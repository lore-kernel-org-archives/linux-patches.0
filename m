Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A9E31E82B;
	Thu, 17 Sep 2026 00:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604885; cv=fail; b=KGivVq8lL4S5e+RyhwXEGDog+zqr1poJrkn/HWDM878f+G2OfawpetQMQttVy4ES7NjsS1JCvylLL3gSG3BkqW9+aw9F4dX9wBTTAHPOv4CRtNpjceaTp47RBhGNcgyqRuOwg/OQXArcwA4cBs+PrKyQ99P6iBwqok9HVRGrGB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604885; c=relaxed/simple;
	bh=x8qPXwbxdsqlmEC53o9DulKy4C0xcVGvw1N92gzCYg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ddTppFqJ1dlv695/D33MpC9QtOxul25QQiGqsmolsa7YZGboaDaLr3X01wQFFAS/ZcPvIc5fi55Ukw97EwAxNQPjWUw0CPc3P/Npho1R7fa/vjid8DfioNYV1RvbJi+8NhQDu/sgNFy9HiS+fgGwkSQ2srbD2oEQwxEXnEL95Bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KnKcnr3A; arc=fail smtp.client-ip=40.93.194.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KnKcnr3A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGkdhJNWwJSueBcgoK9EmyLpIGdrCRewFyhZbFcz9jrWiJrGNgPg8JBNVBUTKmbTfYNuE5cn8G3HDfFE+Jy013HRBMssan5RFbK96E6M29ePjwVwFbVgW80xaiuXzal19CLtn83TqAGk/jhqRcVEtrYyVb1SJbcOiwqtc8hsLfzsJffeWYmlEggo08ibyp3Xh2CZ59VPqFrX/dG9ko5eLFpR7Ze+wJTqvwzLfKgR58v3EYrkXj/Dp3J19k85X549CahlH9JfgcUsWenAKEJ423Izg4WBXLs/A2u3bb1pTlFvt3Pyd//0zw+9qnFJYmWTytUqXmAUz7+Dyf2wv0G+Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cot1A5KiUxhXt4BsSYXLiXwD//xTPmF5GuI2rpFSQPw=;
 b=h/DU7c5u0r1BFXPnFU7WmeKTTHcObttnUCqTXUuURbbIcrnmHalsdkJqUM7QF183K9FIqfHqS6iUXJKsVIeqkHWCYd8ejLRxx9mSGpsBnw5dOlgbzZ3fF2E65Pe8JRw1vBEudDZ6nBEFtkzRZ3wx+05bi3F4ynUzYrSl9tuFooa3OchoqeXsT/1FcsQk0/npSpj+LvZp1vzyEMocf/OEddGbFHbh5dsnHx9cM1szjkdpX759hBSxAnSVs/Ycp0p3OtFsHK5INM8eaZxDkPC10gE08+xrmTUpfpLzqQRpJbS204tzalOSqx2ZcoaCbqC+jTxuhiMoYBpMj+1J4SYH+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cot1A5KiUxhXt4BsSYXLiXwD//xTPmF5GuI2rpFSQPw=;
 b=KnKcnr3Ak6+CxpgV7nRSPtFMyg8oap0KIdSJhJDMbtc7FhSfiCZfC2VLQimrqtEcAP827uHkubuCtGzicrjpH7esCKBJ++wlL9SVIidlEZaNyEDEwc2nmCnj39iPLhNWKUghNuEmaEBeBk7mcoq5SYk9mw6pCdCjWjfTHBwDn47xj7ELJL9M2Nl5rVa0QIVjDZdrK9uyt0nWfGUrwEcP129Eu9R666lmnlbAJEL08qHIhUuRdW0bxv0qT4rMBbCLcZAhyH1bs7GD+5xS3grlq7FMn4WL9+V/TMh0GxAjbiQmpuzM1USpZlsO8lWrhXeLqbHT2/l2b9ZMawH35lb/5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9188.namprd12.prod.outlook.com
 (2603:10b6:408:19b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:55 +0000
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
Subject: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with SVA
Date: Wed, 16 Sep 2026 21:27:42 -0300
Message-ID: <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:208:23e::14) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: b318605d-9960-4ca8-06b7-08df14528336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|56012099006|6133799003|22082099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	haBSi7cAn0Psr97FBuevp0gCCViAIq3p6cQBbhHIxH/PMbcLVKzEf/ViYlyDcVwze6CyT8kOsZC+C2J2cHF9FcZRC1aINsYfHTc8Q8eIJx2NwQcaUoDWV2XaR/PeX+r/A/4o/QS7Hgo0iVbxAJkDLhD+6UQBQVcpmldWpWDYckzC25Gt26vagx5DqE4F2+jsyT39iZ5SA8rRBvDTAOxm71DC1pnBc10gteDptz5tdQLwk46OK6HofUy9atPhuDZdxOQS2iG4HxrN9Xct0lY5/IkfR2NbESBT/J+oqr/UezSfxLvZsL1EgwZo5NSHjyOmwAoYT7ZC/jpIR+WMEOqpfIXtKmPZ/3eFxtOPLiSNyMaaEhYJbTEk7Y1UGjUowtBsSOA1kmPUhOqC3HDvchNk6V39qZ3C+nNB7JiawPQzwAguUs7frUI21XmJAnknNoaj0Y8hywgZ1thXTNUF1UfkjwRCBHNvawCil905JYoGeoaliuEDoiGKsZq7aBnsrWx6BELJB8xBtJxbh51sjJ8t17VuVjp4b0+BYIoo/8IEKOLjjIt8braqTdRhOhFJmdW3GRbzK9Bw20WyJ/YDt+0UOKotmO8aF17QmE8IMSDrZI/eeKLVK5z8uVYkaqlqyN2LX836l/SfzhRBisM0rE0TL6AnCmObkhQP1dLV/19CGomcE3NByln8l6TjwJ4pfMRgc724amSmfYJPq3SV4k3ozQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dpogDgodEHoyY4J9DeAeJ6lOkB1D+I2tve4TZRRCMBYNyDlPLYoICA03GBuo?=
 =?us-ascii?Q?rtszNOBtdc8VHucdmV6iynvYeXyyo+enMfCNyKbY+XcWmpMNhCvG8NaXCcxX?=
 =?us-ascii?Q?7VO7bFDjtA865ivLqxThC6H2nhxCcuFxsYQuqPWiWQpF5LgIi7f0YBBrCLB9?=
 =?us-ascii?Q?8ffJ0mkmQjMdv8CYMgJkWEPX8bybE2RbzMyb9bVEVhvyfR4PEHDiLmp+oOCL?=
 =?us-ascii?Q?NC8W3Vt9t948z0wpCE27NA3kMN0Ad+91ASg7+ZtZfIn54rLlLU974N9s5Svi?=
 =?us-ascii?Q?5v7+Z7knDFbh3H3YbhLwKsha+TFC0DSTaZgXzkgQfeyf6pwte11cYPxbmTm7?=
 =?us-ascii?Q?Z472AT4cqbDd3Eh0pqTByocygCNXpAfTau5hyufXYldN1v/GZVdbZIqEDm1v?=
 =?us-ascii?Q?CFeXtzbQe2pZ00Ayv+7ryChes48dDJkgp1RXJBwkh+1v8zNEC+LsmYR/RjHG?=
 =?us-ascii?Q?JHbLT8rGUWFEhEHlwfPo6uXglVr1bQ/66H65xnQSbJD1JhcbV5IN5WvkKENd?=
 =?us-ascii?Q?dvkllXav5Sx+ynBUjevzHXl89+VJ6/IIL1y02RG50x3jFk7uHONOdkkDz62S?=
 =?us-ascii?Q?v9ass/aWyoYfB4lMiFOKwg2NIG+WWSAg4532SkqtU92tMMGJbM4A8HcBz5Dj?=
 =?us-ascii?Q?rSdfxNiTR6C85ftdluMcg701sJOwSgOa7T5OXVvwbqGcft78qO21XNLCx18m?=
 =?us-ascii?Q?A2RfxPNEtBlCyZY6UXMNwu0mrWmQQFIHZPazzeK7fge9rbPDKlQBPNBTZXMM?=
 =?us-ascii?Q?vxZIqrkQF7CPm4Kosq/+1g+Q2nKU2lUKFy9lOKlJ7xKQrz1WGxTaaFNnVVa7?=
 =?us-ascii?Q?ZDMfFZKqeV09JUYKIa+/IGRMfz9C8izXAQmfuc9fElnLlGTcKCn3JhGDaCzZ?=
 =?us-ascii?Q?LMN4wuaia6JGq7tfUiRcmskfD7y4T1nL9EL9lvLrjr4d4HcRkkCnyk+ZiUhr?=
 =?us-ascii?Q?jVlmrpIyGlfOWSSoNR2ntSluxZDuhtRUkuL9IIMNLI2CZ/ld/9tzyBYrvMDw?=
 =?us-ascii?Q?8AO5Kj+zrQWfSKZa05jBXQ8mKDwumq4XoGT3pg7YIfXlOOr+EIkCOzyO3yxI?=
 =?us-ascii?Q?Oj/6B6n+urFmIxbTH7fsz0sPsJ34eYHxtPq6p8byeYRnDTVXcLu0bDbQEbiP?=
 =?us-ascii?Q?9i+dbQmhaYZdYTTZ/N8QYSHCJLzkjmtAubhpqQ60ia7DVFALh4vlkZ6V6H4E?=
 =?us-ascii?Q?4XOPkjYwJwWiX1YGmO+uncRfz5RqC7xLApwZ5oCMwdLwAN1Nhv8h9RQz37fc?=
 =?us-ascii?Q?mYs7d4XkAyqhFHigBkLQiEvl0aG8hNJgNel8Yn8+4nyyJhGdCBDf+Q+kOuU+?=
 =?us-ascii?Q?RqfoDAWQg9/3RFa5c6J0bPFt8w/CM9av44mGZk0H+f7JwOY1mnIHv4PxGqdQ?=
 =?us-ascii?Q?TUkyaCONO3NBpyMHIj0KN5mokRbk+V1i2t2EsGuEKkxe0YE9SRq581xbPXK8?=
 =?us-ascii?Q?OSzZfdwPmeRsqGjwxebjqJNwTz0wRKgLZK4uYbLGiXiSkD4TTow6OgI7tCWL?=
 =?us-ascii?Q?VCi2PnK2BsM7eGD9XzAt4KxQHajcCu0tlxiJ8GR2n5xauVQ/F41NtDi/9OMP?=
 =?us-ascii?Q?yIWjzm1IX5kdcWAu/CpvojewywWXmGFw0Mm+oWXSqReAl7BbWTmJwLR1h8eS?=
 =?us-ascii?Q?2fuxS4Lc66Cp9tridmT+xdqDyuflZBfEgEQ7xfjOmo0+Kw6xqZXiv+xAH9/0?=
 =?us-ascii?Q?LL0lPM6emoKCFAsNdSTXvixpu/zFpqx+bww9afColuUuYdL6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b318605d-9960-4ca8-06b7-08df14528336
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:53.2304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfpCDSxPyiD1wbJP7SlzNjfY1GTkHNDC2mLrOf7CZAWzVyrTBuAHdCEZe82y3Dnc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188

