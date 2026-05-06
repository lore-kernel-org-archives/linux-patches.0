Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077720CCDC
	for <patches@lists.linux.dev>; Wed,  6 May 2026 06:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778047551; cv=fail; b=YPwQtUvLa4AGIextTrAAGSKb1s2PbhMcLE2464+NmPbRAEJlEUy1/LDv2djfZc8NG1Ao4zoFv1LkcsyWpNsi8+f33cF9f73YSKzYQG4Wv76raVYMR3TgQWWB60NzSCZGNt+4061pOiMS+d0LHtofKPSu3RbV9ME4odrw3lt+I90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778047551; c=relaxed/simple;
	bh=g7BOEdbVd3QgXeYD6L5AdZCJEYnVyk4EhvgnbJi+gD8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Xsp2JC7VXH55O7XQyvpM8LGG/GQryK4ViEa2/XbrQ8XCE25Ww1TH9pUJfDcd2U4wmxu7RBU6H4Fdqb+lToZB3jNmFdQfhbsrsGNduoIW1Clh1PW9rTIbqqLtBUDcBa4GGmB/oeZX9C6red9NhV0bUbN2jaQf02lzfo0nd9CPPAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vm2+iB21; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vm2+iB21"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=St7uBf5RyptkLzXrfdEzJDNiOQbTrU1q5rpSsC9P3uetlmPypDwsDh3DGv1xY9FFJjb/tgNV7iZxguQfRj+TckFSD9mX7giBahWNEx1PnzzmXBC3Cac0FThxaI0G+KudzdhsOdUkPOhEMjqE+qmkYBHEFF2ZUY6y9ceYLzElwQ1HVGXh6b4W3M1RwYVs03xDTcHDd4ptapKOHDkJHmuxB/v+e2YDU+CIOfF/hm1zuix2SmabGKBSKE5s5AqaU6g9VcomhMOAu7RcMjDBqOx7rcKoNbtPpR0eA8doLAA5pS9e5lVWQeL8KiojN3skurbw80sHor1IgT4TTN8zpekwkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7BOEdbVd3QgXeYD6L5AdZCJEYnVyk4EhvgnbJi+gD8=;
 b=g6TNTM5MmK1R8BcrOeSK1yvZlan6HlMhIi0DHHMKm10oyZPTNz7VeFyVG9YuSc9JwxohqFFSiYZ3oIsuROGY+8fJeWE8BfQGwI0b6u2nGSMIPMOFdna0AXyo7Rgiod2xNiuDlYhHdRPlD9CnN3GyPYSR9wUg2XaZakZAPHuPU6sSNSW25G1ijcf85P3UpebjPyIneWTmvM+/5kqUOEH96oYVS8qlvPz4QDzkfHzZuoOayZOmZwkLgMOIGcsEdRoJVeTDOzKYQw38EWHcK9ieCG0UA0AB7U3bp5yfzvnz8g1tE9cxf5ZwYkaQqmDW8skfmjUYTqHAu0OZhOJnvKMKyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7BOEdbVd3QgXeYD6L5AdZCJEYnVyk4EhvgnbJi+gD8=;
 b=vm2+iB21zOedWuyTpJcAubKX+WFp+vmHZefa/X2M4a2I/N4Q+cKL8W2ejsWBzxWpHNMxVacm+WKUWDnm2Way05DvR5K5lgBtv1p8gaTMSdw1GJUon6bzFEtRXSHqA1dGwqvaHPlh8v+FIbH5l4LeGwt1g7x4b5EfM/eoPNesVsQ=
Received: from DM6PR12MB2972.namprd12.prod.outlook.com (2603:10b6:5:39::31) by
 SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.15; Wed, 6 May 2026 06:05:46 +0000
Received: from DM6PR12MB2972.namprd12.prod.outlook.com
 ([fe80::574d:7c2d:4d0a:855e]) by DM6PR12MB2972.namprd12.prod.outlook.com
 ([fe80::574d:7c2d:4d0a:855e%6]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 06:05:45 +0000
From: "Wang, Yang(Kevin)" <KevinYang.Wang@amd.com>
To: Jiri Slaby <jirislaby@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Deucher, Alexander"
	<Alexander.Deucher@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.19 001/311] drm/amd/pm: disable OD_FAN_CURVE if temp or
 pwm range invalid for smu v13
