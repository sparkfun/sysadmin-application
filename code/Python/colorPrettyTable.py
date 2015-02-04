#!/usr/bin/env python
#
# -*- coding: utf-8 -*-

__version__ = '0.1.0'


import os

from prettytable import PrettyTable as PrettyTableCore, ALL, FRAME


def get_terminal_size():
    """Returns terminal width and height"""
    def ioctl_GWINSZ(fd):
        try:
            import fcntl
            import termios
            import struct
            dim = struct.unpack('hh',
                                fcntl.ioctl(fd, termios.TIOCGWINSZ, '1234'))
        except:
            return
        return dim

    dim = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)

    if not dim:
        try:
            file_descriptor = os.open(os.ctermid(), os.O_RDONLY)
            dim = ioctl_GWINSZ(file_descriptor)
            os.close(file_descriptor)
        except:
            pass

    if not dim:
        dim = (os.environ.get('LINES', 25), os.environ.get('COLUMNS', 80))

    return int(dim[1]), int(dim[0])


COLOR_STYLES = {
    # styles
    'bold':      ['\033[1m',  '\033[22m'],
    'italic':    ['\033[3m',  '\033[23m'],
    'underline': ['\033[4m',  '\033[24m'],
    'inverse':   ['\033[7m',  '\033[27m'],
    # grayscale
    'white':     ['\033[37m', '\033[39m'],
    'grey':      ['\033[90m', '\033[39m'],
    'black':     ['\033[30m', '\033[39m'],
    # colors
    'blue':      ['\033[34m', '\033[39m'],
    'cyan':      ['\033[36m', '\033[39m'],
    'green':     ['\033[32m', '\033[39m'],
    'magenta':   ['\033[35m', '\033[39m'],
    'red':       ['\033[31m', '\033[39m'],
    'yellow':    ['\033[33m', '\033[39m'],
}


def colorify2(text):
    """Prefix and suffix text to render terminal color"""
    style = COLOR_STYLES['green']
    text = '{}{}{}'.format(style[0], text, style[1])
    return text

def colorify(text, colors):
    """Prefix and suffix text to render terminal color"""
    for color in colors:
        style = COLOR_STYLES[color]
        text = '{}{}{}'.format(style[0], text, style[1])
    return text


