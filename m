Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010069.outbound.protection.outlook.com [52.101.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00737FF71;
	Wed, 12 Aug 2026 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565400; cv=fail; b=KfH9yRBdeZWcw++bxBv7f/1LblNHSw676sZm0JVLceGK29bUIDCFrotlS8VniXJu70nBHq7gCk/jtDVk18Hr2fgQ9kQm11Qa986soeI/QoRJ4HcRcN99pPc238nMDHeGozWoYRpVeuz6+wLdLP+4KwadB4jXem6PkaFxxcu96o4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565400; c=relaxed/simple;
	bh=gW1H8LpW5vYK3Aig8LadLCAEx1LWg3NticFJtFIb8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g0+qQQ+B0VfGV57Ztm40TQxUQIEi24PUrZ6rLc016NqZCso5VSwgsDUP1juIaMXp0Zq4Js3yC/ZiZ6nHdVZG64AoEdQ2lx+72CC+BNSSH9wzTtlHEi0Kf9bLcFnBtSHCE7QF5PX3vRqs5SR+LL0JxNEyF7EEqItH0l+UJL1Mr1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LZx9HfA0; arc=fail smtp.client-ip=52.101.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LZx9HfA0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bL6bg5T6uEq+93uEpX99BzG8uqqlJZOg2UGHxdZ5Xe6T8ntXNQ4hx65k49uzl3m7ZOSoA0LAnPEZBcj7uggG+lhwOU9GeNfGFZU3VraNcqfBdoGWeJhnx2YqhdR8jhyblRhEX23+FLwI1xMK2sM00ZStpfOQ6hEJsbcVO38DZicX4G+HLfxMsR11mMBQeNtbHwotbUyolsW4Ilyl2LO74GH+3Y1y81jeMQy5TeK793wNTKwIeqsKgL8DJh/oPGHgJbLY+fx62nBdnBAMdFn3YQyT6sMmUU4aTvhPjxv1yWBYVt/2ezkmmeO+EQm6qesMZf8pr007HWpgmFPOj5Uagg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zzb2a83VW/3u/JpyuD64jHkz/AXTBm7sYoqu1i7NL6g=;
 b=CP+LXOkCuQU4b5KEN0VFa2kTbhFgf3TBQ+ZLfzd+RKrPIXlDobgRHjdPWZuran66BfdvP7CillyB1angWH7lbeqMbFFXEpcELo0OuX2jeR04FmBBcEgQG+tkJarNpnzDIqV9FAPJUdqgF0Lyt9QkTZJDPKD37He9T6izVj7d/grEJq+KoK3eBkF0aRpX+HByi3OUKg+rwI86s9+v4IiRHt6YvckVWq4bLo634A03LLiMduVvS0ZCf6fkbsodJ5kt7pRx/5w00PeEAJQTex9dkVhqLnjTYVgTOAxAc6uoD6jC3Q1ql8ZCq91zbE0weKTocAqC9Z7eMmXMIFMiJbYIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zzb2a83VW/3u/JpyuD64jHkz/AXTBm7sYoqu1i7NL6g=;
 b=LZx9HfA0R7CC+hpLy8TI0NM2smlJdo/v8C7OTJGZC5ETSk31sJYNbDw4DHx0XL/68WPWzkWJN1RkmAtR9WOWHfUvObg0tV0o/9ASPbLdgeCjjpiJ49XwMAxPDv1IK3kEJI/jxMubZbDB/YtXPTQwkdWnbqGMviBRoQvX1nuzAlfZhA4A/KaALscf+PYm2Cw+5bAEPkHwpHvzuF6/97wGUei5/p8a9dF+vQJx90emXEhro+rfnCxkCjvK7w565nYhl4nCzeN9ufWq4TmbDdMH93Psdnv9j9Cfb2Gi9+fR2DJ722Khl2m4AiTv4n2QYhFdmw7Z7TdPfaWnfsJJyEOAQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 12 Aug
 2026 20:09:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 8/9] iommu/arm-smmu-v3: Use the generic iommu page table
