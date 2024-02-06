Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99689134747;
	Tue,  6 Feb 2024 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232390; cv=fail; b=Dlc572GSCosW7kC4PK4zsHChOlDwogS9NMOmteEF98zBv8/62mtEKycsIM6ciNi5aPCjNu2/X9RmGVcd9hAyCyA5altXs/zy0hoLSoD1byAZnbok0bHcDH1FL9TseR5RvO9og4mUhN7NjWQFQgJdOdcxiCBq2ZaozA4i7k8NQzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232390; c=relaxed/simple;
	bh=BjnSU4gT6uPmukCcxKSHsn62U1ntioeRcNWc7RTdbLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BxHsgWx0TIJmZNsTDWtiMqM24ZkevopPQU8UcgQbLv0xYloBwf7ZuVtQK0lO/SD+MgGBZw34jCfhjv8xHRCRmV7R9TYFM5jC6CgaTI8Mt7YtviUrINWlq7rXUDUCPJlOnRjdug/G8ygVTR6ZprAFSlAiSnK51OwkJnR4KUFQjkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=djuPwLVv; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="djuPwLVv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaAJ8J+KEji5xEQxuDWt8mdhfMBZCl54ta1mO4UYrJnn7ON3SDE+EYCDL0OYXXL4e2jiD4ZkPNgTOrY3K3SLg+LyBB5FPykp70hFpJnOtLyuuOkqdZkvzJv9jiumMMOxxfYhcqAgXA78vV7GPE6q0B5C8psZLkZsjD9LWa/GoKG/iuzS2IOzXnqJxgUht3k0bqCts4lG5NQfscQ9pIzt19971sIfyA3NMJOcFt0oZvy6G/qRWpbX7lyygpXjRRpMFuhPl5MS8HX4hfTBTRWFI/dYMu1rPtQtlLGNbAuTltje7b2+utEnM0GkromcTo7vncxB9TuaUFzTFLfgXeCEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATPzBLtDX0KwUQwxQ9j/aCeqHcWInQAliwQPfgKxHJ8=;
 b=hGV92Efwh/DFAOWBPvMVq2dOvVqVQ0asb1hdrSaQuXUOzbMPJxeBzJ6TKAwmIFzn/qaMWo/0G13y+nIkKDWnHbbdUsKAUeeTSyEPblpit0Rm6KERbJREsk8gkmmSmfPaVa08/dsIzJ0qIxCvgPI8zlCQ8kLRn9/LiVyAgs5kh+8sH4ChIjAnPJS8Ih15ipGg1LvoplnYTXHKN5Z0lPtFFtH8WARC82BO94lziNZx/xgzA/arSRfREuTJvkvCQvE+Uwd+BKaz3csHYU3OaJQ9hAQRbpe/y+UqnBH21ev2DpbEeO3nSOE8I9o0kzeVtb7X3fPfYdb3bF+PGQX4MQ4RYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATPzBLtDX0KwUQwxQ9j/aCeqHcWInQAliwQPfgKxHJ8=;
 b=djuPwLVvWWJ2yO7jBWJQUQxBmrVr1IUn4knRFXXxaHrbp0B/J0CZofTujzFPCtEI7JnFNbytZBTBMSly7mUc+MgJvRS2fs1H1pUMeumFxuFiBQXaw2xtt6XxUXrsRcqoEUSb0//95FzsgDCWTscxOqkyFJ2qgSH+YWpGBs5FhP/JcIlHNn/PMU7M8SPrb7XWZIb6YwHfmhhz+O7F45QyWAq9mnptQ6ha5zlthOViqtK75LGxBr5s78PZbUcYNhKkeKDosnl5Mkja6aJX/wd5TyJnw08FnBhem6kEwQF5Zo/uVckWy1oT62AnuUQQp0jKMtlRaFmhfwKh8+CJ7kXoZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:00 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 04/17] iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into functions
