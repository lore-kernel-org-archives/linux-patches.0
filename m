Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795000370;
	b=08/NXUDeJBwkI/bJPHVreDzT9apW7FziszrZkPzxN1YuEusj+92YLhAKCuXnE31UR3nk
	 H5NxrxYB7aRw66G1rA7Ci6CIJ6ajj5N7naGt9jYjhqijCuIiW37INIM5YsZ/CPxJxVxD3
	 uqFK5XEH/TRdixJrtu60ryoObzPml4nmKCRmSugR/NVNtt5WwmzZG4qdkL6B8oBNXIKBI
	 V7SucGeC3czUjCEC0lLJPzPKW01IuRixrTfd66SjJw55LctKIzv1fNiBlDqovYRTycKW1
	 r3UWaCPyl6QZbVZYoGXngMH8vT7GqKSjkluQxP5SooII7gvHdns2aT4bQuWTUX+C3AA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000370;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=8joCK23i3B/iAqn9cA8pdaIL+1t67BJZ2Vm6WoDzNCY=;
	b=pXE3eQ4RWkujO2Rv83m0TE0bNPoFCw7u8W6cP0gGMom8kYqLinQnjgN/1gaI1xx1iD8M
	 vFouRt+PfyxxU5BWEufBdcrUxbFFe/7bF2iTCBHAcVh1NImkf7bSQsShDO8VgRQJDI/Hm
	 e0yeMxkaIRmUPc6jwiIH62lZJWaUeu35U2ZV9d+2vKWNedkZw7mYOup9pW3aqdxoh9mHK
	 rjjyoqiYPxEtzMZKdlre5NFdm6faggUgszXjaGB7+An3IuU/moXvnwYUz7kxM/muRpAor
	 QSpjBrA3reyU0D2IERl/TuRnhQxnW/DmLU1O3uu8+yG3j2aRoXW1bBSW2KwSN7IkXow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5h5I8Sb1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.8
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7711606A325;
	Wed, 18 Nov 2026 11:12:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7711606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5h5I8Sb1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAP7KjhpF2VSgBcJCcrsYRwqgbA7H+HtNNssf9spoBk8hdkrvBjUIaKV77WXKSfmuzJ9nuuuDxyefE2sczY7fzVokrYlUtyIkSkEey+lZoksRuWbzP04mmT6RNnArsQC1IqRDHzVxf4Uz277AR3X7OrI4PJQmtavPo2di9aR4swZxzDXbhH3MjgOa1bEp7C6hKhB8QvRLxiYghZOVKnBMa6Rgv0YYZx0mVvTojMIOMrKzpXurucKKdhwWqMXKxnEccj5EXOF3iUUICzRPqJu8C9sxvdVBnU/0GaV+DmtzF5xF7XTDt4kTnxcJeHZWsxl6QOmpl2LuuYuTkLXdBQD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8joCK23i3B/iAqn9cA8pdaIL+1t67BJZ2Vm6WoDzNCY=;
 b=Q5Gye5OCpLOY+1MpcLuPFOAoLGVP4bDcvxPVm+O7Ila42XzY4ZWTn+kOuNj7t66gcALLzuONe4vOLouEq6D3ELFabKbCtxL33LKC1tXGooGzB0HruL3bmD3H1Kgi7FLlGxWaB3ANB+UsfG8V0nBDqDiJ+bVh46CsBrycFP3sA12VTBIU+g5Szi6uCHIoOx4p4+V/ohtf7ncFBuasqJ862yAgogGxX9cLqDMArmh4RSIIBHNJAqoMFFfsc63jg5zB+aN/NXE/uBoAcybZWS5IR+qlRCJLVpPaeBd7/B8BLMQiea5pAGnT8nf/QJDMTdZvBgKIjsHiYHMS0diwzK0v8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8joCK23i3B/iAqn9cA8pdaIL+1t67BJZ2Vm6WoDzNCY=;
 b=5h5I8Sb1VUoR7eKBNlxpNKb2IW5g1wcB6wi3jgnBKomZoSBAeD6QmggxEaRomFvtc6gQ0kFSc5qbrtR+jpwhimD0KINdqF/6xiT3ar+tlk8fFzQGvaaPVys851066SPYOWbe+SYEsZkJkG5pKErdXO9E+0PYjFrBlk6p2DFLlKY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by DSVPR12MB999286.namprd12.prod.outlook.com
 (2603:10b6:8:41a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:12:46 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:12:46 +0000
Message-ID: <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
Date: Wed, 18 Nov 2026 22:12:39 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
 <20261117011837.GG2245175@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261117011837.GG2245175@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:110::20) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|DSVPR12MB999286:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3ab23b-7863-4452-2f68-08df4564dff8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|18002099003|22082099003|3023799007|11063799006|56012099006|4143699003|261026121527099003|261102123227099003|10067099003|261028144727099003|261026140227099003|261022115727099003|261021121427099003|261022105027099003|261021135927099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	sDFlzMt+4Rqc5pgLthnFJvX99G4Sc1PornQHMEMj+26VHhkLL26iN2V1IYCUpDdUnFjPfHt7iAHHEUgOvEdkRI7Ys9fLctzoIQiyUmIqhEDuMjXM7bCk5VrqcQQ4wRbkhrP6IcKgiiAB3A0Rd0+FGKVdX2BQhjfAUr6TlHpUEZK4mlK09i5ocPFkZq0tpd2zWd1qKy1QzuE4/VUoJJrLq9wUPMUaHLy2NAHc1qbNTH9LCeDBMSNK0TgdPYt4cMo0ZmaXOLGiY9y9kH+Oja27lQUJZ1XqZPHjq6m3pGSqDwo1j8E0NE+0WdvOR313hfIbDEMHHN6X8LkpYELpgiS81eycfw5gk5SD8F2m18o+gMtYeoK8Kon/GCd55Q8fCH43QGzfP/SratwmOKM9lRqUwExs55YbfcN4N+3870th1m6UPeVYeI2aiIKDu7GrcmxQOXkuoHIAQ7YtJFueSyN0cJiTHltRRIh+L3mstNo443wVVXiyICoUGxmn9cnlb4xl8d9nnWzvuP5pBIHSHYhptvC06j5P5YUT2+mzzQQ/FpZwDMEhOeG+X/tdlhrAk5vTmD9wpVapohy1+QyWoI6RjFyuGAIRoiyESYwbdUIrtMPfHzfNO0/u8ctBkwN2Omk0+F5YlCurXoLGWeVq770U6Y9XWxouQfT5xU4KHrQITb4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(3023799007)(11063799006)(56012099006)(4143699003)(261026121527099003)(261102123227099003)(10067099003)(261028144727099003)(261026140227099003)(261022115727099003)(261021121427099003)(261022105027099003)(261021135927099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlM5TmZiOVRJWDhudDRodWlBbkp6dTB6Vm8xUEZGYW1KTVZyZ1JjR0dwaUFR?=
 =?utf-8?B?eTNxQS9hVFVzM1hVVTZDVkdtQTF5a1JwOEg1TXZ2M3RobEIwNlR2aXlVU1pW?=
 =?utf-8?B?b3ZzZWl2T3ErMXlmZ2UzTExqNmdveWFUczRPdmIwZUJ4WUtEQVIwcnZaU0ov?=
 =?utf-8?B?NC9VZ3lNZ2I4VWc5eXdZNVNxblBTUkI3QldZekVDRHE4YkcvZUlUQTUvRVVH?=
 =?utf-8?B?RWJYcjNDdjBVMTNnMS9TL2tMTGk4OVpnRUNVcFkyTmxZMHppRmNUTzRkcS9y?=
 =?utf-8?B?NHoxMmhJVVRlaG5DdmVFM21FQkZxalF0V1kyNmpXdDFjdGg5S1FMZzJBYjhV?=
 =?utf-8?B?TExNd25OWlY4Y1k4U1ZkV3BkbWd5ZnVjS2RuS3JBaEx3N2xwcWhoSm4raStu?=
 =?utf-8?B?aTBWRGtZSnZPRjFMaVV0ZTkyUmFKVmtPbDgxaG9NS2hIOEVneWMvR2JVbHZP?=
 =?utf-8?B?c1dLOXNxYmJ5NjZpRVFhZ2E2TnFrbUlIWXJUVm5tbG5YSVFMeTJvbTVPTHox?=
 =?utf-8?B?M2RLYzd3WEUxdU51WTdlaFJPaW15czh1aGx0eFpBdDRkREZla2U1dmlkMVNy?=
 =?utf-8?B?anYxMlozL3JrcE1PVmsybFpkTXA0Sng1UjdsMkErZnBxWXE1WWhRbjhXSTdz?=
 =?utf-8?B?TVI1RWJTSnBXS1hwMVhENlFGMXZwb3hhY1lsQUdNMnZsREs0ay9RZGdkd2Vt?=
 =?utf-8?B?MVJHQi9xSUFIMFJJK3k5S3Z3Q2piWG1jWFVOaFJCZ05aa01CNzR2R080RjJr?=
 =?utf-8?B?UE8wMzNla2FQdklQZmVPRnMvTDJudm95eXBCV3pLd0JWdzV0TWpsc2tscmMx?=
 =?utf-8?B?NCtDSlIvNkJVNkV5alNvTFNLZERrdEdKZmRUQnlKNVVhb05aYVI0RGpTekJt?=
 =?utf-8?B?eGMxTWxpV0grZk9HNzk1VXBUNHRqdVhTNVFYemJCaFdNdTU2ai94UzJFbWpN?=
 =?utf-8?B?QlVONUczU0xLNlhLZy9oT2pzUXhlMkprbEUvTGtBYkFhWlI5SDV4Z2FoVW51?=
 =?utf-8?B?QXhKNExqTmUrUnEvZnZScEtzTXBMRG8xeWNBOU9PQUxOT0FQTzZCQjJ1MmM0?=
 =?utf-8?B?RjZFaW1ZQUJmbEdJTDNBRGJMR1YzWjV5YlMwU0F5QllYMU13NHovZnBBemMv?=
 =?utf-8?B?L1E2dExNR3BtTG83dytZSWtGQ3hTS2c0MHhzQVpoSnZOQjBGUXdnRndKVnU4?=
 =?utf-8?B?K0k3U1JsRzRIZFMxcEhlem9Hemx0dzU5bUl3QjhFWFhmVXZ3QXBZVDlZekNu?=
 =?utf-8?B?SFN0ampxNXJ0RXNaaVZhejNRblJwY3hZTlNUSHcyNzVsR3pjMm1td0JYdWds?=
 =?utf-8?B?MC9hUEFTKzZvR2d4NGF6TzBJTWVqMlpYbGJYN2VvS1FwcU1SZ1hCSTB3TXpJ?=
 =?utf-8?B?OHhMb0xhYmlHTzhDZUkrbkpCQm9KZFU4M01LaktQVkpuNVhGVFFmcDFEbjAy?=
 =?utf-8?B?Sm5BTGpDNkxoRG5UVENGRGJPZkdVVGtReVVaYzJmWlZyRGpNdFNmWE5pY2ZI?=
 =?utf-8?B?MStLQk9JSjdEejA2bkF2VXNxbFdFVDZLMllndWI2ZGFxTzdYZDFQUU1Scm1s?=
 =?utf-8?B?TDJjRHgyWWg4U1E4VmFLbnluVzBLUTRUc2JPWUxiMUtFdm9TT1VVTmxXT2Vz?=
 =?utf-8?B?MSttWm03NXY3bGh6VWowNjZFc2NYZkYvRzcvR2IyWGFON1Yxa2hRZ29rUGZE?=
 =?utf-8?B?b2MvWU1WUHZ6WWh3R1BldmpsZzVwR0twQ0VmSkY5SG5sQWl2YUFCdUt6MUVY?=
 =?utf-8?B?ZzRJT3FTRC9zR3VpWnBwNW4vNExVQmg4OGFHd2JtNTFCS0F6Rk5zcllMU25X?=
 =?utf-8?B?VEdXQ2thaGdpS1VVSzllaENTMHVnNWs3aDhaekhPU2JsN2h4M3JaT2daQkRk?=
 =?utf-8?B?NzZwWkN3enhFcmNENEdjUHNGalhzRWkyS29IV016NW9OM2VVVzVHaTBzcEg3?=
 =?utf-8?B?cWVhRTVWbS9jKzVreHFGblJRdlVjWU43c3ptL3I5UzhDVFlJTkx6akZDRDZO?=
 =?utf-8?B?b25GY1hiUWZaOWJGQ2RoY0MzYkZ2ZnFIdWljM0t3cm0wOTduWVRwK052UmY3?=
 =?utf-8?B?U0lueTUrWjA0V042eXdzTW10ajFtRnlGWURLbHhLUHpCM04rWVlvUUd3bmVx?=
 =?utf-8?B?bUtubEZ1VmwwNTNFeDVnNy8zejlKeXN6cTM1c2pIV2t1VmdESTcwZVdoNUNT?=
 =?utf-8?B?YjhaczZqRHM3M1N5VGExMVowOTBUUGMyTE1NRGpkclY3WmRyQTZJVUxSNFgz?=
 =?utf-8?B?cytVZGZ0YW9XTWNvMk16UGhyblFHbzdXYjA5VUtUM0Q2SndNeEs1c2hmSEpP?=
 =?utf-8?Q?Cud5Nlo6N/QCrmrbhB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3ab23b-7863-4452-2f68-08df4564dff8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:12:46.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cq/wSPnf0DBszU2Ks0kCBvCSboIBU0YqNDvSjNojblS28cFDqWNpI54gIxW65tkG5n5StRh/N/VHIVTGSrvmjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999286

On 17/11/26 12:18, Jason Gunthorpe wrote:
> On Tue, Nov 17, 2026 at 11:48:26AM +1100, Alexey Kardashevskiy wrote:
>>> Again, my reference threat is the hypervisor programs the device to do
>>> DMA after 1 second and then tricks the guest into doing DMA
>>> ENABLE. This must be prevented by the guest and device co-operating.>
>>> For a concrete example, imagine a RDMA NIC. The hypervisor boots it up
>>> and establishes a remote QP with RDMA access to all memory. Passes it
>>> to the guest and the guest does DMA ENABLE. Hypervisor suspends the
>>> guest immediately after and rewrites all its memory via the network.
>>
>> Then the HV is in the guest's TCB, no?
> 
> No, it has access to an unlocked PCI device. That should never make
> the HV part of the guest TCB. Creating that barrier is entire point of
> TDISP.
> 
>> I do not know anything about RDMA NICs but there must be some access
>> control. How is this different than giving the host an SSH key to
>> the guest's root account, for example?
> 
> It is completely different. The entire point of TDISP is to take a PCI
> device in the system and then allow the guest to accept it into its
> TCB.
> 
> My point is: when the guest accepts the device it cannot be "Dirty"
> with state and commands loaded into it by the untrusted hypervisor!
I do get that :) I am trying to figure out how the guest can guarantee (== the device can prove) that the device is clean.

