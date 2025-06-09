Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE4C21FF2C;
	Mon,  9 Jun 2025 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489253; cv=fail; b=FNA+Z6j+n4rrhfB4EiuU0SAW0FhreDCuCGeCRrfaM0/mvJ3S4HJsW6KAZ8Oc+qGIDdu5TTFfCu9UQqeB9rn8t8WvUGdBUEY+dg7A28kL9o57dzRRks0lSowWKDj8krhiSup3ReNrLi8rKVIDzSHENOe2ONXX4xQwsFcPIG/i68A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489253; c=relaxed/simple;
	bh=GcKiOYgvIEvpvuh1tYv9BEpq+L22giIMybsIy01uTXw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=deZ3FyLSvDpq6Wyn1SfY9YgdRysb7HIX4+FuxG+vqTtXtWs61LB2KSVtYsNP4eZ/QwsTpnfd4f4Bl4fbeZos2SxMa/6JmgVGxrz321lzAX1FHNBvo0eosAMIPBlzFa74bXeF/Eog9JYcad9rWSdlRxzC5YdFao5i0h/YTQH21UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d5si5p1B; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d5si5p1B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+n2XO+A2xJ/NnKj/Mj6/65ZN2R2jGVTYGiLz9n6L6bjvBlOpE+O7WV2DmXHF2/UzfHiLHT5PfOkhAUDKo36Ucq+UwEPttTNOqwGzHEQVzSeFBK2160PFtO8zfXUKkpY1d/j59uAWw/Lynidh6SlpKtmbW+ckKzo0gCGH2/kfI1jsquQ3GXGJcVoaabo29HK5ZxftbDkG+Q7LJxYqTTIE3OOZfxNfDWsEVa7Y0I6mmofbMKyG6CDCgZfxxo0HAitBaXA8wnEn/OYNJ0zkKyaP5VcPFZKywnrDO/W3I/vnzN6+bKv1MHl7vDpYDeH56FsZUgTIIdIBb3tXgzMMD7ZOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79PucKB/MntvwdbUDfRONLXeg4yiDFciT3AWNzR9LCU=;
 b=r/x/dm+lIzTrVJS6bfWKXs7+v3T0QIqMStiDgfhO974zX2ywc4u5FhojyfmwJMpqn8G4CsjH6T6LA+IMXR4DpRKS/AI3gAwAMuviD3tyovq2yuZafmU5Dc9K9BUydR57GTRyzLs8WHszRIPCQR/NLZoJpJ446W8VggDDgMd+ptUxuPs39PZdK9O345YctuHGy1C9JFV83bMKPydBylNIQfqhfjON4qJ0F/cabjcauTZHpbhdmZQNSkkMMadXI4rRASQdRueiDc/1N1Tz1Rha2vZm0JxDmE1gnJ16iUx2tktSJHVSQh8toVsr9En3fvTv/6mejB6BGAUmTaLZqHeG5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79PucKB/MntvwdbUDfRONLXeg4yiDFciT3AWNzR9LCU=;
 b=d5si5p1B7HLUxIGYSOMcdmwjS34poS6EOKSGFjJMK3wuMbzePTmPl5CEv0afLQ6w3aEErDQhZEe1UwFNEc080UJ6jwokX+M/DB49lsEfMYdDz4QCQHGwGMnpcAy+bvTGDVJ2mh8h37pCZ5dJ8FHh8iR2Jqr76t2zW8s2Ndn39eYBZoUI9uw+IGTAwSM31VQ4zLDnZF5uuqnvolhJeMnypIzAlv7Fn8Bho6dX8d4EX6yqMlTbM2TbE0CO2l3nGNyhJpsVAUOxQPDjqiOL8bZeJMtjMxYYCJtxL80Ni315lj3DFHV/nhlvJ2c6dPO6u2BFceuoQmCLaB3F9CcGwTa+qw==
Received: from BN9PR03CA0288.namprd03.prod.outlook.com (2603:10b6:408:f5::23)
 by IA4PR12MB9812.namprd12.prod.outlook.com (2603:10b6:208:55b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Mon, 9 Jun
 2025 17:14:07 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:408:f5:cafe::30) by BN9PR03CA0288.outlook.office365.com
 (2603:10b6:408:f5::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Mon,
 9 Jun 2025 17:14:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:49 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:48 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:47 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 06/12] iommufd/selftest: Implement mock_get_viommu_size and mock_viommu_init
