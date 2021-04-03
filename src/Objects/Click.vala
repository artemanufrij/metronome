namespace Metronome.Objects {

    public enum click_state { running, stopped }
    public enum click_interval { semibreve, minim, crotchet, quaver }

    public class Click : GLib.Object {

        public signal void state_changed (click_state state);
        public signal void tempo_changed (uint tempo);
        public signal void beat_changed (uint beat);
        public signal void click (click_interval interval, bool beat);

        uint click_count;
        uint beat_count;

        uint timer_uint;

        click_state _current_state;
        public click_state current_state {
            get { return _current_state; }
            private set {
                _current_state = value;
                state_changed (current_state);
            }
        }

        uint _current_tempo;
        public uint current_tempo {
            get { return _current_tempo; }
            set {
                _current_tempo = value;
                tempo_changed (value);
            }
        }

        uint _current_beat;
        public uint current_beat {
            get { return _current_beat; }
            set {
                _current_beat = value;
                beat_changed (value);
            }
        }

        public Click () {
            current_state = click_state.stopped;
            click_count = 0;
            beat_count = 0;
        }

        public async void start () {
            if (!is_settings_valid ())
                return;

            uint interval = 60000 / current_tempo / 8;

            current_state = click_state.running;

            do_click.begin ();

            timer_uint = GLib.Timeout.add (interval, () => {
                if (current_state == click_state.stopped)
                    return false;

                do_click.begin ();
                return true;
            }, GLib.Priority.HIGH);
        }

        public void stop () {
            if (timer_uint > 0) {
                GLib.Source.remove (timer_uint);
                timer_uint = 0;
            }
            current_state = click_state.stopped;
            click_count = 0;
            beat_count = 0;
        }

        public async void do_click () {
            if (click_count == 0 ) {
                click (click_interval.semibreve, beat_count % current_beat == 0);
                beat_count ++;
            }
            else if (click_count % 4 == 0)
                click (click_interval.minim, false);
            else if (click_count % 2 == 0)
                click (click_interval.crotchet, false);
            else
                click (click_interval.quaver, false);

            if (click_count == 7)
                click_count = 0;
            else
                click_count ++;

            yield;
        }

        public void set_preset (Metronome.Objects.Preset preset) {
            current_tempo = preset.tempo;
            current_beat = preset.beat;
            if (current_state == click_state.running) {
                stop ();
                start.begin ();
            }
        }

        public bool is_settings_valid () {
            return is_tempo_valid (current_tempo) && is_beat_valid (current_beat);
        }

        public bool is_tempo_valid (uint new_tempo) {
            return (new_tempo >= 30 && new_tempo <= 240);
        }

        public bool is_beat_valid (uint new_beat) {
            return (new_beat >= 1 && new_beat <= 9);
        }
    }
}
