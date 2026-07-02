Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740DC35E55D
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009865; cv=none; b=qg3LPCHCotp07tbjDxOHPhT/Us3PRDOLFciwBdeJTr8r9vFt3HjimBn/6bSbOWlpZ1W1y4rWMKH86osif+//i1s1/mDOVfTd21/FOKJKw6BbMW/UiVTpaoPBAWC5jPHjzw5l6GclcTKeDXDYlUpScSZXFJ6apNccl7wegdIVBGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009865; c=relaxed/simple;
	bh=Yhl+3oW3kXt8ec0rUSaQ1g6FmMDZRDoLmEpqjnxw3S0=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=hlK/JADuQ3BbyN8iYYoLp19gA/af71fEicFnbjrzwgsikmPkqmi+xjfU8Eef/kcAfDUlHfWAM0jW3uI1zW667/MXQ8z/oTPQkHmZXh+LOSKShfU/SEZcIm+io9ok8RtgWUiJCmQ3TI7BckGeuJCBzDd/o/GL7ChCHiFt9EollUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=BIdxpUOK; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="BIdxpUOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783009767;
	bh=Yhl+3oW3kXt8ec0rUSaQ1g6FmMDZRDoLmEpqjnxw3S0=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=BIdxpUOKbhKFP6PnEMF+lD4YeYuXVmTche01adarQG604WaPgTqAGmbfYQuRSkMdc
	 XkY88cQoQbQDeXwzh9kqqbbkCvNo1VWEjMJH8VKiR2R+C2Qv8/EcDNkZ/0s40HqR2U
	 WJf23+aO6xjZp5BKU2juUyCau1YXprO8M9sfiGsM=
EX-QQ-RecipientCnt: 8
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQ6f7IieUZ8DoKgL9zJG7IbL7boNmGOgcs=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: D7Y1ShbmZDUc5HDRLR7HoQ+C7igt/Drzm96NVueKceQ55F55yi618lUUpL/fBwymM4ehIFhDnY0VMUlNgbAbaw==
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1783009765te748538d
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?R3JlZyBLSA==?=" <gregkh@linuxfoundation.org>
Cc: "=?utf-8?B?MDAxMDcwODI=?=" <00107082@163.com>, "=?utf-8?B?aWtsYXR6Y28=?=" <iklatzco@gmail.com>, "=?utf-8?B?cGF0Y2hlcw==?=" <patches@lists.linux.dev>, "=?utf-8?B?cGV0ZXJ6?=" <peterz@infradead.org>, "=?utf-8?B?U2FzaGEgTGV2aW4=?=" <sashal@kernel.org>, "=?utf-8?B?c3RhYmxl?=" <stable@vger.kernel.org>, "=?utf-8?B?eWVvcmV1bS55dW4=?=" <yeoreum.yun@arm.com>
Subject: Re: [PATCH] perf: Fix dangling cgroup pointer in cpuctx backport
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Fri, 3 Jul 2026 00:29:25 +0800
X-Priority: 3
Message-ID: <tencent_6D500C6D6BAE135A01D2E2B8@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <2026062455-obtrusive-sandbox-d6d1@gregkh>
	<20260624095920.2558406-1-guanwentao@uniontech.com>
	<2026062404-unusual-nutmeg-87d5@gregkh>
	<tencent_5FDA609363B90C6249A050FD@qq.com>
	<2026070200-uneaten-smock-4130@gregkh>
