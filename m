Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00801E7648;
	Sat, 14 Jun 2025 06:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882953; cv=fail; b=ZV7qafNStH+7C/jSnwCF/ovoTBkx4XFuPocBH4y5nQendtlAjdub3E4ugH9yJMP+e1T7o+zjqKNZ1G64mISvIDyOM6j2pZyC/96pji7YbhqKSZv24+ggzf/PyEZ/bwFKxf3+fpqSsyxqglzda0RoEaCWK3ecv+nAU7d7Ujk+5kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882953; c=relaxed/simple;
	bh=kDdy6bpUzbKC893XFgQ9iwmmcj9IeBkppl9rguSoDhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JTpUIWmIF2nOkhm8IhoNyI6fb2/ryWAMEYgb3xnoHqNw+2WulnJxT5NubAj97k+BvkEb3w0FJwYsYpQgbyMnVDZEeGW69t/DL2riCbL+rsyL+IqzDCvp10CCqpcF2totyx3Xq5emVNCkEog9Q2i6paliXZpiLvMZ0D78xoChU/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nLjEKs3k; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nLjEKs3k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xIPdMLk01bZIGEhTA69/SSZwxuhXIcAr2tRxpKLdAyK/qrpi1JRyg6Fj8LclQmcDmir5I25FydgIa3vkRNkAlGfuVd5hD75M8ukY/Z1JdnrJAUyeV8Glj1A+KwlpjHHXnm9+qqCL0ZBAJc9TQG7ExLLTbDClbQzPueT0vuCDwMMOyfjE7tbSra59AJXSS2c458gxaBI7vn6Q0GysZB60RNo2zrQw0lBBpEyeLRVmgslOUKhvL5PEptncDt9O67pJ+ou7kI357zJZx3qXgshu10V8FWBs7fxinuYWdfE2yzS3eG5HERrK3CAdT2hcIQJTkD+Rmvnq9GIVsfRejD300Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIzSdepgaRjaL1oqsNJan33EenPpQNywJl8OcpwMAVM=;
 b=tLKIUVIBfBpeE82thZMOt1DtN1xP/5R5hPzRh36WfN7uRjNPlhYDVyUKVpbVwrgHnp9c/MmnXLI+THkZk3ui/X4YFdYmYbFVZhQVQ/Nc1dJSggMzygV+K21wYgJRJ2a2llNyeChh3M3TZuOpK2E0XCMBfsFhH7M4Qasq4DnM//z+kYWAV/7mSxvSXyv1a90tRGqTDq6hgH47gPCxxLvgL8hhBVVqEfKSW3xAluxNg44gTFHBHgzQ1T/axJd1KpJjihbHEAydr4fTBQKSAeo7QUDlO5toWGqB2s8hQ9o81vRZej2u5KL2dNxCoY8P0eJUSWccvalApyBHaN237L2ZbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIzSdepgaRjaL1oqsNJan33EenPpQNywJl8OcpwMAVM=;
 b=nLjEKs3kesjXFwErSBez04rWrl/JER0qdm/VwTDnhPM8kbG1jdNUwkcHgs6g1zHBqQjMpaFIgFEtXvECxjB45PCCrRjVUQqVh7M03VKXpeOaYkh4/AxB5F89Dix8aGRahbakdMtOpiBfBBIw8gOyWSm9tRxBoGb4xLWnClo6llOw4f+Fk1ieW78LlI5T7zjLzj30R0lGKyPQZw+tKpnCFXosanAm0ClJLHo3s/OPJSgicSYHHHZrcvuJ/4+TocR+0gnhiXX+Tj99ypvjJwPfY+4X30PuYrnoqHWQUR9NRJm+Qx0LIxjOFw57ffVU8ctZqk5A3CZfMmyiKvYtnN8Xlg==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by MW5PR12MB5600.namprd12.prod.outlook.com (2603:10b6:303:195::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Sat, 14 Jun
 2025 06:35:46 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::94) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Sat,
 14 Jun 2025 06:35:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:35 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:35 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 04/14] iommufd: Use enum iommu_veventq_type for type in struct iommufd_veventq
