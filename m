Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1121C161;
	Mon,  9 Jun 2025 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489244; cv=fail; b=AEesVCp5Kz8SeMMl3OOebdpg/AXdmSGzX4dL6jYzUR5xMilIGFbj9eFnEkE3VCTdsl4MXi7KgivPphfZVUYQnvCsmuOM5f8p4LrRpBjT3fCxmLUX8u0XBTWhuVM1OFUPXRlgjZD+OdIyB0VYn2J1bxqSwwVrZYbrv4rXmKer8Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489244; c=relaxed/simple;
	bh=pLIqQymyBLXykF8rThO0A7FsOOhlpxORjt8yKIbL74g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CU5jrF5V9z1u+BxCusfQC18t/zCawNAxizEvqlxr9IUB32PNbG0WUccniERyFSB1NInZnQN7L1cZnx6ielU2g3vhtncmj+4zqS0hdNH4aT7x9S9WwoZItAfcWWJkMl4dA545ghWhH+K65ltm67DtR79qMUFbgv92eMFcNzAYFQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aAAK230f; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aAAK230f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OzLEMq4g5UqbzndcpcxDF19NB0wApeID2tMnmbDAuxJOHNBQ5nhPlTfy634BHZCTvXwo8V6D89zBtaBtAnFFcQs4pxvFPKkDUq0VkubpKKz2F80as5XDwwElKQvXG7tP00rYsfMVzp9MH/LscvOTjz0h0qiR4upkuz38wCuaS1QzT0R+T3uWAPdUb1Bo353HufMRiS1wI+H6CySegalnQZCb3s/kgmiS2yWyHDsfUDnUfgNykfBcxhmdWduML4p1FFRrVnFeu4jwAB2WrU462KEHeLjGW8BIRgRbui9DKfp+PrkbqOdtkNYohFxCe7cxrLD9XXw3vC5M/69eO869yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxlPOBa1//M+NZrPDf8z0eSnrNudRx2kGs7Bya9Bb5s=;
 b=MRhPDzFnEYnqGk8tXWUT4HNZCf4DypYLXf43qdQWTfWuqXNE9CB+31LOTSeDCj5s7+fIg3t8tw1SgNzhkWNyr5sT/sMximOskQzg+rF0Sagfss3A91Okolu+RbTEpISSJGIdQ6FXkU6zdFZZ7BqHZzPU/mTO5NX+Fw42QmrznzEFv8j8I+eDQevaaUr5z4ftpg1p7R2HTCCA0S2sTTOJGHpc8zYj70/ICSQb3CdiinI1uwrYuoUnyLLzGRb7tkDj/wZzBi/osW6NQq3qgrgGmYnUD4SQZ+wqU0S7boHrq9s65tLQkiHcOtAJJdb6qZ2Vp9UdQlBu4YzXWUZ1o8P6pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxlPOBa1//M+NZrPDf8z0eSnrNudRx2kGs7Bya9Bb5s=;
 b=aAAK230fCAgsJHm1VhuPDOe8QZiwCGsjZ4YDgoH3/FeYx83UlwL5tYOx/jAVUNu3kJ4p+RsMkWUapYhPq0DL2qPvBsMtCYIu26zgB6MfD2DqNx2uAnCUfIxz6P7C3sNT1qTgqS1VpiBMtAwDXfF+KARY7+2TeUSd0oxv9P5VG/QshR8qbRExr/ecERPyQM0szwj6YsKlc8kkq3i8diKS/T+38+tpvimbuPX3GXgz22klrGe4df8rF4c9RIfcjHPAitaYL4Wl3zTulhglN/nkqgPyL1bNe2UA0WwM1CbWb3URafd+jN5ocwnMw4/azQcDavsvOnGbH6R844e6x5ZH+w==
Received: from BN9PR03CA0845.namprd03.prod.outlook.com (2603:10b6:408:13d::10)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:13:59 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::14) by BN9PR03CA0845.outlook.office365.com
 (2603:10b6:408:13d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.23 via Frontend Transport; Mon,
 9 Jun 2025 17:13:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:13:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:40 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:39 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:38 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 00/12] iommufd: Repare for IOMMUFD_OBJ_HW_QUEUE
