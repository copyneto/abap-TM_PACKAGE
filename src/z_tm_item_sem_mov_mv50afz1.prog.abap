*&---------------------------------------------------------------------*
*& Include Z_TM_ITEM_SEM_MOV_MV50AFZ1
*&---------------------------------------------------------------------*


*-desconsidera a relevancia do faturamento na remessa devido a determinação de lote

DATA(lt_xlips) = xlips[].

LOOP AT lt_xlips INTO DATA(ls_xlips).
  IF NOT ls_xlips-charg IS INITIAL.
    READ TABLE xlips WITH KEY posnr = ls_xlips-uecha
                          charg = ' '
                          lfimg = 0.
    IF sy-subrc = 0.
      xlips-fkrel =  ' '.
      MODIFY xlips INDEX sy-tabix.
    ENDIF.
  ENDIF.
ENDLOOP.