In-Reply-To: <2026070200-uneaten-smock-4130@gregkh>
X-QQ-ReplyHash: 379268434
X-BIZMAIL-ID: 2400357538771675532
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Fri, 03 Jul 2026 00:29:26 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NFbgtEGdVZezRXmxXKhLuzCkl18SvNau5sDqnW7xrDdBBmGJu2aGRl5e
	EE4TzFzt0b7Lq3mmSAps3IsN57VXUhJTyhDbs2o9r7aCJYNPwG3xQPQJZPMM9wmM9KsVneE
	JYqwIXAEmwwcyU9LPcw88RtysKpTF6GzOou0cMx/E6hZhQLpIKUP3DqNOqGPrvXtP4POJh1
	2q5NbDiPAv5xlTMbjx2trMFnPF9+UccJ8C/ewbkPB/fo6FGG8pvN68kyJV5/+2/Bq/38qX1
	eHpJ12jTDo7sb3XQI/s2LVuW79a8k/pOFf7tGj9Int1ywlFeCKtDI4YwPNu3rKcmet4n7p5
	7dJ8Q+dyVL8s4rByXXtwiUbGn6lpYExW+nDbfMIIop+meBkqW4teNwdb8aYG5e0ibk8rcdX
	DmTSfudDlb/dc2EtJ4mfQPmKc7GajeaLO6HjHYyWvCfFcin7Y3kSHof2WLBudkwRhVhZBMK
	QiLZMN/Vl44I+fyRCU/oQGMVR1cpeV+wrNFqBRzpr1Lc8CrRhiJcevF5nXlhFIrk9H67Ae2
	O1KBEfpH9lJhpWtGaNmyV12Z/XVtp3wY4gV0U8wKzO2QjMS8VeDncaLJ1SEk9GpTS4b01S9
	PLishDL0BQ8+D9mYkh2kYcpeoV37LlgOprlklincZPMbFm44DltwCausTDdJfg+7hSDg3OV
	dKgWnKVyYWa/+emQRKbu3WRjjTg5VL87dYrpDDHPE8eQyPz2SGlYPYzC8s3SfHQq3a2vXpr
	LhmfGUENY6y/7+plViU4uBd4XYDZbvV32351tyZfyw5Nssr6VNHphv7HEvDbZPsEuHvctgI
	Wf3NIswZMh43FywTnsslWjpVG0h6z28Ct/zrsaLAOpj16h92m3INX+52nGJ5Alm+cyxBlLr
	PpyqmnQk6MWXA8TAhJzjFXASa+yENwntIyjF2xyFOsK2Ir7wuVLPVcAUmfAyQ27/zxVDqwD
	XAFC7PbNTbo+VrqbOVKbmVQO0f/pEg9DjC5ajZaOa8EVEr3kgZoMvh4/hxeLY26afL3bwM+
	p5oe/Q5vLJ2PsnPII13kyZIj9PgbLTznyXl2Xwb7IcJxZOXgiLoQr1Vfn/jUDI/WrA7TvoX
	1Xllmm186e3lK/v7xoXUGmI6+PFjPkcow==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