Thread-Topic: [PATCH 6.19 001/311] drm/amd/pm: disable OD_FAN_CURVE if temp or
 pwm range invalid for smu v13
Thread-Index: AQHcx4iJ60YYxhc8aU67J9j+tzpfr7X9i9IAgAMgWdA=
Date: Wed, 6 May 2026 06:05:45 +0000
Message-ID:
 <DM6PR12MB29729EB48AEBCD70C7EF4170823F2@DM6PR12MB2972.namprd12.prod.outlook.com>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175939.452810365@linuxfoundation.org>
 <a196b98a-a4f7-4e97-9005-d8a9f5e4814b@kernel.org>
In-Reply-To: <a196b98a-a4f7-4e97-9005-d8a9f5e4814b@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Enabled=True;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SetDate=2026-05-06T06:00:19.0000000Z;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Name=AMD
 General
 v26;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_ContentBits=3;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB2972:EE_|SA1PR12MB5614:EE_
x-ms-office365-filtering-correlation-id: ca56b48d-427a-4896-5759-08deab358352
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|13003099007|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info:
 oF8jShoUQ9N5fotEgNFkzD1DpuOTfK39cW4gydDlJCid0MljDT++gnRkqBxT2T9EdKXw0bI9aR5ohMBPB7xtd+1zqsge4+Hk1J4d2tCVvl26/UuvOlydUZAtSm2t191rntM9JIB/acdF21h4kjkKz6yh8D5o0fwoPTVI6U7KeAUjcx0KAECyFrdbqGeKFjsdzCwk4quGyVu290IdUQpsBPECP+MrRhdpZKvoUWHE6TmCWMZPtAS6Zx/h/yF0Urci9t8xVp/eTx+RxttE9LKsmyCdELNKPM1/PDP9dMj9sANnYmFxbrLw69j/ZsJEkrvXQPWd7mVbP94wPVVbCzp5Zdxl88RNFoPtEO+7a3PVb01XU0phoVT6cTzhVhdart/HPxdH+sVU1TEat+1VTv/WcZEtOSnWncjrssjixMEY5tVMd7LeABMHyVIwJ6J5RYE5eCHPGp+UvyJCL8Iob+Tmo1QmxI67XkAiem/ZQoD6hh8dnQegCsV0BBcW0Y2fc183Vfzx83W5IBZX+i5ikOczBbCnZxdIb6ikn9YsYpM9kPDnk4Lk0ZGBkHnOUfE7WsZ32QomXcXobh3vbMNwtCDiL5zBKcGAmjQWEKkqSeELvfHKJXbSXn79xmMLIauzX9EfvdjUhrdAJZFKUXX96bjqWomrRb/35vY1C3cuOHN16b4RU30YpbpSjIFMRyHSKdGcn7A2zcfoK7/0pqNeVSWpxg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2972.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(13003099007)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VFh0Y0N4TEVxTEluQlBOYndvQVBWSUV0NU5zaUJCL3FXVFdqK3dNSWNyVGlr?=
 =?utf-8?B?c0Vzb1k2L0pvNmVFaVkzRHhjUFNZYmxCbWJVcUVxZzdzS0QzdjkrSUVxdXo4?=
 =?utf-8?B?SGhEeDRHdVN5QzR0OER1UnNzMzVuV1ZBUTlBWEcrWDVpTTVabHVpdW5ROWZZ?=
 =?utf-8?B?ME5aMTlydGEyMTNMajBqZzBCRWIvU1RhbTZnbXBVdFFJMFprQnk4aW5NNGp3?=
 =?utf-8?B?Y05kYUpaSHhRWG1nVklScDlPRmRtMDVESWV4MitpYXJhWGVaMDF3a0pKRitt?=
 =?utf-8?B?ZklmaE0wdzFvUkpwczJ1LzFIZVl1UXkwbzVRTDlLTmNTVEtyai9xUit6OVRL?=
 =?utf-8?B?MUFwMVpFRE1uUWc0YUkySXNwR1RHWjY1SkhMb1h4L0s1dFNiZjNUYmtDY1FI?=
 =?utf-8?B?RWVzQ2ZXbzBMRC9tUlAxeE9pZTFReFpzNHhoZ1YzQ3IybFYxWlhZS3A3UGdD?=
 =?utf-8?B?WnF0eTVzYS9HZFd2Z3doczZ4SDRZdE1hYnphQlc3QWtrNnhZOEJ2VFNlUWx0?=
 =?utf-8?B?SU94dkdpRmhWZ3l2bmExVjVoOFJWWmNBVjl5c0t2OHp4NmZhdzBia2t0Wjdj?=
 =?utf-8?B?bUYwNktIS2dPdFVwS1pMTFB5L2xRZlY1WFE2bUFHN01lV0RwYWkweDJyWGpX?=
 =?utf-8?B?Vm9ZVGE2eUR6MEZseWRpdkc0WFZYVzZ2a3ovQjhhL0ZSckFkcjhNMURydFR5?=
 =?utf-8?B?T084VXhXRGdrSFJLTU8wdTN4cUxPRzZLa2tyVlNJekxYeGZ2ZWJ1SllPYWxK?=
 =?utf-8?B?dkdqNHMvVUt2VkNYSmpURkVaM0hQY1lVaTgxK1ZXMmd5QUYwUDM0b01oV3NX?=
 =?utf-8?B?TUpOZlZjQXR3Zk5xdFIvMWNSNDhEYmV0UFd3dUFHRVBqL0ZDaGZ1S0k5Z25B?=
 =?utf-8?B?UWo2L2orRTdJekZuWWM4d0psTytjKy9VNzdhcnZDSWhmbThCallvSElkcndm?=
 =?utf-8?B?c2E4M3VKM0xGM29GNjlNQzVsZHFqbTdKOERhdE5TSHNhT3NTS3Z1Yjkvb2Zt?=
 =?utf-8?B?elVUM1d3TXJZYllTY3A1Tkt0Y3N4WDdkZzJuSlJzdEVvRGFCVXRzVE5oSWtP?=
 =?utf-8?B?eFU1TnhkTnJDSW9ISUFDOWZWbkJiei9QdW1nY2FPV2NPNmEwaVN1eFZrblE5?=
 =?utf-8?B?UUFqVmRyN0lDbjV1OFJBdy9maCt1SURhalRyVUhpK2I3WVJ2VzFYM0N3ckFT?=
 =?utf-8?B?OHF1aUpPVjhGS1FpV25wbmR1OHI0TWNXNk1LS1ZwZmVodmZHUEZLMTVuVkho?=
 =?utf-8?B?U0tlMVpadW1paWFSWTZjNXFpcWRBb0lHcmVJazBQNFJLTUFOZVY3NU0yaFVV?=
 =?utf-8?B?RFIvN0ZpWHFZZGV4a3VjMTJOTUFhN3hWS0R4amFhQUlUV1E0SWVPd2xhQUxv?=
 =?utf-8?B?L0lEYnBQYWQ4QnJFOXozMFh1SC9oRU9EQyszRmJCaGhtVDlLbFIrOWVFekFQ?=
 =?utf-8?B?N3lLZEZlVFVVeXVFaUVzeHA1U2hvUEorRmRLMVdRZXVocW1HTThpWEVRWVBS?=
 =?utf-8?B?cU15NkFXdHlyUzFjM29rTUE4SWdwLzIxaFk0WWJHR3hQRTRPcWRmSGt2M3JR?=
 =?utf-8?B?cy9nNmJTVU82NDh5SkxQM1l3T2xRcVEwL2ducVp1cmR6NVM0N2ozQnpRajFJ?=
 =?utf-8?B?Z1g1aW85a0JQVytzMG5TNTROV1hrTkVYM1gvY0FvL1E0eTJwZnRsYURleDJB?=
 =?utf-8?B?R3hYQ3ZzcFdTc3ZpNlA4dy9Wa0h3N2NDZjVQei9XdlVHR0dtODk4cDVtMmJk?=
 =?utf-8?B?TjhWM1VvNXFZQjRqaWtSelBrRnF3UlYzWTJCVUVkNHY1MXBDZWVNWndwd09X?=
 =?utf-8?B?cmtWWEdCOUpmMVVWc2NjS2tYbmdhWDgzNmorRHdpUzR3SjFBN0V4V0lSMWZ3?=
 =?utf-8?B?Y3NpV1ZRVzJycVlNZEYySVh4RWFiSm5TN1RRQTJQT2RCZE0rZ3h4elVPeWgz?=
 =?utf-8?B?RFEvbFB5TTNVZzJyM3AyTGhqWHV6a1pmNkpDWHNaT1FCZ0xwNmZFMjQyMTQy?=
 =?utf-8?B?TzVWZ2dHZDVJU282RG41OEVVQTE0a0U0czRMOTRxWkE0aUxKcnVQemJEcG5P?=
 =?utf-8?B?OGlMbm9jMTFFbTJWYThzZjhQcHVodzc3ZGtxS2lRTEkzWldUVExENXd3c2tC?=
 =?utf-8?B?QTNjVVE5d0Jyb0FseUhXKzFpVjBoWnYxeUlFb1lnejBzRnlQN1NSbGhwRld5?=
 =?utf-8?B?SG5ZRC9xMzRzOW4yMENiUmliQnlLYUU2NDVjUVBlNUIxVm5SMU1GaXljM1oz?=
 =?utf-8?Q?ca40Il3nvztD4G9PTruA/BaifrSg7h1zYrlRUNrtYs=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2972.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca56b48d-427a-4896-5759-08deab358352
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 06:05:45.7933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0swMlU4tUsc3FPOt2ofZmggiBtw+kB19fEnHQ+akJoo7ISeunOkXg/cx3mdjD1C/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5614

