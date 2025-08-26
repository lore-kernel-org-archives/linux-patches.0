Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AB82E7645;
	Tue, 26 Aug 2025 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229212; cv=fail; b=hVI6WLhpQolXgGxn2Fjzkrci6KTkagENUeiolpBx4LwBNGnMdks+sMwCJG3sUDV+3mi+BwfHk2vLkS6/04vnXZ14+opTJ8jVgMKt27slvRDX/CW59Y4FBhN4xoDYtyzd2VjXxBa1rPoR8DCNbs7mKvulExr+JBMijbegprZkLeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229212; c=relaxed/simple;
	bh=9hIUVxXe8QBHVBq6J3E1WvOuBzpPsAZ96wNZgv/9gc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ou0dTgsDK4NCE8gRsFXmsftB3MtoAd0ug0sDmSImi6CFquLuBcYI2gz9ov+2MEin0ssC2RpmSFWS9IqWYS2kzNtGXNwgjF6MUL9Abvsg6YO4iuo8DkcPoO43499Z9CkJ9/3S56QkogAH8frXnuW0cqCTPLMsRZT40cKthtakW/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I2pSuX69; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I2pSuX69"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oy3KrHtU7XMgjfxMAe31+Sqi4Zj9M3x8PFy6P82tz3MUb8b/eoViT1b9Ax1nngx09z56z2sjgUn7CwhWEwfythPrczD13K7dUT6kHzEpJvkqTHIA2ARB3gyRY8JvBS3E9qLBtQxjWXB4PKPIVascY64RxOwic637YHlbqx4YkhWcxB5Z7LIk8Tf8wPtKCiz4uywpbLvxXBp0yVOvya8KFsPStiKzvlNtAhqD6U4EJLTB3l4LVKfE36UwCIViUk2xHH8nneyERBiWf1zECHcMju0e9RjV6NJfZixQWVD9Q70QiYn+zlPAvpGMfE6Z44zGTKPP0Ze5Wx1+MYx7iiUs4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHnhcoI8h9gs88BHPscJIhAJn2exxsh0Dfb+iNZ09BM=;
 b=QpAKf1HOlE/jk/w7YLOjdWvW5jGguXzJsAxG1cyAufUFQH+NVFtDe4NIGDUY/A5XmxwTPhR9VL3TgMTi1VojdA0vw1RpbogI3MFqM8KQTjhgMvieqevXioD3nMi4QT4mxOsKruXnKrmbkTj1k7AI2/ArFHlN68K1evc2X9QoIxW+miqZNhhHo1pQvRWkMCa5ZHL4DeEnZEs8oCJC42v0GYrgO0WpFcihm2mAVI7WEywo9cGDIAzY2z9SM4AJxM3YerRQ2a+NPeG4SGwkcNzx+YMp3Ut0/5rG7QS3qPL53r8cxWEF8S+6ucVP3Cw9XQC6T2+Op2Ka5KIh8QDMYNXqOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHnhcoI8h9gs88BHPscJIhAJn2exxsh0Dfb+iNZ09BM=;
 b=I2pSuX6996KahWeqgAVPAwEob5jfW5OLU83OQ7gfZSaMJfZxuY5XqXbEYA7p5AduAUluvfdSucWLAyCkfTr4QDb9UYbz4s/vNoVlmtqql0UecrRGVNe73BzCWNfChnAA9NBZHrmqQYihkHqYLUA+FOgMYD2TeD3n+HYZsdvnB6awgDrr+dwFEb7DmyHpVsEuPO292TlntpZlM8+hU8XsfZbkVlSsY3DyIlby0NwD7lbqDe+NTKtWY3Q1wq4lKzDFxyc47npVyCuSRp6Dw20LG7xyO9uQU+angefDSA8HKhuVqRiNuR4iOvwMKFgyJ96fRCyNEauLZN75vipuowIG0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:42 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 01/10] iommu/pages: Add support for a incoherent IOMMU page walker
