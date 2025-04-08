Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221AE2063EE;
	Tue,  8 Apr 2025 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131269; cv=fail; b=KS9Wy+cgp3W/E5O2BpZk/Kf1BrzRm4WW+1tZoAoKJZ3QVABt6ho09xW10pb+xiqdVug+sE/CD+vLfmz38hD8zpnO7sz+s8BDCZesPEr8doVB+dCq414BASkp6pwJ07o3l229WTZoVR4Jba4LQePr6wJEnLCpe3bd3q+IXT0cMRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131269; c=relaxed/simple;
	bh=p/DxFK7+NFcx8ypmeCso7SNU0qNGt1jJ2gVg6XfLoXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZtTCCXNGpjmv/+/e2yY4P9tWv5C4Uhr+B8UY9IyQ2mU/uhsOHTNgByYbr4vXYnRnmtMYAogtBoFLES/cYIL57Jm/hP6+tCki1tCXRICpMJ7/tQjLqRWiKYI91SxhE6V54qKZkacv2Hlp6QYu4V+R91WilVxROsJXo9Ldyz7zLBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l1EK8bIW; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l1EK8bIW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9UEWnoajhnKEzC1q39RY0gb0uvGyyNShaEfR708x34CzU+O03UQ04LkOfPkYr2/t1W7AOfPSYS2fXIuJotOi85krOTuSxPMaaHV7XYkFZhnnyuCNrK1DASzXxNo7D0W3ReASlw05Xi/HiV5J87QehjG/XD28FiYkOALjz/8Y02bxdY6wvAuoKAVThGwDuustwzYn+ZSTnURZBaL5AOWQ5FNZk2Pky7asDmciyxHdPYs2LGbqRqv9NHXYUsJe1l/QNP4MFhUGOfeN88Om6fhHkrNT/ltgFo4hj55sdPr/TKUvTqBaEgsB8ylg8m/ucbJrvTbQa9OpF3L6Kx2Rf1F3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TZ+x7gJ5UYyl3U4d0W7G7snnPyKONscK3UWinwyBxM=;
 b=WY11YVA0aM1EhnxWfUFwcvPxM6wyrHlyXjRnE3g0g6r/U7Q6UNqGiH9ozNOVwtNdx+1uL4ywdtuDdYPUPt/aFwOzNpPIiQqWV2+tTLQHgOy/lfj1R6xVElwJsZ+/ECOvsfQqYld4kmTFQ29STGzzaRGv4k5QZ66moALk7QMrLcwws+uS+1+9ZFLx8Ay/m9xWTTDzr7mIR/oTnMVgTUZDVP3JCfX8eIkFsIJ1cZf/QUJq2GDg2iTtW734PTk7BA3EgrPV5CTd+PF9aFn3O0dz4wB6kNSJhLDEDc/cyHw5l2kMeU/QwFSEi0zicib6WZh1rsQwOam5StcVErlZivRgog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TZ+x7gJ5UYyl3U4d0W7G7snnPyKONscK3UWinwyBxM=;
 b=l1EK8bIWScn4ophQl3LE62j9XMgmihR76YdZ3bZLB9/JMqrtwavmJnClKK0QZT/hjA+dliQpQxTQj6aNbKrTHw2bkA7VqR3y4I2kMm+GlK0Y6Bet6+y5Kvpy3zo4/SFz6L3w7uVYNx2zsYA0FDtZYNNkuJqdwc+Q48QylUcmB6nktno7ee1ccCzBeIyQhYZU04b4i6VsiBpdkipJVWbk6Zntvl5qfnwN90R5HxANwrhJmw6GlN0QB4Uy9fAKtvRTQXPbhR5PatHnaIq6c6jLELb/bK8uXl1FjwbffdalekQh5t7ME6PkuuU11LsikFcreZaMHgKfHA7v/C8rCgIl3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:18 +0000
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
Subject: [PATCH v4 03/23] iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
Date: Tue,  8 Apr 2025 13:53:51 -0300
Message-ID: <3-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:408:fb::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: fd3cb10e-6cac-4ebf-53ec-08dd76bdfe4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KnzCBJfwznu7aMmateBoGXR7ZWfeScETv3/0HPTXUCjl2EXruVrwUVH6xCnu?=
 =?us-ascii?Q?i+Gt+/ZmvVAfjMDhPdKI0maCDvYRejwmK70mSS6XcJxZjGw79gNVxZ3xz1qe?=
 =?us-ascii?Q?f2krtMy3WMFiSSwKDaqQcoOx56OZaJ29j19AwTpRIoXgAsWTsCKqKushq25D?=
 =?us-ascii?Q?/LwggSy2TCznHZrKTJyvrc6DjoiV7d/bo3g2FEhpRCNnKL4+ACleKZEZl6Ri?=
 =?us-ascii?Q?Yaj5403CB1YeEoTqNWljTbksxU3TOOb1WegItz2vTmQ8d7kAIY82EJ2HxT62?=
 =?us-ascii?Q?O73Lh7ak4i3QqDyyoeJ5kyAvIIEvmkKbAIJucVmaGx71juE1/sVWgPVJJlqm?=
 =?us-ascii?Q?TNhHN0U3FhAfqx6r7Zq1n8xE47qvT4B5txtgREzRnYIA0H55Liu6HHzMItjn?=
 =?us-ascii?Q?cAoAvIomne78IGvA0eiDScaRfAjxDf/hrO/2fgumLW8ghOvlh2Q998cQjBAE?=
 =?us-ascii?Q?NKXzLb+cBczxvBTC3B5XXYbPssjzgbgkyttpgFc2LNnrcbaVEjNUxHMHuYrz?=
 =?us-ascii?Q?77NNTE+sFA91ZV35aClzX9jDWgFbGSpuUVfhfOUgwSsX4+lJqVeVb474Vs2E?=
 =?us-ascii?Q?edOxS2NE2/p6xwzp/CSLBsgeEB5Fr1TXjx9IBxlsoF4ClLeRNu9UkMOP/0Yn?=
 =?us-ascii?Q?p6Qv+hwZJCE61e03b6xYMxWbKsqqamhs1WwG1+MHLyEstjrA8QJuz8HNGU5T?=
 =?us-ascii?Q?qCDnPH1U8tmDorw0pAsV67s84XycIGSZOA2LAEIukUOX7P2gyjv5Wf0PEe5J?=
 =?us-ascii?Q?fnN6ESNL8gt2PKUHZM5dArR3zIJaMjlVDxWonHHK3h/lhTomipDXCTMVhZI0?=
 =?us-ascii?Q?Luj3dA9z5W6UKrLpX5Z+NCD1rLTyCmwiKiW+6ASB+/qpJIIvywWTqkw+/NYP?=
 =?us-ascii?Q?vZdtIVnIJeUF0OP1ATFO6wLNFaKcbNqxVv8OH2pC2H0NIhqsmh3hRrplKs3M?=
 =?us-ascii?Q?bBGn3m6OpojKyBogFK0BMOyn5XM+XfDlvzxxb/NJehWgoFcv7pIYoBfdUyzS?=
 =?us-ascii?Q?+KfXQwOwqcYRtwXlkI7Jk6mi8CIovFVJ13QxhErmq6hsDFtVODZERougsZS8?=
 =?us-ascii?Q?bf+VjvOvlEHpQ+7zkv9moRht6SLtP/mPgNOzk1uoVpI5qkeNHNCFag2iXhjH?=
 =?us-ascii?Q?CkKngkywh286nwRPnyNhKAv9Oo62ICKkMwfSveB/i7mXKAsZQAvdkjuGyhBH?=
 =?us-ascii?Q?VbQ1MY/J/FCv+hqewQKgBL0ROuiwiKDjp5nLTSbxwdvh5ndqyDqZferZGKxy?=
 =?us-ascii?Q?8GP/BoWN2VtGnfQ4gMfenv6QtcB4GaTu+9A2kJKjx3bNxQjtCBr8ZXLZI9sV?=
 =?us-ascii?Q?y/ky8rpXsPt1zCrm5LqITZO2PcwGiAUcwjRaVHzI6hKaS1bU3OYJIVOHbHSf?=
 =?us-ascii?Q?Jg/wd3zilPqbf/ewPBQCBRXGzJ+UU2CGuIYItjtFEXKI8eqUKfA8knKY3E/N?=
 =?us-ascii?Q?yDLxtgkx30z7w09wHMHPGB3+z6Wd5Bur?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?315tOBdivZ401gp9Zj62WhOE597kFgKq2Od9aARJK1Viz3N12XDWfepFYIC8?=
 =?us-ascii?Q?SGlpJ5pCRNUwqBRX2b1egKIvNy2acUi/+SzJrnhPmMJNa44Oba9cvywtX7Xv?=
 =?us-ascii?Q?MYFFXcoc+qP4pTQUFQasuM0Ezxn8eijpfL1QQ/x9R9qKAryC6cBacEKIRKZN?=
 =?us-ascii?Q?ngpxXPOLZIbdZ3dwITffu7sAuNWQQ90ufStk8eQXFH/pAFaO8StjjLdnC+0D?=
 =?us-ascii?Q?z7tXIm/VugA+gHEOWyFThKzIcAvKdACRD4mB9IsgExXvkXwMfyxvwGqotv7X?=
 =?us-ascii?Q?nhpcWBJODZbouDMWR1VR9/4U1pAv4WIsQ9Podbh69OMKJ7WqTyUkOVHd7WYc?=
 =?us-ascii?Q?KwtGvddMfZJ3P+YUOChkUiYv5EWs533F+tTMmiAqQ2PFqAYdg2dMv7WNzLFu?=
 =?us-ascii?Q?fKJVXb1b8+Uellw0ZMydopPoP9tdsSMXZtdNfg2LTW8Dot8S8Si+TvMKMJSV?=
 =?us-ascii?Q?FPGraRv+yWXUrxqesn6VPxH+tob7BPny+cTIp7Npd7DLciruvngz6pqHnnUy?=
 =?us-ascii?Q?oHpUKMX2J9+7CDd01ULEVLmjh5VCZrL5jpy8FASBUHBBL4k5T4iHg/sa3ACu?=
 =?us-ascii?Q?k70V15SYPLmYeFxMmoJ/3ms4uBprR/GGiJ+ti6JL0aYTVzigyoEoNwaF9krI?=
 =?us-ascii?Q?9aCwyhCrpSuQ5xyGvL+Ew5rtLuiR4AYtNLcDEXXDsWgmOVZlqJecIAq4noTY?=
 =?us-ascii?Q?5RJtcupNlrzVdm9XafUZM8E9YDlVCg6LzH7JWoBthLfs9r/Qyg/MQ+QWUKHN?=
 =?us-ascii?Q?J+vIMqoYKOBSaODk3beWEuMcBFvMC/gYd9/HNPbF2mKsFgxDtLu0g0sSDG0g?=
 =?us-ascii?Q?mHreUvWb3MXHh5boU+9k16DDhOLaY1J5uzsTorqAZXhPWqVMLqsa0W0H1MUG?=
 =?us-ascii?Q?DyFr3bytEjWNjF6GQZ6MzChU4mj/C5r6YLRwz3TYIx4T1fgVFxWSFRt3B6a/?=
 =?us-ascii?Q?qNQCed8f84rPMoK1eWXJQvhkBYP9ly7o1l1G3Z3fEX2LpIBUXp0G1PCLv6rN?=
 =?us-ascii?Q?GV9Lj6zel8aMfrCWSNRtQbHFz2tAT8XaoyslVMTwvK4SNEjyy59LL0ZPxIKq?=
 =?us-ascii?Q?nKtWirQBPfo8a7oVYBMEXg51ca+OOOFObygjSLotZvVC0GznWcuqJtWxzJl0?=
 =?us-ascii?Q?8BzAAfC8AsUusemSWKA2ahcU2Wh2N7NX134H0RaPWNxOmJ/sC4K/hwzbGxLf?=
 =?us-ascii?Q?Ue29TOmNXq/k5Oj/EdJ7BZjBzfhWOzNtmeS/uY15o40FfTPiLY+dPkno0xmX?=
 =?us-ascii?Q?h5EYsTL+PMLGZnocUO8dsIKNOV1NulchyXJGHBWAt0b+fM+Zz+O4lBxuStyQ?=
 =?us-ascii?Q?Yz3I0nx5+fXoKEuL/Out/p1jhNfNxVn3mdc1vONLqW6HRKNktAtSExByDgUz?=
 =?us-ascii?Q?J5o09d/WKHZaypIKAREoshUh8639hJn9eM31kxkiddE66+5n8/h5qdukaAa9?=
 =?us-ascii?Q?d1XX06L3vGiTK0EwMccL0RDytuJWr/jYFhA25atiYmIKHLJrZRyNM5zUE3Wv?=
 =?us-ascii?Q?wWvbkbNzW3r3fSzhAZqVRFVxfxNAJqT36A2WcpIKY4YPoJQBLTMcoLvduVk9?=
 =?us-ascii?Q?B0Aly/1s7WjNBxQMIlcq9ZVd+xzbZon+nEauZViJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3cb10e-6cac-4ebf-53ec-08dd76bdfe4e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:14.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZBAqx51RsYfmr2IzJMp/i0VUGz3h9vm1WEdET2OjkDg7gApZfM1YxEEw5oJBXtW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

