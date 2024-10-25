Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13C215C4A;
	Fri, 25 Oct 2024 23:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729900225; cv=fail; b=QiZkUj26UrNs4ivg3+rHmqiCWnqd0we2aRBZvUZJaBQiwaBZsJ//y80F9IQUe8n2VkHAKbDH5oq8aQ03vQTkdCyfxIVozO9sB2+mdSTfO2F6qjlY5QWmAGMCa3/ahUpjfa+Qw/xO0y7H5FxMdeXxIC+sqYTvOZPIAArYAgY60g0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729900225; c=relaxed/simple;
	bh=Q8VE6IzeDpgHx76U0y+61ArnaedQajieI4pMEblROZw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eHbzaX0N32x3WzfAM76Gjl8OjuzJZ1miUKb5F6Q98MIsNxEY4Q2cFUCJM7ouN1vbv8i8ddwyt/6R/YPHvF37+w4779cggf/nfaMxwR85nHTEu4Qomd3juwedl1CUF9HujR/3ELIequqlg9VBP/4usNkBon5MPJL9wuFpXTfp+MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E4hP2q8x; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E4hP2q8x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZjRrKO5if2YX5uh6mmh0OZz96LYFmp6tYVuaEEr/npB5h9dUFydWhApJ3CKmpOsqMYZnSDi0gh2PP/fWvFlRGf0cfXyQbI8kwvdNT00QR6Kt2f2sul0GIbCKGznkhtblmgWncVno5L/9d9VB4QULfGDzAi2Q2Q8Uomgei0S98tnX3M15h3SsaYFY236XeP2HuXOCHzDeQoM0mKJV+guSAJ8keeqcAGP4MoC2UElvlo1Dr/sCkUQzG8tymWzn+HB62uhSLRNsmprEcj8elMluXA8/JWt01PVbMDT7SNfNpxxpxTmbmVdLjcdnbQo5Oi5AtxKkdzi5CV0/HGGXWl6b3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsBPpSYX2Hef7LoGRhojQSrQVU9StMLGIqI0V/eyHEA=;
 b=Tb8XPIeNb2vV6DR2gFe+InTxV+fV8LISZ1luetVA8l8pXMEuRv/lKBcUhilbgHtjWDoIiFo6wyqbnhgYECY2FbrlBtDnhFNuF2RHxoctgXb2mE6YdRQaEQP2uUIqSPDO+oDJ5+qOPgZHMDQAwf370f5E1ylPtjPa7A4ubo67a+AsRi6Z1oKOoU0GK9CIK/P9r4CypMZdYgZw8zlfgBcsZrnTm46gssuao0YBZkxLpmUcvoldn6VB7wTAGvFLSDcySa8iqL4wZwB6MBBhSn9h5PthNI95ZZTtTJXFgcup+q5jqV7Aa8MHcDrlHRQExj/mX0lbF/RYP6bGcStZVvDyRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=amd.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsBPpSYX2Hef7LoGRhojQSrQVU9StMLGIqI0V/eyHEA=;
 b=E4hP2q8xHr2jDcvbCZlz6qEAqxovz7vfAH+FZ6yl8Jzkg7qc9SB19Of9YL7ZX4t7+lJd8K9aR8pvrcAZsL90zHgz0F31vbXMe1nCmCJhEY7ls5T9zIc7HlBmKToAPyhAC71oGeXLUOI8x7D3b2rnuIa8GgZrx2ROwNYCc1PisMADQexXZEmxjTIcS6drKxSZrA0URnvR8s5uVYV1nnmQYKXQdXiSWSP6lBkAW7RGnizB/2vrCdcPFzVyfp9/yUEKH5LmTpMgZsoc3ptIRjThdOiovobiE88AMxbIiYn4GkqZsEeMu0tr52s+hEfMa5554HcROufDyYj+zIp/1x+IjA==
