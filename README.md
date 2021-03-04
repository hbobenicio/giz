# Giz

## Work In Progress

This project is really early in development, thus this is not a finished work.
Many API breaking changes may come until this finishes the core functionalities and we get a minimum API stabilization.

## Roadmap to 0.1

1. Comptime API
2. Finish Formatting API

## Usage

TODO

## Trivia

Did you know...

1. Giz is `zig` reversed
2. Giz means "chalk" in Portuguese and Giz is heavily inspired by the excelent chalk npm package

## Brainstom/Backlog of Ideas

- comptime support for static coloring
- support for dynamic (non-comptime) coloring too
- API for changing state (for multiple writes with the same styling)
- API for str decoration (for single write with isolated styling)
- API for chaining decoration
- API namespacing
- API inspiration: https://www.npmjs.com/package/chalk
- API iterate over colors (color indexes)
- API get some aliases from chalk (grey and gray, for example)
- freestanding if possible
- zero allocations if possible (gimme your buffer)
- minimize writes
- flexible, consistent and well documented api
- color mode as input (tell us your environment, we wont waste effort and time trying to discover what you already know)
- tests
- docs
- thread safety!?

## References

- https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
- https://gist.github.com/XVilka/8346728
- 