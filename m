Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2073.outbound.protection.outlook.com [40.107.103.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C70D16419
	for <patches@lists.linux.dev>; Fri, 11 Oct 2024 01:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.103.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611464; cv=fail; b=cLHbFsi6/I3jzHMB2eHjeZK2Fts39kEVcK3ElzLInyjyMjIApVYFcSbbaAqiQ6/hxMkKuKGfPriCHL6FoXtFZqzevkOxWve+zHxKs2BuHWFq2QFFWlbJDDk/SuKFgn1SDyQRQUE0d7Dp9dYklTCEpin+ya0fWX18x12P8CKrRbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611464; c=relaxed/simple;
	bh=/BVqC0VLsxrxBPbUotNGBM41rC6nOyICKy+PquNP/AE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r3hkoldsrCOi0LkvM3QxCkvhrzHkk48JYBykdeu19DiCGWgAjStAVKMmku4M0CKr2GvfvDW7GL/Xsntc3YJvkxVrjTke2Z3yNQsjgDzH++ly0B1AbP6baNVERrREQYYmMS/diujdGdBiTd3uMklasn2TypYDARXS88UlOqShFf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=lHhjXDpd; arc=fail smtp.client-ip=40.107.103.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="lHhjXDpd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jq1qWmLNXVy6R2bP/AqcsQa2Mlbdmw0ijxB5igxZz+JE5a6BL8ll2gJPxMXz2Hgdl0vGkM9OdSGrdcIp8CqjMebeGKSVAxJPZ3PC8PA2LznHGyXLASsXjMiXb/RMbfJzw+N++eEw6aC3bs6h7ZMKPdPjKsvHbFyzfppa1aubWQp/RGbq/YSLzVzTQrzMI2Tl7q3crgalnNXibDT56MybCKfvVJWTVbrZjQr36M2/cVpfOcRhaY/pYT4cKDneKRv8sTqoVFrINDSi5cVmeC17bClAe9FeoxaWIX67jwrg/oMaRwM27kT0HZYmV8CLQms41xqy9A12ARHlr2o+AvpDtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BVqC0VLsxrxBPbUotNGBM41rC6nOyICKy+PquNP/AE=;
 b=zSZOhpv8ykvGQRCxs2DitaY5Pa9SAkL5uRcK/3VL6ofZs43ysyZnw5DpM/Vp2lyF+g+9rr+eTEjBr9/bPGxNMjyMM0x3vMThkddl31uJSWQy2DZW28E8bxABUu7o8Omu6HBva4B1It9HISkmJQQvxjXpMWBkCy1BSavCprDz4A33jWY1/N+2Uub0VOdxtpIM/uBRlkv8wxamWxGXenyh7g0UakFUkYefOeEzII3Dgz4Xq0B0syqqO1NHOXcxmP2S0peiwyI29QiT2nuecbLt7xigGaQjDkKPF1smMtRupmQaTOH7dRG1Ix7cFPOvvEBWaXJldSPlQq/BTi+7lQ+XMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BVqC0VLsxrxBPbUotNGBM41rC6nOyICKy+PquNP/AE=;
 b=lHhjXDpdBgmqAUKwlrao/GHmT9pqTPsck5QSaGeqAVD+SLJ2w/iW4jyqaCspPruoK4FaBnGI8vn6S3CHJYr1R2YJ7bZQzJHBaRg6yQbAxymUQR0gcNrwXZjwbtLNiXLDIcmXdz4dVY6ySJ86LG1waV6QtkegpvvIg30kERFDoesskDC/RWy/XCdtILHT76TtMmvvaqjf8emHHGgg/RRiOxxANqrU5EBEf1RlfLve+/9qXvdxS/oguEPYnDxPBgujKws2paYBf1SFzl2xyaFR/2zwfdqu3FE6Z4gWvnKwiZ029iAe/qvZiNV3nW6WmMjt6aXibWv9N2pEFio2oDNfFw==
Received: from PAXPR04MB8510.eurprd04.prod.outlook.com (2603:10a6:102:211::7)
 by AS1PR04MB9285.eurprd04.prod.outlook.com (2603:10a6:20b:4df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Fri, 11 Oct
 2024 01:50:58 +0000
Received: from PAXPR04MB8510.eurprd04.prod.outlook.com
 ([fe80::a7c2:e2fa:8e04:40db]) by PAXPR04MB8510.eurprd04.prod.outlook.com
 ([fe80::a7c2:e2fa:8e04:40db%7]) with mapi id 15.20.8026.019; Fri, 11 Oct 2024
 01:50:58 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?gb2312?B?Q3OormuoonMgQmVuY2U=?= <csokas.bence@prolan.hu>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Paolo Abeni
	<pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
Thread-Topic: [PATCH 6.6 028/386] net: fec: Restart PPS after link state
 change
Thread-Index: AQHbGYZRPYhz9HNu7k20NdANBO/rHbJ/wqwAgAEJMwA=
Date: Fri, 11 Oct 2024 01:50:58 +0000
Message-ID:
 <PAXPR04MB8510F6DD068CE335D6D7202188792@PAXPR04MB8510.eurprd04.prod.outlook.com>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115630.584472371@linuxfoundation.org>
 <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>
 <2024101033-primate-hacking-6d3c@gregkh>
In-Reply-To: <2024101033-primate-hacking-6d3c@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8510:EE_|AS1PR04MB9285:EE_
x-ms-office365-filtering-correlation-id: 845ef520-fa71-4e0c-ec40-08dce99726e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?gb2312?B?N0w4SUF0dTdaUHIwNTdKSURjaWJNK25ReVp6T0JxRzhjQWZGT3N5MTAwWnRh?=
 =?gb2312?B?NWYyN3hoNGJJWmxSemsrY1pOVDRNM0NtMk1YT3V3UUdNU3ZpNzNZWWI4WFQy?=
 =?gb2312?B?cVJ2SlhhbnI2MHl6NUxaMmkzYWZ1aHFGUEY1RnpwdWhCemgwYk80Q1BIamdq?=
 =?gb2312?B?eER2ZzhuUmJQR1pQT3JURWl5NEk3cjdjRWJhSUZIeUI1YWhvUk9DZ29QdXhp?=
 =?gb2312?B?ZkpBa0JqeHpRaTZ6MFNMTGM5SjAzRkJhSWRxUVZ3Qy9LMVNpdnhvVnQwMGwz?=
 =?gb2312?B?U3Rvby9OcFhSZ3pROEZDL0VTMEZTekpIOHNjbU9zMUhwTlR2UGQ1dGxZMVh6?=
 =?gb2312?B?dktMaEE4blRzdEE0MkxSREZacWVvckVNVUtwRzVQc24ySHErWE13YVdiZTFS?=
 =?gb2312?B?a2JOb3dkaEVRUlZuVnZVcno2aXB0MmtiV0s0N2tKTGx2MmhIblBPZFdwcXdu?=
 =?gb2312?B?QjFrYnNTMk5uVzFOc3dVK0ZGdG1wWjhhU0t4ajhEczRwR1dJU2lZN04yWG02?=
 =?gb2312?B?bEV4eWsyNFlpTStTbUowQ2h2YjJYRmpWN2ZrR1U2RXZ0QzA3Q21UeEpJRTlT?=
 =?gb2312?B?dHJZbkZ6RFpyem9Vc2tsK3dHOUxHRld1ZEYxY3VhUzlnaFhrbHJNcU84b0Rl?=
 =?gb2312?B?WkIycFNPam9NY3E1UTJESUFRdURnS05IOVlPZ0F1dmZPV0hrZ1BRUGxUZ1hq?=
 =?gb2312?B?NEpNempZNklqYlFCTjZxTU5ZdjM5eEpwQnJKYlhGNE8zODd6SnluUnl4RGha?=
 =?gb2312?B?bERySjBSR1BhZndSaXNiSnJkd1Y4cjdQeTd4Yyt0ZGFkbHIzOUQxOUNwVGV5?=
 =?gb2312?B?NUVSREV6Mmp2aSt6Nzl3L084SDd2VVJIRW5CRzZvYzN1ck1KVWJ3YWk2RlRs?=
 =?gb2312?B?Zm1PdkQ3Y3JUK3pmTmZSbGNKOXpGTXpyb25ja01LV3o0Vm9DTXYrTGhiWjNw?=
 =?gb2312?B?ajZtNEdQNjVDTHFZbGFSM0Yxd1hBUVRjdzRyL2h3K0ltS1ZpbWI2WVZpOUdk?=
 =?gb2312?B?a1lBMWtKZkRLNlc0Njd4SWxFamhISTVJd2ZsM3h0N2FKUzhsUEw1dndoVUht?=
 =?gb2312?B?eTBRSlhWeXUyWHpDbFZqMjl6Ry9CYmkycnNNM2MvK0tlL1g2SG1ZSVltQkZl?=
 =?gb2312?B?Qmk3M3RucHFTT3lqNzdidnZvc0J5OC9BVUhKY3djQjJ5RnRyb1h1WVBwWFlU?=
 =?gb2312?B?RnZYeWkveDRXM2JpRTUzdGxVa2tSR2JFazZsWWNOYmZDaUxuaERQMEJVd3lT?=
 =?gb2312?B?RkFYa1pnQi9UbEcvaEtibUV0TUZGOExucVczSnp5bkRwT21weDRSRmNMejE1?=
 =?gb2312?B?NXNyU245WlVLMG9VSzdWaWx3Nkh1U3IrZURVMDhwdjBzd2NLL1EzY25ESERL?=
 =?gb2312?B?NzEzcE0zQ1liQVlBWGZOTTNRbzNVVGhLMjFGc2c1UVdtOWFubnJacDluRVJR?=
 =?gb2312?B?UHIzY0hTbzNSdld3eEFPb1JicDVRWW4zclRYMEVNWjVURXU3TXg5T3RVTm0x?=
 =?gb2312?B?OTdaTW5hNklwbkVUQXdDQ2NtbmZqNVFkTnZoV2dGanBQN1VtMWtTVm5JT0Ni?=
 =?gb2312?B?NFlIYWZmemI4bXlEZjZLZHovaXg0NUg3RDdWZmNzeUFjbGt2SnF3NDg0QlFY?=
 =?gb2312?B?RzZzZUIvNko0aTdad3llZEtWUGo5Y29RU1ZQQ1B4am1CUzhCbEFESE96YTVp?=
 =?gb2312?B?TUJOZFhYL01wSFVCSEdHVkVOREVmZHp0Ty9MblNSY2ZhaS9GYzdDZnlhQWVo?=
 =?gb2312?B?cThDTElCMzBxa3I2MjU2Yk9KVTErd2Z2L3dFcEFXTFJhdFp4Y1BZWHFDemtT?=
 =?gb2312?B?NnZ1YWNpdy9LeThSblRXUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8510.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?R3A4TCtSSlJyUlE3dkN0RXlGSGhWREQxR0diU1YrTGVsQ3Z2QksrMFMwSXJq?=
 =?gb2312?B?MkNyODQ0Sk5WeFZsaURHamhWdzhDRitmQjFVam9xTis1NUc5MWJLeU10aktK?=
 =?gb2312?B?Q28vb2p6RWt1ckp3dXZlT0JoUStLcTlSUk9KRURVZVo4MjIzZnJaQWhnMGs1?=
 =?gb2312?B?UnN3UTJUS3dmMlVsOUwzV200UWwvbHdjVlZOS09BT24yMFRvZUo5eldETkg0?=
 =?gb2312?B?cDJ1OVVsa21YUU9yelBsYm1XUFpxSUZGWEJ3ZWV5MTRvQnFTYVZTMFhZOUJq?=
 =?gb2312?B?U3FCUW1RYmp5L0NGQml4dktOR2RzQnFxajh0b3NvNGhXN05Udk42RWY1aHRU?=
 =?gb2312?B?ZGV2NW1EVXV3YkVxMG1Db1V0aE9OZVAwaGtzVGN5RXQ3byt2eHZZNUhZUnlT?=
 =?gb2312?B?VXAwYXdkcTZHMndqOHFwU2pXdjhsNXp2NFRMUEhjaXJraC9LL21LeFR0d3hU?=
 =?gb2312?B?b2xVbkRnTk9XWVYvLzFXZDVVUlo0UG4yZkN2QUh3OUhNVGVIM3JGV2t6NURq?=
 =?gb2312?B?VC9GU3BEeTNLMG13SDBGVDdHczlXT0g5UkNSZXRXYjlDb0FQOHJMTkpYTXVn?=
 =?gb2312?B?UGtxbXJMcU9tOGFjVm5LUCtUWFd5akhOT0tYU25uWHluNWVqOWJ6VVdrVUpK?=
 =?gb2312?B?OXM5TzdMc0UxRjZCbi9hY2R0YzY5ZlNHS0kzSmptY2JLMWFWNHFCNWVkcVlz?=
 =?gb2312?B?T1FkQXFRdnRiMWtlN2gwLzYrQUVGb1RlWjVwbGdPNFlUTW1sdlFUYnRFME1s?=
 =?gb2312?B?ZHIwTVg3TFRLUlRzWFhwOThJY0dWcDN2emFFbFlCYXB1cVF4bEZhOVhJRkdS?=
 =?gb2312?B?YllzRTNHdExtSVNGSnZJeWVYSGp3TkVjbkpQM2JLcG5SV2htek4rRmdYeEVt?=
 =?gb2312?B?T21PYXYrWEpIdjBVNHR2OG9Jd3JuK2lHVUE2b1F3NnVMTlBoQVdHQ1hialVu?=
 =?gb2312?B?SnI1WENncXlldEhCUUdhMjNzM0FLSld0MlMyWFphMTN4cFNGb0d2OHh0NUho?=
 =?gb2312?B?Y0ZLakdUZ2hXd29BNjdqQkoyRldJSU9EYkxaYmxMV3I2bU1aUnBnWjZCSnc5?=
 =?gb2312?B?eEdsSDFPamJOOHl5czJ1dUlRRkd1QjgvYUh5Zk50ZEJLSUNNYnJsdklKRG9v?=
 =?gb2312?B?K2pzMHQ3L2RXSW9wcUZKZ1BTVFJZZks3c3lHVnZIdGxGQVpHNzd4WFNBQzVK?=
 =?gb2312?B?bk5rK0h0SGNSVjhaQVRJbmNmam82MXUzU2Y1Q0kydWlqdi9vV1dQeXlQeGIw?=
 =?gb2312?B?N0s2QVRUakdOMjh2WDdDWlpjTnhwdkxUTWN4NmpQdTEzMUF5ME14TnZ5UWxU?=
 =?gb2312?B?UVBVNjRFazBmaFpWSzVWSDNtbEs0aXhCK2FHRFcxS1loVUEwSXU4T2pjZWw1?=
 =?gb2312?B?bnZscUYvTnJ5VU1Xd0xsK0V0Q2pkbW4yQ0cweEpYUFpwS2NGZ29PY3ZOdGxz?=
 =?gb2312?B?N3NWcnZIK3RQRkFoSlFPUG40dCtpYWhYVFluUjBldlloV29XeStIOEpjR0h1?=
 =?gb2312?B?MlpqcUVLZWdWMm4wc1N6V2N6TGhQNFh1WXFmdURDQUlqQUFWV2s4RzIwaUFV?=
 =?gb2312?B?V3RxU2tzWmFFREk4NVNUSEluOXZZWkttMjdjdTNjNlkwUzY0WDJRaEpSbzhV?=
 =?gb2312?B?VWt3dmtOcThRMVNKZjRxbHo1WlY4K1NzUFgxZTFXQ0NtL2MxRWpXOGx3NllG?=
 =?gb2312?B?NkxaM0tpS3JTRGUyeHNnQThpbG8zN0JWSEsrQmFYMlo2ZjBSejBLZW1UaVIy?=
 =?gb2312?B?d0FkYzNsOWRUWTNFWWNWeThnc1BzcXQ5ZzJ5NnlWTnB3dXI0bXM5azlBaEM1?=
 =?gb2312?B?Zm9Wa1c4dWh2RGpYWDArMjFZbWpqK3ZTeEp3MGNKMjQwdmRMWEplWGxnaVp5?=
 =?gb2312?B?SXNlWTBCK3lBKzFaVWorRmlvOThqM1M1bWdQaVpOcm5pYlgzV25uZDM5K2lS?=
 =?gb2312?B?UXhnSGRDY25QQUxCQW9OTGFPdFpoT2F4Q2NtM2lIQzRYZ0QzODlsWk5vU3JY?=
 =?gb2312?B?ZXJTRnovRkxuUFFqQjlXUFlSSm1QUHN6ZVV3NU1VZmNXNlZaS2o0ZlBiTS9J?=
 =?gb2312?B?UW9nRHlTazJmVittS1ZjMlgyQ2tEdE9rL216aERteXNBTjdjaUlyTWc1aGpq?=
 =?gb2312?Q?O3J0=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8510.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845ef520-fa71-4e0c-ec40-08dce99726e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2024 01:50:58.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ac1KCuwj0hbpY8DCZx63kXdC4aRcqZ/lTgYUdIse/cQPcf6W85EPxAW/Glkfls/Jk4tSxhKfKC7YvkVFX3SyQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9285

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtyb2FoLUhhcnRtYW4g
PGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiAyMDI0xOoxMNTCMTDI1SAxNzo1
OA0KPiBUbzogQ3OormuoonMgQmVuY2UgPGNzb2thcy5iZW5jZUBwcm9sYW4uaHU+DQo+IENjOiBz
dGFibGVAdmdlci5rZXJuZWwub3JnOyBwYXRjaGVzQGxpc3RzLmxpbnV4LmRldjsgUGFvbG8gQWJl
bmkNCj4gPHBhYmVuaUByZWRoYXQuY29tPjsgU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3Jn
PjsgV2VpIEZhbmcNCj4gPHdlaS5mYW5nQG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
Ni42IDAyOC8zODZdIG5ldDogZmVjOiBSZXN0YXJ0IFBQUyBhZnRlciBsaW5rIHN0YXRlIGNoYW5n
ZQ0KPiANCj4gT24gVHVlLCBPY3QgMDgsIDIwMjQgYXQgMDM6MzA6NTFQTSArMDIwMCwgQ3Oormuo
onMgQmVuY2Ugd3JvdGU6DQo+ID4gSGkhDQo+ID4NCj4gPiBPbiAyMDI0LiAxMC4gMDguIDE0OjA0
LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4gPiA2LjYtc3RhYmxlIHJldmlldyBwYXRj
aC4gIElmIGFueW9uZSBoYXMgYW55IG9iamVjdGlvbnMsIHBsZWFzZSBsZXQgbWUga25vdy4NCj4g
PiA+DQo+ID4gPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+DQo+ID4gPiBGcm9tOiBDc6iua6ii
cywgQmVuY2UgPGNzb2thcy5iZW5jZUBwcm9sYW4uaHU+DQo+ID4gPg0KPiA+ID4gWyBVcHN0cmVh
bSBjb21taXQgYTE0NzdkYzg3ZGM0OTk2ZGNmNjVhNDg5M2Q0ZTJjM2E2YjU5MzAwMiBdDQo+ID4g
Pg0KPiA+ID4gT24gbGluayBzdGF0ZSBjaGFuZ2UsIHRoZSBjb250cm9sbGVyIGdldHMgcmVzZXQs
IGNhdXNpbmcgUFBTIHRvIGRyb3ANCj4gPiA+IG91dC4gUmUtZW5hYmxlIFBQUyBpZiBpdCB3YXMg
ZW5hYmxlZCBiZWZvcmUgdGhlIGNvbnRyb2xsZXIgcmVzZXQuDQo+ID4gPg0KPiA+ID4gRml4ZXM6
IDY2MDViNzMwYzA2MSAoIkZFQzogQWRkIHRpbWUgc3RhbXBpbmcgY29kZSBhbmQgYSBQVFAgaGFy
ZHdhcmUNCj4gPiA+IGNsb2NrIikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IENzqK5rqKJzLCBCZW5j
ZSA8Y3Nva2FzLmJlbmNlQHByb2xhbi5odT4NCj4gPiA+IExpbms6DQo+ID4gPiBodHRwczovL2V1
cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZw
YQ0KPiA+ID4NCj4gdGNoLm1zZ2lkLmxpbmslMkYyMDI0MDkyNDA5MzcwNS4yODk3MzI5LTEtY3Nv
a2FzLmJlbmNlJTQwcHJvbGFuLmh1JmQNCj4gPiA+DQo+IGF0YT0wNSU3QzAyJTdDd2VpLmZhbmcl
NDBueHAuY29tJTdDODBhY2JjOWJiMDE1NDRmM2U4NDgwOGRjZTkxMg0KPiAwMWUwJQ0KPiA+ID4N
Cj4gN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM4NjQxNTEw
NzcxNTc3MA0KPiA0NiU3Q1VuDQo+ID4gPg0KPiBrbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9p
TUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsNCj4gMWgNCj4gPiA+DQo+IGFX
d2lMQ0pYVkNJNk1uMCUzRCU3QzAlN0MlN0MlN0Mmc2RhdGE9c1F5Z1RUREV2Q21NQkZjZ29sWHAx
Mw0KPiA4dzRYa0czSg0KPiA+ID4gZTBkNXJQTG5Ecmh3TSUzRCZyZXNlcnZlZD0wDQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+ID4NCj4gPiBUaGVy
ZSBpcyBhIHBhdGNoIHdhaXRpbmcgdG8gYmUgbWVyZ2VkIHRoYXQgRml4ZXM6IHRoaXMgY29tbWl0
Lg0KPiA+DQo+ID4gTGluazoNCj4gPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9u
Lm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZsb3JlDQo+ID4gLmtlcm5lbC5vcmclMkZu
ZXRkZXYlMkYyMDI0MTAwODA2MTE1My4xOTc3OTMwLTEtd2VpLmZhbmclNDBueHAuY28NCj4gbSUy
RiYNCj4gPg0KPiBkYXRhPTA1JTdDMDIlN0N3ZWkuZmFuZyU0MG54cC5jb20lN0M4MGFjYmM5YmIw
MTU0NGYzZTg0ODA4ZGNlOTENCj4gMjAxZTAlNw0KPiA+DQo+IEM2ODZlYTFkM2JjMmI0YzZmYTky
Y2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM4NjQxNTEwNzcxNjAwNDANCj4gMyU3Q1Vua25vDQo+
ID4NCj4gd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16
SWlMQ0pCVGlJNklrMWhhDQo+IFd3aUwNCj4gPg0KPiBDSlhWQ0k2TW4wJTNEJTdDMCU3QyU3QyU3
QyZzZGF0YT03SVhyaWFVOEklMkJPJTJGMnJ4WnVlcUp0ZiUyQg0KPiBWeUY0WlFJUg0KPiA+IFBO
WnZuS01wdWN0ayUzRCZyZXNlcnZlZD0wDQo+IA0KPiBHcmVhdCwgd2UgY2FuIHBpY2sgaXQgdXAg
b25jZSBpdCBoaXRzIExpbnVzJ3MgdHJlZSwgcGxlYXNlIGxldCB1cyBrbm93IHdoZW4gdGhhdA0K
PiBoYXBwZW5zLg0KPiANCg0KSGkgR3JlZywNCg0KVGhlIHBhdGNoIGhhcyBiZWVuIGFwcGxpZWQg
dG8gTGludXMncyB0cmVlLCB0aGFua3MuDQo=
