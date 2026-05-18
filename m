Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7C93890F0;
	Mon, 18 May 2026 19:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133437; cv=fail; b=JJSwPxTGH1bs2qai1A0OAP+2hIXGT3crI6DeE0oY+5+nXg9ELk6C0jZRY2sV3w7H7NiLu5xbF6ZhRg6qyL0DA6IJdyfKp+PqAI5oAGJRZh0M/e7Mkey/6xYggy51RHI6O6q7p3QcGLXoE/qW2sc5aRGK7IHiM8HtnVBeUuL63I0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133437; c=relaxed/simple;
	bh=/sPCLP1kJTBfe2nEaiVHUjeH51EL+/H6RF7oyUjr+jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HUbIp5Wdvk+ExjmyO1LnEWJnu2Ah9tnJH5828GQqZGaXvbzbxZB7aZ3KNrlrSgzHaAI4NVH8VNOPU8oW8Ro3s+MPbT0boLqdELWJyy7SPcl+ALcnm9TNmmwwYUwYnhKDsnrxkECE+ApNhh5lB4sScrV0Ca5+oYcvj2bxpNbkFes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TV1GTgrx; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TV1GTgrx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1bRRfZc70PgojrtxhM/rxdXsvV0QPuLUsrlzjcKQWJ3i1nBbHd0/yPNisJqR2zpc4HWxNicPByqPy43qBat1+YqQ3tIf+m4ubftbUABra0oK/24SKSxSJCQP6rrTnHEvbR/iBgbu+ug8RWM8yWRuBxeg7HLP0don0RPNn8iV62Fy99VEdoEMAlreb0Nc5eNXufh/irahhJgsTOHbje4nDFgDdhNYHIXE8PUOJHIHmgOdgSPjBoi38GWH3MHEZfEM4b7On9xrAcErakVnEXjqP9Cr1ACfUrgjaPzDknFqDczzty5RLz8K24ibDRMYEJIDsx8fSzlewfj62S84PObgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PiQ/IwmkWhEoubO72ul5YDUWDEAGu2Q/2hE0wJLZj7k=;
 b=IeMBDTQuEdCxN8Vl2ERpwkQOnHOUivIr87j06Pum5Nw+ALMcI7NYz4RIsmsinyGrHV94rtjPbutEgth+gLe4yk5eIv1qzd8JLh95/qwYYM5u3vGQLAlwW83Mi1mZL4mV55MjMpyYmrCudydC1oJd91y8XVDlz0SdjOWfXSaBMe7PGjk1OVpO3tzOE2cP2997IHwZkJMS3EZFxTM5ha+5FGHrYK8MyIbOyvoh1IwUngZrZzHq4ix+2Lv+gwTPCC4y9vG5PLbv0TooJEyexTuQBZoOZlRr7vTHFdHmJ2Vhx2KYUJ/UCsi8+k27dp94BQijsDpe0XAgRaEIb3pBMcr9dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiQ/IwmkWhEoubO72ul5YDUWDEAGu2Q/2hE0wJLZj7k=;
 b=TV1GTgrxDmj/8nPeKR5DEjQNZc6CkEUI69ojsovYDu+6vIi0ryaCcU6qG9IY1MqckJbVXeOpVKVKXatc1kOZ62Osqyyg6m1AUiNUfhLMZuSK5pMeM+G32ifcDY48/PL3W8c690TgnnfAXyt6D45ch9FLsANFENu92+/PrRVYjDx8/7PRmeKwmw8Ddt7/8PuI+/G43tLQR9aCPdmwISPSlarGeIHZFpHaWDrU0ZYAmW5K02REPlc05Ni6IfGLmMCHXVb6P1qkJejcTtNX+J91vCpksogEpkeP7+sU7ND/vt7Q31CygRRhJpdUHst/OrmaANa4tlD3nm9Q5pxYNDEV5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:49 +0000
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
Subject: [PATCH 7/8] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Mon, 18 May 2026 16:43:44 -0300
Message-ID: <7-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:36e::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: 24887e49-d208-4c6a-a149-08deb515c6cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|3023799003|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ibSKcVHboveDp1fqGPgH0iOo1/wvAQyKOjQxDrIRGGH4DRpTSlcQegoFuqkU7f8OHknKhtpWt1C3q2P3zs2cL6rnB0RL2NVUR00ZreHte/mWbSefYX+RWbdrJciSWMEsZokboWhh40ZEa1Mrav/f5yAzYku8YPXs/nWUNoPlI9GoXPtdMz2KdDnMVfUUADtqjJtc2zQp97Uz+lyjqMaD1hibsves/HE2+rK+GmpTDEVR5ii0Zy0N25R6UcUROUWTIKFVcVIaH5/ynPjeEjtaZHg1h6WzU9MXKtGRInpOdoD31gN31IhxQRQ6NhrSmQGiHF13wbxHCRBobRT2un3YhLdlHZPsGRvDGPVq3QEn3cb7DUU19mWzAE4kpGsPzNMwDebcES671Z3Ty7U7r+EkNxIGPeS6VDN9F0T9xQI1P1ofmN6F6P2hynpmGrwDhKN54aFbQlU0d9Filu/d1IX2hFYFoAEeQ6WdX3wQ5Qan4lETVv7qMkKpNux76avfn9qkcdfxL4vEmX15DhWC0yPHvt4/CbNODVZ6LDL1qum8IGO8JtnRP8BlM0H3lvZXgVTH6rXdm5XIg/tvRgQerJadEevnrbo3ye1D30KIXZJj5BUz+LTzQLOJTYtGEKHKqqBBnaE0n08iZUV8zjsfV4cRj80M2VaPOn3hVjlHYvGOamTfwtkvtV72fnhMw093r++A
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(3023799003)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PIMb3IEo2NW07/0ziRfxNlZOHMiP6IBwVi4ePIHg7JiiNjo2uAwpn/QqW5IB?=
 =?us-ascii?Q?koeS7mou38Z9euAffiPwHb2/y+LUbSY0CIOKmByfh6XGwcg2pr9C2S8saFGO?=
 =?us-ascii?Q?iEPuHv5QzIfwIX/CNEX3VuJWHwAT8kYSiWEAxyrIgZDAdw9vlrEB4h8lk3Uw?=
 =?us-ascii?Q?PHydL1YwF2bFP1nOZ7nsoZP8+P2TRyPgKFs8w9jF1ngdbnCIHc0QYT1spUpd?=
 =?us-ascii?Q?xCDKWHsEThmadZheX8M4JA8ChJgZA93T5ab6aWfgMGjhJFAAVu77HHapRa+/?=
 =?us-ascii?Q?WAmFk4ZNBovnUIpQe1k0jX3YWzElkiuhatjKZZrRcLC7Kc6BRzVfVxFPcNoR?=
 =?us-ascii?Q?KDIyE7GVbMs/SuEF7Y1+ES9ERELyhmXXRbYC4N8X0lnxx9SjaYP5nmyuckuN?=
 =?us-ascii?Q?iPXErw/QyKDYjg2WOONxVVDetWZJ0X/5oDjygLDpOrCOZOvKQ/poDHfaaz8q?=
 =?us-ascii?Q?1SIfsz4A36kz7Rw0FevatojNm21veOeg349Tq8HWuXkBlThID5oJ6t3U+K/j?=
 =?us-ascii?Q?3u02jkEIhSZUacdtf38jSnvIAoxs/2wOEG0PAv/F8VjFv3k9mts+9frLMTtr?=
 =?us-ascii?Q?S3FAz+AQcUjgF9jA8pCLdRGFNalaSP/YsgJimB5l/Z8pW4C+D9L4SUosXUPK?=
 =?us-ascii?Q?n2gxo76v/65MSxJbyaqwX9hO/hFEhFAzReWjIxndwCt2y2av8O7AbEaf0v11?=
 =?us-ascii?Q?lV1oQelSQX9Ys9PV+/5sNca9/vL0aCTZ0jwCjQkT6SebmmBF1Cz2JgdCAQrn?=
 =?us-ascii?Q?BobzIiUDqCXSKdvEtxMjUu2yPlQibuflyMENyxv1A+DotBUPM3apND/TQiTQ?=
 =?us-ascii?Q?4ul+vUGdmc0PDlMlQImUptUDE8HgyP2iVyXipwGAqllAKV9i3w3FwIyWTh9i?=
 =?us-ascii?Q?fT3DJZ5mFUYsj0mLHdh+Gv8bmafAwwHLtlLWdz7BKrIh6O4iHX6KgSHzgQqZ?=
 =?us-ascii?Q?el5WtDZATdv/nqrjNYyqd3et1v9InL+IFIK1xNg+21DSeBuE2q+sehPx7PsV?=
 =?us-ascii?Q?j+O8oWgbTxs8rsC2OSRuuiHwILTAf5/qiT0U0nanQNPQWDfLrkn/+MF2tUK1?=
 =?us-ascii?Q?XDHpmcfsO6LAbZwqgtfgK8dmJJpXUQRnrz1/8PvrPsDSn00MlQMTY+1+v8/6?=
 =?us-ascii?Q?GoaCiUXNh5OLL5dqqNQ5A4vEcXrd2WUOrA1uJRJQuJcDSF1wSK9i4+Nqh/tZ?=
 =?us-ascii?Q?ekceABWS968VGzF6d61+v6c1d24dG6OyK9jf4UBkePkZxvAsUl8455aQ4o0f?=
 =?us-ascii?Q?jKjo9A30j/h9z+zHFqEPgGy9f61VUWOjmBx8gcYc0szWxJfj39V0I7FpMulg?=
 =?us-ascii?Q?SfKctG4Fx0BOjcFZLJInBd1Zh32xWZi9Zptmg5kl3Lw4hwqBwa5xb8gB1+yi?=
 =?us-ascii?Q?m33YidvbGLGc7Yn5vO8Nj9uJvw/zeaYlvcFtICaftpdTsGlarjgYusmbsFeD?=
 =?us-ascii?Q?vcDkskhTlBlNCovUcc1IpelLmLUj9Fxx073BvfVh2virSxZj66WHBw1GDn2C?=
 =?us-ascii?Q?t7VviLb51Pe2IyfMxyK7eUUkx3Hs7s6Y2hTzfPQJtBP7R5FBxfEfSz6jn1NM?=
 =?us-ascii?Q?zYPgXkNUx8pYvwOFjgch8w/NJNLHO2qdappOExhDrRbED9ok8PK59qaLG0V3?=
 =?us-ascii?Q?n1zMh/zGRxTe99kmy+kRVK9uhptLKXV00J0XAp9fTTynJmpTecww2LDxF1i2?=
 =?us-ascii?Q?wqohuIbuFFSbfDBdXzQVIU20oiQrW+arV+csa/S/GIxevHGO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24887e49-d208-4c6a-a149-08deb515c6cf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:46.9752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19nc17Km2Gl7t9YAwYBdcj949n49Ayry7t5eXIMBDY0TmDQeqylXN4w8o03loysG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

