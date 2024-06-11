Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572F803;
	Tue, 11 Jun 2024 00:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065886; cv=fail; b=dYdxePgmBBJ48JTtvDEmGNmt8yWXP6NbEpy18f0Lz+aUqiuT5Cr/UC1D2Gv6NeJEm1GC8qq7gyy0lVTcPYgYtiB8kvCeY0x2fsSJFBnmnBPtwnBzOOabU8txWa/eZ3LhzcRfjnZSwNk2PCMQjxorpDIdXnNwAVMQ7i1n1zCMSo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065886; c=relaxed/simple;
	bh=5tbZ4Dy3z7hUS/yFRg38bYyHaY8ck5okVpefXzNIP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VmQYn9JIhO5mtwfuIr03l/Q5hphAydUzkDQ/Zz8+uYYVoEj9xB5P/xMU+MWNmY3w6P/tEE5CiR8GUv0izDW+47IHxhfF2KKNvXiC2fNjslUotZZWvrqaarFtgfTCijyHTamVrUzLT+Kzmzn9rybKyaMtN+yiPEWU1Qun8f5lNRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NV7DoH94; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NV7DoH94"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ8MYglGTrb0v1dUtag20xzkX1UFWAZ4CMGosJCM/im/KYZ0FFAUOr7bsP7bZHnKgrdYlG6EBBq28zDOBngB2dtdy0VwqspQTJbImCJo5LUlXJ3cHMbni854NQv+/vzmWV+q8Ry/yz/sy9gN1m4qwIJoN3xnic1Hu4DbUl8IkWeU83qiawmPm8PlgYWfvsUyN7Vv+Icr/lH4GGxHvYPcFD7ZVrsS7n/ZujQ27FTHH49m05XGqBrJZm+CSsO8DdEWuDVI/N0Gw7w5y+vyRep7HYfwsQjNSGsApXFuIC+b0eBXXQvwnPsYfrMl/v8dw3UZSyp9y9SSWiCgzLM8e2jo2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsziEwBeQqdRiACut6k2MY6n6cUizIl3zTxvH4FcLbg=;
 b=Wdu1mmToY2fdTVt2K13qFRrFnCoL5iNbsrJohppc8DKVUrD2bgau58I4KwqE69qoZIeYrNOievNND1biWcnTFX7CfcT1Ab+XrWD4ZVWScHgR3ZWcpXdasSznazCzblbF89KiS4O+sFm0bD+8rnc/+kcGssPbre84eA8LUNCPq7gLz5NrbHBAjE6o5+EJtWSfw2rzt+ybknAiRXqrycxjoaV5VW0RAWBWvoRI1w5NQOEzeGgO46YOwyAWMpTGYRAJI5fyPbrp9XfXqy0OyD5u5BLnip8l9vrXUOJ5dHKpwVRVc/hYm9y7cF8RnaZWbT8Wqp06c9GLskno75CvdYFbKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsziEwBeQqdRiACut6k2MY6n6cUizIl3zTxvH4FcLbg=;
 b=NV7DoH94XDHzj5lNBVHlPhL3Fh+NInDsvT7tInHENSuP2Fwy3h9fTotNQQFoqZSGw0NoiW3OlU6J8rCv5OPh3dYJxqH9vDXp/252D9Ff11oBqInmO/50TZF+uroTbt22SdQxlz4Z1f0YVLm9bn9fOwPVKyXBd2CdMCn6urc7pThWIHe5chB6lmniz0K8OcdZba2ca0qFiA0LEIlZ8rETk5/JAiiC+q4iKt/MjcTtS32b4zkvdOjwxyVLUXPzpUrqf0iyOIv9n/mokzNOZhWaR/MF+T/LbMsWqxzsuyJTKVUKcYojhSo1BFu4D4QMtckHU8m/3TcrirYjWuXhTv1WvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:21 +0000
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
Subject: [PATCH v2 03/10] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
Date: Mon, 10 Jun 2024 21:31:12 -0300
Message-ID: <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:256::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 968d5e4c-bac9-4a74-b52a-08dc89add13d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EnP2evE/Llb7f71F2TzuUovMP8lnaLDFyxzFHpnidPZO045fb4oF7k90mJZh?=
 =?us-ascii?Q?Uvp/s+jmZZqyAVoT1wVEYjO7RahDao+K0NsnnbqIKZJ9jWUKmheUOPzTj1rA?=
 =?us-ascii?Q?D4djEFr6Zct4ea4eEEN+THcuwmOIDSTkEHet9R+ChffAN6NoQ4er7l5PvbTH?=
 =?us-ascii?Q?IsdhhxqwDMN5gRft6E74ObGNUDqXWnCs713WlXcUipoMq84HINmefrmlPSso?=
 =?us-ascii?Q?oTCVYkrBU3weisBk8KWQPH/F+pEwt3kWKfgRA3iawLcanSQQwhfnTtcE2P1K?=
 =?us-ascii?Q?OgI9bE5e6tyhKjeDzix5cYfDzSaQNKei07MnIAUbA8yx86erjPOFze0MFcoz?=
 =?us-ascii?Q?VXLUp5BFvR66V6xKOJ5K41tRCVL1biQzkulDYtn2eI4nmn2Rm3aKw710uXk3?=
 =?us-ascii?Q?PCFAkGnvgm1HqXrERpKbnpbQiM8lrMbq+BaoWQij4uF97NJp7Lj0k+cKarUu?=
 =?us-ascii?Q?hUYSfjgoVEGOxt+jbDdQ7gscHD3dkimm3eOtwsD5//wwT1C3CKyQiKwyjyq3?=
 =?us-ascii?Q?FpTpqiF+CfDxh2uq9vyn7UxC8UawlyjJnPxPiYJop2iBteT2BYD8N7Ni2smx?=
 =?us-ascii?Q?HKHufdkEFnioMQPOosrGqkcLJIGtVAocAaD1PGdrI/fm1R4p92ZilPHAWqqi?=
 =?us-ascii?Q?+s46JY+7KjhrlNJKK5hwRZv7fm4/rDxoF1xpW9z/6icqytfdx0EzlRD/2GQ4?=
 =?us-ascii?Q?NgkLQqjVpoE/nPemlPvX3DX2hpLHUEsNHE5Jp5JEDfiHB/HTO5txREFriU8F?=
 =?us-ascii?Q?/NUv8ISMVF/FQtWdpZRTH8CSYFvKnp+Mko6W9KP4XwsvZ89eIpakaXMF13yA?=
 =?us-ascii?Q?tQqmKeJKjqvBVf97+AZEE4+MXLwb8HDBk/KMV1Ni5yZCEmyflSG9voL/YY1c?=
 =?us-ascii?Q?yGZrJm0aM4iwE5ZEOF0z3Z6+BS/ZJB9H0KxVN4N3jMGf27iYZn8yY1HsgUI7?=
 =?us-ascii?Q?PN7RHB5faVaYHoNa3lJUGddDIw6VM5ISJOfrMVVeOX8NksaHQivCMsw7uho5?=
 =?us-ascii?Q?l8eSKIJpiIYXkmEE+LRmNLJSew3aqypy6UIgX4JcPMWj9Nc7y5kTKKZACdg8?=
 =?us-ascii?Q?uqMMdJLMn+PMLwYfvn1BJ8PZvDw+yjgKsb7BUya3dpaDguNMN566zvOdbNBX?=
 =?us-ascii?Q?T3D5MkZBxAYqc1ID9p4SdYmJL1yd8mExtyzgkdYyQ4akyTDZlZ39013VDwgg?=
 =?us-ascii?Q?wdCtsdsPKtBLNQVYlbDxdAqp7fgs61dNShbt7WJtG4CUII1SiyKlODe9uGuA?=
 =?us-ascii?Q?1DBf0sDLhjaZUiXkAIRWjaXQnsm7wHIwej3wVD5b3YqqYsNzBKHUszsTib3x?=
 =?us-ascii?Q?7uV46Nk7RmtY3PMqaKQ/dJAp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MOXOVMrsojwKmmaHmdu2UBPol1dTkhNP70a2mRfAobh5uuV+wBnamzhOXXVI?=
 =?us-ascii?Q?9QOqjHjO1SsedVHh7hyHhdvBGbZCvTALkIsEkz6TvmhY4zLqioEN+1lLQVxy?=
 =?us-ascii?Q?3yOkDWKSlKHO7we5Rc/RPAIMRBIzsTvUN+L3osClDE3iNomQeB3jvoQTz5BR?=
 =?us-ascii?Q?Ng1tfsvG+tIGDGl4zbJwZ/qidbDeRxjdn88Em65I/RrojafohaTg28uQbYOC?=
 =?us-ascii?Q?BVXJm53hIMSKIt2+gP4tuF6Zedi5bQK7JfcYBuFrHQ0lPRc76tZwYqCaex0+?=
 =?us-ascii?Q?tVX+L2GpfGAU6Cqf+Jfzo5226B2l2DKl/Unk7SuUiEskIDJo0/WYbL1GZ1zv?=
 =?us-ascii?Q?7A2I5EPJTYkAwFsC6OL/GCts1XxHdhORO7fYuvTXEDZ2SgP0VBV38qyGbbr+?=
 =?us-ascii?Q?dR4Am2D0lJ4z22bbgu0HT9WkUPox2s1jQ7Z10QEqaQGpXSIUYxB9VSiBMKg6?=
 =?us-ascii?Q?3uDz97dbDPfRDlAg76XY9gtCKvBLoZZ9skY2qQpb8vheWGdd0BZIOcpH//KS?=
 =?us-ascii?Q?QBqA7bRBMbFVTz/b45Oal73kqDJc3ntIjBb8jdeIky4sKB3n44DYufwLRSR8?=
 =?us-ascii?Q?ecd+v08yOPWx9DOCSIPWYIzTpTGdFqqyo4viXKwRj/RO5xgvtzp9M1uRjZms?=
 =?us-ascii?Q?p0DchmCfRtOUPKZnXDaNTYlU0gLa/H2BI4tXEiaGyMlB3Z8o09MeWnrxg+Hr?=
 =?us-ascii?Q?fw/EmajZS9nmXPaLLFMh5/17TfFWeIrS0aymF71uf/bNsIVx+4rWAY3DJaiu?=
 =?us-ascii?Q?T43AlQeC2wAoTFEymN+8Zs5wfMqhw68h2JZWrslqSbct3F63rf7v4M97+XLA?=
 =?us-ascii?Q?cwvJmD4SlWzExuLfyQ5KSZHqICFBI/4XfUi7lKCYmQZYqw/dcFLnX/fznmBq?=
 =?us-ascii?Q?0pbH2zI/xO8WXk6CUTSxs9FI032/0p9VvzpGJ78HKlq5TFsGLsy2s0ejiO3a?=
 =?us-ascii?Q?RLmDIVJMVlNb3mbDyKKS8Y0nuCTct2LYJ0YVKhvDuwnWspxWf8q3lbGWmBc1?=
 =?us-ascii?Q?EEXOeMsK2qFbNtVwvjpeNLVs6hOZX61CkCM9fuSazyLV7EeFUHHzrK7uFEDe?=
 =?us-ascii?Q?6jQGwLGUcjiSEFfdDy1IGSFDik3TUzcy7YwyMEw8XN1O1rCsd5jY4m2OBrvY?=
 =?us-ascii?Q?ebiUan+i15Zr2BX2t9R/bnduVFjVWoVK15mawG/+hhAoP+LQ5RNOtdXL1MaS?=
 =?us-ascii?Q?bGiUahJUO46R4UpxKQR/n03VJsEdpF4V/9FeAkw4SmRUdsEZsfUA5KsvcFO9?=
 =?us-ascii?Q?026XpJgOvZ4QFfxjl11NNXSx7sonZhkgF+eWB6vPWqoRwbO3EWBxrzlUX97n?=
 =?us-ascii?Q?PltQjDrhzSEICgOA1z71NTdD+THHfFFVkvypHsuuln+LgI7WtpgwUUFY0WYG?=
 =?us-ascii?Q?6PCCI10U0TtDbi4mk04GN0IvHy5GAv0xhLnUIY4nhLw6TfF7KRkA5zC+486/?=
 =?us-ascii?Q?18KEpuVJ4BNFzo6x1Z08MqNXSa2E9QE5DLodAI1mbLQNHzV9HkdMT1jr57+h?=
 =?us-ascii?Q?kPO/riFTXmFFofru4n+quJqtr0iW6ys3VnPBETel2q1aLBF3/4afTr3uHIYP?=
 =?us-ascii?Q?vsXuXd2emecmxYvtDH/6hQmpbxKm3mhuv8dR5kQO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 968d5e4c-bac9-4a74-b52a-08dc89add13d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14G5oMWRnfoP4lcYPGGonFK7sKzdn6RuIgTrZVMC4bMxj/uNqf6d2l3m6SEFW+ST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

