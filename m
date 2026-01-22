Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013035.outbound.protection.outlook.com [40.93.196.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC06350A08;
	Thu, 22 Jan 2026 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045116; cv=fail; b=NksNpK1lf+JoE2TnBy5DoJalgsyFlppknPjRXnhUwyxzWeFmKT+wjp0vLS7aQruOMR7sVMfcsC+kvzBM2hXNvay1r+hNDDj8lXPTGW4u17g0eSLaw3Rj8HlXkpOl3l5kFndM2L0Gp2W+Tenj8EKGt8EygNbre02+fEaUsbpg404=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045116; c=relaxed/simple;
	bh=g9oG+wS8fIKilVH7kPPV4C8NMaMhsGqJFWoOjTa1OQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lWGceXwHLOtMWbrfS5B5i14FD3IN3W7WJGhJ7Dy3DYgAxWs2uLfNU/BVDQNGsFk9r5JyowLtVrm4CHElNPTDfbYiR3j2bD1i6g9rHx/6dq/0xTl/5s6n9vhYdVPm48YX8WFJRNEVL9AzVGZ0NDy3DcGqBA60Rl+CmZyhpHn50T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jFZ1wcFD; arc=fail smtp.client-ip=40.93.196.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jFZ1wcFD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHygAyXpMBMY71atdNcvhz1XC7bKOZYUSera5Qgh5HLMJNy35KK9by499ckxhiD0axogw4qj7PGQ7Oqdc5oR2BNEgZehCH4DB5Pc37jv94YpqxH/1vP+Vc8uK/iZFe2CMClY9L1jHDZeVrST/acfPM33B4YroyQ3rrDSiZe2qI9xpIzs1jdXhVE0hk4lXTbekSZcmh5sIgJFHP1UgGZBybIB5Dsw95k2IMeYKXbT33lUVOQSdZvtDHh/Lo6G3ITS4n75oGH76PnsW1s4tmGgSjkCaUPWbtcrsVwTjeUR7GMgVnPpVDW2fma/Glwa/krHJz5TqvqT9xu56yUvMtwVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JT2LhjGTdRJ8PLmGnnpurL+ySRiL3QODWJtgR7CyBkU=;
 b=XeBxYq7ACE6t1ON9sEgfp90PuNtb9k8ZM5GzXOYhoiAxUic/AeMAj4IJflY0eTJxn4OWbtWIrj39j4zl2khnKGUSncpXl0kUij2mA02Ojnfrj67YbylJvP+PPSAyfDAv4kmTbgRUOUiPoIRqlBv0Us+oZfpqUwTSrk/x3tONt4hgLiHKrTQFk4adJm1mEbv4bCK2JYvF42oPymAamUsgCbr9yqi9v1HGuT4MB+QFiwKTL8F+K0WD9KICn01y5oLKXVcgUD1X/rS4OmT6R3fjB2Ln+YtDiX3FvpAhsuPAKtPRYEQMfY0bd8FJXdDronQrM5p+lqUbOkXMVbV/RKstvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT2LhjGTdRJ8PLmGnnpurL+ySRiL3QODWJtgR7CyBkU=;
 b=jFZ1wcFDoaKqb4kfExquyZVJ4u0+xDELK+DNysYnYS8woMQgXC/p5G9HsvfgiIq6xD+/L1DrR5Kwro7A52FJQytqaWnR/6sm6iiN7n5d3owE8F5JIw96vvGj+765PtzFlg2fVBGyIYd5y/jUqhzgL+zNHoPA0u0KE29tjBEN679hhR0hJ5tCO9KBE65PkwnRQygNUcQpbQxyxDDivmWjr/6PWDAWEjgr7iTSfJxtEHgphpX/PkTPHdtBRwwqLcx63pLnl1XrerfuFshMgql0hnobY6eM0OA8N3tO8G9zbNf0TGWF4WRRRrJkgtuHO4pQ8eIb7UtWrVWq14K9SxbtiA==
Received: from SN7PR04CA0110.namprd04.prod.outlook.com (2603:10b6:806:122::25)
 by BL3PR12MB6618.namprd12.prod.outlook.com (2603:10b6:208:38d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 01:24:55 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:806:122:cafe::bf) by SN7PR04CA0110.outlook.office365.com
 (2603:10b6:806:122::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.8 via Frontend Transport; Thu,
 22 Jan 2026 01:24:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:45 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:44 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:44 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 09/10] iommu/arm-smmu-v3: Remove ASID/VMID from arm_smmu_domain
Date: Wed, 21 Jan 2026 17:24:27 -0800
Message-ID: <018fe1410567661f3a0b457c7fc2570ae9d5ace4.1769044718.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769044718.git.nicolinc@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|BL3PR12MB6618:EE_
X-MS-Office365-Filtering-Correlation-Id: ba50f75d-921b-4ec6-9f56-08de59550c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ys4yqBmY2rAgCVHEMm2oyvZDZCCyoI9GAuz8Oay7E1P9HB98YnJJvEUa0kB8?=
 =?us-ascii?Q?t01P4OvJB74eWLO1ffRTF+lQ9LBYvrbtVE9M30GwaNcp7GUZcja+Erz4f8iY?=
 =?us-ascii?Q?Cg05wcUp8UphP5NBt+7WWE1USED4L7eSjm09rM6wRSO+ZQSYliWoh2GJstdW?=
 =?us-ascii?Q?HgwC75k/EDU1CCOKcilGzIyrsE85h6ZdHhGpwdqInwUAljzKnwIs2uDLZ1ws?=
 =?us-ascii?Q?vrYVazuWqStNOtjTL6dZ9oGTpYf0MGQHKmk67ekzsKs1UPzbhlzFl6YB63o0?=
 =?us-ascii?Q?u/nP6DuugSd/LKJMRFdWtgxYEmCvDu4gwHU/idfl4nq7Lr6TszcCtEHAR0XT?=
 =?us-ascii?Q?95I0iQIiNWLH6YebVSaheVrVmE7MUeY4+McXki7tFAhsd/8h4XhxYrqF3Hyb?=
 =?us-ascii?Q?mxPqoTZ2CW+CmC6UjsEMdPNjn/i9HlRVUUoHlJ1ASoyzwBn8N8k5zzLDAjib?=
 =?us-ascii?Q?vwWnsnaVKuDF5G3jRkGlY/JTVxHK7FEg1aRccjbpVslVTP4Y30eIfUsBhtf0?=
 =?us-ascii?Q?Xb7Ns6ev3IHgy48X8g2cfGfkGbfXCbXXN/5tUpVBJNsP1FC0ttl0S0aHFVsK?=
 =?us-ascii?Q?MQERGnYLZbKV4KU7JYxOU9F5cDSN2539+dZOEZUyb9SxhD1kWhUxZPwvIoc8?=
 =?us-ascii?Q?JgPzZpMlmuFaByhbJi4MzdqI+5LfLSJ3RG1wDaqCAzp+sxt0+aJV5aLWbY/z?=
 =?us-ascii?Q?mUrDFUodH2OfiqyaC1YEjnxwNzrGAMLhlGOHv91WSRlKU3xYGIsX6wo54hut?=
 =?us-ascii?Q?pi3spK2iF6I+K42lvvLBh3M6BZU7xJIpnOygxKhILwaK3cD+nlDg3sFlOiPO?=
 =?us-ascii?Q?aXyj/4bNzKwCdXYSK+36Kvob/J+Lmtl/YZ5aI7D67Bcrtkth1pPVkGJMUpdD?=
 =?us-ascii?Q?BeQOT7jzQVtdJ6mPwBpjoAHrisVlS3rVFjMA51m0MxA08XogjwwE1PjS/Tn0?=
 =?us-ascii?Q?OQwjfJEPZmsMZ55KsZaVQAikwF4mmdMrZYxu9euZ43MJcSnh3ZHQ8yQyPnLm?=
 =?us-ascii?Q?/HxX0isXDJ+han+AfqECGSX65FiRdUHuWnezG9Aje0soUBlZyEcstkGuqpiz?=
 =?us-ascii?Q?FXtTPLUvnLSO5/TiXwi+wYN53J1p2uvxw3X+PUuNHx6fvwj3TkWSaKl5nTls?=
 =?us-ascii?Q?UZAmGVFoLvnB4GY2+YjHhYdiPB2Pc8eKoQ8TlafDdBVLtwLgxsVVmF58ehgV?=
 =?us-ascii?Q?GIBiRBQd27rAe1iuCpntdd++hZk3aDi7EyR+UnTSW8+54waY0AlHr1+s/VLQ?=
 =?us-ascii?Q?VFi4hqzYakV1MZT1fI/bAk91fFg0qGmfB9cGZykhFK59/JfB/5P+GV/LYfcJ?=
 =?us-ascii?Q?Vf2lvMk1AdYMe1TjJ72hTk3GJglLAzuLxRv2anv901EI9XIaNW/qZQYDbt+s?=
 =?us-ascii?Q?E7+swLF0CFFogAS9WivINWu1dtAOGA+lNYQlqtzWM7/Ow64rZ+KveetaOq35?=
 =?us-ascii?Q?+hIx1s+VD1foGSaM/Bcc4ZZkQoo3oA5a3XrvhhfkwTKYwyEohnKM3PBIIlIs?=
 =?us-ascii?Q?PKs+QoDD50PI1AfWHwHzEoUOSo1hOOU7JLCatgEQ7a6pphBCaNretvk/A6CG?=
 =?us-ascii?Q?djto9OvKBapv5KoBSYYF69FiAGex7wjUJEp3Bj4H0Zy27kGq0f6hoRI1VuWg?=
 =?us-ascii?Q?w8HOqIyx9dhF7l2SFJlNMesusAZo5wz0LV9i9RyGGPvFIZFoMbd+1DLYSDPG?=
 =?us-ascii?Q?lotUUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:54.7140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba50f75d-921b-4ec6-9f56-08de59550c67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6618

Now ASID/VMID are stored in the arm_smmu_master. These are dead code now.

Remove all.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 20 +------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  3 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 58 -------------------
 4 files changed, 1 insertion(+), 88 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8365660282d5..c7b054eb062a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -784,10 +784,6 @@ static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
 	return cd_table->used_ssids;
 }
 
