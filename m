Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301F34314A6;
	Mon,  6 Jul 2026 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355387; cv=fail; b=NpONlK0+KRJdCm+uK+mg0ArvE9FhFzQHnrVOZaQwTJU0IBSVZCO2kcGgK9NbdiGVeyzxUAzoMa8hHKV474qm2xr1xw/QsVY5wmVUXVkiTPLIQYZNKO2HkEBYvpfOFZe5QWsL+D9+bpiwdJbcIyDSxlvuNOxgx9tGei7VlJrMAF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355387; c=relaxed/simple;
	bh=/e9ypqlzAG7AaJP/h+VfAU/2mYxj/O9BziwPPhYdqOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O8UQaHayhf3uqNhvAIRteMASFPJTK3T6eOifY8q6f/mo3fzYQ57s1hFYt7tr5A83KiyLZGko4D/GYH0v7U3QR1aZMmOpeGeFvQaJIaz9Omb/AbiWSIrMWguzD3xyPMv+a2zXTHwBfyEVoNn/X0LDSu59IVQUIRg/rshR49GvPoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=utkGMbFL; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="utkGMbFL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PhGKiQQbMbkAtEOBbYo/712+2GuF7ug33AGy6MT2Zy9hwJCQKNI3aRm31348yILr0guoPgKXdpGtBOh/WR2kuYWMe8OnVZa0qOR7rCkpXg96C1X8cCPQqWPekp7b9VhTpkL/h7kZ2w1Sq133akxUA2huAHwRH8XUGUzGqibLOrokrnQzh6hOSK2IqdLUDrGVLNyeX0I3pB+DErlAEq4CXH2btCYeBHsK5qGWsf7p7zff8hwccZbH5vrwVlg4nb+A4LWjQUZWNDuhvDM0ONzYaUSGRKQvinVoQdEoDRQ0z94CT+SGPANGmeogO3IufFtwreIbrSkZ6coedWcOOEPfAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlCV/x6TwxpUb636pC2jFtebM66sCn/hfgBecUVcyMM=;
 b=c+nxMuTzw7IbXYb6IAcEel8ZIRodKDLjJmeualBA3UivIzP5hL2CJVWyn+zYEojZJ9J9KhwvD9YR5xPUst3BgMrzrPozWL3L4JwzWMZIQryjXwASvuw7j/gB7aPAan+TvigRglZOHDJPZUm2tulxCfdBrOIJJ4G9SZdh4RVQcN7fL95koFvEh+Q91aJpgV5LYi1VzEWn/onRLJcF3kqDCJE+kDOsCLmlpbVWYvNPTvCzKof1j98Vr/V6vWylYhbgF8x/QlKlXbnjnHsnwYBY/b+TYzurDSTWP5OE6SpiDgKRTxGvGYG/+lCtmxcn9Zuhz4VWmy8LxCaZDL4Qhit+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlCV/x6TwxpUb636pC2jFtebM66sCn/hfgBecUVcyMM=;
 b=utkGMbFLGjjA7ZUN4a5KboJ5jp/zkpHVHtiInIrn3/XyYVYG895hrEqf/hBJRH2ogY5/hJkfI9tpiU+LUEzWgKUL5znbuXiPPG/ItWf2jTzVpSR4DnUHlA5s3KLyp78FbnoIGDQdwpUMhZB1oB/OaZI1TRtvVZRP+LzCV18l9V4tdtz03pxZQurfvTOFrZTPFtMWfn2s4kZKtT8vkrByxZykgun+SOlm4rz0KtqvGWEnbZuSkskN+qhMHXZnqpVbPCItPbSgRxkyBEhBdA1furWtLEmArxIWuBXoTWinIHePUIXuc67sRPjZfhiXZIjwY4BRVj7BEvnQM1hBUJNdUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:21 +0000
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
Subject: [PATCH 6/7] iommu/arm-smmu-v3: Use the generic iommu page table
Date: Mon,  6 Jul 2026 13:29:12 -0300
Message-ID: <6-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0057.namprd20.prod.outlook.com
 (2603:10b6:208:235::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 525809e9-849a-4b01-4598-08dedb7bb998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|5023799004|11063799006|22082099003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	/bIDVgpZYyGRdf47oOy7oCBl/pOzPLm2t2UB2QKFiIxnX87jiNaD26oB5uVOWhm1zoIfWIjK8BFduss+Zf/RWeyMjlOFYbv25xMjAiyw1+pO4yZz206p7CEvhcRFJJOi1SWaLJ2HBQGkMu0JlyWAeY61E5GQ7Fwx1HrTSCN4KnIDemgnstVA5nPYERwySTsvq1wt+Kv4omplurncyGJAOtzj+aNpHgXzU8ABQv90Czht9GqCgD8LDUqrHLYovOq9jPUfSboWeMpgYI+cDUv2ftWR+0THIJzAweXiwn4YWQMlUL+K+LgcbDTcJmbA49mtzIS4mVd88s/BWkFT2427QmttkHW9qjpvwkpdSTTy3LvFLsJVY1Ls76/zvd8miwCrb/vW0nD/GKK3xjGg8Pm0eVb2lu1NJP0wTr+9jFocwqOp1gMVTv5AH7s490TdfRP8T7gEYTlOKvr9WfV0QdAgc+cfSpY954tHdqACBv+3ezAD8q0rFsXcKjEIFwmEmb4yV5LW1LYYDd7wonAiRITLFERejMb1bDAx5lLUkDgUs0BHNsXnAVgGKuHYkaVkCKbJAd5flz8t+Ojws3yS2PK30EfFhe9bdlQAk6ACYdLRtGf322Awy+kCv5yYknQoLzCHEUgg5osXCGFvwigOS32uv0JyfqYap2lGUOQXPWHDrDI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(5023799004)(11063799006)(22082099003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yix8NqqsPuGmIvdFhGNT3ZPaex5LrLltFHHqCtSwLzxrxIE4ybKsAYdegdzI?=
 =?us-ascii?Q?Nt1c1XMNTw31XnDbpQ6oCmFDOdEIXX5652fgYNnWFq0OQuPqrKH6h/czjmEx?=
 =?us-ascii?Q?fmbpr1XPcg2Mudm5wHjnaSQYeMSGRBKAl3DdY3jHnZr04Pun3Eqgk2o6cZ/Y?=
 =?us-ascii?Q?HjcpnKNWeN5bnntjQBQlThRpESJaiJ40jB1zU/T4Wz0UcZaBYZR2K9knmu2l?=
 =?us-ascii?Q?g50JFd7V0oZrjOx2WS4NYF3xf+OtX2b1d64mlAgC2P4jY4ToS8BEwS3k0Thw?=
 =?us-ascii?Q?LICxx6Rf24WbfYxItFK2i9G+JWIvbHrD6Q8ai72/j+0Lp0S1dj4JZZEB5c5n?=
 =?us-ascii?Q?RDafkMpiN6awHMtt5hT3AE4NK7j5PBLk9v6GZJdzDjiKwSPVS+WGwipKDGzk?=
 =?us-ascii?Q?JukELe9v8zBeJyyh0zToa0rNmGj5MGLa80h3u94OMsglCMndmrsmYQXRgLIp?=
 =?us-ascii?Q?JTM9N9gfYBIR9lqwFMs36+877frk61O6hUhY/J7oMKQQ6M68WsELjN4Q6f3L?=
 =?us-ascii?Q?BflXrz+szZtE05uiJgyu/xEVbXks/RGljWuiu2SS9C7UH3CPLkIDnSnCzBU9?=
 =?us-ascii?Q?oqx0zPrm92zt2gkIvaw+zeoj09AiKncakCBeOQ4wRhPYmRaRYQgHKckl+t/R?=
 =?us-ascii?Q?TEOel73f2l5Lxee0eIJl2OhFFxyXjOMkpv6wzFqJymbNnM/h84C3KtbtWIua?=
 =?us-ascii?Q?j3UgCu6MVSqPL88F9l+98zabtw6KDk9sWNKAxg3RfPQPK6pAVGRPsJc3x+T9?=
 =?us-ascii?Q?maN+7P9Kdk9uVyTj+mDoJo+kUSW5xvfLWAZ3v2z07bl96bzhZSQB106A4M3L?=
 =?us-ascii?Q?jvBsaGBoccfu6mtePV/qyKp/jZ0ZzYxriIaO98M6JOnAwx+QiMvkS2Wz/vWD?=
 =?us-ascii?Q?r+hui43Mk8o6VNMf9lFMVP1J/w2OvwVG1x7eVavh27ShZr2TezH1SIeeHM4S?=
 =?us-ascii?Q?/0heXhGPfDIVgiVpahO5EEvHZXSTVwpCqDCZrK385XIkVUtrMbZAcuZ/BIvZ?=
 =?us-ascii?Q?jB1bhjerPgLE4yf4FSEIkt4EjezhDPJjRzLkUqUoSvIxpJQ1S8uJ+OO5ka/p?=
 =?us-ascii?Q?5UZv+8SIUvgGeYtgPDnG+prf/vCF6hHjoG1/s6aeeN9G2syBnW0QCtqnIvBn?=
 =?us-ascii?Q?t8ucYMCmZ5/+xeL4VHpfUvzUULFqQlcLPZzaQTpKIxFUTbnys8jbgyf0VJgx?=
 =?us-ascii?Q?jZUX05JVnkyQS9Ye81qgJV/xZdATg3y9nsWMYZ1+ja0PBTXwZjjtehxKkjUG?=
 =?us-ascii?Q?mN3aYZKnSwi2+LJhfKTZIBGvFRB8n01pfrY9jbFkD4WvodvexaRqq/KWsgHu?=
 =?us-ascii?Q?7bHHdbglS30GmMl3BMqUSduJEAHJSf0Y7T4ZeQZxss7rXxger/Pe4nwqEy7i?=
 =?us-ascii?Q?xIfh2LoCF4afjUYTwK2WBtUYBEQw5bM5j0VPrCRoZGf9GaKhZLuaVjvbvg4N?=
 =?us-ascii?Q?DYxVxTIt8IFbuoeEhJx03qCsOsJri6Ts+tRXQF9GDqa7iWCwVZ1inteKxlqf?=
 =?us-ascii?Q?NuWWdTBuqJiD5Yub6J79JcjWwhWCPdcF3TfeIq5OILfnC7oXWe8NSkksSRCn?=
 =?us-ascii?Q?31JzQN26ZVL8l8azOO0m/8fbu246NmmIgFtpYvHPE1RAcpU2UM3PQbl9qzwZ?=
 =?us-ascii?Q?8xSJozsCEvtB+/rcqmLks79JS/PubrGvPwREQEdxW53OJQ0y0NKu/TmPFEeH?=
 =?us-ascii?Q?VhgjVJqyAeItkJIC/O/XUZuBa3UUDSFvjwcmnC5b6frssdmD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 525809e9-849a-4b01-4598-08dedb7bb998
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:17.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kL9EiJiUMIPi1HUg0kxo3vWr3JW0GEIdZFSCPQOtWlVH1eh1K9MMZqwIM2T8llV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 256 ++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  11 +-
 4 files changed, 110 insertions(+), 206 deletions(-)

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
index 785dd21bd68b7a..0a18e292d7748c 100644
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
+		.granule_lg2sz = 12,
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
+		.granule_lg2sz = 12,
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
index dd22c0f881bfba..d0979202a6caee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -16,8 +16,10 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/io-pgtable.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/iopoll.h>
+
+#include "../../iommu-pages.h"
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of.h>
@@ -1596,25 +1598,24 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
@@ -1623,14 +1624,12 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
 
@@ -1888,13 +1887,12 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
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
@@ -1904,19 +1902,20 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
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
@@ -1928,8 +1927,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		(master->stall_enabled ? STRTAB_STE_2_S2S : 0) |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
-				      STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(info.ttb & STRTAB_STE_3_S2TTB_MASK);
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_s2_domain_ste);
 
@@ -2387,14 +2385,6 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
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
  * Check address alignment for TTL hint per SMMUv3 F.b Section 4.4.1.
  * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
@@ -2476,8 +2466,8 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
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
@@ -2776,42 +2766,6 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
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
- * size is the size of the table level and granule is the tg in bytes.
- */
-static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
-				  size_t granule, void *cookie)
-{
-	struct arm_smmu_domain *smmu_domain = cookie;
-	unsigned int tg_lg2 = smmu_domain->tgsz_lg2;
-	struct arm_smmu_tlbi tlbi = {
-		.smmu_domain = smmu_domain,
-		.start = iova,
-		.last = iova + size - 1,
-		.table_levels_bitmap =
-			BIT((ilog2(size) - tg_lg2) / (tg_lg2 - 3)),
-	};
-
-	arm_smmu_domain_tlbi(&tlbi);
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
@@ -2831,7 +2785,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return arm_smmu_master_canwbs(master);
 	case IOMMU_CAP_NOEXEC:
-	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
 	case IOMMU_CAP_DIRTY_TRACKING:
 		return arm_smmu_dbm_capable(master->smmu);
@@ -2889,7 +2842,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	pt_iommu_deinit(&smmu_domain->armv8pt.iommu);
 
 	/* Free the ASID or VMID */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
@@ -2942,66 +2895,69 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
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
+	cfg.granule_lg2sz =
+		pt_iommu_armv8_choose_granule_lg2sz(smmu->pgsize_bitmap);
+	if (!cfg.granule_lg2sz)
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
+		    cfg.granule_lg2sz == 16) {
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
+	smmu_domain->tgsz_lg2 = cfg.granule_lg2sz;
 
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
@@ -4022,7 +3978,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		goto err_free;
 	}
 
