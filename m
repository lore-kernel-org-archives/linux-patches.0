Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E8B22126F;
	Mon,  9 Jun 2025 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489262; cv=fail; b=BawENjXyAIQAjwvUZf6aUFZRJCRXkK6Yzp4KB2HX/3pNB7HJjIm1sZmyJWs8voNgEoaHCuWozldSNtReysVoyw572dQyRUyJMZoFTDgp7LB+MFLGySzlcGTwZkyDD/pJ2tyuVbW7t8Kp3CsPX8vgdqfwx+orquAyppm0I3Du8KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489262; c=relaxed/simple;
	bh=Vm7vUu0ySVpK2tJ9Noo9m4c+0mTWjXjVv9+OxIQuvhI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I6uPRfeWb346Hiimx/scvhmmoiZ9mhud9WsOY4SQvU/3SYgTutpYsjuCEYZSz03hWNsaxjiykHN8V87exIREs1nb/MlojhT3F98WFYISXnXixakJH2NN0kWGDW+HzMSVboSX6rT+OkyDprN7LfG5Ef4MnTei8KV7eASk++mf4cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zs8pdM9T; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zs8pdM9T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZWJTGS1BTwfMIyGWhB1IoxsnOmopBwz9iqarEDmp1sUZOqX5OTmd8wYpmwhUNPXWOMADmpZ0hCIseJusnwTJe8Qw8LvQeEF6rw7Pe4gzeLlSebSmMrSq8xLUS4TE+gg6eCadRTgk1sWwow1JPT2e27xPTWLuiB/zwHrDkx3Cwa/Ye/Y00dbKv88nTOCKgmQSrFO8E4lVOanq+jFh+7ijj6dlMFxaZekarUCk9a5R5aQqB1dB0pXGdqFTaaeogD7JovmlAf58UNPp0VEzhUnd74F3pcNBJe/CBPpTh5x1OCLaKeAXZl5C9QOHpofhmFZ+D16Kq7xnRTkP95HvexLt4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8J/Pt2CO/fHZks9QXTl95Cwy3fAmlggzr/A0VSwTlSc=;
 b=Q5w4T7vRtLNLVLTZYf5eP0RziAHR/NvdzqRlY/I247ieLcy7SOsO/7IIsWzNrFdswlL8ywfYtzd8J1Nr4DJC+krxPO5lUN9Q5QT6afwpJASXD6ob0CazQLGKP0I+YgN8EgK32xmCVPnOSIp6dtAViRtqhvl8rpVA8+lb1q6pmTDecoQTp3UihNREVioM6Tln+HDjm9lcGHDa9AgpAP64ZLLG9QfaXFfXi/dqOqpPVZDi50A2UZgzHMN8/5Xi5Wj+ypAgupL/WGgQ+zMlfudeUte9kR9odAZ6JjzgAWW4LxEOfGNwMd8YV3z+XoJFWluLeoIlhLD3sYcpIF/iiMTVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8J/Pt2CO/fHZks9QXTl95Cwy3fAmlggzr/A0VSwTlSc=;
 b=Zs8pdM9TUofS8iNtL6wjrBwhM7n1zVQdtXIREmXG5Alo26NKQ36KyXmmHHFSaDX6uW4+GiiM9HAF009KWXtWb05uFBDuADcSc5q2hRRjakCuqHvvZWGBl+e7EXkhcrKbP+3Kat4DiEocvyAMHnUgG1VH5XNTbJ3/GGMQYb/F9KFxDxT3BTW+AmsO7JXIAvy27ZfB/UyJmRdzRnKCZ8+WB8KtyzfaRjHDfL4mjArVVGg3cBBPg6p7fi9MGXcWDUQh3LwuFbaQCIQYoZFo/Z85Qp0B6SW6c6yelljpEzGYiwKL8O3K2a6zfbBYAVAXvTxMbCGZWnn64F8EiLIecEfcHg==
Received: from MN2PR05CA0007.namprd05.prod.outlook.com (2603:10b6:208:c0::20)
 by MW6PR12MB8664.namprd12.prod.outlook.com (2603:10b6:303:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:14:15 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:c0:cafe::b7) by MN2PR05CA0007.outlook.office365.com
 (2603:10b6:208:c0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.14 via Frontend Transport; Mon,
 9 Jun 2025 17:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:58 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:57 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:56 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 12/12] iommufd: Apply the new iommufd_object_alloc_ucmd helper
