Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B4A36998B;
	Mon, 23 Feb 2026 20:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878546; cv=fail; b=YN7BSI+WgKcqUJntfmwM12LklWpgiwcUaGgZQ4hpJzk2hSZzZHEbOMd2X9SBnWHqz07e4HZnVtayMJ2FtBm4LzRiTnKp8Y198Zt0rygFQ5Infmfm7QudIPvfV24RkY3Cqs2xp2Fi4tqdddoTPeKdjxsOxsoA6dWP2uUurBkWfKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878546; c=relaxed/simple;
	bh=3pmWQtf9nO/db9B1+3tVeGkvvf4nXdmEVz//6dpLCS4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ni+d6fvNZ22qAFBFpFPENCkEhQSvXpX0Ji2XV1d9OBhrQdQIDjde4vGhJBcFRu8Ycxv+vrvrB4K+X1+6hVa59yqufGbBwMoaiV+mZYg1kXWsAHQED3RIHSF4RVcnwxBp8BXZRpS9V7jeqmsvh0/NHotZHAz86f89LlFjoZrOzIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DAHUlnsw; arc=fail smtp.client-ip=40.93.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DAHUlnsw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A4UhzA6YIQgKQ0/I67XnA2xtXcW6tYBVdQRwV1RvIdFQAnZPxkf42v2EAwQoYZZj94Ofd+5pn+vtBnBxdordxSD0V3iQW927G1D0AVOym6XIni8cDo3nrfo5ccgOAVQJbp/LcnrN+EESaMaMA+Wk/hBMO31GxT4PU+m9z2KKwQeF/A+hQxjaveEtqkj0cbzNdL+w+a0kA1jTtzrOaYG+8p2+vgFmPnICyY7zVLUbeArfobu19vqZgd7PIK4aOI1Xa2xGUoVi+HMH9JX9ZJAvONDALbT3fzcIrNbIQcg4jgx5RrIQisuoG7smTPTCwnxi9GPHfRm48GYYzYb3DIwxMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riiat681LX7XHfgBWmSVwLn1pZXua8Hpw2c0rOinttY=;
 b=bZJNLVePUKzKAsg7WhCoZQ6uTFm8RUVqStH/6k3bU9i/K98RYSzJX8RL9qvol9K6db5J96QKd6PE0WrAHOUqCqEmG/TT+dDakeqgkUPwHn2d7Xo2G/If2VRTRD0ptimPFef6VkqbJyNfao9hmV5LCkGws1Hy1s/l0rwZCZqgq4fDTFP5ImHJ/GZ74hruBBgRZ6DcX3wDPi1iQDlg/7PRSB3wOXGzrZi9k6yPhjsWvugm6xbD49CKUPGN+K9iPBH6LebxUFQsVCqJgDnLeIsJrIZmLVdkA/GMRqYA7MchpGKX8C4DRcgZBWNgwJcRm4rJF9OKkz1F3MpG9NUDcaJm9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riiat681LX7XHfgBWmSVwLn1pZXua8Hpw2c0rOinttY=;
 b=DAHUlnswQk+9w1NJGwiYNg3wKVlcLI9yaRaURpgFUjrk/eVGT95uk7TE8biXbXx01TxaQKbLmNnR6wrE3kSWn4xQcRKDesxrM4MmWbyHtGdAoqkNCqyax52lzYI/+X2ymIo0zwKiaQk0Fwq29dDXj6uArv0oCJmoG/LgqBVe5w9fDgwJ/2w6E2kMgcRzwz5+vtaC+nCI/UTQCUH54k8gbCQdCrizvNHB7PUK12we49VlkobFpHmCzD9u4AB/QBZCdnyamk9aJWz07RFM83cHb6JeOxTl+Udk3FqCgyOil1jUUu6QPGItgOrg+jR4SI+w5a7Rf3jFhr92alGBrp/kPA==
