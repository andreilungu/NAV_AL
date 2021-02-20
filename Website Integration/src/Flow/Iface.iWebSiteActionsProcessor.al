interface iWebSiteActionsProcessor
{
    procedure ProcessActions(var WebIntAct: Record "Web Integration Action Log")
    procedure ProcessActions(TableIdBulkProcessing: Integer)
}
