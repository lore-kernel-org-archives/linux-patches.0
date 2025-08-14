Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020BB1CEAC2;
	Thu, 14 Aug 2025 01:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134789; cv=fail; b=Ho37U0kzC3m5+WXyWGwYaIpO3xnyMw1FOE4RjhdVAx9NC9CWOtgTtulfJTAg47sTYNBQf/lzoIG8HdYZxMGZSMCOHkYehSnzlOQ/9D9kKdHNj3sI+J8f0uUa6JZQQULAC89cpnfRBhnPV2Jo4cca4r9eCK6jndlcsnWqIShz1iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134789; c=relaxed/simple;
	bh=nH0ZCGFMbLVKN5l3omEWdqjqkMt6NCla4oFmOoWZM0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TEfeZc/4iBkhxMiycC5FZQZyPr4z+A+WzXu7rV0EML25t9ENO6YF1hZ8F1NCtvQrOVFxQ4J7ZD31oNf7zdOlxagoScDHId8Mc5NzMRWtalMs+EmNYrpE5DeQkXI7u0bzk0J43pLjtowEMjZBSxzNyWI+WLeSNmNH4O9NmFApbRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lci6uVBP; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lci6uVBP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHEk/wG7uWO48VY0AYZPEkU9RA687s5jMM6vMzrckqbjdaDMxSYQkVNgPEq29srpdAczQvftzCWdeemIkCUrlLIebwl8BdNxcVaKF9EeXL7gOEiiJj6QtwQM9wBvUl29XbUsIKFU62KnB2wOqIF54J5pYpQIDdi/Wr54FIw6pGaQa9ousn/hvowlmJJPVqvJs5ZRjRMxXWssXV+Q3iU08I/RGVqNwqEAVspQnm8TzdZ/heUJvTdFpeB5v8os4U/stHWAQxR34j+EKj9LES4O0ygwUbe0lhhA74C83Y0yv9o+n5QUhMJC6rxLmlt+ntAd8Ykh92Cbgb2bJPJJt1vhPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4MrySLSyWxepi/Xp8MMnwcDI2CQDt0kK96IuuLqhZg=;
 b=dcXrBHQqPAxJiMDUmCfVwhSsg63qKNMVj5c+HkW+heiAU7eVMN7P9L8tpdk9vHudcq+fCm9QGOjX8aCZ6z/HslGmTv5U0X3XN4gda23jP3yEkyavyz17H8UjeNdBxaFS+Oo+sHrW/M0BjsYLoW0uDETZP+l8pEuIFkMCyJylwdla8IcNhx/uQKW4LUnLHwU/gW8kn5VqYw3OISX4CAJ+B11ZjZR3VhBdTqS2tGXzrwkrPT2iZECuxxDXW3ZWtK0u5ZG/RDAzbCXGBgmBG5k9h6VTg5MlAqzPJLZkwznM1XsWqJcS0pGgNO1+4FW2KYN/h/1TW5aDABie3WGjJI55wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4MrySLSyWxepi/Xp8MMnwcDI2CQDt0kK96IuuLqhZg=;
 b=lci6uVBPT2MpgoaDG2bv090zNAJWh99rjT0mgfSUq/gZ1El+8C/UFdL99JVc/O+uJvjLGRoWa0m0iL+XxMqd1xNa0BpJ6H+Ip6LkdNe8ioO32nxGTZygBuzOHSekPF7G93gRMvozTUik9mKOTkNZuWPCdMFObjlxqTL8xYinZI4UPZA4xsAT5oTeLlAQgBfi/XdQ8fiRup6OsEeORf0wc0UT27FAJ+094i+p9YnC4s0qaYD91gQiimp+XwEvii+aB9/x0/Wc/FYcmdHJlThE6jkTsedWa7pGdxCkxP4SfB295pVDl+Tsiwjl+kM8lrj8r8Q4OLRu+m5F7UKCZAzcGg==
