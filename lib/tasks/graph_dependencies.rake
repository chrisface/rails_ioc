task generate_graphs: :environment do

  # For the dependencies to be graphed they must have been previously required.
  # In this case we're asking Rails to load these for us. Alternatively we could
  # load a subset of the files and Graph those in isolation.
  Rails.application.eager_load!
  InversionOfControl.dependency_analyzer.generate_graph('dependencies.png')
end
