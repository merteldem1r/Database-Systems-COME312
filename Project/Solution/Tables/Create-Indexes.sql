-- Medicine and inventory indexes --

CREATE INDEX IDX_MEDICINE_CATEGORY ON
    MEDICINE (
        CATEGORY_ID
    ); -- for joining MEDICINE with MEDICINE_CATEGORY
CREATE INDEX IDX_BATCH_MEDICINE ON
    MEDICINE_BATCH (
        MEDICINE_ID
    ); -- for finding batches of a specific medicine
CREATE INDEX IDX_BATCH_SUPPLIER ON
    MEDICINE_BATCH (
        SUPPLIER_ID
    ); -- for supplier-based inventory reports.
CREATE INDEX IDX_BATCH_PHARMACY ON
    MEDICINE_BATCH (
        PHARMACY_ID
    ); -- for pharmacy-based stock reports
CREATE INDEX IDX_BATCH_EXPIRATION_DATE ON
    MEDICINE_BATCH (
        EXPIRATION_DATE
    ); -- for expired / soon-expiring medicine reports

-- Prescription indexes --
CREATE INDEX IDX_PRESCRIPTION_PATIENT ON
    PRESCRIPTION (
        PATIENT_ID
    ); --- for finding prescriptions of a specific patient
CREATE INDEX IDX_PRESCRIPTION_DOCTOR ON
    PRESCRIPTION (
        DOCTOR_ID
    ); --- for finding prescriptions written by a specific doctor
CREATE INDEX IDX_PRESCRIPTION_STATUS_DATE ON
    PRESCRIPTION (
        STATUS,
        PRESCRIPTION_DATE
    ); --- for filtering prescriptions by status and date

-- Sale indexes --
CREATE INDEX IDX_SALE_PHARMACY ON
    SALE (
        PHARMACY_ID
    ); -- for pharmacy-based sales reports
CREATE INDEX IDX_SALE_PATIENT ON
    SALE (
        PATIENT_ID
    ); -- for finding sales of a specific patient
CREATE INDEX IDX_SALE_DATE ON
    SALE (
        SALE_DATE
    ); -- for date-based sales reports
CREATE INDEX IDX_SALE_STATUS_DATE ON
    SALE (
        STATUS,
        SALE_DATE
    ); -- filtering sales by status and date together (composite index)

-- Sale item indexes --
CREATE INDEX IDX_SALE_ITEM_SALE ON
    SALE_ITEM (
        SALE_ID
    ); -- calculating total amount of a sale
CREATE INDEX IDX_SALE_ITEM_BATCH ON
    SALE_ITEM (
        BATCH_ID
    ); -- tracking which batch was sold

-- Payment indexes --
CREATE INDEX IDX_PAYMENT_METHOD ON
    PAYMENT (
        PAYMENT_METHOD_ID
    ); -- for payment method based reports

-- Stock movement indexes --
CREATE INDEX IDX_STOCK_MOVEMENT_BATCH ON
    STOCK_MOVEMENT (
        BATCH_ID
    ); -- for finding stock history of a specific batch
CREATE INDEX IDX_STOCK_MOVEMENT_DATE ON
    STOCK_MOVEMENT (
        MOVEMENT_DATE
    ); -- for date-based stock movement reports
CREATE INDEX IDX_STOCK_MOVEMENT_REF ON
    STOCK_MOVEMENT (
        REFERENCE_TYPE,
        REFERENCE_ID
    ); -- for finding stock movements related to a sale, adjustment, or expiry