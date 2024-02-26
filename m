Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9151512F5B8;
	Mon, 26 Feb 2024 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967263; cv=fail; b=Np626zsTDjQTIY9fGg3dvJuRq/fAUobGrSxuDpzGIDWRvGy1X3veWrVACG7cQKv4JJseZdFndIAU3rFyaJjNbOmx3RUhw9O0+bwiagL/k9joIc1nSfOvqJTRplPtqzo7sy7lOhZmxqATDnDiMM1Z7UR2SG108a70UJmTq6PqDnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967263; c=relaxed/simple;
	bh=3lNFm7fcNu81Yoi9RB+vYTgvYT+emHgbHTbaN61FGyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JIc+qfnZUudxvSnFXyAexLt+Xm5TYcEARiTlVO2mAf0zbRjPIpiZg51oxxN005B4bKMIhMmnBb+A/MnHw6ILvJRia8Q0ERJvDTGAjCUDJ7C17mNB3Djq8QbugXZyeaHZQqn4YZrFQ7PKwB4sY3nxLfRb5TCPqZe98ZvKFBqXsoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RpgvknOc; arc=fail smtp.client-ip=40.107.96.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RpgvknOc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfP6QE7Vk5kVII4geHCHSOk48FQcsyfidhuZIYF6NsJRWN5UlChpz0ij/NAcv3NrzfdeelbG+Had4vTGphAxpEl/1f2kH2una3jbIUbsOSP4PePf1PlyOi60bYSEAQsS2caOUzFfDHYrn4H6f6pKCKGZ1IzyPsUBlByQEJAsyl/IN0TzJcUd65UBxBtobYmVmNBXLxX4Sw/qlcla5PYi5lTtY+EsXaXFrCkaGvicTeMOaxJunQxZSE/bt3BCBXNtkkWusri7SdfHznQlwrXV8BiudKmT3GLAnuP35dYeeeNuI5n61XIyoFgF7jP+qZLlnC9huAh/GxWWi1GM6lkhsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qP+cPI9ElikO9HdrsNVCnD7mKvBON6I9/dK5f/bFbz8=;
 b=ksblEbMq4OyiRnMaNqueWFpDr1PQRQMascVyTrIQbOGz0TzolKBQUocDiOcuQpZvJ/Ndo5is5MAKNuqOJlu0336VWnJcnUOsWlNNPsTBFn3L1skiT5wt9ws63R8JYCQgQucqgKmBmE0v0JFF9THCgponLVTbiWwxRwXGnAYGQSyBsWFCCbfbUxT0VvleD2UoG6y55sdW+3Z25iNUtAW5sMYd3SnfDqRxcBP+sX4Gcvdb970Cmfip80sLDTcYYjAY4Zja1mud2+d+OXTm4U+IiDy5L8kwI7YasDtJSWzSe630xBxk/4aa+0NX1S+UCPAVol4KZlNQn7iNu8BOfz7SUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qP+cPI9ElikO9HdrsNVCnD7mKvBON6I9/dK5f/bFbz8=;
 b=RpgvknOcChHDA4GnZ+SNeE+a86VwUkYzvHy6IBdJJ2S5oPx5Pa5Ae93gUYIYCXhWes+8ZRUU+8TN8W/kh33yr8mCjXHFfVFy9Bawebnr9V4SLIcTb7b/I/ucRFeT82eWEKMEut0TtoZ25GaEQiDhQmDUfXCWxhJLLfLN00AA6qtI2icqCMbK8c1nNFY+TOCALcV/SHlCJ44xeXN5oT0XG+S9hCEbalgD91af1kvm0VPSxBoS/5ZY0PNoq+l9ZAeGEGJlZ4ChPXgiezvEeiICbU/LNWSTvC8YJL4zZ9hoExJa3hg6JoZH1zbDH4Dqk9kUDcmhJmCQxIsOmTuKSyNUnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6905.namprd12.prod.outlook.com (2603:10b6:510:1b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:32 +0000
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
Subject: [PATCH v6 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY domain
Date: Mon, 26 Feb 2024 13:07:23 -0400
Message-ID: <12-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0049.namprd16.prod.outlook.com
 (2603:10b6:208:234::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: 66ece28d-a146-48a5-58dc-08dc36ed6a55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	maskoXF8ZPQkJieRapbjma7+enAuQGpoF3ZpRqrDiw+SrMwq9GJjQ12lGjgQc1OlClpU3SzNJugu2Ts2Y6v7PmjqdN4+9ETpYxRq3ib3ailM0iaeQ55wMRBQp89s23OTlziU26TF9kd3tSK+Zvu/Z0Jnhr7amCa8Fl05aeJuye25fcDp8U+qMuEGimD2i1+f+xGiyCnmO4X6Y/ngMhg0snxzuKNEAnCgj5nc1K8V3tsBkl4sxG2QncW9ec8I5DXtz0srJkQ1Oad2b7DQXg0v8dpkG9QkGhgh2FyPHx4nGijsf3BHWGauFgR/Gf+YNqEaQd4jBbPE6XEPbj5D7+Wm776VMRLzXg5yZJSkImxnksgwmYsSL9+OLkqnOiJezdjhmn5fHSWQ8D+7J4J/ZJFPpvQTHPoZAgw1RrkE14dL+o6LSKJF1Cuj51pUEvwrs/dMBCFVIQMpW9wloWTteb+2sL53jDRLLA9+8Gl3yPU5SvFgAeOY2k/obpxcj8zJKNu5hjqGeu27avtsyHgyzzhWj28BQ+FQBiOe4EHOisu7lzRyF3bV06nCeQOWbQKGPtMqOlQaLsQ5ndBKLijPefUswc+olw2ZqBEarhzc1rgtVGzsLtSs547bVOcdgYchbMYR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fhfnIeXdNHZgFP3ROqHytWzXByp3xl1M8zOZQm8lEGXLGe1RmiQ+s7hAQHO8?=
 =?us-ascii?Q?8A3kgmQHWWwsDVPr65CTbUamVuMH2rhrpCH8y0d7UaileopdVcWxyIxXL2eQ?=
 =?us-ascii?Q?D3pmny7PjIl5kHhIlpJeSIAUqjav8l+2Pv1tDjD/zakbOo8h/Fp5xkQrOgcM?=
 =?us-ascii?Q?C55sHY0Bo/7ytHSXHiDZ0sEEMxV9k/BdOgzERkGQ9HteNDS2q4IyicHwEt8l?=
 =?us-ascii?Q?PZLRqsoIMJbzOnfkNLwcZ5bavAmmoznSo6VvrqU9BMXg65giwvCMP4uDkWuD?=
 =?us-ascii?Q?vAsHIRPMH3MaEiRoenfV2KDWT6+N1lXZveJXFB34abyOudEPl63EPk2O27tG?=
 =?us-ascii?Q?k1TRbzBgHlwQcK++RKQ/i1CBkodzSqymDoM10lKKy1yX8ZTOJlLMfhYXYXB7?=
 =?us-ascii?Q?W1YGklFhhdigR0WoOC/BaQzV/BSZmgjvpG67RlA7aO+IxH28LSfz7cXv+b+k?=
 =?us-ascii?Q?RQ2vORvSsNINcMmGbYL4PoLbpvFkjgLK+gHmqEFruThEGZSk1Ey8rDo4NFSv?=
 =?us-ascii?Q?R2P8Mr9NySkyD4eZpNRZFUrM6dSBrsgtR8/yqeAar/FCA4tcZVRfZmz2f4PW?=
 =?us-ascii?Q?aBKx9GpQuX7b/T0MI9Z4IuHQiNr6yq9+zorJBG8U1QKC2n7vc8UF7Bxh5kTf?=
 =?us-ascii?Q?0/GBVPxqacDF7GDPRlsrVs+JGDwyrXPLrfq90Yv6o2dK+do/souZMf9jrk7N?=
 =?us-ascii?Q?H8zASAvO0QKMPw8sot3ezXSud/R/cwdCZ20vF+UV+yJjp5RDr0tT8vl9zcCo?=
 =?us-ascii?Q?DsoDGw5mBXZYucdtVeuJXS9BS2oN+pcsSoze92TrGikH//zKZfEHm0AQr+ka?=
 =?us-ascii?Q?hIecjnszBMndpaIwbi0Dj9RMxwd23aXU+EtWrxJzSnP28lQN1xN8e7jtjy3J?=
 =?us-ascii?Q?eGq9CjirsJdzCxCM9nEoaDBNeWotbsB/2G+bsFJbOs3jlG/rAFt/xCaoUemZ?=
 =?us-ascii?Q?Q57J6Jq56n2WhNDlSE7iP95laDV5Kc2AgbE4Gx3V2XX2LQPUbGP6fzOVNCUM?=
 =?us-ascii?Q?xaibRkSSiYKpfSgk1VlLvn0BscBmUYcp36z5lcqU/wo4X7F3+2bDwNGxLX0s?=
 =?us-ascii?Q?l0WlwfyOvG87ZiSja5OvY+QI9x0HvKEtl2f3dTXzaMCfmio1zPIKnaXRFmpg?=
 =?us-ascii?Q?hlR20anoIAGnTGI82153cIU5BECcaNlN61Pjnr5lbo+TeZYs9svWAha/Klml?=
 =?us-ascii?Q?j0NN408szAtnFVyg/JuFBj0NOHf02d/KHbiVlBubmCQ/49ypZ9iRKL2ZKOrK?=
 =?us-ascii?Q?k15amQskIPQS1aPWtgu42q0jSXCicjr4pvOBk/cp8V3wlLhJ578wGAwOcFv2?=
 =?us-ascii?Q?o3pBFkS0RuMNwZsSF8eOOvyKvnWjV1cpE7MgGj2eZdOfucaq7BR0B/8X/ZyJ?=
 =?us-ascii?Q?t7LOrqSTvD5lUPsdk+XCuwaz7LJSgBAHyktcgHonx5Ga9YJcHisSvnw0E2QT?=
 =?us-ascii?Q?TmXEa04N9QfB4hP5zxvjozM9WRvCeR7DIpSSYuFypJbHM60fLcXzdoI1Ta0z?=
 =?us-ascii?Q?110d3I07c1ZLtcfAewV/I0v24QW2v2f/xhdBMVR/zbBSPYcgLmfBRNE32jLc?=
 =?us-ascii?Q?/vwDHCpuceKHLOPiZgo40xXNRs0TGCp254wA9Fec?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ece28d-a146-48a5-58dc-08dc36ed6a55
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:29.9742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8sz0ZFQr350b1WiOFm3+fSMaEl0q/qaYJboUhwVyYyj7VAOunRquo4ah2mE7vY7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6905

Move to the new static global for identity domains. Move all the logic out
of arm_smmu_attach_dev into an identity only function.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 82 +++++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 19a7f0468149cf..842ff8a95baa12 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2200,8 +2200,7 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
+	    type != IOMMU_DOMAIN_DMA)
 		return NULL;
 
 	/*
@@ -2309,11 +2308,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		smmu_domain->stage = ARM_SMMU_DOMAIN_BYPASS;
-		return 0;
-	}
-
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
@@ -2511,7 +2505,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain)
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
 		return;
 
 	smmu_domain = to_smmu_domain(domain);
@@ -2574,15 +2568,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	/*
-	 * The SMMU does not support enabling ATS with bypass. When the STE is
-	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
-	 * Translated transactions are denied as though ATS is disabled for the
-	 * stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
-	 */
-	if (smmu_domain->stage != ARM_SMMU_DOMAIN_BYPASS)
-		master->ats_enabled = arm_smmu_ats_supported(master);
+	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_add(&master->domain_head, &smmu_domain->devices);
@@ -2619,13 +2605,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
 						      NULL);
 		break;
-	case ARM_SMMU_DOMAIN_BYPASS:
-		arm_smmu_make_bypass_ste(&target);
-		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-		break;
 	}
 
 	arm_smmu_enable_ats(master, smmu_domain);
