___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Array Attribute Transformer",
  "description": "Transforms an array of objects into an array of strings, integers, or numbers by extracting values from a specified attribute key.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "selctItemsArraySource",
    "displayName": "Ecommerce Items Array Source (Array of Object)",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "theGA4SourceOption",
        "displayValue": "Use GA4 Ecommerce Items Array"
      },
      {
        "value": "theCustomSourceOption",
        "displayValue": "Use Custom Variable"
      }
    ],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Select the variable containing the items array to be transformed into an array of integers, strings, or numbers."
  },
  {
    "type": "TEXT",
    "name": "theInputArrayVar",
    "displayName": "Items Array Variable",
    "simpleValueType": true,
    "help": "Enter the variable that contains the items array you want to transform.",
    "valueHint": "Example: {{dlv - ecommerce.items}}",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "selctItemsArraySource",
        "paramValue": "theCustomSourceOption",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "theAttributeKey",
    "displayName": "The Attribute Key",
    "simpleValueType": true,
    "help": "Enter the attribute key that you want to retrieve for the transformation.",
    "valueHint": "Example: item_id",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "selectFormatDataType",
    "displayName": "Array Value Format Type",
    "radioItems": [
      {
        "value": "stringDataType",
        "displayValue": "String"
      },
      {
        "value": "integerDataType",
        "displayValue": "Integers"
      },
      {
        "value": "numberDataType",
        "displayValue": "Number"
      }
    ],
    "simpleValueType": true,
    "help": "Select the format of the transformed values."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const getType = require('getType');
const copyFromDataLayer = require('copyFromDataLayer');
const makeInteger = require('makeInteger');
const makeNumber = require('makeNumber');
const makeString = require('makeString');

// Retrieve items array based on selection
let itemsArray = data.selctItemsArraySource === 'theGA4SourceOption' 
  ? copyFromDataLayer('ecommerce.items') 
  : data.theInputArrayVar;

// Validate the retrieved data is an array
if (getType(itemsArray) !== 'array') {
  return [''];
}

const attributeKey = data.theAttributeKey;
const formatType = data.selectFormatDataType;

// Transform the array
const transformedArray = itemsArray.map(function(item) {
  if (!item.hasOwnProperty(attributeKey)) {
    return '';
  }
  
  let value = item[attributeKey];
  
  switch (formatType) {
    case 'integerDataType':
      return makeInteger(value);
    case 'numberDataType':
      let numberValue = makeNumber(value);
      return getType(numberValue) === 'number' ? numberValue : value; // Return original if conversion fails
    case 'stringDataType':
    default:
      return makeString(value);
  }
});

return transformedArray;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ecommerce.items"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2/15/2025, 8:18:48 AM


