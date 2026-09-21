Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D6947ACF1;
	Mon, 21 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034940; cv=fail; b=Oj0S4TPRW0yCHDXprLY2ge5NIzbOMxj1Bwf2WAG9Tix76ss5vqaQC+QYd4iKMrL56YVam75KjlMwTu5Y2r/pMsmjkCw42H1JXMBEUd5NKOAtsN7yVJCyE+GcXyvtZZKJCmTEknFRoWDdQ8KD+faWIgkXcgVXntctMl3+Eb+mdSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034940; c=relaxed/simple;
	bh=oY6DNYSjY7L0WECb9Uup/WPvd8Lp39ZW6L9uHngLDfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dR1KsTDDdOdxQmuA84qt146QvLDXnkmzSM72GoUeo9ZtDf4xs7aCY6vGtm//sRiQOo1rBiM9MvUBXhMC9KnEdt8dJfMK/363ZM25/lHmD+jFK7kSLOgRkUuRfdOe7pX19DQGYR1/tDzAAGHOVRlkbLeFfBhGEUGpzQN24eMMu/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KT5RKKAV; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KT5RKKAV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPb4cfT5CFxpNVYnzgtoQ0n27XCek7rDrH0dlFBVqlhsKoXxpBuF2/R3tD5iT1w9HZ0vpB4Vg41g7LjKDJrdy6ZCzyOeiIdEaix+OcaWlJUjVav0o2OU81oIORAIqFZCtjK5iqml2m1+0gWRJKkkncmRyOMnKScfhBSrE2N0snESgFObAko5b7vlwwrQdv345W8QZi8IdAwsV+v3LDUrDExCEXm8EBoInLXp3eoxc4apTWjZqXTRpNe3DnMEPr0zvL4+NZrvhFL8OetqOW4y1ZoPA8cnxp6V3b3iGSEl69DJw/h9EMtYRewE/Le93hU/ZrZUmyT4kLOD3Qivm+Voqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2a3/JVfI+bt7xfz6mLnJYXi4O7wU+cP0ur5Bpum32v4=;
 b=BFcWpQ2U+IBJ5EJTRrQXc+uQjTIISolnouUz9o492BtANrUFp8/toDNyT76KtZBGFHICWzk+keDdADRgjJBQuJlQdyRbSPiF45FfE8w7hB6ZB/cjR2gxdvvGfZtnm1/5Dj7Gnett/ZJ3xHjRqdvMM6xtmMBihNJQq2Ye6OrsRjvkS0ARJp/J9YX0AMIC64O7DZeeRsjL0B6pd0IUP6VRBGAiaBJWWS0+X6Zpj1D1ozt9YD7QQ/gjj3C4Rvws9Eak0EMek3CvrIuVy5dyJkrk7QjtV2JsWJ0wld2D3eO3OaSjYkJhoIzfXCrPjVRrv+vHW1UnZzMP6eXkOWCsj1sgzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2a3/JVfI+bt7xfz6mLnJYXi4O7wU+cP0ur5Bpum32v4=;
 b=KT5RKKAVaNyELg6eBxSO+SIQDl3pNkYG9KN2q8lpeRsiWZeM6q2+GeflcQvj8UWXGAHPTuSEMTpb8GmL7ud81zN+XJcw/MsCKhDo9oVU7stbRZEr8ccVAnjIbNlOO8C4K5GpgnTwH0lJ17juaPbEuBVRC2g81weCr2/SAX6A3HZhnXj/ihRwUc/JiY4W1uFi2e1jB6HdQUQbwss7Wv4nAkvryAnAah9JEHUetj7q5gtyWdgcIK5YcrF6g2Lr7F9VHxRlvPfxYeYEg8uiwmx9tS9cImwEygYJGHnZ2VdHYsuN0UkpNXNZ10nbelzwC73adT3OaaVK5X3qw9za2JJdQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:23 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:23 +0000
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
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v7 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Mon, 21 Sep 2026 20:55:15 -0300
Message-ID: <7-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:806:130::19) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 5581ea30-25ec-4d5d-fa26-08df183bcb92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	36+aqqdoEj4KNJaZHMuPTyNJLBEQcezrydc4UgHLG47VXUX5u+ugOb1F3g4SsOGg3Uv0l6Z4Z6td8ub8NGn57NBcxUBbJxyMnspVkIS9cgRchmlkc4VUkSnv3laPDb9sTIC+XoUvATi6mE8rBZQX7WNWhjfI6CzuDBZWWvZ0qFAavKfMWntYut4f7k8ONqzG9esbEND69BM3c9xCoD8E3lf21mN/DnAX6wVrjJ6y+nlRKLYzOdKl/SpcfD7pv2EDn6GM/5g0pjscWhYTvR8919PWlx65g75+yrQVnsy8US7oo6c2ZXBN4wEJqGLwGbapi4Rq0REuXJ325q1UgwKXmhmbuZmbemedEcTIT6yxjA8AZX9F+JyyncpXrIyVcXusyGaKgD956nomrhHjEazfsE6UVUM70kkOtoHHcGf8iVNqnBCk8UOgTA+gY3qdU4kZEOe+MfBUMoSbgkScjRUGRxascV4IVDGpGjLvARGodzcGWBZ+kPDUkyizpfNYB/mZGiccF5R6Z/Y1u8C+purvHIMB3Bw7+ZVBMdByJLvmAIfrf4Cr2nsdnr67pTHw9YdsuuMQmd5DN1kFxST8L6sJgDU4L6fh3u8CxFpNK+rxFXVoPBiYzvjAwo7g5fV+AAm3Kbw4fv0j8/L0S0Krut7sc7Zdk4+QLLPP3CaXhge7iSkXNa+dYAZyam25QXmo14HedN/pZmqZnioV7dq8vH9BTg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QRKwWATCX4WKKtBN7MvvgyU+stF9UHTqOnTSfN92etCgJmPY6bLH21Ne3BQ8?=
 =?us-ascii?Q?VPAf3/60nHF310wtDrnrHtbJHUIJU3R0zQQmxLZOWkwYqjiDDej83ugAUYLA?=
 =?us-ascii?Q?nwDGdnrzlwbC/fNLmSPPN4ZjpNEiGwroMVDpDXzO0QVV2sYW/Cs3PntqsNg6?=
 =?us-ascii?Q?a9rue1hAsaFFmATRr7UlA/i0GuD9XaO6dsqhyWWdOEeSZTL+JOwGJe+raqTM?=
 =?us-ascii?Q?FdKtCH7qBy0oryMG4uDdC3aplL26pfdbI8X20fV1I3BwR6uICpMsWSbY960I?=
 =?us-ascii?Q?z1mcsjrT5MWP08bdEiqu6MU0Ui0vH6nDomhNvEpxIXdjnioh791edNGKG8Vg?=
 =?us-ascii?Q?Lw5DWU1Aly8S26HDRaFxk/suGZZRbJuaTuWRaVXD04peBJ6VgcvZZUWiUmSQ?=
 =?us-ascii?Q?o61cc1huy8kEbUaddthtNl22T2qeQG7JRhKJ/hL4idybjDcMfeQ3JblHm5ZH?=
 =?us-ascii?Q?O/h1NuKw4+Fxk0SvUm7XWb2z5OL5ae60LXbn65SAPf+EB5PZpntg46rCPX1X?=
 =?us-ascii?Q?gWDW1rWJXkqfZF4oeB6BrLhknHYLzaNxwj6xzitDCIJ5WTE7MNsakKGqCKR5?=
 =?us-ascii?Q?03Cysdh3vjHEKWAQ9X9bn2Qi8Q/0bec36QCsOkSDktxa2RFhEzcc9vo6QWvG?=
 =?us-ascii?Q?t4x2csydLAI6xhFvbYHbDV6lmMLJYLiRDKnshr566EAh/cYbaJn3sJrInMgE?=
 =?us-ascii?Q?xk1KdoUHXPwgXc2x19K8eGnI2K5SaRBAjcOpX60KCx+EycB3CrRBvzPi82/Y?=
 =?us-ascii?Q?dhDIepZN7aXJZF3fy8sST4m/cm4w3dLB1EClMhFuORf3HybCMRXlEiLTVY9b?=
 =?us-ascii?Q?xDmTzrmDXtRRvyS35pKM0/GDkbN/IIGLgHwxGnUCeF+CJ9HUBB8CW17jgXYi?=
 =?us-ascii?Q?6c1/ptCtpQWd6ch1GrY2vDKFI44QuWN49dLIkcyqnhqeQblKS/Y5yxiWudfD?=
 =?us-ascii?Q?lrdJZ1baPjnHpod/BYMUN0aguhEg+zIFNvbrlxCY/s+yTWClXin2YVrOdnCT?=
 =?us-ascii?Q?d3pNTxVomYsCdBjoVEL8JhsnHO83PSgflwWM+YWftJs4XLjRFSg6kSqrhXWf?=
 =?us-ascii?Q?v60naQo/IuOSJ8BIzOW26HBYZYdZq0PzAc42NzLVrKYEOb+Y0jPFaqinUNtC?=
 =?us-ascii?Q?eYzIJoqgh+7UFFWs8xiJCWl4j0Zm7MaKLMZZ4wa0gfrBd1z+Xl0xkqLVS83U?=
 =?us-ascii?Q?NYLzZy5I5DdCGyYQY8ZxIsn6WDqheyCnd4Z2QrZcIlWCdeKkE3n5CKb/B5mU?=
 =?us-ascii?Q?O+su+KEhED4R/qj7hSMUx5ZqcsZRYg8WhquXoQX/lgZnlDixenaQ+HqlWXto?=
 =?us-ascii?Q?Cg2f7gkwxuId7ic12xFeOcm3pu1yXkV/CUrwzmc4JrHT1lYFNCxiGyjHnARm?=
 =?us-ascii?Q?c/AhAkGnsBsAizlYtLvNr5aEzUSKdQvlCuv0CLLefHu4VzdFpjqCHdjBbpQV?=
 =?us-ascii?Q?105xA9ffixCXvOh49XYRclWIAF7LPoB+KFrmCYJfIR8UnXILSuSdZVhRNZAP?=
 =?us-ascii?Q?kvvqiYMVo1LaFDyF4oKj/oTynPQbKRW/FsxgIWqUEXONn3k/0zH113OrHnmb?=
 =?us-ascii?Q?8zNAEcNqzrOQOAQpftEUF061vZtP8wi/dLHVBlVtTqdOPGEORbBa+bWyXyQ3?=
 =?us-ascii?Q?BVOPwXteEYxPz2qYFQQoy4PHepu3C0t8QZTXv8hzjJP+wJvPN4ORn7X7hwC8?=
 =?us-ascii?Q?5HpTggIKozQsheQB3Fq9BgnHHlb0cDzDUoACFSN/5DxhAFQL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5581ea30-25ec-4d5d-fa26-08df183bcb92
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:20.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MA+sZCt2pa4Up7YwddPMelQ8b8s4aG+xqFrpm1GtPYs2GfryDo1/7OnblA3y6EhD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Each of these have their own unique situation, populate the tlbi right at
the top and pass it into arm_smmu_domain_inv_range(). They will diverge
further when the iommupt invalidation scheme is introduced.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 54 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 ++++--
 3 files changed, 51 insertions(+), 39 deletions(-)

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
index b7c9cd074924e4..4062ef2e13fe30 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2801,25 +2801,13 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
 	}
 }
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf)
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
@@ -2838,7 +2826,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 *
 	 *  [CPU0]                        | [CPU1]
 	 *  change IOPTE on new domain:   |
-	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs()
+	 *  arm_smmu_domain_tlbi() {      | arm_smmu_install_new_domain_invs()
 	 *    smp_mb(); // ensures IOPTE  | arm_smmu_install_ste_for_dev {
 	 *              // seen by SMMU   |   dma_wmb(); // ensures invs update
 	 *    // load the updated invs    |              // before updating STE
@@ -2857,9 +2845,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2873,10 +2861,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2892,12 +2880,23 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
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
@@ -4170,13 +4169,18 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
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
index a3f052cc191680..50fe7e99df898a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1198,14 +1198,19 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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

