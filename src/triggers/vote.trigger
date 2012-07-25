trigger vote on Mobile_Poll_Vote__c (after insert) {
    List<Mobile_Poll_Vote__c> answers = [SELECT Id, Answer__c, Mobile_Poll__r.Question__c, CreatedById, Mobile_Poll__c
                                             FROM Mobile_Poll_Vote__c
                                            WHERE Id IN: trigger.newMap.keySet()];

    Map<Id, Mobile_Poll_Vote__c> userIdsToMobilePollAnswers = new Map<Id, Mobile_Poll_Vote__c>();
    for(Mobile_Poll_Vote__c answer : answers) {
        userIdsToMobilePollAnswers.put(answer.CreatedById, answer);
    }

    List<FeedItem> feedItems = new List<FeedItem>();
    for(Id userId : userIdsToMobilePollAnswers.keySet()) {
        Mobile_Poll_Vote__c answer = userIdsToMobilePollAnswers.get(userId);
        PageReference mobilePollPage = Page.MobilePoll;
        mobilePollPage.getParameters().put('id', answer.Mobile_Poll__c);
        feedItems.add(new FeedItem(ParentId = userId,
                                   Body = 'just voted "' + answer.Answer__c + '"',
                                   Title = answer.Mobile_Poll__r.Question__c,
                                   LinkUrl = mobilePollPage.getUrl()));
    }
    insert feedItems;
}