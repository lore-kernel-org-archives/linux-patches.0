Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA2128C2D0;
	Mon, 30 Jun 2025 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295851; cv=fail; b=caD8m52/QT4MohkafBhZrMeRit5A2Uv9DwkvWUpbuUznFCoPVKmysxUc9jRWE4r2P6a1fgwP/p6SVUOsZ64v+zIRYGnG/k1nqecH1WBS0DmC6XDNdWqApFuhUzeqQ/NCZMuiCQtE9fL/7DAaQjGiPSK7TbaPdTmhaewEokcMRaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295851; c=relaxed/simple;
	bh=LYtQu6dLhT2sOwJk80fulvjoD7mr7S2NXrHq5BJMMPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AoFrL4z5pWfJzhehRyaeWWiM2O2qH4N8zhCckfdmclxVHd7YH82SY18JAejoAN7TQE8et2hKLvGVf0SYbY3b2w3yrJdJF1Qotk36OcZ42Qi6eHvlZ2g0MBaXUdm9UF9C5Ib2ssjlQfh6ec61IQ3aLEpteyB1qa64/LLMFJJ7g0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OeK9Y03U; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OeK9Y03U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqQBqluYFs7pazu3XJo4pvlZJ/1/pMAT4MWxj+OkWszpcwLLfnXg0d4vMjrheKlp6YsIXfsV8wqo6GhNZgZCjwqJA1qjCp02iuNKMyyGPkWPT0rFXbyiBWDsd+EMYeI23bxaRjqgzisDuv3eN4oL1esXIjKrjxCgKi6yuX4EBuYY4ZLq7FCwhP7a1+NhSssKz2ISlsPaA41xDxktVQMy57pU9Iw5lL/p/mPJRI6xmqaUFEUQ39YgWk7k82QHaQ8C7Y9K+BTOKReTn0QWXOLwvZZpqygSCCIDHddSnvwPAly4soPByXvglh2sVVlBgcqeXSNiNogIsqPiMgw8cS2qyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lf6Wxqi5QCIv3PYoS1AKkfwEqDQu3EasnRD8gxrcF0=;
 b=WrIz1Hp4RtqBjFW02aK+0+2Bm2wjsP3GZjwteMA9AwZ204VjZb8yQ8aBPq5ApH+rgVeekMNGpILwbl0jZumCp/Qy5EUGzgM+GSocotV1vrVeNSTkBhk7WjgeX9rzhRIRIxPjoPiOe0WeU1eO2XHM+422f7w4sem6Ai/8LHtxD77CGX8PDrAgVZIUSSxJsKdpX6OhARUceOC1gxHsa3N/VcOdrdrbt5Bdoym5laeeK+5P6z5Kc87if8iuCUIhjWsF0OTCTvZPGgb8sBSPLc9AlZwUDX9opGpBqQbA0HXksHV8KlKqzWqtvBXOvffzbc4/2/p96QgFzBx2aT6AipsIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lf6Wxqi5QCIv3PYoS1AKkfwEqDQu3EasnRD8gxrcF0=;
 b=OeK9Y03UgkB98P1bNisEMetTMUOHKzC/TWK2ZYr189CZlabEZy+y196DTn5HSI4ZgbuvWYe068kAd9sslWM7uhyaeKpwzzmvjdA/Pf+Sr0X/hviieMVRoNZ84EfPfNO+TGEVE1Bgj6D0qmQc7uthv4848t6Ih4PihHHpqJ3J3gdEyyVqbPMe4F9nhbK/BX+DZvALQNZs8voYVHZuBqcgiG39hF8q/Yb/pN6JtGPSvaHICw06rsuT/iFOGZn8FXe7JbacIwAj9zxER/KYBSgUGp0yjd1II2YuyHeKOHksrpMWPGxljKIaVqfOH/Ajspegokeuo6zTbrNMopouyOssoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:03 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 2/7] iommu/vt-d: Fold domain_exit() into intel_iommu_domain_free()
