Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8EE6D1AF;
	Tue,  5 Dec 2023 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hmq96KmV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHIRTWYmaSo8l1RQ14+Nm/MBldzrVPfyCa6x7TRP3qceC7VpBKxoAzlea34fSsZPFaaap3VGtLH6omm258m7Z4tncgomvi9h6vWjHQ6m3MFU4BVYvCmkNyx3Nvd0cK4vWMRvpWrz/oSB+3IrfCJZENQEuS6WyYzAa8w4Lpb8BcXw/dB9yu8DfO/g64FdVm7ahRRpMjoa6G0p7jl3mMHAeZfAfrCw/o2R0+TiCyQ3WSzGc7WV5aCdLGCEDkXOuEDJT6+Z3PAETKzv618hEp1J8+IYZeBdLN5yrIFEJpiGsGMapJ+r8x+gP+K/+iq6CCS4bHJKMSK0BctgNBeASmf27g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ele2izpiXEwAOAdCMHEzhrBBzLRI6WwJXAV1o+E73o=;
 b=TnBULC6ldu7WYqAXsGGZR//Rz+VC0sBoOwOUacladsrmYRfSiWVBYAs0u3OP8iXjNYVWz08iup1X7Zs07CJq4hygFmFeuC6OC5dNq9y+99puLoU/lZ7NXNdqGbqy9LHyNS8G/Wxii7olhLriLYUi6Q0+3a448XWw3grbc4Cshstrl+/gQTEyBtsYm1zXtw0UHUe72rx76G8JrXj/1mqZGW6bwrp2YvAbXJoLCwTegvgd0vWVqU61TLf/AQCZBu6G8UajL0GWEepE4K4XXQteVCsEWcAr/Ah6H4XVSbt0wPTsbIoMMMlNcFQ+8+lAAMoBFUNdAz4PoQ/4gcDZqILkzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ele2izpiXEwAOAdCMHEzhrBBzLRI6WwJXAV1o+E73o=;
 b=Hmq96KmVgUH1pA4MEGbWRZOgTjAb1SoDdq1c67W3MX1sBXBQktd3WR79R0knG3N0F0PMmTicdX8YIEwtcN12Nr+y6mdiozhTzErdRx7ynrRIewkF/oQ8DD9gSL10/1oNYFelIf+va7KSBjAea5C4dZuAFhj7gBN3r8QGDNm2YJztD3SNE63B9ZzejIKGkNyYorLF2WYQDVPhCYpM33CTjlVIzadYLAlSmk9Q4/N14aCqx8LtqXmeCtIwmVWXQer9+UHvnKwtP/qrgkD1x7bIGku0TySNGa/sJii59mcY/048k+8xUqHNGDsU9tApPq8hmZtgqT1Jx7Mf4AI8B63kog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 07/19] iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into functions
