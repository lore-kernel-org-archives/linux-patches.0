Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7E44062C;
	Mon, 21 Sep 2026 23:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034946; cv=fail; b=ViH0hC6pya1ytw/pvWKmMHb7pptSiNyhb7mO3zgJzM+uMpAlaOrTbDscSR9Qk/lseOyb/+7YYX76m5LyjGk1w+ef53N9bmFN+uwpxRFMjiulZlA3fRA5N8+MeWwo88PoVMfzjl1jMdw6QgmkubSkzZZMI9FLT/lbfpN9jr/ndwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034946; c=relaxed/simple;
	bh=+x337iFq4oHBXnA2oMxgyb8BHn3v+zfUQ/cb3FjwA5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N+LKOAMJgCIDFPvCh9pyE95LwT1cn+fXKZ0iMILHhUP3SWr2ixG878/g86XN0Nz1+rYCgvQtTOMS0kt9srguYvbzwVXJSp5lIu9b8X1nzfnQ2W11Lkdw43QlZbqiIAAiHD9BH/hc+PRdeY5MkmRVQC7uOmNoV8NQ7bgBYAx9NH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tCqd4kpq; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tCqd4kpq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q0HDlE1ki87TuoWx1/Pr7iXp1ftLksBusa+IvPuN1hhqesz26yjO/lrza/iR09fogxeBzQ7bHdKDyaZPTR6U9nFo1F0O2kgrLhlH2lT33Vv9b2nPwkYQ4FnJPVydCVAQfNsuBhAp5729VTX9PN3kmI0JS+yx/CwRNEjCO2XqTAr7Gfz9WvLg62vc/TUKBzHcSWM0fw/LXL1YuiDcZDfrk9kfpgAiMyJcPINsnBM/OunkGf5+N5OGh4TneWTirK4QS1z23fvmHo6pv2EWeuJjzMyGMJWgv2KlGy5CkFcCdifZwB/5d+Pmc+HgHJk1K1qrmDy5KpDivA+fKDO+N3ln4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=td+PcY7BIS3PlVXZI7zASm9CDZvuJ4yzrtfbmDJEYEU=;
 b=GSSeAExXRzbEq91TCcgETXBBC/l7qc29hVCVOEQFoDTUxePM4UybifOjzESdyK3B3bhoxcOC6Kp5vLnwjntwEuZcW8Plz8I8hqiZYehloPVCDuyeW/K7yu2z9Z6bs43iDJ6J9r58T6hPUMyN00f8z/9WevJwrxxwwfzK7RdZZyTPY2dlBbEg/jNt4kaJ0CYYfskEseb7u60PTQTmfyBn56RMeUIdbGAmBhCAC2WPeSPS6LrQo/O2U/JaCA3JfovF+hTqDBJwosLGjDASoOzF8rMLoPjbVqEqGU2sAABGmX0uGVU1cf3OAmb2Q0a/+LwK/iOtoA7aNHRNMAVGB6rpUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=td+PcY7BIS3PlVXZI7zASm9CDZvuJ4yzrtfbmDJEYEU=;
 b=tCqd4kpqp/Nu6IcCHfzSdfYWAvtMjifeVDm1FL4VpnLGPKtIURVc54c3cf4dFLOxWMv8qtWxPrDzscDyw1Wqo+nGafZHZKb+I5j0l8wTAV2D9lmjlAMBVZDTEB+lc6PneApKxvP5Ragzf3M6tj2pERSR7ui9uGYVKIc9Sk5/yI8Utr8VyIJrt579rLoE0qcenO+tfjFAfSgdK0eRSi1huHJEla92EsA8B2CREDJp/kZJlnxtyPaJAygOVEnxs+IU3nnUWr1StGCmB8kN6rFrgxgaaXTkA5Gv5yamozvGPb1CF676swDrmACgH/Zj4sBYrmBldRejkOLnCgtlHyzuBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:22 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:22 +0000
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
Subject: [PATCH v7 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with SVA
Date: Mon, 21 Sep 2026 20:55:09 -0300
Message-ID: <1-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::13) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 720c56ff-fc2d-47fa-05cc-08df183bca90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|6133799003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	JbrJb72tDQrLBFmPNJNPGr8gpox0vGF08Mw+zIEdRrumY9ZoqMw3uKWvbQJpuUBfN7N3Y2DGV/T29mMA1i7vFQrdvljW2lQt2k3Q/c1fztBUlHaPBQNDUX2Gcbc4mNROCPyVdj49SiEzz/EdHATNoWOz/y//UgmmPoicUze/VniaUQ3pxOsk1Jhv10L5HiCX79edguWjn8K5zkpoAX4Q8kmuWSVIKdll1z6eQhcT1ADgbk2l46rmv7wQaTe8OAzZgJOnvNyflMav031RY4xWmbxQSOCt0EVrjbkvowkgv6hZcIzlDMQLdFAEYXydR+PBI+gUrB0qc8QrSb0LiuFbE5DQnEkRtqcWB5DR/GZ/kmwX5exnZaQi+vwJTmqZ1T2vnUFm2D3oEOzRQ5thdaXCsbWwkThYAkrT1I5FFioUQgaO+AmnBFsOC/SX2mWh/1sdbwCz/ynAkVgQ8RBijhZR2/AOvbieV3LOf6d4vj5Qy0BFj6gBEFbf9wyF8akeJu2viI9f5bO19ij7SnsWKLRfR27eeudy7bmy8UQmykP6NcloUajJxYxSrwRIZymTzDza926VsrHpu6BaWNRnOf4fTm7EDp141XZTuBg1U4/bxj06mQKopJS7x1+zfHmJ3obBa2LvnTTMLHFOSlajwGWfRZ4LN443HgbYVbyEQwWTfsvjz5NqUa77aLqnLThFG2XXJPdt7/pqcilpR52m1Fi5AQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZPapbN1DM2SD7izVpXuGAuq75D8gxnfEK8Mn9VFWhUrkdjYOQRfBExc91xwp?=
 =?us-ascii?Q?uScKoOX8B9EkR0uiCkqUWyM86KCJGBKMFMwXVx3lpT438wAWLa5uHl84eAxb?=
 =?us-ascii?Q?bHo5b5KjOP7TxSD7fg1t0/pjc0Ec3SppPJ/ahwjfo3PdQpPrlO9QBPrnnm6O?=
 =?us-ascii?Q?c/cWZnIdzlHYDHBUJ5hzv+fRI6rP7GoOkLcwtazuZZGr8f19r91TFgHTbFm5?=
 =?us-ascii?Q?tHrHzTfWSAp9HTwvpDuGIpVtRWqbTbNWSRR6J+9sIklPKQCVCKLOURPg6YNF?=
 =?us-ascii?Q?dUuCCzq7Wf05JVnDeu5i5WNhlrxYYsQVcnJ9gy4q5X/dX0Ql0zvjW0Jw/4xm?=
 =?us-ascii?Q?A3RmewOZVQTIts5y8oaiNxYZoP4Zp6I6fEvW9Wgh5Bwnd6NF2gjHdyxTDGS/?=
 =?us-ascii?Q?2QItE30z3oxyFdOWTxCzOzQ0Zoh9NKO7w/x42KngwxZXnD+w0c8Z7zx8pNjz?=
 =?us-ascii?Q?2YRkyNogBXLIutWZbIiJ3pmm+KwHzhW5iCpIT0gGugYK4ABL1+YY3Zrhy7sO?=
 =?us-ascii?Q?Q0+d0aBzqF6mJJZeNxsswAnB/FEW+d8OsGl0e/FK42rPaYMHTGH6Yf3GoFGv?=
 =?us-ascii?Q?3yUBbftD5KylS2eNEEEQdIMnFMDu5aMcVYUdUDDuGkcDBw5fGXEtMphb/Jiz?=
 =?us-ascii?Q?t3wDeUgX/AC97h1mjUMFjJR5hiDPO4GX8b0eCb1TN6S1xEdrQsXbe+hIQiEk?=
 =?us-ascii?Q?lKH3AZu+OcRwrQAqCqXleesGNmAovDike/vtsqwuvvLVCrAU6yzssguB2Sei?=
 =?us-ascii?Q?+S83Oa0o++CeaiDtyAcw5QwRXpShlyDDzrXmqXWy+rcRGurA5wDFejWbCi7D?=
 =?us-ascii?Q?yT5qZFtA1AdC7KIhESxFXT5y9mtIlyhUjDJ8V60AIEqEgv1GdDtZD0WFWp/J?=
 =?us-ascii?Q?hlMwI5B4lX4bmEfn6v2k2Kp3tL1/lqaRD2SdaPH6QXEXNYmiEOYjGHC7M3YS?=
 =?us-ascii?Q?TtWy9RIKyZwZALzZ+Rl9UZvJWhClh4aAXPqcInZXt/gE8H+ItiTB1EPfvk3Y?=
 =?us-ascii?Q?2/6F7L0lE5uWYwtDx0f9yD9H9pfKV3dFEh3xIT/XM3DXlEPj8pPBecI/JMfL?=
 =?us-ascii?Q?NoZXtxzs62JhZ9RqPGDDKSjgx9/o6vM79SbcPJRCQATgqG695zVFR+dP4VWF?=
 =?us-ascii?Q?c/dTT7FdIqk3Gt0+ByeH+vYi+vfVlPC2gSuoUzAcTVow0rkMH2BaEFBpl3SR?=
 =?us-ascii?Q?XJcA3cEhy/xGQvASmjMi81KMp54x0ZSxzz7KSPijh/VnLbjzUwo6zDGwVGHG?=
 =?us-ascii?Q?/+hueT+b/Q0J1Vn0DiE/Nj42S1390migUXQSsBx9bYAMi3kaN/Ch2a93gIHx?=
 =?us-ascii?Q?FhMZQ63s7SCnSjWw1El0IN84HmMNMZVlnZIuuD7Kd2CBEPwz0PS+wsyDij+n?=
 =?us-ascii?Q?1B+YTf4jC3ZumqsVi7uHAwyGzKUaHw8B7TZ7JCvwTWE0MwPJWS/D/wspfnln?=
 =?us-ascii?Q?8zdBU9HAxtJd6V1DVCAgDDxhrwOASknG1IltzgOIncqdDYtpVnAS6mPv5n8a?=
 =?us-ascii?Q?Gffo9csLzkkMlWpSWKBabPjddW/qu2FnxxSGvgesA9L6NM/YEGv+GYpBIhtp?=
 =?us-ascii?Q?AFBTcb676ZMesf8OMZWC6gCVku2+bMAL8bJ/TPd6h7F6LEQOftNxeeCwGAbU?=
 =?us-ascii?Q?/glte3YhhuRC4VWgagR7WL6tpbYDHheWMOTQZzp2fVINJearm771tHo9x/kH?=
 =?us-ascii?Q?mI5TWIi8F99fnJz/hKTceebnvWhiKD84s0lQUScFlGRa5kf9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 720c56ff-fc2d-47fa-05cc-08df183bca90
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:19.2530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZ2kn2wVSdkTcqYCDLHsXMVDzETyVkqgFLkOUIurWOcVz/MY4+HxqJ6lopyN2IPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The erratum (MMU-700: #3777127, S3: #3673557) deals with under
invalidation of a CONT PTE grouping in the SMMU. The recommended work
around is to use a range invalidation that spans the entire CONT. The only
user of CONT in the kernel right now is through SVA sharing a CPU page
table that contains a CONT created by the mm.

Previously it was thought that this errata was dealt with because the
driver always uses range invalidation. However, there is a subtle detail
in the errata that the invalidation range must fully enclose the entire
CONT for it to work.

It seems that two sequential range invalidations, with a split point
falling inside a CONT grouping, will not prevent the errata.

The SMMU's range invalidation generation algorithm does not produce a
single invalidation for a single SVA invalidation request, nor does the mm
carefully align the SVA invalidation ranges to accommodate the splitting
of the invalidation into several ranges.

Thus, when processing a SVA invalidation, the range invalidation splitting
routine can generate a range invalidation that is split in the middle of
the CONT and risk under invalidation from this errata. This condition
could be triggered by a malicious userspace manipulating the TLB gathers
via mmap/mprotect/munmap.

Update the errata list to the include the S3 variation, detect the IOMMUs
that have it, and then have SVA invalidations use a simplified version of
the over invalidation algorithm from the tlbi rework series. This ensures
that a single range invalidation is issued for a single MMU notifier
callback and now the range invalidation is guarenteed to cover any posible
CONT.

Future work to add CONT to iommu_domain page tables should either use this
one-invalidate/one-range invalidation algorithm or disable CONT support in
the iommu_domain.

Cc: stable@vger.kernel.org
Cc: Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Fixes: 3f1ce8e85ee0 ("iommu/arm-smmu-v3: Share process page tables")
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/arch/arm64/silicon-errata.rst   |  3 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  7 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 91 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +
 4 files changed, 88 insertions(+), 18 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index ac3248b9f2f3bb..68018bf75b7910 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -271,7 +271,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU L1          | #3878312        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
-| ARM            | MMU S3          | #3995052        | N/A                         |
+| ARM            | MMU S3          | #3995052,       | N/A                         |
+|                |                 | #3673557        |                             |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | GIC-700         | #2941627        | ARM64_ERRATUM_2941627       |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 0a429c64fbf3e7..3f50298a1c14ca 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -215,6 +215,13 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 	if (system_supports_haft())
 		feat_mask |= ARM_SMMU_FEAT_HAFT;
 
+	/*
+	 * The workaround for ARM_SMMU_OPT_FULL_CONT_RANGE_INV requires range
+	 * invalidation support.
+	 */
+	if (smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
+		feat_mask |= ARM_SMMU_FEAT_RANGE_INV;
+
 	if ((smmu->features & feat_mask) != feat_mask)
 		return false;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5732f3ba0122d6..e7ce2eb686ea39 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2538,6 +2538,37 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	}
 }
 
