Received: from mail02.rohde-schwarz.com (mail02.rohde-schwarz.com [80.246.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C925028DB78
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.246.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752659954; cv=none; b=KEE/2atk/yij5IKg8j7XjHlUoOuYQOAOMkIBXqisGH7pg3TOZU0j5MQJ+/Zk/CVP/D30tw4JRyT1/+dkC4fQHtHamkZ4dxkWVeiDfgRxpAjlLMgnERrOB93AK9XQ7AcCxP2BEZqzzMCFAXIgUjJz2w73nefXT/ORBcRFWueTRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752659954; c=relaxed/simple;
	bh=S6e1RGFN7dzYH34T2XBmoV0KiK3EgqUAl+mp9sU6Xck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ltd3GdKOPCP7YUAeM4zcMV3DIOKcMhS//sVYIUiS9VzQR4kWas9pbNjMfJHoFWK8omPFwbbqNwSIYSLDBt4uBlGOG/rL97vrlla6HxkPKxsUSHyJdzhL3Mo15HexTmHiTKwnizy5tP9PiZPk8QIugWmKQEyjquePmdWfi1nHvcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com; spf=pass smtp.mailfrom=rohde-schwarz.com; arc=none smtp.client-ip=80.246.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rohde-schwarz.com
Received: from securemail-mu-h4.rohde-schwarz.com (10.0.19.146) by
 mail02.rohde-schwarz.com (172.21.64.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 11:59:11 +0200
Received: from GMU451.rsint.net ([10.0.225.106])
          by gmu812.rsint.net (Totemo SMTP Server) with SMTP ID 945;
          Wed, 16 Jul 2025 09:59:10 +0000 (GMT)
Received: from GMU506.rsint.net (10.0.225.38) by GMU451.rsint.net
 (10.0.225.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Wed, 16 Jul
 2025 11:59:10 +0200
Received: from GMU503.rsint.net (10.0.225.35) by GMU506.rsint.net
 (10.0.225.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Wed, 16 Jul
 2025 11:59:08 +0200
Received: from GMU503.rsint.net ([fe80::957e:76:e488:c60d]) by
 GMU503.rsint.net ([fe80::957e:76:e488:c60d%4]) with mapi id 15.02.1748.026;
 Wed, 16 Jul 2025 11:59:08 +0200
From: Guido Kiener <Guido.Kiener@rohde-schwarz.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jian-Wei Wu
	<jian-wei_wu@keysight.com>, Dave Penkler <dpenkler@gmail.com>, Sasha Levin
	<sashal@kernel.org>
Subject: RE: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Thread-Index: AQHb9jF7cp80q3sgfkWdVNz+k0hWE7Q0Yp8w
Date: Wed, 16 Jul 2025 09:59:08 +0000
Message-ID: <a35a4e1b6cd6484d893b71da487dd8b0@rohde-schwarz.com>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
 <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
 <2025071536-rummage-unlit-70d4@gregkh>
 <faf41397ab4b4344af294bbb8c2e6030@rohde-schwarz.com>
In-Reply-To: <faf41397ab4b4344af294bbb8c2e6030@rohde-schwarz.com>
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
msip_labels: MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Enabled=true; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SetDate=2025-07-16T11:59:09Z; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Method=Privileged; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Name=UNRESTRICTED; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SiteId=74bddbd9-705c-456e-aabd-99beb719a2b2; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ActionId=8b69e117-7756-4ef8-b52e-ebe0297deaf4; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ContentBits=1
X-GBS-PROC: Tn4DSgVsKV6PS+va455PCJVXnKqXXT3mLDNQ8wwtU3idl2DDDPkxbMlQm0Ms/qIqMzWlLXt01x8LsuOuxYx66SdfLxY7Yzl8gcmU/wcs0+6BQCP5V0LQ2vky939bqCDB
X-GBS-PROCJOB: ECnX0hWnvH9dL1EAl2+kxJqENmdgbFXUy5PIlDPculHH7N1Efe/xpSpRPz42hQhr

VXBkYXRlIHNlZSBiZWxvdzoNCg0KPiA+IEkgZ290IHRoZSBzZXJpZXMNCj4gPiBbUEFUQ0ggNS40
IDAxNS8xNDhdIFVTQjogdXNidG1jOiBGaXggcmVhZGluZyBzdGFsZSBzdGF0dXMgYnl0ZSANCj4g
PiBbUEFUQ0gNCj4gPiA1LjQgMDE2LzE0OF0gVVNCOiB1c2J0bWM6IEFkZCBVU0JUTUNfSU9DVExf
R0VUX1NUQg0KPiANCj4gT2RkLCB0aGF0IHNlY29uZCBvbmUgc2hvdWRuJ3QgYmUgdGhlcmUsIHJp
Z2h0Pw0KDQpZZXMsIHRoZXJlIGlzIG5vIG5lZWQgdG8gYWRkIGJvdGggcGF0Y2hlcy4NCjUuNC4y
OTUgaXMgb2sgYW5kIHVzZXMgb2xkIGltcGxlbWVudGF0aW9uIG9mIHVzYnRtYzQ4OF9pb2N0bF9y
ZWFkX3N0YiBJIGFzc3VtZSwgdGhlcmUgaXMgbm8gbmVlZCB0byBhZGQgW1BBVENIIDUuNCAwMTUv
MTQ4XSBhbmQgW1BBVENIIDUuNCAwMTYvMTQ4XQ0KIA0KPiA+IFtQQVRDSCA1LjEwIDAyMS8yMDhd
IFVTQjogdXNidG1jOiBGaXggcmVhZGluZyBzdGFsZSBzdGF0dXMgYnl0ZSANCj4gPiBbUEFUQ0gN
Cj4gPiA1LjEwIDAyMi8yMDhdIFVTQjogdXNidG1jOiBBZGQgVVNCVE1DX0lPQ1RMX0dFVF9TVEIN
Cj4gDQo+IFNhbWUgaGVyZT8NCg0KWWVzLCBzYW1lIGhlcmUuDQogDQo+ID4gQW5kIEkgYXNzdW1l
IHdlIHNob3VsZCBhZGQgdGhlIG90aGVyIHR3byBjb21taXRzIGFzIHdlbGwgdG8gY29tcGxldGUg
dGhlIHNlcmllczoNCj4gPiBVU0I6IHVzYnRtYzogQWRkIHNlcGFyYXRlIFVTQlRNQ19JT0NUTF9H
RVRfU1JRX1NUQiAgKGNvbW1pdA0KPiA+IGQxZDlkZWZkYzZkNTgyMTE5ZDI5ZjVkODhmODEwYjcy
YmIxODM3ZmEpDQo+ID4gVVNCOiB1c2J0bWM6IEJ1bXAgVVNCVE1DX0FQSV9WRVJTSU9OIHZhbHVl
IChjb21taXQNCj4gPiA2MTRiMzg4YzM0MjY1OTQ4ZmJiM2M1ODAzYWQ3MmFhMTg5OGYyZjkzKQ0K
PiANCj4gTm9wZSwgSSBkaWRuJ3QsIG1heWJlIEkgc2hvdWxkIGp1c3QgZHJvcCBib3RoIG9mIHRo
ZSBhYm92ZSBvbmVzLCBhcyBpdCANCj4gZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2UgdG8gaGF2ZSBv
bmx5IHRoZSBvbmUsIHJpZ2h0Pw0KDQpUaGUgcGF0Y2ggIlVTQjogdXNidG1jOiBGaXggcmVhZGlu
ZyBzdGFsZSBzdGF0dXMgYnl0ZSIgaXMgbm90IHJlcXVpcmVkIGluIDUuNCBhbmQgNS4xMCwgdG9v
Lg0KVGhlIG5ldyBiZWhhdmlvciB0byByZWFkIHRoZSBzdGF0dXMgYnl0ZSBpbiBvbGQgYW5kIG5l
dyBtYW5uZXIgd2FzIGludHJvZHVjZWQgaW4gNS4xMi4NClNvcnJ5LCBJIGNhbiBub3QgdmVyaWZ5
IG15IGN1cnJlbnQgZmluZGluZ3MsIHNpbmNlIEkgZG8gbm90IGhhdmUgdGVzdCBzeXN0ZW1zIGZv
ciBpdC4NClRvIGJlIHN1cmUgd2Ugc2hvdWxkIHdhaXQgZm9yIGEgY29tbWVudCBmcm9tIERhdmUu
IEhlIGRpZCB0aGUgbGFzdCBwYXRjaGVzLg0KDQpVcGRhdGU6DQpOb3cgSSBzZWUgYSBwcm9ibGVt
IGluIHRoZSBwYXRjaC01LjQuMjk1OiANCg0KQEAgLTU1Niw2ICs1NjAsOCBAQCBzdGF0aWMgaW50
IHVzYnRtYzQ4OF9pb2N0bF9yZWFkX3N0YihzdHJ1Y3QgdXNidG1jX2ZpbGVfZGF0YSAqZmlsZV9k
YXRhLA0KIAlydiA9IHB1dF91c2VyKHN0YiwgKF9fdTggX191c2VyICopYXJnKTsNCiAJZGV2X2Ri
ZyhkZXYsICJzdGI6MHglMDJ4IHJlY2VpdmVkICVkXG4iLCAodW5zaWduZWQgaW50KXN0YiwgcnYp
Ow0KIA0KKwlydiA9IDA7DQorDQogIGV4aXQ6DQogCS8qIGJ1bXAgaW50ZXJydXB0IGJUYWcgKi8N
CiAJZGF0YS0+aWluX2JUYWcgKz0gMTsNCg0KV2Ugc2hvdWxkIG5vdCBzZXQgcmV2ID0gMCwgc2lu
Y2UgDQoNCgljYXNlIFVTQlRNQzQ4OF9JT0NUTF9SRUFEX1NUQjoNCgkJcmV0dmFsID0gdXNidG1j
NDg4X2lvY3RsX3JlYWRfc3RiKGZpbGVfZGF0YSwNCgkJCQkJCSAgKHZvaWQgX191c2VyICopYXJn
KTsNCg0Kd2lsbCByZXR1cm4gMCBpbnN0ZWFkIG9mIDEgKHRoZSBhbW91bnQgb2YgcmV0dXJuZWQg
Ynl0ZXMpLiANCg0KU2FtZSBpc3N1ZSBpbiBwYXRjaC01LjEwLjIzOS4NCg0KDQpHdWlkbw0KDQo=