Don't open code the calculations of the indexes for each level, provide
two functions to do that math and call them in all the places. Update all
the places computing indexes.

Calculate the L1 table size directly based on the max required index from
the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.

Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 53 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 14 +++++-
 2 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 95351c134c7c45..07b797ad832801 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1652,20 +1652,17 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
 
 static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
-	size_t size;
-	void *strtab;
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
+	struct arm_smmu_strtab_l1_desc *desc =
+		&cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
 
 	if (desc->l2ptr)
 		return 0;
 
-	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
-	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
-
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
-					  GFP_KERNEL);
+	desc->l2ptr = dmam_alloc_coherent(
+		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
+		&l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1673,8 +1670,9 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
-	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma);
+	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
+	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
+				      l2ptr_dma);
 	return 0;
 }
 
@@ -2411,12 +2409,9 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
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
@@ -2792,12 +2787,10 @@ struct arm_smmu_device *arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
 
 static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
-	unsigned long limit = smmu->strtab_cfg.num_l1_ents;
-
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		limit *= 1UL << STRTAB_SPLIT;
-
-	return sid < limit;
+		return arm_smmu_strtab_l1_idx(sid) <
+		       smmu->strtab_cfg.num_l1_ents;
+	return sid < smmu->strtab_cfg.num_l1_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3218,19 +3211,18 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
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
-			 "2-level strtab only covers %u/%u bits of SID\n",
-			 size, smmu->sid_bits);
+			 "2-level strtab only covers %u/%u of SIDs\n",
+			 cfg->num_l1_ents * STRTAB_NUM_L2_STES,
+			 1 << smmu->sid_bits);
 
 	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
