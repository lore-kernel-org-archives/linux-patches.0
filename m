Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0763211A20;
	Tue, 25 Feb 2025 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512408; cv=fail; b=ojFTisWDXHMkmD8B9Le/BhDIUocY6FpXTDbbxzyQ0uWf2n4xgu+9vRfUZ3+4HbZckB//6Q3w+x0nr4asrYQ0la3T35LhAktxW845KtmlJIU1SWjhO0GiSGq3U3kVSRn+9yLPwP7e59mRxkP80uGLcGB+KFDdLi0XMpI1RD8nXF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512408; c=relaxed/simple;
	bh=n8udTREVKeuBTh2FMDjUdEM2v1nlrEHfJ5I7MNnvzdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rffT5PWxFd1/bTycTj8rp+kB5MUYY2Umflnk66FxENMokaOKvIFJuVQrlyYUzxlbwdLviYyxfP+ma9QOfQl7ucaDI4vs+fLZQRDAKqz5f0x7OsDgT54yAUy48uTJpcfdlsmHcLMS7ECtZNQ4vN+KiYJyIbrpTGq4FWWTuSZrzw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nKceQraN; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nKceQraN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRDu2d7TzvjDxnpIGHFotlx2J063Or3zPVNv835b7Ck4bUNF+l4IT0tJDkl8XOJ7KjcYzNbM+wVmeypMl9wu2qG4lMt1HXl9Zs37zkc320F9BjXYZ6zYF/fiWvxJl7OttT0ko01gZakLC7wu0bAIq5FCWs7RaXXbQ/YoHKv/cw6JnYYqcP2a9W/kRjJ0Lb0ouknLEo1oDwsR5G7kVGfgtqNdmTdrXPgFTCIYxUFVHqz9EsRL8mggNAGBn4Tb6AHKcbIWW9xXiipZPcVQQExTazasE/fA1K16Xm6thPFpMT1WjtUOkHZiN+QQpmZ8nGA1xr7BCOOxRzQ2gz5YBmkPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UHbtViTh6h+2wDqLWZev0a0lQdcfzlCElZMycFgtXk=;
 b=nXb9bOc0CFMhlC0hXoWQH/fYG+oCyBQk5PSNZetiw2AzyvGrX6ETh/0UApobNFNEsAEQ80NCW62+1U2m2qvCXRXZijNhqTW/oxU5DRjDzENaIvzUHFQ4RSM1EPR1QIGiFw0aj28hMNOCxaKMGFJyhjszzLv0utP/5AKtDCUV3fWTq10WwCrvdiNSEa360YixUnwAQCcRAsSnEO2bfeLbQSR/1K/r0U5z/q28dxBQ6gHjDGUzbXzYDkCQLcDBJQxfc503qZ7tznsMNbeDp+4MOz6OeN7TsNSsR2WZ9MnCMf2ojRAEckmSfsc/7PWZaQAeJo01FGQj47hzUTp8dJy+aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UHbtViTh6h+2wDqLWZev0a0lQdcfzlCElZMycFgtXk=;
 b=nKceQraNDkwv7dZ6D0JTWq4Ls8SDFI6g0rFNeg8nWe/21RekvSlV1v7zr1ZT9wV9OIB4WbrYcA1TXJrXrLTCY+OrBoa7D5uD3Uy1Z5UPScjNllAdZ6jzBlyQlYjnS4GQrX8ngL8NmAUdGyiKi8hQcQIQQf7M0XFBKfcQCbebvTbnRjDi+Uf39dOWiMSd/MgUnuqbmrO1fhkLtzxjHDFvrq94XLCc/6DA5TrtBfKnQcn033ewemQEbrEdiOArzA/JENbJLRyKo6hrRPZ4nAFPja8lYWQBDIx2sxoVCQB3QNiLSd+FLBwext4F5wXsOxgUWdg8EI5vBvFZEHah+oemdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:54 +0000
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
Subject: [PATCH v3 23/23] iommu/pages: Remove iommu_alloc_pages_node()
Date: Tue, 25 Feb 2025 15:39:40 -0400
Message-ID: <23-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b1da6c-becd-4bd8-84d3-08dd55d42926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UqpE1DCb88aHo9EL2unkuicHS424J5RK9nQwcCJr9OhWoH6WjQYc8go4MIZi?=
 =?us-ascii?Q?CzUcQrQjRGcbI5XzBUK2NJ+38bJUDRI9mEfiAIeYRcdHvlhInyB5qXKyIyq9?=
 =?us-ascii?Q?06wI4EkYhiNSjitc0UakruHF8U1Gve6xVHNfavj6aBXRz3iKZ3pN8NdOLvkP?=
 =?us-ascii?Q?uLKDEQPmT7eo5qg1fYd7Y6ckrEzAtPOUObvlYeXkX0/tfUKYUUoVO4BJYNk2?=
 =?us-ascii?Q?IKwk7njXvS5MH7h+yj+Y5Limyun1k/eR2E4BXE0FYSL1AvDDayLc7WW1+Y+8?=
 =?us-ascii?Q?5vOKiqHtsE0gcbCv69CZ6rmeGemxNbbT49zfuOFaQrd3KLXVRgrZix4D4blW?=
 =?us-ascii?Q?0p7WnA4fjh7FN96j1PRU9rWD5TSrRHNZGWXJvEsKfmGeVg8Ps/9kY0aqA3w+?=
 =?us-ascii?Q?HCwKeTayjIaFTxHgtIMBFGDmMwX92W1fYlVyTOMLTAvDMmdlfqqVM7LWdjmP?=
 =?us-ascii?Q?0/Oe/dMCezeYro4j8m56KTsM8TAHHObqVl6/GY87kbZE5XanXzO1bwoCK7fj?=
 =?us-ascii?Q?/AhjMubyJCkKVoPeRfAXw9E8kv10tZQHwWAiUie2kQ+nf0Uodzmt8Hm1yMoH?=
 =?us-ascii?Q?Yii0udj3Ui35s2Nfh1gAO0vvoi1TSvYfpZDb5swADUvTkeGg4u7Daz+cPPbi?=
 =?us-ascii?Q?6sHKvxoaOpNbPXhllh5at6k3lRkqyVb1swnTv2R2Os5K6ktG1T1RRVjyUuyk?=
 =?us-ascii?Q?Wges7pAOfq0JgmmkZQRZkHKnK0iUfOPBPlb6gKSxvVykL+UFa/cRSc9mgMNL?=
 =?us-ascii?Q?6RLwjS6u9GOF4fnYWNE15Nw0y7GJiyya8kKKYNjaF3nbxUhKd42svgCE/vsk?=
 =?us-ascii?Q?3ZmuBoXa7nHjcajFr2zLOXcnJCW/JrJJCvTgzIWLI7iwNSHY3VD35bbO5yAZ?=
 =?us-ascii?Q?oTDM0LXAox9xzEnegvDe7zTsdEoKSkxTQcpiqGpCPhkJXzSNR+V50NxZKCbR?=
 =?us-ascii?Q?Ylmg0xG0sinOORf26H08jeewIi60alzHRRGrz2nJL1/XBrVYF/AWsAe6EHYc?=
 =?us-ascii?Q?y7CZfL/VMFzaIW0Cy1C1cwncsnmXzIXXOgp1liFBeD87Rd4yFBniks9DQf17?=
 =?us-ascii?Q?KepJm+j9QaWN6sNshDixer1BguDfU/6yOiMvxw8hYcMP0uTGrS4mNB41io57?=
 =?us-ascii?Q?bIE/iecoevU+7V4Z1Mlt7q0LUm0iyZQ1tb353MG5IuyB5OwI19mgexQ9MA9A?=
 =?us-ascii?Q?9/nYKnB4mvNmzBTwLbqbRfntTAIvkbP9B/jCJbkrX9lhPL/qZoxIj45b+rDm?=
 =?us-ascii?Q?gLJgOEAjWXR/QUIj4rIST2yh4w4SuP64q0mq5+AHJYzXSUa0o1P0lGDk8/X7?=
 =?us-ascii?Q?JBLpVZGNQZQOtyq1LnV0F7vYAzG00rZ7xJheJK98YmFctLyFzNeDDDgBvlWs?=
 =?us-ascii?Q?EKA9uXzK+k6RF8TI9DTF5y8exc1y4i9knNDDzY6dWQUET+PYDsF7XqlKBt13?=
 =?us-ascii?Q?6W6OzkLxd/E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MYEcbgrOvgVrMrDD+BKgTa+BD/34zpFpSfg+EIKbXUbS1rYy0uY3R2IU4s5m?=
 =?us-ascii?Q?Tag4YIdqwuMKMhY3afuAnNIVN+YT9vNHCwKgEdy331DBuS9ejTYLO8p6YTyC?=
 =?us-ascii?Q?GkEVSP7ciYUKG1XboGBuZruXQhzQH0WEOU62+986xdlLsqHhhEZgM6qH/gNU?=
 =?us-ascii?Q?PRDlyk8VQbaHmcbgeVm79n++V18vlRV2k/QyJ9SdiKGxvT6FDRj08bX8SYPL?=
 =?us-ascii?Q?wT7Sfe9K+5yagrhdSdkdrhGiQEfUWsmhjsIl16cjw6j9A0tt4CvnNIy7FfMY?=
 =?us-ascii?Q?yTK4/WUwpYcHqZdmBbPAMHKjOzj0K4x9PHYUUpDGOGmF9lJedFTSaIc4fNYx?=
 =?us-ascii?Q?usbRjalonB5kDsCnJY6xHHpUcsMHIUX7HZY0DFAckUawBVrXKrVodOH3j+jw?=
 =?us-ascii?Q?P/24yk3KNJb5OEuknGiMJjEpVztHC9HTNcjaqFrz8CFoDTq8vbydgw4sre7W?=
 =?us-ascii?Q?OHryLkw/rOmKBcMD0H8hutlP15/My3AJzMd6o8BKBup3tW2gFfgqbic6JOcG?=
 =?us-ascii?Q?fhXLM191AS2w8V7ol3ULpxhXGg/qQaKij0Xbwzwp/bmNSG9Oj16hsEXuhg10?=
 =?us-ascii?Q?H9hpnPA65ZPftxzxMPaM139lUMxf6sGJcA8t2b3BtkYm7kpgoHNSKgQ+hO3k?=
 =?us-ascii?Q?YybjnlWDi5de2YvmnQhTR48ekJmqAzttP+2XXDFN1cWTOx74Ks9bbvhW7MPL?=
 =?us-ascii?Q?J14Eu4iCWJ3Kd+kPQFOctNLae6CIZXpUVrRX3OyOCVzOFKOKdU0/lvqsyv9r?=
 =?us-ascii?Q?4FFaW0v8138POesbSNM9c9yG11bAnDjLP7/3NJvix59lezEGh+4tLzBS/RYC?=
 =?us-ascii?Q?egAbNED5G4+W0MsCvaQxfqEKn2ZpDcEXsfqSJ7vmjbU3tfIho5qEly0A+Oen?=
 =?us-ascii?Q?T2IuEjqSBmASqPzQUvKnTNEUP5+55g0wPpulrmx4IW8FAq6lQPi6gJIpFe7D?=
 =?us-ascii?Q?K/fcO3LKOgNlrvl+aEEz8m2/WZ4U4B0Ho1U4snpYhtmaRA4PwThYES9k1dpF?=
 =?us-ascii?Q?BZF0BxP9vXGklnscukj2YObY5VMNZ1P6UVhXG1gx0f8i3OkJyVSisif8brjX?=
 =?us-ascii?Q?SsgYV9e/eRKcn1FoqtghDSdRdwQGzib/fUixzIdQPL4HXX8tYFPP+ui/xRvd?=
 =?us-ascii?Q?ikVhlDwDbAVgGa35FfNfpkahBlgeH3xPO6c7wr5x9OM0KVOWZnyU0wwvWn7s?=
 =?us-ascii?Q?VBS/82msyl85FRPoSeeV3SsaDjGL6VkLYusVFvMwaupCla0V5U/znySR774a?=
 =?us-ascii?Q?dgICJBET8KOC3bIKCF4OojzsSbONsVcP2la8VnXtwjoSVfq5bdXmVNSNtJZw?=
 =?us-ascii?Q?Hfre8d6KnvqwsACyiNM+pnnA0pPrcb1YOeNEKIwzLwLcL6/DHLJOcwWyRMRp?=
 =?us-ascii?Q?mHR08TSENL0NJYr+Uly5UDSEw6D6IFZIWplFybh0NrPsjq20Lomj4SX8wjtc?=
 =?us-ascii?Q?wOdKwGmbjQWcMa3xoKWF7sRWTqF+RQeAAW1Dyd9JEZy8SwN4oA4f/gP7pH00?=
 =?us-ascii?Q?y/0S3+Gw+UO4A/d97/1+dch2nJOzep3S6ty6DW2v5jKesTvicaasEsVdmiHh?=
 =?us-ascii?Q?aYLigdkg9c84Gsh6Q5S+JOro1hQhimn9qvLtnte0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b1da6c-becd-4bd8-84d3-08dd55d42926
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:47.0423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2+qEf+Zr55foSrC+FVtt8ldtBlWGgFwJDw2Dh2IZjDtKoTsyJV8m3rpYzItKXLo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

Intel is the only thing that uses this now, convert to the size versions,
trying to avoid PAGE_SHIFT.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.h         |  7 +++----
 drivers/iommu/intel/irq_remapping.c |  8 ++++----
 drivers/iommu/intel/pasid.c         |  3 ++-
 drivers/iommu/intel/prq.c           |  3 ++-
 drivers/iommu/iommu-pages.h         | 16 ----------------
 5 files changed, 11 insertions(+), 26 deletions(-)

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
index d6b796f8f100cd..fdaa508c17d140 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -538,11 +538,11 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	if (!ir_table)
 		return -ENOMEM;
 
-	ir_table_base = iommu_alloc_pages_node(iommu->node, GFP_KERNEL,
-					       INTR_REMAP_PAGE_ORDER);
+	/* 1MB - maximum possible interrupt remapping table size */
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

