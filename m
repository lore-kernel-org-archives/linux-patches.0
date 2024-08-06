Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E833612D;
	Tue,  6 Aug 2024 23:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987096; cv=fail; b=Ii9J9E1dddjr+yi5d4cu13AJCi5ejlFDA2hlDJ5fsDddFdYonknAemjkOJdI+uWiWAppBAgWSkmh54D+uyIV4sHIYRQtT4YKRHpYBuTjHn8UIB4ITqpfwGkR2IL90kA5s9mn6XJpZIzmkpc4Ew9u4ayCpsh22eeWFY++rPFfl8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987096; c=relaxed/simple;
	bh=bTk1pIHVPmRau0zqgZ76LjqtytcEa7CuJNhNyl864SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MTVYLymFBHP2TdZ8DFx6t0/bJzwu9v33oGrc8/QqJES1t9AFl7G00PoRQH/lYXpRPbs1nffHmqL1k2AQTYJHlBB7P2GDZqyy3oP/Ejzld5uwnXDYgqidRPl2c+tLoBaxK0vFUmHbBxZcdHo59PuksxYUiFIwjULCWNU+UnEMbLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SENN47By; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SENN47By"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuY3nz52TkJFLrH7QBsq+ZPP4QD71+8xpoEvW5WXexYD4PgRGPPPH7paJFCRDo7TDYRdBRQrSaiTmji6ZIyxV48HBa47eGQRaWaJUWoNt26ZuePHqPT4ZjFtxMWnau3Ewq2LnTNZ7flqdiBTj/tOUIpGuQtxT5T1Gt9t4SE87JZjVHHx7bP/R7R4Up6pJ4MuGPOuYLfvxf4vmBHNXsvacU64RLzKpMrJg8WJeAgaSZc/6ytiljtstSardmStKR8A/qeozY+O2d0RVXo39Ta/E4f1xNQHc8p8xxgZnAftG+Xq/x+cgjgVnz4U3h4Fwew2MDGijTWzDtPsyZHpgYbRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTIaufYQU3zDrM7K23leywVCts6C0HkFhyG20Z30FYE=;
 b=gMjldxlIFjSKKKkdqoNMN0/n9xDsZIaBECeEgTxUdileLy8ug5jHr6IQNQ2tnW4anONO8c/CTu2IU/kPL9nx3yO3Nsf52k5XJOSo/8s5hBUXgatGByF/9T37D7xmuZH9LKibm3mMaG2XOa/QbS3tFo98+/4nIMwboGkdjHma7KpbDMM60VWJQrXKQ4gphrUDyAFiTzHiebkuAUjNxwNUPtnLvnYu4oUT5kxVj0lnWsfb1q3NLZYNX6CyqFvNGh3HGuVOg8gLFGMTzbUZos9jXo1QxIHsPMVPYSKG+a1GHSyion1OYUr0zAWrTP+AcyWYVR1gIn1RBy3QZOC6lU/pwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTIaufYQU3zDrM7K23leywVCts6C0HkFhyG20Z30FYE=;
 b=SENN47ByIIowDz1xQlnaHVAUexaUC921lyvicCYf6gYYmR13CCydkUKUvmJ1th40jC5NtFk39ISQy4bBDozZGs92YPo+WLhl73mPOZPPe+qDYaz4mfUKBiVJ84OLy9m+ZbYvht2/RuZcCe1LL5uBMtuv90vwsVscNlbM5ClVyFR7vBRRivwf/w6O5jaT0iOKTgi7Jze07OLHfK/4ZtsKSDBFkH1mATZfrkaBXCxYMkgtGeJTds+KazLgirWxso1yEjc0DheIqFrA99qAAOR8VV7hyc+QjKEsaQqfEXbredtJ7cAM94wbTXeFv76OQFIoYgAFUJrpaEM2YluiSZY1cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:30 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:29 +0000
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
Subject: [PATCH v3 5/9] iommu/arm-smmu-v3: Remove strtab_base/cfg
Date: Tue,  6 Aug 2024 20:31:19 -0300
Message-ID: <5-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:408:d4::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 50748a40-0002-4e78-8d6c-08dcb66fe354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HxJ1ypotUlyVWeXGyx88YdKMR1sOVzVnp2yVHVvYRmSW9ordaFyQORGsqrTe?=
 =?us-ascii?Q?idDjEDNNbiC0+pniKseNVrxXoMZybPOfocBHTWP2ycKDhTzi2OUGjcdp0rKX?=
 =?us-ascii?Q?08og1AxuAhjFRQWrr4XcV9IVTGmm3t7eXBQGn8qj/tUf8+T8aTq/n01ck/nm?=
 =?us-ascii?Q?vAEXt86lbPPr3zUF/WF+vTff8uhEWjD1INCJaQmi7GAnhNRuqh8ER4OGELT0?=
 =?us-ascii?Q?IJSvQaNh8k+MMap9LrK/PDZPJWUQb76BBA6g00+Od/qoGXL2JrVScRzjws/H?=
 =?us-ascii?Q?FmRyhhD3D5XVTQmVWbQlBl/hftUUYXknNTTSges/ZzC6fHn/YvTGc5My6adU?=
 =?us-ascii?Q?HCkq6+o5nc+MkmeDU/LwK22mITaelDLJng2Q7MWa09TlfRFq3NvZAf3VY6NI?=
 =?us-ascii?Q?HLZpq5gx2sgHEDVnD8vgTTKxVfL+nAhjOMDqZaqOtBS6Lo43wIbHtsVpVsNY?=
 =?us-ascii?Q?Z5CbGYs5FeweJ3jZrgpdCYtP7AGyQTWfkRnOgocK32pcJsh07K1v5xkDFgZ0?=
 =?us-ascii?Q?qSs7Plvh03ZhQj+SSUPb8BIICbdawCZW2JaNrze6cz40VnWgm1Dg3ytPOPqT?=
 =?us-ascii?Q?43t2wa62f02nEdCkPhy0Vn2X61cUjuTXCup0wfDEWD+cxsZHVz/d50E0ypgs?=
 =?us-ascii?Q?lLxoPSRjcVhil2g89DjfP0hFsbagwac32iJu6eL3QJg/JEqZNF8Dwaa8N0JP?=
 =?us-ascii?Q?urB2xOsMMD7GjXrj16CL5trY35w3ERAONWPrzO8gIGcFS4cJqmnyMjkksCph?=
 =?us-ascii?Q?RMG53N8Ww5aG3i8xb5c45S48tti/Pu7nQY2R/aWg5tzyqgpCaXy8VS8E8U87?=
 =?us-ascii?Q?ZKMNx56H9FD+JEkpE/XOHLc4CCaPy6YN6VTmad/krSwIqNdGufkhyz4jQTn1?=
 =?us-ascii?Q?59dEHw1hDkRGEtWJoYFOCTZHmsEitmmLd3a3GqSdYzCgYm4oQiH7ZOnwBC+Z?=
 =?us-ascii?Q?3BORYETcU7oYwQ8CiIW1fEVRswNnd2mho1s1bO1OuEhlvFjCY0WbmMVxptFV?=
 =?us-ascii?Q?cxDd4yClxoUgFmBDuO8EE37eco3vR0cqLLSs7RvW7GzkGrOHiGWVmg+VJMZU?=
 =?us-ascii?Q?YXrnVTgwJhquD5uA3j8zbwy857wdR8VsiudelqPF6oxYFa8gbca6ub3pOY1g?=
 =?us-ascii?Q?mO4CG6hDw0JPcVE0pZdyyEDTqLknnnif8BKDxkP3r6YKsTl8Eyoasaz90Ikn?=
 =?us-ascii?Q?AqyWPGu4TsuDe4n/nUL08BetWx74XTzGbtkRozwZeoo9ov2pN9jdvIEl4HEm?=
 =?us-ascii?Q?wvMvpNokXGLgvd4yp48g64insySrAJzmzAUjszWig5q6xUnRqZCfHK/jd4Bj?=
 =?us-ascii?Q?h/phT1sdxWaymFXrUYY2p57qwB80zWnUFrRKMrK6QQoSeg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F0n4P87du42UMTsn7UXdp8edYF507PNnYB6xZhlDOBRumzHPEGZdklnkyu66?=
 =?us-ascii?Q?88CfOPSSoD13K+ZAw9DdUV7uJIv0FfJoSM88d4rmHcESXOpQEI3nwNoqXeu/?=
 =?us-ascii?Q?NGNd/f9c7uu1wTpo/AjjB7oebwDenJ/IoM11Gaeyfu9xgeZCdIfynIHsQom0?=
 =?us-ascii?Q?myhYDHWkoD7wJBMIiWEkqQif2R5gdOpWhrTfZWQ1rY9YOpG+rNHXcgJfaFFW?=
 =?us-ascii?Q?J+MsOW7k4V1wvAGgBKGOSLWwOAVEaeUxOXSdz9qb7yu6+yU11kbJeE7oSGkG?=
 =?us-ascii?Q?VruZm0DIjwSO3bJpx17KU9pSyEgIThcVFNPk7KK/bcnFKOg/bL4pdzHDepRI?=
 =?us-ascii?Q?gl3DiiWUzmfkAbQbzSkMIYOli/qro90xrCD5IsyjPRP/5ixCJqx5aTDbrLCG?=
 =?us-ascii?Q?qePW024hfo08ncviY8alLB6lUIo6plirjopcuL7L9U+VxbeuC6ht8ZcX1Zas?=
 =?us-ascii?Q?Kb2PS7OFhkJi2idEqfu5GRUnjku+rtNZYAGBIovhwjUI5/wS/NDLYfOyOcMn?=
 =?us-ascii?Q?JJi06+Tc38umryGtCrta+s846mEpxv682fm4GBWFUv6J1rMNhXgxQdfNq+ar?=
 =?us-ascii?Q?XznVwM3LekoHTaIYhGIbFURLm6Bd79Z1bllIf7RTrj+v6NkdFOpE+Q2W7HuA?=
 =?us-ascii?Q?u/ObiqTID4sG8fOww+t9DsmdAnqsl4aQfkt4Rc9lRcubAGDko5whqVIMnIOu?=
 =?us-ascii?Q?7fljTs6ckBrjcp9xwPR6wjHW4zEqXwtM0JXm+j2L+wTTB5ts+TMg3YDOUvuV?=
 =?us-ascii?Q?8du4DKGl9ECeB9TZUo5aRcPBOHLjR+mvFmvPzWAKFS2GuN4KQxCArYUtUgY8?=
 =?us-ascii?Q?WiQPF7W2VPdoVu5SlHaMar/ve4HlsK71mLMjILWa8pusJ7nVs353AkKTQHOu?=
 =?us-ascii?Q?nH6Cu2QVkyBKFBFtmVWV6di4Ui/iEJ60ic4PbMVF45Fep8TRXJY2HC9/q0Hd?=
 =?us-ascii?Q?qo8wqOzk1gY5Tx2S763HQuciQ3gPXPy3OSC2kAuS8+zXrRbfsMNMHp0JP8qi?=
 =?us-ascii?Q?IF3biiTy9K5n+/w+I9eqN8T/vSLYC9PB+/jZkjW95eWCnir/6GRSKdM5VaPn?=
 =?us-ascii?Q?kgMdUuZyl1KkWQxn5VY8xMBuSrAXXX9OE8fw8HHsBmlh7mwWycSDjmp50WfH?=
 =?us-ascii?Q?oJT0s5lWysWBP+CdHGJwL8XpjLzK4/j4P8btYhicktNmuLf0xYwxT4woQ93r?=
 =?us-ascii?Q?WGPsnFTjoBz0QXTVEqmfzrkiMINSTT2JWff4+5h9Kcp5MOancnqkuZx3KOYT?=
 =?us-ascii?Q?rYQqNg+3RpWiboVfxEWNkXf6E1uK+66TZCmNCivCSdG/T+g/iIYFG21cEgo4?=
 =?us-ascii?Q?zj+YXxh87aJX7W+jAZNQ9XaMQ7GNle8LS+IMhvGrBIBH9OGSC2B46IftDeci?=
 =?us-ascii?Q?D9RzFDHsNRoywK7bdb8LnJExL0iDE6+t8tJvJUW8UXlDxiABBFcX8nAPBKVX?=
 =?us-ascii?Q?s3MB/5CD04EfEXl+mhl3qIa+wL8kYRYr0kTvxj/I7D/qgOJEP9CXQldoJtZV?=
 =?us-ascii?Q?WYi6g66qLFVt2MpbuMFLKQixSo4TpEtYQe+GIrNrmLkGonPQdHelvPagJM+u?=
 =?us-ascii?Q?kOsPbV+jgb8824WZzlA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50748a40-0002-4e78-8d6c-08dcb66fe354
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.2211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ODLmSM556CjhHBD8//7WqUpjkHOWAYQkefmEq1YCYrGIikG0OiezPxDlOwZzj3A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

