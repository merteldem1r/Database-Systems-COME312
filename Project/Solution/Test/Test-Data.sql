-- TEST DATA

-- This script inserts sample data and tests:
-- 1. Package insert procedures
-- 2. Trigger for sale_item -> stock_movement
-- 3. Dynamic report procedures
-- 4. Duplicate patient cleanup procedure

SET SERVEROUTPUT ON;

-- 1. Insert medicine categories

INSERT INTO MEDICINE_CATEGORY (
    CATEGORY_NAME,
    DESCRIPTION
) VALUES ( 'Painkiller',
           'Medicines used to reduce pain.' );

INSERT INTO MEDICINE_CATEGORY (
    CATEGORY_NAME,
    DESCRIPTION
) VALUES ( 'Antibiotic',
           'Medicines used to treat bacterial infections.' );

INSERT INTO MEDICINE_CATEGORY (
    CATEGORY_NAME,
    DESCRIPTION
) VALUES ( 'Vitamin',
           'Supplement products used to support health.' );

INSERT INTO MEDICINE_CATEGORY (
    CATEGORY_NAME,
    DESCRIPTION
) VALUES ( 'Antihistamine',
           'Medicines used for allergy symptoms.' );

-- 2. Insert pharmacies
INSERT INTO PHARMACY (
    PHARMACY_NAME,
    PHONE,
    EMAIL,
    ADDRESS,
    CITY
) VALUES ( 'Central Pharmacy',
           '02120000001',
           'central@pharmacy.com',
           'Kadikoy Main Street No:10',
           'Istanbul' );

INSERT INTO PHARMACY (
    PHARMACY_NAME,
    PHONE,
    EMAIL,
    ADDRESS,
    CITY
) VALUES ( 'Health Plus Pharmacy',
           '02120000002',
           'healthplus@pharmacy.com',
           'Besiktas Avenue No:20',
           'Istanbul' );

-- 3. Insert suppliers
INSERT INTO SUPPLIER (
    SUPPLIER_NAME,
    CONTACT_PERSON,
    PHONE,
    EMAIL,
    ADDRESS,
    CITY
) VALUES ( 'MedSupply Ltd.',
           'Ahmet Demir',
           '02125550101',
           'info@medsupply.com',
           'Industrial Zone No:5',
           'Istanbul' );

INSERT INTO SUPPLIER (
    SUPPLIER_NAME,
    CONTACT_PERSON,
    PHONE,
    EMAIL,
    ADDRESS,
    CITY
) VALUES ( 'PharmaTrade Inc.',
           'Ayse Kaya',
           '02125550102',
           'contact@pharmatrade.com',
           'Pharma Street No:8',
           'Ankara' );

-- 4. Insert payment methods
INSERT INTO PAYMENT_METHOD (
    METHOD_NAME,
    DESCRIPTION
) VALUES ( 'Cash',
           'Payment made by cash.' );

INSERT INTO PAYMENT_METHOD (
    METHOD_NAME,
    DESCRIPTION
) VALUES ( 'Credit Card',
           'Payment made by credit card.' );

INSERT INTO PAYMENT_METHOD (
    METHOD_NAME,
    DESCRIPTION
) VALUES ( 'Insurance',
           'Payment covered by insurance.' );

-- 5. Insert doctors
INSERT INTO DOCTOR (
    FIRST_NAME,
    LAST_NAME,
    SPECIALIZATION,
    PHONE,
    EMAIL,
    LICENSE_NO
) VALUES ( 'Mehmet',
           'Aydin',
           'Internal Medicine',
           '05330000001',
           'mehmet.aydin@hospital.com',
           'DOC-1001' );

INSERT INTO DOCTOR (
    FIRST_NAME,
    LAST_NAME,
    SPECIALIZATION,
    PHONE,
    EMAIL,
    LICENSE_NO
) VALUES ( 'Elif',
           'Yilmaz',
           'Pediatrics',
           '05330000002',
           'elif.yilmaz@hospital.com',
           'DOC-1002' );

