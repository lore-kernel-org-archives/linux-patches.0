Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C22569796;
	Wed,  6 Dec 2023 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mhq0M7n7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QozAT6tOlwNm57TTQXEGaMTPN/b1uyj1Bn4nZxWyceSNZspXLJY3D257bDcOFaUWXKfmj4JyyqzieijaGb/OxkS+7JVHMsAxt5ClCBdssZmovg7ovkuz3aax8LjrY8t9C9dPbeMidwFnb83kNskGoRHKIGoSuO0OMgalZbJr8cdKgsO3nPWHrSct/A8eOIGGKmVUTTRCquWSC3rPzmSxls7xmku+lPKwDKETYqrCsqLl7cSiwm7pl2bdHBGdqrOA5q7jcgo5KSEfgCQ2YZrdGwOLWma6pNIe2ID8hwFqe7tF+LLC96r2Jp7o3LMWD8cGZnlMRbZmYSrBWHxN3VpKKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5kMJb17X3q2OlpYDtvCNFMDA85eXN62Bg/rYC505wY=;
 b=SmRb/crVntAPpFbSNntnV9BNfxFm1EacuNJNTRquoLFNwQ2XB7YJFbuDK82M5BjpQ6br1LRqg7sTTSXw0X7P3cdXPPomiCP592JXXM/9UbtyozU7bvyQH6Gl+yjPh5Za3WJjh92mkRSfOcV8IFZPmvoNgdD4fDfbJNmn9gXSJ81XxwFlJN194fjzXN9kzZ7HjKF7WTTxRpxLcV6FMr2n1bNu4wRCHaxf/bONMnEVG6XaO6YUOQ7qANG4kqPiJhhauBaWnPfjIL9PHHvoE4Wo48XG7APaL8AqXIZhcmKzFD2K9HZ0Zomic1myr2JsJ0QT9HLyrhnW7b9cAp+2JzWYdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5kMJb17X3q2OlpYDtvCNFMDA85eXN62Bg/rYC505wY=;
 b=mhq0M7n7cvL7NDIhO17WOuOz1GBnF7rto5qb8LNleJ7+Hl4J2T6ZqfM55pr66Ufym/DEI2PZag5Q5NcMnLijSE+uQxBFZMaLP2JcpPHzmRm/MV1lBJJTCYOctw/2rSyr5lAv0OLrVk02h34mYEnL+8mKUrTI0pHIZLHOe0o43bss2TzrXvq2UgnxvCdU+cp5SGkYFvgblPoyPpNag9H03hJXvkvzx0MXb9Eub9xrNPZfcQI6f4Dl0hHuf4R0Qpv0mfbaszUoae4IbcLJC02/yFM1BJ1Ru/Gm8TO2V9D6zq7UAfVtXBv8s4DBDWu3uoXX55/sXxo+79sysP8oN9Ymzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:39 +0000
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
Subject: [PATCH v3 17/27] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Wed,  6 Dec 2023 13:28:23 -0400
Message-ID: <17-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:208:238::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: fb920c62-906a-4634-830d-08dbf680c627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eflRoCAD1J/+uif1so+VSqd/sq6S+au2Dct0xCkr49IejP2iDG8li9Yzv3TL0y4lLXETbyog4PXeTuIcJVKFTm16v1NtT+u/KEjnfXh1liHwwBGFFyWwlY3lvyHXDwkIA7X/07NI5hoetyD4Zt94YK6jL57NFyt9VlGn9QBr17Tgh31mRkRqOxmNi5gjKKZYjNQdKQyaJYFfuW0liWKvgk61XtFe4D7K8+eo4FUfW5rLWYUOiwQQrmOea2VdrS2DCzAJT1UUgYdBw55EmoYWaQ/YLQB6H7VHMFQpxJm+8UBwdl10pzVGYLoX9ZUAkRnheh97HMXQxKXo+mcyvgQ4q8KmWLvX9Gn0HObLKf4Oj7vlj+1em00xLIH2a8yd8j9uOn/CkiMp5zhjSYM8QDYPNrr/3xl3/l9iFr4tvkqwjchFPgJ8dLs4IyzDzac25Dn06ANxw/49/DuZnH/DL8PJWbDzo2Czy9Im6uIKm2NWkcaljr8kQqFSGZblylBjmNMMJRq8/vkcZNj6s5wMW9cyWkysebM/DROCpZM7FgX+Cj7at+elz023LGbJCs9qsERn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oAivjkaDZmZMG6LEOBH/dtV6ZrFcnxvnRrUv3qWqfC2IGIl7aQ+WdC49DNjW?=
 =?us-ascii?Q?QunekGPpSBwImok9N+S2qze+yfWAVRqSdl1DypoE3qE0YJ/318+0hjZ2dRFn?=
 =?us-ascii?Q?cKDCwCkuyfVJI9reybPa7Myen4mR+21OMeUszF1KEsqmtHvCPhe0fovVpKc4?=
 =?us-ascii?Q?kbKZfPJZ6rWbbLt96CemeXcqZDX9CaJBPsNXDirXUesYZ9S1vWEcUwH8eGTi?=
 =?us-ascii?Q?yQOb+jJM1Dw+HmKPxlv/xjm/MMc4KclOML5yqAkD3JoUSOsi3PeBsmx0dyoQ?=
 =?us-ascii?Q?uMfrLYHgHWbfChi+7+M41MZ3eRu3fGNuBD49SjLJn1qIGGFGhOYrHndwBrFb?=
 =?us-ascii?Q?1P5tE4UAdCcnQi65IZzwm0Z1nFW1bJNPTzhklJwejAvV0+0uFeAuiIM1Zoxw?=
 =?us-ascii?Q?C6n11bkure3ItbdYg25b7te0reAe/2dXX5rT3Gaw9YS/cjhK6urdmAXHedP+?=
 =?us-ascii?Q?5OHOXGXIq0FbBDMWJQaAYI1/DyWkuJUUPr4HVNiV7CG6p2HwGbr5e1JQywKO?=
 =?us-ascii?Q?2C5H7hSXGWVlTzgFu41wIziryM1XA0Y0lnwf1TiU5Zh9wHBg+Aoc04y5Dgsl?=
 =?us-ascii?Q?D+mFCC6WEfWK1g0Ky+SxazuzdRX/nWfQYY/JlUdi3W0gJvLPHO5WYkHpCq7r?=
 =?us-ascii?Q?s1yk6TQBr/L1VoXI6J4QqM5HJQW9pwtaBuFxBA8XUHbLyd35iMZEqkm6a8jc?=
 =?us-ascii?Q?Hfk9rCAlDPrYbbRGUx2zVGjHDmE4Xa2cGF5kgn4sM9Fa8h2tp6a2zFHpkFY5?=
 =?us-ascii?Q?cR1Rrntf9fvXVBzwIrkNkxDFkZJ23inP8vxI+7n4lj01+6T3KAiju7y3nBV8?=
 =?us-ascii?Q?/guBvNIJ8cvDm73QnNG9voqIE44CaNyEzit8RF9dnZjytwxi2FipDCdaLeLn?=
 =?us-ascii?Q?AU9a919kL4VkzyvNCrXyl0jJzkH7+TZPaKP88RBjlCjdEiHV2bapPmSw8svX?=
 =?us-ascii?Q?cRQbZ9vJL5ZtNn3yh2N4tK4s2CaVJ341nCAvpcKLrpCi68P1/Y+BiwNkcDRu?=
 =?us-ascii?Q?akjb/+anV8bQOoBmYi0cqpR/QZ4usyue2R5/zAPXUuf6/OkRwlxpqPHW9jfG?=
 =?us-ascii?Q?eXttUAFfazQKgHYWGLqdefmrk89efp3qLUthS96MKwloyUeyHM1kg6jEIB9m?=
 =?us-ascii?Q?c0DAey97v7Y4mdTsH71DZfa8+O+HLGsDcv0L3QeKUfv3O4TNHepJOKmBG4V0?=
 =?us-ascii?Q?4hbjcdQvRQP0xQ6r+Fgr5v6gkTJpC+QcE9xVXiH/I11uOP8H/ibqbD5liuN3?=
 =?us-ascii?Q?xuhZgMqTURQVFGKJ3GU7N6nyA+KVLQdhzuz0soG9l8TADBxUGqkkeH1Y1yLd?=
 =?us-ascii?Q?8MLEL/1fRhDsk78pJCZ/RbUMuC/mJe1T+sYT5l0w/mFXVcAPbJ1xr51UJyRR?=
 =?us-ascii?Q?iSiuMIJWij2sEiegPYXgydTnkqz5un1k5IH5c/ukQqsPb8UsHeZ5ji9v0GCJ?=
 =?us-ascii?Q?HZmOGiGynCDG6//0EZmAJt58PwnKKEK7Sw0BPy2TNYyHBW3Be7583BMdItkj?=
 =?us-ascii?Q?Ua8S/QZHey4xiRcKT572UmPn8xnf2ZubbNj3K4EQY1SElaQS08QtUnFK8lWx?=
 =?us-ascii?Q?CDeA79/15N4H6MAuvdmCX0JRrk6P1A8ubYPDdrdW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb920c62-906a-4634-830d-08dbf680c627
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wevykx50v299wZUQmzOP36QcWrzyChrN010IBVOA6wsZzQ2QIuP/yTkecUhYooyU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 33 ++++++++++++---------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5f6ffd816aaee6..a6cd4699ddcc76 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1961,13 +1961,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
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
@@ -2452,7 +2453,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2523,7 +2524,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct arm_smmu_domain *smmu_domain)
+					  struct arm_smmu_domain *smmu_domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
@@ -2533,8 +2535,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2554,7 +2555,7 @@ struct attach_state {
  */
 static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 				   struct arm_smmu_domain *smmu_domain,
-				   struct attach_state *state)
+				   ioasid_t ssid, struct attach_state *state)
 {
 	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
@@ -2570,6 +2571,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 	if (!master_domain)
 		return -ENOMEM;
 	master_domain->master = master;
+	master_domain->ssid = ssid;
 
 	state->want_ats = arm_smmu_ats_supported(master);
 
@@ -2600,7 +2602,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
  * smmu_domain->devices list.
  */
 static void arm_smmu_attach_commit(struct arm_smmu_master *master,
-				   struct attach_state *state)
+				   ioasid_t ssid, struct attach_state *state)
 {
 	lockdep_assert_held(&arm_smmu_asid_lock);
 
@@ -2615,12 +2617,13 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		arm_smmu_atc_inv_master(master, ssid);
 	}
 
 	arm_smmu_remove_master_domain(
 		master,
-		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev)));
+		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev)),
+		ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2666,7 +2669,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	ret = arm_smmu_attach_prepare(master, smmu_domain, &state);
+	ret = arm_smmu_attach_prepare(master, smmu_domain, IOMMU_NO_PASID,
+				      &state);
 	if (ret) {
 		mutex_unlock(&arm_smmu_asid_lock);
 		return ret;
@@ -2692,7 +2696,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		break;
 	}
 
-	arm_smmu_attach_commit(master, &state);
+	arm_smmu_attach_commit(master, IOMMU_NO_PASID, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2757,8 +2761,9 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 
 	if (old_domain) {
 		if (master->ats_enabled)
-			arm_smmu_atc_inv_master(master);
-		arm_smmu_remove_master_domain(master, old_domain);
+			arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
+		arm_smmu_remove_master_domain(master, old_domain,
+					      IOMMU_NO_PASID);
 	}
 
 	master->ats_enabled = false;
-- 
2.43.0