Date: Mon, 9 Jun 2025 10:13:23 -0700
Message-ID: <cover.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d28b695-c017-49e8-6588-08dda779055a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vaEHVK4Shqhxvzg7VFsM24gnpJccI16qYrq3rVZFHYqSvOr4KLjm75Qa9KzR?=
 =?us-ascii?Q?huqnJ/+rQmKn7nV1qCWUq+jn3HS2l9l7YSHJldR2shMnJqJSz2uq9nND7WW1?=
 =?us-ascii?Q?iicdJEabiJHhyQpxTJNQ+5fMJoItzJ0T3wEcVarLr7gpQA1drYluB42yxo8B?=
 =?us-ascii?Q?OE3EXp5p0puldRhbGhJsPd2U7li3kOvrUnamUqE4yeKNTJcxkVuEDCOK2XWY?=
 =?us-ascii?Q?MlX3bW/RUvQ+aMC/oWdp+6W0Qzg8v2EdpupNyP2cltBR4/FG/chuQNflV+Po?=
 =?us-ascii?Q?rsy88HRXtN3qCormKtYqUu1Ts/CT07BxMG9taCWd7RJxzhE1iQYNlqfVtjih?=
 =?us-ascii?Q?MxGnivMzN+3lqwQ/wPqh013iP90HZJgvSRMYMnbEznI4YwNI0+X8MAMgaU37?=
 =?us-ascii?Q?iTWQpuUIgvHltoXA4Qbadz2s1Mddy0mkX9uxpQak/6IEWLfvP+s1YzmsV8HC?=
 =?us-ascii?Q?GvT1yxOXPy1WGILJBqDe5NUVWvg5O2k4Txd+TolIcndPGMKSwnST8iGuvhIJ?=
 =?us-ascii?Q?oDcxVqZ6Tsmsv+Yg0PrvB0WRKxqh+Wva2MjGOxqu5/YkUi/i6aoPgVzqknOs?=
 =?us-ascii?Q?p+B8owc5dHHFpevbd+BJDHYg8IAjTLygHp/wsQkClnUUsozuI3NqLlglz+ne?=
 =?us-ascii?Q?j8FFw9MBb5sEsC9YRO16qBzzeVevMNKKiT50puOns+H15ekPRpPU8Ma8CtX5?=
 =?us-ascii?Q?rjOmnlc3CbP62idVbR1nccags8G8LwfbsCtuaB4T5hcP1B3u9nFMJOCH7oaP?=
 =?us-ascii?Q?G5ddHobJhoKftHPlIi9eUoD4oGqlweaycRRTpzm0FQksW5PAyOPDnhXuYoyJ?=
 =?us-ascii?Q?wfUgeNvwfko32Kb/OE4AZAx6yQ3h+VUxiXusN0cBBLK4b2NbIRxREYGeli+1?=
 =?us-ascii?Q?j39gJTGJSMDivm2+NBw0vVKsZypFMusVboLRG0fNbJVXNof8ZEr8KUYUuEgw?=
 =?us-ascii?Q?tczzmmRqvz8hFM0Eo6iLKD4e7uS5n++ArF13SXo59xgj9zpZuYiD+zwSKdJg?=
 =?us-ascii?Q?gFdN/IL/tb3ww09aDfOnWRawwsrCbEl/m8FsdBYjGqXDa4oskiy+3NUveHuj?=
 =?us-ascii?Q?uw62sd6GP6xD2+Bq2yoihFfMhUHoeRLcR1HUXb75DcpS7RjUHqHdvwrTM3lL?=
 =?us-ascii?Q?QAw9P61mSWPObLvaUwXjr8xAS0k9YWF26KslVv58CPlJ+jcbgNRg3ucbezj7?=
 =?us-ascii?Q?CSzFKrS27JgFPoUQdQMl4RZ+0LTFVq9vn7wqvIS5+aIGKDhgcCSTLvOrqmzI?=
 =?us-ascii?Q?jb+5+uz8+1PtnYYh3ZgzzzkOCZL9OJ7KnVI4ykbHcm8gDOm4hgF6IN+w6bYL?=
 =?us-ascii?Q?5SioEVVDCI50D+gcCLfrdsl5C/oedOYaPJCGvBjNlBxVtqz3m8OepcglcCUK?=
 =?us-ascii?Q?nZbU6NsGeLMMfeFoG24UsYgMTHr+wweK3roJIku0wDhVyjudjnW/ZBZ3wrow?=
 =?us-ascii?Q?gj68cfQoPLKL7C7Vpr+4F68UdligvTJN3LMz2VsJdQiQWMhcZu8PHBNGWnP4?=
 =?us-ascii?Q?SITynIY/5PMJoH3Wc1YExXKn8GWagnlxfBZm62sA2oxnbsDSEaZN2yh8gw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:13:57.7053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d28b695-c017-49e8-6588-08dda779055a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

