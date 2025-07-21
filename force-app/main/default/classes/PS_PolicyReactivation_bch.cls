/**
 * @description       : PS_PolicyReactivation_bch
 * @author            : Pedro Soto
 * @group             : Softtek
 * @last modified on  : 21-07-2025
 * @last modified by  : Pedro Soto
**/
public class PS_PolicyReactivation_bch implements Database.Batchable<sObject>, Database.Stateful {
    public List<PS_ReactivationRequest__c> lstReactReq = new List<PS_ReactivationRequest__c>();
    /**
    * @description start
    * @author      Pedro Soto
    * @date        15/07/2025
    * @return      Database.QueryLocator
    * @param       bc
    */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String processedFlag = 'Unprocessed';
        String qry = 'SELECT Id, Name, isActive, StandardPremiumAmount, StandardFeeAmount, StandardTaxAmount, EffectiveDate, ExpirationDate, CurrencyIsoCode, PS_ApplicationNumber__c, PS_Channel__c, NameInsured.PS_PersonCodeBDG__c, ProductId, ProducerId, Product.vlocity_ins__LineOfBusiness__c, PS_ParentProductCode__c, TotalSumInsured, PremiumFrequency, PS_OperationNumber__c FROM InsurancePolicy WHERE Id IN (SELECT PS_InsurancePolicy__c FROM PS_ReactivationRequest__c WHERE PS_ProcessedFlag__c = :processedFlag)';
        return Database.getQueryLocator(qry);
    }
    /**
    * @description execute
    * @author      Pedro Soto
    * @date        15/07/2025
    * @param       bc
    * @param       policyRcds
    */
    public void execute(Database.BatchableContext bc, List<InsurancePolicy> policyRcds) {
        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listIppsePrev = [SELECT Id, PS_InsurancePolicyVersion__c, vlocity_ins_fsc__PremiumAmount__c, CurrencyIsoCode, PS_InsurancePolicyVersion__r.PS_Currency__c, vlocity_ins_fsc__InsurancePolicyId__r.ProducerId, PS_EffectiveDate__c, PS_Status__c, vlocity_ins_fsc__TotalAmount__c
            FROM vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c Where vlocity_ins_fsc__InsurancePolicyId__c IN : policyRcds];
        Map<String, List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>> mapIppsePrev = new Map<String, List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>>();
        for (vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c ippse : listIppsePrev) {
            if (mapIppsePrev.containsKey(ippse.vlocity_ins_fsc__InsurancePolicyId__c)) {
                List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listIppse = mapIppsePrev.get(ippse.vlocity_ins_fsc__InsurancePolicyId__c);
                listIppse.add(ippse);
                mapIppsePrev.put(ippse.vlocity_ins_fsc__InsurancePolicyId__c, listIppse);
            } else {
                List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listIppse = new List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>();
                listIppse.add(ippse);
                mapIppsePrev.put(ippse.vlocity_ins_fsc__InsurancePolicyId__c, listIppse);
            }
        }
        List<InsurancePolicyTransaction> iptList = new List<InsurancePolicyTransaction>();
        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> ippseList = new List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>();
        List<PS_MassiveRecordCredit__c> massList = new List<PS_MassiveRecordCredit__c>();
        Set<String> productIds = new Set<String>();
        Set<String> producerIds = new Set<String>();
        for (InsurancePolicy policyRcd : policyRcds) {
            PS_ReactivationRequest__c reactReq = new PS_ReactivationRequest__c();
            reactReq.PS_OperationNumber__c = policyRcd.PS_OperationNumber__c;
            reactReq.PS_ProcessedFlag__c = 'Processed';
            lstReactReq.add(reactReq);
            productIds.add(policyRcd.ProductId);
            producerIds.add(policyRcd.ProducerId);
            policyRcd.Status = 'Vigente';
            List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listCp = mapIppsePrev.get(policyRcd.Id);
            Date ultimaAnulada;
            Date ultimaPendiente;
            Date ultimaDevolucion;
            for (vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c cp : listCp) {
                if (cp.PS_Status__c == 'Cobrado' && cp.vlocity_ins_fsc__TotalAmount__c < 0) {
                    if (ultimaDevolucion == null || cp.PS_EffectiveDate__c > ultimaDevolucion) {
                        ultimaDevolucion = cp.PS_EffectiveDate__c;
                    }
                }
                if (cp.PS_Status__c == 'Anulado' || cp.PS_Status__c == 'Pendiente de Anulacion') {
                    if (ultimaPendiente == null || cp.PS_EffectiveDate__c > ultimaPendiente) {
                        ultimaPendiente = cp.PS_EffectiveDate__c;
                    }
                }
            }
            ultimaAnulada = ultimaDevolucion != null ? ultimaDevolucion : ultimaPendiente;
            Integer dayUltimaAnulada = ultimaAnulada.day();
            Integer monthUltimaAnulada = ultimaAnulada.month();
            Integer yearUltimaAnulada = ultimaAnulada.year();
            Date fechaLimite = System.now() > policyRcd.ExpirationDate ? policyRcd.ExpirationDate.date() : System.now().date();
            Integer monthsBetween = ultimaAnulada.monthsBetween(fechaLimite);
            Decimal premiumAmount = policyRcd.StandardPremiumAmount;
            Decimal feeAmount = policyRcd.StandardFeeAmount;
            Decimal taxAmount = policyRcd.StandardTaxAmount;
            List<String> iptAutonumber = PS_AutoNumberGenerator.generateNumberBatchFlow('TransactionAutoNumber', monthsBetween);
            List<String> ippseAutonumber = PS_AutoNumberGenerator.generateNumberBatchFlow('PaymentScheduleAutoNumber', monthsBetween);
            for (Integer idx = 0; idx < monthsBetween; idx++) {
                DateTime newEffectiveDate = DateTime.newInstance(yearUltimaAnulada, monthUltimaAnulada, dayUltimaAnulada, 0, 0, 0).addDays(idx*30);
                if (policyRcd.PremiumFrequency == 'Annually') {
                    newEffectiveDate = DateTime.newInstance(yearUltimaAnulada, monthUltimaAnulada, dayUltimaAnulada, 0, 0, 0).addDays(idx*365);
                } else if (policyRcd.PremiumFrequency == 'Monthly') {
                    newEffectiveDate = DateTime.newInstance(yearUltimaAnulada, monthUltimaAnulada, dayUltimaAnulada, 0, 0, 0).addDays(idx*30);
                } else {
                    newEffectiveDate = DateTime.newInstance(yearUltimaAnulada, monthUltimaAnulada, dayUltimaAnulada, 0, 0, 0).addDays(idx*30);
                }
                if (newEffectiveDate.date() < fechaLimite) {
                    iptList.add(new InsurancePolicyTransaction(
                            PS_NumberOfRenewalsUnchanged__c = idx + 1,
                            PS_TotalRenewals__c = idx + 1,
                            Name = iptAutonumber.get(idx),
                            InsurancePolicyVersionId = policyRcd.Id,
                            InsurancePolicyId = policyRcd.Id,
                            TransactionAmount = premiumAmount,
                            TransactionTaxAmount = taxAmount,
                            TransactionFeeAmount = feeAmount,
                            TransactionEffectiveDate = newEffectiveDate,
                            TransactionPostedDate = system.now(),
                            CurrencyIsoCode = policyRcd.CurrencyIsoCode,
                            Type = 'Renewal'
                            )
                        );
                    vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c ippse = new vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c();
                    ippse.Name = ippseAutonumber.get(idx);
                    ippse.vlocity_ins_fsc__PremiumAmount__c = premiumAmount;
                    ippse.vlocity_ins_fsc__FeeAmount__c = feeAmount;
                    ippse.vlocity_ins_fsc__TaxAmount__c = taxAmount;
                    if (policyRcd.PremiumFrequency == 'Annually ') {
                        ippse.vlocity_ins_fsc__ScheduleDate__c = newEffectiveDate.date();
                        ippse.PS_EffectiveDate__c = newEffectiveDate.date();
                        ippse.PS_ExpirationDate__c = newEffectiveDate.date().addDays(365);
                    } else if (policyRcd.PremiumFrequency == 'Monthly ') {
                        ippse.vlocity_ins_fsc__ScheduleDate__c = newEffectiveDate.date();
                        ippse.PS_EffectiveDate__c = newEffectiveDate.date();
                        ippse.PS_ExpirationDate__c = newEffectiveDate.date().addDays(30);
                    } else {
                        ippse.vlocity_ins_fsc__ScheduleDate__c = newEffectiveDate.date();
                        ippse.PS_EffectiveDate__c = newEffectiveDate.date();
                        ippse.PS_ExpirationDate__c = newEffectiveDate.date().addDays(30);
                    }
                    ippse.vlocity_ins_fsc__ScheduleDate__c = newEffectiveDate.date();
                    ippse.CurrencyIsoCode = policyRcd.CurrencyIsoCode;
                    ippse.PS_InsurancePolicyVersion__c = policyRcd.Id;
                    ippse.vlocity_ins_fsc__InsurancePolicyId__c = policyRcd.Id;
                    ippse.PS_Status__c = 'Enviado a Cobranzas ';
                    ippse.PS_PrimeType__c = 'PRI ';
                    ippseList.add(ippse);
                    massList.add(new PS_MassiveRecordCredit__c(
                            PS_PolicyNumber__c = policyRcd.Name,
                            PS_DocumentNumber__c    = ippse.Name,
                            PS_FeeAmount__c     = ippse.vlocity_ins_fsc__FeeAmount__c,
                            PS_PremiumAmount__c = ippse.vlocity_ins_fsc__PremiumAmount__c,
                            PS_TaxAmount__c     = ippse.vlocity_ins_fsc__TaxAmount__c,
                            PS_CreatedBy__c  =  'Salesforce ',
                            PS_CreatedDate__c  =  DateTime.newInstance(2025, 12, 31, 15, 30, 0),
                            PS_DocumentType__c  =  'PRI ',
                            PS_ApplicationNumber__c  =  policyRcd.PS_ApplicationNumber__c,
                            PS_VoucherType__c  =  'BOL ',
                            CurrencyIsoCode  =  ippse.CurrencyIsoCode,
                            PS_CurrencyCode__c  =  ippse.CurrencyIsoCode,
                            PS_EmissionArea__c  =  'PM ',
                            PS_ProductCode__c  =  policyRcd.PS_ParentProductCode__c,
                            PS_BusinessLine__c  =  policyRcd.Product.vlocity_ins__LineOfBusiness__c,
                            PS_ContractCode__c  =  policyRcd.NameInsured.PS_PersonCodeBDG__c,
                            PS_InsuredCode__c  =  policyRcd.NameInsured.PS_PersonCodeBDG__c,
                            PS_AdvisorCode__c  =  policyRcd.PS_Channel__c,
                            PS_AgentCode__c  =   policyRcd.PS_Channel__c,
                            PS_InterestAmount__c  =  0,
                            PS_BlockedSend__c  =  ' 0 ',
                            PS_CashDay__c  =  ' 1',
                            PS_AdvanceBilling__c  =  '0',
                            PS_TaxReceiptWithoutIGV__c  =  '0',
                            PS_SumAssured__c  =  policyRcd.TotalSumInsured
                            )
                        );
                }
            }
        }
        List<Database.SaveResult> iptResults = database.insert(iptList, false);
        List<Database.SaveResult> ippseResults = database.insert(ippseList, false);
        Database.update(policyRcds, false);
        Database.update(massList, false);
        Set<String> idsIppse = new Set<String>();
        List<ProducerCommission> pcList = new List<ProducerCommission>();
        for (Database.SaveResult ippseResult : ippseResults) {
            idsIppse.add(ippseResult.getId());
        }
        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listIppse = [SELECT Id, PS_InsurancePolicyVersion__c, vlocity_ins_fsc__PremiumAmount__c, CurrencyIsoCode, PS_InsurancePolicyVersion__r.PS_Currency__c, vlocity_ins_fsc__InsurancePolicyId__r.ProducerId, vlocity_ins_fsc__InsurancePolicyId__r.Producer.PS_ProducerAccountingCode__c, PS_ProductCode__c FROM vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c Where Id IN : idsIppse];
        List<CommissionScheduleAssignment> assignmentLst = [SELECT Id, PS_CommissionPercentage__c, PS_SpecificCommissionPercentage__c, PS_Type__c, CommissionableEventType,
            Product2.ProductCode, Producer.PS_ProducerAccountingCode__c
            FROM CommissionScheduleAssignment WHERE Product2Id IN : productIds AND ProducerId IN : producerIds];
        //
        Map<String, List<CommissionScheduleAssignment>> mapCommAssgg = new Map<String, List<CommissionScheduleAssignment>>();
        for (CommissionScheduleAssignment cschAssign : assignmentLst) {
            String identifier = cschAssign.Product2.ProductCode + cschAssign.Producer.PS_ProducerAccountingCode__c;
            if (!mapCommAssgg.containsKey(identifier)) {
                List<CommissionScheduleAssignment> listTmp = new List<CommissionScheduleAssignment>();
                listTmp.add(cschAssign);
                mapCommAssgg.put(identifier, listTmp);
            } else {
                List<CommissionScheduleAssignment> listTmp = mapCommAssgg.get(identifier);
                listTmp.add(cschAssign);
                mapCommAssgg.put(identifier, listTmp);
            }
        }
        Integer internalCounter = 0;
        Integer internalAutonumber = 0;
        List<String> pcAutonumber = PS_AutoNumberGenerator.generateNumberBatchFlow('CommisionAutoNumber', listIppse.size()*2);
        for (vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c ippse : listIppse) {
            String identifier = ippse.PS_ProductCode__c + ippse.vlocity_ins_fsc__InsurancePolicyId__r.Producer.PS_ProducerAccountingCode__c;
            List<CommissionScheduleAssignment> assignmentLstPr = mapCommAssgg.get(identifier);
            for (CommissionScheduleAssignment assignmenPr : assignmentLstPr) {
                Double recordSpecificPercentage = assignmenPr.PS_SpecificCommissionPercentage__c;
                Double recordPercentage = assignmenPr.PS_CommissionPercentage__c;
                pcList.add(new ProducerCommission(
                        Name = pcAutonumber.get(internalAutonumber),
                        Type = assignmenPr.PS_Type__c,
                        InsurancePolicyTransactionId = iptResults.get(internalCounter).getId(),
                        InsurancePolicyId = ippse.PS_InsurancePolicyVersion__c,
                        PS_RelatedPaymentScheduleEntry__c = ippse.Id,
                        CommissionAmount = calculateCommissionAmount(ippse.vlocity_ins_fsc__PremiumAmount__c, recordPercentage, recordSpecificPercentage),
                        CurrencyIsoCode = ippse.CurrencyIsoCode,
                        PS_CurrencyCode__c = ippse.PS_InsurancePolicyVersion__r.PS_Currency__c,
                        PS_MovementSubType__c = '002',
                        PS_MovementCreationDate__c = system.now(),
                        ProducerId = ippse.vlocity_ins_fsc__InsurancePolicyId__r.ProducerId,
                        Status = 'Pendiente'
                        ));
                internalAutonumber++;
            }
            internalCounter++;
        }
        Database.insert(pcList, false);
    }
    /**
    * @description finish
    * @author      Pedro Soto
    * @date        15/07/2025
    * @param       bc
    */
    public void finish(Database.BatchableContext bc) {
        //Database.executeBatch(new PS_PolicyReactivation_bch(), 200);
        System.debug(lstReactReq);
        upsert lstReactReq PS_OperationNumber__c;
    }
    /**
    * @description calculateCommissionAmount
    * @author      Pedro Soto
    * @date        15/07/2025
    * @return      Double
    * @param       amount
    * @param       commPercentage
    * @param       spcCommPercentage
    */
    public static Double calculateCommissionAmount(Decimal amount, Decimal commPercentage, Decimal spcCommPercentage) {
        Double commissionAmount = amount*(commPercentage/100)*(spcCommPercentage/100);
        return commissionAmount;
    }
}