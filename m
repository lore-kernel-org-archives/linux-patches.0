Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6B34FF60;
	Thu, 22 Jan 2026 01:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045115; cv=fail; b=KmV3XCyyGZ+JsM1hnH1CQu3vlHfwJ6JqA5exY1b+XGh46kCNr8LNRQclDs7/ydG1b1hh6imFzox+0Fy0Yzz5w4bxRSARKzqNL/ZWcfSlOj9N2g9pH7sv5wP+IDciGUwozc+K/nN2S7/sbRKzAvMQUaorAkCPldJPRQB3kRBhhA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045115; c=relaxed/simple;
	bh=gtyt9k82MvmeJpZzLlVp60P0E5dRYg23nLs6nDm2x7U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDWuFhvs0ZSW5PkMQiOUZsZ8ad2sxQF+67/5npx03VikW+zIWIYczjcxvF+q89GvkyFYuvSgJKG/wBZD1Ny8JDl8uV1P3aCFfnDEhWP6Cb7s9G1J6i53XSPIVzgUuKiqTHa9lfOnFxXccVcApooAudXHAYY4Ky7/yhL4kKOyFaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z084SjX3; arc=fail smtp.client-ip=40.93.195.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z084SjX3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZcsTJMo2eGZEK/WT9UyQZ5uHRBWLjZaPpXVN9uV00gm5yS0VnvoijALpSLTMb07UjTr97lLhIxY0fd1A4/PymETX7l3lKko7yqjo+trW/ABgiaFxBpvmo9+rKeneVkofoU0tvjUM/e7sNFPdwPin7VrKHkqS8Suarub+58Nx3ot7cXgF14A6fbWFgH1k7/rBA94In0ExgRGQV6zcCYQb6ow9uW0XM8EuWcdX77VOfsOCVZrT8UW8wvMwAKjtP1aZMmEHpUu93RHqCQMmZIC4mlCvqxSkc/BDjEBGbBs75h6dCkop1efQg9T8N8rtEhWMoPcFuUPu13yZ2adhUJ6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdckUXIb5nf+QUx1xvTruDJ3doOxTZP6h3AD812IDB0=;
 b=xM/pUknZ1kMb6Ogwwx7qIpHdBCQr1G0gVmt7mEXtmg/VYzX9w6JEyiXB/SFJYETjxNyPVkgs+dF5kjEo2A1M+kAWScTXR7tbW/PB92T88VTjCWEsKLGD1dX5O7xC/brYWR/aE6A00iPoTbrLb1eOIgF1VypvXx9nFck2n3et1k+sdUiffFaqLl2nrzMVOrjplpD964cvewuHTVrPkHSbEQE/t3HJnmFnQfl/fx6Wof33vNdvEQa+M7V0TMAfAnap9OoSePZM9KEwOkCQOteHZIa2LMaAZqOXJtq1StEQXVHyGnmQziM/BiZJq2LGG+HgNQe5A2/4aU9PmmxPHS1btg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdckUXIb5nf+QUx1xvTruDJ3doOxTZP6h3AD812IDB0=;
 b=Z084SjX32rCOBoyOl6VQJt0zdaUnqqhD4rpLYex7aIS5UBtxLgtP2F4cRXScOqvStQjRq6PmO89zvuBiks7VZi6Bz8clhQ1uyqjKLAAdpi2/skyevR/OLdPGu51n8T9gQs6yiB1DlMo1jKZ8iunUo7BpBlyManCIDvXZB790DVzSLD9v6ac+r0M4YspxkCQRw6bBBWxWt07Ubvg4t0EljDAz9nVxm9Ov5N8R5JXgoT1tO1I8mUlrp/KC4s1GiXA8rUQpyaQN2CrWu8wThq133l4K2xAs0B+rClotlTsl3UNMQ6ptH0aaorTKKru0pVGP9GwHjcE5mAzdPlrdaj2IoA==
