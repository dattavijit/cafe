@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Cafe Product'

@ObjectModel.representativeKey: 'ProductId'

define view entity ZI_CafeProduct
  as select from zcafe_product

{
  key product_id   as ProductId,

      @Semantics.text: true
      product_name as ProductName,

      category     as Category,

      @Semantics.amount.currencyCode: 'Currency'
      price        as Price,

      currency     as Currency,
      is_active    as IsActive,
      erdat        as CreatedOn,
      ernam        as CreatedBy
}
