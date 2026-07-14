Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB00329C7B;
	Tue, 14 Jul 2026 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054781; cv=fail; b=PeYkiK2nvc/wBTuabuMOS0chynttUE/7r+hC2B/eq7fEd8D0Sg0yFm2siNZsbO7185fQoXyXUmnAAsVZuqyUZaTDHZwgZcmKyIG8yaV5wS98TnVCeggT+vZaC1XP1usoVzTZRQKqiJ2+NPgwNm05SfxTuam6Oiml0GDREv04hdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054781; c=relaxed/simple;
	bh=NDd58UjNcIB4S467sVvzYdXepd9a6T0RAJp6xT6zVUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z+LJzucTAk2OvwMgqvRbRyQX/70et8qMYVyelBbN4ZGAR3RHIE0wdXsoTG21H8VdZCHSE96AEHoE3A0CdBOEcrrxekJG/Q/QbcJoEQFMZe2JA2OWvyeQlMc0f4je4FctABhmelpNH5wafpCG+FRVpKP2jjpOmcW/h1UZ+xZ58JQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XxJaOzYz; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XxJaOzYz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NV3O4J3dgUxYBrVKvfZ7sugx7Cm0gtE+afi79M68pNbCM/t2m33OpcNQv6B4MO2LKZolrWW98q/h2REKn/s1yBsFozQI7deupBTMk6BgNpeHU2C4bI2bdyFq+3Da8G8/JccwssygTIDOdw4avpdSbrrSh5WonzpdHTBIs1HMGk5uyQxqWlZjRQppMcKtU4kL1k3T5IS9LbWHRrKm09SkNEVoQsQ7S81azJaZm62X60/6hjBx1+7MKSTkXnbkuFaIespNOj/zPum0ofYoT7i+/C52D0R/AVPeSvT127WFdIpGt0vr4DBLxTL+cD+YDqfasgvZVFb+dvmSD9ZsrMFf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqTkz4kiqCFOKw5Kxj6aBAen9OzO3crhtCzvztkL5Fc=;
 b=lkaRqwKyQA0RKF+V+hLfVAP4W4hfaGxunVrA+UqHXU0vPTzFgV5zpfhup/XKzM0VoOgYiUaMa3swgbBwwUNPWSi+nxvOdHMTFRxNiTm1LjY/6Z1Dlgpy04PVvMhPzdmjaT41AXp64ywMiUylO4Nz+gSM7DwhkALtrwwzlQNQmy9VpGYnGvX6JLWsbshYwIrQlVnmVSxizzFPpDWnmJx54ofqm3Xd/dbwUWZteRx/U4k3RXNPxJfxV8acoAKbpmu7yTaHaMSfxGvbHH2xX5V4s+Fa3ChcgQwPxo+YIwlbQcJfEWfzD9cKBNa8+MuKPmv9U3scYXci31uf91EnWUoPkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqTkz4kiqCFOKw5Kxj6aBAen9OzO3crhtCzvztkL5Fc=;
 b=XxJaOzYzwx51hBGUsqp2/pPzUzE2Ax6djbAhB4CXS7FSi9vHHT4escRtqZjrdn3dJQ2hNPamrMLmW8njURfQmTbpxYttVSm9C+Krpv5PMyq3DYIYyeCtMw+IU5Ke52817pAwBIhLfzvzM78R2JG4JtZLPTf5aO8e64bYFwCTd57rt9icAPmXIDW4Mw8t+vsax+yP4hG4Q0Wy1E6DWFbjNGwEdQHebIop5ThFw/iHcl2cJXmh5GgLLohlsFJj5SPrrLP0s/+F5tbiy9tXIOSsTnGiwQ6XzOD6GvS3R/yOjQP7kYknk7xtYuc0xc+TE7mzog+hSunu615R1j9S12yIMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 1/8] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Tue, 14 Jul 2026 15:46:01 -0300
