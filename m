Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795054774;
	b=x0DEexXl6Jfm9u0HNMqnpJCxnyngs/OgTNQyua6dwjwzE5RhkT58a/GHgu+Cmcd9iSI7
	 qMI1grCsko60bc1G4OdR/azguV+VxcxxubXy3+JIgRjeQzVuSe/TvN4hLfMEOG531MdVS
	 5JNaGImrOlFOsax4C3Sf3M80GcJuHA09+PJ2v1pk4izJZW2m3aSOpNqT6w4ZpNKh5/iVG
	 yZO0WYJUFYAX5LpAl30G/SnfM8f2shzReobeADTIJeC9+yun00hydKYo/qTasYpraEF5f
	 IwFfmfQ/acR8osKle7YuFocNhYe+87DMOsbdAyGus4Ix/eq9jr4vlJOFgGgyWy5gzLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054774;
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
	bh=v1D9ZaKvUqz0wjKds6l63dad7mRW41YNPloQZrVKPVA=;
	b=wD+XlS6O16SDLS9mUZskbd0AesU85Tmo8piU14JTr6Cva9fgw12Y1QTpPz/qKeEU9RLX
	 vAEWrX55+gNvR0Us8CwXZsOK7zjCN61WDyNx7yzvLdNdogPmryICu+AAH4Mn/BN3lp6m5
	 7YF2WwgFHgnwOUaOo9p+H44oymf/3+4DrNuRyhdifISP8UX561yVRnTy2oFN1sE+mete/
	 eS78EDCOmed4ED4HRTn2eeS86JxfBa5VP1/nX9j93jayPyuxfcv8yR79p5COyJfQI9a6/
	 Xx+xbUmvBRBS8izIxznFIooq2T2BqBrQrq2r4pZ38H/9so7YbseC7nsGNlOIGmkGHBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=2AyXNPu+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.22
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD71D606A332;
	Thu, 19 Nov 2026 02:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD71D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=2AyXNPu+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5OoDSL/bK7t4dfM7uiCTD0ipV3uD0xwda8SouleA2UckLEvu8KLnCMQnrvjZTieAGSeng19+94LoGG9uOKvXsWlZipfQrbZ6v63kXIWNqAeviyPRp/pBScyHNCftjGN88P86ts/HcMNcvx8/EhHwmEiIMgLBUzgv8DW9tiaijrQpopak4eJT5QIdYiPSTJDL4pPKluiRT4umBgr9fSGSbMwsFL1vIw+WE1kQEezgJsj1Q3DWjtopmcOR1WTEyHWynb53uOWhhncbIRB/ATL+885fS5MWTjwFgipdmjYszPQmVrYtFM825Vj/plhRABKZjyoN59BPVjxPTyzV0/gKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1D9ZaKvUqz0wjKds6l63dad7mRW41YNPloQZrVKPVA=;
 b=tIMKoAJMPuLFShsG4RmO7/q4iXYH8X45d59KCpwazRBcGhUYVN23O/U5XWB4kvGzPR1ttwN6vN131sd0D6wneTL56rZ/jOMZAajEqaiV0JPn2vyRfQwI2xb7EjV1rSn+miY1EUAcS8Gia03p8ZbehUTAhMjWwN7lYLJNL/Q2vRDd/y2nAGvjKKMni+GjHvcKSCbeIURUHyk9MRnz5i6RexTVEHvYJb/ZF7evEHa1EnrEOwQSLjek8+kaxlZUp47sVjGMscLGLHg+HZrZp9PrHpmBhOPiUkxjvmivzExQ+Kt1B1pBT4IvVJw0roDpmCyymR1QI39WuwnJ8WOoaMA5ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1D9ZaKvUqz0wjKds6l63dad7mRW41YNPloQZrVKPVA=;
 b=2AyXNPu+pnISaEkKP9dcEFMKFYD/8uoS4aqw5js7w7ntqZAYalpEQyrKZ6/yqDXGmi4toi+L0B972ZLGXJC7N3MRDTFCIJnaB3jLcPb5CgQCqSnpe9GqIXh+m71p9+p/GBE4DDDbYwGrsPGg1gD2t+/KC816c0U0I9WAXx+UMZA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA0PR12MB7092.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 02:19:30 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0615.013; Thu, 19 Nov 2026
 02:19:30 +0000