-- 6. Insert patients by using package procedures
BEGIN
    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Ali',
        P_LAST_NAME  => 'Kaya',
        P_PHONE      => '05550000001',
        P_EMAIL      => 'ali.kaya@example.com',
        P_BIRTH_DATE => DATE '1998-05-12',
        P_GENDER     => 'Male',
        P_ADDRESS    => 'Istanbul'
    );

    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Zeynep',
        P_LAST_NAME  => 'Demir',
        P_PHONE      => '05550000002',
        P_EMAIL      => 'zeynep.demir@example.com',
        P_BIRTH_DATE => DATE '2001-09-22',
        P_GENDER     => 'Female',
        P_ADDRESS    => 'Ankara'
    );

    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Can',
        P_LAST_NAME  => 'Yildiz',
        P_PHONE      => '05550000003',
        P_EMAIL      => 'can.yildiz@example.com',
        P_BIRTH_DATE => DATE '1995-03-18',
        P_GENDER     => 'Male',
        P_ADDRESS    => 'Izmir'
    );

END;
/

-- 7. Insert medicines by using package procedures

DECLARE
    V_PAINKILLER_ID    MEDICINE_CATEGORY.CATEGORY_ID%TYPE;
    V_ANTIBIOTIC_ID    MEDICINE_CATEGORY.CATEGORY_ID%TYPE;
    V_VITAMIN_ID       MEDICINE_CATEGORY.CATEGORY_ID%TYPE;
    V_ANTIHISTAMINE_ID MEDICINE_CATEGORY.CATEGORY_ID%TYPE;
BEGIN
    SELECT
        CATEGORY_ID
    INTO V_PAINKILLER_ID
    FROM
        MEDICINE_CATEGORY
    WHERE
        CATEGORY_NAME = 'Painkiller';

    SELECT
        CATEGORY_ID
    INTO V_ANTIBIOTIC_ID
    FROM
        MEDICINE_CATEGORY
    WHERE
        CATEGORY_NAME = 'Antibiotic';

    SELECT
        CATEGORY_ID
    INTO V_VITAMIN_ID
    FROM
        MEDICINE_CATEGORY
    WHERE
        CATEGORY_NAME = 'Vitamin';

    SELECT
        CATEGORY_ID
    INTO V_ANTIHISTAMINE_ID
    FROM
        MEDICINE_CATEGORY
    WHERE
        CATEGORY_NAME = 'Antihistamine';

    PKG_PHARMACY_SYSTEM.ADD_MEDICINE(
        P_CATEGORY_ID           => V_PAINKILLER_ID,
        P_MEDICINE_NAME         => 'Parol',
        P_DOSAGE_FORM           => 'Tablet',
        P_STRENGTH              => '500 mg',
        P_UNIT_PRICE            => 35.00,
        P_REQUIRES_PRESCRIPTION => 'N'
    );

    PKG_PHARMACY_SYSTEM.ADD_MEDICINE(
        P_CATEGORY_ID           => V_ANTIBIOTIC_ID,
        P_MEDICINE_NAME         => 'Augmentin',
        P_DOSAGE_FORM           => 'Tablet',
        P_STRENGTH              => '1000 mg',
        P_UNIT_PRICE            => 180.00,
        P_REQUIRES_PRESCRIPTION => 'Y'
    );

    PKG_PHARMACY_SYSTEM.ADD_MEDICINE(
        P_CATEGORY_ID           => V_VITAMIN_ID,
        P_MEDICINE_NAME         => 'Vitamin C',
        P_DOSAGE_FORM           => 'Tablet',
        P_STRENGTH              => '1000 mg',
        P_UNIT_PRICE            => 90.00,
        P_REQUIRES_PRESCRIPTION => 'N'
    );

    PKG_PHARMACY_SYSTEM.ADD_MEDICINE(
        P_CATEGORY_ID           => V_ANTIHISTAMINE_ID,
        P_MEDICINE_NAME         => 'Aerius',
        P_DOSAGE_FORM           => 'Tablet',
        P_STRENGTH              => '5 mg',
        P_UNIT_PRICE            => 120.00,
        P_REQUIRES_PRESCRIPTION => 'Y'
    );

