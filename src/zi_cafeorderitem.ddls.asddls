@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cafe Order Item'
define view entity ZI_CafeOrderItem
  as select from zcafe_orditm
  association to parent ZI_CafeOrder as _Order
    on $projection.OrderId = _Order.OrderId
  association [0..1] to ZI_CafeProduct as _Product
    on $projection.ProductId = _Product.ProductId
{
  key order_id   as OrderId,
  key item_num   as ItemNum,
      product_id as ProductId,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity   as Quantity,
      unit       as Unit,
      @Semantics.amount.currencyCode: 'Currency'
      price_sold as PriceSold,
      currency   as Currency,
      erdat      as CreatedOn,
      ernam      as CreatedBy,

      _Order,
      _Product
}
