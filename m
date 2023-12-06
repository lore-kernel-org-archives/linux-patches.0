Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67865697B8;
	Wed,  6 Dec 2023 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oWQlN1w/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4Z8TUtvP1gs1bQX5suMfzQVhWw8DmZ6SV7v5OkWqdxpansH/+ZRuEiimjoxIFiYNfNRaeBnTTUdgXvCglwMTeKy4nqKyDiMMxYwHglmh0VPJbnFe0dbMf6Cc37GsUvDa2cecxlONgBg634o2HWj1zu+w6QwY4mobUV9W3Fd+HsAN/KHz+HZ9/otwtN7zrZvyg41SZPt69EbmU+5JfTwo/KlAyzOsLUDVc1d+xkDpQcVCcdJTMYrx/EZB/KLKKNO0oDpT5ET01AiHcXwCDm6bltTQi/4s3VP70ZhOSsmWqyvUshHEW2i3MWnfilQfb2VkTwdzoGE0dE8q8cKadrCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GHsobYzYGanyus65XCeCWIwam5qEzamwpJPi4GaJ7s=;
 b=jplefmNOJG7sZ/cz49ERPal70tOCT6BOJzYV/SCZKPDhGf3NeYlvmR8914oh9yaahrtkr+z0VqtXJnyv/vbJHTsPmPySJFCO7Nnqyl7JYXU2TuUUacWDAoscO62QA+vqMf/7vr7/sbJikxa2UMSiA8RoLSTyWuMrv8FtOE9ktqT7W3Vbhy2TztxeZhMxdDdnVvgvOsvF2Fee84R+NHobUR8b9QPZFBF8j/PbAkjLuhfF7I03zPnFXR/mB+QCr0KSaJLA8u++P0d2//domiNlONtNHAcuSHsHtcEX2+f8A8RSW6dVXHN7+ZFe7BL2MqsNj2m0hPiq9zLR9aRHQIg3iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GHsobYzYGanyus65XCeCWIwam5qEzamwpJPi4GaJ7s=;
 b=oWQlN1w/biwQ2tGba9yhsQgAmMNxBOTwT86HspPB0qURhxchGiNNOEkGSreHHS4mzTGVdlHh9x21MIMcQgflmiXfA1Iql5MVnBjTycGiMWS/TTmSC20d+VK1LX4ZDXby07CI8ipYR34HDTwisIpzg/BgewsGI8QjDDJIGooI/4QcO565gkj9gC7aiWiTEY4T676944JPgc9IHgyyf/AGn3yF6TLCztTyzMFVsvy5fiRCZZt4TLZwPJoF6lAvWRcjidLu7wo3D1KR/ws7n4DPvmTGY8nhw0QLCNpBCkZUSQDOfFXZupwZYVi3bAd5ItTszB3jXARl5Bm73iaygY+W1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:44 +0000
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
Subject: [PATCH v3 14/27] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Wed,  6 Dec 2023 13:28:20 -0400
Message-ID: <14-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:208:238::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d8e4d25-2d92-4e98-3cd0-08dbf680c724
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZewSW9huSYh30xfiAXU1KxTcO/NDl/UnmKUPhh2WLQQgCZlD1ntJ42IjaCMTXcmKg0JlPzHNxOs1ukAWzlNjtnr8ZS0VJCvUGLW7e7A99T3VU10TXmU/42Ws6SslbQkF++m+j2uwnw3nFl5LTs9eAAQVDRCS7Mhquye/xZMYiA1ccnIz/ZuWVOS411emB3RDZRvuqOP6vApL+Q/R2t9Wmj3J8seGdIn+0fvc0drB8APJeJyvUxduWXpctV4UeZ6MdMRMQsvTeuQ4y1M2rozDA/x6VRsHe9d4Bl4p0AgRC6I+9EJFNfAU1RN1rJ4mim7Txd2vE2qLPQV9xnq7SUp5YdleE2Crj3xERrXVrfbmnFy3eyjh5GvO1Xe5oiPzDN8JO1I0/BcIojiXO9N72wnpOQ3gmcEP+ouEyF1Q2FgI+lpZkIhNSI86nFWOy+vkfhBb5Fb5880tYjAUUdVe7UjEgXaUUJcGNW2ccWNiVtrThSJnk+Huzh3oKkvoM+Cqb2bq6ZzFRZ8wNDUghZ3pJcYc3QLu3kSDd/4YKdmzkUf3hk3aKxNaCSgbHjIQBx0rzYMw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(30864003)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rm7gLsr2zpohxbOzSqNCUOc7Jll67yZ2N0B3RVypkH70+3xO7hARXY5b1ozR?=
 =?us-ascii?Q?+1CDPGYMUoFMv5ftDFafJBVQ95kl8Lkmf29RQ6qqo1VBSqKOrFci8EvJfA5u?=
 =?us-ascii?Q?VmIQI3jbdNI76ZAbONrLZGSk4OPxqYIfJvysX/rucvua+pRPx2jfxwnUh2az?=
 =?us-ascii?Q?03ELBfY0K5/IsyHtcHxYfnsh69XNG7snXEKJXuD7SIcCAWr/lyqbmITjmltw?=
 =?us-ascii?Q?tp5eL0xMIruyvx5+Nt55AzOkr08D8/GnVvEPEhuVComMOXYO5+bmZiM8N/t7?=
 =?us-ascii?Q?4ynA+UIFZR3e0yQCeRCnr45WYsEYTytNxkcUZ5vVVqeDlWR99XNGJfvuDCpP?=
 =?us-ascii?Q?nU0ZqW+veNaZMSt5nu/hGAXUUVZ8BQQinXh1DKdqm7pO8xR8zebcxieebeeB?=
 =?us-ascii?Q?5I0MVe8ac1FE4p7PMnfjoTIUKX1zQQmhxfenSjm40Uy3tXj89ADqALcER2tH?=
 =?us-ascii?Q?EZLVUNyRVZtg9yGkpuC9em8LtBPvyfrlRsmpmuRErF+6GQpHCC98o8g8kRJu?=
 =?us-ascii?Q?KdRU2zDvc2KH3Elp+SC+fQ3V1z+bKVXhbbQ22DoAAHsOc36FCJAYZYbFZwi/?=
 =?us-ascii?Q?/TAlrh9Ed3oOzGcFQ0SwCFTvm7jV8weOBtFKeBVAziv5hm34O8R8H7Yk5JUA?=
 =?us-ascii?Q?5yIgoN40Kj4RbH+WknkzCn/EiutIjnXTiU1Kj83DhlwjTgMLd+ctZc+4QfHu?=
 =?us-ascii?Q?bGkS/82kV8VQBKzNzNPHaHU3xl2loknGy2DFRpGmVL0DLCsYUA7X9P5Fo5KI?=
 =?us-ascii?Q?659AaUWvWAVVWvsOWQ8nW/FvbGCjqK84c5wXUCgQ1kcyvlWVgRhDm/n/BiKx?=
 =?us-ascii?Q?B4spaLXL3pK3xRXxVIZVT+AGzcJ1YLLjtiwuOag4oldztTuyLCutfjDQA7T0?=
 =?us-ascii?Q?Y+G1fAkD2A4qXcxoyK46VZUr0WBlpgcZQbvbYlTRNV7THUXb9vo64i9XlQZG?=
 =?us-ascii?Q?yrwNPPswaExPi3x3lioMAGlmPpVcAiWKijsbf6v+VhqjrikazDuf5Au95qo4?=
 =?us-ascii?Q?riPsNjdkUF1YhciYB0c+u4VLBZ0mnJx4yCKGC9qRACJTVkKNNCk4EdPW4bRa?=
 =?us-ascii?Q?LjaSz04ZCg59SfMzsqhsLSldbZwzt+AnqF2bxOG+PJC2Xj3kIRIlBiBdVWmE?=
 =?us-ascii?Q?QFbWx0f/Q04qrjeTnEGlq2f4Ip6Tuvfb7W/BRGyfqqke4on9p9zouP0yG5/8?=
 =?us-ascii?Q?21jXpAkiONbTp8dfFJNSKldo3ZiBO0ZG4FoYjXtSDC5VmFrB4cEIwT+kc7nd?=
 =?us-ascii?Q?H+EkCSJGQ6QXRpFkCjlMTRrbCxXpqAVHjMNqmyFC8jInt2XBW+VKlEP4AR7V?=
 =?us-ascii?Q?yKo1Mg9zauzEqflYLstVFuiDjUOSHS39LjDIkvTkWZj2vVrHbG0HvPd7QqvV?=
 =?us-ascii?Q?RkGdM2e/KuhyQ2qb7Eq6c1Zq0bw3fqhnV6JQgSi9bzaGIab6CPkVWYi/MqSn?=
 =?us-ascii?Q?bz09zmUk56Ns6qk9Zm+lAWd1sHODDj+L3wmqoBuQgKOD/1Cb4SoxcpE/d8Oo?=
 =?us-ascii?Q?H8OOE9XpacJUlHx5X8xaXzy5p1h+jNkjmuVomxG15So8/KzuQ2BxXWAmJbH4?=
 =?us-ascii?Q?iip9BzOaO0emS/tDGuAtB5VcwVK5BIu+xZr2fhJm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8e4d25-2d92-4e98-3cd0-08dbf680c724
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:36.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/oYkqy0XzxGwGXnGcBwIF20ondRnPUTk/46NXVp4P7xZdLrFJhQ3e5D7gEjW67/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 arm_smmu_attach_commit()

