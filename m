Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08650377A85;
	Tue, 14 Jul 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054792; cv=fail; b=OKggw5+RBcPSclBkxteY1MboiQi1UpK1HpmA0/RpnvXXVLcG7+H0MMpWQCVuXNA/Fz3fO6XMUhgzg1s2Mc4Bpy7JxGHO/Wa1fFkSTgoVO/vo+O7faaHXKeANTvrYSLaU8S1XJeUL/VL7K6rtq1WnUTva9E8JEhSBUMH6v1DsJaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054792; c=relaxed/simple;
	bh=zC5zqP/j+Q1caqdF2PCHArdfWXNjo7TR/mtq7TkFP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ecBHqS5IcdiRAqeI7ivcBlk3gEDMOyNlyHsYVYMBNvsh+yy8+te5S/a2KotPopmyuA4jNUexJdkHjHuDDx8uXviylmyquGlocsiXF8dpvXi9bPGdiJy2vHizavGrAnPwIvhtd3yrw13UAUtUY8zNT5C991FQnKm16LRdpCPFpLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bYarwGKK; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bYarwGKK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D0BPksACEX4RrU06xIReBXYcOpH5DdouqY1z3avA0I9EFytkXNW8pYtTOIl5s7DOhFihEs33yPjnzihgOtcZBfa68uJ0/04Td2dJc0R5CUQHs9hM42gLoWI0aWt3btgIDNGoxnnVyR0YgcRXpOz0oK1sDhkUyhfoWe+eXhbAGLLaSqf5eHqppm9LxxFamP8tDrb1d8HWT9GQiZyEVwktVCPsnMf7fZbZVHfaZvjQM9IlzkucHPfBufGOnc0LuszM/juaZX36qTOJs4edcbFJ3lncJuelpitqvp4CpDnntUGmkBDRLoKic2Es/yAX71EbI84mgUSLNujX/QtXi6Wudg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSL4JBMnxA+C1yCjvNil5XrzdZsFAeVCTwpODVfQseE=;
 b=Gy0OYz2htZ4nJ8+zz/p2e2UhjlmKd0FZX8zcOYkEyZjsfd4RnuhSTiH6gRzpyYqp0yDU6tdC0mONUhH9cOdcdl6fguKWRY15IBiC9EF+H4JGbtRoSqST7gMywYQaMT14pOmlUqW93sOLsia24Lh5x+ElhP+Gfb0MkayxvuqXPEK9nqtCMecp4q4R0WOJrl2ZSOIkh9VTLdUEdGsovs5HcfS29oCkbZOfT1C8+/ZqXX5qZKQNc6HHvJdTD6U2EJTH8Rcyqow/NEGMShYwe05qQ21t1aeAMvev9D5NzSFRDcvF/QMy0QGINTqTlb2yNFyHJXP6Hq5lXqnSKtT8TfqfxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSL4JBMnxA+C1yCjvNil5XrzdZsFAeVCTwpODVfQseE=;
 b=bYarwGKKQyFwa3s0QTDeK3wtpELWBc/9h9N+rg2bQfP3IyJuuPSiztg9pquBsDpEiEUgHxyM2bKEH7XtABvUYc5exULxvrkuVviy/dfSLMhqRC7ByR/qeY+ctaYi/dkxRKXaie+iOw9zlBdq3OU7eoeSvEZimEYaoheqchuVIlb6dC4YxPd1Z0Rw4+Sd/6O9QF3IO1fPpGtVBOv4RF6LrSAgWdCx1QSnEjT38POs47wbNMq7Xa9G38KZFSRs8TxlGEPGBvkWtcXbDSQK8wN2apgU6Xr+2CafswqoIRIerjvcwWoyKZKPSklpeEi+BViKaYHik4RaT5YAMTMq648ubA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:18 +0000
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
Subject: [PATCH v3 3/8] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Tue, 14 Jul 2026 15:46:03 -0300
Message-ID: <3-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0431.namprd03.prod.outlook.com
 (2603:10b6:408:113::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 37bce1c2-6ea8-40d7-5655-08dee1d82c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|6133799003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	qDqdvfEihrrNEEIoHd8JNB9sHFKtbpNeLF8XTb3uBqiwBTXUkCxCX7dUnqzyAkg1VkJVpTCX3f2W0ilV6SjMfcu5W5zBYpIcNCwQuuekhY03jrJWRVWfFDywK4TLBgJu3jI+p44Csb2qDgtwEYxV5wjhDM2ulE10A7D5FvSB0M2CBcdBYYXNqO2arFJgW65LmdD3PDmeSJ9Q8a45myP9+CDkBiuXNrMX4l7CpKfpZUzrcUQRK7lNKTJnH119lq65YcGu1mZAG5gR9uz7MG9iISkQUwmkzPw0jXo8br53OmeorYoxeCrO8no+hPDbT1OEkL8mqghOPhBjaIMJMS5kl32dWDHNVJdwcN55+IpuQS5zfwHfdWUkeRNybwnghQzoqnLNenTr5TwR96yOtUsJ4+yQusksEUF/ak8GTHwuncAR2PHZ0ZNC3xGsWiHv/VBUeZBO+WHLhNyR6iym1s9enKf3MI/qBB1gVvmFf0OrI6jEhmloNe0CEBm3IFY7Uz6iS8X7I1ISfSxor/DP9NH83cFo22MuCIUFaw9YlAfe805GhsAnjEcrxhwcw4P2zC2/6vmEjr2soBkppN0t1IgOxIuYr0MqBPnxeNWHf/ec1xluqno+M26LRpLIfyrg+0E1zp+x5PjvUlU2IYyJHfXP6woo7fSBkMqn1RJ1N8DPItY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rmr6FGkEQtajECK95BN2Z6Uoli+7aOhW7SECcYTi9pFfDDUuSoYyrXKgShUV?=
 =?us-ascii?Q?JjdJR2oviAgXDuBqZZNiJjGxWvfX/c4lReMl5/1kdwT4e5fqpZ6CqI7aStrK?=
 =?us-ascii?Q?2OAwtp1czKduXTNp4Q7bPD1LLwG0ISAIRjd4Dw2V21bHs7enxHQIIsE3ZqST?=
 =?us-ascii?Q?reTNE6rI5dLjzNQBJwYkAKVEF64tw3mVleOTN2XCJ8+BCf1MwHVycES5yrzD?=
 =?us-ascii?Q?ay2r/2rtuPAHRhAV+byLIQ4qbfQ3Abmq53gP/mgo7YejNcDMf0veEe4K0MbW?=
 =?us-ascii?Q?ttOP30/zsPL5gblFM8D3Ycsq/cZw3LsBXZ74fpYTOimjPbBjHKxIkByOL4xQ?=
 =?us-ascii?Q?9F4vQ/2iHEWWhAJ4xB4jlg5ZmXzhctsUQl2En+Ih1hteu/+lQWVHorPCTmEp?=
 =?us-ascii?Q?KArZuzKXZg4TFkYwZn1W0LLLym2Y9Q5383F45EQ9Qju0O51HyFHUurbemXJN?=
 =?us-ascii?Q?LEDESa+fxgBEX+o6zonPJSmzyvzuSPTwTgZu0LVorzGPuAZSBvT4RLMsLx/p?=
 =?us-ascii?Q?GdBNdY/JRCCj+w09Y/WXBtKEwyTmWzG02zdX1tP2zEmAH4AQV/a6JJCTAp5v?=
 =?us-ascii?Q?/lvF/dfTXmDtMH6lLluBzZ/BHhcli1Mzqodwx81VDWGQ4fEcdzuWor1AFstS?=
 =?us-ascii?Q?hoRwxEbC+xrDMxCptl5tcCgX+hauLKESJHIHHK5agZTprjW7Lty3Wi3yjy06?=
 =?us-ascii?Q?1mjaERZvJScCCpFqHWePyBa2j2ruJ0wnJ3/aS9QTBc4fBUjmJ/ZxdrtrDDmn?=
 =?us-ascii?Q?gwuCRol69UunSfy3uj0b5yWLviCiMO+UJe3QbhFi5J1N/gBQAVFcaSvYPFBX?=
 =?us-ascii?Q?oYGFuH56Mb+XJMt4WdYMmV0vtqPDMjL6rKs4tYLreejOjMv8qrh7gN4vQza/?=
 =?us-ascii?Q?/d6pDoDyu8BzduICplgMC5bfnPz5mha65zCtI0UxedNo+Tyq5ne5eDl6ZeD9?=
 =?us-ascii?Q?byKFXWYsNv1fA1R+fZGY6HiNvBEM2bSZst226I6uPpeCUW4b3BeAyb6HdLhz?=
 =?us-ascii?Q?kGF1P94AegoEfGbWpdpB3rf2Hd19cDrXSqiRtp18zGpZIV9EHyOTnnXWFQt4?=
 =?us-ascii?Q?IEQ0erhkTdocHySVrWHO9UjQOUZSenFkp4WJl4E4DyomPbnPxj/5NsLjI+wU?=
 =?us-ascii?Q?XtdA0c4C8O6vMAu4b9hn3elTUWDLdh/3zDF4DWMMCpGxsbTFHa/P2um2L9Hc?=
 =?us-ascii?Q?FlvdaUnMOC4xvjzAY7SWt20yqccKm3LAs6aVADoPg8Zd1Ty4alW+QW3uMJ/J?=
 =?us-ascii?Q?NMAFHUjNgac+/pTM2yqQMNIaYkRHIdUFyQUkX1ButSharBKyrUqUaftp00Ly?=
 =?us-ascii?Q?VC4mAIJvr+HOuX4pFgB25wwZ99qxAxNDg3Hy8O4b4iGN73l+i0fILfKEFAxL?=
 =?us-ascii?Q?CGScIOBLqLbWVT9Q+CUb4x5U5pRvyEQyXhdyvt+Wz6iNONR4NPDsGqs2d6ck?=
 =?us-ascii?Q?pccsUUO/SZNr2Z4rWd14bOQjFj0kZnK5PTlw4NG111H1qPdTiRTiNeJl4Y50?=
 =?us-ascii?Q?dNY7jcOSL697iU28U+jGDPydMS2xUyfG0fog3Tte2giqgnHXtyyTKC7gpOAY?=
 =?us-ascii?Q?FbKrGwbrl1AUsID0/lgf4hblbF4O5UZ92neGC3LUkxuhUE0bK9VX5/7yrS7b?=
 =?us-ascii?Q?0E/6bphdSPk4qsoOdDXlcgYg/4mIO3ldgRBsTElBCqIvTJTUgmQ46PQ3HsB9?=
 =?us-ascii?Q?atF9uGvmPNGgWJbruMDD+PLIZ1Ep4sVZc/csunWC/QJbNVpd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bce1c2-6ea8-40d7-5655-08dee1d82c7c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:11.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CXjsJdzsEIQ1PsqT3pcoCILJR3/8K4gAMTIovPi0Eniw9H31ERu6wMFnNj7bSU2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

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

This approach is selected because there is an invalidation errata related
to CONT that is solved by 'always use RIL', so we don't want to switch
back to single invalidation if RIL is present.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One range invalidate op
 - At most 512 single invalidation ops

arm_smmu_domain_inv() is modified to always pass in the tgsz because the
new logic relies on it being valid.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 263 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   3 +-
 2 files changed, 161 insertions(+), 105 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c567e8749f154b..b40ae0d1355477 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2395,124 +2395,172 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
-	size_t inv_range = tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	u8 tg = tlbi->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	u8 tgsz_lg2 = tlbi->tgsz_lg2;
+	u64 cur_tg = tlbi->iova >> tgsz_lg2;
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 num_tg = last_tg - cur_tg + 1;
+	u8 tg_enc = (tgsz_lg2 - 10) / 2;
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
-			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
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
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
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
+					    cur_tg << tgsz_lg2, 0, 0, ttl,
+					    tg_enc);
+		return true;
+	}
+
+	/*
+	 * The spec defines the invalidated range as:
+	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
+	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules and SCALE scales
+	 * that by a power of two. We must pick NUM and SCALE so the range
+	 * covers num_tg granules, i.e. (NUM+1) * 2^SCALE >= num_tg with
+	 * NUM+1 <= 32. That constrains SCALE to:
+	 *    ceil(num_tg / 2^SCALE) <= 32
+	 *    SCALE >= ceil(log2(num_tg / 32))
+	 * Choosing the smallest such SCALE gives the finest granularity and
+	 * thus the tightest (least over-covering) range, and equivalently the
+	 * largest NUM.
+	 *
+	 * Unlike other IOMMUs the spec has no alignment requirement on the
+	 * address beyond alignment to tg (so long as TTL=0).
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
+	if (tgsz_lg2 == 14 && ttl == 1)
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl &&
+	    !arm_smmu_ttl_addr_aligned(cur_tg << tgsz_lg2, tgsz_lg2, ttl))
+		ttl = 0;
+
+	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+				    cur_tg << tgsz_lg2,
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
+	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
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
+		iova += tlbi->iopte_size;
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
@@ -2535,6 +2583,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
+	bool used_s12_vmall = false;
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
 
@@ -2567,11 +2616,17 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 285a67a9a7a656..47241c0ef54cde 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1164,7 +1164,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