+/*
+ * Generate a range invalidation for ARM_SMMU_OPT_FULL_CONT_RANGE_INV by
+ * ensuring the entire SVA requested range is covered with a single range
+ * invalidation command. The scale is adjusted so that the range invalidation
+ * may extend past the end of the requested range. This ensures that any CONT
+ * the MM is invalidating is covered by a single range invalidation. TTL and
+ * LEAF are always 0 because this is only used by SVA.
+ */
+static bool arm_smmu_cmdq_batch_add_range_inv(struct arm_smmu_device *smmu,
+					      struct arm_smmu_cmdq_batch *cmds,
+					      struct arm_smmu_cmd *cmd,
+					      unsigned long iova, size_t size,
+					      u8 tgsz_lg2)
+{
+	u64 cur_tg = iova >> tgsz_lg2;
+	u64 num_tg = ((iova + size - 1) >> tgsz_lg2) - cur_tg + 1;
+	unsigned int scale = fls64((num_tg - 1) / 32);
+
+	if (scale > 31)
+		return false;
+
+	cmd->data[0] |=
+		FIELD_PREP(CMDQ_TLBI_0_NUM,
+			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
+		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_TG, (tgsz_lg2 - 10) / 2) |
+		       (cur_tg << tgsz_lg2);
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+	return true;
+}
+
 static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 				      size_t granule)
 {
@@ -2565,21 +2596,30 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool leaf,
+				       bool single_range_inv, bool leaf,
 				       unsigned long iova, size_t size,
 				       unsigned int granule)
 {
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
-		struct arm_smmu_cmd nsize_cmd = *cmd;
+	struct arm_smmu_cmd nsize_cmd;
 
-		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
-				  CMDQ_0_OP);
-		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
+	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule))
+		goto full_inv;
+
+	if (single_range_inv && size > granule) {
+		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
+						       iova, size, inv->pgsize))
+			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
-				      iova, size, granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf, iova, size,
+				      granule, inv->pgsize);
+	return;
+
+full_inv:
+	nsize_cmd = *cmd;
+	u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2600,7 +2640,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 
 static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 					unsigned long iova, size_t size,
