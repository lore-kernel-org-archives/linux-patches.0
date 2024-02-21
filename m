Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2103.outbound.protection.outlook.com [40.107.20.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4EB69962
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525073; cv=fail; b=rd0U7tgfZ2uE3TUPxrlNJAZXhgKVAQPiEWn7WuqM7Zwu2ezNEf9UTYCW4sjD4vuOwA3GlcT84oPo0P4yP66CCL9nqUSn/CCLXRR/6Z4xC2tXh2Gau31KjGfrIOZEz5BkaP2lxmkcGYuVyNe1iifKBreaGkc9m2L2ipBmTFDBA7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525073; c=relaxed/simple;
	bh=gcwNtnyFYy8ifZFFt8DOGtWXLSrGLaLRPgU0MJiOsWY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z8vB0q94S9N0kme2eLiMGW2yLETqIIX+Ev/Icu0pjDeIp6DIGzVkjRUpcG42e42lrR6pafvqOMzQqqdjshiiTjwwvamhLbYP3kXa5xu0ONbfhom9I11udhLknILh7mWAuAIsdbEOm2LO8mJ2ybH9JNH5uEOnv/LuxcPv8GeP8Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bang-olufsen.dk; spf=pass smtp.mailfrom=bang-olufsen.dk; dkim=pass (1024-bit key) header.d=bang-olufsen.dk header.i=@bang-olufsen.dk header.b=J8OzD/M8; arc=fail smtp.client-ip=40.107.20.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bang-olufsen.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bang-olufsen.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bang-olufsen.dk header.i=@bang-olufsen.dk header.b="J8OzD/M8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSznXf7hJmMFgaE/s8HP4IWd+b0G/zPD6j8rpk0UH4pPCZvxofKVUzvLoxdlQKaJM7h24Rvzz4uMwG0LFctx1UcH8z7n8pDCJNawiF25mM2o6LotLyesol13KKCe9iPf3Lm29sSl4shwUoN7Gz+cVwEdoP3qratAg3Rc7VR3o6vZNZ8mftEoNphsZW+RSv9QeXwFBSaJkIje+KBBkTj8RW8cZ9cmlj0vdZxe7KKydGeFZw3hW1PI/SRLONFmCKlDiTJkrRV2VBnFnqM9iqk71oV9j00GWxCtLfTdNuNxgkxBFoy4AnfcPMdXADQSoHJmPtBifuMEDZ6Qk0bqtyZIiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcwNtnyFYy8ifZFFt8DOGtWXLSrGLaLRPgU0MJiOsWY=;
 b=BZ08Hw/EgUj/sW/8SmNJ+7jdzjG4l6FQtAXtv93ozQWaeh0heFG6Ai7W0Bq8QaVbAu0Is1WnZ93ncJz/WhQEc7yCCBktY9bWQ+Z5zSQlgRcRvgMhv7w5W88mPMCLciof9TV54mO01Q2fShWaGRKm/XW6hdbjN5+o/GmK3VdPn/gvijZS/Oo9xT1Ur8ouuwVGD6fZ4ll5l6FI/wJwyzejEpbn0NRWYZmrergr840UbGnQ99ifTEyqI/o3nqc/PUktaWMeTVDuAjH591dXO1bwarZf/q7twdlrgFTucQQC1qx981eBmtU9Qrib6BpnekSvKhqFpZ4sBV4Mhxk3OuSIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcwNtnyFYy8ifZFFt8DOGtWXLSrGLaLRPgU0MJiOsWY=;
 b=J8OzD/M8xblb2a2Mgr4XmuKQnk7c0teipnL43XXSYTGgmOJnbcCdil3kE4JxBCL4nBjj4tQcx0Rqt9sYxXP0N7P1NInJuk13g0X1RMOv/kpHPtAF/yWrTNv8doSjt8bY8rhoCoAh2cGmc5QTBAip/d0dA4kl5kK+ePt4ahq39zU=
Received: from AS8PR03MB8805.eurprd03.prod.outlook.com (2603:10a6:20b:53e::20)
 by PA4PR03MB7023.eurprd03.prod.outlook.com (2603:10a6:102:ec::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Wed, 21 Feb
 2024 14:17:48 +0000
Received: from AS8PR03MB8805.eurprd03.prod.outlook.com
 ([fe80::3c77:8de8:801c:42a7]) by AS8PR03MB8805.eurprd03.prod.outlook.com
 ([fe80::3c77:8de8:801c:42a7%4]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 14:17:48 +0000
From: =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Andrejs Cainikovs
	<andrejs.cainikovs@toradex.com>, Kalle Valo <kvalo@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 5.15 427/476] mwifiex: Select firmware based on strapping
Thread-Topic: [PATCH 5.15 427/476] mwifiex: Select firmware based on strapping
Thread-Index: AQHaZMzkDtW59l3pWkGoUF/hexPctrEU1+QA
Date: Wed, 21 Feb 2024 14:17:48 +0000
Message-ID: <mylyn55f4ao6ri542viscz6sybvhlsjcfzgg5amroj5ggv7abf@gqstvogzkyce>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130023.815110111@linuxfoundation.org>
In-Reply-To: <20240221130023.815110111@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB8805:EE_|PA4PR03MB7023:EE_
x-ms-office365-filtering-correlation-id: 5c755a19-0c76-4343-f60e-08dc32e7e1bb
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Cu/8c8TKk5dYX/PIpZLXysUsQgFWE6nobz8r/FMEzql5grJnUYIXA5gucMtolEuz71ouY8t36aBttpyO8EvkxNlpgj4Zk+mSiv9PsIto4Y9+AfYjkx3qZCkucVerdI9PiQUxHOlhkjfJyQXB+uhR+97MLlZSGAbV1/FTo6xkMEAGHDUunL9AT3OFPpykVgS6tZoCwUBEcNJgTAX8TUWwmaO4a8ZT/AuY08AQu6+K1bEFzwt2NZPU7xX9pd34/3LM9s+aI+UeIl87RuDmAwelLFOt8Vkqz9hJfJyOFp+KXPWgWYPe+V7hwL1meWlfHqX+raJogtiw/B6iFo+gMSpI85S7QYOgTRm6v2HlvwZJxtsqL8BrmBUmCeiucynKzl+JUpGm9uxgVut5m9aGRh5Dzc7wF4A8oKMnAQ9OWuJGQaico9GQCQ6touKe8QcvZn+E7LxLN0WQx8mUAQGLcQjzsaFikLHIeQyV510FtwEiGFMIno068Z/7HNcCMWqr8kYttzOwp6rycIswv06Y4WQspq06fq9GClFP9YCjNzu0cjO3IgzbniiKctTtPRjlHLxIl4ha6Ckc1KZlihdn6XX5HX4imqM1zPvRm30u8JL/q5LfuhccPD8jePTxuk5HKicc
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8805.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009)(27256008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUVUQWwrMDBiNXZ0Y0J4ZU1oN004WTFJRTBEK1Q5WU5LNlAyYXJiSHNBcXM5?=
 =?utf-8?B?VHRqTDg0bVg1SkZIU0FOVDNnamp5V0RTS3pHbFNuVHA5YWxBNUxVeGUzZlF5?=
 =?utf-8?B?MzlSVTlZck94SVdzbUpacy9LajNwdExhejNkelpvV0JUMFdZcFlKazFQTVRy?=
 =?utf-8?B?YTJLMVNUdnJwSUFqRlN3Zk9QOHc5MXNSbUx4Uk9nQkViWVlaUXhham0xSUlK?=
 =?utf-8?B?N0tRSGF3cWx5VUpBOHJwUm83MjAvUlNOY0pzM0R4VXhyTDREK2xSdVpGbk5C?=
 =?utf-8?B?aDA0K2twcVdJQjQ1WlZUS2hkOW8wczVoM0Q3dldMMWlhWm9CTEcxUTk5d0Uv?=
 =?utf-8?B?eWFPSUYvYk50eThQQTF5YTVmdzU2Snh4WG5ISlNYa1lLQnh2RUxkUGZMbWdz?=
 =?utf-8?B?T3QvZEZPNDRKQU5HZFFmWDBQVUJ4ajlMV1BJVktNN2tjZ1VIQ1ZISUlFVmYz?=
 =?utf-8?B?Z0Q5Tm1aRVVPYzZ1N2M3cW81S2lXQkdtUk0wQThFWDBQcVJCZ0VFL1B5d0lQ?=
 =?utf-8?B?Yko0dUlTSVhZV0lkcGo3NlEvUENEa0J2SC9KWGVuUUVCcGtNdm9qVnhhTUVN?=
 =?utf-8?B?VGRnV0s0OUQwUnM5b1lSOUlnd0xvRld1Tkl6bU5MTnJ6c2c5UEhQKzJQRnJG?=
 =?utf-8?B?Ui9wL0kvMFYvdlJzWkNvTjJGT0ZPZE1FczFVSUhkYlBwRkpnRHZxMTlsdy8w?=
 =?utf-8?B?RjhLZkhIdGxWTDI0SFpleWRMQ0ZvME14LzVXcktralhtTkIzWk0zamxBNDdO?=
 =?utf-8?B?UWc0eXNJQkNmb3ZKYkNMcHZpQ3MvZ2lzTy9Gc1ZnM0pXUzJsR28yRzBhZG1u?=
 =?utf-8?B?YVlDd25OaDA2TlozRVoxSGcxd3AvblFlcU5nUXRwZ1NDU1hXY01tS1NjR2JG?=
 =?utf-8?B?bDRzdXFqbndCWGtSdVhrZFROYUVwMTBiN2p1S01lTmF0WFZmMWUzYlJnUnY4?=
 =?utf-8?B?b3NRNWQvakVNWlJ2b095dmVHYnpMQ0Z4eUZRRHprM1g3Skx0TGRQczJZZTIr?=
 =?utf-8?B?RkFMcnQxbjMvRm1zTlE0dFJnVFdRU2lrdUFZb1BsNEh2SXgrYmt4SDNRT2FT?=
 =?utf-8?B?WWNPaXlxbTQra1BQTEVQZmJKek9qNHk0YUYvTWpacVdlMnB6WjFjL3VJYkJq?=
 =?utf-8?B?dXZhZllRcjQ3UkpESjMvNHY1NlRQbE5TKzNzdmdON05pcndVa3FwOC9KM3pi?=
 =?utf-8?B?N3NONXVlMHpzQTFEQ3FDUmRZNklLb0QxdlNKMURIeDFrUjlFeXo4bnNITENo?=
 =?utf-8?B?YzhTVzMwKzVTN3A3czYxemNWT1NBdXErSU80S1hDcjhZSDlWZ1BLTW1nRWlM?=
 =?utf-8?B?eit1U2U3b2RsUnNRRmlPdHlFRStvMTRuVGJVV09XWmwwRGhsV3pIU28zdUR0?=
 =?utf-8?B?VDVzRm5wV0dpeTVDdjA3eGU3bk1QUDd4clhzVi8yY1pySitkSTN5ZkJ5NDlH?=
 =?utf-8?B?UHp6SUNIM2ZLUmRYamMyUzFJQXdpK0o2bWQ5VDhHWEdpQnhjTVpHVGQwaWN4?=
 =?utf-8?B?MEMvT1lHcVZ6K3ZmOXgwY1YyWElvMjlWK042SVNyVVBwSGNKOTNKQTluam9D?=
 =?utf-8?B?NnYyVUt6UWxGeDNXc29jNC9rNUNWV0cwcjduRlYwVEdXdnJUclcyUzhrMlNX?=
 =?utf-8?B?YTJjSW1TUzBPNGdLdXNQMFRnR2xRQ0Y3WmZGNElRTUo2Z0RtQ1NVdTg1YUhw?=
 =?utf-8?B?OTcvaldKWW1GTDUxRWFDNUN1OEg3YXd1NFl6SUtCL0s0UmVOcFE4VC9pUUky?=
 =?utf-8?B?L3AvZ3ZRVTRON2VGRGQ5TXp2cG1MMkJwazFrNkRjdUVmV3JhYllGOUlDeWtz?=
 =?utf-8?B?VCsyVDFMcTFBNFBQT3hRV0RldUFzQ3F6NGFmMUdpQ2didGdXSXdQWTZPSWx2?=
 =?utf-8?B?VnN0VWl0SWYvOUs0dzQ3V0gyc2tuSktnZ1dFcUlsRHREUTRmQ2drVitwZ0pp?=
 =?utf-8?B?SmRqakkwMjZjSS85VHVnbFRoNUpKOURRVTZpS3dnd2t1aVdkeVRrd1NtTHBa?=
 =?utf-8?B?RW5VTkd2SzFZbXFzTHVUZC9DUUJkSE5Bcjh5V0cwcmo1dTVMNGE3RHE1ZU9N?=
 =?utf-8?B?V1ArTksxcDZQbGlpSHkrby9EYUNpZlordW9NVWgyYUdlKzBLSnNDZFdxb2w2?=
 =?utf-8?Q?ZbWv2B9N0UVP/uRL27lsyjsE8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40D080C1BC463A4C89A6B8F9283A7757@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR03MB8805.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c755a19-0c76-4343-f60e-08dc32e7e1bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 14:17:48.5380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8YUGmgg9IGTIUGFkL0sm7olwN6qTGdEpt0T8h0yM1UX7gUNtSzijkMCfnJfBL+e/MUSV5cVDGcHKIZ7Qiz4ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7023

SGkgR3JlZywNCg0KT24gV2VkLCBGZWIgMjEsIDIwMjQgYXQgMDI6MDc6NThQTSArMDEwMCwgR3Jl
ZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA1LjE1LXN0YWJsZSByZXZpZXcgcGF0Y2guICBJZiBh
bnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lIGtub3cuDQoNCi0gW1BBVENI
IDUuMTUgNDI3LzQ3Nl0gbXdpZmlleDogU2VsZWN0IGZpcm13YXJlIGJhc2VkIG9uIHN0cmFwcGlu
ZyBHcmVnIEtyb2FoLUhhcnRtYW4NCi0gW1BBVENIIDUuMTUgNDI4LzQ3Nl0gd2lmaTogbXdpZmll
eDogU3VwcG9ydCBTRDg5NzggY2hpcHNldCBHcmVnIEtyb2FoLUhhcnRtYW4NCg0KQm90aCBvZiB0
aGUgYWJvdmUgYXJlIG1hcmtlZCBhcyBzdGFibGUtZGVwcyBvZiB0aGlzIG9uZToNCg0KLSBbUEFU
Q0ggNS4xNSA0MjkvNDc2XSB3aWZpOiBtd2lmaWV4OiBhZGQgZXh0cmEgZGVsYXkgZm9yIGZpcm13
YXJlIHJlYWR5IEdyZWcgS3JvYWgtSGFydG1hbg0KDQpidXQgdGhleSBhcmUgbm90IGF0IGFsbCBy
ZWxldmFudCwgc28gSSB0aGluayBwYXRjaGVzIDQyNyBhbmQgNDI4IHNob3VsZA0KYmUgZHJvcHBl
ZC4gQnV0IHBhdGNoIDQyOSBpcyBPSyBmb3Igc3RhYmxlIGFzIGxvbmcgYXMgNDMxIGlzIGluY2x1
ZGVkOg0KDQotIFtQQVRDSCA1LjE1IDQzMS80NzZdIHdpZmk6IG13aWZpZXg6IGZpeCB1bmluaXRp
YWxpemVkIGZpcm13YXJlX3N0YXQgR3JlZyBLcm9haC1IYXJ0bWFuDQoNCktpbmQgcmVnYXJkcywN
CkFsdmluDQoNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbTogQW5kcmVqcyBD
YWluaWtvdnMgPGFuZHJlanMuY2Fpbmlrb3ZzQHRvcmFkZXguY29tPg0KPiANCj4gWyBVcHN0cmVh
bSBjb21taXQgMjU1Y2EyOGE2NTlkM2NmYjA2OWY3M2M3NjQ0ODUzZWQ5M2FlY2RiMCBdDQo+IA0K
PiBTb21lIFdpRmkvQmx1ZXRvb3RoIG1vZHVsZXMgbWlnaHQgaGF2ZSBkaWZmZXJlbnQgaG9zdCBj
b25uZWN0aW9uDQo+IG9wdGlvbnMsIGFsbG93aW5nIHRvIGVpdGhlciB1c2UgU0RJTyBmb3IgYm90
aCBXaUZpIGFuZCBCbHVldG9vdGgsDQo+IG9yIFNESU8gZm9yIFdpRmkgYW5kIFVBUlQgZm9yIEJs
dWV0b290aC4gSXQgaXMgcG9zc2libGUgdG8gZGV0ZWN0DQo+IHdoZXRoZXIgYSBtb2R1bGUgaGFz
IFNESU8tU0RJTyBvciBTRElPLVVBUlQgY29ubmVjdGlvbiBieSByZWFkaW5nDQo+IGl0cyBob3N0
IHN0cmFwIHJlZ2lzdGVyLg0KPiANCj4gVGhpcyBjaGFuZ2UgaW50cm9kdWNlcyBhIHdheSB0byBh
dXRvbWF0aWNhbGx5IHNlbGVjdCBhcHByb3ByaWF0ZQ0KPiBmaXJtd2FyZSBkZXBlbmRpbmcgb2Yg
dGhlIGNvbm5lY3Rpb24gbWV0aG9kLCBhbmQgcmVtb3ZlcyBhIG5lZWQNCj4gb2Ygc3ltbGlua2lu
ZyBvciBvdmVyd3JpdGluZyB0aGUgb3JpZ2luYWwgZmlybXdhcmUgZmlsZSB3aXRoIGENCj4gcmVx
dWlyZWQgb25lLg0KPiANCj4gSG9zdCBzdHJhcCByZWdpc3RlciB1c2VkIGluIHRoaXMgY29tbWl0
IGNvbWVzIGZyb20gdGhlIE5YUCBkcml2ZXIgWzFdDQo+IGhvc3RlZCBhdCBDb2RlIEF1cm9yYS4N
Cj4gDQo+IFsxXSBodHRwczovL3NvdXJjZS5jb2RlYXVyb3JhLm9yZy9leHRlcm5hbC9pbXgvbGlu
dXgtaW14L3RyZWUvZHJpdmVycy9uZXQvd2lyZWxlc3MvbnhwL214bV93aWZpZXgvd2xhbl9zcmMv
bWxpbnV4L21vYWxfc2Rpb19tbWMuYz9oPXJlbF9pbXhfNS40LjcwXzIuMy4yJmlkPTY4OGI2N2Iy
YzcyMjBiMDE1MjFmZmU1NjBkYTdlZWUzMzA0MmM3YmQjbjEyNzQNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEFuZHJlanMgQ2Fpbmlrb3ZzIDxhbmRyZWpzLmNhaW5pa292c0B0b3JhZGV4LmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4gU2ln
bmVkLW9mZi1ieTogS2FsbGUgVmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz4NCj4gTGluazogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDQyMjA5MDMxMy4xMjU4NTctMi1hbmRyZWpzLmNhaW5p
a292c0B0b3JhZGV4LmNvbQ0KPiBTdGFibGUtZGVwLW9mOiAxYzVkNDYzYzA3NzAgKCJ3aWZpOiBt
d2lmaWV4OiBhZGQgZXh0cmEgZGVsYXkgZm9yIGZpcm13YXJlIHJlYWR5IikNCj4gU2lnbmVkLW9m
Zi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiAtLS0NCg0KWy4uLl0=
