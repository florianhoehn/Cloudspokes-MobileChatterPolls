/********************************************************************************
Name:  MobilePollVoteController
Copyright © 2012  Florian Hoehn
======================================================
======================================================
Purpose: Extension for the MobilePoll VF page to enable the saving of the poll vote
		 record.
********************************************************************************/
global with sharing class MobilePollVoteController {

    public MobilePollVoteController(ApexPages.StandardController stdController) {
    }

    @remoteAction
    global static String vote(String mobilePollId, String answer) {
    	System.Debug(mobilePollId + answer);
    	String response = Label.SuccessMessage;
    	try{
    		Mobile_Poll_Vote__c vote = new Mobile_Poll_Vote__c(	Mobile_Poll__c = mobilePollId,
    															Answer__c = answer);
    		insert vote;
    	} catch (Exception e) {
    		response = e.getMessage();
    	}
        return response;
    }


    // UNIT TESTS
    @isTest
    private static void test_Constructor() {
    	Mobile_Poll__c mobilePoll = new Mobile_Poll__c(Question__c = 'TESTQUESTION');
    	insert mobilePoll;

    	test.startTest();
    		ApexPages.StandardController stdController = new ApexPages.standardController(mobilePoll);
    		MobilePollVoteController controller = new MobilePollVoteController(stdController);
    	test.stopTest();

    	System.AssertNotEquals(null, controller);
    }

    @isTest
    private static void test_Voting_Error() {
    	Mobile_Poll__c mobilePoll = new Mobile_Poll__c(Question__c = 'TESTQUESTION');
    	insert mobilePoll;

    	List<Mobile_Poll_Answer__c> answers = new List<Mobile_Poll_Answer__c>();
    	for(Integer counter = 0; counter < 5; counter++) {
    		answers.add(new Mobile_Poll_Answer__c(Mobile_Poll__c = mobilePoll.id,
    											  Answer__c = 'TESTANSWER ' + counter));
    	}
    	insert answers;

    	test.startTest();
    		String actualResponse = MobilePollVoteController.vote(mobilePoll.id, null);
    	test.stopTest();

    	System.Assert(actualResponse.contains('Required fields are missing: [Answer__c]: [Answer__c]'));
    }

    @isTest
    private static void test_Voting_Success() {
    	Mobile_Poll__c mobilePoll = new Mobile_Poll__c(Question__c = 'TESTQUESTION');
    	insert mobilePoll;

    	List<Mobile_Poll_Answer__c> answers = new List<Mobile_Poll_Answer__c>();
    	for(Integer counter = 0; counter < 5; counter++) {
    		answers.add(new Mobile_Poll_Answer__c(Mobile_Poll__c = mobilePoll.id,
    											  Answer__c = 'TESTANSWER ' + counter));
    	}
    	insert answers;

    	test.startTest();
    		String actualResponse = MobilePollVoteController.vote(mobilePoll.id, 'TESTANSWER');
    	test.stopTest();

    	System.AssertEquals(Label.SuccessMessage, actualResponse);
    }
}