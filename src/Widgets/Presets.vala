namespace Metronome.Widgets {

    public class Presets : Gtk.Box {

        public signal void preset_selected (Metronome.Objects.Preset preset);

        Gtk.ListBox list_box;

        public Presets () {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.width_request = 160;

            var list_scroll = new Gtk.ScrolledWindow (null, null);
            list_scroll.vexpand = true;
            list_scroll.get_style_context().set_junction_sides(Gtk.JunctionSides.BOTTOM);

            // LIST BOX
            list_box = new Gtk.ListBox ();
            list_box.expand = true;
            list_box.row_activated.connect ((row) => {
                var preset = (((Metronome.Widgets.PresetRow)row).preset);
                preset_selected (preset);
            });

            list_scroll.add (list_box);

            var toolbar = new Gtk.Toolbar ();
            toolbar.expand = false;
            toolbar.set_style (Gtk.ToolbarStyle.ICONS);
            toolbar.set_icon_size (Gtk.IconSize.SMALL_TOOLBAR);
            toolbar.set_show_arrow (false);
            toolbar.get_style_context().add_class(Gtk.STYLE_CLASS_INLINE_TOOLBAR);
            toolbar.get_style_context().set_junction_sides(Gtk.JunctionSides.TOP);

            var separator = new Gtk.SeparatorToolItem ();
            separator.set_draw (false);
            separator.set_expand (true);
            toolbar.insert (separator, -1);

            // ADD Button
            var add_button = new Gtk.ToolButton (null, null);
            add_button.icon_name = "list-add-symbolic";
            add_button.tooltip_text = _("Add Preset");
            toolbar.insert (add_button, -1);

            // ADD Popover
            var popover_grid = new Gtk.Grid ();
            popover_grid.margin = 6;

            var new_preset_popover = new Gtk.Popover (add_button);
            new_preset_popover.position = Gtk.PositionType.TOP;
            new_preset_popover.add (popover_grid);

            var new_preset_title = new Gtk.Entry ();
            new_preset_title.hexpand = true;
            new_preset_title.tooltip_text = _("Preset title");
            new_preset_title.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "edit-symbolic");
            new_preset_title.key_press_event.connect ((event) => {
                if (event.keyval == Gdk.Key.Return || event.keyval == Gdk.Key.KP_Enter) {
                    string preset_title = new_preset_title.buffer.text;
                    if (preset_title != "") {
                        var new_preset = new Metronome.Objects.Preset ();
                        new_preset.title = preset_title;
                        Metronome.MetronomeApp.instance.push_current_settings_into_preset (new_preset);

                        add_preset (new_preset);
                        new_preset_popover.hide ();
                        return true;
                    }
                }
                return false;
            });

            popover_grid.attach (new_preset_title, 1, 0, 1, 1);

            add_button.clicked.connect (() => {
                new_preset_title.text = "";
                new_preset_popover.show_all ();
                new_preset_title.grab_focus ();
            });

            this.pack_start (list_scroll, true, true);
            this.pack_start (toolbar, false, false);
        }

        // ADD new Preset into ListBox
        public void add_preset (Metronome.Objects.Preset preset) {
            var row = new Metronome.Widgets.PresetRow (preset, list_box);
            list_box.add(row);
            row.show_all ();
            row.get_style_context ().remove_class("button");
            debug ("add custom setting %s", preset.title);
        }

        // LOAD Presets from SETTINGS
        public void set_presets (string[] presets) {
            foreach (string item in presets) {
                var preset = Metronome.Objects.Preset.parse (item);
                if (preset != null)
                    this.add_preset (preset);
            }
        }

        // PARSE Presets for SETTINGS
        public string[] get_presets () {
            GLib.Array<string> custom_settings = new GLib.Array<string> ();
            foreach (Gtk.Widget row in list_box.get_children ()) {
                if (row is Metronome.Widgets.PresetRow) {
                    debug ("save custom setting %s", (row as Metronome.Widgets.PresetRow).preset.get_setting_string ());
                    custom_settings.append_val((row as Metronome.Widgets.PresetRow).preset.get_setting_string ());
                }
            }
            return custom_settings.data;
        }
    }
}
