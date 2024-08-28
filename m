Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8414C14E2C0;
	Wed, 28 Aug 2024 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828189; cv=fail; b=WeNR57Jv7qefQcSo44BFnIQkOjpvoDLJ8DtjY3/vbBFC8UZ/ppIH2e5LaD9yDHd0XCsqisR/gqkT8L+z2ZB+PkyCNKpWVHbivPnMMP+xLEjLo4lpP5s+cyXrQTwBc8lAXNnAqlaTZVXJJpFqJ8IlBTZCNIw3HW3mfi/pAu1FC3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828189; c=relaxed/simple;
	bh=EyRrJFYzBjUgjYSlxcX9zaloOO130/lNeZcqWq66Ne4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DSrW8KFXUA4GAzx38JVvutncHY/o1xkHAi+eFj8w9JNwn4cNTZNqZlDFXq6k9jJfeKWrKspKHkNFQCXvAOi5DyRSQ4I47MiGqDXeKINI4FbiQ+XlIcWxUJEdlXCu7sJakWpEwQkhs6B47FILYpDHwBTxEWH/AtX4VhUuxLPbQZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sm5KRzSV; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sm5KRzSV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnW4K7QJ13t3T12lBRRi+ZdFfsDsJGymkX2W5w2h+tjmXXPzqTVoiQ8P9SxpZJ4quUNOx2twjzE2JwGaVrJ51iBtzZIBUsW8ltsn/n3XR3przASx3qfBZKn/lIVYpLTJDuQ5ZTRwVn3SkfBMzRGrNvZRUfg7b/R9U/uaiYmOtQeHxh/OYbk6DXCO2Vg035McFvKNZV9LHxYGYFq/SJ9XRUZOp2ofYgHCFQ24/Uoh7d8YLaWgAc++KgchpBqicR4C+gQB94FR/pUoDpoY7QTBKruPZFXleByGtAAE86KCvyBIW/XFd38Q4xpxmk8aQ9T8YKVc8Qaalj7ZG8NdYFl+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzdGvmCZUDeC3EP4XwzOiJC11Gt5EyMgmnUga+ZVfAk=;
 b=D/zju5hctmB/1Jx/ZxafGJqRotqDUG927OhR8FZoSil3zwz4OGN3qcUSarls7BCX3L0vfx0i1RspVWOGKvbUriuYHIbNI7S7x1bOslnIx0fdZ+JwYFbM67dOyNS++at2j6rROFMY5yfidTftIlOI2v4J6FZkqaLsjGhgSzTCbvLODRnH/iJCyMHIVpIz+5gubL3j+QFtrftCKIIslRC6a0NHTyeBbvC43jlvPw8S8EbnbGgNiI+Uj9ic6p3tLdUAGkzUWqTKJ9xPVXJUloCh78oj/xD0JaxA8EPQvBS2kUa1oTov9FVmCjaweD3LZ4gjDRpQ7VydT0wP4O0LeADuvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzdGvmCZUDeC3EP4XwzOiJC11Gt5EyMgmnUga+ZVfAk=;
 b=sm5KRzSVJPZEWJtJChb1oLC0f0jPDYfYPvdtW32YY+GM7gOaD0rExTgkCtht2GzITc/rNFy0ZTBMRQILztJn5Gg3Dowo3n8AO7urfzmQKFXNYyWQv9cIaR56rdJhDdd3y4Niy/c6aLTsoikgs5TkGTKm+0NWIyvNd89ighLcbCY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CH3PR12MB9077.namprd12.prod.outlook.com (2603:10b6:610:1a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 06:56:24 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 06:56:24 +0000
Message-ID: <55486fd4-1bb6-47d5-ba36-c67f1fc67688@amd.com>
Date: Wed, 28 Aug 2024 12:26:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/14] iommu/amd: Remove conditions from domain free paths
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <10-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <10-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::9) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CH3PR12MB9077:EE_
X-MS-Office365-Filtering-Correlation-Id: c481e624-e07d-4c08-42fd-08dcc72e87a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXZGZlVWYkpBQkdOQzJKNVljbHVrV1VPTTZ2NURBRXQvYTNxWWw5R0RZdGxj?=
 =?utf-8?B?c0tXSXhkNXMxMlRrUkE2b0krQ0xFK2o3WElQMEpDL3FURGlyVGx0MnUweGJJ?=
 =?utf-8?B?SGtzYzd0akFldmluVUhLeUdWaHVYRlhUMldKVzlCcUp2c1lsTkxVdENPTUwz?=
 =?utf-8?B?d2pCbTNLN3RTVzlCN2FXRFV3bHZaSmE2ZmlJR1RNbTZIcDdjeUx0SmRnMllh?=
 =?utf-8?B?K3JLVjc1UFVhbGdORVBOdFBWZ0VyY1B3czhxY2NDYnppUGdISXJtUFBMWmhq?=
 =?utf-8?B?SGNXbmlsdXFZRmxJTEVrb3d0Zk05Y3VIUFJYVk1NQTJXaDZrN2NRTmYxeU5j?=
 =?utf-8?B?VzNOaVVEZHAxUERGS0hjWGdDUTVXV3N5WXg3VDJ5allJSW91OVhxanpGa1l5?=
 =?utf-8?B?eWNlSXNWdnVESmJuMWQxZHg5M1VwRUkvWTBTMjlUZjkvVEVuTlRHemNnd1ls?=
 =?utf-8?B?YUdncG5ITHJVT0p5Y1lWZzAwSDh6cjM5SVpJalJLVCtrL2ozeUx5Y1hYNGFF?=
 =?utf-8?B?emp6TFBKMVorVVViNkNQZXRSb1NGaGZ3cVZIU2VYVXpHK3hmZXdOYytybkpw?=
 =?utf-8?B?L0lmRjBiTi9nM0ZNNkRuN3IyUVcybEZCemNyMjJIRkdMaENTUFBPTFlhb010?=
 =?utf-8?B?dVhmOEdub042dENRd1RIR05UMmgwN092M2cxMUFFcjNTeWxOcE1GZXVGSVFu?=
 =?utf-8?B?dmllRWdwUXBjdHJsTFNZaElvN0h4VXNvZ2txNDFkU2FmeE9OaHdHY1RxOXdz?=
 =?utf-8?B?THhVVURMQzFGWnVjOHpsbGIyZDlPVmc3disvM0w0UW1IRXEvbGVNYyt2UDRF?=
 =?utf-8?B?R2Jrbm9IWEJiT3I2YU9VVUl5K1c0RTlOVFc2Z3VqV2Q3ckxhZzFJZXl4Ukwz?=
 =?utf-8?B?SVphVlI4Mi9ITXhQVmFrdDhOYURBRyswL1ZzcVlzNEFadFdsRm4vb1R3enVF?=
 =?utf-8?B?REFFaTk3Slg4dXNFMGhkd1FpT3dDQmJYUFhZNnRMY1NmYUwva3RCYTdXYVZp?=
 =?utf-8?B?OTVPZGtTbDJYRk42L3gyY1I3eXFyV1luZDJFdDhMMEFQVkFwcVJJQzVYUVZx?=
 =?utf-8?B?UWNWdnMwN3gwbWpaSGVLL3VITUZ0SmxKZkNBOEl3U1VXUGZMK0FOREtKZEho?=
 =?utf-8?B?QUVVeEcwSlNOY2J5K2s2UW9wVmFPbHliYkVHMjU1a1BGd2QydmRPV04vL3hZ?=
 =?utf-8?B?UitVd2RKMGtVN3VKZ09LNXQvbTZEbUVud0ZaOHZRV2ZERlJtSGZsS29sLzhX?=
 =?utf-8?B?Q0EvT0pSYkdWUEpSWkRnR0t0Ulk2T3B6cTRNdlJUbkVQMGhGc1F3K3hRSmky?=
 =?utf-8?B?MWdkTWl1YXhWNjAzVllyNVRVb0NKSnNyd25PQVhQUFZhdTNyR25qNkNYQmVQ?=
 =?utf-8?B?dnVYZytPRUYvY3MyUDRzU2JhMzk4dnBOaVZlRk1nSkZCMGpWT3EybkpuaWFJ?=
 =?utf-8?B?L3k0T2o2Vk5QUHhhS1BkbjBNS250WXFVdVhkVktnMkJzckc5V0QrRHRKTVIv?=
 =?utf-8?B?Z0cxVjRyejdPdWFvdHhkS2V3OWR4RjJqNkFodkY2OUkrVXBQUk16WTQ5WjhO?=
 =?utf-8?B?WWN0RlVBN210a3BiTVJUOWU5NmEzQWhNSmFFN1Bna0NXS2VyNzd0NFB0SE8x?=
 =?utf-8?B?MVZrY3BXS0ZSTUprcTRqTVRzeHZoL2hDQ2x0M3Y4aTltSll0Ny9CUC9yRUtX?=
 =?utf-8?B?ZTdPb1hvdDUxM0VuVSt6blc3RGxjTnk5OUhXWXZZSVNYM3luZjY0RTM0M1JB?=
 =?utf-8?B?Nk5yWld3emJiWnVxTFJmL21KVUxPd3ZndFBPd2hHWUxROHZDNWZvTFBLM1Bl?=
 =?utf-8?B?Sm1BdzA1STRkNlFNUG1XZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWN2Tk51ZkxnQytodkZib0w1WHQ5NnVJQXc5OHhYTE9DZVZmcUxHelFPaE1u?=
 =?utf-8?B?dWZJSGduTDV0NjdiK25nM3V6Ujhrd3JYMEVuZ2VkU2M5RzJMUFZNSDB1cWYr?=
 =?utf-8?B?Y0pZKzNPVVcyWHhjRkQ4TTFzQW5TYTZITWJvT1NqZ0xBY21BYUZLTFRCN1p0?=
 =?utf-8?B?eUErcmVRWmNncS95bGhJeGI3enN1RCtFb0V5QUVWS3pDa3A1aHUxZXJNbHhw?=
 =?utf-8?B?R3JYL2lIdzdUd3VDMEtnZFVaK0ZFNXBBM000aTVpQ2dqdDM2ZHZqVjFZMDhM?=
 =?utf-8?B?OU9ydnExRE9PMXRBd3BTSE1hODNTQTRQTW9GZUJwYVpCK2htb3MxVlhSVEV6?=
 =?utf-8?B?azZOakZIcmRXQkdPWUVDN0hFbkNzdjlyRHZrOXhXMjB0OHlTemcxcUZqWW1G?=
 =?utf-8?B?cWFBTkJldGVpNEVaYXlYUzB2aXlYQU9rNWVSdzRPYmpOU0NBck95b3JEd3BZ?=
 =?utf-8?B?aFFtcXlJYnZXK2gzMkVVY2tqc3FXUXovRkR6VVlhZ3BzKzkxcTVPQ2tnNkVM?=
 =?utf-8?B?YXBqdytJcUhYSitzYTNNTU4rYmtqUlN0VS9WU3RHS3NsNis4dTNidUkwbExw?=
 =?utf-8?B?VkE2NjBSVWUxNkEzWTJZYnpNQUZpTnBGVTdtM1VubkhQckpWWi9oQkRoNEpN?=
 =?utf-8?B?TC9lR1JkSnZaZUQzdGpFQWRKUHVEUDNVcEQ0Y1FSTHhGVkEwc2NncWxiTmVl?=
 =?utf-8?B?SUJBa2xtSndrSU5YSDNhd2VWRkpna3lmK09qZkZMcVhYVVRYbWRxVkt1OS84?=
 =?utf-8?B?ZC9NbDgxMnZvOXBsbHU0S0doYmluWVVqN0ZRYis4WHFTdk5zb3kzdzd3RFZO?=
 =?utf-8?B?blVxTlFadnRIbUNHa3oxYms0cGlUcjZkSG5hc3RVRXRIM0pySlJ4VDdtNkI0?=
 =?utf-8?B?a2NVUUFnQzhPb0ZvNldJUzFoTjRkdGp3V1Q3OTVxUlhKUHFLQ0lkeGcvSjRZ?=
 =?utf-8?B?RU9SSXR4alZEeTZBaU40ZithWm5ydWJOYnpMS2crNXdHZld1RHR1Y1RITjVv?=
 =?utf-8?B?bVMyMys1UlJIYU9UU2NpdkNaUUlCSUY5VUI2b1lVbWY3cHcwZThiZEtobyt0?=
 =?utf-8?B?LzBiWDlnMTRWUGNqNlZvNWFZQWpSbEJPbm5DMzFkenJGRzVteUdnSURyUmJl?=
 =?utf-8?B?dHcrbDBQcC91Z3Q5UTBMd0RkNG5VbTI3cEwzYjN2bWVYSCtVM3JocCthSjJ2?=
 =?utf-8?B?bFhvRnlzSE9HM1doN1JEWUdJMWhVai9LSDg2QzdqTDhzd0lHMkR1OEIrYW1z?=
 =?utf-8?B?YjFIejNqS0orcEY2MzNVNXdxT2Z2d3JpYXBsY2ExbHRRYXhZdlQzT1JtU0Vl?=
 =?utf-8?B?bjR2RVVYcTdNUE5GUEkxUHVUbGtXQUJya1dDNkxkYW1jeGwzMFVVMmV2QkJQ?=
 =?utf-8?B?THUwV2VsNUhnMWRvenpwN1oxWWNZSlJObCs5N2kwQ1licG51bWRsSlJ0WjdZ?=
 =?utf-8?B?VWJDM3g4SkdLcGpTTlhWZmFXR1B2bzQ1RktIcXpEUDVsdFcvUlpkVEFVOUhj?=
 =?utf-8?B?SnkvaGZ5Ni8xWkVxeExPOVk5M0QwZU5OeGRRc0JTSmV6TldZcnQxOGtrQlds?=
 =?utf-8?B?ZVRyVmJrVW5xeS9iQW9tY1ZDYmsxSGRHYmFSREhqSjFreTZac2dYVUdDeWxy?=
 =?utf-8?B?bjEzT3o5V2RLRDJsNnNmQ3pCVEsydFpHcW1OQ1ZIUFhmOGVvY2RYV0RLT0Fn?=
 =?utf-8?B?WXcxSWdMbzRhS1g3UzU3YmMwS25XcDkyTXVMNVVrVUxOQUlUbXJtK3h5YzEx?=
 =?utf-8?B?bExzblloT0ZpZkM4VHYrbzZhaG1GcjhEeXY5M0hjOGxXSTZpNDYxR2hYUzVF?=
 =?utf-8?B?S3ZMbE5CNWhuN2RIZy9sUmZwV0VpVVBuUkt4MHpXN1FnYlh1WnNhTmVVVE5F?=
 =?utf-8?B?dyt6c2FNczg0dnlyblBGYkdnaTVHMmFDTEl5NG1TNHQ2eFFDeHFacU1reHRW?=
 =?utf-8?B?MXBvbjV4YkpsZS84aWttWXpyeGwzRXdhUlB2YnRBYUJibStEbkEwbE5heUNN?=
 =?utf-8?B?UUI0eU9DR0FWekhoWVdRTDdyelA0eno3TFlnR1VaSDVGT2srdG4zTUNhL09W?=
 =?utf-8?B?ZTJCSFM0UzVzV0JvMTRreVFLMGNJbHhZVStrTFVrSmY0azljOUprU3Fxd3ow?=
 =?utf-8?Q?aO9PDOhHfDSrQgH2nlR0i0nD6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c481e624-e07d-4c08-42fd-08dcc72e87a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 06:56:24.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnF1yr0Imm8A1z8jzYM2LENqoA/nj330MG7/sRH3hG5YQmsa/LbHMNV5y7uBfdoggpmDuaubhjByJM2beRCi7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9077



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> Don't use tlb as some flag to indicate if protection_domain_alloc()
> completed. Have protection_domain_alloc() unwind itself in the normal
> kernel style and require protection_domain_free() only be called on
> successful results of protection_domain_alloc().
> 
> Also, the amd_iommu_domain_free() op is never called by the core code with
> a NULL argument, so remove all the NULL tests as well.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant
	
