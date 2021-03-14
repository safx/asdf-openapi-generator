<div align="center">

# asdf-openapi-generator ![Build](https://github.com/safx/asdf-openapi-generator/workflows/Build/badge.svg) ![Lint](https://github.com/safx/asdf-openapi-generator/workflows/Lint/badge.svg)

[openapi-generator](https://openapi-generator.tech/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add openapi-generator
# or
asdf plugin add openapi-generator https://github.com/safx/asdf-openapi-generator.git
```

openapi-generator:

```shell
# Show all installable versions
asdf list-all openapi-generator

# Install specific version
asdf install openapi-generator latest

# Set a version globally (on your ~/.tool-versions file)
asdf global openapi-generator latest

# Now openapi-generator commands are available
openapi-generator-cli version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/safx/asdf-openapi-generator/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Yuji Matsumoto](https://github.com/safx/)
