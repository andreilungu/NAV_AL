codeunit 50101 InsertionSortList
{
    trigger OnRun();
    var
    RandomNumbersList : List of [Integer];
    InitialRandomValuesString : Text;
    ResultedSortedValuesString : Text;
    MessageText : TextConst ENU = 'Initial Numbers:\\%1\\Sorted Numbers:\\%2';
    StartTime : DateTime;
    EndTime : DateTime;
    ExecutionTime : DateTime;
    RandomNosMgt : Codeunit RandomNosMgt;
    RandomNosSetup : Record RandomNosSetup;
    begin
        RandomNosSetup.Get;
        If RandomNosSetup.RunMode = RandomNosSetup.RunMode::CreateInMemory Then
            RandomNosMgt.FillRandomNumbersList(RandomNumbersList,
                RandomNosSetup.NoOfRandomNosInMemory,RandomNosSetup.RandomSelectionMaxNumberMemory)
        Else
            RandomNosMgt.FillRandomNumbersListFromRealTable(RandomNumbersList);

        RandomNosMgt.CreateStringWihValuesList(RandomNumbersList,InitialRandomValuesString); //generate string for message
           
        StartTime := CurrentDateTime;
        InsertionSort(RandomNumbersList);
        EndTime := CurrentDateTime;
        
        RandomNosMgt.CreateStringWihValuesList(RandomNumbersList,ResultedSortedValuesString); //generate string for message

        Message('Executed in %1',EndTime-StartTime);
        Message(MessageText,InitialRandomValuesString,ResultedSortedValuesString);
    end;
    
    var
    local procedure InsertionSort(RandomNumbersList : List of [Integer]);
    var
    NumberOfElements : integer ; i : Integer; j : integer; CurrentElement : Integer;
    ProgressWindow : Dialog;
    begin
       ProgressWindow.Open('Sorting Random Nos @1@@@@@@@@@');
       NumberOfElements := RandomNumbersList.Count;
       for i := 2 to NumberOfElements do begin
           ProgressWindow.UPDATE(1,ROUND(i /  NumberOfElements * 10000,1));
           CurrentElement := RandomNumbersList.Get(i);
           j := i-1;

           while RandomNumbersList.Get(j) > CurrentElement do begin
               RandomNumbersList.Set(j+1,RandomNumbersList.get(j));
               j -= 1;
               if j = 0 then
                break;
           end;
           RandomNumbersList.Set(j+1,CurrentElement);
       end;
       ProgressWindow.Close;
    end;
}