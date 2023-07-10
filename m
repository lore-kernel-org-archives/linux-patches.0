Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24064180
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 02:55:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbEvJLRTK7/3R0FKQGH48twkZksb6N/8wqvcQPedPo4q86JPLIae9m9csn1UCUCEZvOFOjtkS6YcmetXgeCkFP4ovpAgdZ4tZ5NEptPnq+soqxZGAU7U1Ak5QbvSoCdzluDPKuXH60VI+AXVQnBx0DT99722QX2VnyIQNsGVVfmySfKIvJtBm2R6MR7HIbepacUjjCmbTLkba0WpSays/SpUsUf2FBU5wW1Do6s69acbSgwT1lPhqgCMD5QqeuS3y9p1AYiawm+Ywd4r8ZF4j4CsG3G0seHE/6c86QItm9EnRbb64biQB71WKLT+x0DUB5U7R0dEjit9enQVUceIhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TXDDd4mYyd7iscyFElK2VSh3N5FKvo1/qcDpVgcfqU=;
 b=C/GFz+jkQwra5rF7PtajbpXQBsdAXbcbbj8on48IRM4v/Zaknqv57DnL3oKIk+qK60OZP21De45Qono+q983iPcHoyR5QvOhz7uwzStFZJ2FVSi+ltc2rXs7uQftG9GeLDBRr7hdoNRH2bZlxWayVZ7gfqe4HXxQP4ffasQc+LNY8n3IU2WGBmUWCXGWUEH9pxNXt8IzjSgm2GljQTjMhLejbVWVYsKqHk01cBeQ3/JpedikbWNEHc0p15rhovFln9tIwFlu3Iq7wDB1Y6F/1pXH5ya8WN8qO+QiXLT5AFq7yeKoPBwbXaKmeZkwDl77DrG07JahUc2MCD9oPtUWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TXDDd4mYyd7iscyFElK2VSh3N5FKvo1/qcDpVgcfqU=;
 b=w8gpT83z5hMIsw269U5cegOJHjFQgElGPZmc9SbmORF//kbahvVXr/j7Di8XAxaAMEk0dMcJh9cIZI54v+AmHalXk9pnpDsk3CfozrhqTKNH6Dtqwqrsapm+/Z4Z8wA2LQH+ADvLfYNW2FR4ldL+S9rHfXgQ0J7GQI+H/7gWShA=
Received: from PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22)
 by PH7PR12MB7843.namprd12.prod.outlook.com (2603:10b6:510:27e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.29; Mon, 10 Jul
 2023 02:55:53 +0000
Received: from PH7PR12MB8796.namprd12.prod.outlook.com
 ([fe80::b918:c914:98d9:2975]) by PH7PR12MB8796.namprd12.prod.outlook.com
 ([fe80::b918:c914:98d9:2975%5]) with mapi id 15.20.6565.016; Mon, 10 Jul 2023
 02:55:52 +0000
From: "Zhou1, Tao" <Tao.Zhou1@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Zhang, Hawking"
	<Hawking.Zhang@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>,
	"Tuikov, Luben" <Luben.Tuikov@amd.com>, "Deucher, Alexander"
	<Alexander.Deucher@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.3 317/431] drm/amdgpu: Fix usage of UMC fill record in
 RAS
Thread-Topic: [PATCH 6.3 317/431] drm/amdgpu: Fix usage of UMC fill record in
 RAS
Thread-Index: AQHZsljfWJ8RTwoXxEml8qnLhQQGM6+yTxpg
Date: Mon, 10 Jul 2023 02:55:52 +0000
Message-ID:
 <PH7PR12MB879648F30381A3A590443B48B030A@PH7PR12MB8796.namprd12.prod.outlook.com>
References: <20230709111451.101012554@linuxfoundation.org>
 <20230709111458.612176044@linuxfoundation.org>
