Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950AB137C4E;
	Tue, 16 Apr 2024 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295730; cv=fail; b=aFJkvrqKisJRewm/O0G+8qE5KWf1VE/kTUJFXMFh2DTkx0QHyjZiSPcsddI4ZNQ4OBBTqykjoKIA1oru5H35Zk9MqZ0Y1Gswl+8UlrtyJpnL94eo4h9YzYGcWaW55ye2oLWAGfpC5eFa7r3/P3dAaaAyMXxgtFla6yxZGQkhci0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295730; c=relaxed/simple;
	bh=IbBxKNbdZkPE9YRNON5Ls4w+DVU4c7/Od1ERJMMu42s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=toGz1CJDsXTqX8PHbkWnDpgAtw1WusMkQ4U69xlIsgVZoFsq3WHKTvOJd6S1DVW+i8iNY4nxp4i8z4oJoQNGU/c/LD9EHHU4pjJ+U2HbLirX+b2bHyFSq5PvFWF31Tdm68Ull8rCD3SZ9C4zmID5/EU9yTfYF9XZ8feHP3QagxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D8dS6m9D; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D8dS6m9D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmcpuXPvD5CzqfYDAwnFhQ2XA/1Dxd8je3VUmGrC8bf0LZ2zHRMasgqty6O8Itvh9a9GpltjKtfzGwFvPp0L28ETV29Nib6iVafKZOsu0x70NcvDQxBAVj1DkrPRSVVJHnMIt9wgpLN9X/GjhgbqrQ/vgJ7D0EfEF0+3W9zkYgO4+5fEvlOcF3ec46AsInuPkQ2K2A4T8idS+pk3o97mkwXQlNDYCDcFDSVbY69W5RRev5ONqIq3HWLLF3+6vC7BY/iciVzL3OEO1QEKKHCUWhbnOszvj2Qmdu2i9HGvsrhs6TiLa5keIZzITSkN305Xky4TT7+H5qjVVvFalXE8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCkCsSGrfmIp+c0bi4wLp1+fU3w7dn66jI22Ex2wIH0=;
 b=Vu4GE2DzeEYLN44U+icmzii+VVRSDb5BEslxe+DIrwnHwIkNPtTRCybZoIMZtwpRKyNY3YR5jX6oN8NaFmVvAvRBi2e3zh5ZgouEeUUpyGjTVNFxOrysrwDGBxuse7OpiXpikCNudSNf28DR1PyOR4BVxtNR01LKKLbXF5tAN9KdkinSSBAPwgp6kPAHHJT0lpkNLM6HoFV4dSOxi0IOW/9aRxFy8IkJR5j+z7F9ba2JKaXLMzpeGF5vrmUq3u2ReoyjjP2MZOUC/IMdbxi1eAOmx2hQZ4xOeug3lnrU7DWM0MfEvHTj+Hzfu9WNT0Esz5JjmODM/SRqAFT3D1HDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCkCsSGrfmIp+c0bi4wLp1+fU3w7dn66jI22Ex2wIH0=;
 b=D8dS6m9DU4p3xzoi3nIQkcZQ8BYXBQ3pCKp3VgLkBwg30Baryj0OOHzgrBe99H/Ngrb97+/+4mpHBBVTRlROqBmjvIlt/MqXLaXtv7tGtMi9cNRw8mDvMjL0n4wtSVKtPCnXkvXsJ4+NYZSRjdUVZmej6KlQOD99LO2lp8icV3HZV/FgGk8a7KuloT1QzxbzWi/7SjqxFhig4a7SZ15/oM7zjyGH68czyUrdi1ZJxV+pcCNLuL7+jBPuN26kalnUtW9e99F3CvyyKY5A/STOur4Nx4IonNwHKwcqSl1Ywq5osDEDuP3NiTLaiLVPPnLgVUSKm4dlN5QsUiD8YFfACw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Tue, 16 Apr 2024 16:28:18 -0300
