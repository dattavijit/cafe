@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Cafe Order Item'

@ObjectModel.representativeKey: 'ItemNum'

define view entity ZI_CafeOrderItem
  as select from zcafe_orditm

  association        to parent ZI_CafeOrder   as _Order   on $projection.OrderId = _Order.OrderId
  association [0..1] to        ZI_CafeProduct as _Product on $projection.ProductId = _Product.ProductId

{
      @EndUserText.label: 'Order ID'
  key order_id           as OrderId,

      @EndUserText.label: 'Item Number'
  key item_num           as ItemNum,

      @EndUserText.label: 'Product'
      @ObjectModel.text.association: '_Product'
      product_id         as ProductId,

      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity           as Quantity,

      @EndUserText.label: 'Unit'
      unit               as Unit,

      @EndUserText.label: 'Price'
      @Semantics.amount.currencyCode: 'Currency'
      price_sold         as PriceSold,

      currency           as Currency,

      @EndUserText.label: 'Created On'
      erdat              as CreatedOn,

      @EndUserText.label: 'Created By'
      ernam              as CreatedBy,

      @EndUserText.label: 'Last Changed'
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed as LocalLastChanged,

      _Order,
      _Product
}
