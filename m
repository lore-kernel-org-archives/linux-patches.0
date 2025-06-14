Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B6E1E2823;
	Sat, 14 Jun 2025 06:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882951; cv=fail; b=mhzf9jFij1UPAWK6Kk33Db4h3UwfpJi00np9c6Blh0bh8N08JL9caMxrDDzeqMMXpM35FB1jb3jtAq4Caw8TZ1RLzr3sPy4pBJjoz31lBXhnNZ7EUG9l/a0GZ//5NJatlgY3WR5kfhpeqtkpNxTuVFcZ3Of9nGnOv0bsy8SoAtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882951; c=relaxed/simple;
	bh=g4qJt/CKkJelOxdo2Oga3csrYG1o2R2iNypuIdpbGy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVhbGM7DG8TG0YLPKQ61l0OUbAXsVlTqG8TMYNFxFpnbBLhK5O+Hxbe8GOwQbALeVq614N0zowFvilerHECNGtGjWGb7nZlw6rgybQUtvsV9i4U27mIQof836jKY1pyuy1ggW1+FNYkovPGohWpJ47YIjLNCUk2Zeemjp10CZqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CKdY0JjR; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CKdY0JjR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jtqV4NV1yHWJL9yp3sdXJMHftwEqZ8BTz7Bx0Tvs0xuOFfkofwP0fh76e1I9My74HESUAZgLl3l6y/1IvENmRjXewu/jBdul73Ua49IZFEzIgzMbx49/l60eQocYmyKxdcVh5YIzfrdzfjLulnFUAD4AarvBGaT2yqeyYjdwBuP/mTay8GuvVkpwDbnFfsrqod7d1BtpL+KnWZiMV356ChxEpWLizZQfbuDjeBy/wJMDXZul1RdUhcvH0Tw3Vdfz1kVxL4S1j7LE0hhet0t1HL6lKuR+I1b566dAi+Wl+2p9IdQeE8SuFeCIvYNvqB4vse0VlD6hI6nvdgP2DWJppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsF8BjcznT+3WKiDC6VLhWngLhtxU4EyCBlexGedYyc=;
 b=zBN/FvUNov+cZZej6aTjFT1QLOTXHnNVkXXWJvzWsKFgvuaUCq5SzKVNVatY+6EexwKsjt2djTHzrBQZVNAoSDhlL5zSABLXhD0+ikC4tPY2SVACwcHpWgl5FH1YY5UJwB7wuRU0Q2rNBJBv5KQmS4ssodTtgb1s/Li2VXuJ4b27ty9dAXkURPloiebkCKT8ISv5DsJscNuAOsL9hyTwD1Ul3hGZDJCAzLr5Gcl34DWTzBXHF+DNFJQmAMSaJUJLifLboyQmejJZl0GnoqN6dXXOOoLJWGpsSrZsYXb4R0vMGgwRtLsJDnMclidNhQpXh8yz3hl2dBwv+TudHnrHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsF8BjcznT+3WKiDC6VLhWngLhtxU4EyCBlexGedYyc=;
 b=CKdY0JjRVwmacopyXFr6mcmZSssKSVC31SG3fd6PCfi8PMpIjpxL1xE4RR/ZUCBO17/Hct1cZ3Vi1L/ZJUKXSwtxMe0YmYFFswJDP5GNMuZwzZ4YUG3YmUlStKNA6Q8BIKplJJwgiVmyJAIM/moqx7LX/XrZYZs58eIWJfK35nVb4KDpy8c8SKfPYEL5+4KYiRbiq/umOm2pMnGEulWYVrLYoAi7b5aosoZHA3DvhhVPo58jSzF0XDS8tRxF446nFo9Fl8z8PRFR/SqBlvyG6uV4lXOVU+c9ympjv0Rypzj78N/wBoAQWLJmKYeBOxNCz/OzDMXhAg/FBX+ZB3jJIg==
