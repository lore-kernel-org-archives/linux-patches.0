Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA012D758;
	Tue,  4 Feb 2025 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738645316; cv=fail; b=YkUB50M0rbeMJnB0Rh+B07YI2jVmDwfmLmqJOtmEaEkPdZAxSVRnk4KCVGcEtwrWTlZDav6j7YvcrryVepXDX5qzGkUiyIc5aibof2EhkSVdVuR8z7xm86qT/efsCuBv/MlfKBO2VgcuoS6f3aCnE8/ot0nCt86cad5rQJxz++0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738645316; c=relaxed/simple;
	bh=cJlJrY3gmJ1TLGlfl2CXbi2N3ZhGG4GgiFZphXHupr8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IuRfEuZ0gQsYGHDYjnidsv1M4NBOXETZ2s3VeZmNZSHzVW16768xuF7yKwJs8Xfg7m1aUMji4ARqII+nsCZnwBlFFKk+L/PfF73vmKZHSQyKqORwI7mzcyWD5s8+S+YGNf0QAeZ2poiu6HVHusB5If1Xv3JCgRSqUyJIa2Lw0Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R/+ADdMT; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R/+ADdMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTA1QjdXum9a2ZwDRBeaSZhWUOBjCNhxCtMlGBU+pohkCNz8XyDHNy0bLairJR8MpmNmeF5+2MNcAZYFN8grHKrWa3NivuhdQakS0rNfRO6lykhd+GbZOgSsRqDQXzokWg+ncybQ489dvbZrmcEL5SWXlVub30T8BE0JLvHI5h1CpGtX5Ytq/APIBcn3h/tymkIZf4X7wnXejPeVYCwXTZJAKinCM+tEc4n6VkwEmqiU0U85Z2kEr8YrxTH73psfwk7lkDu/iHqv/Y1UUh29YwmMZU4VhJJUMecHuTwec3fuhZr2O0vd3C/zFQn0IZEWyvhtAQTK4dW+9fibUDOk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5eLIfYH2xuUOcIVegJLr+6HPrpeiWktKNhTpxuKzqs=;
 b=NrVJ8skGrVXuvFyso+lj6idK4vjWBtn9US1Uh1mKDvfMUc7UtbE4V2p4tOQVK4I0tQknvdGUUltBDqC9PHlTImEunK5ocm86AHLi/aCuuEyfjj9cuO8xVERmvJoP6w2KDlyzkZW/B0++XxD66+RT50kVlJlS53/AK0AC2HsLnNLYxF6DGLpTQU7RGlKe1UnRZ0WuJEcJk7yGsPcLardIyX5Em0o10nYrVbyFetIDPO2sSUnkWgGQ3zQqx2x8Ldp0feW+ppe1NozjIem8fdJvSN+0AlzqzhAwDHeHoGzAeSWleZvLowdQSATJiFSUR07Q5jEJ1Gwlzk8EnOLAdVUbHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5eLIfYH2xuUOcIVegJLr+6HPrpeiWktKNhTpxuKzqs=;
 b=R/+ADdMTcTtAtMvErvSF9m8oIUbVH0x20HXBmZTW8Y+0BwImNFIRihl/FAuQT0023D2ghEI31o6QtaL9YB3fNV2x8WzIu8YiGST7H4QCP4rss4utEOFPmaoHGq22ZbAi3APNQCoX67B7dQhbilTvOoSke9Ys7TlA+IVkel0GBVgtw+0u63Pv0M35b2yvfnh213zihPiV96wHEluvqQ9nyzIZDTroW2MKJSiOX7JU5dzh5tA735+aDVEyiKoDuZc4FlE4JUIiiIkycxxDDNhmbp4bxtXIBr7kP6uzdSgXhUjtgdtOg0R1ThbAt+MZ1zlv77La82c5+/r1mBhPsZBHfA==
Received: from SA1P222CA0019.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::20)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 05:01:51 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:806:22c:cafe::c7) by SA1P222CA0019.outlook.office365.com
 (2603:10b6:806:22c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Tue,
 4 Feb 2025 05:01:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Tue, 4 Feb 2025 05:01:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Feb 2025
 21:01:45 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Feb 2025 21:01:44 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 3 Feb 2025 21:01:44 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <eric.auger@redhat.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
	<patches@lists.linux.dev>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/2] iommufd: Make attach_handle generic than fault specific
