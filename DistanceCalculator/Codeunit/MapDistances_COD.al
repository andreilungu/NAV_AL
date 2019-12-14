codeunit 50000 "Map Distances"
{
    //imports distances from "Data Exchange Field" to "Customer Location Distance" using "Data Exchange Field Mapping"
    TableNo = "Data Exch.";
    trigger OnRun()
    begin
        MapCustomerLocationDistances(Rec);
    end;

    procedure MapCustomerLocationDistances(DataExch: Record "Data Exch.")
    var
        DataExchField: Record "Data Exch. Field";
        CurrLineNo: Integer;
    begin
        DataExchField.SetAutoCalcFields("Data Exch. Def Code");

        DataExchField.SetRange("Data Exch. No.", DataExch."Entry No.");
        IF DataExchField.IsEmpty then
            exit;

        CurrLineNo := 0;
        If DataExchField.FindSet() then
            repeat
                IF CurrLineNo <> DataExchField."Line No." THEN begin
                    CurrLineNo := DataExchField."Line No.";
                    UpdateCustomerLocationDistance(DataExchField);
                END;
            Until DataExchField.Next = 0;

    end;

    local procedure UpdateCustomerLocationDistance(DataExchField: Record "Data Exch. Field")
    var
        CustomerLocationDistance: Record "Customer Location Distance";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(CustomerLocationDistance);
        IF SetFields(RecRef, DataExchField) THEN
            Commit;

    end;

    local procedure SetFields(RecRef: RecordRef; DataExchangeField: Record "Data Exch. Field"): Boolean
    var
        CustomerLocationDistance: Record "Customer Location Distance";
    begin
        IF NOT AssignValue(RecRef, CustomerLocationDistance.FieldNo(Distance), DataExchangeField, 0) then
            exit(false);
        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo(Time), DataExchangeField, 0) then
            exit(false);

        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo("Customer No."), DataExchangeField, '') then
            exit(false);

        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo("Address Code"), DataExchangeField, '') then
            exit(false);

        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo("Location Code"), DataExchangeField, '') then
            exit(false);

        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo("Customer Address"), DataExchangeField, '') then
            exit(false);

        IF Not AssignValue(RecRef, CustomerLocationDistance.FieldNo("Location Address"), DataExchangeField, '') then
            exit(false);

        IF NOT RecRef.Insert(TRUE) then
            exit(RecRef.Modify(TRUE));
        exit(TRUE);
    end;


    [TryFunction]
    local procedure AssignValue(var RecRef: RecordRef; FieldNo: Integer; DefinitionDataExchField: Record "Data Exch. Field"; DefaultValue: Variant)
    var
        DataExchField: Record "Data Exch. Field";
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
        ProcessDataExch: Codeunit "Process Data Exch.";
        TempAmountsToNegate: Record Integer Temporary;
    begin
        IF GetFieldValue(DefinitionDataExchField, FieldNo, DataExchField) AND
            DataExchFieldMapping.GET(
                DataExchField."Data Exch. Def Code",
                DataExchField."Data Exch. Line Def Code",
                RecRef.Number,
                DataExchField."Column No.",
                FieldNo
            ) then begin
            ProcessDataExch.SetField(RecRef, DataExchFieldMapping, DataExchField, TempAmountsToNegate);
            ProcessDataExch.NegateAmounts(RecRef, TempAmountsToNegate);
        END;

    end;

    local procedure GetFieldValue(DefinitionDataExchField: Record "Data Exch. Field"; FieldNo: Integer; VAR DataExchField: Record "Data Exch. Field"): Boolean
    var
        ColumnNo: Integer;
    begin
        IF not GetColumnNo(FieldNo, DefinitionDataExchField, ColumnNo) then
            exit(False);

        DataExchField.SETRANGE("Data Exch. No.", DefinitionDataExchField."Data Exch. No.");
        DataExchField.SETRANGE("Data Exch. Line Def Code", DefinitionDataExchField."Data Exch. Line Def Code");
        DataExchField.SETRANGE("Line No.", DefinitionDataExchField."Line No.");
        DataExchField.SETRANGE("Column No.", ColumnNo);
        DataExchField.SETAUTOCALCFIELDS("Data Exch. Def Code");
        IF DataExchField.FINDFIRST THEN
            EXIT(TRUE);

        exit(false);
    end;

    local procedure GetColumnNo(FieldNo: Integer; DataExchField: Record "Data Exch. Field"; VAR ColumnNo: Integer): Boolean
    var
        DataExchFieldMapping: Record "Data Exch. Field Mapping";
    begin
        DataExchFieldMapping.SetRange("Data Exch. Def Code", DataExchField."Data Exch. Def Code");
        DataExchFieldMapping.SetRange("Data Exch. Line Def Code", DataExchField."Data Exch. Line Def Code");
        DataExchFieldMapping.SetRange("Table ID", Database::"Customer Location Distance");
        DataExchFieldMapping.SetRange("Field ID", FieldNo);
        IF NOT DataExchFieldMapping.FindFirst() then
            exit(false);

        ColumnNo := DataExchFieldMapping."Column No.";
        exit(true);
    end;

    var
        myInt: Integer;
}