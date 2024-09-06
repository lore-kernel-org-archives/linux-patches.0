Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1F41CBE83;
	Fri,  6 Sep 2024 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637693; cv=fail; b=IY2tCdiXmcEAIZiBPeeQKSIE+Hhu1EvVtOb0hOLv9j5jL60oULwHOyLGvOZwaUswlHrg+KIbBh+QLdnghwUi2IqDWbA/mK1oYDtJ4M32e9yqkmRXQNErKBasKwh6hhrwGCsruzmUfaMwI3ZQn7o8MsuBNTDcTGwgkQ6kYh0lQEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637693; c=relaxed/simple;
	bh=opB47MNZiDxR9uN1WiAhqS/+tJqiCbWIEvpOofYsa4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q7IaysjM1nnybg4XGQGgEQL3e2jXinxSjyfdVC623GCkFzSvrmi9ibJG2F9+8VG3ASOy50Z059RDwJ9+OWbgls0ie88hZx0Hboe1bmqdAsAW7dXHOklszjOhNcUnkkro1lhOwiUStGq5KzHHvsEbiDKXC8vvqQkQvc1okHiM+XQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WFw2KMd/; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WFw2KMd/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RUJSZsr+LtbTZvU88QGIZ4yuuvCt8hcD9PDNwGFnJ2+Kael0PYv2Hjn/rW+CxLb0mFLgFlZc6qViyQZlAg8b7wUJwIBIR73CI3LyICVXPS67V8eZkBoBo8jeMSuBWGnW0x0ERRPNZDAWvmhhrPogTfkmFkeOIKebqkmpps8oDn+dnX3ytlbAuvSQclp6f/vXaI7emTFaWbNmdtmE+wmWWp3z7mT4RFy737ZNwYab+gkoQcK8/qDk7gd2QPdVITciRLaycvBdHkimk1ERDrQNAAvVasWEoil8rE+vMu9egtMM1omSOX5dVg6PCzvFGrLFmAVo44BsdmQWXnjlR3qWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McuXPTXyQ5FRCyBye6+FrLNwEcFfYllq2gUqemMhrVI=;
 b=r/0Tz2bfS9VMXrQSPCHUOCBnDz5BpwS3w91SIVVBn4wKMOdGX0d4SUSgUmdeLcQadF+veePkivAB79Vfdg5SSQJVyD/pK7NE/P4c4tl/dYYwenp9JLlje53tw2iuoxaff9yL49/vBo+0Uu4hqnj9cGTgRELyDEiSw1H+Lf06UgrIC9/fvoZ+cziR1BKVpWWL6ZdTQ1FTMrdsCjJaVo/cVA8//b31B7Lfo4g2gG7L7/kLfm4CvrZ0zZgXwZjNIMuFVY1urfMljWWZWWn8+eJ7JnVQQWQNlBQTsjT6q3oCljlEQB6T9paNlqP1ibs20/79PcZUaxEST3TNCZQor4wqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McuXPTXyQ5FRCyBye6+FrLNwEcFfYllq2gUqemMhrVI=;
 b=WFw2KMd/UAI4GyMwG79KXfUnJi58zaJ3wYPWm4K5KSOeUy6x07MbXlE1QRgpWNrlLP7+Q2bdwNSadpXFT2FytEHA0xV+XkCXS0NUY1yPTOP50oTtDtL5nC5va5wPo89h0An24zY2CZSGsMoQJuhYRRLUo9DOkJ13Dck9VdoC2tv8Hi4/+zfChb7G2t3Mzj6sY+ebCg+HyW0tRY9yVvlEfzl7tXZ5gcJEJgzcjycyudMzJM0n8smi2JYq8GHO0VtcXHL+s5UmFOOSEDH8dmnzjaNYLVm90l/q81fgW1fJZoCjU5/kh5DCbTmdda7PeEl2Do7Ps0xPy5TaMQZqivC3zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:04 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:04 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 1/8] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
