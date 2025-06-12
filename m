Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912BC6BFC0;
	Thu, 12 Jun 2025 05:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749705855; cv=fail; b=dk1SaoikehJzyOCsuorqCywpDiRd8WYiLwtJ/njX5QICYhZ6aWV1w65cfxw07HJ0uW9mLr4a65Y7FZiCv6lkeOKbzlYJwldkZiCPTun8600daT3YgsuQ/teDGpmjKNBbCAl48jrCXeK9+M3O5wZxSkuNbeJVoN82E2S6CInmiSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749705855; c=relaxed/simple;
	bh=9coU9AaAhnyj2REB/dCB9miKEppSj/luPZj23hR9RfM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tsnpFpqZPY6WIHXmEalhYuuQt7RUHZjLhVVBzvafXq0GQ5DxL0kyFoGaOdY5Fi1vUrO5YwYT2n1/8kEfAo1v+w8ghlaOmy5GucjP6Z3lDv+TSMkHwyrMMGDNHXwA73QeyIQDXVGxQoV+VMNvfwx0bM6LJ6tPWv4qOXE7ZRR5xt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nk1hoD9Q; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nk1hoD9Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d05hgrrRKvNg9+WoCNV+kdETu3cmfdD/GOR6soeSoTGmf3oHky8UMO/oX+/MGnnKI6reSTI+NdxUPr4oWu2ubfdEKaS1F4WmdmQdaY/VnS6O9qnnOa9nps26J/Fc2SDunko0ExMSoBX1uDNdTfYkLnxC+LxjzqhTxEUJq6BBGek98jTlGrZkM2vxf5A/oicwuK2J+BolSobeFJpMjIGrKqsPoIe+VKba75Ur3FVLxdX+DUUJBZEFgPyWetBtTZ6+iKatuoXwNV6jfuE+r2jPr1rFKU634ccLGpLYtWLbiQZlsC7CTDCeAloy04OiXESdgHauP318LX+642LEs+DI9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4eI5Y68aOuFmPtJe0ZO+LddCEJovpIJrWthH/Ovix0=;
 b=lqr2UBO3ZugoteOQMcDdnh2V61wyHHrTYeS/JM2BC6Wq1OfB3fhc00yU5qia0c9i7Qbo999Y19mkqDW3EtwSPqe1iVqeaeSMpuGR+rg+2NKMzt3jbxd/hEkOsavFnKAQtfio7Yv7sSCB0Jxcj3iOfAtR61hrfxElFp2r9ZQVpPXzIQG/nbE1R6xfMo6kh/tQXJQaRrX+LhIBHX3i8c6SyhzISpPFcQ8ABx8WC5j+mAuQJW0AEe0Y1f7I8+GWsUdgEH6+E1z8n7aHTjwB+EczC1TQNVfyDnxBLkehPELATrwW1vExYoPfOiakAajv+p9i4fGGGwEgiqdhCOj3svnKbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4eI5Y68aOuFmPtJe0ZO+LddCEJovpIJrWthH/Ovix0=;
 b=nk1hoD9Qy49Jom3JgLQ5YzTshXtLdArf3m6HFvATDsjAfXVseICs3/2mKx3ZEZDW0hdWa3UCqbvXuNtqFLi01T7Lx4fj0XGUm8MxL86BVchVkf9CSaZ71sr7wCA0zIKIlN+UGQO5mmHVLTqZ64GBsC2tSyZB0ld0JaK5mqb3QDE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SN7PR12MB6765.namprd12.prod.outlook.com (2603:10b6:806:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Thu, 12 Jun
 2025 05:24:10 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 05:24:10 +0000
Message-ID: <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
Date: Thu, 12 Jun 2025 10:54:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev, Stable@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26a::13) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SN7PR12MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: e6cc67d3-7e65-497c-a93e-08dda9715c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3VjbEJkOTZxVk5YbmRYQmllN1lVYlFtc2ZCUmgxMkxabXJNVHZFVU14aExi?=
 =?utf-8?B?a1hJSXM0SVBJYjRRam9na1BNMGVKMzBhVmMvZlR0NlBvVk1ZZ1gvWnh3UUlI?=
 =?utf-8?B?TGxqanNKdi9ZZXpCTmQwSElnak1wRGVyMXVsVzZwZG40OS9ubVl4WnVRZnAx?=
 =?utf-8?B?OVhDK3RRUnJ3QVJTSzJ4a0xWeTdmQnVPMVlVNWxtSkxJbEpVa3pJSzd6aXZ5?=
 =?utf-8?B?V2lkVUFZb08xMTVEb1FZY2pTZEl5U1FhOEdVbXFtTlJaMVZJUmZXVXNtYlNq?=
 =?utf-8?B?aVoxM29FbHc1RkpNc3VXbzJlZzRkWXBDVkxsdjNKS0JENUIwdUZ4aHQrRTJm?=
 =?utf-8?B?NG5zZjFDeVBobGs5bVI0RFQrcHV4M0Zwb3BpZ0R0eFQvZUl1WmFMS2VvTjhk?=
 =?utf-8?B?dUljSDV3Uzh6QlozVHJjV3VUNnBueSs5RTdOUmRPQ2YyWHNOSmJSY1dWSmtM?=
 =?utf-8?B?ZlBmeEJBVDJ4akFsbUVMTkxQM2dhRTVreWxkM05vTnN1Q3B4ajh1dWdwUmVa?=
 =?utf-8?B?QzRldWQ4Y2dSRCtVSnNyMG1XWUdpeGNDYStITHJEQ1BWYnp4SExCUktDRXlC?=
 =?utf-8?B?U0lRRHZKTSs0QUszRUZtamRsZXE0RjNCY0xzYThxVkg4cGNncURKZXdCeGdE?=
 =?utf-8?B?cmJIRGl0aFlOUjVDcWNoYW9XdTZ1S2sycEpoT0g1YWg1ZkFuU3JsazZPQ3FF?=
 =?utf-8?B?TUJ0amhoVTZKaTdrR05rTklzRk9EOHgrM2FXYnlMSTlqUFRHMGhuc2ZGb05Y?=
 =?utf-8?B?SENZWkRIZ092bE4yell5STZEZEU0dGwxenVWRFZuSGdzNmJSdVNoNFZOQ3Vm?=
 =?utf-8?B?UXdXazNrcjlhUlFyWURDWmtVVTZVc1Q5TzQ1NllJYUxEU0w2RGZpSjJyc3lt?=
 =?utf-8?B?OGcvKy9aS0tZNW5zM1NWSFFYNFNDaUJESGxiVzc2MDEyV0hxQkM0YU81RVh1?=
 =?utf-8?B?UUFMUDZFMGliM0IwWjB3MktRNnNIbklha09GbWtWRHFrUlBiZjVZWlZSNEZF?=
 =?utf-8?B?emVtNFppNUNaUFdBcGxCaENOTlAvcWNtOHBkWGdpTEhqUnE4cEljakk4TlBa?=
 =?utf-8?B?YXl3cS9qSzFIemM3dWJCc25PNTVQVDMvdDlqZEhGd0pkMHFHOU14L2FHUVVR?=
 =?utf-8?B?WG1aY0NBRmxWdjl6VUtFUXRwZXBjU2lUck1uSDFua1hFUk5FV0J4eDBZUkU5?=
 =?utf-8?B?WThHdDhjMUhsTTY2Sk4vRVdEQlF0L0dma3Bham1qb3Y3WlFxZ3dvWWQ4YkpH?=
 =?utf-8?B?YWgwNGRPendsanpqZU1QVDByZG0xNXRUNlhGRmRiTk0xQ2c3b2M0OFpmempM?=
 =?utf-8?B?YXFwMUdNV1N6aHZXemlKaHZyb1R6OW95RkY1b0dLQ1NpRjR2SjJhUVhLaG02?=
 =?utf-8?B?SlJmZzAyQVg3YWM2WTBZeTRYUFNIU3NzV3RvakhNSHhBbE1JMFIxbVo1ZnQv?=
 =?utf-8?B?SHpsZ2xJSmRKeTV5cGhrVUhROG9qdkJXTURSaHY0Mm01TmIzNVFMQk5mYjY1?=
 =?utf-8?B?clRvZjVKZUt1SFppa2VVQjRlSkRLc1RvQi9YRDdjcm5IN2JFeHVpYTZJd2l3?=
 =?utf-8?B?K0drbWRqYlNHNHlBYWtjNlZkd0pCNytsdlhtRWw1N1A2c3NXUExGditYcUtw?=
 =?utf-8?B?SGRDWmhFb2lEK0pMOXUxRTFNUEJyWEZ5eXhXYkQ5aDBrNDhFaHFiVWhsVi9S?=
 =?utf-8?B?VGNKWEpsTmhDenRLT0JuWVljSmx6dGpUZXpQWWtteFlZc2VtZyt4Rm9oTnRD?=
 =?utf-8?B?NTFxMXFxSG5uRTNWTzltTGh1RndoMGNRZkxSTXlUQUgzVXBhUzhVVS9iQlF2?=
 =?utf-8?B?dG03WEcvUkNzK0hVVUI0UHF5WHlpcGFpOG9GM01Id0w1UXZDbWtlSDZFZUR4?=
 =?utf-8?Q?FWZ7Cjw626VFK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akJwSlNhNytBT0VjMXdTK3dEZGJXNHpGa2orMlIwQkMwVEFuU0xGdzY2RlVU?=
 =?utf-8?B?S2RWNHlpYklQUGd4UXVYRklSZi9XWS9qbDlUTWZjMkN2amVGdjNJTVRJaHlR?=
 =?utf-8?B?NzYxZEhJQTYvbjBCQ3hVUG1HQ3FKRE5scDczK1FmVmY0UFltWnpONVdwWjVm?=
 =?utf-8?B?bjk0TTl2dEYyZWFnZm9YaFA4MGMvRkZ1MyswUUloVEFwdUwwK3hXeVVpTGJY?=
 =?utf-8?B?SzkySzN2WVN6ajVxazA2b1p1dGJWMll2aXNCNmFUcnZHOE9SZi9Kem5BcEow?=
 =?utf-8?B?NE9mSEUvb2t2Rjl6cDRrbHpTMVh1cnArbWFzTHlmZkx4OTJ3U1djRmp1OFVN?=
 =?utf-8?B?ZUNVSDAwa3lYR2RHZkRhVGdlWWdRcWU5SjEwb2N5WnI3aC9abkhhU0ozZzVk?=
 =?utf-8?B?QzU3Sld2dENUZS8vcCs0a0pSbkNDZ0lON2RKV0dBNE04ODBrVjdpODRXV3py?=
 =?utf-8?B?NW5oVzBYdUVxVDNmcmM2WFhWYmpBVlVVcWJSYnFybFVyTVRVTEt5YzF4emZH?=
 =?utf-8?B?RDBBSkhGdGtMQ3I4U0dkS3Vab3RWRW41WnVaV2c2dXJEVi9kMjk0ci9BeVdR?=
 =?utf-8?B?Y3ZJUG12TDIyU1ZqaGo5TW1ERmwvWVA5dWdoTDFJd3dpQlozN0tRSXFqRVlr?=
 =?utf-8?B?aWl2bFkzaVRiQXZzNFZQR1IxQXQzVDlpZ1lEbFRyamlyV3BwMFpOaTRyYm9D?=
 =?utf-8?B?ZjVNSVR6MTJ2L2tMUnVST1NyVnY4UGNMeWdoQzhidEg3TXZ6czdTUnYxZVJX?=
 =?utf-8?B?WjVla0hwbDdhS1RGeVR6SHpnVGEzZ3grOSsrV2tVWDFEL09GNFdkWTdvNVYr?=
 =?utf-8?B?WVVENG56TGdEdVBiMnRUS0RWMlNzRkNXSytuRC9ZakhJRkd3TWVNc0tPOTlt?=
 =?utf-8?B?VmpQd0grS0pwM1E0SVd2a01WZVlacFhlQjZjL1g0NURLazVrejdkbkJkMWFa?=
 =?utf-8?B?VnNrR3hadXV0QVZmTE8zcUtlMVpHQmR2NmFiUlY0R2NlRHBJcWhydFczdS9p?=
 =?utf-8?B?bWxKOFFLcXBSbzlQTVhPSEhHODZieGxNa1JaYUNnL3ZtdTVHVjJkQjgvZFk5?=
 =?utf-8?B?RE5xbTR1ODRkc0VBQlhpd3l4eWR6QXl1MVZQVC9xMnJsN1VTdXRGRkhlNExE?=
 =?utf-8?B?NVhia21xQUFqU3Y1ZFNodHEwOWEza1QrUTVPelU4dDI4eGlVWDk4Mjd4UHpr?=
 =?utf-8?B?d2FKTllJZHh3OW9CSGtMQlhQVDlWNnZLbXRsUnQxdFJoRzYydlNYWjliSkZl?=
 =?utf-8?B?OTZyN3huNXNvZWcvWGpTMklXSHMxQm5PZTRVQzhTNzFnOU5qSWl2TG8vcEpE?=
 =?utf-8?B?S29xT3ViaGdzOXluZXMzTDZyZUcyN1FFY1B0ck96SFdjSGJZZUpNNlY0SXdi?=
 =?utf-8?B?eWhsWGxJUGpkc3ZjaEJpYURsT0JVS0NaeW84WmZYTHZaZUlGd0RoY0hWbENN?=
 =?utf-8?B?bDB6Mnd2R0JURmtOS1FZMVVpMXJGQlVHOEZWTnZqcVg3M3M4T1FGRVFQN0FT?=
 =?utf-8?B?RGlUUVNRRml4TklnN284ZEU2OUhHdkJ6WXdYckRaTE9qZXlVbTkzcEZaQmpT?=
 =?utf-8?B?L0tEVWQwVm85eVF0LzVUdVY0WjhEZitTenFyZld4SndaUUF5MDllZS9PNTlk?=
 =?utf-8?B?ejhUdFkvWFRvZWhPM2d5bkV0K3l3MGpWSncvZHlYbXltSUNSZkR6dmRlSkh2?=
 =?utf-8?B?NnBObUpHNWsxbDl5RmY5RnN6dEZ3T2k5MmxGSDJ3andJanhnQ2VOb2pkLzlH?=
 =?utf-8?B?YUd2MTNIK3ZnK3I5Slp0RjZlQ3RFdERPTWJBVVhYbVBDZEdabjlRWW9TMjgr?=
 =?utf-8?B?R29KSjQvUXM2Qmxla3l2cVhhL2hlRVVYaERGRm44NUJleTJOaWFQV1lKbFBZ?=
 =?utf-8?B?Z2hpTUJmYTF3RGVGZSswQ1JnYkM3QWNZNHh6citJVFM2azVaMHVuY0QvL2NX?=
 =?utf-8?B?T2svLzJHZ1Fybm82cG51dHk0WXBxN1d0M1lVSFF2RlF4TXFvZzJBQm0rMHFo?=
 =?utf-8?B?QlZ4MFNZb2N5c3ZLS1lCcVJaVFpNYlUyTnNuNDYxK0VETVBkY0Rvd2E3eHp2?=
 =?utf-8?B?WWxXTUllM2d6SXl3SGZGT2dPODVwZGk1Y293UVBCNXViMGVFd290a0pnZVJ3?=
 =?utf-8?Q?9g8CEMyIcBHhtSzHm0Y9gWuMx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cc67d3-7e65-497c-a93e-08dda9715c01
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 05:24:10.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0tk7YhC3N5Bf9Zp6Vo7QF8Pw9Uy9b3d8vjOcpzKCJiwSbETjSqHYC1SGBqZhOf+4IBxppkTUsc6OgnQYtsjgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6765



