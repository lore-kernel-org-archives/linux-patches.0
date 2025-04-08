Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F123C8C6;
	Tue,  8 Apr 2025 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131273; cv=fail; b=j+yj52h6I5E+IQ64plPzkxYOrKwauQqtH+2fo/8cxTye74LW/Sk4qyiBm625Lv7XItRiVImWIBnY6oGV1eMTJAO9xHcEfiQ45ZzoRD7jU6bvjlzRDVhqrHA7EdBqQuSMjzJL8ipV0aZIyh1f3xhQVwLsl+U4qE009yh3fyjKarw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131273; c=relaxed/simple;
	bh=24gCTQdo0YAh1aA/6cYdTGLGDznW8DM8EX7rH5X2/go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uIoWUV9GvVlUWPANSvoEES/mgi4KqJMVkcPkdWC9OkyHcWUTvSvMouLQPSrj8UzOwY2F4tcjTag8zcvvE/zAXXz/wGQWJSSWtIK7lEeviW7YttkCAmIooBwV8MRRiowQllfDuO1qxVFv6Ii9MAWo9UChceZdFLaO0qixj4YVj2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ixthdzOn; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ixthdzOn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHfbaOd8Mpg8N898PwacH4TIA2Gqv+mTPweO/fpdAE7Fu6wnKCTQoY2dSaIQ7E/LrHGqGE+prctrOlZ9/Ph7yN6U3iZt9PCsp4DogyAbxioX5cTbl9LYnRTMyW78IZnZ7+lD1OSFVW+3fJc+NyPNN2j+rsROL8zg2XGFkh+9pLqxNuz8/DiCibRkNEkehUtCe1yM419f+FtMfRWCMF1xq0Ex2ksmqv8p0qoIEg9YkY32surv0mbeHNTpXSCbRbxC2WJR+//zu0q5IT9CiLJkp7RHLBAE1ppEdHZeMzO2HHnZIioJHnXxJX1kgRog4+zsllRG8X3RRJkKzQKk/mfIPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPvMGbLhos2V2r74nd1APsYEb/OQ0T8Z8Q67ZKZwVMc=;
 b=yalrW8O9ZOOt6t9RTc0tSbZSAHRrgTdFzmMb7eRZ1UkCTV623jSjq3dTNS76oBrslXT7rG/aNcA7wAYXoL3CU+aGLGQi2ePcvttB0xtj6LGS5O8BSepHEfw4sIQ+XUH9bJD2oc6/CZWR883j5JKzmpNQvIICIfpytT1ZIj0bXMycp5WkSBUpHuEb9yZR2tfqIeiQN7cwQgVO5TBz0jTW3B9PyUu7VIgH47V7emsfLq8DqMdlt2/poNZkbuvj9AdIhi4Pd0Y1OlJSf5DyoSUjIRzxup09zV65sFWMVVYWcnKbgIInzeppQf5t0Xu+dUfRe7ZVfvTPVvtFxqR3pYPDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPvMGbLhos2V2r74nd1APsYEb/OQ0T8Z8Q67ZKZwVMc=;
 b=ixthdzOnQt+umnAklFBCenYrgrEcmJZTbEt9b3nEPBC/yqVFTcwkPd8YEpFs+6l/hEf26UOFDsL82/A9BDcjHH3ISOvSpmtuG9SH/B+JSNKg3b6sZOP/gmNagMxievSGtHtvFV8FDmfItECNF/k/5cCNzfvpM5W8EL3Tb1sVyfR6DdrwyQnWdhCRrJXFes4ExdNuUgdwHTpNf4pvUqLoBQ9kdCWNHOtDH+svu2jqxg7JjW8q/iCtNrrVvDvcyb/afhFUYQFV9bSjbxH7aXNPcmince/7K4fpUi5ryqW+N1tjAHfqGSACVa1L7otlvw1wCCbVgg9bnupy04n4iyIhrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 11/23] iommu: Change iommu_iotlb_gather to use iommu_page_list
