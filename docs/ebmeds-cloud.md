# EBMEDS 2.0 Cloud

## Endpoints

### `POST /api/v1/cds` - Clinical Decision Support

#### Request

##### Headers

| Header          | Value                                                  |
| --------------- | ------------------------------------------------------ |
| `Accept`        | `application/json` OR `application/xml` OR `text/html` |
| `Authorization` | The user HTTP [bearer token](##authentication).        |
| `Content-Type`  | `application/json` OR `application/xml`                |

##### Body

The request payload in the format determined by the `Content-Type` header. The payload format must follow the approppriate EBMEDS request JSON or XML schema.

#### Response

The response is one of the following based on the `Accept` header or the _feedback type_ specified in the request:

- Structural JSON response following the EBMEDS response JSON schema.
- Structural XML response following the EBMEDS response XML schema.
- Visual HTML response for displaying the structural data directly.

### `POST /api/v1/cmr-app` - Comprehensive Medication Review

#### Request

##### Headers

| Header          | Value                                           |
| --------------- | ----------------------------------------------- |
| `Authorization` | The user HTTP [bearer token](##authentication). |
| `Content-Type`  | `application/x-www-form-urlencoded`             |

##### Body

| Key    | Value                                                   |
| ------ | ------------------------------------------------------- |
| `type` | `json` OR `xml`                                         |
| `data` | The request payload in the format determined by `type`. |

The payload format of `data` must follow the approppriate EBMEDS request JSON or XML schema.

#### Response

Visual HTML response containing the Comprehensive Medication Review for the request payload.

### `POST /api/v1/dso-app` - Diagnosis Specific Overview

#### Request

##### Headers

| Header          | Value                                           |
| --------------- | ----------------------------------------------- |
| `Authorization` | The user HTTP [bearer token](##authentication). |
| `Content-Type`  | `application/json` OR `application/xml`         |

##### Body

The request payload in the format determined by the `Content-Type` header. The payload format must follow the approppriate EBMEDS request JSON or XML schema.

#### Response

Visual HTML response containing the Diagnosis Specific Overview for the request payload.

## Authentication

EBMEDS 2.0 Cloud handles authentication by a HTTP bearer token. This token must be included in the header of all requests to the service. Traffic is authenticated using a multitenancy approach, where each user organization has their own set of tokens. Each token is linked to the specific user organization, and is used to determine any possible per-user configuration of the service.

### Example HTTP authorization header

```
Authorization: Bearer 4696b545-5b00-4ebf-80f9-b05e098a174d
```

### Receiving and managing tokens

The management and distribution of tokens is handled directly by Duodecim. The appropriate tokens are created and distributed to the user organization as a part of the integration process. Additional tokens may be created - and existing tokens may be deleted - as necessary.

Please note that any tokens provided by Duodecim are strictly for use between the client application and EBMEDS 2.0 Cloud. Tokens must not be shared.
