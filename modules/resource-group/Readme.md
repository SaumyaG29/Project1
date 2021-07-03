This is the module where we first provision a resource from Azure.

The output.tf file allows us to definde values in configuration that we want to share with other resources or modules.
As specified in HashiCorp Learn- "The label immediately after the output keyword is the name, which must be a valid identifier. In a root module, this name is displayed to the user; in a child module, it can be used to access the output's value. The value argument takes an expression whose result is to be returned to the user. Any valid expression is allowed as an output value."
