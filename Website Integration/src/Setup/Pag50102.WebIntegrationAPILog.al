page 50102 "Web Integration API Log"
{

    ApplicationArea = All;
    Caption = 'Web Integration API Log';
    PageType = List;
    SourceTable = "Web Integration API Log";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(DateTime; Rec.DateTime)
                {
                    ApplicationArea = All;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
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
            action(Request)
            {
                Caption = 'View Request';
                ApplicationArea = All;
                promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;
                trigger OnAction()
                var
                    InputLongText: Page "Input Long Text";
                begin
                    InputLongText.EDITABLE := FALSE;
                    InputLongText.SetText(Rec.ReadTextFromBLOB(Rec.FIELDNO(Request)));
                    InputLongText.RUNMODAL;
                end;
            }

            action(Response)
            {
                Caption = 'View Response';
                ApplicationArea = All;
                promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;
                trigger OnAction()
                var
                    InputLongText: Page "Input Long Text";
                begin
                    InputLongText.EDITABLE := FALSE;
                    InputLongText.SetText(Rec.ReadTextFromBLOB(Rec.FIELDNO(Response)));
                    InputLongText.RUNMODAL;
                end;
            }
        }
    }

}
