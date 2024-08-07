Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647511D6AA;
	Wed,  7 Aug 2024 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722993755; cv=none; b=Gr1sy06ewQPkPgbfFiGbPG5VOCmiWJd6LoE61d5ID/fKV5otip0aqX7sCLJzNivddRuu80JiVL6cgExgcuItjquIhcid/rBJ85FS3V9E4ujJwbmkiPHQLOoTdJONRoIHkaxoAdtmK14TCEjLCwskBnXgMenVgbd7OWmm4XLm02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722993755; c=relaxed/simple;
	bh=1mNTJ7YC2BIWunPhqbPijALT44J7LnVXlFM0/JYbZDU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VfEkRjEa/jYd3UXX995Rmhf5QxTG/4UkBonCYoQC2s/bj0Wx2WMK6+Hk6On3/TTwhrqIeXgs1UaFJL1aze2UwJgh4wzZwNscUOtBrDCL/eyTorxE7QIQnVNxr1xbS38iqR+uFSE05J3JppG5A2Z+iIM5TMKfoUqn4CQwznvbZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=AUl/UCDw; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="AUl/UCDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1722993719; x=1723598519; i=s.l-h@gmx.de;
	bh=XyZzFfP0ZyVnpjWY0tVZ0olNlC6rRuH6axVMz5DeHcI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AUl/UCDwEGtdzQepeqhK2clCrRS0giwI1dD+hQnfPETRO+fuTLHQ2qrHSdLFeh9Q
	 bYO2avrSxPkGBZ3SUAdvj1mbwQw0yGxRCsIzEEjDl0mgo5yRM2Uu/SRGwmCPNuZ0Y
	 OM3Qg/IGAIHeKdJF8A8LYV7Y2QpF6fdGVDNF3pVg+5JhoPLo5IeVl8+FYz+2ebRN8
	 VD9K6NYA8zIpU/3PHsRbCBwQX4IgWZf9pJsdZ1U3Z+Xwr8x8GNZ/QPd5H+SHd3Wu9
	 bq7qU+ehr9ow9k4FdwbhsIN+ou7uf6wSF1qsLqnsuMIKEZ2hGerDYENtP/cii1Na7
	 piqUzxIyTbeEeYCL6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.83.155]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mw9UK-1sKnR43Z9Y-011avN; Wed, 07
 Aug 2024 03:21:58 +0200
Date: Wed, 7 Aug 2024 03:21:52 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Sean Young <sean@mess.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>, Hans
 Verkuil <hverkuil-cisco@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240807032152.493b037c@mir>
In-Reply-To: <ZrJD_gHZCsphqT-U@gofer.mess.org>
References: <20240730151724.637682316@linuxfoundation.org>
	<20240730151735.968317438@linuxfoundation.org>
	<20240801165146.38991f60@mir>
	<Zq5KcGd8g4t2d11x@gofer.mess.org>
	<20240803180852.6eb5f0cb@mir>
	<ZrJD_gHZCsphqT-U@gofer.mess.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+Pkajb0p/SgYNP3rlmeG4ASQjEwFQ2sbrbiHfsdRQNhEXiOBtQS
 O/CKukDIl+qgSoxgIyFDfI126oruqJxuZ3nNlkHFh+ExqpGN1SHvcvtFbbcMt+osd1B1wzX
 fsuLe0C5qEEGejqycvI09MavntslCSf87fQ1jGZzrVMaVw8e6+jLXOkvalWFS+/YHlgiD4u
 qbl3GpJjdkyggL3bf88PQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kuIJ1NPaq0k=;MqZDEpIhfvyMtRPHYKpuhikwKJm
 Bm4GcD04mGppqlw7deOrSznXFyKmmr/TJvoRj7ghG4MUf+sNU+8F4cHTypit17X1R4FyXjujh
 YDHtYcfusLl7pO+Wy3VR3gNyFAoRxdPNwulr+dvqoy4LtrlYsMjMlJZLbKc7vwxcfWCakOXDS
 jR8boJ5yH3bhdDTT8GaRPFTzWTx3l3jjR44XqTO4U2eL8slMIpMkLt6ha71RnlaMlRALNPeoM
 z1ATg4LccEuFTFUff7p92Z979pmvkNbQVWGvIf29aU1vh66xLjSCuZfLB/krygUK+W7M+y3Ve
 /oKZVIsw8jOKsGS+lg6s6+wCiuPQQhAmAK+d0Dzm6rSaGgIXFfDe0r++UFbIXTNSh5RpBbEJr
 G1AemZvzWyg9CgaDP9repMziDyWiL3R2i1scb62vTrmweaHvoZS584m43qMbMJFj2e6Xact9m
 OBqUiB0ISe4Gt/1VAI2HsuCwYSrTxHjLgnixYYehDouwdG5R6rIYlcxYTiwpoKnuiPg26sYKm
 R6Grjc1bnPEv1Jy21y5sP3GL0QRe7kFD4JBVW3aGfdBKw2uZzooe2VRlzMcic/cXs3CZU+TG6
 O6mwZC7fSNV2B4CJmBykgSX/1eClN5TJgjskRovM6UWcQMKHA+WuBES6yM+z8F2efznlI0xJG
 8+rLXSYKWgctg3cZ6yoA5u98FwMclVA0sFvT7ESz2hfT/vEdpESmUrRNXBbgeOXo+Ryv1yR3Z
 +rRlzdFNbqY9e/vjkoldve4EUttNWENLpHNH0Hpy9cxxkpKi+hIpbqJ4wzZ9YYOVomhPtbszg
 rB20zpTvFhuhTMOCQ+6aXgAw==

