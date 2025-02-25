Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF8D20E31F;
	Tue, 25 Feb 2025 19:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512395; cv=fail; b=h4glxMmXGMy7C86bECdjBR6iKzyeE9nqYCVb0l4AXGS2PiS1ffaEakJcUexyKLEJY/ALy63Sjg0Zge8p7n1tfO8g3QsSXucx/63i+Nzxx/VWDvXg0vRhgmh5QwYsg7mifJnu9SV8JTgZc7BT92C5XApM4N+9DkUI21QVYN6M3Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512395; c=relaxed/simple;
	bh=3w+pUx7So7j4O6blLmD8O5fIBe82WlBd8SSzrNezI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DkzSeGBOlmEsxqeKhckOdJcjCvF+UWazVCpum1AL+rb91h0jwnSNo8sdB0k6sZvz4i1ygFSQfya9KPmhcMvj/1CaqgAxXK0duWumXzbML0UDYmPW2X2rdFnGfVI59eS2rhJtDoj4ujGXFkrY918v9mbJFxSjrgtDJOe9WeyN9jA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XTJa8CoC; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XTJa8CoC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9d+tUHDXJ040LG06OVJHkWn544rwQzRGg1E2Ulh7aChVkv7GyfqwAvh0I6dTzVWDJkJTlQBL+3YWKzVr8Hq5opDpdHTrU25Ci86N4dteMIholq8Rwts8fKgC3yy20ppk8UdODNZGWqE2zEaTcNbMEoAG+myDsEkIZcvz2MlTZUgduijwyTryLVy6J4ccC392dEoaITOpnQTVtbMElulG6/0Dt2ukR1JolRQhK9bX2aWYCa5ly2fQRIJ0qaX69QfVGGcFL58nC5Td2ex8gTxtd182A/OQGH+HBZDrP7+7QWaBEPcTnQLEhn9KFpW5JY3QPHKJI/GjinGAdazrwomVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtZJ4xMLD9+fk8VLQ4Ts5Z8FQO2u4Pxg0MV5NMplONg=;
 b=SXbeEZXDAsu/ymbRsP/QvhEGuUU/4EtTmkqA7bkRVE8LumI51NFH2+WQwEUeV4ZrqYs/8Mrzeuy9iXDR6lBDUgQK9Qc4iSsbVg7W/qrqkA3I16wRr2LfGa1HjH9y/1gVuxz+B4TPvqLprrKo6M/RBFcnjTPWadF9C7xAs8o/f5N5J8M5o6WmSt7P/mvlCXbT+/qV6lrVLiuDWKlP0ea1ODv7bdhxX9n1ycnNZJN/BFdQrFRpv4cR79CF+kiLVBVB3hzyvYVrjWJSsqYkNCWdYVgJSKLmrd/zuxgHh2hxpm72peNHr+w0GM358SWBV9H9LQb3Qho4hx5DvRkeXrKNCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtZJ4xMLD9+fk8VLQ4Ts5Z8FQO2u4Pxg0MV5NMplONg=;
 b=XTJa8CoCcpWAxzIsjOzVb4bRBsbsdTej+Ki7+XmGXI3U+x/qY54o36Frd1wh6daUEtBYbFEogK2HDj/zyP81Dlo3fLa8rpHI/arnhLEv4tndQHvg5nDgwJmob0n/mQOdLbi9kyX1x7qFN5Tzg+ASKgn3b0wTxAhmyL07f9iaQP16y7TmaOJ4WydIua9vanLOe2sp+LBdKKnD4oE+Hi33KSNy0KZZQOhTRser7jlVLZCXa3dNIKX6fE6ThwC7f3dPjJ6Tvu7XhafXRexXCBc0UN5hFXP7C9BL/bRACBEOAG8U0FDXzmF7M9o+PwScLBl1H8Ebi7eSPS2uKMUSgh9IlQ==
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
Subject: [PATCH v3 06/23] iommu/pages: Remove iommu_free_page()
Date: Tue, 25 Feb 2025 15:39:23 -0400
Message-ID: <6-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d15a54b-dd8e-4aee-5ed7-08dd55d42683
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eSKdoTZREuZBLIyIVNX0kC5Zl+GUMGj8aTFXKII098XVsHTG5LS09MnR9tKT?=
 =?us-ascii?Q?32l7zqssWPvKjtVH4V4HbVVBe8RslKsoD7F4ukhMvtpzxgKQ+5/fY146uuoQ?=
 =?us-ascii?Q?5BFxIyhoap8CVOEUg+sEofTIgZOSk5++NZMd7onqSJLVywDIs+6Q4XgMaCnq?=
 =?us-ascii?Q?+x+d660VTzbsiF0/aDeg/ZAkVgo4y4NPAiPbGlt5to5AbD6qHITeEbrjdwCL?=
 =?us-ascii?Q?ZUEfBf5zle8HQQfb/tpDpq/B+Hcu6n6tepy8LnEJvhIqJxvQ8R07haBuUvYf?=
 =?us-ascii?Q?Do2pdwIJogI76o0VDQD0nvzYiT1JM9O5G+6GH6ZSwOG+Brd9Rie8D8QhnDpC?=
 =?us-ascii?Q?OHbpBZZosAsThmlYIsGR8BQ4N+CJ1B5d0kewlkrp95C2VbRaJf4PFHJiUceg?=
 =?us-ascii?Q?9h3XeAKM6wP2p/O3roq5jD5IqD+9p9+8Zu5Iaswn8doQUmxyaBChhxZb935x?=
 =?us-ascii?Q?B96Lb6M4fQgu+xKPoiRva0dz0Xi48O/WZJrmAKNvlxkybzqew5KeFBBrbfI+?=
 =?us-ascii?Q?UCD3IdcUqCbYuyljza+0b+nS5s+qtaK9udFS14oYHirDEU0lC+wfqJYwA3Sq?=
 =?us-ascii?Q?KyNIO71WgNzZVGpz8Kx0iyC1gDWCESfQr1ffl7RS6Lybeap4xaUf3NmBfHiX?=
 =?us-ascii?Q?Xg4rmr0wnf0FntyjZmI4qI/XYeJFmFw2uQGmOyP1ORjJ5ZSrnXsxvvLZMl6z?=
 =?us-ascii?Q?cdjEHXP8LdIwpMQQrJQb/AZY1kWXgheNc8O/9bkOr0FNBk92HzXSuTdC+M5e?=
 =?us-ascii?Q?kUyAMZXwud44UwIRLaX/wlUCIuqZ/zl+z+4U4hXt1intkshsqNRBSDVebdWD?=
 =?us-ascii?Q?vMjtKgk5Pnsb7HkDy0dsDQC6ltwPcVQfzs25enLkejnfSOjXE0uGp80P7nap?=
 =?us-ascii?Q?+FaFLH+xmGZxHahpAJddnnbQF+ygVyjCIcnnwqOBbQk3OwZqe6ElpDHaTfZd?=
 =?us-ascii?Q?SgV8sEZz8+Dlbfz1SvGPSc/BvHFa0uG8wZmsyz1esjzo1eeR5t7v/wZvSYVB?=
 =?us-ascii?Q?oJlCo3JzCJ+KH1guNfkxSYGNw+CaB5teByfPJi3+63HC/5mj826wN5Y0Qrva?=
 =?us-ascii?Q?2GX1FzxMzjL7aqcBEwA3RdziTb447+8ZLn37euBvHGDONJzybBooXJC7rZCw?=
 =?us-ascii?Q?RqR/kBuoVJ1r2UE4M7z2FtHiG2sMoPpFs1AFMmhDwfWhBFs+d3rlqX25lv/+?=
 =?us-ascii?Q?sIOf8RFCckY7J1g8wHxgUJ4ri6PJJtRng5as77sDCq8OPTex4Spo6FriuH9+?=
 =?us-ascii?Q?jHk7X+PgbZEeO7P0uJVsEcj0egcRF3vzS6GPEr9PeTS+i7zXoLnrCPPXRnr2?=
 =?us-ascii?Q?hayIxM4GpoW33XuKS2T47kp+o8V2MYi5OTv0VWCsfuQ9xGnkFMavxW/5+1B4?=
 =?us-ascii?Q?Lb0ToKTFwSRGjdJpRu9dRg3J4e0XVraEiblZmV2osEfEBTnKXHnxEwGWpqOr?=
 =?us-ascii?Q?7BJky1NBiKw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k5NNAhogyzPT+Djt5J3eWTfJsfmteOsjq5fSjZ6q6FVass+6cszQBKcER6oK?=
 =?us-ascii?Q?xYlP4DLih8JrpfMnRtDptw3sqCPnEbUqkmkTXELmp7OvuX7zNo3ljxqCQb/n?=
 =?us-ascii?Q?dh77eCcfqclrvk72PN43NtWILuF28wPRvrFGAoypRLyujCgm4KoqUOryTa+e?=
 =?us-ascii?Q?cFYPYLhKs0q2xM0bLEiPn6qFX6J0N327jYHGiEXloj+YAWuq6WroZrFt02jt?=
 =?us-ascii?Q?O1FGj9lqwwBZRUY65G+zn3kR3zSXOLN2AEyK7CYsnPdMbT8tL+Rjvlx7kYvC?=
 =?us-ascii?Q?9a5TYR5zR775sKrPsDBey+UIpYiZUtshYrWsg80i3nnr8dUzMwvJ/PNuzaqz?=
 =?us-ascii?Q?lD4F+S8weRoF/0oWMcYk8VLlzquDLGQLAl8ufXnjqFZsN/buYxIYVqxBMMJy?=
 =?us-ascii?Q?sXuCeAXTm1XXquiSYhB4hWv3ben9Po0V5h27vN6i2CwbmFE1vYOUDyQcBbZG?=
 =?us-ascii?Q?30dhsuboBOvXUCl/NGVxXwQyD0hoPfywt38+3N3W7WGu4/6HPZSQucEsvx03?=
 =?us-ascii?Q?5o+Yo5+7jb4ORkviOx5f0/Fdsa8C0lWK1l+3JhZKlUxm/ZOziFYjtK74vIoS?=
 =?us-ascii?Q?3zCCL7yD6WYtSvKz2TZfMvpys21ZpyuAP/Pc7XqkK+BTLKZdj94QYo1rNVAY?=
 =?us-ascii?Q?LLQ2QbwQn6rGtAWhUeyvn7iTG/5MHod8fCqRnZ/MSrBlkNzWuH57P9AJ8bT7?=
 =?us-ascii?Q?TKHjyMqsVKs/BhNXutRK/o8tboxGw0lg7ld7SwBGT/zxdejPvzYGC0qyM8nh?=
 =?us-ascii?Q?wDiARrE17ABf4UuFmdocqgJoCGXk33PPC3jPeGpP3w11M1DumEmcjijQffOg?=
 =?us-ascii?Q?QYdulTe9aC1ydaBOZ1suHenDkK70tu2RFOwCug0cB3+5Qxg2OyBhM6HJXcKJ?=
 =?us-ascii?Q?6CSTzbx/+2USk9T9kIRP1wA9vtRkFQViCoZajwzB6xjYhWAAmTVPv6mV2vjc?=
 =?us-ascii?Q?gUVZ7OVC1sUswXztmZnmItYKJe2f68VRF0JRPjZttDOJlOi5i9fQ4YZ4+9Fo?=
 =?us-ascii?Q?aNhx4aAxkVVPiiWUd95EnJzcZZhOK8zpRhAXQ61zJVLyKi+y3QOCk40zEgPv?=
 =?us-ascii?Q?hn/M6fYuwBj5BktVPgsfw7xPUUWnL0ExN8pbNNMnLx4iAdb5kR2klVlu13lY?=
 =?us-ascii?Q?IDhIYzrN0C/UUclmNXvFSUwoCv+nCBhh4lCN2RY3ITYET/naVcgQ4i0GV/ow?=
 =?us-ascii?Q?Mc/x85ZSktpqneREE/mFgxlMqHrLIHsVRlyfwaRadmglTUyrJZMAifGQVRjl?=
 =?us-ascii?Q?7gBZkNspZ+fkdKpWM5ibEkPKuZKztx53lzverJpj6rY3JbSNbP6A+cHMFQMz?=
 =?us-ascii?Q?zyFOQ5DEJQrUXT+b56/hjzznUm/2HA5vg6mIQ7BFmGrRNA83tLt/DiADiuV+?=
 =?us-ascii?Q?YblWVCoFm4f3T8V7IItMTUXZTcNg6vtIqUOS6KWeSqDMKcv/D1UZ80ipVU6G?=
 =?us-ascii?Q?x/pYwzAekVrUiYODhX9WjbZ7ftUJvXKhjFnmMIftMeMgoh+OOu4is0sRLI4f?=
 =?us-ascii?Q?OrLO/tpnJLz8Xano8EbX0kIsqONg81cd7xQjuOvoKVzVFURaq5HBoSYt7na/?=
 =?us-ascii?Q?att9cgc9XCQipMyVegZCvmFhYLRw4NkgZwgNoZcV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d15a54b-dd8e-4aee-5ed7-08dd55d42683
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:42.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfB9M9vaAdmpAOgFxj7Mfk4PhqMuJd17zj6Y5ETuY+3KA3/DoxiJmVNAHOcp3+fn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Use iommu_free_pages() instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c          |  2 +-
 drivers/iommu/amd/io_pgtable.c    |  4 ++--
 drivers/iommu/amd/io_pgtable_v2.c |  8 ++++----
 drivers/iommu/amd/iommu.c         |  4 ++--
 drivers/iommu/intel/dmar.c        |  4 ++--
 drivers/iommu/intel/iommu.c       | 12 ++++++------
 drivers/iommu/intel/pasid.c       |  4 ++--
 drivers/iommu/iommu-pages.h       |  9 ---------
 drivers/iommu/riscv/iommu.c       |  6 +++---
 drivers/iommu/rockchip-iommu.c    |  8 ++++----
 drivers/iommu/tegra-smmu.c        | 12 ++++++------
 11 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f47ff0e0c75f4e..73ebcb958ad864 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -955,7 +955,7 @@ static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
 {
 	if (iommu->cmd_sem)
-		iommu_free_page((void *)iommu->cmd_sem);
+		iommu_free_pages((void *)iommu->cmd_sem);
 }
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f3399087859fd1..025d8a3fe9cb78 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -153,7 +153,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
-	iommu_free_page(pte);
+	iommu_free_pages(pte);
 
 	return ret;
 }
