Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947A30EF63;
	Mon,  8 Sep 2025 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374147; cv=fail; b=sod4rRNUarQSjYS6XWaCDUP02NHKezsNz0QnDxQ50RfdmYKNY+tH9SGU3kx/wBw6QO9yG5bAxmoFITcuUMfT/QbIinh9Kab6sV7Y1tyLbX2rqwXUp/A3EFpmRt/PkLYT6uMH5DEkweHNRB8FIcUT2KBZwvEJNDgFlueusTu2Qvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374147; c=relaxed/simple;
	bh=fCW2A9Aol5vTUEEFdnFWsgx7ZMspjy31R9kWtADIplc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyAIOo5HcRTOh0jQ+qRNezmzgArdvu4zY7EYfbHodjchcsipwO3gLjqG3KEETy+FjC0sLxvzjaI8y7mO1Agu8MBKFa4iML/bkbASYDCE8BvW5dJrKEkRqE6VV70RlEfapGe5eg+Ag+y2xk91LR6uSH0UDIydp3zy0asnIFBtgoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uI3Gi1sn; arc=fail smtp.client-ip=40.107.102.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uI3Gi1sn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOis5llaRcehlyNjy59i77p8lGkpDH83uMdPXxZb8o8NjN66MBJPNsgYl4q4c/lld3W/8Y1pHlUJhNs94n7LJ36078rm4xhIemkM7nGJgfzVIOUbqmJ9b/wZnMk9Px/79ZftuzJv7Eqs2BGnJpqRY3QRIB754HQrqMRgrHI/dSemax/4n99DrjnIIknYbq3XePsYiQOmWcFN15lwgxooM0pRG++FGjSWGJtSf7eiogcRo4os5YNdbVq1xyrwywiDj0cMJPWtx/j0PS/NMLTlUaC6UX1UTh1zQQkRh4olufy4VNaK9EBxSyN52U2FPDkl4mR+kHy0uaGDTkkm935RLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9Rn7EDDOfQSvuY2+fNRUVfcb38rcuyJz1eu7hJI+P0=;
 b=fpx/fpx1uKFhVfGA5gA/exmRmN5MaxzV3xS92ID2/MFxenficBhWkG0ABe8yDVMqDS+oleMk0Uq2FFrnTi63hqNIQQRlaHO244x8b+kSvtCHgbUtL1y8Ju1iSI9Bs5O6JtxBOBOAVQitn/jr62Y9GU2afmOywh+YQk5MhwXsKmqsFg76TJk3Ujn0YaNv+eC9E10Z3jSWK7f992TQQkuM+P/R925zjBKDyEynWc+oWbRVQ1gZm1gJ6oScxojjOqxxln8tXVVApr1Ag64JcicLjHkbs/zZeAuV4jfHG2zySWW2YiBpLzfVX3T2Pq0R+AUVZD587OU9aNBJA8x+Ny3Y+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9Rn7EDDOfQSvuY2+fNRUVfcb38rcuyJz1eu7hJI+P0=;
 b=uI3Gi1snKyzWavjQe8W3G+yYGVpQfeVxzpE2S7vQbuBeNgh/K8aYDQ8m76JRipVmdRkm5LYQGVzlTKwlVzIxPEFyau4Zn2ux5wGL7rfk5UaF8r+RDRiBtKVpfpDCgVsoqtb/lIwJZdQKRZJsNMRHoGy+GerntOqVA5dFlXvs9idV/82xVxUgk0wZOyAaVemXXwpaoZ4jycAxR5WxL4JZkiNtVKelcLCchESPeJByuV7HeWK/2eMWBd7RHn0iyAb53AO2wpqcmq+e23D1sxGuHZRS6vI5Xpio/Yn1nNmNlzK5YnY1a0fauTqPRcjwpt5tR5fq+XvnKocQnNNTj9dISA==
Received: from BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15)
 by BN5PR12MB9512.namprd12.prod.outlook.com (2603:10b6:408:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:28:57 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::b1) by BY5PR03CA0005.outlook.office365.com
 (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 23:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:42 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:42 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:41 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 4/8] iommu/arm-smmu-v3: Introduce a per-domain arm_smmu_invs array