Date: Fri,  6 Sep 2024 12:47:48 -0300
Message-ID: <1-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:208:23e::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: efa3b6d3-ccf2-4aa5-b3f9-08dcce8b473d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0bqzAdE7yTllDuZaLyogp8hCQzGLW8p5O7o1CDEEQ+bXg5FpDDj5cOm0LceN?=
 =?us-ascii?Q?x0pPzMSywyicrJtVRQ844sZLjY7HrvH9wRvrCrHHKVsjn/bp2QcbNT8Th1DZ?=
 =?us-ascii?Q?hhKmiRiObnlUsD/4YbNkYRBeSL1jVG0w7QeWwwLJ5+q3rbLsmHA6PhykV8Hk?=
 =?us-ascii?Q?BSm0ixxi1JE5kl0gEq38DSM57+zsBm8DzStlO7Y32hqR/oJxlAgHwrvo9amf?=
 =?us-ascii?Q?rCk8eII5/czcO8cfLbwhxvi3s5beoxqv56QFJqQn5dWAQ6Dy/SE6OZWtrk+2?=
 =?us-ascii?Q?5EVpIlPZPl5AXmmX2CxeRB31/ak0bBS9nUe5x2aLBSNFfRCCUBahhlS6cghI?=
 =?us-ascii?Q?/lhYrqq2F1NzUnSSTj3AdmNHI8igFYBpEJ5lm4l5i8MoHqNPDFKaJGue5dXA?=
 =?us-ascii?Q?ibFxNmtPQLwTrlmwi2FVhaZr21FSAkCW3bxmhpvaceNDHxeGZry/Jxg04MaJ?=
 =?us-ascii?Q?Vu8kEC3vyNoLx/46EA9sHLpRxXfFa0rbAaySaNyVNYhJKqO5mkoR/U5kcK/o?=
 =?us-ascii?Q?gHtiCgX4PGSROG3gvGK9lX3PtdDKsETIdAz0NhRX0dkyKj1IR0iC0tlUn6EX?=
 =?us-ascii?Q?WP+sgMKh8DSOd0jYgB883Dkggjnae2Bxi6tbE7LbqJQeGn58FB0428jkU7VA?=
 =?us-ascii?Q?FLaJv3uzhfrUM5t1MB0iGjII2oEDWJOGqEqqfEWaK1AbWYpxFKYRr9O1hiM/?=
 =?us-ascii?Q?95guXzVsHIgUkEfs2NRb2YXWtoE/o3LXFe+92Rz0ryQmLoJRbKDlfk142XhM?=
 =?us-ascii?Q?ncT2MvdWbBZzA8OgaYl9QUwyLSTLVUa+gJgQFEval8YNDSlij7UbHj03JATn?=
 =?us-ascii?Q?cH4rkThS00bRVCi8Zrhj8MyrXCPrjekLtifPtywboHWUNs+61WYKVNch1okn?=
 =?us-ascii?Q?+CWkK0JV7wCKiYKW3gZtRXQgnfFaT3kaKmEGiHjTYCMtgY47N50FCKC50Pjr?=
 =?us-ascii?Q?rv+9xepqRLS+LLCZqUPLPzoZWT7SOjjwA25rtcVSjaAYpJd0CTZeNhrfb3Dv?=
 =?us-ascii?Q?PPjwTe5zdgaQ8OL1PNepC/8XOFNe6+R7P9NCre4AgCIjowsxW1V5vmPDRzbq?=
 =?us-ascii?Q?I9+RLeIjG1FDYOj/e+MoR1BvtviVmX2kMleNGgiU9kC1tlN16D4PsdVwIalF?=
 =?us-ascii?Q?1tKrM+u3BiJTU3E4UvbmaVSFfMFCfoMzMdt8vw1UluQ8JuoLCTr2PRD510Nl?=
 =?us-ascii?Q?1FPfXcovZWgxV7rBGtvJhoFAg1bt6uQKnoXbe1gokcDsVwvnyVxjS05VTtvh?=
 =?us-ascii?Q?n3Guo9iw9+VuhYFiH1X85yWQrJ74GoHUOaWyWsDQTYti2KFyZyxkAWjbJIRu?=
 =?us-ascii?Q?8BskJUzECt7hw3KLtdUJUvLXghhiP5TX+XKjHFrhhONUeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wHQHNgJRtRJ3VNsKAGGKp7Z8klMXL0FSbL1WaVj3N6yOgErBaq/DtlHOm6kF?=
 =?us-ascii?Q?SCu5qzTmFL08AlQE1hnd/Hkt6UySbWCARwny8yVVIuN2YHKVPO5sEr+36XZc?=
 =?us-ascii?Q?8EULrkNBT4ayf3nCoEio6lJE25lU/TPI/Zu/ItgBsy0e6iGbxTgWwJhOIOB8?=
 =?us-ascii?Q?vx8rYB5idvrb8IQXMa30kfH1Od4hy8DC/J5woRC4xfZ7dB+5Q622cThfygUL?=
 =?us-ascii?Q?NNK6Izn7FhBtYkoqrl8HPjhhYHNbvhqWEQ7hbwrV5a6dwr1LFcxy6ul0KkAw?=
 =?us-ascii?Q?D83xv6ZbKXGUAm1QhSTrKG2xYS5r1+IOTLoAgPT3L5guz9jSThCKzs9e+Ixd?=
 =?us-ascii?Q?IU6mxW3CEBKrLkuid4jJQTDzNpMyv68tUaMvnQ8P/rpQGxoj4JfN2RRt+niA?=
 =?us-ascii?Q?MpBT5Ag8Sz4Ypz7ei3XxUK3hC8WFEmLReqe0zurnUq1im8zAOWN0VJSSIzGQ?=
 =?us-ascii?Q?+tg2FtsOVwZRGcTUftfhT1sOIxCzIB1HEqzcbyPIFJLcJX4ACYyhQw6przJV?=
 =?us-ascii?Q?WpXg10hKgvHeWPVomAzTKt7QgVyK5Vu7Tj2KsejUY4aE63hKRXFmQBi/gztr?=
 =?us-ascii?Q?zfGDcXZbvuasP6EhobJ4ZOq9kp+/jfveysh5a3/z5e8lHzBb7dwmSXo/4pCg?=
 =?us-ascii?Q?WY57Wr2JGcwDXmeesRB8agfLGewZa6EVB1j8W/wRrfqeqB8TH3VffKUiDIZm?=
 =?us-ascii?Q?q+3x2G+zI8YZJRusE1y50TlfvUTnSYFoEc6q8eTy/pVWJUtrbI+7rwsuAeju?=
 =?us-ascii?Q?nk5HgMoJVKvCeP3iA9Dg/KDAcPl3PrFvzMBfdSedW5Qx8hw116ZDMjmwETp3?=
 =?us-ascii?Q?fHxf2hvWp7N5WT1O6zZHYA7LaWRmXWMt4klaw3b7+WFkofxaU/5FaSE64DgV?=
 =?us-ascii?Q?m3med5f5gXyGHtXZgAF/0PjuDIofOO5JPj9CIPNB4CnkDo+WQu95MuoMxuxZ?=
 =?us-ascii?Q?m4B4+Sol8C5vjCQbniLz6p2mNsuKr5DNuASbnBIwXBkaXOYRY9I8bsVdqr3b?=
 =?us-ascii?Q?SArGF6nywlNMFKxgNBXvQy08yAy+SqDB+S2eHuU0WsB26aLtkz7G8YK8Wpt3?=
 =?us-ascii?Q?cbMteDQ9FyZwiSM6UEOwTjzqBH/aSPwD2Hte+mahde8O+WJlebTLUZd8WxOz?=
 =?us-ascii?Q?JSwmwkNoNI7ODZs33FfVDQA6nIboyqw8yjh9N7WopHB11TjgPk/ppeo2/6Nx?=
 =?us-ascii?Q?NbL2L2V+ff/u4nHtrTpgjed5oNHWEFmVAg/G390d0dWjSEUHjueCz6nz0A0W?=
 =?us-ascii?Q?1/fT6sYlq5BCsh5ebp08k1trfzyI1l6ZVE7IOp5BLhPxQzvrFTwRLgWOJ51t?=
 =?us-ascii?Q?95qZCHDuY5vvqeuqpJeUA4D4NTXHAdwcBPBd7mVcuqVdIDEDbc7ZpL9ee2m+?=
 =?us-ascii?Q?9WXNx6UabQNM0JE8rG9rv5cpI7DtfLVChSP0OriMFn20IX74d6C2xJ3qwxB8?=
 =?us-ascii?Q?oXWjp+HB+EDfK73B7dzhzKWAS96rgrTfOtaZDfEoY4aXIvIKk1y0fAaDmj1z?=
 =?us-ascii?Q?97EOQi1BdVwVB/8+6hrS+rYv1qU14h5zV3Bfuh7gFjA5heSGFQLAZFFVvl18?=
 =?us-ascii?Q?zh/R5MOqr5PDOCj5NbC84AmoYulYzbW5vlTykz3Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa3b6d3-ccf2-4aa5-b3f9-08dcce8b473d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:57.1836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlbYewllSp0TfeBTgRKKHi1/dhDNXA7p2cVVZO0BcVGTloaBWAiMjOhCMpnC1Bkj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

