Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3308633F;
	Mon,  9 Jun 2025 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489242; cv=fail; b=hX8QJL78HYC542/w4Wm7SY4zSQGpom/8115jbsHnYXEOF5bFjTMu9G7TZksnNk72/LTLzgEdtjgGkU/iqze2YlCEdeOK0CheX5kV2atiGTz3Lle2O/BhIy5yuYDjkhvjBaW0ee2L2bHh/j9mrsSjBbqjWwatqATLZkF2xV16esk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489242; c=relaxed/simple;
	bh=g4qJt/CKkJelOxdo2Oga3csrYG1o2R2iNypuIdpbGy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eE2eSDrIskXR+ij6jp70Rck/ZJHAIbp3PGF2BeCupBVEhdBzTkkurkV4s6ULote/MzWfONfmc2HQetfnRi4y5TBfvEmROAqYdBtyhzzdsfLA79bLTWkKayBRE8SQ8WuLejMnWO0753uJfDiv32CAQx7AYFhv6bVyogCCx9pvanI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a5GZy+q5; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a5GZy+q5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bh2r7KBaf+YxuD1RL1e5F6FMT7vMUV2HJ0J3EFON9qreeTT38dRS06UP/VSo0HN6MkEJwruIxkp+9o9X2jMNl7ymqxqHxSDrJ9N+MPisS5ubch4cbIBoxuSQOp9d9+bz06SpISgfEd0h2iov8XRZm7gZ35yY51cwWfljjAzaohKs7IvIUjIr9+88sSvhI/skBAa8p42fZkcgTMwoRjJbfiNXk0+6SCJV9WZDyVZtMj08fP7oh69qIAEbeW9PN8VVhBgjK//WtPyGuluQPKze2DlEorbDozeF9JcVeiYj7IS5LhzM7p6Fax9cdkuYM7cahVrhUIa34muXNegzFAcUtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsF8BjcznT+3WKiDC6VLhWngLhtxU4EyCBlexGedYyc=;
 b=OVPN1zLYyCepR6ivBXOA8X++O6Gq4lId+kDjz5NucKUu1s+LBHNMYwQQmLxLcmIBsh43SI5UAhmcecU8SvNWIm4BO8X6rnm3aJnicOupYY4+Xr1e3KTXe+CztXKPyIidi9b4w+YRigRMwYvpzuz7S3Gxq37eLlOtu77+QMQhhKoCjRJb7lAqBqKnW6BoHQpTNWq/K5XmhumFK6H6A0THyzO0piylfhJTcA+MWH/NUDnr2VB7E0T5qCUv2Z3xeY0hgIdYQCbL61/AEYQr+8lW+OnLGCFv7UUiWV74idgWEryA+Xpv88sLGxo9w2HCPtsEC8hrg+Ltvc8bQuJ9y40UKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsF8BjcznT+3WKiDC6VLhWngLhtxU4EyCBlexGedYyc=;
 b=a5GZy+q56stqGtAIS523oA1AqaaB/oac3iBHQg0xusaYEl4Q9U4nNeWxUU8shucWe9WsoUJdfGJI4cxOVnLIt8MHJvEGp65rjQdx3e5rK6XES5ErTAuBpw0PsUCcN+jVSe5tUZPoUwMpSyEuPY+5PAsbmbdwb63umjCXdCHnxsp3cq9iXYqFsWEsc5YBQyjF2qNg+LiSCVCNt2eLRdUAtbKsmWQl4meX8W6HTxHZ2oiAEpPnz/nDuHJhBIBGkv1OzViUX4lxWo7LIgAVnqXKnRXBCydxF8IRa0+3r3K3erjA1fUffnhXdWXUeXY3q9lT7atThhJ8xZuNaT5mVvRgJw==
Received: from MN2PR14CA0022.namprd14.prod.outlook.com (2603:10b6:208:23e::27)
 by IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Mon, 9 Jun
 2025 17:13:56 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:23e:cafe::36) by MN2PR14CA0022.outlook.office365.com
 (2603:10b6:208:23e::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 17:13:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:13:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:41 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:39 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 01/12] iommufd: Apply obvious cosmetic fixes