@@ -2641,6 +2620,60 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return ret;
 }
 
+static int arm_smmu_attach_dev_ste(struct device *dev,
+				   struct arm_smmu_ste *ste)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	if (arm_smmu_master_sva_enabled(master))
+		return -EBUSY;
+
+	/*
+	 * Do not allow any ASID to be changed while are working on the STE,
+	 * otherwise we could miss invalidations.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	/*
+	 * The SMMU does not support enabling ATS with bypass/abort. When the
+	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
+	 * and Translated transactions are denied as though ATS is disabled for
+	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
+	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
+	 */
+	arm_smmu_detach_dev(master);
+
+	arm_smmu_install_ste_for_dev(master, ste);
+	mutex_unlock(&arm_smmu_asid_lock);
+
+	/*
+	 * This has to be done after removing the master from the
+	 * arm_smmu_domain->devices to avoid races updating the same context
+	 * descriptor from arm_smmu_share_asid().
+	 */
+	if (master->cd_table.cdtab)
+		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	return 0;
+}
+
+static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_make_bypass_ste(&ste);
+	return arm_smmu_attach_dev_ste(dev, &ste);
+}
+
+static const struct iommu_domain_ops arm_smmu_identity_ops = {
+	.attach_dev = arm_smmu_attach_dev_identity,
+};
+
+static struct iommu_domain arm_smmu_identity_domain = {
+	.type = IOMMU_DOMAIN_IDENTITY,
+	.ops = &arm_smmu_identity_ops,
+};
+
 static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
@@ -3030,6 +3063,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.identity_domain	= &arm_smmu_identity_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6b63ea7dae72da..23baf117e7e4b5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -712,7 +712,6 @@ struct arm_smmu_master {
 enum arm_smmu_domain_stage {
 	ARM_SMMU_DOMAIN_S1 = 0,
 	ARM_SMMU_DOMAIN_S2,
-	ARM_SMMU_DOMAIN_BYPASS,
 };
 
 struct arm_smmu_domain {
-- 
2.43.2

