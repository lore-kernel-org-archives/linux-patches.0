Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43AD1A57D4;
	Thu,  1 Aug 2024 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722523937; cv=none; b=H//THb1kY6NCN2rf7igNqaLo6T8U22kb/oelzXSrqX4WgmvfuzS0msqQfEVgW/cbG9qj+YEGB4R564VNSwrpVZAYZ8mzSFEaLC+jwQwMlTNuomQl6BeJ7bAKSuWr3bSDMIFW/ebPJyyezq+fuZEg1kYlXeposoNo0o8YB9jN6HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722523937; c=relaxed/simple;
	bh=Sx4LnAokAVGxFMDmzqEOYf2mouairaMnqeQ+nlwUmBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TrpNVDO5OdEHomDnzvcUmlvBkImzLxkQogVTg0CZPDMb1YxLRc8ufUhKgkXV2KXANGmgvl8bB72R8/y11DeNhOdwc1HNLVxfkA7DA5/RNOh0M1CTuDX45mOTSNN6n3Ca/FxTdQYpLJrUmpoLug9HjZG/4ak0OPlkwlXf2Z9Qb+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=g+pomVEO; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="g+pomVEO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1722523909; x=1723128709; i=s.l-h@gmx.de;
	bh=sZjAK1kGV4/ZQxNAwHNKAASAXTed3HSFE5bcvquk0W4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=g+pomVEOgYEQ/fX5mmEvYi37IQee/4pt1OYCmQfyZNfmICWIu8HYsspM7Xes8mGr
	 POkPhhKz9FaISQxH9krlb7HXXTPF2qdar8+ozhUYlNqWLKaThHEIYRS+vhhY5kaWl
	 yv2jXOvORFftD9/MnSu7vRDVeCkxbPr7mNE16pL6F9dBwyvHDywcTkJnV2AWOIde9
	 tMzurTH8+8LVpqNSj6UuAZiP9i8ppHbtkZ93pxwrSnOdyDKQgRH4Wqtccx3IOHP78
	 OjOpa96bCnxU29/7Kxo0Tein1PGPqL6Ihw88iHII0S9sAAAkh3QoFvZAAksxHhIbV
	 odhA9Ik4VLxCu4koXg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.83.155]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M59C8-1sadcG3Oyq-00DEBy; Thu, 01
 Aug 2024 16:51:48 +0200
Date: Thu, 1 Aug 2024 16:51:46 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Zheng Yejian
 <zhengyejian1@huawei.com>, Sean Young <sean@mess.org>, Hans Verkuil
 <hverkuil-cisco@xs4all.nl>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240801165146.38991f60@mir>
In-Reply-To: <20240730151735.968317438@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
	<20240730151735.968317438@linuxfoundation.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6y+TVMDKWnyXo7sJWyCKe3sH4G/iapGv9ps9hTyfDBoL6oqJAZz
 ciBTQUfG2fVpkjqSiCf+frWYA5SDhy1Uox4ITQSAtV/OnSWO6GFhkb+D7oAvkA4SbB40Dg8
 VFDVjexeUWEYkAdNEZlY5v+cBpwxcIXffEx9IcwJn0w+hU63Xr83gxZ/vCwDxmNwpYtmD/U
 uB3fwju21+Bo/iDHMV0RA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W4ijU84EKZk=;CqkFqytxP7qM7kLUTsdkZfAWi0S
 117zJDBzCqhse+Ov023B7zFj/O+jCLN0Ejixzdm3i+ZCUOjTMCHFViIDqwUjlb5nD6M6QEuk2
 wyrjVz4XK3Q4E/tOibe12r1Lh6RqGeT6E0eouGaL55PFdGXOBjc2a2DMjSsnPx2EnSGNoJ/JL
 lOYz7SFaTqofO7SFZRacv+ii2OXj+ROtA2wAz1HJGdGR3rZoPANZznBjiOYZb9d2LyE+AaBOg
 x7ySOjsZKynZqbOsc11r2Mt1DueDwBtlBjgW7FHqKgo3E5DgewNXAjdGwnIWfCOVHnGICsczi
 QnXwtFu4e2jynwTiXpH4kE1k/t1h06mBTVcouL46sSqEMnEc9grZMM7VlcZnyaN4EYezWlBD7
 R3KYXzzgjB69B37pTrfn1oKOBic2Y9ix8oRbbu4SiR9f0DgEODtnIMv1WkJ2IQiFGLnzDFw8B
 TwFX1ltcyOO+GRzZtW5gNgpGNkJtpjNahSmOqYOSKH+EAjteBv9kPjA1bWhf3d9T9+pAl80LW
 cl3svGKUfDurWMj1LIx7Br19/vxFraryT6LPCvakzn3kFH4lU0jssMddzLR36fdDCofLMh9/2
 RL2vpFggWf1058en3kJqvK8xfwG0SvYNRDzW3W3k+z99W2ajGVDNiFctpqJdjmio3pgbenkPz
 dkdfP8xj64JGFdy4JPtrCaZC0+Jn3JBOPrFHlMhHgj0AENbTfchFqV3bOwuORPtfNOalMDfft
 ZVjqkiCyQcxUoiT6K0ZdFY+LAaHA8S5ZZ4hMqWLfA4Yp1KKRJM4yt1XXKXYH+ZS1ozIO02SdK
 z7I56q2goaa5BzYyphVgOk3g==

