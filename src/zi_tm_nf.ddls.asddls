@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lista de UFs com NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_NF

  as select from /scmtms/d_torrot       as _root    
    inner join      ZI_SD_REMESSA_INFO_DOCS                           as _header on _header.DeliveryDocument = cast ( _root.base_btd_id as vbeln)

    inner join      I_SalesDocumentBasic                              as _SalesDocument on _SalesDocument.SalesDocument = _header.SalesDocument

    inner join      ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                               p_chave2 : 'TIPOS_OV') as _Param         on _Param.parametro = _SalesDocument.SalesDocumentType

    left outer join I_SalesOrder                                      as _SalesOrder    on _SalesOrder.SalesOrder = _header.SalesDocument

    left outer join ZI_SD_CKPT_AGEN_REMESSA_HEADER                    as _Remessa       on  _Remessa.SalesOrder = _header.SalesDocument
                                                                                        and _Remessa.Document   = _header.DeliveryDocument
  //    left outer join ZI_SD_CKPT_AGEN_FATURA                            as _Fatura        on _Fatura.SalesOrder = _Header.DeliveryDocument
    left outer join ZI_SD_REMESSA_INFO_FATURA                         as _Fatura        on _Fatura.SalesOrder = _header.DeliveryDocument

  association [0..1] to I_SalesDistrictText            as _SalesDistrictText on  _SalesDistrictText.SalesDistrict = $projection.SalesDistrict
                                                                             and _SalesDistrictText.Language      = $session.system_language


  association [0..1] to I_DeliveryDocumentItem         as _DeliveryItem      on  _DeliveryItem.DeliveryDocument     = $projection.OutboundDelivery
                                                                             and _DeliveryItem.DeliveryDocumentItem = $projection.OutboundDeliveryFirstItem

  association [0..1] to ZI_SD_REMESSA_INFO_ORDEM_VENDA as _Sales             on  _Sales.SalesDocument = $projection.SalesDocument

  association [0..1] to I_BillingDocument              as _Billing           on  _Billing.BillingDocument = $projection.BillingDocument

  association [0..1] to I_BR_NFDocument                as _NF                on  _NF.BR_NotaFiscal = $projection.BR_NotaFiscal

  association [0..1] to ZI_CA_VH_NFTYPE                as _NFType            on  _NFType.BR_NFType = $projection.BR_NFType

  association [0..1] to ZI_CA_VH_DOCTYP_NF             as _NFDocumentType    on  _NFDocumentType.BR_NFDocumentType = $projection.BR_NFDocumentType

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_INT    as _VendorInt         on  _VendorInt.SalesOrder = $projection.SalesDocument

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_EXT    as _VendorExt         on  _VendorExt.SalesOrder = $projection.SalesDocument

