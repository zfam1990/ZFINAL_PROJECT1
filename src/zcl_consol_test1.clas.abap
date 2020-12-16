CLASS zcl_consol_test1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_consol_test1 IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.
            try.
            DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'https://sapes5.sapdevcenter.com/sap/bc/srt/xip/sap/zepm_product_soap/002/epm_product_soap/epm_product_soap').
            data(proxy) = new zco_epm_product_soap(
                            destination = destination
                          ).
            data(request) = value zreq_msg_type( req_msg_type-product = 'HT-1000' ).
            proxy->get_price(
              exporting
                input = request
              importing
                output = data(response)
            ).

           out->write( |{ response-res_msg_type-price } { response-res_msg_type-currency }| ).

            "handle response
          catch cx_soap_destination_error.
            "handle error
          catch cx_ai_system_fault.
            "handle error
          catch zcx_fault_msg_type.
            "handle error
        endtry.


  ENDMETHOD.

ENDCLASS.
