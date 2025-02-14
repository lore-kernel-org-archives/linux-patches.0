Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6C9267F78;
	Fri, 14 Feb 2025 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552900; cv=fail; b=YixjqG5IrAkfNEeJGW4sgnOdJY77RoDPmjcHLtE2BBA3c+7FmGx92W/Obx/5T2eGTzEFGgBhV1W5+kpIuv4mX3aXjieZ6V+ABSUF5KgsCNaWLQG7BtkJbLRol8qKJrg7rPA4glxmOwuuavUXrkRFSi5Tx0v5bJs9PAxqUDT+WoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552900; c=relaxed/simple;
	bh=UtzKKSBnaS8lFZPW0jL6yaEcdSrKtxLoeFbl758erko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H2uTA3GGar6KlmszICyw9FUx1NmHT/YMn6fUtXwSLV6ivAUJPrbb4O/VCDjWVl5qVIwSTFLo6ZfTRKKeS99Z+TkqWgeDSji+6KsyqLzYX32I3cVD4eCBC1wYCYDXcKM/xOGYoi3CKQaS/MZVZt/WKrkgfR+LU3J9et7R+YCtxMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fI2QqcG8; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fI2QqcG8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPrKvJtOj2lfhodu6DXU4FtvS7tXienxtYBtO4sq1iFrahEvQ+LlEROd3oZgp1/8toMRiMZNjm6RYMrZeMKjegieUJnsdVnQd96eXnwgtdJunLV2oESjlWUMGPWPe608SBLYEpPB6SBZCAe3ipq3Aq5y0xWDWiQYrgFdXE5HDY5HgAXxTdwBX4Oy/mn7yqz7/UYb4YpO1M1Jz6Ss76l6eSdkH/NK/fAoI+CrfKwNltggnOStEJ0m5dybE7ER6s7ARaqVhv/SAHpjgRSdAOo14mXX6rSVaQnGREU6u9OrdOYQgfR5Zz8B04LR8V17oGST5iRDTBE1x/Ngv/4SI0ZNUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYH33h7k/qpe+6EAOIHWfkZhWMg4vY1I6a3/YmcazLo=;
 b=E1OdmZHcGUUMy0qTzKmE6eZVoK2utYzR7jSPF9z6uWPmaQo7ndKmmy6nGw3fCmO9KBOqsLvx+UxdLKIjTqCkaxecR/LrtQPw3EVuKcZcEHd8vPZPsSEVi8hnPBrMW+/b5kCa6B8D2PSkVV/eppcxAv5tEcyoW/L0sHc+ZikQcoBJUKNd7p7nUPTX0iM0AxfPJen1PAca+UcdnJnY7gUMmZS4s2T9GCtplQWn3+tWq8Cew55+UkSIQbbXnf7B9lOUWzF2Xsw0zU5YMnI1yR6K+y5nKe0wAza+MwvPZYpDGLN3UvZOZAHS4qfKUa0wzKbcrB0D/8LBqEF6r5eS9Q69Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYH33h7k/qpe+6EAOIHWfkZhWMg4vY1I6a3/YmcazLo=;
 b=fI2QqcG89XTO9V8XEWoCE73vXya6PUMTXvXKccx2EtCgnBQ1k6y/g54rreNCKtcHrTyAKh8E8qPKbUFVs+S9ZqUW5ef1UqMVxZAfWA06VZWQma7NSjKKv2gnc8oxZjjbL6zFvaGmgYjp1oMtPiGMY4I7Qhcodl5RLsoQhwp1ZKjEXucuxi8f/4+2LTy1rdQPGztTSkFmJv+AVJ1nPZe8TpbemHtZ5vfkfPcOht9yo9NY0655JXjRd4vdv8T2Gk6s+dY9JgVStxUhTuI9zz9YSZrlNZlFikIsKaajicI550mcvI6zWUHJwgGR5gX/6zFEljDbAVfGD2PMHSiF9lidDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:06 +0000
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
Subject: [PATCH v2 04/23] iommu/pages: Make iommu_put_pages_list() work with high order allocations
Date: Fri, 14 Feb 2025 13:07:37 -0400
Message-ID: <4-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:208:237::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e6a6e04-d7ec-445a-9f11-08dd4d1a2210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SrqJ1XYPi6LLNawuQVvchmbN2Llk02m5TD4lRbVEHD9Yz8lsI6g+y9I3UxxK?=
 =?us-ascii?Q?qF4Jh1ufiYVMtcIaVUsZWtNFdf/uVMjIV4dTbVBYtk6a0AAUIrldsdXdSyMH?=
 =?us-ascii?Q?LpStvseTlmrBkpyV11srTVVPe0cQqp+R7XHTxBJvtFjjJzq+t6yDDdUaW2DW?=
 =?us-ascii?Q?4bu4QN4ijAVBGd7oaATkTxUkvHrc/AKK9+H2/KahKjJvQLb1MuLkT82JXShq?=
 =?us-ascii?Q?erRamNwJTWA8j8Ubso9tuehma+0x6LToBibKPpvIaaKmaUOlg/XwzzTYB/Jq?=
 =?us-ascii?Q?igXoh8x5H+4lwSrnlvcYUnAsq5VgfJFKBN+5Vvn8/37m0m5HeAtAekBzOR4N?=
 =?us-ascii?Q?7pB79MiAX+HPxmuBF6y0DpJOC4oiE6x0F10WT1rOFe/LbxtrmBg3SpbqMNwF?=
 =?us-ascii?Q?iYhAcZcaal7U/t9fn6H+sOLE5iWKKWmtVcd/v6hnq+UIMsr5O2a+u+AFxgzK?=
 =?us-ascii?Q?48Pjk2YVIN9bKJaKq7YNirs3LjHcJgmB+FcsjPkHOANplNQU8molf1S+VK5L?=
 =?us-ascii?Q?vBfppCKmrpHnNrn8qs8PGy9CeeB23MlE3J/ohAvgz3Ufse+17Q8fSieceEHf?=
 =?us-ascii?Q?fvCV1PRA8peieMsawaenbRJULYpZtt5czV5hMCKLErfJTady3mm8FTRLr97A?=
 =?us-ascii?Q?pEo3TPz0EPfUeDubWCT4cx4ZSmSHJjZRg7YSwSOdIZihj12GvKZCGIUv6x67?=
 =?us-ascii?Q?lY7/vFeS02gfQTu6v5utFtj5B7NVM7Kx9HSPYycA0rko4XZwbUDgFTBXc55+?=
 =?us-ascii?Q?nZTiYYtM6U+M4EV/59aNFYXHGrenz6RgG58BTqc0RaeMjby06XC+hUcnaFKl?=
 =?us-ascii?Q?uLKIP08xZMmYsmVmZJl6cpW/ksDZQu61YvlXzlz8S62V8hhWDW8G+Tf7We50?=
 =?us-ascii?Q?HhG+rL5jMriHyn7T8xQ/KAZy5qxybWRQMMzY7WVz2GMWlHH5yCYaWv4NYx4q?=
 =?us-ascii?Q?yU95AEDm+cvAIigW6O+H30A7CEGtdA6fiQ/96cM2P+BniYjxuOXbruaW0IGp?=
 =?us-ascii?Q?OsB0jKWV8QrZVsJHASSf8owMHHTkfIYZ2EBdjnzm7GFaJA1VDD2EQuWFbr50?=
 =?us-ascii?Q?z2fUyHw/kr3A1fsHetTEAoRU0JaTStXdpbHmUFDIbqt2HH08h4S7BKwdp1UH?=
 =?us-ascii?Q?PviQa7InPJpahb6mGJoKXFxLUe7u56WMgItkLwcavjciHs7zgu/rY19IzW43?=
 =?us-ascii?Q?dNPqwjvwYLi3U+Cki3L4Djj7ztNRGeSq3S2gdbMUZxQR2Z79NwtoSnJZ6zOq?=
 =?us-ascii?Q?cY92RfOaxO3Jr/wulDe31sDohZVrhRst+6V+N6SUTkh+CJ/i1imckM9rQBUR?=
 =?us-ascii?Q?zEQuDwv6frNWBkydkmPiac9nW7TnBU3hahVC0JYnrWuxeU8UyuLaaYT2/NWt?=
 =?us-ascii?Q?HDk6cl9BjBNLg8+3IU9uvCAcItQJXI7qMhEYyQErY2t1Ak/lIPivrtLaVxWL?=
 =?us-ascii?Q?JyvGZqQTRpo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LAPUHtO6udFxEkrYXgtb+Hurtd7GzLM0FnfB36CWBB+/Flmipsry0Xf3hc/D?=
 =?us-ascii?Q?Q7WBwhsWjbDvodp6uh5taFoWixtlFqBvdZcjLvdPd2x3VdGl82iIFZEqZ9H4?=
 =?us-ascii?Q?Cle9jNInGinPwuPKrP8kHqV+zEyUR73hKK6zZhIJvoMlGhaa1wm3/bcGogv6?=
 =?us-ascii?Q?HSn75/t7x6Q8U1Wma5lzSZuguS2zDhMhnWTdmsAS7yWj0x03yhApai0im8lV?=
 =?us-ascii?Q?g2rR30hLKNSdip2f82JEXNg579otkqe1Ht1bj3wIjlB+CMntw/YOoO9nyCLX?=
 =?us-ascii?Q?HG0zUAQQ3ecnv8zf0o5joysMObWvKtbdx24YAvkyQf4WT8e/IDD1ajePhfrM?=
 =?us-ascii?Q?4dPGfpqToDb2X4Mi239RddOAODZDXSgvT8qQj5iQ7eCyUiD3abx3vt/hHTBY?=
 =?us-ascii?Q?51PCEZOjYbWQ6axDZZF9guWwr6KtO0RTLVlMgbDrY/+h9WyRC/TOZnbWGuvQ?=
 =?us-ascii?Q?ojlagoyIYzX2tajvQLT6U2gjNFDTen81j0/NF6JS7omySZW3u0Qi8O/QynSP?=
 =?us-ascii?Q?wr9Dji3SeEOG3VV8Fa6KEhDqq3KGiYY8qRRbJl3XmZZUGxijEuYkqpBCXM6U?=
 =?us-ascii?Q?wxNTTVDmhL7WvAHDIgPpHMhlF2bTQJhD4gSwx73TlbPzxwksRkYzaih3503y?=
 =?us-ascii?Q?K+plqmUWCGFEkbGYW39ZVbbZ+xl+bwIeRatVW5VeXvpFPH6JckyPMmeU05t6?=
 =?us-ascii?Q?+FszOBDPg3DIGKpiavy/aIB0PVND9rlI+FQYHk3zaZgoezuTQL4XB9UXEsl4?=
 =?us-ascii?Q?9OjsHE3kpgMVmsViuRMqy5ILsBBto9Uvkt2WRED8fNsM3jTMt4z446e/EjQu?=
 =?us-ascii?Q?bxHiALExateVFeKDKke+Q7x+dxTc5lQFb+Pj+KOi1vYmj3n4XHj1TKDYpDNh?=
 =?us-ascii?Q?l2zjGWUSKPqfa2Tla2oVwuqM0flEoAV6SLmDQ6Wox/p3Y39IRjLB7X59jR0T?=
 =?us-ascii?Q?fHK5i3YpSs0ZfbDQDM9UAKWLgGlx9eWQ+YAwS/sHgw8brpHEoMEWayDNJf/6?=
 =?us-ascii?Q?hzjVaiDiue3zvqA9gifZ8bBlTfXVRrIrsYLRL5aSA1CDCT/ubscv/VzV/5SO?=
 =?us-ascii?Q?iDrmWVksvPWz5Kp6gVoJUJqywqSV6R+aSI2LZvFhmh2moyi1cXN/HvQGC3Pb?=
 =?us-ascii?Q?ZRqdvrUyRkPlUg3F4A+dINU14fG9LqP9vDM9XWqWq8oAZAIdAzNusQqK5bJ+?=
 =?us-ascii?Q?PND9vfVotK48AObnXrykEf1eMsQD4fF/X0a1remH2x0E1yJ48ACvUJxOKfMk?=
 =?us-ascii?Q?Zt5ud/nZI2e/FkRDVwsiM1LKW7uzFB6tlJDoqQQ8rpWhSMmhF7Ier6rbcbsi?=
 =?us-ascii?Q?bfFwO8oqn5KHD1R97Lu0MhGsrwzES7KhoYTEj1ADwXJPFTEl6822aJRYKhon?=
 =?us-ascii?Q?avDqphbOQWYliPKu5B1tyDq1IMtjjHfw8ZKGbb8eDNGvjb6GQ4Ok7hdmtapn?=
 =?us-ascii?Q?z0kz1VfCYYLWS6GoyxxY3mKKtZCfHv+IyM1H8Qrh7cq2pW7dRiesuJjkZkwF?=
 =?us-ascii?Q?AHrHrRfMcu6hvIZEs7WlWN7c4XLcF46SGxF4sGV4sCYUxfX5bxqcAAXd9B/7?=
 =?us-ascii?Q?t0VCuZpPc5D7cMHilyE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6a6e04-d7ec-445a-9f11-08dd4d1a2210
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.4773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPzg4cePWvVR7u8zFHhRLXVUW1uoL8tF+RfdxYOJU/nmNCNC4dpMA/hmoBXqeXs7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

