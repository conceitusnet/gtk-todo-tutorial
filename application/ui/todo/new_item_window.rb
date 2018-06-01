module Todo
    class NewItemWindow < Gtk::Window 
        # Reistre a classe no GLib world
        type_register

        class << self
            def init
              # Definir os recursos do modelo binário
              set_template resource: '/com/iridakos/gtk-todo/ui/new_item_window.ui'

              # Vincular os widgets da janela
              bind_template_child 'id_value_label'
              bind_template_child 'title_text_entry'
              bind_template_child 'notes_text_view'
              bind_template_child 'priority_combo_box'
              bind_template_child 'cancel_button'
              bind_template_child 'save_button'
            end
        end

        def initialize(application)
            super application: application

            id_value_label.text = item.id 
            title_text_entry.text = item.title if item.title
            notes_text_view.buffer.text = item.notes if item.notes

            # Configure  combo box
            model = Gtk::ListStore.new(String)
            Todo::Item::PRIORITIES.each do |priorit|
                iterator = model.append
                iterator[0] = priority
            end

            priority_combo_box.model = model
            renderer = Gtk::CellRendererText.new
            priority_combo_box.pack_start(renderer, true)
            priority_combo_box.set_attributes(renderer, "text" => 0)

            priority_combo_box.set_active(Todo::Item::PRIORITIES.index(item.priority)) if item.priority
        end
    end
end
