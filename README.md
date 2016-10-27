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

Proposal
--------

When developers create an application in C, for example, utilising some
third-party libraries to offload some of the work, there's no guesswork involved
in the correct use of that library's API - the developer does not (cannot)
simply compile and ship it, hoping that every `library_fn()` invocation will
work out okay. Instead, that library's header files are checked at compile-time,
in order to ensure that such calls match the signatures of functions the library
does indeed provide.

In the context of an IoT device, while third-party libraries can of course still
be linked to the embedded application, typically an analogous 'offloading' of
work is instead conducted via a remote server. This introduces a network
protocol, and (de)serialisation to either end of the API barrier. There is
typically no checking akin to that of library header files that the usage of the
remote API matches the implementation.

It is easy to imagine a scenario in which IoT devices such as tiny sensors set
in concrete are all but forgotten about - having been deployed years even
decades prior - yet remain a component of a production system. One need only
look to the financial sector, the age of some of its crucial infrastructure, and
the relative few who can maintain it. Should the server to which such devices
communicate be upgraded, perhaps because some other client device is assumed to
be the only user, the impact on the forgotten devices of a breaking change to
the API would likely be severe - if not a critical component, the resulting
errors could go undetected buried deep in a server log, lost in the noise.

Similarly, it may also occur that an IoT device in production receives an update
that causes it to no longer correctly communicate with the server - or perhaps
some combination of changes to each side. In either case, the device will
subsequently be filling server logs with client error status codes - such as
`404 Not Found`, `405 Method Not Allowed`, or `412 Precondition Failed`, for
example. It's not at all unlikely that such errors would be lost amongst the
noise of similar errors resulting from experimentation, or even routinely
ignored in favour of solely monitoring application-level errors.

The high-level goal of this project is to investigate ways of preventing such
circumstances; to provide, in a manner akin to local library header files, some
mechanism for 'compilation against an API'. Compile-time checks against some
form of 'contract' or schema for the API could mitigate the potential for errors
in use, while strict semantic versioning of the API would prevent destroying
that trust.

The problem essentially has two levels of complexity. Initially, I will look at
classes of error which can be prevented without considering state. Not in a
sense of idempotency of the request itself - an HTTP `POST` request is not
idempotent, but the correctness of the data structure sent can still be analysed
- but rather without considering a stateful *session* of multiple interactions.

While static type checking may be a useful angle on enforcing correctness of
request method and payload, an investigation into session types may be similarly
fruitful for preventing errors caused by missing preconditions, or a lack of
authorisation to make the request.

Standards such as *JSON Schema* exist for specifying the structure of an API,
and may prove a useful basis for this extension. *Ethereum* provides distributed
and undeniable contracts, which might be worth investigating as a trusted
authority for the nature of the API.

### Evaluation

A wholly successful implementation would be unable to compile any program that
would then fail at runtime due to a fault of the client in communicating with a
server. It is not expected that the implementation would progress that far, or
even necessarily that the investigation will discover such a thing to be
possible.

Thus, the project can instead be evaluated by considering an enumeration of the
possible ways in which communication could fail with the client at fault, and
whether the project has been able to address or prevent each possibility.

As part of the project, a system will be created for attempting to compile and
run test programs with some randomised variations designed to target areas that
could cause a client error at runtime. The project will analyse which and how
many of these successfully compiled, and the run-time behaviour. In line with
the high-level goal of the project, success would be shown as the minimisation
of error classes that compiled successfully and erred at run-time.

### (Rough) Timetable

| Milestone                                             |   When  |
|-------------------------------------------------------|:-------:|
| Established clear idea for 'compilation against API'  | Dec '16 |
| Established clear test strategy                       | Dec '16 |
| Implemented server API contract                       | Feb '17 |
| Implemented test suite                                | Mar '17 |
| Implemented client API contract checking              | Mar '17 |
| Established clear idea for stateful session extension | Apr '17 |
| -- (Exams)                                            | May '17 |
| Implemented stateful sessions                         | Jun '17 |
| Finalise analysis/report                              | Jun '17 |

### Cost & Requirements

None expected, beyond perhaps AWS use within the quota freely available to
students.