Date: Fri, 13 Jun 2025 23:35:16 -0700
Message-ID: <208a260c100a00667d3799feaad1260745f96c6b.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|MW5PR12MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 150e54d7-2f90-4abb-d5ce-08ddab0db20f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YBro5FAjsJnpUT8p8yAcAck16ceFEfM1jgpH29Y2Bn+Wge6z1bfcB+SNwoU8?=
 =?us-ascii?Q?AYTTEVWBR8IgOiHt6uTQr6oPqfvKsZYLurF1wwnmhsXXA2Z6stEqRrbyPETT?=
 =?us-ascii?Q?tleG7ldfubeLKzC8HLkV+bdPDQnDUfp8sZCmeiOZXj8Y99i6WKf6tkb471SF?=
 =?us-ascii?Q?yE/+G3/iazuHafsXGVknao3ASJ+IVEfHxjM5+d+tPRY8IkTpabhGGNCvn9Sl?=
 =?us-ascii?Q?mnXs+57KwH4rIEh4VF7BXUiSvcJsEMgZDvgj3SsBfn+FZ96z5jJfJZLsXmI8?=
 =?us-ascii?Q?Eiu91ucGsWdjM79R0B+6WbsvUg+zU/pacqhMi7y4GpBMI6S9VQXzX9aRHupx?=
 =?us-ascii?Q?dySs9AQwpMi5cIavzzvOsZGH2dKGa4Je3daEB/9U+sMSRf4LSek7AsHb4Cgu?=
 =?us-ascii?Q?EHypp6sJpcaw37m6Y3mvFQe5AWeCd4qixRRKy6yDjhm/cZCu27yPrQmE5Boc?=
 =?us-ascii?Q?a3PNKunDTT1/Lo8RNQiWRhD/5UsAqDMe/gxAsEUS9qss+TvfBIbJwyGsP7WO?=
 =?us-ascii?Q?kwhJRDMKqGLwpEwWpM9hg47s3x+11ecpy2LehBkRLIahaba6P/LBDJOllqJf?=
 =?us-ascii?Q?mU1LZEuAKWfmM1G4/Kt5MimRg72DBTyKXJSw16YinZXwo0cg3pYEIZnv92c2?=
 =?us-ascii?Q?t7cwo5f+huiu6piAmOMulWO4PSVN/YZAa+mClYNXGJuRNJkB/AFQXlU7Yw/o?=
 =?us-ascii?Q?Zac2TvlxscHfoYemb/IpCGTiWwSj8NNcZOE393o+vvarsyqWtYFA+yAmLeCb?=
 =?us-ascii?Q?SxPLgT8VYkF4LaKc35vmGt/ORvyJKHq57QqHApREfIYeFeOtKnIIAlgwAHZM?=
 =?us-ascii?Q?0EGDxFPviJ1VZILYWQ8cRLl1gmkKf4yP6md0DToUH05GyPegYc0P7nl3Cv96?=
 =?us-ascii?Q?nbXrGni2nfoIDzGDuFcYqmhFAB41XgsYmNvygbsYJQur2hbQbPqac47OdBfT?=
 =?us-ascii?Q?fa2T3OJUE8oPVAlnpA6eREFXYOgfE09JRSGP6yOWqw83l1WVmimEsJnDalRq?=
 =?us-ascii?Q?QKQq4GZgjWCOTnSikDrszSmUUH0a7VnLrSj4H3lGzGvGHih0+xWXGa5d/ahI?=
 =?us-ascii?Q?XvYgwWzPQ+jul8L0NLPTEKavJk7cPTvLytkYrjGU1TCbTMO9VBvU6DEaifxQ?=
 =?us-ascii?Q?7TbMNfKyca6E/e7Vet3J6iOVfJmZC8xRJBUfbGrJGDT3bYttbB00l5XkALC9?=
 =?us-ascii?Q?qOY8yhadVDT9w1/niYncNMQB6DlIot3EYL9+UJhGjDhzwk9WcZQSjm7iyjuG?=
 =?us-ascii?Q?sobi6e2XsU3a3wdSXJ5ppvmXouSes30P4LlavzFlAq1kFwYu00foWNlg01at?=
 =?us-ascii?Q?c+o2vmr6BdBSEqlpX4w4ef5nlhFcdpKJzw/BL1siRnO2/wn7FBMZhzTkAM0U?=
 =?us-ascii?Q?bGp/euc30a76ppkXr4U0ZbP0yDGkp1rq7VglHXcxbSBNpABVubeZ+GQ2hzAg?=
 =?us-ascii?Q?JNxw/Qld2qNKYGDJghE+g5bf6lMl25hw0T6X5upgWY38MQDLlkpLFA4C7Ez1?=
 =?us-ascii?Q?C2chnvDMu2L6AKUsY7fQiEbeywuWq0ZeC+CN?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:46.5130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 150e54d7-2f90-4abb-d5ce-08ddab0db20f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5600

Replace unsigned init, to make it clear. No functional changes.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 4619285c09b7..32f0631368e1 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -526,7 +526,7 @@ struct iommufd_veventq {
 	struct list_head node; /* for iommufd_viommu::veventqs */
 	struct iommufd_vevent lost_events_header;
 
-	unsigned int type;
+	enum iommu_veventq_type type;
 	unsigned int depth;
 
 	/* Use common.lock for protection */
@@ -581,7 +581,8 @@ iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)
 }
 
 static inline struct iommufd_veventq *
-iommufd_viommu_find_veventq(struct iommufd_viommu *viommu, u32 type)
+iommufd_viommu_find_veventq(struct iommufd_viommu *viommu,
+			    enum iommu_veventq_type type)
 {
 	struct iommufd_veventq *veventq, *next;
 
-- 
2.43.0

