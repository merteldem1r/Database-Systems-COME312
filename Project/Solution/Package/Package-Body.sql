-- PACKAGE BODY

CREATE OR REPLACE PACKAGE BODY PKG_PHARMACY_SYSTEM AS

    -- Patient operations

    PROCEDURE ADD_PATIENT (
        P_FIRST_NAME IN PATIENT.FIRST_NAME%TYPE,
        P_LAST_NAME  IN PATIENT.LAST_NAME%TYPE,
        P_PHONE      IN PATIENT.PHONE%TYPE,
        P_EMAIL      IN PATIENT.EMAIL%TYPE,
        P_BIRTH_DATE IN PATIENT.BIRTH_DATE%TYPE,
        P_GENDER     IN PATIENT.GENDER%TYPE,
        P_ADDRESS    IN PATIENT.ADDRESS%TYPE
    ) AS
    BEGIN
        INSERT INTO PATIENT (
            FIRST_NAME,
            LAST_NAME,
            PHONE,
            EMAIL,
            BIRTH_DATE,
            GENDER,
            ADDRESS
        ) VALUES ( P_FIRST_NAME,
                   P_LAST_NAME,
                   P_PHONE,
                   P_EMAIL,
                   P_BIRTH_DATE,
                   P_GENDER,
                   P_ADDRESS );

        DBMS_OUTPUT.PUT_LINE('Patient inserted successfully.');
    END ADD_PATIENT;

    PROCEDURE UPDATE_PATIENT (
        P_PATIENT_ID IN PATIENT.PATIENT_ID%TYPE,
        P_FIRST_NAME IN PATIENT.FIRST_NAME%TYPE,
        P_LAST_NAME  IN PATIENT.LAST_NAME%TYPE,
        P_PHONE      IN PATIENT.PHONE%TYPE,
        P_EMAIL      IN PATIENT.EMAIL%TYPE,
        P_BIRTH_DATE IN PATIENT.BIRTH_DATE%TYPE,
        P_GENDER     IN PATIENT.GENDER%TYPE,
        P_ADDRESS    IN PATIENT.ADDRESS%TYPE
    ) AS
    BEGIN
        UPDATE PATIENT
        SET
            FIRST_NAME = P_FIRST_NAME,
            LAST_NAME = P_LAST_NAME,
            PHONE = P_PHONE,
            EMAIL = P_EMAIL,
            BIRTH_DATE = P_BIRTH_DATE,
            GENDER = P_GENDER,
            ADDRESS = P_ADDRESS
        WHERE
            PATIENT_ID = P_PATIENT_ID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No patient found with the given ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Patient updated successfully.');
        END IF;

    END UPDATE_PATIENT;

    PROCEDURE DELETE_PATIENT (
        P_PATIENT_ID IN PATIENT.PATIENT_ID%TYPE
    ) AS
    BEGIN
        DELETE FROM PATIENT
        WHERE
            PATIENT_ID = P_PATIENT_ID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No patient found with the given ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Patient deleted successfully.');
        END IF;

    END DELETE_PATIENT;

    -- Medicine operations

    PROCEDURE ADD_MEDICINE (
        P_CATEGORY_ID           IN MEDICINE.CATEGORY_ID%TYPE,
        P_MEDICINE_NAME         IN MEDICINE.MEDICINE_NAME%TYPE,
        P_DOSAGE_FORM           IN MEDICINE.DOSAGE_FORM%TYPE,
        P_STRENGTH              IN MEDICINE.STRENGTH%TYPE,
        P_UNIT_PRICE            IN MEDICINE.UNIT_PRICE%TYPE,
        P_REQUIRES_PRESCRIPTION IN MEDICINE.REQUIRES_PRESCRIPTION%TYPE
    ) AS
    BEGIN
        INSERT INTO MEDICINE (
            CATEGORY_ID,
            MEDICINE_NAME,
            DOSAGE_FORM,
            STRENGTH,
            UNIT_PRICE,
            REQUIRES_PRESCRIPTION
        ) VALUES ( P_CATEGORY_ID,
                   P_MEDICINE_NAME,
                   P_DOSAGE_FORM,
                   P_STRENGTH,
                   P_UNIT_PRICE,
                   P_REQUIRES_PRESCRIPTION );

        DBMS_OUTPUT.PUT_LINE('Medicine inserted successfully.');
    END ADD_MEDICINE;

    PROCEDURE UPDATE_MEDICINE (
        P_MEDICINE_ID           IN MEDICINE.MEDICINE_ID%TYPE,
        P_CATEGORY_ID           IN MEDICINE.CATEGORY_ID%TYPE,
        P_MEDICINE_NAME         IN MEDICINE.MEDICINE_NAME%TYPE,
        P_DOSAGE_FORM           IN MEDICINE.DOSAGE_FORM%TYPE,
        P_STRENGTH              IN MEDICINE.STRENGTH%TYPE,
        P_UNIT_PRICE            IN MEDICINE.UNIT_PRICE%TYPE,
        P_REQUIRES_PRESCRIPTION IN MEDICINE.REQUIRES_PRESCRIPTION%TYPE
    ) AS
    BEGIN
        UPDATE MEDICINE
        SET
            CATEGORY_ID = P_CATEGORY_ID,
            MEDICINE_NAME = P_MEDICINE_NAME,
            DOSAGE_FORM = P_DOSAGE_FORM,
            STRENGTH = P_STRENGTH,
            UNIT_PRICE = P_UNIT_PRICE,
            REQUIRES_PRESCRIPTION = P_REQUIRES_PRESCRIPTION
        WHERE
            MEDICINE_ID = P_MEDICINE_ID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No medicine found with the given ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Medicine updated successfully.');
        END IF;

    END UPDATE_MEDICINE;

    PROCEDURE DELETE_MEDICINE (
        P_MEDICINE_ID IN MEDICINE.MEDICINE_ID%TYPE
    ) AS
    BEGIN
        DELETE FROM MEDICINE
        WHERE
            MEDICINE_ID = P_MEDICINE_ID;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No medicine found with the given ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Medicine deleted successfully.');
        END IF;

    END DELETE_MEDICINE;

    -- Sale operations

    PROCEDURE CREATE_SALE (
        P_PHARMACY_ID     IN SALE.PHARMACY_ID%TYPE,
        P_PATIENT_ID      IN SALE.PATIENT_ID%TYPE,
        P_PRESCRIPTION_ID IN SALE.PRESCRIPTION_ID%TYPE,
        P_SALE_DATE       IN SALE.SALE_DATE%TYPE,
        P_STATUS          IN SALE.STATUS%TYPE,
        P_SALE_ID         OUT SALE.SALE_ID%TYPE
    ) AS
    BEGIN
        INSERT INTO SALE (
            PHARMACY_ID,
            PATIENT_ID,
            PRESCRIPTION_ID,
            SALE_DATE,
            STATUS
        ) VALUES ( P_PHARMACY_ID,
                   P_PATIENT_ID,
                   P_PRESCRIPTION_ID,
                   P_SALE_DATE,
                   P_STATUS ) RETURNING SALE_ID INTO P_SALE_ID;

        DBMS_OUTPUT.PUT_LINE('Sale created successfully. Sale ID: ' || P_SALE_ID);
    END CREATE_SALE;

    PROCEDURE ADD_SALE_ITEM (
        P_SALE_ID    IN SALE_ITEM.SALE_ID%TYPE,
        P_BATCH_ID   IN SALE_ITEM.BATCH_ID%TYPE,
        P_QUANTITY   IN SALE_ITEM.QUANTITY%TYPE,
        P_UNIT_PRICE IN SALE_ITEM.UNIT_PRICE%TYPE
    ) AS
    BEGIN
        INSERT INTO SALE_ITEM (
            SALE_ID,
            BATCH_ID,
            QUANTITY,
            UNIT_PRICE
        ) VALUES ( P_SALE_ID,
                   P_BATCH_ID,
                   P_QUANTITY,
                   P_UNIT_PRICE );

        DBMS_OUTPUT.PUT_LINE('Sale item inserted successfully.');
    END ADD_SALE_ITEM;

    PROCEDURE ADD_PAYMENT (
        P_SALE_ID           IN PAYMENT.SALE_ID%TYPE,
        P_PAYMENT_METHOD_ID IN PAYMENT.PAYMENT_METHOD_ID%TYPE,
        P_AMOUNT            IN PAYMENT.AMOUNT%TYPE,
        P_PAYMENT_DATE      IN PAYMENT.PAYMENT_DATE%TYPE,
        P_PAYMENT_STATUS    IN PAYMENT.PAYMENT_STATUS%TYPE
    ) AS
    BEGIN
        INSERT INTO PAYMENT (
            SALE_ID,
            PAYMENT_METHOD_ID,
            AMOUNT,
            PAYMENT_DATE,
            PAYMENT_STATUS
        ) VALUES ( P_SALE_ID,
                   P_PAYMENT_METHOD_ID,
                   P_AMOUNT,
                   P_PAYMENT_DATE,
                   P_PAYMENT_STATUS );

        DBMS_OUTPUT.PUT_LINE('Payment inserted successfully.');
    END ADD_PAYMENT;

    -- Report operations

    PROCEDURE GET_SALES_REPORT (
        P_START_DATE  IN SALE.SALE_DATE%TYPE,
        P_END_DATE    IN SALE.SALE_DATE%TYPE,
        P_PHARMACY_ID IN SALE.PHARMACY_ID%TYPE,
        P_STATUS      IN SALE.STATUS%TYPE
    ) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- SALES REPORT ---');
        FOR REC IN (
            SELECT
                S.SALE_ID,
                S.SALE_DATE,
                PH.PHARMACY_NAME,
                S.STATUS,
                NVL(PT.FIRST_NAME
                    || ' '
                    || PT.LAST_NAME, 'No Patient') AS PATIENT_NAME,
                NVL(
                    SUM(SI.QUANTITY * SI.UNIT_PRICE),
                    0
                )                              AS SALE_TOTAL
            FROM
                     SALE S
                JOIN PHARMACY  PH ON S.PHARMACY_ID = PH.PHARMACY_ID
                LEFT JOIN PATIENT   PT ON S.PATIENT_ID = PT.PATIENT_ID
                LEFT JOIN SALE_ITEM SI ON S.SALE_ID = SI.SALE_ID
            WHERE
                ( P_START_DATE IS NULL
                  OR S.SALE_DATE >= P_START_DATE )
                AND ( P_END_DATE IS NULL
                      OR S.SALE_DATE <= P_END_DATE )
                AND ( P_PHARMACY_ID IS NULL
                      OR S.PHARMACY_ID = P_PHARMACY_ID )
                AND ( P_STATUS IS NULL
                      OR S.STATUS = P_STATUS )
            GROUP BY
                S.SALE_ID,
                S.SALE_DATE,
                PH.PHARMACY_NAME,
                S.STATUS,
                PT.FIRST_NAME,
                PT.LAST_NAME
            ORDER BY
                S.SALE_DATE,
                S.SALE_ID
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Sale ID: '
                                 || REC.SALE_ID
                                 || ' | Date: '
                                 || TO_CHAR(REC.SALE_DATE, 'YYYY-MM-DD')
                                 || ' | Pharmacy: '
                                 || REC.PHARMACY_NAME
                                 || ' | Patient: '
                                 || REC.PATIENT_NAME
                                 || ' | Status: '
                                 || REC.STATUS
                                 || ' | Total: ' || REC.SALE_TOTAL);
        END LOOP;

    END GET_SALES_REPORT;

    PROCEDURE GET_LOW_STOCK_REPORT (
        P_PHARMACY_ID  IN MEDICINE_BATCH.PHARMACY_ID%TYPE,
        P_MIN_QUANTITY IN MEDICINE_BATCH.CURRENT_QUANTITY%TYPE
    ) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- LOW STOCK REPORT ---');
        FOR REC IN (
            SELECT
                MB.BATCH_ID,
                M.MEDICINE_NAME,
                M.STRENGTH,
                PH.PHARMACY_NAME,
                MB.BATCH_NUMBER,
                MB.CURRENT_QUANTITY,
                MB.EXPIRATION_DATE
            FROM
                     MEDICINE_BATCH MB
                JOIN MEDICINE M ON MB.MEDICINE_ID = M.MEDICINE_ID
                JOIN PHARMACY PH ON MB.PHARMACY_ID = PH.PHARMACY_ID
            WHERE
                    MB.CURRENT_QUANTITY <= P_MIN_QUANTITY
                AND ( P_PHARMACY_ID IS NULL
                      OR MB.PHARMACY_ID = P_PHARMACY_ID )
            ORDER BY
                MB.CURRENT_QUANTITY ASC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Batch ID: '
                                 || REC.BATCH_ID
                                 || ' | Medicine: '
                                 || REC.MEDICINE_NAME
                                 || ' '
                                 || REC.STRENGTH
                                 || ' | Pharmacy: '
                                 || REC.PHARMACY_NAME
                                 || ' | Batch No: '
                                 || REC.BATCH_NUMBER
                                 || ' | Quantity: '
                                 || REC.CURRENT_QUANTITY
                                 || ' | Expiration: ' || TO_CHAR(REC.EXPIRATION_DATE, 'YYYY-MM-DD'));
        END LOOP;

    END GET_LOW_STOCK_REPORT;

    PROCEDURE GET_PRESCRIPTION_REPORT (
        P_PATIENT_ID IN PRESCRIPTION.PATIENT_ID%TYPE,
        P_DOCTOR_ID  IN PRESCRIPTION.DOCTOR_ID%TYPE,
        P_STATUS     IN PRESCRIPTION.STATUS%TYPE
    ) AS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- PRESCRIPTION REPORT ---');
        FOR REC IN (
            SELECT
                PR.PRESCRIPTION_ID,
                PR.PRESCRIPTION_DATE,
                PR.STATUS,
                PT.FIRST_NAME
                || ' '
                || PT.LAST_NAME AS PATIENT_NAME,
                D.FIRST_NAME
                || ' '
                || D.LAST_NAME  AS DOCTOR_NAME,
                PR.DIAGNOSIS
            FROM
                     PRESCRIPTION PR
                JOIN PATIENT PT ON PR.PATIENT_ID = PT.PATIENT_ID
                JOIN DOCTOR  D ON PR.DOCTOR_ID = D.DOCTOR_ID
            WHERE
                ( P_PATIENT_ID IS NULL
                  OR PR.PATIENT_ID = P_PATIENT_ID )
                AND ( P_DOCTOR_ID IS NULL
                      OR PR.DOCTOR_ID = P_DOCTOR_ID )
                AND ( P_STATUS IS NULL
                      OR PR.STATUS = P_STATUS )
            ORDER BY
                PR.PRESCRIPTION_DATE,
                PR.PRESCRIPTION_ID
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Prescription ID: '
                                 || REC.PRESCRIPTION_ID
                                 || ' | Date: '
                                 || TO_CHAR(REC.PRESCRIPTION_DATE, 'YYYY-MM-DD')
                                 || ' | Patient: '
                                 || REC.PATIENT_NAME
                                 || ' | Doctor: '
                                 || REC.DOCTOR_NAME
                                 || ' | Status: '
                                 || REC.STATUS
                                 || ' | Diagnosis: ' || REC.DIAGNOSIS);
        END LOOP;

    END GET_PRESCRIPTION_REPORT;

    -- Duplicate cleanup operation

    PROCEDURE REMOVE_DUPLICATE_PATIENTS AS
        V_DELETED_COUNT NUMBER := 0;
    BEGIN
        FOR DUP_GROUP IN (
            SELECT
                FIRST_NAME,
                LAST_NAME,
                PHONE,
                MIN(PATIENT_ID) AS KEEP_PATIENT_ID
            FROM
                PATIENT
            WHERE
                PHONE IS NOT NULL
            GROUP BY
                FIRST_NAME,
                LAST_NAME,
                PHONE
            HAVING
                COUNT(*) > 1
        ) LOOP
            UPDATE PRESCRIPTION
            SET
                PATIENT_ID = DUP_GROUP.KEEP_PATIENT_ID
            WHERE
                PATIENT_ID IN (
                    SELECT
                        PATIENT_ID
                    FROM
                        PATIENT
                    WHERE
                            FIRST_NAME = DUP_GROUP.FIRST_NAME
                        AND LAST_NAME = DUP_GROUP.LAST_NAME
                        AND PHONE = DUP_GROUP.PHONE
                        AND PATIENT_ID <> DUP_GROUP.KEEP_PATIENT_ID
                );

            UPDATE SALE
            SET
                PATIENT_ID = DUP_GROUP.KEEP_PATIENT_ID
            WHERE
                PATIENT_ID IN (
                    SELECT
                        PATIENT_ID
                    FROM
                        PATIENT
                    WHERE
                            FIRST_NAME = DUP_GROUP.FIRST_NAME
                        AND LAST_NAME = DUP_GROUP.LAST_NAME
                        AND PHONE = DUP_GROUP.PHONE
                        AND PATIENT_ID <> DUP_GROUP.KEEP_PATIENT_ID
                );

            DELETE FROM PATIENT
            WHERE
                    FIRST_NAME = DUP_GROUP.FIRST_NAME
                AND LAST_NAME = DUP_GROUP.LAST_NAME
                AND PHONE = DUP_GROUP.PHONE
                AND PATIENT_ID <> DUP_GROUP.KEEP_PATIENT_ID;

            V_DELETED_COUNT := V_DELETED_COUNT + SQL%ROWCOUNT;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('Duplicate patient cleanup completed. Deleted rows: ' || V_DELETED_COUNT);
    END REMOVE_DUPLICATE_PATIENTS;

END PKG_PHARMACY_SYSTEM;
/