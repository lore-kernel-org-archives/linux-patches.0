Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564AC2D7398
	for <patches@lists.linux.dev>; Wed, 24 Jun 2026 09:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293363; cv=none; b=PsZzxXZolSFiIICrONnDBX5deFY6Tls197YF/ZC7dw+k0lCxu/Fe/WzhvBUJGNxxfBgiYJ3fa0eqY0sQrW98yao5SdPF2fzMKoYcPih1Zd/+JifnCJ75TDNtKXhEFBOOvEaG3SdWSkB5xeESKHHf6AyyRgNvDiytSvwzjb+Kr3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293363; c=relaxed/simple;
	bh=OCeN4taB/M5dPJpMJKkXhDru/InAXPoRvcuwgcg6ICI=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=DBmGnbp+Xj4Izn2ZVH14CoPb/Eu/l13R0hyKDpaGNERbBU37z2Qj1L04NUfzlY1N5Xt3bxYW8i2RPbQCQ8xnxSUyoe+3LV+tRu9u9nctE2An7OmN0jGq31XE7Jdfn6TzTrPpA+QRix2m/TCXfpNhYGFpoIcPhI0CcCMhHIIcd0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=SnIneY0E; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="SnIneY0E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782293278;
	bh=OCeN4taB/M5dPJpMJKkXhDru/InAXPoRvcuwgcg6ICI=;
	h=From:To:Subject:Mime-Version:Date:Message-ID;
	b=SnIneY0ErAHhMC3ZDG5GhOhOTa6taGbqDvPbgw8ifG5pri44t8GoOPrAZx3eL2rrZ
	 WSEAzh/iQhIteD+IK+APHy0PkLOwTSIEd9AVuysBc7Yk+JCMa5EexLabQh62zuBNEa
	 vs4S9cpNCWEUG3S+M/mXc2ujuLMcZ5Qdb5Cux3QU=
EX-QQ-RecipientCnt: 8
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-FEAT: D4aqtcRDiqRdFc3p2pDC+jQy+RNMWdI0Y5ii4Iz6wLU=
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: +VT0cWnT7GyX0qk2JdQ4G3JLprWid0GRigGxRf0uoCI=
X-QQ-STYLE: 
X-QQ-mid: lv3gz7b-6t1782293276tcd911889
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?R3JlZyBLSA==?=" <gregkh@linuxfoundation.org>
Cc: "=?utf-8?B?aWtsYXR6Y28=?=" <iklatzco@gmail.com>, "=?utf-8?B?MDAxMDcwODI=?=" <00107082@163.com>, "=?utf-8?B?cGF0Y2hlcw==?=" <patches@lists.linux.dev>, "=?utf-8?B?cGV0ZXJ6?=" <peterz@infradead.org>, "=?utf-8?B?U2FzaGEgTGV2aW4=?=" <sashal@kernel.org>, "=?utf-8?B?c3RhYmxl?=" <stable@vger.kernel.org>, "=?utf-8?B?eWVvcmV1bS55dW4=?=" <yeoreum.yun@arm.com>
Subject: Re: perf: Fix dangling cgroup pointer in cpuctx
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Wed, 24 Jun 2026 17:27:56 +0800
X-Priority: 3
Message-ID: <tencent_62A2AD8F12114EBC582137F1@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20260616145120.525872058@linuxfoundation.org>
	<20260624080310.2502480-1-guanwentao@uniontech.com>
	<2026062455-obtrusive-sandbox-d6d1@gregkh>
In-Reply-To: <2026062455-obtrusive-sandbox-d6d1@gregkh>
X-QQ-ReplyHash: 1032237551
X-BIZMAIL-ID: 5673338499215917731
X-Address-Ticket:version=;type=;ticket_id=;id_list=;display_name=;session_id=;
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Wed, 24 Jun 2026 17:27:57 +0800 (CST)
Feedback-ID: lv:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NAtipnnbTPea+aNH8FRrsJRoedTR8oAzEuEdIuBK8aiCiGooKDxQS4r3
	1n2HLxSasRlLfPyUMxXaVKpqiB3JILEqUMQf3p8RL1fKlKmeVMG5T0pAM3wikxvvRUHIfJm
	3/jjxwiqMosQxG6DpainEXzVCA5FDiXgfw7YN4ELbv1yg6v9zFV0h7YLB6Kx+Y4t6ifYOE1
	1KJ7CTRI4XVZ6q4TN3s5xXW4hTmiG1XDndqOeyeu4ZvOqwac3HkJJJVGG/jKRzU1Zq33i+q
	5Ei9bjVZkwOQ2I1NoIcxii+zog32e5XVHBRe9Vm9mNOB6y6rPXd6MR5DseQudExJL2zNfc4
	GTpsTaExCH8kPUNBbrDk3oZr5KjDXmuuqqlMs1ep1L8Z4/nRL6ETy1o79xsb6rfHjwOlXAG
	1JDkjHw7/bVoLEGJ4sRwbFgB0EP83Lecq4+mqZyRXf42rrTjRk51TmtWzY1QL99NhyAeswz
	Ua/sKnanQ3+NbAOVds5rX4SkaLUkKU+7OLXBqrRvGebpEvXc54niP8AoLb0QKN/2rx93uvu
	jtqwPbjw8x3ZFVTvGtF7NnP8fLdYw9AGaIKb+FVYXgSUQT/N+R5xRL6w4P1Au9CG9Wax98B
	zev09Y0hjrwupDR8ftJBMv+dnIEvDPce6yJK6FhCXV1QnqLn9zhdX0WwmM1HwXMZwWRvX0t
	1dMwAj+6vT7q8OuhiXsB71kBMTBifvXRrNBmShlKQp+0fwXL2f/aHmFGuOxTPwGLwj3IVcP
	DXi+FyEvOHVEDvUCZ4wrBhP6ECXGQ8FIYct8rnzbFKVxI05J7OnVY285bq+PXmt4WgBLzXr
	lDqkYQG2GdCo8vfygN8bOnqx947Iw0dOU7e/692KrcRNe/JOJFC5b2fVFeFMRFi0x+kzFOy
	BB5IuCrinCUSh73Yg5oqS0nFLNFmarzh7bW3lhFdEGnGaDEPXkGC+xEXE3JGMOYS9m73rDP
	QN18XPuK1gYEBVaFrZheqbpRPuIze0mzeGzG6ncbZvjVcnRGnm65RxpRjBrTFVTRUsbp9zR
	tKt/+7K56Hhk7V/62vOWBF7ko7mWpX6a92omrutU6lOHAJNO2cRZEY2d3epCr9+y0Piqb4H
	Q==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