{
  key _header.SalesDocument                                                  as SalesDocument,
  key _header.DeliveryDocument                                               as OutboundDelivery,
  key _root.tor_id                                                           as FreightUnit,
      _VendorInt.Partner                                                     as VendorInt,
      _VendorInt.PartnerName                                                 as VendorIntName,
      _VendorExt.Partner                                                     as VendorExt,
      _VendorExt.PartnerName                                                 as VendorExtName,
      _header.SalesDocumentFirstItem                                         as SalesDocumentFirstItem,
      _header.DeliveryDocumentFirstItem                                      as OutboundDeliveryFirstItem,
      _SalesDocument.SalesDocumentType                                       as SalesOrderType,
      _SalesDocument._SalesDocumentType._Text
      [1:Language = $session.system_language].SalesDocumentTypeName          as SalesOrderTypeName,
      _DeliveryItem._ReferenceSDDocument.RequestedDeliveryDate               as RequestedDeliveryDate,
      _DeliveryItem._ReferenceSDDocument.SoldToParty                         as SoldToParty,
      _DeliveryItem._ReferenceSDDocument._SoldToParty.CustomerFullName       as SoldToPartyName,
      _DeliveryItem._DeliveryDocument.DeliveryBlockReason                    as DeliveryBlockReason,
      _DeliveryItem._DeliveryDocument._DeliveryBlockReason._Text
      [1:Language = $session.system_language].DeliveryBlockReasonText        as DeliveryBlockReasonText,
      _DeliveryItem._ReferenceSDDocument.CreationDate                        as SalesCreationDate,
      _DeliveryItem._ReferenceSDDocument.CreationTime                        as SalesCreationTime,
      _DeliveryItem.Plant                                                    as Plant,
      _DeliveryItem._Plant.PlantName                                         as PlantName,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _DeliveryItem._ReferenceSDDocument.TotalNetAmount                      as TotalNetAmount,
      _DeliveryItem._ReferenceSDDocument.TransactionCurrency                 as TransactionCurrency,
      _header.FreightOrder                                                   as FreightOrder,

      cast(_header.CreatedOn as  tzntstmpl)                                  as CreatedOn,
      _DeliveryItem._DeliveryDocument.OverallGoodsMovementStatus             as OverallGoodsMovementStatus,
      _DeliveryItem._DeliveryDocument._OverallGoodsMovementStatus._Text
      [1:Language = $session.system_language].OverallGoodsMovementStatusDesc as OverallGoodsMovementStatusDesc,
      //      _Header.BillingDocument                                                as BillingDocument,
      _Fatura.Document                                                       as BillingDocument,
      _Billing.AccountingPostingStatus                                       as AccountingPostingStatus,
      _Billing._AccountingPostingStatus._Text
      [1:Language = $session.system_language].AccountingPostingStatusDesc    as AccountingPostingStatusDesc,
      _Billing.BillingDocumentDate                                           as BillingDocumentDate,

      _Billing.BillingDocumentCategory                                       as BillingDocumentCategory,
      _Billing._BillingDocumentCategory._Text
      [1:Language = $session.system_language].BillingDocumentCategoryName    as BillingDocumentCategoryName,
      _Billing.BillingDocumentType                                           as BillingDocumentType,
      _Billing._BillingDocumentType._Text
      [1:Language = $session.system_language].BillingDocumentTypeName        as BillingDocumentTypeName,

      _DeliveryItem._ReferenceSDDocument.SalesDocumentType                   as SalesDocumentType,
      _DeliveryItem._ReferenceSDDocument._SalesDocumentType._Text
      [1:Language = $session.system_language].SalesDocumentTypeName          as SalesDocumentTypeName,
      _DeliveryItem._ReferenceSDDocument.DistributionChannel                 as DistributionChannel,
      _DeliveryItem._ReferenceSDDocument._DistributionChannel._Text
      [1:Language = $session.system_language].DistributionChannelName        as DistributionChannelName,
      _DeliveryItem._ReferenceSDDocument.SalesOffice                         as SalesOffice,
      _DeliveryItem._ReferenceSDDocument._SalesOffice._Text
      [1:Language = $session.system_language].SalesOfficeName                as SalesOfficeName,
      _DeliveryItem._ReferenceSDDocument.SalesGroup                          as SalesGroup,
      _DeliveryItem._ReferenceSDDocument._SalesGroup._Text
      [1:Language = $session.system_language].SalesGroupName                 as SalesGroupName,
      _DeliveryItem._ReferenceSDDocument.CustomerPurchaseOrderDate           as CustomerPurchaseOrderDate,
      _DeliveryItem._DeliveryDocument.CreationDate                           as DeliveryCreationDate,
      _DeliveryItem._DeliveryDocument.CreationTime                           as DeliveryCreationTime,

      _Sales.ItemGrossWeightAvailable                                        as ItemGrossWeightAvailable,
      _Sales.ItemGrossWeightTotal                                            as ItemGrossWeightTotal,
      fltp_to_dec( _Sales.ItemGrossWeightPerc as abap.dec(15,2) )            as ItemGrossWeightPerc,

      case when _Sales.ItemGrossWeightPerc < 25
           then 1    -- Vermelho
           when _Sales.ItemGrossWeightPerc > 75
           then 3    -- Verde
           else 2    -- Amarelo
           end                                                               as ItemGrossWeightPercCrit,

      _DeliveryItem._ReferenceSDDocument.AdditionalCustomerGroup5            as AdditionalCustomerGroup5,
      _DeliveryItem._ReferenceSDDocument._AdditionalCustomerGroup5._Text
      [1:Language = $session.system_language].AdditionalCustomerGroup5Name   as AdditionalCustomerGroup5Name,
      _DeliveryItem._ReferenceSDDocument.OverallDeliveryStatus               as OverallDeliveryStatus,
      _DeliveryItem._ReferenceSDDocument._OverallDeliveryStatus._Text
      [1:Language = $session.system_language].OverallDeliveryStatusDesc      as OverallDeliveryStatusDesc,

      //      _Header.BR_NotaFiscal                                                  as BR_NotaFiscal,
      //      _Header.BR_NFeNumber                                                   as BR_NFeNumber,
      _Fatura.NotaFiscal                                                     as BR_NotaFiscal,
      _Fatura.DocNum                                                         as NotaFiscal,

      _NF.BR_NFType                                                          as BR_NFType,
      _NF.BR_NFDocumentType                                                  as BR_NFDocumentType,
      _NF.BR_NFDirection                                                     as BR_NFDirection,
      _NF._BR_NFDirection._Text
      [1:Language = $session.system_language].BR_NFDirectionDesc             as BR_NFDirectionDesc,
      _NF.BR_NFModel                                                         as BR_NFModel,
      _NF._BR_NFModel._Text
      [1:Language = $session.system_language].BR_NFModelDesc                 as BR_NFModelDesc,
      _NF.CreationDate                                                       as NFCreationDate,
      _NF.CreationTime                                                       as NFCreationTime,

      _SalesOrder.SalesDistrict,
      _SalesDistrictText.SalesDistrictName,

      /* Abstract */
      ''                                                                     as DeliveryBlockReasonNew,

      /* Associations */
      _NFType,
      _NFDocumentType


}
