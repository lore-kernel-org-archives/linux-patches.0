Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8A37756E;
	Mon, 23 Feb 2026 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878528; cv=fail; b=eEBqHF1X3fKQQWZLSJJAOu0+jW/X60C9CCe9bFechpKmV/1yy+JkEky4vcHUITzgWPaBrZd0F5DruuAa3zN0fiSgd6j9JgYBX7EB1LwkXCANd9BsWICx4dYD73wGJjB9DHr0yVqrSR6HK/rpS33j3MTkhhC68A+LQld+Az7Ut7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878528; c=relaxed/simple;
	bh=VwwIeK8oRs0J+6/wG7QedBOGNmG29ytP+d5EGraW1ZE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gd9R20ZqgR3TbCCpETlHOHvE8OAfeJtsR1t7wHhZqZvhdgj5oGzOJvRVVx/kqE+W204R64p6zC9KYNa6W8Qtgpm82f9yq2pxkRSeVdnuP9itaik4wyC6QZ4lgxtUZZdCKirAL3wQ0gwOkJSdS5+265dtXB9hRCMODoKnw1Nh8No=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=husCYtLd; arc=fail smtp.client-ip=52.101.85.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="husCYtLd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mzwgbewNAWVIhTM2vgMnheASX8uaVNclr+bZozMhQJCaLzPTfudjU6nFbuwkp03Y/+T9h2Ph8u+GTZ/Iq4O2HNGUyrTg6930Fk/FGkdSOPV25diyrocDnbkfcxZ9mZMnHqVOhAB8hKuqy13fWetoYclboOgIrHiN/bsI4J8svXpUphz1HoCTlnpUtAqCMoS5QSFuOsN769KLxv3CtDpy2tjiZbHcGt0FbXIGAGAkSedLiY2znX9R7PW+d/PF1f2TsRExxVQGRUKRNk+3NcUtER7ou+MY+7aqgLmliuLtyz77HuvHOwsMTmBazoWTaYbhjw1gARleFr8YO+b0TTDk7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9FA7H2Ddvi0OlE1745ynA9UGlgSpvkRq6f4X7WokWo=;
 b=fVnojug5aMKZ2Z5zRXcnYWlm0E7Hq+MF5fZOGY3QfTP5ktA8oZ52uajOqb6aE2gLRUBoJsAJVgrI9pRh4GRBpn56UwqCJ2SuRWL0qSJ8adTjyKu79bhrn4MqyJ0svFE/xKkNuorAMoZAQwzC9NK0r9ygrOPMuHWz7GAopCB53P/BuaGXTZ4wVd165TR9zfr24fF37/Qxqra2/xYParoJJp2MoowTmviJsqrAx14RdKiYLLo1QXNFFrtaXPlQsRRd1Cxu6qyaT/ojzAd2bcM918X5tlIY/G3kpZPd+o6cmd71EJj9EHgy4lwGk5aHULsl4u7xBR4p1siSN2NkaK+vfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9FA7H2Ddvi0OlE1745ynA9UGlgSpvkRq6f4X7WokWo=;
 b=husCYtLdXugFiZsZmKi856P4d0pUzGE62aaVhIangz1V/PhezAaceYq1GGfWu9LjMpZ1ND7cvSHtYjDzVHDeNQoAI8/tzCp2owJJP2YePhD7xb6cPD3qHBY7FbyB/cb4XzrPt9VJ3u6mwhMVEfDE8Kv52JIcawPn4t8ymO7yLaYL4hGhh2LCoqekNu54BZ07MCxe6IHqu+o1Y1gRhft4KTHlnYKz5rz3Rgr0FU/eNUfOEa0VCemgvbMkYOUyn3FTk8e+AOL4ervg1TFvyZVPRuYblISpyhAgTNdrxGe0aby8jNajHz7xJHncEWdIqQCpi9j09O9TgPf3vjBbrLyGhQ==
Received: from MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::26)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:40 +0000
Received: from CO1PEPF00012E66.namprd05.prod.outlook.com
 (2603:10b6:303:115:cafe::d5) by MW4P220CA0021.outlook.office365.com
 (2603:10b6:303:115::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E66.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:21 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:21 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:20 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 02/10] iommu/arm-smmu-v3: Pass in arm_smmu_make_cd_fn to arm_smmu_set_pasid()
