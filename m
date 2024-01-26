Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607BD20B00;
	Fri, 26 Jan 2024 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292947; cv=fail; b=TDWEjWpHIpNo9HjsdKpRf6OaN0tGgQYxSsBHgUlGd4b2sq5ETBjFqzC4lA/6osmRHdWjdPtnHHZxQoHgC84r7xWU+T6WK23DdBBh0mBz8dIwIPBMQHdMJQtczLztfXxP9eY26XMtPODeM0GOZcIZV7c7XwzFS6BuqlxeWJlLLD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292947; c=relaxed/simple;
	bh=Pg7q+CfwMTXqErkI5hocDCrjhh7zRPL1k87x5vWjKAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vgb4myDyFXWfF8OHeUImsHi+9B4iue0v2rtceXNB7f7UGZFQBr9zQMQ74mpwluG3Q/lYoO63sxy9mTL4tKU7jEF6wpBgIuc0KO/Y5mjbzAhgqW+VDh/h2RWzOKUIO44O2eh7Zo+mfRsfrUHkxtmA8nRzAwuyLLgMPTFW2fGM+fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=McxkKI+a; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="McxkKI+a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmgZo2FVEjTPFXxpK4MoDLy/PzRfmyuJLFj+VYpVVaecbnRCcnC0t5D/kqxGDQCDrCg+VPpoenU/qkC5bC1BNu9ArX6ExETrqbHwgJdOCWhEP8SfBP/w6oN1bkYNyfPRVpvk3tPSKgcvVHbzGqdIn9bCImOTchZ0GfzcRhP9MOU6rOPphTHNUHsqx/dZvhfnqsrJSBWpPQKRsMWZ7t+f6p3jo8WXmiFJwDE7LYCRouC0FCFIvOVi9EvuhO2z0JJkGCqsYsor4p5URpWjjJOkQDin9ofwUOsgMRHFIuNksSwfg3K5iJ2Bf+CYPL1wInXDcLQBCE1J0PxGYcUq3UInxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAV1s2s4/J+XqdCH/nYbzEbFrx1DSlWHZmhbv0SZMB0=;
 b=KeFVdRlgZ1xBtsCJ+DjI9extSIuwLmdxXn8kXHUiNbn9ks3tS/Oq8d6Nxy3P0/GPFNF2++TPlHkP/s3xg+be17Xl3fByt2RmMNm4WJ4gjWPc1xNFsI78sySZwHsXHMoURherkg9Xgaw6Oi2XiESlNE7KcwTujNjUEYGHtSz4Vkgf6BVgWzNBZuO6jZAVd+iPuNR1dMrt9za5ewwJwxOLzOAYKmUbcDmAIPW3oXcLd4W25FUobG0uStNmxC12IYy+9jJHnFpNStW/cr3+o65G3hUOiUgLzdcklx6XDX07t53Ru8QSA8fXJtEhss+m7N4/Hcm2yKo7CND2L9yu+OhZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAV1s2s4/J+XqdCH/nYbzEbFrx1DSlWHZmhbv0SZMB0=;
 b=McxkKI+a45XQtReVMO0bj1zZHHgRO4tkyVmgzS2zit/cLpYcAY3FIG1t5uvpd4FEiXbAB5/WZgl2knLv5BCjUfeMHog68xYPaG+L/sOXewP9CBwDyIWb34+NDZz92ZmvdRkOWBsaNWKwOa4gRWWnc97q4vnvcL46MRGn0YsT313eALT0Al++sJfxT6xJKu6oi05g9jmS8o37ci9056NtwLG813m4FSzzA6euux6YshUncBZrAL7snQ7itkaHjzTkEq/ZTS7fyuoOFTJF3YUcA2SoUDhQ2/vq6pA5Tus2RBKEY6FdQ9VXEOKqQ8selUO9v+pAwjplCtReIrIWwIpzEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:36 +0000
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
Subject: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Fri, 26 Jan 2024 14:15:16 -0400
Message-ID: <14-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: b380d35a-1643-44f0-8ed3-08dc1e9ac8fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HDVm/VgyE/1ki9SiCc7YLPq8ENouHsZ9j/XjQ1eznL7d0ztSk3e9SN7EzYghGH3ogUnVtsVPLyirdr17CgkCSrQjV/AD+z+AIbpaZ8JMHSa5JnIuvtyQIqRJ7rApNRf5ZOWtU8gNSN3B13PG924ClWmmsrCkls5pm39Y11ht/JfjpUQ4R20HDm581XgtoSesN2WxpF2ffOb2zmX4SDqJCLQ+L96KVyjyk1XyQgalSqCw87sQJrLa5unfv7u5xvsd9G4XkZytpEIOeyyjvFc4mNN6Y34O/c2A48irfqh7LGW0ydP27TVJmvtoNPSF0+gfKTbSIj5EQAnWfOd7KAmSsMvjy8yZ/RnWk2BMwc1oeTZW6X5HgUCTpquny/HgqlZbMPcHMK3gJqtAF6dam0AZYe0yS90w8J7pM7YAPfm4Hfrt2DkxvI2q2VNaydQPYA3MdFSUzDJOSCQQVeiPfyuT5+uF9JEbOgQPXa99LCM5ZUNGvJhzLyDwy7bI0gA52nr3SbwE5sQWlG8y6tl/Hm6nNjgbw9rWC2o/Vey/vfcQKWhgiPaSiVis9oop+yae6QTL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(30864003)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PbEQrvVAUgi3+uy1FEvu4GBeaZ+aJ4639w9KQkZcssFrG7Iy82ubUu2oIPOQ?=
 =?us-ascii?Q?wGzJ1nHK7eHs+hm2ueewPJepfR+dgPSasqLtPsmeO6REU52YwqQla9hVkFyk?=
 =?us-ascii?Q?2evxEwHLJHp5/pT1CaIlqsRv2zpEacy9VqEyh4GOf3wqeqwhlhzmXfhGeLMj?=
 =?us-ascii?Q?PLwOojuHBk9/sejonrps7bboyXEZugeVY2axWRA8fKtXXki7z2a3yZRMYI56?=
 =?us-ascii?Q?M+CZBfroN7OTud8GFvfyUf+3i/zfTCsv1ZcuIbDc0a9B9xq0M0sdpqCfskw3?=
 =?us-ascii?Q?iwqUmWESvmYp3jVnvmnxNTZZFaJF/2+FM7u2AdYnAJ+RmZ+X24c3NqrFb94U?=
 =?us-ascii?Q?1gKr+XcYPiexQyqRgI8Uw0qwp1kxKaJUmspbCgmN23gM4rkdizM/X/szRcqX?=
 =?us-ascii?Q?vwWEUOkUILRIKyIKVxyV2/hVtDAkBQHmliSwnHZnl/V3U85LmNcpbRFlWFnJ?=
 =?us-ascii?Q?P9lKNn8XcmyyLNvs7qH8ntle8Ony7z+ZodYzifpF1UkbvkiFJ2V0XiQ7MyjI?=
 =?us-ascii?Q?LGulYLvw/AuI/uZHs4ftPCRzirsRWhOCxjfSPnjpq1DuJcHfWDJgON6aykWf?=
 =?us-ascii?Q?oglILn0tUXTJWmbFyJ1NsgeG1/Fj/6iV2ZxY273W7Od/8qmqEbDPRB2QUVcF?=
 =?us-ascii?Q?6hs1JyNXgBN6Q3Dm8jy9NTiPxBdw0H/58LhqEM1Ukb1N/BnDjsojL3FSohFh?=
 =?us-ascii?Q?86jV58TNwR/7fZg5LOtbZC4FOXzvQgi+t5QfTk0oMKejPZzlAaB6JvVchozF?=
 =?us-ascii?Q?41aXcfbI9AxxxRm5Xp/Fo6UopdI7WlFE/wB9Bata/19axWAg+YFH9xeXYuL2?=
 =?us-ascii?Q?mhadcQ07cYmW1oPo8KInrw0YwZSBI756SmKExhMcFBviEk/SiTSlbFMCjrt/?=
 =?us-ascii?Q?/iAzHBr92jICu0G3Hun0Ix1bPVHC9IGz6uiyupUvOpJttjKCGv4dT74ngIyb?=
 =?us-ascii?Q?avZaTgOhq6nLzhf0dDM60MDp1v/8JSTwP19hVyCs6CSF6OvDnlBT4fWQMCUm?=
 =?us-ascii?Q?uBSw+RB1Jps1bTKOiCVeyqhlAFcEyLLuVMq6I923iVvW+fbNiQ4ru154Ag3d?=
 =?us-ascii?Q?ON/i/grPb3kRg7+AryHQQosy1W9Pfo9TlJ8kvaFf55w5DL3QIwKfXc97sbMw?=
 =?us-ascii?Q?wdqv558BKn/ax+QM6vQ+3WtOp/Qw5kOecAwQE3K16KMkCTUP/pois4zRkL7G?=
 =?us-ascii?Q?JLrm+C3yydwxtDRYdrK5SYEz1r7VrqahFY8bpdcwEb5FS4wJUQcfGDg0dPwF?=
 =?us-ascii?Q?Trc5Ko6Cl800/uSul/K0IhZmBW8h/oW+4WZ4jP0BYHfDLuBxUYv9abfZ5oC2?=
 =?us-ascii?Q?h74VVnTQNPNaKwsH55IuHuMh3zhXnq4PiIb6Udidq+jO47eY3dGYYibpjBKs?=
 =?us-ascii?Q?ZEWKbrEM3gRA/unMsWcOmkEXFGu13CKsdqO9zYXoFbd7/fJ0Nkn7z/Rm9ch8?=
 =?us-ascii?Q?qQQrc98cLnfchIgUzJTMX2vdTBuL+ziaUQCCbOTYnmsWU2H7ON+IwH2cjSty?=
 =?us-ascii?Q?tmflGoG1CNeVwVScLQle0O1zi2LD4aN89PZ1o1DlDxIiTnzJW+dvSnOw98sR?=
 =?us-ascii?Q?An9NuOarDmgfQ10xLpLG0Qrq3mPmZhPNdKwfmBBE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b380d35a-1643-44f0-8ed3-08dc1e9ac8fd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:32.7236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NVfVbLWsdN5IvcFRFLXEoLND3IAOTQJnAll/POiUnR6tEaeEbd4h+UoUQ6HTAlop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

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
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 199 ++++++++++++++------
 1 file changed, 141 insertions(+), 58 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fcacf30a4698d7..b50e56cc3d9fe2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1542,7 +1542,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