SGVsbG8sDQoNCm9yZ2luYWwgcGF0Y2ggY29tbWl0IDNiN2EzNGFlYmJkZjJhNGI3Mjk1MjA1
YmYwYzY1NDI5NDI4M2VjODIsDQpwZXJmOiBGaXggZGFuZ2xpbmcgY2dyb3VwIHBvaW50ZXIg
aW4gY3B1Y3R4IGRlbGV0ZQ0KJ2V2ZW50LT5wZW5kaW5nX2Rpc2FibGUgPSAxOycgaW4gX19w
ZXJmX3JlbW92ZV9mcm9tX2NvbnRleHQoKSwNCmJ1dCB0aGUgYmFja3BvcnQgY29tbWl0IGFl
MWFkYTBhZjE2MjQ5YTNlZDE1ZTMzZmE2NzE5YTZhMmY5NmY1MzcgZGlkIG5vdC4NCg0KW2Nv
bnRleHQgZGlmZmVyZW50XQ0KMjUsMjZjMTksMjANCjwgIGtlcm5lbC9ldmVudHMvY29yZS5j
IHwgMTYgKysrKy0tLS0tLS0tLS0tLQ0KPCAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMTIgZGVsZXRpb25zKC0pDQotLS0NCj4gIGtlcm5lbC9ldmVudHMvY29yZS5jIHwg
MjEgKysrKysrLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspLCAxNSBkZWxldGlvbnMoLSkNCjI5YzIzDQo8IGluZGV4IDBhYzgzZmMxY2I1ZTMu
LjEzMjUyNGQwMjk3Y2IgMTAwNjQ0DQotLS0NCj4gaW5kZXggMWNjOThiOWIzYzBiNC4uZDc4
NjA4MzIzOTE2ZiAxMDA2NDQNCjMyYzI2DQo8IEBAIC0yMDU2LDE4ICsyMDU2LDYgQEAgbGlz
dF9kZWxfZXZlbnQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50LCBzdHJ1Y3QgcGVyZl9ldmVu
dF9jb250ZXh0ICpjdHgpDQotLS0NCj4gQEAgLTIxMjAsMTggKzIxMjAsNiBAQCBsaXN0X2Rl
bF9ldmVudChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQsIHN0cnVjdCBwZXJmX2V2ZW50X2Nv
bnRleHQgKmN0eCkNCjUxYzQ1LDUxDQo8IEBAIC0yNDAxLDYgKzIzODksMTAgQEAgX19wZXJm
X3JlbW92ZV9mcm9tX2NvbnRleHQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50LA0KLS0tDQo+
IEBAIC0yNDg4LDExICsyNDc2LDE0IEBAIF9fcGVyZl9yZW1vdmVfZnJvbV9jb250ZXh0KHN0
cnVjdCBwZXJmX2V2ZW50ICpldmVudCwNCj4gICAgICAgICAgICAgICBzdGF0ZSA9IFBFUkZf
RVZFTlRfU1RBVEVfRVhJVDsNCj4gICAgICAgaWYgKGZsYWdzICYgREVUQUNIX1JFVk9LRSkN
Cj4gICAgICAgICAgICAgICBzdGF0ZSA9IFBFUkZfRVZFTlRfU1RBVEVfUkVWT0tFRDsNCj4g
LSAgICAgaWYgKGZsYWdzICYgREVUQUNIX0RFQUQpIHsNCj4gLSAgICAgICAgICAgICBldmVu
dC0+cGVuZGluZ19kaXNhYmxlID0gMTsNCj4gKyAgICAgaWYgKGZsYWdzICYgREVUQUNIX0RF
QUQpDQo1M2M1Myw1NA0KPCAgICAgICB9DQotLS0NCj4gLSAgICAgfQ0KDQoNCkJScw0KV2Vu
dGFvIEd1YW4=