Message-ID: <1-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0432.namprd03.prod.outlook.com
 (2603:10b6:408:113::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d1cff7-40a3-465a-f9b3-08dee1d82b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|6133799003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	0cJEfcOAint99WnRa2897sxvN4j2r02xx7/lUAP3/M027stYAq0wyjM7vHq53eWKKiUPCoy0YdEnflIbtyK6WpNfN9vTC0BotR3SE4t1WyuAcPz01TqLVS3sqJNYZxVQU0ylqeOHkPpbMABLwPYkJ3wX6a0GEcv+yNTZ6gqfPjq1+brOkB1jISH7E/ClSKAvjleDdpVuPc53/SS/rKnlTHi53XUwofJsujF/3cUsGdTNx7yc6IQXpe3aIDNd0uqP/wv0z+BPJ/736HcV44TC3rMFnXGbeqUdjfAiEVPcRG0UTU1yrLHSSHo2P09Za8gUFjaDLdWVBAkljAm87MzFvzQfLdp4RgXUrJsojtz+bTPWTjwzLVB90/xJil3FmeRpQ4VTA7LiKDnnHzBfe4qHLzKklaKCyoPgbYEFgu0crqm4AHH4k4gpllXMIcvaUK3NnDZ1/8bDuZeHXJr9ZmP5pyaSIO+LAItFAIhOQi3oZstWmeLiX+ZMPZ5pAILT5r3yfRuFyJPoOu4tML1FPkCCt/YeM+pH1MiG6HXOmdTkhu9bhCVj66KTrqz9rw1Wgcc7XFQRXAnkz5UQhLZgM1j4GICPlU23IUrvN7Ods9gUWiwPUqUhH5NuGuibqSZUi0CnhGeBv88iAzss51v72B0ff4qP1WEsjUgR+ClEIzd9H8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gMUIVxmgzNe7zA4Eczmvb1kHKPNa5fmMqLeViOk25UQc1mBU8aHuAaU/t6Tx?=
 =?us-ascii?Q?iwCtMjs29lWc3f5TDAANjmXQpkz5o8oQINCP1PVtAdR9Tgnn8CfbdWG2dEdd?=
 =?us-ascii?Q?AN37+/7h8RrmvWI1t2V+rExezCYYP5PCTHFnfEgE0GUCTx5p1wXgpI/K2z+B?=
 =?us-ascii?Q?mjx4go7HHWmb+BkLW9zuIKXz9+XI6CdUHUsS1e3HIR3TobvXMmW1svRotxz4?=
 =?us-ascii?Q?PjBFYv7JsgBNCLTQi4SEGOi/B1zcs4AuQVpfll/FNgppQsx17SNMXrpkfvpR?=
 =?us-ascii?Q?DvjXjR/ZuYZFlrc+Pn8pm3mPPMvmDZBRfwaWRAx1Oyb8BxyFms0FY736UTSG?=
 =?us-ascii?Q?UMhUZv8krJzpyfEX0705XsM3DhmhEsGecGryk7m/xor+eSmajirX9bYR/8k0?=
 =?us-ascii?Q?HM8k1RmXqF3Rc7lZfmWW1ZCJNmMJhfdB91PK+iTkb6CxPanz0y3nB3crcbka?=
 =?us-ascii?Q?21WOZm4w0xBeuD1tVjUGomtulY659Hkx/IT53w40tMa9fD0ocYjT9K2Kpd+l?=
 =?us-ascii?Q?J57+HcppPBETqLdOVJa3pYw/6gTFoX3MsTWj2OmW4wihP7KF+TuTJpjgYnuI?=
 =?us-ascii?Q?qC6y1QlncR+DTBu1ECfKbE/BHUXmrvW9D+a90bvojPNaTB/fk8EbJ99KTOSz?=
 =?us-ascii?Q?xpTJXRXyBszOJnRJZiiwsxVIMkHyJwIZkbid1N8jew8u42ebL2tsJ9ILMGeb?=
 =?us-ascii?Q?5pei5Xg8Ef5NQsaNi1x1pxLtO4BfxeFnEZoyVEhXrv8N3RWngd6zTgxs7gBL?=
 =?us-ascii?Q?C+9YwWioKiRe3rbwt5Fzkk/8lHARY3VIfi3BE2pBWNxO3Gf3uStdG9FQBZcF?=
 =?us-ascii?Q?/SxObXwntqe3D09S5dL3ryfMnuFb2VBvmXWD3j6YwHb+m+OuooCnDLBBH74D?=
 =?us-ascii?Q?RtX5DY1/bUex2+tr0U6j4vYkoEuVP27hwfDv0JU1dIV4kEZNNmdGTfZdxAjt?=
 =?us-ascii?Q?WOsVCiWl+plQ71RY3tJkSGKpQFrAmvQz32ZCJNraIqrEcWcdtMWowU9ZDFTu?=
 =?us-ascii?Q?W/C4QTSgjemoESPzOTvIltuFnOA8aHlPKSeJGT+YypYhNC7ntyUZNRDSNGVo?=
 =?us-ascii?Q?WNJxsSHcw3UDq2m/844d6qzwv7QYjb0WOEN5txz5qOcGXN993wRjb/LEf2tK?=
 =?us-ascii?Q?aOtJzMIAcqO3PqrWaABdvm+q4Zhg3y/CatE4CjaCuHoXs5iH8Xq+j1wmSRRA?=
 =?us-ascii?Q?lYixpJ2YXEM01jzdWiE4FCMRaSQl0qeet9Ee2DRJtDEhTfFKcfaPjDG8JVDB?=
 =?us-ascii?Q?CUQh4JTVKZ0QY0qB/iYebqrKT0uH7MrTmF/Aq4mGTHJceKbMLF2DvQOd5m5i?=
 =?us-ascii?Q?KZhINsTVm9MY5PMwKjjVntXQPQfGpwW2d69/SFZWYtbyLSnsVtAAXqx0IZuz?=
 =?us-ascii?Q?7YoJR5vzKz4mCOwSpbdVcZOwmvhWSZNec/ijqdHTdKhKiT3mQSWfQHcd9Igv?=
 =?us-ascii?Q?bkwu9TxgcJL1Io4k2bUYjbHTMCX4IMfBMioykTk0bjxomBTh7AnING9QvUv/?=
 =?us-ascii?Q?YCvrKxFJDTkwTmrAYAjQj/lAnIuEJs7L+5wGPAm0OA+bUE4vh3BV27UM5ebF?=
 =?us-ascii?Q?cHx5AICttQRkh2T3HRh3mLabuMlj7g7SHQY8fo7Y4k6Tw49PdW/c1DY9rbtL?=
 =?us-ascii?Q?ZHteO1HbyBPYPBjckHYYTcnkBYWJXrM/kNXtLbe1rcjkYfcLPhCSn1x9YtDt?=
 =?us-ascii?Q?Mvg445OpdhIvLxdTlaEgRx1fBaK0Z8Gi9R7RZcboz/k1fFZz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d1cff7-40a3-465a-f9b3-08dee1d82b87
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:09.5806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEOpoKbjmi0rpAdosVIpF459oR1zhTd8Zop6MlHv1ad/NyrVHHMH2xRpyr3PPw7i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

These parameters go to a lot of different functions and the next
patches will add more. Put them into a struct to keep things tidy.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 75 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 +++
 2 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a10affb483a4fe..604b165be5fbdd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2298,8 +2298,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2321,8 +2321,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2397,20 +2397,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd, bool leaf,
-					  unsigned long iova, size_t size,
-					  size_t granule, size_t pgsize)
+					  struct arm_smmu_cmd *cmd,
+					  struct arm_smmu_tlbi *tlbi,
+					  size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long end = iova + tlbi->size;
+	unsigned long num_pages = 0;
+	unsigned int tg = pgsize;
 	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
 	u8 ttl = 0, tg_enc = 0;
 
