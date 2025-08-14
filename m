Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9011C5489;
	Thu, 14 Aug 2025 01:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134787; cv=fail; b=X2AS0dKnjy1OkxRlsoVoOmahSB2cl8W7+QNPvFRjt52MuLvFEUr7aE61q6e0PEHbLzlgVvKiExZf3t8LOLBlfCwhls0nTJN56a0baKBAvPgIfcG1gYKP/Yr2ruWrfmg7tt/xQReOM/JBjdlENVLcYhWpGICIWTvJ0Q2XAbN3Rtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134787; c=relaxed/simple;
	bh=DDogWgQw6MspgUUgMu6U1J6gzKIf8H1yrxuaRZXdpec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwbUPYVmbBxQ8lgC56E/RfFgPczp3ML4IaKowRNv4bk65O4rcnZmhUE290PAg5ds3uk4I4XP7TkWHAn2FPgRyaHTDMMnWV3yWD/YMkyKyguXIfNwRbPSbnoygY6uJE2PwSEQ16+drrRvqNNoAy8yc+aYZoDRON70wk4gQaZPLCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hrgB9KRS; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hrgB9KRS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qkm8FHgw5nHyKr8cXgkw997SkMBwxyEkxGx2Y2hLcBdim3T0l2jmhX3E/e7uUG6YuO7GGxTT1EpztjQcSm6JS/ALC4oZb58dtY+/RcqlMUAqSwUFYkb9vs4HS5+lRqgNxaWQLgxhW/BW5tgI2fm6/nxFyKW83yULZrJVT1kB5Ffvb6tP5husfzpDfIJZyx2pcD5/Hvfmo9fAvNiPlYeSLPf1/xawC0sVuFzQGH0RUxCQS8thXPzQu4ALAaiu9BVfkOSx4UNhTBitTuEzQYjY5zUkLbbY4fHr9n+5py3oTcIKPvMrsT6rkfaSKiBoxS+HSjk2mCygkfQHvJ4PYCWdRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qqoeVnRECMfD1Pp4tZ2Fwc6QXLvQlgWCLGshn4ZE9I=;
 b=Qx0fdVuQ57eWknqg4rUsImDLIRqCeojfS7zQdUDGf3tUOwLPL9MGHiluJJvuo4MU67OqLo4Or77mpFSL8CkNjFGkoaHRl0U/sFCXa42Xl5wFrQZ5UFN5sQTLLGQnDRvx18OsjLKpxi4asNr9w5Nu3tczO6v/E8Mev1sDeexnuT7hz9LRFApLV+6awrbG0oaE7Pp8DBtDixsZBbmgMKDQCXbB01RIsb5XcOzRDkca7ndvpI6F7AkixjpqJwoHfOo1A6nm2IzR+kf+WadzLOCy1Ycl8BM0UjEGfo8P0GczLyLUIR6kdhHrlJPwtRDlgxdnKre/6VPQBA4LeYQspfDfdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qqoeVnRECMfD1Pp4tZ2Fwc6QXLvQlgWCLGshn4ZE9I=;
 b=hrgB9KRSz2O+ebWtl+3ezqXDyZbFsOVeiKapSJvXOsirpFFDQyD5pf78gDqqhV9mhEFvc1kLIsoPkqxGRsTwyJTebIrf2jD1QfBlwP+/20+XMK3EMhK3pZ7MhPfk2IibpmB9dXMNwNWKP9s18xjRlxDeDXRHwt4bpdZbGrE3759QZWTbUTaR1JdGudXV1bqeGfNRkgJ19GvoLaSM5SzclAJDApCvKduZHMH6lDn9h7d06R5sHzQi2Pb24jnBABHs3UrgKBLspPTF1xnr3R/Pf5zgXo94VUDbDFRnxdXxvbPB9YX6ItfhosiOXuhvDh9OPZ6/GUZtQy3wVxh2tPoRIg==
Received: from BN9PR03CA0642.namprd03.prod.outlook.com (2603:10b6:408:13b::17)
 by SJ0PR12MB7460.namprd12.prod.outlook.com (2603:10b6:a03:48d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 01:26:19 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::bf) by BN9PR03CA0642.outlook.office365.com
 (2603:10b6:408:13b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 01:26:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:18 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:03 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:02 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 2/8] iommu/arm-smmu-v3: Explicitly set smmu_domain->stage for SVA
