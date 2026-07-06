Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7B0433BA6;
	Mon,  6 Jul 2026 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355226; cv=fail; b=LvFRVWLbCGpbhXqZhf4DhabmCPlNPHbSRyiFnukP5OrnkfmZcsgACDB0cjkZXRiB75AIBWWolXoJq5tzpb4m3E/InEhfbhTMx12J4a+5Vgpea4wlTaEDYzZOA+XnkeASS6KdPtOPBkWJ8lfNGs3Ud+HqXktzioyghZ8ChOGj5gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355226; c=relaxed/simple;
	bh=p9v9/CkwMiJ7D9tXOBR1EZvXRDZWN6CmBv7+MZix3Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dMs1SMWpuXvzORfjdIhfhhQ3r8L3Z/ftZgZs2GkN71UhXmQ2nYnlC1yr5uPulV9q6Rgjiw0HeTfmSZ/CJ1vNaZ9zRz0MI68Bo3Guoyl1edZLSlK3meInDvIYT7wa90PxIxdKAmcF/D8qOYrVogANrbtFIZM3+yWL8VjHlh8pcik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XSbgCXi9; arc=fail smtp.client-ip=52.101.53.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XSbgCXi9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZftOmlnWf25eRYTESRjZmF5+FG9Pk8glw3UBKD2fQJ6EzchurQLlleGI1EeLQX252KrsPjxaxpmmKPT4MMRcqiA9w5NmBLainZGOZ2UN+0n+ygtpU7ce/EeeYaKekBymOf4i7rO+3YiOfP3GyYeAHAQlAItbQqcy6XvOcHi6PN1G8ypO4ylNIPU0h2qG7m2c5PEfuFJE7eTkE5COeBwXlrYMxHlyHKhTNllGatRDpoQUA2s+OLSiJVWAOZbrJ9qsU1C0lzg63jjHVbZBE3YcP2tvVlzbVm9HsniAm/g8XOQ1R2rVA9VIuj07fWG/RK/CDNVfYtiAcKnLwYcKQkQk8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTiSxHJ9BRqG9JKFkJvfjVwcKvBSZ79BiShDORb1z0o=;
 b=NWnzeA21pV/P2YTzRvT0xYyZWhTbEZadxV/jAvZseC271fXslyPzbu4sZOLVjjyIXsPjViSE5L1CdmxnPzV3zHoNVa8BiVQ64Mr3E8A6gyFuB6XZoBtCNyYrWd+Jo7aFZG41m96gEMv/SvMa1GFT87flvL+XYuIMT/L9B1R8VhcgML50jCX7ALXHspRrJx1KatAOBcgleBgdHgzC4BhY1+n432nca/3gHsUROt7BfmjQBlV04PEUfawkMhtOnNv4VmsWFVngISPV13Um93g9dw+52UjSCMh0osK5jhVOB+S8riGlvJiJW1uzj4gb8xSDrnduaVqXtpmoy5NAvDAljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTiSxHJ9BRqG9JKFkJvfjVwcKvBSZ79BiShDORb1z0o=;
 b=XSbgCXi9sh+njeeWEQ4GUJTjW9kzGGLJJRsWevEg2DyLr3W6Ut479EnvsPCXO1yGJrxnz0fOCwuoiDn1n12I+hCXgQiGIhwZGgTKzLKUbnX6oA/V4e4e+gJnbYFVI2irWchp87K5QohAHezBmDi0ei8VYmNUqw/gPJjdtzo9IffvR2m0VxJmg6zLwCXMGHnf8l8tET31zqXc+zCothCZ5ZWpOiVvsEbAwEW66kJn4RxAERmPO91hOxp4zJAYKBSamTyNeAItyZDv27W/fVN/iP+EBikHtH1BiD7VzwBI8dqy2DtoWcFL84anms9MgyqkVL3bk7CNTHn4Jld/dO5BFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8535.namprd12.prod.outlook.com (2603:10b6:610:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:50 +0000
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
Subject: [PATCH v2 1/8] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Mon,  6 Jul 2026 13:26:38 -0300
Message-ID: <1-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8535:EE_
X-MS-Office365-Filtering-Correlation-Id: 981d280c-8584-420c-2734-08dedb7b60da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|3023799007|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hROVLaxU7HhWjYF8NnXefShKpz49PzWiivIrGTmjVm6o1kooS4RWd+XHzE4Zz9fL8d9ay0iCw2NFr11EjAXpDFTCPYvlCs9eTOjM5Zsae03/Lw2LQGXrXG7Wom2RTzlpRJZ+VVpY6Cg9/BLWIB3/QwdUH7Df41pQkNVtWosbEI7ogBsi0cVhRvKKB5TKvm+FgRXqd3/hD/Nts8cx+Sh1AeGTIvh4L6+/s2mu+6/jSJv1Crtlq8ccwuGwEefGtTimSICOGWAhn/+YAYFMGo9jEMVQjQlPe4ecZqYb3eASssAYKjymFldK3zHZKT8AObpkZ5ii9jDTzLhGk4xrsyxSJBcgsRyooojfZGJp3qmlHtx3t43EPEu8mzf5TY+E9OkZr1gjfAaBhKytfEhB1R8Yho1tmDq5e34fFFT2xVWyA5lMGe5EmcEx96a0RwqTHwBYfWvzcP9ZkfD9kUbYw0ReQfMnFbeXtI3SbOjifPkvSVUKyv4N0XbGQLd7tCugT2PCtPMz3mjFiRHbRfDLPL0sUONIsK/WvWSfRlW1ZhoZPzkSnu4o4+3EQJ2ESm9epIlp0pV0pJ02HgfuIhxXYjtd6EFZub16MyHQNCsUSCO+WKzQYuIHGSzW2YxJhirr2lGK3QDWEPRCam9F821sw+Be/akd847GcXnzdHFGp9hYha4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(3023799007)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wv/t+tWVHSaClmJr6uDdPq6PDzb8HbQ1pwoe2zqAlyPMsVKBrneY/FVQe7D1?=
 =?us-ascii?Q?zkIHWOBfVDcGUhXS2fYBNhowCeawa36eIguZb/Y0Wof+tpxusrwg6wYvEK0S?=
 =?us-ascii?Q?1vwq+aNM7TfXhR3jFavVAIbSWrG6qEgVQtFEtH3RbV1U/PUgXIL7zZSD6mUr?=
 =?us-ascii?Q?dvROhoTOiIBuoNZf0ZcIrVcyeG8Rm7k1jWAtnJDiGWeLvDplUC2wBrWFbdT9?=
 =?us-ascii?Q?OEbniuOxGdIqWctzsWQoSaGfP9rE2lwjhfBOL3gSiVjhQaO5UJdLU1BKPaQM?=
 =?us-ascii?Q?zrhxBVV2K7TGz3W305JfQpTbAYjcWkB7DvKNaa0zdqLO6HMbZwY8ACv9Nxp7?=
 =?us-ascii?Q?Zsh65kip4FRWA32er7+LTg3elSWBpbzM/qwWwdzjBEQ6pceNQywzCL4Q+gQN?=
 =?us-ascii?Q?pdPAufqwr9fLapzN4nEiic18gTI606p/5naBW7ianMdtyjMeEYnog2ATHKDY?=
 =?us-ascii?Q?5KHx14oBQC+lJ044Wa8o5JiD8nTy8J7HXG/RcFAKTRRSQ5e9lpPeFeP7A/qo?=
 =?us-ascii?Q?+TgF3apiCElqmIKWNDkY+1JVMbcAo1Hyu1Vld5SRl8BbfA8zV2GV4R+OOBQz?=
 =?us-ascii?Q?J++jSLRDUH0dkXcI4v6uW2lGwUhZDkrq0mXEmjYo5LXPzoX7OAl21TI/AF/V?=
 =?us-ascii?Q?EVXKI54nSPMnveAXb0AF1zuElq6cF3mzVZt10wwlIPeHNRjapho7uOS5p02D?=
 =?us-ascii?Q?rHn7lxHFaVyQGHXgbt+38mzGZeF87NK4KbRVuq6UNhGuRI7NN3RSyBDGrWh8?=
 =?us-ascii?Q?ITDh6kkV4OZ4ZaLnsr8ZTy1fGxZNMSwqKVGdkWx6t5SgVpYGbKtTcJwGgkJF?=
 =?us-ascii?Q?8gVtRSOHUR9wdz2qCZOnMt/eW8lW5xR//giKNZGcJpLNHxReLSK/X827pe/e?=
 =?us-ascii?Q?5BRxtwLobruDUmCnYmFaXiQn7KvmIIn7ft/XZ8Rrf5nzjdo3ALKT3aja2mr6?=
 =?us-ascii?Q?7+MsxINUWT9UsmC4YxfrdWiIBDSUrOOYUR7Ntawel/pHAGZOGI/3hEPlMy3t?=
 =?us-ascii?Q?0NfEOdnw2Ep5W7b4AOrR88qn9lrmzXFDgDAyYkhoXRqf807pGILj4qpQVOTh?=
 =?us-ascii?Q?Dmj2z7sKtem11T5NXb3ATlFDSYvtvgTGFtd6mLq0q16NDQTjt6+hLTXbPO4L?=
 =?us-ascii?Q?KZEXhMSYhy/3UrfxfHo1HMhskCQxZ8lDMcead++aupJAZbGgSLAUKQk+DSN9?=
 =?us-ascii?Q?SKq7y3hb4kedDdngQ5sx2qQ38ZLEczdJvhUvUnPIvupxmouw4Q+pTFhhanim?=
 =?us-ascii?Q?5XSncPaIaxwnAJXtL5J9p64QTYVQzP1L/Z5YZ8e48LsADvbQsQhZ4HnkQ0QE?=
 =?us-ascii?Q?VSPCSfE9+nQRrMINcGhPc9BS28PP54oaZx5qKobcWofhm960UFc5BjW27BYR?=
 =?us-ascii?Q?OGeyyBlmq1XFBexN2+25mwMElFib20eo7gfDrKz/G6p9zGexAkxCzvlSWR24?=
 =?us-ascii?Q?CCJ6S/KdgXMWdm7LF5HXW7909oV2vAGZA7SSgOnn/A/4829sAlWuTJd4UnST?=
 =?us-ascii?Q?xo6QNZqIijEKoTOnsL1vvl8UAM44NMkgA7WBsv2pwk40CPxjQkVxw7oFerj1?=
 =?us-ascii?Q?h3IBm5yLOX7HmuskFF8kAYJdfb579A2USI93C1H8oV/2mxQgiSQ2l7PAL+c1?=
 =?us-ascii?Q?40NmJkgZa3LZGxENuvnvpuovPovBAnyvcxgwRJIorG5i/wo5YlCpBSpKgCKw?=
 =?us-ascii?Q?kuaVdfQ0cQ2YhQUAjE92SF3cYOF77Fh85kz0Q7Kh+Y5JKCpA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 981d280c-8584-420c-2734-08dedb7b60da
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:48.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSbqpPmodJF9jw5Z5CUgkHA4wG5C1GkTT+BBzpzIph6l25SFU/7xhp90J3+MYm5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8535

These parameters go to a lot of different functions and the next
patches will add more. Put them into a struct to keep things tidy.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 75 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++
 2 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a10affb483a4fe..0c875771b46d2f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2298,8 +2298,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2321,8 +2321,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2397,20 +2397,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd, bool leaf,
-					  unsigned long iova, size_t size,
-					  size_t granule, size_t pgsize)
+					  struct arm_smmu_cmd *cmd,
+					  struct arm_smmu_tlbi *tlbi,
+					  size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = tlbi->iopte_granule;
+	unsigned long iova = tlbi->iova;
+	unsigned long end = iova + tlbi->size;
+	unsigned long num_pages = 0;
+	unsigned int tg = pgsize;
 	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
 	u8 ttl = 0, tg_enc = 0;
 
