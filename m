Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BF11A3BD7;
	Thu, 14 Aug 2025 01:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134785; cv=fail; b=nL05AJNs+knnRkTuzQKh2F4laiTp7W6JozfZaOzhOP7k7AXkFKNTjM/1aywEK8DGgIxGdmwlaNAtm2oXfJoJrGtUWp53beZ0OfMhCm/LgRxbsXQGLGN/PH0VrgexM0x9Pqko4ZjYFgziwcTcRtfQG2icPTlkAeUsvlX3YN8aVtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134785; c=relaxed/simple;
	bh=43ZMWBORDEpyjm+2IXDdkboOglfwTlt2zG1vUiJBlh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/O2wG2uYJYL+13rUG0FeyVdTnSDdUP4hUQrWzeJhMYtkOpcJ7acG7bHzaF192MpyCmBfQUeUoEBCzbpm0uS8/HM+vdatkmA9xYxtEo24BU4xaouSTmuIZ/yRMPrrwK6mq4bPO1FUix7hSN//+wnZ3QHykvCtKvZFYUrK7OgLmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kPFDpa6K; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kPFDpa6K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcWWkLC8ISjiEcxOkJxua+qBRnOHZZcNRckHWiozcBUKjBT+Wxn+s1MNhuUgpO6YH6SQl08ET86DE75sWd9eAX/nO5iR4f3UWLAmF/BEPMT5pJqeP5dtkuGhaVBdIzzVcNWwELfwPKjmbfUbSHNXYCT4xIFOW+nv611N3gMkzl/VjeSfqsFQCv6vaDavnttVImhtdLOKa46CwTFJVy8tcponu9PZosGdqGGBFL3jqCEqrCoTDP8Xnjsd6CRJusXtxXcBsdT0X6gbeiJYARpaGn6AhyfN2N8nt6FBpH6RscnpIOWLChVrmEjhIRBflHCVVKu/6dxF97mjditIB/3H6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dAYTIaV9Q0/Ly0dbrAP3ivsk4xFT1n521Lg7rIKLrg=;
 b=jCNefJDMsb8GHtAHqHCqgdopami4bVRISWynpRyhwEguKby72H9aXmNs5/ztZkWSvji7CE+5sGc+ArZWP4CaJXXzgCpaqs7ljymE+sP7oTbm2sL2sq5Ewx8GJf1P6v/Vy7jQxXs2G8jRSEtDzgihJd+JVU5ApQPynuzMBU3AyKfN91oLMYT+3Ahuwh/oW9ttw47t7v0A/rlKq/duqK1ZNeqe7jvKxHn3eHZ066TN1hG6GFXecb5sWUox0PmAqE/1z2rIt4SFi0R5ydufXylqn7lQL3gxpyr/24QMS1LDSoi8MlqozMZvEDc1Yg5X+mgS22QO3Du9OvNmWABY83f34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dAYTIaV9Q0/Ly0dbrAP3ivsk4xFT1n521Lg7rIKLrg=;
 b=kPFDpa6KFmOUrvzvtXgJvJMAm8rikIHG5sUo5Cl9aQiDcCjXppMXYLeNGxOyjVda0/jc/TER47TsbZPsviG8d+2RyNgSaLngLtcbD/u/ipCCTpAx/e2Jc/OOa1N06vccl8S9x+qWpf+ehaIk9p2XUaAGEr5lnn6MBQgT2GPMK6X32WIPAzAMaIyI5gHCLjOSM/ZvdFK4p3A0FeCidtOnai2sUm8OQEZztBePx+tmTgvrSfFnkPbYtwjsgTI6KvCnHuiPvvsBH13d7Vk7U34s4ZjsGjmpWuBV0Q6560j/Bz7kfDLOoIwFyNb0CNASDZAsPSuIotcnHklSptxS3AYlvQ==
Received: from BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45)
 by PH8PR12MB6913.namprd12.prod.outlook.com (2603:10b6:510:1ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 01:26:18 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::d8) by BYAPR08CA0068.outlook.office365.com
 (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 01:26:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:17 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:02 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:02 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:01 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 1/8] iommu/arm-smmu-v3: Clear cmds->num after arm_smmu_cmdq_batch_submit
