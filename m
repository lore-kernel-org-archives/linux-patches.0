Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FD921FF51
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499123; cv=fail; b=heiqO2DfM+W3VsUTnodOOq/G71r9dosonQieAWQJ8iGIFlyJ68w88Yn05m3o3cpwMbFizx89YrsbmmCRRiao7v8OxfW/B3cs1jdFSPnpuzRbKwYLE+a1vKliJlF1uCq+Uwc+aAIlfohvh90N9sbYMgtqddVZqEyP8doN5wbtF3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499123; c=relaxed/simple;
	bh=CZ26mDwc/Nj3VCUbGvvB20tRR8j1BNLXvlo3aMQeapw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ha4icFK76B3zi7MsE2BoJCrb18PxaZMHnyG29aEFPq4XevHGpxvn3D9/GQjlBMhoBs4edLtc1Iag/3VVZ4lWyN1YToc0e+fIk2jJ63jv9X4guG51obpTQIG+yn4zz3v5FORgZUapVc4LUL2s+jBCOPCfXp9LLjI7Jx9GaU2mJI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mLC+CQIX; arc=fail smtp.client-ip=40.107.96.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mLC+CQIX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxLVBkTWd4WQkFjlTwOy+bXJM1eLpyoVQ5SRIbWwkMNyLZimGw1knswbW7HXKWcSJese2FY6VGUOXOzwSOXT8bWH+LxwNr0q2eSMO2ROyITMkb44bPMwT+ussHoRtgtTrEGU7+rPd1iiaIbyrpP3W7vf5x5SO1E4mZFL9TVExPHeO6yd0net8scUBDluAdlt3Hp6nvNGxee3zD6MpsJ1+9f0av+oo3Tb/negDtmRqq3AEJQXCMd134Wfk1QhiU5luYzk066laFRkevsN6uO/DbbXYY7eqUJbRhgar7PxzWGkNGKLA1p9Ij7HpjWpNEVfou5rKsHAlEbIUHDO36Eleg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pcLPE5MaWqJ3S6U+unkFexYduVvzKYAnAQ2vBMTVCdU=;
 b=Z7TStCMpZpE3/Gs9+QBlBta9bPdz57jjiyX3jDHFriYVr47ltqKZYDc6oWAo9ffSrNvS6X+RG6HoTYqlOM1/VR59IC6aSGXhvb4GqKXld6AquHSKhgpBX3utSP/3Kf7006T9Bt9YurSSSbvaGWboNKrypRXaAXDAH0mePaZSDlhANhjGEaL7TLqqil8h/mAhWlEqSeBIdeXLazZvpkJ2N7oc5K+MGtUr6BoxkN30QFsh0uk4CWqdSKeCftSdAw3EIZgcWwqJNzrBjWFucXw//BUo1JQ4BDKuS5D3x/E0JvrqSKeIdRzL4X+e/GqGp3lmwNTGJHTclb0pLHZxmhBtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pcLPE5MaWqJ3S6U+unkFexYduVvzKYAnAQ2vBMTVCdU=;
 b=mLC+CQIXAgBF0/d1gNxo7eDImth9Lh0xfzK5Mi3ueIsFmHg4pGNWxNvtQ1bGoFBLf2ymIS2FfOEeAxs86AFh21rfUvegJqE/pjGMinWAqOvpuJ+3sW2CJGkH/Jqa0IBF60PXrYjO9qXpxMha2r6aKhmYU+tDQUFkjTEe0EVO9h8WNbH5suM0HAgCfZ1aEisI202HFXeDjeRshYFLCjnwMYpwFgDMu6i3NyjBTexCss3Nv7I5+Jo948NXYCirqcJXyQDTDFESoyHtOZXYCJXxN0zQ4m/y2/YGoX/ptIsCxI5jGWBzV/Dn7cpga/LJkwXqjQDra+Zp/Be0dIE0ikijPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
