Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CDB6D1BA;
	Tue,  5 Dec 2023 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bO+ODFD4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMrlOk8wLhMDb3C/5LPt4qxRDJr0DyDkrhbaH3tjrLn6qtnLsAAAYrRRL0YeC3trnWErYv09KpIqXpdHWnw2KT9Mn2KgVzRAZKKXrP3zUcOa/6q6gasXNOzlPyBRbqVaE6NIivPXLLbkSP7rXV3w6NH6UuO5fXJvszsqw66ls1rmljv3uELSy9laMQlgZZ7Bo1E10Vqqg55kxksGNYOHxQCC8h525yb8WLfHB7mKtAN/JSGbodP/Co4dbPyes2pNwe0RxIXGM66IfQ5qYk7da0sGtYoAS6/6HIrbR7+i1psncIlhwtI8EozRfEF0bBTmEvC/1tKPmKZB0W/b2iPUKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQERdPUsIWx6+TUpXLhG5WwgEbG0x7s28cYpuD/80IA=;
 b=K2X52WYATBmYlYN0AbUCh/b89mvjZ2sVzJbmUPJQYHS5QEN57xg2AoLoqhTh5O5HU2vNdLBbgE2wHRQOApFLhJF3AsFABWmforbG+biFmAe+HXQaTXYqT3H8eyOxw+YiRl1M6L79tDS8/UgGggcvInvfKeUHSP3ZH/9p1SK1v+4uZ7Y8rfwSD0imTfiaw5QtnkrNjd9SZZ9h7aFBC3UFsxtkJTdaPymx7hS+G/efa71aHMpGsmQyDx/0XSAG26OQjBnDmlgn5SXUVejs7er+BefO8F+xqBpwcAScuf061GQfMyAa8Pj9BDifOMXQzxwLf2o3PzQ2HYVQdL48LlN+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQERdPUsIWx6+TUpXLhG5WwgEbG0x7s28cYpuD/80IA=;
 b=bO+ODFD4Bh/LqFnee7CSl4p1bnk3Dtf7ZZLLrMtHrS55GV2sIMc0hDHsWZgb2rzBxA1Oij6+TlnOQyMtwGhW4jnyzdH3pHLlk5PkswtIRPkToDdCjsv/jc6aWOVu3YgzoE50VNnDcLTYgkI+aY1414KIyMEtGcPXXx/EbmEaQl2EjKW9mB4BRO7O8pkt95v89nSPSClmpsYculHrR1VgAB3f5mYuXOxZcSisAytOBzq6mavh4VdrDFV9CIDU5J7aKBg1/JHSc0jh7h7sYqfjSAe+yMIgSIIpGx9hT3mUg6VUDJ2neA9/SZLIPlWQQvsZvQUzE6wpShTcXzSLBEw+mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 15/19] iommu/arm-smmu-v3: Add a global static IDENTITY domain
