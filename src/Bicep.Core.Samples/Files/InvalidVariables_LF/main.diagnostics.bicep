
// unknown declaration
bad
//@[0:3) [BCP007 (Error)] This declaration type is not recognized. Specify a parameter, variable, resource, or output declaration. |bad|

// incomplete variable declaration #completionTest(0,1,2) -> declarations
var
//@[3:3) [BCP015 (Error)] Expected a variable identifier at this location. ||

// missing identifier #completionTest(4) -> empty
var 
//@[4:4) [BCP015 (Error)] Expected a variable identifier at this location. ||

// incomplete keyword
// #completionTest(0,1) -> declarations
v
//@[0:1) [BCP007 (Error)] This declaration type is not recognized. Specify a parameter, variable, resource, or output declaration. |v|
// #completionTest(0,1,2) -> declarations
va
//@[0:2) [BCP007 (Error)] This declaration type is not recognized. Specify a parameter, variable, resource, or output declaration. |va|

// unassigned variable
var foo
//@[4:7) [BCP028 (Error)] Identifier "foo" is declared multiple times. Remove or rename the duplicates. |foo|
//@[7:7) [BCP018 (Error)] Expected the "=" character at this location. ||

// #completionTest(18,19) -> symbols
var missingValue = 
//@[19:19) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. ||

// malformed identifier
var 2 
//@[4:5) [BCP015 (Error)] Expected a variable identifier at this location. |2|
//@[6:6) [BCP018 (Error)] Expected the "=" character at this location. ||
var $ = 23
//@[4:5) [BCP015 (Error)] Expected a variable identifier at this location. |$|
//@[4:5) [BCP001 (Error)] The following token is not recognized: "$". |$|
var # 33 = 43
//@[4:5) [BCP015 (Error)] Expected a variable identifier at this location. |#|
//@[4:5) [BCP001 (Error)] The following token is not recognized: "#". |#|

// no value assigned
var foo =
//@[4:7) [BCP028 (Error)] Identifier "foo" is declared multiple times. Remove or rename the duplicates. |foo|
//@[9:9) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. ||

// bad =
var badEquals 2
//@[14:15) [BCP018 (Error)] Expected the "=" character at this location. |2|
//@[15:15) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. ||
var badEquals2 3 true
//@[15:16) [BCP018 (Error)] Expected the "=" character at this location. |3|
//@[21:21) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. ||

// malformed identifier but type check should happen regardless
var 2 = x
//@[4:5) [BCP015 (Error)] Expected a variable identifier at this location. |2|
//@[8:9) [BCP062 (Error)] The referenced declaration with name "x" is not valid. |x|

// bad token value
var foo = &
//@[4:7) [BCP028 (Error)] Identifier "foo" is declared multiple times. Remove or rename the duplicates. |foo|
//@[10:11) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. |&|
//@[10:11) [BCP001 (Error)] The following token is not recognized: "&". |&|

// bad value
var foo = *
//@[4:7) [BCP028 (Error)] Identifier "foo" is declared multiple times. Remove or rename the duplicates. |foo|
//@[10:11) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. |*|

// expressions
var bar = x
//@[4:7) [BCP028 (Error)] Identifier "bar" is declared multiple times. Remove or rename the duplicates. |bar|
//@[10:11) [BCP062 (Error)] The referenced declaration with name "x" is not valid. |x|
var bar = foo()
//@[4:7) [BCP028 (Error)] Identifier "bar" is declared multiple times. Remove or rename the duplicates. |bar|
//@[10:13) [BCP059 (Error)] The name "foo" is not a function. |foo|
var x = 2 + !3
//@[4:5) [BCP028 (Error)] Identifier "x" is declared multiple times. Remove or rename the duplicates. |x|
//@[12:14) [BCP044 (Error)] Cannot apply operator "!" to operand of type "int". |!3|
var y = false ? true + 1 : !4
//@[4:5) [BCP028 (Error)] Identifier "y" is declared multiple times. Remove or rename the duplicates. |y|
//@[16:24) [BCP045 (Error)] Cannot apply operator "+" to operands of type "bool" and "int". |true + 1|
//@[27:29) [BCP044 (Error)] Cannot apply operator "!" to operand of type "int". |!4|