Received: from CH0PR03CA0061.namprd03.prod.outlook.com (2603:10b6:610:cc::6)
 by CH8PR12MB9789.namprd12.prod.outlook.com (2603:10b6:610:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 01:24:55 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::da) by CH0PR03CA0061.outlook.office365.com
 (2603:10b6:610:cc::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 22 Jan 2026 01:24:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:42 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:42 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:41 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 06/10] iommu/arm-smmu-v3: Allocate vmid in arm_vsmmu_init
Date: Wed, 21 Jan 2026 17:24:24 -0800
Message-ID: <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|CH8PR12MB9789:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b9cce4-a82c-4f1a-a344-08de59550ce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dRt+sMiQDSK68UHg5omSwwby1DftbYTF2U2TYIVIY5zHTsSishXV8LO8nSJE?=
 =?us-ascii?Q?Vm5dT2mGOvAR7AEQWGWTsLiozKfvSEpQvDPADpKGbcYLJU8qCil7QnIfCtnE?=
 =?us-ascii?Q?3O+Dt6E1ygbOh8j1m9yvZBpigyxL30giyUQyDibgUHCiTZ4HNAfTTidN5OUw?=
 =?us-ascii?Q?wSjI2Gh+J5JS1VDcfZfiMJjm4VNbxG8I7UD2KxAZSjyKMVeTsy13DLKCIk3x?=
 =?us-ascii?Q?K9W06DwWYuzQKhdwEUbifCdHE/wL6Lt4Ziqhc/k1F2tm2LDAL7+r34vLn5Uc?=
 =?us-ascii?Q?I3w6ya180K1ajRyjtgZB5tuy5zQ5m3jKGdH4O7VoqRfTlPT0dy3fXwQRA2z5?=
 =?us-ascii?Q?Yoh6diIMWfreIwb2dYUGcWWzzlZWw2M1Ji4srcu2Z9qs3icK/YRmFvZ4b0po?=
 =?us-ascii?Q?QAmNrjXgCg/zp5FJA630lzyBP7mBZLRf8nJTMghUz/TKYlBLCHWj6UqL6Bf3?=
 =?us-ascii?Q?6VX6/2TeqRToWT2lBXYddUU8H0/8L+jjKyHRlKBzX0f4l0BpiVeYL/URLLYl?=
 =?us-ascii?Q?9nXnriIVMbFtZDLQ82VylLap4++u2tdH4chrdY7bWNrVkEZtxJ4GDTwa+L8g?=
 =?us-ascii?Q?/uwRZVpEVi5YvE+Kn41X2fjndJMPjppaZJOctympSOphsiGiVU64ZLV1x+hB?=
 =?us-ascii?Q?T4NZi0M6e+DAc+ig/I0QXC3gJrV5YcZBCvuFYDjkV0pdKCFwDG7A7QM6/5rc?=
 =?us-ascii?Q?p46Xr+QrIa3jAre6VykC946EILkP6lXxzb47RnBVKGqgQKIZ9Vl/YFMrazu/?=
 =?us-ascii?Q?qZrMlmHOfGZEPtd8him1IhuX94e6zJQJ09WJAAuE/oDQJWcRSN0feK0ks0Jv?=
 =?us-ascii?Q?z8ooQJGwbh7VOrVDvLjAPiXcGH+Waojt+8ix/auTdg0v2cUZN91QpazmuzlD?=
 =?us-ascii?Q?jCuwzQQpgjz1PDw8X44n631gz5IXgr3tOLIDQotxck2rikGB34E4lcB89eXk?=
 =?us-ascii?Q?s3sB2vWPg8ABIuGtELB3z5WdRt++TkGpxFC4XOdjbAzBfPqaMy3gf4xklRvZ?=
 =?us-ascii?Q?qr3a4YwwoHsMyS6FG146kxWnHIqqPlHJzpSYLybXfKgKwwkoQQbNyeES91Ij?=
 =?us-ascii?Q?Ab/XP5baeLVCg2yxaLYffU6bAE9eRLLNfK0wvIsB25CQzXkKwtB915mJmsEG?=
 =?us-ascii?Q?PWeUwwjUHoWgRf6eCGfbDC9aeuAtn+Q6rU1tsZW7PyfMlGioB2dBY0XSp+ih?=
 =?us-ascii?Q?z1/ByTVJVtBAyEThSzkK4fK/u9/Oz+geachh1Qr/YwDvMolpYL1GCUD9zjVX?=
 =?us-ascii?Q?Hr3U7rgoxnRarKm3prveQOmT8f8qlyaFx55Ip17GvDpsC8OzULimmrpILb1h?=
 =?us-ascii?Q?h/jNT/pfFqC8c+IsfgaBl8x5cKlT7SzUrQUkpzG3tIKpkyQ3QMqwv19IyYxm?=
 =?us-ascii?Q?5qKFhpWEdj2AiGU//m/IfzhWPgnrbNuYlHjhJVo2U8mqOZSHDLxbLals9Gw3?=
 =?us-ascii?Q?F8lohPBI83XKGhrYtJmYH4HGyc4MtQ92eV6bklpTYWbfcRPlHCPDdrADkscR?=
 =?us-ascii?Q?DUSAGYzR/VcpWkf3R35u4bSVfmxjKLh6MtEfQyvUqBDa4P8CDYvmxe80HLAY?=
 =?us-ascii?Q?cEOzMPh65IM+fN5KDAY+tRZHZ20ppq8fhd43HAWdt235098pkai1LM/rvJL1?=
 =?us-ascii?Q?NAa+OlTRM+bKYCrIVteTlgQlDAu9P8DTroiIz8Xb9pWk874klH4RrPNCKms1?=
 =?us-ascii?Q?jUbFpw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:55.5447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b9cce4-a82c-4f1a-a344-08de59550ce7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9789

