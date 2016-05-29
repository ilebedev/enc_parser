# enc_parser
Parser for marine cartography: S-57 encapsulated in ISO/IEC 8211

The US [NOAA][noaa] publishes free and excellent marine cartography, which is often repackaged and sold by sketchy chartplotter apps (often via a subscription). Open source options exit but are few, heavy-handed, and not very portable. This project aims to make cartorgaphy easy to visualize by translating it into a sane intermediate representation. The freely available marine cartography (ENC charts) in the mess of a [S-57 standard][s57], encapsulated in [ISO/IEC 8211] is The standard for ISO/IEC 8211 is (of course) not free. A brief preview is available [here][iso8211_preview].

ENC charts published by [NOAA][noaa] are available [here][enc_charts].

###Related work

A handful of parsers exist.

#### [OpenCPN][opencpn]
OpenCPN is an excellent, although opinionated and bulky open source chart plotter in C++. It includes an adequate parser for ENC files.
![opencpn](https://a.fsdn.com/con/app/proj/opencpn/screenshots/screen.jpeg)


#### Other ENC parsers on Github
[This one](https://github.com/tburke/ihos57) does not look like it's going to happen, but [this one](https://github.com/KaiAbuSir/EncLib) may one day do some good.


[enc_charts]: http://www.charts.noaa.gov/InteractiveCatalog/nrnc.shtml#mapTabs-2
[noaa]: http://www.noaa.gov/
[s57]: https://www.iho.int/iho_pubs/standard/S-57Ed3.1/31Main.pdf
[iso8211]: https://webstore.iec.ch/publication/11636&preview=1
[iso8211_preview]: https://webstore.iec.ch/preview/info_isoiec8211%7Bed2.0%7Den.pdf
[opencpn]: https://github.com/OpenCPN/OpenCPN
