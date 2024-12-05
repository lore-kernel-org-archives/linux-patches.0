Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C462C218E99;
	Thu,  5 Dec 2024 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413420; cv=fail; b=l2RbbGmNPrxszJxjRSV7f7NrxFMSflTSqGeQ6/i/5IqVMF3XER8tBKOgrnqVYPzu6z5h5ruaI7hRa5/RtTCpGvd+Vw8SmUeDDVxPhJ2yw3cFF9kA/iMK3l6secr63HMtV9jI/dsO/tCI0dYQx/Z4maEv6IVcVIcRw8c7v/dSgHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413420; c=relaxed/simple;
	bh=/Ce3hr9hYVYp6aWS8LeFzi1G3ZIf5RtsA82f4CLjioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rB9wejI6CcDBjy4xL4uF/2XAajHD+QMJ6KU2DNazPzFPDbwJrxQHa9i/MKJkqIrQ0L7gUBU/spsmGGGZBsDqHLbWvUIC/1THHDoPpDdkepJFcVsyh/0NGtiErdh42sMzdc/H8JpcADsbhCGILlJypGqZXPSNOKsoPrCdEsZioBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IAgV648G; arc=fail smtp.client-ip=40.107.101.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IAgV648G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8xjkY3YrTvDJ2yJo0gZxgWXxU1ldlO7hK6Hz9P6OW02UMYmMVd5OI5P0QoD8QISxriQqJNKJBc56CewIBIHHRIG3VRBrZY3x+wOLw0+P9QU48YXooGRDBVvIFzWqTiGr7Vpr4HPXral/ytjnYePxngTOoNEB+3QjkfKZdq1O5jspWHRXiOfagpllOUU8OO3qAfwh0ResRPa+LBtIJitQq9doPHfVx3JjAdphOY4MbDSc71dA+MPG/Rsu+/ij97KN3q1+1fhJrgVfSfTfkTlMMe9HaTbRnIdfRpb2WOFiXFha8SeZIIaWJ8MgjHr4a6ANXJZQyz+0twxtLfGMwS44Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4t+7LEKru34zt+XUKbuXCe37jNEAPuvOcwMVuCXbEY=;
 b=hKb4JSmZxXGQhgkAo5JOaxB921q3Bc2feb4aaQuRCnWQf2pBuynQdHaKNFP/6OLfL/Gvx0gAphvjGPnYT29Z5KDJxfYPtVhRI5Ct4Yo9MEEGW2oi0x+ULpyFq03FLqiRTCf2bFLTiQPmYV+SKHUEo900P3ZmG5pg6ztzdpiUDYvT40exZ4c07gQws4JZpeoqvaNFo+2bHNZcTn0bWIJ5G/Ucd4OkHKCL70IPxMCDm8y2cUDsg803mtBq3hte3Ju8qn6m0lZE4Oq8yMbYsmzykg1a8i5CdiRsG8JBY3v7S+CeoIx4hBbVgjvAonoN7gzO2rOcTiBJeWbmsridWDeFMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4t+7LEKru34zt+XUKbuXCe37jNEAPuvOcwMVuCXbEY=;
 b=IAgV648Gp74xWgb6EQnS3UlfDavEopTFAsHPvUBOSwCqVU0sqRSJOkzx6DO9Muu4mJnlblQWx5/IDScBkd1IzDML0mQkPrZULV5c88EqydwREAGClLQABhTAlObGDeagFKxtdKrLy0eLPMrUEjxskiZwm0EsKbXl65EaDSJE7dkeJKUCXGaw2DKJLuY6Et57o5HS9N78+jyphnDxjQmSNUlS9KBd4wzn/4VdyUMkbkNLnPkAGAU06XK7wxSGcx6gBso1CwfLWGZJ1tkb/VtcWo3INLUlus7nrNADQlkGZ2ZnvHFBzALuPZ2sKKRe+GbQlu+1J39FevzcL+i2Fb3SFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 15:43:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 15:43:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 3/3] iommu/arm-smmu-v3: Remove domain_alloc_paging()
