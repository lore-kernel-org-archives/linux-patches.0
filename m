Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7ED20B20;
	Fri, 26 Jan 2024 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292957; cv=fail; b=DtmziFGUrHexFeSwx+XXDT6v/AKkGeVy6f5XLTvmzj964OnosnpGHQ5cprQ3f84uMVB6LVIT6nNWNLriPWqvtf2X4R+Xr4r/av3rTGijjwGh6Jx4X4ZQRNojVA4pn6nmwZ1TRr5Ip+fQtRrUf1wfQlTo9IAzYKSmZzvkjbpFQ2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292957; c=relaxed/simple;
	bh=foP3O7M/mgRwF8wEmBsLp7Du9qkTM1ukTZBgswoj0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JW6qkNEe+0m8ynnaAJBACihHq3tsnt6zYmojbSTjMZ8k91Q7DO2C3dMJ1ZydsnD9SGtLKIGAHeh/8AfCrNdahA97zze+0l+6SjZXGNanwsPqzvPoFLatMQqzSXU4y+cwozjLgcLipZyM1IDmW+lCpYMZ3IdGYrFr+QE9HcUhH3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=swHzlekX; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="swHzlekX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GviknjVz4N/UqKGG3GIclxaXF9Fn4W5sHbdf/AwP1EWzdS/iVm7tlZXSs1xG+0ydIGfziBsEBgTtLivSwCjFwW7VIaGOdL7uHNqxfadHiExzDAP5dXmr2fdAjQ3CvHroSg9OwlQy4UKu1jTiNr54G5IuReQSM3ivhoC5bSu/x1eqDp0RjjUDPq7EAvqZt7eFl+i32FAUzuUdviCyqrY4aE8EM+Map1/Ec7sMRshnT40QwA74nWKQ+zwOoIDtjSGIbTiB5jK+Hi/6pKne1v1nHwqcgl1JZpStnnb63MJY0O2Jwwcib8VU45t+Txbq3ttwie4DLnNm7B18sXE0ukvdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIr/tl2WpEb5tV/5ORenYHK8ctS8SE+NHCt2ai6LxKM=;
 b=INbn17FI8HVHjtihT6fi6kcY+tdDMq46X4TpIB2+hHyhQ/IDyupSNuv6m9ZMv+ZZHc/gFStM5blKg36FyTqBERca5ahCRv4GVzgoez7M7gSsI1W0ixryklg9wfcQl9skANUTcRAqhQjcOfe9olXoUmF40I6EuyTvpHszOlmdkN/GV9shzPjpqAycM1MQz0uRFTPNHYQ5uBek/bXQ8MAYqSct6mJdiQhwcQ49ILUix8PhI8tVDL/4ig++TNAuZ/xdb2wWjKzdAC+VvGQ7JvynOH9dlqeY6XM6LbAV6og/nNo7Oc6OMx24RyUBhmg6ccFkVMtdcD8udfNmv0I0Ut1LDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIr/tl2WpEb5tV/5ORenYHK8ctS8SE+NHCt2ai6LxKM=;
 b=swHzlekXwQ1WwsnD8umRtLjp5Kgif2bfA8R6eF/HyK6R0x5Vgg6wQEVWraSjsAnm0xM5nvJq6+nBo0b9t5KrXakcUrs2MbItTF2qrMzSqZW8pqCD1/VdDyYBoM2lQYvunPblIgqq/D3vayASTaoj1kYh8EGA9blT8HfweKoscxTM56+Y2qQ1yShmZHxrppZFVD9klQivEAydfLq+Dn9w2E0BoAv9mjsPPPOBXNzzrJTh+Zck802zs+5zY62OuAapsNgwMQw37ly/zvxshYAee87cmV4JDZuXxwF5UC9lWlhlrWphiF3l4Y6ZXTsfElZEn0zACsmVLg9w5kZbTZpifw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:43 +0000
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
Subject: [PATCH v4 24/27] iommu/arm-smmu-v3: Bring back SVA BTM support
Date: Fri, 26 Jan 2024 14:15:26 -0400
Message-ID: <24-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:6e::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: d05c028d-37e9-4cce-cec3-08dc1e9aca43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cVE47faRPXLtHtM7ha0l88B6ytGPnlo30EOj8uVpUb2GMdBBvFS/Y/AsUKh3ex9NIgSGKNTG28dOvtmHz2gkEcVeeZLdPKsxc5ve9m6Hh3UsYTsRwp6b582mO4jcZBcSXYHS/j3e+leLH4QnvdU6iWVqK0MhoYnlX2MK2TTHuHwDiUqI8VGHdufLXgWJcTQk1IGrMx09zDKNPkMGF4YDqtxvsy0gj5DvYlisLRfjlot25qSYgophurvjw3Sy+Iiy5rVh0LTm2C2ALMECsueQVyAsoAT8dKms0Abyu6Xwcf1w7TdENwVtn3Qe9VFpL5uRTxKArheO35EPjoIyuFe5zrPrI6EpnT6tD051nQ4Ukqk5/LBud6Jq7yc616b9e5ZexYdNYd2Db3dnmQwUFOcNuvZ2F+cbnV08E5aKePD6aPjHdgTad2LHslpLfv0ctSjR5rP7Y74DcFqfMp9/CAaNJSEbRXlf/gK8wBoVHaAUfk/C9SSkvmrFRHrM6xYnDSJnSi5h7w0GtT1P1G2TGhQKQSRzb1uESidhRYbMDehU7R4+FnBzC90h8IEuPlSpoJlF5rHNejdIZPvFuVg0DhNGxSzSXBZJX757WogAsqiJ1vzNd2w7Eeiwj+zo1YMMv8xt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(230273577357003)(230173577357003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(30864003)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ul5D8lo7DDhMZpL95mgOKnNjsImXBWvlasz8EX9NLmm0VwxqEBceFuKcXD7j?=
 =?us-ascii?Q?TQDqaLro6XKIUSUr/lkJcJ4QKJjhXvTua7Q/Z1Q53XksUTUOhiDpGr/sxcfy?=
 =?us-ascii?Q?NLGfbYEfZ98tgv8/ICU1WFX4o+UoeTjxthGOx0BUeKJ0ZcXSoPK0Te50Azba?=
 =?us-ascii?Q?8hvxIlDNAWL+ZtEwDaNC/Q9WJPTZNqeaaQLyCJvb7KGYfs3JcQLYLfd19pHw?=
 =?us-ascii?Q?kLaGkxcYBMSt/cFVY0aUyoUgppcOz12FARQqZHnpyGBnXhV/sCGMHKTAA54n?=
 =?us-ascii?Q?degSPrbIf5yDxYfjQKWeeGbuuaWxhGksS6+fAHZpIN2hwVXezHjg/o7cq7r8?=
 =?us-ascii?Q?8+kWyQ584PsB/Rix34wVUgFSATf3Vq73sB87AIdyqog72+w6Ch7ReuSoud7j?=
 =?us-ascii?Q?xU7LEKkSe6FLuA5CGVC2P6m2Skbd1cv2Vbu5+zMXFQdIxxt/U2Zv7IDYsU6D?=
 =?us-ascii?Q?CMxBVAzEsE0uGUZlaYmDeBXsc+p3FdwU13HBbiJpDbaUFpt/nRqeHZXQSBse?=
 =?us-ascii?Q?jtYpHJZdwvFvacPfBaM/wgq4MFJTV6qaCCwjN84AgWx3U7i6QMXnkmKeLM36?=
 =?us-ascii?Q?wDtJV3NSTj8WvLFGhslbEsdBgfQB3+pa9ECRASh18BoZD2/2VxyuQy/N4sEL?=
 =?us-ascii?Q?CNMjimbEtfFluT6rRvf+ZldMyjmpdVSE4H+4OVDOqXDcdJtsfsH2byzS/wZP?=
 =?us-ascii?Q?zr3mITzOXN6yEgawEJj4/DztSMRCNyulVEco8cyrkIM7pfJEuzUkxgkRUlAB?=
 =?us-ascii?Q?6IbkbI0CYjCBAC6jPRAjCmTHlnOAU1oryxykyeby9Z9Gj32PWP/JpRWVoA7p?=
 =?us-ascii?Q?lyOHy/til7cLMKGO+FzwFUKUanFOIRGXlHB/dLG06qP7mg9L0rgtvWoFxgPk?=
 =?us-ascii?Q?2OOEyVwHQCSQC89HViwKDkkIttcSvSr4LzRsidNJF3DFSi/iLViFi+By4Erz?=
 =?us-ascii?Q?AIwjsSBw9F/ibo+nYJfqKN7GaetYqcu1AxTktJjAcCtqNkjnNSQlSNo50dnH?=
 =?us-ascii?Q?DcGfWYjD7OTHU8uKbDmDwAy0f8aJsK4z6MRLdb6cVA7t8n4cC6WP5x2oziuL?=
 =?us-ascii?Q?AweXRHElamd6QrTbuq06DjacRBIq5c5XvZt6Ov0fMC4/SoIc6ljeDELvCO2Y?=
 =?us-ascii?Q?03a5utjfqfmzH/r60b0RnnhY+Ayoj2gl71R8eOEkGKMIFw+VYDuSqHqQvzgX?=
 =?us-ascii?Q?/SiTUHEPn1N+GyclTVs1lD+ewH/nQCDTwwvO0wugiMdBeTQtNaH+9IUD91WQ?=
 =?us-ascii?Q?LFuPaw0O7JN6mUAY3OvYmBd45Ez2UYp+l9/fb5heSRO9lgkIXU8Z3TgotvLW?=
 =?us-ascii?Q?Fl10a0Ix1GNDfuX1QCb7McZ1vBUKAyWI0ZmnirykYhLbO/4CaZRai2KI4hHd?=
 =?us-ascii?Q?UGSy8Q1wopkF7AoK8iPYXoDcstEIWVTC9ijzZrvLYdlrIgWWjAeC3sSMDWff?=
 =?us-ascii?Q?4Id9sH3Z8w6DY9j6RUpp5KIU+UtbIpk+D4p+fiNVcbZLJ1QCiBLhZEsXaULw?=
 =?us-ascii?Q?zHA+QE/q8hPyQ0k9wXAG2jfB6Ee5z9Bl9fddtcRZXi+Sd29ZzBXZ2C6tniFN?=
 =?us-ascii?Q?gDqXeVobIRKoReQca6J4CpCUvg6VG9RImau5MzhK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05c028d-37e9-4cce-cec3-08dc1e9aca43
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.8684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHpN3uGLhEVV5F2nVIhrYdtoY7TcGm7IZxIquK9ggy2xyNjpXBOOFr2JBuwU2a7x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

BTM support is a feature where the CPU TLB invalidation can be forwarded
to the IOMMU and also invalidate the IOTLB. For this to work the CPU and
IOMMU ASID must be the same.

Retain the prior SVA design here of keeping the ASID allocator for the
IOMMU private to SMMU and force SVA domains to set an ASID that matches
the CPU ASID.

This requires changing the ASID assigned to a S1 domain if it happens to
be overlapping with the required CPU ASID. We hold on to the CPU ASID so
long as the SVA iommu_domain exists, so SVA domain conflict is not
possible.

With the asid per-smmu we no longer have a problem that two per-smmu
iommu_domain's would need to share a CPU ASID entry in the IOMMU's xarray.

Use the same ASID move algorithm for the S1 domains as before with some
streamlining around how the xarray is being used. Do not synchronize the
ASID's if BTM mode is not supported. Just leave BTM features off
everywhere.

Audit all the places that touch cd->asid and think carefully about how the
locking works with the change to the cd->asid by the move algorithm. Use
xarray internal locking during xa_alloc() instead of double locking. Add a
note that concurrent S1 invalidation doesn't fully work.

Note that this is all still dead code, ARM_SMMU_FEAT_BTM is never set.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 133 ++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 3 files changed, 129 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 080b84a3b78ce4..12c7290e3fc995 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -15,12 +15,33 @@
 
 static DEFINE_MUTEX(sva_lock);
 
-static void __maybe_unused
-arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+static int arm_smmu_realloc_s1_domain_asid(struct arm_smmu_device *smmu,
+					   struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_master_domain *master_domain;
+	u32 old_asid = smmu_domain->cd.asid;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
+	int ret;
+
+	lockdep_assert_held(&smmu->asid_lock);
+
+	/*
+	 * FIXME: The unmap and invalidation path doesn't take any locks but
+	 * this is not fully safe. Since updating the CD tables is not atomic
+	 * there is always a hole where invalidating only one ASID of two active
+	 * ASIDs during unmap will cause the IOTLB to become stale.
+	 *
+	 * This approach is to hopefully shift the racing CPUs to the new ASID
+	 * before we start programming the HW. This increases the chance that
+	 * racing IOPTE changes will pick up an invalidation for the new ASID
+	 * and we achieve eventual consistency. For the brief period where the
+	 * old ASID is still in the CD entries it will become incoherent.
+	 */
+	ret = xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
@@ -36,6 +57,10 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+	/* Clean the ASID we are about to assign to a new translation */
+	arm_smmu_tlb_inv_asid(smmu, old_asid);
+	return 0;
 }
 
 static u64 page_size_to_cd(void)
@@ -148,12 +173,12 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 	}
 
 	if (!smmu_domain->btm_invalidation) {
+		ioasid_t asid = READ_ONCE(smmu_domain->cd.asid);
+
 		if (!size)
-			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
-					      smmu_domain->cd.asid);
+			arm_smmu_tlb_inv_asid(smmu_domain->smmu, asid);
 		else
