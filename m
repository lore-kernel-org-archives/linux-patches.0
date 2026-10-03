Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52943325726;
	Sat,  3 Oct 2026 01:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990652; cv=fail; b=QPrtLosh01MSN2E/SjKNaHnnzai+5d/VBAwhRpJPtrB+IULKL6qQh49tgRAFRKxm2corpVZ+y0LamiCbtaBfKNzuJ2OyDNZD2+uDJYy8GM1POJFTWzJRIi7/wBvzy6zFC/Ykvr2Dbg7nSlD/EShaP22DipugqNT/qCnjikoHaaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990652; c=relaxed/simple;
	bh=Yys+CkYpZuqpUoOipqyKmWrB76X/ysJvIh/9HG72v0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eBetC2BKYaGuKxjIO2etdQ2wAzsF7ENuTSFZV80kAXI0aPmd+m+LHFvFT1lhR5EFW7RFDtis9OTCwC5hKdF5MnsUiAQbCuPB6X0yqOmBGz8L0M/X5nTywEcOvJJCb9phHEpp10+46SEEAkkcw3CTx2uRUp9DPIJ8gC/s6DBhAIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tt3LAteL; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tt3LAteL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qF46IZvZ+AJcwETXtV1HFK7Aoz9c0VDxt8AgrQa188ovH/MrhVQ+vrk33ti0btEJ9dSV5ZY7CpEDSFV7BRyWBsvXjIMtLiAeZKQIajIeJ4JgmUBx97yNWp7LbT7QWz/K9gOOgOnFaSCLcGmRAGX/n/JUvLaT4WADFyZPzR0IYjCm5JZT4WB1N1ps+Ktbz8w/bVKSBFHM7Rd+JcAMC41t+fQMEGECJzOQctkiVgxdvEqP9923JtJZiWQD4krMyhPuSR1BnZDPKs501ItMdiwyKCN9pHaVwWh7YJiY7NUibPBT+o5e/LnnEq7GHwmr+ZpQ4Kx1mIknqTbdQwfScFSjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a44w2DRrpBZo8np/csAL/j/HR+y0VqATXCsQRYuldvs=;
 b=I96ydARYr2ADVNmuKT1RbvcglXuMmJDLysBT69QCP6IV0hqNRk+B243m+VIXuv7nzf5TZ6MjDyeFgQ4vfKTjTZ13wG5RTzZBpp8LWMasK8f84uGTUUfU4UQTqAWJQuQtWTmNlaT0K1ChBrBmNr300JGihY1EXmWquGiIdXsgTBQre+z1r2jJaJQ7FfIzv2R2qgJJ3S1tcvfzLZN1y3FInCHtUcGI3hennszcwamRYfKkskk+v1ya0leGEW+d2vEPBckcKTmHDixZkqxhjnB19WlHab0L6PoMGXvGakxWF8g+LMbhl/9ePE/HIxdhAuCgJNaNg1p802MEw5jsPs3gvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a44w2DRrpBZo8np/csAL/j/HR+y0VqATXCsQRYuldvs=;
 b=Tt3LAteLsxSkrN90SnhHywtR/YIIRHqST0QtBT+k9kPoO8fiZAhckw8aUYrKKQtyJHc4GFICQ0WZdWv5thI5DUfPSsW6X1jmPFej95VRPywXxzGkMRvF+OOV7+ehxuMQ/qwG5q3AnYuUA2mSww4ifVbNPpW0pHPesZzFjLo7Adf4VUYLcFnw3dJcTWge5OZoNmVFJer6xFyEWbP/NEllMoO3zIR3Pbg18QZCigz0YXvrcqzPrryknyGfK8G/GKIr/MpecQ7HNoRPAT+4v1uGOrQYnGJ/i3SaZGFs8+5+u5R/bPsGtEk3uBqiOy+7uLSvjDRpmrfo/7ZFFMrPqJWq6g==
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
 01:23:32 +0000
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
Subject: [PATCH v8 4/9] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Fri,  2 Oct 2026 22:23:23 -0300
Message-ID: <4-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 93179f57-f501-4627-1b54-08df20ecef90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|6133799003|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	E6ShQ6lJvHCUMbN7sY0DPSiBP3pmkaKAwy1oRJMmXYnrO0t9zDSLYJnbha9aMIpOf10qA1UG6GSiLGdh5Q5qrarSuCYGdeK5oC109WbJ1+eZiMPgFFHBvUCmWSWOxLeyAWf08qE9Q/X/tAqKnGWrn4FY4smJsvRSa5LR0GU/5ltBVzc/lB+SRWCJKPd5naztdEouNbUz4YCXqIUKWxzSQvwUbJnP9XDXEWvoRb/lVC9TOBLEvWZ29YmdRt9NPsTnpPDfeYWO/VV+HT4sGSdfNV6GQ+WXUj4b/wmGPBL3jgVpbzKeI5ATlfSc6dpn6kEmEmu8AzWlI9E3JP1W8MdHJAztBEb9DBXZDMzJXrWwjMG/CmoAvbro9E5A9qsDMI7eOEk0Dr3zXduuPwOuIVcXiLZuS3zzeyWaxU8Warw9VHBNnVkPT44E1WEiz2t1vBjpN+VJfh/0a5K00F5/Mb0PwzwSqAsDNxYWrYS3ADx3LPH64FmczV5I1+0Cg9Tt43LSqko8K66QbqM/OdgolveVo91GDg6dIHggGx0FRSmT6tj7Kwae90vRSnSbtH8/B0RFuBr2gk1srInnG6t/e0kGRcfNdrBa4yQNjliiH+bEhe4BN3IdZcXdOnb9IZVpyES+LQQImPNrT6gwxwyooeP8cPBEfZTr3z1eMGqMmZwIpul/4pGMmTKdxf95bjqgE7JYJtlJOFuL/oJAp/XzL1GaLQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sD04EBENGV4YEaa2V64TjqyUn9rPXJO0v7FHw0pKO/4vTy2hAZKdPOmsF8ko?=
 =?us-ascii?Q?gexyj3LzXq+CNagYj3ZCECoKXOIqV+gG0FBSonFYr4/feoZvK/IjBWTTsfDC?=
 =?us-ascii?Q?Js2vlVxgL92/lqLU0Ml5d/NRg17Pov5TF0XJIkpP1EFUXOvI33ZiQV+3aPW0?=
 =?us-ascii?Q?T0gfGqjX6kA5QRh/RQ9uZElHU8J5z+zzuiqyjDsNazUiFrYVEhgWKD/pniqJ?=
 =?us-ascii?Q?4f21DjZRcue6Qz7P9zmI96pOY/NaWG7ZKd5AOxbNV4Y1EKYzAR0Vtd6g6Kno?=
 =?us-ascii?Q?oLYPxkAeqQCVMWQ+wVAHkHDBruhBVg15I3te2huIqgY34rfsHIbywPuojKNy?=
 =?us-ascii?Q?f9A6UkpWCPbYehnoTrUTh2Pg+25oeYloeIZKG6ysuYAfWwP5MRXM44Plr0w8?=
 =?us-ascii?Q?JsaP5WI834i3mrwwwW/wUU8tYeJoSPvNny3n6YYE9CHOwGK1VLIOJEwv9PZr?=
 =?us-ascii?Q?pSLPd83kEzMhli+IjKmCQFbvCEZBUGHPRoas1emtC+X//0246WGBtjFoLHM1?=
 =?us-ascii?Q?cPEMOb4YDYOh4iFmPYKT0UrBu7PZUZGm6ClAvEDyYSuDonFwGbpHFGidWfLm?=
 =?us-ascii?Q?xM6fdtui/LyHm2heOj/oMFiLrpDmcLLhUjAeL/bJNa1EbpronEuP7Sf4w51e?=
 =?us-ascii?Q?9f65ujEaRE/0Rggg5y0hqFR/itdqE9FXsMAImjCo0NZBEW9Zfino9Do91vRo?=
 =?us-ascii?Q?HWz7yHeRZ730ZN6rELBf/5A1wbbtgSKf5zmHbk8AtUlbEQY/berMrMuyAQWE?=
 =?us-ascii?Q?46A3X6uQMyW4LXXNjHs7pjJTJyVgRlZKuYdoNpFIPo5oFs7Q4zx09RH+2+oz?=
 =?us-ascii?Q?kwJEBT30tYn1YudXdwmkPMznSk1y35HKN5EGiP0deoqd29Ey6EQTMu8qBbgW?=
 =?us-ascii?Q?ltcsVsXqN+Li9p3UO4UQhwOsMiA0c+H/DV2et+bxqtzlqsgKnUxwgCSnBrvr?=
 =?us-ascii?Q?CVUjjGdk6GCe9Gj2Vmf9rPaDjQh/LYhLoBYtF+O5zXGjRTFtxbSybsBQimkj?=
 =?us-ascii?Q?0UojCe4nuJUq5uBxgrosmF6tS03c2d4/krwOB5NV/kAIQuNlY90ViXM+0N0l?=
 =?us-ascii?Q?V7nW5dniMibJ3ujuePEKJ/dEO3SPgJ0rxmNdp2GSrVggW+D5zmgYA4OhHDzC?=
 =?us-ascii?Q?jkXtT5ovwylOIisI+N1Kthwgw5OuIKmvO7bJwvynFU7iSfVFrh7PMehVzbqJ?=
 =?us-ascii?Q?pEfeSKqd0bFyMlSEr2y1bTxJb0T49iRX6pBp8CCewkckvpPBi7AI5v2Fk9go?=
 =?us-ascii?Q?krom3iPrx0FPRR+i+kUV1FYbaRjyXjHgVEmWSjlPeyoDoUsHzcreP2RlklRT?=
 =?us-ascii?Q?OjESCpcrqIcqzYw8VvmZ6g65sfjfGQIlSNLOENrkMcWzCX/SFE4gDxNoUYVX?=
 =?us-ascii?Q?l4ZzkNtz5Ypz7QExRhwplsC6GzAUs2s7GqbHgqITDTZilehlLObZ5aEHJrvo?=
 =?us-ascii?Q?ZaD8hr45jDft/7Dj9tmhcIh2sipy/BYrN1voJ8ERbYI6+MhAmgKv4DoKdUcx?=
 =?us-ascii?Q?Z3m+eoYH7A4g++mgUmyHWFFUDSavElz3M3fxZ/c1i3vOASI+6E1roDIzEpG5?=
 =?us-ascii?Q?IxggAIS66JL8HVXDTs3GeJwIGGCseX4CE/2KN6gmujJfmuoo7d16koamCZde?=
 =?us-ascii?Q?auPAl/gEw01jiQzO4Q+TWAX96Z92CAKgcq8j6D+3oUkscYTxih6aC7Unclfd?=
 =?us-ascii?Q?4p7lCC7DrQOAw9SCjbl+Ls0BueVvZA2Ax1n6qO0LHXomEp5H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93179f57-f501-4627-1b54-08df20ecef90
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.6729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSbytofMPCb7NV17BSpJ14Nq8y5suJ6Gju/Pl3o5vKUWo6v73bpgk3KD5UwOFzK8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller range
invalidations.

