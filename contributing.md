# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test openapi-generator https://github.com/safx/asdf-openapi-generator.git "openapi-generator-cli version"
```

Tests are automatically run in GitHub Actions on push and PR.
