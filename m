Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741752AE99;
	Sat, 14 Jun 2025 06:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882949; cv=fail; b=FopF/s/r1HT5Fq5qNZdT+CXY5EFjFm6RGkMozyD+bn1FLGxXilGr2a1VWkxDDsKZj5hdO1IpdCHfcHhODrBceqCMkaeAf7iL/P0ZFtqZC/871xicR5dcsf2pSmAK6ZDA1wSdGyRbOdiIOzqeeXVmTj7MhxFZPaKDjRDhirzMc7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882949; c=relaxed/simple;
	bh=z19R8Y0zWlJaNZavSwuc2Piz13nR8v5kYvqW902upXs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MGw6aRF2YRSh8Zlix3eSYreAJIKQACbelr2gbkc9c6QlBbpwUetG4xZfJo4rToWHo+YUL1kXAbsVJ5kOLKgE462BYmi0B4maG4FHmM//QDQXvFWSaLzO8JddzfflYuPEddTbjXKRioly8c/2/78bTEFueYXOGFNqjEqBMPo40JA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TyDTz0bS; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TyDTz0bS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xA+0ugDCuaS5RpogHQjds+tybv08yPs/QQNBDYfY+rUw+Nh5PYaq/qCpHK2T80mBs+rIqJ+Qu0pvXC4IwLa2E+Ki/6k2jXCf5vyEutbmu/4YHjY0girZArU80aDfOXmYfPskR4sPB/X3/banBqlR2MpCBcyzmtKig7xSIMoMQB7utJ3X+s3P9q3Xndkj+A9eNtndtuAfmVwIxsRUazBMwtWAeIp0CFRozpXYAuo8bjVlaTgSpTKvofDR574rFPGpmJO6xOpOCxQRAaZSPKCYH4T6qukOLt/LYaGworFobR289C2uctg1u83fxbPQVAroMfzbKfYZo+vztFV+xOW8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BlYfFf8rCgrPNZIBS5/aBAMxDCZDOtoAHN0HQbfgiLk=;
 b=ytuw5pvakZacATBaqPo9mCrPkzMd3/xkHfCNPAd4HSfif02Sfk5I9kQpShVApUwry39TiGAt1hLlF+rdnNH9t4xH1v1o+acjDw/ETWHDUJZ/hTJlt1LT2sFY7NWVG7DtCIYmXmUv4tgr6rx5mb84/PfH4wLC+gyX4m2y5leeJFC4bNRlZFEMDuWx/6oYC3owWELiBazbFIbga8EbzmyUCGjC1ZqQ4LRsOzImVdLGEP6o28APJilkr6f1BjRewV+78a8kTFJm7DzBO4YV3NF/0N6bvp/osjjB625RBL9tlSvGuNwxPNSVvn4aWMGD/s/eq1bSfHZvzScWvr+MUpPk9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlYfFf8rCgrPNZIBS5/aBAMxDCZDOtoAHN0HQbfgiLk=;
 b=TyDTz0bS7Cec7+ccymQWQ+tXcQ3HDsK0jheMYG8xxeRVXz5G/jCgRSLsOaXHg03kHUfCtVKvOTXw3WDCGjuCvSXMjn6sVEIgBXsnO5/ueESNoMfQaJZ0moPdHH2Quy6aAe9BwgOO2vDS5gUD8OQ4cRwhg1Q/+9dROp0m5oc57fYZmB7taUbFVFnqxJMTTEY93hM3Vk8Z5BHPXKhiRbfNKPX7wb7VULts1gCbY7IZrVwHQIqAslKrzhsLeztc/xIo/9lvqJ97aVdIyjjbBfU74I6LEbqBDXRlGM5K7g2sxCeEvlmelhSjc0KrE4i1i1HLFyrX42zKdkKEyZRt9psBpA==
Received: from CH0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:610:e7::11)
 by SJ5PPF3487F9737.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::990) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Sat, 14 Jun
 2025 06:35:42 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::2a) by CH0PR03CA0216.outlook.office365.com
 (2603:10b6:610:e7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Sat,
 14 Jun 2025 06:35:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:30 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 00/14] iommufd: Prepare for IOMMUFD_OBJ_HW_QUEUE
