# Please remove bundle exec if you do not use bundler
flavor = "thinkingsphinx"
on_app_master do
  run "cd #{release_path} mkdir -p config/#{flavor}"
  run "cd #{release_path} && bundle exec rake ts:conf && bundle exec rake ts:index && bundle exec rake thinking_sphinx:running_start"
  sudo "monit reload"
end
on_app_servers_and_utilities do
  run "cd #{release_path} mkdir -p config/#{flavor}"
  run "cd #{release_path} bundle exec rake thinking_sphinx:configure"
end