@@ -229,7 +229,7 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c616de2c5926ec..cce3fc9861ef77 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -121,10 +121,10 @@ static void free_pgtable(u64 *pt, int level)
 		if (level > 2)
 			free_pgtable(p, level - 1);
 		else
-			iommu_free_page(p);
+			iommu_free_pages(p);
 	}
 
-	iommu_free_page(pt);
+	iommu_free_pages(pt);
 }
 
 /* Allocate page table */
@@ -159,7 +159,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 			__npte = set_pgtable_attr(page);
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
@@ -181,7 +181,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		if (pg_size == IOMMU_PAGE_SIZE_1G)
 			free_pgtable(__pte, end_level - 1);
 		else if (pg_size == IOMMU_PAGE_SIZE_2M)
-			iommu_free_page(__pte);
+			iommu_free_pages(__pte);
 	}
 
 	return pte;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b48a72bd7b23df..e23d104d177ad9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1812,7 +1812,7 @@ static void free_gcr3_tbl_level1(u64 *tbl)
 
 		ptr = iommu_phys_to_virt(tbl[i] & PAGE_MASK);
 
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 	}
 }
 
@@ -1845,7 +1845,7 @@ static void free_gcr3_table(struct gcr3_tbl_info *gcr3_info)
 	/* Free per device domain ID */
 	pdom_id_free(gcr3_info->domid);
 
