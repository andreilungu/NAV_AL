codeunit 50100 "Web Integration Actions Mgmt."
{

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyItem(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        WebIntegrationAction: Record "Web Integration Action Log";
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
    begin
        IF Rec.IsTemporary THEN
            exit;

        IF NOT Rec."Active For Website 1" then
            Exit;

        IF NOt CheckFieldsChanged(Rec, xRec) then
            exit;

        IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1|%2', WebIntegrationAction."Action Type"::Insert, WebIntegrationAction."Action Type"::Modify)) then
            exit;

        ActionType := ActionType::Modify;
        ForWebsite := ForWebsite::"Website 1";
        WebIntegrationAction.InsertAction(Rec, ActionType, ForWebsite);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Active For Website 1', true, true)]
    local procedure OnAfterValidateActiveForWebsite(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        WebIntegrationAction: Record "Web Integration Action Log";
        ActionType: Enum "Web Integration Action Types";
        WebIntegrationAction2: Record "Web Integration Action Log";
        WebIntegrationAction3: Record "Web Integration Action Log";
        ForWebsite: Enum "For WebSite Enum";
    begin
        IF Rec.IsTemporary THEN
            exit;

        IF Rec."Active For Website 1" then begin
            ActionType := ActionType::Insert;
            IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1', WebIntegrationAction."Action Type"::Delete), WebIntegrationAction2) then
                WebIntegrationAction2.DeleteAll();
            WebIntegrationAction2.SetRange(Processed, true);
            WebIntegrationAction2.SetRange("Action Type");
            IF WebIntegrationAction2.FindLast() Then begin
                If WebIntegrationAction2."Action Type" <> WebIntegrationAction2."Action Type"::Delete then
                    ActionType := ActionType::Modify;
            end;

        end;
        IF (NOT Rec."Active For Website 1") then begin
            ActionType := ActionType::Delete;
            IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1', WebIntegrationAction2."Action Type"::Insert), WebIntegrationAction3) then begin
                WebIntegrationAction3.DeleteAll();
                exit;
            end;
            IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1', WebIntegrationAction2."Action Type"::Modify), WebIntegrationAction2) then
                WebIntegrationAction2.DeleteAll();

        end;
        ForWebsite := ForWebsite::"Website 1";
        WebIntegrationAction.InsertAction(Rec, ActionType, ForWebsite);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteItem(var Rec: Record Item; RunTrigger: Boolean)
    var
        WebIntegrationAction: Record "Web Integration Action Log";
        WebIntegrationAction2: Record "Web Integration Action Log";
        WebIntegrationSetup: Record "Web Integration Setup";
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
    begin
        IF Rec.IsTemporary THEN
            exit;

        IF Rec."Active For Website 1" then
            exit;

        IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1', WebIntegrationAction2."Action Type"::Modify), WebIntegrationAction2) then
            WebIntegrationAction2.DeleteAll();
        IF CheckUnprocessedWebIntegrationActionsAlreadyExist(Database::Item, Rec.RecordId, StrSubstNo('%1', WebIntegrationAction2."Action Type"::Insert), WebIntegrationAction2) then begin
            WebIntegrationAction2.DeleteAll();
            exit;
        end;

        ActionType := ActionType::Delete;
        ForWebsite := ForWebsite::"Website 1";
        WebIntegrationAction.InsertAction(Rec, ActionType, ForWebsite);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Variant", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertItemVariant(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemVariant(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Variant", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyItemVariant(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    begin
        InsertActionForItemVariant(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Variant", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteItemVariant(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemVariant(Rec)
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Variant", 'OnAfterRenameEvent', '', true, true)]
    local procedure OnAfterRenameItemVariant(var Rec: Record "Item Variant"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemVariant(Rec)
    end;

    local procedure InsertActionForItemVariant(var ItemVar: Record "Item Variant")
    var
        Item: Record Item;
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
        WebIntegrationAction: Record "Web Integration Action Log";
    begin
        IF ItemVar.IsTemporary THEN
            exit;

        if Item.Get(ItemVar."Item No.") Then
            IF Item."Active For Website 1" Then begin
                ActionType := ActionType::Modify;
                ForWebsite := ForWebsite::"Website 1";
                WebIntegrationAction.InsertAction(Item, ActionType, ForWebsite);
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Translation", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertItemTranslation(var Rec: Record "Item Translation"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemTransaltion(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Translation", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterModifyItemTranslation(var Rec: Record "Item Translation"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemTransaltion(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Translation", 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteItemTranslation(var Rec: Record "Item Translation"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemTransaltion(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Translation", 'OnAfterRenameEvent', '', true, true)]
    local procedure OnAfterRenameItemTranslation(var Rec: Record "Item Translation"; RunTrigger: Boolean)
    var
    begin
        InsertActionForItemTransaltion(Rec);
    end;

    local procedure InsertActionForItemTransaltion(var ItemTrans: Record "Item Translation")
    var
        Item: Record Item;
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
        WebIntegrationAction: Record "Web Integration Action Log";
    begin
        IF ItemTrans.IsTemporary THEN
            exit;

        if Item.Get(ItemTrans."Item No.") Then
            IF Item."Active For Website 1" Then begin
                ActionType := ActionType::Modify;
                ForWebsite := ForWebsite::"Website 1";
                WebIntegrationAction.InsertAction(Item, ActionType, ForWebsite);
            end;
    end;

    local procedure CheckFieldsChanged(var Item: Record Item; var xItem: Record Item): Boolean
    begin
        exit((Item."No. 2" <> xItem."No. 2") OR (Item.Description <> xItem.Description) OR
         (Item."Unit Price" <> xItem."Unit Price"));
    end;

    local procedure CheckUnprocessedWebIntegrationActionsAlreadyExist(TableID: Integer; RecId: RecordId; ActionTypeFilter: Text): Boolean
    var
        WebIntegrationAction2: Record "Web Integration Action Log";
    begin
        FilterUnprocessedWebIntegrationActions(TableID, RecId, ActionTypeFilter, WebIntegrationAction2);
        IF NOT WebIntegrationAction2.IsEmpty then
            exit(true);

        exit(false);
    end;

    local procedure CheckUnprocessedWebIntegrationActionsAlreadyExist(TableID: Integer; RecId: RecordId; ActionTypeFilter: Text; var WebIntegrationAction2: Record "Web Integration Action Log"): Boolean
    begin
        FilterUnprocessedWebIntegrationActions(TableID, RecId, ActionTypeFilter, WebIntegrationAction2);
        IF NOT WebIntegrationAction2.IsEmpty then
            exit(true);

        exit(false);
    end;

    local procedure FilterUnprocessedWebIntegrationActions(TableID: Integer; RecId: RecordId; ActionTypeFilter: Text; var WebIntegrationAction2: Record "Web Integration Action Log")
    begin
        WebIntegrationAction2.SetRange(Processed, false);
        WebIntegrationAction2.SetRange("Table Id", Database::Item);
        WebIntegrationAction2.SetRange("Record ID", RecId);
        WebIntegrationAction2.SetFilter("Action Type", ActionTypeFilter);
    end;
}
