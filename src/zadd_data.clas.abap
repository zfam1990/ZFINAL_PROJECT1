CLASS zadd_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZADD_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_custom_legal TYPE TABLE OF zcustom_legal.
    DATA lt_custom_private TYPE TABLE OF zcustom_private.
    DATA lt_supplier TYPE TABLE OF zsupplier.
    DATA lt_device TYPE TABLE OF zdevice.

*   fill internal travel table (itab)
    lt_custom_legal = VALUE #(
      ( customer_id_l = '1' name = 'A1' address = 'Minsk, Nezavicimosty, 58-100' phone_number = '80442869875' responsible_person = 'Kulyeshov Ivan')
      ( customer_id_l = '2' name = 'МТС' address = 'Minsk, Nemiga, 2-54' phone_number = '80298547854' responsible_person = 'Fadeev Daniil')
      ( customer_id_l = '3' name = 'Евросеть' address = 'Minsk, Golodeda, 41-99' phone_number = '8029584456' responsible_person = 'Podobed Pavel')
      ( customer_id_l = '4' name = 'На связи' address = 'Minsk, Tolbuhina, 8-154' phone_number = '80335487122' responsible_person = 'Kulik Anna')
      ( customer_id_l = '5' name = 'Xistore' address = 'Minsk, Rokossovskogo, 142-1' phone_number = '80295874587' responsible_person = 'Baranov Roman')
      ( customer_id_l = '6' name = '21 век' address = 'Minsk, Nezavicimosty, 05-115' phone_number = '80295899965' responsible_person = 'Sushko Anna')
      ( customer_id_l = '7' name = '5 элемент' address = 'Minsk, Lenina, 3-50' phone_number = '80295625587' responsible_person = 'Senko Vladislav')
      ( customer_id_l = '8' name = 'Электросила' address = 'Minsk, Surganova, 112-51' phone_number = '80336547841' responsible_person = 'Komarov Lev')
      ( customer_id_l = '9' name = 'Life' address = 'Minsk, Kalinina, 8-14' phone_number = '80335462121' responsible_person = 'Giro Fedor')
      ( customer_id_l = '10' name = 'Связной' address = 'Minsk, Krasnaya, 15-11' phone_number = '80295621255' responsible_person = 'Solovey Tatyana' ) )
      .

      lt_custom_private = VALUE #(
      ( customer_id_p = '1' first_name = 'Sergey' last_name = 'Somov' address = 'Minsk, Pulihova, 10-69' phone_number = '80445487845')
      ( customer_id_p = '2' first_name = 'Svetlana' last_name = 'Zenko' address = 'Minsk, Yakuba Kolasa, 5-57' phone_number = '80295879565')
      ( customer_id_p = '3' first_name = 'Daniela' last_name = 'Parshuto' address = 'Minsk, Kulikova, 100-169' phone_number = '80335689211')
      ( customer_id_p = '4' first_name = 'Kirill' last_name = 'Litovcev' address = 'Minsk, Plehanova, 20-78' phone_number = '80292547855')
      ( customer_id_p = '5' first_name = 'Vladislav' last_name = 'Muranov' address = 'Minsk, Koshevogo, 54-96' phone_number = '80258754581')
      ( customer_id_p = '6' first_name = 'Pavel' last_name = 'Leonov' address = 'Minsk, Pulihova, 10-69' phone_number = '80445487845')
      ( customer_id_p = '7' first_name = 'Anna' last_name = 'Demidova' address = 'Minsk, Yakuba Kolasa, 5-57' phone_number = '80295879565')
      ( customer_id_p = '8' first_name = 'Natalya' last_name = 'Korneeva' address = 'Minsk, Kulikova, 100-169' phone_number = '80335689211')
      ( customer_id_p = '9' first_name = 'Igor' last_name = 'valuev' address = 'Minsk, Plehanova, 20-78' phone_number = '80292547855')
      ( customer_id_p = '10' first_name = 'Marina' last_name = 'Svetlova' address = 'Minsk, Koshevogo, 54-96' phone_number = '80258754581') )
      .

      lt_supplier = VALUE #(
      ( supplier_id = '0' name = 'Customer company' )
      ( supplier_id = '1' name = 'Фортисплюс' phone_number = '80445487845')
      ( supplier_id = '2' name = 'ПАН ПАН' phone_number = '80445487845')
      ( supplier_id = '3' name = 'Дженти- Спедишн' phone_number = '80445487845')
      ( supplier_id = '4' name = 'Шнайдер' phone_number = '80445487845')
      ( supplier_id = '5' name = 'АльфаМаневр' phone_number = '80445487845')
      ( supplier_id = '7' name = 'Крафттранс' phone_number = '80258452122')
      ( supplier_id = '8' name = 'Бремино групп' phone_number = '80295214587')
      ( supplier_id = '9' name = 'Белтранс Спутник' phone_number = '80332541259')
      ( supplier_id = '10' name = 'Альфа Техно Транс' phone_number = '80332546589')
      ( supplier_id = '11' name = 'Авто Стим' phone_number = '80335412854')
      )
      .

      lt_device = VALUE #(
      ( device_imei = '385124572215695' producer = 'XIAOMI' model = 'Mi8')
      ( device_imei = '385124888215695' producer = 'SIMENS' model = 'P35')
      ( device_imei = '385124557715695' producer = 'NOKIA' model = 'X10')
      ( device_imei = '385124572289110' producer = 'SAMSUNG' model = 'S9')
      ( device_imei = '385124880015695' producer = 'APPLE' model = '7s')
      ( device_imei = '385126384211195' producer = 'XIAOMI' model = 'Mi8')
      ( device_imei = '385124888889195' producer = 'SIMENS' model = 'P35')
      ( device_imei = '385563327715695' producer = 'NOKIA' model = 'X10')
      ( device_imei = '385124572298541' producer = 'SAMSUNG' model = 'S9')
      ( device_imei = '385124896551695' producer = 'APPLE' model = '7s') )
      .

*   delete existing entries in the database table
    DELETE FROM zcustom_legal.
    DELETE FROM zcustom_private.
    DELETE FROM zsupplier.
    DELETE FROM zdevice.

*   insert the new table entries
    INSERT zcustom_legal FROM TABLE @lt_custom_legal.
    INSERT zcustom_private FROM TABLE @lt_custom_private.
    INSERT zsupplier FROM TABLE @lt_supplier.
    INSERT zdevice FROM TABLE @lt_device.

*   output the result as a console message
    out->write( |{ sy-dbcnt } entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
