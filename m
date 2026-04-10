Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2A3D6688;
	Fri, 10 Apr 2026 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836642; cv=fail; b=gM+P1PJVq4DW5/DK3k9lqUxphWeIT2iesQAPY3L2h5FuVGkMU5grf5ZUa4CIgl80A97t9ZA/C1vkMRmDSFIBzf6xsitPTJ42V9myvPOmUzYx1xD1AzQgFVjiKUFmm49HFAz/KNNRfaPqpq46Sbi5DezLYjr5Y+HtBOh6MgzbaUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836642; c=relaxed/simple;
	bh=zMPlJmpa0leOryvQEWfXCuSeXijJkQZmCA9AGheAMtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a0jSsJrdET/eDLIKvTxFe83pP3aoIS3bg8Rlwfr2f//+KHoOcbegje7gErTZr+/REdnZBsea6Ez/D1t0RWP3mXh2h3YQbMPvdyBrHSepbi3XVPDJFWz+cS/87KlMn1xc4UlNhU+D6xMKHMFckPKBjhjkxjL/qVSgdyWBKCrnyJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jZcBppCz; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jZcBppCz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XItj/jjh12Y1STa5M+poLHtTE1RAuVHxiVbenRUU1z/t0fZ8o4RXQW0D8Ay5JvUOLaz/mZ5FMzpThXXBlmQKN6Mm0oJhTbrw5586dDfvb3AsDcVZ1jdQZmZQMufocatwEN69vIVWrLaySGCFQhy07yZ5BFlSQg0EtVWbGXIX6vFfx78vOGnRBTS2AHa6q1ubXv3/ilMQFB9Dpt5Vaa0Agdk06s9J+lVc7kULUOhdO0CkuwU+41pytF0VvZ33/Yi64zlaSJjcNQbD+fz+/d9BujagJgtfUPyB03Niy6oOwwM9NZzyqHy2BtCVogSn3bTc2SayJQku1rBVdEDLE3yJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Ybp7cdNBrAbS+/A9QJb8RV3prFpAzzYbRq5YovrXzo=;
 b=RCXLPDPvVMNvT5YaMLod5s9Cf7ZrHwTgcuEiSt03Slry0tpRLp6xdCRqtpBhfCHjbas0gmqxNuAOndUIEZnHm1+/rEuSfc6dG0Hi/11qoCwKnr2PfRWgE3e/J3JOx3X2o7zmD/IMdcEisKCNnELtDl7658KKN1KyBGeMvrShy8QpDpfA91ujS1aXep/OZMti9VridVNzZ0QyroMvSzWHhvlFvH0vYTwWpjE1CAf5La6zSHA0nxDQ6pGO+Uew7v7sLCavXv5zNITEFjidhfykLfsKvT+mHiR86BFgnPgGMGN8oBA9LhvAn6QTDmfXn83/1TRywbgAI975cWVCE9ICDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ybp7cdNBrAbS+/A9QJb8RV3prFpAzzYbRq5YovrXzo=;
 b=jZcBppCzFXXPuBK3MupH9J6val7qspe7EkqjBu42D96xeegCUdJi1y7AhSm3xpLVMeGKaNAhpAq8t9A+FfE4ACmnXahdkM2AHUEYToIRu387Ti9dpN9E+lNipw26iUUffiQbl4W3rsg9NZdXlKXRak2+hFZ+71yv5t+vMYWH1ffHX330ivES+w5gg4llwHhMkKrU/b8BqT8nc7VlRCtKNTEsC/eBoQKAOj5034UFzH/3Nn1eZPMeBNN5hp2ahpOAxEpcbGaZldJl6HUVEEHPfbFYalu37np8TMjj3acxjtyceLy154XXAcoqNB5GxyOCaDXjbteew/hQo+i144t9pg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Fri, 10 Apr
 2026 15:57:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:15 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH 5/7] iommu/riscv: Compute best stride for single invalidation