Hi

On 2024-08-06, Sean Young wrote:
> On Sat, Aug 03, 2024 at 06:08:52PM +0200, Stefan Lippers-Hollmann wrote:
> > On 2024-08-03, Sean Young wrote:
> > > On Thu, Aug 01, 2024 at 04:51:46PM +0200, Stefan Lippers-Hollmann wr=
ote:
> > > > On 2024-07-30, Greg Kroah-Hartman wrote:
> > > > > 6.10-stable review patch.  If anyone has any objections, please =
let me know.
[...]
> > > > > Infinite log printing occurs during fuzz test:
> > > > >
> > > > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > > > >   ...
> > > > >   dvb-usb: schedule remote query interval to 100 msecs.
> > > > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully init=
ialized ...
> > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > >   ...
> > > > >   dvb-usb: bulk message failed: -22 (1/0)
> > > > >
> > > > > Looking into the codes, there is a loop in dvb_usb_read_remote_c=
ontrol(),
> > > > > that is in rc_core_dvb_usb_remote_init() create a work that will=
 call
> > > > > dvb_usb_read_remote_control(), and this work will reschedule its=
elf at
> > > > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_=
control(),
> > > > > see following code snippet:
[...]
> I don't think this drivers uses the bulk endpoint, and it is missing the
> corresponding out bulk endpoint.
>
> Please could you test the patch below please - that would be very helpfu=
l in
> narrowing down this issue.
[...]

After applying this patch, the TeVii s480 works again on both of my
systems, but there seems to be a new error message in the log

ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D 0xa2, value =3D=
=3D 0xb7)
ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D 0x03, value =3D=
=3D 0x12)
ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D 0x03, value =3D=
=3D 0x12)
ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D 0x03, value =3D=
=3D 0x02)
ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D 0x03, value =3D=
=3D 0x02)

The card/ driver is not totally silent otherwise, but I can reproduce
this over 5+ reboots with each kernel. Logs below from the sandy-bridge
x86_64 system (only TeVii s480 installed).

Old behaviour (v6.10.3 with "media: dvb-usb: Fix unexpected infinite
loop in dvb_usb_read_remote_control()" reverted):

$ dmesg | grep -i -e dvb -e dw2102 -e ds3000 -e ts2020
[    1.684825] usb 2-1: Product: DVBS2BOX
[    1.701050] usb 4-1: Product: DVBS2BOX
[    4.435989] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    4.436923] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    4.436927] dw2102: start downloading DW210X firmware
[    4.608568] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    4.608641] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    4.609001] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    4.840630] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    4.840769] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    4.849470] DS3000 chip version: 0.192 attached.
[    4.910145] ts2020 9-0060: Montage Technology TS2020 successfully ident=
ified
[    4.910468] dw2102: Attached ds3000+ts2020!
[    4.910474] usb 2-1: DVB: registering adapter 0 frontend 0 (Montage Tec=
hnology DS3000)...
[    4.910489] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    4.936777] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 1, =
scancode receiver, no transmitter
[    4.936958] dvb-usb: schedule remote query interval to 150 msecs.
[    4.936964] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    4.937039] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    4.937094] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    4.937097] dw2102: start downloading DW210X firmware
[    5.096566] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    5.096612] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    5.096960] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.345567] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    5.345825] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.349193] DS3000 chip version: 0.192 attached.
[    5.361941] ts2020 10-0060: Montage Technology TS2020 successfully iden=
tified
[    5.362312] dw2102: Attached ds3000+ts2020!
[    5.362318] usb 4-1: DVB: registering adapter 1 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.362326] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.363534] rc rc2: lirc_dev: driver dw2102 registered at minor =3D 2, =
scancode receiver, no transmitter
[    5.363692] dvb-usb: schedule remote query interval to 150 msecs.
[    5.363696] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    5.363739] usbcore: registered new interface driver dw2102
[    8.691350] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    8.691642] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.299494] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.299530] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.301416] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.301424] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.904482] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.904505] ds3000_firmware_ondemand: Waiting for firmware upload(2)...

