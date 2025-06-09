Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5622D221265;
	Mon,  9 Jun 2025 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489258; cv=fail; b=NEVP7GMBotPokawy22kAlvCavIvWUWSof2e0PVP0hS5Q66R9hA8nc2V8krYRsWj/HJ/wRhC5obVnRDXXbZ5z7QkQK4sRKWUaCDMPxo4qWQ/O953OLArtEWEZ5ZI+LmEIY62sNmWMrWfogcoBgH+kJMoHLZLMi0fjtLo8DxmvPwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489258; c=relaxed/simple;
	bh=dwJNu2t7naZrvE/2Bg4d0FRfShHBCzg05lXimGJVegw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skhi2ZSrXi8GT4YoZL1PtqkTXmRMl+0nvVJjxcRGjOD08Ta9qobyFoG3NbsF7to3JIA2cQ41gHC+vZCJuqfLsPdxRtZKX6feOSEiQ2XXIRZgDdDXV6ViXwaSG3RpP7JBrTjaAYHY9k2d3pw6I8XilzeICIUmcFgZG7KMuJTIxVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ifzZyVKy; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ifzZyVKy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JsEQca22pKtBSLLgafKbWlH1Ih8cDFbXNouOtihjxjrOSirPrCg96CfM2xsj5n75HIyagfwk60ia2LzJLAqDwh73Xf5BBeZBHLD+5wqUmd918VUtwTpma0FP4SvxjOysUSSTiQnrBepqgv7eYoIGMLuN3X5+vwLgzCPgbS7sZdvKW4NcJ1QSqoWJbBajiDgv0300sQuAbc0Ugmji1/Rc7ryn9JNPeUDgV1wokAZZfaWbSmi68bO8iH8VSZqy1FNRh/ltjVK4LooTJ5wvsL/LnC7Xi4nhdeu+vOg0ez2wcOdLx2VOEcEXzgtm0yBf9P0k26Q/y4fMZR4VzX95BdwBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAL8AaEJ0GJpOH+cgDTYfIh+xNzJg9zQTvB2xAjVpJU=;
 b=rpApaNI7/UPlC4RFVl7cI+x2O4g6vDiwos72Rb201NslHV2T6qE01wxteSoqVBQbTlAKRxsIpp0qnJ4PCr19TO+NxyyGNmhfkQAD7po/vnLnaqZOVybYmqg7pPvZAm2T4ym6YYN3GRKvrkWZFbJXBbC7wbsM1i4QKJQeiJKUUqzKRXk0RqL+sWwrOHrGbdcD4ZvBuSGpPH9xBn+zAWWXtpvPtaKRVMthZHndNjYGOwNZvuMU8PoHByQ9NQcX3inJ8Bn0Xty9fT5/7B6Fymr54HFE5F5wcdOlq2cx/FWcTcauN2iuF+L+t//R4MOUMf7id7pMpNsCer+cHpP5EZm8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAL8AaEJ0GJpOH+cgDTYfIh+xNzJg9zQTvB2xAjVpJU=;
 b=ifzZyVKy+zG0ypy0lOxEuK1gy9y0hFn+Gf4Eq6TlnHy/0Jfoq96LrvO4xprOgSEkA5sW6KlBVcYJ2n18l4WOhmv7IxqH2+5eJhOH179eHoOETrlbNAmEUAs0/bqsuIRN3b4/B0rHz2xnIZXBq7Mko12m6wx9sxrrCsuY4xyLHSrlL6QSAV6DBXrHBMiWOaNfalEnfI+JoGBnSRM4xfQV8vwcuCIailgHZ308VeHpzU2neBrbSfZgGSQ7X80rVMBjl08ZF+MFSy0X4rdnlOcvuLtqtRafY0SCZMXKyDxxVIMoP75vCFsmLKJwKptQBvr17mW8CYrxj3G194D6lX4JgA==
Received: from BN9PR03CA0046.namprd03.prod.outlook.com (2603:10b6:408:fb::21)
 by SA5PPF916D632A9.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Mon, 9 Jun
 2025 17:14:12 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:408:fb:cafe::db) by BN9PR03CA0046.outlook.office365.com
 (2603:10b6:408:fb::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 17:14:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:55 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:54 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:53 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 10/12] iommufd: Move _iommufd_object_alloc out of driver.c
