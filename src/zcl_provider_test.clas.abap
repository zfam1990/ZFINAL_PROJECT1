CLASS zcl_provider_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_provider_test IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA ls_response TYPE zce_test_soap_odata1.
    DATA lt_response TYPE TABLE OF zce_test_soap_odata1.
    types lty_product type zce_test_soap_odata1-product.

    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'https://sapes5.sapdevcenter.com/sap/bc/srt/xip/sap/zepm_product_soap/002/epm_product_soap/epm_product_soap').
        DATA(proxy) = NEW zco_epm_product_soap(
                        destination = destination
                      ).
        DATA(request) = VALUE zreq_msg_type( req_msg_type-product = 'HT-1000' ).
        proxy->get_price(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

        ls_response-product = request-req_msg_type-product .

        ls_response = CORRESPONDING #( response ).

        APPEND  ls_response TO lt_response.

        io_response->set_data( lt_response ).

      CATCH cx_soap_destination_error.
        "handle error
      CATCH cx_ai_system_fault.
        "handle error
      CATCH zcx_fault_msg_type.
        "handle error
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
