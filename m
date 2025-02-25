Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DFC20C46D;
	Tue, 25 Feb 2025 19:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512394; cv=fail; b=eHWnaWHt1jy5hgKQZVNnVOlD1ycqow/DsxVvueUG1cnK0G1+F0ti6CwZc5YoAZaK9Qjr/L5q0+BHuZMp71Hxy9ZfuC8oyox3SQz7XbP81NIccAdVWbesqmJIFq1/u46yUQgzcKzbM01hkOT843mEJuJUnbQ52gZZF6tGDgAOFZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512394; c=relaxed/simple;
	bh=cS/fQvQwp21uiRWTTCOlcqZtVvZAFcp+RQx7Cu4g7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lNpMh6a9l1tljnzxLXiJH6QSZNTO8Uc9vO6T7Rojf8sKwk4KZoYaK9fNojznvRo2Yst9QafzUHcATqzMUzKCbSM/uOXz/cSsjcAhpD9ExkkZQul+5w78fof9Nufavyl6OmK7JiOKviD/fRaF2wDgBiBU1BZIFA/fMuIWKCN2bVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E/zrf///; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E/zrf///"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZHfGRswjjMC24rzTOF96tW9lEPgIoMs5ob7ZfOmVFpcLKhcriCT/ahOUKYZLwMfAQRvC0fT4wFSZdnsOpZKCPZDPjOumoXK+XNWOE/sZnTnHwlN31xxwAv0o7M8q9cOSIY5J9bfTaRaBze5rXXpN0BoSQVw0tGFDsTnKEbJjv18aZGWMJ+i4gXMFjAe5Wsehz5Wg404ZaMA7uSWEO/rE9qHESx3KBdFcLf6NAsGSBtoATdQUzWpUjvaTQSJxxHxpADZdcKtPcIViPDOtpnHf74BOqoSOdt/sPpWne4rkHmm/BkV+h5AZ7uKi4ILAsnIH2leTOVxmz+3npP0w0sS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGwJ3YgQukhYeal/8M+gwSQTj0rq/d0cUCKaozR2WFU=;
 b=CfAkhjU416FQ6uAzK82LTYcTifoW2OJwjg+CfVFfZbBKAy/sbJ9eAYCVJWTPisoeX+1nNjEao+urJHzldfXN4jCZVhq1nbfUQn29zRXpUUsbN4xaVXnXohT/xWPAp2JrRpv4O4+bURUcHRSRcu/gbMbtgej4+SETUxGbRv/iE6b6R4CKfqAWZ20zz80Z97EQKQ3Zr1sdtQHlWutYNoFn928h8igSlWfxQjHoXa6Ngg/B/Ni33c8/wAtKBG66BR4G0f0HOKbYTfCzbVXZkvBE5T1KKWlvyUg7MvXHgJVw2gtHLHodSjIIKafdBYoSgK5OP8ZhS7URbEWXADjRUy+seA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGwJ3YgQukhYeal/8M+gwSQTj0rq/d0cUCKaozR2WFU=;
 b=E/zrf///ycpkxZYoSwIoCRPdzVebMusshk07SlxYPBZ6FQQnRBVnGkyaG417ftoABvJpE9u7jeZ0oOZC2HbWvip3QOgOpNpQ1V4Gqv/ucqCS9Bi/e5OoHuCphMA4HuUx6purHDX5qwS2h4pDiccVEryOcEJ3suOtj3APLKJ/xCx08A16FSVRglq6YtgXSwH+hIckkZekCL8BmHefDb1pOLMHO6OlZhWuukdUzvJnH0xEjLDtvMOfftTgM8QjUWw6li/jwxe2T4fCh6IJy0yBntEQDyXt1STfm6JB27CqSV266b3QWLX+2Px9eTYtTgq2tuOtImCf25bNCwbKFEV//g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:44 +0000
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
Subject: [PATCH v3 01/23] iommu/terga: Do not use struct page as the handle for as->pd memory
Date: Tue, 25 Feb 2025 15:39:18 -0400
Message-ID: <1-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0004.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::12)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: a5cb23c6-b56b-4421-e257-08dd55d4267f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yz+TzHwc7hEq82FF1JYEfKyY6OVlvEc3Fx0h8hW2aCAwcimlllZpZyNxImPV?=
 =?us-ascii?Q?i0RsTSrB6jDhlVADSfC3MPj8vc6rOZBOpLVf/xUKGDozKRumpUlqos20gqtp?=
 =?us-ascii?Q?mlEXl/G+JHKathbrKTyqHIL9tq9YQRmbOslpGQXXhWto7KigKQH96XH1GO3l?=
 =?us-ascii?Q?+1ALDYdD/uN1tjE7c1GlGQPYxEKuC7Jj6HUryvPoHWK67qWsSN9g5YqUbVAm?=
 =?us-ascii?Q?tLHGx5mxLXigTqCbD6UYRsUBs+koWyz35hvoydU7yF/QwHyxbQZJhdB6eTPT?=
 =?us-ascii?Q?/B1CPiHALnENwEvZJVmEK2FYoWhEMgoOyGltSpCcPNCGsKLitgdD6hXid7/P?=
 =?us-ascii?Q?Jw2YRRMG+7jflxa1LPr6BsCRsOTtZCNKifw/XqtgbTP9SmAqleCe2GQd6Pow?=
 =?us-ascii?Q?eMKBObVhQPyganLbQ8j9zagnw9ufcIzZvL4Ogec+ZMOhhRWBaM778qLRe/9s?=
 =?us-ascii?Q?siPuf3azcYc6j0OS4IcviOXIU8pJ8QRDPkZZUxF4BfXTz6M+66bKYm0xNuMH?=
 =?us-ascii?Q?Z5I1JNP5JzrTFzeJ39P2DvWoijjl79dFRgyfIxNay6EQHHqdBlxU9Hidy0GH?=
 =?us-ascii?Q?OAjyPOwaeVMxYJYUGHzY1Z6B4/Cm9qcD6XqO8wYAjCtlOli0k6/atHhGZdGv?=
 =?us-ascii?Q?WGeqz8/RJujUhBKqLveqTgk99zE3VVlXlsTnl5h1eQ9xUHPQJMPpSlR2X7uC?=
 =?us-ascii?Q?d/yq8608ghWsoyGCzaWUG4JlN2d8VqwoRNsYoA2F2H57DhRpLXIJ11NMFxM8?=
 =?us-ascii?Q?w9rFwIma0SknMO+/RrrrLMhoeM6y61DyrY0tpi0BqWQLESpu6NsJQ+xAHNPr?=
 =?us-ascii?Q?VIG50RbPKxFp9IC5Fr2pmbLB1xYJzPrZQZn2XPDiQEODblGB87jfPc4OL1aH?=
 =?us-ascii?Q?XfIKeiZjc4RLvQ9KBjID2hdpmbYREePXhsTHKl6sA5JllC/cbXdsF7v2l9zC?=
 =?us-ascii?Q?Dc+IMtOHCSrMzF/FKpBQD+9T2xlfc8nwkJ3UOQ0cV+dV0LZs7chKo98aYsZS?=
 =?us-ascii?Q?ohK18CuYs3HFvKXv7yNITP26D1by7R4Qe/QHZp4f3R2WlYBjl04HjI0b1YyT?=
 =?us-ascii?Q?N3vP0QWQjkPef0uaTnRtt8DCASG67N3LP2drFgojyGPhzHl3Sb+QRKWPPjhm?=
 =?us-ascii?Q?fnZumiX63nTzt01Hel2O9b/WStv6NM3/EHNburwnjM4knjzLe3a7MmVk0FuM?=
 =?us-ascii?Q?/RlRr91Ds4eBExsWlZUFS9GifYi1KgZhn7Hpk3Z/my1V1aQIBNNi0brQ3OZO?=
 =?us-ascii?Q?9J625WLYAGtYgPBFWKU3gadqYYVDveOg8j/yol5EzzS2h6BfPQz4HOqlT8oQ?=
 =?us-ascii?Q?/XthOFVWzB0Qd5t+3fkJPOuHTXmHtD+JK0wlPFEk3mTxohbs3gkxijYq6spB?=
 =?us-ascii?Q?frUI+/Ra/VekgRD+UVmI1PHt8N/KjLo3afqXXIWQ7tnlYY6BBog2CeHfsnwv?=
 =?us-ascii?Q?iqtorzGyLnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/rYt5xKWz1zsoKzmbPULkIcQMmcxfV3bY8xPRDyRK82zv8ipF5g9vJWpUfee?=
 =?us-ascii?Q?qDxu4VUN75yJMuG4ziwSvRUbHnKdIvoJv1z5MPsNoTlmmAWkCXaDHrAmEllD?=
 =?us-ascii?Q?p4/JtVHLwipMkQyxYxIFTobIOJzGQiw+Pud3ItmlKhGDkNmPwXD6FNElL2qM?=
 =?us-ascii?Q?XsZC9lq8P3jGzbHWSPtPIIriMRbIh4ZLvWz6AogK5WTzyl2FC8JJv3sKzM7m?=
 =?us-ascii?Q?T6fqKis+Rz3tBkwYV++jxtHQo1n6qEL1VvB6VoYSrY3ydTLY36JQtJumihJb?=
 =?us-ascii?Q?vG5Ft43R9e0BRA2QP2QXmM/q0jF0kRPfDwlhHJwgXEoyEixs++fCANiUVLSS?=
 =?us-ascii?Q?tbvuN21Cds1Mu92QxKv+gMbV2/BG7JKPwBG9DFAHoep3BSz6P/LpiO5K3uDt?=
 =?us-ascii?Q?ncyrORT2MAodt6W0VNDkjtr0V3nbVOjWIhI6AMzmQOfAeXt4WRqW9MOuhHQX?=
 =?us-ascii?Q?4SlAiPOYDJDDmM5fFijEvmAslHthfBM7TZMsxtHCqR3cNcrbm/yygIcoCgGv?=
 =?us-ascii?Q?BSssgEJaMmxkblqtKPVvHeZGhF0/KdchVvu4N1NfQXgqJ5GCaRY4btcEfEKu?=
 =?us-ascii?Q?P8KgpuXnqmGVBuLsKB/qHhvm9yaUTo5nLe2+G0OW5d4HRLMfswxp009ug9Uv?=
 =?us-ascii?Q?vXZccekyXCUIZ68YpWcjMM4wQijAPKJQPLJVBHMXTim7mK7ZaE6vhSN+4ie3?=
 =?us-ascii?Q?k9iDEAl8WvaqfWAyjZ+oJsYMVMx5M6YdsZqlaaZSe8B+ok1VxVV3XlmfnkfI?=
 =?us-ascii?Q?lUycHpCM6iLj/DD4bDPiSAEQJyJ6pzj4/8Hth7qzNN+s0Kobhha2NzLWgFpf?=
 =?us-ascii?Q?c4Y0v5KTCejBG9INXJ/sNzykpby7JKMlmQ7fTJ6likgJD4pic3NNAUBYcjWm?=
 =?us-ascii?Q?ymhrUAGOnPFz/4ozJ8WmbBJCdRGe1yyq/vcdAPCjdtlkvnDrqZomsdE2EKot?=
 =?us-ascii?Q?O7kUW8lG/SyLWP1kyOKXNoAh8PPZloe5q0o6TPti8aRPOD200whxlnUgYFxq?=
 =?us-ascii?Q?R5ETmKUsZiAz+k7OTJbzWTR8zonVQmVAfH+SvYv3rAZPgNEhKjYIipw/uYXY?=
 =?us-ascii?Q?ma2nQQTZTEuXblWHw/R9v7/DPF89Rnz2dWU/DzoA2CUqOPxFWJY+lCn2hgVh?=
 =?us-ascii?Q?vAasOHN3ZiCfjdXf3E85Qh5ZhMl+reN4AK1E/81wfxW0PsyUdh1DYqtGMxBH?=
 =?us-ascii?Q?psCV4q4H0/CRzC9D+hMHlTEvto9eT1DNRILZYEOv97u9nmtFeLeG5RHHUBFj?=
 =?us-ascii?Q?26sLiDKEecsb6JjOw0xyaPMjPzIRz7iEC61kfw3d9GSS9zPv9XIOsf8vJg7Q?=
 =?us-ascii?Q?zTzBlGIxNgpSYlzx8XlQEH3C4ci/brjv3Lk6jQNiB0av5sOGq3lbZuynbDXL?=
 =?us-ascii?Q?EFzt9QMWqlwK6i1kUQiOvO+sBwDKXheGwCFa0R439YM4Px6emWUOTYSofOu3?=
 =?us-ascii?Q?B+9rdOhoWgbjLCkqMIzOqmRr339FNqNHJSV+ZZ+fIZ/P9pqKJznbSN8Nw9KE?=
 =?us-ascii?Q?sAq+WcsfEWzES2G8OPdB5QZeMwLwrupsRCJfrFNAMo6XQijnNxdiPiwopw5H?=
 =?us-ascii?Q?7qWuP7012498Kdcd+xUz+FlxBsBHphgP2h65S3m4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cb23c6-b56b-4421-e257-08dd55d4267f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:42.5942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9M+4y3+VuGmHsVg9jFdc4xKYxp/oCsKEW5kVQPO7dxK727Z0Tud1t32J513EWo/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Instead use the virtual address. Change from dma_map_page() to
