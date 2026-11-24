REPORT zcafe_insert_testdata.
*&---------------------------------------------------------------------*
*& Coffeeshop Test Data Loader
*& Package  : $DATA_GEN  (sub-package of $ZCAFE)
*& Inserts sample records into ZCAFE_CUSTOMER, ZCAFE_PRODUCT,
*&                             ZCAFE_ORDER,    ZCAFE_ORDITM
*& Run in SE38. Safe to re-run -- clears all rows for sy-mandt first.
*& Orders and items also get LOCAL_LAST_CHANGED (etag field) set.
*&---------------------------------------------------------------------*

CONSTANTS:
  gc_cid_alice   TYPE sysuuid_c32 VALUE 'A6FC397997EC4536A7335D6C3E76D374',
  gc_cid_bob     TYPE sysuuid_c32 VALUE 'CE9B8D6347B1415DA7F69E5CEC506227',
  gc_cid_carol   TYPE sysuuid_c32 VALUE '63637A53696E4BCF9EED27861B9841CB',
  gc_cid_david   TYPE sysuuid_c32 VALUE '7D7EB7691D7C418C92BB86B941D5DD3F',
  gc_cid_emma    TYPE sysuuid_c32 VALUE '6F644A463D5D4730904FEF30B75863DB',
  gc_pid_latte   TYPE sysuuid_c32 VALUE '1503BF15EA334E898F50A21DFC149F1D',
  gc_pid_cappucc TYPE sysuuid_c32 VALUE '27B69EDCFDAB44B9A7784F948F50FD93',
  gc_pid_esprsso TYPE sysuuid_c32 VALUE '08ACFEA679A6454EAE3D5E942EA2C026',
  gc_pid_flatwht TYPE sysuuid_c32 VALUE 'A250E25204B54972AE7B8E42D2428B50',
  gc_pid_coldbr  TYPE sysuuid_c32 VALUE '765C488F1DB3460F80E41A94F2B35159',
  gc_pid_icelatt TYPE sysuuid_c32 VALUE '7DDFE2E16CBF4B3AB350843A50F683A4',
  gc_pid_frppcno TYPE sysuuid_c32 VALUE '103BFD0DA10546E7A4B6DF944C1F7C67',
  gc_pid_croisnt TYPE sysuuid_c32 VALUE '65563954B8C24DE7A43E86D6B12F1688',
  gc_pid_blumufn TYPE sysuuid_c32 VALUE 'A77F7BCC5E7140129992C5A04ADAE974',
  gc_pid_sandwch TYPE sysuuid_c32 VALUE '88ED0D9B42E0415D903849C533F8DCCD',
  gc_pid_chocbrn TYPE sysuuid_c32 VALUE '8522258211934655A528AF9D4C3C1656',
  gc_oid_001     TYPE sysuuid_c32 VALUE 'C07BBA24589D486A8BB41FFE2949440A',
  gc_oid_002     TYPE sysuuid_c32 VALUE '640794EC6CAA48168CBF897B5C32BFE3',
  gc_oid_003     TYPE sysuuid_c32 VALUE 'B34A9C2C2FA545B680C791FC092AFDF3',
  gc_oid_004     TYPE sysuuid_c32 VALUE '99F9948975E04FEE9D5E057973115EEF',
  gc_oid_005     TYPE sysuuid_c32 VALUE 'FCEBC8F3EEC840B183CFFCDB41352C73',
  gc_oid_006     TYPE sysuuid_c32 VALUE '9EDE4AE8A6534AA0B6B33A689E23000D'.

PERFORM delete_existing.
PERFORM insert_products.
PERFORM insert_customers.
PERFORM insert_orders.
PERFORM insert_order_items.

WRITE: / '---------------------------------------------'.
WRITE: / 'Test data load complete.'.

*&---------------------------------------------------------------------*
FORM delete_existing.
  DELETE FROM zcafe_orditm.
  DELETE FROM zcafe_order.
  DELETE FROM zcafe_customer.
  DELETE FROM zcafe_product.
  WRITE: / 'Existing records deleted.'.
ENDFORM.

