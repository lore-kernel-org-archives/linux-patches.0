Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6199914EC5E;
	Wed, 27 Mar 2024 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562929; cv=fail; b=Cq3UmLDccgPvU04hImSPWvqSSRPuxmWwtbyz23QkI5Ke/qKx2Q/v7DlF/NLsscdiEAg2DSrWE6GuFPKt9+wuGyZQPmox85JFcz1C2cqiJATTAp2LEr2B1nL0T2YCobpaDMXLErMrxYKVu8zLiostJ4X44M80zr1t+ri6TZ2ZFRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562929; c=relaxed/simple;
	bh=JM17aUmGC0+OcgbG87p/hoH5J74XDgzKWCY0CEtmjzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ACv6hNeC3LdKC9ztK+r5q3sbc9tI3HaMui+Mcuf8hkSOeZNd3HoVizpkYKQa0F0oHYfY+2Vv7MavnE8f+QIrfaihhHk31RfnCwOxPOC6+w52aaHQY01+Hv02Zxoed55teUjHGb11JVLjwOwxB+j6YDfe5E8M23FfWXvqDsLSbuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=liC1Ks6S; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="liC1Ks6S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfHv6f1x8HHecrlbj1aFRuDxMTzgAdshYA7I6eD3bAJDgtbbtPWhq1UVdoc4xfnSoGPFs8CV4nSKcqBhZonjxJp5NHtf0qvcTkvJcjOeR5svL96jmuo1P5o4hZ2iUxQKk5f0OLCx5oEtq2jWp3iDFlkqnPbZOVv2MuNWO86Y/CDkKW/fIQFzLaRCEW0sJZy/qgngdi4mS9rFkhukhvzW4JcTIMobMpxMognzfmNuGHtv6+GX5LiexVrRYZO/GPRYTf/ql0uSWj6d95EDp9QfUOQBhhGA1UsIoxKydp4w5RLWbvY8HSvFB0hs25q19Pql/mQ35yHgi78EV9JkMao4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YifcmNgQewXB0Krv0y3NQTC6WlItmItJ660UGTNJ4F0=;
 b=n6jQD9F4zQ/1H4dvRsiE5BPz3/ABwy8IxPuikflq+SAvCoI7ACH3+Yb0KaC+ogV8tTe6lfOjccW/QgkJBByZ2OR42vZ7rVpuTatquG5pJfkkK16079i6mor2NiGkNXgyzegw5uyzZpWM5EJNH+itoHt80lRRTPh/oJDyEgLCidzEeS6rt5M8XERdEqSVgOL38McmPQJGNiQZSuO3Rl0kGwFP9h88yKRNX+1i9zx+yjy9sTO4p6/6ob5Rth4v/Ogdw4pwjLZ1hzAnvkPCZsaSCI/SwmguCwCwmck+u5PF9F1e4LvHJLCYD2sMdJJ+qyLhJ185rS0TJ1KvGdkUsojbtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YifcmNgQewXB0Krv0y3NQTC6WlItmItJ660UGTNJ4F0=;
 b=liC1Ks6SOTiyDYfjB2VT0yl7KNkwSizwgTfcb70rkXcLEReqsjpygCbJKnL/sMJ592nyekaZdQ3NI/H4KuYsG2hyY2tIdvIXas/7OQFNEUCFTFm+yT5OHzenFuvnMyS2BfGB8PkicLl4XrHwNJUotmgmtWU856857ieEqS5Qx4LGPHM2Nq4Z7Z6YHRXvIZEtgO9cqgYLAEHWh6SCnMw29+u1QC9dRQPoKKdrQV/arJZo5NHBYAFbcJGMwwFzdgy1Xx+zoaGbYZEH/Kbl4nI1RilWgcwcQi1vHCrp/ZQn8G2T8/RtaMYYvw+O6J7fdcngw3lFIT+mimlvF8iSbWgZwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 25/29] iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