Date: Wed, 12 Aug 2026 17:09:24 -0300
Message-ID: <8-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 8edcba46-6268-48d9-68fc-08def8ad9de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|5023799004|11063799006|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lPpXtualLiXfTtgH1LRbLkwa25WJgHhIoJ3ogmhvVU7TfxGkJGMpogsuz85ki+wTAds5cnto8sEEUBU9j2Q0/o9c19/eEr9Vyha70A4bohv9oc9QWngpDDV8D+/RUtDwxCnT0YalYUImgKFMX1p1GXPjqbFXPLB01WhPHV6Yc0BulKvcg8mC750lJYyRkCmfm0GAb2zBvj2ziZdBsemfISrbEuMO+PodZm7+DwO52QS5yKNDTwp+zbatGckol5xUqwW4mwPbbpdlqcJNy52e0c0JzTDa7hYpkPc52QexJjkWJ9gnkUk4iPkJZrmwFjgLTmzJZGr68DE7GGzP7wr7qsHb+YYen6nCiclnon4Ro7xEL6WVhJRh7F6I+ZN35/NAn0zTLAI+3U0ZaqDYxuVHlSkrirCRPlQBi1dLfhE4rcJXjei3wFt8xMHgmb0+KknXZb68CcW4HnGhRgh5D4KuDMKZh21exUYsS3CWC7u2wByKzxuqvP0eEVYTYSx0D3zRHQGX8nSu4jlUO1QfYQf+z5CrpmIOOCvc80vupXbLmmUH17APVUkwwFpXf5t7dQ2i9vWlejzQ+qIuvaS9zBgTtEOPmIG0x0tWahgpapKYHVn46dgmKIUs95SUQDHzPzqK8gDwWUYrSrJHJV24VMKCrvVzaeIXp6Gu7Pj4R+EVvT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(5023799004)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wm0Vh/oaUY15rzlJW8wll2dMRSULHBoNk6v0kHsNVU9fa3N1DmGJ3qzLb8mb?=
 =?us-ascii?Q?aHkXQaMzPVa9tZSxP/Tqs0yIWlo6djpSGu5dhmvMB0ajBa1zMGzZkCrwy+AM?=
 =?us-ascii?Q?qwwvknVVNzlXslr7/QcganhU5v3axZc68zNlHa9QSeoTksldpON8QQ7pYXRY?=
 =?us-ascii?Q?V21ohhT7AXk1ichIPZItsuUJ1LMShkthhht6rhnUxfw8DqXdUHLbFZsnp9rb?=
 =?us-ascii?Q?R87FWxb/QdCyxsv9NOUAhh794dqGBl7OXSfRdaetziOtO43sgHtIosT/c7Ho?=
 =?us-ascii?Q?+n3jaFVZMEdA8rNmaAVaOJ6lEDsOYIK1wdR18mcuulo5xDPkb5Rv+1POVDXN?=
 =?us-ascii?Q?i9NvHWgIa76e0G5fUswP7ySvHPnOSX408N6gsAAxJu/kLcPkAAJkZxJae1HX?=
 =?us-ascii?Q?rRPxpGsG9LOlKYYphcIUpZznONy53lK01a81NJ6gphmq3/055K6S69x1n0p7?=
 =?us-ascii?Q?tpsJ+jxHSELWml9ZywHZvACvYktQcyjQiYjlpXS/vIZL08BDeNBuBzsVSfL5?=
 =?us-ascii?Q?Uzlr6XGiXug4YZt1uFWBX8nMuEB8DOJsyjzIAF98pgNStcE72PWelhzSKlUR?=
 =?us-ascii?Q?K9Nw/Q6PtQosoESJIKm0iyEYQV5tOLHG1UlbdDUmLUNqUZaHqW9+Po6mCB7P?=
 =?us-ascii?Q?3xOKO4utW1noLI9fdjQmxt164WxzaoAfWhTcXTohwwg3mXLMg4b5cChkVFPN?=
 =?us-ascii?Q?OK28P2DKXkUnxaagpIbSwSQ5QMeWIhMk+Uv5lcozqBwB+nHAnFEYnt/GaqfU?=
 =?us-ascii?Q?EGx7vBzA9GUVra4JI+ZSTtF1RonO6+i/mSKrKfI6Ef5cBhsKxJRogAmqcXDh?=
 =?us-ascii?Q?gTtRSIYe9eAc4OxL7V3N+ygx93sEgPFEWDQ0yXetCBGLLyZb595MEMexyQqC?=
 =?us-ascii?Q?76ZdeVTiHpewpBJERPG4EObMznKlupcXk2w0PEHwaXyRSXf3GyB8rI3fSHSp?=
 =?us-ascii?Q?vVps1wtDva2wrd6g7gs4Veu9X93YzWvWqagvJ+2ebDA6h94WfJKZgfPIo7LM?=
 =?us-ascii?Q?ULpSzA2Q+RGuip+l9nuiAhp8Whv7h+mZdakf9Umyd4pqedSSjrdzWeJmTkqV?=
 =?us-ascii?Q?x04ZR41r4tll2BIjBcQTXTFuZtObQppjTCv9vptKaoghyzonnCtcjy4Ml2YV?=
 =?us-ascii?Q?Jv/QDxtcejDfndYXZZx+EAs32A8e6gqJ3bvsnrL3EcjPVwinKprDRHIuk5+f?=
 =?us-ascii?Q?ezUUkTweFkeNepiTyX+A66zetwb3uwKScnbIYQ8pbOCWt4koR4mZaxfqs/GM?=
 =?us-ascii?Q?RWoBENw5p7hK4RyTDJkGUBZ/O2uJr/sEEkimYeroOIDby5JZpUtsM8C2KK5b?=
 =?us-ascii?Q?QXmqXlqvI5PNJnUXXMKkuVzN/jd+RlTkalTf3ssCIK+G6lNyWgmQS6Y+WJVF?=
 =?us-ascii?Q?r1lv7rsSiItS5CInwu8LR/GdFWuGFXl85M6hgXdr4kVCisXhVEujMy9Mx116?=
 =?us-ascii?Q?Tzreel0eVycEHBs08TprdYgDjWvsgOeQI/rfD8bZEsUI0FSELAjuuhAWP/aU?=
 =?us-ascii?Q?Q6iAyvq07+/iA6H569h3YL65iCdfnNPiy1g1RjdjMJq0PoJaxcHaZCNuQvHb?=
 =?us-ascii?Q?5q2ejtuH/O8CwCTbYFhpMgFWUx2INjO4A1X+xXHiwR2X8DbydRyW4bdMo3ly?=
 =?us-ascii?Q?QpNbITjGDksBB/pMA/A2SQJg90m7rpU2W1/xMWJ8my4RfQlIfLfnvb26kzd0?=
 =?us-ascii?Q?AoQR9gu+PRdhJjlLWuEoA2aYV4MXsHiVkP9SmLlEEKiLDA30hBEEyUy3jAlm?=
 =?us-ascii?Q?sVy/tBbXvQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edcba46-6268-48d9-68fc-08def8ad9de9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:29.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFVSHFxh8vAWxtL+f3woQzDOcx5I+rxWbp5H8a0aT/b3Zw74wU6pc9X7TEZHApz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121

