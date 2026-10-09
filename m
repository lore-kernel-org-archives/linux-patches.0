Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AB54DA9D2;
	Fri,  9 Oct 2026 20:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791576870; cv=fail; b=OgQn/K7EE+gKr9kkkx2MNoDwP3bZAozPS5ZMB+kzZyF+3rOXAf2kw6r/pDMePvssRDBpsbCTLqrrnTV7yFFND3xmksxzvkDnnuIWeODtqjUvYiQxFTUTpqLVWKFoZy+2ijch9jx6qRauBHcbFA24v7Dhamfu7W4CRvyuvRUp/Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791576870; c=relaxed/simple;
	bh=uyFj/oNWJ5QoXCppPZtLPc4pBc44dYhb7aMavcSBLqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dPXZ5ZYuE/y53Cb3YvYCVReJvhyr6EFdMHzJ+ksl+itJj35LBkMH4nNUPXBmdlKjI4mHq6KAv3Ufe5CG9UNBOyb3zVdyTfdURHJs+USHtFjvw80XorI1vxjd9jBSBVdwCN+KjYZbFLcArw11eu+DsDOeaQkCt/Yk+uEspq9iv+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bZct6cB8; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bZct6cB8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pqtd4vZcmdA27MzktYuQp5RGIpGm5W4+MMqiBEgsjUA7/vkTdSiLH16aRrDC18DZ9w9LaCdoH/w5YbXUHpxkHdF7RpkPCsf6Uy1vZQ8nyBfudNCI5txhhNAup81e0RlENA+l7Kq7xhJXX6Lkm43niAW2QKe+wuaKuQN34nrY5M7uRN0yH/VD35w+VRVamK+awx/LDk/FTBJLhTQwqGiCLWdfS1ubdgKoNmGw4KWH7Bws2BxDk6fHrPotTp5NhSFpGdwO0GCwHRkSOU1zQ6WYqMz+c6CNi83aSZgzek/qbEuW1gI1SNJvoHx4TL+pVEyisxfgHcjMCnTCC0XIgERAYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQAZdZEBJ3VUuNy1n6aoWmP5yhmdXdbqG5XkKP2SDz0=;
 b=PKKbvm3iSg+MGXQDqzB3nqmQI0ckGMfB7cRXErIZlaQzE3/Ewg1jHAyhpxhMiHTLPSZJ2RStDeog7jbSwIeSyQjF3DOQ9RhMS5NeiRbXWGQwwJZuUlp5sozKv2/O9Rxp4mt0iTrYQGAUkVpYR5etf5cpkDMCDMcSEP91OZ+KGCof9l66iTya3ANQNjrtJyJUPG33jyMTwQe1+mhku2yMKNLKVsh4viC9ny37s0r2vV6tVlfZaPoWyIZcxIqyqvRlZcPfgMKl7bvrwrUXiwrRnYcGWgbivpPitHW0jdMKgvnDaujzBYrScToLOqxhpYpuoIlTZAjixHjbPva7pojF8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQAZdZEBJ3VUuNy1n6aoWmP5yhmdXdbqG5XkKP2SDz0=;
 b=bZct6cB8IZqM+uPza8m6+zcZ6IcWoau9lSHaOnWakRhBuB0sCeBQpHZt5syHXTX1mW6v9yFydA5S5aFCEjSS21wVqGU0nbfH28euugANX1sH0dK8EXIOAK2ljbo1pHOZwGSQCvWQVsidEktxcvem5eFpg58mMPKrClxTBieE8+6uzP6oLuubYLmskUY8b074wta6laB8nSy8NLU/+xFrjPW2gnE8qyd5cn0xZhQCNKvt4ez8VGdU86YjnBhxRfs+eCw8rdu7y8Zgt4QdPRyJAR3o9bUYb86dD3XE5yZignnZ5KN5mJH7CRJowCFiXrIJUmnlNcd05QuF0FaxVVEqGw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSVPR12MB999174.namprd12.prod.outlook.com
 (2603:10b6:8:389::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 20:14:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 20:14:20 +0000
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
Subject: [PATCH v9 1/2] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Fri,  9 Oct 2026 17:14:17 -0300
Message-ID: <1-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0461.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::29) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSVPR12MB999174:EE_
X-MS-Office365-Filtering-Correlation-Id: 317a9822-3afe-4a46-326c-08df2641e6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|22082099003|10067099003|18002099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uIlUhUiwhDm7imAxcOo5mx29//5/2I5FHAOTJ5hzLI9qm4wKPRbEaPR/Jsh+IRV/PChQxLBU7SXCidpmXueSQ3aIqZJJCcNPW4on+HoNUfQGDVOgxdv1om1UYCKHmhNtAqp83rpw/iX/p0aZZ49VcJ3LkUGnhSkHl1hCtvRo6pzFYTe9nSplhrYlJ41xlDh4D2GmW1o2bHvqUCKQQmxHblb0GaapO1EcmrKrK6gU2BuIb/92McyprOPSYe52J3FB6n+qztwzHBqxUXWtnih8hDK+XM7w0w8R0PSOei1DXuLKYf2PmhwelAOH/jVwWor0xpkIwPyN9MNS/uO9EOjEWOx64IEk/wkacIQss+dkhqUTumoNWoqawMKq/8OAQY+l5xX1ceSZwJLBSSK+MZkj/4OJ1eagtRznZhji2MGUCw+e0kgk+saWAU4NRAatjV7V+GRUf7Fp405cCXUqYczAVQZhc0PoZKY06Bv6SaR57TKZtvBM0Y90swhqS+Ajs0cuILpg+8SGIjzMMM6hP8gFGo1sDukP+7eUdAuzXp4Rer3dBJUPekD3UfcQAN8pbsqyJ6IbX1obI5AGyus4Rs86oZLOLUlroQTOAGTGmOJoj495yJEqF3tOSE8rhyOhvCNaj8X7BxYIVzefOB9me7TUEjKiRVPl+q1UrWgzCTFLfJQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(22082099003)(10067099003)(18002099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aMze5Rw94JIdQhYAwJpWo/m5SHkRGKv8TB5Cx6w87kMrRLrjLSC/jJvVqQFN?=
 =?us-ascii?Q?Hj0+47cN7SME0X/Tb9B6Z4Ilduj/lv9wQq6KZmYqrQUBbAJQyPScOzVYk6M+?=
 =?us-ascii?Q?V4NIviDfc8i97uUSCaS8t8gmyqCdu+QOAclhSZuXRLjH/z58pqTvlauQfLGT?=
 =?us-ascii?Q?6z+vmJp98Na/D7Y6qJ7zG34bW1Zbj5pchrK4B6RTzMTBxUzsAiHwpI27RZuP?=
 =?us-ascii?Q?5PfEhgtqoW0880gPqrdUpUX7EabIF479jvJHMCL+ENFcpm+UwT1C1Sd3C7ms?=
 =?us-ascii?Q?TQX0a3Pmhq9zMPrsujVYl5gLvI4lcgcShMqJCtMRIC0BfkEnMhevhzt4qAX8?=
 =?us-ascii?Q?DaQcwlDjrmrr6qfgdM8D/RA0zu/TMeyli4yYPI9x4TdvGUymq4I/GriZwfR7?=
 =?us-ascii?Q?fPKitVDnCPgIv4cn7XIJhb67gkvSNyspWz+9O3RnUpXjE/h0taGN01Q9eJLw?=
 =?us-ascii?Q?RuPxRlCXtnyEjlrzt9LVTk96Nrg0B1JzvCIpVXdImetD5SlUnA1s3Ne+1pQK?=
 =?us-ascii?Q?5agRvoJVZH84LiZujYMGsC5hBfXLLzjUFs0pVm1nd7pXoqolL7uaCcwLvqrw?=
 =?us-ascii?Q?0+HdrgzGa4fry1kqi1tBje01MFZcE0cIwEbx4b8PJPWhbtSF7wEMeT5Nw2qN?=
 =?us-ascii?Q?OiSk1XEudtPbtIeIdXMAr+LKnCL+D82Iu/Or/9+z7Yy3VVRCEy3eQ2w8xHyS?=
 =?us-ascii?Q?/EAHvTzM5cP0m/uXFAZeEuSd6Syhvk+UvoRV4RZF5qqIlXhHDFIrjOgE6YbZ?=
 =?us-ascii?Q?80AadPDrGgkX6ye9EjFEHclvCwAl6kk5CcMQQvsyU4JquNRPosweuCO0wcdj?=
 =?us-ascii?Q?E55+pdbCi8jkCpGYfJZKMmLiphnFa3AQdMYyYdN/HYm4yRlaTH/wBwvOL8cf?=
 =?us-ascii?Q?6c6gGQOWS1XL9KDvYNmNsFQUG1mcEz4eaRix1pDENg9ZROoi0JGxeAAAKt+K?=
 =?us-ascii?Q?k1YwX9wsbGktPxSAsIqySO5fymTqBl00k3B8xPVocvI4IlhiKKPUJxBhlHze?=
 =?us-ascii?Q?wkwsEl6N2UhLhY94PBvLhBeI7Y2+Omh9kAg6BzawX9qRkMvCJ2kCZWbnwdKZ?=
 =?us-ascii?Q?Ee9dmy6mvehioozTI8dAdpXrULT0cH/28HVGya9CPIqJp7HSHlV9VLrLXsKT?=
 =?us-ascii?Q?/0P5Qo9lDOisr2jDHVsaT11aA6dOvNZTv7wwbcxoi6y+7rgrGHbFAEO5fULy?=
 =?us-ascii?Q?L//QDWiwXl1q/H5GkvaCKvsoNqqFFTOmtybYZmNT7+gVGFKuFQXf+zA3I8V8?=
 =?us-ascii?Q?0JWJbXstr7y5GGB5udNnJ2Cvdc6zmD7VYuZ/JdDdN76O9hQ5EipnKyI7xQSh?=
 =?us-ascii?Q?6pVqDHll9gFNrOY3UVp927wpuMu894qOB7KWF7ziLmm3Fdba+qezS4f8pkaN?=
 =?us-ascii?Q?SOlYZeD8Hb8DXNnkwipcBc8jxjjaQVA+jNApxXEeGMnSXW48X+Dpxcb1LEAW?=
 =?us-ascii?Q?84FzvBYtRn8dNMHOaSABMK7FLGWMBulIjzGPYWyXRZvI9ViL1nofX49RPsYi?=
 =?us-ascii?Q?7IfLTRd1vavDCV1reuGrqURB6RMrKUKhciAkhnGNe/OK/aN1R/Hl4UuRe7yk?=
 =?us-ascii?Q?y18KLckQrwROoezl6/JLFZHxvEbN45O9Wx4Vt7PlLz0TMBQqvHyqzSGe78r5?=
 =?us-ascii?Q?v//4bE2ENSQ6f6QB/9L1FzVxTBAwKUkX9bycOKRGo6qfEMgpv2d0z3ySDX3f?=
 =?us-ascii?Q?WwY+ijBUJw8kQNX6e2PpJE107FGlfDXWgUFGGMfabyWXzYVn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317a9822-3afe-4a46-326c-08df2641e6d4
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 20:14:19.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqcpFRu+C8pOJwnuPaWuYMYK/nKY7hJN9pf2wFA/zY6LzSi0oQVr+MrJbD5YLTDw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999174