SGksDQoNCj4gT24gV2VkLCBKdW4gMjQsIDIwMjYgYXQgMDY6MDc6NDFQTSArMDgwMCwgV2Vu
dGFvIEd1YW4gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEp1biAyNCwgMjAyNiBhdCAwNTo1OToy
MVBNICswODAwLCBXZW50YW8gR3VhbiB3cm90ZToNCj4gPiA+ID4gcmVjZW50bHkgYmFja3Bv
cnQgb2YgKCJwZXJmOiBGaXggZGFuZ2xpbmcgY2dyb3VwIHBvaW50ZXIgaW4gY3B1Y3R4IikN
Cj4gPiA+ID4gdXNlIGEgbWlkZGxlIHZlcnNpb24sIHNvIGFsaWduZWQgd2l0aCB0aGUgdXBz
dHJlYW0gY29tbWl0Og0KPiA+ID4gPiAzYjdhMzRhZWJiZGYyYTRiNzI5NTIwNWJmMGM2NTQy
OTQyODNlYzgyDQo+ID4gPiA+DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogV2VudGFvIEd1
YW4gPGd1YW53ZW50YW9AdW5pb250ZWNoLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBr
ZXJuZWwvZXZlbnRzL2NvcmUuYyB8IDUgKystLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPiA+DQo+ID4gPiA+IGRp
ZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL2NvcmUuYyBiL2tlcm5lbC9ldmVudHMvY29yZS5j
DQo+ID4gPiA+IGluZGV4IGE0MTg3ZGVhNjQwMmEuLjczYTg2ZGIwNmNjOWIgMTAwNjQ0DQo+
ID4gPiA+IC0tLSBhL2tlcm5lbC9ldmVudHMvY29yZS5jDQo+ID4gPiA+ICsrKyBiL2tlcm5l
bC9ldmVudHMvY29yZS5jDQo+ID4gPiA+IEBAIC0yMzg0LDEwICsyMzg0LDkgQEAgX19wZXJm
X3JlbW92ZV9mcm9tX2NvbnRleHQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50LA0KPiA+ID4g
PiAgKi8NCj4gPiA+ID4gIGlmIChmbGFncyAmIERFVEFDSF9FWElUKQ0KPiA+ID4gPiAgc3Rh
dGUgPSBQRVJGX0VWRU5UX1NUQVRFX0VYSVQ7DQo+ID4gPiA+IC0gaWYgKGZsYWdzICYgREVU
QUNIX0RFQUQpIHsNCj4gPiA+ID4gLSBldmVudC0+cGVuZGluZ19kaXNhYmxlID0gMTsNCj4g
PiA+ID4gKyBpZiAoZmxhZ3MgJiBERVRBQ0hfREVBRCkNCj4gPiA+ID4gIHN0YXRlID0gUEVS
Rl9FVkVOVF9TVEFURV9ERUFEOw0KPiA+ID4gPiAtIH0NCj4gPiA+ID4gKw0KPiA+ID4gPiAg
ZXZlbnRfc2NoZWRfb3V0KGV2ZW50LCBjdHgpOw0KPiA+ID4gPg0KPiA+ID4gPiAgaWYgKGV2
ZW50LT5zdGF0ZSA+IFBFUkZfRVZFTlRfU1RBVEVfT0ZGKQ0KPiA+ID4gPiAtLQ0KPiA+ID4g
PiAyLjMwLjINCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBXaGF0IGtlcm5lbCB0cmVlKHMpIGlz
IHRoaXMgZm9yPyAgV2hhdCBnaXQgaWQgZG9lcyB0aGlzIGZpeD8NCj4gPiAxLiB2Ni42LjE0
MyBhbmQgdjYuMTIuOTQNCj4gPiAyLg0KPiA+IGFlMWFkYTBhZjE2MjQ5YTNlZDE1ZTMzZmE2
NzE5YTZhMmY5NmY1MzcgaW4gdjYuNi4xNDMNCj4gPiA0NmY1NjIzZjliMGVmNjYxMjdlMWRl
MTZmYjg1Nzg1MGNkYjE0ZTY4IGluIHY2LjEyLjk0DQo+IA0KPiBQbGVhc2UgcHV0IGFsbCBv
ZiB0aGlzIGluZm9ybWF0aW9uIGluIHRoZSBjaGFuZ2Vsb2cgYW5kIHByb3ZpZGUNCj4gdmVy
c2lvbnMgZm9yIGFsbCBvZiB0aGUgYnJhbmNoZXMgeW91IHdhbnQgaXQgZm9yLg0KVGhhbmtz
IGZvciB5b3VyIHJlcGx5LCBJIHdpbGwgc3VtYml0IGxhdGVyLg0KDQpPdXQgb2YgdGhyZWFk
LCBwZW9wbGUgc2F5cyBodHRwczovL2Nkbi5rZXJuZWwub3JnL3B1Yi9saW51eC9rZXJuZWwv
djcueC9saW51eC03LjEuMi50YXIueHoNCmZyb20ga2VybmVsLm9yZyBwdWJsaWMgYXJjaGl2
ZSByZXR1cm4gNDA0LCB3aGF0IGhhcHBlbj8NCg0KQlJzDQpXZW50YW8gR3Vhbg==

