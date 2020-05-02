codeunit 50100 "Test UnixTimeStamp API Mgmt."
{
    trigger OnRun()
    begin
        GetOauthToken()
    end;

    local procedure CalcUnixDateTime(StartDate: Date; StartTime: Time; Duration: Integer): DateTime
    var
        NoOfDays: Integer;
        RemDur: Duration;
        EndDate: Date;
        EndTime: Time;
        hoursDiff: Integer;
        DateTImeDotNet: DotNet DateTime;
        DateTImeDotNetUTC: DotNet DateTime;
        DurationDelta: Duration;
        DT: DateTime;
    begin
        IF Duration = 0 THEN BEGIN
            EndDate := StartDate;
            EndTime := StartTime;
            Exit(CreateDateTime(EndDate, EndTime));
        END;

        NoOfDays := Duration DIV 86400;
        RemDur := Duration - (NoOfDays * 86400);

        EndTime := StartTime + (RemDur * 1000);
        EndDate := StartDate + NoOfDays;

        IF EndTime < StartTime THEN
            EndDate := EndDate + 1;

        DateTImeDotNet := DateTImeDotNet.Now;
        DateTImeDotNetUTC := DateTImeDotNetUTC.UtcNow;
        DurationDelta := DateTImeDotNet.Subtract(DateTImeDotNetUTC);
        IF DurationDelta <> 0 then
            EndTime += DurationDelta;

        Exit(CreateDateTime(EndDate, EndTime)); // UTC time converted to Local Time!
    end;

    local procedure CheckExistingTokenIsValid(): Boolean
    var
        CurrDT: DotNet DateTime;
    begin
        CurrDT := CurrDT.Now;
        CurrDT.AddMinutes(1); //maybe web service call takes little time so need to ensure token does not expire in the meantime
        //Exit(YourSetupTable."Token - Expires On" < CurrDT);
    end;

    procedure GetOauthToken()
    var
        APITokenResultTxt: Text;
        JToken: JsonToken;
        JObject: JsonObject;
        DateTime: DateTime;
        Dur: Duration;
        TestDateTime: DateTime;
    begin
        TestDateTime := CalcUnixDateTime(19700101D, 000000T, 1588400673);
        Message('%1', TestDateTime);

        Exit; //for test

        //example of real life usage:

        //GetAPISetup()

        //YourSetupTable.CalcFields("Token");
        //IF YourSetupTable."Token".HasValue then
        IF CheckExistingTokenIsValid() then // if existing token is not expired use it
                                            //exit(YourSetupTable.ReadTextFromBLOB(YourSetupTable.FieldNo("Token")));

            //else generate and return a new token

            JObject.ReadFrom(APITokenResultTxt); //read the content of the json
        JObject.SelectToken('access_token', JToken);
        //see https://andreilungu.com/read-write-text-from-to-blob-fields-generic-way-nav/ for more info:
        //YourSetupTable.WriteTextToBLOB(YourSetupTable.FieldNo("Token"), JToken.AsValue().AsText());
        //YourSetupTable.FIND;
        JObject.SelectToken('expires_in', JToken);
        //Evaluate(YourSetupTable."Token - Expires In", JToken.AsValue().AsText());
        JObject.SelectToken('expires_on', JToken);
        //YourSetupTable."Token - Expires On" := CalcUnixDateTime(19700101D, 000000T, JToken.AsValue().AsInteger());
        //Dur := (YourSetupTable."Token - Expires In" * 1000) * (-1);
        //YourSetupTable."Token - Created At" := YourSetupTable."Token - Expires On" + Dur;
        //YourSetupTable.Modify();

    end;

    var
        myInt: Integer;
}