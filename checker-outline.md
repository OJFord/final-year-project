Outline of a Checker for API-Consumer
=====================================

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
