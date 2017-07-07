using Gst;

namespace Metronome {

    public class MetronomeApp : Granite.Application {

        public Gtk.Window mainwindow;

        // Controls
        Gtk.Paned root;
        Gtk.Grid content;
        Metronome.Widgets.Presets presets_sidebar;

        Gtk.Button start_button;

        Gtk.SpinButton tempo;
        Gtk.SpinButton beat;

        Gtk.Image led_green_right;
        Gtk.Image led_red_left;

        Gtk.Label tempo_value;
        Gtk.Label beat_value;

        Gtk.Popover tempo_popover;
        Gtk.Popover beat_popover;

        Gst.Element sound_semibreve;
        Gst.Element sound_minim;
        Gst.Element sound_crotchet;
        Gst.Element sound_quaver;
        Gst.Element sound_beat;

        internal Metronome.Widgets.Volumes volumes;
        internal Metronome.Objects.Click click;

        Settings settings;

        string file_click_1 = "file://" + Constants.PKGDATADIR + "/sounds/click_1.wav";
        string file_click_2 = "file://" + Constants.PKGDATADIR + "/sounds/click_2.wav";
        string file_click_4 = "file://" + Constants.PKGDATADIR + "/sounds/click_4.wav";
        string file_click_8 = "file://" + Constants.PKGDATADIR + "/sounds/click_8.wav";
        string file_beat = "file://" + Constants.PKGDATADIR + "/sounds/beat.wav";

        public static MetronomeApp _instance = null;

        public static MetronomeApp instance {
            get {
                if (_instance == null)
                    _instance = new MetronomeApp ();
                return _instance;
            }
        }

        construct {
            program_name = "Metronome";
            exec_name = "metronome";

            build_data_dir = Constants.DATADIR;
            build_pkg_data_dir = Constants.PKGDATADIR;
            build_release_name = Constants.RELEASE_NAME;
            build_version = Constants.VERSION;
            build_version_info = Constants.VERSION_INFO;

            app_years = "2015";
            app_icon = "metronome";
            app_launcher = "metronome.desktop";
            application_id = "net.launchpad.Metronome";

            main_url = "https://code.launchpad.net/metronome";
            bug_url = "https://bugs.launchpad.net/metronome";
            help_url = "https://code.launchpad.net/metronome";
            translate_url = "https://translations.launchpad.net/metronome";

            about_authors = {"Artem Anufrij <artem.anufrij@live.de>"};
            about_documenters = {"Artem Anufrij <artem.anufrij@live.de>"};
            about_artists = {"Sam Hewitt",
                                "Artem Anufrij <artem.anufrij@live.de>"};
            about_comments = "Development release, not all features implemented";
            about_translators = "";
            about_license_type = Gtk.License.GPL_3_0;
        }

        protected override void activate () {

            debug ("sound file: %s", file_click_1);
            debug ("sound file: %s", file_click_2);
            debug ("sound file: %s", file_click_4);
            debug ("sound file: %s", file_click_8);
            debug ("sound file: %s", file_beat);

            if (mainwindow != null) {
                mainwindow.present (); // present window if app is already running
                return;
            }

            settings = Settings.get_default ();

            click = new Metronome.Objects.Click ();
            click.current_tempo = settings.tempo;
            click.current_beat = settings.beat;

            click.state_changed.connect((state) => {
                if (state == Metronome.Objects.click_state.running) {
                    start_button.label = _("Stop");
                    start_button.get_style_context ().remove_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION);
                    start_button.get_style_context ().add_class(Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);

                    led_green_right.visible = false;
                    led_red_left.visible = false;
                }
                else {
                    start_button.label = _("Start");
                    start_button.get_style_context ().remove_class(Gtk.STYLE_CLASS_DESTRUCTIVE_ACTION);
                    start_button.get_style_context ().add_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION);

                    stop_sound ();
                }
            });

            click.tempo_changed.connect ((current_tempo) => {
                debug ("current_tempo %d", (int)current_tempo);
                tempo_value.label = "<b>" + current_tempo.to_string () + "</b>";
            });

