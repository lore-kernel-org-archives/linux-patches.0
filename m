Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83F7F
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 03:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1686627196; x=1687231996; i=s.l-h@gmx.de;
 bh=msZvXqPw/dhid6/NvZwLoi7NiphU3a9DuyFNhP/pA6U=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
 b=R/xz7fQOOOuTBDqZnS96uMd60PBWD8qtTcLd/T0MykO8x4HRT3e4TcA9S5MZTYHdYsU9YNg
 vmvKFwGSsCh28BfQcRTVcWmJC8GTffVtgdFAYH2hVDDjdzjTncLAHO0rOnrFyVs1rawSoLh9X
 U3Rm82edhdJ5qJ3KQvXIgCQHmb+dPamUYJVDHNCMxbS0EdzgO3wXN+vN2hhiIys/HRzMAePX2
 hnzKIxxfA0zByokftR8Es0rM8tKXelnlCA5AHNM7O7X4cDjN/KYevfu6a7wv9XDdMy4VjmDdt
 jdWJAY/jvJuD+5cajbxdlYWFezTVbu6JPM39gJhuyVKtjjht88Gg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.90.21]) by mail.gmx.net (mrgmx105 [212.227.17.168])
 with ESMTPSA (Nemesis) id 1MDhhX-1qFkvk3LvT-00AmJf; Tue, 13 Jun 2023 05:33:15
 +0200
Date: Tue, 13 Jun 2023 05:33:14 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Hyunwoo Kim
 <imv4bel@gmail.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 136/286] media: dvb-core: Fix use-after-free on race
 condition at dvb_frontend
Message-ID: <20230613053314.70839926@mir>
In-Reply-To: <20230607200927.531074599@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
 <20230607200927.531074599@linuxfoundation.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+1Tibscsx3f0DKWCxO4xboGTqaAeSW3lmtlX7sjG9AhkwVd7sia
 ki/SoXIGxR+hkpDKrHhkQu1xUVwGx8JJVa/DE2CUPSwPUsf81AoQSIlcNAaj+iwag8ZDqrZ
 fWe2lRTLun7EOzwbBootwMEGj7khcD8ROqPNS1g4XKlM4l3wrr9iWIxCqNdhtXhk+QGZwk6
 YTS+MAu387iuHiArYpWSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7pAGYykS8jg=;AxFcyyGPzKYz40jwhHe7BBO+M0l
 ae7uNjyWmPNDZ+AnJ1TJdnY8q7AK/eSfNPexgZV2K/tPNnVRAFdg/Qn+PCW51MMbR1GG8fgqk
 oOIsqGTdO47QgDJibXvlOAFyn/962HnOWOcmG9nrnX1m1724b8wWQUSLCvlo2BgiI9q11ZAR8
 FrI1iCm3U/aAmi9ESMfIcPh1bDk232V4LeEZDMuFf9dXlNdLKEbvLQj9qIC/ptCrchTNidvjQ
 GziW1NE46818jtUeuwybmJCJOnWFXyLMUSe8qXm1Y2sybez37iX9kNNC6b5boDIzeHyubT9Df
 KJqyyW6dRj2WXzitOroqQoBfUhwPfpJL5FZ7xvbA7XigYMBFHnppuj0A/6eCTtYiww808BZVN
 hcgcTvylWXycx4JfLaiZdYvQCP9py3qztZ2Q4+5vsPGovbqd94p0mReehURYNgCTL83yp2BuI
 xG5mFDdIRFN/GCU/7zNp2GghklEAnVFTqwpvkhC72hREN91XRAACaNvCSsWmsGot4tod24Oa+
 YkV/2zF3LjwjKeQVqu5gMI9a5WVeJ3Jd/Yc2G3ioDbDlKcQezr3YnIbq0xVqr43pParYA56Gh
 ZavcaTRBecJ4cv8sXqBZgWRUzTL+ixg4X6eZV8KDTbqAVWto5hEBUxxcCjp6Rk/F2yhfHwvnt
 bIZrya1F7SW/pSgRK7z6I4y+dxJIt1HnOEX7xBUwXOTijd6z77QLT0JXn25o+KiF+ci2UnuB5
 S3MjqEmUhu1ZxY2TyURLVYxlgnH5Gq+wb1p3WZr1Ar251wuXTPg2/a+LLo4ChdsEBPBWdss9k
 bMdWSn9P+HiU6ytKJQPvTPiqzUwLHEOcMMTQYXWejPH3TjTAkXJyWqQ36TmT2JoxbplgDniy0
 4vv5HUsa1LHU6XdNVQUBxEjenL1htCGUue5JgPQgkAgT7LhR3IdE9rTWxyjRU+VJuQ3zrIAA5
 FU0i9Q==

