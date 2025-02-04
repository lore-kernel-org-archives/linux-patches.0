Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E32218593;
	Tue,  4 Feb 2025 18:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694114; cv=fail; b=hFJUPjkjsaQzAWQVYRykkHJCSZVxmOLYNR2hBcnwUoeNUNe0SUByKaoLUGTAMi9SMrdkrV3QGnwKrqkNU8PMl6GNtbwKwK7yloTNVVuF70ZFcg2lfaNC8uYKW0q79Et4gdN36NAwC/5BHc8FKO6DsSrxKvTUqb3M+9RJs2UTBFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694114; c=relaxed/simple;
	bh=VMBmlfaiEi7I0AVVqmAO3GBOCrSjq7vUa6VM/QNfRw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bvpfNInaxeRud4gCqkxApVi4kZQzoTGHr12bp2PeUDnemTKsjpMHpRYRDJOcSL2zaAmbdTUdT4wwqAUBBiYOvTLHKWTGn+dsDSKa8/brroniPiZoduC1lx5DkplAE4p6uThUf0Ojch20w/qAvvHboE+hsC4mSyw2IA6pi5cKnCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cb587i1c; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cb587i1c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARRNAAiqA+m0UM4thfq9cS9H5rm81k/5+UFKr9bltB77WB2TFTm7G8CRcgUzCWS6txosMxT2CUTHwL+wb8CmnkD2V+s33fGrus1Ld6nwG+2NXd8zMRceo5YnL6Nmvru+LNDDXdLKggkXECLnGeXYYJofDRWu0PUsz+WGMKPTMpzSEiOBmEDbmIq4Gw4RF2EnGn2VXK++BBHXbaK8oQAvtdzqR+WKIfvR6oKrXSVJtSPxExPQjTjCANyAgo+Nqm25/yZab+gAZtezx1M5wDyse9NCl6vbXAMH4wYnfTL9RMOmWFI1XheY1l8zpNUEOhe13LkCN+C+xoIeKTzpr6lp0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XI2QFCQYcaJ37YwUbMNxNLWLPhB1v7qzHs36uI+mcws=;
 b=jvdvpekFPWvONQwMWfyqVwvaKDS1JcmctfEZinAG3CW5Otyx0Bzovq30YowMKAjQgJWL5owEGKNx81ObmqjYFQe6Znb46XDTJ4rffkyBvoZ4XZ8fK4IIGxuORxgxrg2orgPqQr5EirCwmvn2MeNhKtAilLlDLvM2nFLRNOGZOkWJF91s7U5f4C4flZb3fxn1nC2DCrGH+aFspCq1CZvnwYsUP86s2KdzOdyFhRV+iAasqyqG13DE7AikS9Ucaqpz+dhklcEb+LsTNnHhBruENNMoEd8GvbBp620v5P5RhK4Vz4bjEb3aqXJ0R20e6qFNtQ7ze9o5FyJYXBVg3I9hgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XI2QFCQYcaJ37YwUbMNxNLWLPhB1v7qzHs36uI+mcws=;
 b=cb587i1cXQg7TubuvCyc698DVbQlHaZrI/MqjW9xceytUm95cnCnbaF4pB/YUzveKNIPvjQNuTfTMr7KI+5t+OluJtI3xzoUBVq7fZLWIWuedm4nJaDRulRAeZpWzh8IQjEmanO9vShFnyhFWieuPWOvLh6SVjBoMKY5dz9WzKSHJQ5wj0ZIJrwSefI70dnjL/mb/IY7/3+GyZXOwK8V1HuNLLVq0n8af9fSzzBjOWQRFy/TiWHWA79McVxOzUGBxQElG2d22bDEDmzDdelJpr6ZCNnMXt7b2/L/S+HiqCjkyvqoWKMgm/sS1n1j9asACOBBFZjb8wTjxJ+SppUA7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:04 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
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
	Hector Martin <marcan@marcan.st>,
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
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 17/19] iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
Date: Tue,  4 Feb 2025 14:34:58 -0400
Message-ID: <17-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0011.namprd15.prod.outlook.com
 (2603:10b6:207:17::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3ef6a0-f813-413b-4f44-08dd454aa339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QcZm6u8B5bWoGknIytHa1AfNM8oiw1Irfng0QwGOmuxn0b5uCx1U4MfHqXYm?=
 =?us-ascii?Q?eEDzEcDq4FxcJe+nDTb31I+vdwwCn5xbUzeabLP5um4wuElMe30mYlvryzs/?=
 =?us-ascii?Q?ZPpBqJP1feXeZWxThZsN+6AOWGigz8G5hdfv5uYeuNYN63Bj50PMSbSV2rsc?=
 =?us-ascii?Q?jGkPa88t860paUfmCcqxIEn0QzU/spofnh1XTKZ/aSUdJ5h8agTsFkCX+fvi?=
 =?us-ascii?Q?X8OOir6DHvTQfu05tvAzzmIQFkpWYjbm7N28jRqSG+bKred5mtvP+CdyiS7+?=
 =?us-ascii?Q?dnCl5T07ARJ2JEtThsBiyB/hw4DCffFn8qn7fGFgfABn56mWHy7cJxuaEzdf?=
 =?us-ascii?Q?pIFfhCtJUhvknzAjtG9KdkouKcu/B184MYOkwc1Wb0qi02VxjpGQEc9eN3Tw?=
 =?us-ascii?Q?puvw75qGl+gZsYf6ahkiHFSuDNBEWUYWldkcwFMePAFtQCLeH7NV7xq4fhII?=
 =?us-ascii?Q?n+/rV/P8kbIyjN3Gpapw4rjv3XxnOGJywABPsggzvoTKzSzF/yN+XjdZjqPh?=
 =?us-ascii?Q?BhtoRbjp3ZqyS1OmabXcZwSBj8wImhfH3RZCoSqtEqidgoqxP3SICeADhVVT?=
 =?us-ascii?Q?h8sFoV8aVDvUBvVhPA0SQc+NhgYpwyAWnOeUIXOEdYytfq6iy13FBKt7TzLz?=
 =?us-ascii?Q?WPYjuBpRtblKRJzINWm9pWkIG6X+EAMwut6k2VI+fvIPTLDlPMs45Y9CFxk3?=
 =?us-ascii?Q?OQ6RzrLhy+3dU4EHjweYhLGO25X9D5+qhCjxWz9zuMqbKa1CNGiOma7AzObY?=
 =?us-ascii?Q?xEqKk1dGlw/TGnjpwz//DxfPB5vwnV6hjdvq+GfUN96mEJSqoPpUynYpoWS8?=
 =?us-ascii?Q?y3QLHtCXSo3CPeZpR37tgRAxzmHyFz9pqXSN1RHCGy3mHs5jkU01G8yNZPIi?=
 =?us-ascii?Q?lBKIFobiiTReW2+n/7tq77R+I/FdDqaydhPScLcn8E0yG7E8ZxRvBqFUx3nP?=
 =?us-ascii?Q?ClMFWaI2+8tBbYoArbr0I/x/BhXd003kpTp9ylyCs7kBRJ6EUtgJJiCLtu+4?=
 =?us-ascii?Q?ay+J5jEZJoH/+qV16ooIaHxV6PpYYn0bIZllj9HVSgp81DONXZISvwYfPa6R?=
 =?us-ascii?Q?FselZj7mVf20odlMbIumoxfWLLNCl0LIQ7En6aq1WXn/FIL9B2doOudybfKc?=
 =?us-ascii?Q?pQL+mB+LpwhiPoBHP/dcwtM36qJ34KWe7FkMvN3mLqN/yATITvXPq0+Up5LV?=
 =?us-ascii?Q?rZdUi0K5lYDjvcYwW2gp5fF3hpBALHOF1DJR/Y+K7wVa0is26mjOKRRpRz+h?=
 =?us-ascii?Q?hYK0tRqtKR6JL8lrlOHUnKQna21vEffUjYkjX0lSKxXpdypJDb/41AnAMlnM?=
 =?us-ascii?Q?p4gcu8aaYGDCJxfqRKcfeLKBViNSHU8dQGduMO6uGJWXOQOuB7pglMA2iPTf?=
 =?us-ascii?Q?BL6Jtg7+oPOwvjhz0BVPcp1/BQniaPMEsn0pShYu4RlvMRgELdNqvHGblUzr?=
 =?us-ascii?Q?GqPqIXqLzOY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YtOdVm+GGvOQxnMLgII+sltumZqSsMrUqcv1vPE/A6c1E/LNmQkDH4Uhj7Co?=
 =?us-ascii?Q?wyyBnLE3yiXKOTxQxyAIrwEBIILhWJD0LdGc/45JQ5EMBo9xaNSWjB9JJa++?=
 =?us-ascii?Q?57z2dlsU97UyYG9GAsi+79GvuYbFSEmEnYuz1j6JTG095fxACKwnmBw7DmFg?=
 =?us-ascii?Q?ggASV9ST+KV9sjcLRbne+iiQCagYmbZYt3zx4lPRAwuj0VHGRjmN/Taoz/72?=
 =?us-ascii?Q?9e1zg/8BYQtHSTBtBG/RT8//P8RoilMSdvzPryesSvdxGeivrvc/6S+SsOt0?=
 =?us-ascii?Q?nLDDavBHrtww08De1dnyXjp7OT5WAhHbFVvptz28x+U7gxigXws8uA3WhEKe?=
 =?us-ascii?Q?7v8k3LVNidK900IFp41BOA9aVqAN+vrHvChy+Eg7ngCRtQ4PEh7+fR28Z2Eg?=
 =?us-ascii?Q?2W3KYPuTQ2EjRet7By2lY6xt9YAgyNZ2/8QR8gm+w+CqvPNpIuESEyCEdmNx?=
 =?us-ascii?Q?YEcf0ArMNerQ+Sfi1TrXxa7nqXLev8s+4JGY3YFDtBpB+WSHJsVtbZgG8UrP?=
 =?us-ascii?Q?yMBC2IFwu6EBxWhacxA5ZSs8Uvs8ZjcxtPQpDtpXqHr0iVnD3LzeDJVvchGs?=
 =?us-ascii?Q?FaqtpcAAj9+i4AgmLyu6tX2n9JDK4BDgTI5VoZp8be1fjLhWGr2Np6KZKSa+?=
 =?us-ascii?Q?EULUGddgPr2Jaq2zUorwOEQT1yfOrCxaRRjY0au2GxZJo/gPGoOEzrtA5gqd?=
 =?us-ascii?Q?fu7FcpjROyg6ElQ2AcvOD1UiuSwrZpGwDzbsRYUJMirmbI1IGK6gvLqKvhmD?=
 =?us-ascii?Q?5YAsCZnbJr71+UvLUpd/z/apXA2EKpa6Pe/ZWJYjHnR6FQxpTbibc+eUSRz/?=
 =?us-ascii?Q?cJeOyEzUc1ltMgqwoH2AgJIbWzKGMhmeGUxoN46Tx4ndEuYdjOilXq9sxFyo?=
 =?us-ascii?Q?PhBp7eYbwKJRJ3Ge6Ejct7X87NsXTQCeS3pWOuMnhKOUTX4z0SH4UjCOGUWG?=
 =?us-ascii?Q?WVuFizbz/trrDmfffvTNPke9FgecuPgNrmxfw0nqb5rdyJg2fSdgrjqDAS/5?=
 =?us-ascii?Q?vaeua1kRsFoM4mJy2zDKj8GCddBLSyHW9EfQFqQpqfkPRsLu0fF8sC4cL6b2?=
 =?us-ascii?Q?4J/C3Gy7VBcGC91RLP9dyJM7va5b8Vnv8xEL9ExmqKX8k7jn0ltmTLcYN+fZ?=
 =?us-ascii?Q?Xxc6koVwZqGB6SSc7SLdsBvxn1dHVFxQPPasvZgVywCGJd9r42080AzlkkBM?=
 =?us-ascii?Q?lHFXFehWRBk4virruAIjdRyfr2eF5hBF2iTZQ5XVh9I0EqpPPa4GwxHtk5gj?=
 =?us-ascii?Q?FnrdrMQHT2+cnrwHZNjotPxJU8lbeDuZDNw6xqOpM242tBF9giuyoGq9IaLE?=
 =?us-ascii?Q?xeDh+062Q814PpHMKPQ9RogmPeJZFMG6U34YwuRKouLxfaiXOYl4OdBjJURa?=
 =?us-ascii?Q?TjrMPCF1OgXRsGESBsrDpG0p75utbAqnBcQmsyczZc/5jGPB/YSckzpptupD?=
 =?us-ascii?Q?cYQfO62WwdQyFKPJpMmfDXQ9BoN9zWVSEb37HEzyyU+TwwJ5N1D1VFOBhDvS?=
 =?us-ascii?Q?WLwBCAvbP7Rtizy1f0L+bt9q0L6GJoAB0c3E8tamE3m3lrpVGLMgjZDYeB3J?=
 =?us-ascii?Q?l5LXLxw3Wn67oXASlQk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3ef6a0-f813-413b-4f44-08dd454aa339
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:02.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrrrxG2k4D6XJbObhw0DDEADNzZSXFG5wtzLxT8EfyGHYquTTvlCZEQG7qRMaVO8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

One part of RISCV already has a computed size, the other part seems to use
PAGE_SIZE (which is probably SZ_4K?). Convert the call.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 549bd8d0615d75..b7cee3d651b179 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -65,13 +65,15 @@ static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p
 	return devres->addr == target->addr;
 }
 
