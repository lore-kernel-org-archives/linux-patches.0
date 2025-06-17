Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2076.outbound.protection.outlook.com [40.107.102.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48621B9FC
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179194; cv=fail; b=sb6buMTkUn+0tRnIltFq0GlKZIfzbbpZx+I3Vd7K0Y7m3T4oayWd4EBHOGbZE8DM1SjSCDKDp2/fsXvA2SAWIe+MEH0a4ljzJbyVRIZVMw62e5XJNnUKN4pV+zrruxwtQnjU5kv9S5AWgF5ZpbuqlfPYAK44NANcPOVQzO2Y1I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179194; c=relaxed/simple;
	bh=cyAthi1+J7HrINxv1RKK6WTaCnJRflhkrpOcyyF3N+4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NP45DVGaggjoskBgjJK8Mn1C+gM+S8T8v4TsOvkwxnOJ0PUGNa1MyBhYMQvwUHECvSKAwqPx+5II3WQUF63Jnb6Lv1xQ2grzffsFlRnjsRWdomysavCW80hmdpmWr7mJhNkhX8yjeuidg5i1VL3MXvs0GBDMSIrj6dhzZRaiZ28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uzzkG7/x; arc=fail smtp.client-ip=40.107.102.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uzzkG7/x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pXs8uAlQ5zim+xrSR0wZZ5+559ficD1yPC/PGfbWS4sz5hoTZAa2ZC5iAN0SKir3cP5NtxFlV0RwtFqWQg5XiXX2O7cAzjWtjWzh8OjCEuXY5f/9aavOdGjOMSrzrPWoyS0oOkuL0ajEQ6AYkU0rG86bcAWsCpW2792/9yNC9CSUGGR83HHY3UB0S4lEPlP4sf1OTXH9L7TcGiBCdoVcmfYMql4aKxV4epyfi/ixHLwWTaUxUzyh0MPipS3t4xQi8WBqf0z01MmHdh/LZJ+fujVl1HUoDIuvRtS9DniuBOb46jJYBVBgT1UvkTNPU3tdDa2pp4E+Zb15xg2ygsWCJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyAthi1+J7HrINxv1RKK6WTaCnJRflhkrpOcyyF3N+4=;
 b=gUcZIE5+F0COiOpJufvNaoe7He6DqWvpnzwMQ4XXhY9zFxrYkF5ArTxj4TrqTf8M8WbmsP73nh91lfFLfEKiCjL8J9dMwvDC7T5g6tbOq2vHTSxjKh1KPfwyeuJboxys+ORI64vrBxGwnYXu8UAbL/KJ4KLm7yS9Oqnc1Uu5PP8JNyNH4h1ba4f3sXG14Qg3HR/FwVIlf8Ya+Qw5Svy4nWkBrsQtBu+Zr7ejuUCobqN0MHsh4XveouwgHOhPcYaL3GgcP1XQbWc6kDX0/uFO9/NkRzgBe8vmoNwaz0XpYjJEGr4CfcH4je07gon/aGyM3zIWyAtVZEud7JHdtSsxPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyAthi1+J7HrINxv1RKK6WTaCnJRflhkrpOcyyF3N+4=;
 b=uzzkG7/xckTCef/75LSFy7Y9LCFgRi3RtPxO5grMfBEw4Vu+CbVVSsf0/0IK768KEDewbiLOOeU0G673igwnOK1q8V6gyJ1OwLibKL7At3DE00h5KmNMfznoNSvsZhZ7U4rH5zjaJsXwV0mKmdhZpbE4izMtv+9jlx+x/Ow4PdE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 17 Jun
 2025 16:53:08 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.8835.026; Tue, 17 Jun 2025
 16:53:08 +0000
From: "Limonciello, Mario" <Mario.Limonciello@amd.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Bjorn Helgaas
	<bhelgaas@google.com>, Denis Benato <benato.denis96@gmail.com>, Yijun Shen
	<Yijun_Shen@Dell.com>, "Perry, David" <David.Perry@amd.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 501/780] PCI: Explicitly put devices into D0 when
 initializing
Thread-Topic: [PATCH 6.15 501/780] PCI: Explicitly put devices into D0 when
 initializing
