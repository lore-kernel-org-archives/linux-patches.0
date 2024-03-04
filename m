Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA757D06E;
	Mon,  4 Mar 2024 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595870; cv=fail; b=JiBmzS8vydEdCLV4l5lpamVF4ct+4sbfKjuPwkxsifci+yxgNtkmueXAFP4uzRqGVgVpdjaPskBdNKW+NQ0GW7ReaX+WjNH6//ypJ+pJwqNB4/WoSfioC7e+/cNcocJRzD84KNtIRZQoiXjF4fJtbUFzyvxKo6pT5F1rjrzZj8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595870; c=relaxed/simple;
	bh=E/dv3aQKMNWwfbdkOq1Adl5C8SkY/3JJDbIbbvvEG+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R1lvJyaCiDibvxLkDJ82j/ExHV6naySjEc11GgrmswXQldkHpAIPY80fgYac1NvsPw6ZJHTm8bjOTb+nni8Nhd1uWcMdcIMDgXn67zlvyWnfm1beUbOqZ/wmSohDVkMW11+OOw7r5yasZbw1SY9XyUMnTbXtgrKk1J1BoJLnqS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FO09yjaM; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FO09yjaM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0LzIXrx83gkPGev9wbE3ejovT8SaG+mI5cpASMJz8i+Jw8vjjcKcJZFOfvZmTTyWDFB2qk2ZAI0FAjVMVJvIgQ9yKryfia9lR1IYpRJHBwfEUSxtchcC8clrSGz6e6c4ut8femlbcAUZ2O2wdcJwj/vGvbwDn0dirqw8wrgiPmEJL2P9cxojXLuZu+yOGQr1zQ3LkjFNJ0M8LjWyidqNK/GPqZBZravDpLaaYxLo3ug8kI9HBU1JP/WhyoNTeOut9tsb0U8UHwnrXfevWzAMD1H5tlX4LtQzQbOSpMJvkyNxDy4tBjPBURQQ2EO6Tvjw9pJklFwwtASAnWPoJGNNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXxJChavfxvkoof8D89lfluQnkmDC8CiI9SRHddPXQI=;
 b=f9F4+p4gS9AE7lbJnOKN6ksGn7AOLzcs0nTRz8ZXOTOArf8L7RROfBDzqEA9dJhdmtN7vIQNMgeAorVHoixvRcsv9PFgHb9qHMmuIKn7RUJanoOYyvhVvOqOHmBoZTnGP7PVWfmlwXU20up6rvJbh910F1GWva55wDKih2SYxOJBTsw+iISwd+ogeRdaFsfDI4U8rId5GnrejJc4pF6sX8YiCYvI/zJu2Bd1AW/bfNjCNus/IhaRlUkQbOcIo2mP4zk7IOVBu25gb9YuxJ21Jz+OBjBdOLU4fVNio5Asp66JNTGGqHw7gQynK+GXGqrhYvU39AGyXk/iFRrSsyAYkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXxJChavfxvkoof8D89lfluQnkmDC8CiI9SRHddPXQI=;
 b=FO09yjaMXv6dTqbDII3QgXqCH1VGVdttUoxbRfSo9fsC30+zMXA9iU2oAoRavqJvn6eYmUonBg7ZBOnh+0jrZsikdlgfbxWPwp5SSn/hKH0Lp3/zX53scRk7HZ9qvUBG9fRz4nKJDWdxRvCUJLC7A74WMe0TKvyi+A6FWYMXTdGxntGZwMlhQWCoQgftR8xD120r0nXRWNG4+5jO/lHv+oOG+5hWLhroVXMOljkwz5jo7TYxeAIMNcDJvHKTWEOSjOBVFeuCgptMcGKjxWU3gFD6A7GmgDislXvIWzeWBnKRHsuM07ahXnXzFDQBuK7B+4cS5QMsue1VA3J6zVh3mA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:22 +0000
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
Subject: [PATCH v5 20/27] iommu: Add ops->domain_alloc_sva()
Date: Mon,  4 Mar 2024 19:44:08 -0400
Message-ID: <20-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E11.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: d87cee8d-9548-4b1f-d8ca-08dc3ca5015c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vobe7yaoWAi/pDtTPsvO7zjN6zFAGOWaFX7bqJFzq8WLySq8POddEHflqqZDxcoDm1jh1lXvkNqsD1Y0kHnDYUnD5Xu9gwCbn52u/sk7bNdiyce//QiSDzN+dRGq4GqpaTmf5nppx70AFkp36ZFP6dTwkVJYz54v93xPMCpUg5DlSV7vStRlOknT08GClPfuC7rSJFMYokAjkb1YOBrxwwsG+gPqCwOR7AAlGirMzbeLl6bQQv3o31p42dIB63+JyroHFmeBPna8Ikicg6oJDBflQM9KA/qyX9w6ldvm6VxPo61Xf8shdsqyVrbArtIxdbzZPNXl4hOnfCWFfvcG+crV1EIcFyzw+Ci7sZYyj7uHrt4V7rbzIa59NLrPFGpVHGr3imMC2qyONjHwXsk4nIMFK+DlgqY1HSIr2gaHNbtNBcBNwOLajviMfuG9SXN5VW/0VNaOiOXHKlNeSmdOzTelaGCN0kQFxy8x8e8VT73yv8s+amxd++J5Y7Aoj0K/vDvg2YO4LNQVYmPlHT3qASO/IuU/UKhz0XupSSactjl4sOAZZEVo6G4U14941AXJgGjuOEHS8G0ssbSnBFn454wuDhR+QQxMfP68NQagagxlYKOVPyc5/owBNWCuVELa9Fk+vBCTdWSu0rsyfVCcg1EW1DwfNpg2VryY94dhbM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/3BMhqAyjLuv6tp8vX1/vVK1W6+FGRyLRD0Y/i/5TTm0wEbLbji0NcNVi+Tz?=
 =?us-ascii?Q?Y6W0wCAEgwtQkPpa0FQm6XJyM0514xshPWcldjQrXlzXwBYtujliFW77Qwpv?=
 =?us-ascii?Q?AgrVYv8dvkk9tqzolAVTRAoXIpL2uJ0E+cHCWwbmgt1l6QDDab/l2Y5NCDx9?=
 =?us-ascii?Q?lcODYJFZ43O7Li1JBhkl8ohiVrGNbR18vLkIixwcTkEo+YoiBpa2rHo5sCbt?=
 =?us-ascii?Q?rfO70krWZhkvbzNPDDNq0rXcUDc9pjFVZpApiT4mLG3mC95k0HTvCpn1UICD?=
 =?us-ascii?Q?en7nmm4++VWWo7PmVVpRCyXxNXdxExHxCLVrY0RaPZhUXhnEJU05mwqbA08e?=
 =?us-ascii?Q?Nol+wyT6j1VkKBcthrQrhO9GLWuKiISSFdZdmiKbG/2z07I548tfoof37+s2?=
 =?us-ascii?Q?RcN3rOovKp5jVkqhzJZARfZ/BYOJj5HEAMGcLZvS13qy5tsJe7BgYJz+zbLi?=
 =?us-ascii?Q?z14SRVd9o8bhE7s3jey3S+iV0rmjOw+M3QsAFb1BGzpEABzfbunGUAIWaHd4?=
 =?us-ascii?Q?OKwY/b3GNHJYWaIRnPTZaT13MhZbcQdBL3mt88756piDCI8bYw95rA2hCp19?=
 =?us-ascii?Q?S0X10Uc01YMbQEUQtIHwceWdzkc64EVzpuCmGGz31HGD33esw9veZ56zfxgg?=
 =?us-ascii?Q?hN6AAOBYEJSkb44Hao5YoNpUBI9tKSxHGzODIsnK1pHEUaCT/yh2WwpK+UNm?=
 =?us-ascii?Q?/Ky+siqokNc6xhIbOq8hCJ2XMaJGN53CsbZVm2wr6g7VsIh9FBtf6VZMdFjC?=
 =?us-ascii?Q?gCL3iYEHT91M+MMaDkBLOMup3mDhzIA9FIoldS9jaznozeHkK06YpwrdHsqC?=
 =?us-ascii?Q?MlH4BHpPpfL347PWuMVpoxzteH5bqkvzfLW3QQ0/yYUZCZ7pj4blRWf7ujjt?=
 =?us-ascii?Q?cgwKNggsSubS9Prgx1wnwOJERY4A6PTX0dibqejQftZsQSHFHMTbGy5Wh9AW?=
 =?us-ascii?Q?6bz6sBx97WiFkVhM2QiqYnU/R64f2sFP2mGcp5B33aMfy1vrtIP8TQtU5cvw?=
 =?us-ascii?Q?qlG5KqkiloYnumkc5IgvN4pzp1yEnvAEVBXdIiml15wv8N8el28I1cRAiCRO?=
 =?us-ascii?Q?DMXFlg7M0xc59kfiXAZyItC5/JBeD4b8FoVwDrUiMjf9R9dRhZXtvpr305r/?=
 =?us-ascii?Q?v0Y7gZ/WMiimSrQSRwn3fevJ/6R4JB50OyiLgSglb8t7cUboLp1PcAo2FUj2?=
 =?us-ascii?Q?rKOA/BqFFe5Vj0YWJ28sAHOTmh0G7PuhqF4DSd74YK2c2JpvWmoJMz87rXub?=
 =?us-ascii?Q?pqAxtPBkJY6P8SyEBYdEXVPyt+ZeokBokcazomLDdqsQ5XOJ8Fl5C9TnRIIi?=
 =?us-ascii?Q?TwePBFft2rtGF0rBU4CylmKsDC6oFTbZzKQFSjI9tfeNUidROUKqTNorD0UT?=
 =?us-ascii?Q?u9+PABObxyS4IfS/5hLLSbwkmiy53zsuCNmA50iBnVD8qeL31cyAwhO/ecmv?=
 =?us-ascii?Q?/IIfruUlmmkZdIWPLY8S+AKaN/1xmibCd9qhdKME7IY5LdAb57yl/D5kAJAE?=
 =?us-ascii?Q?ApBLytYpgoWDPXlgrjEPLa0xN2zLCJzmIpejvO7NXWN9UQgkpucTv/yg+B7p?=
 =?us-ascii?Q?S7iAKfeGL+BfUziB7iz4mlOP9B3uV0SWTW1aIbA6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87cee8d-9548-4b1f-d8ca-08dc3ca5015c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.1209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yAYBajhTn/veNs4RwH/xHuExG6c8/fZasaBkNwePr5KnEhKmNwV0uNxRRhMzO7nG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Make a new op that receives the device and the mm_struct that the SVA
