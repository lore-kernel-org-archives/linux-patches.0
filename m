Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BC217FF;
	Tue, 11 Jun 2024 00:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065888; cv=fail; b=ugZj2fvtF7XAv/Ie1x2M4zut9fDlqHN+UMTq6k9jwVff9XAumKTFawtjlCHMTWQHhoeBIxe5B0jdzsn1/TPqqx8i555Rg3bgDteAa3fW813f2tcmr8hU9Pu1lF8GJY3UfNFa4ahwOYJRfa+ko1110LwitDzcZtuDT+Vqe/8NyVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065888; c=relaxed/simple;
	bh=T5STX6DkH62xcUde+md8L2jNePUFxp4xogpi1WssK4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LeumiL0XlpNexs3EydN/DEV3DdH7awHBMP9NubaHeeKYCzwmyHfwqdSxD9oxSOg76Rkg6s+CZOvpFFed9s/0mlcNOC9EGb9glRitUtZQL6XE7uVy1wbaeSoOGdZIWBCFqwb5vPoXfQPFV8fp0ARQ93+ekk0IvwMqu7Te6UCPzmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gjSwGUMv; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gjSwGUMv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtibeu8Nu7C42YsEqKBLMHnxGbNQuMDy1RauwpbqxHDnG66ebLRGncVHSzJiUyXIVv8Wm4pPI+VCpq2dGEzoj3nf7vUvzfzDazaMEctyp1xEoJZlAX6FFwJ3j2J31l6CcBGFCv5+2RWWtLCZ8TD3X3yLG4+aCPvpTRH09hvpCInsDXAm0GR41MuetkmrSWmN0kaZFM71sp9QWmvpRvmj0fvMk2NK8psmF28I233/MVFiCrZdWOirHZVbKwbkdAzvo11OzPfouUygWZQ15EKbQSt16wd6MCcjkZztq98eQuTL6E2klriw8YLeEWCNxSn3PVt3hXawJJkXnCiA0AiGxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wicn8xpR+3lz8Lwtw6mtwa1S5KQEjSdyhRq590rrAw=;
 b=Ji/+2ttlfBU0bLGbLfC0o8A6hXjZO+49V/7OujSOMGjGkSHxWOvW4elSYhKdYkJc8RzYcx9ZKrctuoH/JlYdhl82oBOuRf5rrL9MN3ARqjER8DVEo3O5cUAzd3alu70MPjB/5sDioTw5RNDlYLTQX/XsYVwBemOPwlXuY6HnpXlXq/1zF6t/3woxsv6Scx/RvFl+VThI+tfcdECBof/Z8KkPpuRksVVZt/+0LqxiUSk8mGF8Sw46hQe8mFrDi9vSjk7jfpRdB6dSa4qNI1HTngCqhYK8Pp4gJ4Otn2Enm5MxKUbWExUgAemJRKwAKB/b8Encp2uD9Gann3MAZebGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wicn8xpR+3lz8Lwtw6mtwa1S5KQEjSdyhRq590rrAw=;
 b=gjSwGUMvGOccspGbFjwoiUJXi9lkjePMZ03G73UCjfUFoLvC7WBYky0gOjcsIBuWkHmpRCrKvJYcVHL4d4GeIlXuMDDFOlC2EQSHl2MGoTYb01xUtbG4MWF5LrqpF5nkHEl7XTc5GZTwAVienyCTJUcssSQgVovPY/8vAhSkHRl80P4pvti6nWd8gXqUgtv8MWRHoPwvdt8v7LNMbsmUFokXotkXElGl7Y8Jq8vRcoFqKzeFuLPs5nURlgaI/HGjm2EOdwBlQc2sQDeFncCjiafFp2T8haWBMQ3CjnndXe96EeJEPlpG6KiI/t9K4YY6+IwIGqi1b+hWyC6CZVvmGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:22 +0000
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
Subject: [PATCH v2 02/10] iommu/arm-smmu-v3: Shrink the strtab l1_desc array
Date: Mon, 10 Jun 2024 21:31:11 -0300
Message-ID: <2-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:208:19b::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 86da12e4-7ba3-4a3d-7380-08dc89add145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WeJxJ/Oi9WOXbgjSo29BDhYwHL2fqgx3qjUHXF0L6WrSCkXf++S8kWc5gC/T?=
 =?us-ascii?Q?aLQjKWX/1yU5EIYsZq9ee/qkMf7l3lXCOtUrzUPGFKE6zLbNDJvMZzFp9U1e?=
 =?us-ascii?Q?pni/nDdy9R7eWeztaI/Wm99VWLI9Tcc81BxpPrJkKnlscLxu3buFrWRhTUsw?=
 =?us-ascii?Q?Iy0UQFLKgcDt/JWhXGDlOSuNIRZSUiLl9zSTG9tr8bBJI/zTJoEu6eS+sIFA?=
 =?us-ascii?Q?rwmxFSfZlVxoaYSBqSSknH4oqn6kNoiRL+X3yTaDTxCejNI3qG0xv0lK2P8Q?=
 =?us-ascii?Q?UtZr/6opraXztdHzxH0Pi2paCeCDnyQo7HX+KiFBUHj21Eh/1izknkurzKh0?=
 =?us-ascii?Q?1BSara8RcNZ0nljmHOVC8zhzeUHU4hbKucTK4SNK7yBeIvtqWakE8CrxapLN?=
 =?us-ascii?Q?arE/t8DkhzxfJ3SrCZ0v0QTvgzYFabVzLCQzz6dtrUcVK8fGOS9fO73CV8sJ?=
 =?us-ascii?Q?F9zX6A7wgF8FPLefp4IwGfGiOV4tGmYAEwfdoSfgq5UfFKqtORnw+RzG17al?=
 =?us-ascii?Q?ip+ngxWS+XqIpCCjQJwGLKxF4KLuxCyOVpFiiYR893wp26HDxnqTJL+SwxfQ?=
 =?us-ascii?Q?3KLSgUn2YuTdA07ZSJf3TzBWvm7lqKGm/vB0OJP7CfZp1cQRhGCVNkQfox3y?=
 =?us-ascii?Q?2QaY0+EamdnwaTmpRtOpgdKhRjGmSwmiIwKPsJl6fr5YRYDXOS4FxJ9V6vIu?=
 =?us-ascii?Q?FdQ/VBDf5p9jTnS2BWoWGorlbWuuN513hphbDWAO6Gzb6pv4QOwrAOlC9kPf?=
 =?us-ascii?Q?BzWn/qH836VNYZh1jdN8PgvPyyx2qVUsM3FzIelULAF9joqQVFP91ooq3hdC?=
 =?us-ascii?Q?xEvu5MrbRYoLG4AMtutujLbLDA137/3SzN7SBlvtfBjcKWHiFlHF6BNkNw66?=
 =?us-ascii?Q?EBhPUBm8OEV6WBLQjOy9dijtMyuX5p+8FClEEmxQImc/4f8cDbbUTBX6k52I?=
 =?us-ascii?Q?jjIZHBFO+y92vZ2h8v2mO3ywP2JuLkhjDTZ+ztg5CoNE0tbSFx2qPd7cPHcK?=
 =?us-ascii?Q?0kvjyGVZdTIvgnQzsnjrYN96zmNJcuXT8xAG9DO5isTBt1gcIbN2eEReHSKZ?=
 =?us-ascii?Q?Rp8yV0c0Z9vEoDjPjfXDovltEcrujzQiK12Q7aimLdEm9jooJ2DYUR2UR4Hb?=
 =?us-ascii?Q?iQT/5s9QtcK+5K30v1EflSVyKQWlYHaaQx7xGygGh+t9HmNknZ4w4ycdayw2?=
 =?us-ascii?Q?tPzZ3wc3XHpnVUtgWoGNpNy7jDcCEsk9YHKVh+BbqxN9MX4gwr4ab5yybpsL?=
 =?us-ascii?Q?caKA9fUUhQgqAjcg0LAydNbsbHEu5V00Y4a6HWxArHoquGU7XQdR6XL9pMUv?=
 =?us-ascii?Q?udE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yanyrZ/UDtyxPs7LvFCj6vYqKWIuYp1C3lDL2D174Otae0Q/ThpMn2hZBfDX?=
 =?us-ascii?Q?1Q0bZEsSNQCN83KgLWVOlvDHISkdb+PACH/PORAwhF96c6BEYuZ4g4QIh/zi?=
 =?us-ascii?Q?NF+oLSUIzwr4Lua44PTrC4iCl19zm4ddyHdc2Q7QbPb7EsUpTYVNfq6BZNAa?=
 =?us-ascii?Q?uv/m+L+L0ASyNwrL7zyO4nQwSQaS72tQxrw24B8nwZqwZMeoecE8m9pze6KV?=
 =?us-ascii?Q?D9B9yey/jsr90OgOOKrEeDMBCTP4iMHdU76ppERd0jgCySWiP76vWhtz2XD1?=
 =?us-ascii?Q?zhMxNCN86K4kojpIoYJwvuK8a6WM3HrCWdmM5pADlH4vyJZIMEyNMzbaN/qK?=
 =?us-ascii?Q?ulXFD/QTWM4KsHsSM+OiE82kH4ngvO16jJ73SSjytv6Nga2oxCh+EzyLSxy1?=
 =?us-ascii?Q?VNofA65Bdbis1HvFcbWOBI2p3WxFEE3qFTMy7DjjKxUy4aKaGjNc+tYilj6S?=
 =?us-ascii?Q?dYL2NHUkXQ+pzg1355xgYdPIU4+JcV6IAF3Q3QbdZvxko6N2fJI130QacK/p?=
 =?us-ascii?Q?DKcy9JPdl9VNMNmt/gFS2wMq8VZgrr3ciz5bsMngAqHQ0Tts52l2jUxbZzMS?=
 =?us-ascii?Q?p8S58VdBFrYLuvRbDpGXsUldfvk/WLHCWBJy3Y+wM0tu7KvPwEu0PDtkkAMQ?=
 =?us-ascii?Q?0faHm73+8QXFE2/ZyLqD3eddcmmFfWLzwtY/8BGpKvf65mWm8TZ/pp1E0uIl?=
 =?us-ascii?Q?7MOhMvxumaf3oqa0FCYBlcCp/BJtN/ZcafCIbRUTSAZdxf3Lft+nvtWT1qEZ?=
 =?us-ascii?Q?cEZ9LAAio7rsCtqATNjN2R5zgAtJPGbU2/OdUUCkPwYQcTahRbR5DQ8UwkVC?=
 =?us-ascii?Q?2tzgezm3GPDVOz9VCfrDuC+JNLdiSAhouaSe7ZePy3lDv2ct3iBcYUrClqbZ?=
 =?us-ascii?Q?CEHahogN6E4ZpyHJIhxCYFB6NYAkT9iigGcqjb7gNvwupMKLZwHrXI6CiWdf?=
 =?us-ascii?Q?sV7IsbHgEMFhq+k16JIfpPg4YalUh7Khc+B0MiSAvHz+Up7GxGqtLpj/yF14?=
 =?us-ascii?Q?Q26+0FFHt25I5z+I2mAsJgwub5MWtqnifyWaR3gtBl44ticscx32b5S/gKVb?=
 =?us-ascii?Q?SPGs6b+6+pG9475WqztuQpEHmegnkQcVjNzWarY22H0UposhEzpKN8Eu2+Nl?=
 =?us-ascii?Q?ZnFtwAZ9kBDJaBduZ6gSsaNOz1PaYR8aWB3GtmWrKS/PJH0gFdDUyNeUzCUG?=
 =?us-ascii?Q?Abv6CpXg7rcPLL+183pYHZb+Vo7drNyLb/7V95w9/xjlKEI0PFVDuswbhnDF?=
 =?us-ascii?Q?oujdoLNkYxhay3Pg9TEA5aop9U6bQIbbBV401NuZT88F6nSdj9Phrv+Y/lSh?=
 =?us-ascii?Q?sSfs+lqxb+odbu5DJQcUMGOA1qap9MBE4ULXyoF15BO7xCCH58fv0UW+UtM9?=
 =?us-ascii?Q?sktbCFdV4cWGrugglMOVM/Q95PPRdRK+lauREccuxCpRXjh8plcH0bx1x1A2?=
 =?us-ascii?Q?F23zeITvDM/bAwxVtIZqg89VBKRdOlSsdfjO3uG4BgyzW6V/DeQHvRYIuohW?=
 =?us-ascii?Q?fSt/hjpuST2wHq3Oe9DyGQW+9OEW+h5sAfpkGOVJyDunHnLOCR7vLKVMeXr1?=
 =?us-ascii?Q?Vp3J7PvJzerh27okfQfUnob9qLRhfWuwiU+mDRrj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86da12e4-7ba3-4a3d-7380-08dc89add145
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1ilnvDcbZ+6siYuILljdIC6B7UOHJ19sw6iTSlfd8odHiOOlu0d5WSN7Te1uH81
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