Date: Mon, 3 Feb 2025 21:00:54 -0800
Message-ID: <32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|MW5PR12MB5683:EE_
X-MS-Office365-Filtering-Correlation-Id: 54bda743-64b8-4725-7b81-08dd44d9094b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Du0in3Yxt6OIxMWVmnMCYwzqfmNLK3jEwd3POKJHSP/FHpuAM1986zvi1+xf?=
 =?us-ascii?Q?v4+2aFdJ1bTXEeVCpSdJhNL7xL/M686En5Ks5KNYgze7i/PfE6kLWQencxAx?=
 =?us-ascii?Q?raoTwk10snNpikWx87d7ZguQ4yKnjludaErHHrTm44I3/q//bIxUIHBYVT8a?=
 =?us-ascii?Q?iBCC7jHkPGDUldfOx25451wnuWbxV7eHNtyU6ZXmypuKPctJmkzD+XUTJJdZ?=
 =?us-ascii?Q?Fiki7km8Wlnv1/XQbBGebMARr/h8gxJZ3zjg/IYrEKlhr4UEJupwujMSZpeU?=
 =?us-ascii?Q?Gbee6Jdf+BLjMN+N/V9ez45ZJrC7ktXqRIBdMiYgDQa7wm5epXBRRssmCUmI?=
 =?us-ascii?Q?MiUBYxUob+DC/ut5znREIe+YWwJCNs5pJBfU5KLzd/gqKo/eGJdPjvUzMSZm?=
 =?us-ascii?Q?ZaGOAl4G8xyBleWJfnz9TorIM4G4y1EUTDw7Zt1N/o74ivsMCZ7lNsRlfPNJ?=
 =?us-ascii?Q?rNB7/vgPBoapRGfSINSpb4JNuO86WE+k9d7RFEEaKtBLn/PA5y0C0Yw9jp0f?=
 =?us-ascii?Q?dgOIVcZRuKHI6tByR6MKNei4QdjCGn/SJCYUteuzfkg8PQWiuTXIn3N/wKEd?=
 =?us-ascii?Q?OrPQz0i6g0d6X3eopllD1+HJz8VZkDqxv2MvkV+KTIQ3l28/zFSkCtq6Egjx?=
 =?us-ascii?Q?YgziAbGt7fYoGag/pTfUdhvBQYHN84Fod1Vm6z7/ME0SdFEWL5sqWuiREU9G?=
 =?us-ascii?Q?uDUPycuY1JEV+ddzq1TkxrF02X++56RSN4YKJTSRN7vUT+sMKmVVfGY34a+n?=
 =?us-ascii?Q?e1sZjUQ8NLUjdHMAuj0ii9iN9gd8oanDPjbfWC4TND8ZMb5Ys9x92/67LW5O?=
 =?us-ascii?Q?UBuFSx7NyZUGm95xUdPqf3LBCahijhICdaEf8H3qstcGb6HuFFsmjEfaW5TL?=
 =?us-ascii?Q?3Sm8ybXD+JrQTo4P1F4XlJnUMguhQdlfRrRVOzE3zSIks3YCzxzDawA3wtdJ?=
 =?us-ascii?Q?X3qjVM+zoC/FuX8HCHkrbCZsCD2ccNa9Xv0tVQ7Zo4N8EDg+ESVcbSdb8WPz?=
 =?us-ascii?Q?XyXm0IPyoCTaYjftgFCtYfA3qc+5T5ivSO+/8shEE9J023+mUKyP4Js7ULYk?=
 =?us-ascii?Q?zFnQfGW4OLpNVCiwQsrMxe5PFqo0u4AkkPPlASDBCqDbsGxoKQF/kpj4bWn7?=
 =?us-ascii?Q?aJ2Ckf+oQN55pj2LAoz7dknN7Yq8eTzEaNmR++HGOm/5uKOWx8kjBIkHmXWj?=
 =?us-ascii?Q?r58EHbsavBOVZtP52raLNC/JlttZ68USzZAzAvndk5oTiSJzuvHiuwqfYmQo?=
 =?us-ascii?Q?njvn3qfsE9ng0l+AxoWPmGKQGwfGR5aRe457hcX9isC3dZZFzsQE6E5Xwc4f?=
 =?us-ascii?Q?O5sorgJUwT92uBiBJ5FlnRx+4jo+lHvPBMXuR6KcjWe5HP4yIcRJ4Ilt78W/?=
 =?us-ascii?Q?79igUUeDkVn1lCmTj4xB/YRT0asw3hWBTPqQ0u/HokOja4roqpDHkQhOeItx?=
 =?us-ascii?Q?X+g5CPxdcg3Ji/Qnrc5C2NNIgt4sH4kJQXS6VzEMaK/bSU+PaGukh/kTpD3t?=
 =?us-ascii?Q?2HUg0Jhd+40Lki8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 05:01:50.9605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54bda743-64b8-4725-7b81-08dd44d9094b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683

"attach_handle" was added exclusively for the iommufd_fault_iopf_handler()
used by IOPF/PRI use cases. Now, both the MSI and PASID series require to
reuse the attach_handle for non-fault cases.

Add a set of new attach/detach/replace helpers that does the attach_handle
allocation/releasing/replacement in the common path and also handles those
fault specific routines such as iopf enabling/disabling and auto response.

This covers both non-fault and fault cases in a clean way, replacing those
inline helpers in the header. The following patch will clean up those old
helpers in the fault.c file.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h |  33 +-------
 drivers/iommu/iommufd/device.c          | 101 ++++++++++++++++++++++++
 drivers/iommu/iommufd/fault.c           |   8 +-
 3 files changed, 109 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 0b1bafc7fd99..02fe1ada97cc 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -504,35 +504,10 @@ int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
 				     struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_hw_pagetable *old);
 
