Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29AE125B2;
	Tue, 29 Jul 2025 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753828366; cv=fail; b=hA38GkP59M99FnaVZ2CbPNnbpfB7hE2ohbRowPpOaTlIF7HdOlKXwz2wOfxI9A76sim4HtWFCb3vtH5qB4NpQ1tOAYJ9Zy8KjBx1BcNCu/5CnwO9DMCnSZ2tQwCE9ev5BUrTJHzFP3dJwUETbAx4zuIf1wh++2k5aA8jMhqEAuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753828366; c=relaxed/simple;
	bh=22KQ0uip53TXswxcCujpKT5+cMRzt/ajrfH4HjamFVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eebsCORLCke2yhuOnfb2Iri1FaoiBDeBVZGCC2HqX0JTH4WSFq/b0sqY6nQRN4WcorRKeuc+rHd0G5kFhN2oKHonntDT1+oUSkUaBxKy6y/wIbbnzE4CsMJgHoJWs3I5pkgJ/vSstyAf/PXSpfR0vswGNkOe4nkqIS38uOpjhVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gg0lbIpq; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gg0lbIpq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywfewiquUReGlELgoGBNNM2Ewp2GdiQIcblbDzUG8n88vwdY8Dc2YGDe6CRcz82CdGJjhE66nJIOPmIjMYS6A1RQSd1sXO+dSnB5jJl1P7HP9Nbj0v/32PkzwoXWO2s6hcGFX5Ajk/ZTcI11burxXRrpQ+TocHLTihsiTuYeMxzBtuY5i5GLYXpzBJWO+7JDG4Ins3v8kE5W21l8CVhiRKV7lXA+HHwexUxBI1CNMTfSA//4+wH2YkfJrpizmOxqgTxoh/ql32ikLC/LSJQO9FB6I/7uUUl5nIYrH+F8qSE44F6SUCgjPngjo6kbXydHuexwZXj5yYei9XNU2TAhmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fekyo60JRYuYpwsWKvMyoy6pK72zCU9o1mawPoCoiUM=;
 b=yYSEyT83cvpA8KHSfMfbQcGrDA/dZJL2HDJ9teearJs+BDYTeIKjQgSmmFYVSzL86XWYTp9sCKlbKuZWkM2AK5p7a+xFJnX8qsWhmsEARDPU2pGD7GJfC32TiN5hfAuTmS9L0Vm8w3YM7+q62T/lnOAcuvuOThNR4WbWtKLK6Qm9yxJ2hDn0kUIKWVOfYRLGbT5XT1tbvYHFh9+bczkM4UmUyPfAdiYC8D0/+8HPAr4WXMczrQd4SfODFhtPmslsCjaGuCUZkrNc7EkIRC2Bnq/3LGcpQkD50lhAKmMXfBBqi9sLtvV5GmRCv9by6oZS1NOkWJxuR87/QKE5+EtfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fekyo60JRYuYpwsWKvMyoy6pK72zCU9o1mawPoCoiUM=;
 b=Gg0lbIpqlFE1irWmNrFE4iH45UQO0DIG0r12CYJfL4lGIjEbxjoYpSdHhDUwI9RqHIkFRToHAWfyM1c065uLBCoD/HQx0itiO+zhfpxZUONinbMRfrqueIqNgUTQ2XxQq8qzRsLOtsLptU/cptfL3nlFwD69eWmzwR4lTbfeBElQe4PaxIJ+Inn9zOygt4fsfKS/TUMw3XFxxBc07nE0EZgHp5BJVwT4PNkRFQ07uXUgsmtbFlRVD6glJQLun0qFX5LnKF2dvYKZEfz82IFZgiPu3z1qaozCp/I7OWNsVkZqt0INtNrZmpWVaGtLkYckoimrprZy5qQSzAlAQ2Zm+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 22:32:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 22:32:41 +0000
Date: Tue, 29 Jul 2025 19:32:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page
 walker
