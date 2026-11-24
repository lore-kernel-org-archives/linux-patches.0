Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795478930;
	b=F1+4t4qX2BaZhTtmVXo6aV2f5fsKJ9R9i3mupf7G4OK3Eb8MaVeZQ6KYypPPOo81LVAM
	 1EeyCiimOoWlaVJaTWmHhF7+ecW0DsjsVxD/YemGLMPQPcPrYzq+rEQi0LcapMvxObrwK
	 gd0rFa7Dj0A80kN0tEwBnuo4b6iXMO7oAuwlR7SG6Dx6XScpAiROddB1Zt3Lch2OxLyhL
	 aTKAw5W/a6jwmc3xkfydGU15g4Jsn0dAZ9pPaLqSc04yXepoZGJYEQgav28TAISw6UNdp
	 sIsnKBMJm5ERKg+kIvRGxDV5KWsNhoL0ZlqDr2fCTCFuvqKUoO7UVn4vwCt5DiMzQRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478930;
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
	bh=y7mLVJRpgfKLAIWDIozJRJJei+4fgDXWqvaeefH4hNc=;
	b=gE8oPYgmfM6BbLgodNQHDDnJzJY1tMAFNtxMsNC0GMDwdO6Pls+StEovnoBqa1hHteg6
	 A4UNd7jiDXiABNnC4GNUOgFJYi1pmxt1V5zkeIsfSLYy3ycEgCWjVfCRHs4lJPWFzfKzi
	 9IgwnS1rsaTslfElGf7XwPe+pp0CpdCGraBXVuVmusLulGTvD6/b0Qa/whaYqG4H811UV
	 RpjB6Gc//1oYj7aQTYZpBff3kMWbC6lqXtHY6E6o71bx80dyna0U958SZX4QJR+LM7nRq
	 L2gWPAF3OK32YIJ1jBNZLyiGqwcUXPnyBLLqVIRBPNmKy77Adv5qROTkadWER22h+6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=UWonZWSN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C7606A327;
	Tue, 24 Nov 2026 00:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C46C7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=UWonZWSN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZKycszzUqAc4ML0ZOpQzCRLuKkcFAD60KlImhbr4G5Vjeai9EfH6KHzkcPGkS+d7RckaDg8Ci5deAWafMFutedzur/MgVVOb6GKGTCzY6aXYrlmaaAQwlJ6IhE2Scvh/NV09+EOw69AweC/o9Ru3160QzS33ktt9+wLZzKf2A1don+hpe3rnXoJubHv8yq8zQ2XCdr6kD0AJCQ0oi8wuEpXCsBSNwGkrXYkBuySJSI24/IcMXy9HdLWo81woekC5Ondb1iEk+Fn7f/x/zvHARa3kndJm2YxTBMJcN24kzGsJvW0qZxp/iQhBsjD2Atpgn+LSpIvKJN/kpOOzmT8kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7mLVJRpgfKLAIWDIozJRJJei+4fgDXWqvaeefH4hNc=;
 b=wSK0fttQO9z2BI1CoZIYEh6uKMiRMlDwdAdSkySrULnXKn7b07t17QDBy5DJ9SQZF36Wl1LI/OJ5fZJXINqZ1uPDxiI7NTkyAzfq+1pevAhD94GKyuIS9Yu+PrpSUR882V43URncoDRrPOJTo5pRpUdh4FkRq1j0Ykfbkx0RHCScO4vdr9/o3o3ALTzExHqQKA+5hgrM0iQEyH4vG+ahVkMboLkvYQDmpmIshIZ0ngOW3ZqvT5N8wu0mmcFv2cym+2ZrURQxqesBGIXirIXnB7c9iNjkfPx2m9qhb1BCudwz8ByjrZM2oF+Bk+7Xq4gyJR/aOyoojoUSP1Wh9g0khA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7mLVJRpgfKLAIWDIozJRJJei+4fgDXWqvaeefH4hNc=;
 b=UWonZWSNDh4tqxbz2a9Izd5AsvyIIMF7xM4OmQeyB/wRgPCX7PnCa4nIfC/62j49ZSHVAeOf0aAQvTiGIubwnW3hnmJII4PJQ65OgbBniKN463+BrqixqiY8oq3e99ATXCz1cOFeioMG6B/W7N4rF5atEEZgr0qwsAShFeFIlA4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA3PR12MB9090.namprd12.prod.outlook.com
 (2603:10b6:806:397::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:07:14 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:07:14 +0000
Message-ID: <de8c8547-4656-408d-8b1e-cd8f90690ccb@amd.com>
Date: Tue, 24 Nov 2026 11:07:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/10] PCI/TSM: Add sysfs lock and unlock for
 guest-assigned devices
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-9-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0028.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::13) To SA1PR12MB999228.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fd7411a-53f5-4ba9-3c3b-08df49bee4e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|261009221227099003|261009223027099003|4143699003|56012099006|11063799006|10067099003|261026140227099003|261028144727099003|261026121527099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	UtiqFGftqqgpAR722lpvSOYxEqJiVG8b36thJj0E6W2d2+4T7K1BelCuD0ef7qujIsa3HW7qlmxQxc73nMqE2p8qUCkqnoPMSrwDiaWtHuZ0+fgTvhBv1vqVZOJ/65pHJoA4tu42y1Fy2wE/q/YKZHiGQCx2AHubezlwaUU8iwVnewn1Hb55RYKT0mVZesUWTrkLVBPM4oJ+m2egeUZAkZCQaDCnqIIq6/Q9x+YYZ3cOfEK0yLY049ybi/eHmqgdXoXRWZypOyGQ/gTXqiiRayMsX95VklH4RqdCinD+5XY8zxNxWHJJZh68LRZXyah80Hfb8D+CiRBGojXnHd+EAwNUVbD7P2eG8X2oeC0zUfPlZsrCddKv2xfyHfgRuWjWc/cCr+YYyZA59CnRhVUlWLqxJ4cRXpPJ91xpNPbc9WNoV2mm0z2yMmFWMWUnamXT48QF1Q2IhGrsysm0DkOFSszoxdRG4hMt7Kc3elIyabbXObahVgxlIFUnN7rndhnroAcsIfXloUXrzHX9zz/ePE83cufhdp8wOPwMD1u5CAKSkU0MxLbwS15JPLa7zQrKd4alGfntBkJPviTp9przX2T0eCZd3ZU4Jp97G/hgypY+LLT1S56lSairOB6XV8hUELawJodKqozsgD2o30aOW+Bfjdgvt6mABP53PZCeDhs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(261009221227099003)(261009223027099003)(4143699003)(56012099006)(11063799006)(10067099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SCtKOXJkMDdvYmJjQkU5KzBNZXV6WlR5aXhSY3lNbTBrdW1aa2NDWjJRb3BO?=
 =?utf-8?B?UXZUZFIvcXBnWC9wUkY3bjlwM0VSMEI5RzB4MW0xcE5Ub1FtY0NjaTJLc29I?=
 =?utf-8?B?Y25Jdm1hTGs1Nlp0UThicFN3RG8zRHJhUXZjZVdxR2lYaWFLQkk1OEhlVktI?=
 =?utf-8?B?MXh6Z0VVeW5YUDNyb0F6c1FCV2dPMTgrNzV3NHJ5OGN5MEw2RkViZFRlQzBx?=
 =?utf-8?B?ZjFzakhRWCtHWGRRMTREYkVrQi8vTWUyMUxGU3VMZUl2RUYvZHBXTWpQRFgy?=
 =?utf-8?B?SFkwbG8wRzRRMUNxSDFIMXpDUXdXVlFtTHYvYVVnQ2ZCdVcyTnFya1NLNWRN?=
 =?utf-8?B?a1pzTXRMbWhLK3hkYzlwTjZ2WmNZNmpkMXBnKy96Q29yQW1sejUyVVJicWVI?=
 =?utf-8?B?MUtaRG5pWnNhV0laL3Q2VTQybXRDY0RkMjBsNElWUzZZR1o4ZGl4eHJQL2xJ?=
 =?utf-8?B?eGRnOFpranBNMGMybjhKS296cUxoUTVGUnF0NUVyMjE3dmh5cXhHSmx2clJz?=
 =?utf-8?B?bXdXbkF2eGpmN3M3VFgrNlNtYUxaeVJSL3JWVDJwWEtIQzNwYVF6VkFaanIz?=
 =?utf-8?B?QVJaT2xMQVJiTTdodWVSaSt1N2FNOUVJVFVqazZlWDI0TkFJVnZUaHA2eUY3?=
 =?utf-8?B?ZjVrS0NaTTNGL1RhQ2QrRGZpVm12Q3c3UEx1TElOelBOdDdWelkwZisxY0Rv?=
 =?utf-8?B?VGhwZGNaRHVhMGFqa2dVdEkrTWVHb0NLUEYvSlcxbTlib3RNTzQwYU1MRGdL?=
 =?utf-8?B?UHdvN1B4Um0yajVJVmhrL2h2ZFpZK2FLYkJnTDBZOE5Jano1L1BLRlc2amZY?=
 =?utf-8?B?VncrVlBLY2ZKSGx4ZFZZbWZvK2FCNUwxVmJZeVA0eVp1R2paUDlQeUk2eWV1?=
 =?utf-8?B?RlZZQVNaKzBlUGZSS2hQRVIxRm4xcUFMWVpGQS9oMjBYMFl4cjhnNk4zMlM5?=
 =?utf-8?B?Y041WG13WjYxOUhHdFd6TVBlbUY0S0U4L0tjR25nTlI3VkZVeVZUUzM1eWtX?=
 =?utf-8?B?QklYUVhQYkl0dkVhRGRiZkpTOUZqVVpqV0kyQ0xTQVB5U1k3T240K0NvR3JL?=
 =?utf-8?B?UEEzbFBxcmMzNTQ3OHI3VG9HK1FLa0ZQRFcxblZQNURGdGxuYmJmSDFCVC9L?=
 =?utf-8?B?QjZyaHZFcjJldnEvSTZVc0FYK3JCenljb3diR09xbzhOcnpQQkNZNUdidFJU?=
 =?utf-8?B?TzVIWEpVRFNqYkJCYXBiejZCUHhTelZWNVN0SUVIbHZ1dXc2dDlXRXlJU0ZY?=
 =?utf-8?B?L2s4bHk2WEtVQWRwc2FJVm5PT0RsemZlbU53cFhEUjR1KzhPS0VkZVNDMDh4?=
 =?utf-8?B?YTFVdVRycmpML2FEcklnTk15enpLcEV3WFRaUVlydkZFUStvQ3ZQNVkrZmRV?=
 =?utf-8?B?UG1oVWl5U2pseWhTRDNVaDg5aDBiSlZhcTZYdW9oSDJmaTRCRGVMNTlaOUp0?=
 =?utf-8?B?VDQybnNuR2RvVHlGVUpKbEMzRm5YSTEwNGpoWmYxRENOaEUrWmNMMFF0NzRm?=
 =?utf-8?B?K2JXN0JZT2VGN2toV2RBdENEdGcvblNIeTY0dzFkUW54UGZoNnRzTjNReUFC?=
 =?utf-8?B?M2tvTkRnK3FtNlI2OS9IUEIxQk9GbjNLeEVvSTVmQ3RhV2tnZysveFB5VFFq?=
 =?utf-8?B?TzFybm5Dd0ZiR05PcXR3VmNzUDE4aE9PL2ZzL0FraFBnU0F2ajh0TTk0VUNJ?=
 =?utf-8?B?VElaMkJmRGphM1JMLzRPUlhQNE9NVUExUGlGelRyNWMyQXBsK29wTHVUNkJL?=
 =?utf-8?B?SFdxZEQ1TE9VbjVZV2Q2TWlQWHdlb2hSeHNwRGdUOTQxTmxXUUVmaGVNT0t0?=
 =?utf-8?B?Zk9WSG9jZFVzZU9xYUdWWnBnaFZteUpWb0w5YXV2dFBSbmdURE9zdWJOdk1V?=
 =?utf-8?B?Z2RJMHJtakI5K0pkaWtOaUIxSGE3WHNlLzZKZ2xyNWdOeEE1WVRyUDdLemh2?=
 =?utf-8?B?TWMwK2xQNDlRUlA3alJyQ0o3QUYyVWZVNFZKcmF1R2RsTUJDdGNRSXphVzdl?=
 =?utf-8?B?TFY0RHovZ0h6VVVGWXpvbmw2WkwvS3p3TFhHeFBWY1dxUjNUK3ZUM2lFRjk5?=
 =?utf-8?B?Y1M1ZlJPNWVwYzgxMko2RFJvL2RxRnkrLytPV2ovYklZQ2ZLRXNGYkdZZmhE?=
 =?utf-8?B?ZnVSVHNDWE9Id1d6R1hta2lSeDdqTm1XSWZOS055QVl4QndiTnpNOVBrSHJZ?=
 =?utf-8?B?ekFnTjhuQ25lbTdjMm9wdjNPM0k2dy9md3A5bXoxVG1sb0w3c25Udm5wWDJi?=
 =?utf-8?B?a3QxenQ4RE1IMHp2aWRRS3ZudXVHYy85YloxN3pFamsxTGF1THhHV21PblZr?=
 =?utf-8?Q?I8kaBtDAbflldbT/p3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd7411a-53f5-4ba9-3c3b-08df49bee4e9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:07:14.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6J4YO9Qjd5+8IqAO4I+F7H+DthlO9NKQLTggjHAX2AqeUZH+1aut/wGBfuJvl5KwcPI+10swH5YYe/LAT7QezQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> A confidential guest needs to lock a PCI device before collecting and
> verifying evidence about it. Userspace also needs a way to unlock the
> device after use or when verification fails.
> 
> Add tsm/lock and tsm/unlock sysfs attributes for TSM drivers
> implementing devsec_ops. Writing a TSM device name to tsm/lock calls its
> lock callback. Unlock calls the matching driver's unlock callback
> 

Are not we doing it now via the new ctlv tool?

We'll still need pci_tsm_devsec_constructor and other helpers but not sysfs.

Thanks,



-- 
Alexey