SMMUv3 on the other hand will try to do up to 512 single invalidations,
otherwise falls back to full invalidation, or it will try to issue an
string of range invalidations for every 5 bits of IOVA range to perfectly
cover it.

While the range-invalidation optimization is pretty good we can still do
better and reduce it to only 2 invalidations at maximum using the idea
Robin came up with to overlap two range invalidations in the middle. This
preserves the exact coverage of the current range invalidation and still
caps the number of range invalidations at 2.

This works because the range invalidation can start at any IOVA, so we can
place a range invalidation forwards from the start and backwards from the
end, overlapping in the middle if the scale isn't precise enough.

In the cases where this produces 2 range invalidations it continues to
produce range invalidations that don't overlap, but the exact split point
is different than the original algorithm due to the new calculation
method. In cases where the original algorithm would produce 3 or more
range invalidations this will produce 2 range invalidations with an
overlap.

The SVA under invalidation errata work around is maintained by "rounding
up" to generate a single range invalidation that over-covers the entire
range.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One or two range invalidation operations
 - At most 512 single invalidation ops
   The current code switches at 511, but this turns every table removal
   into a full invalidation. Change to 512 to try to minimize the amount
   of full invalidation when using a 4k translation granule.

arm_smmu_domain_inv() is modified to always pass in the tgsz because the
new logic relies on it being valid.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 372 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  16 +-
 2 files changed, 238 insertions(+), 150 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2df064cb0a5ed3..777ec0e8cb0735 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2482,167 +2482,232 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 H.a Section 4.4.1. Address
+ * bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = arm_smmu_pt_level_to_lg2sz(tg, 3 - ttl);
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+struct arm_smmu_range_inv {
+	u64 start_tg;
+	/* Normal integer, not encoded. 0 means 0.*/
+	u64 num;
+	unsigned int scale;
+};
+
+static unsigned int arm_smmu_range_inv_calc_scale(u64 num_tg)
+{
+	return fls64((num_tg - 1) / (CMDQ_TLBI_RANGE_NUM_MAX + 1));
+}
+
+static u64 arm_smmu_range_inv_calc_num(u64 num_tg, unsigned int scale)
+{
+	return DIV_ROUND_UP_ULL(num_tg, 1ULL << scale);
+}
+
+/*
+ * Initialize the smallest range invalidation covering num_tg and ending at
+ * last_tg.
+ */
+static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
+							     u64 num_tg)
+{
+	struct arm_smmu_range_inv range_inv = {};
+
+	if (!num_tg)
+		return range_inv;
+
+	range_inv.scale = arm_smmu_range_inv_calc_scale(num_tg);
+	range_inv.num = arm_smmu_range_inv_calc_num(num_tg, range_inv.scale);
+	range_inv.start_tg = last_tg - ((range_inv.num << range_inv.scale) - 1);
+	return range_inv;
+}
+
+static void arm_smmu_cmdq_batch_add_range_inv(
+	struct arm_smmu_device *smmu, struct arm_smmu_cmdq_batch *cmds,
+	struct arm_smmu_cmd *ref_cmd, bool leaf_only,
+	const struct arm_smmu_range_inv *range_inv, u8 ttl, u8 tg_enc)
+{
+	struct arm_smmu_cmd cmd;
+	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
+	u64 iova = range_inv->start_tg << tgsz_lg2;
+	unsigned int num = range_inv->num - 1;
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+		ttl = 0;
+
+	/*
+	 * SMMUv3 H.a Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is Reserved
+	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
+	 * to target only the exact leaf entry.
+	 *
+	 * For a single tg invalidation a 0 TTL can come from places like the
+	 * SVA path that don't have enough information to get a TTL, or as a
+	 * side of effect of the splitting.
+	 *
+	 * A single-TG invalidation cannot reach this point if it is part of a
+	 * CONT group, so it is safe to transform it into a single invalidation.
+	 * The ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata does not apply.
+	 */
+	if (!num && !range_inv->scale && !ttl)
+		tg_enc = 0;
+
+	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		      FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
+	cmd.data[1] = ref_cmd->data[1] |
+		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
+		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+}
+
+/*
+ * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
+ * if successful, false if the range is too large to fit into range invalidation
+ * commands.
+ *
+ * Normally the first range invalidation is the largest representable span which
+ * does not exceed the requested range. If necessary, the second range
+ * invalidation is the smallest representable range covering the remainder and
+ * is anchored at the end. Any excess coverage from the second range
+ * invalidation overlaps the first instead of exceeding the requested range.
+ *
+ * If a SVA is being invalidated and the SMMU has the
+ * ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata this produces only a single range
+ * invalidation and overinvalidates to ensure any potential CONT is covered with
+ * a single range invalidation.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	u8 tg = tlbi->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	u8 tgsz_lg2 = tlbi->tgsz_lg2;
+	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
+							tgsz_lg2 };
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 num_tg = last_tg - first.start_tg + 1;
+	u8 tg_enc = (tgsz_lg2 - 10) / 2;
+	struct arm_smmu_range_inv trail;
+	u8 ttl = 0;
 
-	if (WARN_ON_ONCE(!tlbi->size))
-		return;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = tlbi->size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (tlbi->leaf_only)
-			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			/* Keep the pre-DS 5-bit truncation when scale > 31 */
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
-}
-
-/*
- * Generate a range invalidation for ARM_SMMU_OPT_FULL_CONT_RANGE_INV by
- * ensuring the entire SVA requested range is covered with a single range
- * invalidation command. The scale is adjusted so that the range invalidation
- * may extend past the end of the requested range. This ensures that any CONT
- * the MM is invalidating is covered by a single range invalidation. TTL and
- * LEAF are always 0 because this is only used by SVA.
- */
-static bool arm_smmu_cmdq_batch_add_range_inv(struct arm_smmu_device *smmu,
-					      struct arm_smmu_cmdq_batch *cmds,
-					      struct arm_smmu_cmd *cmd,
-					      unsigned long iova, size_t size,
-					      u8 tgsz_lg2)
-{
-	u64 cur_tg = iova >> tgsz_lg2;
-	u64 num_tg = ((iova + size - 1) >> tgsz_lg2) - cur_tg + 1;
-	unsigned int scale = fls64((num_tg - 1) / 32);
-
-	if (scale > 31)
-		return false;
-
-	cmd->data[0] |=
-		FIELD_PREP(CMDQ_TLBI_0_NUM,
-			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
-		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_TG, (tgsz_lg2 - 10) / 2) |
-		       (cur_tg << tgsz_lg2);
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-	return true;
-}
-
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
-				      struct arm_smmu_tlbi *tlbi)
-{
-	size_t max_tlbi_ops;
-
-	/* 0 size means invalidate all */
-	if (!tlbi->size || tlbi->size == SIZE_MAX)
-		return true;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+	if (!tlbi->size)
 		return false;
 
 	/*
-	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
-	 * this is used as a threshold to replace "size_opcode" commands with a
-	 * single "nsize_opcode" command, when SMMU doesn't implement the range
-	 * invalidation feature, where there can be too many per-granule TLBIs,
-	 * resulting in a soft lockup.
+	 * Determine what level the granule is at. For non-leaf, both io-pgtable
+	 * and SVA pass a nominal last-level granule because they don't know
+	 * what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
+
+	/*
+	 * The spec defines the invalidated range as:
+	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
+	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules. Find the smallest
+	 * SCALE at which a single command could cover num_tg.
+	 *
+	 * Unlike other IOMMUs the spec has no alignment requirement on the
+	 * address beyond alignment to tg (so long as TTL=0).
+	 */
+	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
+	if (first.scale > 31) {
+		/* Range too large for a single command do full invalidation */
+		return false;
+	}
+
+	if (tlbi->has_cont &&
+	    (smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
+		/*
+		 * Produce a single invalidation by rounding up and disabling
+		 * the trailer.
+		 */
+		first.num = arm_smmu_range_inv_calc_num(num_tg, first.scale);
+		trail.num = 0;
+	} else {
+		/*
+		 * Produce two invalidations by rounding down and adding a
+		 * second trailing range invalidation anchored at the end.
+		 */
+		first.num = num_tg >> first.scale;
+		trail = arm_smmu_range_inv_init_end(
+			last_tg, num_tg - ((u64)first.num << first.scale));
+	}
+	arm_smmu_cmdq_batch_add_range_inv(smmu, cmds, cmd, tlbi->leaf_only,
+					  &first, ttl, tg_enc);
+
+	if (trail.num)
+		arm_smmu_cmdq_batch_add_range_inv(
+			smmu, cmds, cmd, tlbi->leaf_only, &trail, ttl, tg_enc);
+	return true;
 }
 
-/* Used by non INV_TYPE_ATS* invalidations */
-static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+/*
+ * One TLBI command per IOTLB entry, assuming the entries are all at least
+ * iopte_granule sized. Returns false if too many commands would be needed which
+ * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ */
+static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
+					   struct arm_smmu_cmdq_batch *cmds,
+					   struct arm_smmu_cmd *cmd,
+					   struct arm_smmu_tlbi *tlbi)
+{
+	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long i;
+
+	if (!num_ops || num_ops > 512)
+		return false;
+
+	for (i = 0; i < num_ops; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+		iova += tlbi->iopte_size;
+	}
+	return true;
+}
+
+static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
+				 struct arm_smmu_cmdq_batch *cmds,
+				 struct arm_smmu_cmd *cmd)
+{
+	u64p_replace_bits(&cmd->data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+}
+
+/*
+ * Used by non INV_TYPE_ATS* invalidations. Returns true if it fell back to
+ * full invalidation using nsize_opcode.
+ */
+static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	struct arm_smmu_cmd nsize_cmd;
-
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
-		goto full_inv;
-
-	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
-	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
-		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
-						       tlbi->iova, tlbi->size,
-						       tlbi->tgsz_lg2))
-			goto full_inv;
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
-	return;
-
-full_inv:
-	nsize_cmd = *cmd;
-	u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode, CMDQ_0_OP);
-	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2664,6 +2729,7 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
+	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
@@ -2695,13 +2761,21 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
-			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
-						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode, 0,
+						     cur->id);
+			if (arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi))
+				used_s12_vmall = cur + 1;
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list for the same SMMU. There may
+			 * be several pairings so check this is paired with the
+			 * one that did the full invalidation.
+			 */
+			if (used_s12_vmall == cur)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ae1fc9bae34098..d2dc787349e01c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -809,6 +809,19 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+/* Generic page-table level 0 is the leaf-only level. */
+static inline unsigned int arm_smmu_pt_level_to_lg2sz(unsigned int tgsz_lg2,
+						      unsigned int level)
+{
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) * level;
+}
+
+static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
+						      unsigned int lg2sz)
+{
+	return (lg2sz - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+
 struct arm_smmu_tlbi {
 	unsigned long iova;
 	size_t size;
@@ -1182,7 +1195,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

