Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5670619B580
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723553788; cv=none; b=HwQyPP+pgMGwCk8qjnBQxr1hHZ6ntZsLUvLje7iIBBAh3S2j8hSlVY1Fv1ZOU10n3N+2O/9xWFZ4PNsGEuGVkCrN7Xyyx3K0RiK53+sNDSKV5JPdKLpccv1U42gLfgf+tuvEV+GYHY3m+oG/ynQ7N59+eG+Kg+8ZYwUBi7JEUik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723553788; c=relaxed/simple;
	bh=Vp8CkJbR2Oxr6i4hruj52WJzN1ov+xKRpH8VHWMRVXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUZs8mgOjnfPxjGzLbZBKQ2Xgx0R3Od3Am1QjVzMytNZHDhA+nUZUXSHaVGbYrVxyEbVbsF4SVt4bCFIFz4tTvtvmAo3Q37/D2AW00kKB2mLXAFqg7EVnsnjODOrHV4Py24w6QiOimTf2iwogXBm5UZql85RC56O6c/qV6452o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev; spf=pass smtp.mailfrom=holm.dev; dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b=pmq5kQIO; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holm.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b="pmq5kQIO"
Message-ID: <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=holm.dev; s=key1;
	t=1723553782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vp8CkJbR2Oxr6i4hruj52WJzN1ov+xKRpH8VHWMRVXg=;
	b=pmq5kQIOTU06psOfBIhKu7R8UVPxbfXBvkbpVXmkJW8lno3/8LrntoGPqQSux4IgmYPz6C
	zjfLIcs3ZZKrki3tlPTRfKNgiuvN1vstNnEwLc99snW2X47KjZ4S1j0RGUrVjt1LtP//O3
	QamcoRxaLMd9/5V9vTuZ7nMk2pR4xOT/Nf3m82ZNGIIFzRmqbRKmjz6gZdwiBWbKtA5bsu
	jLyU+b+VhgSGDZQG7CtXhaUqfnVGNUCVubub056Rv5A8FY9T4iAmr39AxkvvuYozqT27o8
	vh+x7oW+1Za4xyUYck6BBMB8JYJOaOAKUjt0Agc8em7lKH0dKDqFC42uGLF4Lw==
Date: Tue, 13 Aug 2024 14:56:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Mario Limonciello <mario.limonciello@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, Hersen Wu <hersenxs.wu@amd.com>,
 Wayne Lin <wayne.lin@amd.com>, Daniel Wheeler <daniel.wheeler@amd.com>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kevin Holm <kevin@holm.dev>
In-Reply-To: <20240812160156.489958533@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Migadu-Flow: FLOW_OUT

