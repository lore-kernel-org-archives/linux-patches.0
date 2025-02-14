Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBA12686AD;
	Fri, 14 Feb 2025 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552907; cv=fail; b=tfGPjW8rQDdLyfj1+kLfcHLKzA+r4JjEHoDbXOkug/l7ld99ogCfv4gsSkMrOmxpXusMTyIDuNcoXwlVJ6ZiTxCJ9BnbaQyKpo87wtdhyzD4WDPVNyYljwmNKZ3pUDFaJk1+Gxcf5ENvgGc4FKI2GYfCN9LKhzbXsPn0+XKk7go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552907; c=relaxed/simple;
	bh=Ev0L4lKsC3mq2qYttVTsH67GvrXamXzIzm+whKkQnSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rDbPmXjE3Yo5LN7sxyrfo7taV1ZpJJ5U3HstCIXpyRO+z51n8aa5xrc87fM/fgNaZUfTZd4V40+YrFyR76E3VQ/G1XFGR4ZXJ3N8HkvfssgLF4VpK4oqSdUgbWw31JIJX7QCVw7c9PPy4Dl/C9X++h0oVd6FA44EANabJ5uxmUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y96s/oR7; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y96s/oR7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAj3tragpEBRV5M+pXwkm6PqAxdAKAnC35NSEPZ1TMDgAfA6ppFuq4P31KWy4NghnGbZ/ZEljLR+bK8ApccazxLzlX1xSRB9Qdh5s7f7BMpSIbP2kakfaGXQJeSbWpKq9yH8vIyw2AYpLiqBrRI8us879gzF3Uv1K0Rd+ofQR+UMHW2lyS0Y9xfzJEuN8qnk3hjSSaHvHdJ/Nf/dMtKaofnsO34Zb6aktLWXDShk1b+EvaCSayyPoqB+LCp/8Z7X2WX5XFIQ4Eu2THAmi/3n230w8pJMnVyMUt4RLNPA89LKri1gXDe4JctJvMyyTdmDh44UFJxfEmfJqBiHcXDK3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3L6NKirpU3Wg6PfUaO73ivGjryAKJHvWWrYxrsf0Vvk=;
 b=wAP/UWPHz/vHJCAebAsGY8EQnhIYY7ui9I1o685tSqoe+LEKpFZlfs0xJsGul6jr1P2PbvDzh9lL/Z0wXRvu99Mbxj220KIu59GMESoE/ObeO7dW6Kb8bUYeUNTFEwzehqpwVf6bqbV/cgdDlgT4WgIEpTrUEhv1HoxoK29WX0SKMG41PESvpzArC14nG0q0C61HBe8IZFzC4uxMsKYMYp5nhomUhoyAd06GWeisJrZXZKdb61EW7QVQ+VhO3QhaKMLvmK+B2brkega2wApUEQSy1OULs+VR/kLiELYvCD18AY5cDbynv9iKYMt07jOc439nZDY9bcuII1JFDi3Nag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3L6NKirpU3Wg6PfUaO73ivGjryAKJHvWWrYxrsf0Vvk=;
 b=Y96s/oR7eRMPHbcIkWKfVtmhCKj9MTHqe50ooGT/+nTstXwG99Uif9KpW+fcFx/fpMkrDOUo4hYAjYP3APrMqb380HxU42QzOXehPr4Nh1BM/447MXONqhk6cHGOgAynwN1QsjQ25Nq7UHPYfR4SeM5kjt826pSvKOv8zoEtq9PCzuaEQU3HL+m4rQ816ApLhg+BfbBWa2qh7yR+VZvRRHkCylWV/nPtZq0T5Cysk4I9/nMfh0ZoLgrjGkgVUUXr4/yMAbdSszbDf2ibiZZ8+kjyiVJOi/ECNAZ62feU0C3wzV+z+JoPo14gg1EkcgaGKBEWiXLA0jURiXhiqWwENA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:10 +0000
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
Subject: [PATCH v2 23/23] iommu/pages: Remove iommu_alloc_pages_node()
Date: Fri, 14 Feb 2025 13:07:56 -0400
Message-ID: <23-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0006.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 446446d9-1a95-4e08-d867-08dd4d1a22b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/k1sKBH5cGUtxfSrsEypO++t5RupOF1I2BUmbA3O+GO/YcTDt1w5PCYC3OYw?=
 =?us-ascii?Q?qNR+uI0nn5e+EnCqjveuJfJ30BQKoP1p2JPDbEs344nn6iHCPK3gSvEUjDJa?=
 =?us-ascii?Q?Vo1HzJQHvkJYh02vLGZ++DD8r2ZiO6uaWy//4sqeEiOfTEWx31XephVxIlAt?=
 =?us-ascii?Q?XKG2pwqpc8AUdhHkdu8Z46PLEPeyQ8zXT3fNxoF+DoKFUkOGhD17EFOzJjg6?=
 =?us-ascii?Q?ApAAcJh42ZG/JrM6sH6JSi3JD0qkYkBasx++Ia7cigFmME3zvx1Ld5rUMkzH?=
 =?us-ascii?Q?jySd/Dt+T3FKETWVk9h5v2I8/YoRWVd9rN/FJjNO01jDH6UJ4XlNqYj8/9wg?=
 =?us-ascii?Q?+4/GhsoL8qws4/k6fGksfILa0raE2j8CFWshvS6sLfPP888RHekmVliajN7S?=
 =?us-ascii?Q?RxJhx8PcM9X/f88Opt13s85UM14HbQvhp4q8nGcrAil9Gx2OTm+3YC6RLxsj?=
 =?us-ascii?Q?njU7VNSLGbfBmadZZ9VNA0+OpoQaclAsDSidKptUgReBwRdJ5+mG8YpMeua9?=
 =?us-ascii?Q?dnjP9r1hJzUsqkOTxOzL3CWaaR4FlxwB33lyup/gzDUns9Q+prtxC2cyNksy?=
 =?us-ascii?Q?ETCmUpLD2+dp0RXkSSQyJoUzPBYZ3YbNWEow6amQOr0bFt+7KHIKpVKioiJ2?=
 =?us-ascii?Q?AjNnIDPYuExgCxdqmfA2L7BLL9f4LXS5qQT/sCWEC1MNoezWrKa9Gz4tdkrT?=
 =?us-ascii?Q?BQAvCCWqkcjR1fb8ry4aZc8m04kJOGlEL++5Z1XLmSw8Ym2mHacqbnSEnRbx?=
 =?us-ascii?Q?PFJ8UKdE1Uw9FdPg6IDfg8lFJckyY9i/8teDFUPU6aEuAZ02UDUmQpVnzJTv?=
 =?us-ascii?Q?xE1gAQcPsDPtnBO5K/gF5yZ88CM6Xj1D9nUSLNPBlOv23fyLHeUnstuo/PCS?=
 =?us-ascii?Q?D/9eyWlwqnjGn/qc8HD0vjOe7AzRyYkwuic8FZW0QXcWxG4anG/+T9zhE44c?=
 =?us-ascii?Q?IVJBc878pwQhgg0eL2RkYWlqXUFmDf1/PX+ukHeu4Ez2qeSZSDhz0kUeka9B?=
 =?us-ascii?Q?jXlTsOmViM1la38foYDRJnn99kpziqKyKTcnYFvWSOoEeZ47puyPn0AY3FnM?=
 =?us-ascii?Q?TBsRC2EgUj1pThKm84huIrzFrwVzqI9tqwiJdzA3ZOBrm2viM6TRQ3v87Mxm?=
 =?us-ascii?Q?cBJmFjhxaDhdqoEWJRxlDcg+/r8o3ESZKZzecsy7OiSx7Cy8TsWfVvEHldi9?=
 =?us-ascii?Q?KdjVVZH+aqywr0FbmW0PntafO+n07AL4LCC8RL1StD361pXc/qBAikCi5Z0+?=
 =?us-ascii?Q?31jG8Wc05aVgr1zcOEhn6pvIhG4yBShqgoFDoxKbG3uQ/yiDHPtWZxKzF96C?=
 =?us-ascii?Q?th6M+WzMLeZuVIiYnWK3qHWLKzzCGIyB3R8DZonGyqxGsNht4uEOBih+R9bG?=
 =?us-ascii?Q?ZY2FO9TyzWUaIoX/rI71peJyhSFipUYeqaPfUI+5wwT5H1IbXJeMWNNQHNqi?=
 =?us-ascii?Q?onwu1ZeTMYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j4SPL3SG563LTcBDUGAs2Ymh5sIi/ENecErBQ45rFIR33oDLPyaQ8a3XahLp?=
 =?us-ascii?Q?joOn6I9DO2WseqkPmtcvaVDmX87fVRKkVXICEGpdXwN77xwj6dKudFTS+Qcr?=
 =?us-ascii?Q?G1mauvZwyKQ54Bwmt7ubzCl7WNXaWyQrt9KuI2YW2eaJKlQNCE2aKCBoWWh8?=
 =?us-ascii?Q?p4opKJOmPq4NqO8Ff0j/liBOOlGVO/Nk424CqGRbmsm7IYcEkW+HYCZ3jMys?=
 =?us-ascii?Q?OhYdDlEyhDaYhMXyGCuvmFK0HDE9zf/G+KEykI9wN3AxudQ0P0OG9ZL9rvKP?=
 =?us-ascii?Q?3Zx9iwoVFXomERoZh6KoaB2I1+WLcKvweA/cBkmaeIUurNjDF/fuuXfen1cO?=
 =?us-ascii?Q?GqX8MrpqS1qUrA/MDE10S4tEm7H5ERiPq/vnQAiJy0loL4SsausdShMRumfi?=
 =?us-ascii?Q?6SpX6HMbH3lybT6Hd8tIQn0/D4UxUk8b0ZpEH3SuJZfET9Srr3PaDDZlLv4T?=
 =?us-ascii?Q?YMT6LiN9UagEiX/sKlLns/VjW0i6zU2feadx6QY5eoc+TphKLz46MC/P+J3Q?=
 =?us-ascii?Q?nTGC7pG6iWR10WryUkdJICYhrBwB37Er8ijjTx9e+xP2QFG09XsCN+IGx85S?=
 =?us-ascii?Q?wA+B5sC/sEiJTRNySr6xUwpwnXH/T0xMuxEG5VKW61t4VjysDFrpXX6mBHb4?=
 =?us-ascii?Q?QMpfKzYucurCVrqbbocTIY8l8Dl2fOg11AQVu3tJqiCQ7lCEUmPJRjsawL5j?=
 =?us-ascii?Q?3vW3K/68kAjW3hZzSJ0HMi5X24bex3TXJUeon9HqTHA51VjBbonkUjbk+dBd?=
 =?us-ascii?Q?LJcjI/lbTvXY8keZ9sbJ2xJXTYYnssobCSYKwNBs8kRe86Vld2PN2ARD993E?=
 =?us-ascii?Q?RetQYyldDspFQFUOQwhKq16oGpw/pGruf1K0dpUsUBAsBcI/amSTIGs/j+QA?=
 =?us-ascii?Q?1NgHlkN206z//wjRYlnokuzHjg8iG+vWIY45XBJbRCjP3H/E31b/NT2/M05M?=
 =?us-ascii?Q?YfYg4QDb29BOAdYacwmfalpczKoAW5Y0A+8Mi/i6IFp/sdT7ix9hWX7sEqiF?=
 =?us-ascii?Q?Qo3PAOqEKQ+a6VzOnjP9M0p8TW3D1tz5rV5+0U78fBECJFSx6a8mTE2X9h0E?=
 =?us-ascii?Q?AKD/9ZRqu50eHZz220Iz9V3QniZtl4M6V45v8aFDPapznKhrzDS9l3bO29Hg?=
 =?us-ascii?Q?wTLUujMh40ckFhjohGBvu5UVeZ1xIyJpON0J98bkOtsi74Zrauj+LiLqx5QV?=
 =?us-ascii?Q?0vPc2wV9ORGDx3wPgn49rypeJ+taWDeFL9OpfQ0YrJcgg7JiluzJfbyo1ENw?=
 =?us-ascii?Q?krRLuwdHbpuc7RR4qIJGxvwTm3Q4BkzD9yPXK0OOL7RJQKWMNZhLJzF8xOHn?=
 =?us-ascii?Q?sTkG6HBewWUqlFX9OigIJc/f7eXvOstxfZJnxDBNokRaNxdaBNcN6+hur04h?=
 =?us-ascii?Q?MIxzGJlpxUgXGu4+2+INcha8youeHfPtnCHn6sqshX0bHISg6KWGcjAUqAZy?=
 =?us-ascii?Q?J5sPqR1AD//JPvOu/BpDgNZHou1gjUkhdHVVJsGaYQoGu93wL0dT7JWgwtTk?=
 =?us-ascii?Q?A4e5G3V98MtSuWtlqBwBFAmHR0jz4YjQY1gZkRzB0ih4W769BGMuBlpWJ3Nn?=
 =?us-ascii?Q?lu+jwBN8uNytMCDtZP8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446446d9-1a95-4e08-d867-08dd4d1a22b3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:00.5215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrPK2wu0Lmsh6lzs9Ln4xAJnimIP2TL5cTTup39V0uVoE1/8hUVcd6VNqGe1QAEq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Intel is the only thing that uses this now, convert to the size versions,