Date: Tue,  5 Dec 2023 15:14:39 -0400
Message-ID: <7-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:208:32e::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: d37bebd3-82e4-4dff-7a9f-08dbf5c674ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wJW3UkZjIDfdlBKHUZ0iHMtjPHSm0CZUHrsxaXQt3ZPde8fbeROMDEuFsJXftJi+4E7f/N7DVzxs9G6hYE76Vb7m99YbpjVESCZzmPR9exjrF1lXPkvu/MKEgv/wqSGRMrtNPYew//bfBN33nowMGcZ2SDYPcBZV0L/1mqxWawE5g76hmYfYX26cvXC1kiwAjxVlSJ16vt2wLHfTanLSUGkLjiJjkklyjpNC6l9TUCgFKK5h6OwJVd0QUoExgdKAFHkYxQHcDJaHIu63I4Rr4TCcfdqKHD50V2QbGAwu3w3UlsyNLW3wzSFg6XU5J9Z02IEIOYf92LRy4n8WcAZik498sGzyrKcenC9TpgeDcOWq/Y7Rs9HSjfrfRBFEv52ESyOeNgC/F6WvoUE/S0bDXFy/mOgGBCXelR8U8FZXK1AGFazxKvegjofOr6hW1uSVdfqXKOTe/1tzIP15WyfXoyVi5kCE13ABmBqdcJmibHCgNcaqzxmYRa5yrP1BEdiRtFlpW/kLUp611MY/DKGeuqqzoDXCpNN0Wzl37BGFpPqscdMVNP9Ia1cvlFiF0F1LgzXSlLepv0W4+N0VaFbfXqYDeSWEiGXwQK5Z9GwHPLwbgyq00EyMzo6IgVLaW8XuDFQhn1ADyS8bO98yB//XGw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/SrePuIVxpX/wDoLGSRxihwcd1OR7NpOIGXdd2m3eyVDg0Ev074OhW3YPuso?=
 =?us-ascii?Q?2sihO/jUW+6Cfo/KUxSD4WeU16UScU8N+5OIAIO/DsBbiZMXq1BnkwhwFVYh?=
 =?us-ascii?Q?CtGTEV5XIrNpyRsQgp8hFlhxkvAYlSYUYtEb1tgmBUQsHzZeOiM2O7xwQk4c?=
 =?us-ascii?Q?w7Etp9FjHRzrR8Zo2bydVa8YBsN5CaE2xAvAYY43lGL43mjLmsHVImK51WxO?=
 =?us-ascii?Q?CAPaMlTtMrHJPguJlVOdY8OPS/4hcKqh135IJqq7sFvAabdlzKaXrg4qlf+h?=
 =?us-ascii?Q?IY+rvYBJe4n040lqRj68PayzwtDi9DH7E0YNWTiJXB2uuYJsSG/c/YSqln3u?=
 =?us-ascii?Q?+43imY+iARLFlRgb5vSrY5foMAFpoHWDohtvT8cjVvU1NfqG+dMTopeSUERb?=
 =?us-ascii?Q?6K/I2mC9wYyccUfq+cj1Rz0qa986E34Wz3ediZROm28iyaffRdL9AjGOBYim?=
 =?us-ascii?Q?ZnmrUhCLoYa7hCh6JCtKEH/Z640jX9/lgCDUJ1EPpNIOFQZeoos9HFAPB55N?=
 =?us-ascii?Q?0q+9+vPPXePPMBH9OZhJfWPmgin4DMGBNahWyMXhxKCoQg5kx1aSz+OiWAzX?=
 =?us-ascii?Q?c1gTgfQWEg+KsZeNkpedkJrsGDWYJKE9FBl3EIUUdNFOdtNIdmrMHPUIarop?=
 =?us-ascii?Q?UHr/u1Gge87qyG26QCdHNwPP/2slqtTXydgTuif8YYC7qeLvVY2gkpwAIjB8?=
 =?us-ascii?Q?ztNSimtlWPzQbDhUp2kXz3zM4ZKqpEjOEajv6LauB4R99VbuxwJPuMvq+MCV?=
 =?us-ascii?Q?FnZo+RGvOUwjf8FPpgwOVpwTKaOEspI9hB/Gxz7XSfVO8G4reaXJztgGEvnZ?=
 =?us-ascii?Q?cosjkEQqzEuIO3/hoExzLCTeFykk+IKy0e5xFVAFZQ7JZQ4joJrFfsiUks30?=
 =?us-ascii?Q?EBXZgSHwX9WOuOyI3KRE1Xwk+UaXeNKmKFbFXrct0Rph3brBFIJxE2ViHsN5?=
 =?us-ascii?Q?JZwmcipd/Ml7mhsHqeyob5j/08SR7aNpTjrX0zkeUksWdM4pi1YOfJVf7TqS?=
 =?us-ascii?Q?Q28lXTHn2DPqJmz8I5bQYGKKHbr1qJv7y96oaCvlxSxrzDTZZRayeX1SGsxq?=
 =?us-ascii?Q?ctdIxQ3zXhdwI8C8muYbrITld5XQOpmkZc8lOOW5v8jkJ+bPkYFAIwW/yzQv?=
 =?us-ascii?Q?C97VOfrA64jqwMUuxwgI5OWqvzgtj2nrES9dXRYd8kS/RF6NYuYsXq+tJwWM?=
 =?us-ascii?Q?Z5LMK3DOWb5D9F9CBUbqNcOSUJVmAYt0WtB5nuyWtpE6onLhv8Tqr8vvR09G?=
 =?us-ascii?Q?dF9Q55hzHhBzjLncrhkxcpv1F7cuuave8P3Wum3/ve1/Ore97wcwaJpV4bqu?=
 =?us-ascii?Q?2GlmYjiToSRjfYFV54C+wkZJdAeuWTAgX4lJewpWo3jE3ZClJQB7JzQjNvG8?=
 =?us-ascii?Q?LEBEo0QP6W1rAZ7HC8ZlqzzJnoRCc1VQVVKIOw2InNKVX09goxi9UIaiKVIM?=
 =?us-ascii?Q?kuWI0ZFyA2ysO0fZRb90Tmfv5I9CCFb8zyBqM18RFt4MAMjv029yn6OhpSC2?=
 =?us-ascii?Q?iIZ9nPwj2FHPh03eLOwWCSOrpLgfPiAFmQ1sQvtk5SleC/43EKUDjWDgENZL?=
 =?us-ascii?Q?kE5oFoIdZI/4Dm6oTKSF2yDfrSbhIBnN5p3pV+2r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37bebd3-82e4-4dff-7a9f-08dbf5c674ea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:51.8252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCfHv+LJ3sfql9wbC6wNROM1zwV3kaahEyAEVHTrSh4xJdE6B0bQ90AsN1tsnCet
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

This is preparation to move the STE calculation higher up in to the call
chain and remove arm_smmu_write_strtab_ent(). These new functions will be
called directly from attach_dev.

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 114 +++++++++++---------
 1 file changed, 62 insertions(+), 52 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 95c78ccaebd439..b3b28c10bd042e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1463,13 +1463,69 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
 }
 
+static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
+				      struct arm_smmu_master *master,
+				      struct arm_smmu_ctx_desc_cfg *cd_table)
+{
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
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+		FIELD_PREP(STRTAB_STE_1_STRW,
+			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
+				   STRTAB_STE_1_STRW_EL2 :
+				   STRTAB_STE_1_STRW_NSEL1));
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
+	target->data[1] |= cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_EATS,
+			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
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
 	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
-	struct arm_smmu_s2_cfg *s2_cfg = NULL;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
@@ -1484,61 +1540,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1:
-		cd_table = &master->cd_table;
+		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
-		s2_cfg = &smmu_domain->s2_cfg;
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(smmu, sid, dst, &target);
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
 	arm_smmu_write_ste(smmu, sid, dst, &target);
 }
 
-- 
2.43.0