>>> Devices MUST have protections against these kinds of attacks built
>>> into their LOCKED/RUN state transitions and verification, somehow. No
>>> spec says how to do this.>

Exactly that. No spec.

>>> Pretty much any device that does DMA can be tricked into doing
>>> something like this :(
>>
>> So we basically want guarantees that bus master is off when
>> transitioning to RUN, is that right?
> 
> No. We need guarentees that the device is *clean* before we do DMA
> ENABLE.
> 
> Clean means something like "just reset"
> 
> IIRC we can't change bus master while in RUN anyhow, that is not how
> any of this is expected to work.

We cannot clear the BM (triggers ERROR) but 0->1 is allowed. Although the VM can only ask to enable it without knowing for sure what it was...

> We expect the device to respond to RUN and LOCK and do one of the
> options I gave.
> 
>> A TDI measurements could include the VF config space but we do not
>> have TDI measurements... Huh.
>>
>> Sorry but it sounds like the device driver is the one which has deep
>> enough knowledge of the device and, upon transitioning to RUN, can
>> tell the device to stop/reset (via encrypted MMIO) while keeping DMA
>> blocked.
> 
> Too late, DMA has already been activated, that breaks our model to try
> to activate DMA somehow after the driver starts.

If DMA is activated as SWIOTLB (so the device is still "adversary") - then we could (I am not really suggesting this, just clarifying).

> Plus many devices
> cannot reset themselves just from mmio..
Well it does not need to reset, it needs to know it was quiesced...

> The device knows what it is doing, the device has to respond to TDISP
> in an appropriate way to give this guarantee, or it is security broken.
>>>>> We run the attestation without a bound driver now so the device is
>>>> quiet but so far PCIe TDISP did not require this.
>>>
>>> There are many things the specs don't *require* but have to be done in
>>> a certain way to get security. Enabling dma and binding a driver
>>> before taking a measurement is obviously security wrong.
>>
>> Well, I meant that the driver can start with encrypted MMIO (or not
>> encrypted) and untrusted DMA (SWIOTLB or vIOMMU with only shared
>> mappings) and then, after the attestation, switch to trusted DMA
>> (and remap everything).
> 
> That's not our goal in Linux. We want unmodified drivers to work with
> TDISP devices in RUN.

True.

>> Say, it is a the only NIC in the guest and the VM wants to run it as
>> trusted but the attestation server is outside. Reloading the driver
>> is just easier.
> 
> A flow where the VM self-attests is really weird, and I don't think it
> can really be made secure in cases when the NIC is involved. We want
> to log the attestation (Eg to a PCR) and then the online verification
> can check if the lohged measurement is acceptable or not. Since the
> log is tamper proof we have a record of exactly what was accepted
> before it could have compromised the VM.

Nah, I meant to use SWIOTLB which does not compromise the VM. Thanks,


>> Right now my guests request measurements with a guest userspace
>> provided nonce and the PSP talks to the device to get them.
> 
> This is basically right.
> 
> Jason

-- 
Alexey

