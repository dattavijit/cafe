@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Cafe Customer Projection'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_CafeCustomer
  provider contract transactional_query
  as projection on ZI_CafeCustomer

{
  key CustomerId,

      @Search.defaultSearchElement: true
      FirstName,

      @Search.defaultSearchElement: true
      LastName,

      FullName,
      Email,

      @Search.defaultSearchElement: true
      Phone,

      LoyaltyPoints,
      CreatedOn,
      CreatedBy
}
