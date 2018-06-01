require 'securerandom'
require 'json'

module Todo
    class Item
        PROPERTIES = [:id, :title, :notes, :priority, :filename, :creation_datetime].freeze
        PRIORITIES = ['high', 'medium', 'normal', 'low'].freeze

        attr_accessor *PROPERTIES

        def initialize(options = {})
          if user_data_path = options[:user_data_path]
            # Novo item. Quando salvo, ele será colocado sob o :user_data_path
            @id = SecureRandom.uuid
            @creation_datetime = Time.now.to_s
            @filename = "#{user_data_path}/#{id}.json"
          elsif filename = options[:filename]
            # Carrega um item existente
            load_from_file filename
          else
            raise ArgumentError, 'Por favor especifique o: user_data_path para novo item ou o: filename para carregar o existente'
          end
        end

        # Carrega um item de um arquivo
        def load_from_file(filename)
          properties = JSON.parse(File.read(filename))

          # Atribuir as propriedades
          PROPERTIES.each do |property|
            self.send "#{property}=", properties[property.to_s]
          end
        rescue => e 
            raise ArgumentError, "Falha ao carregar o item existente: #{e.message}"
        end

        # Resolve se um item é novo
        def is_new?
          !File.exists? @filename
        end
        
        # Salva um item na sua localização `filename`
        def save!
          File.open(@filename, 'w') do |file|
            file.write self.to_json
          end
        end

        # Deleta um item
        def delete!
          raise 'Item não é salvo' if is_new?

          File.delete(@filename)
        end

        # Produz uma string json para o item
        def to_json
          result = {}
          PROPERTIES.each do |prop|
            result[prop] = self.send prop
          end

          result.to_json
        end
    end
end