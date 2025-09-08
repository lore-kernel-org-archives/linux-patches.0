Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885F313263;
	Mon,  8 Sep 2025 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374149; cv=fail; b=Xk2evNW5T3ZzMcqDDPTkhXUGhzK9nqeYWsREXVjn4UCQVrZc9mQvjZ9iaaBsHwxlyZGXgRjtQq8SJ1IVkNhR224KeW6/MY8qUVZLSwUPqIIu13ZVD9A8X16v7aCi6chBfFTJME5mvzCrDFKrP8LQFf4hl/ixcvk1y9J6b8kRNTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374149; c=relaxed/simple;
	bh=8ulN/RD/NgCfaIZM/UoNy0H2/sSNrMVCN0j/ERD99RY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBuHFr/nyZLZym0TVe1ZjUc76C8/PBtpPyIJlS89x5iprK+0aEzW/C33m+za/RyYrp3a0yHiUxWosa2fzdE6lnbGM26x85P8OVSb7HOUQlQc7MTAKdhDg/6aB8jYPf/ShegrWnpHQRivTP2olauG/wFvxMlShVUqcDtofsRJoq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Yy/9dmuv; arc=fail smtp.client-ip=40.107.95.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yy/9dmuv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=khZmuACRhSPO9yekR5xzVW+lWuXpB/sGuX/ngmLZL6uNEd6jhMGrESFB0Cfa9nRoFSxRr5VWpvam9IJviPttuvncwbdnQRnkdxmVcFmY0xUznghpnbjeYsc1654O92zKTBeD55Tosh5fhcawNfRU49F6zN3/8Ce9SKzX0yPDYPZismtcFSoAgSC8hGN4+3xbj6Xl84fm0UQYjGYiHYbom+B1DlBGruKPp2dit798RqzaPpBdbKL1Atn9CQaCoNSQVzjCprtPneSdfaeaOSQdKNfPe2HAG/+URxnGCvrOzX73eid6Wg1TMA1hGUJsUpH9omfk557n+BSykL94wRUeMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tohmmI2OKQEzBeBN7bVIdF9c11hW/UH540QqCU22Duo=;
 b=qLGIi9GK+PnrGzUFuxPnXi3xlzqdFKtNbpXIbHyGwqLCuMIFE5I+M9ENc+w1a8xijuqXUKfY0WReE5cpNtEHCpsyxWG9eIMKbUf1JoNlEpnkkLlhhl/prcSJ9JUMOOUEql9+QDpp3OESq4ChnVB65cExj42aWfh3M/XMoP9mUDzYOlXP3A7LADXCzRW2UAcwtLRUZxjvMiGqOcY+Dnr/1rIs8zvYcbnzdRf6949/jVkxDDbSVmK/mOxScOw0WS59zUEubfFiGqjhteOK1+Iu6dLcEQZ1YAOmf84DfDen2zlHj5Kg7I1yFsA3o/ce56HE9WWwTXR299f74MePqWjiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tohmmI2OKQEzBeBN7bVIdF9c11hW/UH540QqCU22Duo=;
 b=Yy/9dmuvmy6Dhk5eRPM24udVFRpsj8NmgrXoujTMi/hv9Mw4Ec2fKzubWLanoF6JxvMyLUT7kHvRjHNyhF/rwYu4xgmdVFg+2+yI3HCD78O8rpdeYt78qRj1CfZ5ElrwrkB8jKQnPzdBiIerYnDtmrwZKpsPpPcspLUlzVJEZdjNZEVrhhARQGUa0W1EH3hPV/v0mwpr6Q/ORWnL9geWe8LRp/tnKRrGNlT7L2D3vXKjCQLZiUhYxJb1adA0pKFMgAcPxUwio7BZcQBNMJXrF8Dm0R6twtIcGjZTaFsCNH1IEdZUlcWcshO+m4GtImeP/LDtToRw3ehT5oiTZ2a9Pg==
