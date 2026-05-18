Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62137BE83;
	Mon, 18 May 2026 19:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133435; cv=fail; b=KYbPeZUc/OWZLL/Ajk2QL1/bpYA0CvILfaZgEwxy2rab1hNbzjNfAkTWXN6vBnPVXrh4SnWwpfA/H0lvt1cU/pDcG3m8KGEmMI/EFKRoOBu8xNGq/5sJeD/8LxejJNCTdBY2m4Tb60QteOey48FxRwXo/5w/48px229FAHMLLc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133435; c=relaxed/simple;
	bh=RACPvccvetlkIjvlBi7efzDqv1Rdn+TTbggTMn6RS9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=li/n90YRy/1Pq+KHgY5pTO2HaptoSU1qpseefEtNyJJBcSxQa7JXiyhxryHIupFkA0QyXmznkk/TzPVtpHp0X0I3TTJakPYE8/BvO/dn4mfQIHZqCfe8NAa7NsAEPg6LukOVtjLinwFpuNGGkJIXb+3naE1PY9Yxie64WU2h/wE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gQbSYm+g; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gQbSYm+g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjPtDutnT6LZeag66Wktak/NEUr8wFU1jTlRXNEeCAjw7CvM8mCOFPoWGA/czwXF+ipyedAhpmMhlOodhE1CejFUrP2Sk53gfkvkRccUFsrMlCC683kJ/qWo7zl3buU5bfrYk3DyFctaGT9s3cvU7J3WRfLi2rqTBEMuWkOuxjKzFq+lX/B7klBnqOrEGwyBMpaP19T7KUI1BKiHB7wQR5auwSxkLZpeijolsCoCSd0mdJC84bbtIggHxpXMhmmbzv+Knxp2k0NKo5f950X/7HXJraof7nEQTyP+j7qBstb40Fa/04R3TYiemsjoepmsdrZVQ4spr++WyDUZAChvvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuM8TNENs94IbBkPfnmB+Z8/pygYxDP8gbLrS/3wk4I=;
 b=fkjY1V9/Wk2mmRK4h0zlt5UwXyf+FbJIW5Gm0GCzWa4R7VjQoZcJL2paL993gjWfZQTqLXhFRYMGmb1hBilZ1oHViMxrbZBgr+QD+JFQxmnExLKVAQx+/oAR1NA0N36/lzwk7M0aDFmsJ3duc3D30l/UDROdAy9w9jj3VPzyyf4pQklJjYXXgpj8/gs5ZzTJ1yuFVsdzqvflgODn5EwxqyBhyhPLT5h0hIEo4M/v+SzFBIUBoVXH26KQewky7aPkXaowNa2dSEvsuBUnfhPuLZet5WtIXfnonbsEWs4/h7KX0HipZWlwyOMUBfHc5wzg3JQUJ08x6FjjR3fo0BI1sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuM8TNENs94IbBkPfnmB+Z8/pygYxDP8gbLrS/3wk4I=;
 b=gQbSYm+goJ5pwrvJ//u3lAVlgIX2/vp5cK9cr52Hz9hz3rfomBcTYkzcKxz30JRIgHZGNnX9FKFeEz7tmGke7DePs6I2veoRPVAvDzaqQ4zLDQk4LkUhWNzUmxAO77vtnG12hwtFM1QScizy4qks/5oWm5GWsnzn9pJ+W+k2rKVgrpiOAhvRLvXi66y6oVcmeIKc8cy4TFOA3nwd34jDih0T+EBjYiCXEriNeSW5gMvFEXHf69TJ5ywwVY8DgTnynW3XGr7k0N0uL+H68h+tfueKKs4VOh7VGnhQeE7aYOdenxEUwHgf3lw+XXRK6O8/ZVfVvA3Qt9Jc8l/t3+fdSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:48 +0000
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
Subject: [PATCH 3/8] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Mon, 18 May 2026 16:43:40 -0300
Message-ID: <3-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:208:329::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: fd154c27-65d5-4e9a-ae8d-08deb515c69a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|3023799003|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	gPw4GbsZcY6C/MK6sGnHPaPdIHcc+O2Pz39x6QTMxFvcO2tOzDRfaMpbgPx6S63cqcR2DBr73TL67gDvcqNAQhlzyVjEBRt/eyGY33X5hDwVps3nDBR4aF0p/m4+O9tdAIKp7r5iI7Dn/dS+WolhHKns7nkaYQWXTW9tn8FR83qRQnG1P92/IVjjuRaaWoX5m0Q4aVtR9kLQndMLNiaa02RQwvLkq4f8jUavKYFjOWn8iBgAqEIkKw/yYkV57ikANrYD+NVaaDagUQdElJbBYaUBvBN8tbDLTPzKcHeDAfUv2oVtM381p+8IxctD81GCbKKcXq+RXlMomcfB/CK5T/VGSlXday+wM9vkpbH9jBC4kwHKi/mnvVKPCAXgw1DF7OOToEuB452H6w30dN4UK7vK4BcpG87qS8CQuFLF88oktUKTne0BqxtnF5lHl5vhXutnHWV5qSEasoToCqwzDlbqS5iy6QOPfslC+/kY3VkRCUnR9CnmYXm80Ozq2JTutNA+gyUn1nI7/HvnRoZbpUiWd3ER4q9SbANPLKAxIOcvPcZBF/1bFrJXVPMr+sMGRgpy8hC6LYEDvqkBjLVYoN+qhkCYZThgQRvHtz3ejOO4jy81Nn1jWOv0MugEYsLOSlMYiu6Vf5vWQbffKnnm+8agTtRTEXOYcmj7upbsE4vsqOmy1k7LcYD0UTi+jqK7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(3023799003)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fmdkNpXVa+b6TTcj2YihEyIW48CbtIBkdCBpacenE6DrX7UxKQADWIruF+L/?=
 =?us-ascii?Q?0WTmSnVvHteyZRojnycevVlGigIbX0ENF9oSxZiPvUY4nCKColDLVRKWtTbA?=
 =?us-ascii?Q?VzqT+iZXje7sSKqrJFVwUubsaaHO3T7MHo+4GMbda36c3Gusc+7y7M5HwBZF?=
 =?us-ascii?Q?SsIMdpDRcjMXnbV7YXYXPPSGkB7q7+uqWFi6r0Cqr8u8wDHFwhyrDaE3Ymou?=
 =?us-ascii?Q?zQdedDp2JRGaMM4BxNbthliUGG7aYJvksBoTkneWZoVx0XeUb3IJQLwbqSg6?=
 =?us-ascii?Q?iZl7qx8zKmnFKEryW8PdU+B+/caoylpVqvyeAirOtKgaMb8cyX/g6ZOVNErW?=
 =?us-ascii?Q?R+92Oo6mlS6zkHwwfRta3fhMlcWlD8ntw3+Gr42j0ySrWRdUF7CBKd9nl4VG?=
 =?us-ascii?Q?As0hX5rf8UEQXKYyBq+lU5mfvH9JHHrXaI836gNbGsYdWIDLPeHSDLQzSI7y?=
 =?us-ascii?Q?Dk9NDiK8kxuqVVP1UU9ijYe37J6s2TvKcB3+2ujAfU2plj2gLgr97B4NXUCt?=
 =?us-ascii?Q?dCxUcowSqasms68cG2FzQfcwsKpK+HvACdVUjDhWwKRPVO4fbNlpMSJKxJfG?=
 =?us-ascii?Q?xHqvsd6KwhOYGYE+3k8hT9rzH22EEH6DIFRa/MnxfJ6ycFqFHY1waalAEDYV?=
 =?us-ascii?Q?7QAtyJxtZPknlO4/cnFMXqAWHziiYZQNJiV+GumAMiY7mZLF7gEmZElRopyW?=
 =?us-ascii?Q?6ZghuOP4LvU+U+NiBz595QSFTPqzt6LkecLlneo/OetgDW3j4oHj2aRjMI+l?=
 =?us-ascii?Q?PSqF7vB+paor9AUNEBZ/lp4V9wdSKD2NII5yKypuB5gvQu+6g30OrhUhDqWu?=
 =?us-ascii?Q?Wp3nAFqZm4x5sV2j8dPtrM4vkSuPMDYIarAjzmUUXRwe7K9eUJxZ6j2OyDAh?=
 =?us-ascii?Q?4Hr6jR0inBg9e/NfJ/xk4KLG0UFSqqnDE87mlJJQka/1a9ZMmM97LkWZVP6n?=
 =?us-ascii?Q?T+QdYWWiS+6TJKt5s5+IzkBkraefw2r2XKCv6pv2vNNZnHyyGyuAixJW7gF0?=
 =?us-ascii?Q?xNglh5/uqGh7t3odHrvwjVc5yiorMqIL+2FUmzk3aq6U3kFkRZ/NMNCSj2EL?=
 =?us-ascii?Q?VEIIth2Z+W8UgEtYYwnWcB3CHoWLp26tChg0knUndp7XOt3eDwbxTMTg1Zrw?=
 =?us-ascii?Q?BE7AZnZeffiZ10F89t3uPZRnhwUwWvh30YLaPSLYybOEdxvzPTTKeR0/vxgG?=
 =?us-ascii?Q?knvA1wyOU1RTTMQhQQr9qvxBpLffTNdbF2kc+awYJp+svedeStz8YtCwpoiB?=
 =?us-ascii?Q?OI4IvWTXBsW10yH966mMA75LI6Fno56hTAZB22hiIgGzNbegNhJfPn+aleP3?=
 =?us-ascii?Q?d/0T8hrgNIR+NEd1Ssl84K1cA5koW3TPoXB7mkYPk0/0x3QMr6YZgG4/bk5J?=
 =?us-ascii?Q?D/nrrStqg0AKalgMtnZeKkUNKWoF/e/fuoHBSi8eQeGuGu1iD1T0h2bQl1Pe?=
 =?us-ascii?Q?5j3paJMVtYJ1W6oZqHVn0WJ3Bc7bLKAf3qGPENiVgWiodlLuaIqIyP2sdwPa?=
 =?us-ascii?Q?ho1rKL3gc47zIfP5GQV1gwuJ4n3cpgbn3mBOVYfC+mEeaRGsQ4T9ZPV6Zp+g?=
 =?us-ascii?Q?CNzf9k1zltU7ukj18bdmZVa0Cfj/n1MY82iE8Q2lRD6wo70F6iSIpAtyqYLH?=
 =?us-ascii?Q?24As+CYe0mmqtyyma2AVxrwr7gEx2Va/CYhplIveDrvYUydJkS5UhUxcnn4R?=
 =?us-ascii?Q?J++CJFsp138+l1eqnYfold/Q1+imonWGCAnPd7UotHxP7kDT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd154c27-65d5-4e9a-ae8d-08deb515c69a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:46.7790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2jjRa2oRLaM3r0pbEM9dO/BR0Z6X3MjBH9uoTNQ7TowNOzUG6MjigAdW5S3hKMl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller
