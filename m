Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694DD344DB1;
	Sat,  3 Oct 2026 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990643; cv=fail; b=IM5PksIqbMUibEz6YMu8F6UwF1u0EtJuz0y0qSum+k5slKBFoLzSPCRLB1gxXgUWDm4HT3E+DmZxB+oEqcATmHB6/ByW6FPr7ARFFK/yLqaJOA4GbFbjlXB6seqSoR+CqC1qA/S+foSvFtJmrKiq7B5PoeT+sgrfpjIKDClL9Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990643; c=relaxed/simple;
	bh=NGC7bTchnONBOCHzs53RfUoJpjROprcDBHbvuKVdvVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gW60SdRpchzcYcrdz9ehCRkR0sN6qtNE5Gx/ZoLan8TmahY4qms7nvP57YEMiw5t6oJFRH2nApLA1JpneXfExmm6G1E5xPkFTLh4lGv0s8WuXYTYEJ0teokSDbDCkUtyOckE3CmG5XJSiXuKSN2ujOhZROEWCjdg5UuD8+RhUYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VNMBeRbY; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VNMBeRbY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mp6oyr6TljlNAhDdBzQ0E7CajyibjaGms8DGKhd46llgfTYXkMQwt+bX2eFC2RQKqV2At8u2gFQbnD/9yAERe8BXbWkTqAJPQ+a8leW2/lJEARVEVp54t1REPXax/oy+dRDF16ay8I2BVaVC4MIJNk5VEPwvRMz5HS6MC8LA8oVgpfPihnDAR1gziW2++xzpOC+3ps/45+yyC8R1jkrjH9DEWlmhIfXt9+L/wA2gXLNzkFYFgLs0Rio0AaDb7MdIYqR4ZNChXSiz8LTrhKTt+5wTqcGYcbhHtWStfIoWsKpBvtYiHZzkSIK4Q5DTPug6bCV4qzGjng7+WJhu1mwqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0mv7n3kdWHjTmvD33w64LEsE1sTty4i5Iqi5cd+MNU=;
 b=XZUWgTp9Ed8fn53b7StQGugJLiS4GGA2VEJl+xI33JRyJYD83BuDw5SAQXq581qu1hYgHV1tMeAaeQbL6fqI2o5gvjCJezfYzTRHutUrf7sAGkSL3sZ8k/pmBMG0LS5X1n1ZeEq/lbdZL8EwxgEkAsQuV0IJTsMUeJMufP1bv+dfHG01SD7JSdChNDeEQQegBffNO9IAxJTejYu31OQeJllOThbDCscKILAIUO3jZRJLUBek4wwLwrrhvcBiLGzaSnMvFtRLd4+t1ifp1eXTU2It5yonz0iK/x3yY6hJpu15Nvz26qCfVSO8tgAtWVD9hS9/WmVabnHnUw+/xE5+4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0mv7n3kdWHjTmvD33w64LEsE1sTty4i5Iqi5cd+MNU=;
 b=VNMBeRbYvPas49Ie1fR5HiY5kJxWFPgNcAhDmTxqBJh6WJ80NSSDZJr6AvQFZHSfn/q1GmUFmXwDELexn2sH6hDor5kQsdUOpYznV+gq7KehD/xeH3ElSQT0CV7NGV/AjPHa8VGY+oJNMO0NXr/UrKVI+v9K13xUp36pa+4QQV3Mx39NW3U7Ia+nyMViz+X1qUn/yWIZ9IbmjxOc0NKKOEOP60fcYvRPcdQ4nAcERUseNrjo9BJb3d93grJFN5AgflJQy9zbmyZaKdb8heen253Je+8vCfiObfWH2z81PsiPzd2VZb4oyjg7T7G3iaOeeofYijvtsCg8wj0RoeAT3g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6615.namprd12.prod.outlook.com
 (2603:10b6:8:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Sat, 3 Oct
 2026 01:23:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v8 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Fri,  2 Oct 2026 22:23:26 -0300
Message-ID: <7-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::16) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a28435d-1247-4e32-7e3b-08df20ecf0a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	gOZKdXgZ8BmSW76eh57Jk6QqEj9VOwGhb61IJS+ngnPLqnUdRg8Nti1DkyhJIGFM6PEqUqtWGlmuWGAbYAn4GasJ89bG4veeXOtQmiWbQonbcoDcmxNJVSnZYFOWip+mriZXooYFhe2iXaQPSJtI7iA9j32/sTX/mlrc2ZN0oPkhehdoPGK1tMeQKJ8nOvHlTDJ+qP9568Nqeqb5NnTzaYk8gyFtrq6hFIijefaMg4CuHPsX6UAc6TO2yQYA/b6zpqX+gfZwxGVtAAbURFsC2H5FC9lzjeUxxo5zkFCrqlzk7p2eIVCE8PRCluP2vysGPFGpli2O3Z9F3Xmy+c0lN+YjWbAQv+/ysCUmI1Q/D/MpWG1kylGIn9SEp3rTDzLG/9mORflEk4WysfeZLIga5K0LECdnaqHl6Uf7lCN+pkgntW2jDrf3rSbWutOqDFmhll1l/OF7ipN8AYzZH4hib6sMELx+L6sSDoKiSyaVou110nty66gpYDQcoi1KKcAxNXtMkbv9Y8uS4/caIHS1h5AwxrpDaa6JegDiikFNjK/hmJSWwBIBZg61+GL5ErOFmTVtrp1yHN+YJXHBGiFwHnD2jZbxVwxORFDJv/A9pX8Lk3IrpEEv48TfUonoh8D0Kr1J2pwLIX54Cqv/hRhmtGJQtAWfSLPWnMXeY+qpaWC6f3xOJ7aagegfrNeQ7RuP6/NRZUq2i+fEukHYDAn67Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NOhlz7th0UIoiX7kiuX7exRMga/2vo/RzAZuHrhVPsCoUDbGkGsUE4jLfAe7?=
 =?us-ascii?Q?DrBqa5yKinvqluVwoWnHOVBkYb4Ls/ikJlzehENfTALCdRK84fZGPW0jR6fr?=
 =?us-ascii?Q?wAFKY+iUdfP6bmDk5TjgBPM5tLOaHQEFxd5Pi3voBTmJVapANduAZPdSLI7h?=
 =?us-ascii?Q?AaGaL7eZlFK87RMEldrOQQH5QYxeoiMSjIeUk4gjB4Ko+tEOpmLrI8QHJOjG?=
 =?us-ascii?Q?wrQpQ1t12AjTDXaWLZZYseKa6gJsdpVCFk3USLCU+xjUvLkgTBiU3PbFwDFb?=
 =?us-ascii?Q?LJXvzRJwW7uupHgzmBKq1WySI8E8k/hZI/+upZxqe9umq7BjllvDwpt0btlb?=
 =?us-ascii?Q?tSMZfwpVffDbFIpD5U0r4VdelPoTJijDPBrjg4raisWWjvCvTp5WqGegZVOZ?=
 =?us-ascii?Q?4wYtPw5XRO8af0JmevI4hBLfPltMHNuNTXalOcDo3/aJ2tY6g2Eu8km4Ka6i?=
 =?us-ascii?Q?CVdPsN9Pfg0GoBlGdrLXXrHcm6xRI0NxfsAvrFbAoKfwNMmtplrFIxtKmrU6?=
 =?us-ascii?Q?9Jttsw05fY+2gE6GWbYmFbj6ihuxl0iWH4bzPfXlUHDnIXjK7qgSntGi6RUV?=
 =?us-ascii?Q?II3pW2T1MDU6mi27TFTFRcUbL8BOe3EYFljmU0naKIPIbH92beKWrsm4nZhS?=
 =?us-ascii?Q?UggcTjSG+K2PRmtLmfTfxKKm12EBL5FKwPYdf339RAjBYcICKwa/cVS8waED?=
 =?us-ascii?Q?Zb6ZgLmXYbfLkZASfIMDvYcEj7bA99/LH2GWooAyGUjs9vzJ7oTO8vcrPssG?=
 =?us-ascii?Q?WZ6xRJkUcw5uhPOggv2oAHtSLX6nJFrm/nbnzLIDpZ4PMjI45Tg8A2DrRH3x?=
 =?us-ascii?Q?8kiL1UX8NZ8hQttdCeXYh4THpcidnq3uWi3RPl/ak7AxG41NBI85KOmZR3Bh?=
 =?us-ascii?Q?gtDzH8+cufILfvGlcV1+9fJ3LxafKaApo+w/OZIDmC94VdNn0gDU5k2WkhuR?=
 =?us-ascii?Q?YDB3BbUZXszTKgwjIyfX8oDgw8CAS/v01NaFBJ2mC8SG3SSWpNTwRUq13bPT?=
 =?us-ascii?Q?bq/B6UWuxGUiwTpsI56uFJtVM6dNMhqFM7K6J3lFKnenKDrIquwYvmo5BuAR?=
 =?us-ascii?Q?D0jeVFhjWZZaxNHKr17CHbbz/d5uzAnjnp4Xuj4l8Dwj5iCsMMilqP9x1pu6?=
 =?us-ascii?Q?VqIV9Kn1xcDicS5/853dE42rCwfxSZ7qfu6r/7DLCOjuQC3y5Wqx6qfpB9Ki?=
 =?us-ascii?Q?4lKzTuvD87ABGfQkkqQsXhF3q+oHxOOTVSkh07JTvLe+rIZyXS44/OCMvg6q?=
 =?us-ascii?Q?K2IGDAYxs9K8NZCeZdysTL6IFWpxHUgAomY8jMBF0qLtQsoeGWSeYZKUGLn5?=
 =?us-ascii?Q?XSgb5DUmdmlUHhyxOz0/bJu1SY3lJaX37XGi1VXkfU+xABSCJi7VFFktUMHT?=
 =?us-ascii?Q?8yjfHrQRjiCBl6VqGaH998XVs0v8hRBkiNrLTVaq3f0usSYu29NjSmelj0P1?=
 =?us-ascii?Q?8AeOSR2un0ULrA5L98fESe5fRq/Yg5O+3urr9h/tZIJyMHAH9QFEMzdX7r7M?=
 =?us-ascii?Q?0IGU8yGMGkdbOIJqYSET3FgWmV5WYurYAFEeX9Td/xvnmAIzCydyiTxXSIc9?=
 =?us-ascii?Q?FwVeGG99xb4Fj3LdREKgpxGcVX6VYYyI+Ux3zjLXYqIiaJW+bNzczTm89NpM?=
 =?us-ascii?Q?vQsHGgKIr2hVXmiHkrxqnbH1RvXll16LU/aUKnhNdcs0FTgbWGEfqKnB31U0?=
 =?us-ascii?Q?pv/6KkyTGrRngZPk75IC/tL2aQ36f7ZyGcYZEjDXW5t2n6ED?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a28435d-1247-4e32-7e3b-08df20ecf0a1
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:33.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSmLUECXgXRQgJ5k2o+wLmnGissokyLh50jR0yCKtPlA0oIXzQ3Lq/nC6HxDf81N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615