Date: Tue,  5 Dec 2023 15:14:47 -0400
Message-ID: <15-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:208:32e::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: fc1138fa-8c2f-46d4-5057-08dbf5c67521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z/jxdFMyHpMyeG6sH0ALAw/Q4dtHkwnYFIpMbK6fRHLNXtL2S88lQFe0DzKpgCN+GcwpW6LxLUj/fx5pVnyaQpt8aNY6TVGHijDqoKGNMkSK9G3+/e1DunQ2EiYQN3+VO6vzTZJWLif0zY6hHDzJ0F0s4L1C3R0Wx2nsba7FxLLC7dlHqSa244lvEhQ93qmkZa6p/8hBuxcYJJlozo/EzYQsJK6xjXFr1fw0kLv7VFyMcIgAcMCT0F1SZpa0jZ4ILMiXs92lWvHSbL+g783VCu/bN6Kpj3SOj0vckY5aDBL++TBxXu62am9DKlEpM3SR83sz5LGX+LxNV1qEYEnImJOIrJosKYuypvxQ67Nway0uhpQjGIgAVI1r1oB0/us3sevnlbR4WAMwP8ROq/inwZJM8uaJCSg6Gzi9/4lsacG+t7HEuY9/ZtFGcEk5ACHQ5ov0rXpBoNdf+GHeq36QIvh2BrwdYjs4kp/bdT4W/Dplugv2tnhJw1ObJ1sabLNOjnPv5IscqRNDK3eNjwEOTTNk31EYv5C1TG4swDDjHtyp2K+q47pQRh93R2IFnk5n
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9EinjE74chJ8OkK79C2SMjR1uxSoilk1DYsyMv0iA67l6HkurkghN7Qpx2vZ?=
 =?us-ascii?Q?nPy3eqe6INjGOhmgWj4X49UHmPr+gllT9+vsjBMqWo5AOnma3BJ2IzsIcOTc?=
 =?us-ascii?Q?K3aB9fHXlX+PsBaaOE7Rh8Tbp7T6t+9OYhWnCXN9IHWqUJIaByVxgiH/Ob73?=
 =?us-ascii?Q?8RJ98jE4LtSlhVX7bzmfBy7KdIQ0TzaDBqYxNGsdnm6Cj/CdlQOZjGXdxkXS?=
 =?us-ascii?Q?feWO5ND+VjgWYtzktuXBP/fgf/K0HGgvWQqpkikq+vHTJKebyloe1Fze5DGa?=
 =?us-ascii?Q?Hs78cwhOy6H2tiR9KhV2wmeIcmfMaGEuKTlp31ASoM0qXRPhl8HxiQecoB65?=
 =?us-ascii?Q?P3AMCvfrSWJCypQ1vl/ZemQsYFQrVZGfb3DMQcQurnYXtTFmmj1Gysgq38rG?=
 =?us-ascii?Q?bhZU1uiT+YAhiD8CBo2k6yFUdnjNV8y+TzeT5HNiYXL2Lytj2BCaZa4UzjId?=
 =?us-ascii?Q?6RUYM93j6GW6aGdvuAAFrEUlm+9sgb4rudc2JKnKlbt6lFfs+OfaJG4BVVex?=
 =?us-ascii?Q?tOrazpKOUIM0XejxdyCTIcvtNqACdscoYuprai7m/SDj2eNkjNnAC2nijWaU?=
 =?us-ascii?Q?wgIESCB2LoklWnTO+uyMN+xiZbBSCO8+8q6W0SQPKPrR2eHQVs3WH19/jFWO?=
 =?us-ascii?Q?D4MojYOh5NVl+OXuIBiKvskbtRI+e6O/IgzzYrfA66W5MJwlfrU1TkDfg+Vs?=
 =?us-ascii?Q?ZHXO94JvN2sAjU9/GggSglOXnQvuwQLdF7Qa87Ht6aDaO7rUTNV3qMi6vLR2?=
 =?us-ascii?Q?gEX6/nY8tXsotGJCueNj5fZmPG8ZDmRWg1MBbosr90bAY9DCvJjvC0u1mxEI?=
 =?us-ascii?Q?0U7zBIcaW6hcBUccm7KKunWgdxxy0wVze9cfH2R4Hiv8S4mym9BVXuoMh4md?=
 =?us-ascii?Q?cai7TmYX7l7niE8DDYowD0WQAK3yVRFYZXThfUERuII6k4FNCwM32AjsRuEV?=
 =?us-ascii?Q?C8wDAXagGqfWPaftgj+qcUOJI01dBTX4g0P6oP2qMXODEjIDtFlQvgtgBfRZ?=
 =?us-ascii?Q?h4KF6nFVwxIKtb4ZGW405CGx7ockRYVgcl8FqtEgIXcwrYqy3IHqINqgXXV4?=
 =?us-ascii?Q?CoBteTZkiHn09aX00KD2vrxMeW8gBeNfubzLGSIvLeLcjlfMWp0gOM4KbfRT?=
 =?us-ascii?Q?AKc2NJqfMuTR1zGDBqb6xbTtb/3l1Gk2DXQ92R1y75qNrn5PWN2Qwb1YjZGL?=
 =?us-ascii?Q?TC4eh/UbSn8o5MZiEpBwlqLPNmSCi+AI7dYkqZZ1V9RsUJ/YM5Dr1PJZchht?=
 =?us-ascii?Q?fsuDKwROlEc+eiogPLBJmEt54/T9GFxaKVEUJuu20yu+dZmO3GBUIi0IfgSv?=
 =?us-ascii?Q?+8wcitK/JUlZNrZmUUH8IfLc0xPFyOQuZC6XTqJPz7czXwrYDlVrtjbLrm73?=
 =?us-ascii?Q?1AmIQdGwoEW67gCN0jrVPccRDQIswUBMhZnDNwPlLWxQbKZKjY50ef66y/of?=
 =?us-ascii?Q?YS98ZWgGFL+b1Hk53vpVfoLVR5kRxd1gIPilJ5L8pwHf0NuJn8E1trj8jkn8?=
 =?us-ascii?Q?G+Clup2mkJf/4svJ66RL+72nW7p3c1YMURhmw67rboIiuZbjnjChL+Ha6Jbv?=
 =?us-ascii?Q?REbIqaZXKLUsxUhD9d4n9h0wQUKR2f7r3hz4eWAr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1138fa-8c2f-46d4-5057-08dbf5c67521
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GE+ajxudAhjU3bIJNjsxlXvMJP2rMAbFoIfZAJiyncH+nC7wjkGY5wITeAQFiyY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Move to the new static global for identity domains. Move all the logic out
of arm_smmu_attach_dev into an identity only function.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 82 +++++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 525048a79e8a90..9899caeabc8744 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2173,8 +2173,7 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
+	    type != IOMMU_DOMAIN_DMA)
 		return NULL;
 
 	/*
@@ -2282,11 +2281,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
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
@@ -2484,7 +2478,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain)
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
 		return;
 
 	smmu_domain = to_smmu_domain(domain);
@@ -2547,15 +2541,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
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
@@ -2592,13 +2578,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2614,6 +2593,60 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -3007,6 +3040,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.identity_domain	= &arm_smmu_identity_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 21f2f73501019a..154808f96718df 100644
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