Put the ATS disable flow into arm_smmu_attach_dev_ste() - we only disable
ATS when going to IDENTITY or BLOCKED domains.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

  1) Add the master to the new smmu_domain->devices list
  2) Program the STE
  3) Enable ATS at PCIe
  4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled
masters currently in the list. This is stricly before and after the STE/CD
are revised, and done under a spin_lock which more clearly pairs with the
smp_mb() on the read side.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 171 ++++++++++++++------
 1 file changed, 120 insertions(+), 51 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6a3a5df836b9c7..b50d5cfbef8c71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1490,7 +1490,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
-				      struct arm_smmu_ctx_desc_cfg *cd_table)
+				      struct arm_smmu_ctx_desc_cfg *cd_table,
+				      bool ats_enabled)
 {
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1512,7 +1513,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
 		FIELD_PREP(STRTAB_STE_1_STRW,
 			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
 				   STRTAB_STE_1_STRW_EL2 :
@@ -1521,7 +1522,8 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+					struct arm_smmu_domain *smmu_domain,
+					bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1537,7 +1539,7 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] |= cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
@@ -2405,22 +2407,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2429,22 +2425,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2508,40 +2488,116 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain =
-		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
+	/* NULL means the old domain is IDENTITY/BLOCKED which we don't track */
 	if (!smmu_domain)
 		return;
 
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct attach_state {
+	bool want_ats;
+};
+
+/*
+ * Prepare to attach a domain to a master. This always goes in the direction of
+ * enabling the ATS.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
+				   struct arm_smmu_domain *smmu_domain,
+				   struct attach_state *state)
+{
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
+	state->want_ats = arm_smmu_ats_supported(master);
+
+	/*
+	 * During prepare we want the current smmu_domain and new smmu_domain to
+	 * be in the devices list before we change any HW. This ensures that
+	 * both domains will send ATS invalidations to the master until we are
+	 * done.
+	 *
+	 * It is tempting to make this list only track masters that are using
+	 * ATS, but arm_smmu_share_asid() also uses this to change the ASID of a
+	 * domain, unrelated to ATS.
+	 *
+	 * Notice if we are re-attaching the same domain then the list will have
+	 * two identical entries and commit will remove only one of them.
+	 */
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	if (state->want_ats)
+		atomic_inc(&smmu_domain->nr_ats_masters);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured to respond to ATS requests. It
+ * enables and synchronizes the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_master *master,
+				   struct attach_state *state)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (!state->want_ats) {
+		WARN_ON(master->ats_enabled);
+	} else if (!master->ats_enabled) {
+		master->ats_enabled = true;
+		arm_smmu_enable_ats(master);
+	} else {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+
+	arm_smmu_remove_master_domain(
+		master,
+		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev)));
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
+	struct attach_state state;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2576,11 +2632,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2589,13 +2640,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(master, smmu_domain, &state);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2604,18 +2653,20 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
+		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table,
+					  state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2648,6 +2699,8 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 				   struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_domain *old_domain =
+		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2665,9 +2718,25 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
 	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
 	 */
-	arm_smmu_detach_dev(master);
+	if (master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * Ensure ATS is disabled at the endpoint before we issue the
+		 * ATC invalidation via the SMMU.
+		 */
+		wmb();
+	}
 
 	arm_smmu_install_ste_for_dev(master, ste);
+
+	if (old_domain) {
+		if (master->ats_enabled)
+			arm_smmu_atc_inv_master(master);
+		arm_smmu_remove_master_domain(master, old_domain);
+	}
+
+	master->ats_enabled = false;
+
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
-- 
2.43.0

