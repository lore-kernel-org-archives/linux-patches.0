Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B04122DF85;
	Fri, 22 Aug 2025 21:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897206; cv=fail; b=mQRy4FW+YlFugU1HZwsSB7oozrrAfxTyWihSJr0yiJiie2xYdu2CMYLtmf4TIrUipxqBWP39QNaqTK5A+MBZZE1+A70fE/hnaqO7ZgFJ02G3+Z6xjMYuk8tVSfvWHNGh3lQbcbNk+4AUeLmgkswu1FtHEIWGjCvcUW/RpWiyekw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897206; c=relaxed/simple;
	bh=PmH6okbBCGPzzZoSNEzPCKwWILJDzjxwtTd76XQ0qY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k7TWCIotQwTsn4EaLdN19237QpXr/SLXTwjgbJ87uiiqbL3J5otVzkBVviR9S2DfN9hAFNHVkoUG089Xw+Q0l0N4su161Zy4cTBRbR5qXMleBcuhqHl+PhczbcOaS46aMd4fhSjE17Fj0YWCOB3vv5BXwdu3R6BVBc2rKnAE5Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q2c8ybJd; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q2c8ybJd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuzgb1DyyCrAoeR1pGw3GtlHMkjLnTUxfNVkfTjTo56tWIrjE6niSGrjP41BKhOIYf45Ra5dIHGDwYUsRKfc8ob4XJXjhkmLVrQuAhw2yUiqYMm8R5FngJnaZvyBier82WHt0+up3EiUcfxjI8Giij2ZcWJeRzp/Vyt3AHmt7uS0DKCkkpfJC53TnmCAJWTP9a/HUGk6yqyCvdi+2xOx4/PMVF6uDZx5yWFz+C4N/Mdj6dIYlEDyBUh5dcnAnHy3GAl6PQzdiD7apDyg3KQlnwHh319VE6MnjXLdIMsMv2fX5bC/GQDW/SExxhCCKFOd4wjHeoguVnt/MH8Ql37m+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlySCN+FjYH6WV/UsAJF/5aR/fBFyLWc1GLwsWFlm+0=;
 b=PB2IHP6+LLCqELTDyHmIHPkFmisxJDIpc1apTK2tMX9Btw0xYvhrgCQ6oThRlMzF0RsRsxEi9wF7rd8mEOiv/StZ4aKmCYJr/KqAa70Rwl1Fg0R9qd2oCfe+BGKCr8jO9CtknWuml4u2pRHdkV1Kh9SllrjDGjj0eMhVDMNXtsUQUIZLDgW7POyMNkXV9Vt53oiBbYvzNDfS//BsbUuFY8vQGgdE6sFDRCj1pM3ecIQUc7HUpfAJ9qGRAFBOJwm9ZP0vRC1Uz1mUj3XYTHrIKVaehdHX7ArTR8TS21fsiqymMIFP4bzZtlmzkBfeH5EDAEp1dLXeoR3UEOzHTLrukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlySCN+FjYH6WV/UsAJF/5aR/fBFyLWc1GLwsWFlm+0=;
 b=Q2c8ybJdy4ZmepLzxX5mm7wLfbdgDf8hxgCEeIwnPpKPqFwb3Li3xfnqLdSVC57hF9392xWoBLl1647Qa+mHzXatQEfxHpBIV+fRmZpyUt2IatVRDiwvLf4Xu1ZIhvNsuSgz8RU6edyKptgy31kryYvx2kSx8lyohiUtzoUBz+AEf2Z2UN2RL3GHUnh/UzD0zacvtBbdHt2slOBUbu+Wfp9HPfa9zlKFNdMBl1mIN2v10yp4QfWdTVGP7BZWrlG10ju+lzkj03Bs3am4bnyHSvO9xJp3Jr9jXK9qe7tI8wGIyEj0a8s99BMpSDnMPeMi1P0MW1UdmmS7a2lMdLwAkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 21:13:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 21:13:19 +0000