Date: Wed, 27 Mar 2024 15:08:11 -0300
Message-ID: <25-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:208:236::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f7a7b22-cb5a-48cb-39d1-08dc4e88e1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KLFl0sK23SoCx+qyba2vegeQpOXw/+gNa108xCot5Us2P7wST1P36itg8nYQj2wDD0vy8rLZmgdfDIh/pQlXxZma/g0p7xF2fdJ72iv1ZI4I4NakmVCkn2j7IksA3LkCYLgJhOQgiIYSDw235QDsPT8uV07MKvqxhHr7ffmLmS64W0TElTUxw2hifts03VAZlZaEmXqPNDhaltQYi8TtZAf2LgrTP1pfM7lGkw2Q7f7RSnO2blayx5Klci5KJJQok8IZHlue1Z+ZEZCZV6xJatJvnr4lJXj4n1mu3+1X5VLEtnN6qcBNy20idRaqpUjlpqI05l7y7bWgJoUFv/BaFnlmh7KvkpuA+PnxFFkNgVGhPWpRq1pBw4olXL0C8LUU8BBEMNA/JYVeusgm6px7CWe347m9yPnGVpvADpyE0ce+xvJh6QjKo7wwZfxYIWyS971FaHB6j9asmXNHX4nwGfSyFcQYXpgSR+wBDFlPZLKTeDpb58lMllbI8i31K3HGYpNv5BwN+MoNxO6O4L9B/8TtPtnDLTNiPOZWIFFYp+gReeoBn03etSFF3rZcy8c1tKaUCemAm4YZFMBCiJPz0SEQ5K82WHN3YlVeA0CKNk2EwAw3DPjqsremQUF19jZMmn+T+23ESsVGsMgvwHZTnkqSPUVhR1JIunNi2l47LQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jOOTn5ruM1mXkvBJ55Dec9Z3APVC6mQ5d24JrTXjd64oIIQhdFCFV10B+vf1?=
 =?us-ascii?Q?jwgNTJ1g0PeaqCmbkoWVCT+6G6AiaVnknMN8idvYGwhh9NNJjONGvPy5xt5r?=
 =?us-ascii?Q?e1TwK30E4shDH8uUX5Ots6bb+Fh/3xVe4QDp/FtiieD/Fbkbh/ZD1ErFJrN0?=
 =?us-ascii?Q?CNBSr07aeKiIRBSnM+HCe19U5J1WjspmoGmYwl3ykC9ApBysK8T5FjSOvWtV?=
 =?us-ascii?Q?+ZU0T4lxmN34qvvCwGG6/LHPyPQXMkCml14dmRxit2nVvtp0XRiOc3mlGtOO?=
 =?us-ascii?Q?gQ3dBF6DMTgSvQgW2zg/56zPyM6KmGdg5WitE+/nwF/OwQhpVRKh9UYDzvl/?=
 =?us-ascii?Q?yeFWSdX/AiyVgZcPX+mkjBQl9uSShQIOGcedPLizXT1H5i8sGgFzKsNsqu2r?=
 =?us-ascii?Q?KiuyaAZmuf4sK8alTco5t77TRNw1Ca119Xb1oo86jHyG5zpvW8b90rHNYteb?=
 =?us-ascii?Q?kizAc+8Aag8DuGYZhdGz55/8YmwP2TXALd7il23SSKw0JjEtacGRGRH2/o0E?=
 =?us-ascii?Q?Dz3hkUWIi6u0BxTQT78IBRvGiFPOy5OJ9O8dtvVNCSxu5EI+/XxeazYPmTIo?=
 =?us-ascii?Q?bq1tErEZxw6mUVyTzbFFrEn9ycqSOUvSt4qkXxTEdRzTgpU2AL0czSagAlKO?=
 =?us-ascii?Q?87ULeNSXCJ3+lfbZX4+msq9FBjpHpI76LHvGuILZMlJJhDc4F/IbCTnlpAFc?=
 =?us-ascii?Q?CV5fvHnr1xCOqDsGLqFWvF+3iFv8iIsLkNmc0C9p2RuI9l0AVs5c+bd/sKx4?=
 =?us-ascii?Q?LozavTsy4kz/rPsex/E6jsc+IxtFDTM7SOhyXRyxBpuzXGUr9mOQ7xjuu4m0?=
 =?us-ascii?Q?DZR4S7TYF5MDK5uWE5bFsJA7T4pmxvqMS3ATDth5CQzJebz9etm4eJcHu8hY?=
 =?us-ascii?Q?r34KG/CrupWTEUDiiDK8HX5Hu1Yh/GHKVGcZy7qjzDJB8gFqkRL3ys5gnLvh?=
 =?us-ascii?Q?ZAujeO9BYJGtKYU7Ubd8WugxNVDYkQwSQFLK4aX7ZMtM/98VxoWnP9kxuojk?=
 =?us-ascii?Q?iDefGZZW7OFDOCWfH3hmxUYP39JZopSxesSmR5PDVQxMp/JgBUrzmmilXiV7?=
 =?us-ascii?Q?DSJIebbXFCRDcHPsENw1FlFXl/BvYz4MqFf6TQo6MWTTwyBwyRYUsO+nlfP4?=
 =?us-ascii?Q?uIS5qn049olgkad/jDS15djlY2fkwi4lQ9bp1nBRMccyKLw0vhq7P6/pUuEv?=
 =?us-ascii?Q?Lqva+xr4ofau91RIpfERK7HZvl3MG0s66JrepjdL0nTkqWZEJ/i99g+hYAg+?=
 =?us-ascii?Q?Pj73j5IEdklD2gI4PIlTkicn0jPMuKe8tLb2jSuohUDck/goeWKf6/rgPnnE?=
 =?us-ascii?Q?PYHxs2MqLBir9ecHwk+rhzyVNayyI6PhspL1fma/4UtpoSCqhh7c+KaBidup?=
 =?us-ascii?Q?pxLAyOcGiAtGO7zG+QyCfSJjFqTL4VDEVSVMcJzy2b1nTfo1Ghy6hLYNcZts?=
 =?us-ascii?Q?NiG4g6yR6yVEj8XgE3tR6xDGtX7Q2R4mxk/b7cQQv2pgnadWZQXNOh5sZU4k?=
 =?us-ascii?Q?poN321ak994/Ty1j3WlBBdZPnuv990vkUNQ2ivielwiSsCt+IE1WoRG9pWt8?=
 =?us-ascii?Q?nK2C7FO9DhhGZpNQeS3138lLJS1tgDNRgfRAoRq1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7a7b22-cb5a-48cb-39d1-08dc4e88e1be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.1280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 399CA5WnwMm8oThpgF/VE9GEo/zxBgglKgh8HhSQkI/EUCzVBhFTWHNi6a6OFYTf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The SVA BTM and shared cd code was the only thing keeping this as a global
