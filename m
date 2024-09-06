Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9C11D2F67;
	Fri,  6 Sep 2024 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637690; cv=fail; b=dNmSfjtMp5M9o3k1YKPD7IFIRwPKsEVHbGITe/iex3ypq5s3a+Fm9hxULkzPYwUCwTul9z4oWcN33dN7DhB7kdQqvZcraiLY1TQpSnZ3R3l9LqGkhY9ce/ceyM7W18ZjClhc/VooCC9+FLQ3hoQdl2sgc1ByFkQgZ7F5mdClC0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637690; c=relaxed/simple;
	bh=Cz0/umqwt3bRkKJNRUfRehlNMNlkuePeQCkutQv+DgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cYEOU+9Zv5/LCkiSw+hiVFFsD26H67Rnl61N/zfnUb9+8goJI0uCJTVBNzM0I1hvYL3OfdN0cwQaaU0ycoEB+jFqBhoMt8x23kk5lcmbFAyDw4biwUL6yHT/2dld2jh9iF0YVyKcyr+0H22jn802Y1TTatjgvJFsWYOy5erU3JA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f4RLwiix; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f4RLwiix"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJROqgXhH6I2/VbHmIIsucYWWrCGWMtTk2d7sOcWj0vQIwPiu2oD6wh46vpIAM4ry0pXHX3HTUTLTJd2s0M+7vPKum9NERwpj9GMNLq8E43d5V4yn42xfXR+ANjMXOsDUM+p455vuAoGk41BYsFz2RXhXlZN/q+5Go421H6kx9JhhfCT/dWma3iUUL+FmuqeJdRuTEYRYDE9feSnFvAW9RoKCr90IPn1i+odip5G/M60WUEW0UEQvjRQaCvg+XoD7U/6mpzD7JhthDSR0IsnjEsQxxpY7oByyIhOPCJ5eaU2q3AMsdbW8iWFtdnLrZIE9ZO7OWi32y2hEO8rqFvzBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCqk3ZO4Em6iPBbO6sLuzgGRBH+FruDDU7FnWBte34c=;
 b=PAV+ATJRDwR425WbJOX4K+xEXSGdBdXsxJRDAvFJiLncJXOooX1kj3iRBrJOFgfnjxdmDn4tya6wlti9AkzwzWswtxMBG0kwRflBHhugA059i8sEuaV0U3MtA96kWKTBJtqxW71QSXj2LKF86AyCstE4DQ5i9u/qKMIjcD9hPeGKbxoQWBeQNgMYgQ8780RbDPq/zrYXN9z6s7z8zWYh+EjN7PB4ZUsR5yoaHHUCuhVuWAIMxq5c18pJtHunBj7UoGYvLgovFUyOYqfjsM14rJApOT5FfvmdZYotB/4BY2tpSlT0O0aPaI/JqteCmeS8WpGO0trt/onyvVzNtjn/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCqk3ZO4Em6iPBbO6sLuzgGRBH+FruDDU7FnWBte34c=;
 b=f4RLwiixmhusC86RYvcpChcj/poMduOnPiyZXEdMCZfXxIHS+Y0PoognIdQv+gqBjuljJFU+5dvjHRe193OszaHvMYrOjho87HXLDKrD8GW8yztPPIe9ZCJjsSmsB7T8GcFnVAOufqUQVWMY4OO4vlo34lmnD5sFDzsMgD/KHJaj/L3N4MRRHbTdASxKzCQA3K6goZZFkOXAck3EQdkaAd0M6IM/ympDDm8KiLQV13bm464jNXvQ1i8q2UZJBJGpJnVpEioO+yxGfqj7/OuLh1bo0DZR1ySArcRVdeQhWisdSYKLD2hjyg60WX1QSJR48i4qaScfb+bNjU5kI2UPRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:03 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:02 +0000
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
Subject: [PATCH v4 4/8] iommu/arm-smmu-v3: Remove strtab_base/cfg
Date: Fri,  6 Sep 2024 12:47:51 -0300
Message-ID: <4-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0375.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: ac82b2f7-a5e5-44e1-dd82-08dcce8b4713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lOjw9HaIYzYSC03aev6my0ycTl62PH/N+dziI/5raJRqwDcSm04beT2whTc?=
 =?us-ascii?Q?XCC1P5hYSlHCh7CEg/rIVwHjiRWmYGP8+fHUY4cfCgWX21ZdvIiDBTj+SOVW?=
 =?us-ascii?Q?oHKhZbVMHbtx6bO630rH3AJdnc2i2Wgl0TBcWSslmq2Px1mUWI3+W201ucn5?=
 =?us-ascii?Q?jsTnFio4YskJjzq0kXkv6QKoH+hvato/QcLJAHnK70YOeRtDUjZhluuwlLIC?=
 =?us-ascii?Q?ITyVralbzVdG4vpCf94fd/W5gwr0KmDiKEiuO8LaEEUxvp7iSDAj4my0pXlk?=
 =?us-ascii?Q?5ONcbzC5pHQMYXbeF0RyMi/X5Bd1BlYWHFdr0KFvqh2bIHU2rLsdqBfcp6O6?=
 =?us-ascii?Q?XRNelyoOCbHnBO1ubaJAktv3oXx2XS7PhvNv6ekFzqW6ZUBm9Tiq4Ph4CXtq?=
 =?us-ascii?Q?gtc1rpYpXyu77HJDd7GyUoTfrHFpupcjfm6m82SO2dvvEG9DVsKmt5Nt089M?=
 =?us-ascii?Q?+IYI7+/X2d6ZNJ8YmLae0IkEjhYetxE35OQ97e53DWwk0er73+OgTHVb5m/r?=
 =?us-ascii?Q?Oq2MZsqK4Ly2UbTtbsBnYb3v2K9GuBeszLjS1v0tqDjcw8g6HiH0lYTZjHqs?=
 =?us-ascii?Q?JSz5Y8rCjYYoPF+ZkXO0h5kd2k/AzlaLckiEPIjI7b2Tsqg3pPFlYxZmJVts?=
 =?us-ascii?Q?juTQK8XeuGiVlGDWkeIK1r45mzjV2v6imolxF/xTraHpZxlcdO8bCZy3HA8B?=
 =?us-ascii?Q?RQfoH+rIGxCAUJy/NHsnaTU6cfzlTc9b8kq+IcVvXBNKqCGtkggScF2zdczn?=
 =?us-ascii?Q?T2paoxaLet103ePuetC+5UCC8PxiG1hoL/BhbriGeaKPFzlhw8VmIVEDOCQy?=
 =?us-ascii?Q?J8NXurNLWNzZF36Cr/tEWW8LjHyATgom+1obezT/8glcETlRnBrpXM7w2uLg?=
 =?us-ascii?Q?WtVl1zEGXpkB/v5LiLfDttriD7fogRy9JYjREM5NS5WzCdnJfiC9IPAG+5JX?=
 =?us-ascii?Q?4DS3ffYGatOYTlmEmUb9kJF3UkCzauMnu99Go12vRjGgqNM83sPo++hk1gDc?=
 =?us-ascii?Q?ypbpzwMxPWa9lPHG4pHkXv+Wkn95Kz+ihSML0CqtQ8HsZ2B+e5V3IxowFNaA?=
 =?us-ascii?Q?ctfuFEirma1ev7IG4PaxBn58yI71hmwb5cy9PGStrm1o+GCmnD/Z2E68nQ/A?=
 =?us-ascii?Q?qeWqd1pVxhiH2vC0SiaNjA5w3xtQ89VLN33U2iXEA1IbnmrDUUNHeX26m7WT?=
 =?us-ascii?Q?fQrCjsKpvg5/m58ZiOT4/l4ZDPmQiEK2Kxz7ewEBy51lf5hkkFzBp94J+5qR?=
 =?us-ascii?Q?XKessouDJpq37JQXFoO0nDjLsg8XgidlF6Q2f0diDjrK8YXibNLl3oN2O8gg?=
 =?us-ascii?Q?gfgjk5C0TnXlc/mHuENAjE4FtFBCPsFtmNt0eVTDB4CBfw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEjvgsXSPBMUdWSowhOuJTVy5PRaguD1I22d+Odz0gnCvogCB4rIiTYWx1SS?=
 =?us-ascii?Q?KmQ/M195mO6GVF5mzHQZroDJvbf6E5ekSxVcPFPvp7isUEOJRFVb9WTdiOed?=
 =?us-ascii?Q?W8pjGVO/v21d7lArpXpDuux4fIXT+rXeniQCdgDN8ZYJMOTo/CG98oFuxxzo?=
 =?us-ascii?Q?6wGjedX/TeyjcWF0LTImqGV0MhcsM1t01kIM62vS5BL5Ikpvl9t21/euOPtG?=
 =?us-ascii?Q?l23zFfjicBKBJM+1B1vGIeEx9aeRbufVwF9UUZvUVEMqYepKoySG16wNd1eS?=
 =?us-ascii?Q?n08T9Pjr1+OiVICXcLFuMw0y7uonR3WnRT6orPQunT3XQ7MJldUrGL22ls3h?=
 =?us-ascii?Q?d5oldC4XTkTOtEMZHQZr5KTsVGcR1mhCMPP/WY2pUSCYZRcdC/lr3HqUNIMI?=
 =?us-ascii?Q?VngVl92IGm7TatAhFna/z7wHiLRXNbA39oWwSnVBr+BEymT4WWtmKLAbjtgr?=
 =?us-ascii?Q?VgC+lHCl9vsbPvF0DsDhwHM2xi70cTfev9FUyVuMhtsVbWpqjV9QuQB+XJXz?=
 =?us-ascii?Q?OC3sdJPFICyJjxk61IWZR1fPGioNAzMI6FPY1dJs7QUVg4h+H3yGho5sA/S7?=
 =?us-ascii?Q?PFZhc1V4SFx61vwtnoHlnDk+FjvypBHwriwutj/iauY7nXUMqLhnw4575xvh?=
 =?us-ascii?Q?G+4g+K00bQxFQdcUkwvlAWBRQEnXdobfDMUmU026jpA3xAQXFWYjDtief4wp?=
 =?us-ascii?Q?3bvIMn7zF3q3xcKeWCuIvJGpAEvgV5dRgzDiokbEkNjR3FH9weKwMC/l8dw8?=
 =?us-ascii?Q?Z7vZrJzHTNwNA7ZP7/6JVB4PuBbC9cFcjjbIjf40Fp0fKfStVAgrqOV85h8D?=
 =?us-ascii?Q?Jz8p4uFHbSCgxWfw8SFD/MirUhI7JayC3vmzRBHOrHjVwlywzaBzasnG6W6m?=
 =?us-ascii?Q?5dCdFGsjidQ5s4ov+72KliDRnHL0WqfRZ3ratsQIHMYykrJHd0iMacseU4fa?=
 =?us-ascii?Q?HK+Pw27ZOD63sQk5UwUYPEp10PuGMwIvK0k9HYcFl4DHW+m+/qJMKzIMdrrj?=
 =?us-ascii?Q?xlluHXYjHILKWV0Yr8X67vFlpsJpsDSyU7uEVK9V6JmJkFf7++PbDguH5Cuy?=
 =?us-ascii?Q?y75Gbe79jbUWjqsQKU/e2aCjGpL2wGLn/KMVhecmUrT3YVwsxBJG5baStpsT?=
 =?us-ascii?Q?WBbeGEypn1lNPWyt+aC4pA1OFP1HLMhaZ7Vpd6HF1jr4cMN5p0IwWgiHwIAm?=
 =?us-ascii?Q?wrGSTPNen3uh2s7jvZsXgvyxe+2lyR3DYpV0ol7Kt7x10sRIkCipxGEXaMZ7?=
 =?us-ascii?Q?jFUX31fu/Zs71N+eic/laJ21NzUwl5BhlMAuxAc0M/tfXNZJf1EgGiFETiBL?=
 =?us-ascii?Q?TWb2sqdHQHvXxYz70Ss9unuAGPLTMnWo4enFIZhHDLxrORlL5KED+gR3Mvnj?=
 =?us-ascii?Q?au6+CxPHowRHbuyZIf15A1I4sYECroLnOTvK/TGkNN3sHY9M8IZsKV2DXuji?=
 =?us-ascii?Q?DfgJYX3A0eBJwCjLHW5QsdsT6ZiGdq+BqzlnpVKBswkUegiSHToDGi8ZpCXu?=
 =?us-ascii?Q?AtJfEFbpiNifqmXHpZDTEhvqFQrt1XYHWdoQGx2K00qwrafIlZgKkFOHQWnn?=
 =?us-ascii?Q?AjZqgMOMzVDquwZTDQc987l7oS9QTVxkLnS3FUgz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac82b2f7-a5e5-44e1-dd82-08dcce8b4713
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:56.9312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJKuzmheO3Tf/oKd8HLAMV+FC6rE9W51T7VxyZ5G26HjMkqqPVOCvT+0ktM8UQHd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

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
index 336803fb1f895e..bb6c556995a7a7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3627,7 +3627,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	unsigned int last_sid_idx =
@@ -3651,13 +3650,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
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
@@ -3668,7 +3660,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
@@ -3684,34 +3675,21 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
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
@@ -3927,6 +3905,30 @@ static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
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
@@ -3962,10 +3964,7 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
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
index 23918a547cbbce..33a8bee1b82e3b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -658,8 +658,6 @@ struct arm_smmu_strtab_cfg {
 			unsigned int num_l1_ents;
 		} l2;
 	};
-	u64				strtab_base;
-	u32				strtab_base_cfg;
 };
 
 struct arm_smmu_impl_ops {
-- 
2.46.0