Received: from BYAPR05CA0012.namprd05.prod.outlook.com (2603:10b6:a03:c0::25)
 by CH0PR12MB8552.namprd12.prod.outlook.com (2603:10b6:610:18e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:49 +0000
Received: from CO1PEPF00012E60.namprd05.prod.outlook.com
 (2603:10b6:a03:c0:cafe::b6) by BYAPR05CA0012.outlook.office365.com
 (2603:10b6:a03:c0::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E60.mail.protection.outlook.com (10.167.249.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:48 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:29 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:28 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:27 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 08/10] iommu/arm-smmu-v3: Allocate INV_TYPE_S2_VMID_VSMMU in arm_vsmmu_init
Date: Mon, 23 Feb 2026 12:27:44 -0800
Message-ID: <71438f280adcf17dc76d56810e336445fb4bf85d.1771877893.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E60:EE_|CH0PR12MB8552:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d8bfdc1-29c5-4f4d-1080-08de731a26c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HIPU3TEU4R2O6dM5PJu2DI4Zm3o7tPunLE86ES28Jd5L0Akp3qu7vob6b7aI?=
 =?us-ascii?Q?G9uPBRUYOf3YnqCe9vCGZeYVLZKwhQo6vb4ZmlvuTpWrQlkpTbEGS3VVu2si?=
 =?us-ascii?Q?pech5cuZ8CYF/+nhXoV+Rb14VI/43+b5Dhhh3ihMAAGnGFwX+640bW/yRlIt?=
 =?us-ascii?Q?RetO0pEGLNThVsAE5AW6SQQNGJ3X4hdgd5RNwSuv9UGz0jdJVl1P6frGDCNP?=
 =?us-ascii?Q?xJ1MgzjbLycweSjHEi8Z5FmA/QRc4ZxxjPoFjCO2ojqFkGkfsXUgdT1oUf+8?=
 =?us-ascii?Q?X4YCyJVAIjrjSWpMZZwSYCcr/oB9aPTzceD/aWF2J8kb7OKR4PKxOJ49uvDt?=
 =?us-ascii?Q?pF2ftMKI/G08PX3d6SvIzRBerbw9bf/IGVHk2u91QdKH5iE20CjJ2mzr/s2k?=
 =?us-ascii?Q?bvGf4RoHYZ9+pUiX2WkdexiGweubwY+pB8ctZrvgTSIe0tXKpXHaJPoxmq6Q?=
 =?us-ascii?Q?u7NE7em/VY8SRY9yyYTvHv9w1ZqMJ9Koz0zpM+YrlKtb+ynrvc48W+GeLQYX?=
 =?us-ascii?Q?jcXN+9DRxOvLdp0EINF84knqfJ/g9DI5SesA7vt4eOf4wSVPde52982AxWnj?=
 =?us-ascii?Q?yPBoi1yMPn+8fZfE0hrYKhRXkO7AEN3WqHQvNrrYZjwprRpcahufcC5q8LSD?=
 =?us-ascii?Q?QewjQP0+Vx3CBgWEG6iPn/Vog9zQK66x42Ok85QaYZ4OB/ndVpTzdhF1iOV4?=
 =?us-ascii?Q?azJzgvV94n739U93IeER5xooj7a6uTOPhmlTBJXnxXJN0Qzax29qMGspypRG?=
 =?us-ascii?Q?PyHgbD551zGvousnRzDAQ6tTOmGew1212dkeOXacO/w8koHuT4e7ziVzSbqe?=
 =?us-ascii?Q?6t1OtBvHweZnXyG7j/nqMU3gdateYYbbOxtEhVa7YbfH4f33kvCROJx/WHNo?=
 =?us-ascii?Q?MRQVuSAij893BB2ZQ9jXq1KxfAWKnCAUVr6xgurihwB4/YuVJCp+lzHyg41K?=
 =?us-ascii?Q?yltKN6CrZPa+33SGnLX08+Tt385y3HOez+flZgOGrtH2zNfB6DIZLbI01kbg?=
 =?us-ascii?Q?46C/XnBmzxLeQT0iL3+Rtcd4mh7FbJjoRqVUPxZHxI91+7lm54i2CXBudQFA?=
 =?us-ascii?Q?EL1SCR0XazeinC8o0BHuVqBcuMiJ2P//0MhHqJzQ7KeCBCJX1ASQw9Rz8HJV?=
 =?us-ascii?Q?s6MugGhJczAmgKO3ZpagWWUTmqrrauenJa9X8cIHTo/iFekcKcKsXD6sQKdy?=
 =?us-ascii?Q?uwc6rcNH66bXNdU0M2fxYffOPMiqWONynrGPKXiTAReym2rhGPn/VYuaHaae?=
 =?us-ascii?Q?9aPCb/xdMIF2wKmQr4oUf40PUPZV7KfAvXbgEI4oYPmCQ3k6Yxi1b+URuv5L?=
 =?us-ascii?Q?5T7Iu5t4/sH8OfWZu3x56AqW8OoZ2siCsuXqVsdbtQvAivhp24V1s9z3vBg9?=
 =?us-ascii?Q?3wk09kfJ/goQVWI3uuTIkSIj8A5n09VKRxkAWhoLy1CF0glIGozEVuW9XGeV?=
 =?us-ascii?Q?gx6htf1H4D9uk+d/0xDXP0rfD/dnzldDuBJaQUBj644oicowvQ/y//stsu+i?=
 =?us-ascii?Q?qO6MdMdh5v0OfSRrVpld57VKbGa3WSDn0MvZy3rqpRvej7ZsJbB1Eg6aaLhb?=
 =?us-ascii?Q?lNJ5l4cCWQUCJY7MsP6/vV+iRp9MkIRYbdaZU6Nrg/zai3bevn3FRwurgO1E?=
 =?us-ascii?Q?3o8bP2xZ5GGzwU5x70ttssIILeiBm3WNzIfpiR/vDf0hAJmWl+PUhP5yYMJj?=
 =?us-ascii?Q?3+Kby03pep21q0HUFdH+EbVuJV0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YUJSMwmamNhg20rHimq0QXuefre/OIXbh+bdD5RYsKVbLFeTqg80P0NSaowFxgZBKneZuGXuip7leFC8h69o7T1KRbCVo5Hh+ogi0PjSHoxKh6/hw/npzwW/vUAiPNSp4lom2+torM9UFCHNBxWwEenM4WQx7LX1R2XhyMsSP0wblxQ5F076sG8ZqkvFibZ6NvZ45tJgkGJSMyT2VK8ltNWLOIUloWDVjxB4BOL+xrUohGiC/WTVPab+/dJL2peVBRAg9LICB5W+k40VUH3f3uW/gxCniJwsBAWeCFMu24va128aV5mnyvowinDvviGZtWHtRYSdIYLyrUgRMjzvvslaamVAOkZppPg9Jd5JHkE27sVXFlpId5PGqA9Bitxfo15CZrn8W70M9i1JSALb02An+gzLT4xo8rcv5r5q7b9eqAZ5YJjPFcNhIicxXTY9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:48.9019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8bfdc1-29c5-4f4d-1080-08de731a26c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8552

VMID owned by a vSMMU should be allocated in the viommu_init callback for
 - a straightforward lifecycle for a VMID used by a vSMMU
 - HW like tegra241-cmdqv needs to setup VINTF with the VMID

Allocate/free a VMID in arm_vsmmu_init/destroy(). This decouples the VMID
owned by vSMMU from the VMID living in the S2 parent domain (s2_cfg.vmid).

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 24 +++++++++++++++++--
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b821241f73c7a..db6568f1b2dd6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1213,6 +1213,7 @@ size_t arm_smmu_get_viommu_size(struct device *dev,
 int arm_vsmmu_init(struct iommufd_viommu *viommu,
 		   struct iommu_domain *parent_domain,
 		   const struct iommu_user_data *user_data);
+void arm_vsmmu_destroy(struct iommufd_viommu *viommu);
 int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
 				    struct arm_smmu_nested_domain *nested_domain);
 void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index a77c60321203c..dc638c38515e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -406,7 +406,20 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 	return ret;
 }
 
+void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
+{
+	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+
+	guard(mutex)(&arm_smmu_asid_lock);
+	/*
+	 * arm_smmu_iotlb_tag_free() must have flushed the IOTLB with the VMID,
+	 * but it did not free the VMID to align its lifecycle with the vSMMU.
+	 */
+	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);
+}
+
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
+	.destroy = arm_vsmmu_destroy,
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
 };
