Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6C63CBE6E;
	Fri,  1 May 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645780; cv=fail; b=uqzVKW+HdJ62qApuFUItwN3TIlGgzVWSpMyJ6Z/bcu2a8TtttD4sdrU2QK4D1MJvPcez1EV4hsErNZhRs6bmzHKdUgx3GaSaOPRcuqpW6kvYhDwU3mdmJJiXV2plm7E2bU4LqrEIsjREaO5UUsnKfqvI1D9YQuCxijMHKAZbwE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645780; c=relaxed/simple;
	bh=0DiZO4rPrp8Dq+oG//ohq4PLiX7J+sApLhLL8xPePjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S8f+5dXvnBnRoxiQWTQABRzLbEJ517XAzM5fKFCVRce1tQql4JcD8522bOijYfRToxkRAdj08Kz6cQQ66dDmcAHCV9h0/RsH+XdpFfygA64vIP57SAeQe6AdxbImIEcA4aNTDnnS8E9ggLftvSbPQN8ZB9kAdU35sjwVA2Uus1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=khV++btL; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="khV++btL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLD0LYIfmHC6OkV16ZHFyZ++PEjqjg82fN+5teN30K1h23eDvEzk78qorXtxZ6F2U8wNGLsFrdlYD+CxNcfHQkrOg8CFigAfgBfhrTOz6KkRqGa4rHvOQO3bL6HyyDs/zaGr7Gty3OjFD8zz79F+L9rk1T1qPMTrd1O2PHwonMYSEeAyVY4sbi/zFwLTPKcMjspbLrJbXtrLE3tukvzy1tJWx6BKO31UUpM2DUV6Kh2kCK6C0mq+H0J2LZ6GZEpIny2DohTaTWFZhPQB9m5Uzxy1n1bI5Tk92RENKlkheai1Okwc0zVFucKXzErv+1FvYh2DQNsz5uo0KdjsqzvRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNjJ5QHnutlgt5Uk9IPWdQzl2DOPiAyg06fxlD64Ep0=;
 b=Z8eWy5avSKljw9oLJOGxEeg/UGv/1RBO6k90QrlPksyEF99mMTMXdOSVMScRA+v83mtFV1TmJYNshfODxpHdwVlGNluS0YnvjkAqywm1BoD2k30WhllcQn3OKDTIcL4Y86BysHCwdrJtOzejqdoPLRzn3Yib3vakm2fEw/G81LQAFfnRfZb3/YazstBT4sxEpDogOcpY5alMBgygECv18qRqoT05s46977pW1NULtvQ+IXTXdi0aIc+LZUH3me4aLg/BOISSw+00mz8npLKHbhFxzYws2G7q19hvywGHbVPwybt+pFGA6B/WQTGW3wpCCcfBz/wQPcJbNs0+np1P9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNjJ5QHnutlgt5Uk9IPWdQzl2DOPiAyg06fxlD64Ep0=;
 b=khV++btLMqnYLVeW3aLdYV4itK/Xv60G8nUNi7yVXqx90bjn3bj2ECaZ5pXBDujl7ltQjB9tVh4cb3wh/MVRfuYI4+LX+KE11Gh6QwLEGc3Ah9F+hQri1r9GBhJiaEf+3SnYT5Lm4oX/4DdZtjAP0reX3esRR8Y8LTzWz+i7Ilanh+UopDJewt2hpgrjQfEQVTSxVl8iKIxX0neyoEXBElyNGm6PtVUwjfvpn2B9tQQav0ueDKBTZZjBjU9KfwfGcUqwG0a73Rm3tY/7/QHeBZIwe/oG5mmEcOEA2r6sHFOI/VeA0eiyJTSRhuLWqCVQyxV79jwgJaAABovhxSfmBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:26 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Date: Fri,  1 May 2026 11:29:16 -0300
