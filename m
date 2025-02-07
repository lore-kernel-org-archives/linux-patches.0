Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001B3DABE1;
	Fri,  7 Feb 2025 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939574; cv=fail; b=ky3KSDvbjSp9h3mqXPzSRN1ok58YBCJWR1lXW3m+AMCwsjdwZb9EouYxr/jWQiC2QQldLcO+f/rZujy7hhi31CN+AYUbvPIsqudjH5EXN4cshqqZ8jyOW0Cyi0zufDdUOVUPTqpolzQd/tA6LRTH7PC6CeTGY5LC3wjkCZ1+9FU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939574; c=relaxed/simple;
	bh=hiHZCk2mJ/To+cBmDKB+p2JNv7NcCgmSUwsCUl3kus0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gs1tit4i7DBSHZX5xTPL5RvBNlOrsZtg4ONpJ8NcHva07MhnTZQZjkLpc/XPHJ0O/pk5sGQaJEez4Z3tHoVjq17xjQo6uGoIXUjo3pgAGJ+3yTXz8uRLtw8pUORGI+XXfHOd/1v436CM7/rC92+IkYbrmFBUj2RbNRWqAXcggCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J+V1EYU4; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J+V1EYU4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSYNTLaW4lyVfJkoc0Lr/zscsV9qArpvfaYbrGiiXFSeSEUhc/b4QXrG/eSE10jMcF5BT36WAx/Q/iFJdhfPQtSc1B8ULxnBlJu8TaL8fqjm2mVf+MMXW5Z3IgrVgalWKyH91jy4Wulkn8rwkZsYVC5gbFlU0BNAdR9JhTjIltTHNBOGWV4AO2n16VR1iWABPJMMFREEbR0nNdkZOVG7iqvGSrAGVLSGKTx+bdAEgaiO04KWO8hwp2w2NVh5GHXP7fAEn1mUiHL3s+sNFQRHer//GvWJCP8WnxR3lyAq7L2ApnH8E393TisLNFRkf+isMteqTpot0EQh53S3ObDvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFMc6u/zbErr7yReG468x/WtpRSu0IzfVMZVC8BOC7k=;
 b=cHGv2gmyiisKjtnvTsH3T0oZukekCNt8seqWn7Pc29jHpZEclRbByPPrcGYxBfezxcH1KmejYYlV6jzIZtIhGHgs5XzwDcBktSnBNFIJZ8YUh/7ALRaO2qYco0WlJSF8sJjVerRyu3ARj9NBQ1Evu/1fu0Cs2YWvO+xauRwoYUx/df0h0fz5NDUSj+QsFT3b41RyCHNIEQiE8C9wJPJdf9M0/6+s/fd3s9X4faV3qxjaoD7GvF5/7+pyfR5tJsQ8r40CwTzJhqjutL85XMYdO4Xdvwe7JJg2v185YGRZe2ZgrWjMnRSoZBlJvXPVKm8uDLBElvaSccQBmL1p/wDtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFMc6u/zbErr7yReG468x/WtpRSu0IzfVMZVC8BOC7k=;
 b=J+V1EYU4JugaBb5HWOabF3apPD4b+NVfpaYqySvGdr6KVAYQ2wPsvmLs99Pclce1tw/zx2fjstxyLaLGCevAGpjpKALIun0UIHxUem7Gc3LCp9wKDgHPRaioUcEv4ownLQrFvZzwDMYEI7ZwOr6vTzRvQrEo5F0nM5uG+BZqFwNxjBdHyoNOsoCPZOsWciDytuelSSKrDlDlELk8o8WvERYGXI9L2LFJrnjh2iQ8S/wOMmNmq2trjDsKYJt56CpXyZPkb/JFSSGF+eX2pTcGvhgPv3JaMLGAHjbq27ro0XLK+PFzcXu/ZMub6snNWUxdlbeMGw3F22Vjos6NthcdVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Date: Fri,  7 Feb 2025 10:46:03 -0400
