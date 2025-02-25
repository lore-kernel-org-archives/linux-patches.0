Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF8420F06C;
	Tue, 25 Feb 2025 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512398; cv=fail; b=afb+MPLl+qHWX6+dmCccGkPZKtbl7DOHBVpTno9uChmEUvlnis4VcRbrUfMn2gWcAyRtH+KZ2g2SxxXklGKEF7LRn+lqqPUB0ygec/Z9Sj+qA9EL9DvcdTCkv4VW4FlJIuDPPXLH1TZp+oUxg5PtZaXlscedYiZn+3PFI77qOmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512398; c=relaxed/simple;
	bh=7oHI0GyLumgvMIKvUpqw1CJEOMSRESC/V+6irdYMai0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i79q67P1qBV+sd7T4uXs/UFTK6ZnLlwpM0s0BJdCCF4hyjF4ivQ0ipEdPxrG9wUMk664dbv3nOZbYPMYmGH28S19EPuvEfNozfWea+GFGCpZfCxRJMeGmQbczFnmini34tbvmHjHewzYewyuxcYB1zpgL5jxN94Jp1ujMRhzNlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KZj4MpYg; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KZj4MpYg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGv8chlyEEJSda5RD9F9Wcrsk9NWxNa2pyjnb1uUVswzAnoR6CDHSd0ODVd3or766kGqzDzafZAiYr5H8YPR2do7f4oJ0h5Qzs4Wf13aoDP/talhbFuB+mxsnyVMS45kWZm/EaLDEOBw9K0NisY6d3LPE6RiQL0GYf8Z6kuOgkYtr6UvBqQNO77xYZuG5epGNgGOUr3fE9dDAB3c5XXRt/kr5jyoOddNgpFWe2IZDqhj3qraOyNATV3d39s7qfyn77vlVC2u6xL0W/TX5wyRmf+EBL+YUvZUxfJlzdLyifgX2K0tWxdqxY7ceJYTXclHegCo4Fvg4ICFVjFtfX0WKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Cs5EsFaIBa+5XCjoIlnH4ZtuXAiKKIXEQ0mSW7vR1A=;
 b=i66yCNytbGdt5wK0A/6zC9LiimQ/smk22DPqXLyznmFxwLRFbe1dm3iU740VyGZ2VAftgk6hunxZU+6HGHY5PULJazQQJ3lJlqXT8dith+Lv8beiSREDH3cmqndZMYyEoLApn12PfMgNFab72leZMcO47M9aaZZwxuijQi8dqXaHwqRcwaRt4B04FYwhKeBPKSLEffkudmdGywSkohXDO0yMgWvaXUwIupS4/NbRUP7fUUNSQG5zwmb0NsviHP5IE+wB3g/6ZZIBIMSZhpE3xw2b1h+73JJxKckXozjQW8czTB9j3ZjwrpG7/rnUfE3qaw/yI+94yk70PedQ76znRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Cs5EsFaIBa+5XCjoIlnH4ZtuXAiKKIXEQ0mSW7vR1A=;
 b=KZj4MpYgUHwCctW6g9hVS3uLaSE3h6AqpG17AlBstlDJl/N9cNxvcgi186nPnhUzzLmVSEGPuGwqSJMj8mz3ritpqaVorz5oppOtFWkpSk8AYT5P/1a4mXnUGU7XxoERnZ+HjXMbazDOLnJnt4roT9CDy8M0l2sEC5+nTK+a3ac+PxBylZcNzJ1GKio/0JrqGOJ6wU7CwNt7J1UdAZ4Awb7ZJudaWRxvDM0ToGcdQ5B/eBPa8vgJAj8JzXXW46Q5VRknCEjwUEnOTKC5k8vpq+rME/lni15UV1r0rDW+ABYBKecOUGcwBC1QbxN70iiXiX9ssNtEoEpWtZDOknEjFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:46 +0000
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
Subject: [PATCH v3 13/23] iommu/pages: Remove iommu_put_pages_list_old and the _Generic
Date: Tue, 25 Feb 2025 15:39:30 -0400
Message-ID: <13-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: f516dd6e-a489-4d75-55fc-08dd55d426f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P9oHeundMok9KY6RaD7KOkL39kykJN4XrgDSl3TR04gO/mKt7W3KKi+La8fr?=
 =?us-ascii?Q?d2mB0Ia3iXvOxxFetOJaRzBhcP2iEFjfyS/y+JL6Z/9qUlzJYO3OiC0NqQMs?=
 =?us-ascii?Q?Jg3AGTNcMaCv/Ug2H2haMEB7p4M96/iA8ESjssuFxhYIf7tOiFuXNVHmmfpE?=
 =?us-ascii?Q?9aW8ZZ0+jNn87NibsheBq1BRjP/rNs8SA4Qcu/OCO7L28uvQe+9xOFR8zCNY?=
 =?us-ascii?Q?paaXQgL5XjgOEOTt+pU+bmb1YnKMdQwSyPEvmKijch5IEZ2tda7KK5GWM6so?=
 =?us-ascii?Q?JC3KSfAj7ydE+IEI1OKWfOfuuYw7pfMhsr5XGv0svX2OTqfc7eKzvQuZ48Ve?=
 =?us-ascii?Q?WT+NNiKsJfo6ynAjEiSCyYkcor+5B/XomN0kMYUf9O8IuL0YAQaBri+q98gJ?=
 =?us-ascii?Q?u5zA6UgPGwYQKLK2dYuiRVIUp/yeM6ROObv1UR7NLHom4EYotS1W5f7+QcLv?=
 =?us-ascii?Q?aBTC4NyQMVwLmcoYiODDxR0QP6E1hF3fA2Gv4Pml0H5ITI3JHouWp/Ouss8K?=
 =?us-ascii?Q?pDO7hIEm4eFaEo29q7sncTWk9e5ZaCMIAIs/Bh2pw3PFsbcMzCd+1cVbTGIs?=
 =?us-ascii?Q?7x+Pm++cmsoPbPcyd9HQ6Lqveq5sSN6Q2JYp/C7gGzTMw/kNf3Q1LiCzXQ+6?=
 =?us-ascii?Q?XfhhilCtPcQtZF8w/EMoNJjJ03UM8UMjqEZYB+C9GNEKE2etv2inYtH4s3CW?=
 =?us-ascii?Q?RV+p+MxCJaIeV8sM/VEV5DeLh+HxkEyweJXnagpjX+quCyRAtMrEz8c8zmwm?=
 =?us-ascii?Q?zVarye/yWpiGOI41E6JwQ9VjUOJUq7DXp6qd5zR3xSX4MBlLA4/8BdCkIVmm?=
 =?us-ascii?Q?q505n/AlpJKHmPZ8YzA/Ulk6AoX+JMq/YGtfqASfPHar8GEwlgWqJWYK1PY7?=
 =?us-ascii?Q?n+2YlTd0PvH2BaMAtrbO99IKaEpinp+UFrfOT7nhtEP/mz9BHqlf+Hkjo8HR?=
 =?us-ascii?Q?TI+6CUIDX/BxGtPpbAdeuDNBYBuZmj0gSEsBuBOUDKKwlEmxZ/khZQxlMnBf?=
 =?us-ascii?Q?TvgENDkE+FOghWo/YmAnfTqroC7Jyy1+LcM3QaMXroD+876VoqO46d88MxSK?=
 =?us-ascii?Q?52cJajYTNalx6Fx5x55YQGyDaRzhlZGy2M0Ud83UMeOBwmhBawlD0VtcDdWB?=
 =?us-ascii?Q?7Hi0IzWLWOW7NJ8b1wK+IKiI21pGHp+6kuq2Mn10SbMQQ8VEm8vt/+mzwScv?=
 =?us-ascii?Q?R2KU5gyv5GHx7u+swz30Tb9AQ0uKp083XGXBtQ1JnKTZg5xcIDCT1l1ntiHx?=
 =?us-ascii?Q?svKCFUV0ibIpsHJbQOQag+T8x/EeCiLH8BlHlIUfzx06f/pjzPHpM0MolGWw?=
 =?us-ascii?Q?m+c5383H9f34lBldnerA0lbLsESkphAZcNTFMuniBkC6jn7/jPzmnjmsb7+r?=
 =?us-ascii?Q?BKjE1JiuVYWrSUI1FBTY9yKtzo1HAYX7Zhru7W4h4JpYy9Dtm4/u9XNNYKsP?=
 =?us-ascii?Q?BVeC6hzeGxk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0UJ+zu8be5xyESR1whoQ3yEjLDxcWZ9lon1tBdCq4uES2S2V/1tNWPaQ1p8/?=
 =?us-ascii?Q?UTGm6zRoj2lgbkxcHAj0vzJj9QuRczEJTrTUoctsR8rEH4qyGznREzl14qdR?=
 =?us-ascii?Q?bpZBWizim7/Eqjj+JCFw2bByipsZJCpNJHyeFF2NkwJ1GQ6InXLngd5k+pIp?=
 =?us-ascii?Q?qlUPm1mo3ew4ry002pd1gjq+L6x0TDsGxwz3PCAvLiE1tFuR2xbHJ6g8G44i?=
 =?us-ascii?Q?wIMAYYlnqXnPT6tkjhmhQNyq7aNNJaH4Ili6/zikJ5Vtz5FfUcKcZZRVmOan?=
 =?us-ascii?Q?jl4H9Xw2iWSIaUFogvaiJRkSYwrvyOv6xlRRu3xZ64rexgtvJagFR6rGYqUX?=
 =?us-ascii?Q?ymlW3ZFzPnwuzPCtbzlTHwjg2BpjqILW7zUd8jl6nsif6DQsA+tIF+UJ3V7f?=
 =?us-ascii?Q?5krjrXjIqJ6+CUBmKZ8smXC8AmS4KH6VyM9iQH94uLZW/EnLW568/AGjLYgW?=
 =?us-ascii?Q?Bcmv+upu4pSO4pmVV3PbtU8eaRCfiBdJD7Ne62tEdtYyRfNajPOFT0tfrUdV?=
 =?us-ascii?Q?LXb+B9L5cpu2+TpvY1zmCZt4mc4PekxwMYbl3yPBH4N+ABuBVue3RP7GE4gw?=
 =?us-ascii?Q?s4wUbL2j4QvHSGpLt+bzL+SQO9iDH7NPG0suK7g3kFC59sT5s7SJJHs8+wn5?=
 =?us-ascii?Q?k5OGO9alp85IdKohAmf/kpoIiiA1w2kLTnru67EsqhEOL6DU5g7EnNaDrscK?=
 =?us-ascii?Q?AA+arHAScOwFKF3lZGfxtsplyy3cAXUcPFnybXgEpUCdapxubc6pXplI+v0x?=
 =?us-ascii?Q?Gg9WwUKmN6eJL4VR4xLSEQ8KPZuvStda9vNdjxvadZ93KLdkMftJMvcWVjz+?=
 =?us-ascii?Q?TI/iwzN2WCoBBFhL+ibqJIOEDcXL5Tb1HBeHKpmATy/JD8JLdEyMGAudoDDG?=
 =?us-ascii?Q?rtbBPwVXBakQovfYNlWw3vx0CQH5OMq5qc+4Fe1yYbToatpEacs2sM9yl7kq?=
 =?us-ascii?Q?eRJTl3h6/Qr1H4wboVV+jL1X4e7/oubipLgZryocO8d0cI+9i/fY7iiuQRb5?=
 =?us-ascii?Q?+pDgNaaTWIxRxXBkVRTFMrOsUY4CGLPCuvu7C+a37VpC/FhC5cGb4H+Eh2pW?=
 =?us-ascii?Q?TObM0oe+3M6HnOi4EvWWfszWzdGJb53xfyx0k/NIRhRGUapEvpbwY/xFKgID?=
 =?us-ascii?Q?veSpNH4f8JIHaOZgETqQYTsmk/13lK8CYMMKAC9d7qqLztsUwsdjttZHBYDl?=
 =?us-ascii?Q?7+ABVRfTGG4Dn+Y/rucROWvD0286diQA4ZDukYOt3QVsz3GGy1rHrKydkrCi?=
 =?us-ascii?Q?IMu0AonYi2e3KHjV2/eUZD3fcLWvvKHqbxsvbNvT7XXULTatGEj0DcpjzA6s?=
 =?us-ascii?Q?ExQHPtoAzzB2sp1sqFds9PnAbrh9HBjT7RoKmA/sy/vlIuqvGCQ8eIbQy+Wp?=
 =?us-ascii?Q?gAs9ScB/VU+2ZC8WWtXSfzKs6P3kb/uQzczQy7p6SPBuDoQWYIkYP3RDCNmd?=
 =?us-ascii?Q?EBIp2LgOv/hW3lTAY0hF1jBw7gFD8eXeH35JKhwKa7wsMqJT315IEM41WjVm?=
 =?us-ascii?Q?1k/zm2yBidWSbsYARf+vZU+VakZf/WTjdr/uRG52fT8/k8aA7xa4KMQOLgvE?=
 =?us-ascii?Q?6EGO+JM+bA1rfNCFNhsuyWIOeZfuKeOPB/4Z48Fa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f516dd6e-a489-4d75-55fc-08dd55d426f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:43.4542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbHpkQSrJIiaFvOBLMV506FtueCTDbxavG7wHYyvZerR+E3msn2vLukvxc6nFcK2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Nothing uses the old list_head path now, remove it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 15 +++------------
 drivers/iommu/iommu-pages.h |  8 +-------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index af8694b46417fa..6eacb6a34586a6 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -67,25 +67,16 @@ void iommu_free_pages(void *virt)
 EXPORT_SYMBOL_GPL(iommu_free_pages);
 
 /**
- * iommu_put_pages_list_new - free a list of pages.
+ * iommu_put_pages_list - free a list of pages.
  * @list: The list of pages to be freed
  *
  * Frees a list of pages allocated by iommu_alloc_pages_node().
  */