Date: Tue, 26 Aug 2025 14:26:24 -0300
Message-ID: <1-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::38) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e0a4608-f844-412e-c3f0-08dde4c5b874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dM5Umm5Pxr5DyAkz/vcE2IojymKFC9P0YyhH4lSm8Vd+apE4ZnQ4Fba2blnP?=
 =?us-ascii?Q?P1zLqH8AENev2YGR446n6hjTduO70kc8zTVZ0B6GnESzUScjQNbJwmpq5TeA?=
 =?us-ascii?Q?5fgD+4eW37elHBUXeYrtzgWgwdf7mgz4wAnobF9FKfd3GhsP+s2iBoFR8uEz?=
 =?us-ascii?Q?cghYgAdEOycs0fDARPQI3HN7AORlmp4Y3s+Dn7DWSXDoXkvRlgBg4l/oPWOD?=
 =?us-ascii?Q?6D4aoF0rCoQVHTj9iW8RU2T8MbkhDp9iGQa434q8kGxQenMNuGmLc1OkNnhP?=
 =?us-ascii?Q?I1fA7kEE4IeN89x37x1s6RytWiP5M6lZAWDZUzzRsr/VAqSUBk+J6ZuUl3P/?=
 =?us-ascii?Q?etlxxwPCd8RZ/RhUbUoasiuww8BQqvL69pNoymxKr8MJmm3gPl+cUyMe1Yac?=
 =?us-ascii?Q?Y9qv8tTc57OG2K4nK8ly/u7svBZX5pG1p/7BcWGJGZHX6W5vhLPKhPcH1DlB?=
 =?us-ascii?Q?ej6PQ41EaLHrmyPUoMVvwOJcW5B6geiKPqxTjhp9xbNjGILZudwGsUl2/Fwt?=
 =?us-ascii?Q?OSSopqTXITHZcYjIC/9QzBJJtXl89fq80BiwRt038g/NC7wq+7D4YTSe+zJp?=
 =?us-ascii?Q?XJr4r7+IBim2Bc3bF08/biYo+YqbejLFEx3MkLR1xXBCGqhX0vZchvb7HqQi?=
 =?us-ascii?Q?b1I4Nrn/81vPiiXnk/lbZybbZKnpP+HlRw0AIpqkOqUGNs74e1/nTeLufggg?=
 =?us-ascii?Q?7c5Nu90wjvdio4Ug+GOpdrsA6uq2szd9/ONt2NzU/wVVjTK6EtEi4GM1xyyU?=
 =?us-ascii?Q?SGalQ2hMwmuxgpCe1Prmjsp5ZHJ0iBv6K8dofbpCQ5HQHh+HEwFGuhZLtiXG?=
 =?us-ascii?Q?Ek/GrfrHUnHFemdfkzc5iG+aBO4kzbc3wADYoQLkvgW3Nw3uO/7Gy+Od4vrW?=
 =?us-ascii?Q?m/+Xg80WQe1L4MsWEIZGQfNEWRpSay7vT2TF78HQtx10YulJTfpThJlksvV0?=
 =?us-ascii?Q?sCB3OfeD/nXwZKvThXoDFv+ysbLhsWZlB5FcwqhzARhBGhEoBcOgezHAkGSt?=
 =?us-ascii?Q?x2wJz59DEXYZfMeUNV5DYmJHqcVxbfYahXVstyES6GGUROYmQHTh3uN3GSjp?=
 =?us-ascii?Q?5HWw1wQEdWiF2qTQ/tAprARBaQuDHofvczAIh8J3KjrUbn05qlLVh9QNTk/u?=
 =?us-ascii?Q?uOLVAWdJdJ5WTCeNINVHacy3jgOShDTO9Jp7IzCPWU1WNprRp1W3rPMACly+?=
 =?us-ascii?Q?/LQsB7zTD7WG4UBln7xoMrh70Wih9i3MJkVU6OenbiOzteSGaUB0WYDx1gZD?=
 =?us-ascii?Q?DJ/+aIgJJSikizpBMmlkDvu+t4uxmtxdyEdrTgKNZ3AuGlfCJvnIRiFQypdS?=
 =?us-ascii?Q?I63qMDs6KmpCBO9CXUwZPmdJ/fFJIRndZTK9TKtOBbYUiHszLWnK/uiScdf1?=
 =?us-ascii?Q?+wh4VUXKBagk2VRspJ7ZBClsSLWZjkhTBdzgb11UP0NpvAn4UG5FT7mx5sB4?=
 =?us-ascii?Q?0mojUvuQn2I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KWVlgJPqU3ixj2uPjAIUcR9ayn2zNCM+CnruFE6q+63S9pcOz86oiZgceE3G?=
 =?us-ascii?Q?b4VTseleGHBe9szb1Lq/khEPimoCi95LYm7anh3cDBimKaOA+497RDi1UuKk?=
 =?us-ascii?Q?r/pB11RqH40lADTxPDnNJ5M9ag0/cLc+gHj6vFcc3veh/bMUBSq0a5DAtinb?=
 =?us-ascii?Q?tG0eEh+O4l+hstbjdvI+akU3Cp3yN3fDiYfC4rnUB9RLwv6lxgmmx5TpcDMa?=
 =?us-ascii?Q?rCYYvzfm9KqKJExCAVQvycgwTfoIx7giduYBim6odQKowD7BbkfQ2o9D8RuP?=
 =?us-ascii?Q?aTRxDVL05WyqFwd0kCJJuh5T03DoUB8QHOWXasjWm+8YKH6LRaz/ubUuEq1t?=
 =?us-ascii?Q?cWit9kmgCWIrHSISuzRaUfNyMzm1EDCw9VMQChmEfz8w3jsw8dUhO9O1GefJ?=
 =?us-ascii?Q?I7AW9qqTytXSaC8exSwLjGgFIBaLk+3e8LcWb0MB8I7CStjYP0+OWU7C0nhy?=
 =?us-ascii?Q?l74AB6xzBUJl3apOr06flNfZtwf8mQh8kRKsF8l5PiDF8fRtiFH+/NvPZ40l?=
 =?us-ascii?Q?jiqudRZteAF9uNYSY8IuD/QzmsrSn0dirvmpmN4chW17PdMlaEu1O7kUqTKg?=
 =?us-ascii?Q?6v0ZQYLh334K6RHmXQof8UNXDFKDDkQESCoezzRTs2NfK7UJ4vNJGMyjEldr?=
 =?us-ascii?Q?ZN7OFceqGsQ2xDD2CcXH8utcBbVhMiPRtkJMJDh6pj3vc5uRrqdhQG4tJKpA?=
 =?us-ascii?Q?JqlPBBs5HYZZaaJHPjccJBwEnPLt9aaWAOkBoLrFF6jyqmmztIL5wUgEgApE?=
 =?us-ascii?Q?56eMmdbbK/tNW2S33WQHOaWxWX4ZziP56as3PjXL9E8YQqgr6BBwWmbn4I4K?=
 =?us-ascii?Q?wEjNlIq1SDPgFL+Wp21pshhwdxQ8A/AxKvnJZcXemo+yXXpVh3DXqv6KFqPK?=
 =?us-ascii?Q?6j0srZCrsgu08RM0bxaARRSvHwCgsvrCv4hS9po5+HcvUXG7yW/Qd0xEnS+B?=
 =?us-ascii?Q?bLbx+64j4Debs8OO4obrqYzkMcUq3BulU+d9FmfzUDKiTC7dTc53Ig4pG/hG?=
 =?us-ascii?Q?y+GA8i/q2v32XGQc2ls7iA58g+VEqtQoyrysgRoQhBzlHZ1h5a5P2ZToMEOi?=
 =?us-ascii?Q?fZGrr8xiybp18IQqxbPVEPMo7ZO5in4bx+/qDlSiPktcVa7VNTpLaAr07HJc?=
 =?us-ascii?Q?WGGPvEvzVz2qHBzU1LCqte/6OAQ2q9rQ4ZgOR/sBJskVHmrAklRSLdwzRmvW?=
 =?us-ascii?Q?LVclIV3fVAfMvKOVktuxRm14njqFK9vQWCIfh4jqwE9OWDpOS75S3/cbEac8?=
 =?us-ascii?Q?qPKaq9NrcCgWxjkSHSTLxkybN5aPwamxW2XfD+oeNIERRg2cextYn0Vxlh3F?=
 =?us-ascii?Q?84O/GtTof+OLPqJZL7Iac01QhNzmjYB6UwYP8GvhdDLAaF8WoXYjfEkxp57c?=
 =?us-ascii?Q?ILR/zqdumeG4w9LVdszYuFivlG4M+tIr/nZrtDGeU5dnWBCJr2of/mrA21zO?=
 =?us-ascii?Q?30nw7yECg7yHpHJyG6zAYh95hKmovdAQmiWozCoAe48AOc1JwHzIohGqUmJ4?=
 =?us-ascii?Q?Fxc+m+vPZfjcF8W3An9TJ7yB7qaHQglKpDZxgalqwi9o98RNqPK65s2w6fUi?=
 =?us-ascii?Q?g5mHAn1qeWkH2qGKfj522vh1iYsTEUbcojFzFPGR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0a4608-f844-412e-c3f0-08dde4c5b874
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:41.8753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQwP1xCAuwuNtkeg/F0nOgYPhwaiQbkt6yiZSiyv7FPFPfKrWAy9PbMWovuTwYOW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

