Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCE11D516A;
	Tue,  4 Feb 2025 05:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738645322; cv=fail; b=kxR137+NKu7PttT7a3SvPiZE/Op6KDE2uOUii/zpzyXsx0GLxglvo5T0Irayw742ZOwBgTZDKZPLXRHe7hOo9PTbSODf1xlnjJyiMoJymKgB0d9PhrA5CPxqakZ0SEonDSLUu/1w2nM9Osa+htrkxDPL09GdmL5QmkNniZGy9MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738645322; c=relaxed/simple;
	bh=ye2SFZGB/Gy+YrGsQ39zjjvZBPbPD5NlRAwVQRCcvoI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J20zwaKQv9iLbBtAgfLimLV5YI+nDZR0NG843yM8nGbkcccTN5GKI3y9k1uDuHw0FprHgmAo6JtQn5P7/fG2l5vSz6ZiBJorWh3bm8UN77yigylwhFWPxmFp1H2a9KexB3xu1dyQ7vEKrTY7Tbcy7+HGfAnpmYmLnPiFpapbBzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y4TXHqU8; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y4TXHqU8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g91z9n/QXaZ16CKLMPhVF0inODswnFB1V2o3pf7ZDE6HAnRq+77369pS+zDiTNdj+rB10EGet7sTbgmEvCKtYUnn7nmiVwumA9vVQW/b+av+y9M1Hr2A6d5rLtVwgnv5A2Ba/tDVQ1iDd/txvPYWinhhacm5QRfGpdt/EpqKWmSL2amAzcmPrje8J+RWMqlawLgAw9PhB0g7fggBlMIwmsWaVJ2vYgCnDtVU7oOGBRE5RE3itiTZWuFASzwGfvMIOHLeQ+THJDxxdto9U2yQDAidroOYFrEr5pvlVmhYsa1zWy7syNXxXfjEedIul8eKe+Lz3ZrPRvgKjttT/loTPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KNyw0acLDnZLzLNp75TSPfHhj+Mz6GNh+s0+zi4A8I=;
 b=qnOpf9jLa098xWYwmjHH9F/MH8SsU3BU/HFLHltPd/xUwQlHovcVZtk+9avNSbOm2pWFdb2eL8vFmN1QyyUDqnFJ3QAEWnoTH+L2ChJung7EhDBj5UsFbUMbQNyoEqk8NCzh/ecl0hi57pXyTXJlqkpXz4yEq8N10NgjnSY9BSfgXTsDAkpfhk/TCvrT4C/Ft02I0CsiI2SPI6O+D/dbtuChsNh9eF98p/7i3M7tfVeeHCYtPvp6Ic4B9sov8Mze9VwBSVxgPUyo9AL/RIc5XB9CHvy0sXonav1/O16jD5jpJ0yx4omvZYjBd5yfLaikop8FembD9uili2ywAjAU4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KNyw0acLDnZLzLNp75TSPfHhj+Mz6GNh+s0+zi4A8I=;
 b=Y4TXHqU86ls25qpNe+3DCY01APobyWyiUp+VPAxpGLb8pfg5hHZfrD4Km7LOfnkoqXRMurySQFicoYPw8QaU8hNqFkznmIeEhPiyWwZu3H8Jdv8Z3H3craLAwlunwplOWDuBSW27eS1inArnribuw7hG+DQK/5wQesyvLUZpx3ISn4halaubcJqdtRWVMXT3OYdYhZnjq+XmawSC4dS02ywOs0y6pxoOBnP+H1fUNhcfxbYp51RI8XoAGqHQlD3d2Pl+/wGYAB2cDLtvoVf8cT86MXWhMGykYOdBdzbYucAxSz9GLTdaHh5fx0FhCstabUGSCClWu8fq0hGISCZ/eA==
Received: from MW4PR03CA0111.namprd03.prod.outlook.com (2603:10b6:303:b7::26)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 05:01:57 +0000
Received: from SJ1PEPF000023CC.namprd02.prod.outlook.com
 (2603:10b6:303:b7:cafe::d) by MW4PR03CA0111.outlook.office365.com
 (2603:10b6:303:b7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Tue,
 4 Feb 2025 05:01:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023CC.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Tue, 4 Feb 2025 05:01:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Feb 2025
 21:01:44 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Feb 2025 21:01:44 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 3 Feb 2025 21:01:43 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
	<patches@lists.linux.dev>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 0/2] iommufd: Allocate attach_handle for any HWPT