Switch to use the iommupt provided page table. This is fairly
straightforward now since the page table construction and hwinfo are very
similar to io-pgtable-arm.

The struct pt_iommu_armv8_hw_info is a direct replacement for 'tcr' and I
have a kunit compare test validating that the fields have identical values
for identical configurations.

Quirks are replaced by features
 IO_PGTABLE_QUIRK_ARM_HD -> PT_FEAT_ARMV8_DBM
 IO_PGTABLE_QUIRK_ARM_S2FWB -> PT_FEAT_ARMV8_S2FWB

SMMU features are mapped to iommupt features:
 ARM_SMMU_FEAT_COHERENCY -> PT_FEAT_DMA_INCOHERENT
 ARM_SMMU_FEAT_VAX -> PT_FEAT_ARMV8_LVA
 ARM_SMMU_FEAT_S2FWB -> PT_FEAT_ARMV8_S2FWB

Remove the iommu_flush_ops entirely, iommupt only uses gathers for
invalidation. Wire the tlbi directly to the gather.

Remove the trampoline for map/unmap/iova/read_and_clear_dirt. iommupt
directly provides the domain ops. Domain initialization is largely moved
into iommupt common code.

Change the kunit to fully create a page table to generate the tcr bits for
testing.

Compared to io-pgtable-arm iommupt has a number of key differences:
 - CONT support, including always using RIL to avoid errata 3673557
 - Unmap yields a single gather which generates a single tlbi operation
    * free_list is always used to free after invalidate
    * walk cache and leaf invalidation are combined for non-RIL cases
      instead of being duplicated
    * non-RIL cut over to all-invalidate covers walk invalidation now too,
      umap -> single gather -> single all invalidate.
    * RIL flushes the walk cache and leafs together with a good TTL hint.
    * RIL always generates one command from any gather.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/Kconfig                     |   4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  45 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 261 ++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  11 +-
 4 files changed, 111 insertions(+), 210 deletions(-)