Date: Mon,  9 Jun 2025 16:58:26 -0300
Message-ID: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0061.namprd15.prod.outlook.com
 (2603:10b6:208:237::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: c2fd009e-ed83-4744-16a5-08dda79000c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ST8FVL71irXRj3E3hEgdkkEAQ2tYAhoLEIz6qYIHYKwd4BogasBUKlNhO9UX?=
 =?us-ascii?Q?8uopQqgEDlmqn2wj6AvUHuM6kyEY3B7YreCctT1as4N/9Xwl1uo7lGytsC42?=
 =?us-ascii?Q?5v2q/D5Rn/iqeVuxKuETJsOFDpYzCT/ef52cLk+zcEZoeMXcJp7Z0+iV3xoG?=
 =?us-ascii?Q?Ui01LM5X4nPDF7rd7Sj6Tyl1RSrAdhvmzVftEszYgI/HnrTST2EOXKNMcvOy?=
 =?us-ascii?Q?IidXMUsm2I7jZCLjgJsx7aoGEkvKd8qjjV2/t6EGByUyk3Gg05GtVEH7HG+z?=
 =?us-ascii?Q?YlALzZBxPRvyG0rgVIOJkBrIRkhj9YP8EFmY1jW4Sqz6XRR0wOP1w2KJFXIl?=
 =?us-ascii?Q?f4QZwM6vCxWffup2eKZVaoNr1W4CUoPzW70XPo+MSDtq7hMDDvC1VRqHHzCP?=
 =?us-ascii?Q?FYW0OQJh2qLQXtR3NiVRndXjQqBUHEhBeg2IzelvOWshXvjkelq4u1TWU8q2?=
 =?us-ascii?Q?13stutcdGXYFuXUgJN02ME+JPRkUiPv0TwGBqutGK0u0gHUi8rcB+ia3ssuo?=
 =?us-ascii?Q?XOG2//4IkkgrJrqB0nMTDAbUslz12stvYDHFbeTuCfHa7v2LoqGWdq9Iqd0l?=
 =?us-ascii?Q?C+5Mk38ggSqj/3DE4acxlFn+Ap9qcGqCkfkcgsI14gPRFPTvjeTcxuJUomUT?=
 =?us-ascii?Q?SaOIfweRFQwVERm8PvVwsHkC5IcIUQAFxjYB5r68JpikDWHnmYIrXFyc+YG7?=
 =?us-ascii?Q?8J9Mwt7u537dSZV+4/CSZtxfVbFATCjexuQ1vyU3ZLPV6TNJZKs2EkE6zwAq?=
 =?us-ascii?Q?MJsNiGSUuu0bSupg6tW9BxPvyCv4ZexkScMxupXmYVTs9CeXXkXI1LiQMvdy?=
 =?us-ascii?Q?WEO2G5nDEp4cbiRWh88JVy82ffu1mcZJ4tiAmC5V2B+5SjJGrXo+o2e5uCRD?=
 =?us-ascii?Q?e4EMoNVbgSHDk7DYKKYWQEZCKA2EBNV5dzb8jL3W0n/QdKKYvX6sbLoPJPfH?=
 =?us-ascii?Q?7qKFmkFu8Gym0Y9U/yvtM6IAqgeyhhuSGeOOH3MxC7xg9zETF5OafUYITaja?=
 =?us-ascii?Q?XJDeaIZij5VHebZWSDhJ/6kjPcjg8Yl6HC8Xx3QNmHa3AYYAsj13+/YT91Kl?=
 =?us-ascii?Q?CqVj/zY2KTgRA7P+S0gUs0SK8ajfpkRj9w/gsx+aHzY2/vkCae6vpQqeM8cL?=
 =?us-ascii?Q?qYKLwxrGnz8wgs8Ilapbdi8RMqEa1U4NsHKj1XuTLtBjbDKZI0itkrDmksg9?=
 =?us-ascii?Q?SKPXP9QoQRXt0WkjU04tHaWOco/EuC0o8lEBiJtbdKs85wl/VC4MmQRLmaLB?=
 =?us-ascii?Q?UIDBM2VbKBd2mTzLqI/kNcB+EsAacBxvMEsAkVG2Nsp+iZbc3tAF6dvaLYFz?=
 =?us-ascii?Q?cTaZQXQiTOue+pTXZIr0DCMXVamxCIOiAYH7kdljL5Uz+h9J75LuwoydmTP8?=
 =?us-ascii?Q?i0tpOhNe5PxW7i79uMnagj2YJwhTBUCGlvMsHGXxKBStnPwfzrReTpyq8wgC?=
 =?us-ascii?Q?lKS0YSc1qIg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jMjiq2gxd5pXnqzPl6BCwT/1L2I/jeOuj+qo1DgbxvDqqJR+m4AezmsszoTX?=
 =?us-ascii?Q?5lnIyf7sKiha44Rrf956KpvQOKnAKs0Q2PWpCRbkVI8+1WPFov/MTWr0bPkR?=
 =?us-ascii?Q?0QfLCR8EEqZlp/Gxtu7og6aBkD6lF9HqK8fSWoeq/x/9al6F3Scyfruf5gwG?=
 =?us-ascii?Q?OuAT5aMvsSYbLoJpE+VLfPiJ3QkuwB6lY8zGUhT4mcXhhbp7DvphulxmJ3d1?=
 =?us-ascii?Q?zdqV38sl5+bIUGOuPPfJUMw8PzMxwYEdUUH+cFQZ/7iMZb4Kzx7YqWRYcc7+?=
 =?us-ascii?Q?8wiZRmZCx7Y1qNOkmatCjqqwuEK3mOXvStRC04jNdmXW/PEQiYEgsUQOBedn?=
 =?us-ascii?Q?nBcW+cnxf4L3EFb4ZFcXN8lAtgpA0oTHFkl23Bw5NqExxL6Yeb3vJs4c9Jdu?=
 =?us-ascii?Q?RMiD8PDZShXrGB3Rtd3w/MO+LcHDMqD9IiOW9L/bd9DYA64INoM6vpvlYO0T?=
 =?us-ascii?Q?kfHruCAJIpwMWuv3xa8BiwUUz781ZW/4weYkYsf478VO4bJpPwu/fvJRXpBT?=
 =?us-ascii?Q?QnpaYNfJHi9ksjkRy9PctegY/LohMhY4Dc+u76Um/qNOlo0iak9yaUjIDXTS?=
 =?us-ascii?Q?mWHCRnqYcOY3XXl3B/R/yRnzcbBrBqRSKAdITCnMkZotoxpxFdgEYPH2PAQg?=
 =?us-ascii?Q?w1Mya8XTj+CLiMuowNQOP4N3FXZuJfQD31or7rveNwmbSnBP0LIBXINC4dCE?=
 =?us-ascii?Q?AcSn9u+YeCRE+J4T9+xqHrvAR4NWZO4pcMkHBtSvcVB1z4hG8Ml23kfWU6Oj?=
 =?us-ascii?Q?AC+pkUXGnym2gxUosm8p4RhlivIDnfDen07lW5uvlhLnKurC1VzRm5hC3uYG?=
 =?us-ascii?Q?WZbFBSyjh5tudF4T89WRgYSbne7fuifwARFiXDIdf5vmEN2ynu11OJQDu6eY?=
 =?us-ascii?Q?Q7UV4eIV0/pFLwTgxvDlTcus2Qeph7aiYg5mwWATYaO5lCHCXcl69vsRLIaI?=
 =?us-ascii?Q?uVK6Zarjp3IxAjHyqiB+GLklmkh7VlxMGYdr/5cxJbZDUIR12rmHYHuklh6C?=
 =?us-ascii?Q?Nfo8QyyGYUUJ58KqPCLit6ZCVIJHtcbFyRyWSs1igh3d+dLTjHhKLQATM/rj?=
 =?us-ascii?Q?Vm0VySK77EkF6vYhriqRBxmzb75zzbgCkuLBQxM/aeS2WxFX6aOPW4bCYboC?=
 =?us-ascii?Q?AmM/NV+VpvwZdDnubok+mdIgsBFi1qMzwUyW2Icpna1g8oSaAK/jxbkg1Cz2?=
 =?us-ascii?Q?MrwqqCvJBEycOoZXJXRL20Y4nqF36lvn1nmwOR77X8ABJcXcM51SQPmzsbfO?=
 =?us-ascii?Q?/GtVuIc4O8i4TLrRYfyJTi//PFDgM7S4u6rZmiYT0dWwMWCbaFjdOsPpsZyv?=
 =?us-ascii?Q?n6WW3oj5VVivd7gqqiqjXdkYt7xoh3Mfk11voh3Zk58E1xoE3RRQ9CH+ERDv?=
 =?us-ascii?Q?e3d8VyT/KmEhdfbLCfkwxziMadbw5jjJN9RGLjDPfJ+2l88B3FA+dpgiSvvK?=
 =?us-ascii?Q?zVa0Lw6Is280Pta2qtOGpzN4wU6rEDV2kzpIk4LGhfo3rlwJs0yS2b4noi3h?=
 =?us-ascii?Q?el5WHRQT3QA/PX9O9pS5Aw9L+Q6eXFk5D2R9N61gEBBDz5UGbX5/wcD9R7WU?=
 =?us-ascii?Q?Om3d1yRfXru6fC7d4jf1ftg3L0hg46WpWkfIB61y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2fd009e-ed83-4744-16a5-08dda79000c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:28.8444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6n5vuZtS0zvKnovt6mc7ic+E5gsR2t0ReCGDmRd/t03O5kVOgS3nZuc9AjLDAnh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

Make First/Second stage specific functions that follow the same pattern in
intel_iommu_domain_alloc_first/second_stage() for computing
EOPNOTSUPP. This makes the code easier to understand as if we couldn't
create a domain with the parameters for this IOMMU instance then we
certainly are not compatible with it.

Check superpage support directly against the per-stage cap bits and the
pgsize_bitmap.

Add a note that the force_snooping is read without locking. The locking
needs to cover the compatible check and the add of the device to the list.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 66 ++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ab2e9fef75293c..a482d1b77d1203 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3416,33 +3416,75 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	kfree(dmar_domain);
 }
 
