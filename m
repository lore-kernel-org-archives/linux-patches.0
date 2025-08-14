Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD01DE3DC;
	Thu, 14 Aug 2025 01:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134794; cv=fail; b=FeJ8DxocUe+fEE6vPI1gtvFZfw1haYMZr8Rfs+igNjzLoyHFw4ka9DJv4xVycllPvPXgpZYrokXEVlHTp3M/Y2vc7Yx0YszoR+bZ1K/fTaSQKBbcL2GBh0g+Wk7m8u+A+00BnKqwOXojK0jg5mq/+ad3MFtiR8FiuuicPG73GBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134794; c=relaxed/simple;
	bh=ozp33+2gloR6AiJ19PMkq7LcwscI3WW8eijdK+Vs1TI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vD2XMNyD4ob7lipGmGkmK543G1PkywkCgcvSPOeLn+LqukN4ewc+5oBMUvlMLzCPu0g+KqXLCjRjChw8g0rAjPBEIByEEVvtjP9tEHANemr6Lv1/RpxsFDFLF4RPRiGeil2fZxxx1SC+Y6EjvZLPEeRGvMxOeq3wLqfkcYEb+rY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qC9vert7; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qC9vert7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDeM3X2Pnb+sN1XiOhpwQbPtDvbKLGhHMGyV/ssmKsUzFRa+NHEYdUZQIuCRLsABZC9p8GscQZ7A5K3gvtcQ4E4rBLPZYjUQsMZtn4vPU/bFGyxkrx1zvTnQdOrjtUVLnBHXvPgt6rvN0JPrFFPkbTpbg1qyTmqvdNa+216hwcDOL6CKpTYfnJ/8fV0Nnpy6Kago0PQ1v5JX5ErmpMxey73JI+v7ITIdOKXvJ2+nA+J4DpDQS2Uzh5/mANCoUT8ZwoDPFLiMuL3r75cJAMyFC5K0dSUqriJKtKrZv7171yMgByn9nF3snWtRUlUxoR/6Mm+0dcT6ALiR8/VhIBMm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7+DOaHzvoBkZ9ieUqsGvU4RjP2MgFaQhBiQNV17Gi8=;
 b=ZwTxBgivUMDSVjEXVSVDnlyJ89Z2XP828hsDejrMGHYCPvPEceHzKZ+ecaI2nPxjc5Pfa44zpiUnUEk5F8YFs+kgPGgKYmN4mXMcsBNqDETtSngkW3Nncok6gEzfyGkYQcHoCGAiAqu6KrezXQtKhziuorwm4oQMfYmeOiSmarKU7gU6D2qQAukF2kqDysTOIcxZuMF/mytENyEUaLlRT4DUCD9KMLGxnlr9GqknovrpbDaf0NWhXFbWaKYZAyDqFb3fCsTO6YH3jGmY3Hk4vuhjv1dTZOKUsz2baa9UzjEpqmx58oTg4AiJkzYeVZYYU9GCErGPO608GbB0OvwHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7+DOaHzvoBkZ9ieUqsGvU4RjP2MgFaQhBiQNV17Gi8=;
 b=qC9vert79MlqZdzbRis3h2M149m1WrcKEE5ez9kdKhJfwNbcFxIdS4bRxZUt3b07Cwi4UE6YSSMQH0koKecwPce6/CV+RWN11F67DUZl9tZHiqa4scC7oH6GZSORbtUOPZasVkoOr5WcnmZFP/g31WsbcNnFiQBBN1O35OgCKyXD1LEI4JToLjaiNA+fdizoUMW4x1dX/Fv2f1v1ePUivg4utxl2xYUZxglYmY45sL4q0OFY4epvpN91PIXoLECzNmvvyjzcrcBn2IUjaE35h0Ju5xkraJB7bwvecoT0vBG2ZgO6UiBC+bupbxz/zuiauMz66PCWaTwqkQXXi+thiA==
