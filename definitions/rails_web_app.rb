define :rails_web_app, config_files: [], ssl: false do
  _params = params
  app_dir = params[:app_dir] || "/u/apps/#{params[:name]}"
  app_owner = params[:owner] || node['current_user']

  %w(/ /releases /shared /shared/system /shared/log /shared/pids).each do |dir|
    directory "#{app_dir}#{dir}" do
      recursive true
      owner app_owner
      group app_owner
    end
  end

  params[:config_files].each do |config_file|
    template "#{app_dir}/shared/#{config_file}" do
      source "#{params[:name]}/#{config_file}.erb"
    end
  end

  web_app params[:name] do
    cookbook "instedd-common"
    server_name _params[:server_name]
    docroot "/u/apps/#{_params[:name]}/current/public"
    passenger_spawn_method _params[:passenger_spawn_method]
    partials _params[:partials]
  end

  if params[:ssl]
    include_recipe "apache2::mod_ssl"

    web_app "#{params[:name]}-ssl" do
      cookbook "instedd-common"
      server_name _params[:server_name]
      server_port 443
      docroot "/u/apps/#{_params[:name]}/current/public"
      passenger_spawn_method _params[:passenger_spawn_method]
      partials _params[:ssl_partials]
      ssl true
      ssl_env_vars _params[:ssl_env_vars]
      ssl_cert_file _params[:ssl_cert_file]
      ssl_cert_key_file _params[:ssl_cert_key_file]
      ssl_cert_chain_file _params[:ssl_cert_chain_file]
    end
  end
end