Date: Wed, 13 Aug 2025 18:25:32 -0700
Message-ID: <cb53a7d3a2ed1092eacfa03d10bd8b6bd999bd3b.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|PH8PR12MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 562d6e60-6821-41d8-ab08-08dddad1917a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3A8eDBpWUwWNnQ8WCI16Jxy9jqNic0VO3r4vVlQu4y5gXowxmNuJqAb3OrON?=
 =?us-ascii?Q?LfRISR9ocPO0cesOIzka87LCfasM8x9hsEcC3+PYu8dej4LtWePKSJa5f01c?=
 =?us-ascii?Q?seRB983fVHT3XxazndSQ6mdYQKAVUQHEPaz7AvNW/FoImImSLKDohlcZD/nv?=
 =?us-ascii?Q?DCtS8xQPNge0oWHmnY3FTmBXEB0f/U+7XBM9cggM4rW+x3zVe0ZrVZ+zPYtD?=
 =?us-ascii?Q?IZTUblvSANS6QcCJSw7aHYNMVLqCj+GEVXYxoxqEep1Y5VDooAgoFtznNYry?=
 =?us-ascii?Q?K29/umOkdvxeeKx68B4Drhh3oekZC/7JwP2hdyr2JGCNtqhoSzJhTAogiHDr?=
 =?us-ascii?Q?e/u6JPI1D+mho3bJH2KnM6D+bgGJ4BNLjXrFkw4hT4oBXZgygq/db+bxNFMS?=
 =?us-ascii?Q?FuKxUkIGnJjq6bY9QfreJn9elSBdPgfYJflQUNewaFGNWGkKyK3dY5eScNPY?=
 =?us-ascii?Q?pwQMmtMjGZZbsFY370FqEIAhmJAnReh1EHjydxvjFRPCxXsLG1Ln0163KaeM?=
 =?us-ascii?Q?7bCPzGfIffkL+rhc0moxD7KyBcy/AsK7+EM1Qx2OWsbizFTP/s+2bJGEJEkb?=
 =?us-ascii?Q?rofhyMpqMv9WO1El0PCLxx7GCqsL3HBuJNhhIhN5bCp2fMg2usOtn98fx9fe?=
 =?us-ascii?Q?5h42NZEwbQWCH9p4IDGm6zgWFck39c/qQctqdCWNBxwo6esV7CtvfufO2yiB?=
 =?us-ascii?Q?kiOrwwHECE5toBsiWFsZGbYJBJSndwNdbxCDTZ8ksIQ7ABQFwTfiGo3WihjY?=
 =?us-ascii?Q?nze4EuPLKb0g7Qs+YMTXyVMLffG2GucQHAE7CtbcB7jFxp59YW638v/Q4iCP?=
 =?us-ascii?Q?bS7tJZUF36/nuJDI2Kta2agefYqhFx6oYy/xfONz1jQR0iI5fk15tICTVbPt?=
 =?us-ascii?Q?0Dym3QvFBmMd6DCIVkM5Zds3qPQ75T/wM95JTqA7yXajyFHYYDPKjskjncne?=
 =?us-ascii?Q?UDVgVeewe3A0JS0+Kanjvt8naEuS5mIrtYfKpjZRaG7TgqEN1T0Ecx5W/b8+?=
 =?us-ascii?Q?Q2MnsRrRXy1RZrldG/sNvveulWoUsliMHF6Z0hivQj5aWFZslsM5rLf2h0eJ?=
 =?us-ascii?Q?01B60LfX+d0CfaZHet1t7Obd9zOSYl2bvABVD03cxBPnMT8VpxktxjgFpLwQ?=
 =?us-ascii?Q?cEz6bSys+sPVadK+pSQtyK7+iiKYsHl5eEdFTiz7pWDzqy0FVD5mD2LKvbsm?=
 =?us-ascii?Q?dB3xWC4+OnkgbQCd3mfR8FqsmyGuio+MnIEr0c+SzepeexaqThzsv0PrxdRT?=
 =?us-ascii?Q?h+Lz/QMeRnBCni0Tw6zm0t16zcYl0Br+m+/bNrbJEZkTMmm/DrR4dtxFYBR1?=
 =?us-ascii?Q?b7D3Zcl80ivgm5IZLsQjIxOEfvAPV/gXOTFrpy3rZnYr7PaQrLNV1xUhxiI/?=
 =?us-ascii?Q?ExYRvIlYqDgx+xqTt83nOpMWzWzY4ptvSUrhWVvGD3nxi2pnmZy2IBeHruse?=
 =?us-ascii?Q?jm08UEekaUGBB0+yi/h0se4SqR8aMz7Az4Ay3/pQB6HN1qELnJqecI4CcPIH?=
 =?us-ascii?Q?Ii1vnHHWQXmyiGvxKIQv0AY6iwAdDZ9l1e2V?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:17.9578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 562d6e60-6821-41d8-ab08-08dddad1917a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6913

None of the callers of arm_smmu_cmdq_batch_submit() cares about the batch
after a submission. So, it'll be certainly safe to nuke the cmds->num, at
least upon a successful one. This will ease a bit a new wrapper function.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a8b46b948f05..cccf8f52ee0d5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -974,11 +974,17 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 	cmds->num++;
 }
 
+/* Clears cmds->num after a successful submission */
 static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
 				      struct arm_smmu_cmdq_batch *cmds)
 {
-	return arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
-					   cmds->num, true);
+	int ret;
+
+	ret = arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
+					  cmds->num, true);
+	if (!ret)
+		cmds->num = 0;
+	return ret;
 }
 
 static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
-- 
2.43.0

