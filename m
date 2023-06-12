Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2105.outbound.protection.outlook.com [40.107.15.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13031FB7
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 08:50:23 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnsR32wCKow7KuC6TopIdogAO8raZ9JL/8NPI56rnuD4XiOpUiYBV/NJO/XHB/Yqpfy4C+SGspnJXTk9bGXV4a1aPAQU7RlClyyfWSjcaZPIhK1xbFIO0jjIZeh4OvYqh8R6O8WTRkfaUMSKRQSkiIfrqH/lgOIkquSXtRTy7swECJOwZD0I458LhKpSQR6prmk7+YBnQYV1Vib5MYZOVb6lsylQqnDxAu2OxwswRqad4GEyAPSglc/U6SgZH21A4XC9LnKahOmn7nbNGClRXuaEWI4lyxUxpa2rrOTOlxbENRBqcY2AK4p0Qin2HrEhg+vZTow3fJX1EczVsjo6yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdaOsMQtq5VISpDceMvsfuK6e4Wzcn8BYig7T+VaESc=;
 b=Gy042E5xUk6BJ89nBCLgBHFFUewLX8HGmb0FADkf3vB7/JpLH0eNl11OHnKOQ9vyDV+P3JnWfqdvPmPqqu4F+pfsT3zDVDYlJ3CPyiybrVq84hwD1Fjg5zxg1a7fGwZGhe3WYECtZGUcdCorjXz/I4SKsd0dz73sMgo2EtRvNwPWWv+oia1IO592jrV0w3WRxD6IedFoxfgIeIrTqfys2qW9UxO95hlJ5nM9VhuCIFlcc9cLZShRrV+OTDg7IiG2BB78WrIJnTCS2kf/6eLH06dFJTwgwCoMHto0uWSg230iIXwOyb6ZFae5NWb5y3XDZEcnwDHFFin3H2V9Blso0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sma.de; dmarc=pass action=none header.from=sma.de; dkim=pass
 header.d=sma.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdaOsMQtq5VISpDceMvsfuK6e4Wzcn8BYig7T+VaESc=;
 b=TV7MCNA7ZaqYIinxvbBYGkKRF84/mcFMCRjT9EeqmlwvQj/Qetvt57LV2qz6vbaro0QGJKH7ImbPmXs0/AlOdYfCg06K7/g/OfTOQYJilwJ10GULz3H3b/gctHj0JrfbBquoAaSOaI+iZX2GkLrCtScx5uazYfptOIQdyf3HQNU=
Received: from AM7PR04MB6998.eurprd04.prod.outlook.com (2603:10a6:20b:10a::20)
 by PR3PR04MB7484.eurprd04.prod.outlook.com (2603:10a6:102:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 08:50:18 +0000
Received: from AM7PR04MB6998.eurprd04.prod.outlook.com
 ([fe80::3371:a506:4476:3e58]) by AM7PR04MB6998.eurprd04.prod.outlook.com
 ([fe80::3371:a506:4476:3e58%3]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 08:50:18 +0000
From: Felix Riemann <Felix.Riemann@sma.de>
To: Lino Sanfilippo <l.sanfilippo@kunbus.com>, Greg KH
	<gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "sashal@kernel.org"
	<sashal@kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Thread-Topic: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing
 interrupt registers
Thread-Index: AQHZh0NUPlbkVZOgikWTPfSAp7SXZ69oqcCAgBmrbQCAAG5AAIAEO5fg
Date: Mon, 12 Jun 2023 08:50:17 +0000
Message-ID:
 <AM7PR04MB69984F972B81A455B6EE525B8854A@AM7PR04MB6998.eurprd04.prod.outlook.com>
References: <20230508094814.897191675@linuxfoundation.org>
 <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
 <382309d7c0ae593d507eb816982f6a66c2cda00a.camel@kernel.org>
 <2023060906-starter-scrounger-1bca@gregkh>
 <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
In-Reply-To: <3bdaa40e-16dc-6c04-b9e4-9e5951267e7e@kunbus.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sma.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7PR04MB6998:EE_|PR3PR04MB7484:EE_
x-ms-office365-filtering-correlation-id: 0c8d9b50-c37f-4bff-2729-08db6b220c2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xxHuPA98Ih4I4GhIFHhh3igxgNO6ii6f18YV4hg9TeNMl34je1JC0SbUZIV5aiwyMnSXEVI8oV6j+QCO5WYEIa+5NrZhLECJr6fcVLSFzhT7QH0ug60w1LA92guemvBqnS+NdQj5jL7CQoC25r8oJ/IOS5jAjpl+bFcPxegsVhHv6n3lh3XCM5R089Uqbl6YkyE7kXmS9iShInYVSphKCI4tU/0aCG2lMsxk4OF42UeHth0fQBhUdNklqvuWY8CqZJ70XZKKZoSGvEpOF9+68Fs270zCvnjYo2tfXlsLCRr2+ErOrSsehtJB2a3MBbAsSG0yK8QStoaMvjxHhocefPJoMXTVfzOHyvZGK/ozoL0wovuqcYY8KNnBmGxlggG06qboWT5TFhLocgefWm8tkbzJWkg3EMyJW0/j3W+B7nGnVE1lXZvOXBTDaWGsnPm9TknrJdiHFviGLcFWqw2JWhh/Z4JT+lrFEgtW+pyB0ThgY+KJd7zhBQkrQuGgDACHkC50BTfxJBkj/taPoUw9rFOhI29dMEZuIlrtC8TM2OZB0NHSu58j/LU5neEljmlsZc2jOGPHWPP5CbCSOq5DOT7ZSxlydh2FHxm2AdUErRf9Ex+E23rrZ8duVCVSUHY0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6998.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(83380400001)(33656002)(38070700005)(86362001)(122000001)(38100700002)(55016003)(478600001)(110136005)(54906003)(7696005)(71200400001)(8936002)(8676002)(2906002)(5660300002)(52536014)(66556008)(66946007)(64756008)(66476007)(66446008)(76116006)(4326008)(41300700001)(316002)(55236004)(186003)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MHRVRWZoN0s3NU8xVnAwRjl6WXhVTU1GQzNPREVmTVFvRUxLUStWR3IyUmhO?=
 =?utf-8?B?QklBbW8yYUxLeHJ1K2NmeTh2ekFBbWV6Qk5ES0lpR0V2bURRWjQ5NmJDZ3ZD?=
 =?utf-8?B?UGcwcWZTU01kenlFOWxoOGt3dU9GY2ErR2JQZHowUHBNZnRzQXA0c3JGcys2?=
 =?utf-8?B?YWhzaXU3NDEvYSt5bHpyU2VpZ2cybm9uUmxGUk11ZllabjF1MFp0RDVHOE1m?=
 =?utf-8?B?aWNsY3Z6QUREZ0tuejBLczNPNmhoN1NaSHBMQUpOa0xXQUkvK296TFI5S2o1?=
 =?utf-8?B?bmQ4TG8rNm5KYWpaaFU2R2tjRVFKTGlUTlgzQ0g3YkkrSmNnUVpNRU03akRQ?=
 =?utf-8?B?cE4yUTBybVlEVnJNeFhyanBDMHgzQmErL2N2T0ltdzczMUdVbUJjSE90VkZj?=
 =?utf-8?B?Vm5YTnhPdFNrZ3pUaXBzdjZ3MUV6UmZwdWFZOGtIVnMyM002aVlPaVZCNll2?=
 =?utf-8?B?Q25DZms5K2ZaZDBCejFha1F1dy9OZjY4Y0xKa3hqa3FaUUhpS2xBRjdSM1lY?=
 =?utf-8?B?eTJiUXM0ZndIY2VwQWtWY2tkc24vLzlxOFltQ0FUU0plblZHQ2IyTXhqQ3BX?=
 =?utf-8?B?TGFWY1pJTVVFaHdRckZOcEpUTzJNSEl6OUtBa1FLcFY4cURrb0RPbm5lS0lB?=
 =?utf-8?B?Q29EQkVxUHFxR0Vyc3Z0SjFHbWhpbzlkY25GdDViQjcyUHphTVgrV3hhcnND?=
 =?utf-8?B?bjQvZ0tsMjA1UEtJQWlPTWdYWUd2dVY1aXNXdjU5dzJtUldGQnFnV05iUU1i?=
 =?utf-8?B?cUpYS0NXL04xYXl2T0pGcEZieG1Ea04vY3gwbjdsTHBLT1JGMngzTm5OYVhE?=
 =?utf-8?B?SEgySUNZVXMyNjBMSnlJekdwejJkbDhQbTVtbXZMYW83dllPMlJXZVFXVyti?=
 =?utf-8?B?MytnbEgrc1J2N2RwYWxLZ280eXhld1A5cUp2emRwd0hWWkdIMXUvWXkvWnpM?=
 =?utf-8?B?SGRoRXdlMmNpNzBiYnhaV2k1azFNUHl5MXdrMEI2Vk01U1BKcDlLOHpvNldW?=
 =?utf-8?B?NXFYVncwenUwNGlPL0I1SDRTNlRaM1BXa0JNajIxMy9YZlhxYlo1cG9wSE05?=
 =?utf-8?B?RW9rRXJHQmVaRzZwbXpvbkp2SGtpdVRpN3lvZlNFdTJHbEhEU0FobVNiMU5R?=
 =?utf-8?B?T0JXN0JnNUZPNWdjc2dCT3hMOG03ZkR0UlFGR3UwOVcyMndmZkRBaTlTRU5K?=
 =?utf-8?B?dGp0TXN6WnA3NXREVmY3ZkJCTkV0NDZvRHJHSXhpVlRZUVhSbmIyL0U4R1E2?=
 =?utf-8?B?NzZuNXNuTVVoNTBQWmNRdFR2aWowdCtaMFFDam04a3htbmFnR1NqNzIxUlBZ?=
 =?utf-8?B?dThtMGltaC95U2xCaDdUVStFa0lLSkh0VzdVTjFTR1pmdWpQdGRmS08xYnZl?=
 =?utf-8?B?NitTaVhDUVVlVktxRitXSmYvcWxyMWhaQXRWUWUrS255ZUY2cEl0Qjc2aTNZ?=
 =?utf-8?B?akVja1JmeTgyMit4Q1VXRzFxeVdUUVVranFkdnc3eDFFd2VCbXlXWkRNTXNU?=
 =?utf-8?B?VTNoQjE5NTZaMHF5dEhmVVJoMFRrRFRucW5OWUQ0ZW1KQnlmbXIxWEVjeXNh?=
 =?utf-8?B?TlQrZ3hOZDhQdFJhb1hSbnhRNG1Yb0JReGdyNEk5RFB0Wnh5L3NDM2FoV1Rl?=
 =?utf-8?B?WW9CT3NiQ3ZBa1dzbmt2N24zdWdZZGlKRGFXbnA4VlFPREtPZzc3aUEvRFRL?=
 =?utf-8?B?c3U2dlIyUThSSks5YXRCcVRJSkZHWEdjT2dRQXpVY2NKNFNUdkpONUd2M1pZ?=
 =?utf-8?B?d0dUeHdtM3JQNS9yakhoT0F1WVluNmJMZ0lsYWJkKzIwRnZNWU1TcTRGaWRX?=
 =?utf-8?B?YmRENXdwMTRVeEM2bVFJVFJrbGpXcFVYblZzZ0FqdHgrNlFYeDIwVWF4am5y?=
 =?utf-8?B?R3g1cWtSYVhDcEU0YlZiVVZhdzRrS0FlbGdEeVFOL2NiUG01L2dFKzU2a29O?=
 =?utf-8?B?ZDlPeDVmOHVQa1RmNEhDSXFsbjc3T1BRUERpWmtsQ29VRGp0cEI4RU0vRnFI?=
 =?utf-8?B?anRKYjdrbXdqYkxQNWF3WWluSU9ZcnVzVmZLeU9XMGJUWmMycnFad1dHaC9V?=
 =?utf-8?B?NVNuMjNIMXRIdEIrQklaNmc0YTlEOXhkeWNxNHlQMGJIay82d3J3dDh4OVV2?=
 =?utf-8?Q?Q8IQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6998.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8d9b50-c37f-4bff-2729-08db6b220c2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 08:50:17.9877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MMf4j68XpSXrzr7v+JJNVhB3FmoT3v1vCci71sHcREwx1/Dw9TDhELAZPW0sa18O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7484

SGksDQoNCj4gPiBPaywgSSB0aGluayB0aGlzIGlzbid0IG5lZWRlZCBhbnltb3JlIHdpdGggdGhl
IGxhdGVzdCA1LjE1LjExNg0KPiA+IHJlbGVhc2UsIHJpZ2h0PyAgSWYgbm90LCBwbGVhc2UgbGV0
IG1lIGtub3cuDQo+ID4NCj4NCj4NCj4gV2l0aCAwYzdlNjZlNWZkICgidHBtLCB0cG1fdGlzOiBS
ZXF1ZXN0IHRocmVhZGVkIGludGVycnVwdCBoYW5kbGVyIikgYXBwbGllZA0KPiB0aGUgYWJvdmUg
YnVnIGlzIGZpeGVkIGluIDUuMTUueS4gVGhlcmUgaXMgaG93ZXZlciBzdGlsbCB0aGUgaXNzdWUg
dGhhdCB0aGUgaW50ZXJydXB0cw0KPiBtYXkgbm90IGJlIGFja25vd2xlZGdlZCBwcm9wZXJseSBp
biB0aGUgaW50ZXJydXB0IGhhbmRsZXIsIHNpbmNlIHRoZSBjb25jZXJuaW5nDQo+IHJlZ2lzdGVy
IGlzIHdyaXR0ZW4gd2l0aG91dCB0aGUgcmVxdWlyZWQgbG9jYWxpdHkgaGVsZCAoRmVsaXggbWVu
dGlvbnMgdGhpcyBhYm92ZSkuDQo+IFRoaXMgY2FuIGJlIGZpeGVkIHdpdGggMGUwNjkyNjViY2U1
ICgidHBtLCB0cG1fdGlzOiBDbGFpbSBsb2NhbGl0eSBpbiBpbnRlcnJ1cHQNCj4gaGFuZGxlciIp
Lg0KPg0KPiBTbyBpbnN0ZWFkIG9mIHJldmVydGluZyB0aGUgaW5pdGlhbCBwYXRjaGVzLCBJIHN1
Z2dlc3QgdG8NCj4NCj4gMS4gYWxzbyBhcHBseSAwZTA2OTI2NWJjZTUgKCJ0cG0sIHRwbV90aXM6
IENsYWltIGxvY2FsaXR5IGluIGludGVycnVwdCBoYW5kbGVyIikNCj4NCg0KWWVzLCB0aGF0IG9u
ZSdzIG5lZWRlZCB0byBhdm9pZCB0aGUgSVJRIGJlaW5nIHBlcm1hbmVudGx5IHRyaWdnZXJlZC4N
Cg0KSWYgSSByZW1lbWJlciBjb3JyZWN0bHkgKCBJIGRpc2FibGVkIHRoZSBJUlEgZm9yIG5vdykg
ZTY0NGIyZjQ5OCAoInRwbSwNCnRwbV90aXM6IEVuYWJsZSBpbnRlcnJ1cHQgdGVzdCIpIHdhcyBh
bHNvIG5lY2Vzc2FyeSB0byBmaXggdGhlIGludGVycnVwdA0KdGVzdGluZyBsb2dpYy4NCg0KV2l0
aG91dCBpdCB0aGUgaW50ZXJydXB0IHdvdWxkbid0IGJlIHRlc3RlZCBhbmQgdGhlIGRyaXZlciB3
b3VsZCBwb2xsIHRoZSBUUE0NCmFnYWluLiBCdXQgc2luY2UgdGhlIHRlc3QgZGlkbid0IGV4ZWN1
dGUsIHRoZSBJUlEgd291bGQgYWxzbyBzdGF5IGVuYWJsZWQgaW4NCmJvdGggdGhlIFRQTSBhbmQg
dGhlIGhvc3QuIFNvLCBsb29raW5nIGF0IC9wcm9jL2ludGVycnVwdHMgb25lIGNvdWxkIHNlZSB0
aGUNClRQTSdzIElSUSBjb3VudGVyIGJlaW5nIHJlZ2lzdGVyZWQgYW5kIGNvdW50aW5nIHVwIGR1
cmluZyB1c2UuDQoNClRoYXQncyB3aGVyZSBJIHN0b3BwZWQgdHJ5aW5nIGJlY2F1c2UgSSB3YXMg
dW5zdXJlIGlmIHRoZSByZW1haW5pbmcgcGF0Y2hlcw0KZnJvbSBMaW5vJ3MgcGF0Y2hzZXQgd2Vy
ZSBhbHNvIG5lY2Vzc2FyeS4gSXQgZGlkbid0IGRvIGFueXRoaW5nIG9idmlvdXNseSBiYWQNCndo
ZW4gSSBwb2tlZCB0aGUgVFBNIGZvciByYW5kb20gbnVtYmVycyBvciBoYXNoZXMgZm9yIGEgcXVp
Y2sgdGVzdC4gQnV0IEkNCmRpZG4ndCB0ZXN0IG90aGVyIChtb3JlIGNvbXBsZXgpIFRQTSBvcGVy
YXRpb25zIHRoZW4uDQoNClJlZ2FyZHMsDQoNCkZlbGl4DQoNCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KDQpTTUEgU29sYXIgVGVjaG5vbG9neSBB
Rw0KVm9yc2l0emVuZGVyIGRlcyBBdWZzaWNodHNyYXRzOiBVd2UgS2xlaW5rYXVmDQpWb3JzdGFu
ZDogRHIuLUluZy4gSnVlcmdlbiBSZWluZXJ0IChWb3JzdGFuZHNzcHJlY2hlciksIEJhcmJhcmEg
R3JlZ29yDQpIYW5kZWxzcmVnaXN0ZXI6IEFtdHNnZXJpY2h0IEthc3NlbCBIUkIgMzk3Mg0KU2l0
eiBkZXIgR2VzZWxsc2NoYWZ0OiAzNDI2NiBOaWVzdGV0YWwNClVTdC1JRC1Oci4gREUgMTEzIDA4
IDU5IDU0DQpXRUVFLVJlZy4tTnIuIERFIDk1ODgxMTUwDQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCg==
