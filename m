Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B541DE2DF;
	Wed, 11 Dec 2024 18:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940856; cv=fail; b=gZ8GqFiM8mduwc64XKydoZH7k1U2Mx/bCjYqmPQgZqJLkk8O7v7xL6ZcnzuYWok9rb1VokY7p93vMpa27G6DM8EKWytBOUmypl0v0looFoI8imF0OGREGdMGUxUbKHBiWEwIglmrVbZoYL2OuoWXhIOlhhYb/0F4pVy7O6dzvIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940856; c=relaxed/simple;
	bh=ipY6d/MeMtHv0OS0vcp7o+NcihavJLSjRQDyWRRYTds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H/sGlX7WZtxIaHrgrarv8hm08AkbbiwrnqjRhVOO9lCxrRKFCvuUonGZmcCNmN3MuvZ0l8QElrGFgZy56f4AbGXzmwvBoNWvVAR3K2qUGm7vOkySNredmJZ7ISg0T/59HnTWGniVEKueV9iw3x8wWMuR7H+158A5AkT+G+HMf4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qOovLhuy; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qOovLhuy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XIf++1kA0UuTK9IGOlACzE+FVGvg4Hc88+koArjejrHZ66pNVwisk3UUG1C2M7vqeuKLZuQac+6xF5r6VqCwQsi4N4Hx87AGp3tSB2+HgHPiT9tDakbUcXW3f37TMiG4eG1JWP2TSllhpnQRTsYNhgEmUQ6mKSFncknyTlWtiPx3WanLCzJy1/tWTYP9Y2xbApjLCAMKc6vFeTFGa6Y/fx+WMiLcDh6DJWEeHlJmH+GrlOhMHAXQlYHDomtZqpBVaWJH+jgi3aJ+wdhCn8X72MviUMNp81UB2WzssngmeeLQoIY7Wv2UoI67FoUxKaORH+PrO2zU6PNUYsZb/NOmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wreZdiUpL3gzKyVr1Riwn62duxMT+QOgI1O39D4e9NE=;
 b=CO+3pUpXJTZ2IrNfhHQf/rbqkdc2MdQ8uzCKx2usY2dshLlBxv67HvZCHbNHTqlhIRFyDyvFzn6mGotyNqofn5AfELGW3fRdbDGpLKlTxQkCiebzzOBdkxL3le8XhdLhnSL1tW+ZxSWVlLUOWiuLL88bQ2Nw32yAQiVk7mFCqgg2I7G2cf+eCShZErLSUHLWAt12U/TPbRd9ozM2onFEt36MwBrdOFbAOJXv9d6C5E3PQxNhs+mhvaL+3Elh2FA9MtSs4CsgvxD0v0Y1cIOOJQsWILrINBwHZZQH4Dl6zIpyeopPy4I6bTRGYaW8vEd/6e1FUuohEuoD++3hXlxX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wreZdiUpL3gzKyVr1Riwn62duxMT+QOgI1O39D4e9NE=;
 b=qOovLhuy1l9+dDraOh8zGbxG3+JJ9fHnOBG5qc55myRHZTOZVfufvNtRZChdKiz5jIvIobm9eN3Y9lTDOsLbg0AazVLs1z246Q/gDvCKxOtwGofVKcL4Pb6x+0bKEovUm9hBz9y1S2PUnlYRC2aK3egdWMRkkDDkpe1y/KIxLh4ChbBpvwTcKmfxXRIsif03guuUK25f81Q1RX23VRkUxPO8OvlMzF0B04tTTl0rFN2B+V110D/ZVTUMUgrP27mwXSYRQUWXePy6ZZxrrLXNrai9yiPIM2zgcmnL5ekaLPfk9cXjbqLGLV934kMdfHbrpySh5IoqNSSFYGW/bG/JFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Wed, 11 Dec
 2024 18:14:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 18:14:10 +0000
