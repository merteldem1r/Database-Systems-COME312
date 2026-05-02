Smart Pharmacy Inventory and Prescription Management System - Database Systems Project

Main actors/entities

Final Table List:

1. PATIENT
2. DOCTOR
3. PHARMACY
4. SUPPLIER
5. MEDICINE_CATEGORY
6. MEDICINE
7. MEDICINE_BATCH
8. PRESCRIPTION
9. PRESCRIPTION_ITEM
10. SALE
11. SALE_ITEM
12. PAYMENT_METHOD
13. PAYMENT
14. STOCK_MOVEMENT

Core relationships
One patient can have many prescriptions.
One doctor can write many prescriptions.
One prescription can include many medicines.
One medicine can appear in many prescriptions.

One pharmacy can make many sales.
One sale can include many medicines.
One sale has one payment.
One payment uses one payment method.

One supplier can supply many medicine batches.
One medicine can have many batches.
One pharmacy can have many medicine batches.

One medicine category can include many medicines.

One medicine batch can have many stock movements.

Trigger Idea
When a new SALE_ITEM is inserted, the system automatically decreases the quantity of the related MEDICINE_BATCH and inserts a new record into STOCK_MOVEMENT.
Example logic:
SALE_ITEM inserted:
Medicine Batch ID = 5
Quantity Sold = 2
Trigger does:
EDICINE_BATCH.current_quantity decreases by 2
STOCK_MOVEMENT gets a new OUT movement

PL/SQL package idea

One package called:
PKG_PHARMACY_SYSTEM

Inside it, include procedures/functions like:
add_patient
update_patient
delete_patient

add_medicine
update_medicine
delete_medicine

create_prescription
add_prescription_item

create_sale
add_sale_item
delete_sale

get_low_stock_report
get_sales_report
get_prescription_report

remove_duplicate_patients
remove_duplicate_medicines

PROJECT

1. Project Scenario

The Smart Pharmacy Inventory and Prescription Management System is designed to manage pharmacy operations such as medicine inventory, supplier batches, prescriptions, medicine sales, payments, and stock movements. The system stores patient and doctor information, tracks medicines by category and batch, records prescription details, processes medicine sales, and automatically updates inventory levels. It also supports reporting operations such as low-stock medicines, expired batches, sales by date range, prescription history by patient, and supplier-based medicine stock reports.

2. ER diagram from dbdiagram.io
