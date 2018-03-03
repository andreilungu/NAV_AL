codeunit 50110 RandomNosMgt
{
    trigger OnRun();
    begin
    end;
    procedure FillRandomNumbersList(RandomNumbersList : list of [integer];
                        NumberOfValuesWanted : Integer; RandomSelectionMaxNumber : Integer)
    var
    i : integer;
    ListOfInt : List Of [Integer];
    intprimarykey : Integer;
    randomposition : integer;
    RemainedRandomNumbers : Integer;
    ProgressWindow : Dialog;
    begin
        //add values to Int Temp Table
        for i := 1 to RandomSelectionMaxNumber do
               ListOfInt.Add(i);

        ProgressWindow.Open('Creating Random Nos @1@@@@@@@@@');
        RemainedRandomNumbers := RandomSelectionMaxNumber;
        //select random values from tempint and add to List. Then delete the added number from tempint
        for i := 1 to NumberOfValuesWanted do begin
            ProgressWindow.UPDATE(1,ROUND(i /  NumberOfValuesWanted * 10000,1));
            
            randomposition := random(RemainedRandomNumbers); //get a random position using a variabile instead of tmpInt.COUNT which is slow.
            
            //add value to Random Numbers List
            RandomNumbersList.Add(ListOfInt.Get(randomposition));

            //detele value from tempint to have only unique random numbers
            ListOfInt.RemoveAt(randomposition);

            RemainedRandomNumbers -= 1;
            If RemainedRandomNumbers = 0 THEN //in case someone inputs more wanted values than the RandomNumbers
                break;
        end;
        ProgressWindow.Close;
    end;
    procedure CreateStringWihValuesList(RandomNumbersList : List of [Integer];var ResultedString : Text);
    var
    i : Integer;   
    RandomNosSetup : Record RandomNosSetup; 
    begin
        RandomNosSetup.Get;
        for i := 1 to RandomNumbersList.Count do begin
            If ResultedString = '' then
                ResultedString := format(RandomNumbersList.Get(i))
            Else
                ResultedString += ';' + format(RandomNumbersList.Get(i));
            If i >= RandomNosSetup.MaxValuesDisplayedInMessage then begin
                ResultedString += ';' + '...and ' + 
                    format(RandomNumbersList.Count - RandomNosSetup.MaxValuesDisplayedInMessage) + ' more'; 
                //limit the numbers shown in message
                break
            end;
        end;

    end;

    procedure FillTempRecWithRandomNumbers(var tempRandomNumbers : Record RandomNumbers temporary;
                         NumberOfValuesWanted : Integer; RandomSelectionMaxNumber : Integer)
    var
    i : integer;
    ListOfInt : List Of [Integer];
    intprimarykey : Integer;
    randomposition : integer;
    RemainedRandomNumbers : Integer;
    ProgressWindow : Dialog;
    begin
        //add values to Int Temp Table
        for i := 1 to RandomSelectionMaxNumber do
                ListOfInt.Add(i);

        ProgressWindow.Open('Creating Random Nos @1@@@@@@@@@');
        RemainedRandomNumbers := RandomSelectionMaxNumber;
        //select random values from tempint and add to temprandomNumbers. Then delete the added number from tempint
        for i := 1 to NumberOfValuesWanted do begin
            ProgressWindow.UPDATE(1,ROUND(i /  NumberOfValuesWanted * 10000,1));
        
            randomposition := random(RemainedRandomNumbers); //get a random position using a variabile instead of tmpInt.COUNT which is slow.
           
            //add value to tempRandomNumbers
            tempRandomNumbers.PrimaryKey := intprimarykey;
            tempRandomNumbers.RandomNumber := ListOfInt.Get(randomposition);
            tempRandomNumbers.Insert;
            intprimarykey += 1;
        
            //detele value from tempint to have only unique random numbers
            ListOfInt.RemoveAt(randomposition);

            RemainedRandomNumbers -= 1;
            If RemainedRandomNumbers = 0 THEN //in case someone inputs more wanted values than the RandomNumbers
                break;
        end;
        ProgressWindow.Close;
    end;

    procedure CreateStringWihValuesTempTab(var tempRandomNumbers : Record RandomNumbers temporary; var ResultedString : Text);
    var
    i : integer;
    RandomNosSetup : Record RandomNosSetup;    
    begin
        RandomNosSetup.Get;
        If tempRandomNumbers.FindSet then
            Repeat
            i+=1;
                If ResultedString = '' then
                    ResultedString := format(tempRandomNumbers.RandomNumber)
                Else
                    ResultedString += ';' + format(tempRandomNumbers.RandomNumber);
                If i >= RandomNosSetup.MaxValuesDisplayedInMessage then begin
                    ResultedString += ';' + '...and ' + 
                        format(tempRandomNumbers.Count - RandomNosSetup.MaxValuesDisplayedInMessage) + ' more'; 
                    //limit the numbers shown in message
                    break
                end;
            Until tempRandomNumbers.Next = 0;
    end;

    procedure FillRealRecWithRandomNumbers(NumberOfValuesWanted : Integer; RandomSelectionMaxNumber : Integer)
    var
    i : integer;
    ListOfInt : List Of [Integer];
    RandomNumbers : Record RandomNumbers;
    intprimarykey : Integer;
    randomposition : integer;
    RemainedRandomNumbers : Integer;
    ProgressWindow : Dialog;
    begin
        If NOT RandomNumbers.IsEmpty then
            Exit; //values already were added at a previous run

        //add values to List
        for i := 1 to RandomSelectionMaxNumber do
                ListOfInt.Add(i);
            
        ProgressWindow.Open('Creating Random Nos @1@@@@@@@@@');
        RemainedRandomNumbers := RandomSelectionMaxNumber;
        //select random values from List and add to RandomNumbers. Then delete the added number from ListOfInt
        for i := 1 to NumberOfValuesWanted do begin
            ProgressWindow.UPDATE(1,ROUND(i /  NumberOfValuesWanted * 10000,1));
            
            randomposition := random(RemainedRandomNumbers); //get a random position

            //add value to RandomNumbers
            RandomNumbers.PrimaryKey := intprimarykey;
            RandomNumbers.RandomNumber := ListOfInt.Get(randomposition);
            RandomNumbers.Insert;
            intprimarykey += 1;
        
            //detele value from ListOfInt to have only unique random numbers
            ListOfInt.RemoveAt(randomposition);

            RemainedRandomNumbers -= 1;
            If RemainedRandomNumbers = 0 THEN //in case someone inputs more wanted values than the RandomNumbers
                break;
        end;
        ProgressWindow.Close;
    end;

    procedure FillRandomNumbersListFromRealTable(RandomNumbersList : List of [Integer]);
    var
    RandomNos : Record RandomNumbers;
    begin
        If RandomNos.FindSet then
            repeat
                RandomNumbersList.Add(RandomNos.RandomNumber);
            until RandomNos.Next = 0
        else
            Error('%1 is empty. Run batch job from Setup to populate it !',RandomNos.TableCaption());
    end;

     procedure FillRandomNumbersTempFromRealTable(var RandomNumbersTemp : Record RandomNumbers temporary);
    var
    RandomNos : Record RandomNumbers;
    begin
        If RandomNos.FindSet then
            repeat
                RandomNumbersTemp.Copy(RandomNos);
                RandomNumbersTemp.Insert;
            until RandomNos.Next = 0
        else
            Error('%1 is empty. Run batch job from Setup to populate it !',RandomNos.TableCaption());
    end;
}