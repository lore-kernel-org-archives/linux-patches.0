Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BF616DC28
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 01:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130110; cv=none; b=YPatuHNJ7DRVqzH/4rsONk7RkjNKHvdx4NA74FSTbs2mTUSWfp4vXwX1Q4PiBdJRoJVFgyUZRN4DjGq7frO5y7GPx1Ej6IeAR1VlrSY23jiyvaG0UUGqIksR61uBP2mWxoMnz5SYPlkEEcoJi7eyHmLE0/yFYCG1AJUtSWDl8KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130110; c=relaxed/simple;
	bh=o4rf/9CgKzT9mny7t5wz2BOkDVx1G0IeipD5wm8BOSg=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=ZeYPhaYZuYhlby8wN7vsF9ORIFYqBKGFQegdlthIXiTGQB6PPunlgBN25vTGhBqqnVSgUzwd14DFUkSYITcZWdL/LUmKloxnmXUsZhrKZXqL/8RUoJgoO5ajGaTKM3Nb5czakIgx9s0HhE5dvPlu+e72vI5K9a48qbuRdZTMcgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=VLZwnwk9; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="VLZwnwk9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783130061;
	bh=o4rf/9CgKzT9mny7t5wz2BOkDVx1G0IeipD5wm8BOSg=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=VLZwnwk9AhG/OaJ15IL0lpZLkBMRx+iUQQ0QJvSwbDULtnWRxYli8DexU9F9Pk6Ge
	 AtwUC06hXkM8NGmLa1nZjbzdhUPI+II3TcWy6C4QEh1okobecSaeFTirqLpHV1ZCN+
	 0ZKWDqRr0UeVhM/iVUH6EH3p+Exo5hYbraO8Kh30=
EX-QQ-RecipientCnt: 8
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqQ6f7IieUZ8DoKgL9zJG7IbL7boNmGOgcs=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: sy5slbgbkOrpveN3vtpzWIsJn0DU2HSRV9x4l1UKfxg=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1783130059t617f07cf
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?QmVuIEh1dGNoaW5ncw==?=" <ben@decadent.org.uk>, "=?utf-8?B?R3JlZyBLSA==?=" <gregkh@linuxfoundation.org>, "=?utf-8?B?c3RhYmxl?=" <stable@vger.kernel.org>
Cc: "=?utf-8?B?cGF0Y2hlcw==?=" <patches@lists.linux.dev>, "=?utf-8?B?UGVkcm8gVGFtbWVsYQ==?=" <pctammela@mojatatu.com>, "=?utf-8?B?U2ltb24gSG9ybWFu?=" <simon.horman@corigine.com>, "=?utf-8?B?ZGF2ZW0=?=" <davem@davemloft.net>, "=?utf-8?B?U2FzaGEgTGV2aW4=?=" <sashal@kernel.org>
Subject: Re: [PATCH 5.10 01/96] net/sched: act_pedit: use NLA_POLICY for parsing ex keys
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Sat, 4 Jul 2026 09:54:18 +0800
X-Priority: 3
Message-ID: <tencent_5E399B2E4242D50E1870F69E@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20260702155108.949633242@linuxfoundation.org>
	<20260702155108.985307603@linuxfoundation.org>
	<418ca29bbbb1190853136331c572470dca803800.camel@decadent.org.uk>
