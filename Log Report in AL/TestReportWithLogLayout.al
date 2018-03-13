report 50001 TestReport
{
    DefaultLayout = RDLC;
    RDLCLayout = 'ReportWithLogLayout.rdl';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        { 
            trigger OnAfterGetRecord();
                var
                GLEntry : Record "G/L Entry";
                SumAmount : Decimal;
                CountTransactions : Integer;

                begin
                    clear(GLEntry);
                    clear(SumAmount);
                    clear(CountTransactions);
                    GLEntry.SetRange("G/L Account No.","No.");
                    IF GLEntry.FindSet then
                        repeat
                            SumAmount += GLEntry.Amount;
                            CountTransactions += 1;
                        until GLEntry.Next = 0;
                        
                    IF CountTransactions > 0 then
                        InsertReportLog("No.",SumAmount,CountTransactions,SumAmount/CountTransactions);
                end;
        }
        dataitem(Integer;Integer)
        {
            column(GLAccNo; ListExample.Get(Number + i)){}
            column(SumOfAmount; ListExample.Get(Number + j)){}
            column(CountTransactions; ListExample.Get(Number + k)){}
            column(AverageTransactions; ListExample.Get(Number + l)){}

            trigger OnPreDataItem();
            begin
                Integer.SetRange(Number,1,ListExample.Count / 4);   
            end;

            trigger OnAfterGetRecord();
            begin
                //the index of the AL native List starts from 1, not 0.
                If Integer.Number = 1 then begin
                    i += 0; j += 1; k += 2; l += 3;
                end Else begin
                    i += 3; j += 3; k += 3; l += 3;
                end;
                //Message(ListExample.Get(Number + i));
            end;

            
        }
    }
    
  var
       ListExample : List of [Text]; //AL build in dot net wrapper
       i : Integer;
       j : integer;
       k: integer;
       l : integer;

    local procedure  InsertReportLog(GLAccNo : Code[10]; SumAmount : Decimal; CountTrans : Integer; AvgTransAmount : Decimal);
    begin
        ListExample.Add(GLAccNo);
        ListExample.Add(Format(SumAmount));
        ListExample.Add(Format(CountTrans));
        ListExample.Add(Format(AvgTransAmount));
    end;

}