Date: Mon, 3 Feb 2025 21:00:53 -0800
Message-ID: <cover.1738645017.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CC:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b02762-3b49-4fba-5876-08dd44d90d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rdPqOJY6gpAgDseFmTX4Ju+qPyekSek3j6DmTr20PB5Nh8+22MaXHfT6GvHj?=
 =?us-ascii?Q?pBAJMfXaai4Zy6Z2Z2Ce6xh0DPkpuGCBgG44vVd6HMJuelhpLo4szgyX2Avv?=
 =?us-ascii?Q?emUKBQKNOTNrxXDRFPDx0oI9R3Qxl+UVW82cXGgbwb0bbeloZfbZ2+mjqU/K?=
 =?us-ascii?Q?F8mrYZgQH0cmVPU+X7emqpRrdgP5PigAwH78s63ULrGy5ph9tqJy9ALXMvpi?=
 =?us-ascii?Q?enPg+/6DtTHl/g6U0+r3JY6SN5J68FW8JKz0Npasqrw12JQbfbfY44gsMP90?=
 =?us-ascii?Q?g3Z7ZWCiQ03u7gDVfhhq5LYItvEUMIQHdrEP5TKwJ+C44Y6R2619IL5oWl0U?=
 =?us-ascii?Q?ENnjeWK4dzuD8WaqI/DeccQQBm74xDhdCqjo5hCPhXYHvoVEZccngooYzWRd?=
 =?us-ascii?Q?2hA1FjEKAXxt/6AkF3Js/vJZiNYBRNK/rMnYl0tFyNE6D4QEiJCGzDUdH2PM?=
 =?us-ascii?Q?B530a9y33NcjZzKyppxrhEqOU8PZ4xS7njTfzk3r955tZ2nFB0ubK3gGF0Rl?=
 =?us-ascii?Q?ZsFFj9MbxRdoyemLWpuhNHhfXun/WciVizVKvCzbtJv+EfA32+zx5YNzpuRh?=
 =?us-ascii?Q?9NScxaR9+sG/MsxPA16ljsh44tDgJ14F+WWnx4aDVjZdHNi6ULbEn4N7Sfrj?=
 =?us-ascii?Q?yB61ZhV7WbKGh28c+aUGlLUadw538ZtUv/zYt3X+EDZE0J+9q9ZGypS9Qz7g?=
 =?us-ascii?Q?ctUbgqXugEX7CTx260DcBFjAMctsjDVkQax4gtIb+pD7MHiefsFwNhVzFMKt?=
 =?us-ascii?Q?CxfR7YcSmJbeMpvqWpeS6EuRj2pDpwLnV+gV7OEfMX5gJlQkdwidKvV3JpH2?=
 =?us-ascii?Q?yOktOnwfsjcizInXEZvwQH5lGIs3LZo2Zpu0/2l1G2h4Vd+DOLDGNv9q+RrB?=
 =?us-ascii?Q?sYSyA8HGxv/BL+fdtmSDSawxMHjNzCcghFUyyktN1+NxTOzuSPyGBO4tvAnz?=
 =?us-ascii?Q?4ayXdX5gM7Z0hHaN5jAxUyzQaRfzbsGjvk2IrpJeWGVKdtUgjYngWsnIjSVb?=
 =?us-ascii?Q?u8oViUM/YEKhCyl5Q4u5hWrKsgRBEeQZN033BPC3ixp+LQ4uj+XI0mrH+0E5?=
 =?us-ascii?Q?o+b0qs8nUbR2xxqlYwgHoQKmbdPwLZQ3+PCiRwC4Z3I392FAhaION2AojEYj?=
 =?us-ascii?Q?UV313Q4rzJ1Ars5YDnjQwYDMspOE0zuggsf0ZZeGf4IzDh0FWRjxjRU+Qv+N?=
 =?us-ascii?Q?Eda/RY07KJa3vqqo/gwqh5Xb5tGqTE+hiP8o21JMuebamOGDZRfiFf0kmmfJ?=
 =?us-ascii?Q?kbjT7JKFK+M0QeXb+5db22/X+gluRXixiyC9Mbuldt/0WO59VIOymA8VY4v4?=
 =?us-ascii?Q?lvPMF5+8lSsToe6eTv2HgaW6JryMFPcftyrTKmJu1nGmLTqSOuke6LGgLvEA?=
 =?us-ascii?Q?n+uuE8xzFzdmAXZyomDlRKmqpHSCUqqaXZ8qp2Fp5Ae3gd8tMU89bH88vNZp?=
 =?us-ascii?Q?SikLKs4Xai8vZOzIOTevEwqixH2yl9p91aZcJILhv4Vjf+1qwY2EKMARynwY?=
 =?us-ascii?Q?O+i4jlMEhiuCkZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 05:01:57.4366
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b02762-3b49-4fba-5876-08dd44d90d19
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475

An attach_handle is a hwpt->fault specific thing, so the fault.c has been
holding a set of attach/detach/replace helpers for attach_handle and iopf
enabling/disabling.

Now, both the iommufd_msi series [1] and the attach_pasid series [2] want
to reuse the attach_handle for non-fault cases. Rework the attach_handle,
to prepare for either of the series. It should be merged with either that
gets merged first.

[1] https://lore.kernel.org/linux-iommu/cover.1736550979.git.nicolinc@nvidia.com/
[2] https://lore.kernel.org/linux-iommu/20241219132746.16193-1-yi.l.liu@intel.com/

Patches in this series are from [1] with some fixes addressing the review
comments.

Changelog
v1 (since [1])
 * Rebase on v6.14-rc1
 * Unwrap the fault attach/detach/replace helpers
 * Split the attach_handle patch to make it clearer

Thanks
Nicolin

Nicolin Chen (2):
  iommufd: Make attach_handle generic than fault specific
  iommufd/fault: Remove iommufd_fault_domain_attach/detach/replace_dev()

 drivers/iommu/iommufd/iommufd_private.h |  41 +-------
 drivers/iommu/iommufd/device.c          | 101 +++++++++++++++++++
 drivers/iommu/iommufd/fault.c           | 128 +-----------------------
 3 files changed, 109 insertions(+), 161 deletions(-)

-- 
2.43.0

