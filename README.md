# enc_parser
Parser for marine cartography: S-57 encapsulated in ISO/IEC 8211

The US [NOAA][noaa] publishes free and excellent marine cartography, which is often repackaged and sold by sketchy chartplotter apps (often via a subscription). Open source options exit but are few, heavy-handed, and not very portable. This project aims to make cartorgaphy easy to visualize by translating it into a sane intermediate representation. The freely available marine cartography (ENC charts) in the mess of a [S-57 standard][s57], encapsulated in [ISO/IEC 8211] is The standard for ISO/IEC 8211 is (of course) not free. A brief preview is available [here][iso8211_preview].

ENC charts published by [NOAA][noaa] are available [here][enc_charts]. An [example enc chart][enc_example] (of the Boston inner harbor) encodes a superset of data visualized in this printable [official marine chart][printable_chart_example].

###Setting up your enviornment

This project requires `ocaml` and its package manager, `opam`, as well as a few modules. To set up both on a Debian/Ubuntu linux, the following is sufficient (note that `<parser>` refers to the `./parser/` directory):

    cd <parser>
    sudo add-apt-repository ppa:avsm/ppa
    sudo apt-get update
    sudo apt-get install ocaml opam
    opam init
    eval `opam config env`
    opam install ocamlfind core menhir

You also must build a native tool (in `./c-src`) to parse the ISO/IEC 8211 format into an intermediate representation. To do so, simply:

    cd <parser>/c-src
    make

###Related work

A handful of parsers exist.

#### [OpenCPN][opencpn]
OpenCPN is an excellent, although opinionated and bulky open source chart plotter in C++. It includes an adequate parser for ENC files.
![opencpn](https://a.fsdn.com/con/app/proj/opencpn/screenshots/screen.jpeg)


#### Other ENC parsers on Github
[This one](https://github.com/tburke/ihos57) does not look like it's going to happen, but [this one](https://github.com/KaiAbuSir/EncLib) may one day do some good.

### Acknowledgements

This project uses the [iso8211lib tool](http://home.gdal.org/projects/iso8211/) (copied [here](https://github.com/vladimir-lu/iso8211lib))


[enc_charts]: http://www.charts.noaa.gov/InteractiveCatalog/nrnc.shtml#mapTabs-2
[noaa]: http://www.noaa.gov/
[s57]: https://www.iho.int/iho_pubs/standard/S-57Ed3.1/31Main.pdf
[iso8211]: https://webstore.iec.ch/publication/11636&preview=1
[iso8211_preview]: https://webstore.iec.ch/preview/info_isoiec8211%7Bed2.0%7Den.pdf
[opencpn]: https://github.com/OpenCPN/OpenCPN
[enc_example]: http://www.charts.noaa.gov/ENCs/US5MA11M.zip
[printable_chart_example]: http://www.charts.noaa.gov/PDFs/13272.pdf