Hi

On 2024-07-30, Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me k=
now.
>
> ------------------
>
> From: Zheng Yejian <zhengyejian1@huawei.com>
>
> [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
>
> Infinite log printing occurs during fuzz test:
>
>   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
>   ...
>   dvb-usb: schedule remote query interval to 100 msecs.
>   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized =
...
>   dvb-usb: bulk message failed: -22 (1/0)
>   dvb-usb: bulk message failed: -22 (1/0)
>   dvb-usb: bulk message failed: -22 (1/0)
>   ...
>   dvb-usb: bulk message failed: -22 (1/0)
>
> Looking into the codes, there is a loop in dvb_usb_read_remote_control()=
,
> that is in rc_core_dvb_usb_remote_init() create a work that will call
> dvb_usb_read_remote_control(), and this work will reschedule itself at
> 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(=
),
> see following code snippet:
[...]

This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
card, reverting just this patch from v6.10-rc3 fixes the situation
again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
keeps working).

broken, v6.10.3-rc3:

$ dmesg | grep -i -e dvb -e dw21 -e usb\ 4
[    0.999122] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.023123] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.130247] usb 1-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd482, bcdDevice=3D 0.01
[    1.130257] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seri=
alNumber=3D0
[    1.152323] usb 4-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd481, bcdDevice=3D 0.01
[    1.152329] usb 4-1: New USB device strings: Mfr=3D0, Product=3D0, Seri=
alNumber=3D0
[    6.701033] dvb-usb: found a 'TeVii S480.2 USB' in cold state, will try=
 to load a firmware
[    6.701178] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    6.701179] dw2102: start downloading DW210X firmware
[    6.703715] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in c=
old state, will try to load a firmware
[    6.703974] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.=
20.fw'
[    6.756432] usb 1-1: USB disconnect, device number 2
[    6.862119] dvb-usb: found a 'TeVii S480.2 USB' in warm state.
[    6.862194] dvb-usb: TeVii S480.2 USB error while loading driver (-22)
[    6.862209] dvb-usb: found a 'TeVii S480.1 USB' in cold state, will try=
 to load a firmware
[    6.862244] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    6.862245] dw2102: start downloading DW210X firmware
[    6.914811] usb 4-1: USB disconnect, device number 2
[    7.014131] dvb-usb: found a 'TeVii S480.1 USB' in warm state.
[    7.014487] dvb-usb: TeVii S480.1 USB error while loading driver (-22)
[    7.014538] usbcore: registered new interface driver dw2102
[    7.278244] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in w=
arm state.
[    7.278403] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    7.278915] dvbdev: DVB: registering new adapter (Microsoft Xbox One Di=
gital TV Tuner)
[    7.279137] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    7.460377] usb 6-5: DVB: registering adapter 0 frontend 0 (Panasonic M=
N88472)...
[    7.460389] dvbdev: dvb_create_media_entity: media entity 'Panasonic MN=
88472' registered.
[    7.460822] dvb-usb: Microsoft Xbox One Digital TV Tuner successfully i=
nitialized and connected.
[    7.460998] usbcore: registered new interface driver dvb_usb_dib0700
[    8.496278] usb 1-1: new high-speed USB device number 3 using ehci-pci
[    8.625238] usb 1-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    8.626608] usb 1-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    8.626613] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    8.626616] usb 1-1: Product: DVBS2BOX
[    8.626618] usb 1-1: Manufacturer: TBS-Tech
[    8.627027] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    8.627079] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    8.627081] dw2102: start downloading DW210X firmware
[    8.655186] usb 4-1: new high-speed USB device number 3 using ehci-pci
[    8.781321] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    8.781775] dvb-usb: TeVii S660 USB error while loading driver (-22)
[    8.784340] usb 4-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    8.785705] usb 4-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    8.785714] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    8.785718] usb 4-1: Product: DVBS2BOX
[    8.785721] usb 4-1: Manufacturer: TBS-Tech
[    8.786247] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    8.786299] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    8.786301] dw2102: start downloading DW210X firmware
[    8.941215] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    8.941532] dvb-usb: TeVii S660 USB error while loading driver (-22)
[   16.107993] mn88472 12-0018: downloading firmware from file 'dvb-demod-=
mn88472-02.fw'

