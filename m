Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010055.outbound.protection.outlook.com [52.101.56.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEE621E097;
	Fri, 29 May 2026 05:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780031895; cv=fail; b=F7eRSHsv5o8W0YJonxTW51TJJlsHD5X+PFEuiZ4xJ00L8lDbtq1UUJp54EzKxUvBNyzmOBwMo4+nh2QKSHCum66N68GNbfx5wKXq1TeBF9B87MYdBZYmfpQqRseToaLfqJHUSjQsAu1T24HZsqGqR/QIgZjks/Vw2usL/4Ivid4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780031895; c=relaxed/simple;
	bh=+6ujn/o5zcUAk8PViEk6G0nRAWTgkDY/O0XvVMJPsBk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fwCil4Gx1kFKc2wYS04+tIC9NmemH9/GarqUATpOvzOfN4Ed120aD9e2bk8anxAs7F/64BqrALCdxhkBfp07cFD0nEmHD3G86K0VOqpfjKZL1ywQOi7AHvoF21uwjYnAQc3R9Uv0JXp8cdDVma2KSigiPlRckxBjp79OB20mf9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CB3bD1hh; arc=fail smtp.client-ip=52.101.56.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CB3bD1hh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VxJmnOQ8tE43AlEMaMYkvcpWcRwPvYOsbQGfZRPJJzooduU/hT2IO58kSFnMVhJkjFiBNuvhKgsU2RBccJZ/cuSbAzm8UjB+XhI4Nd38nQPhwPeZfTUh1QDAWTK8i9DJ7FuMxAXzZcsMqbgAPL42PshA60ntKToM0UaL7wDl+m5yYR/+EahQ2SN3LPxPy2vO9O/lTnXgwq3S2H3hVfgQARDN7JbVBeBvzAAxOp7XN6NUXsoEZdNCXg1yvFz/SqDEVP7Qqu5f8CkHxmbyTAhTCdf0hgm4z3zEB4MDqaio1ZZ+/Gj/tqhEwdo8y98OOAnpp4vDWRE7GFIBWFatAiZP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vADAtwph+sPZZJzGPkl8siuhyUxNCLlqmi9GKC8o1E0=;
 b=h/UNRiM6eNZuGfgnXKSh2qIZ6zmZONE1MeE/oGKSrNi01/oUtBmZGUGmPBR0og3jnRFKAe2gI4o4VQl6RyH53mt2UCmmsTwXNSo4ioPMnM/GsPfz1cItLc93bHXJJ5q1ldUcUWfjMHv96N2DTGfCC4yG1/R+AYKy3GOy8Bod2nBvPPjjXyxm83Y1NO/0PLFMSgSKfmbdWxEjwOWzWrgK/MyVH9CP3nmP/PvNJjxr4BEQHHL8skKEmj/iDub1Kf7aLgki+6TqqwqqDTCNSg1N+1LqdUVktIQCG9RiJBOmbZ9aexvesCTaUZEx2YTuZm9GlFUkrwNQasacRxoT6wKg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vADAtwph+sPZZJzGPkl8siuhyUxNCLlqmi9GKC8o1E0=;
 b=CB3bD1hhxcuKarHjJu/7kUoXg2Qztw9EakEb4hyJ4yfXjcFBFYDdan2cmhLS5wjY8a3qa2y4hzuUSVrLzUjXwBsIiuTHcE9y7nKyfbSLD1UZXUzmjqBE0VjryTuNEbQv3De9MHN/y4Yj2PemXbgymaTEZhTqcRw+Zj7RJ522qNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB5766.namprd12.prod.outlook.com (2603:10b6:8:75::12) by
 DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.14; Fri, 29 May 2026 05:18:11 +0000
Received: from DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::222:966a:d65d:d08e]) by DS7PR12MB5766.namprd12.prod.outlook.com
 ([fe80::222:966a:d65d:d08e%3]) with mapi id 15.21.0071.010; Fri, 29 May 2026
 05:18:11 +0000
Message-ID: <a1bd3c5f-2730-49a2-aae2-f17abc055fbd@amd.com>
Date: Fri, 29 May 2026 10:48:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
To: Weinan Liu <wnliu@google.com>, iommu@lists.linux.dev, jgg@nvidia.com,
 joro@8bytes.org, suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
 robin.murphy@arm.com, santosh.shukla@amd.com, chrisl@kernel.org,
 josef@toxicpanda.com, Wei Wang <wei.w.wang@hotmail.com>,
 Samiullah Khawaja <skhawaja@google.com>
