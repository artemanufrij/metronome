namespace Metronome.Objects {
    public class Preset {
        public signal void tempo_changed (uint tempo);
        public signal void beat_changed (uint beat);

        public string title { get; set; }

        uint _tempo;
        public uint tempo {
            get {
                return _tempo;
            }
            set {
                _tempo = value;
                tempo_changed (value);
            }
        }

        uint _beat;
        public uint beat {
            get {
                return _beat;
            }
            set {
                _beat = value;
                beat_changed (value);
            }
        }

        public double volume_semibreve { get; set; }
        public double volume_minim { get; set; }
        public double volume_crotchet { get; set; }
        public double volume_quaver { get; set; }

        public static Preset? parse (string custom_settings) {
            Preset? return_value = null;
            debug ("parse custom setting %s", custom_settings);

            string [] split_title = custom_settings.split (":");

            if (split_title.length == 2) {

                string [] split_properties = split_title [1].split (";");

                if (split_properties.length == 6) {
                    return_value = new Preset ();
                    return_value.title = split_title [0];
                    return_value.tempo = int.parse (split_properties [0]);
                    return_value.beat = int.parse (split_properties [1]);
                    return_value.volume_semibreve = double.parse (split_properties [2].replace (",", "."));
                    return_value.volume_minim = double.parse (split_properties [3].replace (",", "."));
                    return_value.volume_crotchet = double.parse (split_properties [4].replace (",", "."));
                    return_value.volume_quaver = double.parse (split_properties [5].replace (",", "."));
                }
            }

            return return_value;
        }

        public string get_setting_string () {
            return "%s:%d;%d;%g;%g;%g;%g".printf (title, (int)tempo, (int)beat, volume_semibreve, volume_minim, volume_crotchet, volume_quaver);
        }
    }
}
