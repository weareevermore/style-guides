# Ruby Style Guide

## Table of Contents

1. [Routing](#routing)
1. [Controllers](#controllers)
1. [Models](#models)
    1. [ActiveModel](#activemodel)
    1. [Queries](#queries)
    1. [Decorators](#decorators)
    1. [Form Objects](#form-objects)
    1. [Service Objects](#service-objects)
1. [Migrations](#migrations)
1. [Views](#views)
1. [Testing](#testing)
1. [Gems](#gems)
    1. [General](#general)
    1. [Development](#development)
    1. [Testing](#testing)

## Routing

* You can use `resources` to create routes for the seven default actions (index,
  show, new, create, edit, update, and destroy).

```ruby
resources :subscriptions
```

* However, blindly using `resources` can be seen as a leaky abstraction. Instead, you should use the `:only` and `:except` options to
  fine-tune this behavior.

```ruby
resources :photos, only: [:index, :show]

resouces :photos, except: :destroy
```

*  When you need to add more actions to a RESTful resource, use `member` and `collection` routes.

```ruby
# bad
get 'subscriptions/:id/unsubscribe'
resources :subscriptions

# good
resources :subscriptions do
    get 'unsubscribe', on: :member
end
```

* Nest route declarations under existing resources.

```ruby
# bad
get 'photos/search'
resources :photos

# good
resources :photos do
    get 'search', on: :collection
end
```

* If you need to define multiple `member/collection` routes use the
  alternative block syntax.

```ruby
resources :subscriptions do
    member do
        get 'unsubscribe'
        # more routes
    end
end

resources :photos do
    collection do
        get 'search'
        # more routes
    end
end
```

* Use namespaced routes to group related actions and API versioning.

```ruby
namespace :admin do
    resources :products
end

namespace :api do
    namespace :v1 do
        resources :users
    end
end
```

## Controllers

* Keep the controllers light. They shouldn't contain any business logic. All the business
  logic should reside in an external class.

* Each controller action should (ideally) invoke only one method other than an initial find or new.

* Always put `macros` first, then `public` methods and `private` ones after that

```ruby
class PostsController < ApplicationController
    before_action :authenticate!

    def show
    end

    private

    def post
    end
end
```

* If you want to validate params that are not related to a model, use [Form Objects](#form-objects)

## Models

### ActiveRecord

* Avoid altering ActiveRecord defaults (table names, primary key, etc)
  unless you have a very good reason.

* Group macro-style methods (`has_many`, `validates`, etc) in the beginning
  of the class definition.

* Add title to the group and use the following order - includes, contstants, associations,
  other macros and scopes should be last

```ruby
class User < ActiveRecord::Base
    include SomeConcern

    # Constants
    STATUSES = %w{active inactive invited}

    # Relations
    belongs_to :account
    has_many :photos, dependent: :destroy

    # Validations
    validates :first_name, presence: true

    # Scopes
    scope :active, -> { where(status: 'active') }
end
```

* Prefer `has_many :through` to `has_and_belongs_to_many`. Using `has_many :through`
  allows additional attributes and validations on the join model.

### Queries

* Favor the use of `find` over `where` when you need to retrieve a single
record by id.

```ruby
# bad
User.where(id: id).take

# good
User.find(id)
```

* Favor the use of `find_by` over `where` when you need to retrieve a single
record by some attributes.

```ruby
# bad
User.where(first_name: 'Bruce', last_name: 'Lee').first

# good
User.find_by(first_name: 'Bruce', last_name: 'Lee')
```

* Use `find_each` when you need to process a lot of records.

```ruby
# bad - loads all the records at once
User.all.each do |user|
    NewsMailer.weekly(user).deliver_now
end

# good - records are retrieved in batches
User.find_each do |user|
    NewsMailer.weekly(user).deliver_now
end
```

* Favor the use of `where.not` over SQL.

```ruby
# bad
User.where("id != ?", id)

# good
User.where.not(id: id)
```

* Avoid N+1 queries. For example, given the relationship below:

```ruby
class Post < ActiveRecord::Base
    belongs_to :author
end

class Author < ActiveRecord::Base
    has_many :posts
end
```

The first line of code below will send 6 (5+1) queries to the database, 1 to fetch the
5 recent posts and then 5 for their corresponding authors. Instead, use
the `includes` method to ensure all the associated data is loaded with
the minumum number of queries.

```ruby
# bad
@recent_posts = Post.order(published_at: :desc).limit(5)

# good
@recent_posts = Post.order(published_at: :desc).includes(:authors).limit(5)
```

* Use [Bullet](https://github.com/flyerhzm/bullet), which will watch your queries while you develop your application and
  notify you when you should add eager loading (N+1 queries).

*  When specifying an explicit query in a method such as find_by_sql, use
   heredocs with squish. This allows you to legibly format the SQL with line
   breaks and indentations, but they get removed from the logs

```ruby
User.find_by_sql <<-SQL
    SELECT
        user.id,
        user.name
    FROM
        users
        INNER JOIN....
SQL
```

### Decorators

* Use decorators if you want to add presentation logic to a model object.

* Put your decorators in `app/decorators` folder and append `Decorator` to the class name.

* You can use [Draper](#https://github.com/drapergem/draper) for your decorators.

* Write plain old ruby object for simpler decorators.

```ruby
class PostMetaDecorator
    def initialize(model)
        @model = model
    end

    def title
        @model.title
    end

    def description
        @model.description.present? ? @model.description : @model.body.truncate(160)
    end
end
```

### Form Objects

* Use form objects if you have forms that are not backed by a model.

* Put your form objects in `app/forms` and append `Form` to the class name.

* Feel free to use `ActiveModel::Model` concern.

```ruby
class ContactForm
    include ActiveModel::Concern

    attr_accessor :name, :email, :message

    # Validations
    validates :email, presence: true
end
```

### Service Objects

* Feel free to use service objects to move logic from controllers

* Put your service objects in `app/services` and append `Service` to the class name.

## Migrations

* Set default values in the migrations themselves instead of in the
  application layer. While enforcing table defaults only in Rails is suggested by
  many Rails developers, it's an extremely brittle approach that leaves your
  data vulnerable to many application bugs.

```ruby
# bad
def price
    self[:price] or 0
end

# good
class CreateProducts < ActiveRecord::Migration
    def change
        create_table :products do |t|
            t.string :name
            t.integer :price, default: 0
        end
    end
end
```

* Migrations should be reversible when possible.

* When the logic is simple, use the `change` method. When using `change`,
  Active Record can automatically figure out how to reverse
  your migration.

```ruby
class AddNameToPeople < ActiveRecord::Migration
    def change
        add_column :people, :name, :string
    end
end
```

* However, if you want to do something more complex that Active Record
  can't automatically reverse, you should use the `up` and `down`
  methods.

```ruby
def up
    remove_column :products, :tax_percent
end

def down
    add_column :products, :tax_percent, :decimal, null: false, :precision => 6, :scale => 4
end
```

## Views

* If in need of a view layer, use ERB templating over HAML or SLIM.

* Use double quotes when dealing with HTML or string interpolation.

* Never make complex formatting in the views, export the formatting to a
  method in the view helper or into a [decorator](#decorator-objects).

* Mitigate code duplication by using partial templates and layouts.

```ruby
# index.html.erb
<h1>Products</h1>
<%= render partial: "product", collection: @products %>
```

```ruby
# _product.html.erb
<p>Product Name: <%= product.name %></p>
```

## Testing

* Use [RSpec](#https://github.com/rspec/rspec-rails) for testing.

* Unit test your models, decorators, services, etc.

* Do not test your views.

* Rely on unit tests to test the permutations of sad paths rather than
  pushing that complexity to integration tests.

* Test happy paths and one general sad path in integration tests.

* Make heavy use of `describe` and `context`.

* Use model factories instead of fixtures.

* Structure your tests into three parts, separated by a new line - setup, steps, expectations.

```ruby
it 'shows error messages' do
    visit '/contacts'

    fill_in ...
    fill_in ...
    click_button ...

    expect(page).to have_content()
end
```

* For more good practices, refer to [Better Specs](http://betterspecs.org/)

## Gems

* Setup a Procfile for starting the projects

### General

* [`draper`](https://github.com/drapergem/draper): Object-oriented layer of presentation logic to your Rails application.

* [`active_model_serializers`](https://github.com/rails-api/active_model_serializers): Brings
  convention over configuration to your JSON generation.

* [`carrierwave`](https://github.com/carrierwaveuploader/carrierwave): Proves a simple
  and extremely flexible way to upload files.

* [`chewy`](https://github.com/toptal/chewy): High-level Elasticsearch Ruby framework based on the official elasticsearch-ruby client

* [`will_paginate`](https://github.com/mislav/will_paginate): Pagination library.

### Development

* [`thin`](https://github.com/macournoyer/thin/): A very fast & simple Ruby web server

* [`quiet_assets`](https://github.com/evrone/quiet_assets): Mutes assets pipeline log messages.

* [`better_errors`](https://github.com/charliesome/better_errors): Better error page for Rack apps

* [`byebug`](https://github.com/deivid-rodriguez/byebug): Simple to use, feature rich debugger for Ruby 2.

* [`letter_opener`](https://github.com/ryanb/letter_opener): Preview mail in the browser instead of sending.

### Testing

* [`guard-rspec`](https://github.com/guard/guard-rspec): Runs your test automatically.

* [`capybara`](https://github.com/jnicklas/capybara): Acceptance test framework for web applications

* [`fabrication`](https://github.com/paulelliott/fabrication): Object generation framework for Ruby.

* [`shoulda-matchers`](https://github.com/thoughtbot/shoulda-matchers): Collection of testing matchers.

* [`faker`](https://github.com/stympy/faker): A library for generating fake data such as names, addresses, and phone numbers.
