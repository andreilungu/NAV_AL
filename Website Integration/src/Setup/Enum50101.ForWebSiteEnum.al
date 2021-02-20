enum 50101 "For WebSite Enum" implements iProcessWebSiteActions
{
    Extensible = true;

    value(0; "Website 1")
    {
        Caption = 'Website 1';
        Implementation = iProcessWebSiteActions = "Process Website 1 Actions";
    }
    value(1; "Website 2")
    {
        Caption = 'Website 2';
        Implementation = iProcessWebSiteActions = "Process Website 2 Actions";
    }
    value(2; Website3)
    {
        Caption = 'Website 3';
        Implementation = iProcessWebSiteActions = "Process Website 3 Actions";
    }

}
