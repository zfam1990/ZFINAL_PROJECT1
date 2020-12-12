CLASS zcl_additional DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF st_item_uuid,
             item_uuid TYPE  sysuuid_x16,
           END OF st_item_uuid.
    TYPES: BEGIN OF st_order_uuid,
             order_uuid TYPE  sysuuid_x16,
           END OF st_order_uuid.
    TYPES tt_order_reported            TYPE TABLE FOR REPORTED zi_order.
    TYPES tt_item_reported           TYPE TABLE FOR REPORTED  zi_order_item.
    TYPES tt_item_modify           TYPE TABLE FOR UPDATE  zi_order_item.
    TYPES tt_item_uuid                 TYPE TABLE OF st_item_uuid.
*    TYPES: BEGIN OF st_range_table,
*         sign   TYPE c LENGTH 1,
*         option TYPE c LENGTH 2,
*         low    TYPE sysuuid_x16,
*         high   TYPE sysuuid_x16,
*       END OF st_range_table.
    TYPES tt_range_table TYPE RANGE OF sysuuid_x16.




    CLASS-METHODS calculate_item_id
      IMPORTING it_item_uuid TYPE tt_item_uuid.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_additional IMPLEMENTATION.

  METHOD calculate_item_id.

    DATA: lt_item_modify  TYPE tt_item_modify.
    DATA: lv_order_max_item TYPE zorder_item-item_id.

    IF it_item_uuid IS INITIAL.
      RETURN.
    ENDIF.

*   Read travel instance data
    READ ENTITIES OF zi_order
         ENTITY item
               FROM VALUE #( FOR is_item_uuid IN it_item_uuid (
                                item_uuid = is_item_uuid-item_uuid
                                %control-order_uuid  = if_abap_behv=>mk-on
                                %control-item_id  = if_abap_behv=>mk-on
                                 ) )
         RESULT   DATA(lt_read_item).


    DATA lt_order_keys TYPE SORTED TABLE OF st_order_uuid WITH UNIQUE KEY order_uuid.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_order_keys = CORRESPONDING #( lt_read_item DISCARDING DUPLICATES MAPPING order_uuid = order_uuid EXCEPT * ).

*    select DISTINCT
*    'I' as sign,
*    'EQ' as option,
*     order_uuid as low,
*     ' ' as high
*     from @lt_order_keys as o
*     into TABLE @data(lt_range_order_keys).



      DATA(lt_range_order_keys) = VALUE tt_range_table(
                                    FOR ls_order_keys IN lt_order_keys INDEX INTO i
                                      ( sign = 'I' option = 'EQ' low = ls_order_keys-order_uuid high = ' ') ).





*         READ ENTITIES OF zi_order
*         ENTITY order BY \_item
*               FROM VALUE #( FOR is_item_uuid IN it_item_uuid (
*                                item_uuid = is_item_uuid-item_uuid
*                                %control-order_uuid  = if_abap_behv=>mk-on
*                                 ) )
*         RESULT   DATA(lt_order_keys).

    SELECT
      FROM zorder_item
        FIELDS MAX( item_id ) AS max_item, order_uuid
          WHERE order_uuid IN @lt_range_order_keys
        GROUP BY order_uuid
      INTO TABLE @DATA(lt_max_item_keys).

    LOOP AT lt_read_item INTO DATA(ls_read_item)
        GROUP BY ls_read_item-order_uuid INTO DATA(lv_order_uuid).

      IF lt_max_item_keys IS INITIAL OR lt_max_item_keys[ order_uuid = lv_order_uuid ] IS INITIAL.
        lv_order_max_item = '0'.
      ELSE.
        lv_order_max_item = lt_max_item_keys[ order_uuid = lv_order_uuid ]-max_item.
      ENDIF.

      LOOP AT GROUP lv_order_uuid INTO DATA(ls_item_result).

        APPEND VALUE #( order_uuid = lv_order_uuid item_uuid = ls_item_result-item_uuid item_id = lv_order_max_item + sy-index
          %control-item_id = if_abap_behv=>mk-on ) TO lt_item_modify.

      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zi_order IN LOCAL MODE
      ENTITY Item
        UPDATE FIELDS ( item_id )
      WITH lt_item_modify.

  ENDMETHOD.
ENDCLASS.
