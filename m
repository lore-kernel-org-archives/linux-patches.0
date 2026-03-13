Received: from MA0PR01CU009.outbound.protection.outlook.com (mail-southindiaazolkn19010006.outbound.protection.outlook.com [52.103.67.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF1F2EAB82
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.67.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773361643; cv=fail; b=L224OTTWwjF6Ax4tDWYoyy5lTYj0J/MeU+W7W2HpR01IJ2tlG8OfUpholCbonNs016FSaisCFx4dLm5B0VO69nQV9hMbezSjUs+xXzeN2XF9rmd1tqKfk5xN8ESoLku2IwecYR1GW9REX1MYa4xQDIy8IzF5z++hS3fZcHQytIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773361643; c=relaxed/simple;
	bh=keZpaZSXOLx5hqxCui+TmVSOCk5X+dWdCl00eEDefvA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QYny+gukCFtp6Cm5ERfEK8N9YZICg+8COy3hmnAmlw2SUk9QpELZhY6G60oYjrGYBTAtMrKdxAEx/BS5robIh4YrOR+4yTOKZgk4lS7QFT9+WhryZ0KEh4OMxEknD/jkUbG4SE/QdhFRHkgtmzwtVstnqYrHCz8Fa/VbY9smYmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=vI0eRmSv; arc=fail smtp.client-ip=52.103.67.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="vI0eRmSv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moHENoYod8NjPKm7dpv6oDjFDUFplwtg50vFwolTyq7y4UqSEEf4IwUdoMsNyNsjh7Rw+wSxyq3QrMwYEpkvKe722DehyQUs4Dl67dENgRpEiUK7obUaVEXjJnU4mdt20Ik9irVT0QOOrxq9j01Gw2s8a7q2tH8D5s/1XPJacamE/WNmOWL5No4gvzqnRgfRTfcvmu6JShw/b5XbBw6bhTGRLpCstUOPr6ahyKqteYcxl6YXvGw9TYnSuLucWyAQSdj1QYlnNUvJTvkwHEdeS6/uFwrIraZzH4psIMA418mf4KMEFJysRE9odzZ5Q3EMXDA1581gRfa9bSZcXYp00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keZpaZSXOLx5hqxCui+TmVSOCk5X+dWdCl00eEDefvA=;
 b=DM3fjneb5GV9p3ihic3mRuEpGNGv97NlRXv+UJy20oaT1qG7fcOYpqRzW6QpvOSdrrHUpF3/rK0c5k07vpN24EANcckQoJXTG8DSFhqYyWNeaVt1PKfS+A/D8ckaFkiVvGvqY2QrMMcqSjgVTUi3XSizOv2bZuoCPxDIySOL6A6NyWi/ca23ZR/Y/DWXME32Yq7OJOxlE/+R8CHaef/3ljxYlDNZS0xy5t5G6CZ7iBLs9dUPHZN9JjdRX0tbqMe4gYUXrIfXlO7TrF1UpLHe7MCKZuW895IxUTBpNSLSJlkKgtYkSUiG63hMRiX3JxV/3FPRZ3WdxSrCCQgT1FJ+pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keZpaZSXOLx5hqxCui+TmVSOCk5X+dWdCl00eEDefvA=;
 b=vI0eRmSvDdtGEDjFDIShnEmVrFuwy8IiA9r+xBwBdedfFZRgSAfPWHLRdKdVRvUW0N0NRrbaj3+3haYDaN0bI9Ov8nOB4nv8DTqFd1MkWMTGAJaBnPiVDAZj27Z8Z0RP1Wmr/9RhcLUr0nSTWoDG1WU3MaafL0/ag9jiHlis9ILyju3dqgVaP6E0tmiNnYU5w9oJQwrwoeWWpcIwG+o1G/yu/eXNxfs4lYPlVv3htHRSOiXjWQaTOBrIeFash5VtSEHb2gtVKcr5ES/l57hX3kcL7+sXT85Ta5Ywqy1hKzyVfUWwLupFWlrFo9d0S/S1QranqE+/sMVQu1piizxdyw==
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:19c::18) by PN1PPFB60701353.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04:1::320) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 00:27:15 +0000
Received: from MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295]) by MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::1fed:9b0b:69b:9295%6]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 00:27:14 +0000
From: Aditya Garg <gargaditya08@live.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Kerem Karabay
	<kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>, Sasha Levin
	<sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.12 175/265] HID: multitouch: add device ID for Apple
 Touch Bar
