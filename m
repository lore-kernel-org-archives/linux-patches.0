Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2514A1E51EA;
	Sat, 14 Jun 2025 06:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882960; cv=fail; b=XINOR7WMTQFhSzv/YTN00ovLdaUxN/fOLEpNrAPlpXf013+mq/LPWD94ubGW8bzfvRNB1erQGUrm2zJ3FKN3Iwx48hBp9jPwhHp/mxVKhPqTtb6jX5HpmfBS5WkmNwXgfqC/TDphvgWTzPZO1OzokkwsVsZnZ3++f8/jGg9rqvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882960; c=relaxed/simple;
	bh=tJaiCLMT2jlcQOqDN0RBkaF4P8GQL1SEyrnnTEn/+8A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jmqfOD9zK5WojZOfr/jM9UhEtyiBx/MrbpTVqwtKyFw1mcHRCVo+Wm5HU0TcH4t+UNUMqsdGvqc3QhF1+4n0YOWx9DQWRsZN379pvye4sL6BgChmHYjxJD0/g2m5oqbKtMKkBzu5QwvI1jcQXvbuJkD7L3cToPBxWCqIdgy2TAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KyE4DjsD; arc=fail smtp.client-ip=40.107.101.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KyE4DjsD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bU0P8wZV1177ty/WPqZOLv9RgijomO6loN0utNiBHThdI0lhq8TSWkCleNIIY6WieBOHvT8RgA9J9iueXJU0QcSgngZ2xVhJMSqmTjWbx4MAajbnuZkrzDrUW9AmsjraZTeeZ0xP0xR4KREUaqFHWpKIRLpzwfA9JdgI+m2laJnQ1mT/JePjglhMD7jRG2UDIgX+zQ3OJIFjt/jHyCe+UJfKjFINN4dqn+8LafGfFaIkqxugvRdfvhf4FcS03Caeoy+H+CDF002Rl3PTyyxG/1GNSbuZlVaS1+Huh7VDaH97bFQ++5cm2yRtwTy4kwTYlwZFurszZR4Dh2S2JMzWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSRjyQzfnjA+EbewA3MOv322HR2B3VepPo1rhvuI214=;
 b=MLT3KxdixU/9hZjwvrQAIZcr0JedjnSls/37d1SzjMEgGhPStiAWtVIOuhYJmzBTdvDQ11QinwoMLoMDNgl7XvnkDvTy+1k8cdXArM8kVdLamLHpi/Vmcv/c1R/FXKOxWQtZBJmUGYvCJeJVrmqrFpebICuVxR7gmCwNDkEgivTQsAHD33mAgR7/t/roANjFsxOE9fl0hFCYUVa5qMc21aftwYI+XdlrzqSQrJLCVytjepAJx4q8DM87Jn6vVMCWyX+paydP87V44Kr869bFqlG86k69+6aY2aWyTks7cSIc5F6rKvU2AvoaQM81tSxOWhoYDWfam0dMbNe/Cj3OaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSRjyQzfnjA+EbewA3MOv322HR2B3VepPo1rhvuI214=;
 b=KyE4DjsDSSPpqKO+C6W5U8OqXx4gQTevjaSZFYUL2XgN2eKUfJmIGchxbCq90cMTyyTnEBmV+sGbm1wGJVay+NZUpxqcM7xUGf4inewYs4ell80jK6v0CjUYVxvCHXcH2Qei5SIRhZRHD350nQYXObcdh3PLEURuRRXG9BBBaMAc7L2S3KARLH1CdrZR+s/5iatSElRLhvTU8uUG6b/PYq2ITYgjS2i/MWTH58PLwe32BJZTF1pHUojBUJB6mqI0joyWq2ofpHJP5NnoYMr6Lafksdor4F5TEW1WNARADpn8ESC+UIlQoChL4I7EqweRYMWZRLP1SBKISWQZfiZdZg==
Received: from BL1PR13CA0125.namprd13.prod.outlook.com (2603:10b6:208:2bb::10)
 by DS2PR12MB9822.namprd12.prod.outlook.com (2603:10b6:8:2ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Sat, 14 Jun
 2025 06:35:53 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::ec) by BL1PR13CA0125.outlook.office365.com
 (2603:10b6:208:2bb::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:37 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:36 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 06/14] iommu: Introduce get_viommu_size and viommu_init ops
