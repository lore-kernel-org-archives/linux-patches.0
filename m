Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C030C603;
	Mon,  8 Sep 2025 23:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374145; cv=fail; b=gdC8EyOXlmipFwmmnpVB62dHoUm4/GFtbDIwc4KHtF23bOQ891qn5qC/9qox/Fl06BhUeVjj6yM/lzflqEbL9dU36f9w1Z2ifN4BRGwjNLsa4YTku/2aP7m7YDOp6AyugP6ID1yQ1OSHPNd2HFyamQA6UE3fTudgsTPbwStbSM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374145; c=relaxed/simple;
	bh=PpjbkdTbRmQPxmDGd6jyaHuY7x3CzOBBm1Zc7LpcYyQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dr0gnPYu3kDTIb1sKsbJnCSnwDuKX4UEiYKgtOAfU4XhDfuAjYZGHBfJxJOZlyXM1eAr6B7S+gJCQMny7Fn9Jcb1i+qWAS4gO0KwMOn7vyJHls3uBYXUA1ywOicPT6KPb4lM2hQoHCwqjAAy9avzAojswLk4MpG5wYQK5O2zwpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HC8fa6Vw; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HC8fa6Vw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpsT75PfUM+eO3mXW5CyuEXBHnNpHJmg818QYV/s0/Qk/K8zFiUNf0hykT30rtrHJicw78Uo1yL5GnYdYhWpaaSG81sCM4kT5kFZf9Vou0g7WGf2eMAP1goc7Y78/jKpt/eIy0nXy/7evexlkRGG4ODmmoYp2/04jwRSRMr6t5zg7Alj5a/yujfBBKgS9iZUUbfCvH92WFHVhsvb68vsg9zYcytRF7DL+V09ZKXXfBYZ5Gao2xP6S3TDtBQfuK3Xw8or1isdQ0nkJsmRcya0T5N3RPD5Y2zN3NzbddKJPKK4ucTVuPgCUUOSPHkgCEBs5ITJhJC71NQ3pVFHRxo9LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7DRPvB6MmFLFzvYRE/FnZgmWwUKgD++V8mEgs0bl0E=;
 b=ZFytl2yxdGDvCRtqTSlZ/7DhRxx+tDmI/7QyHMtsdfh+ydJKIjum4nGMN7lKG6Ud4p645X0/4FT+lND79XgW+jZxI7F6jOgKG5uzuG7JvVN0CZHbWtc+Xa0Wo9HQq5oWUR0rswb4X8S76QT9la3v5hUGivfX80dWJ7erMIogEIdNJdVdLIbbFWT3uh+2J58dWlOx95aYAi0Uk3poWq4XJvchWRqmMU5bnw8awiieU6/rn5xuk2DC87Vi5AINNoiq5fz0JFeSde1MH3YEi3Lok/7Aunmvq2oqYM2j79ME4OIbZQayEvRn99as+SM2QOHqMNp3vPslCdgUMYsgD7JSlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7DRPvB6MmFLFzvYRE/FnZgmWwUKgD++V8mEgs0bl0E=;
 b=HC8fa6VwEz4pmZPXo16HBPtFdwEk8uK/u2BXcHxQSF17Nk3N47iouD8Nh1X/JKMQb49I3hnPPA3pjixtQDiID1WNT1Ftah3wFV1Xmc2Pu9AU1zJ2uQbbV5J/XKHGfI8/SPVgnrw6ivNU8IN35PhGncJloQe6W+Wb1HoWzw/Iyp5cM77zrjnOyGm0vSRxtU0A+V0FkoE+eLXxfmekExerR0d+6a1dZt1gmh5+MLuCOyJNqMKKq1OkwEECXwiLPKN/YpAvgNfpAwvowq97G1I9MeS5ZjbG1IpS0puz0wERSjaWslKlskQlgAtpD8j/MfhSEQCm5THooYGHjsCSx7XKTA==
