define :rails_web_app, config_files: [] do
  _params = params
  app_dir = params[:app_dir] || "/u/apps/#{params[:name]}"
  app_owner = params[:owner] || node['current_user']

  %w(/ /releases /shared /shared/system /shared/log /shared/pids).each do |dir|
    directory "#{app_dir}#{dir}" do
      recursive true
      owner _params[:owner]
      group _params[:owner]
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
  end
end