// test for array item recovery
var x = [
//@[4:5) [BCP028 (Error)] Identifier "x" is declared multiple times. Remove or rename the duplicates. |x|
  3 + 4
  =
//@[2:3) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. |=|
  !null
//@[2:7) [BCP044 (Error)] Cannot apply operator "!" to operand of type "null". |!null|
]

// test for object property recovery
var y = {
//@[4:5) [BCP028 (Error)] Identifier "y" is declared multiple times. Remove or rename the duplicates. |y|
  =
//@[2:3) [BCP022 (Error)] Expected a property name at this location. |=|
//@[3:3) [BCP018 (Error)] Expected the ":" character at this location. ||
  foo: !2
//@[7:9) [BCP044 (Error)] Cannot apply operator "!" to operand of type "int". |!2|
}

// utcNow and newGuid used outside a param default value
var test = utcNow('u')
//@[11:17) [BCP065 (Error)] Function "utcNow" is not valid at this location. It can only be used in parameter default declarations. |utcNow|
var test2 = newGuid()
//@[12:19) [BCP065 (Error)] Function "newGuid" is not valid at this location. It can only be used in parameter default declarations. |newGuid|

// bad string escape sequence in object key
var test3 = {
  'bad\escape': true
//@[2:14) [BCP022 (Error)] Expected a property name at this location. |'bad\escape'|
//@[6:8) [BCP006 (Error)] The specified escape sequence is not recognized. Only the following escape sequences are allowed: "\$", "\'", "\\", "\n", "\r", "\t", "\u{...}". |\e|
}

// duplicate properties
var testDupe = {
  'duplicate': true
//@[2:13) [BCP025 (Error)] The property "duplicate" is declared multiple times in this object. Remove or rename the duplicate properties. |'duplicate'|
  duplicate: true
//@[2:11) [BCP025 (Error)] The property "duplicate" is declared multiple times in this object. Remove or rename the duplicate properties. |duplicate|
}

// interpolation with type errors in key
var objWithInterp = {
  'ab${nonExistentIdentifier}cd': true
//@[7:28) [BCP057 (Error)] The name "nonExistentIdentifier" does not exist in the current context. |nonExistentIdentifier|
}

// invalid fully qualified function access
var mySum = az.add(1,2)
//@[15:18) [BCP107 (Error)] The function "add" does not exist in namespace "az". |add|
var myConcat = sys.concat('a', az.concat('b', 'c'))
//@[34:40) [BCP107 (Error)] The function "concat" does not exist in namespace "az". |concat|

// invalid string using double quotes
var doubleString = "bad string"
//@[19:20) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. |"|
//@[19:20) [BCP103 (Error)] The following token is not recognized: """. Strings are defined using single quotes in bicep. |"|
//@[30:31) [BCP103 (Error)] The following token is not recognized: """. Strings are defined using single quotes in bicep. |"|

var resourceGroup = ''
var rgName = resourceGroup().name
//@[13:26) [BCP059 (Error)] The name "resourceGroup" is not a function. |resourceGroup|

// this does not work at the resource group scope
var invalidLocationVar = deployment().location
//@[38:46) [BCP053 (Error)] The type "deployment" does not contain property "location". Available properties include "name", "properties". |location|

var invalidEnvironmentVar = environment().aosdufhsad
//@[42:52) [BCP053 (Error)] The type "environment" does not contain property "aosdufhsad". Available properties include "activeDirectoryDataLake", "authentication", "batch", "gallery", "graph", "graphAudience", "media", "name", "portal", "resourceManager", "sqlManagement", "suffixes", "vmImageAliasDoc". |aosdufhsad|
var invalidEnvAuthVar = environment().authentication.asdgdsag
//@[53:61) [BCP053 (Error)] The type "authentication" does not contain property "asdgdsag". Available properties include "audiences", "identityProvider", "loginEndpoint", "tenant". |asdgdsag|

// invalid use of reserved namespace
var az = 1
//@[4:6) [BCP084 (Error)] The symbolic name "az" is reserved. Please use a different symbolic name. Reserved namespaces are "az", "sys". |az|

// cannot assign a variable to a namespace
var invalidNamespaceAssignment = az
//@[33:35) [BCP041 (Error)] Values of type "az" cannot be assigned to a variable. |az|

var objectLiteralType = {
  first: true
  second: false
  third: 42
  fourth: 'test'
  fifth: [
    {
      one: true
    }
    {
      one: false
    }
  ]
  sixth: [
    {
      two: 44
    }
  ]
}

