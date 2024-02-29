Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F6C4AEF6;
	Thu, 29 Feb 2024 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709222383; cv=fail; b=aZNayRVGrZqbwsQ6tZZ+eqDxUj7Axb3W4OucukWwLmQBv/uzOom6AnhZJZQndTS3vHnHVvZkRYcckivGDZdDhj8rpZ7KeZzZmjo3NVRR0uTgqSNcQguQevvMolSyedlpfBCef8ghxaMpWvvDTbNElc+magouFYlenJpLX2O/pHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709222383; c=relaxed/simple;
	bh=0tGacLkHZf5R5GmoVSuF+iCuO8yl7w8uOqgrppah1I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QSum9RpnCbdoDaRmxACLd0QGXpVpAQ3PrXYchc8fGWbPA3BLGHw7ElTXssmRx7UAE4Ovmb/STvgeCdtBuYwsF75qhKdZcPgMnQPUwBll+p2AJSXDrbVrZxzcpo3o8PR7X3Mk8VVaVl8tOPbide8dfljgu/2geoHE2vRwarBuTEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A8UwpQuK; arc=fail smtp.client-ip=40.107.95.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A8UwpQuK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm2CN2GVHDJAbpbfu0IyAeL+YhhtIe8LcCRWRZPrSj+fSaNtlQAlrI4VB0I+kTxwx/G6fbKOxyTXLj4cctsFxVxa8XFs487Xh+acnv7iesy1HYnOsDIID7pWebbqdYCoEEFRsJUUYyHAaAJedCNgzYdtBG2e5iuP5IEV7K6Iu+ItZjwnvhbCWbBvyOSJvrCtbzvoXNTYLeGYeWFK1z2qakJMpVxgdZ/a/hlkCMG9u5tTdCT61i8MCYhI1kkLkFePjMwlN2GVp40WR9EHty+8RmX1XOSndr+i/eoEYn+mcQZ/YMEHlb/UyMA5shGvcWry+J3UM5hwS9ME4jm9bEU8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WvpBa8OFaIXQZA+liVBs+VB/yo8eOKXiJPLsX26HAY=;
 b=L5SxZv+QSg4+eeccbffRvTtVaiXZoJLICqGmzysMyipL3z3mNiNBNKcQeuFM/JQ6xJ70q3MKSIk9dfjWPOR9UUIFEWmd8aCLeJCwS5jRxvrjybJT4I/+W7XB3+yowNGqF+L8zwBaco2pBUtuQ3r/sjAPpNtQ9kJ534hho3K873d4/deccVDA1jAYcScBGumgApSFB1FNuJ0ejJOJX+iHeEL/1Xh59nV49GYTxRsHFtitQyregeCPqtAzGw6H4FSBAejSI1PVYUBz7ETza43v4Lwu2qMhd9uPIZEatm706uYIUnSuslQiNx58krqREDA8VTxMop/6jV3hTTmckEFVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WvpBa8OFaIXQZA+liVBs+VB/yo8eOKXiJPLsX26HAY=;
 b=A8UwpQuKy+I3h4Gubk336Owjt/ZW+IOk+xwGVGBAsLCv+crNmMmA0s1qp+MPGDERpGeKQkAO0c0jIughhnjqPyW4h18O0H1JOKhHue0Ih6AplDA/+I6izW4fjTX8rFRqkBSmHgpf8QO+hjjJcfNLUt3/AfCjw7JA71Y/NPYP89nqHg+x/woPdSjdqK7SLp1tOj7TDJL3Fab6cGO2X9CxxMvMkhRuIAQfyC+5yvid+SSL+ADjm0ZmCoHjixbh0UT5d9Za6PnLTbSl3QZXyOB4zoHqLq13TRXAfSHEmBKdWD7L+AnhmfqcflE8IY1arzLQHJhPh0pr7jYX/jk6cvFXWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB8077.namprd12.prod.outlook.com (2603:10b6:208:3f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 15:59:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 15:59:38 +0000
Date: Thu, 29 Feb 2024 11:59:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommufd/selftest: Don't check map/unmap pairing with
 HUGE_PAGES
Message-ID: <20240229155937.GA57929@nvidia.com>
References: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:207:3d::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: c51bfdab-21d3-4afe-5288-08dc393f6f05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IVqbJiGSvWRrtT9SP9y1nU1SINoUZY2K+tM/yRqrgMuoP/HUOZQt7kwQa1cre6ghhsycn9KgIFvQAUngEJtbegbVbQ3g3EuEJD05/zjRo3Fp84cYmMvP2zIIowjE2YZh0+QG+5UOOb87ebM51n2SOCOA4ZoNosmFoQA2eI0dOifV8Vo1GOeIwCLyuPMi1haGbz1FVklUmzlV/7piiqU4zbFPGm8BibzcHAlfWvS0490BWS9zI8Oe/lm3A08/tuDQ7wv/GrpuKBSZzGoNwTocJJkZnALkepDYkBQlHu9YF5aIUnHfWxg8QqxN9jJOhxJeZ+Nzy+PIL2O+TIK5/TAXVKFI20gyBujOj7Mydk02jXbXXCncwWhqYVEu/r97cR3sHIrRukwOx5xOhxu+p55lulLatA0t/i/qomFsXyrqguIx1j1zZwEIz6QIPLZdeogDG3wjEXdEsFFPFLjbY9cIynkJjpRrxI9qhjr8r3e4zFDAbKEkH+64TXDLF6Qmoe/g3nhA82/bIGKJh1tgiydHA1WTKBaMabXJrFhz+g3E5crM1XvQorqmtUfvI8rphOs3yvZuBRfmPQWd9Ay7HZSdlMZyu6kpWbkTlcRYkyJoJa/ac+BFycY1XVReBVnLuxBz1w20hDGwQDu9gJOcLovdSA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XPob1VLOoJlqIvJQD4zD0YtysjLemqqegYvLf8Tcu9oU8t0HGVNbUB7X8mWs?=
 =?us-ascii?Q?76VVDdjgOE/culoTaEGsykNMBTEkLv6Y/9Xa8LyIoPm4oV3WfP8hDAqHp56x?=
 =?us-ascii?Q?SL1qaSU+1UIqNml53e7AdYbfUqe7McIQki839TbljcOh/h+3cI5f3PH4NP7u?=
 =?us-ascii?Q?u3SKsBRigMnLaOfp4T03MjgthMJvU1rQPXkRmP8clyUs598Uk5f7haGHLN4V?=
 =?us-ascii?Q?upvw8jrNHy9TVl+wel9InyfPQzEaEkQQGvT5EUzvuBsHi9KyH1+liiwf2nXt?=
 =?us-ascii?Q?qEJuC8QYlhg20F3WZTeLzQK1Of/25tV/fTlyJ1VTBUb7PKeTQF5y1ftl0y9b?=
 =?us-ascii?Q?OHSiNX+P9bYXcCTHLO3MLo5Ek3XJZd8ybDO8+7b7LBpsqHhcdjkE4h2KVG+C?=
 =?us-ascii?Q?4sW1p96ql5qgITEgOSpXjPsVTskyI1XA/Rap/ista93vnS1gpEMeUX+06oAX?=
 =?us-ascii?Q?nrqsqb0Vjo7hGXEuA86acSUIA41oygqUykX2PkI80RI6+T/ZWTzr+VTWFkBm?=
 =?us-ascii?Q?BzeGDtmoM+a7Is3cDD0cAGbsYvrLLIsMSWF91OMe+tDmKwfWCXNYp3qcI0eK?=
 =?us-ascii?Q?qEbpDm/Gs7wNpfG4BDcQUUJ873dLw6UWNWW6Bk+1xla2EjQztl5XvFAfHOm+?=
 =?us-ascii?Q?btSXTuU1k+qICgyi/wVY25ysT3Rxgl89/Dmv/pK//yECRzexCv3frtzAkkA/?=
 =?us-ascii?Q?d3Mlymf9wwk87io4Wdtyc2wKLA/CyXx56oZDzeFV254/GxhNtsEA4sGQ1iUm?=
 =?us-ascii?Q?AWLW2T+BgV5qm3d9+rJmjPPr1flVkcsCfZr9uN4O2NF+Kaee12eRhJCplpIT?=
 =?us-ascii?Q?tJnHdai6/Z2qdcWy2pVBHmR0l90ZVJEYGJDIgjOOVZhoP487ywUVUO5GD36H?=
 =?us-ascii?Q?3lXSXLpMmoQ/zydsp3qXWMGuZtMKhfe1CUgWdoFuxjCPHegqRzf0JAiiqFuc?=
 =?us-ascii?Q?OYN5D8+fgfEMSklpZLJoUrKeN552ewqSyunbgl/das3UEu6VDiZNx2G56lap?=
 =?us-ascii?Q?H6ubKSeDRHz2s/c5+1afRNsQeT23DVKfgvo+8XQq77gt285UguW5dHDCpZzx?=
 =?us-ascii?Q?X+k6Z9dLv2gxRjLSOgcodmZA6TZwRm7XT4E/x2WJWI+UhKpmVQMOHERxBBke?=
 =?us-ascii?Q?vtq1IldE3fhh+7jzD6ROE1qPwCWY7ntIjQRNaou8Pwd4HpFhRdYZTfz7y3jT?=
 =?us-ascii?Q?24Qlh+bYxkuHXoL196cO8MFanetj8drzm3Q9JmhP8ppBcbWFJSaAdXiX53Nc?=
 =?us-ascii?Q?VKq4DMVL3YSP1sD+LzDri+eRlPNklhbCaZ+WjEpDQ8AxHvAyMnGdigJ6xff6?=
 =?us-ascii?Q?SV9TxZ9dzxyyZagkHUevUM/TrcEsJccA7lN5VFYFQG80b/pQgbWnQLa7NiYC?=
 =?us-ascii?Q?Xb9nxmgpCmycSz6WmNtJZIpCWub/ig49hdqux+S9JUu3Jdbh9WsImSQ9M33O?=
 =?us-ascii?Q?ocq5qgREe3P62UncidRfxoM79sXALOiLxzeRx2W583Rw2ctoVmfyCkaIMGp8?=
 =?us-ascii?Q?yRObXi1HX+9eqCCDNnMxYFEB7IJteT3+Yzu4lhmnnv2Nl9hNm08nlyR25+V4?=
 =?us-ascii?Q?EZYfztmUxfht46L3SjuJkc2r8W00Zqwz2vb3yN75?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51bfdab-21d3-4afe-5288-08dc393f6f05
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 15:59:38.9157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hb2wPe1JM0PQM92mCG5jdYfwuteXhopvfVDb147qBMe70qcug9jQdSJAHI3jNEWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8077

On Fri, Feb 23, 2024 at 02:44:08PM -0400, Jason Gunthorpe wrote:
> Since MOCK_HUGE_PAGE_SIZE was introduced it allows the core code to invoke
> mock with large page sizes. This confuses the validation logic that checks
> that map/unmap are paired.
> 
> This is because the page size computed for map is based on the physical
> address and in many cases will always be the base page size, however the
> entire range generated by iommufd will be be passed to map.
> 
> Randomly iommufd can see small groups of physically contiguous pages,
> (say 8k aligned and grouped together), but that group crosses a huge page
> boundary. The map side will observe this as a contiguous run and mark it
> accordingly, but there is a chance the unmap side will end up terminating
> interior huge pages in the middle of that group and trigger a validation
> failure. Meaning the validation only works if the core code passes the
> iova/length directly from iommufd to mock.
> 
> syzkaller randomly hits this with failures like:
> 
>   WARNING: CPU: 0 PID: 11568 at drivers/iommu/iommufd/selftest.c:461 mock_domain_unmap_pages+0x1c0/0x250
>   Modules linked in:
>   CPU: 0 PID: 11568 Comm: syz-executor.0 Not tainted 6.8.0-rc3+ #4
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
>   RIP: 0010:mock_domain_unmap_pages+0x1c0/0x250
>   Code: 2b e8 94 37 0f ff 48 d1 eb 31 ff 48 b8 00 00 00 00 00 00 20 00 48 21 c3 48 89 de e8 aa 32 0f ff 48 85 db 75 07 e8 70 37 0f ff <0f> 0b e8 69 37 0f ff 31 f6 31 ff e8 90 32 0f ff e8 5b 37 0f ff 4c
>   RSP: 0018:ffff88800e707490 EFLAGS: 00010293
>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822dfae6
>   RDX: ffff88800cf86400 RSI: ffffffff822dfaf0 RDI: 0000000000000007
>   RBP: ffff88800e7074d8 R08: 0000000000000000 R09: ffffed1001167c90
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000001500000
>   R13: 0000000000083000 R14: 0000000000000001 R15: 0000000000000800
>   FS:  0000555556048480(0000) GS:ffff88806d400000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000001b2dc23000 CR3: 0000000008cbb000 CR4: 0000000000350eb0
>   Call Trace:
>    <TASK>
>    __iommu_unmap+0x281/0x520
>    iommu_unmap+0xc9/0x180
>    iopt_area_unmap_domain_range+0x1b1/0x290
>    iopt_area_unpin_domain+0x590/0x800
>    __iopt_area_unfill_domain+0x22e/0x650
>    iopt_area_unfill_domain+0x47/0x60
>    iopt_unfill_domain+0x187/0x590
>    iopt_table_remove_domain+0x267/0x2d0
>    iommufd_hwpt_paging_destroy+0x1f1/0x370
>    iommufd_object_remove+0x2a3/0x490
>    iommufd_device_detach+0x23a/0x2c0
>    iommufd_selftest_destroy+0x7a/0xf0
>    iommufd_fops_release+0x1d3/0x340
>    __fput+0x272/0xb50
>    __fput_sync+0x4b/0x60
>    __x64_sys_close+0x8b/0x110
>    do_syscall_64+0x71/0x140
>    entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> Do the simple thing and just disable the validation when the huge page
> tests are being run.
> 
> Fixes: 7db521e23fe9 ("iommufd/selftest: Hugepage mock domain support")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)

Applied to for-rc, thanks

Jason