Date: Mon, 30 Jun 2025 12:03:52 -0300
Message-ID: <2-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c832ed6-2dc0-4183-f32e-08ddb7e75947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4bbtZGcg/Hk0ruwwwPHJLikf2EaS0QZA5yQCKCT9S33mh3zOqhDBm1uufy01?=
 =?us-ascii?Q?DS5BHk5piq51YT4lUtLTulx/hpjmiVoPGxWieUnhETj5sTq+ydbXUcAAYZ/E?=
 =?us-ascii?Q?lNvXIeM1E0fXdUy2eztmcZx1w1fTs17xWxm0Kso+1sa0+xYXMax+S4psIAQr?=
 =?us-ascii?Q?59LNbOT+jpGXOJ2P4LykmbyRya+Nce2mMOtGTFnurE76akI05OGNT+hYtzmL?=
 =?us-ascii?Q?4rjpg+15i5uz8GHU1rT2H0f0+xh4NMulB29Z9bLrnWDqeYbVxXEx7wdZILly?=
 =?us-ascii?Q?Tgr8WQQ4wAqmV2PxMJTFMpJZXXgCag61yrsrsnhv74EuEWUCGZjpcQtzzrT5?=
 =?us-ascii?Q?FXSVVohOiVeIKF9sh6EmK4x9L1XRfUHdfasQaQJReEP13DeR2c8NU0wkFhY8?=
 =?us-ascii?Q?trzmCwGSqrA09Eu5lPRMqj94/2h3GcNYdvoGV3K5eqcIymg98IwlzRrD+0/M?=
 =?us-ascii?Q?muOBffZxs1hfP0Q3I4j9g80K3MtQJZZZr8EjlQ+bqz5jYWWoKBgAB9pFiUwy?=
 =?us-ascii?Q?a00sR5cz4Yrf2gQSsmL1tD/R3e6hrHY420vf7GyHyMc3/I1ctVwNaX2yXM5s?=
 =?us-ascii?Q?QbMVtrZwlBA1jw4QlPdFwXSzyr/BCucaKF2zmrBLCFbAihoBV9MABKFmyPaO?=
 =?us-ascii?Q?otHK2S46dPhNS9gwh8RNE4KxMVFpbLH0SgUtYBwicvHyREdbbVsbmAloDEz2?=
 =?us-ascii?Q?3EXPl90RMjKSovc2yqGkeKraCbb4AoJClQGCHtYxgHgsEp0Yyxs32CE6VRGA?=
 =?us-ascii?Q?3sl96V6mL2uvW9u1UIEU3mpd4LeBZ5TyrVnaufCfsFCEpntfeN/rDL5atL0A?=
 =?us-ascii?Q?AhLwFQA/qjx0+K2Sv0HDbTJv+jsb2yC/voypJqkTMngWGDjpqLSupC6CcG3b?=
 =?us-ascii?Q?UBfN/s+6tV3D8cbcr+MH8lHhjLzKsUt4wqwjwQaQdot/nEsHhT0U5kUn4ebg?=
 =?us-ascii?Q?4nilf1A092Kt5CKflTBYYO+wJ7gOdg4H4C+5fT3CKJlF9WjIjRXoeg1hmmgZ?=
 =?us-ascii?Q?V2l1oLIpfKUjC314AeDAU+nw9e+STMZLGAIQRGH2EDOJXybFAbOgxWtfTgvQ?=
 =?us-ascii?Q?JxZnVARgzNsbVDkO1JIv/z5UKAv9Ve6wugSB/1hBaNoZ2yqSolkD5fTPyL94?=
 =?us-ascii?Q?E84VEpXy2MUVdRnYcKThNx12amLpCBD4yhXE56arD3MkshxuajKubr4E8+Dg?=
 =?us-ascii?Q?N2OqTtVHNhNudEj4qca8GZDc9uGAJBgg5q+oO4nXc8Z/oMJHZRO2OGE0aXZD?=
 =?us-ascii?Q?EJxF/saLV/sMQxnJ19tm48QSbYpbb3XCDSwYRXOkFgw4FSTqdQti/01VCWSv?=
 =?us-ascii?Q?BEKHQ2lSg2C3HwPSJurM9jfzIXN6o7ZMdvei/8MuWX4xwszfE65gsR9cQXFF?=
 =?us-ascii?Q?c/g7G6jxcA9qgvkttgWZU7rIgdJ1Gu3I5rCtjPVvdWxHdEF/UniH/kAGf2IV?=
 =?us-ascii?Q?RVCD0QX+DyU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ph/ZQv5ceezWCYh4zTpv0GwlY64vvcSThtzApMN949BNB/oPY2MmWdmSjb6e?=
 =?us-ascii?Q?GIC4IchDGxR6kppJlDqcs569v8ih1A+Z8Zpj00+XpmL34fY+ZFOK4AjnxgYW?=
 =?us-ascii?Q?fyoYFw0B0IeNES8byQv6Vi7IXs2pBoetn0bAJAz4YFDvYVLFk1bJ9oH5bjCp?=
 =?us-ascii?Q?Z0FmmhGZ7EwPNIjYfKMsBDqFWpF58rsiXrhYhWFOTrcrKmR2QiNINyGMSVW+?=
 =?us-ascii?Q?2r33no3eOfaNHQeEa/JiIHhUG8ffuUXrkUsBr7MlM2NOKjuGkwI+ZJDumDdB?=
 =?us-ascii?Q?5j9Q8cDpA3jpR2J5SB3qMhH9PcdCs/3ZC/UYUIEozSlBsFlRgyc3KLaYneoB?=
 =?us-ascii?Q?P9QRbdizuQMKrOWZng3Ih3cxjXan8T5B+gN/WkrXPjNh6i/PBm6jj0XD3wiD?=
 =?us-ascii?Q?0JETRfaoWKedRbz4rX72NFDpo3WesOH3ZAjBl7dOwCzoct3D5YJAxTwlIWTC?=
 =?us-ascii?Q?++7eVSZ0y/qzYcU3z0kc1lBD5iET4fyuWMnJudCNoppHNy5HwH99IFU2vMmb?=
 =?us-ascii?Q?zlS9U3sD8c2FIUl8IUYjZXEsV4jbhAIedcd5eYyy5irAy9p8C3at7nga11mS?=
 =?us-ascii?Q?WBk9kzIrmemKZhGqOXjg3SLQCefDk2JMeh4poGGWxeK3lhfxQtVv7jmux8Av?=
 =?us-ascii?Q?jf5I7T/8OnbB32ZMBTjszbFmTED0tFl8xKiIoCH529hJcVGw10JqTlEL3+5l?=
 =?us-ascii?Q?G4jX/0wxu0oOJjAv1uMKxO+64xK1D+xsfZ7lQSqzQh8TAGirASol+CHlteyo?=
 =?us-ascii?Q?hG7Gp0/revaT4sMxY01Br0gi6M+lPwGQ8VGh+zAapLdj4qqPVewAs+PvhYes?=
 =?us-ascii?Q?oPOa3sM6SLyOKxzaro9JxpytA+4cmOLBnpCPYqomdqqTEdAmEjbPrnIffnh3?=
 =?us-ascii?Q?LaBpZ2Db7YS8dJ1rJe18QTGJvZm6S0HHCEP188ulyFVF5KfW/vtbDhkRmx4r?=
 =?us-ascii?Q?0Yu5tIJG2KHqQKyBVqmslS+cC6dxetvnz2/BH1ORLIifSajOHwJTYivR4AXH?=
 =?us-ascii?Q?8y+OS7n0bxreHXlOW728j5FM8ggZ8bVIMfIjRa9G35RF7Lv2z5ybZ2S88GnL?=
 =?us-ascii?Q?pcGx3gJ3GEtIG78DW2bhDqUCAdTWHSKHf6A7Bx97hW/158yPblmhMNLGrM/D?=
 =?us-ascii?Q?XFqi7xj4uBWeaVP8jQmfvB08xInyOpui2P06Ae1ONyqgoZr7FY0ajOFFePba?=
 =?us-ascii?Q?VgYgXbAvIGpQP+7ZGffCNn0m6VDNVPuSsojaO8bcVgxOn+fmBihfNWiOIgCH?=
 =?us-ascii?Q?TawEfIxheJDJE+r7sqt72wDYbmaDlGEPPXIJUuEVZtdr4aBTZgO1Tx2zGIjZ?=
 =?us-ascii?Q?tXb1xZEAo6vUFEtscuVfVtU8C06va0AZLmDE+JmFFEjRgZ+vZOP6EFRpOL/3?=
 =?us-ascii?Q?bGFEDVjOJZuL1kXJPm2+ReSgeiFHS/gY4uGn8/xm5ICElONPg3EK+nvYB5tI?=
 =?us-ascii?Q?yBPs21IMvSJVjtoumOwHm/QF/Ei+Pvv53J3SR/QGWEe7J/juV9ysdO1JqAUr?=
 =?us-ascii?Q?zUpxycC9m72QHGCX507fGRdI/BsZmctm0WhdUCtcl27kQ30o7KSPeQAW3jjg?=
 =?us-ascii?Q?3utHMWDEKnHuL2Tgb9wxUHbp0PZcn8CK2Xw+jcDx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c832ed6-2dc0-4183-f32e-08ddb7e75947
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:02.4024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhM111bf8dtKE7sn/hRXHYHnp/dyOAAC7okRgyg4xJIjyojn88qxpEYCRf2vH0Y8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

