Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363EA40A951;
	Mon,  6 Jul 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355222; cv=fail; b=bmMdYoHWyid2i8I+dnk3aTew4DiTiz9r303ZOC9r5FsSbO8sZQoVa1gM3G9K0FsSt4Hh8byXIUYXXko/Gc0pAQqMzHYJ/9exvOwZS0fTGplMBqx0UdoYxVTBd0GeBk4PvJbr6S6hELIlna8bYXM5ItqoXj2JmuabBltOeyro8oA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355222; c=relaxed/simple;
	bh=n/7UzYmnST9DUW7QAKqA4xP6ukYuu5NdubLD2ILhkWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=If6J3X3wxa6plsjfM87DyEi57I1m2BKqFNpNj9lmQXTNefwLRKSzjba/DgsvzZTq0vwdLTNri46aDtC1M7WGpUJxKfEFsBXTAx/yIb0GNDx448xkYfJWlStv0jBQFHewNr+6WgJSANINFxmigTPEW3LdY94CEWguhAHMznTq7G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aVBZwrMN; arc=fail smtp.client-ip=52.101.53.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aVBZwrMN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwHdsSdwKRYkmCy6ejhRNcKgtGfKf3tqd0t8i/yPRiH/6gxKdFq2rFPqFTkO5ZQ/pdwQsdjyKZpib92jgXugKJvttJkwo8ohtvT+45W05qCtFJ9QpD6MthRPlLxO+HMKRbQFFg3c57bLCeSAvQVy+oIY+cgeCifV7o+I/AstrKsrJdnl+uNgPvFFoe1dJo1BpMe6UsvAxJlptU980mVcyKECucL2Rvl4+dhbu+aHNBKrEMTjfl/UKjPWpAds5m36w2/6JLdnpXsk3v70bnAHZmMU3U0IUWGm+ETxRVBaIk0XJEqQZCdGcQCGXfaA30asB0KX2Yyw0bUmcokyKlxp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpPFinRhYUjTOk+a4fHw7OHmS+erD42oXx2NkgPG5C0=;
 b=TE0NPeK0bnY6ZubMs+ZsChIdCzI9FOUE6d00ecLrDKsahmPnpa6AjFMsBi1cufP1GXmllsTRY2PvvGaKFlvLwQOhfuE/bvw8XoI2byLDzh5WQHZEegzPdk9hioPjEpf6usKEG0t3x3uO7df/noMpGP7EGm6I53HFUbKpAC4VitilE4Xhx80arV1Ryy4tcuIiU7ybmJJDCcWYgBGudv/sCAfIfLaVInmlt/L1KdBKPSilduqsWGN3rLMPr2MwcYXXpPEkgYOZ8LCoIZw+MJJUvQusnjKb7sFCVzG8r/U1+BP9OqmiugMbD5/jAAfcEa4/woRYPU1zgvuFi5rgfWF/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpPFinRhYUjTOk+a4fHw7OHmS+erD42oXx2NkgPG5C0=;
 b=aVBZwrMNn43hk83zYQfNIyQy51zwLNC5sOrEHj/Ay3c5yi+EtgfpM8Z67gMgNulAMNhhhjLNVK4IvmJdYmoARkLjJG0w4bH5T4cbSyPjDPeV4wE2+fGrXZsNPCRj7gAfdl1SaROcybo9bfrwtTUmDTb3XQs4R/U7fQRMYyPGVpSWKh0CZqp/SFHoSt4wqyB9j+b90vsQlg7tlcBM5dV1RyvLpkuNMIhBjFN80ei6nGQ8I/OgnOAsrAPAn5M+P7jkBJNtyZPj+rtzQYFZ7+UpzJsF7Xm5F+IkNjoNaxCdn9Ukd9BPhmEQlW/aNw/3n/tMMbWLbX9brUV4seToVnwf+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8535.namprd12.prod.outlook.com (2603:10b6:610:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:49 +0000
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
Subject: [PATCH v2 8/8] iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE
Date: Mon,  6 Jul 2026 13:26:45 -0300
Message-ID: <8-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:408:f5::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8535:EE_
X-MS-Office365-Filtering-Correlation-Id: 4106fed2-530b-424c-98a5-08dedb7b60df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	JcUXFnkCPG4HLiplcpE1lKbJYZW/ZrM+w6m11NULbb07IN/GZBIxq0di2rNCU3lYRHVRURLlMF1RsnHsFzYc2tq5K5V+rBQ08Z5LJp1Jw2oyzJN/xr+OyDDhqLxXcpCK+5jD50D4ZN/WLlTmVcLONXFtoQcQKgnA0of9UK+uJHE49s7wIOTjD8UYzV9zrCdVdY1WTBlEgLY61u869Uon2J7ViKImrliYmRYoUxBs9B1oCeg9cL+cndWy6hSMNL0V7qebasTM+JorDAIxJo76hJE6Qo/BJKa+6aGzzAE6/ApZjuo0Dg9YYGcG7seDMRxeqU7Dr36WeLv7VIzVSLD30YpBOjWdVagYuYdfl7Di1OFBdmbzW2959++DC7ZYpJV2ZK1yLnOaBIwnIr0XfpeYGsSIZo/lajUsgzUKTyaZnqLV9H+2Jfef+AHVnwrJ9R1h5zK+WOO5PrcV3/GeuJeDo+cvGoCtbrYHc8xL+at+1m8EP5gKezFAQW2BLu7l4Qix0o/geMsovLH4IgcPz06YYzmL2HYBian9SrQygCpnpmZ0GZyPiRVQ5a1c+Bp9RygsAJTgIQNca1BOGx6JQ/RpVuCeTVM7uvT0f6t55AmDU5yP/whiKllAcCSyqEyf1jP9urAexDExg6qzk2lxdJFGwk8rGyu5zh3JLgMJtz+oTCs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qIypYWPaw+vaH6pOWavbGqhVvIUFaUyjeAzboI3Xhd6thFR1cc9+HmU962GM?=
 =?us-ascii?Q?Rk0hRuvwjyinIWTLxTWK8M+DAeJIDbNGodbzTuuJtrFA39Ags8JrKxNoDqBr?=
 =?us-ascii?Q?Ilhm/coq7iPTFm4f41Sh2/KTAWGEI8hTNBuXRucUzEq/JOANVYrI65fflu1D?=
 =?us-ascii?Q?Nk+XTNmWWiTgZJUYvNobtTMU+kM4fDrF3O23hOMRpMUvp6bok2p/aBiPY20r?=
 =?us-ascii?Q?i6pYK4CBojNketDB1VAs3rQtmIMpShhtq84WJ7y4gin825iqQrAV6wItmVRF?=
 =?us-ascii?Q?YZjfVzO7waEsXU+GMo13FA9w+RtEB9rC7KrULqHpsKibIqUQVt7D9lPH3PWG?=
 =?us-ascii?Q?hOG8Se7DxTFPiKLbk1NPWdveDpPj+gtIGdMRXj0+Sh9OcLm8cy3e0NXxLrya?=
 =?us-ascii?Q?+kgRr87g5iFRDQvnqkZyRhNyVcttmlRDuQx0HvUvkzaK/Ut0bQg1MpNQ0mdx?=
 =?us-ascii?Q?tnBpEGoYyRTXtSF8HdygYUjhRc1F+XUoeFAcvBDFI9fOEjhgx4PYYiBYD/Nm?=
 =?us-ascii?Q?BNW4SHu3G66okNTR1lNuc12UXnPkp7OAnHhDd79r6TMeY0c+QAEty1SrMJrP?=
 =?us-ascii?Q?CB48ntkScqQfg0GZFN1lKDlfyzVNwvczoMkvwhV4sl7Rjqd2MU8ud2cg9sPv?=
 =?us-ascii?Q?wojZflI7KnQJxfX6U2+HBhXc/qUCrb6h+gb6D7FP/eW1aVOTSs9jzKfkPGAG?=
 =?us-ascii?Q?8SNX+b3ITCIR7sB2+Wz74PRgM8jDiUS50VlON6tWTZYwRrnryum1/EcIfO5T?=
 =?us-ascii?Q?hpDmaWA8wrunILkBKzHrxDJFmV0KeVMUdMef9dgN+DFr9ex6c9HMjie/23bX?=
 =?us-ascii?Q?RvfSzGbeS0DFQVokAtxB9qAYmv8tGvS2r0QB4II3NX6wPjc/MMCAR71OGadJ?=
 =?us-ascii?Q?8reLuSOFFVpymA73X2Is3BKWhOCDP/qPrHANDgFsqjwzjkbT1QXKHASgZn8s?=
 =?us-ascii?Q?U7JpdLCrnANj57+4VzC8BEA/0Cv32igDDb+8ZlfTNSw4xA6sdyk0kxL1AcgK?=
 =?us-ascii?Q?QVQYGAdJAsIwq1P072erLN7EQwegk9nyhC1CZb9pebuZ+vueN2CP8JuEKItG?=
 =?us-ascii?Q?0LpfFwDcGezdCPO49TRGmIi76iRgh49EL4ZtAhgbOUCKAnXfnQ95eeM1KRu8?=
 =?us-ascii?Q?9rYjDYBQllb2bWmc2r+zDY1Z+lon4StiFNpRnnYgu9urS73TLefRJKnOOL+4?=
 =?us-ascii?Q?zRGuD0xW9mEc9P2sgvFiizwVNXzV/Ddymh2r1NS0EZR50IL/Hxz+eNHk0Wrr?=
 =?us-ascii?Q?7wzJrymZMna91onHdWjVAPQXTtsqag0mhdp+bDakKjTXFF39/t1y5Oz7sCrq?=
 =?us-ascii?Q?UoPgUDxN+i9HZO+SXdYXhh7N25oal1XsHOQVFfbR93CAaGAU933cO62GRkjF?=
 =?us-ascii?Q?PyXn+TpYZg/zuSGSINYoWtmNhYOIJcedV3YFcMw/wCRTHpHtEJKDObfNNeaQ?=
 =?us-ascii?Q?98TY+puZMkn15WBK6bxV1SQW+WLdpNXPIOPPoGelJirmvLmIaVkfZK78hcqq?=
 =?us-ascii?Q?UtIIeev7atRazbt/TFycdYaXFpGifkwEvOo44Tfxjtd4r4UTTuJm3G9Z7d9x?=
 =?us-ascii?Q?Z6Y+FNQeGWcGzhxzBT1Nm/lQ3v0wGjxZ3+7reStWt4LKMONlDE1ogrcHSEHZ?=
 =?us-ascii?Q?KmC03thcKZI7UVWyS4EQEmdlsZg06oELRn5+4i/pRf8++P/xzg8ME4uHRFDe?=
 =?us-ascii?Q?v7TitmSZ9rky786aQb8lxQLz6dsP2dA3PH4ZvcD/C0OXWCER?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4106fed2-530b-424c-98a5-08dedb7b60df
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:48.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8H9QEG8eBfc6EHuoXVWW1WW7w27NtNGQZfNRb0UiZHSMAPw9iXNszaNagUcRhBN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8535

If DS is supported then SCALE can go up to 39. Detect the IDR and compute
a scale max that is compatible for the entire invs list.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 +++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 +++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a15eaa99c24121..5087603ea18e62 100644
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
@@ -2467,7 +2472,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
  * the invalidation range.
  */
-static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     unsigned int scale_max)
 {
 	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2511,7 +2517,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 	 * on the address beyond it must be aligned to tg (so long as TTL=0)
 	 */
 	scale = fls64((num_tg - 1) / 32);
-	if (scale > 31) {
+	if (scale > scale_max) {
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
@@ -2762,7 +2768,8 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
 	/* Only precaculate RIL if it will be used. */
 	if (invs->has_range_inv) {
 		if (!tlbi->range.use_full_inv)
-			arm_smmu_tlbi_calc_range(tlbi);
+			arm_smmu_tlbi_calc_range(tlbi,
+						 invs->range_inv_scale_max);
 	} else {
 		tlbi->range.use_full_inv = true;
 	}
@@ -5235,6 +5242,9 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/* Maximum number of outstanding stalls */
 	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
 
+	if (reg & IDR5_DS)
+		smmu->features |= ARM_SMMU_FEAT_DS;
+
 	/* Page sizes */
 	if (reg & IDR5_GRAN64K)
 		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b57205a83128e9..95186cf84e9abb 100644
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

