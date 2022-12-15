# monorepo_example
This repo is to setup a monrepo & yse bazel as build tool.


## Bazel Cheat Sheets

* `bazel info repository_cache` - shows the bazel cache location
* `bazel info output_base` - list the output base location
* `bazel clean --explunge` - removes all the `bazel-*/` directories created by bazel
* `bazel run $(bazel query "kind(buildifier, //...)")` - runs all the `buildifier` targets in the workspace


## CI setup

* `scrips/ci.sh` is a POC to builds only the chaged packages. Inspired from [bazel's CI](https://github.com/bazelbuild/bazel/blob/master/scripts/ci/ci.sh).


## References

Good [blog](https://jayconrod.com/posts/110/writing-bazel-rules--repository-rules) on how to write custom rules
