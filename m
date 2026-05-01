Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCC3C0610;
	Fri,  1 May 2026 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645768; cv=fail; b=hTOPHAxYJbr46/Jx+1EnMCxFTn1izaoArueW+f3ZXiV3mvYiqY2mGG3Loyj9R1n21W80HwXSO3lcz2rk3ImcKjDlZeQZY9v2e3PHkaOKzjmXyCTB5V3QU2zgOePDcMHSttha00WmU9USu8Z4kZWxZ17dT5VRp3K4HvBILrVQbg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645768; c=relaxed/simple;
	bh=qD0LZ6bDnQ4zYwFuloWD3o8VwcR+nzHS7qO0LCfq+GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R8BNAhBR0MfXEkQ2HpxlWNW5EFAHz6/6NoUMBvCvWFEDIBeiYdVBvRDDf8M+Bp3x5WiksgQqkSXvYEQPGfTrvWejaGuS29bwT7y9WxcVVSFYc/uOK/ygZ+aZ6Q2ZNMkWGd8rXP8p0lWYUkXk30CAKR19DfDdc7WpNt5DPjRdPmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FyiVBIrS; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FyiVBIrS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2AJWHeaPshmRicOenVuUPTnyp4lP+UMyjs0pDR2uerwoyZSk2AQZ4ESUSyEo5JtEWqrC/BTMU13tnXbD7OLH5oJZXbYfmf12rB1/SUpr6/DpDuKwh8+DCvNXpFtYbBYq+BML4VvDaePVGxcyDxX12/s9vr6f9FeDv3GkDKTVS1Iqe6/QqHlShzDEoa5/mwAdpc3GIzVEfXdLBM+J/DN9qzCWsbsIWh4PiqXbNubHMqBbSdvkHzIsc9QbUqtvQ7Gug1kZPvrgKRR9SmS8oAxPj/5AEojrSOBogEiGeyvAiSZNW/kaZZSzEeNN0LXWb9HRA1z8H4FafzHhGuswR6D3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1uhfAmuA8YY+eLYAKMut3jF20w/vgKNBzm/D/EpeDU=;
 b=oP3rf0Fwu7G73b4mj58giCf0Th3T6m29gKs5iwn68Wpq8HA61BP+AdyOGroz85MggdCeztL5ZclPqyYx2AEUTCxoOBJkPmrsnBh8FPquQ+Rimo3Ni2sFSc1tMrwYZm9r+Qcc+wjL3N8Df8ZwNZ9IR1BZmufKWTydu5cUgYGvZiK7fcYjYlZihKdD6EoCPgSVowN0LHrbO+1dbJe+InyUVOj2YJsqUVSiU7a0Aln9DNVmYQpsUQKhYSfzKRCrDLONAFUSAHKra9t7KZ0b3CATaD+pqUF+FGars1s5fshsvdw7wufIy1miWLqIcqXUgPsGZ9VaV74wIoxRmJkCtiTjaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1uhfAmuA8YY+eLYAKMut3jF20w/vgKNBzm/D/EpeDU=;
 b=FyiVBIrSnpBq4OIUOqsWemzbaXIcr5e1JzLPsukc+IBM3zVX9iav7s9Zw4Z0V/2J5gHI8uKVkjIM8JuwAaJAcPbK4BU2DWtU5WOuqtduZlklNI1kqDnIQg/Fr7erkIePM6f7llppQ/nR053F+pwoPWYZfF0BlLjVavTxEBSVlO/+rmsm3hmayV5RPWRjGz7OYgkBv9S1vFVS3/rsyhd7PJUwMMgk5MdePBNgPdjkRA78pRhdpJOB6ANvYiq+ooJNC/YdWzy+ta3GL3cPHbI3JZ6daBx04jiiUVoSWcKNwTZCpWUHu+6zY+PItbMyHDzlcHPYKDGtgzX7tY0/89lWyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:21 +0000
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
Subject: [PATCH 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq selection functions
Date: Fri,  1 May 2026 11:29:11 -0300
Message-ID: <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 1312e880-e10a-46af-94b1-08dea78e0851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	frAEzBoDYkSQS4nn8UWgKAe8tHfJOX98vBzrG/qZV31K9Q3pM8MNLcR8OUGMkIPuLWGhKQK9iP3X8vXAr571R/iaz3E1/VPM6hZXQ6JejzJ8rTwOcxbiliIr6s2RBTQAJzLif8WGFJ3YBm4cjkoJc29LoYOYbZKCZp7agKCOTxMFvPCzjSsTR82JAtEarLEqAWLYhfzVwqkaNTw7lACO5LA8PepijvmR4tBATg4vRMUVXgz1x+zUggu899Wwab7raQ0hwbmRiFR4pydc65EoBRli1sX/m5SJqHTKAyhtwIm/TXb2FhE4iYZ7eeLTyfhdXHK/EVLSQAxhsbtSuFDj/a9CFregFWBSE+aaQb7xaezBFMlItr2eVTChOprBenxOFfAvY1gM5lS94FK6S7F8bQGU7Brcr3M1Elej2FWZ6BGRJ2lbmahGzHkYSsQ2h984yH1eiU3zCER3JX5utAV4LAF3E0oG8ZoB9ojIzTFNruFjb45UbLk6NC6hUOARPLnwiCtbwM0ecPIN6PHZiAAVSVu7UT2k5C1T7huVCwILMmkKVt57KTgX1uHtBGDbsIAcynBUtmkMwH5bvZk/FzPQOuZH9gmQaQLGxhvy7J+XWZzKWigoCPD7+hlm5q+u3T5TCs7+QNLoENBP2mvHJ3JMCS/8siPWt24xARhD9eRql7iidIzMq5PrAMvfnpFUc2v1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VCxv9iCTEKmj492Klh5MF4xsvPt3yPQBM5hhFgyMKGxNmsi7wHFol1lnbpRV?=
 =?us-ascii?Q?0JazwXXA2sPq5b/YimEDqXsZ7nkLCxz58ONb8sWXLMqavol8RFOORKAPRC2g?=
 =?us-ascii?Q?76axBYKPABbZXLgQDqJ0fIvXiktb8N1zNlamAv9EkbZsQD2BBhNdWlroscLK?=
 =?us-ascii?Q?CKzsS/Gcv5UElh8wXh3FijNpLeFitSR22O8IcSOkTN1tfTJqox6k6FQOESyE?=
 =?us-ascii?Q?X9B7TH+Nph1+NPiAH1ylqhHEs/V8xmbCVHUq3BvXUKvSceisnNo14lWfkqxR?=
 =?us-ascii?Q?A1W99jAK/h1iZwjDwWhWKenvs8QaL1tQGsV+Zrdm2CJjtk9vrULgXCuOvxtf?=
 =?us-ascii?Q?of4brogZeHUT8jv3s9Wq6Bre5onLyRpkdynXKlSrK9X74WyoUlPeXCggl6Li?=
 =?us-ascii?Q?0daebhy8dLC79rU9IWBikF0td4AWrmJbnhDMcrBCJI/fQIku7Vus45wrJ4Cn?=
 =?us-ascii?Q?lW/159+OcbOv/WhzqIzjXcIAnIBsRuhoJ3mOYSIs6QVLvhJz2vh9iboykw5U?=
 =?us-ascii?Q?LK3fDsdpQFSXzvwX78k6RC/hg7cgkyW05JYq7KZF+tcslyUDG4vP9WipHiEV?=
 =?us-ascii?Q?4act1hJibyE2plpnK6u0kNjRxhoXVDVlCRIx7Z09kVbd7Y5Pfo3H0ge2rGSN?=
 =?us-ascii?Q?UZjO5dK1mRTS1VA8id+OA4hShEAfXCqyodRrxqdVvQrqWUHD04s1WojueGhR?=
 =?us-ascii?Q?++m7mHnb1YyTrApLfcD0pcUCK/WdJ+MR9jl+G+iPlsadboPudIZOZ4LEuSD2?=
 =?us-ascii?Q?iGCLCYNeu1Ll9DC0E+P2z9A0BEYmR+j1obZ9dFLrkKNwTzK0I8VT89bE7RZH?=
 =?us-ascii?Q?jRNvoPTDZMnHD7saW1abIb9xpu+wK85P/1fw42uvcH5ht3xS11iNBD5T57f8?=
 =?us-ascii?Q?d7lwNao6OKXUWZnjnhvM9UqRxBif9HB02aoIcrtwm0yoUii62Q9Ae/3mG1kJ?=
 =?us-ascii?Q?WAWlUeWx19xBJi2MlAoaZDyXaNxNaQ75rjZ7/BmLG4cR0aAcqIRIeqYftJGR?=
 =?us-ascii?Q?C8OP4atR5QY9CkMm5vS3uvGA9suTaiNXXICg1jVUnBZKh2ZdgppS7Wyuq2hB?=
 =?us-ascii?Q?BZwhHr0FhV2aeyS2w4dHoPMQ+oZETVe2LkFuJML9oI00Ah1HQ7L2xLd1EPgU?=
 =?us-ascii?Q?DHLZc0O5/hUNmbsBwe4ISqUJ/Q2QcwcOLzUlwLhNc7f2AzitZE6eQuCKnyNu?=
 =?us-ascii?Q?KpG/cRYnUWlSQBcDVVBvDAXPJesXv7jjvvfmEwbo24k2XPMozminZNtywVJ3?=
 =?us-ascii?Q?Lis8YBXFT7kVVhws1nuyObhIhL7FYA7R5UZ9Eek68FOV3JdnlgWvfxMvjg6g?=
 =?us-ascii?Q?ns5xSVflpXDFHWEXfbeOyPGWUxlWNNRJigLHfiWTqSXZEiiqJ1rhWfJHVreI?=
 =?us-ascii?Q?y8eG0ML18aPPm1fx/fGx08HAcTd2tBhhrLM+EnrfWtBJp7GqrQhiM4+hmmJO?=
 =?us-ascii?Q?Pl6hop2cBeMi53yPoQ3TJj1we3hDB/8OnrdxOeQAiobmFuEtzZMVuCy9Huer?=
 =?us-ascii?Q?Aicyd2xaHw1yxsPog5OzvvBBsgGQw3+A6FYV+asYbr64XdWHdyhy7pbE4Ssq?=
 =?us-ascii?Q?L2P9yVqNxMgRfUma9wh4zlpx673wPwSbufQPqPDdh1F4CcNMgoKk8FRqQ6P5?=
 =?us-ascii?Q?vmdPuWYyZqOZ5aadPVls/LqRxFa51S5VXKWAJUagPCPbNpvUnsz1H0NVXACn?=
 =?us-ascii?Q?2FYDo03Dy8mvC15ljsaZNjDnhPJc7rYeKldKDF+ZV53ckcSa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1312e880-e10a-46af-94b1-08dea78e0851
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:20.3273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtZBMOn7nGLGimjH0DGdQKdtbYtA1/upod8Y4IUzJn9LAplXSiasRHuovFww7jDy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Start removing the use of struct arm_smmu_cmdq_ent, starting at the
lower levels of the call chain. Change the functions that determine what
cmdq to issue the batch to into using struct arm_smmu_cmd directly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 47 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 ++--
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  8 ++--
 3 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e8d7dbe495f030..5cdeaec890592f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -371,12 +371,12 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 }
 
 static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu,
