page 50105 RandomNosSetupPage
{
    PageType = Card;
    SourceTable = RandomNosSetup;
    CaptionML = ENU = 'Random Nos Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(RunMode;RunMode){}
                field(NoOfRandomNosInMemory;NoOfRandomNosInMemory){}
                field(RandomSelectionMaxNumber;RandomSelectionMaxNumberMemory){}
                field(NoOfRandomNosRealTable;NoOfRandomNosRealTable){}
                field(RandomSelectionMaxNumberTable;RandomSelectionMaxNumberTable){}
                field(MaxValuesDisplayedInMessage;MaxValuesDisplayedInMessage){}
            }
        }
    }

    actions
    {
        area(processing)
        {
             action(PopulateRandomNosTable)
            {
                CaptionML = ENU = 'Populate Random Numbers Table';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                RandomNosMgt : COdeunit RandomNosMgt;
                RandomNos : Record RandomNumbers;
                begin
                    If Not RandomNos.IsEmpty then
                        RandomNos.DeleteAll;
                    RandomNosMgt.FillRealRecWithRandomNumbers(NoOfRandomNosRealTable,RandomSelectionMaxNumberTable);
                    Message('Inserted %1 records in %2',NoOfRandomNosRealTable,RandomNos.TableCaption());
                end;
            }
            action(RandomNos)
            {
                RunObject = Page RandomNosList;
                CaptionML = ENU = 'Show Database Random Numbers';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action(InsertionSortList)
            {
                RunObject = codeunit InsertionSortList;
                CaptionML = ENU = 'Insertion Sort AL List';
                Image = InsertStartingFee;
                Promoted = true;
                PromotedCategory = Process;
            }
            action(InsertionSortTempTable)
            {
                RunObject = codeunit InsertionSortTempTables;
                CaptionML = ENU = 'Insertion Sort Temp Tables';
                Image = Insert;
                Promoted = true;
                PromotedCategory = Process;
            }
            
             action(MergeSortList)
            {
                RunObject = codeunit MergeSortList;
                CaptionML = ENU = 'Merge Sort List';
                Image = OrderList;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }
    
    var
        myInt : Integer;

        trigger OnOpenPage();
        var
        begin
           If Not get then begin
               Init;
               RunMode := RunMode::CreateInMemory;
               NoOfRandomNosInMemory := 1000;
               NoOfRandomNosRealTable := 100000;
               RandomSelectionMaxNumberMemory := 1000;
               RandomSelectionMaxNumberTable := 100000;
               MaxValuesDisplayedInMessage := 300;
               Insert;
            end;
        end;
}