Date: Mon, 9 Jun 2025 10:13:33 -0700
Message-ID: <2ebd4bcbd404039d4faaf840dc52d7c44f672016.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|SA5PPF916D632A9:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb0139e-3d41-431e-e761-08dda7790ddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AihVs6nUwYvVREBI/tWvC8JsTn3fIWa373BucUJut84Dzxwd3f42xc+Wp/T4?=
 =?us-ascii?Q?cbzo1zTp3tunGTtU7frO7wWWJEjGoA6w+frW3EA2Peh+79wPSRbek0+aIb7K?=
 =?us-ascii?Q?OjWu+07jPvo7I769s4xTxYCzKuAftvYf0zW7f/Asopq5/PaZkCIxTLMS1wWn?=
 =?us-ascii?Q?QLzMDprOwotr/MPjgTi9xaUZkIsm/fWt07ORO7VL4w/eoez5CdkNhVACGiJq?=
 =?us-ascii?Q?zm0+YLWcaYHw2oMibXm+DkZDU0bsfI7WlHlSic55LyZMxymYF/5bCKsgSNsE?=
 =?us-ascii?Q?QZ0BKIXjyecj2q4g/PmBLiWGFD7Hyk4IMGgoAOx8PutGXK/XN+4X/m2La4LJ?=
 =?us-ascii?Q?Wo982BMH+J9xIiiArKd3e+zENLH+Lad86y/ipmKXTHC8stI/l83bWA01NO3P?=
 =?us-ascii?Q?3L1H2+wxwfh4skd++M4k3HKs/syRnMfDC4D8qC8lzR+dS5pIjhaRd+GWQ19V?=
 =?us-ascii?Q?n7buf7VPQnL45/ITt231+3RmJtg6TM/vLLPgZiOy4D5iVRLmkXDt3pPbe+NR?=
 =?us-ascii?Q?9irSSxrHv1F/pC/2T5jFx0Q04whFP+jN25A2zZ02SWyg7xeyy7MTv3xGrZZs?=
 =?us-ascii?Q?PqN90FgvTwTBwlYxa7vREAVkQNqhYePOzhMlZf1n/ZYgfV6fkrCj0WwBZkBe?=
 =?us-ascii?Q?g+Iz8l/cVfVrYWBqts/mOXWUOyuCHZKxv4B9plG98TQo7ShL916aJcaNqGKs?=
 =?us-ascii?Q?vXy4I4DK9brqeibmvmhD50xsCaeXdVotuWxFCRd5c3Fpw1ong4mui5XIoYtX?=
 =?us-ascii?Q?xuBZA38/gi2lwKc48xrGwREznTOjgPnqLiWOLC8z1nyMJ3/6eWBZEkkMkTsw?=
 =?us-ascii?Q?oUPvdZDfOjgcOlPEihA7sn+LZGFRml/tRTMGqXVARhLKpUuZaMEU0I6yl+S0?=
 =?us-ascii?Q?gtyHjcB2QQHyKVbpCDsu2wTsU0WC+0kf5UnOXdMPt47mOs9+R/wMcXZGdUjv?=
 =?us-ascii?Q?74qsSTVW2XbAQbrQIdL8s9TGwPtXaTgkQMA/l5OFXe2ANYt+XElyB1d6yy9J?=
 =?us-ascii?Q?esymDwRevdRCOCHaiTclunrArOXZGyDmgpUB4zWbSd6ZhQnFhAe269m0HQM0?=
 =?us-ascii?Q?wP4SUjFQbe/uEuQtDAEh4SA3oJaTyErn24YATGWxEyzAzvvu0nFyWzjYR3Sr?=
 =?us-ascii?Q?15PcbXD4ATo/Q8rXZET3Of8FCb3WYYtuHF0KQFawAjcmlN7enuxNd2s5pmt2?=
 =?us-ascii?Q?EV0FJWYKf41SlK6HUuUOi6evvyBDa7RXe40Vi+JiXfARQwKsW25TjMAJfJK9?=
 =?us-ascii?Q?N4plpMiwGvmfB7os9Pao317b5zgtc7I3/wliiSdw4dQ+kSD6gvH9MeeJBBjy?=
 =?us-ascii?Q?36HAkc7e22FSkqQ8Hq/KMGA0gjPLFYIfjYyNVIboXf/Fa93Uw6fzYat/7g2h?=
 =?us-ascii?Q?LkvDR3IT0Nf6dCPVj//v3RopVpY8DTft4ZNU4mhQSWHXgjdZbJVgE95zLpkK?=
 =?us-ascii?Q?PXceqQAL4Ju0XZ2BgQq94hyyIsEWL+r6FgHOewCTqcXUdnD5qXyTnHvzLp7y?=
 =?us-ascii?Q?ytiS/3QrUGKscsRNUY+y/LEtt72mMpJBStTU?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:11.9983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb0139e-3d41-431e-e761-08dda7790ddc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF916D632A9

Now, all driver structures will be allocated by the core, i.e. no longer a
need of driver calling _iommufd_object_alloc. Thus, move it back.

Before:
   text	   data	    bss	    dec	    hex	filename
   3024	    180	      0	   3204	    c84	drivers/iommu/iommufd/driver.o
   9074	    610	     64	   9748	   2614	drivers/iommu/iommufd/main.o
