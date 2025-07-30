global with sharing class PS_GenerateScheduleEntries implements vlocity_ins.VlocityOpenInterface {

    PUBLIC STATIC FINAL STRING TRANSACTIONTYPE = 'Sold Policy';

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
		if(methodName == 'generateScheduleEntries') {
            generateScheduleEntries(inputMap, outMap, options);
		}
        return true;
	}

    public void generateScheduleEntries(Map<String, Object> inputMap, Map<String, Object> outMap,Map<String, Object> options) {
        String policyId = (String)inputMap.get('insurancePolicyId');
        System.debug('policyId'+ policyId); 
        InsurancePolicy policy =[
            SELECT Id, CurrencyIsoCode,
            EffectiveDate,
            ExpirationDate,
            StandardPremiumAmount,
            StandardFeeAmount,
            StandardTaxAmount,
            ProductId,
            PS_Currency__c
            FROM InsurancePolicy
            WHERE Id = :policyId
            LIMIT 1
        ];

        CommissionScheduleAssignment commissionAssignments = [
            SELECT ProducerId, PS_Type__c, PS_CommissionPercentage__c, PS_SpecificCommissionPercentage__c, Product2Id, PS_PercentageTotal__c
            FROM CommissionScheduleAssignment
            WHERE Product2Id = :policy.ProductId
            LIMIT 1
        ];
        System.debug('querypolicy'+ policy);
        System.debug('assign query'+ commissionAssignments);
        Map<String, Object> inputMapDates = new Map<String, Object>();
        inputMapDates.put('EffectiveDate', policy.EffectiveDate);
        inputMapDates.put('ExpirationDate', policy.ExpirationDate);
        System.debug('inputmapdates'+ inputMapDates);
        List<Map<String, DateTime>> monthsToRenew = getMonthsToRenew(inputMapDates);
        System.debug('monthstorenew'+ monthsToRenew);
        List<InsurancePolicyTransaction> transactionInsertList = new List<InsurancePolicyTransaction>();
        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> entryInsertList = new List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>();
        List<ProducerCommission> commissionInsertList = new List<ProducerCommission>();


        for (Map<String, DateTime> month : monthsToRenew) {
            System.debug('entra al for de transacciones');
            DateTime monthStart = month.get('EffectiveDate');
            DateTime monthEnd = month.get('ExpirationDate');

            //TODO: 1 TRANSSACION   todos los montos se sacan de la poliza y fechas
            InsurancePolicyTransaction transactionRcd = new InsurancePolicyTransaction(
                CurrencyIsoCode                   = policy.CurrencyIsoCode,
                InsurancePolicyId                 = policy.Id,
                TransactionEffectiveDate          = monthStart,
                TransactionPostedDate             = Date.today(),
                PS_CurrentPeriodEffectiveDate__c  = monthStart.date(),
                PS_CurrentPeriodExpirationDate__c = monthEnd.date(),
                TransactionAmount                 = policy.StandardPremiumAmount,
                TransactionFeeAmount              = policy.StandardFeeAmount,
                TransactionTaxAmount              = policy.StandardTaxAmount,
                Name                              = generateSafeAutoNumber('TransactionAutoNumber'),
                Type                              = TRANSACTIONTYPE
            );
            transactionInsertList.add(transactionRcd);
            System.debug('list transacciones'+ transactionInsertList);
        }

        insert transactionInsertList;
        
        Integer index = 0;
        for (Map<String, DateTime> month : monthsToRenew) {
            System.debug('entra al for de liquidaciones');
            DateTime monthStart = month.get('EffectiveDate');
            DateTime monthEnd = month.get('ExpirationDate');
            InsurancePolicyTransaction relatedTransaction = transactionInsertList[index];

            // TODO: 2 GENERAR LIQUIDACION
            vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c entryRcd = new vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c(
                    Name                                    = generateSafeAutoNumber('PaymentScheduleAutoNumber'),
                    CurrencyIsoCode                         = policy.CurrencyIsoCode,
                    vlocity_ins_fsc__PremiumAmount__c       = policy.StandardPremiumAmount,
                    vlocity_ins_fsc__TaxAmount__c           = policy.StandardTaxAmount,
                    vlocity_ins_fsc__FeeAmount__c           = policy.StandardFeeAmount,
                    vlocity_ins_fsc__InsurancePolicyId__c   = policy.Id,
                    PS_PrimeType__c                         = 'PRI',
                    PS_EffectiveDate__c                     = monthStart.date(),
                    PS_ExpirationDate__c                    = monthEnd.date(),
                    vlocity_ins_fsc__ScheduleDate__c        = monthStart.date(),
                    PS_Status__c                            = 'Procesado',
                    Related_Insurance_Policy_Transaction__c = relatedTransaction.Id
                );
            entryInsertList.add(entryRcd);
            index++;
            System.debug('list liquid'+ entryInsertList);
        }

        insert entryInsertList;

        System.debug('sale del for de liquidaciones');
        Integer indexCommissions = 0;

        for (Map<String, DateTime> month : monthsToRenew) {
            System.debug('entra del for de comis');
            InsurancePolicyTransaction trans = transactionInsertList[indexCommissions];
            System.debug('trans list' + trans);
            vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c entry = entryInsertList[indexCommissions];
            System.debug('entry list' + entry);
            ProducerCommission commissionRcd = new ProducerCommission();
            commissionRcd.CommissionAmount                  = calculateCommissionAmount(trans.TransactionAmount, commissionAssignments.PS_CommissionPercentage__c, commissionAssignments.PS_SpecificCommissionPercentage__c);
            commissionRcd.CurrencyIsoCode                   = policy.CurrencyIsoCode;
            commissionRcd.InsurancePolicyId                 = policy.Id;
            commissionRcd.Name                              = generateSafeAutoNumber('CommisionAutoNumber');
            commissionRcd.PS_CurrencyCode__c                = policy.PS_Currency__c;
            commissionRcd.PS_MovementSubType__c             = '002'; //to do consultar
            commissionRcd.PS_MovementCreationDate__c        = system.now();
            commissionRcd.ProducerId                        = commissionAssignments.ProducerId;
            commissionRcd.Status                            = 'Pendiente';
            commissionRcd.Type                              = commissionAssignments.PS_Type__c;
            commissionRcd.PS_RelatedPaymentScheduleEntry__c = entry.Id;
            commissionRcd.InsurancePolicyTransactionId      = trans.Id;

            commissionInsertList.add(commissionRcd);
            indexCommissions++;
        }
        insert commissionInsertList;
    }

    private static String generateSafeAutoNumber(String type) {
        if (Test.isRunningTest()) {
            return type + '-TEST-' + String.valueOf(Math.mod(Crypto.getRandomInteger(), 10000));
        }
        return PS_AutoNumberGenerator.generateNumber(type);
    }

    /**
    * @description método que obtiene los meses para renovar
    * @param inputMap
    * @param outMap
    * @param options
    **/
    public static List<Map<String, DateTime>> getMonthsToRenew(Map<String, Object> inputMap) {
        Datetime effectiveDate = Datetime.valueOf(String.valueOf(inputMap.get('EffectiveDate')).replace('T', ' '));//(Datetime)inputMap.get('expirationDate');//inicio
        Datetime expirationDate = Datetime.valueOf(String.valueOf(inputMap.get('ExpirationDate')).replace('T', ' '));//(Datetime)inputMap.get('reinstatementDate');//fin
        //Datetime effectiveDate = expirationDate;//.addDays(1);
        List<Map<String, Datetime>> monthsToRenews = new List<Map<String, Datetime>>();
        Integer counter = 1;
        while (expirationDate >= effectiveDate) {
            if (counter == 1) {
                effectiveDate = effectiveDate;
            }
            Map<String, Datetime> monthMap = new Map<String, Datetime>();
            monthMap.put('EffectiveDate', effectiveDate);
            effectiveDate = effectiveDate.addMonths(1);
            monthMap.put('ExpirationDate', effectiveDate.adddays(-1));
            monthsToRenews.add(monthMap);
            counter++;
        }
        return monthsToRenews;
    }

    private static Decimal calculateCommissionAmount(Decimal standardPremiumAmount, Decimal commissionPercentage, Decimal specificCommissionPercentage) {
        System.debug('entra al metodo de calculo');
        System.debug('entra al metodo de calculo'+ standardPremiumAmount);
        System.debug('entra al metodo de calculo'+ commissionPercentage);
        System.debug('entra al metodo de calculo'+ specificCommissionPercentage);
        if (standardPremiumAmount == null || commissionPercentage == null || specificCommissionPercentage == null) {
            return 0;
        }
        return standardPremiumAmount * (commissionPercentage / 100) * (specificCommissionPercentage / 100);
    }
    
}