Date: Tue,  8 Apr 2025 13:53:59 -0300
Message-ID: <11-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:408:60::38) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: b307dce0-46e2-48d0-da97-08dd76bdff11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IaRNqSrJt/rOaRJXirK2AHvez46gio9Aq/cKKybiDIJf4frzx3mq/GAJ+FVA?=
 =?us-ascii?Q?eLFXS10e0Zbi+hhz8ZqgHwxhN+p0E25DLR0zOLcJ78AMrdoX30tpawATvTtd?=
 =?us-ascii?Q?ihHHInfuTlUSeQBz7TOO7+Yz8h6mug6esr7S+SObCKLlyCiBzhlLVOrhAPPH?=
 =?us-ascii?Q?079sMuXOkP6DH5Gi8cXQMt/5JxlOiGXdXSqOKM7xZCnOCK60+n6PNSjC4MOP?=
 =?us-ascii?Q?HLLMo58cba1I7+YnJBeZn1cxDGPDMptYBF7VrBdQjNtShHlvXsXDFaXIny/j?=
 =?us-ascii?Q?Bqwa56e2g64myNV7Jn/S41fZVLLvkVD+YtiXuSGUCDALhcxWD9XyiZV9xjLf?=
 =?us-ascii?Q?WdCQ/LSiOHO7YoPLvXLuyxSRseXtkwPYnCXqALqSH0oki13bjy4uW+WAc/kO?=
 =?us-ascii?Q?hJaAOI7uWSPtScqM6pYXPeZVc4o3KPBpPu+k+6PWQxyFuyknN/WhVg36QSR5?=
 =?us-ascii?Q?KQ1wrUfYQd3iIkqz4VkUli3UF0pKPTAaSftH0xBtHmBSdePS+s9eQXGKMnd/?=
 =?us-ascii?Q?8PbJbLdxJbN3C9k4LmeVeD9HURJ6l8ZwcHgiEyLluuIAk3NHnRvEckBY6Gux?=
 =?us-ascii?Q?Dadvbgy1D0CwZBvGJpLR+inRaHtGE8CixQILVPYwBj0r9AnaLpYNiGueUYKs?=
 =?us-ascii?Q?b1RLVgigvtgr8jtsC1LAZ8TaEB/yrMhlYTqMBe6nIUgW31UYcvbELRkCwfPX?=
 =?us-ascii?Q?2dY0apuY0mOuTJ+jgHqC+mTJWtvUd4LsIMjTlmF5EgMDuFAm9e8iqh120NaP?=
 =?us-ascii?Q?cFAMzxzUHwn5BSO8rglbUTdHbAS18kjWLEAorL1ZlXJZpr4t8d9zZvyzogAO?=
 =?us-ascii?Q?g/84l4y00+jojU4qUt1G3JMlAJB2hkK4dQ8ROP763QNaGCUiI1G/dxLMEhAx?=
 =?us-ascii?Q?tigQ6wmDfjJsJ7LY9h9YfmCQhEYZIIgIJhRXS46dz0+CEufJ1kkHZyb4bLsS?=
 =?us-ascii?Q?qhhAR5JWsFCpX5Z/eIJFsFtKVxY17YtNVfI8LJUcJt+IeaI1cH3XI8gu2a2v?=
 =?us-ascii?Q?YszxrLNMyYZkEMH2VpCIrFBGp+4Jftx2Qbm2G6iON1ZvyoaxsriD6IlS40pX?=
 =?us-ascii?Q?3qisAzhb6CBWwwtUSR4dtrZAn8v0jKdrIkWMx7d977kGYPpreHND4clTn7Qq?=
 =?us-ascii?Q?RJ+mCDO+54NpLSLDyANuDLx+qz7rtQR4Ytqr4CTB24i9EuwTtyzBFeG8qAUA?=
 =?us-ascii?Q?zakoORDTYOGFZLVq3eweVfqp3vhnmKZPhSZJmUxuZjTJxZesTVUHrojrbHlZ?=
 =?us-ascii?Q?QeuABZ56cT+6bBFogBFhksYMUlj0/ka+wXm7k4W5QKnnp0Xm8792nH3Dewif?=
 =?us-ascii?Q?jLQlD9rHYSKnKMlv3P1SsvIDgt55YULySVMlZf2kDuMaPIIQ1KcoKm2IbNhe?=
 =?us-ascii?Q?zSZDdDH8UH4JsJiKQtrliZ7+QcpVrd8BC+6APW8q/c/kDbAfeMDglxLC6U0i?=
 =?us-ascii?Q?rx6l1z7dWBYu/0Q39ajq+QuF0aLQ0RZyBlD6ajqOw05FANnMhgqVBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gZs2h3+cMb78H8R8RdKt2k+NaFMvMtDQ3Z34VKKiK0pnrEQfCl9F1mgCK8Da?=
 =?us-ascii?Q?ogQTu228B8c3xTvF2B+ipBCRc78p2jbusW3krf6ycNjztS1GFj2xcEHSeDRZ?=
 =?us-ascii?Q?DkcnIpvNYNZ4n16zIfINJvlJf5w+++DGYg1fr5VdRX0jl28W9afVaLcfjaFT?=
 =?us-ascii?Q?57GFq1QsqskWw6BuYE2n9S51NAi9aSO8dGeev3gHFQJRKWKxcI6YwL5k6A3F?=
 =?us-ascii?Q?Ze0QHPYJ0docnfb6KbhQRilO8/nWOdcK9KOGK015t7a24jjWB1igJavpfVBq?=
 =?us-ascii?Q?f1uF79I3XlKBa1KGihjKSeftuIQsOeu6qSq7Dsjztb962MB4eKk1hkKSktvN?=
 =?us-ascii?Q?R3pv2eD6auQoeXebZq+9h2KPV8oQS1od47tJ0buFu0f3sjrsLzrllm+kRkT1?=
 =?us-ascii?Q?DGMPNErnCqwz51jyztW17rdNxogn6/X1uyj9sDac2M6qz8X95dOHhfKTM2o9?=
 =?us-ascii?Q?eSSSGa4uVTAwuw2FQ23BcTYzrS02LAHR8z1Vtia2MCfqhITggUsx8SNC9XsF?=
 =?us-ascii?Q?P7P0Hcg+T6fdv0LpXpxkhiP8Apa2DkL0MwZrhI7MxCGsOtN7oHAOvyWxyNnj?=
 =?us-ascii?Q?HSFEq6wuMSAXHmEwiesIVabppwce7bPW5nZxLPfbCKlbiK4z7JKfmLPv4k7R?=
 =?us-ascii?Q?sm+kPNDkJFi+gF3JDWDy0o/oXSlijoTqiLj/kmiH5mF2hdCtWyDCTR6d5B2s?=
 =?us-ascii?Q?tvXbJ2n/1ZWTEci9BgeMM2SgBxR7L7imS/4dhg7K9QGUtNS29H/x9gYlq/OT?=
 =?us-ascii?Q?1ekrtSxOTtP4CNmH2fQlIX5aXYRzyo2hRpoB8QQQewoLjNcHXgRT3asTmJJz?=
 =?us-ascii?Q?8zSGLoiVe1AByP2vUuxJiFImUI0cUdCauKrUHsG842o44/qdhyF1EXXmH70P?=
 =?us-ascii?Q?YFSSunywTWcNguUxwcmjqA4Sa3/emm3p7p9SznR0Uu5nWRRcUqOk/d1sxhN9?=
 =?us-ascii?Q?YW7Cm7SZ4YyurMwQQXmIgEwWgsNwo1uVkuDkvWWKgpNKgF5odQtKy3LZyv+P?=
 =?us-ascii?Q?LEoQvqiYbUTbAL0TBwUOsxR5gXUeMJFN0AOhMS2Yqb4IKFoUgwYZB1XVZB9z?=
 =?us-ascii?Q?F/TiQiS5LCC05lJymB6pDL6xcIvmzHLSnXVvTjzaM33Sz4yAe7bHma50vXj6?=
 =?us-ascii?Q?QYDP8HKv7HUogPIKIuN0avDDf8gesfdbcWrFvz3xzzHOENAVhuhsANqcF03r?=
 =?us-ascii?Q?zrQqirdwYTJsNhvpiRrXiXLNuf1R1mAQlbGbjk6kVij7MR5zcpsj8Ba5muvo?=
 =?us-ascii?Q?Wp5o/MeB2q1IYqbKHlWZfyvz585C5hIiSVWj5d0MxMCact/j45qoM1lrsn75?=
 =?us-ascii?Q?FwyMgUWHCjeO0WM2U3cwxHFjpQYUjZsLWCja6W4GFhvOFCX7KQOidZHX5Yv+?=
 =?us-ascii?Q?wX2aE+2uEIf77TOq0onp7/GyjAC67S52QL0jcK3pbgA1tMmRZoqf7sO8UiDx?=
 =?us-ascii?Q?DYhx5t042wQn7CqZnQqmjHFMp97Nh6jPHETBHX5Li7LZa39uPEeYiIhoTuFJ?=
 =?us-ascii?Q?26YGazRbvUHfNugSTCSIvPNA7eI1mRaBXfPlbaBmHTD/cI57FZtVj6iomdsL?=
 =?us-ascii?Q?2X7t3oPIkK2ubCq5sgYWUxwqr9Q9iJsX/UUh79fG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b307dce0-46e2-48d0-da97-08dd76bdff11
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:16.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0nz+WtMnI88mejhOtClfgS55Drwg90juIUI7jwmsUmmA816olGEtTRn5TdbrQas
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

