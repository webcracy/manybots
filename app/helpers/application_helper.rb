module ApplicationHelper
  
  def current_tab?(current_controller)
    unless current_controller.is_a? Array
      if controller_name == current_controller.to_s
        return "active" 
      end
    else 
      current_controller.each do |pc|
        return "active" if controller_name == pc.to_s
      end
    end
  end  
  
  def gravatar_url_for(email, options = {})      
    url_for("http://www.gravatar.com/avatar.php?gravatar_id=" + Digest::MD5.hexdigest(email))
  end
  
  def active_param?(filtro, valor, local_params)
    if !local_params[:filter].nil? and local_params[:filter][filtro.to_s] and local_params[:filter][filtro.to_s].split(',').include?(valor.to_s)
      klass = "filter selected yellow smaller"
    else 
      klass = 'filter gray smaller' 
    end
    klass << ' awesome' unless filtro.to_s == 'tags'
    return klass
  end
  
  def params_trick(filtro, valor, local_params)
    unless local_params[:filter].nil? 
      if local_params[:filter][filtro.to_s] and local_params[:filter][filtro.to_s].split(',').include?(valor.to_s)
        return remove_filter(filtro, valor, local_params)
      end
      unless filtro == :order
        h = {}
        h.clear
        h.merge! local_params
        valor = h['filter'][filtro].to_s.split(',').push(valor).join(',') 
        return {:filter => local_params[:filter].merge({filtro => valor})}
      else 
        return {:filter => local_params[:filter].merge({filtro => valor})}
      end
      
    else
      return {:filter => {"#{filtro}" => valor }}
    end
  end
  
  def remove_filter(filtro, valor, local_params)
    filters = {}
    filters.merge! local_params[:filter]
    ids = filters[filtro.to_s].split(',').to_a
    if ids.is_a? Array and ids.size > 1
      ids.delete valor.to_s
      valor = ids.join(',') 
      return {:filter => local_params[:filter].merge({filtro => valor})}
    else
      filters.delete(filtro.to_s)
      return {:filter => filters }
    end
  end
  
end
