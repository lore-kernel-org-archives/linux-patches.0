Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51969697A1;
	Wed,  6 Dec 2023 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mXa9pKnd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwqRD0sL8BTSLzlwCQmxMchOnp7D7/atN5PJxF+2QZojOuY0w5phdzvfypCpUeI2Ml3TrDsm91eebEDcvytXjL9WAk3nyHe6LhxTIFXM/RlhKRHaPHgFv0zfxeMlyY1UyQ8VP0g6qlBq2e12Th9pJV2wwmTlMMTwSYg3KmPVq5Rrp1KOYjd5Rpgs9MOnFKs4wtHrz/l+4ab0OVNUOVWNbJMIL5lF01h5va6vPoiMx1fIRP/xZgg03EfQxiRLwYf7syKMFYZUpSuOdG674vG7PjwDaDG9DuRRXxkNQeHnm5arqwov86y1xGTzGqjvT705CIUHDau6IcXTkve9Ige3Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deJ8narlj3Slb7yQBSdPfAhHExA6UttlyYQOvNEG6Ec=;
 b=NoSoPCePKPn93MFc36sTnUpsRgiVmBZSrCg6DwZJiCnIIvoO2mFMhfqp5lo5LHDD4ADiBE4qMQ03SU1uJib85QhkHXcWrepQm/ZZu6lF3SznuV9LqZBfcHxeuftuQjJB/86Fclt0VllRvbVVGSuhLAT2YnCxcnO6F4slHroN2tph4D6rs4caOA6WhHVv8XkLBtQ446+k4SLIf0GAinnzAq++g5WI0FKy24NkVWBD3eDHMLL5NV4Zxxz/CFh4eImAAQOhbg3d17HWZA25YCo+rjnVqyTTfHcvBOz6zObCsOWC0WwQUsQ4P7NmlJ5Qiy5OXuWLTTZBqTBuYg9xqa8rRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deJ8narlj3Slb7yQBSdPfAhHExA6UttlyYQOvNEG6Ec=;
 b=mXa9pKndArj0AGDSrbN2vpSpLwXFgNkcxHxiJKvjLMtBR5zMquc1EOVuQzazZ6Xd01m0AAFpJPmhH1LKRch+o0M7ygcdu/WCsHwHBXYM0wL67AGtA+xZlZrAD+nuiXKIBPmrPpfrDiBhiqHgsfh943DFst03SEGWrbbTnMXhV5tuP4g746dAjJJHJYlt9g5KcUj2RJNTJEUwROE5GtmqOksxKuLwQuXdFaOcliv4Qs2kiWTGkQ3XWebUD8oExM7TjF+kkepHqEd8g82wMw2QOmTW370eGGJByFeukg2iMR+L/7HwgJCVPTgN/IxpOwQYV8GJQL4OAStEHq713b7MVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:43 +0000
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
Subject: [PATCH v3 23/27] iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
Date: Wed,  6 Dec 2023 13:28:29 -0400
Message-ID: <23-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0057.prod.exchangelabs.com
 (2603:10b6:208:25::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 112b197b-e773-47e9-6801-08dbf680c6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1gOeiETMfDg3YCgkTy2dddeSboN1ymOGJ2xOLwcgsyCzWYYfAPRY7C49suvXVbo14Q4a6fLb6UpwaYO+OBW2UkIJjLWSGrJxoNF2jS9ajetVr4xu5weH9w+93SCcisUT8VFilCmbNRvlRYVTQVlH8LFKIjD+i7vYuc8SRg6fYnWYSKCQ8flH8fpxNhyO9XMEzDRD2kDZTu1wqXPyUrAAkEmud6M8MkmMDniieSC+zvlPqOiiAfNGrg4xmplwPOm+2Fg4hBWccrWTPiY7TNEtsX14bm+9IrURa7NloCTXlOQMqIWSlj6o5v2ny95hRMB9cFfgwksnmNDCSD5A4gr2Q1EDnXIKl4HxZ2h0H5I/j9K77pr01vUIvxuY/bdotJk3SPXQ+sg6JScgTgohwes5afx7R3CyRz33ck7x/1crbSDfwACPWihUm3tClnvrvyCLZHZBClvTNO2E1jVSq68amT9opPeoZR6JKkgBZdyf/VldatLhgCFL2F4U1GtafUe8Zk/hZgdk6yEo/eKmJBfL8meeAA3iAH1xN1K5hpC66cx15gGavMe7uwC5k6AgKWUa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hVK69gVt60dPH0h8tHEJNPwyHPmCJQIN7jeYcC9KphBB0RQC86rrkX7N3E8T?=
 =?us-ascii?Q?Wu4Bq/Vh0VMjKYycKuT7z3S6XNlasJnqf+RKw1ieodB4Lq5AmrKPRVs1rxmU?=
 =?us-ascii?Q?Q6I4UtRoKtrBlsRx4udz2przn4RuzbCl9tzEfJW+nLvgxfsak0z8Loqz5HHH?=
 =?us-ascii?Q?pnXmsm8QqRX7fw31cCQDFooIPAFsACwSonkcFa47gQ42Co9Wf70G4P2uaBbC?=
 =?us-ascii?Q?qzR4BjiVRDxWJFcqOIkh+EEtyZfCoNB3KC0PfgrIUM8cmT3ebjx8avopQng1?=
 =?us-ascii?Q?0aNjE+pRJpbwgpDBsokbcov+vb5ogZNYOaKHONL8peKP43NxEjijRwY+k9+Y?=
 =?us-ascii?Q?GNpbu3IInS5SYpOaahlOk/oDF3JKRH4TuSUMjRMu9XRGkkPTXGvtJTE1ZszI?=
 =?us-ascii?Q?d2tBrie5kvQBpNyTM4mA1gZDfu8qgB2MaOThu89JDpiiQFW2HX2fiuicFqcm?=
 =?us-ascii?Q?O88gX96LMG/2cpCv6gatJuTgBXHWlbkX6s+x5XH4mNk5GFK8eFm7Z79/+8eN?=
 =?us-ascii?Q?1gtuR5Z9l3ENqz2drLm1hxiYllyC9MsMRCSQDtmVOcsXfVe1IQhBJPrcUquz?=
 =?us-ascii?Q?qwA0OHJ10eHo75we5qiG6c7YfXJoDpkI3vJYYk0N0RApyX/j1u+PlMVGUqtK?=
 =?us-ascii?Q?I+zqfyLobKeEHU9/FBnAOeVFIC9vFTGwBOuS72qsE04/JIiEO+PxOX/j1ZcH?=
 =?us-ascii?Q?+cDPwSWYGJl2V8x2jXQ/pxvVB5/aNpmSpnZyy7P/wp/jqJ8+sWYgZtio52pm?=
 =?us-ascii?Q?7cc5mRZNpKLy1p+NWsxtAmydIcSraJD8TYVgXihZlZz0hZECd/yGSNi3qrqm?=
 =?us-ascii?Q?a/zeFyYXt9DTD7PqauvE706sljq6JQ3kKWEx3hGOg660wCpmOv9d3tND2PQ2?=
 =?us-ascii?Q?dkfmusT9tAo9ZPdfz+tn1RAz4cxJILIUMtrYlXUU3UGwbYA0O1C3+XIzuDNd?=
 =?us-ascii?Q?rpqeoRFjKzJd03t4SMvXT1ZNVxrWq82sqQacGbDwrn0EjrIjdAafebXjznuE?=
 =?us-ascii?Q?HcLsZO7MS3FPIAgjYeLw0pHQR+G3/SrMHZNB6TOyyjxXODxc/YFExbWOuEKO?=
 =?us-ascii?Q?4dUZoV6WeqsfFEryROxca62ymQhtuiyC1MpvbbtM2ggppvPPfiqpYL9sqty/?=
 =?us-ascii?Q?icJNqRTXJ5EanXhwJAzF5rGUgcYgtL6mLCzOuSXwHm+r6AetrRx3mxf/L7ZQ?=
 =?us-ascii?Q?5w7ZRF5oYG/TR+FYAeXWevasxIfonth9ajJkKuPkCjOaicIKEsXSG0wjd8KZ?=
 =?us-ascii?Q?TPRRPU3tFotNTKNfbKQWMsQU4B5JDNjeuSZYa/IG7pLjmtMObfcWxaVBB4Nb?=
 =?us-ascii?Q?7J3Souen01SEcSBQZvthDGHeRYJGGxYvNT/AijuS6l1Qb15IZnTOocIxWZou?=
 =?us-ascii?Q?xmtTQPFpU98nYJsFNt1cMcVx9sZ4u/wMuhH2G5Hu4TB4aQ+8yBrH2K10hBhf?=
 =?us-ascii?Q?vCYeKxDNxjDFXYpG8u7JKqqrS6T9W3jR1SeWUhFiY/av0rxiRgcWz++INdIM?=
 =?us-ascii?Q?PkwHvfj7WgahMiYkwKarQ+Tyys/5hZ6rxt6Re7TeSgqHLaWHbdZknTFVDxMo?=
 =?us-ascii?Q?/2wN6kEKV1+N1lKUFLXHfjwi+zkizbay8rAxwf+m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112b197b-e773-47e9-6801-08dbf680c6ce
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3JDOiP2wTtAy35xYvVEFRSuqoTH8QPJsVOuOP5mgRVsRDUxJ4nuXnYdzIvBL/Vp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The SVA BTM and shared cd code was the only thing keeping this as a global
array. Now that is out of the way we can move it to per-smmu.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 19b4d52be7ab66..d5772ce27d48b2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -408,7 +408,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	if (ret)
 		goto err_free;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 83e31177215533..e30de36044cac5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -71,9 +71,6 @@ struct arm_smmu_option_prop {
 	const char *prop;
 };
 
-DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
-DEFINE_MUTEX(arm_smmu_asid_lock);
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -2245,9 +2242,9 @@ void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
 
 		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_lock(&smmu->asid_lock);
+		xa_erase(&smmu->asid_map, smmu_domain->cd.asid);
+		mutex_unlock(&smmu->asid_lock);
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
 		   smmu_domain->s2_cfg.vmid) {
 		struct arm_smmu_cmdq_ent cmd = {
@@ -2277,11 +2274,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
 	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	mutex_lock(&smmu->asid_lock);
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	cd->asid	= (u16)asid;
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return ret;
 }
 
@@ -2545,7 +2542,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 	 * arm_smmu_master_domain contents otherwise it could randomly write one
 	 * or the other to the CD.
 	 */
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
 	if (!master_domain)
@@ -2584,7 +2581,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 				   ioasid_t ssid, struct attach_state *state)
 {
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	if (!state->want_ats) {
 		WARN_ON(master->ats_enabled);
@@ -2647,12 +2644,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * This allows the STE and the smmu_domain->devices list to
 	 * be inconsistent during this routine.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&smmu->asid_lock);
 
 	ret = arm_smmu_attach_prepare(master, smmu_domain, IOMMU_NO_PASID,
 				      &state);
 	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_unlock(&smmu->asid_lock);
 		return ret;
 	}
 
