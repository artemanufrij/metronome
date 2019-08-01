namespace Metronome.Widgets {

    public class PresetRow : Gtk.ListBoxRow {
        public Metronome.Objects.Preset preset { get; set; }

        private Gtk.Label title_label;
        private Gtk.Label tempo_label;
        private Gtk.Label beat_label;

        public PresetRow (Metronome.Objects.Preset preset, Gtk.ListBox parent) {
            this.preset = preset;
            this.preset.beat_changed.connect ((new_beat) => {
                beat_label.label = "<b>%d</b> Beat".printf((int)new_beat);
            });
            this.preset.tempo_changed.connect ((new_tempo) => {
                tempo_label.label = "<b>%d</b> BPM".printf((int)new_tempo);
            });

            var grid = new Gtk.Grid ();
            grid.margin_top = 4;
            grid.row_spacing = 4;
            grid.expand = true;

            // TITLE
            title_label = new Gtk.Label (preset.title);
            title_label.halign = Gtk.Align.START;
            title_label.get_style_context ().add_class ("h3");
            title_label.expand = true;
            // LABEL
            tempo_label = new Gtk.Label ("<b>%d</b> BPM".printf((int)preset.tempo));
            tempo_label.use_markup = true;
            tempo_label.halign = Gtk.Align.END;
            tempo_label.opacity = 0.6;
            tempo_label.margin_end = 12;

            beat_label = new Gtk.Label ("<b>%d</b> Beat".printf((int)preset.beat));
            beat_label.use_markup = true;
            beat_label.halign = Gtk.Align.END;
            beat_label.opacity = 0.6;
            beat_label.margin_end = 6;


            // ACTION MENU
            var menu = new ActionMenu ();
            menu.valign = Gtk.Align.START;
            menu.delete_clicked.connect (() => {
                parent.remove (this);
            });
            menu.save_clicked.connect (() => {
                Metronome.MetronomeApp.instance.push_current_settings_into_preset (preset);
            });
            grid.attach (menu, 0, 0, 1, 2);
            grid.attach (title_label, 1, 0, 1, 1);
            grid.attach (tempo_label, 1, 1, 1, 1);
            grid.attach (beat_label, 2, 1, 1, 1);
            grid.attach (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), 0, 2, 3, 1);

            var event_box = new Gtk.EventBox ();
            event_box.add (grid);
            event_box.events |= Gdk.EventMask.ENTER_NOTIFY_MASK|Gdk.EventMask.LEAVE_NOTIFY_MASK;

            event_box.enter_notify_event.connect ((event) => {
                menu.set_reveal_child (true);
                return false;
            });

            event_box.leave_notify_event.connect ((event) => {
                if (event.detail == Gdk.NotifyType.INFERIOR)
                    return false;
                menu.set_reveal_child (false);
                return false;
            });

            this.add (event_box);
        }
    }

    public class ActionMenu : Gtk.Revealer {

        public signal void delete_clicked ();
        public signal void save_clicked ();

        public ActionMenu () {
            var delete_button = new Gtk.Button.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.BUTTON);
            delete_button.tooltip_text = _("Delete Preset");
            delete_button.relief = Gtk.ReliefStyle.NONE;
            delete_button.clicked.connect (() => { delete_clicked (); });

            var save_button = new Gtk.Button.from_icon_name ("document-save-symbolic", Gtk.IconSize.BUTTON);
            save_button.tooltip_text = _("Save current Settings");
            save_button.relief = Gtk.ReliefStyle.NONE;
            save_button.clicked.connect (() => { save_clicked (); });

            var buttons = new Gtk.Grid ();
            buttons.orientation = Gtk.Orientation.VERTICAL;
            buttons.add (save_button);
            buttons.add (delete_button);
            buttons.opacity = 0.5;

            this.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
            this.add (buttons);
        }
    }
}
