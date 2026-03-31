Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3891A29ACF6;
	Tue, 31 Mar 2026 19:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774986996; cv=fail; b=krsNrVCrYDRwnO/ELhnBTemCszd6shgV0cXOq7qu25e+yKC/c+/wgMUJBiI88B0aq+tH/kaF7RmdHq6xkTHJcZa6tIsDO60ckFR66NwjseoHf92xoob3MLtm0VjsdjU56Ljx15svdjtidyEmqXHDZIZg/wh6EooCSOS0T0Dpqjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774986996; c=relaxed/simple;
	bh=rJOz6HmGXt2TW69RlDBrnvqQ+VgsB4IjNKPw5urvChY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hZt4o1gmVQVCwPz006T15u8phX5cNtmaqArW9pYIJpmYqtjKYHegk01YPorrs/e1V+azfnN0JQwBdC4H3VvYLLeUy6o0K6xLRylpjZ+Tyv8HF38keqd266fQtsE3MhSOUrfsXidSDWH9xaEkCcsWBT4XBMgTciK1u0nFGa6MTE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tJUnu1FU; arc=fail smtp.client-ip=52.101.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tJUnu1FU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGsbJ8A9q4NGBHOZ/Tq9ar3ZKaNSHCDIyOVrgfk95BUfXiPmlyjy1xwiJq7tWmLNy5hAQTY8oDM4MekRK7QlP1phgMi2CFyNKKkPdVSCMPpQVnMjsoqea7teG1vnvOIeR6mdPa+d0wxCjSb6Hnm/stOmJ5vUfktT9yQqZrzOQ1AXsx7J6ZWkgKT4r+vdloNmzKiL1fN0iyvqnyP5TAXeHfdPfMoKsqF9DhrmPgQ8MgRiStu/Uqgf3npsDm9IGcVK0X+oJEWtpD4K0PVN8EfeKECUrTYZ7n14LaYwnMjRm5JzEoMmjqjJT0OQuRxg1Y1l7vxw5CzAfgxUdok86vE9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPKrF7cCCAHO5t3ubcZIHTwTCR3avdQrpYBWYawqY0A=;
 b=H5aEuVKZ76KcF3lRFblgwV+QWlDtbD5p87Itbb1oC6S4T09FNg+IHYpgYhw1mMCpitIpG87gy1IwhlPw/48dgt0M7Ct6SCYaDK/EpInrKumlTpCC2l7HeV2OnENJCcGp4A+bXDUyI1ewUHPp+n1sz67hKs4Mq7QuStY5cPGRprpadMAB0YVjmFQ0YJuymRrDz3JIRTP6NSD1yb0VTjNFY5XfG0gzWJLyeEs2c3V2iLf01PKhH3vjh93yqa2HOZb7TOgXZB1MJ0P9ZrXesyd8DAD++rg9aiLdtOOHXT1JqdYm2cLaYfIPWfS4vborg2zUpIYQWGQvoxAcHMaeBhF7JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPKrF7cCCAHO5t3ubcZIHTwTCR3avdQrpYBWYawqY0A=;
 b=tJUnu1FUnZ3EADTd9naYlfcNO4LedH5b8z/rcB7UZJMwi3aeUlb5AMJOP38RRuBHw6ApJn93dKxNL3E9nvsYnEYUKrkWy73NY0SBUkXE/IUFbKE+sMZJNk7mlFsusIB/M2eFi5uYVv7rTagBIg667N3Dly1/QmqiJ/pTNe6XT1zOLbuuMuoGVS3IMZqXdcnHsSu3+b+ey74cXtI8Ls0wku0oL6ZA4oSDIh40ywzLOIL5LXj+GseG6ox1GXjOzfWGusEAqadEPyGNks1wT/2BuYSNsdnW7j5OoZWKeVXJflAk9VeIBzbgkiiTzIWZWFXn6LzAUi++vfSE8XSGOLpTjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB6823.namprd12.prod.outlook.com (2603:10b6:806:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 19:56:25 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 19:56:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>,
	Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>,
	Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH] iommu: Always fill in gather when unmapping