DQpPbiA4LzEyLzI0IDE4OjA0LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+IDYuMTAt
c3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBs
ZWFzZSBsZXQgbWUga25vdy4NClRoaXMgcGF0Y2ggc2VlbXMgdG8gY2F1c2UgcHJvYmxlbXMg
d2l0aCBteSBleHRlcm5hbCBzY3JlZW5zIG5vdCBnZXR0aW5nIGEgc2lnbmFsDQphZnRlciBt
eSBsYXB0b3Agd2FrZXMgdXAgZnJvbSBzbGVlcC4NCg0KVGhlIHByb2JsZW0gb2NjdXJzIG9u
IG15IExlbm92byBQMTRzIEdlbiAyICh0eXBlIDIxQTApIGNvbm5lY3RlZCB0byBhIGxlbm92
bw0KdXNiLWMgZG9jayAodHlwZSA0MEFTKSB3aXRoIHR3byA0ayBkaXNwbGF5IHBvcnQgc2Ny
ZWVucyBjb25uZWN0ZWQuIE15IExhcHRvcA0Kc2NyZWVuIHdha2VzIHVwIG5vcm1hbGx5LCB0
aGUgdHdvIGV4dGVybmFsIGRpc3BsYXlzIGFyZSBzdGlsbCBkZXRlY3RlZCBieSBteQ0Kc3lz
dGVtIGFuZCBzaG93biBpbiB0aGUga2RlIHN5c3RlbSBzZXR0aW5ncywgYnV0IHRoZXkgc2hv
dyBubyBpbWFnZS4NCg0KVGhlIHByb2JsZW0gb25seSBvY2N1cnMgYWZ0ZXIgcHV0dGluZyBt
eSBzeXN0ZW0gdG8gc2xlZXAsIG5vdCBvbiBmaXJzdCBib290Lg0KDQpJIGRpZG4ndCBkbyBh
IGZ1bGwgZ2l0IGJpc2VjdCwgSSBvbmx5IHRlc3RlZCB0aGUgZnVsbCByYyBhbmQgdGhlbiBh
IGJ1aWxkIGENCmtlcm5lbCB3aXRoIHRoaXMgcGF0Y2ggcmV2ZXJ0ZWQsIHJldmVydGluZyBv
bmx5IHRoaXMgcGF0Y2ggc29sdmVkIHRoZSBwcm9ibGVtLg0KDQp+a2V2aW4NCj4gDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbTogV2F5bmUgTGluIDx3YXluZS5saW5AYW1k
LmNvbT4NCj4gDQo+IGNvbW1pdCAyMDJkYzM1OWFkZGFiMjk0NTFkM2QxODI0M2MzZDk1N2Rh
NTM5MmM4IHVwc3RyZWFtLg0KPiANCj4gW1doeV0NCj4gTGlrZSBjb21taXQgZWM1ZmE5ZmNk
ZWNhICgiZHJtL2FtZC9kaXNwbGF5OiBBZGp1c3QgdGhlIE1TVCByZXN1bWUgZmxvdyIpLCB3
ZQ0KPiB3YW50IHRvIGF2b2lkIGhhbmRsaW5nIG1zdCB0b3BvbG9neSBjaGFuZ2VzIGJlZm9y
ZSByZXN0b3JpbmcgdGhlIG9sZCBzdGF0ZS4NCj4gSWYgd2UgZW5hYmxlIERQX1VQX1JFUV9F
TiBiZWZvcmUgY2FsbGluZyBkcm1fYXRvbWljX2hlbHBlcl9yZXN1bWUoKSwgaGF2ZQ0KPiBj
aGFuZ2NlIHRvIGhhbmRsZSBDU04gZXZlbnQgZmlyc3QgYW5kIGZpcmUgaG90cGx1ZyBldmVu
dCBiZWZvcmUgcmVzdG9yaW5nIHRoZQ0KPiBjYWNoZWQgc3RhdGUuDQo+IA0KPiBbSG93XQ0K
PiBEaXNhYmxlIG1zdCBicmFuY2ggc2VuZGluZyB1cCByZXF1ZXN0IGV2ZW50IGJlZm9yZSB3
ZSByZXN0b3JpbmcgdGhlIGNhY2hlZCBzdGF0ZS4NCj4gRFBfVVBfUkVRX0VOIHdpbGwgYmUg
c2V0IGxhdGVyIHdoZW4gd2UgY2FsbCBkcm1fZHBfbXN0X3RvcG9sb2d5X21ncl9yZXN1bWUo
KS4NCj4gDQo+IENjOiBNYXJpbyBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1k
LmNvbT4NCj4gQ2M6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4N
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gUmV2aWV3ZWQtYnk6IEhlcnNlbiBX
dSA8aGVyc2VueHMud3VAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogV2F5bmUgTGluIDx3
YXluZS5saW5AYW1kLmNvbT4NCj4gVGVzdGVkLWJ5OiBEYW5pZWwgV2hlZWxlciA8ZGFuaWVs
LndoZWVsZXJAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4
YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhh
cnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiAtLS0NCj4gICBkcml2ZXJz
L2dwdS9kcm0vYW1kL2Rpc3BsYXkvYW1kZ3B1X2RtL2FtZGdwdV9kbS5jIHwgICAgMSAtDQo+
ICAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4gDQo+IC0tLSBhL2RyaXZlcnMv
Z3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0vYW1kZ3B1X2RtLmMNCj4gKysrIGIvZHJp
dmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG0uYw0KPiBAQCAt
MjQxOCw3ICsyNDE4LDYgQEAgc3RhdGljIHZvaWQgcmVzdW1lX21zdF9icmFuY2hfc3RhdHVz
KHN0cg0KPiAgIA0KPiAgIAlyZXQgPSBkcm1fZHBfZHBjZF93cml0ZWIobWdyLT5hdXgsIERQ
X01TVE1fQ1RSTCwNCj4gICAJCQkJIERQX01TVF9FTiB8DQo+IC0JCQkJIERQX1VQX1JFUV9F
TiB8DQo+ICAgCQkJCSBEUF9VUFNUUkVBTV9JU19TUkMpOw0KPiAgIAlpZiAocmV0IDwgMCkg
ew0KPiAgIAkJZHJtX2RiZ19rbXMobWdyLT5kZXYsICJtc3Qgd3JpdGUgZmFpbGVkIC0gdW5k
b2NrZWQgZHVyaW5nIHN1c3BlbmQ/XG4iKTsNCj4gDQo+IA0KPiANCg0K
