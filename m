Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C33F54AE;
	Fri,  8 May 2026 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251996; cv=fail; b=JdhoZWfAaAWLW7F9/mFDWvgChnl9ZFk8GHRXijUi+/f+PefSLBscPK4FtOU5Mq2JM7BryMzL0fDN5NSOf1NzActxGQaWz8FKMQFmbQaJyoCCVrdihjfaZ+OVhA6hNvQkXxEVIgxTeIMXGtF2Flai52x4xL7XBfmEXTwnLc6YO38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251996; c=relaxed/simple;
	bh=ZZlDlxFi8RtH2xOWVUtBjCk4aSZJN5FbzxHlCbSGMqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O8yfUp8nsz0xBlO92b3I/sDqyArJ7F8dJw8p1XVoM5wCcn4c/QGEejydvAN8G7UB/EzM+qZ2BEP+jTp0uYn0MFE7fvDDCqx2DPZvXyBXqeiD7vLtErvqVNxT3RWCszzLuy3NHA5ezCTLfGCeMyDgufOAYcyX3q85ommIsaNzrgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KURYsnZu; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KURYsnZu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TH3mCBMrdK9YmupPhol1be63FbqzqHPuQPze29+u8nfbOCp0egnJS/BLrrgmA5oyBYPhjJWBeB//CtbL38kz6bWhXmw+7wozoyUPacG9ODThYpPRP/ZBZAqdDM99u18ymSrqj+VYz6vBwAS3BaX7ujAF2f/r+ivbdR84aXBd2fK4+6piXCbrarTQJBrPiWHCATMwiUXbX4tl7j8DRfn9jvWvU87J1VQVHgsTYchm/NKXSzhckJfMJ68C+qvjX6eW1KbLARgdNDOG86aZz01vBm8+blmyL4N2LXOqBBBkj5CTCR9q+CvYt3mhNn2TKUzRXjR0VDafd7Il2HjM+lJEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJfZDOHUwM7JgAuh3hY3wKCZwYr8dUM9JLeZYtlEvG8=;
 b=BopIfwa8e5imukm6MFZcQ4ezbUbNdT7ddbzEeKu5N41VM5fRia2Lo4x0WJ6DQs81sSxdFyVbz3h/8j1mxArvHfw2clBhWudyd3D3IpZubheH4ePT0ex7DBB3qY90+fI5FzMvMUZWvXhdneAHhW19HdIWsr2TzrM510aJMW+yRSqcsBJF7FKGJYQdVwREozek5Kq8Y3m4bm8lfhtk6QOqg2sO8r34S62Fsive5CGjIyKcRbIy3l24yeATueS8QVoX7ClOdHTpf6dAKI47p8lwdbtRQDAo+G6Gwws/xU3lw80dtVtajP5F4PLMIt+FBCkDC3oDiQkV3QPQO1AXqKBkFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJfZDOHUwM7JgAuh3hY3wKCZwYr8dUM9JLeZYtlEvG8=;
 b=KURYsnZuF3ZrqR2heNfmmXOk2rWj5XTcr5CKjTguB2mWQI0kKY3S7G1oY+9RRQirWDjMA6ZRDioRUXU4Pb1YlVWT7R6C4sAC9dsWtmMovOawv03vYFRMuZfZ+OW4hV3I5UrrhKl00wv2bqaGaJ90BhLPiqvHckJVFu+dptTf9WsN0PAyOz3yLwz8O9+L6HA+0JHWQ+D7IxZLe8m3e9i9s7C0SaQta9DUhyHtLeme63w+HX1tsDiES0c5Zp96mIngYOumVfG4Wu21TsvjEyCogjifnV99IpoUpVZYAvRV1r6c+YWA5Vqb6dGhuFFtXRiH3mHAClccr1gJaBdl8G9MYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:08 +0000
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
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 5/8] iommu/riscv: Compute best stride for single invalidation
Date: Fri,  8 May 2026 11:53:04 -0300
Message-ID: <5-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:408:ea::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: fb26aacf-9d91-45a7-818a-08dead11846a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	tR54o4lZtTxyzgi5hnpw5ZBpToGMJnAoMdMuZA6DG/VeB/yFcsi/BIgGpGs4fOPjS2Guhtb3Q+2W5vgvjtEpz+Beq1PkTxiOdrD8KnKTXWbXzirtfHIXbR1ATb6bwtf2hyq49CWXSML3ICAa2DGSWHly9PPjVhmocVKpuBKuM8CgnzW6IkB40a9PO29/DcsGQT8yGWjcAKum+RJ4d+s+Wsn0fvnBUCpGN1Y9dnn//MZGUgLkwFmBD1rbWkxNdL5iLfgqDwAy8lf+2hOwhfiAGNTEIkXEG3jsePp49mOcWU1LeO4f2+R22eJXa3Hk++Pnt+Qgv8AtjUxUqzk+Q7QGzTtSX1EZlH76hpADh+A+GNCeVPotcRYdHscS0nvHirbEWq8oOjb3CNCC6b4BNVYs+xMNvTRGBKWxan4oo72DMcK3AAin/xn7L8FQBCNw+N8xQDDvGy2Oz6zEV0lHP/yXW86Te/hgyhxIkp5A+SKvrVHfKjOrOfmqs7+kmJhlfwjuP0+v5NX5eLitCrT56g86RFlXiknmK0YHZ208chuWjIv5rgKtkayL6AsOc/d1bXixHQ3BZDx0aY1BQYPUChu8TY7OjxqlGaJ3oAUb7812gj/Ma5yd4g54Cq2IFGl9iMlowgpZhCQDGW5cQgHM20xEbgh3IJDqKBpFreYcVNd+ddN3MXsUGhnpSixHhJAdsE+QVIISY1RcsakR7JuRBkON8JOCempcRpaPAUTlTksT6eeCZlkExdnnisGLlq8rqDm5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+CHp+bjSn4Ww7AcxjGlCi340KKCUNV+cnP9sjRGgWhzEPupuc5udFfuDjr5+?=
 =?us-ascii?Q?0fK2SGFNyI36/Cwx++KWlZEvv1hjb0xFESdJBdXzGYW0A+Fjh2QEWXkl24oi?=
 =?us-ascii?Q?TVxMDv8SlUfg+ggofVYrfdQtkMm3E/M3ZTkxNa0/pMzA56iuDEPBSB4V5pvX?=
 =?us-ascii?Q?75wnNWYBOkISnfQ3RI2cXMQuEx/vwtbkJ7+h8laTfek0BJd70lexJESXGfPb?=
 =?us-ascii?Q?mvFE4ZY3lY3lAfhxnpOsIY6aVfOwvlQh68UdUggPivk2c3W8Y4Oc5j0T8YND?=
 =?us-ascii?Q?/2eus0xJwM0nvhsHd6jaawx4klP+5QNidfbfF7Ga4ti1wCUKDm2XrGAD59+j?=
 =?us-ascii?Q?bLlweA4vneyZTfQeiRtoA5iRGs2fbvaiQ5CYnPwuAvtGSaoygqRtLAFTZ5R6?=
 =?us-ascii?Q?1FIFX7mQqYvKe81MhWlt65djC3rVkzO06zOCFui6fJELgQSqfJnLpvKAgcGg?=
 =?us-ascii?Q?pqQCNPHWiOxFKERtxuJmnD+AblyvyljXTGoWOcKc0n26+ztdXt0Z2nHnsbcP?=
 =?us-ascii?Q?h479vUBkroghrljoQ/scF7FLwTJo2ys3+G1tDcQDW6Cms6Fwg+qJUwPba/uu?=
 =?us-ascii?Q?OCz3M6b7GlwYoJ7OsysXKJ4kRKhMjGaYfVd8Ah2TrJcvaXB3jO1PqH5xom37?=
 =?us-ascii?Q?1nTCYrxB/fK2r/5Tr/NtRGy9+qlJnYTY/Lg673asRaRAx1lr6bJYuYy78920?=
 =?us-ascii?Q?bepZaLVhmddo7IQkgCArF0ihKi76WDXnD84+p6UK2lhvdRB2suJiU4NQhQqX?=
 =?us-ascii?Q?SXPGkA+lJT5k8aDplgT62XIsMD386HP19WKtrXtaxvQU2WwNdWWsxyQSEQmb?=
 =?us-ascii?Q?vispv4IYBzwE/USCZXXgeZCM1PdYfl8zvss2xz7D9JEk9CdDi1zu9ugaRptb?=
 =?us-ascii?Q?nhZokDOIykWZXRhNGyOoKeqtrpkt1E/qY41UMk97rmnNBmWwrq1MS5SgxXDf?=
 =?us-ascii?Q?sjUMzsfRgTesJAOKpYmd+xQGzQ+v+2oLIg0LcZ0ev9QKybFhZRqQpQR1qoSG?=
 =?us-ascii?Q?cVlhXtZABlZqa4B/io8E53i/6rmufaHzrWP3f2xPGCUrcBef0UQoFT+kl1zs?=
 =?us-ascii?Q?DpUtOLN3++5uzC49pl/aDEJWSpptz5mF4zwe9/wT6tMJGtnvh00FevnTO4vC?=
 =?us-ascii?Q?PEovKsSU1Vtldxc/E1JMQWODo5z369PScPpDmu4EpT36chmaW03fG89eZtU7?=
 =?us-ascii?Q?FBSDayiLkBihtUT7bV1ySyCrx/dT7Q4DdTWo9oKIdgWj2YQKKrFc0vrzB7kh?=
 =?us-ascii?Q?nu/vOidAlcqcCxX2Q7nojAP2bJwyLitoTEvl2arHmwoLSQjvSe3RFBSYmQTE?=
 =?us-ascii?Q?X/9418WMZ4HEdNdtuyc4SDU3wA0mbj7r+l7v+bePvHJ+uRVE4QnpkfSLUqKZ?=
 =?us-ascii?Q?lqcjQ2XDmU8f8gHWgjsstVvVhjcAHjR7rKTOeO56E4hLEVabybt1fpj97DYj?=
 =?us-ascii?Q?4AP1TsbmQro1DKGlCM+1q3W68WdeBafruAXw/2ROrdTUNOMoYvIwfXlkg7ZY?=
 =?us-ascii?Q?uwP9HvfU1Bi+HlqHVVfgzyRGRwsnPPTFQRehgXVEMwhlJMcX9s6fxDAIafts?=
 =?us-ascii?Q?nvv++FpcwfX86xSoiAVSqhfuIVJLX8XOIjDP1J2LdB3+YxF9z6WBEWaHdReu?=
 =?us-ascii?Q?pPDXghpQ+lTDKfe6O1cBVckA+0cfQUv5QEkZ1o2hFvJZnJmQQFKEecCRNeRU?=
 =?us-ascii?Q?ts2mpI+Vgguqt8Iin2KGE8vLhcUROVQhGUSrykbO9oMFF2dF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb26aacf-9d91-45a7-818a-08dead11846a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:08.2934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9SrUW8QE4C1TU7CeHyOGealLnf0LGQ2XRXS9qZC0kZhUkpw02yLXyRIfv/wD5sy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

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

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
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

