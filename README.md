# RIPE for Ruby

This is a Ruby client for the RIPE Database service. It can be used by any LIR to view & make changes to their RIPE database objects.

## Installation

The library is distributed using RubyGems.

```ruby
gem 'ripe-db', '~> 1.0'
```

## Usage

Usage of the library is designed to be simple and support managing of all types of objects supported by the RIPE database. At present, it doesn't support additional services like searching, abuse contacts, meta data or geolocation.


### Getting started

```ruby
require 'ripe/client'

# Initialize a new instance of the client. This accepts the mode and your maintainer
# password. The password is only required if you wish to make changes to the database.
ripe = RIPE::Client.new(:live, 'helloworld')
```

### Looking up objects

```ruby
# Lookup an object by providing the type of object and the primary key.
object = ripe.find(:person, 'AC23456-RIPE')

# Read attributes from the object. This will return an array of attributes because one
# attribute can have multiple values.
object['person'].name   #=> 'person'
object['person'].each do |attribute|
  attribute.value                  #=> 'Adam Cooke'
  # Some attributes link to other objects. You can access the referenced object
  # using the referenced_object method on the attribute. This will return a new
  # instance of an Object.
  attribute.referenced_object
end

# Get the link to the object
object.link             #=> 'http://rest.db.ripe.net/ripe/person/AC23456-RIPE'

# Get the primary key for an object
object.primary_key      #=> 'AC23456-RIPE'
```

### Creating a new object

```ruby
# Create your new object lcass
object = ripe.new(:person)
# Set all the attibutes you need to. You can pass an array to set multiple
# values for the same attribute.
object['person'] = 'Adam Cooke'
object['address'] = ['Unit 9 Winchester Place', 'North Street', 'United Kingdom']
object['phone'] = '+44 1202 901 222'
object['mnt-by'] = 'ATECHMEDIA-MNT'
object['source'] = 'RIPE'
begin
  # Make the request to create the object. If this doesn't raise an exception,
  # the object has been added successfully.
  object.create
  object.new?            #=> false
  object.link            # => "http://rest.db.ripe.net/..."
rescue RIPE::ValidationError => exception
  exception.errors.each do |error|
    error.text           #=> Text about the error
    error.severity       #=> The severity of the error
    error.attribute      #=> Details of the attribute that the error relates to (if applicable)
  end
end
```

### Updating an existing object

```ruby
# Find the object you wish to update
object = ripe.find(:person, 'AC23456-RIPE')
# Update the attribute you wish to change
object['phone'] = '+441234123123'
# Make the request to update the object. As with create, you should keep an eye out
# for RIPE::ValidationError exceptions and handle them appropriately.
object.update
```

### Deleting an object

```ruby
# Find the object you wish to update
object = ripe.find(:person, 'AC23456-RIPE')
# Delete the object. This will return true if successful or an exception will be
# raised. As with creations and deletions, you may receive a ValidationError if
# an object cannot be deleted.
object.delete
``
