Restricting the Scope for Client Error in IoT Communication
===========================================================

With billions more IoT devices predicted to be connected every year, every
problem in IoT is realised at large scale. The connection of so many devices
inevitably means vendors will iteratively improve their products; change and
improve the deployed software. This rapid iteration may easily lead to
unintended incompatibilities between client and server APIs. Additionally, many
of the devices expected to be deployed will be deeply embedded in their
operating context - light switches, concrete-borne traffic or structural sensors
in roads or buildings, et cetera - such devices have relatively long lifetimes
and may quickly be outdated, but continue attempting to communicate with a
server using that outdated interface. Client-originating communication with a
server may cause errors of great concern to a user, but be visible only to a
vendor examining a server log, who may anyway assume that the error was indeed
"user error"; perhaps that of a developer rather than a device deployed long
ago, expecting an older version of the server API.

## Proposal

Versioning and its adherence has important implications for the function and
security of any IoT ecosystem. The aim of this project is to minimise the ways
in which IoT client-originating requests can fail, such as by HTTP 4xx status
codes.

The project will start by extending the Rust 'cargo' package manager to enforce
adherence to the Semantic Versioning ('SemVer') scheme, at least as far
leveraging the type and 'trait' system allows.

The next step will be to investigate possible methods of implementing a
language-agnostic behavioural 'promise' or contract for web - primarily JSON -
APIs, such that software targeting the client can compile against the contract
in a manner akin to library headers; with the aim to eliminate 400 Bad Request,
405 Method Not Allowed, and possibly other response status codes. Ethereum
contracts are a possible candidate, or some form of inspection of and validation
against JSON Schema.

A more research-oriented element to the project will investigate session types,
and how they might be used to further the implementation to prevent client
errors arising due to bugs in a stateful interaction - 401 Unauthorized and 412
Precondition Failed codes, for example.

### Evaluation

The project's success will be demonstrated by the inability to compile client
device software that would result in an error, through fault of the client, when
communicating with a server at run-time. This will be shown by analysing
automated and randomised test applications for compile-time and, if compilable,
run-time success.

### (Rough) Timetable

|         Milestone         |   When  |
|:--------------------------|:-------:|
| SemVer-enforcing Cargo    | Dec '16 |
| Investigate API contract  | Jan '17 |
| Implement API contract    | Feb '17 |
| Randomised test suite     | Mar '17 |
| Investigate session types | Apr '17 |
| -- (Exams)                | May '17 |
| ? Implement session types | Jun '17 |
| Finalise analysis/report  | Jun '17 |

The break for exams, and unknown possibility of implementing session types also
builds in some slack with which to catch-up, solve some unanticipated problem,
or allow time for an idea arising by having had a mind on other matters for a
while.

### Cost & Requirements

There should be no particular hardware required. Real devices may be useful for
testing, but existing devices or software can be used. Testing may be easier
against some external infrastructure, such as AWS, in which case some small cost
may be incurred - though a certain quota for students is available free of
charge.