Date: Tue,  6 Feb 2024 11:12:41 -0400
Message-ID: <4-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:160::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 6319dc91-7147-4e23-1b07-08dc2726188a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JI2a8vom1MnG9cM58g33V1S61fFI3nAsbNvx7VuT+9vjsp/4OvFBBzkUjX42RJJPDVjVMq2f/S04jppfJyyMT0we5NOLUwk8u59luC4X5994R1iI3t086j6I1GYBVCIr7SD7J92W6a91dhLvgn57QHT+oEMAAPwPODFMNxfneFlhsU4jAurDKVi98Z/SBkclzxT8Ki5VNt0Cb+PGyl2sBLiKDmsy/e6sa929pCXnOZp5O22kDeRqmKmOm8Tu6t6rZWoRQ7WJjvFgGdtrOpXivdRlZT+YT2bVS1jNAX0FhYn+GXJRy5/+qna48CvTr1rKzqYfrpf+OZf2xOktGaRYHlSVjjJr71+vhHoDoIcvDjzipfsZo/qSdlKOjuN8TuF2bVzvn8JOBjZy4uRCZ64z+2rDby+tB0VcelNUQ57ftofqfccNxCS3c8NDYoJ3fZCOaMse7fChKb8Q6fB6dShEGcNqim+jYP83y+tcrPb8da1eVSoNPfywYcenxWHcNCN99fOZnV+7mubF1HmeNRh6E/yJrg9Uoc+Kin0esjA45eQFDOzj2wzc+Uww4fChi6pv7X9j17FuuCw2OL2iScdMjeftsqzSPz4B2yXEdI9MN9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?usifx7nyjWJKMy74y6d1UtADM0xZD/URwEVQUdJevo//8CgcFtpgzN0cOt49?=
 =?us-ascii?Q?czqjWbn8hguLWMThJncPnuMZdCGWhm9ommWBdM8KVopLQLRFhBUgEWsBpEBm?=
 =?us-ascii?Q?DbtERsaExLYofmkEeMC9zyynft0s4uak1UvheC/WbuMgWupRRYru0L9v5I85?=
 =?us-ascii?Q?Ww/hfzq9yr6ENOs2HdcYo9mkS5borq8DvzQL64GzCTC/uoAoupnwBuuVemix?=
 =?us-ascii?Q?r2e7cgjpPI++vwe6UYgY3AjkjnaJHpwSWcnwc0emQLd4SV9d5zQbMkYh4jaj?=
 =?us-ascii?Q?sNk8oVav/M8c7j4ZyQXD0jyJrrvbnN/VOMEjS+8vtobX+PpuRBuYt2G8E5UB?=
 =?us-ascii?Q?zhijrOkptKYQZhustoBXZmUTycUYo/x4CyAayyOwlfa03c49zh5tCh/OYeAv?=
 =?us-ascii?Q?tb4g/OIxUfyUqWe2yqSUiyNdKCoCTmZbDp8WQSiUPSkYbHumiL8INkJneexS?=
 =?us-ascii?Q?mQ+PgueNTncbMJ3SEtcFX9iye9R63o86QEnZ9fH19Xwk1N1bHzjX0lp2M1+z?=
 =?us-ascii?Q?fFDutrDz/8lmH58zNwJFXjSb9SekX2ljy41ScGt1cv6vZdGV3wNs6QE+R/aH?=
 =?us-ascii?Q?lwm/e8LU87fdyWq8hYWmLR5KAoDqS0T/jWHrNWYCFVbYPCOqdRwLhrz80mG2?=
 =?us-ascii?Q?NPfgl89ZACO41gGcjtPt+0P7ppau7ev21D58JmkOS9qhIhy/ItkaOBquFdmK?=
 =?us-ascii?Q?lDjp3ocQSpu1rILMe9ku7L73qkcYqHTaBiD+w9sgqLXzvWxOJ7Z3/CDWkIvi?=
 =?us-ascii?Q?8G0xrK2ZxQcPKBCBHoTlxeFoe1bJWvY2sq30Zcd4bPhhLKe5RBwerVuOT3WK?=
 =?us-ascii?Q?YBSCi/dT2GunPmlQgMb/Pm+iTPibhwZEV7f7EpLRvxwTG4OFUmMMRbVzTcnT?=
 =?us-ascii?Q?ysJ6HL/m9d4zwGABk/f/ouXK3NxnXmuhut6FpVGS2m5yySqZIoouefqt77we?=
 =?us-ascii?Q?zGJRxVLLuMNkoXiq+ej9EFobm2P0i4WApiOSGwZk/JXpTI+WRKT3Z1cV4cGo?=
 =?us-ascii?Q?qu/DxkxZ0Nz024zM7MUYxi81XHSsR+2pL8yOQaPzrZXbQsgw301jAHQOHq/X?=
 =?us-ascii?Q?/d2BtTQquSDqEIF28zW33/VFKon8McR2qm/JRutHCFvCy6g9DIhO3J6ufp2x?=
 =?us-ascii?Q?dFjmp1g3D8e7Mrd0cGcIGNyBhfrlA2Bxxr1xrHy3lhzV0joZetp0OcvK6jTj?=
 =?us-ascii?Q?AxollRAnt82i5hunHaSOj5Radm4sGx9AMhb9kBJOl0qAC4wOy+WsDhdEM6mz?=
 =?us-ascii?Q?a8gEYGskiavuSe+1AEUY7iUCcxygzM44+EXx+HT7+OM+JzUUa+4uTt0q7tTz?=
 =?us-ascii?Q?7tYadttfoidBcZxyWD0Jk3BaTBRcxhuiGTaMpJZTalZz3X3vbKPmBbmO1G3R?=
 =?us-ascii?Q?76pblYW2kSgYNwKr/qxP4IslNADEDISeKAzK/XeVYJCpOxwnKal7k5dCTmZC?=
 =?us-ascii?Q?QHrqTNQS9RxNAsjmmwHUawxsI+R/vkXGGMeCxbjMrgqsYYvYDJAqwzRs4ZNq?=
 =?us-ascii?Q?ia7l3MI3BF+2YeN022NnZb2pS+qqwp0Pq+0/53cnWArohwnxLAl696/jOhLi?=
 =?us-ascii?Q?Xkfekp4/O/5op2ea2vz3s1/xc5TGxO3UrF8c1jVD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6319dc91-7147-4e23-1b07-08dc2726188a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofk8j2gbz794I2tqB/XY+Jxf3w4s7ssOwUb6DJscGAqWO7ewiL5PfjAcEmSH/N2e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

