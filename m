Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45156134747;
	Tue,  6 Feb 2024 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232388; cv=fail; b=p2WIDHR6qmkjcNJJ/rPqIxC5YvsgIyd58b3PlTdiltj2TYx7NyacdbGbYNaybClAUr77TjUSx+FRE1OJq2bnkKA4Klty3aGV3YFwl22JZLeHBfWDexQNYJxUTSpCLPP5gmz5fqbZBaMCzWHiRTew0oDBGJ6G4nUQHvr55z9S+ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232388; c=relaxed/simple;
	bh=UKZJ9pLUNGPzhlazRhcE+oc29Gp3XQmi0Frqy8i0tYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p5KgTLYGYYVGFNMMICeNcLfa6ubvus3aFMpbUNt5klTmUGNAUK75WgNQeQKhD7YO10cCaRaDu8+3Zvs7PVD+xp/pTP2SiFZe7ODSiDtOXyCIcyYBsz+m4jL3TPNwc+tMiGlnedTfTS+LcjT7hSudzi9/FdgSAlxjZW2GeXJZLoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bE5OmpN4; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bE5OmpN4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7Ue+Z6O4CkKA3OAYlQqyIbQq4K7l60BFjD9GW0VZ1XMvHo0maAOKqqixSqzo1kwm3qb0oTRdl4v+ZFHFMnDq2SeChTDlPfuEHwFzCoTTtxE3Hp1S26I/Wnbh5+xduPrwZg1ZWq0Ya80VA8izJB/jzF47HGerYsCBI6kZ+fitK4kK95Cw+rdLDNTPRe5oZc8ogWR+MseoBpIJmeye6HyDXccxU1cQ3YHoKq1bNsv+eeEVLrI5XL9hxqzwolvUWPCqMDSNw0Dti5Lt8uVnzloHJ6CllhaR1qMcX31vzrNHzSIeAqX+XjnthUdTMbUFGupcRTYcbsYjHEiCq0oq3exPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0ighcIRQax7XCaG1DLtcRtYK00PDJ1RDaxqVIZPL6A=;
 b=X3U8sahXSCtk8BzgvBv86vamIt0QuxFr2niHs+YLS915eu0cC8K7GABjxnN0Yk+BdFpSXtn4hPiqQzeMRXwYXKI08u2gp56CU3XISZbWklNpWh0r260Ap6srM9dGbi/rVeC+4kEmt4IuGRhnaeDcr0DZVi4hTqEl4zBy5QI0pEdJz1axv17nQX/uonnUKpAvs/wdpehJ/eWh26bR5MeS9PSHAFBqG3N+MYkocyG9AtJ6r6oEflCi9EY2AL6qmmTCmMC11d+1mxWk0I8mC/0dEpDJFi4E6kFuz67Nmv/39MZbNhSu5uwBoFiEtQBGHHYK+hgGT3JnLBC+DGU+k01VYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0ighcIRQax7XCaG1DLtcRtYK00PDJ1RDaxqVIZPL6A=;
 b=bE5OmpN4nk7wfBgmncUPFOVWKk5uS4mX7GltmJEPgLEi7sC1CxscnJcbwhcNZskNpYzqSymLMur+HwLBlAIzCCMaIwvkG8l2EYykEceM+V6jK3E2KzVNDyqjW/22OIebA8D16cbUOrhVfWnvIqZp9WOTXHkkDrCBKmY56ghYIwkNWEqc5Qx/67Mi0VV1vEQij1rcYyYkTLZjVaNQhO57p+//Z99F12g2sKMpJZRGAtA1oG6P1yxFLQkAiWPO5OBzzKpxzO6eLlPbl/FHDMbLFycGt/aHpWEPbKgj5YtPckNiN2IqjkMA29t0diL81/+o5WIZfDGuPr6WjGUx69lcoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:12:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:12:59 +0000
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
Subject: [PATCH v5 05/17] iommu/arm-smmu-v3: Build the whole STE in arm_smmu_make_s2_domain_ste()
Date: Tue,  6 Feb 2024 11:12:42 -0400
Message-ID: <5-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: d926bce6-d496-4804-1867-08dc27261881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZAeVtXizDmYAw+WT/RrRugTuau9tOZ9foYcTdXZM1rMVKJc/J9EFKzfmTJL9rAGRCwMtumyXK2Tlk3KcnnXaENghc2nIScJJltjv0+ZiJpNLb4b5OenQZvjqkUybpNjiA+ejPmXM2QEd5B7/ENnbI01oG+KbVTqoSHGCkMQDtvID3CE3xGriA4yuiOFAqWFwh2VAWp+yiGnWLTHNvdaootNsMVNRPPjoq1nY9/qBq0pjhKwpgtvsTyNsyL0kf9mflkQpmTqNA24tB34g/Ni0yQYjlTus5pXUTMjeazJI5wyj4xpzjsyWAfuEaU2kZ+/GjJtA+vYFAbNP0+2zGRiCZvZK0ga54WoSi9Hl5AUg73/lf/xMa7bPdeEVce8WoiQi2tGNyHJmJ6xG8+rdp9Hy4jOARgiRvuM85yPTN0ldxQhn05x1uwcbnm9UYzTj/Hcqe8KxFqs+kD4P81orLnt7jkQcxODwe1zYwFP3pCqIcG1Xl3Gx7cWjmSbzILVl6yhdA+xvX/DYiTWIyWKWjh0HmYmqy/ItgYqz4/mIvgpJpw87DM5upddDXEoDCTxgbHhluk2X5/E4T8oTndKMk2LlBcf0NVoRYlrfd7NxF4Y1k6w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9oqUijKTv4wu+VJwTvG9eK1cqQmNQoLYH8bfBwvnIq4f0JuNlv55yfZcgq4?=
 =?us-ascii?Q?Or3x0Fvv/KyidI7ISBct67pLN7HCcNRPJZoih7cYCLSbGzy2zwwPYmTfe6bV?=
 =?us-ascii?Q?E8/3yX1Crn+Xy56UdQqgPp2RFI1vMosKuG88NDcxTb/PtEcpzgwyOhsATEqG?=
 =?us-ascii?Q?Ekgq5BnES+s3I3TraNs5omM4ILOY9DKTUCir0c/zFy2C18/Uu5uDR3N7DxO7?=
 =?us-ascii?Q?+idqSoB+2Q2b7w59lZYQVgruM1EwV6l1d1h8pkgRx7DSHhvnsVQZKAI/d3HW?=
 =?us-ascii?Q?THvY1UqOtcwxSoN2/1Yubq6Sm5eShvDiy81LIPXp0hVj7BB5ZskSa9TIrmX9?=
 =?us-ascii?Q?TFFjMCJn950Ig5CBhPYt7qQ+PSZVRZ+Fo+JIQdcvlfs4h6Obx05hk22Moh9T?=
 =?us-ascii?Q?x1Mr2ZXaVwdmIY4A0kjnVIcm3kiEhSLBwPFsrLNTlgbV8IpWuuYS1CXUBbrs?=
 =?us-ascii?Q?6Vh1oZAem1k1YrDTTXID745oHuQo1q9jEibyZ3oOqLreXzZXLOfiTfioXVuU?=
 =?us-ascii?Q?vQUIvSvGJn7D7BVSg1G3dKijScxnlVJ/u0oDGB1Sw3p0Sc3C/NRvXRPlkk0z?=
 =?us-ascii?Q?C+uWvpjwO7VlUNVfhh5+i88AC9HimbXpkT4BUoPLigcqYJFZ1WQBlXCswj0w?=
 =?us-ascii?Q?t3pFNe6SvKVU7gJUD3o+MWzIPByqgFn/hdWo1YCKWaqXKJb+rgW8VsmmqSjC?=
 =?us-ascii?Q?XgJq7JNwabNgnttFHyb+qhSZqIEEFiETDt7lioOrCo/GOC+//nkJm46h7CoA?=
 =?us-ascii?Q?jFsCFqv/7Kj/mL7SK2Wnk3s8VSh0KYUcrKsp6a8m2INrHtSsM1U/N9cCUVuk?=
 =?us-ascii?Q?BskOm+sse8lNFz+1R4yqcKFp9yO5t2tNzwsbmwM6sOjaPqWGeBC0MNH6S1LA?=
 =?us-ascii?Q?HHMjisk5VlaR/j727kp6bo4r9DkAZFFrM1m2JRKWpOwuB9XuZwz8WYILebpE?=
 =?us-ascii?Q?xyrZ2XrYtg/EUL3m1xYrP6jK832JT93GKVcB4yWJ1GJht1EOUyr9KW7iqpEg?=
 =?us-ascii?Q?Fk7RNZk3n43NcaJo0zvametxWpr6dL62AsZaxQRKTmasspuPOsRABlQbcGfU?=
 =?us-ascii?Q?AN8AqLp736pb+xf0f+9QHpWO00e7hI0Sj0zhrV0Q2LQt2rWNpE9hRnWfLDgX?=
 =?us-ascii?Q?NNA8pV+5mAzez5UE8l6kn5wUd7lmK866TI3s5Fy8e4RnpoiY2ci7WeFhav/B?=
 =?us-ascii?Q?MlXJqvoZkpr3lKvsR6AlLNiA7wJbErsvi9Wc0RHDXShRyRY/f7WjhzWKVaX6?=
 =?us-ascii?Q?yZcL5xsHk+zlE3P+wcRoleREYZpZy/rUeO+uOlyJWQcqv4zcIfnYIDvgOS5h?=
 =?us-ascii?Q?Pxr8JFj5jPGcKV0N4x3SXI8bKze142pHdgyQ5Xy6g4CmQ7mFash0RN2ZPyIh?=
 =?us-ascii?Q?U4r7NHL2yGDneH0XY7IsihliZRr2xl6h3YasCs6ouhuywAOkMQyXKSvLR/P4?=
 =?us-ascii?Q?p0S6bCNpUjjrXbh7G5HYvZH6yyjeeAeDTX1IerSIDjzeOmZ7TQnxn+5CQSrc?=
 =?us-ascii?Q?XynYTnwNhmbhgg/HGu1a3uBLR3FKES9XBNL/TWCsoATab95ul/SddF0uUgEc?=
 =?us-ascii?Q?/f4iUTQwU/DYUbieK2JvxpSp7wePthbO0vPOdRrB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d926bce6-d496-4804-1867-08dc27261881
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ms0e1URhGVYmLMwlUJw+O5+dHbuUG/t4RO3zFg15Yo18n0Q6cfsixyEbjaNK3dOc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Half the code was living in arm_smmu_domain_finalise_s2(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 ++++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 --
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 893df3e76400ec..417b2c877ff311 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1573,6 +1573,11 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
+		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	u64 vtcr_val;
 
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1585,9 +1590,16 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_SHCFG,
 			   STRTAB_STE_1_SHCFG_NON_SHARABLE));
 
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
 		STRTAB_STE_2_S2ENDI |
@@ -1595,7 +1607,8 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		STRTAB_STE_2_S2PTW |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
+				      STRTAB_STE_3_S2TTB_MASK);
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
@@ -2355,7 +2368,6 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	int vmid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
 	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
@@ -2363,16 +2375,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	if (vmid < 0)
 		return vmid;
 
-	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
 	cfg->vmid	= (u16)vmid;
-	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
-	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 53695dbc9b33f3..cbf4b57719b7b9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -610,8 +610,6 @@ struct arm_smmu_ctx_desc_cfg {
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
-	u64				vttbr;
-	u64				vtcr;
 };
 
 struct arm_smmu_strtab_cfg {
-- 
2.43.0