Date: Tue, 31 Mar 2026 16:56:22 -0300
Message-ID: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0009.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: f29deb23-400f-46be-cbe2-08de8f5f9619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kxi2MoOlqOzyiQUaPVavpFNinXtk2BfImZBVe5NlaTknzi927XQynUJIJaHzVDGkYaKRrvDEP6zv5X5nK6cN4gG64k/gVyL62dpK44qIIB/ruGaKtJasgIRMAiPCAZoIFLIZfirIhZxOBdrPS3+x4Sa36LI2R2iI/VONesj+xBHGsiVbugQwbU7ONWYpQFWaRWRDDgzwJk+9z0Wbgf0QlO7aD+mC+bnqUGhfMsvxCxp+sRteYkff6wXL/7JoP4gO/RXjXWjOQxOGgO7v8Wpp0XhxH0VqGp79H15JVyFAbwWsoiYDiApuIqg5wq1i+tDd9jfAqaYxDOKFJLuW2jk9vToqtMR0hUac0sddprpoRhT6HuCaNzXA56OEmsRafQbZ58yCVdakp/atxOHBrCvlGXb7byPr9lfWRjdAdUlDIB0NtFh2Dvj40LvUI/dXUwCAqpliNHQZTaKtV4zBA+vRUZ9x4puRVLssnMmMLH1b/mzg1I931qcDUZQXMsagYbyfVB6Vfqu6WSrzjzWcYEQ001JsWAUT77B5+eCAykJ6DmiA2ntmPHnVkZapBdRbjvW+dteVKgta1aDjk8tQo1EWb7QIBxEaOzs7tM2Rt0zQSD4PF5r7yOTDKRk+HT2jiK9g2O8h/MP5ewOwiI6uoPzsUlhODEUFTx/kD2nEWdUZDuupa3AGmKlLmkRu2qAc0qXWH88TWr+OM8pzTh4zdna02CAQs4HoYduKPkCZTkuxLmD+r5VzE42IwnPAd+Gs5zy2cLGAKB4ASW/YUeTn9vx5F5t50q07Sgog8fBX1/zCf00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?os5QxeHvKht+W4m21l7sXk86H6im4hvVLnGDPCmDV6+Tbzd4sj1lQV7ccPgh?=
 =?us-ascii?Q?vgag2LnxrDYD0fZQVU/xg4qi9YAI2ffyfKv4LPK9gLREUeXy3TKHzlhP2PBG?=
 =?us-ascii?Q?7FdiSxDXhpeBQK9Jh+0bpf2M1IXNy1eaKMdCiGDL39SQBNu7PmCsvlQxxVfF?=
 =?us-ascii?Q?rlL9OD+TDGEHzkbnxlxGwEFPf6yzaS59XzZ8q2qVg3wjp4MzJ+h5vYjR/zgk?=
 =?us-ascii?Q?6msa+2kfe9Oh2cKLvsFjBWuqRnQuZT0qvVakkIRP7MJFj0i/WOkwvm6Brxux?=
 =?us-ascii?Q?FMUPzt4PP2d6opAGyLdzNbhTYY0fJPQ2be9+5QYZGn0zuV4qDlL8L2YQi76s?=
 =?us-ascii?Q?Xc/nKJ9VhekoDQrHTQQsM25QXboLG+8kvx2X6HmXha4xe9QU8BzTiymZLEaS?=
 =?us-ascii?Q?JZVnRyyiXsmIo+LhIGjK4KCioMrJnAEDNrvjbp2BFgKXUC7j/G7AkPi6+ul4?=
 =?us-ascii?Q?8SnZ9wR/nJDkvE/7HyldqIZ4Tm27K+jtbCHrmZ4gKT9zDD8c/uWWTJeZJqHn?=
 =?us-ascii?Q?h8nvqOCzpMcXDgApgh5nuvofTjBagQ4DK6zK+++jmhUvMUrLTVSs3s23+v0F?=
 =?us-ascii?Q?hHDqNcRqkALuaOaT/DvtQDZhIZUC5OwAk5RNVZmQTdst76WC7hdur3kOtyaG?=
 =?us-ascii?Q?0VwvBBvn8bVTHhFQOZwYhcvfzA0xfUHVQv0me/TpaqHQSazAHkbdbFuTDHsi?=
 =?us-ascii?Q?EgfM0zaHsKmRbZRioztzx5sxIdaw4e9UWa2mqyoq07YRMUkToOtS5naccc5r?=
 =?us-ascii?Q?wYeAKdZeNl4hd8NbWQGxuTCdGtLLLBze7us7oBofWFVB2molbd2Ztj2Px71f?=
 =?us-ascii?Q?Y2nNGvHsOTeqDDY7rm/WmkCLnDRXnTplOHjV12PHkWYnAsmMvm2Lgx+gA4XW?=
 =?us-ascii?Q?eGM6aKnMYQnmDMaeMyVmrRGqh4OawTfYTueMlcn7Yzr0es0vGBoSNQHS7VsP?=
 =?us-ascii?Q?hc2lxggkgq06Z59utSVw0z4epooEb9mnobom6M/yztnMCBrGEUt4kksCPdIV?=
 =?us-ascii?Q?eoonyze48aPsdZlYuDxVplQrWLB19iEgODIwzaE2+ApSsWeVlJ5GcXFkmkw+?=
 =?us-ascii?Q?a0eL52cuIYTeXqlFjcKuZ3F9aRBciN7lnqKq4tiLxrMu2Ed251roROBHTnGS?=
 =?us-ascii?Q?gPhnHGvKRtS6NaJJkv5gRwGRn8Ie0ngBbNpbyhg4Ve/WNqqyZ77QXeR8Yp0K?=
 =?us-ascii?Q?fUcfn2wVUv7pG+w7qgSyM+JUbz8TeyvuQllbQpVX9fQahuY2+SYAW4gsjjNX?=
 =?us-ascii?Q?V3jPHyLy0vjY1cvVVPCemcJNYJ69vc2Zm3y+HV0SJR4JW1XYhwflzzgXdMlD?=
 =?us-ascii?Q?oCYhWnnHSWImXN5PQzU1/PLkZuxL/TqVQMgcoQohyDXxcw/rHplBnI+4s2At?=
 =?us-ascii?Q?wnxLuhrvji8T88cLIVuUQFZoJNNX/CMdoCXoU9wDAQ+03/RYQQ3+UCU6I4KY?=
 =?us-ascii?Q?5Y3zF4oLxUM6awTMz88TGthCv4D5a6PUipojd7x0Nu7UGbqJ92BAkzUNUIma?=
 =?us-ascii?Q?o7vDlQb03+kdQDrbdtFDuQi/5qxH55BiqxFG9iOFQNWNmq4rlYHpe3KU/23r?=
 =?us-ascii?Q?R5dFVsiDjFsyycLOYIXtkaVvRpVDn+n77sitcAgw7R1w8JDM2mnyanKEG5w8?=
 =?us-ascii?Q?Cr56ifKBMKs9hmoOuplkWEmzZMob4OXmUyRWoRR/gXu74Xj/hb/6n6IoAJHO?=
 =?us-ascii?Q?JWKsj27OYfsx2cjS6KbraIx8HDYh3ovsQ9d5yzeeouDCrpGo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29deb23-400f-46be-cbe2-08de8f5f9619
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 19:56:23.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CABeFgj1DfeFa2N0cdn8V+r9HlWJPdG/SCnyO9VCdbF5qai8eGc24xm2hIAIkkHG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6823