Date: Wed, 11 Dec 2024 14:14:09 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH] iommufd/selftest: Remove domain_alloc_paging()
Message-ID: <20241211181409.GA2463293@nvidia.com>
References: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
X-ClientProxiedBy: BN1PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:408:e2::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: 72594de9-8642-46f3-fcec-08dd1a0f9c55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uZqz9odRFawjAPw0SpKq271wBl7QHq7dubGgAIg4523w/a0e4QBwGIar2FPr?=
 =?us-ascii?Q?DTOcHbVXOozMtai74C009iFUygMHRWRWgGjp1K5BVme1+0maWs+xjhzVPCwc?=
 =?us-ascii?Q?M3T4pDWDImyliAbvUwB8KhGpn6dO7jQnx3hTIfzNLJkmYPwtupWqdFKHXAyU?=
 =?us-ascii?Q?kKi87m2CJWQo+51JV/qFffZY/zs/xUxtLKR2UljM5729T1KQxilc17zVug7j?=
 =?us-ascii?Q?wSqvRE03zJNSao3TKf6gVklvtOXPxmbzyU+dwqxioV5H8aV5nNZ2j1VO0zJv?=
 =?us-ascii?Q?g178ZITC3YwxzeLVkyEpQYY0KNyBi9MnJZ+nUem8h6/HhZELtApT8KYldg8A?=
 =?us-ascii?Q?rAegMWmN3puOX29sYoprSyRbIFHOMnx8kVU3Ia/H34C8Vkdag4sZ2pR5hZhu?=
 =?us-ascii?Q?g/8uzvUsWotBCNr8D0UToQgE2uitQSYb6Th4znRPfczkx//zNG4hF/+9bsEg?=
 =?us-ascii?Q?3B7Ad52fFljUU/xAMkpK6d8YoKY0NqKfg1ALmWFaAd/yMLRKFoMuLsuZUlKX?=
 =?us-ascii?Q?AfgoxEAvDGS4mZPD8m/bgGa7S84LgtQvdGXAWFb+U7WvGdE4eX35USa+g4ow?=
 =?us-ascii?Q?qmz1ONxxmF+0Cmf9kDE+ir5Dxn5qILRMoqOipmQszou7QInv3rP6kbxkTJ60?=
 =?us-ascii?Q?yIA2RCYkuXtGsAt3BbGyN0ywU5WH+JLEYH40PWCgZpywShehe4mISwCjn+/x?=
 =?us-ascii?Q?N4LDVezGdBOeh8R1O5Uznoi+guLfGNg5MPKh+nlpi+5SRkvhZnOdt/G2kb1M?=
 =?us-ascii?Q?BAWqxtXZSwS3XgulJB8MzU3tXb/MQQ1mHNGoNsG/Ki5dcAZoac34CC44IHNL?=
 =?us-ascii?Q?v3ce7LT3RG+sQlBf+X2I+2xd0pawoSWtCtwAZF4OdO0OVQf6RKXa7Wff6pYc?=
 =?us-ascii?Q?8MLKRQvCjXPRKVIgou5ODQ2laoDBO1FG5cRVlWU1SoV7QZyeIkZ0KEphN/3r?=
 =?us-ascii?Q?pVPDMfbzTz5E5VBnJa8eirQW+ZPMWA01jxVdDphcJnvIJH6vclt8sARvf2iV?=
 =?us-ascii?Q?nNw10UCPzJ9qnQaopgExTV6O70dP4omdGMBUGbs9/da1G6zW54kgvRNJ2Pd7?=
 =?us-ascii?Q?04DWGGsZrIAm5PRujHTluINH0im9Vh++wjEpv4UFF6MKPVosTS93i+GaOVWP?=
 =?us-ascii?Q?QUEqFF6MPFkGnY+fQcm3hWugMPPEiCBAovqTwfpjQc2NFibVk2HQO68busDK?=
 =?us-ascii?Q?Ub/bZ1Fm1NQ6R54kQE/mZ+1EuTkKMDaQv90Zm21AnEqHUWhNQdJCHTaYiV2z?=
 =?us-ascii?Q?3hoZl4Lc+BmR2vOkh/H/uy6+Lvhrnhz1LoO+W28HKkC1IG+loPgwrTQ+bHyL?=
 =?us-ascii?Q?skqWnTTM3BHj68M1tQa/3lAINON+wf6t/4GyB7E9queT5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rbOROwzB4wlnwZ6bn/Crp9mOcMmImVX8POukdXAhZ5Jt7OTnWDtlz3sDZJXw?=
 =?us-ascii?Q?5ty218lISgF2hkS+6AQUxYF+9Lv7L5HntvMHFCVrPOSdEFM8c6vwo8fQC8jl?=
 =?us-ascii?Q?Rh9wCN9vBpimZSyxgCv823tHdtIZErVg+ROwSum64HPSy+BFEMuyP5VoI84E?=
 =?us-ascii?Q?GhUlQS+qxkb2jYWJs2Ie5WvSNQa23dVwTaGo/NP/sRY6Kt7uBCC8ZBvK/u1g?=
 =?us-ascii?Q?X8868E44JqKnQYfaXa0Iw781te8icBFq01IxuGOcCrU/j4ehtuVYm7LHBe4Y?=
 =?us-ascii?Q?riltA8Nj6X2fE1LJFAoEsvAHcpSqrUGa/cHy9GTNe+WCgJd7aIwyWT4YNEjM?=
 =?us-ascii?Q?dX90jKiES1rX2tJPixtOsbmhZ4ENCuY9NigAFrssmp/4NdECKPrCIEAxaLSB?=
 =?us-ascii?Q?x/hIkY/IIFppIguI+o2NOJ7hoN+2BGC6IfO3ikObCHjCPiuWWjLwj8Qg6EHP?=
 =?us-ascii?Q?0tg2PINnT8+42iU66Z4nRI2sRNoVRvUnQnmhoQibaw9RbM703yogexSnoFoP?=
 =?us-ascii?Q?4PP02ZCNx1BbBScnvmHIW2fcrpHNGwORqF4F/xuKbMANRAolz9Bjb8fqSV+4?=
 =?us-ascii?Q?hY/WYeMLp4K4UTxvlipQeBKURrEv/ArO20UZPBWlRO6IGwGptSr3mRnK2cnS?=
 =?us-ascii?Q?1xdkghOZGl0EgDxC512RZEDD23Y+p6jeifHUSg4WVFWUl4v7bB6RN28px7UQ?=
 =?us-ascii?Q?hbXF3dS++Bcts4ajsFid/biVsqa52oW/kVUsH06SYPE5wNbljqt/sU/B5rKe?=
 =?us-ascii?Q?Q4vant7mjzDkQ+POudVRiiTDHrsWQWyCDS7WSATlJBGKCPYhZlwdxND5P1TW?=
 =?us-ascii?Q?xHXIeEDg+oYOhgATTcIQ3ZFzTuqIfTUDSwUoV+xNnLxMG55XM+OK46/qyTKB?=
 =?us-ascii?Q?LMpoz2GqtzWx0Btq36/6AMK0CieYSO6BXw9An35U5VxZTZd1ynPgAdUwPEOE?=
 =?us-ascii?Q?zfwnMeW0/TSye3A/J001ZC9DtWsuL0wdPpAwCLRc3mbss6kfQswtnZ5cxBB5?=
 =?us-ascii?Q?DrPhrMw7NUbH5qOmvmdc/RzWrnlUFu9eSVCZAZ+yj6QLpAqoEeyL2iH/ELRY?=
 =?us-ascii?Q?ze0vhzKGUwI08xL/gEuOncv7hKtZz4mm21EYN+pKF/3hg6ZbjT3ylgTv9+Du?=
 =?us-ascii?Q?ZSmEbawujHBJBTmijRQ6IWZDuBnHro3gbUXH0FQkmT30MwNxuo75z7s40LaW?=
 =?us-ascii?Q?i6mfvVMVwsXfHfyB6hnMkhpVpfaA4rUTlTDI/80i0Zu4eY7nzjO5lXaSUUG7?=
 =?us-ascii?Q?gi3vm1MBB2VNL3gRyfRntzCq0pi7jaTLr0/83uzNaWTTpfLlvt/9m9iAl8wv?=
 =?us-ascii?Q?KqKYDKjCXx3whF0CZgflGChZOLUYhrYtrPdM6TxervyvXJjko5bH9FK5kDbs?=
 =?us-ascii?Q?ipMqbjuNqHcNuPVFxfUt4KLqxIQKjHboKNh6qtXpVG78ROVQnEo4sBB/wT4c?=
 =?us-ascii?Q?gQ5qpyP2BYAib8HqvhlET0SZIL5vKw/m8CGe4kqIzhH2bcwqlKonLACxW8vn?=
 =?us-ascii?Q?46b9U+qz+UV7F7Pph1aS3aEHdHi7aWOEiQMSMX9p1QorCDeh215Er7Sf53Jf?=
 =?us-ascii?Q?Jh+H3RQqqS2JERAlhDVRPS14TcUpk8+npB+1WQy7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72594de9-8642-46f3-fcec-08dd1a0f9c55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 18:14:10.7452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hm3PmW+sxWQXQ2tFnLgPyKSTAxLwSmoTPzGy10+QsQGdpdGTaO+4wrpyCn8rQOwX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555

On Wed, Dec 04, 2024 at 04:13:39PM -0400, Jason Gunthorpe wrote:
> Since this implements domain_alloc_paging_flags() it only needs one
> op. Fold mock_domain_alloc_paging() into mock_domain_alloc_paging_flags().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/selftest.c | 43 ++++++++++++--------------------
>  1 file changed, 16 insertions(+), 27 deletions(-)

Applied to iommufd for-next thanks

Jason
