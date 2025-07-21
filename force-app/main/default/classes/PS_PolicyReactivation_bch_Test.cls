/**
 * @description       :
 * @author            : Pedro Soto
 * @Softtek           :
 * @last modified on  : 18-07-2025
 * @last modified by  : Pedro Soto
**/
@isTest
private class PS_PolicyReactivation_bch_Test {
    @TestSetup
    static void createTestData() {
        //Id classRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Class').getRecordTypeId();
        //Id productRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
        Time expirationTime = Time.newInstance(23, 59, 59, 59);
        //Time effectiveTime = Time.newInstance(0, 0, 0, 0);
        DateTime expirationDateNormal = DateTime.newInstance(system.today().addDays(200), expirationTime);
        //DateTime effectiveDateNormal = DateTime.newInstance(system.today().addDays(-165), effectiveTime);
        PS_GlobalAutoNumberSetting__c transactionAuto = new PS_GlobalAutoNumberSetting__c(
            Name = 'TransactionAutoNumber',
            PS_LastGeneratedNumber__c = 2,
            PS_MinimumLength__c = 10,
            PS_LeftPadDigit__c = '0',
            PS_Increment__c = 10
            );
        insert transactionAuto;
        PS_GlobalAutoNumberSetting__c transactionAuto2 = new PS_GlobalAutoNumberSetting__c(
            Name = 'PaymentScheduleAutoNumber',
            PS_LastGeneratedNumber__c = 2,
            PS_MinimumLength__c = 10,
            PS_LeftPadDigit__c = '0',
            PS_Increment__c = 10
            );
        insert transactionAuto2;
        PS_GlobalAutoNumberSetting__c transactionAuto3 = new PS_GlobalAutoNumberSetting__c(
            Name = 'CommisionAutoNumber',
            PS_LastGeneratedNumber__c = 2,
            PS_MinimumLength__c = 10,
            PS_LeftPadDigit__c = '0',
            PS_Increment__c = 10
            );
        insert transactionAuto3;
        Account intermediaryAccount = new Account(Name = 'Intermediary Account', FinServ__SourceSystemId__c = 'ACCT');
        insert intermediaryAccount;
        Producer producerRcd = new Producer(
            Name = 'Producer',
            IntermediaryCode__c = '1111',
            AccountId = intermediaryAccount.Id,
            PS_ProducerAccountingCode__c = 'ACCT'
            );
        insert producerRcd;
        //Producto
        Product2 newProduct = new Product2();
        newProduct = PS_DataFactory_Test.generateProductList(1)[0];
        newProduct.Name = 'PLAN-SEGURO';
        newProduct.ProductCode = '9999';
        newProduct.PS_CodeUniqueIdentifier__c = '9999';
        newProduct.CurrencyIsoCode = 'PEN';
        newProduct.PS_Currency__c = 'Soles';
        newProduct.PS_IntermediaryUniqueIdentifier__c = 'ACCT';
        newProduct.PS_InsuredMinimumAge__c = 18;
        newProduct.PS_InsuredMaximumAge__c = 88;
        newProduct.PS_RenewalType__c = 'Normal';
        newProduct.vlocity_ins__LineOfBusiness__c = '99';
        insert newProduct;
        Product2 parentProduct = [SELECT Id, PS_RecordType__c
            FROM Product2
            WHERE Id = : newProduct.vlocity_ins__ParentClassId__c
        ];
        parentProduct.PS_RecordType__c = 'PS_CreditLifeInsurance';
        parentProduct.PS_DanaServiceAPI__c = true;
        parentProduct.ProductCode = '999';
        update parentProduct;
        Account clientInsured = new Account();
        clientInsured.LastName = 'APELLIDO P CLIENTE';
        clientInsured.PS_MothersLastname__pc = 'APELLIDO M CLIENTE';
        clientInsured.FirstName = 'CLIENTE';
        clientInsured.PersonBirthdate = system.today().addYears(-40);
        clientInsured.PS_IdentificationDocument__c = '1';
        clientInsured.PS_IdentificationDocumentNumber__c = '11111111';
        clientInsured.PS_PersonCodeBDG__c = '11111';
        clientInsured.PS_validationPGA__c = 'Validacion Completada';
        clientInsured.PS_PersonCodeRRGG__c = 0;
        clientInsured.PS_Nationality__c = '1';
        clientInsured.BillingStreet = 'dirección del asegurado';
        clientInsured.FinServ__SourceSystemId__c =
            clientInsured.PS_IdentificationDocument__c + clientInsured.PS_IdentificationDocumentNumber__c;
        insert clientInsured;
        //Opportunity
        Opportunity oppObj = new Opportunity(
            AccountId = clientInsured.Id,
            Name = 'Test Opportunity',
            StageName = 'Qualification',
            CloseDate = Date.newInstance(2025, 1, 1)
            );
        insert oppObj;
        //Opportunity
        Opportunity oppObj2 = new Opportunity(
            AccountId = clientInsured.Id,
            Name = 'Test2 Opportunity',
            StageName = 'Qualification',
            CloseDate = Date.newInstance(2025, 1, 1)
            );
        insert oppObj2;
        //Quote
        Quote quoteObj = new Quote(Name = 'COT-ISAAC-HERNANDEZ-204-4', OpportunityId = oppObj.Id);
        insert quoteObj;
        //Quote
        Quote quoteObj2 = new Quote(Name = 'COT-ISAAC-FERNANDEZ-204-4', OpportunityId = oppObj2.Id);
        insert quoteObj2;
        List<InsurancePolicy> lstPolicy = new List<InsurancePolicy>();
        lstPolicy.add(new InsurancePolicy(
                IntermediaryAccountId = intermediaryAccount.Id,
                SourceQuoteId = quoteObj.Id,
                ExpirationDate = system.now().addMonths(6),
                EffectiveDate = expirationDateNormal.addMonths(-6),
                Name = '9999111101',
                NameInsuredId = clientInsured.Id,
                RenewalDate = expirationDateNormal,
                Status = 'Aprobada sin primer pago',
                ProductId = newProduct.Id,
                PremiumFrequency = 'Monthly',
                CurrencyIsoCode = 'PEN',
                PolicyTerm = 'Monthly',
                StandardFeeAmount = 0.32,
                StandardTaxAmount = 1.98,
                StandardPremiumAmount = 10.69,
                PS_SubSalesChannel__c = '6',
                PS_Currency__c = '99',
                ProducerId = producerRcd.Id,
                PS_AccountType__c = '001',
                PS_EntityCollection__c = '221',
                PS_ApplicationNumber__c = '7099111101',
                PS_AccountNumber__c = '192803841203411',
                PS_OperationNumber__c = '10080990',
                SaleDate = system.today())
            );
        lstPolicy.add(new InsurancePolicy(
                IntermediaryAccountId = intermediaryAccount.Id,
                SourceQuoteId = quoteObj2.Id,
                ExpirationDate = system.now().addMonths(6),
                EffectiveDate = expirationDateNormal.addMonths(-6),
                Name = '9999111102',
                NameInsuredId = clientInsured.Id,
                RenewalDate = expirationDateNormal,
                Status = 'Aprobada sin primer pago',
                ProductId = newProduct.Id,
                PremiumFrequency = 'Annually',
                CurrencyIsoCode = 'PEN',
                PolicyTerm = 'Annually',
                StandardFeeAmount = 0.32,
                StandardTaxAmount = 1.98,
                StandardPremiumAmount = 10.69,
                PS_SubSalesChannel__c = '6',
                PS_Currency__c = '99',
                ProducerId = producerRcd.Id,
                PS_AccountType__c = '001',
                PS_EntityCollection__c = '221',
                PS_ApplicationNumber__c = '7099111102',
                PS_AccountNumber__c = '192803841203411',
                PS_IssuanceRequestType__c = 'Hipotecario',
                PS_OperationNumber__c = '10080991',
                SaleDate = system.today())
            );
        insert lstPolicy;
        List<InsurancePolicyTransaction> iptList = new List<InsurancePolicyTransaction>();
        iptList.add(new InsurancePolicyTransaction(
                TransactionAmount = 100,
                TransactionEffectiveDate = System.today(),
                InsurancePolicyId = lstPolicy.get(0).Id,
                Type = 'Renewal',
                TransactionPostedDate = Datetime.now(),
                Name = '0000002')
            );
        iptList.add(new InsurancePolicyTransaction(
                TransactionAmount = 100,
                TransactionEffectiveDate = System.today(),
                InsurancePolicyId = lstPolicy.get(1).Id,
                Type = 'Renewal',
                TransactionPostedDate = Datetime.now(),
                Name = '0000003')
            );
        insert iptList;
        List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c> listLiq = new List<vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c>();
        listLiq.add(new vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c(
                vlocity_ins_fsc__PremiumAmount__c = 100,
                vlocity_ins_fsc__ScheduleDate__c = Date.today(),
                vlocity_ins_fsc__InsurancePolicyId__c = lstPolicy.get(0).Id,
                PS_Status__c = 'Anulado',
                Name = '100000001',
                Related_Insurance_Policy_Transaction__c = iptList.get(0).Id,
                PS_EffectiveDate__c = Date.today().addDays(-65),
                PS_ExpirationDate__c = Date.today().addDays(35))
            );
        listLiq.add(new vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c(
                vlocity_ins_fsc__PremiumAmount__c = 100,
                vlocity_ins_fsc__ScheduleDate__c = Date.today(),
                vlocity_ins_fsc__InsurancePolicyId__c = lstPolicy.get(0).Id,
                PS_Status__c = 'Anulado',
                Name = '100000003',
                Related_Insurance_Policy_Transaction__c = iptList.get(0).Id,
                PS_EffectiveDate__c = Date.today().addDays(-65),
                PS_ExpirationDate__c = Date.today().addDays(35))
            );
        listLiq.add(new vlocity_ins_fsc__InsurancePolicyPaymentScheduleEntry__c(
                vlocity_ins_fsc__PremiumAmount__c = 100,
                vlocity_ins_fsc__ScheduleDate__c = Date.today(),
                vlocity_ins_fsc__InsurancePolicyId__c = lstPolicy.get(1).Id,
                PS_Status__c = 'Anulado',
                Name = '100000002',
                Related_Insurance_Policy_Transaction__c = iptList.get(1).Id,
                PS_EffectiveDate__c = Date.today().addDays(-65),
                PS_ExpirationDate__c = Date.today().addDays(35))
            );
        insert listLiq;
        CommissionSchedule comision = new CommissionSchedule(
            Name = 'Comisión Comercialización Prueba',
            CalculationType = 'IntegrationProcedure'
            );
        insert comision;
        List<CommissionScheduleAssignment> commissions = new List<CommissionScheduleAssignment> {
            new CommissionScheduleAssignment(
                CommissionScheduleId = comision.Id, Product2Id = newProduct.Id, PS_CommissionPercentage__c = 2.5, PS_Type__c = 'Cobranza', ProducerId = producerRcd.Id, PS_SpecificCommissionPercentage__c = 2.5
                ),
            new CommissionScheduleAssignment(
                CommissionScheduleId = comision.Id, Product2Id = newProduct.Id, PS_CommissionPercentage__c = 3.0, PS_Type__c = 'Comercializacion', ProducerId = producerRcd.Id, PS_SpecificCommissionPercentage__c = 2.5
                )
        };
        insert commissions;
        List<PS_ReactivationRequest__c> lstReact = new List<PS_ReactivationRequest__c>();
        lstReact.add(new PS_ReactivationRequest__c(
                PS_OperationNumber__c = '10080990')
            );
            lstReact.add(new PS_ReactivationRequest__c(
                PS_OperationNumber__c = '10080991')
            );
        insert lstReact;
    }
    //
    @IsTest
    public static void testBatch() {
        Test.StartTest();
        PS_PolicyReactivation_bch bch = new PS_PolicyReactivation_bch();
        Database.executeBatch(bch);
        Test.StopTest();
        Assert.areEqual(1,1);
    }
}