This is preparation to move the STE calculation higher up in to the call
chain and remove arm_smmu_write_strtab_ent(). These new functions will be
called directly from attach_dev.

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 136 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   1 +
 2 files changed, 84 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2ab36dcf7c61f5..893df3e76400ec 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1518,13 +1518,89 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
 }
 
+static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+				      struct arm_smmu_master *master)
+{
+	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
+	struct arm_smmu_device *smmu = master->smmu;
+
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
+		FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt) |
+		(cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
+		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
+
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
+		((smmu->features & ARM_SMMU_FEAT_STALLS &&
+		  !master->stall_enabled) ?
+			 STRTAB_STE_1_S1STALLD :
+			 0) |
+		FIELD_PREP(STRTAB_STE_1_EATS,
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+
+	if (smmu->features & ARM_SMMU_FEAT_E2H) {
+		/*
+		 * To support BTM the streamworld needs to match the
+		 * configuration of the CPU so that the ASID broadcasts are
+		 * properly matched. This means either S/NS-EL2-E2H (hypervisor)
+		 * or NS-EL1 (guest). Since an SVA domain can be installed in a
+		 * PASID this should always use a BTM compatible configuration
+		 * if the HW supports it.
+		 */
+		target->data[1] |= cpu_to_le64(
+			FIELD_PREP(STRTAB_STE_1_STRW, STRTAB_STE_1_STRW_EL2));
+	} else {
+		target->data[1] |= cpu_to_le64(
+			FIELD_PREP(STRTAB_STE_1_STRW, STRTAB_STE_1_STRW_NSEL1));
+
+		/*
+		 * VMID 0 is reserved for stage-2 bypass EL1 STEs, see
+		 * arm_smmu_domain_alloc_id()
+		 */
+		target->data[2] =
+			cpu_to_le64(FIELD_PREP(STRTAB_STE_2_S2VMID, 0));
+	}
+}
+
+static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+					struct arm_smmu_master *master,
+					struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
+
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_EATS,
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+		FIELD_PREP(STRTAB_STE_1_SHCFG,
+			   STRTAB_STE_1_SHCFG_NON_SHARABLE));
+
+	target->data[2] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		STRTAB_STE_2_S2AA64 |
+#ifdef __BIG_ENDIAN
+		STRTAB_STE_2_S2ENDI |
+#endif
+		STRTAB_STE_2_S2PTW |
+		STRTAB_STE_2_S2R);
+
+	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
-	u64 val;
-	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
-	struct arm_smmu_s2_cfg *s2_cfg = NULL;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
@@ -1539,61 +1615,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1:
-		cd_table = &master->cd_table;
+		arm_smmu_make_cdtable_ste(&target, master);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
-		s2_cfg = &smmu_domain->s2_cfg;
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
+		break;
 	}
-
-	/* Nuke the existing STE_0 value, as we're going to rewrite it */
-	val = STRTAB_STE_0_V;
-
-	if (cd_table) {
-		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
-			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
-
-		target.data[1] = cpu_to_le64(
-			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
-			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
-			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
-			 FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
-			 FIELD_PREP(STRTAB_STE_1_STRW, strw));
-
-		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
-		    !master->stall_enabled)
-			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
-
-		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
-			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
-			FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax) |
-			FIELD_PREP(STRTAB_STE_0_S1FMT, cd_table->s1fmt);
-	}
-
-	if (s2_cfg) {
-		target.data[2] = cpu_to_le64(
-			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
-#ifdef __BIG_ENDIAN
-			 STRTAB_STE_2_S2ENDI |
-#endif
-			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
-			 STRTAB_STE_2_S2R);
-
-		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
-
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
-	}
-
-	if (master->ats_enabled)
-		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
-						 STRTAB_STE_1_EATS_TRANS));
-
-	target.data[0] = cpu_to_le64(val);
 	arm_smmu_write_ste(master, sid, dst, &target);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65fb388d51734d..53695dbc9b33f3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -249,6 +249,7 @@ struct arm_smmu_ste {
 #define STRTAB_STE_1_STRW_EL2		2UL
 
 #define STRTAB_STE_1_SHCFG		GENMASK_ULL(45, 44)
+#define STRTAB_STE_1_SHCFG_NON_SHARABLE	0UL
 #define STRTAB_STE_1_SHCFG_INCOMING	1UL
 
 #define STRTAB_STE_2_S2VMID		GENMASK_ULL(15, 0)
-- 
2.43.0

