module Todo
    class ApplicationWindow < Gtk::ApplicationWindow
        # Reistre a classe no GLib world
        type_register

        class << self
            def init
              # Definir os recursos do modelo binário
              set_template resource: '/com/iridakos/gtk-todo/ui/application_window.ui'
              bind_template_child 'add_new_item_button'
            end
        end

        def initialize(application)
            super application: application
            set_title 'Gtk+ Simple ToDo'
            add_new_item_button.signal_connect 'clicked' do |button, application|
                new_item_window = NewItemWindow.new(application)
                new_item_window.present
            end
        end
    end
end