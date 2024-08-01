Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10713D617;
	Thu,  1 Aug 2024 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722532915; cv=none; b=XLuaD9xHHifmGkE09I+hr+KeuniukGuLfD53/rZffl3/SUPYXOv2iPAtoBhCXP0t/z2K0hVwR36L+Y8VaM3Q5nUJh1j4lD+xnJHu5VL4Kt/rwOSayAFCqGqq3MqraCmAvKEX/yTdoIfIvi3elIfAcVTtWpmYsggJfAaIfSzh+HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722532915; c=relaxed/simple;
	bh=Tx9SInrmVGNm7JYtAtJ8slOgLb0DaX/M+MP67cGrCzY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXcmNwwV8Mu32+hIBvVho9Dmkl2w1QkNPuch5GlbkgnbxWroDeCCRnbS08g7x7nCi/JSJUTJ5b7xnzC4QE/KPuV2904ZFPudEcjrh4GNZcJ04xgQx7Nrehhh/Fa1yojhJicryZkW8FPGw3RYDIqwK3F467TSEAo68f71w3tDxPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=okmj9W7K; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="okmj9W7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1722532891; x=1723137691; i=s.l-h@gmx.de;
	bh=BfXj+vxWd1NieRCVoijTgxquldoEAmV/8d0Nv/sf2IM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=okmj9W7KAM/WL28EP/MNKWmPQQRZ1b/IaCvIog2Xs5gC8skG5BfGQ7HrLVsmvQp3
	 Vhp1S0iM3SiNym21iF02NB+/zyNbIrKY3jp7S/72Hpt/QsTLTau1mJK60rk3dLGfp
	 2o3EEJ6cf5k4aFg+u+NO1PClmRfbHp2cC7GrP54vc34FMOuWm2Im59VmNwH01QreT
	 v5GI4q5nol4wMBs4B1zrn1rggAkWvvHl54UpF72oMwtiSpzMNskP7sdd+4LHhhp3R
	 s/zcEdLogqUwuUwpHaa6KSW6zruOiRMtut5ZqDnXD+XPuFM8Ba4HGJu+zNEoxscs7
	 pyglmjREfJdIcwh/Iw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.83.155]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZkpb-1sn1mG3LTr-00NMUE; Thu, 01
 Aug 2024 19:21:31 +0200
Date: Thu, 1 Aug 2024 19:21:25 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Zheng Yejian
 <zhengyejian1@huawei.com>, Sean Young <sean@mess.org>, Hans Verkuil
 <hverkuil-cisco@xs4all.nl>, Sasha Levin <sashal@kernel.org>, "Linux 
 regression tracking (Thorsten Leemhuis)"  <regressions@leemhuis.info>
Subject: Re: [PATCH 6.10 288/809] media: dvb-usb: Fix unexpected infinite
 loop in dvb_usb_read_remote_control()
