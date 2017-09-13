module HerokuSecrets
  module Application
    def self.included base
      base.class_eval do
        def secrets
          return @secrets if @secrets && @secrets.secret_key_base
          @secrets = begin
            secrets = super

            ::ENV.select { |var|
              var.start_with? '_SECRET_'
            }.each { |var, val|
              secrets[var.sub(/^_SECRET_/, '').downcase] = val
            }

            secrets
          end
        end

        def reload_secrets!
          @secrets = nil
          secrets
        end
      end
    end
  end
end