Thread-Topic: [PATCH 6.12 175/265] HID: multitouch: add device ID for Apple
 Touch Bar
Thread-Index: AQHcsl4QlhqY/CkkYkyg4o7jMlvK+bWrm4oe
Date: Fri, 13 Mar 2026 00:27:14 +0000
Message-ID:
 <MAUPR01MB1154696D5379AECBCD87ED89CB845A@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201024.625617672@linuxfoundation.org>
In-Reply-To: <20260312201024.625617672@linuxfoundation.org>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MAUPR01MB11546:EE_|PN1PPFB60701353:EE_
x-ms-office365-filtering-correlation-id: 9a1d5067-dce3-4c85-724a-08de809746be
x-microsoft-antispam:
 BCL:0;ARA:14566002|14091999006|461199028|31061999003|51005399006|6072599003|25031999004|19110799012|8060799015|8062599012|41001999006|15080799012|40105399003|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 =?utf-8?B?dHloNDZFTURUWWRoTGw2NzdEblI5MGZ2VUJvS2lscytwck1SeUJtV01zdmR0?=
 =?utf-8?B?ZnhWaUkyWUJlQ0xxVUUybS9xbk5LanY4MSt1V1VRUGZ2bkFUL2ttcFptcEpW?=
 =?utf-8?B?OW5jbWx4aEhnS05oT0dvaHA0ZjducUdqUTFUQWRIaHlsRkNpU3dvMzQzWGtu?=
 =?utf-8?B?Z0MreVRZenNCa0x2ZG95bnBTUkxlRXRnTW5WQy9nK2d1bERYSSt1V3ZGUkVL?=
 =?utf-8?B?MFNwVllkbkMvNkxhTi9tN296cThVamhvajRuOEduaDI4SVRBc2hDaWZEQVBJ?=
 =?utf-8?B?TFM2YUEreEZoS2tidjA5LzI5QmFVQTFUMURwRWdRdVlCZjhEVXNXMkVvaFAw?=
 =?utf-8?B?VkprNWpVSi92Y1lEVDBuWks0NWE3VExtVjdBbWV5SFJyVGhHMlozYU1obFJs?=
 =?utf-8?B?RzVlLzJxYzVYTm1DU1pVOUxDNzMvWW5GUi9PMCtOSmQveVYyWDgzUk1uMklk?=
 =?utf-8?B?ZHdwdDRqTTJFQVJDV1hYT3ViTWJYT2xnNWJrRDdEcGpNMGJQUFY1MzNmSmlH?=
 =?utf-8?B?dk85NkdYaUVZbGVuSUdLbGl4QnpwNWdlMUFrY3A1VkoxSG5ZWHVtU0Z0OUxa?=
 =?utf-8?B?cU85azVFd293bUxjSk9vMFMvOXNZaDYreHdJUVpuK2ROZFlJTExEN1RSY1VS?=
 =?utf-8?B?Q0crQXJjRVJ0eE44UFFSSitXclBWSEp4bWRQcHBDV2pMQ1VQWm5LajJXQWtv?=
 =?utf-8?B?VnVVTjZ4KzJjT3JOTlJPdmF5VDM1MG44aFl6ZHpDNVd5Y0NDSzROSGhuMDNZ?=
 =?utf-8?B?c3I3bW9yMXkwdmdJY2hHa0ZZZmZ6cUZ0WHppS0Rjc2NyOUdWQlowM1dzdjdj?=
 =?utf-8?B?OGlTWmQ4TjJVUW1NQ3h6NzhwbjRYZ0tQTStRaUNhbTU0ZWdwM3dXM0kzNFB2?=
 =?utf-8?B?Y3Jjd1RnbWdqTGZFSHJnNis2RHhGN2JKVjBZNVlYNGRMd3UzYTFkNm9aWXFT?=
 =?utf-8?B?Q0VjU0lzZThRNXJNWGliOGF1SmN4aUZTd0J6WmMwcjJYVWNuZEdoc1pmSXE4?=
 =?utf-8?B?QysrYWJZNE9ybDcreUpqOFZ1VjJBanpUblJOK2YrOEpxMjlqV25xOXlwVlA4?=
 =?utf-8?B?Q2l4dlBnTGN1d2JhUXBtM1lMVjlacHkyN0xGUTlJWDJlSkZwU1RHTU5tb2ZF?=
 =?utf-8?B?MlNhS2g0clk4Sk5naURYOUNzK3lubVBoRmZBVnc4ZVhNZWM0VmxlUEJBckdM?=
 =?utf-8?B?YThhN0lBS0Qvem9pZFJsempCQnl4Y1dCN1pTTk85UTZmcUZ5YVVKb1dzUHBW?=
 =?utf-8?B?b1NmMFZDODNHYXh2a3h5TElyZU1vQ0F0K1EwM2JoMlhLajh3OEJwL2xqQS9H?=
 =?utf-8?B?Ty9vd081enh0MG5ZRWVLaFRSUnVrWEcxMHF0VW9LM2kwNTFKNS9ka0tOQzJq?=
 =?utf-8?B?cXpGc0ViaDhmV0E9PQ==?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmJJWEkyMmt0alY0Z0tvSG51emJKUmJxc0lmTzd2djh5aGx5c2dIZEh2L2ls?=
 =?utf-8?B?MnEyMTF5eXVFWTVRTE5vYlFaSUxFclplaHByZ1E4WWo0Nmh0VVhkYnJvTndH?=
 =?utf-8?B?bklKYkxGT0VMN2tOYUtBMUtVckZWUDdJV1FlV1J1ZXZlQVJBTU1Jc0RFYk43?=
 =?utf-8?B?S2VnTXQ2eExEYklmMEp3KytEUUVmTWVOTTVMNmlUZmFGYVZRaFBZSk96dWJz?=
 =?utf-8?B?VDl5dmZRY0xPSjVTQVgxaTVnNk53U1AwWVN0MEJZL1ZFVUt5WGFwbVdkN1Jj?=
 =?utf-8?B?aFFOL1FjVitxYnpFZkpLbXJxZXN6VmtMSWFTQkVUcUVjalpOMVE4aS9jRGI0?=
 =?utf-8?B?ZVVkYnpmU1F0UUR6RWN3UDZjNjJSZU5ZNzlMeXVYSmgvTEpjMWhMeFdiWk5V?=
 =?utf-8?B?WUNodnc2dEZnSnhBbDRqVWx2b0RQcHRmbWNFSWxMclNMY1dpdnV1VnVZU2tO?=
 =?utf-8?B?Q2NCcS9qa1R6cy9rNi9SaVVKdlBYY0VySmI0cUR5c3A4akp0L3VGcUR1N2l5?=
 =?utf-8?B?d2ZONDVVa3NRdEdWaitFS1E2WFZ0OGQ0UmpyckNvMllnbk9zeWtVRFpUSGZ4?=
 =?utf-8?B?R1VUdFB6NjZWY0g3VmZxcDdhaU1jL0RzVzVYTEp0M2pQMEI4RXBQOG5TTjJ3?=
 =?utf-8?B?NG94Wkk1ZEZBTjZhSDVYS3VDc2JmRWpmVVNGa1lUYVYybU9uRmhmSWdHSTA3?=
 =?utf-8?B?OFZkZ2wxTU5YT1hpTTRIekVabUxmenlIWDRQZnJZRXZ1Rko2R2QrRTVFN0dl?=
 =?utf-8?B?czR5aEtlSFVKNGEySlpzcmdRRU9OSXEwL05tV2tDSU5hVDlyOTNQUnhOVUZR?=
 =?utf-8?B?cmJsd2gwdXpJbGlmdkFaRlhtditqNitjdkFNSzNUdEdxZUV3NFZCZWtjclVB?=
 =?utf-8?B?eEtlUGdERU45YlZVVEE1ZGNpUEEvUlBnWVRra1V1Lzk0dnhLZ1N1ZDcrNUtl?=
 =?utf-8?B?WSs2VVZ2c0kvdTh2RmtmSDliVGc5K0pVc3NlSVY5bVdPbzBNL3p3L1dXTDBo?=
 =?utf-8?B?VkJFWElJZ0MzWTFwTVhsdWttUTBRTTgyUkM2bCtYVE1mWnVRUXdodjA5ck5N?=
 =?utf-8?B?MVI5bnI5d0VHZSsrUXQwOTFiYS92c29ZNDVEQThNTmMxUWtCRXJmMlcxRTln?=
 =?utf-8?B?WEFSY01MRnFPdTV3ODFQRlFNWCs1V3pLdkdIdy9YZXhaTlBybVdUaCtMVHBP?=
 =?utf-8?B?ME12R3BPU29McEZaVnpXSDN2RWFOMWtnc0tIK3pDeEFjN2pNSllnTXhEcGZC?=
 =?utf-8?B?ZStzaU5qQUtqWm9CSWxFNkl5dDlqQ1hQSm15QVBEWERLVGw1UzQ3MjRQdWpK?=
 =?utf-8?B?dStScGlJc2JYTllPTXMyYUVYSjhaVkQ1WjNrc3hkNkZEdnY3UlFCRHFFUm5o?=
 =?utf-8?B?VG8wZHFwRkhwZDdWUFZmSktGYWxaSkd4WExhd3VRbjV2MEVXd3Q1bzZ5azU2?=
 =?utf-8?B?ME9GVklYTFh2ZDg0aktuR1B2dkhiYjVPVUJvV21uVVY4bmcweWFZNnRuakFX?=
 =?utf-8?B?OWVlVWJRS1hzK1FzdDNRdm9kOGJXaWlCcGwrdHloeUlDTEtUdXg1Mm5ULzJp?=
 =?utf-8?B?ZWVmOWtVdmZUbVhOZ1c4cXl0TEZlWUlsSU9sRWxiQi83Y09OaDlSVnFpaUJu?=
 =?utf-8?B?Z2ptTUp1Yml5c0FGWWFLYXJ2NjJGdEkxb0ZaaVhEUlBjMEtkNVVkMkVPOU81?=
 =?utf-8?B?U2wwby9hdThkdnJycjlsbTF5VFA1bFkzeTVZcW5Jc0tyZXVWMTJFM2FLQWE3?=
 =?utf-8?B?emNMK0w0VktwendlUjdjSk1aL3VvQldocVhQUDBDYkFQQWRuRVNOdDdjZm5r?=
 =?utf-8?B?aUxNUkdLWU91M05FbU5XckRXck55QWZFZktoYUZMWnpTbk5ydjV2UHE2d1Vt?=
 =?utf-8?Q?R1A2D8iEhp3Tp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-63b91.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1d5067-dce3-4c85-724a-08de809746be
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2026 00:27:14.8045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PPFB60701353