Message-ID: <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0039.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da3e7b2-ecc3-4348-e963-08dea78e09e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QHsVPgIFf9hMijehBynNBpgxgiTCAjhb18Ig9v5oneEqtfszHeWPmVzS1D/ApXlzsBvtz8lxX6gUoCrWHo4JiLeUxH2om9t6xyFfR1I5QMSWjfLhoj5r29OCGYelNweihpH2QgY4ydxi1yzNg80R7pA/LuB3gR8QODmpmtxL9xddZ4GdFIlbKgVSgDGoH8io+E8loAUBmUhGfN5BR86YGIyou6Bnaj2ErWLr5SC7JXmAvB057FuFhSGH7/LlrGTklNnmr5juiK5l4GUXtxfoK7FjkqY5+b3OZP+0JYpxnbyF5bZED2SvzWARwDIJfRXIk1hk3V3GHx7Brhncc9ovYTdg3XLennG/DEShqKDJgfRdPqfYlXvVExRYRvE4lcpRXQGzwqx5Tx5lhoD+BqSgT9Y1uT0eGc3h3XkJfNXGXiXPuEo/wSshzQFJdKyg6arKGEUhAeUKhIrRwJVg5spuZcQVDimCu63Gpqc3Jr+pPH4ohF73jTLV0ZS+ZEMHzwnlRO9jlOW1ZH9f74YCZkFRk3NqL1dKkJ6wE68hLutwkZQbNa//J3cvU4qDkB9czUwXE8yeRBxUigfl2U/vanyACBf0n2GbxfpdRUEs2d2rzgaSserSM+83IhlAFSxffvm+PFdWTRuiojNz6L4UXmbvQvYg9IXB+CBrMajdx23XnSbmu93OloO87utS+90Z8CoC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8uPOq5M9IFwzc+czo5K+q9mlanNy/wv1wb0IzDCIHIKQ/LAj6UdWcQ+M6981?=
 =?us-ascii?Q?Jz1XEULFnZOWShImV8Vfi+5KjZIfyRfGFxyR0dscQMRS9Ynzn+vylXX8O81r?=
 =?us-ascii?Q?eSTlj99uJxb+5oDKIVZpWrT7pYPEeL30TLuY14smMhewJwc40cX1N/BTiBjC?=
 =?us-ascii?Q?uKj1NgLENnwe2J2StTkdNwVnqnobG8GcrJgfDd+lcSxt9QRXWN7Q7s3bfjL8?=
 =?us-ascii?Q?tyoNlx6NRIR3A5PZ7fkEMrrgMJh5X1pNFWRoN/WnlQ0AeV8hdgWac+HO8Qkt?=
 =?us-ascii?Q?W71HJl4nrod+Rd8MDTwr20RrlRtTI61fFOvoJXQeytMzTnom8c2+t1RMhaI1?=
 =?us-ascii?Q?pEBMKe2dvoUTrQQYS5xg6asYXPzngiENOI9wfXyx0m74Oj4Jl6Iy++Z6XSdH?=
 =?us-ascii?Q?Fqa0CRUAJjPi2y4vzLOBy452pPxw3mpb3p40/aIbQgx4Wn8wFVMDzUEKOuqz?=
 =?us-ascii?Q?avf08cn27TS4LEzS5ymreOBwqi1j+iXEL4PsMRpwl85iVufVb041BfrWhRMz?=
 =?us-ascii?Q?hSlsu8Sh7/sYRQsIKYy+m+qmDE7XGQBPpRnwc5bNhsUIX6WnzipjnzcqHN+P?=
 =?us-ascii?Q?7UAPycsZQXJLcpPMpUNos++dG1FgQre1JVBM6KkVQsZLrMH8Sb7CeI6cyXgE?=
 =?us-ascii?Q?PGmJ7LRpIuTHbSRHJR6c+DEejKgVguZgFkzMUWhcRnX6WzYwvzw51UV4iWWn?=
 =?us-ascii?Q?Twh+Cj1qpYLa7EAJqTd3RctHeADjhZd+rRqCYEep6dbUPLcqqWMmBhadRGH5?=
 =?us-ascii?Q?PNSYnk4xDF+wSSiX4xyXLPEbtNTTTFTZATqLXimn6AjD62QAt+Zgz27t0CUR?=
 =?us-ascii?Q?DcoIcfb6z33LhMb1xr6/ZOsjy6K6T0lbK2xLeTTIkjYM9t3c4J/NaQBRWwjR?=
 =?us-ascii?Q?P7fEoIWnUPzC1ILCK5GUiR2VQMfz7hBN6YUPqhl9cTDxslZ95WDHIlNacyav?=
 =?us-ascii?Q?QNSWoDPb/n8BKjS0qoHzxigP4Yyg0BOs7x/wATpmb8Fs/UAEODh94gPH1qOJ?=
 =?us-ascii?Q?kZzNd4Dd0OSIYLlG8mpu/6rdod/ItfjBaDbDUOAxYjlHfPRtfIKRACPfqds5?=
 =?us-ascii?Q?ghX7oYkX0wq7D118udyn3H/zAtt76QeWijsayfY8yWn/u+fJx04s/va+Fq/k?=
 =?us-ascii?Q?a1SHnKumT01lNd7Z8oxNeXinv372ij6Iw4Y14XUJRbrwG3bkZhYPzchMLTw4?=
 =?us-ascii?Q?tavM5Pvc3ASbnneto1Q7psFz/7hM+/PxIa0dhY/RB9T7wAtjgcKChG3EoFCJ?=
 =?us-ascii?Q?Lq2kY/9jvhsrm6jxdGhIhjSyPzTlwXRo8/CT7ugD6+C+Lk7x9bV3Fw+dUDgY?=
 =?us-ascii?Q?rHDeMtscONbMKMmHGncQkvmHc2SmGsT/g0K92U3K/RNqWgZ3OJwixD7gKFKT?=
 =?us-ascii?Q?vROhlblHzYTsdZ+AbYCKNmEjoUWITQgaiirVWlyygQRi09U6mHpz6KHBFo0s?=
 =?us-ascii?Q?3jqr4z+mZus0yh6wFcM6XeH6TTjtOJXfNhrXcaQn6QBc19uz8j/FkqFZbXPr?=
 =?us-ascii?Q?qTPDiDyB42aAY7CBUbcwG+P+rl9HY3GHlxYgjaH9n5cJEkrQu8Lo7UdsaiOy?=
 =?us-ascii?Q?RGXuS+kbdomxO+xY34CwV6KjLLPVL9C0IpEc5KVM3BnkoB/7vYC/jW71vZq8?=
 =?us-ascii?Q?AADITNHBlTWK7vi1cH56T/d7iV1Whrb/E5Kz/lIkFIaQ7wXdXop1iZEuDIgf?=
 =?us-ascii?Q?P2yX9mnuOeWGxn2FtibJZEnefkI2OfV3zCc+RknRbaXEinqz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da3e7b2-ecc3-4348-e963-08dea78e09e1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:22.9672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWk6GsbMv0Ftd2rhPInw2Qtt0CSgcN5NNa/gU1UIjkQcdaxMSpV34MlNiedPJFB8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Add a new command make function and convert all the places using
