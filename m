Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9F812B166;
	Mon, 26 Feb 2024 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967256; cv=fail; b=WhwqSgXUbo8SujX5JsURS0KnRjVnbRld70G6bLUutwHaXBfeCVz+GzYZ0nYTgqODaspOpGg6dPzyOYKn882DoqTCt/uOvq0lrnltoTn9qjy6VCQcZprblODy3r3vYPyLI7Bf0yNdHRqymJYFQUT3k9zlKYEIznljVfXTG/Fk3h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967256; c=relaxed/simple;
	bh=GKeR0rQywLIhFRMkbLCgIWJz7zEnKdbDsFSEB/GXqXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fB1Dh1o60zpruronsTFb6zNZwXZLxKc6CDjgZvTC0Fhm2cP3iZkeELTh9Ggi+Gtu/8PYmG3f0DyHD9Wtkt+9Hwe7B2y6FepSGqliJvWyXt56dYtapVWhtw1UajOSmu7cGHc8vVuIQ2ORD0b+cMVHhh6nueAFKWlKAcpOvNrUXWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gUdTMNY0; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gUdTMNY0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGEQajO/QDwp8TUxVnRUdE8j/CFaJHU0BMVBl8Ts/vboSQ72bIim0qcSecXVkdXGERFHTheucs6RFmJv7lZAHF5P++s/crnz8i8mPCBQlmPQeWYB5H89ITJGZIVQx+r8oxVpZvmARhvLZYHNt0cm6x4WyJ3HdcH6Fdygl2ZvKZ5bEBvHRroRd4ANn/CMv7yb4ndvLhci8eLMbJPNVXWIdDMnmOMPwppsso4qoEt/3tG5cRdkSrnaKKjjZkpZXHr3njq8gos73HHvB2PebXYNEmIIO6aAG0C7s2A/4WigqhuaK+mmEGJQebjF+NZ9tCI4Wym1blvNHEW/JC33C1OBmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YMRf8eUCowtHepCIhiLLHq4UmIUqrl2p80RhAD5JIU=;
 b=JiOk/wau2+bScju112cGxm7nLpvCaEAVMtDlOG3hQervWHd/4K2SKWJdsW9ccQ2/twKmsCQNS4gvgVpVGq60HHfsyyRsVsoc6KVFtKBZdisFiY10Uv8JOkF+12SZpRq1MoaSHp5RVaSAYNzhgkgSX4nWSsqW8E/T+T/uXwOeeJM/ovg+fIuY/61tFnYHKlcialCRhj9Is1BJj0zBEqX6UqH4iV26IOfLmBbXpZx9AqfHkAjUYkVYig/fNyGK4DZPZTpDsi2c2DNDI7VQdvnlKuA6D5xaiV6d4o8XABV5XMqGP1jkgw+NQZtHahSfJd+r1FHkI6O+q3vl+yh4kmkfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YMRf8eUCowtHepCIhiLLHq4UmIUqrl2p80RhAD5JIU=;
 b=gUdTMNY0TuRMpVPuWa2hMm9Wh/6U+PZvb3NFIvifYDY/Nr52lOoWlAy0g0Od27Hazjhw5p2UdeTO2y7Y6lD7/eQlaDt4fgrZp9m1GB/fmNOWMJcQ15qNHilnzHu3b2D8iVZPHCDdsx8iYxPVXtI+O0l124JZ0fdh7QionLcgcPnsTDJBs31caZ6f5ovBIKmMTxx6XIcnXey4JgMKvLQVfXvse6lWezTS51XqeExnrJfnoPrzml3SdytknRz2T9iop2ewsdq1nqg2tdTNE5B0BCdhBzs0dppL4y0JXzD331GSTddEP2Dhz6ikWBpufAULOa76ni5CivmRYttGT7WA3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:30 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 03/16] iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into functions
