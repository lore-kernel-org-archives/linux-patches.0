Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E53313BE8C;
	Thu, 25 Jan 2024 23:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227077; cv=fail; b=a1FET7sDnaqQJDWHOJ/RF7BSgyaNp/jVXHhLP9n+lZQpiTVUsxFgpWAKvv+OiaSa2k5k+d3OQkt6QiVacoW5wAexQlkAg1kGl1e+u6S4DMgt/9CekrEXxQYbImmOA38jbXGbJHiDhTVD++NOJtdA20JOCpu1/vtCmHkyE8af+Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227077; c=relaxed/simple;
	bh=QZu1TdgBkvCIN15vJVRKHsIm9EmjaKu4tMPgej4Rv0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DDm1VEhm8XT5BFI8nA8mN0FeQgA3bMpw6gqFGlOGOalVSI7cwMlSDT01kaeaG+l6khuxjD6tcATnUColXYToccpR8h9Pj7bQ1u/1TviipD10d+PnmVQJe/GA8mspNNTbQ2dZCgWuUPxxezyq2RFciQOCwcFFAd+MJq1i2UCypJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W2QJ1RDA; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W2QJ1RDA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6dBBg8wHsiYTGGOVMvvJwPK4bkz39FCLROEaykaQKFTEhXNDLtLjKOgLcXKx1dtHMKb5gf3GsBAXIy7PjfAFD+e7G39mH2RO/IPQ44bm/awfnvkMT3wG4+f7H6t9/gLVK/Q4hyhY9d9k+vPomAP8VzsIMKZ/51IoGl+6ryN9Gt0ka744q6ryZRyiksQBtRylgj7LOCluwHnuX8ySAj5A6vF6tG3TIh8E8SWN7M4Bwyvx5+NZg0mg8pA2mqtKVs24DSOM8+SHvb88YIszdcPElyBQJ1DKEFBGZXlcNdT72QCA7ghR/q1C8BbBRu7h+DnTsxx8IdBUlEaoS+ShM52xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRg1kVqXSznZdQhXxpifepmj1QxQckRVOnw0zHEnVFI=;
 b=JveWwVjd503chdcbYhDRtN701VlBs2jRmKWw7fmXaHCleAsrEQc7yvNkp2Ia7Bju0ugfXMzqlhQCVDzKQWtYHhpw7Jr5/PM5o2JkVwvv6ejDZtnrNIaYROtRYJpSWzSijb4fdO9T3hpsKg1/9slTSiyJ0rmaKjiCJt8dO4WgXgUsuFoYMhxayb1afQe8XdqM/a+5agJxqtQYf7vxbw0437dtaoHwU0HpnJcrjuMqAeKkjK/pvV8P2WjWHm8kXajHtQmoodoPmV7M92Vh2MsrFC3TNM1KTRI2yHdxt879PdDUuBUOk+ycvwf/xI1IzVOCGtIVCdYMsfqUHZ1dHbfUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRg1kVqXSznZdQhXxpifepmj1QxQckRVOnw0zHEnVFI=;
 b=W2QJ1RDAVBgY2L4Z8VsR1y0Qn6cU/OodYFejG1otpzx1AKOYmgynaXFKq0P7cmP9tTO3BNvAOPJ4PcPqyQv/FLFB/zD1nFO8Fa1SgmuaQH/ZzLEmYJtAl6GRqMY51kmpkLdRg82l3/yW1q4vW2e1Z91JviBbXk7cRsViv9rjcykGexrA9rlOE1n/u4IM87bGqfu61PwpGinQJKgZcSEOcqvS19DeAQ86wsvqj2dIWO7X0QTVyje7yJExol4NjWlo/trB+fXAcPcyXcberMcOGUrkHe0QYs6kwABAv1ASPcuDHJWX9J8fJSoarQrVHhg05qe462A7Dp6STxF5R52KrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 15/16] iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to finalize