working, v6.10.3-rc3 with this patch reverted:

$ dmesg | grep -i -e dvb -e dw21 -e usb\ 4
[    1.136231] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.161156] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.267579] usb 1-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd482, bcdDevice=3D 0.01
[    1.267588] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seri=
alNumber=3D0
[    1.291329] usb 4-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd481, bcdDevice=3D 0.01
[    1.291338] usb 4-1: New USB device strings: Mfr=3D0, Product=3D0, Seri=
alNumber=3D0
[    3.135217] dvb-usb: found a 'TeVii S480.2 USB' in cold state, will try=
 to load a firmware
[    3.135430] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.135432] dw2102: start downloading DW210X firmware
[    3.166588] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in c=
old state, will try to load a firmware
[    3.167079] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.=
20.fw'
[    3.188357] usb 1-1: USB disconnect, device number 2
[    3.287145] dvb-usb: found a 'TeVii S480.2 USB' in warm state.
[    3.287222] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.287254] dvbdev: DVB: registering new adapter (TeVii S480.2 USB)
[    3.287258] usb 1-1: media controller created
[    3.287355] dvb-usb: MAC address: 01:01:01:01:01:01
[    3.287499] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.290759] dvb-usb: no frontend was attached by 'TeVii S480.2 USB'
[    3.315441] rc rc0: lirc_dev: driver dw2102 registered at minor =3D 0, =
scancode receiver, no transmitter
[    3.315640] dvb-usb: schedule remote query interval to 150 msecs.
[    3.315646] dvb-usb: TeVii S480.2 USB successfully initialized and conn=
ected.
[    3.315730] dvb-usb: found a 'TeVii S480.1 USB' in cold state, will try=
 to load a firmware
