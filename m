Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A76327BF8;
	Thu, 17 Sep 2026 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604899; cv=fail; b=nR60uxzVXbtzJJWZhm3w5hdVsSDsro4z/Q+25+hOjQeDrMg7ycyRsRN9xaJsqxrQv7hDQKBfeNL02Fgvf18pZQ+ICD6JFW/vl54M6y2Nzr6G6K1rd57jRFsRt5243hxVDiOqoyiohm8VzpyINhrb2QSd7+nUKYwSpShg9bCzrM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604899; c=relaxed/simple;
	bh=uphOe1hv26DQAjyPhAJWhHSO9D6rqZVxLFo5Z6hqFkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JI0/HTtWIY3MJZlqsKaswguCzoAgXAI9zKWuSCSMwF2MfxJPIX2X7x3wM3w18Ha7+FxdiHgCAHKVbxwUNeRtrnvNZXWK5zehLle3hbkCyn3lxYN6yHyC4s5cYbEu486w0GKB6RyBljeA0xF+fwsTQYrAuuQkzxIwXwrVz2uQdE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=APXZ1U4J; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="APXZ1U4J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKo0+wPiXMdBKg/a3nDaIEevForOPqmGHJR58cmaBIDNKbCazg9VVDQHJWey/Rpk9pXlgKqNX2vyMEjFae7E6pbvB0iCFOKsIVFW6HH3jbJ9S9oeMaE8BMgua3WGNOydM+H2IsXHoMcml+tJ+mSXabuhv0ceccHWwKLOkEU1UyZFrjWRIPhmDP1BKQ7ele6d338cCsvL63Bu/SXZg6XqoVIDxRdz0ELZ1zkAL6YkfpcAWafR9dsFPtPxHtHTgWtsAmPZXCJLn+/HaVXpmPNqw589kARcIKyQygJ81FLXR8i+XySuR4tN+0RLmQAZ09U5qrnpSEqofAfNkwpZ4wB8Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89kzCuNDxgvFM4ZPxvVm9+RE4vSCbxS9uCI/TwDHMhw=;
 b=iBSKKOOzwQmGhmiJoXSaLe6YVD+tO5JxFTOqbu3VNxrX62eD3qubtS4QmoDeIu3l5YZjL/4bbWEM4/2tskoZfeI9zefWdQeK0oLYFttUDwt6XE3Gzpb29e3ZZBNJ5927i0uuehIDPPu4DG+1KSuAUK1fwpOvmzf1FFL41ctleOe7V/2sFUKugF2n7CduFAZNIBK9PNBJBHNJjtVXOGAeefEqn+Wqpe9Uv9Jg1ZKl7JGnPmdykjIgn1owpIiIgpzfVGC4Vrr+oXfN+7ZN0ugNPTvkw5NhlxtLwZ91HTjx9xMN4rhZu03USiTDScwJ+Uvud7XBMHlgM+mlqCd465hzZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89kzCuNDxgvFM4ZPxvVm9+RE4vSCbxS9uCI/TwDHMhw=;
 b=APXZ1U4JByL5XHZtbw+faCXYelwAHhJ1z1GSkPdGmFJTyn+pzhYlT2Zy/IcjGI11toIzUJk8I45mWV6rz03tCkepkhuYuoe5IVmWxJxXBgVflPcZxzCiR5xXkcxU4GTRfqdEO3jYTU2QJDIi5kIXY0929CLXFm8aF2vZwuUh1Y4Werla8L+wRO9xvcW3Slc2IxRlnNP3NYnptFAvDrr6svAaAaJZYR++pBa/+K6JeOO5flc0sUqNZSgxoe9tw+dZfXHbjGZSZF0K/yslfGB6+/Y5c5OwObN8WPQHKXO3wAK50mHBcBjfPmzGrrzpXCqqQ6yc2lqM4BVI2iLE9vQOnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:53 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v6 6/9] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Wed, 16 Sep 2026 21:27:47 -0300