The RIL logic has long had a FIXME that there is not enough
information to properly compute the RIL. There is also subtly not
enough information to properly compute the single stride either.

Change tlbi to use the information format that iommupt is going to
use for ARM. This prepares the invalidation code to support iommupt
and fixes two small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single
gather, then the iommu driver should issue a small number of commands
to execute the gather to control invalidation latency. This is in
contrast to io-pgtable-arm.c which generates many gather flushes and
direct walk cache flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps,
one for leaf changes and one for table changes. This is enough
information for SMMUv3 to compute the proper stride for single
invalidation and to generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt
conversion will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation always gets a single table level so it can set a
   single table bit.

   This corrects a weakness in the existing design where single
   invalidation would walk the entire table level issuing 4k
   invalidations, now it will just push a single invalidation.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the RIL invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  28 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 163 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  20 ++-
 3 files changed, 157 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index c708fefb053771..d7f88866469846 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -129,17 +129,33 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	unsigned int tg_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.smmu_domain = smmu_domain,
-		.iova = start,
+		.start = start,
+		.last = end - 1,
 		/*
-		 * The mm_types defines vm_end as the first byte after the end
-		 * address, different from IOMMU subsystem using the last
-		 * address of an address range.
+		 * No information comes from the mm, assume the worst case that
+		 * it changed every table level. The way this is hooked into the
+		 * mm is tricky, the range won't be expanded to include an
+		 * entire table level if one was removed like the iommu gather
+		 * does. Thus even if this is a 4k invalidation it may be
+		 * including any table level too.
 		 */