-struct arm_smmu_s2_cfg {
-	u16				vmid;
-};
-
 struct arm_smmu_strtab_cfg {
 	union {
 		struct {
@@ -964,10 +960,6 @@ struct arm_smmu_domain {
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_ctx_desc	cd;
-		struct arm_smmu_s2_cfg		s2_cfg;
-	};
 
 	struct iommu_domain		domain;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 461ccf4bdb03..7f7f147327bd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -295,14 +295,6 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 */
 	arm_smmu_domain_inv(smmu_domain);
 
-	/*
-	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
-	 * still be called/running at this point. We allow the ASID to be
-	 * reused, and if there is a race then it just suffers harmless
-	 * unnecessary invalidation.
-	 */
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-
 	/*
 	 * Actual free is defered to the SRCU callback
 	 * arm_smmu_mmu_notifier_free()
@@ -321,7 +313,6 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
-	u32 asid;
 	int ret;
 
 	if (!(master->smmu->features & ARM_SMMU_FEAT_SVA))
@@ -340,22 +331,13 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
-
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto err_free;
-
-	smmu_domain->cd.asid = asid;
 	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
 	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
 	if (ret)
-		goto err_asid;
+		goto err_free;
 
 	return &smmu_domain->domain;
 
-err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 err_free:
 	arm_smmu_domain_free(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index d66931b56b46..4ad26046fab6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -461,9 +461,6 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
 		.pgtbl_ops = &io_pgtable.ops,
-		.cd = {
-			.asid = asid,
-		},
 	};
 	struct arm_smmu_inv tag = {
 		.type = INV_TYPE_S1_ASID,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6d3da3f82ec8..19437ee6f4e1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2784,66 +2784,17 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
-
-	/* Free the ASID or VMID */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			ida_free(&smmu->vmid_map, cfg->vmid);
-	}
-
 	arm_smmu_domain_free(smmu_domain);
 }
 
-static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain)
-{
-	int ret;
-	u32 asid = 0;
-	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-
-	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	cd->asid	= (u16)asid;
-	mutex_unlock(&arm_smmu_asid_lock);
-	return ret;
-}
-
-static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain)
-{
-	int vmid;
-	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-
-	/* Reserve VMID 0 for stage-2 bypass STEs */
-	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
-			       GFP_KERNEL);
-	if (vmid < 0)
-		return vmid;
-
-	cfg->vmid	= (u16)vmid;
-	return 0;
-}
-
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu, u32 flags)
 {
-	int ret;
 	enum io_pgtable_fmt fmt;
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
-	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain);
 	bool enable_dirty = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 
 	pgtbl_cfg = (struct io_pgtable_cfg) {
@@ -2863,7 +2814,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		if (enable_dirty)
 			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_HD;
 		fmt = ARM_64_LPAE_S1;
-		finalise_stage_fn = arm_smmu_domain_finalise_s1;
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
@@ -2872,7 +2822,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.ias = smmu->ias;
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
-		finalise_stage_fn = arm_smmu_domain_finalise_s2;
 		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
 		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
 			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
@@ -2890,13 +2839,6 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
 		smmu_domain->domain.dirty_ops = &arm_smmu_dirty_ops;
-
-	ret = finalise_stage_fn(smmu, smmu_domain);
-	if (ret < 0) {
-		free_io_pgtable_ops(pgtbl_ops);
-		return ret;
-	}
-
 	smmu_domain->pgtbl_ops = pgtbl_ops;
 	smmu_domain->smmu = smmu;
 	return 0;
-- 
2.43.0

