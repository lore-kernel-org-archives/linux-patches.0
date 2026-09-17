Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3E2318BB8;
	Thu, 17 Sep 2026 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604892; cv=fail; b=V81V8/TUDaXV9FTKJlmf+M/tFXAQvw98SOi7rtjy1SLhroBcEmwhTL7ItG54b+l0VVIT+y37BTgZWYu6ylrQDJNl0yWdlGI4sjjtZhlP/I/2dFHMgKOJV7BPmt6q32ARzsjlN2JIJx4Qt4X74MFj+7aHuHHvu74COYPrOBwK/r0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604892; c=relaxed/simple;
	bh=QfoB1UN5RRW8lfwJ42UAV89IFLiIDe5cEG85ASkifdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fez/MdSrWDR1dvlF9kLW5s5xTNXq96CGk3krnNt5n77NJjYKQr3F/H0a7U4OMSh6VYVl6UKieCgBu6J/5u7TT6Ji7Gzjsl9y3h/sLSg6xpVKkgQNYJ/I+LX6RnI31g/FbfzOM6aeXin739XtY84Mc/whZbiZhflU/UIGUKorHnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ae2FHdam; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ae2FHdam"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMqCyoaqzRw9e+LAEhSSvXr44srcrnzTgOXEz/hxrhXftTdYedCkY0/yfYgU17GcTbQXyVYXYTFy7kEKlsPuXXg/i/6orlbPLpOlB6UWjdX6vOrl/gKuawTA1nEPrUEcLxHsiVvuehjyhV5wbtuLHV8lpDU2BrXekLvfmvWDpqMMiXcaWRLAq/UhlSV0aknHtXRE646P29fhmhnFQ6TKZypM/KfkI8US+b/0hg8Jas868fe0lfDdLJ9YcwiJiICGNX18BAMtiK+33TftuOBAUJXwc6l8sOdCP/S3kGz1otANCuTWkWKe/xl8h25zsvNCTkYPpIdX/N4fV9Zf+KxfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRTKJBDzDhhmWDzqVEddplIUmqGD3+g4ggkzI9QyBW0=;
 b=E0uSzHt60Oouib/cA+JPZe35VxVzVttdL3DVsU9oD6RkN0NHYRVwgshO7PmebeKCrtWg6EzzoDvD/hZH5y13YcP1j8CSWnDxvwQwedE5VpOkNabeYAfS7sxrAFaAijGdDYQ/7HBeDt4uMHdS8skPKymmqzccB5V7uxmDOETb4N75Yuk+EFROke52x3oSJb5LNVBbCOPV+nyGZe6kjFDfRDsvmPgULiYVgU0dPT2rqhGABJ4DabijAdXpplQGb4NOwvf8peDMBoi54NZLsm0sLvG5Q+yX650KOVpixYl57K0h+knGBJbq3hCIR9MwGl+3s0uI1dsyAqfKwP4dPZ3TZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRTKJBDzDhhmWDzqVEddplIUmqGD3+g4ggkzI9QyBW0=;
 b=ae2FHdamOX2+sTpfm2tpdfQic44qEw8VRDQAlE7SAbjoR90X3o0ngGb1LKwiHgPU2AQOId4uzFmPWjaqq0rjpUL8sA8GVJV6YHKKxApFZPoPVUxWEJQ+BlHfJtRINFotG/FTKhmhuR6CnqNO4qsacNa/7XGDc+rgi15Lji0mqdHm2o7dnHe1KuUnPpWWO9WifN0P4I6ASVTmTpApQssW3hILiZvU40rOYx/9pSLPPZNBU3CRTQFSaN0UMvrpCvY6GDCHmxBONa4kI41dRHAaf9Fi1/nP3t7Iy2PiOT9HmrmIKukzuYO00eYjOKf8MaRmzADYkFwLubWxUMnMd+Sm+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:54 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:54 +0000
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
Subject: [PATCH v6 2/9] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Wed, 16 Sep 2026 21:27:43 -0300
Message-ID: <2-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::9) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 330ec0c1-6d58-4f53-0f79-08df145282aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|11063799006|10067099003|18002099003|56012099006|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	j0GT6XgfLmwQsFFsT2Z/AWc8b0p7G7vkcoybQ1CowyO7GTRfa5h1lJUG/gGaNGqz62qQC936XNKEetfPOJKrkTMmqCSchlWcza2hM3N7EscAFnWMp2A/RpTRPZ2pCCnBOtBskZft+9JkMkd/P6BsSpW1NuyVRP9SIC667okY5y4PdScE77IJg2h+VXnpH+Qq57Y8KKBPoTziNwOZyTBmwdwhNTV4MdHIkvFLLco/qqQxqAj++jIOS3vbGSginWVs69SckDAlgP9ii+8aABDhTNe/yAJD+lrF1kUK9xbAWLSsju/zuwbcmN/1ltDNC5pxASQ4/66PmVvZo00Zqfm66iY8N2nt5hAJcs29gvEqUXSlt1ESq4x2CKPEYCZDfPsaLhDJnM+hSEpgg7ch5E5P7iYkQmJSwg5OTrZHdyqeqLz8MEhoYmJOgZfP73KI2pvTBVr6W3Vsp+M2/bJZgdpJplnt3Tdc2SJwimuHfrKtkpUOhRFHaknMzavZjZ940ZHjfTt/g8KizZvTu+d3OdWqjNJo8f+qPt1DQuD6VSarnSAHbuK7LoDc4qv+lZCw81wOlKWN929hVh/YPeAaXwwdD1YmDktSf9ygIhStyCpdwU2n9GO6hmPuxwOK0PpdpvyiPwMeEw25LUzn3G2DKS8odJUnq1Rm8JdF1smeZPIrdTMzCZgUbCetrX7z3Cv+TGw12Fh6EADK2Ll272svW31ubg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(11063799006)(10067099003)(18002099003)(56012099006)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gd2rNGqMm2R67tTJ0ypiHLNsrEh8UaSxcuvqUG0Cp0mfEBohfrYvMOJRwI8M?=
 =?us-ascii?Q?+47wThp/fNVnoQ0cI9bmTc0mlqwcfJcyP4UX8xBeZkIhZ6onBhZS/0Rmhiu8?=
 =?us-ascii?Q?SVUPnSkQI/Ho3hlIRt0RbEFYKc5nAA6gbFTgMW3Ig5ysbeAkE5FI11UgMJAP?=
 =?us-ascii?Q?c7yM8KgJ7mrq6VfGa+XmSd3f5fJdwhG+9uefkw5RHzhQlgJcmCe8b1O/9H+G?=
 =?us-ascii?Q?Ml2WT5hh+/IzfrCfeyeSMGnh7BWtSNQzmN1ohIiufVz8AhJplOm2G6Ny0XI9?=
 =?us-ascii?Q?Qr57QeHM6FCeviEECho5muCEZMjchwOPCRsqi9ys7hXCZ9gT/yduE7Fpwbqq?=
 =?us-ascii?Q?aanLpGOUePCH0qPPiD2yduNv/TLs0HJDdyZ+8oQhEIkdFD6HQXpy9ncU/fhP?=
 =?us-ascii?Q?csnScG75UQKjqGP7ZM5srqB2K2UCgpODqqpGHBdfl+3teepH/RQO+x12QfKD?=
 =?us-ascii?Q?kQph88RkcAPhA5tvqFkCTgB7uoy1thXI3LbGb31baxD/LugbXkspV93FKOQP?=
 =?us-ascii?Q?/517H19J14GQ720NJdMEw8L24ArKnvLRpws6oAoG4kGokPQkBIJ+E8Wksrt8?=
 =?us-ascii?Q?kZu+3RZ1OxV5sle7WDdw/Vd6ok3OO4fn323zkLlajgXPCJTJugay/7V9HL8Z?=
 =?us-ascii?Q?uAz4ZJlpQApvtlGDWR4oJNIQ7Y+0icMjpK4AX4yK6LFailPd2WbSyEAfR42e?=
 =?us-ascii?Q?zJdMY7i5zXxX4HImeQ1NDtPh2XJ0M/c5XAfhF3O7QvZ6FXghbebLk7d4YuhT?=
 =?us-ascii?Q?HxZKL61hNkEKDPHSMIZ/600sfHqlHXNUZqChezg7LW93PMq0GhJSmVXWxJnY?=
 =?us-ascii?Q?NNbwtIBj3s6dANrinS1tTwZja8igTZ/lQIIO4crgAPxEEZmT5JH5tlqN5et7?=
 =?us-ascii?Q?MFonHg84yoi/ABt0z+hpCjEYgG9Cy0V3CBR7FEOiBa9CaBbjeAmFu4PgtU5i?=
 =?us-ascii?Q?GszbYV0yrJIPhr9TNitHGmYueWIWRkHgWVRkRKFvxavJ/KdZ5E6VcGEYnc3H?=
 =?us-ascii?Q?FouqlsaF9aQYkWY+i5Xm1yyBINo6liifDD3r17QhtLAL7tKzEW2DT/z+6js3?=
 =?us-ascii?Q?adn+d44SR145GBCfU8vwabU5p/thgR0/R71VAZGN2nd9Ob0qQK+toI8wE/zA?=
 =?us-ascii?Q?mm2O93YMB0wdZPuu/EUodxTs2fWhOgFw4QAQICh/kKhRht7Vg6kC7Eean/ks?=
 =?us-ascii?Q?T6XU//ZEANh6XGOjC+9440SEfH/SKuvsAf4E02poDKTf8mocDkwAKGx90b9u?=
 =?us-ascii?Q?JsAG1s1eCi1ylZTiwtZa8k03GAMhaRXe36VLprw2ntzuXItMM2lVYDThoHEY?=
 =?us-ascii?Q?ViOu/46Jxos6RZHGjUQVrIKuuxq6dyZ55Nf2o/+0RhJVwnHuHHjzdYA0WqW5?=
 =?us-ascii?Q?js7qh+aNjsO5J10IRveSMVBuT4oJZwqr7jm5jyLOMqD80qOgKn+wgY3FrSwF?=
 =?us-ascii?Q?5CQmxVMEKk17i5e0WXfqyInYXjF8Vhs7W0xJyXpDm8dB/pyOsMY3xSIYx6hB?=
 =?us-ascii?Q?ZYpaWqXoVoyJXCzbYfyOwGmT3u7zJ4gIt2i7mfpYsE1ykc/bAdvXCAzuhZRd?=
 =?us-ascii?Q?6QpwzLOb6ql1L6sQqW9QPDs+3POhICZhnivIRKJU/tFruHuzpoESttrtkRjK?=
 =?us-ascii?Q?z6bp6Hxp2Gq+/9Hk5xGkWyG/zMyyj8EncVd+0RwMj+OoTg9fY0YoHl/gqonY?=
 =?us-ascii?Q?BDux01xVXBbFP/rK25tLWaLcs/UaVcltKIOS6LhB34d/zqk4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330ec0c1-6d58-4f53-0f79-08df145282aa
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.3234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jh+EEJFpXLnki4Jryrpllz6pD6V3nGOoZskNo5WjdSOWtfiaHfSvXnXaqxeoFtkl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

