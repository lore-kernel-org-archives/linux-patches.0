Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B467D08F;
	Mon,  4 Mar 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595871; cv=fail; b=ADZDwhodLo9NBNClm4ijQ++R5GUexRheqvzoGLTjYzmXdWReyCngwrgbpqky5nPFQWpSwDjHUfjMSfn8fmz5LWzMRxmxlquvhFzhMZlMJJ+YSDwSNiwKdth+gSvLsYf1/+/zyRlvJi6G33KqloOpOTn0xj9CNT3W+1OwvxqWcwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595871; c=relaxed/simple;
	bh=V0m6ELOm4/WPs9XY1Il8g7RGfj13LsRQP/Orh/iMKVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UhglVj9Gbpq63krEoKJZHcnNis7iBMo9RGGNXck+RNlWZmRBlASJssPPVhtN49LHJlq3qnAiug6ZpLytwhhhVHPvLWvS2b5iH6ozPMuWzwF/aVj+vXr2CiYKsDCRB82FUuKE4lJUa8dCa4Gc4eW6WUCQXTzUHlEr977I/pT4viA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AAFJdmjf; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AAFJdmjf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obFES02c9dKUSIatvuF640Qk06jnzboXiMFVDAvZaO98nMiv6dXmBnu9GPAOHtRDTHoRvqXiE7ig3ny+ynN0oNizqkE0RsGzBSfcG+t4x2/WCqiNlYDLt/eW/If36Tjbtjn9R4gAmy8DsbE9304U/svLUoiGhrXEetaa4U3jIz2IyzLP8zreWYWxkaxlxGZUfvORrpYyFLcn5BM8cFcmYzSJ0TabtBEgzE7LQFheifu8grlAwf1ocJWpUkPmSCim92QK+NzdvMRhNGWNmON3bNr3cm/2IiTfcXXf+U8GgeM/VTuYciSMvvWxh3l75AD5uDloQ17pz31ryFkcNksdWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+y3PgZadW1z8J0rINMeF4elv/JhyAiB81AEI3+L2ZIQ=;
 b=XmKKFtZRup8MtT8K+ArW/+kr6Fc8vUDEJAoSxv0USdTp3xSP3FGDM7vxkzvL5BN/PZmHxgMNePRUtqI4Dkg+jz9GrgtOgef3NC+k832wcawaIeUb7/5M81LO02drXZUyyCPV+T+FgJfkPkEdhNTGvMaZ/fNiMTsbc5ea5LbAQDprVpDw6IxRD2Ysa5zjDWZYOvy/CASmacro8C1beHm78/o1GNepZ07eWYFo4kUtDswtYl798ayrVBQvR3KfR/4/6zbnIHl9y4DLmAMD6yvrEhJGi2Qd47RPdJkdKlaEvhv+WJQrGGZOOGq7qdWDyuIZAW7bERK3g/VcajJGz+ukdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y3PgZadW1z8J0rINMeF4elv/JhyAiB81AEI3+L2ZIQ=;
 b=AAFJdmjfquGoNr0DSfSxz97fjwkLeETk1kRwSXGkKqgaNLy4wpfW0GdK6cY57ud4YnhJNVs0ttolgS8nlNZV+7/4/nz89+0WbyUeltJqWhk7TEkPPu753qzRvWyo0QRdAWGIxh9RBjLoXuV4kpN6RlhQM6x6diOwdGNkuw2FKgXwJjMeoAaHRPelsIb7p5nWKptEP34P6GCONRy3fyrPUZ3bBrQnb3meEMzJZR7YFAG4J//rejIdBjUnwdRGP7nReq4lVURy4KRW4VVoTymy64XVmoLNnFjGscQ2+chFXbIiHuw769eYj8/1b/H1gUChJgAKbY9H6ihNnR5uhDimYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:19 +0000
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
Subject: [PATCH v5 10/27] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Mon,  4 Mar 2024 19:43:58 -0400
Message-ID: <10-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E13.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 189133f1-1f6f-4ac8-2610-08dc3ca500dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nIaWmP+OhboA6wpd/9Tc8oV3vaMUXfz444yWkji3eh3Z1EKvUvKdqAxUEwKAId/LVSqYe93S9XWm0cRnWbAFCAbZwmMsYPoObW052RmfEZpvf4rygY5iZ/VeIHLBXsiewLzgM+gd7aGTqwiNQxfXP8lecsfmkyz3bu+0o81VtjZSPj3M40+VaH8HY+CaO8e06W//l8p4Vt6GsUI9P1mj2CWR+/teJArPCO1HLlFMEBWeArxTt3NYCF3dLyOtNS/yVgFeLXfqtmALhWb7zKTB9lmNBxMEQEO/goZ/h0DHul4Lfj6Ug8ChxTy1PzsUxBKkjIHrv8SnVUH7wnt+488Pz05uxNbgaF/0BauAejF4aUBDpuW9Q1NzxSEIrLM0Qv/SVs9u+Hq73w4WZLOWH1YgADS3OdsGDmvzGd4QM3Bwg3NSmHjFBywiJQOR9Ft+FteOZGAkUlbVa1hdOUiQG0279jhG063NoA6mQ1mmhN6kWSLPQVVPJmTXNb0dvI1CRERl3/lTfzQK+kywAWZR502nozqEIOfI7moUDn8qztTYa+6Q9jMOLNzMRX9WwNkgJHgbtOGsKM9rDbn+7few6uA2HfW8/x0O/gr4SdxtE6cFKpS0g5CrDbWAbdn3gtoyEy2QVfB/i7gMFJIun5nvlucug7B7He1LrhV7b6ShxqQS1Tk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o3DmvEZtzrNdZf/RSK4cufTxt6YqpKEHJkCP/snwNJxDSv38nbITidp+pvOv?=
 =?us-ascii?Q?g8Zpr/jFLaRmULOGpOEnrBtgzhfr5+Yk+uFC40tatPnQ5ioW2Tj810XNGdvv?=
 =?us-ascii?Q?8j6Jty/AnE53LN+NF/8S+6EsrTAA/SfOpXePykZhodhswcue9lCz3xcMs1aL?=
 =?us-ascii?Q?jr6MINv8p6G8PZLqpE32C3J5CxH2hivisvg6uknVLgA6tSgKVFvgA1hKmGxU?=
 =?us-ascii?Q?15Un4bhuSJDVk+WOflzjpEkEKCt5FmoKikuxZSu25P9IkFF0xmfxxoXt1lG2?=
 =?us-ascii?Q?bO6K6LZRqvKNH/b5bQw7OPEZO3ZIOo1F8k/+rY0s++HQPxz2cutqaDnkchJL?=
 =?us-ascii?Q?OrnS5NR4LCfDBUL0q+CpFvjq1vs5K3Rr12CYXJdFpj3ylGT/GYecDLe+dJKx?=
 =?us-ascii?Q?YPoueV9+uiNuVGyWEJkOZ76cd3ZicLpLzHZFarrOkSF5W08AVB1wrNe1spQt?=
 =?us-ascii?Q?pwefEg/4i80bz6oZPW4jhf1MpxR+xO2ErUo4J2dDYkLRRR9mVO2P6nw8lvpc?=
 =?us-ascii?Q?Yh8lpUg4c2O01HbA8j5HjG6GUqTjsnCx01E4OUHGpJ/aqWsnq0LWuOEEnDMb?=
 =?us-ascii?Q?EwIPaBBLRM0UIwYpX2+kyBaiAEgV190dwBXqRCYzXR483qenl+a5pSmNwwl8?=
 =?us-ascii?Q?JsNWI6zbCXyEXufc0Bono1XGERNettZZnhzIWlnRBp5nr7idIv262kO/BImQ?=
 =?us-ascii?Q?eiY3lBVkzEoDp8eN5iZq19QEI4uo3ypE05yokx4RxBIWYOANBoC2hpPe4uX8?=
 =?us-ascii?Q?SndIriIeZdQST33+96/DmaErQqn+ICo2rOM1w71bxIFjLcE3Pj/ydjTqkJo8?=
 =?us-ascii?Q?s+WzEDSyrHK8LcSzhlOt8o2g7odnXovbjG+nbirzthBgwkw/QPdQaneZ9vj5?=
 =?us-ascii?Q?gu/u54J0KIIbId4sT0Phh5KhI0Np/RFUu6qnj+Cxhsq/mp9PtASeRe8+MhNr?=
 =?us-ascii?Q?ilrvhctJqS+Jn3glpT5/Czhyp2xttKxljQwHNsHZ42QWW1WtZJVfVwd/LH7Q?=
 =?us-ascii?Q?uAMnr0r8krSs/Tti1JP1usjuxq7ivAqsmnVh+94cCGu6hmaau+KNYyM6Hcvl?=
 =?us-ascii?Q?IIhx1iEkgtZGsyuljVT/G+p58Q2Kc7kEcOTSMFxBQk7iH4YJguRG6SbBDrUl?=
 =?us-ascii?Q?6KhFPI/gcmme/79qj5s1wPfQpw9G+AOEEt5EMJl2beimrRERZyREl/VoWLBy?=
 =?us-ascii?Q?EeL4+fey7NRDnRipGJJ+80h00zs+t9Ee+zh0IPmal3BeFtQNhmgdy34pNkhn?=
 =?us-ascii?Q?Zx6laoA+aiRKXQrRlioG25CKPOCuQ92VOl/DrYzi0nk62td7+wu2qt/tQyAn?=
 =?us-ascii?Q?tj5WTld8v9uaGOsct2dgBNwD3yXM/ujAxX96uBilvfFud+11qkG5YZk118XU?=
 =?us-ascii?Q?o8g/Vz8nFAhQRub9+6DzMGbSMkwovE/DdUjen6Rc49Vp1CPbIxkCIfK9/k6Z?=
 =?us-ascii?Q?yxMlNbW3xwgHKxYOj1OOXgJzxNtO/a0cjz0Gbwn2lIxjHbEtYAXY6Spr3oUc?=
 =?us-ascii?Q?k3Yp5+tBGDG8lR5iBqBFrCxKLXNs2ZBcWwsJw5wPXIP8bkB0nOVliAKo6mNM?=
 =?us-ascii?Q?i6b9hgaB4Iendu3g5Z4fZS4hcnOlxkyiNSFXJpA9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 189133f1-1f6f-4ac8-2610-08dc3ca500dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.3562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDLjG6kP6TcBdeH+fmHVvRRYUKZcnKQYWG4PgXMGfViYK2jv9Wu5q/YrY8TvUoOU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Remove no_used_check since this was the flow that could result in an used