Message-ID: <20250729223240.GC82395@nvidia.com>
References: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <00c5972b-a5d9-4604-aea6-cc0d8e2601a0@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c5972b-a5d9-4604-aea6-cc0d8e2601a0@linux.intel.com>
X-ClientProxiedBy: MN2PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:208:fc::38) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 70bd91df-dd12-49ae-a6d1-08ddceefd41c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AAdYnxMSrvSElwuxXC1ppNh3Yd1crOsAtnU+8+YohHlGf/BVrRO+UwcSwDd8?=
 =?us-ascii?Q?/wGfCXtzyykzS453VNDzlXJydgM3YLme3XDPXQqlOQ7xpnSoxYf3mH+azeA+?=
 =?us-ascii?Q?WzNm/U4YT/JbgZItgPzBMIEycXw0n/qKEGoFPevB+GjEDjfy2VBZWHAlZmNg?=
 =?us-ascii?Q?XY8HKX3kFFAOqenn++U6JxkiFzlk6Xfq+b1Zu+ZCCckx9FU3WttLff7vyXT+?=
 =?us-ascii?Q?igkCWsdr0Qn6QSJroutcUMgX7iNiRWz68efzRgA+MFbaU677UoErpPgttOjI?=
 =?us-ascii?Q?zn9NPY2h3ZgPkzOcmyODwqK0XjukgE4T9NNZw+kaqXs5G0yXcO83n5fZgpud?=
 =?us-ascii?Q?RQv+tlY0WgB1/Y3ik9BCQCL1+Hgq4kCz6c5EFLsOq5WgLG1RYefz3JDrqOsq?=
 =?us-ascii?Q?7mWNvEU/O3m5O0nKEvqM5oM0vuDYF0AZuK5CTmgiBMogBHA/pJTiBL3L+DkJ?=
 =?us-ascii?Q?AopVYK0VIJtTyrym49a5LKFFEih52OBJlYroJvtD6xbmM0b4WupClJkHSM0r?=
 =?us-ascii?Q?wrP1SbO53uGwIfBsmt5UjGWEOm/3ZXGPo3YNNBP7XCfrF+vpS3HP2UNtjJ0R?=
 =?us-ascii?Q?gT7rRQtUJGpbqV4OMn2ib61rqW7o2gFGEUEy1TCdMRi/Q1i3SSy4IEi0vEwm?=
 =?us-ascii?Q?78kjImO4EWqWrw5jWoE5wJ+lB8Igj7GQyyFLTTXyiNKoA2nL/V4Nk9F1zVYs?=
 =?us-ascii?Q?+dbqbZzlMJsnQIYV0dIfUTjyOP889VnOm9UlWNOnOKJth5fMr70+F0c7z3TJ?=
 =?us-ascii?Q?CvTlf8TEa8G99bVumtwiNq682H6VYcwxFwYD73AsRi0W7qMMPjE9h5hbbvua?=
 =?us-ascii?Q?m+rwwUIgZScjuqwq6xPkTrpmF02hkT2PqZgScKkOOGykXKx1+sOYgL1oZN3t?=
 =?us-ascii?Q?jJtpR2uzMqDF2YKfXIgiBBG+UtfrOdisIXnh/YjZ6Fz538Kc3IvFxRWHu1o9?=
 =?us-ascii?Q?YvwCMCAB+KWVMKZOxLd9hSpmN2uS6L5THmTk+3HzvCQ2Cm4y9y4ga/WuIPNz?=
 =?us-ascii?Q?oC8vVbQ194x6XMQ4+ypF2VI0kDHMK4JNIJTc4q/6+zsK/yqIljBgGfQ5VPu4?=
 =?us-ascii?Q?v6u6Ns5myvqlLCPosFWF8KntTa9RHeKsDKV6Hq/ST1+p0qwfYzHGP+TrXfpH?=
 =?us-ascii?Q?2+2B3+7+t2WrBzc+OY2Dz4f+w2m6lrr1tgXOJXGk+KgecWRzBm4Rc9Y90wcg?=
 =?us-ascii?Q?InKGDqrt0RqUI31G1VOJV3tEV9plqdvf8KRxHNTtg+ZjcEuPSWHLnmh9DV2A?=
 =?us-ascii?Q?Xq/1yGn2AHHNZcXwpjHDbgFOM+l24WO8KJ53miCdHIxTb5cCvNJrmBDwU3Hb?=
 =?us-ascii?Q?w6W3Fquh47AilaiCx0GcT2Hf5r2qrnJNlbNVMvhLSUBR872cD1zy/FIBj7sl?=
 =?us-ascii?Q?IgkiD+KGa0iy7M+BBuKaoj1a1hM2yagKHVN8BdtASUQa49SMog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fXzk4fACzgTZ3FBSlHXEpnp7f7wxe4LJ+KF7j9QkmEQiQ5Mq6aRJ3Mgs29g+?=
 =?us-ascii?Q?Zgy+JDO7cVLXAbF1n7+tW6wqoKpmUTWKN7S2av+k6YP3nJ0SyTdC39nwRhjS?=
 =?us-ascii?Q?HvT9UjSrod4HMMUmfg8nZyNjA14V6G5PvgXoapeJcPUnNzt1Di3jaEq8hAE9?=
 =?us-ascii?Q?cykRgxYsSEov+bBjyB8w60pUCzm47DG21+f6KwWNkwFybJ/c13dOk5mMuLAj?=
 =?us-ascii?Q?jFRqLdyqtKQFitiKlX5A75EHH1cF06el3u7noK+PgHOO/eOJmAVYIcCXGcIs?=
 =?us-ascii?Q?cawp9J1XP2gqHWIz9o20k8FFLw4lD5jPNsfZw0L//lgDvn6R2ImbH0TBJiIp?=
 =?us-ascii?Q?LpwkHL/PY4/NIaGgrh6x6ksiqp6odzPueEUOZIzcS/5cqfyNRDkqGdnOmr7w?=
 =?us-ascii?Q?TODmUi51RdAppHg1nrPKwSdBs6N5N22mSVYJ87rOAR7SvxF1rk5Qy+gtL/gl?=
 =?us-ascii?Q?1l61ZZrSlwGErl5UOVwzTAy4j3zHaB77EnPUneSy6P72Xz+21UiUpbnQ54Zq?=
 =?us-ascii?Q?jM5iXaf7S5Jw5bW9jmId47LkjC0Nakq5w1WonnYOiuzTRVvDUHL8+OXOf06s?=
 =?us-ascii?Q?vwx/5UiAvfVonhOArguuED7aHO2ycCL4msqYlls40x8lS2r98lWwzclsjxqW?=
 =?us-ascii?Q?vpOThlXauCr8HPQ1r55bufRsAMTL6x7UIowMCaZRPNDyQ1sip/REBCvpnbvl?=
 =?us-ascii?Q?PI4hKcHzQZRZEICOiWVLz940N5E8sTW48rgwOoOyTPl2igCiz7nOimWPwj2v?=
 =?us-ascii?Q?q0IkMSnqluv/R2m2m6UzBfAUxhIGuc0C1J1SpWxh43Nqq+4WqDDkd86blUo5?=
 =?us-ascii?Q?cmkUTLaNHXVvU9DWobVx8y+N89M3E8cyfMKPgmMHVJAdOC14MxdctV06EgCQ?=
 =?us-ascii?Q?DIBpU8h+VhjMDgbjbP4F+KKTiLAfg7q2A7pfvcK7O3wpC5T6VNuMG5oQumuK?=
 =?us-ascii?Q?2D+v2Lc/4zzC/xQ+Oo0n63i6PyRc9pfJBKIfsFdQ089p0HcsLOSmCGbfz/lH?=
 =?us-ascii?Q?7diHXnXs6ywBx9KYxGfWWMFfcsLf6tm/nzfD7D8VjVnSbrstEJDdtel7Gcd7?=
 =?us-ascii?Q?wj3fdrHySvMbYUct8q+YsK/LUKrqeeBN56e4fhBanngzHb3y3JUmYUtUbIP6?=
 =?us-ascii?Q?9dLPjpi3xSAbcBm78T1PLs/P13HJn8P2PmEDIWR6r78O98l/qa4bKyWcEyqN?=
 =?us-ascii?Q?7b4f6kTDMPT/MicWuTk6E77QDfNO6xAbA0ogQraAw/ecXsrcT8DvczY5jXP1?=
 =?us-ascii?Q?Gv/0d68ZoomeAGRZk1g/kyFoKrPUl7tsegbkC+AdskwjewSkWVp5DjasTJWH?=
 =?us-ascii?Q?d5vvS0mlq7sE4kfnNQhJrOFYT4rrqlfimFEM3rZ0ekRd/7AYa89AKnnGslkS?=
 =?us-ascii?Q?/x+QwOkeE6Jm7afDbt0xYU1IHG6ppDLai9nxb3PVDKsApTZH1kGJJpE6bju5?=
 =?us-ascii?Q?Z7Ezh7dIXAnkel5/UhxGbsLWkCTdfv7CJfcD/4aWkhsZq2Ect+EA/thaeYDx?=
 =?us-ascii?Q?iDYRtKiGrXu5LxTTzsIA+ff7syHIcZCLTuEj0s3NJj/r4BflPFsqCXSaSUPq?=
 =?us-ascii?Q?KESlESPhOpd6ZTDvYbM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70bd91df-dd12-49ae-a6d1-08ddceefd41c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 22:32:40.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1puBELaA9yfuCeY+u3RrlGXt1907aXbHdETb304XH/nkm8jglVl7t6XKWvAxJkx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025

