pageextension 50101 "Item Card Web Fields" extends "Item Card"
{
    layout
    {
        addafter(Item)
        {
            group("Web Integration")
            {
                field("Active For Website 1"; Rec."Active For Website 1")
                {

                }
            }
        }
    }
}
