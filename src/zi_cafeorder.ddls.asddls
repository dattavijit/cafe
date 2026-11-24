@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Cafe Order'

@ObjectModel.representativeKey: 'OrderId'

define root view entity ZI_CafeOrder
  as select from zcafe_order

  composition [0..*] of ZI_CafeOrderItem as _Item
  association [0..1] to ZI_CafeCustomer  as _Customer on $projection.CustomerId = _Customer.CustomerId

{
  @EndUserText.label: 'Order ID'
  key order_id           as OrderId,

      @EndUserText.label: 'Customer'
      @ObjectModel.text.element: [ 'CustomerName' ]
      customer_id        as CustomerId,

      @EndUserText.label: 'Customer Name'
      _Customer.FullName as CustomerName,

      @EndUserText.label: 'Order Date'
      order_date         as OrderDate,

      @EndUserText.label: 'Order Time'
      order_time         as OrderTime,

      @EndUserText.label: 'Status'
      order_status       as OrderStatus,

      @EndUserText.label: 'Total Amount'
      @Semantics.amount.currencyCode: 'Currency'
      total_amt          as TotalAmt,

      @EndUserText.label: 'Currency'
      currency           as Currency,

      @EndUserText.label: 'Created On'
      erdat              as CreatedOn,

      @EndUserText.label: 'Created By'
      ernam              as CreatedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed as LocalLastChanged,

      _Item,
      _Customer
}
