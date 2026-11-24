CLASS lhc_orderitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR OrderItem RESULT result.

    METHODS recalcTotalAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~recalcTotalAmount.

    METHODS setPriceSold FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~setPriceSold.

ENDCLASS.

CLASS lhc_orderitem IMPLEMENTATION.

  METHOD get_instance_features.

  ENDMETHOD.

  METHOD recalcTotalAmount.
  ENDMETHOD.

  METHOD setPriceSold.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Order RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS earlynumbering_create_order FOR NUMBERING
      IMPORTING entities FOR CREATE Order.

    METHODS Earlynumbering_Create_item FOR NUMBERING
      IMPORTING entities FOR CREATE Order\_Item.

    METHODS Cancel FOR MODIFY
      IMPORTING keys FOR ACTION Order~Cancel RESULT result.

    METHODS Pay FOR MODIFY
      IMPORTING keys FOR ACTION Order~Pay RESULT result.

    METHODS recalcTotalAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~recalcTotalAmount.

    METHODS setDefaults FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setDefaults.
ENDCLASS.

CLASS lhc_order IMPLEMENTATION.
  METHOD get_global_authorizations.
    " Authorization checks disabled: grant everything
    result = VALUE #( %create = if_abap_behv=>auth-allowed
                      %update = if_abap_behv=>auth-allowed
                      %delete = if_abap_behv=>auth-allowed
                      %action-Pay    = if_abap_behv=>auth-allowed
                      %action-Cancel = if_abap_behv=>auth-allowed ).
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF Zi_CafeOrder
         IN LOCAL MODE
         ENTITY Order
         FIELDS ( OrderStatus )
         WITH CORRESPONDING #( Keys )
         RESULT DATA(orders).

    result = VALUE #( FOR o IN orders
                      ( %tky           = o-%tky
                        %assoc-_Item   = COND #( WHEN o-OrderStatus = 'O' OR o-OrderStatus IS INITIAL
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled )
                        %action-Pay    = COND #( WHEN o-OrderStatus = 'O'
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled )
                        %action-Cancel = COND #( WHEN o-OrderStatus = 'O'
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD earlynumbering_create_order.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      TRY.
          DATA(uuid) = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_uuid_error INTO DATA(lx_exception).
          " If the generation failed then report failed
          APPEND VALUE #( %cid = <entity>-%cid ) TO failed-order.
          APPEND VALUE #(
              %cid = <entity>-%cid
              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                            text     = | Error generating UUID : { lx_exception->get_text( ) }| ) )
                 TO reported-order.
          CONTINUE.
      ENDTRY.
      " else Return the GUID
      APPEND VALUE #( %cid    = <entity>-%cid
                      orderid = uuid ) TO mapped-order.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create_item.
    " Entities->read by \_item->existing
    READ ENTITIES OF ZI_CafeOrder IN LOCAL MODE
         ENTITY Order BY \_Item
         FIELDS ( ItemNum )
         WITH CORRESPONDING #( entities )
         RESULT DATA(existing).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      DATA(max_item_number) = REDUCE i( INIT max = 0
                                        FOR ex IN existing WHERE ( OrderId = <entity>-OrderId )
                                        NEXT max = nmax( val1 = max
                                                         val2 = CONV i( ex-itemnum )  ) ).
      LOOP AT <entity>-%target ASSIGNING FIELD-SYMBOL(<target>).
        max_item_number += 10.
        IF max_item_number > 9999.
          APPEND VALUE #( %cid = <target>-%cid ) TO failed-orderitem.
          APPEND VALUE #( %cid = <target>-%cid
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = |Can not have more than 999 items| ) )
                 TO reported-orderitem.
          CONTINUE.
        ENDIF.
        APPEND VALUE #( %cid    = <target>-%cid
                        orderId = <entity>-OrderId
                        itemnum = max_item_number ) TO mapped-orderitem.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD Cancel.
  ENDMETHOD.

  METHOD Pay.
  ENDMETHOD.

  METHOD recalcTotalAmount.
  ENDMETHOD.

  METHOD setDefaults.
  ENDMETHOD.

ENDCLASS.