Message-ID: <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0007.prod.exchangelabs.com (2603:10b6:805:b6::20)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 02bf238b-17e9-4f42-a6bf-08dc5e4b61a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sdhQdcd3LpHSA609P0EdyUgUNYnsI1qEpoHWCmBHDIu/RDaSilpcGvXr6jrlY7bv4I41QQ3RlHaVxQuaEghCWLGSwbo48dvNy9wgoOWq3Skk48ql1tay7hhxleP2W8HG0ehOzfylRoBX6RvRaQftdO4DfQDcc8bJdtw3XWQwtYBvbtnSDQK+y0QIprsM+pxch4zdmIW3jh7Aig+Myu+wZBTZbexKPFzcwXnmmluX7y8Uu5sVOeJ41A5MpvWWNjZpRQuqsRQEUNcj7M1BhEarMe9/fGML+7X1v9V0yPc6WMcVtWGF3LdWWNL84/wd5BqcLUDPMeBO7T/rQZ+QsXGYADf2Ttg4jbwI1dRj7Xak3KToZ6eyiug6wXHPMwkwgf9KxSTC8GZyJzCT58e9T5iM1NCMIBrxabsMo2NLsDsC/LR/45jyoJeY/bvafoFAaOvGYgpiPDJOLdhBgKbzESD6+dQaMpSclwFyVEoyflniyI5NmBUXMYaP6scE57+9dw52S9WFnQORS9BdB+gbHggQChYn/Y4zo2oYBAJMo8r273ynxaY5PvnMbnKieHXxnd8RTljatT3xXRl9Dwk3N5OY99t4JDUc6DU4VMWgjFzympXPI3VPmrxQuCfrT6PAJlwTwRjgEQe1fMnMzhtqfCY5GY8WfQp3ONtIJEBXxtLlu9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?35e2/aKW/Fe1VwSu1y02GT609LpQhPb4JLKVxlWooNSUVUEUG0bn4v1NjQzc?=
 =?us-ascii?Q?r9kICoEfh5Cq87EmBwy6lCbm4c520Wm66aBe519CJg1qHnASgvVC2aA1P+5d?=
 =?us-ascii?Q?O6XGj+yjBGLJvXcRFM6IdZAb5wOXeylM+W2CgOS5zZWu1+fWaQAqK746/Q7e?=
 =?us-ascii?Q?nO58PGXhhTCBuoR5aHgoA82LXnHqFSBfZxiXbvf9uKghl4v7KEbY6NmabQbv?=
 =?us-ascii?Q?0d9GLI4yZ6FU31KVkYV1339sjnYWurhyCOHGfsGqjxjLfIP8yrU0A3gk0upo?=
 =?us-ascii?Q?n1pK44xkEK17zzF3ulIiX+G1wuzn4NOfDLgZ3HtUQOwhvbnTFtCjrUkxewHE?=
 =?us-ascii?Q?ICQTvS0nmL4fakIJlJhXBHbCffxzJ3dfNg7oO2xoz7zygy4Dbalt7pOqtjfb?=
 =?us-ascii?Q?wkui3+KHbWD57nzx8C7mdu3kO1C4quSkzPoO4f+vK7gaye9kA3fwqfolXne3?=
 =?us-ascii?Q?dGVSmihAY3IRrOH6q6H+Ils9se0SLyX87o7iZKQqag63Yshm6m8jQaW5U6tK?=
 =?us-ascii?Q?6cVIQwNR0zHGFja7cB8BMYY41o1IhPwIAV/rpZ+O38JfTUTSqr/6UYVMN3TA?=
 =?us-ascii?Q?gJE6nF+TRbCC526Y5uhR36sHpjbgAs9OorTmGiVhRb+f5JkQ19wkWO4GLYtW?=
 =?us-ascii?Q?j9Qd3GYAtMZkgz3fKGOxsAdtg6FqXw7/QxyWT4RITRN5l+z5NJ9d63XHKpln?=
 =?us-ascii?Q?JD4C7hEBhiWjqezTudrFJQkNqh+z/238dppYhbv0qlvswSjq4PycteVRZVlf?=
 =?us-ascii?Q?dn+/62b5V81V5NnnhQA7384AfAUGPvz0nafhOZhaEwhtdJcYUAWUIuOcsLHn?=
 =?us-ascii?Q?0pzw//lm+oporsRF6zhrW7UM6H3UdrMPfpeFy+0MyRkuMRoCNxfhbUTyfMt6?=
 =?us-ascii?Q?/sb+JoTBE30YV+WHaWZOWKGpJdq0/esiagn2lMrFqypNUUi05I3CM0Y43NgG?=
 =?us-ascii?Q?CoRocFwRu7R6/pZ29vKnrya0oBkt75/t2tA6IfR6i51Ye0MZsa/M3equXiSk?=
 =?us-ascii?Q?4HaOxTeTw5P6641i0V1evqLFQdX6OangsxEfBdpFzs+EX2DrVm03VfxqKnRj?=
 =?us-ascii?Q?SAATmRA3FuPtqIYHnLWwc7c74WSKpDhNsRfG79jUxRayZmju1UFMeTTi0NAF?=
 =?us-ascii?Q?qARH2OAxmP+hc9vPJend9WSp1oDczmJwG63eAzpDsuQpG1cj2BCWS/q6y3/s?=
 =?us-ascii?Q?lEF8ymqeZcH6oGSVh6/ajUGvAt/JkN2H4cyPbFQIIRqr4U8qfeme8bXZjChy?=
 =?us-ascii?Q?tG+axOEz0DS9OLCphuNp6f8iMfKTLXZDk9X9XKbRcrM+WMRSCFH9V6B81auM?=
 =?us-ascii?Q?AyHwfkNKZG8I4kQzL9p80sBDJ/E7cSG3350OmMjvPoYkl2iEWADh4kuDhphk?=
 =?us-ascii?Q?w65ws4PTfTU0KyYukobxzoEaON6y5ATUxJGLsWGIny0DUK0lPuS94oLnBMDi?=
 =?us-ascii?Q?MnPVgja2sZDl97t6ETkSCINKvdtbkG2SHfNmvSoowez+kvGztAjqvKlJcyub?=
 =?us-ascii?Q?VHsS2cjo6lFEAjKEjKqQnNAo4h1RHdiK6RjZLs4eJk9YJ459MN/LOMLPyCdV?=
 =?us-ascii?Q?aU7UhjlmcKJSlh7ULMz/xQXtvwEG8IWUEAw1VPhI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bf238b-17e9-4f42-a6bf-08dc5e4b61a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.6604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjAwflGl51V2xTIBq/1AMfS6FR2KUXwYLZr8pbj8asWVefaMqMRexlE20nJmWK/9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