Message-ID: <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0245.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 156cf09f-5fa9-4f21-6c90-08dd47862732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ge4qmBsvcRO08K1dJrKELxi/bvNMt88nKBMyNm5NmzeVMH69OunBoPG1KTXn?=
 =?us-ascii?Q?nCmKIGvvlMF4PM12CFR5UtNa+UwGEVeVti8va89czCxBu5MMOZjD1MiGP8ib?=
 =?us-ascii?Q?1XcSSvxXH6orjKH8up29B/mWP9Qpdd65iA7fobasGYmDt4NJFrmpV2AmJQc8?=
 =?us-ascii?Q?FIKTuOFzD5KuwctK1yfrjuZE6BAT5gqkS9NZhsBR0ki28eh6XUozOoGt7lMz?=
 =?us-ascii?Q?exQcGOjoQwI4UChfnh+9RzXL6aC0e/tsIg45XNPkv4vejn966sSYRSZi7YcB?=
 =?us-ascii?Q?qtvbEo3oYsso1zAtvW3/nOUaGk7O3aQTvFdcm2VD9q9xeO27g7Xgij/NyTWr?=
 =?us-ascii?Q?x6J05b3BiIhnQHr2VJ1aeEy4JlxmFm9lJv9b5d7ZK7zVnKTvuHn/iQieSKCp?=
 =?us-ascii?Q?neJFwel/zVZ71YZMYYO16tdeqnRdjDhDi2TC62M3wX99ibJAL43S38Z/Pk3v?=
 =?us-ascii?Q?uhRlWxfZqlJeVrWjTGmUk9NogicrH09cYQG4+MV5ryEZsieFZzr+/PV/GHM+?=
 =?us-ascii?Q?fnIRIwJ1YWHVLK8+y7b9JhLqiWtkuIqqvyICcdvjeWWQDdB+ffseLQnpyTHQ?=
 =?us-ascii?Q?uQG/8u5MWwI7kWnPKyFD+ze6Q2X94LiMPyCaVXepcv3bGwtgJRSqqxNJbw92?=
 =?us-ascii?Q?RHrwHOY/Yv0xMmmUfDULEn612l2/AC+0x6qlajHFxwsL/a0KOALycs9YUgeb?=
 =?us-ascii?Q?Y/Wg7I+xj3ycIB9wkF/F2Iy9njVpuvg09Lic7WBKjnYx9Rc6vICokBM4LPmH?=
 =?us-ascii?Q?b5uCqSKIqns09nNNuatVsCnSVsgBw23kkUsB1NKzZ1pZ+8fssXyXj4WcEGsa?=
 =?us-ascii?Q?8zeDN46/creC41+DGIBBQJjdaqRwWnWLUFWHCGO0KeMZi9v950t7Chvohe34?=
 =?us-ascii?Q?Ykn9zQl/qEEM+QrOO0oySlsrtzJnWYMCoA4R5s0WAhKkOnadqd9kpug43j0w?=
 =?us-ascii?Q?2r+M/rSTyR6UjweCiH9MZxfNuf1lwUusxpXonKdHLXls6qa3qhHd1CJ9emUS?=
 =?us-ascii?Q?ADYE04mAI/BvBDK9EGL1z1AgwMajJa3/WUEEsgAQnVvfDLsWfUv65phJy3aI?=
 =?us-ascii?Q?eE1mdhSnbNO2vEb2Hb0OUGT4XamadKqT6mpDGPxINM/aP5pip73dVPXZ4U7e?=
 =?us-ascii?Q?uwzuFYNbceHol3pd9hrboxIaDhHn+X7hjBx91Uu1Ryod4Q1uBuGSr9PulFXF?=
 =?us-ascii?Q?jgLeDBwAM1rlSOet6by3fBRcqYReKuHOEVr+6dlkTcY88h4Rd2zgxdtOgA+2?=
 =?us-ascii?Q?UgGuSttkKGb7bDYBPLrMVS2z26siz9XPPiD8W/RdiLbXkquUm3lJge8MxAM6?=
 =?us-ascii?Q?aP5kvax1Jxv51HetincDstgHerwssMyaR1lgbt1Csuvo5ASwi1uUkCt5jEu3?=
 =?us-ascii?Q?ciQOseLXUb/cL7xr6RaL7j+cn6KO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?33K2oHYNJTAUCK/adS5pxwmpqj3jN6wOzQU7x0n6AAyM1pHbBADSBkt1sp/J?=
 =?us-ascii?Q?r4nVLDp6/BZ6/626NzbZuB2lhBeqNgo/S2sE/eLfURRNOo0JGoXe8iW7ZNKq?=
 =?us-ascii?Q?OB9PG/hwlh8aXu7N28z2sD1SBAdeR7m+qk8Ag2O6mohZTDmE0j+6y0hbVNYs?=
 =?us-ascii?Q?3gFZ080VQEVsulljh5Od0BVNCYK0juI9MTXiqU/MNoddO6k3z2F54xZWQR1K?=
 =?us-ascii?Q?p2yOQySodWj1i6B8ZNCxFS0BGJLK5xJMfK9cOFYNZ68cr/8D0s/JKsc4iU9x?=
 =?us-ascii?Q?0t6Q9iYdsVNxb0pIifiHm46O+A3TLO25GZzvmnKZcDRasBheelIiagLofmsJ?=
 =?us-ascii?Q?WODRDU27h2dJ7OmIOd3nLlwkTRLER3VTdxCnwgkCu0QWJfrJws0iGX5STiDl?=
 =?us-ascii?Q?UEL3oQq7XKj1pGh+Kd6JMp6YpS/zo9ReJH202v3QUGsFKOamwgDSlZIX2LPR?=
 =?us-ascii?Q?TfNuPtrDt/6VUnZPQMt88ApkLjQ+5TW33FCk0yW2xPr9c/+arlNGDGNno8zu?=
 =?us-ascii?Q?s/gmK2IlqWh58u/vqOnbIPOlCVt/xmaMK+53RvkpApDaO2e7cB6QfmpigYDS?=
 =?us-ascii?Q?6hfZLSDtMZ5aW1i08VDghcDjHRYXTTNmKh/EQTwUGIBKmuqbOKPIZ/9krtxx?=
 =?us-ascii?Q?qUzbNlr1yClTB7JUEb8aZnVkJcMugFJHNLCbBPtP3Bw9QEQqKRJ/44TykSjI?=
 =?us-ascii?Q?g1npMMi077C/gCReYIspW+I7H68e07XtVGdgguLlce5flIPMxete4An7AMth?=
 =?us-ascii?Q?uZMlNmB8bu5IOrN5atqNblje2tdwbAZlERaSxIvb9J7X2pNGOMxVN1/yD26n?=
 =?us-ascii?Q?sJ0ZmLie/6+KCx5OZ2tiTySlJpYHs8GObtBVOVX0u7uDgG8TpIS0PjH462B+?=
 =?us-ascii?Q?tDerul6FL7IvPukjhuSi0Vb93XltzNGT95tbldbZwU5++lFMHQPSHaRlWEiy?=
 =?us-ascii?Q?8i5tbqXk0Kjr3RY9U3dTJLCHyg+Zws0DvBkguIYX/fE/Aovs+k5c05RFVe17?=
 =?us-ascii?Q?ok/WDjhTz1GqT30J/shuhmOxYYPNyUZymfoXdKh6P4ZbsL/5lu5z7qomcvqA?=
 =?us-ascii?Q?ldY51dhLi9omP4Cb2weqVGXINzZxVbdulzVDP9e6OcD8pkszjup9HZgcjnZo?=
 =?us-ascii?Q?9wfZcojL6aaKQK0t3SX4OUnaKBEdwKDKJ4Czt01tvzkxzREtqfqPNOBmkmQy?=
 =?us-ascii?Q?QlJg839nOvLSYLS6GWHz/imAHFbydJvuqDXSc+aXTystlc7XoxwtmF8H4Tzv?=
 =?us-ascii?Q?etIfHznVuuAqOTvp4HeJVqMua5tYftTP4iF9Bl1GkdgPlv5SaflKVysNI42k?=
 =?us-ascii?Q?uRqRsR6yTPTHajsIL4hYVcIvYtW4Gojr/cS7ab7TyxcomTTuJ8/tcFTRK6nW?=
 =?us-ascii?Q?QsFeAJ73ZttE+PvgeUj+6pGlBUBjFIx/51jeYRUlLbk6qG/xUHIDwmggdJIO?=
 =?us-ascii?Q?cz5oQfMhaGqVvTnFq6rPHwq8XN2EX7yIKXR7OWerqKofyV97xWZ1JByqq0YY?=
 =?us-ascii?Q?gp/z1Q6/f7Hvufknn8YO2WWezSq7rJ/0rh+s6Q9SXfC9NHgLDwlobM4mPDTg?=
 =?us-ascii?Q?1GOcBkABfOsgNEWp9v7W+jUhaSr3U68on+C63lzc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156cf09f-5fa9-4f21-6c90-08dd47862732
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:06.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6lwL19cW4r7/MkDiX+Czy5wRSBaXPTETLeW7OFFeAXqiszRv7R+0qRuDuhqmYNt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

