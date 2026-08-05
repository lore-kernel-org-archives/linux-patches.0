Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6CA38C40E;
	Wed,  5 Aug 2026 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957378; cv=fail; b=WuQY+CVuuetpISCc+9DSShmvthVGgNQBUdTnZJcKPcogsQufVBJG2nYgE/cSaR4xFvHNmR2B+92l+M6DtmeA/CjSE7jGkKEzgOQ1Ax7qWZXBJfNuC/u80vTQ+rxPFwXSrA5gjbfqQL9DhHZrb32drHKSzzKYpiRcL6jFt0UDrfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957378; c=relaxed/simple;
	bh=R1ymNjnjxEjP2bU2wfVJgkr8KWIk1X6hx4KFqixVV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lzwy+6TQh9hhzuGiNoQOEWFvcK1B6qdY+zsMSZKoRQ9sMTCRSIU+yqX11dtpg0FNZuoj2bTCJcKohZSjJ2rHqs0Ek/n/22suSovlaWASbpwAvgeKYonm7v9k7qe6sFYs7N48F4UhpZIQYrVn/g/tZ9RnPY/rwzdveAWc0rEBxI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uke6k3Wg; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uke6k3Wg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vFrPuyRLhwWbfEB++MQyB4xjkM6XboNM6GX11iThFagAvCVBBmJoxvNb4qcZQpndL+1fFS8uu3vckkXaiBIb/09rgdyCani0U2dkzKskyFUMtJCbY+Gr/549jB1e/r0rJfJGSZbc+Elq556uALKjS5pp7iCx4nfxbkQ5CPa+5VBxD72DSBg4o2FUOEFzqsNeSexdXDapLHaa6rAcGkgW0B5v2pLMxb0re+4eqvkEOMkZR4Ks/S9sbOqx4abpR+wT1wpEN5iAL+RgTBbvxcD884wP/YszPxRNli5NYo0z3aX4EPYZDaSM7aF0R20NaSa99+CKlJS2uJEJvQI3ZUTPAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8W+0S94mPQBLLwvX8M2FCUUSZt78Rh3PyYlBoTxZDg=;
 b=tr+0PZW5Om3d8M2qA3hGUJHJCmArzFc5UESjnRjJQI1Z9WEk7V0skWgeGLijiFHKGCybxE9ea5S27+ivN3boSAGcuFCrSpAba1H6JgMpwT3gop46IHeYGFtMg9Oil0UuZWCpX7dgkEV6JFZH761jP48V+7reAdhhrxs80uQa4Z/U/loFEnn+PlJQmDmyR5HtbtFtFiLZIHHMiMuwnCzPHpzmxtpBlyY3ZM1+lWDdOtS2B4QdJCA5S/bZ0bTr6gdU8jL0GQvZVKNby83/w0HhEx08tmklLCn9qWGuHK5ASksyrcOFIshyl2doKsr4hkh010PoPhHAga/oWx7GDKsYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8W+0S94mPQBLLwvX8M2FCUUSZt78Rh3PyYlBoTxZDg=;
 b=uke6k3WgbdufYD6Zr9cLN2OBoFRZVpPZppURkLB7sdttZZWsNUniEPXLK1boqJnqYfSlgslVk/Th5IOIjMW/qqpAizYoQ3tU7GKGYyBX5gno2iIQxWOxrP37JAqW8Jecb945Y4JVMS7WRcvbVH46EOnywg+1ENXQub7v78DMhIa8Z+k/1Y28NJUUy0/yRYKB3r57A/XLyKVyEoceiJFR9dsS10Vw9Ha/KgtBXcsK4CTsQR+PvvNI5tpqnvFX6F2dPyh5K8g10WhmebXPJUFGiNuLXX6HqSP7/GaBEkscIPt3At0fV3FrYE6lNrHeapIK79V4O110UgcFfa4/dssnGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:31 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:31 +0000
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
Subject: [PATCH v4 8/8] iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE
Date: Wed,  5 Aug 2026 16:15:26 -0300
Message-ID: <8-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0210.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::13) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 28786a07-3113-49c0-e3da-08def325ea54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	K629BMGVWg9eEvB6TyuGGf8cuZtLZWANfEB9j0OWNMPq3ft+gPP8HqAq0r4do1H0tfwWGYk3qzifPj3fYowvsacxuMvuqQ3Md5K1Uy1xKW/uZnHsCWLCgGg2djkqZSIaLymu0pZJ5J1qfSd1GnroGKFzFISzMXLLp7dBpj9hPQKeg2sTaiGFdhKTDqJLjjCyyikMK0MKzhcoTQzVDclVGI5d/jf09S62SCQWZRztkq9vt0DNSrYL4dOlFJ9fDcsd1MwYmPHr4/R6CVU+uE9097HlNqUx5CDkez5GeKY8ZG1Ri+hD3WKhrHYgPBUlymLR/eLStEoI2GafIGAkW6QIBlhuRjJfWGM3Q3ohMKRNXQmFoYjwjZurTJ3WnmrC6Q1HKgwHtDvpro5/RVjk24TAqEFMPOBnEizGBEkxTcZAmh1lvxZ4376K8yQ5sDXJYZxufjTphCbU3e4s9yGcS8Jh3wFHvvFc5Bq1bwf9k2QmjBQEp/0ImcuHZ36TrN7jF5uUl/m/BWGRgJN2lN+MOCmS9Cx2qey2zRP5dYLr+zroqT4Ptj0ukD16WlPqwN4TdIgtQkuSws/6/8Zy3qnDVvWVGiz4AnPvPLRDUnPGurZo2G7xq12xl7IAQuu1GM3vBO4AUdAMoQlI7Ipf33bUzvhs02Wx3nROc8UQgEv1Oa2ciOA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gj3fzFZdg9vAwO03+VVjFZt43ao5wt9iDagEORlf15ZwteMvUUmDSb+nYAvJ?=
 =?us-ascii?Q?K9z6toopoylyhdKk+afvil+IjxSoPZXmeLOJfyzez+pSlqk3MkSYD74ynbrU?=
 =?us-ascii?Q?v/Dycrtxwm55IMQpitA6uZeCdWoDXBSiFgcR4kCXcx7zH6ZPlZ0p5775bVUX?=
 =?us-ascii?Q?6YnXCUvmKo/S9yE2aMemQmTFJHeaEY1tCM2Wj6qsdSsc33FLE63KUJWayY3h?=
 =?us-ascii?Q?h9ewMKRf9qx+PFCX4ap2xbzKbQeVrFaIiJJhTAbNowyX42RJmCj4TJw38lJE?=
 =?us-ascii?Q?Ni0g0MdlX/BQWu68SqdumkJ2cemH+ZgaYAwWpt2l8whdKS9GpSGAXvMvANmj?=
 =?us-ascii?Q?mdXE1CrUN5Z+OHGNqGQAomVYHZcQQY2V+hTfj6AYR1Uk34YLg5VQFFpmGuXF?=
 =?us-ascii?Q?rbJGSUOVGjILq+Lb9RSVLmo2Vzn9dgU0OPn9Y0a+Yp4jT0qDDYp0Lunddi8c?=
 =?us-ascii?Q?paH3VV1+qg9zqZzSVQTdkVcD+BOL8oneBsnPRPE+nZJnv02VxZxHudLQlWdv?=
 =?us-ascii?Q?/2JpDa8ajI+Ve7D5jufE4l3PsV3y9ZsxjZlpYlhAlWEZ4rEqFkxYYvtwbgKm?=
 =?us-ascii?Q?mPfiUq56Fpo5y4immecPJDRIyX9QXf3qFFdRfpmk4lfHmQwqNYc60dZZaT5Y?=
 =?us-ascii?Q?DWgcWIa+lnit8oIFJgYwml4ALY7IgiPbFE2rdwQtjnpkK6fUzancMvR/8+4T?=
 =?us-ascii?Q?53b0z1tY12JjtUlpa+x3CbfwNL/Z7RBALydgKJXd+/IPoUHEx7Jo02tdvM9F?=
 =?us-ascii?Q?obHljct2gQmbzBCOaxUBIcOq5lfrOCVcUF0fDj5axnSk0HF1ngjjiyNdsbwG?=
 =?us-ascii?Q?cXV05K2KhTkmcfZV4A4p23hqX91OhrADpqARn/3zZVsw/MYD+JPs/y+RBUhB?=
 =?us-ascii?Q?y5acNv0kHkkmSHb/ao4LvkYm7nNlTWY8CHsSVossTLosUqU/tL1DEeYYdP2r?=
 =?us-ascii?Q?7N6yfAjKRgBx+3PcMNZnF/suTL/zoOoDkpif/BMbChJasz246wvhVpZm6tbA?=
 =?us-ascii?Q?o+GhmnuUhXp20446f5EuzW3LUN5d+pLXqpBwg0i1LDX+tTspSsPoXgCU7lkH?=
 =?us-ascii?Q?fQ5eK7iibACtRruDNkklsZmLB1G6RxEVeOITpJFMtMNxv/BAEYfHCsihc3TW?=
 =?us-ascii?Q?1Q7xTN9yNdDYaNw0lCHE0QuJv4yBzt+q9FW5M0OQUBYAgOV/le9L6DZBzSLC?=
 =?us-ascii?Q?iyZHewO3QlBNSElDUnz6xwGSozu+t2lF+d0lhJcXsyqR5i7NWjq2wh6bgsda?=
 =?us-ascii?Q?a+aSv7CuVkr8WgNtYdIRXzdPYf5RYFIDHlAVpxUjULwIDhy2YbccQfDoHPse?=
 =?us-ascii?Q?wPmvLSRxsXQBiRP/RszGab21n2he37ttjYVdilqJb4bD4D16bBVT4K3LVP3T?=
 =?us-ascii?Q?6/RErY3NuhlLH0c7Zb6Zz1eG1s2VVMnYhoRPJlX9Co1b1/lycGlfUvfGxyRu?=
 =?us-ascii?Q?t2X/3HxXiu+7hUEb9pK9RV+7C/vd/H5R/RKPBATuKqHFmiawBJEZ/GiWSznm?=
 =?us-ascii?Q?NvCer6ZvLFYlDtNXkAiapvxfnjIS2Y5xYaPhzgir2bBkxnObvA67yc17z9bC?=
 =?us-ascii?Q?zKUnrVlM4KEpAOg3Q81kS9sRl28JvgqxlGbnsdtg6tZ3yBKy2lLLz4s/IQP7?=
 =?us-ascii?Q?ixanqFlzXorr98xQfnahlNWC3C1oMtF49FJjBHH22UbkHYwcO8jlC6bs1sEV?=
 =?us-ascii?Q?TkNLiFE2DphqlBB7K9ap6310jpomlhIyLoQivAOY+tZQXAm4Ogsil+zso8N4?=
 =?us-ascii?Q?A2r0Gg7YUw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28786a07-3113-49c0-e3da-08def325ea54
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:30.6208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3dbgi4YF+Qxe8L9eAFst8IocdxC9bkF+QQ6hvau53NjZHA9NKLcVIyRH0PSnHPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

