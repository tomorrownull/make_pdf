# -*- encoding: utf-8 -*-
yaml = File.join(Rails.root, 'config', 'redis.yml')
if File.exist?(yaml)
  all_redis = YAML.load_file(yaml) || {}
  evn_redis = OpenStruct.new(all_redis[Rails.env])

  redis_server = evn_redis.redis_server
  redis_port =evn_redis.redis_port
  redis_db_num = evn_redis.redis_db_num
  redis_namespace = evn_redis.redis_namespace
  if defined?(Sidekiq)
    Sidekiq.configure_server do |config|
      p redis_server
      config.redis = {url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace}
    end

    Sidekiq.configure_client do |config|
      config.redis = {url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", namespace: redis_namespace}
    end
  end

end

