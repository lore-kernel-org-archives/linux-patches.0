Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022104.outbound.protection.outlook.com [52.101.66.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A3D3CE0A8
	for <patches@lists.linux.dev>; Thu, 21 May 2026 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370151; cv=fail; b=rN+c89TjZOR5BhMhrAAW7nJndNr0knKb1QDha6rriNtXIJr9/yRmqO2t7gpYVKs4TKkmXYNPwhNIBAgsllwCBT4C1ykQm1+fD9D05t1Krto0mp1jaHqRuiT8nazA2Pc0lvZDqBymyN3haH4kY9oP+3JFhLq8NUMaRuHKglDYwvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370151; c=relaxed/simple;
	bh=/Oqd06RaJpn7XlvV384+SiQIEkCzRPvfdGkZfdm48ls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U54r5Ulwx4Y4X3zJSDKJfcqS3Vd5lULOoYtp77iQUDaGsqAiABiCsjdC0kw2HEltXsMVZpVa8nHDF8kcOXtb+99RrMdYE4awS6ZEUwjY8pQCBQeazHyNxt/IBjQJTvPUtT3o4iJ2vyEhOezPamCrSsCWOLA29Mzcu7u2bcFbawo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=polito.it; spf=pass smtp.mailfrom=polito.it; dkim=pass (1024-bit key) header.d=polito.it header.i=@polito.it header.b=MszHyRQq; arc=fail smtp.client-ip=52.101.66.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=polito.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=polito.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=polito.it header.i=@polito.it header.b="MszHyRQq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3rdmwRXRX14vBEbr0tnJhoRV07RDtfDCbnU1BiOB/qBeMvNMO2EqS0tr/WTopI/yVuzKUUZuCb6v/94R6yqborO4NWYIOWca9euQ4Gktj6qkcWTb3pOOfA7hETNpRfWOH4G051yPeEWiPrgxsHXIWqkuEW0JtpofJbwjoWU45cOIY9TjdM6c3fkKzNhgmsS42JdqbGcMZLh4YOgAU6YpgO+PeTBwr0SmRwZ8qxnWqJiAWxTGTfeCG5XiCYUHakZ1Z4JqaTf7sCtdcNEWw1alJYafk/YOQqn7vcF7OmvsGLxg0LfO6KXKm9zxFWWvboAFQ+RX8cOJTsIJCwQcLlr1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Oqd06RaJpn7XlvV384+SiQIEkCzRPvfdGkZfdm48ls=;
 b=mfWt4RdLs9vpWMySr2Wx0d22UbShlHS8Ms+xMyrQGsVpkjZtMvLaTeIpUyjOnY4E5pXLKPJTebh5nQZMYjrh5rTnK680j4KbCZkaLf3L0DF75VidUnr0QYskPYxzOtFlCvPF61sn7yWWcSM0KvVgfptGqzvqvK/3kCFIjpib8b+k1W4pUo8lzzreiYeSMxYE9cnm/9k5Ow7WMriEviG2ywurgCIpLaco0FAsAhNxgi5w+MXzN6s5UElQiipJCU39YWzJGRLbDn57pelIOo5iNmhEmP98eyR+Wcj+0vf8AvZux/PFkUuCNvwvBfnU6Y49zZH9ZEi9D5eIDcvdZjISbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=polito.it; dmarc=pass action=none header.from=polito.it;
 dkim=pass header.d=polito.it; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polito.it;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Oqd06RaJpn7XlvV384+SiQIEkCzRPvfdGkZfdm48ls=;
 b=MszHyRQqekJxOlkSYiSzjgC+NC1uUE1MmhZ+rhHvs1oPcwW+vGj/iT1yHEtbqkhP83jiMcB3HiNkU3udVZ03/T6jRQJ1XOio6Wi47Bvgzl7XOmXRXvT3U/RufOnV1Mh7yokE8UPYe5kjdyD0CnYVwNZpm3EqWaqqy2D+T8bUgLA=
Received: from AS8PR05MB7880.eurprd05.prod.outlook.com (2603:10a6:20b:253::20)
 by DUZPR05MB10973.eurprd05.prod.outlook.com (2603:10a6:10:4e0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 13:29:01 +0000
Received: from AS8PR05MB7880.eurprd05.prod.outlook.com
 ([fe80::b739:4a27:cccc:cd64]) by AS8PR05MB7880.eurprd05.prod.outlook.com
 ([fe80::b739:4a27:cccc:cd64%3]) with mapi id 15.20.9913.009; Thu, 21 May 2026
 13:29:01 +0000
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
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Thread-Topic: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Thread-Index: AQHc6Q6Fo7XJSFPLLUaAKHf4UNRNvrYYeXMA
Date: Thu, 21 May 2026 13:29:00 +0000
Message-ID: <0d67203ea22a7e63018ec8faf64ed2926a35b217.camel@polito.it>
References: <20260520162148.390695140@linuxfoundation.org>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=polito.it;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR05MB7880:EE_|DUZPR05MB10973:EE_
x-ms-office365-filtering-correlation-id: e9507cd3-117a-4ccd-53c3-08deb73ceb7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|786006|376014|7416014|38070700021|56012099003|22082099003|18002099003|11063799006;
x-microsoft-antispam-message-info:
 VdRSyBlQUHTiuiWjqDlQHCcwy7jl2IHZEa1o3x87MhPAVBJ19LWtiYqYJOfxpF4cb6bMjn6/4nMNVscUcv2RE54Y9ow9vwV5joF5UUU8XgobKm+wzkr+NYS1O8mn7/KyqapU6rU+P/t56zDhHqK2sp9gydMQ42Cfe6BHmGu4o3Rvhmhnejyl+P4TaMnaEqApgmIL6IIArUtPBLC6HBIM8aqzk6WhdBMB6ZhB52pIoBL9z2QJ3R5f8KCPrbkNQ7r3YMKq6IfedgvWyVjcZImowc+jEhbMnXPv29wZhYgKcGhQqwVnL92jgr/dmhfjAPPNetP0H92re6hoyso4AtYTWGjQUSB+SkHmgOt7c7ywVKXE72GH0D/U7eQ0IneVf9Jrameed2JXz3cS47EQk1eomK+12RjaujtNpxE2XTCeB5mrNCW6TseTa/HWJS3r9kXjaEP1FG4XORWawjXHeAqSkmIAT0yQTvcbc4B9QxE97cUkd1aL3EiROP9qJPrmLfcYQph2LOR/1BbxVOFPft9V/vz2Ek0HB4569jcNLkORedMr8rVi/rWFiSUfV86aVEDcZ6+k9LfDNBC4oKk2mP9qCJHWFCtBWzbHYx7pQKebEzVoDE1ncg8DToSy2EFngXZPMF2OuR2MyYS8/ztArFaly1PHnj+o2wMOxgwWYVQv4UKS5fnAmM2Hd+z89xG7SL/BSELLLbAZYsKiv+srX2idpJsT6yqsngU2XHYHiDMWBnq7m3BcZFWbt9+k4w1VDoSl
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR05MB7880.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(786006)(376014)(7416014)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Slp2SUhSWi9qWFpsRmFySTRITXFwUnV2QTgyU2xLSmVmbkJ3aFUvdnQxaTJM?=
 =?utf-8?B?cHdxMVJtQnpJNWhUTytxQ0RZckd4VFNRREhrelhuMnplZzdIby9rcmR5Z1R3?=
 =?utf-8?B?T3FSKzliNlNuSDdOLzNlS0kzY3JvVTYxRytoNjVxRjUxRWUxeW9GM0FKQW9X?=
 =?utf-8?B?RG9OcE1Ja0pWRzlQbjdSV1p5dlpEMzFtS01aNUVhSnkvcmRVWEpxYjN3Uk8w?=
 =?utf-8?B?NUg0YUtEQkVMaS9ueVp2TG1FWVBxTnpQSERLSEdUUkZKM3pEdGtzRVAvVmh1?=
 =?utf-8?B?RDU0NzJlUW5ESGlENWgxQXVpVEVqMlI1dWQyclRHUFVHMXUrT1RNTDZqVk51?=
 =?utf-8?B?V3R4M3N1TjhrZVVmQlRsZERWaTBlWk9USUFpT04zRDNYZVA3SEl3cmljeWhz?=
 =?utf-8?B?Z1gvMDBHbzRTdDVmS1lFVVFCakJmQjN1bHBZaDJDSjVwUnIyaFk3MzA3YXZ5?=
 =?utf-8?B?U2FGK2U1a2FwZnVFUkJDWUdSUkRIMjNuaTgxN0Flb0oyVWxmOFZTMVhocXR6?=
 =?utf-8?B?RzRJWXZGTjlOWnNaK0RJZE43b04xc0I0RjNocHAvZFNJQUNSNXdVTzNkL3U0?=
 =?utf-8?B?OG5rLys5b29na282bENRL2d0ZVMrNlBiR2V6N0o2d05yUGl4ejZ0UGU2ZTVK?=
 =?utf-8?B?dHYzekFTNmcvNGdFSVo2ckM4NVhteFV1aC9jSFBySU5mTEJuU1BSUkkyZi9S?=
 =?utf-8?B?dUxRenAxSDBKOEJFbWhCY3hOVmlRWEQ5QVE2d085QWlJZWFUdXQzSURiRHNx?=
 =?utf-8?B?K09ZRVNka2RTQlVUZ0FOd1UzNUNQTVFNWW5Ibkw1Y1c3bW4xRkxTclVCR01o?=
 =?utf-8?B?SnZTTFFkYXhiVGdCZTZ5aU9hZ0hSZWN2OEkwT01pbDR3MzVjK3F6eGlTKzZy?=
 =?utf-8?B?UXpHcVA5NEFMTi9Hak8wMGJsRjRkOEtWUVdNVENHZXdZZC9ibFhtNEdlNjdQ?=
 =?utf-8?B?ZHdwdURSZTBaRTBDdW5ISHZYUE5CU0hVQXlScDB5Q243MVJmT0FZY0xycm5M?=
 =?utf-8?B?YXFQRDJ4ZHl6Z0FHNTVSM1pkQVRhWHdSRzBma00vV1MyMGg0Yjd5K2V3VUxa?=
 =?utf-8?B?dy9pYTRqQVBHQ0h6NVY4L3liRmxrWi9DMm1Ick0vdFRVWjE4U3pBSmRUU3hY?=
 =?utf-8?B?OHFXMlNSdFhRTjhIbVVZSWkzZFpHWmtPRVk5WUNSMUhydSt1WWduWjdJTFVi?=
 =?utf-8?B?OUtlb0Q3d1NxY3VabXVydk50aTJBc2lVWHc5S2NhT1AzOUxMU0lna0ZoLytK?=
 =?utf-8?B?SStiUW01MTljblJmcnM2amRpRUU3YVhBWFpPREgvdFJ0MFBGaG00amVQQmJa?=
 =?utf-8?B?WVdsVlIzNDNZTkt6bEhlOXhHNWlWVENSbzFHdGwwRnpOSDUxZXd1a2tJeFFB?=
 =?utf-8?B?THhVbWRiVjNsc0hYZjNzZk4ya1h1aVllK3VFUUdpd0JwSGpkcmdJeUFBem9G?=
 =?utf-8?B?NkdiMDNFOEM2aEtueS9GMDhiWjRTM1lIQkZzYVFtb2NMUWpqcjE0aE5zTnJT?=
 =?utf-8?B?bTY4c2xwcDl5dUxsYzJmR1dtNTYxTXR5QXp4S3RIOVNWQ1pyeHZKdURDeHA3?=
 =?utf-8?B?VWtXNjc1cUh3cVRINkdFU2psMUszcjlGVGFIVWsyOHJXTUM4eXFPdzVrR2lJ?=
 =?utf-8?B?NlExYi9PVzhBQXloL25CbGN1KzhRTmp6MlRpZUtWM243WjdHMm5yeTFOS3hV?=
 =?utf-8?B?cE03d01DZ3NWQTNTajd3ZUVKeHkyWmF5MzVpZStmUjNxaE9xZEFVNFZvUFhE?=
 =?utf-8?B?ZHBjcjVDRUlKZTJaRHBSUVFQZTAxVmM3NnZiYzY2eHZFV1h2V2VzQjR5clg2?=
 =?utf-8?B?ZEJWZ1dQMmw1NnhibEk5VGtwUVlac2czQ2FlY00zbkErUUVjL3h1Ymh5NlZF?=
 =?utf-8?B?cmU1UXhWYWxGWjhVTHNvMDUzbnNtbEg4L1V0YVcyWlE1cmo4bUdFTEN1Rngx?=
 =?utf-8?B?OGFFRS93b0FhYkZpSVRnRGdqM2pXamo2TTZOcGRsenczVVo3L3MwckF6eE84?=
 =?utf-8?B?WDhtOVFYTU5zUGdlM2ZzQ2lQWjdBa2lQZUQ2eGJLOHNVTFF1TkZ5b2tLcGUy?=
 =?utf-8?B?RUluV2FId012YlZKNDg5dVlSZS9JaVlwTHkwNjdkTUJhSnJ4VER4ZXo3RlNS?=
 =?utf-8?B?Z1N2VlZWNDg3THN6bHZkaXpCV0lUenJEb01qSzl3cllLUUF2U0h5eFJKU0xV?=
 =?utf-8?B?WnplekxiUExVbW1YVlZGd2tFdDRFYmpQMEVaeGgzS3VkYWZIRnRmclhpL0Jt?=
 =?utf-8?B?UFdkbHYxZXJKQkY3b3EzYUVVZ3gvQ29hbTlzc3N4MzAvMTRSZjA3VGM2UnZj?=
 =?utf-8?B?a01qWkkxVFl0VEJac3BZVGJJOXFUdk9wdDZQVm4rLzI2eElTMWJpdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37087E5B6972E049A8EFA9618E574EC6@eurprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e9507cd3-117a-4ccd-53c3-08deb73ceb7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2026 13:29:00.9635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a05ac92-2049-4a26-9b34-897763efc8e2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzOg0+0nY4ufRuMBVfZfM4ZiX4F1n+qEd6Cy/0kSp+KmKwC814P+qPXpj0KISmZ38FeNOS669dpkfXmHQFfeIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR05MB10973

SGksDQoNCk9uIFdlZCwgMjAyNi0wNS0yMCBhdCAxODowNCArMDIwMCwgR3JlZyBLcm9haC1IYXJ0
bWFuIHdyb3RlOg0KPiBUaGlzIGlzIHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNs
ZSBmb3IgdGhlIDcuMC4xMCByZWxlYXNlLg0KPiBUaGVyZSBhcmUgMTE0NiBwYXRjaGVzIGluIHRo
aXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9u
ZS7CoCBJZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBw
bGVhc2UNCj4gbGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkg
RnJpLCAyMiBNYXkgMjAyNiAxNjoyMDoxNiArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0
ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPiANCj4gVGhlIHdob2xlIHBhdGNoIHNl
cmllcyBjYW4gYmUgZm91bmQgaW4gb25lIHBhdGNoIGF0Og0KPiAJDQo+IGh0dHBzOi8vd3d3Lmtl
cm5lbC5vcmcvcHViL2xpbnV4L2tlcm5lbC92Ny54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNy4wLjEw
LXJjMS5neg0KPiBvciBpbiB0aGUgZ2l0IHRyZWUgYW5kIGJyYW5jaCBhdDoNCj4gCWdpdDovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXgtc3RhYmxl
LQ0KPiByYy5naXQgbGludXgtNy4wLnkNCj4gYW5kIHRoZSBkaWZmc3RhdCBjYW4gYmUgZm91bmQg
YmVsb3cuDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0KDQprZXJuZWwgYnVpbGRzIGFu
ZCBib290cyB3aXRoIG5vIHJlZ3Jlc3Npb25zLiBUZXN0ZWQgb24geDg2XzY0ICgxM3RoIEdlbiBJ
bnRlbChSKQ0KQ29yZShUTSkgaTktMTM5MDBIKS4NCg0KVGVzdGVkLWJ5OiBFbnJpY28gQnJhdmkg
PGVucmljby5icmF2aUBwb2xpdG8uaXQ+DQoNCkJlc3QgcmVnYXJkcywNCg0KRW5yaWNvDQo=