These parameters go to a lot of different functions and the next
patches will add more. Put them into a struct to keep things tidy.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 90 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  9 +++
 2 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d6896e25b6632a..03723bb00de412 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2363,8 +2363,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2386,8 +2386,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2462,20 +2462,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd, bool leaf,
-					  unsigned long iova, size_t size,
-					  size_t granule, size_t pgsize)
+					  struct arm_smmu_cmd *cmd,
+					  struct arm_smmu_tlbi *tlbi,
+					  size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long end = iova + tlbi->size;
+	unsigned long num_pages = 0;
+	unsigned int tg = pgsize;
 	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
 	u8 ttl = 0, tg_enc = 0;
 
-	if (WARN_ON_ONCE(!size))
+	if (WARN_ON_ONCE(!tlbi->size))
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
+		num_pages = tlbi->size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		tg_enc = (tg - 10) / 2;
@@ -2488,8 +2491,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (tlbi->leaf_only)
+			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2528,7 +2531,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2568,13 +2571,13 @@ static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
 	return true;
 }
 
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
-				      size_t granule)
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
+				      struct arm_smmu_tlbi *tlbi)
 {
 	size_t max_tlbi_ops;
 
 	/* 0 size means invalidate all */
-	if (!size || size == SIZE_MAX)
+	if (!tlbi->size || tlbi->size == SIZE_MAX)
 		return true;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
@@ -2587,32 +2590,31 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 	 * invalidation feature, where there can be too many per-granule TLBIs,
 	 * resulting in a soft lockup.
 	 */
-	max_tlbi_ops = 1 << (ilog2(granule) - 3);
-	return size >= max_tlbi_ops * granule;
+	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
+	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
 }
 
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool single_ril, bool leaf,
-				       unsigned long iova, size_t size,
-				       unsigned int granule)
+				       struct arm_smmu_tlbi *tlbi)
 {
 	struct arm_smmu_cmd nsize_cmd;
 
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule))
+	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
 		goto full_inv;
 
-	if (single_ril && size > granule) {
-		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd, iova,
-						 size, inv->pgsize))
+	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
+	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
+		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd,
+						 tlbi->iova, tlbi->size,
+						 inv->pgsize))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf, iova, size,
-				      granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 	return;
 
 full_inv:
@@ -2637,10 +2639,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
-					unsigned long iova, size_t size,
-					unsigned int granule, bool single_ril,
-					bool leaf)
+static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
+					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2670,18 +2670,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
-						   leaf, iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
-						   leaf, iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
@@ -2692,7 +2690,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2723,10 +2721,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
 			       unsigned int granule, bool leaf)
 {
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_size = granule,
+		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
+		.leaf_only = leaf,
+	};
 	struct arm_smmu_invs *invs;
-	bool single_ril =
-		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2766,12 +2768,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_ril, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_ril, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ab54210a8ed999..c7d64156edbba2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -805,6 +805,15 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+struct arm_smmu_tlbi {
+	unsigned long iova;
+	size_t size;
+	/* page or block size of the leaf iopte */
+	unsigned int iopte_size;
+	bool has_cont;
+	bool leaf_only;
+};
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
-- 
2.43.0

