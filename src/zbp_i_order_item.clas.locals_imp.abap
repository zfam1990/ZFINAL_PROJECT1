CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateItemKey FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~CalculateItemKey.

    METHODS MandatoryInitial FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~MandatoryInitial.

    METHODS SetEndDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~SetEndDate.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateCustomer.

    METHODS validateDevice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateDevice.

    METHODS validateServiceType FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateServiceType.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateStatus.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

    METHODS CloseItem FOR MODIFY
      IMPORTING keys FOR ACTION Item~CloseItem RESULT result.

ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.

  METHOD CalculateItemKey.

*    READ ENTITIES OF zi_order IN LOCAL MODE
*      ENTITY Item
*        FIELDS ( item_id  )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_item).
*
*    DELETE lt_item WHERE item_id IS NOT INITIAL.
*    CHECK lt_item IS NOT INITIAL.
*
*    DATA(lv_order_uuid) = lt_item[ 1 ]-order_uuid.
*
*
*    SELECT SINGLE FROM zorder_item
*      FIELDS MAX( item_id )
*      WHERE order_uuid = @lv_order_uuid
*        INTO @DATA(lv_max_itemid).
*
*    MODIFY ENTITIES OF zi_order IN LOCAL MODE
*  ENTITY Item
*    UPDATE FIELDS ( item_id )
*  WITH VALUE #( FOR ls_item IN lt_item INDEX INTO i (
*                       %key      = ls_item-%key
*                       item_id  = lv_max_itemid + i ) )
*REPORTED DATA(lt_reported).


  IF keys IS NOT INITIAL.
      zcl_additional=>calculate_item_id( it_item_uuid = VALUE #(  FOR key IN keys
      ( item_uuid = key-item_uuid ) ) ).

    ENDIF.

  ENDMETHOD.



  METHOD MandatoryInitial.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        FIELDS ( customer_id_p device_imei service_type  status claims )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-customer_id_p IS INITIAL OR ls_item-device_imei IS INITIAL OR
         ls_item-service_type IS INITIAL OR ls_item-status IS INITIAL OR ls_item-claims IS INITIAL.
        APPEND VALUE #( item_uuid  = ls_item-item_uuid ) TO failed-item.
        APPEND VALUE #(  item_uuid = ls_item-item_uuid
                         %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '000'
                                             severity  = if_abap_behv_message=>severity-error )
                         %element-customer_id_p = if_abap_behv=>mk-on
                         %element-device_imei = if_abap_behv=>mk-on
                         %element-service_type = if_abap_behv=>mk-on
                         %element-status = if_abap_behv=>mk-on
                         %element-claims = if_abap_behv=>mk-on ) TO reported-item.
      ENDIF.
      IF ls_item-status = '2'.
            APPEND VALUE #( %key = ls_item-%key ) TO failed-item.

            APPEND VALUE #( %key = ls_item-%key
                            %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                               number    = '008'
                                               v1        = ls_item-status
                                               severity  = if_abap_behv_message=>severity-error
                                               )
                            %element-status = if_abap_behv=>mk-on ) TO reported-item. "Wait
          ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD SetEndDate.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        FIELDS ( status end_date )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).


    DELETE lt_item WHERE status <> '2' OR end_date IS NOT INITIAL.
    CHECK lt_item IS NOT INITIAL.

    "update involved instances
    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        UPDATE FIELDS ( end_date )
        WITH VALUE #( FOR ls_item IN lt_item INDEX INTO i (
                           %key      = ls_item-%key

                           end_date  = cl_abap_context_info=>get_system_date( ) ) )
    REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        FIELDS ( customer_id_p )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    DATA lt_customer TYPE SORTED TABLE OF zcustom_private WITH UNIQUE KEY customer_id_p.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_customer = CORRESPONDING #( lt_item DISCARDING DUPLICATES MAPPING customer_id_p = customer_id_p EXCEPT * ).

    DELETE lt_customer WHERE customer_id_p IS INITIAL.
    CHECK lt_customer IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM zcustom_private FIELDS customer_id_p
      FOR ALL ENTRIES IN @lt_customer
        WHERE customer_id_p = @lt_customer-customer_id_p
      INTO TABLE @DATA(lt_customer_db).

    " Raise msg for non existing customer id
    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-customer_id_p IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id_p = ls_item-customer_id_p ] ).
        APPEND VALUE #(  item_uuid = ls_item-item_uuid ) TO failed-item.
        APPEND VALUE #(  item_uuid = ls_item-item_uuid
                         %msg      = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '001'
                                             v1        = ls_item-customer_id_p
                                             severity  = if_abap_behv_message=>severity-error )
                          %element-customer_id_p = if_abap_behv=>mk-on ) TO reported-item.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDevice.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        FIELDS ( device_imei )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    DATA lt_device TYPE SORTED TABLE OF zdevice WITH UNIQUE KEY device_imei.

    " Optimization of DB select: extract distinct non-initial device IDs
    lt_device = CORRESPONDING #( lt_item DISCARDING DUPLICATES MAPPING device_imei = device_imei EXCEPT * ).
    DELETE lt_device WHERE device_imei IS INITIAL.
    CHECK lt_device IS NOT INITIAL.

    " Check if device ID exist
    SELECT FROM zdevice FIELDS device_imei
      FOR ALL ENTRIES IN @lt_device
        WHERE device_imei = @lt_device-device_imei
      INTO TABLE @DATA(lt_device_db).

    " Raise msg for non existing device id
    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-device_imei IS NOT INITIAL AND NOT line_exists( lt_device_db[ device_imei = ls_item-device_imei ] ).
        APPEND VALUE #(  item_uuid = ls_item-item_uuid ) TO failed-item.
        APPEND VALUE #(  item_uuid = ls_item-item_uuid
                         %msg      = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '004'
                                             v1        = ls_item-device_imei
                                             severity  = if_abap_behv_message=>severity-error )
                          %element-device_imei = if_abap_behv=>mk-on ) TO reported-item.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateServiceType.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        FIELDS ( service_type )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).
      CASE ls_item-service_type.
        WHEN 'W'.
        WHEN 'P'.



        WHEN OTHERS.
          APPEND VALUE #( %key = ls_item-%key ) TO failed-item.

          APPEND VALUE #( %key = ls_item-%key
                          %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '005'
                                             v1        = ls_item-service_type
                                             severity  = if_abap_behv_message=>severity-error
                                             )
                          %element-service_type = if_abap_behv=>mk-on ) TO reported-item.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITIES OF zi_order IN LOCAL MODE
        ENTITY Item
          FIELDS ( status end_date )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).
      CASE ls_item-status.
        WHEN '1'. "Open
        WHEN '3'. "Close
        WHEN '2'.
