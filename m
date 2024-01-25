Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88A813BE84;
	Thu, 25 Jan 2024 23:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227074; cv=fail; b=lFxqYHjXUWXzyCcwbM5YLtLbOZXYiWUEgoBIQLNI4f2o3CGMCr/jHk7rUVnz16Lp0bOzbYDqcHJWReTqTv9+Rb8uQPgKlwqbLqtuIty/IkqCGN2skGGrwNhVEQ1z6fdt00tno1RUzJL43e0YJiZzhlDJq5cIrucgkprKHiIFDWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227074; c=relaxed/simple;
	bh=qH9RTHSmEAr1RnaFVQ4pInhe8SXGUSQqniDNqB8UTTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GxlmthZj1amLlj/Jye6LuAicBSkEhjHSYyWjpR3e6xT06ZwihuTHEPLYkg2Rq8T0tfcM4LuhWqtClGvrHeZ0qI9f2Us4RDsUX1fIOzJo1+2SxqE+CYTUUXZdpnUPGsiB12MNROHvLmrSqNckv9EJgt3x4lW9/sA/jvGwrHBW88A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KZJETX60; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KZJETX60"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiBEAbWON+hxNGSoGyO3okFTjHSqzWMv3oxu9yjEHNKDjXxlcCJG9YVyKsXnG1FmhbNwGHKchwXFRVDODvdhF5Ic0re7BgQ6xlrqknJjEgm/2mqb37o8i7JG/Ni8uYoeJwUGVHZtRlIc5X5Y0Te440X9maH5Ykx5TyGSJUUbEMG+UJQ5XHt33tmDvSy47ZGVtRkAka3Fa9YjDsrD5KM9qcLf6RpFPcA3ozUcI0vWW0VO9dyG+kHyBgCXRGCz7i7tjaMWSSJ3brlqJ4JF/MRjadJ1fYDM+odwLs8FeahzWs+gs6+5kUuZYW+M0GVf+n0JnuC97vb5yqXAS3arQ8vsBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ2IgqEfUbEeZpD7csML9M4hGZnxzGF+SCh2UJRQq+8=;
 b=NeOsxYUKv0TKV1vw9XIwi538kJ1ODu6u5MC3sKowej8xg8pwRbq+UsnXk4of+9N9sEL+rb5/aT8LkbVMLIUY3J4bQWPRnfGG31GSX+tBPbjF55QoMzWAEx/5cByHAvUU7GvbBTSIsyzO5b6RF5uxiyLDJ2EM0yyxBIlqq4mXyHXZ15hUUThZZ5yfWhWw/sAwfgNsy70iKmlBmEb6IQqvMPGpfEeUzmPD0xdVG/f+qFHbEIhJvpAMvrl9qGKguLbpn+0vqNm2DIiHLrlgKvi8BCIIczQiY9MgCgkZ3/vwZyZM46VABNRVHVr8l+pOzuIo7mn0GQBTojKjXZO6IopAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQ2IgqEfUbEeZpD7csML9M4hGZnxzGF+SCh2UJRQq+8=;
 b=KZJETX60Dy/tuiiJ9Rh7cx0iSkrLNdxgiNXVc152TCGpi0ZPxGni7b5+sS/XTlI640fRacnJuyqT3BTxFlEdoGt3aPx5Rg60uWqWprMN6ITqEQT2aCZSzqT4y5sRXzmWvNt+Rb5btBjjdZ5K7z5kOzomA35Rj+5pdDNOxOaoTv4CPBv66JNpqtNOddPnrXGYlIrnooBtV+chgPD/HeaPwO88sQO/oXwPlDxpMLV3Hqz4Ag8ehl/BFGlsyH8TIZ+YJVG45+2hAQTw5eqwxvM+jLIdH5/Jk+ElR4AC43wickXGayOEagyicvNYgnO0GsQEC9v56yCL9+buntetKufkcg==
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
Subject: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY domain
Date: Thu, 25 Jan 2024 19:57:22 -0400
Message-ID: <12-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0058.namprd11.prod.outlook.com
 (2603:10b6:806:d0::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d3396d-973b-4195-f9b6-08dc1e016508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f2YqaRm7vJ+nULFOARFMS6qJt0Lt9gSiHCfPZVEx/8/hg8Iy5eIP8/XOsxuZpPQznhJuQWKaYIpZDwb6BJDQVqOnC19VbeIdq6ouxHvQSUjWil0wcjjesfee5duocnbNKfDtXzdBNs0Q42bzgOlHkk4hHzEccaWIaQDhZdSTawI8ZfEgOYHEV3Tp29jaxRovvEY6RB2Q+07DQr9mpQspeHXFF+JCsPSl29OFwJjekJVTzcqerKGUdI/fsZJki6TGYVFjZblRO72n7S7ycJedXpYgrdLQnmI/sNyUaXBMWQ0T7N0qXg8ThgO4WQHgLrD9Kq9fok8UFd/7zPZ5S4cCFNneeXZpoAB7VdJQcVkmMEc8SYjvQe4qDqzwRegEmDfeIf0gLcuH6IOkH/4lTGoQ49G39/OQrZU/pgeq2IIMOlPf4MRcq6XZNTPLaaNn8CZEqmx9eHb5wKZiIrZTpxDLvlJOF/5ygtChLx5k8rwCMkJjf3M5hE7+5z6g0+JEmdq511OfCaUy236NI5tZwYnrEXaH5HoyIHSoieN3JdVHrcywbLqDKk4XYPGC1G/0aaI9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f7WS8pr/FyfSfJwYSniuOpbs9sKQkpBaNVibH6oOzbbrJEgdregHj6RkJNpb?=
 =?us-ascii?Q?0EAcsWIXHsEbpTaHonrWi1+e2dmgDhX6ex0bjrS4YUbLaHOrqDEdkWRwC/wu?=
 =?us-ascii?Q?zqfR612XmBiX2negQzS7fioKu2lhgO0HeXDEnzOTvGh1kD2ZuzqaOs+bA4PE?=
 =?us-ascii?Q?bCYjmHP509QCbpU4vw70zA6Xq7akd6xcRTNevD/MSm5Hqb55kX9/eQLe9QoM?=
 =?us-ascii?Q?5LhhCXT6S7aRLIF3MmBeME5ES60PSqjblAj+18QxI0DcUCddgM6HGNySbrYO?=
 =?us-ascii?Q?/eatQUBzTJpveBO/Mam2uLQv3gmVfKa/OH0kmWh1yl9bCe4p7lY+U7853xyj?=
 =?us-ascii?Q?iNNaQthv3Kc8OqvUt0ih4pF0pykylOCdKxRrzTBZ+0O7Qamy9O1mJ12c55fU?=
 =?us-ascii?Q?fx6V+8b3BzUeSsmfipm4EIFr2VedzuCEI8YOAsW+ltDujygKJlYlbrGwVEkN?=
 =?us-ascii?Q?9G51nwe2U43c7Sd1yJLRNG4WYtcoHIWr6j7uGa/xpQShHsbhf6PmKOPZe7cQ?=
 =?us-ascii?Q?lV6qhw9OBhzLPt67SUqXIe5w1R5+Y98KkvQ3zXMKAYVmq1c1FAzL/CcIQsOf?=
 =?us-ascii?Q?3HlQFl6L9f57ISkfBnc4KwaUUt5yCHJzYdmpUfIN6oR4UMwcBXaGf1tewRpM?=
 =?us-ascii?Q?GexVttDXM9AnDgy6tUQladcRa/wJo0SsYcZlNS+j8HccWM0DhR9M3oR6PG5V?=
 =?us-ascii?Q?SeDHCZCW/R6MY6CnkzUig1SVZyCp/WvEZI+Q3QVR8BcasdiAGxeWFeT3qvE0?=
 =?us-ascii?Q?wfItOn4zlNcumOqnaeWkkVld14CwFWSP9loKz/m/bChnwCLbv6gUfZyTl7YJ?=
 =?us-ascii?Q?Hkk9UTyyLZLgUAblxGn/sAHRGPplJju1GcehoBngtXto7+qsHcu8W4WlnMC1?=
 =?us-ascii?Q?MhXNAwVWQl9j9FfkjxIglRBaAtRRp1wQTvdf+ZCpnZNDmrshQMoFoIR9Snof?=
 =?us-ascii?Q?91Nb4EVAO4vxeHXGMqV/ooZ9YfT7I+EoeUHrCnUwlTXSZ/6aKkmU0TQZiagx?=
 =?us-ascii?Q?8F7I3wdixgoybhY22rvMUH//zUTSCfWZCP5jHzAk5isjnWuv8c8b1ww1vZzv?=
 =?us-ascii?Q?peZ76+hU9aizLwnoUsIgWpXvQsDOKVxtrMCNjSLRtK2ck71uhXLB2PZKZtZM?=
 =?us-ascii?Q?fRmoUSulK0oN9jm2o0kRvJZPOg1fKfqJM08URK7FATvqnibqdyntaxUMG374?=
 =?us-ascii?Q?pX/aJiWqw7d76IPPfXOicePovrpG81865CE5OcW96IVO5CC9cq0o1bG6PrQN?=
 =?us-ascii?Q?JffgccGVMF6gk5o3Wq1/ETdexvEntKOMYAItwL7Or109BjBkoUCotY9jLADq?=
 =?us-ascii?Q?Le46J1cXTYOAdu9j3ZlVDssovChvhX5ty/r2oQceLn83sYUpNTR9tupI4cX2?=
 =?us-ascii?Q?RzbfIzyBuhctAxSZPobu+nLf3pjFI9Mrqn8Bz8ikphnBtpSY9sY0Uxn019r4?=
 =?us-ascii?Q?mm3Oj9E5UEMSbGuh4EpCb3Hj3VB8mlIhiBRlvPamn2j8+51ZdF/RjgbrZULX?=
 =?us-ascii?Q?JxDDSexMuXBCPYBSXqIQm8yuPRyeNXRYaGNciA1AMWRuIfHjhqPc7IvYSN9S?=
 =?us-ascii?Q?di3G7hws5lYHLI0Mfozya7seEr5fMn1b2WZLKgFN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d3396d-973b-4195-f9b6-08dc1e016508
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:31.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlpQ317SNlf4jQqFrg3x580ueGvk7ZPzxSxuoppcSGVXij9hQsni0V/nmUDRcVhB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

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
index f08cfa9b90b3eb..d35bf9655c9b1b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2226,8 +2226,7 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
+	    type != IOMMU_DOMAIN_DMA)
 		return NULL;
 
 	/*
@@ -2335,11 +2334,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
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
@@ -2537,7 +2531,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain)
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
 		return;
 
 	smmu_domain = to_smmu_domain(domain);
@@ -2600,15 +2594,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
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
@@ -2645,13 +2631,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2667,6 +2646,60 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -3056,6 +3089,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
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
2.43.0

