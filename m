Received: from usb-smtp-delivery-120.mimecast.com (usb-smtp-delivery-120.mimecast.com [170.10.151.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E81625
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.151.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739742; cv=none; b=qyinGYp2x+DJfhCfQC40l2lrnWGNiauwUec+3Jp30NYo+1fQZNqK9LigKveYke8hQIwKSyL+yu2je9nppU71LDhdLmzIa3BmpW2t7Aqu3fC8ui3C3QJUrv1Nnn4k3gXc9lLubBpI98YUgnOdIq1JF4g2iu/sKQGz1dnlz/XNmb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739742; c=relaxed/simple;
	bh=XUyYnEhUKZIE924id5udATc/tGirhPb4phPJMLBM+1g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=XpwiGk9OBE8EbR25XY16Q3oBz2jF6dS+oeDBg7KxD7qB0GO2yXuw/VjoFZdifXuE5mUVaKFgh866UFlG5jAOFRXLF619LZejMl3lEm29LuzIXyRJfmMi4rT1DqIP0s+owoXfIyasWCicc1gTOKfYTsjZAxORGgNlvB49E/yrHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=onsemi.com; spf=pass smtp.mailfrom=onsemi.com; dkim=pass (2048-bit key) header.d=onsemi.com header.i=@onsemi.com header.b=OrIxce7I; arc=none smtp.client-ip=170.10.151.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=onsemi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=onsemi.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=onsemi.com header.i=@onsemi.com header.b="OrIxce7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onsemi.com;
	s=mimecast20250127; t=1784739739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XUyYnEhUKZIE924id5udATc/tGirhPb4phPJMLBM+1g=;
	b=OrIxce7IDXITZNpsWPRTcW3RYjHOxWv33wyLuRrKo3K6kfkvluK7lcR2b6eZQ66MzA9eru
	pQPA+5sURX6jxlOBPXGdCG3uS6VuTOchf9IowdBrJozN1dmATaZw9OnSzwZM291dLP8cqG
	Ny9QC9lR01g+vYun50CbSF0NtsUuydx3vSAU/pVbDdda9nkkOZ0x28JJpeaVZLU5tR+cX4
	aXPugXMLhIGUNLUN+uzKhYqPR0DCeYRXKC/ZkAfs7ycMJLU10t4Bdh4/eH8L4ttB/Um3bE
	/JMxccHgUV9sY2nMCHeEd6vKqZG6TOjYtCO96p4uG0xRKIvqgV2NlWgBj6SHOg==
Received: from CH5PR02CU005.outbound.protection.outlook.com
 (mail-northcentralusazon11012029.outbound.protection.outlook.com
 [40.107.200.29]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 usb-mta-67-3WLvZx6NOnaqH5c8rXdEeQ-2; Wed, 22 Jul 2026 10:02:16 -0700
X-MC-Unique: 3WLvZx6NOnaqH5c8rXdEeQ-2
X-Mimecast-MFC-AGG-ID: 3WLvZx6NOnaqH5c8rXdEeQ_1784739735
Received: from DM5PR02MB3369.namprd02.prod.outlook.com (2603:10b6:4:68::27) by
 DSWPR02MB11444.namprd02.prod.outlook.com (2603:10b6:8:355::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Wed, 22 Jul 2026 17:02:11 +0000
Received: from DM5PR02MB3369.namprd02.prod.outlook.com
 ([fe80::a77f:334f:452d:2b3e]) by DM5PR02MB3369.namprd02.prod.outlook.com
 ([fe80::a77f:334f:452d:2b3e%6]) with mapi id 15.21.0223.017; Wed, 22 Jul 2026
 17:02:11 +0000
From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Krzysztof Kozlowski
	<krzysztof.kozlowski@oss.qualcomm.com>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type to
 be active low, level triggered
Thread-Topic: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type
 to be active low, level triggered
Thread-Index: AQHdGUIpnSDB20L+tkC93xJY6hmidbZ4bU6QgAFSjgCAAARL4A==
Date: Wed, 22 Jul 2026 17:02:11 +0000
Message-ID: <DM5PR02MB3369BD573A820009C50D66D283C12@DM5PR02MB3369.namprd02.prod.outlook.com>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152611.685698227@linuxfoundation.org>
 <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>
 <20260722113504.rc-reply-0004@kernel.org>
In-Reply-To: <20260722113504.rc-reply-0004@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR02MB3369:EE_|DSWPR02MB11444:EE_
x-ms-office365-filtering-correlation-id: 2adbc287-ff1a-49be-646d-08dee812f8c3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|10067099003|56012099006|11063799006|4143699003|6133799003
x-microsoft-antispam-message-info: Fi/N4ecvVl8mweZ3nUYDmhZXWNW8oOmvVpzEpXEn2uThJAlrQ/xEReP4xU9SXNz3Tz5OwXNJgS+31O2Z5knrwJDVPgnH9WIM3nlynOywqtYFM81Cy/zDNru8o82jvcgnJN3GGPo06NhjmkRC0951iphL80xbsTrPAVNFxoGu5WVfpsTWgrbt0shSs6clJtrK+Ks3yhfFblfSpXgutyUohNjiQUEDV6Mu36T+HzBHlrM1m1SV6/o8a0F0JVuClHeUcPUfF5wQvbGWvDkWxONME24Ay9gn+QaXtMei6zLcErCUgpNqdwg5ridjBRzKBFYXvp9LB7inQ3LprZ/G3UCRQhYe9M86OK6n/tyruxcak4/sXjZ/iNel4VlkwWyhwRFThnEuceFyZu4aLAHPk2txhiwEAZIF0AhcBh5Edzrr4+DQpQqCIqoFjufj/nD69Cj05apF6+XEYv+L2esuPXt3mCbM1L4xucXACIiAH+E9IfeY+kW/AMfAzsATQ2bzuYi/d6KWssKrwwDbhErEmLmyGFi7blaj1eRQdikA/F6CTG69v4NiX5jgK+T7p1e3d4CEuyppxcDQ0IdoyIsSVZyx4AivOHBKpHeVCK0Rwcjm3vb3b0cRut+/iTzV9T0a0QggPDnC5V0jVid4uXpXDvP3jYnNNGZAQfUvPCt3VoZwHnCQPEywlpfzf3SzrXepWJl+euu06Y9A2aLEXbeGEDJe1NHgwiboFcXFxvL0AL3H/Ok=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR02MB3369.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVJHcGVUTVJjK28vWThmN2VPMnF0RXJ0NC9mTFZxOEJocmFRS3VaV2tYMU15?=
 =?utf-8?B?d3F1UVNtSnY4MUxRRVBiR3RSdmVocjFEUmhYUEh3ZDdoRk5naFovYi80dkw2?=
 =?utf-8?B?ZE5UM1A1c1d6eXBRTTIxdU5OcHZlWDJudmdwcTFOZWl0QzRVR1FQbVhQZ0cx?=
 =?utf-8?B?M3E5R0R1QUdITlZJWHhjQU1TTTVQdWJpTEhua3pmczFzQXRLdTNNWktQbUhz?=
 =?utf-8?B?bDQwOTZHUlI2c1pUL3hCYVNweFRWSHA5SS9BN1ZHblpHRTF2alpLS0JnZzJw?=
 =?utf-8?B?eHdNYVhkSk1xYk9SdkdtTlJBZVNEdnFPNlRyY05KNDR5UmVkWkExc29yQkU1?=
 =?utf-8?B?TkM0Z0pKbGdqWFdMWCszRGRnSlFPNlZBQmR4cnBoVis1dEYxTEhvTWVDL3Zr?=
 =?utf-8?B?YTNVZFVuSUhvdnU2ek9CMkZlTk5lRzlVQjNhbFVNdEZGSDZURVErS09DVnFq?=
 =?utf-8?B?RVI5N2djNkZwQ0JjWnhFOW9zNDVmRTlIMWdEN3cySllJZU5NeVFLS2lwRzlh?=
 =?utf-8?B?cGE3eC9wMHRvbmhJdml3eEloUzJCTDhqNlBmOENERzRoUllvMWxCUW9jSEpz?=
 =?utf-8?B?NlpLT0I5Vzg0Z3VVSWVpVDhDUEtDTWNNcmh0VTFVMFF6OGpyUEd4U2hGcTMy?=
 =?utf-8?B?bjVCa2pFa2RYdVc0RC9aaDdBQUFwSjJWelBTSjUyRU5nZkx6QzByRDR0ek05?=
 =?utf-8?B?bW1xN0JmQm0zS0w4TUVsSnpQVVZsWi9CSnV3OW9lY084ZGxDUjQ0NDcxc1BL?=
 =?utf-8?B?M29QK2hyUG1nYXVLUFl3TkV5cmZpVUZydzM4dDZVOHduOW9wMCtUejIxRjJH?=
 =?utf-8?B?enQySlpQT2JIUXBXbFBMcktXeVoyUmpTZGdwY3pMd3VBbkVKcmlFTDh4Mlp6?=
 =?utf-8?B?eVZDaGEzUlBpWVJWL3IzZmF4Y3JmR2FlRmNyQVFzYTZ1YlQ1SFpmWTA3NDVv?=
 =?utf-8?B?SVVUdzVTQVFOVCtlYmNvQWJ3T2NlaE4yVTVhNG85K1pjRGpNMlpJcVNTaTZU?=
 =?utf-8?B?eXlzY0N2bjlhdUdXNTFTUXpNS29kNURoNUdQRDJJL0tHbVlTZ3FUVGNxZElO?=
 =?utf-8?B?MGEyVWcwTzNldERra0VUeDFYMkwveEJ1QUJ4ays4MThEQWlTTmppd01uSUdD?=
 =?utf-8?B?a0hPaXRvWDdsVi9peHZBeU8xK1NGS0svUHB1VC9tZ0xsV2x0M0J6L0N6S2NX?=
 =?utf-8?B?NFA0cTRtWGFQRGZTTHhlQjZTNEx4UXAxTXJuQnMvcG9WaVlHVnJGZHpaRU1m?=
 =?utf-8?B?QXBrSnRNUFNQaGpjWUdPVFpqYktGa1RtWkJhbTViU0l6Qm11Vi92TUVMdnQw?=
 =?utf-8?B?Y2tKYUpLeXpnK21SRXRJRWhXSHh1UGdaMzVpSEM0SmpMdWcybTlIMDhHdHlN?=
 =?utf-8?B?MEltVXQ0ZkdudjNnZk9oNEo1L0hOQnlZbWJYckVWOFZQSUxOdEJWS2ZTblF3?=
 =?utf-8?B?NG1lenozOTM4Sm95NWdoSjJtTzlkWnZEaUdCbDRoRVhJRFhYdWxpQmppQ1Qx?=
 =?utf-8?B?NnVZd2hQaThWczk3ZEZ5cGsrbXFjbkgyU0R1ODhJcjFwTEp4Q0xleWU3a3Fh?=
 =?utf-8?B?SzNWQXdqazluVDRvbVZVY2FrZVVtNzd0dmFONUtjZW1BMVljczdLcjN2dzBH?=
 =?utf-8?B?bVZvTTljTSszYlhaaWpiczdFblp3WXF6NjZKMmM4M3lFQU51eGhYWmRxUXdS?=
 =?utf-8?B?bjNsUTcwQklPd0JFQk5uUSthQVY5Tkx5cUUyV3plbEFDbWlBdDlLZDFST0Rx?=
 =?utf-8?B?bjZNMVJRcFJ6c05zU1I0WktjNEdMS0Y4RFVKQnRoSWxQSjFvNkdRUEZjY2da?=
 =?utf-8?B?c3JUMUNnWkRLQzY0cXA0WFIxUDNhYkh0NURGWnNiTnFBcVQvMnoxQ3RQSGt4?=
 =?utf-8?B?dE1EbXRjYkRXQytqY1krRyszQlZBYlF0RTUxQ0pzN2gwWExsUmNISndTZDNp?=
 =?utf-8?B?YmZJcDUySXlNWXNnSFBkbW9nTFlpakJ1RUliMnVoUUozaXR5dnNrUGZuQUF1?=
 =?utf-8?B?N0l2MVZva0tFQzIwWmNXTTg5ZzFQeG5MazZlM3ppUis4Y0pvcWdVaUdpQTBD?=
 =?utf-8?B?eFVjRU1HVlRVZEdFRjlQb2NjVVRQNDhNeURmcE95R1cyTU00ZU40dGxjZy9s?=
 =?utf-8?B?RTd6eGtTNkpjc3doODRKa0ZIUW0yYWNHRGR2SDRNWkVTajd2Nyt4ZGtnTXlE?=
 =?utf-8?B?ZWFEbzFIUDdzMlpqMmZGS256bVYvcDQ4Zlp5TXRDZ2VhaVRkNUZzSUFpRUJ4?=
 =?utf-8?B?bER0MENLUzlsTnRCYm5EcFRGMXNwVnc1SnlWUUFqckpiSTgvNnpKVHFZeDYw?=
 =?utf-8?B?ajdBQWlaRkRDOE03Sm9xZkY3R1RjbTQ2TGVJQXdxcXFrZFI2dTRaTU9xN2dT?=
 =?utf-8?Q?B1/qCtLr/aHxh/q4=3D?=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qXHaEJ92atLTg8TImgEsccjQy+mD5pssnZbqowTAYyeEAqOdbUr8VrLEw9V8A6Kwn79GhTmqBo0lu7zsJgs0BOGZgh2bJtCJNQ55B9tkE3Ngj3KCSlXABWrB51r9L/9LrPQ3MMlF8OeNxKXMPUPON/P45d2gEuj5U4+wKiuWijqnV0LT1MAh6ONXQyVDroySN6fYCQmizkOAr5YenJh3j43B9Md9t0ZWwXTjO9EHL+/Y/g5kzfT6vdq41fGnKcGqZcsmYbnJh5Vf1BgvmdypCvQX63NZu7xeoZIHoTlDypGDsJIZQL+y0YAJuZLyK6FNtruYIfVqeuNagAWrwzwsGg==
X-OriginatorOrg: onsemi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR02MB3369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2adbc287-ff1a-49be-646d-08dee812f8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2026 17:02:11.3504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 04e1674b-7af5-4d13-a082-64fc6e42384c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /z+a95X3out82wiB8jq2K4jgyorBpFEWKQU2cHVjC5jlTCxnF8Vs9rAsreayN/urAZGQatrlt+EjCnKdauWeWoEs2lQoE/B904JVG+b1Da4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR02MB11444
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yE3jBcT4FxIlhxG3Z7fEAvbuznCqSZn_v8tRJX_oMSw_1784739735
X-Mimecast-Originator: onsemi.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNhc2hhIExldmluIDxzYXNo
YWxAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBKdWx5IDIyLCAyMDI2IDk6NDMgQU0N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCA3LjEgMDgwMS8yMDc3XSBkdC1iaW5kaW5nczogbmV0OiB1
cGRhdGVkIGludGVycnVwdCB0eXBlIHRvIGJlIGFjdGl2ZQ0KPiBsb3csIGxldmVsIHRyaWdnZXJl
ZA0KPiANCj4gSSd2ZSBhbHNvIGRyb3BwZWQgdGhlIG1kaW9idXMtPnBhcmVudCBmaXggKGEyMjFk
M2Y3ZTNmMykgZnJvbSB0aGUgNy4xLA0KPiA2LjE4LCBhbmQgNi4xMiBxdWV1ZXMuIFdlJ2xsIHJl
cXVldWUgdGhlIHdob2xlIHNldCB0b2dldGhlciBvbmNlIHlvdXINCj4gZm9sbG93LXVwIHNlcmll
cyBsYW5kcyB1cHN0cmVhbS4NCg0KYTIyMWQzZjdlM2YzIChtZGlvYnVzLT5wYXJlbnQpIGZpeCBp
cyBhbHNvIGFuIGluZGVwZW5kZW50IGZpeCBpbiBjYXNlIHlvdSB3YW50IHRvIHJlLWNvbnNpZGVy
Lg0KUGFyZW50IHBvaW50ZXIgd2FzIE5VTEwgYmVmb3JlLiBJdCBpcyBnZXR0aW5nIGluaXRpYWxp
emVkIHdpdGggU1BJIGRldmljZSBwb2ludGVyIG5vdy4NCg0KPiANCj4gVGhlIG9uZSBwYXRjaCBJ
IGtlcHQgaXMgdGhlIEZDUyB0cmltIGZpeCAoYTVhMWQxMWRkMzcyICJuZXQ6IGV0aGVybmV0Og0K
PiBvYV90YzY6IHJlbW92ZSBGQ1Mgc2l6ZSBpbiByeCBmcmFtZSIpOiBJIHZlcmlmaWVkIGl0IGFn
YWluc3QgeW91cg0KPiBwZW5kaW5nICJmaXggcmFjZSBjb25kaXRpb24gYW5kIGNyYXNoIiB2MyBz
ZXJpZXMgYW5kIGl0J3MgaW5kZXBlbmRlbnQNCg0KQWdyZWUuIEl0IGlzIGluZGVwZW5kZW50IGNo
YW5nZSB3aXRoIG5vIHNpZGUgZWZmZWN0cyBpbiB0YWtpbmcgdG8gb3RoZXIgYnJhbmNoZXMuDQo=