locking assertions to arm_smmu_alloc_cd_ptr() since
arm_smmu_update_ctx_desc_devices() was the last problematic caller.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 156 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 103 +-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
 3 files changed, 108 insertions(+), 158 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7cf286f7a009fb..80a7d559ef2d3f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -34,25 +34,6 @@ struct arm_smmu_bond {
 
 static DEFINE_MUTEX(sva_lock);
 
-/*
- * Write the CD to the CD tables for all masters that this domain is attached
- * to. Note that this is only used to update existing CD entries in the target
- * CD table, for which it's assumed that arm_smmu_write_ctx_desc can't fail.
- */
-static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain,
-					   int ssid,
-					   struct arm_smmu_ctx_desc *cd)
-{
-	struct arm_smmu_master *master;
-	unsigned long flags;
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		arm_smmu_write_ctx_desc(master, ssid, cd);
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-}
-
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
@@ -128,11 +109,86 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	return NULL;
 }
 
+static u64 page_size_to_cd(void)
+{
+	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
+		      PAGE_SIZE == SZ_64K);
+	if (PAGE_SIZE == SZ_64K)
+		return ARM_LPAE_TCR_TG0_64K;
+	if (PAGE_SIZE == SZ_16K)
+		return ARM_LPAE_TCR_TG0_16K;
+	return ARM_LPAE_TCR_TG0_4K;
+}
+
+static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+				 struct arm_smmu_master *master,
+				 struct mm_struct *mm, u16 asid)
+{
+	u64 par;
+
+	memset(target, 0, sizeof(*target));
+
+	par = cpuid_feature_extract_unsigned_field(
+		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
+		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	target->data[0] = cpu_to_le64(
+		CTXDESC_CD_0_TCR_EPD1 |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
+
+	/*
+	 * If no MM is passed then this creates a SVA entry that faults
+	 * everything. arm_smmu_write_cd_entry() can hitlessly go between these
+	 * two entries types since TTB0 is ignored by HW when EPD0 is set.
+	 */
+	if (mm) {
+		target->data[0] |= cpu_to_le64(
+			FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
+				   64ULL - vabits_actual) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+
+		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
+					      CTXDESC_CD_1_TTB0_MASK);
+	} else {
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
+
+		/*
+		 * Disable stall and immediately generate an abort if stall
+		 * disable is permitted. This speeds up cleanup for an unclean
+		 * exit if the device is still doing a lot of DMA.
+		 */
+		if (master->stall_enabled &&
+		    !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+			target->data[0] &=
+				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
+	}
+
+	/*
+	 * MAIR value is pretty much constant and global, so we can just get it
+	 * from the current CPU register
+	 */
+	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
+}
+
 static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 {
 	u16 asid;
 	int err = 0;
-	u64 tcr, par, reg;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_ctx_desc *ret = NULL;
 
@@ -166,39 +222,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	if (err)
 		goto out_free_asid;
 
-	tcr = FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, 64ULL - vabits_actual) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS) |
-	      CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-
-	switch (PAGE_SIZE) {
-	case SZ_4K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_4K);
-		break;
-	case SZ_16K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_16K);
-		break;
-	case SZ_64K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_64K);
-		break;
-	default:
-		WARN_ON(1);
-		err = -EINVAL;
-		goto out_free_asid;
-	}
-
-	reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	par = cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par);
-
-	cd->ttbr = virt_to_phys(mm->pgd);
-	cd->tcr = tcr;
-	/*
-	 * MAIR value is pretty much constant and global, so we can just get it
-	 * from the current CPU register
-	 */
-	cd->mair = read_sysreg(mair_el1);
 	cd->asid = asid;
 	cd->mm = mm;
 