*&---------------------------------------------------------------------*
*& 11 products: 4 COFFEE / 3 COLD / 3 FOOD active + 1 FOOD inactive
*&---------------------------------------------------------------------*
FORM insert_products.
  DATA: lt TYPE STANDARD TABLE OF zcafe_product WITH EMPTY KEY,
        ls TYPE zcafe_product.

  ls-mandt     = sy-mandt.
  ls-erdat     = sy-datum.
  ls-ernam     = sy-uname.
  ls-currency  = 'USD'.
  ls-is_active = 'X'.

  ls-product_id = gc_pid_latte.   ls-product_name = 'Caffe Latte'.       ls-category = 'COFFEE'. ls-price = '4.50'. APPEND ls TO lt.
  ls-product_id = gc_pid_cappucc. ls-product_name = 'Cappuccino'.        ls-category = 'COFFEE'. ls-price = '4.00'. APPEND ls TO lt.
  ls-product_id = gc_pid_esprsso. ls-product_name = 'Espresso'.          ls-category = 'COFFEE'. ls-price = '2.50'. APPEND ls TO lt.
  ls-product_id = gc_pid_flatwht. ls-product_name = 'Flat White'.        ls-category = 'COFFEE'. ls-price = '4.25'. APPEND ls TO lt.
  ls-product_id = gc_pid_coldbr.  ls-product_name = 'Cold Brew Coffee'.  ls-category = 'COLD'.   ls-price = '5.00'. APPEND ls TO lt.
  ls-product_id = gc_pid_icelatt. ls-product_name = 'Iced Latte'.        ls-category = 'COLD'.   ls-price = '4.75'. APPEND ls TO lt.
  ls-product_id = gc_pid_frppcno. ls-product_name = 'Frappuccino'.       ls-category = 'COLD'.   ls-price = '5.50'. APPEND ls TO lt.
  ls-product_id = gc_pid_croisnt. ls-product_name = 'Butter Croissant'.  ls-category = 'FOOD'.   ls-price = '3.50'. APPEND ls TO lt.
  ls-product_id = gc_pid_blumufn. ls-product_name = 'Blueberry Muffin'.  ls-category = 'FOOD'.   ls-price = '3.00'. APPEND ls TO lt.
  ls-product_id = gc_pid_sandwch. ls-product_name = 'Turkey Sandwich'.   ls-category = 'FOOD'.   ls-price = '8.50'. APPEND ls TO lt.
  ls-product_id = gc_pid_chocbrn. ls-product_name = 'Chocolate Brownie'. ls-category = 'FOOD'.   ls-price = '3.25'. ls-is_active = ' '. APPEND ls TO lt.

  INSERT zcafe_product FROM TABLE lt.
  WRITE: / '  Products inserted:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& 5 loyalty customers
*&---------------------------------------------------------------------*
FORM insert_customers.
  DATA: lt TYPE STANDARD TABLE OF zcafe_customer WITH EMPTY KEY,
        ls TYPE zcafe_customer.

  ls-mandt = sy-mandt.
  ls-erdat = sy-datum.
  ls-ernam = sy-uname.

  ls-customer_id = gc_cid_alice. ls-first_name = 'Alice'. ls-last_name = 'Johnson'. ls-email = 'alice.johnson@email.com'. ls-phone = '+1-555-0101'. ls-loyalty_pts = 150. APPEND ls TO lt.
  ls-customer_id = gc_cid_bob.   ls-first_name = 'Bob'.   ls-last_name = 'Martinez'.ls-email = 'bob.martinez@email.com'. ls-phone = '+1-555-0102'. ls-loyalty_pts = 320. APPEND ls TO lt.
  ls-customer_id = gc_cid_carol. ls-first_name = 'Carol'. ls-last_name = 'White'.   ls-email = 'carol.white@email.com'.  ls-phone = '+1-555-0103'. ls-loyalty_pts = 75.  APPEND ls TO lt.
  ls-customer_id = gc_cid_david. ls-first_name = 'David'. ls-last_name = 'Lee'.     ls-email = 'david.lee@email.com'.    ls-phone = '+1-555-0104'. ls-loyalty_pts = 0.   APPEND ls TO lt.
  ls-customer_id = gc_cid_emma.  ls-first_name = 'Emma'.  ls-last_name = 'Chen'.    ls-email = 'emma.chen@email.com'.    ls-phone = '+1-555-0105'. ls-loyalty_pts = 540. APPEND ls TO lt.

  INSERT zcafe_customer FROM TABLE lt.
  WRITE: / '  Customers inserted:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& 6 orders: 3 Paid / 2 Open / 1 Cancelled
