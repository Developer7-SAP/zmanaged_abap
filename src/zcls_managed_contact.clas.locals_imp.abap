CLASS lhc_zi_managed_contact DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_managed_contact RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_managed_contact RESULT result.
    METHODS setstatus FOR MODIFY
      IMPORTING keys FOR ACTION zi_managed_contact~setstatus RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_managed_contact RESULT result.
    METHODS copycontact FOR MODIFY
      IMPORTING keys FOR ACTION zi_managed_contact~copycontact.
    METHODS calculateage FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_managed_contact~calculateage.
    METHODS validatephone FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_managed_contact~validatephone.
    METHODS withpopup FOR MODIFY
      IMPORTING keys FOR ACTION zi_managed_contact~withpopup.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE zi_managed_contact.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zi_managed_contact.

ENDCLASS.

CLASS lhc_zi_managed_contact IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setStatus.
    READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
    ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).



    MODIFY ENTITIES OF zi_managed_contact IN LOCAL MODE
    ENTITY zi_managed_contact
    UPDATE FIELDS ( Active ) WITH VALUE #(
                                          FOR ls_result IN lt_result
                                          (
                                          %tky = ls_result-%tky
                                          Active = COND #( WHEN ls_result-Active = abap_true
                                                           THEN abap_false
                                                           ELSE abap_true
                                                         )
                                           )
                                           )
    FAILED DATA(lt_create_failed)
    REPORTED DATA(lt_reported_failed).



    ""pass the value back to frontend
    result = VALUE #(
      FOR ls_result IN lt_result (
              %tky = ls_result-%tky
              %param = ls_result

              ) ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      INSERT VALUE #(
          %tky = <ls_key>-%tky
          %msg = new_message(
               id = 'ZMSG_CONTACT'
               number = '001'
              severity = if_abap_behv_message=>severity-success
              v1 = 'Status Changed successfully'
          )
      ) INTO TABLE reported-zi_managed_contact.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
      ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
      RESULT DATA(lt_result)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    result = VALUE #(
                    FOR ls_result IN lt_result (
                   %tky = ls_result-%tky

                   %features-%action-setStatus = COND #( WHEN ls_result-active = abap_true
                                                         THEN if_abap_behv=>fc-o-enabled
                                                         ELSE if_abap_behv=>fc-o-disabled
                                                        )
                   %features-%update = COND #( WHEN ls_result-active = abap_true
                                                         THEN if_abap_behv=>fc-o-enabled
                                                         ELSE if_abap_behv=>fc-o-disabled
                                                        )
                                               )
                    ).

  ENDMETHOD.

  METHOD copyContact.

    READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
      ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
      RESULT DATA(lt_result)
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    IF lt_result IS NOT INITIAL.
      MODIFY ENTITIES OF zi_managed_contact IN LOCAL MODE
      ENTITY zi_managed_contact
      CREATE FIELDS (  Firstname     Middlename  Lastname  Gender Dob
                       Age           Telephone    Email    Active
        )
        WITH VALUE #( FOR lwa_contact IN lt_result (
                      %cid = keys[ KEY entity %key = lwa_contact-%key ]-%cid
                      %data = CORRESPONDING #( lwa_contact EXCEPT contactId
                       ) ) )
      MAPPED DATA(lt_mapped)
      FAILED DATA(lt_failed1)
      REPORTED DATA(lt_reported1).
    ENDIF.

    ""pass data back to front end
    mapped-zi_managed_contact = lt_mapped-zi_managed_contact.

  ENDMETHOD.

  METHOD calculateAge.
    READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
   ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
   RESULT DATA(lt_result)
   FAILED DATA(lt_failed)
   REPORTED DATA(lt_reported).

    LOOP AT lt_result INTO DATA(ls_result).
    data(lv_today) = cl_abap_context_info=>get_system_date( ).
    data(lv_final_today) = lv_today(4).
      DATA(lv_age) = lv_final_today  - ls_result-Dob(4).
      IF lv_age = 0 .
        LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
          INSERT VALUE #(
              %tky = <ls_key>-%tky
              %msg = new_message(
                   id = 'ZMSG_CONTACT'
                   number = '002'
                  severity = if_abap_behv_message=>severity-error
              )
          ) INTO TABLE reported-zi_managed_contact.
        ENDLOOP.
      ELSE.
        MODIFY ENTITIES OF zi_managed_contact IN LOCAL MODE
        ENTITY zi_managed_contact
        UPDATE FIELDS ( Age ) WITH VALUE #( (   %tky = ls_result-%tky
                                             %data-Age = lv_age
                                             %control-age = if_abap_behv=>mk-on ) )
        FAILED DATA(lt_final_reported).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD ValidatePhone.
  READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
   ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
   RESULT DATA(lt_result)
   FAILED DATA(lt_failed)
   REPORTED DATA(lt_reported).
    data lv_output type char10.
   loop at lt_result into data(ls_result).
   lv_output = conv #( |{ ls_result-Telephone ALPHA = OUT }| ).
         data(lv_length) = strlen( lv_output ).
         if lv_length <> 10.
         LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
          INSERT VALUE #(
              %tky = <ls_key>-%tky
              %msg = new_message(
                   id = 'ZMSG_CONTACT'
                   number = '003'
                  severity = if_abap_behv_message=>severity-error
              )
          ) INTO TABLE reported-zi_managed_contact.
        ENDLOOP.
         endif.

   endloop.

  ENDMETHOD.

  METHOD withPopup.
  ENDMETHOD.

  METHOD precheck_update.
  loop at entities assIGNING fieLD-SYMBOL(<fs_entities>).
   check
   <fs_entities>-%control-Firstname = if_abap_behv=>mk-on
   or <fs_entities>-%control-Middlename = if_abap_behv=>mk-on
   or <fs_entities>-%control-LastName = if_abap_behv=>mk-on
   or <fs_entities>-%control-Gender = if_abap_behv=>mk-on
   or <fs_entities>-%control-Dob = if_abap_behv=>mk-on
   or <fs_entities>-%control-Email = if_abap_behv=>mk-on
   or <fs_entities>-%control-telephone = if_abap_behv=>mk-on
   or <fs_entities>-%control-active = if_abap_behv=>mk-on.

   if <fs_entities>-%control-email = if_abap_behv=>mk-on.
   append value #( %tky = <fs_entities>-%tky  ) to failed-zi_managed_contact.
   append value #( %tky = <fs_entities>-%tky
                   %msg = new_message(
                   id = 'ZMSG_CONTACT'
                   number = '005'
                  severity = if_abap_behv_message=>severity-error
              )
          ) tO  reported-zi_managed_contact.
   endif.
     if <fs_entities>-%control-middlename = if_abap_behv=>mk-on.
   append value #( %tky = <fs_entities>-%tky  ) to failed-zi_managed_contact.
   append value #( %tky = <fs_entities>-%tky
                   %msg = new_message(
                   id = 'ZMSG_CONTACT'
                   number = '006'
                  severity = if_abap_behv_message=>severity-error
              )
          ) tO  reported-zi_managed_contact.
   endif.
  endloop.
  ENDMETHOD.

  METHOD precheck_delete.
  ENDMETHOD.

ENDCLASS.