New behaviour (v6.10.3 with this patch, "media: dw2102: TeVii DVB-S2 S660
does not have bulk endpoint", applied):

$ dmesg | grep -i -e dvb -e dw2102 -e ds3000 -e ts2020
[    1.638632] usb 5-1: Product: DVBS2BOX
[    1.653420] usb 7-1: Product: DVBS2BOX
[    4.228845] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    4.236973] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    4.236989] dw2102: start downloading DW210X firmware
[    4.400024] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    4.400090] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    4.400441] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    4.636293] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    4.636422] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    4.644701] DS3000 chip version: 0.192 attached.
[    4.706119] ts2020 9-0060: Montage Technology TS2020 successfully ident=
ified
[    4.706726] dw2102: Attached ds3000+ts2020!
[    4.706735] usb 5-1: DVB: registering adapter 0 frontend 0 (Montage Tec=
hnology DS3000)...
[    4.706749] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    4.732248] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 1, =
scancode receiver, no transmitter
[    4.732428] dvb-usb: schedule remote query interval to 150 msecs.
[    4.732433] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    4.732501] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    4.732548] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    4.732552] dw2102: start downloading DW210X firmware
[    4.896029] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    4.896090] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    4.896447] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.146200] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    5.146449] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.149849] DS3000 chip version: 0.192 attached.
[    5.208491] ts2020 10-0060: Montage Technology TS2020 successfully iden=
tified
[    5.208972] dw2102: Attached ds3000+ts2020!
[    5.208978] usb 7-1: DVB: registering adapter 1 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.208986] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.209659] rc rc2: lirc_dev: driver dw2102 registered at minor =3D 2, =
scancode receiver, no transmitter
[    5.209872] dvb-usb: schedule remote query interval to 150 msecs.
[    5.209878] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    5.209950] usbcore: registered new interface driver dw2102
[    8.477890] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    8.478405] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.076264] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0xa2, value =3D=3D 0xb7)
[    9.076296] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[    9.076313] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[    9.076331] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[    9.076346] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[    9.080866] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.080899] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.081898] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.081902] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[    9.677938] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0xa2, value =3D=3D 0xb7)
[    9.677999] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[    9.678040] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[    9.678079] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[    9.678122] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[    9.682856] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[    9.682884] ds3000_firmware_ondemand: Waiting for firmware upload(2)...

Same new error message on the raptor-lake system:

$ dmesg | grep -i -e dvb -e dw2102 -e ds3000 -e ts2020
[    3.105834] dvb-usb: found a 'TeVii S480.2 USB' in cold state, will try=
 to load a firmware
[    3.105982] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.105984] dw2102: start downloading DW210X firmware
[    3.261142] dvb-usb: found a 'TeVii S480.2 USB' in warm state.
[    3.261268] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.261289] dvbdev: DVB: registering new adapter (TeVii S480.2 USB)
[    3.261339] dvb-usb: MAC address: 8b:8b:8b:8b:8b:8b
[    3.261422] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.263774] Invalid probe, probably not a DS3000
[    3.264382] dvb-usb: no frontend was attached by 'TeVii S480.2 USB'
[    3.289229] rc rc0: lirc_dev: driver dw2102 registered at minor =3D 0, =
scancode receiver, no transmitter
[    3.301371] dvb-usb: schedule remote query interval to 150 msecs.
[    3.301382] dvb-usb: TeVii S480.2 USB successfully initialized and conn=
ected.
[    3.301479] dvb-usb: found a 'TeVii S480.1 USB' in cold state, will try=
 to load a firmware
