Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795054759;
	b=HEcCN5HOJURMwlmzE5L8BAxNq8K7DQE3cSSlFDjSR21hhtx8Qs9hpIVuWGK+O7xu9A+i
	 WLX35Yeiprr18Zb7ImRJormF0lOi03mAwMsNmWWSHg+Nr8Sa0Zg5Sy1hL/FM1jHY4KETQ
	 ADWz7j2Qv0v38AweWlEVGoBhZbeGL5/MNPKV0LJ1b8dKC1lkGaDkP09DSPJUNE6ed7MXW
	 wHUbYrjTudiLRe11GkH4Nlp7VC3V5lT+SKEVjHZEHFnRQewkYs+N6h5ZcrkYGRtoXe7Zc
	 TJfIwt359cGnStQrOL+gpyejbfW3W/rbNIui0Ee26VoUgkvjsQJIAYKOutwBsp1s+2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054759;
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
	bh=kxaYmdmiAP9X2CZlOBDqoQAZ+9iNWYP8OzrlNFpmZBg=;
	b=amnGg6r0NNjhkN0jSMXcf2JPlzASLIIw1lz9pio3w0qkkJAAt5H6IXKSM3CZeNY7hiJl
	 +7gJhqlhzBzx/O6WHJNdn97KxsiasYMiZK7FjskgniQob8+rfI9z5kyhQKf6n/w2oYkf4
	 /ptAezLL9er1IQP9ePBdudPg75mkA7Iavz6bGcHQLu0UmRQBNkR2RkjyaVl1cd3ouVjST
	 QF4eZa63SUwXAAPhhHwrO7KIjjrtfEbbJoFGVZLBhQ/y007lhhrBjIRPTVz6W2J622R9x
	 0iBsiYj4Xse/n+eGT/VV1EXPuA7OqiflgtcvhbWuQsKSCJYqtoCbQteo/D/gPhPj6Ng==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JGMKqaey;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.24
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606A606A325;
	Thu, 19 Nov 2026 02:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4606A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JGMKqaey
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yz0/wTF7zb5OnZXIf/LPTlRptvDczfH5BEfYe9UVXUSC/nd0t7doLNf6sWfjQHDPlyaAgW3/TU+rEvJ4KUeuXHykzjCDlSCLjMKmF3jmRmSYk6/BXJ2aOBYdtCnux+8rSmB5bYt2cZizp39BDJZYeTW+4rk0rNJejQFumvzzV6wUl2wmA1wBUU9Yzi5v9nJ+CUStsInwxm2Lsg7XRfskV5ucUuq4o3xuEUT3aV8X2SOGN9wYQyki9fyZcBTpZOsJaGgpoiEhB1Nf7zLh02rya9G2ZVnbImJyjhB8+Q8N6YkcdedwPjPeiD00OpM6kgr3124Yo/AQta7ko/mhuBtDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxaYmdmiAP9X2CZlOBDqoQAZ+9iNWYP8OzrlNFpmZBg=;
 b=sy3Mie2WaPAi1Bv6QrjhrTVnxl30Y5urKr6dHw4sT6otmVNApEysnPWHSqzIp++c0JyM6cIW0YhvwTpAUXQviF4tK8/Yv3uyFwyTfEgANGc06jWUby0FITE2ba+qEXjDVdXOuuYLslMyR0NcLYlzCpwUCAI6E4cDQZ6181qHvMCQMAkywdDw9ut2JECn297NVK5pq6TBGmEUaTJtI9m0Ht4PxJ/8l03TdWy5nJQRnqCH2CjUlwImAB3i7/xNDk8yWRwX4Tz39wFF7ZfoY18Q2N7lP85ZFlhmKHKPF8hro/VlF2Rh0Znf1N2ppbej/K6nAMKYSaAOlNFc8+5GVW9/MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxaYmdmiAP9X2CZlOBDqoQAZ+9iNWYP8OzrlNFpmZBg=;
 b=JGMKqaey4VJWi0NV8gNniS0HB+MH+P7tfB95e6Dbvdht+MTvgG11qBQLl7rECCQeTKARGrNgY2Ar3xb7ax2+ddnATbNeYn1Xk1YmYJMtF6oeOIYdguSTNoy/tcnPkb40tqX+ZtsQZxvYEKSuPFubPqa+gR9PUjbOZlIaMoqKjpk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA0PR12MB7092.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 02:19:13 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 02:19:13 +0000
Message-ID: <d8a32937-059f-41ee-9e11-2036002149d7@amd.com>
Date: Thu, 19 Nov 2026 13:19:05 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
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
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Alistair <alistair23@gmail.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <06d99ff3-3fae-47df-a27e-f2b45d8d3852@amd.com>
 <20261118131636.GN2245175@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261118131636.GN2245175@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0129.ausprd01.prod.outlook.com
 (2603:10c6:10:1b9::20) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|SA0PR12MB7092:EE_
