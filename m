Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2D267E78;
	Wed,  6 Dec 2023 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bJv132Qz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYQDWEXSjGenIBkCXgJzxIuAd9jY0ISMv6s4Bk4NnC+4J9L/ijoL1bnc+ZdFhzhx8rOoXifKnyedmpoukZvKKMJJwbCiSxaA1FfG6+GygBlC/wA8VjJN+3cjt3Fmk9VtCWoRKIwIVC971VunpQxEhhd74Ybxb4SjdwZxbmarGNZ1isdcUMYNvjOTtMw1R4mkJEuG7gZIPtTCyyN6/MRPJ2afXWujE2TY7bA3Kw0IDDQtLdrSxR2juauOoujCZV8EYUk8GzPgndFBjb28+lShIwV70ktmMuvXpoP/AcSxeo2lwhtJerlSTogZrKc258Jt9fVSjTWeGkjIe8c03XNn3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzTs54M4R0dJXEkA7e9eEUaQVjze2XQHFwn806D0TLA=;
 b=Y4ud5YzCwYzTdlEbYp3cV46AfUZduFKmu4BG4mawLwSCqKQvNdU28pLt553EB75f1ibGYr8QEayMammC9TYwpD/JA8+4EcMDN4nQmZlPvUFufo13hx3u4zKnOSHhPHA3jMpGm4O6tQnKlhBJ8O8DnFWF1dqxfZcxvGDgxVG0Ji7+UKwBUvo1zQajDJThZepv2lS4PUBRYv/GBgY+LV0P9JEQdd15vGDAByzUSYb4KY/SGmoozf4dmUD3fTZs3RDaI+lO4GG3geSaeRXP3sqBSQa9kmccE5BglGepbxFJRc08ZjFNDbIfSKuTfPt7+SPlnNw7WCfra+AVEISD9X0J3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzTs54M4R0dJXEkA7e9eEUaQVjze2XQHFwn806D0TLA=;
 b=bJv132Qz4lgNx/twnPJbL4SkCBuNOdpCmd/nETn8/HVGdz94YiPhuA6cCqa/um7DaeDBuwAhlW23fyCXFtTpjGVpaQxP878fbLp1jbVFUotxjK3y+4nKLlcIlclLhVZiAPDC3TYTM9Qxkh5Y+PNU+bHYVdoWtgVQ9j4xXoy6D1reKZRfCXxp4XtMyUqMQznoEfArUwGR8GpFEfZDFtVlWv0WO4pLEuqjVPAp9CHW8UobWbsCotK3l8DelYi6emAQZezq/FbGFIpy/DE7/o/rO6WxtoZSHd48jBOp8EhaiIZmi64yQSvsauoTJh2Ke/OZf8xgrgwoyz0b486ACZJn2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:35 +0000
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
Subject: [PATCH v3 12/27] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Wed,  6 Dec 2023 13:28:18 -0400
Message-ID: <12-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 7973dee0-1f38-416b-24f7-08dbf680c5c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jtmy4q+58Wf9vAW0yTZtgYiEUcL4Kvvo9b3dR4KxzBFjDa/nnBGan3Uscstp35HF9uh/6UejFxMtuhvnZKeNu0KWkkMxaWtoLWQDAhK7u2STGvwmx6ntOBNbo2HCiDvKCtDYaHSuzyd4JeYnsZ6UJd7sLOAPwxKn7ABcdaaLEO8TH/2Wi3IsENT/AObvgB4STNbS+mrxtNlzmDeGp3xnjFgDbS7mH9DBdiDV/XUC/qN5RmsD2/cqCqH3NJrjJdO/i+8jRYPL/ekaKpoffFwjVIsHrKCJy4QZn0p7EN7n8PYw6db8kT8ZYIOw1xNcvL+ckFea1HG48RDRVWGFs1c9SJjW8o3swquSLdwdyT9uiWTyD6ISgxx015tJA6N7vCDQB4/xNlxB1gZna8aAuRGBl9+7Ip6y9mRWSRLkO56ZJJrrOhy8QXZTwbAbTHPD+eAD+pnNRzZkMzkX59yY1+pnsTKyFAsbBfmTYMQYXRIUWViUQ5a0L809+9+96isNcT82WpYteYPYUquBBZJl5jJ6axbkBKZ24ObqIlEgEAow1rJCD8HtDLsHw93WB0ovYCmV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zhxUOnFVIKQs9567PLgGThqVOIkfVvMrSSMgyhIS8MqEcULhFX1SZvNE8Ohw?=
 =?us-ascii?Q?xYl2q9TbpoRz6ofOIB2HOmGd40u2gajV/TxrD8oaKnjPcYPo7jt1OQad2W0t?=
 =?us-ascii?Q?CEa9c6JX63HaYaXM/Kts2L8eWJ24xpxaNUFy4BFSaOjiTtfSh/HC+f9oQhe8?=
 =?us-ascii?Q?2hm1sdXLxfd+IxiVnI13+yVkI0oTbELX2q5R0YGmoYu3576mGDPelVvuy+E9?=
 =?us-ascii?Q?QTwYZAAhT0cCGijr/MZyzxfz5YGVNYiLOumLB6mJiZycefyvspUB3NgwSIu8?=
 =?us-ascii?Q?8LFWI2TRBQme0jfGD+dtMZXYfoUgSZHn9nkRMUNg4DlDcHwWGwARFrCzhKAg?=
 =?us-ascii?Q?n46NzsPvhhdZk5YkjJRcv+xQIocjgcTfkA1+++3JjGePNBIv4NNh9R/mUchb?=
 =?us-ascii?Q?SU2GlHINJu79dcL27vKVxIn3wphyMtoZmrm9/XnrV8MyZkXOhyMitqjqMnbb?=
 =?us-ascii?Q?8c1zJKMTSdHamaEnKML9yWymBdNIocWsEuZgcuFo9N4CmP9o8TauwE59ig4y?=
 =?us-ascii?Q?UoMOu/DQTJT6NQdDojvD25cSA71CHh+/0o7c9Jj9PEt5bo5DtESiVthcOwM3?=
 =?us-ascii?Q?1/vjWxgC7meugs917YJFUA4fvd3aH2cmlKKRXEYQ0WQX2GFjEo8CRdzUMlx4?=
 =?us-ascii?Q?oervDk0qKJVCI4lhQmvJBKERYtL2/rtfWDDdz7giVF0cuK41cHbFYZSRJWYf?=
 =?us-ascii?Q?Dhl2mQBGheFxYsD7MP39ATE8ArjQy1pFnEEuMqHahyZH73fBF90sETJTwEBe?=
 =?us-ascii?Q?pzGrn4JAKqla50Hd6oVudWW8xsSnYtKuB5YFztUgfT/y7c6n32rb7Hid29AK?=
 =?us-ascii?Q?fgfMHqkinm0Fg9PTsWoWKRFFPQbMxiPrlQ1LNFlm+lVQikA8K6lrOiywGQUD?=
 =?us-ascii?Q?yZ5XLMm8/jJ4WrPDu+2y50UxRj+Nqhs2QDWAv8KiIkBqVfFR+36VjIMAWMob?=
 =?us-ascii?Q?h2BvHWNajc67frmS8VrIJXQ6jU4qt1Su6/Xl778RoyVZs83IQJjLFtn5gd/l?=
 =?us-ascii?Q?e04QHXL2XJbnJy8+fVw4w8bKukugQnbrvMDTxfNoh8ldPY86LOmX9eMg/g/5?=
 =?us-ascii?Q?b0RuOksDU4tYqOh6fIo4WEQBJzcKWba8Ws8pwQQReOllaNxhtSCMWwhpvmOX?=
 =?us-ascii?Q?swYGHFKqFmkpy48aRW23bNFuXbPDYsmtyUQpwat7v9BDjhBOWWMup+rnwfjn?=
 =?us-ascii?Q?e+U/p/pYLitB/JtZdXAdIkQC3blh9ipveXH70f/GUEBJt43cQuYXuX0rfglH?=
 =?us-ascii?Q?Hiun9L5kv2KeTf2mmO1/LL4Ga84X4sJ2sbFv65n53VRxHwbLrnWupT8Rhwa/?=
 =?us-ascii?Q?3XGHKIoEhOzyqfc1y4CJWj6piKUqTJ4vl7/EXi+dp4l3gwxY/45cZnBlrwYN?=
 =?us-ascii?Q?860KSGDSZu7f7Csr278FTS/xqMLdZ2hCWCyAxcSJk6FCCWWiyJPbtQwpIpzF?=
 =?us-ascii?Q?v3d/3pM8L9iNhIcNcxA68z6wOKA1Nz7MzpCy9yWSw0tZBw96tQ9rBVMOGWwA?=
 =?us-ascii?Q?6s7yBUn8Hnzn2rIdkVU8O872bu5nOotCiqAnBCKKNcG5CMuR8nD5+dB2gQXG?=
 =?us-ascii?Q?B4+lN+oGPwFuSOXvoqvg79ILqeWMNyIaOFUqa3/C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7973dee0-1f38-416b-24f7-08dbf680c5c8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:33.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgCmqTgib5tiYJPvK9xMpH24pY/Vkir5OKx67pS+bBtgH+qgXvUHyPfdZdc306XU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 27c0a468958dc0..38e83386f631f1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1204,15 +1204,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
+		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		cd->tcr |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
+		CTXDESC_CD_0_TCR_EPD1 |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1220,9 +1230,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_ASET |
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
-
-	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(cd->mair);
+	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
+				      CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
@@ -2240,13 +2250,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	refcount_set(&cd->refs, 1);
 
@@ -2254,31 +2262,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	mutex_lock(&arm_smmu_asid_lock);
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto out_unlock;
-
 	cd->asid	= (u16)asid;
-	cd->ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
-	cd->tcr		= FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
-			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-	cd->mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
-
-	mutex_unlock(&arm_smmu_asid_lock);
-	return 0;
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int vmid;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2302,8 +2292,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2346,7 +2335,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1c756803b7f963..b7a65e37c51e9e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.0