Date: Mon, 8 Sep 2025 16:26:58 -0700
Message-ID: <80310b98efa4bd7e95d7b3ca302f40d4d69e59c5.1757373449.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|BN5PR12MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e6e64cf-5ba2-4468-96ec-08ddef2f7b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jp5jVU+9epL3Q0ZfpPNCO4JQ9FEbWmDZuX/kosVxTfF3HSCn1UJnITEQbgXf?=
 =?us-ascii?Q?hMauzhaD6j5+DLNzZydhNmuicJ64O+usyaL10vG4WrO3M2KiZe9zNflxGYvy?=
 =?us-ascii?Q?DpZ8zKrJIZDWBuGDvGDNp+rEvXJt8d+RgwJ89eDlqPDpt5aJT1ZcutciWgh9?=
 =?us-ascii?Q?PvIA/hIujrlP1/KnK7+8C7A30cIO0KOpWD8C3sk9Dmekzby141SDbQefZqoQ?=
 =?us-ascii?Q?3Vj30dcWS5fKjHIIWI+L/BXpcId55JGkYC7J5ITaU4uCtTAymxagbqGqOuIe?=
 =?us-ascii?Q?8VR0nIIHUnJj4SxeN6WEOUqHdRRaA00Gum2DKY6W6Y9hO3J+/uTKH2XVTqZc?=
 =?us-ascii?Q?PqoaQ+6yvjyXBsx4R3i6un/9FrvnEQCiZF+gHngo51hpHLdUolUOEmtNYKNw?=
 =?us-ascii?Q?Yhmx4F2sDlhdhPQGHsR5zqrHyQyGEnEyxfdc6bwwRxRaHrGeaVXLE3JDDLTb?=
 =?us-ascii?Q?168hfiCraKdZKD5Qcba0DdmWvLUvmSKqhh6Na7I6AbGqa/cTkf2UHA/fsfHx?=
 =?us-ascii?Q?PQQBkzVeXjXCTuJO8kryVicp2MWeMD3a0rf8kUrlT6Us2ojSlmwj8PtEY+XY?=
 =?us-ascii?Q?A5ILdfoZou8V2SJhWnURAKhD/TWqoA9JTsOPmNqReWszqub83VWfypDtS+k3?=
 =?us-ascii?Q?j+GU/jWd4Jwok+zpuqe8CsgYKxe9DMIn3bdj4lHwWg3WJDYSphfg+sDknWB9?=
 =?us-ascii?Q?A+Do92xxOqsqhzj8PY4WuNZUdwhBA6+7JM9kbOsFB7Tf4ewE5Gv5Tn2ROqB6?=
 =?us-ascii?Q?2HzBqE5gADE4+0kHE7MSPJZdNaXG6Ul3I9MRxIxvlFMQ5CENJzCXB+5SXFUz?=
 =?us-ascii?Q?68vJ49m/56DED//kG4xhrxzRykzy+5vvzg88Tt5xoOEmIZX012WCuOMnF3Tg?=
 =?us-ascii?Q?LOaE1kqVbbOw/dY8LmX0UfrKQd52Sl9fcO+G6qZzo5goNn2mMyUHjTURHofb?=
 =?us-ascii?Q?HZTbLA1sj/Qw5u06blP1bdRRdfnMf3xwxVGZ5RE3/O1EZv3NTsSMY8IwqgmL?=
 =?us-ascii?Q?nyhuZBQUFTkQXUi9hdeKpMdyb/Pk6Yh+elSAp6qIJCCag3VS+xvf6UuloJ/N?=
 =?us-ascii?Q?pdQZK5Ti6uTrbpBvyrOjkm7YWdfMAg31GauOJqgXiEyngjQ7HgdjcWHKlH7I?=
 =?us-ascii?Q?ckJxkH/9HXyn/HAwyeU+eT2ushaB7i8GD3jiKAjiHEDyaY8ZwZFxnWu0dohZ?=
 =?us-ascii?Q?b+ObSDsb6EdOzhvY01ZrVifDdjeHRwaX+Mu5MkoO6qDuBvMjUlu/tqJ6i/li?=
 =?us-ascii?Q?CWBV735R9ss6rL36SzVAcTSvk3EremNorMnJvXHgdc5VhQTWSRQh1BTzpyKK?=
 =?us-ascii?Q?mgXbEWUglEbviCw8nkD1+fPhISTk4s0Zw0/tfxMlYrK/7dYd0r6xP/Fo1Qw9?=
 =?us-ascii?Q?PM739SLICdLltOaYO30kmJc6a/tZTYkOk3kvUAjJShaTpjcfwAIqm/KYrMPb?=
 =?us-ascii?Q?ISjMis0dMQJpIuVh3TGkjxuCpxmtMFeLFeywoJIBv//5mSulOAIoiDRvo+eb?=
 =?us-ascii?Q?5WRXuhycp8yP4q/SfhbiuLYSSVAVkDZVITxR?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:56.6105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6e64cf-5ba2-4468-96ec-08ddef2f7b46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9512

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

