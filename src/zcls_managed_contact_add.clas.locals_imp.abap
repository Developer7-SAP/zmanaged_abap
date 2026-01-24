CLASS lhc_zi_managed_contact_add DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateaddresson FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_managed_contact_add~validateaddresson.

ENDCLASS.

CLASS lhc_zi_managed_contact_add IMPLEMENTATION.

  METHOD validateaddresson.

   data lv_pincode type char6.
   READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
   ENTITY zi_managed_contact_add ALL FIELDS WITH CORRESPONDING #( Keys )
   RESULT DATA(lt_result)
   FAILED DATA(lt_failed)
   REPORTED DATA(lt_reported).

   loop at keys assIGNING field-SYMBOL(<fs_keys>).
   lv_pincode =  Value #( lt_result[ %tky-ContactId = <fs_keys>-%tky-ContactId
                                           %tky-AddressId = <fs_keys>-AddressId ]-Pincode OPTIONAL ) .
    endloop.
    data(lv_length) =  strlen( lv_pincode ).
    if lv_length <> 6.
        LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
          INSERT VALUE #(
              %tky = <ls_key>-%tky
              %msg = new_message(
                   id = 'ZMSG_CONTACT'
                   number = '004'
                  severity = if_abap_behv_message=>severity-error
              )
          ) INTO TABLE reported-zi_managed_contact.
        ENDLOOP.
    endif.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