Message-ID: <6-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:408:142::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 2426c521-7fa3-4209-2efd-08df145282a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|11063799006|10067099003|18002099003|56012099006|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	jKWuLreepiZVbxaSOjZvNS9hdCTdJ8nO83KHuugBfGyYVdD8WGfE3/HLbYioN5kNkoZjdmg0vIeXPwz9JgB9l+WP40U19uV3l0M1Kv7ueJMtYMO+JM4DpOOUe8UgBEXvFaR4sDoIj0iUUls19ma2i8U44D4kO+Ojf5DJOutYOKJcARmc/hVzwnimkXG/WziaNxEGcas+UYNimG6zvgwN2sXViBojn0xfXelNYzCJuGtrJpqYwUSPUdcP1ru+Uo5vcXoQqbLfZo1wjJtEXur3OqSC7ZGiUazvJVGpBlQs4oT7fwh5jV+8o7Vfdr4KmM9EdEZSaQNElHtrFwmIu7Bp/eGoIQydRgsN4cA5zgEAEEVnT+tegSx8TNYwkgYnBp/YqF5tFiAma9gsnUeAxwfM55MGpqwTM0B+vjbHmarwNMiy1yHsg5yd6Iw0XF3exy0f0M174+m+IcdktMCllOjhUlobojXpOkDgqKmjaR998fJiALvT4XCqOPdiJLikZcupjjvKY/Sr+uENtj/9f16mDEMphuwW77Rj+H65MTzfAQrTY7HniIa5BzVOPIzZI5OQmDeHds6IdcrXKELLO+w8LTP86426VVyQzHz6NnRaA60uYy/cr5Ia0A13iyhzP6MkSaWzNKXBzhSSDSz1mPtIaOg5OhveCC9rSPF8fIEMx52cwd+Hl2Gj6Ni32sDO5nu70ehKMSDHlOm8LawBaSsFBQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(11063799006)(10067099003)(18002099003)(56012099006)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u2lpnNaq/aS8JhNHzjNbj3mTOK4eCOV242Xjdku4JcsSjyRDZPFhLyYO4fr1?=
 =?us-ascii?Q?4osOP4BVN+3N5d/l0gWF85Tgiz5+xvg27DhZt02Jp13ljPfTUfGwYy2ZeMKv?=
 =?us-ascii?Q?bXFYmUojXGOxfyRg7yPwpV89Z4EQ6n1FSS7SroJB+xrC8gvDLOSSwqJoAnLN?=
 =?us-ascii?Q?L1a+ykISDM4dSGgEXdSwbGGRj0Zzprn3fla1TVttFcAyqQHBAGrTTfENddRt?=
 =?us-ascii?Q?kLTzrIQLLpgUM0e/lB6gaJ7129WkuecENYbWvU+i3wrEsZLxMALuoRAHWcY0?=
 =?us-ascii?Q?7MZDUPZPMo++QnbEsmBWyh4a8B87hr/5aWoovVcu1OHe/ncUl5u0k5Z2QSbh?=
 =?us-ascii?Q?fwvtnk38fFfccboUtilunus/x9ApYmp4ltCvZVRm+JCGwdy5XxXxGKE+ZegH?=
 =?us-ascii?Q?HFCAPa161PKCeenh5MXR1EStTfsgj9DseOJm6ptoRhsxa46Dg/P/VwJCDgHP?=
 =?us-ascii?Q?J/1KrZe5gRJyhxvqM0pU6gvJ9gXRMyN8A5KBhpgM1Zp3+g8A6DPQKHNve6Ev?=
 =?us-ascii?Q?eJCQaByin7LXjq7mlU3kQVb4tZOyHa+sYtIcHsIKZV7iSNnk74fLIMZgvZ88?=
 =?us-ascii?Q?bjQlo7aX86ywk1NL21prsgLF85YI3FiXJ1D46PPOHbpWSkeQHEeQ7my0JmT9?=
 =?us-ascii?Q?Gz8E3WZL516MaIIRqtd+74fA762DjCAGCSK0z/6x7/FD5TO3zCeskhLJ3iPV?=
 =?us-ascii?Q?2HMTTjey6wCqusYYuzMTYXwMCN8/DUuUiSwUmI7X+JLoG8MkvvBZeuxoYxd3?=
 =?us-ascii?Q?7NxPnHhYHY1du5KyBg8FXKlv4srYpFmPOPra5IWO9MOmCZb6TOJkRYM5f+KM?=
 =?us-ascii?Q?8Co0rguijQmgwtEFkcMn0gHSuCrrtFbpLuFC3MYxN/+nCw8v/v423dWkFgPe?=
 =?us-ascii?Q?lv2z6wXB2HfOME7N48TswzALKOINmtLgNyBcXbnCCUZo+QmB3Nq+81zDlH9e?=
 =?us-ascii?Q?yDWY1KZBsS+P2+jyLJpWoYIqMMulhYFzLIQRtoi/SlDOyd3OSZmFxfyslKww?=
 =?us-ascii?Q?nXmGT0oF/zv1smx6Y45/KWVAnSMIFyJrmkIhz1PC5a9Pj1+TPeoTVlnka5kO?=
 =?us-ascii?Q?tLLhekyfRjR0x2cmUW5z6d/liFvw2+A6JFJo2FgJLoWd4klX2pco1JJ6CFyH?=
 =?us-ascii?Q?B2nz+4GBbIDnT10DNbCt8q10EE8TBKWmPnYiV3N4L7uwLAQ9yxNGqWyJfMxf?=
 =?us-ascii?Q?RCr6MAQyVoMVupltlIQ2Fp+0JQeuK0au1rmrTTZCdr0DTgO9uljAtklStCP6?=
 =?us-ascii?Q?yFs4Q67MHljHUL9gUQfThufWLQAN5w1eG+8aRP1Dc6kBoLGh1n50hL7xDe3X?=
 =?us-ascii?Q?x482I7HG/oUFJFyW1zShNTkBj5bbwdK8BWRLMSx1L5RdqeKKnv2XRpndEFq/?=
 =?us-ascii?Q?XraSouBdQ1VyKDrVu3V4eA/Ahhsj+brSHkaKwCys3Lhk7+FrlstlJn+ro8lp?=
 =?us-ascii?Q?4/1/a4oPoRnRDi/2UmcsOkwPUuk0/Z9I2uifV8c4RI5n3Gs512sFB25Kh3HJ?=
 =?us-ascii?Q?oGhrdQ8Wlxk0MF12AA9PyewcnUapVvclNTIirFPQzEpohO0eXNb0xnQooj2M?=
 =?us-ascii?Q?C//6qhjHnPRGq0Swz13UY7i3QaiZUoPbIvS9bFk9U38su55z2D0MRIqBc3fE?=
 =?us-ascii?Q?AIeYI5FxDT3f7ewr3/oSOAQ9rAwGWWB9q76DHVAXUltkb0NDdECrFkCs+uSd?=
 =?us-ascii?Q?0Igbbs1/k+bAuyA1ewR0PZX7VNFwQjOaiNZVxI7eA+KnV5sJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2426c521-7fa3-4209-2efd-08df145282a4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWWwiyEjfcUPuoe1cw+lXnaXmX6Nxr7HE7ueD88DELIkgB9OxQnWlONOYwvqJ767
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on
if the instance supports RIL or not, otherwise it is always the same.