+static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
+						struct intel_iommu *iommu)
+{
+	if (WARN_ON(dmar_domain->domain.dirty_ops ||
+		    dmar_domain->nested_parent))
+		return -EINVAL;
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!cap_fl1gp_support(iommu->cap) &&
+	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
+static int
+paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
+				      struct intel_iommu *iommu)
+{
+	unsigned int sslps = cap_super_page_val(iommu->cap);
+
+	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
+		return -EINVAL;
+	if (dmar_domain->nested_parent && !nested_supported(iommu))
+		return -EINVAL;
+
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
+		return -EINVAL;
+	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
+	int ret = -EINVAL;
 	int addr_width;
 
-	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EPERM;
+	if (domain->ops == &intel_fs_paging_domain_ops)
+		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
+	else if (domain->ops == &intel_ss_paging_domain_ops)
+		ret = paging_domain_compatible_second_stage(dmar_domain, iommu);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+	if (ret)
+		return ret;
 
+	/*
+	 * FIXME this is locked wrong, it needs to be under the
+	 * dmar_domain->lock
+	 */
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
-	if (domain->dirty_ops && !ssads_supported(iommu))
-		return -EINVAL;
-
 	if (dmar_domain->iommu_coherency !=
 			iommu_paging_structure_coherency(iommu))
 		return -EINVAL;
 
-	if (dmar_domain->iommu_superpage !=
-			iommu_superpage_capability(iommu, dmar_domain->use_first_level))
-		return -EINVAL;
-
-	if (dmar_domain->use_first_level &&
-	    (!sm_supported(iommu) || !ecap_flts(iommu->ecap)))
-		return -EINVAL;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-- 
2.43.0

