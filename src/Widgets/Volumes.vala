namespace Metronome.Widgets {

    private class Note : Gtk.Scale {
        public Gtk.Image icon;
        public Gtk.Scale scale;
        public double volume;

        public Note (string Name) {
            scale = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 1, 0.01);
            scale.expand = true;
            scale.inverted = true;
            scale.draw_value = false;
            scale.set_value (0.5);

            scale.value_changed.connect (() => {
                volume = ((double)((int) (scale.get_value () * 100))) / 100;
                debug ("Volume %s %g", Name, volume);
            });

            icon = new Gtk.Image.from_file (Constants.PKGDATADIR + @"/icons/symbol_$(Name).png");
        }
    }

    public class Volumes : Gtk.Grid {

        Note scale_semibreve;
        Note scale_minim;
        Note scale_crotchet;
        Note scale_quaver;

        public Volumes () {
            hexpand = true;
            row_spacing = 6;
            column_spacing = 6;
            height_request = 180;

            scale_semibreve = new Note("semibreve");
            scale_minim = new Note("minim");
            scale_crotchet = new Note("crotchet");
            scale_quaver = new Note("quaver");

            attach (scale_semibreve.scale, 0, 0, 1, 1);
            attach (scale_semibreve.icon, 0, 1, 1, 1);
            attach (scale_minim.scale, 1, 0, 1, 1);
            attach (scale_minim.icon, 1, 1, 1, 1);
            attach (scale_crotchet.scale, 2, 0, 1, 1);
            attach (scale_crotchet.icon, 2, 1, 1, 1);
            attach (scale_quaver.scale, 3, 0, 1, 1);
            attach (scale_quaver.icon, 3, 1, 1, 1);
        }

        public double volume_semibreve {
            get { return scale_semibreve.volume; }
            set { scale_semibreve.scale.set_value (value); }
        }

        public double volume_minim {
            get { return scale_minim.volume; }
            set { scale_minim.scale.set_value (value); }
        }

        public double volume_crotchet {
            get { return scale_crotchet.volume; }
            set { scale_crotchet.scale.set_value (value); }
        }

        public double volume_quaver {
            get { return scale_quaver.volume; }
            set { scale_quaver.scale.set_value (value); }
        }
    }
}
