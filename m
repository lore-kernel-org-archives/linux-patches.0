Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B1285CBA;
	Wed, 24 Sep 2025 21:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758748077; cv=fail; b=oOMEpTYOA4PiVrVl7CZyZY5/TBIzoXL/RT9kkURwtEE1cFXbY8PRhMUtLgdhoK4tYbORbtiIxgmaUExIUGC1RIJrtDVOSHAUPqjSiMmRfayzlvktHINMXq0dlZRVG7lVpmbQln9rOP2+EHbMwUZDqmXhpDUtA2WgdbRU4S3WvYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758748077; c=relaxed/simple;
	bh=+eTfzckjaCfOKS70yBv5yuPAuiuFblCP3Y9XmFi0P3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=stb7N39375tedQhuru321QR/oUmj1hjmRTIyJ5CXwx7FFqLaQOGgnJAR0T21sheWq7q6znR6ODmVGPdXnc/Q87Fdzkk2OhsRSa+5A80fzodulU5Qx/iJ+uOO5vCE4R9mMyJvCvEEigFujgnj/2tmSgEd+sJ40MkjR/WLTweo7io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BxRKS+GU; arc=fail smtp.client-ip=52.101.46.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BxRKS+GU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHeMcREQQn/LseDpFnudHveg/dYf7wbuaozjv8hVpXgMbLYti4CvFfqfCqqOm6hoPoeS1pdKmIEag7Cq7bpWH92VMHGQiLmLq3uh8KU0yZS2Qylix+bHOioXuu51EE1CETE/ZqrnuwlAiqwxaB4u3aMpimJTgJDHcGgd7aNlI3JPs5Bxx5cpHgVPPFcg1x9OQDUqb4brjcWuV19bRN3NbRY4uHIoEweCzwvh87B2jMDBGsVwsFHp2g04JrVnBoVTdyTEIYM9eXeoXJdzLnjC/XHTAZA+CcgohED4fRriyRKy0XQBLn5AOKQXFcgkHywPOX1q/+yyZzSX/hze6zWlAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDTarE8pVVvuHRZU5vW2Hx91+XumeUvu6r+qbYHkjsc=;
 b=K8e6vsNaOhN0gl4wgeuOhb4JyGDHNtAsvkPhRfVdGlu31sTjuA0C1iv09jGclqCZ6nMODSF+s/qaobEH9hxuQs49D7oqhGZHKoiP1Bx+BxyjXp0BVPSMRQx2RafwKyvvFzLkOYoCLu6zILJ2q4uVej74VZxNU04T5lxmpK4aszCyx+n+nUpc3yb0i9/Swnqb2DIxRppsw4RquSZ0DKekGP/EBN+caEdlFcdNxnRmAzLPfll1NWxFACCbc/gQzIyl06Eho9G8ZaUQsvRwZkXg/eTem9j3W/5/u8cibJhzWKEANfv7gJJBXoNYYIHPym0udtJCFdL+VZk+RIjhgbiA9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDTarE8pVVvuHRZU5vW2Hx91+XumeUvu6r+qbYHkjsc=;
 b=BxRKS+GUZNnOmvNXtWh3+tHojLVkDzCfekSzxHUTLNcr2Vfqr4qHYJ7EDA/rRO9W2CAd+J6bf2Ex6G61Bim67OYqGQQRLrMya2Kuzz0YWOFz1BTX2gAeUQ9JwyCGg7kB3+OhHz91wvHnti75sWulaKX1uFdGLVuetbrSTQFa9aN3QOxlh4EPp0rlD4VVoXXZoBK3P/CeY1TBV0X9B7w9NpOqEdZDCEulC24PAOa/GE//1xkXgYhTT9ZtLdI7xHtCXhQ9SctE9sLo0Mq8kTL230ER3C/tcUC2aE77eKBEGt72M9qQL70mLMsFO0Hb6k9abZy2+U7sD1o2qmPgt7O4fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 21:07:53 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Wed, 24 Sep 2025
 21:07:53 +0000
Date: Wed, 24 Sep 2025 18:07:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 2/8] iommu/arm-smmu-v3: Explicitly set
 smmu_domain->stage for SVA