Message-ID: <20240801192125.300b2bd9@mir>
In-Reply-To: <20240801172755.63c53206@mir>
References: <20240730151724.637682316@linuxfoundation.org>
	<20240730151735.968317438@linuxfoundation.org>
	<20240801165146.38991f60@mir>
	<20240801172755.63c53206@mir>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4VwlsyBQ8888CV70W6iOO1HkVpv+ZdBnlX011mBOmZ3r6IXcj1/
 eEy5P/wt6T9ubsrRUoKFFFSVyIyfok7K4M8yswkMPOzkDGqdiuA2iyhLTnunWuT90m4da5T
 vXMf3bJxERh2/tg8mM3oZFHivPGht3i+Chdz/Zx61APDbNye5U1MuX0d2Egk51X26cReVmr
 d0Rm2HJxWDkRAP4o2hPlQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qHLVGV3H6OU=;gUZcyrlPMbUQVgL17nkc3J0LCex
 kZFkM2y1lhUDcmtQFWGH11x/JsiQblbPIx+vYO3Xa3JtdH23bUuUilcZiPO6G3wbureBCYam1
 oOyT3PysHasH7Tdqzf5Vxk9uYaLpo6KfRbclu14itctLN3Jmwx9fgTNLnbLJYT/1sKiCW/oX5
 M0D81rmcRiMEv2eT1uicftN0X4OKKPQtflVa6cIXvMtBwQcxMxOLRJAcXM9sNHU1T3ScLmDub
 scKPGDnS7OPPIVbGUE4ooXHHeFbdhfmGkxb1oq+pZDq+jnSFG9IKEt8CYSyocPjhkUZU2tzf9
 ooTkf1dWFThebcX1IIs9MJy9Wsgvi+RpbW9rg+u+huFErYLe0y6ntLIBUlq5OMWA/CpP1zsfT
 X2Rlz/rJx0Q+rNfMLloVp1J8E2Jr6FJ8lUNpHqSBs0iqLp+cilXx4VBxqM/GIxQJfemVwLenv
 xQRJai7LmibgbGkUsjNxBGqA9r5Epej6kXXPNA4hasmnxkP+8aQ/BpbfK0MVweJf1Shox+qTA
 g/oWXTAGsFWpAYqPVcO1uiAFx5f0FUrLw5piuoR5DZ7gyWx8/SHC0MXp7AY8tB2NjfTDYFkMO
 83MedtQM2+0zYdbxKRDxBQD4ioTVb7Xf7BluGzxqilMFpQGR3vRhzjCZClp8vfzlmHImQyuvw
 pj1nB11/00hVn0p3bhdn/BJN0P/NM7zaYuKYFaYfdHgulWq5EPohQS35Sa5hwhAp5z4USPNsp
 w7vJuzwkvjw9t8gBn46VyZ0sv2Re9bKzJ5xJjRqJpFDFcSdomCkKtQpr0bPSMgmrCYBtKbhX6
 rO1nwqLe4FmM/hp/GDmnj4jA==

Hi

On 2024-08-01, Stefan Lippers-Hollmann wrote:
> On 2024-08-01, Stefan Lippers-Hollmann wrote:
> > On 2024-07-30, Greg Kroah-Hartman wrote:
> > > 6.10-stable review patch.  If anyone has any objections, please let =
me know.
> > >
> > > ------------------
> > >
> > > From: Zheng Yejian <zhengyejian1@huawei.com>
> > >
> > > [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
> > >
> > > Infinite log printing occurs during fuzz test:
> > >
> > >   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
> > >   ...
> > >   dvb-usb: schedule remote query interval to 100 msecs.
> > >   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initiali=
zed ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >   ...
> > >   dvb-usb: bulk message failed: -22 (1/0)
> > >
> > > Looking into the codes, there is a loop in dvb_usb_read_remote_contr=
ol(),
> > > that is in rc_core_dvb_usb_remote_init() create a work that will cal=
l
> > > dvb_usb_read_remote_control(), and this work will reschedule itself =
at
> > > 'rc_interval' intervals to recursively call dvb_usb_read_remote_cont=
rol(),
> > > see following code snippet:
> > [...]
> >
> > This patch, as part of v6.10.3-rc3 breaks my TeVii s480 dual DVB-S2
> > card, reverting just this patch from v6.10-rc3 fixes the situation
> > again (a co-installed Microsoft Xbox One Digital TV DVB-T2 Tuner
> > keeps working).
> [...]
>
> Btw. I can also reproduce this (both breakage and 'fix' by reverting
> this patch) on a another x86_64 system that only has a single TeVii
> s480 dual DVB-S2 card (and no further v4l devices) installed. So I'm
> seeing this on both sandy-bridge and raptor-lake x86_64 systems.

This issue is also present in current linux HEAD (as of this moment,
v6.11-rc1-63-g21b136cc63d2).

A clean revert of this commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c
"media: dvb-usb: Fix unexpected infinite loop in
dvb_usb_read_remote_control()" avoids the problem for v6.11~ as well.

Regards
	Stefan Lippers-Hollmann
