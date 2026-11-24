CLASS lhc_ZI_CafeCustomer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.



    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Customer RESULT result.
    METHODS setCreated FOR DETERMINE ON SAVE
      IMPORTING keys FOR Customer~setCreated.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Customer.

ENDCLASS.

CLASS lhc_ZI_CafeCustomer IMPLEMENTATION.
  METHOD get_global_authorizations.
    result = VALUE #( %create = if_ABaP_BEHV=>auth-allowed
                      %update = if_ABaP_BEHV=>auth-allowed  ).
  ENDMETHOD.

  METHOD earlynumbering_create.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      TRY.
          INSERT VALUE #( %cid = <entity>-%cid
                          customerid =  cl_system_uuid=>create_uuid_c32_static( ) )
               INTO TABLE mapped-customer.
        CATCH cx_root INTO DATA(lx_root).
          INSERT VALUE #( %cid = <entity>-%cid )
               INTO TABLE failed-customer.
          INSERT VALUE #( %cid = <entity>-%cid
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = lx_root->get_text( ) ) )
               INTO TABLE reported-customer.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD setCreated.
    MODIFY ENTITIES of ZI_CafeCustomer IN LOCAL MODE
        ENTITY Customer
        UPDATE FIELDS ( CreatedBy CreatedOn )
        with VALUE #( for key in Keys
                    ( %tky = key-%tky
                      CreatedOn = cl_abap_context_info=>get_system_date(  )
                      CreatedBy = cl_abap_context_info=>get_user_technical_name(  )  ) ).
  ENDMETHOD.

ENDCLASS.