@@ -456,14 +469,21 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	struct arm_smmu_device *smmu =
 		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
+	int id;
 
 	if (s2_parent->smmu != smmu)
 		return -EINVAL;
 
+	mutex_lock(&arm_smmu_asid_lock);
+	id = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
+			     GFP_KERNEL);
+	mutex_unlock(&arm_smmu_asid_lock);
+	if (id < 0)
+		return id;
+
+	vsmmu->vmid = id;
 	vsmmu->smmu = smmu;
 	vsmmu->s2_parent = s2_parent;
-	/* FIXME Move VMID allocation from the S2 domain allocation to here */
-	vsmmu->vmid = s2_parent->s2_cfg.vmid;
 
 	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
 		viommu->ops = &arm_vsmmu_ops;
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 6fe5563eaf9eb..92845fabd0dec 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1152,6 +1152,7 @@ static void tegra241_cmdqv_destroy_vintf_user(struct iommufd_viommu *viommu)
 		iommufd_viommu_destroy_mmap(&vintf->vsmmu.core,
 					    vintf->mmap_offset);
 	tegra241_cmdqv_remove_vintf(vintf->cmdqv, vintf->idx);
+	arm_vsmmu_destroy(viommu);
 }
 
 static void tegra241_vintf_destroy_vsid(struct iommufd_vdevice *vdev)
-- 
2.43.0

