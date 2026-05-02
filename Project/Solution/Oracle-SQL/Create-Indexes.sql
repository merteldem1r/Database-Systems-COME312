-- Medicine and inventory indexes --

CREATE INDEX idx_medicine_category
ON medicine(category_id); -- for joining MEDICINE with MEDICINE_CATEGORY

CREATE INDEX idx_batch_medicine
ON medicine_batch(medicine_id); -- for finding batches of a specific medicine

CREATE INDEX idx_batch_supplier
ON medicine_batch(supplier_id); -- for supplier-based inventory reports.

CREATE INDEX idx_batch_pharmacy
ON medicine_batch(pharmacy_id); -- for pharmacy-based stock reports

CREATE INDEX idx_batch_expiration_date
ON medicine_batch(expiration_date); -- for expired / soon-expiring medicine reports

-- Prescription indexes --

CREATE INDEX idx_prescription_patient
ON prescription(patient_id); --- for finding prescriptions of a specific patient

CREATE INDEX idx_prescription_doctor
ON prescription(doctor_id); --- for finding prescriptions written by a specific doctor

CREATE INDEX idx_prescription_status_date
ON prescription(status, prescription_date); --- for filtering prescriptions by status and date

-- Sale indexes --

CREATE INDEX idx_sale_pharmacy
ON sale(pharmacy_id); -- for pharmacy-based sales reports

CREATE INDEX idx_sale_patient
ON sale(patient_id); -- for finding sales of a specific patient

CREATE INDEX idx_sale_date
ON sale(sale_date); -- for date-based sales reports

CREATE INDEX idx_sale_status_date
ON sale(status, sale_date); -- filtering sales by status and date together (composite index)

-- Sale item indexes --

CREATE INDEX idx_sale_item_sale
ON sale_item(sale_id); -- calculating total amount of a sale

CREATE INDEX idx_sale_item_batch
ON sale_item(batch_id); -- tracking which batch was sold

-- Payment indexes --

CREATE INDEX idx_payment_method
ON payment(payment_method_id); -- for payment method based reports

-- Stock movement indexes --

CREATE INDEX idx_stock_movement_batch
ON stock_movement(batch_id); -- for finding stock history of a specific batch

CREATE INDEX idx_stock_movement_date
ON stock_movement(movement_date); -- for date-based stock movement reports

CREATE INDEX idx_stock_movement_ref
ON stock_movement(reference_type, reference_id); -- for finding stock movements related to a sale, adjustment, or expiry