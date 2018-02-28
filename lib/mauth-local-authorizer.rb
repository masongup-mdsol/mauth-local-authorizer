#Dir.new('lib/mauth-local-authorizer').grep(/\.rb\Z/).each { |f| require "#{Dir.pwd}/lib/mauth-local-authorizer/#{f}" }
require 'mauth-local-authorizer/info'
require 'escort'
require 'pathname'
require 'securerandom'
require 'json'
require 'openssl'

module MAuthLocalAuthorizer
  class ProcessMAuthKeyCommand < ::Escort::ActionCommand::Base
    def execute
      key_path = Pathname.new(arguments.first)
      server_dir = command_options[:mauth_dir]
      raise 'Must have server directory to run' unless server_dir
      dir_path = Pathname.new(server_dir)
      raise 'Server directory must be valid' unless dir_path.directory?
      dir_path += 'local_security_tokens'
      dir_path.mk_dir unless dir_path.directory?
      process_key(key_path, dir_path)
    end

    private

    def process_key(key_path, server_dir)
      priv_key = read_key(key_path)
      pub_key = generate_public_key(priv_key)
      app_name = get_app_name(key_path)
      app_id = generate_app_id
      write_pub_key(app_name, app_id, pub_key, server_dir)
      write_mauth_app_id(app_id, key_path)
      puts "Successfully wrote mauth key for #{app_name} using app id #{app_id}"
    end

    def read_key(key_path)
      key_path.read
    end

    def generate_public_key(priv_key_str)
      OpenSSL::PKey::RSA.new(priv_key_str).public_key.to_pem
    end

    def generate_app_id
      SecureRandom.uuid
    end

    def get_app_name(key_path)
      key_path.dirname.dirname.basename
    end

    def write_pub_key(app_name, app_id, pub_key, server_dir)
      dest_file_path = server_dir + app_id
      file_data = JSON.generate({ security_token: { app_name: app_name, app_uuid: app_id, public_key_str: pub_key, created_at: nil } })
      File.write(dest_file_path.to_s, file_data)
    end

    def write_mauth_app_id(app_id, key_path)
      mauth_conf_file = key_path.dirname + 'mauth.yml'
      return unless mauth_conf_file.file?
      file_data = mauth_conf_file.read
      mauth_conf_file.write(file_data.gsub(/[\h\-]{30,}$/, app_id))
    end
  end
end
