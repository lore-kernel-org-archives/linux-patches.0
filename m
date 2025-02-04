Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791BD218587;
	Tue,  4 Feb 2025 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694124; cv=fail; b=Wf+ECTL5PWBsf4Vogk8bHMo29RV333mGcfTR9ctVpAsknj5vnGlZV50gicN04I26Dc6PDMhRnhMOFAfFoj5oXuWxMNRLc/yYJEVYpHngXO/D0eesgALWnksNIn+Gmj+bZgM8xyWxKotMRW8a+lSjFkMdQxtAyRGOQT49ESmO+RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694124; c=relaxed/simple;
	bh=tySBAVxoncE9VjMvAsHFkY64fi7DotLJYs7lE3/iqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BTmX8Re2I7K2HfXmv8o8kX9pY5yioCGOEcIERtIZ3MrrMPQY+8ZaUNRaTajy0o7jpo5mr2QmDrsvMrnvaYAF+tVwYKR/+z9qmPfvX0ZcNYIAZ4BZPDAKTsbiVuoh/f3mtO65HKk4Rewi76Yo4AzVTmRNdilVv6SO5i6auGWmgzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UFe4883P; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UFe4883P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evHtJNdPOSv0/ztQ7VvI+qtskSg1VsH6ie7EU5Y3qGR6CdA+ozuPKNPWd4vurRstykVDbrUfSawjbb0jHzS/5nrpQaaU38QdmNNPDwHnMOllO6Q4pJYeF0odS501FdwE3HT3sgrJvJxs8+6rHnh4klj01QKYVv0FP6gIp/3eAdY/0pnVHjrNOpP/vD7eSy7OXrMTyaWgqaoms0bi7SEKw/J2091LQEFe1mHRad8NttM06PG/oxPBns6YIUwhE0/wLLkaUJGWFhQzZYL6RY9Ap1VyrXpSJ3NtFGKJJM33OkUXdpUvuQexoVJKU3L1n2h6SfB/R1lOTSkD434bsV7FIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdM5+XUpOGaJVMJY7yo8v9rwWXZpyJymkraipAs50Ws=;
 b=wY/12ORiPkyKfPx8lhUFgmIzGdSRCsxYPCp8dp5VatE9nW+Q1ApXw2ygn7TbThZ1fYAHKDbSvoTh+8zn759U6FrIcxx/UIxYJCgrJmdg+Tu6ZovXU3SdkL3Z2eT09VX1SUfMUTaalek+g7ZJfP2AEIdcxDU6Pp8IT6ymLF3OzH1mswQ0vMuwsBzUWXcqpH0ivcChxs74CU3T9ur9QXnZdxPOv8iPcLBoh7gpa6F5nsSBYmywY/ztNZbGL8Mx9kKUoywoHUuwz+QQQQEhDBSPQu8NmrudHgv4/bj3ntnisUq0rUyWRpKDuAUk4bBPSQl6av0RbvIjJ9L0zKZzEwMsvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdM5+XUpOGaJVMJY7yo8v9rwWXZpyJymkraipAs50Ws=;
 b=UFe4883PHJg3uTBhEj4d0JFcsSaN24WcifZ7rND297wqESkBJ+bCxbGh4unz7jpzapEceCJ6vhidUfso3mMOx1Mm1RvyPd2quh4Wiw3HD3+vaShe/0r1+FyTodToTnd7wqMYJQJfwx3tEeGbee1rdBIN72cFE+dQ9zR+Aok42RffB93v78ov9IbbiHIPiTTzkhAYaev9jPaXoXYRuoN9WsQTyvsJ2Q0qxg/dxHVI/X6ChpT9kfdZehXQj/sTB7ypVw3pHSgQcqvyqDG86l8Gre8E4JMbuVSub5h1UDqcfC0BbRGgdqGMuW9KBj89ajlHyRnOLXr+bfIZ0IFMfOzo8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:09 +0000
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
Subject: [PATCH 11/19] iommu: Change iommu_iotlb_gather to use iommu_page_list
Date: Tue,  4 Feb 2025 14:34:52 -0400
Message-ID: <11-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0033.namprd15.prod.outlook.com
 (2603:10b6:207:17::46) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: e1050e75-e110-4661-3390-08dd454aa415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MbHBrj4YEelSaZhTcSrn/8Aq3EDuTl3FzWo5r6oar0VA9/bobytAzlEF4tFK?=
 =?us-ascii?Q?uADixtLcbQc0Gzu6v3vSXtt1N0ElM83aucENj1jg6s8N+bGO4EfyVHAzsagC?=
 =?us-ascii?Q?TAmRZHX0vgndA2D8/UluZxc1aQJbUKABLKdvyOO2rn54VG7JYRpt9t3x/Ytu?=
 =?us-ascii?Q?TQJO63anphpCX1nPtbxwsqHFG9XcZz08YkV5U8dCuOwDF9bjjCAhY9eF6H1V?=
 =?us-ascii?Q?natej/iH3xpb/gCyq/EEApgsIloA6lp2AdpLh9uA84PHbVUYNkVWBO0KgPzM?=
 =?us-ascii?Q?oXNizoP+7bq6U36jZe4HZ/th+z0WG0mIIN5O5/bMneXpxHpkRNqqkjft9TWH?=
 =?us-ascii?Q?70UCttezyCuYex+3HUtqsyVl4SE76Afej9GTP54YDNVdFL1YuUXFyLgOf8HX?=
 =?us-ascii?Q?gxFMkgQkDySQm8Ml2vgOaJ47OBWfM1njPTd3hIPU9WBVSoqM1yA/dSBxiCJs?=
 =?us-ascii?Q?vqbLs7oatAsAfqFuGrhJaML6YHgMG10jGFgN/TRNj+hMl7/0IYM98rtlqGdZ?=
 =?us-ascii?Q?4PPbmudXNhKh54yI/DclVkCkYm2gLtEczPH06iXdxg6lvyP4u1BSdpnf54Yg?=
 =?us-ascii?Q?KDxv3Odots4ym9vdTUy0LomkKnD5UFkkb4hTbMqFOwq2eOjukS2XjIrSIzSR?=
 =?us-ascii?Q?mqunRJwvcC9v0KyD0Ktzfe+II+iLU8lCZbKr+u2WsrjG6g+un6fKphPA+lkk?=
 =?us-ascii?Q?gvzNi5sH4Lj85II/Hh8GdjGktJSOUZH0xfVqHhnPZOadf0fHHCD9yHySjVbU?=
 =?us-ascii?Q?wfcmS16P+N4AZLMX7VAKjaXp3La24dQ5YI0QlthQc2cKf5gIl4gfiDdwP/8L?=
 =?us-ascii?Q?CD8k//OT4GRYdjTQIyLdGPbYGgnrVkuECFDcF9M/IwYy9ZA/okuMf/EvgroX?=
 =?us-ascii?Q?NmdD3XwKuOYrlJWWK3L1qfANRwkMATzj4LQr/myW8FuPqMO+8s5QLF5v1HZD?=
 =?us-ascii?Q?PPB3xWUNDk/iBdJlk2QBA4P7fBcDNYZpno3Qpx/bJ4FIQkh6XNpH7pp0W+dy?=
 =?us-ascii?Q?V2wjHZFhkxFaTehP3LfP0Th/34U96t+a5sfP5K0paWWWsOPDITz323RE91ok?=
 =?us-ascii?Q?9o8DvZIK2bxG/ixlbahyh4v9iiSj1l2cscjU/5Gm6xl0OVANWYfsAM79KxmG?=
 =?us-ascii?Q?6NV1sGjcto46mVGJ1lyG63TkmKdBCzhHp5GzzBz+2arVvzppw+gjUiCdiCHC?=
 =?us-ascii?Q?rNvyMs8v3e0Ct9WDtwtb6AISV+yAJntqXjjZ/pOnVje2A9vJpGgaGSlS10gK?=
 =?us-ascii?Q?I3dsnuLMZZc3Ovj9Y/j+FiG6pe0ZLkz5GfNXWP0b+C2o0JfQdcYr3xpWKnJz?=
 =?us-ascii?Q?wDToMSytwBREyarB19ej6Fxm4elXYQOJSz2VsRsaZmig150yPiDZ3z36BKbq?=
 =?us-ascii?Q?dqucDcg0CbyW7D2iC5xAuylgEVLtp2ZwIwWTyt7XutvTqohXS7qlPU+5/LbM?=
 =?us-ascii?Q?vkZazIxo8Bo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mtMT7cIJJ+VftAFKPVqbLx3DmHRDzAcv/wkzmMFV8NfFrel0tCtDSYUuS5xQ?=
 =?us-ascii?Q?v4XCO5dU8phKQxZN3nihA80iSMZYSgu+1gnjx0VewMZMvyXbPYlAZbOkEAoG?=
 =?us-ascii?Q?vtzQaq+CwhrDBZWNE3qhREKFqdSsdNw/iR4bbOkNMdmmDv5xq8z3Z+q5QdTT?=
 =?us-ascii?Q?OJanzVho10VOPOexm+U7r9cacPsX2XvqJG61OjFMVkl8azKR8Aczw1+Wr9tp?=
 =?us-ascii?Q?V9mum5zpo//yM1lCCPQ6A3vFUB56z+JobgP/Oq2c64/WRF08FE36sCAjKsEa?=
 =?us-ascii?Q?wCIbI8B9tPfBOeY/CbeDW95k7EHdCTh88DZVOcKQH4vVGoPKnRmr/ku04xRf?=
 =?us-ascii?Q?g04gxDyc9xhVjhwV/g5QX74VW6SVn/Zmf0Gf//SWS7FBLb70Bf+trFMgS035?=
 =?us-ascii?Q?zB0TYXQDA7V6ODn9JcYWG9mwCHgRSF8urkINZkHNH4OjlucAmnxwDmGDnIpe?=
 =?us-ascii?Q?qBcXRTaAQrBVAqho1RYnNEiLlF0yYmryeRRvsAY6za38wjSzPT0g2XbUyEJA?=
 =?us-ascii?Q?MgHENLic0xUL8IK/gwQpPFHuhqNiHEqBAPNCpXmylqE5qUY3C+f+160E0lZ+?=
 =?us-ascii?Q?xPiSMCBzosSR6hcUkYhCWY1OUUUpAo255PZN0S3uw1QcFx7BrCU4QLGOEjp+?=
 =?us-ascii?Q?m13r2j7MGWBpAJGPdPm9kjqPGeKkWsY+2e7it5XKHtGb5uGppEkCR36KRd3t?=
 =?us-ascii?Q?+KmU9Ed818FaqN6lVPGBCxvieoj8z3h0k3ak8J62dR/8pda5Dn8XIZxmNSgC?=
 =?us-ascii?Q?679ZsxvdAPxCdCefTyECSxX0UxpFwU0sG8Grm6Il4qVEgL21JKsrV8hXAK7i?=
 =?us-ascii?Q?XEicjNZjFWGEWeyDpKid4npaRyGYQpGxJDDaJGwj0x9Eiik+itXesQxbyD1l?=
 =?us-ascii?Q?yzPejxU5ObXWBvhDoO09ckzcaEEUFHN5pUNe8J81fVFMSkKeitTLVyplktye?=
 =?us-ascii?Q?9Yb1++3ynpDOdN/cXFE1OnGTv5634I+7nIlGDOuAP5vDg1ajVTryNxcF+M5i?=
 =?us-ascii?Q?ib076O6jlz2G3iKh3vNyZO/QkuWvflX5CGNjjHx5eOhSp+/9Glx8IcRCKf7B?=
 =?us-ascii?Q?yYEHG/Q3TjtXBedy2MTkFkut3epO+cQSdkvwRPHNBXZTjLuONTs0GKk37EQ3?=
 =?us-ascii?Q?SCck54hKnCTw2VvTqvlUnMHFFsIUemkfHWYu4+kZ2uTrs3wfIXid7XqSeB6d?=
 =?us-ascii?Q?JF2lHY3EXOLMV0fqxYl/wahPHRQ3FauZFxCAq/nntvjGqe9fabPf1CduvN0C?=
 =?us-ascii?Q?OOOzfSC77gMYXJN32EeGsGUI9KmYclQqK+FMoMROCAvE06ETVwtv4ZlfqDzI?=
 =?us-ascii?Q?6IWsG2+dYzdBb8IF3mI6nrtsN28Cz7x2ansuu/8ttGoYbG14MLpPH03vXBwE?=
 =?us-ascii?Q?lmm9y1G+FobnQeYlYiPeTGIaXjawbJW/KK8tGAJDJRaOt4V1SziVA5JpYPdG?=
 =?us-ascii?Q?C3abdvbEuX6+OihhlVtPfK9JKtTzZ5WSs34aW9cisSeyQloU/E0RHiyz+E6Q?=
 =?us-ascii?Q?Qn08xsnfJSpkXVTnZ2qTHYL83EHzexoBtzfmsZpSv/42F3M9nm+pWklrqoON?=
 =?us-ascii?Q?/W65LP6stLRPMhy4ryo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1050e75-e110-4661-3390-08dd454aa415
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:04.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLVrSzupgHdaBLzFqL1A3MN8ABPWjZuDGQ9/lrEfjpwrx4nAV5xP5AU9nxkYC0HF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