The erratum (MMU-700: #3777127, S3: #3673557) deals with under
invalidation of a CONT PTE grouping in the SMMU. The recommended work
around is to use a Range Invalidate (RIL) that spans the entire CONT. The
only user of CONT in the kernel right now is through SVA sharing a CPU
page table that contains a CONT created by the mm.

Previously it was thought that this errata was dealt with because the
driver always uses RIL. However, there is a subtle detail in the errata
that the RIL range must fully enclose the entire CONT for it to work.

It seems that two sequential RILs, with a split point falling inside a
CONT grouping, will not prevent the errata.

The SMMU's RIL generation algorithm does not produce a single RIL for a
single SVA invalidation request, nor does the mm carefully align the SVA
invalidation ranges to accommodate the RIL splitting.

Thus, when processing a SVA invalidation, the RIL splitting routine can
generate a RIL that is split in the middle of the CONT and risk under
invalidation from this errata. This condition could be triggered by a
malicious userspace manipulating the TLB gathers via mmap/mprotect/munmap.

Update the errata list to the include the S3 variation, detect the IOMMUs
that have it, and then have SVA invalidations use a simplified version of
the over invalidation algorithm from the tlbi rework series. This ensures
that a single RIL is issued for a single MMU notifier callback and now the
RIL is guarenteed to cover any posible CONT.

Future work to add CONT to iommu_domain page tables should either use this
one-invalidate/one-RIL algorithm or disable CONT support in the
iommu_domain.

Cc: stable@vger.kernel.org
Cc: Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Fixes: 3f1ce8e85ee0 ("iommu/arm-smmu-v3: Share process page tables")
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/arch/arm64/silicon-errata.rst   |  3 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  7 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 87 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 +
 4 files changed, 81 insertions(+), 18 deletions(-)

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
index 0a429c64fbf3e7..a0c9078646fb55 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -215,6 +215,13 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 	if (system_supports_haft())
 		feat_mask |= ARM_SMMU_FEAT_HAFT;
 
+	/*
+	 * The workaround for ARM_SMMU_OPT_FULL_CONT_RIL requires range
+	 * invalidation support.
+	 */
+	if (smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
+		feat_mask |= ARM_SMMU_FEAT_RANGE_INV;
+
 	if ((smmu->features & feat_mask) != feat_mask)
 		return false;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5732f3ba0122d6..d6896e25b6632a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2538,6 +2538,36 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	}
 }
 
