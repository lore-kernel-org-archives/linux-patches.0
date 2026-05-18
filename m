Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687EF390C8B;
	Mon, 18 May 2026 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133465; cv=fail; b=sVoQ7u86OaOzGrhZ1u/zO3FVWfDwdFmD0Twq3RwTlZYbzYLpaW4sFBbxBH72AN1OE37QC2uOp4/lukEvI5isKcSJyPOb9E3OsOrbrd9OTspcbIhW5z6FCys4cHPrDFO3xf6hDGAZ/A38aZW+rJgJZDxj1wio/CJT7COg85ddmyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133465; c=relaxed/simple;
	bh=Wfd7Bb2wDAAacP/2G0iMWe4BHrDfM4lo1ZceE83k0cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WSOTHrDeiKNMwD12A2jcsxe9Vg4tgMirDX2j3cyx39QPvEf32YGebhbEsun8Gl2qq2WsudBTmAypKEEOmBGJlYs1E6O2BfCX1DMEi0ybYkcpNYEMMCz0UxPml0/Otth9d/JHNNUQAgYrIvYlCbDcnl0B2Sw8ezLgY+i9bieFvfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o3CopqF9; arc=fail smtp.client-ip=40.93.194.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o3CopqF9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RLSbzyM+3Nt1mcmYwVt3WIu+fBEupexbM5AtYda1LkNj6KO/ozRm1IDBkhE9/ca8fGZohWtG6GdHFT740vboUHE6EBaNc0wFDigVEmtuL+jW4UHR3YXlkfWJME2UvGDtarob/prrPGQUqvs49FUaIQw4hcABHaeakejTTa8BEF0h5A/9MSX78nN0gFqmPaGu6Y3hI4c3ox2uux5cgsID32LyivZR3TcHOotEsTB2fQ3rdJpPK8ik6hEHMSUcauK1eWVev0OIQDIUB+bfVx1iaZGkzPqyidjSOw80u7fVBdgmXezqPWfAl4xKh+xiLcvSqMptw2bPsBTweRJiFQxkhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZWHiELT+SKeD/VHhgOQrpDww5CYuKtPZAq1kcMnPBU=;
 b=Hy/XU0KVoNWD4ldD9iii05J8b4EJradCEKtswqpAEGWS3EGjrLKFgJy7NDcTP+AbxHvsVanAncvml4bIisOQ+xTPKkWe8IPfAbMok+MpN7mnP50KgMMCvzKUffgrlNmbDVYA1V0B4f+1dDZw8kkxDP8z0jor8VhaUtCMaVzXvn3GMG8EvDM2FXq/lqsXR4fiVzwbk2n8PMMuP4K1mZMoXBk8wYQfoEfZbW5+1wnzDL0QqhkNrCuQFOvjMREP9iZMzw7pbWL+nCy6aYMcRDb6krWYdijpt8vQjSYSEZOTu6/f/+LknbalwCV4vF5OTK3ZtYHg0hsFBWQykyU+8mMEpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZWHiELT+SKeD/VHhgOQrpDww5CYuKtPZAq1kcMnPBU=;
 b=o3CopqF97bTypzwzts4Vpk/7lsZZxxb5aQSyphKtDgqy8GfJ3q7c6tSAvKP09y8z5aXnGDVlaPaBDNiIUIArmy3xmgtALfL7Xe16od+HG7AfzWko0Uf7K0hI59+8PxnMBs69pO5lbR4oWVcUuc1PNUVT9Uc4kqGoixxD9WvScPHBkmo+lK+1hsJNnbqELbC9HJtpw5l2jDkiZz8ty3NNJpHS38bfcKq4Z5PCeveCkxdNldCuZryFJSqcFeF6uLWmBCNbc0D55nDhWiTinvfEMFNNFlk5bvy0ZilZK/jAzM1x8QKZuaP5j9NQ5Kau0JBCgC/j2/CEnHm5G7ipmdMjLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:44:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:44:15 +0000
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
Subject: [PATCH 5/8] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Mon, 18 May 2026 16:43:42 -0300
Message-ID: <5-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:208:32e::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: f309dfb6-ea13-4ff9-fe72-08deb515d78d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|11063799003|56012099003|22082099003|18002099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	jeBltHideTtW+j5QuUmz4nHHGB8mPI39r6toQNaw53wCen3V3RL8G85zBy3naJDsDA9fDQendWbxtAnPUoHhL0w6oW13/6sMH9mFIreaNVsft/DE8JWEaIPIy6LwFT2+PfUCqSLqXoAKH4sfLgI12RofF9ia9xP8xmLWs0qxjfQJ3PPcdXkXb/B1k9Pa/AehICHq5iyzgct+tGcD3FvgbeUylMqfZdoXv/3S50bkyXG05WDh6DbYlzth8qr1e6affmod+QozeqOpl6m3BBEMQ/D/tbBofn4AhIadaC6gEmh4rkfBoqfFZtrAfz9a5zhpmlfJvrcaTZhmTgyh0bzP02yqrXIO7ohOwHIEKnAPZrA3sjOyHRfEEji/l1uxnzBG99kwK81J1FErGb/yhtW7JyesvDEt7x+cxRXEBTCqD0KzGACHd9F5cm5HBb/iJbatbdb/OjOA2swRubbfqpFUy1Ty2OkFGPzcMO3pjsvHCV5PBbtDr/gomgeBZCRvHvPMoZnueMNiBrQcd2Rj/166mImZRooFsRgrzLcMZ391+SDeQ8dxBHoj+TqHmI2qclhIwF3KV6s0YaUT+1zygpFDrTmnw+lk6wqcbTDyA8jpL5m6uLm0Nma8d+xc0pZ8Lp3O6N+YB1EmbYaZ7dliazXIo2FlbgTY0TQ3cGUY0GLP5oXpDp563IEv/3eomuv1FAlS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(11063799003)(56012099003)(22082099003)(18002099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NrQuBx+R4CStvemefBXHxkT2U5duJtmJXAg8eqMWa4x0BEeB34y9xtIGDi+b?=
 =?us-ascii?Q?9qz+pjEHlHkdaqh/draAClsuf0jV5H9fe3XJO5dw8ZKbR+J6ZbP/u+UCcXgw?=
 =?us-ascii?Q?owxjZvOEuvqhnoIY1wIj3Xl2VrCgNzGGeRh/hKFp/dC50FnzHDoMrInpegcL?=
 =?us-ascii?Q?waC+l/mipzqVAb73PMoWQxI9lH0lSV0cOGCJCMvwm8p5pbDOhAMixXC+TSEJ?=
 =?us-ascii?Q?U/0JVaBBouKcRyEpjicd+zxUlkjSzthNV49Eukpl8X7EBcfoNqN3knJKBwjq?=
 =?us-ascii?Q?q3K/iDeIRSGL+rZk0+QsLcpiqEuvWryvunWKy5vaoNHtCj+WlXIQ/9BYNZ4u?=
 =?us-ascii?Q?2oIvrrLe1UlC/7hw+m+aZiNVyvDgYJTDzHcemwv4JrzOY/GL7o8Wo+P2xWT5?=
 =?us-ascii?Q?M+/FIaQC8F5FeV/h7lcMl/DAEKzrFNpQqd4bmzEk1gSyxU5hZwBEWRsNUyb7?=
 =?us-ascii?Q?9HmwDDIeSpu9ErxAXdBGBYh2Kel5GiexarXYSu8DvZu0D+EUnla07ke0h06H?=
 =?us-ascii?Q?0mdtaqmo3bE1zOQ0ImtMsjhNwr+vEAOZ7bqg0ZMWPQUiBQrM8ELLbdpS5wZ4?=
 =?us-ascii?Q?TPqqRz+MljfCN2ya7ApWlPLGP432dhZshxK9kjlivOiKXdqCw6j/Fcn7TBbj?=
 =?us-ascii?Q?5QsN7IRTvfdwh+kGcgHtdYmFLilt8c8v1Zln7Ojh560iTIezAiwpyYqHY0TS?=
 =?us-ascii?Q?D6HvZvk+qVfP04UvtLXIVI1h8k0AYP+CTXs3zc9rUTj2dDfq2PJageL/QPKZ?=
 =?us-ascii?Q?g/aELvSUZnPE2RYJgfq+9g/Li9E/v42enLlHhTv0edlyW+xBgivVUFkuPzZG?=
 =?us-ascii?Q?nCXebvqSp9i7M4/HHfGkhQ8Xo10pGSMVNsiFDvvEEu6Fdk9+t/XlBnIkIT/V?=
 =?us-ascii?Q?ligWwez+lafrPuDX07lhRRFX8vzAfaQG/tmVIvGZmHF+7AbXneMZEXIcTk/h?=
 =?us-ascii?Q?Zk+EBLf9uxoCU7p/520yOB4/kaN5Jy5cVAo2IwHgaOfwpe0aXl60EhfHTT2G?=
 =?us-ascii?Q?ctorsAmuk4lUY7WrKem1FA6kbAdfyjSObyZBYOgmtVfoy/kOyOZ8Xp67i2T5?=
 =?us-ascii?Q?XxRdokaHX+YhHbiPU5Pns0Q2awarSSkL/Zh1rkzup/iFLT1rWxSMYOXou+6m?=
 =?us-ascii?Q?XCPIiv031srGgWTkzHSQKmHo2bogTDCtXhlw6u44yueo6ieju9gDZUO8m25E?=
 =?us-ascii?Q?6lw7oIX2CKpaXl5baPlbsIpxC6qTBsVw8Kr8iG5iQxjJP6bEMcBUodgDo3Ms?=
 =?us-ascii?Q?vcbrdXHYfMAtZ7SKqEyW6pxWusFMVJ+8wFNbSXX6Ibk/PLQu/y4a+26FXFHk?=
 =?us-ascii?Q?/H2GB5izuNHMh7n7XXku9pi5ybCsURNfRNN9iaVisW03P5uwBn7CF7vJ4HV0?=
 =?us-ascii?Q?xTZbN/qKlIJd/fN8stISywBqz9UKYyO900tUyO+T/WxPLvgQ2PF4SLCH3aAE?=
 =?us-ascii?Q?XZ8wuTzvKnleMnFzCccLmIXLgeG+1NnuK6BrYYd/tueRV0P4ZKCIZzMoF5Bf?=
 =?us-ascii?Q?cNTJCod20Ryvkl6JZFo9dRDZCMT+FYCENkNpv1hA5Ql6B+/LXGQETymP0ksu?=
 =?us-ascii?Q?iBOh9lO6iICo2zcaBfuTyi8X/bvmV7nIvD9im2T+PyXU5HBkNTUkrfzAl2hH?=
 =?us-ascii?Q?PurRs8vmLpaEiiKsk2N1lBPn1vu+ABdc3S/bECd6OosMglsm7vwoEvBeIF5c?=
 =?us-ascii?Q?2f0G1Fj3YhEb3TfMcaYMJ7B0gC90SIVR5tdTwDIST2ogoxUa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f309dfb6-ea13-4ff9-fe72-08deb515d78d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:44:15.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfocH9TLYqVEs/T0KNYvaBDPGzbct9HFLY8ETt3pS6J4phN6GMCpycjy4PmSShn+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on
if the instance supports RIL or not, otherwise it is always the same.

This avoids redundant calculations for each invs entry.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 132 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  11 ++
 2 files changed, 81 insertions(+), 62 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3b0b273fcde829..9aa08f782e8986 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2398,32 +2398,15 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
 }
 
