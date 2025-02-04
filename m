Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5DC21885C;
	Tue,  4 Feb 2025 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694119; cv=fail; b=I3tdsOhBX3SuXFjkiwBZbBXZKnDqjyG2yZIVyx+fxM5sD+6baJ2m1OrCpseKc9RSsppYXUj3dJfWLbzbUhd9nUVd4/prjZohrTtznYGfDu/YRY6rYor1MhppCN99oDjRY+VtRaMRPnqDrqNsOpnzSMaI2AXy/fC3JwBGhIuoML0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694119; c=relaxed/simple;
	bh=14pOMhvHI3es5xbf29xjIo+BFKxoAwFzwQH4L6elr6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FMF5aYSTdFOs9Oh1kkcHg9Jqus214D5kfijpRRJJHwckSAwPHhmQAVtZXk8tObSq2pEWTsgXVIlM9wh8mrm32GZ8qcaKAclNmWa4GwVldr6co0qRKDV/OHNoAH/AXZ6k0sY7/TzgbpUHmZBx6DjTCaFjJgTd2NzA3o8Bc3LEemo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OxVV3sbc; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OxVV3sbc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NbvS+QjlKpFCDyqfM/xmpjPcxquxlpeTVzUaScEbVk2zzxL6GYj3gb8iqLNIwSboZwUZ/rfmnDNyYzWm7u7wUDj5UxWeJg8DZyupSZnvaiqetdfAIrBbAK3JyNkOjHwLSEFNYhTktdTnck5zdtE1twY/JKvF1wk6b41vuDoLqRLe+38l2kbTljVqiPLqAY3O140Ds52eQaPHtl1pfeAP5jY+ZjS9xGF3JjHLTDaHuB8II8rT+TJDd7MqhAyLFnwU3XyUS+xxy8gM55uCPwCJkHWm4xBZHmC4rdGvLBgif5t7G+F10iXJW5GNzwEPNYVH/LrUbmyz1O+lPxWr/T2xEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR3d5iHeN9VZo3UFwYNh+jAx8Ck4bC2VCoz1mP2idEA=;
 b=Jmt1WqK/UQ0sQDm/BrX22zGBqQ05gzQCgAvkN1d1ves0zbT7HOZU//1FN7y/812MpFwUGAlyKWMQ1YXU2a/yEuq0VIZQr90nQzI0VaH7hXM88Gzs9xXDNEqSEHizhXJrAUdkJI5qpxEv8t4d5qEVvfEKnrWhtUb7E4605Rhexnqdtbva7LriqRKePnX3f9C6knbJyvh0Hau4bt93dkKfgVe8ldLIgcNGRWUWu/sFeU3iRoJrKZq7Xw4Ozt4fWylVtH5NStg2u3Y/0S+WUDk0MUCOJNkCxoXEQqEHzQaSLexoKa7cjW6dz64tp3yJcVP1NIbAmJMloZDP8BlwtHCu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR3d5iHeN9VZo3UFwYNh+jAx8Ck4bC2VCoz1mP2idEA=;
 b=OxVV3sbcNeB3Y8qZk8era8/9pqGgPkYc38GLmg18eSvRq8Ip8bvzNXh9yOQnZCUZKkz59XifqL1gpeCMGlniP8gtVL0AIjwP8Hyy4wls6JlkvPXNpk0LDkhnfn3g3MQ1Sp78Tw102uNogLzsyWIO5MTd3mz9mOBZs8e9o15bl1EgfJ6kf0ZXaNIYKUhNG7rD4EkIvPE50hRl2Jp/4eJGUdW81svSWZWG2MVdRUP83pOXL0QiCAseR1+wDh1C1/Bbj/m2P+4oadFwNCksrMOvfCPxTSWqnXwtiWvPIvD8agl0svL+YJrEda6M0dmR9ULziclUHRDrsUddHcyUoPHkDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:07 +0000
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
Subject: [PATCH 12/19] iommu/pages: Remove iommu_put_pages_list_old and the _Generic
Date: Tue,  4 Feb 2025 14:34:53 -0400
Message-ID: <12-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0028.namprd15.prod.outlook.com
 (2603:10b6:207:17::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 842c37eb-4c49-4f4d-a8ea-08dd454aa3a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wXO0JFa+FL/jSzEVnBxMHNtPYnOEu4LYbV0Oq1slsig6kbr4fCjW/HT0r/9s?=
 =?us-ascii?Q?yfLY7dKOSp73OzW0/dwk2P6QFv/uK6CtcelJR91SVmJAbc2O6ZIyok/J0B6R?=
 =?us-ascii?Q?U7mUqaFBHyzjw7Hvl0WYHKwK+ZWF/TunakdNgaTqj0NfCDr3wNgs5ghQLr0N?=
 =?us-ascii?Q?5pXtIwThvBXvAP21z0E1Fl2nu3YGOgCv6dpMOAFHwPUMxH7/3lSsCFa5vZLo?=
 =?us-ascii?Q?Li3clW1fx5GivOwPOUu2b6sxQ6Pl6Kql9lPXVkpTrWJ+lBmujVP8p+3546Jm?=
 =?us-ascii?Q?iqg+bdG4dcf1XYlHr+2+B9SdcLRSPmrFUsjK8RqqzYieEFZC+oNzUVZYGv2R?=
 =?us-ascii?Q?1P1+9zIUb8jjmYtW+8zW5Y5niEejMLVNehXNAOoWv+Xwj03X5tW7gT/Zakky?=
 =?us-ascii?Q?diUn9+v290kQrOL/mVt+7uGLjQlf8wIurMwe4EA9ZjlWY8WCCqwU/mGO1jdv?=
 =?us-ascii?Q?dA7YJQoW0XuwzASUnaDhlBrJ+STyFkWTFUqePylpbLHFEj2PSxfZRlDGPiYr?=
 =?us-ascii?Q?mUf2P34/Zkp4344Zp0cEpnZwkWIlXCzJEDQK1xKrDR7y8KAbNlDGRLtQaUcj?=
 =?us-ascii?Q?i9sqdMkPqbgW4qmyV0yZQylhbtJJzoX/36ZgdN7GPc6Yqvd05XsidmnRQxR/?=
 =?us-ascii?Q?784fvaNW0UpD/RZc+85YRKUnEDHyui9S7tBwMKFUIv2h2itj5p/07WXqmVA/?=
 =?us-ascii?Q?TFSYn873jogxomklZxhZVKhmIQcS2NLFmMvuXW/oHt9yTDcFx1QVbMOU7YfJ?=
 =?us-ascii?Q?8T0oc/NBmZ8M0HPtSmD0YF+kxbZ71meNRV368oq16RA1GkawOkEmVPwejOeR?=
 =?us-ascii?Q?V6PtD6HbX3vk9zyKOUYmBeIq+qo3nhcHI4qGLfJ2AAsns5hDXlleBbQVv82I?=
 =?us-ascii?Q?YKdAV/E+CzSk6MmGyzM97l5/CBwc0a8sU6P6AnGDXEghU399tKxRM1lfLNZi?=
 =?us-ascii?Q?+AI61XUVk2iYbWfMtrJFN8ZhYMa+iC4donrlIpluxw9XMquKgh1rjI/eZ7zQ?=
 =?us-ascii?Q?Dk4JRqKXWwCmPxpOsYChLY2yObTbJzXcufaN5hl4YlO476HpZQxcG6PpKQf6?=
 =?us-ascii?Q?TAQduqLsLBXpe2O5GaftoFeD5LlpsUGIF0VSH5xx6Fv0ujUbD57TEjjd7Rz2?=
 =?us-ascii?Q?LUmhL4w0bV9p6KJDkkrv1xXNLNmWEgPuKDtqLiyJR3UQbZGvnA2hQm5nReM6?=
 =?us-ascii?Q?DLGUg4E3YTwp1s9BXx8JWHoRjyd3RwZenWfHFqS75j+irJYN0tBKjmDntZkt?=
 =?us-ascii?Q?6ZhJ9PkXs4dSQoIibbSuToRk60cDN2kwSq9CajJWBixhb/v1jYJTlbYeLIN4?=
 =?us-ascii?Q?wq837dNV0D87Eqr5yrMfqXxcNOTPNoLFtGO1hTYMX0OnnHOZJN8qNuNPTT3M?=
 =?us-ascii?Q?p1LCZexxhqrSBczYlCITajsf9+j8PmG+EGctqzxAqgLm56yVa6OODSRg91gN?=
 =?us-ascii?Q?cPpQQvvStFU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VfliLPdh/H0nNwaZfoq4dD9SD6jmzqSZe9/BJ2SdK3J2/nAW4NehLMvreo1d?=
 =?us-ascii?Q?HU5NIdpwv3YOnkIVWmfskeHVbNRPE2pfmjR3NEhclqdvaZf4kiOvEGBAlGWf?=
 =?us-ascii?Q?V/wXl5wcBLXK09AqOMsX0WCW7Jj96m3z9aOWTemncrp0j4ZBKYiORxFOr5bm?=
 =?us-ascii?Q?X2KJbYKWY68N4Sm9Cb9g8jQv4WMwGPc4VzjngDXBqf52Qk4nWnK3Tl38nImZ?=
 =?us-ascii?Q?f3mgY1sA9FoH8bU+Gx569icIqja4LIqaInm5tEGl51djyMyiiDYMidQ7k2jM?=
 =?us-ascii?Q?4hlPliHWpEgeZKbW1sVgaWeqtf63M32y7bSSAlhx6GALQUDqL05H8zZy/2TR?=
 =?us-ascii?Q?VfSOMcujNuq17PczSV0rNc0VG0U+ersypd5el/tgapsCDgF6+4+hNVlNR9Bo?=
 =?us-ascii?Q?quPjOzoGs5f8vW78f2MqzmBiJVxQA5D+C0Wqwk/ZAlUT5grTTfelSwrOa1JI?=
 =?us-ascii?Q?LEvdltKbaW+M1oWwgLvrKBWrZxKIs1osm7X6YxGlHhrQrO1qNCnS1fOiXHNd?=
 =?us-ascii?Q?wu4kQpFfnE0crceES6qoXJ06941S6tvTuTPtASTV3KqhUhVFNMRrQM6BaSxD?=
 =?us-ascii?Q?u0Hk/oO2QXRuIfe6X7xxHt6QR5KGSLBexelFHGdI4PXd0cEZgo3VbkszIGda?=
 =?us-ascii?Q?7pfVKbtGXRTQLOdR7QpFfEj5a97/XaxmtoauyTsZh4gYXg8M2Hjww8MNcpBB?=
 =?us-ascii?Q?HjjUqPt/rB1dXGhOVxvGJTZZXuTAodDt86C/YcU4vGpW1goZDxU7UWOrcix/?=
 =?us-ascii?Q?BTFK0snm0WES+JnLaIShqH6/Wtzf80tb5OddSWyvAlEuImwT97FK4CfY2CL/?=
 =?us-ascii?Q?A/ZlN0Yg/YQoclK1rvNpiznvdJOKIj+cTf5/4VKl8MZyNwq2/hlHuNZakcqc?=
 =?us-ascii?Q?V67WyOpDnAd2vDATYMo9+Cc0F7ITF5mHJo8EeNW7Gc4RZOUfeb7AIvVJehj9?=
 =?us-ascii?Q?yttJ7dUb7qh/zzFeRRGCun0XsDCBVos+DVb88j1k++ly7peZoO7rpCw62TsV?=
 =?us-ascii?Q?SQ16N1w2Voq54caDmueTvfulEp7rQWy/FO1q8uma9MVtL07fk0ZDFXk7K3az?=
 =?us-ascii?Q?58rc9yxCV7NDVykDw3ZZUautjpEfTPVwV4ftdAnb7iccpn25azE2NgHU0bky?=
 =?us-ascii?Q?LiJ+rRl7LRgOeoe71BWQe5b6Qb+P5j9JmFptmjVk71e3LaXC+Zd6/CTWjls1?=
 =?us-ascii?Q?4q0q1dwiM2Xa921feXI/nyOYqDnedG4O/EJF0/vPaVV/TdSxrECycOAzBHrW?=
 =?us-ascii?Q?DT+0zh52XRC1gkFn/JfVPLDlVmirnGPLuXSFN780/bG4IvuKu6ZyecfDtk6K?=
 =?us-ascii?Q?E9aq/Y5J39vGvg+5oHzFG+Mnu0HkdTQTHvFtndjdGKF9MWN15O3xIm2qcCGC?=
 =?us-ascii?Q?pFJ3cKkyuohd+gYPE0fpVd3VdUAhcSolPCWhhsmfZrjZoDd22vjugEGcIiem?=
 =?us-ascii?Q?2nOV/Xzo3P+N9/Nf4XbKJTJD16/VNRKLZ+kwxpshAOChc6WGkSxHyCTGK/kl?=
 =?us-ascii?Q?xBt/JNJ2rKuYcJuT/cIizOMQRFGXYKcvRlkIJfoXGxpTLjnObnMwOzNMHdy1?=
 =?us-ascii?Q?zsYA2R7vGToeM3ilKXo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842c37eb-4c49-4f4d-a8ea-08dd454aa3a1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:03.4090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C911WbLpNVXZlhbIeREpp3fHkCTiMCgsGCQzdVT7WClkvwSlr+EPY6Nz4lRXT4Wi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Nothing uses the old list_head path now, remove it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 15 +++------------
 drivers/iommu/iommu-pages.h |  8 +-------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 92a6966ad4c032..af86c487ba100b 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -67,25 +67,16 @@ void iommu_free_page(void *virt)
 EXPORT_SYMBOL_GPL(iommu_free_page);
 
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
index 0950f7c0cae9eb..d35d9f99f320dc 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -11,13 +11,7 @@
 
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_page(void *virt);
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

