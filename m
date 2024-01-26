Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33353208DA;
	Fri, 26 Jan 2024 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292950; cv=fail; b=R5qb1kqRdHIz46BnmYWIe2G/mkmj6fujf9nUiX4KipGt4kwVyVYxHjUeuMglLla9rP980YDENnFat5dIu4qvyAhg2puR0zIJIFvbLydsGqQRPpl7hjS9V0dvIm/y0ARvn5O2cJvgySrE+/zWNEyS7Yo+S5DAB8yxw4aJl7xbSQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292950; c=relaxed/simple;
	bh=VV1uaO5KU8fqaRilsWEQ9ntUUgBbt0gRR61G7JyxIRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QGmAFZhHC9yUpC+9AnrFnjROuBD0rz/Tb9mBT7j7wDcT/6FPMdLY8ONMdmuWm49TIn3ET1pebRUpl2UWxWY7SdC8wc5GP8EeCwuRAzWoLz4lqioyJKs5rsVmzXBe1UW7jp6/Kyr5v2vP5P67W9y2cZDThjpCzVnPfmvdfCAW8lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fn34FJ2y; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fn34FJ2y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amHHDWVvMmWHJHSCG7/tax8avXSj5jy/GwR9zouXODjRjXrrVmwjcU9S5dSHFdhCtaT0mv4n5O+1U3H7mISFPIu3svdFBSDQCtTWRCafwz2SSE56KgoJAt37l4ujROeTYsBsN1YBZX4bLQCVUW5ptiNP9L1nYq0H/jfhJp0fcD86Bg8Y9eYM6yyL59qpBWZ5rNEeAEZ3HffDldLLQUVDOahOh40steWSO7JGdL+vkYy9selAg2yub1VsCW0t4RaSFIfIkobLMCNLo/Qa07+XCggHrErdzqadjPtQb4jlIEHEr1AzoLi9KD3ZmoeJVE89/rfkX6Ed1Rg608SM/R9l9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tV/ouUpLYAZ/XO/6/oMmXJFpdbP1MVdFztgCouOheKQ=;
 b=HcsZ6QkyTL1fXpCevoAaXEFsunlMVnVii2KIVQptaEnIMC7T+/AU8L/MskxCluYjVia6enhgFBLVzRXJvvzre3Erg6tHjkVDSHBlMKFjWlKYW90a/sufLyNPDpm6uJEgnUZiAwobZc8lDVwUMoLprrN8xCW/fEZ2Z4NSTYfI/4pB3LaHsuDwEZ6Bj2YeCYL4HRB1U2/WlLrKXPwxKMzZHd26ZVI3TONZU/8M6WJkBufSvvp8IV20lOyesY9bqh01VV1ABnz0ElNN+/FYwLDaB3r5VDn0CUIQzR3X2BUIiTiB+fa7ShAY9O1nOr33BZeZcWIZIVUDvrZYwVV39cKh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tV/ouUpLYAZ/XO/6/oMmXJFpdbP1MVdFztgCouOheKQ=;
 b=Fn34FJ2ygWA4GOVF8lmMpZ9QFo4AOQUQhocAsf5TWE+CsEm2CwfT4vgq5Y0/lRx3dVKtZRTBXN4Rzea8lbYgxu6Xe6YWeEeP9UzDRr+Mi9DJxbEE4Q/d/kkTnn0qfcB6DgbqTDhWkp6gyNrngDCrKNaniik48o3fhL7rpSZkvQehsCjHtxlqWXc7wRhklY0Qar9ZSg+UBzQHoMuUtDglW1eMtfWsV8RbTi2nu8aIeSP0J34lvc7ZKdYHNaTesQlbPjMNU/sqD6inZ5kQibkj/EnMCKWR8CPAysSbb/lX2C6cj34hrao7+qHlqBmEnDnO5HNY5JVF0rQiRBtNINV79w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:42 +0000
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
Subject: [PATCH v4 27/27] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Fri, 26 Jan 2024 14:15:29 -0400
Message-ID: <27-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: d1b42e3b-38bf-46c9-0fea-08dc1e9ac9f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/WUGH010zlYZaKWAC9I6oIIsJcqXEX1Jcc/DN3RbVGzpMfPj/ZdptfSCncyv9FMzjzlv3Z0N8F18Mst4s8iVEepQZCV5Vfg33TEppVntTjPgyeWgPxSSbm6wbt8sC/5GtzaTdwiv64nEZ9jXEYXr3rJqB+0GoVgSvnlywB/RR1IKux3R6NvrhlyvP3NLJjF6+mqmqICptl6t2L94x5hzV1gDBGB6upWP1L32I2BOL5WjGuOR0Fbcq/bx0/kYWz6g0g9ZiWRIzU2FNNiF0E1/Uu5xVL3OLYIvkvq3mIGWlv3CTpN0IY3GFvEA0MVSPg3GnAzc+Ql0nIcthTM8bHHDKaT4ISf3Ue/WSDhb6wjO96m3fEg22HsOJgpEy07VR7a1JpVWq5XmEmbkKImoofaJndlVbXPictJkRI8VYXKOxQRdunFpi+YE02r6I3pN3w77clhd1AfjMosRRaYOS+kJ4YDiKHPbDKyKb9WMugUsPTwtR3kcQC3J2JS/P28UjzGjFVRd1TjFtwg5amQnSNbm11hMnNUvf9utYJeVaHarkUhh01EvOzyCjN9sOjM/Wscg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/210hny3+ug2csHF6rrFIsq87HaeUHQSwURngOhCknrX23ivJwR7FYkWIQ1t?=
 =?us-ascii?Q?brN0BdCrxOlPFurl+aIKyIy35t2sGYDyZM/EYpO5qnv7woUUtWKeBJqE52ra?=
 =?us-ascii?Q?QLGWsYjk2UKwPrafdqAZBnVZulEDtoQj8zQAug0pLE36dFbVf/7Mv0yfHMVp?=
 =?us-ascii?Q?zmAmrAfkZGaPX/PX07gYVgLJ/LVjfd+KvSij8BSrfcSonisg2Dc/AAdzCFxE?=
 =?us-ascii?Q?eXFnLXg9sNWER77Jbf6jDhadVeEaxKDfPV7koTGs+jGrFyG9cSJt4lDt8ypm?=
 =?us-ascii?Q?D0w7ekZBl3coTMktdTWMNto9RXGoXSvhqs6QJAqIWo7FZpJL+GcSf7t9lBD5?=
 =?us-ascii?Q?lTWE8jvh4hdFJkPXmGTnyNGaCkCGnPV802ySa/8Y4gr0avF0wVKYiCMTGufn?=
 =?us-ascii?Q?wuZj/Q32JwSlISQ16/Rvibov+9PopngPOPjHUnlNCzUzGCPW8XvzeOR7jO66?=
 =?us-ascii?Q?MhkG4qLZJzmEfgNA8Nal6JqFAzRsXi1L8OHc0F6O3RTjShRELVn/DGLH9CLu?=
 =?us-ascii?Q?DSToBGj4KK/g0rhp66bhGi0mSYq7LsSqUd/QRybTQDGALp8BJTMzTRpu8Kg6?=
 =?us-ascii?Q?GNbPdWFLbNp4NboaeEBEJ2flxPgStchVvh/IZd3agp47mBGUae2j3c9WRvLB?=
 =?us-ascii?Q?ReKLladj4s+SxVW1LzYlXGzL90tMPq3iBPQqKXEJ8GHSZhGZ0DOzUOA3YfN5?=
 =?us-ascii?Q?VFVCwXQG+4rnMm9KQdfuHFdqV4JPkvuboLKq9xNt+Jw7Rk9K7FWO9dSXxwYU?=
 =?us-ascii?Q?c2MGN7X3V4TezH4lW5NInfrundpuAGzRseeugIowFZVd0L2PMibpzwuEvhj2?=
 =?us-ascii?Q?EqyAqVUc6MO5nBBLyzclU/XADrq4sQ648W3Vcuknh6pdH5P9EiihCg2VL2Cq?=
 =?us-ascii?Q?bQtgOt+Z6NPq28p0Ffo7LNvsfU2T1kUu0PSKSHRDvKAlXsL39/77g5KEkF5Q?=
 =?us-ascii?Q?h2q1c1OHpQo+INkesJta4CxBn3Tnp5/ImOUxrtRreWcXr12aIGRIvK4KjIPe?=
 =?us-ascii?Q?fpNMcTxt2fZ1Qi+xhG9dP32Zm1ka+H5VMWC2FrIH8M7AMI27zeaV96JTNhuj?=
 =?us-ascii?Q?aPiLkFPKTEq+jl2L1d1k/GMwV1ZsGyc1NZqGzyNevhAZtrK7NBJwOdnDPkPc?=
 =?us-ascii?Q?z/Mrs8Oa5dI8ZCnMt6/XZV0kpyu4h46/Zzr4pnphzelSNq64zTbtz1L3CCfL?=
 =?us-ascii?Q?460G//7ANozfENbxlJvbsxP04o0inRdrEkiUwiYatBIBG7WboxjNNNpmjEau?=
 =?us-ascii?Q?QK4lVzX91zGqoYNvYfO2M1FWfRm+c5lIaHh2FkAPSBhQ0SOWBWRvExZk0e9a?=
 =?us-ascii?Q?Rvk1XIZ50tiDGEBbY5a2IGJqnM7Ce9iJrjht4ip5U7foeX7o6cB+4Xbsiwea?=
 =?us-ascii?Q?xg+TZz+iodmDd0Ihuri/5/5AyhLcNasVS0GMoGORBs7nCyAd8okjq2iInG50?=
 =?us-ascii?Q?hL7Di7eeZIHZeV4cFp3UhESPpITwFdwOsfnZ4v10SoPR2Vs294vLfNZofrTk?=
 =?us-ascii?Q?ZVCbbOneqC3lVuFCYtMp7IgBO4xzMW6Ha2+Fr0fwdC5tCRrARHUC6M6oppqt?=
 =?us-ascii?Q?acajv0jZFCMBBAN+A8KV4AULbVvbfkIedP/Kl3tT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b42e3b-38bf-46c9-0fea-08dc1e9ac9f1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.2320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BJU59pZ9rL9uaw8GcC4DMpPpUK5VTo9w7n+dqLPQR4CmGv3FAVwZks7j8qHzFsd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 371d7930c36390..97a1b010b10221 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1274,8 +1274,6 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