Date: Mon, 9 Jun 2025 10:13:24 -0700
Message-ID: <911815af406cc2d9fde50920aef61493be839fcb.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|IA1PR12MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 090dec04-f8d8-4014-cf40-08dda779046c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uqpVUxBGdSHOXjz7eigYV+iWwC3zaqVR0aGsxjqnlX4JF1jl8pSDN8SevrSs?=
 =?us-ascii?Q?D3JkHzXfDa+SFK7BD7nkyDk0D7MdH8UDtEmIyUsVPRZJpAIUzXn1ruahd42x?=
 =?us-ascii?Q?1jasU/F951uvo9rDSXzSoZF07uu+Jc3pCIPL8JQuImfeei9tGtrb7k3Fcrfy?=
 =?us-ascii?Q?ROmn0G8vpvvDTCv+lHJbpBLCnH9RZlQotf+zctJ1YkhPRsGawgVPeWao4o9p?=
 =?us-ascii?Q?9zikMAolxLVOrJLBx1ka0Ov4+PAAPEOsJZAaKOy+l2dIsVvKqNDBPoIBQ1Ex?=
 =?us-ascii?Q?UIJaA5JOHOC7cAw5t96R5mb1dpCpI5b6lWZJvToMf6os8StdDmFCDY52nuEj?=
 =?us-ascii?Q?w8PTKls227FmnWLfIpo+lDRQhaEx6ZnDfdnYjO99QUsG6i4f+Ne+G5ajQD9O?=
 =?us-ascii?Q?QxRaZZIyNCFsqOe9HyjYNkA2l7QkyCc63X8ZBVvTmnKE4nNKcYF1HB7WZ3++?=
 =?us-ascii?Q?6bgx+Fm55CD4EVMObFgpnKZ5PlCn9hX/VQSD2VrF0vt8lmSFGTLXGUmkfF/6?=
 =?us-ascii?Q?O0FlYR8hERw7B8I/6rzlSCpZJmdWAtPp8XAQlpP5RQ6Tm6hUJIpocmD6tiPX?=
 =?us-ascii?Q?7DDuAnjpir7R1NFKteGodH7uhB11GfRjW8MuDw7MRHjjur7fJgeqv464Ok2a?=
 =?us-ascii?Q?GGz1Yl7iWoeAMUadY/kY7ZKSEhot2u23qoVsId2tYPoctpF2vgLZJ014KYk/?=
 =?us-ascii?Q?Nd1eCyLbtFly8SEM2yM6F9nsnC9FJiVy6WUEEyKnOZ3i9Kjs39iqYm624s33?=
 =?us-ascii?Q?iKf8hd8hZCEdjqaCmTdVwSOi0Ycze/4JLGfEt+4J3LZqU6N10lA2zCIx4Tsq?=
 =?us-ascii?Q?PoA2xQgjNQLT4hHdKxam924u62hczGoZ5Fre+0fdoQM1/y4xEWItd/SD8rs3?=
 =?us-ascii?Q?4OCzT7eW/R2kYMVw4sayexrka6OfM4dFzdNHPJueadKLz6DRIJ558JMZfRVZ?=
 =?us-ascii?Q?6TC04j8te/i6WZQyDphOC6G8GaCtDoSSoZoDDPxcmEuUce79aB+a9GMU7C/+?=
 =?us-ascii?Q?KsvANLas2dT3l2f1QfhS7ImdhpGRwy0zMBtqLvOLNNGFDfaSL/cUhqsaQBoN?=
 =?us-ascii?Q?m9o60yPbufjLALM0FEH5nESGyJGXW66isntaBZzCsf0yBucPya23U0WTriaa?=
 =?us-ascii?Q?Nelnq3rGjCnY+MJJgq76v+MkHrs5FoIiI0007I9yZ67P6OJ2tVUm6zv7COKF?=
 =?us-ascii?Q?vv94tLL4uATO0cITkaOiXxD//J4+hD3MHEibqIR3KebY+PtaQJ3nRa5SnlPn?=
 =?us-ascii?Q?zcDFW4QNxcXhZhVLncun8bDma+1B2pEQtNLssdKkwTpU9gadUkQSMZ55MWCj?=
 =?us-ascii?Q?XrdH8DLpildGFdddDsxRWPk/L7Fpd9kWXEY9Be12ZUgs9csaG0ayRFianrks?=
 =?us-ascii?Q?NjnGBw2ynFeKrcgg8cv8jCYZTaVQHGfQed6PccGEJYmIVAV2O08+oLsSPN/c?=
 =?us-ascii?Q?6wCBt2I26urgzypoAaEoO/4ny/ayBImTR7Q5sTFoDBTy2iRQ2hRbk34Ukks/?=
 =?us-ascii?Q?IBIJL8s6kSFktP151MVg4MtqRP3ViUiFQ+7R?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:13:56.1646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 090dec04-f8d8-4014-cf40-08dda779046c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517

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

