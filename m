Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1240932B99E;
	Fri, 27 Mar 2026 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625050; cv=fail; b=FWyR2ROxyzj91AUECJelX/0CBar18/SbLLYtD/tMv3jKAESMANAE5Ve8BMO2nEySQ4n80vslXspJhh//+hsc2Xla9o3X3NssIMbx8LHDqBh75SgIy9YAk9tq+pxRhmjRCa3lzFRPQAa9ZStt/5gFBT+Y9Ff9th0mDuFaZ+LZWwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625050; c=relaxed/simple;
	bh=fiNAC0pNOqdwsNjYnf6eaaKG1hpo2ZDn/mBL3thX63E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cxdSUa/w3bMMZAfbzTmpNBAXrGd/TSRYu+SjXnnuMwedh+U0pnbxJiLu5UsqIvc0C5vEaSifDr7kg7S7D1G3RvC6nEq85VwM38s2vfigrmpLDPG0GyYbeWk1Mz9agwUkvZCvdSlNmlla9le0sroribG5zNSl+YDeBs7+Kha/U/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZIMx0t+T; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZIMx0t+T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWZCbHKTifmk6Z6ifcpgMDpB+O7DFfF4xwm2xrU/yE/921iYVqeDKSzNS4fiNuvw0sNvA6TrTQ7sz94gW9+gmWpqVRRWzF+gsDQIJqigVG7fAQ0RdV+eTUaLLx2tgTp1BeMd6Hll6lPh4pahTfDLGF3oprXbGXX+LLfeeEzaHrmVB/CPAUEQ50EQ1g88qZ09JLIe5F7G81pfJuKfE4m9XI82pmPVZ6GnfDUfwZtvwwsMc8HqHFLLRQi4LN79yCKVLac5I34+FS4P1JCxJ3AbheTXYkjmyolQidvRskhXyCHI1HJpGhq3r0mVka/nSkw/hC/YY3UiO3C3wYjMsaBR9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZxGEO3bgSvEpPzhHInyCCNQID0f1tsQIOpHCqtjJjE=;
 b=d06Ae5TurGP9zmQuAPwkPtmh9z8bu6JTeoENfuQNApNGJEsYJNeU0LJGh5xSB/ynPm8CWF4Izt6u4pFZuihU4/jtCeuuxtvjiXBweRakpv62MH5bxRyi5A5i68/xcITOWtV/aqvHx4/1LOwifRYyefqrCJoASbK7lGBLr28qGPC4dEajUN/yooMBcSNA/8N6puXa9haGWZu1lMZFm86GffPSLUo7IJZzjta+QTPQPt2ywzvLJmpreg7O6d4PJwXfzMptbzpnpjBPfwPJ/bLEzv3tWTtKLX1Vu3YXt99+sd5Ttto80ZryT5Q3B1/ubmk23tTjVJAzcARQ1RSVgRMl+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZxGEO3bgSvEpPzhHInyCCNQID0f1tsQIOpHCqtjJjE=;
 b=ZIMx0t+TnqJ4BJZAW6DCWLyFtqqC3VSr2xj1g18ijnHu+xG/qk2b5ntGE8o9yx69w4ROuGtH8o2utFQ+wsQ5gTQLXt/OzOJw2cdenvgza6kXFNh9y7ZsWpNbAtxBAwvA/uC/9plbzip22JxIwXSpn3SfJkYuCvmg8IVVlXHZUGbhYGIBPNJO9Bm0snKi574mJcajGEDp+XG4xC7S+TQn/kcGbkpJe3SczYpztkdkrc7FGh2gvj1CzHpHVS+J4SRcH0jxsxobeufIJL5pojHBb6Kz4ClWndxF6iFdYOtXmIgWKs2josQ7zErhvlDe2hTHeG1dI7LK70cfeXiNALdZXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:24:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:24:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 4/5] iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