Date: Fri, 22 Aug 2025 18:13:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
Message-ID: <20250822211317.GE1405994@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB5276865229DD850CFA873B448C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276865229DD850CFA873B448C34A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:208:52d::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: 968b8078-fc95-426d-3ab3-08dde1c0b7c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1oz7NXF9cif2bo4n1mSau7WLRG1uRlT6Asr1t5vbHIYVoeUmuy7qcKCxOqHY?=
 =?us-ascii?Q?8TAjXyqWdWG7pYRxORi492mCE/Dz2scbO2duf0PhfbgGGdYFLLPbNGqvVE8D?=
 =?us-ascii?Q?ClYLjOiflj8t35Vda++K8JwQZB/3MW/WviG55jHyElaDXA5cm6ZwqTbOUBxn?=
 =?us-ascii?Q?8h2ivHtuEl5XdzfbCkM16AasLEzd/dUvZ5YRc+pYtWGdjP2CDVH+CCjAIWFJ?=
 =?us-ascii?Q?zG4I4cHcFnHhh7NDUI+7PEKH1HAj+SBgLyeWzFyGzm5D8w94KpY1ut9ApWPu?=
 =?us-ascii?Q?DJAFqlJkPK5U3GXsCPQ1Xrn17ztbk+8yqivwteSejHLpBRZH0S33gOvoga0d?=
 =?us-ascii?Q?K3R6L1h9Li3/lhc799nydYxRILRkJ+n33Jguzv44tFHNQjkMdiqpWpg2kDdR?=
 =?us-ascii?Q?zjuaKmWVmSqej2UMSoQXBzevK+tn7sg7mo49xFIyYhoW7Zg3P47UkBoZQJIo?=
 =?us-ascii?Q?RV4Re5rNNttWrPYj984NvCCTTp2F6R4CkcP7rqtKT5ojLR0H3pujARf6Z5GJ?=
 =?us-ascii?Q?IGl4N9fKdJ4/WUYBG/5lCCJl6XwOqvnydlOe5/85R8WPdDzhAz21Ak+0PXJG?=
 =?us-ascii?Q?5yXLhDsF74K/On4o6w60P+hx8Dr+oY12yiGS1JaB76cnT71uD4eQCWjbp7Vb?=
 =?us-ascii?Q?H8VMsiDUZxM6JT3hDfNgP2UVWrHJyzlQSQ3nE7fN0dLPOJ2jzMXdV+X00shP?=
 =?us-ascii?Q?7V439TjZUC6h+NNzV/sA+ptX4XuoTJuYUC1OJzxDTk0INQYij9fKV+05ugLc?=
 =?us-ascii?Q?WiZvFG9oONni++f0fMDIxrkc4hYyG3OMBowA+Mf4hks/QqWExJiRG30+Y7io?=
 =?us-ascii?Q?/2OzdTQ8BK+Hpzdei7p8XTNeaukts7NaRiOEN0BIkUeouZ18T4YRmJOr7N9G?=
 =?us-ascii?Q?IXx8zz8RK4t2NrKXRv49z0WzE4gi9/ZmdCYfT6qKeSMgMHCDK1z2zRv8sw32?=
 =?us-ascii?Q?KL6+Z/X2qLuVlZ7znceaYYGq6finu8L4AuKRaHOzijtOwQel2nenYTpIf/93?=
 =?us-ascii?Q?BvD9scmwVLI7zLWXYEKEThr1cZpSvVds3SwTkhSkf+Xpd+LDGvoMQyrSm0z8?=
 =?us-ascii?Q?VfD+gaQCBh5dDhHHeG47BkDnKsQSRmZJgKrdtYo/MguEAsqt926UGDgjrTr+?=
 =?us-ascii?Q?xlu9KNoMWwrw9jsKKOXECg6x/v/Nw8ddpI5pbmGcqWW3zhKGL047tD1d3+zF?=
 =?us-ascii?Q?LB6DUWY5jUehTId6urSrbxhuEhfc4Ee3fSynIZJXzUGBvB9tsPd5aZbYg+CM?=
 =?us-ascii?Q?8A3oNs1WqGxLQ0ejMyiyN8ie3p2xY8k0vUioaxoLjZ/p5Q50th29U+qlcbR3?=
 =?us-ascii?Q?Q1UovOiGy212EM2b0eYJAANJhw+OgIzbagqDQUSac5AjQLBgxd0klFdVkImx?=
 =?us-ascii?Q?IM6ukGnJzZMfpjH+NExbELq0aMfxGTnha82hleYW++7xavZmMXjwb+N0z5vc?=
 =?us-ascii?Q?xs25bhdWWbg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rt7kDWZwCk4QKCRyvcZerZGzaLhfT8BnFG5RtgDPcPYKvz7hgoq9bJ1thKBM?=
 =?us-ascii?Q?7s21BaxwHHqxFVlXPJjDeLmxMWgIAnd1RYbdONJDJMjzP9MGtyf1lpKFzDbs?=
 =?us-ascii?Q?g6cbiWpvRUAlc0H1eY/8qOaoSKP9Q9TD9XCy0ez2VRDcvjdh62D017PLxbgb?=
 =?us-ascii?Q?bKsHviORjU4EEZwnDgh2fBUDUgBM5cuPmoejJoNDDg+sqePXvUe+eumxeOj6?=
 =?us-ascii?Q?TNgoXIIxilHu40Vc/nPR+91cXgZrmMCiVyJ0TcF28e+y6Q8b+N3th2tfXsVf?=
 =?us-ascii?Q?LkEA2p5hOZg6JqKtMAKKC7kQuFgAoA5iZn2480Xjx9E3CWAL0lSdC6N8ZxkP?=
 =?us-ascii?Q?F8YhMPs/xDdh/N5dIXUYXQ+SwFVvp3D9NkxnzarcPUPUmGEnLsTevAKiUrZn?=
 =?us-ascii?Q?PY+Sfwjn5xcpmFPsiISjyEKEakhntM8oFr/FMxAoXbCXbsQCuWfdjq+j37SC?=
 =?us-ascii?Q?Ie7/8oXsNTKqqFilE1itcgltuY8qQ1qFKt33TXLCRPp8OYNoS1kcDaeuvs3K?=
 =?us-ascii?Q?6Ok5aUHVUFEP/2T2ecphniMcpwqzQUmFKM3X5YdXCIM/rE6fU7k7KPHo3n7e?=
 =?us-ascii?Q?T9jUUnWYIwb0lbXdJxVOkhOhrQ4L7O6+RDDWVmDPoIDCX/a4tcpXDjbe/0of?=
 =?us-ascii?Q?jD99yCvPfbF/FVl+1X4dAiwqOh506YxANtrh+V71rkxZ7xz0APhSZwWrZwJp?=
 =?us-ascii?Q?ik5WszwwOA9512S6MCgU5BiLcS78v0ovUVDgErRD+W95ahoypFtt2BOCXUTa?=
 =?us-ascii?Q?0SjptuNEDOzqCmYuDyRj4Cau6X1oP6non9kFx2JzB7pFqwnvk/38/8KR6Uy8?=
 =?us-ascii?Q?RBwAm9+69Whie3bQ2iKPOVMm3ySs/dj5LMr5Wq5+15u5UsA9d3uVWQoDCQf6?=
 =?us-ascii?Q?/lkA/IxMsWldf7mAUrRw/lNq/ScTFXbWH/hjnIPg7Z4ju2KMVXiL9B74d7Jg?=
 =?us-ascii?Q?JOOcRuCe7Kg1PP5ooOaX/opoShJHE2ookHQIr/qCzQStR/wLDG3bIEC5MHsz?=
 =?us-ascii?Q?Tqk3zCWcmRSvOZy9nZAC110XWsU6rXSIZFrtHim6357VkDQtDgI+2w+qqVR1?=
 =?us-ascii?Q?aWQCoQJlkoAyw+Wf+zZtBXDGBUZc9+xeAKbclWemfXjxAXjcGaNTfpZZmmR9?=
 =?us-ascii?Q?N7fYPS5bSnsvdHswkj0WQm+BmhtuRi3A+9aTAzylygJFiS0+wr7JAm1GL3zb?=
 =?us-ascii?Q?wZGttLHSxtfJoHjqTV1kHwnHN9UDJEF2ZQMFguRfpSgAW8dMp/zTsFkARoPP?=
 =?us-ascii?Q?z7pW95djh0V9jI6BCsCCyNm2MzdShBiNZObn9jmAoZI9vbQCJEwZ9v4BHDsl?=
 =?us-ascii?Q?ExBRTcqm1TfgD7XMcZcXOgPm2qt/09nqd27V+FazSozvLdvxLt4PK7oZ7yO5?=
 =?us-ascii?Q?4PDQrYPDB6UUivsCT65CrOEk6lATsneY8EZztLOojRX8YT+ManFv7A4Fzqbp?=
 =?us-ascii?Q?Hd0w1B7y1VdR3SvPBZNA3ZSSUexAG3jQfwn5+pYJqBjGo/PvjT2D92o9rkPe?=
 =?us-ascii?Q?rFYxLCgRqcG6kdCUC8lNufeUHW6hGJm/nvb6ZUg44p9z2V0VpEGSghJUnzqU?=
 =?us-ascii?Q?ZScW51IENFutgEFrs2MkIcMbL3SIv1A+SpzWtYb2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968b8078-fc95-426d-3ab3-08dde1c0b7c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:13:19.1705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rc8Kj0E531psEYdBJW8/hWl/xbCYIBzYFjDxHM94Pqol2JWFV9maLQ7x0ySx8D8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798