-void iommu_put_pages_list_new(struct iommu_pages_list *list)
+void iommu_put_pages_list(struct iommu_pages_list *list)
 {
 	struct page *p, *tmp;
 
 	list_for_each_entry_safe(p, tmp, &list->pages, lru)
 		__iommu_free_page(p);
 }
-EXPORT_SYMBOL_GPL(iommu_put_pages_list_new);
-
-void iommu_put_pages_list_old(struct list_head *head)
-{
-	struct page *p, *tmp;
-
-	list_for_each_entry_safe(p, tmp, head, lru)
-		__iommu_free_page(p);
-}
-EXPORT_SYMBOL_GPL(iommu_put_pages_list_old);
+EXPORT_SYMBOL_GPL(iommu_put_pages_list);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 0acc26af7202df..8dc0202bf108e4 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -11,13 +11,7 @@
 
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_pages(void *virt);
-void iommu_put_pages_list_new(struct iommu_pages_list *list);
-void iommu_put_pages_list_old(struct list_head *head);
-
-#define iommu_put_pages_list(head)                                   \
-	_Generic(head,                                               \
-		struct iommu_pages_list *: iommu_put_pages_list_new, \
-		struct list_head *: iommu_put_pages_list_old)(head)
+void iommu_put_pages_list(struct iommu_pages_list *list);
 
 /**
  * iommu_pages_list_add - add the page to a iommu_pages_list
-- 
2.43.0

