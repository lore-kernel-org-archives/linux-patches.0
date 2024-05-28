Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [202.36.163.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49862179650
	for <patches@lists.linux.dev>; Tue, 28 May 2024 20:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.36.163.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929262; cv=none; b=azBP7+LqEh53kCucHdlKz5mFpud1F21pWvIaAeZlYjpUS9vrP+T2L4WtjmpC+hwd6CGW2xWBzzg7aUcepM8zJm/K0uwb7Wc4dCt+lt1TfVuu1IEOSg4a9cl5yYWpZXSLyr06Ilyxa6IfhRCz9H6bZ3JywEiqOEB61UMku8BxiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929262; c=relaxed/simple;
	bh=CJ0wRt39wry877MFi5yLNi/ccKGSRy4FwAIVIEaqIF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GNhiT0B/L9Nwnznt/YP4NhYaKzsaIRYP8MbVmOu+EK2i2WCvp/j709jPNeqJhHwPDoxojFI8l9Y8j+lZiY5um1ZUNKD+KSGKRrRwecWDYZLkz4pfwqmI5i5I/3L+V9x/19EtzLlUUWPcXib1UJbqr5EjmAPIAu/x8USKPb45Se0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alliedtelesis.co.nz; spf=pass smtp.mailfrom=alliedtelesis.co.nz; dkim=pass (2048-bit key) header.d=alliedtelesis.co.nz header.i=@alliedtelesis.co.nz header.b=IXtvp3bx; arc=none smtp.client-ip=202.36.163.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=alliedtelesis.co.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alliedtelesis.co.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alliedtelesis.co.nz header.i=@alliedtelesis.co.nz header.b="IXtvp3bx"
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B87412C02CC;
	Wed, 29 May 2024 08:38:12 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
	s=mail181024; t=1716928692;
	bh=CJ0wRt39wry877MFi5yLNi/ccKGSRy4FwAIVIEaqIF4=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=IXtvp3bxuBBtDxhgwIhDwpa76JmTbmCqM5KyQLNPZJvRniJmAoZUFRDVqKg1t+NQx
	 +mbtDasFYzQLVk09VJONheuxtxNSHYbed5IAHNbW+MjEYvpsPbvhQm5muzPrGRcM6g
	 mlQiPa+0+TPLM1xRhgJz39QL5+qEBeHFu9Tq3zjEGq8hHDhDEM3tOzHs4rl06g32ap
	 SusXAS9vgP/eZoOdQqMs+P3tJH48sSKR2TfvzHoC/7Ho+b9bZidJdfgy7kXlD6MRYH
	 FYFG/8PM2TuSsDPGBrRvaQf7tjTMkOeJzZ1Z42qwPF24am/osa1AjvJGRYYoFjwRiZ
	 j9YuXFla7MB9Q==
Received: from svr-chch-ex2.atlnz.lc (Not Verified[2001:df5:b000:bc8::76]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
	id <B665640b40000>; Wed, 29 May 2024 08:38:12 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex2.atlnz.lc (2001:df5:b000:bc8:f753:6de:11c0:a008) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1544.11; Wed, 29 May 2024 08:38:12 +1200
Received: from svr-chch-ex2.atlnz.lc (2001:df5:b000:bc8::76) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.48; Wed, 29 May 2024 08:38:12 +1200
Received: from svr-chch-ex2.atlnz.lc ([fe80::a9eb:c9b7:8b52:9567]) by
 svr-chch-ex2.atlnz.lc ([fe80::a9eb:c9b7:8b52:9567%15]) with mapi id
 15.02.1544.011; Wed, 29 May 2024 08:38:12 +1200
From: Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To: Jon Hunter <jonathanh@nvidia.com>, Chuck Lever III
	<chuck.lever@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Neil Brown
	<neilb@suse.de>, linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Linux Kernel Mailing
 List" <linux-kernel@vger.kernel.org>, Linus Torvalds
	<torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "pavel@denx.de" <pavel@denx.de>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>, "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>, "srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
	"allen.lkml@gmail.com" <allen.lkml@gmail.com>, "broonie@kernel.org"
	<broonie@kernel.org>, "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Topic: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Index: AQHasN4TfgxwqfFZfEKH0FZYU7evErGr1xiAgAARtgCAAGozAA==
Date: Tue, 28 May 2024 20:38:12 +0000
Message-ID: <d5adc4a4-81b6-46f6-bcf6-7debf48d2bbf@alliedtelesis.co.nz>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
 <2024052541-likeness-banjo-e147@gregkh>
 <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
 <968E3378-1B38-4519-BB85-5B1C45E3A16A@oracle.com>
 <8b6fe99f-7fa9-493c-afe7-8e75b7f59852@nvidia.com>
In-Reply-To: <8b6fe99f-7fa9-493c-afe7-8e75b7f59852@nvidia.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E74215606E9154889788EFD7A709BB7@atlnz.lc>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.4 cv=F9L0dbhN c=1 sm=1 tr=0 ts=665640b4 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=75chYTbOgJ0A:10 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=yDejyKqjGvIJSoj4HikA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0

DQpPbiAyOS8wNS8yNCAwMjoxOCwgSm9uIEh1bnRlciB3cm90ZToNCj4NCj4gT24gMjgvMDUvMjAy
NCAxNDoxNCwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4NCj4+DQo+Pj4gT24gTWF5IDI4LCAy
MDI0LCBhdCA1OjA04oCvQU0sIEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPiB3cm90
ZToNCj4+Pg0KPj4+DQo+Pj4gT24gMjUvMDUvMjAyNCAxNToyMCwgR3JlZyBLcm9haC1IYXJ0bWFu
IHdyb3RlOg0KPj4+PiBPbiBTYXQsIE1heSAyNSwgMjAyNCBhdCAxMjoxMzoyOEFNICswMTAwLCBK
b24gSHVudGVyIHdyb3RlOg0KPj4+Pj4gSGkgR3JlZywNCj4+Pj4+DQo+Pj4+PiBPbiAyMy8wNS8y
MDI0IDE0OjEyLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+Pj4+Pj4gVGhpcyBpcyB0aGUg
c3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1LjE1LjE2MCANCj4+Pj4+
PiByZWxlYXNlLg0KPj4+Pj4+IFRoZXJlIGFyZSAyMyBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBh
bGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSANCj4+Pj4+PiByZXNwb25zZQ0KPj4+Pj4+IHRvIHRoaXMg
b25lLsKgIElmIGFueW9uZSBoYXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQs
IA0KPj4+Pj4+IHBsZWFzZQ0KPj4+Pj4+IGxldCBtZSBrbm93Lg0KPj4+Pj4+DQo+Pj4+Pj4gUmVz
cG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFNhdCwgMjUgTWF5IDIwMjQgMTM6MDM6MTUgKzAwMDAu
DQo+Pj4+Pj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBs
YXRlLg0KPj4+Pj4+DQo+Pj4+Pj4gVGhlIHdob2xlIHBhdGNoIHNlcmllcyBjYW4gYmUgZm91bmQg
aW4gb25lIHBhdGNoIGF0Og0KPj4+Pj4+IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvcHViL2xpbnV4
L2tlcm5lbC92NS54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNS4xNS4xNjAtcmMxLmd6IA0KPj4+Pj4+
DQo+Pj4+Pj4gb3IgaW4gdGhlIGdpdCB0cmVlIGFuZCBicmFuY2ggYXQ6DQo+Pj4+Pj4gZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC1zdGFi
bGUtcmMuZ2l0IA0KPj4+Pj4+IGxpbnV4LTUuMTUueQ0KPj4+Pj4+IGFuZCB0aGUgZGlmZnN0YXQg
Y2FuIGJlIGZvdW5kIGJlbG93Lg0KPj4+Pj4+DQo+Pj4+Pj4gdGhhbmtzLA0KPj4+Pj4+DQo+Pj4+
Pj4gZ3JlZyBrLWgNCj4+Pj4+Pg0KPj4+Pj4+IC0tLS0tLS0tLS0tLS0NCj4+Pj4+PiBQc2V1ZG8t
U2hvcnRsb2cgb2YgY29tbWl0czoNCj4+Pj4+DQo+Pj4+PiAuLi4NCj4+Pj4+DQo+Pj4+Pj4gTmVp
bEJyb3duIDxuZWlsYkBzdXNlLmRlPg0KPj4+Pj4+IMKgwqDCoMKgwqAgbmZzZDogZG9uJ3QgYWxs
b3cgbmZzZCB0aHJlYWRzIHRvIGJlIHNpZ25hbGxlZC4NCj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gSSBh
bSBzZWVpbmcgYSBzdXNwZW5kIHJlZ3Jlc3Npb24gb24gYSBjb3VwbGUgYm9hcmRzIGFuZCBiaXNl
Y3QgaXMgDQo+Pj4+PiBwb2ludGluZw0KPj4+Pj4gdG8gdGhlIGFib3ZlIGNvbW1pdC4gUmV2ZXJ0
aW5nIHRoaXMgY29tbWl0IGRvZXMgZml4IHRoZSBpc3N1ZS4NCj4+Pj4gVWdoLCB0aGF0IGZpeGVz
IHRoZSByZXBvcnQgZnJvbSBvdGhlcnMuwqAgQ2FuIHlvdSBjYzogZXZlcnlvbmUgb24gdGhhdA0K
Pj4+PiBhbmQgZmlndXJlIG91dCB3aGF0IGlzIGdvaW5nIG9uLCBhcyB0aGlzIGtlZXBzIGdvaW5n
IGJhY2sgYW5kIGZvcnRoLi4uDQo+Pj4NCj4+Pg0KPj4+IEFkZGluZyBDaHVjaywgTmVpbCBhbmQg
Q2hyaXMgZnJvbSB0aGUgYnVnIHJlcG9ydCBoZXJlIFswXS4NCj4+Pg0KPj4+IFdpdGggdGhlIGFi
b3ZlIGFwcGxpZWQgdG8gdjUuMTUueSwgSSBhbSBzZWVpbmcgc3VzcGVuZCBvbiAyIG9mIG91ciAN
Cj4+PiBib2FyZHMgZmFpbC4gVGhlc2UgYm9hcmRzIGFyZSB1c2luZyBORlMgYW5kIG9uIGVudHJ5
IHRvIHN1c3BlbmQgSSBhbSANCj4+PiBub3cgc2VlaW5nIC4uLg0KPj4+DQo+Pj4gRnJlZXppbmcg
b2YgdGFza3MgZmFpbGVkIGFmdGVyIDIwLjAwMiBzZWNvbmRzICgxIHRhc2tzIHJlZnVzaW5nIHRv
DQo+Pj4gZnJlZXplLCB3cV9idXN5PTApOg0KPj4+DQo+Pj4gVGhlIGJvYXJkcyBhcHBlYXIgdG8g
aGFuZyBhdCB0aGF0IHBvaW50LiBTbyBtYXkgYmUgc29tZXRoaW5nIGVsc2UgDQo+Pj4gbWlzc2lu
Zz8NCj4+DQo+PiBOb3RlIHRoYXQgd2UgZG9uJ3QgaGF2ZSBhY2Nlc3MgdG8gaGFyZHdhcmUgbGlr
ZSB0aGlzLCBzbw0KPj4gd2UgaGF2ZW4ndCB0ZXN0ZWQgdGhhdCBwYXRjaCAoZXZlbiB0aGUgdXBz
dHJlYW0gdmVyc2lvbikNCj4+IHdpdGggc3VzcGVuZCBvbiB0aGF0IGhhcmR3YXJlLg0KPg0KPg0K
PiBObyBwcm9ibGVtLCBJIHdvdWxkIG5vdCBleHBlY3QgeW91IHRvIGhhdmUgdGhpcyBwYXJ0aWN1
bGFyIGhhcmR3YXJlIDotKQ0KPg0KSXQncyBwcm9iYWJseSBub3QgbXVjaCBoZWxwIGJ1dCBmb3Ig
dGhlIG9vcHMgSSBvcmlnaW5hbGx5IHJlcG9ydGVkIHdlJ3ZlIA0KYmVlbiBjYXJyeWluZyAibmZz
ZDogZG9uJ3QgYWxsb3cgbmZzZCB0aHJlYWRzIHRvIGJlIHNpZ25hbGxlZCIgbG9jYWxseSANCmFu
ZCB0aGF0IHJlc29sdmVkIGl0LiBOb3cgdGhhdCB3ZSd2ZSB1cGRhdGVkIHRvIDUuMTUuMTYwIGFu
ZCBkcm9wcGVkIHRoZSANCmxvY2FsIHBhdGNoIGl0J3Mgc3RpbGwgcmVzb2x2ZWQgZm9yIHVzLiBP
dXIgc3lzdGVtcyBkb24ndCBtYWtlIHVzZSBvZiANCnN1c3BlbmQgc28gdGhleSB3b24ndCBoaXQg
YW55IGlzc3VlIHJlbGF0ZWQgdG8gdGhhdC4NCj4+IFNvLCBpdCBjb3VsZCBiZSBzb21ldGhpbmcg
bWlzc2luZywgb3IgaXQgY291bGQgYmUgdGhhdA0KPj4gcGF0Y2ggaGFzIGEgcHJvYmxlbS4NCj4+
DQo+PiBJdCB3b3VsZCBoZWxwIHVzIHRvIGtub3cgaWYgeW91IG9ic2VydmUgdGhlIHNhbWUgaXNz
dWUNCj4+IHdpdGggYW4gdXBzdHJlYW0ga2VybmVsLCBpZiB0aGF0IGlzIHBvc3NpYmxlLg0KPg0K
Pg0KPiBJIGRvbid0IG9ic2VydmUgdGhpcyB3aXRoIGVpdGhlciBtYWlubGluZSwgLW5leHQgb3Ig
YW55IG90aGVyIHN0YWJsZSANCj4gYnJhbmNoLiBTbyB0aGF0IHdvdWxkIHN1Z2dlc3QgdGhhdCBz
b21ldGhpbmcgZWxzZSBpcyBtaXNzaW5nIGZyb20gDQo+IGxpbnV4LTUuMTUueS4NCj4NCj4gSm9u
DQo+
