Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FCA21FF28
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499125; cv=fail; b=l9vB6pSgZrU07UZN9U7w85GOtfwHPjZE1Qlig17zJNTs5gZ7ARlRg7/wg2zXSQzLtuJkles+MkcFjyTPB626mtbJbxSF3U+xWFcQYG235+s2IW0cUol3L1yCByamHNkbEpa3oJrnS/pHLfIOvxJp7GqYOjep61saEIh5NhwMBWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499125; c=relaxed/simple;
	bh=+KSEVNqFwVFRlOzKf2ahJeypAMeXGGHEEI55W+LHjtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k+8k/KFwXpqHExySrRB68dXUuCZDV/BZDUMfL20f1EnJqSiSg9erS2SVBqcQo4a2f1WFSBeu0zB9K6yWBdm9Ss3j2F02ZetmRutja3O02EGznOlLtfUR9p4Hqe06fMtcRDWnYxLKJqNMlC7a9GP69S5z6NhM4OElAfWW6qm1rq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B6mFaZoM; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B6mFaZoM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ol5iWjKMBZ3mGyxz52WSPDxwWFrwwSznBsoeb6DXWWF8Gus8A2F56mEKnbp6B8ltODJt3c0u8gFO0xgPoKyxYa50hRisaxbBuSNMr9MYYBL14es7tCXgosN+2IQx1LcDbaQ7t4qmpUt5p9kzCYZGc4FxOt6NLQiMC32G5pUdBfE3g4rjYyhHmy0lgmKvwkMjpoY/B1XveO9r5u7AOXF4oawEM2FoHWytvzoUurXT4bzfwKxQKbmDEuYxRr6zvSY3Lui/qjegb/jdUuWVhJTTKbRjFEPIG/znK644QQaYCqjrodG47hVr5GYi3/QCukow4PAice1V5YUrEV8HS+dSlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/kC5S+HyzBgApdnUFaOtJ/2IAJJOZx8cu0T6D/jsWc=;
 b=knzC2x9l9ZcMOAUWML6eFJibV1282ZTEqSTXx0fT6PNVk9lC/72VTM8iVMC9u/nvpj6TofATAavKUKfFWjMh8ikr5UjpXSa6m099ntzqTU16cXJW1B5MbVCb3kNNEMjAKz/fF80E2x+YUeLI/JlIcwKj3+fQFkBIHlbgv1UDZLIb6w7qCqJ1SGPsHiZ9vZKJjh14QslbP1ozILc288xUrx18e2rA+Iucftw/XxWNyfUPymBT9RZPP2nmOpJAbrUsfdvSByqol9UIF+qZAANcXwrUV+mlvwwXN4y+mS5u64Pnsx6ijGCOfXd5Cil/8SyNWwt/aobxnqEbE6rrpA5kOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/kC5S+HyzBgApdnUFaOtJ/2IAJJOZx8cu0T6D/jsWc=;
 b=B6mFaZoMEOR4rEAyojCnQTXx9xlchthEyM/44d/NyMs2qw6Z6ku9salnRIRVEYQdpArNKxpqxkMaXGVuyWrJN2Q4zvwi8sQuLP7h8qYiRd5gVPEMpYun82hhPYqzbJ/mXlHWhzI2QN1vn4z5V3aJwhC93Zv/u720OBUz0zTgUvMNML/tgndbCL/J5o0fvHhdbvfvfuTrSLHjZWutoKq0A6nt2CzvnSD9j+yxvfNARoB7khDC18Gxt2V6Nfp39BSSQhvVt/0Nc3rC99Pp+oBzuVkfg/hq1J6gUOqYEPjDan3yiMFlS//9vmNWRRdjn5h5IIFCvEqyJDX4OeV4bFSK6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 6/7] iommu/vtd: Split intel_iommu_enforce_cache_coherency()
