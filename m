Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210BF481A94;
	Tue,  1 Sep 2026 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285009; cv=fail; b=teow1+h15neVTGLg0srA/SIerECjCkEKYx3LZdM9bAaCYvAPpB8T8wEsrB+E18kIdBI8yHKWwZZGyafqsDyLfLIjVoHOQI6ktXwhrtbGAFyIEl65hOW1rLfIDAD13Fany7a+MUwr15egBBDaIfC+FwDY3B1k/gR0ZN04GEgRGmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285009; c=relaxed/simple;
	bh=u6lARTzpb8ZepzE64tOKawnJueq9jtsNCQ33iijOVZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HuQdzHT38v5MyBmGVZL4/vvDeBg4H7sVTLNcOZlFoQ+odJaWSMNHyxbn3M6nEGu32rQblUgRNqfAGwAJrilp4UU26GgURC69T0Xp0b4cMc2Y53pWgghfs/aafpqYQxDzs/qzGvpYS8XCLY5/a+FP1rp7VOaJDEIZ6c7ccOblYoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j62jUkR/; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j62jUkR/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/AqM+O4oVfRCAUCNEiUAAFdcF+ksTpQtAJdfyBh50CjVxN1DWrSN6spnqtGCChYfqk+ufb/wmfeNaYjVZ75XUhr4hSpLHDBJ1IsgdA/fINXo8CXPb6Wr4D5kvibYHOdSaOF/BYpP7xZWr4iBLbmzvuV6h6r0OTzBP4CUyz55dsDuGJcCWdI1G2VWlD/mLIR0eTknJwGGgIW0NaQ4Ih1OVmlYUrikMVGRyxzslar25PmhQ7a0txFgdqpU0NKQiacLkcCWSsDKuiCal/44ey/bEpFLjZ7YVSSlpKKBfHkA9K8eoIS3qB6pe8fWvfSp7Gx6JKk7Lo7kxn1519CeFwcZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95wkI2imOU3JhOMGENKRtM7ngr3S0ZR2Lkd7nJkvMAM=;
 b=BKxlf8AwON3GszTdGatwxHH7nfAz2GVKac0Av2HYz07QGJSoZFgwA7pKVuYKy3DfYvGbEtHSgbb6JdyVezTqdHCqPkVzLCVFm4k3ZM6tjL4lU8lf7bMcupXp0bXLZxVVZr/CmW6fI2BMhtH/QOqTkcAM2yygb/MOvF79c5EnnlRO09ThSc4kizAizI1uvKK988YnE90tBj5wRpMZvEKw+udiqI/RqKiqN8rJO7m4uFKWj01qKIqkhoRyE/0Xc1fOshZcumpwUL3n7glLeXrJOFKbOlVi01HhbUCJtNnHo7h3rgV/Dq0MWwjhnpAMlN7u3HLeZslouLNLDH+S4fOrTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95wkI2imOU3JhOMGENKRtM7ngr3S0ZR2Lkd7nJkvMAM=;
 b=j62jUkR/ieW/y8hVK/suxUPaB59zIJerVKWcHVVDIYy7XRJcde7oQhtlQ8CFK9sLmtF+4QVJqPp2c3DsXkKKkS+CXUpSUzg/n7I/JAT/oXVEDXFTCi2U+8Gf+F7pNFksqnZUC2UWIvSCH9JQgFQB/wmIvXkURtrhlwKsJSTgGLMiNh6AJ6f8955jrzDmDgNbvgiiZunMATcI/R8Myf47CplKwBNaXu2SQkbo9phZaneMfxiGVAye/XfH/yNBrPyfgCqc2Cnea9g6KKZ2HMap7a/RyFa8HAtUMVAiBsbVgTd5Kt3xJiw+MfHTbr+m2Ti04cLTVDPq60pidKmvstqS0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:00 +0000
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
Subject: [PATCH v5 2/9] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Tue,  1 Sep 2026 14:49:51 -0300
Message-ID: <2-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf43912-68e9-4098-2f4d-08df08517145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	esCKIPbRiTofJWODKCBLtGycQF2qcgs7yRV+OducHS5JpjT9GI8Tv2788a1r2Zk/mlRAiC153urNzFqucv/Ttjc3s2LsrCbaR987nqutihq4+TizaDNUM+lLqzeCz21lzdv0U9iVyKXDzqjUYFa6JpDVZxx0ilUAKAH+xNH7ETSlx66Ykb4FPGwmqTnVvfQOUE2GF8qe0Zrped0ARwBrlBgyMCXmNCQE8ChfqHkPpdN/qU7vMm6iErOer3zzmXbaczFxLymcvq7ZX6udJ/7SRSPGCHBxLGyUN7YpQMgUh+lZqTuUlo3ueGJ+9T0r4JPCV/WCJAcoJGS/PbcOxszk7O7VqHyUa5R8HbSbkznt6uqZtGPt5/TfXHNHc22vsewDoz60ET6jubiQzKTNitkt/sg27Kn4exUbIeikEoNDD2SIVpmK+LZWIMz93RoPr2NDHWKqGse+O4vY5pT2JO7MisqVpLciZOHp6bQ+uWawewwSNKoRYohsFRSuS24eoRRy7l3km9oJLSr1R05lvtu6sAU9XPX6qkmXjLl/OLqcqD68DpCVBliKsYdMHvrDGdTm1Q4VBJnULqVcepVRNYU7G6PhoUl3XHaT9smuY+UlJ3Pp97WoXCrRE2WPIYlmCR7xEqptImudOR4Eqgz4hOX2TQ5FsBNwSh+k8Lc9BR2XNDzDoKfINROoNlP0T1nH4/fVBFm/q/ET/wI6A3U89UUv2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YsPvVQZ04Xcz5uVB76vEPQOR76nauMwveEtCmv7DtZwi3N2MTs1lvs0/+xnr?=
 =?us-ascii?Q?UtB7HLFH/P0uRJ8wKt3rzlLvmZOxUoY+LNPknacyFJT6AL2PFTv6jDP0Vjl0?=
 =?us-ascii?Q?h6OZO/THFbgLmhdAcrFr45zIvrVjP7EQsq7KgBxzZSmIOg/FCMI441tqZzEg?=
 =?us-ascii?Q?r4FaOHrXjcsIVFj96LMOQa9ixCQhuwCXQA7VqWyPta9yRkJSU3ls3pdmfKdZ?=
 =?us-ascii?Q?hpOiaV0JSldnLyMnv1BI2w6hQrxSrUr4xhlTk3SoMOO2FvCUItYr8mweI5eD?=
 =?us-ascii?Q?bMOMwCzgOKeRpkEgtuIB/AWloB+BzmEOpnu1jVgzV3sGGbEGOCNQ5OR+vAFn?=
 =?us-ascii?Q?/LCrNogZn6PCOwbp70coHUsvgs+U8aXSAqnQkEfCT5wiAPzqepK+/s6nybb0?=
 =?us-ascii?Q?Xk17hRA7uG1YAXN+OG8VG5uu5S7ETKYGpEodn0CCafc9yl1nz7d+Q025EiDx?=
 =?us-ascii?Q?dnYWlxCr7eh6oNfjNs20txvLbL7Wkpx+fDL5eE0NbPvGoSSgGCeAoY/UOWoc?=
 =?us-ascii?Q?XCiaL0vLCQYTq+/u/WSbhli0sZljwZSl4NI6HFItNHtTH3H/M+Gc471u4hXR?=
 =?us-ascii?Q?ZExjd3Gulpp57QAwo9+vsZ4SBHCsSYkYT5YVL2otjUOKIBmnSPEpB2BS99uS?=
 =?us-ascii?Q?dHtMl2xpmn/5ZIHdW+4TL2HWjMyV3YPsB9ciMdj9ucKUvn7XKaPemIm0OVNU?=
 =?us-ascii?Q?poqclULS2gj+6au+2sEoUR2Anh8u/v8iMQSy/e7njVxDVRGJoclHw9Qu2tYH?=
 =?us-ascii?Q?R7cIzMPz3KAn8DZme6rkZ3sJTP9HSNqf40P64JR3n9yQfQ1ZmJYKb0tLKD4T?=
 =?us-ascii?Q?+WQEZ2jmquZmyii0VNC/qL/lg9B+HrYZntH5+p8BuJ4eaOxIA9IFWxyya3B/?=
 =?us-ascii?Q?NdxqfdTeqEkx/pOCm13tagBNptPdzMcgp3iRfsUZSGWRBT4192AbsoOjLKiQ?=
 =?us-ascii?Q?9yS5chho0Uzhn45yBMTxcFtjdUS48fNh5B68E/Ci27TQ5dqhopDJ3rQ2Yap6?=
 =?us-ascii?Q?+oXh9riGPX/OgVvtrlB4gdSyFNWyiEuT8T5qyiLTKm14+VQB+BT0RyxuEJo9?=
 =?us-ascii?Q?U+PcL95NHWXI8FtGyy4FtdYFHI5BnGzzUFz0Gi95py163B+iwFTkJxhCVch1?=
 =?us-ascii?Q?NeMiz1necgSbtWozTW9IUGeKyeDMDRJiRbFSU7xRs3x+ZeRnLjPKpcKcOMTy?=
 =?us-ascii?Q?0pkh13RFLK5bRb5quiltc6PtV5o2GUJNZNJkHuxlk86NlhhMe3ygu0Fe9Ju3?=
 =?us-ascii?Q?3ioXp4FFHgVD5m/A2cGi/4Bhexhe5p7eaoZGlFScHMWrFSNaYEohmv6dokyt?=
 =?us-ascii?Q?Lo964hmwxY30Ie/Hm1+KicwV9ag4kk7xKirZTaeU0LRxQC89pUw8lVQTWr26?=
 =?us-ascii?Q?CmKBYq7b9Yq+b6K1mN/I5vzvagl6icxkLigf8qqc+sUvdRdH5o34SfhJ1vrN?=
 =?us-ascii?Q?lBW+VL+oHpBzPffip6oB5EUPG642QtmOUba2IMdj+lVdX6sb/cP9OZ/RUF6q?=
 =?us-ascii?Q?IW4VUkvw64CMZ3G1zp3s5d0X+2P60qFijFCSSiOF9tX5cAXyEohXo0A4NXf/?=
 =?us-ascii?Q?kgAkHf7+SFcBalqM9GT9iQcSaihgPLF0+T92ToiYxnoGdHCCoV3heGGsQp2T?=
 =?us-ascii?Q?QfwCWypuRaL5Zzr6qKzHjGu4AXmy0wO+oenQ6exXvaA4s5hMpP87Ib/2uoHR?=
 =?us-ascii?Q?ffP1H0bBP3nNiHboYXojZtcYHh8WQW2SAdDo9J0WMNUC7e9c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf43912-68e9-4098-2f4d-08df08517145
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:49:59.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjWOjd8w7Bludn/dQGv1wv/S/NM/cZZvYWbCT2hGPGV/KB796ZGKL1Lfi3bnRvjI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

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
index 065d76eb148119..d3e81056f24afc 100644
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