This avoids redundant calculations for each invs entry.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 141 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
 2 files changed, 91 insertions(+), 62 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 670ffa87c076ef..0ac832534311f6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2516,14 +2516,12 @@ static struct arm_smmu_ril_range arm_smmu_ril_init_end(u64 last_tg, u64 num_tg)
 	return ril;
 }
 
-static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
-					struct arm_smmu_cmdq_batch *cmds,
-					struct arm_smmu_cmd *ref_cmd,
-					bool leaf_only,
+static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 					const struct arm_smmu_ril_range *ril,
 					u8 ttl, u8 tg_enc)
 {
-	struct arm_smmu_cmd cmd;
+	struct arm_smmu_cmd *cmd =
+		&tlbi->range.cmds[tlbi->range.num_cmds++];
 	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
 	u64 iova = ril->start_tg << tgsz_lg2;
 	unsigned int num = ril->num - 1;
@@ -2552,18 +2550,16 @@ static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
 	if (!num && !ril->scale && !ttl)
 		tg_enc = 0;
 
-	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-		      FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
-	cmd.data[1] = ref_cmd->data[1] |
-		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
-		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		       FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
 /*
- * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
- * if successful, false if the range is too large to fit into RIL commands.
+ * Generate up to two range TLBI command payloads covering [iova, iova+size).
+ * Sets use_full_inv if the range is too large to represent.
  *
  * Normally the first RIL is the largest representable span which does not
  * exceed the requested range. If necessary, the second RIL is the smallest
@@ -2571,14 +2567,12 @@ static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
  * excess coverage from the second RIL overlaps the first instead of exceeding
  * the requested range.
  *
- * If a SVA is being invalidated and the SMMU has the ARM_SMMU_OPT_FULL_CONT_RIL
- * errata this produces only a single RIL and overinvalidates to ensure any
- * potential CONT is covered with a single RIL.
+ * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RIL,
+ * produce only a single RIL and overinvalidate so any potential CONT is
+ * covered by one command.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     bool single_ril)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
@@ -2589,9 +2583,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	struct arm_smmu_ril_range trail;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
 	 * io-pgtable and SVA pass a nominal last-level granule because they
@@ -2612,10 +2603,11 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	first.scale = arm_smmu_ril_calc_scale(num_tg);
 	if (first.scale > 31) {
 		/* Range too large for a single command do full invalidation */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
-	if (tlbi->has_cont && (smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
+	if (single_ril) {
 		/*
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
@@ -2631,40 +2623,27 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		trail = arm_smmu_ril_init_end(
 			last_tg, num_tg - ((u64)first.num << first.scale));
 	}
-	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only, &first,
-				    ttl, tg_enc);
+	arm_smmu_tlbi_add_range_cmd(tlbi, &first, ttl, tg_enc);
 
 	if (trail.num)
-		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-					    &trail, ttl, tg_enc);
-	return true;
+		arm_smmu_tlbi_add_range_cmd(tlbi, &trail, ttl, tg_enc);
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
 	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long i;
 
-	if (!num_ops || num_ops > 512)
-		return false;
-
-	for (i = 0; i < num_ops; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       (iova & ~GENMASK_U64(11, 0));
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += tlbi->iopte_size;
+	if (!num_ops || num_ops > 512) {
+		tlbi->single.use_full_inv = true;
+		return;
 	}
-	return true;
+	tlbi->single.num = num_ops;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2684,16 +2663,37 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
+		for (i = 0; i < tlbi->range.num_cmds; i++) {
+			struct arm_smmu_cmd range_cmd = tlbi->range.cmds[i];
+
+			range_cmd.data[0] |= cmd->data[0];
+			range_cmd.data[1] |= cmd->data[1];
+			arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds,
+						      &range_cmd);
+		}
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
+		iova += tlbi->iopte_size;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+	}
+	return false;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2712,8 +2712,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
@@ -2808,11 +2808,17 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
-		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
 		.leaf_only = leaf,
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
@@ -2843,6 +2849,19 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/*
+	 * Only precalculate RIL if it will be used, invs generation ensures
+	 * this matches the instances used for invalidation.
+	 */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv) {
+			arm_smmu_tlbi_calc_range(
+				&tlbi,
+				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+					invs->has_full_cont_ril);
+		}
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2851,10 +2870,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index d38cc176c2ce6d..49ea829354b723 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -828,8 +828,18 @@ struct arm_smmu_tlbi {
 	unsigned int iopte_size;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool has_cont;
 	bool leaf_only;
+
+	struct {
+		bool use_full_inv;
+		u16 num;
+	} single;
+
+	struct {
+		bool use_full_inv;
+		u8 num_cmds;
+		struct arm_smmu_cmd cmds[2];
+	} range;
 };
 
 struct arm_smmu_evtq {
-- 
2.43.0

