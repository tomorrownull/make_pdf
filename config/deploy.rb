# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'make_pdf'
set :repo_url, 'git@github.com:tomorrownull/make_pdf.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "~/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.3.0'
set :nginx_server_name,'generator.restaurantweek.cn'
# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system','public/pdfs')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }


# Number of delayed_job workers
# default value: 1
set :delayed_job_workers, 2

# String to be prefixed to worker process names
# This feature allows a prefix name to be placed in front of the process.
# For example:  reports/delayed_job.0  instead of just delayed_job.0
set :delayed_job_prefix, 'pdf'

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
