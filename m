Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E621E9B3D;
	Sat, 14 Jun 2025 06:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882968; cv=fail; b=fP1riIFyBOhW4jl3P/gPT5IPlsR4cnAEMsmF1su7fcrxUUFiD9y1wEBqvxhCnvk0hf/8/r0JZhGGkPaxaJU2QUPU743qPZRzBOYoAQjdN45SWE/JgkwQDUMV5EqyRBBsOonNgqkUE+q2uV8Is2ZXXxYCkAHJ3y0hyop9zsqOn98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882968; c=relaxed/simple;
	bh=FrKXrudyhfqtmpcMHlkL8Sa6PU/A8qMmLzDVtLEnuSs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtVAlNmhobh/6LU3Jr9YHx2HQvlxnGcf04Lnxx84m0DLTg7P/2hqniRvy3XzRgB3r+Ir8m8lukka/ZEMlpOn3K/TaixvnXV2Mej1aA5mTh65edNoMVqODZ1LfqHD4MR4FJ59YDtI5iqcvfIY5ihc+OOT47MecZFyUz+Sepoaxns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CSuDe3H/; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CSuDe3H/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lYCDrXRzess/ygaQ5sMcls/CfTWgr8QeZbsaxa/h/Me5cm+jEHhnAFaSHmXQubTeJBdPYpdyeOL2Kt4oBggG++C2X2Sd/+4CT/8Dcnw+HkDCZd5d80Gpd62yiyoPAP0gUUIof06ahhhVWvLZiGuZTKZdR75nrsjgvFHY3+bkCzuWVc0dUp8SRhoOWiosTLi0H8A4i+/DPhBEcZQ4jMiKPPvw9K1kjY59MbO8fB2Z55DJhPgbPLec2ukp+LT77CvB4lkZRuGMfQMPw11ld8/YTgloyIPP2bJROgBUsC18yH8DpytMIE5Y8FR3nHk7BEBsQp0OiY+S58qXERheUcW64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDvUc5Lg3kfoN4Sb/WC3fCMh51yl0AAzH4VpwbOIevs=;
 b=ud75h+9KCL73rbEXI/sMXq0awfVxV+y2aB11ouFmuLAgoxinegJJt7B4bIZThoqYKcsuMN2WSfO5u5EtiOAk4NAsJsNnEM3rp2ILrHtzmppiUt8m4wr/cdrY0+4SGNDhfPJX9XuXX32MvPO6QBvnBKgLv3BSiO6qPmI1EVx8vEVE6uiDCPEwxZ1gHrpq74eY48R0GFxbYpmiKALJZJcl8t9U9h/bTcAfaxDH9LCPG4Rq2X0bvWfphrdFb8PW6lwhSR1fGaR06W+LX2fuMMNFGgCFoziOiiQ4p4ycdWxz2c61TctInwfaDZ8RvBJ9iQRFZ7uX3pBusEEaxyRW+I9jqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDvUc5Lg3kfoN4Sb/WC3fCMh51yl0AAzH4VpwbOIevs=;
 b=CSuDe3H/pBG4/qBMChzEuXPSZz+VitsCO+Q/VAiQrSFZLh5/0QDz8cQfgU/o4F3Uwc5TyZHkjyYphzDTzi5P8wsyXxyL2b/hQTo6QodjeXn8aVnAzgxPCUMluhGRUxSub1NNE+vTg8nBPLzNLbYe8hXfMMKqYB0PYOwH6ZuYvs3LTAcCEWI4EaL2pQDR9RfBtRbKknlZgPJvrgBn5THPF9R14BYbOcsrVtwJPelZdGIr9lGolahpXLV5Bg303Zmoj2gOXZiujY8vS9W/KFRD0dR3DRjXzPpCM6kumhnKAscO3bgBmD/K3SgdoYcpUhcUzq8NrovTSFMWKEP49vUV4Q==
Received: from BL0PR02CA0132.namprd02.prod.outlook.com (2603:10b6:208:35::37)
 by SJ5PPF0AEDE5C3D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::989) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Sat, 14 Jun
 2025 06:36:02 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:35:cafe::94) by BL0PR02CA0132.outlook.office365.com
 (2603:10b6:208:35::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Sat,
 14 Jun 2025 06:36:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:36:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:46 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:45 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 14/14] iommufd: Apply the new iommufd_object_alloc_ucmd helper