virtio has the complication that it sometimes wants to return a paging
domain for IDENTITY which makes this conversion a little different than
other drivers.

Add a viommu_domain_alloc_paging() that combines viommu_domain_alloc() and
viommu_domain_finalise() to always return a fully initialized and
finalized paging domain.

Use viommu_domain_alloc_identity() to implement the special non-bypass
IDENTITY flow by calling viommu_domain_alloc_paging() then
viommu_domain_map_identity().

Remove support for deferred finalize and the vdomain->mutex.

Remove core support for domain_alloc() IDENTITY as virtio was the last
driver using it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c        |   6 --
 drivers/iommu/virtio-iommu.c | 114 ++++++++++++++++-------------------
 2 files changed, 53 insertions(+), 67 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ee33d26dfcd40d..73a05b34de4768 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1599,12 +1599,6 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 		domain = ops->domain_alloc_identity(dev);
 		if (IS_ERR(domain))
 			return domain;
-	} else if (ops->domain_alloc) {
-		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-		if (IS_ERR(domain))
-			return domain;
 	} else {
 		return ERR_PTR(-EOPNOTSUPP);
 	}
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index c71a996760bddb..79b471c03b6ee4 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -63,7 +63,6 @@ struct viommu_mapping {
 struct viommu_domain {
 	struct iommu_domain		domain;
 	struct viommu_dev		*viommu;
-	struct mutex			mutex; /* protects viommu pointer */
 	unsigned int			id;
 	u32				map_flags;
 
@@ -97,6 +96,8 @@ struct viommu_event {
 	};
 };
 
+static struct viommu_domain viommu_identity_domain;
+
 #define to_viommu_domain(domain)	\
 	container_of(domain, struct viommu_domain, domain)
 
@@ -653,65 +654,45 @@ static void viommu_event_handler(struct virtqueue *vq)
 
 /* IOMMU API */
 
-static struct iommu_domain *viommu_domain_alloc(unsigned type)
+static struct iommu_domain *viommu_domain_alloc_paging(struct device *dev)
 {
-	struct viommu_domain *vdomain;
-
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
-		return NULL;
-
-	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
-	if (!vdomain)
-		return NULL;
-
-	mutex_init(&vdomain->mutex);
-	spin_lock_init(&vdomain->mappings_lock);
-	vdomain->mappings = RB_ROOT_CACHED;
-
-	return &vdomain->domain;
-}
-
-static int viommu_domain_finalise(struct viommu_endpoint *vdev,
-				  struct iommu_domain *domain)
-{
-	int ret;
-	unsigned long viommu_page_size;
+	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
 	struct viommu_dev *viommu = vdev->viommu;
-	struct viommu_domain *vdomain = to_viommu_domain(domain);
+	unsigned long viommu_page_size;
+	struct viommu_domain *vdomain;
+	int ret;
 
 	viommu_page_size = 1UL << __ffs(viommu->pgsize_bitmap);
 	if (viommu_page_size > PAGE_SIZE) {
 		dev_err(vdev->dev,
 			"granule 0x%lx larger than system page size 0x%lx\n",
 			viommu_page_size, PAGE_SIZE);
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 	}
 
+	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
+	if (!vdomain)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&vdomain->mappings_lock);
+	vdomain->mappings = RB_ROOT_CACHED;
+
 	ret = ida_alloc_range(&viommu->domain_ids, viommu->first_domain,
 			      viommu->last_domain, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	vdomain->id		= (unsigned int)ret;
-
-	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
-	domain->geometry	= viommu->geometry;
-
-	vdomain->map_flags	= viommu->map_flags;
-	vdomain->viommu		= viommu;
-
-	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		ret = viommu_domain_map_identity(vdev, vdomain);
-		if (ret) {
-			ida_free(&viommu->domain_ids, vdomain->id);
-			vdomain->viommu = NULL;
-			return ret;
-		}
+	if (ret < 0) {
+		kfree(vdomain);
+		return ERR_PTR(ret);
 	}
 
-	return 0;
+	vdomain->id = (unsigned int)ret;
+
+	vdomain->domain.pgsize_bitmap = viommu->pgsize_bitmap;
+	vdomain->domain.geometry = viommu->geometry;
+
+	vdomain->map_flags = viommu->map_flags;
+	vdomain->viommu = viommu;
+
+	return &vdomain->domain;
 }
 
 static void viommu_domain_free(struct iommu_domain *domain)
@@ -727,6 +708,28 @@ static void viommu_domain_free(struct iommu_domain *domain)
 	kfree(vdomain);
 }
 