Received: from CY5PR15CA0250.namprd15.prod.outlook.com (2603:10b6:930:66::24)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:28:58 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:930:66:cafe::4f) by CY5PR15CA0250.outlook.office365.com
 (2603:10b6:930:66::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 23:28:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 23:28:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 16:28:43 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 16:28:43 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 16:28:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv2 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master invalidation array
Date: Mon, 8 Sep 2025 16:26:59 -0700
Message-ID: <f5f635077b791b27b46ea41b5c86a52fd4549a44.1757373449.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ba50bc-eb57-4a8f-3ef0-08ddef2f7ba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qs5VnTOFL4iO9/z4fGeW+ZlT3oJjVN9Lvcp0q544vKhvMXPZPLsyf9N9/WCX?=
 =?us-ascii?Q?fZCkSjt6bQUEBaUcVUbOSXx1/w13FhXhnRYbjH+tY2XUMG13IYi5nlYOOzyf?=
 =?us-ascii?Q?aGZRaoXt0F83MsObgUB8e3EELgV3A1UICmSnPL0fbu3HvZ88KlQdG7AT/LGq?=
 =?us-ascii?Q?DwBNMRpj0t8tpapftMtKGPT+rvViZSeRuVhNG4ktnhnm78uMvM7E3JcY3XYD?=
 =?us-ascii?Q?lC/2ZNSk96zVlVKVR8otJCne40konny4J5tGFZwSnd8O5VOmwTClLrbdTUS9?=
 =?us-ascii?Q?xHW8FvbbIqAG9O6E3wGN5s/vLcTstBxsJ+5fGMpI5at93cdJ8VLtpcNjGKW0?=
 =?us-ascii?Q?SCfZ0RYMRsjAt0XhlvwSnHFc/AlUSTaLyCKZyzlZvyVTnkgEX7I7F4OFEMkB?=
 =?us-ascii?Q?uMVIcyysgPoWs48KAAmnYe2Q/WpsJ8N+2RQYYjwwXNZUfbVqrZwkkuokDK6O?=
 =?us-ascii?Q?DxutDG9ZzdOi7oaJ/9lO9wFcxTbMA3vJP7DNVLm8G+CIP735zwkiJYaaBRux?=
 =?us-ascii?Q?hNWOqAFO9PoImIy/M3zbICqKTV23bGbx7BwbKc7+ZbxqviwZKEUbQEmUyFf5?=
 =?us-ascii?Q?EfHq11emY+2Qofi2eusUXFotqyrBl5X6fMEtJEZYebVVGUEyGn/+fjP1nj+c?=
 =?us-ascii?Q?0711ERsLz3Uo2h0D52lIuCB/Vr/cw/LwrYsbloJJKTzXaud62UTvNHnPDpho?=
 =?us-ascii?Q?LpXCohSLBcDoQWpXt7LT/y9eVnIg5SfLtFcukm3jf8PA7Z+517NCch6P20s9?=
 =?us-ascii?Q?UuYwn46+cWpfjtYZyMVytmZsdh6KXtJzDV2LE80oJEWRrlcuENk0ROnXXQei?=
 =?us-ascii?Q?Q1RgahDSkeGYHZU4nnKeb6JRh+8Tp+HJb6SyxBe1xfrw9qSDkyVFi/Sreuyg?=
 =?us-ascii?Q?2EXLE0SgvfT53jCWwwWDk+/DuxMZJYEZ+rwa0Ovv1dwfYVneCyVe9Zi/0ejn?=
 =?us-ascii?Q?taDEa2v+8S1679U5H3SVCeWNKe+L5sC3o1c6eUY7E1NcFM/6btQjZIqyS1KL?=
 =?us-ascii?Q?r5U6VSwRwcsRwqukpPj/zmuEKcOZ2AZZ3r0wLebt2V1pr38BbiZFp/0fgm6y?=
 =?us-ascii?Q?YO9gQpER0aYQihZmen7F6+JRMkR08yWg0kofHHlTR1bfiuNk/FsHB2BkH4tw?=
 =?us-ascii?Q?yyo7cF17jDgLUuTZwAG5AgUot9fzjRi03cOLtnYVIxZ0/vsoduckpnUxYOfD?=
 =?us-ascii?Q?VNU+EGcqZa0vLdXEHSo+ZM0XiCmPhJnL+25fGtyitishnh+OFuQXLPA362mX?=
 =?us-ascii?Q?ey7Cj40nm1IJYHQiDZ39lWF9CDETjlGSgohsMZAaLpkyG/ZlS/9ZKgyrEmGx?=
 =?us-ascii?Q?fK29rEzpo6jmj9uFI2j9fzLM0r+SqP3kBYkd4Nt3qGqmBmfWMu0lnIkxqMXp?=
 =?us-ascii?Q?F3LYgulucW21FTUJ58uJM7oH9qnssOZSHJ49GzrODPibjhIOwH3GWdWPOEXR?=
 =?us-ascii?Q?Y452A3cMEP1/vexwCejT2i66Dx8KiVf7vSdZPfMjzYzYH1BWY2MYPh3oGQ8+?=
 =?us-ascii?Q?vm3PuC4IgMRe2n7zGX5PUYtYN1wRPk1lZVuc?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:28:57.2008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ba50bc-eb57-4a8f-3ef0-08ddef2f7ba1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001

When a master is attached from an old domain to a new domain, it needs to
build an invalidation array to delete and add the array entries from/onto
the invalidation arrays of those two domains, passed via the to_merge and
to_unref arguments into arm_smmu_invs_merge/unref() respectively.

Since the master->num_streams might differ across masters, a memory would
have to be allocated when building an to_merge/to_unref array which might
fail with -ENOMEM.

On the other hand, an attachment to arm_smmu_blocked_domain must not fail
so it's the best to avoid any memory allocation in that path.

Pre-allocate a fixed size invalidation array for every master. This array
will be used as a scratch to fill dynamically when building a to_merge or
to_unref invs array.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 +++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 +++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 34fcc1a930e6a..246c6d84de3ab 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -919,6 +919,14 @@ struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
 	struct arm_smmu_stream		*streams;
+	/*
+	 * Scratch memory for a to_merge or to_unref array to build a per-domain
+	 * invalidation array. It'll be pre-allocated with enough enries for all
+	 * possible build scenarios. It can be used by only one caller at a time
+	 * until the arm_smmu_invs_merge/unref() finishes. Must be locked by the
+	 * iommu_group mutex.
+	 */
+	struct arm_smmu_invs		*build_invs;
 	struct arm_smmu_vmaster		*vmaster; /* use smmu->streams_mutex */
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 83d842bd88817..4e69c81f5a28b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3663,12 +3663,22 @@ static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
 	return 0;
 }
 
