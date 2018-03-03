codeunit 50100 InsertionSortTempTables
{
    trigger OnRun();
    var
    tempRandomNumbers : Record RandomNumbers temporary;
    RandomNosSetup : Record RandomNosSetup;
    InitialRandomValuesString : Text;
    ResultedSortedValuesString : Text;
    MessageText : TextConst ENU = 'Initial Numbers:\\%1\\Sorted Numbers:\\%2';
    StartTime : DateTime;
    EndTime : DateTime;
    ExecutionTime : DateTime;
    RandomNosMgt : Codeunit RandomNosMgt;
    begin
        RandomNosSetup.Get;

        If RandomNosSetup.RunMode = RandomNosSetup.RunMode::CreateInMemory then
            RandomNosMgt.FillTempRecWithRandomNumbers(tempRandomNumbers,
                    RandomNosSetup.NoOfRandomNosInMemory,RandomNosSetup.RandomSelectionMaxNumberMemory)
        Else
            RandomNosMgt.FillRandomNumbersTempFromRealTable(tempRandomNumbers);
        
        RandomNosMgt.CreateStringWihValuesTempTab(tempRandomNumbers,InitialRandomValuesString); //generate string for message
           
        //Sort Random Numbers from temptable using Insertion Sort
        StartTime := CurrentDateTime;
        InsertionSort(tempRandomNumbers,tempRandomNumbers.Count);
        EndTime := CurrentDateTime;

        RandomNosMgt.CreateStringWihValuesTempTab(tempRandomNumbers,ResultedSortedValuesString); //generate string for message

        EndTime := CurrentDateTime;
        Message('Executed in %1',EndTime-StartTime);
        Message(MessageText,InitialRandomValuesString,ResultedSortedValuesString);
    end;
    
    var
    //no global variables

    local procedure InsertionSort(var tempRandomNumbers : Record RandomNumbers temporary; NosCount : Integer);
    var
    CurrKey : Integer; CurrValue : Integer; IntToMoveRight : Integer; StepsMovedLeft : Integer;
    swapped : Boolean; ProgressWindow : Dialog; i: integer;
    begin
        ProgressWindow.Open('Sorting Random Nos @1@@@@@@@@@');
        If tempRandomNumbers.FindSet then begin
            tempRandomNumbers.Next(1); //start with second record
            repeat
                i+=1;
                ProgressWindow.UPDATE(1,ROUND(i /  NosCount * 10000,1));
                swapped := false;
                CurrKey := tempRandomNumbers.PrimaryKey;
                CurrValue := tempRandomNumbers.RandomNumber;
                //move to the right any numbers greater than the current one
                StepsMovedLeft := tempRandomNumbers.Next(-1);
                while (StepsMovedLeft < 0) AND (tempRandomNumbers.RandomNumber > CurrValue) do begin
                    IntToMoveRight := tempRandomNumbers.RandomNumber;
                    tempRandomNumbers.Next(1);
                    tempRandomNumbers.RandomNumber := IntToMoveRight;
                    tempRandomNumbers.Modify;
                    tempRandomNumbers.Next(-1);
                    StepsMovedLeft := tempRandomNumbers.Next(-1);
                    swapped := true;
                end;
                // if items where moved to right, 
                if swapped then begin
                    If StepsMovedLeft < 0 then
                        tempRandomNumbers.Next(1); 
                    tempRandomNumbers.RandomNumber := CurrValue;
                    tempRandomNumbers.Modify;
                end;
  
                tempRandomNumbers.Get(CurrKey); //go back to initial record
            until tempRandomNumbers.Next = 0;
        end;
        ProgressWindow.Close;
    end;
}