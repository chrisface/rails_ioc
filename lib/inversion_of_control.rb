module InversionOfControl

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= { dependencies: {}}
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  # Construct new instances of the dependencies to be injected into the newly
  # intantiated class
  def inject_services(overriden_dependencies = {})
    dependencies = self.class.injectables.merge(overriden_dependencies)

    dependencies.each do |name, injectable|
      injectable = self.class.build_injectable(injectable)

      # Setup instance variable
      self.instance_variable_set("@#{name}", injectable)
    end
  end

  module ClassMethods

    def build(options = {})
      overriden_dependencies = injectables.keys.inject({}) do |hash, injectable|
        overriden_dependency = options.delete(injectable)
        hash[injectable] = overriden_dependency unless overriden_dependency.nil?
        hash
      end

      class_instance = options.blank? ? self.new : self.new(options)
      class_instance.inject_services(overriden_dependencies)
      class_instance
    end

    def build_dependencies(dependencies)
      dependencies.each do |name, injectable|
        dependencies[name] = self.build_injectable(injectable)
      end
    end

    def build_injectable(injectable)
      if injectable.class == Class
        if injectable.ancestors.include?(InversionOfControl)
          injectable = injectable.build
        else
          injectable = injectable.new
        end
      end
      injectable
    end

    # add a DSL method to specify the dependencies to inject on a class
    def inject(*injectables)
      @injectables = injectables.inject({}) do |hash, injectable|
        hash[injectable] = service_from_name(injectable)
        self.send(:attr_accessor, injectable)
        hash
      end
    end

    # accessor method on the class to get dependencies for injection
    def injectables
      @injectables
    end

    # One way of turning a symbol into a class for default injection bindings
    def service_from_name(name)
      registered_class = InversionOfControl.configuration[:dependencies][name]
      class_name = registered_class || "#{name}".camelize.constantize
    end
  end
end
