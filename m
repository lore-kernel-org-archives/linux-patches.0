Received: from mail02.rohde-schwarz.com (mail02.rohde-schwarz.com [80.246.32.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF99828B4EA
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.246.32.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657107; cv=none; b=Kih46+dZJM36KgFxJhUSzWsjt9eU4FytdXn9ZsAcAeisPvV8ADlZzC0MRfKGgZAkjvExBglCukzq1ymPeRUez1SYUCcLoyK/lIGLGdM0c7AE4mKiI22ZPFtVLr6cSfYjG2m13NEv2rhTda0Sd7Wn4kJ6WO0IiCoJxE9O4lIUe2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657107; c=relaxed/simple;
	bh=5HI0/SR2ct7DhxAJNhXW4fVtVa/dZvvC/8Q09B6LLvw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GL4pCPNiUeG7tTcC/pc+31v32hKz9IWImsZDc/UKmw9XF7nYUiDaV4GA02bQauremLRgQLwb3hxPDRPuCb7lNico/DxziSikbzFY/TnsgLnsBMqfbxle5WWszoyeiT7bvT8lz5JsMSgVDtTgjQ9f5LAonjKJrYxCVXkzbMpji2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com; spf=pass smtp.mailfrom=rohde-schwarz.com; arc=none smtp.client-ip=80.246.32.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rohde-schwarz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rohde-schwarz.com
Received: from securemail-mu-h4.rohde-schwarz.com (10.0.19.146) by
 mail02.rohde-schwarz.com (172.21.64.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 11:11:44 +0200
Received: from GMU452.rsint.net ([10.0.225.105])
          by gmu812.rsint.net (Totemo SMTP Server) with SMTP ID 942;
          Wed, 16 Jul 2025 09:11:43 +0000 (GMT)
Received: from GMU505.rsint.net (10.0.225.37) by GMU452.rsint.net
 (10.0.225.105) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Wed, 16 Jul
 2025 11:11:42 +0200
Received: from GMU503.rsint.net (10.0.225.35) by GMU505.rsint.net
 (10.0.225.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Wed, 16 Jul
 2025 11:10:32 +0200
Received: from GMU503.rsint.net ([fe80::957e:76:e488:c60d]) by
 GMU503.rsint.net ([fe80::957e:76:e488:c60d%4]) with mapi id 15.02.1748.026;
 Wed, 16 Jul 2025 11:10:32 +0200
From: Guido Kiener <Guido.Kiener@rohde-schwarz.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jian-Wei Wu
	<jian-wei_wu@keysight.com>, Dave Penkler <dpenkler@gmail.com>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Thread-Index: AQHb9jF7cp80q3sgfkWdVNz+k0hWEw==
Date: Wed, 16 Jul 2025 09:10:32 +0000
Message-ID: <faf41397ab4b4344af294bbb8c2e6030@rohde-schwarz.com>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
 <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
 <2025071536-rummage-unlit-70d4@gregkh>
In-Reply-To: <2025071536-rummage-unlit-70d4@gregkh>
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
thread-topic: Re: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB /ur/
X-rus_sensitivity: 10
msip_labels: MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Enabled=true; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SetDate=2025-07-16T11:11:37Z; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Method=Privileged; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_Name=UNRESTRICTED; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_SiteId=74bddbd9-705c-456e-aabd-99beb719a2b2; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ActionId=8b69e117-7756-4ef8-b52e-ebe0297deaf4; MSIP_Label_9764cdcd-3664-4d05-9615-7cbf65a4f0a8_ContentBits=1
X-GBS-PROC: dev/X1L2Ka5BabOiD2atpGbkfiq6x+M60+HqxdkZsnFELb/eJkgMtf4+C5j9We2xQy93m1E7mRJwq0q8VUutcKBjTiSSplpCliPbvnbCGtGAwfPi+teu0+hpxFT4hR4T
X-GBS-PROCJOB: ESYvPTQMRamQCd/HYKnKPiuqyCcZxolSlegcbYYZtyWJCN/tg/zKnJnEEijQ41CD

PiA+IEkgZ290IHRoZSBzZXJpZXMNCj4gPiBbUEFUQ0ggNS40IDAxNS8xNDhdIFVTQjogdXNidG1j
OiBGaXggcmVhZGluZyBzdGFsZSBzdGF0dXMgYnl0ZSBbUEFUQ0gNCj4gPiA1LjQgMDE2LzE0OF0g
VVNCOiB1c2J0bWM6IEFkZCBVU0JUTUNfSU9DVExfR0VUX1NUQg0KPiANCj4gT2RkLCB0aGF0IHNl
Y29uZCBvbmUgc2hvdWRuJ3QgYmUgdGhlcmUsIHJpZ2h0Pw0KDQpZZXMsIHRoZXJlIGlzIG5vIG5l
ZWQgdG8gYWRkIGJvdGggcGF0Y2hlcy4NCjUuNC4yOTUgaXMgb2sgYW5kIHVzZXMgb2xkIGltcGxl
bWVudGF0aW9uIG9mIHVzYnRtYzQ4OF9pb2N0bF9yZWFkX3N0Yg0KSSBhc3N1bWUsIHRoZXJlIGlz
IG5vIG5lZWQgdG8gYWRkIFtQQVRDSCA1LjQgMDE1LzE0OF0gYW5kIFtQQVRDSCA1LjQgMDE2LzE0
OF0NCiANCj4gPiBbUEFUQ0ggNS4xMCAwMjEvMjA4XSBVU0I6IHVzYnRtYzogRml4IHJlYWRpbmcg
c3RhbGUgc3RhdHVzIGJ5dGUgW1BBVENIDQo+ID4gNS4xMCAwMjIvMjA4XSBVU0I6IHVzYnRtYzog
QWRkIFVTQlRNQ19JT0NUTF9HRVRfU1RCDQo+IA0KPiBTYW1lIGhlcmU/DQoNClllcywgc2FtZSBo
ZXJlLg0KIA0KPiA+IEFuZCBJIGFzc3VtZSB3ZSBzaG91bGQgYWRkIHRoZSBvdGhlciB0d28gY29t
bWl0cyBhcyB3ZWxsIHRvIGNvbXBsZXRlIHRoZSBzZXJpZXM6DQo+ID4gVVNCOiB1c2J0bWM6IEFk
ZCBzZXBhcmF0ZSBVU0JUTUNfSU9DVExfR0VUX1NSUV9TVEIgIChjb21taXQNCj4gPiBkMWQ5ZGVm
ZGM2ZDU4MjExOWQyOWY1ZDg4ZjgxMGI3MmJiMTgzN2ZhKQ0KPiA+IFVTQjogdXNidG1jOiBCdW1w
IFVTQlRNQ19BUElfVkVSU0lPTiB2YWx1ZSAoY29tbWl0DQo+ID4gNjE0YjM4OGMzNDI2NTk0OGZi
YjNjNTgwM2FkNzJhYTE4OThmMmY5MykNCj4gDQo+IE5vcGUsIEkgZGlkbid0LCBtYXliZSBJIHNo
b3VsZCBqdXN0IGRyb3AgYm90aCBvZiB0aGUgYWJvdmUgb25lcywgYXMgaXQgZG9lc24ndCBtYWtl
DQo+IG11Y2ggc2Vuc2UgdG8gaGF2ZSBvbmx5IHRoZSBvbmUsIHJpZ2h0Pw0KDQpUaGUgcGF0Y2gg
IlVTQjogdXNidG1jOiBGaXggcmVhZGluZyBzdGFsZSBzdGF0dXMgYnl0ZSIgaXMgbm90IHJlcXVp
cmVkIGluIDUuNCBhbmQgNS4xMCwgdG9vLg0KVGhlIG5ldyBiZWhhdmlvciB0byByZWFkIHRoZSBz
dGF0dXMgYnl0ZSBpbiBvbGQgYW5kIG5ldyBtYW5uZXIgd2FzIGludHJvZHVjZWQgaW4gNS4xMi4N
ClNvcnJ5LCBJIGNhbiBub3QgdmVyaWZ5IG15IGN1cnJlbnQgZmluZGluZ3MsIHNpbmNlIEkgZG8g
bm90IGhhdmUgdGVzdCBzeXN0ZW1zIGZvciBpdC4NClRvIGJlIHN1cmUgd2Ugc2hvdWxkIHdhaXQg
Zm9yIGEgY29tbWVudCBmcm9tIERhdmUuIEhlIGRpZCB0aGUgbGFzdCBwYXRjaGVzLg0KDQpHdWlk
bw0K
