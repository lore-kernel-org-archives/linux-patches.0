Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D926285C96;
	Mon, 16 Jun 2025 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750078148; cv=fail; b=S0LAhT+xd137UpiqtQuXiOhjMuQQA7lqpVQ9FY/Bz32uvQlyiXtbaZ1Se0/VZtkIJz238HlbwiyL/vw+vVTS3v3kCj3DOeNU8vsoom+hHqRvZK18Kb/XmZLzJT81RoOP4+OhYKUXgaEdG3cuWh0lcgxDV0JSbkOtbgT25mbwe74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750078148; c=relaxed/simple;
	bh=WpB2JJuk8U36CqF8hUgcDS7HTC3Z4ddMCfB30HMKw4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LOatrgEVVclAW68dz0uhypvwu5ogeIbUMTpXFOQVgl0CTGq6bYpUrz7qGkEf8OnW+xvtHuqMlD3xiv0V2M/CgDE5CoCaKxQw9htrUBZsSSD+2/ZOdqoly7wiTPjmjB6fyTEDnW8SS6K6aQHrKZkm039NweV8vh+X4D6y5swJzoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CM13yjb5; arc=fail smtp.client-ip=40.107.101.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CM13yjb5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc10IhtdPPGaZprWzQ3RriUN9TVTdaetrKd/J7/z4rus/UOrToUIwGmB6R23VYwOEJbI01VoZrEzKdAbcS3B2+HsEhQSGW+eYnAIrTawrr/1qXTInlwXodxdAlG31L8TkFdOCMMcdl4HYK5LvnQjqhCipno8qwpXJ1EnScJEY8oKPZqtDqGeHDnbe68CdJuTTg0pDKNc8r5go+EUW8lhvENycUNCA8Vq9+zRkJ8WKiJBHLy59oRn3wkCytzBIc3Te01Vk/ueeILvbNqWmyv/FJAC7iXLoMZQDR+yZqpAh0tI/B0F1HBOmX2SLMxmb84kUPM2OuM6HxfoQJc1vw9P2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHWvYN3e4Q8erFib/CqjM/U64fXw6Itk8ZIgHFvrgv0=;
 b=sk7No1WGY7/uEQteVxJk9lbHCDwgNuNVVjrQguj/Ckvimm93vrHlycJ0TMk/1kff3c9H7lNhMWYw1wbJzMCwsqQhF44/zgl8waQbNfjTq8UnWiB37Ou3y5EwLqKFrDznZIj4qAI0390VFNRPFKQFBYcvi5LQJY+AoZkPtMoqUtoUPxz3RO9VzJJgDSAuYFr+BjoH9XrPIYzQYxWXGibdUq5zjQ61Y06Vur5bfPlE/cf5VUkpiw4531LYFlTbGKVTEdsHDY7tmhKJWDUBZ6FAV3Dd/YCZrQog45uY6EtmnNQI8O9kDQFw1KunKLEik5xaBKs1zNv5pM1GyLvW+G+vsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHWvYN3e4Q8erFib/CqjM/U64fXw6Itk8ZIgHFvrgv0=;
 b=CM13yjb5DdYAo9QLYNyjpM+TKQHMclPp5fj6IjFDDs3rsSmv8VEhb+PadiwjGhNWgtQzLc3u4/TAOKm5TvkM4MyCaAR4A9O6+loFuOKUel9ZT/cxqu9nNg38rdpJrdhqF//bdxGYiGIH+FtVQ9Bd6ZghkZ7/bnd0yl+sRjy0FYnJeP22Xnk75q+yuIKARgw7/bJffRACSfcAOm4sEkfJf5Rr5XBMZmGp2O8m8mXtPuTre56RbqEKP93CBXNJFy12ECU92pW7U3NxHK1wBj3XjpehIdskyuQxRW4mpyyC+y8l4bQ+bmZW1U+uRpoMslOHMDDeLdqh7agEhGHivm/PFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 12:49:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:49:04 +0000
Date: Mon, 16 Jun 2025 09:49:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 10/14] iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with
 arm_vsmmu_init