Date: Fri, 10 Apr 2026 12:57:06 -0300
Message-ID: <5-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0070.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: efe1c60e-1361-4f28-bedf-08de9719d378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LFhpEe0JOuEyaa6YKS6ffUZUZ/6c2TSnEAWYosZGNBAYB53P6RFHVz20UZVPWUbpKHGSeuT7dW/bMh3wyrkx/eV27kX9k61RN9O9vNxnGhr7Qhkxu+ccTVlGtNxP9HwmDG8tHgrZdFlzSMkrRd3ZoG5f5j/UO41Rzh5YRPUzzzQSBHxLPdO925cqTPW0M8H6GviBLX6YDjzgePexeceu/ZmmvJwlBUEiWTiB+MO3B7ScAVfKx5xImrrgbOS5p0hMcUVyWaImIbxUeQSRnPGaiDJl4uZvhvINQllKNYqE3icaT1+vEkMPH1TccpQaEd4qIk/Z0eRgTy14Zq2WeGEKNIeZ1fxx/FgXzC5DX9iYyWByUwxVBi6ryso86WZZ4+R/uBWzscVr0gk34oFwX1/3jKqTt5jIdntOQmD7YAlofq4wCH8veSI26C9AAJXWs5HEPzBrcym9TDmbpU0cDoikQThXkhnAkNHBEj3XyRBXCWZE2vn8EyJw90tnydjTwVFgGyQU8S9wpZO2ontGXS/4khnQ7UhV56pDqC9r3m6e67BupHtfXLoZ6HR5FpclGSX640yacCOPBh/EEw9RpdkhlLc795dyzRd6joodV7Umm4K55rOgNvMamfNxz0QCIRf0v1wd8J/1lbSGLXGkK2Of6IT2ZTC3b/27fvb9i0jTa4janFhg5AYs7SqTdfuca84UBqCmC02/J/kHb5jwFpF0YBkLvLVaGR1TQu2RsfCM7uwTDZD3gVK0HbwITlUK2TnTlbFduWm/LduUpagBZ4Y5Eg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?maDpiLj1oVsuq94qmf5yNSWchVEIwklmEftKztm1Eizoyw1Mn0XXJNSelCTK?=
 =?us-ascii?Q?EvqYJ8udJEpG9RdkxfdOi7/gSzNfMDRA5vFSNtacz7hOgX1IwJRCdt9Lsu4C?=
 =?us-ascii?Q?ITe935qdYujRPKrLNl1xQMd3sz18YDVtt+7OhhPReKIP8UBuXldhOju4Qlnc?=
 =?us-ascii?Q?Gaumxmu0IQYEDgCCvYG+gSAE+/Gf91Z0e60LEF5GEh4oXzINjBM8KBGQVcCt?=
 =?us-ascii?Q?Lu6zwUnJ8QKrB4dISiXyhZoDSIJPowRnyrRNKyWqw6vqI+fLofZLIt1g9wKR?=
 =?us-ascii?Q?7EayD9z4W6MjMNqMqLFAKqYirgnBcx5p9Ew2pM96NsycOa5DfuP/ye++/Pq+?=
 =?us-ascii?Q?61bp333JB04H5SWehLkDVozdALnK12MaUBjKbJicL/VX+9DM4va+WZlZTTeX?=
 =?us-ascii?Q?4PiAlNQ+2Ao19dSg0zfg6jNgdSHXtNOPVIOhKPzo6VCCXXTKTbzRTQXppW8a?=
 =?us-ascii?Q?FhpHLoz6gqQZSyHGUIMXdbGJW8Gj3PKaxcN3BbUG6FKeuVaqfAiXiX959/6w?=
 =?us-ascii?Q?ZRb2Dnt+2IWBrscDoHk9WzoQ+6OE+YfRHiOsQ6g08JjuYGo85FNiHxVZk87h?=
 =?us-ascii?Q?kSDXG2pbab3SMNyhZdPXb9vWFsO+ab/xQRMBNuDX0OCBgAytq7YkAASXzvOB?=
 =?us-ascii?Q?pN4i9SbNslftXoMPDqiB8fSDQpKOxjT5RnDJOPm/+ABWbvhZOunDYTD+bvNC?=
 =?us-ascii?Q?C0n7Etr6CPUxMOCvPqTOPnVNOgQpbU1XJzAI+AxIMXP+xvR/pnaX1c5iNi8Q?=
 =?us-ascii?Q?Jro/I9jEbPsAAOkZw5Hh56eFjq+Sb1c+ZWK453YRkpBVmEvzlYmvbZp0RbeN?=
 =?us-ascii?Q?QRpc/coxu4GRCqRpdtrSzN1kwtNyYflXWN3740lUgA7v8s8Mdva7zsEeVqDS?=
 =?us-ascii?Q?4waBTjvSjEILbLBy78h3n326rbsXvjtunNfSuU8nKQolkxdX9oZSTfUZGWb/?=
 =?us-ascii?Q?G4woxy4fH2fg8drSvL1J4WWNzUJpzGAbkdpvcXUX6nhNgijMLR0wclWHCh5d?=
 =?us-ascii?Q?OE0pryhzUDztM9j6xlL04khRreKyskwgTpjJ/CoyCgCoGGgB4VL9PkSTT/Fk?=
 =?us-ascii?Q?nM4Xf62WLeFRPZ26AJA9LaJinjP+Ud0s/FB3tfBX/S3aHKFdS+XYVHUnRi6u?=
 =?us-ascii?Q?uoeEK9WkSClXBnchEhfQMVrdobHgkj+eLojlHXKz3Jz3GrpfKR5Jusu8S3jZ?=
 =?us-ascii?Q?gqp6vdTMmLA6xupAB2SVo3EVpcEc+sCQ/wDbeLDNaYMV33IbKi7qwRBEe66Q?=
 =?us-ascii?Q?6ks9922S4uu3BG86udMSKnC/prnVYrkCu2DYmfUm1KkwfozxpJqZwP/vS5SZ?=
 =?us-ascii?Q?JSeod+qjQfXCNcnZhCY+ISNbfVd6PzHSA1ZoB917Yp4fSCPmUGX/yQ4hfrLc?=
 =?us-ascii?Q?32B2Az7jXOnYxuwdQ76Exnf4zpjyPoYR6/qTYg8qTmP/WVW7sDQWP5dUyuMl?=
 =?us-ascii?Q?OcqByhr+sOkaRm7FLMVTSCC9DUZT4IaplqTaAQoWQ7qtZkKfUevSzQG9Hrxt?=
 =?us-ascii?Q?3yV/dRWGriL0cbqqKibJGQIEG0wpGN6EP96l/yXWdL6djbtWqqDitt5h/wAT?=
 =?us-ascii?Q?HgoipOzMN+zWOpQEZ1Wy2XjPaxsiL9PlMkibdVpeM40Yo00V1k/QKoZpMAbM?=
 =?us-ascii?Q?WkumsBBMr1/+ij5G+wVKjCPgKxV4PrgArQgiFHpzGL6zqrxUlXvEVwiUvOKW?=
 =?us-ascii?Q?cDjw6msXeNE6Zi15AtkvuwTJnHugEceoTsBQ2J8DhtoxlAID?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efe1c60e-1361-4f28-bedf-08de9719d378
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:11.6253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: guoTb8s0aPl/s9HSEYaOf2ZydsX8tYWx/Yq1mHRLtfM7X8T+dHmH0a4gOP6YGiDO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