-	if (WARN_ON_ONCE(!size))
+	if (WARN_ON_ONCE(!tlbi->size))
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
+		num_pages = tlbi->size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		tg_enc = (tg - 10) / 2;
@@ -2423,8 +2426,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (tlbi->leaf_only)
+			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2462,7 +2465,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2472,13 +2475,13 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	}
 }
 
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
-				      size_t granule)
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
+				      struct arm_smmu_tlbi *tlbi)
 {
 	size_t max_tlbi_ops;
 
 	/* 0 size means invalidate all */
-	if (!size || size == SIZE_MAX)
+	if (!tlbi->size || tlbi->size == SIZE_MAX)
 		return true;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
@@ -2491,19 +2494,17 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 	 * invalidation feature, where there can be too many per-granule TLBIs,
 	 * resulting in a soft lockup.
 	 */
-	max_tlbi_ops = 1 << (ilog2(granule) - 3);
-	return size >= max_tlbi_ops * granule;
+	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
+	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
 }
 
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool leaf,
-				       unsigned long iova, size_t size,
-				       unsigned int granule)
+				       struct arm_smmu_tlbi *tlbi)
 {
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
+	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
 		struct arm_smmu_cmd nsize_cmd = *cmd;
 
 		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
@@ -2512,8 +2513,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
-				      iova, size, granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2532,9 +2532,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
-					unsigned long iova, size_t size,
-					unsigned int granule, bool leaf)
+static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
+					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2564,18 +2563,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
@@ -2586,7 +2583,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2617,6 +2614,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
 			       unsigned int granule, bool leaf)
 {
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_size = granule,
+		.leaf_only = leaf,
+	};
 	struct arm_smmu_invs *invs;
 
 	/*
@@ -2657,10 +2660,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c909c9a88538bf..4806a00844d30e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -802,6 +802,14 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+struct arm_smmu_tlbi {
+	unsigned long iova;
+	size_t size;
+	/* page or block size of the leaf iopte */
+	unsigned int iopte_size;
+	bool leaf_only;
+};
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
-- 
2.43.0

