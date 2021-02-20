page 50100 "Web Integration Setup"
{

    Caption = 'Web Integration Setup';
    PageType = Card;
    SourceTable = "Web Integration Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Website 1 Integration Active"; Rec."Website 1 Integration Active")
                {
                    ApplicationArea = All;
                }
                field("Log API Requests"; Rec."Log API Requests")
                {
                    ApplicationArea = All;
                }
                field("Website 1 API Base URL"; Rec."Website 1 API Base URL")
                {
                    ApplicationArea = All;
                }

                field("Website 1 Create Items"; Rec."Website 1 Create Items")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(WebIntegrationActions)
            {
                Caption = 'Web Integration Actions';
                RunObject = Page "Web Integration Actions";
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
            }

            action(WebIntegrationAPILog)
            {
                Caption = 'Web Integration API Log';
                RunObject = Page "Web Integration API Log";
                Image = Log;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

    trigger OnOpenPage()
    begin
        If not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;

}