It has only one caller, no need for two functions.

Correct the WARN_ON() error handling to leak the entire page table if the
HW is still referencing it so we don't UAF during WARN_ON recovery.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 38 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b42bb091088ff5..7119f4be1b1393 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1396,23 +1396,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	}
 }
 
-static void domain_exit(struct dmar_domain *domain)
-{
-	if (domain->pgd) {
-		struct iommu_pages_list freelist =
-			IOMMU_PAGES_LIST_INIT(freelist);
-
-		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
-		iommu_put_pages_list(&freelist);
-	}
-
-	if (WARN_ON(!list_empty(&domain->devices)))
-		return;
-
-	kfree(domain->qi_batch);
-	kfree(domain);
-}
-
 /*
  * For kdump cases, old valid entries may be cached due to the
  * in-flight DMA and copied pgtable, but there is no unmapping
@@ -3392,9 +3375,24 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 
-	WARN_ON(dmar_domain->nested_parent &&
-		!list_empty(&dmar_domain->s1_domains));
-	domain_exit(dmar_domain);
+	if (WARN_ON(dmar_domain->nested_parent &&
+		!list_empty(&dmar_domain->s1_domains)))
+		return;
+
+	if (WARN_ON(!list_empty(&dmar_domain->devices)))
+		return;
+
+	if (dmar_domain->pgd) {
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
+
+		domain_unmap(dmar_domain, 0, DOMAIN_MAX_PFN(dmar_domain->gaw),
+			     &freelist);
+		iommu_put_pages_list(&freelist);
+	}
+
+	kfree(dmar_domain->qi_batch);
+	kfree(dmar_domain);
 }
 
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
-- 
2.43.0

