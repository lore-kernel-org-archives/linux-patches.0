Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23876131E56;
	Tue,  6 Feb 2024 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232397; cv=fail; b=Tx0n8nJJEiwRorISF6tiQADe+KW0SFmQBSbGkqvy4yesVIlJIDvWa4gTu6z3pNfoL/HgPCqzlA+N4KATi/RQ/NovxLm2elR2EUPo9ONwBq84H4B5NxrVw6iR0wi0UEL8XCQZ6e1O1x3MzLqv2iHvIEVsC8B+x++cz1IrR3XXDMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232397; c=relaxed/simple;
	bh=J7DQERBJ/9TaU2Fkqkkj/VQrFmM2ESN4d79sd8BQl7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uHXTmsxbXJ1w5hLvKbDwsV8yRYXEvkeo0eVymmxUddbyz+cojaklolUScVhaq6dfU/50fnZAWsQ/jxeJbYFl1BPndTttSLDd4VYepVBEiZzcE23DUka3ozs1zmjmpxXnHaXEosRd8Qn80dzMWzatADOegcDrr4J0bbXqPMkLjQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jRGEjs9S; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jRGEjs9S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSXN21rL2WS9sQ5ySB7OZ+4Qz53h+4VEG3SLynwa3gew+gxmr5w+0XooAbsyazZ/nNmzJ4ZS7EDenzIXRSPpadRRcTkpTbTvp1w/+GS1zqNnb5FBeje5EukXaWQhSj/Q9Fql9a/Rfiu6XkKULZQKAiPmQoDZTuQozSRALFDw0C/YE8OUdy4GfQ2Qgpwzis7wh1fCYK5Dc8HMNEG4OEsHKCUWTzHxU0YgDL/lZaRrHFhGdxmnsfpLReIImwzwHgSq4yRirYnxVggU5m9bkf+V09a+gcEOGa+67f0UEQusUkfGPVUzDIQsnREOFOifcGcrwMGTfHnElxR8Vn6y0nwAAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDaL8iCsrN3cG8xsMKrhBAKxDr5uGda1SYKKuRZihrQ=;
 b=Au5+p0WeM9elHaERu0c7Z3kvvgqJ0NWj9/oenZrNjVNUAdRXBRmv5mImG81JILz1wuOFhxCC5J+u2uEMNmnPUAUHWrF8P5bIIQH2pfyBqfeSbaoepwsN0W+2tOsahbQfASy9lktxD8E9g7SjPmRMgI5VKqgTdtt1IYSf+pi1qKwTVeLt3RAPckgHtACiwrdlA00YTdFpzmYGVwtCSwvdGsNzYK9s45Nkqgt/TARG/H2dXI64SxK4gYsilRnvzgtYIir7uikc6uQK0iLA6YnFiwHsKIJV4HDp49VABkbkStW7C5qc7krIV1lBFCpZ/R8ZkhDC9/Uq0+D5xHkiMJ3r1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDaL8iCsrN3cG8xsMKrhBAKxDr5uGda1SYKKuRZihrQ=;
 b=jRGEjs9Sphkpp6OuUUmkvpyTQzN++yCEdFXLG9rQ4fwVWYLQbJZY9TsPBUuiUeMsO508rRGB1Hdbldhe0Zi9A8MctKkQsWyBxHHBUlFVupKZxqJbBq5zGaq5X8vEurq9pqEyhBpVCjLdDBbGxFvhKEpjqK/xjY6w5RmFU1SANWQHKjbM6Sv3dNwwwem9Bb/dcWji3D4rHAvMeaOBQjH/x2i1x3jA8LP3TSnsVUNKqXm8poHr29bVCyC99f/hbCRwoFFLzpnnE1owJs8wvQFNLnO/fALXo8apWeamtyjRIMrTBMmeZKS1dqGg1BK6Qi8t3CYpsq8GslQqtPDRRus70w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:04 +0000
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
Subject: [PATCH v5 07/17] iommu/arm-smmu-v3: Compute the STE only once for each master
Date: Tue,  6 Feb 2024 11:12:44 -0400
Message-ID: <7-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:208:160::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a0c522d-9326-497d-8cb5-08dc272618ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VYL5HpLu60kjVF1gTK2wg9adJ6gKSyq2KcaPJDUy+E/yNrDnBCqwVno3HaXmbC70OHvFa0vlbrhZcrUTRvBHxZ6uir+X+fv6/U7In8o/RmFpg4z70EJz8HAWj9YT2xZLWeQYqy7p55gI9CjT+WMLUqBpRIkl6Z1evbWc+M7jqErt8aRAh4tQveXa+3X0zBmMnCMUFzLMltgwPHLLAuIunWvSDlF8wGJDmd9Py0dGbsuevzx84z/Jx5dBqLvl3sHHqaYnuGQ9k4rUixJO5vHnM8x28sYX58a2xn6VwH24Slr62zoH0uJN3RMdk+HVZQ5ywcIvnyf57OyH/zq7uP8oP9TAeWEN5cjeeb0naO42Lw93txEshi7JYAXC1aX70mlM4UccqCt93paMK3ffmtEP5Kr9XyeZu3zbHzrFvOW7HZtBC+VaQxFWEXN0kxiTbb5pIOeB6m06/Zjf9KCc5v21VvEVss6p3dSDRfz0R72ekeBxUIRcTUeTzR2ynPw0SdYzcySX25xx2IhnW8dJm24OPbOVyKPbEuKAzxobJWLPZJgUHlahNNci0NP3gjuFH6nqWETntO0zg//Qngjd1XE/Xqj36yebFKhu15xvGkDDDeM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NbZqARf8j54aSRQYtO4/p1RLdi/hYYI3M4MWAzbsfKSiNgi3bxiVd6g9sJcm?=
 =?us-ascii?Q?PQDpEU7hpVVT18o3s2FB701WNufsGn9zEZicZcoeQOqQwaQKNUS2t+B66gvk?=
 =?us-ascii?Q?REvA+39zj9oa2Ig/tN7jgARTYY5D+61qQ1JVhGGALGbRQZpecHd/idq/oWTb?=
 =?us-ascii?Q?UN3y+Lfzdqsoa+CK1DAqlfyU5H0pMZDRsQn/Ku3RNEHyI6N52GNoJgkzer7E?=
 =?us-ascii?Q?EEer6WGZ/P93XZgg9Glc9Cd/4Mll/qzXae7mhCJzLkqSeJwBSxFBEczxe7Qt?=
 =?us-ascii?Q?71+8pJ2Y3a/6DasLmKk1v/bJBymb7t0U5WYRebjuo6gkBtMTViUdr6BOhqme?=
 =?us-ascii?Q?pKrZvCmLkHsjt6T2E6oNiAjTcnB0dqirpyg9FpMoJraIiKkDGDjZGLt+edBC?=
 =?us-ascii?Q?X0Wj828pfFxCT7dKL1bQGvEG4jzU4EPucj7T7FmyqR7eTHS/AYvEH2cV8Ldn?=
 =?us-ascii?Q?wIXDPNnsZBE7UKRPTqjMkzyX/H01ux82wo/RJiWE66+Njt1OfNdSssyAtVrN?=
 =?us-ascii?Q?KNAiTkz0/xLGXWS+oMzQ1QMWlJSBJEUOX9p9pii6kXtqcb7y8YfdBz+sfLTH?=
 =?us-ascii?Q?F8Xj1iXdreduULkIoO8u8sr7gBw3KIUJcDBx3WQhWGPTSnOSKPT1boaISLpg?=
 =?us-ascii?Q?7FVqouQFGTkDsnOzzkyrntIEcbAcVl3i9UtWbuGS9mrPdAE7Oj2NDssu0o2G?=
 =?us-ascii?Q?scbsI+IQPNOo4voc/sltmYokbXUdQgKj8fCZLrcFUcgFwzaVNcg7mnqa35d7?=
 =?us-ascii?Q?TThlO62wUtcSENST29GppYwwdSXWqC2Aehgz+u5Tg64ieVKyUPUKe6OMck+y?=
 =?us-ascii?Q?ZD5C+PSF61Bnp67EE8eT2ejTwGCIGmu2Wvqy/B9vxD5uT5xKmN1qoOOlmyrr?=
 =?us-ascii?Q?Q0STysXYpp9Og4hbILj/vVOkXQpEAEBfA832Zop4Gy8F50wV5BER4BMjU2qF?=
 =?us-ascii?Q?Qe1f2w1X+XtEM0HmvJs/PLhepy33lUhwjDpQmqgYq0At4BweUpms/tfcjURr?=
 =?us-ascii?Q?qynwbHlYDqRp0vTWchAgbGp02ZLiO8lonnR99Lr45hlleuQiGnWLalWhxCuv?=
 =?us-ascii?Q?3ZWQi+Zms/EIq00ezI8gH6EE3EuG01I738NVVUSprOtU5ulqnIkZg4LfKvdd?=
 =?us-ascii?Q?Y/Vu0Yfr6ckZB9MEtWjVdWeTGzt5qQxoLQLQAMJEEgCSuAmFFlDnPltpf6Ue?=
 =?us-ascii?Q?oSHba0ylKLPGp7IpLpGKUpg7r+ubjCTu3kYBjNgrPR07dlEhr4/FG7KIFhTu?=
 =?us-ascii?Q?fQpbeBUeouoOCwWd/vh7/ZdXkRjlwQZitLELxsNXWNU2cOIjIDBtxHcsAwD9?=
 =?us-ascii?Q?WBs2ZyJCDQbs+Lqjqq+HhDA5yWrDM9B41JwZVTXPXb0kt53WXHRTgH2y9R/G?=
 =?us-ascii?Q?UuiEwyNHVloyEcHhknsSOTB1dVg1/U3P/7QOOKQ0Quebw+s54rqNTr21HcP4?=
 =?us-ascii?Q?1oPnpo4dGNu/BEze2JTWYeCYopV1s1jHw6Gb/twxg8Ytrg1ZgEJTqoOcVDRh?=
 =?us-ascii?Q?CgNLxsNZtEiU5F/ibdakzJLEqURp2CL7t0ADqr04u7uyoIJ0B9uEW3QrINvb?=
 =?us-ascii?Q?1LHPauM40q9FgbafBxltqglWXqMf1VxGxZjlrnez?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0c522d-9326-497d-8cb5-08dc272618ea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:56.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0n/KkvRUPK6kT2cIpD9eYalNEB8jOEU0SEb8ZtEEpKJhBdBChWnOCxadgv/HdGgk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Currently arm_smmu_install_ste_for_dev() iterates over every SID and
