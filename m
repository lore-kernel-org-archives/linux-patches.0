Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074EB21D595;
	Mon,  9 Jun 2025 17:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489251; cv=fail; b=VJaCslGknnrzRGMN+eOWCMJM72BlDqbhWQWxFiRN9EwvyCc9T0tsunxk7KKRNFPr35C5gJwU65drHy9NxjUhUwHUUnDVEO4oA8fjI9hgAhDs2ggyWS3DxK87Olo9OtnBMWQ/PJAroA1tw4/7f4TQNwLUG665qc2RA1EOUBLW1ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489251; c=relaxed/simple;
	bh=9ftI8sQO2OvKI1/XdJY0fZfOjiHcEOypw5OSr0ZYk8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3SG4hVrefsLI1JhgSupS+5DisvDWFn8OBKZVm46DdZIFJ0goci8d8WHBVvZzZ/JgptWjFy0UJ6ZUuHBQwlBwI0SuEE1i5Dje+lgWTsCd2MUzdKB3R0HycCjSlglPz7NSW2gxQgCgIFLrzILg5dqIQeNHkHoyrPI4iWAljnAyOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h/hygeib; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h/hygeib"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hG8bPMaET1dkU3kCHXxmw/bZF2BZNMNTl7NLNe8ZjsJLVoMbrub9V6iquWACVrmHhpqe/xMZsep/MUSUOvlxMeR4rVdhBxevmYkZQ4XTqfof1SJe0Gbfsu/X6ZEMlxBv2Z+4/Bh2dGwVMrE0/AEjhZCQfMbBZBK/p7n338C4EUjTQbI4Ny5QsuXfRsPS75/+y/652dUF1kE1v5h7B7/so1CfIqHMAuli7nkoHfgeu4D1gT2T0qT2AKTn0efyY+mW/ehfiAZajYwrJOwGJ1IDifekr6SaRqU0XkhQuzlBwxkUwGgpTp71lkKXEmz9PHO4mqsd+ENBfR4rnJwGUrI2mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L64H7vgiJtyoHGMa4CCmMcqSlXb907wGx0owAc9WJTQ=;
 b=vZYChOx4XmzQfYYim3tTXbzqp3xQkLpQ39/tfyNUhqx6ed8WohGIJDlcK2DkCP7Skg2WFMaDI5wrBvMXvqiwnbOnk6Se/w+wi+nYbhkurB6ucMTKISxKLx0BqHJWSii+qbhBLAHoZSAYuZrenQiX2Ew251a4yPrcjxZAKpTeEYD3Q0O8KR+Sx9jx7wekp6O+XkJqXhbvrFEtLdXF89UrCOGi+1QWmFOFZRi4FT9pArI39JoDSr+RKhzusLeMz+20Oob7/G8/LM/37ydL36aucNOXEfT2AFPjQKOOZpGZf9aXQP1vJcSsMq8CuS+dXbf2u/tMuSF1FUw+5ejcEGI+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L64H7vgiJtyoHGMa4CCmMcqSlXb907wGx0owAc9WJTQ=;
 b=h/hygeibVc1+FhkfgE6quimBJsUIrvpXjLwlcqig6y7PQgHOtsGrrRl3rE9IKKBMJr6XRNsIFQJMUR+pfDJp3q/y7GGqbnb5MwfD66tUYaGKvihRkRIH9ykJYrHQFMqq1XGRZ8aUfnBsqWusRYaXGKgQoVedYFWl1ZVjQkSo1UkY4hXrP40eCHNaWUd0vapJpI0uASPCLUuH7l/CSZf7pUPF8Cnxl19svjCGpwX73GO1H33Skt5LnhbQ+VsYik8WV3a8j+Prw//7ucXEKA+ol0pnqx1VtgiNQW024YkR7sjw2TTky0U7zr047T3jPVow9lbZVEqEV3kWlVWbYxKCMA==
Received: from BL1PR13CA0219.namprd13.prod.outlook.com (2603:10b6:208:2bf::14)
 by DS7PR12MB6165.namprd12.prod.outlook.com (2603:10b6:8:9a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Mon, 9 Jun
 2025 17:14:06 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:2bf:cafe::7d) by BL1PR13CA0219.outlook.office365.com
 (2603:10b6:208:2bf::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.12 via Frontend Transport; Mon,
 9 Jun 2025 17:14:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:47 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:47 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:46 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 05/12] iommu: Introduce get_viommu_size and viommu_init ops
