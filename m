Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AC51E1E12;
	Thu, 14 Aug 2025 01:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134797; cv=fail; b=XSK1R6nCHe0EOjfk/FZhovt689O6gPq9lUWKS7cRBHURE6KseWR4OrRRufCdmoVICfcl5yVyOYvyn3+ihrZZ6rxf4jqGTdthfBdshLkdKaBC1q1NDbFDOAsf7V7LRcTmbptN9oggMPgNjviYsnXDC6BUlLBFVF7mEihMRd3Jvso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134797; c=relaxed/simple;
	bh=YO2iAHObku2jzCZuK7wxk6nK98fCCt7xO6P4tp4aPG4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DG0oaGDeNyWsjyjol67aqdN/WgCHwPbagdbdRvq5pvq2K52sTD3CkCvR2iaBOC8J+J87TnhomYGurrsQCknlAHd9VdvMSbFcC0zVunuFv0bDlIfg3QWCsM8wmNOeN20BjhjKdoJJKPvsarclrJoQAmzWMsWsB/b6jAxLz/NMkqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sGY9M5Aw; arc=fail smtp.client-ip=40.107.102.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sGY9M5Aw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYh5OgYkgB9wiqd+8a+WaXlvQSgsFjuTon735NOOMjKexBDKTj0relkklN47nG7sCWcorndBNXtPhAw/v/du07wYYZF9FIDVj5dMV43W/hmm4O8dl+6R/8rGI6rO2bAhlsL+rMQoqTnnOIKLqM1GswVf4EzqU5Hw2A4t8uSUWVVH3xIUIOhJk7qzLzPggv3IDdg7cpqddFxBriQtt6CV+1ywDSRSaUf+TtbyeHNfHVUAL+mfmTaTini0JuFbZpHEunNt79RSrGsFHN+qqntq8wyDLgFbQmRy6c1lKbiKCkfGgLWMz0S2VLUHwZsoT/D+YBzU6Yc70KLLvbkY6COJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuulPnsBVTp/JuY0yLnOEEusgqIj2mp8ETgz6UjsfUE=;
 b=VcxxdGE2vOKo6zCxtb7dhoqD400DXThOpAanWihsj1tkMr91iQ0Osk646WeJG9SMCqmXmyquxBx+5vAFyt7MZdLAAdXl0DRKHXVahapWajB/zTCKhmsP9Nt/IEuRLgu1tWSpyhSH6lQ3Yu4gKQBFYWJWdWfy6EmYPnNPMsREX3o8KUkLl2n5njnQc3bxPSKrJ5esIoQ+F+YP4RPAx/DDTOF/5Q491hVzjWxrjdCleWHcj+fMdObNa1s2qdPSp2iUtgF8AvW+zjQDDzLf/OLW217X2UBxoSCbipBCDok0RbvHckiawaQ8Mm4bHPnrN/ZM/23MEDsqjpelQIYhf7VHiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuulPnsBVTp/JuY0yLnOEEusgqIj2mp8ETgz6UjsfUE=;
 b=sGY9M5AwDyiJLzeWinzMyaiUF94eRyOCSNyFBvHDrFcBdPymSprqirBsx/kPOyays53e16e8B6yqkyhXnfQ69dd9rjVzrkjmmZRI8si5l8G2i8SdpPXs2mlElRQpaN3vOK4/L/mbuWpUVd8Ygz4fkwTe4CQG4GT28916Hv9xQDQmTpId+b77EqgDUPM6DpawaMlKDkjl4gttKTi2dndBc1EgaKZdQONg786a6/dKCGicgFz3MfzuY5owk/FWX92WqQFaKkyknmTtcJw2wlzR3U2n/CFNnkCbM7CHlqjB1y4yARzA+l0R2I+ZZwDlLNIhLLtF2XgR917MFBkRlaDFeA==
