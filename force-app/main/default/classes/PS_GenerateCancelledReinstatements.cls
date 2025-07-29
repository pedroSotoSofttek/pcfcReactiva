global class PS_GenerateCancelledReinstatements implements vlocity_ins.VlocityOpenInterface {
    global Boolean invokeMethod(
        String methodName,
        Map<String, Object> inputMap,
        Map<String, Object> outMap,
        Map<String, Object> options
    ) {
        if (methodName == 'getTransactionSchedule') {
            system.debug('entra al metodo');
            getTransactionSchedule(inputMap, outMap, options);
        } else if (methodName == 'generateReinstatements') {
            generateReinstatements((Map<String, List<Map<String, Object>>>) inputMap.get('responseMap'), inputMap);
        }
        return true;
    }

    public void getTransactionSchedule(
        Map<String, Object> inputMap,
        Map<String, Object> outMap,
        Map<String, Object> options
    ) {
        String policyId = (String) inputMap.get('insurancePolicyId'); //Id de la póliza
        Boolean generateReinstatement = (Boolean) inputMap.get('GenerateScheduleLists'); //Genera Reinstatement?

        system.debug('policyId ' + policyId);
        system.debug('Boolean generateReinstatement ' + generateReinstatement);

        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> PaymentEntriesToEvaluate = [
            SELECT
                Id,
                Name,
                PS_Status__c,
                vlocity_ins_fsc__InsPolicyTransactionId__c,
                vlocity_ins_fsc__PremiumAmount__c,
                vlocity_ins_fsc__FeeAmount__c,
                vlocity_ins_fsc__TaxAmount__c,
                vlocity_ins_fsc__TotalAmount__c,
                CurrencyIsoCode,
                PS_InsurancePolicyVersion__c,
                PS_InsurancePolicyVersion__r.PS_PolicyCommissionPercentage__c,
                vlocity_ins_fsc__InsurancePolicyId__c,
                PS_InsurancePolicyVersion__r.ProducerId,
                PS_InsurancePolicyVersion__r.PS_Currency__c,
                PS_EffectiveDate__c,
                PS_ExpirationDate__c,
                vlocity_ins_fsc__ScheduleDate__c,
                Related_Insurance_Policy_Transaction__c,
                Related_Insurance_Policy_Transaction__r.Name,
                Related_Insurance_Policy_Transaction__r.TransactionAmount,
                Related_Insurance_Policy_Transaction__r.TransactionFeeAmount,
                Related_Insurance_Policy_Transaction__r.TransactionTaxAmount,
                Related_Insurance_Policy_Transaction__r.TransactionEffectiveDate,
                Related_Insurance_Policy_Transaction__r.PS_CurrentPeriodEffectiveDate__c,
                Related_Insurance_Policy_Transaction__r.PS_CurrentPeriodExpirationDate__c,
                PS_InsurancePolicyVersion__r.StandardPremiumAmount,
                PS_InsurancePolicyVersion__r.StandardTaxAmount,
                PS_InsurancePolicyVersion__r.StandardFeeAmount
            FROM vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c
            WHERE
                (Related_Insurance_Policy_Transaction__r.Type = 'Cancellation'
                OR PS_Status__c IN ('Pendiente de Anulacion', 'Anulado', 'Enviado a Cobranzas'))
                AND vlocity_ins_fsc__InsurancePolicyId__c = :policyId
        ];

        //Lista general y listas de tipos de Liquidacion
        Map<String, List<Map<String, Object>>> responseMap = new Map<String, List<Map<String, Object>>>();
        List<Map<String, Object>> obligationList = new List<Map<String, Object>>();
        List<Map<String, Object>> cancellationListPRI = new List<Map<String, Object>>();
        List<Map<String, Object>> creditList = new List<Map<String, Object>>();
        List<Map<String, Object>> cancellationListEND = new List<Map<String, Object>>();

        // Generar Listas de SchTransac
        system.debug('PaymentEntriesToEvaluate' + PaymentEntriesToEvaluate);
        for (vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c entry : PaymentEntriesToEvaluate) {
            Decimal igvTransaction = entry.Related_Insurance_Policy_Transaction__r.TransactionTaxAmount != null
                ? entry.Related_Insurance_Policy_Transaction__r.TransactionTaxAmount
                : 0;
            Decimal emissionRightTransaction = entry.Related_Insurance_Policy_Transaction__r.TransactionFeeAmount !=
                null
                ? entry.Related_Insurance_Policy_Transaction__r.TransactionFeeAmount
                : 0;
            Decimal igv = entry.vlocity_ins_fsc__TaxAmount__c != null ? entry.vlocity_ins_fsc__TaxAmount__c : 0;
            Decimal emissionRight = entry.vlocity_ins_fsc__FeeAmount__c != null
                ? entry.vlocity_ins_fsc__FeeAmount__c
                : 0;

            Map<String, Object> mapSchedTransc = new Map<String, Object>();
            mapSchedTransc.put('TransactionTotalAmount', entry.vlocity_ins_fsc__TotalAmount__c);
            mapSchedTransc.put('ScheduleEntryExpirationDate', entry.PS_ExpirationDate__c);
            mapSchedTransc.put('ScheduleEntryEffectiveDate', entry.PS_EffectiveDate__c);
            mapSchedTransc.put('SchedulePremiumAmount', entry.vlocity_ins_fsc__PremiumAmount__c);
            mapSchedTransc.put('ScheduleFeeAmount', emissionRight);
            mapSchedTransc.put('ScheduleEntryStatus', entry.PS_Status__c);
            mapSchedTransc.put('ScheduleTaxAmount', igv);
            mapSchedTransc.put('ScheduleId', entry.Id);
            mapSchedTransc.put('TransactionFeeAmount', emissionRightTransaction);
            mapSchedTransc.put(
                'RelatedTransactionExpirationDate',
                entry.Related_Insurance_Policy_Transaction__r.TransactionEffectiveDate
            );
            mapSchedTransc.put(
                'TransactionExpirationDate',
                entry.Related_Insurance_Policy_Transaction__r.PS_CurrentPeriodExpirationDate__c
            );
            mapSchedTransc.put(
                'TransactionEffectiveDate',
                entry.Related_Insurance_Policy_Transaction__r.PS_CurrentPeriodEffectiveDate__c
            );
            mapSchedTransc.put('TransactionAmount', entry.Related_Insurance_Policy_Transaction__r.TransactionAmount);
            mapSchedTransc.put('TransactionId', entry.Related_Insurance_Policy_Transaction__c);
            mapSchedTransc.put('TransactionTaxAmount', igvTransaction);
            system.debug('mapSchedTransc' + mapSchedTransc);

            /*             if (
                (entry.PS_Status__c == 'Cobrado' &&
                entry.vlocity_ins_fsc__PremiumAmount__c <= 0) ||
                entry.PS_Status__c == 'Anulado' ||
                entry.PS_Status__c == 'Pendiente de Anulacion'
            ) {
                creditList.add(mapSchedTransc);
            } else if (
                (entry.PS_Status__c == 'Enviado a Cobranzas' ||
                entry.PS_Status__c == 'Procesado' ||
                entry.PS_Status__c == 'Error cobro') && entry.vlocity_ins_fsc__PremiumAmount__c >= 0
            ) {
                cancellationListPRI.add(mapSchedTransc);
            } else if (
                (entry.PS_Status__c == 'Enviado a Cobranzas' ||
                entry.PS_Status__c == 'Procesado' ||
                entry.PS_Status__c == 'Error cobro') && entry.vlocity_ins_fsc__PremiumAmount__c <= 0
            ) {
                cancellationListEND.add(mapSchedTransc);
            } else if (entry.PS_Status__c == 'Cobrado' && entry.vlocity_ins_fsc__PremiumAmount__c >= 0) {
                obligationList.add(mapSchedTransc);
            } */

            // Extraer condiciones a variables descriptivas
            String status = entry.PS_Status__c;
            Decimal premium = entry.vlocity_ins_fsc__PremiumAmount__c;

            Boolean isNegativePremium = premium <= 0;
            Boolean isPositivePremium = premium >= 0;

            Boolean isCobrado = status == 'Cobrado';
            Boolean isAnulado = status == 'Anulado';
            Boolean isPendienteAnulacion = status == 'Pendiente de Anulacion';
            Boolean isEnviadoCobranzas = status == 'Enviado a Cobranzas';
            Boolean isProcesado = status == 'Procesado';
            Boolean isErrorCobro = status == 'Error cobro';

            Boolean isEstadoCobranza = isEnviadoCobranzas || isProcesado || isErrorCobro;

            // Clasificación
            if ((isCobrado && isNegativePremium) || isAnulado || isPendienteAnulacion) {
                creditList.add(mapSchedTransc);
            } else if (isEstadoCobranza && isPositivePremium) {
                cancellationListPRI.add(mapSchedTransc);
            } else if (isEstadoCobranza && isNegativePremium) {
                cancellationListEND.add(mapSchedTransc);
            }
            /*
            else if (isCobrado && isPositivePremium) {
                obligationList.add(mapSchedTransc);
            } */
        }
        //Llenar Mapa de respuesta
        responseMap.put('credit', creditList);
        responseMap.put('obligation', obligationList);
        responseMap.put('cancellationPRI', cancellationListPRI);
        responseMap.put('cancellationEND', cancellationListEND);
        system.debug('responseMap' + responseMap);
        if (generateReinstatement) {
            generateReinstatements(responseMap, inputMap);
            outMap.put('output', responseMap);
        } else {
            outMap.put('output', responseMap);
        }
    }

    public void generateReinstatements(
        Map<String, List<Map<String, Object>>> responseMap,
        Map<String, Object> inputMap
    ) {
        Decimal policyPremiumAmmount = (Decimal) inputMap.get('PolicyPremium'); //Premium de la poliza
        String currencyISO = (String) inputMap.get('CurrencyISO'); //ISO de la moneda
        Boolean isPaid = (Boolean) inputMap.get('IsPaid'); //Esta pagado?
        String OldPolicyId = (String) inputMap.get('OldPolicyId'); //Poliza Original
        String ReinstatementDate = (String) inputMap.get('ReinstatementDate'); //Fecha de rehabilitacion
        String policyIdVersion = (String) inputMap.get('insurancePolicyId');

        //Generar Acreencias
        if (!responseMap.get('credit').isEmpty()) {
            for (Map<String, Object> schedTransacEntry : responseMap.get('credit')) {
                schedTransacEntry.put('currency', currencyISO);
                schedTransacEntry.put('isReturn', false);
                schedTransacEntry.put('policyId', OldPolicyId);
                schedTransacEntry.put('policyVersionId', policyIdVersion);
                schedTransacEntry.put('setEffectiveDate', schedTransacEntry.get('RelatedTransactionExpirationDate'));
                schedTransacEntry.put('setTransactionEffectiveDate', schedTransacEntry.get('TransactionEffectiveDate'));
                schedTransacEntry.put(
                    'setTransactionExpirationDate',
                    schedTransacEntry.get('TransactionExpirationDate')
                );
                schedTransacEntry.put(
                    'transactionStandardFeeAmount',
                    math.abs((Decimal) schedTransacEntry.get('TransactionFeeAmount'))
                );
                schedTransacEntry.put(
                    'transactionStandardTaxAmount',
                    math.abs((Decimal) schedTransacEntry.get('TransactionTaxAmount'))
                );
                schedTransacEntry.put(
                    'transactionAmount',
                    math.abs((Decimal) schedTransacEntry.get('TransactionAmount'))
                );
                schedTransacEntry.put(
                    'transactionName',
                    PS_AutoNumberGenerator.generateNumber('TransactionAutoNumber')
                );
                schedTransacEntry.put('transactionPostedDate', ReinstatementDate);
                schedTransacEntry.put('type', 'Reinstatement');

                schedTransacEntry.put('effectiveDate', schedTransacEntry.get('ScheduleEntryEffectiveDate'));
                schedTransacEntry.put('expirationDate', schedTransacEntry.get('ScheduleEntryExpirationDate'));
                schedTransacEntry.put('name', PS_AutoNumberGenerator.generateNumber('PaymentScheduleAutoNumber'));
                schedTransacEntry.put('primeType', 'PRI');
                schedTransacEntry.put('status', 'Pendiente');
                schedTransacEntry.put('transactionEffectiveDate', schedTransacEntry.get('TransactionEffectiveDate'));
                schedTransacEntry.put('transactionExpirationDate', schedTransacEntry.get('TransactionExpirationDate'));
                schedTransacEntry.put(
                    'scheduleAmount',
                    math.abs((Decimal) schedTransacEntry.get('SchedulePremiumAmount'))
                );
                schedTransacEntry.put('scheduleDate', ReinstatementDate);
                schedTransacEntry.put(
                    'scheduleStandardFeeAmount',
                    math.abs((Decimal) schedTransacEntry.get('ScheduleFeeAmount'))
                );
                schedTransacEntry.put(
                    'scheduleStandardTaxAmount',
                    math.abs((Decimal) schedTransacEntry.get('ScheduleTaxAmount'))
                );
            }
        }
        if (!responseMap.get('cancellationPRI').isEmpty()) {
            for (Map<String, Object> schedTransacEntry : responseMap.get('cancellationPRI')) {
                schedTransacEntry.put('StandardFeeAmount', (Decimal) schedTransacEntry.get('ScheduleFeeAmount') * -1);
                schedTransacEntry.put('StandardTaxAmount', (Decimal) schedTransacEntry.get('ScheduleTaxAmount') * -1);
                schedTransacEntry.put('amount', (Decimal) schedTransacEntry.get('SchedulePremiumAmount') * -1);
                schedTransacEntry.put('type', 'Cancellation');
                schedTransacEntry.put('setEffectiveDate', schedTransacEntry.get('RelatedTransactionExpirationDate'));
                schedTransacEntry.put('setTransactionEffectiveDate', schedTransacEntry.get('TransactionEffectiveDate'));
                schedTransacEntry.put(
                    'setTransactionExpirationDate',
                    schedTransacEntry.get('TransactionExpirationDate')
                );
                schedTransacEntry.put(
                    'transactionName',
                    PS_AutoNumberGenerator.generateNumber('TransactionAutoNumber')
                );
                schedTransacEntry.put('ParentTransactionId', schedTransacEntry.get('TransactionId'));
                schedTransacEntry.put('currency', currencyISO);
                schedTransacEntry.put('policyId', OldPolicyId);
                schedTransacEntry.put('policyVersionId', policyIdVersion);
                schedTransacEntry.put('newPolicyVersion', policyIdVersion);
                schedTransacEntry.put('scheduleDate', ReinstatementDate);
                schedTransacEntry.put('transactionPostedDate', ReinstatementDate);
                schedTransacEntry.put('primeType', 'PRI');
            }
        }
        if (!responseMap.get('cancellationEND').isEmpty()) {
            for (Map<String, Object> schedTransacEntry : responseMap.get('cancellationEND')) {
                schedTransacEntry.put(
                    'StandardFeeAmount',
                    (Decimal) schedTransacEntry.get('TransactionFeeAmount') * -1
                );
                schedTransacEntry.put(
                    'StandardTaxAmount',
                    (Decimal) schedTransacEntry.get('TransactionTaxAmount') * -1
                );
                schedTransacEntry.put('amount', (Decimal) schedTransacEntry.get('TransactionAmount') * -1);
                schedTransacEntry.put('type', 'Reinstatement');
                schedTransacEntry.put('setEffectiveDate', schedTransacEntry.get('RelatedTransactionExpirationDate'));
                schedTransacEntry.put('setTransactionEffectiveDate', schedTransacEntry.get('TransactionEffectiveDate'));
                schedTransacEntry.put(
                    'setTransactionExpirationDate',
                    schedTransacEntry.get('TransactionExpirationDate')
                );
                schedTransacEntry.put(
                    'transactionName',
                    PS_AutoNumberGenerator.generateNumber('TransactionAutoNumber')
                );
                schedTransacEntry.put('ParentTransactionId', schedTransacEntry.get('TransactionId'));
                schedTransacEntry.put('currency', currencyISO);
                schedTransacEntry.put('policyId', OldPolicyId);
                schedTransacEntry.put('policyVersionId', policyIdVersion);
                schedTransacEntry.put('newPolicyVersion', policyIdVersion);
                schedTransacEntry.put('scheduleDate', ReinstatementDate);
                schedTransacEntry.put('transactionPostedDate', ReinstatementDate);
                schedTransacEntry.put('primeType', 'END');
            }
        }

/*         if (!responseMap.get('obligation').isEmpty()) {
            for (Map<String, Object> schedTransacEntry : responseMap.get('obligation')) {
                schedTransacEntry.put('currency', currencyISO);
                schedTransacEntry.put('newPolicyVersion', policyIdVersion);
                schedTransacEntry.put('policyId', OldPolicyId);
                schedTransacEntry.put('policyVersionId', policyIdVersion);
                schedTransacEntry.put('setEffectiveDate', schedTransacEntry.get('RelatedTransactionExpirationDate'));
                schedTransacEntry.put('setTransactionEffectiveDate', schedTransacEntry.get('TransactionEffectiveDate'));
                schedTransacEntry.put(
                    'setTransactionExpirationDate',
                    schedTransacEntry.get('TransactionExpirationDate')
                );
                schedTransacEntry.put(
                    'transactionAmount',
                    (Decimal) schedTransacEntry.get('SchedulePremiumAmount') * -1
                );
                schedTransacEntry.put(
                    'transactionName',
                    PS_AutoNumberGenerator.generateNumber('TransactionAutoNumber')
                );
                schedTransacEntry.put('transactionPostedDate', ReinstatementDate);
                schedTransacEntry.put(
                    'transactionStandardFeeAmount',
                    (Decimal) schedTransacEntry.get('ScheduleFeeAmount') * -1
                );
                schedTransacEntry.put(
                    'transactionStandardTaxAmount',
                    (Decimal) schedTransacEntry.get('ScheduleTaxAmount') * -1
                );
                schedTransacEntry.put('type', 'Reinstatement');
                schedTransacEntry.put('isReturn', true);

                schedTransacEntry.put('effectiveDate', schedTransacEntry.get('ScheduleEntryEffectiveDate'));
                schedTransacEntry.put('expirationDate', schedTransacEntry.get('ScheduleEntryExpirationDate'));
                schedTransacEntry.put('expirationDate', schedTransacEntry.get('ScheduleEntryExpirationDate'));
                schedTransacEntry.put('name', PS_AutoNumberGenerator.generateNumber('PaymentScheduleAutoNumber'));
                schedTransacEntry.put('primeType', 'END');
                schedTransacEntry.put('status', 'Pendiente');
                schedTransacEntry.put('scheduleAmount', (Decimal) schedTransacEntry.get('SchedulePremiumAmount') * -1);
                schedTransacEntry.put('scheduleDate', ReinstatementDate);
                schedTransacEntry.put(
                    'scheduleStandardFeeAmount',
                    (Decimal) schedTransacEntry.get('ScheduleFeeAmount') * -1
                );
                schedTransacEntry.put(
                    'scheduleStandardTaxAmount',
                    (Decimal) schedTransacEntry.get('ScheduleTaxAmount') * -1
                );
            }
        } */
    }
}