diff --git a/drivers/iommu/arm/Kconfig b/drivers/iommu/arm/Kconfig
index 5fac08b89deea7..495b03ad3cf6c1 100644
--- a/drivers/iommu/arm/Kconfig
+++ b/drivers/iommu/arm/Kconfig
@@ -77,7 +77,9 @@ config ARM_SMMU_V3
 	tristate "ARM Ltd. System MMU Version 3 (SMMUv3) Support"
 	depends on ARM64
 	select IOMMU_API
-	select IOMMU_IO_PGTABLE_LPAE
+	select GENERIC_PT
+	select IOMMU_PT
+	select IOMMU_PT_ARMV8
 	select GENERIC_MSI_IRQ
 	select IOMMUFD_DRIVER if IOMMUFD
 	help
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 785dd21bd68b7a..658b12d52b7a9b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -3,7 +3,7 @@
  * Copyright 2024 Google LLC.
  */
 #include <kunit/test.h>
-#include <linux/io-pgtable.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "arm-smmu-v3.h"
 
@@ -343,21 +343,21 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 		.stall_enabled = stall_enabled,
 	};
-	struct io_pgtable io_pgtable = {};
-	struct arm_smmu_domain smmu_domain = {
-		.pgtbl_ops = &io_pgtable.ops,
+	struct arm_smmu_domain smmu_domain = {};
+	struct pt_iommu_armv8_cfg cfg = {
+		.tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2) |
+				   BIT(PT_FEAT_DETAILED_GATHER),
+		.common.hw_max_vasz_lg2 = 40,
+		.common.hw_max_oasz_lg2 = 40,
 	};
+	int ret;
 
-	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tg = 2;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sh = 3;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.orgn = 1;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.irgn = 2;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
-	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
+	ret = pt_iommu_armv8_init(&smmu_domain.armv8pt, &cfg, GFP_KERNEL);
+	WARN_ON(ret);
 
 	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
+	pt_iommu_deinit(&smmu_domain.armv8pt.iommu);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
@@ -495,24 +495,24 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
 	};
-	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
-		.pgtbl_ops = &io_pgtable.ops,
 		.cd = {
 			.asid = asid,
 		},
 	};
+	struct pt_iommu_armv8_cfg cfg = {
+		.tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_DETAILED_GATHER),
+		.common.hw_max_vasz_lg2 = 40,
+		.common.hw_max_oasz_lg2 = 40,
+	};
+	int ret;
 
-	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tg = 2;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.sh = 3;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.orgn = 1;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.irgn = 2;
-	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
-	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
+	ret = pt_iommu_armv8_init(&smmu_domain.armv8pt, &cfg, GFP_KERNEL);
+	WARN_ON(ret);
 
 	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+	pt_iommu_deinit(&smmu_domain.armv8pt.iommu);
 }
 
 static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
@@ -815,5 +815,6 @@ static struct kunit_suite arm_smmu_v3_test_module = {
 kunit_test_suites(&arm_smmu_v3_test_module);
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
 MODULE_DESCRIPTION("KUnit tests for arm-smmu-v3 driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f2e4b66ebf1ce5..618b42ef4f630c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -16,9 +16,11 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/io-pgtable.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/jump_label.h>
+
+#include "../../iommu-pages.h"
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of.h>
@@ -1661,25 +1663,24 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	const struct io_pgtable_cfg *pgtbl_cfg =
-		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
-		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
+	struct pt_iommu_armv8_hw_info info;
+
+	pt_iommu_armv8_hw_info(&smmu_domain->armv8pt, &info);
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, info.tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, info.tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, info.irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, info.orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, info.sh) |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
 		CTXDESC_CD_0_TCR_EPD1 |
 		CTXDESC_CD_0_V |
-		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, info.ps) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1688,14 +1689,12 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
 