END;
/

-- 8. Insert medicine batches

INSERT INTO MEDICINE_BATCH (
    MEDICINE_ID,
    SUPPLIER_ID,
    PHARMACY_ID,
    BATCH_NUMBER,
    PURCHASE_PRICE,
    CURRENT_QUANTITY,
    EXPIRATION_DATE,
    RECEIVED_DATE
) VALUES ( (
    SELECT
        MEDICINE_ID
    FROM
        MEDICINE
    WHERE
            MEDICINE_NAME = 'Parol'
        AND STRENGTH = '500 mg'
),
           (
               SELECT
                   SUPPLIER_ID
               FROM
                   SUPPLIER
               WHERE
                   SUPPLIER_NAME = 'MedSupply Ltd.'
           ),
           (
               SELECT
                   PHARMACY_ID
               FROM
                   PHARMACY
               WHERE
                   PHARMACY_NAME = 'Central Pharmacy'
           ),
           'BATCH-PAROL-001',
           20.00,
           100,
           DATE '2027-12-31',
           DATE '2026-01-10' );

INSERT INTO MEDICINE_BATCH (
    MEDICINE_ID,
    SUPPLIER_ID,
    PHARMACY_ID,
    BATCH_NUMBER,
    PURCHASE_PRICE,
    CURRENT_QUANTITY,
    EXPIRATION_DATE,
    RECEIVED_DATE
) VALUES ( (
    SELECT
        MEDICINE_ID
    FROM
        MEDICINE
    WHERE
            MEDICINE_NAME = 'Augmentin'
        AND STRENGTH = '1000 mg'
),
           (
               SELECT
                   SUPPLIER_ID
               FROM
                   SUPPLIER
               WHERE
                   SUPPLIER_NAME = 'PharmaTrade Inc.'
           ),
           (
               SELECT
                   PHARMACY_ID
               FROM
                   PHARMACY
               WHERE
                   PHARMACY_NAME = 'Central Pharmacy'
           ),
           'BATCH-AUG-001',
           120.00,
           50,
           DATE '2027-06-30',
           DATE '2026-01-15' );

INSERT INTO MEDICINE_BATCH (
    MEDICINE_ID,
    SUPPLIER_ID,
    PHARMACY_ID,
    BATCH_NUMBER,
    PURCHASE_PRICE,
    CURRENT_QUANTITY,
    EXPIRATION_DATE,
    RECEIVED_DATE
) VALUES ( (
    SELECT
        MEDICINE_ID
    FROM
        MEDICINE
    WHERE
            MEDICINE_NAME = 'Vitamin C'
        AND STRENGTH = '1000 mg'
),
           (
               SELECT
                   SUPPLIER_ID
               FROM
                   SUPPLIER
               WHERE
                   SUPPLIER_NAME = 'MedSupply Ltd.'
           ),
           (
               SELECT
                   PHARMACY_ID
               FROM
                   PHARMACY
               WHERE
                   PHARMACY_NAME = 'Health Plus Pharmacy'
           ),
           'BATCH-VITC-001',
           60.00,
           8,
           DATE '2027-09-30',
           DATE '2026-01-20' );

INSERT INTO MEDICINE_BATCH (
    MEDICINE_ID,
    SUPPLIER_ID,
    PHARMACY_ID,
    BATCH_NUMBER,
    PURCHASE_PRICE,
    CURRENT_QUANTITY,
    EXPIRATION_DATE,
    RECEIVED_DATE
) VALUES ( (
    SELECT
        MEDICINE_ID
    FROM
        MEDICINE
    WHERE
            MEDICINE_NAME = 'Aerius'
        AND STRENGTH = '5 mg'
),
           (
               SELECT
                   SUPPLIER_ID
               FROM
                   SUPPLIER
               WHERE
                   SUPPLIER_NAME = 'PharmaTrade Inc.'
           ),
           (
               SELECT
                   PHARMACY_ID
               FROM
                   PHARMACY
               WHERE
                   PHARMACY_NAME = 'Central Pharmacy'
           ),
           'BATCH-AER-001',
           80.00,
           30,
           DATE '2027-04-30',
           DATE '2026-01-25' );

