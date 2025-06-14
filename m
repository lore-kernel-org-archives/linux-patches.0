Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8762B1F91F6;
	Sat, 14 Jun 2025 06:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882960; cv=fail; b=gyXVac51Nzip3ubn92QgNP8KWkEWIQ8iwp/BG3DJismRZqdmW/9pBFY9rrUN42G0BR6PV3l7SWITh6VkeQEAn2+/Q8sPuLkV34fAp54egMh9cfwrSFwBH0Ux/OwpldaWmb4elS0w56VShaB4XjBy7/wgtH3GSRnljhy82SXKG5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882960; c=relaxed/simple;
	bh=2AVA37Eu1Ph6oHmqZUUDW73kXWnZYzdXA+57UySEx4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLG9FL4KV4jexmxXrXA0TpEiJKi/KpGex/Xi1j1dg8Txbk9TE9E1sDOrZJsqrE7kKTsrjq6+Kd+aWws9qNKQHOXntR68gkW3PvJtT61lXUIObREjbxQSu9mJYEoosi36EXGVXDTOh8sXavEQKuRutBzFpYg0CDXev1I3zhbuNQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pZCyCvh4; arc=fail smtp.client-ip=40.107.92.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pZCyCvh4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEOkoobnN9gEenNAgDue0EYrJOxTrblZkOX0mkHVWmPkn3huXgyhMHF57FPb20bswNQ0EqKyV+uaJ4p4tT7/N8o+vrvjGlXGYQ1cffOUbdgNk8lH+Y89Ti7V21ujh9XhTOwJAOvLhmeNW4wz84nJq0L5E6IdqyKkcAhXCZKTpdvKIc8y/nzpHcTO18EY1umWgO0d4cO4i5sz0LOLEZEptaz40gUaTVVuIEepP/+bGL36lWolFXH0OKmDxZkTdREDtcsd5NWdt0+zlBI6U7gC45RmrFJQ0hKH2ctFnC4TQIyZeXkxZ5Wi5BEeSyMN5HTeFZcVhSjCD/4k0JYjqNhmrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzRICHr/rbnxzlW0m7MaValzQike50M7b3rplFoYPss=;
 b=Tt7RtDQpvs4nllK/lShhnZrAshQVf4U68USeIWqxMo+jqdCJOcGxcn6YQ/ULKIaNxyQLDa/u+5C3/8nFnUKRXd5oSxQ3vOFjdxWpXcDDY8z/4wd8nOY98+rSQcgwSx6vkc1/j3GCqBryhhg6mjwwUNWfDjhkr7ybvCOyqsx34PM0ydC+9I7pFu9mhKuePuFLZTOVfYNjPkgG1S0tVOhrEiqQzR5MUN+zbF+9ljuy96pZg3r7y5Q4TqwwulGhGmDXMiCC0+agzaxR5lzxNS3d+ycKCz74jzN9z9o43nDPMgpIvJ2OSwZcRWj0YK+DG+Um/r4IRRtY5vETgn5TOsewug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzRICHr/rbnxzlW0m7MaValzQike50M7b3rplFoYPss=;
 b=pZCyCvh4hJQEJNIHJQQRy2oCcBr22dDHbekWPRvcBPSvplNkl9B0Bx9xnO2Dtdvo+jpBfSvrQK4ITaT0YZvAvvmgMrqXwixYgi7tJvq6o2RYGxnuGkpSLmmWlS03+ppLgZPPj0iMuSkaL5LtrxvkBkTdtzQqTyoaWveq9QZyT9qMV2+/+VnfRWCW2q/l5P5Uzdu2xo+3ORA8Abs2uFeLmherdqF2jKGuZSaBbXjh5gW38Snbqdw9QZo6rGRc3ouryCtM9zwaVkkW/e6m3/WIgc38oF8On1MWgdfUuNyUuPrHy1lVl15jgnzFYTi6ljd71ka3zKTBG3Qc3xE0hF/bSQ==
Received: from CH2PR02CA0010.namprd02.prod.outlook.com (2603:10b6:610:4e::20)
 by PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Sat, 14 Jun
 2025 06:35:53 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::75) by CH2PR02CA0010.outlook.office365.com
 (2603:10b6:610:4e::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Sat,
 14 Jun 2025 06:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:42 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:42 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:41 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 11/14] iommu: Deprecate viommu_alloc op