Received: from SJ0PR13CA0217.namprd13.prod.outlook.com (2603:10b6:a03:2c1::12)
 by LV3PR12MB9165.namprd12.prod.outlook.com (2603:10b6:408:19f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 01:26:27 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::83) by SJ0PR13CA0217.outlook.office365.com
 (2603:10b6:a03:2c1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.15 via Frontend Transport; Thu,
 14 Aug 2025 01:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:11 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:10 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:09 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based arm_smmu_domain_inv_range()
Date: Wed, 13 Aug 2025 18:25:38 -0700
Message-ID: <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1755131672.git.nicolinc@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|LV3PR12MB9165:EE_
X-MS-Office365-Filtering-Correlation-Id: 1364b41d-bacf-497f-3794-08dddad1972a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6CynS+78chb6OeEf5C5MGr32AcnxiEP9zbUfVxsr/Yf8/ai8uZYJSe2dIo1J?=
 =?us-ascii?Q?7pbjr+YzbwEHrWxNqUaTCiiejWppA7gUYvd98hwAmu/xWN/2c9O+lXJZQRFB?=
 =?us-ascii?Q?lzJEQuMmbNrvjLL/apNEcnQR+FFFIac8ePad1CsLFB74+smaXU3+oE6ovyGG?=
 =?us-ascii?Q?lFO2qfxhSTb/txwICnQnzjPhlTNaD5trtvq4ETYDAzkqM6+LLg7UJNpfIHm0?=
 =?us-ascii?Q?7lJl0nZJClVacOEhhInIEebBnCUGpa7IfhQjnHg2AfpLpV3+nT4CtS65x9JL?=
 =?us-ascii?Q?Xwd/v61mqwjS958hYTPTV7f2ZTx3D5Cx7ksrAd9zARayrqKTlKN2irpaXOT6?=
 =?us-ascii?Q?+tX3E35cnCDoC5qZpyeNLXVw0Ha5cY64To6xocfoRl4hgpMadhG6Vi/d72lJ?=
 =?us-ascii?Q?tGCnID3GKvYT1aK0w93EIjHf0MYAyl27kC4fqFJspdKLga6hxqMfGuerOMYV?=
 =?us-ascii?Q?3QN2nUZd5Kbvn5q0BQfPx/MeMhFbYuUFnHP817C0Ka+DPxBJlaFERWnnyPKh?=
 =?us-ascii?Q?eYWcm1qGnCy2xKCmvLgB9fzp+n59iG10U6wW9jU94a5cNJV6qRVimwWecyRH?=
 =?us-ascii?Q?pvJQ2KPPTh374/Wet4qPzd59PgQGHKdReLq8hGF28+AQUCsdTi+KUKxVo05u?=
 =?us-ascii?Q?L9q/RQGda4xbuFOW90Qyykwmf0Qb38FOJMDwAIWO/LWb3OGcYK8vgx9P7lFs?=
 =?us-ascii?Q?mA6mKzQqoa868FNxI22eAmuVhstU8PRnSKcKxdz1swxr1A8EIlSordrmS7GO?=
 =?us-ascii?Q?e4ZD0eBTG4AbXCs6nBALKpgjlZaxLNmu2gIBIqjSCc6E66ClsuFglV+aNlz9?=
 =?us-ascii?Q?er73hgH9RicayvNJR+UpSPORbV5SrVUq+miR4LSfMST4nqen+rCCv+QWDKv8?=
 =?us-ascii?Q?4E3SiUnYNv8cSe1mwxDZwG6+S1CEiXwlGJH56/QyAlbZ9kGI/1dLw0DiGwYt?=
 =?us-ascii?Q?5eWubbaRl9nOvXzEhbF0+pLsb+ELZU9INYG9CFsdJd7nQuqxtFuCS45TXWIv?=
 =?us-ascii?Q?vXLKonRqcievv0BvJMyouEC8m++F9lK4okYkEV+nDdH+fDjNEGaukF60LB0y?=
 =?us-ascii?Q?DVhqQFDoTVjQtx6qMrOEVTa9QrQGVZhMJ31F+zUzgvjw3j9IprbyGwzh2VJ+?=
 =?us-ascii?Q?o1SyVyA5FDUXuJdXnJ68q6VbdmBY0VZHkmKnUDwnHUnHQh6wU5EmAGPAk3ep?=
 =?us-ascii?Q?B0UIIlLBcdsELHRYXzhOz2yw6g718FMmGJaBv4aK0fbmxcH8Ps0uHZlCaa6v?=
 =?us-ascii?Q?0pthNCnzH43C1n2o8tNCPo7aCQVu1aMQoZYSjH8b07jGN3GIOjUqnG40ltYL?=
 =?us-ascii?Q?yhFPYSCDVAMPtdJIPCt+W4YROXoZxnZor4weGJvfvNKDkO/08KCMSAcHuNtm?=
 =?us-ascii?Q?GoMqjOKvlyx+VttmO4wUoz2Z7orQMd4XdM7QKEZt+BpQBqrqEOJzlS52efWr?=
 =?us-ascii?Q?GisRtMiTZVs570DHo7/yhfVHYGDUQvHGGemRT9rAj7SGZ41jLPqkQYkcBfPX?=
 =?us-ascii?Q?+rQ0ZSppsmSIbbCoiSZCVlKzbRv6KHqkeqL0sQaN/SkFMq24wAsr+G1iXyR/?=
 =?us-ascii?Q?y2CqiATsygT3Dqjawiw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:27.4283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1364b41d-bacf-497f-3794-08dddad1972a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9165

Now, each smmu_domain is built with an invs array that keeps all the IDs
(asid/vmid) and its attached device SIDs, following the exact pattern of
all the existing invalidation functions.

Introduce a new arm_smmu_domain_inv helper iterating smmu_domain->invs,
to convert the invalidation array to commands. Any invalidation request
with no size specified means an entire flush over a range based one.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   9 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 215 ++++++++++++++++++--
 2 files changed, 211 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 715179249eced..69271beb54527 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1060,6 +1060,15 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 			    unsigned long iova, size_t size);
 
