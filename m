Received: from usb-smtp-delivery-120.mimecast.com (usb-smtp-delivery-120.mimecast.com [170.10.151.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044D3B6C05
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 20:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.151.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666202; cv=none; b=b/YsO6l/qSjJ4D9ZTpqYDVluwqpzPcU22tM4pzrPWVYhdGDTlhZACtfUhDhJOmLI1xw9YX3ncwZmmy0mwc9eua7hknpwlHNzYLVYkafsZd2OeFfaAC7a772cfmZn4aCIwouS06DHhULg34Xjlig1RZc5lvAzZVq68S/GX5JP/jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666202; c=relaxed/simple;
	bh=k3R2WVYtry6MG3RG90Cf6FU+B6RXgo/s8xZAarRpmhk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=NJJj92wCggxcdXUG8XOLgnQn/uf52v6loDsC9i+1J08JbHEHtjd5P1t3PnKapSd/Srdzoxc+NO5NuBVuiNqdoQEI/PXMno4mhSHSe+u4K/tMviO0m4S6tVya+xSLQbdE6/BmpKCr5lcNB/NTxEhFhJukmZ6RIurS051i8Pu+Qd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=onsemi.com; spf=pass smtp.mailfrom=onsemi.com; dkim=pass (2048-bit key) header.d=onsemi.com header.i=@onsemi.com header.b=QgDzD4PG; arc=none smtp.client-ip=170.10.151.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=onsemi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=onsemi.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=onsemi.com header.i=@onsemi.com header.b="QgDzD4PG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onsemi.com;
	s=mimecast20250127; t=1784666192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3R2WVYtry6MG3RG90Cf6FU+B6RXgo/s8xZAarRpmhk=;
	b=QgDzD4PGWBAQ+PN7vz4xnMRyaIixg9spd98FNLf1lS6nxSaWPsGIs2xg3iVtpCA0d7nb6a
	ri7p5jl+OrlmuqVIoatVPz3yia72wKCTaz9GLnPZhSaxF7oVBbqcIoV7Dk94Ix5au8ESHv
	ztyUabQf7hNNlxoYhxLNzaJER9+gheAHSJmNdotaTfU35E3DtAZtgJ11zT27pUXrlJjZFJ
	wV3Bpk6LWWWxACVs6OtxHLDFfR2yoznaXCoHXfpNwIV9OIVusCGWF2m1NVhByGBE0xoR+J
	O+tDLU6Jk7WatZ6QoBdXlZYOW/JiInd5+c+OsJxohBVTLQG6Y74reXCa0Q+i5g==
Received: from DM1PR04CU001.outbound.protection.outlook.com
 (mail-centralusazon11010007.outbound.protection.outlook.com [52.101.61.7])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id usb-mta-65-dtjuFBBtOIySNoSjT9bqTg-1; Tue,
 21 Jul 2026 13:36:29 -0700
X-MC-Unique: dtjuFBBtOIySNoSjT9bqTg-1
X-Mimecast-MFC-AGG-ID: dtjuFBBtOIySNoSjT9bqTg_1784666188
Received: from DM5PR02MB3369.namprd02.prod.outlook.com (2603:10b6:4:68::27) by
 PH0PR02MB11701.namprd02.prod.outlook.com (2603:10b6:510:115::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 20:36:25 +0000
Received: from DM5PR02MB3369.namprd02.prod.outlook.com
 ([fe80::a77f:334f:452d:2b3e]) by DM5PR02MB3369.namprd02.prod.outlook.com
 ([fe80::a77f:334f:452d:2b3e%6]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 20:36:24 +0000
From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Krzysztof Kozlowski
	<krzysztof.kozlowski@oss.qualcomm.com>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type to
 be active low, level triggered
Thread-Topic: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type
 to be active low, level triggered
Thread-Index: AQHdGUIpnSDB20L+tkC93xJY6hmidbZ4bU6Q
Date: Tue, 21 Jul 2026 20:36:24 +0000
Message-ID: <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152611.685698227@linuxfoundation.org>
In-Reply-To: <20260721152611.685698227@linuxfoundation.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR02MB3369:EE_|PH0PR02MB11701:EE_
x-ms-office365-filtering-correlation-id: 3757fecd-1cde-45af-b22f-08dee767bb9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|38070700021|6133799003|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003
x-microsoft-antispam-message-info: qSbhYdCLzkWbYzW6DtUHwVoY3XmKViKHYKcijgftD9HQMlWN40hqth/ETSYPfUBrM3jyn6t+JTWxKduChdF6He/XwyKjhY3/bSEWeTWBJLtPyugxqIRne38ROnwiq8wXl26CbP/fCGsCt8nkkIMZ1VcaIkZ4QTo/1OW2yqk06LmH82K514vpTTzAYM1tjgfL9d4yaant3j0eHkc75ziv5lhXciUNE8fvFFXP5EmkAHP22GUJ1WOUjcB3e3QQRyyhTyi+7EWUDkKHSGgKt6E6yaYiEEAU9uhvWfBMIZ2Vae2DK5OlTe0NLd9WLvBuwLNG7pZTYJ8mRJpfIndFzQik4onlnoDbndqO6fZ0QivMfZwekR/fkS0okInXTMYj0AR5SiE4Z6aURflMGbGm6541FJ2TfrbNoqHQ/c+hwtVqoOpvGAD6R7es/41nY57kIo6osYRPvavfpBNr/lGE9Mw725h5Lo/he/6DLaKDz1yuJ0rOIO9xxpX6O42o7QbUF1X6gnBUjDWzZ/wamWTJbQwY5Fn4jaE9rVEdeXiEFgyDSwknQTgspSq38zo9CoyVPKvXlSNdf3AigjZ5n6U4rEhtZrrmZ/NvCIaYGvcRjLrQECdRVPW7UGxdPaDTV9/K1WX0v4Q8K188QrxTLvSTF/PXn2GVKWHTsAvcp/bejqLGeigWzy/YRWfAL9plED2qV4ddEyjj5gDr95Hq7Z8/4AlDDluHWSC5kWbTELbexlM7x50=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR02MB3369.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(38070700021)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXFTaHBMZDBsR0twc0hQVGl0R21FSjgrY0RyQWJYM0JwTDVOd2JCeWd6Smtk?=
 =?utf-8?B?NGlZWDkrMXlHYU9MSFA5OGRLZ29XZ2JmaXJXeDlIQUErR1BRZTEzc3krcE8v?=
 =?utf-8?B?TFY1akE3VUZhcEhsUmdrd0ZuNlhtWU8xSUJPMGR5ODN3d1BuSDlKMTRCQlNM?=
 =?utf-8?B?Wm1rWS8vT3lYM1hFekRTT0ZzOHNwSFNSZ05hSGpaTVQzMEJiV2ZCYWlhNmI0?=
 =?utf-8?B?QmovY2kwRFdSRk1rd1ZMRjBBazdnSW9Lc0pFSG1TR1NWQ2NPeU9Db2JYdzIx?=
 =?utf-8?B?dVExQ3NwQ2l5MjduZDAzTjdrZ3NXR2RCWmlicHppblgwWDV3eHg0WXJuSGND?=
 =?utf-8?B?bDY4dmE0WFJmS3llWlVtOFcvNmF4YkdzQ0MvRE96eE9rYmFIbEV1TDhxckJN?=
 =?utf-8?B?d04wTFhtMmxmclFtRkgxejQ1WDVqN3lHYTlDbGdqYnhMbmRIcFFqck5yU1Jz?=
 =?utf-8?B?ZmFlWmtoLzJDbjVjZ2x3bFVPbEdxQWpEaEJ6VkJaT3BDRlVobGJCaXF5OHpO?=
 =?utf-8?B?SFN6NFBzR2M5VkJVZkFwZUIyV0RVTTU1MTF4SDNaUGQzWkVselc5a05GMHVa?=
 =?utf-8?B?V0o5MzBwSTFjMDZraWRkK09hOEhMMmgwbU1OL2gwU2dsTnVNYnRJTkdSQ1Ex?=
 =?utf-8?B?YStESUpTaDMzNVJhNC9XbVRXak9MWnpUUTRRbEFKZ1MxV1U4b0kzQVVRd1pI?=
 =?utf-8?B?OTljZ3F1eTdqVDMxbENidjRZanlCNFRGb1RFa0RocGVjQU1NdWN4aVRXb1Rr?=
 =?utf-8?B?cWdRbkcxN0p6ZTQ1a0RPTy9QbFNUQVExYzVGMUs0TWVXQ2dBcXpHVndoWFVx?=
 =?utf-8?B?aXdEc2NqRUQ5VmlmTWNVNmFjUmdFOXdYdDdMQmlybFBmMTNEQ2VzVmpFVnVl?=
 =?utf-8?B?TUlxclhZdS8rUzd2ZnVzbUUrNVpVbTkvbm8rVHIwbkpCUG10RzN3bGNLQXNp?=
 =?utf-8?B?ZHlnYTY5ZkxxUmpGWThvRnRBR0g4YXpOd25MaVRPcHNUWEpGaXB2c3k3Nm5s?=
 =?utf-8?B?MGpNeWNiM0RwTWtjZCs5RG9TWTAzdUF5NE05L2dHUXZRV0xTckVlZzZsMmdl?=
 =?utf-8?B?N0hPMGtERE4rMmsvb1FCU3lPRTRmbmNWMVBrTXN5U2MxZW41SHBmNGROUzdC?=
 =?utf-8?B?eitjSnhjaVJQendZMUVNYktIKzBsaXVCTVlRTmY2dXUvUzJ6MHllbVM1d0NH?=
 =?utf-8?B?MU9QcVhtbm9kV2VPcTIvZ3JpYUhDdmwvQkV1VXZzUTNTVVRSc0N4d25NUjlr?=
 =?utf-8?B?RjR6cVFIYSsvODJaakUxbHlFcUNuS1hrb0xGRkxKaERNRnNsenpEb1FUekFx?=
 =?utf-8?B?R0lxQm82bnUwZy95Mmw4aEFTWVRxbWFPdnZxT0FVYjdVc0tNREREeDAzaHhv?=
 =?utf-8?B?TFFQNGFGVG05Z2ZzR1RrUDlCY3BXemFRdEI2d0dqaG9vU0pxMDBTTDZ4Vm9I?=
 =?utf-8?B?WDM1OEpUOHo2YmtyWFBGZG9xcUpFaGUrUy9sU0Z4MnpEOVFtOWJHL0t5NG5D?=
 =?utf-8?B?M0d0SityR3d3ZzE1ZEg4cWYvblVIbTNhZjZXQkZ1VTd0WEVEakcyYW1RNkxv?=
 =?utf-8?B?Uk1FYVlQTjBRYzQ0S3o5V0ZPZ1dGajhnY3BDc09pMzN4N0RvM0NSaGg3Rzlh?=
 =?utf-8?B?UU9wc1pNNGJpWm1YaTdrNm40WXdWNjJGYWVDWEw0RjVHOW9lU0JmWW1UNit4?=
 =?utf-8?B?dWJ2WTFBaDZtLysrbGZBTDFqQkVjSUtmTUFSMlVTb21qSDZJN0tsOFROZWhP?=
 =?utf-8?B?YVNMUDY4cUx0c3NtbVVyVDg2cXJLT0RmMHpZTGdoZnhwQ2doUDFJV0dBQ2h6?=
 =?utf-8?B?djhuUjN4V1h3ZW5jbmRyYnNHWDJJQ2tzaFVCNy9PUzZ2Ymg1ZWMzSUdrVHZC?=
 =?utf-8?B?MlVQNEFNRVozMWx5bGgrbW5MZlVScUtoc3BKanpSRkMwSDJEelJ0bUhNZ3gv?=
 =?utf-8?B?NGZUUUFkZ3diazlzem1KMWJzcmM1RURLdXFoS05SNFJxUEc2SE5wWitIbkxI?=
 =?utf-8?B?TCtlbjBvNE1NdG9kUUpCR0JHRm1mUHhYbHJkbmxvRGJCWGtSUnZmNWZkQTJR?=
 =?utf-8?B?b1ZVVlQxN01YaUN3UzRrV1NHajdrN3ZEMURJU3lFVVlHNGp1OGEycXJSR2Zs?=
 =?utf-8?B?blhJYTk0bHU4ZDJpeFhJRmJzUS8yK3F3Ly8rWUxQMzN3VDd2N2t6WUhCMmRB?=
 =?utf-8?B?Y1drK2E3VzRtU281dC9sS3lHdDByU1AzTUhQc2FpOXp4WS9VbC9Fc1VadWtj?=
 =?utf-8?B?Z2ppaWJ2cUJJQWxJRUtCbk41VzJFdWVZRi8xUldqUG9UNHVUZXVjWVFaRTF0?=
 =?utf-8?B?UWZLSXdlZ3RrN2M5RDNjZFBZQjRGVDJwMUgrU2Y3ajZ4MDRuVW1qMFBuOGYx?=
 =?utf-8?Q?xofLM3DQvnIKyVXk=3D?=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Utba30z2qA1FqTrwH2hJ9VsU7W/w6Csg+BBSzpbatWCqUNeAiFsOJHVDUJRBU3jNlCjnNo1PjTS+IDAomM7Y/5Ld/p0AnzwhthdzViJRYx089iT6SlFu/o3JGFL+07oFPkXibgqVMG4KytsVFZYfM7wZK/gOiFr2JxXmnlejMlc/d9Ez6oJNBi1cwL+8rfLh7VueZHGmXrxizW+K1yhcOQYI3F/Quk9wb/irBE4n14yoGVhlaEIj5Lq0OUuDnl6bYhufLohcx4tPPz0BCElEu+fOvrJdl1KTHgVbVSRFO8ShZ5/H5AABsS+13KBzvCYgyLg/mxlWTLr2xEojDyBWRg==
X-OriginatorOrg: onsemi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR02MB3369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3757fecd-1cde-45af-b22f-08dee767bb9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2026 20:36:24.8187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 04e1674b-7af5-4d13-a082-64fc6e42384c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0STTKnLbHuWvQ/qqc9u2kDbHRX+S7gH6lzyoksFhuAFa6Fd+3i0+niIux9YwLBeTqkZqzaD/o8s6OXWiZHw/QDHykVgvc8odN+lhJbhmf/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB11701
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kMoBv2fgaqPxrxb-2Pf0ZAUHJi2GkHvCe7b_9hKMzjY_1784666188
X-Mimecast-Originator: onsemi.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogVHVlc2RheSwgSnVseSAy
MSwgMjAyNiA4OjA4IEFNDQo+IFN1YmplY3Q6IFtQQVRDSCA3LjEgMDgwMS8yMDc3XSBkdC1iaW5k
aW5nczogbmV0OiB1cGRhdGVkIGludGVycnVwdCB0eXBlIHRvIGJlIGFjdGl2ZSBsb3csDQo+IGxl
dmVsIHRyaWdnZXJlZA0KPiANCj4gLS0tDQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvbWljcm9jaGlwLGxhbjg2NTAueWFtbCB8IDIgKy0NCj4gMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiAtIGludGVycnVwdHMgPSA8NiBJ
UlFfVFlQRV9FREdFX0ZBTExJTkc+Ow0KPiArIGludGVycnVwdHMgPSA8NiBJUlFfVFlQRV9MRVZF
TF9MT1c+Ow0KDQpXb3VsZG4ndCB0aGlzIG5lZWQgdG8gZ28gaW4gYWxvbmcgd2l0aCBzb3VyY2Ug
Y29kZSBjaGFuZ2VzIHRvIGRyaXZlcnMvbmV0L2V0aGVybmV0L29hX3RjNi5jPw0KT3RoZXJ3aXNl
LCBiaW5kaW5nIHdvdWxkIHNheSBJUlFfVFlQRV9MRVZFTF9MT1csIGJ1dCB0aGUgY29kZSBpbiBv
YV90YzYuYyB3b3VsZCBiZSB1c2luZyANCklSUV9UWVBFX0VER0VfRkFMTElORy4gSWYgdGhhdCBp
cyBhY2NlcHRhYmxlLCB0aGVuIGl0IGlzIGZpbmUuDQoNCkZZSTogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvb2FfdGM2LmMgaXNuJ3QgcmVhZHkgZm9yIHB1bGxpbmcgaW50byA3LjEgb3IgNi4xOCBhcyB3
ZSBoYXZlIGEgZm9sbG93LXVwIA0KcGF0Y2hlcyB0byB0aGUgIm5ldCIgcmVwbyB0aGF0IGlzIHN0
aWxsIHVuZGVyIHJldmlldy4NCg0K

