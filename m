Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74B212B34;
	Fri, 10 Jan 2025 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526914; cv=fail; b=uSDK2hPQlgK1DbTy7yy5pkPyL1JwJqQIYAP+I6LwfnOXImdT01wjo+D19nSpmdPdwe1pZJzfPwDVShbOCrnmXAzijddDagqkVd5EB+NaghK0dMysleTUMZ6qZnbHwNzOc7dLWxKz44gArfrzldN48o1vXpxXt+hHpMpNTthgKNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526914; c=relaxed/simple;
	bh=W9gBi2yad6PgmVU7ZGaupV3NAv4sB5Rf4inIJtqrAgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gZL41H/Fyn3VJJ+lssPTX0n4sRqr1nOZ+xl2rVpz8f/bxq7q02CQBs2IvAnKrGVXTN/ZY3WVYrzv71WHxMvnFhd0P9jE08uzMn2SIGmTdv8yy5lvN/HMDYE1eIW8un+QlkqUJ1lapJxMirarnjyNtaAFMS4fMOFj7/xkQ75TUXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WcF0M9jw; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WcF0M9jw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=moDiTRQZsIXPFfP9PGq2XhS0Xam2vE1I6SZuarBl5DL9CnOdhkIgjBubTcYXsBgom7wqMrGVDIuid3lyVj4MGipRlS4DM7uwQOAhOzfOyHTHPxOLCSowyOpF32znQ8FRsfrjq/scyeFZ4ZM9/Y6DnZzK+leL0K/Z6ZcgtWegffAZhRJLx/tHEVFPbzmDTNnzRA2o2p3yBut6Tl0cJNKzigKZpUcMvZDKvPLZymV1t28ssv4ztWZG4JXgM4nb2V7RgIcJ9tX9CLxbiaMVrkCf/X56R1uHx1y6iIvbT3wDaAT/Ob0+17wpgNwVDw/EY5JhBlziB3x86BO4QYe9nqjrUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVkdANdMt4ALU2FdaJDscnUrKjyHRocyxOjJ1ahgG1U=;
 b=D6KYpkABAII5zKBxNYfZ70UNQaH/XVtAELuxLTuMZz0d3MveBfyPsC5ZrR7ZQrcHgjfg/znvtEA3zx/LAQ6IEBbSaf9/KtWSO4+dNA4NmAhs0YfQUfNV6gjbf6qQhFuZV4VZCKjZDlpvbF4ZEMmao+IQ/gdSTA/DF13biXqTzmelIx/kTkQNzDMkflOg/UHuZcAaG+si8yhctvALvRvZvi96EDcdE4oASnBLnsi2aGAIjSXIqUOxy9zjjtZqKR1fFLmsdGZ8stN4RzGgO7KKuCGEK4SuSxDwtyrYKi6rqrD+e9YdHnplu8HD2dURfwFbjqy4Mr5kz6qQV0ZZPdfjOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVkdANdMt4ALU2FdaJDscnUrKjyHRocyxOjJ1ahgG1U=;
 b=WcF0M9jwAhE7sWRF4wFp87lQgmURzntcLGfgyvJBtQIIBEBdAscr0HAn4ebE+JdVFXic+A1o6U/IH8u/uwW+dmOQ8qpqv3U+5IPozTD91O8zrxv9RhXWU3505M4tLiJm36xqfBsnTyvY+g5UB4hSgsmA2dO2nuE2VfH2kVxPv7PP+Aik2hd/5+65qtK7ajWxdclTaw1V0P0GYD9XcRE18+d0rYuQo1rQi68nO6SjivSoXunQUayyffwwFrRGWrXrocNW0/C7HcykPJ86MoS47K9+FxD0iUK0sbviNasJJDcf8Y7vTHMnoLEkZ9W5p6LNPoAS4hC1wNcc14kiHS/15w==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 BY5PR12MB4195.namprd12.prod.outlook.com (2603:10b6:a03:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 16:35:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 3/7] iommu/amd: Remove dev == NULL checks