ATC_INV.

Split out full invalidation to directly make the cmd instead of
overloading size=0 to mean full invalidation.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++---
 2 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f9c25ca9a9e7b8..0cdf0752ff6d62 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -308,14 +308,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
 	case CMDQ_OP_TLBI_EL2_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		break;
-	case CMDQ_OP_ATC_INV:
-		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_GLOBAL, ent->atc.global);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SSID, ent->atc.ssid);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SID, ent->atc.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
-		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
-		break;
 	case CMDQ_OP_CMD_SYNC:
 		if (ent->sync.msiaddr) {
 			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
@@ -2371,9 +2363,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static void
-arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
-			struct arm_smmu_cmdq_ent *cmd)
+static struct arm_smmu_cmd
+arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2395,17 +2386,6 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	*cmd = (struct arm_smmu_cmdq_ent) {
-		.opcode			= CMDQ_OP_ATC_INV,
-		.substream_valid	= (ssid != IOMMU_NO_PASID),
-		.atc.ssid		= ssid,
-	};
-
-	if (!size) {
-		cmd->atc.size = ATC_INV_SIZE_ALL;
-		return;
-	}
-
 	page_start	= iova >> inval_grain_shift;
 	page_end	= (iova + size - 1) >> inval_grain_shift;
 
