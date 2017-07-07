namespace Metronome.Widgets {

    public class Volumes : Gtk.Grid {

        Gtk.Scale scale_semibreve;
        Gtk.Scale scale_minim;
        Gtk.Scale scale_crotchet;
        Gtk.Scale scale_quaver;

        double vol_semibreve = 0;
        double vol_minim = 0;
        double vol_crotchet = 0;
        double vol_quaver = 0;

        public Volumes () {
            hexpand = true;
            row_spacing = 6;
            column_spacing = 6;
            height_request = 180;

            scale_semibreve = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 1, 0.01);
            scale_semibreve.expand = true;
            scale_semibreve.inverted = true;
            scale_semibreve.draw_value = false;
            scale_semibreve.set_value (0.5);
            scale_semibreve.value_changed.connect (() => {
                double result = ((double)((int) (scale_semibreve.get_value () * 100))) / 100;
                vol_semibreve = result;
                debug ("Volume semibreve %g", vol_semibreve);
            });

            var icon_semibreve = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/symbol_semibreve.png");

            scale_minim = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 1, 0.01);
            scale_minim.expand = true;
            scale_minim.inverted = true;
            scale_minim.draw_value = false;
            scale_minim.value_changed.connect (() => {
                double result = ((double)((int) (scale_minim.get_value () * 100))) / 100;
                vol_minim = result;
                debug ("Volume minim %g", vol_minim);
            });

            var icon_minim = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/symbol_minim.png");

            scale_crotchet = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 1, 0.01);
            scale_crotchet.expand = true;
            scale_crotchet.inverted = true;
            scale_crotchet.draw_value = false;
            scale_crotchet.value_changed.connect (() => {
                double result = ((double)((int) (scale_crotchet.get_value () * 100))) / 100;
                vol_crotchet = result;
                debug ("Volume crotchet %g", vol_crotchet);
            });

            var icon_crotchet = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/symbol_crotchet.png");

            scale_quaver = new Gtk.Scale.with_range (Gtk.Orientation.VERTICAL, 0, 1, 0.01);
            scale_quaver.expand = true;
            scale_quaver.inverted = true;
            scale_quaver.draw_value = false;
            scale_quaver.value_changed.connect (() => {
                double result = ((double)((int) (scale_quaver.get_value () * 100))) / 100;
                vol_quaver = result;
                debug ("Volume quaver %g", vol_quaver);
            });

            var icon_quaver = new Gtk.Image.from_file (Constants.PKGDATADIR + "/icons/symbol-quaver.png");

            attach (scale_semibreve, 0, 0, 1, 1);
            attach (icon_semibreve, 0, 1, 1, 1);
            attach (scale_minim, 1, 0, 1, 1);
            attach (icon_minim, 1, 1, 1, 1);
            attach (scale_crotchet, 2, 0, 1, 1);
            attach (icon_crotchet, 2, 1, 1, 1);
            attach (scale_quaver, 3, 0, 1, 1);
            attach (icon_quaver, 3, 1, 1, 1);
        }

        public double volume_semibreve {
            get { return vol_semibreve; }
            set { scale_semibreve.set_value (value); }
        }

        public double volume_minim {
            get { return vol_minim; }
            set { scale_minim.set_value (value); }
        }

        public double volume_crotchet {
            get { return vol_crotchet; }
            set { scale_crotchet.set_value (value); }
        }

        public double volume_quaver {
            get { return vol_quaver; }
            set { scale_quaver.set_value (value); }
        }
    }
}
