page 50050 "Distance Calculator Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 50050;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Enabled; Enabled)
                {
                    ApplicationArea = All;
                }
                field("Refresh Interval"; "Refresh Interval")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Refresh Interval (days)';
                }
            }

            part(DistanceCalcSetupLines; "Distance Calc. Setup Lines")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Reset();
        If not Get then begin
            Init();
            Insert();
        END;
    end;

    var
        myInt: Integer;
}