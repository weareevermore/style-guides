# Ruby Style Guide

## Table of Contents

1. [Whitespace](#whitespace)
  1. [Indentation](#indentation)
  1. [Inline](#inline)
  1. [Newlines](#newlines)
1. [Commenting](#commenting)
  1. [Commented-out code](#commented-out-code)
1. [Methods](#methods)
  1. [Method definitions](#method-definitions)
  1. [Method calls](#method-calls)
1. [Conditional Expressions](#conditional-expressions)
  1. [Conditional keywords](#conditional-keywords)
  1. [Ternary operator](#ternary-operator)
1. [Syntax](#syntax)
1. [Naming](#naming)
1. [Classes](#classes)
1. [Exceptions](#exceptions)
1. [Collections](#collections)
1. [Strings](#strings)
1. [Percent Literals](#percent-literals)

## Whitespace

### Indentation

* Use soft-tabs set to 2 spaces.

```ruby
class Awesome
∙∙def method_name
∙∙∙∙# Method logic
  end
end
```

### Inline

* Never leave trailing whitespace.
* Use spaces around operators; after commas, colons, and semicolons; and around
  `{` and before `}`.

```ruby
sum = 1 + 1
a, b = 1, 2
a > sum ? '2 is now greater than 1' : 'You cannot math'
[1, 2, 3].each { |e| puts e }
```

* No spaces after `(`, `[` or before `]`, `)`.

```ruby
some(arg).other
[1, 2, 3].length
```

### Newlines

* Add a new line after conditionals, blocks, case statements, etc.

```ruby
if wall.needs_paint?
  paint_the_wall
end

wall.paint(:favorite_color)
```

```ruby
def method_name
  # ...
end

def second_method
  # ...
end
```

## Commenting

> Though a pain to write, comments are absolutely vital to keeping our code
> readable. The following rules describe what you should comment and where. But
> remember: while comments are very important, the best code is
> self-documenting. Giving sensible names to types and variables is much better
> than using obscure names that you must then explain through comments.

> When writing your comments, write for your audience: the next contributor who
> will need to understand your code. Be generous — the next one may be you!

> Comments should not describe what the code does. That should be obvious from 
> the code itself. They should describe WHY the code does what it does. Hidden 
> assumptions, dependencies or that sort of thing. Things that are not obvious from 
> looking at one particular block of code.

 - [Google C++ Style Guide](https://google-styleguide.googlecode.com/svn/trunk/cppguide.html#Comments)

### Commented-out code

Please don't leave commented-out code. Let git handle this.

## Methods

### Method definitions

* Use `def` with parentheses when there are arguments. Omit the
  parentheses when the method doesn't accept any arguments.

```ruby
def some_method
  # body omitted
end

def some_method_with_arguments(arg1, arg2)
  # body omitted
end
```

* Do not use default arguments. Use keyword arguments instead.
  * [Keyword arguments were introduced in Ruby 2.0](http://globaldev.co.uk/2013/03/ruby-2-0-0-in-detail/#keyword_arguments)

```ruby
# bad
def bake(pie, temp = 400, at = Time.now)
  # Bake stuff
end

# good
def bake(pie, temp: 400, at: Time.now)
  # Bake stuff
end
```
### Method calls

* Wrap method arguments in `(...)`

```ruby
# bad
User.new params

# good
User.new(params)
```

* Do not add `()` if the method does not accept any arguments

```ruby
# bad
data.shuffle().first()

# good
data.shuffle.first
```

* When passing a big hash to a method, have the hash keys on new
  lines with one indentation level.

```ruby
# bad
User.new(first_name: 'John',
         last_name: 'Snow',
         age: 23)

# good
User.new(
  first_name: 'John',
  last_name: 'Snow',
  age: 23
)
```

* Use a single level of indentation for multiline parameters.

```ruby
# bad
have_fun(one,
         two)

# good
have_fun(
  one,
  two,
  ...
)
```

## Conditional Expressions

### Conditional keywords

* Never use `then` for multi-line `if/unless`.

```ruby
# bad
if some_condition then
  # ...
end

# good
if some_condition
  # ...
end
```

* The `and` and `or` keywords are banned. They have a lower order of
  precednce and will cause unexpected side effects. Always use `&&` and
  `||` instead.

* Modifier `if/unless` usage is okay when the body is simple, the
  condition is simple, and the whole thing fits on one line. Otherwise,
  avoid modifier `if/unless`. `return if object.nil?` is ok.

* `unless` with `else` is confusing. Please use the positive case first.

```ruby
# bad
unless success?
  puts 'failure'
else
  puts 'success'
end

# good
if success?
  puts 'success'
else
  puts 'failure'
end
```

* Avoid `unless` with multiple conditions.

```ruby
# bad
unless foo? && bar?
  # ...
end

# okay
if !(foo? && bar?)
  # ...
end
```

* Don't use parentheses around the condition of an `if/unless/while`,
  unless the condition contains an assignment (see [Using the return
  value of `=`](#syntax) below).

```ruby
# bad
if (x > 10)
  # ...
end

# good
if x > 10
  # ...
end

# ok
if (x = self.next_value)
  # ...
end
```

* Favor modifier `if/unless` usage when you have a single-line body.

```ruby
# bad
if some_condition
  do_something
end

# good
do_something if some_condition
```

### Ternary operator

* Avoid the ternary operator (`?:`) except in cases where all expressions are
  extremely trivial. However, do use the ternary operator(`?:`) over
  `if/then/else/end` constructs for single line conditionals.

```ruby
# bad
result = if some_condition then something else something_else end

# good
result = some_condition ? something : something_else
```

* Use one expression per branch in a ternary operator. This
  also means that ternary operators must not be nested. Prefer
  `if/else` constructs in these cases.

```ruby
# bad
some_condition ? (nested_condition ? nested_something : nested_something_else) : something_else

# good
if some_condition
  nested_condition ? nested_something : nested_something_else
else
  something_else
end
```

* Avoid multi-line `?:` (the ternary operator), use `if/then/else/end` instead.

* Indent `when` as deep as the same level indentation.

```ruby
case
when song.name == "Misty"
  puts "Not again!"
when song.duration > 120
  puts "Too long!"
when Time.now.hour > 21
  puts "It's too late"
else
  song.play
end
```

## Syntax

* Never use `for`, unless you know exactly why. Most of the time iterators
  should be used instead. `for` is implemented in terms of `each` (so
  you're adding a level of indirection), but with a twist - `for`
  doesn't introduce a new scope (unlike `each`) and variables defined
  in its block will be visible outside it.

```ruby
arr = [1, 2, 3]

# bad
for elem in arr do
  puts elem
end

# good
arr.each { |elem| puts elem }
```

* Use `{...}` over `do...end` for single-line blocks.  Do not use
  `{...}` for multi-line blocks (multiline chaining is always
  ugly). Always use `do...end` for "control flow" and "method
  definitions" (e.g. in Rakefiles and certain DSLs).  Avoid `do...end`
  when chaining.

```ruby
names = ["Bozhidar", "Steve", "Sarah"]

# bad
names.each do |name|
  puts name
end

# good
names.each { |name| puts name }

# bad
names.select do |name|
  name.start_with?("S")
end.map { |name| name.upcase }

# good
names.select { |name| name.start_with?("S") }.map { |name| name.upcase }
```

* Utilize Ruby's implicit return, only use `return` statements when
  necessary (returning early from a function)

```ruby
# bad
def some_method(some_arr)
  return some_arr.size
end

# good
def some_method(some_arr)
  some_arr.size
end
```

* Use `||=` freely to initialize variables.

```ruby
# set name to Ash, only if it's nil or false
name ||= 'Ash'
```

* Don't use `||=` to initialize boolean variables. (Consider what
  would happen if the current value happened to be `false`.)

```ruby
# bad - would set enabled to true even if it was false
enabled ||= true

# good
enabled = true if enabled.nil?
```

* When a method block takes only one argument, and the body consists solely of
  reading an attribute or calling one method with no arguments, use the `&:`
  shorthand.

```ruby
# bad
bluths.map { |bluth| bluth.occupation }
bluths.select { |bluth| bluth.blue_self? }

# good
bluths.map(&:occupation)
bluths.select(&:blue_self?)
```

## Naming

* Use `snake_case` for methods and variables.

* Use `CamelCase` for classes and modules (Keep acronyms like HTTP,
  RFC, XML uppercase).

* Use `SCREAMING_SNAKE_CASE` for other constants.

* The names of predicate methods (methods that return a boolean value)
  should end in a question mark. (i.e. `Array#empty?`).

* The names of potentially "dangerous" methods (i.e. methods that modify `self`
  or the arguments, `exit!`, etc.) should end with an exclamation mark. Bang
  methods should only exist if a non-bang method exists
  ([More on this][ruby-naming-bang]).

## Classes

* Avoid the usage of class (`@@`) variables due to their "nasty" behavior
in inheritance.

```ruby
class Parent
  @@class_var = 'parent'

  def self.print_class_var
    puts @@class_var
  end
end

class Child < Parent
  @@class_var = 'child'
end

Parent.print_class_var # => will print "child"
```

As you can see all the classes in a class hierarchy actually share one
class variable. Class instance variables should usually be preferred
over class variables.

* Use `def self.method` to define singleton methods. This makes the methods
  more resistant to refactoring changes.

```ruby
class SomeClass
  # bad
  def SomeClass.some_method
    # ...
  end

  # good
  def self.some_other_method
    # ...
  end
end
```

* Indent the `public`, `protected`, and `private` methods as much the
  method definitions they apply to. Leave one blank line above them.

```ruby
class SomeClass
  def public_method
    # ...
  end

  protected

  def protected_method
    # ...
  end

  private

  def private_method
    # ...
  end
end
```

## Exceptions

* Don't use exceptions for flow of control.

```ruby
# bad
begin
  n / d
rescue ZeroDivisionError
  puts "Cannot divide by 0!"
end

# good
if d.zero?
  puts "Cannot divide by 0!"
else
  n / d
end
```

* Do not rescuing the `Exception` class. `Exception` is the root of Ruby's exception 
 hierarchy, so when you rescue `Exception` you rescue from everything, including 
 subclasses such as SyntaxError, LoadError, and Interrupt. Be explicit in what you are
 rescuing from

```ruby
# bad
begin
  # an exception occurs here
rescue Exception
  # exception handling
end

# bad
begin
  # an exception occurs here
rescue
  # exception handling
end

# good
begin
  # an exception occurs here
rescue ActiveRecord::RecordNotFound
  # exception handling
end
```

## Collections

* Use `Set` instead of `Array` when dealing with unique elements. `Set`
  implements a collection of unordered values with no duplicates. This
  is a hybrid of `Array`'s intuitive inter-operation facilities and
  `Hash`'s fast lookup.

```Ruby
Set.new([1,1,2,3]) # => #<Set: {1, 2, 3}>
```

* Use symbols instead of strings as hash keys.

```ruby
# bad
hash = { 'one' => 1, 'two' => 2, 'three' => 3 }

# good
hash = { one: 1, two: 2, three: 3 }
```

* Use multi-line hashes when it makes the code more readable, and use
  trailing commas to ensure that parameter changes don't cause
  extraneous diff lines when the logic has not otherwise changed.

```ruby
hash = {
  protocol: 'https',
  only_path: false,
  controller: :users,
  action: :set_password,
  redirect: @redirect_url,
  secret: @secret
}
```

## Strings

* Use single quotes, unless using string interpolation.

* Prefer string interpolation instead of string concatenation:

```ruby
# bad
email_with_name = user.name + ' <' + user.email + '>'

# good
email_with_name = "#{user.name} <#{user.email}>"
```

* Avoid using `String#+` when you need to construct large data chunks.
  Instead, use `String#<<`. Concatenation mutates the string instance in-place
  and is always faster than `String#+`, which creates a bunch of new string objects.

```ruby
# good and also fast
html = ''
html << '<h1>Page title</h1>'

paragraphs.each do |paragraph|
  html << "<p>#{paragraph}</p>"
end
```

* When you need to split long string on multiple lines use \ instead of + and <<.
 \ simply tells Ruby parser that the string continues on the next line

```ruby
# bad
some_str = 'ala' +
           'bala'

some_str = 'ala' <<
           'bala'

# good
some_str = 
  'ala' \
  'bala' 
```

* Use heredoc style strings for multiline strings that need interpolation

```ruby
html = <<-HTML
  <div class="row">
    <h1>#{user.name}</h1>
  </div>
HTML
```

## Percent Literals

* Use curly brackets for `%` literals

```ruby
# bad
%w[active inactive]
%(A long string)

# good
%w{active inactive}
%{A long string}
```

* Use `%w` freely.

```ruby
STATUES = %w{active inactive invited}
```

* Use %() for single-line strings which require both interpolation and embedded
  double-quotes. For multi-line strings, prefer heredocs.

```ruby
# bad (no interpolation needed)
%{<div class="text">Some text</div>}
# should be "<div class=\"text\">Some text</div>"

# bad (no double-quotes)
%{This is #{quality} style}
# should be "This is #{quality} style"

# bad (multiple lines)
%{<div
  <span class="big">#{exclamation}</span>
</div>}
# should be a heredoc.

# good (requires interpolation, has quotes, single line)
%{<tr><td class="name">#{name}</td>}
```

* Use `%r` only for regular expressions matching more than one '/' character.

```ruby
# bad
%r{\s+}

# still bad
%r{^/(.*)$}
# should be /^\/(.*)$/

# good
%r{^/blog/2011/(.*)$}
```

Thanks to these kind teams for sharing their code styles!

* [dockyard](https://github.com/dockyard/styleguides/blob/master/ruby.md)
* [github-ruby](https://github.com/styleguide/ruby)