The fixed commit assumed that the gather would always be populated if
an iotlb_sync was required.

arm-smmu-v3, amd, VT-d, riscv, s390, mtk all use information from the
gather during their iotlb_sync() and this approach works for them.

However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio,
apple-dart all ignore the gather during their iotlb_sync(). They
mostly issue a full flush.

Unfortunately the latter set of drivers often don't bother to add
anything to the gather since they don't intend on using it. Since the
core code now blocks gathers that were never filled, this caused those
drivers to stop getting their iotlb_sync() calls and breaks them.

Since it is impossible to tell the difference between gathers that are
empty because there is nothing to do and gathers that are empty
because they are not used, fill in the gathers for the missing cases.

io-pgtable might have intended to allow the driver to choose between
gather or immediate flush because it passed gather to
ops->tlb_add_page(), however no driver does anything with it.

mtk uses io-pgtable-arm-v7s but added the range to the gather in the
unmap callback. Move this into the io-pgtable-arm unmap itself. That
will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
ipmmu-vmsa).

arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
already have the gather population because SMMUv3 requires it, so it
becomes consistent.

Add a trivial gather population to io-pgtable-dart.

Add trivial populations to sprd, sun50i and virtio-iommu in their
unmap functions.

Fixes: 90c5def10bea ("iommu: Do not call drivers for empty gathers")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/r/8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/io-pgtable-arm.c  | 4 +++-
 drivers/iommu/io-pgtable-dart.c | 3 +++
 drivers/iommu/mtk_iommu.c       | 1 -
 drivers/iommu/sprd-iommu.c      | 1 +
 drivers/iommu/sun50i-iommu.c    | 1 +
 drivers/iommu/virtio-iommu.c    | 2 ++
 6 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0208e5897c299a..8572713a42ca29 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -666,9 +666,11 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 		/* Clear the remaining entries */
 		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
 