Date: Mon, 9 Jun 2025 10:13:28 -0700
Message-ID: <bc2c57254c40028e4dc74f32ac350826a26b3d8c.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|DS7PR12MB6165:EE_
X-MS-Office365-Filtering-Correlation-Id: 5593dfdd-1c0e-4577-cd82-08dda7790a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fFlG+bLXGftGteJm2eGgBmy2QNCDXq6P2LtyymH5fFX6+W0RTjilsV6PBje+?=
 =?us-ascii?Q?Xlaj+iyycV7lJstR9bE+MntHWYiX3g2zJHYM7lRGtjFuZFqar3jA8Lwqps0l?=
 =?us-ascii?Q?DlMpZeoJ3wIgFd6ScVC4tUYzptyQMsJfioOXmPugDlaji2D9oR+b4v5iIlTh?=
 =?us-ascii?Q?2eUT8knHEAL5yoUov+xhg6NZatnJJrYJRsFF/mzEyyGXcnZKzONSWBoNtTdB?=
 =?us-ascii?Q?CtNAvP0TQW5qUQOLz7mkch2DEAW6Em8vfV2s5MQxC2OMJDH+uBCQbpr9RNto?=
 =?us-ascii?Q?a+URiinMsXo1734xBMhYyLcePmSI8Ta60P4HM608V+4BQ167KCN+Af8QKOtm?=
 =?us-ascii?Q?owiSs7FIRdHaw9xQ8pV6xMWUilPT6DUUK1PiXPYyKv9LMDg7vUsVhtDRfOpq?=
 =?us-ascii?Q?4CI5yT7IZg5maU7OsTs7uApjhIIbe9ISZ/Vx33Pw1y1gWkZPtPzkkFczGkSq?=
 =?us-ascii?Q?cBNhVzYgO0xn39qFF+HVV/1+U+u017Lv2f0pzMO48675UTfmBmcaY0OUaHuo?=
 =?us-ascii?Q?BuSQNBWEiTiU4szTDwhkLbitBJc9vShP1ff4zkJsI3wOA27y570tujv08HKI?=
 =?us-ascii?Q?fJEUyHL9qM1wX4UfNF7naDNxtqJ4zKyOXS6azxz0fztY04eZDiFbEnQIPBoV?=
 =?us-ascii?Q?6g7LlAdZovQvt8lYlvVIspncp2coS5is+AVou8ZQtnWdZUsLBgHpit6lGzh5?=
 =?us-ascii?Q?u4mD3Qz/uW43ZLd/8tbRmfk8Xg3TCr58Eybw68HRzWFjLmHS+RIHL3TJTbi/?=
 =?us-ascii?Q?zA25I9dK1EVG3JLMnJ6zTL77v6qR4r8S3n4sECtHuL4H3FoJ27cq8U7uztMo?=
 =?us-ascii?Q?zMX+u+c6xUGGe4DSMSJOnDKRmU2XGERymQZmI/YL6Jrg7bUU0E8V3EXPdLnz?=
 =?us-ascii?Q?uF5ivnGE28IJGcnWk+Kazkq+CeRP52vI4KlkHuiM+gdSwj41TONklKU/C4x0?=
 =?us-ascii?Q?3iPs1jSNsF5pK0CX9+lvAwznNFw0Zm1Qs8aWeQ4hWQLRsOVrFgZogGyRK7z0?=
 =?us-ascii?Q?FFU6EsmEAp64tojM69brWLKroaqxY0d8JT6fyPyrZBNuMaXGsjINyKDMrJNe?=
 =?us-ascii?Q?NT2+sC9Hb1LtwXNzZtnML3N7MulZMAoVhaAPHlZgY4tAd4NV5oZYiHe5XxYM?=
 =?us-ascii?Q?Ja7gxiZS92TcS9gZrqJNv8Tqr0w6M8yWSSWX5Q/jxVgFNSwzDlnEiWyRM/N+?=
 =?us-ascii?Q?kY/WWZVrgbt9X99JoT61ocGE/tonvke0iEqsaKL4PnSVjunzAKSSlsr2fbww?=
 =?us-ascii?Q?SXP82jSbcTZnxWHhS10g081FBvt9tDWPFFp7k9xRxQQsx21RSWZ0AWrWjcDK?=
 =?us-ascii?Q?4XhNgRShJNBTo5luFWbCS9VjkEsKsQBUOS6vYu4wm1Wd4h6H3tG0pZ+19E0Y?=
 =?us-ascii?Q?5kPs0m9fVWfC+OQqAT9IpUjvcdWNIP6WDbHW9DBvwOuY7B+r1R04jGcWcBhs?=
 =?us-ascii?Q?vpqslxdHDFBXJLYH7pLWunXxcUJ7U6StXs9oohMlMRMro2t6AusxsL47Eo7F?=
 =?us-ascii?Q?kp+VEN1LFoO38r0YOJjucGYWtfIqkplIxRhI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:06.4011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5593dfdd-1c0e-4577-cd82-08dda7790a89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6165

