-- TEST PACKAGE OPERATIONS

-- This script tests:
-- 1. Update operation through PL/SQL package
-- 2. Delete operation through PL/SQL package
-- 3. Duplicate patient cleanup procedure
-- 4. Trigger error handling for insufficient stock
-- 5. Dynamic report procedures

SET SERVEROUTPUT ON;

-- 1. Test UPDATE operation through package
-- Updating Ali Kaya's phone and address.

DECLARE
    V_PATIENT_ID PATIENT.PATIENT_ID%TYPE;
BEGIN
    SELECT
        PATIENT_ID
    INTO V_PATIENT_ID
    FROM
        PATIENT
    WHERE
        EMAIL = 'ali.kaya@example.com';

    PKG_PHARMACY_SYSTEM.UPDATE_PATIENT(
        P_PATIENT_ID => V_PATIENT_ID,
        P_FIRST_NAME => 'Ali',
        P_LAST_NAME  => 'Kaya',
        P_PHONE      => '05551112233',
        P_EMAIL      => 'ali.kaya@example.com',
        P_BIRTH_DATE => DATE '1998-05-12',
        P_GENDER     => 'Male',
        P_ADDRESS    => 'Updated Istanbul Address'
    );

END;
/

-- Check updated patient record.
SELECT
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    PHONE,
    EMAIL,
    ADDRESS
FROM
    PATIENT
WHERE
    EMAIL = 'ali.kaya@example.com';

-- 2. Test DELETE operation through package
-- First insert a temporary patient, then delete it using package.
BEGIN
    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Temporary',
        P_LAST_NAME  => 'Patient',
        P_PHONE      => '05558889999',
        P_EMAIL      => 'temporary.patient@example.com',
        P_BIRTH_DATE => DATE '1999-01-01',
        P_GENDER     => 'Other',
        P_ADDRESS    => 'Temporary Address'
    );
END;
/

-- Check that temporary patient was inserted.
SELECT
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL
FROM
    PATIENT
WHERE
    EMAIL = 'temporary.patient@example.com';

DECLARE
    V_PATIENT_ID PATIENT.PATIENT_ID%TYPE;
BEGIN
    SELECT
        PATIENT_ID
    INTO V_PATIENT_ID
    FROM
        PATIENT
    WHERE
        EMAIL = 'temporary.patient@example.com';

    PKG_PHARMACY_SYSTEM.DELETE_PATIENT(P_PATIENT_ID => V_PATIENT_ID);
END;
/

-- This query should return no rows after delete.
SELECT
    PATIENT_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL
FROM
    PATIENT
WHERE
    EMAIL = 'temporary.patient@example.com';

-- 3. Test duplicate cleanup procedure
-- Duplicate rule:
-- same first_name + last_name + phone

-- Before cleanup: Merve Sahin should appear as duplicate.
SELECT
    FIRST_NAME,
    LAST_NAME,
    PHONE,
    COUNT(*) AS RECORD_COUNT
FROM
    PATIENT
GROUP BY
    FIRST_NAME,
    LAST_NAME,
    PHONE
HAVING
    COUNT(*) > 1
ORDER BY
    FIRST_NAME,
    LAST_NAME;

BEGIN
    PKG_PHARMACY_SYSTEM.REMOVE_DUPLICATE_PATIENTS;
END;
/

-- After cleanup: duplicate groups should be removed.
SELECT
    FIRST_NAME,
    LAST_NAME,
    PHONE,
    COUNT(*) AS RECORD_COUNT
FROM
    PATIENT
GROUP BY
    FIRST_NAME,
    LAST_NAME,
    PHONE
HAVING
    COUNT(*) > 1
ORDER BY
    FIRST_NAME,
    LAST_NAME;

-- 4. Test trigger error for insufficient stock
-- Vitamin C batch has low stock. We try to sell 999 units.
-- Expected result:
-- ORA-20001: Not enough stock available for this medicine batch.
-- The error is caught so the script can continue.
DECLARE
    V_SALE_ID    SALE.SALE_ID%TYPE;
    V_BATCH_VITC MEDICINE_BATCH.BATCH_ID%TYPE;
BEGIN
    SELECT
        SALE_ID
    INTO V_SALE_ID
    FROM
        SALE
    WHERE
        ROWNUM = 1;

    SELECT
        BATCH_ID
    INTO V_BATCH_VITC
    FROM
        MEDICINE_BATCH
    WHERE
        BATCH_NUMBER = 'BATCH-VITC-001';

    PKG_PHARMACY_SYSTEM.ADD_SALE_ITEM(
        P_SALE_ID    => V_SALE_ID,
        P_BATCH_ID   => V_BATCH_VITC,
        P_QUANTITY   => 999,
        P_UNIT_PRICE => 90.00
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected trigger error caught: ' || SQLERRM);
END;
/

-- 5. Verify that failed stock operation did not reduce stock

SELECT
    MB.BATCH_ID,
    M.MEDICINE_NAME,
    MB.BATCH_NUMBER,
    MB.CURRENT_QUANTITY
FROM
         MEDICINE_BATCH MB
    JOIN MEDICINE M ON MB.MEDICINE_ID = M.MEDICINE_ID
WHERE
    MB.BATCH_NUMBER = 'BATCH-VITC-001';

-- 6. Run dynamic report procedures after sale exists
BEGIN
    PKG_PHARMACY_SYSTEM.GET_SALES_REPORT(
        P_START_DATE  => DATE '2026-02-01',
        P_END_DATE    => DATE '2026-02-28',
        P_PHARMACY_ID => NULL,
        P_STATUS      => 'COMPLETED'
    );

    PKG_PHARMACY_SYSTEM.GET_LOW_STOCK_REPORT(
        P_PHARMACY_ID  => NULL,
        P_MIN_QUANTITY => 10
    );
    PKG_PHARMACY_SYSTEM.GET_PRESCRIPTION_REPORT(
        P_PATIENT_ID => NULL,
        P_DOCTOR_ID  => NULL,
        P_STATUS     => 'ACTIVE'
    );

END;
/

-- 7. Final verification: sale totals calculated dynamically
-- We do not store SALE.total_amount or SALE_ITEM.line_total.
-- Sale total is calculated as SUM(quantity * unit_price).

SELECT
    S.SALE_ID,
    S.SALE_DATE,
    PH.PHARMACY_NAME,
    S.STATUS,
    SUM(SI.QUANTITY * SI.UNIT_PRICE) AS CALCULATED_SALE_TOTAL
FROM
         SALE S
    JOIN PHARMACY  PH ON S.PHARMACY_ID = PH.PHARMACY_ID
    JOIN SALE_ITEM SI ON S.SALE_ID = SI.SALE_ID
GROUP BY
    S.SALE_ID,
    S.SALE_DATE,
    PH.PHARMACY_NAME,
    S.STATUS
ORDER BY
    S.SALE_ID;

-- 8. Final verification: stock movements
-- There should be IN movements from batch receiving
-- and OUT movements created automatically by the trigger.
SELECT
    MOVEMENT_ID,
    BATCH_ID,
    MOVEMENT_TYPE,
    QUANTITY,
    MOVEMENT_DATE,
    REFERENCE_TYPE,
    REFERENCE_ID,
    DESCRIPTION
FROM
    STOCK_MOVEMENT
ORDER BY
    MOVEMENT_ID;

-- 9. Commit test operations
COMMIT;