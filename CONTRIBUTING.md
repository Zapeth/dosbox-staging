# Contributing to dosbox-staging

Thank you for your interest in contributing to dosbox-staging! There are many
ways to contribute, and we appreciate all of them. This document is a bit long,
so here's links to the major sections:

- [1 Feature requests and bug reports](#)
- [2 Build dosbox-staging]()
- [3 Find something to work on]()
- [4 Contributing code]()
   - [4.1 Coding style](#coding-style)
      - [4.1.1 Language]()
      - [4.1.1 Code formatting]()
      - [4.1.1 Additional style rules]()
   - [4.2 Submitting patches / Pull Requests]()
      - [4.2.1 Commit messages]()
      - [4.2.2 Commit messages when you're not author of the patch]()
- [5 Tools]()
   - [5.1 clang-format]()
   - [5.2 Summarize warnings]()

# Feature requests, bug reports, discussion channels

TODO

# Find something to work on

TODO: Describe where to find backlog and features for the next release,
ideas for contributions: documentation updates (wiki, manual), game testing,
benchmarks, documenting DOS-related resources, helping new users, etc.

# Build dosbox-staging

TODO link to README.md, INSTALL, and build.md

# Contributing code

## Coding style

These rules apply to code in `src/` and `include/` directories.
They do not apply to code in `src/libs/` directory (libraries in there
have their own coding conventions).

Rules outlined below apply to *new* code landing in master branch.
Do not do mass reformating or renaming of existing code.

### Language

We use C-like C++11, which means:

- Avoid designing your code in complex object-oriented style.
  This does not mean "don't use classes", it means "don't use stuff like
  multiple inheritance, overblown class hierarchies, operator overloading,
  iostreams for stdout/stderr, etc, etc".
- C++11 has rich STL library, use it (responsibly - sometimes using
  C standard library makes more sense).
- Use C++11 features like `constexpr`, `static_assert`, managed pointers,
  lambda expressions, for-each loops, etc.
- Avoid using exceptions. C++ exceptions are trickier than you think.
  No, you won't get it right. Or person touching the code after you won't get
  it right. Or person using your exception-ridden interface won't get it right.
  Let errors like `std::logic_error` or `std::bad_alloc` terminate the
  process, so it's easier to notice during testing and can be fixed early.
- Avoid complex template metaprogramming. Simple templates are fine.
- Avoid complex macros. If possible, write a `constexpr` function or simple
  template instead.
- Never write `use namespace std;`. We don't want any confusion about what
  comes from STL and what's project-specific.
- Before using some platform-specific API - check if SDL2 provides
  cross-platform interface for it. It probably does.

### Code Formatting

For *new* code follow K&R style - see [Linux coding style] for examples and some
advice on good C coding style.

Following all the details of formatting style is tedious, that's why we use
custom clang-format ruleset to make it crystal clear.

TODO
Skip to [using clang-format] section for a quick reference.

[Linux coding style]:https://www.kernel.org/doc/html/latest/process/coding-style.html

### Additional Style Rules

1. Sort includes according to: [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html#Names_and_Order_of_Includes)
2. NEVER use Hungarian notation.
3. Most old code uses naming convention `MODULENAME_FunctionName` for public
   module interfaces. Do NOT replace it with namespaces.
4. Utility function names and helper functions (generic functionalities, not
   tied to any specific emulation area, such as functions in
   `include/support.h`) do not need to follow this convention.
   Using `snake_case` names for such functions is recommended.
5. Do NOT use that convention for static functions (single file scope), class
   names, methods, enums, or other constructs.
6. Class names and method names can use `CamelCase` or `snake_case`.
   Be consistent, DON'T mix styles like this: `get_DefaultValue_Str` (bleh).
7. Using `snake_case` for variable names, parameter names, struct fields, and
   class fields is recommended.
8. Use header guards in format: `DOSBOX_HEADERNAME_H` or
   `DOSBOX_MODULENAME_HEADERNAME_H`.

## Submitting Patches / Pull Requests

Submissions via GitHub PRs are recommended. If you can't use GitHub for
whatever reason, then submitting patches (generated with `git-format-patch`)
via email is also possible - contact maintainer about the details.

Code submitted as raw source files (not patches), files attached to issue
comments, forum posts, diffs in non-git format, etc will be promptly ignored.

### Commit messages

Read [How to Write a Git Commit Message]. Then read it again, and follow
"the seven rules" :)

The only exception to these rules are commits landing from our upstream project,
so occassionally you might find a commit originating from `svn/trunk` branch,
that does not follow them.  There are no other exceptions.

[How to Write a Git Commit Message]:https://chris.beams.io/posts/git-commit/

### Commit messages for patches authored by someone else

- If possible, preserve formatting used by original author
- Record the correct author name, date when original author wrote the patch
  (if known), and sign it, e.g:
  
  ```
  git commit --amend --author="Original Author <mail-or-identifier>"
  git commit --amend --date="15-05-2003 11:45"
  git commit --amend --signoff
  ```
  
- Record the source of the patch so future programmers can find the context
  and discussion surrounding it. Use following trailer:
  
  ```
  Imported-from: <url-or-specific-identifier>
  ```

For an example of commit, that followed all of these rules, see:

    git log -1 ffe3c5ab7fb5e28bae78f07ea987904f391a7cf8

# Tools

## Using clang-format

TODO

## Summarize warnings

TODO describe ./scripts/count-warnings.py