domain should be created for. Unlike domain_alloc_paging() the dev
argument is never NULL here.

This allows drivers to fully initialize the SVA domain and allocate the
mmu_notifier during allocation. It allows the notifier lifetime to follow
the lifetime of the iommu_domain.

Since we have only one call site, upgrade the new op to return ERR_PTR
instead of NULL.

Change SMMUv3 to use the new op.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 11 +++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
 drivers/iommu/iommu-sva.c                       |  4 ++--
 drivers/iommu/iommu.c                           | 12 +++++++++---
 include/linux/iommu.h                           |  3 +++
 6 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d633316f2e45bc..30b1cf587efffb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
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
index 6d15fe3a160acf..a255a02a5fc8a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3311,8 +3311,8 @@ static struct iommu_ops arm_smmu_ops = {
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
index c47e07d695bef2..f62bd2ef36a18d 100644
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
index 65814cbc840200..aa20ee6a1d8ae7 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -108,8 +108,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 
 	/* Allocate a new domain and set it on device pasid. */
 	domain = iommu_sva_domain_alloc(dev, mm);
-	if (!domain) {
-		ret = -ENOMEM;
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_free_handle;
 	}
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d14413916f93a0..f9a2b8363ad941 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3629,9 +3629,15 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
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
index 5e27cb3a3be99b..0274044f1fb084 100644
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
2.43.2