-		.size = end - start,
-		.iopte_granule = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	unsigned int pmd_lg2sz = (tg_lg2 - 3) * 1 + tg_lg2;
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows RIL to use TTL=3 in
+	 * cases of PTE only changes.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 94f742de90330c..0841ab053f903e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2312,8 +2312,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2399,7 +2399,49 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 }
 
 /*
- * Generate a single range TLBI command covering [iova, iova+size). Sets
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttlt means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					 unsigned int tg)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		if (is_power_of_2(leaf_bitmap))
+			ttl = 3 - (int)__ffs(leaf_bitmap);
+		else
+			ttl = 0;
+
+		if (table_bitmap) {
+			int table_ttl = 3 - (int)__ffs(table_bitmap) + 1;
+
+			/*
+			 * A RIL invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				ttl = 0;
+		}
+	} else if (table_bitmap) {
+		ttl = 3 - (int)__ffs(table_bitmap) + 1;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		return 0;
+	}
+
+	/* 16K granule, ARM TTL=1 is reserved (SMMUv3 F.b Section 4.4.1) */
+	if (tg == 14 && ttl == 1)
+		return 0;
+
+	/* ARM levels -1 and 0 cannot be hinted */
+	if (ttl <= 0 || ttl > 3)
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate a single range TLBI command covering [start, last]. Sets
  * use_full_inv if the range is too large for a single command.
  *
  * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
