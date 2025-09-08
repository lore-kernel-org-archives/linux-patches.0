Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EEF31B838;
	Mon,  8 Sep 2025 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374152; cv=fail; b=dPQsfNPNjBzW8PO7yb1VEpcHITOx4Mc+YFuWQT99BIqfgZUz4nvpIHSjsWh1Hjyfki8ibgsu6D2jANvwxzCb9TeFOgqiF9xm3C5CeOh8L7jvt+3jIw5kOxmd5gpD8lx+EBfR2af7wqPkMC/QAj+mi0haRYp63zy6zLMUfnwBF3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374152; c=relaxed/simple;
	bh=3YzN9ASXAULlFaIVwyG7o8b1D9B8MisWBF8Fp8f5+dU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brUBOio2iEnFE693TlNF9maAWMGBRFtKADYtlXJmbN+a/T66oMW3MRE3p2dtjD5t4280ar49CBq6XKW7cPeuQWl+zr82r19jNUDCPwE4o1Xs2SJbT5YY6kfwTMkcW+/A+6Ik3oT1e7swwFrBt2UN4Pkf59DT9IM3dyFA4yniplk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JnJ/O+kF; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JnJ/O+kF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1XTmGH/uzc3T1itstqD2OjYhRktbpglyhxBQIQ18Z6H8SOuGqSMJKN/JKFdTmmixG3znk1Wy01OF/2T2rjt16pJEuRVtCEOLCUnJSiCaFzTFd0YMDccnjbYe0S8UoKRPEj4uIiTneP8ZE00IAc/KjYXSFvi4ERT/2ZPSCfV3tTlfZH5Qd1iIgTUAFUw80L9BfwtyEzmIS/O6gyvj09+CzRjGhvMJlKcr8bxIqegnOZuYHVnTE5/BWU6YTjClNQA+fLwsvy+9dljY5IPRv7saJHZTgeVS2rfI2FOHmVz9lyyrSv0zlPdxbEx/zuSqPQSjBSA8w6uhyT/wjTJo+KrXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFTUB9h53UZwn08CA1Nz3kUSNT8E0+H4KfoccS4JgZg=;
 b=NjEFV3BhF55275xsMXtX9ExVdF98niT9ms5O53zYjxfNowOXI2/6MYQof+7wBIFN/cgsgM5m7DONobyTHHECJge2Lv3kaxKinP4ThXNIFY5852vutravoYPDuuakcLmp31ZnrtgL3U2+KFjLJXLzKaMZswecL53PIX5RT1qixKuNUc6Y1wxc36OPe1ck2MEFbjO/K8nD4DN79dUhC43m8fTiIy/kna7nf31Gz/jIoMep/oa6bptCwVXgOEL7i1OgszLHyr+h4OSI3t+SpPRja6Ho0Z7bOqt8vCdtvZKo0Hhw+HLN+kKtR1ggp3MXvlC0DVv+4InaR/Qpm7My9ZKNow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFTUB9h53UZwn08CA1Nz3kUSNT8E0+H4KfoccS4JgZg=;
 b=JnJ/O+kF5Z+fMw32JoOqwchFyVH19W8XsqW1Z0Gi0+dx0HtYaxRT01AnAyYsNKu5+xDpqVxW/fgQYbgli2AXHYknT2nCBinpQ/4XsUulZtQsIEU9S7rTUHc7A8fy3ET4NPoJYGbB4hgfDt4gZcHZMOfMUhG8f+L9cTfdRpYJMazWcfXIVBIxBNB0V5LEx9hIcF6r3L2fsFqknJatzFRBBithysL4nxFRAKZUtQ/c/fEqUje6ra3sl0JT4Gbn2VxvkMxcV19MRMsdTKsQ3QHFJuIActBsQJi2IlL1h135ms1xFFbIrti+Kak9294eqtXZu0LRiE/SdbyCSLwBtlZcfA==
Received: from SJ0PR03CA0127.namprd03.prod.outlook.com (2603:10b6:a03:33c::12)
 by IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:28:57 +0000
