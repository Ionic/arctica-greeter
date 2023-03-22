/* -*- Mode: Vala; indent-tabs-mode: nil; tab-width: 4 -*-
 *
 * Copyright (C) 2011,2012 Canonical Ltd
 * Copyright (C) 2015-2017 Mike Gabriel <mike.gabriel@das-netzwerkteam.de>
 * Copyright (C) 2022 Mihai Moldovan <ionic@ionic.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Robert Ancell <robert.ancell@canonical.com>
 *          Michael Terry <michael.terry@canonical.com>
 *          Mike Gabriel <mike.gabriel@das-netzwerkteam.de>
 *          Mihai Moldovan <ionic@ionic.de>
 */

#if !HAVE_GTK_4_0
[CCode(cname = "GTK_IS_CONTAINER", cheader_filename="gtk/gtk.h", simple_generics = true, has_target = false)]
static extern bool gtk_is_container<T> (T widget);
#endif

namespace Utils {
    public double screen_lightness (Gdk.RGBA color) {
        /*
         * Reference (too long to fit onto one line, please paste both URLs
         * together):
         * https://web.archive.org/web/20220921183844/
         *   https://gist.github.com/Myndex/e1025706436736166561d339fd667493
         */
        const double weight_red = 0.2126;
        const double weight_green = 0.7152;
        const double weight_blue = 0.0722;
        const double gamma = 2.2;
        const double light_exponent = 0.678;
        const double perceptual_offset = 0.03;
        var y_s = (weight_red * GLib.Math.pow (color.red, gamma)) +
                  (weight_green * GLib.Math.pow (color.green, gamma)) +
                  (weight_blue * GLib.Math.pow (color.blue, gamma));
        return ((GLib.Math.pow (y_s, light_exponent) * (1.0 + perceptual_offset)) - perceptual_offset);
    }

    public Gdk.RGBA invert_color (Gdk.RGBA color) {
        return {
                 (1.0 - color.red),
                 (1.0 - color.green),
                 (1.0 - color.blue),
                 color.alpha
               };
    }

    public Gdk.RGBA contrast_color (Gdk.RGBA color) {
        Gdk.RGBA ret = { 1.0, 1.0, 1.0, 1.0 };
        var l_s = screen_lightness (color);
        if (l_s < 0.5) {
            ret = invert_color (ret);
        }
        return ret;
    }
}
