Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D207D086;
	Mon,  4 Mar 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595869; cv=fail; b=uyFfZxORnnFvTGggaUekR67QAUp2lVeTSnr9orT6CrHb4g9wUsBp7qaQlBWSKB13Z5/Samg/xrs01q1KgFUjmvlhKtSBSCAL/mcvHWRGD9BkoNAM8BsQg+zNn4zGOn12a6Z8hz8atdSmFUifl5lfOAawSEqTOyxQu+6D7Cb1vMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595869; c=relaxed/simple;
	bh=yyWZWEDyPdFYLjw4Dn313SJSpt4yvp5H3uufmU1danM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nphxFY82Zw49MnjctI+6ryl2qmGnHwgCJjVqcskqgCZv9f/RmX2Wdqs8KBn8DAMoH+X3pKtQmk0+2csLHtaEve/1GRVFz9zakuOQBPhiy2eo1aVMvz7NUFzyYuF/28S0PeYXje0531E00bjqfBnaR7ANnGx1T57UAaIv6O5opLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pqv7icWl; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pqv7icWl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FonNnu5NORKy38dARw0OzNbMLRkMLDE9PXhwUF1FWAv4jQFIYuIqaES06h1wuwYaTuYSNODdSFQAUWKlBWSh/ttrl+/7bGBb77VMBT6Ff1mto7N+atzRlL8SHngEYsjb5PSucD3fP02kiyomDFxWxBHjCf/NQVXxieLgZAAdEPPtfWzppsi/Nr8Hd1dAEFiysyOb3cEGkZnBPVriwpvykHIArQPI75kvZsK0exAMHMTQDPFROwEMO2hiHiVIeCJjjEuMrGRrDxYVqjE7swI9C1nAvR56/DQwGBkGyE+64ueAn1tMFLubkoYh0rA/nMnXbvJlR6yyuikkLuQZCmYf2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8Q2Ex5NlF7kQ6vr3cZCirmQ9TzxHr5+Psc1nmU4c0k=;
 b=hUAVcC4fgixs7iB1VNDwgXFjn6woWf9xUHl2Ef5j/QxegzAA5Ag8IlW9B+ZJQzEnKtWSdALWQ1kD3nwAew4KegYGamcx6l44+wwl0lYPyG/3Ry6corg5RcKJ3QoZ5RUODOS4MtUtud3z6dZEEV8ybcIWw5yimWAR2GpMUiKnPC04UITlUi3hJs5CVf0qOJfhPkgGoxfZhsM4i2py3yCFX5aY6e6uzgEnOFzY63PP1eLRZ5WHAS/xzMEkmczsqjobu4952J5WtKODtY/UDzEMsRpll0qDtX0ayjQG3GL097r87yJO7xGh6G3Zz8A2V4fjNnQ/jHkIfJCZpXfeAMru6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8Q2Ex5NlF7kQ6vr3cZCirmQ9TzxHr5+Psc1nmU4c0k=;
 b=pqv7icWl6FNZV/q0S/Yo4l4yRJqXuXOsEMbCyvY15sKLeKLCdodvAht11VP0rba/8sEDan8BHfvG/dxSoJo046PALGg38mXMpwuyYIVZg285/uOzHdlwaV3laEsdsI6bf349MWjT/gTicOnWHkhhYgg7gZ+HGxcJfLHDAK1hndKurKUfT9EupzFE5x74vSeRVALaE8tKaDP7xIXSK+ainwzfi2Yq7LpdJzT2wRqMjGnZLg6F0Hxt84POKZSqf0ryLEF4/xtdWgBQmGtCkISMMyQyZFcfWNw7iunOaWydVTiNgFyVpTRsJycvX2kdgwT1ago17hT8pU2qZTKH/stNEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:18 +0000
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
Subject: [PATCH v5 13/27] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Mon,  4 Mar 2024 19:44:01 -0400
Message-ID: <13-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0014.namprd15.prod.outlook.com
 (2603:10b6:207:17::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 1969cfd2-a13b-4d12-2c69-08dc3ca500e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uOlgReS7gQxgstFeowPPs7J/ncSgs4ZiTVcvEAEzSZo/x5KCML9deE0tduTWBKoT1zicMQ4SS7GqFEpJMzl/QsJNL+Fl1UvAJj6WjSvyja189lWgoezJoVJLnj4Z/kXOT6E6BS86y0k5ZOf5iQs9sd5t1Ld9XeLCIlShN6+ZwUVGvxJoQk6vtR3abkR1QgWcwDw2NsKXJV/tTJfhzB1vf83C0/mUObo9xE5+iGKyoXtXPQdGIBkbw4Kqlynw6DvDMNaWJctwZ/IPUyCcjCToxUwKRVq2U2o3wK94sNKbUVwgFqt9GcAx+hW5rwiY2Pq9EeEE/0XNi8YQoT/roEsvE64LsCmlza/slR5swZ2FuWpeh1piJTXsZBtBKR5bHxDs0clpbYW8WvXxUZ3byfS35aspU4gfCtnNb1PJbqWOaGS3ux68i36sVCpHgpqrMWnLDQD4QSOIRnpAWSjd6Kojd3LHwpQRp6iOIiRFfJxWFRxGPRhWwboj5cM7JIfHGALrOWIb1Jul5g11IAiiYZIsTnfUIFakx3E1e0tlBlRW8w0addletOO/aOElzJ3YYA1lHVoGDK379OSZSHE0l+DTrjwq4gH/kRBISSIZ86jtqCPTMfrhnNrv6LY2Bg+XowmNZq13aQb4Gptr9d39LmLvHLMuFrmt/DX7L7cm7m8/lKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0VgOQVp9WhhxzjCJ3IhQ7XyoWBoNZfb7Tul9A2ZDtDLRaVQSuuDPI04hWkBJ?=
 =?us-ascii?Q?fuPE1aDzlhAXwMELrP+zgS+qk+sLLpM38+FLc+OzqZHlt0wXNlDo6XJAGnbP?=
 =?us-ascii?Q?aURqisGSdx173dWEdVo33IPgVqh+08maGQ277FMZdJ4kQzusX0tbk0i8mxrC?=
 =?us-ascii?Q?xYBZJheCl18LpUb5GDZb/9prsyQh6s8gy5DyXzVs9pt97YnqMrgwvSV4Umvt?=
 =?us-ascii?Q?u64XQb3z6ertoR7+5xaiiycwaN6M6mGsExaT5s7BKlcQ4ab8cDTWuTjxPMQo?=
 =?us-ascii?Q?8HwasLM/uUgOiSutFg4m9DSdmmLWRWK4eY8vUmX9w4vQReGbZo4ghbcTlUS+?=
 =?us-ascii?Q?+Y77nVB7Mvm/8UaHgh2bb1IH4OEdzluYQ/OcbfK7LLHs7ImROo1r+R8XG3PQ?=
 =?us-ascii?Q?bC2yleDLQeBQWs7euQlQDsK5VJC3MYsI8yofUN3KV7IiaLPKtp6BpdwQaxC5?=
 =?us-ascii?Q?I4dz4FJjDgfjcwRYhe1wYoym19x1Y+dhjPUfc2JjGpIPl7u6IN8fw/5LU7+Z?=
 =?us-ascii?Q?+Uqy9LlOAxGMBtfrLHeN5XUBd9IIUpJXgSAjzvDt13yyjJw+jmYPq//JABVM?=
 =?us-ascii?Q?3hfkPWNeGzJ8q6Wu4RnrjkwQS4YJTf3+TeKfLHyA+yla+MDHrJjKtokJC5x/?=
 =?us-ascii?Q?8KmkFhWrhqjfGG+Gr5TtDbaPZOJi6U22S2ibZHUW8PEMXDHnxFMcIoFoubGn?=
 =?us-ascii?Q?q+rmqdSU22/YGuidFCD/nUuMWmGoSxx4YXIVkB8bnHq2THav1uF/BGh4CS7U?=
 =?us-ascii?Q?AF6bsHBGMtRrrpbGCEsrydhBpgBMYidmkWPcGmfco2X0k2/Ii+GxsYmgY/CT?=
 =?us-ascii?Q?xlErGiEFEClo6LU34omNjhcAvvovahOb6alMC4q5tyVar7gJET9vSUfNUjre?=
 =?us-ascii?Q?NBhBkRCrLMJiSfzHdFvTC0W787/KMuvCk5GTLdTwYCq8EsHDDwfhSF5Ayt+R?=
 =?us-ascii?Q?5E0D8DoMW+dPi3Kt9W9iQi7M1YC8giwSAv72i83zOZ1W+L24YVpFp5Ny5Doz?=
 =?us-ascii?Q?Z5P/gAXsnLgCP/MB1ZIOn/p9G2ky5Hy4VLQ5c3mn8gUGVlzw7akZ8bFSKOKS?=
 =?us-ascii?Q?3VAcYBza4CMiGk1Wx1nsIPZ3q2eKE2X6t3UWQw//GoUeXH2I/7uusGqvgOr4?=
 =?us-ascii?Q?Zjsqt6kaNeXPa1U73oZBYqZwbe26gRqO1VDkySoAKd4cSyl3VT9toNm87Y1U?=
 =?us-ascii?Q?vGSLbawxrpHZQgdDhnSiPq7hHHQDKvYWPzOS8BBrfxwyPsjkGuIXhvUBwljn?=
 =?us-ascii?Q?MpiiQr3lqnAb6ktjBSplgnqbwbDmFRCLOSB9eDr5/8U4At6xukvT1u0wfbro?=
 =?us-ascii?Q?l4qlV7Dj/jryl4epQWj/G6NvQHtFr4qEWBHCIwFrRoFEH5RRXwqH8XkDrDje?=
 =?us-ascii?Q?W89t+hCr3yx38FonCO3oo3zlI6RNWnpl4uBNTlscmb8KTfrnxY3wQKDqYa62?=
 =?us-ascii?Q?3Px8k17/2JDo3LoZZ481s4UuQfh1DF3tAUdGPruc01vbaXr3Q3OtHrh3JrPw?=
 =?us-ascii?Q?8EkfCTHzQ7mSIB1Tgj38aNeniQpBfZBwk4xwNVw0mj6CaVXtEdlyhCjx7juI?=
 =?us-ascii?Q?kxAUVcnlmmb9iv5aaa3nbBTI4XaUMAQ7Nc5vXteR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1969cfd2-a13b-4d12-2c69-08dc3ca500e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.3373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYPzjlCIXuxcTp6hDupf35uAGrLaftDb4AmL+6p8dIBL2A5T+MBrxPzPRNJDeB2R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index e1fa2074c0b37b..9a285b828e8b12 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -300,7 +301,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -314,7 +315,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7a0be7dd719793..51a1e7198fd1af 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2031,10 +2031,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2062,7 +2062,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2554,9 +2557,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2567,7 +2587,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2581,6 +2605,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2617,6 +2642,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2630,7 +2660,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2949,7 +2979,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ab0a6587e07ec8..c4b79bc52991be 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -695,7 +695,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -729,12 +728,18 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
 	struct list_head		mmu_notifiers;
 };
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.2