Received: from BYAPR08CA0016.namprd08.prod.outlook.com (2603:10b6:a03:100::29)
 by MW4PR12MB7288.namprd12.prod.outlook.com (2603:10b6:303:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Thu, 14 Aug
 2025 01:26:23 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::61) by BYAPR08CA0016.outlook.office365.com
 (2603:10b6:a03:100::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 01:26:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:23 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:07 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:06 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:05 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain arm_smmu_invs array
Date: Wed, 13 Aug 2025 18:25:35 -0700
Message-ID: <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|MW4PR12MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: eb17f76f-a973-4496-060c-08dddad194b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?11jGr5FRQ+lmntcaiQ2dcOH5GXZJUS5OUkqxhLNFUes6Vsk9jr8Ux34iAzCi?=
 =?us-ascii?Q?mqfip1yz0DxH+JwaDc+yWXtoX6A8GaGuDvQwXZHfaZAwyMyl9K1Jq8U/I/5s?=
 =?us-ascii?Q?9VWzqJmrGEHCQN2ce7E6pJIKxKk5WCIVJSqjACEa0tOA6+uc+s7pn8/RJ3rL?=
 =?us-ascii?Q?arNm4HEK9VfT2PGC1kjH+6pW1VntRLChnsuKjQzx6YyzFaXs0ylybjmMbfw/?=
 =?us-ascii?Q?JUTt4SjmLKecvBwpE3D32OLaZH6G/sPmnI36h3paLGYNotPRLsfCoTuf6eVs?=
 =?us-ascii?Q?uOrVFqXWmX35YgRjc4zbEtiJLBpcWH07ruzT5GpdA6Ie4JEOJv1BnE2KYYrF?=
 =?us-ascii?Q?qo+CEYaoVPnlaCwFxv/b8wUGUnrvgTzwZL9bkqxFqYrv32VdvfgEwk0Qry6d?=
 =?us-ascii?Q?GRj2LsLV87fbQiP+NfWuuxCupZXQWYMeBwitkexbyC5L0J9TvecbN6lcoMDt?=
 =?us-ascii?Q?p4FU7M6V/PZWJg0bwh8kheETjaROplI9KERXSQbP+X8eHJ3lq16sPVQTa1LZ?=
 =?us-ascii?Q?gZKr8xWEUfZQs0HaRvq6bhrtamPMvO1Ee89bJ6ppRTf3T8oFXU06cqE9TakU?=
 =?us-ascii?Q?NnSDreha97oAklIE1BpTTxIobvVXxj0IJFiqNFLrCBWZzKe100zROya5RBKn?=
 =?us-ascii?Q?HGmc1YIk7H4eBdqZ4F2p0fc0KA2mZHxP3sl0Es1QUeo8QmbLNoPjX2m6t6CD?=
 =?us-ascii?Q?tERj0ATO88zEPAt6Jbm1/yGyQRbNWvjclNsp2e7zfkqIRpDwg8wDGhUO1EXt?=
 =?us-ascii?Q?5t1oSPhV4AsxipjyKvmVRkdT7W/MX6r0u8QABGMLPQ1p1VsSM7ARwKqzbE6H?=
 =?us-ascii?Q?9oI9paH8giOYk5Isi+edIVuodobEk8HgWz+Se48EIqERxk6Ij46EcPwfO6Xm?=
 =?us-ascii?Q?fzBasYhgJqYqyVbuvEmVnTCPVzwBmuIZyHCxjFx1KC/rweda5hx/6tC2/zw0?=
 =?us-ascii?Q?X3uMVzmFZL8SfX8B5l777FwQ+PuHUdip99DsVxyDsjVDWbgq5O2ZdTIcv0gU?=
 =?us-ascii?Q?art6kjF9u19P/yTvBGG+ahmqF94n6tJgdBOUQhaTwpm29NJCrC0WT8b8k9HJ?=
 =?us-ascii?Q?FzlREzZGzGhhFjuMeVbTmg/ur0bM5YP+YYCX8b5qewZbeqkzCE17oWWVtVFC?=
 =?us-ascii?Q?vnRLYA/aGtCHDembFujLJ2Z2nBDCkdxCZcLgnzS8995AxgPj+WC7WTRXfHgK?=
 =?us-ascii?Q?mw2wc8yy3GyI/TFMilc5yuxkFvNMHrG9vLC4teM+wmQ4wdlX8DabqYU1op2g?=
 =?us-ascii?Q?HwpuTQDM7w9ZhdR3oyg9SvC/2C3fsJC/TNmNLhLbKlZ3QitUp+wh/JGgzv5Z?=
 =?us-ascii?Q?qHBAb8+AYk/oyBjy0CgfWk86F4BiM8KnCeyFv+eKtfdQBkvIUY+ahclzz4xN?=
 =?us-ascii?Q?pgO4glN0z1Mya8Wb6gErD0nYOggZDibYuoWNGZmcKdLb7BzMNAXmmVkw44rG?=
 =?us-ascii?Q?rnWCYLZnpgoTUjr71Z5clnYaL+dcRMTL/UYcd9JIgNv6eOuAoPQd9o3g0/8z?=
 =?us-ascii?Q?Gte08vEcxxLveLKUuiosh9k0igZE+lerFo7i?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:23.3072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb17f76f-a973-4496-060c-08dddad194b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7288

From: Jason Gunthorpe <jgg@nvidia.com>

Create a new data structure to hold an array of invalidations that need to
be performed for the domain based on what masters are attached, to replace
the single smmu pointer and linked list of masters in the current design.

Each array entry holds one of the invalidation actions - S1_ASID, S2_VMID,
ATS or their variant with information to feed invalidation commands to HW.
It is structured so that multiple SMMUs can participate in the same array,
removing one key limitation of the current system.

To maximize performance, a sorted array is used as the data structure. It
allows grouping SYNCs together to parallelize invalidations. For instance,
it will group all the ATS entries after the ASID/VMID entry, so they will
all be pushed to the PCI devices in parallel with one SYNC.

To minimize the locking cost on the invalidation fast path (reader of the
invalidation array), the array is managed with RCU.

Provide a set of APIs to add/delete entries to/from an array, including a
special no-fail helper function for a cannot-fail case, e.g. attaching to
arm_smmu_blocked_domain. Also, add kunit coverage for those APIs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Co-developed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  79 ++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  85 ++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 266 ++++++++++++++++++
 3 files changed, 430 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 96a23ca633cb6..d7421b56e3598 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -649,6 +649,82 @@ struct arm_smmu_cmdq_batch {
 	int				num;
 };
 
+enum arm_smmu_inv_type {
+	INV_TYPE_S1_ASID,
+	INV_TYPE_S2_VMID,
+	INV_TYPE_S2_VMID_S1_CLEAR,
+	INV_TYPE_ATS,
+	INV_TYPE_ATS_FULL,
+};
+
+struct arm_smmu_inv {
+	/* invalidation items */
+	struct arm_smmu_device *smmu;
+	u8 type;
+	u8 size_opcode;
+	u8 nsize_opcode;
+	u32 id; /* ASID or VMID or SID */
+	union {
+		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
+		u32 ssid; /* INV_TYPE_ATS */
+	};
+
+	/* infrastructure items */
+	refcount_t users; /* users=0 to mark as a trash */
+	bool todel : 1; /* set for a pending deletion */
+};
+
+/**
+ * struct arm_smmu_invs - Per-domain invalidation array
+ * @num_invs: number of invalidations in @invs
+ * @rwlock: Optional rwlock to fench arm_smmu_invs_dec()
+ * @rcu: rcu head for kfree_rcu()
+ * @inv: flexible invalidation array
+ *
+ * The arm_smmu_invs is an RCU data structure. During a ->attach_dev callback,
+ * arm_smmu_invs_add() and arm_smmu_invs_del() will be used to allocate a new
+ * copy of an old array for addition and deletion.
+ *
+ * The arm_smmu_invs_dec() is a special function to mutate a given array, by
+ * internally reducing the users counts of some given entries. This exists to
+ * support a no-fail routine like attaching to an IOMMU_DOMAIN_BLOCKED. Use it
+ * carefully as it can impact performance from the extra rwlock.
+ *
+ * Concurrent invalidation thread will push all the invalidations described on
+ * the array into the command queue for each invalidation event. It is designed
+ * like this to optimize the invalidation fast path by avoiding locks.
+ *
+ * A domain can be shared across SMMU instances. When an instance gets removed
+ * it would delete all the entries that belong to that SMMU instance. Then, a
+ * synchronize_rcu() would have to be called to sync the array, to prevent any
+ * concurrent invalidation thread accessing the old array from issuing commands
+ * to the command queue of a removed SMMU instance.
+ */
+struct arm_smmu_invs {
+	size_t num_invs;
+	rwlock_t rwlock;
+	struct rcu_head rcu;
+	struct arm_smmu_inv inv[];
+};
+
+static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
+{
+	struct arm_smmu_invs *new_invs;
+
+	new_invs = kzalloc(struct_size(new_invs, inv, num_invs), GFP_KERNEL);
+	if (!new_invs)
+		return ERR_PTR(-ENOMEM);
+	rwlock_init(&new_invs->rwlock);
+	return new_invs;
+}
+
+struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *old_invs,
+					struct arm_smmu_invs *add_invs);
+struct arm_smmu_invs *arm_smmu_invs_del(struct arm_smmu_invs *old_invs,
+					struct arm_smmu_invs *del_invs);
+size_t arm_smmu_invs_dec(struct arm_smmu_invs *invs,
+			 struct arm_smmu_invs *dec_invs);
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
@@ -875,6 +951,8 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	struct arm_smmu_invs		*invs;
+
 	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