-	/* To enable dirty flag update, set both Access flag and dirty state update */
-	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_HD)
+	if (smmu_domain->armv8pt.armpt.common.features & BIT(PT_FEAT_ARMV8_DBM))
 		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HA |
 					       CTXDESC_CD_0_TCR_HD);
 
-	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
-				      CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
+	target->data[1] = cpu_to_le64(info.ttb & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(info.s1.mair);
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s1_cd);
 
@@ -1953,13 +1952,12 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
-	const struct io_pgtable_cfg *pgtbl_cfg =
-		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
-		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	struct pt_iommu_armv8_hw_info info;
 	u64 vtcr_val;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	pt_iommu_armv8_hw_info(&smmu_domain->armv8pt, &info);
+
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
 		STRTAB_STE_0_V |
@@ -1969,19 +1967,20 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
-	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+	if (smmu_domain->armv8pt.armpt.common.features &
+	    BIT(PT_FEAT_ARMV8_S2FWB))
 		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
 
-	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, info.tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, info.s2.sl0) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, info.irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, info.orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, info.sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, info.tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, info.ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
@@ -1993,8 +1992,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		(master->stall_enabled ? STRTAB_STE_2_S2S : 0) |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
-				      STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(info.ttb & STRTAB_STE_3_S2TTB_MASK);
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
@@ -2452,16 +2450,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-/* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-
-	arm_smmu_domain_inv(smmu_domain);
-}
-
 /*
- * Check address alignment for TTL hint per SMMUv3 F.b Section 4.4.1.
+ * Check address alignment for TTL hint per SMMUv3 H.a Section 4.4.1.1.
  * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
  */
 static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
@@ -2571,8 +2561,8 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 */
 	if (num_tg == 1) {
 		/*
-		 * The two io-pgtable ops filling the tlbi won't generate ttl=0.
-		 * sva sets constants for single page that give ttl=3
+		 * iommupt won't generate a malformed gather and sva sets
+		 * constants for single page that give ttl=3
 		 */
 		if (WARN_ON(!ttl))
 			ttl = 3;
@@ -2871,45 +2861,6 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	rcu_read_unlock();
 }
 
-static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
-					 unsigned long iova, size_t granule,
-					 void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-	struct iommu_domain *domain = &smmu_domain->domain;
-
-	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
-}
-
-/*
- * Called by io-pgtable-arm.c for each single table level it wants to remove.
- * size is the size of the table level and granule is the tg in bytes. This must
- * clear the walk cache and any leaves within the range.
- */
-static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
-				  size_t granule, void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
-	struct arm_smmu_tlbi tlbi = {
-		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.start = iova,
-		.last = iova + size - 1,
-	};
-	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
-
-	tlbi.table_levels_bitmap = table_levels;
-	tlbi.leaf_levels_bitmap = table_levels - 1;
-
-	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
-}
-
-static const struct iommu_flush_ops arm_smmu_flush_ops = {
-	.tlb_flush_all	= arm_smmu_tlb_inv_context,
-	.tlb_flush_walk = arm_smmu_tlb_inv_walk,
-	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
-};
-
 static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
 {
 	u32 features = (ARM_SMMU_FEAT_HD | ARM_SMMU_FEAT_COHERENCY);
@@ -2929,7 +2880,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return arm_smmu_master_canwbs(master);
 	case IOMMU_CAP_NOEXEC:
-	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
 	case IOMMU_CAP_DIRTY_TRACKING:
 		return arm_smmu_dbm_capable(master->smmu);
@@ -2987,7 +2937,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	pt_iommu_deinit(&smmu_domain->armv8pt.iommu);
 
 	/* Free the ASID or VMID */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
@@ -3040,66 +2990,69 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu, u32 flags)
 {
 	int ret;
-	enum io_pgtable_fmt fmt;
-	struct io_pgtable_cfg pgtbl_cfg;
-	struct io_pgtable_ops *pgtbl_ops;
+	struct pt_iommu_armv8_cfg cfg = {};
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
 				 struct arm_smmu_domain *smmu_domain);
 	bool enable_dirty = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 