Provide a set of APIs to add/delete entries to/from an array, which cover
cannot-fail attach cases, e.g. attaching to arm_smmu_blocked_domain. Also
add kunit coverage for those APIs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Co-developed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  79 +++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  93 ++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 212 ++++++++++++++++++
 3 files changed, 384 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 96a23ca633cb6..34fcc1a930e6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -649,6 +649,82 @@ struct arm_smmu_cmdq_batch {
 	int				num;
 };
 
+/*
+ * The order here also determines the sequence in which commands are sent to the
+ * command queue. E.g. TLBI must be done before ATC_INV.
+ */
+enum arm_smmu_inv_type {
+	INV_TYPE_S1_ASID,
+	INV_TYPE_S2_VMID,
+	INV_TYPE_S2_VMID_S1_CLEAR,
+	INV_TYPE_ATS,
+	INV_TYPE_ATS_FULL,
+};
+
+struct arm_smmu_inv {
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
+	refcount_t users; /* users=0 to mark as a trash to be purged */
+};
+
+/**
+ * struct arm_smmu_invs - Per-domain invalidation array
+ * @num_invs: number of invalidations in the flexible array
+ * @rcu: rcu head for kfree_rcu()
+ * @inv: flexible invalidation array
+ *
+ * The arm_smmu_invs is an RCU data structure. During a ->attach_dev callback,
+ * arm_smmu_invs_merge(), arm_smmu_invs_unref() and arm_smmu_invs_purge() will
+ * be used to allocate a new copy of an old array for addition and deletion in
+ * the old domain's and new domain's invs arrays.
+ *
+ * The arm_smmu_invs_unref() mutates a given array, by internally reducing the
+ * users counts of some given entries. This exists to support a no-fail routine
+ * like attaching to an IOMMU_DOMAIN_BLOCKED. And it could pair with a followup
+ * arm_smmu_invs_purge() call to generate a new clean array.
+ *
+ * Concurrent invalidation thread will push every invalidation described in the
+ * array into the command queue for each invalidation event. It is designed like
+ * this to optimize the invalidation fast path by avoiding locks.
+ *
+ * A domain can be shared across SMMU instances. When an instance gets removed,
+ * it would delete all the entries that belong to that SMMU instance. Then, a
+ * synchronize_rcu() would have to be called to sync the array, to prevent any
+ * concurrent invalidation thread accessing the old array from issuing commands
+ * to the command queue of a removed SMMU instance.
+ */
+struct arm_smmu_invs {
+	size_t num_invs;
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
+	new_invs->num_invs = num_invs;
+	return new_invs;
+}
+
+struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
+					  struct arm_smmu_invs *to_merge);
+size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
+			   struct arm_smmu_invs *to_unref);
+struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs,
+					  size_t num_dels);
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
@@ -875,6 +951,8 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	struct arm_smmu_invs __rcu	*invs;
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
index d2671bfd37981..417a2b5ea2024 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -567,6 +567,98 @@ static void arm_smmu_v3_write_cd_test_sva_release(struct kunit *test)
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
+		 { .type = INV_TYPE_ATS, .id = 4, },
+		 { .type = INV_TYPE_ATS, .id = 5, }, },
+};
+
+static struct arm_smmu_invs invs3 = {
+	.num_invs = 3,
+	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
+		 { .type = INV_TYPE_ATS, .id = 6, }, },
+};
+
+static void arm_smmu_v3_invs_test(struct kunit *test)
+{
+	const int results1[2][3] = { { 1, 2, 3, }, { 1, 1, 1, }, };
+	const int results2[2][5] = { { 1, 2, 3, 4, 5, }, { 2, 1, 1, 1, 1, }, };
+	const int results3[2][5] = { { 1, 2, 3, 4, 5, }, { 1, 1, 1, 0, 0, }, };
+	const int results4[2][5] = { { 1, 2, 3, 5, 6, }, { 2, 1, 1, 1, 1, }, };
+	const int results5[2][5] = { { 1, 2, 3, 5, 6, }, { 1, 0, 0, 1, 1, }, };
+	const int results6[2][5] = { { 1, 2, 3, 5, 6, }, { 0, 0, 0, 0, 0, }, };
+	struct arm_smmu_invs *test_a, *test_b;
+	size_t num_dels;
+
+	/* New array */
+	test_a = arm_smmu_invs_alloc(0);
+	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+
+	/* Test1: merge invs1 (new array) */
+	test_b = arm_smmu_invs_merge(test_a, &invs1);
+	kfree(test_a);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results1[0]),
+				     results1[0], results1[1]);
+
+	/* Test2: merge invs2 (new array) */
+	test_a = arm_smmu_invs_merge(test_b, &invs2);
+	kfree(test_b);
+	arm_smmu_v3_invs_test_verify(test, test_a, ARRAY_SIZE(results2[0]),
+				     results2[0], results2[1]);
+
+	/* Test3: unref invs2 (same array) */
+	num_dels = arm_smmu_invs_unref(test_a, &invs2);
+	arm_smmu_v3_invs_test_verify(test, test_a, ARRAY_SIZE(results3[0]),
+				     results3[0], results3[1]);
+	KUNIT_EXPECT_EQ(test, num_dels, 2);
+
+	/* Test4: merge invs3 (new array) */
+	test_b = arm_smmu_invs_merge(test_a, &invs3);
+	kfree(test_a);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results4[0]),
+				     results4[0], results4[1]);
+
+	/* Test5: unref invs1 (same array) */
+	num_dels = arm_smmu_invs_unref(test_b, &invs1);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results5[0]),
+				     results5[0], results5[1]);
+	KUNIT_EXPECT_EQ(test, num_dels, 2);
+
+	/* Test6: unref invs3 (same array) */
+	num_dels = arm_smmu_invs_unref(test_b, &invs3);
+	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results6[0]),
+				     results6[0], results6[1]);
+	KUNIT_EXPECT_EQ(test, num_dels, 5);
+
+	/* Test7: purge test_b (new array) */
+	test_a = arm_smmu_invs_purge(test_b, num_dels);
+	kfree(test_b);
+	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+
+	kfree(test_a);
+}
+
 static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_abort),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_bypass),