Date: Mon, 9 Jun 2025 10:13:29 -0700
Message-ID: <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749488870.git.nicolinc@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|IA4PR12MB9812:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a33738-54c7-48b5-e33d-08dda7790b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3wDS99W5KDZX7+U99H8CNBa6Pl8ZQ4S8yNdGioIpxlJEudPSOs2MUqwjuW/d?=
 =?us-ascii?Q?qRoU4HKBtZKho5nWNEcvrIEnpC7N+C64GZQTJWBy/mkOBiwtsJ7qNcAO4b1p?=
 =?us-ascii?Q?yVPw4HwdfdtTkg6RDElyPYkT+GBBPYUk0Ym5uw/Y5XGuDZDK2utpKecnzgCh?=
 =?us-ascii?Q?ygrwAZ4U1UribIfFHvQKd+o+QodQNpuLMdTsiaBtVhh0sF1itGYYuoTb9yBH?=
 =?us-ascii?Q?74PEfS2r7VCp+2dw2j2CaWgrgQLh5VGksyCBIWBADDD7gtIcXVc+2r400hGL?=
 =?us-ascii?Q?J9g/Q940J68L5418hXY2/BE6QLl8Mrm5cH9FTfV3sdCCbiaNvJ8v91CZVPdX?=
 =?us-ascii?Q?vTGF5HVqK2SCvIiKJhFHbZnbWHd7iKU8f5iw3WKwablEt20kGOx9Z7vGPNRP?=
 =?us-ascii?Q?7sf7zHMcwyq8dqncfCj9LYeOdyKKJDgFh1ByAy1Qj1i5wjN5vPAc/+GBomaN?=
 =?us-ascii?Q?bgvJ48J37G4BwTTarujqcMX1jfY4RKWRW+2u/OcXvzaJtyicr0gNjHvb96XG?=
 =?us-ascii?Q?ed/2h4r7eGI7HKn97etApMI7M5Rgfase5cnimoaIs1lC+2xwuAY0gKQJy4Du?=
 =?us-ascii?Q?P4qUIvEarumXaGTk1PytI9YtLWUcdHi3Q+qGYtIFGGiKwS0H2dj1bEqwB83K?=
 =?us-ascii?Q?JF5Wm9EMSulFgO8d0LVjrK79SAK51xK3ma01m9ntnOhVAVCqUrJEWnAJw8s1?=
 =?us-ascii?Q?bVt0IFQ5hzqEPGrzWnk+586KiJcIrDRo2tZOavKAYAC4k8lV1hPdcQrIgFGI?=
 =?us-ascii?Q?OGm1/eDDO0zOevoH8+Z0KWjTgJwMJu0r2A2QFGdUjakbqa7/LuNhNn3T6Ypk?=
 =?us-ascii?Q?58aoa2q1+IisH7rLT0AZJsDe6M2DaZIQN6Mds9Njg0qd4XW4/s3zerQ8YjLV?=
 =?us-ascii?Q?E7G4TiC7M0eOEjwIIgOUN+a8PZz6BxPjiwdeeQMqr7MvvMyLVNhlKi+HSPtS?=
 =?us-ascii?Q?x2eeKTZ+jwl8pE78cArZWtPM5xbb0VYyuDk8buTcAuPaM7EBCGRixutvlzYS?=
 =?us-ascii?Q?/eVwDmF3mH9ZVlq7nMg3A6VhS+HZZ/jpnMlE/0LrQndlQRRKh1nuy2bQjKWl?=
 =?us-ascii?Q?J+pIGkkbeGh/9phdSM21xpty0GIEsbOHxdLp4m2UDWXdtcJIENbVAorZnSXy?=
 =?us-ascii?Q?qQQn+KqxVo53s6+q7FIYWljKhZ3mi4EGHdp6+uxt5hMtqCLUoOTy9VT/hWh1?=
 =?us-ascii?Q?9lANccow5XRMrNjfXC+NxA7FqMftpJQD6f0kTUumPIMCIpvQSdY26WXLD57L?=
 =?us-ascii?Q?66/MSQMxRNIxPoYFzKY6JM5ya7SQgzz0kzQ4EdU2T8z2T8fnYFBxYT5BV2Bq?=
 =?us-ascii?Q?os86o05HBToeL1GR220k9ycwqKyDbpr80mgz7h0oaizagoCcZ+1Wk8QRRHhv?=
 =?us-ascii?Q?Bcx9ffaZqaRmkvVYyP9/hWQgIs1odlnoEwd832djoXTqNYtqAd2eY1axoSal?=
 =?us-ascii?Q?Skv2i5DTXlW40hNpO8phzFkVnc0PW/fSbKv/M56o/PidTTb+sLJzzOdKcJhL?=
 =?us-ascii?Q?gJtXYBOSTbaHSHuUO00Om3uPf1lVFjhRO8Bd?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:07.4341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a33738-54c7-48b5-e33d-08dda7790b26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9812

Sanitize the inputs and report the size of struct mock_viommu on success,
in mock_get_viommu_size().

The core will ensure the viommu_type is set to the core vIOMMU object, so
simply init the driver part in mock_viommu_init().

The mock_viommu_alloc() will be cleaned up once the transition is done.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 4d5dca8027b1..b0de205a2303 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -772,6 +772,29 @@ static struct iommufd_viommu_ops mock_viommu_ops = {
 	.cache_invalidate = mock_viommu_cache_invalidate,
 };
 
+static int mock_get_viommu_size(enum iommu_viommu_type viommu_type,
+				struct device *dev, size_t *viommu_size)
+{
+	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
+		return -EOPNOTSUPP;
+	*viommu_size = VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
+	return 0;
+}
+
+static int mock_viommu_init(struct iommufd_viommu *viommu,
+			    struct iommu_domain *parent_domain)
+{
+	struct mock_iommu_device *mock_iommu = container_of(
+		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
+	struct mock_viommu *mock_viommu = to_mock_viommu(viommu);
+
+	refcount_inc(&mock_iommu->users);
+	mock_viommu->s2_parent = to_mock_domain(parent_domain);
+
+	viommu->ops = &mock_viommu_ops;
+	return 0;
+}
+
 static struct iommufd_viommu *mock_viommu_alloc(struct device *dev,
 						struct iommu_domain *domain,
 						struct iommufd_ctx *ictx,
@@ -810,6 +833,8 @@ static const struct iommu_ops mock_ops = {
 	.probe_device = mock_probe_device,
 	.page_response = mock_domain_page_response,
 	.user_pasid_table = true,
+	.get_viommu_size = mock_get_viommu_size,
+	.viommu_init = mock_viommu_init,
 	.viommu_alloc = mock_viommu_alloc,
 	.default_domain_ops =
 		&(struct iommu_domain_ops){
-- 
2.43.0