-static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
+static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu,
+				   unsigned int size)
 {
 	struct riscv_iommu_devres *devres;
 	void *addr;
 
-	addr = iommu_alloc_pages_node(dev_to_node(iommu->dev),
-				      GFP_KERNEL_ACCOUNT, order);
+	addr = iommu_alloc_pages_node_lg2(dev_to_node(iommu->dev),
+					  GFP_KERNEL_ACCOUNT,
+					  order_base_2(size));
 	if (unlikely(!addr))
 		return NULL;
 
@@ -161,9 +163,8 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	} else {
 		do {
 			const size_t queue_size = entry_size << (logsz + 1);
-			const int order = get_order(queue_size);
 
-			queue->base = riscv_iommu_get_pages(iommu, order);
+			queue->base = riscv_iommu_get_pages(iommu, queue_size);
 			queue->phys = __pa(queue->base);
 		} while (!queue->base && logsz-- > 0);
 	}
@@ -618,7 +619,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
 				break;
 			}
 
-			ptr = riscv_iommu_get_pages(iommu, 0);
+			ptr = riscv_iommu_get_pages(iommu, PAGE_SIZE);
 			if (!ptr)
 				return NULL;
 
@@ -698,7 +699,7 @@ static int riscv_iommu_iodir_alloc(struct riscv_iommu_device *iommu)
 	}
 
 	if (!iommu->ddt_root) {
-		iommu->ddt_root = riscv_iommu_get_pages(iommu, 0);
+		iommu->ddt_root = riscv_iommu_get_pages(iommu, PAGE_SIZE);
 		iommu->ddt_phys = __pa(iommu->ddt_root);
 	}
 
-- 
2.43.0