Date: Thu,  5 Dec 2024 11:43:29 -0400
Message-ID: <3-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:208:32d::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: a09349ca-a929-43cb-ac95-08dd154391b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6y4rWdM22yP6U/xpIXuWZIYMVp6HgzTqGk8VyoKGH5btCQMTgAcdzeWe0xKE?=
 =?us-ascii?Q?m8EvWC/J79iPzCLipCGxVK1m9++DBXm2x1N8f6BuCAlzbA9c1szmQJftpFyU?=
 =?us-ascii?Q?MBYT+7CJVeqzg4fE9njGUu46EPkV0/F+ROUKWZiYXZE8yvIZqDftJ8Hqx8wR?=
 =?us-ascii?Q?bUV+IihF0WSdUpHufKyYESwqXDe2i5RrT4mS/UEQESiclJJbZqep+z0f1sDc?=
 =?us-ascii?Q?lZIdvGQUaLQ67+n4x0dgHpvd0oo4PjI8eR5xhMwcDLjKoo6xjAbiqRMVnkNZ?=
 =?us-ascii?Q?EIvYLWXDpII3sqoXL/7GCcSwx5Ua5l7PrkPhJI64quzwZViKCL2vZv6jSifP?=
 =?us-ascii?Q?QmwSD78HIC52+8bpiBi5VvrQCsYzyDRrW9U70BBpmG/tcCePqytykshK2Mqa?=
 =?us-ascii?Q?ZemGawf38CzXyUHUsEPk0IliTaLNErYdUE1pVj0S9av07yz+jpmwkt8B8Mcf?=
 =?us-ascii?Q?WhdVAqVZJo6yfODZWALaOe5xRvh28ILe4NaGg+VA2m5/dQA16CV/Lq8YTMVm?=
 =?us-ascii?Q?ZHeLWk0zhyuG5eut6zQr8AfCv0aJ6y6AkunoMDzFV6WGW0kUS6pRkBp9L8O1?=
 =?us-ascii?Q?WcYVSzgblL0aRJMW17/cvNHlBZglOSzOvGh1MbmCbxOscCHta+GfDYgkzUAh?=
 =?us-ascii?Q?YqMstRF6zSiLINKNl2DnMvI1TY8BTiNQwjj9TpjF+dm/xFWqaf3zYWJbxjl9?=
 =?us-ascii?Q?Q6bna2QNFYzrTXaiSri5YtdLdhcrHt9pDK4rgYA2i6jKa7cbQ5p8xLSkXrn4?=
 =?us-ascii?Q?EJ1NOpdc6XZH6xBXPbXId1a2R/XTzTVCIewODmCe2wr4Vcvf3w30GZgoAa4q?=
 =?us-ascii?Q?ql4tCkW38iXUBbeb5epc3SCB+Fes1esxXLzTalelJ3AbJUgGY86q4Gr0DToA?=
 =?us-ascii?Q?zoa4kUirYXXIeRC+1qrpm9UV2OtH6YfDBo2ZIGihyau3wBtQDnDHA6M/Y+5u?=
 =?us-ascii?Q?y2ew2drME0Qj/7atpJ3qIYwnUSXcMkFdykrjr6XDXm3WyTQ/hhwLcTcEm39q?=
 =?us-ascii?Q?AUF7zl84SdTYtjR5MdHSQ34cbf2UJMqx/6aXfeA1p3kScT6el1OlKVb+O0h2?=
 =?us-ascii?Q?Z3Pg7gXfpjAyGn9gqJAejI5OgHajt272cG6gfN/MbCm22WjUQ/CrcPG8UAqR?=
 =?us-ascii?Q?cuWMRO7i/eVyfdlQ8TJC7ZRvhgaWDiYFTULrsf1nc5iHmj5DcUUs9zkunB67?=
 =?us-ascii?Q?IOMhoJEAcHlV7x7KOvMztwPT7W0D5BhMZr7q4zfvMSjJwfnW4W6HDTJqMgJ9?=
 =?us-ascii?Q?ta6RmKecdyhbldjqHk/3WcKSgR3nB+pF/nGVqNVVOyMXmRk3eAgsk0UVvKMy?=
 =?us-ascii?Q?H6lBlNXyro8UGOQLVAUCse/nSHc9FPFNcmdsNvSNbub29g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6B3cUovmQ19z0O4Ju0dSbxUAIKt9bSd/39Ooee2h1agt1HXsyB5gwEWNvKX7?=
 =?us-ascii?Q?G6szEYCg95IqsLDX6v7TeO7aajlDp8XrkPSH9Zedokd/CSn4PglChwr+Mmxl?=
 =?us-ascii?Q?85xzKxLzMhEB4i0Plr0MrWhGcBIq/lhpl6WOqIL1LQ9Jfzmeeicze1nuGCcq?=
 =?us-ascii?Q?TKSZTjvAYO8SR+p3AG+TbZJf4q0hiNKUvUX5ScyCE+D+7cjxR6Iksud8CnU+?=
 =?us-ascii?Q?uAUFgrrGSq93+rJ+dp38O91LDuR0ckqj9zjkT02W58XGB3vxbYqMdEwl9kdA?=
 =?us-ascii?Q?a5CCtxJxMrQzyRid9zTKVNgAn0lHlfEV0K+HM0gUGrGM8eniQ//IhxZdnZZ3?=
 =?us-ascii?Q?pUagbxnbeUd6zGua5szcOnuLEM7AD4IJzqWDm3cCu6zDyQD9Wb6no48ZnjkT?=
 =?us-ascii?Q?rikxFECWo9Zj0tKHRa6ZcDVWssXRyq5otDK2g5EdUngEKPnzDCqHVhIUKS2b?=
 =?us-ascii?Q?fZNA3J8hlcq7Yr+iCbLh4UmVcN+HCBw9olaTBIWvqyF1ljDwB5oWWCHxKESu?=
 =?us-ascii?Q?fclagdtO+eKmwfBS4eeP0Osh0nmW/tMZrRV/dmF9mh9/1ybbiZI82FXeHYCA?=
 =?us-ascii?Q?jUJD5hV/SWpkPRG/EVChWE6tvAlGTnHLGc+mP1EmnxyVP1DDpzBtSiH4MhZJ?=
 =?us-ascii?Q?ProD/qw+beLXdXCOCixREQxjLYtT6ZyBq9ZoCMSmELYbgUewrbqLZOQlRUnk?=
 =?us-ascii?Q?zZfP57j2iBb1NoFDYuGalxMPjnTDqFMnupMbv0o2kkOZEwfDz0TOoFi0TrJK?=
 =?us-ascii?Q?m7uuVK+FeKn7atEBc+KLHlQMYhOf9zlNBbK29pCP0fnDH1yndtTOtKkYmiUK?=
 =?us-ascii?Q?2JE0pEPH5M4y1oMyKGzgFQSVGBC0O8j5z5qXij/irdMA2v4+0GYgQWzM5EDG?=
 =?us-ascii?Q?1UcgzOOhH7/kOM0ZAz9r1KwtSN5f+NedytMP/2GSMbXA/bk9hFOFxMH/S79A?=
 =?us-ascii?Q?Yvo8qIrEQKmP6vXE3U3Nm/8RQHddZfWQA6DQI1JaEOzg+z3BJwGU+5bt1yID?=
 =?us-ascii?Q?XD5NGajyydK7Ld+HpXNRiVvZP4GEB3y9EXwQE+WtJf6YSmqpd0bm6J5uxNMD?=
 =?us-ascii?Q?bcHwCn/qj6F6wiPHxTy4yd2qZVG4N0zyft4HRZyNYC+VeQg7KeEcVeHkPKL1?=
 =?us-ascii?Q?9uj45c4GTYvigEcqKuLV4wDDPWWJnLxLe35//cCZEfhP1nUHCicA7dJq+JJW?=
 =?us-ascii?Q?40Mj2/sD268zw3nYsPMtVXTQjTnT6uqfRCa2O+THybxASqgTeLWBcJ6EALdY?=
 =?us-ascii?Q?hvjHKEZTZjF3VmpUYJU/oN2eYEz8D9iJaBBY2RHgzXcr/aKSVZwUq9zHu7U0?=
 =?us-ascii?Q?ubGDxYuTt+j1giK8hcKA56mSCvEVrtZdObddivIeK5bXnpR/GmOJ9pyzv3Hg?=
 =?us-ascii?Q?SI6qEbiVo8syulOHZj15kA2VEdISUAGJruvFHLKy8gBXFct+GamXlFDi47M3?=
 =?us-ascii?Q?bpg0CiRoyAgGZREqZMkuOffBx8e3ZXSxaRys9LjmOB3EV5r0r6Xk9e3ei0ao?=
 =?us-ascii?Q?bus5ex4lhsRLiWQsCKuXgrVfdEEG2qhPEz9aHBIJq+YZpXWYjlLfdvWFRIrR?=
 =?us-ascii?Q?/8qkVDW85SGU2yo5WcO3+ZgLveEH8BoR4DBUB19t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09349ca-a929-43cb-ac95-08dd154391b5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 15:43:30.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsOsZ1BVK/57eFnszqDgWNtVOdACr5rU1n1cKhXyST2ZaN03kF8VsW22XlHnr3vD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789

arm_smmu_domain_alloc_paging_flags() with a flags = 0 now does the same
thing as arm_smmu_domain_alloc_paging(), remove
arm_smmu_domain_alloc_paging().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 ---------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 00105ccadc8b2b..f285b98f982c14 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -83,8 +83,6 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
-static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
-				    struct arm_smmu_device *smmu, u32 flags);
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
@@ -2359,34 +2357,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	return smmu_domain;
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
-{
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_domain *smmu_domain;
-	int ret;
-
-	/*
-	 * Allocate the domain and initialise some of its data structures.
-	 * We can't really do anything meaningful until we've added a
-	 * master.
-	 */
-	smmu_domain = arm_smmu_domain_alloc();
-	if (IS_ERR(smmu_domain))
-		return ERR_CAST(smmu_domain);
-
-	if (master->smmu->features & ARM_SMMU_FEAT_TRANS_S1)
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S1;
-	else
-		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-
-	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, 0);
-	if (ret) {
-		kfree(smmu_domain);
-		return ERR_PTR(ret);
-	}
-	return &smmu_domain->domain;
-}
-
 static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -3549,7 +3519,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.hw_info		= arm_smmu_hw_info,
-	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging_flags = arm_smmu_domain_alloc_paging_flags,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.43.0

