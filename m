Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCCD68B75;
	Wed,  6 Dec 2023 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qzX1GE3f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zfa4Cnaicxhl1IfHdJP9wLRKbvHj4fqqhtHq34QcIa5RNXTcsI7ObK9BOcdPa9yEpOSdWNi3cZKmBxe/2v1y8U8Siv+ffHzyGrN90lRpEVseBTmhppmcGqICjatzvy+1GsrYYPVdibhDgwyYTk0wH0AfsCx2/kGgJpX3DPjB1BEMTgduLVP1Yc45loScLHRenZ99lSdRY72paWmRaD44UubM7WMRGuC4YBj0HiKsWMI8wmKLE8PJNdg4FDw18QxRE2bRfAu/ascu5JjEcOxlRoLfKKNpLX12RfjCRTIdUC04SGL+LV5tEz8PpRf8psQk4xiXWJLXB4YL5/dbO7Tdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3szW7cIHmYMg7ErJje6VuauWlAflJUMe2HWJ/uj75ho=;
 b=m1ncxH3xKI0aFJhDJ5DWw8/Or6cyRD6TVCn/p8ztI6GEuYJGgTq+Wi9IVi/6L2eWtwFDfYOeyAJackAFgJgOf7nDpRPkmGERQyDg46KF7hk5WPbbzlSsoU/It6dLqLDRtBuiZHD2XXG6OjF59RcPlB2jXiDP51lN1hVJxYv6Q1rZ7Kz88o6rBgG8G1v4Y191OywpeFFuU155BBm3uOhPuWtePN/OuTCuXUt+cXyomeKDZphV81+MLvaV4PoUUfI8XPOPNd+bHwme+F25apD52OHNAcCRhdYfS6tf+WkoFfcUnU5uMadeSBMIYJLE8E7Zaj8jal7MK2Jm+vDir53zFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3szW7cIHmYMg7ErJje6VuauWlAflJUMe2HWJ/uj75ho=;
 b=qzX1GE3fJRzXoJXK2/0tblnj6NEcbzfMaejxiRPDLSVzCP54uDVXOdUVRV1olX7AkzfpqkY3b3M02bJ9cB6nGTExG7BSlCbbWNUzurh2t3tdv+bvarTZCjxIht/OAPFAm/pkhB2ju5Y5SmpUH9/qFXEyo+6mO74jdYidhj1o41dYFC7mIiCHfP30oTUyHByLbFC2kx1hikDr1VxrvC/j9KzDftbuO0DFNnEODhJMrAS9rkjDTZzbq6oyw1bs8oVN2wCQlQ873HtewYubZAQz5sGKIzblrZtLp8/MSzrg4TyV7iE1YZOfzljsqYXW87k7yTvVfMcGaHs29SOSTrYkhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:39 +0000
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
Subject: [PATCH v3 15/27] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Wed,  6 Dec 2023 13:28:21 -0400
Message-ID: <15-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0002.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a868ba4-6a70-4a5c-4806-08dbf680c62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Tzt/hnsxo64LxYmTYhb6UrWRV6ZdrJIidvqAu8Fd3oOAUQtuDAB4zm0ndhVyLb0MAYKE8sk2trQIYYeL/Mi+8ozhpG/T6soFosK6EFaIFb2bUi2xkAjK1fXTYFr8TIb/ijBuxM/q8VPjT2EQsxpYvzFyYKFVjXRVacdyNZ3FrC8rOlT2lfDBTzaARhxQJAGbhmlVfaRF7cf3CQmgG0RaLOubBJtwlCJQFn6Al4/t6MHDpL818MzGuSWl43mXo6thO4KwiIPNSlve3dnC/mFqQr70iERppEU5ot2CyZQBwQuz277g8F2YK5cf7Wd+Q4vittoZUlTyRuTInlpcJiNFozncZAyXd5yb7LyiIg8VSyjirLVoJvQtvN337zvNTKF5WiE3YwqOcyrnR81U4Cu/d2TN4HHe8PN0sn3CQuIuI7dtAriThAm+Aaoh0LSU2dI5tZZxggWwv7zPd/TTcfrD/tysP3fSGC+KUA1VESzCmePDX4c65RTNGWcx1IyUJ5O+jE5TdWKM6iNVSMoi+70WjrOmYrAb/BVC+ldccacDeM9A8oCFI9a2PQCFe+vDNJoI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9yY7cbdfm8ICLzVmrDPh/8uO4weZBOVuLWrwdpQXMrkWMabLZ34Qgyylxyho?=
 =?us-ascii?Q?D5s/IYqBOvxnvq2llTUoUPODpm3LmbhkEMztlWDyEX2n0bR1X25Fyqa34neU?=
 =?us-ascii?Q?CpFfJ9P5rE63pRUeulvf56yjMrL5Btyb/jZUnL7RPiYoM0tw2tfwbvI3Pf0G?=
 =?us-ascii?Q?TkilzGtnzEd0gMd2ad/21grwUaICAdJ/loIT0dyX5i4jG7GUTtIMeBs8bBQC?=
 =?us-ascii?Q?t448/ZsQsLGpQ2XNj+uvrMP+Zp7D/ZS3kwMqkJysTlBXoeox5P5v1x/OPMMb?=
 =?us-ascii?Q?d46N0QJPDAhgcJNwSAj5bOXN4w1fV6ZBF89qm704qOPDGLZU1sHYBNaQS3VF?=
 =?us-ascii?Q?mvI1bnE2WAjQAFrrilmlqa5DSo0w9eM69hZ4CTF+ZSDhQkJdq32EJJLXRqfJ?=
 =?us-ascii?Q?k1TIHX/Hqz3cilNDKBfiFhr1gPhpynXJjc2Y+ljzX9y4TCtBTGAzIt38CtSJ?=
 =?us-ascii?Q?DF9J2d4XF0KM8PahB8SpT+JnFS5Tiq/FA4xUZvbTrL6s0qfl8syvrKWOJFl0?=
 =?us-ascii?Q?Z0TDFeJtFpvqd00YZ/x6GFlL69MLHTI9G7Wg/5Kq5h80EceD+oqpG/RmCb0a?=
 =?us-ascii?Q?Cxbgsus0XhmDW4AuK9t8m2i5qMdEE5hbwdGdRnEIUDlWjgQYY6iv6f6NPj6I?=
 =?us-ascii?Q?ZZCyfe3s/lsLDXQOP4bKIsbXmyjxqqP1mWEVstYCM82SFAa9+5g8dFvIAUOr?=
 =?us-ascii?Q?3zJBequ36/Kd9LX4Y7gbVIhxKbp47ZpvppDj8osigXcsIMTOYryDE/KIqG1P?=
 =?us-ascii?Q?W1WQVtx1r6Br7b92QQRm6VkzCYhqeuEUK9hcA0ruYfYrHG9PjAcDqJOjrgtc?=
 =?us-ascii?Q?GQBmGDGRJOZar49hK/iE57cLv1jnG2OGGWK+18bdVb/Qrn3juwbC1XkFJs7h?=
 =?us-ascii?Q?JRWbuMtno5QxiJnL04v8SVJO28C02XZx+kKgX2qTXbKAX/SIHlfK3TM5ihP4?=
 =?us-ascii?Q?KBFugkMLyrFMITZGPu5K7tc0yg48fep6ljg+Eji3MMZC8H7uYzb/CEZGyPDB?=
 =?us-ascii?Q?Nx7WT8FidD1cveyrIQoza1SCMJaxSHFX+DT9YwRlZAlBcxTC8uouWIUbCsSu?=
 =?us-ascii?Q?xtrc3BiXScIitgNcnt/wijJtMibba7iDXepC05RG1UKJCM7kI3QuzfiZN9v7?=
 =?us-ascii?Q?KiPU+WJDFz2iPPkqgpnC7ZpKc+GFAoyUdUct7KpI3shtEDkiA/6eswJAk6bH?=
 =?us-ascii?Q?NVXqLOJF1Gwg3TBGtKlZBHWL0n30XEO4GEvhcsJdUrb0G7kiX82AHSTwcxNn?=
 =?us-ascii?Q?QhGBNI3rle3UQFudvcVeHYXUrEdCkTcr7gdI/w1Z9kCLZtizULetCW6dFq+t?=
 =?us-ascii?Q?j1V+Nk86szZiFCNR56SQEK7jsiYZMy06OneT6ik/Tzqffc8lVgUUhhwTLRu2?=
 =?us-ascii?Q?UWitDR+buOS91MjjSNsYySOBl4CXUDHljpfG7AiavPoocoXI5h5ARUoiITn3?=
 =?us-ascii?Q?14YzTc8yrr6ZLD9jiXTa8xbuIOEmuEAYKUEwD57Hz197MUvgdeo8RX5z9gxh?=
 =?us-ascii?Q?PG2ry5TgRjvZwpq71cGQbU7BdDMCoVIscynzT3+c2SKOzB0GyfBm1l3zbdL6?=
 =?us-ascii?Q?F1mGJIJqd1jls4ks78eBhclzhEGpPct7NPEpqUN8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a868ba4-6a70-4a5c-4806-08dbf680c62c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.5861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riR23mn0eryMqWTC/vVhjWnmKfrd08s714VI06TepkI4tln+5vhQ+AlbDwONe3DY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 +++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index c541b94917d036..4644d4601c0830 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
-		/* S1 domains only support RID attachment right now */
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
-		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
@@ -283,7 +282,7 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, start, size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm->pasid, start, size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -319,7 +318,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm->pasid, 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -398,7 +397,7 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	 */
 	if (!smmu_mn->cleared) {
 		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, 0, 0);
+		arm_smmu_atc_inv_domain_sva(smmu_domain, mm->pasid, 0, 0);
 	}
 
 	/* Frees smmu_mn */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b50d5cfbef8c71..a2263d9c3658a3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1967,8 +1967,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -1996,8 +1996,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2008,6 +2006,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 		if (!master->ats_enabled)
 			continue;
 
+		/*
+		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
+		 * invalidations for SVA PASIDs.
+		 */
+		if (ssid != IOMMU_NO_PASID)
+			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
+		else
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
 			arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds, &cmd);
@@ -2018,6 +2026,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
+static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				   unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
+					 size);
+}
+
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
+}
+
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2039,7 +2060,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2137,7 +2158,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2474,7 +2495,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2482,7 +2504,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2499,7 +2522,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 59bb420af52e28..887669f04b55c1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -738,6 +738,7 @@ struct arm_smmu_domain {
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	u16 ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -783,8 +784,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.43.0