// #completionTest(54) -> objectVarTopLevel
var objectVarTopLevelCompletions = objectLiteralType.f
//@[53:54) [BCP053 (Error)] The type "object" does not contain property "f". Available properties include "fifth", "first", "fourth", "second", "sixth", "third". |f|
// #completionTest(54) -> objectVarTopLevel
var objectVarTopLevelCompletions2 = objectLiteralType.
//@[54:54) [BCP020 (Error)] Expected a function or property name at this location. ||

// this does not produce any completions because mixed array items are of type "any"
// #completionTest(60) -> mixedArrayProperties
var mixedArrayTypeCompletions = objectLiteralType.fifth[0].o
// #completionTest(60) -> mixedArrayProperties
var mixedArrayTypeCompletions2 = objectLiteralType.fifth[0].
//@[60:60) [BCP020 (Error)] Expected a function or property name at this location. ||

// #completionTest(58) -> oneArrayItemProperties
var oneArrayItemCompletions = objectLiteralType.sixth[0].t
//@[57:58) [BCP053 (Error)] The type "object" does not contain property "t". Available properties include "two". |t|
// #completionTest(58) -> oneArrayItemProperties
var oneArrayItemCompletions2 = objectLiteralType.sixth[0].
//@[58:58) [BCP020 (Error)] Expected a function or property name at this location. ||

// #completionTest(65) -> objectVarTopLevelIndexes
var objectVarTopLevelArrayIndexCompletions = objectLiteralType[f]
//@[63:64) [BCP057 (Error)] The name "f" does not exist in the current context. |f|

// #completionTest(58) -> twoIndexPlusSymbols
var oneArrayIndexCompletions = objectLiteralType.sixth[0][]
//@[58:58) [BCP117 (Error)] An empty indexer is not allowed. Specify a valid expression. ||

// Issue 486
var myFloat = 3.14
//@[16:16) [BCP055 (Error)] Cannot access properties of type "int". An "object" type is required. ||
//@[16:16) [BCP020 (Error)] Expected a function or property name at this location. ||
//@[16:18) [BCP019 (Error)] Expected a new line character at this location. |14|

// secure cannot be used as a varaible decorator
@sys.secure()
//@[5:11) [BCP126 (Error)] Function "secure" cannot be used as a variable decorator. |secure|
var something = 1

// #completionTest(1) -> empty
@
//@[1:1) [BCP123 (Error)] Expected a namespace or decorator name at this location. ||
// #completionTest(5) -> empty
@sys.
//@[5:5) [BCP020 (Error)] Expected a function or property name at this location. ||
var anotherThing = true

// invalid identifier character classes
var ☕ = true
//@[4:5) [BCP015 (Error)] Expected a variable identifier at this location. |☕|
//@[4:5) [BCP001 (Error)] The following token is not recognized: "☕". |☕|
var a☕ = true
//@[5:6) [BCP018 (Error)] Expected the "=" character at this location. |☕|
//@[5:6) [BCP001 (Error)] The following token is not recognized: "☕". |☕|
//@[13:13) [BCP009 (Error)] Expected a literal value, an array, an object, a parenthesized expression, or a function call at this location. ||

var missingArrayVariable = [for thing in stuff: 4]
//@[41:46) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|

// loops are only allowed at the top level
var nonTopLevelLoop = {
  notOkHere: [for thing in stuff: 4]
//@[14:17) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
//@[27:32) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|
}

// loops with conditions won't even parse
var noFilteredLoopsInVariables = [for thing in stuff: if]
//@[47:52) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|
//@[54:56) [BCP100 (Error)] The "if" function is not supported. Use the ternary conditional operator instead. |if|

// nested loops are also not allowed
var noNestedVariableLoopsEither = [for thing in stuff: {
//@[48:53) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|
  hello: [for thing in []: 4]
//@[10:13) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
}]

// loops in inner properties of a variable are also not supported
var innerPropertyLoop = {
  a: [for i in range(0,10): i]
//@[6:9) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
}
var innerPropertyLoop2 = {
  b: {
    a: [for i in range(0,10): i]
//@[8:11) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
  }
}

// loops using expressions with a runtime dependency are also not allowed
var keys = listKeys('fake','fake')
var indirection = keys

