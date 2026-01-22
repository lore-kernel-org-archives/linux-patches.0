Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAD52D73B1;
	Thu, 22 Jan 2026 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045115; cv=fail; b=SqLSq7f8To+hxJtHC2IiHz0YJBu9ph8V2+f3/DHKJOmymuPSXrVTNAOEiE/IhmqekRkYrIZ4ImYJhFNk1FBj1VuBpyS2nsOuLTE4kIuA02kSE1nZQ6p4o+/hej3Xojb3lw73ehgD1yMvBqcMV9Vh02iHBYuF6ouGQ5SkNKyNrTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045115; c=relaxed/simple;
	bh=LaW8SLL115RbvRznkgxGtab6E2hWygr70S1cxDqzh3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c6nlggy/DQXsr4s13AyMLjCCmxE2OxIeTTGk1uSsXEUzoJAYt6UsidiE8gBR/OiCtx3QvRCeFB/qw45a/mM4Gb1qiEfVZ0nj/JbotR1praLMu7L3aQDsUUE4LKJ9nzhmVWwrKbtQX+rR7oyRImG35uMlie+muEeKea/pk4ljnrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PTVWJyFn; arc=fail smtp.client-ip=40.107.208.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PTVWJyFn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeguyoSeydRsVv6l+np/4xrkXFHTVW+4M0FyP526S/mA/u3XScxdonyRMhNMmjkfroC9MmCha+/Hdh2wi8FswqhpNHqQtYzRisnv6sEJKtCKCScSClSJ7bN/I+C757rE4Rv/wraEK9QMfOxjhS/Hu1b0Ro0RJz3varOL65OG7rKWKDFlW2MH6nu1N9ko07H6x3Cqdoah8K31c8nne/8c/r7ONEYObvqzhHAGt4C6c3OYKdFYMwDAKAxj4RlBvsXY1wNsboJV0VpzLYbsA2WY73N35gRLZ0lb+MsMr3ClWS1zr+EYh931Ds8ondU2wI62iu8mXackL2TSf5fUiyGIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uTdKN2rOTnFc1RcDsBqRdaYcRLGEPLbkIatg8W2YVQ=;
 b=ReGTV4uaIOagOOpPKs1N+71KT4fyhz+5WDbWLYgNBlQUg2LyxmgNDiuxEs3V8g+I2BXHOnN3GMKTONa8gcEzR3r9/hKjB1O+5q20/oXx0mvBYoK89ApFPGArt1OcA1M0oGAdR6zDCT2ydEiC0/mhvu4BLiJTvz4SnVsIW3dKuxnyteHe9bfR8b5MHPfxSBZ2J3YZtu0RgI69iibZcu0DG2TTY5XQvs7xwa8uQbP8Nfr/XvBa33rGHpV7EqRwYTeBUjzP4/QKFsECNssfwKLnH2T+YEjlR+OySH9tzfBvaihi02Ms6oPiAqfEZxdY34pu2tlXzwOvFQ+HnBR1JkDKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uTdKN2rOTnFc1RcDsBqRdaYcRLGEPLbkIatg8W2YVQ=;
 b=PTVWJyFnqgpVSHn9aBk888MvsKyM188WBSqLvDtNLX5ikWKZqGMrZv0EcZbVC+pDytDyWpMl+XxrwuBI1bCx67LrUuYayCPtIOKsdixAnJswwqidMbyLDdiAmwOLLe9J5hOzjD4tH7T1SQplT4x76Jrd/3vYxkKD8jIe81DBTko33q7OZyX8u7k/VjREWSwfdo7XfKAOR14zw1xMhtMdPUt7hOulVRHt/n1KBn/ozE9riPTh4jCpuaHq8hwXGh7es3zd3VAFVr0fmGOKEEp7kz8Pt7Lwwb763Ntl24IGudDOml1wlJZ/ANe6O4g4po98v2MBc0vwfLky7BAuctPT+g==