-	if (WARN_ON_ONCE(!size))
+	if (WARN_ON_ONCE(!tlbi->size))
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
+		num_pages = tlbi->size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		tg_enc = (tg - 10) / 2;
@@ -2423,8 +2426,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (tlbi->leaf_only)
+			ttl = 4 - ((ilog2(tlbi->iopte_granule) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2462,7 +2465,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2472,13 +2475,13 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	}
 }
 
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
-				      size_t granule)
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
+				      struct arm_smmu_tlbi *tlbi)
 {
 	size_t max_tlbi_ops;
 
 	/* 0 size means invalidate all */
-	if (!size || size == SIZE_MAX)
+	if (!tlbi->size || tlbi->size == SIZE_MAX)
 		return true;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
@@ -2491,19 +2494,17 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 	 * invalidation feature, where there can be too many per-granule TLBIs,
 	 * resulting in a soft lockup.
 	 */
-	max_tlbi_ops = 1 << (ilog2(granule) - 3);
-	return size >= max_tlbi_ops * granule;
+	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_granule) - 3);
+	return tlbi->size >= max_tlbi_ops * tlbi->iopte_granule;
 }
 
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool leaf,
-				       unsigned long iova, size_t size,
-				       unsigned int granule)
+				       struct arm_smmu_tlbi *tlbi)
 {
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
+	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi)) {
 		struct arm_smmu_cmd nsize_cmd = *cmd;
 
 		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
@@ -2512,8 +2513,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
-				      iova, size, granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2532,9 +2532,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
-					unsigned long iova, size_t size,
-					unsigned int granule, bool leaf)
+static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
+					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2564,18 +2563,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
@@ -2586,7 +2583,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2617,6 +2614,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
 			       unsigned int granule, bool leaf)
 {
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_granule = granule,
+		.leaf_only = leaf,
+	};
 	struct arm_smmu_invs *invs;
 
 	/*
@@ -2657,10 +2660,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c909c9a88538bf..a364d847c22a92 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -802,6 +802,13 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+struct arm_smmu_tlbi {
+	unsigned long iova;
+	size_t size;
+	unsigned int iopte_granule;
+	bool leaf_only;
+};
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
-- 
2.43.0