X-MS-Office365-Filtering-Correlation-Id: 027e875c-5807-4bb7-dcfa-08df45e380c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|11063799006|56012099006|4143699003|261026121527099003|261102123227099003|10067099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	db9ygqLgXFcFgWBnYbG9veZmaT3Ui86uWCX3fG6uGizy2Kc1ngHmw4XGSxFCLciKydcxGHe14W4DxlxmeVtwpgiKEvHHUWqlKSyDl1zVuJYLVnnlRksr/e8rlvNl01LMzVYF94W1cumlDq4glH40YLoU19XQSNwRzr35CNVIvgl1hNXcmUCy8qPHpSgaKl5+XFGlyvZJ/wq4Z1W/vjRgvkYbEGsGkPqyHsfdLliuQdXxf2x0t6uz3YgpQnYX/m0nO4FRuw7er2GlziEM15F5Uot8gsPuPR1gASX+lmyiEj3qSYq8lYVP6ghQcEpQT3S2uyytuWVxB9AO7Mv5peDOOhN4Lu9kkk8UQTyk7uChmOostygqvf710eT9wMH20/r+AgG4YlwTY1wJZvjrvRFQYUhfvUVGbIPX9BzAffhnCBMi08vndER5cTT5ywnggHWWm6JlwuC7x6dCnA46Wba8QYncDh+2Tr2LRKpBTcRnf4yAEGN4uQwUNbB7EtCSk4xqDWvTmrSIusfjj6qd5uqZaHwlg7m5uKRgjx3NXNyO0Mbx23UEaTn5lZaLEXGhaDout0V1yOtu4gWu/WEtE1lu6KLDHHkeG//p36tZK8hKimUZBx/GAwJNNXLaHnZO7eH+8J302vgMMzNfrW+OxwPq7Bx599oLoagykPNuToDowlg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(261026121527099003)(261102123227099003)(10067099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0JqZGp0UjgvSDRBYndBL2JhbkJSallHUGphNGtTYzBqMktmU0d3UmYzSVFm?=
 =?utf-8?B?ekZlMndPL2RJQnR3cmdQdklZaG92NDMvTUZESjlma0ZKL081TG9zNTF2MWk1?=
 =?utf-8?B?Q2tkUElSWk9kUy9FYUpLU2dpYU02ZG00VTAwRzN1VmdNZlN1R0NQNFFVT0RS?=
 =?utf-8?B?TTBKRCt0OFFPMW1NY1NRd3ZQMU9xREpvMTZsWGhqRjhiODFPaXhWU2RDeDdy?=
 =?utf-8?B?Y3ZELzRNdllpazZ5Q0NnT1JyN2szQWd2Qys1ZHRYUC9VV2FsM3cxUDY2V0F4?=
 =?utf-8?B?MUlqNFNHZldIOHZsMm1YZlNSVUFsT2hyU2VaUXRTMHhTdStrVGNWazZIVjRx?=
 =?utf-8?B?bU1pYzJZUEhKckU1VGFVclFxbURTY2J2dE1iYjkrdTN2VHNCMWJZQjYyam1E?=
 =?utf-8?B?eXRqd1hBeFFNdTYwdjVIaElCQmkzV1k3SHhkeFF0eUJyK1AxT0RCdUUrYjJK?=
 =?utf-8?B?OCs1WkxQZlp2cnEvZCtJK2l3U3NEL3dMWWFRRldLRk5FWFJHajJWY0tjYTRw?=
 =?utf-8?B?cnZtcitRRm93ZUF1QWt3K01nb0ZyZm95bFNteCtVaTd1WVl2Q0ZDSU8zZmk5?=
 =?utf-8?B?QkhDclluN2tYR2QyNHQ0ZGJTSEhFK2xHc2phcWlRR3c5eGRLTExYVWJoaHdv?=
 =?utf-8?B?bE4yY0Jkdk44MnRRemc0WGdvSHlQNVpmNTFEblkvVGtQRTlJb2dNbXA0OTAy?=
 =?utf-8?B?RlNoZStJWXFhZVFGcnFLYjA5M2ZnWG5CTnMxaG9wMFRId3BkT0ttWUpwQmNn?=
 =?utf-8?B?TG9Cbmc5ZGJRQmdubWZPbEpiMklockRMQTA0UjJLbFRZK1I5elJQdlArYmZY?=
 =?utf-8?B?cERoQklNL2RBNjh1NGYzN0ZJb2FRQm5YSk5jUms3bjZJTXczZDV0M1RHWlF2?=
 =?utf-8?B?M0tsN0Nlek05Y1dKWmIyaXJsSXhqaEN0ems3Y1ZZWWdPQ0o3bldodHdSZUFj?=
 =?utf-8?B?S3lrSG4vV3VkeVdpMVhoV054eG5rVlltVW52dHVkSDVDbVQ1NFNzRXNYN2Vk?=
 =?utf-8?B?dUcvRTNtejBrTXdDWVNSVis4KzdiMUo1eFd6MDhaenpUMk9VL2pHZ1BjQ3pD?=
 =?utf-8?B?RWVpY3ZrOVRNa0loc3JzYUxjOFM4bVJIYURtRy9qOGFnUVBtL0tSa1pFUGh6?=
 =?utf-8?B?VDZ2LzIvYnRyVGowVjcxRGhueXRGSVZRL2k1dXlKMFVEdnlLVElmVDdlMS9m?=
 =?utf-8?B?UXZJcXlsQ2o4VWlET3ZSbDlFd2QyMFh2M0FLN2dUZEpZcnlGZjltaXNOam5x?=
 =?utf-8?B?aEFobWQ2cmoxWjBCK2VwZzk3RzJSalliUXZEdm41a0s0SENsK3RXT2tFUERi?=
 =?utf-8?B?WkVpZ2pad2pDNWRGL0Z1clU0RHJzTXN5aDNZZTJZYVcyOVJCYitvVXNSb0tR?=
 =?utf-8?B?VjlXRHE0S3kwS1A2WHBhWTZGQXluN054QWtPdUpML0JrU1ZrWUtxN2NBc0V3?=
 =?utf-8?B?ZS9YQVJ0QndYRU1EY2dvcE1vOVVFcHB5WmxZM09tR3lTU3dkVFZMQm5HbkhM?=
 =?utf-8?B?azhlWFpCMlZsc1BDNEZMMUJ6WkJIVk0wWVhnOG9qWHJwdWZ3K0hpaENqL2hn?=
 =?utf-8?B?VDEyWE16YlFza1RiTGtqREJRMHp6ZEZtNEdCWVNtTTVFSHNQNjc5em9TNzI2?=
 =?utf-8?B?bE1PSHcyS3hEei9SZVRJZURnM0dLeDRNVElCZWpYTFN5U2NGc1BIMVczTnZZ?=
 =?utf-8?B?T2RiSFBsSENQd2l0QXFKbFN4Yno1NUdEMXRod3RuUmZJNnF3aUlYdTVOS3FU?=
 =?utf-8?B?N1FyZjc3VzFIZEN2eHRzNVluenllVzlWSFZ4VlpqaFJ1ZTY2NU5EaUFSY0hE?=
 =?utf-8?B?b0ZoMlpHTTlzVnhnZWJtZnBPMmltR3MxdG1YY2NaZ2Y2Z2tiZFlwMUt5ZDY2?=
 =?utf-8?B?aUhYUW1Ba0RkbUh6WVhoTkNZbGgwY1ZaN1JFblljcHJrREZQMlpDOUFUUGZ4?=
 =?utf-8?B?VmlqM1AwMS92UHBMeVN2L000TmdOc1JuSnBDd2RjUUhDQVZON1M4c1B3THpi?=
 =?utf-8?B?b1lqUGVxS0RyVGtyRFo3cnNxdFdnR1h3R1U0anJPMEVTVzRXSHZjQmRveVFT?=
 =?utf-8?B?bHl1YWsxVE9qbU5EOE1sdkcvM1Z1K3FNS2NUdTZmODNramM5YnNJY0JEVHFh?=
 =?utf-8?B?VEpVVG9vcFZMTkh0SUYxT3FENWJpYlZGTllZNGgwVm5tR1pCTWZTMnFHRk1O?=
 =?utf-8?B?aVlWT1ErVWRkQysrYStlTGs2ZXJFaktRUnVqSVZMeHBaUEw4N0ZnUXBuaVVs?=
 =?utf-8?B?bFFiU0NtM0E0eTF6dmV1T3h0MktYK1hRenhhc3I0LzI2TzhQSGZQMHZTSWtF?=
 =?utf-8?Q?6CUmGHvqV3KXpnOsoC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 027e875c-5807-4bb7-dcfa-08df45e380c7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 02:19:13.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +pYVjUUU68Rz1Jst3YfXU+kIL5mlIY8vCqLeA+Tg/zG9OT9xtxJxLA1SmYbEs9MlRq67qBf/PRxFR8fH0frXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7092