Date: Mon, 9 Jun 2025 10:13:35 -0700
Message-ID: <1dc6db3fb727f33818d37c6e46bcf3a7ff4d4ce2.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|MW6PR12MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: a002406d-5cd7-49c9-dd60-08dda7790f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a51+W/k64dRkM+0PQJrULO2b15DjkCjS2yU7TFAoTLyVWNfUuiO51DQcbkHA?=
 =?us-ascii?Q?Q2Twjj6BlI2Mkvo5htNu5EyKf4jMfmKL7qgkgBjLg+gQ4lOQ9eG9pJn9bo3p?=
 =?us-ascii?Q?TdGANk1S+3xqNhV3SK5OUCjEqjDQfvTElKdsNcpxhVu9nxFgyPR7RiughDxw?=
 =?us-ascii?Q?Bjlqfb+rum+Vy+YWUzKhRHPYwl/lJgPKdJvF6EdoKawpYIsPziFtXUlwNMoj?=
 =?us-ascii?Q?yuokgxSVO5PZ0Zw70NufTk+r5cQH/68SiD0PhmaqOV//bZutXOKPk6tsoSjF?=
 =?us-ascii?Q?0mDAHcVUaY2Cau+pOtTghYrqAaL5X3QpIOSqe36tFi9hTfljLC/tansa2yPO?=
 =?us-ascii?Q?JHLe3KJ1deiwqSWQ7uzz7cIXm526LtkGFcOBet4w/Nae76OweJVfZjA/3SyX?=
 =?us-ascii?Q?o+XTgJ5SpBKNB0YF1qG7BvxowkFL/zNkNchRaROorrK8Pgniq2cO6LhBCirP?=
 =?us-ascii?Q?5Udv6uF6W3oWCoS6hAEdERI2MEb99OFBb05U6KzLbUeDJlQz1/ahQAn3hUPW?=
 =?us-ascii?Q?Ku10Wo2VgZocjT7CzwHpqtA7ch7W3qD1Ybgz0sEqCEaRlMF34Ml1SmrsShbJ?=
 =?us-ascii?Q?O+W8XU9qrFUwXZUGORUCm/gYxeCy96wu/4wyBAHkRyUZ1mgNqbUCjKxvqS3q?=
 =?us-ascii?Q?lEgThtULrGqNTtED78ov93mjhsdVK3BNBOohLMvWmCWm0LKo+d7jAHs8U91K?=
 =?us-ascii?Q?RqEjF/0QGe3pF5I6491jTowKwZPZnAvnInDaFRzLMpbO0nOQ1O1Q4Kc28XuN?=
 =?us-ascii?Q?qUtS81BeO+TbV46QyTtudpyjmt+F5x4CD1c10GtJwDDRuXKG5/K87Ud5gqCd?=
 =?us-ascii?Q?4qEubzJtP22EuuiXjTnI1q9QqcDRTOWrXsKYHRhznQQNlcQ81g+Op00FcCKR?=
 =?us-ascii?Q?VCWKVMdpbRcMbG6aID8yuiQPi03TAUjMt87FaGkgT3HaZxu3Up1t7yZAg/IN?=
 =?us-ascii?Q?GmcYrhxTLNyNAZAoCHuqEm1Yhq8iL6BzKszyfYA+xfgJnAflZoBIwv/DNzd4?=
 =?us-ascii?Q?fCIU8AFPVgxw7hAOKIizvSCGIsQXaD80HMWhX6+D4RPP5v+h/XqjC5+yVC0/?=
 =?us-ascii?Q?VCw9Fizjqyxb/iIZEQbbO+5xkoZkpQDJvbwuaeIGk/ILgVxqIWaCEDQhA+nG?=
 =?us-ascii?Q?RffqIpFsVXdWmeqTtcdZxJiQl5KIQOv38dgCPwH8sE9aMgSohhc9avxan0Hr?=
 =?us-ascii?Q?PWBcj/F4USN8W7VcF0AsG2nj4cAHQeaxhxAui0DgP2XXvDpS/62Q/Y7NAQ+h?=
 =?us-ascii?Q?eiV7vHMCvRb/YC8YeRIRWx/ILuPu8sQSSRxf6R1Fdr47lf0jScKyuwlzWZ80?=
 =?us-ascii?Q?dSbfXHtt3+nJPFdYFlm9b8cb8GkvVo6wavzbxvJPGgLOSux2pTC0OaBqWuZ/?=
 =?us-ascii?Q?h0AOUxrDTKX4BN75B1yhHDRvm9Iss1ql9FlKwxwnH4PJ0NYhPT7ocmemCpgH?=
 =?us-ascii?Q?KTIZN0qvqvKs9e6t8ZfxJZYMNKynbYRyaZXtBrKqzB8beS1OnhMVk1kY/7/5?=
 =?us-ascii?Q?L5R7O4wlvsXk22pjBEB56wKuMZtv5Lpb+8TB?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:14.8600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a002406d-5cd7-49c9-dd60-08dda7790f91
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8664

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
index 63a92fb27ef4..742df3cb0ba5 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -61,8 +61,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_hwpt;
 	}
 
-	viommu = (struct iommufd_viommu *)_iommufd_object_alloc(
-		ucmd->ictx, viommu_size, IOMMUFD_OBJ_VIOMMU);
+	viommu = (struct iommufd_viommu *)_iommufd_object_alloc_ucmd(
+		ucmd, viommu_size, IOMMUFD_OBJ_VIOMMU);
 	if (IS_ERR(viommu)) {
 		rc = PTR_ERR(viommu);
 		goto out_put_hwpt;
@@ -84,23 +84,17 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd *ucmd)
 
 	rc = ops->viommu_init(viommu, hwpt_paging->common.domain);
 	if (rc)
-		goto out_abort;
+		goto out_put_hwpt;
 
 	/* It is a driver bug that viommu->ops isn't filled */
 	if (WARN_ON_ONCE(!viommu->ops)) {
 		rc = -EINVAL;
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
@@ -148,7 +142,7 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 		goto out_put_idev;
 	}
 
-	vdev = iommufd_object_alloc(ucmd->ictx, vdev, IOMMUFD_OBJ_VDEVICE);
+	vdev = iommufd_object_alloc_ucmd(ucmd, vdev, IOMMUFD_OBJ_VDEVICE);
 	if (IS_ERR(vdev)) {
 		rc = PTR_ERR(vdev);
 		goto out_put_idev;
@@ -163,18 +157,12 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
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