-					unsigned int granule, bool leaf)
+					unsigned int granule,
+					bool single_range_inv, bool leaf)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2630,14 +2671,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
+						   single_range_inv, leaf, iova,
+						   size, granule);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
+						   single_range_inv, leaf, iova,
+						   size, granule);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
@@ -2684,6 +2727,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_invs *invs;
+	bool single_range_inv =
+		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2723,10 +2769,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(invs, iova, size, granule,
+					    single_range_inv, leaf);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(invs, iova, size, granule,
+					    single_range_inv, leaf);
 	}
 
 	rcu_read_unlock();
@@ -5009,12 +5057,21 @@ static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
 				/* Arm errata 2268618, 2812531 */
 				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
 			}
+			/* Arm errata 3777127 */
+			smmu->options |= ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
 			break;
 		case IIDR_PRODUCTID_ARM_MMU_L1:
-		case IIDR_PRODUCTID_ARM_MMU_S3:
-			/* Arm errata 3878312/3995052 */
+			/* Arm errata 3878312 */
 			smmu->features &= ~ARM_SMMU_FEAT_BTM;
 			break;
+		case IIDR_PRODUCTID_ARM_MMU_S3:
+			/* Arm errata 3995052 */
+			smmu->features &= ~ARM_SMMU_FEAT_BTM;
+			/* Arm errata 3673557 */
+			if (variant < 1 || (variant == 1 && revision < 1))
+				smmu->options |=
+					ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
+			break;
 		}
 		break;
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dd2fee2f560e68..eb308993c810f2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -934,6 +934,11 @@ struct arm_smmu_device {
 #define ARM_SMMU_OPT_MSIPOLL		(1 << 2)
 #define ARM_SMMU_OPT_CMDQ_FORCE_SYNC	(1 << 3)
 #define ARM_SMMU_OPT_TEGRA241_CMDQV	(1 << 4)
+/*
+ * Range invalidation is mandatory and one range invalidation must fully span an
+ * invalidated CONT
+ */
+#define ARM_SMMU_OPT_FULL_CONT_RANGE_INV (1 << 5)
 	u32				options;
 
 	struct arm_smmu_cmdq		cmdq;
-- 
2.43.0