QU1EIEdlbmVyYWwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaXJp
IFNsYWJ5IDxqaXJpc2xhYnlAa2VybmVsLm9yZz4NCj4gU2VudDogTW9uZGF5LCBNYXkgNCwgMjAy
NiAxNDoxNg0KPiBUbzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZz47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHBhdGNoZXNAbGlzdHMubGludXgu
ZGV2OyBXYW5nLCBZYW5nKEtldmluKSA8S2V2aW5ZYW5nLldhbmdAYW1kLmNvbT47DQo+IERldWNo
ZXIsIEFsZXhhbmRlciA8QWxleGFuZGVyLkRldWNoZXJAYW1kLmNvbT47IFNhc2hhIExldmluDQo+
IDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCA2LjE5IDAwMS8zMTFd
IGRybS9hbWQvcG06IGRpc2FibGUgT0RfRkFOX0NVUlZFIGlmIHRlbXANCj4gb3IgcHdtIHJhbmdl
IGludmFsaWQgZm9yIHNtdSB2MTMNCj4NCj4gT24gMDguIDA0LiAyNiwgMjA6MDAsIEdyZWcgS3Jv
YWgtSGFydG1hbiB3cm90ZToNCj4gPiA2LjE5LXN0YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlv
bmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lIGtub3cuDQo+ID4NCj4gPiAtLS0t
LS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IEZyb206IFlhbmcgV2FuZyA8a2V2aW55YW5nLndhbmdA
YW1kLmNvbT4NCj4gPg0KPiA+IFsgVXBzdHJlYW0gY29tbWl0IDNlNmRkMjhhMTEwODNlODNlMTFh
Mjg0ZDk5ZmNjOWViNzQ4YzMyMWMgXQ0KPg0KPiBUaGlzIGFwcGVhcnMgdG8gYnJlYWsgNi4xOS4x
MiB3cnQgZmFuIHNwZWVkIG9uIFJhZGVvbiBQcm8gVzc3MDA6DQo+IGh0dHBzOi8vYnVnemlsbGEu
c3VzZS5jb20vc2hvd19idWcuY2dpP2lkPTEyNjM4NTQNCj4NCj4gNy4wIGlzIGJyb2tlbiB0aGUg
c2FtZSB3YXkuDQo+DQo+IFRoZXkgc2F5Og0KPiA+IEFzIG1lbnRpb25lZCBpbiB0aGUgc3VtbWFy
eSwgbGFjdCBmYWlscyB0byBjb250cm9sIHRoZSBmYW4gc3BlZWQgb24gbXkNCj4gPiBBTUQgUmFk
ZW9uIFBSTyBXNzcwMCBncmFwaGljIGNhcmQuIEl0IHdvcmtlZCBwZXJmZWN0bHkgdW50aWwga2Vy
bmVsDQo+ID4gNi4xOS4xMSBidXQgZmFpbGVkIGFmdGVyIHVwZ3JhZGluZyB0byBrZXJuZWwgNi4x
OS4xMiBhbmQgYWxzbyBmYWlscw0KPiA+IHdpdGggYWN0dWFsIGtlcm5lbCA3LjAuMi4NCj4gPg0K
PiA+IEkgYXNzdW1lIHRoZSBwcm9ibGVtIGlzIHJlbGF0ZWQgdG8gdGhlIGZvbGxvd2luZyBrZXJu
ZWwgY29tbWl0IHRvDQo+ID4ga2VybmVsIDYuMTkuMTI6DQo+ID4NCj4gPiBjb21taXQgOWI5NjI2
NmEyZDQ2OWNhNjU3NmZkMGEwNzFhNDhlNzFhOTQzNjY4Ng0KPiA+IEF1dGhvcjogWWFuZyBXYW5n
IDxrZXZpbnlhbmcud2FuZ0BhbWQuY29tPg0KPiA+IERhdGU6ICAgV2VkIEFwciAxIDEyOjE2OjM3
IDIwMjYgLTA0MDANCj4gPg0KPiA+IFNpbmNlIGtlcm5lbCA2LjE5LjEyIHRoZSAiZ3B1X29kIi1G
b2xkZXIgdW5kZXINCj4gPg0KPiA+IC9zeXMvY2xhc3MvZHJtL2NhcmQxL2RldmljZS8NCj4gPg0K
PiA+IGRvZXMgbm8gbG9uZ2VyIGV4aXN0LCBzbyBsYWN0ZCBmYWlscyB0byByZWFkL3dyaXRlIGRh
dGEgd2l0aGluIHRoYXQNCj4gPiBmb2xkZXIgYW5kIGJleW9uZC4NCj4gPg0KPiA+IE15IHByb2Js
ZW0gaXMgdGhhdCB0aGUgJ3NlbnNvcnMnIHV0aWxpdHkgcmVwb3J0cyBoaWdoIG1lbW9yeQ0KPiA+
IHRlbXBlcmF0dXJlcyBvbiBteSBXNzcwMC4gRXZlbiB3aGVuIGlkbGUgdGhlIG1lbW9yeSBzdGF5
cyBhYm92ZSA3NcKwQw0KPiA+IGFuZCBhbmQgcmlzZXMgdXAgdG8gMTAywrBDIHdoZW4gd2F0Y2hp
bmcgYW4gQVYxLWVuY29kZWQgbW92aWUuDQo+ID4NCj4gPiBUaGUgZmFuIGlzIG5vdyBjb250cm9s
bGVkIHNvbGVseSBieSB0aGUgUmFkZW9uIGZpcm13YXJlLiBUaGUgZmFuIHJ1bnMNCj4gPiBhdCB+
NjAwIHJwbSAoMzAlKSBhbmQgZG9lcyBub3Qgc3BlZWQgdXAgd2hlbiB0aGUgbWVtb3J5IHRlbXBl
cmF0dXJlDQo+ID4gYXBwcm9hY2hlcyB0aGUgY3JpdGljYWwgdmFsdWUgb2YgMTA1wrBDLg0KPiA+
DQo+ID4gVGhlIGN1cnJlbnQgc2l0dWF0aW9uLCB3aXRoIHRlbXBlcmF0dXJlcyBydW5uaW5nIHZl
cnkgaGlnaCwgaXMgbGlrZWx5DQo+ID4gdG8gaGF2ZSBhIG5lZ2F0aXZlIGltcGFjdCBvbiB0aGUg
Z3JhcGhpY3MgY2FyZCdzIGxpZmVzcGFuLg0KPiA+DQo+ID4gIyBzZW5zb3JzIGFtZGdwdS1wY2kt
ZTMwMA0KPiA+IGFtZGdwdS1wY2ktZTMwMA0KPiA+IEFkYXB0ZXI6IFBDSSBhZGFwdGVyDQo+ID4g
dmRkZ2Z4OiAgICAgIDE3OS4wMCBtVg0KPiA+IGZhbjE6ICAgICAgICAgNTk2IFJQTSAgKG1pbiA9
ICAgIDAgUlBNLCBtYXggPSA1MzAwIFJQTSkNCj4gPiBlZGdlOiAgICAgICAgICs2My4wwrBDICAo
Y3JpdCA9ICsxMDAuMMKwQywgaHlzdCA9IC0yNzMuMcKwQykNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgIChlbWVyZyA9ICsxMDUuMMKwQykNCj4gPiBqdW5jdGlvbjogICAgICs3MC4wwrBDICAo
Y3JpdCA9ICsxMDUuMMKwQywgaHlzdCA9IC0yNzMuMcKwQykNCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgIChlbWVyZyA9ICsxMTAuMMKwQykNCj4gPiBtZW06ICAgICAgICAgICs4NC4wwrBDICAo
Y3JpdCA9ICsxMDUuMMKwQywgaHlzdCA9IC0yNzMuMcKwQykgIDw9PT0gaWRsZSspDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAoZW1lcmcgPSArMTEwLjDCsEMpDQo+ID4gUFBUOiAgICAgICAg
ICA0OS4wMCBXICAoY2FwID0gMTUwLjAwIFcpDQo+ID4gcHdtMTogICAgICAgICAgICAgMzglDQo+
ID4gc2NsazogICAgICAgICAgMTUgTUh6DQo+ID4gbWNsazogICAgICAgICA3NzIgTUh6DQo+ID4N
Cj4gPiArKSBpIG5vdGljZWQgdGhhdCBlLmcuIHRoZSBmaXJlZm94IGJyb3dzZXIgaGFzIGEgbmVn
YXRpdmUgaW1wYWN0IG9uDQo+ID4gK3RoZQ0KPiA+IG1sY2sgdmFsdWUgYW5kIHRoZSB0aGVyZWZv
cmUgdGhlIG1lbSB0ZW1wZXJhdHVyZS4NCj4gPg0KPiA+IFRoZSBwb3NzaWJpbGl0eSB0byBzZXQg
dGhlIGZhbiBtaW4gdG8gOTAwLTEwMDAgcnBtIHdpdGggbGFjdCBoYXMNCj4gPiBoZWxwZWQgdG8g
a2VlcCB0aGUgdGVtcGVyYXR1cmVzIGJlbG93IDY1wrBDIHdoZW4gaWRsZSBhbmQgYmVsb3cgODXC
sEMNCj4gPiB3aGVuIHBsYXlpbmcgYW4gQVYxLWVuY29kZWQgbW92aWUuDQo+DQo+DQo+IEFueSBp
ZGVhcz8NCg0KVGhlcmUgaXMgYSBrbm93biBpc3N1ZSBoZXJlOg0KaHR0cHM6Ly9naXRodWIuY29t
L1JPQ20vYW1kZ3B1L2lzc3Vlcy8yMDgNCg0KVGhlIGFtZGdwdSBLTUQgd2lsbCBkaXNhYmxlIHRo
ZSBncHVfb2QgZmVhdHVyZSBpZiB0aGUgdGVtcGVyYXR1cmUgcmFuZ2Ugb3IgUFdNIHJhbmdlIGlz
IGludmFsaWQuIC5lLmcuIG1pbi9tYXggPT0gMCwNCkl0IG1heSBjYXVzZSB0aGUgU01VIEZXIHRv
IGNvbmZpZ3VyZSBwYXJhbWV0ZXJzIGluY29ycmVjdGx5Lg0KDQpQbGVhc2UgY2hlY2sgd2hhdCB0
aGUgT0RfUkFOR0Ugc2hvd3Mgb24geW91ciBjYXJkIHdoZW4gdXNpbmcgdGhlIG9sZGVyIGtlcm5l
bC4NCg0KQmVzdCBSZWdhcmRzLA0KS2V2aW4NCg0KPiA+IE9EX1JBTkdFOg0KPiA+IEZBTl9DVVJW
RShob3RzcG90IHRlbXApOiAwQyAwQw0KPiA+IEZBTl9DVVJWRShmYW4gc3BlZWQpOiAwJSAwJQ0K
DQo+DQo+DQo+ID4gRm9yY2libHkgZGlzYWJsZSB0aGUgT0RfRkFOX0NVUlZFIGZlYXR1cmUgd2hl
biB0ZW1wZXJhdHVyZSBvciBQV00NCj4gPiByYW5nZSBpcyBpbnZhbGlkLCBvdGhlcndpc2UgUE1G
VyB3aWxsIHJlamVjdCB0aGlzIGNvbmZpZ3VyYXRpb24gb24gc211DQo+ID4gdjEzLjAueA0KPiA+
DQo+ID4gZXhhbXBsZToNCj4gPiAkIHN1ZG8gY2F0IC9zeXMvYnVzL3BjaS9kZXZpY2VzLzxCREY+
L2dwdV9vZC9mYW5fY3RybC9mYW5fY3VydmUNCj4gPg0KPiA+IE9EX0ZBTl9DVVJWRToNCj4gPiAw
OiAwQyAwJQ0KPiA+IDE6IDBDIDAlDQo+ID4gMjogMEMgMCUNCj4gPiAzOiAwQyAwJQ0KPiA+IDQ6
IDBDIDAlDQo+ID4gT0RfUkFOR0U6DQo+ID4gRkFOX0NVUlZFKGhvdHNwb3QgdGVtcCk6IDBDIDBD
DQo+ID4gRkFOX0NVUlZFKGZhbiBzcGVlZCk6IDAlIDAlDQo+ID4NCj4gPiAkIGVjaG8gIjAgNTAg
NDAiIHwgc3VkbyB0ZWUgZmFuX2N1cnZlDQo+ID4NCj4gPiBrZXJuZWwgbG9nOg0KPiA+IFsgIDc1
Ni40NDI1MjddIGFtZGdwdSAwMDAwOjAzOjAwLjA6IGFtZGdwdTogRmFuIGN1cnZlIHRlbXAgc2V0
dGluZyg1MCkgbXVzdA0KPiBiZSB3aXRoaW4gWzAsIDBdIQ0KPiA+IFsgIDc3Ny4zNDU4MDBdIGFt
ZGdwdSAwMDAwOjAzOjAwLjA6IGFtZGdwdTogRmFuIGN1cnZlIHRlbXAgc2V0dGluZyg1MCkgbXVz
dA0KPiBiZSB3aXRoaW4gWzAsIDBdIQ0KPiA+DQo+ID4gQ2xvc2VzOiBodHRwczovL2dpdGh1Yi5j
b20vUk9DbS9hbWRncHUvaXNzdWVzLzIwOA0KPiA+IFNpZ25lZC1vZmYtYnk6IFlhbmcgV2FuZyA8
a2V2aW55YW5nLndhbmdAYW1kLmNvbT4NCj4gPiBBY2tlZC1ieTogQWxleCBEZXVjaGVyIDxhbGV4
YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8
YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4gKGNoZXJyeSBwaWNrZWQNCj4gPiBmcm9tIGNvbW1p
dCA0NzA4OTE2MDZjNWE5N2IxZDBkOTM3ZTBhYTY3YTNiZWQ5ZmNiMDU2KQ0KPiA+IENjOiBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+ID4gWyBhZGFwdGVkIGZvcndhcmQgZGVjbGFyYXRpb24gcGxh
Y2VtZW50IHRvIGV4aXN0aW5nIEZFQVRVUkVfTUFTSyBtYWNybw0KPiA+IF0NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+ID4gU2lnbmVkLW9mZi1i
eTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4NCj4g
dGhhbmtzLA0KPiAtLQ0KPiBqcw0KPiBzdXNlIGxhYnMNCg0K