bit inconsistent CD.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 156 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  95 +----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 -
 3 files changed, 105 insertions(+), 151 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 6acc65f6d00a71..159350a78d4cf9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -35,25 +35,6 @@ struct arm_smmu_bond {
 
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
@@ -129,11 +110,86 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
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
 
@@ -167,39 +223,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
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
 
@@ -277,6 +300,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -288,8 +313,19 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
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
@@ -384,6 +420,8 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 			       struct mm_struct *mm)
 {
 	int ret;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -410,9 +448,13 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
-	if (ret)
+	cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+	if (!cdptr) {
+		ret = -ENOMEM;
 		goto err_put_notifier;
+	}
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
 
 	list_add(&bond->list, &master->bonds);
 	return 0;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 39081d828a2132..50d17e3ce0a956 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -57,7 +57,6 @@ struct arm_smmu_entry_writer {
 struct arm_smmu_entry_writer_ops {
 	unsigned int num_entry_qwords;
 	__le64 v_bit;
-	bool no_used_check;
 	void (*get_used)(const __le64 *entry, __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
@@ -92,12 +91,6 @@ struct arm_smmu_option_prop {
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
@@ -1060,8 +1053,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		if (!writer->ops->no_used_check)
-			WARN_ON_ONCE(target[i] & ~target_used[i]);
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
 		unused_update[i] = (entry[i] & cur_used[i]) |
@@ -1070,8 +1062,7 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update[i] & target_used[i]) !=
-		    (target[i] & target_used[i]))
+		if ((unused_update[i] & target_used[i]) != target[i])
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
@@ -1167,11 +1158,8 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
 		 * in the entry. The target was already sanity checked by
 		 * compute_qword_diff().
 		 */
-		if (writer->ops->no_used_check)
-			entry_set(writer, entry, target, 0, num_entry_qwords);
-		else
-			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
-					       num_entry_qwords));
+		WARN_ON_ONCE(
+			entry_set(writer, entry, target, 0, num_entry_qwords));
 	}
 }
 
@@ -1219,7 +1207,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1290,7 +1278,6 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.sync = arm_smmu_cd_writer_sync_entry,
 	.get_used = arm_smmu_get_cd_used,
 	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
-	.no_used_check = true,
 	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
 };
 
@@ -1348,75 +1335,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
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
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
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
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1425,7 +1343,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1523,7 +1440,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d32da11058aab6..8eabcccb9420ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -608,8 +608,6 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
-	/* Whether CD entries in this table have the stall bit set. */
-	u8				stall_enabled:1;
 };
 
 struct arm_smmu_s2_cfg {
@@ -747,7 +745,6 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -759,8 +756,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