VGhpcyBwYXRjaCBpcyBub3QgbmVlZGVkIHRvIGJlIGFwcGxpZWQgdG8gNi4xMiBhcyBuZWNlc3Nh
cnkgZHJpdmVycyBmb3IgdGhlIHRvdWNoYmFyIHRvIHdvcmsgYXJlIHN0YXJ0aW5nIGZyb20gNi4x
NS4NCg0KPiBPbiAxMyBNYXIgMjAyNiwgYXQgMTo1M+KAr0FNLCBHcmVnIEtyb2FoLUhhcnRtYW4g
PGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gDQo+IO+7vzYuMTItc3RhYmxl
IHJldmlldyBwYXRjaC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBsZXQg
bWUga25vdy4NCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbTogS2VyZW0gS2Fy
YWJheSA8a2VrcmJ5QGdtYWlsLmNvbT4NCj4gDQo+IFsgVXBzdHJlYW0gY29tbWl0IDJjMzFlYzky
M2MzMjMyMjk1NjZkNzk5MjY3MDAwZjgxMjNhZjQ0NDkgXQ0KPiANCj4gVGhpcyBwYXRjaCBhZGRz
IHRoZSBkZXZpY2UgSUQgb2YgQXBwbGUgVG91Y2ggQmFyIGZvdW5kIG9uIHg4NiBNYWNCb29rIFBy
b3MNCj4gdG8gdGhlIGhpZC1tdWx0aXRvdWNoIGRyaXZlci4NCj4gDQo+IE5vdGUgdGhhdCB0aGlz
IGlzIGRldmljZSBJRCBpcyBmb3IgVDIgTWFjcy4gVGVzdGluZyBvbiBUMSBNYWNzIHdvdWxkIGJl
DQo+IGFwcHJlY2lhdGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2VyZW0gS2FyYWJheSA8a2Vr
cmJ5QGdtYWlsLmNvbT4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5
YTA4QGxpdmUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5YTA4
QGxpdmUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKaXJpIEtvc2luYSA8amtvc2luYUBzdXNlLmNv
bT4NCj4gU3RhYmxlLWRlcC1vZjogYTJlNzBhODlmYTU4ICgiSElEOiBtdWx0aXRvdWNoOiBuZXcg
Y2xhc3MgTVRfQ0xTX0VHQUxBWF9QODBIODQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZp
biA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiBkcml2ZXJzL2hpZC9LY29uZmlnICAgICAg
ICAgIHwgIDEgKw0KPiBkcml2ZXJzL2hpZC9oaWQtbXVsdGl0b3VjaC5jIHwgMTcgKysrKysrKysr
KysrKysrKysNCj4gMiBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9oaWQvS2NvbmZpZyBiL2RyaXZlcnMvaGlkL0tjb25maWcNCj4gaW5k
ZXggZjI4M2YyNzFkODdlNy4uNTg2ZGU1MGEyNjI2NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9o
aWQvS2NvbmZpZw0KPiArKysgYi9kcml2ZXJzL2hpZC9LY29uZmlnDQo+IEBAIC03MzAsNiArNzMw
LDcgQEAgY29uZmlnIEhJRF9NVUxUSVRPVUNIDQo+ICAgICAgU2F5IFkgaGVyZSBpZiB5b3UgaGF2
ZSBvbmUgb2YgdGhlIGZvbGxvd2luZyBkZXZpY2VzOg0KPiAgICAgIC0gM00gUENUIHRvdWNoIHNj
cmVlbnMNCj4gICAgICAtIEFjdGlvblN0YXIgZHVhbCB0b3VjaCBwYW5lbHMNCj4gKyAgICAgIC0g
QXBwbGUgVG91Y2ggQmFyIG9uIHg4NiBNYWNCb29rIFByb3MNCj4gICAgICAtIEF0bWVsIHBhbmVs
cw0KPiAgICAgIC0gQ2FuZG8gZHVhbCB0b3VjaCBwYW5lbHMNCj4gICAgICAtIENodW5naHdhIHBh
bmVscw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLW11bHRpdG91Y2guYyBiL2RyaXZl
cnMvaGlkL2hpZC1tdWx0aXRvdWNoLmMNCj4gaW5kZXggYjdjMjY0MGE2MWI0YS4uNWFlZDllMzIw
ZDMwNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9oaWQvaGlkLW11bHRpdG91Y2guYw0KPiArKysg
Yi9kcml2ZXJzL2hpZC9oaWQtbXVsdGl0b3VjaC5jDQo+IEBAIC0yMTYsNiArMjE2LDcgQEAgc3Rh
dGljIHZvaWQgbXRfcG9zdF9wYXJzZShzdHJ1Y3QgbXRfZGV2aWNlICp0ZCwgc3RydWN0IG10X2Fw
cGxpY2F0aW9uICphcHApOw0KPiAjZGVmaW5lIE1UX0NMU19HT09HTEUgICAgICAgICAgICAgICAg
MHgwMTExDQo+ICNkZWZpbmUgTVRfQ0xTX1JBWkVSX0JMQURFX1NURUFMVEggICAgICAgIDB4MDEx
Mg0KPiAjZGVmaW5lIE1UX0NMU19TTUFSVF9URUNIICAgICAgICAgICAgMHgwMTEzDQo+ICsjZGVm
aW5lIE1UX0NMU19BUFBMRV9UT1VDSEJBUiAgICAgICAgICAgIDB4MDExNA0KPiAjZGVmaW5lIE1U
X0NMU19TSVMgICAgICAgICAgICAgICAgMHgwNDU3DQo+IA0KPiAjZGVmaW5lIE1UX0RFRkFVTFRf
TUFYQ09OVEFDVCAgICAxMA0KPiBAQCAtNDAyLDYgKzQwMywxMiBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IG10X2NsYXNzIG10X2NsYXNzZXNbXSA9IHsNCj4gICAgICAgICAgICBNVF9RVUlSS19DT05U
QUNUX0NOVF9BQ0NVUkFURSB8DQo+ICAgICAgICAgICAgTVRfUVVJUktfU0VQQVJBVEVfQVBQX1JF
UE9SVCwNCj4gICAgfSwNCj4gKyAgICB7IC5uYW1lID0gTVRfQ0xTX0FQUExFX1RPVUNIQkFSLA0K
PiArICAgICAgICAucXVpcmtzID0gTVRfUVVJUktfSE9WRVJJTkcgfA0KPiArICAgICAgICAgICAg
TVRfUVVJUktfU0xPVF9JU19DT05UQUNUSURfTUlOVVNfT05FIHwNCj4gKyAgICAgICAgICAgIE1U
X1FVSVJLX0FQUExFX1RPVUNIQkFSLA0KPiArICAgICAgICAubWF4Y29udGFjdHMgPSAxMSwNCj4g
KyAgICB9LA0KPiAgICB7IC5uYW1lID0gTVRfQ0xTX1NJUywNCj4gICAgICAgIC5xdWlya3MgPSBN
VF9RVUlSS19OT1RfU0VFTl9NRUFOU19VUCB8DQo+ICAgICAgICAgICAgTVRfUVVJUktfQUxXQVlT
X1ZBTElEIHwNCj4gQEAgLTE4NDIsNiArMTg0OSwxMSBAQCBzdGF0aWMgaW50IG10X3Byb2JlKHN0
cnVjdCBoaWRfZGV2aWNlICpoZGV2LCBjb25zdCBzdHJ1Y3QgaGlkX2RldmljZV9pZCAqaWQpDQo+
ICAgIGlmIChyZXQgIT0gMCkNCj4gICAgICAgIHJldHVybiByZXQ7DQo+IA0KPiArICAgIGlmICht
dGNsYXNzLT5uYW1lID09IE1UX0NMU19BUFBMRV9UT1VDSEJBUiAmJg0KPiArICAgICAgICAhaGlk
X2ZpbmRfZmllbGQoaGRldiwgSElEX0lOUFVUX1JFUE9SVCwNCj4gKyAgICAgICAgICAgICAgICBI
SURfREdfVE9VQ0hQQUQsIEhJRF9ER19UUkFOU0RVQ0VSX0lOREVYKSkNCj4gKyAgICAgICAgcmV0
dXJuIC1FTk9ERVY7DQo+ICsNCj4gICAgaWYgKG10Y2xhc3MtPnF1aXJrcyAmIE1UX1FVSVJLX0ZJ
WF9DT05TVF9DT05UQUNUX0lEKQ0KPiAgICAgICAgbXRfZml4X2NvbnN0X2ZpZWxkcyhoZGV2LCBI
SURfREdfQ09OVEFDVElEKTsNCj4gDQo+IEBAIC0yMzMyLDYgKzIzNDQsMTEgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBoaWRfZGV2aWNlX2lkIG10X2RldmljZXNbXSA9IHsNCj4gICAgICAgIE1UX1VT
Ql9ERVZJQ0UoVVNCX1ZFTkRPUl9JRF9YSVJPS1UsDQo+ICAgICAgICAgICAgVVNCX0RFVklDRV9J
RF9YSVJPS1VfQ1NSMikgfSwNCj4gDQo+ICsgICAgLyogQXBwbGUgVG91Y2ggQmFyICovDQo+ICsg
ICAgeyAuZHJpdmVyX2RhdGEgPSBNVF9DTFNfQVBQTEVfVE9VQ0hCQVIsDQo+ICsgICAgICAgIEhJ
RF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfQVBQTEUsDQo+ICsgICAgICAgICAgICBVU0JfREVW
SUNFX0lEX0FQUExFX1RPVUNIQkFSX0RJU1BMQVkpIH0sDQo+ICsNCj4gICAgLyogR29vZ2xlIE1U
IGRldmljZXMgKi8NCj4gICAgeyAuZHJpdmVyX2RhdGEgPSBNVF9DTFNfR09PR0xFLA0KPiAgICAg
ICAgSElEX0RFVklDRShISURfQlVTX0FOWSwgSElEX0dST1VQX0FOWSwgVVNCX1ZFTkRPUl9JRF9H
T09HTEUsDQo+IC0tDQo+IDIuNTEuMA0KPiANCj4gDQo+IA0K
