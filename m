Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022115.outbound.protection.outlook.com [52.101.66.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF80363C79
	for <patches@lists.linux.dev>; Thu, 21 May 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377318; cv=fail; b=s0TM5aFb+Xt9UHd1QvQQVKdbRM0KvdLPyGDcOLtnHbw946+G5275vLgZFzQJDdyGbBnPn6v8AcdGFbk6+W4ZeI87N/AGwzs5MrP9hCAQp0rAHvl3szQNFXe2ZrUt0gO0twfCxqgwJCwpO3O1KraKa+DQj1OpV1lt11c8dtLam1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377318; c=relaxed/simple;
	bh=2KL58sH6OMto/fbKJShSyN9huWxrk4Bqhm2PXNjNO3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Max/Aql9jn7tJX8kn15WSq0s/qVcXxoKstMcJj+uyL5Z0A9nTlpJvQnUYoTzzQulXyHiRlJHPhxkjijNWLyj9lUUkzSP/8bTwp6BUojlugdf2jg1aTdezugHzBMT5nITXPH3lvO6MDBprZDKPJA9U9FTx2DFtCE5ZB637RbXjNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=polito.it; spf=pass smtp.mailfrom=polito.it; dkim=pass (1024-bit key) header.d=polito.it header.i=@polito.it header.b=GPsPMt5n; arc=fail smtp.client-ip=52.101.66.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=polito.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=polito.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=polito.it header.i=@polito.it header.b="GPsPMt5n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnL8X6OyJVCA6u7v9MY3byYqFtOO+5EvQp/zKFw1eCP+ofgttWYJfry8QNZdPFWR5DJTqO7el84cGEK4OEl+KCvPGQYrrRTBGIzoZj2yu4IUKpVuWcPe0YjhPrf0RnBNcLHYXdS9VkrsRhHvI2w+Rhd2ulb1SVIW9+SZFhl5hYfDOH9wwrOALkS8+UBLiZEuGiSGqD0XD+o2bwcm+39ycQiOVzld0qayY4ShUHZDKeQosovi1FsEpWddmzUXvHj6na6wsqrVpp4miEVVfutc8e50y+vObNk2Ww3+nqLyACQ2c4HasWDUCHHjYN7A/hRdZhXkaVUPqXQQi14ujxyHRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KL58sH6OMto/fbKJShSyN9huWxrk4Bqhm2PXNjNO3E=;
 b=kf7yoABeidApEXfpoqFGxAxsqXWlHOgeB7TkJXSMnxc5YMrkvyCuVuTSYmeq+eFDNjIf0/HkndgW1rVF9VSIlWovmZibqRiY2pfF0NaPBWL7z93MUprZQNwosC8sXjbrpMv2LFYfPj1QwJWd0nPv7BxbP9m9ZGljC9EI7qIqXSBDP6UhyrNlicWaQZ2H0X8qqugAnhWkqiK0weH11MqRrWtY0wuNUxGoHRnFn+jKYaXw3GQD9AUWeOg5fruhXUpY1+tt+BL4DKCzKbfnmbQCQEk6T6/pj9HFETRBsN6pSZ+0yuj8K6HdBFCzxt+3S/ndJCHolSqvVG4eguCHeDqM6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=polito.it; dmarc=pass action=none header.from=polito.it;
 dkim=pass header.d=polito.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polito.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KL58sH6OMto/fbKJShSyN9huWxrk4Bqhm2PXNjNO3E=;
 b=GPsPMt5no/Yr4tCSaBamkZ6rSDRlYmgujtM6Q9MAyHcir3ykij2wqnbEyJ4fqa9wY3D1S/QpojTT6AG3ETZ06kUifSGC5I3J3EQwA3k8nemQuShBLD2+9e8GzR7TIhZPkB0WNVCWo9E7a8zOPEllEcn0MPaFDs5e6QOqtXkpHqA=
Received: from AS8PR05MB7880.eurprd05.prod.outlook.com (2603:10a6:20b:253::20)
 by PAXPR05MB8269.eurprd05.prod.outlook.com (2603:10a6:102:15a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Thu, 21 May
 2026 15:28:32 +0000
Received: from AS8PR05MB7880.eurprd05.prod.outlook.com
 ([fe80::b739:4a27:cccc:cd64]) by AS8PR05MB7880.eurprd05.prod.outlook.com
 ([fe80::b739:4a27:cccc:cd64%3]) with mapi id 15.20.9913.009; Thu, 21 May 2026
 15:28:31 +0000
From: "Enrico  Bravi" <enrico.bravi@polito.it>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "jonathanh@nvidia.com" <jonathanh@nvidia.com>, "shuah@kernel.org"
	<shuah@kernel.org>, "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "pavel@nabladev.com" <pavel@nabladev.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>, "conor@kernel.org"
	<conor@kernel.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "sr@sladewatkins.com" <sr@sladewatkins.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, "hargar@microsoft.com"
	<hargar@microsoft.com>, "achill@achill.org" <achill@achill.org>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>, "rwarsow@gmx.de"
	<rwarsow@gmx.de>, "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
Thread-Topic: [PATCH 6.18 000/957] 6.18.32-rc1 review
Thread-Index: AQHc6Q9UDzTIV8ORTUqn7jXpCn+j17YYmtaA
Date: Thu, 21 May 2026 15:28:31 +0000
Message-ID: <59aa899745c980f74f422ac63bca106fd6173e66.camel@polito.it>
References: <20260520162134.554764788@linuxfoundation.org>
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=polito.it;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR05MB7880:EE_|PAXPR05MB8269:EE_
x-ms-office365-filtering-correlation-id: 8f1200c5-e2d2-473e-f7dd-08deb74d9db8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|786006|366016|1800799024|11063799006|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 8cRwbM4KCRJV+cz8O3vaiSw8Wk8Bv1PO3O56u+dUVfBCjgisdevp35VXCNhXQkEHoM3xfvxVa4k3rJg5Ix41ShmUGJe0ykBKy34wyJAqp1N43+UQ/DJWbWmhjXzvUEuMWbZmzzDHsLtnQTtpQQbXPTF5V8RkiWgYFW6pzjYg//cyo8+/U0olxfpC2QZDE1VCgB8GsjZeMMhn4K/SD7OfUol78urlf+DKW+pwjvvOkLo+bFpv9nWraHhp5HmfcIPdA4Es3s3C+qjHuDS8JaWvEmrEF2ov+AbXuO1/O/ttdjU3+UO2ZB2NuVvvSs6H2tytmnnaHjpUalsWl4wxBOx1eEQ0v+Ja9ztBopP1n5ED4mkXJmbkezcxr3svjmT9DAxp14QaaIaXlo7plT4PGfFDewQcbUC1Jv9GGvT6anJxcCtp9GYmT04YktWdVNdk5reftVuVm2aRNm7NvdYPx2/LxbvVc2qy30gC+5k0w0xJblIcOvJ4dil7d++SPYEY3UriwNc6gZGgcXl5cppzJ6FhSCmOK7ogW3ktD3wV672TINJ0Rjkl474kT29EDbj5sBtmoZfGucXcljqvil1zt39iEqSX4b1MrII/bEjP3DqKbqFip24gNc7v0CInL116YWMKhwAYens7CTo8RLI4BIcEDORA3XLkP5NitJfLZmHLQRp3iFynyIqxdAm4X3d7W1FGUQ38yKaA79jISFeoszgFabmz1I5lePQN28ZPBU4j8wn1e/bR0QS7A0cQnLqdExZP
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR05MB7880.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(786006)(366016)(1800799024)(11063799006)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V0dsb0xvVElIQTJYRXBNUERvd2JMTGJUdXpnQ0lqVlBaM1pBaVNSdWZEcUg4?=
 =?utf-8?B?WVF4QnhQQk9haG8zQW0zdnlDbGdjbXhwRnBtYU5ncHpST0FwMk90bFdTVzVa?=
 =?utf-8?B?WWl0YWU2a1BGcTJrQWpKeHVrNFhTQ1hJbm51TS9Gc01sLzJ5djJka3VGZ3I1?=
 =?utf-8?B?WnpvQVFNeUNxMk9HOHA5ZnIwREo4SWNPRGdzdTdqWFlUeEFFTjRWU2E2blpn?=
 =?utf-8?B?TXg1NXBGSXpQMUpQc1E3VDlNTCt0T2FSSHA5M0VtWU1HaENZNUxZS1FmN2w1?=
 =?utf-8?B?ZWY5b2pLREIrdGRxd1VCUlNuZnVJWkl6ajVSdUVQYnk3RnFwNzRlUmRyZGNI?=
 =?utf-8?B?aFBZUlU2SXBlSzN0dGRwR2dJTk1YbnptQlpmVk1Ha1FCUGdkeExSUVQ2Q1ZR?=
 =?utf-8?B?QXc3bjNub0FTWG1zZnp3SHhtWjdNRGFMNWJYOUhoSlBZSlBVL20xN3RuR2xq?=
 =?utf-8?B?RHBYMWhJSTNDS3Q4Z0J4S2Q4RzdhSS9hb3c2RkF3YnowK1lCMVVHK202KzJi?=
 =?utf-8?B?UE9qZDRjYlJEKzZqd3pmUEhoQTlRcVdSWExOQTRhd3RuT2pEdDNoTUhPUXh3?=
 =?utf-8?B?Y3l2MGtZalA1NXdrWndXTDJzODI5R3JaNm91N1pUK1l2S29yNjBvODl0RUtN?=
 =?utf-8?B?UWx0dXp3K1JVUDlKNEcxYkQ5enEySmFOcjc3YVlpcWtmbktxWXFDaFh0M09Q?=
 =?utf-8?B?S2RwUzIybktaaTZWTitmVUZEQ1lHZFZETEk4NTJsRTllYW9vQ1ViYlBTWVRm?=
 =?utf-8?B?NktjVHVncFM3Zmx5Qnp4ZlJuRXNLV3BkQmxic2p3RDY5TkhSSTR0OE82Skt0?=
 =?utf-8?B?WE5BOFB6RkZGSGZaTnBGakhqQ3k5Q1Y4elRicVFaV3lvV1FERW5pRXV3Ym1a?=
 =?utf-8?B?UTczTitYSWJuUzBleFJNZmJnc0ZUOEg5RjZNYmtqemZZb1dJekF3Ny9qRnlV?=
 =?utf-8?B?b09PQ21QbUxQdGZCZTYwTW5SckwvbDJKQWk1cTFMM0djYnpEQjgzWm11NDRB?=
 =?utf-8?B?d2E2Z2JxVnFLL3pIalk3aVgrUGExN2ZGVzU0YnVxY0x3cWhVMGZOUjhjdUZQ?=
 =?utf-8?B?eEl1cURqNDdnVEEzRlR0a0w3cVplVU1NbWJhLzFhemh4Yi9CT1loODZoK0FQ?=
 =?utf-8?B?Q0dkcXoxamtGelRzckI4SFo0RXhIR3hOb2J0WkdJRWFyWG5Icks1WklCcTVh?=
 =?utf-8?B?YXdaek9uWXhxdlIwT1NXckkvM1Z5eWVZR0xrdlZJZXZUcnNDeWFtMTd2TmNh?=
 =?utf-8?B?U2NtWFBhQ0dBU2dwUmkzbnZ5L0JQanI3L2lTVkFLY1FuL3NDY0F6MUd2MmxO?=
 =?utf-8?B?SXdWa2grTXRTbzBiYnFmMlBHeCtHVjc0YVhITGJWT2MwUzh6MmFtVnFMT3hD?=
 =?utf-8?B?aHhJcG43eFM3RGlSeHVtWUlwMHdZTktmQlEyTUlMTDJnSTBtcjhDN2VFaGY0?=
 =?utf-8?B?OVp1c3JXTHpHTDgwSFZjNTNCdlNQSHdOUlhWSEJjaUNWeEVUbDg3VkF2T1c0?=
 =?utf-8?B?YURBSFp2Yi9lUXpETWhyc3ROZEljOGJJVVV1RnhrVkE3RG1LQWFHcnJhcXh3?=
 =?utf-8?B?WElBTUpmOE4zdUlHaGltTkJvQUIyaXZoaU1WMG0ybkl2a0VQRFhTZ0Qzb0VV?=
 =?utf-8?B?a1hCZlRJRnZuZFVwWEVzMFJac1BESDNaZ2Vma2tYenRDZW4wd3RUZlQwU0My?=
 =?utf-8?B?M3l3Z1dYWVZVdXh1NlYwSVlJTGZndytDWHdQbTdURTREMWZyR1l0T0xDQzk2?=
 =?utf-8?B?MjFJdW4wUlNldkxUbHJWRVFYaUQwMFo4T3RubFNFcEFOVzdJYU9RSUtubnVH?=
 =?utf-8?B?dTU3OFVjbHlLSVQyYnhtVi80S1ZDeXBWaVpaR0V3cXVRVHU2TlBxSlVmVUhJ?=
 =?utf-8?B?eW45anQzR3JpL1pqNWxIRlZ5UGxqSkIzaFZQbllCcTN1MHUyR0xENlpBRTV4?=
 =?utf-8?B?YWJZSmwwZFp1cDBkRlRBcHhoMElCNXlYQjRwNjZiZU1rSlg4RGpjTU8vTncv?=
 =?utf-8?B?RW1zaEFzaWY4b2NnV2xDWFVDeThzWm13Y21lYmVhcE1kL2UybFF1UUgzRHRX?=
 =?utf-8?B?N3JXc21YQlhpSkpRNXhLSFl1VnlUQ2NxZTF3cGdwTWFndmtwWXdyc040OVI0?=
 =?utf-8?B?VzN6a2IwaFZoa0cyMWhtbzBUMG5YRjV3VTVBbU9sUCtEV1FCTnVPdzhDRXZW?=
 =?utf-8?B?MTNvMUE4cjRKSldQWnpJQVVBMXFGUHhKdnp5SlVDTWdIbThnTU1ibVRnNnNT?=
 =?utf-8?B?REtON2VYWFNIS25tc0lqRFJBRzJEREJKWk9oTElsRWZjUjdMTlc3REtRejQv?=
 =?utf-8?B?dEp5WXlJK2ordHhOWVhOYzhCdkFlWTkwek1LYTY3ZkNOc0VSSHBGVnFhZzda?=
 =?utf-8?Q?U4gQ5pTeJi1f4kFs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8520D82C6FB6A941A9ADA383C3A2F491@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: polito.it
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR05MB7880.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1200c5-e2d2-473e-f7dd-08deb74d9db8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2026 15:28:31.9132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a05ac92-2049-4a26-9b34-897763efc8e2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V2CSoBK8MUO4A7hfRvLkMspK2fl7FCZDXJP19YJ/cc7aowfOvOC3KojK0Oc17IByUB9uSgK6kWO5DiwNS6OCUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8269

SGksDQoNCk9uIFdlZCwgMjAyNi0wNS0yMCBhdCAxODowOCArMDIwMCwgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOg0KPiBUaGlzIGlzIHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNs
ZSBmb3IgdGhlIDYuMTguMzIgcmVsZWFzZS4NCj4gVGhlcmUgYXJlIDk1NyBwYXRjaGVzIGluIHRo
aXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9u
ZS7CoCBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBw
bGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkg
RnJpLCAyMiBNYXkgMjAyNiAxNjoyMDoxNiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0
ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPiANCj4gVGhlIHdob2xlIHBhdGNoIHNl
cmllcyBjYW4gYmUgZm91bmQgaW4gb25lIHBhdGNoIGF0Og0KPiAJDQo+IGh0dHBzOi8vd3d3Lmtl
cm5lbC5vcmcvcHViL2xpbnV4L2tlcm5lbC92Ni54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNi4xOC4z
Mi1yYzEuZw0KPiB6DQo+IG9yIGluIHRoZSBnaXQgdHJlZSBhbmQgYnJhbmNoIGF0Og0KPiAJZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC1z
dGFibGUtDQo+IHJjLmdpdCBsaW51eC02LjE4LnkNCj4gYW5kIHRoZSBkaWZmc3RhdCBjYW4gYmUg
Zm91bmQgYmVsb3cuDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0KDQprZXJuZWwgYnVp
bGRzIGFuZCBib290cyB3aXRoIG5vIHJlZ3Jlc3Npb25zLiBUZXN0ZWQgb24geDg2XzY0ICgxM3Ro
IEdlbiBJbnRlbChSKQ0KQ29yZShUTSkgaTktMTM5MDBIKS4NCg0KVGVzdGVkLWJ5OiBFbnJpY28g
QnJhdmkgPGVucmljby5icmF2aUBwb2xpdG8uaXQ+DQoNCkJlc3QgcmVnYXJkcywNCg0KRW5yaWNv
DQo=
