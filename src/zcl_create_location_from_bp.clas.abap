class ZCL_CREATE_LOCATION_FROM_BP definition
  public
  final
  create public .

public section.

  interfaces /SAPAPO/IF_LOC_CREATE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CREATE_LOCATION_FROM_BP IMPLEMENTATION.


METHOD /sapapo/if_loc_create~det_loc_creation_4_rel_bp.
  RETURN.
ENDMETHOD.
ENDCLASS.
