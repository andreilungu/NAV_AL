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

        ActionType := ActionType::Modify;
        ForWebsite := ForWebsite::"Website 1";
        WebIntegrationAction.InsertAction(Rec, ActionType, ForWebsite);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Active For Website 1', true, true)]
    local procedure OnAfterValidateActiveForWebsite(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        WebIntegrationAction: Record "Web Integration Action Log";
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
    begin
        IF Rec.IsTemporary THEN
            exit;

        IF Rec."Active For Website 1" then
            ActionType := ActionType::Insert;
        IF (NOT Rec."Active For Website 1") then
            ActionType := ActionType::Delete;
        ForWebsite := ForWebsite::"Website 1";
        WebIntegrationAction.InsertAction(Rec, ActionType, ForWebsite);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterDeleteEvent', '', true, true)]
    local procedure OnAfterDeleteItem(var Rec: Record Item; RunTrigger: Boolean)
    var
        WebIntegrationAction: Record "Web Integration Action Log";
        WebIntegrationSetup: Record "Web Integration Setup";
        ActionType: Enum "Web Integration Action Types";
        ForWebsite: Enum "For WebSite Enum";
    begin
        IF Rec.IsTemporary THEN
            exit;

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

}
