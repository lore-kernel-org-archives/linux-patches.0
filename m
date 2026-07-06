Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F0432BDA;
	Mon,  6 Jul 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355222; cv=fail; b=ndXFd0mjtMCMcgQmfFVr4A4ZfGIklj1IP7LLEQN7WPguIsMWIY3b6gKa7qSvjXy2QHOoyQLEWj7VACo6svvw8AVFbjKBB9Bocbz9BVPs2o0IPk5yQ58EDtTOIIxlifiAINRwvSfy+1yO3Kell5fwz/rId8KhGz4sqNAq/AYd5yQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355222; c=relaxed/simple;
	bh=sp0ppl7sk5ngZ0WpAVoQyQp4IX9ro8hzTRLyptkgxAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GZF5oVo9x3R2HLoD8Op3+gCZ4hrHKWc8U3sLLDrY8IwjCUJgEU9QtU5DOV0YhtK0sOQwTqjZiWOfdH5wskmBCuuBUsX6IFrx/G10HkQ5qTcGSYML2hoUSHAIYedv6SuSxo76jxcv1XOxo+yOQ7lMhFAXsoodThLSv4Ddk/Vxc1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ihvq1Xlg; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ihvq1Xlg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HBiX1wpri0thurkkAk8zfWVvX8jZS/XBbj66ibApdoKnQMHEI/D+tI9RFQiJ05UX+btB/7tvdbbrCCOccVvak5rITJITM9wJOUiSX0Ob8KVsVYx+KMa4ZScrZS9S8ZmJoeLBGCaoeblK5QDI6ZtO6IwNC3W533JNfyaw3zEZB2ynYhlrHE3QV9BZG4jVQL9Szo6+Vu3ueLAnC77Fd1x3KXDyGJbk2p2SOlimRYUwF7R3qc0R+3bFBvqHc4C+VMzhfbDx6T7Am5h5uDWpbDf+ELvsz+0n4tt2NJmDXeobpzB11w9dXt5/NvcYNPEKWp0WsALjbzvLJ431OuBeJYLxFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haG2/0OagBCigd43jnPJLL0QvZrlhwi3LlkkxKLmQLs=;
 b=MM81bPQ1M5JRC2Vh+oHUXWYvkxgacSWPIxaVgN6HT4JF52NhvBg1ngseFVJ3lgHxWdfry9SsibRImob/vBYYdJkrf2OioHV9Po5Xlcci8hAxgzFUxuaS/mFBwV+19x16Y/Qycps3kIErt9O4nBzBRm4kJisV123pXgQmoLOLDbPPHLw1fDDrA6CT9SPCAYmRoyd/0Z0bMHS+DbLxLobmU4UB1wOLofGgO6WMgczavxlfG9Sg1CKnQo3u2UOxErIL8hzzMSrIEXU0st0l+rx80oP18NMESJZimxCnQiixxx3qEqZzndiHrAO7UAV+JwuNGf3cQgR+/B0vGs0HyHtbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haG2/0OagBCigd43jnPJLL0QvZrlhwi3LlkkxKLmQLs=;
 b=ihvq1XlgDRFaDbISzXGJZY6GMXqoyF9aHlZODr/uMONmeac+yo4YhuFXkwREP3TCfCJ6OFLVaA39o1NNfGhZt8rhvplmCaKLjCzJTTNnlOjlNuhDq44FZJzfCWCUQBKoFhA/nNPWcHkQjzOcaykqrsabBx1X7vd/8Ehz5o9WeeFYgL/Vy5V8BAM/AQGY8fQsAMIuK8RWm4ouC0NP5h2VMMKd75WAQim3b4zJLo0g6FBk2Znr1NUol1Mswu3faqrDoIkfOqQ1/mKXp3feoXrkOzqvbVm9EKColf4RmPrUJOfRMHFnVV1UkwG7hxbsZJc0etnFnckp4gZtknq5A/fGJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:51 +0000
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
Subject: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Mon,  6 Jul 2026 13:26:42 -0300
Message-ID: <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 62a5c882-f775-43ff-6304-08dedb7b6182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	NnlygYHPEdLMqgbAfy588GGFWeE0+cmp76wcvtPa7h+IDG1ObjUV4gyg9vqvA3dNmfLxq5VytFXkopfnsEjm9U9e5yZtPt1B1qJ+INSfSEgFSB6kncUMZQai+OLSNg35eUQdLDQXLhj5nildH0Eq6I8PPh0S0icOctKmktSeUkmDlKAL1on67rmUbP9kIWFWH11KzhwovJdAlSNgg/D70OX0M7FqmjSEWdXnT4bBGvHD8b5yvgz8u205GS+0jdh5Pc8JIv1rWAwsSBILv7f3mMZ15XSu9EUiEhpai6skyEZxaUF2k1KsX8RIkLwFnYTZ74vjsiMMBjm/UPou8W5udCviN29SNQTdVN5SDpnDO38ZBr9VDXpiF1wQW9CnixO50wxXXBeshHcZNzcWvamfdwAl7632HjIpc/CmnOEwXOYyGpC06AI1ApBGDZdjMVuXcouKEJjP3lIyuXU8yJEOu+1AP8DBumkIVegaQdxzRP9VROsdB0XIV7/7ABxyDdTwaRJktN/Hpr9Onv44Zd506ni6IWRp/g7ON5LlBX7Wd7owJGSRb5viGvt8G37gYm+E5jnXyYdRWvvGANaQ0IgFM2PdMDT/V3h+WtwDRNBfNDjo5yy4CFsYj8KGIbtqHa7Pnazk0HGy7I7bekmF0dHWwukktbvihBiNr3iuG+Bd1Jc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o3D7D9FiCEdF12pgBJ9JhuISks4Nh8bEcW1JYk1mSfPowiV6oeXLcEL6MfoF?=
 =?us-ascii?Q?jwoQB1TM96rT0GqTgxyI7EhjQ3JfPJ6BoOzJfMUlsuzT4JE8OyPa+yLu9oIt?=
 =?us-ascii?Q?qYgloYd9mRx8M75j7iIuYToghy+T2CGz960aAyY9w6cq5CVBxqCLpulDiu9q?=
 =?us-ascii?Q?P8Ozf2vb1QBBIqdYzd8/D+BRhfpB/5f/urR/TSDSX2UM7CHGNdkA/9StKw8H?=
 =?us-ascii?Q?MdYlU9mhklbqXJJFQr1QRDIdG4ggtN7kgped6CMJTXxtA+efA7BCNiqZD2eT?=
 =?us-ascii?Q?nW4rprztGHHZjkG8svtr9svxYQ2zKMGyJOHZzziF9pAQHwgqvqEQrlckO7oq?=
 =?us-ascii?Q?k3Y1NS7Skpg7TUxmn2zMDdvwSScMgIPt9thuLZ5EVE41Mlx+lhP2k7bB9rCI?=
 =?us-ascii?Q?r4tdTgaUGk7LnI9o4vbu9HvYcMjl/JbJRFFwGjEtMCjytG98d6mcOLnVkSCE?=
 =?us-ascii?Q?DP7qlDNRmjmnlgk93+0qP6vjO1hz4rLwk2W/GKI5mM502X3EJXTexcxG0Hgd?=
 =?us-ascii?Q?cv+wbk2ubRPkItQiEDpEoa8K5Zml6YLcEI7AIIBFncdK1DVUPLUJsj7rvDEK?=
 =?us-ascii?Q?8aaxibHnniXpPjPx2W4mCIJDbmrZqsqhz/7YHCWnqUXr+t7hR4NRZr4GqgWP?=
 =?us-ascii?Q?XVNBlwNN2E8kTvddly/g4b6uUUQ4DwPHs2pBe0JGZ18RorfaHeOFiicuM20H?=
 =?us-ascii?Q?c2yFUHP3mSKF5oS8vhwHOTF+SRfV9pW3ug9H8suDxtNapaaiTqerX8WAxtmu?=
 =?us-ascii?Q?1PFKgbXc+2O3BlqgFj3MDyP4Z2SnAyc0mgxiJO4cpS7X+ikWPtiUGrmoEIpr?=
 =?us-ascii?Q?1IVsiriDNJSGftSrRaNRTe3EgzYXrrLv+am/i0APe4tVs8rxeXWNtTGHI/EX?=
 =?us-ascii?Q?TCuX0iwUYLGBZcr+XvzhB0MolDgoWLImeRNgWefBoUZ4ogaMy7ADIgKggYie?=
 =?us-ascii?Q?6Lh/eP3FJORFSK2vhTIE80UAT9HMqd6oYUyCuTvZ3wFB7WmkJriHtNo6C17E?=
 =?us-ascii?Q?vbmLk1RZgBAFSfdO9xh6RTLZ6LMLu1Aken04FdBBRWSmAcDNSQIedCnFVgm+?=
 =?us-ascii?Q?cvlmhZziHGBUC9l8pl6vUhEukotjx1X13NTasxlF0cWK9t9jLbTjacu1XRyc?=
 =?us-ascii?Q?YOZLQjBcOXMsNg8yeivUipSfaby5wbOYBvvjhxmTMTgTP4cUy7CzVrUHB6yY?=
 =?us-ascii?Q?ODFRr3e4L8WK9kiZUkVteVOznAE04AZXUAd9oxZsGJJpMGhcdzBTKXpgYKXQ?=
 =?us-ascii?Q?cKU1ViPkTfd1RnaSbVL5/WV8r/U+CJ0nxYdLJ9/XU4cEUg03t8/+rj8JzZMz?=
 =?us-ascii?Q?YpKFRNwX3/9C+IrMx3robukYbDwijNYQKgLzVlfWDtWYMpQCrVtaG4+lctWQ?=
 =?us-ascii?Q?SwwuELb4LPkryQz6qzgkx7wk7Osv/MBZgeKbEQShkwOffLUME0/Hf9LJ262i?=
 =?us-ascii?Q?WBNGJJHBWpme/F5qG7h/BpkdJjkLqXn5/6BikSLr+FbG8de3mLxVxtj6YnfI?=
 =?us-ascii?Q?vbWxeB+7Fryr1jhcPAFE9iwL0gLzRvPqSRXq/PBLY9dXoYw1JRT4Y0kTvC2J?=
 =?us-ascii?Q?dpA3qZHw+vTeNJm9Pus2i+qaOa3RCufFOJkz75I7rnfDEv+DVslFssiLHXzX?=
 =?us-ascii?Q?1KkuWoUYzBv7wZ2mzlVMUtO+CCSAnEwkaeeToMNaj2gaUo5kzdPoL0yWoTPZ?=
 =?us-ascii?Q?ophQdY64zJiSNj7hQ1otksTM7h6xu/ytpd7JGhrXDETx7lXq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a5c882-f775-43ff-6304-08dedb7b6182
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:50.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1BcqFy6zc69mSUVS/xMs3sXix9qYkPRkjHQ74C0A1qcawZQoXYWEApLFo83W4Ot
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

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
index 02323fd7709f07..fbe3e5dc42f964 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2417,32 +2417,15 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
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
@@ -2452,9 +2435,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	unsigned int scale;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
 	 * io-pgtable and SVA pass a nominal last-level granule because they
@@ -2471,10 +2451,13 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2493,7 +2476,8 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
 	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
@@ -2504,38 +2488,31 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2555,16 +2532,32 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2583,8 +2576,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	bool used_s12_vmall = false;
@@ -2681,6 +2674,13 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2711,6 +2711,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2719,10 +2727,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index 3ef55f8af63d90..9d262ef6076225 100644
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