Each of these have their own unique situation, populate the tlbi right at
the top and pass it into arm_smmu_domain_inv_range(). They will diverge
further when the iommupt invalidation scheme is introduced.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 +++--
 3 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 2f76f649dcf1a5..faeec656da9e7f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,16 +140,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
-	size_t size;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = start,
+		/*
+		 * The mm_types defines vm_end as the first byte after the end
+		 * address, different from IOMMU subsystem using the last
+		 * address of an address range.
+		 */
+		.size = end - start,
+		.iopte_size = PAGE_SIZE,
+	};
 
-	/*
-	 * The mm_types defines vm_end as the first byte after the end address,
-	 * different from IOMMU subsystem using the last address of an address
-	 * range. So do a simple translation here by calculating size correctly.
-	 */
-	size = end - start;
-
-	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 26490d11767266..9724c58d2194d0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2823,25 +2823,19 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
 	}
 }
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf)
+/*
+ * Perform the invalidation with the parameters described by tlbi on everything
+ * caching for smmu_domain. tlbi is an on-stack structure that contains both the
+ * input description and working memory for this function it must be discarded
+ * after this returns.
+ */
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_tlbi tlbi = {
-		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = granule,
-		.leaf_only = leaf,
-	};
 	struct arm_smmu_invs *invs;
 