@@ -2434,24 +2414,25 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 
 	page_start	&= ~span_mask;
 
-	cmd->atc.addr	= page_start << inval_grain_shift;
-	cmd->atc.size	= log2_span;
+	return arm_smmu_make_cmd_atc_inv(sid, ssid,
+					 page_start << inval_grain_shift,
+					 log2_span);
 }
 
 static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 				   ioasid_t ssid)
 {
 	int i;
-	struct arm_smmu_cmdq_ent cmd;
+	struct arm_smmu_cmd cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
-
-	arm_smmu_cmdq_batch_init(master->smmu, &cmds, &cmd);
-	for (i = 0; i < master->num_streams; i++) {
-		cmd.atc.sid = master->streams[i].id;
-		arm_smmu_cmdq_batch_add(master->smmu, &cmds, &cmd);
-	}
+	cmd = arm_smmu_make_cmd_atc_inv_all(0, IOMMU_NO_PASID);
+	arm_smmu_cmdq_batch_init_cmd(master->smmu, &cmds, &cmd);
+	for (i = 0; i < master->num_streams; i++)
+		arm_smmu_cmdq_batch_add_cmd(
+			master->smmu, &cmds,
+			arm_smmu_make_cmd_atc_inv_all(master->streams[i].id,
+						      ssid));
 
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
@@ -2650,14 +2631,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
 			break;
 		case INV_TYPE_ATS:
-			arm_smmu_atc_inv_to_cmd(cur->ssid, iova, size, &cmd);
-			cmd.atc.sid = cur->id;
-			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			arm_smmu_cmdq_batch_add_cmd(
+				smmu, &cmds,
+				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
+							iova, size));
 			break;
 		case INV_TYPE_ATS_FULL:
-			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
-			cmd.atc.sid = cur->id;
-			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
+			arm_smmu_cmdq_batch_add_cmd(
+				smmu, &cmds,
+				arm_smmu_make_cmd_atc_inv_all(cur->id,
+							      IOMMU_NO_PASID));
 			break;
 		default:
 			WARN_ON_ONCE(1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 10b3d95d9ee660..194f73cabef5c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -552,6 +552,25 @@ static inline struct arm_smmu_cmd arm_smmu_make_cmd_pri_resp(u32 sid, u32 ssid,
 	return cmd;
 }
 
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_atc_inv(u32 sid, u32 ssid,
+							    u64 addr, u8 size)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_ATC_INV);
+
+	cmd.data[0] |= FIELD_PREP(CMDQ_0_SSV, ssid != IOMMU_NO_PASID) |
+		       FIELD_PREP(CMDQ_ATC_0_SSID, ssid) |
+		       FIELD_PREP(CMDQ_ATC_0_SID, sid);
+	cmd.data[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, size) |
+		       (addr & CMDQ_ATC_1_ADDR_MASK);
+	return cmd;
+}
+
+static inline struct arm_smmu_cmd arm_smmu_make_cmd_atc_inv_all(u32 sid,
+								u32 ssid)
+{
+	return arm_smmu_make_cmd_atc_inv(sid, ssid, 0, ATC_INV_SIZE_ALL);
+}
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -630,14 +649,6 @@ struct arm_smmu_cmdq_ent {
 			u64			addr;
 		} tlbi;
 
-		struct {
-			u32			sid;
-			u32			ssid;
-			u64			addr;
-			u8			size;
-			bool			global;
-		} atc;
-
 		struct {
 			u64			msiaddr;
 		} sync;
-- 
2.43.0