Received: from CY5PR15CA0243.namprd15.prod.outlook.com (2603:10b6:930:66::14)
 by DS7PR12MB6072.namprd12.prod.outlook.com (2603:10b6:8:9c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:28:59 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:930:66:cafe::9f) by CY5PR15CA0243.outlook.office365.com
 (2603:10b6:930:66::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 23:28:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:45 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:45 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based arm_smmu_domain_inv_range()
Date: Mon, 8 Sep 2025 16:27:01 -0700
Message-ID: <9ac8acbd289fa32378498f09f78e7924d3523200.1757373449.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1757373449.git.nicolinc@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|DS7PR12MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 05395b6d-d05a-4b9d-05f5-08ddef2f7cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wk2C+LR7AwO2w0BxmLx8HHjbT82NVaUPOpLh/lwTSbosIGwPnFBLHBfcOHvr?=
 =?us-ascii?Q?5YcgH6VQX7YfyDElSh9WUCew30+I3hKdvOiusMCy2oRKZ02yjMOUyTuEl919?=
 =?us-ascii?Q?mZ7JP6ktcKnCSp5jWWL7RHFsXOLJxK/Q6Tb9TEU+76gNO4w3f/V5wol3oN4V?=
 =?us-ascii?Q?QMdny01zjvni8mmZQjv851tmmUPmBUsmVpJs+JJVfO3O3dJiuAGg6I+JUCfS?=
 =?us-ascii?Q?Pwza9pkLKa7Tj3mJuXKPeMlmEEBHKEzzQDOafjIetwwazyVdejTDw3w4W9i8?=
 =?us-ascii?Q?AsRr4GADYxrzSNLlbbQyqTDSx4gbWioaSXQHi4frG2Dwl5XCMCMDBsNiDIPF?=
 =?us-ascii?Q?efvHKRG6mdyuRmXnDfCf14O0I1OVUfL8pTyMwkXuqxU8HHqcnkb16Rt7TaUx?=
 =?us-ascii?Q?vQm45gLW0LsoKI/mGqw47ynM5GH/t43ApGc8U0lB6tODexcW+loShQh6K3zm?=
 =?us-ascii?Q?CJ7/J7XfNVuJGqvCKtihpnXXUiL8K3y1wKC9UtaCsVoQZ4Pfi4iB+EGN88Zf?=
 =?us-ascii?Q?WCCtfTr6zfFHz5lSmAyCJT2kiv68huBG9g8qA6sZ5w72Xbzz8/EYmrrwyLgp?=
 =?us-ascii?Q?OorQsl1mNdj2ko/MU1OZDRo5+JXdA9bWYLZaQNmSvp12g8GAYQ/760JxdI3u?=
 =?us-ascii?Q?NL5eh7WKiMbtppMHw18M2fzt3s0NsSCbqCbVpmGjfQlI+qpVVICnIISawNkj?=
 =?us-ascii?Q?Zns4mEUnO4sfIQyVfz61ukp6dA3Y88EMceZZr8/FWmt0kul5lQ3FpvNyksMC?=
 =?us-ascii?Q?fcCG79J+xH2md+WP198l5CR2fDtGnuZn0qkMgrox+Ki9/FE6UwTyd677Evyd?=
 =?us-ascii?Q?5eynWby5m/3aTdkJx5TFPlXeVcesMLyu+C0jaI8fVqmMIALeWH2YLCT5v48w?=
 =?us-ascii?Q?4pnDlYtvpHxgpLOIbW770WDAPU08YjlY7cVLz4JZDfoCOnjG9MZ5KDR7s0hn?=
 =?us-ascii?Q?AfZadr+SDGM0vqOPggd1UZ1OMiedqNv0kODG6retQeHMKPQPZ3sO6gBhRHrp?=
 =?us-ascii?Q?md2MkxtQg7Gu+mK4zJgi9G3h5+qQwpdelP0anpkjEzP6JYh2pC3+XdPta2/0?=
 =?us-ascii?Q?nbLyQKP6r8v8x7x6SC5p5gFwK3F9y/y51dryaNcAg/HYh3glIeHWYvO2BVFs?=
 =?us-ascii?Q?bZPB6lOdpLQlbAMaZ5bO21jf3DEVNtMjB26RrlEofhMgarn7AUIvjb3CFzXh?=
 =?us-ascii?Q?sUEh6xMFAWgg4NFGj1AOOepyE/ahQ7tZKzK8+j0nO/jo4ZVc/22M6D6aLGFL?=
 =?us-ascii?Q?Tgp3AiMbkw77xoMfxiqalJX1Vob1DfftPbcDHVmkkOJIYHgvNSr8YrE4hwyb?=
 =?us-ascii?Q?gETJuVaSN9JswvRfNcHvrhlMf1eco849vFcb+1louY+/QuzW7lQmBj/7L3Aa?=
 =?us-ascii?Q?JkssxwaxeY6dvvvCWtR534uUfpJ0NO/vZb3HiUKC+ezpX401YGsn9PJ7Xcd2?=
 =?us-ascii?Q?aTkQ0vfJvP+KQ24vNGotEnvO1N8ZVzVK1U92sw16mOzoxlMgW2mSXvelR0VO?=
 =?us-ascii?Q?qFBbySol45ONZRCanRa8ZHtgohk7mexQ8vSP1SfNHM9MbxKN0lXSb3J7D8Gv?=
 =?us-ascii?Q?+oIFWHaG/H30tWaR3m8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:59.1436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05395b6d-d05a-4b9d-05f5-08ddef2f7cc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6072

Now, each smmu_domain is built with an invs array that keeps all the IDs
(ASID/VMID) and its attached device SIDs, following the exact pattern of
all the existing invalidation functions.

Introduce a new arm_smmu_domain_inv helper iterating smmu_domain->invs,
to convert the invalidation array to commands. Any invalidation request
with no size specified means an entire flush over a range based one.

ATC invalidations must be in sync with an attachment, espeically when it
is an IOMMU_DOMAIN_BLOCKED that is used by the core for a device reset.
Add a has_ats flag in the invs structure and hold the read lock if it is
set, in which way a concurrent attachment will be blocked until any ATC
invalidation being sent to the in the command queue is finished.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  16 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 225 ++++++++++++++++++--
 2 files changed, 228 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e4e0e066108cc..c73a94514c6d6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -675,9 +675,15 @@ struct arm_smmu_inv {
 	refcount_t users; /* users=0 to mark as a trash to be purged */
 };
 
+static inline bool arm_smmu_inv_is_ats(struct arm_smmu_inv *inv)
+{
+	return inv->type == INV_TYPE_ATS || inv->type == INV_TYPE_ATS_FULL;
+}
+
 /**
  * struct arm_smmu_invs - Per-domain invalidation array
  * @num_invs: number of invalidations in the flexible array
+ * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
  * @old: flag to synchronize with reader
  * @rwlock: optional rwlock to fench ATS operations
  * @rcu: rcu head for kfree_rcu()
@@ -706,6 +712,7 @@ struct arm_smmu_inv {
 struct arm_smmu_invs {
 	size_t num_invs;
 	rwlock_t rwlock;
+	u8 has_ats;
 	u8 old;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[];
@@ -1072,6 +1079,15 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
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
index ee779df1d78fb..c06d2dd893c11 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2479,23 +2479,19 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
@@ -2515,8 +2511,6 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 			num_pages++;
 	}
 
-	arm_smmu_cmdq_batch_init(smmu, &cmds, cmd);
-
 	while (iova < end) {
 		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
 			/*
@@ -2544,9 +2538,26 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
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
 
@@ -2602,6 +2613,194 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
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
+static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
+					   struct arm_smmu_inv *next)
+{
+	/* Changing smmu means changing command queue */
+	if (cur->smmu != next->smmu)
+		return true;
+	/* The batch for S2 TLBI must be done before nested S1 ASIDs */
+	if (cur->type != INV_TYPE_S2_VMID_S1_CLEAR &&
+	    next->type == INV_TYPE_S2_VMID_S1_CLEAR)
+		return true;
+	/* ATS must be after a sync of the S1/S2 invalidations */
+	if (!arm_smmu_inv_is_ats(cur) && arm_smmu_inv_is_ats(next))
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
+	struct arm_smmu_inv *cur;
+	struct arm_smmu_inv *end;
+	bool locked;
+
+	/*
+	 * An invalidation request must follow some IOPTE change and then load
+	 * an invalidation array. In the meantime, a domain attachment mutates
+	 * the array and then stores an STE/CD asking SMMU HW to acquire those
+	 * changed IOPTEs. In other word, these two are interdependent and can
+	 * race.
+	 *
+	 * In a race, the RCU design (with its underlying memory barriers) can
+	 * ensure the invalidation array to always get updated before loaded.
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
+
+	while (true) {
+		invs = rcu_dereference(smmu_domain->invs);
+
+		/*
+		 * Avoid locking unless ATS is being used. No ATS invalidate can
+		 * be going on after a domain is detached.
+		 */
+		locked = false;
+		if (invs->has_ats || READ_ONCE(invs->old)) {
+			read_lock(&invs->rwlock);
+			if (invs->old) {
+				read_unlock(&invs->rwlock);
+				continue;
+			}
+			locked = true;
+		}
+		break;
+	}
+
+	cur = invs->inv;
+	end = cur + READ_ONCE(invs->num_invs);
+	/* Skip any leading entry marked as a trash */
+	for (; cur != end; cur++)
+		if (refcount_read(&cur->users))
+			break;
+	while (cur != end) {
+		struct arm_smmu_device *smmu = cur->smmu;
+		struct arm_smmu_cmdq_ent cmd = {
+			/*
+			 * Pick size_opcode to run arm_smmu_get_cmdq(). This can
+			 * be changed to nsize_opcode, which would result in the
+			 * same CMDQ pointer.
+			 */
+			.opcode = cur->size_opcode,
+		};
+		struct arm_smmu_inv *next;
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
+			cmd.tlbi.vmid = cur->id;
+			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			break;
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
+		/* Skip any trash entry in-between */
+		for (next = cur + 1; next != end; next++)
+			if (refcount_read(&next->users))
+				break;
+
+		if (cmds.num &&
+		    (next == end || arm_smmu_invs_end_batch(cur, next)))
+			arm_smmu_cmdq_batch_submit(smmu, &cmds);
+		cur = next;
+	}
+	if (locked)
+		read_unlock(&invs->rwlock);
+	rcu_read_unlock();
+}
+
 static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 					 unsigned long iova, size_t granule,
 					 void *cookie)
-- 
2.43.0

