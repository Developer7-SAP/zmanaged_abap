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
                 NUMBER = '001'
                severity = if_abap_behv_message=>severity-success
                v1 = 'Status Changed successfully'
            )
        ) INTO TABLE reported-zi_managed_contact.
endloop.

  ENDMETHOD.

  METHOD get_instance_features.
  READ ENTITIES OF zi_managed_contact  IN LOCAL MODE
    ENTITY zi_managed_contact ALL FIELDS WITH CORRESPONDING #( Keys )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    result = value #(
                    for ls_result in lt_result (
                   %tky = ls_result-%tky
                   %features-%action-setStatus = cond #( when ls_result-active = abap_false
                                                         then if_abap_behv=>fc-o-enabled
                                                         else if_abap_behv=>fc-o-disabled
                                                        )
                                               )
                    ).

  ENDMETHOD.

ENDCLASS.