-- 9. Insert initial stock movement records
-- These records represent stock entering the pharmacy.
INSERT INTO STOCK_MOVEMENT (
    BATCH_ID,
    MOVEMENT_TYPE,
    QUANTITY,
    MOVEMENT_DATE,
    REFERENCE_TYPE,
    REFERENCE_ID,
    DESCRIPTION
)
    SELECT
        BATCH_ID,
        'IN',
        CURRENT_QUANTITY,
        RECEIVED_DATE,
        'BATCH_RECEIVE',
        BATCH_ID,
        'Initial stock received from supplier.'
    FROM
        MEDICINE_BATCH;

-- 10. Insert prescriptions
INSERT INTO PRESCRIPTION (
    PATIENT_ID,
    DOCTOR_ID,
    PRESCRIPTION_DATE,
    DIAGNOSIS,
    STATUS
) VALUES ( (
    SELECT
        PATIENT_ID
    FROM
        PATIENT
    WHERE
        EMAIL = 'ali.kaya@example.com'
),
           (
               SELECT
                   DOCTOR_ID
               FROM
                   DOCTOR
               WHERE
                   LICENSE_NO = 'DOC-1001'
           ),
           DATE '2026-02-05',
           'Bacterial throat infection',
           'ACTIVE' );

INSERT INTO PRESCRIPTION (
    PATIENT_ID,
    DOCTOR_ID,
    PRESCRIPTION_DATE,
    DIAGNOSIS,
    STATUS
) VALUES ( (
    SELECT
        PATIENT_ID
    FROM
        PATIENT
    WHERE
        EMAIL = 'zeynep.demir@example.com'
),
           (
               SELECT
                   DOCTOR_ID
               FROM
                   DOCTOR
               WHERE
                   LICENSE_NO = 'DOC-1002'
           ),
           DATE '2026-02-06',
           'Allergic rhinitis',
           'ACTIVE' );

-- 11. Insert prescription items
INSERT INTO PRESCRIPTION_ITEM (
    PRESCRIPTION_ID,
    MEDICINE_ID,
    QUANTITY,
    DOSAGE_INSTRUCTION,
    DURATION_DAYS
) VALUES ( (
    SELECT
        PRESCRIPTION_ID
    FROM
        PRESCRIPTION
    WHERE
        DIAGNOSIS = 'Bacterial throat infection'
),
           (
               SELECT
                   MEDICINE_ID
               FROM
                   MEDICINE
               WHERE
                       MEDICINE_NAME = 'Augmentin'
                   AND STRENGTH = '1000 mg'
           ),
           1,
           'Take one tablet twice daily after meals.',
           7 );

INSERT INTO PRESCRIPTION_ITEM (
    PRESCRIPTION_ID,
    MEDICINE_ID,
    QUANTITY,
    DOSAGE_INSTRUCTION,
    DURATION_DAYS
) VALUES ( (
    SELECT
        PRESCRIPTION_ID
    FROM
        PRESCRIPTION
    WHERE
        DIAGNOSIS = 'Allergic rhinitis'
),
           (
               SELECT
                   MEDICINE_ID
               FROM
                   MEDICINE
               WHERE
                       MEDICINE_NAME = 'Aerius'
                   AND STRENGTH = '5 mg'
           ),
           1,
           'Take one tablet once daily.',
           10 );

-- 12. Create a sale and add sale items by using package procedures
-- The add_sale_item procedure will fire the trigger.
DECLARE
    V_SALE_ID           SALE.SALE_ID%TYPE;
    V_PHARMACY_ID       PHARMACY.PHARMACY_ID%TYPE;
    V_PATIENT_ID        PATIENT.PATIENT_ID%TYPE;
    V_BATCH_PAROL       MEDICINE_BATCH.BATCH_ID%TYPE;
    V_BATCH_AUG         MEDICINE_BATCH.BATCH_ID%TYPE;
    V_PAYMENT_METHOD_ID PAYMENT_METHOD.PAYMENT_METHOD_ID%TYPE;