In-Reply-To: <20230709111458.612176044@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a776e369-078e-4f6f-ab90-9d5f0d6e61ce;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-07-10T02:54:52Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB8796:EE_|PH7PR12MB7843:EE_
x-ms-office365-filtering-correlation-id: 2fa9a46b-5761-4449-1bff-08db80f12c40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 0M4+W3PmxYOdWuCGg6hjkqC5Tkc91KrQOn6ts7m7yHsoip8NCvsTLznVBdFhZax8TxlvCneVLNnR3Wi35zN42rhLJ3UWUPlpDwjybZTOG/O1dKICUirIMF56rAEYrxwW40TlkGPfjGS2gRcDoLJJAof0K012hp65nZX1xOT1VUvpVCkPa3SMpIzkNVqWEhnmosxVuvnr+SK9iGmmTwSalHYj7OiNt/hWQWbzao20QGdO/HLsUxAaC7UU5HRofA9NoWdqIDdyGmmKiCNYiqs7HUpFALtWEO6dPVogxwfUts3BK3Gj2m7BOnfxMjbieHTcUbnL0VRKjBeqEGRK9W8CHmhEDQ0zepnDJmA3m+ekZPVHu2/54x3vY5esbn4eDxy3oFTumamD70Uvgz/1fQHdK2tZcbGNc9FTf3nHqlJH2J49/A/lv4z0Oytk7/4yJAyTBThBrU48aIA9GqIhD0xR/7HUYe8todv6c1wDlcbXEBPjndusBaq3CwydE6+Y6y4EmrYGGJnTcJBL+oEXaJKmGkXKaE9p2xYd9Xi1C1Sh+b3cWcm17M3mHxoYdiAIOWLSj9arLirUkWGWZBlR/eoN+D8zgcR0tAfYODi7dUor+x4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB8796.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(7696005)(478600001)(76116006)(110136005)(54906003)(71200400001)(83380400001)(38070700005)(33656002)(86362001)(55016003)(2906002)(66946007)(186003)(6506007)(26005)(53546011)(9686003)(966005)(38100700002)(122000001)(64756008)(8676002)(4326008)(66446008)(316002)(66556008)(66476007)(41300700001)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b04raHU2ZWVnMmcwSFl0aHhaTUgrVGp4Z1NCK2lQUkFCaEVPMW83b1pPOEJz?=
 =?utf-8?B?TjNTU1kvMkR4OHovOVRmOS9RcTlld0EzMjhIQXRMTDNZeHpTckJ1aVNuSW5C?=
 =?utf-8?B?c2ExMVZtTmppdmRKSjZzbXYyL3lOSUhvRTZVRVZDa2FRclN1ZmEvUDJQOEtw?=
 =?utf-8?B?NHk5MEJFb1FoYUpaNDJPcEMvZUV6ZVhmY2RFUEdTNTZvTTFObWFyaDQ5Qk5a?=
 =?utf-8?B?WENpM3R4YmxFSisvSTU2U2Zmc1B5eHUxUUp6dGgyYW91NVV3L1lVbVhoWU1O?=
 =?utf-8?B?NlpudGJVUXV0ZFNuUkw4eW9oQ255ZWw0V0g0c3JiUStlY2ZkRVVEMjNWRVFR?=
 =?utf-8?B?TE8rQldXQWZzNXBhTEw5RFMwUnQ1Q1czdm9XZ0UvNVAzcWpkdU5MbFJxeXlk?=
 =?utf-8?B?QkYvWlZBWFJHTDQrQ3VJajE2VTU0OE1jN2k4Z2pqTmcweGpKQkVjR0pLOEh2?=
 =?utf-8?B?YndWUDhUN0xhV21pUlZvbU94M2ZuRmJwOGhNaTVUUUY5eUZrTTNYdkxYRDVs?=
 =?utf-8?B?ZXBSSzlET0o5TXZzYmtaQk84S3o2VHBvMnBYWGxkUEtiZU5PZjRaaldGOGRE?=
 =?utf-8?B?ZExXY0FtaHBzMXZWemxjL3RSYm1hL0tPNVJhNWFjc0hsdWpOaTRQbUY2aXFX?=
 =?utf-8?B?eVJWa0FGVnFNQXZUcVBIcmJ6Q0dIa0p2TEVWNTRlenlwbzdiZ0ZuNXBEYURC?=
 =?utf-8?B?NEpKSUlaTFdjZFdGS0JVYUM0MG8zd2xlcWlKT2xsUWZ6UUROYTQvcEZZUTZ3?=
 =?utf-8?B?ZTJkK2tXQkhDYUpabWMzbC9iaU52Y3dSZ2xtNkhiMGovRnNsMXQzS1hhN3k4?=
 =?utf-8?B?RUxaY3R6eFVqeE1rUnkvL3R3dGd4czV1a0xESGduNS93aFRpdWUzZEErK0VU?=
 =?utf-8?B?dW5qWklBMWxPNzFnT3hJTVFsd1NaL1VWV0xjU0FLbVdIK3lkMDMrU1pDMjNu?=
 =?utf-8?B?OGlwUnlXTWRRdEdzSXMydlRhNW5qMUdscW1YN3lyWnZ5VUpmMVd1b1lzVnVO?=
 =?utf-8?B?Ti9WdkFLWHRodHRiVUM1YkhXeUJFRjVOMFZQS0JqZmpwSFJ0RDc3ZU54NTVH?=
 =?utf-8?B?UUtpOUszSS9yZy9MdWFTaXhvKzM2aHZiR1FkUkJCSXN0alZRMnNiOUFFeTZE?=
 =?utf-8?B?cXR1bTJ1dWZGZGtLd090Q0NoWDNMY3FjMEFqYlpHdzhLVDc5VWZNa2xJaFZt?=
 =?utf-8?B?ZmYya0RZcEs4Ym05eEZwOWNMRFBOaE9UaVRZZFBoMk1GODBIcnBKaTZMekhI?=
 =?utf-8?B?VTV6SmxKR0tudHh4blhMUDZpWEtvUGRQb0JxRmR2TzNnUnBzUWVhalRBaFlG?=
 =?utf-8?B?QkxKc2cvdFhvME9CTEFyNStpZThoemQyNDBCU0dMKytHOWpDRWxFVUdHWjVN?=
 =?utf-8?B?emRxd0NyK29ySVNXdjZKdlBzNTI2Q2M2YW95YnM1MW9MZjFlQUpUL0hUdHdU?=
 =?utf-8?B?UGhXNlh4TzA1bmFhcGJienF5RWFhYzJJaUo3OW1GbmhQakp0bmRaS01IdytS?=
 =?utf-8?B?NkJ1MmN5SXQ4YlZJaXNRWjdSbWJiSm5oUVZwTVRxdGRYRWRFU2JvOE5EU2dl?=
 =?utf-8?B?VjlmanhXWDBZV3F4eHJaOFBrdkI2SGxRNmlOdFYvUW9JNUtabk4yVmUwMHBs?=
 =?utf-8?B?WTI0UjQ3bWc4Tk1IN1RNSHQxWGk0Y3BnVWtvVEwrQ0MzZ1I4a01yNFBOR0sv?=
 =?utf-8?B?RnVpOGJTMitqUkZWOEF4Y0diUlloZXhOYnZseG14bE1tOHdLZjZyRmhLQjRN?=
 =?utf-8?B?em41MXkydUZ0bHo0MVFpdDh5NC96N2tESllvY3BkeTVtSVk5aGoyZWRUOFMr?=
 =?utf-8?B?YWNyOGRXYjN5QnVHZXNQaTVhbnJvNzV6SW9TbFFueGZ3M1ExUkwyTjN4WUdi?=
 =?utf-8?B?V2RvLy9DYnYvME5Wckh6bnpXUWxUM0Q4bG0wbU1LVjJzby9BSlZNWSt1ZUlk?=
 =?utf-8?B?TUtLMEp4T1VYcEExMitIT1N5QjYrSW5CTjVHVWEwL3BCV25yWTNYSUlnemNP?=
 =?utf-8?B?TkVTS0Y1dVozRjBheFVScHp1YUxDSHJtUzlJdG5CY1lOdlNHM0dzZlVmTFBM?=
 =?utf-8?B?RzIrZTZrSHZGc09TNFIxTzFCRlhZandKSHNYZytQWlZsN2RQWjRrMVdYam55?=
 =?utf-8?Q?80SI=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB8796.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa9a46b-5761-4449-1bff-08db80f12c40
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2023 02:55:52.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HfCB1n8/IBiJZtLqVifu0NesN2t+AcItMBHF+CsU5rMJKJYVMvRD4Cphsk7zHAD/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7843

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNClJldmlld2VkLWJ5OiBUYW8gWmhv
dSA8dGFvLnpob3UxQGFtZC5jb20+DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
RnJvbTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4g
U2VudDogU3VuZGF5LCBKdWx5IDksIDIwMjMgNzoxNCBQTQ0KPiBUbzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZz47IHBhdGNoZXNAbGlzdHMubGludXguZGV2Ow0KPiBaaG91MSwgVGFvIDxUYW8uWmhvdTFA
YW1kLmNvbT47IFpoYW5nLCBIYXdraW5nDQo+IDxIYXdraW5nLlpoYW5nQGFtZC5jb20+OyBEZXVj
aGVyLCBBbGV4YW5kZXINCj4gPEFsZXhhbmRlci5EZXVjaGVyQGFtZC5jb20+OyBUdWlrb3YsIEx1
YmVuIDxMdWJlbi5UdWlrb3ZAYW1kLmNvbT47DQo+IERldWNoZXIsIEFsZXhhbmRlciA8QWxleGFu
ZGVyLkRldWNoZXJAYW1kLmNvbT47IFNhc2hhIExldmluDQo+IDxzYXNoYWxAa2VybmVsLm9yZz4N
Cj4gU3ViamVjdDogW1BBVENIIDYuMyAzMTcvNDMxXSBkcm0vYW1kZ3B1OiBGaXggdXNhZ2Ugb2Yg
VU1DIGZpbGwgcmVjb3JkIGluIFJBUw0KPg0KPiBGcm9tOiBMdWJlbiBUdWlrb3YgPGx1YmVuLnR1
aWtvdkBhbWQuY29tPg0KPg0KPiBbIFVwc3RyZWFtIGNvbW1pdCA3MTM0NGE3MThhOWZkYThjNTUx
Y2RjNDM4MWQzNTRmOWE5OTA3ZjZmIF0NCj4NCj4gVGhlIGZpeGVkIGNvbW1pdCBsaXN0ZWQgaW4g
dGhlIEZpeGVzIHRhZyBiZWxvdywgaW50cm9kdWNlZCBhIGJ1ZyBpbg0KPiBhbWRncHVfcmFzLmM6
OmFtZGdwdV9yZXNlcnZlX3BhZ2VfZGlyZWN0KCksIGluIHRoYXQgd2hlbiBpbnRyb2R1Y2luZyB0
aGUgbmV3DQo+IGFtZGdwdV91bWNfZmlsbF9lcnJvcl9yZWNvcmQoKSBhbmQgaW50ZXJuYWxseSBp
biB0aGF0IG5ldyBmdW5jdGlvbiB0aGUgcGh5c2ljYWwNCj4gYWRkcmVzcyAoYXJndW1lbnQgInVp
bnQ2NF90IHJldGlyZWRfcGFnZSItLXdyb25nIG5hbWUpIGlzIHJpZ2h0LXNoaWZ0ZWQgYnkNCj4g
QU1ER1BVX0dQVV9QQUdFX1NISUZULiBUaHVzLCBpbiBhbWRncHVfcmVzZXJ2ZV9wYWdlX2RpcmVj
dCgpIHdoZW4gd2UNCj4gcGFzcyAiYWRkcmVzcyIgdG8gdGhhdCBuZXcgZnVuY3Rpb24sIHdlIHNo
b3VsZCBOT1QgcmlnaHQtc2hpZnQgaXQsIHNpbmNlIHRoaXMNCj4gcmVzdWx0cywgZXJyb25lb3Vz
bHksIGluIHRoZSBwYWdlIGFkZHJlc3MgdG8gYmUgMCBmb3IgZmlyc3QNCj4gMl4oMipBTURHUFVf
R1BVX1BBR0VfU0hJRlQpIG1lbW9yeSBhZGRyZXNzZXMuDQo+DQo+IFRoaXMgY29tbWl0IGZpeGVz
IHRoaXMgYnVnLg0KPg0KPiBDYzogVGFvIFpob3UgPHRhby56aG91MUBhbWQuY29tPg0KPiBDYzog
SGF3a2luZyBaaGFuZyA8SGF3a2luZy5aaGFuZ0BhbWQuY29tPg0KPiBDYzogQWxleCBEZXVjaGVy
IDxBbGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPg0KPiBGaXhlczogNDAwMDEzYjI2OGNiICgiZHJt
L2FtZGdwdTogYWRkIHVtY19maWxsX2Vycm9yX3JlY29yZCB0byBtYWtlIGNvZGUNCj4gbW9yZSBz
aW1wbGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBMdWJlbiBUdWlrb3YgPGx1YmVuLnR1aWtvdkBhbWQu
Y29tPg0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjMwNjEwMTEzNTM2LjEw
NjIxLTEtbHViZW4udHVpa292QGFtZC5jb20NCj4gUmV2aWV3ZWQtYnk6IEhhd2tpbmcgWmhhbmcg
PEhhd2tpbmcuWmhhbmdAYW1kLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxh
bGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8
c2FzaGFsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUv
YW1kZ3B1X3Jhcy5jIHwgMyArLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1k
Z3B1L2FtZGdwdV9yYXMuYw0KPiBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9y
YXMuYw0KPiBpbmRleCA2M2RmY2M5ODE1MmQ1Li5iM2RhY2E2MzcyYTkwIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfcmFzLmMNCj4gKysrIGIvZHJpdmVy
cy9ncHUvZHJtL2FtZC9hbWRncHUvYW1kZ3B1X3Jhcy5jDQo+IEBAIC0xNzAsOCArMTcwLDcgQEAg
c3RhdGljIGludCBhbWRncHVfcmVzZXJ2ZV9wYWdlX2RpcmVjdChzdHJ1Y3QNCj4gYW1kZ3B1X2Rl
dmljZSAqYWRldiwgdWludDY0X3QgYWRkcmUNCj4NCj4gICAgICAgbWVtc2V0KCZlcnJfcmVjLCAw
eDAsIHNpemVvZihzdHJ1Y3QgZWVwcm9tX3RhYmxlX3JlY29yZCkpOw0KPiAgICAgICBlcnJfZGF0
YS5lcnJfYWRkciA9ICZlcnJfcmVjOw0KPiAtICAgICBhbWRncHVfdW1jX2ZpbGxfZXJyb3JfcmVj
b3JkKCZlcnJfZGF0YSwgYWRkcmVzcywNCj4gLSAgICAgICAgICAgICAgICAgICAgIChhZGRyZXNz
ID4+IEFNREdQVV9HUFVfUEFHRV9TSElGVCksIDAsIDApOw0KPiArICAgICBhbWRncHVfdW1jX2Zp
bGxfZXJyb3JfcmVjb3JkKCZlcnJfZGF0YSwgYWRkcmVzcywgYWRkcmVzcywgMCwgMCk7DQo+DQo+
ICAgICAgIGlmIChhbWRncHVfYmFkX3BhZ2VfdGhyZXNob2xkICE9IDApIHsNCj4gICAgICAgICAg
ICAgICBhbWRncHVfcmFzX2FkZF9iYWRfcGFnZXMoYWRldiwgZXJyX2RhdGEuZXJyX2FkZHIsDQo+
IC0tDQo+IDIuMzkuMg0KPg0KPg0KDQo=
