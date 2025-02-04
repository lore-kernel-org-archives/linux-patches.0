Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F368C1E7C3A;
	Tue,  4 Feb 2025 05:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738645325; cv=fail; b=GrK9wIlERddHqwPUIokjnV2Z2CXaNpqFIBpbGo0jHBjVqM6GSxgi5Lw0EWj+414zdoqpB/CwLoJ7T+3SkSnZWXg9sjOpMOqyG9IXGj1ou550aIfMVwvK2DXX8aGelXkrGGgd8fKFpxzy/ah+DExkewFZUT51Vl2Xc0gJ7oespDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738645325; c=relaxed/simple;
	bh=+6WiS66TD95alx4LZ3VqOmlaxxRV91Tgtv68Ngw4c34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qm5OLmlvARB+qbsRopzGmg5apa6oY+7IqtRS4Oy5at/YUYmgcdfxblZkThO9mJAmTUrHaUM+dsDgAnthvpl25mjI+JZEc9UnNRJ+eM48b+k3vlYodra9cKNzNBn43lmCgQCpgw+nGp/dKpG/vSOeqFVAkW1l1ELzIrYLci0KAWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D2AHjQ6/; arc=fail smtp.client-ip=40.107.243.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D2AHjQ6/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6iv0g6k5gQCp72mvr3isKfQ5CAMs6zoVlcetd85pBkoIqU0ujUeZ3c1que0wSjmfYyQ9SGVQJf0UIVqcHTKEhMORB5nPRShBaqgdPSS7zAyYb/nGvn6REwJTcGrh39UPFniJLQQY9vnwek0NSuVwd8eVbbAiTPS0iYUQFU9dYKRR3kd5Ax+Yr/aA50a+dG309ZTyb0CniQ9QNG66QT2ymnVtNpy71wzpMCUX469X7Ru8lw1eVGhaRZsCA0/NSZwqXiEUpPjK6MWY0SYwFjqz+2q+R2iHUd4gGD2WS+jtSYmqLamUb7YL3Cn2gwB961bybirN0/Ti2J9pBCttNlCMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rjfGzs9tec3Irn/J338YSB29qnNO487MKclWav7C8Q=;
 b=mKuJhxZh0XX5wcSwVQ5ccU2+G+SrnWK/5S+m5HmADbBmQ9na0lInLNqPWO/1jAObMi2VmLLvF2d/OwkcOEfDeCSh3mzDaKE2+lZCChjx5/6Dg+UnEzh7AlfYI96+onIqAD+wB6pHNVr5upydHKy5W5nyB9xP4VwGr2KFjqqJQzs0nYEfxn0JkS2cfGWl+uvBuLSE47e+GiX7SRLDUtYCXpw/2Rw3SnH7SUkUgs8H30KweadlQvPn9S/W5A1ai3waKA7NXjSDSGDST/OTAwUrkQZbWVoACrd11sojWOIhoRfkNbUuC5Y324FGej7DImCe8/SQ6zQSL+ZLc64LbHeDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rjfGzs9tec3Irn/J338YSB29qnNO487MKclWav7C8Q=;
 b=D2AHjQ6/XXJ0tNwE9a514F7IgpYVVl5PeCbnjbel1ENiHb2Gq47Y/ARks1vIaaQynSJDmV6o8x1TGH+O0bgb+mBjTQsTqMUK0B1MVtNKjSJqYnmq4V9j2vnKQkwZYS+AThxnOD/P3THMC/aDHKxGjfafMS/OemtTN7V8SIC4YGL8EVYYWXLN7XZRCS4CCQRUNrpbgzPedne9UMUbwGqcln5EJ7E+Y42cx2eUvprzCGeVIpeQssfQh6rCqhBy1/rp0NwQnYa0zdH5adak8ot2HNBnZj1Pi0xsqfiCiJmySUfZsYQPgpymxs0q46CG1NxC8rXAxvtTY1VU5UWM+ua1FA==
