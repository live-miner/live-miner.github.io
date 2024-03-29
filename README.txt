live-miner
==========
Sam Morris <sam@robots.org.uk>

Burn this image to a CD, or write it to a USB stick, and when booted a system
will automatically begin mining bitcoins by using
https://github.com/m0mchil/poclbm[poclbm].

You can find the latest version at http://live-miner.github.io/. If something
doesn't work, https://github.com/live-miner/live-miner/issues[file a bug] or
mailto:sam@robots.org.uk[send me an email].  If you are feeling generous, send
spare BTC to `1MjtnhbdVAL21meEBnhHwfMSovN7kYtrH6`.

Requirements
------------

An x86_64 PC with an AMD Radeon HD 5000, 6000 or 7000 series graphics card.

Downloads
---------

http://live-miner.github.io/releases.html[Download live-miner here!]

Release 2: 2013-04-08::
	* Updated poclbm to support the http://mining.bitcoin.cz/stratum-mining[Stratum mining protocol]
	* Added support for multiple graphics cards
	* Added the ability for the user to provide their own `xorg.conf`
	* Changed window manager to i3
	* Allow reconfiguration at runtime

Release 1: 2012-08-20::
	* The initial release!

Configuration
-------------

Configuration happens in two places:

 1. Boot parameters
 2. Configuration file (`live/live-miner.conf`)

See `live/live-miner.conf` on the live medium for the list of options specific
to live-miner, and their corresponding boot parameters. The system can be
reconfigured at run time if you edit `/etc/live-miner.conf` and then restart
the GUI (press Windows+Shift+E).

In order to escape
spaces in boot parameters, use octal. For instance:

----
live-miner.urls=http://user:pass@host0:port\040http://user:pass@host1:port
----

Values from boot parameters override values from the file. Whether you use the
boot parameters or the configuration file will depend on how you choose to boot
live-miner.

See the man pages for
http://live.debian.net/manpages/3.x/en/html/live-boot.7.html[live-boot] and
http://live.debian.net/manpages/3.x/en/html/live-config.7.html[live-config] for
more boot parameters. Of particular note is `toram`; if you use this then you
can remove the USB stick or CD/DVD once the system has booted. This might be
useful if you have several machines, but only one USB stick!

USB stick
~~~~~~~~~

Write `binary.img` to your USB stick. On Linux, you can do something like this:

----
dd if=binary.img of=/dev/sdX
----

This will erase anything already on the device, so make sure you aren't
accidentally overwriting your hard disk! On Windows you can use a program such
as https://launchpad.net/win32-image-writer[Image Writer for Windows].

Once the image is written, remove and re-insert the USB stick. You should now
be able to edit `live/live-miner.conf`. Once you have done so, boot from the
USB stick and your computer should begin mining.

CD/DVD
~~~~~~

While `binary.iso` can be written to a CD and booted without any further
changes, you will have to do your configuration at the boot menu. To do so,
press the Tab key during the 5-second boot countdown, and then append boot
parameters to the list that appears. Press Enter to actually boot.

If you will be rebooting often, or have several computers to configure, you can
avoid the inconvenience of manual configuration by remastering the CD with an
edited `live/live-miner.conf`, or by booting with a different method.

Network
~~~~~~~

The netboot archive contains two directories: `debian-live`, the contents of
which should be shared over NFS; and `tftpboot`, the contents of which should
be available via TFTP. Setting this up requires some co-ordination between your
DHCP, TFTP and NFS servers. I use the same machine running Debian for all
three, on `10.0.0.1`. My setup is something like the following:

Install `isc-dhcp-server` and put the following in `/etc/dhcp/dhcpd.conf`:

----
subnet 10.0.0.0 netmask 255.255.0.0 {
    range 10.0.1.1 10.0.1.254;
    option routers 10.0.0.1;
    option domain-name-servers 10.0.0.1;
    filename "pxelinux.0";
    next-server 10.0.0.1;
}
----

Install `tftpd-hdpa` and move the contents of `tftpboot` to `/srv/tftp`. Modify
`/srv/tftp/live.cfg` to look like this:

----
label live-miner
menu label ^live-miner
kernel /live/vmlinuz
append initrd=/live/initrd.img boot=live config quiet netboot=nfs nfsroot=10.0.0.1:/srv/live-miner
----

Move the contents of `debian-live` to `/srv/live-miner`. Edit
`/srv/live-miner/live/live-miner.conf` to configure your server URLs and miner
options. Install `nfs-kernel-server` and export that directory via NFS by
adding the following to `/etc/exports`:

----
/srv/live-miner 10.0.0.0/16(ro,async,no_root_squash,no_subtree_check)
----

Run `exportfs -r` after editing `/etc/exports`. Finally, configure your
machines for network booting in their BIOS, and reboot them!

Overriding xorg.conf
--------------------

During boot, live-miner will look for AMD graphics cards and write out an
`/etc/X11/xorg.conf` that combines them all into one `ServerLayout` section.

If you provide `live/xorg.conf` on the live medium, it will be used instead of
the autogenerated file. An example config file is provided at
`live/xorg.conf.example`.

Building your own image
-----------------------

Most of the heavy lifting is done by the excellent tools provided by the
http://live.debian.net/[Debian Live project]. I'm building the images on a
Debian wheezy system, but any reasonably modern Linux system with
http://live.debian.net/manual-3.x/html/live-manual/installation.en.html#121[live-build]
3.0 installed should work.

After installing `live-build`, `make`, 'asciidoc' and `git`:

----
$ git clone --recursive https://github.com/live-miner/live-miner.git
$ cd live-miner
$ make
----

This will build three images (in `output/{hdd,iso,netboot}`) and collect the
source archives in `output/source`. Unless you really want all three and/or are
planning on distributing your built image to a third party, you can save time
by building just what you want: run `make output/stamp-hdd`, `make
output/stamp-iso` or `make output/netboot` instead.

*Important legal stuff*: If you are going to distribute the images you build
then be sure to do the full build of all three binary images, plus the source
archives. If you distribute a binary image to a third party, you must also
(offer to) give them the source archives as well. This is necessary because
live-miner contains materials licensed under the GPL (and similar licenses).

FAQ
---

[quanda]
How do I use this crazy GUI?::
	Windows+Enter will fire up a new terminal; Windows+D will open a quick
prompt for running other programs. To restart the GUI from scratch, press
Windows+Shift+E. To move the focus between windows, press Windows+Arrow keys.
See the http://i3wm.org/docs/userguide.html[i3 User's Guide] for the full
details, and the http://i3wm.org/docs/refcard.html[i3 Reference Card] for quick
reference.

Acknowledgements
----------------

The http://live.debian.net/[Debian Live project], for making it incredibly easy
to build a custom Debian Live CD.

The Debian project, for being Debian!

m0mchil, for https://github.com/m0mchil/poclbm[poclbm].

Mark Visser, for https://github.com/mjmvisser/adl3[adl3].

Obligatory legal mumbo-jumbo
----------------------------

Permission to use, copy, modify, and/or distribute live-miner for any purpose
is hereby granted. Note that live-miner includes many different programs. Their
exact terms of use are described in the individual files in
/usr/share/doc/*/copyright.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
