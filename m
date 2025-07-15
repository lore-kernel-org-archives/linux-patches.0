Received: from mail02.rohde-schwarz.com (mail02.rohde-schwarz.com [80.246.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279A62045AD
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.246.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592568; cv=none; b=AA/dGe8hkWftwsVs6Oiya5loZx6Z8nABqBRwOwgeBsddVJhKRguChmqo7doD4jqGtyYoNYSw62aYv6EMnuFUyWxcCQz8zRmQcFFK3TdXU5DpeZcYmtcNR/Oulkgy3F9jaMhjovlotrWY5mx1xkKIr+L6gRZwgumgMtog5/ATd3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592568; c=relaxed/simple;
	bh=AihO8Q6yZNer2lqZ9UN5is6VS3fX4fiv5U0uGchE9Cc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SYlpUpqqSby9I08LiNCU564FCeP6yj6IJ2LY+KTRAa//1Wx9npw1JGkpJEOp4qhOmsZ1ZM5lwVJxxgCNdf7l3BBc1ZIc0V+xKthUZrRUBkINy3cahlSBRwOT/9G8b8GicGOEehMo6Ywu584aiirDfepbhHWbi3HmEnvpnGLDHL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com; spf=pass smtp.mailfrom=rohde-schwarz.com; arc=none smtp.client-ip=80.246.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rohde-schwarz.com
Received: from securemail-mu-h4.rohde-schwarz.com (10.0.19.146) by
 mail02.rohde-schwarz.com (172.21.64.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 17:00:56 +0200
Received: from GMU452.rsint.net ([10.0.225.105])
          by gmu812.rsint.net (Totemo SMTP Server) with SMTP ID 939;
          Tue, 15 Jul 2025 15:00:56 +0000 (GMT)
Received: from GMU501.rsint.net (10.0.225.33) by GMU452.rsint.net
 (10.0.225.105) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Tue, 15 Jul
 2025 17:00:54 +0200
Received: from GMU503.rsint.net (10.0.225.35) by GMU501.rsint.net
 (10.0.225.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10; Tue, 15 Jul
 2025 17:00:52 +0200
Received: from GMU503.rsint.net ([fe80::957e:76:e488:c60d]) by
 GMU503.rsint.net ([fe80::957e:76:e488:c60d%4]) with mapi id 15.02.1748.026;
 Tue, 15 Jul 2025 17:00:52 +0200
From: Guido Kiener <Guido.Kiener@rohde-schwarz.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Jian-Wei Wu
	<jian-wei_wu@keysight.com>, Dave Penkler <dpenkler@gmail.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Thread-Index: AQHb9ZlBYC5wtvPD90O3Bh9/J1/1xQ==
Date: Tue, 15 Jul 2025 15:00:52 +0000
Message-ID: <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
In-Reply-To: <20250715130811.725344645@linuxfoundation.org>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-IQAV: YES
thread-topic: RE: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB /ur/
X-rus_sensitivity: 10
msip_labels: MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Enabled=true; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SetDate=2025-07-15T17:00:53Z; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Method=Privileged; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Name=UNRESTRICTED; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SiteId=74bddbd9-705c-456e-aabd-99beb719a2b2; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ActionId=8b69e117-7756-4ef8-b52e-ebe0297deaf4; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ContentBits=1
X-GBS-PROC: 1T61JB9aiY9Dq0saU4Tr0capdehh5WAyLsfDc8wGAgUXT1eQdSWbYKQy25sWpD7pwZv5425DJfxdyDnG4u5OX1TenQ14n1N7wGxEZSekHI4tiDTIrBRACBUg1yu64Ttf
X-GBS-PROCJOB: thmaY5ol9LuMbKYhJRZwriu30Vi15LuxoLLzRMgp5fxEz3eaL9nwC/hzN8IpEe+O

R3JlZywNCg0KSSBnb3QgdGhlIHNlcmllcw0KW1BBVENIIDUuNCAwMTUvMTQ4XSBVU0I6IHVzYnRt
YzogRml4IHJlYWRpbmcgc3RhbGUgc3RhdHVzIGJ5dGUNCltQQVRDSCA1LjQgMDE2LzE0OF0gVVNC
OiB1c2J0bWM6IEFkZCBVU0JUTUNfSU9DVExfR0VUX1NUQg0KW1BBVENIIDUuMTAgMDIxLzIwOF0g
VVNCOiB1c2J0bWM6IEZpeCByZWFkaW5nIHN0YWxlIHN0YXR1cyBieXRlDQpbUEFUQ0ggNS4xMCAw
MjIvMjA4XSBVU0I6IHVzYnRtYzogQWRkIFVTQlRNQ19JT0NUTF9HRVRfU1RCDQoNCkFuZCBJIGFz
c3VtZSB3ZSBzaG91bGQgYWRkIHRoZSBvdGhlciB0d28gY29tbWl0cyBhcyB3ZWxsIHRvIGNvbXBs
ZXRlIHRoZSBzZXJpZXM6DQpVU0I6IHVzYnRtYzogQWRkIHNlcGFyYXRlIFVTQlRNQ19JT0NUTF9H
RVRfU1JRX1NUQiAgKGNvbW1pdCBkMWQ5ZGVmZGM2ZDU4MjExOWQyOWY1ZDg4ZjgxMGI3MmJiMTgz
N2ZhKQ0KVVNCOiB1c2J0bWM6IEJ1bXAgVVNCVE1DX0FQSV9WRVJTSU9OIHZhbHVlIChjb21taXQg
NjE0YjM4OGMzNDI2NTk0OGZiYjNjNTgwM2FkNzJhYTE4OThmMmY5MykNCg0KVGhlbiBVU0JUTUMg
QVBJIFZlcnNpb24gaXMgY29uc2lzdGVudCB3aXRoIGFkZGVkIGlvY3Rscy4NCg0KQERhdmU6IFdo
YXQgZG8geW91IHRoaW5rLiBDYW4geW91IGNoZWNrIHRoaXM/DQoNCkd1aWRvDQoNCj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogVHVlc2RheSwgSnVseSAxNSwgMjAyNSAzOjEy
IFBNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENjOiBHcmVnIEtyb2FoLUhhcnRt
YW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgcGF0Y2hlc0BsaXN0cy5saW51eC5kZXY7
DQo+IEppYW4tV2VpIFd1IDxqaWFuLXdlaV93dUBrZXlzaWdodC5jb20+OyBLaWVuZXIgR3VpZG8g
KDE0RFMxKQ0KPiA8R3VpZG8uS2llbmVyQHJvaGRlLXNjaHdhcnouY29tPjsgRGF2ZSBQZW5rbGVy
IDxkcGVua2xlckBnbWFpbC5jb20+Ow0KPiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+
DQo+IFN1YmplY3Q6ICpFWFQqIFtQQVRDSCA1LjEwIDAyMi8yMDhdIFVTQjogdXNidG1jOiBBZGQN
Cj4gVVNCVE1DX0lPQ1RMX0dFVF9TVEINCj4gDQo+IDUuMTAtc3RhYmxlIHJldmlldyBwYXRjaC4g
IElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBsZXQgbWUga25vdy4NCj4gDQo+
IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbTogRGF2ZSBQZW5rbGVyIDxkcGVua2xlckBn
bWFpbC5jb20+DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1pdCBjOTc4NGUyM2MxMDIwZTYzZDZkYmE1
ZTEwY2E4YmYzZDhiODVjMTljIF0NCj4gDQo+IFRoaXMgbmV3IGlvY3RsIHJlYWRzIHRoZSBzdGF0
dXMgYnl0ZSAoU1RCKSBmcm9tIHRoZSBkZXZpY2UgYW5kIHJldHVybnMgdGhlIFNUQg0KPiB1bm1v
ZGlmaWVkIHRvIHRoZSBhcHBsaWNhdGlvbi4gVGhlIHNycV9hc3NlcnRlZCBiaXQgaXMgbm90IHRh
a2VuIGludG8gYWNjb3VudCBhbmQNCj4gbm90IGNoYW5nZWQuDQo+IA0KPiBUaGlzIGlvY3RsIGlz
IHVzZWZ1bCB0byBzdXBwb3J0IG5vbiBVU0JUTUMtNDg4IGNvbXBsaWFudCBkZXZpY2VzLg0KPiAN
Cj4gVGVzdGVkLWJ5OiBKaWFuLVdlaSBXdSA8amlhbi13ZWlfd3VAa2V5c2lnaHQuY29tPg0KPiBS
ZXZpZXdlZC1ieTogR3VpZG8gS2llbmVyIDxndWlkby5raWVuZXJAcm9oZGUtc2Nod2Fyei5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IERhdmUgUGVua2xlciA8ZHBlbmtsZXJAZ21haWwuY29tPg0KPiBM
aW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjAxMjE1MTU1NjIxLjk1OTItMy1kcGVu
a2xlckBnbWFpbC5jb20NCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU3RhYmxlLWRlcC1vZjogYWNiM2RhYzI4MDVkICgi
dXNiOiB1c2J0bWM6IEZpeCByZWFkX3N0YiBmdW5jdGlvbiBhbmQgZ2V0X3N0Yg0KPiBpb2N0bCIp
DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gLS0t
DQo+ICBkcml2ZXJzL3VzYi9jbGFzcy91c2J0bWMuYyAgIHwgNiArKysrKysNCj4gIGluY2x1ZGUv
dWFwaS9saW51eC91c2IvdG1jLmggfCAyICsrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0
aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NsYXNzL3VzYnRtYy5jIGIv
ZHJpdmVycy91c2IvY2xhc3MvdXNidG1jLmMgaW5kZXgNCj4gYmZkOTlkNDYxZjgxMy4uMDkzMDQw
ZWE3ZTA2NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91c2IvY2xhc3MvdXNidG1jLmMNCj4gKysr
IGIvZHJpdmVycy91c2IvY2xhc3MvdXNidG1jLmMNCj4gQEAgLTIxNzMsNiArMjE3MywxMiBAQCBz
dGF0aWMgbG9uZyB1c2J0bWNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGUsIHVuc2lnbmVkIGludA0K
PiBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KPiAgCQkJZmlsZV9kYXRhLT5hdXRvX2Fib3J0ID0g
ISF0bXBfYnl0ZTsNCj4gIAkJYnJlYWs7DQo+IA0KPiArCWNhc2UgVVNCVE1DX0lPQ1RMX0dFVF9T
VEI6DQo+ICsJCXJldHZhbCA9IHVzYnRtY19nZXRfc3RiKGZpbGVfZGF0YSwgJnRtcF9ieXRlKTsN
Cj4gKwkJaWYgKHJldHZhbCA+IDApDQo+ICsJCQlyZXR2YWwgPSBwdXRfdXNlcih0bXBfYnl0ZSwg
KF9fdTggX191c2VyICopYXJnKTsNCj4gKwkJYnJlYWs7DQo+ICsNCj4gIAljYXNlIFVTQlRNQ19J
T0NUTF9DQU5DRUxfSU86DQo+ICAJCXJldHZhbCA9IHVzYnRtY19pb2N0bF9jYW5jZWxfaW8oZmls
ZV9kYXRhKTsNCj4gIAkJYnJlYWs7DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgv
dXNiL3RtYy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3VzYi90bWMuaCBpbmRleA0KPiBmZGQ0ZDg4
YTdiOTVkLi4xZTc4NzhmZTU5MWY0IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
dXNiL3RtYy5oDQo+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC91c2IvdG1jLmgNCj4gQEAgLTEw
Miw2ICsxMDIsOCBAQCBzdHJ1Y3QgdXNidG1jX21lc3NhZ2Ugew0KPiAgI2RlZmluZSBVU0JUTUNf
SU9DVExfTVNHX0lOX0FUVFIJX0lPUihVU0JUTUNfSU9DX05SLCAyNCwgX191OCkNCj4gICNkZWZp
bmUgVVNCVE1DX0lPQ1RMX0FVVE9fQUJPUlQJCV9JT1coVVNCVE1DX0lPQ19OUiwNCj4gMjUsIF9f
dTgpDQo+IA0KPiArI2RlZmluZSBVU0JUTUNfSU9DVExfR0VUX1NUQiAgICAgICAgICAgIF9JT1Io
VVNCVE1DX0lPQ19OUiwgMjYsIF9fdTgpDQo+ICsNCj4gIC8qIENhbmNlbCBhbmQgY2xlYW51cCBh
c3luY2hyb25vdXMgY2FsbHMgKi8NCj4gICNkZWZpbmUgVVNCVE1DX0lPQ1RMX0NBTkNFTF9JTwkJ
X0lPKFVTQlRNQ19JT0NfTlIsIDM1KQ0KPiAgI2RlZmluZSBVU0JUTUNfSU9DVExfQ0xFQU5VUF9J
TwkJX0lPKFVTQlRNQ19JT0NfTlIsIDM2KQ0KPiAtLQ0KPiAyLjM5LjUNCj4gDQoNCg==
