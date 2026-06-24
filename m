Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C573AFD08
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 10:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295726; cv=none; b=QNNGs1zIK3IGBpT0scHu2vjw6VGMmPv9NaWhY3rOlnbhyPnSnEnictDlHz7LIpqpPs9yBR0AxMxObXfTlnf7fVN87eN2PHi6D3j2vYB3jOb9sK21LEa0rEFNaYBsLr1/ApyQE5y28k9RavFKL8Fuqsl18hoyNAnf2TKf9TM71uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295726; c=relaxed/simple;
	bh=+v7S37E0dY5/4t3avKqI3VqYZwq7Lsh9Mz4eOk+nSno=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=ChRkLHiALZFQe/F6hvsp7ZL5E1vS4S791Mp61HSrmNBguaHybPElIoETmYoUOLh8ls+nfAqynvuD6CzCIBEoszLb8MxZk2OVFBC2lKFV7PTv1RLs3QWXdKlrAWPrXy8RmhkMnleRI4obrPWglHMxh1P4DsvYIMWAU0IpmPYUokc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fMqa0fqp; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fMqa0fqp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782295664;
	bh=+v7S37E0dY5/4t3avKqI3VqYZwq7Lsh9Mz4eOk+nSno=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=fMqa0fqp1fo0dhrdvdu6x5wTXsKF29PSE5Wizc657IrQ1auHkidNRuL0jcwW58YqT
	 F8Qd+r3xSZIYsoRgTpoV5rswgmI2mKeZxn7UhlnPEYLAPAJiEfjhpMGbP6kZ/GVxjm
	 dx+iIhSPjpj/I9WkvOzZv5+V0GPZWd5VIGVZDsyo=
EX-QQ-RecipientCnt: 8
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqRdFc3p2pDC+jQy+RNMWdI0Y5ii4Iz6wLU=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: OHVu3/xI3m804vI7Ai0ywxH/GLrEw/Xa3VCxSyRykJo=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1782295661t3e371744
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
Date: Wed, 24 Jun 2026 18:07:41 +0800
X-Priority: 3
Message-ID: <tencent_5FDA609363B90C6249A050FD@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <2026062455-obtrusive-sandbox-d6d1@gregkh>
	<20260624095920.2558406-1-guanwentao@uniontech.com>
	<2026062404-unusual-nutmeg-87d5@gregkh>
In-Reply-To: <2026062404-unusual-nutmeg-87d5@gregkh>
X-QQ-ReplyHash: 705459129
X-BIZMAIL-ID: 16212402345110046153
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Wed, 24 Jun 2026 18:07:42 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NBxOuQH3x7tHK47B0Gbh2ByzuEYLKphe40naw3wmdG0WzHFlro6VuoIX
	no9pPx90uI+TBncykxmnNzsRWjGA7a8GtT6oVA0mdGHGQ0E/H0beapOXNQMqPTTqLu+x2QQ
	0sb5N2dhKkxroepD7F+MPJEHpnh3Hj6IeLBMx4I5oqMwxF/aFZMzPceqWmzYl/Vv8yDKOsL
	N/SndiGdLtLHaSsvTtjOz0+ShYTLdH4S00EN4wVgIBZoX+ut0DVZMAaiLpGL3H/biD+xzIu
	uaeSNBP+x8eIKbyY0go/2S5nW6UZVju8Xz753EHh5UWYey2ihQCKjf5v12XuBoVrwRIINPX
	dEricExkSf02vUoYJFj6sTadpBYq5WJCC40pjV76dBWOkTzl0ZMqCYRNY470proTPyOcoGV
	UWXn8csQb4sgLflXR2220hWR9f6j7koujx9b2n+qZaGTOIEuZO+Qc3hawuqc0WcrAXpSGL/
	wjeq1W1plR2CMiSJrroCuELqDePfoi7REnNa42NVGTXOrJurm8PJvQFOmNJiTInMh7cDX7U
	Zgfisaal/V3A9jnBGZjYjA/gvokC4jddbnpgXSHQlR65M+BTPnVl0TCXfqV/Y1za0dAsJ3s
	9b/rRyrFHXSWfEAaRm5LhXrVVUOHgbuODvmrHeuRYJiGEzwHuaz1/NegYvDiQktWtT6M1qn
	OEZ3pr8VSrrUB02dyXRJqBkUdTw0jXogBWJENkpmys29dWIMgzA9UUTNtGc+RfpAaIf2JKb
	iZGb/43mMfbc/8N7GrxTMItl0gF2+jLQXX115NFzEKf7hmtEHKR5P8/qtCHN45utYCGS2NM
	QMZkf69kwN6oegJWgZl48UTTkID+BstzN22Xk0NDXLCe05CjtPDLUe4PRHripVlbjNv+HEe
	FlQBoxRrFFN5dYfUrjAkxMCQOThX70iBo9r7H2qm7GUXYhpUXMIzHPZ/GUTQpmBZPr5i92i
	iGM33hY4+u07rO0yYDtg69IqmaznJll+tcdB+6mQCPiB2wSpJYodr7AxaSzR5ypypqelw6f
	aNYBYKGlJBKEf1EP2F5yCURckSHCTc8TWtoGXEBQItGE9Dk7w12wUKP4u/Np7jTaJDOTjtN
	A7mLQCF5NQ3v7ISSdt8b6P17lVpfd7lWf0fjGuSoGmVfuhiItpaaD/bXBSuAT5oazCA+Cxz
	xNvx
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

