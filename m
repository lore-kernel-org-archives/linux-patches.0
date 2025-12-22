Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD2252917;
	Mon, 22 Dec 2025 01:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766368471; cv=none; b=svAHPKEglLkKyLcQiPbZ/VehUhtnY4ZIQ8NLyK7KntXK17OlUM0ZiMF+UiYMINxes3fGfUwfzM1t98iat4kTSfzEx7vXQcprWz8suHPS6GLt3otyaWfOTDPMt+ofqxjnwYFNuXXoz6VUXJPXq1Lux/QaBhE2oL1rEmv4FHkY+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766368471; c=relaxed/simple;
	bh=YKx2OfNHpt0zU6PvEsKM9KHdD6zN7eSvvVs5a+tcpNw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cobHe6X4K0GAP1u3pHPv5bT+QnOJJ2nxhpJvbvKPQcgpPv8xtPq9gdZ6qj8rX9Sa9PZ+j7/5TEi1WAuA3Yl5WiOaKqX5q/0FFtU8ewBpd3DPdJMK/TKZYM2YfM/GzOPSdVhlfRpQ0hyYszzCKlivq+ogEpgk7EKEZG2MHVIeHwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=A9TM3HBM; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="A9TM3HBM"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 5BM1sCRp92481740, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1766368452; bh=YKx2OfNHpt0zU6PvEsKM9KHdD6zN7eSvvVs5a+tcpNw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=A9TM3HBMb2Ph6Hogcxv6xTQc2+l/8h8/iDT2+1WLmdoX3MwBDP56NSHwofdhVFwwr
	 qT0z0xoKtTb1d6ciPiuOuW1zoGiK60qeaZ1pPzwHmahVRpaaKRqHkUC23tuOsh1RTa
	 T5ECdTy7raz8RhKoyO81uJNzmiKn0mae75CZkC7dIiL1QYagdv4qOA/aRXUsmvmwDh
	 tA0OeSPUNcVHJWtjrS7vVToYktTiiFoIWJjqBoUT8LjoylJ03J3okms+Yx+XsoKvjV
	 /beK84jmlpyAFG4NsrYHP0BuTBb4AOu9QrXx9jQPce2/9NYkeMC14oXOWaQemNEhce
	 vmFX74HluX3FQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 5BM1sCRp92481740
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 09:54:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 22 Dec 2025 09:54:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::4cbd:6c6c:b92b:3913%10]) with mapi id
 15.02.1748.010; Mon, 22 Dec 2025 09:54:11 +0800
From: =?utf-8?B?U2h1bWluZyBb6IyD5pu46YqYXQ==?= <shumingf@realtek.com>
To: Nathan Chancellor <nathan@kernel.org>, Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>,
        Liam Girdwood <lgirdwood@gmail.com>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [PATCH] ASoC: rt1320: Change return type of rt1320_t0_load() to
 void
Thread-Topic: [PATCH] ASoC: rt1320: Change return type of rt1320_t0_load() to
 void
