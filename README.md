## Build 

```shell
rake build
```

Build without cache: 

```shell
rake build[false]
```

## Run tests 

```shell
rake test
```

## Run a command inside a container

```shell
rake run['tlmgr --version']
```

Default command is ``bash`` (as a login shell).