Received: from CH0PR03CA0224.namprd03.prod.outlook.com (2603:10b6:610:e7::19)
 by DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Sat, 14 Jun
 2025 06:35:44 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::88) by CH0PR03CA0224.outlook.office365.com
 (2603:10b6:610:e7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:32 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:32 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:31 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 01/14] iommufd: Apply obvious cosmetic fixes
Date: Fri, 13 Jun 2025 23:35:13 -0700
Message-ID: <9132e1ab45690ab1959c66bbb51ac5536a635388.1749882255.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|DM6PR12MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: 005c22e2-ee3d-4adf-5e6d-08ddab0db07d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MqlmwIcX8w2MZfGr50m9F294BkEr9x8CBpI9GeIWDPQvN/rIEg4L8R9c+ocj?=
 =?us-ascii?Q?IVANuJPioqTi3yHtjbmIUgc1pKS+GAMKPKtNLfjt4GzJQVjxNdDpJT6scL3C?=
 =?us-ascii?Q?Xb45oNlKB24tIwtweM4No4HveNdpiTHEVSb01FIaBeqeecSRdtmdjYrALLEz?=
 =?us-ascii?Q?mj/2UuWleSzt5LJh/6dRLueGcTcyj2/UurhBoJjHmY08lYPxi/Z5C8mE0pmm?=
 =?us-ascii?Q?s08icBNJ5gcEff7kSOJsQgLgtBMXut1ONKM7qWKYEc6KDmFLVA2p+ZlXTbuu?=
 =?us-ascii?Q?INlVYryGY47YqeQr9KhTcozua51p/ajnqXP32fmLWAm8JyQagA6FSyswz1IF?=
 =?us-ascii?Q?ru/uz72/Gz/FeGtHMeL/cmyL3dZyXa6ZNgvUvp+WH6qGAk1lnJaFUEEs0i1v?=
 =?us-ascii?Q?0hdi91HIikk7qv0MVuHtcazW0C8mzqETgMHb8mDRES0XgV2C8Uivic3/1avc?=
 =?us-ascii?Q?4eH3Lx3tWvZqApdq3DibM5cZ1qf3pf93tl2ualrEHHTTBqPnOF4tP2HOM0rR?=
 =?us-ascii?Q?NlVEAd5bUnY4KqP4WaG0+7Iuy/POpwie1/DP+7fzpv3VmK4CAw+119vlVxTi?=
 =?us-ascii?Q?SwQ2R9sqC7O0P6qjDBz7So7bkYDmoUUJ2Jgqf0pRF1RIh+2F7Ge3IT0zT5fQ?=
 =?us-ascii?Q?HB85unKRrupONtGslxVLwE1xnH/OSaS9TnvPQxJxQLKOEI9rQyRGo4x1iMq7?=
 =?us-ascii?Q?psNw6sekjGHXoSYB1Vv1w04A0Z85LwN2nshGoBs+b7ijggeuVXo+/aXaC8h2?=
 =?us-ascii?Q?4JGap+VOU+tDeGID4a18NG96xMzHJF/u6t7oq61t5cTqoGGmoRTedmY95RDo?=
 =?us-ascii?Q?bRJkXBzZ6Ls/Haz3jaiqWo+F0Vs0+z7f/fexuN9Vs9ASuQpisghMicMK+5q8?=
 =?us-ascii?Q?e/0vcg7F8rvuy0NhLd8+AW9HsuAcwvcbXLtjA/CionHCw9YSulJBr6sn0k/x?=
 =?us-ascii?Q?1ztptXB1jkep1S94NNfUwrCjw3+4NR76VEuSBP4kUDdpVp0jvtqORhN2maJW?=
 =?us-ascii?Q?/PhugzMZsLSzIwWZLBchmFlUKBoMEtotMPL5K/O6DBxLl+pFaUxvsbDDSusS?=
 =?us-ascii?Q?p7SHXVB2/7NPYnwJa8OY5fVyuwGGJCOYAd3C4l8EzT97SsQkelKr7Kdehccv?=
 =?us-ascii?Q?LnN1dcA7YY0/rN8zN3UPlICQEqx4G5avJEC8zMPVCf5ciNL5zHTp6CQhZume?=
 =?us-ascii?Q?N/HshrvrBh21js55OtZcgvXu/D38uPShSfHZaapf3nts/ultSOtm9Q3Baq+T?=
 =?us-ascii?Q?wSCGln8cQojnCLq6hj4t+naxxrIGv4FdY2Prw3xYoXO0VsEUyqViQDxg5NOV?=
 =?us-ascii?Q?2uqf5HBqd7aLU/990leLFhHGVvuTKFR2wXSrQdkSo4MEfUWgCsPv/9UHxf6/?=
 =?us-ascii?Q?59lWc6hgSJBIxKt6l5GKQfRRS3rVMQvkQb+Ruqc7/ZFKAvfz+a/avVJUJSFh?=
 =?us-ascii?Q?Do7Ugz2UkjHZA0kLJiy82tJDjgJDFnF/hj6ucQEDV7VsmurccCg6Njl4mWRy?=
 =?us-ascii?Q?XrLo61cWqRL26yAVtfw7asP8YWqHkcwn5EcM?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:43.8747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 005c22e2-ee3d-4adf-5e6d-08ddab0db07d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297

