Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5781E991B;
	Sat, 14 Jun 2025 06:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882953; cv=fail; b=I6u+ILQfHEsQ578W1uSnMDeOubIZhoCvqN4M/RpAgVEryc3C3yJxAUYTjMmQ8x8kIvo620vmsuIcH+g/FVlFJRnHReSouqjbPqA2QruP0eC8EnvbpsOy7oxY8aQNW0rIQnsFH7l0cRevdv0ps3Hgey5g0ROS96pGNb2VFF6H4hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882953; c=relaxed/simple;
	bh=rg1yE2MXqC2cnyNYLVdl2239OF9X/xExNQgOvojvGBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlD4/+ipgs873NOfjqj6F8b+pWJFQaiROHd1aAEoyT6kaRfGMuRdvBLpg7AyAKIOxXC41Eh0jTydhtO+N3V9C8dsEDgsOXLuAAcOsm7x1NePneP0xludZm3jniOYj/VNeLhlP4iXs+MsdmC6qgBa0ug7PCyPwgoCwvt7OK0NvGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CUm0/YpT; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CUm0/YpT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTGzedmeBJrBBj8AxC9sUUx9L9yh70bO85khN/MdnAGUEL4FL9AKNtUAv0y2gPhGqb4rlsNzo/pbKycvUyBMH+8eec68CX1BBZzKIgKbL7+X+gIbUKB/d3OT8IptQzFf25cwXEuE4E2Fu/W6PPT3hi/+5wQTpysSjKtEeYFlIhIX0xtIcQnl5RncKK5GVSDcxDkom/dOdkJ3z+IUwRQziLNNRbJgg1fMdezvR806r14254irjs/xQ5XiY4b1qsgdVsOgTX2HspozWKMN3BTnZbRLOOthBY0635V8q7aHk3ge8JOHD9H8a5kCcGuqyNd/Mm/WS0CDMY3gswKWX90+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMJ4tA75JKnY1O8mxVqQxh5MQus6HpHA8B9U7j5krBY=;
 b=x/l2zh/exzFPGABAPxb7IjRriVpScXUssiAbcb6Ba4+0JxZB+CAwfyeVvMXvXS7GtE0Pi/9Z0KCvgxoyAP6i2UtXX6kGtioHmpkvwzeod8/WuI42UjMvhheBkCgNoewbRJ3WzU1Tv38kFdkpZ/CsIwWrHvDzJoIGySkqfW1m37gnFw67rOl4w07LM4mhEa/lbZpaokqgWQPV8Jox4DD6wMIA0Mk2AElDhGJPicnCjfHSku5C9+qdkZTc6u96ionuzMkF9JLS3Cg0BMl3TL6HAKQXLY1NrJmAhltxEoSv8XCXSBBPnoJ4PmmDX5GVAjnszIgvB9w3nZMNmoEQKsWPIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMJ4tA75JKnY1O8mxVqQxh5MQus6HpHA8B9U7j5krBY=;
 b=CUm0/YpT1WMqd0HSrxCh3dq5D07mZ5S1kIICkMW/WTsUqw6GLN5XtR1WNRsJcHvIJn+3EVUGVvCe+cTok7oUbOpnW66eh9ZfAQyWO0Y/DHAUyuj7EqoFS+yDIuTULTCdNvo9hG/lFi7WzVK9SbslSeS4PJ1kIKxn7/mU1hdMb3mVC0vkcO1kpLY0VB9zTeR5Iexlybk9v74viQMF7/PeI0fYUiynbJafo8q2qwgRUtsSRkaXXFgDMBtE3EDX51xFipk9CdzJvVFs70kp8kN5Lslb7CyjfC/J03VbuzJohCXO4UXTT7nBIbjtg39RH2TEYmEl6gJrDiBbkdfBADqc1w==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by PH0PR12MB7906.namprd12.prod.outlook.com (2603:10b6:510:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Sat, 14 Jun
 2025 06:35:47 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::bd) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Sat,
 14 Jun 2025 06:35:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:36 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:36 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:35 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 05/14] iommufd: Return EOPNOTSUPP for failures due to driver bugs