Date: Mon, 23 Feb 2026 12:27:38 -0800
Message-ID: <5a46ec5a87d7f43bae47468073b64dae603f36eb.1771877893.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E66:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bb15435-c18d-4bb8-5b6f-08de731a2172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lYIMMiacBTXTGP8VPuj4GV9Aczo+y5tRelr/X6F0BvafDBExgqSpJpuiWGV?=
 =?us-ascii?Q?lhhzW9UDXSrunsjV5MsDD1FcXo/YC40JLBRgjxDmSBGu7dYqB5CN0NhseP9K?=
 =?us-ascii?Q?bYt6oVRBEahFXR48unohlF1Z4lkbhBtqgD+FVaINQ9IHSSAjwWD+AeWhDvTw?=
 =?us-ascii?Q?DdpEr59hrcmoPres1K72rDh8g2mJIg6uLD45VtUsoXdhZjVg5cI1/xGQnCKB?=
 =?us-ascii?Q?77FDQoFg/jBfExVKyAJBkN305MEkyeAuabYsFS9DRPjMgfRcEZ1GVve3msN8?=
 =?us-ascii?Q?ElMg8hK9grSjo34QKsrj6MnOWqmyVIx4/qm0GaBICeBsSJozdk/i3sfq7OTY?=
 =?us-ascii?Q?ZQVx9GfTje59EWnnbmJzmFRQ/kpMLs/UtOB4gjtV0bJV+zAzpnEOFusTwegF?=
 =?us-ascii?Q?9HTegcXIEI2IYa8p9kPeYNxbxweae1aIXYbMwAQzD0lkCaCsAyHstd5CeuGA?=
 =?us-ascii?Q?YS4d+qL6hcqAMCrcRKzyo2boOtU4olysVYU35ZgxODxf/fRz0caPqK1pWSSH?=
 =?us-ascii?Q?1G04PihzuXHNZkHOSvCMGTd/UDjCqzXTMGZ1IDDhlZq9slFPKXDvWVfdoobm?=
 =?us-ascii?Q?hXU9aBNhiDyYE5W5GhRPdKhQ62DVBHGVi60RBZecAN7yKjAcKptOqztT1cPI?=
 =?us-ascii?Q?5j5PdnLUFXsbVBjNatCu+P5RtkYcUMnrxEtDhUg4epQE0zV1KrNd4sqTMbc7?=
 =?us-ascii?Q?84HqTQ2dthSppVtvkm0pKLpmnTLUT/NwwO5pgiLzYslHttWgl4RYwSAzYrzC?=
 =?us-ascii?Q?u6ziURkpNMrjjcGxxu2dSEjH96Tdc2YIM6x1qk0fxsxeB2j/4tLA8zeVHLcc?=
 =?us-ascii?Q?vWvj2Cu3wo2ENPIm29mNDUWl7hf2bhKRIB7xbdFYRRdbHTDGQk96Kavxz4h1?=
 =?us-ascii?Q?zB76RdBl01PUTVDg9dKR81NBFxpqxOBYbIp0XXoZz+izt8ZK0Zy3vype6GUy?=
 =?us-ascii?Q?LCHIsfSXJFtgSsV3Nkx16Klyc7/xZ59UN1Oy6ocAA1ZVukGlkU/zmG2PruzK?=
 =?us-ascii?Q?1AR5hfCOnCi0D8NXl7YSiDvdBV5CMrt/1pBiRTqGMqDE33G2vUD+t/+U42Tr?=
 =?us-ascii?Q?fIzPqEgqU76hL6kYJAu1SHBxaIESqFfxcIgM9v1eAi2Dh0+WY4/mR5tuBqoM?=
 =?us-ascii?Q?qcJ+xpQale1yk7QzpLwOhU2R0AJTA+OrPMzkF75LHehlhPKQ5sDJA9BNcxpP?=
 =?us-ascii?Q?1oSUtZOWocq86P/TCDH2CK0i7dJaJWZLqraL0Dr2aO3wOneSIDq4c3D6t6z3?=
 =?us-ascii?Q?a3uSbbCMXEE5Z9Vt+sFRS8SeaHsJqvfGqn4lKYv/4hVff/m0xqQj+z7SGKsd?=
 =?us-ascii?Q?TgHpsChTKUyMbCMwHtYEUvxwNsircIt4oVP1wOilAXmZf9mrKOcBVx5SPFgg?=
 =?us-ascii?Q?+S3//JUkODF+5WPzW7CIYs/vVdGIDwZZB2Wul+OAs/W7lueV0t9IqDaAQDk4?=
 =?us-ascii?Q?sgCXNRsOVd9hk+HCyy0kwaJheLAl/l7UlufXK/W5rETUigw9h8qfpwy5HFu0?=
 =?us-ascii?Q?IP27BBd4rcj6q9ouQSfo7WczGa2VuGjf0gh3xCr7eFzTQm0f50/fBee8OmxG?=
 =?us-ascii?Q?rdGMSeL9U/F9K3a4sxJALe07sMAezk/JGSi5Lz12akRiIdWk0+YCw98kKsJv?=
 =?us-ascii?Q?AmNpY6S185bliJySTT2wLA7fet64UIr/XD2amRUOot7ni0ne3BIppCozviYu?=
 =?us-ascii?Q?MvtsAw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mtbCNnzQJLTgbv921KHrNcrmZ2COCTOe/u/NM5ltIXwMC2cW9lq8RNfhYkEsDpe3xhnw5EqRPiiN7YOt7q4YzTNC2CC8qFU5wkPON9/YXbdsQwFWsF14m4h8G9M6EGxM/8DdHw5uPtynwsviq8gpDPnoV3JUiD2zm8cuEj3FwIpKYeQDUXgMRHmLPP14XepKAmPZVLOr25IBfPAo5NROTd9UKfEBh+0tmRcRlbbOmMYJa7xMCgN1faeMuup2/3Tbk6xq59dUjnos25XD/oCzW+UZXCjpt/nC/PouslLKFXUhNhcKPyXe58kTIaiwLjodq5VJYGGPR/UTB958AJZZf09BM+A1koUiU0B8AVcROoBVfh55+tqYeNi+QIM6KFJmLVsVPfamFdo1mOrrnM/FN4g3d/qGUuQeB7RDQ5Z0LwMPOojD+duV4GfxG70jBHcQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:39.9732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb15435-c18d-4bb8-5b6f-08de731a2172
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E66.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951

