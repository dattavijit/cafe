@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Cafe Customer'

@ObjectModel.representativeKey: 'CustomerId'

define root view entity ZI_CafeCustomer
  as select from zcafe_customer

{
      @EndUserText.label: 'Customer ID'
  key customer_id                                 as CustomerId,

      @EndUserText.label: 'First Name'
      first_name                                  as FirstName,

      @EndUserText.label: 'Last Name'
      last_name                                   as LastName,

      @EndUserText.label: 'Customer'
      @Semantics.text: true
      concat_with_space(first_name, last_name, 1) as FullName,

      @EndUserText.label: 'Email'
      email                                       as Email,

      @EndUserText.label: 'Phone'
      phone                                       as Phone,

      @EndUserText.label: 'Loyalty Points'
      loyalty_pts                                 as LoyaltyPoints,

      @EndUserText.label: 'Created On'
      erdat                                       as CreatedOn,

      @EndUserText.label: 'Created By'
      ernam                                       as CreatedBy
}
