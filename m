Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B651D78F24;
	Thu, 19 Dec 2024 05:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734585284; cv=fail; b=BERbqq+TfqpAgDbR7gSmAgCEP7pe0MMhurrfX+HDrnPsWEVzLyRjjqHG84/th2L2xF2wp3NuHCehEZdYX3FsELBAkiT8j8d7s4lbXR9EGNGYFZtmFh33b82I0M/Ah0pMYpVhm3KWZIcWFz5jLFsQX+kK3kJ8/Dnt2qHhFgS4i50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734585284; c=relaxed/simple;
	bh=FxhFFaJQGrT0AW0gtm9Nshv9oHyau2gZjrkUzJ9kE2A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gghvUKOltljzCmONSfrq5cV86GiYgF65m+qwkW8BFEQpU799y3cOo1elgiuao2S5L1ktf3vjZyXZlSLxRHECKw+mAQPkO5BpGcaO15xCGVh1g/nIl6rJuOlH3IdDLFy/RrtLbTuLvq3t2Ewht6RvzdHSjupXUfvAXeVyFryS+Vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=czKwsG/C; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="czKwsG/C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qq3BprYkOX/7/h+Rv0XoQLCGwCBRixOiRsI6BZcxoLS6wBMNXPwiHooDd7Cvi3bFHT0+o45PD+Is8Dbhjwdg6quzxSwAkp9BrQ9edzw7YaFrjegIGeKD8rMy/ahO1gZ2nKCqVeFM0Is4kA+8NL97breUAj4CB20CyoGR7dMpvPK463Uipje4OE5Q4DteTgCiYJfCoZ8MPLxzy1cr2rsbvTkCJsbL4ZntU7gP6eGHIgBe1Zo0a5eJtPWVhFxtb6ZcYik0IpkwoP/096ScqngNiz2rGpwlwmEqkBOX2xJcihpCKNQ00nOlkGgzjwzbAkFBRnjBoeXw12Kxzi2vCIzzAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuiQlb+X0qO3MzfMfFHGSTuOds0FP+ainneRzadih7U=;
 b=JVDihPSsdgSTxtoT7ptyq7i5n1d2h2HXLcUnubeuAONPZfmsPSs+RkaPWYAuUOitC50Ultc6wCM8YxMvNjg1LpoAya61MbWTcG2xXK5RLXzjW2aabu358sDzN8TRdRorHLSLpuM4tapzMDCYNuP9U2GADxL2SKW5B+GeMROOhSoss74vrc6d7C9dg0AmtZtGm5rFUmw8SlpnRvK13pIIaA3ZrJiXRqMYvnjFfkJqrz6UtXon3hS9jVZYJnrroJ+/AMTU+tWlS1rkjrGy4kQ34F7agSvuPdHjBsXlYWSlsMxAVloolFFZEILJbDmgRYfzQb8uqNGznpRrAya7PTOu6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuiQlb+X0qO3MzfMfFHGSTuOds0FP+ainneRzadih7U=;
 b=czKwsG/C7nq88iI+pQ0eAh3bU944xWLDl17lyv/iEw0JLtIV5+hppdcsoyY9PqGjQ8j5/cNTbiRPaITcywslP3xY2Efe7rwJkJeth7pCu+hVb1edyQJ5JBMNoZtbdVLBfPPMvGPlr5UJ4F7A9JmSWwcTqQRhH7tZqpSyZsUlZjTUlITITgNdXxR24IR+BA9sO/4GHQk9VrUh5Z62TdrhmvWlAitJ1z4SMi3+1gM4/Nuh3YjklwRqS3pm5783wGRTCHMGPPEf0hA6p39+8cibRsOZBRkBNGWVb7B9EQo2EZ3TjeAcQJM/8uyMBsuah1B5Ds2NDrpWnSsCfIVBGrniBQ==
