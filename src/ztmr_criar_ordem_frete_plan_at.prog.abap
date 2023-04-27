***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Geração de Ordens de Frete para unidades de frete      *
*** AUTOR : Wellington Moraes de Oliveira                            *
*** FUNCIONAL: Jefferosn Alcantara                                   *
*** DATA : 08/11/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
REPORT ztmr_criar_ordem_frete_plan_at.

* Variaveis globais
DATA: gs_types TYPE /scmtms/c_torty,
      gs_tor   TYPE /scmtms/d_torrot,
      gs_likp  TYPE likp.

* Select options
SELECT-OPTIONS: s_type   FOR gs_types-type,
                s_uf     FOR gs_tor-tor_id,
                s_vbeln  FOR gs_likp-vbeln.

PARAMETERS : p_driver TYPE /scmtms/d_torrot-zz_motorista,
             p_tsp    TYPE /scmtms/d_torrot-tspid,
             p_plctrk TYPE /scmtms/d_torite-platenumber,
             p_plctr1 TYPE /scmtms/d_torite-ztrailer1,
             p_plctr2 TYPE /scmtms/d_torite-ztrailer2,
             p_plctr3 TYPE /scmtms/d_torite-ztrailer3.

* Selection screem
START-OF-SELECTION.

************************************************************************
**  Os logs deste job podem ser consultados através da transação SLG1 **
** ou app equivalente. O objeto é ZTM, e o subobjeto é ZOF            **
************************************************************************
  DATA(go_job) = NEW zcltm_process_of( ).
  go_job->process_documents( ir_tipos_fu = s_type[]
                             ir_num_fu   = s_uf[]
                             ir_remessas = s_vbeln[]
                             ir_tsp      = p_tsp
                             ir_driver   = p_driver
                             ir_plctrk   = p_plctrk
                             ir_plctr1   = p_plctr1
                             ir_plctr2   = p_plctr2
                             ir_plctr3   = p_plctr3 ).

  go_job->show_log( ).
