Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795009330;
	b=yzqROur5RxYK5aXaQGUWsKX8qhXrBcSCRmy16mi38T2ibFWTr5vfaC38owLyn18g7/X+
	 v7zSYpy2IbTfxp+Ifs/K8Xe/TgzkRNIaMlmLkMt1YArXa8gtLakOgLvMpQRwzfRk/JGc2
	 RK/qF2xaU8+KR+wkaQAh3wUFM+NRr3Wx9Kh9s1jRv6Xk+G0QHc/bfO+IMERfjg1JbSWgZ
	 TwhV4zD1VAoQ38YzsGNqwN9QiVmkC1J6jomOwr+RTcwk+QvZOXOLN9E9JHORkb4Sa2FlE
	 hWZq7K5ykfTwZme5OORI09+SyV1UUZPSBw4v9X5Mqif8ndtVevqMg+MWhqUNPy7jdAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009330;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=+9ZsC8DMn7axzu3dUOzLF6D4OLTWfDHNH2J7ssjOx90=;
	b=lytPP0d82fwrxGSZqZmSPzmP8biTpGSv2GdtBpCkO7nFZogfqn13cmWCsFP++JZLyDVR
	 n9h6hgqL2NjiQkbquAjp44i+X+peCEcVLMBprgt7IcOASSyaNat+jQjPHauH24E1Mj1Ui
	 5bE+OGEd2NrKSLVA/EViZrBmoQGBD4V1qxw64TJ63w9KGzOzgqg/tKGZK1mf8lkdSLmVs
	 hwo8WL8sFluxCQltfyw1rnlrjMQ0LD6Erv/JWbrX4ZGix7osRpal8gUFoOjloGiO1qLx9
	 zhmMTgXYMqPAKapU0FHjx24T4Jc+CupajAIStNwumtx9w1wQPHRfvUpkS0JgZ2Bk36w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pBJeOJsS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.6
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010006.outbound.protection.outlook.com [52.101.61.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA962606A31C;
	Wed, 18 Nov 2026 13:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA962606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pBJeOJsS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ubelQrgS0g9EbSW5KBHIAgTVK4b6DbvR5pIGo/f/hCG9ZFLWefXdMlxNcWsy5CDwh/D7s1AewADYsCg7J1yW0UVl5Ry1fMbANdKUvoJn+zOezhFVqrF3P28+DDgw2J2Q9qEXD77IjEyP3N9MDCJPOBbFhwfjvf52oIQrGKUKvC9JDS+AqmdI25Eo1xnyUBojfklhdOh88i3DxhPQkhSYYc/Mr3YQSLVMJsNWVmk/7V78HLq9MQXPlsaeO8wa+rDv5f8gVOGp9krhCJ6rVX3+f0H2o2HvqDObNzMgQVDZ0EEoYGp29BkrbkPcC5IpOp/LcCZkLeNkglzxL7SOdBKuTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9ZsC8DMn7axzu3dUOzLF6D4OLTWfDHNH2J7ssjOx90=;
 b=JcscMvNpacN1N79AyCgRqhdJ6V8wO2cW+TRXQC9K0EZSglKIAKU83qfN8G+AUW/SlJitUqbmhcFRUsOEgj4C4RpOFnaLS0QBzyAqz/4T0VX3UNwaZUQoCNbMoYqTr1awiV11xTufCJzDc14eHdiorRbxQ6IYdrmiMYjvu24m+U5mWOLlJvwGKxvEzwwRpmwS0EvW88r0BGGacqYGythTUBU01DqYIlGK6gXXBF15jg2QSOI5fJLq0IQ7YxyXHqzvjBJo0B8RFRKORsJditsTlHUBhYFn39MGKka+vstIMrr34FyJ0y/dI/OVxUiStXeB66yWbuAVXMKnbaTkbutZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9ZsC8DMn7axzu3dUOzLF6D4OLTWfDHNH2J7ssjOx90=;
 b=pBJeOJsSFly2z3EilSGQNOUKlBTnB0KZ1w3wEWAQD1cnuiGAEDOokZqKPcb6uhxehUjePzvNjtsJ/jllVFpjwRtH2Px6gZv51YYUZTwaa/pmEirHV7VRW8at6Qg8DzRdZk4H8M3qDnhjruH0pYxsxga2EuzfNLk2IPj7zpRoylkP5q92lGWJIwS3BqeEQHtCVIW8hs/VkhrMrl/WxVSfAdxEtOS1E5tcza4DCjJQb01ADAMgnPmbw5haLw5KNOoujZ0eft+7VI+tPi9W+tj37Ihl50zDwO+l61YmM3dHYYgM9Rahg/ExYEDN5/sb3iR6j3o11bVwJGfGb25+rcCOgA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS3PR12MB999217.namprd12.prod.outlook.com
 (2603:10b6:8:390::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 13:41:57 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:41:57 +0000
Date: Wed, 18 Nov 2026 09:41:55 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261118134155.GP2245175@nvidia.com>
References: <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261111141315.GI738765@nvidia.com>
 <73d5e5b5-2626-4107-8f0d-2203c53ddd43@amd.com>
 <20261112123127.GK738765@nvidia.com>
 <b0efaf47-5a94-4922-98b7-2000ae9a405f@amd.com>
 <20261117011837.GG2245175@nvidia.com>
 <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac37ee5-03e0-4a30-b22c-0f7f20e58cae@amd.com>
X-ClientProxiedBy: BN0PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:408:e7::23) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS3PR12MB999217:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff1c473-f8c4-4ee0-916d-08df4579b70d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|261021123027099003|4143699003|11063799006|56012099006|261026140227099003|261028144727099003|10067099003|261022105027099003|261026121527099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TN81+rq+WyS+56gzKGqaD1E1Yhd2rzMCD+GDo8Srx/2HMfXAoGTpeJFiZIefkCsFrh0YKUwwVMgiE8jp1jDuOcWkD+fEAhua8x75WznxTKUk5r3uiVok1wpTB+RWGUxwdoPbnT05Vl36LQdjm9ZspKEzMNTAvIu0b7MWLQZTVXCHrZLcu8//iDsm7ovNWLq8wyNo6eRFDo1/tUBTeMQWE37R0NPBpv0cu6OdCpPTrWY2X6SiZA8/eqwAb7nUqmqa12w180hF5Mqf80yRNAh9QsNm9YIHCK7pEif9yVrQGkMgAlNLKVm7C+3odzauY5AZ7jaf9pEazFPD4wTSozLVVgWcj/KSBz7f2e7uAgLFaMvGTJvEDkufdPOxC3omUPKI69qAgfyOB7nvXhxxTv1d83ynX8jCMiY/+fnXXOn3adv8saV0Zmua+B8JGZeH9C6HEdvFggN89I67m/I+ZXqDncey/QV1I4yuLIw2sEl2m2Xtop1Wjo/CCtVMk8UflaPiG72011HsTfrbg5DwrHHcB88qxGSkpNdGtJsSwbMpHK3hhwK5r6+LojxPr31VihX2M+6RMSXNI0LFiD9e8hPwFnRNxZJ1ake2b+9DrA0LIh93y9/6Qna1r/34qt/QN0Xl/317DzzkkxQRICiiroACkA8EihKgVCXhYn9SE/cJNig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(261021123027099003)(4143699003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(10067099003)(261022105027099003)(261026121527099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LxemeX2Nt2871sFwyXW1Rzs3u6q7t61YWcO449R7PEvMUYO4LEBr8F0pttk+?=
 =?us-ascii?Q?Bnb8UeK4agAiMkL3JcqLZOp528JTQoxbYzNXjEz7WEfmjWH0Imq8Z4kraCCp?=
 =?us-ascii?Q?yl1T0YlK4JCP0zVcGntvzQazNgDw7wE5+GBvFmAAl58amsvZs2tHstvJU/jC?=
 =?us-ascii?Q?DTS30W4GfabW1NZ0Vph+jDiIm+f33m4fmW+QZZa5q8pKP5NwVFOwYNtb+ZD8?=
 =?us-ascii?Q?u9sFKAiYIPBpophZXoC223FXfBfUATVLHfmRnsCiYepLQu42Z6+MdxNumLrf?=
 =?us-ascii?Q?O5XmYNqk4WmKzcswQ5buUyNNhoRVdNbp5V5GdhaEu/MFC5o391Prwkm2VbIM?=
 =?us-ascii?Q?ntFyZSwQt16RZ1pUQ1C0LOvzFlvwSZFjZbFlym0QDx23YSE9RvnVnsrbTBEG?=
 =?us-ascii?Q?T3D6Zs+qGJehQo/wZRKZT2uM2vho7nRGdTCKFkQDvn5ujO+bQ0FUt2uRjKAH?=
 =?us-ascii?Q?tfMUIYSzBi57Cgc70+LgMU0aXF4wxNd60A/27jGS0Y8gkStn92nPwdrsg7Ay?=
 =?us-ascii?Q?DDEiLrH8jzqD0YY8guxnVxXtgrGrR2A6q3NoCtz1c56YdpI7fyxof92iIVZF?=
 =?us-ascii?Q?kCULJWlFR282SPEqJHni+aL7aRfbvph7p23tNXnukEzFxc/ahHODTud4+mmW?=
 =?us-ascii?Q?5q/YDsPmK6/WvXprf7A2mniZFvZ1rnJrETY5ZpjGXlAi8DG2gF9vf4Ap1ZqQ?=
 =?us-ascii?Q?tB+x2mhVZddkX49WBODPoRCxfb8Pe6KH1r9YvVHRD/D2j/aF2Isvf2MxfUx9?=
 =?us-ascii?Q?8swDFnSi0bkA6fXiK0R5kZyghBPUBkXweCXYD5YaRdzVetr9y/ZwUP6WFhay?=
 =?us-ascii?Q?e0E5TLfqk7roky6g8nrqM7HlnXPeBphkubLVlhOjdQ9z+O6V4LRHv6Wqw5gc?=
 =?us-ascii?Q?vNEzpm0u1A0Ce7zWVqjB7Riu8meu5WkcSCItcwphKZNRG6KEXZIB09E+/DNY?=
 =?us-ascii?Q?vOgheo8cE3E7RkmQ8uuk7XEZ5RRJhDExoHF8JvLrkfeSN+BrgEn1Gjc2fQlX?=
 =?us-ascii?Q?bh39oBsKk/M1CSeE6r8EYbz0ybtkBtiqwJnBOHlBpzrqYIMLj9UWH6bQCOsC?=
 =?us-ascii?Q?fg8nDFYOJ2sxwbqY7Dl3TG5UTZwioJmCpB30Lb4iDTKkyP4s3Tgy4Lwoh3lM?=
 =?us-ascii?Q?8F0esrdc5VxB/ubfKMjjMlo8Dzz3+UE8BseVVrtX/LK2c9vJXKbp79e5yYw+?=
 =?us-ascii?Q?BJC+n9BY9S6PHlYemU7H+Kp5CJnDNUr4iTvzGYnfaK29gZD9g6A9QgdG0qWb?=
 =?us-ascii?Q?1swKM7GBzznMpVPbMg5SZF8YpBjruqXQNT0H3epO2Sro8xS147VSbPxX7Hf6?=
 =?us-ascii?Q?M1jnVe7JCUVjSzNGBnL/f5mvM5jGdN7h+h62ODx6EVkfsc4hLkyTAXa1v/D+?=
 =?us-ascii?Q?tjIyHg/P1oMyyEPCJoSIwoor83xGyA0m1p41s3d5s+5pvFDAf39nx3Wwa5tA?=
 =?us-ascii?Q?wiwRkj3tUz7D4KtkgHPKeg3uW64deCo/JReF8iVOyvEcSkJhAU9ohpgXNKFm?=
 =?us-ascii?Q?oZ2mPDCvQUOp48pvU1deiJX1lLvxls+XcCX/TYjdSxkbHkyh5TF/yBBNhOK2?=
 =?us-ascii?Q?iv/6UseooeejM8GaF3fdB6ZFiDA/jUDH7OHWiC4sGMgxMDjWtL1WWOBvRBDz?=
 =?us-ascii?Q?nc8W0zUzeCVhSW5bHGQIxfu5EDpDUT1BUcEVQbpInyR9QJ6sHHJ38rEP94sD?=
 =?us-ascii?Q?cgrLs9ey0lh7RuunVFhf+J1Wl7k78nzm3cRVJzsIdQZrwuhy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff1c473-f8c4-4ee0-916d-08df4579b70d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:41:57.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHG7Y0MnzllGUkATkv+dSA+nibbgBL79g+cpRZ2peBuo4oMz8Klm2tj5yYvlOMWU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999217

On Wed, Nov 18, 2026 at 10:12:39PM +1100, Alexey Kardashevskiy wrote:
> > > > Devices MUST have protections against these kinds of attacks built
> > > > into their LOCKED/RUN state transitions and verification, somehow. No
> > > > spec says how to do this.>
> 
> Exactly that. No spec.

I gave the options I see for a device implementer to follow. People
will do all of them, I think.

> > Too late, DMA has already been activated, that breaks our model to try
> > to activate DMA somehow after the driver starts.
> 
> If DMA is activated as SWIOTLB (so the device is still "adversary")
> - then we could (I am not really suggesting this, just clarifying).

SWIOTLB doesn't give very much security. It is pretty easy to attack
drivers through their control surface, and worse as soon as you DMA
enable a hostile device with ATS you loose all security.

So we cannot have a model where we accept a dirty device and then try
to undirty it. The device has to be known clean before we enable DMA.

Jason