range invalidations.

Only if a para-virtualizating hypervisor is detected do they switch to
using more accurate invalidation. This also triggers using
iommu_iotlb_gather_is_disjoint() (ie PT_FEAT_FLUSH_RANGE_NO_GAPS) to
remove over invalidation from the gather. A pvIOMMU has a hypervisor that
will walk the IOPTEs and resync them. Over invalidation, especially
significant over invalidation, can incur a big latency cost reloading alot
of page table. x86 IOMMUs have aligned range restrictions so there are
some pretty nasty corner cases that can trigger huge over invalidation.

Currently SMMUv3 doesn't support detecting a hypervisor, and it
unconditionally runs in a NO_GAPS mode. This makes some sense for the
single invalidation flow where there is little reason to push single
commands across a gap.

When we get to RIL hardware, this doesn't look so good. On real HW the
best option is the same as x86: issue a single RIL per gather and optimize
for latency. SMMUv3 has a significant advantage as its RIL does not have
alignment limitations so it's single-command over-invalidation is capped
at < 1/32 of the gather's size, making it much more suitable for a
pvIOMMU.

However even with RIL SMMUv3 still uses NO_GAPS and it breaks down the
gather into several exactly sized RILs to avoid any over-invalidation,
costing latency on real HW.

When the HW has RIL support follow the x86 approach in SMMUv3 and
calculate a single RIL per gather that will cover the required
invalidation.