Don't open code the calculations of the indexes for each level, provide
two functions to do that math and call them in all the places. Update all
the places computing indexes.

Calculate the L1 table size directly based on the max required index from
the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.

Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 14 ++++++-
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fb8b71b02d96a8..cdf146bad5bd24 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1710,17 +1710,15 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
 static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	size_t size;
-	void *strtab;
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
+	struct arm_smmu_strtab_l1_desc *desc;
 
+	desc = &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
 	if (desc->l2ptr)
 		return 0;
 
-	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
-	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
-
+	size = STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste);
 	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
 					  GFP_KERNEL);
 	if (!desc->l2ptr) {
@@ -1730,8 +1728,9 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
-	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma);
+	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
+	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
+				      l2ptr_dma);
 	return 0;
 }
 
@@ -2486,12 +2485,9 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
-		unsigned int idx1, idx2;
-
 		/* Two-level walk */
-		idx1 = (sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS;
-		idx2 = sid & ((1 << STRTAB_SPLIT) - 1);
-		return &cfg->l1_desc[idx1].l2ptr[idx2];
+		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
+				.l2ptr[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
 		return (struct arm_smmu_ste *)&cfg
@@ -3195,12 +3191,9 @@ struct arm_smmu_device *arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
 
 static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
-	unsigned long limit = smmu->strtab_cfg.num_l1_ents;
-
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		limit *= 1UL << STRTAB_SPLIT;
-
-	return sid < limit;
+		return arm_smmu_strtab_l1_idx(sid) < smmu->strtab_cfg.num_l1_ents;
+	return sid < smmu->strtab_cfg.num_l1_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3637,19 +3630,18 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
 	void *strtab;
 	u64 reg;
-	u32 size, l1size;
+	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	unsigned int last_sid_idx =
+		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
-	size = STRTAB_L1_SZ_SHIFT - (ilog2(STRTAB_L1_DESC_DWORDS) + 3);
-	size = min(size, smmu->sid_bits - STRTAB_SPLIT);
-	cfg->num_l1_ents = 1 << size;
-
-	size += STRTAB_SPLIT;
-	if (size < smmu->sid_bits)
+	cfg->num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->num_l1_ents <= last_sid_idx)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u bits of SID\n",
-			 size, smmu->sid_bits);
+			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
+			 smmu->sid_bits);
 
 	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
@@ -3664,7 +3656,8 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
+	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+			  ilog2(cfg->num_l1_ents) + STRTAB_SPLIT);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e8320e9341d70f..7d8ed274af40e5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -204,7 +204,6 @@ struct arm_smmu_device;
  * 2lvl: 128k L1 entries,
  *       256 lazy entries per table (each table covers a PCI bus)
  */
-#define STRTAB_L1_SZ_SHIFT		20
 #define STRTAB_SPLIT			8
 
 #define STRTAB_L1_DESC_DWORDS		1
@@ -217,6 +216,19 @@ struct arm_smmu_ste {
 	__le64 data[STRTAB_STE_DWORDS];
 };
 
+#define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
+#define STRTAB_MAX_L1_ENTRIES		(1 << 17)
+
+static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
+{
+	return sid / STRTAB_NUM_L2_STES;
+}
+
+static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
+{
+	return sid % STRTAB_NUM_L2_STES;
+}
+
 #define STRTAB_STE_0_V			(1UL << 0)
 #define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
 #define STRTAB_STE_0_CFG_ABORT		0
-- 
2.46.0

