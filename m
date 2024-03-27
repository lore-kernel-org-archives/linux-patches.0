Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1909B14D712;
	Wed, 27 Mar 2024 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562918; cv=fail; b=f07jHYyUv+DVm3KIdlm5w2hbPHnYBLt53+B+y/fTDB5Z94FcLqhryAtnKPFpIcJGQs222ruWr7CUDTWwW7wn2Sbsv0WFbBsL8kLlrcyA1JhFcEeyVGEcnZsAapiXr5WRxzpaS82y6BkT60ObcVGID2svaod4F/tPC4xws5mlG6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562918; c=relaxed/simple;
	bh=EwuO3Ac46WJtMRDtzLwi0LbMepG4lZGC8T5FetkjwDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SJom6H99aFuK51zNTZoyWs6AOn/E3a2uF11CgYOu3twW1K7kERF883XiW//pdfOcemC6SsyeN+z9DyNsiW1bF7ggm5JxsEujPJ+DjFaBV/SqIBk3Rpx4BDj4Rr1Ro9aLIPLzTvs69Ybi0Ir1PnJJm+k/xaQ8T+ID9ZBHTLsP5MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ipsuih0S; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ipsuih0S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msjkGhaoPUe4vqHCaRAdkpFe/0p0lKYdrSRil/poIMgdCkj0YAb6ZVSkeuI7+LmBvO7Aetb28MOjktWIcEcRrjrO3rqVFrYY1JHNrw2+fZte3Mgr/iaiiN6h786TDydi7U5ZzuxfykFl0nxlT9p4vv/+BdESOghm3fTBjgx0XGIAvUmGMgrUCEPjCRd0WCSqvBXjoG/SaaDoMm2HMZVWf6i1RaqMveT5C5oKMVjhD8IufhRq+rnKxBTy14569ZHG6EXLMLs2rUX+LUSCu4RNoOvMlxeoDv4r9j1WH1an1llhLNpQ4TFybeNwimjDFTBSO2rTb7e8sjUVIbURsdciIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOVipcU6YZzA7Y/k2PkAaFfvnxP5+bMlrG/Vhhx9CAQ=;
 b=XR0SmwzCFBrY64XBD8DhavKoL6+8aR0mGHSOaSX+oQ2bFH6EsVula4bG5IabblkND5uGOA52zMpwH/tCK1acfhOzYYL6b2CD6oPYWBPD1DrB1PW450ZQIuXt8R4aISLCLCeNRBeRM3WIJvqmc66JJfHQ8L4ggfAvvT4xRDooYzdmzfjWYys9WiH8P+S3TnN81j+JcAjklYcY29a2Njg4e/kOhwAEkpGTEzxnh0lQLlpNk4b2LI6wyrw3KFASt32c+X9Q5ZaaK7arC8RKYuLWevgSxXUFy68gxZliqW27lk+nU6xf4fOipw40i+gFYM6mkyFfBHZ1a7rt/HBbhvn0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOVipcU6YZzA7Y/k2PkAaFfvnxP5+bMlrG/Vhhx9CAQ=;
 b=Ipsuih0SLDkhDuNDvOSdXpr9au7HRRYpV4AxGIcGNFy/kcWepNRyv/VtrIollln7OYO61yC2sWAGdj8KSbPtA+nJ8yYUEgMnrMZHsDb/oSkovHO1gNiDu+qwv+qRbbMLJuEcy6/ahEqYlO/QaCxP9Fz8EwVzhAIUzelne2qYStEMuJzw2RozFS4JgId13rNAuiZmn+Pn+PmbaSQgz/1RSjqKzDaYowA/qzgDQIMNABTumB3yNrSBvn0LTrSQC9B+TVMofZkLfFJgocfdVbc9V6UCfD/MD9+9NUprwm8dMtgVcn3XK42uP91dLAzc64PmfFNI7Zp+pdqA1oBQ80/QJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:28 +0000
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
Subject: [PATCH v6 20/29] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Wed, 27 Mar 2024 15:08:06 -0300
Message-ID: <20-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:208:236::9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: b7281c64-d9df-41d2-dc65-08dc4e88e17e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y+LaKuC5wTb2mfvwTdDjPcnYjZP+F4YDWvBxC66GYC4n0UnCYUFLz0dOZhiKi0ISGd6+z+1KgOPCUyIJ5lP2SAjyM3FvGQ8m2ALHv0WQzLTwUKfXfNW69hgxJIqCpRDVm0xvrEii1d6/R5j3vVwOyx4fbNMR5/KtYwN5ctNn0fgxo8POialCcqI9JEoRSK5iTMKQf8utC4WzFrvXqWwaYrVk2eZUAb3Cre9DdcgLpXUXOl19lcJHw6Bm1lf8GgScDtpTHBhC00SsD9L3aJ0+2Vd46oc0DdtUFeX0JiYZejDvb54XFsB6BEh+LjK+u5QupoB8au/Ue0v5j2ycFrQJH/ihnqlVvhRmFO4EM/BUKQA4EGILmjoi3f7SAOxvOafCBKgfL0C+ETMMobruGrQXd690tMbBCa0mdfSI54I0JfsOw3ugOyxoeSe0MtW3gj/YCutuX5RwOQrKvUd3HpPBgjSwYv2ISXyFf4kWt0mDgsNa1QPg5w2TInqhh0FZYmPekcVJOm97UdFgbJmdO9GiCkyqAMcdTgLqFtxkkVvumPlxE8KmIe8g2sy/00tCuCaL+CXhwlxjGoGlVpJqIM1rlFZC5o/J7tkLFRFTnvdHB2XyyV+ETwbvaOFiJkRBLLrWSKND4+bGpa7A4XF90qIozXX2Nn41f3f9FeGZoQU0Ha8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UpTJ5aeCi8X2ZN9/A+OsDICYDEtbwwT4HnLjP6jwm5BQ+vgDCobFOMmGvuFR?=
 =?us-ascii?Q?cWJgGAExCanGyDpj3V6ksrIly47pIeZzjv7PQUN8Z0cDeIV0QRP4VH2Gt/w2?=
 =?us-ascii?Q?glo+BOV9pTJtZqxXehrJQMve60Dr7VZXLavRhgfzQKXtSSSIelkOspQpy8oe?=
 =?us-ascii?Q?nHvr2KiaWtX29drO5PtTzqoSAwn1PcnQGWbyKtWc/CEgjsNqW75hq5UVz6tZ?=
 =?us-ascii?Q?yKC7M9ds/7MoKKzu8SBLqJUHUbvNeU5GlCanY9ZKcQC4PUWy/g/DacW+F7Ds?=
 =?us-ascii?Q?QLWTJqenNKkbJzR5CMIyhQHMWG73wqOKQ2CwBlUCpiZD68TW69i/R1BMaPft?=
 =?us-ascii?Q?DawVCIp3mWwfecN+apSebZVX/dibkTrvSdVXOO3FBGFjmFAxxc8H0CdGYD7V?=
 =?us-ascii?Q?kfMF3DCKQjOSn0pHxXZXhZz5WJEFICBpCtQjwABwBYl3cP3Vq065tJnK+WMb?=
 =?us-ascii?Q?aOYVejiBU+uzgcZ9guWrAOh9cEy5pyT6otE8dooqOQtO5EabyxriwN8GV4pf?=
 =?us-ascii?Q?4Nx/hC40nVbU50Mvac/PExdE4tfZxO229UV/zNWiSepiQ0Hc0fwiNDYUqC7F?=
 =?us-ascii?Q?OwSibV7V3rXT5E9MWlBl6c6upLZkTYOWJZx9JeI7KC90/IG3lnSjm9lPbVv7?=
 =?us-ascii?Q?d6fmaFH+dl+MLXWUnFR1/XiH36UDIFgNltWWjfdUmIqmo1DtfntWsXOCvXs6?=
 =?us-ascii?Q?BjjSOrRUrNj0u7HA7jKiB+Iyq3TOI6WZvAP3gkMxDiKESVGefaZs7k07c2v/?=
 =?us-ascii?Q?1OjgcFUckrEzu/pk3YadWTW3sZdD979KRNbeFiWUUyzeGUL16ajAhvzAfZR6?=
 =?us-ascii?Q?BpuYmcMuYd4xUjXsD/XJKmY20JeCX5XgLNHtz3RUlrnRvuIkrF+KF4erGvGy?=
 =?us-ascii?Q?TguDE5v0+jeKqcv4ZzNfjXtVlc4nGogTeZTC01eraAKLJ778H7OnHteT3olO?=
 =?us-ascii?Q?vQrXXLV00zx6pPXDzc4+p/YWuAwktEMqBDpLO4vzouNMX+YkIU8lYUkxFI5M?=
 =?us-ascii?Q?2vqPWlZlhQY8cuBKT3riaJdEAfUeO1eQeCi5i/maXaLKPBvQutdovuwHRFYM?=
 =?us-ascii?Q?PPf3xipV03DaaS5zKP8U5N6OKa1j6aT6qi4R0mMGsATp1Ta6AL4PV8lmqEjZ?=
 =?us-ascii?Q?Ub4J4fKOZLPoWqpgNJAFoeeR9RNnAOHrhqMIYyiWM68ZfJDaCVxJd6aRT3sa?=
 =?us-ascii?Q?nZ94Xk++VwKMtnr34J+KrLZcbrk4eaVoB3jdQi99mn96G/h9sWmZjNgjrr+o?=
 =?us-ascii?Q?FVwnzZdEJzYjbm93tPzGT/r4//zUXYOoOw/eft7nCR33KcSq/7y+iBO/7R6W?=
 =?us-ascii?Q?1Uyn7T8jVaKtXqW3pPqkCVAIgBSJIBIQfl73mTEXzQbes27fkPMCNLGY9NCh?=
 =?us-ascii?Q?YRUvA410TNhHUTUb5YAnOzofMeUdckt0quqfDzcu6PMmK6yfjoxEuzxnDDHu?=
 =?us-ascii?Q?uV8v5aQb4DzhJbR2Epyxq5AGc3ak6dowtDDh3ZRLVuOSdl8JV7NHryZn0LnX?=
 =?us-ascii?Q?BvKe92lDMt3N3h8fZZI+RWpExTVLwYv0nCBScvi1G5No5YO6hhZ3pkylgKzX?=
 =?us-ascii?Q?F7hxPj+/nnJEGuVeR3g0vQAbCGPj0NBJ8MquDKXQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7281c64-d9df-41d2-dc65-08dc4e88e17e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mB+YA7XRLnOLzLK68fU/+4Xh2eZCu4U4p5mxVQNut4+TVrjOZ7OjYJRdk5OFOw6l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 +++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 38 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +-
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 24e7cf759bbc35..3e7aad0960bfd2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -637,7 +637,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
 	if (ret) {
 		list_del(&bond->list);
 		arm_smmu_mmu_notifier_put(bond->smmu_mn);
@@ -651,7 +651,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -659,14 +659,17 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return NULL;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	if (type != IOMMU_DOMAIN_SVA)
+		return ERR_PTR(-EOPNOTSUPP);
 
-	return domain;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0376c1bda8d8fa..9611ac239fea8c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2270,23 +2270,10 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
 
-	/*
-	 * Allocate the domain and initialise some of its data structures.
-	 * We can't really do anything meaningful until we've added a
-	 * master.
-	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
 		return ERR_PTR(-ENOMEM);
@@ -2296,6 +2283,23 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	return smmu_domain;
+}
+
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+
+	/*
+	 * Allocate the domain and initialise some of its data structures.
+	 * We can't really do anything meaningful until we've added a
+	 * master.
+	 */
+
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 		int ret;
@@ -2309,7 +2313,7 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
@@ -3273,7 +3277,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
@@ -3295,7 +3299,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.enable_nesting		= arm_smmu_enable_nesting,
-		.free			= arm_smmu_domain_free,
+		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3da131e0173e1f..9db84d5940466a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -757,6 +757,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
@@ -789,7 +791,7 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
-- 
2.43.2

