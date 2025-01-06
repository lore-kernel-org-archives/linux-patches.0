Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E171E487;
	Mon,  6 Jan 2025 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736174041; cv=fail; b=FKkbwA5zGDwXPiFkBGfG2D4AaTKAPLzXTUkChG35xvLkhkshwTzkcYk2nk4IO36U9nNuvdEamec9rUV1XNH8L4mXfq+s1oUEEkJyrTsYZSl0oFpDoCrtiVXzGtu0bEmOb6qrsfwuRVm7JQritjN8D6AG75klwTBGbNlUX4grec4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736174041; c=relaxed/simple;
	bh=j7JfIsYewbQdsWLMqRplOjB9R49yjUU5SopOGtx30bo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=prG0WPWZGSzg2I/JpqAGuEA6V1XqJgYj6ew4MnhMFx0t542TK3AN4XLx+Cq7TAfADjb21xWWsZymLNEtSVXxlWHCZ7GC6Y8uCMSshRuU9Ub3+OkS1hX1fdKtnSkdCNREEoetOYogyC5GHf1Vks6W4I9nYnzNCd7nM2oHoEvvlZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zqb9dZyj; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zqb9dZyj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7cwytP6PgU1MGPVo/gA0FNUWlNXG5j/WSvyoYD7P+GHge/b9bIjCRJbA4tbj+lDvRmINrBd9XeHCDtX6h7hsiCPHz8MYeTwwBkSl2vMaICTxGJyPYbBKcMnPUKf/Ax6Q3E4FUHh3UUtR1BH2GUSkvLyIdn0H6NzmX0UD6L9Xcjd+E78C8arkivwYNKQ5pVpniRuYuTg3KXr4to5n99Xvvqu3cyvioBIpDPFH8cXZPUxF0lzt579pBtMhp3iiiwxmi70shkXfysRNYSeKHZ8S1l9CWT8xKtsCJX5TBcOlLA43Fhetcmvaf+ITXg6Ypg8f2JREiqSGXrt6rmapxN/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeVa6FlAui6h5r2n+FZCgA6/G5H0wG/JJ2yZQMUou3Y=;
 b=paTiQRiFNC1YIJUADQTHNDEAdIMCF+vF0HKLxTi8E6bIHsjqfTC6gJeAxBj6Zsex9g5NOGHLqx3eUJwr+r+3CWtSJN7Yhy7haZLB+JQwUuW0E+Kc8BmJcM8mbOVDyfi4QNUtWR00Z6wb8aHNyfYkXWEU/LSwmqLtJ3RLxY93namUaYBN8TzW8PMFYMpiSJa3LUd60YE1nJgpdAvBWevb1Az87FatRjN4NV6bQZDxFhgPuQnzybaVG7kPPtjLl6Oy/3VjEwumMI9ydOPAx1FUki7fEzPeuUw7hQjDkJCQHiGWzO6fTMa8ehMqMpcZC6ZTGUQq0KPk3tGfXHExWwonRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeVa6FlAui6h5r2n+FZCgA6/G5H0wG/JJ2yZQMUou3Y=;
 b=Zqb9dZyjsnUfPILXX2E4uC/S09/FNjVU+7c8+OftPpMhxotQXB3+o5y2RNZNM8mMzBVEZiwYocYRAFmENt+p+GHIpdDUI1ivWF7E7FBS29t5bO/O24BotxvQwpxCuxOAbGx9ee3ILaEuJJaVk9GXjms0e5CygOfhFHFiRngOoXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 CY8PR12MB7563.namprd12.prod.outlook.com (2603:10b6:930:96::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Mon, 6 Jan 2025 14:33:52 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 14:33:52 +0000
Message-ID: <97add702-c152-4cd9-bdf9-8fc3d130f58e@amd.com>
Date: Mon, 6 Jan 2025 20:03:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] iommu/amd: Remove dev == NULL checks
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <3-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <3-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0131.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|CY8PR12MB7563:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d728d0b-9604-4065-2152-08dd2e5f244c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkZ3N1h5MWdEUXhSN3NDK21qak5OYzRhbE9qcHJhUjBYSWhxc21kYnRiOHRB?=
 =?utf-8?B?M3hCcERWUGhFWUdRS2lseTFoejhqY3F1RnpoZVpVQnVvVmpkMVJWbGFNdExQ?=
 =?utf-8?B?L2VUdUJhSCtsYlJHWEYwb3pLT3JrMjdUMXVGVEkxdzE0ZzRYNzIyVCs1cXlL?=
 =?utf-8?B?SytJRVJZTEpqc2NDK1hINStyZHZpd25xeWlYYXRNNVFndGpXbDFWNGxQR2tU?=
 =?utf-8?B?Q0EvWDhTNGk2ZjMrcFp2N1B5Zm5NWCt6Q0MxcG44bTVoVkp2aGVEREprRnFP?=
 =?utf-8?B?dmVFKzJIbmFjdGZ2Y21FYlhFS0JVOVhLbzB4YUF3WWpPdjF5dUhEYkRXZUlG?=
 =?utf-8?B?L1QwNk5CR2hJNXJOcVB3WFlsN0IrdVpHblo4a3dJTmljcXlDU0c3VkR2bTZG?=
 =?utf-8?B?QmpPcnIrMU9PRHhHNXJ4MkNmbXVmdjVRYU0rVEVsK1FPVjlmU09mMGs2d09v?=
 =?utf-8?B?aUJ5Yng0UGUzbkZ5bVFsaGdMOU5raGN1OXdQVVFGb1ZPLzN5ZDZJQkdIWkFS?=
 =?utf-8?B?ZDEwL3lhZFI0WDhGNitQQ3d5OTRnYi9tUWgyL3E0N01QUElja1Z0OENLTW1h?=
 =?utf-8?B?aWFwVlpSK1dta0lodW9RTXNWd0JESmU1U3ZQRXhMbjI1Z05Ta3k2S3B0Q1N1?=
 =?utf-8?B?WThGWXoyK0NpRmFqSCtiQ0lEbkRGd1d2OU5ra2R5a1NHY3BNclY3U2FlMHhV?=
 =?utf-8?B?bGJDb2dFTkgzYkdaZ3RaWEZRNEFUK0N3NjUzYWV3Uk1ZRG5TR0tCWUp2aFJI?=
 =?utf-8?B?R3NJZ2xwcEhNTHJxUVdFekExcVBpcmUyMXBIeXIwUGlvcDlvUDVrOWVHQURU?=
 =?utf-8?B?ckxZOUl6Z3NzcU0wdTB2a2FpTHR0OEhUREdSVTNIMEhmS0dVald6ZjI2VkFw?=
 =?utf-8?B?TER6VGRqYlVjWFBJbjRlZWkwN2Z0ODhvQ0hwaG5MUXJBUjdlUi9DaUJxMkZr?=
 =?utf-8?B?TEoxUFlxNW9kMUVMMkhBVXFnTjlTN3Nld1U0eDYrZEJmNGNEM0Vta3RacXpV?=
 =?utf-8?B?cDRTS3YxaWY2MHlQZ055U09uakZ6M3FTVVpkU29SQm9SVjhJUmZxQ3pkZzNE?=
 =?utf-8?B?V1JpZHZLTmFWblJBaUJPMlZiUUxBSTJEOG1ERnlRUnJGTkRtNy9NTXJmbjJL?=
 =?utf-8?B?SCt6bW1STzMzSGdwc1dTMk5NcnZaOU5wV3hrUlhaVFJtdWhKYWw4aTZWRGZK?=
 =?utf-8?B?aXRVNk00SCtrVUtjSGtETHovaEhqNXhhNHFBekR2V0pXdDRHTytZaFpOMGd6?=
 =?utf-8?B?Y3VsVEdyMHJwbmtjdStHbVVKaGY2NGpQM24yOXBsWmFwak8rNXdpVW9rRzkx?=
 =?utf-8?B?cGRUM0plbDhVS20wdkk3c1lPZUQ3MWVETkhHQkxwL2szVlpoeS9LK3Yzc2RQ?=
 =?utf-8?B?anhVdWk5dHhFdmo0QTBTeEpVeXFwS1IzcUVpSXV3NDlzQjZuOTNxWHNucWhi?=
 =?utf-8?B?S2NpZFdCUEpRMVl3UXpZRDk2bHlrWHprdmNmYUQ5VU83YXBGcU1WYmV6Ri9M?=
 =?utf-8?B?N0xpSUYrLzhNbkc5QU8wWExIQ28yR1B1TER1cGFZQUZ1RGRGSEF3aktORVJu?=
 =?utf-8?B?eDJSWVduaVhwL2crd2FmZHJVRU5MMlZOQmpkU2N2UFVybDJuRVRSY0NaTDBo?=
 =?utf-8?B?anBvTGNqQ1RRWXFPSUpodU5EZTF4WXZwVUlYeElESTdjOFgyUTlmZ0RjTVU2?=
 =?utf-8?B?RmhXaktNZ3ZMbFY2L1dPUnhnWmZ5WTBHREZoVHVrckdQQ3BENk4wRU1ZUXBZ?=
 =?utf-8?B?SGVPUXUwR3VzeW5mWkFBS21xZUMyWmpmU1N1U3FQYjhwUmFnUm5pdStHeHpm?=
 =?utf-8?B?M25BTEF4aWgxdHJwMTM1QXlRd1ZPeFB5NkU5VDU0bU43M3dlWFk5TkNIR3Ju?=
 =?utf-8?Q?AcB7roMOiwD1N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk9rYjdpNHRCRlRadXowWEVTd0lTcnU5S0oyVElHejJJcnRJYXlGY2lUN3Yz?=
 =?utf-8?B?aHB6dGJuOUJhU2E3NlBNNUU2dC9pcDdhb3pFSysyS1FBVlNiZnMrUzh2cVJz?=
 =?utf-8?B?eVh5c3FlTW14Z2JzUDFsNmZjbzBwUmwyazhyZHJtU2UzTmNoZzh4THYvSVAw?=
 =?utf-8?B?bHYwajBwbkxiaWdGVnpFYzlBOE9rUnEzVjlLcXdyUENSbjNxVEJCNzBjZDNH?=
 =?utf-8?B?U0UycWs4VmdyZ2FXcDZISElLbnRnODhSMFdSaHBxM01HTzdROHhCVkh6T1NF?=
 =?utf-8?B?UDNPcW13MnZJa3kwdEtBWFZQZUNiRjJoUlA1Rmd6UkREQ2hRSEhuRitoSUZY?=
 =?utf-8?B?d2Q2alBLbGRma2NJenltYys2RWw3SmlLNmNLV1hna2FlTGlXMkpzekZMSVBQ?=
 =?utf-8?B?WkczREI0Rk9mTklCa3V1TUczbTRPdEM4RjlUL3dUK2QrNFNyL0RleDFZem1w?=
 =?utf-8?B?bVhWS280UTdNblVsVlY5ak53MTdqQVJoOFlpRjRoRmh5L2s5OHlUdVdFR2x6?=
 =?utf-8?B?SkVvZWR6ZnZuVzhkWENZQWZPcjBQeVdlaEtkR3k1UU92UUYrQzBJYm1vWllm?=
 =?utf-8?B?WkxKbms5MWgycHpsTDB6WGhKNGxFTkwyY0g3Ny9LUXJXQUpGaXByOVlLa3dY?=
 =?utf-8?B?WVpHT1hIb1RlcVA0a2FvSGs4Wm9sNFpQQzcwUFZDVFhHTWpHWFRmbTJzZ0h3?=
 =?utf-8?B?NXVNNmNKOUR1UWFSV1l3VXQvc00wZHpCMWRxdWVWL0d3ODM5ZjhEVnBDQ1pL?=
 =?utf-8?B?c1pjTmZ0Q0V5VWVQeHoxL3NnNlFEWG5pTFVYK2M2LzY3ekNSajRRTzUzWUdi?=
 =?utf-8?B?WTM4eVF6SGFXcHFtTTA1NnNramRjWWZtSVNxSjBpdjNsQVYyRVNmVlNrNkpS?=
 =?utf-8?B?V3R4WEpMUUJ2amwzMVgzSTFCa3ZCZUtlVjhsOUx3UGovZTRLVTRSZ2JTZHRq?=
 =?utf-8?B?NWpJRkRJSkRkLzJiRWJTem1IbC9aRHF3RjFBa2FYcHdSRkJrZnlxcnFBV3cr?=
 =?utf-8?B?ODNzS2F5MnM0SEF4Mlh1SzV3THlMc1hHSXA0S25mUE9wcWkzSzhpUGNpMnFE?=
 =?utf-8?B?VURRbk90OGJlLzlkQkgzTnhlRStIZnFvUWdDWU44SFhJdC83QVlKaFJKS2ZW?=
 =?utf-8?B?SUh6ZjZHaDZ6RVRYU1ExTjdOTHFCdWxoY2hqYkNxeWo0cWlxK0FxcFE2Zk82?=
 =?utf-8?B?ZWJKMi9IZVlsSTdtTTB2cDVvS3JXSE5tTFpMTzkyQVMrUWRITnNvamM5c3hX?=
 =?utf-8?B?eDFEa1AxcnI2T0xMc0d2SmZQanJVTlV1QXpPZDhYaDN4bUpSdDg0bWJFbEZ5?=
 =?utf-8?B?QU1PNlNGcjdyeDdTbk1Wa0RmTXBJMG1odGtNUjVUV1h2eGVmM2MxMElpVVFa?=
 =?utf-8?B?WWZ3QTVYdmtIZ1lyZ1R4TXI4YVBad2dIdHE4b01zNlFQTFlLc1RKeFQ0WTNy?=
 =?utf-8?B?NDgraXFnRTBaS0F0cWdEZTVYdk5TbEswOWU4VEpDWUhRbC8zSjZha3hVZnNG?=
 =?utf-8?B?TTNzL01OYWEzUDBvWDRYNGI1SmFUakJUOTl0dFpGd0xZNXNuVEI4MHNsajJW?=
 =?utf-8?B?dWYzS2FVeHVsOUQ4V1dBWkVRYWNPZTFEakZ0Z3dnQ0VxM3o2MEZHdjBHaFEr?=
 =?utf-8?B?ZzVyNGNJcVI0UWZaa1Mwb0NCUTYwVjJ1ZmNPeXRpd3NxMWNvSmUvcjZpeGR3?=
 =?utf-8?B?TDIvS2g3OUwwbHBRZU5aL3J2aTZyWHBPQkFpMUhORGJMUXVNTGJBMWV1QVNa?=
 =?utf-8?B?bURkdUtuMXNsV09hL21KQzU2dVNrNEZCN3VrVTdiWUdvRmxzTmMvLzRXRXJu?=
 =?utf-8?B?VkxJYmN4RThKejlyY21kUzB5QTMrYnkzckxIYnpuK2RaVzBpbDhaNGExVk1P?=
 =?utf-8?B?TVFwd3ZEVUFabm5KelJNUnlQTmRoUndJNDFvYVUrMnJFM0ZuVzN5aCtjdnFK?=
 =?utf-8?B?STVpdGtIRGFDL0VUN0V0bWNVZnNCWVVza3RzV3EydlJUeFZ4eStlVytoOEZ5?=
 =?utf-8?B?QlBhYzh2ZEpQOUFmb2ZpQVg4c0JHWGlxaklqTVFoS2cyaDRvMFBSc0x0bjA4?=
 =?utf-8?B?OWNaWE5aNmw1R01UbjIvSUVzNU1sZ29PbS93NmlJaEExQ1VWWkVaN1VkS3VS?=
 =?utf-8?Q?iQBf++5RPQZlXsfy6m4z8jEyY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d728d0b-9604-4065-2152-08dd2e5f244c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 14:33:52.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kSGNcd4KKqxfXjNBpKWtn51pF1t7QFmUyYdh8DRFqdPKN2XUxeENu+PQRQqPslbfJfpLRjujaT9jQFyHl3pvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7563



On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> This is no longer possible, amd_iommu_domain_alloc_paging_flags() is never
> called with dev = NULL from the core code. Similarly
> get_amd_iommu_from_dev() can never be NULL either.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