In-Reply-To: <418ca29bbbb1190853136331c572470dca803800.camel@decadent.org.uk>
X-QQ-ReplyHash: 935495786
X-BIZMAIL-ID: 163351916519790184
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Sat, 04 Jul 2026 09:54:20 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MXoUQUXLLXXAUfqSpgek5yrezdbBldehLVJWNVvqNri8Eme+w+w5LZKN
	BkCV8lAka9BAtg5ol4scbpQP4x46joYSRm1nNqG4Jtqzn4sQAMwDaKu36LxJSrY2u92rYz3
	5yBHNTZqeSb+cuPY83phS7uckzPf698MXEIXVs6XOpAfHzoYj+K504iNDSzFx5lmHdqnczf
	uyEDMbT/jIIB4J3Yau031aXYgNrA00QoWEb0VYFGWKQntLImlzlkNsx/E8L0Kyv01Ws4S7G
	ZNpvkNZ+DezBkhyn+CwDNinbfRNYRfTfE3bU/PBPX8QwRxX1OE7BeMmSTpicGDKQZqSRixV
	xxhwhYJTQFZeI0tK2AWdkZnKrmkhY6/Up2v+uGpBnsDj5S5Y5l2RVeKCnES4JbbyZi+4pXz
	hL639FOCwwl38EIykZ/HjlJqLAYqNafg5VAGnEHgs08dPlZmQUCa3JYr0sjp7sjpFhhJSxc
	XuElgBmoWMJh+bON870QEKWuROxxHlXlhF/H7T8IovqHPGVF9dIiFdXOQyYf0zF51yWXGV3
	nJ7rQOqqiV8B1bmOmL/4gh4XQwJrXayfNHsKdW7MHh32MWxdj3p13/L59jO8ikLRknf1xa6
	ZJu9seLo/2mm6tppUiygW4//kmY+Z8jXnRBvNd3AMMG24iBSJKXwFvrMIcfebnChMoI/Uda
	haSOKTdO57b073UwlJsDcbthCaBHAwLPi5FybGf+N5xZopFWJG3J5YO5i8clxpiBy5VkgQY
	cxAL3DnCCEY/oS2PFAKCSc+LdYBgCB/f7GFDRE6/ncKv7YgM6y9NJRa3f+6AcPsNG9FW60N
	IGkzPTRCnb2wVNyQoSt1jUZ9xruOe9CwB+Izh4Ij1nocd7RywU1SwZrCPGNl/EBTODhp6To
	IncXYeigw360CfSQ8bIIIIDEUq7EkVur6v/3T0mtU/AkFezu1rshG8APhxXfFSoyXjxO9AN
	LvWTlYPP+gHQToLaTodddVfQm3qwY+fN2a2jJKMD1waOjBgaQSC1T5vb3hs8no0B/lKxjRT
	S58KfAVV6bnMv1CY7Hjz3y3PFQanFa6MPr0AahaAGaYE2924u6CwrWDLBZP2Xcz19Rm4dui
	h49rkd1SV7M1i8AJP4Mfg/b/wu3BHKLoskKfgW91IIP
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

PiBPbiBUaHUsIDIwMjYtMDctMDIgYXQgMTg6MTggKzAyMDAsIEdyZWcgS3JvYWgtSGFydG1h
biB3cm90ZToNCj4gPiA1LjEwLXN0YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFz
IGFueSBvYmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lIGtub3cuDQo+ID4NCj4gPiAtLS0tLS0t
LS0tLS0tLS0tLS0NCj4gPg0KPiA+ID5Gcm9tOiBQZWRybyBUYW1tZWxhIDxwY3RhbW1lbGFA
bW9qYXRhdHUuY29tPg0KPiA+DQo+ID4gWyBVcHN0cmVhbSBjb21taXQgNTAzNjAzNDU3MmI3
OWRhYTZkNjYwMDMzOGU4ZTgyMjllMmE0NGIwOSBdDQo+ID4NCj4gPiBUcmFuc2Zvcm0gdHdv
IGNoZWNrcyBpbiB0aGUgJ2V4JyBrZXkgcGFyc2luZyBpbnRvIG5ldGxpbmsgcG9saWNpZXMN
Cj4gPiByZW1vdmluZyBleHRyYSBpZiBjaGVja3MuDQo+IFsuLi5dDQo+IA0KPiBObyBvYmpl
Y3Rpb24sIGJ1dCB0aGlzIHNob3VsZCBhbHNvIGJlIGFwcGxpZWQgdG8gNS4xNSBhbmQgNi4x
Lg0KR29vZCBpZGVhLCBidXQgaSBhbSBub3Qgc3VyZSB0aGF0IGhlcmUgaXMgYSBsb2dpYyBj
aGFuZ2UsDQphcyBwb2xpY3kgZm9yIHN0YWJsZSB0cmVlIGl0IGJlIHNob3VsZCBhcHBsaWVk
IHRvIDUuMTUgYW5kIDYuMS4NCg0KQlJzDQpXZW50YW8gR3Vhbg==

