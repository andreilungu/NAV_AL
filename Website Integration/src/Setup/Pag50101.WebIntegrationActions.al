page 50101 "Web Integration Actions"
{

    ApplicationArea = All;
    Caption = 'Web Integration Actions';
    PageType = List;
    SourceTable = "Web Integration Action Log";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Table Id"; Rec."Table Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Key Text"; KeyValueTxt)
                {
                    Editable = false;
                }
                field("Action Type"; Rec."Action Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("For Web Site"; Rec."For WebSite")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Skip; Rec.Skip)
                {

                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                }

                field("Processed At"; Rec."Processed At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Processed By"; Rec."Processed By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Web API Log Id"; Rec."Web API Log Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProcessLine)
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Process Line';
                trigger OnAction()
                var
                    iWebSiteActionsProcessor: Interface iWebSiteActionsProcessor;
                begin
                    rec.TestField(Processed, false);
                    iWebSiteActionsProcessor := Rec."For WebSite";
                    iWebSiteActionsProcessor.ProcessActions(Rec);
                end;
            }

            action(ProcessItemsBulk)
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Process Items Bulk';
                trigger OnAction()
                var
                    iWebSiteActionsProcessor: Interface iWebSiteActionsProcessor;
                    WebActions: Record "Web Integration Action Log";
                begin
                    iWebSiteActionsProcessor := Rec."For WebSite";
                    iWebSiteActionsProcessor.ProcessActions(Database::Item);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        KeyValueTxt := Format(Rec."Record ID");
    end;

    var
        KeyValueTxt: Text;
}