Calculate the smallest SCALE such that NUM can cover the range to minimize
over-invalidation. Always use a RIL command if RIL is possible working
around the spec limitations to form a valid one. If RIL is not possible
then do full invalidation.

At least one invalidation errata is avoided by 'always use RIL'.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One range invalidate op
 - At most 512 single invalidation ops

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 257 ++++++++++++--------
 1 file changed, 153 insertions(+), 104 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cd0ab518712cd6..59634a5a5c0640 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2376,124 +2376,166 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 F.b Section 4.4.1.
+ * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = (tg - 3) * (3 - ttl) + tg;
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
+					struct arm_smmu_cmdq_batch *cmds,
+					struct arm_smmu_cmd *cmd, bool leaf,
+					u64 address, unsigned int num,
+					unsigned int scale, u8 ttl, u8 tg_enc)
+{
+	cmd->data[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+			FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | address;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+}
+
+/*
+ * Issue a single range TLBI command covering [iova, iova+size). Returns true if
+ * successful, false if the range is too large for a single command.
+ *
+ * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
+ * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
+ * the invalidation range.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_granule;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	unsigned int tg = tlbi->smmu_domain->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
+	u64 cur_tg = tlbi->iova >> tg_lg2;
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tg_lg2;
+	u64 num_tg = last_tg - cur_tg + 1;
+	u8 tg_enc = (tg_lg2 - 10) / 2;
+	unsigned int scale;
+	u8 ttl = 0;
 
-	if (WARN_ON_ONCE(!tlbi->size))
-		return;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = tlbi->size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (tlbi->leaf_only)
-			ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
-}
-
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
-				      struct arm_smmu_tlbi *tlbi)
-{
-	size_t max_tlbi_ops;
-
-	/* 0 size means invalidate all */
-	if (!tlbi->size || tlbi->size == SIZE_MAX)
-		return true;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+	if (!tlbi->size)
 		return false;
 
 	/*
-	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
-	 * this is used as a threshold to replace "size_opcode" commands with a
-	 * single "nsize_opcode" command, when SMMU doesn't implement the range
-	 * invalidation feature, where there can be too many per-granule TLBIs,
-	 * resulting in a soft lockup.
+	 * Determine what level the granule is at. For non-leaf, both
+	 * io-pgtable and SVA pass a nominal last-level granule because they
+	 * don't know what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_granule) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_granule;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg_lg2 - 3));
+
+	/*
+	 * SMMUv3 F.b Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
+	 * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
+	 * a TTL hint to target only the exact leaf entry.
+	 */
+	if (num_tg == 1) {
+		if (!ttl)
+			ttl = 3;
+		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+					    cur_tg << tg_lg2, 0, 0, ttl,
+					    tg_enc);
+		return true;
+	}
+
+	/*
+	 * There are at most 5 possible values for NUM based on SCALE. The
+	 * highest NUM is at the lowest SCALE where:
+	 *    ceil(num_tg / 2^SCALE) <= 32
+	 *    scale >= ceil(log2(num_tg / 32))
+	 * The lowest value is 1 where 2^SCALE covers the whole range. Pick the
+	 * highest since it trivially also gives the tightest range.
+	 *
+	 * Unlike other IOMMUs the spec doesn't have any alignment requirements
+	 * on the address beyond it must be aligned to tg (so long as TTL=0)
+	 */
+	scale = fls64((num_tg - 1) / 32);
+	if (scale > 31) {
+		/*
+		 * Range too large for a single command, use full invalidation.
+		 */
+		return false;
+	}
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (tg_lg2 == 14 && ttl == 1)
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
+		ttl = 0;
+
+	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+				    cur_tg << tg_lg2,
+				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
+				    scale, ttl, tg_enc);
+	return true;
 }
 
