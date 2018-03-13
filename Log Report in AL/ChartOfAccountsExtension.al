pageextension 50001 ChartOfAccExtension extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Reporting)
        {
            action(ShowMyReport)
            {
                CaptionML = ENU = 'Calculate Amounts for All Accounts';
                Image = CalculateCost;
                
                trigger OnAction();
                begin
                    Report.Run(Report::TestReport);
                end;
            }
        }
    }
    
    var
        myInt : Integer;
}