Date: Fri, 13 Jun 2025 23:35:23 -0700
Message-ID: <5b32d4499d7ed02a63e57a293c11b642d226ef8d.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|PH7PR12MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: b20767d1-0011-4d19-32cc-08ddab0db624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pvxjpIowTMj/R0mD442lxATNJJQKxdNCo4ZeR5whp2lANPeLj5SFDQsQnbLQ?=
 =?us-ascii?Q?gnoJ345+f/vRRBGwJhUGsSILTKOmVZlkkMPjg3fiU3iSLyQDlnQy1fuXvFVe?=
 =?us-ascii?Q?kfivWbzu32qmUNZymrSoS+z3VQE7kTEx/6nJbdjNXfSOHaAzRCmx602RN07a?=
 =?us-ascii?Q?xC+OBWdrPv3PxVrodgS3qLbt3VsrFcfoAJyMsv72gge2oJ/nCZ5Jx7ydrWZR?=
 =?us-ascii?Q?sTvcSoyRurd1Lw8f+kjsYi80uWc0qerBpUX8wS3EVDgCUl5CbHMDkogJIcsb?=
 =?us-ascii?Q?ID9vxtCeNdBXLZIbTKeNpiCkRCRjy1aVkpQD5Lce68u9lR6lAnMAtDDryu05?=
 =?us-ascii?Q?DETCrPUyS0r3siSa9t9a2NuYXBUHREM+XPFB0vN+SBXed6/qBa+VLYIfStxz?=
 =?us-ascii?Q?is0z6TSEBeGTKz2FP4JdpNSRtm/hsxNYqxpb/Qv5qGcxcgOQCVdtBD1Os1Tk?=
 =?us-ascii?Q?nr8zB+UtbTiShe3qEM4Uoev71UQI+fjumMcpSgEZ9WjTPd2KDuuO1ItzUE2n?=
 =?us-ascii?Q?GhNnaCS8+UfZgVYv/Es1o17XUFGAOTaZNc6tiMs48rU5lldWL5Q8qE2dl1gr?=
 =?us-ascii?Q?MuSTbrwEFKORR2rbR2Fj1iMHOfWBqg1htiHPLsCIqFgff08SXEduTCG/vzvK?=
 =?us-ascii?Q?fQKN49VkliYI84/beFAQQpJMQTJvEuLgFY2Zw1PCfMY0JYRIGqUOCSWW5bst?=
 =?us-ascii?Q?OyGtG60MOmll/+dplsJ2tQP9ApvtIvnT45T4wcLGovTnpUGB07JpZITVc0IK?=
 =?us-ascii?Q?Ck93GpFDMQ0HTkLh7hn8WqJl0CHOplp6cEFVhi+22qrhg4bxHb8Nj26D9smH?=
 =?us-ascii?Q?6FsF5So77Di1QvJIHrG441FdVi/ew5JQ2mVqfrY3pECP1idrJIj9ezCTsCN/?=
 =?us-ascii?Q?751oZBqvfhAh8f8u5EMqxYxXSO2kNB0S2eCFu3nUTg6UZV1ocW+adxcQ7ZQK?=
 =?us-ascii?Q?0YJkYj9VcgN4Sk5OfJ1aKOs45mZs92RYG13jvsD80N+VMWFcpPJiik0NOeIN?=
 =?us-ascii?Q?sLx74PoAtUPWws3R+1845k0cldzb6Z42RTglLTOoI1RHFbJbP/aL/5YG0DWa?=
 =?us-ascii?Q?nTs3S8HiYTfgdD/0JeoHWEzpz7GUJpvmkABktZCFAM8hutR9X56dSEktfwVu?=
 =?us-ascii?Q?upsTaPhlqxWoh+G6OJjvD3LB2zaG/dI9/Q9nNzonfaTcEjUdqRktJS9okszy?=
 =?us-ascii?Q?zxaYll6q5MFAWze4Y4dCixdaQjPqW3ENUdJ47qyqDWORjbGfvjrE/XQq+LpK?=
 =?us-ascii?Q?ja/oq/zYGx5BR/T4A+dlayOc2WBNYYtaYGQpVK0SanDU1RZL6/qicP7IW2yL?=
 =?us-ascii?Q?6V9uUS94mnyC6hwKPIP7f6rYexscjaBnY2wGAPek/ZrxzUgvzwQy+Eo6Biy2?=
 =?us-ascii?Q?0PjU5XF/75c7QjTnK01fQ14C0A3ZiWL2D8UkbFzUTz3m/10CW8fXFIzlxcyZ?=
 =?us-ascii?Q?ZB08Z1S8zSi9D6IjSt069SOnnx8AdEiKDL1pl2IBOBFhoe2C0958UGq4G8Ls?=
 =?us-ascii?Q?b5RV78VEhtOvd1UgzbCw+MZgqjhSCJiV2myX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:53.3837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b20767d1-0011-4d19-32cc-08ddab0db624
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8796

To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
are introduced. Now, those existing vIOMMU supported drivers implemented
these two ops, replacing the viommu_alloc one. So, there is no use of it.