These were only used by tegra-smmu and leaked the struct page out of the
API. Delete them since tega-smmu has been converted to the other APIs.

In the process flatten the call tree so we have fewer one line functions
calling other one line functions.. iommu_alloc_pages_node() is the real
allocator and everything else can just call it directly.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.h | 49 ++++++-------------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 82ebf00330811c..0ca2437989a0e1 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -46,40 +46,6 @@ static inline void __iommu_free_account(struct page *page, int order)
 	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
 }
 
-/**
- * __iommu_alloc_pages - allocate a zeroed page of a given order.
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the head struct page of the allocated page.
- */
-static inline struct page *__iommu_alloc_pages(gfp_t gfp, int order)
-{
-	struct page *page;
-
-	page = alloc_pages(gfp | __GFP_ZERO, order);
-	if (unlikely(!page))
-		return NULL;
-
-	__iommu_alloc_account(page, order);
-
-	return page;
-}
-
-/**
- * __iommu_free_pages - free page of a given order
- * @page: head struct page of the page
- * @order: page order
- */
-static inline void __iommu_free_pages(struct page *page, int order)
-{
-	if (!page)
-		return;
-
-	__iommu_free_account(page, order);
-	__free_pages(page, order);
-}
-
 /**
  * iommu_alloc_pages_node - allocate a zeroed page of a given order from
  * specific NUMA node.
@@ -110,12 +76,7 @@ static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
  */
 static inline void *iommu_alloc_pages(gfp_t gfp, int order)
 {
-	struct page *page = __iommu_alloc_pages(gfp, order);
-
-	if (unlikely(!page))
-		return NULL;
-
-	return page_address(page);
+	return iommu_alloc_pages_node(numa_node_id(), gfp, order);
 }
 
 /**
@@ -138,7 +99,7 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
  */
 static inline void *iommu_alloc_page(gfp_t gfp)
 {
-	return iommu_alloc_pages(gfp, 0);
+	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
 /**
@@ -148,10 +109,14 @@ static inline void *iommu_alloc_page(gfp_t gfp)
  */
 static inline void iommu_free_pages(void *virt, int order)
 {
+	struct page *page;
+
 	if (!virt)
 		return;
 
-	__iommu_free_pages(virt_to_page(virt), order);
+	page = virt_to_page(virt);
+	__iommu_free_account(page, order);
+	__free_pages(page, order);
 }
 
 /**
-- 
2.43.0

