@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cafe Order Item Projection'
@Metadata.allowExtensions: true
define view entity ZC_CafeOrderItem
  as projection on ZI_CafeOrderItem
{
  key OrderId,
  key ItemNum,
      ProductId,
      Quantity,
      Unit,
      PriceSold,
      Currency,
      CreatedOn,
      CreatedBy,
      /* Associations */
      _Order : redirected to parent ZC_CafeOrder,
      _Product
}