Date: Fri, 13 Jun 2025 23:35:26 -0700
Message-ID: <107b24a3b791091bb09c92ffb0081c56c413b26d.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|SJ5PPF0AEDE5C3D:EE_
X-MS-Office365-Filtering-Correlation-Id: 493849e3-7a39-4564-0209-08ddab0dbad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ivEEGSh5arCL8omeE9+AwYjbAAvSWGIcKrjcJVXAPEqOWvzJ4m+row9GeubY?=
 =?us-ascii?Q?PMgzAgU7Xiw8AK8iUUDDII4VanGOtgK9DeviUB4yHhM/t5aTJA3WAIebQoW1?=
 =?us-ascii?Q?pcSNM/jeTyUMPu/ekrBmyhK4Wh7mJNJXKBA8gwBgwBbNiaqUiSs4iZDT7a+U?=
 =?us-ascii?Q?sZeDRwgDxC1OZzyeqwoj+Lxz5P9nBuhLreuxWyBCbYg6UcJ74f9kt3u+N5ad?=
 =?us-ascii?Q?UdyCQ/awfR54PLiz8C2GNb5RaS3E7eDZxm+8hkeAQJ4BNncvI6JP9nlBLysl?=
 =?us-ascii?Q?MZtnLs0Xb0Ccnq6xSBERIjheQsP/HDZwMG3H3w3UhpxaaS7vLzhz2MqPmi/E?=
 =?us-ascii?Q?XHb0QSpOUwd1REe18fj5b21O+OoIVIVYQBPLZyh3h2e7BcySX+P4H1oqlrEK?=
 =?us-ascii?Q?HgXr/AJ5ZW+MO63AQhKGRrcmLerpvsGDc7F4x6zNQhPHgpXqajl3ZM392AZ2?=
 =?us-ascii?Q?ML10haSYLhNH6GxcHd6b6Vl0/0LgVPJo1Troax72ML1408StbV1sAPOlaoOd?=
 =?us-ascii?Q?sRP6142NBxMLiPgE1ikX1QCdK0lp6MNR0pBZXJqXyArxuTtRkroqY0PBkTuO?=
 =?us-ascii?Q?RRuVP5+3qv5A+aI7jKpHp8nOQ85f7it/zPGllP9WjYm3JG4BMMkbd81xpC4n?=
 =?us-ascii?Q?7qTqSP+VcaP/NqbYuazxnlf30Wxq5OXFJSUh+fB7JVVE2rvvC3XIychvcgjA?=
 =?us-ascii?Q?G0vFbMjQk1pmU+WOoQJeB6LCtcscsmphy1xUBt+LZym/+vPl2ChaPiw5DyDP?=
 =?us-ascii?Q?ewxCV7tPAR37TwfEVOoQKCA6tbucLKJT4x0lyz1RttW1j6bRdgio4g19El1S?=
 =?us-ascii?Q?3kjXbdt8EinDrtlj/SyAoCduygRqto6vb8GS0W3GW9iVHnfZibRx1ncDoxdc?=
 =?us-ascii?Q?85UFtDKWfLOsILEz5yKh+VksvQE0NkIMmFvAoUA3mGbDbjkGLvCb73hirrE6?=
 =?us-ascii?Q?C5lZKL3Bka/ALTFbCWsZvk/d5DlP/abzO7l6ZxCipLsntCatson21KuyDB3S?=
 =?us-ascii?Q?OZe61NQjNRrIu2JmoMT2H4gtWJyhp1ggU2WJTaRTlbto/LfsQm4U8ElYW2I7?=
 =?us-ascii?Q?PyHz20fIUPt7c6P/XwYPo+JUHyn3ecDx9BnaamcWsNbypt2n6SVEif21GZ64?=
 =?us-ascii?Q?9jNFhAyXXeylVxEiWbDT/2ehXXxHOSUYM5NQBvjWP22mNGPhLokl+8vXDNan?=
 =?us-ascii?Q?IcuCSLuRP/rrEXwDp2GHJxQYZ2RKO+JS0riFXD87uN22dkR61EX0jK5li66G?=
 =?us-ascii?Q?3A8fLYfytjrspt2BPav2KcvRjnA+XSy6Y3xx1X1F+M4davpuN29MWR9qF+TF?=
 =?us-ascii?Q?I94kWrAnQ0LTtla7rHeIhyM1q+9qRVSV4xyXTLTR2xIKidCk9YKvA6SWIm0D?=
 =?us-ascii?Q?11cV1pKpnQZTKNEjlDj9XaQj4A3nbjwTBEVMO5B2JK1HchCQx+FTbfp+IlAq?=
 =?us-ascii?Q?cVY9cIk0GgK6DqdYe7gItrGXT/44Xe5la10PZK/XlgWOf4ZtG0nJyHOUXQxK?=
 =?us-ascii?Q?0Z7Nos6WDBDEMGP1pYzpNropvyNlaYRyLljX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:36:01.2109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 493849e3-7a39-4564-0209-08ddab0dbad8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0AEDE5C3D