Received: from MW4PR03CA0091.namprd03.prod.outlook.com (2603:10b6:303:b7::6)
 by DM6PR12MB4186.namprd12.prod.outlook.com (2603:10b6:5:21b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.26; Tue, 4 Feb
 2025 05:01:59 +0000
Received: from SJ1PEPF000023CC.namprd02.prod.outlook.com
 (2603:10b6:303:b7:cafe::a2) by MW4PR03CA0091.outlook.office365.com
 (2603:10b6:303:b7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.25 via Frontend Transport; Tue,
 4 Feb 2025 05:01:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023CC.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Tue, 4 Feb 2025 05:01:59 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Feb 2025
 21:01:46 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Feb 2025 21:01:45 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 3 Feb 2025 21:01:45 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
	<patches@lists.linux.dev>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 2/2] iommufd/fault: Remove iommufd_fault_domain_attach/detach/replace_dev()
Date: Mon, 3 Feb 2025 21:00:55 -0800
Message-ID: <3ca94625e9d78270d9a715fa0809414fddd57e58.1738645017.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1738645017.git.nicolinc@nvidia.com>
References: <cover.1738645017.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CC:EE_|DM6PR12MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a50eca5-0924-4c8c-0f1a-08dd44d90e54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rmB5tsWuUchhWcsUQPF+7Hwj0khlcE2cJCt1ILdq8qlvqjUEYmV41XrnjB1I?=
 =?us-ascii?Q?EhZ1TsRdRLlGjQe6oHKT4NJ1GAJrvh0mS5BZYY+XOYkEXAh/gdmAYLGnlhTh?=
 =?us-ascii?Q?ZTEe3tj5Ks/2r2PiqkJB0ANdQLBwBFKePXe4cn/pK3hL+sIrnN0qxAW5kDvL?=
 =?us-ascii?Q?ZyROsRIC3eJbtLe8yB00bEC1ddw+jNk3vO4vZ8+aU5AfAz8Wg+6CYtT9VZG4?=
 =?us-ascii?Q?C3HZOXfhCAJCJvN5f3V7xZZcDnvtZj6PA4OrHGTtBmnowm9LRqIlD6rMaUmm?=
 =?us-ascii?Q?5DzqN187DEp6TZ5Q+oLSiiDpPJQmwoXvSW43L2SLPPIGpYga0ktFPnxtDRci?=
 =?us-ascii?Q?bUP10SnKtaDOr8OyPukH7L2HlW38vpTcN+IpUlXvWIS3Wlr3WqdTMsRXBv9k?=
 =?us-ascii?Q?gKcVIQahu2qtHVTP3aQtfulUngCGjEOxrkNNEtKbUhJggIEZ4TT0Nf8aIeGA?=
 =?us-ascii?Q?ifwHaQyh+cYH3Pcrx2GxAQZemK28pUumfyPiYqAmtbRTWu9vsQT/xhbMVS1L?=
 =?us-ascii?Q?s5Sp0g+2RHNiKnHKcaI+vj1k9WwKOd9sj2ubUxB4AiFstnVrX+O2XzQ+D+1d?=
 =?us-ascii?Q?iV727+1YRu4bfD5zbiGbhFRteliGf6/fg3ycJ6TqMMQU8SFu/k8uCFVUPNfI?=
 =?us-ascii?Q?z6cFPWF6OLtPoDpHhEr7lzSOj2ul75vhwXyU21adGB3tN9tQZNkGTEyB7cJX?=
 =?us-ascii?Q?Ddjkc29SjwUqpJRe15MKaZwaSlEgrLbkA+HD6DSmI6DIXiY57MhoD/UKWw0V?=
 =?us-ascii?Q?1uZ14/RMq9wiCehd9OSsXfywggmGZhKh/y5ldhqwWcrvWvN1zwJzBYk0OuGd?=
 =?us-ascii?Q?D8G1V+iuMjGFiCa27AZlY2WHhyYJfX8jV2pswKRoJ4oD7c/tE/XuUg2TACC/?=
 =?us-ascii?Q?BVfRIuTTpgtOEHTc6uNeDV2Gmeurc8BCSCfFImPERM5QWyqaKpB95abO3xDu?=
 =?us-ascii?Q?wUHYIxJE4KltzS8V6YfP9a4Sx/X4BcjMXXPHSFaLkm+ANkG9UtRsnn93eXkR?=
 =?us-ascii?Q?EG+Wy7WAc7y6+nhvf6Lg5dK1G4Z7b7JI0HfE/ZJyNov7v7Hykrw3q/FCvi3V?=
 =?us-ascii?Q?Vq7FkX4BcVc2iuwLeVqBV+xQgU2vXsWE4s4NhuC/BdSWL2S7/gaJFmCYS9wX?=
 =?us-ascii?Q?4BBhlEstf28EotN6H0MHOgZiQZ/vjo5xH1JmubsZzH0Iyo3xxJm9GeQyUTGx?=
 =?us-ascii?Q?W6aKvde1TB9tleF0y++qmi6X9un4CTS+MmIyKqIaA0tvx18xebiiMjxUabz+?=
 =?us-ascii?Q?xkxZNt2RhwHV6QL3w2H6enzFr9cpgtRcrJGoimsP0LfWAQxa2fTiwuqnuu7k?=
 =?us-ascii?Q?zjN75oXefKBVxB1VgjxAQO8S31/8/VzMJjQmxboQYGgCI6Wd/BjLPXafFQxD?=
 =?us-ascii?Q?/QBjLBxvL/kzTiGvb/rSOxrELputiSAHA76C3zdce4FNa+Z3oaG/7gO/E6UG?=
 =?us-ascii?Q?NtBMbVaDTlzRi1n1KF2+oEJ0u0vFsoKKteoL9l6dVZRnwx79kL3zGljn7Jg+?=
 =?us-ascii?Q?I0CaqIKXPlwZ80s=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 05:01:59.5147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a50eca5-0924-4c8c-0f1a-08dd44d90e54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4186

There are new attach/detach/replace helpers in device.c taking care of both
the attach_handle and the fault specific routines for iopf_enable/disable()
and auto response.

Clean up these redundant functions in the fault.c file.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h |   8 --
 drivers/iommu/iommufd/fault.c           | 120 ------------------------
 2 files changed, 128 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 02fe1ada97cc..8e0e3ab64747 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -496,14 +496,6 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd);
 void iommufd_fault_destroy(struct iommufd_object *obj);
 int iommufd_fault_iopf_handler(struct iopf_group *group);
 