Message-ID: <f68e71a1-4c22-433f-91c7-064f419ca7b7@amd.com>
Date: Thu, 19 Nov 2026 13:19:22 +1100
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
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
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
 <20261118134155.GP2245175@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261118134155.GP2245175@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0133.ausprd01.prod.outlook.com
 (2603:10c6:10:1b9::13) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 2c89049c-a752-405f-e3e7-08df45e38ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|11063799006|56012099006|4143699003|261026121527099003|10067099003|261028144727099003|261026140227099003|261022105027099003|261021123027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	rKXRjeDJNm73eqlxsjnMikMBX38qyj7fJ+uJwALzpX9X3RhvbVqcBYdg1wau6EnS7e7HVTqVy5+bNqIUfC5DZ0PvrtzO9gJfsAuMwjRexGgh26hstxvnE8cf385H/el8Uv3gAUXcdgkuKNikpcjCcVQPXk3sMSjx9K7/itYe29o1EssBT1OYd38sEH++fP1SxmTvKXAiaLzxVTFiBgu0gEgUcayw+JcLUeoXUNGWCJhqJxkJmvpoTA9aXAEyZRKJqdTclm/gRVfSXkYhRqmbGQXW+DruGyRnHwqpOIc7/bK7beNfQNxGKsDOKbrFTzo0zX1da4ET1gWQ5CMKbJ6QlCZ5XWi6FbA6KxylriQO41RI0Sy0yxd7jCxXkQShzpdT7wmTogkTkfE4dZssPv1KYbZALUDR2QMjeiHcHhJibDKRTou8+MqbmITUALpqmLZbtMFd+pAJFIPs//2e9dXpFzhpMMk8YriVGVrB1ms0RZefl1HxdNewW3Tx6afqBA/qXTDX8dG8dno3G7hvav8eU0KyspyHUg7/E9IgxLq2/1OBz4V538oTs60EpG1Tv6CyycUxE6N+x99670MuO3FgOWXN0kRUHlY8e6V5b8F780WfA3YJeien2YztsdhW5m1oZ4hcVwR0ESkTAdmf/HeKkR30fPpudDEGI/bipm4nxyI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(261026121527099003)(10067099003)(261028144727099003)(261026140227099003)(261022105027099003)(261021123027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDkzNnBiZG4zVjMrSUhHS2YyV1JkdkQ0cm13a2V4c0grR2U1T0NISjBhR2sz?=
 =?utf-8?B?QVorR2Z5bHZJazhPUStQTnN6TmhUTnhrWTMyRVRwUHE2NG5UUlIxSHkrUWNT?=
 =?utf-8?B?MWQxMSttaXpJRzNvbVR3VnRzcFhwUEliQW5vNlR0eE1ET040SEd6Y3pKWTR0?=
 =?utf-8?B?amRzMHIxWXkrNHFURGJzUVF6SUF3MUNRYXZYUWVlYlBzZStSNml0K2FLQUNN?=
 =?utf-8?B?NnVwanRja3VvZ3VPM3F2Z0ZnVGd5Q0FIZkYyaEMyelVGS3ZUcE1weTFwVU9T?=
 =?utf-8?B?WnVISFVmL1NRNVkrYzJGa0RJWVVSaWtwZXMvN3daczkzT2IzYndZQXJqd0Zm?=
 =?utf-8?B?Z2t6bHJ4UFowZERHMU5EWmROWjc2a3YxUmZRSVg5dUFvTUNHRVZEVUgzN1lT?=
 =?utf-8?B?M25Mdzh6b04zNnBGMTFqMVJzc2NON3RxQ1VEQjVidm9SbStvUVIyRTZhUndn?=
 =?utf-8?B?RFBxVTNqczFEa2dnczFuNkdkeHBhdU1PSldaTUVDSm1weS9wM1JCZWVTTUQz?=
 =?utf-8?B?S2FsQ0J4VjFhcWpCaW55Q3hGN05RWGJoVmxCQkpPMVl5dW16cDhBZStUOTdH?=
 =?utf-8?B?OHNETUJBQmRMcXRHd1h0dEJ2YzR6MGNORjcyS3pYNEhXenBzelFHTm1DVmdy?=
 =?utf-8?B?N05DZnpFUDlxYmRLVkViSTBMZ2djT0hKOUw4MkgxYlVGWFhHQkRYeWJrTHVB?=
 =?utf-8?B?SGpROEhieTlFaERMTCtGc0ltYzRZWHVsejRrTWZ2ZERHT2NWc3hlNlVrZDFN?=
 =?utf-8?B?UTRPWmM5dnVET2c2MXc2bnV1dkl2MmFqd0Y2eXphdXVFUnNPVGZpaWpCNVJx?=
 =?utf-8?B?WEVIcU1rRHBxK0lDZ3JYOXlXRzJJeFB0R0NWMk9FRDlWZHpGUlVIZjBPaW9p?=
 =?utf-8?B?VEs2QkJRVDl3Mm9PODlVOWl6ZStaS25yU2xUUjRoTk5NLy9zRWRubUF5dmw3?=
 =?utf-8?B?Q2RSTWJod1A3elBtR051VE1Hd1VUbFRiK2VHdktFenVKQXJlSnRJckx4K2x4?=
 =?utf-8?B?bjNNejJlb24xUzltK0YzdkNPamhpbnZaUHJNMFM5MUU4QTlYaVJ3d21UR0p4?=
 =?utf-8?B?L0NDdjBlaFo1cXo0MDZyOWJiZzB4MGZQRGFYRXdsOWt3cGs5b3YvRytqTjJj?=
 =?utf-8?B?aXJZVTFuVVNCbEpoQzdySEdnekVNN0VtQ2JVTGc4aDNGb3laenExU1FjcGpH?=
 =?utf-8?B?aDlpcDNPa2dQeksxcWc3S3M4azUwK3FjL0RaQ1RNTWlsMEljOXJiMUVYVlNR?=
 =?utf-8?B?bzdaV3BJK3NINjk0RWFCcnJqZ1dvYWszNkMvWFF2aGM4TkNJY1djQlhoTXdC?=
 =?utf-8?B?Ynp0NGdNcnFDSCtTcFVnc3J6cmpaYVBCUlIvQ2w2aXBUWTRRNmJrQmVXcVh1?=
 =?utf-8?B?RHYxVlNiWVc2WWZzZGVJNi9zbVdNaU5KK2VUSkdjUTdGcElyLzNsMWhuU0xC?=
 =?utf-8?B?QUVSclN6djhhdS9wMmpzVFJQaXlRakZCNGt3aDZVQy8yM21jbnV2Vjd5NHBr?=
 =?utf-8?B?Q1VjNVFoMVcwZmZxemE1SkhrenFEWFBnNFg4TmEzRTZ2Zi9XZ1ptaDJUNk1s?=
 =?utf-8?B?SjlGUGordlc5OGhIS2ZZYmRTb1NaNnVkd09DdnpUdlhSMWM0OVBuek1MMlE1?=
 =?utf-8?B?Y3Bma2ZCWFJVRWlmOFh5a212N1MyVDBPVUU3cWRCQUFiMy92U21ETGp1VUhO?=
 =?utf-8?B?c3RRM3A5amJJckM2cWJCc2xiejBRRUZwbGpQQXVHTnJrajRydTgrdVVWQzRX?=
 =?utf-8?B?aTFjOUNtTmpzbGdYVUg1M2NTTkdLWDNJMkhXVGFMS3pHZW5rMzdnNHY3WDh5?=
 =?utf-8?B?amc2dGt2ZWR1TjVNaTh2ZEppV2YrNFF4QWpTYnBNU1ZCQkZWN2hmbnJudG1Q?=
 =?utf-8?B?aCt5VnB6KzJiWmxKNEpiMFRBYmlBN05iYkxFa2JGMEl0cVRzSEhJamV6UjVH?=
 =?utf-8?B?a05Sc1hwUFdSa1BXOGFia3MyUnRXeFZQWEttUmJBSE9pME1kWmZWZVk1TEhv?=
 =?utf-8?B?ZFRhRzF0YXBTMVM3Zy83KzVsWnY5ZmFORXdsR2pYRjlteXJaajFmNUd4Z0E1?=
 =?utf-8?B?Z3ZMeE5yWEVVZW12emxqL2crT2tpNzZydE1ocXhWa1VNSFV1WUhxbG9QN2JV?=
 =?utf-8?B?R1p6b0lOMEtvbGdCSXBaeG8xbjJSS3pwT0Y0REdnY3k2L2N3R0xnenVrUEF3?=
 =?utf-8?B?S1czdzl5Mk8zeDl3WHVoSmFpSDRHTUZjL1ZGWFhEckxXSzhsQ0NhYXM5RW12?=
 =?utf-8?B?RkluYTNZNmc1RWxVOUF3TlljcklPbE05ajQvbEFpRzN2bXY4a3hVRm5tMFZ3?=
 =?utf-8?Q?7b3sj13pLX/opTfm5/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c89049c-a752-405f-e3e7-08df45e38ad2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 02:19:30.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/RrV412tSHeelMDJq8GvStGFcqmHOm0dERD/7UhKRuTvS+JYu08w02qTpBAbRv0qSLu6Zx0VdBPU3M9FWIYHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7092