Received: from SJ0PR05CA0138.namprd05.prod.outlook.com (2603:10b6:a03:33d::23)
 by MW4PR12MB6897.namprd12.prod.outlook.com (2603:10b6:303:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Fri, 25 Oct
 2024 23:50:18 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a03:33d:cafe::b6) by SJ0PR05CA0138.outlook.office365.com
 (2603:10b6:a03:33d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.12 via Frontend
 Transport; Fri, 25 Oct 2024 23:50:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Fri, 25 Oct 2024 23:50:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 25 Oct
 2024 16:50:13 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 25 Oct 2024 16:50:13 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 25 Oct 2024 16:50:12 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>, <will@kernel.org>
CC: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<robin.murphy@arm.com>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>,
	<shuah@kernel.org>, <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kselftest@vger.kernel.org>,
	<eric.auger@redhat.com>, <jean-philippe@linaro.org>, <mdf@kernel.org>,
	<mshavit@google.com>, <shameerali.kolothum.thodi@huawei.com>,
	<smostafa@google.com>, <yi.l.liu@intel.com>, <aik@amd.com>,
	<zhangfei.gao@linaro.org>, <patches@lists.linux.dev>
Subject: [PATCH v5 08/13] iommufd/selftest: Prepare for mock_viommu_alloc_domain_nested()
Date: Fri, 25 Oct 2024 16:49:48 -0700
Message-ID: <f080c65265372b56942e6d1008ee114654a23f91.1729897352.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1729897352.git.nicolinc@nvidia.com>
References: <cover.1729897352.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|MW4PR12MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: 38922398-967c-49b5-0eee-08dcf54fc7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W4ZESfy+Ps9KW0fC0k/kR0il1x/dh7PD2JyelVWs5Nj1iKsgitSMD8EJxkMN?=
 =?us-ascii?Q?K2YO5uxUHRzSKtqJXmvHMEKfFJ9IhTSMubxTf5/hAwCyY0atULGQMaler+//?=
 =?us-ascii?Q?Fk8TH5Ray4EQuljQ0nIrzirMWP5SQ1HRkHPjaf6ikzH/WVmF4WsXjp/YmsQ1?=
 =?us-ascii?Q?en9mnqCWvm+qseetqRx22qx569ITpyk9ikzxCChX5IUJP3db8hD4LD0axf+m?=
 =?us-ascii?Q?u64IvSRNmq/D+GPvSUzWzCvTktZLLxtnc1TpKueScGyPuaJtzgcoY3vD4Ju9?=
 =?us-ascii?Q?fuzCClNBcg/FHqvxvElGqyxtsLlg/s7EwBkHmuXErPEhE+z/g/rpvOfRGtU9?=
 =?us-ascii?Q?4V4DCBgFWbUs+K/PbuQE6zL/5pRQbRxWMLN59WSjUDynuEDBcwKc1Z5m9h/L?=
 =?us-ascii?Q?yWlpES0JWRGSw7qcbkAOXeD1RQopFTy45/45QmjJP/vfqUTdzHUVSZVvxM2j?=
 =?us-ascii?Q?gxh40GDtpOCLZ3NOrB1cLg6usGhPAVrUXRCgUuUUHePDtTb2OporGY0xH3Jl?=
 =?us-ascii?Q?GLUaE5pl8MDCWSz0UMlCjngcVFtkNiuDSjZY/9ImLtm8N44Qz8QsHLdDo4nU?=
 =?us-ascii?Q?RLSY1Gy9UVYlQnnz6UiabzHjsNkvL5SfplH2HAvICsj643DmYjxM85QF63yI?=
 =?us-ascii?Q?IaDxN3rgbk3nocL4Kq3bPr9u+mnRzhULWBH4mANJEMpybVZD9DjlMaMiFref?=
 =?us-ascii?Q?w1ZkJo2SA4aIXjNLDE7AsSlLxLz4CT25i3lCE/M+Yf+vsAHNfn5eOcrbaH+M?=
 =?us-ascii?Q?lQgsdUv+HH5s7W4uv2MopuACdkAUAwzgXsLE+3DCHqPb6PR+iQh+kMwpdy6Q?=
 =?us-ascii?Q?dw4CD2o/qClQmIl7p4LJgkV7Tu6JELaZ4rV2EQ0+brWsf1EKUsTDh8joN1Or?=
 =?us-ascii?Q?nzkUM06ELyUeECUUTmAPkMjK0scI2sMe6Bnn5efJ64E29wEpx7n5Qf1PCv+r?=
 =?us-ascii?Q?7WK65c9l1Dwww9Uu2ZDmFZbEVPpNUoNOZ9yr034WUmO1wlLjwtjWoSXdz5Yj?=
 =?us-ascii?Q?TKMozX2nXWQTUaPXPfsVjPFj7FoyhYDceVP/LcFORlmN6YbZahZyNoDmqBmX?=
 =?us-ascii?Q?4QDZmjpqHKD9U/gIL7wmDTfH8nMaZtrCS8Lh7V6GMTwIF8Q0Hs342WO03pVG?=
 =?us-ascii?Q?OCgZzAmDMG6Pvpnvr5fQ4j5fVLgfJ6B3ZlwIrAsINJr4ILJcWebQTSMGuHCI?=
 =?us-ascii?Q?fhBWp5WDFtQvfNLpsgofWnRIYuLV7rnoABH82mJvqEum0YwumBpbyiRcYnxG?=
 =?us-ascii?Q?O4UnJTrI8QSS5Udq7JAvwyjY8UKMFe077pWfLMoSIZa08va8ZJrbEbbE4TM3?=
 =?us-ascii?Q?zckbDoP+SmTZF35eadjwGYj+QYLRhLgZsKfbBaYiNpiN5UPpBjVrIa0NWfXM?=
 =?us-ascii?Q?Svc5zDL+2wB/R7gIBg336ygt2YzBAK6UEPOJ3fnKI7vk5WpVaw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 23:50:18.3396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38922398-967c-49b5-0eee-08dcf54fc7d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6897

A nested domain now can be allocated for a parent domain for a vIOMMU
object. Rework the existing allocators to prepare for the latter case.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 89 ++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 322e57ff3605..92d753985640 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -318,55 +318,39 @@ static struct iommu_domain *mock_domain_alloc_paging(struct device *dev)
 	return &mock->domain;
 }
 