computes from scratch an identical STE. Every SID should have the same STE
contents. Turn this inside out so that the STE is supplied by the caller
and arm_smmu_install_ste_for_dev() simply installs it to every SID.

This is possible now that the STE generation does not inform what sequence
should be used to program it.

This allows splitting the STE calculation up according to the call site,
which following patches will make use of, and removes the confusing NULL
domain special case that only supported arm_smmu_detach_dev().

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 ++++++++-------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1229545ae6db4e..1138e868c4d73e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1611,35 +1611,6 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				      STRTAB_STE_3_S2TTB_MASK);
 }
 
-static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
-				      struct arm_smmu_ste *dst)
-{
-	struct arm_smmu_domain *smmu_domain = master->domain;
-	struct arm_smmu_ste target = {};
-
-	if (!smmu_domain) {
-		if (disable_bypass)
-			arm_smmu_make_abort_ste(&target);
-		else
-			arm_smmu_make_bypass_ste(&target);
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
-	}
-
-	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
-		arm_smmu_make_cdtable_ste(&target, master);
-		break;
-	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
-		break;
-	case ARM_SMMU_DOMAIN_BYPASS:
-		arm_smmu_make_bypass_ste(&target);
-		break;
-	}
-	arm_smmu_write_ste(master, sid, dst, &target);
-}
-
 /*
  * This can safely directly manipulate the STE memory without a sync sequence
  * because the STE table has not been installed in the SMMU yet.
@@ -2466,7 +2437,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
+static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+					 const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2483,7 +2455,7 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
 		if (j < i)
 			continue;
 
-		arm_smmu_write_strtab_ent(master, sid, step);
+		arm_smmu_write_ste(master, sid, step, target);
 	}
 }
 
@@ -2590,6 +2562,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2603,7 +2576,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	arm_smmu_install_ste_for_dev(master);
+	if (disable_bypass)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2618,6 +2595,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2679,7 +2657,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	list_add(&master->domain_head, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret) {
@@ -2693,9 +2672,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			master->domain = NULL;
 			goto out_list_del;
 		}
-	}
 
-	arm_smmu_install_ste_for_dev(master);
+		arm_smmu_make_cdtable_ste(&target, master);
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		break;
+	}
+	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.0