Hi

On 2023-06-07, Greg Kroah-Hartman wrote:
> From: Hyunwoo Kim <imv4bel@gmail.com>
>
> [ Upstream commit 6769a0b7ee0c3b31e1b22c3fadff2bfb642de23f ]
>
> If the device node of dvb_frontend is open() and the device is
> disconnected, many kinds of UAFs may occur when calling close()
> on the device node.
>
> The root cause of this is that wake_up() for dvbdev->wait_queue
> is implemented in the dvb_frontend_release() function, but
> wait_event() is not implemented in the dvb_frontend_stop() function.
>
> So, implement wait_event() function in dvb_frontend_stop() and
> add 'remove_mutex' which prevents race condition for 'fe->exit'.
>
> [mchehab: fix a couple of checkpatch warnings and some mistakes at the e=
rror handling logic]
>
> Link: https://lore.kernel.org/linux-media/20221117045925.14297-2-imv4bel=
@gmail.com
[...]

I'm noticing a regression relative to kernel v6.3.6 with this change
as part of kernel v6.3.7 on my ivy-bridge system running
Debian/unstable (amd64) with vdr 2.6.0-1.1[0] and two DVB cards
TeVii S480 V2.1 (DVB-S2, dw2102) and an Xbox One Digital TV Tuner
(DVB-T2, dvb_usb_dib0700). The systemd unit starting vdr just times
out and hangs forever, with vdr never coming up and also preventing
a clean system shutdown (hard reset required). Apart from the systemd
unit timing out, there don't really appear to be any further issues
logged.

# systemctl status -l vdr.service | cat
=E2=97=8F vdr.service - Video Disk Recorder
     Loaded: loaded (/lib/systemd/system/vdr.service; enabled; preset: ena=
bled)
    Drop-In: /etc/systemd/system/vdr.service.d
             =E2=94=94=E2=94=80override.conf, umask.conf
     Active: deactivating (stop-sigterm) (Result: timeout)
    Process: 762 ExecStartPre=3D/bin/sh /usr/lib/vdr/merge-commands.sh com=
mands (code=3Dexited, status=3D0/SUCCESS)
    Process: 1070 ExecStartPre=3D/bin/sh /usr/lib/vdr/merge-commands.sh re=
ccmds (code=3Dexited, status=3D0/SUCCESS)
   Main PID: 1088 (vdr)
      Tasks: 1 (limit: 38073)
     Memory: 215.8M
        CPU: 738ms
     CGroup: /system.slice/vdr.service
             =E2=94=94=E2=94=801088 /usr/bin/vdr

Jun 13 05:15:35 system vdr[1088]: [1088] detected /dev/dvb/adapter1/fronte=
nd0
Jun 13 05:15:35 system vdr[1088]: [1088] detected /dev/dvb/adapter0/fronte=
nd0
Jun 13 05:15:35 system vdr[1088]: [1088] probing /dev/dvb/adapter0/fronten=
d0
Jun 13 05:15:35 system vdr[1088]: [1088] creating cDvbDevice
Jun 13 05:15:35 system vdr[1088]: [1088] new device number 1 (card index 1=
)
Jun 13 05:15:35 system vdr[1088]: [1088] DVB API version is 0x050B (VDR wa=
s built with 0x050B)
Jun 13 05:15:35 system vdr[1088]: [1088] frontend 0/0 provides DVB-T,DVB-T=
2,DVB-C with QPSK,QAM16,QAM32,QAM64,QAM128,QAM256 ("Panasonic MN88472")
Jun 13 05:15:35 system vdr[1088]: [1090] epg data reader thread ended (pid=
=3D1088, tid=3D1090)
Jun 13 05:15:37 system vdr[1088]: [1089] video directory scanner thread en=
ded (pid=3D1088, tid=3D1089)
Jun 13 05:17:04 system systemd[1]: vdr.service: start operation timed out.=
 Terminating.

TeVii S480 V2.1 (this is effectively a PCIe card with a USB hub and
two TeVii s660 card on the same PCB):

lspci -nn:
04:00.0 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.1 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.2 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.3 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.4 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.5 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.6 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
04:00.7 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]