alloc_pages_node(, order) needs to be paired with __free_pages(, order) to
free all the allocated pages. For order != 0 the return from
alloc_pages_node() is just a page list, it hasn't been formed into a
folio.

However iommu_put_pages_list() just calls put_page() on the head page of
an allocation, which will end up leaking the tail pages if order != 0.

Fix this by using __GFP_COMP to create a high order folio and then always
use put_page() to free the full high order folio.

__iommu_free_account() can get the order of the allocation via
folio_order(), which corrects the accounting of high order allocations in
iommu_put_pages_list(). This is the same technique slub uses.

As far as I can tell, none of the places using high order allocations are
also using the free list, so this not a current bug.

Fixes: 06c375053cef ("iommu/vt-d: add wrapper functions for page allocations")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 0ca2437989a0e1..26b91940bdc146 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -38,8 +38,9 @@ static inline void __iommu_alloc_account(struct page *page, int order)
  * @page: head struct page of the page.
  * @order: order of the page
  */
-static inline void __iommu_free_account(struct page *page, int order)
+static inline void __iommu_free_account(struct page *page)
 {
+	unsigned int order = folio_order(page_folio(page));
 	const long pgcnt = 1l << order;
 
 	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
@@ -57,7 +58,8 @@ static inline void __iommu_free_account(struct page *page, int order)
  */
 static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
 {
-	struct page *page = alloc_pages_node(nid, gfp | __GFP_ZERO, order);
+	struct page *page =
+		alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
 
 	if (unlikely(!page))
 		return NULL;
@@ -115,8 +117,8 @@ static inline void iommu_free_pages(void *virt, int order)
 		return;
 
 	page = virt_to_page(virt);
-	__iommu_free_account(page, order);
-	__free_pages(page, order);
+	__iommu_free_account(page);
+	put_page(page);
 }
 
 /**
@@ -143,7 +145,7 @@ static inline void iommu_put_pages_list(struct list_head *page)
 		struct page *p = list_entry(page->prev, struct page, lru);
 
 		list_del(&p->lru);
-		__iommu_free_account(p, 0);
+		__iommu_free_account(p);
 		put_page(p);
 	}
 }
-- 
2.43.0

