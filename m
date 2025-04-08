Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6786E23C8DE;
	Tue,  8 Apr 2025 17:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744133065; cv=fail; b=DT4TntqirfeUPvF4hD5bWhaMyLlw2mwe85Qam24b6nQH1WpnCm7syyohCSNuMzJvlrXwDyNxphG/8iUhtm75RXRnk+wAGxZxLYDprYMd/wcL36AHQwoIdnB30nO6EYW3SF90lP3OGqqiLvfWm9KkzLplN0fgKe7FMVSQXiTRz54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744133065; c=relaxed/simple;
	bh=bq2I9pizBR8/YsbWJcC+6hoeMLVm6n8oNKgJ1XmiC1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSyqYuvqT72icctlT0RuMfkcSbkdHefPFNIMrUdKApyyp+Z1pRUV5hl65twtrJWZ5yLZMfLLM3Ikj7LlZ6pnB/FIyje63XE8iw1icRpvfXYCDzjfillYaMjrPkKPMSTJjZERnv6NKq2I0wj+KCRBkP9ADJUCgM1cqzsFSXR0ctc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HLLQec8o; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HLLQec8o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKU2LDE5B2Ap1uhh5Xk4FjFV/qrC16xEc7vMiM/I/7eOL6pKKfBaEnYKvpLj1qa/0gUpKPO+ZLIIVggB0sGcsXA9utAO1nrL/SoJAkYUKDTTDQspRLcUGgNWFHw8PWePDH0xDJVj8Vq8gBBeaFroThc9CZz0LB/vg4hjT+PwtRcr5u2eqBqUWF1uEQqgAmjLmIpWwcvui/pXS/rJeDC5u5VIPlYU5Qa3ZjjownPYcItsQqv2B9IShN7mIQCEWniqVVadLzfC1tyZww53gUmqlEuMy634689dfQ49tiHf0zJG6XEyzaVtPV2d8ImcF/ulq67k8FBHfYC/2HG1yBXJug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pz8aFQru04TskK5JjiC/vlot38W7HjzfjFFPF27YHmU=;
 b=KCP56F+c/uSGk5lieXPThMr186PoMYroSct6y7od5isNBWRDIjJl1kJ+DObbQX8J9BBAF99du1rfzSLj/OLg8ESaOFcoozzuxWX0fa/LHd+bSYPxPFM9wWzS9j6L8A5q5uOmn3NUkzigjehLhINEvHyO/ugQ0vrbHydL0xY+B6jKXCaOcu75fF5D5C58zJ1PFr97ipDwKOaguVVDHKzwBKM+cYNz05HZw9cLWO8UDMOAYb5MOrZ7YrD0t8oWz+/TldldvyLg8pKsuZEUSqbbyVZEvdvPrKzdkiJLA9TkdoPvKMLjFKJcfHLp0o/YLqrItUEz6/Aj1MZ3RZ65JfTZ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz8aFQru04TskK5JjiC/vlot38W7HjzfjFFPF27YHmU=;
 b=HLLQec8onLgCs3m1ycYEm3idKn85W78z5VGJZ83cWDSbgylHHDvi4OfEefatNpjkM1bWbAlKjRCRMLRoPPCv7L9Ya9PTxVtgEkru5SEod1eV2dK9zkoMwvNQlAQEOY3wEkK3Wv9UqyPtChp/DY/pq3yg/yb+V0PMTp5EoNVj4bAgx/+uCa1O5zkHgWUklujeDzLTvtw2Jd+kfcsLPzrZ/BjLUN54ZHztOjkMtPXGEh3JDaozdCLTVrM2LgN3O6bN5YreDPdtcYwJf5Zh1mfdVfKhl0oQYtTrs9T6x7gZLZje9IfvZG37n8xQ5kO533lWtOpfQ8tDvwzjglGu6u/5oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9579.namprd12.prod.outlook.com (2603:10b6:930:10a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 17:24:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 17:24:13 +0000
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
Subject: [PATCH v4 08/23] iommu/pages: Formalize the freelist API
Date: Tue,  8 Apr 2025 13:53:56 -0300
Message-ID: <8-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:32b::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9579:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f44b27-ed7d-4259-a5cc-08dd76c22e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7wbEFybl9bhIDYGUkTs5Vv7rGqekx6W6hfZkxMB/v/zZZkVVamvxREE0fJb3?=
 =?us-ascii?Q?L40lZMQ3QoyKzTpoXZl0ILTvQxP0x4epmVe51zjgJavNUOwOR+9uKvbdnn+M?=
 =?us-ascii?Q?sA+MPL73RlXJEXiYH3V1D4SNzC/cgIodSZSE+vZrDVDW09PoR+85K2hddGPE?=
 =?us-ascii?Q?iHDKprhFeTU4F8b3rjK6nC0ghxk6wxwQwjA7grLNXN67ObIOHZhAawX5DoSv?=
 =?us-ascii?Q?2Ijx7iWuMMXxnFkOdQizZIufpJ6xXHjMe7ZXXq6afQD0e5oydGM3Wsi7S8kl?=
 =?us-ascii?Q?aFF0zjdv1y9CE3KaqcdzbtyhXC9g3MxO1UN094RBrmjmuQtQXQ5LnQH8YVfG?=
 =?us-ascii?Q?xrgMY3j4UNRk3mDKks9nHYBeZz8MhTh9Oq5HkCn1n1NRC6vloH84r3xt83cb?=
 =?us-ascii?Q?RJ0349HqrUpTuw/yRr48UoppAOID0r0CNEGtxcaIHIa2rsxbeNY2gOnq53pY?=
 =?us-ascii?Q?m+STVhrOjhHaY8AmV7FBlJfobzetEjjuSxCcO9UyKQtKI4i75eVJ01YwAArN?=
 =?us-ascii?Q?ucAOa7PYGLbarU0Dw/T1ik6vu8/dmDbSA2XqcdoNVO89nxlNn/NA40k3oKr3?=
 =?us-ascii?Q?aXetxzjIdTNCrB34dlhJCKlfzxOeFlXyctaSKqJ4RbvDy7bP5ZUtJtMgj2Dw?=
 =?us-ascii?Q?LExjm2larnllOl4QkMFWxaEX78EjHm3gjjA6hwgurfZiPxKH2vT7/57pVkba?=
 =?us-ascii?Q?iNOthTRK6Qknzo+JItRw5WNd1pOA/n4JCKfnu/mHi9FueXrRy5PoaSSLk/xk?=
 =?us-ascii?Q?xhKmzBrc4U5BivjQpbyqCDd+Ckr9WRwMUOsCs5Vr+e/WXvgvzlBhddRLOOJ7?=
 =?us-ascii?Q?rVxw6O4Dqkdbm+H9wlkmb0CYu4vu5X2CvxWiTOlUiozmT8P9o857gU3o3RGA?=
 =?us-ascii?Q?tfGkJpjKkzpx+TL1igEfgX1Z5VwpGy2bo5eO9DK4TFUUxR6D4IWqAJ/PBGme?=
 =?us-ascii?Q?UpRGHhoFelVl3hcHb4/nqBMVMa5hqnpXygjHjRcortAbcwODbpjEeJODXumo?=
 =?us-ascii?Q?XgKltOTDMONXFDK0y15rbGx2BaJvtHZgr8bibqCoSsK0bNLDv8l4QDw3pfmS?=
 =?us-ascii?Q?5cPVC+uDgdYKoA6iZH4hY2B/mbAZ+YnQQ+nKbDNKykbW9u0ufQhFQcab7ZIS?=
 =?us-ascii?Q?wm887SFM7pDKxg7rztkx5OezMP6SVoXJFXjn1oqFenQs6syhqXIP0GzxFNYb?=
 =?us-ascii?Q?P0YVtAoH1AGoAFRKRDrIW2/18LCmNBaBTw6wcvKK29aEF8tSYxwPJr07oOjl?=
 =?us-ascii?Q?93iXj/L6A0n24g6KDOKrLMNGXmf3EqIX4GDtkR2nK8v2+h2y5ml4185ZNCmG?=
 =?us-ascii?Q?xm5UgqxgFhqWvBfastNRshmtlHHqVcTt9gs6FT5MgUAZXrEl5SSbgw0iOvvz?=
 =?us-ascii?Q?Y88zKB1HhTshejIbqS/RHdjPH83n0q9VQQsyLPlcDhEGw18Z/vrjDWRKh8IK?=
 =?us-ascii?Q?MeVW9hllZvaI7Hy0zO/OQDgJQr/7yWFhg17BaISSldrxg4ELLc4J7Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8R9/qGmXyxdHMStQcWkj3uPBuZbnV9FB+lSbkpAe0nmYMFTD0JaDmEtEtVMn?=
 =?us-ascii?Q?EGyVgUPdBm80bqsN9nGBxbbTT9S36QQJCa5NWTwtDH1GMAcwkq3vMwROltfk?=
 =?us-ascii?Q?8BKfGeeLbpSuT3BYZmM2PuNi8n+ty5bD183W/E/wcRpIAo9ybBMTwri3yi1o?=
 =?us-ascii?Q?U1f1r53Y2p3fAVsP0n7AbR108LdgguIu9t2raNS3Yx7s16Fu4sQFVIw3pRIJ?=
 =?us-ascii?Q?gs2vwsLMkMBSG7/T9SJ5nr7JuZe8IZIYjGu+GkJQltmMwBvKLxlNXnnx3IOV?=
 =?us-ascii?Q?tKQEMUQeFZjMSwYjtf7vIOxjAt0cxpKr9cZDZi6Wdgq9/fP79ktgaJMbAoC6?=
 =?us-ascii?Q?EFspfbd9dTUz5egEJb2D09HXQvMBA0SRY2xtDKrgwRUJgihOGh/K+m4Xu7g8?=
 =?us-ascii?Q?hWjZtFl1a0gqlxyWVClw1WNK83K4ZrfP1PkHyO9PM5mRx+GO4GVrqOjmLcS+?=
 =?us-ascii?Q?v4TPWd4XsrYnZTUjQSzWSZLkb7K+ReSCDK0wgKKCeZo7kre5+y729tm0fr9d?=
 =?us-ascii?Q?j0cgmA2hp1IMQlh7gpwSysnjEgbHBxhbdCKhzKUlLJ62LpDZWF/zVJS0nzV1?=
 =?us-ascii?Q?xBcVygJovaIkHWO/iHgmknrIhlr83DqSTJQSO7+NetOqYLbOa6Ssh70URzSQ?=
 =?us-ascii?Q?fR/O/VT/KLm4gywmJOkHdh9fSUx4JrRX/CBiLxCNDB+Vf2MvgR2rmJOX7U1p?=
 =?us-ascii?Q?rPiZgd4GRw8A99LJ1VZhXXdxtovTZr4jQNTnHAuYzzhkunvuVDAbwifrV/l1?=
 =?us-ascii?Q?OK5QcugWatQidLRHbX0Z7hWYNvOeDhy6FtPYxDxS+GM3F7V+cuzL2xyDVj3y?=
 =?us-ascii?Q?JvXsegBlKkc48T3wNZgsj5HkEITBoSdom3poSuxQHftVDtqI5nNI0RYD/Xdj?=
 =?us-ascii?Q?2vDvdZ+WRqCjdyRkIfAcaoiI0BmG4i4h3LOzxEwxLPMP/XDQeKjTT/6bRhEN?=
 =?us-ascii?Q?iXz+nHmaUpuAYmWSXEQmf6nCnLFw2iUMv0s2K4eWrOz8hpI6dHphdepPX2Me?=
 =?us-ascii?Q?Oc3W06b9lX8Cv4HzR1F+Q/FE/BBQCuyIGWUYxGWLiQj6mYtyUZsLPqRKXnw7?=
 =?us-ascii?Q?PrEfb2+ArxPY1Hl8Z/mHwJZVjhj0hHZLpVDOIkn7aomyAmdS1yXcUysh1ju1?=
 =?us-ascii?Q?fnBZcA+BKwPXOC6uyAsYvmjW20xjOqGeFHqtT2sSdxuhGOSlGiw6reDfDdEP?=
 =?us-ascii?Q?IjwdE2gLN1S8hi1S9gYizu+M4dvB4PzJREfRRrx7lI2/7CquXVsm1ScBf5+O?=
 =?us-ascii?Q?51jFd/JaBFwtadq9vUbBomnlwXj597JiGFF2lrs4aXqnYXuwbrF4AWBR3wD6?=
 =?us-ascii?Q?l/DxS7gqlPLajrnkFvcd+F1zXQmsNdpVixaey61jV8rS9pyDjmVb0nUNH2dl?=
 =?us-ascii?Q?Gx2186aGgrRtMh1f0MlWNuY0mifzVrkG+tMOMDnL/m3JgnEASonXwMZLJ9al?=
 =?us-ascii?Q?/QzG3WdhRKmBsKqUn184EgChVXRgmoueaXVqyqwXHEIlrI4SpjHEO6H9R9WX?=
 =?us-ascii?Q?s7eZzJ9H3U1QYr+NhsmtNpxTJxbbecQjaY/wtsJBSQe+Uh4mHA0DuIm3/zbB?=
 =?us-ascii?Q?ncz9VpnO5RFiSYbxqVA9BeczuK6AIX6Eg14E011O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f44b27-ed7d-4259-a5cc-08dd76c22e4f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 17:24:13.1551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZubnMpwHGtG2LcBWdG0+FEwLpxstmunvZaGbWvB2ZbU4Ch6zArlm8MppMNiK73lD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9579

We want to get rid of struct page references outside the internal
allocator implementation. The free list has the driver open code something
like:

   list_add_tail(&virt_to_page(ptr)->lru, freelist);

Move the above into a small inline and make the freelist into a wrapper
type 'struct iommu_pages_list' so that the compiler can help check all the
conversion.

This struct has also proven helpful in some future ideas to convert to a
singly linked list to get an extra pointer in the struct page, and to
signal that the pages should be freed with RCU.

Use a temporary _Generic so we don't need to rename the free function as
the patches progress.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 23 ++++++++++++-------
 drivers/iommu/iommu-pages.h | 45 ++++++++++++++++++++++++++++++++++---
 include/linux/iommu.h       | 12 ++++++++++
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 31ff83ffaf0106..af8694b46417fa 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -67,18 +67,25 @@ void iommu_free_pages(void *virt)
 EXPORT_SYMBOL_GPL(iommu_free_pages);
 
 /**
- * iommu_put_pages_list - free a list of pages.
- * @head: the head of the lru list to be freed.
+ * iommu_put_pages_list_new - free a list of pages.
+ * @list: The list of pages to be freed
  *
  * Frees a list of pages allocated by iommu_alloc_pages_node().
  */
-void iommu_put_pages_list(struct list_head *head)
+void iommu_put_pages_list_new(struct iommu_pages_list *list)
 {
-	while (!list_empty(head)) {
-		struct page *p = list_entry(head->prev, struct page, lru);
+	struct page *p, *tmp;
 
-		list_del(&p->lru);
+	list_for_each_entry_safe(p, tmp, &list->pages, lru)
 		__iommu_free_page(p);
-	}
 }
-EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_new);
+
+void iommu_put_pages_list_old(struct list_head *head)
+{
+	struct page *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, head, lru)
+		__iommu_free_page(p);
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_old);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index e3c35aa14ad716..0acc26af7202df 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,12 +7,51 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/types.h>
-#include <linux/topology.h>
+#include <linux/iommu.h>
 
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_pages(void *virt);
-void iommu_put_pages_list(struct list_head *head);
+void iommu_put_pages_list_new(struct iommu_pages_list *list);
+void iommu_put_pages_list_old(struct list_head *head);
+
+#define iommu_put_pages_list(head)                                   \
+	_Generic(head,                                               \
+		struct iommu_pages_list *: iommu_put_pages_list_new, \
+		struct list_head *: iommu_put_pages_list_old)(head)
+
+/**
+ * iommu_pages_list_add - add the page to a iommu_pages_list
+ * @list: List to add the page to
+ * @virt: Address returned from iommu_alloc_pages_node()
+ */
+static inline void iommu_pages_list_add(struct iommu_pages_list *list,
+					void *virt)
+{
+	list_add_tail(&virt_to_page(virt)->lru, &list->pages);
+}
+
+/**
+ * iommu_pages_list_splice - Put all the pages in list from into list to
+ * @from: Source list of pages
+ * @to: Destination list of pages
+ *
+ * from must be re-initialized after calling this function if it is to be
+ * used again.
+ */
+static inline void iommu_pages_list_splice(struct iommu_pages_list *from,
+					   struct iommu_pages_list *to)
+{
+	list_splice(&from->pages, &to->pages);
+}
+
+/**
+ * iommu_pages_list_empty - True if the list is empty
+ * @list: List to check
+ */
+static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
+{
+	return list_empty(&list->pages);
+}
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ccce8a751e2a55..6dd3a221c5bc66 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -341,6 +341,18 @@ typedef unsigned int ioasid_t;
 /* Read but do not clear any dirty bits */
 #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
 
+/*
+ * Pages allocated through iommu_alloc_pages_node() can be placed on this list
+ * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
+ * can be used this way!
+ */
+struct iommu_pages_list {
+	struct list_head pages;
+};
+
+#define IOMMU_PAGES_LIST_INIT(name) \
+	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
+
 #ifdef CONFIG_IOMMU_API
 
 /**
-- 
2.43.0