To install a domain (CD) to a substream, the common flow in the driver is:
 - Make an S1 or SVA CD outside arm_smmu_asid_lock
 - Invoke arm_smmu_set_pasid() where it takes arm_smmu_asid_lock, and fix
   the ASID in the CD.

The reason for such a flow is for the timing of arm_smmu_asid_lock, since
it was too early to take the mutex outside the function.

Tidy it up by passing in a function pointer for CD making,, which supports
both existing functions: arm_smmu_make_s1_cd() and arm_smmu_make_sva_cd().

Then arm_smmu_set_pasid() can make a CD inside the lock where ASID is safe
to access.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++++++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 19 ++++---------------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dd5d2b5acf664..e3a66e6bc303e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1076,9 +1076,14 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
+typedef void (*arm_smmu_make_cd_fn)(struct arm_smmu_cd *target,
+				    struct arm_smmu_master *master,
+				    struct arm_smmu_domain *smmu_domain);
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd, struct iommu_domain *old);
+		       struct arm_smmu_cd *cd, struct iommu_domain *old,
+		       arm_smmu_make_cd_fn fn);
 
 void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 414fc899140f7..4370cb88c57cf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -273,8 +273,8 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	 * This does not need the arm_smmu_asid_lock because SVA domains never
 	 * get reassigned
 	 */
-	arm_smmu_make_sva_cd(&target, master, smmu_domain);
-	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old);
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old,
+				 arm_smmu_make_sva_cd);
 
 	mmput(domain->mm);
 	return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b10a68565e9df..7c075e64f842e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3733,13 +3733,8 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -EINVAL;
 
-	/*
-	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
-	 * will fix it
-	 */
-	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
-				  &target_cd, old);
+				  &target_cd, old, arm_smmu_make_s1_cd);
 }
 
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
@@ -3769,7 +3764,8 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       struct arm_smmu_cd *cd, struct iommu_domain *old)
+		       struct arm_smmu_cd *cd, struct iommu_domain *old,
+		       arm_smmu_make_cd_fn arm_smmu_make_cd_fn)
 {
 	struct iommu_domain *sid_domain =
 		iommu_driver_get_domain_for_dev(master->dev);
@@ -3800,14 +3796,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (ret)
 		goto out_unlock;
 
-	/*
-	 * We don't want to obtain to the asid_lock too early, so fix up the
-	 * caller set ASID under the lock in case it changed.
-	 */
-	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
-	cd->data[0] |= cpu_to_le64(
-		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
-
+	arm_smmu_make_cd_fn(cd, master, smmu_domain);
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
 
-- 
2.43.0

