Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5271C8626;
	Tue, 25 Feb 2025 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512396; cv=fail; b=me5fkLuTKNEjYheIvYAXYiIohZO9XzshlEpD8MNuaa4BEX2phoJZUkxAUnIqpcYa81uCzcKAGCvD624WbULs5T5nq28p8B67RAx5ce17TbSS86A880WgdtHri2e5jrl+PXxwMBm0Wzzoe8vBh6YsnTjDvlwiilBRd1bT2KXzk8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512396; c=relaxed/simple;
	bh=Uk/6Ciq54cbUF75u9+f144pb/13FDwBOG4xUZDgDNio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WPjICBlQTnVcf87m5H9xKdj9I+cKwsRQAhy2Q6wQF0J4IGQogVTGgZdEq0dh2UziniBn0oyBDrFrmsqOk3wnTC0TO3gFxJh+kok2FJQB77bJEpSvAQgjEgSqScGYEJWIU8TMsTMgScDwr/CFlzxMSZvK/fm5v8vFhkbmRCBJ7nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=suPKKKdm; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="suPKKKdm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9mttZm3uEXJyQnR8DPOa6i/u/iWguCB7cAhPS3z2wYtvS4Y6pHMgMGdooPzXfkSUPkoGb1gGxfRUX7i00NdIZpS7JT4QgN1PnDybdliICoYfjjQq8+8QD/bhmqbcioQv+PZ4YH8NhOk57PtNvk4jT0rLR1GKGOyPCmace5Jmqb1bvlLDeI1GoQQJBXRklHmcnrOWL3iQCDJSpC244sjavBNfarBtv1Yfn7aQb2OE7gdy04W/JJn15HjfxWb01T/3VEthQvrWF4m1XwE+gYdwPV8jR8bC6TYpnokeYt0eVlFrGZjTLa7hyJg2Kgc8JnFml2o54Q/H0JkE+bU6GDPOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+akwFg18r3NdimMyy2y7q62VGXPwuDsWVi+yie6UZWg=;
 b=hu6qt0bh9G2iju4YP5B0EhYCqQNkwBzFfbIJ6m1r4f5HkCPXpmLte56nwZobzLMERXMQNXDjDYZKeeHvRXdIE/sayjk/QF42waLy0PvmgtAP8EiMmSx6XnKq6WjIe+qbCLsCTKFPDMveh5ftsaLDwPxeeCKfuj15CNs5WG2Jv1Io18jHdiEylvdzNqThcYcw62gzR4m374yx2TUdMkUr1lx8z3bQRCxkIT5baQ7nkqp+LawM667EzyqA4d1DIGkv/Xz6+pmNY01ivPnzurqYVYVDYNI6QJYDft5LN8dcwI7jQvFwTThrx/4r6Te4eiSes63zfEA2f5Pstnlj7X1V2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+akwFg18r3NdimMyy2y7q62VGXPwuDsWVi+yie6UZWg=;
 b=suPKKKdmGxjM5XTT+E7CtbJkEUX1vB5uKZWXISQRIhQ3Li7iPn1RZ0zfTHwd+sHgWByOGNHsJnuNhUJ1mxVzB7ZupgMN1x5UTKVlHDEgkSx0kLvh7+Ot23+VJdOembD2VC73nHpkMjDSKKOlmy/IgqnTQAHGOsMU8YuPln9knN8xpYRS/2KoMVf+bZtK6jqTn7+fNki3o0g8useD9cJtJZXLQf9RdVtXDe0u/z89uOfqwc+le1yhThdUL5fOV+IKoK/6bomA2WN3336vncvDHE+Ni1Yj8G1gSk4ZBdjPRnJXjQZCJzCOqliJ+QHdgKyzvlnox2AbtMp+MVZ9Si3gxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:45 +0000
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
Subject: [PATCH v3 10/23] iommu/riscv: Convert to use struct iommu_pages_list
Date: Tue, 25 Feb 2025 15:39:27 -0400
Message-ID: <10-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0065.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: d276cceb-f46a-4bd3-91b5-08dd55d426ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R8/DtGiom39FXKWpwroKCyu+PAvcv6kdQ8uIP3GwCVXwSEaVm/dEsObTalrN?=
 =?us-ascii?Q?BYLA8tFPpvV1dW9uj5tGKBbFnYMc09/hVoq6LawDsDXsmocDecq/YDoS57rg?=
 =?us-ascii?Q?DylHr+CJH/88Pj1NyvGXW7BY+7Jjeb5IAmeHWwZ45/RME4NR06SG21T6wIDS?=
 =?us-ascii?Q?TkjH53VZGysRSQ6tNYgo3ttFszlAYDqMjpnvxBOedyqdUnIXeStS+zLRESYO?=
 =?us-ascii?Q?7MibZa3y5v/s0far7JMQRcvqI0sygEkcOT+Jf+9YQKxhq6GNdo7A3is1Utso?=
 =?us-ascii?Q?bgngeKCuxE3wAe+bIzYVUIs53uU9n41mL+29kzWsrQti2I+UiW2+h2b5MSe7?=
 =?us-ascii?Q?XOgUgIvddAA7qrmeuKfdg8Fz6fcsb7CGyZRVZn5mpPedLVtmAH4KuB0co79n?=
 =?us-ascii?Q?JId8WWZHO9nnwyRtv3Bu7CFtgGPkW3KK1yDlZnHjMqV997RlqKfUw7OZja8F?=
 =?us-ascii?Q?eR5i8KLB1ZL0GvT6U4v6YV7eSsGwxW07j0Xgex4h/qEuuq3+YV0K5/kUFHGm?=
 =?us-ascii?Q?6CekpxkBsTfKJgJ6PWJu6mUStL6BPNMVDpDPPln8xoHuBXmlDmo8U4rRIDFA?=
 =?us-ascii?Q?rnjQSP29dD5CV/4aaiUDmeesNljHLLzPLw6FPgz4LolsHshXi6m8t7LfMfvN?=
 =?us-ascii?Q?LsHLRIe6jndJn1LZLIU21ppfqu5Y25u2Rva3boKURLELUMzrPsimVbcL3WUz?=
 =?us-ascii?Q?2gFWPskFkgBYRcfBPtwWnxmEMyvvb7MgYr7v4sx9pjMvpqdZM0aX2kwhJrAD?=
 =?us-ascii?Q?WmcEsMgckI3BgtSS+ZHO2yRaf7/hDQa+PE4LZ5K42BrAtIS+p3KqdaW9DYBf?=
 =?us-ascii?Q?sY5eEqiBi38Hhid2agnDKx3zG4YEdwO5AHHhARtqGY9Vo/hBcklRlGaJxa3z?=
 =?us-ascii?Q?bpuGy6xkGaO6ZHH0XoVRe0Z5rGpeln6HgXhEVOEO7q5pYYONJNXmRSaDcsYc?=
 =?us-ascii?Q?TaeI9mcP0XMXF8FjclGXfyXcTZI3N2xKRXMHG8ATKHszwcpuJf6JiLRPhRLo?=
 =?us-ascii?Q?V8uaEClg2AzdH5NEtVub2TgeSF1yzpUWEatnR9Yyv0ZdEjlS+BMaci1iwq05?=
 =?us-ascii?Q?Kpg0EUdkneC2vYq44xK7LFwmHhwkq1ReLM/wdn67Hav+VpOItkrnFTkKjxGn?=
 =?us-ascii?Q?XKH4ar1cV70FpFZZe8tmI6zRYyuKuoObLS8w0mxtqJMUs3wIFjkVYLjP/qiN?=
 =?us-ascii?Q?lZ+DJVKO0qgDJqj6bazKLxHq9nj8pA/v0j+Vk1XxAonZXsV3QX7vivBKvrws?=
 =?us-ascii?Q?8yXwsAUmhjcfiW/WaxItf++V2a450NuoH1qjW8drwPkKzPaSliZJtzMHK9hQ?=
 =?us-ascii?Q?3amLee1ixAdcxjVd8T9EtJqdOHJbHbrc16Azv7c7PWX3843PDEWjHLJ+X8p5?=
 =?us-ascii?Q?6nYQmD5Iwbtq8DNBaBsDxQISi//0nKD+Ye4vMX/F78mq001GxmhBCsYy20oT?=
 =?us-ascii?Q?4Ez7To0hfGM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WNuSzNxJNNBoIu6ubr5TPddDln0supgbzJzFn+9qmgngfN445UJSrhJ1YFqN?=
 =?us-ascii?Q?IZp14CdY2iJvJwLY5OcTfspw0M/lEaUZjIT0Ccq+atwWRn+O079QaCUYGJvD?=
 =?us-ascii?Q?xXPTzx7f0KcffRK+tJEAM8i0DpXXEpzuJlY8Dh5dcm4oh+IKt1XguzixNNV7?=
 =?us-ascii?Q?qaskW4+CFzJTPa40FwZzHELGZ44f6CfRoKVeiV5DlFYAL5CXNpOdxuoDC6qB?=
 =?us-ascii?Q?eAi9FjZJ3OYXlRLdBej6rqEb8cHSTIez1efokoUTp5FKjp3wH/47KsKgzgM3?=
 =?us-ascii?Q?Cl8T9NgyYCImv3UxkgEiADSK7LU4KAf2QvzCvl8MVhdVmC0aIgL1wOf62xSu?=
 =?us-ascii?Q?74vloKByXu8bB8n1NL1HM28z1jfsxULRgYucpxN3RBWp8+7+pbtgL+N7iKwk?=
 =?us-ascii?Q?tcTZN0dV/UsFBkgTAj6+o+lq7QmtYsJ65ojBLTA3MJBoLrTwa1EakL2cgBGz?=
 =?us-ascii?Q?FBkRpglQEZ5pnoV84g2tU9WZjWJJwqurfyyOvjsmhasFRqtVYIiixL5vA85k?=
 =?us-ascii?Q?Vlnpl9p8rxl7poizxVZyqnru73NTZyErLe1qA+VB/YjKaLV6LV146oq12lCk?=
 =?us-ascii?Q?DoD8QZ9srIQb6gupZe969gVgTGxy1MYsmpgtn76VjcM0MC9Yoz2yi7xHOEyS?=
 =?us-ascii?Q?m5IPe4wYWB0DWLFvzYsTmknNC1QdGtgsQf1NKgsRu26KQdi+WB6LMHkk30C3?=
 =?us-ascii?Q?1yGP+S9t8qNnCYi6NurYaR41aXU00hKYEflBj6CXl9CAT2Bht5fqBAwZaKe5?=
 =?us-ascii?Q?WntDDutFNHNf7F+8cRnY6iV4crW5Rkc5oDN+ZkbxLk32Rz1pMGab78W4iVrt?=
 =?us-ascii?Q?dqdXhWBtYWntEuM0QoZZvkDu8wO8383z4+CAO1bw5VFy9QkHpESmBsFZrP4H?=
 =?us-ascii?Q?VTQqfzslvZskz/QFHCqTC7anTkGF06T8I+vk0pCvMK0jwJxHYLLDvZsOEpC/?=
 =?us-ascii?Q?Fwi11WILHeJB2bbG20/pD2sc87cAaZIa2MqZSt/pjQsKyca9+81VM1YVugnb?=
 =?us-ascii?Q?1a8zCuS+1NVjvcpd35s8OeB/+dHcGvHj+2ZoksAbhQ6PQ+PTznJkXsJQ7CzV?=
 =?us-ascii?Q?s7tZYxMHqp5X5Yyi/I+/v6YWerwkvzaZDcg0cD1RHJiD5Dh9VZeiDuRTnGW0?=
 =?us-ascii?Q?smvHpkYT2bPfFtTb7zaglHFGsb8jKGkCZNFSxZ3GBXUdwbGzsE84JW7NAaP4?=
 =?us-ascii?Q?camzImpyjAcFN498VvT29DCQ5GsMwzn/wz7Ym5nFwUDeQcPLlq4FgZzgOTS0?=
 =?us-ascii?Q?mVWkptg9enpJi/OhtEzw7HKBoFyXcNpLNwKsX3lTIYDXtBAOhAq7JeLW9VN5?=
 =?us-ascii?Q?+ktEYXNkh3LGabbBYDuH0I+NA7Yw27xNKv3XlFGYTuRPeLzepzPCLFARLT9D?=
 =?us-ascii?Q?rxfdMdxpnefQlwnFbAgvAWcE7ZUhB4mmAUNg1N2zPH7/bdMFcoIF9TtI90kL?=
 =?us-ascii?Q?GBccaEX4KOlj1+defoJ3/XTiH/0sW5m7szY6NntA0KeB+qq1jyGBtgAYtFaH?=
 =?us-ascii?Q?ucAdodfLxoEb/Lcw5saAlAvRYO+gs+pd1Kc2MOp6BiouC6BdAF5Y6RkiasUd?=
 =?us-ascii?Q?x5HaRLPXvKwlHKXPboo4XdKrZKpgZpKAzbE1Xdvk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d276cceb-f46a-4bd3-91b5-08dd55d426ee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:43.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbzJkM36rU0zcDZnCLU5fjHEYonLa4UWVncqR0ftoivldQxpAVDqg7mrpFa9VdIe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Change the internal freelist to use struct iommu_pages_list.

riscv uses this page list to free page table levels that are replaced
with leaf ptes.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 4fe07343d84e61..2750f2e6e01a2b 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1085,7 +1085,8 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 #define _io_pte_entry(pn, prot)	((_PAGE_PFN_MASK & ((pn) << _PAGE_PFN_SHIFT)) | (prot))
 
 static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
-				 unsigned long pte, struct list_head *freelist)
+				 unsigned long pte,
+				 struct iommu_pages_list *freelist)
 {
 	unsigned long *ptr;
 	int i;
@@ -1103,7 +1104,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	}
 
 	if (freelist)
-		list_add_tail(&virt_to_page(ptr)->lru, freelist);
+		iommu_pages_list_add(freelist, ptr);
 	else
 		iommu_free_pages(ptr);
 }
@@ -1192,7 +1193,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 	unsigned long *ptr;
 	unsigned long pte, old, pte_prot;
 	int rc = 0;
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
@@ -1223,7 +1224,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	*mapped = size;
 
-	if (!list_empty(&freelist)) {
+	if (!iommu_pages_list_empty(&freelist)) {
 		/*
 		 * In 1.0 spec version, the smallest scope we can use to
 		 * invalidate all levels of page table (i.e. leaf and non-leaf)
-- 
2.43.0

