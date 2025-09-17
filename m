Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012021.outbound.protection.outlook.com [40.93.195.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161FA18FDBD
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119624; cv=fail; b=gzEBP6SD9/BT67CY8Qq3RLMKOcbDWBiR6Y+Cj862jRxkoabZglZ3jMXQgKhB76yGmAyx/Buy2K7cLChOQB2g0etoPFTjgcyjJjg1B97Jwc1UZEXM4Bpl9Ipdb+REEsPltECvwWJZyYMeKYylbCuBH3AydCnY7Iwevdv1s/UlASw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119624; c=relaxed/simple;
	bh=Q4QHK8bqrhXaVbXHzcusQ9sm9mr9nahCVHsm/A/7QS8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eJqoKQ+f5MzbgSnT6cwRApzKfoWdMeCyzPYlxGhruu4kkIEO9jCEyNFu5UdZjbOo1+iMGEg5DrGmB24V6CC5hHEtvngTcGTfo27Ty40geeTGwKS69U4Ee1G/CdHgpsKPrwqTsyH5SAktyaSgREgh5Rd70R5M4fUYFu4JKh5YFYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p0dDHl76; arc=fail smtp.client-ip=40.93.195.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p0dDHl76"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=efkJdQUIuDOcglMiPp6RAfw51lk/QAY8SijwhmkY5us5ssEUsvg1FuQymAYe9gaz5s0a+MICYCorl4rJsmh4NJGHG/iWUKgZ8cXOq3erIxaVwk91sA1+iMCY5je2lt2yzDZvJoq0rRCOy68m+Re1+p9Dt+bjTINHK9gOhkh/zbD+ymoMVgRtkFJd7uyAP72D+ypLefnb5s/Iv/MAm9dofIcGSPYp8osjrw35WUHB2O5+GySWuPI4uhR7ga3WLZ0N06vN64dAvU7lZHLZItCkKguaGsjI+/u4VWIuBsj2jONNC98PLGOTzB3+uZxUABRJOpGEHIpY4Znnk+jn4tT2ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4QHK8bqrhXaVbXHzcusQ9sm9mr9nahCVHsm/A/7QS8=;
 b=fUGwIP4Sn6tVlH2NFBFZ1TCz7pMq5jk/LGIvKl1fIfNMfV/Iqx5vs6v2DogR9zzL1+CIVcNCvBFpFzyOBYQtlcQ5t3ilvUVPc9xm1xeoFYPt/jlHGcB84RNwunlT3H3OQU5P+PTNAcItEPWJ/9Rf/nuoUKakFV5LnAR5krVsvewJ9J2B95BWM8txc4T9E0fR6i11LxNsKT59rxYmLVNFLh2LHV4FN8QmxZSADWicHH5CNP02WeeMDDyoGzaGRG0gGnlCbwP5XhGbbM63HC7s/Vd7j/0TWTrxvSfQxp6HBh1HH1c8HTJXuO+/U45Ne9+tKhNway4VZisXWdnZix//Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4QHK8bqrhXaVbXHzcusQ9sm9mr9nahCVHsm/A/7QS8=;
 b=p0dDHl76nbMf4wAdbVUKbMmN5cRUx6McAytZnsAyLUGUjGaVOw2eQ/HLo1zOoc8shOvlFziOcwh+zQOl0mJNr4lxBDnyR8Qj0lcJfMAnaCqaP+o+MXGsIQ+1nYBhnykj+OhBG/VFyUJmTCfahijQZkfm4gD8a9tGHkgKzDxHaEQ=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by PH8PR12MB8432.namprd12.prod.outlook.com (2603:10b6:510:25b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 14:33:39 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::491a:cce3:e531:3c42%7]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 14:33:39 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "cao, lin"
	<lin.cao@amd.com>, "Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>, "Koenig,
 Christian" <Christian.Koenig@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup
 when unloading
Thread-Topic: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup
 when unloading
Thread-Index: AQHcJ9OAiwMKfZn0FkSpN+IDyJZ6UbSXcAgA
Date: Wed, 17 Sep 2025 14:33:39 +0000
Message-ID:
 <BL1PR12MB51449335D2432734B3C149DEF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20250917123329.576087662@linuxfoundation.org>
 <20250917123331.416162682@linuxfoundation.org>
In-Reply-To: <20250917123331.416162682@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-09-17T14:32:06.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|PH8PR12MB8432:EE_
x-ms-office365-filtering-correlation-id: b8a9bc4f-a363-4b26-8594-08ddf5f731b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dWtWMXpJeDh0MGwyNzhhNkZFZDNZc2RaWkxSTzZ5Ym9TTmxLUzI5aGp3OGN5?=
 =?utf-8?B?aEExTGNKbmFXVzhxUTd0T2xnK2FKa2U2dDFpL0QxY3lBcHZZTnNFU2orcTBE?=
 =?utf-8?B?OUtnZFJ0eXNpM3RsSng5cFNhSmVUTnR6bjhaUGhBZzhlTHlDZEJ2WVU1a09q?=
 =?utf-8?B?bHZiTUlEZ21RNm1IMVJNTENjNk5seDhML3ZFMkFaV2FUbVFCZ3F5V3h4MGVu?=
 =?utf-8?B?TXNSZFhkN0lBZHZtQ2JObXhraXpHeTJ0VHdxaHlOZEJRcmRsbWJTT0ozVFpn?=
 =?utf-8?B?c3VBQ2E0YnFCRUZoN0tNQjRzTURYN2ZLdWIwTmJTT0U4MGdzUXVjdFQ2azkv?=
 =?utf-8?B?S3dTcUx5Q0hHRlo1bHByTkp3VWE2a3h0R2hubXgzNFFMQ0ZvSFM3SnBDVnBn?=
 =?utf-8?B?Wnp5MWhselpvMEhQY0hsbzBxRzM1WnJpM1N6UC93K25USE02NjFaaHpXWThv?=
 =?utf-8?B?bE9ZdEZ0MHBHTk5kQ0N0ZmxVTmQ1KzcxSHh4a3F3K3BiNTY2dFRaejlOTmRB?=
 =?utf-8?B?L3BTMU9VcXZ6RWxzMEJIU1oyQzhnbnFic1l3ZWV3bXE5L1paTC9Wek1sUlY2?=
 =?utf-8?B?aDlHV2RzTEdEQXpIQkJxeHpGZGlLR3U2SVRPaVdEY0pVTWN5T1Nud2ZiaG84?=
 =?utf-8?B?bkNKNDNDckFsYUlTVzR0bFhla29vdDdCSnE1MEJKWWNwUkhrRTRtZEpuS0FG?=
 =?utf-8?B?Rkp1NDMvKy9VY3BUZGQ1eTVYVHNkZ3ZSblBTM1hkZW9LbVJ0M2hRYXdTaHd5?=
 =?utf-8?B?SXAvbHY3d01teWhXeWxialBBYW9QRDRGbDRBY3FNVUdHVHRWL0Z0T3I2SjYy?=
 =?utf-8?B?TCtHQUJUVlVuRDRqL0JDV3JwV3NqS2s0QVNnWGt6a0swRTliTjlsaUtPRlZ2?=
 =?utf-8?B?bVlaYkJ3QUs4WDUrOWVwMUJPOWNzQlduR3ZBSXpCTWIvMEh0RG42cFNUMGZk?=
 =?utf-8?B?Wjh0MURzZnlWOG9LWXNsRHZJRkZBbHp4MnJZMWc5UlNRd2JkRDVFeTZqTTdr?=
 =?utf-8?B?dExoSlZLTGxxdWV4N3BURHJsYmpGUWpXdXU0R0hENnNzZ2FQc0o3WnBuSXpD?=
 =?utf-8?B?UWFTMHBhZ2VQQ0VibFJlK0F0d3d2V1dhWnFJUHVWQnRLMlBWc3pZanArMW5z?=
 =?utf-8?B?ZU03S2h4VEZCcUx5TFVGSXdvK3NhNTkyNmlqVHNFVWhnV1l4ekpvVzV4ZW9k?=
 =?utf-8?B?MnZRVWx0c0pxU1h6dk9oamx4VFN0ajh5Smt6U1Vib0crQVRobDdGNFk2dDll?=
 =?utf-8?B?V09wWnphRkRlVEV2TndOd0FWalh3bUhYWHlCZ2ovNDE3VUwxTUEzdGhDVUhw?=
 =?utf-8?B?SG1aK1F2RHdkNGZRcWRBQ2tZV0lWd0x1T1JYVlFRMExlVU9XQ01MR0kvM1Vl?=
 =?utf-8?B?TWxVNVRldDBKV3NwODNzSTJ2d0R2c2xVMlBVSXMwbHA4Q0E4VzNOSmVUWmZT?=
 =?utf-8?B?cjI3eG9XenREYUs0RG4xNWRrWGNMTTdpNDhSMkNTdVRabnBBa0JWTVVKS3Z3?=
 =?utf-8?B?YmNxcjZjSjRWcVFRMlo4YmE1T2l6alZib2lxdUVJMFZpMldpT2FYQzN2VGVR?=
 =?utf-8?B?ckFBWk1NN2NVMGIwODk3YmQwelg3L1ljQnZNTTJTVEdFUTNnTTVSaTlKZ2hi?=
 =?utf-8?B?WmtiRU9JV3J5Zi80UVBpWS91TEtpcjZVUENDdUx4dm9tTjNLSDVxck9ManZv?=
 =?utf-8?B?UHJ1Ry9KSGFnSlNvVUI3RE9ISndmTi82TVVEY3Voa3FhRW5LYXdBRHhFSEs2?=
 =?utf-8?B?dTl0ZTNGTXQxV2VhdmhoMVU0ZG1kM2xKaUxXMFhrWmlzeEFwMEU0Sy9oVFNW?=
 =?utf-8?B?d0tPYjNFczhMaXY4NUt1cjYzMWFPUytRWjd0UEo1OVNHM3RNV25RRkxWQ0JL?=
 =?utf-8?B?Znhya0Vsb1U0MllRSnVWOG1kZ0krZXpud2V2bXBuR1VxbVl0R09FcVVjNmI2?=
 =?utf-8?B?NXdiRDdNN3ZUeHZ0N2cxaFcxUTFtQTNUdnVLazlOTDYwa3JkeFRINEN4ZEhv?=
 =?utf-8?Q?Ahf7KHfPqgo4vQFgf7Diy/+xaZ8WcU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WDFqeXlmbmtqNXd5cU9ISmNRY00vdGVDdHBoRnJZTkNsVktQaExhMzV3d3ht?=
 =?utf-8?B?aDZZK3JKcU5lQ0MvMGtaYXR3Q1p1TDY1TTMxV0QvVGI0eDlDYnpWS3VYRUhi?=
 =?utf-8?B?a0JWUXI5LzVGWnlrV2UxamlIVFNJRWlpUnZmbzBwV05WZTJOMGJseVhqQnNQ?=
 =?utf-8?B?TDYwTVZrM1lvdjIyTW5CR05aeis5L2RESlJpNDRDYk1RVjFUNkhXNm5rcisr?=
 =?utf-8?B?cDRvK3dWSE85WCthQ3BoM0pHMnY4bDlBdFoyb1FvZnppVXdLZlp1cGJkWEJ2?=
 =?utf-8?B?bXU5QVI3ZEZXaTJ0TDh6NWlROE5XMzR4TTIzMEx6OUhWWEZnOTI1UFJWMDZo?=
 =?utf-8?B?c1I0Z0loQW9tOStodDBmU3lOb0l5RDhtcS9SZnJ6K1c2WThiZWxGcnIvWUho?=
 =?utf-8?B?bnMwamRJcWs0U3VHVnNjNXZRU1d3N0p0KzlzbnllNzdNeHV5cUtvbXFpNjll?=
 =?utf-8?B?VjJ0b1JSWkNQQllpbHQvYWY3ZkNzaVc5cDhSNUVmVW9hMWQ4NlBaUGoxOVl4?=
 =?utf-8?B?eFRNUzZFZk0xWDZrWHFidVlTYlRHZXF2WWNNWU1UY213WmViUitTaXRnVTMr?=
 =?utf-8?B?eUg2Znh6eGpkWmEyaWt3WSt3NDQrZVZlTEdlR1ZYeWtOYW1KRnN6V2JYbkRk?=
 =?utf-8?B?Sm1TTEFKd2FYV0VyNStTSlpSaTBuU0U1SE1obnAvVnpScThiMXlTZTYweUQw?=
 =?utf-8?B?VWNjSXFGSG1sK1BVTWpvc3ZwVkpqekxoWXFlc3lXSEtqMnBDSjFnYTViNW9p?=
 =?utf-8?B?UDE4QUg0NG1GQWl5MHYyWnk0WjhqUlQwcVl5ZVJYU1JvVmtDUmFPa3p4bnhH?=
 =?utf-8?B?NGFqdUZZWHhpZHJBWnQvWVhvN01UOG8raFJSM3p0ZytqM09xRm5VRzNTR2dP?=
 =?utf-8?B?dTY5Q2JpclpLL1d0SFVaL3A0RjlTT0didkdsbW9ValUyaGh2ZmFpbEVGTkdz?=
 =?utf-8?B?MlQ1MW9BWUMxM1l4TmxaRXVDd1BjSCtkeWxLSnE2cldnTDFHWTVTdzNiZEtH?=
 =?utf-8?B?RzE2K2RxbXFsUTU3M0JxN1hVVGJiUzUyRzVVeXJGdHFmN2dNMWxMdXNFYm5t?=
 =?utf-8?B?bU1IQUx1S04vMWZTMUhBcXFJRFhWSWZBdWc1UWNTNnVwT25uc0drS3VBTTNI?=
 =?utf-8?B?T0tWTmJ0QWdHaVQzSlZnWHRqQzBMblZJakliUldOZXNDVXZRM1ZLN0cvYXQ5?=
 =?utf-8?B?SnQ1RVhEbUJtdmFFQnRGeUFkNWYwSkpaTXNGRThwU2VTY0xRL0R1U2hTekE1?=
 =?utf-8?B?YU5iOU9KNFlQMHBzMGlGNnRZT1VhU0dTcDdVZFRPeHZ3NGwxMHc0bVN1dTdj?=
 =?utf-8?B?dkJIdVRYZFA3eDRrZHF5ZWt5RDR3bG9DTHgrcXlUR0NjVEJJYWhEV1gwcDk2?=
 =?utf-8?B?bGlQd1pQWE1oeGRrbi9TWXV2SXFDZnBNck1hM0x4czZicE8yZFhVcGdrd1Vo?=
 =?utf-8?B?Z25pbllDNnBSOFUydy9qb0xWTExCbDJ4NWRxVjkvSzBSdytVTkttRFQxWDgy?=
 =?utf-8?B?NThiMjJlcGlydGUyU3JBYWdvVDkxbE9lY090RjEzWXF5UU40TnEwWUNCZFVS?=
 =?utf-8?B?RlFSM0JjY3R5bXFmb05LOFpncWM5RC9EMXBVRjdiS2lXZHl2N2R1OGdxbTE4?=
 =?utf-8?B?bmtLUm5QaVJNTEUyVUZmMVVLdEY2cFJoWTN0UjlEUUFHeTJaOEZsbUQyMGsx?=
 =?utf-8?B?UUNWYU4vbzlieXJpRDA4L3VHZDI0LytFaFdIQllHMGFSM0t0UkQycjAzQVZk?=
 =?utf-8?B?VDg4OU1zTkhCcUpxdXRCN3RpQU8yRkF0RzVDWStQTzdueFh4L2crNmdJVmxP?=
 =?utf-8?B?ZVhTK2hoZFNzNlFqaWJTY3MxZVB1aGRhR1JkWnZsQkNydXp0MGVyZzhyS2RE?=
 =?utf-8?B?UHNlbEpvY2tzSGtKQWZwbXRPZll4dCtCSmdONlc0NGF0dGJyWEhFRGFxNDNS?=
 =?utf-8?B?dDk4TVBvMStXaTlsaTIraWcwYVRyRzBTZ1RrdWc5NERCaUFoMG9ObnU1THh1?=
 =?utf-8?B?d1VSNWNuZFk3Y1F5RWNjSE9SOW5tZ0hjUHFMS0NYZUFnQzhqSFZlOS9XcWs5?=
 =?utf-8?B?WHBWWU5BT2R2bUhJT29hZmMySFMwTTFOZWFXQjBuWWUwV2ZGcjRIVFdGVzUy?=
 =?utf-8?Q?hk+c=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a9bc4f-a363-4b26-8594-08ddf5f731b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2025 14:33:39.5954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRFjhxaq2bBmgeqOQbq3Y40TU3ajvS2QfQPVQ+ppZlOJfRkM9k/KybEMUrArF2zo0SQIzyi7Lb+UY81LiBOS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8432

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRt
YW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRl
bWJlciAxNywgMjAyNSA4OjM2IEFNDQo+IFRvOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsgcGF0Y2hl
c0BsaXN0cy5saW51eC5kZXY7DQo+IGNhbywgbGluIDxsaW4uY2FvQGFtZC5jb20+OyBQcm9zeWFr
LCBWaXRhbHkgPFZpdGFseS5Qcm9zeWFrQGFtZC5jb20+OyBLb2VuaWcsDQo+IENocmlzdGlhbiA8
Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5k
ZXIuRGV1Y2hlckBhbWQuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiBT
dWJqZWN0OiBbUEFUQ0ggNi4xIDc1Lzc4XSBkcm0vYW1kZ3B1OiBmaXggYSBtZW1vcnkgbGVhayBp
biBmZW5jZSBjbGVhbnVwIHdoZW4NCj4gdW5sb2FkaW5nDQo+DQo+IDYuMS1zdGFibGUgcmV2aWV3
IHBhdGNoLiAgSWYgYW55b25lIGhhcyBhbnkgb2JqZWN0aW9ucywgcGxlYXNlIGxldCBtZSBrbm93
Lg0KPg0KPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4NCj4gRnJvbTogQWxleCBEZXVjaGVyIDxhbGV4
YW5kZXIuZGV1Y2hlckBhbWQuY29tPg0KPg0KPiBbIFVwc3RyZWFtIGNvbW1pdCA3ODM4ZmI1ZjEx
OTE5MTQwMzU2MGVjYTJlMjM2MTMzODBjMGU0MjVlIF0NCj4NCj4gQ29tbWl0IGI2MWJhZGQyMGI0
NCAoImRybS9hbWRncHU6IGZpeCB1c2FnZSBzbGFiIGFmdGVyIGZyZWUiKSByZW9yZGVyZWQgd2hl
bg0KPiBhbWRncHVfZmVuY2VfZHJpdmVyX3N3X2ZpbmkoKSB3YXMgY2FsbGVkIGFmdGVyIHRoYXQg
cGF0Y2gsDQo+IGFtZGdwdV9mZW5jZV9kcml2ZXJfc3dfZmluaSgpIGVmZmVjdGl2ZWx5IGJlY2Ft
ZSBhIG5vLW9wIGFzIHRoZSBzY2hlZCBlbnRpdGllcw0KPiB3ZSBuZXZlciBmcmVlZCBiZWNhdXNl
IHRoZSByaW5nIHBvaW50ZXJzIHdlcmUgYWxyZWFkeSBzZXQgdG8gTlVMTC4gIFJlbW92ZSB0aGUN
Cj4gTlVMTCBzZXR0aW5nLg0KPg0KPiBSZXBvcnRlZC1ieTogTGluLkNhbyA8bGluY2FvMTJAYW1k
LmNvbT4NCj4gQ2M6IFZpdGFseSBQcm9zeWFrIDx2aXRhbHkucHJvc3lha0BhbWQuY29tPg0KPiBD
YzogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29tPg0KPiBGaXhlczog
YjYxYmFkZDIwYjQ0ICgiZHJtL2FtZGdwdTogZml4IHVzYWdlIHNsYWIgYWZ0ZXIgZnJlZSIpDQoN
CkRvZXMgNi4xIGNvbnRhaW4gYjYxYmFkZDIwYjQ0IG9yIGEgYmFja3BvcnQgb2YgaXQ/ICBJZiBu
b3QsIHRoZW4gdGhpcyBwYXRjaCBpcyBub3QgYXBwbGljYWJsZS4NCg0KQWxleA0KDQo+IFJldmll
d2VkLWJ5OiBDaHJpc3RpYW4gS8O2bmlnIDxjaHJpc3RpYW4ua29lbmlnQGFtZC5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4gKGNo
ZXJyeSBwaWNrZWQgZnJvbQ0KPiBjb21taXQgYTUyNWZhMzdhYWMzNmM0NTkxY2M4YjA3YWU4OTU3
ODYyNDE1ZmJkNSkNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gWyBBZGFwdCB0byBj
b25kaXRpb25hbCBjaGVjayBdDQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxA
a2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdw
dS9hbWRncHVfcmluZy5jIHwgICAgMyAtLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGRlbGV0aW9u
cygtKQ0KPg0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfcmluZy5j
DQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV9yaW5nLmMNCj4gQEAg
LTM2OCw5ICszNjgsNiBAQCB2b2lkIGFtZGdwdV9yaW5nX2Zpbmkoc3RydWN0IGFtZGdwdV9yaW5n
DQo+ICAgICAgIGRtYV9mZW5jZV9wdXQocmluZy0+dm1pZF93YWl0KTsNCj4gICAgICAgcmluZy0+
dm1pZF93YWl0ID0gTlVMTDsNCj4gICAgICAgcmluZy0+bWUgPSAwOw0KPiAtDQo+IC0gICAgIGlm
ICghcmluZy0+aXNfbWVzX3F1ZXVlKQ0KPiAtICAgICAgICAgICAgIHJpbmctPmFkZXYtPnJpbmdz
W3JpbmctPmlkeF0gPSBOVUxMOw0KPiAgfQ0KPg0KPiAgLyoqDQo+DQoNCg==