-	iommu_free_page(gcr3_info->gcr3_tbl);
+	iommu_free_pages(gcr3_info->gcr3_tbl);
 	gcr3_info->gcr3_tbl = NULL;
 }
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 9f424acf474e94..c812c83d77da10 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1187,7 +1187,7 @@ static void free_iommu(struct intel_iommu *iommu)
 	}
 
 	if (iommu->qi) {
-		iommu_free_page(iommu->qi->desc);
+		iommu_free_pages(iommu->qi->desc);
 		kfree(iommu->qi->desc_status);
 		kfree(iommu->qi);
 	}
@@ -1714,7 +1714,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 
 	qi->desc_status = kcalloc(QI_LENGTH, sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
-		iommu_free_page(qi->desc);
+		iommu_free_pages(qi->desc);
 		kfree(qi);
 		iommu->qi = NULL;
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index cc46098f875b16..1e73bfa00329ae 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -571,17 +571,17 @@ static void free_context_table(struct intel_iommu *iommu)
 	for (i = 0; i < ROOT_ENTRY_NR; i++) {
 		context = iommu_context_addr(iommu, i, 0, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 
 		if (!sm_supported(iommu))
 			continue;
 
 		context = iommu_context_addr(iommu, i, 0x80, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 	}
 
-	iommu_free_page(iommu->root_entry);
+	iommu_free_pages(iommu->root_entry);
 	iommu->root_entry = NULL;
 }
 
@@ -744,7 +744,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			tmp = 0ULL;
 			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
-				iommu_free_page(tmp_page);
+				iommu_free_pages(tmp_page);
 			else
 				domain_flush_cache(domain, pte, sizeof(*pte));
 		}
@@ -857,7 +857,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
 		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
-			iommu_free_page(level_pte);
+			iommu_free_pages(level_pte);
 		}
 next:
 		pfn += level_size(level);
