Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509C8313543;
	Mon, 18 May 2026 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133435; cv=fail; b=gGxki8fSCvV5FfQWSAPiliAZJO7mJ7N6qLQVOX0nA/x1fWAZtA9wfIpLPAULx/Ai9Tm6HNwpfNLuzJB7cqSTUWQNYodJ1hilYle2AbmCKCMIJ+DzD+xRdltQ41ZXLXctvKjGfDsUjkYlgw7us7W2lmK6ugCD5V8AVFPD3V/Su90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133435; c=relaxed/simple;
	bh=2yaEVBzsZjYUu6PVzr/S8DbwJTNeIC0/OmBcZVGnL/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gyiyTrammaEjPEp22jcMNl7/Dr3p2RxgWNcJMCJt9tEMmDCxAwtMYNWY98LQiihkCXoVqDbIydPXote8uL6Vul2alKXbfzO31DfO3qqer7o2/NeZyHIgz5OoLPyzD2pUd8umi0FOc+Dh4ggoI2p0JojY0XJ07E/cwpB7fG/iRmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KZ2KYNug; arc=fail smtp.client-ip=52.101.53.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KZ2KYNug"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7dEDZEZdyA0PnG8HegZoZLozwBuCztfuCCyDOUqnw4em3HelGkJtvjyiN3381lgkcW3mWGiFvtoDEv8Oi24nklhd7+hMic+mtKyoHJ/ZZzmJ53rjwFLsdPHJQXzKEdeqAFvRnK75V3lDfb9Q0wVSpEBQdY6eTIiuTWBmtfVT2QpKV1dLSMeJYddXjXVTrPpxREyOCEIzFR7ncd+7nSWcD5Cl51qhzsbUywy3jA0LGsEDKgqz7/AtWgHDMQBDtFitvoh4NsYhyCV78Gti8lOnAuOTd4Pv2jC+d7vSYoBbLFLsBKS2H/K5zF8110RyVtd7z17Ess1XIXWIDljpAiw8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7iwDlJXKcnJ8Vqj0weB5KFCqhfIIc9dq/koVoYdBaU=;
 b=W2h5GOgzCkb6YJ31wfO4k2Xkc/j8wAmpfocPhlW6BNcG+05Bqj7i4FcStb+9wvbJyjcTthQWwLdIDBvENP8V4eHFEur9t1nf5ydwPvnKnzYhR3HHLzO5kkxzN9l05nA0q91090JD5fMkUbKVuwF/sXIGpvzWgN1c+g6qTeMXrFL+C/DHMQx3bh9eficlkDK1cj+05O1K49Kds115mePD8epFUad9Haz7n+oldPFYC71ec0tJfZtNSv4tuiU+eG+8tBUcWeO8CHL6uRCA6YQNh63IiCFGUcOSHqJ9Yi2qlkaOTc3oCOJSRkeOw7WXrtTipQmHB+oQnD6OIVxCSrsrcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7iwDlJXKcnJ8Vqj0weB5KFCqhfIIc9dq/koVoYdBaU=;
 b=KZ2KYNugw4utAnto06pnZl5lzKgl5F0ThOPSBvWdU9OHaZYvY7V507Ys4aUnHukKBneQx1mpJlG4eZV8+7j3i679gogOjwY1mQZwyyinfIDi1EPmYaXHmpo4XHUTUYJsYXIIugcnqnBV3sKzOg1Zm7gBa8MTWw5OrSaU1kMHKVghO5EzwEggqxfqK0KGSGGtHBjTa1a1zUOajJu/OVp3BfWQBw4ttQVb1jl/dkEqEdaDH9J0wTwYxLZT+VDkIFJXCMam0wQHLE2w2gRMfe9YJCiSO0Rm3J8IulfudYnU9rOVc5yQxYhG7NpheftxQbqOt21gnUDMKxno4HLyLkpjGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
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
Subject: [PATCH 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Mon, 18 May 2026 16:43:39 -0300
Message-ID: <2-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:208:32e::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: 02eda98d-3907-4d37-e846-08deb515c689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Bb4LUIXuuMHTvavUHycJAAXovwS/gKV1oHeBN9usM/h7TBHZNRKMckGGqxDncSNktldco2rDzm+VzP+S4tZlGhCvr1Eo8cY0UZC9CT16st9aSgoVcs5ckWhxnc37Ua2jgyi12lKmUBIaiaqqHDA+gOrsMU+hs1S8x76/tNjKb8KvBbpwAObiQ9/XDNowMvuDEbPCtcmNDwRx/dceXHpUQ9yVUT+dPt7/eOns8Y3w2/wxkCBb9uxnVCzSt82JvqjRuzPDMWJd+P/qcuebBTMLPjXhqxXuAr0vwI+jk1Kfq/JTnFbHk7SPz+KuMQCmbibNn2UcQX806gFAXe58GZSPpavwztGJwiJXpaAAnvm2ODqm7ffs6IbiwqzyLGDuLRQ/PGl+VN16FZ+OQ3HTyW04LLl4LHpWzu7I9oSzdXNgBZ0JZYna7uaIckoUon0PkIdmnFiCxlzOHyqDVm8UiGXZ8GwbwGKXi6ooGiw50ed6LdWw80ve9Gnv+cIoDSmtBjMvCDoCBu16CDZxNAlbw7Qq0X9BDoBSb5g3sxCm3kRSlY5cpBaIGFqoA09hPqq53sL1zPZiuvD0Fef+vWpziP/xTSsuVlzf0qFUiixDYL2EJrKCrfDmOPtNQVt12cn6+iDtmmMD2gYiIrsvZYxSjP0QOv7p7etUqrCOM/XWUKkzbOYnrXAzX/Nrge5Ova13KqTN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mntkKueJAmPWf237q87OfFaa5uQMPipmjl3irvPuTALfAnQVa0ADhZH/BlFp?=
 =?us-ascii?Q?0cwJYiqgB4L6LNgMf0xYtW9XoZk6wAPTeF5AxLWKYDaO8EF2YLypVT7+GoEm?=
 =?us-ascii?Q?hXI55VI0TecJ/92ifWb3HjxrYLot1H3vfV8QrA+yJmNKTRnmVl/438VDi9rL?=
 =?us-ascii?Q?BBprIPZXdXvKl0eWl7B26YdkhqpwkIduL5/DIwExY2NQweDJrYLPgEHNarEJ?=
 =?us-ascii?Q?yoYV8Xv/S32ieFCwb0b79vhcfIyZ18pqO0XdLoKkwyPfZlVrTvqX52hhVMfU?=
 =?us-ascii?Q?RGIXmut/8yyOoNcdeTNBIlilq6KRyEdhj5sjwH5TJzBqRhvTKgoJe3Dq3aKc?=
 =?us-ascii?Q?ckopfLxCVGEHInubFtePssZtK5k74P4tPRXYqGBLsChrL4UnqowhkXUAmDPT?=
 =?us-ascii?Q?SDCf1hGyZx1LPEpdWKCDFFN0CGqY5qRmPmvByoUX8iIRJKYNILuf1K3ZAAOg?=
 =?us-ascii?Q?8FhlXRLfGBteQ2nQ88WORJ7gPNzv75Jr8l5/mZ1ubeuDVhyr7SdnrRt3MJDM?=
 =?us-ascii?Q?urGs94VVLhj1OxZHeoCOlwRB7A51XDZ4/CmLELk8djNeih2YVdVycpWyGOuG?=
 =?us-ascii?Q?wE4r4dA1XIaHve3U9Y1qiG0nNcTuCj7xsmTgTztihKlfNqlfiRd2JuYmOQ3D?=
 =?us-ascii?Q?jpNAsaPlYb4tqsVQHo3tmo/hw9jy4qjKrOuqgEENO72Tl1GE0UIEAddcfPkf?=
 =?us-ascii?Q?STAgwGgfuSQ60EncJw6Kke/M+0FpLo4QVoy62FJWn8e3fVAGx1uxkuRU177q?=
 =?us-ascii?Q?FCIPqcBFzsaMUwTjloX1+voTmmj+yVByfbhtRQEwMV32zD+vKKKWFXc3kf6N?=
 =?us-ascii?Q?lKxO9b1Zbd3yD+i4SdYOjuBXmXdNix/M4xil1NvsY0/sC7o9irA6Sk7KWgip?=
 =?us-ascii?Q?IRrmP9mk0ThIHzBXd1e/BGRHwAGcl4G7G9vU3nMaGT5d3g9DXKVxdAzwoF41?=
 =?us-ascii?Q?YUGH8xluz6170owJueYD5Gaw8pei5T68pqnVkfZB5pnh8o5cCXewxKzP7IWx?=
 =?us-ascii?Q?/BAvZPX+ZRACXKIrvkqmB3/9/D5qPB+M33zAAmJkwzXmSto+RFzUjwgIWXOR?=
 =?us-ascii?Q?XML48QdFs86XcsOPK7DrtNYrNUeg1YQ4nRQGwjdFYoLGNT/CXSfmGO9M883C?=
 =?us-ascii?Q?ByuvEV0eiySzhjp2fyje9uHPVsbx2UCOJrwqjA8HopSK/nTtzXELYz8dCW3C?=
 =?us-ascii?Q?TyKYK1QzTd7CQXKJQrqoIluiyLTbH6SfiUxktLQ/JX3R90ye1NzW7seOPHsu?=
 =?us-ascii?Q?cgIK1bjGXic4Bu1nyuVetZKIDXx2BLWHpXJh/95A5aB0F8BfFnSyzG8Jhmfo?=
 =?us-ascii?Q?iCeDhxU8lYpTZ7GHCd2PZDEPXgSJilsLVit+cLnkAjRYpDuzwGiOP9yHZ2Rr?=
 =?us-ascii?Q?eojxchiXnRn7kN2PgN3ACDkj4ewbbZn7B+W5E0R+0XoCXlL7mivZ3sAyyIVv?=
 =?us-ascii?Q?oQm1ICL/adXwdzAi+3GjjSlruS3Xgo7b6Y8GpCV3U6YAMDuz8v+JAXwnAQub?=
 =?us-ascii?Q?CnGFG4us9aEn353PH1CKxFrhLFjNxRLC13BvA6FOYM8QtbddcSChYY7mIURA?=
 =?us-ascii?Q?diHC1vv+1yC2tY+G2GJ8hpgOYjS+MDESf0fyK5wT19TEbMo/2eqI7sC3qMms?=
 =?us-ascii?Q?zIL36QYsfUOulifSvAyCU0Bm7WVdTJJwjuJNiauiKS4xp709gJyy7ABRl0Az?=
 =?us-ascii?Q?qQY3uRhXPH+D1+3bIrsKL/jxV33d3xKSUuS+iD4X00jBmDJo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02eda98d-3907-4d37-e846-08deb515c689
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:46.6496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOi+EyZfXxnTGx/H5vYfNNNKeDF1lTkN/AmI9wRcGUjjmikxNOXyZafoVvloinuM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was created.

Add smmu_domain to the tlbi and just get tg from the domain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 27 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 ++-
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index f1f8e01a7e9142..4649717df151ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -324,6 +324,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f7881d21eb06cd..cd0ab518712cd6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2379,14 +2379,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_granule;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	unsigned int tg = tlbi->smmu_domain->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2494,7 +2493,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2596,6 +2595,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = smmu_domain,
 		.iova = iova,
 		.size = size,
 		.iopte_granule = granule,
@@ -2851,6 +2851,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3085,15 +3086,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
-			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
-			  size_t pgsize)
+			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
 {
 	struct arm_smmu_invs *build_invs = master->build_invs;
 	struct arm_smmu_inv *cur, inv = {
 		.smmu = master->smmu,
 		.type = type,
 		.id = id,
-		.pgsize = pgsize,
 	};
 
 	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
@@ -3145,28 +3144,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
 {
 	const bool nesting = smmu_domain->nest_parent;
-	size_t pgsize = 0, i;
+	size_t i;
 
 	iommu_group_mutex_assert(master->dev);
 
 	master->build_invs->num_invs = 0;
 
-	/* Range-based invalidation requires the leaf pgsize for calculation */
-	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
-		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
 					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	default:
@@ -3178,7 +3173,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3189,7 +3184,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4e97aa5d011a98..0c63069400d22d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -734,7 +734,6 @@ struct arm_smmu_inv {
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
 	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
 		u32 ssid; /* INV_TYPE_ATS */
 	};
 
@@ -803,6 +802,7 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 }
 
 struct arm_smmu_tlbi {
+	struct arm_smmu_domain *smmu_domain;
 	unsigned long iova;
 	size_t size;
 	unsigned int iopte_granule;
@@ -1049,6 +1049,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0