-static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
-					     struct iommufd_device *idev)
-{
-	if (hwpt->fault)
-		return iommufd_fault_domain_attach_dev(hwpt, idev);
-
-	return iommu_attach_group(hwpt->domain, idev->igroup->group);
-}
-
-static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
-					      struct iommufd_device *idev)
-{
-	if (hwpt->fault) {
-		iommufd_fault_domain_detach_dev(hwpt, idev);
-		return;
-	}
-
-	iommu_detach_group(hwpt->domain, idev->igroup->group);
-}
-
-static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
-					      struct iommufd_hw_pagetable *hwpt,
-					      struct iommufd_hw_pagetable *old)
-{
-	if (old->fault || hwpt->fault)
-		return iommufd_fault_domain_replace_dev(idev, hwpt, old);
-
-	return iommu_group_replace_domain(idev->igroup->group, hwpt->domain);
-}
+int iommufd_fault_iopf_enable(struct iommufd_device *idev);
+void iommufd_fault_iopf_disable(struct iommufd_device *idev);
+void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
+				  struct iommufd_attach_handle *handle);
 
 static inline struct iommufd_viommu *
 iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index dfd0898fb6c1..360ba3ed8545 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -352,6 +352,107 @@ iommufd_device_attach_reserved_iova(struct iommufd_device *idev,
 	return 0;
 }
 
+/* The device attach/detach/replace helpers for attach_handle */
+
+static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
+				      struct iommufd_device *idev)
+{
+	struct iommufd_attach_handle *handle;
+	int rc;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	if (hwpt->fault) {
+		rc = iommufd_fault_iopf_enable(idev);
+		if (rc)
+			goto out_free_handle;
+	}
+
+	handle->idev = idev;
+	rc = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
+				       &handle->handle);
+	if (rc)
+		goto out_disable_iopf;
+
+	return 0;
+
+out_disable_iopf:
+	if (hwpt->fault)
+		iommufd_fault_iopf_disable(idev);
+out_free_handle:
+	kfree(handle);
+	return rc;
+}
+
+static struct iommufd_attach_handle *
+iommufd_device_get_attach_handle(struct iommufd_device *idev)
+{
+	struct iommu_attach_handle *handle;
+
+	handle =
+		iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
+	if (IS_ERR(handle))
+		return NULL;
+	return to_iommufd_handle(handle);
+}
+
+static void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
+				       struct iommufd_device *idev)
+{
+	struct iommufd_attach_handle *handle;
+
+	handle = iommufd_device_get_attach_handle(idev);
+	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	if (hwpt->fault) {
+		iommufd_auto_response_faults(hwpt, handle);
+		iommufd_fault_iopf_disable(idev);
+	}
+	kfree(handle);
+}
+
+static int iommufd_hwpt_replace_device(struct iommufd_device *idev,
+				       struct iommufd_hw_pagetable *hwpt,
+				       struct iommufd_hw_pagetable *old)
+{
+	struct iommufd_attach_handle *handle, *old_handle =
+		iommufd_device_get_attach_handle(idev);
+	int rc;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	if (hwpt->fault && !old->fault) {
+		rc = iommufd_fault_iopf_enable(idev);
+		if (rc)
+			goto out_free_handle;
+	}
+
+	handle->idev = idev;
+	rc = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
+					&handle->handle);
+	if (rc)
+		goto out_disable_iopf;
+
+	if (old->fault) {
+		iommufd_auto_response_faults(hwpt, old_handle);
+		if (!hwpt->fault)
+			iommufd_fault_iopf_disable(idev);
+	}
+	kfree(old_handle);
+
+	return 0;
+
+out_disable_iopf:
+	if (hwpt->fault && !old->fault)
+		iommufd_fault_iopf_disable(idev);
+out_free_handle:
+	kfree(handle);
+	return rc;
+}
+
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
 				struct iommufd_device *idev)
 {
diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index d9a937450e55..cb844e6799d4 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -17,7 +17,7 @@
 #include "../iommu-priv.h"
 #include "iommufd_private.h"
 
-static int iommufd_fault_iopf_enable(struct iommufd_device *idev)
+int iommufd_fault_iopf_enable(struct iommufd_device *idev)
 {
 	struct device *dev = idev->dev;
 	int ret;
@@ -50,7 +50,7 @@ static int iommufd_fault_iopf_enable(struct iommufd_device *idev)
 	return ret;
 }
 
-static void iommufd_fault_iopf_disable(struct iommufd_device *idev)
+void iommufd_fault_iopf_disable(struct iommufd_device *idev)
 {
 	mutex_lock(&idev->iopf_lock);
 	if (!WARN_ON(idev->iopf_enabled == 0)) {
@@ -98,8 +98,8 @@ int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
 	return ret;
 }
 
-static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
-					 struct iommufd_attach_handle *handle)
+void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
+				  struct iommufd_attach_handle *handle)
 {
 	struct iommufd_fault *fault = hwpt->fault;
 	struct iopf_group *group, *next;
-- 
2.43.0