The range-invalidation logic has long had a FIXME that there is not enough
information to properly compute the range invalidation. There is also
subtly not enough information to properly compute the single stride
either.

Change tlbi to use the information format that iommupt is going to use for
ARM. This prepares the invalidation code to support iommupt and fixes two
small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single gather,
then the iommu driver should issue a small number of commands to execute
the gather to control invalidation latency. This is in contrast to
io-pgtable-arm.c which generates many gather flushes and direct walk cache
flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps, one
for leaf changes and one for table changes. This is enough information for
SMMUv3 to compute the proper stride for single invalidation and to
generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt conversion
will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation is expected to clear the table, child tables, and all
   the leaves it could contain. Set a range of table bits and all the leaf
   bits.

   There is a weakness in the existing io-pgtable where it double
   invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
   again through the gather. Since these are separate operations they are
   not capped by the invalidation count limits and a single unmap may end
   up doing thousands of tlbi commands. Eventually converting to iommupt's
   gather only approach will correct this.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the range-invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 193 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  25 ++-
 3 files changed, 188 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index faeec656da9e7f..fdc6cb7a128037 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
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
-		.iopte_size = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	u8 pmd_lg2sz = arm_smmu_pt_level_to_lg2sz(tgsz_lg2, 1);
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows range invalidation to
+	 * use TTL=3 in cases of PTE only changes. The mm must not try to
+	 * partially invalidate pmd/etc.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 34e916ea339ff6..6c6588477e7301 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2418,8 +2418,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2545,16 +2545,11 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 			    u8 tg_enc)
 {
 	struct arm_smmu_cmd *cmd = &tlbi->range.cmds[tlbi->range.num_cmds++];
-	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
-	u64 iova = range_inv->start_tg << tgsz_lg2;
+	u64 iova = range_inv->start_tg << tlbi->tgsz_lg2;
 	unsigned int num = range_inv->num - 1;
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
-	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
 		ttl = 0;
 
 	/*
@@ -2562,9 +2557,8 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
 	 * to target only the exact leaf entry.
 	 *
-	 * For a single tg invalidation a 0 TTL can come from places like the
-	 * SVA path that don't have enough information to get a TTL, or as a
-	 * side of effect of the splitting.
+	 * For a single tg invalidation a 0 TTL can come as a side of effect of
+	 * the splitting.
 	 *
 	 * A single-TG invalidation cannot reach this point if it is part of a
 	 * CONT group, so it is safe to transform it into a single invalidation.
@@ -2575,14 +2569,84 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
 	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
 		       FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	cmd->data[1] =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
+		FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+}
+
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
 }
 
 /*
- * Generate up to two range TLBI command payloads covering [iova, iova+size).
- * Sets use_full_inv if the range is too large to represent.
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					       u8 tgsz_lg2)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		/* If TTL is used then only leaves at the TTL are invalidated */
+		if (!is_power_of_2(leaf_bitmap))
+			return 0;
+
+		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl =
+				arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+			/*
+			 * A range invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				return 0;
+		}
+	} else if (table_bitmap) {
+		/*
+		 * Table-only invalidation. Spec says:
+		 *  For operations with Leaf=0, invalidation of cached Table
+		 *  descriptors for the address and scope additionally occurs at
+		 *  levels between the start of the walk and the level before
+		 *  the last level given by TTL.
+		 * Choose a TTL hint that covers the only target table
+		 * descriptor levels.
+		 */
+		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+		/*
+		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
+		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
+		 * since we don't know what instance this will be applied to
+		 * yet.
+		 */
+		if (tgsz_lg2 == 14 && ttl == 1)
+			return 0;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		WARN_ON(true);
+		return 0;
+	}
+
+	/*
+	 * Assumes the page table is formed properly and does not trigger the
+	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
+	 *
+	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
+	 * 0 cannot be hinted because ttl=0 means no-hint.
+	 */
+	if (WARN_ON(ttl < 0))
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate up to two range TLBI command payloads covering [start, last]. Sets
+ * use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2591,28 +2655,21 @@ arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
  * invalidation overlaps the first instead of exceeding the requested range.
  *
  * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