Date: Mon,  9 Jun 2025 16:58:25 -0300
Message-ID: <6-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0324.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 6543acf5-66fa-4fa6-623f-08dda7900217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dXGi9XL5NDuVF/Ky594KKqje9AkyQ8BBO0e7cw0c0Gdeq0dEPibYNRl8wP0d?=
 =?us-ascii?Q?bp1rPAppdFK5vumOLXliI0DHvXTsmoc5rBy4czY5ifFXXCms37OVW/BBtw4v?=
 =?us-ascii?Q?5EpVIUkPuETgVkNNd/DdHZJ+tzeKveswg7rgp5pMJUPzFjyZk7ZbxcRZVVAM?=
 =?us-ascii?Q?L/ytid8sVYAs+9XSgObfqJ69qKvrKYFLr5VfNxAgDaMgn7rIP9FltMzrJw1b?=
 =?us-ascii?Q?GuAnQ+PbKg2KNhIHslcvrOZyMbXBPCYPJtKcjWCJj6Kf1w7Sa5Rn8Snyu//y?=
 =?us-ascii?Q?EscPMuPMFMDy08b1HJ0/x+I3umCASf591mA272Y/ClmRcaBii2NWNReigrxV?=
 =?us-ascii?Q?BNb41Zl+gyI+uHt5ABEz0B5pTmmcdGf8G0qpGVIfdcawKbBGGPNM2gZXAvQv?=
 =?us-ascii?Q?Uz7jg1qpMn7V+sm2bVHYmhTvhVg0C4FH2HbB08LpvzKOjsJxX3FcNmZxrvaF?=
 =?us-ascii?Q?RSTE6BhRmTezaFvpV4KXIl8toscdESR05hUgfcRZa1ESjJI9ns/Mg310nLm7?=
 =?us-ascii?Q?O5gmiR1hRi8Mbguq9IAv7soa+x7fWsR55TRluJBziQEiCsgy/eLphNyN0/2z?=
 =?us-ascii?Q?//4gisBWcrx3LTsTSwGhEl2543B10a4zfIBhtOa7xBRap+OKdptoWGzRSo+o?=
 =?us-ascii?Q?16Kx4vj8IDLM4qUMtshHw17SmqZ90WCjmeRL2SBayCUM8qR7Botc5oQzQneB?=
 =?us-ascii?Q?35Nse52XFDXZeIShfp2/tjhAn0TnyC1awS8BteK8VT58Ejz8SDxXZ7CfWCB+?=
 =?us-ascii?Q?eee7aSxBG39NlKjde3+4GQsGPqdmbA3l9emtsoPybfZW/qz7C6SMzb3X2mmS?=
 =?us-ascii?Q?UHdVMDLXNKARpHziH2/35wCauJU2azjNinslklA2plqcs9wemWZKD5kj4rLb?=
 =?us-ascii?Q?GnYo13eit7SZRn5mUuCYy2BLf9Wsqc/KvUsBlB6LM5QQNENlDCmowigFNzss?=
 =?us-ascii?Q?y4AOE8OC/Q7oTsRcvRLv/j375SKDpjUQx7SQqbF8nx5ERGjW8P7Sbojco7hJ?=
 =?us-ascii?Q?P4mumOil+sm0RnC+hj2UyRqs7Ft0h/5FgSI8/CJCddewlk5I/JpdTq78rpYk?=
 =?us-ascii?Q?JurcFsWG0CoQ7Tr/JfsTYTpu+SUfZrmnPQb0D5bB3+qlioNj4Tu3EheJlSPU?=
 =?us-ascii?Q?GnnLvpPvE12kzNNRuO0k2qBVVwd3jZ6pi2iOB+3ViPbhtSmRilLSDNkNZiTS?=
 =?us-ascii?Q?XSflQd6lC2khCuT6Ne+TOy5yFi4pctwYzNFPUGT0vlp1fRR055mG+28X3fQf?=
 =?us-ascii?Q?/Hhm+8pzU4CYCQjYJaMcjF9NlwfXXA+ymkk5AwfvO3B3ijMOSBjqarVsI6ZT?=
 =?us-ascii?Q?kXR/m/QQ5EY8XlnDVqw46WE7hUpgPB2fUFV/6NiM6euij/Dej+oMR819DqLJ?=
 =?us-ascii?Q?Bhu8+Xqy58XNl7fwNi8v3hK0flVkfj/FuKbMXVKXVqmhZtLMKw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?liuyCoALiV0ZlxXyT3aI5aE3vqSbabzoHkkaaCRYwtVp1TC3s8vVMg2rAk1M?=
 =?us-ascii?Q?m3c+z9ihK79XhU4qeiDkf1/GXGlnxfGR45H7/JTyko7KgXI4IY36SYHgViHR?=
 =?us-ascii?Q?mamrNGjD3/Zff6+Ui0keQn6lFyIv1HZqiSI8HHkCSGD4fWi//s+W/K/1umid?=
 =?us-ascii?Q?ElQT3hnJ/nHz9hrNuXlgfsg5dqnl/ZDdRIExrMtFP6CONyi7M9DPzydZxY2S?=
 =?us-ascii?Q?S/sGAkIwU/dqp4iO81lusiWfvLCZd3H8leGio3cEejFQprNCzc6RE+i7MdH0?=
 =?us-ascii?Q?w+S8Neubm8WVBfrqNTBOVUAfidb9hEstUjfF94CY2dlyxihy2PA4v++qh3qY?=
 =?us-ascii?Q?ja6X69yPlS5+Q33rm5A85NBZPpk2gYxY9GS8WiZmDqpmcOG48Qbt6h+gsVXa?=
 =?us-ascii?Q?AluAuI83yJhlEKcBqdcG3ikt+YRCCqMA8XydZ6VqGDmtFNQ1poeVkgghT08f?=
 =?us-ascii?Q?3kXpanR84qw+QeprjMBYffYArvcYVMVot4Q82oMmLsiNVUYZKk0F77SyWcg+?=
 =?us-ascii?Q?XlInjS+MuczjhFg76wuQXDcgCLK8YIWlLNwFzNa4UQPmmMZ6gIZUmWSJrwDz?=
 =?us-ascii?Q?i/HOduFfkL/rGixEpFXLKy8j2cSG34oQQVyDELI/ulVpvz0t/a6wbrntdAjy?=
 =?us-ascii?Q?EoNfcwjmUkEUgH5PiQqvydX/4eqDA/NS7Yb2i/go/91T/T1CX5CT5agA+LEP?=
 =?us-ascii?Q?I0RoUyUN7UjvYrpGtG1hd1YhlTsxrkcgbAj1D/iPqmG+oQbEXKPmYLnX0Bn3?=
 =?us-ascii?Q?TckeRToAS6ovigODqqbhOFw7uejrudyg9YYfoWhHH8LYpK2fAGTHOc8qLCzJ?=
 =?us-ascii?Q?LwQ6DlqZxZes6RWbRQeD0Kq6r7QbKvkHBP62vSWgM7WzArJkWkX9yvxMUaXP?=
 =?us-ascii?Q?6YMheunRIp1JXwV5N8RScB5WxPwdrnt4QqygVHsZVnn6QSelbsws6Oe9X7nD?=
 =?us-ascii?Q?uZJkA11uXLdaLdJMXdpssDPSZdMNaFuItMh7b64w2f/e/T9lSK2vcwXDeNfq?=
 =?us-ascii?Q?0RoE75M+omn45xOA6EnFjOnJZNwnp9vs4i/oAIAmFoIO9fXFtTffw1iZd808?=
 =?us-ascii?Q?Ru+7f/4DC3YOxPRdLKIClfvLczc1XXS9cge3jO5K69dwNvNgtzKvDRE1bI+E?=
 =?us-ascii?Q?aU1NnDrNAkaId0dakOFGuJeRwrxvP8n0fayCjriwC3+Y9KjFecP1oMJp035W?=
 =?us-ascii?Q?GRgIQ2i+izfXAdftB4emLVYBZ81VUbULoXSh1+w07JIZ41pTFNCBxJoGyTfN?=
 =?us-ascii?Q?48dLth26KmLrVR7cSxfFCRk28iVxkyoqE9btJXeDfeorxtIFHSzFlt/WS0Eh?=
 =?us-ascii?Q?t3KVKzNUCCwmBoVTLA2pLXqranZQ+ltLsikAmVMJl6bdZRDqISYorYc+2P5n?=
 =?us-ascii?Q?BoBvEH7V7ckP5JcS5HpfhuGbevmJN6ZJ/Gbr0FXuBgBil81934k7YNna9Z/D?=
 =?us-ascii?Q?pfq5VP6LQ/Bem3DwS+0uFSZ5QzpIp8D4BvpMJOWWxYUeR/ZfYNqvtJ8qYqZr?=
 =?us-ascii?Q?w+5BXkbImAb2fh2kR81e5svi4tPc2P/6D8FiIBvQe422cnsDiqliU0Ehejnm?=
 =?us-ascii?Q?iZNkX0/uYY4HBF8fKHdDgzMy5/nbSeWIJuAv4OaV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6543acf5-66fa-4fa6-623f-08dda7900217
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:30.9953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMHFvVuggEuS1/SrNAXdoux5DUukC2GleCVaov0Jn7Pq1yW8W6GJ1tKc+DVDC24Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

