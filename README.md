# lapp

[![Package Version](https://img.shields.io/hexpm/v/lapp)](https://hex.pm/packages/lapp)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/lapp/)

## create a new project

```sh
gleam new app && cd app && gleam add lustre

gleam add --dev lustre_dev_tools

gleam add rsvp
```

## add lapp to your project

```sh
gleam add lapp@1
```
```gleam
import lapp

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/lapp>.

## Development

Unless you say otherwise, Gleam will check and build projects for the Erlang target. We want to build an app we can run in the browser, so first let’s add a target field to the generated gleam.toml.

```toml
  name = "app"
  version = "1.0.0"
+ target = "javascript"

  ...
```

To run the app:

```sh
# Run the project
gleam run -m lustre/dev start

# instead of:
gleam run   # Run the project
gleam test  # Run the tests
```
Once the server is up and running, head on over to your browser and visit http://localhost:1234