@@ -2677,7 +2674,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_attach_commit(master, IOMMU_NO_PASID, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return 0;
 }
 
@@ -2701,7 +2698,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (!cdptr)
 		return -ENOMEM;
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	ret = arm_smmu_attach_prepare(master, smmu_domain, pasid, &state);
 	if (ret)
 		goto out_unlock;
@@ -2711,7 +2708,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	arm_smmu_attach_commit(master, pasid, &state);
 
 out_unlock:
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 	return ret;
 }
 
@@ -2727,12 +2724,12 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 	smmu_domain = to_smmu_domain(domain);
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, smmu_domain, pasid);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct device *dev,
@@ -2749,7 +2746,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 
 	/*
 	 * The SMMU does not support enabling ATS with bypass/abort. When the
@@ -2778,7 +2775,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 
 	master->ats_enabled = false;
 
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 
 	/*
 	 * This has to be done after removing the master from the
@@ -3436,6 +3433,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	smmu->strtab_cfg.strtab_base = reg;
 
 	ida_init(&smmu->vmid_map);
+	xa_init_flags(&smmu->asid_map, XA_FLAGS_ALLOC1);
+	mutex_init(&smmu->asid_lock);
 
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c7c4f4fda31297..efc6bc11bbb838 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -675,6 +675,8 @@ struct arm_smmu_device {
 
 #define ARM_SMMU_MAX_ASIDS		(1 << 16)
 	unsigned int			asid_bits;
+	struct xarray			asid_map;
+	struct mutex			asid_lock;
 
 #define ARM_SMMU_MAX_VMIDS		(1 << 16)
 	unsigned int			vmid_bits;
@@ -768,9 +770,6 @@ to_smmu_domain_safe(struct iommu_domain *domain)
 	return NULL;
 }
 
-extern struct xarray arm_smmu_asid_xa;
-extern struct mutex arm_smmu_asid_lock;
-
 struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
-- 
2.43.0