Received: from SJ5PEPF000001F2.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::dc) by SJ0PR03CA0127.outlook.office365.com
 (2603:10b6:a03:33c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.23 via Frontend Transport; Mon,
 8 Sep 2025 23:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001F2.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:44 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:44 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:43 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs when attaching masters
Date: Mon, 8 Sep 2025 16:27:00 -0700
Message-ID: <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F2:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 69261b6a-eba4-48b3-9c13-08ddef2f7b4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S9fWA8JuwEJz+3jE8pxjmNvvdrBdtuKMBhgzhzMTFnvfLsG7aDqelyKfVeQc?=
 =?us-ascii?Q?QowGBU7ZIxHKydiqNU6TssgjDiFq+9A8jZtOACgZZEF4oKLPZ0W6wvc8z7cX?=
 =?us-ascii?Q?I92ZpNj+Bfp7j0CQMDrsLo/S+g6ZIjz1CAa92BG6HieWto0qO2v+S2xVkzkC?=
 =?us-ascii?Q?CQHrFZ/T4A+CyWiWCVSbAFUL6wAxftqQiQecRNi1YFSieuLc06G2wY6GUvWM?=
 =?us-ascii?Q?64fcGWWuz6Im374qwu4i0NpQRCiPwXcCQjyIA3h1AqurfVQSl3ghFk+Gb6sH?=
 =?us-ascii?Q?LSrLRtb4HJBcM5XSL/R4nqNTiGB0z8evAK7VJiLCbPARPJZEBPmCsVZT+bJQ?=
 =?us-ascii?Q?yuoDhjs1btLM/OEBYmWL7s+8Tf49+XzxbkK7UVIiit5pvBEsghHxMD/dbQwc?=
 =?us-ascii?Q?bOkwG8abkIx3o720MKgPyFHRztXeTROnIoK4km3vbldErzSZ4UKdmNHOLOxb?=
 =?us-ascii?Q?v2td/WKHBnbcFwg1/p895vvLBHLlVK9f8n7NXpge50aSl2Nk+nYtnZc1f2tL?=
 =?us-ascii?Q?VDRYfRopxDMk876DtWgGSqTvMu+908t7FmpIbB6OyxP/HtmZdL28YWuO8lVW?=
 =?us-ascii?Q?uPepy3KzEWUdG4JUtDImX1+kZPryh9xTA6slsKLFn8P8FIAnRgby8xrQFayI?=
 =?us-ascii?Q?BIb/6k+Mn+7uKqwVs7aWymaazOkvGPkoBn4yatUXGYOiGJaxYWNk18NxHOgh?=
 =?us-ascii?Q?NpRqfDUGqQ1R/hsP6DBFiR8m/GrewNQVd+RpxQyJY0hb6/tBf9ywttdwp0oR?=
 =?us-ascii?Q?A9lCVxagbLJx6jcUVeqasSqIoWYkt8sic+u8XGR+XeITq/emAZ0fCp2BSE5G?=
 =?us-ascii?Q?srCBrEb/oG+kQjzjJkso+t7zeEItpraQXCfx/3J6KBqwuPl4uvlRpApSBt6b?=
 =?us-ascii?Q?1QsL0CcGvUOeDtGkJlcI8uIzaY+ziB/EI9r8JXismuTLX7EjkTN4xGZU7okl?=
 =?us-ascii?Q?Ep6/pS4tCBiFnHF3tNmyz/wDrXGhQh1zICmodycNaVrWns55TOcRDmU1h7Af?=
 =?us-ascii?Q?E725L7bGV+82XVAmtMRpCLWfYDB8i7K1w9Ol8ssPnPO9U1gbotgnhHetO2bX?=
 =?us-ascii?Q?YsoNaYWUzAJsYsh8OXUCMoOdxzB3H/ON5jNyD2oYZB/Ocs8Zm9f0UzL//O4b?=
 =?us-ascii?Q?VHihr3lHzcjZWlD26uQozUoADgoGr/B/NiMWospNiTdu2V53yur4cyNIUIve?=
 =?us-ascii?Q?IKCzMWINVkqKIemQ3gkG703Eb0j8WmrRNqeE+SgEQ5i7lBi1DQ91WaI/zwr/?=
 =?us-ascii?Q?P2qzhh1NQ3vIjdSl0lBb7IRXz9qcKQ/BV0dzbxKOXQS5+f0Ksf3TlHCBFHLe?=
 =?us-ascii?Q?20P2rllDykW7Ca/I/1hBfHwkVBbGTpXLyh+3mKj1QM9cbv7kW2iUXaH9MfcO?=
 =?us-ascii?Q?DZubvQhiSl48ks0SPTTxnkmx1xi8r9FO9DWSlA8EGHVtDf3OM0aUuddSEVY2?=
 =?us-ascii?Q?YjnR27FIAmQd4pT28fh3A3KY7o267X9e7DHLXJT66tYWXVqa+/rQpdxlXDFz?=
 =?us-ascii?Q?pPT7tSP8xt0x65Qvf49aIOlVUaPSi9C7GIpF?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:56.7378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69261b6a-eba4-48b3-9c13-08ddef2f7b4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

Update the invs array with the invalidations required by each domain type
during attachment operations.

Only an SVA domain or a paging domain will have an invs array:
 a. SVA domain will add an INV_TYPE_S1_ASID per SMMU and an INV_TYPE_ATS
    per SID

 b. Non-nesting-parent paging domain with no ATS-enabled master will add
    a single INV_TYPE_S1_ASID or INV_TYPE_S2_VMID per SMMU

 c. Non-nesting-parent paging domain with ATS-enabled master(s) will do
    (b) and add an INV_TYPE_ATS per SID

 d. Nesting-parent paging domain will add an INV_TYPE_S2_VMID followed by
    an INV_TYPE_S2_VMID_S1_CLEAR per vSMMU. For an ATS-enabled master, it
    will add an INV_TYPE_ATS_FULL per SID

The per-domain invalidation is not needed, until the domain is attached to
a master, i.e. a possible translation request. Giving this clears a way to
allowing the domain to be attached to many SMMUs, and avoids any pointless
invalidation overheads during a teardown if there are no STE/CDs referring
to the domain. This also means, when the last device is detached, the old
domain must flush its ASID or VMID because any iommu_unmap() call after it
wouldn't initiate any invalidation given an empty domain invs array.

Introduce some arm_smmu_invs helper functions for building scratch arrays,
preparing and installing old/new domain's invalidation arrays.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  22 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 312 +++++++++++++++++++-
 2 files changed, 332 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 246c6d84de3ab..e4e0e066108cc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -678,6 +678,8 @@ struct arm_smmu_inv {
 /**
  * struct arm_smmu_invs - Per-domain invalidation array
  * @num_invs: number of invalidations in the flexible array
+ * @old: flag to synchronize with reader
+ * @rwlock: optional rwlock to fench ATS operations
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -703,6 +705,8 @@ struct arm_smmu_inv {
  */
 struct arm_smmu_invs {
 	size_t num_invs;
+	rwlock_t rwlock;
+	u8 old;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[];
 };
@@ -714,6 +718,7 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	new_invs = kzalloc(struct_size(new_invs, inv, num_invs), GFP_KERNEL);
 	if (!new_invs)
 		return ERR_PTR(-ENOMEM);
+	rwlock_init(&new_invs->rwlock);
 	new_invs->num_invs = num_invs;
 	return new_invs;
 }
@@ -1082,6 +1087,21 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
 	       IOMMU_FWSPEC_PCI_RC_CANWBS;
 }
 
