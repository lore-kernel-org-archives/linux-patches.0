Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9712F599;
	Mon, 26 Feb 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967258; cv=fail; b=NYke6u78J1+BVOS8PFei7U32cDoqLX41VzhRhJEfZh1Vj8sw3S5kEQkmsfLtC4Ffuy1LJa7ehGeZs8uK5QM/1axtEB67g20PiKTBl8hO6xO3PLcElNOyMZbDPCYwf/7u07qS4j2EBsDzj/RbL7UGvPk6Xf2Zor8aFtubODe6x68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967258; c=relaxed/simple;
	bh=sQp2QzB/g58ewEC8Oaw5Jl10LclLVijx5GM7LI91hqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p8Vwq1eRLNEIcbZ3yxgm9fp1xXq0T26yQFHJMMZ5R9wDPaIgo6X7dfzPlbiNsXUZPoxmO72uB4xuKqXK2qunywpQ72QW3U9ZJNK2/SM2FXeEZCGjigizSlF2rlR3tCeJw0YqWHju1DFZXiGrl2cj1A8Bwjx9SoWiq3X8sFMVpVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uGkibC8A; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uGkibC8A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VS62wjgdCGNB1GqS4pJY+/L6Oxu4+yCMvqG6uewXMD2uZPAk7mLLc01J+MYxI7blahnpG7Vd6+W9R1aGBc5AZGRkApzu0L9JKXiKFP3YnoCwH6gKO9Aei8NMMIdFlAD26GxuKwQ0inClGSKzYIY6Y0mElrrIBOML2VuJ/pYqD4ae5ugk76EQunWV4JrIvwXM9QZEnrEf6ueCsit3mUbGnTxCPDJJvS2KXLFNH9wRv3//lkiGc+CspcVyVolu6bx6CacM0kWCXUvGj5xRRLC2pFjpsGDI/K+q26uNuW27tu9Abk3bykHIfe7CaGVEUHcD+4g3cfKB9jVTm38JWpXfYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSWI2KHW5zcH0QlDKCwINPDZOpnQiCisbxGGeezTrcM=;
 b=H3qB34+KKatennzJa5ymTrdTA37PEsQYBaXwBaGUOtZnJIpfYevNRCa/EYkr0H1iC7wR2uOtzymXxD8bKm130BkwPilXGwQlysvwwHXUSIiYBtejQGDzJVlGYVEFUktXSdxXzYqk3FX7hjzeAeX5bgf9xIW9SzkUNnxmlhHt2V4jPLVkVfXpxtfvR/C3kzD0XqWS1p5a7hLfozWcaeibRu4tG3VPO/UYV9ArO9/9A5Xi7KZF088PgDcy0yNtc8XroAMsocmp9on+eSnaJDo7z95qw+FC5NWmfq6VaYgBeJQs6qUAxdjj6X44o3CsNyH1Xrf07n9s3F6ygbwWHGsGNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSWI2KHW5zcH0QlDKCwINPDZOpnQiCisbxGGeezTrcM=;
 b=uGkibC8AVl8BNdLTx65N6dZ9EgoFkKRG9oGyzmFZk/HGTYZdnfXRbYxszUtIHfYOfp2Z9GH3Dk3l3VbULhZuGBAog/fK0eGYTCe6SfOVP8d75HXlBGa7VT+OUYiBawa3ZQWux0TXwAqtncvqxiVmkGYK8JniW/fVQ/HsR0C7XNUELmTLQdRDRWYrzZEpw/MPxTcZyZqjYoXOgyFpkfwEKzd4jvuuy4KPQZIT+gCJhI0B6DpWI1t5TOCndbYycWhP4ZMXX3dXOKPWhXhQddJsvTY2fWcPUxjZnkw5q5MOBucjZc2zAGsTzCaokwvvUrEWPxvc9rk9Vy0yb98Zr6IOTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:30 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 15/16] iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to finalize