Thread-Index: AQHb36b7eAwlIwcxV0eB/0Xpb3fT4bQHkUwA
Date: Tue, 17 Jun 2025 16:53:08 +0000
Message-ID: <c9927a2d-c9d7-46aa-adb6-edc2377bab51@amd.com>
References: <20250617152451.485330293@linuxfoundation.org>
 <20250617152511.901698429@linuxfoundation.org>
In-Reply-To: <20250617152511.901698429@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|BL4PR12MB9723:EE_
x-ms-office365-filtering-correlation-id: 55dd6529-f047-4954-5fa4-08ddadbf6ffd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dVA1dWJ6MTFkUmFxRW1rZ3pyTnpRZ0xneTJYaVVSOW5LNm1uU3Q1KzAzTkd4?=
 =?utf-8?B?UTIvRGllanlyQkg1bXV4eTA0YXJCbDFxRjFua2huTDUxdjZZSGorWklLNlhs?=
 =?utf-8?B?dkpNeVl3NHdLNzBMUFc1SW1jdnFqTGVOeEZUZHlDald2bXZBT3QzUllLK3h6?=
 =?utf-8?B?OGtCZWQ1NnFVU3RrR1Z1aWpVTWtGcUVQUnlOa3ZTeVBtdUw4cE9qL240Mjc5?=
 =?utf-8?B?M0tjMFlFNndhaUR4dGg0ZE5ZV2plVXpIMjFMU3BEN1FVM0hnbnhIVFFqSWlL?=
 =?utf-8?B?czV5YklPMmhhK0U1ZlVWNW9aWU1nNmJkNzFRZnBDOHpmQ0NiYUJLN1dPc0k0?=
 =?utf-8?B?QkR0T3NlckpyVG1STzJGdVYrSHZERGNIQW91QnNpbW1aR3FWYmZnSGRxcmht?=
 =?utf-8?B?cWpqWUtuOHdYdUZjd2VDaTlZdUY1dWxoMUFXZkUvZm9Xd1R6NURFTXU1dDVC?=
 =?utf-8?B?TFh1YXdWWDZZeWE3SXUrZlZsNE16ckgwVDU0NGpoKzRLclZJdlZ5Z2pYajF1?=
 =?utf-8?B?dWhBRWVKdG9pR0ZjNjJYbm1rZ2tzakpJdXRvZklGMk9zcUlLSVhQbTNETldW?=
 =?utf-8?B?ZWI3Qm1KUVl5Zi9XNUowVWhESktXNW8yN1J4OGVrREtTNldnMFp2STZHZkJD?=
 =?utf-8?B?VHMzbnZLcGJLYzY1T2V4MkdkaG0ycExWeEI1cStFM3piTGJFR0Q4WGZVaEZR?=
 =?utf-8?B?WGQwcnBZRDJJSGxFcXNtbmRPSUl6YXlKcVFYcVNLSXhlaXhSUXZkZU5ydVE3?=
 =?utf-8?B?cVdEbUQwZUI2VUtFbHByTjJObVkvRUR3RUJtYVFCYXpIUVpVOFJZeU95UVZ6?=
 =?utf-8?B?emhrWXI2T2ZmRDBITUY0MEhZR3BDTkU2MDd6eHJ1b1VkNVI2ajFHeStnTkd2?=
 =?utf-8?B?N2hqMDhZODZ5Y3lWUjFJTFNxVTVYTUZnSUVJeE5LSml5Q0Nac0RhczRuUzA1?=
 =?utf-8?B?eW9zTTlvV3hjVGx0SlNjbmxubjhzUnFVUmJnNUdkN1YyOVI5TGtzc1MxaFNT?=
 =?utf-8?B?aGVOUHJaZ3VFVWtMbkV0bjVwZ0RpWEhEN21rUm1XRmFHWHBTdno2cFFuV3pL?=
 =?utf-8?B?bkhwTkR1SnBqTDRQWWk2bEdPYVJqOGh4azFtYlhBV1hnaEhub2ozbkU2MXlv?=
 =?utf-8?B?Ym96OGMyT0F1T1hhcjFwWXhHWWQ5cWxwcHhLR3JjR2VuYUJjOFV4bUVhU3pW?=
 =?utf-8?B?UUxBTHBIc1o0OGxRa1N0MXVMd1p1cnhnNEtSRU1YME80VlJBRTVwK3A0Y1BY?=
 =?utf-8?B?STJPZE1xc0o2dWhSbmxXKzhMcHNWemN4MUdFaHFJRCtaejVEaURPeFNXaU1F?=
 =?utf-8?B?RlFSTjdVQ1IwRzZOanp0OStkU29wQVFkejVDV0RvWGdUbm5zVExJUlNyY0NJ?=
 =?utf-8?B?VUpQQVN4N2IrWEZ6VE04ZE5aVEdib3BlSmJ0Y2NWeEgwVmJmOGdCQ2xJdUNV?=
 =?utf-8?B?eVFqcDBjTHhEMkVzYkRBanU5Z24xenJzUTJHUm9pYXpyUTk1UVhyc0FYUExl?=
 =?utf-8?B?a3FVZkRZdUt5Y1ZCUk9ZOVJ3UGxOLzQ5YnJnaFBrelUxOVZ2RDBScE1HREVw?=
 =?utf-8?B?V2pvNVlCQXFpdDFjM3VoMGJYQXNPRXdvOHNJU2M4ekd3WmkwTjRMdkJsdkNK?=
 =?utf-8?B?b2dLYks0V0JGdVVNbkdVOHVDMTl6dE42QVl0clQwSUZhcEM5MjVxcnFsMDhN?=
 =?utf-8?B?REhuRFVWMkNaMzRoZE5FZE9RTjF0KzNLWkxFTlRscmJ5Q29lQ2pFeVcya2Jz?=
 =?utf-8?B?Z1NqamZtL0UzMkNuNTNRWGN6YStBRzJ0WDFoT21heGNnMFRnNWxMK05IVVpN?=
 =?utf-8?B?S3ZtL1d3aTdlZmZ4ZW9lVTZneE9BZnhiTlgzZTZMOTc1VUJkT2o5NGIySzZO?=
 =?utf-8?B?ZnI5eVhQbk5ZcTZaZ2lsVXpsQmpYN3NmREYwRlp3T1hRVW0xMFNGVVc0UmF1?=
 =?utf-8?Q?sjHSlD/hNq5iTL2tJq70Wkmym9lmM7OR?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Tk9LS1RDWGJMd3p5VnY5eWtJUElVWGQ0V3hBUmgrOHc4Yy8vTnEweXVMU0NS?=
 =?utf-8?B?ZUxWaGFwTXFwU3RhWnQ2M3Q4RlhZczNOYVAwOGVMb0R0akxRVnNBZUlwN0lI?=
 =?utf-8?B?aHB5WW9EN2F4U2JHZEIyN0lSYm5JcHNTcjJ0NnpmcUJ1aGJ1cTJlRDRkSGdw?=
 =?utf-8?B?Y3VuTjFpUGFFUVg4eXpjaUlQakpDK00yaGlMeTU4RzVSc0h0Q3V2d3lZTUlH?=
 =?utf-8?B?dEtMUWt2Y3grSW81eWkrVVdYYml2NElYQVR0VnhZbXZiQm9PM3QyRlk4dFNv?=
 =?utf-8?B?eG0rNElzV3h3a3FIV3ZCR1E0bFdaZlU4M0lHY0RXd2hCSGd5RVgyUTRWck5w?=
 =?utf-8?B?N24vOUI1MHM0S0h2TXBtS1ROQTl5YXFzeXJPVzZCSS9KSW96MllBSWk3ZCtW?=
 =?utf-8?B?RFBKRTloVzl6K0k3dzVMTjlUMTdvK2x2djBTeXV1L2E3Z2l3RU1XeTVwbEtz?=
 =?utf-8?B?OVM2ODdSb0tUTmxVSXZ5dWNvTG9oeDF4UEFSWVI5VHRYbVlsdGltR3QyMC9P?=
 =?utf-8?B?R2xiWjl1RDhQTElVTllUUkFmMzBFbjNsR3F3dnArK3RQUkZ6emJjQk0xSmh5?=
 =?utf-8?B?Wm5IQWRxWGorMXFYZ3BHVEI0K2U0UlN2MEtCMHhQY3g3ejZXUTE3OEt4cE9x?=
 =?utf-8?B?Q1hEQUdWeE8yVVAweDBSUUU0U2c1R3hpdmdGc29YelMzTGRaREVDTUFINTZm?=
 =?utf-8?B?cXRYR0gwRmwzVXdGVkVacDQrRXFRYkVBaFZGL00yMldUdW9HZVBLK3ZydDdN?=
 =?utf-8?B?Wkk4S2V5alZ1UXR0UWlpR05kOUt5UEdVcjRBdHA1TmJhWmkyYU52ZmFOY081?=
 =?utf-8?B?MEdiUUVvUkd6dE40QlBhUnRKeEhkUUlWdjRlVGtWQStBcWFSVE52S3R0cFEv?=
 =?utf-8?B?WWViSEpNa0RKOXVWeEJuUTBmMkpmcEMxWGx6ZWM3ZVV1QjN0SnhsTHRRU3lQ?=
 =?utf-8?B?d1RKTHFDVjQ0aitlSFNWTmRVd1dmZWgrNUdhM3hKRGpxUHdGT0lVK1BlTzNy?=
 =?utf-8?B?b3VocFFob1RRZTF2VW1STDZqUnR3bVZ1cWQwK2dSdVZ1c2wwYmZUM2pHVHNP?=
 =?utf-8?B?dnE3WWprYVdaengzTk1SYUE5NWUzT1EzQ2JUbHRZTk0zV0ZnemZQYlBveERH?=
 =?utf-8?B?UVJjVWtuSTlpdDgyc2hnWWppdVdSY2EyTkpGS0NDQW5INlVndUFXOEs0TGNM?=
 =?utf-8?B?THVBOTlDZ1FTRHFCQk5SdzlHUmIxQjI0T1JPa29JcTZKNGlDR3RFRkZRWFpG?=
 =?utf-8?B?d0dHbjFVUmJ3Q2k0aFdCTVNsRDFjNTkzQ0tYdDc3TmVDdWdoNGhRRlVXRy90?=
 =?utf-8?B?U2JyVU1iNzV6S3hHdUc0WDdvME1ieEpKdGlTSzQ5RXdoUm5xVDdTMGlZWWJJ?=
 =?utf-8?B?SjNkVE5KQjNXRFplVWF6dDZickNYS0VzNlBZL3dDdEpGNy9Ta2hkUXN4RkFL?=
 =?utf-8?B?V2pOak05Um5LaEVKV0FMaU40Z3JzNHIzTFh3Z1dMaDZSRlBjUGw3QUFNUkQ2?=
 =?utf-8?B?NDZJdHVoeDBGVjIxQitzRTEraHMvcEdCVnBGWVlWcmxMVkw2UjEydFFCSzh2?=
 =?utf-8?B?bEdHaTAvMXd4dWdNR0ltcXpiTGVSZ0d0RFJMRnlsNCsxQkJ3MnNIVHhvQ0I3?=
 =?utf-8?B?WVM0aWpRWmdnU2pQZlUxL3F5SHN0eDQ3RWhtN0x3T2lxV01VYzZFQS9adkRi?=
 =?utf-8?B?TnFXeHJQUXdObEhtK2ZqcE1BSlV6dDFXTlhpbXR2R29rbEVhNnhoYWtHT2Vk?=
 =?utf-8?B?dEZDY2tPSjlERkplK2RBODd0ZnEwMUt3QWJZbTAzZEtSL0ZvZmQ0eVlqVWVB?=
 =?utf-8?B?dUUzUnlQKzNDZzNoS2pJNFoxZlE4Y3pvZEowa3dpTjJNTjJPeTh5RkpWVnA0?=
 =?utf-8?B?SDVOUDdjZXBNN1loR3hBQ2VjNkwvQTBIQWtuS1BUN01BYi9pNVFNcDhWYTc4?=
 =?utf-8?B?YlRpdmJIQjZ3NXpVbmtheVJNejZXNC9nVGtBU2hvNnc1QTNJM3gwRFBoMWxO?=
 =?utf-8?B?OWQySUNZTlhXcng3eXEvbUlicWFOQjdmbnorZWxYaFMyb1lmVU1RZnV0OCt2?=
 =?utf-8?B?bWNkZW1zRzVCcmlaRWMxSWFzRUxLYkNNMml1cXd4WTBKSmxWU1luVDI2Wklz?=
 =?utf-8?Q?+brQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FAE8556188263478251312744BD5B7E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55dd6529-f047-4954-5fa4-08ddadbf6ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2025 16:53:08.5662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAKZjqYpRDNWjI5RS0EnINzkmcYTVdLHjq5k8wzCSGF90O+PBNYS87LnjqBiflRL4B9FMwM/cBMNPWiXYL2DEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723