Received: from CH2PR17CA0005.namprd17.prod.outlook.com (2603:10b6:610:53::15)
 by MW4PR12MB6873.namprd12.prod.outlook.com (2603:10b6:303:20c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 01:24:59 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::52) by CH2PR17CA0005.outlook.office365.com
 (2603:10b6:610:53::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:46 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:45 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:45 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 10/10] iommu/arm-smmu-v3: Allow sharing domain across SMMUs
Date: Wed, 21 Jan 2026 17:24:28 -0800
Message-ID: <2882c7b6dcec7cf8bdc08bd4fd9f4c4373db5469.1769044718.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769044718.git.nicolinc@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|MW4PR12MB6873:EE_
X-MS-Office365-Filtering-Correlation-Id: ed9fb169-55ff-4343-1fac-08de59550ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GPyhxTqSmaq63bxDpV4pHFpGC+3DXhRwFHkQ39hGvVG/2tqwZ2aqZF53h3Av?=
 =?us-ascii?Q?7lY9qoK/2wT2iYh5IkWwufTu0gGrQONrOBqzRs189tltj0qPF84yy4fESGhw?=
 =?us-ascii?Q?X5RlJIeCeo4Q+kOP24BHNl8VsXE6KTk7vq9BP+hSgi+6U+3BWeJmFriuw05A?=
 =?us-ascii?Q?fL3JFoFOV7Om36ExRN0JibeLkmWhxLtxEy8Z5uAepO7tg07bryxrPDAeaVAW?=
 =?us-ascii?Q?3Rk+gRFbOsU7bK9l9/3u9CUelCGdPHESZP7qy7+LPwFKAdN3s6sRMpMFOYgt?=
 =?us-ascii?Q?ufe751pESbac6C6xSLLg9LIPHi6EaCNX57cD5loEZOdqGfK0lXIlOLWEcCkq?=
 =?us-ascii?Q?+hxx9SfF2ko2nxbcaJ6LcIYzccxH2e/VSZNRrZiTtYsS7rCo31LVwfIFsPG1?=
 =?us-ascii?Q?GtX1be73QDtw5iiHCSiEFKm/pYNA/kxJ2pJ3JMm/CqqJnWb6KJE5Jnd2q7IX?=
 =?us-ascii?Q?kL4gXd4BCyVlkpK3KEe83PTz2ZtI7HG1BEGU4ILQHoROsdMxgMAuqgtv+jEm?=
 =?us-ascii?Q?aNMYLAzQZO72nGkOJ6aMCrBSgsa907zXh6GfBrd1n5vbP5Est+2Xs60ilYqq?=
 =?us-ascii?Q?tPKr3LobTVMhBUYSKG3GaPmzjStvHAhajQ3orT8echoj62WYteIn8fmfO2fX?=
 =?us-ascii?Q?EcuBSkHfkt07QuXTaWw7N1Kj4lpDPd0dzI3cWrd6G0Yskz7+Vfe2lcNkqGWO?=
 =?us-ascii?Q?8FqO7KTC/1JhPzf4cBl2jAxw0V5IyGDnldSfK48duqWQrpBrfa313bc3kxjG?=
 =?us-ascii?Q?YFmtPyAu/QqA4gPCz0wF+LgjLZNENRmlbyFwBwHtgZ4+luFJXWft33H6qWOB?=
 =?us-ascii?Q?axCZToGBUMXjNEaIbK4udurgvQWSdkhKMMbRwBFwJ3Tw959mWcQ0cgMgnD5f?=
 =?us-ascii?Q?la5DD2ZMhtBiZEDBgsmj7ZwIugdM+TlkrAAFtGft2lQBX97RBGjX7fzFC8ls?=
 =?us-ascii?Q?1F4jCIJZ/VUmYWRoRSO9KbqXatA2zRAmH038PNf2QH64+J0PB2SXDoXy1OQh?=
 =?us-ascii?Q?ramjRAtKfRtxS/9sDAjPwP86F1b01wak3A+0wYYwqTJ+KOC6BzDfw0ho3JV7?=
 =?us-ascii?Q?SgluzacYfZPnMfujpCmEEHKEqBpY2xrG/0voE0g8V6pCykHEDJSeXWS0QZqN?=
 =?us-ascii?Q?u+7M54ZAYqs/UCeXhlWylq1VtkYkVv9TNuYZsuhGW7XrtwhlJnIeqWmlRMNX?=
 =?us-ascii?Q?fBR8g1+804Fc13yubzVcXOY7hqH1kN+Y4eJcUwAXyvVop5n8kh0RUioX2zL1?=
 =?us-ascii?Q?IHOgjTQXSoKLgjeX7fpMUUBi4Tb40KEKkwXnuc6vHQz8VdNtNUgZkdWJRJiC?=
 =?us-ascii?Q?ktjzXyYQ+AoQH+qDT/qfu3fHLhtHIsIAkqdHQWFV5ERIuILd+IjHqQ8cjsjM?=
 =?us-ascii?Q?KylDbMiq7iFe+Ea4EQTZ7yC1A88Nba0e0rFfj81ImLlwPsdlpUXw5TfRK1ZC?=
 =?us-ascii?Q?sIrs/1fXCmOAXhSl0xEDlr/W4rMZZ6XE8c/0UXJKrRlfZwJ3Lh7KWyBHmZr8?=
 =?us-ascii?Q?wYOwcrC2wn/dU3Ipb8cREZQPIRgM+6fEVJyM6ld4nchKPip5T5xCUW0742tU?=
 =?us-ascii?Q?0WpfYu3c0vfdl9qyp85pv+YB9gwz5iFFcHAR2nkapW7MbkC+v/4B13PJlti0?=
 =?us-ascii?Q?ZNinuFKIWE9PqY/P+pDanoFTVv5jKqoWY9H5XG38ang8gvCHA0dCVyC1Qrja?=
 =?us-ascii?Q?a4/dtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:58.9017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9fb169-55ff-4343-1fac-08de59550ee9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6873