@@ -956,6 +1034,7 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
 static inline void arm_smmu_domain_free(struct arm_smmu_domain *smmu_domain)
 {
+	kfree_rcu(smmu_domain->invs, rcu);
 	kfree(smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index d2671bfd37981..2008a4b55ef70 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -567,6 +567,90 @@ static void arm_smmu_v3_write_cd_test_sva_release(struct kunit *test)
 						      NUM_EXPECTED_SYNCS(2));
 }
 
+static void arm_smmu_v3_invs_test_verify(struct kunit *test,
+					 struct arm_smmu_invs *invs, int num,
+					 const int *ids, const int *users)
+{
+	KUNIT_EXPECT_EQ(test, invs->num_invs, num);
+	while (num--) {
+		KUNIT_EXPECT_EQ(test, invs->inv[num].id, ids[num]);
+		KUNIT_EXPECT_EQ(test, refcount_read(&invs->inv[num].users),
+				users[num]);
+	}
+}
+
+static struct arm_smmu_invs invs1 = {
+	.num_invs = 3,
+	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, },
+		 { .type = INV_TYPE_S2_VMID, .id = 2, },
+		 { .type = INV_TYPE_S2_VMID, .id = 3, }, },
+};
+
+static struct arm_smmu_invs invs2 = {
+	.num_invs = 3,
+	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .type = INV_TYPE_ATS, .id = 5, },
+		 { .type = INV_TYPE_ATS, .id = 4, }, },
+};
+
+static struct arm_smmu_invs invs3 = {
+	.num_invs = 3,
+	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .type = INV_TYPE_ATS, .id = 7, },
+		 { .type = INV_TYPE_ATS, .id = 6, }, },
+};
+
+static void arm_smmu_v3_invs_test(struct kunit *test)
+{
+	const int results1[2][3] = { { 1, 2, 3, }, { 1, 1, 1, }, };
+	const int results2[2][5] = { { 1, 2, 3, 4, 5, }, { 2, 1, 1, 1, 1, }, };
+	const int results3[2][5] = { { 1, 2, 3, 4, 5, }, { 1, 1, 1, 0, 0, }, };
+	const int results4[2][5] = { { 1, 2, 3, 6, 7, }, { 2, 1, 1, 1, 1, }, };
+	const int results5[2][5] = { { 1, 2, 3, 6, 7, }, { 1, 0, 0, 1, 1, }, };
+	struct arm_smmu_invs *test_a, *test_b;
+	size_t num_invs;
+
+	/* New array */
+	test_a = arm_smmu_invs_alloc(0);
+	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+
+	/* Test1: add invs1 (new array) */
+	test_b = arm_smmu_invs_add(test_a, &invs1);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results1[0]),
+				     results1[0], results1[1]);
+	kfree(test_a);
+
+	/* Test2: add invs2 (new array) */
+	test_a = arm_smmu_invs_add(test_b, &invs2);
+	arm_smmu_v3_invs_test_verify(test, test_a, ARRAY_SIZE(results2[0]),
+				     results2[0], results2[1]);
+	kfree(test_b);
+
+	/* Test3: decrease invs2 (same array) */
+	num_invs = arm_smmu_invs_dec(test_a, &invs2);
+	arm_smmu_v3_invs_test_verify(test, test_a, ARRAY_SIZE(results3[0]),
+				     results3[0], results3[1]);
+	KUNIT_EXPECT_EQ(test, num_invs, 3);
+
+	/* Test4: add invs3 (new array) */
+	test_b = arm_smmu_invs_add(test_a, &invs3);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results4[0]),
+				     results4[0], results4[1]);
+	kfree(test_a);
+
+	/* Test5: decrease invs1 (same array) */
+	num_invs = arm_smmu_invs_dec(test_b, &invs1);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results5[0]),
+				     results5[0], results5[1]);
+	KUNIT_EXPECT_EQ(test, num_invs, 3);
+
+	/* Test6: delete invs3 (new array) */
+	test_a = arm_smmu_invs_del(test_b, &invs3);
+	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+	kfree(test_b);
+	kfree(test_a);
+}
+
 static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_abort),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_bypass),