dma_map_single() which works directly on a KVA. Add a type for the pd
table level for clarity.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 7f633bb5efef16..b6e61f5c0861b0 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -51,6 +51,8 @@ struct tegra_smmu {
 	struct iommu_device iommu;	/* IOMMU Core code handle */
 };
 
+struct tegra_pd;
+
 struct tegra_smmu_as {
 	struct iommu_domain domain;
 	struct tegra_smmu *smmu;
@@ -58,7 +60,7 @@ struct tegra_smmu_as {
 	spinlock_t lock;
 	u32 *count;
 	struct page **pts;
-	struct page *pd;
+	struct tegra_pd *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
 	u32 attr;
@@ -155,6 +157,10 @@ static inline u32 smmu_readl(struct tegra_smmu *smmu, unsigned long offset)
 #define SMMU_PDE_ATTR		(SMMU_PDE_READABLE | SMMU_PDE_WRITABLE | \
 				 SMMU_PDE_NONSECURE)
 
+struct tegra_pd {
+	u32 val[SMMU_NUM_PDE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -284,7 +290,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = __iommu_alloc_pages(GFP_KERNEL | __GFP_DMA, 0);
+	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -292,7 +298,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -300,7 +306,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -417,8 +423,8 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 		goto unlock;
 	}
 
-	as->pd_dma = dma_map_page(smmu->dev, as->pd, 0, SMMU_SIZE_PD,
-				  DMA_TO_DEVICE);
+	as->pd_dma =
+		dma_map_single(smmu->dev, as->pd, SMMU_SIZE_PD, DMA_TO_DEVICE);
 	if (dma_mapping_error(smmu->dev, as->pd_dma)) {
 		err = -ENOMEM;
 		goto unlock;
@@ -450,7 +456,7 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 	return 0;
 
 err_unmap:
-	dma_unmap_page(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
+	dma_unmap_single(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
 unlock:
 	mutex_unlock(&smmu->lock);
 
@@ -469,7 +475,7 @@ static void tegra_smmu_as_unprepare(struct tegra_smmu *smmu,
 
 	tegra_smmu_free_asid(smmu, as->id);
 
-	dma_unmap_page(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
+	dma_unmap_single(smmu->dev, as->pd_dma, SMMU_SIZE_PD, DMA_TO_DEVICE);
 
 	as->smmu = NULL;
 
@@ -548,11 +554,11 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	u32 *pd = page_address(as->pd);
+	struct tegra_pd *pd = as->pd;
 	unsigned long offset = pd_index * sizeof(*pd);
 
 	/* Set the page directory entry first */
-	pd[pd_index] = value;
+	pd->val[pd_index] = value;
 
 	/* The flush the page directory entry from caches */
 	dma_sync_single_range_for_device(smmu->dev, as->pd_dma, offset,
@@ -577,14 +583,12 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
 	struct page *pt_page;
-	u32 *pd;
 
 	pt_page = as->pts[pd_index];
 	if (!pt_page)
 		return NULL;
 
-	pd = page_address(as->pd);
-	*dmap = smmu_pde_to_dma(smmu, pd[pd_index]);
+	*dmap = smmu_pde_to_dma(smmu, as->pd->val[pd_index]);
 
 	return tegra_smmu_pte_offset(pt_page, iova);
 }
@@ -619,9 +623,7 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 
 		*dmap = dma;
 	} else {
-		u32 *pd = page_address(as->pd);
-
-		*dmap = smmu_pde_to_dma(smmu, pd[pde]);
+		*dmap = smmu_pde_to_dma(smmu, as->pd->val[pde]);
 	}
 
 	return tegra_smmu_pte_offset(as->pts[pde], iova);
@@ -645,8 +647,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 	 */
 	if (--as->count[pde] == 0) {
 		struct tegra_smmu *smmu = as->smmu;
-		u32 *pd = page_address(as->pd);
-		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, pd[pde]);
+		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, as->pd->val[pde]);
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-- 
2.43.0