Date: Thu, 25 Jan 2024 19:57:25 -0400
Message-ID: <15-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: c79019b0-4c2c-4e4d-7519-08dc1e016517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XlgOjvy50Jyzz4v/3lws+fdkG/+l7dCVf/cJaBdjh5M48c8geFYs2CHkzvcCizzoD1IbPPdTMxuEqQPT3bAM45nCfE208sV337ldCTGNCNJpUyYUiacpox9jqrvz6npyjrQgotQ2KP0QU5zjBnq23QOnAqEPMrYsE6kHSY40s1MVM3W5T7jKyUY1ACFaRMKMVODWmC9GvSXk9Cg7Ysa8GdNbfQToNLDVym/P1KHIqDTW+b8RrDEpLzh1qPVFfoY+e03omAJPTfmfWv0rsQjxUBBgoRsW26qxo5i7SPSIxokmmE6M7NR3jBuc5KWPdyGXZVgUTtxo6gHalN0V+VXSNo8Otu0WKrGlvj3tU9idNP11HClt9kP43lWWfR6HEEGM8LMqQZqULLOvTBZEyrYE9MGCPxoynfKCAL/COjTKc3Z+o0AeaKqxULgB/yNf4xyFnjxsGtwdqcAEr3wxXpgRm9uD3JglwezAOypjve1SSnetKumU4LG9lOOXcoyMBwKt3kL6UMkTFDjE51002RC/Cyp0LsMBEpSHwlDenQIXjBlORSL7uYcIYb4Zo5uFq14P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BNw9uydrMwOEAwGEQgyuTfk/O4g6t0OGoZjJKBRacy1i+MFtwT8+FOXbH8sJ?=
 =?us-ascii?Q?90vF8oEDYEyrd4vCWFy7w1GhgwyYVviVIKAc9gXFu93bmJ4HcFas9cEqqAMg?=
 =?us-ascii?Q?A4lrnDrx6V2IT3/hPtzkCUOTbY+ORM5B4hCSFUGw06l+DGDAKBKPtbDOXGLf?=
 =?us-ascii?Q?HbPHW+nbzvLrrpwlPEg/4xoDw640FKNOZt5qzQjvVA+pjYK4D3XxBGzCub+Q?=
 =?us-ascii?Q?VRqSw026wIOPyP75K/oSHVEvUSzxVAziXP2mduCqtLg/07Pcv12840rJhu36?=
 =?us-ascii?Q?Cl0/PiVRXkRermYKlNKbmt0150ZdtovA38LC9ifE7XBby2aIQuuESzJ8sxrZ?=
 =?us-ascii?Q?KH3kuzSvAd8h5WKX7bJLwHr3tjvVOCD5pqZ05F8stX6iEeE4ImqcoDNYnBEQ?=
 =?us-ascii?Q?SH+mroGCx6isSAQ9jPzewOFT5koWfk1few6vNA9cw4GdZNuqkc4dCCcyMEDM?=
 =?us-ascii?Q?a1QmDaJG0othYBH4I307jv5Hh727t0y3VuFIAy6NN9EFmu4GxDKKh5DHf2gZ?=
 =?us-ascii?Q?Z4eue2A1qyRqcqPCISJFG1qgriO7d1nINyQFpf8grooy7SVsY+mVcxha4M3n?=
 =?us-ascii?Q?SmWa81X8R5rzD8mLA1IggO5NGaaG5KN0U8NshSxSZfg0XheczFkyZfUGBJt/?=
 =?us-ascii?Q?PGkE4CLH2F2n0rvzXYnz3Mp7RwhV5uvgRU7PryKeFLuM0W540DFStLaiyiTS?=
 =?us-ascii?Q?DrpJ6hZm8F2DDlwbSO70liyBl+qZTOfXlfu8vrVvXFWAWkfJ41gtgKY+IeKj?=
 =?us-ascii?Q?omWQmmk/7QfBu73o2ghBjDZlUq7S7B0g2x/Bn0bPtgv7VtJAet2kFea6hMCU?=
 =?us-ascii?Q?9CWjXgLNZMrTgCQRXMYXOPnQUrEJxDNjPILJKYjS6T5ozgUSBujEg14oE8AG?=
 =?us-ascii?Q?OMLkT0Z55AgTL8sL96IlR9+pZ3znEJWsgA241uoInJzS15bPWRk0zRmL809v?=
 =?us-ascii?Q?IvhEfQICXd1WQVPXJPvQsWLNGKD+HDeq5cbzUiJiUYfCVD72UM+ionSDLi0l?=
 =?us-ascii?Q?W8oE4shEJscY8sBwrvuxd8EaX+QnQ5E5qMEyTYef38PMvmPfjbzQYJvYMOu9?=
 =?us-ascii?Q?W+FpAkNZIHnEfAxUOYVBY4xu204a+vdFkQ8KV9y5QQfOWpIld0Vp5xJ6v7sV?=
 =?us-ascii?Q?yHDDo4s4PY3+JHhrQn4j3WOSXuq3xZUPN6biMPYtXwSdFXHrrs3vnY+et0aj?=
 =?us-ascii?Q?T3DjNH5pw1X9O9Til9vlAyYbl0bTKgwsdHBjUYQhZv/ZK1qevftah+hyKOLV?=
 =?us-ascii?Q?0Q9dM90J7KRSpt4vdHiTjOEtBUyTpEZzAjo0e7hwxm5j7jCWP5uIhDkjSbJN?=
 =?us-ascii?Q?6mlZ2FxwbiUpM4P7lvrJ1kMGqfJOgn5z6VhrXQHfaOZVkwy1gw8SSwS4FfYz?=
 =?us-ascii?Q?oynRpsxb+jopmMKBH1uBeZAY5AFPpJwx/rBSfbV3BDpLm4SSQ1tD9iAfGNPo?=
 =?us-ascii?Q?0OVkiW7tFU/B3eJzkC+BoQEcoFaeB7T+uJLVUQ5Wvbodlp+EvbIZvoLqm+L+?=
 =?us-ascii?Q?6OqFENXGP9C6kS0oDJle6DY/Pu5nkoPwyAKyA9URaMz3gyMVjqOS+hM88+1r?=
 =?us-ascii?Q?J63vVnuCK++wx4O8pZwR/uxqI39LQ5tNkn0sTyp+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79019b0-4c2c-4e4d-7519-08dc1e016517
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:32.0549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY7CREKDxxL5DeT8/+uh4n+DOhMnZ4PxJIxRP2XwVJTcZDB3bu5wQx0O6ayJFXmA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

