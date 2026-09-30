locals {
  sku_tier = coalesce(var.sku.tier, {
    Free_F1     = "Free"
    Standard_S1 = "Standard"
    Standard_S2 = "Standard"
    Standard_S3 = "Standard"
    Premium_P1  = "Premium"
    Premium_P2  = "Premium"
    Premium_P3  = "Premium"
  }[var.sku.name])
}