var runtimeLoop = [for (item, index) in []: indirection]
//@[19:22) [BCP175 (Error)] The variable for-expression body or array expression must be evaluable at the start of the deployment and cannot depend on any values that have not yet been calculated. Variable dependency chain: "indirection" -> "keys". |for|
var runtimeLoop2 = [for (item, index) in indirection.keys: 's']
//@[20:23) [BCP175 (Error)] The variable for-expression body or array expression must be evaluable at the start of the deployment and cannot depend on any values that have not yet been calculated. Variable dependency chain: "indirection" -> "keys". |for|

var zoneInput = []
resource zones 'Microsoft.Network/dnsZones@2018-05-01' = [for (zone, i) in zoneInput: {
  name: zone
  location: az.resourceGroup().location
}]
var inlinedVariable = zones[0].properties.zoneType

var runtimeLoop3 = [for (zone, i) in zoneInput: {
//@[20:23) [BCP175 (Error)] The variable for-expression body or array expression must be evaluable at the start of the deployment and cannot depend on any values that have not yet been calculated. Variable dependency chain: "inlinedVariable". |for|
  a: inlinedVariable
}]

var runtimeLoop4 = [for (zone, i) in zones[0].properties.registrationVirtualNetworks: {
//@[20:23) [BCP175 (Error)] The variable for-expression body or array expression must be evaluable at the start of the deployment and cannot depend on any values that have not yet been calculated. |for|
//@[37:84) [BCP178 (Error)] The for-expression must be evaluable at the start of the deployment, and cannot depend on any values that have not yet been calculated. Accessible properties of zones are "apiVersion", "id", "name", "type". |zones[0].properties.registrationVirtualNetworks|
  a: 0
}]

var notRuntime = concat('a','b')
var evenMoreIndirection = concat(notRuntime, string(moreIndirection))
var moreIndirection = reference('s','s', 'Full')

var myRef = [
  evenMoreIndirection
]
var runtimeLoop5 = [for (item, index) in myRef: 's']
//@[20:23) [BCP175 (Error)] The variable for-expression body or array expression must be evaluable at the start of the deployment and cannot depend on any values that have not yet been calculated. Variable dependency chain: "myRef" -> "evenMoreIndirection" -> "moreIndirection". |for|

// cannot use loops in expressions
var loopExpression = union([for thing in stuff: 4], [for thing in stuff: true])
//@[28:31) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
//@[41:46) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|
//@[53:56) [BCP138 (Error)] For-expressions are not supported in this context. For-expressions may be used as values of resource, module, variable, and output declarations, or values of resource and module properties. |for|
//@[66:71) [BCP057 (Error)] The name "stuff" does not exist in the current context. |stuff|

@batchSize(1)
//@[1:10) [BCP126 (Error)] Function "batchSize" cannot be used as a variable decorator. |batchSize|
var batchSizeMakesNoSenseHere = false


//KeyVault Secret Reference
resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'testkeyvault'
}

var keyVaultSecretVar = kv.getSecret('mySecret')
//@[24:48) [BCP180 (Error)] Function "getSecret" is not valid at this location. It can only be used when directly assigning to a module parameter with a secure decorator. |kv.getSecret('mySecret')|
var keyVaultSecretInterpolatedVar = '${kv.getSecret('mySecret')}'
//@[39:63) [BCP180 (Error)] Function "getSecret" is not valid at this location. It can only be used when directly assigning to a module parameter with a secure decorator. |kv.getSecret('mySecret')|
var keyVaultSecretObjectVar = {
  secret: kv.getSecret('mySecret')
//@[10:34) [BCP180 (Error)] Function "getSecret" is not valid at this location. It can only be used when directly assigning to a module parameter with a secure decorator. |kv.getSecret('mySecret')|
}
var keyVaultSecretArrayVar = [
  kv.getSecret('mySecret')
//@[2:26) [BCP180 (Error)] Function "getSecret" is not valid at this location. It can only be used when directly assigning to a module parameter with a secure decorator. |kv.getSecret('mySecret')|
]
var keyVaultSecretArrayInterpolatedVar = [
  '${kv.getSecret('mySecret')}'
//@[5:29) [BCP180 (Error)] Function "getSecret" is not valid at this location. It can only be used when directly assigning to a module parameter with a secure decorator. |kv.getSecret('mySecret')|
]

