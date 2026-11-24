@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cafe Order Projection'
@Metadata.allowExtensions: true
define root view entity ZC_CafeOrder
  provider contract transactional_query
  as projection on ZI_CafeOrder
{
  key OrderId,
      CustomerId,
      CustomerName,
      OrderDate,
      OrderTime,
      OrderStatus,
      TotalAmt,
      Currency,
      CreatedOn,
      CreatedBy,
      LocalLastChanged,
      /* Associations */
      _Item : redirected to composition child ZC_CafeOrderItem,
      _Customer
}
