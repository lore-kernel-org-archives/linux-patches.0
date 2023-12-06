Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C733E68B75;
	Wed,  6 Dec 2023 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g5B4dTe/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGD50jk97eN1l3fBTQ0F90IGM0FqNKUtxYHKmv4ibvvTWcSDe/FT0dQgqZrfPWs79Y7B0SFvoeIvbXUyGIJ7gsqj4Vf19YBUPCub1kdrJUlPw09NUi+BFDGDFdx8V/Uoh3eHrbWmFSxBf9kwyzw/uT5twaAUMuvUSTW3UaerwSc6yXjZDKm+DGEo9MdU6qi/qPctsKluJpYAo0BFu778baEGEsB6ynluUCGwCiAdd0hT0clZ4XFJ8a7cCwgpps6KJiDI+E6avHglFj7c34qe702c0s+JF8JCrzD+vxlxJ7thu96xfZFIRFBn7jETqnQ1qtnMvNd4XrXqL7bYygRbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUime/3yKgW4y4/G58R6ZKEJX25ieum4+gTWMfe2tW8=;
 b=OqUCVwYeD64dP0Vt6frBHaEfdvwKrb3fztmTVHQ3yUOAj67ONCAdNLPQPsu8Z+ZQ6oUzkieQCWcouytQ3E4C1YCjSiqShgSs3pzwZ2j/R8KCVx/CNIXFeTjnzJkulUkrxiteayHyNtSMdH3NUxGwZr+UKsWf2vz/UFEgr0u6cN5cnxMvquVWmSxMtUK9bO2DiChBK+fwGf0W3iQW61rgOs3TMB8eEUE9zLEMg0sT+F1pya3mb2db/Cgl74FWPdU64JnMUXpodHHM7RqBaPtQg+mWo5Z4dqrNi1QaixrZZk8BzUCE6Ynfe4UxsjLANWzZxMHNc7KVE/gQBSIOsiKc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUime/3yKgW4y4/G58R6ZKEJX25ieum4+gTWMfe2tW8=;
 b=g5B4dTe/xQkE759nZkCPzq9x0uwSBOiTknjou3ODXE8eooa7nv1uRvf40NctOqt1YZywxHH1xntD6YtfPgBMuA3A+26gf1wQvPE7A00hHppCGf2tjEFkkZW/RBb/jGux4yFEHyyFcHuRl034mjgaQY6+7lSkSbTdLMmb91/0ZhLA24alWkLcr6P5nait62dHYflblmrh5kgXkpkABZ/wg5lKFvpMU/Uozsx00sWv5tLV2gmTuku19LIbcNrfPn4ui3eSwtD5da81NCI2l3f0Fx8qi1QtiXrE0OjWVCLg0MF/U/k0QjHI0tTSaJyeJwCfVSO24a/ICMEWsqOoDl5kjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:41 +0000
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
Subject: [PATCH v3 25/27] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Wed,  6 Dec 2023 13:28:31 -0400
Message-ID: <25-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0017.namprd15.prod.outlook.com
 (2603:10b6:207:17::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c20fb3-301e-4350-43b2-08dbf680c689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fqQ995YdNad6fSbiOSacivaysPxeF3nHLYsFGR/1V0DX/8iAeQJtCSF1SX5WH4OXQuIghweLGqXNSR/ckDZK99CvtDinzI3JNL6N0pdqv8tpUWRcqIBZinTfP0538ByO1ONBkpz+koo2B7kldB0QifdTjZPMQrzZjUQfaDycVbY4sHiu6cuKF7cWciMXQGjiitRv1Y7qf1ctGhsiuBHhz8GHcRhvZRBJgwQ3iNl1zjmKS1w+5Ez4kk6ZdOTQPZ2gypwXxtveI9XVP1L6Nf6vZk/yJ3hQfSdGms9AAVbugB+xgBGr2AucOQjv8S/HUPk9BBbfuVPdVWNyeCzJCSlezMpkNWQiGXvTyihG4p9ZgSrW8RGJL1T+J5Kc5R3ZTVfNRwkTc9elet2rOMV9WbQiZ5g/k2EQIu0gR75OVI/c1q6vzmK5mLcQiNeBHJSAqjRCwlkHN28WeelEmRLGqFac+sS5Js2MUfEAiFH/lFUibDBlGvZ5TcDgjwY4SsNSKOqt/dbcpRLUyXycjtysjx4ISCHLxVrDLzwDxGmc2CO9mNet42EPXfJQh+GYYor+aFbJ8ZPMorP74W2xdYwMVVRBs5T/fEmmb1s737c29/Bd46bg1wdCiqwu+VKBRQJFwGR68X63E9ycW5Pu7uD7QJlelA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(15650500001)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g2S5xz3I4hpMr1mxbHdS7HyojUrQQwVZjPld2RcbWV7F7qh3HePVnWyexA5Z?=
 =?us-ascii?Q?psBG5FqKesj9vCQqB0JjYGaS5YxMV+3FSj0F7ByjGFzMYPOpOo/iP8YwWvrA?=
 =?us-ascii?Q?v73YameytlSFFEz+GS1ohF6AV4DLJmAHBYl58kxuUeZPKYmK14QrMd0UhQpY?=
 =?us-ascii?Q?jBsZ6y5IWH7Lv6HdiZL1Ba1otFvwrQQvZE4uzDdHdYxW2T3gDNbzM4JzlgRX?=
 =?us-ascii?Q?umzgm6F+6RfRm5GSdmPTIMdoNnW62ya9ps/tHbWEOssDjQwCNdLtgyarGO4S?=
 =?us-ascii?Q?0nDwucO4DMvq4/VBLxque/JLzCQrsXuSvq0qnZu4J00z09qZONmG5CMwXtln?=
 =?us-ascii?Q?AC9dm1zXfKVO8ykaWc4jdkPoNTi2PviWG2/BzYbbqy1e08K4/3c6bAv3tfB1?=
 =?us-ascii?Q?5MQyskop9N9mXvd6Gt5Ryc9i6lLAfZQKQJGjlpRIL9gwdtHW6e6ofmqp5pus?=
 =?us-ascii?Q?qF3ZChzt6UnX63sWsdJS3EvY+TXzCUXTUVWd3zuyhdfwRpiJIRdVSAIWa13+?=
 =?us-ascii?Q?KPqAtz1a66qtDy9kLBNc1AzOdP9a+DOAfjvb56wzzuHlfqhgM8myQjep80Hl?=
 =?us-ascii?Q?/eI/DniJrzt++FNKoeN5vNTYup+Sbe1URBfUcXDIGvuDI+u6+g3S7qf+ueor?=
 =?us-ascii?Q?sUP9uCYXaAcRaFqwflJa74s+kdXzV+19xMTBmU/NEsxzNBtWQ8HoBZOolRZl?=
 =?us-ascii?Q?viVlzKCqhQIPHhyE2LvP5A81jUMcg0lBS0zS/FzDpCvWVfW2xDr4EXd76W/g?=
 =?us-ascii?Q?+v2w3CxPGI7v2KulVhc2Nw9V9w0tc7v72auyL/kwOic9IGpwQL6o8NllN9UO?=
 =?us-ascii?Q?aaSFxnkhUsytBOoiGDFTRLq8jinczAAndFLeaDfEnGH8LSDzz4ZP7T0c0UnX?=
 =?us-ascii?Q?wFsRWuQPfuPaxdKy8K7yCjj85GWELXgHlYg4I3yBBoI09+X2QnigvHyc9/s6?=
 =?us-ascii?Q?hr5gRmJNp6oJ/bZ/RIYc2P0uUhUxsRO4akpXg/96JcuTGxzwwCr5Kk4+V8Lv?=
 =?us-ascii?Q?xSGJdu7hr97kM6porPap99ktd6l2Fb0VxU0mifNsMW18271F72vt5twW2KI0?=
 =?us-ascii?Q?cYGMOf2O1tP3vq2c0Q65W5R45e7eQv3oOgqseMUniKMl5T9Va1/uibBAYoGZ?=
 =?us-ascii?Q?iFbOVtJWcGYgCI38HdvJZeGBwq72BZEoe0GGmfPGPmQJekof/lgW3C9rOTVm?=
 =?us-ascii?Q?CJonTnJid7Rc1V/P0thrWvnN99Zx3gyCiglm6QWrkkOpj+sewR+kG4b4m7NO?=
 =?us-ascii?Q?MFGQqtcyLqCJEN4zFNsi+VzYa1xUtCzEU2Sh9g4Y9Xo+FNp1KHrPMbXK95KC?=
 =?us-ascii?Q?NpVVjTLRYMTYc3MhCIhMfZSzGhpqKYzdOiRB3GCYxmMyFQdxd2YtAguULUlp?=
 =?us-ascii?Q?vRX0mENXLib9I9Rz+sEMz7tpbx0xQIeyuX51rj68osD4a4JMFyNMx4saUzGd?=
 =?us-ascii?Q?JSLXfUgjHLgmGu56OJdR8KnCmiw7MiZXAkhPTJV0SweRq5elQlFu54UZyp15?=
 =?us-ascii?Q?F/H+52c7tsA8KuHeXie2N9zCMrSnQnpcfvnHYZMFCe7JWSj384la/pzMO+sR?=
 =?us-ascii?Q?0uZIMkCTr6Dd9GmdQrnc/roPx/68s/ylUPT7xY39?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c20fb3-301e-4350-43b2-08dbf680c689
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.1450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J35XH6Gx0zdzsuN59HIs6LCRDH3ekKrlhc8U9rc/PqK82AwEfsZpCY8jTtKNG1Cq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The HW supports this, use the S1DSS bits to configure the behavior
of SSID=0 which is the RID's translation.

If SSID's are currently being used in the CD table then just update the
S1DSS bits in the STE, remove the master_domain and leave ATS alone.

For iommufd the driver design has a small problem that all the unused CD
table entries are set with V=0 which will generate an event if VFIO
userspace tries to use the CD entry. This patch extends this problem to
include the RID as well if PASID is being used.

For BLOCKED with used PASIDs the
F_STREAM_DISABLED (STRTAB_STE_1_S1DSS_TERMINATE) event is generated on
untagged traffic and a substream CD table entry with V=0 (removed pasid)
will generate C_BAD_CD. Arguably there is no advantage to using S1DSS over
the CD entry 0 with V=0.

As we don't yet support PASID in iommufd this is a problem to resolve
later, possibly by using EPD0 for unused CD table entries instead of V=0,
and not using S1DSS for BLOCKED.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 66 ++++++++++++++-------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3907cf4db3efe1..f97fac1de0b103 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1485,7 +1485,7 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
 				      struct arm_smmu_ctx_desc_cfg *cd_table,
-				      bool ats_enabled)
+				      bool ats_enabled, unsigned int s1dss)
 {
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1498,7 +1498,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1511,7 +1511,11 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_STRW,
 			   (smmu->features & ARM_SMMU_FEAT_E2H) ?
 				   STRTAB_STE_1_STRW_EL2 :
-				   STRTAB_STE_1_STRW_NSEL1));
+				   STRTAB_STE_1_STRW_NSEL1) |
+		FIELD_PREP(STRTAB_STE_1_SHCFG,
+			   s1dss == STRTAB_STE_1_S1DSS_BYPASS ?
+				   STRTAB_STE_1_SHCFG_INCOMING :
+				   0));
 }
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
@@ -2656,7 +2660,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table,
-					  state.want_ats);
+					  state.want_ats,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2727,16 +2732,14 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	mutex_unlock(&master->smmu->asid_lock);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static void arm_smmu_attach_dev_ste(struct device *dev,
+				    struct arm_smmu_ste *ste,
+				    unsigned int s1dss)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *old_domain =
 		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