If DS is supported then SCALE can go up to 39. Compute a scale max that is
compatible for the entire invs list.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5d3fed4d13a217..22ff4aa01d208a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1056,6 +1056,8 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 				      const struct arm_smmu_inv *inv)
 {
+	unsigned int scale_max;
+
 	if (arm_smmu_inv_is_ats(inv))
 		invs->has_ats = true;
 
@@ -1063,6 +1065,9 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		return;
 
 	invs->has_range_inv = true;
+	scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+	if (!invs->range_inv_scale_max || scale_max < invs->range_inv_scale_max)
+		invs->range_inv_scale_max = scale_max;
 }
 
 /**
@@ -2558,7 +2563,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
  * the invalidation range.
  */
-static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2607,7 +2613,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	scale = fls64((num_tg - 1) / 32);
-	if (scale > 31) {
+	if (scale > scale_max) {
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
@@ -2859,7 +2865,8 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	 */
 	if (invs->has_range_inv) {
 		if (!tlbi->range.use_full_inv)
-			arm_smmu_tlbi_calc_range(tlbi);
+			arm_smmu_tlbi_calc_range(tlbi,
+						 invs->range_inv_scale_max);
 	}
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e381fca5a2be6f..fc4fe43d7fe53b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -759,6 +759,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
  * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -789,6 +790,7 @@ struct arm_smmu_invs {
 	rwlock_t rwlock;
 	bool has_ats;
 	bool has_range_inv;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

