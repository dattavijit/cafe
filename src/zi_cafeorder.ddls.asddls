@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cafe Order'
@ObjectModel.representativeKey: 'OrderId'
define root view entity ZI_CafeOrder
  as select from zcafe_order
  composition [0..*] of ZI_CafeOrderItem as _Item
  association [0..1] to ZI_CafeCustomer as _Customer
    on $projection.CustomerId = _Customer.CustomerId
{
  key order_id     as OrderId,
      customer_id  as CustomerId,
      order_date   as OrderDate,
      order_time   as OrderTime,
      order_status as OrderStatus,
      @Semantics.amount.currencyCode: 'Currency'
      total_amt    as TotalAmt,
      currency     as Currency,
      erdat        as CreatedOn,
      ernam        as CreatedBy,

      _Item,
      _Customer
}