Date: Fri, 13 Jun 2025 23:35:12 -0700
Message-ID: <cover.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|SJ5PPF3487F9737:EE_
X-MS-Office365-Filtering-Correlation-Id: c6900e1a-b9d0-44da-4ef0-08ddab0daf3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gGJdH3MV9TXUSzg80mz2oLQ+gaQBhAPAjV5fB2WLg/rJCPQw6xNKktEbF/Lt?=
 =?us-ascii?Q?uGWunVIxUHg9LNL/FUtoTb2y7ftK8LI/pMbaRhj4opE4kytTX3H8NbYpQ5Rz?=
 =?us-ascii?Q?mBBRCyV/lnUX2tak4rtQTkZqA/kaO5Q4/m+2BcKCpWmf4XaDtGyn+vc2qT9o?=
 =?us-ascii?Q?N3Qhs62LEeMvuveXker5PNB/DmFYwS5PZT43MArpqGzglSKI9tb1Y0v1YQdk?=
 =?us-ascii?Q?ZEzHFL4yo45litL78773KyBtEnM99iGPZBfeOwQx6Xj5EjY8BmTfj8zDujqh?=
 =?us-ascii?Q?Bi8WxbydukcMgXPTb77RGBzzHwAreLJXYBNo6HsNbn5J3qiXWKhzwJuJZQoB?=
 =?us-ascii?Q?0evtTTV6rFULHngB1tJpbnDjbo1/tUZqLOKKiTLmtNC5m8NJai8k8CCPj3n1?=
 =?us-ascii?Q?mekLNfs/gBoj0NnLI3HNmDQw02sc3BNoUfcUz7x6M/bNkO5R9Oj+OVgxoA6G?=
 =?us-ascii?Q?zVFsYyQF0dXEmywPU0acxstN4VHpJQHyaFZ4atIb/ScKv/ZZZJQsvnjtZDZ/?=
 =?us-ascii?Q?U/P6mCQzOQW+eT7nn9NEU4dNvx+wZVjHkY8GwSJmHsMwCxWUPDCs7UuBhZJ5?=
 =?us-ascii?Q?tAO+14oeIU8zuUFkAP+wZvsSjDVqBXf2nIIUI6ZBkuOiQeHxJ84TLGgkLk0h?=
 =?us-ascii?Q?NL+wyvzXJLyGKzDXUrYyjr8Oc+S1OqVm2GSMOJS21LZwimvEPcX+CJyoBmb9?=
 =?us-ascii?Q?M4J0Vk3/Hkfwcbk15smEuYVaaQxFHvp/DCx24x9G7AL02b48RKr9k4UBgNEO?=
 =?us-ascii?Q?uYJsA12tACZRKGFdScBuWmRwiO7q6s3s89GWnS1f+V0yP11ZWIMxMndP8WWi?=
 =?us-ascii?Q?UE8tXq1Gbk4oDrxEyFYICnvinjsLPi5M65MUaKigU7O9jM6or+5CyPVOGN0v?=
 =?us-ascii?Q?4UfsVm3XeuX8G4E2El5rezdB9YKIhLB9gnKtlp4VPQSZ6h3Z5NS9SPVZ8Txc?=
 =?us-ascii?Q?Kn26L1FzfP8Ehes8EME9V+poE7eHtcp1U7yEZLYPYNKNkILwVl716uzEKznp?=
 =?us-ascii?Q?CGidX57KDZxl81JviXLpv4zUU0sPjUiiqMi4Rt94TncZPQvKTI+nfbwSh+oj?=
 =?us-ascii?Q?GKtaj4bxMs+JGTOLb2ZfQSUAMMuh/uUSPutDjAxp9+Bau4Mw978QWtAebv17?=
 =?us-ascii?Q?6vJ34cQL3ozpfpXrtG2GG44cK/f+7bWaNAFNBxrTrUVK2j0rV+VbRj90SHaM?=
 =?us-ascii?Q?q/Sj14Nb/uw93vrq63Wre2qhpMTmic6PP18VFPbkMOioMC2AjLxNXUlYFtTW?=
 =?us-ascii?Q?WnhXDk/6LPJqq6dis+smfWrMqDjK/Z9ikq1Jbit6+ecyOJ7FyKVApBrTz8WR?=
 =?us-ascii?Q?osXH26QwfSPJ/LxILH9UgFZtijPLUenShmohYuugtBNfQfjwgbgKSyDKHxxX?=
 =?us-ascii?Q?3EAsn7BAVsNPxey823rkQcFTG7w4gj64+Nf4QojyI7xw2Ox4FdB+OnRRf+tC?=
 =?us-ascii?Q?rSV+bJffYr3nzrc/ZV8EoYSIfHsOlDjCZ94ue13fBET4iKC2t4oCuL1Je/iN?=
 =?us-ascii?Q?WG0LXY2avCSHEWPMzgVPFMGgytlC3uHK/kC6o3xRDfLtafoN78E9IxnPTg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:41.7968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6900e1a-b9d0-44da-4ef0-08ddab0daf3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF3487F9737