Now the new ucmd-based object allocator eases the finalize/abort routine,
apply this to all existing allocators that aren't protected by any lock.

Upgrade the for-driver vIOMMU alloctor too, and pass down to all existing
viommu_alloc op accordingly.

Note that __iommufd_object_alloc_ucmd() builds in some static tests that
cover both static_asserts in the iommufd_viommu_alloc(). Thus drop them.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/eventq.c | 14 ++++----------
 drivers/iommu/iommufd/viommu.c | 24 ++++++------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/iommufd/eventq.c b/drivers/iommu/iommufd/eventq.c
index e373b9eec7f5..fc4de63b0bce 100644
--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -427,8 +427,8 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 	if (cmd->flags)
 		return -EOPNOTSUPP;
 
-	fault = __iommufd_object_alloc(ucmd->ictx, fault, IOMMUFD_OBJ_FAULT,
-				       common.obj);
+	fault = __iommufd_object_alloc_ucmd(ucmd, fault, IOMMUFD_OBJ_FAULT,
+					    common.obj);
 	if (IS_ERR(fault))
 		return PTR_ERR(fault);
 
@@ -437,10 +437,8 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 
 	fdno = iommufd_eventq_init(&fault->common, "[iommufd-pgfault]",
 				   ucmd->ictx, &iommufd_fault_fops);
-	if (fdno < 0) {
-		rc = fdno;
-		goto out_abort;
-	}
+	if (fdno < 0)
+		return fdno;
 
 	cmd->out_fault_id = fault->common.obj.id;
 	cmd->out_fault_fd = fdno;
@@ -448,7 +446,6 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
 		goto out_put_fdno;
-	iommufd_object_finalize(ucmd->ictx, &fault->common.obj);
 
 	fd_install(fdno, fault->common.filep);
 
@@ -456,9 +453,6 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 out_put_fdno:
 	put_unused_fd(fdno);
 	fput(fault->common.filep);
-out_abort:
-	iommufd_object_abort_and_destroy(ucmd->ictx, &fault->common.obj);
-
 	return rc;
 }
 
diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 044e3ef06e0f..25ac08fbb52a 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -63,8 +63,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
-	viommu = (struct iommufd_viommu *)_iommufd_object_alloc(
-		ucmd->ictx, viommu_size, IOMMUFD_OBJ_VIOMMU);
+	viommu = (struct iommufd_viommu *)_iommufd_object_alloc_ucmd(
+		ucmd, viommu_size, IOMMUFD_OBJ_VIOMMU);
 	if (IS_ERR(viommu)) {
 		rc = PTR_ERR(viommu);
 		goto out_put_hwpt;
@@ -86,23 +86,17 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 
 	rc = ops->viommu_init(viommu, hwpt_paging->common.domain);
 	if (rc)
-		goto out_abort;
+		goto out_put_hwpt;
 
 	/* It is a driver bug that viommu->ops isn't filled */
 	if (WARN_ON_ONCE(!viommu->ops)) {
 		rc = -EOPNOTSUPP;
-		goto out_abort;
+		goto out_put_hwpt;
 	}
 
 	cmd->out_viommu_id = viommu->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
-	if (rc)
-		goto out_abort;
-	iommufd_object_finalize(ucmd->ictx, &viommu->obj);
-	goto out_put_hwpt;
 
-out_abort:
-	iommufd_object_abort_and_destroy(ucmd->ictx, &viommu->obj);
 out_put_hwpt:
 	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
 out_put_idev:
@@ -150,7 +144,7 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_idev;
 	}
 
-	vdev = iommufd_object_alloc(ucmd->ictx, vdev, IOMMUFD_OBJ_VDEVICE);
+	vdev = iommufd_object_alloc_ucmd(ucmd, vdev, IOMMUFD_OBJ_VDEVICE);
 	if (IS_ERR(vdev)) {
 		rc = PTR_ERR(vdev);
 		goto out_put_idev;
@@ -165,18 +159,12 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 	curr = xa_cmpxchg(&viommu->vdevs, virt_id, NULL, vdev, GFP_KERNEL);
 	if (curr) {
 		rc = xa_err(curr) ?: -EEXIST;
-		goto out_abort;
+		goto out_put_idev;
 	}
 
 	cmd->out_vdevice_id = vdev->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
-	if (rc)
-		goto out_abort;
-	iommufd_object_finalize(ucmd->ictx, &vdev->obj);
-	goto out_put_idev;
 
-out_abort:
-	iommufd_object_abort_and_destroy(ucmd->ictx, &vdev->obj);
 out_put_idev:
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 out_put_viommu:
-- 
2.43.0

