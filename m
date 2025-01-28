Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D621AB6DE
	for <patches@lists.linux.dev>; Tue, 28 Jan 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738077683; cv=none; b=gw8/umnhUrDaGAvz0fx9knCtroLhEfez22NVGPWRjGUsfiw+3hiDlglhbwZgFpg99vVQrcDYvbFxdFS7XTl7SwghBszNhw8cffJWPVi1kCmRnsHd9rZhnW6WbYWnjP6a3Bph50IIqVKiI+BrdsTd35XR0knF4EIXc+Cyvs/Vbgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738077683; c=relaxed/simple;
	bh=x/B9yX/e7R0UrYl5d1VDIwIS7elP7kUmpSEP5ElElyI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=St+VNtLtzyFNsKVEAGBOB4Pr5aebsav2pelH+Uq48JXABKA6v2VFIZHvU4i29x+yjxFGJ9xuAPLtbLcxrgbPelIzr48TVUoaKyK8d2I912XK8rhbtoAP5UwzyC3Pws/DDz1m8WGwocIDJ3kX6bL/Yb/RuKA/9BdNmXtS+SGra50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=MYpoSbYL; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="MYpoSbYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1738077659; x=1738682459; i=efault@gmx.de;
	bh=x/B9yX/e7R0UrYl5d1VDIwIS7elP7kUmpSEP5ElElyI=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=MYpoSbYLi1Y9+ZFa2/1a0yI0UYq9nS4dBGsxzMnozk9a6k3xc7QZpxNRlh4lVxff
	 RsJqhjRjfBUHWjUX8NkzeJy6Thq/aaPjc7OUM0fKRl9PZ5kW3paTOOggKHypWpCzl
	 fGGg8HYkjrcOi/8OdHNuYuYHHkZlb7/jnJyOanUx0brq0JbhjOeXpa4SIMB/uojbG
	 Io6zZNCstZyJtrYWO0HrENr66vAs0M2aG/jtmL2LtvyV6IUWYnZtsFo5pW80uamQx
	 9QKPW/IM3NP2H6GCRLp7t0tXtMx3IVMx/LfvYxYBOBZegockoSTXd8T0NP1rXH9QQ
	 Ob+VBQSxfqbKyWVE0A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from homer.fritz.box ([91.212.106.53]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0oBr-1tHwUQ2yCD-011heh; Tue, 28
 Jan 2025 16:20:59 +0100
Message-ID: <b51f217d565609ae87395c8e23e62b15e489a0a4.camel@gmx.de>
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ron Economos <re@w6rz.net>, Arnd Bergmann <arnd@arndb.de>, Naresh
 Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,  Linus Torvalds
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,
 Guenter Roeck <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org,  lkft-triage@lists.linaro.org, Pavel Machek
 <pavel@denx.de>, Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli
 <f.fainelli@gmail.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 srw@sladewatkins.net, rwarsow@gmx.de, Conor Dooley <conor@kernel.org>,
 hargar@microsoft.com, Mark Brown <broonie@kernel.org>,  Anders Roxell
 <anders.roxell@linaro.org>, Vincent Guittot <vincent.guittot@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>
Date: Tue, 28 Jan 2025 16:20:57 +0100
In-Reply-To: <20250128143949.GD7145@noisy.programming.kicks-ass.net>
References: <20250121174532.991109301@linuxfoundation.org>
	 <CA+G9fYtv3NNpxuipt8Dxa_=0DhieWWc07kDgCDBM+o0gKRi4Dw@mail.gmail.com>
	 <cc947edf-bece-498c-bcb0-5bc403141257@app.fastmail.com>
	 <20250122105949.GK7145@noisy.programming.kicks-ass.net>
	 <faa9e4ef-05f5-4db1-8c36-e901e156caea@w6rz.net>
	 <bfc6d9c18eaa856cddb062ebc07c398a16d91353.camel@gmx.de>
	 <20250128143949.GD7145@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:pGEnJgsdnuVPnK9+wy2jIlrs/IgmyWsstwKE6mY6h1zLm5a3qo/
 Zx9voJFFFp4Amcd6mKF0W3IeHBLKbcj1j58Gm6mvT1KzffonJ7zTB//nPsaMXZU41ovy1cS
 MY56Cksk2FxF4pcmzwjNJqvno6iVXYLSY2hQGdPVG1+oZo14AYOoMbAmM5wIshfy0KCqp/4
 nxXxBKpapmcvexNwyFlVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FEY3YyLg3tg=;3mCrZednNtJwNNT6r0uHLr2aleV
 D38J3OWjKaGKttY/gqHLTbC0mx8xFIFqqghaHpHLSzpoAbgKPoCToRQyRvrIoqb8hDvdwrNrO
 zfrNa3K0CUz+Xd7dwAe+cg3bnbg3zVfEcMn/njNMjZ1DKvWVzCmxpj94a4QGsMDgjWUmTYDtH
 uMr8lZgmvHNwCMEI2/YhkXkn7lTDMCQBRreJVZlwf+cSvOVWlHaksTqFIQkTPr+KIXWEtWuFp
 Ow8MiMHw4B1YxnoycvpQ0sqtf9b26l3LrbnfG449lEqwaMgBfKWN8lQcAdEbFcqp3I5OAp4Df
 K+nMOdV7leBPAUAE23/H/GNYQROafSlhdFDP60FC6CXKrHd6QVPFiAGwMPkVeRA2jjZSKEe/9
 OcjJ6Ti5Zzy83cpvC2Iplydx9Zjn8PuVc9/BtTQjn63CxCKPTxJax2I8aTh2VeLSRMSvtvdzd
 YdjLCI5WYEyhkeqbphqutZueIAf32LGCS2Qk/dzrLYeNeJOU26nMzbC+447YAFAap6V131p4m
 Jp/E8fq67/IL7SKj3NvF6AV/oF3rVwG8H4GZuDPxqhKheXh/igHSNkb2G46UTfmjpZ603/hX7
 jIOvK3kxoQKg6JIhRVczpb2iAdDKZur1L34UAfY5o8yDLjpdU5VUifFe3ACPr6w20ScIwLkiH
 XWr2Of/74drxmKPB+DdpgXCobrhoKop0VBJMfx5lZAtgSBHKH8KEKx9Inhd9TDsg07vj07uZl
 LZvVJd3Je72GNaXKoZh3LwR90YKadVo5e6E591ghl6vdV6Rl1Mi4tdp+T3dBJJ81LZVRoy+kD
 mnRH4AbZrWnoDZ1B+P8h382sTPYKTfTRCdOn+lf2UihAZH0DUid3PnpigTTUv0nKedXZrWXeE
 /TAgQXRv1qWJG8XlrsP3YEmiHoMHX/KVWOnrsKBIzILtmsyO7Hs6hP8xvuGo8tGD2QSRpi/73
 Xnoo/lfPgnycpm3ifjspNGmdeBEVEwgo/h8SSLGeapiZKsEkgkvYo10xV/uwCrFnH5a4Qinjk
 2TXiygmWVZL7sPYzyqGqHYRP9+tB5QJcDn0Mqovy+jQg0FEpPVouRC6ByGCJU4cP9oq5WNviw
 YlDZuTKWUU/4336IICM2L+BM2tYYKlvblLgEDU7KMS0g4HQhazBETA3ydGsjQt6hpilrI6Dxa
 FV51ZHcwK8aAbrB88wp58gOFX+mAM0gAus0d9/f8BKQ==

T24gVHVlLCAyMDI1LTAxLTI4IGF0IDE1OjM5ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKYW4gMjgsIDIwMjUgYXQgMTI6NDY6MDdQTSArMDEwMCwgTWlrZSBHYWxicmFp
dGggd3JvdGU6DQo+IA0KPiA+IFNlZW1zIDYuMTMgaXMgZ3JpcGUgZnJlZSB0aGFua3MgdG8gaXQg
Y29udGFpbmluZyA0NDIzYWY4NGIyOTcuDQo+ID4gDQo+ID4gSSBzdHVtYmxlZCB1cG9uIGEgcmVw
cm9kdWNlciBmb3IgbXkgeDg2XzY0IGRlc2t0b3AgYm94OiBhbGwgSSBuZWVkIGRvDQo+ID4gaXMg
ZmlyZSB1cCBhIGt2bSBndWVzdCBpbiBhbiBlbnRlcnByaXNlIGNvbmZpZ3VyZWQgaG9zdC7CoCBU
aGF0IGluc3BpcmVzDQo+ID4gbGlidmlydCBnb29wIHRvIGVuZ2FnZSBncm91cCBzY2hlZHVsaW5n
LCBzcGxhdCBmb2xsb3dzIGluc3RhbnRseS4NCj4gPiANCj4gPiBCYWNrIDQ0MjNhZjg0YjI5NyBv
dXQgb2YgNi4xMywgaXQgc3RhcnRzIGdyaXBpbmcsIGFkZCBpdCB0byBhIDYuMTIgdHJlZQ0KPiA+
IGNvbnRhaW5pbmcgNmQ3MWE5YzYxNjA0LCBpdCBzdG9wcyBkb2luZyBzby4NCj4gDQo+IE9vaCwg
ZG9lcyBzb21ldGhpbmcgbGlrZSB0aGUgYmVsb3cgKCstIHJldmVyc2UtcmVuYW1lcyBhcyBhcHBs
aWNhYmxlIHRvDQo+IC4xMikgYWxzbyBoZWxwPw0KDQpZdXAsIHNlZW1zIHRvLCA2LjEzIHNhbnMg
NDQyM2FmODRiMjk3IHN0b3BwZWQgZ3JpcGluZy4NCg0KPiAtLS0NCj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC9zY2hlZC9mYWlyLmMgYi9rZXJuZWwvc2NoZWQvZmFpci5jDQo+IGluZGV4IGI2NzIyMmRl
YTQ5MS4uODc2NmY3ZDNkMjk3IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvc2NoZWQvZmFpci5jDQo+
ICsrKyBiL2tlcm5lbC9zY2hlZC9mYWlyLmMNCj4gQEAgLTM3ODEsNiArMzc4MSw3IEBAIHN0YXRp
YyB2b2lkIHJld2VpZ2h0X2VudGl0eShzdHJ1Y3QgY2ZzX3JxICpjZnNfcnEsIHN0cnVjdCBzY2hl
ZF9lbnRpdHkgKnNlLA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVwZGF0ZV9l
bnRpdHlfbGFnKGNmc19ycSwgc2UpOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHNlLT5kZWFkbGluZSAtPSBzZS0+dnJ1bnRpbWU7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgc2UtPnJlbF9kZWFkbGluZSA9IDE7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBjZnNfcnEtPm5yX3F1ZXVlZC0tOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmICghY3VycikNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgX19kZXF1ZXVlX2VudGl0eShjZnNfcnEsIHNlKTsNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB1cGRhdGVfbG9hZF9zdWIoJmNmc19ycS0+bG9hZCwgc2UtPmxv
YWQud2VpZ2h0KTsNCj4gQEAgLTM4MTEsNiArMzgxMiw3IEBAIHN0YXRpYyB2b2lkIHJld2VpZ2h0
X2VudGl0eShzdHJ1Y3QgY2ZzX3JxICpjZnNfcnEsIHN0cnVjdCBzY2hlZF9lbnRpdHkgKnNlLA0K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBsYWNlX2VudGl0eShjZnNfcnEsIHNl
LCAwKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIWN1cnIpDQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9fZW5xdWV1ZV9l
bnRpdHkoY2ZzX3JxLCBzZSk7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjZnNf
cnEtPm5yX3F1ZXVlZCsrOw0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oC8qDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogVGhlIGVudGl0eSdzIHZy
dW50aW1lIGhhcyBiZWVuIGFkanVzdGVkLCBzbyBsZXQncyBjaGVjaw0KDQo=