[    3.301534] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.301538] dw2102: start downloading DW210X firmware
[    3.344870] dvb-usb: TeVii S480.2 USB successfully deinitialized and di=
sconnected.
[    3.453179] dvb-usb: found a 'TeVii S480.1 USB' in warm state.
[    3.453437] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.453507] dvbdev: DVB: registering new adapter (TeVii S480.1 USB)
[    3.453738] dvb-usb: MAC address: b3:b3:b3:b3:b3:b3
[    3.454071] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.454698] Invalid probe, probably not a DS3000
[    3.456655] dvb-usb: no frontend was attached by 'TeVii S480.1 USB'
[    3.458763] rc rc0: lirc_dev: driver dw2102 registered at minor =3D 0, =
scancode receiver, no transmitter
[    3.458896] dvb-usb: schedule remote query interval to 150 msecs.
[    3.458900] dvb-usb: TeVii S480.1 USB successfully initialized and conn=
ected.
[    3.458953] usbcore: registered new interface driver dw2102
[    3.497370] dvb-usb: TeVii S480.1 USB successfully deinitialized and di=
sconnected.
[    3.510918] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in c=
old state, will try to load a firmware
[    3.511231] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.=
20.fw'
[    4.102223] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in w=
arm state.
[    4.102420] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    4.102965] dvbdev: DVB: registering new adapter (Microsoft Xbox One Di=
gital TV Tuner)
[    4.103265] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    4.282575] usb 6-5: DVB: registering adapter 0 frontend 0 (Panasonic M=
N88472)...
[    4.282586] dvbdev: dvb_create_media_entity: media entity 'Panasonic MN=
88472' registered.
[    4.282871] dvb-usb: Microsoft Xbox One Digital TV Tuner successfully i=
nitialized and connected.
[    4.283033] usbcore: registered new interface driver dvb_usb_dib0700
[    5.033690] usb 1-1: Product: DVBS2BOX
[    5.034104] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    5.034139] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    5.034141] dw2102: start downloading DW210X firmware
[    5.189199] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    5.189490] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    5.189857] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.226403] usb 3-1: Product: DVBS2BOX
[    5.226870] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    5.226912] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    5.226915] dw2102: start downloading DW210X firmware
[    5.381171] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    5.381417] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    5.381861] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.436278] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    5.436503] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.439527] DS3000 chip version: 0.192 attached.
[    5.533899] ts2020 13-0060: Montage Technology TS2020 successfully iden=
tified
[    5.534271] dw2102: Attached ds3000+ts2020!
[    5.534277] usb 1-1: DVB: registering adapter 1 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.534287] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.534895] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 1, =
scancode receiver, no transmitter
[    5.535069] dvb-usb: schedule remote query interval to 150 msecs.
[    5.535072] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    5.624792] dvb-usb: MAC address: 00:18:bd:XX:XX:xx
[    5.624993] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.628417] DS3000 chip version: 0.192 attached.
[    5.695664] ts2020 14-0060: Montage Technology TS2020 successfully iden=
tified
[    5.696037] dw2102: Attached ds3000+ts2020!
[    5.696042] usb 3-1: DVB: registering adapter 2 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.696051] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.696598] rc rc2: lirc_dev: driver dw2102 registered at minor =3D 2, =
scancode receiver, no transmitter
[    5.696764] dvb-usb: schedule remote query interval to 150 msecs.
[    5.696767] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[   12.622893] mn88472 12-0018: downloading firmware from file 'dvb-demod-=
mn88472-02.fw'
[   12.778138] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   12.778301] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[   13.375913] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.375968] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[   13.377005] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.377018] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[   13.972206] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0xa2, value =3D=3D 0x07)
[   13.972225] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[   13.972232] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x12)
[   13.972238] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[   13.972242] ds3000_writereg: writereg error(err =3D=3D -11, reg =3D=3D =
0x03, value =3D=3D 0x02)
[   13.976900] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.976978] ds3000_firmware_ondemand: Waiting for firmware upload(2)...

Technically, the card does work now on both systems, vdr 2.6.0 starts up
and I can use both frontends concurrently.

Thanks a lot for looking into this and sorry for the delay, but I
just got home to my system(s).

Regards
	Stefan Lippers-Hollmann

=2D-
$ md5sum -b *.fw
a32d17910c4f370073f9346e71d34b80 *dvb-fe-ds3000.fw
3d88c577b7a1ef370cef039cec3f665f *dvb-usb-dw2102.fw
2946e99fe3a4973ba905fcf59111cf40 *dvb-usb-s660.fw

$ sha256sum -b *.fw
ad8c23bfb51642f48d31fe4f797182352bb13a4d4b7247b25aea18e208e0e882 *dvb-fe-d=
s3000.fw
96560cd6e04b187dad1d6079716a8970273f3729f3e0342a609d5d3fc6dce30b *dvb-usb-=
dw2102.fw
454a93c4c6604e9b5e33b2dc9afe49194f4d8471a3e37863ac04af7245ca2f59 *dvb-usb-=
s660.fw