-static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
-					struct arm_smmu_cmdq_batch *cmds,
-					struct arm_smmu_cmd *cmd, bool leaf,
-					u64 address, unsigned int num,
-					unsigned int scale, u8 ttl, u8 tg_enc)
-{
-	cmd->data[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-			FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
-		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | address;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-}
-
 /*
- * Issue a single range TLBI command covering [iova, iova+size). Returns true if
- * successful, false if the range is too large for a single command.
+ * Generate a single range TLBI command covering [iova, iova+size). Sets
+ * use_full_inv if the range is too large for a single command.
  *
  * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
  * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
  * the invalidation range.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 {
 	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
 	u64 cur_tg = tlbi->iova >> tg_lg2;
@@ -2433,9 +2416,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	unsigned int scale;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
 	 * io-pgtable and SVA pass a nominal last-level granule because they
@@ -2452,10 +2432,13 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	if (num_tg == 1) {
 		if (!ttl)
 			ttl = 3;
-		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-					    cur_tg << tg_lg2, 0, 0, ttl,
-					    tg_enc);
-		return true;
+		tlbi->range.data0 = 0;
+		tlbi->range.data1 =
+			FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+			FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+			(cur_tg << tg_lg2);
+		return;
 	}
 
 	/*
@@ -2474,7 +2457,8 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
 	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
@@ -2485,38 +2469,31 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
 		ttl = 0;
 
-	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-				    cur_tg << tg_lg2,
-				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
-				    scale, ttl, tg_enc);
-	return true;
+	tlbi->range.data0 =
+		FIELD_PREP(CMDQ_TLBI_0_NUM,
+			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
+		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+			    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+			    (cur_tg << tg_lg2);
 }
 
 /*
  * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Returns false if too many commands would be needed which
- * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
- * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * iopte_granule sized. Sets use_full_inv if too many commands would be needed
+ * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
+ * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
  */
-static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
-					   struct arm_smmu_cmdq_batch *cmds,
-					   struct arm_smmu_cmd *cmd,
-					   struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
 	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
-	unsigned long iova = tlbi->iova;
-	unsigned long i;
 
-	if (!num_ops || num_ops > 512)
-		return false;
-
-	for (i = 0; i < num_ops; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       (iova & ~GENMASK_U64(11, 0));
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += tlbi->iopte_granule;
+	if (!num_ops || num_ops > 512) {
+		tlbi->single.use_full_inv = true;
+		return;
 	}
-	return true;
+	tlbi->single.num = num_ops;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2536,16 +2513,32 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
+	u64 iova = tlbi->iova;
+	unsigned int i;
+
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
-			return false;
-	} else {
-		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
-			return false;
+		if (tlbi->range.use_full_inv) {
+			arm_smmu_inv_all_cmd(inv, cmds, cmd);
+			return true;
+		}
+		cmd->data[0] |= tlbi->range.data0;
+		cmd->data[1] = tlbi->range.data1;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+		return false;
 	}
 
-	arm_smmu_inv_all_cmd(inv, cmds, cmd);
-	return true;
+	if (tlbi->single.use_full_inv) {
+		arm_smmu_inv_all_cmd(inv, cmds, cmd);
+		return true;
+	}
+
+	for (i = 0; i < tlbi->single.num; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		iova += tlbi->iopte_granule;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+	}
+	return false;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2564,8 +2557,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	bool used_s12_vmall = false;
@@ -2662,6 +2655,13 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	};
 	struct arm_smmu_invs *invs;
 
+	if (!size || size == SIZE_MAX) {
+		tlbi.single.use_full_inv = true;
+		tlbi.range.use_full_inv = true;
+	} else {
+		arm_smmu_tlbi_calc_single(&tlbi);
+	}
+
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
 	 * an invalidation array. In the meantime, a domain attachment mutates
@@ -2692,6 +2692,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/* Only precaculate RIL if it will be used. */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv)
+			arm_smmu_tlbi_calc_range(&tlbi);
+	} else {
+		tlbi.range.use_full_inv = true;
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2700,10 +2708,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d58fe91a96325f..b5e214b428d644 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -809,6 +809,17 @@ struct arm_smmu_tlbi {
 	size_t size;
 	unsigned int iopte_granule;
 	bool leaf_only;
+
+	struct {
+		bool use_full_inv;
+		u16 num;
+	} single;
+
+	struct {
+		bool use_full_inv;
+		u32 data0;
+		u64 data1;
+	} range;
 };
 
 struct arm_smmu_evtq {
-- 
2.43.0