Date: Mon, 26 Feb 2024 13:07:26 -0400
Message-ID: <15-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0025.namprd15.prod.outlook.com
 (2603:10b6:207:17::38) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d93afb7-7bc3-4dbb-becf-08dc36ed69cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bTLS03aqq1X9aYrJ1XUnu3AohMtuPvTqKY3+xErEbexnl7DjeuflxrER+A+ef6jHthg9FKw7JJQNorScQwP8momEjK9cXmvD1h4ah4/CIoc/L58ROvKn+M9Dwc6+i1SUiN13qQl3h0jJZowTAq5Ksjz/UiiI34YXopIUGZnSCvryIpL9yya+J84R/eFwQtx9pZMXyuXqK2Vd/flrW199gOcORGIW9BK9cZzcGblPpEIFpygxBwNrMdCJeXxQDYBukpZDrAgmuferc/F/ThK1SWw6UqNmwTlHENU4AyrV4UcNqVLhfKvCKISvxh/rZeI8a4VSMjQED1YupCg3Qi/GYdJUXLbukT00q9A5iEotKeb8fdFcNS/tVFkeCPIp03RumeSQpREH+Dzl8hZvbv1NDE/O0235IoE2DL8kjb+iDlDwLJy0tAosCzPppYxTTVgIJs4R9RyhumXjEpO3EypsM39Kq6vVOQegbKPwtDT9cje2cF1guL3B5I1WUV1V9Ih1dJaROT5qsZzMRyo67MGZ7L9gT2mX1VtEPNujTameCWtN8LIqPqhAQPlCbCTcE0VPzHIs5JO4V0JjNJAF7tWRED59stfWKdaOTQsLJsUzVXbituajdiN6bmF8fNAbr3w/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dax2gul0eVi8XCU9bDdA0Zdr1dUOLKGtDeMC3fAcpMVNQ6AuZ542hKL2QDc4?=
 =?us-ascii?Q?B7Rcquo13vnK2aung/UwdfgBKm7MSOnJdVOSA7igzGY5eBQ64Ar/8VlP4qdD?=
 =?us-ascii?Q?yccvQo3C8QMG+ui3uZJl62mh05DQNYZSNqWD20bvmGkhfiThee1plhNOCTp8?=
 =?us-ascii?Q?Xi8wnRLcepQ8MQpp+rihsb1Ss592lAe86ZewAFVBXC5Xau8GkA+k5Ii/5sNA?=
 =?us-ascii?Q?f+/JXkKZ6kPSXehzjVWmCupbrErw0AMeijHWUJAF7z29EIVAnRJmsWCbBbtY?=
 =?us-ascii?Q?heAMy1LFL+k0Kc+YeIAskawxyA/Fm2vOaNkZvcg+qQx21CJuVEz54pq+1yek?=
 =?us-ascii?Q?kxjvfnJIC0O6Smzdmii6WDQ64vPeijSbFPS/1YEGAFzfRjtwg3iYdLPmnHOf?=
 =?us-ascii?Q?7Wf5GvvdrC6Om9ESEiEwClGlqSrwD+iE6hwTuZmEE/9qz8WLyrItnY7W0Ml6?=
 =?us-ascii?Q?2p8UvscualDdHALP3zmzkV3MEV2734OCnE0vEcpe9Ziwn2KaObtrgflFeTFj?=
 =?us-ascii?Q?ATUKiY2rCMYjvt/gnclQ62xpJ8cvaSZ+mcc4iVpn67uG3EBJ0ZpT2zJxP3cH?=
 =?us-ascii?Q?6i/JXS2oAssSqeFhIc6rpZ4BBPggBRElu0bjGDqAyntDAVZVTwJ6AwwHOQi7?=
 =?us-ascii?Q?PM/ftK1FDnhrDAM8jk+hpfNVmIB0EDdtFK0+Onp1HcY93+5zIZdLjNGqijSW?=
 =?us-ascii?Q?JIKOjGB37Bc4S4UZQzkL+pW+yuHd03Icexf2XxEVIObM8t/3q6lO2jZtjIQd?=
 =?us-ascii?Q?7aRjpmafp7gFFmUisASq0HSzgeyxze1j33RDZEggNKHmgCPFT6fETi6Vfqjx?=
 =?us-ascii?Q?/3qf2I+ScJMC6VFpCH3OB+QBfOB61fDXt95sJAnkxhmBZMykPTnuInL1zEfo?=
 =?us-ascii?Q?nAzPYjK5K0+wB2v+ANOvrhOpATtIc+2Iu65mcNZfuJw5mrhLz/BdToj4oRg7?=
 =?us-ascii?Q?FKDJY+rFK1OiC1AEuztFzMJjEzPeUnYZj3uMRth6Q/KoosHrt7ErGmEaPdJD?=
 =?us-ascii?Q?I3x1EMCKzxAO/VRek3psM7b77QNaRIa61IxC5RA7NGaew/1r1Dfcj4tfEOvf?=
 =?us-ascii?Q?agIty4XuaXsdRtWYLW7rq9omR5OtUxaUZ13cj+zPdzky7Dzxics3m8LScgHB?=
 =?us-ascii?Q?eid43gWqqm1SUHk3edQ2LqfGuqZwUELl+dqtikZIW+nGt+ETmy8RaBGTUO61?=
 =?us-ascii?Q?KOcxapXf9KMTU1Ky8M5TV2iFo29dBhVAoCS9/B4phRke0VE/BFvKiQIcp0VO?=
 =?us-ascii?Q?xVYnOoAlcm7w/hRwv+KkxB4m6C3xNuNw743/BOsm6sS6imrmrgdgJOvUEeok?=
 =?us-ascii?Q?hufwj7FkZTml3lgNjg4e/l24G+JwxTZE0oCMjuQ1k0JQvIt/kl+rKH1oqSF+?=
 =?us-ascii?Q?exlE0Ajy6vxLdH6pT2wfRL8QoH6MAHpwqOqGEzL/BHnZ+kglJKtz4Fs1hdtf?=
 =?us-ascii?Q?9FVsBm3nHx2jppB8EkL/J+C4gUfWCml3jijk+9yLqjTewx6XQ5ZI2OlDtTgI?=
 =?us-ascii?Q?CAO/FTY6yJvU0eus4S7xO1GOtGQmcky/LlBgfqDGtRLQUirrTRei0f0O2j3d?=
 =?us-ascii?Q?HPkqMPuI3xXA3zy4e4I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d93afb7-7bc3-4dbb-becf-08dc36ed69cb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.2071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkC86n5lx58C4giJT63LebNHkApdKfrh62mMV11hE5HGJdU3kpLtwVZXbxqAxlch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 +++++++++++----------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1303e9c603fc6a..ebd8362c8aa3ac 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -89,6 +89,9 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu);
+
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
 	int i = 0;
@@ -2242,12 +2245,12 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
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
 
@@ -2279,11 +2282,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
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
@@ -2296,17 +2299,17 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
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
@@ -2345,17 +2348,18 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
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
 
@@ -2547,10 +2551,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
2.43.2