-	lockdep_assert_held(&master->smmu->asid_lock);
-
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2773,6 +2771,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
+				      struct device *dev, ioasid_t id)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_cd target_cd;
+	int ret = 0;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (!smmu_domain->smmu)
+		ret = arm_smmu_domain_finalise(smmu_domain, smmu);
+	else if (smmu_domain->smmu != smmu)
+		ret = -EINVAL;
+	mutex_unlock(&smmu_domain->init_mutex);
+	if (ret)
+		return ret;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -EINVAL;
+
+	/*
+	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
+	 * will fix it
+	 */
+	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
+				  &target_cd);
+}
+
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
 				struct iommu_domain *sid_domain,
 				bool want_ats)
@@ -2801,7 +2829,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {.ssid = pasid};
@@ -2825,6 +2853,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * We don't want to obtain to the asid_lock too early, so fix up the
+	 * caller set ASID under the lock in case it changed.
+	 */
+	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
+	cd->data[0] |= cpu_to_le64(
+		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
@@ -2842,7 +2878,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct iommu_domain *domain;
 	bool last_ssid = master->cd_table.used_ssids == 1;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
 		return;
 
@@ -3349,6 +3385,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b842414b143c10..cea1a0f8e25475 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -771,7 +771,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
-- 
2.43.0