-/* Used by non INV_TYPE_ATS* invalidations */
-static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+/*
+ * One TLBI command per IOTLB entry, assuming the entries are all at least
+ * iopte_granule sized. Returns false if too many commands would be needed which
+ * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ */
+static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
+					   struct arm_smmu_cmdq_batch *cmds,
+					   struct arm_smmu_cmd *cmd,
+					   struct arm_smmu_tlbi *tlbi)
+{
+	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
+	unsigned long iova = tlbi->iova;
+	unsigned long i;
+
+	if (!num_ops || num_ops > 512)
+		return false;
+
+	for (i = 0; i < num_ops; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+		iova += tlbi->iopte_granule;
+	}
+	return true;
+}
+
+static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
+				 struct arm_smmu_cmdq_batch *cmds,
+				 struct arm_smmu_cmd *cmd)
+{
+	u64p_replace_bits(&cmd->data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+}
+
+/*
+ * Used by non INV_TYPE_ATS* invalidations. Returns true if it fell back to
+ * full invalidation using nsize_opcode.
+ */
+static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
-		struct arm_smmu_cmd nsize_cmd = *cmd;
-
-		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
-				  CMDQ_0_OP);
-		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2516,6 +2558,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
+	bool used_s12_vmall = false;
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
 
@@ -2548,11 +2591,17 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			used_s12_vmall = arm_smmu_inv_to_cmdq_batch(cur, &cmds,
+								    &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list.
+			 */
+			if (used_s12_vmall)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
-- 
2.43.0