-		if (gather && !iommu_iotlb_gather_queued(gather))
+		if (gather && !iommu_iotlb_gather_queued(gather)) {
+			iommu_iotlb_gather_add_range(gather, iova, i * size);
 			for (int j = 0; j < i; j++)
 				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
+		}
 
 		return i * size;
 	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index cbc5d6aa2daa23..75d699dc28e7b0 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -330,6 +330,9 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		i++;
 	}
 
+	if (i && !iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_range(gather, iova, i * pgsize);
+
 	return i * pgsize;
 }
 
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2be990c108de2b..a2f80a92f51f2c 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -828,7 +828,6 @@ static size_t mtk_iommu_unmap(struct iommu_domain *domain,
 {
 	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
 
-	iommu_iotlb_gather_add_range(gather, iova, pgsize * pgcount);
 	return dom->iop->unmap_pages(dom->iop, iova, pgsize, pgcount, gather);
 }
 
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index c1a34445d244fb..893ea67d322644 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -340,6 +340,7 @@ static size_t sprd_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	spin_lock_irqsave(&dom->pgtlock, flags);
 	memset(pgt_base_iova, 0, pgcount * sizeof(u32));
 	spin_unlock_irqrestore(&dom->pgtlock, flags);
+	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
 
 	return size;
 }
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index be3f1ce696ba29..b9aa4bbc82acad 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -655,6 +655,7 @@ static size_t sun50i_iommu_unmap(struct iommu_domain *domain, unsigned long iova
 
 	memset(pte_addr, 0, sizeof(*pte_addr));
 	sun50i_table_flush(sun50i_domain, pte_addr, 1);
+	iommu_iotlb_gather_add_range(gather, iova, SZ_4K);
 
 	return SZ_4K;
 }
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 587fc13197f122..5865b8f6c6e67a 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -897,6 +897,8 @@ static size_t viommu_unmap_pages(struct iommu_domain *domain, unsigned long iova
 	if (unmapped < size)
 		return 0;
 
+	iommu_iotlb_gather_add_range(gather, iova, unmapped);
+
 	/* Device already removed all mappings after detach. */
 	if (!vdomain->nr_endpoints)
 		return unmapped;

base-commit: fcbe430399ca5c318e99bfda6df9beee90ab051c
-- 
2.43.0

