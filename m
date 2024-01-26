Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10244208C4;
	Fri, 26 Jan 2024 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292943; cv=fail; b=VYrLe2BLgV46Y0scLuLcYOg1YtBCUumGtSfWmras/uW2T3auuk/laI/2vs6g1NhZT/XL+cPRJq+qJIsQDuGSJqrc9slFdXTnJylgLB/uYn8Doc2LhfVjb5SGYjsJm7OKnh1LrYJd+Va/nhMCgcsM5IWutM03sVxIf6qEjZj+8K8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292943; c=relaxed/simple;
	bh=mnhHiDtlJHOHVU5Y/FryjedxZI5Ru09RffCdUZcgsh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jdx7t22vZzGdOIUCB1X4vBD2GPLhaHAFWkwvcT8U6HYnMbaoh4s1mDY7LwiThcv6gw/Y8XrO5HUcmp8gSNCeL4iqAI+P28EaeUG/maQFY0d+mp8vJcNeIHAlXx4/Z4qUlRU9XoLAnFfDjiAYDhu4oKjIi3H9JBOAPYuH1D7zFTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EPJBFI+s; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EPJBFI+s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKkyeAv9zhlUzeZ9fKKwLLpDokUk4p8fgnAz02pjpl32uhk3zHGGrKh75O/IqSCiXC5jLUI1Sve0h+P0rydrDc1KfalnnlxuYAfQAgYjv1QMGszacl6PZkWH7vbcobEOiaz3OfubqKXI9itjxjWg7tzCpjO+LMUJqnp9EHMrsd4E9dAQ32Mzsvf+rNucBbK/2eR5lsN18sv9XxTDJp1dZfUFB49bGeIKpm0S8sfVKO9bVGP+jFXB6U+guIEl51Hkd+DZ+OSgl6rISJSVvMtvm3CUwPmBF6eqeRh4wIMdeAcFEs7yaYVvvdAkGZdtNY4yIr/oPbMnHsrnKgNVrQBxZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLgRVqMu61EII0cVhYEFcw0CHxLI0ne9la1jQmieQfU=;
 b=VjB8aJG3UVYD2FQ7kkaXYCepDi8ntTh2jrGUZkErr2J3y7VYjnszFhYkQU5XBEidEJdJIUzs3+3eEfFIk7R05cTYUgf1YDbPSm4+ffpCa5NOFx25x6SX4WC2xuOeU3W8x+hPeV7Tpn6Jkr94CsxZ0UQMp22agk2AgLtHMUZLwn0Cl1dvrl8gVbNLiN5T9AkHxocdM6w1PmaU2/nzCjSAsvIi6ZPUtBFJMSM4Q3bbSRgQsQy3gAKCigeHSBuMvO21QOyPixy4Q68kgJFu+vZ79u6Dm/QE9hHcvYnj4gC2w00t/5DjGPnpg8aGXIht2W1HNyRO3XdLUofJGJHTWcgxpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLgRVqMu61EII0cVhYEFcw0CHxLI0ne9la1jQmieQfU=;
 b=EPJBFI+sZ7b2nUDtaoeGchlGH7SdLmzk9vC7F2LJ8w3DG2ChdgWuC9v73phKJFa9uaAQMAhiF3CdFfsQtJAtfcQlpPiFaLenY3WXL2tQIM5UlsvCje43osoBbpfa0TeAmA2D/hzer5SK59Tdhw4ibvO+P0+Dx+ENVKx/uc1Cpw3tG/R7z4E37eKD3hrv+DS6Jgck29nzU9AyVgOAFm0nbvP9Z6709aiXSTX/BD9Lsxe0i7li1XGg23kOWUcUFEeo1F0GiY1LkEbDnWcUngmjkWsIldgiNYSGzOLPS4kwfi9W7SP7cKwpG2LGW1PiIfnPKkRArOPvGHz+j3UMf1fr/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 20/27] iommu: Add ops->domain_alloc_sva()
