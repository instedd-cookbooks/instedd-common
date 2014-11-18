node['config_from_bag'].each do |bag, item|
  if item.is_a?(Hash)
    data = Chef::EncryptedDataBagItem.load(bag, item['item'])
    item['values'].to_hash.each do |key, path|
      value = data[key]
      target = node.default
      while path.length > 1
        target = target[path.shift]
      end
      target[path.shift] = value
    end
  else
    data = Chef::EncryptedDataBagItem.load(bag, item)
    data.to_hash.each do |key, value|
      node.default[bag][key] = value
    end
  end
end