BEGIN
    SELECT
        PHARMACY_ID
    INTO V_PHARMACY_ID
    FROM
        PHARMACY
    WHERE
        PHARMACY_NAME = 'Central Pharmacy';

    SELECT
        PATIENT_ID
    INTO V_PATIENT_ID
    FROM
        PATIENT
    WHERE
        EMAIL = 'ali.kaya@example.com';

    SELECT
        BATCH_ID
    INTO V_BATCH_PAROL
    FROM
        MEDICINE_BATCH
    WHERE
        BATCH_NUMBER = 'BATCH-PAROL-001';

    SELECT
        BATCH_ID
    INTO V_BATCH_AUG
    FROM
        MEDICINE_BATCH
    WHERE
        BATCH_NUMBER = 'BATCH-AUG-001';

    SELECT
        PAYMENT_METHOD_ID
    INTO V_PAYMENT_METHOD_ID
    FROM
        PAYMENT_METHOD
    WHERE
        METHOD_NAME = 'Credit Card';

    PKG_PHARMACY_SYSTEM.CREATE_SALE(
        P_PHARMACY_ID     => V_PHARMACY_ID,
        P_PATIENT_ID      => V_PATIENT_ID,
        P_PRESCRIPTION_ID => NULL,
        P_SALE_DATE       => DATE '2026-02-07',
        P_STATUS          => 'COMPLETED',
        P_SALE_ID         => V_SALE_ID
    );

    PKG_PHARMACY_SYSTEM.ADD_SALE_ITEM(
        P_SALE_ID    => V_SALE_ID,
        P_BATCH_ID   => V_BATCH_PAROL,
        P_QUANTITY   => 2,
        P_UNIT_PRICE => 35.00
    );

    PKG_PHARMACY_SYSTEM.ADD_SALE_ITEM(
        P_SALE_ID    => V_SALE_ID,
        P_BATCH_ID   => V_BATCH_AUG,
        P_QUANTITY   => 1,
        P_UNIT_PRICE => 180.00
    );

    PKG_PHARMACY_SYSTEM.ADD_PAYMENT(
        P_SALE_ID           => V_SALE_ID,
        P_PAYMENT_METHOD_ID => V_PAYMENT_METHOD_ID,
        P_AMOUNT            => 250.00,
        P_PAYMENT_DATE      => DATE '2026-02-07',
        P_PAYMENT_STATUS    => 'PAID'
    );

    DBMS_OUTPUT.PUT_LINE('Corrected sale test completed. Sale ID: ' || V_SALE_ID);
END;
/

-- 13. Insert duplicate patients for duplicate cleanup test
-- Duplicate rule in our package:
-- same first_name + last_name + phone

BEGIN
    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Merve',
        P_LAST_NAME  => 'Sahin',
        P_PHONE      => '05559990000',
        P_EMAIL      => 'merve.sahin1@example.com',
        P_BIRTH_DATE => DATE '2000-01-01',
        P_GENDER     => 'Female',
        P_ADDRESS    => 'Istanbul'
    );

    PKG_PHARMACY_SYSTEM.ADD_PATIENT(
        P_FIRST_NAME => 'Merve',
        P_LAST_NAME  => 'Sahin',
        P_PHONE      => '05559990000',
        P_EMAIL      => 'merve.sahin2@example.com',
        P_BIRTH_DATE => DATE '2000-01-01',
        P_GENDER     => 'Female',
        P_ADDRESS    => 'Istanbul'
    );

END;
/

-- 14. Test report procedures

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

-- 15. Check trigger results

-- After the sale items are inserted, Parol stock should decrease by 2,
-- and Augmentin stock should decrease by 1.
SELECT
    MB.BATCH_ID,
    M.MEDICINE_NAME,
    MB.BATCH_NUMBER,
    MB.CURRENT_QUANTITY
FROM
         MEDICINE_BATCH MB
    JOIN MEDICINE M ON MB.MEDICINE_ID = M.MEDICINE_ID
ORDER BY
    MB.BATCH_ID;

-- Trigger should have inserted OUT records into stock_movement.
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

-- 16. Commit test data
COMMIT;