Message-ID: <20250924210751.GN2617119@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <390fe709e756a54168fcd43e1323998456f2d8d5.1757373449.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SN4PR0501CA0035.namprd05.prod.outlook.com
 (2603:10b6:803:40::48) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ba2b07-1112-4749-345d-08ddfbae6cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?radWk59chdu5AoFfURMlb+5foO9m64LuMrtbCdRW/PooeUu3hjZCmADSVFdd?=
 =?us-ascii?Q?MO2G8qOFuoAYZVv4g0ysx8iZ+g622kz0jQCQv2rER4OjImXWXqkZ27yguco0?=
 =?us-ascii?Q?kADo9VC+nBSUFuZ8JePd/x57x3lRepoZb8hE6bVNSyCSO0FAItgOvYFq7Z1t?=
 =?us-ascii?Q?blVt3aHbfBasFQntlVyVkzZq/5YDPhz8tnFtrgJdBFxWRlKkN0WIiFAXD19N?=
 =?us-ascii?Q?R8jYHNJ/bfW6CjWku+GtVarfahANWt4+dGJOnnGSzIBeE7fmS0pVDSjw6P9x?=
 =?us-ascii?Q?7plQtCqE6IdAW0fXab1le3Hqrghlhp6u5hBHky33aBQlfgq09emiO3jFSP9G?=
 =?us-ascii?Q?gyFJKUFQA9W1OAwjbqEgWvCljxMUiwb6KjG6gCGnr20BbLm/MvuJdK2Pr2d1?=
 =?us-ascii?Q?Gp48g043DdX4fC+hcevV4vHc4B+9rY5nMO3QjeDgTcP2djrLvs+sQJ8LJSdN?=
 =?us-ascii?Q?jiObWDp7r7pf/s2eJcCkzbHF7YYbPksrG+HmSEfZV0Y5iBViYpi/Z70sCanq?=
 =?us-ascii?Q?qgyhoQ/rS9qNc0o2iR0gHIxuWUiwmmadAx4nSkJle/JqSgBEoUBWFyfklxfN?=
 =?us-ascii?Q?gGpNeWaVf7FlTFFVI+y8xnzPUVwYcudTDJCGywq7iR+p3MApNQT0WXln3qvm?=
 =?us-ascii?Q?gOdXEcg4QwBCNszoYRjUlpJFSl4/Nlja8PEDC4Wgn+4HTJBr21UTy6mFmhq5?=
 =?us-ascii?Q?nNzWyQi+mCTY3/U4Az5I37ykFhGkSWUwHbR1UW0TIaNg5J+LPkzIps5n1u/5?=
 =?us-ascii?Q?x9kixeezk3taHqBXM/Z3pawYZTVs7FTkjRItXoOk0ucT2TmowWGGk0yFr13q?=
 =?us-ascii?Q?YxTp2wgvvO2/Lft62t6SwKavZGwhGhKTUnivDy1xd0gLionS/ZEvha4Sm2q4?=
 =?us-ascii?Q?KZblpYOEMSqTxSVsc9Yyu3r4HCXiAOZfneWNJA9dPdrW99sE1GY3U4IbQrdC?=
 =?us-ascii?Q?zMh2DQUCXaKXTrvruf3REkxXJW2fFgcUZlRdYOkgjio6C9mMc7XZSQvXsGCC?=
 =?us-ascii?Q?lRnNy9c9KUo6o2Xk7KmzPFTbUkarA54lJQWJyVkpcN3jrwZmoHwQz4JYcyt+?=
 =?us-ascii?Q?KrLgSPzPUSyVXFcp7+NN8+tgY96ysp7OFBya75Wpdg+pkb8pTc1P5Xz2qIYM?=
 =?us-ascii?Q?SQoZAo0vZFKJGEh4JYsIzibrhp0v/Ss9QcDaIxREEomZA9meF7Z1NeajCRnF?=
 =?us-ascii?Q?3mUB/wZpCef1Y3Fd5pT9E0AY/B2ufzaXHfv/adBc31FEbxLJZ0VzYPWh6+Vb?=
 =?us-ascii?Q?13B7QwM4WKWVlT3nPrHznw4OBK5xT5HE6Wi3aliC0Ko2x/Yq8UA52BcLQnRG?=
 =?us-ascii?Q?nRbhSuiS7qr60ie9ZPbv7BNbP5HtVXOwke5yvz9JQpNIeVYALWnKYxcRFtur?=
 =?us-ascii?Q?x6wJH5qyQ/WlGw+AtbZMTQt900gIMmhSyRoOsp/7Kd804vhpgjl2eITAMEYE?=
 =?us-ascii?Q?74UyeBrLrTo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w/aJOK9Dm+9eDDwAs5nikhXZ20oKQCd55snRuinltw++EWPY2gVjze374N7I?=
 =?us-ascii?Q?Bf5m0nvs4yfmdWbYRuhsg+wRvEbL7EsMDldaIbIQ4DbSn8ZT67J6oHRLvDdB?=
 =?us-ascii?Q?joO3S7Wogngde4z1DM9EbFvlfF6wamfY/mhziqIEJjtqWHoaKDa+Kbu9AEON?=
 =?us-ascii?Q?6eqG57VIp8OUdOaVCzroc8x+/Xggl+yqGtl3iY9usGuAcmzUNvJ5KdJ7zb+L?=
 =?us-ascii?Q?hY8WvK4pX28zWuNoT0jbzsuIgYQxwxknvbbd+BpoGaH7yh+3CJ386CMGctuf?=
 =?us-ascii?Q?YhtMY4k+dluVZBAOAW/jFDica+m+SEisqlGCGb/3OnhKKQJ5Xv+YOn9HpwOZ?=
 =?us-ascii?Q?Yd3lO5Xz16euoBcs/3Iq2Lkt6bhj8FEhLw0xk0IOo1o/LxkbIzSKmIT4pGXX?=
 =?us-ascii?Q?XGWDZ7n2zly3Neqsv2Yn2fXtZMmpYTZD/QVZY9KLGRj8zYjL6MFFyZDqppg+?=
 =?us-ascii?Q?UHisOE0GOKTM4xA6HVzWtLegebjRT01BcbkRV0DPAsbvi0N4B6ZUDhK3ymND?=
 =?us-ascii?Q?nVzgcoUy8rclwXxq/lv2glrp/AMSWPJHEKoXIevxM6K9qzSwJLigT96H7EDN?=
 =?us-ascii?Q?Na/yaDhABAL6/uEJiepp397kza8CqoCoRPgsaCGQzE2M4/Lb1Kdya3CzavyC?=
 =?us-ascii?Q?9rPQOZZi6jiKZodQX/04v5By9Lxlufa7hq/l7Qmp6SFkEhqdXpbJFJzvzlqj?=
 =?us-ascii?Q?RaYsJwkzh8o+obZd3COkvGPZLlnikMqGYUfpsfni0kYv5f8kdgXSrGqWZV8W?=
 =?us-ascii?Q?7YpX7NwS/KxsxfHOiM8fQF8MDeg1mTv7AMTjb0p2ozXcdy80Nuo1RBTEunU5?=
 =?us-ascii?Q?4YDMakgoISzDeZRml3sPpA2x/xrGVM7q++Ksqc0cQ3x00xzFboASCMCXCjVe?=
 =?us-ascii?Q?pw5gw6et4qVURCVTcdmJIP4ay1f9aKHR4CAGuQ/zdGo+ALoKtCjWeI4WDFpI?=
 =?us-ascii?Q?QiY86whM275byZQhuoK6c6L0j66VESKdIhWnIdVNyirt+1HGOY7C60k9dxlZ?=
 =?us-ascii?Q?zht6MQx3G4X/tSiavIvPDsAZm1c7SkbGwKGeD4g1247J/lgMVf+wBQ3NFGRh?=
 =?us-ascii?Q?EyQSxBMjgDx/uZuJna4XEKnqiAn1ym4fzb2d9ypKKpgXTFZptlmmFWrTysJ5?=
 =?us-ascii?Q?DNee8K2eXr1IKI5vczjT26EFq2T0WQPX/N5HHgqfxuZyPsFVXUgeJClAtviy?=
 =?us-ascii?Q?OzfWc4LGXcopbHrbzzToZpniIGjdvMTaNuQa9Mjz2D+JikI300P0rDSe38nJ?=
 =?us-ascii?Q?CX8vq/HMcRGo8YXswiue77NsGOrEDlsA5gv+UqKSVX1mdzsBHv5b1zXN3Q60?=
 =?us-ascii?Q?MtPLqs2Nx4s8BBGTZwg2a1KKeiNb+AfCK5t3BydEHlooZc3/dKuMbcxOsAdg?=
 =?us-ascii?Q?6hOppF/3b8pkv4zGaBqLUCidwb9Cfz09ts2UzXWhMCpBG89VkJB+2dMPTQFt?=
 =?us-ascii?Q?FAEGNb8KDYZS9lrKBM03yBU5lUzfJgHXuELP+X+m//TQdArJBFnFsOqhD+P/?=
 =?us-ascii?Q?XpkyzbLw/N4BO1Q5jDjau8qbgdB7fL7TpOR09p4XDxymMxSg6n05w5LpT7gB?=
 =?us-ascii?Q?vll6R6/Ucovw6lWqkjcz4Hj9DMlaCtybQmVShtOE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ba2b07-1112-4749-345d-08ddfbae6cf5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:07:52.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpuKPGodgO91RjX05mLVp5b8fdJqbXZYGozeSVwN3v2Xnc8oic+3jF3pyb2PgLQn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284

On Mon, Sep 08, 2025 at 04:26:56PM -0700, Nicolin Chen wrote:
> Both the ARM_SMMU_DOMAIN_S1 case and the SVA case use ASID, requiring ASID
> based invalidation commands to flush the TLB.
> 
> Define an ARM_SMMU_DOMAIN_SVA to make the SVA case clear to share the same
> path with the ARM_SMMU_DOMAIN_S1 case, which will be a part of the routine
> to build a new per-domain invalidation array.
> 
> There is no function change.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 3 +++
>  3 files changed, 5 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