Thread-Index: AQHccTxglr1HitGJyUuPdztRa3DQ+7Us6Gpg
Date: Mon, 22 Dec 2025 01:54:11 +0000
Message-ID: <62281f7409064902bdacc4863e5aae60@realtek.com>
References: <20251219-rt1320-sdw-avoid-uninit-ret-v1-1-faa3e250ebc4@kernel.org>
In-Reply-To: <20251219-rt1320-sdw-avoid-uninit-ret-v1-1-faa3e250ebc4@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBDbGFuZyB3YXJucyAob3IgZXJyb3JzIHdpdGggQ09ORklHX1dFUlJPUj15IC8gVz1lKToNCj4g
DQo+ICAgc291bmQvc29jL2NvZGVjcy9ydDEzMjAtc2R3LmM6MTM4Nzo2OiBlcnJvcjogdmFyaWFi
bGUgJ3JldCcgaXMgdXNlZA0KPiB1bmluaXRpYWxpemVkIHdoZW5ldmVyICdpZicgY29uZGl0aW9u
IGlzIHRydWUNCj4gWy1XZXJyb3IsLVdzb21ldGltZXMtdW5pbml0aWFsaXplZF0NCj4gICAgMTM4
NyB8ICAgICAgICAgaWYgKCFmd19yZWFkeSkgew0KPiAgICAgICAgIHwgICAgICAgICAgICAgXn5+
fn5+fn5+DQo+ICAgc291bmQvc29jL2NvZGVjcy9ydDEzMjAtc2R3LmM6MTQyMTo5OiBub3RlOiB1
bmluaXRpYWxpemVkIHVzZSBvY2N1cnMgaGVyZQ0KPiAgICAxNDIxIHwgICAgICAgICByZXR1cm4g
cmV0Ow0KPiAgICAgICAgIHwgICAgICAgICAgICAgICAgXn5+DQo+ICAgc291bmQvc29jL2NvZGVj
cy9ydDEzMjAtc2R3LmM6MTM4NzoyOiBub3RlOiByZW1vdmUgdGhlICdpZicgaWYgaXRzIGNvbmRp
dGlvbg0KPiBpcyBhbHdheXMgZmFsc2UNCj4gICAgMTM4NyB8ICAgICAgICAgaWYgKCFmd19yZWFk
eSkgew0KPiAgICAgICAgIHwgICAgICAgICBefn5+fn5+fn5+fn5+fn5+DQo+ICAgIDEzODggfCAg
ICAgICAgICAgICAgICAgZGV2X3dhcm4oZGV2LCAiJXMsIERTUCBGVyBpcyBOT1QgcmVhZHlcbiIs
DQo+IF9fZnVuY19fKTsNCj4gICAgICAgICB8DQo+IH5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+ICAgIDEzODkgfCAgICAgICAgICAgICAgICAg
Z290byBfZXhpdF87DQo+ICAgICAgICAgfCAgICAgICAgICAgICAgICAgfn5+fn5+fn5+fn5+DQo+
ICAgIDEzOTAgfCAgICAgICAgIH0NCj4gICAgICAgICB8ICAgICAgICAgfg0KPiAgIHNvdW5kL3Nv
Yy9jb2RlY3MvcnQxMzIwLXNkdy5jOjEzNjY6OTogbm90ZTogaW5pdGlhbGl6ZSB0aGUgdmFyaWFi
bGUgJ3JldCcgdG8NCj4gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gICAgMTM2NiB8ICAgICAgICAg
aW50IHJldDsNCj4gICAgICAgICB8ICAgICAgICAgICAgICAgIF4NCj4gICAgICAgICB8ICAgICAg
ICAgICAgICAgICA9IDANCj4gDQo+IFRoZSByZXR1cm4gdmFsdWUgb2YgcnQxMzIwX3QwX2xvYWQo
KSBpcyBuZXZlciBhY3R1YWxseSB1c2VkLCBzbyBpdCBjYW4ganVzdCBiZQ0KPiBlbGltaW5hdGVk
IGFsdG9nZXRoZXIgYnkgcmV0dXJuaW5nIHZvaWQsIGNsZWFyaW5nIHVwIHRoZSB3YXJuaW5nLg0K
PiANCj4gRml4ZXM6IGRhMTY4MmQ1ZThiNSAoIkFTb0M6IHJ0MTMyMDogc3VwcG9ydCBjYWxpYnJh
dGlvbiBhbmQgdGVtcGVyYXR1cmUvcjANCj4gbG9hZGluZyIpDQo+IFJlcG9ydGVkLWJ5OiBrZXJu
ZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gQ2xvc2VzOg0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjUxMjE5MTcxMS53WTZYVTc5Ni1sa3BAaW50ZWwu
Y29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5lbC5v
cmc+DQo+IC0tLQ0KPiAgc291bmQvc29jL2NvZGVjcy9ydDEzMjAtc2R3LmMgfCAxMCArKystLS0t
LS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2RlY3MvcnQxMzIwLXNkdy5jIGIvc291bmQv
c29jL2NvZGVjcy9ydDEzMjAtc2R3LmMNCj4gaW5kZXggOTQ0N2U3NDJjNjcyLi44NTU2MDQ1NWMz
ZTMgMTAwNjQ0DQo+IC0tLSBhL3NvdW5kL3NvYy9jb2RlY3MvcnQxMzIwLXNkdy5jDQo+ICsrKyBi
L3NvdW5kL3NvYy9jb2RlY3MvcnQxMzIwLXNkdy5jDQo+IEBAIC0xMzU3LDEzICsxMzU3LDEyIEBA
IHN0YXRpYyB2b2lkIHJ0MTMyMF92YWJfcHJlc2V0KHN0cnVjdA0KPiBydDEzMjBfc2R3X3ByaXYg
KnJ0MTMyMCkNCj4gICAgICAgICB9DQo+ICB9DQo+IA0KPiAtc3RhdGljIGludCBydDEzMjBfdDBf
bG9hZChzdHJ1Y3QgcnQxMzIwX3Nkd19wcml2ICpydDEzMjAsIHVuc2lnbmVkIGludCBsX3QwLA0K
PiB1bnNpZ25lZCBpbnQgcl90MCkNCj4gK3N0YXRpYyB2b2lkIHJ0MTMyMF90MF9sb2FkKHN0cnVj
dCBydDEzMjBfc2R3X3ByaXYgKnJ0MTMyMCwgdW5zaWduZWQgaW50DQo+ICtsX3QwLCB1bnNpZ25l
ZCBpbnQgcl90MCkNCj4gIHsNCj4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcnQxMzIw
LT5zZHdfc2xhdmUtPmRldjsNCj4gICAgICAgICB1bnNpZ25lZCBpbnQgZmFjdG9yID0gKDEgPDwg
MjIpLCBmd19yZWFkeTsNCj4gICAgICAgICBpbnQgbF90MF9kYXRhWzM4XSwgcl90MF9kYXRhWzM4
XTsNCj4gICAgICAgICB1bnNpZ25lZCBpbnQgZndfc3RhdHVzX2FkZHI7DQo+IC0gICAgICAgaW50
IHJldDsNCj4gDQo+ICAgICAgICAgc3dpdGNoIChydDEzMjAtPmRldl9pZCkgew0KPiAgICAgICAg
IGNhc2UgUlQxMzIwX0RFVl9JRDoNCj4gQEAgLTEzNzQsNyArMTM3Myw3IEBAIHN0YXRpYyBpbnQg
cnQxMzIwX3QwX2xvYWQoc3RydWN0IHJ0MTMyMF9zZHdfcHJpdg0KPiAqcnQxMzIwLCB1bnNpZ25l
ZCBpbnQgbF90MCwgdW5zDQo+ICAgICAgICAgICAgICAgICBicmVhazsNCj4gICAgICAgICBkZWZh
dWx0Og0KPiAgICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICIlczogVW5rbm93biBkZXZpY2Ug
SUQgJWRcbiIsIF9fZnVuY19fLA0KPiBydDEzMjAtPmRldl9pZCk7DQo+IC0gICAgICAgICAgICAg
ICByZXR1cm4gLUVJTlZBTDsNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gICAgICAgICB9
DQo+IA0KPiAgICAgICAgIHJlZ21hcF93cml0ZShydDEzMjAtPnJlZ21hcCwNCj4gQEAgLTEzOTks
OCArMTM5OCw3IEBAIHN0YXRpYyBpbnQgcnQxMzIwX3QwX2xvYWQoc3RydWN0IHJ0MTMyMF9zZHdf
cHJpdg0KPiAqcnQxMzIwLCB1bnNpZ25lZCBpbnQgbF90MCwgdW5zDQo+IA0KPiAgICAgICAgIHJ0
MTMyMF9md19wYXJhbV9wcm90b2NvbChydDEzMjAsIFJUMTMyMF9TRVRfUEFSQU0sIDMsDQo+ICZs
X3QwX2RhdGFbMF0sIHNpemVvZihsX3QwX2RhdGEpKTsNCj4gICAgICAgICBydDEzMjBfZndfcGFy
YW1fcHJvdG9jb2wocnQxMzIwLCBSVDEzMjBfU0VUX1BBUkFNLCA0LA0KPiAmcl90MF9kYXRhWzBd
LCBzaXplb2Yocl90MF9kYXRhKSk7DQo+IC0gICAgICAgcmV0ID0gcnQxMzIwX2NoZWNrX2Z3X3Jl
YWR5KHJ0MTMyMCk7DQo+IC0gICAgICAgaWYgKHJldCA8IDApDQo+ICsgICAgICAgaWYgKHJ0MTMy
MF9jaGVja19md19yZWFkeShydDEzMjApIDwgMCkNCj4gICAgICAgICAgICAgICAgIGRldl9lcnIo
ZGV2LCAiJXM6IEZhaWxlZCB0byBzZXQgRlcgcGFyYW0gMyw0IVxuIiwNCj4gX19mdW5jX18pOw0K
PiANCj4gICAgICAgICBydDEzMjAtPnRlbXBfbF9jYWxpYiA9IGxfdDA7DQo+IEBAIC0xNDE3LDgg
KzE0MTUsNiBAQCBzdGF0aWMgaW50IHJ0MTMyMF90MF9sb2FkKHN0cnVjdCBydDEzMjBfc2R3X3By
aXYNCj4gKnJ0MTMyMCwgdW5zaWduZWQgaW50IGxfdDAsIHVucw0KPiAgICAgICAgICAgICAgICAg
ICAgICAgICBTRFdfU0RDQV9DVEwoRlVOQ19OVU1fQU1QLA0KPiBSVDEzMjBfU0RDQV9FTlRfUERF
MjMsDQo+IA0KPiBSVDEzMjBfU0RDQV9DVExfUkVRX1BPV0VSX1NUQVRFLCAwKSwgMHgwMyk7DQo+
ICAgICAgICAgcnQxMzIwX3BkZV90cmFuc2l0aW9uX2RlbGF5KHJ0MTMyMCwgRlVOQ19OVU1fQU1Q
LA0KPiBSVDEzMjBfU0RDQV9FTlRfUERFMjMsIDB4MDMpOw0KPiAtDQo+IC0gICAgICAgcmV0dXJu
IHJldDsNCj4gIH0NCj4gDQo+ICBzdGF0aWMgaW50IHJ0MTMyMF9yYWVfbG9hZChzdHJ1Y3QgcnQx
MzIwX3Nkd19wcml2ICpydDEzMjApDQo+IA0KPiAtLS0NCj4gYmFzZS1jb21taXQ6IGE1NGZkNDgz
ZDBkNWY1ZjYyMGM0OGEyOWM5OGIwMTNlNTkwMDlhMDkNCj4gY2hhbmdlLWlkOiAyMDI1MTIxOS1y
dDEzMjAtc2R3LWF2b2lkLXVuaW5pdC1yZXQtYTE4ZWZlMWFkNTk0DQo+IA0KPiBCZXN0IHJlZ2Fy
ZHMsDQo+IC0tDQo+IE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRoYW5Aa2VybmVsLm9yZz4NCg0KDQpB
Y2tlZC1ieTogU2h1bWluZyBGYW4gPHNodW1pbmdmQHJlYWx0ZWsuY29tPg0KDQpUaGFua3MgZm9y
IHRoaXMgcGF0Y2guDQoNCg==