First Stage and Second Stage have very different ways to deny
no-snoop. The first stage uses the PGSNP bit which is global per-PASID so
enabling requires loading new PASID entries for all the attached devices.

Second stage uses a bit per PTE, so enabling just requires telling future
maps to set the bit.

Since we now have two domain ops we can have two functions that can
directly code their required actions instead of a bunch of logic dancing
around use_first_level.

Combine domain_set_force_snooping() into the new functions since they are
the only caller.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 56 +++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 820a4ef9396d68..ab2e9fef75293c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3628,44 +3628,40 @@ static bool domain_support_force_snooping(struct dmar_domain *domain)
 	return support;
 }
 
-static void domain_set_force_snooping(struct dmar_domain *domain)
-{
-	struct device_domain_info *info;
-
-	assert_spin_locked(&domain->lock);
-	/*
-	 * Second level page table supports per-PTE snoop control. The
-	 * iommu_map() interface will handle this by setting SNP bit.
-	 */
-	if (!domain->use_first_level) {
-		domain->set_pte_snp = true;
-		return;
-	}
-
-	list_for_each_entry(info, &domain->devices, link)
-		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
-						     IOMMU_NO_PASID);
-}
-
-static bool intel_iommu_enforce_cache_coherency(struct iommu_domain *domain)
+static bool intel_iommu_enforce_cache_coherency_fs(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
-	unsigned long flags;
+	struct device_domain_info *info;
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
 
 	if (dmar_domain->force_snooping)
 		return true;
 
-	spin_lock_irqsave(&dmar_domain->lock, flags);
-	if (!domain_support_force_snooping(dmar_domain) ||
-	    (!dmar_domain->use_first_level && dmar_domain->has_mappings)) {
-		spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	if (!domain_support_force_snooping(dmar_domain))
 		return false;
-	}
 
-	domain_set_force_snooping(dmar_domain);
 	dmar_domain->force_snooping = true;
-	spin_unlock_irqrestore(&dmar_domain->lock, flags);
+	list_for_each_entry(info, &dmar_domain->devices, link)
+		intel_pasid_setup_page_snoop_control(info->iommu, info->dev,
+						     IOMMU_NO_PASID);
+	return true;
+}
 
+static bool intel_iommu_enforce_cache_coherency_ss(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+
+	guard(spinlock_irqsave)(&dmar_domain->lock);
+	if (!domain_support_force_snooping(dmar_domain) ||
+	    dmar_domain->has_mappings)
+		return false;
+
+	/*
+	 * Second level page table supports per-PTE snoop control. The
+	 * iommu_map() interface will handle this by setting SNP bit.
+	 */
+	dmar_domain->set_pte_snp = true;
 	return true;
 }
 
@@ -4380,7 +4376,7 @@ const struct iommu_domain_ops intel_fs_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_fs,
 };
 
 const struct iommu_domain_ops intel_ss_paging_domain_ops = {
@@ -4393,7 +4389,7 @@ const struct iommu_domain_ops intel_ss_paging_domain_ops = {
 	.iotlb_sync = intel_iommu_tlb_sync,
 	.iova_to_phys = intel_iommu_iova_to_phys,
 	.free = intel_iommu_domain_free,
-	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency_ss,
 };
 
 const struct iommu_ops intel_iommu_ops = {
-- 
2.43.0

