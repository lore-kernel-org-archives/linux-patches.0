Received: from mgw400.mail.berlinercloud.net (mgw400.mail.berlinercloud.net [194.29.227.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B6716EB56;
	Wed, 20 Nov 2024 08:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.29.227.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732091168; cv=none; b=C1zqQYWJ8VXASpWxMfTZzVLgmXwbiPum+ttD+Q79cWA5LU6sFDzItgp57gDVGpC1WPYFdMrOC65BJyLpXqlIl+ITjdFc1P2SnTBkDHlpGfcyPSkMupkvq0PeZl9/npUCMSR0l6soNOWe02fjhtecleGnSjWxZ5DC3CVpn3I1ghQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732091168; c=relaxed/simple;
	bh=OdqGtApa574oa+JDCsp8wbdRiz1gWpYxQxPKwpUAhYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OBcfWu4V9yu2rAl6++eDuyEUtoyUD/HKvKAHh1Rs0QOdgjWU2BqUaVpbOA1z29Cw3JLex8jZVZk6TfuZqewKp1VFyn7dvgAKadTeMceKh5TMXIegKK094731iAF8/729Sz0qjCTv5PX5WgQOojthoSv7Dz0LTkMsGmdkATjaDW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kumkeo.de; spf=pass smtp.mailfrom=kumkeo.de; dkim=pass (2048-bit key) header.d=kumkeo.de header.i=@kumkeo.de header.b=lrrBICDP; arc=none smtp.client-ip=194.29.227.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kumkeo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kumkeo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kumkeo.de header.i=@kumkeo.de header.b="lrrBICDP"
X-TM-AS-ERS: 172.18.2.115-127.5.254.253
X-TM-AS-SMTP: 1.0 bWd3MzUwLm1haWwuYmVybGluZXJjbG91ZC5uZXQ= dWxyaWNoLnRlaWNoZ
	XJ0QGt1bWtlby5kZQ==
X-DDEI-TLS-USAGE: Used
Received: from mgw350.mail.berlinercloud.net (unknown [172.18.2.115])
	by mgw400.mail.berlinercloud.net (Postfix) with ESMTPS;
	Wed, 20 Nov 2024 09:25:58 +0100 (CET)
X-DDEI-TLS-USAGE: Used
Received: from mail.kumkeo.de (unknown [172.18.2.1])
	by mgw350.mail.berlinercloud.net (Postfix) with ESMTPS;
	Wed, 20 Nov 2024 09:25:58 +0100 (CET)
Received: from kumex2.kumkeo.de (172.18.20.16) by kumex2.kumkeo.de
 (172.18.20.16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 20 Nov
 2024 09:25:57 +0100
Received: from kumex2.kumkeo.de ([fe80::6572:2554:d711:1795]) by
 kumex2.kumkeo.de ([fe80::6572:2554:d711:1795%2]) with mapi id 15.01.2507.039;
 Wed, 20 Nov 2024 09:25:57 +0100
From: Ulrich Teichert <ulrich.teichert@kumkeo.de>
To: Dominique Martinet <asmadeus@codewreck.org>, Salvatore Bonaccorso
	<carnil@debian.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "y0un9n132@gmail.com" <y0un9n132@gmail.com>, "Kees
 Cook" <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, "Jiri
 Kosina" <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: AW: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Thread-Topic: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Thread-Index: AQHbOyM/ORYYqoFd/ke2q7rGpiMvkrK/0jK3
Date: Wed, 20 Nov 2024 08:25:57 +0000
Message-ID: <eaf6cfe58733416c928a8ff0d1d1b1ec@kumkeo.de>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
 <Zz0_-iJH1WaR3BUZ@codewreck.org>
 <Zz2JQzi-5pTP_WPx@eldamar.lan>,<Zz2YrA740TRgl_13@codewreck.org>
In-Reply-To: <Zz2YrA740TRgl_13@codewreck.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-as-product-ver: SMEX-14.0.0.3197-9.1.2019-28808.006
x-tm-as-result: No-10--16.656800-8.000000
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tm-snts-smtp: DCE1CEED649190E95C54F8AF029E46E8AC9DB78594E3C853B73BE31A034DC1F72000:9
x-c2processedorg: c2164c60-77f9-4731-9233-294e5719f64e
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-DDEI-PROCESSED-RESULT: Safe
X-TMASE-Version: DDEI-5.1-9.1.1004-28808.006
X-TMASE-Result: 10--14.801200-10.000000
X-TMASE-MatchedRID: WyuTQeNUcY0zEoEUvSEINfHkpkyUphL9pPMmjQJmXyEtferJ/d7Abz9B
	BAgMnMgelxPsRwiY5LwAf/HImzvCGN/K1ikJIsLOMKPrF7dK57ORgLeuORRdEo5V1ACIyZtnI7c
	nzSpYxIOAVtbAzV2zqJI60+HRZpMO9MoRcH4eD7hsWedgrJMQ/kEe5VjFzwNbyIKHzIGoT627Al
	zDQluRGwd4WtFglqZuWHpfQd/qEd8IlyLfFl8CZysIuzCLc2mNDVuL2vYqrd45Nq0T4/ElUqW8W
	Sf5267x4s1HPpjzp9kdablShYBTXhgHZ8655DOP0gVVXNgaM0qcIZLVZAQa0HhSEE8tGW+Gx3Aa
	4oibyxkLbigRnpKlKSBuGJWwgxAr0t0ccteCeDcJ3JnPbkSAeQs7YRilFXpK71o8zC656/Q562r
	IhW5dAVgpWCbva+Mm
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: c85819c8-dfe3-4205-b4b0-97f51b7442e6-0-0-200-0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kumkeo.de;
	s=bcsel2403; t=1732091158; x=1732523158;
	bh=OdqGtApa574oa+JDCsp8wbdRiz1gWpYxQxPKwpUAhYE=; l=1844;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
	b=lrrBICDP2yj3r/++fmFtSWgHHxMilw9yI6kTYfmkp//5wtklMDNDVIBfC7aftkUse
	 GtpxcM5G8AhzfQOZq4NKS7mKkOtoAVMw1ZMoTxcNBUvxU7Bz4JcdaC9dzuIw5ZVVa1
	 CCHs+WWL8se8AVOBPkzr70Dl49r5IvbsDHwimscGIV2z2mxo/1SzxPx+fB/kbFUyh2
	 GwFfxCSgb+kJD3ufihasxStzpexivCDsnx178+VKFWxBurmGv32qDABOB8HF2+xDAT
	 HK8emmWOualGgpfEfm154BVFK6wDAWEGvk2o5oFG2BlwBYTiRg6+t8EzH7L8errVoX
	 KQsrGSa5xLzaw==

SGkgRG9taW5pcXVlICYgYWxsLA0KDQo+U2FsdmF0b3JlIEJvbmFjY29yc28gd3JvdGUgb24gV2Vk
LCBOb3YgMjAsIDIwMjQgYXQgMDg6MDE6MjNBTSArMDEwMDoNCj4+IEludGVyZXN0aWdseSB0aGVy
ZSBpcyBhbm90aGVyIHJlcG9ydCBpbiBEZWJpYW4gd2hpY2ggaWRlbnRpZmllcyB0aGUNCj4+IGJh
Y2twb3J0IG9mIHVwc3RyZWFtIGNvbW1pdCA0NGM3NjgyNWQ2ZWVmZWU5ZWI3Y2UwNmMzOGUxYTY2
MzJhYzdlYjdkDQo+PiB0byBjYXVzZSBpc3N1ZXMgaW4gdGhlIDYuMS55IHNlcmllczoNCj4+DQo+
PiBodHRwczovL2J1Z3MuZGViaWFuLm9yZy8xMDg1NzYyDQo+PiAgaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvcmVncmVzc2lvbnMvMThmMzRkNjM2MzkwNDU0MTgwMjQwZTZhNjFhZjkyMTdAa3Vta2Vv
LmRlL1QvI3UNCg0KPlRoYW5rcyBmb3IgdGhlIGhlYWRzIHVwIQ0KDQo+VGhpcyB3b3VsZCBhcHBl
YXIgdG8gYmUgdGhlIHNhbWUgYnVnIChydW5uaW5nIHFlbXUtYWFyY2g2NCBpbiB1c2VyIG1vZGUN
Cj5vbiBhbiB4ODYgbWFjaGluZSkgPw0KPkkndmUgYWRkZWQgVWxyaWNoIGluIHJlY2lwaWVudHMg
dG8gY29uZmlybSBoZSdzIHVzaW5nIHFlbXUtdXNlci1zdGF0aWMNCj5saWtlIEkgd2FzLg0KDQpw
YnVpbGRlciB1c2VzIHFlbXUgaW5zaWRlIHRoZSBBUk02NCBjaHJvb3QsIHllcy4gSSBkb24ndCBr
bm93IHdoaWNoIHZhcmlldHkgb2YgcWVtdSwgdGhvdWdoLg0KDQo+U2hhbWUgSSBkaWRuJ3Qgbm90
aWNlIGFsbCBoaXMgd29yaywgdGhhdCB3b3VsZCBoYXZlIHNhdmVkIG1lIHNvbWUNCj50aW1lIDop
DQoNCldlbGwsIGF0IGxlYXN0IHdlIG5vdyBoYXZlIGNvbmZpcm1hdGlvbiBmcm9tIHR3byBkaWZm
ZXJlbnQgZ2l0IGJpc2VjdHMgZG9uZSBieQ0KdHdvIGRpZmZlcmVudCBkZXZlbG9wZXJzLCBwb2lu
dGluZyB0byB0aGUgc2FtZSBjb21taXQgOy0pDQoNCkhUSCwNClVsaQ0KDQpNaXQgZnJldW5kbGlj
aGVuIEdyw7zDn2VuIC8gS2luZCByZWdhcmRzDQoNCkRpcGwuLUluZm9ybS4gVWxyaWNoIFRlaWNo
ZXJ0DQpTZW5pb3IgU29mdHdhcmUgRGV2ZWxvcGVyDQoNCmUuYnMga3Vta2VvIEdtYkgNCkhlaWRl
bmthbXBzd2VnIDgyYQ0KMjAwOTcgSGFtYnVyZw0KR2VybWFueQ0KDQpUOiArNDkgNDAgMjg0Njc2
MS0wDQpGOiArNDkgNDAgMjg0Njc2MS05OQ0KDQp1bHJpY2gudGVpY2hlcnRAa3Vta2VvLmRlDQp3
d3cua3Vta2VvLmRlDQoNCkFtdHNnZXJpY2h0IEhhbWJ1cmcgLyBIYW1idXJnIERpc3RyaWN0IENv
dXJ0LCBIUkIgMTg3NzEyDQpHZXNjaMOkZnRzZsO8aHJlciAvIE1hbmFnaW5nIERpcmVjdG9yOiBN
aWNoYWVsIExlaXRuZXI7IEfDvG50ZXIgSGFnc3BpZWwNCg==