On 19/11/26 00:16, Jason Gunthorpe wrote:
> On Wed, Nov 18, 2026 at 10:12:17PM +1100, Alexey Kardashevskiy wrote:
>>>> Btw, does any other arch provide #3 today? I am not able to see this in ARM
>>>> spec at least.
>>>
>>> It is coming, currently ARM doesn't even allow the host to see the
>>> measurements *at all* which is a really big miss on their part.
>>>
>>> AMD is probably broken the same way as TDX is right now from what I
>>> can tell.
>>
>> The PSP always takes nonce in DEV_MEASUREMENTS and updates the
>> digest. Nonce comes from the initiator, the updated digest is
>> reported back to the guest via encrypted VM<->PSP GuestRequest
>> mechanism.
> 
> Okay, so that means it is broken too. You will have to disable host
> evidence collection once a VM starts using the device.

Why? Because of concurrent DEV_MEASUREMENTS from the host and the guest, or something else?

>>> You probably also want
>>>
>>> 4. TSM controlled nonce
>>>
>>> A way to put the vdevice into "tsm controlled nonce" where the vdevice
>>> evidence collection no longer accepts a guest nonce and the TSM
>>> provides its own random one. This would be a permanent choice when the
>>> vdevice is created.
>>
>> Is this any better that the initiator's nonce? Thanks,
> 
> There is a certain customer that wants this weird flow. Ask your
> architects they probably know.

ah right :)

> 
> Jason

-- 
Alexey

