codeunit 50107 HttpStockDataImportMgt
{
    trigger OnRun();
    begin
    end;

    var

    procedure ImportStockData(Symbol: Code[10]);
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RString: Text;
        Url: Text;
        APiKey: Text;
        JToken: JsonToken;
        JTokenRates: JsonToken;
        TimeSeries: JsonToken;
        JsonObject: JsonObject;
        JsonObjectRates: JsonObject;
        ListOfDates: List of [Text];
        DateText: TExt;
        ClosingPrice: Decimal;
        DateOfRate: Date;
    begin
        APiKey := 'YOURAPIKEY';
        Url := 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=' +
             Symbol + '&apikey=' + ApiKey;

        Client.Get(Url, ResponseMessage);

        If not ResponseMessage.IsSuccessStatusCode() then
            Error('Web service returned error:\\' +
                'Status code: %1\' +
                'Description: %2',
                ResponseMessage.HttpStatusCode(),
                ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(RString);

        JToken.ReadFrom(RString);
        JToken.SelectToken('[' + '''' + 'Time Series (Daily)' + '''' + ']', TimeSeries);

        JsonObject := TimeSeries.AsObject();
        ListOfDates := JsonObject.Keys();

        foreach DateText in ListOfDates do begin
            JsonObject.SelectToken(DateText, JTokenRates);
            JsonObjectRates := JTokenRates.AsObject();
            ClosingPrice := GetJsonToken(JsonObjectRates, '' + '4. close' + '').AsValue().AsDecimal();
            DateOfRate := GetDateFromText(DateText);
            InsertStockPrice(Symbol, DateOfRate, ClosingPrice);
        end;
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find token with key: %1', TokenKey);
    end;


    local procedure InsertStockPrice(StockSymbol: Code[10]; Date1: Date; ClosingPrice: Decimal)
    var
        StockPrice: Record StockPrice;
    begin
        If StockPrice.Get(StockSymbol, Date1) then
            Exit;

        StockPrice.Init();
        StockPrice.Symbol := StockSymbol;
        StockPrice.Date := Date1;
        StockPrice.ClosingPrice := ClosingPrice;
        StockPrice.Insert();
    end;

    local procedure GetDateFromText(DateText: Text): Date
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
    begin
        EVALUATE(Year, COPYSTR(DateText, 1, 4));
        EVALUATE(Month, COPYSTR(DateText, 6, 2));
        EVALUATE(Day, COPYSTR(DateText, 9, 2));
        EXIT(DMY2DATE(Day, Month, Year));
    end;
}