Instead of putting container_of() casts in the internals, use the proper
type in this call chain. This makes it easier to check that the two global
static domains are not leaking into call chains they should not.

Passing the smmu avoids the only caller from having to set it and unset it
in the error path.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 34 ++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 92a72ec6ee974a..f4543bf0c18a49 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -103,6 +103,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 };
 
 static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -2268,12 +2270,12 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	kfree(smmu_domain);
 }
 
-static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
+static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
+				       struct arm_smmu_domain *smmu_domain,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
 	int ret;
 	u32 asid;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
@@ -2305,11 +2307,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 	return ret;
 }
 
-static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
+static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
+				       struct arm_smmu_domain *smmu_domain,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
 	int vmid;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
@@ -2322,17 +2324,17 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	return 0;
 }
 
-static int arm_smmu_domain_finalise(struct iommu_domain *domain)
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu)
 {
 	int ret;
 	unsigned long ias, oas;
 	enum io_pgtable_fmt fmt;
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
-	int (*finalise_stage_fn)(struct arm_smmu_domain *,
-				 struct io_pgtable_cfg *);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
+				 struct arm_smmu_domain *smmu_domain,
+				 struct io_pgtable_cfg *pgtbl_cfg);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2371,17 +2373,18 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 	if (!pgtbl_ops)
 		return -ENOMEM;
 
-	domain->pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
-	domain->geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
-	domain->geometry.force_aperture = true;
+	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
+	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
 	}
 
 	smmu_domain->pgtbl_ops = pgtbl_ops;
+	smmu_domain->smmu = smmu;
 	return 0;
 }
 
@@ -2573,10 +2576,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
-		smmu_domain->smmu = smmu;
-		ret = arm_smmu_domain_finalise(domain);
-		if (ret)
-			smmu_domain->smmu = NULL;
+		ret = arm_smmu_domain_finalise(smmu_domain, smmu);
 	} else if (smmu_domain->smmu != smmu)
 		ret = -EINVAL;
 
-- 
2.43.0

