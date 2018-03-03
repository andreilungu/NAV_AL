codeunit 50102 MergeSortList    
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
    ProgressWindow : Dialog;
    RandomNosSetup : Record RandomNosSetup;
    begin
        RandomNosSetup.Get;

        If RandomNosSetup.RunMode = RandomNosSetup.RunMode::CreateInMemory Then
            //generate a list with random numbers populated at runtime
            RandomNosMgt.FillRandomNumbersList(RandomNumbersList,
                RandomNosSetup.NoOfRandomNosInMemory,RandomNosSetup.RandomSelectionMaxNumberMemory)
        Else
            //generate a list with random numbers populated from table: the table must be populated first !!!
            RandomNosMgt.FillRandomNumbersListFromRealTable(RandomNumbersList);

        RandomNosMgt.CreateStringWihValuesList(RandomNumbersList,InitialRandomValuesString); //generate string for message
           
        //Sort Random Numbers from temptable using Insertion Sort
        StartTime := CurrentDateTime;
        ProgressWindow.Open('Sorting Numbers...');
        MergeSort(RandomNumbersList, 1, RandomNumbersList.Count);
        ProgressWindow.Close;
        EndTime := CurrentDateTime;

        RandomNosMgt.CreateStringWihValuesList(RandomNumbersList,ResultedSortedValuesString); //generate string for message

        Message('Executed in %1',EndTime-StartTime);
        Message(MessageText,InitialRandomValuesString,ResultedSortedValuesString);
    end;
    
    local procedure MergeSort(RandomNosList : List of [Integer]; leftStart : integer; rightEnd : Integer);
    var
        middle : integer;
    begin
        if leftStart >= rightEnd then
            Exit;

         middle := round(((leftStart-1 + rightEnd) / 2),1,'>');
         MergeSort(RandomNosList,leftStart,middle);
         MergeSort(RandomNosList,middle+1,rightEnd);
         MergeHalves(RandomNosList,leftStart,rightEnd);
    end;

    local procedure MergeHalves(RandomNosList : List of [Integer]; leftStart : integer; rightEnd : Integer);
    var
        i : Integer; j : integer; k : Integer; leftEnd : integer; rightStart : Integer; x : integer; y:integer;
        tempList : List of [Integer];
    begin
        leftEnd := Round(((rightEnd + leftStart - 1) / 2),1,'>');
        rightStart := leftEnd + 1;
        i := leftStart; j := leftEnd + 1; k := leftStart;

        //create temp sorted list
        while (i <= leftEnd) and (j <= rightEnd)  do begin
            If RandomNosList.Get(i) < RandomNosList.Get(j) then begin
                tempList.Add(RandomNosList.Get(i));
                i+=1;
            end else 
            begin
                tempList.Add(RandomNosList.Get(j));
                j+=1;
            end;
            k+=1;
        end;

        while i < leftEnd + 1 do begin
            tempList.Add(RandomNosList.Get(i)); //add remaing elements from left list
            i += 1;
        end;

        while j < rightEnd + 1 do begin
            tempList.Add(RandomNosList.Get(j)); //add remaing elements from right list
            j += 1;
        end;

        //copy sorted elements to main list
        y := leftStart;
        for x := 1 to tempList.Count do begin
            RandomNosList.Set(y,tempList.Get(x));
            y+=1;
        end;
    end;

}