Date: Fri, 10 Jan 2025 12:35:01 -0400
Message-ID: <3-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0910.namprd03.prod.outlook.com
 (2603:10b6:408:107::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|BY5PR12MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eefa07b-9ebb-472c-803e-08dd3194be2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1KIqJUE0r1cKPXsZWLb36w04DTnnyhZJlEqhf5T94tiUOtMOodLPE2eSDFdl?=
 =?us-ascii?Q?srxK6ozQQy8gwqNm2pGtYMGXA4v+FmBwoQK05/LNweefeW9op2zYCUYBZD21?=
 =?us-ascii?Q?ROoxf6VkwMqyC4Ut8GZGUItEDEMQjIGizOr+fiyui4x/cnvLAUv7dyg+iTsH?=
 =?us-ascii?Q?y0SwXL0V/K2BeWxW2vhcn+QDmN9uF1hqIEMuG2ozsdebV+oreIi6a4w4zMyL?=
 =?us-ascii?Q?AI7VpzwM1aCzy26T5U+yw3EdFFpEf5P/2HMgVAlZO2hB0i4qJSJopYFy7EiI?=
 =?us-ascii?Q?w1C2VEvYdWzFvPZ9iCPZ4oWDVbAcThramGeaC5EujtWFOduBexVCA9X0DEvz?=
 =?us-ascii?Q?4RGJEXHhch6aRZcEi6ne/1mRm1m5lWVR2Im4vIbin3Lq73qJf5BaHjLYo9kb?=
 =?us-ascii?Q?LosPzvbB8z3EovJNU+ahVuRuI69D3j9fDG6hcm60G/gLJWTig52UnKM90nyK?=
 =?us-ascii?Q?mKJnopSIQNacJY4U10fJdo3eJeiqACVa9QQU36Hvb78hyTiteeMY9/LB9176?=
 =?us-ascii?Q?AaGglXQAo3eU/kvbc9R9P9T/vo3C1mmPdaZNKp7u5tG9Zzh317fcnbASoq5m?=
 =?us-ascii?Q?fx62wR7O4iHKz/fvdHsng1nTqqVozpdNiVmewEloX/YKC53dQsOGsySg+ZOL?=
 =?us-ascii?Q?To91PzpvJswoDVYobCduZCGxdiPvnJiIaEpsLEOQPeCGixlm23hG4UIzWp0n?=
 =?us-ascii?Q?EIKzkfb40FcgdiuWt+tS2pGU8fltSVsNWnf824HI2RuiEW94Voa/rj5nP+OM?=
 =?us-ascii?Q?xi4Jx6HR1WeLJLoT0mPvHhBvhh0FTMlr3wm54kC1pjrpgAlgX/ayhudbn/12?=
 =?us-ascii?Q?zHkhWMVzgANQnuz3VPh721fugvA+AZD12UDWaYwAJIQtzYtgLDwH1zgVhw/t?=
 =?us-ascii?Q?+zlDsueKDvemeJf5iDqGVA53MCoYty9gDyG83McavHFeozhMMOZ5Fqlw1Fpp?=
 =?us-ascii?Q?hJBxfb9+m7YL1bEPbqa8BdvGWe87VyjcQpx4sjpYqXRuGtaPLeU0hiUzYN/8?=
 =?us-ascii?Q?luLb1ITozjgoXPrFFowy8THUmm1YhYFoTSQtjYqpPusAS0DlQNdm8SSPks1h?=
 =?us-ascii?Q?Qy26ZLvmuyscRicB1qCDaCiqSz6f+GOCrt3ZQYfGU4ffjhr0ldrLvSsUfycd?=
 =?us-ascii?Q?rR3QDXEYByc6uFtaGgxbVV6+ueBPkATkwdtCCRt5dSxmL44nz8pqRsZgpblc?=
 =?us-ascii?Q?JeYZVH5wxkYb/QkOtOfCwY096fcBdWpQpAQCv+909Gv13zx1v5gI7R4FR9kF?=
 =?us-ascii?Q?4a6bRioU7/I3CUSfv0uwgOWHEDPqtIEnsP47ZG+K2Oej0hmb4M7MhTguBjib?=
 =?us-ascii?Q?2GA0+VuIg2oWeZSNxPxHIeGLhF+lTLUHw5wj+yS+tUaDRCV2lYB83JvkESrp?=
 =?us-ascii?Q?cqQQRt+9qSvxW48DfSZfnEs+WFYg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mN/xdSc6lOc4qAX3D7LGj8xmw3DW0sl/VdVbc65rLtLIRcK5bpFpj5uNzGWR?=
 =?us-ascii?Q?77h9Q0arziHewT5po5Gy5D41slKfr8Xs+nH4qy1ilzdifOKvAcvRonoXi/uQ?=
 =?us-ascii?Q?T3EopzKap3XC5RTzfUMAgD3rmUG0K2rZhc1wBMK5tkjCFWlJzRQ4LPf0ituL?=
 =?us-ascii?Q?SjfuNeUvMTf0j7iDExTyEhI3NaHlQVVglzjwvaUWWnZ73q+n3G5gCTcdxPcK?=
 =?us-ascii?Q?GpC0H1l4F4u/XvLibCcxwcDR7QYOlk5ZCwW+R427h1DutkjSUrkFdh6oZQvN?=
 =?us-ascii?Q?JEdeGyKqgh2I6JmpTEBAan08CS/zTaI/QWfTo4G2XoentGvzhVYUnHJu23BE?=
 =?us-ascii?Q?pcZ1NUkeRMiGXXohOn/0N7z8VjiUyaDfgC3trtonMVQGocknnn/6ui5/QyUA?=
 =?us-ascii?Q?9fZ4GkU872uwMuOtQLhocLDXF+GsZRo/gd+HRPDk0jJ1Ypabn9MXhj4LVM94?=
 =?us-ascii?Q?sp/1uzxLhLrhn+bkg9o630Yj4lqrTVTVkeRAU3Cl/mugF+on4UcVbq6l23Vw?=
 =?us-ascii?Q?AWUs7s56Dh08RA+oELg4geCgQVeIrFPzKNAbB4KjGfDR2K1RCwHYGQrq8p+Q?=
 =?us-ascii?Q?aBmRsnlSqxMGqg9YIz/WE1OToe3DFJMmaMQOMc0GpnsyPFIYmtiim4JB49Hk?=
 =?us-ascii?Q?kJIG6Oc/psSmCXHRc+nirwncT6buymffZ70aFW8rGPM8BzoreTkl1HvCflMe?=
 =?us-ascii?Q?X1mr/w/BC2WlYmVzjRVV5KkTOhb10oq8sY4itVOSB4K83jmyQgWbCqpaI0mT?=
 =?us-ascii?Q?92mEIZjOXGljksW470//6WVDH0LT94k5XHcv3PEn7iR510bfiSMiulCLatlh?=
 =?us-ascii?Q?/YarR6ePITrWv3DUrZ1I+lrxjz9gZEI4T5MRq7devHc0lScn9eqFTNc5IJtU?=
 =?us-ascii?Q?bysrI4UsXNokHq0gb38U3nBSgwQypXImxpVZGm/M/VoaDSMIc+tuOZ6fkqVP?=
 =?us-ascii?Q?rFEY7U/oZtgfMgYTcfPSuq2D/oqzcBk9oLFbinPU9d8HDlBhUuqucanU7HOO?=
 =?us-ascii?Q?9x7fH1/ioUf1mgKSQ/1UVJBDqZbtpcfcn3lS0atdCmapJMkh8+djHIpIlNv7?=
 =?us-ascii?Q?o5gHdwc6s0viSl4apnPyY002XgC1MekaWpN22lfr3ivavFdh1ArhgIxZzuMF?=
 =?us-ascii?Q?e/ybLJ+8wAujKqO3puuuyHFwd6II0cjE3gyK8i3XuP1lIzIpTjCOwpx81o9g?=
 =?us-ascii?Q?hYxJtynLp/3egwbffH4tBqAL/fMb+hwPgSeD9lBTwmGbA/nohxSqHHz1OAYx?=
 =?us-ascii?Q?9alXeBDHwSC/AR4xGDhLvARA3fJMLJgMwG30RpT3yrfqsOipyJAe2wuvFWb8?=
 =?us-ascii?Q?5h5cKnSUWl5yL9ZBAdsTINl34VoJnNK9R2qOzBlloHfedw3EzT+vDxnD/D6t?=
 =?us-ascii?Q?aHZM7alnNeL9SXqTVHhFvlpO8QLMJRUHrbMYvjmKvF7dcZ0P+mWUgqpPnpcm?=
 =?us-ascii?Q?62XU57c6BShwmFlYamnjh+RYzIyIEd3T/xEcpJ+KC9CybUZaDo5f85+hBUpU?=
 =?us-ascii?Q?5BypZYXB/3PEqYj0ewJnThaBS8RPphQSO8Udq1u6+qHyPoKeoGXGyXl2ici6?=
 =?us-ascii?Q?5IoylM/WEyCGDYurygDpUKttx65jzJKt1RvpdUvH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eefa07b-9ebb-472c-803e-08dd3194be2d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:07.3346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EkkJhBrVn0oDMEOaFwgl3uy5FmDx/tdw0VvbGqiM0xzQTg9yt4Pv0Us+ZkX1+U3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4195

This is no longer possible, amd_iommu_domain_alloc_paging_flags() is never
called with dev = NULL from the core code. Similarly
get_amd_iommu_from_dev() can never be NULL either.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index fd94667ed85357..a439dc9aefec54 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2523,13 +2523,10 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 						  u32 flags, int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
-	struct amd_iommu *iommu = NULL;
 	int ret;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	/*
 	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
 	 * default to use IOMMU_DOMAIN_DMA[_FQ].
@@ -2537,8 +2534,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
 		return ERR_PTR(-EINVAL);
 
-	domain = protection_domain_alloc(type,
-					 dev ? dev_to_node(dev) : NUMA_NO_NODE);
+	domain = protection_domain_alloc(type, dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
@@ -2554,13 +2550,11 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	if (iommu) {
-		domain->domain.type = type;
-		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
+	domain->domain.type = type;
+	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
-		if (dirty_tracking)
-			domain->domain.dirty_ops = &amd_dirty_ops;
-	}
+	if (dirty_tracking)
+		domain->domain.dirty_ops = &amd_dirty_ops;
 
 	return &domain->domain;
 }
@@ -2571,13 +2565,10 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
-	struct amd_iommu *iommu = NULL;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -2591,10 +2582,9 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (iommu && amd_iommu_hd_support(iommu)) {
-			return do_iommu_domain_alloc(type, dev,
-						     flags, AMD_IOMMU_V1);
-		}
+		if (amd_iommu_hd_support(iommu))
+			return do_iommu_domain_alloc(type, dev, flags,
+						     AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.43.0

