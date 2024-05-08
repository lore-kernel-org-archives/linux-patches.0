Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98BB12C81D;
	Wed,  8 May 2024 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194661; cv=fail; b=WmcdX4iLA573yWGnbeb204c5mrP7zOiUk2dghe6MU5yRWQ5PchNHYryVxTmKOSjbFvEaOhcHuMNXrZ2km5NviMUczZOl9bt0PVPHnL4SMS0zJI4YW2hx4MpYwNxpiWauq6rVmQShy9lx2d8CjWTyv0r3f5ZO4n724lYvmntojlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194661; c=relaxed/simple;
	bh=LNxRl5AjnEbHVjWN/222rn+fAtWlYHj0Iix69uf8px0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j6IGkAR8c9ovse5j3fzuU1tAvtbHC+mWgeHl1/ML4W4AMGN82NNfAfc8Rye2QClD4+xRHqJJmcUWrrWy4CBWYxoRMMsGQqPqaEbkID9WuvN7CSzATqKBj6/Gxsu8xryf2BD/+EGKMXB4vJScOCffxhj0wd4uCfIolkVIa+PCG1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DIUhOHHC; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DIUhOHHC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab82/+a8d8q66b2Re/8DdVfsz0g4bBR0B3jtCmS1Vv3CALQwmiAdKEv3iBqrhtrlfYt3gB6omjgModPx0INZ/R7mILqpC7Nh4jt7dat56WaWh8ljmoLB860HKQxFQ0FWZmkZ8/U9hxrnK3gFHdTx0fDoPQS7PMXiykPzT4gN/C0KXNxnep7ElWxjl3XrF1SpsOBEMwnwTJinQaXlK9/h5AQE5izNJdyCVDuz+2AFx7HsMVztOCtoNmlX+/OuPq5u+SRP8wJltZSH1mJIQSg8M+/5Wj1h6mLGh3vYYC8FNOPX+6kWnSaJ5aag9kKdTjJ1G+PoY6hWb2NGGRV1EGgU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5FTUpjpMSI/6olZMRtQP+S/FJoJlN0+xp6bzMXdtVY=;
 b=aA7oix9/0n2pupmXEcysk8t+xb2wGwoqJ021+UqDNZDstuhmPM75FllRo9JgGOzvJiyjkLfDR2DouISEMTTZlcTjhSPNeL9lVfZzosgHnGTM99sWbZGo4112++AZsnSQUICjviro+gtQXD/tMOJzoItvPWgbFko/FlVqdde9QV+nbcuMfDjxlvo8/jI+gE7z3X+JSVBoRBmSe81ZJqjN4wC8EKWqee99l04dXx7Rxf4SYjvEkpNmlH8Jz5FLZAFGzuW4ajxvr+Z4en2RM5hKaKOV9dkvHDf4+VVIleRMc0PSbLL7nypd8KaYdGORD6BsmhgVgXlPgMC2ClyEB6iCQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5FTUpjpMSI/6olZMRtQP+S/FJoJlN0+xp6bzMXdtVY=;
 b=DIUhOHHCZdz95xneCW4ItWMrFJocjVrAtFt04FxhxwEroydYyuOtEjQStBYregXUYBZMJjJqJ4nlXWGafnyqDZ19gLTCT8o6sVfqUqK1aFCOheOeJdhWJkNekaFbYsmhUkHmHz6a+08j3heqd7ZvQH8RuT1QYfWqjCTmxS7tZWLMgUvJkrdvir3O8C5oeAlApdQNRLHivdnphy0ehfEOZ/ONf1TLxhMwFR+5dYWG7eNXyB3EMskVVhw5/ZROI/i19Su5g67StlsiqhaONXZL45qsEoBUz7UOIAPGZt3NiK3yG/lBkUIj1h988x5Mqtov+TubiY36ZEUyAgIDutwsow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:27 +0000
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
Subject: [PATCH v7 08/14] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Wed,  8 May 2024 15:57:16 -0300
Message-ID: <8-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 634611c7-01d0-4abd-6c1d-08dc6f90b3f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Uz5wvK85S+6l9/rmHoTHagH3ps7faIS9Ifsc2HCPJzeXZ7WhCIHX6qkcCyLk?=
 =?us-ascii?Q?WOuGgxSWBUNibQHpzlEVo4OPQGGWAuesXnoPRd355GB6fxPs5dj3gx6qvWLD?=
 =?us-ascii?Q?7dt8DZInFTo9UIX7rCTaiHgPJggwAbGFgC6otoId7M+r8udYLf5mNry3jQLM?=
 =?us-ascii?Q?+XwwvSthAuMhDKFi2Nfl3p6cOLYhoyTcxQDGoumzBuaJsJVhw6r5AjF1O+bc?=
 =?us-ascii?Q?8AiWWRVjFLSim77LfjlGmMI+f7ixRVjigQERAoZ2IgAiKcXFEkCeWJeofytY?=
 =?us-ascii?Q?xPOWGLHpBXPG9J8KZwyxCf5yY1L0+5g1/GhlKhQBOdynRNWTdNz8rJAN0arx?=
 =?us-ascii?Q?l9mr+odP2OXUd6jALP8Ubnt/xanKJl3BTV4fKPPniurXLw6bVolQ42JCdkLr?=
 =?us-ascii?Q?XNjHRp040Ez7XJzHGejW7HnvOAaQD4DTg8BvxdxXQh5ltkGr5n7A3BW4ryZD?=
 =?us-ascii?Q?lW0bAvoRcIyaCOOAUKY1lQIob6ID0cmSByXX5nvW0x/Skn4v4LCCoVZtAEUC?=
 =?us-ascii?Q?FyF1DOdrCTy+lne2nNq05baL0AgTBCsu30Y74ZDxmpDGuD0zGSVPJ0LKOymc?=
 =?us-ascii?Q?jtRpN2mG2VTovp38EtX2ZnI+wa0i3PDJ6P4HLu0MoAamYwzxhw5JiJKNioQ0?=
 =?us-ascii?Q?waE8LRRv6birqsFH6B4MkjgmuzbNUa33Gt/+jmxX5XYRG8C9jHs8+XRmXnzh?=
 =?us-ascii?Q?D9NQFQJzj19eYQAQto/Pgn1UCxLh2HpclyNnguT+EjAw1tc5qV9t9ybMU9Bp?=
 =?us-ascii?Q?W1gt7++E67c/6ct7xl+yXKUZS6rvQooaIMx75RLdZlgXb85h5V0MWrp3y1TW?=
 =?us-ascii?Q?iKlvKlRU+2f8i5R62+S/5FCpSUDyTOyxwhR/r58A2czM+XzNtrTMPkUK6sND?=
 =?us-ascii?Q?UZ1O07n8VkDbXp6YB4riCO453GsrVLpJJPPpPCJ0Q7G7isI+x6r/cEl/WKxF?=
 =?us-ascii?Q?aq5+uhpOdldbsjEBOCABf45E63bMreuDAwVJduZVq27gP9u75gmqUcA7FhoI?=
 =?us-ascii?Q?OnvXhI5MZnYN8isGBdeWhwOXoSh/o5Ufcy6n9ZTyPoiIEG4bEq+4o8nCWop6?=
 =?us-ascii?Q?s0ecM2hpTvaRQqycOecBibsiMdsEK/cjE5nzcIzBLmx+f0GPRMQDZtrPrXWR?=
 =?us-ascii?Q?6z0yYNS9tgrb1P26oojwxCu+m09uhxfGNNE/+0/nLbDrcTBmEGMFp1m6TUXb?=
 =?us-ascii?Q?gupERmsy6H/9D+DCLSrmzKry90vUKSbNx5nJBfooDh4iCFVj0wn9lZIXZBuR?=
 =?us-ascii?Q?84KYsk3BVNQDAQgFXjpPU1yCfiAfiakdEekPDoM63Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CGVhfALsfECYrwLYImK+yrYRJG1zJHbd2zWDuVfjLdckBm7jeDAvXzWZb3Ax?=
 =?us-ascii?Q?yIdvUZf3FRxLWWExraf/16pHiAbsKbkgd08N3kod+Gcg6Pw2tta1gbK7cq8U?=
 =?us-ascii?Q?ahAItox9logOUab/QZEL2103QIQ6r4w1jTuDnRRa4huSb+Xt2lPZzT67qyw/?=
 =?us-ascii?Q?NLPGaddNIihKAL7pbVpbXYtCDYzP0Q5GdWCqtPFAVWEPffLrfc7VkJzxCf5f?=
 =?us-ascii?Q?UxqMU1jMsbhgsNNeP3ZmyuG70/Yhyru7JYCE7Ag1wZQkrnBDUN4Uf08M4YLr?=
 =?us-ascii?Q?am6Y3SpYrOxf4X17v4Z3MtorVeecFO/metyhybdTzqvM2dV3lmLMA4KidXRQ?=
 =?us-ascii?Q?HAo5w/ollLBmORTR7FJfF2WJSFHyTk3zHIsI/Rsu3Sx38QLmc14rAOZ9MSkx?=
 =?us-ascii?Q?cX8+MKt/i5Vues8bJmG7EbPkO2wHPtKWKdRBH/e0tCwks6I+UowAYKz9bBe4?=
 =?us-ascii?Q?1cjYAWfbSgEAdLrxst0+DLEsESYLI7NFsi67A0B+TpFBZMka58egysK+0inn?=
 =?us-ascii?Q?wXQTSlagQYcB8bh3wP6p9AqmPD7Q3Sm4UIRjTGo/kp5sUaC7IEuhTLmd3AD5?=
 =?us-ascii?Q?z8h4K4lapBZsCoC+qwflwMrDcZKQP1Xa7OtGewXDpADydpqeB10D8AXKy7CD?=
 =?us-ascii?Q?E0StpB0bIcyHF2arJPGYwh2tDz/678ht0WAXKJebJXdHa71iYy8dl4SarjJg?=
 =?us-ascii?Q?K45vdOQxaeg5JJgSoeICRSeWyZAhptz9wd/4/gsxXAanTjcN6Ac4K7PcVWYS?=
 =?us-ascii?Q?eu3btle7S167YKb/MDf3kR3pdhwONL2TPlN/snXBL4xcdsbKFRnvX+FkVpqY?=
 =?us-ascii?Q?O4wRcxFW6ApSu7gsZrvPABFWMJ7zGVIV85wSTcg3nIH4oAniJ5Jcth3UIbJT?=
 =?us-ascii?Q?zOMHznXokLo7EIo/KFOH8cpOGtLsOnVpzHavvSV9jDO96hCUlF5iEEQpKIXk?=
 =?us-ascii?Q?iCBFW7qeyauYCgwmeicqzu3qSfRmqu1x1rb6jBICkaHMcUWiVwYJcLKGN9Wg?=
 =?us-ascii?Q?+/ZhM4QwjiqYDCiwLPyLiVRUh9b5CWboF9p+yz1jU8pV8XD2fn1UeiPIedfw?=
 =?us-ascii?Q?Rn7vMMOTgADfRDfzwG5a+vKjOo+vEz7oB4mXIcbmgrGxSDiBOXvj8I3K6Qnz?=
 =?us-ascii?Q?oUMaasD4Fg+yJ8zKzWgj+nKQ13RJknXwxJP1c/klPdogeQmoVSCmoCAe8Rt6?=
 =?us-ascii?Q?jFavg0MmaRMsRjFUiRUH2Y1uJ2KCB3AF7hA2bdFHntRC2+hsHi5HJFF9GD5z?=
 =?us-ascii?Q?YBxpLbLwi+kxXooRFS7WEiw8fu7Hy1V+JEJpJZIH50qdfFnK3XECrHoen8M7?=
 =?us-ascii?Q?5j1k/+j3nY+fMoYbWsswA+yFT+Ao1i2wI9QrUCOpffMyY3X7T85ymhL627nW?=
 =?us-ascii?Q?Zd4V06HJ/qWMEOeXYbcvA0f7BSPNKiSapN0ypYFMj3mfVFIJ0YBqYz8u5OE3?=
 =?us-ascii?Q?BDbJGQIq8KfAAKTpaHk72zDQyDxFZAyoLL75Ks3+5Obbqu5PbPOitg7lQQTp?=
 =?us-ascii?Q?LYWhStjzsrsgoUbjOdRwTwhhK+2f4ZCLI/w+TEvt77Vsa0QSzwtkoLfH6qUL?=
 =?us-ascii?Q?vZrT1+axoAXAFXsLN5bIgsKoBsKR/aOBMwVgW6bL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634611c7-01d0-4abd-6c1d-08dc6f90b3f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:26.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPY7RUBypwjseqjR1u2BfmPCfu7fGcTbW6/UEDHeJyf8lCae9mnrWDv/CIhNiuMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 +++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 31 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7627cb53da55b9..39ba6766513457 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -639,7 +639,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
 	if (ret) {
 		list_del(&bond->list);
 		arm_smmu_mmu_notifier_put(bond->smmu_mn);
@@ -653,7 +653,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -664,13 +664,16 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
-	domain->type = IOMMU_DOMAIN_SVA;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
-	return domain;
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b2d8b7a1df343a..3011eb10763bee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2272,6 +2272,22 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
+	if (!smmu_domain)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&smmu_domain->init_mutex);
+	INIT_LIST_HEAD(&smmu_domain->devices);
+	spin_lock_init(&smmu_domain->devices_lock);
+	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+
+	return smmu_domain;
+}
+
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2281,14 +2297,9 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	 * We can't really do anything meaningful until we've added a
 	 * master.
 	 */
-	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
-	if (!smmu_domain)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_init(&smmu_domain->init_mutex);
-	INIT_LIST_HEAD(&smmu_domain->devices);
-	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
 
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -2303,7 +2314,7 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
@@ -3285,7 +3296,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.enable_nesting		= arm_smmu_enable_nesting,
-		.free			= arm_smmu_domain_free,
+		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e850b7913e67a1..a036610e50da14 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -790,6 +790,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
-- 
2.43.2

