Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C677E313543;
	Mon, 18 May 2026 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133463; cv=fail; b=ShJYbMbmCb2lzbiU4D8jSFcGJWZC4BEiV+zdlw9A9kP5IOSdb7qFKDv/tjKYIDjJo5oNYBSV73v/ynmJLAe/+7fyAbCAWOnvDdsE78j7nPXiU42EvjvHZFgdSZxi95wq5O/a6pIt8jinH7tS7MF8sIRpzMB08dNt121evPG9FQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133463; c=relaxed/simple;
	bh=ZLtPkf+Aaaao/W1L0yWy6VUlPwa2H2K4a8A2+QTPnLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pAjOx/sWynHD1hpKCvk0lkAW5MP8RXJMb2b//Pd+Wavaq/J7Yi0+B0WtUtoqwbXkpYPYsKr9ZwXIJXKyWS7Y5BZ8LUE6OttuOeRHNG6so69iaXSYTSHvXE+yFDW1LMc30C4f3AblYlaFp+74HgIn6p7kOW/IHSHgfq3j1bS+uP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TkymmzeU; arc=fail smtp.client-ip=40.93.194.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TkymmzeU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GAvYNEGJ83CBcq/rZchiyVNFdE1K9PATvCkW8EFX1WvAWEuKZ+4fHmC3hSia+3h3yV0Qce0NQ+dVBjlMWd/98RiVkxGdMiReSwz0r3ID8nKJJdrr+N8hLPifLOB68YPPSKrbopKtyje5CcGdhCKI29GrtSDk1DWnG7/gGl1VrHhOacDyZF6iGGhz60yk0fObXWtXXLD2bewiSTgQUcDSB/p70Gm4GaEPD9+2X2KsYZLILCw8Eu4wqkikVe7O7ZlQB+oEhy/cZhg9PU60b9fweeM+jQdBju2TjgPP+bofeOH4iJWmtE3Gzo/tr/MDYwi/Hd39WuZ4/fHxehe9aWUSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYPmZUVmgIlmXwqczNg836tEPXdBQPR3ZJoFK4HqKwQ=;
 b=aFgRYizNw5+0CBT3ubDWIwdPy3pvrcHefkLVeCDqFzB16x6x+uKu1/QuT6Y9UApBiOsablbXpmLrplhV/A/XVRjoqpiZ5nEN/VhVzaUwP4jMznDBLsqVK91upBaL9VGH3Y2NjaUU8WL1mYIG9PW7iHOyJd0nw36p4EiCsWUbApcPRgEsnejukvU7nHBDovs1/zrlbPcLorE6tUOMMKMQZUrxHTnyD+Q87iZyes3ak6Fe4eAO1PtsGElWlDs3YlKvyqD4YDhKW8MCaXRJTIQsTi341RRMSd3eSZYbCKjwYusQZtjDL8XhmIpxgMfXBd0rXkgzmczWecNObqN+HVbj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYPmZUVmgIlmXwqczNg836tEPXdBQPR3ZJoFK4HqKwQ=;
 b=TkymmzeU2xgeUabqqtr7PQp3neIP7pGu1x9XDs/1ekwlBy4QAT+B6tFE2UnARq4Wo/yCrkvS3b1cRRaNQ7wi0A2IfjEgMj0/q0c/J2kF3XVmhDlVUnZHP6mznJQzLGgJBEsgUUAF9Q2J9nmZOOlQq4Ye2AwccEaN+fPs7puDoUhcTGzvFqlZq49PB3e8+c4x3NWrN0WpRoAb83LMNQhPMVDetRl0wV+XaQvuw8q676TFN4taH1W+UvQD5h8PKsh9npIMGVMhY4w5iz7pIa96YC/Lq08YN3Ib4C/6SW7O196hCpLmnqGShhiRgxyWdmyMXpelGkLQCx1Tjau8uo/oOw==
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
Subject: [PATCH 8/8] iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE
Date: Mon, 18 May 2026 16:43:45 -0300
Message-ID: <8-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 50c1c1b9-e7fb-4348-3c5d-08deb515d790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|11063799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4Ad0w2qppjC3M6Cwi6pmnOwYjvr91peeRb6tLXZUn6mLL58CHM5CsRNeujpLET5aCAKria3my7H0kHjcRyrOZBxfiTJh6gJvkp/nE3+sVCxcLAmnPBh5JbryRsV7V+TfWWZsJJUWKUitxasTSJnKRDNDw1kyws9Sk6WrqMZwq84VrQ0ocQvSYxNiR0dtL3sEM/JsjN73A1Ef5A+jUGKBkiAGs7vI2pF68vT6S1xR6zX8vUgkdrDbPBTRQ9sIVw1EP336GvZNx2LeT02e2Tw3vTz259lMwNKhnuVhfYTENp94/eveT4HtmxdAaATeQI+B3O6oMuBHfSgrsfK4YNhmJnjfPdekPI7Dm9zH1qDSnnlQu+pUB5K0rSQ/bq1fqvvyCGv7Zs8eNIWQ3MPrXkJDhx2LZ3l2bESWSTaZaYMPCXqxnTPW5A+/3IFRo97OPdKQ2vt8fUj4ZWsdffDCDaju78imRquJS3dBEzu9IMrNjw5tWjoN5FVjoq6fMd0AWpbTOsEESb/Wi8A6VLpAwW4DgSH+y69+5xGPVkYh5rG0nt9XtxS7m5UR20bhReOKhpYnRMeUOAuZInyUULaE2DETRp7s6LcnKaHWd2mRBDD/Tub0jO67lZKkTxkU2SJlTxtP0L7Lw+kBaP4hIaIF2yxSFbDGkaRTszz7ib0/NO3Z9eIcrO+Q1uRYMlnDhBAoeVhd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(11063799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jLyd9ntfWoXA2lSOy+05rnKb6Zhwf65Az8GbJMtuqVJhFvgmRQB/YfEaPy9N?=
 =?us-ascii?Q?9GogKfOS4CVcW7wHkkvmQWi8ZaELufjwNPYwVUKCzQvQqRpMOzBv1SNJ1hQl?=
 =?us-ascii?Q?6jkakbSVRU730cVPWuZ0l7Hj00fscsISyJbfRSsPlAxvLDjn70evWnEwn+Xb?=
 =?us-ascii?Q?iJ1v6zDkX4ffadrIckmuE56zG3fZ0LhjceXItqJeYF8263nDJwF9HdzJ8xff?=
 =?us-ascii?Q?+3oRBPbwLe1yjcQrlfXorPSZQbq1YJtSltL2enmMJ93CF3ZOmWsKS9lXRZR2?=
 =?us-ascii?Q?3P7gT7yc/wB6AEq2d86jYLw/tqLTZ3SjFrVmttSrQhe5s3Fx/NWTdkGxlKf/?=
 =?us-ascii?Q?pHUW5yyyXiA8mls8Ox+H5ppPb2wXDxZcPjQ7pW8roos0WVnKFxRIneMcEcnI?=
 =?us-ascii?Q?NCtSgVOYdLTPKoQICrI9xsg6cBg84u+y12Z9wj+wqW+NZCqNo1bfrvgsEGhc?=
 =?us-ascii?Q?RfAOlWr0sCGWAwYcPmTKFDd+Z9BUPphT8cwQVD+9Co0OuBx7UREcR5Hef76O?=
 =?us-ascii?Q?b68OYMXrtqgEaOOq+ROI/QrOO5LKd/iehPOwnc8P+Dl2DsIUTqPAmy3OamJ2?=
 =?us-ascii?Q?Fzv+21Fs6YEGM2i64snGH674loK0/9RjbAbvqP1ljnYFY98qI2fZMS8lZcaL?=
 =?us-ascii?Q?pJ5lE0f1uf6EnYaDryQmuQfpd7A6HomA8D35BbP2Q0pAzzGy4VuXVfvw11mF?=
 =?us-ascii?Q?o5GcKCFgWaqc8osmdNkkzLYRUiapmHJMGhZPsKLhXNfZo4IWQRpRqjbom8wZ?=
 =?us-ascii?Q?G8UByNhsnfxeF5gPk6gj9Irugxv25TvVXpjRiiMfxG/938aPlvcTQE/7/13l?=
 =?us-ascii?Q?bgkAZT3GtXx0tt9pRK7RwyCbvn7ECSCo3jycv8I6okYhvwVF777+JgzOJTUe?=
 =?us-ascii?Q?ZQcJARzcZaR3vmot9znUegae37cakov0FU8rWro/fGKe1/pzvYgFCJhMMXgY?=
 =?us-ascii?Q?6pmdSXjpXqzHnafuyrjvHcW9XGw0wgZymYlrzRNC0+oQMWgFpKFmXq5xWBIe?=
 =?us-ascii?Q?oTsLOpzcZXLXZ3pRV9GpQOYtIchQvlj5tp2lTjbFcRB0dG38xh/znROkBOm7?=
 =?us-ascii?Q?JgXcvamNV6aUBO+8LpWpFEON5lFP9Lzwu8IekSZ9/mTIu8QV8LjmXnSAQxN6?=
 =?us-ascii?Q?pvBl+mFOtcTUBeG7MumxmWEeeE/Q1c6svjz71sxA94BwjTimE0QynNI1aArS?=
 =?us-ascii?Q?YKqWppoUcUiaLWzo/r+LCV3fLNwwLGjLtAToV8J//zxP1CY04QXpvpgNht9i?=
 =?us-ascii?Q?iAEmTkXEHh8FSOS5qYgTDVnJ1rLQVXycqdjMxSdm+eJNt8NFspTXlAHLxoeO?=
 =?us-ascii?Q?XZbiBsZXxcBdlGwpEZ9VobwdDNk18h8hIBaXp+LZQENPmWYk+kJUj3vjNqJd?=
 =?us-ascii?Q?IQs04iBz02kYu1rSmL+o913IOMQC3KqDprh2J16sHBTnaKkpAy+0igrOCOb/?=
 =?us-ascii?Q?LshBT2LxjdrEsriA+UZANiWLihhjkolbsR8usoVP/Zbb+VfyQ/zUoAItM2in?=
 =?us-ascii?Q?GD4FhX38Wv5vQIKpAHfj9qZj9kdeTV90dll+x2+5dGDK9xDCGdK1EOkdPQr4?=
 =?us-ascii?Q?QT1DQr+SU2GdPrnLK2m+E/1qjMZ3dDKx/DUBRDaXrMmpNcmOf9XpMRJcC8vI?=
 =?us-ascii?Q?bxRzWZqOpnIaV+qkhn1KsUMXijKOaonoQQiCBZvHK3y88ec1VMFDa2n6qya4?=
 =?us-ascii?Q?lLPTkKfqkEIf2gRwir7J8PGgifBiQ55ixqNia2st9Ci2BQh1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c1c1b9-e7fb-4348-3c5d-08deb515d790
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:44:15.0092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQqfyXqy9B1WWpUavjoxxoll76W/yvLilCipMhGeqT3Ua4RM7yR+ofMyFK40WcPv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951

If DS is supported then SCALE can go up to 39. Detect the IDR and compute
a scale max that is compatible for the entire invs list.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 +++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 +++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0841ab053f903e..8b727aef9ac277 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -991,6 +991,8 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 				      const struct arm_smmu_inv *inv)
 {
+	unsigned int scale_max;
+
 	if (arm_smmu_inv_is_ats(inv))
 		invs->has_ats = true;
 
@@ -998,6 +1000,9 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		return;
 
 	invs->has_range_inv = true;
+	scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+	if (!invs->range_inv_scale_max || scale_max < invs->range_inv_scale_max)
+		invs->range_inv_scale_max = scale_max;
 }
 
 /**
@@ -2448,7 +2453,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
  * the invalidation range.
  */
