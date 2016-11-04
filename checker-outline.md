Outline of the Client Program-Checker
=====================================

The program checker must be designed in a way so as to be runnable at
compile-time. It should inspect HTTP (and perhaps other protocol) requests for
compliance with a schema found to match the requested URL, and determine as far
as possible whether and why the request would fail at run-time. This will
involve checking of (likely constant) parameters such as the request method
(`GET`, `PATCH`, et al.) and type-checking variable data used for e.g. updating
resource attributes.

The table below enumerates the 'official' (the specification allows for custom
extension, e.g. nginx adds a couple) HTTP client errors (`4xx` status codes),
and the proposed method for determining they will occur.

  --------------------------------------------------------------------------------
  Code   Description                 Detection
  ------ --------------------------- ---------------------------------------------
  400    Bad Request                 No unification of request and schema data

  401    Unauthorized                Partially detectable by typing the session

  402    Payment Required            Not detectable

  403    Forbidden                   Not detectable

  404    Not Found                   Schema not found; URI not in schema

  405    Method Not Allowed          Method not in schema\[URI\]

  406    Not Acceptable              Accept header or return type not in schema

  407    Proxy Authentication        Partially detectable by typing the session
         Required                    

  408    Request Timeout             Not detectable

  409    Conflict                    Not detectable

  410    Gone                        URI not in schema

  411    Length Required             Missing Content-Length required by schema

  412    Precondition Failed         Partially detectable by typing the session

  413    Payload Too Large           Partially detectable by examining constant
                                     data

  414    Request-URI Too Long        Extra query parameters not accepted by schema

  415    Unsupported Media Type      Content-\* headers or data type not in schema

  416    Requested Range Not         Not detectable
         Satisfiable                 

  417    Expectation Failed          Not detectable

  418    I'm a teapot                Umm... Not detectable

  421    Misdirected Request         Method & URI combination not in schema

  422    Unprocessable Entity        Not detectable

  423    Locked                      Type session, acquire precondition first

  424    Failed Dependency           Implicitly prevented if entire call-chain
                                     checks

  426    Upgrade Required            Protocol does not match that required by
                                     schema

  428    Precondition Required       Type session, match schema

  429    Too Many Requests           Not detectable

  431    Request Header Fields Too   Partially detectable by examining constant
         Large                       data

  451    Unavailable For Legal       Not detectable
         Reasons                     
  --------------------------------------------------------------------------------

Example
-------

Given some program making HTTP request to a remote service:

``` {#program}
make request:
    url: 'https://example.com/thing'
    method: 'GET'
    data:
        foo: 'bar'
        bar: 'foo'
```

and some schema for the service being contacted:

``` {#schema}
/thing
    PUT {
        foo: '(bar|rab)?'
    }
    POST {
        foo: '.*'
        bar: '.*'
    }
    GET NULL
```

a program-checker may be along the lines:

``` {#checker}
lookup schema for program.url

matched := false
for uri in schema:
    if program.url regex match for uri:
        matched := true
if matched is false:
    ERROR - bad endpoint

if program.method is not in schema[uri]:
    ERROR - invalid method

validated := []
data_schema := schema[uri][program.method].data

// check provided data is correct
for key in program.data:
    if key is not in data_schema:
        ERROR - bad data {key}
    if data_schema[key] is regex:
        if program.data[key] does not match data_schema[key].regex:
            ERROR - bad data {key}
        else:
            validated := {key} | validated
    else:
        if program.data[key].type does not match data_schema[key].type:
            ERROR - bad data {key}
        else:
            validated := {key} | validated

// check required data is provided
for key in data_schema:
    if key is not in validated:
        if data_schema[key] is regex:
            if data_schema[key].regex is not optional:
                ERROR - missing required data
        else:
            ERROR - missing required data
```

where the type matching could be simplified if the schema encoded the
expectation, e.g. by using
[TJSON](https://tonyarcieri.com/introducing-tjson-a-stricter-typed-form-of-json),
and comparing against the types of data given in the language being checked.

Alternatively, something like [JSON-Schema](https://json-schema.org/) could be
used, which has some traction already, and could be inspected for or extended to
include types.

The example program above would error for each key in the data sent, since the
schema expects no data to accompany a `GET` request.
