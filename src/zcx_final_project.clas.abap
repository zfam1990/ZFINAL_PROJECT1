CLASS zcx_final_project DEFINITION
  PUBLIC
  INHERITING FROM cx_sadl_exit
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZCM_FINAL_PROJECT',

      BEGIN OF entity_not_known,
        msgid TYPE symsgid VALUE 'ZCM_FINAL_PROJECT',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_ENTITY_NAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF entity_not_known,

      BEGIN OF virtual_element_not_known,
        msgid TYPE symsgid VALUE 'ZCM_FINAL_PROJECT',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF virtual_element_not_known.

    METHODS constructor
      IMPORTING
        textid      LIKE if_t100_message=>t100key OPTIONAL
        previous    LIKE previous OPTIONAL
        iv_entity_name type string.

        data mv_entity_name type string.

*    CLASS-METHODS create_from_system_message
*    RETURNING VALUE(rcx) TYPE REF TO zcx_final_project.





  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_final_project IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( previous = previous ).

    mv_entity_name = iv_entity_name.




    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.


 ENDCLASS.

