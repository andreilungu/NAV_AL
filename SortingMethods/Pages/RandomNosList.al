page 50106 RandomNosList
{
    PageType = List;
    SourceTable = RandomNumbers;
    Editable = true;
    CaptionML = ENU = 'Random Numbers List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PrimaryKey;PrimaryKey){}
                field(RandomNumber;RandomNumber){}
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction();
                begin
                end;
            }
        }
    }
}