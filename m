Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17115FD0E;
	Tue,  7 May 2024 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715090995; cv=fail; b=iG7TONR+ZTJP4QwX0qwo1tnnb4efiwhksWmYUg/R2JR4g/5uHVqj4d70f7nv528Wlz/dTTXo3h6OtCF2B66urS/WEsSjkTo8XaBuAR+5srysHAP+V5qg/5YYE6MtIBkd1K9UvlsX3J6fpK+UeXwsWsyo06TTWVuyVy7NeYUbLbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715090995; c=relaxed/simple;
	bh=fBN6z15drW18wTLDZH8RSoMNipo2bRPdv7w2q/Q4NZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=USBuTsi0nkQiXDaUIncjBF9mB30U4J/nvoj4WgePkTlAZtGlLZGI8BQGwq2lVY/W7HiqwSWoYQ3wMNKf87nZ2WAEkEAJvtfUJeNf0eowpmF3Zw1W7ZvkqHtvWr06VcxzyEG5wpFia/PFVKJ6i92X30FE6QzgbxZRaMrZBd+uJVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Va36nfpO; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Va36nfpO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jk3NASKPPZbMvARJr5WPa8kyBikXDemnIUC6zvqk3vxfxa2g5Lr55mwFJ9rdReglZew2SEVbN/PrZTznDp00De1HuUMR/qejIcT9TIbuTz45q3CszcPZ9/TJux9V83QYZ/LqsjxFeZI23jIbrr1u3Sf6Mg7F/kYZxyufPAAVLMlkzghlg8PhiPe4iwgFhFuh5JtpC8fhx/lafZfw08uyIjPlkiLYNRPc9CU75w9VCdF6oRpHJS+P8KoIrgEbfktwBgvPaJgvMm7qF3AGJ+ZTEUztqiXfOzWtBOtNhuGr5+ncDoN9OHMztMiiqrhSIeJtlgjVSN3Pa7dCQL6Wpd2Pzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgeNMqIJLUfWAViQD7FE8C3qYCPV8YZiXFgqhVKufkk=;
 b=XPO9MRDnMepkil9GIn15miZXRu7HjguT/EcHWbQBqueycjBWxRK8OHzGroHx66i/SNg/aSJgUBz2ojory0fWbVBLIm2kSjzVozMSwEhU05wGh13hKC4o812Pdx0GrVhbpbOJRiPhFBXRSS3YJnj3zEvf0bAKC/jtps7lNVch4SApu1Q4nvuwKF2H89WS5dNZtk9OJREZ4u4xt6yyjtq6zyP9DgjK7xgqwWcxlq7FP/wXl6eCNjwM4gVwxP9yzJz5YncGzhS8ikGtriDBRe2/ocQymsasRTvFr+Q7yaY4+sA216zO1LNHb0m0l3Y9GMc8O7TxUdSisQhBGdV+fyGM2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgeNMqIJLUfWAViQD7FE8C3qYCPV8YZiXFgqhVKufkk=;
 b=Va36nfpOJWZYBll6Srshc5r2K0P+Db/+ZHZKuDhZL3OgpOYjsCnlUXI1kebzQZA5yFC+3wsohTl1wSz9TnsUpYzFTVdPiVTGoH2D0BJdiiE6yWeoxJy0ww3q+4LnIupTgPeD/lNLqRbtEJnOzBJRo2KWRDav+E/NLuJIw3zig0SRvBRCvI/ReEZdRlWrENWri+uRqwIOQPOx41cHEcHFk4b34actwFFr98rR7H5QJOX8IwOiC4KkkMlaVNvTdxQc4vZJDWUSh3Wm65iQ8iQclN4XgMH8K8PANQAEZ43uA5OmjDtrsY8aeXt0+p96H0UMsvt1Si8nD+CPDOLLzzJO9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB9125.namprd12.prod.outlook.com (2603:10b6:510:2f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 14:09:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 14:09:49 +0000
Date: Tue, 7 May 2024 11:09:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240507140946.GO3341011@nvidia.com>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507135817.GA22408@willie-the-truck>
X-ClientProxiedBy: SJ0PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB9125:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1bb5c5-98df-40f4-8f06-08dc6e9f5b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r753vGNWBNXRF0EJqgafWCPvfKToZ9K5hUNCHqJFEwsL0jwHQApwVjmuKIRz?=
 =?us-ascii?Q?qhBkqIkxiaMXhMSA8/6wloq0NKfEL0T1JSu4gYROCPp6WkOa1+pHBYn4QJlG?=
 =?us-ascii?Q?VR1SQyduVIRf+sVv4S6iXHWVkurhFF9XZrF5DEMKCIOKaGY4ggTaYoUuHbdX?=
 =?us-ascii?Q?WsWR2Pbgd97vo8/YqoSctyTC4pykw2JSi0hhIwrRi8KCRazDUW1L0724mS02?=
 =?us-ascii?Q?mDx6gxIvapnTWLpUtAru1CyrLXGvHjQaheNoOeUUnqvwfPkTxmcbg3n6oojk?=
 =?us-ascii?Q?2QENS7HfeqtaFyA66LUC6CrZnWMZDPLOz+ItUU2oGrno0NKReMLgaJgwZjAT?=
 =?us-ascii?Q?fJo8oV9QSHG4JXLRm+OKd/QE8DoXWL9QlSvQVq+OH96AGlzvwrV45sztU7MR?=
 =?us-ascii?Q?ujg+z+n17IUER5+Z+7L5J8tyJ4phsaRzSZNC38XujqK9DDNZxCNpUiDlz4ws?=
 =?us-ascii?Q?P9YeuZbe/m9icxmvgrDF0Hh7RmuSVEH7zS6vBisSfMwxT/0s1HgsPNQ3jnp3?=
 =?us-ascii?Q?3kvfzAaPrGl2NSSyUQifSsDJzJnc5giPH8/0AC4A0b/BhhPVtFgh2Ch8Ozw3?=
 =?us-ascii?Q?Bxfz3ifj1LJe7pW26vAAhJQG5/Bp8Qq69WfMpaG5yvWCc6q8z0dyv2f+NyFU?=
 =?us-ascii?Q?tTiMgWHv1+/ceUQjNmTtwIeEAsqJhZiiVzXH0YAG4bhaGXHc+kBzxGHBnWlX?=
 =?us-ascii?Q?SvL7O3Dn8HNGi6ejmURHNEazzo96WSfA0PIVUs1OmPcWoaPUeA9JgRSVf7N0?=
 =?us-ascii?Q?vrTo/+l+6tgMI43l2QJJondApoNYa2/tCWOc5w+Gdx5sVd6UtZtIGxmF/MTf?=
 =?us-ascii?Q?wKo2ZfAjDHVWbruOifwD7nY2M67R6RACvvVvqQpE+azcMvBICU9X3S/zN4XS?=
 =?us-ascii?Q?97sxqrofC8dhMUpt3XAhUbdNEZCUsK+yMmxBcnyWJp6jROX3YMpzd4tQ84dz?=
 =?us-ascii?Q?VKbGWVtltcnhC+u71SYUGy96dyDDGF5dLJ+8ufa8skUCZpb1Brnb1doYbMsD?=
 =?us-ascii?Q?mQA8stahqhG5DBxr42Te4pP2MFVT13MTFZ0etvY+k4D9k/JWtQ7S3ZopD99Q?=
 =?us-ascii?Q?jx8RBXUr1d7ZzDCHIfJd9Q5GzKO3Sdsfeylz69VJxAbpZwjdh3RcTQeoqukB?=
 =?us-ascii?Q?OgLwu0RqN5bNRl2jZWKUwCm2YZzclLPlFwCMqW5vdUoqKxElXpA6u1Q6Iuvb?=
 =?us-ascii?Q?fxctERe36e9dXUSBe0sQBy5ZHaexa3g8IrMJ469B3qlJnbWcwijzIcW/+QXl?=
 =?us-ascii?Q?5zQYrTSvlEZUoVZOE/ye+cbnTJgJihftOrZZJocIlw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l4oLR9f2nUbemk1OGJ+tv9WYBgOOJoE067VR9pDDP5+z0B3O6c1/8VGoDq2K?=
 =?us-ascii?Q?2Dve3eMmF7rKlLzm04a78OB9D3M7SirxP1BBy0318nhCS4cLjnYIfC7ibIgK?=
 =?us-ascii?Q?jedFKYrn9dAFM4m68VZhOU4Q+xL6lA3v6EzHCZjydZpHQouvSPomug4r2TsD?=
 =?us-ascii?Q?v9sZlBce0TBtXTGgrivgcmfCM+baIVtgxKK/NRQ6uTnfxOfuHhnvhLniqb1c?=
 =?us-ascii?Q?hvKTJ8MG7zEV/jj1QMBXIQ65w1B4oO9jYgoVe+O8+3dcXzBeuE+OS7hf3vhj?=
 =?us-ascii?Q?q2fy6Fa6EqZrV5YXYuguTClYXnPGdz5iXfCJedU+T1sY/9hs38HHLNO4wQXj?=
 =?us-ascii?Q?9DhKocNg89quxkxKbdi5DV3mwgxxfG17IRdpLO6m6OCVaM1uqTxP5vmxJuTA?=
 =?us-ascii?Q?mwBVt8rvSuT1yOQBUtMd2Uf6kTLIDB2tUjOmdTs0aaF9QN5sBi5uHse7XZCZ?=
 =?us-ascii?Q?1qgYhOkkw8nj5+KJewLfGGIX9V13aS0ec8vCMW1J6xY5Cq6P9AF2C4M/7f9V?=
 =?us-ascii?Q?5q4nG0bCMR9EP0MUXkhqx9Fa83X0ZFc8oHkPlgG/duwsKoY6yGCfRbHwALB5?=
 =?us-ascii?Q?1D+RzpW3SsaTOjJOnOEOT6waECvJzApm8r15pJ7Ga+tKqcImf36IXxXy4QK3?=
 =?us-ascii?Q?ZGKif3koBW6OMCjul8XdkNMLhd6++dfPQBLD7T0Fosv/FFgrPUI0KfJ6hfm4?=
 =?us-ascii?Q?1ebgSi9/nA4vOsQVh0/Mhy11HRHUwWIPYIzIlYftHbP/jO6rcQgtOhf/Ochr?=
 =?us-ascii?Q?jIuAylIzamWJ8N2cktR/29zFufOijgRFRIc40x7tzwbgKDt9GwbJPCsuS2zz?=
 =?us-ascii?Q?Ri6RUAI2uQ/4b9ukyPKyFsGPsszJSYOVtIq56PswzkR8g875oMrnHxcpdfz+?=
 =?us-ascii?Q?FihSVNba6nGqTXOcqR3h5ySxMMUgtiX51iLhdgCzvVw2ebSTq4TT0EkvKHOm?=
 =?us-ascii?Q?Yo6Q5XmhKoJqNeLwk/6/WQ7NcffwFKWyJ1AzX9Ne5jJJUyPZcDRMGh+NoXWC?=
 =?us-ascii?Q?+ybtD7yuO9PgXTZ2FvCLjjrVtXj+tRHYZvAPyzKIqlo5veKpaO72RtSxO3oE?=
 =?us-ascii?Q?cuvS6VebZd1I3zHdvQQDpkZbLqnCe2cWmlMkAsB8MUpEBbmvaA4pFX3xvAd9?=
 =?us-ascii?Q?1OZGepoefvhEWRVEWPbsEUNj4cwMTmuWX5ERfxQ3PoPyRKkI/B4wnE9ssgQn?=
 =?us-ascii?Q?xZbPaudZDRkQ7SjMNw5cpaCOEt4KKVxxitmnwjC/OZujnxrvZTo4ibhu2zpy?=
 =?us-ascii?Q?AUluQOkJV2AmQZCujKMsGr3WpOc0Logvg91TLMJNj+A4i8kHlNK/tfD4oAUo?=
 =?us-ascii?Q?wMWDCwjqVRaEfJqRw70h+xsdEOJGAFfSn1yIa+tysYojAOiqsQYcBzRRZJuB?=
 =?us-ascii?Q?xeaLkGhDfAyfuv1Un+tINnWIpYstbwDSEVcYfzTLRCRM/MoITLS7Go6MrRs4?=
 =?us-ascii?Q?mhPN90yNFLWFIIRsREtZavYNGkzA004oIS14KXkVuN4kzr5HDZhEDlD3P8IZ?=
 =?us-ascii?Q?VvwcY67SNK0pvpeBlE1NnRJlA6jZGHErCOsuWjGsMcyVrI/7WZrc7hsDS/Dm?=
 =?us-ascii?Q?HfufGuLGCT6jPLCzGJaLD5HKD3VBJth2j4NcBCpL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1bb5c5-98df-40f4-8f06-08dc6e9f5b3c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 14:09:49.0914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPMxGdcJZIERYBCEePelWAJFRDY780VqEwU/SgEGAWMHX9KFNCpQKmMwqsuRMjCi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9125

On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> > It turns out kconfig has problems ensuring the SMMU module and the KUNIT
> > module are consistently y/m to allow linking. It will permit KUNIT to be a
> > module while SMMU is built in.
> > 
> > Also, Fedora apparently enables kunit on production kernels.
> > 
> > So, put the entire kunit in its own module using the
> > VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
> > vmlinus on Fedora and makes the kconfig work in the normal way. There is
> > no cost if kunit is disabled.
> > 
> > Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
> > Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> > Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/Kconfig                            | 2 +-
> >  drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
> >  5 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > Joerg, can you pick this to solve the linux-next issue for Thorsten?
> > 
> > Thanks,
> > Jason
> > 
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 66325210c8c986..c04584be30893f 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
> >  	  and PRI.
> >  
> >  config ARM_SMMU_V3_KUNIT_TEST
> > -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> >  	depends on KUNIT
> >  	depends on ARM_SMMU_V3_SVA
> >  	default KUNIT_ALL_TESTS
> 
> Would it work to leave this as 'bool' and have something like:
> 
> 	depends on KUNIT=y

Yes, there is a version like this (depends on KUNIT = ARM_SMMU_V3),
but it made kconfig act a little weird and hide the symbols.

> instead? That would be a lot simpler and avoids all the conditional
> symbol exports.

But then Fedora is linking this code into their production kernel
which doesn't seem right.

I avoided doing this from the start because I didn't know about
EXPORT_SYMBOL_IF_KUNIT and didn't want to make it costly.

Jason