-					       struct arm_smmu_cmdq_ent *ent)
+					       struct arm_smmu_cmd *cmd)
 {
 	struct arm_smmu_cmdq *cmdq = NULL;
 
 	if (smmu->impl_ops && smmu->impl_ops->get_secondary_cmdq)
-		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, ent);
+		cmdq = smmu->impl_ops->get_secondary_cmdq(smmu, cmd);
 
 	return cmdq ?: &smmu->cmdq;
 }
@@ -924,16 +924,16 @@ static int __arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
 				     struct arm_smmu_cmdq_ent *ent,
 				     bool sync)
 {
-	u64 cmd[CMDQ_ENT_DWORDS];
+	struct arm_smmu_cmd cmd;
 
-	if (unlikely(arm_smmu_cmdq_build_cmd(cmd, ent))) {
+	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
 		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
 			 ent->opcode);
 		return -EINVAL;
 	}
 
 	return arm_smmu_cmdq_issue_cmdlist(
-		smmu, arm_smmu_get_cmdq(smmu, ent), cmd, 1, sync);
+		smmu, arm_smmu_get_cmdq(smmu, &cmd), cmd.data, 1, sync);
 }
 
 static int arm_smmu_cmdq_issue_cmd(struct arm_smmu_device *smmu,
@@ -948,42 +948,55 @@ static int arm_smmu_cmdq_issue_cmd_with_sync(struct arm_smmu_device *smmu,
 	return __arm_smmu_cmdq_issue_cmd(smmu, ent, true);
 }
 
+static void arm_smmu_cmdq_batch_init_cmd(struct arm_smmu_device *smmu,
+					 struct arm_smmu_cmdq_batch *cmds,
+					 struct arm_smmu_cmd *cmd)
+{
+	cmds->num = 0;
+	cmds->cmdq = arm_smmu_get_cmdq(smmu, cmd);
+}
+
 static void arm_smmu_cmdq_batch_init(struct arm_smmu_device *smmu,
 				     struct arm_smmu_cmdq_batch *cmds,
 				     struct arm_smmu_cmdq_ent *ent)
 {
-	cmds->num = 0;
-	cmds->cmdq = arm_smmu_get_cmdq(smmu, ent);
+	struct arm_smmu_cmd cmd;
+
+	arm_smmu_cmdq_build_cmd(cmd.data, ent);
+	arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 }
 
 static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
 				    struct arm_smmu_cmdq_batch *cmds,
-				    struct arm_smmu_cmdq_ent *cmd)
+				    struct arm_smmu_cmdq_ent *ent)
 {
-	bool unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
 	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
 			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
+	struct arm_smmu_cmd cmd;
+	bool unsupported_cmd;
 	int index;
 
+	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
+		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
+			 ent->opcode);
+		return;
+	}
+
+	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
 	if (force_sync || unsupported_cmd) {
 		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
 					    cmds->num, true);