On 19/11/26 00:41, Jason Gunthorpe wrote:
> On Wed, Nov 18, 2026 at 10:12:39PM +1100, Alexey Kardashevskiy wrote:
>>>>> Devices MUST have protections against these kinds of attacks built
>>>>> into their LOCKED/RUN state transitions and verification, somehow. No
>>>>> spec says how to do this.>
>>
>> Exactly that. No spec.
> 
> I gave the options I see for a device implementer to follow. People
> will do all of them, I think.>
>>> Too late, DMA has already been activated, that breaks our model to try
>>> to activate DMA somehow after the driver starts.
>>
>> If DMA is activated as SWIOTLB (so the device is still "adversary")
>> - then we could (I am not really suggesting this, just clarifying).
> 
> SWIOTLB doesn't give very much security. It is pretty easy to attack
> drivers through their control surface,

True.

> and worse as soon as you DMA
> enable a hostile device with ATS you loose all security.

? I'll set vTOM=0 to make all guest RAM shared and observe IOMMU RMP faults if the device attempts accessing outside of shared SWIOTLB.

> So we cannot have a model where we accept a dirty device and then try
> to undirty it. The device has to be known clean before we enable DMA.

SWIOTLB does not accept the device, it operates as untrusted legacy device (which has parts of config space locked), we allow that now...


(btw here I am trying to educate myself about the attacks which you see and I do not, not suggesting undirtying or such)

> 
> Jason

-- 
Alexey