@@ -3245,7 +3237,8 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
+	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+			  ilog2(cfg->num_l1_ents) + STRTAB_SPLIT);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 087733797f9087..95c3ac8613da79 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -199,7 +199,6 @@
  * 2lvl: 128k L1 entries,
  *       256 lazy entries per table (each table covers a PCI bus)
  */
-#define STRTAB_L1_SZ_SHIFT		20
 #define STRTAB_SPLIT			8
 
 #define STRTAB_L1_DESC_DWORDS		1
@@ -212,6 +211,19 @@ struct arm_smmu_ste {
 	__le64 data[STRTAB_STE_DWORDS];
 };
 
+#define STRTAB_NUM_L2_STES (1 << STRTAB_SPLIT)
+#define STRTAB_MAX_L1_ENTRIES (1 << 17)
+
+static inline unsigned int arm_smmu_strtab_l1_idx(unsigned int sid)
+{
+	return sid / STRTAB_NUM_L2_STES;
+}
+
+static inline unsigned int arm_smmu_strtab_l2_idx(unsigned int sid)
+{
+	return sid % STRTAB_NUM_L2_STES;
+}
+
 #define STRTAB_STE_0_V			(1UL << 0)
 #define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
 #define STRTAB_STE_0_CFG_ABORT		0
-- 
2.45.2