-		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 	}
 
 	if (cmds->num == CMDQ_BATCH_ENTRIES) {
 		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
 					    cmds->num, false);
-		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
+		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
 	}
 
 	index = cmds->num * CMDQ_ENT_DWORDS;
-	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
-		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
-			 cmd->opcode);
-		return;
-	}
-
+	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
 	cmds->num++;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 092179f689e9f1..6d73f6b63e64a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -641,13 +641,13 @@ struct arm_smmu_cmdq {
 	atomic_long_t			*valid_map;
 	atomic_t			owner_prod;
 	atomic_t			lock;
-	bool				(*supports_cmd)(struct arm_smmu_cmdq_ent *ent);
+	bool				(*supports_cmd)(struct arm_smmu_cmd *cmd);
 };
 
 static inline bool arm_smmu_cmdq_supports_cmd(struct arm_smmu_cmdq *cmdq,
-					      struct arm_smmu_cmdq_ent *ent)
+					      struct arm_smmu_cmd *cmd)
 {
-	return cmdq->supports_cmd ? cmdq->supports_cmd(ent) : true;
+	return cmdq->supports_cmd ? cmdq->supports_cmd(cmd) : true;
 }
 
 struct arm_smmu_cmdq_batch {
@@ -815,7 +815,7 @@ struct arm_smmu_impl_ops {
 	void (*device_remove)(struct arm_smmu_device *smmu);
 	int (*init_structures)(struct arm_smmu_device *smmu);
 	struct arm_smmu_cmdq *(*get_secondary_cmdq)(
-		struct arm_smmu_device *smmu, struct arm_smmu_cmdq_ent *ent);
+		struct arm_smmu_device *smmu, struct arm_smmu_cmd *cmd);
 	/*
 	 * An implementation should define its own type other than the default
 	 * IOMMU_HW_INFO_TYPE_ARM_SMMUV3. And it must validate the input @type
diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 83f6e9f6c51d6b..b4d8c1f2fd3878 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -367,9 +367,9 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 
 /* Command Queue Function */
 
-static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
+static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmd *cmd)
 {
-	switch (ent->opcode) {
+	switch (FIELD_GET(CMDQ_0_OP, cmd->data[0])) {
 	case CMDQ_OP_TLBI_NH_ASID:
 	case CMDQ_OP_TLBI_NH_VA:
 	case CMDQ_OP_ATC_INV:
@@ -381,7 +381,7 @@ static bool tegra241_guest_vcmdq_supports_cmd(struct arm_smmu_cmdq_ent *ent)
 
 static struct arm_smmu_cmdq *
 tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
-			struct arm_smmu_cmdq_ent *ent)
+			struct arm_smmu_cmd *cmd)
 {
 	struct tegra241_cmdqv *cmdqv =
 		container_of(smmu, struct tegra241_cmdqv, smmu);
@@ -409,7 +409,7 @@ tegra241_cmdqv_get_cmdq(struct arm_smmu_device *smmu,
 		return NULL;
 
 	/* Unsupported CMD goes for smmu->cmdq pathway */
-	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, ent))
+	if (!arm_smmu_cmdq_supports_cmd(&vcmdq->cmdq, cmd))
 		return NULL;
 	return &vcmdq->cmdq;
 }
-- 
2.43.0