Date: Fri, 13 Jun 2025 23:35:18 -0700
Message-ID: <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DS2PR12MB9822:EE_
X-MS-Office365-Filtering-Correlation-Id: 851440d2-0d55-4411-0fa6-08ddab0db5be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N1JY4VgLKgbO4SAzdvZ4JWkwBPnyrvYCTuRT7jOX3BNmjHsVGXJds5e1yeYR?=
 =?us-ascii?Q?v6vhPJwom5Is1QlXEmjdGFxg9gxuIe9QA8fxcIGIdGnorg41AhGvps0Y2SY6?=
 =?us-ascii?Q?Sq99ibQ2NWgZIGAnBDu96etHZhgEAnCK8IqREUrwJOH2bavcnkS+6fVvpocw?=
 =?us-ascii?Q?871alWgyCuapMFBIYZmmOfP0lIWxGqH6mQ87MGgzTcSqskUuciHYrV3FalQK?=
 =?us-ascii?Q?tEevIzHQK1fla2qnFZrmYRiXg0Jc/aCxREwbVjs6tY/n0+thXyfaMZkxJWnG?=
 =?us-ascii?Q?k/NJePSJw2GGvZTSIhTos7FtnMk18yiu44HNw6g4w7MPc1SV43j5f2DISnUq?=
 =?us-ascii?Q?3KpNKvMsogu3VZ/mhbkjlJ5hyRLW0QFz1HWPFCPaaoF5/sqzHc9jYVAnyXun?=
 =?us-ascii?Q?cyLrepu+P/5wih0ibjISxBO9odFLvX+r/fQzO+u0PjoQiCD56iDmrA1cOP9d?=
 =?us-ascii?Q?O78ok4FjwaFmjTWrUw53dowPNUGcka0qWsSogoc7hyjn5GjuABhVex2YnlzY?=
 =?us-ascii?Q?YrPTUZHfh4Azzd15f//7RyPQzgapg0ihfJBKDAVkme4Qg7AACE6fh2JWmtX1?=
 =?us-ascii?Q?efywW0Q3DTawMR7zvlkpoeQBZ1fT89z0jp/sMpb7xAaiRehSWPZOHjJwW7hi?=
 =?us-ascii?Q?0K5dfUrfbLpEqkltwEeQmkynZMhJqQFUgIC8FXhjIp2T0scFwtgDIEzUpU2N?=
 =?us-ascii?Q?MqUmvFnGgZol9jBGD227qZSXxfynkO5EXDD4W3cG5LGqNIsjo+6vD9BHpkmL?=
 =?us-ascii?Q?erhvIyvfH74dRYYKbc4AkUeBYNpTGrg8A6b7rv1bj2RGW/j3Zc3MzlpOKJH7?=
 =?us-ascii?Q?z9524d6j+QVF4mIIQFhGisknyb5ThxRFZgWCmxxd+gzW/RIeoYMptWFoW5f/?=
 =?us-ascii?Q?02RrmY8GZ6a7RaZZALujjweHbQRNr3LsX3D697Vo9jM/QN2WMEiQzLBJ+U8W?=
 =?us-ascii?Q?aoopqeS7MHL9MAN77QRrE5z1GRgLZYS8z92XgEntgkYfs31Bpq65BehhDPD4?=
 =?us-ascii?Q?gpt0kZUl2qxfpZZ8xA5ivFYYkQi+gNnR8z5M62cFBf/h5y7nVTj8tPj6v/Rx?=
 =?us-ascii?Q?2UR/k6IpBnFcs6pDttCzY80yUt0LihWrhD+vqLCt2ck+or7eZWMtMJT1wfn0?=
 =?us-ascii?Q?oO5WTRuOIc+U1X7eh5QwugE6CDKRNa36RQw0qafvzeJ9M0ot9adPaj8kiQ8H?=
 =?us-ascii?Q?AGYPjpoUzGuWw5E9tZewkOCO5VC4NaZYIZ90AFziQCH6QzZjWQ8zrh4L8/m3?=
 =?us-ascii?Q?q9pHxszqXkNSFovL4mx83QEFCa9o8y1GC0h5EyEayV0OTsnKETLe5FwwjfVT?=
 =?us-ascii?Q?xCm3dQRy3QGZdoSEUj6klDh9MTVRGzag8xa1LZo+ufznYAD2iH5dNe685xUZ?=
 =?us-ascii?Q?lHrPW4u+pQ93bCCrCZy/6lK0BGUkK0jbclhHspmeeZZxjv1QOHrj/PbWkj9v?=
 =?us-ascii?Q?kHI+aUxD5KVUl7RV51Vb1WFMoI2m3eZ10KYgcK5My7h3mE7Q/A/XzTZ22gFZ?=
 =?us-ascii?Q?Okrz+z+iorg4NsuKkFY3vLwsfrHOyJUmyuZz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:52.6522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 851440d2-0d55-4411-0fa6-08ddab0db5be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9822

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

core:	viommu = ops->viommu_alloc();
driver:	// my_viommu is successfully allocated
driver:	my_viommu = iommufd_viommu_alloc(...);
driver:	// This may crash if it reads viommu->ictx
driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
core:	viommu->ictx = ucmd->ictx;
core:	...

To ease such a condition, allow the IOMMU driver to report the size of its
vIOMMU structure, let the core allocate a vIOMMU object and initialize the
core-level structure first, and then hand it over the driver to initialize
its driver-level structure.

Thus, this requires two new iommu ops, get_viommu_size and viommu_init, so
iommufd core can communicate with drivers to replace the viommu_alloc op:

core:	viommu = ops->get_viommu_size();
driver:	return VIOMMU_STRUCT_SIZE();
core:	viommu->ictx = ucmd->ictx; // and others
core:	rc = ops->viommu_init();
driver:	// This is safe now as viommu->ictx is inited
driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
core:	...

This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which would
statically sanitize the driver structure.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h   | 15 +++++++++++++++
 include/linux/iommufd.h |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 156732807994..9be4ff370f1e 100644
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
+ *                   @dev corresponding to @viommu_type. Driver should return 0
+ *                   if vIOMMU isn't supported accordingly. It is required for
+ *                   driver to use the VIOMMU_STRUCT_SIZE macro to sanitize the
+ *                   driver-level vIOMMU structure related to the core one
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
 
+	size_t (*get_viommu_size)(struct device *dev,
+				  enum iommu_viommu_type viommu_type);
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