-	if (!size || size == SIZE_MAX) {
-		tlbi.single.use_full_inv = true;
-		tlbi.range.use_full_inv = true;
-	} else {
-		arm_smmu_tlbi_calc_single(&tlbi);
-	}
+	if (!tlbi->single.use_full_inv)
+		arm_smmu_tlbi_calc_single(tlbi);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2860,7 +2854,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 *
 	 *  [CPU0]                        | [CPU1]
 	 *  change IOPTE on new domain:   |
-	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs()
+	 *  arm_smmu_domain_tlbi() {      | arm_smmu_install_new_domain_invs()
 	 *    smp_mb(); // ensures IOPTE  | arm_smmu_install_ste_for_dev {
 	 *              // seen by SMMU   |   dma_wmb(); // ensures invs update
 	 *    // load the updated invs    |              // before updating STE
@@ -2879,9 +2873,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 * invalidated.
 	 */
 	if (invs->has_range_inv) {
-		if (!tlbi.range.use_full_inv) {
+		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
-				&tlbi,
+				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
 					invs->has_full_cont_range_inv);
 		}
@@ -2895,10 +2889,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 	}
 
 	rcu_read_unlock();
@@ -2914,12 +2908,23 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each single table level it wants to remove.
+ * size is the size of the table level and granule is the tg in bytes. This must
+ * clear the walk cache and any leaves within the range.
+ */
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = iova,
+		.size = size,
+		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+	};
 
-	arm_smmu_domain_inv_range(smmu_domain, iova, size, granule, false);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
@@ -4192,13 +4197,18 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.iova = gather->start,
+		.size = gather->end - gather->start + 1,
+		.iopte_size = gather->pgsize,
+		.leaf_only = true,
+	};
 
 	if (!gather->pgsize)
 		return;
 
-	arm_smmu_domain_inv_range(smmu_domain, gather->start,
-				  gather->end - gather->start + 1,
-				  gather->pgsize, true);
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 static phys_addr_t
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bc520698863e57..8e205ddd6bf67c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1204,14 +1204,19 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf);
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
+			  struct arm_smmu_domain *smmu_domain);
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
-				  false);
+	/* Prefilled for invalidate all */
+	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
+		.single.use_full_inv = true,
+		.range.use_full_inv = true,
+	};
+
+	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