Date: Fri, 26 Jan 2024 14:15:22 -0400
Message-ID: <20-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: bd06d7e0-29d5-4772-3aeb-08dc1e9ac838
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F//9s3c4MMHK7PoKX+24feWkdM/4BMBwl72BxoJbibpn1wU66+EtGPgzoP6TY1iyibQ6weUm2u2/RkoCDL5z4e6q7SHlkN899BYrTv9vhbTYQl/VljX2gwaQ2jEEAK/tQOCzthsQYiT0/lNP+b3jfpYeP6EskWr+/2Ibfu8Lr+gv0EeMZiIvkm3hEusoGx6dgtEQxXOQyHMhN72Dem10gZ/DegehErjh/3IREJyWhuzeXAzf1gOPVIgu18lbhIKZBtbes2sswc+bd0KHpGvqH3OlPTPqA+G+bsXPai+CNOWxhNhy7XX75RK1H2UTYZOGfieSw8vfFApAavLCj+mMkNgRa3viXMfdYpQxn5xn5PBwy2nc6CqM/NcEoNF1ONheIdCKh356N/YPGJdBVWpMmCrXtN+PK/9URucKJw/zM3rB3XVLpl/ZyFnCEw3ZQOGe/dKh/3voCTDiv6t/Fk2ylk/DFfjLE2WrbFfv2qqaSXlPFZV6kCQ76hi+Ndnpwu6ECDVqKUr66A9s0J5YB+4sCCneR9b59SFKFHcTU74OAxpOf/G1PKcpweRp4mh/DZaF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jkEQSDGfysIgE0gxoBDsDiJMS1GEfnUjvKN3RJ019m6k0Z9Ul+hM1f++AXTp?=
 =?us-ascii?Q?/tukPSs20vKAe+eTznEoUs9f841bV9mjpgE15uh6ibLFW2i44znqnoxmEEp5?=
 =?us-ascii?Q?FEdhibRDvQQ8g3BhLY76NmF3wV7Dbtkqz77UK2A0f+8VvtFagYpZTZWaXP0z?=
 =?us-ascii?Q?GPU6IdcqhN9XAjb+aQUmzvOIUv2t5ttSIQNm9IzyWC6OeJflcKVZcj3Kcztm?=
 =?us-ascii?Q?L4VAWvzYtL6i3mhfndwizH76tyojrvvUtYh1/cPZGg0t7HozAapLOb/XKbHV?=
 =?us-ascii?Q?x2DZd4EFAy34gIOM1TiX2A+9pqGL7uPuwJoQtpk8v+z9Mbfx6KQBNcZTqH8y?=
 =?us-ascii?Q?gAvR/UdVpXu+Pujs9aLdMs1RRkc7PmNozgqZNlJ0ifedqnRbucdGLKbMj51l?=
 =?us-ascii?Q?yYaY5SmxWoYLK7S4GbJOEjuFbAaKCkqUEIVlF3N3Ht8FuhEaT4YG4MRdyEA5?=
 =?us-ascii?Q?9XDkXNF9VA9bAWRvA0l/tVxwMNShyQKo6kOaCcX2jl1Xs8esQhewtwtCkjLm?=
 =?us-ascii?Q?6Tlgojm89IZNq7bfWlBih72QcqIkHGVEKQ+OqUuuKFXNRnxkRRNZMK1tegze?=
 =?us-ascii?Q?i/Q19kPd4Vp83yWxypOESIgUp6f3BXOMas0kb6ErSkXlMFZOqpZykhv0eMP2?=
 =?us-ascii?Q?uG2VzM0FtNv8V+nLKrxpVboM1hhwW9XuiJx35tKeR2Erdu3ChTaoiSpd+SAJ?=
 =?us-ascii?Q?q+eprP6hkggwQ9++OS8aY6pOO2AZyLQlj+MfFvi5vVpX7Yef/yWNweDBu1L7?=
 =?us-ascii?Q?Ndk7/R4uQcf4u2nrzveSCJOzBTBSHYYMkIA9CCr81oiyGsjNTWaOwChZn2rb?=
 =?us-ascii?Q?11whXFZIrSiWw8KrhtGzVqFFv5vlxxCalYvwwJ0Lcwq2WIAyDHoIr01DQaRw?=
 =?us-ascii?Q?KnBqbxH4i76EKJVUNWYHlJOn3XjjBmuQhW8KADzZ4fvX7OLINaSIX5gs0y/t?=
 =?us-ascii?Q?7m3pSmXNAHalx9rgb9UpWQa2QNWjePRbm0HOVzwBW4W0tdgQ0WW+Xy0lQDPy?=
 =?us-ascii?Q?p8s3I5lzX81XI5HpFdbDp8qjXZO8xbocLA8vY/1oogxLssJivIvXe0KkQMLs?=
 =?us-ascii?Q?yL2ySYRbTJeOquXYYwcxPINHhmHGgIpHYVGhnII1bUodo8n4PuaertSFFQmJ?=
 =?us-ascii?Q?7PsGrWo6+dPf+rUTzoJqF7DBXnl/F4mP6tYenzr719X3NX4YC1DhCn+aCA2V?=
 =?us-ascii?Q?02zbFmY6m5dTvevUbRTtTdQSE63/PyGELTQIiVrq0AiFS/ZaQPu3sR9HLL4Z?=
 =?us-ascii?Q?lsNsHSAKlkjNvpiCOuKeCZNwsAeV/YwdhXNLreyQYn//vTcSxK9UKW/A5cxL?=
 =?us-ascii?Q?DUqzr4Dza87wdAwM+7qU+LeIOPy17UMLeZoBiPuG27+TC1Ho18PdjfKt0Y7r?=
 =?us-ascii?Q?0wKsHOnLgF/7Gg1To51Ctcfz04oICPyj1BQmHLIJbAOIKkgtrXajryYfR56R?=
 =?us-ascii?Q?AvFlWCIMLXtLvniUs84LAQxMewCiceqwZXjXepcYFta+c4nKatI2rUsjcJdb?=
 =?us-ascii?Q?sSVa5JFSZQZH8U//0AgLIddV0lfEbXrULAh+6WIOiCd8H7zMbsYVQJ92obea?=
 =?us-ascii?Q?O9Z9esFtNFQi5sZFMyCEiZW0QidQG3NJti6NJLl3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd06d7e0-29d5-4772-3aeb-08dc1e9ac838
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rOULesmujCSppJG7N8dCDgM9k5El0AvFfBK2jfCD7YQrw5MS+LXZkBixesyHE9c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