@@ -590,6 +682,7 @@ static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_s1_stall),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_release),
+	KUNIT_CASE(arm_smmu_v3_invs_test),
 	{},
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 08af5f2d1235a..83d842bd88817 100644
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
@@ -1033,6 +1034,209 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
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
+/*
+ * Merge compare of two sorted arrays items. If one side is past the end of the
+ * array, return the other side to let it run out the iteration.
+ */
+static inline int
+arm_smmu_invs_merge_cmp(const struct arm_smmu_invs *l, size_t l_idx,
+			const struct arm_smmu_invs *r, size_t r_idx)
+{
+	if (l_idx != l->num_invs && r_idx != r->num_invs)
+		return arm_smmu_invs_cmp(&l->inv[l_idx], &r->inv[r_idx]);
+	if (l_idx != l->num_invs)
+		return -1;
+	return 1;
+}
+
+/**
+ * arm_smmu_invs_merge() - Merge @to_merge into @invs and generate a new array
+ * @invs: the base invalidation array
+ * @to_merge: an array of invlidations to merge
+ *
+ * Return: a newly allocated array on success, or ERR_PTR
+ *
+ * This function must be locked and serialized with arm_smmu_invs_unref() and
+ * arm_smmu_invs_purge(), but do not lockdep on any lock for KUNIT test.
+ *
+ * Either @invs or @to_merge must be sorted itself. This ensures the returned
+ * array will be sorted as well.
+ *
+ * Caller is resposible for freeing the @invs and the returned new one.
+ *
+ * Entries marked as trash will be purged in the returned array.
+ */
+VISIBLE_IF_KUNIT
+struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
+					  struct arm_smmu_invs *to_merge)
+{
+	struct arm_smmu_invs *new_invs;
+	struct arm_smmu_inv *new;
+	size_t num_adds = 0;
+	size_t num_dels = 0;
+	size_t i, j;
+
+	for (i = j = 0; i != invs->num_invs || j != to_merge->num_invs;) {
+		int cmp = arm_smmu_invs_merge_cmp(invs, i, to_merge, j);
+
+		if (cmp < 0) {
+			/* no found in to_merge, leave alone but delete trash */
+			if (!refcount_read(&invs->inv[i].users))
+				num_dels++;
+			i++;
+		} else if (cmp == 0) {
+			/* same item */
+			i++;
+			j++;
+		} else {
+			/* unique to to_merge */
+			num_adds++;
+			j++;
+		}
+	}
+
+	new_invs = arm_smmu_invs_alloc(invs->num_invs - num_dels + num_adds);
+	if (IS_ERR(new_invs))
+		return new_invs;
+
+	new = new_invs->inv;
+	for (i = j = 0; i != invs->num_invs || j != to_merge->num_invs;) {
+		int cmp = arm_smmu_invs_merge_cmp(invs, i, to_merge, j);
+
+		if (cmp <= 0 && !refcount_read(&invs->inv[i].users)) {
+			i++;
+			continue;
+		}
+
+		if (cmp < 0) {
+			*new = invs->inv[i];
+			i++;
+		} else if (cmp == 0) {
+			*new = invs->inv[i];
+			refcount_inc(&new->users);
+			i++;
+			j++;
+		} else {
+			*new = to_merge->inv[j];
+			refcount_set(&new->users, 1);
+			j++;
+		}
+		new++;
+	}
+
+	WARN_ON(new != new_invs->inv + new_invs->num_invs);
+
+	return new_invs;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_merge);
+
+/**
+ * arm_smmu_invs_unref() - Find in @invs for all entries in @to_unref, decrease
+ *                         the user counts without deletions
+ * @invs: the base invalidation array
+ * @to_unref: an array of invlidations to decrease their user counts
+ *
+ * Return: the number of trash entries in the array, for arm_smmu_invs_purge()
+ *
+ * This function will not fail. Any entry with users=0 will be marked as trash.
+ * All trash entries will remain in the @invs until being completely deleted by
+ * the next arm_smmu_invs_merge() or an arm_smmu_invs_purge() function call.
+ *
+ * This function must be locked and serialized with arm_smmu_invs_merge() and
+ * arm_smmu_invs_purge(), but do not lockdep on any lock for KUNIT test.
+ *
+ * Note that the @invs->num_invs will not be updated, even if the actual number
+ * of invalidations are decreased. Readers should take the read lock to iterate
+ * each entry and check its users counter until @inv->num_invs.
+ */
+VISIBLE_IF_KUNIT
+size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
+			   struct arm_smmu_invs *to_unref)
+{
+	size_t num_dels = 0;
+	size_t i, j;
+
+	for (i = j = 0; i != invs->num_invs || j != to_unref->num_invs;) {
+		int cmp;
+
+		if (!refcount_read(&invs->inv[i].users)) {
+			num_dels++;
+			i++;
+			continue;
+		}
+
+		cmp = arm_smmu_invs_merge_cmp(invs, i, to_unref, j);
+		if (cmp < 0) {
+			/* not found in to_unref, leave alone */
+			i++;
+		} else if (cmp == 0) {
+			/* same item */
+			if (refcount_dec_and_test(&invs->inv[i].users))
+				num_dels++;
+			i++;
+			j++;
+		} else {
+			/* item in to_unref is not in invs or already a trash */
+			WARN_ON(true);
+			j++;
+		}
+	}
+	return num_dels;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_unref);
+
+/**
+ * arm_smmu_invs_purge() - Purge all the trash entries in the @invs
+ * @invs: the base invalidation array
+ * @num_dels: expected number of trash entries, typically the return value from
+ *            a prior arm_smmu_invs_unref() call
+ *
+ * Return: a newly allocated array on success removing all the trash entries, or
+ *         NULL on failure
+ *
+ * This function must be locked and serialized with arm_smmu_invs_merge() and
+ * arm_smmu_invs_unref(), but do not lockdep on any lock for KUNIT test.
+ *
+ * Caller is resposible for freeing the @invs and the returned new one.
+ */
+VISIBLE_IF_KUNIT
+struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs,
+					  size_t num_dels)
+{
+	struct arm_smmu_invs *new_invs;
+	size_t i, j;
+
+	if (WARN_ON(invs->num_invs < num_dels))
+		return NULL;
+
+	new_invs = arm_smmu_invs_alloc(invs->num_invs - num_dels);
+	if (IS_ERR(new_invs))
+		return NULL;
+
+	for (i = j = 0; i != invs->num_invs; i++) {
+		if (!refcount_read(&invs->inv[i].users))
+			continue;
+		new_invs->inv[j] = invs->inv[i];
+		j++;
+	}
+
+	WARN_ON(j != new_invs->num_invs);
+	return new_invs;
+}
+EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_purge);
+
 /*
  * Based on the value of ent report which bits of the STE the HW will access. It
  * would be nice if this was complete according to the spec, but minimally it
@@ -2468,13 +2672,21 @@ static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
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