+void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
+			       unsigned long iova, size_t size,
+			       unsigned int granule, bool leaf);
+
+static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
+{
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+}
+
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
 			      struct arm_smmu_cmdq *cmdq);
 int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 95615525b0ab8..aa770275029e2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2530,23 +2530,19 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
-static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
-				     unsigned long iova, size_t size,
-				     size_t granule,
-				     struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+					  struct arm_smmu_cmdq_batch *cmds,
+					  struct arm_smmu_cmdq_ent *cmd,
+					  unsigned long iova, size_t size,
+					  size_t granule, size_t pgsize)
 {
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	unsigned long end = iova + size, num_pages = 0, tg = 0;
+	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
 	size_t inv_range = granule;
-	struct arm_smmu_cmdq_batch cmds;
 
 	if (!size)
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		/* Get the leaf page size */
-		tg = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 		num_pages = size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
@@ -2566,8 +2562,6 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 			num_pages++;
 	}
 
-	arm_smmu_cmdq_batch_init(smmu, &cmds, cmd);
-
 	while (iova < end) {
 		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
 			/*
@@ -2595,9 +2589,26 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 		}
 
 		cmd->tlbi.addr = iova;
-		arm_smmu_cmdq_batch_add(smmu, &cmds, cmd);
+		arm_smmu_cmdq_batch_add(smmu, cmds, cmd);
 		iova += inv_range;
 	}
+}
+
+static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
+				     unsigned long iova, size_t size,
+				     size_t granule,
+				     struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_batch cmds;
+	size_t pgsize;
+
+	/* Get the leaf page size */
+	pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
+
+	arm_smmu_cmdq_batch_init(smmu, &cmds, cmd);
+	arm_smmu_cmdq_batch_add_range(smmu, &cmds, cmd, iova, size, granule,
+				      pgsize);
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
@@ -2653,6 +2664,184 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 }
 
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
+				      size_t granule)
+{
+	size_t max_tlbi_ops;
+
+	/* 0 size means invalidate all */
+	if (!size || size == SIZE_MAX)
+		return true;
+
+	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+		return false;
+
+	/*
+	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
+	 * this is used as a threshold to replace "size_opcode" commands with a
+	 * single "nsize_opcode" command, when SMMU doesn't implement the range
+	 * invalidation feature, where there can be too many per-granule TLBIs,
+	 * resulting in a soft lockup.
+	 */
+	max_tlbi_ops = 1 << (ilog2(granule) - 3);
+	return size >= max_tlbi_ops * granule;
+}
+
+/* Used by non INV_TYPE_ATS* invalidations */
+static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+				       struct arm_smmu_cmdq_batch *cmds,
+				       struct arm_smmu_cmdq_ent *cmd,
+				       unsigned long iova, size_t size,
+				       unsigned int granule)
+{
+	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
+		cmd->opcode = inv->nsize_opcode;
+		/* nsize_opcode always needs a sync, no batching */
+		arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, cmd);
+		return;
+	}
+
+	cmd->opcode = inv->size_opcode;
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, iova, size, granule,
+				      inv->pgsize);
+}
+
+static bool arm_smmu_invs_end_batch(struct arm_smmu_invs *invs, size_t idx)
+{
+	struct arm_smmu_inv *cur = &invs->inv[idx];
+	struct arm_smmu_inv *next;
+
+	/* Last array entry ends */
+	if (idx + 1 == invs->num_invs)
+		return true;
+
+	next = &cur[1];
+	/* Changing smmu means changing command queue */
+	if (cur->smmu != next->smmu)
+		return true;
+	/* The batch for S2 TLBI must be done before nested S1 ASIDs */
+	if (next->type == INV_TYPE_S2_VMID_S1_CLEAR)
+		return true;
+	/* ATS must be after a sync of the S1/S2 invalidations */
+	if (cur->type != INV_TYPE_ATS && cur->type != INV_TYPE_ATS_FULL &&
+	    (next->type == INV_TYPE_ATS || next->type == INV_TYPE_ATS_FULL))
+		return true;
+	return false;
+}
+
+void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
+			       unsigned long iova, size_t size,
+			       unsigned int granule, bool leaf)
+{
+	struct arm_smmu_cmdq_batch cmds = {};
+	struct arm_smmu_invs *invs;
+	bool retried = false;
+	size_t i;
+
+	/*
+	 * An invalidation request must follow some IOPTE change and then load
+	 * the invalidation array In the meantime, a domain attachment mutates
+	 * the array and then stores an STE/CD asking SMMU HW to acquire those
+	 * changed IOPTEs. In other word, these two are interdependent and can
+	 * race.
+	 *
+	 * In a race, the RCU design (with its underlying memory barriers) can
+	 * ensure the invalidations array to always get updated before loaded.
+	 *
+	 * smp_mb() is used here, paired with the smp_mb() following the array
+	 * update in a concurrent attach, to ensure:
+	 *  - HW sees the new IOPTEs if it walks after STE installation
+	 *  - Invalidation thread sees the updated array with the new ASID.
+	 *
+	 *  [CPU0]                        | [CPU1]
+	 *                                |
+	 *  change IOPTEs and TLB flush:  |
+	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs {
+	 *    ...                         |   rcu_assign_pointer(new_invs);
+	 *    smp_mb(); // ensure IOPTEs  |   smp_mb(); // ensure new_invs
+	 *    ...                         |   kfree_rcu(old_invs, rcu);
+	 *    // load invalidation array  | }
+	 *    invs = rcu_dereference();   | arm_smmu_install_ste_for_dev {
+	 *                                |   STE = TTB0 // read new IOPTEs
+	 */
+	smp_mb();
+
+	rcu_read_lock();
+again:
+	invs = rcu_dereference(smmu_domain->invs);
+
+	/* A concurrent attachment might have changed the array. Do a respin */
+	if (unlikely(!read_trylock(&invs->rwlock)))
+		goto again;
+	/* Only one retry. Otherwise, it would soft lockup on an empty array */
+	if (!retried && unlikely(!invs->num_invs)) {
+		read_unlock(&invs->rwlock);
+		retried = true;
+		goto again;
+	}
+
+	for (i = 0; i < invs->num_invs; i++) {
+		struct arm_smmu_inv *cur = &invs->inv[i];
+		struct arm_smmu_device *smmu = cur->smmu;
+		struct arm_smmu_cmdq_ent cmd = {
+			/*
+			 * Pick size_opcode to run arm_smmu_get_cmdq(). This can
+			 * be changed to nsize_opcode, which would result in the
+			 * same CMDQ pointer.
+			 */
+			.opcode = cur->size_opcode,
+		};
+
+		/* Do not throw any trash to the command queue */
+		if (refcount_read(&cur->users) == 0)
+			continue;
+
+		if (!cmds.num)
+			arm_smmu_cmdq_batch_init(smmu, &cmds, &cmd);
+
+		switch (cur->type) {
+		case INV_TYPE_S1_ASID:
+			cmd.tlbi.asid = cur->id;
+			cmd.tlbi.leaf = leaf;
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, iova, size,
+						   granule);
+			break;
+		case INV_TYPE_S2_VMID:
+			cmd.tlbi.vmid = cur->id;
+			cmd.tlbi.leaf = leaf;
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, iova, size,
+						   granule);
+			break;
+		case INV_TYPE_S2_VMID_S1_CLEAR:
+			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
+			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+				continue;
+			/* Just a single CMDQ_OP_TLBI_NH_ALL, no batching */
+			cmd.tlbi.vmid = cur->id;
+			arm_smmu_cmdq_issue_cmd_with_sync(cur->smmu, &cmd);
+			continue;
+		case INV_TYPE_ATS:
+			arm_smmu_atc_inv_to_cmd(cur->ssid, iova, size, &cmd);
+			cmd.atc.sid = cur->id;
+			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			break;
+		case INV_TYPE_ATS_FULL:
+			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+			cmd.atc.sid = cur->id;
+			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
+		if (cmds.num && arm_smmu_invs_end_batch(invs, i))
+			arm_smmu_cmdq_batch_submit(smmu, &cmds);
+	}
+	read_unlock(&invs->rwlock);
+	rcu_read_unlock();
+}
+
 static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 					 unsigned long iova, size_t granule,
 					 void *cookie)
-- 
2.43.0