-	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, smmu, flags);
 	if (ret)
@@ -4034,31 +3989,6 @@ arm_smmu_domain_alloc_paging_flags(struct device *dev, u32 flags,
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
@@ -4080,43 +4010,23 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
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
 		.smmu_domain = smmu_domain,
 		.start = gather->start,
 		.last = gather->end,
-		.leaf_levels_bitmap =
-			BIT((ilog2(gather->pgsize) - tg) / (tg - 3)),
+		.leaf_levels_bitmap = gather->pt.leaf_levels_bitmap,
+		.table_levels_bitmap = gather->pt.table_levels_bitmap,
 	};
 
-	if (!gather->pgsize)
-		return;
-
 	arm_smmu_domain_tlbi(&tlbi);
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
@@ -4368,17 +4278,6 @@ static void arm_smmu_release_device(struct device *dev)
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
@@ -4468,20 +4367,18 @@ static const struct iommu_ops arm_smmu_ops = {
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
 
@@ -5104,7 +5001,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/*
 	 * Translation table endianness.
 	 * We currently require the same endianness as the CPU, but this
-	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 * could be changed later by adding a new feature flag.
 	 */
 	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
 	case IDR0_TTENDIAN_MIXED:
@@ -5702,4 +5599,5 @@ module_driver(arm_smmu_driver, platform_driver_register,
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMUv3 implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
 MODULE_ALIAS("platform:arm-smmu-v3");
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 99ca96db0d0401..d46df6c8a96cd8 100644
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