VMID owned by a vSMMU should be allocated in the viommu_init callback, as
HW like tegra241-cmdqv needs to setup VINTF with the VMID.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 21 +++++++++++++++++--
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 696ebb89ffa3..8aecdbceb974 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1190,6 +1190,7 @@ size_t arm_smmu_get_viommu_size(struct device *dev,
 int arm_vsmmu_init(struct iommufd_viommu *viommu,
 		   struct iommu_domain *parent_domain,
 		   const struct iommu_user_data *user_data);
+void arm_vsmmu_destroy(struct iommufd_viommu *viommu);
 int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
 				    struct arm_smmu_nested_domain *nested_domain);
 void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 34c7bd4cfd84..9998871f69a0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -404,7 +404,17 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 	return ret;
 }
 
+void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
+{
+	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);
+	mutex_unlock(&arm_smmu_asid_lock);
+}
+
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
+	.destroy = arm_vsmmu_destroy,
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
 };
@@ -454,14 +464,21 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	struct arm_smmu_device *smmu =
 		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
+	int id;
 
 	if (s2_parent->smmu != smmu)
 		return -EINVAL;
 
+	mutex_lock(&arm_smmu_asid_lock);
+	id = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
+			     GFP_KERNEL);
+	mutex_unlock(&arm_smmu_asid_lock);
+	if (id < 0)
+		return id;
+
+	vsmmu->vmid = id;
 	vsmmu->smmu = smmu;
 	vsmmu->s2_parent = s2_parent;
-	/* FIXME Move VMID allocation from the S2 domain allocation to here */
-	vsmmu->vmid = s2_parent->s2_cfg.vmid;
 
 	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
 		viommu->ops = &arm_vsmmu_ops;
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 378104cd395e..67e72115d43a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1209,6 +1209,7 @@ static void tegra241_cmdqv_destroy_vintf_user(struct iommufd_viommu *viommu)
 		iommufd_viommu_destroy_mmap(&vintf->vsmmu.core,
 					    vintf->mmap_offset);
 	tegra241_cmdqv_remove_vintf(vintf->cmdqv, vintf->idx);
+	arm_vsmmu_destroy(viommu);
 }
 
 static void tegra241_vintf_destroy_vsid(struct iommufd_vdevice *vdev)
-- 
2.43.0