+/**
+ * struct arm_smmu_inv_state - Per-domain invalidation array state
+ * @invs_ptr: points to the domain->invs (unwinding nesting/etc.) or is NULL if
+ *            no change should be made
+ * @old_invs: the original invs array
+ * @new_invs: for new domain, this is the new invs array to update domin->invs;
+ *            for old domain, this is the master->build_invs to pass in as the
+ *            to_unref argument to an arm_smmu_invs_unref() call
+ */
+struct arm_smmu_inv_state {
+	struct arm_smmu_invs **invs_ptr;
+	struct arm_smmu_invs *old_invs;
+	struct arm_smmu_invs *new_invs;
+};
+
 struct arm_smmu_attach_state {
 	/* Inputs */
 	struct iommu_domain *old_domain;
@@ -1091,6 +1111,8 @@ struct arm_smmu_attach_state {
 	ioasid_t ssid;
 	/* Resulting state */
 	struct arm_smmu_vmaster *vmaster;
+	struct arm_smmu_inv_state old_domain_invst;
+	struct arm_smmu_inv_state new_domain_invst;
 	bool ats_enabled;
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4e69c81f5a28b..ee779df1d78fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1183,8 +1183,11 @@ size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
 			i++;
 		} else if (cmp == 0) {
 			/* same item */
-			if (refcount_dec_and_test(&invs->inv[i].users))
+			if (refcount_dec_and_test(&invs->inv[i].users)) {
+				/* Notify the caller about this deletion */
+				refcount_set(&to_unref->inv[j].users, 1);
 				num_dels++;
+			}
 			i++;
 			j++;
 		} else {
@@ -3028,6 +3031,97 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+/*
+ * Use the preallocated scratch array at master->build_invs, to build a to_merge
+ * or to_unref array, to pass into a following arm_smmu_invs_merge/unref() call.
+ *
+ * Do not free the returned invs array. It is reused, and will be overwritten by
+ * the next arm_smmu_master_build_invs() call.
+ */
+static struct arm_smmu_invs *
+arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
+			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
+{
+	const bool e2h = master->smmu->features & ARM_SMMU_FEAT_E2H;
+	struct arm_smmu_invs *build_invs = master->build_invs;
+	const bool nesting = smmu_domain->nest_parent;
+	struct arm_smmu_inv *cur;
+
+	iommu_group_mutex_assert(master->dev);
+
+	cur = build_invs->inv;
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1:
+		*cur = (struct arm_smmu_inv){
+			.smmu = master->smmu,
+			.type = INV_TYPE_S1_ASID,
+			.id = smmu_domain->cd.asid,
+			.size_opcode = e2h ? CMDQ_OP_TLBI_EL2_VA :
+					     CMDQ_OP_TLBI_NH_VA,
+			.nsize_opcode = e2h ? CMDQ_OP_TLBI_EL2_ASID :
+					      CMDQ_OP_TLBI_NH_ASID
+		};
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		*cur = (struct arm_smmu_inv){
+			.smmu = master->smmu,
+			.type = INV_TYPE_S2_VMID,
+			.id = smmu_domain->s2_cfg.vmid,
+			.size_opcode = CMDQ_OP_TLBI_S2_IPA,
+			.nsize_opcode = CMDQ_OP_TLBI_S12_VMALL,
+		};
+		break;
+	default:
+		WARN_ON(true);
+		return NULL;
+	}
+
+	/* Range-based invalidation requires the leaf pgsize for calculation */
+	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+		cur->pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
+	cur++;
+
+	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
+	if (nesting) {
+		*cur = (struct arm_smmu_inv){
+			.smmu = master->smmu,
+			.type = INV_TYPE_S2_VMID_S1_CLEAR,
+			.id = smmu_domain->s2_cfg.vmid,
+			.size_opcode = CMDQ_OP_TLBI_NH_ALL,
+			.nsize_opcode = CMDQ_OP_TLBI_NH_ALL,
+		};
+		cur++;
+	}
+
+	if (ats_enabled) {
+		size_t i;
+
+		for (i = 0; i < master->num_streams; i++) {
+			/*
+			 * If an S2 used as a nesting parent is changed we have
+			 * no option but to completely flush the ATC.
+			 */
+			*cur = (struct arm_smmu_inv){
+				.smmu = master->smmu,
+				.type = nesting ? INV_TYPE_ATS_FULL :
+						  INV_TYPE_ATS,
+				.id = master->streams[i].id,
+				.ssid = ssid,
+				.size_opcode = CMDQ_OP_ATC_INV,
+				.nsize_opcode = CMDQ_OP_ATC_INV,
+			};
+			cur++;
+		}
+	}
+
+	/* Note this build_invs must have been sorted */
+
+	build_invs->num_invs = cur - build_invs->inv;
+	return build_invs;
+}
+
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 					  struct iommu_domain *domain,
 					  ioasid_t ssid)