This converts the remaining places using list of pages to the new API.

The Intel free path was shared with its gather path, so it is converted at
the same time.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c   |  9 +++++----
 drivers/iommu/intel/iommu.c | 24 ++++++++++++------------
 include/linux/iommu.h       |  4 ++--
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 2a9fa0c8cc00fe..3d5a2ed2e337be 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -114,7 +114,7 @@ early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 struct iova_fq_entry {
 	unsigned long iova_pfn;
 	unsigned long pages;
-	struct list_head freelist;
+	struct iommu_pages_list freelist;
 	u64 counter; /* Flush counter when this entry was added */
 };
 
@@ -201,7 +201,7 @@ static void fq_flush_timeout(struct timer_list *t)
 
 static void queue_iova(struct iommu_dma_cookie *cookie,
 		unsigned long pfn, unsigned long pages,
-		struct list_head *freelist)
+		struct iommu_pages_list *freelist)
 {
 	struct iova_fq *fq;
 	unsigned long flags;
@@ -240,7 +240,7 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 	fq->entries[idx].iova_pfn = pfn;
 	fq->entries[idx].pages    = pages;
 	fq->entries[idx].counter  = atomic64_read(&cookie->fq_flush_start_cnt);
-	list_splice(freelist, &fq->entries[idx].freelist);
+	iommu_pages_list_splice(freelist, &fq->entries[idx].freelist);
 
 	spin_unlock_irqrestore(&fq->lock, flags);
 
@@ -298,7 +298,8 @@ static void iommu_dma_init_one_fq(struct iova_fq *fq, size_t fq_size)
 	spin_lock_init(&fq->lock);
 
 	for (i = 0; i < fq_size; i++)
-		INIT_LIST_HEAD(&fq->entries[i].freelist);
+		fq->entries[i].freelist =
+			IOMMU_PAGES_LIST_INIT(fq->entries[i].freelist);
 }
 
 static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 688c0e86a8256e..6f7dc8b850a450 100644
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
@@ -1422,7 +1420,8 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 static void domain_exit(struct dmar_domain *domain)
 {
 	if (domain->pgd) {
-		LIST_HEAD(freelist);
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
 
 		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
 		iommu_put_pages_list(&freelist);
@@ -3558,7 +3557,8 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
 	cache_tag_flush_range(to_dmar_domain(domain), gather->start,
-			      gather->end, list_empty(&gather->freelist));
+			      gather->end,
+			      iommu_pages_list_empty(&gather->freelist));
 	iommu_put_pages_list(&gather->freelist);
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e414951c0af83f..166d8e1bcb100d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -360,7 +360,7 @@ struct iommu_iotlb_gather {
 	unsigned long		start;
 	unsigned long		end;
 	size_t			pgsize;
-	struct list_head	freelist;
+	struct iommu_pages_list	freelist;
 	bool			queued;
 };
 
@@ -849,7 +849,7 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 {
 	*gather = (struct iommu_iotlb_gather) {
 		.start	= ULONG_MAX,
-		.freelist = LIST_HEAD_INIT(gather->freelist),
+		.freelist = IOMMU_PAGES_LIST_INIT(gather->freelist),
 	};
 }
 
-- 
2.43.0

