Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3CB433BAE;
	Mon,  6 Jul 2026 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355240; cv=fail; b=oqi6xGUbggSRLYgUKDGYEDDLH0HjgLd9N4MmSMbsEcjnT9oqfssA1+RNqTCFkL4EN708HyzgRal21nCLjQTQ7PrvqyyjACwaCrwMXxVNC/4GdapcCLjDVFGMzbCbSsYwct/WlNaF5iZKIbOOWKvE8hNPcSJwjG6IA/aZFESQx8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355240; c=relaxed/simple;
	bh=b4zgvRqF04Uf5rCj+GRvGlin9guFijRW9d5JzHWWHVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FWhhCsArokIAJbvOd0V1ci6tY6oUHqfwy30Ytaf6hTaT12bdV8zcsf4sjg0bS9ShBomLeOE1BNRrhPJgEC5mdPuZZFyYP1MD0OsgAdqRuRDvuywDqpsed156/r2ZIlxERHPDOsTQQTW99pSyPyyrov1AQ4FjPRDbEn0GYZ/fGEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W89bPvE/; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W89bPvE/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UMuk+eoX5dP+j5x2T/Sl4WTz8OXVOAc6T+cliJRQPY68EE3iA3HazVfqwI4Ek7aTRuu7tXZTggjp3/KJOnnFelR/Xa2c5vdLUZlEgRbV3Ta4j9aiQIwm3FxV0pK9xxo8Ks/ybRKFv91dGqw7EyWn28+Y70J0Mfs0YrH0Q0eylHeng1u/w5nNKH/3V3Y5oHPB7YWq2nUL/XoU+4GdLciXaJsYubELC7FR5OXh20mvIwVIOQjqALT5wzur8tKu++uHVPHKyRR1ukVPME8i6qb7zq9PGfgSiU8m9nqNZga1EBf3QVr7Naq8nz/hMNdEvWKgZ6Kuz68djbuFGqx85N4XHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rk+6qR56BMJmk2GwPdjbJaZ0U0KLuz/MkeFgRfTAyQY=;
 b=H9TLIFpL04uDHieZEJEbRkXYtyg7UqwH52cmZgsWYNeppTPA3lhoSGNmz8Lj6wy1JyzRGKdMbQh1K4RPgVOAYc7pvBM96OYrrvr0ekiJ2d0DxIKrhR/v1Cx8KRR+Zq7p32Yd/YqiX+xPKQwzg/TVA4Edyu5XZT/bzcBBdnFb+o9dh8kEjAxTxapf2PmkQBPN/3aQM4fpPSoXgCsE7PvlnfpaiqFrWyuoh29YHUok7ijtIX/R3FAHGHJCkXFOOKMKsVwn87w9e2BejuUVfFDXAGoVnbhvbDD8X52JaRmXlIAVVzC3Xpp/t8yw7CUcTns9Qg9T7WMzTb/EBDqXRmMxFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk+6qR56BMJmk2GwPdjbJaZ0U0KLuz/MkeFgRfTAyQY=;
 b=W89bPvE/5lPoRZoFgqBCg9wg0qDFVYweUyDQeyp+Fn7xKuyE+Z+HyoZEkJlKowpfwnqBG9tYyZjyOSehrTZCPWdliqg8nBJL2I8XI4UGf1diK0jod4m6q4FeLsAgF13v5lWbps+iV0DGSWu38cg8QcnBykJHYk4qBfZHnseSVCrdxsyEX+upGtp+cn+OtfaGnPZdetaSvMndgRE/EbHFDdywILcYlLqW2WdFnlEzt9cqJvc4pAu8Sa67b2qCMN786hqLfu4oPGR0X2TVwhBNLDuAv0iasE7ahzgr0A9fp9i0eARJhSJ8Z2W0ulGyh0XdAhRVXS0Q8LNpZ55s7QSL3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:53 +0000
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
Subject: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Mon,  6 Jul 2026 13:26:44 -0300
Message-ID: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 889c1f8a-3ee3-41af-0f83-08dedb7b6265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	jgzctZTiHF9ozIpxet6m37EPjg4a7u2xN65B8mA2xp+rVBLYK/6/w6PRfhY9l8ydbpc5cADe0h71xJsw9MpP5IqQ6YfD1Hw1fsCv8gHeiWI/TltyjCm/UaDZtVKVhBI2r5qy98fmT+OU98gsmpwTh71wEaCQQsjGzhr2JMgDPf/QyRWTEqsb0UTSRAzWvKnSxghAFQOkGTtGtvDpPcaI2wT1ua+BIxBs7N39IKT4L3No2DlGS/C/nkIpBwatgxKhrLBkGdTPhmZIuOoei+EV1Zuqj3yS0g6OJoXio4YrG4/IeOQjJ8rB+ViDOY99oppRlmYb7oCCxeafiOvmp68Vnt0TRKZn/Wo74lQrPbMpv6c0hBu2qZ4xMtGLuf9LqClmKeCiYkymXYjBxeJr0bLEKMFVcraORW3X0F+PMDNxFk97ZkSfHHG6t1bIPZRqu4XeLpDixbwCYHL6C55sdsBX4umGuxgU5nL4aOaVKicKoNVV/3LaetHv83DCM0T/ST3pmWG3WkaDr5O1jIflXfnJUcIFJ/dxHFCal2Ev2LOKVMAeD3pxAagaqJXUKEDI0vZ/T+kRxCA7T8VQisGvdIIIaVNqW/uPUS664Ebw6mj19QzPlbjMAQFq/+3mSLpx76R7UJrgajiA6KfQLeuCfKAn0mq3cTacGhlHmJRHjwMwlrE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GJwTdVBa5kb6e86qxesNo0Yx+hAwshK9f8wEtrM46sGFOS5nyxE2ZDHkxgJb?=
 =?us-ascii?Q?3LM8y/kYSWgA+3vjxOKiGgAehuUVDtq+iEEDmEg6P0YjYgNMEyX3zjUE00gU?=
 =?us-ascii?Q?1jLmfNGjX00T8d8H4y8F2WqAMBgfT6dWjqXVWNU1BkR3ARq+GTW6LdsCjOPM?=
 =?us-ascii?Q?nTBAKKq8YlCO9wbhzE31qo9A2HIGpqyfgb3SobruAOnLuiQHyd6ik9py8wvz?=
 =?us-ascii?Q?Hr0Z/njt8rtkElCHO+qbCTW0vD9tFx3ciie0I2iv/8bi0/2yQRdwdTDtIsig?=
 =?us-ascii?Q?BhRFIoo0D2b17aFCLEiQqod0Ey60Fv6o1t2AkFDz1hhTpOMzA1rArK8P45iA?=
 =?us-ascii?Q?bfmN/FoujmMHP7yNWCwQgG6X6+R5tAgqELmPsilpTrMju7kDC/DW5XedP9RQ?=
 =?us-ascii?Q?jl7RlTHYpGIdHnVttMNxfncDmKrEmmqhx9v9MKCUpyt5ZN9hDTmvAGELO3zO?=
 =?us-ascii?Q?W+p+UZtv+3sF9T/T/hDiU7YVb1bShU3vjEFLbULxfXPjB+jfyksiVrSH5l48?=
 =?us-ascii?Q?1+3hDUmvGHBnX8+KPe7gn8ysPwl8V8RzE08XSIvKRYh4n3UlbwYqkXVPweVy?=
 =?us-ascii?Q?dwgx/YO2ZsEviJF/Qau72QLQoXhRpjIf5t9QxlbMVZ5Kx6NgtFBi/chRN/+6?=
 =?us-ascii?Q?evj2P6RHescJfYPetem2TmTSVJljb5xWHuFCJqYncVjRUPkEI4RxNv/WL+JB?=
 =?us-ascii?Q?YyvGWGe9VAEb73vNlnjak60CQ93VVNnM1objA3ZUtf9KdeelApPbVLUioBSK?=
 =?us-ascii?Q?apDQxvz6hTzmBCLnHJxkIpM4fUmR7qZRXtwt3AfrxdTRv3dEKJzjyyQBPE8J?=
 =?us-ascii?Q?tiW3GNi1Ld9Yav1NCRgeif+/oIWaeNpw9169C7Wjh8tKRjuAKPfWLWoO3epS?=
 =?us-ascii?Q?BmSdGfU7MlBlhpvtcGQxaH8SG8WftOAknHp0LMmB1CJri2ryfSOBYcxbSp4Y?=
 =?us-ascii?Q?YeQl82SyzcGRwuOWJVKKMtsr0dkVjwgqlnKmM2zrYQMpXWv0w/1bS+yh9eG6?=
 =?us-ascii?Q?CtWkk7EYfBd//IVuEWfqq8A+Ym/jiVvDw+WZri0zz7zXfem0sQgXt49sYma+?=
 =?us-ascii?Q?hVDaJ7vpgiazZsZ0CK0+AYDCtgD7CbPDECjMuPBhoGT+a9MFtVGhUYBn4HpG?=
 =?us-ascii?Q?Eh+TolQDtsrd1tJuNGwGAwIz4jtXU3IoePRco4u5fFIvYjDkdvYiwhOr3BoS?=
 =?us-ascii?Q?wxW2OegFYRbgzv9CU8tASJ5rw35/BjmRRNeVz4POLU217IYuvw+O8Q/2AVmi?=
 =?us-ascii?Q?IqUpIc0+EF725eIz9Qd/gOnEGeXXubxQREflr36DlXyGuePl+JZCLmVgKi1M?=
 =?us-ascii?Q?cPqy6rhZHD4R6dRdvt+WSMdXxdvI7Xa1UiS1YkgsGgH62VMil4TNPYrHqe6Y?=
 =?us-ascii?Q?x2ncWRhKbxw87hYI6BJ0dxk4Se5CPGVbcVIfH0CFsLesS1LG+S6cWVYOPyoS?=
 =?us-ascii?Q?w2t47as2YiSjWbAMoEKV9oblY1vcELUBNbLOnB38LBZOcHI52eGsdkvWP8Rg?=
 =?us-ascii?Q?bfUkqxdUvGOqI3MI6dqW7Ee4K+BvAA3+R3AKUwdcY2VfNczczSm4755EemTW?=
 =?us-ascii?Q?0FLaloKrI/cPzw+gCjP+4cRVhMAUOfOSZPK3w6dgdAjMSsGUR63EW+obOpzK?=
 =?us-ascii?Q?NdGRiuT7Rg5TbYvN0FjtK8qVrxx+2GUHkmRzCjENKwAb3S93OGynF9oIwshl?=
 =?us-ascii?Q?8HU+h4gtrqzYUlIM76DSgkBS0SQCUMBnecPru2NI+Fx1KY61?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889c1f8a-3ee3-41af-0f83-08dedb7b6265
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:51.6491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvZtU7YfwWigRlBI04uF8jzgsVHlcRVjKHXHWN5SIT8LN5UTsZYMsHkIQqSCqb3E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

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
index e6001913e2b043..0e670c92469b2f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -139,17 +139,33 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
index 2e477f15080148..a15eaa99c24121 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2331,8 +2331,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2418,7 +2418,49 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
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
@@ -2428,20 +2470,13 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
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
@@ -2449,14 +2484,18 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
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
 
@@ -2480,10 +2519,6 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 		return;
 	}
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (tg_lg2 == 14 && ttl == 1)
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
 	if (ttl && !arm_smmu_ttl_addr_aligned(cur_tg << tg_lg2, tg_lg2, ttl))
 		ttl = 0;
@@ -2492,27 +2527,52 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
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
@@ -2532,7 +2592,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2552,9 +2612,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2733,15 +2794,21 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
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
@@ -4008,15 +4075,23 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
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
index 5f97d1a63ebbfd..b57205a83128e9 100644
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

