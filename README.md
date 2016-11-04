Restricting the Scope for Client Error in IoT Communication
===========================================================

With billions more IoT devices predicted to be connected every year, every problem in IoT is realised at large scale. The connection of so many devices inevitably means vendors will iteratively improve their products; change and improve the deployed software. This rapid iteration may easily lead to unintended incompatibilities between client and server APIs. Additionally, many of the devices expected to be deployed will be deeply embedded in their operating context - light switches, concrete-borne traffic or structural sensors in roads or buildings, et cetera - such devices have relatively long lifetimes and may quickly be outdated, but continue attempting to communicate with a server using that outdated interface. Client-originating communication with a server may cause errors of great concern to a user, but be visible only to a vendor examining a server log, who may anyway assume that the error was indeed "user error"; perhaps that of a developer rather than a device deployed long ago, expecting an older version of the server API.

Proposal
--------

When developers create an application in C, for example, utilising some third-party libraries to offload some of the work, there's no guesswork involved in the correct use of that library's API - the developer does not (cannot) simply compile and ship it, hoping that every `library_fn()` invocation will work out okay. Instead, that library's header files are checked at compile-time, in order to ensure that such calls match the signatures of functions the library does indeed provide.

In the context of an IoT device, while third-party libraries can of course still be linked to the embedded application, typically an analogous 'offloading' of work is instead conducted via a remote server. This introduces a network protocol, and (de)serialisation to either end of the API barrier. There is typically no checking akin to that of library header files that the usage of the remote API matches the implementation.

It is easy to imagine a scenario in which IoT devices such as tiny sensors set in concrete are all but forgotten about - having been deployed years even decades prior - yet remain a component of a production system. One need only look to the financial sector, the age of some of its crucial infrastructure, and the relative few who can maintain it. Should the server to which such devices communicate be upgraded, perhaps because some other client device is assumed to be the only user, the impact on the forgotten devices of a breaking change to the API would likely be severe - if not a critical component, the resulting errors could go undetected buried deep in a server log, lost in the noise.

Similarly, it may also occur that an IoT device in production receives an update that causes it to no longer correctly communicate with the server - or perhaps some combination of changes to each side. In either case, the device will subsequently be filling server logs with client error status codes - such as `404 Not Found`, `405 Method Not Allowed`, or `412 Precondition Failed`, for example. It's not at all unlikely that such errors would be lost amongst the noise of similar errors resulting from experimentation, or even routinely ignored in favour of solely monitoring application-level errors.

The high-level goal of this project is to investigate ways of preventing such circumstances; to provide, in a manner akin to local library header files, some mechanism for 'compilation against an API'. Compile-time checks against some form of 'contract' or schema for the API could mitigate the potential for errors in use, while strict semantic versioning of the API would prevent destroying that trust.

### Evaluation

The project's success will be demonstrated by the inability to compile client device software that would result in an error, through fault of the client, when communicating with a server at run-time. This will be shown by analysing automated and randomised test applications for compile-time and, if compilable, run-time success.

### (Rough) Timetable

| Milestone                 |   When  |
|:--------------------------|:-------:|
| SemVer-enforcing Cargo    | Dec '16 |
| Investigate API contract  | Jan '17 |
| Implement API contract    | Feb '17 |
| Randomised test suite     | Mar '17 |
| Investigate session types | Apr '17 |
| -- (Exams)                | May '17 |
| ? Implement session types | Jun '17 |
| Finalise analysis/report  | Jun '17 |

The break for exams, and unknown possibility of implementing session types also builds in some slack with which to catch-up, solve some unanticipated problem, or allow time for an idea arising by having had a mind on other matters for a while.

### Cost & Requirements

There should be no particular hardware required. Real devices may be useful for testing, but existing devices or software can be used. Testing may be easier against some external infrastructure, such as AWS, in which case some small cost may be incurred - though a certain quota for students is available free of charge.