After:
   text	   data	    bss	    dec	    hex	filename
   2665	    164	      0	   2829	    b0d	drivers/iommu/iommufd/driver.o
   9410	    618	     64	  10092	   276c	drivers/iommu/iommufd/main.o

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/iommufd_private.h |  4 +++
 include/linux/iommufd.h                 | 10 --------
 drivers/iommu/iommufd/driver.c          | 33 -------------------------
 drivers/iommu/iommufd/main.c            | 32 ++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 32f0631368e1..ec5b499d139c 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -230,6 +230,10 @@ iommufd_object_put_and_try_destroy(struct iommufd_ctx *ictx,
 	iommufd_object_remove(ictx, obj, obj->id, 0);
 }
 
+struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
+					     size_t size,
+					     enum iommufd_object_type type);
+
 #define __iommufd_object_alloc(ictx, ptr, type, obj)                           \
 	container_of(_iommufd_object_alloc(                                    \
 			     ictx,                                             \
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index bf41b242b9f6..2d1bf2f97ee3 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -190,9 +190,6 @@ static inline int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
 #endif /* CONFIG_IOMMUFD */
 
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER_CORE)
-struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
-					     size_t size,
-					     enum iommufd_object_type type);
 struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
 				       unsigned long vdev_id);
 int iommufd_viommu_get_vdev_id(struct iommufd_viommu *viommu,
@@ -201,13 +198,6 @@ int iommufd_viommu_report_event(struct iommufd_viommu *viommu,
 				enum iommu_veventq_type type, void *event_data,
 				size_t data_len);
 #else /* !CONFIG_IOMMUFD_DRIVER_CORE */
-static inline struct iommufd_object *
-_iommufd_object_alloc(struct iommufd_ctx *ictx, size_t size,
-		      enum iommufd_object_type type)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
 static inline struct device *
 iommufd_viommu_find_dev(struct iommufd_viommu *viommu, unsigned long vdev_id)
 {
diff --git a/drivers/iommu/iommufd/driver.c b/drivers/iommu/iommufd/driver.c
index 922cd1fe7ec2..2fee399a148e 100644
--- a/drivers/iommu/iommufd/driver.c
+++ b/drivers/iommu/iommufd/driver.c
@@ -3,39 +3,6 @@
  */
 #include "iommufd_private.h"
 
-struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
-					     size_t size,
-					     enum iommufd_object_type type)
-{
-	struct iommufd_object *obj;
-	int rc;
-
-	obj = kzalloc(size, GFP_KERNEL_ACCOUNT);
-	if (!obj)
-		return ERR_PTR(-ENOMEM);
-	obj->type = type;
-	/* Starts out bias'd by 1 until it is removed from the xarray */
-	refcount_set(&obj->shortterm_users, 1);
-	refcount_set(&obj->users, 1);
-
-	/*
-	 * Reserve an ID in the xarray but do not publish the pointer yet since
-	 * the caller hasn't initialized it yet. Once the pointer is published
-	 * in the xarray and visible to other threads we can't reliably destroy
-	 * it anymore, so the caller must complete all errorable operations
-	 * before calling iommufd_object_finalize().
-	 */
-	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY, xa_limit_31b,
-		      GFP_KERNEL_ACCOUNT);
-	if (rc)
-		goto out_free;
-	return obj;
-out_free:
-	kfree(obj);
-	return ERR_PTR(rc);
-}
-EXPORT_SYMBOL_NS_GPL(_iommufd_object_alloc, "IOMMUFD");
-
 /* Caller should xa_lock(&viommu->vdevs) to protect the return value */
 struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
 				       unsigned long vdev_id)
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 347c56ef44d8..85ad2853da0b 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -29,6 +29,38 @@ struct iommufd_object_ops {
 static const struct iommufd_object_ops iommufd_object_ops[];
 static struct miscdevice vfio_misc_dev;
 
+struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
+					     size_t size,
+					     enum iommufd_object_type type)
+{
+	struct iommufd_object *obj;
+	int rc;
+
+	obj = kzalloc(size, GFP_KERNEL_ACCOUNT);
+	if (!obj)
+		return ERR_PTR(-ENOMEM);
+	obj->type = type;
+	/* Starts out bias'd by 1 until it is removed from the xarray */
+	refcount_set(&obj->shortterm_users, 1);
+	refcount_set(&obj->users, 1);
+
+	/*
+	 * Reserve an ID in the xarray but do not publish the pointer yet since
+	 * the caller hasn't initialized it yet. Once the pointer is published
+	 * in the xarray and visible to other threads we can't reliably destroy
+	 * it anymore, so the caller must complete all errorable operations
+	 * before calling iommufd_object_finalize().
+	 */
+	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY, xa_limit_31b,
+		      GFP_KERNEL_ACCOUNT);
+	if (rc)
+		goto out_free;
+	return obj;
+out_free:
+	kfree(obj);
+	return ERR_PTR(rc);
+}
+
 /*
  * Allow concurrent access to the object.
  *
-- 
2.43.0