Date: Mon, 26 Feb 2024 13:07:14 -0400
Message-ID: <3-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0002.namprd15.prod.outlook.com
 (2603:10b6:207:17::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e48be36-d683-48e6-5a54-08dc36ed69c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JWYY0usYDwkjyNrni9y8y7G31KzCfLnuHCWCvjiPLYX+Su3qDm1+PEChUcFmMUFlBG8xN4FH1NG1II+qcOQTh6t5jW5Grtq0WH2FAZNkkacy3WjyS/Ew81BZWWas/3FOku3viDD4q12fJchWs8eGFLNhD7uszOQf1YZ2EFrFql1qM8tFKL5OU3K/t6k9/gd1TT9e2Ft5u/75g/Njwm+95mp/31qiMZ63B+YzksnxGkVtmJADNSrnERUg99vvbyqgaxeQNeCBVgx+dBxpvfQ/v/+S0ksFCB2OQJrnYWKzKA6GcvslK62+QszfmvRyElHLzSbt1Jv9//beysn1He2m9fTAR8Qk+oaIsahqLYBFeO60SEQlawoquJCPOW8a1EyYchUtX/55QS+n9PnfTNijShLa+9/6ltVa3/4c8YGkQ+iqtVRhzKy/x/V6gZOJzsKVbUdseyfjakGBXprYwk9pjq9/8vRzHLqMUPjcYOtDMt+62sNLO1YF/Yy89l4bh/bdZB0mIROP8yWwrinnMfa9bt6UYTLONUSa+T9/2KwABW52uo2E+7rC1XMd4KkymQ9a7hXNvWiBBUT0NIVlltIkIMXfyi11Sdm8Eia1ReQ1MtZy5KpTpl1rEeGRN2MpJDLH/j1T5iHUVMenGXVESux0/A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K3GOCZiADwN8pKM5x6rvdfHGrwUKBKTqPGE1XqlswQyMY+RITHp8OIPiFJ/T?=
 =?us-ascii?Q?Ggsd009F7KCz7i7BZiqE21auwf92HjPMSDPVFQBMquzOm4RUal8Y2c8Rjgha?=
 =?us-ascii?Q?+AO82XXEgxz6fCApyoKiPOg+BKoeZcPWt/LiH3O+lfg/76NFoJEFvgYIII+U?=
 =?us-ascii?Q?dm6rMIo8f2Lb6oqhLd/SlB60nekMHrmkbButaep2rtRbn/yLTm/6XVuhVV0b?=
 =?us-ascii?Q?oB0ytBNZTw6QeoeIwV0GwiDty4yLADIVfWasNFveHmJbm07rSKmyIUpTZ6+Y?=
 =?us-ascii?Q?/e3hnFH/y0J/42QCgWuvdgv5uDWkihztta7jQXW21I8pIhnCshm4schj3Eau?=
 =?us-ascii?Q?+pG4GDnY9B6rvbSYpIklsEpHvA3l1LTnNmwfg9ZgSnv//Mtm92OQXj8QF1P5?=
 =?us-ascii?Q?vEdP1CJcvlFL+t6HB+pcvt5WLWT2GQg+hTDDfBMfjWkwVUaUAa8NvKuiwabn?=
 =?us-ascii?Q?m/lc0pqLAJjS2Hk0KolnQLKh+sPygAnoYNNtrt6rgOah6J6GBzqCtwidfInJ?=
 =?us-ascii?Q?xLnVy+SsLidZdlzesUbecjguQcrL9qMQffBaTp7Z1vh7HSc83FY6oEsVSk79?=
 =?us-ascii?Q?He3cuNKOd7biCeRrzdeuDMrzvxZg/4uXZ4lGwRa8Xo6i5/tVanBKp/9Vq2HP?=
 =?us-ascii?Q?DJpVvh1kOITZiXDhqGCClZ458yCRuIEa/zkibOe24h9af1ZX948aIpNoBBmh?=
 =?us-ascii?Q?7B+E1f4Wg2sI4LxDULVqx8yzAgFzDRUeY20Z+X7i7FkqxCCzKHSVn4X5d2Tf?=
 =?us-ascii?Q?uX4inA55EzjeM3vu9LQvcpI5eaXLb7Yw0Mty8pmrcilIelO/I/z5lxPFoLSP?=
 =?us-ascii?Q?zKn5ydEUuvqHXapQQqpY1RkFoWBsMs9xf5EijrZQUwG+iDMlLoXIStkB6oc6?=
 =?us-ascii?Q?zV5q8IC8KauwGjDkdbvBC6cgWh73YlzdXsOqikVfVonjv4X6VioU+cSdu4Vb?=
 =?us-ascii?Q?OdfDlP/S6CyI1BgrKzGHpNT0LRCpp+L/b2H+f0B7T7WpaiXMDr0vlw0UIDD+?=
 =?us-ascii?Q?SD7lRWtiIAnQ0tRBUq4fwgx/bweDOP6CJHSQ9/4yHnNXZsP14wLmQmcEhZFD?=
 =?us-ascii?Q?jZ2ud6Cza0LUTCmvHd5ZYCU/sXovOVvpdLYfYLH1lymNgKPciTL6Qa2xoVOw?=
 =?us-ascii?Q?GbqF/rzPQ6YWLhGMNc7km3d9Y6oEb/wm51RSRhKyM4jIOgeiqNDFesLIvsUN?=
 =?us-ascii?Q?G61EZmBOnPRVljdu1EB3/joPi9DU13HuqnGVlXRKL1sQSvPWyOvSlehe7g88?=
 =?us-ascii?Q?IXISbjv/BUCsOohQBphMjb5JGKJ0uz/ZV/hlNb6DJgQqpsHlBuzJZHoW5DOC?=
 =?us-ascii?Q?Uaatet3T1O/O994vk7wTzOd6G/JgmAF+XPv1JozowmkQlS84+XYatvHvb+Yy?=
 =?us-ascii?Q?4TcNqyhXySB2HJG6kIQVDhzcINSrI9ErOQhxCWdE2VjDuXZAPJBFsSGt0CH5?=
 =?us-ascii?Q?GMD2qYA9YiFvFvknW02VlXoyCUWVulCRkngasIxrOhtWAXu3nSLS0eSGESVL?=
 =?us-ascii?Q?qcTIUKRK/MCFLf7U2bEDa86uQSYUrU9lTEAIRqcbiPBenUYJg5Rl3KkBZ/lI?=
 =?us-ascii?Q?j66FdlpqHTbyUzzfvQg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e48be36-d683-48e6-5a54-08dc36ed69c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.2244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWkxMrzVF8jHvrhBWiAHmUn55WRioPTcBWAOnTPusMcBljduaUCrawX3/BnPGKOV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 138 ++++++++++++--------
 1 file changed, 83 insertions(+), 55 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 12ba1b97d696c9..e34c3181966934 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1465,13 +1465,89 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
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
+			   STRTAB_STE_1_SHCFG_INCOMING));
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
 
@@ -1486,63 +1562,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
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
-		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						STRTAB_STE_1_SHCFG_INCOMING));
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
 
-- 
2.43.2

