Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B942B208D9;
	Fri, 26 Jan 2024 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292944; cv=fail; b=ph/P4cCtVxl7BSGVJL8wHsi5UqEIgygVUCJzOU1pyxi8YCvSNrn48kYve/a7MzrjTHaEUZygVn9vBGXyocY+ms6E2cZrv0PDWBJFleqOIFxElcFiKn3Vr2ApJeuTwX75J25RENDnKO7kcco41D2Gr3LzHkF/Yo4s+EZ8NAyQh2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292944; c=relaxed/simple;
	bh=jPnIUMF6+o/d6n+mrK5szv2gIbvcHt8+TFtdWUGp3I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AHZ6xAmyr7gmG1ZCHEYLkXNNxvXQ3chdl0Y5mhoDTj7tNsfjArueB4D2rkGirCf9JIHp4C4Jj9rKEGT8KhSzYZimjrB4UuTeYQxtjmj7TAD5acd6fbnmszbOFTPcf1qByAU2mHn3MXg5usywEjEQ0Oys23qdaksOUr7DJnzkJCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HC/GSgKY; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HC/GSgKY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3yNxiV8Lea+UBhTp86amjmM3IPeDxnoIxQhXez4Hk/wVfrvEoMaZ6dfgaYcJRJAEjEKgKnkgq2zJ9s/tG0nuIWhrJY/4vZXvbiqPfGMzDCE9+0q2tipGXLynAdQ1D2kPKwiALAR/DHkEHqFiKNNy1hQN84ETxgeCee61OL69LPRMD0W/cXIBl792l4fUxcqngkT7Xn1jkgEaYcTI89p8w1zcf2NF/hxUx4in1M5OebMMN0W09pg4nJTRuSZi4x7RpzkikAKCX/Ogb7UWkHqSAYB9OK/kEqVnDFSgpow61IT9TiYM/1ESYa+LlDJjlsKdUvHKGmddir9vkQ3TMKyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGSVVZtdzkeaP91xLF+QEFLzkWB+BkCZnFImu3/kV3w=;
 b=XO37/6jy5Bf6M/LYmj0Fyqlml+9KHZ0UaF6xmpn9Z8ZxZZlQ0PVBTt70GVcx+WjaWDLfiRUCUHgPIRXYcT7QvisqFu/G9kKoxHflS3tN/VE9LzNmHSlhcyWAQOnaWy9k5RImHF6VGVRDABpXf8qTdQjwbeYYdMStLlsSzUIESX81LjmgzGJswys2r7W8T5plMbo5t1Ic6dyjQjpPjtaGW1x8M2GHhgzjR5qYvCLvtm8R9BwCE0dAurTCqXo2prDbifriQlvFAuywRqsh+9cMWCuJT/xqKJ5PocRAgmXAbqeufn4PNsOc20NbkMzV2sDPliQR/A8kYWD9Yig+JoSWpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGSVVZtdzkeaP91xLF+QEFLzkWB+BkCZnFImu3/kV3w=;
 b=HC/GSgKYYdawGR+JBsHQaodooGkHk1UCRXRWCVj8jrpMcWHnpMc8F6+ZUVvmcoRNdMf2nqTrCwSvlvNVpfPqyLvXbfP+D0uAVpdvJXqp3OJSQGKuQy/XUFVEUh9NPzu9nvz49hrEBqCC2qurdVFiPJW0EICoadRFqY4OncxFVqTO7Y0a6eAvNvvnXoO7j9Id1QjI0QpW8rMgJtODdUkVzVSDSs1UUnAJ32kHkD4IVYHj2xLfCalHBFmFftSlC/AwdZiMXhRsPWmCMYfvFxQMEManBd7iM+yxQDUOhcOZt3LxeBUbDl/LqwBhep/aWV/+ruVbmfrBkGvstlcGio6fIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:33 +0000
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
Subject: [PATCH v4 25/27] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Fri, 26 Jan 2024 14:15:27 -0400
Message-ID: <25-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0103.namprd05.prod.outlook.com
 (2603:10b6:803:42::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5f5de3-c8a5-46f4-ecbe-08dc1e9ac847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kp1sh8UCUVrQhOOJoAtVrVlO+w2/s3ctEBIvwxBCYdNCtZCNKOFyurSLbv7a9y6qX9DKI/vG2XnrgmYfhepB9K8CwvghTp2/c0X2HowkIaPui6IY7cDJ5jwuO/1rXDpdyl2/nTCdhqDKknmZJ5Cysb4ojPzzLKloq5noueTkR6taJHQy2Qti5ouJHvo5J7uXgRbel0exg2ybXLjUvUSq8BDGSql/UkAJUqGTShoDKCYBAupz7p5Y9w5BQXncNeqe8M06nkBgfxMIY4zLzTOpW6cjsxTL99eS+u5Pn6oTyATH30qubuU/tnSt4RPqp/5aui7j08AOZADhJfIl3mZ6flc3nw14kiYATDysbUZD/+UfTbsd9vTvmQjkjbGjyIn5EbvKAOsBPLB9Bmo6/x+nawLBQGkFdYXy131HXvPsyYuCToHqvW0zkFyrpKsycAgA2B+KOjMYM1xpK5qRmfyF6kq3ulMGw9VuMIbkfStgln/anAHv5h36fG/7ruxgY3dUU0gkudwJUVgl2fPhKNCs2Qm6oBPNALUYy+rSgfrTQPERSJClJxdKB6FsUy8GGoIlDSrArxVJjXE4y1N79gfnxbwDIrqMC4YsVEc6Lgwt0pptAJbpQ6+x68bD65LU+60Z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(15650500001)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uLGXw4cRCDtzad4d0inRXFznUJQb85BV+Wfbl4DRf10mmCoUNCJL5mJHcMMj?=
 =?us-ascii?Q?s+gBaMloQiHzNrIcrO4YZtMS2fOjlAltgeWO5UHwug/9u0GoWcC+fcUPy0BG?=
 =?us-ascii?Q?rFYDRleoV2z1hooKPzkUG58nU1Gty3MG5IUWEMn7mvFJkMkVtD19Qqk91zn4?=
 =?us-ascii?Q?GOEBwsQ1zLiDgNxWcbrbVfZIKzfycMHySbLgcbtBJhJnDWzs/3SkLseH3CcB?=
 =?us-ascii?Q?i+vNnsHh+mMKIDEq4dG36OriXZTK+BXuTs6SS1TVAqc4gOlDKVJCgPpsi6PM?=
 =?us-ascii?Q?+JhTWkLihs8rruBQjnGCYxDks4pt+cevRDdRo/NBXbQeaK2T7L9glxeP850Y?=
 =?us-ascii?Q?W9k9ZvOLcd/kbiYRguV0xAmE9+h9xyx32SHFpPe7U4BEc97Bu2aMJCpQHvi1?=
 =?us-ascii?Q?d1KNWXi9u+MTwlS3EB2b70dcolh00gXN7C7l1vBAJfjc1m0/D8yCsrLg7Maz?=
 =?us-ascii?Q?tTvhXjqKukKqeQvDOOtfX6wxXzY7lBk+bhyYC0l7LQ4VwfE7pwZgvr6ZlKNp?=
 =?us-ascii?Q?PUNxvAyoZf3bBBrBq2OCx8FmhaifcYZWmvcVMwRMcWZgC198gn0E/JDaPfpD?=
 =?us-ascii?Q?usyBlLJeG+dhJ4dfE4NxprnzZRHTqF0xJiLCnR71Euu2fBh/MaHbs9KOnlHV?=
 =?us-ascii?Q?ErDToCtjr7EIqcB8pLECWwMQUbYUBUr0l2Sv3XMbcCLYRtjTiW5EmAJOsnr0?=
 =?us-ascii?Q?nJNV7pZ3A6IZ2TfCjH9P9qUZStb5zczb1Kl1U49uuhZZwjJVjntynDntjbNn?=
 =?us-ascii?Q?4piqVd91RxiSIeVUAc+c8Y69ZQaCwdtDbcIzdwVC0LxB6/2bH0Nn4mbt0xWZ?=
 =?us-ascii?Q?AlPhX8AFihCmP18SXjd+5nS618HPsE4wyD67zB9BewFRMybYjj2Oepm8gPdh?=
 =?us-ascii?Q?yYTBq4U+EBgF6QLtaf0bMUk15/KwlSBmd/g09iGhnsx6LNfJzGtpAA6O4O7a?=
 =?us-ascii?Q?tjt8Fm76r8R5lmED+DFsU2KU7K9/T05NTa6TwyuRBcaXGibGgjQUVeUOtbB/?=
 =?us-ascii?Q?MhYwsieQ9E/ON/jQ5TVPNhmX14Et8YdJVbIWAJhqt7ClSVGC1sOS++YjApS7?=
 =?us-ascii?Q?lFl1l9mc/O2J29zy/FsRqD5f2C5jheDLpcvLnAOyKr93cLidaBntlnJ6sfN7?=
 =?us-ascii?Q?PE943LPjmf3x4PPZRNdsGXHLHVw1mBA8+EBBnxOePrmCnqOhGLSX2qTcYAqS?=
 =?us-ascii?Q?Jp536ng+olI0/Y6GT6Q3jKC7+hf6ZAdEDNgDf7v8lSre3PL0bx5DaTdye/Ru?=
 =?us-ascii?Q?S0IyHYPgLtynSqXdLERJOu3g3Y5HODR/j3KVdkJpig5fne2ztquOMOqmswWQ?=
 =?us-ascii?Q?SWesKtVkehxP5IMwL2ZDzx+oY7r0igQy8txuUwdn0LhPfT5YwVw0WwEv/VGi?=
 =?us-ascii?Q?aEH5GouJS0XySCoieSxc9rnREnDSZ9VvrOzH3FDx8uK0f0BlWeIWdssPYS+P?=
 =?us-ascii?Q?zUr+zATKD0vzjDQKaTNl73Dut1SDq3Yny6gKqOKiapoEHHTmdu3Wxp2AmSBA?=
 =?us-ascii?Q?xvT5tOyixOFGy1hhllIMQLAQpipOnapXqWb1QAjUkKyyRjXwC286u14QjMtS?=
 =?us-ascii?Q?baTMlrHs5TvgzIVxPTKxojFM3y8KeX09iZXpU76S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5f5de3-c8a5-46f4-ecbe-08dc1e9ac847
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.4422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DRS5Ed3yZrEQGkFtnhXuU8j7U7OvHiSLI4ZaWD5PRQDaq7uACSTx1+ZcgF++yw1C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 60 ++++++++++++++-------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index dd49da9e533b66..87f05820a85923 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1537,7 +1537,7 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 				      struct arm_smmu_master *master,
 				      struct arm_smmu_ctx_desc_cfg *cd_table,
-				      bool ats_enabled)
+				      bool ats_enabled, unsigned int s1dss)
 {
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1550,7 +1550,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1563,7 +1563,11 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
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
@@ -2744,7 +2748,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table,
-					  state.want_ats);
+					  state.want_ats,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2821,15 +2826,14 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	mutex_unlock(&master->smmu->asid_lock);
 }
 
-static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-				   struct device *dev, struct arm_smmu_ste *ste)
+static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				    struct device *dev,
+				    struct arm_smmu_ste *ste,
+				    unsigned int s1dss)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
@@ -2837,14 +2841,30 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
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
-	state.disable_ats = true;
-	arm_smmu_attach_prepare(master, domain, &state);
+	if (arm_smmu_ssids_in_use(&master->cd_table)) {
+		/*
+		 * If a CD table has to be present then we need to run with ATS
+		 * on even though the RID will fail ATS queries with UR. This is
+		 * because we have no idea what the PASID's need.
+		 */
+		arm_smmu_attach_prepare(master, domain, &state);
+		arm_smmu_make_cdtable_ste(ste, master, &master->cd_table,
+					  state.want_ats, s1dss);
+	} else {
+		/*
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry).
+		 */
+		state.disable_ats = true;
+		arm_smmu_attach_prepare(master, domain, &state);
+	}
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&master->smmu->asid_lock);
@@ -2855,7 +2875,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2864,7 +2883,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2882,7 +2902,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste,
+				STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.0