Remove it from the headers and the viommu core.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h          | 11 -----------
 include/linux/iommufd.h        | 18 ------------------
 drivers/iommu/iommufd/viommu.c | 20 +++++---------------
 3 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9be4ff370f1e..04548b18df28 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -607,14 +607,6 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *               resources shared/passed to user space IOMMU instance. Associate
  *               it with a nesting @parent_domain. It is required for driver to
  *               set @viommu->ops pointing to its own viommu_ops
- * @viommu_alloc: Allocate an iommufd_viommu on a physical IOMMU instance behind
- *                the @dev, as the set of virtualization resources shared/passed
- *                to user space IOMMU instance. And associate it with a nesting
- *                @parent_domain. The @viommu_type must be defined in the header
- *                include/uapi/linux/iommufd.h
- *                It is required to call iommufd_viommu_alloc() helper for
- *                a bundled allocation of the core and the driver structures,
- *                using the given @ictx pointer.
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @owner: Driver module providing these ops
  * @identity_domain: An always available, always attachable identity
@@ -669,9 +661,6 @@ struct iommu_ops {
 				  enum iommu_viommu_type viommu_type);
 	int (*viommu_init)(struct iommufd_viommu *viommu,
 			   struct iommu_domain *parent_domain);
-	struct iommufd_viommu *(*viommu_alloc)(
-		struct device *dev, struct iommu_domain *parent_domain,
-		struct iommufd_ctx *ictx, unsigned int viommu_type);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 423e08963d90..bf41b242b9f6 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -234,22 +234,4 @@ static inline int iommufd_viommu_report_event(struct iommufd_viommu *viommu,
 	 BUILD_BUG_ON_ZERO(offsetof(drv_struct, member)) +                     \
 	 BUILD_BUG_ON_ZERO(!__same_type(struct iommufd_viommu,                 \
 					((drv_struct *)NULL)->member)))
-
-/*
- * Helpers for IOMMU driver to allocate driver structures that will be freed by
- * the iommufd core. The free op will be called prior to freeing the memory.
- */
-#define iommufd_viommu_alloc(ictx, drv_struct, member, viommu_ops)             \
-	({                                                                     \
-		drv_struct *ret;                                               \
-									       \
-		static_assert(__same_type(struct iommufd_viommu,               \
-					  ((drv_struct *)NULL)->member));      \
-		static_assert(offsetof(drv_struct, member.obj) == 0);          \
-		ret = (drv_struct *)_iommufd_object_alloc(                     \
-			ictx, sizeof(drv_struct), IOMMUFD_OBJ_VIOMMU);         \
-		if (!IS_ERR(ret))                                              \
-			ret->member.ops = viommu_ops;                          \
-		ret;                                                           \
-	})
 #endif
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 27a39f524840..044e3ef06e0f 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -33,8 +33,6 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 
 	ops = dev_iommu_ops(idev->dev);
 	if (!ops->get_viommu_size || !ops->viommu_init) {
-		if (ops->viommu_alloc)
-			goto get_hwpt_paging;
 		rc = -EOPNOTSUPP;
 		goto out_put_idev;
 	}
@@ -54,7 +52,6 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_idev;
 	}
 
-get_hwpt_paging:
 	hwpt_paging = iommufd_get_hwpt_paging(ucmd, cmd->hwpt_id);
 	if (IS_ERR(hwpt_paging)) {
 		rc = PTR_ERR(hwpt_paging);
@@ -66,13 +63,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
-	if (ops->viommu_alloc)
-		viommu = ops->viommu_alloc(idev->dev,
-					   hwpt_paging->common.domain,
-					   ucmd->ictx, cmd->type);
-	else
-		viommu = (struct iommufd_viommu *)_iommufd_object_alloc(
-			ucmd->ictx, viommu_size, IOMMUFD_OBJ_VIOMMU);
+	viommu = (struct iommufd_viommu *)_iommufd_object_alloc(
+		ucmd->ictx, viommu_size, IOMMUFD_OBJ_VIOMMU);
 	if (IS_ERR(viommu)) {
 		rc = PTR_ERR(viommu);
 		goto out_put_hwpt;
@@ -92,11 +84,9 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	 */
 	viommu->iommu_dev = __iommu_get_iommu_dev(idev->dev);
 
-	if (!ops->viommu_alloc) {
-		rc = ops->viommu_init(viommu, hwpt_paging->common.domain);
-		if (rc)
-			goto out_abort;
-	}
+	rc = ops->viommu_init(viommu, hwpt_paging->common.domain);
+	if (rc)
+		goto out_abort;
 
 	/* It is a driver bug that viommu->ops isn't filled */
 	if (WARN_ON_ONCE(!viommu->ops)) {
-- 
2.43.0