On Mon, Jul 21, 2025 at 04:41:03PM +0800, Baolu Lu wrote:
> On 7/17/2025 3:57 AM, Jason Gunthorpe wrote:
> > @@ -98,4 +101,36 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
> >   	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
> >   }
> > -#endif	/* __IOMMU_PAGES_H */
> > +int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
> > +int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
> > +                                      struct device *dma_dev);
> > +
> > +#ifdef CONFIG_X86
> > +#include <asm/cacheflush.h>
> > +
> > +static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
> > +						void *virt, size_t offset,
> > +						size_t len)
> > +{
> > +	clflush_cache_range(virt + offset, len);
> > +}
> > +static inline void
> > +iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
> > +				 struct device *dma_dev)
> > +{
> 
> Do we need to clear iopt->incoherent for X86, given that
> iopt->incoherent is set in the start path? 

No.. When I wrote this I felt we may as well keep x86 fast since it
doesn't use the DMA API and did it like this:

static void __iommu_free_desc(struct ioptdesc *iopt)
{
[..]
	if (!IS_ENABLED(CONFIG_X86))
		WARN_ON_ONCE(iopt->incoherent);

To largely ignore the incoherent flag.

So:

	/*
	 * For performance leave the incoherent flag alone which turns this into
	 * a NOP. For X86 the rest of the stop/free flow ignores the flag.
	 */

Thanks,
Jason