+static struct iommu_domain *viommu_domain_alloc_identity(struct device *dev)
+{
+	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
+	struct iommu_domain *domain;
+	int ret;
+
+	if (virtio_has_feature(vdev->viommu->vdev,
+			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
+		return &viommu_identity_domain.domain;
+
+	domain = viommu_domain_alloc_paging(dev);
+	if (IS_ERR(domain))
+		return domain;
+
+	ret = viommu_domain_map_identity(vdev, to_viommu_domain(domain));
+	if (ret) {
+		viommu_domain_free(domain);
+		return ERR_PTR(ret);
+	}
+	return domain;
+}
+
 static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
@@ -734,20 +737,8 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
 	struct viommu_domain *vdomain = to_viommu_domain(domain);
 
-	mutex_lock(&vdomain->mutex);
-	if (!vdomain->viommu) {
-		/*
-		 * Properly initialize the domain now that we know which viommu
-		 * owns it.
-		 */
-		ret = viommu_domain_finalise(vdev, domain);
-	} else if (vdomain->viommu != vdev->viommu) {
-		ret = -EINVAL;
-	}
-	mutex_unlock(&vdomain->mutex);
-
-	if (ret)
-		return ret;
+	if (vdomain->viommu != vdev->viommu)
+		return -EINVAL;
 
 	/*
 	 * In the virtio-iommu device, when attaching the endpoint to a new
@@ -1098,7 +1089,8 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 static struct iommu_ops viommu_ops = {
 	.identity_domain	= &viommu_identity_domain.domain,
 	.capable		= viommu_capable,
-	.domain_alloc		= viommu_domain_alloc,
+	.domain_alloc_identity	= viommu_domain_alloc_identity,
+	.domain_alloc_paging	= viommu_domain_alloc_paging,
 	.probe_device		= viommu_probe_device,
 	.release_device		= viommu_release_device,
 	.device_group		= viommu_device_group,
-- 
2.43.0

