Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB8648CD77;
	Tue,  1 Sep 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285021; cv=fail; b=MpMrX3rdPcm1iudwNzXLZW9ZtKnwpuE40WVsiB8ITDee2ZKezNdPmWIQmmsByq5O4vscyuMLjhjWQmBSe4IDn6FqVQ9qYtvXaYzwomOY69Ar8fIZ26eFnkCJt2wxG2yIVRJNGw0nbDUOp1f11LSYcPHeogSZFkq1Qo1q4Xo2Jz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285021; c=relaxed/simple;
	bh=5XwBndVA+H/quloRmuSmN3gSfK8AsrBV23qseIvqYdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BNbukQ3GDLxuZDcdriNZmdxE5aUmTL+Ou6f5IbAYbhLt+0+1Z6otmltQtactqOf/U1CLlIrTtzjNuAsdzYg9vIx8GKX8rR4TaoUbGnHWY9Hx4HfzMIvk8p9l00Zs0su6lGzaPFXhxYMHLl+SIvO/tuFaLNnf0jJdDwl4KPzkWOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ULVCPw2c; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ULVCPw2c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AGryZ4FJO5/5M+kd87u9UG2dgUv+XN7eUjfEiGX3X54qYoPiHT0YRQMnbguygIUIDHrQpNF4/m59rmN39FE1nICcgPGEpyPlxSxZT01E0L6TWpsXwISZ91LOJGM7yjxyPK6hKH4wx17vYkMVhvQrs9AIDzA/eXkMJ120KSiRDfSaUN/7RwWOr1mFbURkrKbUVxrAfHlXzRG+SsBrWEKJXzAgEyRJ77OUnnK42+IZOvSMx3k6xopOAQQk2bUSopNy8W7uqWXpQFbE2ahhYm3ZQoqvCUNfQnIFcLERVYbDZrFvSNBAB88KXOQxHaM5dt++8KSX9DhAnR2xkt68NF5Qtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk4fgT+EC9LSRrCnKpEK/NsJDK2QGmvhirVvF2UZAKg=;
 b=ONeVgirnF6x8Yz+fkY8Lv0D1fWnPQ1eUIAvOEonreBIuxCiqsGjXFqgUmMBk5TUR2T5XdK3AfBSd3Y4CIX0+B2S4FBx+7jB0+DAP1nvKWX6AaJF7jueLlSQOUKGEBv33yTRPI+SIGg3Q8sfVHoUVdAGLcYfnIqvU35KoJ7Fz9waQKtw6OtMDIwkkHzoHydu96DM1ZiqW1tCPr3NzSf3aL9aB5/UrQyBSfIw33d1NmzvsE01vDPveVIIiatXGGRsc3OIpK8LEUkuxIbvEugb/3gA1i4E+4/TNqAkD/Y/pmtGt4owK7il3QNm7lHcFq16iby1X8GhOTSOzFqlXTxppiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk4fgT+EC9LSRrCnKpEK/NsJDK2QGmvhirVvF2UZAKg=;
 b=ULVCPw2cEXQ+RWOX0I23vxXmvxA6yn/OXbBPQzAiyGGMrCb6+bGKnM2fiheGOONoy+b+r5TTg/RhBoNTxiD1Ks0xfcjm/RYOtzjVh9m+x5lN25XNzu0W4MYm3vbNuYQQOvYopKX5TKtG9CegEQEiXRI7GMMCe9AvzXxsSZXceeXXba6eVLkekWV+XWERqHgHAbJwy3sRdrO55ENVhvIObtgeIgNuRmYjdTTdPKbP++VkTva2dV/H/toq1lX+3VWGpoHb3p5UAxrIqGLHjD79FnLJxNnZhLjPTENVFm3r7qTtlgBNlYrejh0ilqOdnfUBX4wR1BbcXU7OZHcfUWaV9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:07 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:07 +0000
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
Subject: [PATCH v5 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Tue,  1 Sep 2026 14:49:56 -0300
Message-ID: <7-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0225.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: d78e49b1-2b3a-46d4-db0c-08df085172a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VII1+TgFsspKK7mxM1AqfvjS3fz7w4WGD2W9AI9UF2p+a5L+Ku/Z9qovg7kXL1BvW/Gyf9gA9mK8dWuEBTf8d6kwI/mpkeKSGQvoGQtJl6UfYj40qDk70Zeqtin3kJrn6w6OPtbFZ7muUXMxeIXh2auiMzvwscEHc45yFWDzDcg9/Y4mU+fNWtZ13D886DbEK+sZczVYdYqv66RtwXXGUnGW2SRE2zS5HtjceqEF0xmsXONJPpQrmqoPCkll3Np0c4/Xobc0NRd4CKlpa/nXW6008TocRD6Nvrk4F3pIPvNR/ol5ZNg/EehfL2wscsTTk/Mwz033ZzkQ+7TI9zkCf8wJnh1IUaCK3umT1M8FYFylprpRKULhzg+lB2DVzA9MS4o9AQ1Ht/oFhrO8CRKJcJCICwi/ojwpuNNe8KhvGPUcBKzH+VecGI2DONvkY+ew/BK3CmRJPL9oaprz1S4ItvZ2fzcoFcsWdszcGhP1m4DEQD8tlxuhFgBxW344D7DBEaSLVyEsi2gBVbQHoKP4P+ypalYT+zu7FuUi/VxGozJko6+PXCVrT5lvjqOb6MchvtE9auk+RoEN17IIu1sLrbQ1PIo6et2ZXamC6y5/zEMrEgJuaFhkbzVtUzDxpHMaJGVajOAbosdZ++q0oL8ZpwAZgcWLfKZR19/G4ss1xf1xmoqrN8wChSx7awb8FYiPNb7phhnHy41xDD6MWaYYBA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DB3q4BXD1iDTYZkPokSCWCTbyrLCDAVkgrAmQLCobqYua57h7xN+B+50bQFm?=
 =?us-ascii?Q?fz5QTcWaB/Ur+UfGHl8sUGlQYUJq8enlOTea/dd/vhRpFMSLE0z4O0FRvSmA?=
 =?us-ascii?Q?ZeUXpS+v67lLC+3SItN4Nl0E3x51kfvi5jnYbIKQEgOQQAoxJH/cC6Cpxz67?=
 =?us-ascii?Q?p+CXwximyfXJK0sqFH48CLj3ic5yNOl6C7lT84Er9AitOXSM8W5IWKuX4utQ?=
 =?us-ascii?Q?jI44hXt5IajItSRiofhkdgvYsRTL9DH6vjlV4964Mv+ArKsE9Cj4dHl5Liwv?=
 =?us-ascii?Q?wIjd7pt/aHirrauYb0yHk3u0Pf5tn2LJn3cnaFpyyQAxio0GPofLNou2ba5/?=
 =?us-ascii?Q?KkdzdQoAXNP+AxCd12S3scKyDxMORnvxx+99q50M3iDze0thW1IS1FPlQSv6?=
 =?us-ascii?Q?QpFwVYco9vBgKnLYhqUUWOFQ63rb2L4KyjwprRBKt4ykUr3uzi+EnuebowTs?=
 =?us-ascii?Q?7XSu7tE9nNStSLgutbfao0InJe2lxaD/x8SFU3vG/nK4iXGxSepMwFgTYUaK?=
 =?us-ascii?Q?XeHd5lkxsIMPmW/vPU79R+/dLm+knE8UlK87pwCqsy7RC2v0ivpi4vQyBmLw?=
 =?us-ascii?Q?wMi5tQrRh/lJxBGeNBJiOybEpsgILjwtxWz7ohIqKVD4z0GhAxCkGrO8hCgQ?=
 =?us-ascii?Q?gqPBlS9aMvSjVeAAjC3Ua15v/V/vJC5rFDoJ3nyv5kNXeYtsoweLE+wtO1pw?=
 =?us-ascii?Q?GJY7Drj1pSn3kSP215RaOVwv+2HzgMah5STF/r1R2Na01gv0sE3Q2MZXmz22?=
 =?us-ascii?Q?/+TdfoH1o9FvaSxzJlkuWuLBDmijbUuNXFNKZzDANoHpQwdXBpdwt7/ofWsY?=
 =?us-ascii?Q?3FEcpIE4+2fd2CK0qFm+mnHFhF4/tsPkJU/DtWo0P1QmAjBzf0E8mju99iRa?=
 =?us-ascii?Q?AhhJk9xUM/T3+k7ighyU7tAL8rIzH6Qs0qmP2Xn2Y0XKrFGsTSoyjpTcHFYH?=
 =?us-ascii?Q?MXX1pRDE1Qc2KW/AOIA5oWVxUOhiarrrLeRe6XVv381nak0CouStsYV034dc?=
 =?us-ascii?Q?JW3iRU4Byc+KCJOUsdSmEW/fZ/U0mexflKJkrHNKqDCefmahR7AgQ3Y181mv?=
 =?us-ascii?Q?vzKkgp9PiLQ0sL4Zh6YYruNF81o+t05ZrqGtAIqUBd5H2mfGZcvHl9q4ytNQ?=
 =?us-ascii?Q?5if/UsKd9nk6O9hPqyCR3G32q4sv7W0m8EfazLVCZwV4Q7+BbUjqdt3rJ/9M?=
 =?us-ascii?Q?Hen6vhbs1WTFR6IRhDoV71wkMknlvUztebQFLgvz0KXVEG1kZCk0CQ4oL6q8?=
 =?us-ascii?Q?TMP1hEN0he6WMzgk9jAhbE/z4GHQpN5yFtd9ZJqXnxlPq/U9/8yHx3+fLRyn?=
 =?us-ascii?Q?+oX3HXO/oM92M7/f4pWJGhEhTUWiwIG2YGGsnUjdwD6oHiqwVEQTjemd8LXi?=
 =?us-ascii?Q?Z5hT6KFG/wXl3hpOfKMF8iytvy2M6/h8fHn2er0TYNXqtoSZNfcgwdIvH7LN?=
 =?us-ascii?Q?D9c+YDVv4q4eVdBgLpV7wIIKeAJuTrmK8ehuWPJjLTh4iYTQ8hDo7ZznifAs?=
 =?us-ascii?Q?hmb9k9MGfravwzsOMk1yzco7yQKUj6G3IZkenFUHu8O+L/m2xLeAKC5tXiD4?=
 =?us-ascii?Q?XOxycQ6KfvKDzi6wQbFRj84bFwVU6Exi+JmLH6olLKiQGpfpwpId/Fv+2ilj?=
 =?us-ascii?Q?UsRKb08ZwsnHv8Ne/mlpkolVZreyac8Hr+EglVKZ2lTchai7inyCJ1vJFuyR?=
 =?us-ascii?Q?RNzMEJq1IZs4zWusb4D8B8v0C4vm1sryM57ShLFvoNn2h7qN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78e49b1-2b3a-46d4-db0c-08df085172a0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:02.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdzhcnRZVMJmjHt50jyp7EI9XZTgcdr7d3ByUBhR5sVDiwj7chMVyB8v40TPm5TH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

Each of these have their own unique situation, populate the tlbi right
at the top and pass it into arm_smmu_domain_inv_range(). They will
diverge further when the iommupt invalidation scheme is introduced.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 54 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 ++++--
 3 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7acb70d060ec4e..47eba08bd1161f 100644
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
index 883dfc584ed6c6..b9efba3404c68b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2789,25 +2789,13 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
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
@@ -2826,7 +2814,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 *
 	 *  [CPU0]                        | [CPU1]
 	 *  change IOPTE on new domain:   |
-	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs()
+	 *  arm_smmu_domain_tlbi() {      | arm_smmu_install_new_domain_invs()
 	 *    smp_mb(); // ensures IOPTE  | arm_smmu_install_ste_for_dev {
 	 *              // seen by SMMU   |   dma_wmb(); // ensures invs update
 	 *    // load the updated invs    |              // before updating STE
@@ -2844,9 +2832,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	 * this matches the instances used for invalidation.
 	 */
 	if (invs->has_range_inv) {
-		if (!tlbi.range.use_full_inv) {
+		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
-				&tlbi,
+				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
 					invs->has_full_cont_ril);
 		}
@@ -2860,10 +2848,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2879,12 +2867,23 @@ static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
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
@@ -4157,13 +4156,18 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
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
index 33ef99775aea87..09befe7b284fed 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1181,14 +1181,19 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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