-static struct iommu_domain *
-__mock_domain_alloc_nested(struct mock_iommu_domain *mock_parent,
-			   const struct iommu_hwpt_selftest *user_cfg)
+static struct mock_iommu_domain_nested *
+__mock_domain_alloc_nested(const struct iommu_user_data *user_data)
 {
 	struct mock_iommu_domain_nested *mock_nested;
-	int i;
+	struct iommu_hwpt_selftest user_cfg;
+	int rc, i;
+
+	if (user_data->type != IOMMU_HWPT_DATA_SELFTEST)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	rc = iommu_copy_struct_from_user(&user_cfg, user_data,
+					 IOMMU_HWPT_DATA_SELFTEST, iotlb);
+	if (rc)
+		return ERR_PTR(rc);
 
 	mock_nested = kzalloc(sizeof(*mock_nested), GFP_KERNEL);
 	if (!mock_nested)
 		return ERR_PTR(-ENOMEM);
-	mock_nested->parent = mock_parent;
 	mock_nested->domain.ops = &domain_nested_ops;
 	mock_nested->domain.type = IOMMU_DOMAIN_NESTED;
 	for (i = 0; i < MOCK_NESTED_DOMAIN_IOTLB_NUM; i++)
-		mock_nested->iotlb[i] = user_cfg->iotlb;
-	return &mock_nested->domain;
+		mock_nested->iotlb[i] = user_cfg.iotlb;
+	return mock_nested;
 }
 
 static struct iommu_domain *
-mock_domain_alloc_user(struct device *dev, u32 flags,
-		       struct iommu_domain *parent,
-		       const struct iommu_user_data *user_data)
+mock_domain_alloc_nested(struct iommu_domain *parent, u32 flags,
+			 const struct iommu_user_data *user_data)
 {
+	struct mock_iommu_domain_nested *mock_nested;
 	struct mock_iommu_domain *mock_parent;
-	struct iommu_hwpt_selftest user_cfg;
-	int rc;
-
-	/* must be mock_domain */
-	if (!parent) {
-		struct mock_dev *mdev = to_mock_dev(dev);
-		bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
-		bool no_dirty_ops = mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY;
-		struct iommu_domain *domain;
-
-		if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT |
-			       IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
-			return ERR_PTR(-EOPNOTSUPP);
-		if (user_data || (has_dirty_flag && no_dirty_ops))
-			return ERR_PTR(-EOPNOTSUPP);
-		domain = mock_domain_alloc_paging(dev);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-		if (has_dirty_flag)
-			domain->dirty_ops = &dirty_ops;
-		return domain;
-	}
 
-	/* must be mock_domain_nested */
-	if (user_data->type != IOMMU_HWPT_DATA_SELFTEST || flags)
+	if (flags)
 		return ERR_PTR(-EOPNOTSUPP);
 	if (!parent || parent->ops != mock_ops.default_domain_ops)
 		return ERR_PTR(-EINVAL);
@@ -375,12 +359,39 @@ mock_domain_alloc_user(struct device *dev, u32 flags,
 	if (!mock_parent)
 		return ERR_PTR(-EINVAL);
 
-	rc = iommu_copy_struct_from_user(&user_cfg, user_data,
-					 IOMMU_HWPT_DATA_SELFTEST, iotlb);
-	if (rc)
-		return ERR_PTR(rc);
+	mock_nested = __mock_domain_alloc_nested(user_data);
+	if (IS_ERR(mock_nested))
+		return ERR_CAST(mock_nested);
+	mock_nested->parent = mock_parent;
+	return &mock_nested->domain;
+}
+
+static struct iommu_domain *
+mock_domain_alloc_user(struct device *dev, u32 flags,
+		       struct iommu_domain *parent,
+		       const struct iommu_user_data *user_data)
+{
+	bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				 IOMMU_HWPT_ALLOC_NEST_PARENT;
+	bool no_dirty_ops = to_mock_dev(dev)->flags &
+			    MOCK_FLAGS_DEVICE_NO_DIRTY;
+	struct iommu_domain *domain;
+
+	if (parent)
+		return mock_domain_alloc_nested(parent, flags, user_data);
 
-	return __mock_domain_alloc_nested(mock_parent, &user_cfg);
+	if (user_data)
+		return ERR_PTR(-EOPNOTSUPP);
+	if ((flags & ~PAGING_FLAGS) || (has_dirty_flag && no_dirty_ops))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	domain = mock_domain_alloc_paging(dev);
+	if (!domain)
+		return ERR_PTR(-ENOMEM);
+	if (has_dirty_flag)
+		domain->dirty_ops = &dirty_ops;
+	return domain;
 }
 
 static void mock_domain_free(struct iommu_domain *domain)
-- 
2.43.0

