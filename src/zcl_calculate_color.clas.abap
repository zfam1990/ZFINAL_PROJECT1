CLASS zcl_calculate_color DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_calculate_color IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF iv_entity <> 'ZC_ORDER_ITEM'.
      RAISE EXCEPTION TYPE zcx_final_project
        EXPORTING
          textid         = zcx_final_project=>entity_not_known
          iv_entity_name = iv_entity.
    ENDIF.

    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      CASE <fs_calc_element>.
        WHEN 'COLOR'.
          APPEND 'BEGINDATE' TO et_requested_orig_elements.
          APPEND 'STATUS' TO et_requested_orig_elements.

*        WHEN 'ANOTHERELEMENT'.
*          APPEND '' ...

        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_final_project
            EXPORTING
              textid         = zcx_final_project=>virtual_element_not_known
              iv_entity_name = iv_entity.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    DATA lt_original_data TYPE STANDARD TABLE OF zc_order_item WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      DATA(lv_term) = lv_today - <fs_original_data>-BeginDate.
      IF <fs_original_data>-Status <> '0002' AND lv_term > 8.
        <fs_original_data>-color = 1.
      ELSEIF <fs_original_data>-Status <> '0002' AND lv_term = 1.
        <fs_original_data>-color = 2.
      ELSEIF <fs_original_data>-Status <> '0002' AND lv_term < 5.
        <fs_original_data>-color = 3.

      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.

ENDCLASS.