On Fri, Aug 15, 2025 at 11:28:06AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > 
> > @@ -82,6 +92,9 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
> >  	struct folio *folio = ioptdesc_folio(iopt);
> >  	const unsigned long pgcnt = 1UL << folio_order(folio);
> > 
> > +	if (!IS_ENABLED(CONFIG_X86))
> > +		WARN_ON_ONCE(iopt->incoherent);
> > +
> 
> a comment is welcomed here.

How about this instead:

-       if (!IS_ENABLED(CONFIG_X86))
+       if (IOMMU_PAGES_USE_DMA_API)
                WARN_ON_ONCE(iopt->incoherent);

And all the other CONFIG_X86 removed

> > +/**
> > + * iommu_pages_start_incoherent - Setup the page for cache incoherent
> > operation
> > + * @virt: The page to setup
> > + * @dma_dev: The iommu device
> > + *
> > + * For incoherent memory we use the DMA API to manage the cache
> > flushing. This
> > + * is a lot of complexity compared to just calling
> > arch_sync_dma_for_device(),
> > + * but it is what the existing ARM iommu drivers have been doing. This
> > keeps
> > + * track of the dma map inside the ioptdesc so that error paths are simple
> > for
> > + * the caller.
> > + */
> 
> also talk about the x86 specific case.

/**
 * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
 * @virt: The page to setup
 * @dma_dev: The iommu device
 *
 * For incoherent memory this will use the DMA API to manage the cache flushing
 * on some arches. This is a lot of complexity compared to just calling
 * arch_sync_dma_for_device(), but it is what the existing ARM iommu drivers
 * have been doing. The DMA API requires keeping track of the DMA map and
 * freeing it when required. This keeps track of the dma map inside the ioptdesc
 * so that error paths are simple for the caller.
 */

> > +int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
> > +				      struct device *dma_dev)
> > +{
> > +	struct ioptdesc *cur;
> > +	int ret;
> > +
> > +	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
> > +		if (cur->incoherent)
> > +			continue;
> 
> Is it a valid case to have the caller pass in a page which is already
> made incoherent?

I think no, I made it into a warn_on and will find out :)

> If yes the current definition of start/stop is not strictly no par, as
> there is no record whether item->incoherent is set in this start
> call or left over from previous call in a failure path. Then the caller
> just passes in the same list to stop to cleanup which reverts all
> items with incoherent in the list i.e. more that what a failed start
> may change.

But this would still be desired because the point of stop is
basically to prepare to free the list. It is structured like this
because we have to pass in the struct device * to call the DMA API..

Thanks,
Jason