Date: Fri, 27 Mar 2026 12:23:58 -0300
Message-ID: <4-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:208:23b::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 922ad52b-9321-4262-d644-08de8c14dee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	VUfhpTyomFGmRkGUtzr8ldSmHldwb/GWI51RZ6VfDduma0b+dmKZooE0EqKOJ5UIXAUcJOKgz201kZArfpEMviQUYeykUs2UGhotMhHcwzr+dCYgGf8pipmMd2vQRszaYsSLKtUn4ioRc9rxxi7wdKp/kjKCLgbF2puRof48KAFoRRxWH7e4bs9JHcPjKTwfxNIpAsEh8FPI6RqBolhKX+zBji0xw6beWW0mlTMYm8EYrPWwieGNrJllqdA5+v07TBpAXUagX2FWdirymtHwze4xO5cEowy3EvJIk/FMv6jAGSMVDyO6r7hHvS78tHzdXtflE9lf+9WErmKYf60t4yIhP036v5Mu/pFvtdFhPiWcp/zW1y9wmfVZzqfxz7LX5Lm8zFo20kkeKdsrSwqQlkk0FW8A6AsauzToxCYkUtxoubSZVWnBANegMBQMPJREUwpmv/kpznBHn1KhEGDdP/gCvrBA5a81m/zBwokxlHN7dzHAYXQ0uJwyJVQn5r593TgxDTQIuSNadkjjCnn7IokuXRdjx1uLBzWK7c6Y9y0NaE6i7Hdu8CTy7ZOuGsu7AXFmC1Gm65KKzurgVA3duBevBGKQykHM3onycxXgGCQdnuqE+MloEWLyDWrVZAmc806Vb/8vjwU/X3Vf4y2mf01laaUckzfhokMl/Hqpo3Kfa1/2MJO7VbTZXQGUvdACb7twO077BR3hPM7zk8MYF6qpm/uLyWfDPl74f07QPW8wTM6HezXfxkUWkb9g0MpbV9nfvF4joXBb0Ql8g8WsZFsk/8kuHrx0Q2Pj+9Z47Gk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xHecpRyEgJ99UYhF9e1EX3Wrv7XGKmsrVp8Ibfvj/za8304CHwVq8BI+IoR+?=
 =?us-ascii?Q?cNIRqs8NtwFWXgn8Tbt4PkyjYEUWWrnPuvB8yxzcntsxIoa9IqxgPzXY+h7m?=
 =?us-ascii?Q?1wjeJ8IvsMcm1DhKrLW3hhNFbBwbXorKkLhd5fQXxOJWW5iDj0UxYKOr2khz?=
 =?us-ascii?Q?NOaEFlhM7wJrZBd3bVDQrYKjxfPn+jZsQKtU6OxmDh18g01o71IY+c2W5uQJ?=
 =?us-ascii?Q?QeZPdwP7otUuXoJOlCWEPDifXNBdXAmWWVC8XlJt1OmIF93pbwK9N/ivDPkF?=
 =?us-ascii?Q?5LxoLUT82BOsFq4taZxcwYAJ9HV6uNiyfUhnJsFrWwHbzMN9ygJYGVEfJCQ1?=
 =?us-ascii?Q?T5ja3CYjTN2EnkEwX2ZJyaRpaPL8bf2ZpCr3nSAVVisuHzRtNpPepEzwJJs4?=
 =?us-ascii?Q?wp/2PgE46BgjkZFCAUSB/6jqlK6HDTs833Z0OkcQMNUYUKsC2iQEcPSJluSJ?=
 =?us-ascii?Q?MxuHwptnaKExkYpaj0elrHL/hJgJlIkMRCMfo6Se+ID+7vVTH+99Cmi0bk5n?=
 =?us-ascii?Q?FS7BG+64srmv4lYDYCDukwViGo0q6jlF3PtdmybgIP7+/DJfK2ip60Xr4OUZ?=
 =?us-ascii?Q?aeoL/7mwF0TJ77nfccTqhXykEp0CADx8+l9KpDDIPyRS5RnK60NIFhJONLiD?=
 =?us-ascii?Q?tp/mxhKpEUqlIAPbbkRpBkf5wg6AiQKxg6v5/xj24Mvi9clweltOkziLQhiM?=
 =?us-ascii?Q?+dLkytTndwo330upZNZod7We9XXjfd3MlQcUBe6VdXnyAcTzAlwikDidny3A?=
 =?us-ascii?Q?j3wUTOv28cV+yVLdRW3pbxKj9oB5lfmbr7O8L4jDrc09/W6X8fM+Q20DIgwX?=
 =?us-ascii?Q?o3cfhhKs7knO39ZaSHQzdksZChnQ8zk/raxCZByt/XmxfRSLCU36RVRTsebS?=
 =?us-ascii?Q?RtJZW2xPK8Hgwu9YPUf7yff7CThup2hXIDLxzlz8lLSJBcaRf16WygpYiXTs?=
 =?us-ascii?Q?yNr/U9kw0uabKJb//YGtC5FgDK0DURW/i+8xaIW6E2/O1tPT6ndj/IZbwgwk?=
 =?us-ascii?Q?GEzP3m6r5ZzcmUOTR8rDxyI1TeZROkZclW6RQVcYmv96ZAmOe8aMLfOsIfma?=
 =?us-ascii?Q?4X8j1d8sW79lx/Y4qIScUYWWYU/BbiGLlD6uos1Pox16vvdVRdH1cHPC7ULV?=
 =?us-ascii?Q?NVZHHGVeaoLahcQhdeWD/HR+OyTONIdaNtCKuSbu7GIAycxt+uc8BQIc7Dcd?=
 =?us-ascii?Q?JHjMzCz4XL4FlvgrPlP47vLywW4zk+thsvpu6nI84UXYBbMiN8WFAMyiQq7M?=
 =?us-ascii?Q?+vfkSCjR+Ec8+OmlrEoVU8SDOmnaeYS9xqb0ZVRw4Z0M0uik3V8K+sw/P5zP?=
 =?us-ascii?Q?bGEJzDZGx6VWMFA77bL3FL1ZGZiYn1WceZ6Oon6OgQDUFm5TCTWhTPIi5W9X?=
 =?us-ascii?Q?ixfPw9MvRHdk+my0AoTBD1MJIepC6JF2p0TJNBLycLAAfgA/Xse/4Nm+YZ6c?=
 =?us-ascii?Q?IHrQLkKHOXeQKHy1kKB6NmdE/Zy4YcNBfAFjVKS88KpK0HfY2LQPOLT4JaBC?=
 =?us-ascii?Q?nioZeSrUmrDrOnQHgIxCMg+LdZChPp7rpfRZKKYLAIqJUDjH4FxxcP5pOuYg?=
 =?us-ascii?Q?KCN3qVq6Yf8gFFpzwUDBvSGe6Q9r0T9wvnm8bbsgsBIpQnE1oyfrKld5rlIY?=
 =?us-ascii?Q?mpYkZC6jYXLDsfZct+LZZi3eNaE0HTedy62PxKRni2zNqi3hphfAp5HaXZLf?=
 =?us-ascii?Q?0URc/KkB9czU78OjOWWAPPl85o0bPckZ8a5M63SLRWDWva6+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922ad52b-9321-4262-d644-08de8c14dee0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:00.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 266WD5KHk4peCumBkozo90HKnvsTotY/v3J9qQTM79vLui0co9ihXhEKjsI0RNDa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

The spec in Table 14 defines the "Entire Cache" case as having the low
12 bits as zero. Indeed the command format doesn't even have the low
12 bits. Since there is only one user now, fix the constant to have 0
in the low 12 bits instead of 1 and remove the masking.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 2 +-
 drivers/iommu/amd/iommu.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index c685d3771436a2..c239c5fbe47461 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -221,7 +221,7 @@
 #define PPR_STATUS_MASK			0xf
 #define PPR_STATUS_SHIFT		12
 
-#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
+#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7ffffffffffff000ULL
 
 /* macros and definitions for device table entries */
 #define DEV_ENTRY_VALID         0x00
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a3773a145af811..4e057fbc20021e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1287,7 +1287,7 @@ static inline u64 build_inv_address(u64 address, u64 last)
 	 *
 	 */
 	if (unlikely(sz_lg2 > 52))
-		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
+		return CMD_INV_IOMMU_ALL_PAGES_ADDRESS |
 		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
 
 	/*
-- 
2.43.0