The top of the 2 level stream table is (at most) 128k entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (1M), and one of struct arm_smmu_strtab_l1_desc which holds
the CPU pointer (3M).

There is no reason to store the l2ptr_dma as nothing reads it. devm stores
a copy of it and the DMA memory will be freed via devm mechanisms. span is
a constant of 8+1. Remove both.

This removes 16 bytes from each arm_smmu_l1_ctx_desc and saves up to 2M of
memory per iommu instance.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 ---
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d56e19ca6ef6c5..95351c134c7c45 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1447,13 +1447,12 @@ bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
 }
 
 /* Stream table manipulation functions */
-static void
-arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
+static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 {
 	u64 val = 0;
 
-	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
-	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
+	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
+	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
@@ -1655,6 +1654,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	size_t size;
 	void *strtab;
+	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
 
@@ -1664,8 +1664,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
 	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
 
-	desc->span = STRTAB_SPLIT + 1;
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &desc->l2ptr_dma,
+	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
 					  GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
@@ -1675,7 +1674,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	}
 
 	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
-	arm_smmu_write_strtab_l1_desc(strtab, desc);
+	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1242a086c9f948..087733797f9087 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -579,10 +579,7 @@ struct arm_smmu_priq {
 
 /* High-level stream table and context descriptor structures */
 struct arm_smmu_strtab_l1_desc {
-	u8				span;
-
 	struct arm_smmu_ste		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc {
-- 
2.45.2