Replace the per-page IOTLB invalidation loop with stride-based
invalidation that uses the level bitmaps from iommu_iotlb_gather.

Pre-calculate the invalidation information before running over the
bonds loop as it is the same for every entry.

The lowest set bit in the PT_FEAT_DETAILED_GATHER bitmaps indicates
the stride. This design ignores the SVNAPOT contiguous pages on the
assumption that they still have to be individually invalidated like
ARM requires, though it is not clear from the spec.

Replace the 2M cutoff for global invalidation with a 512 command
limit. This is the same for a 4k stride and now scales with the
stride size.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 103 +++++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 556d5dc9c58681..fd9c5294dbc082 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -920,22 +920,58 @@ static void riscv_iommu_bond_unlink(struct riscv_iommu_domain *domain,
 	}
 }
 
-/*
- * Send IOTLB.INVAL for whole address space for ranges larger than 2MB.
- * This limit will be replaced with range invalidations, if supported by
- * the hardware, when RISC-V IOMMU architecture specification update for
- * range invalidations update will be available.
- */
-#define RISCV_IOMMU_IOTLB_INVAL_LIMIT	(2 << 20)
+struct riscv_iommu_tlbi {
+	u64 start;
+	u64 last;
+	bool non_leaf;
+	struct {
+		bool use_global;
+		u8 stride_lg2;
+		unsigned int num;
+	} single;
+};
 
