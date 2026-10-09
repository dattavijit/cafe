@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cafe Order Projection'
@Metadata.allowExtensions: true
define root view entity ZC_CafeOrder
  provider contract transactional_query
  as projection on ZI_CafeOrder
{
  key OrderId,
      CustomerId,
      OrderDate,
      OrderTime,
      OrderStatus,
      TotalAmt,
      Currency,
      CreatedOn,
      CreatedBy,
      /* Associations */
      _Item : redirected to composition child ZC_CafeOrderItem,
      _Customer
}