- * produce only a single range invalidation and overinvalidate so any potential CONT is
- * covered by one command.
+ * produce only a single range invalidation and overinvalidate so any potential
+ * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 				     bool single_range_inv)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
+	unsigned int ttl = arm_smmu_compute_range_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	struct arm_smmu_range_inv first = { .start_tg = tlbi->start >>
 							tgsz_lg2 };
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - first.start_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	struct arm_smmu_range_inv trail;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both io-pgtable
-	 * and SVA pass a nominal last-level granule because they don't know
-	 * what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
 
 	/*
 	 * The spec defines the invalidated range as:
@@ -2653,20 +2710,43 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for single-page invalidation without range invalidation.
+ * Returns the log2 stride of the lowest affected level. Single invalidation
+ * removes all IOPTEs that contain the IOVA invalidated, and we can reliably
+ * assume that the architected page size and table sizes (not contiguous!) are
+ * reflected in the IOTLB. Thus if there is a 2M leaf entry we only need to
+ * issue a single IOTLB invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+
+	if (WARN_ON(!combined))
+		return U8_MAX;
+	return arm_smmu_pt_level_to_lg2sz(tlbi->tgsz_lg2, __ffs(combined));
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
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
@@ -2686,7 +2766,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2711,9 +2791,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_size;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2908,20 +2989,26 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 }
 
 /*
- * Called by io-pgtable-arm.c for each single table level it wants to remove.
- * size is the size of the table level and granule is the tg in bytes. This must
+ * Called by io-pgtable-arm.c for a table level it wants to remove. This
+ * implicitly includes any table levels below it as well, there is no seperate
+ * invalidation for child tables if their parent's range is fully covered. size
+ * is the size of the table level and granule is the tg in bytes. This must
  * clear the walk cache and any leaves within the range.
  */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 level = arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size));