So far, a vIOMMU object has been allocated by IOMMU driver and initialized
with the driver-level structure, before it returns to the iommufd core for
core-level structure initialization. It has been requiring iommufd core to
expose some core structure/helpers in its driver.c file, which result in a
size increase of this driver module.

Meanwhile, IOMMU drivers are now requiring more vIOMMU-base structures for
some advanced feature, such as the existing vDEVICE and a future HW_QUEUE.
Initializing a core-structure later than driver-structure gives for-driver
helpers some trouble, when they are used by IOMMU driver assuming that the
new structure (including core) are fully initialized, for example:
    // my_viommu is successfully allocated
    my_viommu = iommufd_viommu_alloc(...);
    // This may crash if it reads viommu->ictx
    new = iommufd_new_viommu_helper(my_viommu->core ...);

To ease such a condition, allow the IOMMU driver to report the size of its
vIOMMU structure, let the core allocate a vIOMMU object and initialize the
core-level structure first, and then hand it over the driver to initialize
its driver-level structure.

Thus, this requires two new iommu ops, get_viommu_size and viommu_init, so
iommufd core can communicate with drivers to replace the viommu_alloc op.

This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which would
statically sanitize the driver structure.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h   | 15 +++++++++++++++
 include/linux/iommufd.h |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 156732807994..e42a28971182 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/iova_bitmap.h>
+#include <uapi/linux/iommufd.h>
 
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
@@ -596,6 +597,16 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
  *		- 0: use the default setting
  * @default_domain_ops: the default ops for domains
+ * @get_viommu_size: Get the size of a driver-level vIOMMU structure for a given
+ *                   @dev corresponding to @viommu_type. Driver should return an
+ *                   errno if vIOMMU isn't supported accordingly. It is required
+ *                   for driver to use the VIOMMU_STRUCT_SIZE macro to sanitize
+ *                   a driver-level vIOMMU structure related to the core one
+ * @viommu_init: Init the driver-level struct of an iommufd_viommu on a physical
+ *               IOMMU instance @viommu->iommu_dev, as the set of virtualization
+ *               resources shared/passed to user space IOMMU instance. Associate
+ *               it with a nesting @parent_domain. It is required for driver to
+ *               set @viommu->ops pointing to its own viommu_ops
  * @viommu_alloc: Allocate an iommufd_viommu on a physical IOMMU instance behind
  *                the @dev, as the set of virtualization resources shared/passed
  *                to user space IOMMU instance. And associate it with a nesting
@@ -654,6 +665,10 @@ struct iommu_ops {
 
 	int (*def_domain_type)(struct device *dev);
 
+	int (*get_viommu_size)(enum iommu_viommu_type viommu_type,
+			       struct device *dev, size_t *viommu_size);
+	int (*viommu_init)(struct iommufd_viommu *viommu,
+			   struct iommu_domain *parent_domain);
 	struct iommufd_viommu *(*viommu_alloc)(
 		struct device *dev, struct iommu_domain *parent_domain,
 		struct iommufd_ctx *ictx, unsigned int viommu_type);
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index ac98e49e44fe..423e08963d90 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -229,6 +229,12 @@ static inline int iommufd_viommu_report_event(struct iommufd_viommu *viommu,
 }
 #endif /* CONFIG_IOMMUFD_DRIVER_CORE */
 
+#define VIOMMU_STRUCT_SIZE(drv_struct, member)                                 \
+	(sizeof(drv_struct) +                                                  \
+	 BUILD_BUG_ON_ZERO(offsetof(drv_struct, member)) +                     \
+	 BUILD_BUG_ON_ZERO(!__same_type(struct iommufd_viommu,                 \
+					((drv_struct *)NULL)->member)))
+
 /*
  * Helpers for IOMMU driver to allocate driver structures that will be freed by
  * the iommufd core. The free op will be called prior to freeing the memory.
-- 
2.43.0