The new HW Queue object will require more interactions with IOMMU drivers,
with a few more for-driver APIs. This will complicate the driver-allocated
structure design like the viommu_alloc op: since the core structure is not
initialized during the driver allocation stage, a new for-driver API can't
reference any member in the core vIOMMU structure.

[before]
core:	viommu = ops->viommu_alloc();
driver:	// my_viommu is successfully allocated
driver:	my_viommu = iommufd_viommu_alloc(...);
driver:	// This may crash if it reads viommu->ictx
driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
core:	viommu->ictx = ucmd->ictx;
core:	...

Make a preparatory series doing:
 1 Replace viommu_alloc design with get_viommu_size + viommu_init
 2 Add a new iommufd_object_alloc_ucmd
 3 Cosmetic fixes and clean ups

[after 1]
core:	viommu = ops->get_viommu_size();
driver:	return VIOMMU_STRUCT_SIZE();
core:	viommu->ictx = ucmd->ictx; // and others
core:	rc = ops->viommu_init();
driver:	// This is safe now as viommu->ictx is inited
driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
core:	...

Some of the patches are included from:
[PATCH v5 00/29] iommufd: Add vIOMMU infrastructure (Part-4 HW QUEUE)
https://lore.kernel.org/all/cover.1747537752.git.nicolinc@nvidia.com/

This is on Github:
https://github.com/nicolinc/iommufd/commits/iommufd_hw_queue-prep-v2

Changelog
v2
 * Add Reviewed-by from Kevin and Jason
 * Drop unused mock_nested->parent
 * Revise commit messages and kdocs
 * Add WARN_ON if new_obj is already set
 * Re-organize the patches replacing viommu_alloc
 * Use EOPNOTSUPP for failures due to driver bugs
 * Return size_t for get_viommu_size op (0 means EOPNOTSUPP)
v1
 https://lore.kernel.org/all/cover.1749488870.git.nicolinc@nvidia.com/

Thanks
Nicolin

Nicolin Chen (14):
  iommufd: Apply obvious cosmetic fixes
  iommufd: Drop unused ictx in struct iommufd_vdevice
  iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
  iommufd: Use enum iommu_veventq_type for type in struct
    iommufd_veventq
  iommufd: Return EOPNOTSUPP for failures due to driver bugs
  iommu: Introduce get_viommu_size and viommu_init ops
  iommufd/viommu: Support get_viommu_size and viommu_init ops
  iommufd/selftest: Drop parent domain from mock_iommu_domain_nested
  iommufd/selftest: Replace mock_viommu_alloc with mock_viommu_init
  iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with arm_vsmmu_init
  iommu: Deprecate viommu_alloc op
  iommufd: Move _iommufd_object_alloc out of driver.c
  iommufd: Introduce iommufd_object_alloc_ucmd helper
  iommufd: Apply the new iommufd_object_alloc_ucmd helper

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 11 ++--
 drivers/iommu/iommufd/io_pagetable.h          |  2 +-
 drivers/iommu/iommufd/iommufd_private.h       | 42 ++++++++++---
 include/linux/iommu.h                         | 26 ++++----
 include/linux/iommufd.h                       | 39 +++---------
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 46 +++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +-
 drivers/iommu/iommufd/device.c                |  5 +-
 drivers/iommu/iommufd/driver.c                | 33 ----------
 drivers/iommu/iommufd/eventq.c                | 14 ++---
 drivers/iommu/iommufd/hw_pagetable.c          | 10 ++-
 drivers/iommu/iommufd/io_pagetable.c          |  3 +-
 drivers/iommu/iommufd/iova_bitmap.c           |  1 -
 drivers/iommu/iommufd/main.c                  | 63 +++++++++++++++++--
 drivers/iommu/iommufd/pages.c                 |  9 ++-
 drivers/iommu/iommufd/selftest.c              | 56 ++++++++---------
 drivers/iommu/iommufd/viommu.c                | 48 +++++++++-----
 17 files changed, 222 insertions(+), 189 deletions(-)

-- 
2.43.0