@@ -2409,20 +2451,13 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 {
 	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
-	u64 cur_tg = tlbi->iova >> tg_lg2;
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tg_lg2;
+	unsigned int ttl = arm_smmu_compute_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tg_lg2);
+	u64 cur_tg = tlbi->start >> tg_lg2;
+	u64 last_tg = tlbi->last >> tg_lg2;
 	u64 num_tg = last_tg - cur_tg + 1;
 	u8 tg_enc = (tg_lg2 - 10) / 2;
 	unsigned int scale;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both
-	 * io-pgtable and SVA pass a nominal last-level granule because they
-	 * don't know what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg_lg2 - 3));
 
 	/*
 	 * SMMUv3 F.b Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
@@ -2430,14 +2465,18 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 	 * a TTL hint to target only the exact leaf entry.
 	 */
 	if (num_tg == 1) {
-		if (!ttl)
+		/*
+		 * The two io-pgtable ops filling the tlbi won't generate ttl=0.
+		 * sva sets constants for single page that give ttl=3
+		 */
+		if (WARN_ON(!ttl))
 			ttl = 3;
 		tlbi->range.data0 = 0;
-		tlbi->range.data1 =
-			FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			(cur_tg << tg_lg2);
+		tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					       !tlbi->table_levels_bitmap) |
+				    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+				    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+				    (cur_tg << tg_lg2);
 		return;
 	}
 
@@ -2461,10 +2500,6 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 		return;
 	}
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (tg_lg2 == 14 && ttl == 1)
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
 	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
 		ttl = 0;
@@ -2473,27 +2508,52 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 		FIELD_PREP(CMDQ_TLBI_0_NUM,
 			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
 		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			    FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			    FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			    (cur_tg << tg_lg2);
+	tlbi->range.data1 =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
+		FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+		(cur_tg << tg_lg2);
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for non-RIL single-page invalidation. Returns the log2
+ * stride of the lowest affected level. Single invalidation removes all IOPTEs
+ * that contain the IOVA invalidated, and we can reliably assume that the
+ * architected page size and table sizes (not contiguous!) are reflected in the
+ * IOTLB. Thus if there is a 2M leaf entry we only need to issue a single IOTLB
+ * invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	unsigned int tg_lg2 = tlbi->smmu_domain->tgsz_lg2;
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+
+	if (!combined)
+		return U8_MAX;
+	return (tg_lg2 - 3) * __ffs(combined) + tg_lg2;
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
+	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
+	unsigned long num_ops;
 
+	if (stride_lg2 == U8_MAX) {
+		tlbi->single.use_full_inv = true;
+		return;
+	}
+	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
 	if (!num_ops || num_ops > 512) {
 		tlbi->single.use_full_inv = true;
 		return;
 	}
 	tlbi->single.num = num_ops;
+	tlbi->single.stride_lg2 = stride_lg2;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2513,7 +2573,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2533,9 +2593,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_granule;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2714,15 +2775,21 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each single table level it wants to remove.
+ * size is the size of the table level and granule is the tg in bytes.
+ */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	unsigned int tg_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.smmu_domain = smmu_domain,
-		.iova = iova,
-		.size = size,
-		.iopte_granule = granule,
+		.start = iova,
+		.last = iova + size - 1,
+		.table_levels_bitmap =
+			BIT((ilog2(size) - tg_lg2) / (tg_lg2 - 3)),
 	};
 
 	arm_smmu_domain_tlbi(&tlbi);
@@ -3984,15 +4051,23 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each run of same pgsize leaf only
+ * invalidation. If it has to change to a different leaf level then it flushes
+ * the gather and starts a fresh one. Thus this always targets only a single
+ * leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
-		.smmu_domain = to_smmu_domain(domain),
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_granule = gather->pgsize,
-		.leaf_only = true,
+		.smmu_domain = smmu_domain,
+		.start = gather->start,
+		.last = gather->end,
+		.leaf_levels_bitmap =
+			BIT((ilog2(gather->pgsize) - tg) / (tg - 3)),
 	};
 
 	if (!gather->pgsize)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 95da62d64df171..d6c548ade41f01 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -805,14 +805,26 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 
 struct arm_smmu_tlbi {
 	struct arm_smmu_domain *smmu_domain;
-	unsigned long iova;
-	size_t size;
-	unsigned int iopte_granule;
-	bool leaf_only;
+	unsigned long start;
+	unsigned long last;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * If leaf_levels_bitmap is 0 then this is a walk cache only
+	 * invalidation. If table_levels_bitmap is 0 then this is a leaf only
+	 * invalidation.
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
-- 
2.43.0