trying to avoid PAGE_SHIFT.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.h         |  7 +++----
 drivers/iommu/intel/irq_remapping.c |  7 +++----
 drivers/iommu/intel/pasid.c         |  3 ++-
 drivers/iommu/intel/prq.c           |  3 ++-
 drivers/iommu/iommu-pages.h         | 16 ----------------
 5 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index dd980808998da9..1036ed0d899472 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -493,14 +493,13 @@ struct q_inval {
 
 /* Page Request Queue depth */
 #define PRQ_ORDER	4
-#define PRQ_RING_MASK	((0x1000 << PRQ_ORDER) - 0x20)
-#define PRQ_DEPTH	((0x1000 << PRQ_ORDER) >> 5)
+#define PRQ_SIZE	(SZ_4K << PRQ_ORDER)
+#define PRQ_RING_MASK	(PRQ_SIZE - 0x20)
+#define PRQ_DEPTH	(PRQ_SIZE >> 5)
 
 struct dmar_pci_notify_info;
 
 #ifdef CONFIG_IRQ_REMAP
-/* 1MB - maximum possible interrupt remapping table size */
-#define INTR_REMAP_PAGE_ORDER	8
 #define INTR_REMAP_TABLE_REG_SIZE	0xf
 #define INTR_REMAP_TABLE_REG_SIZE_MASK  0xf
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index d6b796f8f100cd..735e26498ee9f2 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -538,11 +538,10 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	if (!ir_table)
 		return -ENOMEM;
 
-	ir_table_base = iommu_alloc_pages_node(iommu->node, GFP_KERNEL,
-					       INTR_REMAP_PAGE_ORDER);
+	ir_table_base =
+		iommu_alloc_pages_node_sz(iommu->node, GFP_KERNEL, SZ_1M);
 	if (!ir_table_base) {
-		pr_err("IR%d: failed to allocate pages of order %d\n",
-		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
+		pr_err("IR%d: failed to allocate 1M of pages\n", iommu->seq_id);
 		goto out_free_table;
 	}
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 2b6e0706d76d62..3afbad4eb46303 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -60,7 +60,8 @@ int intel_pasid_alloc_table(struct device *dev)
 
 	size = max_pasid >> (PASID_PDE_SHIFT - 3);
 	order = size ? get_order(size) : 0;
-	dir = iommu_alloc_pages_node(info->iommu->node, GFP_KERNEL, order);
+	dir = iommu_alloc_pages_node_sz(info->iommu->node, GFP_KERNEL,
+					1 << (order + PAGE_SHIFT));
 	if (!dir) {
 		kfree(pasid_table);
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index 01ecafed31453c..0f8c121a8b3f9d 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -288,7 +288,8 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	struct iopf_queue *iopfq;
 	int irq, ret;
 
-	iommu->prq = iommu_alloc_pages_node(iommu->node, GFP_KERNEL, PRQ_ORDER);
+	iommu->prq =
+		iommu_alloc_pages_node_sz(iommu->node, GFP_KERNEL, PRQ_SIZE);
 	if (!iommu->prq) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 7ece83bb0f54bb..b3af2813ed0ced 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -84,22 +84,6 @@ static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
 	return list_empty(&list->pages);
 }
 
-/**
- * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
- *                          specific NUMA node
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * Returns the virtual address of the allocated page.
- * Prefer to use iommu_alloc_pages_node_lg2()
- */
-static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
-					   unsigned int order)
-{
-	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
-}
-
 /**
  * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
  *                          specific NUMA node
-- 
2.43.0