@@ -3057,6 +3151,211 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 	kfree(master_domain);
 }
 
+static inline void arm_smmu_invs_dbg(struct arm_smmu_master *master,
+				     struct arm_smmu_domain *smmu_domain,
+				     struct arm_smmu_invs *invs, char *name)
+{
+	size_t i;
+
+	dev_dbg(master->dev, "domain (type: %x), invs: %s, num_invs: %ld\n",
+		smmu_domain->domain.type, name, invs->num_invs);
+	for (i = 0; i < invs->num_invs; i++) {
+		struct arm_smmu_inv *cur = &invs->inv[i];
+
+		dev_dbg(master->dev,
+			"  entry: inv[%ld], type: %u, id: %u, users: %u\n", i,
+			cur->type, cur->id, refcount_read(&cur->users));
+	}
+}
+
+/*
+ * During attachment, the updates of the two domain->invs arrays are sequenced:
+ *  1. new domain updates its invs array, merging master->build_invs
+ *  2. new domain starts to include the master during its invalidation
+ *  3. master updates its STE switching from the old domain to the new domain
+ *  4. old domain still includes the master during its invalidation
+ *  5. old domain updates its invs array, unreferencing master->build_invs
+ *
+ * For 1 and 5, prepare the two updated arrays in advance, handling any changes
+ * that can possibly failure. So the actual update of either 1 or 5 won't fail.
+ * arm_smmu_asid_lock ensures that the old invs in the domains are intact while
+ * we are sequencing to update them.
+ */
+static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
+					struct arm_smmu_domain *new_smmu_domain)
+{
+	struct arm_smmu_domain *old_smmu_domain =
+		to_smmu_domain_devices(state->old_domain);
+	struct arm_smmu_master *master = state->master;
+	ioasid_t ssid = state->ssid;
+
+	/* A re-attach case doesn't need to update invs array */
+	if (new_smmu_domain == old_smmu_domain)
+		return 0;
+
+	/*
+	 * At this point a NULL domain indicates the domain doesn't use the
+	 * IOTLB, see to_smmu_domain_devices().
+	 */
+	if (new_smmu_domain) {
+		struct arm_smmu_inv_state *invst = &state->new_domain_invst;
+		struct arm_smmu_invs *build_invs;
+
+		invst->invs_ptr = &new_smmu_domain->invs;
+		invst->old_invs = rcu_dereference_protected(
+			new_smmu_domain->invs,
+			lockdep_is_held(&arm_smmu_asid_lock));
+		build_invs = arm_smmu_master_build_invs(
+			master, state->ats_enabled, ssid, new_smmu_domain);
+		if (!build_invs)
+			return -EINVAL;
+
+		invst->new_invs =
+			arm_smmu_invs_merge(invst->old_invs, build_invs);
+		if (IS_ERR(invst->new_invs))
+			return PTR_ERR(invst->new_invs);
+
+		arm_smmu_invs_dbg(master, new_smmu_domain, invst->old_invs,
+				  "new domain's old invs");
+		arm_smmu_invs_dbg(master, new_smmu_domain, build_invs, "merge");
+		arm_smmu_invs_dbg(master, new_smmu_domain, invst->new_invs,
+				  "new domain's new invs");
+	}
+
+	if (old_smmu_domain) {
+		struct arm_smmu_inv_state *invst = &state->old_domain_invst;
+
+		invst->invs_ptr = &old_smmu_domain->invs;
+		invst->old_invs = rcu_dereference_protected(
+			old_smmu_domain->invs,
+			lockdep_is_held(&arm_smmu_asid_lock));
+		/* For old_smmu_domain, new_invs points to master->build_invs */
+		invst->new_invs = arm_smmu_master_build_invs(
+			master, master->ats_enabled, ssid, old_smmu_domain);
+	}
+
+	return 0;
+}
+
+/* Must be installed before arm_smmu_install_ste_for_dev() */
+static void
+arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
+{
+	struct arm_smmu_inv_state *invst = &state->new_domain_invst;
+
+	if (!invst->invs_ptr)
+		return;
+
+	rcu_assign_pointer(*invst->invs_ptr, invst->new_invs);
+	/*
+	 * Committed to updating the STE, using the new invalidation array, and
+	 * acquiring any racing IOPTE updates.
+	 */
+	smp_mb();
+	kfree_rcu(invst->old_invs, rcu);
+}
+
+/*
+ * When an array entry's users count reaches zero, it means the ASID/VMID is no
+ * longer being invalidated by map/unmap and must be cleaned. The rule is that
+ * all ASIDs/VMIDs not in an invalidation array are left cleared in the IOTLB.
+ */
+static void arm_smmu_invs_flush_iotlb_tags(struct arm_smmu_invs *invs)
+{
+	size_t i;
+
+	for (i = 0; i != invs->num_invs; i++) {
+		struct arm_smmu_inv *inv = &invs->inv[i];
+		struct arm_smmu_cmdq_ent cmd = {};
+
+		/* arm_smmu_invs_unref() sets users if it was the last user */
+		if (!refcount_read(&inv->users))
+			continue;
+
+		switch (inv->type) {
+		case INV_TYPE_S1_ASID:
+			cmd.tlbi.asid = inv->id;
+			break;
+		case INV_TYPE_S2_VMID:
+			/* S2_VMID using nsize_opcode covers S2_VMID_S1_CLEAR */
+			cmd.tlbi.vmid = inv->id;
+			break;
+		default:
+			continue;
+		}
+
+		cmd.opcode = inv->nsize_opcode;
+		arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+	}
+}
+
+/* Should be installed after arm_smmu_install_ste_for_dev() */
+static void
+arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
+{
+	struct arm_smmu_inv_state *invst = &state->old_domain_invst;
+	struct arm_smmu_domain *old_smmu_domain =
+		to_smmu_domain_devices(state->old_domain);
+	struct arm_smmu_invs *old_invs = invst->old_invs;
+	struct arm_smmu_master *master = state->master;
+	struct arm_smmu_invs *new_invs;
+	unsigned long flags;
+	size_t num_dels;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (!invst->invs_ptr)
+		return;
+
+	arm_smmu_invs_dbg(master, old_smmu_domain, old_invs,
+			  "old domain's old invs");
+	arm_smmu_invs_dbg(master, old_smmu_domain, invst->new_invs, "unref");
+	num_dels = arm_smmu_invs_unref(old_invs, invst->new_invs);
+	if (!num_dels) {
+		arm_smmu_invs_dbg(master, old_smmu_domain, old_invs,
+				  "old domain's new invs");
+		return;
+	}
+
+	arm_smmu_invs_flush_iotlb_tags(invst->new_invs);
+
+	new_invs = arm_smmu_invs_purge(old_invs, num_dels);
+	if (!new_invs) {
+		size_t new_num = old_invs->num_invs;
+
+		/*
+		 * OOM. Couldn't make a copy. Leave the array unoptimized. But
+		 * trim its size if some tailing entries are marked as trash.
+		 */
+		while (new_num != 0) {
+			if (refcount_read(&old_invs->inv[new_num - 1].users))
+				break;
+			new_num--;
+		}
+
+		arm_smmu_invs_dbg(master, old_smmu_domain, old_invs,
+				  "old domain's new invs");
+
+		/* The lock is required to fence concurrent ATS operations. */
+		write_lock_irqsave(&old_invs->rwlock, flags);
+		WRITE_ONCE(old_invs->num_invs, new_num);
+		write_unlock_irqrestore(&old_invs->rwlock, flags);
+		return;
+	}
+
+	arm_smmu_invs_dbg(master, old_smmu_domain, new_invs,
+			  "old domain's new invs");
+
+	/* new_invs is a copy, do the copy update part of RCU */
+	rcu_assign_pointer(*invst->invs_ptr, new_invs);
+	/* Notify any concurrent invalidation to read the updated invs */
+	write_lock_irqsave(&old_invs->rwlock, flags);
+	WRITE_ONCE(old_invs->old, true);
+	write_unlock_irqrestore(&old_invs->rwlock, flags);
+
+	kfree_rcu(old_invs, rcu);
+}
+
 /*
  * Start the sequence to attach a domain to a master. The sequence contains three
  * steps:
@@ -3114,12 +3413,16 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 				     arm_smmu_ats_supported(master);
 	}
 
+	ret = arm_smmu_attach_prepare_invs(state, smmu_domain);
+	if (ret)
+		return ret;
+
 	if (smmu_domain) {
 		if (new_domain->type == IOMMU_DOMAIN_NESTED) {
 			ret = arm_smmu_attach_prepare_vmaster(
 				state, to_smmu_nested_domain(new_domain));
 			if (ret)
-				return ret;
+				goto err_unprepare_invs;
 		}
 
 		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
@@ -3167,6 +3470,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			atomic_inc(&smmu_domain->nr_ats_masters);
 		list_add(&master_domain->devices_elm, &smmu_domain->devices);
 		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+		arm_smmu_install_new_domain_invs(state);
 	}
 
 	if (!state->ats_enabled && master->ats_enabled) {
@@ -3186,6 +3491,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 	kfree(master_domain);
 err_free_vmaster:
 	kfree(state->vmaster);
+err_unprepare_invs:
+	kfree(state->new_domain_invst.new_invs);
 	return ret;
 }
 
@@ -3217,6 +3524,7 @@ void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 	}
 
 	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
+	arm_smmu_install_old_domain_invs(state);
 	master->ats_enabled = state->ats_enabled;
 }
 
-- 
2.43.0

