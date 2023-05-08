trigger ViewOpenOpportunities on Opportunity (after insert, after update) {
    List<Opportunity> openOpps = new List<Opportunity>();
 
    for(Opportunity opp : Trigger.new) {
        if(opp.StageName == 'Open') {
            openOpps.add(opp);
        }
    }
 
    if(!openOpps.isEmpty()) {
        Map<Id, String> oppOwnerNames = new Map<Id, String>([SELECT Id, Name FROM User WHERE Id in :openOpps.OwnerId]);
 
        DataTable oppTable = new DataTable();
        oppTable.addColumn('Name', DataType.TEXT);
        oppTable.addColumn('Stage', DataType.TEXT);
        oppTable.addColumn('Amount', DataType.CURRENCY);
        oppTable.addColumn('Closing Date', DataType.DATE);
        oppTable.addColumn('Opportunity Owner', DataType.TEXT);
 
        for(Opportunity opp : openOpps) {
            oppTable.addRow(new List<Object>{opp.Name, opp.StageName, opp.Amount, opp.CloseDate, oppOwnerNames.get(opp.OwnerId)});
        }
 
        LightningDataTableUtils.createDataTable('Opportunities', oppTable);
    }
}