-	pgtbl_cfg = (struct io_pgtable_cfg) {
-		.pgsize_bitmap	= smmu->pgsize_bitmap,
-		.coherent_walk	= smmu->features & ARM_SMMU_FEAT_COHERENCY,
-		.tlb		= &arm_smmu_flush_ops,
-		.iommu_dev	= smmu->dev,
-	};
+	cfg.tgsz_lg2 =
+		pt_iommu_armv8_choose_granule_lg2sz(smmu->pgsize_bitmap);
+	if (!cfg.tgsz_lg2)
+		return -EOPNOTSUPP;
+
+	cfg.common.features |= BIT(PT_FEAT_DETAILED_GATHER);
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1: {
-		unsigned long ias = (smmu->features &
-				     ARM_SMMU_FEAT_VAX) ? 52 : 48;
-
-		pgtbl_cfg.ias = min_t(unsigned long, ias, VA_BITS);
-		pgtbl_cfg.oas = smmu->oas;
-		if (enable_dirty)
-			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
-		fmt = ARM_64_LPAE_S1;
+	case ARM_SMMU_DOMAIN_S1:
+		/*
+		 * Historically FEAT_VAX maps to LVA behavior in the io-pgtable.
+		 * IDRs should be decoded more completely to select
+		 * LVA/LPA/LPA2.
+		 */
+		if (smmu->features & ARM_SMMU_FEAT_VAX &&
+		    cfg.tgsz_lg2 == 16) {
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_LVA);
+			cfg.common.hw_max_vasz_lg2 = 52;
+		} else {
+			cfg.common.hw_max_vasz_lg2 = 48;
+		}
+		cfg.common.hw_max_oasz_lg2 = smmu->oas;
+		if (enable_dirty) {
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_DBM);
+			smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
+		}
 		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
-	}
 	case ARM_SMMU_DOMAIN_S2:
 		if (enable_dirty)
 			return -EOPNOTSUPP;
-		pgtbl_cfg.ias = smmu->oas;
-		pgtbl_cfg.oas = smmu->oas;
-		fmt = ARM_64_LPAE_S2;
-		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		cfg.common.features |= BIT(PT_FEAT_ARMV8_S2);
+		cfg.common.hw_max_vasz_lg2 = smmu->oas;
+		cfg.common.hw_max_oasz_lg2 = smmu->oas;
 		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
 		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
-			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
+			cfg.common.features |= BIT(PT_FEAT_ARMV8_S2FWB);
+		finalise_stage_fn = arm_smmu_domain_finalise_s2;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	pgtbl_ops = alloc_io_pgtable_ops(fmt, &pgtbl_cfg, smmu_domain);
-	if (!pgtbl_ops)
-		return -ENOMEM;
+	smmu_domain->armv8pt.iommu.iommu_device = smmu->dev;
+	ret = pt_iommu_armv8_init(&smmu_domain->armv8pt, &cfg, GFP_KERNEL);
+	if (ret)
+		return ret;
 
-	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
-	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
-	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
-	smmu_domain->domain.geometry.force_aperture = true;
-	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
-		smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
+	smmu_domain->tgsz_lg2 = cfg.tgsz_lg2;
 
 	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
-		free_io_pgtable_ops(pgtbl_ops);
+		pt_iommu_deinit(&smmu_domain->armv8pt.iommu);
 		return ret;
 	}
 
-	smmu_domain->pgtbl_ops = pgtbl_ops;
 	smmu_domain->smmu = smmu;
 	return 0;
 }
@@ -4120,7 +4073,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		goto err_free;
 	}
 
-	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, smmu, flags);
 	if (ret)
@@ -4132,31 +4084,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	return ERR_PTR(ret);
 }
 
-static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
-			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			      int prot, gfp_t gfp, size_t *mapped)
-{
-	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
-
-	if (!ops)
-		return -ENODEV;
-
-	return ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
-}
-
-static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long iova,
-				   size_t pgsize, size_t pgcount,
-				   struct iommu_iotlb_gather *gather)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
-
-	if (!ops)
-		return 0;
-
-	return ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
-}
-
 static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -4178,43 +4105,23 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 	 */
 
 	if (smmu_domain->smmu)
