Received: from m1383.mail.163.com (m1383.mail.163.com [220.181.13.83])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831DC24C96
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="P5zTp7We"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=e6zMk9Bh3Q6656u3sK7lbwsFM17CE7gE3cgmnFOZML4=; b=P
	5zTp7WesqSRGI6wPvnNwDY+IiHnW4FEubMaFddlIBrXrg88cxcFXSkeLU1DR2fxc
	h5nCb2vsieZLm6QpBCKh3JAxgpBxsR0NzCGcmSKgBLQ3r4g0PiK0Rq+R9QhIRum+
	6ZmeNDZ/dUh6jcxC3Om1NoIXLKlLgnXcwfSJHaj+Us=
Received: from zyytlz.wz$163.com ( [111.206.145.21] ) by
 ajax-webmail-wmsvr83 (Coremail) ; Tue, 10 Oct 2023 22:16:01 +0800 (CST)
X-Originating-IP: [111.206.145.21]
Date: Tue, 10 Oct 2023 22:16:01 +0800 (CST)
From: =?GBK?B?zfXV9w==?= <zyytlz.wz@163.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Alexandre Mergnat" <amergnat@baylibre.com>, 
	"Chen-Yu Tsai" <wenst@chromium.org>, 
	"AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>, 
	"Hans Verkuil" <hverkuil-cisco@xs4all.nl>, 
	"Sasha Levin" <sashal@kernel.org>
Subject: Re:[PATCH 6.1 407/600] media: mtk-jpeg: Fix use after free bug due
 to uncanceled work
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <20230911134645.689607572@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
 <20230911134645.689607572@linuxfoundation.org>
