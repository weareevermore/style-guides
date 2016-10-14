# Elixir Style Guide

## Table of Contents

1. [Whitespace](#whitespace)
  1. [Indentation](#indentation)
  1. [Inline](#inline)
  1. [Newlines](#newlines)
1. [Syntax](#syntax)
1. [Naming](#naming)
1. [Modules](#modules)
1. [Exceptions](#exceptions)

## Whitespace

### Indentation

* Use soft-tabs set to 2 spaces.

```elixir
defmodule Awesome do
∙∙def call do
∙∙∙∙# Function logic
  end
end
```

### Inline

* Never leave trailing whitespace.

* Use spaces around operators, after commas, colons and semicolons.

```elixir
sum = 1 + 1

for i <- 1..100, do: i * i
```

* Do not put spaces around matched pairs like brackets, parentheses, etc.

```elixir
[head | tail] = [1, 2, 3]
{:ok, record} = Repo.get(User, 1)
%User{name: name} = record
```

### Newlines

* Use empty lines between defs and to break up a function into logical paragraphs.

```elixir
def some_function(some_data) do
  altered_data = Module.function(data)
end

def some_function do
  result
end

def some_other_function do
  another_result
end

def a_longer_function do
  one
  two

  three
  four
end
```

* One line functions should not be separated by new lines
```elixir
# bad
def one_or_two(1), do: "one"

def one_or_two(2), do: "two"

def one_or_two(_), do: "other"

# good
def one_or_two(1), do: "one"
def one_or_two(2), do: "two"
def one_or_two(_), do: "other"
```

* Do not add empty lines after `defmodule` and `def` definitions and do not leave
  empty lines before the closing `end`.

```elixir
# bad
defmodule MostAwesome do

  def sup? do
  end

end

# good
defmodule MostAwesome do
  def sup? do
  end
end
```

## Syntax

* Use the pipeline operator (`|>`) to chain functions together.

```elixir
# bad
String.strip(String.downcase(some_string))

# good
some_string |> String.downcase |> String.strip
```

* Multiline pipelines are not further indented.

```elixir
some_string
|> String.downcase
|> String.strip
```

* Indent multiline pipelines with one level if its being pattern matched.

```elixir
sanitized_string =
  some_string
  |> String.downcase
  |> String.strip
```

* Use _bare_ variables in the first part of a function chain.

```elixir
# THE WORST!
# This actually parses as String.strip("nope" |> String.downcase).
String.strip "nope" |> String.downcase

# bad
String.strip(some_string) |> String.downcase |> String.codepoints

# good
some_string |> String.strip |> String.downcase |> String.codepoints
```

* Use parentheses when you have arguments, no parentheses when you don't.

```elixir
# bad
def some_function arg1, arg2 do
  # ...
end

def some_function() do
  # ...
end

# good
def some_function(arg1, arg2) do
  # ...
end

def some_function do
  # ...
end
```

* Use parentheses for calls to function with a zero arity so they can be destinguished from variables.

```elixir
defp do_stuff, do: ...

# bad
def my_func do
  do_stuff # is this a variable or a function call
end

# good
def my_func do
  do_stuff() # this is clearly a function call
end
```

* If you use the do: syntax with functions and the line that makes up the function body is long, put the do: on a new line indented one level more than the previous line.

```elixir
def some_function(args),
  do: Enum.map(args, fn(arg) -> arg <> " is on a very long line!" end)
```

* Be consistent in the way you use `do` and `do:`, so if a function with multiple clauses
  is using one of the styles, apply it to the rest as well.

```elixir
def one_or_two(1), do: "one"
def one_or_two(2), do: "two"
def one_or_two(_), do: "other"

def some_longer_function([]),
  do: :empty
def some_longer_function(arr),
  do: Enum.map(arr, &SomeReallyLong.Module.func/1)
```

* Be consistent in your styles

```elixir
# bad
case Awesome.day do
  {:ok, :friday} -> Party.start
  {:error, :monday} ->
    Work.Work.some
end

# good
case Awesome.day do
  {:ok, :friday} -> Party.start
  {:error, :monday} -> Work.Work.some
end

case Awesome.day do
  {:ok, :friday} ->
    Party.start
  {:error, :monday} ->
    Work.Work.some
end
```

## Naming

* Use `snake_case` for atoms, functions and variables.

```elixir
# bad
:"some atom"
:SomeAtom
:someAtom

someVar = 5

def someFunction do
  ...
end

def SomeFunction do
...
end

# good
:some_atom

some_var = 5

def some_function do
  ...
end
```

* Use CamelCase for modules (keep acronyms like HTTP, RFC, XML uppercase).

```elixir
# bad
defmodule Somemodule do
  ...
end

defmodule Some_Module do
  ...
end

defmodule SomeXml do
  ...
end

# good
defmodule SomeModule do
  ...
end

defmodule SomeXML do
  ...
end
```

* The names of predicate functions (functions that return a boolean value) should have a trailing question mark rather than a leading is_ or similar.

```elixir
def cool?(var) do
  # checks if var is cool
end
```

## Modules

* Use one module per file unless the module is only used internally by another module (such as a test).

* Use underscored file names for `CamelCase` module names.

```elixir
# camel_cace.ex
defmodule CamelCase do
end
```

* Represent each level of nesting within a module name as a directory, but do
  not include `lib` if the file is in the lib folder.

```elixir
# parser/core/xml_parser.ex
defmodule Parser.Core.XMLParser do
end

# lib/awesome/parser.ex
defmodule Awesome.Parser do
end
```

* No newline after defmodule.

* No newline before first function def.

* Group and reference other modules in the following order:
  1. `@moduledoc`
  1. `use`
  1. `import`
  1. `alias`
  1. `require`
  1. `@type`
  1. `@module_attribute`

```elixir
defmodule MyModule do
  @moduledoc """
  An example module
  """

  use GenServer

  import Something
  import SomethingElse

  alias My.Long.Module.Name
  alias My.Other.Module.Name

  require Integer

  @type params :: [{binary, binary}]

  @module_attribute :foo
  @other_attribute 100
end
```

## Exceptions

* Make exception names end with a trailing `Error`

```elixir
# bad
defmodule BadHTTPCode do
  defexception [:message]
end

defmodule BadHTTPCodeException do
  defexception [:message]
end

# good
defmodule BadHTTPCodeError do
  defexception [:message]
end
```

* Use lowercase error messages when raising exceptions, with no trailing punctuation.

```elixir
# bad
raise ArgumentError, "This is not valid."

# good
raise ArgumentError, "this is not valid"
```
