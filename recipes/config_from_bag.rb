node['config_from_bag'].each do |bag, item|
  data = Chef::EncryptedDataBagItem.load(bag, item)
  data.to_hash.each do |key, value|
    node.default[bag][key] = value
  end
end