@@ -276,6 +299,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -287,8 +312,19 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 &quiet_cd);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		if (WARN_ON(!cdptr))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
+		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+					&target);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
 	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
@@ -383,6 +419,8 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 			       struct mm_struct *mm)
 {
 	int ret;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -409,9 +447,13 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
-	if (ret)
+	cdptr = arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+	if (!cdptr) {
+		ret = -ENOMEM;
 		goto err_put_notifier;
+	}
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
 
 	list_add(&bond->list, &master->bonds);
 	return 0;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0aacd95f34a479..d01b632197c0b7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -84,12 +84,6 @@ struct arm_smmu_option_prop {
 DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
 DEFINE_MUTEX(arm_smmu_asid_lock);
 
-/*
- * Special value used by SVA when a process dies, to quiesce a CD without
- * disabling it.
- */
-struct arm_smmu_ctx_desc quiet_cd = { 0 };
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -1201,7 +1195,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1224,12 +1218,15 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
 }
 
-static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-						 u32 ssid)
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	might_sleep();
+	iommu_group_mutex_assert(master->dev);
+
 	if (!cd_table->cdtab) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
@@ -1345,91 +1342,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
-static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
-{
-	struct arm_smmu_cd used = {};
-	int i;
-
-	arm_smmu_get_cd_used(target->data, used.data);
-	for (i = 0; i != ARRAY_SIZE(target->data); i++)
-		target->data[i] &= used.data[i];
-}
-
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
-			    struct arm_smmu_ctx_desc *cd)
-{
-	/*
-	 * This function handles the following cases:
-	 *
-	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
-	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-	 *     CD, then invalidate the old entry and mappings.
-	 * (4) Quiesce the context without clearing the valid bit. Disable
-	 *     translation, and ignore any translation fault.
-	 * (5) Remove a secondary CD.
-	 */
-	u64 val;
-	bool cd_live;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr = &target;
-	struct arm_smmu_cd *cd_table_entry;
-	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
-	struct arm_smmu_device *smmu = master->smmu;
-
-	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
-		return -E2BIG;
-
-	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
-	if (!cd_table_entry)
-		return -ENOMEM;
-
-	target = *cd_table_entry;
-	val = le64_to_cpu(cdptr->data[0]);
-	cd_live = !!(val & CTXDESC_CD_0_V);
-
-	if (!cd) { /* (5) */
-		val = 0;
-	} else if (cd == &quiet_cd) { /* (4) */
-		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
-			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
-		val |= CTXDESC_CD_0_TCR_EPD0;
-	} else if (cd_live) { /* (3) */
-		val &= ~CTXDESC_CD_0_ASID;
-		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-		/*
-		 * Until CD+TLB invalidation, both ASIDs may be used for tagging
-		 * this substream's traffic
-		 */
-	} else { /* (1) and (2) */
-		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr->data[2] = 0;
-		cdptr->data[3] = cpu_to_le64(cd->mair);
-
-		val = cd->tcr |
-#ifdef __BIG_ENDIAN
-			CTXDESC_CD_0_ENDI |
-#endif
-			CTXDESC_CD_0_R | CTXDESC_CD_0_A |
-			(cd->mm ? 0 : CTXDESC_CD_0_ASET) |
-			CTXDESC_CD_0_AA64 |
-			FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid) |
-			CTXDESC_CD_0_V;
-
-		if (cd_table->stall_enabled)
-			val |= CTXDESC_CD_0_S;
-	}
-	cdptr->data[0] = cpu_to_le64(val);
-	/*
-	 * Since the above is updating the CD entry based on the current value
-	 * without zeroing unused bits it needs fixing before being passed to
-	 * the programming logic.
-	 */
-	arm_smmu_clean_cd_entry(&target);
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1438,7 +1350,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1536,7 +1447,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 99fd6f24caa818..8098bf8836a180 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
-	/* Whether CD entries in this table have the stall bit set. */
-	u8				stall_enabled:1;
 };
 
 struct arm_smmu_s2_cfg {
@@ -749,11 +747,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain);
@@ -761,8 +760,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