-		arm_smmu_tlb_inv_context(smmu_domain);
+		arm_smmu_domain_inv(smmu_domain);
 }
 
-/*
- * Called by io-pgtable-arm.c for each run of same pgsize leaf only
- * invalidation. If it has to change to a different leaf level then it flushes
- * the gather and starts a fresh one. Thus this always targets only a single
- * leaf level.
- */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.start = gather->start,
 		.last = gather->end,
+		.leaf_levels_bitmap = gather->pt.leaf_levels_bitmap,
+		.table_levels_bitmap = gather->pt.table_levels_bitmap,
 	};
 
-	if (WARN_ON(gather->pgsize < BIT(tg)))
-		return;
-
-	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
-
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
-}
-
-static phys_addr_t
-arm_smmu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
-{
-	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
-
-	if (!ops)
-		return 0;
-
-	return ops->iova_to_phys(ops, iova);
+	iommu_put_pages_list(&gather->freelist);
 }
 
 static struct platform_driver arm_smmu_driver;
@@ -4466,17 +4373,6 @@ static void arm_smmu_release_device(struct device *dev)
 	kfree(master);
 }
 
-static int arm_smmu_read_and_clear_dirty(struct iommu_domain *domain,
-					 unsigned long iova, size_t size,
-					 unsigned long flags,
-					 struct iommu_dirty_bitmap *dirty)
-{
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
-
-	return ops->read_and_clear_dirty(ops, iova, size, flags, dirty);
-}
-
 static int arm_smmu_set_dirty_tracking(struct iommu_domain *domain,
 				       bool enabled)
 {
@@ -4566,20 +4462,18 @@ static const struct iommu_ops arm_smmu_ops = {
 	.user_pasid_table	= 1,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
+		IOMMU_PT_DOMAIN_OPS(armv8),
 		.attach_dev		= arm_smmu_attach_dev,
 		.enforce_cache_coherency = arm_smmu_enforce_cache_coherency,
 		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
-		.map_pages		= arm_smmu_map_pages,
-		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
 		.iotlb_sync		= arm_smmu_iotlb_sync,
-		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
 static struct iommu_dirty_ops arm_smmu_dirty_ops = {
-	.read_and_clear_dirty	= arm_smmu_read_and_clear_dirty,
+	IOMMU_PT_DIRTY_OPS(armv8),
 	.set_dirty_tracking     = arm_smmu_set_dirty_tracking,
 };
 
@@ -5236,7 +5130,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/*
 	 * Translation table endianness.
 	 * We currently require the same endianness as the CPU, but this
-	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 * could be changed later by adding a new feature flag.
 	 */
 	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
 	case IDR0_TTENDIAN_MIXED:
@@ -5836,4 +5730,5 @@ module_driver(arm_smmu_driver, platform_driver_register,
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMUv3 implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
 MODULE_ALIAS("platform:arm-smmu-v3");
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index fc4fe43d7fe53b..0ab47e4e51726d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -9,6 +9,7 @@
 #define _ARM_SMMU_V3_H
 
 #include <linux/bitfield.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kernel.h>
@@ -1066,9 +1067,12 @@ enum arm_smmu_domain_stage {
 };
 
 struct arm_smmu_domain {
-	struct arm_smmu_device		*smmu;
+	union {
+		struct iommu_domain	domain;
+		struct pt_iommu_armv8	armv8pt;
+	};
 
-	struct io_pgtable_ops		*pgtbl_ops;
+	struct arm_smmu_device		*smmu;
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
@@ -1077,8 +1081,6 @@ struct arm_smmu_domain {
 		struct arm_smmu_s2_cfg		s2_cfg;
 	};
 
-	struct iommu_domain		domain;
-
 	struct arm_smmu_invs __rcu	*invs;
 
 	/* List of struct arm_smmu_master_domain */
@@ -1090,6 +1092,7 @@ struct arm_smmu_domain {
 
 	struct mmu_notifier		mmu_notifier;
 };
+PT_IOMMU_CHECK_DOMAIN(struct arm_smmu_domain, armv8pt.iommu, domain);
 
 struct arm_smmu_nested_domain {
 	struct iommu_domain domain;
-- 
2.43.0

