Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD1248B38C;
	Tue,  1 Sep 2026 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285014; cv=fail; b=ssmHjZivlDCECa/FEvQmadLEhsIcUx6ANQHHTG2J+qTA+PCn5Xt1XQW8DS8IWSb3hlYwoSIZitgpYeigpPgHoyq41pLdnRvG41Pgk8yJoHCK6KiNgIaVDXuLmqeR3NNmAFkMG5b7QFnGQw3Qe/6nIgulOfTVroBWokWXpBkE+HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285014; c=relaxed/simple;
	bh=71naRKB8/cH1ItuIinbPHZcxsVHWjBSDMxXUNJlh1ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pYOfkiMTpj00KoqnhVegOZU4RNlJueSDZtjkdDqLWQUaIorQKUjyQ7oI9qt1c22Xw8gJxxqPZOuiuEKRoZUzaKHL9Iw8AYQ9pXoWXi+eY9VDdotN2pClNyDKC0SOlv23fqH5NzMO1W7+RcB9BSohbW4dV/ZQ/l7r6I0QE9JMgos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q9XLNdSU; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q9XLNdSU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5+E0/mHpAWGBOgbv2KiYRCa5XotX7c3AMxzB/AQn+EbhMFJ3ebhlfmnzO1zXKlGNdsL2TZDRMOy+fG3OEGsH1t2vDylnHZOBwqtBeJwmtD4fl9M8qviepzrKIqh0C9BFe35AF/aDCjzNaUm5/Hvaq8+zXU5tHE/lXf9fAQ17QMT0W/zqzBzrqWJHnf9FBAZO7aFa2QRa4WBsnKh4EJ6Vb9G3H8ACUhXRy7acK2iSWE1STNkakCphZfCyRC93KNdalwF+oLZoXJzBaLxKqu/Hlv3WW51Bh4T6r89AbW5mBI0v/87EWA+UYBde1pcxWcAneJuOtFZyAtpex476MbsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywlmTG35FYtBN72xasJ5zX4M8o1qY8ZMFvd/XnSDB7k=;
 b=lfhvnW1fBbJ+BXTcM1RQftVy21ExH9RGXzU2AQqVJKZDYgFrPqEphWym3Rqflbj/r4WMOd+GTaPvPDxzUYa+9vTHCBlZDzcPAT8lBIYEiS2QQmc4YMfORCojGDWi904/viejJ5KwiR9KSN/WG+k+DSmf+do2+07Ce1IhQKIFD/L0WHZLFXCASZ+hF+bQ77kwMnA2QrEQs6pS+/Et9qpl0IG5Q12ZlTQp/6Cl1SoTOQYMubFsa43i/CTW6N7O/9I8PQk57mG4SNHSXH4Zf2CGziTFbZea9BaI2lK/2zHYbMlbqjwp1raACkdv71AgRtix0/OfDxfbfkjV+LovikgP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywlmTG35FYtBN72xasJ5zX4M8o1qY8ZMFvd/XnSDB7k=;
 b=q9XLNdSUx5uupY7kwY5fogquL/cL21uMEmtVmQglh0X46YRl8nk5fJUuguwKJL4f0w/KMX4b829yGTpb+RsnI2dSL2dp55+wB2sA5sP/ZKc1m8oc/IKWR6X0aYI8byoHX3j1qidRk6PeV/iFdkiXbdlODzxaMTFHX1WyGm/R/wNccoB57eJ9a0D4hnqVpgQm3FTX6xpTTehob9nda3W0rH5tBU/+Pg2P1B6tHi1xxRbNSmGio9W+jkQmOpJikkv3XAPnvhmwBbNoPsLDDw5jpGb+Kak6pJSrGj12cuoUvEcli0aMEOoHlTnpTpM7mqxkOQUURtI9tZtM5vdQB5mKiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:03 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:03 +0000
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
Subject: [PATCH v5 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with SVA
Date: Tue,  1 Sep 2026 14:49:50 -0300
Message-ID: <1-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0494.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ffb6441-2b3f-421e-bb0f-08df085171e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RuI4CwoCm5G1OkH2bYrkk0HYcyGBEXVRQuCRQozE+BncA0KlXabFZT+vRUX9uYUtU3zt/uhfRcXvyDjw8wq5dIQ0KFLzvbE8FRsPnwext0fZqsYVJ/hQVRa5vLjuN+HYn5hF+nxgSbikwgGrQx/5/xnIvqA7dBnSgSAC+anaa1d1d5lc3uNmK1TqlIUb82fm2Td2mJII211/TOXsovBzNpjtEzbRFu8kHQws1TdpYZc6XMGIK3GlPzTzMHFkhO9uBwzs4VaPNd0gLUnka1VA5jqDkPsICJnh+HE8C9kCaNaVB9iRTzzZkd9Axb3QTHFTxo6r0cvQHPmaVJtIXqBVfNPOOGbjX0Y/wBRv2XPARFPzPFoFKPKNhHYaTj3p4XgDhDKePD+LJ2NRLkXY6reDdLYHmIVlDCdy9u7WdyICiNJGKBLX3zngmlZnpsbduujqkceYB/p//k4wsNFsrGL/HF8o/LIAxkdQPwzuVXmle3r8cJoINM7amK1MKbzuvy3HCvSN0vJMhzAOAqMa+NI+b/iF/Ua/4Om4wsK9vuY/Fcd2piu3AM67/Hpb0rGzISn6/lqZjC+Y8uoiiiWNOuJ7V5ncyK9fFBBL03hYoWX97KitHakL21ZWKMAoExLVKjcycl+mEifJeOP//LcIAOm+9hXM6FMsvbGSiXXxBURlO9yp3YMizQ5p8GrHydoxoVVzOa8MdRBG4xrQG8DyCLCrSQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7olUJzyyXboroJ7CeHVpeJyqaDUakSVOaT1Pjz9JWkCJrczW3NKVhQLsONiB?=
 =?us-ascii?Q?/NL7I6GS1sqlkucFFC/y1qlKIhN5UfTntCOztkT0ySuvart4zzIzaq7A07Ij?=
 =?us-ascii?Q?aMnaDnkqL+KdKGG8a5KtS2mquafCtzrjrBOCjT6FbM5HC8yhbPdZZXxsqZi5?=
 =?us-ascii?Q?G8uqsovwzWyZ5uBO/rmwgyvL8S6ojChnFf/9gVUC7iKFztOh3lQWQOeyIyKw?=
 =?us-ascii?Q?QL2fIzACXUJLPCwLlSBui9pI0n+XK7ebSPVK/gxXV9S3H0NAJLYv8e1mKtqU?=
 =?us-ascii?Q?E1NA8xMeT537c6YqpljrfZCAhYah2j4zEuZKeIQYrJpiRYAh9XLypp15K4+h?=
 =?us-ascii?Q?6wm46qYaBZPsV4b1gidFnO1kB3zcOQ3+ZydyM93alK/79InHYU+Mu4qRuP5N?=
 =?us-ascii?Q?YabNJwsqLyK2WGNDO8cUAhmgADQjEi9h2AmFaobLZ3jmu/FXfcI0CFPleQe4?=
 =?us-ascii?Q?Dp8FqqMFZ2W80j98SL9MbajFpiVQptkZ8e1K9u7OybccrEz19GJc7BIgqIR3?=
 =?us-ascii?Q?VlPm1zD2LcsKvPoeLACF4IiouQ8HwlFw2g2hYnx8cj9u5B2nU5nkZZNc8fEH?=
 =?us-ascii?Q?uklqnQNs5uEgokswTQhO6tL80Vujd37BSpF2sLKWWabfekDX9eg+9AZkBtPg?=
 =?us-ascii?Q?ZpilLeHz4kiEieTpCndkFT9A195PE7VvqqkZGEuKWjQaC/E/lli0TDwBHAx1?=
 =?us-ascii?Q?PFDRCFTCwo57yzNmcl/4RSszhVv/6f7zb7nc8soBk8GK2o7Wb0/czakSEbPS?=
 =?us-ascii?Q?dLrIu3qWdiltS8KiAknEloC9u10avWufhMWMem4RuzugXVUifOm996jRkPFn?=
 =?us-ascii?Q?P2KhSEQ4M9qnJrqQrYnu3EtFLzN3fer4Z0esFiz3pa8XiRwOtJ/MflBokuYz?=
 =?us-ascii?Q?rXDq9XJCM0J3UnBs3hRFjsBzIClMFEr6Ce8Ha4yavzON0PCba1tN9Lm8+DUb?=
 =?us-ascii?Q?5+SPgXZ82E3spx/321NXCPirTnpX5RyuPMLHO7UrL4JyOsQh78XMPuMZjIgp?=
 =?us-ascii?Q?mrw18hufTaamBGm2nMVIx6h6OxNQDmepYHXQKA/a1yZeAcfZmGmKUPP/w4yO?=
 =?us-ascii?Q?lzQspXTgZsiFAo6yJ0GY7JrVYs7eUnYbsDNdHoCoDJBJMc5hdmuLEXT6qOZj?=
 =?us-ascii?Q?E44zH73DP8DHsIZxPk0gDSBexdjhzMKgIXFlHr7C3MZZtdaKibupGOp+vOwa?=
 =?us-ascii?Q?KoOrjV0A8Co6/4POK343u69SbKrq+0VYoi1TTIG6RlcMSZ3quX+rUcXEEnqN?=
 =?us-ascii?Q?h8bAujskAUb4EEbNA4qvwSVJe7v39CSxFl4lnXi0Wj4hLLNvi7/qms3xo3eQ?=
 =?us-ascii?Q?ZSwyPzwPd3uRpwLyxu4KPlKbWrFIHP/T03AuyhUdhaljAfe92hEkNL529BNn?=
 =?us-ascii?Q?Bn9/QIFgHXyCUzmSQtvBPWFr2mohTxNe21fMQSY1RUhckTo3nPsEyaToMdKV?=
 =?us-ascii?Q?RXMPOSzu4ZkSXoRTFMuDaKZgxstWIKD7X4aacihNzUaSRMhRdfuR7K7QDN7t?=
 =?us-ascii?Q?6++swpWRR7l5hGLJwjoDuP7aaXUNvo+ERwkrdrJpR7Ja1ntuBTdwfZbqjJ+j?=
 =?us-ascii?Q?xy2RE2Cv80USQTyxOm7PHtEE24BSbSHt3L3NnPRs0ZeTnMDzPDCA730Qz/ya?=
 =?us-ascii?Q?4qsA3n+wn9/floIdBiHIULMH/+00ahfFy0zxz3w6D78jInm5o+xJvj8mey5h?=
 =?us-ascii?Q?7y8Sd0uJLMul0B519u0+zECjinWvKNZGEPwvGiD7p6VrZazN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ffb6441-2b3f-421e-bb0f-08df085171e0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:01.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6wbzauPO8Jui5WlffXBeA0s0XVYzjHnM80zXD88x9k2VZr9m2gNv5jGySA/Aj0b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

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
Fixes: 3f1ce8e85ee0 ("iommu/arm-smmu-v3: Share process page tables")
Cc: Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
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
index 50f8321e979cef..065d76eb148119 100644
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