Message-ID: <20250616124901.GZ1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MW4P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 203645b6-2ec0-438f-7089-08ddacd42c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bn3c2HeTvSClo+OK4140Wtm4oEjS7tYgXp86rvq59qKn5EgzBM5cNZR6Ff62?=
 =?us-ascii?Q?p89QmzRbNllDS1ssDCTeOtYxpwRoiF622HyFyXOjWKSG3asQxB8fXL9cNNzp?=
 =?us-ascii?Q?IhF5qgWNxP1MNBuP7SfhTXHy8286x3QLE8vV7iBAXnfDaxEsAny/lY30hUED?=
 =?us-ascii?Q?WutB5soBFkLhd+TBlMHo2D0RBHIf51L980BmWCiI2oRBLkoGdbHXP4UDmvcp?=
 =?us-ascii?Q?RhA0YsYRvl5FV501uSa2pDdhVnyGj/veUnmMQgeZ6AV1VWkvqtFM4bHZeOOA?=
 =?us-ascii?Q?GwxC1BTYNJWCgpY4bxjQybH8J2tPbMRrW+HV+V/GFyoX5iKD/gOZS+/dQWEI?=
 =?us-ascii?Q?Z0QqD9W0scvJY1B3nENjJEn28lf1C++WHDx8QHYuB4AzrGaOc3Enfg+USwg6?=
 =?us-ascii?Q?3FqPvU4sPQD+lvkjlUEzHWmRtn+pLfxD9+321tIVW4WWmlsXmqQiHqP1d4EK?=
 =?us-ascii?Q?RKF3P3KDMG1SluzOWZV70iw3El9zunwgBzNVh/ZAvk8WUvXhJ+M5D0p1aikE?=
 =?us-ascii?Q?8wt5t7vy7fAgIPYC/D0MfDzxbiuxjEcPHik0S1ctfQbGWuKPiB2jmmWLrMN7?=
 =?us-ascii?Q?CWdgDg+bgyp5JHYwfUdFgtlegbZhLSI9UTfsDS9zbPFrKz6/kcQZ/qmSb5fn?=
 =?us-ascii?Q?kiUXNz/7zwx16ZOmuLVMjl83oZKD8hRQctltACmknQAaVBsouqPb7K0jNMWq?=
 =?us-ascii?Q?e2545XVetT/elBcCm5vSghEqDU7gTOxS4YF+IGjmcjmB95k3i80oEcoLD0jw?=
 =?us-ascii?Q?nijH8RFQFejuKj7nmmbaNBkkdjDrsWXDizQnNpBxMZjaMr8ZZgRYcltcUXrC?=
 =?us-ascii?Q?lMEXlvcf3VLWv8zKRlqX1FzLi/6PNxXf5AokF/XIwvRi3VZclUVNm8N0h5va?=
 =?us-ascii?Q?k+OU0sH2e+47SVLC/cF6ql7cPCYDMuRprcZ15ukeZ/Er8o3qRIgCD2DsoE8s?=
 =?us-ascii?Q?dJ/lYtLyFJAx7TzsvmKECqI0ckbqjED0Z4YRgLKTueh/cY7abIOrIgFc5uwY?=
 =?us-ascii?Q?QHkBhie83J5UjdkvZ0p/W+Ub7VqB+7VGtvAwvovCvH8A3jvYht9/U5XpuJZD?=
 =?us-ascii?Q?Ip4aeBbsJzcEvl3SPQ4L7dsmOSAcVt8YOJN0X6Z/+kAq+VANTXqOS+FxHwQp?=
 =?us-ascii?Q?cf+n/MdCht9NWylMBaninMo68Nn7eCEh1qB/Njb0zkw4AVaGHoe/aYc7sGVd?=
 =?us-ascii?Q?2ha4pkzcpIJ121ymzyVJh1C1cnVDdV7EPneBppya7H6ivnEuJy79npJO1aiD?=
 =?us-ascii?Q?8zyfPDPxWxfkwHBRolhSe4OZNewQPAtz2AEt2MEOLk0zbunrvyiTh6okJ4gn?=
 =?us-ascii?Q?7KSBvkAbrwEbVsoyUQ3zJwUpYb/DRU2GO+3DHkbAlW3aGgB1mybgwqNi0+w4?=
 =?us-ascii?Q?jXZaq2vB8SUDSMqV5qYmnWMRKBxo+8EAAr7/eEt+Tm2cAGMlxlA8q3Ec9hkh?=
 =?us-ascii?Q?jN8hBkTMIis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fYAYI8Fd9YWXxl0CejBaciexNWT7y9onU75/0QrlF3kBPQBRuJ5bHndC1844?=
 =?us-ascii?Q?zQIfpOriFTIlAq350Ch6sbs+Ax5qKkbKtSyGI4VJT1vDn7Tuli81BDFSf+E0?=
 =?us-ascii?Q?b+DkbkD0Sg8WB/yzAYWyl4GMdlhStGL2gM8QZnFtB9mtcMzMLhvLmUr6qT99?=
 =?us-ascii?Q?EZyK+EfqETqULEuE4iVdOcYnHURS3XP04rhqoDmYqMMJrxQlOz/seE141LOC?=
 =?us-ascii?Q?IRICl81cEmZaZ5ctpm7n88x6IxJdHoaH0oXxTn2E1OjTQK/ViGfVOAYt7vNe?=
 =?us-ascii?Q?vQjhHVFHE+89RuoRQuV2Z3W+fV4kXdChlSXFIoWOuy8aElLfUvPBp605KAgk?=
 =?us-ascii?Q?fgyZelWwowrYMg5DQ6tVqbmnIE8Y9yvwcH2wYBgZBluHay/d6oEduhwitcEt?=
 =?us-ascii?Q?FXd8sb/49WBIb7i9igbjg+M7DkOQ+neI6eyutNoQpqCNw/yjgP2uDL25HwKa?=
 =?us-ascii?Q?4n/L2kv6jRGlPaQS7Gk7eJ3iVUD4RZfrxbvquaIEej/aNZQ258Q750sjYvCU?=
 =?us-ascii?Q?XgvBXM8BG7cW9OthimdAZx9c5fjKnP6omzalxTxdfZ0bxhV0P2VzWgEA89oW?=
 =?us-ascii?Q?bgxmmJ3qirhzjsf/dxO0YPn7YHpygsEp1STYb5p/fUfI6kJIs4tcS+KC6AlE?=
 =?us-ascii?Q?YDPfeqo/lSOPSmibG4OQdx+ZBHclt1yYvG1a1donh4IFUg0rneObfk64eFvP?=
 =?us-ascii?Q?z7Lm+ggoGHgf22DjyvEt1/p6f6uqho/Lrfy5ZZqrYewiNps0Tj/MQaL1RF6s?=
 =?us-ascii?Q?ETARh8fos33r0QuXAKw87zW4HxFYpmLGsQrsMVb3va4e1I1MziMZ91ewcoex?=
 =?us-ascii?Q?3ixHWdKjNJRzezehsGEReglIv1grOViVW4XbkI0Fg//lrzhDfPJSyU+teLls?=
 =?us-ascii?Q?DotrxDdDYk9njrdHdwGjZpTxtE/tU4EtFK6DrB1BqpIEOYs0ciJCpljVDeQm?=
 =?us-ascii?Q?6nPzbZEHxzAh9TV+mWMsoojAxA3tK3+qFF9ljnI/fk0BD5UaV1XP8t8xI+tK?=
 =?us-ascii?Q?FWo7oVNfRjUe8p9kXbK/FDUU5ofyNbIpd4cGWRksPnW9+9wmzDFvCOCE2l52?=
 =?us-ascii?Q?6DkhOhj9PFcNYei2vWIwnf4mr7UCBfz21ZyZ1YbGcKa2tEHik7OQrT5GFZvJ?=
 =?us-ascii?Q?/kPhLnvYNUIZNTyaFpxB7FtpzI9Ca38LrWYFOnMVDXXh7+jLIWpYr1+uiV6H?=
 =?us-ascii?Q?SlndgG5gJ7Tc4xVMgzxWdwv1YjzKHxs4SesBNYPvFzOqCPkbdHDniNuyJq+X?=
 =?us-ascii?Q?wCD236OBv+GSKdN5vw/X4k0s/bNUHC9B0aMWuA2JHA9jDxNoBi8C2Ci150/7?=
 =?us-ascii?Q?0mY1YMx89h73NEUM+wI0+X87M0OasGkZFWLCjA4NYgmhA/Ds+GBi9Letp86i?=
 =?us-ascii?Q?xlgRuHlJQsRm2BSvWlM+BzluG3I/65W6Ra6d4CavoA7teB1AHx4bCrMPyfkm?=
 =?us-ascii?Q?klNMMvUdx3j9X2k9ysQTf5YVZBFrNHwbrjSdEd2113S0fMtS55WHImKChhbB?=
 =?us-ascii?Q?J9OnyWw97AFT0y9MZr+qJvMR2MH3uGlWbLhkbda/721qJHDfzp7FI523Q9s1?=
 =?us-ascii?Q?ybjkP2mX+8bFwNvpw1FGgiADfNg12HEcnHU5fTZA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 203645b6-2ec0-438f-7089-08ddacd42c6e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:49:03.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnWGFCtJ2h0JDO4zsRKTnjcm+zRyAlZSVA0rF4obBtctoL12sU2VUkZ4bqoS6NVn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295

On Fri, Jun 13, 2025 at 11:35:22PM -0700, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced.
> 
> Sanitize the inputs and report the size of struct arm_vsmmu on success, in
> arm_smmu_get_viommu_size().
> 
> Place the type sanity at the last, becase there will be soon an impl level
> get_viommu_size op, which will require the same sanity tests prior. It can
> simply insert a piece of code in front of the IOMMU_VIOMMU_TYPE_ARM_SMMUV3
> sanity.
> 
> The core will ensure the viommu_type is set to the core vIOMMU object, and
> pass in the same dev pointer, so arm_vsmmu_init() won't need to repeat the
> same sanity tests but to simply init the arm_vsmmu struct.
> 
> Remove the arm_vsmmu_alloc, completing the replacement.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 11 +++--
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 46 ++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +-
>  3 files changed, 32 insertions(+), 28 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
