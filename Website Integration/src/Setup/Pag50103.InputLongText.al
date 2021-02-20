page 50103 "Input Long Text"
{

    Caption = 'Display Log';
    PageType = StandardDialog;
    SourceTable = Integer;

    layout
    {
        area(content)
        {
            field(MyText; MyText)
            {
                Caption = '';
                MultiLine = true;
            }
        }
    }

    procedure SetText(pTxt: Text)
    begin
        MyText := pTxt;
    end;

    procedure GetText(): Text
    begin
        EXIT(MyText);
    end;

    var
        MyText: Text;

}
