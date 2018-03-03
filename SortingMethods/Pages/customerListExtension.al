pageextension 50101 CustListExtension extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst("&Customer")
        {
           action(OpenRandomNosSetup)
           {
               CaptionML = ENU = 'Open Random Nos Setup';
               RunObject = Page RandomNosSetupPage;
               Image = Setup;
               Promoted = true;
               PromotedOnly = true;
           } 
        }
    }
    
    var
        myInt : Integer;
}