@@ -881,7 +881,7 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		iommu_free_page(domain->pgd);
+		iommu_free_pages(domain->pgd);
 		domain->pgd = NULL;
 	}
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 00da94b1c4c907..4249f12db7fc43 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -96,7 +96,7 @@ void intel_pasid_free_table(struct device *dev)
 	max_pde = pasid_table->max_pasid >> PASID_PDE_SHIFT;
 	for (i = 0; i < max_pde; i++) {
 		table = get_pasid_table_from_pde(&dir[i]);
-		iommu_free_page(table);
+		iommu_free_pages(table);
 	}
 
 	iommu_free_pages(pasid_table->table);
@@ -160,7 +160,7 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		tmp = 0ULL;
 		if (!try_cmpxchg64(&dir[dir_index].val, &tmp,
 				   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
-			iommu_free_page(entries);
+			iommu_free_pages(entries);
 			goto retry;
 		}
 		if (!ecap_coherent(info->iommu->ecap)) {
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 88587da1782b94..fcd17b94f7b830 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -122,15 +122,6 @@ static inline void iommu_free_pages(void *virt)
 	put_page(page);
 }
 
-/**
- * iommu_free_page - free page
- * @virt: virtual address of the page to be freed.
- */
-static inline void iommu_free_page(void *virt)
-{
-	iommu_free_pages(virt);
-}
-
 /**
  * iommu_put_pages_list - free a list of pages.
  * @page: the head of the lru list to be freed.
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 1868468d018a28..4fe07343d84e61 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1105,7 +1105,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	if (freelist)
 		list_add_tail(&virt_to_page(ptr)->lru, freelist);
 	else
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 }
 
 static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
@@ -1148,7 +1148,7 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 			old = pte;
 			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
 			if (cmpxchg_relaxed(ptr, old, pte) != old) {
-				iommu_free_page(addr);
+				iommu_free_pages(addr);
 				goto pte_retry;
 			}
 		}
@@ -1393,7 +1393,7 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
 					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
 	if (domain->pscid < 0) {
-		iommu_free_page(domain->pgd_root);
+		iommu_free_pages(domain->pgd_root);
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 323cc665c35703..798e85bd994d56 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -737,7 +737,7 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	pt_dma = dma_map_single(dma_dev, page_table, SPAGE_SIZE, DMA_TO_DEVICE);
 	if (dma_mapping_error(dma_dev, pt_dma)) {
 		dev_err(dma_dev, "DMA mapping error while allocating page table\n");
-		iommu_free_page(page_table);
+		iommu_free_pages(page_table);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1086,7 +1086,7 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	return &rk_domain->domain;
 
 err_free_dt:
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 err_free_domain:
 	kfree(rk_domain);
 
@@ -1107,13 +1107,13 @@ static void rk_iommu_domain_free(struct iommu_domain *domain)
 			u32 *page_table = phys_to_virt(pt_phys);
 			dma_unmap_single(dma_dev, pt_phys,
 					 SPAGE_SIZE, DMA_TO_DEVICE);
-			iommu_free_page(page_table);
+			iommu_free_pages(page_table);
 		}
 	}
 
 	dma_unmap_single(dma_dev, rk_domain->dt_dma,
 			 SPAGE_SIZE, DMA_TO_DEVICE);
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 
 	kfree(rk_domain);
 }
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index c134647292fb22..844682a41afa66 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -303,7 +303,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -311,7 +311,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -608,14 +608,14 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
 				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
 			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
 					 DMA_TO_DEVICE);
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
@@ -656,7 +656,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
 				 DMA_TO_DEVICE);
-		iommu_free_page(pt);
+		iommu_free_pages(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -707,7 +707,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	 */
 	if (as->pts[pde]) {
 		if (pt)
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 
 		pt = as->pts[pde];
 	}
-- 
2.43.0