-				      struct arm_smmu_ctx_desc_cfg *cd_table)
+				      struct arm_smmu_ctx_desc_cfg *cd_table,
+				      bool ats_enabled)
 {
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1564,7 +1565,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
 		FIELD_PREP(STRTAB_STE_1_STRW,
 			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
 				   STRTAB_STE_1_STRW_EL2 :
@@ -1573,7 +1574,8 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+					struct arm_smmu_domain *smmu_domain,
+					bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1589,7 +1591,7 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
@@ -2459,22 +2461,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
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
@@ -2483,22 +2479,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
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
@@ -2562,39 +2542,145 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
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
+	bool disable_ats;
+};
+
+/*
+ * Prepare to attach a domain to a master. If disable_ats is not set this will
+ * turn on ATS if supported. smmu_domain can be NULL if the domain being
+ * attached does not have a page table and does not require invalidation
+ * tracking.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
+				   struct iommu_domain *domain,
+				   struct attach_state *state)
+{
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(domain);
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
+	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
+
+	if (smmu_domain) {
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->want_ats)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->want_ats && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_master *master,
+				   struct attach_state *state)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->want_ats && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->want_ats;
+
+	arm_smmu_remove_master_domain(master,
+				      iommu_get_domain_for_dev(master->dev));
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
+	struct attach_state state = {};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2631,11 +2717,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2644,13 +2725,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(master, domain, &state);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2659,18 +2738,20 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2704,10 +2785,11 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct attach_state state = {};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2725,9 +2807,10 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
 	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
 	 */
-	arm_smmu_detach_dev(master);
-
+	state.disable_ats = true;
+	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2745,7 +2828,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2763,7 +2846,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.0