@@ -590,6 +674,7 @@ static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_s1_stall),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_release),
+	KUNIT_CASE(arm_smmu_v3_invs_test),
 	{},
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 08af5f2d1235a..73f3b411ff7ef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
+#include <linux/sort.h>
 #include <linux/string_choices.h>
 #include <kunit/visibility.h>
 #include <uapi/linux/iommufd.h>
@@ -1033,6 +1034,263 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 }
 
+static int arm_smmu_invs_cmp(const void *_l, const void *_r)
+{
+	const struct arm_smmu_inv *l = _l;
+	const struct arm_smmu_inv *r = _r;
+
+	if (l->smmu != r->smmu)
+		return cmp_int((uintptr_t)l->smmu, (uintptr_t)r->smmu);
+	if (l->type != r->type)
+		return cmp_int(l->type, r->type);
+	return cmp_int(l->id, r->id);
+}
+
+static inline bool same_op(const struct arm_smmu_inv *a,
+			   const struct arm_smmu_inv *b)
+{
+	return a->smmu == b->smmu && a->type == b->type && a->id == b->id;
+}
+
+/**
+ * arm_smmu_invs_add() - Combine @old_invs with @add_invs to a new array
+ * @old_invs: the old invalidation array
+ * @add_invs: an array of invlidations to add
+ *
+ * Return: a newly allocated and sorted invalidation array on success, or an
+ * ERR_PTR.
+ *
+ * This function must be locked and serialized with arm_smmu_invs_del/dec(),
+ * but do not lockdep on any lock for KUNIT test.
+ *
+ * Caller is resposible for freeing the @old_invs and the returned one.
+ *
+ * Entries marked as trash can be resued if @add_invs wants to add them back.
+ * Otherwise, they will be completely removed in the returned array.
+ */
+VISIBLE_IF_KUNIT
+struct arm_smmu_invs *arm_smmu_invs_add(struct arm_smmu_invs *old_invs,
+					struct arm_smmu_invs *add_invs)
+{
+	size_t need = old_invs->num_invs + add_invs->num_invs;
+	struct arm_smmu_invs *new_invs;
+	size_t deletes = 0, i, j;
+	u64 existed = 0;
+
+	/* Max of add_invs->num_invs is 64 */
+	if (WARN_ON(add_invs->num_invs > sizeof(existed) * 8))
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i != old_invs->num_invs; i++) {
+		struct arm_smmu_inv *cur = &old_invs->inv[i];
+		/* Count the trash entries to deletes */
+		if (cur->todel) {
+			WARN_ON_ONCE(refcount_read(&cur->users));
+			deletes++;
+		}
+		for (j = 0; j != add_invs->num_invs; j++) {
+			if (!same_op(cur, &add_invs->inv[j]))
+				continue;
+			/* Found duplicated entries in add_invs */
+			if (WARN_ON_ONCE(existed & BIT_ULL(j)))
+				continue;
+			/* Revert the todel marker for reuse */
+			if (cur->todel) {
+				cur->todel = false;
+				deletes--;
+			}
+			/* Store the new location of this existing op in id */
+			add_invs->inv[j].id = i - deletes;
+			existed |= BIT_ULL(j);
+			need--;
+			break;
+		}
+	}
+
+	need -= deletes;
+
+	new_invs = arm_smmu_invs_alloc(need);
+	if (IS_ERR(new_invs)) {
+		/* Don't forget to revert all the todel markers */
+		for (i = 0; i != old_invs->num_invs; i++) {
+			if (refcount_read(&old_invs->inv[i].users) == 0)
+				old_invs->inv[i].todel = true;
+		}
+		return new_invs;
+	}
+
+	/* Copy the entire array less all the todel entries */
+	for (i = 0; i != old_invs->num_invs; i++) {
+		if (old_invs->inv[i].todel)
+			continue;
+		new_invs->inv[new_invs->num_invs++] = old_invs->inv[i];
+	}
+
+	for (j = 0; j != add_invs->num_invs; j++) {
+		if (existed & BIT_ULL(j)) {
+			unsigned int idx = add_invs->inv[j].id;
+
+			refcount_inc(&new_invs->inv[idx].users);
+
+			/* Restore the id of the passed in add_invs->inv[j] */
+			add_invs->inv[j].id = new_invs->inv[idx].id;
+		} else {
+			unsigned int idx = new_invs->num_invs;
+
+			new_invs->inv[idx] = add_invs->inv[j];
+			refcount_set(&new_invs->inv[idx].users, 1);
+			new_invs->num_invs++;
+		}
+	}
+
+	WARN_ON(new_invs->num_invs != need);
+
+	/*
+	 * A sorted array allows batching invalidations together for fewer SYNCs.
+	 * Also, ATS must follow the ASID/VMID invalidation SYNC.
+	 */
+	sort_nonatomic(new_invs->inv, new_invs->num_invs,
+		       sizeof(add_invs->inv[0]), arm_smmu_invs_cmp, NULL);
+	return new_invs;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_add);
+
+/**
+ * arm_smmu_invs_del() - Remove @del_invs from @old_invs
+ * @old_invs: the old invalidation array
+ * @del_invs: an array of invlidations to delete
+ *
+ * Return: a newly allocated and sorted invalidation array on success, or an
+ * ERR_PTR.
+ *
+ * This function must be locked and serialized with arm_smmu_invs_add/dec(),
+ * but do not lockdep on any lock for KUNIT test.
+ *
+ * Caller is resposible for freeing the @old_invs and the returned one.
+ *
+ * Entries marked as trash will be completely removed in the returned array.
+ */
+VISIBLE_IF_KUNIT
+struct arm_smmu_invs *arm_smmu_invs_del(struct arm_smmu_invs *old_invs,
+					struct arm_smmu_invs *del_invs)
+{
+	size_t need = old_invs->num_invs;
+	struct arm_smmu_invs *new_invs;
+	size_t i, j;
+
+	if (WARN_ON(old_invs->num_invs < del_invs->num_invs))
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i != old_invs->num_invs; i++) {
+		struct arm_smmu_inv *cur = &old_invs->inv[i];
+		/* Skip any trash entry */
+		if (cur->todel) {
+			WARN_ON_ONCE(refcount_read(&cur->users));
+			need--;
+			continue;
+		}
+		for (j = 0; j != del_invs->num_invs; j++) {
+			if (!same_op(cur, &del_invs->inv[j]))
+				continue;
+			/* Found duplicated entries in del_invs */
+			if (WARN_ON_ONCE(cur->todel))
+				continue;
+			/* Mark todel. The deletion part will take care of it */
+			cur->todel = true;
+			if (refcount_read(&cur->users) == 1)
+				need--;
+		}
+	}
+
+	new_invs = arm_smmu_invs_alloc(need);
+	if (IS_ERR(new_invs)) {
+		/* Don't forget to revert all the todel markers */
+		for (i = 0; i != old_invs->num_invs; i++) {
+			if (refcount_read(&old_invs->inv[i].users) != 0)
+				old_invs->inv[i].todel = false;
+		}
+		return new_invs;
+	}
+
+	for (i = 0; i != old_invs->num_invs; i++) {
+		struct arm_smmu_inv *cur = &old_invs->inv[i];
+		unsigned int idx = new_invs->num_invs;
+
+		/* Either a trash entry or a matched entry for a dec-and-test */
+		if (cur->todel) {
+			/* Can't do refcount_dec_and_test() on a trash entry */
+			if (refcount_read(&cur->users) <= 1)
+				continue;
+			refcount_dec(&cur->users);
+			cur->todel = false;
+		}
+		new_invs->inv[idx] = *cur;
+		new_invs->num_invs++;
+	}
+
+	WARN_ON(new_invs->num_invs != need);
+
+	/* Still sorted */
+	return new_invs;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_del);
+
+/**
+ * arm_smmu_invs_dec() - Find in @invs for all entries in @del_invs, decrease
+ *                       the user counts without deletions
+ * @invs: a given invalidation array
+ * @dec_invs: an array of invlidations to decrease their user counts
+ *
+ * Return: the actual number of invs in the array, excluding all trash entries
+ *
+ * This function will not fail. Any entry with users=0 will be marked as trash.
+ * All trash entries will remain in the @invs until being completely deleted by
+ * the next arm_smmu_invs_add() or arm_smmu_invs_del() function call.
+ *
+ * This function must be locked and serialized with arm_smmu_invs_add/del(), but
+ * do not lockdep on any lock for KUNIT test.
+ *
+ * Note that the @invs->num_invs will not be updated, even if the actual number
+ * of invalidations are decreased. Readers should take the read lock to iterate
+ * each entry and check its users counter until @inv->num_invs.
+ */
+VISIBLE_IF_KUNIT
+size_t arm_smmu_invs_dec(struct arm_smmu_invs *invs,
+			 struct arm_smmu_invs *dec_invs)
+{
+	size_t num_invs = 0, i, j;
+	unsigned long flags;
+
+	/* Driver bug. Must fix rather, but do not fail here */
+	if (WARN_ON(invs->num_invs < dec_invs->num_invs)) {
+		for (i = 0; i != invs->num_invs; i++) {
+			if (!invs->inv[i].todel)
+				num_invs++;
+		}
+		return num_invs;
+	}
+
+	/* We have no choice but to lock the array while editing it in place */
+	write_lock_irqsave(&invs->rwlock, flags);
+
+	for (i = 0; i != invs->num_invs; i++) {
+		for (j = 0; j != dec_invs->num_invs; j++) {
+			if (same_op(&invs->inv[i], &dec_invs->inv[j]) &&
+			    refcount_dec_and_test(&invs->inv[i].users)) {
+				/* Set the todel marker for deletion */
+				invs->inv[i].todel = true;
+				break;
+			}
+		}
+		if (!invs->inv[i].todel)
+			num_invs++;
+	}
+
+	write_unlock_irqrestore(&invs->rwlock, flags);
+	return num_invs;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_dec);
+
 /*
  * Based on the value of ent report which bits of the STE the HW will access. It
  * would be nice if this was complete according to the spec, but minimally it
@@ -2468,13 +2726,21 @@ static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
 struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
+	struct arm_smmu_invs *new_invs;
 
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
 		return ERR_PTR(-ENOMEM);
 
+	new_invs = arm_smmu_invs_alloc(0);
+	if (IS_ERR(new_invs)) {
+		kfree(smmu_domain);
+		return ERR_CAST(new_invs);
+	}
+
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
+	rcu_assign_pointer(smmu_domain->invs, new_invs);
 
 	return smmu_domain;
 }
-- 
2.43.0