Received: from BN9PR03CA0653.namprd03.prod.outlook.com (2603:10b6:408:13b::28)
 by PH7PR12MB8794.namprd12.prod.outlook.com (2603:10b6:510:27d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 01:26:23 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::6f) by BN9PR03CA0653.outlook.office365.com
 (2603:10b6:408:13b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 01:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:08 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:07 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:06 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master invalidation array
Date: Wed, 13 Aug 2025 18:25:36 -0700
Message-ID: <2b55869f698340d5791210b9a7e542f81ad20bcb.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|PH7PR12MB8794:EE_
X-MS-Office365-Filtering-Correlation-Id: df1fcaaa-59fa-4ec1-b041-08dddad19439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D7mFmEh4UERTsC9hSWeyjy7JNljFs/+u0wmazcfk2NzMVTjLmDM+zZWj+9Ma?=
 =?us-ascii?Q?NGe38KP3iCgMgWNRlanVI+8xwlwdTxbaCtQDRqpGKgGkZnzGAozK8M8uJqN0?=
 =?us-ascii?Q?MsY4PIEHFev3ub11VdZ2OJoX0m0jGHsBWhRq+NSi7wRxj+VTkTbRteUk3cwk?=
 =?us-ascii?Q?wsbZT/z3BTWVIRdAwex14JBUlLlK88+mBnGIHoQHW8iDfAWAX3mzem08LUt6?=
 =?us-ascii?Q?euv5VbOoCfdairFTtNjexnx4ts6bTTNL6pz2uQ9ZMWlvlKe5+1dnxxSiQGIv?=
 =?us-ascii?Q?hczBVWH+08Nj1j0RT3W3ACaLfWj8Hkj9Y1I/5oYE3QbnQekavYKxxt5ORf8Z?=
 =?us-ascii?Q?SW1bZbVfIbuMqFjfgqOTKmfzuRIf6rFBFipGA2Iui5NRmJiUIjD6EGwqLZcj?=
 =?us-ascii?Q?t++zvlYK/kLEMDt7OgxPeZRSxOeBgVHP5aeOeMZ0927iVLHv1U98TiKBMu7B?=
 =?us-ascii?Q?ANxTrw0kv8tViNVuiXpyCHcwHrRGCJy/80FeurM06DSLPJ6zzQeN7idOG4hl?=
 =?us-ascii?Q?bgK3RSULl/r8onFN5/pdzNXUq0B8HBtR5eQJfGnidVaTmjzYHbK8NGfageg7?=
 =?us-ascii?Q?SEFP1J10GJs/JLMAW6SKE5QUqI5HaT0XvZiNy/xEY7+l8toc0ovgJrVQBAgI?=
 =?us-ascii?Q?tT2mCtkMy5Rcop1vZnngl/eZnsUtFesfeWCnIjyCvWpPSPRut/LekIF3JfrB?=
 =?us-ascii?Q?6LySO7mQED0V+HuySpQ1QGmpPKASiaZbAjwrHnV3Nxa4DpkIPNvBD2HBpJ0D?=
 =?us-ascii?Q?+HQUL//eh5fWxbWTiM2+lY9XeHXbyWdok12XzHLoMpDlSzVloIwtAeHRj0am?=
 =?us-ascii?Q?nMEF1vw1ERMWslw6oqA1ucnE8pgk7cPKeKn0JDY4lNbZFUjCUMGpzz9ss1Go?=
 =?us-ascii?Q?r5/fsluVymSVW+JelyfNwB8z2mzXR9Sa8QN85wzwTxEfZxSFxHfdw3UAz85l?=
 =?us-ascii?Q?1n0TpO1YFf9mOJvI2H+3Bf5BjucAGL72Q4ZFjkbRsaK6xzp2ATG9jmaEiWG0?=
 =?us-ascii?Q?RK0JyUET4lKsLG2s/WonG65J6vy5l8apBdDugS8L1S4EJUSZOCVIx3xoLWVz?=
 =?us-ascii?Q?1Y2kAVs3PPMuZ7u50NpOWgxJ6pJWde1RGqn6L/bqz5WIDU2R74ZfxPsBcLAz?=
 =?us-ascii?Q?T2h1p533zzMqzQD1Mzc4WmnSiRTCBFEoLqMmhla3NvWB43P64Dk4D7vHlrAr?=
 =?us-ascii?Q?J91QUcG23pft2R20H7Hs0vr12Q+Ubm5Ir6tgxt9lJhj0NsIUNyTVPvzmXOLA?=
 =?us-ascii?Q?O6u6P7a5i623QYZTj+FCpyRrth3VWn+48yr2VtPb5jDD/lx0zOEGJpJPKlkr?=
 =?us-ascii?Q?VZTbiYtaaTlg4IZbV4Tr7EqUXUhx5u2si9iMf7M1YU0Xsb8OAikwvxk/yXI2?=
 =?us-ascii?Q?iVcadlxqxl3/cusWgIRKdduzZUKgpaQwig5CyLvXABOx1YXQxb7gzrxHsukH?=
 =?us-ascii?Q?2JkSjE9WsP02A6s3DP0r9dkRjei4W0Wsf29vIJW6dHi2ogCPg+EiuVduOtmu?=
 =?us-ascii?Q?b9cwI0X0y2FgP4eMQgCtJJMLWXP8aQCu9DGw?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:22.4411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df1fcaaa-59fa-4ec1-b041-08dddad19439
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8794

When a master is attached from an old domain to a new domain, it needs to
build an invalidation array to delete and add the array entries from/onto
the invalidation arrays of those two domains, passed via the del_invs and
add_invs arguments in to arm_smmu_invs_del/add() respectively.

Since the master->num_streams might differ across masters, a memory would
have to be allocated when building an add_invs/del_invs array which might
fail with -ENOMEM.

On the other hand, an attachment to arm_smmu_blocked_domain must not fail
so it's the best to avoid any memory allocation in that path.

Pre-allocate a fixed size invalidation array for every master. This array
will be filled dynamically when building an add_invs or del_invs array to
attach or detach an smmu_domain.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d7421b56e3598..0330444bef45f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -919,6 +919,7 @@ struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
 	struct arm_smmu_stream		*streams;
+	struct arm_smmu_invs		*invs;
 	struct arm_smmu_vmaster		*vmaster; /* use smmu->streams_mutex */
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 73f3b411ff7ef..fb5429d8ebb29 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3723,6 +3723,7 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 	int i;
 	int ret = 0;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
+	size_t num_ats = dev_is_pci(master->dev) ? master->num_streams : 0;
 
 	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
 				  GFP_KERNEL);
@@ -3730,6 +3731,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		return -ENOMEM;
 	master->num_streams = fwspec->num_ids;
 
+	/* Max possible num_invs: two for ASID/VMIDs and num_ats for ATC_INVs */
+	master->invs = arm_smmu_invs_alloc(2 + num_ats);
+	if (IS_ERR(master->invs)) {
+		kfree(master->streams);
+		return PTR_ERR(master->invs);
+	}
+
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
 		struct arm_smmu_stream *new_stream = &master->streams[i];
@@ -3767,6 +3775,7 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 		for (i--; i >= 0; i--)
 			rb_erase(&master->streams[i].node, &smmu->streams);
 		kfree(master->streams);
+		kfree(master->invs);
 	}
 	mutex_unlock(&smmu->streams_mutex);
 
@@ -3788,6 +3797,7 @@ static void arm_smmu_remove_master(struct arm_smmu_master *master)
 	mutex_unlock(&smmu->streams_mutex);
 
 	kfree(master->streams);
+	kfree(master->invs);
 }
 
 static struct iommu_device *arm_smmu_probe_device(struct device *dev)
-- 
2.43.0

