"Name: \TY:/SCMTMS/CL_LE_TM_MAP_TTRQ\ME:GOODS_MOVEMENT_IND\SE:END\EI
ENHANCEMENT 0 ZTME_GOODS_MOVMENT_RELEVANT.
*
  IF is_lipsvb-nowab = 'X'.
    ev_goodsmvt_relevance_ind = abap_true.
  ENDIF.
  IF is_lipsvb-bwart IS INITIAL.
    ev_goodsmvt_relevance_ind = abap_true.
  ENDIF.

ENDENHANCEMENT.