References: <20260528223147.750229-1-wnliu@google.com>
 <20260528223147.750229-2-wnliu@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20260528223147.750229-2-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b7::15) To DS7PR12MB5766.namprd12.prod.outlook.com
 (2603:10b6:8:75::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB5766:EE_|DS0PR12MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f180861-d447-4b72-ea8c-08debd41ad32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|18002099003|11063799006|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Fdvb0tSQy8Bl7KKXplgCQzrUiJ12MFF4+YcscffaFiWDNKYHsjdBLsybVCcnLISX15Paaxhqq4gvY5BNkLJKzULcAJafg4AD8/hdhtiYVkclMQhl2XmrEjJsEUrG45ktmc6NhrPQBwDJk+3X8rqu6Em7s2TTb8UnJeEfEkCqido01wE+u5B7bPkefVeeUapjQ7SRXR9NAgVQ+fm+t7hWnp1jcgInG0n70XMnHGVvdfuXS6qhVHwiyMtM//Dd08M1Qmkhkr8o08b8vOLAV8QxyaGxbNcrmTJrw7qXlNDejzk16isqFNHmYJwCPIECkyztD7W2Y6zxjdjTOMsXwaPAWlA7wZ9+jveNu94bQzFfsWqSWjTNB0QEzmfkeXncTuJ4cpJ0DRrnD0KYDucysTlJS8yKUPs9nosjbSJdNI5WCh8+PLPzbjK6PDN0BPTDlPKxs3QxnVRi+MVdymDbwWbjP+hf6vLSiJGCyq+U0l8n4PvC66pqSw07T0rhNkQiahnW7a6L413BuRzN+IXj9E5Crm8c2qg5otxLkUs9OJ90TQzWB0LBNmpKEbd2sfJlLgjvTk7ariJPaPz4Inmf01PJYAEEsQUmNwVStBLEErQfotEhPcxb68GCCqQ3Tna9UYbpc2somNOnkBHgBPGxoS4YVoqH2vhSR6d255DMzyK0QqXccfoQJrlPzomkKTLKwm0VwPvvV1buGbTV50MbhT9BRQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5766.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2lKMEtVcjNoNlF6NC9POXh2OFhPYTVOZmNjbGQyd2pMeThlWVR5OGxBOVRU?=
 =?utf-8?B?RFoxMmpZNHNwQTVFaVNWZlJkWlpVeEZpMlpxSDhXL2E2YnRubUpQL0w3Q2hR?=
 =?utf-8?B?QXdDVTVLZTlvYkZuYU52UEJRdGJDdS94c082MzdQSEkxRzVXYUNLUkNxTDhx?=
 =?utf-8?B?ODhlL3p1cDkrSytMNnQ4WFJhRXdNelY2ZFZuYWRIVEU1ZklXT3dhcm5EQVZm?=
 =?utf-8?B?SXcrOElWL0JXYjRzbFlVc05naTk5OERrWlhQWThsOWNKb3BKb2ZIVTZDOVJD?=
 =?utf-8?B?Y0pneWVZWTdOb3lyMFFPMUo5Nk9WNU5QaUp0WFN2Q2tIa1hRclFMeXhTZW9y?=
 =?utf-8?B?M3p2WHMzdWpMQllYYTNvcW9CeGFpUHRhcHRVQUZtSEFoR2pMVUZvRnBWZzZn?=
 =?utf-8?B?UWpDaFlLOFVyR0JuMFFKUk9UMURUVHg5b0ZGaExYNGpwNW14V0RMWDcweGlW?=
 =?utf-8?B?QnpIY25yZTFDaXp3aW5xSHZjRk1lY2o2Tjk0MHZLb3N4TVFoL2ZUSzFWa2Qx?=
 =?utf-8?B?L0dETGcvR1p1Tkk0SDVZR0VsR0tJQm14UDZGdkxEelhlYlNBSVJwbGxFU1di?=
 =?utf-8?B?OUtHQ0cxVk9CRHZXd1VaZmRROVM5eHc3UEkrT2l2N0g3VmJIQmp1Snk1ME9Y?=
 =?utf-8?B?bEZ3Ykx0K0lZRnV3Q0h2SEhrNy9tZmwxbnc5TUwzQWZQQTBXd2FVWEN5RnpR?=
 =?utf-8?B?UjBiNnJTb3dvUCtTcS82czJtVGV3Q0gwQ1ByQU10R3p2VTBuQ25MSWtjZGJU?=
 =?utf-8?B?Y1lsS2xqbXNYd3kzYVZDT2loeFF0Tmc2V2RKaGROZ3Vncjl0UTZ1eFpndFkz?=
 =?utf-8?B?WG5nd04yTzN0dFNPMmF4eE9BamQzNi90d0tmcUdvLzZzUUp0U3ZnbU1zV2Zo?=
 =?utf-8?B?RWoyYTVpM1BXVDY1aWZXZng5M3FvYitzVXFIYk0rNXVvZHZKL1JMWHhWbVZC?=
 =?utf-8?B?SndSajA1ZDMxU2FSd3haM1YwWkdFcDNyejg3T2FuNmNrbzZIN29WMkJFVCt4?=
 =?utf-8?B?UWp3Ly9VUHFKbWdGbGUvSE5mQWpIRHY1aktKakpUemtGTHNhZ3c1eGJxQzNu?=
 =?utf-8?B?ZVNlT3BGbjZvSlhla1hUbE9lZzRpZm9GOTc1akYvam14TDQrcXl6UW9LaFVm?=
 =?utf-8?B?NmE3cmlMV0RyZHFHRjNoK3RuL2NoMTNGa1JVcUxZUjJuOERuYys3SzhOL0p0?=
 =?utf-8?B?ZEZROW5aMFlTZzBqeTJpdGdFR3NzWE9Sa3dIbjNreGhDM0lxT1VvQk1IOUVw?=
 =?utf-8?B?Y3VRa0o5VExNNnBYZ0Q0WGJxYzRnQTBIWm5mZXlLU1pXdklUcFFIN1pYODlF?=
 =?utf-8?B?QWdxa2pzQ05xbWVZdlQ5aGU5bTIyKy9Icnl2eFpRalNKQ2l3TlNMRkxsWWVw?=
 =?utf-8?B?cjBTb0tKODNOa1QyMUlvWnBtVENOSDFDdWV4MUFvemp0Y2hPVkRtNTk1cUN5?=
 =?utf-8?B?K3llTVNZMGkvUytiM2JDSTFtWUdwVktFQitVdXI1UWJtUmJkTUpxV1JsZmV4?=
 =?utf-8?B?aHVaZWxENnRkY3dESE5JU1MxU0Erb0EzalFlVERVWjl6NW9YbXdsRFJQamZU?=
 =?utf-8?B?cGVRM1BqQ1pBZGFmbVJSRFRXbCtOTnI0UnJEUTdQTnduS092Qy9LVzhSc1ps?=
 =?utf-8?B?YVp0NE5YMTBFUkt5SlVMVWRYUDR3VGdONjNHektwckNWdGNnVUE3SUZHMnVs?=
 =?utf-8?B?VUpyUUoxZkdhaUIwL3BXUXFMVDUxTXY4TFEvRjBBaHF4aGhxa3hYbHU2MjEy?=
 =?utf-8?B?eW1hVmdLSVB3SEc4Mmo2NGx5OFJPV1d5Y1VXREVtNFpBcFNPMVVJclBPQklV?=
 =?utf-8?B?OUgyU2wvR1pNMFFVYUgzT0RFZ1BPazRpUTlyVHZhOEdsTzZkaTEyVDA0b1cv?=
 =?utf-8?B?QmVlQ0pnOEpqUVBNQ2VYeU80VGtlbC9zMGhTVlRoeDFUU1BNelJ3RWc0M0xB?=
 =?utf-8?B?MlZNS0JwM1BtWW5XeTIzL0tHREdBVEcyamlLOWJzVlZJY1pUMlZ4UFZTbUpJ?=
 =?utf-8?B?N1N2b1RvNWswU0s5eDQ0WkVOVGMwT0Nnb2E5UUtKWUcrTE14NlFBVTBKYmdY?=
 =?utf-8?B?QThMd1JCMFplQ0pUNURiVFBoKzhzNjRtOEh2QjBNdjdJb1h3enpBMkxUWS9R?=
 =?utf-8?B?WnI4U25xZExBZVg3SzZ4RjBRRUFLdGNjK3ZyMDdVZlVKampOWmRLb0JNSDRX?=
 =?utf-8?B?OWJKVnc0ZEYxNWFkeGM2Z29hNHZPSlVVVUlqdXJwRW43dHY2T0lMSnpaaS9q?=
 =?utf-8?B?ajFwSHozMjhpU1dhT0gxVnpjOWhkektwVjByc1FTZmU0V3YxeklxN0poN3dR?=
 =?utf-8?B?ait1MEhydkdRT1FUOGVHZHhiWHM2T2Iwd25yYWpEL0krbHNZQTMwUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f180861-d447-4b72-ea8c-08debd41ad32
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5766.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 05:18:11.1389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQVSqLujyut6dg0xTvEzp5ndI6evbCYbORi+XebZWuS9Szi2l5lbT3PTNVfSMlBe87hnwR9iDcfX363zX0/1dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9273



On 5/29/2026 4:01 AM, Weinan Liu wrote:
> We have observed multiple full invalidations occurring during device
> detach when we are done using the vfio-device.
> 
> blocked_domain_attach_device()
>   -> detach_device()
>     -> amd_iommu_domain_flush_all()
>       -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)
> 
>       	while (size != 0) {
> 
>           -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
>             -> domain_flush_pages_v1()
>               -> build_inv_iommu_pages()
>                 -> build_inv_address()
> 
>          }
> 
> build_inv_address() will trigger a full invalidation  if the chunk
> size > (1 << 51). Consequently, the guest will issue multiple full
> invalidations for a single call to  amd_iommu_domain_flush_all()
> 
> Without this patch, we will see 10 time instead of 1 time full
> invalidations for every amd_iommu_domain_flush_all().
> 
> Cc: stable@vger.kernel.org
> Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Weinan Liu <wnliu@google.com>
> Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