@@ -2744,19 +2747,34 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	mutex_lock(&master->smmu->asid_lock);
 
 	/*
-	 * The SMMU does not support enabling ATS with bypass/abort. When the
-	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
-	 * and Translated transactions are denied as though ATS is disabled for
-	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
+	 * If the CD table is not in use we can use the provided STE, otherwise
+	 * we use a cdtable STE with the provided S1DSS.
 	 */
-	if (master->ats_enabled) {
-		pci_disable_ats(to_pci_dev(master->dev));
+	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
 		/*
-		 * Ensure ATS is disabled at the endpoint before we issue the
-		 * ATC invalidation via the SMMU.
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry).
 		 */
-		wmb();
+		if (master->ats_enabled) {
+			pci_disable_ats(to_pci_dev(master->dev));
+			/*
+			 * Ensure ATS is disabled at the endpoint before we
+			 * issue the ATC invalidation via the SMMU.
+			 */
+			wmb();
+		}
+	} else {
+		/*
+		 * It also does not support ATS with S1DSS = bypass but we have
+		 * no idea what the other PASIDs are doing so it has to be left
+		 * on.
+		 */
+		arm_smmu_make_cdtable_ste(ste, master, &master->cd_table,
+					  master->ats_enabled, s1dss);
 	}
 
 	arm_smmu_install_ste_for_dev(master, ste);
@@ -2768,7 +2786,8 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 					      IOMMU_NO_PASID);
 	}
 
-	master->ats_enabled = false;
+	if (!arm_smmu_ssids_in_use(&master->cd_table))
+		master->ats_enabled = false;
 
 	mutex_unlock(&master->smmu->asid_lock);
 
@@ -2778,7 +2797,6 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2787,7 +2805,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	arm_smmu_attach_dev_ste(dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2805,7 +2824,8 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	arm_smmu_attach_dev_ste(dev, &ste, STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.0

