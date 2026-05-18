Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE73909AB;
	Mon, 18 May 2026 19:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133437; cv=fail; b=AhkAqSSQuoWPUcP4PudfqJo/MtDjfGKvOK4wsemvOWzwLTPi/Ty0WlZxRCD3frk7+LeMe6f/dAnR192zkHQSi6Ck81mjHJzkbOb30HpA3LTi6m749pqI7hzaDBf2Zh1qA2yzuLiH3Prx3JmJr/ZsJ7ak4N02cM/4e3xehKfE6YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133437; c=relaxed/simple;
	bh=bQXs5FEoxGmtLcLU0x6LgrtWqUSnTSfoRq+No02lTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S5OzP+emxw1bU/Tn/O/gWN4G79q0ri6P8SDF76YdZRonR9Tu2ehs5zmnKIzQAeW1PD9ZUvP6xgbbWL3q0FBs13UOhK9s5fbOsP3YAvdnvLH+ytCEJ4M63v9c09fQavHoQSvZJ5CuOgFrjcTq9LZPw0fWqeRBPt22dmK7jS1djHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H9YMHbiC; arc=fail smtp.client-ip=52.101.53.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9YMHbiC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=edN3QjDsYT9JjjxPifiBgUFSsuc5Htl6IBG+mwZASUj2blt1Vb9OAijpK0lyl0uA6H+ORKdRiK/pF20uDOExqi8UvqT+OH61JV1t5uDS1LWA+oN1yLiJeGd+A66vqIe5SVgiq+aUE/1/D+PGHRy/GjCsrJB2tVAG8bMZUfxgnKmidGqJH+uno3cL6XsdGMwx2JiJIZj+uK7cOxfcz1nxnwLUAxxxekmogteOMUOMIDxeLFjy7i8G9dZblsx9fOA2It9AKwQiSCJy6zgYnux/f0JxfjtioW3D9+5nbx/JbSD1ooozGd9ohDs3BuQA/Iw5TIc8JNSxh3L4kGS0kV3oyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jwNcGdYroAWvZbvihkpnd9HthfuOt+MCNtjaiX9288=;
 b=PjdDY7+80jIUK5Mu9ShMlh6BTqBVp8B2sXwY3ZWaxvbPQKxMP7prbj5SLdJZmmwwlrfS/lvjLfboB5WCZQHi/EISjeju3wlldMhpA0bn6xax5i/dicw4juPgJAnt/l9wApbW1S2enfbj2QUtgx+o9cO5Tjo4T2fznc8GVFHf1p4qoH+6fhszKZ6gRWWAe2le8rtF5c8q0QvNaIiP5vX231owWZ+QnWANDfTJqTtDeXgRl+iIbNO80pAAoVkQkKdEt5eNZHgkS9FsJBl8ylrTdR7dWHLtacYKigs97NU7P7BgpSnnaVs9CYNw41zjyit6j+B3KuXxFVSB9ayEeUlPjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jwNcGdYroAWvZbvihkpnd9HthfuOt+MCNtjaiX9288=;
 b=H9YMHbiCLQ8fDFYa8tl/XeI0FoO2O/jqZtznJ4XHI/3t+pqKsX69k0/b692MRIiZ5oHX3u+XEe1ZBQOCUhB5A9/MUUAiXrS7o8/rFfp93DpzIZsFrCReykU4YGkAjyv0wLprzC9YwPdkDm+/fvmjhMLGRBXiT2ci5UzeUvBwAkf0Grf0tPiAR0NcM/hztd1Pz4uAri8ovvGRKMgK+xwNqWJxKnkgaA3L71uR3Ck6X4o069/RA9QH8SXZuGhavyDW8dCnhWgYKgVl+pQyU+NoqRQ6+J5Giu1r+lbJvEAG7rHaNNAfWv5g5eglpr8q/LlaoTZn8DUkIFVBv8rGPTn7eQ==
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
Subject: [PATCH 1/8] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Mon, 18 May 2026 16:43:38 -0300
Message-ID: <1-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c1452d-6358-43a8-4111-08deb515c75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|3023799003|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QQqb/QxGGV4rkctHzGWwHa0nnz+AaniMaY/TV/uJqIeJHdSyN5GzRVrMV1rLezt703tq7UOpauEkx0r9mmhkbVsUCFgCVL21N8h+98U/EO6FobxGo1TBqiGI8Ixxv02Hsy5lsxHHXRT8ZvHY/iBD3rTpPNlnD8bB+u4xKkouLYVwjVBmeUi+n31d8NqZoEbuom/JYeS91xK4q9kof98x2HsXgSvPoipIHFNYNX4OVLxiikmeUPxzh1EYts0QLOtaNWr2Sr3i9cvMHzu+5vHgHT43CT2mARBMGMF6B/PFxnxto/wA/74iJW3OPZSvQgWn9AbwCxK+BJEDkRni8CkR3ScS3u/gbFrIvhvkJCh89qJLLB2C+x4VlSh/RvLCuzFyctuyxmMbc9wtXPuQE31U58BIb0vnCP9TNNtEPqEamZ69Nb+FQDVjt+AI7LI/ROVe2d7VTg1TkbMyBQy44I2D4OIa5JpR5jZ5PHqtvUbX4wOZpbE2k4uX8Nt+Sini1zzIXy8qgNytC3nPV/1iuSM5CocD+v3WjGvk8IO+vtE6Zemsg3VvUT9QTgOadmFu4No00sb05Y/Izq/tRUf7l9IO1l8Kk8Y77mdbeLnYBmWkYUsoEyuSgN6x0VRvfhuqLnHZhbMMSWCZ1zGk0ft02tj+ieTejN3+QBx/M430mgKZZS226ZVAZnGaodJwNl1Htwy/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(3023799003)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ySnCWRALQfUlgmPlhbL8jakYok0TVHarjM4X85ZX4wF6Mp5Id+tGQqFh3LcE?=
 =?us-ascii?Q?VuqVbWWK2Q7STLAscIksDMTIgGeU/E95JYrQ9O04KmBHsmp3a6FtYxS+4rdu?=
 =?us-ascii?Q?N8W3MiZO6nZBXgC0b1QKvEsFyB6ashOY2e5FVt02ecEHZc8fv20kR0xLu1gU?=
 =?us-ascii?Q?aTrVLmrXzMISjXItotHuEC2zUZgYrj8lf05JjMHrhP3tVOHOcZE/e0ViiI+e?=
 =?us-ascii?Q?X4y1/NPsEyYk3C1+Ia89lmZfuRyrFDKzT7uMU81Sf0mfp4cJJrksuMOY5WPo?=
 =?us-ascii?Q?Ww05C2OvKhNhLS0uU16JHaL5jovDWouiaLNJdJExsQzXlwpsWmQLxhLZEXhY?=
 =?us-ascii?Q?vA9s0l/ZWWFz57ScFK9ajOaS2/LYWb6+ri5hANoBwAmFaIkaztA9rmbVOWmx?=
 =?us-ascii?Q?jhY/PtIOjPF3QrK6IUJLUw1ne1dE1BdLhYa+g7bwrnpcOcrTXbdx1OQDqT6b?=
 =?us-ascii?Q?u0+GZDODq/XqQ18j2H8FIUWHQSrvMSEw3M3s1yBTu4jZxELPyPykXoSrub+R?=
 =?us-ascii?Q?++WugDfnkksbpKs+y8VOkxC8vOxBNXq0RnaKCyblCyEJIx/IhtwNtw6zRbwT?=
 =?us-ascii?Q?9U0AZV3GCWflsC7AaWnULxAgDnCi0Ic8AqHXjkyvb4lwqUvA14NVK0YW38f3?=
 =?us-ascii?Q?4vYjmcLIUDdFuMVabKvfKKCntoiaT3DUPQNqStZho0BbeQ2mOVUaRSmLC58A?=
 =?us-ascii?Q?XzQ4JFkBIYXoHut5UpvROzF0sbyR74q/zz0MU/MJbCwqJPeFaori1xbpa8vM?=
 =?us-ascii?Q?YOXYIidPGweM+iGQf9GFuPnFvTXE6DGwKC7WSHiwvlWNlzwLUoYOOIDmTL1J?=
 =?us-ascii?Q?fZ4tDpEL/LlFCbp0o+xu0yhsWwexEG11LaovgUfolZlLQJidsL3mw17oYmbd?=
 =?us-ascii?Q?mgd1MjKwohL+WNrH58X4HKwm9T/IGRJMaEdPIafGeBjsvXm0zhku4QWWQsTN?=
 =?us-ascii?Q?1iRoyrduojQkRvnlhZocn5ebp8hDWjOWwAlp8U5Lq6VoMkxsnZWnqlacuUwI?=
 =?us-ascii?Q?M0ONiL2QnmykKN+NJdW1Lwlk/jWewwsvpU/nrl/0nndVR9jJPjhBqil5ixjz?=
 =?us-ascii?Q?CgUQeBJjYEzrYhasStlziAMwqDNXx/dtnhatUor8vCCaN5cKL4uSdJ3ON46V?=
 =?us-ascii?Q?kTKM5AdXTVYyKyVpx2d/wUVwF6MnMb9iJUEol6bxuhNP+Bkl7q+RRRhBZHAP?=
 =?us-ascii?Q?x6ufVPHNA86nYV2njaxy7ydxXjErNO0Cm4ymjJpbRilJ5oT+M1unIeUqLQ5K?=
 =?us-ascii?Q?fagAVplLvTl+Ce519a6s+KtZ0YulkcnoavR7BCJAOB3QAxbZXrW6KcdtFxQt?=
 =?us-ascii?Q?waGnvOuGI2PX8MFG4V8/eExEo3PA2zAElTXEd0RVbXh9e3CUnG0SEzX2DQIr?=
 =?us-ascii?Q?fa23iSCg24tO+FBjPRRDIbXcLym6wGFLuopFC4cAooKrJeV3TVoGzFImKhgU?=
 =?us-ascii?Q?xnR+eejH79lu2xLLizW0HJ8+lv4vV0Yv1XfFafjTfSqUFbKZ5d6zspXZKhjE?=
 =?us-ascii?Q?d076dHIsepwO+91OZtHodpi4vwS9zCh/kNxJjQgJJSoisdt7tLICquHMegSY?=
 =?us-ascii?Q?fhjcH0sSv4gYtcDrEjlZHk8haG5nWsTIHILGXDePPP1PNz41pQhlpfXZhfHR?=
 =?us-ascii?Q?kDKugh30Byej7eX2fIkM7lr5NIzUWm9gPsY4mE/+SSaePnCH1tHSi0GscLDI?=
 =?us-ascii?Q?cF2xEDs6mFgarIreQN4SBLefswoNjdaFI5dPQt7mQr714cJz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c1452d-6358-43a8-4111-08deb515c75f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:47.8905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CpF+OpYi2Yy8OYDA9kvw4reStDg9BVKhHKrIjBv+HUrRTUG4/lxcihvGRAJ2Egh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

These parameters go to a lot of different functions and the next
patches will add more. Put them into a struct to keep things tidy.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 75 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++
 2 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9be589d14a3bd4..f7881d21eb06cd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2279,8 +2279,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2302,8 +2302,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2378,20 +2378,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
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
@@ -2404,8 +2407,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2443,7 +2446,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2453,13 +2456,13 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2472,19 +2475,17 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
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
@@ -2493,8 +2494,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
-				      iova, size, granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2513,9 +2513,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
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
@@ -2545,18 +2544,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
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
@@ -2567,7 +2564,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2598,6 +2595,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2638,10 +2641,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index 16353596e08ad8..4e97aa5d011a98 100644
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