These values can be computed from the other values already stored in the
config. Move the calculation to arm_smmu_write_strtab() and do it directly
before writing the registers.

This moves all the logic to calculate the two registers into one function
from three and saves an unimportant 16 bytes from the arm_smmu_device.

Suggested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 55 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 -
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9b1f947102a554..95bd4a36268c00 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3593,7 +3593,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	unsigned int last_sid_idx =
@@ -3617,13 +3616,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 		return -ENOMEM;
 	}
 
-	/* Configure strtab_base_cfg for 2 levels */
-	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
-			  ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
-	cfg->strtab_base_cfg = reg;
-
 	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
 				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
 	if (!cfg->l2.l2ptrs)
@@ -3634,7 +3626,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
@@ -3649,34 +3640,21 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	}
 	cfg->linear.num_ents = 1 << smmu->sid_bits;
 
-	/* Configure strtab_base_cfg for a linear table covering all SIDs */
-	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
-	cfg->strtab_base_cfg = reg;
-
 	arm_smmu_init_initial_stes(cfg->linear.table, cfg->linear.num_ents);
 	return 0;
 }
 
 static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	int ret;
 
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
 		ret = arm_smmu_init_strtab_2lvl(smmu);
-		reg = smmu->strtab_cfg.l2.l1_dma & STRTAB_BASE_ADDR_MASK;
-	} else {
+	else
 		ret = arm_smmu_init_strtab_linear(smmu);
-		reg = smmu->strtab_cfg.linear.ste_dma & STRTAB_BASE_ADDR_MASK;
-	}
 	if (ret)
 		return ret;
 