The new HW Queue object will require more interactions with IOMMU drivers,
with a few more for-driver APIs. This will complicate the driver-allocated
structure design like the viommu_alloc op: since the core structure is not
initialized during the driver allocation stage, a new for-driver API can't
reference any member in the core vIOMMU structure.

Make a preparatory series doing:
 - Cosmetic fixes and clean ups
 - Replace viommu_alloc design with get_viommu_size + viommu_init
 - Add a new iommufd_object_alloc_ucmd

Some of the patches are included from:
[PATCH v5 00/29] iommufd: Add vIOMMU infrastructure (Part-4 HW QUEUE)
https://lore.kernel.org/all/cover.1747537752.git.nicolinc@nvidia.com/

This is on Github:
https://github.com/nicolinc/iommufd/commits/iommufd_hw_queue-prep-v1

Thanks
Nicolin

Nicolin Chen (12):
  iommufd: Apply obvious cosmetic fixes
  iommufd: Drop unused ictx in struct iommufd_vdevice
  iommufd: Use enum iommu_viommu_type for type in struct iommufd_viommu
  iommufd: Use enum iommu_veventq_type for type in struct
    iommufd_veventq
  iommu: Introduce get_viommu_size and viommu_init ops
  iommufd/selftest: Implement mock_get_viommu_size and mock_viommu_init
  iommu/arm-smmu-v3: Implement arm_smmu_get_viommu_size and
    arm_vsmmu_init
  iommufd/viommu: Replace ops->viommu_alloc with ops->viommu_init
  iommu: Deprecate viommu_alloc op
  iommufd: Move _iommufd_object_alloc out of driver.c
  iommufd: Introduce iommufd_object_alloc_ucmd helper
  iommufd: Apply the new iommufd_object_alloc_ucmd helper

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 11 ++--
 drivers/iommu/iommufd/io_pagetable.h          |  2 +-
 drivers/iommu/iommufd/iommufd_private.h       | 33 +++++++---
 include/linux/iommu.h                         | 26 ++++----
 include/linux/iommufd.h                       | 39 +++---------
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 47 +++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +-
 drivers/iommu/iommufd/device.c                |  3 +-
 drivers/iommu/iommufd/driver.c                | 33 ----------
 drivers/iommu/iommufd/eventq.c                | 14 ++---
 drivers/iommu/iommufd/hw_pagetable.c          |  6 +-
 drivers/iommu/iommufd/io_pagetable.c          |  3 +-
 drivers/iommu/iommufd/iova_bitmap.c           |  1 -
 drivers/iommu/iommufd/main.c                  | 62 +++++++++++++++++--
 drivers/iommu/iommufd/pages.c                 |  9 ++-
 drivers/iommu/iommufd/selftest.c              | 57 ++++++++---------
 drivers/iommu/iommufd/viommu.c                | 46 +++++++++-----
 17 files changed, 212 insertions(+), 183 deletions(-)

-- 
2.43.0