PiBPbiBXZWQsIEp1biAyNCwgMjAyNiBhdCAwNTo1OToyMVBNICswODAwLCBXZW50YW8gR3Vh
biB3cm90ZToNCj4gPiByZWNlbnRseSBiYWNrcG9ydCBvZiAoInBlcmY6IEZpeCBkYW5nbGlu
ZyBjZ3JvdXAgcG9pbnRlciBpbiBjcHVjdHgiKQ0KPiA+IHVzZSBhIG1pZGRsZSB2ZXJzaW9u
LCBzbyBhbGlnbmVkIHdpdGggdGhlIHVwc3RyZWFtIGNvbW1pdDoNCj4gPiAzYjdhMzRhZWJi
ZGYyYTRiNzI5NTIwNWJmMGM2NTQyOTQyODNlYzgyDQo+ID4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFdlbnRhbyBHdWFuIDxndWFud2VudGFvQHVuaW9udGVjaC5jb20+DQo+ID4gLS0tDQo+
ID4gIGtlcm5lbC9ldmVudHMvY29yZS5jIHwgNSArKy0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2tlcm5lbC9ldmVudHMvY29yZS5jIGIva2VybmVsL2V2ZW50cy9jb3JlLmMNCj4gPiBp
bmRleCBhNDE4N2RlYTY0MDJhLi43M2E4NmRiMDZjYzliIDEwMDY0NA0KPiA+IC0tLSBhL2tl
cm5lbC9ldmVudHMvY29yZS5jDQo+ID4gKysrIGIva2VybmVsL2V2ZW50cy9jb3JlLmMNCj4g
PiBAQCAtMjM4NCwxMCArMjM4NCw5IEBAIF9fcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KHN0
cnVjdCBwZXJmX2V2ZW50ICpldmVudCwNCj4gPiAgKi8NCj4gPiAgaWYgKGZsYWdzICYgREVU
QUNIX0VYSVQpDQo+ID4gIHN0YXRlID0gUEVSRl9FVkVOVF9TVEFURV9FWElUOw0KPiA+IC0g
aWYgKGZsYWdzICYgREVUQUNIX0RFQUQpIHsNCj4gPiAtIGV2ZW50LT5wZW5kaW5nX2Rpc2Fi
bGUgPSAxOw0KPiA+ICsgaWYgKGZsYWdzICYgREVUQUNIX0RFQUQpDQo+ID4gIHN0YXRlID0g
UEVSRl9FVkVOVF9TVEFURV9ERUFEOw0KPiA+IC0gfQ0KPiA+ICsNCj4gPiAgZXZlbnRfc2No
ZWRfb3V0KGV2ZW50LCBjdHgpOw0KPiA+IA0KPiA+ICBpZiAoZXZlbnQtPnN0YXRlID4gUEVS
Rl9FVkVOVF9TVEFURV9PRkYpDQo+ID4gLS0NCj4gPiAyLjMwLjINCj4gPg0KPiANCj4gV2hh
dCBrZXJuZWwgdHJlZShzKSBpcyB0aGlzIGZvcj8gIFdoYXQgZ2l0IGlkIGRvZXMgdGhpcyBm
aXg/DQoxLiB2Ni42LjE0MyBhbmQgdjYuMTIuOTQNCjIuIA0KYWUxYWRhMGFmMTYyNDlhM2Vk
MTVlMzNmYTY3MTlhNmEyZjk2ZjUzNyBpbiB2Ni42LjE0Mw0KNDZmNTYyM2Y5YjBlZjY2MTI3
ZTFkZTE2ZmI4NTc4NTBjZGIxNGU2OCBpbiB2Ni4xMi45NA0KDQpCUnMNCldlbnRhbyBHdWFu


