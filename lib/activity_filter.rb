AVAILABLE_FILTERS = [:verbs, :actors, :generators, :targets, :objects, :providers, :tags]

class ActivityFilter
  attr_reader AVAILABLE_FILTERS.join
  
  def initialize(filtro)
    unless filtro.nil?
      for af in AVAILABLE_FILTERS
        valor = filtro[af].nil? ? nil : filtro[af].split(',').to_a
        instance_variable_set("@#{af}", valor)
      end
    else
      @verbs, @actors, @generators, @targets, @objects, @providers, @tags = nil
    end
  end
  
  
  
  def options
    { 
      :verbs => @verbs,
      :actors => @actors,
      :generators => @generators,
      :targets => @targets,
      :objects => @objects,
      :providers => @providers,
      :tags => @tags,
    }
  end

end