+/*
+ * Generate a RIL for ARM_SMMU_OPT_FULL_CONT_RIL by ensuring the entire SVA
+ * requested range is covered with a single RIL command. The scale is adjusted
+ * so that the RIL may extend past the end of the requested range. This ensures
+ * that any CONT the MM is invalidating is covered by a single RIL. TTL and LEAF
+ * are always 0 because this is only used by SVA.
+ */
+static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
+					struct arm_smmu_cmdq_batch *cmds,
+					struct arm_smmu_cmd *cmd,
+					unsigned long iova, size_t size,
+					u8 tgsz_lg2)
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
@@ -2565,21 +2595,30 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool leaf,
+				       bool single_ril, bool leaf,
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
+	if (single_ril && size > granule) {
+		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd, iova,
+						 size, inv->pgsize))
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
@@ -2600,7 +2639,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 
 static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 					unsigned long iova, size_t size,
-					unsigned int granule, bool leaf)
+					unsigned int granule, bool single_ril,
+					bool leaf)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2630,14 +2670,14 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
+						   leaf, iova, size, granule);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
-						   iova, size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
+						   leaf, iova, size, granule);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
@@ -2684,6 +2724,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_invs *invs;
+	bool single_ril =
+		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2723,10 +2766,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(invs, iova, size, granule,
+					    single_ril, leaf);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
+		__arm_smmu_domain_inv_range(invs, iova, size, granule,
+					    single_ril, leaf);
 	}
 
 	rcu_read_unlock();
@@ -5009,12 +5054,20 @@ static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
 				/* Arm errata 2268618, 2812531 */
 				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
 			}
+			/* Arm errata 3777127 */
+			smmu->options |= ARM_SMMU_OPT_FULL_CONT_RIL;
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
+				smmu->options |= ARM_SMMU_OPT_FULL_CONT_RIL;
+			break;
 		}
 		break;
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dd2fee2f560e68..ab54210a8ed999 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -934,6 +934,8 @@ struct arm_smmu_device {
 #define ARM_SMMU_OPT_MSIPOLL		(1 << 2)
 #define ARM_SMMU_OPT_CMDQ_FORCE_SYNC	(1 << 3)
 #define ARM_SMMU_OPT_TEGRA241_CMDQV	(1 << 4)
+/* RANGE_INV is mandatory and one RIL must fully span an invalidated CONT */
+#define ARM_SMMU_OPT_FULL_CONT_RIL	(1 << 5)
 	u32				options;
 
 	struct arm_smmu_cmdq		cmdq;
-- 
2.43.0