*& Totals match the line items below.
*&---------------------------------------------------------------------*
FORM insert_orders.
  DATA: lt TYPE STANDARD TABLE OF zcafe_order WITH EMPTY KEY,
        ls TYPE zcafe_order.

  ls-mandt    = sy-mandt.
  ls-erdat    = sy-datum.
  ls-ernam    = sy-uname.
  ls-currency = 'USD'.
  GET TIME STAMP FIELD ls-local_last_changed.

  ls-order_id = gc_oid_001. ls-customer_id = gc_cid_alice. ls-order_date = '20261001'. ls-order_time = '082500'. ls-order_status = 'P'. ls-total_amt = '8.00'.  APPEND ls TO lt.
  ls-order_id = gc_oid_002. ls-customer_id = gc_cid_bob.   ls-order_date = '20261002'. ls-order_time = '103000'. ls-order_status = 'P'. ls-total_amt = '11.00'. APPEND ls TO lt.
  ls-order_id = gc_oid_003. ls-customer_id = gc_cid_alice. ls-order_date = '20261005'. ls-order_time = '091500'. ls-order_status = 'P'. ls-total_amt = '7.75'.  APPEND ls TO lt.
  ls-order_id = gc_oid_004. ls-customer_id = gc_cid_carol. ls-order_date = '20261007'. ls-order_time = '143000'. ls-order_status = 'O'. ls-total_amt = '5.00'.  APPEND ls TO lt.
  ls-order_id = gc_oid_005. ls-customer_id = gc_cid_bob.   ls-order_date = '20261008'. ls-order_time = '080000'. ls-order_status = 'X'. ls-total_amt = '4.50'.  APPEND ls TO lt.
  ls-order_id = gc_oid_006. ls-customer_id = gc_cid_emma.  ls-order_date = '20261009'. ls-order_time = '120000'. ls-order_status = 'O'. ls-total_amt = '16.25'. APPEND ls TO lt.

  INSERT zcafe_order FROM TABLE lt.
  WRITE: / '  Orders inserted:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Line items -- every order gets 1-3 items, ITEM_NUM in steps of 10
*&---------------------------------------------------------------------*
FORM insert_order_items.
  DATA: lt TYPE STANDARD TABLE OF zcafe_orditm WITH EMPTY KEY,
        ls TYPE zcafe_orditm.

  ls-mandt    = sy-mandt.
  ls-erdat    = sy-datum.
  ls-ernam    = sy-uname.
  ls-unit     = 'EA'.
  ls-currency = 'USD'.
  GET TIME STAMP FIELD ls-local_last_changed.

  ls-order_id = gc_oid_001. ls-item_num = '0010'. ls-product_id = gc_pid_latte.   ls-quantity = 1. ls-price_sold = '4.50'. APPEND ls TO lt.
  ls-order_id = gc_oid_001. ls-item_num = '0020'. ls-product_id = gc_pid_croisnt. ls-quantity = 1. ls-price_sold = '3.50'. APPEND ls TO lt.
  ls-order_id = gc_oid_002. ls-item_num = '0010'. ls-product_id = gc_pid_cappucc. ls-quantity = 2. ls-price_sold = '4.00'. APPEND ls TO lt.
  ls-order_id = gc_oid_002. ls-item_num = '0020'. ls-product_id = gc_pid_blumufn. ls-quantity = 1. ls-price_sold = '3.00'. APPEND ls TO lt.
  ls-order_id = gc_oid_003. ls-item_num = '0010'. ls-product_id = gc_pid_icelatt. ls-quantity = 1. ls-price_sold = '4.75'. APPEND ls TO lt.
  ls-order_id = gc_oid_003. ls-item_num = '0020'. ls-product_id = gc_pid_blumufn. ls-quantity = 1. ls-price_sold = '3.00'. APPEND ls TO lt.
  ls-order_id = gc_oid_004. ls-item_num = '0010'. ls-product_id = gc_pid_coldbr.  ls-quantity = 1. ls-price_sold = '5.00'. APPEND ls TO lt.
  ls-order_id = gc_oid_005. ls-item_num = '0010'. ls-product_id = gc_pid_latte.   ls-quantity = 1. ls-price_sold = '4.50'. APPEND ls TO lt.
  ls-order_id = gc_oid_006. ls-item_num = '0010'. ls-product_id = gc_pid_flatwht. ls-quantity = 1. ls-price_sold = '4.25'. APPEND ls TO lt.
  ls-order_id = gc_oid_006. ls-item_num = '0020'. ls-product_id = gc_pid_sandwch. ls-quantity = 1. ls-price_sold = '8.50'. APPEND ls TO lt.
  ls-order_id = gc_oid_006. ls-item_num = '0030'. ls-product_id = gc_pid_croisnt. ls-quantity = 1. ls-price_sold = '3.50'. APPEND ls TO lt.

  INSERT zcafe_orditm FROM TABLE lt.
  WRITE: / '  Order items inserted:', sy-dbcnt.
ENDFORM.