class PrettyTable(PrettyTableCore):

    def __init__(self, field_names=None, **kwargs):
        new_options = ['auto_width', 'header_color']

        super(PrettyTable, self).__init__(field_names, **kwargs)

        for option in new_options:
            if option in kwargs:
                self._validate_new_option(option, kwargs[option])
            else:
                kwargs[option] = None

        self._auto_width = kwargs['auto_width'] or False
        self._header_color = kwargs['header_color'] and kwargs['header_color'].split(',') or None

        self._options.extend(new_options)

    def _validate_new_option(self, option, val):
        """Same as _validate_option for prettytable_extra specific options"""

        if option in ('auto_width'):
            self._validate_true_or_false(option, val)
        elif option in ('header_color'):
            self._validate_color(option, val)
        else:
            raise Exception('Unrecognised option: {}!'.format(option))

    def _validate_color(self, option, val):
        available_colors = COLOR_STYLES.keys()
        if val:
            for color in val.split(','):
                try:
                    assert color in available_colors
                except AssertionError:
                    raise Exception('Invalide color, use {} or None!'
                                    .format(', '.join(available_colors)))

    def _optimize_widths(self, options=None, max_width=None,
                         term_width=None, border_width=None):
        """Update widths to match the current terminal size

        Arguments:

        options - dictionary of options settings."""
        if not options:
            options = self._get_options()
        lpad, rpad = self._get_padding_widths(options)

        if not border_width:
            border_width = len(self._widths) * (1 + lpad + rpad) + 1

        if not term_width:
            term_width, term_height = get_terminal_size()

        if max_width:
            for i, width in enumerate(self._widths):
                self._widths[i] = min(width, max_width)

        while term_width < border_width + sum(self._widths):
            extra_width = border_width + sum(self._widths) - term_width
            greatest_width = max(self._widths)
            for i, width in enumerate(self._widths):
                if width == greatest_width:
                    if self._widths[i] / 2 + 1 > extra_width:
                        self._widths[i] -= extra_width
                    else:
                        self._widths[i] = int(width / 2)
                    break

    def _stringify_header(self, options):

        bits = []
        lpad, rpad = self._get_padding_widths(options)
        if options["border"]:
            if options["hrules"] in (ALL, FRAME):
                bits.append(self._hrule)
                bits.append("\n")
            if options["vrules"] in (ALL, FRAME):
                bits.append(options["vertical_char"])
            else:
                bits.append(" ")
        # For tables with no data or field names
        if not self._field_names:
            if options["vrules"] in (ALL, FRAME):
                bits.append(options["vertical_char"])
            else:
                bits.append(" ")
        for field, width, in zip(self._field_names, self._widths):
            if options["fields"] and field not in options["fields"]:
                continue
            if self._header_style == "cap":
                fieldname = field.capitalize()
            elif self._header_style == "title":
                fieldname = field.title()
            elif self._header_style == "upper":
                fieldname = field.upper()
            elif self._header_style == "lower":
                fieldname = field.lower()
            else:
                fieldname = field

            if options['header_color']:
                fieldname = colorify(fieldname, options['header_color'])
            bits.append(" " * lpad
                        + self._justify(fieldname, width, self._align[field])
                        + " " * rpad)
            if options["border"]:
                if options["vrules"] == ALL:
                    bits.append(options["vertical_char"])
                else:
                    bits.append(" ")
        # If vrules is FRAME, then we just appended a space at the end
        # of the last field, when we really want a vertical character
        if options["border"] and options["vrules"] == FRAME:
            bits.pop()
            bits.append(options["vertical_char"])
        if options["border"] and options["hrules"] is not None:
            bits.append("\n")
            bits.append(self._hrule)
        return "".join(bits)

    def get_string(self, **kwargs):
        options = self._get_options(kwargs)

        lines = []

        # Don't think too hard about an empty table
        # Is this the desired behaviour?
        # Maybe we should still print the header?
        if self.rowcount == 0 and (not options["print_empty"]
                                   or not options["border"]):
            return ""

        # Get the rows we need to print, taking into account slicing,
        # sorting, etc.
        rows = self._get_rows(options)

        # Turn all data in all rows into Unicode, formatted as desired
        formatted_rows = self._format_rows(rows, options)

        # Compute column widths
        self._compute_widths(formatted_rows, options)

        if options.get('auto_width', False):
            self._optimize_widths(options)

        # Add header or top of border
        self._hrule = self._stringify_hrule(options)
        if options["header"]:
            lines.append(self._stringify_header(options))
        elif options["border"] and options["hrules"] in (ALL, FRAME):
            lines.append(self._hrule)

        # Add rows
        for row in formatted_rows:
            lines.append(self._stringify_row(row, options))

        # Add bottom of border
        if options["border"] and options["hrules"] == FRAME:
            lines.append(self._hrule)

        return self._unicode("\n").join(lines)


##############################
# MAIN (TEST FUNCTION)       #
##############################

def main():

    x = PrettyTable(["City name", "Area", "Population", "Annual Rainfall"],
                    auto_width=True, border=True, header_color='yellow,bold',
                    left_padding_width=3, right_padding_width=3)
    x.sortby = "Population"
    x.reversesort = True
    x.int_format["Area"] = "04d"
    x.float_format = "6.1f"
    x.align["City name"] = "l"  # Left align city names
    x.add_row(["Adelaide", 1295, 1158259, colorify2(600.5)])
    x.add_row(["Brisbane", 5905, 1857594, 1146.4])
    x.add_row(["Darwin", 112, 120900, 1714.7])
    x.add_row(["Hobart", 1357, 205556, 619.5])
    x.add_row(["Sydney", 2058, 4336374, 1214.8])
    x.add_row(["Melbourne City", 1566, 3806092, 646.9])
    x.add_row(["Perth", 5386, 1554769, 869.4])
    print(x)


if __name__ == "__main__":
    main()