lsusb:
Bus 002 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Xbox One Digital TV Tuner

lsusb:
Bus 001 Device 005: ID 045e:02d5 Microsoft Corp. Xbox One Digital TV Tuner

dmesg (excerpt):

[    1.452325] usb 3-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    1.453824] usb 3-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    1.453829] usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    1.453831] usb 3-1: Product: DVBS2BOX
[    1.453833] usb 3-1: Manufacturer: TBS-Tech
...
[    1.475380] usb 6-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    1.476504] usb 6-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    1.476510] usb 6-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    1.476513] usb 6-1: Product: DVBS2BOX
[    1.476515] usb 6-1: Manufacturer: TBS-Tech
[    1.711179] usb 1-1.5: new full-speed USB device number 3 using ehci-pc=
i
[    1.719179] usb 2-1.3: new full-speed USB device number 3 using ehci-pc=
i
...
[    2.209899] usb 2-1.6: New USB device found, idVendor=3D045e, idProduct=
=3D02d5, bcdDevice=3D 1.10
[    2.209903] usb 2-1.6: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D3
[    2.209905] usb 2-1.6: Product: Xbox USB Tuner
[    2.209907] usb 2-1.6: Manufacturer: Microsoft Corp.
[    2.209908] usb 2-1.6: SerialNumber: 005099070515
[    2.256025] usb 1-1.8: New USB device found, idVendor=3D046d, idProduct=
=3Dc069, bcdDevice=3D56.01
[    2.256030] usb 1-1.8: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D0
...
[    3.208796] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    3.209147] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.209154] dw2102: start downloading DW210X firmware
[    3.211830] IR RC6 protocol handler initialized
...
[    3.221848] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in w=
arm state.
[    3.221930] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.222327] dvbdev: DVB: registering new adapter (Microsoft Xbox One Di=
gital TV Tuner)
[    3.222333] usb 2-1.6: media controller created
...
[    3.221848] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in w=
arm state.
[    3.221930] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.222327] dvbdev: DVB: registering new adapter (Microsoft Xbox One Di=
gital TV Tuner)
[    3.222333] usb 2-1.6: media controller created
[    3.222552] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
...
[    3.367164] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    3.367241] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.367597] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    3.367603] usb 3-1: media controller created
[    3.397279] mn88472 10-0018: Panasonic MN88472 successfully identified
[    3.400166] tda18250 10-0060: NXP TDA18250BHN/M successfully identified
[    3.403933] usb 2-1.6: DVB: registering adapter 0 frontend 0 (Panasonic=
 MN88472)...
[    3.403941] dvbdev: dvb_create_media_entity: media entity 'Panasonic MN=
88472' registered.
[    3.404241] dvb-usb: Microsoft Xbox One Digital TV Tuner successfully i=
nitialized and connected.
[    3.404461] usbcore: registered new interface driver dvb_usb_dib0700
[    3.414990] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=3D=
635 'alsactl'
...
[    3.616707] dvb-usb: MAC address: 00:18:bd:5a:be:8c
[    3.616946] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.628076] DS3000 chip version: 0.192 attached.
[    3.690739] ts2020 11-0060: Montage Technology TS2020 successfully iden=
tified
[    3.691064] dw2102: Attached ds3000+ts2020!
[    3.691070] usb 3-1: DVB: registering adapter 1 frontend 0 (Montage Tec=
hnology DS3000)...
[    3.691078] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    3.717182] Registered IR keymap rc-tevii-nec
[    3.717231] rc rc1: TeVii S660 USB as /devices/pci0000:00/0000:00:1c.5/=
0000:04:00.3/usb3/3-1/rc/rc1
[    3.717346] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 1, =
scancode receiver, no transmitter
[    3.717412] input: TeVii S660 USB as /devices/pci0000:00/0000:00:1c.5/0=
000:04:00.3/usb3/3-1/rc/rc1/input20
[    3.717480] dvb-usb: schedule remote query interval to 150 msecs.
[    3.717484] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    3.717531] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    3.717566] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.717569] dw2102: start downloading DW210X firmware
[    3.871216] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    3.871389] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.871785] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    3.871794] usb 6-1: media controller created
...
[    4.109692] dvb-usb: MAC address: 00:18:bd:5a:be:8b
[    4.109930] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    4.113052] DS3000 chip version: 0.192 attached.
[    4.162597] ts2020 12-0060: Montage Technology TS2020 successfully iden=
tified
[    4.162967] dw2102: Attached ds3000+ts2020!
[    4.162975] usb 6-1: DVB: registering adapter 2 frontend 0 (Montage Tec=
hnology DS3000)...
[    4.162984] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    4.164314] Registered IR keymap rc-tevii-nec
[    4.164381] rc rc2: TeVii S660 USB as /devices/pci0000:00/0000:00:1c.5/=
0000:04:00.1/usb6/6-1/rc/rc2
[    4.164474] rc rc2: lirc_dev: driver dw2102 registered at minor =3D 2, =
scancode receiver, no transmitter
[    4.164578] input: TeVii S660 USB as /devices/pci0000:00/0000:00:1c.5/0=
000:04:00.1/usb6/6-1/rc/rc2/input21
[    4.164671] dvb-usb: schedule remote query interval to 150 msecs.
[    4.164676] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    4.164756] usbcore: registered new interface driver dw2102
...

