Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2102.outbound.protection.outlook.com [40.107.104.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5A67C0BD
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525208; cv=fail; b=Ia/HRcryVqFyTs0enHiRMRGdIdSI+wfjf1sTMRnjMCoCH3TCqQX/Lv5aaQ6HjU8dU4fnGHz3G5DKoJpfAGTRbRrX4JDl9/w0OcfMBZeGRfnNF5Yjt5oOJ39fUxfoMQeq7dMkQugEaaCnvNUx+abdvSx5h7YvUwPQpeFYfpV819o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525208; c=relaxed/simple;
	bh=8szoK600fZtjRb3YcW7L9hS7FftjSfL/qf2KYD67XJ8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZTp3/uumQpMBQ3Ozi6IHo0KJj4euIyDrQuX1wrX/HTTj65r7rgznmVQQtegbjlJr8h8J4F/Fum23exMeRXTUvHQHynofp1MRAO5cn5vcUyTBSwKb6g6LjlzrgerynsGd8HLrt3g58/FRQ+V3pu0yTNWppxEx7O7gutZS6YF3Myc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bang-olufsen.dk; spf=pass smtp.mailfrom=bang-olufsen.dk; dkim=pass (1024-bit key) header.d=bang-olufsen.dk header.i=@bang-olufsen.dk header.b=qK2LIYnz; arc=fail smtp.client-ip=40.107.104.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bang-olufsen.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bang-olufsen.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=bang-olufsen.dk header.i=@bang-olufsen.dk header.b="qK2LIYnz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUFyHAb27qd5f+hezGPVPio/vxts3aID+SeqbUZ8B8SiYoEcLQoGk0qaRkNmb4AOMykbttI3yOebAy5snN/GshtQIjmPQaQ63LhGFDBo/hl1jczIGjG+cUjKEd7CuQcqEihLEn41HFlrVd0netNc65DDYwAhV0SpzoRDe9z19JCujxy6dcvFQrEN3ccsdu/P9zB8W516fy9dYeGWIuL2A5DZCXRCDW3CiBJqy95h8ey47Vz/7JU0TMDd9Vg+ftNz7sH7/sbxWnB4qVXPFxjGkLRx+3d3HN6Rhgl3yp6ssf4csc1MpxyTHcIFli9tWeZK0gMWz4J79iKV9vR5X9OS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8szoK600fZtjRb3YcW7L9hS7FftjSfL/qf2KYD67XJ8=;
 b=kKVhHNbqWxY/fxRVULUF6LOMwaUil78Jyiwm7yR9eY5rq6Rhw5iL15mk25gZ8Vz4VDwDwSs3NAs+CEc7Y+xKQprUwdcI9EJHDVxQQVeTgCid4ZDzqTBGv+VeVqyq/zFJi38rcV0fNtAGZQPb3a+Q3YT+Qzec3tc7xYOJF4mPhfEAQOkYDPSWnlZFk5ZraMzSYY/7CbK3+oHl+QYy8HMeSr0mUT1d493MJ05WRccchgLVwTvNFCGXtJ0HPy9g09rrb5x7cdI/hrIiugnY9zpUOiIaBNg7sy7w62GgnNcOBzG/hrgpXaYXyIdHEY6b7n9KLwS0kD6VKZDuYBgwMolIlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8szoK600fZtjRb3YcW7L9hS7FftjSfL/qf2KYD67XJ8=;
 b=qK2LIYnzqCk9LWEyp4J/1Q2inzG7NaBc/YVl3Hq58y7EyCzLglSMMt28TtID9RpS5+K6QjrU9dcp5qVLusyuIAYGD3mMYDNN9d7ic5Ofice2O2AoYvQsz3t1P4qF9N3gazZp7NIVofZGvzofCOinyaL/MYA1nVWJQffIkYUWozI=
Received: from AS8PR03MB8805.eurprd03.prod.outlook.com (2603:10a6:20b:53e::20)
 by DBBPR03MB10198.eurprd03.prod.outlook.com (2603:10a6:10:52c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Wed, 21 Feb
 2024 14:20:02 +0000
Received: from AS8PR03MB8805.eurprd03.prod.outlook.com
 ([fe80::3c77:8de8:801c:42a7]) by AS8PR03MB8805.eurprd03.prod.outlook.com
 ([fe80::3c77:8de8:801c:42a7%4]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 14:20:02 +0000
From: =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Andrejs Cainikovs
	<andrejs.cainikovs@toradex.com>, Kalle Valo <kvalo@kernel.org>, Sasha Levin
	<sashal@kernel.org>
Subject: Re: [PATCH 5.10 350/379] mwifiex: Select firmware based on strapping
Thread-Topic: [PATCH 5.10 350/379] mwifiex: Select firmware based on strapping
Thread-Index: AQHaZNAdpmnhO9wDv0m4Y0BH2mqD0bEU2HyA
Date: Wed, 21 Feb 2024 14:20:02 +0000
Message-ID: <xxg5asor55x4yz4nvg5sn6reliefneaotvdbnl5hkvmxd3gnsr@5u3tvfhf2oyy>
References: <20240221125954.917878865@linuxfoundation.org>
 <20240221130005.373885693@linuxfoundation.org>
In-Reply-To: <20240221130005.373885693@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR03MB8805:EE_|DBBPR03MB10198:EE_
x-ms-office365-filtering-correlation-id: fdd65566-f93b-4150-be36-08dc32e83153
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0ZkYfiJ+iwI96V81poZ1h9N+KbmTJeRvrVHk1l7I4HcuxPZ/B4IKs7ANILeL6GhC4byeadVMOiAhQV1NkNwB14fnaEuWm+WRfNseayPDJCvDp6pgrVMCNFfWBErI6dtvKEpFMJy9r0K8Ad+NFhonc4ridTC1oJvyKmqJ9tK0II7JUSykkhexXNzmhBhnw3TX+9Bk2+LjqyyyCfBzjoEY+WzrduhUH3qAbHLcyA5b4g5MMjAEId5BY11sAyhGUfLcYAsMLNCzPcM/5PiSc5PqCZIuV1y4qEdLGwu88lgbOzdEF17g8sI5xYGF8kEXdejvsJ3P/fr7owMFOcvq2XTVqqnjjMQ/Y04nWSnUJMWAwzTUXKsPYINS9CrZthXJHpDYCzCZJdLdCYBpxI4FNqK5ypzB3xixy/mDV9/SeHz94pgRO4LOew2yByiKCrfsDfsxHt62VnaLOOtgpGaHwWXcV/uuFrrwtJkB00rxb+0fsCXMrR83TxTj+vUFH9cv9jVTyUQrWK/mpTYrCBQ0G+LXt3UIB5qwbTp0MqdtI0EsN48SLmTOK9FK32H5vWiGQFRqjw8TMKf15GrUChE1S7THKRWJoYwEUVsr/AeHX7Pi8qU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8805.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z09MSm94dm5TSEhERWV4RFVCNGdUYWF2NUorSndQNVRwL0FZZUdncnAvZ2V3?=
 =?utf-8?B?S01abWNTZ2pUUXFJS1Y5ZUJnYlF6UEl2WFdHTnk5MGRzRllEZ09KVG1lYXBu?=
 =?utf-8?B?VXkwQmVyaXVqOU9RdURwZlFYQ2tYU25vaHM2alVHdzgwNjBmVU0yMm9NM2cx?=
 =?utf-8?B?QXdCSXZ0R3EycjB2NExMc3lWbHVSL2pHYm5VMUcwTWM2VE5RaC90WHJ3SGlV?=
 =?utf-8?B?b3Y0WThnK2RsNEx6Uy9FL2wvTjJiTnpNbW9IMFFmMU40Wjg0ZVo2SXdYZHBK?=
 =?utf-8?B?OVRkbFF0akh1STlsZGhabGEyZlNvOVEyZFZTSFgveWNGdnk3R0o5S1VrS3RI?=
 =?utf-8?B?M3RtZWFCVEpSZ3BtSzRMdHh5Q09PcHBBM2YydEVuY0NvclFHaUFpdWVmM1VP?=
 =?utf-8?B?QU9BZU9FNnl0dVNPSHF6VlJjWk14WFpOeW8xWC9HR053N2NGT2YyejllcW9J?=
 =?utf-8?B?RllDWWg2TndyeWVJVjdTTTYrWm9hbmZOYllydEdwc04zelVUdmlsS2o1bkpa?=
 =?utf-8?B?ZmFadkJIc2xpeTM3TlNVcWZCQ2dNSHVlL2QycVBVaVZTQnJ4NGUrWlF4d2ky?=
 =?utf-8?B?bS9lRVZTcUlGZGZnMGZ6RTBDeDUrWnZWT0J6L1YxeGJ4cTJvc3gwVkhFSGVZ?=
 =?utf-8?B?N2dwVkxVZEtqNW1CWEFwMDdSa3ZGdnpsNDk4d0NMTEx6NkZtVFBONGJ2SktI?=
 =?utf-8?B?bVpuSXA4aEg4amlLbGw0ektVMVRVTWtubHVWaEFWd3VYRFp5TzNnQjRsbTRY?=
 =?utf-8?B?SVFFNmtiRHBKRGx1TEtZNFZOYWRoN0VyRE8zS25aKy9ucHlKOW9tblowdFdV?=
 =?utf-8?B?V2FVR0dOUHUxb1NzNThlUi9Ncm8rVER6aWpHUGF4eUEvSWljamt2U2J1czZs?=
 =?utf-8?B?K1ZIdks1MTY5MWU1T1c3R2hITHQyTHZxV0VsWkFVeVlnWHNBY2dZRXBTSGZG?=
 =?utf-8?B?c0hrM05DTEttdjJhZmJiOTJQV3VBVzhHY1IxNFB6L3ZoMUYrRUlaS2Y1VzNz?=
 =?utf-8?B?cHNiVWRMbFBMK3l5MzFsZnVHanpqcDBCS2liT0hqL1o4VE1wUW1wbFlKQWV5?=
 =?utf-8?B?c2JHcWNLTFRkbjl6aENaZTErUlZCSlBvVjhKMEtncTU3K25tSmdpKzZLWDNW?=
 =?utf-8?B?U1o1ckdxSkJ5a0JQQ2ltSDdCazBNNis3UkJhVUFza2FETnNTek5wMWFqZVB3?=
 =?utf-8?B?YUF2WHJ1WlY0cGpCRGZKZGozNGNVUHU4TnRPVEpuZkNMVTBySGNVOTJkY0NH?=
 =?utf-8?B?L2JEN2pEc25pUmNJUXRObWVZWFFhbjhvVTdFTHJoTHlCQmtCc21FeVRlTExK?=
 =?utf-8?B?MU5JMzlUVzl1b2VpRDZsRHZBQkdlL0dod0ZERE1zVEI5cnY3QmFqbGpXRFY5?=
 =?utf-8?B?UGg5eS9YU3FwSnl0bURJekxBMnczcUt5ME81NEZzVCtaMEVCc1dqYXBweEtM?=
 =?utf-8?B?RTlPVkFQQmFZQ3pON1crK1NGTWtGT0VWVjI3K29IaTFpRzFsR1I2OWwrcnFj?=
 =?utf-8?B?UHZGV05KYVNHUUhQWUxPR3dIVFIrazVEWmxwdGN4bDl0YVNpazExSFgwY3hU?=
 =?utf-8?B?S3NaN0dENjdMYzNJV0FhZzhGdzZNT2pLUzFiMG5qVVN1NDBGT0dsOVBFZmRq?=
 =?utf-8?B?OXVFZTI2VjUxMFV4ZmpUcGZkTlFRbVhoQ2ZOaEU2c1NkK1hOcmlxVU8xTmFt?=
 =?utf-8?B?ZFVpTFdnaTR5c1IzaEpXOG1VYlJEaytJbTJydHNuWkQ4MVJIREdJcFBrUmhv?=
 =?utf-8?B?ZkpzMW9KZ3RMdVczcnRna2dqdjlpY2VGZlhuUXB0V1dlRUNjVEY0cTdVZ2th?=
 =?utf-8?B?NFRkZ3ZzcFFCVzZMTVIrd2RENXdEWmxsNll5cm1IeEhqRGJxWW1TT0tQc3VO?=
 =?utf-8?B?TnZNSW0zakIwQi9UTkpDRkRLRWY3SnZySDcyZzNBSHNjbzlrV05NZmF5amM3?=
 =?utf-8?B?Y3oySGJHVGdwWXEwZW5kTWphMktaQmphNWlxTnlod0V1TXUvZFNMQXFJNFRN?=
 =?utf-8?B?c05ySEdtb3FxZVZQSkFLbEg5aGNmakx0TmFyUi9heU1xcTE1TGEweS9rbFdh?=
 =?utf-8?B?a0NBSFNXUVhHdlRhdkVuRGNYMlpxZ1dhZi9NK0FFMGV0U0FneFVpaCs1QXJM?=
 =?utf-8?Q?HgsX9hC4NTlTup6y0sHdG9ZnS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F3AA6FAED307A4E839A68A1CB5F528F@eurprd03.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd65566-f93b-4150-be36-08dc32e83153
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2024 14:20:02.0843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OvA+xIjTBI0SNHG1r/igvQ2TwLiAdOcW7HMMOKnMqpx2fKwcjr1LLX0k860bxeHqBZwlt7vMBE+tvDVgffXOfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB10198

T24gV2VkLCBGZWIgMjEsIDIwMjQgYXQgMDI6MDg6NDlQTSArMDEwMCwgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOg0KPiA1LjEwLXN0YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFzIGFu
eSBvYmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lIGtub3cuDQoNClNhbWUgY29tbWVudCBoZXJlIGFz
IG9uIHRoZSA1LjE1IHJldmlldzogZHJvcCBwYXRjaGVzIDM1MCBhbmQgMzUxLg0KDQpLaW5kIHJl
Z2FyZHMsDQpBbHZpbg0KDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IEZyb206IEFu
ZHJlanMgQ2Fpbmlrb3ZzIDxhbmRyZWpzLmNhaW5pa292c0B0b3JhZGV4LmNvbT4NCj4gDQo+IFsg
VXBzdHJlYW0gY29tbWl0IDI1NWNhMjhhNjU5ZDNjZmIwNjlmNzNjNzY0NDg1M2VkOTNhZWNkYjAg
XQ0KPiANCj4gU29tZSBXaUZpL0JsdWV0b290aCBtb2R1bGVzIG1pZ2h0IGhhdmUgZGlmZmVyZW50
IGhvc3QgY29ubmVjdGlvbg0KPiBvcHRpb25zLCBhbGxvd2luZyB0byBlaXRoZXIgdXNlIFNESU8g
Zm9yIGJvdGggV2lGaSBhbmQgQmx1ZXRvb3RoLA0KPiBvciBTRElPIGZvciBXaUZpIGFuZCBVQVJU
IGZvciBCbHVldG9vdGguIEl0IGlzIHBvc3NpYmxlIHRvIGRldGVjdA0KPiB3aGV0aGVyIGEgbW9k
dWxlIGhhcyBTRElPLVNESU8gb3IgU0RJTy1VQVJUIGNvbm5lY3Rpb24gYnkgcmVhZGluZw0KPiBp
dHMgaG9zdCBzdHJhcCByZWdpc3Rlci4NCj4gDQo+IFRoaXMgY2hhbmdlIGludHJvZHVjZXMgYSB3
YXkgdG8gYXV0b21hdGljYWxseSBzZWxlY3QgYXBwcm9wcmlhdGUNCj4gZmlybXdhcmUgZGVwZW5k
aW5nIG9mIHRoZSBjb25uZWN0aW9uIG1ldGhvZCwgYW5kIHJlbW92ZXMgYSBuZWVkDQo+IG9mIHN5
bWxpbmtpbmcgb3Igb3ZlcndyaXRpbmcgdGhlIG9yaWdpbmFsIGZpcm13YXJlIGZpbGUgd2l0aCBh
DQo+IHJlcXVpcmVkIG9uZS4NCj4gDQo+IEhvc3Qgc3RyYXAgcmVnaXN0ZXIgdXNlZCBpbiB0aGlz
IGNvbW1pdCBjb21lcyBmcm9tIHRoZSBOWFAgZHJpdmVyIFsxXQ0KPiBob3N0ZWQgYXQgQ29kZSBB
dXJvcmEuDQo+IA0KPiBbMV0gaHR0cHM6Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcvZXh0ZXJuYWwv
aW14L2xpbnV4LWlteC90cmVlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL254cC9teG1fd2lmaWV4L3ds
YW5fc3JjL21saW51eC9tb2FsX3NkaW9fbW1jLmM/aD1yZWxfaW14XzUuNC43MF8yLjMuMiZpZD02
ODhiNjdiMmM3MjIwYjAxNTIxZmZlNTYwZGE3ZWVlMzMwNDJjN2JkI24xMjc0DQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBBbmRyZWpzIENhaW5pa292cyA8YW5kcmVqcy5jYWluaWtvdnNAdG9yYWRleC5j
b20+DQo+IFJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+
DQo+IFNpZ25lZC1vZmYtYnk6IEthbGxlIFZhbG8gPGt2YWxvQGtlcm5lbC5vcmc+DQo+IExpbms6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA0MjIwOTAzMTMuMTI1ODU3LTItYW5kcmVq
cy5jYWluaWtvdnNAdG9yYWRleC5jb20NCj4gU3RhYmxlLWRlcC1vZjogMWM1ZDQ2M2MwNzcwICgi
d2lmaTogbXdpZmlleDogYWRkIGV4dHJhIGRlbGF5IGZvciBmaXJtd2FyZSByZWFkeSIpDQo+IFNp
Z25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gLS0tDQoNClsu
Li5d