            click.beat_changed.connect ((current_beat) => {
                debug ("current_beat %d", (int)current_beat);
                beat_value.label = "<b>" + current_beat.to_string () + "</b>";
            });

            click.click.connect ((interval, beat) => {
                do_click (interval, beat);
            });

            // SOUND
            sound_semibreve = ElementFactory.make ("playbin", "player");

            sound_minim = ElementFactory.make ("playbin", "player");

            sound_crotchet = ElementFactory.make ("playbin", "player");

            sound_quaver = ElementFactory.make ("playbin", "player");

            sound_beat = ElementFactory.make ("playbin", "player");

            build_ui ();
        }

        private void build_ui () {
            mainwindow = new Gtk.Window ();
            mainwindow.set_resizable (false);
            mainwindow.add_events(Gdk.EventMask.KEY_PRESS_MASK);

            root = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);

            content = new Gtk.Grid ();
            content.width_request = 200;
            content.margin = 24;
            content.hexpand = true;
            content.row_spacing = 24;
            content.column_spacing = 6;

            // TITLE BAR
            build_titelbar ();

            // VOLUME sliders
            build_volume_sliders ();

            // SIDEBAR
            build_presets_sidebar ();

            // START-STOP button
            start_button = new Gtk.Button.with_label (_("Start"));
            start_button.hexpand = true;
            start_button.get_style_context ().add_class ("h2");
            start_button.get_style_context ().add_class(Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            content.attach (start_button, 1, 1, 2, 1);

            start_button.clicked.connect (() => {
                if (click.current_state == Metronome.Objects.click_state.running)
                    click.stop ();
                else
                    click.start.begin ();
            });

            // LEDs
            led_green_right = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/led_green.png");
            content.attach (led_green_right, 3, 1, 1, 1);

            var led_gray_right = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/led_gray.png");
            content.attach (led_gray_right, 3, 1, 1, 1);

            led_red_left = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/led_red.png");
            content.attach (led_red_left, 0, 1, 1, 1);

            var led_gray_left = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/led_gray.png");
            content.attach (led_gray_left, 0, 1, 1, 1);

            mainwindow.add (root);
            mainwindow.show_all ();

            presets_sidebar.visible = false;
            led_green_right.visible = false;
            led_red_left.visible = false;

            mainwindow.destroy.connect (() => {
                click.stop ();
                save_settings ();
                Gtk.main_quit ();
            });

            load_settings ();

            Gtk.main ();
        }

        private void build_titelbar () {
            var headerbar = new Gtk.HeaderBar ();
            headerbar.show_close_button = true;

            mainwindow.set_titlebar (headerbar);
            mainwindow.window_position = Gtk.WindowPosition.CENTER;

            var settings_buttons = new Granite.Widgets.ModeButton ();
            settings_buttons.margin_left = 24;
            settings_buttons.margin_right = 24;
            settings_buttons.mode_changed.connect(() => {
                if (settings_buttons.selected == 0) {
                    tempo_popover.show_all ();
                }
                else if (settings_buttons.selected == 1) {
                    beat_popover.show_all ();
                }
            });

            headerbar.set_custom_title (settings_buttons);

            // TEMPO button
            var tempo_button = new Gtk.Grid ();
            tempo_value = new Gtk.Label ("<b>%d</b>".printf (settings.tempo)) { use_markup = true };
            var tempo_bpm = new Gtk.Label ("<small>BPM</small>") { use_markup = true };

            tempo_button.attach (tempo_value, 0, 0, 1, 1);
            tempo_button.attach (tempo_bpm, 0, 1, 1, 1);

            // TEMPO input
            tempo = new Gtk.SpinButton.with_range (30, 240, 1);
            tempo.margin = 6;
            tempo.value_changed.connect (() => {
                set_new_tempo ((uint)tempo.value);
            });

            tempo.key_press_event.connect ((event) => {
                if (event.keyval == Gdk.Key.Return || event.keyval == Gdk.Key.KP_Enter) {
                    if (set_new_tempo ((uint)tempo.value)) {
                        tempo_popover.hide ();
                    }
                    return true;
                }
                else
                    click.stop ();
                return false;
            });

            // TEMPO popover
            tempo_popover = new Gtk.Popover (tempo_button);
            tempo_popover.position = Gtk.PositionType.BOTTOM;
            tempo_popover.add (tempo);
            tempo_popover.closed.connect (() => { settings_buttons.selected = -1; });

            // BEAT button
            var beat_button = new Gtk.Grid ();
            beat_value = new Gtk.Label ("<b>%d</b>".printf (settings.beat)) { use_markup = true };
            var beat_beat = new Gtk.Label ("<small>Beat</small>") { use_markup = true };

            beat_button.attach (beat_value, 0, 0, 1, 1);
            beat_button.attach (beat_beat, 0, 1, 1, 1);

            // BEAT input
            beat = new Gtk.SpinButton.with_range (1, 9, 1);
            beat.margin = 6;
            beat.value_changed.connect (() => {
                set_new_beat ((uint)beat.value);
            });

            beat.key_press_event.connect ((event) => {
                if (event.keyval == Gdk.Key.Return || event.keyval == Gdk.Key.KP_Enter) {
                    if (set_new_beat ((uint)beat.value)) {
                        beat_popover.hide ();
                    }
                    return true;
                }
                return false;
            });

            beat_popover = new Gtk.Popover (beat_button);
            beat_popover.position = Gtk.PositionType.BOTTOM;
            beat_popover.add (beat);
            beat_popover.closed.connect (() => { settings_buttons.selected = -1; });

            settings_buttons.append (tempo_button);
            settings_buttons.append (beat_button);

            var sidebar_toogle = new Gtk.Button ();
            sidebar_toogle.image = new Gtk.Image.from_icon_name ("pane-show-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
            sidebar_toogle.tooltip_text = _("Show Presets");
            sidebar_toogle.relief = Gtk.ReliefStyle.NONE;
            sidebar_toogle.clicked.connect (() => {
                if (presets_sidebar.visible) {
                    presets_sidebar.visible = false;
                    sidebar_toogle.image = new Gtk.Image.from_icon_name ("pane-show-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
                    sidebar_toogle.tooltip_text = _("Show Presets");
                } else {
                    presets_sidebar.visible = true;
                    sidebar_toogle.image = new Gtk.Image.from_icon_name ("pane-hide-symbolic-rtl", Gtk.IconSize.LARGE_TOOLBAR);
                    sidebar_toogle.tooltip_text = _("Hide Presets");
                }
            });

            headerbar.pack_end (sidebar_toogle);
        }

        private void build_volume_sliders () {
            volumes = new Metronome.Widgets.Volumes ();
            content.attach (volumes, 0, 0, 4, 1);
            root.pack1 (content, true, false);
        }

        private void build_presets_sidebar () {
            presets_sidebar = new Metronome.Widgets.Presets ();
            presets_sidebar.preset_selected.connect ((preset) => {
                bool click_runs = click.current_state == Metronome.Objects.click_state.running;
                click.stop ();

                push_preset_into_current_settings (preset);

                if (click_runs)
                    click.start.begin ();
            });
            root.pack2 (presets_sidebar, false, false);
        }

        private void do_click (Metronome.Objects.click_interval interval, bool beat) {
            switch(interval) {
                case Metronome.Objects.click_interval.semibreve:
                    led_green_right.visible = true;

                    if (beat) {
                        debug ("play beat");
                        sound_beat.set_state (State.NULL);
                        sound_beat.set ("volume", volumes.volume_semibreve);
                        sound_beat.set ("uri", file_beat);
                        sound_beat.set_state (State.PLAYING);

                        led_red_left.visible = true;
                    } else {
                        if (volumes.volume_semibreve > 0) {
                            debug ("play semibreve");
                            sound_semibreve.set_state (State.NULL);
                            sound_semibreve.set ("volume", volumes.volume_semibreve);
                            sound_semibreve.set ("uri", file_click_1);
                            sound_semibreve.set_state (State.PLAYING);
                        }
                    }

                    GLib.Timeout.add (60, () => {
                        led_green_right.visible = false;
                        led_red_left.visible = false;
                        return false;
                    }, GLib.Priority.HIGH);
                    break;
                case Metronome.Objects.click_interval.minim:
                    if (volumes.volume_minim > 0) {
                        debug ("play minim");
                        sound_minim.set_state (State.NULL);
                        sound_minim.set ("volume", volumes.volume_minim);
                        sound_minim.set ("uri", file_click_2);
                        sound_minim.set_state (State.PLAYING);
                    }
                    break;
                case Metronome.Objects.click_interval.crotchet:
                    if (volumes.volume_crotchet > 0) {
                        debug ("play crotchet");
                        sound_crotchet.set_state (State.NULL);
                        sound_crotchet.set ("volume", volumes.volume_crotchet);
                        sound_crotchet.set ("uri", file_click_4);
                        sound_crotchet.set_state (State.PLAYING);
                    }
                    break;
                case Metronome.Objects.click_interval.quaver:
                    if (volumes.volume_quaver > 0) {
                        debug ("play quaver");
                        sound_quaver.set_state (State.NULL);
                        sound_quaver.set ("volume", volumes.volume_quaver);
                        sound_quaver.set ("uri", file_click_8);
                        sound_quaver.set_state (State.PLAYING);
                    }
                    break;
            }
        }

        private bool set_new_tempo (uint new_tempo) {
            if (click.is_tempo_valid (new_tempo)) {
                if (click.current_tempo != new_tempo) {
                    click.current_tempo = new_tempo;

                    if (click.current_state == Metronome.Objects.click_state.running) {
                        click.stop ();
                        click.start.begin ();
                    }
                }
                return true;
            }
            return false;
        }

        private bool set_new_beat (uint new_beat) {
            if (click.is_beat_valid (new_beat)) {
                if (click.current_beat != new_beat) {
                    click.current_beat = new_beat;

                    if (click.current_state == Metronome.Objects.click_state.running) {
                        click.stop ();
                        click.start.begin ();
                    }
                }
                return true;
            }
            return false;
        }

        private void stop_sound () {
            sound_semibreve.set_state (State.NULL);
            sound_minim.set_state (State.NULL);
            sound_crotchet.set_state (State.NULL);
            sound_quaver.set_state (State.NULL);
            sound_beat.set_state (State.NULL);
        }

        private void load_settings () {
            tempo.value = settings.tempo;
            beat.value = settings.beat;
            volumes.volume_semibreve = settings.volume_semibreve;
            volumes.volume_minim = settings.volume_minim;
            volumes.volume_crotchet = settings.volume_crotchet;
            volumes.volume_quaver = settings.volume_quaver;
            presets_sidebar.set_presets (settings.custom_settings);
        }

        private void save_settings () {
            settings.tempo = (int) tempo.value;
            settings.beat = (int) beat.value;
            settings.volume_semibreve = volumes.volume_semibreve;
            settings.volume_minim = volumes.volume_minim;
            settings.volume_crotchet = volumes.volume_crotchet;
            settings.volume_quaver = volumes.volume_quaver;
            settings.custom_settings = presets_sidebar.get_presets ();
        }

        internal void push_preset_into_current_settings (Metronome.Objects.Preset preset) {
            tempo.set_value (preset.tempo);
            beat.set_value (preset.beat);

            volumes.volume_semibreve = preset.volume_semibreve;
            volumes.volume_minim = preset.volume_minim;
            volumes.volume_crotchet = preset.volume_crotchet;
            volumes.volume_quaver = preset.volume_quaver;
        }

        internal void push_current_settings_into_preset (Metronome.Objects.Preset preset) {
            preset.tempo = click.current_tempo;
            preset.beat = click.current_beat;
            preset.volume_semibreve = volumes.volume_semibreve;
            preset.volume_minim = volumes.volume_minim;
            preset.volume_crotchet = volumes.volume_crotchet;
            preset.volume_quaver = volumes.volume_quaver;
        }
    }
}
    public static int main (string [] args) {
        Gst.init (ref args);
        Gtk.init (ref args);
        var app = Metronome.MetronomeApp.instance;
        return app.run (args);
    }