Date: Wed, 13 Aug 2025 18:25:33 -0700
Message-ID: <826a71630caef33effbd82d918e7f7393fb4d377.1755131672.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1755131672.git.nicolinc@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|SJ0PR12MB7460:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4e2337-2481-4c55-d84f-08dddad191c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dg5a5askZmfSFLaUsasf03aqwwAvgxQ/OvGhkeAg6FVDpBTy0CKzoWv0ZqrF?=
 =?us-ascii?Q?wkbmk5zGSnDfQl4mswdGhnnmmAp+xc6AxoTvwx/fZHsjqN0eP2sYKlhDDwg4?=
 =?us-ascii?Q?mlYYD+fHIsFNM8xprHaqUrqf7bJdl2q+uw1oAdUZ1AL5UE5h8flIzbm1AIfc?=
 =?us-ascii?Q?8omLcfFFnnRYIDBZ7LxqoYMr+LJW3ubo6uyrmdBszQVTztOVorS95KgtH2Ii?=
 =?us-ascii?Q?shARMf6t7WNArF3ySeAZlZUQ42ugpLHpYmBeMjfjCqQ6z3xkUZkqaVv9LLIM?=
 =?us-ascii?Q?sW4IIoEs6NSPPEalBaBxmocu6k43f0TpfMKMpFmOr2eIu1w7wPzb29zuQ1C2?=
 =?us-ascii?Q?e0HpstyaYFoSa+BZ3qDdFYlTSLVm3t/9+qC/MDQHpbGukxdl2f77Cg9ZM6H3?=
 =?us-ascii?Q?nPDxiKle05AvWniUek4txbuswot0WKRoSbDkMbGjDcfMJFio6AIW2DSj306Z?=
 =?us-ascii?Q?kYViOeVW9YSS2Hle3kNlLTaTobsUOYqrwHbZ2RsosTkJNzNGy2kDqHtIctPj?=
 =?us-ascii?Q?yqHXRit1Mo/tGapR25j/UhU/mI1U/wATlOIXukqzScUH+KTFRRPfVlbL50nm?=
 =?us-ascii?Q?3k6fcDT3qFDch6RuIOKkpzV+026tyQ6xkwMhuXL1t4t3V2n1iYlBc8c4wydg?=
 =?us-ascii?Q?57S9A8/3lBsa/efqYC+SDUhkX2U0GD8XtmJB+sfAgmJe0ixPPxRWROsDepRh?=
 =?us-ascii?Q?q37A1nXbk26k/7kVn3KouwOc2xgYODQi7vjFKsCpGvvk9UdaWB0TyBPO8mT2?=
 =?us-ascii?Q?00LH7omWnS34ymDyyohsh8pjcOS5XV1IuV61u5ocisGbzD7zSadA+OAfCaXC?=
 =?us-ascii?Q?yy70BiCH1Aq7hAs+cEzaZeoQH/YuStMb9x5dphuytpcX8M/byBCLErgTLcqs?=
 =?us-ascii?Q?mSjP7qJqXoTx3R3ve8ZCQNR0Zv0FSeJ1IQfSxxVdTaZHZ17UKXd+A/0yvJfs?=
 =?us-ascii?Q?cRmKYJTYAmeEPFqlb9OnWbvleGqovMrjIxpK0ZL9oNsmbfWI0eadReHW8KIN?=
 =?us-ascii?Q?0EA557Kxo0vKZ2Wk7WvTv0YUQEvhaQ3/49r/J2jAmAjkqe8yIc5bwelstC2J?=
 =?us-ascii?Q?YM/jfQjw+uaCln8/Dy1Mp7WRGymXJio2pRmpEoynDjcg2MfLEchJFdys4lPR?=
 =?us-ascii?Q?ARA1eOldrd1IgHemEPfMFr177hCFz8qJdO4AVCT+Y49QMiBDlXKuRE2T7W9N?=
 =?us-ascii?Q?ZjyXSoIEy/H+s9nwahR7eqFxekO8GBHPg/twBFvWTzrisDoYFGuAqZclLgo0?=
 =?us-ascii?Q?j1m/oqsWINgQ+1BJzBCoJWdfYzhoU2BbINW6L8eu9s9tnVBwr5yaCxhqZyV6?=
 =?us-ascii?Q?znpwz3qy65zqWgYE6jdN9Bh2rz/buTSnn8lsza0rhFsPBxoEWjNrcEmZie6R?=
 =?us-ascii?Q?fOmxnGW5HW1yZhARwVqoz/igUCU+a+F8ffXMolw5bayQVI6LA2nCf3DB7ZRc?=
 =?us-ascii?Q?Td5LRg5txzQlHG3YckwJ+hLhHFdnCaGf1PFvVxeG6uCyKmzKohuRf4kzuu45?=
 =?us-ascii?Q?xJKbbMBTHgu4sNg6dfkleNxDC1DAOHlrWtBW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:18.2814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4e2337-2481-4c55-d84f-08dddad191c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7460

Both the ARM_SMMU_DOMAIN_S1 case and the SVA case use ASID, requiring ASID
based invalidation commands to flush the TLB.

Define an ARM_SMMU_DOMAIN_SVA to make the SVA case clear to share the same
path with the ARM_SMMU_DOMAIN_S1 case, which will be a part of the routine
to build a new per-domain invalidation array.

There is no function change.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ae23aacc38402..5c0b38595d209 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -858,6 +858,7 @@ struct arm_smmu_master {
 enum arm_smmu_domain_stage {
 	ARM_SMMU_DOMAIN_S1 = 0,
 	ARM_SMMU_DOMAIN_S2,
+	ARM_SMMU_DOMAIN_SVA,
 };
 
 struct arm_smmu_domain {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 59a480974d80f..6097f1f540d87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -346,6 +346,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cccf8f52ee0d5..0016ec699acfe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3070,6 +3070,9 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
+	default:
+		WARN_ON(true);
+		break;
 	}
 
 	arm_smmu_attach_commit(&state);
-- 
2.43.0