Received: from CH0PR04CA0089.namprd04.prod.outlook.com (2603:10b6:610:74::34)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.14; Thu, 19 Dec 2024 05:14:37 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::ab) by CH0PR04CA0089.outlook.office365.com
 (2603:10b6:610:74::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.23 via Frontend Transport; Thu,
 19 Dec 2024 05:14:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Thu, 19 Dec 2024 05:14:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 21:14:28 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 21:14:28 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 21:14:27 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>
CC: <robin.murphy@arm.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<thierry.reding@gmail.com>, <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
	<patches@lists.linux.dev>, <stable@vger.kernel.org>, <ikalinowski@nvidia.com>
Subject: [PATCH] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding
Date: Wed, 18 Dec 2024 21:14:21 -0800
Message-ID: <20241219051421.1850267-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: ae7be9d9-7b6d-4f2c-66e2-08dd1fec08b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?50OfU6Bu+EdVSjyZR2AkTW3kEOjLwy0zHX7G57Rv1X+M9fQ/mu3i/z6+bI9H?=
 =?us-ascii?Q?EHhLtrQ8RTGM3p7SASt1j296pVFyz5uiJ/ifXfogCOcrBhnMBBcEbSd2dhCF?=
 =?us-ascii?Q?u7ewlB/MBdyExhmmiLqZB/3p0gsoUCnyS4TAOjCdg/S2lz4acov4jUnQVP8o?=
 =?us-ascii?Q?H3lu5H0wIg6jc1KIa4JmLnUIKKXx8ODSAM5baQ7uNEQWCNvu6ig0kr0JxjBN?=
 =?us-ascii?Q?kDHBDmVsrVlo0dWrF+nFbKfurLaPDYDauOtczdife7iwDlyMTrYgUEe3vkvy?=
 =?us-ascii?Q?AeawXrPGuDg13w5dqohJJJrSLz6d7Ls+Vnl7CCtrqZ/5/kqMcHq4hX+CUbPw?=
 =?us-ascii?Q?BaND8YtRvjEgSbNLoUkHl48Zx3a7H6d//BksKB0Va7fUv0bkMMQDxDMoPAO9?=
 =?us-ascii?Q?DKGb2Ks1q6YPoDYoRxFnygYasWxwCPPhT6cgwv0Tjy7uKHgH5UQRWQaZ/+PN?=
 =?us-ascii?Q?ZHmCyM2crRBWo1z5zKR2o3OTc8wSwtwWKGXBCL5UF6IgAkRnx4vhrAlDFDPx?=
 =?us-ascii?Q?xzA11dwKRs+a4zSm9mvIJ4CXNshtNIs/zxDvy7Dgg6IA2j2p40xx/2kcD0TX?=
 =?us-ascii?Q?Qten+I7UvHekxC32ENk/OxA3E56k8kGTJnsaOa5+7byMJ07l4XC0HUa4s6qK?=
 =?us-ascii?Q?AWfaO+GUMtDRCtUCwcw6DwKLG9LugQikl7IrXjzOBcxd0UgNh/bUXRNcEL/R?=
 =?us-ascii?Q?ctccGb+m24GLutb8BSObhaKdYBl3KubZ/l4zY0L7rhYwOBsR5Q/JREHV7NLO?=
 =?us-ascii?Q?x7dq8A5Xezx/o4pfQ9SmKqRZgB1ytzrtMxJ0YFiJsb4h9hYEb4C4t6VP1IML?=
 =?us-ascii?Q?loLZ1spsASolN4GwWWJiunnpsJ4PMbgk99pz0USI5vOlbbXGRpglXDcBMxtT?=
 =?us-ascii?Q?z5TAfnwaCRdhn8AsAb5VW4uJzN5VOe+fiFDYJ9aYCyDt5/bD3bwC6kq1tgxC?=
 =?us-ascii?Q?PkbXCXpqpaHvgnf2yM6GetJTgzBMyBIaSgoGbYZNVqSgXtsJKTKg3sS3pQHb?=
 =?us-ascii?Q?eZanF5zwCVoJBHZ9Nfi09vSFSAdchxhOtVmZPbmJpYfc8Eoj1PLxEqcPnEgI?=
 =?us-ascii?Q?ONCZRu6E8zUhsuonTyvoCQB9GcCgiy+j833bJTA7UctWrkHS7QQ5xfUl/fTQ?=
 =?us-ascii?Q?Wn9XSY6di3XsW/7fZwXBAPKiuToSv4f7kbP/skaFXXA/IXSCdwtvyyQdg0vh?=
 =?us-ascii?Q?hTp9GaZeoSptwmyQ8ekUEano1Zs0VU6hR5jEJplc3EL05V2PGarg80K5BY/o?=
 =?us-ascii?Q?cT4PheN4YNxI7YfijnvxygS0jWzVB9nfS+E6UqqdhEc/vuWHury21Pvn9s9a?=
 =?us-ascii?Q?Rc8Bofm396QYA0RdwW4vIO+VSkz/rmNMpxM0huByGh/KJaDahX4fPk+uhBee?=
 =?us-ascii?Q?hVM5ELUCXtbQP/3Ikcx65PLHl0zeQ9yvc504bzly1vbFEJQN9PcGJeQk6bi7?=
 =?us-ascii?Q?xYK1iykhEYLNSFfLvuPyBts9sDaCMNyFyTmmBefK4vh6uq7nXU/dMQH7t/jn?=
 =?us-ascii?Q?ly3hh1HoIMZqJXY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 05:14:37.3699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7be9d9-7b6d-4f2c-66e2-08dd1fec08b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962

The hardware limitation "max=19" actually comes from SMMU Command Queue.
So, it'd be more natural for tegra241-cmdqv driver to read it out rather
than hardcoding it itself.

This is not an issue yet for a kernel on a baremetal system, but a guest
kernel setting the queue base/size in form of IPA/gPA might result in a
noncontiguous queue in the physical address space, if underlying physical
pages backing up the guest RAM aren't contiguous entirely: e.g. 2MB-page
backed guest RAM cannot guarantee a contiguous queue if it is 8MB (capped
to VCMDQ_LOG2SIZE_MAX=19). This might lead to command errors when HW does
linear-read from a noncontiguous queue memory.

Adding this extra IDR1.CMDQS cap (in the guest kernel) allows VMM to set
SMMU's IDR1.CMDQS=17 for the case mentioned above, so a guest-level queue
will be capped to maximum 2MB, ensuring a contiguous queue memory.

Fixes: a3799717b881 ("iommu/tegra241-cmdqv: Fix alignment failure at max_n_shift")
Reported-by: Ian Kalinowski <ikalinowski@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 6e41ddaa24d6..d525ab43a4ae 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -79,7 +79,6 @@
 #define TEGRA241_VCMDQ_PAGE1(q)		(TEGRA241_VCMDQ_PAGE1_BASE + 0x80*(q))
 #define  VCMDQ_ADDR			GENMASK(47, 5)
 #define  VCMDQ_LOG2SIZE			GENMASK(4, 0)
-#define  VCMDQ_LOG2SIZE_MAX		19
 
 #define TEGRA241_VCMDQ_BASE		0x00000
 #define TEGRA241_VCMDQ_CONS_INDX_BASE	0x00008
@@ -505,12 +504,15 @@ static int tegra241_vcmdq_alloc_smmu_cmdq(struct tegra241_vcmdq *vcmdq)
 	struct arm_smmu_cmdq *cmdq = &vcmdq->cmdq;
 	struct arm_smmu_queue *q = &cmdq->q;
 	char name[16];
+	u32 regval;
 	int ret;
 
 	snprintf(name, 16, "vcmdq%u", vcmdq->idx);
 
-	/* Queue size, capped to ensure natural alignment */
-	q->llq.max_n_shift = min_t(u32, CMDQ_MAX_SZ_SHIFT, VCMDQ_LOG2SIZE_MAX);
+	/* Cap queue size to SMMU's IDR1.CMDQS and ensure natural alignment */
+	regval = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	q->llq.max_n_shift =
+		min_t(u32, CMDQ_MAX_SZ_SHIFT, FIELD_GET(IDR1_CMDQS, regval));
 
 	/* Use the common helper to init the VCMDQ, and then... */
 	ret = arm_smmu_init_one_queue(smmu, q, vcmdq->page0,
-- 
2.43.0

