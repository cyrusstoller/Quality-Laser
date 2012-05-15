Quality-Laser
=============

This ruby script is meant to find whether there are exact phrase matches in text documents. This was originally written to detect whether
survey participants were copying text verbatim from source documents that they were asked to read.

## Setup

1. Add all of the survey responses you want to have tested to the `/responses` directory. Make sure that they are plain text files (not `.doc` or `.rtf`).
2. Add all of the source text you want to test against placed in the `/sources` directory. Again, make sure that they are plain text files.
3. Open `manifest.yml` and make sure that the settings are satisfactory.
4. Run the script

## Manifest.yml

- `min_phrase_length` is the minimum length of an exact phrase match that you want to check.
- `max_phrase_length` is the maximum length of an exact phrase match that you want to check.
- `responses` is the name of the directory that the responses are in. *(Default: `/responses`)*
- `sources` is the name of the directory that the sources are in. *(Default: `/sources`)*
- `output` is the name of the output file.

## Running the script

```
$ ruby quality_laser.rb
```