Some IOMMU HW cannot snoop the CPU cache when it walks the IO page tables.
The CPU is required to flush the cache to make changes visible to the HW.

Provide some helpers from iommu-pages to manage this. The helpers combine
both the ARM and x86 (used in Intel VT-D) versions of the cache flushing
under a single API.

The ARM version uses the DMA API to access the cache flush on the
assumption that the iommu is using a direct mapping and is already marked
incoherent. The helpers will do the DMA API calls to set things up and
keep track of DMA mapped folios using a bit in the ioptdesc so that
unmapping on error paths is cleaner.

The Intel version just calls the arch cache flush call directly and has no
need to cleanup prior to destruction.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 117 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h |  45 +++++++++++++-
 2 files changed, 160 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 238c09e5166b4d..5dc8cdf71e2ade 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -4,6 +4,7 @@
  * Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 #include "iommu-pages.h"
+#include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 
@@ -22,6 +23,11 @@ IOPTDESC_MATCH(memcg_data, memcg_data);
 #undef IOPTDESC_MATCH
 static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
 
+static inline size_t ioptdesc_mem_size(struct ioptdesc *desc)
+{
+	return 1UL << (folio_order(ioptdesc_folio(desc)) + PAGE_SHIFT);
+}
+
 /**
  * iommu_alloc_pages_node_sz - Allocate a zeroed page of a given size from
  *                             specific NUMA node
@@ -36,6 +42,7 @@ static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
  */
 void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 {
+	struct ioptdesc *iopt;
 	unsigned long pgcnt;
 	struct folio *folio;
 	unsigned int order;
@@ -60,6 +67,9 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 	if (unlikely(!folio))
 		return NULL;
 
+	iopt = folio_ioptdesc(folio);
+	iopt->incoherent = false;
+
 	/*
 	 * All page allocations that should be reported to as "iommu-pagetables"
 	 * to userspace must use one of the functions below. This includes
@@ -82,6 +92,9 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
 	struct folio *folio = ioptdesc_folio(iopt);
 	const unsigned long pgcnt = 1UL << folio_order(folio);
 
+	if (IOMMU_PAGES_USE_DMA_API)
+		WARN_ON_ONCE(iopt->incoherent);
+
 	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, -pgcnt);
 	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, -pgcnt);
 	folio_put(folio);
@@ -117,3 +130,107 @@ void iommu_put_pages_list(struct iommu_pages_list *list)
 		__iommu_free_desc(iopt);
 }
 EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+
+/**
+ * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
+ * @virt: The page to setup
+ * @dma_dev: The iommu device
+ *
+ * For incoherent memory this will use the DMA API to manage the cache flushing
+ * on some arches. This is a lot of complexity compared to just calling
+ * arch_sync_dma_for_device(), but it is what the existing ARM iommu drivers
+ * have been doing. The DMA API requires keeping track of the DMA map and
+ * freeing it when required. This keeps track of the dma map inside the ioptdesc
+ * so that error paths are simple for the caller.
+ */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev)
+{
+	struct ioptdesc *iopt = virt_to_ioptdesc(virt);
+	dma_addr_t dma;
+
+	if (WARN_ON(iopt->incoherent))
+		return -EINVAL;
+
+	if (!IOMMU_PAGES_USE_DMA_API) {
+		iommu_pages_flush_incoherent(dma_dev, virt, 0,
+					     ioptdesc_mem_size(iopt));
+	} else {
+		dma = dma_map_single(dma_dev, virt, ioptdesc_mem_size(iopt),
+				     DMA_TO_DEVICE);
+		if (dma_mapping_error(dma_dev, dma))
+			return -EINVAL;
+
+		/*
+		 * The DMA API is not allowed to do anything other than DMA
+		 * direct. It would be nice to also check
+		 * dev_is_dma_coherent(dma_dev));
+		 */
+		if (WARN_ON(dma != virt_to_phys(virt))) {
+			dma_unmap_single(dma_dev, dma, ioptdesc_mem_size(iopt),
+					 DMA_TO_DEVICE);
+			return -EOPNOTSUPP;
+		}
+	}
+
+	iopt->incoherent = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_pages_start_incoherent);
+
+/**
+ * iommu_pages_start_incoherent_list
+ * @list: The list of pages to setup
+ * @dma_dev: The iommu device
+ *
+ * Perform iommu_pages_start_incoherent() across all of list.
+ *
+ * If this fails the caller must call iommu_pages_stop_incoherent_list().
+ */
+int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev)
+{
+	struct ioptdesc *cur;
+	int ret;
+
+	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
+		if (WARN_ON(cur->incoherent))
+			continue;
+
+		ret = iommu_pages_start_incoherent(
+			folio_address(ioptdesc_folio(cur)), dma_dev);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_pages_start_incoherent_list);
+
+/**
+ * iommu_pages_stop_incoherent_list
+ * @list: The list of pages to release
+ * @dma_dev: The iommu device
+ *
+ * Revert iommu_pages_start_incoherent() across all of the list. Pages that did
+ * not call or succeed iommu_pages_start_incoherent() will be ignored.
+ */
+#if IOMMU_PAGES_USE_DMA_API
+void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev)
+{
+	struct ioptdesc *cur;
+
+	if (IS_ENABLED(CONFIG_X86))
+		return;
+
+	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
+		struct folio *folio = ioptdesc_folio(cur);
+
+		if (!cur->incoherent)
+			continue;
+		dma_unmap_single(dma_dev, virt_to_phys(folio_address(folio)),
+				 ioptdesc_mem_size(cur), DMA_TO_DEVICE);
+		cur->incoherent = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_pages_stop_incoherent_list);
+#endif
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index b3af2813ed0ced..1c0904a90ef252 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -21,7 +21,10 @@ struct ioptdesc {
 
 	struct list_head iopt_freelist_elm;
 	unsigned long __page_mapping;
-	pgoff_t __index;
+	union {
+		u8 incoherent;
+		pgoff_t __index;
+	};
 	void *_private;
 
 	unsigned int __page_type;
@@ -98,4 +101,42 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-#endif	/* __IOMMU_PAGES_H */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
+int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev);
+
+#ifdef CONFIG_X86
+#define IOMMU_PAGES_USE_DMA_API 0
+#include <linux/cacheflush.h>
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+	clflush_cache_range(virt + offset, len);
+}
+static inline void
+iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				 struct device *dma_dev)
+{
+	/*
+	 * For performance leave the incoherent flag alone which turns this into
+	 * a NOP. For X86 the rest of the stop/free flow ignores the flag.
+	 */
+}
+#else
+#define IOMMU_PAGES_USE_DMA_API 1
+#include <linux/dma-mapping.h>
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+	dma_sync_single_for_device(dma_dev, (uintptr_t)virt + offset, len,
+				   DMA_TO_DEVICE);
+}
+void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev);
+#endif
+
+#endif /* __IOMMU_PAGES_H */
-- 
2.43.0