This converts the remaining places using list of pages to the new API.

The Intel free path was shared with its gather path, so it is converted at
the same time.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c   |  9 +++++----
 drivers/iommu/intel/iommu.c | 24 ++++++++++++------------
 include/linux/iommu.h       |  4 ++--
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index cb7e29dcac15ac..6bfa9ab3987c4b 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -105,7 +105,7 @@ early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 struct iova_fq_entry {
 	unsigned long iova_pfn;
 	unsigned long pages;
-	struct list_head freelist;
+	struct iommu_pages_list freelist;
 	u64 counter; /* Flush counter when this entry was added */
 };
 
@@ -192,7 +192,7 @@ static void fq_flush_timeout(struct timer_list *t)
 
 static void queue_iova(struct iommu_dma_cookie *cookie,
 		unsigned long pfn, unsigned long pages,
-		struct list_head *freelist)
+		struct iommu_pages_list *freelist)
 {
 	struct iova_fq *fq;
 	unsigned long flags;
@@ -231,7 +231,7 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 	fq->entries[idx].iova_pfn = pfn;
 	fq->entries[idx].pages    = pages;
 	fq->entries[idx].counter  = atomic64_read(&cookie->fq_flush_start_cnt);
-	list_splice(freelist, &fq->entries[idx].freelist);
+	iommu_pages_list_splice(freelist, &fq->entries[idx].freelist);
 
 	spin_unlock_irqrestore(&fq->lock, flags);
 
@@ -289,7 +289,8 @@ static void iommu_dma_init_one_fq(struct iova_fq *fq, size_t fq_size)
 	spin_lock_init(&fq->lock);
 
 	for (i = 0; i < fq_size; i++)
-		INIT_LIST_HEAD(&fq->entries[i].freelist);
+		fq->entries[i].freelist =
+			IOMMU_PAGES_LIST_INIT(fq->entries[i].freelist);
 }
 
 static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0877bc6d8094e7..4ca74a2b1a1109 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -894,18 +894,16 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
    The 'pte' argument is the *parent* PTE, pointing to the page that is to
    be freed. */
 static void dma_pte_list_pagetables(struct dmar_domain *domain,
-				    int level, struct dma_pte *pte,
-				    struct list_head *freelist)
+				    int level, struct dma_pte *parent_pte,
+				    struct iommu_pages_list *freelist)
 {
-	struct page *pg;
+	struct dma_pte *pte = phys_to_virt(dma_pte_addr(parent_pte));
 
-	pg = pfn_to_page(dma_pte_addr(pte) >> PAGE_SHIFT);
-	list_add_tail(&pg->lru, freelist);
+	iommu_pages_list_add(freelist, pte);
 
 	if (level == 1)
 		return;
 
-	pte = page_address(pg);
 	do {
 		if (dma_pte_present(pte) && !dma_pte_superpage(pte))
 			dma_pte_list_pagetables(domain, level - 1, pte, freelist);
@@ -916,7 +914,7 @@ static void dma_pte_list_pagetables(struct dmar_domain *domain,
 static void dma_pte_clear_level(struct dmar_domain *domain, int level,
 				struct dma_pte *pte, unsigned long pfn,
 				unsigned long start_pfn, unsigned long last_pfn,
-				struct list_head *freelist)
+				struct iommu_pages_list *freelist)
 {
 	struct dma_pte *first_pte = NULL, *last_pte = NULL;
 
@@ -961,7 +959,8 @@ static void dma_pte_clear_level(struct dmar_domain *domain, int level,
    the page tables, and may have cached the intermediate levels. The
    pages can only be freed after the IOTLB flush has been done. */
 static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
-			 unsigned long last_pfn, struct list_head *freelist)
+			 unsigned long last_pfn,
+			 struct iommu_pages_list *freelist)
 {
 	if (WARN_ON(!domain_pfn_supported(domain, last_pfn)) ||
 	    WARN_ON(start_pfn > last_pfn))
@@ -973,8 +972,7 @@ static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		struct page *pgd_page = virt_to_page(domain->pgd);
-		list_add_tail(&pgd_page->lru, freelist);
+		iommu_pages_list_add(freelist, domain->pgd);
 		domain->pgd = NULL;
 	}
 }
@@ -1449,7 +1447,8 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 static void domain_exit(struct dmar_domain *domain)
 {
 	if (domain->pgd) {
-		LIST_HEAD(freelist);
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
 
 		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
 		iommu_put_pages_list(&freelist);
@@ -3603,7 +3602,8 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
 	cache_tag_flush_range(to_dmar_domain(domain), gather->start,
-			      gather->end, list_empty(&gather->freelist));
+			      gather->end,
+			      iommu_pages_list_empty(&gather->freelist));
 	iommu_put_pages_list(&gather->freelist);
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6dd3a221c5bc66..3fb62165db1992 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -375,7 +375,7 @@ struct iommu_iotlb_gather {
 	unsigned long		start;
 	unsigned long		end;
 	size_t			pgsize;
-	struct list_head	freelist;
+	struct iommu_pages_list	freelist;
 	bool			queued;
 };
 
@@ -864,7 +864,7 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 {
 	*gather = (struct iommu_iotlb_gather) {
 		.start	= ULONG_MAX,
-		.freelist = LIST_HEAD_INIT(gather->freelist),
+		.freelist = IOMMU_PAGES_LIST_INIT(gather->freelist),
 	};
 }
 
-- 
2.43.0

