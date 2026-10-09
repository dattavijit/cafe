@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cafe Customer'
@ObjectModel.representativeKey: 'CustomerId'
define view entity ZI_CafeCustomer
  as select from zcafe_customer
{
  key customer_id as CustomerId,
      first_name  as FirstName,
      last_name   as LastName,
      email       as Email,
      phone       as Phone,
      loyalty_pts as LoyaltyPoints,
      erdat       as CreatedOn,
      ernam       as CreatedBy
}
