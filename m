Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37823A1DB;
	Fri, 28 Nov 2025 00:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764288284; cv=fail; b=oiUUZ1fBiOXZLvgfUAPOAaRGKf6mRqValoOGEYBIOHB0W94cj00Z+D6367oVgXBdEAcPm7Ebqdg9ZWnBr/c/oxIp+ZjDo7oYKwt2Nt9hZVc443+XNd9LvSWRH1NzDo3SEVE7fzok57GQkLTCyE09OwjiTALScVvT6F2GvTEL7Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764288284; c=relaxed/simple;
	bh=kFAGk4i+6Bj+3Uj2WbSD2ScZPOhh2glGNaXWCkE8d/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mPd84M3EsCB8v3kajXtV27cbW+gVlpSOkjbXJLwVZXY2yzus7dCq4+SnRcymVsQ/013D0x4YEgmN2XEaeTVOEwPesr5xlvCycTRxTg5WOLWGvwQFCS2nSr7crWKa02eDN3dZQnSuzvRJf2n2WuAQWOnzzgzgvO/ip3A7XltOejY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l+jldegY; arc=fail smtp.client-ip=52.101.56.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l+jldegY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2uVZTpxAXljS+8pYldE4Nf7vlhZsN32YmU2xQYBLL4T5yfn7WUZfGvQu1X5FOvvzUxRcm/QtzoyjZ/3XbH+lAe3jVy/Ydb1c/pyQ0e6QKtbjXCOjWZTjiwbhANm1pGW98L3aHXu9UwitkelWLoYa9J/nTQhKYjwyT9igoWAyVXyC6qU4JrJLlML/X0BmS0v1Ai47W/nC7Zf1yrEI9bW2AOU1GQt8U76KsoHgimnPQO9cHVUuejQYFZIuMsSXFX/Isrpyzigo6QH0a6l91Al0RsAfSxIFG6aScyLABrZUGGKZMeaQiOzD3RP9QMRowNJ1toy78bkFRQU67Uf+3sXzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hVDk3dtuX4weiimIw52gDgRUu/ujlHAA9Fr3VknQPU=;
 b=vmBFgbHvNN3HnhD8ylaMKhip3bEtQI8WC0OnaBD3JCFuqueOhedgLbz8VFPaYsSdl4Fp8ZkbjHsJJMcV8pE6Xv3JDoXJo4DZp3SqHPMo+Y1loMx9uuFpkYC3PNnxkv7KHk+sBIeCtDe5qSpius3YbPH7dtq2qEhzNdzvaA64fbT2qXuxMrH+XgfJvuqVEbWzW6KBqVTQTzBvxdQjRRc0k7CirU6XpQvJt4gHw6gDc6KdOjrk4DPLvz5OGAHqzzYukEBrZ7oL7cYrU5uDTygjusgoE4Oe9RF7ObcpEfaT3YqTbx1GuZVA4GgYg+22o2MtIXIzNgZijn13P1kZqlPHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hVDk3dtuX4weiimIw52gDgRUu/ujlHAA9Fr3VknQPU=;
 b=l+jldegYIYUC5YIDQuKB/JsJPkiegUKMrploe6LImdQ/69LfUIqWtWubWPgDP42aczWRBMt7qXYGEc+doyO4u+1zCOa5OsDJ+Q9mxHL52CkyEzvu3k/9OvbJkP4rfs9aIwe0b1toO/LAKdZMNcTtZPzNpmZbvnd5B7sM5nyqS7akeXNWyD1cipoSP0lHLZQfnZgyxSHB1wl8GXMAnv3GxYT2U409eYDs28HkgtDgbr1R8x1j11hoq+YJRL8Bs/335jaCkufkJkrAguC38oDIzz859l+/BSNDeNpe+GhTA1c73w5TGNFDvPvAgGe55Y4/551N/HFQjZnUjAHLcAs3bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA1PR12MB6797.namprd12.prod.outlook.com (2603:10b6:806:259::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Fri, 28 Nov
 2025 00:04:39 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 00:04:39 +0000
Date: Thu, 27 Nov 2025 20:04:38 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Calvin Owens <calvin@wbinvd.org>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>
Subject: Re: [PATCH 0/2] Fix VT-d when the IOVA limit is small
Message-ID: <20251128000438.GA787428@nvidia.com>
References: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA1PR12MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f43da6d-b5a4-4075-2749-08de2e11b947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fFgvMRbU7kS7i6/0QzoMaRmPbdrl+Q+RLCBv2KuK5wg+IxwJoSdQjY7/zS4F?=
 =?us-ascii?Q?XEYKEmK1qyvrOvddPHhuryb2pC4uFW0c+hWqHOlyv8Z79NGFiyf8WbMOME0V?=
 =?us-ascii?Q?DbNp/CyWeke6IjhX5MpMdR1B3YuL573LRLIJ2vnioL3dENAvK3qmkUOnx61M?=
 =?us-ascii?Q?u/GYb4Izbb9ECF7G/cX6EnTK8aqt9t38WE7FAm2yZtx1nruj3xyuCVsiRqby?=
 =?us-ascii?Q?PcdxpiJ/qPLOeO3RICl1RLf/bucyE7Ez0Q1VTh3gRWkQe+pvlMZsxl7DvATo?=
 =?us-ascii?Q?/Ez5SN0wqDuj2keffhNJXL7CBOfCbtyAiYJ1PIBovXmQKmPfub68QRD067BX?=
 =?us-ascii?Q?oIIrQVTDoRWxtYyTkBsbOWCi7FB4CIVsJwbxmePernfLmXKOZ2St3ya3S1ky?=
 =?us-ascii?Q?TcsWXcbl46yV4DCE3v5lKc3MOaoJzXD0Nu9AvhKGV+oTSLHnuIwR5dxZDK2j?=
 =?us-ascii?Q?/H2UIRJbMWC7Uvo2EMHlfpX7vPkOdtVUpi1OXx3tlPU9vEcvn0930qzgteIm?=
 =?us-ascii?Q?33znaKFhgqT0GIqliU7crvgoSz8YLYciYV0JGo1Zc1UQrqYxijll+s7XFK1q?=
 =?us-ascii?Q?mGcS+C+EYVaetKUHTFmKYbP+6x2xCFsMCf8RHGXcdTzIgESu/5MJsCWvIs9E?=
 =?us-ascii?Q?Xp7Y+TSbKmlz5eAKIhaz2AO5E7wcZlxiarY94IgTcY41hZf6gI0loBdjdTE4?=
 =?us-ascii?Q?ttNaXUS6hyt2ucopFDMxDjxTbnKFGrBwJobptX5Ch55XiogeoSUlBOCBURFp?=
 =?us-ascii?Q?QYs/KzrcdwkfSDMMk+EIlaKGZ0aQ9jTthXidtLV+rO+1FB/N7FXvA+m0OV+J?=
 =?us-ascii?Q?us8pNFLKOny526fAMz/ixxdIZSk3Fwui5iGglDJOPwMTK/3K8JW0V44RKDEX?=
 =?us-ascii?Q?JffUFbUm7gQKxasi/YknvEjhDbuZ3NaEedXJ9+Sid/3Tb5b3tRtCJxBOznil?=
 =?us-ascii?Q?jZ72M6F/8HbBi+vDpOPDpBJ9Ehj0yox8I6ZIEMyHhc41YejxUXc75JBTMRNt?=
 =?us-ascii?Q?WXnDEM7RajeAly3i9h/qpW4Y81MqSgxahhxtqUdcGYAw/28noiQo9KNQafhA?=
 =?us-ascii?Q?0giERpH75GpIkwG6HxYyu8wNBE2xsYUs/UsGJgs7DevTHFLpYJZzI8Uy6IHq?=
 =?us-ascii?Q?GygR4q3H+RvmX864JqYzgs88t2oeUuNBvlJbyRPPQC/CJoIrrnMkJRW7sNdY?=
 =?us-ascii?Q?BF9UMZqi/4QFxQ78+dBnBTB7ZWap8t12t+WvnXKJjk5/ZDfLfD8h96phKGos?=
 =?us-ascii?Q?rvxO1Wx5aWZpHupNfYze7Y+3Pts7Q9OcsdGxim745EteRh3sjy3nltnJw1Sr?=
 =?us-ascii?Q?FGEW+nB0xct0OeA5G/FSuy3hLnAxMHg4iFQZOQEnmGZQ92JywPUM6FVprpJJ?=
 =?us-ascii?Q?jJ4E7d+9HZu2ahvjU6aOpmnNRR8LcTNqhLSAF6CkeLDJpzFzPbnarxmZ1Ss/?=
 =?us-ascii?Q?SFpGqZijY+p41uWVOxpCE9SQ+bWUxKSx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3+CoWkr1hWrnQv7Bz9BBrEOqnpovb7m0B66ezY1pCqTqlWqlfZDOmS4xjQw1?=
 =?us-ascii?Q?0yt3cwcCmda4FSjQeRsr7vgOfJceDAzt+jyxAGQ0zIEqH75iBeXYYX7XyOUJ?=
 =?us-ascii?Q?bSobquqWjQxQmheNExg2Tzw+kdOkQv2vHhVQMaLwZHtM/4jRZBCIlHHyXICc?=
 =?us-ascii?Q?2oOzg7K3W5w9DFIxFe3hkxEld3bMwdfkXg13/+CkBIfTxv4z1CJ+b4EsELoT?=
 =?us-ascii?Q?GqGULAcjYKVEIX7JpxUW2/dsZ9dZ/5wXYzdpf85OiAPfIHzpwtpyeozCf43q?=
 =?us-ascii?Q?YTrDwQBMeokEEdvaB+yBpgy+7KFnk2fp/12C3B186cfGKIjBH4Rkwx1fMrdp?=
 =?us-ascii?Q?+Gj5X4FPLZx78mPlhfttgcCcnTPibQd3dB7jgl6tJwZiYkMGsuaseVoUydMO?=
 =?us-ascii?Q?lshD+D38N8/7OJx0j8NS22di/JV+A36fGLHv/qTqFAASygL2Rvlnpo/rFeo+?=
 =?us-ascii?Q?dYqHlknu0o5O9lEm1VEQIjHo4IMhtI7WnzLVQGYPksnQWqRKER/oMeyWYOaJ?=
 =?us-ascii?Q?KYtHDU9hyIfNQKvTVFuXkxzttkKLGWzZXIPmNEqalIJmwp4HUerfJGtNAwA5?=
 =?us-ascii?Q?N8O6bBS06Wn1n5jsIp/R1iOAYRHhejsCMzOhYGLV4kHRmYLLVZiKs1JlHogP?=
 =?us-ascii?Q?4xLXdZSDTr4l57YFR/7PgdAYTSlUp8oTASvzznzT9HWSTpEvbKLHJhgc+EJX?=
 =?us-ascii?Q?W40fGqwGDRewqxH9I5/QRyPH/2hDDOeSStVhlezRnUDZAG2j34Ho/cJgGqdV?=
 =?us-ascii?Q?IVfaqx93U6Lxi8uc9xQcHllHtDt13iy/XNhXFXI+aPv8mtZ6kbFFDYzH3MOL?=
 =?us-ascii?Q?i0XA9L21MqgaiEgUPu8uMqAkJM7yfl0DG8CNP/ss7ID+SCxDnhbYE88t/hix?=
 =?us-ascii?Q?QIoCxcmzcnW8/4HUCfMi378wsQapb/+93/dHWiftrmM1a3klcyxCjBqEeZLF?=
 =?us-ascii?Q?82c/ofxP8tenCFd5CFBttMYmteIcfPy8dnlL1tfZTP0Xk/+dEvsCX4Z+R2qu?=
 =?us-ascii?Q?Rve4iaTF0wcPstQowrjYfK3+7uOhZYBuFI/tC2QKvqmH5gjKx7PE+L77O1lb?=
 =?us-ascii?Q?E7J7OF06uKkc0PEX9k/na50NtHCorV9nUUuBmapF4JpR6HPJZ+YDYauG89XE?=
 =?us-ascii?Q?0uB6vx4DN+ykK+m80ifdApyryqERpbO/FTqCLwv7HsqOXAjfLajR4Im0Q2SZ?=
 =?us-ascii?Q?G8xRARNlECa1iAuoL45NZHfa7vFN9XcyCnjUkeNTjb3lxQeLmhvTJqA+PsjJ?=
 =?us-ascii?Q?gX48BGq1dKtuW1Aiy+xpyHoYko8VYyUHxOq2RGUJc+4HTAUHbXeUnKRUDKUy?=
 =?us-ascii?Q?6MrZKBRIQQqnTKAyBaoFVXSOUr60EKFxzSEJwzjLpXzBz/oU/kKvueKb/Kcf?=
 =?us-ascii?Q?4ZUw0X2mqtvxTDSu6tOUH/uE3tt+SGzCtmZ623xKOw4iUyiYR4+1DzkNjf5h?=
 =?us-ascii?Q?M0KxF7rNb6G5+TlMknb1Vlj4521dn7/qi2PB7MrvraPfeu450NUuzsz571rA?=
 =?us-ascii?Q?JJgF5rUE/6MPR4zVnx7G8s2Xy6Xxy+pgQgkYURiyRCBqgWCTJa6b+2tZo+Ld?=
 =?us-ascii?Q?zS5ju8URf1k0XfpUadA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f43da6d-b5a4-4075-2749-08de2e11b947
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 00:04:39.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onHJzgqSRjI1z44+0JOkIvhuycBXttlAGpevaknHqvyeOekrgIEsdx5207/ZIU1e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6797

On Thu, Nov 27, 2025 at 07:54:06PM -0400, Jason Gunthorpe wrote:
> Calvin notes:
> 
> =======================
> A Skylake machine has problems with strict translation on next-20251124:
> 
>     pci 0000:06:00.0: Adding to iommu group 18
>     ------------[ cut here ]------------
>     WARNING: drivers/iommu/iommu.c:3055 at iommu_setup_default_domain+0x268/0x2f0, CPU#2: swapper/0/1
>     CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.18.0-rc6-next-20251124 #1 PREEMPTLAZY
>     Hardware name: ASUSTeK COMPUTER INC. WS C246M PRO Series/WS C246M PRO Series, BIOS 6101 06/26/2024
>     RIP: 0010:iommu_setup_default_domain+0x268/0x2f0
>     <snip>
>     Call Trace:
>      <TASK>
>      iommu_device_register+0x126/0x200
>      intel_iommu_init+0x2bf/0x580
>      pci_iommu_init+0xb/0x30
>      do_one_initcall+0xad/0x1c0
>      kernel_init_freeable+0x238/0x290
>      kernel_init+0x16/0x120
>      ret_from_fork+0x1ba/0x1f0
>      ret_from_fork_asm+0x11/0x20
>      </TASK>
>     Kernel panic - not syncing: kernel: panic_on_warn set ...
>     <snip>
>     Dumping ftrace buffer:
>     ---------------------------------
>      2)               |    __iommu_group_set_domain_internal() { /* <-iommu_setup_default_domain+0x25e/0x2f0 */
>      2)               |      __iommu_device_set_domain() { /* <-__iommu_group_set_domain_internal+0x6d/0x140 */
>      2)               |        __iommu_attach_device() { /* <-__iommu_device_set_domain+0x6d/0xb0 */
>      2)               |          intel_iommu_attach_device() { /* <-__iommu_attach_device+0x1f/0xe0 */
>      2)   0.140 us    |            device_block_translation(); /* <-intel_iommu_attach_device+0x19/0x80 ret=0xffffffff81b5e980 */
>      2)               |            paging_domain_compatible() { /* <-intel_iommu_attach_device+0x24/0x80 */
>      2)               |              paging_domain_compatible_second_stage() { /* <-paging_domain_compatible+0x47/0x170 */
>      2)   0.137 us    |                pt_iommu_vtdss_hw_info(); /* <-paging_domain_compatible_second_stage+0x29/0x1a0 ret=0x1 */
>      2)   0.530 us    |              } /* paging_domain_compatible_second_stage ret=-22 */
>      2)   0.907 us    |            } /* paging_domain_compatible ret=-22 */
>      2)   1.653 us    |          } /* intel_iommu_attach_device ret=-22 */
>      2)   2.157 us    |        } /* __iommu_attach_device ret=-22 */
>      2)   2.528 us    |      } /* __iommu_device_set_domain ret=-22 */
>      2)   2.954 us    |    } /* __iommu_group_set_domain_internal ret=-22 */
>     ---------------------------------
>     Rebooting in 10 seconds..
> 
> The failing condition in paging_domain_compatible_second_stage() is:
> 
>     /* Page table level is supported. */
>     if (!(cap_sagaw(iommu->cap) & BIT(pt_info.aw)))
>         return -EINVAL;
> 
> This happens because, for many domains on this machine, MGAW=39 but
> SAGAW=0x04: that claims a 39-bit maximum address width, but also claims
> to only support 48-bit/4-level paging, which seems odd.
> 
> Before the GENERIC_PT rewrite, the kernel only looked at SAGAW, so this
> machine has been happily running for years using 4-level paging.
> 
> Now, the kernel refuses to use 4-level paging because MGAW=39. But SAGAW
> claims not to support anything else, so we hit the -EINVAL case above
> and fail to initialize.
> 
> If I force 4-level paging, everything works. If I force 39-bit/3-level
> paging, nothing works (lots of bad context faults). So it seems like the
> machine really only supports 4-level paging despite the 3-level MGAW.
> =======================
> 
> Which is not a possible condition that was considered when this was
> made. Allow VT-d to pass in the top level of the page table as well as the
> max vasz as seperate things. This lets it setup something compatible with
> the HW.
> 
> This is happening because VT-d doesn't quite fit into the architecture we
> expect on Linux where the IOMMU driver should be reporting its full page
> table capability as an aperture and bus width or addressing limitations
> should be attached to the end point devices as a DMA mask. Instead VT-d is
> putting the device limitations in the iommu as well.
> 
> Jason Gunthorpe (2):
>   iommupt/vtd: Allow VT-d to have a larger table top than the vasz
>     requires
>   iommupt/vtd: Support mgaw's less than a 4 level walk for first stage
> 
>  drivers/iommu/amd/iommu.c             |  7 +++-
>  drivers/iommu/generic_pt/fmt/vtdss.h  | 19 +++------
>  drivers/iommu/generic_pt/fmt/x86_64.h | 17 ++++----
>  drivers/iommu/generic_pt/iommu_pt.h   | 14 +++++++
>  drivers/iommu/intel/iommu.c           | 58 +++++++++++++++++----------
>  include/linux/generic_pt/iommu.h      |  4 ++
>  6 files changed, 73 insertions(+), 46 deletions(-)

I forgot:

Tested-by: Calvin Owens <calvin@wbinvd.org>

Jason