journalctl (filtered):
# journalctl -b | grep -i -e dvb -e vdr
Jun 13 05:15:21 system kernel: usb 2-1: Product: DVBS2BOX
Jun 13 05:15:21 system kernel: usb 6-1: Product: DVBS2BOX
Jun 13 05:15:21 system udevadm[415]: systemd-udev-settle.service is deprec=
ated. Please fix vdr.service not to pull it in.
Jun 13 05:15:21 system systemd[1]: Found device dev-vg\x2dsystem-vdr.devic=
e - /dev/vg-system/vdr.
Jun 13 05:15:22 system kernel: dvb-usb: found a 'TeVii S660 USB' in cold s=
tate, will try to load a firmware
Jun 13 05:15:22 system kernel: dvb-usb: downloading firmware from file 'dv=
b-usb-s660.fw'
Jun 13 05:15:22 system kernel: dvb-usb: found a 'Microsoft Xbox One Digita=
l TV Tuner' in warm state.
Jun 13 05:15:22 system kernel: dvb-usb: will pass the complete MPEG2 trans=
port stream to the software demuxer.
Jun 13 05:15:22 system kernel: dvbdev: DVB: registering new adapter (Micro=
soft Xbox One Digital TV Tuner)
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'dvb-demux' registered.
Jun 13 05:15:22 system systemd[1]: Starting systemd-fsck@dev-vg\x2dsystem-=
vdr.service - File System Check on /dev/vg-system/vdr...
Jun 13 05:15:22 system kernel: dvb-usb: found a 'TeVii S660 USB' in warm s=
tate.
Jun 13 05:15:22 system kernel: dvb-usb: will pass the complete MPEG2 trans=
port stream to the software demuxer.
Jun 13 05:15:22 system kernel: dvbdev: DVB: registering new adapter (TeVii=
 S660 USB)
Jun 13 05:15:22 system kernel: usb 3-1.6: DVB: registering adapter 0 front=
end 0 (Panasonic MN88472)...
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'Panasonic MN88472' registered.
Jun 13 05:15:22 system kernel: dvb-usb: Microsoft Xbox One Digital TV Tune=
r successfully initialized and connected.
Jun 13 05:15:22 system kernel: usbcore: registered new interface driver dv=
b_usb_dib0700
Jun 13 05:15:22 system systemd-fsck[650]: vdr: clean, 472/19660800 files, =
65559385/78643200 blocks
Jun 13 05:15:22 system systemd[1]: Finished systemd-fsck@dev-vg\x2dsystem-=
vdr.service - File System Check on /dev/vg-system/vdr.
Jun 13 05:15:22 system kernel: dvb-usb: MAC address: 00:18:bd:5a:be:8c
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'dvb-demux' registered.
Jun 13 05:15:22 system kernel: usb 2-1: DVB: registering adapter 1 fronten=
d 0 (Montage Technology DS3000)...
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'Montage Technology DS3000' registered.
Jun 13 05:15:22 system kernel: dvb-usb: schedule remote query interval to =
150 msecs.
Jun 13 05:15:22 system kernel: dvb-usb: TeVii S660 USB successfully initia=
lized and connected.
Jun 13 05:15:22 system kernel: dvb-usb: found a 'TeVii S660 USB' in cold s=
tate, will try to load a firmware
Jun 13 05:15:22 system kernel: dvb-usb: downloading firmware from file 'dv=
b-usb-s660.fw'
Jun 13 05:15:22 system kernel: dvb-usb: found a 'TeVii S660 USB' in warm s=
tate.
Jun 13 05:15:22 system kernel: dvb-usb: will pass the complete MPEG2 trans=
port stream to the software demuxer.
Jun 13 05:15:22 system kernel: dvbdev: DVB: registering new adapter (TeVii=
 S660 USB)
