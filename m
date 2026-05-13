Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F323CE0B1;
	Wed, 13 May 2026 23:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716684; cv=fail; b=qwu9CaP+GD9TWm7nRYsqYP6vXAshxCiCfW90aRDoolxPYDmuq2HpNCtKiRCo3l0VEPLiW1EWGBkwP28hY/rGX9CStRoD2en1M3SOfV5yhMx1g4N8kBNRo2Y3a0A7pC8asGDQxOSeFXJBTPpY95MIr0ISRpHMToOXe59kPQTsmqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716684; c=relaxed/simple;
	bh=88Du6f3oaE9BX8LfSyLbXmIUaRFFekPE6pSFIwQfsRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VFfOxvp2S076QYXs4xHWFLaTJyhkhe2dOhmGu2OjSQhOppO1Huh5sk7WTkAoz4ObA6QK5s5bse7oXsFGul1VA3VbnpRcbBMlp0yVlaq/qyNuqF8MOTKBb0rj5wO1Rfj1Ii6QaKQ7VLcHptZygTK3L192OSDB6TjFD6QCr5SVGyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YP0h7mVf; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YP0h7mVf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mk0XCif514ITocjYxQ9WQRlpX5L37tVJKhoSUVnmN1VWnMfcEaXctw4+aCxLGUYm79Rwi4FIvzru1eUANWdfvjmy4dxnUW4C4Se6XSdX8OJuMgWC4tvG/xDcBUo4zvDNLAHds5RB+dApgu62CcrF4vFsgh5nGpkpFsdoRGr1OEA3jhZ9gtPOnBQ4eSH3ar+iOXf9vG6xwKLko0VbMec5w34DbgyqPfUx0H5d0Qj8Fxze8MYdOZeyQp3OMkfIrIPYVCDnSaPi039Xn9THoSCCl0YYefZ/Av0fjdbhiyCi8xJhSWmb06mXti581UdxniZJYSHLPymwM6JzgICDeoh4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcSUDodWJURWun7QKLcFjXxajA5T9sQZZ15+Xc3SKtc=;
 b=gWKXDbOjZ7FGrnG6Ph9KPH7iFu6lUJb0ECNkSJZK5EaY7CfBnXwfRxRGOlzI1x09ZKmqUoZJbUfCHP1zBqV3Ds+NSEGRDcnoHxu+nCYdoTUpXe+ba68RXlWQTKJqyWDD7NnEcB9w9hx1NCmpDDR81E1S+f5W2K3zFKmPPEpt4d4DJyLJSARfaKqLH6gz4dmGfpMcApakzvMLJh9Wcg/GOCaEubIk3fo/CXK9cVFjYI4uYwWUnrxua7JduMf9IdaKETM0KnNbHcmCLEYwpC0h8819djZwI6S3i/jry7yNfufbCAqPhjBYhchFVVMo4pvWMYVBJIDZZSpmyOAKLhYecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcSUDodWJURWun7QKLcFjXxajA5T9sQZZ15+Xc3SKtc=;
 b=YP0h7mVf/xknOApZU/yi1MAp2V2BxHIRhXs/w7gNjQypdIksZL4UOGXrB9Esn53BPNX3tr/6HZ2bySQ0GQS/ZODEas4fJFtmaayrVr97iMHFBX07EnV30UJdPGpQGJXwHquWOtko5f28LX006McWCqshrBBDuEiqCBrDNxJlgH1W/ZI4JMU6d0tCkO605qzNsGHEwGkYTMoE99wR6X+B7ngA++jNLveodmSfpWDJgVqaOCV+To+aTJRCgD54XhKg5t+O4FEiCBSgoDxaYoFoHb0e3cWaccuFPmqcLsPVPXYkypRL6OrSZySKgat7tpi5kATRMbItncTZlCFXEnGNiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:54 +0000
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
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Date: Wed, 13 May 2026 20:57:46 -0300
Message-ID: <7-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0497.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: f921494d-41d2-495c-95f4-08deb14b7180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	+q9aUgvpLlbS1w6KNK0G8Fxc8iO0qHrIc2efY2xiOAjgOPzMmkxW96ZyzM44T7gJA+qI3Y50aPMswKKj4TDarGn75BmNvVZiT3S90gfI4eNIDnnjFxxlkoDa9WQmp0DKjXYuEFuI6kOOy+JOh8GxJeX4gnPXjA9MRR4TKTlbSeahXh89T6zzjY8y8W9fMv/c5SFKwF4HbsFXNUhjwWhvnV/R8qzrvDHOg5DAGRTw1HyP4pUVjTApSkXGSn8GMqXKivNT5CLkdWhQ2uNvaXNCbZg7GJf/B4n9ciGPPJ86VwWn7EPxZAOIEzsqBdgmS5BuShcm8O/L2ByxnSH/hQoA61XtSYMvrk9wNpbAknm2SmJsBak/cCkuSd535SzAhTUpNhqptLwb/ADzpCGSKlG3nkRujN9XuMGNR9j6K2mH5P3I+N5c7+7/FRcLV4AAqE178TWRNTQa7jTQZEHK1AuSqCC/4ZqJq7hhAABkdl2fYK9BWqPayRqlA6Md5cw+STBYa7U7AeC/8cWRQ78CNj6iZsykij59W8/ZGY8YDGXkHIhSsQLz/PTX1Jve9go1srHwT2hwYYvD7LVGwLDyhgz6YoF7JXoK1pEd24z4aG/gzmFRX5pPshBlk+af2Yg+gzYeMN0U/BnEC9BL4KVpBb/kb+tKAmwSrLdKwEVk3OIJNSHYkSOSDnD5EV0qOfJdLAuS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jhieVwjpLCzub2ZqEHJOe3VvEPn2VrEgWJg5/bSUgA7gcpFAH040uOSCwuyJ?=
 =?us-ascii?Q?eVo+iZ8iANeMPRyjLQYlVENydiNZaMaD87XxAkgS4a2v5NDBVjUmiezVFd1d?=
 =?us-ascii?Q?T1mFZiN/a2G2m+K8bJv4mb35CVbQlsM4fmMCjvutHbPIdVoO2nCwUxsDzCSh?=
 =?us-ascii?Q?hwCgYAJ5bbxafxYBFBockrh5Tx/EHLjQtccti+e+gxkXU3kL1z9OR00Fh2Wq?=
 =?us-ascii?Q?zwnOwbOXfa8ldWAfK83VuSwDLcJG37hBuht+NPz+xnJI3h9P4ns4uDPgz7fy?=
 =?us-ascii?Q?nOI7ntrO+Xi3jLazbfDM4IK338muvH/0Llf3uMe++khXm4vBhh0hkc7d4suj?=
 =?us-ascii?Q?iCsdKo2FNzLfPu3Vjm7kV9L8C0qYFx3LhWOYEgl5bOBlfAF1xvl4eo+AXtQt?=
 =?us-ascii?Q?HYZJljqm+rxSfYBtERDIFFwFkmcw8w9Fe6vPPGrI04sdECno1cEyQ+46R1I/?=
 =?us-ascii?Q?vDycgImoFNECJ2Aw+JpeCw/aKdwRH2ZAl7YnSZH6z0MbKhURZk8Tdp8Cl/JJ?=
 =?us-ascii?Q?tZEMUawcp6RdPKX9nUnpB3ZnmcX6rApY9vUMXHZp676z91Oy7n3VPuPQxGBA?=
 =?us-ascii?Q?CghplvYKg1pHSTy/eqZQK5oYUl3xseoC0llcW5ag6bzLyutK18wSZmhk+rS9?=
 =?us-ascii?Q?X3/lOcXBtWV1qPdx7hszQdXzFj2eEYmaL966LV4E7z7qZUH/WEzFd5n0BX8x?=
 =?us-ascii?Q?0Lk71C1UGA1nXhQYDk8w3GXCPcL4/hp2mlPQFRlpBG/qucGknMflpA6Mv3+7?=
 =?us-ascii?Q?XvzXVgf3f8RnNcobd1YL3J/BI5OTAbIKDunQ58pU7JaPMUw8om0VOrxN5aOT?=
 =?us-ascii?Q?OeVsFqV3CdzCjUkVtrEWABuCEHPs3BkrqpizN9YH4lFwTJ/T+y5ykvJPslhQ?=
 =?us-ascii?Q?CbOZgtkawA1h5SfQQrkyKE/Hgj2uoDrVdfUrQ9fxM/ublm7xxbnln7al2cm5?=
 =?us-ascii?Q?o6LzcW6ZAnQF+wXMGN/oBCoR+XpVGHXz8sZ8HgANZdBFW/3s9w9v7XgjCQ0Z?=
 =?us-ascii?Q?MD2tjn8suDPKKJ3WKxmZcbbxjBSM7bLsiTkmKRdT1yzS+/+slByEzhoKJ1zy?=
 =?us-ascii?Q?46T86JWcvqiZRbIQXkQOypz3ZN1rxoDQj+MS12XV6tCYat8UX7Tnd90r0u3I?=
 =?us-ascii?Q?sEiaDfNCXyPLAPZl5xn9zNUnpBmbvv7tzHkuksGGzU8jrqVYkp0xxuB7Ir5s?=
 =?us-ascii?Q?2Xks3H+sS9/SeZM7c2E7fQZDoNdY2LPJKLUbci9EgYW0C9pDzCaUzgtdSNBe?=
 =?us-ascii?Q?DCLI1bwrT8uzu8AOh+z5b8mo3z4ReZNZxcdBI0XQw/HKdyOEwXddwLKnBbFn?=
 =?us-ascii?Q?iwBf0o/HIZSu1u+07UMUzE8+OE25RdpsQUdaw38t5ekMNJNkcibMqbUhYNwc?=
 =?us-ascii?Q?oqctuP09bnBHW5tHPlyAvpBDnWbhRVMqqJNDBwv+V6qKp1Q8aFOyWnpRVxJn?=
 =?us-ascii?Q?ecwvM188sktShIvGCQ2WM729Mmy665lb2SaCvbY1pYCwNapgcyhn+NO6sfFr?=
 =?us-ascii?Q?6VUPGB39yfXNM6DwQ2Es5ADrpJU3GPKNmUQyzZkRVy/xFaQkB3eC+gmGS7NO?=
 =?us-ascii?Q?aAh1A0rfeFRMh+0OxqA6gD7ZjlgF6Yzo5xPLqBqPuyayPow3HpqHxVSHznYQ?=
 =?us-ascii?Q?/hphOqbwQU2wx/FeZghEcPW95aVdBaCBxR1Eu6qO5XVA1k0yFK4asxF3vrAu?=
 =?us-ascii?Q?a6EfVP1xXST2DUF9VHZCmSkjTsS2+h+HYV7qCi9UnsxV3/ki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f921494d-41d2-495c-95f4-08deb14b7180
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:52.3598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtjF9qJIJKFZ0LVlscANmpkNWGNGgQEtRjJWIlWwH09CLXaRLVjxXz9y3rGIFBNC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

Add a new command make function and convert all the places using
ATC_INV.

Split out full invalidation to directly make the cmd instead of
overloading size=0 to mean full invalidation.

In section "3.9.1 ATS Interface" of F.b the specification says:

  When the SMMU returns an ATS Translation Completion for a request that
  had a PASID, the Global bit of the Translation Completion Data Entry
  must be zero.

Even though it faithfully forwards the G bit through to the ATS
invalidation command there is no way to create G mappings so there is
never any need to send a G invalidation. Thus don't expose global in the
new helpers and leave CMDQ_ATC_0_GLOBAL unused.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
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