-int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				    struct iommufd_device *idev);
-void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev);
-int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
-				     struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_hw_pagetable *old);
-
 int iommufd_fault_iopf_enable(struct iommufd_device *idev);
 void iommufd_fault_iopf_disable(struct iommufd_device *idev);
 void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index cb844e6799d4..931a3fbe6e32 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -60,44 +60,6 @@ void iommufd_fault_iopf_disable(struct iommufd_device *idev)
 	mutex_unlock(&idev->iopf_lock);
 }
 
-static int __fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev)
-{
-	struct iommufd_attach_handle *handle;
-	int ret;
-
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle)
-		return -ENOMEM;
-
-	handle->idev = idev;
-	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
-					&handle->handle);
-	if (ret)
-		kfree(handle);
-
-	return ret;
-}
-
-int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
-				    struct iommufd_device *idev)
-{
-	int ret;
-
-	if (!hwpt->fault)
-		return -EINVAL;
-
-	ret = iommufd_fault_iopf_enable(idev);
-	if (ret)
-		return ret;
-
-	ret = __fault_domain_attach_dev(hwpt, idev);
-	if (ret)
-		iommufd_fault_iopf_disable(idev);
-
-	return ret;
-}
-
 void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
 				  struct iommufd_attach_handle *handle)
 {
@@ -135,88 +97,6 @@ void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
 	mutex_unlock(&fault->mutex);
 }
 
-static struct iommufd_attach_handle *
-iommufd_device_get_attach_handle(struct iommufd_device *idev)
-{
-	struct iommu_attach_handle *handle;
-
-	handle = iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
-	if (IS_ERR(handle))
-		return NULL;
-
-	return to_iommufd_handle(handle);
-}
-
-void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_device *idev)
-{
-	struct iommufd_attach_handle *handle;
-
-	handle = iommufd_device_get_attach_handle(idev);
-	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
-	iommufd_auto_response_faults(hwpt, handle);
-	iommufd_fault_iopf_disable(idev);
-	kfree(handle);
-}
-
-static int __fault_domain_replace_dev(struct iommufd_device *idev,
-				      struct iommufd_hw_pagetable *hwpt,
-				      struct iommufd_hw_pagetable *old)
-{
-	struct iommufd_attach_handle *handle, *curr = NULL;
-	int ret;
-
-	if (old->fault)
-		curr = iommufd_device_get_attach_handle(idev);
-
-	if (hwpt->fault) {
-		handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-		if (!handle)
-			return -ENOMEM;
-
-		handle->idev = idev;
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, &handle->handle);
-	} else {
-		ret = iommu_replace_group_handle(idev->igroup->group,
-						 hwpt->domain, NULL);
-	}
-
-	if (!ret && curr) {
-		iommufd_auto_response_faults(old, curr);
-		kfree(curr);
-	}
-
-	return ret;
-}
-
-int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
-				     struct iommufd_hw_pagetable *hwpt,
-				     struct iommufd_hw_pagetable *old)
-{
-	bool iopf_off = !hwpt->fault && old->fault;
-	bool iopf_on = hwpt->fault && !old->fault;
-	int ret;
-
-	if (iopf_on) {
-		ret = iommufd_fault_iopf_enable(idev);
-		if (ret)
-			return ret;
-	}
-
-	ret = __fault_domain_replace_dev(idev, hwpt, old);
-	if (ret) {
-		if (iopf_on)
-			iommufd_fault_iopf_disable(idev);
-		return ret;
-	}
-
-	if (iopf_off)
-		iommufd_fault_iopf_disable(idev);
-
-	return 0;
-}
-
 void iommufd_fault_destroy(struct iommufd_object *obj)
 {
 	struct iommufd_fault *fault = container_of(obj, struct iommufd_fault, obj);
-- 
2.43.0