*          IF ls_item-end_date IS INITIAL.
*            APPEND VALUE #( %key = ls_item-%key ) TO failed-item.
*
*            APPEND VALUE #( %key = ls_item-%key
*                            %msg = new_message( id        = 'ZM_TRAVEL_M_017'
*                                               number    = '008'
*                                               v1        = ls_item-status
*                                               severity  = if_abap_behv_message=>severity-error
*                                               )
*                            %element-status = if_abap_behv=>mk-on ) TO reported-item. "Wait
*          ENDIF.
        WHEN OTHERS.
          APPEND VALUE #( %key = ls_item-%key ) TO failed-item.

          APPEND VALUE #( %key = ls_item-%key
                          %msg = new_message( id        = 'ZM_TRAVEL_M_017'
                                             number    = '006'
                                             v1        = ls_item-status
                                             severity  = if_abap_behv_message=>severity-error
                                             )
                          %element-status = if_abap_behv=>mk-on ) TO reported-item.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY item
         FIELDS ( status end_date )
           WITH CORRESPONDING #( keys )
        RESULT    DATA(lt_item).

    result = VALUE #( FOR ls_item IN lt_item
                       ( %key                   = ls_item-%key

                         %features-%action-CloseItem = COND #( WHEN ls_item-status = '2'
                                                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                         %features-%field-status = COND #( WHEN ls_item-status = '2'
                                                                    THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted  )
                      ) ).

  ENDMETHOD.

  METHOD CloseItem.

    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        UPDATE FROM VALUE #(
          FOR key IN keys ( item_uuid = key-item_uuid
                            status = '2' " Close
                            end_date = cl_abap_context_info=>get_system_date( )
                            %control-status = if_abap_behv=>mk-on
                            %control-end_date = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zi_order IN LOCAL MODE
      ENTITY item
        FROM VALUE #(
          FOR key IN keys (  item_uuid = key-item_uuid
                             %control = VALUE #(
                             device_imei = if_abap_behv=>mk-on
                             customer_id_p = if_abap_behv=>mk-on
                             service_type = if_abap_behv=>mk-on
                             status = if_abap_behv=>mk-on
                             claims = if_abap_behv=>mk-on
                             end_date = if_abap_behv=>mk-on
                             last_changed_at = if_abap_behv=>mk-on
                                          ) ) )
    RESULT DATA(lt_item).

    result = VALUE #( FOR item IN lt_item ( item_uuid = item-item_uuid
                                            %param    = item
                                              ) ).

  ENDMETHOD.


ENDCLASS.