-			arm_smmu_tlb_inv_range_asid(start, size,
-						    smmu_domain->cd.asid,
+			arm_smmu_tlb_inv_range_asid(start, size, asid,
 						    PAGE_SIZE, false,
 						    smmu_domain);
 	}
@@ -182,6 +207,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
+
+		/* An SVA ASID never changes, no asid_lock required */
 		arm_smmu_make_sva_cd(&target, master, NULL,
 				     smmu_domain->cd.asid,
 				     smmu_domain->btm_invalidation);
@@ -388,6 +415,8 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 * unnecessary invalidation.
 	 */
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(domain->mm);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -401,13 +430,97 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
+static int arm_smmu_share_asid(struct arm_smmu_device *smmu,
+			       struct arm_smmu_domain *smmu_domain,
+			       struct mm_struct *mm)
+{
+	struct arm_smmu_domain *old_s1_domain;
+	int ret;
+
+	/*
+	 * Notice that BTM is never currently enabled, this is all dead code.
+	 * The specification cautions:
+	 *
+	 * Note: Arm expects that SMMU stage 2 address spaces are generally
+	 * shared with their respective PE virtual machine stage 2
+	 * configuration. If broadcast invalidation is required to be avoided
+	 * for a particular SMMU stage 2 address space, Arm recommends that a
+	 * hypervisor configures the STE with a VMID that is not allocated for
+	 * virtual machine use on the PEs
+	 *
+	 * However, in Linux, both KVM and SMMU think they own the VMID pool.
+	 * Unfortunately the ARM design is problematic for Linux as we do not
+	 * currently share the S2 table with KVM. This creates a situation where
+	 * the S2 needs to have the same VMID as KVM in order to allow the guest
+	 * to use BTM, however we must still invalidate the S2 directly since it
+	 * is a different radix tree. What Linux would like is something like
+	 * ASET for the STE to disable BTM only for the S2.
+	 *
+	 * Arguably in a system with BTM the driver should prefer to use a S1
+	 * table in all cases execpt when explicitly asked to create a nesting
+	 * parent. Then it should use the VMID of KVM to enable BTM in the
+	 * guest. We cannot optimize away the resulting double invalidation of
+	 * the S2 :( Or we simply ignore BTM entirely as we are doing now.
+	 */
+	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
+		return xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid,
+				smmu_domain,
+				XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+				GFP_KERNEL);
+
+	/* At this point the caller ensures we have a mmget() */
+	smmu_domain->cd.asid = arm64_mm_context_get(mm);
+
+	mutex_lock(&smmu->asid_lock);
+	old_s1_domain = xa_store(&smmu->asid_map, smmu_domain->cd.asid,
+				 smmu_domain, GFP_KERNEL);
+	if (xa_err(old_s1_domain)) {
+		ret = xa_err(old_s1_domain);
+		goto out_put_asid;
+	}
+
+	/*
+	 * In BTM mode the CPU ASID and the IOMMU ASID have to be the same.
+	 * Unfortunately we run separate allocators for this and the IOMMU
+	 * ASID can already have been assigned to a S1 domain. SVA domains
+	 * always align to their CPU ASIDs. In this case we change
+	 * the S1 domain's ASID, update the CD entry and flush the caches.
+	 *
+	 * This is a bit tricky, all the places writing to a S1 CD, reading the
+	 * S1 ASID, or doing xa_erase must hold the asid_lock or xa_lock to
+	 * avoid IOTLB incoherence.
+	 */
+	if (old_s1_domain) {
+		if (WARN_ON(old_s1_domain->domain.type == IOMMU_DOMAIN_SVA)) {
+			ret = -EINVAL;
+			goto out_restore_s1;
+		}
+		ret = arm_smmu_realloc_s1_domain_asid(smmu, old_s1_domain);
+		if (ret)
+			goto out_restore_s1;
+	}
+
+	smmu_domain->btm_invalidation = true;
+
+	ret = 0;
+	goto out_unlock;
+
+out_restore_s1:
+	xa_store(&smmu->asid_map, smmu_domain->cd.asid, old_s1_domain,
+		 GFP_KERNEL);
+out_put_asid:
+	arm64_mm_context_put(mm);
+out_unlock:
+	mutex_unlock(&smmu->asid_lock);
+	return ret;
+}
+
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
-	u32 asid;
 	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -418,12 +531,10 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	ret = arm_smmu_share_asid(smmu, smmu_domain, mm);
 	if (ret)
 		goto err_free;
 
-	smmu_domain->cd.asid = asid;
 	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
 	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
 	if (ret)
@@ -433,6 +544,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 
 err_asid:
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(mm);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index be95f29e80df6a..dd49da9e533b66 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1274,6 +1274,8 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	lockdep_assert_held(&master->smmu->asid_lock);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2078,7 +2080,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	 * careful, 007.
 	 */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
+		arm_smmu_tlb_inv_asid(smmu, READ_ONCE(smmu_domain->cd.asid));
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
@@ -2323,17 +2325,10 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 				       struct arm_smmu_domain *smmu_domain)
 {
-	int ret;
-	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
-	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&smmu->asid_lock);
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	cd->asid	= (u16)asid;
-	mutex_unlock(&smmu->asid_lock);
-	return ret;
+	return xa_alloc(&smmu->asid_map, &cd->asid, smmu_domain,
+			XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e8aa78fc0b8a0e..ed747e25f2367d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -586,7 +586,7 @@ struct arm_smmu_strtab_l1_desc {
 };
 
 struct arm_smmu_ctx_desc {
-	u16				asid;
+	u32				asid;
 };
 
 struct arm_smmu_l1_ctx_desc {
-- 
2.43.0