-	/* Set the strtab base address */
-	reg |= STRTAB_BASE_RA;
-	smmu->strtab_cfg.strtab_base = reg;
-
 	ida_init(&smmu->vmid_map);
 
 	return 0;
@@ -3885,6 +3863,30 @@ static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
 	return ret;
 }
 
+static void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	dma_addr_t dma;
+	u32 reg;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_2LVL) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+				 ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT) |
+		      FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
+		dma = cfg->l2.l1_dma;
+	} else {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_LINEAR) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
+		dma = cfg->linear.ste_dma;
+	}
+	writeq_relaxed((dma & STRTAB_BASE_ADDR_MASK) | STRTAB_BASE_RA,
+		       smmu->base + ARM_SMMU_STRTAB_BASE);
+	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+}
+
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
@@ -3920,10 +3922,7 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	writel_relaxed(reg, smmu->base + ARM_SMMU_CR2);
 
 	/* Stream table */
-	writeq_relaxed(smmu->strtab_cfg.strtab_base,
-		       smmu->base + ARM_SMMU_STRTAB_BASE);
-	writel_relaxed(smmu->strtab_cfg.strtab_base_cfg,
-		       smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+	arm_smmu_write_strtab(smmu);
 
 	/* Command queue */
 	writeq_relaxed(smmu->cmdq.q.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 18e85fc936876b..be931616d9a27e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -645,8 +645,6 @@ struct arm_smmu_strtab_cfg {
 			unsigned int num_l1_ents;
 		} l2;
 	};
-	u64				strtab_base;
-	u32				strtab_base_cfg;
 };
 
 /* An SMMUv3 instance */
-- 
2.46.0

