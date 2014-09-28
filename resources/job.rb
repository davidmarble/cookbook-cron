actions :add, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :minute, :kind_of => String, :default => "*"
attribute :hour, :kind_of => String, :default => "*"
attribute :day, :kind_of => String, :default => "*"
attribute :month, :kind_of => String, :default => "*"
attribute :weekday, :kind_of => String, :default => "*"
attribute :command, :kind_of => String, :default => nil
attribute :user, :kind_of => String, :default => nil
attribute :description, :kind_of => String, :default => nil

attribute :jobinfo, :kind_of => Hash, :default => nil

def initialize(*args)
    super
    @action = :add
end