Make a new op that receives the device and the mm_struct that the SVA
domain should be created for. Unlike domain_alloc_paging() the dev
argument is never NULL here.

This allows drivers to fully initialize the SVA domain and allocate the
mmu_notifier during allocation. It allows the notifier lifetime to follow
the lifetime of the iommu_domain.

Since we have only one call site, upgrade the new op to return ERR_PTR
instead of NULL.

Change SMMUv3 to use the new op.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 13 ++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
 drivers/iommu/iommu-sva.c                       |  4 ++--
 drivers/iommu/iommu.c                           | 12 +++++++++---
 include/linux/iommu.h                           |  3 +++
 6 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 1163c7d70359f4..163e9acd51b204 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -654,7 +654,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -662,17 +662,20 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
 
-	if (type != IOMMU_DOMAIN_SVA)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
+
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
 	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 961000f308b9bd..849365a5ff550d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3301,8 +3301,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index cb08b9305e0208..66a6a44f4895e9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -793,7 +793,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -839,5 +840,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 ioasid_t id)
 {
 }
+
+#define arm_smmu_sva_domain_alloc NULL
+
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
 #endif /* _ARM_SMMU_V3_H */
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index c3fc9201d0be97..446ce5a0cae868 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -99,8 +99,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 
 	/* Allocate a new domain and set it on device pasid. */
 	domain = iommu_sva_domain_alloc(dev, mm);
-	if (!domain) {
-		ret = -ENOMEM;
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_free_handle;
 	}
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 68e648b5576706..bc96090cb477dc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3621,9 +3621,15 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-	if (!domain)
-		return NULL;
+	if (ops->domain_alloc_sva) {
+		domain = ops->domain_alloc_sva(dev, mm);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1ea2a820e1eb03..be5b51fc3af4cc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -419,6 +419,7 @@ static inline int __iommu_copy_struct_from_user_array(
  *                     Upon failure, ERR_PTR must be returned.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
+ * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
  * @probe_device: Add device to iommu driver handling
  * @release_device: Remove device from iommu driver handling
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
@@ -459,6 +460,8 @@ struct iommu_ops {
 		struct device *dev, u32 flags, struct iommu_domain *parent,
 		const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
+	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
+						 struct mm_struct *mm);
 
 	struct iommu_device *(*probe_device)(struct device *dev);
 	void (*release_device)(struct device *dev);
-- 
2.43.0

