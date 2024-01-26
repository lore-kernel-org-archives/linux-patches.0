Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3320B14;
	Fri, 26 Jan 2024 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292955; cv=fail; b=qCI3eQY1BduAVvsMDraMYWe7LmUN2J9WAQNj3YBOqqxgcb8VO1r0DBoW96+A5kxxodBUS24q1GFbSNKcKbyZt6Ic8VSUi20ssnXR1wn8zZ8YixWV7fOu5eNfS4VIhqdIFt4jDM4JOFD5GDILpUSR3tAgok+YBUcLV5fiMHIFJRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292955; c=relaxed/simple;
	bh=Lv/n4asP6ouMTGKljDeB9Jw5iMysV4mB8BTyTPUFiLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OJVl7ijHrtLces6MrpIQyz45YupIiqO0yRwiJJWTmEINDIlRoAzB9qZrKA0+cirTik98qGOGdqOAcvO1tdGUYE/fzN7lvMxe1BMvZqHybfTVEAqYPcyVh2kr342JK/6tDbe7wATYt8PuZDpuhaxfYIW5pBCmhu/e0kezZNNsiAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WwzjwJe0; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WwzjwJe0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDOBTkaLrzVP3DxTG3cNkfRuprNMrIszAz5m3AUr2RhYt+Oot/PHNZ8/bD+pUX34AMzZOdCi7nTA/HIRbORPAZVtZbZRN2YgPkcRHYwWIUwtbu+M71kS7SXsg29Rfl020KsLgpOC+4+QtAedBtYp6qOIlJgcMKSYkxYBT04kHBBUwPwehO3qhbqwaPdKzEFvRwB96C1Wu7ja3H6Ijj/RE+wDKuOPSTGRZvq+aPNb0JhJPDo50KTwRZsdyGBBx/Ls++KcVT7c9O5ts8eKplkTewBMcuPcdcXhb47QCmDM/CotIEfyux3cJY6ocCefMlHvV1VMG9PmkkchJiQnDa3Z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VV9Yh9P4a4yc4QjCzu13JeOuUpTa3tEya2OAACDUKko=;
 b=Q3+Tpi/Tyr1PcnBXXFQP7TSKeEKihK3ep/WY5AGGrs2UOsXMNnK+FZabRhsZleuavNbQi17V7v3Js8M6srHv4K9GeZOxatHd5JFzfKiINNFc7V4fAY/CoiEnSWZbiu+FOxLa1VY0Mquv1tBPqfWuUCqox3D7qyp6ehLgM/my45TuWBUit2YoZFdGo0VOM5EL2Efi8thAtiAdQZkQMWzPcDVCEKvN9Iemq5i+orOLmSX9jabSB9wiv9nT3smXjQSyZn22Fc6jVM7MZ2E4XV2C8iGjlaPZhHA3dCgSdQDIK4mscom8vYVHSsQ8uGwkosqUOJN2c5t6lDWwJfHb6xKX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV9Yh9P4a4yc4QjCzu13JeOuUpTa3tEya2OAACDUKko=;
 b=WwzjwJe07jUxejN5Ojw+2cZoBQ6W4sciZZ69+WkNtLVRqQnE3lxa6uW5NX3ip7kyIVM86dVtzrfgPefvn+HKB8KIKbnvG9N4v+eOUS84fHCaGwBEud3VhQI/7gVEaYEUH+5bf9UjQMnXQUUdUOEeTZGZp9w6mhrHu7dR5c3mvf6KbfHEk2/hqucFy2nlF11u9NNYX2CcAzG8r98nWfSeuQ4hps05Bt318m3pzRvVJprOmExJtYKyU30ep/XV7HkCpvisHP9f/kNPjKYByBMX1n7A3C8E8+5UkbXu09smSkTtOuaLBCuM2XMMi9x9EAPUnVqzW3h8Siwc5N5X/6+kRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:44 +0000
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
Subject: [PATCH v4 26/27] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Fri, 26 Jan 2024 14:15:28 -0400
Message-ID: <26-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0108.namprd05.prod.outlook.com
 (2603:10b6:803:42::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: d14776fd-a450-4300-b93b-08dc1e9aca5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EHSi+tuatpFdKtmI/NStbPSZxmlQ094g/YVUnzfB7e7SjO6LUvT73n0M0IqejaTQmepFufak+8Q6kER1F9ZPsFpfl/xlstY2Y4GtHGBupsjkFqilhEUXxhCUEUIBNgc9Ht71UPXjPGZJ/RLpFvnfqfm+pI+Z5KC4M9BU/ZXSk82Jzan28/B8SNgxAvTy9cENb8cvRdnvGMvGiDJPqc439Lequb2jSvvkA1+vXS54ZZZEaWGkxBEaPi4kUP7Sf1okGbPdpYpD57eWiwR+6z8mibbIJbNIAbYO8w+8iG7JDfNeynIoxaPziGw+pOAPUL2YHdQQ7y7QRWe7opkolv5FZhdPvSSOspNT/7PcL2ykrVSWYzhoujhiAb4s3NCuLksMgV0ZyP5GQyjvhUOKZnm9xS8HAJvRelHPfOU5awX1fF/411vdUvfSGUBZCEbBosgtxGQwDKn6lDe27o+NUhGacr6bE5tFOd0tNXGQIDhmF+EJ8Gni7ipsT+qZ+CSQ4dQvVd3duIfNdiTgpRrASK0tjPo1ge150xHMu+EvSPdYsQ6k/ACmdOcizNxup/zjs6Mf8m4QnyE8xNKSV9MV0gyJRE7OEI8tLNrr/fLW7C1Ji1iGMXl0t0qqinp1Dd3+rhK7aU9ouExXQje91v0g0PHi6g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(15650500001)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nzpcjW5/QLd/pvnPjzlSxPrOuSAa6bFPotEDzEVPtcu1SP6QeBLcmu4AJusL?=
 =?us-ascii?Q?QWvR/a8Pbge8kTBKPE7gwvG163J9JaxI6yd/mcfM/UeswdWNz7UgrOzgzYR/?=
 =?us-ascii?Q?PwNNXNjgfP/jGVht3Ma+bBDOecIre1cRL+EMc7U04OEKvxh7L7xuFApzh6fZ?=
 =?us-ascii?Q?IkdXBQ1Ya/nrblMNWeEpRDwq2OkkDZKCWV0tTomUnWUFzanbWDlxjJ6+Icau?=
 =?us-ascii?Q?NtovPjEnKkhWQU0WAu0R4ktlT2E4v7Tm9pAYNq1rwcW23CgMiZnvu3k0vUKg?=
 =?us-ascii?Q?d8bEwj8UKERywMdEXyw0khfIibAUQ88/pPAyv9QjU4/akiDZ2qxcPv5mTkGZ?=
 =?us-ascii?Q?pahVc9ct1Nl3NZcd9QDEbQranjHri+qXCT29CL/3DzLS6Fr8k7zx8XL+gh4c?=
 =?us-ascii?Q?S5xvCVonY2Q08souYmspxaNk1Q5MAqVeeu3JpFEnp7/mSW7G5O5cfVb1rwdg?=
 =?us-ascii?Q?MjxazZsuu/Deb5pUXYomVXwIPJuIptSof4VfTk0qw4NzuK8BQjnLNCZji+bP?=
 =?us-ascii?Q?/+GTxLueDc5jXoE8echJEj13z9xrxtmkrThAwfZqXpInWRR0d4yascKNaJeP?=
 =?us-ascii?Q?uj922VL+L3J8K/yqJgSajcbyd29BVN+XQQw9miT5VZbpsPA9SK0KG9JnO/YT?=
 =?us-ascii?Q?ja5s25KAYbyfZeLxwlhHqAFkA9uuKjkfl+cGSRSHL1twZn49ZRsIdjwWnO/o?=
 =?us-ascii?Q?naMBJUZDger79ec7ZuCt531B8EO5VUX6kYElJvm+dsI/0VC3lxR54vmWMg1c?=
 =?us-ascii?Q?kysu2LtV/nMG3sR6h0JU7rU7tFaEbnQq2ptoWxOEOWN1D2gaU38bwThTubjS?=
 =?us-ascii?Q?F3sHf2Ro8sNF0YAT8sYez15VpboF0dor3y9ZGLhTMj2EL25RdFzYRZU3vQxP?=
 =?us-ascii?Q?0JagzQbY2hhXu6/IwlkCaVhfqQR2k+ijORcmlChc6PHoTRfPcqYqLhonBa0t?=
 =?us-ascii?Q?qhCUI53l1ZHIvMQmwZE0wVSjZom1CBJBI+1WZhLiSftrdLivoi59mQGhF63e?=
 =?us-ascii?Q?fYQNojemtu+m+BFAiZlpIqc5/NkZi9t4l1nyUOfFTx2uCw/RAsYkvmLyfVgt?=
 =?us-ascii?Q?VwS/5iw7FtP6Uk+dArnAguRYL8BLC5wrOBhn+fm6IRbMOWcG6LF+rdSMIGgQ?=
 =?us-ascii?Q?dF38QcCR6y2KebwSUDolTcXKOULSDGaVmiMnbQzBrFMVOqyxdR3lB7qzMHox?=
 =?us-ascii?Q?IHkVbqhVtQR4lgynHqkiUWWJ7pjwFIxqQL3Z/pQ6wE87haW3s3jOVWBwC63k?=
 =?us-ascii?Q?nG9XRdzqNZIWhdfmZ3vEghG5uSN52eVuciY7DE8gJ8AJ4Pb3eedMzTcHR0GG?=
 =?us-ascii?Q?EYMVZ5RxDG2jsMrC+hMXpmoQtZsOBzttsyQ5AdEXwFE2O5Fga4rFhMt7knw+?=
 =?us-ascii?Q?dDck3ZEgH4jXFGgrZr0iLNotQt+y0w84vIEZcVtxQaMA/yzF9yChLxM5OJNg?=
 =?us-ascii?Q?TsTkE55dSXyJtaYIqPYeQ2opZqTuQGbfm2rxIp/ncCEDajkqDEQDKRK5xtjd?=
 =?us-ascii?Q?v0iM9P7qnPJZOi13fzmMz4DkQgqIVCC8k6vRuwFPoYHECd7tL9ZnPRMSmNbq?=
 =?us-ascii?Q?sNh7TxTaydFOreKsvKTKfJpaUC/Pkh3SSK5WYSHe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14776fd-a450-4300-b93b-08dc1e9aca5a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.9871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JqtVwrCJwAKGt4OqqJSuVsHw8juPN550CUZ5mbzS8xvBMEKkaV1NTMPsm7Hrdk/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 ++++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++-
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 87f05820a85923..371d7930c36390 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2439,6 +2439,13 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	master->cd_table.in_ste =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
+		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
+
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
 		struct arm_smmu_ste *step =
@@ -2766,27 +2773,48 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
-static bool arm_smmu_is_s1_domain(struct iommu_domain *domain)
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool want_ats)
 {
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
-		return false;
-	return to_smmu_domain(domain)->stage == ARM_SMMU_DOMAIN_S1;
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == want_ats)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. The cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise
+	 * it installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, &master->cd_table, want_ats,
+				  s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
 }
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {.ssid = pasid};
 	struct arm_smmu_cd *cdptr;
 	int ret;
 
-	if (smmu_domain->smmu != master->smmu)
+	if (smmu_domain->smmu != master->smmu || pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
-	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)) ||
-	    !master->cd_table.used_sid)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2798,6 +2826,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
 	arm_smmu_attach_commit(master, &state);
 
@@ -2811,6 +2840,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *smmu_domain;
 	struct iommu_domain *domain;
+	bool last_ssid = master->cd_table.used_ssids == 1;
 
 	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
@@ -2824,6 +2854,17 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
 	mutex_unlock(&master->smmu->asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (last_ssid && !master->cd_table.used_sid) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		sid_domain->ops->attach_dev(sid_domain, master->dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ed747e25f2367d..b842414b143c10 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -600,7 +600,8 @@ struct arm_smmu_ctx_desc_cfg {
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
 	unsigned int			used_ssids;
-	bool				used_sid;
+	u8				used_sid;
+	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
@@ -708,7 +709,8 @@ struct arm_smmu_master {
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
 	unsigned int			num_streams;
-	bool				ats_enabled;
+	bool				ats_enabled : 1;
+	bool				ste_ats_enabled : 1;
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-- 
2.43.0