VMM needs a domain holding the mappings between gPA to hPA. It can be an S1
domain or an S2 nesting parent domain, depending on whether the VM is built
with a vSMMU or not.

Given that the IOAS for this gPA mapping is the same across SMMU instances,
this domain can be shared across devices even if they sit behind different
SMMUs, so long as the underlying page table is compatible between the SMMU
instances.

There is no direct information about the page table from the master device,
but a comparison can be done between the physical SMMU that the domain was
allocated for and the physical SMMU that the device is behind.

Replace the smmu test in arm_smmu_attach_dev() and arm_vsmmu_init() with a
compatibility test for the S1 and S2 cases respectively. The compatibility
test goes through the physical SMMU parameters that were used to decide the
page table formats.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 20 +++++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  2 +-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c7b054eb062a..c4bea9f7f4f1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -982,6 +982,26 @@ struct arm_smmu_nested_domain {
 	__le64 ste[2];
 };
 
+static inline bool
+arm_smmu_domain_can_share(struct arm_smmu_domain *smmu_domain,
+			  struct arm_smmu_device *new_smmu)
+{
+	struct arm_smmu_device *base_smmu = smmu_domain->smmu;
+
+	if (base_smmu == new_smmu)
+		return true;
+	/* Only support identical SMMUs for now */
+	if (base_smmu->features != new_smmu->features)
+		return false;
+	if (base_smmu->iommu.ops != new_smmu->iommu.ops)
+		return false;
+	if (base_smmu->pgsize_bitmap != new_smmu->pgsize_bitmap)
+		return false;
+	if (base_smmu->ias > new_smmu->ias || base_smmu->oas > new_smmu->oas)
+		return false;
+	return true;
+}
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 33b336d494c3..6ecf98ca3bb8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -467,7 +467,7 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
 	int id;
 
-	if (s2_parent->smmu != smmu)
+	if (!arm_smmu_domain_can_share(s2_parent, smmu))
 		return -EINVAL;
 
 	mutex_lock(&arm_smmu_asid_lock);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 19437ee6f4e1..4252418fc0a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3635,7 +3635,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	if (smmu_domain->smmu != smmu)
+	if (!arm_smmu_domain_can_share(smmu_domain, smmu))
 		return -EINVAL;
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-- 
2.43.0

