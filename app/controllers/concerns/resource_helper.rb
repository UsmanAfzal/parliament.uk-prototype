module ResourceHelper

  ACCEPTABLE_OBJECT_TYPES = {
    Person: 'people_path'
  }

  def self.get_object_type(node_type)
    node_type = node_type.gsub!(/http:\/\/id.ukpds.org\/schema\//, '').to_sym
  end

  def self.check_acceptable_object_type(node_type)
    ACCEPTABLE_OBJECT_TYPES.include?(node_type) ? ACCEPTABLE_OBJECT_TYPES[node_type] : nil
  end

end