+
+	tlbi.table_levels_bitmap = GENMASK(level, 1);
+	tlbi.leaf_levels_bitmap = BIT(level) - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4214,21 +4301,31 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * io-pgtable-arm.c calls this function either under
+ * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
+ * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
+ * with a single uniform pgsize leaf. If it has to change to a different leaf
+ * level then it flushes the gather and starts a fresh one. Thus this always
+ * targets only a single leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_size = gather->pgsize,
-		.leaf_only = true,
+		.start = gather->start,
+		.last = gather->end,
 	};
 
-	if (!gather->pgsize)
+	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
+	tlbi.leaf_levels_bitmap =
+		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb048e08d613d3..b08c112875d3b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -830,17 +830,30 @@ static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
 }
 
 struct arm_smmu_tlbi {
-	unsigned long iova;
-	size_t size;
-	/* page or block size of the leaf iopte */
-	unsigned int iopte_size;
+	unsigned long start;
+	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool leaf_only;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * The pair selects the invalidation scope:
+	 *   table!=0, leaf==0 : walk cache only
+	 *   table==0, leaf!=0 : leaves only
+	 *   table!=0, leaf!=0 : walk cache + all leaves
+	 *   table==0, leaf==0 : illegal
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1213,6 +1226,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
 	/* Prefilled for invalidate all */
 	struct arm_smmu_tlbi tlbi = {
+		.start = 0,
+		.last = ULONG_MAX,
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.single.use_full_inv = true,
 		.range.use_full_inv = true,
-- 
2.43.0