-static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     unsigned int scale_max)
 {
 	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2492,7 +2498,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 	 * on the address beyond it must be aligned to tg (so long as TTL=0)
 	 */
 	scale = fls64((num_tg - 1) / 32);
-	if (scale > 31) {
+	if (scale > scale_max) {
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
@@ -2743,7 +2749,8 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
 	/* Only precaculate RIL if it will be used. */
 	if (invs->has_range_inv) {
 		if (!tlbi->range.use_full_inv)
-			arm_smmu_tlbi_calc_range(tlbi);
+			arm_smmu_tlbi_calc_range(tlbi,
+						 invs->range_inv_scale_max);
 	} else {
 		tlbi->range.use_full_inv = true;
 	}
@@ -5172,6 +5179,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/* Maximum number of outstanding stalls */
 	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
 
+	if (reg & IDR5_DS)
+		smmu->features |= ARM_SMMU_FEAT_DS;
+
 	/* Page sizes */
 	if (reg & IDR5_GRAN64K)
 		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d6c548ade41f01..e56524e7bfb198 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -64,6 +64,7 @@ struct arm_vsmmu;
 
 #define ARM_SMMU_IDR5			0x14
 #define IDR5_STALL_MAX			GENMASK(31, 16)
+#define IDR5_DS				(1 << 7)
 #define IDR5_GRAN64K			(1 << 6)
 #define IDR5_GRAN16K			(1 << 5)
 #define IDR5_GRAN4K			(1 << 4)
@@ -415,7 +416,7 @@ struct arm_smmu_cmd {
 
 #define CMDQ_TLBI_0_NUM			GENMASK_ULL(16, 12)
 #define CMDQ_TLBI_RANGE_NUM_MAX		31
-#define CMDQ_TLBI_0_SCALE		GENMASK_ULL(24, 20)
+#define CMDQ_TLBI_0_SCALE		GENMASK_ULL(25, 20)
 #define CMDQ_TLBI_0_VMID		GENMASK_ULL(47, 32)
 #define CMDQ_TLBI_0_ASID		GENMASK_ULL(63, 48)
 #define CMDQ_TLBI_1_LEAF		(1UL << 0)
@@ -756,6 +757,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
  * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -786,6 +788,7 @@ struct arm_smmu_invs {
 	rwlock_t rwlock;
 	bool has_ats;
 	bool has_range_inv;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
@@ -953,6 +956,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_HD		(1 << 22)
 #define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 #define ARM_SMMU_FEAT_BBML2		(1 << 24)
+#define ARM_SMMU_FEAT_DS		(1 << 25)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
-- 
2.43.0