Jun 13 05:15:22 system systemd[1]: Mounting srv-vdr.mount - /srv/vdr...
Jun 13 05:15:22 system systemd[1]: Mounted srv-vdr.mount - /srv/vdr.
Jun 13 05:15:22 system kernel: dvb-usb: MAC address: 00:18:bd:5a:be:8b
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'dvb-demux' registered.
Jun 13 05:15:22 system kernel: usb 6-1: DVB: registering adapter 2 fronten=
d 0 (Montage Technology DS3000)...
Jun 13 05:15:22 system kernel: dvbdev: dvb_create_media_entity: media enti=
ty 'Montage Technology DS3000' registered.
Jun 13 05:15:22 system kernel: dvb-usb: schedule remote query interval to =
150 msecs.
Jun 13 05:15:22 system kernel: dvb-usb: TeVii S660 USB successfully initia=
lized and connected.
Jun 13 05:15:28 system systemd[1]: Starting vdr.service - Video Disk Recor=
der...
Jun 13 05:15:34 system vdr[1088]: [1088] VDR version 2.6.0 started
Jun 13 05:15:34 system vdr[1088]: [1088] switched to user 'vdr'
Jun 13 05:15:34 system vdr[1088]: [1088] codeset is 'UTF-8' - known
Jun 13 05:15:34 system vdr[1088]: [1088] found 28 locales in /usr/share/lo=
cale
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'alb,=
sqi'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'bos'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'bul'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'chi,=
zho'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'eus,=
baq'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'iri,=
gle'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'jpn'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'lav'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'ltz'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'mlt'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'por'
Jun 13 05:15:34 system vdr[1088]: [1088] no locale for language code 'smi'
Jun 13 05:15:34 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-conflictcheckonly.so.2.6.0
Jun 13 05:15:34 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-epgsearch.so.2.6.0
Jun 13 05:15:34 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-epgsearchonly.so.2.6.0
Jun 13 05:15:34 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-femon.so.2.6.0
Jun 13 05:15:34 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-live.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] live: INFO: validating server ip =
'0.0.0.0'
Jun 13 05:15:35 system vdr[1088]: INFO: validating live server ip '0.0.0.0=
'
Jun 13 05:15:35 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-osdteletext.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-quickepgsearch.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-streamdev-client.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-streamdev-server.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] loading plugin: /usr/lib/vdr/plug=
ins/libvdr-xineliboutput.so.2.6.0
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/setup.conf
Jun 13 05:15:35 system vdr[1088]: [1088] [xine..put] Skipping configuratio=
n entry Remote.ListenPort=3D37890 (overridden in command line)
Jun 13 05:15:35 system vdr[1088]: [1088] [xine..put] Skipping configuratio=
n entry RemoteMode=3D1 (overridden in command line)
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/sources.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/diseqc.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/scr.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/channels.con=
f
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/timers.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/commands.con=
f
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/reccmds.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/svdrphosts.c=
onf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/remote.conf
Jun 13 05:15:35 system vdr[1088]: [1088] loading /var/lib/vdr/keymacros.co=
nf
Jun 13 05:15:35 system vdr[1088]: [1088] registered source parameters for =
'A - ATSC'
Jun 13 05:15:35 system vdr[1088]: [1088] registered source parameters for =
'C - DVB-C'
Jun 13 05:15:35 system vdr[1088]: [1088] registered source parameters for =
'S - DVB-S'
Jun 13 05:15:35 system vdr[1088]: [1089] video directory scanner thread st=
arted (pid=3D1088, tid=3D1089, prio=3Dlow)
Jun 13 05:15:35 system vdr[1088]: [1088] registered source parameters for =
'T - DVB-T'
Jun 13 05:15:35 system vdr[1088]: [1090] epg data reader thread started (p=
id=3D1088, tid=3D1090, prio=3Dhigh)
Jun 13 05:15:35 system vdr[1088]: [1090] reading EPG data from /var/cache/=
vdr/epg.data
Jun 13 05:15:35 system vdr[1088]: [1088] detected /dev/dvb/adapter2/fronte=
nd0
Jun 13 05:15:35 system vdr[1088]: [1088] detected /dev/dvb/adapter1/fronte=
nd0
Jun 13 05:15:35 system vdr[1088]: [1088] detected /dev/dvb/adapter0/fronte=
nd0
Jun 13 05:15:35 system vdr[1088]: [1088] probing /dev/dvb/adapter0/fronten=
d0
Jun 13 05:15:35 system vdr[1088]: [1088] creating cDvbDevice
Jun 13 05:15:35 system vdr[1088]: [1088] new device number 1 (card index 1=
)
Jun 13 05:15:35 system kernel: mn88472 10-0018: downloading firmware from =
file 'dvb-demod-mn88472-02.fw'
Jun 13 05:15:35 system vdr[1088]: [1088] DVB API version is 0x050B (VDR wa=
s built with 0x050B)
Jun 13 05:15:35 system vdr[1088]: [1088] frontend 0/0 provides DVB-T,DVB-T=
2,DVB-C with QPSK,QAM16,QAM32,QAM64,QAM128,QAM256 ("Panasonic MN88472")
Jun 13 05:15:35 system vdr[1088]: [1090] epg data reader thread ended (pid=
=3D1088, tid=3D1090)
Jun 13 05:15:37 system vdr[1088]: [1089] video directory scanner thread en=
ded (pid=3D1088, tid=3D1089)
Jun 13 05:17:04 system systemd[1]: vdr.service: start operation timed out.=
 Terminating.