+static int arm_smmu_ids_cmp(const void *_l, const void *_r)
+{
+	const typeof_member(struct iommu_fwspec, ids[0]) *l = _l;
+	const typeof_member(struct iommu_fwspec, ids[0]) *r = _r;
+
+	return cmp_int(*l, *r);
+}
+
 static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 				  struct arm_smmu_master *master)
 {
 	int i;
 	int ret = 0;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
+	bool ats_supported = dev_is_pci(master->dev) &&
+			     pci_ats_supported(to_pci_dev(master->dev));
 
 	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
 				  GFP_KERNEL);
@@ -3676,6 +3686,20 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		return -ENOMEM;
 	master->num_streams = fwspec->num_ids;
 
+	/* Base case has 1 ASID or 1~2 VMIDs. ATS case adds num_ids */
+	if (!ats_supported)
+		master->build_invs = arm_smmu_invs_alloc(2);
+	else
+		master->build_invs = arm_smmu_invs_alloc(2 + fwspec->num_ids);
+	if (IS_ERR(master->build_invs)) {
+		kfree(master->streams);
+		return PTR_ERR(master->build_invs);
+	}
+
+	/* Put the ids into order for a sorted to_merge or to_unref array */
+	sort_nonatomic(fwspec->ids, fwspec->num_ids, sizeof(fwspec->ids[0]),
+		       arm_smmu_ids_cmp, NULL);
+
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
@@ -3713,6 +3737,7 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		for (i--; i >= 0; i--)
 			rb_erase(&master->streams[i].node, &smmu->streams);
 		kfree(master->streams);
+		kfree(master->build_invs);
 	}
 	mutex_unlock(&smmu->streams_mutex);
 
@@ -3734,6 +3759,7 @@ static void arm_smmu_remove_master(struct arm_smmu_master *master)
 	mutex_unlock(&smmu->streams_mutex);
 
 	kfree(master->streams);
+	kfree(master->build_invs);
 }
 
 static struct iommu_device *arm_smmu_probe_device(struct device *dev)
-- 
2.43.0