[    3.315786] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    3.315790] dw2102: start downloading DW210X firmware
[    3.340783] dvb-usb: TeVii S480.2 USB successfully deinitialized and di=
sconnected.
[    3.369557] usb 4-1: USB disconnect, device number 2
[    3.470172] dvb-usb: found a 'TeVii S480.1 USB' in warm state.
[    3.470320] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.470371] dvbdev: DVB: registering new adapter (TeVii S480.1 USB)
[    3.470377] usb 4-1: media controller created
[    3.470516] dvb-usb: MAC address: a1:a1:a1:a1:a1:a1
[    3.470724] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.472540] dvb-usb: no frontend was attached by 'TeVii S480.1 USB'
[    3.474008] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 0, =
scancode receiver, no transmitter
[    3.474268] dvb-usb: schedule remote query interval to 150 msecs.
[    3.474274] dvb-usb: TeVii S480.1 USB successfully initialized and conn=
ected.
[    3.474331] usbcore: registered new interface driver dw2102
[    3.511730] dvb-usb: TeVii S480.1 USB successfully deinitialized and di=
sconnected.
[    3.743260] dvb-usb: found a 'Microsoft Xbox One Digital TV Tuner' in w=
arm state.
[    3.743496] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    3.744132] dvbdev: DVB: registering new adapter (Microsoft Xbox One Di=
gital TV Tuner)
[    3.744363] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    3.924797] usb 6-5: DVB: registering adapter 0 frontend 0 (Panasonic M=
N88472)...
[    3.924805] dvbdev: dvb_create_media_entity: media entity 'Panasonic MN=
88472' registered.
[    3.925073] dvb-usb: Microsoft Xbox One Digital TV Tuner successfully i=
nitialized and connected.
[    3.925220] usbcore: registered new interface driver dvb_usb_dib0700
[    4.928291] usb 1-1: new high-speed USB device number 3 using ehci-pci
[    5.057227] usb 1-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    5.060100] usb 1-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    5.060106] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    5.060109] usb 1-1: Product: DVBS2BOX
[    5.060112] usb 1-1: Manufacturer: TBS-Tech
[    5.060517] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    5.060560] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    5.060562] dw2102: start downloading DW210X firmware
[    5.105152] usb 4-1: new high-speed USB device number 3 using ehci-pci
[    5.214345] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    5.214663] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    5.215024] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.215031] usb 1-1: media controller created
[    5.234371] usb 4-1: config 1 interface 0 altsetting 0 bulk endpoint 0x=
81 has invalid maxpacket 2
[    5.235622] usb 4-1: New USB device found, idVendor=3D9022, idProduct=
=3Dd660, bcdDevice=3D 0.00
[    5.235632] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D0
[    5.235635] usb 4-1: Product: DVBS2BOX
[    5.235638] usb 4-1: Manufacturer: TBS-Tech
[    5.236096] dvb-usb: found a 'TeVii S660 USB' in cold state, will try t=
o load a firmware
[    5.236154] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
[    5.236157] dw2102: start downloading DW210X firmware
[    5.390220] dvb-usb: found a 'TeVii S660 USB' in warm state.
[    5.390437] dvb-usb: will pass the complete MPEG2 transport stream to t=
he software demuxer.
[    5.390831] dvbdev: DVB: registering new adapter (TeVii S660 USB)
[    5.390837] usb 4-1: media controller created
[    5.457940] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    5.458189] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.559308] dw2102: Attached ds3000+ts2020!
[    5.559318] usb 1-1: DVB: registering adapter 1 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.559327] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.560578] rc rc1: lirc_dev: driver dw2102 registered at minor =3D 1, =
scancode receiver, no transmitter
[    5.560745] dvb-usb: schedule remote query interval to 150 msecs.
[    5.560748] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[    5.643009] dvb-usb: MAC address: 00:18:bd:XX:XX:XX
[    5.643244] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' r=
egistered.
[    5.756627] dw2102: Attached ds3000+ts2020!
[    5.756632] usb 4-1: DVB: registering adapter 2 frontend 0 (Montage Tec=
hnology DS3000)...
[    5.756641] dvbdev: dvb_create_media_entity: media entity 'Montage Tech=
nology DS3000' registered.
[    5.758025] rc rc2: lirc_dev: driver dw2102 registered at minor =3D 2, =
scancode receiver, no transmitter
[    5.758194] dvb-usb: schedule remote query interval to 150 msecs.
[    5.758197] dvb-usb: TeVii S660 USB successfully initialized and connec=
ted.
[   12.578584] mn88472 12-0018: downloading firmware from file 'dvb-demod-=
mn88472-02.fw'
[   12.732107] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.338071] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.339290] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...
[   13.970274] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-=
fe-ds3000.fw)...

The https://www.linuxtv.org/wiki/index.php/TeVii_S480 is a PCIe card
which combines a USB host controller with two onboard TeVii s660 USB
DVB-S2 cards.

07:00.0 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci
07:00.1 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci
07:00.2 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci
07:00.3 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci
07:00.4 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci
07:00.5 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci
07:00.6 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci
07:00.7 USB controller [0c03]: MosChip Semiconductor Technology Ltd. MCS99=
90 PCIe to 4-Port USB 2.0 Host Controller [9710:9990]
        Subsystem: Asix Electronics Corporation (Wrong ID) Device [a000:40=
00]
        Kernel driver in use: ehci-pci
        Kernel modules: ehci_pci

:  Bus 001.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dehci-pci/1p, 480M
    |__ Port 001: Dev 003, If 0, Class=3DVendor Specific Class, Driver=3Dd=
w2102, 480M
/:  Bus 002.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dehci-pci/1p, 480=
M
/:  Bus 003.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dehci-pci/1p, 480=
M
/:  Bus 004.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dehci-pci/1p, 480=
M
    |__ Port 001: Dev 003, If 0, Class=3DVendor Specific Class, Driver=3Dd=
w2102, 480M

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660

Regards
	Stefan Lippers-Hollmann
