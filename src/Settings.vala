public class Metronome.Settings : Granite.Services.Settings {
    private static Settings settings;
    public static Settings get_default () {
        if (settings == null)
            settings = new Settings ();

        return settings;
    }

    public double volume_semibreve { get; set; }
    public double volume_minim { get; set; }
    public double volume_crotchet { get; set; }
    public double volume_quaver { get; set; }
    public int tempo { get; set; }
    public int beat { get; set; }
    public string [] custom_settings { get; set; }
    private Settings () {
        base ("org.pantheon.metronome");
    }
}
