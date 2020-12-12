CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateOrderKey FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~CalculateOrderKey.

    METHODS CalculateStartDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~StartDate.

    METHODS FillSupplier FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~FillSupplier.



    METHODS MandatoryInitial FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~MandatoryInitial.

    METHODS validateDeliveryType FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateDeliveryType.

    METHODS validateSupplier FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateSupplier.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateCustomer.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD calculateOrderkey.
    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
        FIELDS ( order_id )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_order).

    DELETE lt_order WHERE order_id IS NOT INITIAL.
      CHECK lt_order IS NOT INITIAL.

    "Get max orderID
    SELECT SINGLE FROM zorder
      FIELDS MAX( order_id )
        INTO @DATA(lv_max_orderid).

    "update involved instances
    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS ( order_id )
      WITH VALUE #( FOR ls_order IN lt_order INDEX INTO i (
                           %tky      = ls_order-%tky
                           order_id  = lv_max_orderid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
         FIELDS ( supplier_id  delivery_type )
       WITH CORRESPONDING #( keys )
     RESULT DATA(lt_order_result).

     result = VALUE #( FOR ls_order IN lt_order_result
                         ( %tky = ls_order-%tky
                           %field-supplier_id = COND #( WHEN ls_order-delivery_type = 'S'
                                                                      THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-mandatory  )
                        ) ).

  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITY zi_order\\Order FROM VALUE #(
      FOR <root_key> IN keys ( %tky-order_uuid     = <root_key>-order_uuid
                                 %control = VALUE #( customer_id_l = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_order).

    DATA lt_customer TYPE SORTED TABLE OF zcustom_legal WITH UNIQUE KEY customer_id_l.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_customer = CORRESPONDING #( lt_order DISCARDING DUPLICATES MAPPING customer_id_l = customer_id_l EXCEPT * ).

    DELETE lt_customer WHERE customer_id_l IS INITIAL.
    CHECK lt_customer IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM zcustom_legal FIELDS customer_id_l
      FOR ALL ENTRIES IN @lt_customer
        WHERE customer_id_l = @lt_customer-customer_id_l
          INTO TABLE @DATA(lt_customer_db).

    " Raise msg for non existing customer id
    LOOP AT lt_order INTO DATA(ls_order).
      IF ls_order-customer_id_l IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id_l = ls_order-customer_id_l ] ).
        APPEND VALUE #(  %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #(  %tky = ls_order-%tky
                         %msg      = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '001'
                                             v1        = ls_order-customer_id_l
                                             severity  = if_abap_behv_message=>severity-error )
                          %element-customer_id_l = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateSupplier.

    READ ENTITY zi_order\\Order FROM VALUE #(
      FOR <root_key> IN keys ( %tky-order_uuid     = <root_key>-order_uuid
                                 %control = VALUE #( supplier_id = if_abap_behv=>mk-on
                                                      ) ) )
        RESULT DATA(lt_order).

    DATA lt_supplier TYPE SORTED TABLE OF zsupplier WITH UNIQUE KEY supplier_id.

    " Optimization of DB select: extract distinct non-initial supplier IDs
    lt_supplier = CORRESPONDING #( lt_order DISCARDING DUPLICATES MAPPING supplier_id = supplier_id EXCEPT * ).

    DELETE lt_supplier WHERE supplier_id IS INITIAL.
    CHECK lt_supplier IS NOT INITIAL.

    " Check if supplier ID exist
    SELECT FROM zsupplier FIELDS supplier_id
      FOR ALL ENTRIES IN @lt_supplier
        WHERE supplier_id = @lt_supplier-supplier_id
      INTO TABLE @DATA(lt_supplier_db).

    " Raise msg for non supplier id
    LOOP AT lt_order INTO DATA(ls_order).
      IF ls_order-supplier_id IS NOT INITIAL AND NOT line_exists( lt_supplier_db[ supplier_id = ls_order-supplier_id ] ).
        APPEND VALUE #(  %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #(  %tky = ls_order-%tky
                         %msg      = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '002'
                                             v1        = ls_order-supplier_id
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-supplier_id = if_abap_behv=>mk-on ) TO reported-order.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateDeliveryType.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY order
        FIELDS ( delivery_type )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_order_result).

    LOOP AT lt_order_result INTO DATA(ls_order_result).
      CASE ls_order_result-delivery_type.
        WHEN 'S'.  " Self
        WHEN 'O'.  " Other company

        WHEN OTHERS.
          APPEND VALUE #( %tky = ls_order_result-%tky ) TO failed-order.

          APPEND VALUE #( %tky = ls_order_result-%tky
                          %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '003'
                                             v1        = ls_order_result-delivery_type
                                             severity  = if_abap_behv_message=>severity-error
                                             )
                          %element-delivery_type = if_abap_behv=>mk-on ) TO reported-order.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.



  METHOD CalculateStartDate.
    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
        FIELDS ( begin_date )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_order).

    DELETE lt_order WHERE begin_date IS NOT INITIAL.
    CHECK lt_order IS NOT INITIAL.

    "update involved instances
    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS ( begin_date )
      WITH VALUE #( FOR ls_order IN lt_order INDEX INTO i (
                           %tky      = ls_order-%tky
                           begin_date  = cl_abap_context_info=>get_system_date( ) ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD FillSupplier.
    READ ENTITIES OF zi_order IN LOCAL MODE
        ENTITY Order
          FIELDS ( supplier_id customer_id_l delivery_type )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_order).

    DELETE lt_order WHERE delivery_type <> 'S'.
    CHECK lt_order IS NOT INITIAL.

    "update involved instances
    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS ( supplier_id )
        WITH VALUE #( FOR ls_order IN lt_order INDEX INTO i (
                           %tky      = ls_order-%tky
                           supplier_id  = '0' ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD MandatoryInitial.

    READ ENTITY zi_order\\order
      FROM VALUE #(
        FOR <root_key> IN keys ( %key-order_uuid     = <root_key>-order_uuid
                                    %control = VALUE #( customer_id_l = if_abap_behv=>mk-on
                                  delivery_type = if_abap_behv=>mk-on ) ) )
    RESULT DATA(lt_order).

    LOOP AT lt_order INTO DATA(ls_order).
      IF ls_order-customer_id_l IS INITIAL OR ls_order-delivery_type IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.
        APPEND VALUE #(  %tky = ls_order-%tky
                         %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '000'
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-customer_id_l = if_abap_behv=>mk-on
                         %element-delivery_type = if_abap_behv=>mk-on
                                             ) TO reported-order.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