X-NTES-SC: AL_QuySBPWfuEst5yCZYukXkksRj+o/X8G3uvgi2odeOJ80iirQ4SAKXlxtF0Xo8fyVGxu9kzuUUjhe5vxzb4t5U75a1TQx6OeSvF4IBVmca7zi
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5f19d638.6fa5.18b19f1d4fd.Coremail.zyytlz.wz@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:U8GowADXH4yhXCVlvosRAA--.44033W
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/xtbBzhQFU2I0a3bJSAACsE
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKU29ycnkgdG8gYm90aGVyIHlvdSBmb3IgSSBkaWRuJ3Qga25vdyBob3cgdG8gc3VibWl0
IHBhdGNoIHRvIGEgc3BlY2lmaWMgYnJhbmNoLgpDb3VsZCB5b3UgcGxlYXNlIHB1c2ggdGhpcyBw
YXRjaCB0byA1LjEwIGJyYW5jaD8gVGhlIGNocm9tZS1vcyBpcyBhZmZjdGVkIGJ5IHRoaXMgaXNz
dWUuCgpCZXN0IHJlZ2FyZHMsClpoZW5nIFdhbmcKCkF0IDIwMjMtMDktMTEgMjA6NDc6MjAsICJH
cmVnIEtyb2FoLUhhcnRtYW4iIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj42
LjEtc3RhYmxlIHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBs
ZWFzZSBsZXQgbWUga25vdy4KPgo+LS0tLS0tLS0tLS0tLS0tLS0tCj4KPkZyb206IFpoZW5nIFdh
bmcgPHp5eXRsei53ekAxNjMuY29tPgo+Cj5bIFVwc3RyZWFtIGNvbW1pdCBjNjc3ZDdhZTgzMTQx
ZDM5MGQxMjUzYWJlYmFmYTQ5Yzk2MmFmYjUyIF0KPgo+SW4gbXRrX2pwZWdfcHJvYmUsICZqcGVn
LT5qb2JfdGltZW91dF93b3JrIGlzIGJvdW5kIHdpdGgKPm10a19qcGVnX2pvYl90aW1lb3V0X3dv
cmsuIFRoZW4gbXRrX2pwZWdfZGVjX2RldmljZV9ydW4KPmFuZCBtdGtfanBlZ19lbmNfZGV2aWNl
X3J1biBtYXkgYmUgY2FsbGVkIHRvIHN0YXJ0IHRoZQo+d29yay4KPklmIHdlIHJlbW92ZSB0aGUg
bW9kdWxlIHdoaWNoIHdpbGwgY2FsbCBtdGtfanBlZ19yZW1vdmUKPnRvIG1ha2UgY2xlYW51cCwg
dGhlcmUgbWF5IGJlIGEgdW5maW5pc2hlZCB3b3JrLiBUaGUKPnBvc3NpYmxlIHNlcXVlbmNlIGlz
IGFzIGZvbGxvd3MsIHdoaWNoIHdpbGwgY2F1c2UgYQo+dHlwaWNhbCBVQUYgYnVnLgo+Cj5GaXgg
aXQgYnkgY2FuY2VsaW5nIHRoZSB3b3JrIGJlZm9yZSBjbGVhbnVwIGluIHRoZSBtdGtfanBlZ19y
ZW1vdmUKPgo+Q1BVMCAgICAgICAgICAgICAgICAgIENQVTEKPgo+ICAgICAgICAgICAgICAgICAg
ICB8bXRrX2pwZWdfam9iX3RpbWVvdXRfd29yawo+bXRrX2pwZWdfcmVtb3ZlICAgICB8Cj4gIHY0
bDJfbTJtX3JlbGVhc2UgIHwKPiAgICBrZnJlZShtMm1fZGV2KTsgfAo+ICAgICAgICAgICAgICAg
ICAgICB8Cj4gICAgICAgICAgICAgICAgICAgIHwgdjRsMl9tMm1fZ2V0X2N1cnJfcHJpdgo+ICAg
ICAgICAgICAgICAgICAgICB8ICAgbTJtX2Rldi0+Y3Vycl9jdHggLy91c2UKPkZpeGVzOiBiMmYw
ZDI3MjRiYTQgKCJbbWVkaWFdIHZjb2RlYzogbWVkaWF0ZWs6IEFkZCBNZWRpYXRlayBKUEVHIERl
Y29kZXIgRHJpdmVyIikKPlNpZ25lZC1vZmYtYnk6IFpoZW5nIFdhbmcgPHp5eXRsei53ekAxNjMu
Y29tPgo+UmV2aWV3ZWQtYnk6IEFsZXhhbmRyZSBNZXJnbmF0IDxhbWVyZ25hdEBiYXlsaWJyZS5j
b20+Cj5SZXZpZXdlZC1ieTogQ2hlbi1ZdSBUc2FpIDx3ZW5zdEBjaHJvbWl1bS5vcmc+Cj5SZXZp
ZXdlZC1ieTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8gPGFuZ2Vsb2dpb2FjY2hpbm8uZGVs
cmVnbm9AY29sbGFib3JhLmNvbT4KPlNpZ25lZC1vZmYtYnk6IEhhbnMgVmVya3VpbCA8aHZlcmt1
aWwtY2lzY29AeHM0YWxsLm5sPgo+U2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBr
ZXJuZWwub3JnPgo+LS0tCj4gZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9tZWRpYXRlay9qcGVnL210
a19qcGVnX2NvcmUuYyB8IDEgKwo+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+Cj5k
aWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9tZWRpYXRlay9qcGVnL210a19qcGVn
X2NvcmUuYyBiL2RyaXZlcnMvbWVkaWEvcGxhdGZvcm0vbWVkaWF0ZWsvanBlZy9tdGtfanBlZ19j
b3JlLmMKPmluZGV4IDMwNzFiNjE5NDZjM2IuLmU5YTRmOGFiZDIxYzUgMTAwNjQ0Cj4tLS0gYS9k
cml2ZXJzL21lZGlhL3BsYXRmb3JtL21lZGlhdGVrL2pwZWcvbXRrX2pwZWdfY29yZS5jCj4rKysg
Yi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL21lZGlhdGVrL2pwZWcvbXRrX2pwZWdfY29yZS5jCj5A
QCAtMTQxMiw2ICsxNDEyLDcgQEAgc3RhdGljIGludCBtdGtfanBlZ19yZW1vdmUoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqcGRldikKPiB7Cj4gCXN0cnVjdCBtdGtfanBlZ19kZXYgKmpwZWcgPSBw
bGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsKPiAKPisJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5j
KCZqcGVnLT5qb2JfdGltZW91dF93b3JrKTsKPiAJcG1fcnVudGltZV9kaXNhYmxlKCZwZGV2LT5k
ZXYpOwo+IAl2aWRlb191bnJlZ2lzdGVyX2RldmljZShqcGVnLT52ZGV2KTsKPiAJdjRsMl9tMm1f
cmVsZWFzZShqcGVnLT5tMm1fZGV2KTsKPi0tIAo+Mi40MC4xCj4KPgoKCg==
