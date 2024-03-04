Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BD37D090;
	Mon,  4 Mar 2024 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595870; cv=fail; b=A0uBY351ZWyfLfatBIws2DLUajyTXicgYzm2wc9IEcPgPGg5M0cjhBr+wwZ0ra+mlhyF0DkkbpPn7/KtpWwPDTSNKQHvrMPqFA29Azozxj4kpmXiLd7jiKKfQNIFAQb8lVPbNO4diOIuXMV9qWk2oiRbTQ7ANvz4hmT+K+V7efE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595870; c=relaxed/simple;
	bh=xVLbPFWcTr9cEL7LVO4rxN3mTtKgMnaiVfRrRm6cWVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IBxrKIvDhCSTCWeYccQZmlBlzgaw6PlqRxLOkpOUuVGuQ7SgMjn4Vew055vPU8p1otThcSvgYzeTFpUefM7Y1EHagW0Oz4+IrDllsuujulzF7ykF6o65uQpOGhPHewNPVvemWboXUqGaGdCeWGttNVz5A33e2slgSHEav3VJrkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s7/46qgt; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s7/46qgt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiFMBhiRwQhV1tDLKXbX7TPEFqwXqLWwN9msMKLx+VvxR0mOE1u22r1EGXiq2QB4JZJVgR+IYvCdTehsb+KkFWonCqtV5rCRue4CNUZsMRVY7e+aRCuDocok1SKrOty+wWpI/U4s37viWoYMx2b9RUPr54VKdz0KpKE7c5EK/sk9yQLST3fr4oJhA9dOjz8j9vjt5aTvz5auiR162fmg/BphlY5tdjfu2s7KDXDF6QwkJytL/8HQ94wxRWL+CJp+KUDHtTAH4BuvJmJcJ73Dcw0+C+tkhYTr0KuqmuolwUkKrmqtZehdNYjHVU972/V2NqLYyiv1auqTk52Es9eVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KT8IYuU52f4qGAa1A3msPHSerC9OZcGLL8OuHCnzI44=;
 b=f3i7Ogcjfp+vDqND/rY+JecJMHoMw6TgFnLYR3LKKTq92VIHH71jGnmtCJeUoSIm46XL5VutuRMgI1mBxSjzy41TYDmpPWdrg1EpIGjyi1sHTfXTIHbxZxWXvxEpVyJNGuO9jxIp9Bs15VQg6kGg2Xd7nO/v6rJ4uPYDa+ZV7dWYdGPqcnNQPv3RGQ7JYq50/BOf0lEd1sY0KTp4dAnEKU3ovxzTPDrLe2aAS7zDraK5vLvGjzZH4mza5ykx2KYkPDBssauXrqtB4WyXmYoZbXWzTIyKVbFLQbQi1Iy1jDoalyl6dsaH82N16uTteFCgmwvKtDN7ZPs9530KPrf0RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT8IYuU52f4qGAa1A3msPHSerC9OZcGLL8OuHCnzI44=;
 b=s7/46qgtzeuHStLY26fipRMUxU/pkB2E+o+PdsLu9n7U5qs7Zp6HcrIDJVWRSDIIibnZiemLybKKxDja/F8ps5Ix2ZtNymjiV0I3d2gKParkZrAOGe/soXFtsr0XVS1VBXyMCKdfbpXmAaWpy9FjBRWCi0rP0a2aZrL/NQNEZhgqhjMuDWpWN6rhH8ANilALiXwSG6+61QXc5s7SvJ6UMMrBVxMLM8/D/CE0KYhQTNfPeinINMgaVzGGdSgpcdxbzCwEkF87MMJbh8d4/pVtzcz2BncYnNKzPwEZBdUzL4D8wAHxq+Tpmivm6/pclwUzKbWI0xMd1wK6B2Od7UVJeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:23 +0000
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
Subject: [PATCH v5 17/27] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Mon,  4 Mar 2024 19:44:05 -0400
Message-ID: <17-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E08.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:5) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bcee81-fc0c-4a74-bb99-08dc3ca50177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QcGNTIBo4OvizonQfpWGP1TR0PDx7NQhqoSh/qY0pv/P501O0Q4JT9UR/cTpUIoHuLfcRmvu04uvFIVcoN1WFQNlS1ZTEm3+KxXjFQ5By1o/rnzLmdP71Dfor/mA9Y3LAV2QBGkUL0o0Yo9n738tdzOLcgAwyYgcQI5vWg3sXZ9GOdaFqz9LZV7xQzTMJSvGTaAyvfwAvVaSIF3HorOExLj3oiuGsrtm5c0xTwdFx8IIKrCl/FYvjuVHLNx2PLrqBFJaIx1bzpam1RqllrTo0rnrvkInzlbbVqHxDNgl233caDrlpzPAlzuoMiGgwCaOuQPa6muYtT3nxkY77cqJZPMuDdlQ0HQ4ZtsNCPMpbf2RTc1tTOzNN7emmfeG4ZCLiHqCx3HawqprLL1y9RiFJQ3OYH+R9Fui8y3/QXdVg3gqxDULhxyZrHIjEhCTbvlZfMteSQU4AVWMQM8NicjKXwgzNKumnTwW5sUmypKB8zijh10lucTxovaQm1vykHX5gVOxCJB/blaxBPZi+iGgnA8RovwxcBPJhP57yFh0yCA7P1H20yHiPHInM6X4o2xRji9IFfecrWozZRUq46WUBOmT2Awsg0bET1W1FntER4c58c0R84bAJR9hhpEeViwdc41VVGPRqOmhwhhcuJbAig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EksRkNLaz72fR8k2teOQqERL6IhFejauiG98ItI4OexqUD5mdqTr2YNHpXZG?=
 =?us-ascii?Q?XlX8F3KtuMFwJrU3AKtagMTdjzFnkyfqnhsfqec/qDgj5ZzpzogkrOg4dzz6?=
 =?us-ascii?Q?lme9b/UEXFncmtlyWbWMdYSPY/zknGjO/MpO7JwFGxfjI9i2aF4c2YiUL5Bn?=
 =?us-ascii?Q?pC5dGENXWz7sjYdHq67VzzKlMRhDdsTlOIyzn7vXiD5VWEYcjJXJtNwfLPq6?=
 =?us-ascii?Q?X++cDqnXwWFWnB0uFFblu8WWvlZlTTU4g+3fY+nKsqR0V8mHOQ9kRguYdYyq?=
 =?us-ascii?Q?fX1goC5pCDCxJqzoki+8mp47R59FFzEDmsIahTcp+bX0aUWpFcoW3gK6O+Z4?=
 =?us-ascii?Q?DWmnLTRJYVGfyi/O+pBu7S1k6XxAQTHRHvXGGUknmf5fESVXhLpOvSZ3IuHF?=
 =?us-ascii?Q?w07A+uwbYjhpH/gcjW60YhNcUzvfk18p4EEBz08x+jeFCYQLl0iqoolCssse?=
 =?us-ascii?Q?JgHQO4tYjqKfp+0Os9lqTuETiU2dEb5psVQXYr9iOPRTXUux8+p6VK52XtP6?=
 =?us-ascii?Q?w1jbRto5AgLg4H8Mn20qcZhsLPwS374NswgPVK6M8gHv5Ckr+oal9Frg2/Yl?=
 =?us-ascii?Q?Pnzrf20jOaNaZ3TxITJRTev4m/Jue8upqPpbF3L3/kn2gbtF0TujaQSAe6n6?=
 =?us-ascii?Q?zhA3rfHf6pZ7yprm4/cHdBeBQPHy2Dd/VAuNYBeK6bnTM8xIpyuU3X5rCEzG?=
 =?us-ascii?Q?u19n8ZTQneGd+XM8KRWV6SnuW0XJb9F7/48L3rAu6pzpjO4swCgFUx/5cY8s?=
 =?us-ascii?Q?hCNxNpv9m2YVR1aylyOjwfR1vzf5WTv/HKXhWJqb/ZxTqOvjHejJbgwcWIX1?=
 =?us-ascii?Q?5/OkaOFFt4/DvuBvFy15edzor+sdjTEjdmsvrknpF563/ICd2pyaHdUMpmoa?=
 =?us-ascii?Q?wPiWZAa2ca+vHU1k6FaVQYtfaHT1Zfq/bStuDcYqa7VYjctkp05e0v3i+0nM?=
 =?us-ascii?Q?6ckjY1qiiZv4QtzqVgQCC3OBb22CaKpolgwpoWuXz7gaMXAXQD7q331Uq+F2?=
 =?us-ascii?Q?vbLpWciWZtTHDf0l1NDQHgnTnB9mE7RdVwsTYdIUARHh9Y7EAdOu/60oGVLX?=
 =?us-ascii?Q?5tYXL/Gk6fjjWjnmP3v2/zgOjd+sF2xT/N5Mkvog76TRDRSJeLXP8tUFJOTO?=
 =?us-ascii?Q?xx9el3PasMPe3n8U80znJgcPXOGWZ8CsB2rjhmysZFK2Dy/u2/Z+0twlGl9F?=
 =?us-ascii?Q?UCfqsH4T2YbPGO0fZsm+jWVXdC0Y7K2jS62QI8PrqjW5pqmD0VXJ2B9fPnby?=
 =?us-ascii?Q?9YqHImGRTMNZUn0UApUjm/0UjlMXkql4oMghsKlAb/WRultD3QOtOedGX2P0?=
 =?us-ascii?Q?ep4FzKJRELz+pUC07HfMQCKkLteQBGk2MnHDipn9WrGvEsFlxnuT1WgPHPSZ?=
 =?us-ascii?Q?p/QV+tccatNmHlnPTxIBGF5KjUqIcM+X/QOuhZExg11QOOG8F6GCVMWJflPs?=
 =?us-ascii?Q?R3EA45oyyX40+0PEu0xjbtZnCcgyMygmzAePOg+5c2bLuATfABtm189XTT9f?=
 =?us-ascii?Q?jVzBgJjAZAfsTWrmNAmMLHh+mSok2ONg75wynGiiTkS4GqGzGkxPB1KG//FY?=
 =?us-ascii?Q?IVlh6lzoxKsCbIxMe7Q2BgAvi5G7C1UQ2y7jzNrt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bcee81-fc0c-4a74-bb99-08dc3ca50177
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbIF1Py1Muol3I6nvLzB7R9tgPNpkVNeKZHMPmT19ESWKt2bzHPPVA0XGf+YOhxU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 28 +++++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fc19585bf192c6..dd7f841cd19b3c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2024,13 +2024,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2517,7 +2518,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2604,7 +2605,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2614,8 +2616,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2628,6 +2629,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 struct attach_state {
 	bool want_ats;
 	bool disable_ats;
+	ioasid_t ssid;
 };
 
 /*
@@ -2659,6 +2661,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2711,12 +2714,15 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		if (state->want_ats)
+			arm_smmu_atc_inv_master(master, state->ssid);
+		else
+			arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->want_ats;
 
-	arm_smmu_remove_master_domain(master,
-				      iommu_get_domain_for_dev(master->dev));
+	arm_smmu_remove_master_domain(
+		master, iommu_get_domain_for_dev(master->dev), state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2726,7 +2732,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct attach_state state = {};
+	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2825,7 +2831,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct attach_state state = {};
+	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
-- 
2.43.2