-static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
-				    struct iommu_iotlb_gather *gather)
+static void riscv_iommu_tlbi_calc(struct riscv_iommu_tlbi *tlbi,
+				  struct iommu_iotlb_gather *gather)
+{
+	u8 combined = gather->pt.leaf_levels_bitmap |
+		      gather->pt.table_levels_bitmap;
+	u64 num;
+
+	tlbi->non_leaf = gather->pt.table_levels_bitmap != 0;
+	tlbi->start = gather->start;
+	tlbi->last = gather->end;
+
+	/* No level information available */
+	if (!combined) {
+		tlbi->single.use_global = true;
+		return;
+	}
+
+	/*
+	 * Calculate stride from the lowest changed level. RISC-V uses 4KiB
+	 * granule with 9 bits per level.
+	 */
+	tlbi->single.stride_lg2 = 9 * __ffs(combined) + 12;
+	num = (tlbi->last - tlbi->start + 1) >> tlbi->single.stride_lg2;
+	if (!num || num > 512) {
+		tlbi->single.use_global = true;
+	} else {
+		tlbi->single.num = num;
+		tlbi->single.use_global = false;
+	}
+}
+
+static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
+					  int pscid,
+					  struct riscv_iommu_tlbi *tlbi)
 {
-	unsigned long start;
-	unsigned long end;
-	struct riscv_iommu_bond *bond;
-	struct riscv_iommu_device *iommu, *prev;
 	struct riscv_iommu_command cmd;
+	unsigned long iova;
+	unsigned int i;
+
+	riscv_iommu_cmd_inval_vma(&cmd);
+	riscv_iommu_cmd_inval_set_pscid(&cmd, pscid);
 
 	/*
 	 * When non-leaf page table entries were changed, the base spec
@@ -943,13 +979,28 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 	 * way to do targeted non-leaf invalidation without the NL
 	 * extension. Force global invalidation to preserve correctness.
 	 */
-	if (gather->pt.table_levels_bitmap) {
-		start = 0;
-		end = ULONG_MAX;
-	} else {
-		start = gather->start;
-		end = gather->end;
+	if (tlbi->single.use_global || tlbi->non_leaf)
+		goto global;
+
+	iova = tlbi->start;
+	for (i = 0; i < tlbi->single.num; i++) {
+		riscv_iommu_cmd_inval_set_addr(&cmd, iova);
+		riscv_iommu_cmd_send(iommu, &cmd);
+		iova += 1ULL << tlbi->single.stride_lg2;
 	}
+	return;
+global:
+	riscv_iommu_cmd_send(iommu, &cmd);
+}
+
+static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
+				    struct iommu_iotlb_gather *gather)
+{
+	struct riscv_iommu_device *iommu, *prev;
+	struct riscv_iommu_bond *bond;
+	struct riscv_iommu_tlbi tlbi;
+
+	riscv_iommu_tlbi_calc(&tlbi, gather);
 
 	/*
 	 * For each IOMMU linked with this protection domain (via bonds->dev),
@@ -990,19 +1041,7 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 		if (iommu == prev)
 			continue;
 
-		riscv_iommu_cmd_inval_vma(&cmd);
-		riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
-		if (end - start < RISCV_IOMMU_IOTLB_INVAL_LIMIT - 1) {
-			unsigned long iova = start;
-
-			do {
-				riscv_iommu_cmd_inval_set_addr(&cmd, iova);
-				riscv_iommu_cmd_send(iommu, &cmd);
-			} while (!check_add_overflow(iova, PAGE_SIZE, &iova) &&
-				 iova < end);
-		} else {
-			riscv_iommu_cmd_send(iommu, &cmd);
-		}
+		riscv_iommu_iotlb_inval_iommu(iommu, domain->pscid, &tlbi);
 		prev = iommu;
 	}
 
-- 
2.43.0