Jun 13 05:18:34 system systemd[1]: vdr.service: State 'stop-sigterm' timed=
 out. Killing.
Jun 13 05:18:34 system systemd[1]: vdr.service: Killing process 1088 (vdr)=
 with signal SIGKILL.
Jun 13 05:20:05 system systemd[1]: vdr.service: Processes still around aft=
er SIGKILL. Ignoring.

git bisection:
$ LANG=3D git bisect log
git bisect start
# Status: warte auf guten und schlechten Commit
# bad: [e282393f9d0cd66cee8c68a80f4936f46c449b2d] Linux 6.3.7
git bisect bad e282393f9d0cd66cee8c68a80f4936f46c449b2d
# Status: warte auf gute(n) Commit(s), schlechter Commit bekannt
# good: [abfd9cf1c3d4d143a889b76af835078897e46c55] Linux 6.3.6
git bisect good abfd9cf1c3d4d143a889b76af835078897e46c55
# bad: [95055e6eb8319d5e929380bb7246362815890b75] ASoC: SOF: pm: save io r=
egion state in case of errors in resume
git bisect bad 95055e6eb8319d5e929380bb7246362815890b75
# good: [7a5427ae3f1da6c61e38060a6c1865b0ab2e8f43] mtd: rawnand: marvell: =
don't set the NAND frequency select
git bisect good 7a5427ae3f1da6c61e38060a6c1865b0ab2e8f43
# good: [8e4aa73e787cbdc9e58ed41ccc44a48ceab2d890] fbdev: modedb: Add 1920=
x1080 at 60 Hz video mode
git bisect good 8e4aa73e787cbdc9e58ed41ccc44a48ceab2d890
# good: [722993741c696ebe4855a403c98408d720be2386] media: dvb-usb: az6027:=
 fix three null-ptr-deref in az6027_i2c_xfer()
git bisect good 722993741c696ebe4855a403c98408d720be2386
# good: [ec35bef6256ddc24114c7e6749c0baa1b467bcc4] media: mn88443x: fix !C=
ONFIG_OF error by drop of_match_ptr from ID table
git bisect good ec35bef6256ddc24114c7e6749c0baa1b467bcc4
# bad: [47dc2e5f5fb45aff7f9c32f10412125ee13cb5ce] media: dvb-core: Fix ker=
nel WARNING for blocking operation in wait_event*()
git bisect bad 47dc2e5f5fb45aff7f9c32f10412125ee13cb5ce
# bad: [8bade849b15b3ecb62893f328b2cc4cdc65ac0c6] media: dvb-core: Fix use=
-after-free due on race condition at dvb_net
git bisect bad 8bade849b15b3ecb62893f328b2cc4cdc65ac0c6

Reverting just this patch from v6.3.7 and v6.3.8-rc1 fixes the problem
for me, vdr starts up and is fully usable.

Regards
	Stefan Lippers-Hollmann

[0] packaging at https://salsa.debian.org/vdr-team/vdr.git
