table 50101 RandomNosSetup
{
    DrillDownPageId = RandomNosSetupPage;
    LookupPageId = RandomNosSetupPage;
    
    fields
    {
        field(1;PrimaryKey;Code[10])
        {
        }

        field(5;NoOfRandomNosRealTable;Integer)
        {   
            CaptionML = ENU = 'No Of Random Nos Real Table';
        }

        field(6;NoOfRandomNosInMemory;Integer)
        {
            CaptionML = ENU = 'No Of Random Nos InMemory';
        }

        field(7;RandomSelectionMaxNumberTable;integer)
        {
           CaptionML = ENU = 'Random Selection Max Number Table';
        }

        
        field(8;RandomSelectionMaxNumberMemory;integer)
        {
           CaptionML = ENU = 'Random Selection Max Number Memory';
        }

        field(9;RunMode; Option)
        {
           OptionMembers = CopyFromDatabase,CreateInMemory;
        
        trigger OnValidate();
           var
            RandomNos : Record RandomNumbers;
            RandomNosMgt : Codeunit RandomNosMgt;
            RandomTabEmptylbl : label '%1 is empty. Do you want to run job to populate it ?';
           begin
                If RunMode = RunMode::CopyFromDatabase then
                    If RandomNos.IsEmpty then
                        If Confirm(StrSubstNo(RandomTabEmptylbl,RandomNos.TableCaption)) and (NoOfRandomNosRealTable > 0)  then
                            RandomNosMgt.FillRealRecWithRandomNumbers(NoOfRandomNosRealTable,RandomSelectionMaxNumberTable);
           end;
        }

        field(10;MaxValuesDisplayedInMessage;integer)
        {
            MaxValue = 10000;
            CaptionML = ENU = 'Maximum Values Displayed in Message';
        }
    }

    keys
    {
        key(PK;PrimaryKey)
        {
            Clustered = true;
        }
    }
    
    var
        myInt : Integer;

    trigger OnInsert();
    begin
    end;

    trigger OnModify();
    begin
    end;

    trigger OnDelete();
    begin
    end;

    trigger OnRename();
    begin
    end;

}