array. Now that is out of the way we can move it to per-smmu.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 9ec1a5869ac3b2..95d8d2d283c916 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -404,7 +404,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	if (ret)
 		goto err_free;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 888972c97f56e1..bdcf9a7039f869 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -86,9 +86,6 @@ struct arm_smmu_option_prop {
 	const char *prop;
 };
 
-DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
-DEFINE_MUTEX(arm_smmu_asid_lock);
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -2280,9 +2277,9 @@ void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA) &&
 	    smmu_domain->cd.asid) {
 		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_lock(&smmu->asid_lock);
+		xa_erase(&smmu->asid_map, smmu_domain->cd.asid);
+		mutex_unlock(&smmu->asid_lock);
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
 		   smmu_domain->s2_cfg.vmid) {
 		ida_free(&smmu->vmid_map, smmu_domain->s2_cfg.vmid);
@@ -2313,11 +2310,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
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
 
@@ -2609,7 +2606,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 	 * arm_smmu_master_domain contents otherwise it could randomly write one
 	 * or the other to the CD.
 	 */
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
 
@@ -2661,7 +2658,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 				   struct attach_state *state)
 {
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	if (state->want_ats && !master->ats_enabled) {
 		arm_smmu_enable_ats(master);
@@ -2725,11 +2722,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * This allows the STE and the smmu_domain->devices list to
 	 * be inconsistent during this routine.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&smmu->asid_lock);
 
 	ret = arm_smmu_attach_prepare(master, domain, &state);
 	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_unlock(&smmu->asid_lock);
 		return ret;
 	}
 
@@ -2753,7 +2750,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return 0;
 }
 
@@ -2783,7 +2780,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (!cdptr)
 		return -ENOMEM;
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
 	if (ret)
 		goto out_unlock;
@@ -2793,7 +2790,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	arm_smmu_attach_commit(master, &state);
 
 out_unlock:
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 	return ret;
 }
 
@@ -2809,12 +2806,12 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 	smmu_domain = to_smmu_domain(domain);
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
@@ -2833,7 +2830,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 
 	/*
 	 * The SMMU does not support enabling ATS with bypass/abort. When the
@@ -2846,7 +2843,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 
 	/*
 	 * This has to be done after removing the master from the
@@ -3508,6 +3505,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	smmu->strtab_cfg.strtab_base = reg;
 
 	ida_init(&smmu->vmid_map);
+	xa_init_flags(&smmu->asid_map, XA_FLAGS_ALLOC1);
+	mutex_init(&smmu->asid_lock);
 
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a711a659576a95..97c13f9313dcfe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -673,6 +673,8 @@ struct arm_smmu_device {
 
 #define ARM_SMMU_MAX_ASIDS		(1 << 16)
 	unsigned int			asid_bits;
+	struct xarray			asid_map;
+	struct mutex			asid_lock;
 
 #define ARM_SMMU_MAX_VMIDS		(1 << 16)
 	unsigned int			vmid_bits;
@@ -751,9 +753,6 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
-extern struct xarray arm_smmu_asid_xa;
-extern struct mutex arm_smmu_asid_lock;
-
 struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
-- 
2.43.2

