Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2064.outbound.protection.outlook.com [40.107.212.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C824246BCB;
	Tue, 10 Jun 2025 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749561942; cv=fail; b=bn1ZWZJ6bXnumgkMvNdHlgU4Eo4JiEOw3zszcnNwhgdIuFRf9feRMlBmoj6q2FFTT/8M9883O7FtV1xdmOwXWwQ/kpGLz8mFb6kDKNjFHxxxveqU4MD8Kzx+7RAPAiiVGG50qonqUkllBncIiNm+bKqCI6I89/YoaE5hNoQDRYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749561942; c=relaxed/simple;
	bh=9QVrIGzU1qk0VNJKH3HbxN2GJ5m2fyjbyqciXXD0cFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bJ8S/LrOvN/el4iHY23N+6JDqRNGtZaQfsyYcSE5+dkMHHl9Y/uRSvQN8nM/MDQDTqWRgS21krDp0rDqzA1g1cBAQLtleYL4qK5J19gCzxRcpHFTNoH3Lu90kY8UjUFcNINf2eeVaVF6hROf4GVUEzgHro/qbCl3zpprJNTBt/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DL1eqQhj; arc=fail smtp.client-ip=40.107.212.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DL1eqQhj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDNY7b8Rsn7qBYF/ZDKLSNsi947vSEfmU3iDcjp7nvqeGlTx3/gV6Rmd/sXDKpWWf54Jour/DMJkqLJRxT2fx+iltZjh3ngNf0XtIraQ8Fi47vY8FJllrYHH+rMVY4TS5I1BvbKP4rBQrGvFvkTvIGLQfeAk5oBqLViodL1I7xpQ2mqy7UKupU/4zQw+1sTjd82rRp8gBXUoJGx/GzEEXPED+TYs2i7cvBi/XDS3DbwvVLynfSctJoThsqQ93uR8oBPzzzm56vuQ7QooL/1g2x7NYowYv4cwvT86quhWlj23zQVguQGoZHg/DzN2Jhs5z5IJuXx21/409HeeZKzuJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAd9lbsg+0zXdeKnIT3kxBuwEzWpxE6AT6cmyrOc120=;
 b=XaAgytP58KIWFSwAE6UT9yQzZhgvny/SbbYqAZKIEXQ8Z0rXOEWIfRLqgqh2uAZlW/leEDPdgrDYdkvv7IFfKPi6O5PF8ouu6UUPP6KkeG57s8buoFPsfEIpfN2O/AP2Z5i9j3EWAbQ1SKsf2LsQWi7kI+89qwKo2pIrKI/4H8TJrsWgM/Kc/x6NgBOF76wwsrErbJTzr5sAcOC3mARZJwPaKMZS53CHG9M0dGRxaJRFRGB9zbEuWpihOmv2Nq2m0nxEQA8lkwDef9X+4FAsnHJA5CG3xDAk5e/IrTaY31zIHgFTid1Swr7/Y7jkzvYkakIorxr8kR7GKP195ge3og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAd9lbsg+0zXdeKnIT3kxBuwEzWpxE6AT6cmyrOc120=;
 b=DL1eqQhjUQTAbXCrxsXoH0j+ksZIvAIyCV6PceDRHy86JpkyY6Njk6gpcuAxuBOY7GzG2mvGJjy3byXPTxKvMuwwGtYZTqOW/KREdN2qWoXh2oJ7ZbyCnOY9PpCh7+iKha+7tNnWWpLCR7I+HrdYAl0WO9nXnbvYAye63xq+nGNGpRb70zKKu8BSTDLQpypl3CRRhMvfC7BcqAt3dZlfJC3DpIDM11PKe28OxM0v2kt7TrRjMR7mAF43MTEEYfSXJjBkEl/29DT8vCpx+N0vE5bxLqC9ZX7IyK6CZ6jDvzc9ziMR+TP60a33J2j8bTyTGCDfxxjmYQNzOAkTggW53A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8545.namprd12.prod.outlook.com (2603:10b6:610:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 13:25:36 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 13:25:36 +0000
Date: Tue, 10 Jun 2025 10:25:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 4/7] iommu/vtd: Split
 intel_iommu_domain_alloc_paging_flags()
Message-ID: <20250610132535.GE543171@nvidia.com>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <4-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <DS0PR11MB63735BADC131F8AF05B98B89DC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB63735BADC131F8AF05B98B89DC6AA@DS0PR11MB6373.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8545:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d1be6a-789c-403b-89c7-08dda822492d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VXeqaXlsz5PpxkSGmX0BXTiUSt7je8qsi2Ad/YTKvDRy1CpixfmHUjKIXgwy?=
 =?us-ascii?Q?Fr3RG3Per2z342OahKD3Rd89Axub8vbru+bIA88b+sKTtaRaJ8OZf8JrbVne?=
 =?us-ascii?Q?mMpXYpnJXCG+d5NOb072uB8BRGTOojtRiTCIYcK8EPZVAexLCaVjql20VQHg?=
 =?us-ascii?Q?tJRspTL+DnPTQyRR5scowQ+IbJSp4TUrxelL6h/rPBqdVJfCdOn8VOEqd2DO?=
 =?us-ascii?Q?wFUAn35yHoIUAO3UOsYhAJvsR3siNgR33rLgQVaK1+31OTcx39uwUDNap0T0?=
 =?us-ascii?Q?WEPu36H9aGPUH21sT6u8kTWsaFAuJjI9ND3YFgZ9W9b3KQP4r/WGY+iOHOWG?=
 =?us-ascii?Q?HZZoQgVwBs1qwakffBxHpnAoiAQ1QLRuwopft+9cYyS6PQc6syYHakIMUjDm?=
 =?us-ascii?Q?8/A27Hs1wSqE+QDnFK1nASSZUDaMRQ0YZqh10aOikwaS4UykVDNFT8gWmeAx?=
 =?us-ascii?Q?VGifGAmFOfHOAttgO5E0qMjfqltK/c6lJkfpujm3TUaTg2AuoQvVynpiDAHQ?=
 =?us-ascii?Q?HdQutnr0RUyD2HNMUhxClKmivqedhyz+QVPrkBwvM+MM8B+9kpySfemmPuGO?=
 =?us-ascii?Q?139vrIetDOC81hKMeSK5N0cM8uI+oQwl6yRTt8OWb/SPBNBzdhKpIpKI1IVE?=
 =?us-ascii?Q?9NZaKJcR+J4Gwy42hgW1ddITXb1Iq+B7b4aWpMjxF8k4JzT9kWu6CfRS9TlC?=
 =?us-ascii?Q?xoXPOhsrygdGpNDezAyqU+oTVYPa9SWZr8NV/2b9vJRZfLjzF3mIsc3xvVM/?=
 =?us-ascii?Q?dTsfEhyr3Qqz4biqMrGyfuip4FKj8b0PgDmXS+JEe/f6HwKN7XIvZYRTHnAB?=
 =?us-ascii?Q?rLhDFGoJrStZrfgNVAthhn8we12XeF4U0bFxxgcjJn8wiJFEr4BCV5IQDmnO?=
 =?us-ascii?Q?V1ALXW0k+61tgrJ57kgKmwSpXpJOYMw/bIQ1wQipdGxhr8ghYjl9/jnl26g6?=
 =?us-ascii?Q?w7WDlcCfVAPSlwqT1GadL6xFKl0YtHKPWpWwuD58kmbu+8OfIqpW7o3swfAs?=
 =?us-ascii?Q?UgIcn9V5b2u/EyrlbaXeD8LO3y7OuKPKM1YVlGNeDQPDN4duYueslFQtcBtW?=
 =?us-ascii?Q?/stTF5b6jiLxamQmraqq9qdudWcTNxNhPLkxb9O8eAWUFefqt9k5TpFI88sH?=
 =?us-ascii?Q?Uhgzv2K9s2abDYerTbIP+ddTs6csG8ohNKx5Tk/uLS1VJ3dooeVi1rBMCsYP?=
 =?us-ascii?Q?Uf8U5dv4GlD9AymMxK0ipN7cgwBcJfumU1Y2TMv+qTz2r3dp3Hg2EMEHkhNA?=
 =?us-ascii?Q?K1CmWKsusKfLiUZiLDzI1c+Njr/ocyOTxvZ+njca0IX351+nTWEIAkEYbKSr?=
 =?us-ascii?Q?a7lOyriG/TAHk9w2a73yP9IPMu+Yz82so8ptFBnYISYW2j6TfOgNJAyiPBX8?=
 =?us-ascii?Q?SAmH13r8bidJaP6FeGFReiUTtbxhQznBQTI/ixZJqtnTKZoZNG4jvijSOdCg?=
 =?us-ascii?Q?9LZ0C5Ib7cU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uJiDdIaQQdW+bwTA9W2rUV9OImHTr0d+FtU+5DD+LgOnXt32epWbjf6jEr4H?=
 =?us-ascii?Q?pbExY94Upww81iuag1KIP3D+Zxg691lNobOfj+iaNBohnX0jWngpc6tZhekG?=
 =?us-ascii?Q?NBQoZbH2nHRRqNKPA+9ZZH2nKOHSjYuwNfoclp9lagH2QZUimvRuQlzO5X3I?=
 =?us-ascii?Q?SgJWE+VWgfDlsFjqNpxq6hG1d0AmTSWY4993kZBhupBXfKTbUUM/5UW6+zK8?=
 =?us-ascii?Q?MnnSvqHXPqSceqBmAN+36OClArgnkUY4TcdFKcFulmRrI4tOIn9jEHeM1dVR?=
 =?us-ascii?Q?PoZNKHcpHxQ4shXB9ZbvlMNvQwzEu7NeGfsPXcTcpTlJ3rYJ8JNLUCp9jgmh?=
 =?us-ascii?Q?6Ak9XxqeR/lRZQesfRYDK5H9hIC5Nrs564Etc9Z9oGLL84EigCyWtM0ZjS3o?=
 =?us-ascii?Q?pWozRjB5/eOPUalLvI7cJofarADqDF7sDcsd/elfO1cOdXF9p+UL4yVxzUt5?=
 =?us-ascii?Q?g7P9qvcAfb0lVLC7RCyZQg8M8fh9a59jdFokHfK1xxNncI7Z34XW6vzsY5Bh?=
 =?us-ascii?Q?Q6HkcTbQ3n1LR///Ndq7E80JOpXsIy4sgMaBfIJfkU+gRY3uLceVPtPbDhUT?=
 =?us-ascii?Q?IbRoqPvLze0Oy3CmMTLFe3QObFRVvfsnibo08i6F8htPIVh1QU099ypV9rnY?=
 =?us-ascii?Q?kOQ/zVXrn96UBGpsngsiH/QOoVx8r5XpE4DwrF783l6nlIEc4PE8CMggzz0O?=
 =?us-ascii?Q?UkMvyMBgo2amzckAOsKi0FeaCP5b5p3qNSFlB0EQlVCZjp6+UaUcDz/NxhmO?=
 =?us-ascii?Q?QnNV0PrBdo4r4k7LwQtCwL/n4ZzRVXmVcfBSyRbPDHYk5rZDpBKQTJARJJVt?=
 =?us-ascii?Q?LuM1lpx1W8HL3d1R2QM/uxCCfOVxeWUe6MaAW4mYsJZIq4A8CVT0S2Olfm90?=
 =?us-ascii?Q?IHX/1b5Rm4Xcxx5/hnWUuiqidKgP5k7nkCDYpNnbEB6gv/7wG0wrrK3Iqcag?=
 =?us-ascii?Q?yupqjjcTQ03x627WiJjS/1Mk0yqrEy6epBbeeQwSPKwyaU251fVMNcO40Vzm?=
 =?us-ascii?Q?Zo+5irAYMFWxg0JDF2nokpXdOHX6Pkm6Nkt81FdcSWrPlVMcyJGVp39Jt8fH?=
 =?us-ascii?Q?t7Yckr9crCpVFLpvZSNfRaLjX6uSLV0ynOzzFzYirGvVuzQa4mqX7v7XgXyE?=
 =?us-ascii?Q?VPAzGXgcvcd+6C5MOEXS2cRB3zeVN1S+bOuwp2omIyrf2/thZNOTkBNLCO6X?=
 =?us-ascii?Q?PoVes9WcoVIE8+xeA+2KC/lrifsHFsfaoQL4pFnS1QDiJ4bx6IUGUajXnKBy?=
 =?us-ascii?Q?+ykLew6mpj7siDFH+SSP6WETbNCEuuJnWtJuyrRsQwjm9Vhw8Czzw/it8gNm?=
 =?us-ascii?Q?+qyJwwCaBEcwpwFATERHvfC18togbDwJTKWpoMr7qlYfT9Z+O2348Ne+yau6?=
 =?us-ascii?Q?1J1MlBiQo4bBSMDTyYTkyO8fvmDuBVFeXZ7EXniQN7pILgGxevCUxNEPTLVD?=
 =?us-ascii?Q?Y2ENY4yA8S8WOnjx2rpe9gz80RKI9tFB033NzFczmq7eHuiuu+6W68w7gVCy?=
 =?us-ascii?Q?qN41Y/t+0eSGrwuIRX5SCSVKl9rTOsOCSF+uK1tlHu0UxQdhbZDYz26vlwZ4?=
 =?us-ascii?Q?MLFDAvoCBGiy2r55DdV5770I9A0Lo/b1sh9bqhEk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d1be6a-789c-403b-89c7-08dda822492d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 13:25:36.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dheolwblgw0RaV/jD3OYLrDk/zNTD7I0j5zMMncRbWARCEmXZ8DWGZhvjKRFaI8y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8545

On Tue, Jun 10, 2025 at 09:14:05AM +0000, Wang, Wei W wrote:
> > +static struct iommu_domain *
> > +intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
> > +				      const struct iommu_user_data *user_data)
> > {
> > +	struct device_domain_info *info = dev_iommu_priv_get(dev);
> > +	struct intel_iommu *iommu = info->iommu;
> > +	struct iommu_domain *domain;
> > +
> > +	if (user_data)
> 
> Curious how is this user_data used. I check all the drivers (intel/amd/arm/selftest),
> seems nobody supports it.

It is a stand in for drivers to allow userspace to customize the page
table format. Only nesting domain types use it right now and since
they were split out the paging ones became disused.

> It seems a bit confusing to have it everywhere without
> real usages. I had a plan to remove it from all the interfaces (not sure if any
> misunderstanding)

Please just leave it, it will get used at some point

> > +
> > +	/* Prefer fist stage if possible by default. */
> 
> fist --> first

Yep

> > +	domain = intel_iommu_domain_alloc_first_stage(dev, iommu, flags);
> > +	if (domain != ERR_PTR(-EOPNOTSUPP))
> > +		return domain;
> 
> Should be "if (!IS_ERR(domain))" here?
> paging_domain_alloc() could also return ERR_PTR(-ENOMEM)

If alloc_first_stage() returns -ENOMEM then the first stage was
supported and we ran out of memory, the entire function should fail
and we don't try the second stage (since first was supported).

If we changed it as you propse then we'd never try the second stage.

EOPNOTSUPP means the first stage is not supported and the second stage
should be tried.

Jason