Date: Fri, 13 Jun 2025 23:35:17 -0700
Message-ID: <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|PH0PR12MB7906:EE_
X-MS-Office365-Filtering-Correlation-Id: 2247562d-783f-42f0-0803-08ddab0db26f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hMLJQLq5R35CDZ2MejfgKjhNw5E9jDMAEjjRRkmtk85HmLIoKG5fA+Sn9f0Q?=
 =?us-ascii?Q?WJFlHhKq+xOojQbE5GRnJQ3UuCeMOnHG0jiUjXvn+K+upONbK8loydyI8K2w?=
 =?us-ascii?Q?kzn235GhYJpYov12vMNeOTh5HTGubR53adBZvlFEcEDpxrkXwlsP0U8GDXVM?=
 =?us-ascii?Q?yW9AvP/ORCOJeHdL7gwGQhS7wUjUaEsEyLHe/X3ivhD76kheo7vFvPdW9zps?=
 =?us-ascii?Q?GR09LF1h31ruqX7ECN+c3mPYeDPxkpD85xY21etbh3x/96JTFn6xnyScEGw1?=
 =?us-ascii?Q?OQDLuAC92s2oYrLgLaxhl0qazQdkiRAxwHtsQQ4JyCk+hkRUegq7BE0ljKdJ?=
 =?us-ascii?Q?c3Ej3Llo6nTG96rMlKcl0pn3Vd2BP2XWxzB+oG/TKh04cKlhF6Ei71CigdOb?=
 =?us-ascii?Q?tmF8fO1U58nWWfSK0qlbU1FFmEYHmSPMhRErA3kb8ZkSOdYjti/sm3ZLfvRR?=
 =?us-ascii?Q?tInFuM7IpLkqPkSLhbp9JrlW2cfa35rKSuXI/bdBkXQnwNeTrj+1/MyQ4Bmt?=
 =?us-ascii?Q?YlvPjEDC6qX24gAKlb/onbMONW43UA5U+p70x+FL+9tXke/lPz0LwrbSpwbQ?=
 =?us-ascii?Q?0LQ0he4wxAdA0a8IRWIzG2+PPFOfjXq+oG7levdZEwFpLYslYdeSpIy0WS77?=
 =?us-ascii?Q?SlUQjGJ8k8fC9xG+/4PMuzxDzGWDUwIOzZROTxAE8AiMzK/5ceMD4td0elhC?=
 =?us-ascii?Q?61SORXCpu4uRAU4G3VOWazZCL31dvUnUixPd/rZunTVpQMHNEq+iyI+gz0rM?=
 =?us-ascii?Q?s5pMLl6VhVI1cmV6z60LXVl08UguNlafqF6hC6RUiNLYJivvXHcOyTCRwaJc?=
 =?us-ascii?Q?xXHoKA2oagwzz0m4fLpfsLEMT5IBrpTcoDoEyq/Cs0AtVZCvPqxH2YK80v3d?=
 =?us-ascii?Q?bbZPaQ+IgjpOCoaW6dzewlazfescvrN/z/0tX0fmSRXDBJ26gbZjFbUFTNMe?=
 =?us-ascii?Q?bV408lQopfjG3smegAAbSA1qWGinOKSZFCNbAqZq0ShU77tL0qv11ZDJIqqg?=
 =?us-ascii?Q?QF8Hrs2U8RTmUiK4MPUscJPw42XJo0UaT9GUPAH2+SdwhLMTLjU0CIjLnpFl?=
 =?us-ascii?Q?2OfAYaTuUFiNSJ0Oy+oGEmNDC7Ot5QA8bRQeDFoPnADHrICrrG8Sh91XREgm?=
 =?us-ascii?Q?1cqC8LU/yzukFt/geOSDO4JuNS65vop2QohjF/58DBCtXHRjYQWjxB2iMmLu?=
 =?us-ascii?Q?omWfWHtRjkoTrH7cmQLWx7RCPHXCjtxjtw5/eh873/rnybcbep/vEdv1f/iK?=
 =?us-ascii?Q?ATO9HQx2dfcK9zQ82AVf2o7am59+DPNclf8d+nRYgxZ1LignFbNEcl1wzP3v?=
 =?us-ascii?Q?QTB/JnboROv9F+8XtEBcyjjc42d6B/0aNaez6Yoznccwsz3sJPqfTIUQcMI+?=
 =?us-ascii?Q?YIHlKs+4D1kNUeGhCa2+dsbl2r/lM8olHjwG1MsBD57DFYPvkCrJ3aZD/afU?=
 =?us-ascii?Q?RvffP45Adln2Ittla+9wJA10PwSfqqvZDNf3a6g6udLiLTG2uNcuuOKod/p2?=
 =?us-ascii?Q?a54G+jZuafQcgHpR7yrfKFJhAxU8tE7C6ZiC?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:47.1315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2247562d-783f-42f0-0803-08ddab0db26f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7906

It's more accurate to report EOPNOTSUPP when an ioctl failed due to driver
bug, since there is nothing wrong with the user space side.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/device.c       | 2 +-
 drivers/iommu/iommufd/hw_pagetable.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index ed0dc539d490..e9b6ca47095c 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1483,7 +1483,7 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 		 */
 		if (WARN_ON_ONCE(cmd->out_data_type ==
 				 IOMMU_HW_INFO_TYPE_NONE)) {
-			rc = -ENODEV;
+			rc = -EOPNOTSUPP;
 			goto out_free;
 		}
 	} else {
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 8565a6f596b2..fe789c2dc0c9 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -264,7 +264,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	hwpt->domain->cookie_type = IOMMU_COOKIE_IOMMUFD;
 
 	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
-		rc = -EINVAL;
+		rc = -EOPNOTSUPP;
 		goto out_abort;
 	}
 	return hwpt_nested;
@@ -321,7 +321,7 @@ iommufd_viommu_alloc_hwpt_nested(struct iommufd_viommu *viommu, u32 flags,
 	hwpt->domain->cookie_type = IOMMU_COOKIE_IOMMUFD;
 
 	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
-		rc = -EINVAL;
+		rc = -EOPNOTSUPP;
 		goto out_abort;
 	}
 	return hwpt_nested;
-- 
2.43.0

