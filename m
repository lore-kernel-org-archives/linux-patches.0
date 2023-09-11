Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76A23D9
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:44:31 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc2PWE8ui7nsiBY0/MMF50RfKCmWhcxWa8QcrJTzg4C9gMDtBo61s9yuChJQzNPKtL2tObcxu1qOrqUT1jpXfPMdz1J5Tq1/xurf/UIMACjabRrRod0SUCamGm9LSlfZmlJHWFa5c0nHPYKyE+ca1veSq+X2f2SSrEVpBfM9o4lKSeyKsWlpm39ofv7jn/mIKHxd82hIh4oE6qiTO4EWnEY3SdWjhAveJFjbW4u+0U7J0xoL66BO6eiuBG2reqkRYKJ56nsbUvH5EgfCzHX+QoZFQxDKep2jgHHqYK0xncaz+2fXnEQLbdU6x6wCXxN5tBYmTfaCXeBBh5xt/+4+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKksSS26RFSwKd4El+anRheLQDfiIS0gxGDfRxFCujU=;
 b=C5k6tjLQvolVD7GlUf1OhkaZ6CsraDhNj+s0IzgrMbNLFK/JKD2KOOuuajGQenxb5QzZwvRZ6XbE30xwUFp5GTiQ5hDVw+ojgGM9nPcvd6ZBsLsI+BVaJmQQPy5fv3TJW86o+wZvf22ooFghhT04XyipYyTMC877wT6zNCkOcZZ+PlKRtXKKOgZORi/UghOUpunCPfGPkXWpttzBA1LgKoE65STh5oA1AeRgbqrYmxJ82xXJj7FLlYu1zXNkuDE8vsuKSxeBdON7Pn6hK2PJ2KG33nBFkNhUARVdYnnOmkmaJ/Hu+uWZ//DW3RPaxqptU6zkSlySIaCM6J9DbBgRCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKksSS26RFSwKd4El+anRheLQDfiIS0gxGDfRxFCujU=;
 b=iENQIxrQ+xEp6JUPqexfAqX1IJFv0sPy7UFzo4Q2K+aQ33vq/13C8GaAmIHc0L+7sN5keklMIsllFzg5+HoHWvmFzp5gvPhNIWKk0SAwqd/j/NXGnYa2nOwWFHSL7I0RAF9eSaWwJiusBKO+cs31F+POir9J01gV9iiGxjeca+s=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by SA1PR12MB7344.namprd12.prod.outlook.com (2603:10b6:806:2b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 20:44:28 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::629e:e981:228d:3822]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::629e:e981:228d:3822%4]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 20:44:28 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Koenig, Christian"
	<Christian.Koenig@amd.com>, "Yu, Lang" <Lang.Yu@amd.com>, Sasha Levin
	<sashal@kernel.org>, Bryan Jennings <bryjen423@gmail.com>
Subject: RE: [PATCH 5.15 015/139] drm/amdgpu: install stub fence into
 potential unused fence pointers
Thread-Topic: [PATCH 5.15 015/139] drm/amdgpu: install stub fence into
 potential unused fence pointers
Thread-Index: AQHZ1pqmumskZEJ1N0CZEHxJlrVivrAWM5eQ
Date: Mon, 11 Sep 2023 20:44:28 +0000
Message-ID:
 <BL1PR12MB5144A0E84378A2666A26AE18F7F2A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230824145023.559380953@linuxfoundation.org>
 <20230824145024.239654518@linuxfoundation.org>
In-Reply-To: <20230824145024.239654518@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=b49aa244-3fd6-4c49-b83f-0a8153547e15;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP
 2.0;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-09-11T20:43:46Z;MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|SA1PR12MB7344:EE_