On 6/10/2025 5:28 AM, Jason Gunthorpe wrote:
> The AMD IOMMU documentation seems pretty clear that the V2 table follows
> the normal CPU expectation of sign extension. This is shown in
> 
>   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
> 
> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
> would have three regions in the page table: lower, non-canonical, upper.
> 
> The manual describes that the V1 table does not sign extend in section
> 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
> 
> Further, Vasant has checked this and indicates the HW has an addtional
> behavior that the manual does not yet describe. The AMDv2 table does not
> have the sign extended behavior when attached to PASID 0, which may
> explain why this has gone unnoticed.
> 
> The iommu domain geometry does not directly support sign extended page
> tables. The driver should report only one of the lower/upper spaces. Solve
> this by removing the top VA bit from the geometry to use only the lower
> space.
> 
> This will also make the iommu_domain work consistently on all PASID 0 and
> PASID != 1.

You meant PASID != 0 ?


> 
> Adjust dma_max_address() to remove the top VA bit. It now returns:
> 
> 5 Level:
>   Before 0x1ffffffffffffff
>   After  0x0ffffffffffffff
> 4 Level:
>   Before 0xffffffffffff
>   After  0x7fffffffffff
> 
> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  drivers/iommu/amd/iommu.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> v2:
>  - Revise the commit message and comment with the new information
>    from Vasant.
> v1: https://patch.msgid.link/r/0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 3117d99cf83d0d..1baa9d3583f369 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2526,8 +2526,21 @@ static inline u64 dma_max_address(enum protection_domain_mode pgtable)
>  	if (pgtable == PD_MODE_V1)
>  		return ~0ULL;
>  
> -	/* V2 with 4/5 level page table */
> -	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
> +	/*
> +	 * V2 with 4/5 level page table. Note that "2.2.6.5 AMD64 4-Kbyte Page
> +	 * Translation" shows that the V2 table sign extends the top of the
> +	 * address space creating a reserved region in the middle of the
> +	 * translation, just like the CPU does. Further Vasant says the docs are
> +	 * incomplete and this only applies to non-zero PASIDs. If the AMDv2
> +	 * page table is assigned to the 0 PASID then there is no sign extension
> +	 * check.
> +	 *
> +	 * Since the IOMMU must have a fixed geometry, and the core code does
> +	 * not understand sign extended addressing, we have to chop off the high
> +	 * bit to get consistent behavior with attachments of the domain to any
> +	 * PASID.
> +	 */
> +	return ((1ULL << (PM_LEVEL_SHIFT(amd_iommu_gpt_level) - 1)) - 1);
>  }
>  
>  static bool amd_iommu_hd_support(struct amd_iommu *iommu)
> 
> base-commit: eb328711b15b17987021dbb674f446b7b008dca5

