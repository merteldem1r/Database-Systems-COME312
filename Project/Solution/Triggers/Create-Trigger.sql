-- CREATE TRIGGER

-- Purpose:
-- When a SALE_ITEM record is inserted, this trigger:
-- 1. Checks stock availability.
-- 2. Decreases MEDICINE_BATCH.current_quantity.
-- 3. Inserts an OUT record into STOCK_MOVEMENT.

CREATE OR REPLACE TRIGGER TRG_SALE_ITEM_STOCK_MOVEMENT BEFORE
    INSERT ON SALE_ITEM
    FOR EACH ROW
DECLARE
    V_CURRENT_QUANTITY MEDICINE_BATCH.CURRENT_QUANTITY%TYPE;
BEGIN
    -- Get the current stock quantity of the selected batch.
    SELECT
        CURRENT_QUANTITY
    INTO V_CURRENT_QUANTITY
    FROM
        MEDICINE_BATCH
    WHERE
        BATCH_ID = :NEW.BATCH_ID;

    -- Check whether there is enough stock.
    IF V_CURRENT_QUANTITY < :NEW.QUANTITY THEN
        RAISE_APPLICATION_ERROR(-20001, 'Not enough stock available for this medicine batch.');
    END IF;

    -- Decrease stock quantity after sale item insertion.
    UPDATE MEDICINE_BATCH
    SET
        CURRENT_QUANTITY = CURRENT_QUANTITY - :NEW.QUANTITY
    WHERE
        BATCH_ID = :NEW.BATCH_ID;

    -- Insert stock movement history.
    INSERT INTO STOCK_MOVEMENT (
        BATCH_ID,
        MOVEMENT_TYPE,
        QUANTITY,
        MOVEMENT_DATE,
        REFERENCE_TYPE,
        REFERENCE_ID,
        DESCRIPTION
    ) VALUES ( :NEW.BATCH_ID,
               'OUT',
               :NEW.QUANTITY,
               SYSDATE,
               'SALE_ITEM',
               :NEW.SALE_ID,
               'Stock decreased automatically after sale item insertion.' );

END;
/