x-ms-office365-filtering-correlation-id: fadaef30-9f53-4e62-cb86-08dbb307e48d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 X1OrTYlKnaa+io8ANjHfZgjHXNzyXVbQNbCas5kKd4AeT+QGhKyAyt43aVisNCJPWcTDR5QqMVU1SKVVtyQC1LTorT+BCI/9DnZ7jlvD+3hqRgkh4HhMg+R8Ic1S1plVm/kK/FZ5jC7AFzupo8qXtyZiNrLDq7Z7YJ4BAzM/dNm0/BJkz/NxC1nSF0ice3xmgGm0efD8LoffzgR4l+QjpZGQQW3hclj46lJ9i46Xlmbm6Y7ASjuoilx/48frWmcFiuCmKbmvNmRnHA1TPtouo6wJchUjg+79Ohb6lQFAwN+Yv0XUJV9IeGrj02w0SGi3INS7kXM4G/zQAmE6/wIsZyGP6FOJd/7L9Dt2/12NzjBmGwTPblb1SCUoGoLKTlyt/1wYMpmDTxD1fxBmRsxL3KYL3s6WWSVpiZJy69sclY3UBD17bPxt6Uu/BBjZapkkU8HT1EjNGUx6Fnx8Hb7GPMdtehVOl/ISkc+xPadx8Ezr/KN7iVmMBP6FG4giaSwBnizCBT4orCbCUjSx7BfezxDHlXBOWPHeygve4TsWUtfE/B3B4jV6aj0KssfvEomPEiwQ3gBamr2rcbqU4INB7lvzviskF/PUbVh8DK07+00=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(376002)(136003)(346002)(1800799009)(186009)(451199024)(122000001)(71200400001)(6506007)(53546011)(7696005)(86362001)(33656002)(38070700005)(38100700002)(55016003)(26005)(66574015)(966005)(9686003)(83380400001)(478600001)(41300700001)(110136005)(76116006)(52536014)(316002)(8936002)(8676002)(5660300002)(4326008)(2906002)(54906003)(66476007)(66946007)(66556008)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVNTRHlzZzliTWduTzdwdWYrUnBVZURKckZDc0c4S0Y1QnNwUHZIR1gvQ3U0?=
 =?utf-8?B?clJ0d2FGdE9sMm83M0VCaTEyMm1TU0Z2R0NXb3d2c0dhd0FSZ2JlQlVrT1Za?=
 =?utf-8?B?b3g4ZHQ3Zm9wV0hrdDdBaEJaRkRYeTB2bTViWkMzMnhnNWlwamV5MXRoYnRN?=
 =?utf-8?B?STdQbTR6TU50eHluUTgwMGJPU2VWYkxBb3FKd2VYQzlnTUFIekp5YVZSSHhh?=
 =?utf-8?B?QzIzUFV5Y1BESXBxZUdyM2FtdW5lQUxaVXpoKzQ2Z3VrY2pseEpDcVY4Ukpl?=
 =?utf-8?B?VEthalpNcmtMNE5DOEJQS2Y3bk4wYWRWMkl4bXltNDRYRlpJd2psVlNLdWps?=
 =?utf-8?B?OGNXLzRUMXdNSW02bEs3dW9LenUxeEM1ek5sRmtHckxXc0RGWE9RVHk4S3Mw?=
 =?utf-8?B?SkdNTDM1eWU3dEl4cUZnVFVaZEUrSmIrajlLQXlkUi80cloxVWppeFlNTjdY?=
 =?utf-8?B?R210RlhaejlKaWkwc0dSWnBGdldrcHB4R2RCbDhIMG9WZkdMRGFsQTF0M29U?=
 =?utf-8?B?aTVZdmdXR3BGbjNNNGxqY2pWb0FxVDVFUWl0dmpOSlQxRkFyQmtsVy8rdmhx?=
 =?utf-8?B?R2JNT2VaK3BnUHJEbEtYREdoOWhvTVQ5RHIxZmFtaU5IM3lNbmF4ZmNSOG1x?=
 =?utf-8?B?dGxxYkM1TUVGT2NQVXJzWHV1RW0xeHEvd0J2SUowSy9qaisvZFhHRHVWa3Qy?=
 =?utf-8?B?ZnV5WGdDSFJOT25iMDV0QUR0SGpTeWZmUXhQUUk5VG4reElEVFpZR21sRVJB?=
 =?utf-8?B?V2c4RWtkT0xBMHc5b2c0M2h0d25NTzd3YzdmUVdZNEtxUUthTFozNlZqS2c5?=
 =?utf-8?B?RGd6SWlzcThpSTd4M2tZV0RKNnJlZ0c2TWc5a1RnREorWm9FSkNjOVRmdVJZ?=
 =?utf-8?B?R04vaC9sR3QrSXluVUk1MVFOd0d0RHdmRjcxMGs3b0VsVFovZmxnQ2tlRTRH?=
 =?utf-8?B?R1VWb0JGY1F3Yk9ZK3FCZncwalphZ2s2UW5TalhNUzhoSCt0S0wrSHRsVTRO?=
 =?utf-8?B?ampoOWlWVkNPU3R6TnZzRHJuQU53R1l3VEhHaEdHN3VDTWVJb2JBTjBJYkVq?=
 =?utf-8?B?UmxyT3RoaDMvRlE0TGhoVjhaem41OTJOZ0V0NlRJSHpRUGV4UFZkbnFSVk1X?=
 =?utf-8?B?OEVKdzU5c1lZNTNkWFAyeXZROC8yVjJpaVo2K3FMeU9LWmQ2ZHRwOEtPcHFx?=
 =?utf-8?B?bDVqNVdtWDlYOHJBNDk4bEZCaXpGWHprc1grZjUxcHk4QmxPMU44YTFtV1B6?=
 =?utf-8?B?bFV0V3JhajVtejVLaXhZVVVZMlRvSFltdGVJaFh1NWVIbVF0WEFndGxydHla?=
 =?utf-8?B?TW9VaWlrczV6TEdJS2lCejM0NzJrYkdiYXM2d3BiYndKUGxvY0o1Tm93Q2pw?=
 =?utf-8?B?cks5WXl6TnFiVk8vMm1jRm1YeWhCQnJvNEJxS28zOS9NYWY0OGtQclhZaEpt?=
 =?utf-8?B?cXpFWDdPak5aVjZwTGtBK0lzN2dBWGFTQ2tsTzBpQS9sV0JkMWhHRlNJdEIr?=
 =?utf-8?B?eDV4L1VYQ3JPRHhjd2NnclBlaXJyanFRQUI0NnBvVEFEc1liNDFzamdxT2dK?=
 =?utf-8?B?THByQ0ZuUWlEbTFxL1FBOTBsd2t2V2MvY1BUUS9KOXJNdHlRS3BSS0tJM04v?=
 =?utf-8?B?T1Nta1F0SVFIWitLWk14WCtZZG5DbDY0QjdNS3Z3MzF5MmN3ZXA1N2k2ZlpJ?=
 =?utf-8?B?UXBkMXNHYnNzNWlzbnZVdzd0eUNkOXBJZGpqVC9scnVqZEQ1dDd1aVMxTHZW?=
 =?utf-8?B?UkRCYVU4cmZSYVVtNTluVlBWbzJlSE1tLzBZNGI2K3ZWaHdicFlRNTNiUnFM?=
 =?utf-8?B?bFBIY3dsNE9VNWJVQUVYV0hmbkpVM0xVdkxVTTF1ODJZTVJBdVUxOEZhcUJ5?=
 =?utf-8?B?M1NBeVVqOUs1OHJWNVY5eFhQYWxwbURUV3FtUjFwbnB3UDJTMGlFNmtwMFdZ?=
 =?utf-8?B?R0xBcVIvOTZ0WExjcTY3dUFONHUzaW5hWjNVb0tFUEhFaW1KeEpHTmpXc3VX?=
 =?utf-8?B?Z2wvQUlQK0hCYnNYSGZ6YnNlWUFNa1RhT0RuNDRzbWxtako5VUVpeDI5V2tS?=
 =?utf-8?B?YkNJRmV3Q3RXYTZDMWYwN2tPMURDalZ2L2lwQjlvYUEySVQ3azR0OGdRQU5z?=
 =?utf-8?Q?lnd4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fadaef30-9f53-4e62-cb86-08dbb307e48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 20:44:28.3265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bnsSru+8/YHSvb3PtbPjqPeI6W+Xirm7md77AZF/XdClhTVn/NV5aZBNAcXMLk7iYjtIhM0LcWAGSE10Sr32Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7344

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBUaHVyc2Rh
eSwgQXVndXN0IDI0LCAyMDIzIDEwOjQ5IEFNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsN
Cj4gcGF0Y2hlc0BsaXN0cy5saW51eC5kZXY7IEtvZW5pZywgQ2hyaXN0aWFuIDxDaHJpc3RpYW4u
S29lbmlnQGFtZC5jb20+OyBZdSwNCj4gTGFuZyA8TGFuZy5ZdUBhbWQuY29tPjsgRGV1Y2hlciwg
QWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgU2FzaGEgTGV2aW4gPHNh
c2hhbEBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBbUEFUQ0ggNS4xNSAwMTUvMTM5XSBkcm0vYW1k
Z3B1OiBpbnN0YWxsIHN0dWIgZmVuY2UgaW50byBwb3RlbnRpYWwNCj4gdW51c2VkIGZlbmNlIHBv
aW50ZXJzDQo+DQo+IEZyb206IExhbmcgWXUgPExhbmcuWXVAYW1kLmNvbT4NCj4NCj4gWyBVcHN0
cmVhbSBjb21taXQgMTg3OTE2ZTZlZDlkMGMzYjNhYmMyNzQyOWY3YTVmOGM5MzZiZDFmMCBdDQo+
DQo+IFdoZW4gdXNpbmcgY3B1IHRvIHVwZGF0ZSBwYWdlIHRhYmxlcywgdm0gdXBkYXRlIGZlbmNl
cyBhcmUgdW51c2VkLg0KPiBJbnN0YWxsIHN0dWIgZmVuY2UgaW50byB0aGVzZSBmZW5jZSBwb2lu
dGVycyBpbnN0ZWFkIG9mIE5VTEwgdG8gYXZvaWQgTlVMTA0KPiBkZXJlZmVyZW5jZSB3aGVuIGNh
bGxpbmcgZG1hX2ZlbmNlX3dhaXQoKSBvbiB0aGVtLg0KPg0KPiBTdWdnZXN0ZWQtYnk6IENocmlz
dGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
TGFuZyBZdSA8TGFuZy5ZdUBhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5p
ZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNo
ZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExl
dmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCg0KUGxlYXNlIHJldmVydCB0aGlzIGZyb20gNS4xNS4g
IFRoaXMgd2FzIGF1dG9zZWxlY3RlZCBmb3IgNS4xNSwgYnV0IGlzIG5vdCBhcHBsaWNhYmxlIHRv
IHRoaXMgYnJhbmNoLiAgVGhpcyBpcyBjYXVzaW5nIGxvZyBzcGFtIG9uIDUuMTUuICBJdCB3YXMg
aW5jbHVkZWQgaW4gNS4xNS4xMjggYXMgY29tbWl0IDQ5MjE3OTJlMDRmMjEyNWI1ZWFkZWY5ZGJl
OTQxN2E4MzU0YzdlZmYuICBTZWUgaHR0cHM6Ly9naXRsYWIuZnJlZWRlc2t0b3Aub3JnL2RybS9h
bWQvLS9pc3N1ZXMvMjgyMA0KDQpUaGFua3MsDQoNCkFsZXgNCg0KPiAtLS0NCj4gIGRyaXZlcnMv
Z3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jIHwgNiArKysrLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdm0uYw0KPiBiL2RyaXZlcnMvZ3B1L2Ry
bS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jDQo+IGluZGV4IDBlNDU1NDk1MGUwNzIuLjc4ODYxMWE1
MGE2OGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92
bS5jDQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jDQo+IEBA
IC0yMjYwLDYgKzIyNjAsNyBAQCBzdHJ1Y3QgYW1kZ3B1X2JvX3ZhDQo+ICphbWRncHVfdm1fYm9f
YWRkKHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2LA0KPiAgICAgICBhbWRncHVfdm1fYm9fYmFz
ZV9pbml0KCZib192YS0+YmFzZSwgdm0sIGJvKTsNCj4NCj4gICAgICAgYm9fdmEtPnJlZl9jb3Vu
dCA9IDE7DQo+ICsgICAgIGJvX3ZhLT5sYXN0X3B0X3VwZGF0ZSA9IGRtYV9mZW5jZV9nZXRfc3R1
YigpOw0KPiAgICAgICBJTklUX0xJU1RfSEVBRCgmYm9fdmEtPnZhbGlkcyk7DQo+ICAgICAgIElO
SVRfTElTVF9IRUFEKCZib192YS0+aW52YWxpZHMpOw0KPg0KPiBAQCAtMjk3NCw3ICsyOTc1LDgg
QEAgaW50IGFtZGdwdV92bV9pbml0KHN0cnVjdCBhbWRncHVfZGV2aWNlICphZGV2LA0KPiBzdHJ1
Y3QgYW1kZ3B1X3ZtICp2bSkNCj4gICAgICAgICAgICAgICB2bS0+dXBkYXRlX2Z1bmNzID0gJmFt
ZGdwdV92bV9jcHVfZnVuY3M7DQo+ICAgICAgIGVsc2UNCj4gICAgICAgICAgICAgICB2bS0+dXBk
YXRlX2Z1bmNzID0gJmFtZGdwdV92bV9zZG1hX2Z1bmNzOw0KPiAtICAgICB2bS0+bGFzdF91cGRh
dGUgPSBOVUxMOw0KPiArDQo+ICsgICAgIHZtLT5sYXN0X3VwZGF0ZSA9IGRtYV9mZW5jZV9nZXRf
c3R1YigpOw0KPiAgICAgICB2bS0+bGFzdF91bmxvY2tlZCA9IGRtYV9mZW5jZV9nZXRfc3R1Yigp
Ow0KPg0KPiAgICAgICBtdXRleF9pbml0KCZ2bS0+ZXZpY3Rpb25fbG9jayk7DQo+IEBAIC0zMTE3
LDcgKzMxMTksNyBAQCBpbnQgYW1kZ3B1X3ZtX21ha2VfY29tcHV0ZShzdHJ1Y3QNCj4gYW1kZ3B1
X2RldmljZSAqYWRldiwgc3RydWN0IGFtZGdwdV92bSAqdm0pDQo+ICAgICAgICAgICAgICAgdm0t
PnVwZGF0ZV9mdW5jcyA9ICZhbWRncHVfdm1fc2RtYV9mdW5jczsNCj4gICAgICAgfQ0KPiAgICAg
ICBkbWFfZmVuY2VfcHV0KHZtLT5sYXN0X3VwZGF0ZSk7DQo+IC0gICAgIHZtLT5sYXN0X3VwZGF0
ZSA9IE5VTEw7DQo+ICsgICAgIHZtLT5sYXN0X3VwZGF0ZSA9IGRtYV9mZW5jZV9nZXRfc3R1Yigp
Ow0KPiAgICAgICB2bS0+aXNfY29tcHV0ZV9jb250ZXh0ID0gdHJ1ZTsNCj4NCj4gICAgICAgLyog
RnJlZSB0aGUgc2hhZG93IGJvIGZvciBjb21wdXRlIFZNICovDQo+IC0tDQo+IDIuNDAuMQ0KPg0K
Pg0KDQo=