T24gNi8xNy8yNSAxMDoyMyBBTSwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA2LjE1LXN0
YWJsZSByZXZpZXcgcGF0Y2guICBJZiBhbnlvbmUgaGFzIGFueSBvYmplY3Rpb25zLCBwbGVhc2Ug
bGV0IG1lIGtub3cuDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IEZyb206IE1hcmlv
IExpbW9uY2llbGxvIDxtYXJpby5saW1vbmNpZWxsb0BhbWQuY29tPg0KPiANCj4gWyBVcHN0cmVh
bSBjb21taXQgNGQ0YzEwZjc2M2Q3ODA4ZmJhZGUyOGQ4M2QyMzc0MTE2MDNiY2EwNSBdDQo+IA0K
PiBBTUQgQklPUyB0ZWFtIGhhcyByb290IGNhdXNlZCBhbiBpc3N1ZSB0aGF0IE5WTWUgc3RvcmFn
ZSBmYWlsZWQgdG8gY29tZQ0KPiBiYWNrIGZyb20gc3VzcGVuZCB0byBhIGxhY2sgb2YgYSBjYWxs
IHRvIF9SRUcgd2hlbiBOVk1lIGRldmljZSB3YXMgcHJvYmVkLg0KPiANCj4gMTEyYTdmOWM4ZWRi
ZiAoIlBDSS9BQ1BJOiBDYWxsIF9SRUcgd2hlbiB0cmFuc2l0aW9uaW5nIEQtc3RhdGVzIikgYWRk
ZWQNCj4gc3VwcG9ydCBmb3IgY2FsbGluZyBfUkVHIHdoZW4gdHJhbnNpdGlvbmluZyBELXN0YXRl
cywgYnV0IHRoaXMgb25seSB3b3Jrcw0KPiBpZiB0aGUgZGV2aWNlIGFjdHVhbGx5ICJ0cmFuc2l0
aW9ucyIgRC1zdGF0ZXMuDQo+IA0KPiA5Njc1NzdiMDYyNDE3ICgiUENJL1BNOiBLZWVwIHJ1bnRp
bWUgUE0gZW5hYmxlZCBmb3IgdW5ib3VuZCBQQ0kgZGV2aWNlcyIpDQo+IGFkZGVkIHN1cHBvcnQg
Zm9yIHJ1bnRpbWUgUE0gb24gUENJIGRldmljZXMsIGJ1dCBuZXZlciBhY3R1YWxseQ0KPiAnZXhw
bGljaXRseScgc2V0cyB0aGUgZGV2aWNlIHRvIEQwLg0KPiANCj4gVG8gbWFrZSBzdXJlIHRoYXQg
ZGV2aWNlcyBhcmUgaW4gRDAgYW5kIHRoYXQgcGxhdGZvcm0gbWV0aG9kcyBzdWNoIGFzDQo+IF9S
RUcgYXJlIGNhbGxlZCwgZXhwbGljaXRseSBzZXQgYWxsIGRldmljZXMgaW50byBEMCBkdXJpbmcg
aW5pdGlhbGl6YXRpb24uDQo+IA0KPiBGaXhlczogOTY3NTc3YjA2MjQxNyAoIlBDSS9QTTogS2Vl
cCBydW50aW1lIFBNIGVuYWJsZWQgZm9yIHVuYm91bmQgUENJIGRldmljZXMiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBNYXJpbyBMaW1vbmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogQmpvcm4gSGVsZ2FhcyA8YmhlbGdhYXNAZ29vZ2xlLmNvbT4NCj4gVGVz
dGVkLWJ5OiBEZW5pcyBCZW5hdG8gPGJlbmF0by5kZW5pczk2QGdtYWlsLmNvbT4NCj4gVGVzdGVk
LUJ5OiBZaWp1biBTaGVuIDxZaWp1bl9TaGVuQERlbGwuY29tPg0KPiBUZXN0ZWQtQnk6IERhdmlk
IFBlcnJ5IDxkYXZpZC5wZXJyeUBhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTogUmFmYWVsIEouIFd5
c29ja2kgPHJhZmFlbEBrZXJuZWwub3JnPg0KPiBMaW5rOiBodHRwczovL3BhdGNoLm1zZ2lkLmxp
bmsvMjAyNTA0MjQwNDMyMzIuMTg0ODEwNy0xLXN1cGVybTFAa2VybmVsLm9yZw0KPiBTaWduZWQt
b2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQoNClNhbWUgY29tbWVudCBh
cyBvbiA2LjY6DQoNCkkgZG8gdGhpbmsgdGhpcyBzaG91bGQgY29tZSBiYWNrIHRvIHN0YWJsZSwg
YnV0IEkgdGhpbmsgd2UgbmVlZCB0byB3YWl0DQphIHN0YWJsZSBjeWNsZSB0byBwaWNrIGl0IHVw
IHNvIHRoYXQgaXQgY2FuIGNvbWUgd2l0aCB0aGlzIGZpeCB0b28uDQoNCmh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xpbnV4LXBjaS8yMDI1MDYxMTIzMzExNy42MTgxMC0xLXN1cGVybTFAa2VybmVs
Lm9yZy8NCg0KPiAtLS0NCj4gICBkcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMgfCAgNiAtLS0tLS0N
Cj4gICBkcml2ZXJzL3BjaS9wY2kuYyAgICAgICAgfCAxMyArKysrKysrKysrLS0tDQo+ICAgZHJp
dmVycy9wY2kvcGNpLmggICAgICAgIHwgIDEgKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Bj
aS9wY2ktZHJpdmVyLmMgYi9kcml2ZXJzL3BjaS9wY2ktZHJpdmVyLmMNCj4gaW5kZXggYzhiZDcx
YTczOWY3Mi4uMDgyOTE4Y2UwM2Q4YSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLWRy
aXZlci5jDQo+ICsrKyBiL2RyaXZlcnMvcGNpL3BjaS1kcml2ZXIuYw0KPiBAQCAtNTU1LDEyICs1
NTUsNiBAQCBzdGF0aWMgdm9pZCBwY2lfcG1fZGVmYXVsdF9yZXN1bWUoc3RydWN0IHBjaV9kZXYg
KnBjaV9kZXYpDQo+ICAgCXBjaV9lbmFibGVfd2FrZShwY2lfZGV2LCBQQ0lfRDAsIGZhbHNlKTsN
Cj4gICB9DQo+ICAgDQo+IC1zdGF0aWMgdm9pZCBwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9z
dGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldikNCj4gLXsNCj4gLQlwY2lfcG93ZXJfdXAocGNp
X2Rldik7DQo+IC0JcGNpX3VwZGF0ZV9jdXJyZW50X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+
IC19DQo+IC0NCj4gICBzdGF0aWMgdm9pZCBwY2lfcG1fZGVmYXVsdF9yZXN1bWVfZWFybHkoc3Ry
dWN0IHBjaV9kZXYgKnBjaV9kZXYpDQo+ICAgew0KPiAgIAlwY2lfcG1fcG93ZXJfdXBfYW5kX3Zl
cmlmeV9zdGF0ZShwY2lfZGV2KTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIv
ZHJpdmVycy9wY2kvcGNpLmMNCj4gaW5kZXggNGQ4NGVkNDEyNDg0NC4uZjFhOGYwNWE2MTA1NCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMNCj4gKysrIGIvZHJpdmVycy9wY2kvcGNp
LmMNCj4gQEAgLTMxOTIsNiArMzE5MiwxMiBAQCB2b2lkIHBjaV9kM2NvbGRfZGlzYWJsZShzdHJ1
Y3QgcGNpX2RldiAqZGV2KQ0KPiAgIH0NCj4gICBFWFBPUlRfU1lNQk9MX0dQTChwY2lfZDNjb2xk
X2Rpc2FibGUpOw0KPiAgIA0KPiArdm9pZCBwY2lfcG1fcG93ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0
ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldikNCj4gK3sNCj4gKwlwY2lfcG93ZXJfdXAocGNpX2Rl
dik7DQo+ICsJcGNpX3VwZGF0ZV9jdXJyZW50X3N0YXRlKHBjaV9kZXYsIFBDSV9EMCk7DQo+ICt9
DQo+ICsNCj4gICAvKioNCj4gICAgKiBwY2lfcG1faW5pdCAtIEluaXRpYWxpemUgUE0gZnVuY3Rp
b25zIG9mIGdpdmVuIFBDSSBkZXZpY2UNCj4gICAgKiBAZGV2OiBQQ0kgZGV2aWNlIHRvIGhhbmRs
ZS4NCj4gQEAgLTMyMDIsOSArMzIwOCw2IEBAIHZvaWQgcGNpX3BtX2luaXQoc3RydWN0IHBjaV9k
ZXYgKmRldikNCj4gICAJdTE2IHN0YXR1czsNCj4gICAJdTE2IHBtYzsNCj4gICANCj4gLQlwbV9y
dW50aW1lX2ZvcmJpZCgmZGV2LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfc2V0X2FjdGl2ZSgmZGV2
LT5kZXYpOw0KPiAtCXBtX3J1bnRpbWVfZW5hYmxlKCZkZXYtPmRldik7DQo+ICAgCWRldmljZV9l
bmFibGVfYXN5bmNfc3VzcGVuZCgmZGV2LT5kZXYpOw0KPiAgIAlkZXYtPndha2V1cF9wcmVwYXJl
ZCA9IGZhbHNlOw0KPiAgIA0KPiBAQCAtMzI2Niw2ICszMjY5LDEwIEBAIHZvaWQgcGNpX3BtX2lu
aXQoc3RydWN0IHBjaV9kZXYgKmRldikNCj4gICAJcGNpX3JlYWRfY29uZmlnX3dvcmQoZGV2LCBQ
Q0lfU1RBVFVTLCAmc3RhdHVzKTsNCj4gICAJaWYgKHN0YXR1cyAmIFBDSV9TVEFUVVNfSU1NX1JF
QURZKQ0KPiAgIAkJZGV2LT5pbW1fcmVhZHkgPSAxOw0KPiArCXBjaV9wbV9wb3dlcl91cF9hbmRf
dmVyaWZ5X3N0YXRlKGRldik7DQo+ICsJcG1fcnVudGltZV9mb3JiaWQoJmRldi0+ZGV2KTsNCj4g
KwlwbV9ydW50aW1lX3NldF9hY3RpdmUoJmRldi0+ZGV2KTsNCj4gKwlwbV9ydW50aW1lX2VuYWJs
ZSgmZGV2LT5kZXYpOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgdW5zaWduZWQgbG9uZyBwY2lf
ZWFfZmxhZ3Moc3RydWN0IHBjaV9kZXYgKmRldiwgdTggcHJvcCkNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcGNpL3BjaS5oIGIvZHJpdmVycy9wY2kvcGNpLmgNCj4gaW5kZXggN2RiNzk4YmRjYWFh
ZS4uN2UyMDZjMTczNTk5ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9wY2kvcGNpLmgNCj4gKysr
IGIvZHJpdmVycy9wY2kvcGNpLmgNCj4gQEAgLTE0OCw2ICsxNDgsNyBAQCB2b2lkIHBjaV9kZXZf
YWRqdXN0X3BtZShzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCj4gICB2b2lkIHBjaV9kZXZfY29tcGxl
dGVfcmVzdW1lKHN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2KTsNCj4gICB2b2lkIHBjaV9jb25maWdf
cG1fcnVudGltZV9nZXQoc3RydWN0IHBjaV9kZXYgKmRldik7DQo+ICAgdm9pZCBwY2lfY29uZmln
X3BtX3J1bnRpbWVfcHV0KHN0cnVjdCBwY2lfZGV2ICpkZXYpOw0KPiArdm9pZCBwY2lfcG1fcG93
ZXJfdXBfYW5kX3ZlcmlmeV9zdGF0ZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2Rldik7DQo+ICAgdm9p
ZCBwY2lfcG1faW5pdChzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCj4gICB2b2lkIHBjaV9lYV9pbml0
KHN0cnVjdCBwY2lfZGV2ICpkZXYpOw0KPiAgIHZvaWQgcGNpX21zaV9pbml0KHN0cnVjdCBwY2lf
ZGV2ICpkZXYpOw0KDQo=