Run clang-format but exclude those not so obvious ones, which leaves us:
 - Align indentations
 - Add missing spaces
 - Remove unnecessary spaces
 - Remove unnecessary line wrappings

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/io_pagetable.h    |  2 +-
 drivers/iommu/iommufd/iommufd_private.h |  6 ++----
 include/linux/iommufd.h                 |  5 +++--
 drivers/iommu/iommufd/device.c          |  3 +--
 drivers/iommu/iommufd/hw_pagetable.c    |  6 ++----
 drivers/iommu/iommufd/io_pagetable.c    |  3 +--
 drivers/iommu/iommufd/iova_bitmap.c     |  1 -
 drivers/iommu/iommufd/main.c            |  6 ++----
 drivers/iommu/iommufd/pages.c           |  9 ++++-----
 drivers/iommu/iommufd/selftest.c        | 24 +++++++++++-------------
 10 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 10c928a9a463..c115a51d9384 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -240,7 +240,7 @@ int iopt_area_add_access(struct iopt_area *area, unsigned long start,
 			 unsigned long last, struct page **out_pages,
 			 unsigned int flags);
 void iopt_area_remove_access(struct iopt_area *area, unsigned long start,
-			    unsigned long last);
+			     unsigned long last);
 int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
 			 void *data, unsigned long length, unsigned int flags);
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 9ccc83341f32..190ceb5dada3 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -266,8 +266,7 @@ struct iommufd_ioas {
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ctx *ictx,
 						    u32 id)
 {
-	return container_of(iommufd_get_object(ictx, id,
-					       IOMMUFD_OBJ_IOAS),
+	return container_of(iommufd_get_object(ictx, id, IOMMUFD_OBJ_IOAS),
 			    struct iommufd_ioas, obj);
 }
 
@@ -452,8 +451,7 @@ struct iommufd_access {
 
 int iopt_add_access(struct io_pagetable *iopt, struct iommufd_access *access);
 void iopt_remove_access(struct io_pagetable *iopt,
-			struct iommufd_access *access,
-			u32 iopt_access_list_id);
+			struct iommufd_access *access, u32 iopt_access_list_id);
 void iommufd_access_destroy_object(struct iommufd_object *obj);
 
 struct iommufd_eventq {
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 34b6e6ca4bfa..498c9a768506 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -171,8 +171,9 @@ static inline void iommufd_access_unpin_pages(struct iommufd_access *access,
 {
 }
 
-static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
-		      void *data, size_t len, unsigned int flags)
+static inline int iommufd_access_rw(struct iommufd_access *access,
+				    unsigned long iova, void *data, size_t len,
+				    unsigned int flags)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 86244403b532..ed0dc539d490 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -485,8 +485,7 @@ iommufd_device_get_attach_handle(struct iommufd_device *idev, ioasid_t pasid)
 
 	lockdep_assert_held(&idev->igroup->lock);
 
-	handle =
-		iommu_attach_handle_get(idev->igroup->group, pasid, 0);
+	handle = iommu_attach_handle_get(idev->igroup->group, pasid, 0);
 	if (IS_ERR(handle))
 		return NULL;
 	return to_iommufd_handle(handle);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 487779470261..8565a6f596b2 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -309,10 +309,8 @@ iommufd_viommu_alloc_hwpt_nested(struct iommufd_viommu *viommu, u32 flags,
 	refcount_inc(&viommu->obj.users);
 	hwpt_nested->parent = viommu->hwpt;
 
-	hwpt->domain =
-		viommu->ops->alloc_domain_nested(viommu,
-				flags & ~IOMMU_HWPT_FAULT_ID_VALID,
-				user_data);
+	hwpt->domain = viommu->ops->alloc_domain_nested(
+		viommu, flags & ~IOMMU_HWPT_FAULT_ID_VALID, user_data);
 	if (IS_ERR(hwpt->domain)) {
 		rc = PTR_ERR(hwpt->domain);
 		hwpt->domain = NULL;
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 8a790e597e12..13d010f19ed1 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -1410,8 +1410,7 @@ int iopt_add_access(struct io_pagetable *iopt, struct iommufd_access *access)
 }
 
 void iopt_remove_access(struct io_pagetable *iopt,
-			struct iommufd_access *access,
-			u32 iopt_access_list_id)
+			struct iommufd_access *access, u32 iopt_access_list_id)
 {
 	down_write(&iopt->domains_rwsem);
 	down_write(&iopt->iova_rwsem);
diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index 39a86a4a1d3a..4514575818fc 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -407,7 +407,6 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 
 update_indexes:
 	if (unlikely(!iova_bitmap_mapped_range(mapped, iova, length))) {
-
 		/*
 		 * The attempt to advance the base index to @iova
 		 * may fail if it's out of bounds, or pinning the pages
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 3df468f64e7d..347c56ef44d8 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -102,9 +102,8 @@ static int iommufd_object_dec_wait_shortterm(struct iommufd_ctx *ictx,
 		return 0;
 
 	if (wait_event_timeout(ictx->destroy_wait,
-				refcount_read(&to_destroy->shortterm_users) ==
-					0,
-				msecs_to_jiffies(60000)))
+			       refcount_read(&to_destroy->shortterm_users) == 0,
+			       msecs_to_jiffies(60000)))
 		return 0;
 
 	pr_crit("Time out waiting for iommufd object to become free\n");
@@ -539,7 +538,6 @@ static struct miscdevice iommu_misc_dev = {
 	.mode = 0660,
 };
 
-
 static struct miscdevice vfio_misc_dev = {
 	.minor = VFIO_MINOR,
 	.name = "vfio",
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 3427749bc5ce..cbdde642d2af 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1287,8 +1287,7 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 }
 
 static struct iopt_pages *iopt_alloc_pages(unsigned long start_byte,
-					   unsigned long length,
-					   bool writable)
+					   unsigned long length, bool writable)
 {
 	struct iopt_pages *pages;
 
@@ -1328,7 +1327,7 @@ struct iopt_pages *iopt_alloc_user_pages(void __user *uptr,
 	struct iopt_pages *pages;
 	unsigned long end;
 	void __user *uptr_down =
-		(void __user *) ALIGN_DOWN((uintptr_t)uptr, PAGE_SIZE);
+		(void __user *)ALIGN_DOWN((uintptr_t)uptr, PAGE_SIZE);
 
 	if (check_add_overflow((unsigned long)uptr, length, &end))
 		return ERR_PTR(-EOVERFLOW);
@@ -2111,8 +2110,8 @@ iopt_pages_get_exact_access(struct iopt_pages *pages, unsigned long index,
  * This should be undone through a matching call to iopt_area_remove_access()
  */
 int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
-			  unsigned long last_index, struct page **out_pages,
-			  unsigned int flags)
+			 unsigned long last_index, struct page **out_pages,
+			 unsigned int flags)
 {
 	struct iopt_pages *pages = area->pages;
 	struct iopt_pages_access *access;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 6bd0abf9a641..4d5dca8027b1 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1216,9 +1216,8 @@ static int iommufd_test_md_check_refs(struct iommufd_ucmd *ucmd,
 	return 0;
 }
 
-static int iommufd_test_md_check_iotlb(struct iommufd_ucmd *ucmd,
-				       u32 mockpt_id, unsigned int iotlb_id,
-				       u32 iotlb)
+static int iommufd_test_md_check_iotlb(struct iommufd_ucmd *ucmd, u32 mockpt_id,
+				       unsigned int iotlb_id, u32 iotlb)
 {
 	struct mock_iommu_domain_nested *mock_nested;
 	struct iommufd_hw_pagetable *hwpt;
@@ -1491,7 +1490,7 @@ static int iommufd_test_access_pages(struct iommufd_ucmd *ucmd,
 	int rc;
 
 	/* Prevent syzkaller from triggering a WARN_ON in kvzalloc() */
-	if (length > 16*1024*1024)
+	if (length > 16 * 1024 * 1024)
 		return -ENOMEM;
 
 	if (flags & ~(MOCK_FLAGS_ACCESS_WRITE | MOCK_FLAGS_ACCESS_SYZ))
@@ -1508,7 +1507,7 @@ static int iommufd_test_access_pages(struct iommufd_ucmd *ucmd,
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
 		iova = iommufd_test_syz_conv_iova(staccess->access,
-					&cmd->access_pages.iova);
+						  &cmd->access_pages.iova);
 
 	npages = (ALIGN(iova + length, PAGE_SIZE) -
 		  ALIGN_DOWN(iova, PAGE_SIZE)) /
@@ -1584,7 +1583,7 @@ static int iommufd_test_access_rw(struct iommufd_ucmd *ucmd,
 	int rc;
 
 	/* Prevent syzkaller from triggering a WARN_ON in kvzalloc() */
-	if (length > 16*1024*1024)
+	if (length > 16 * 1024 * 1024)
 		return -ENOMEM;
 
 	if (flags & ~(MOCK_ACCESS_RW_WRITE | MOCK_ACCESS_RW_SLOW_PATH |
@@ -1610,7 +1609,7 @@ static int iommufd_test_access_rw(struct iommufd_ucmd *ucmd,
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
 		iova = iommufd_test_syz_conv_iova(staccess->access,
-				&cmd->access_rw.iova);
+						  &cmd->access_rw.iova);
 
 	rc = iommufd_access_rw(staccess->access, iova, tmp, length, flags);
 	if (rc)
@@ -1665,7 +1664,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 		goto out_put;
 	}
 
-	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
+	if (copy_from_user(tmp, uptr, DIV_ROUND_UP(max, BITS_PER_BYTE))) {
 		rc = -EFAULT;
 		goto out_free;
 	}
@@ -1701,7 +1700,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 static int iommufd_test_trigger_iopf(struct iommufd_ucmd *ucmd,
 				     struct iommu_test_cmd *cmd)
 {
-	struct iopf_fault event = { };
+	struct iopf_fault event = {};
 	struct iommufd_device *idev;
 
 	idev = iommufd_get_device(ucmd, cmd->trigger_iopf.dev_id);
@@ -1832,8 +1831,7 @@ static int iommufd_test_pasid_attach(struct iommufd_ucmd *ucmd,
 
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
-		iommufd_device_detach(sobj->idev.idev,
-				      cmd->pasid_attach.pasid);
+		iommufd_device_detach(sobj->idev.idev, cmd->pasid_attach.pasid);
 
 out_sobj:
 	iommufd_put_object(ucmd->ictx, &sobj->obj);
@@ -2004,8 +2002,8 @@ int __init iommufd_test_init(void)
 		goto err_bus;
 
 	rc = iommu_device_register_bus(&mock_iommu.iommu_dev, &mock_ops,
-				  &iommufd_mock_bus_type.bus,
-				  &iommufd_mock_bus_type.nb);
+				       &iommufd_mock_bus_type.bus,
+				       &iommufd_mock_bus_type.nb);
 	if (rc)
 		goto err_sysfs;
 
-- 
2.43.0

