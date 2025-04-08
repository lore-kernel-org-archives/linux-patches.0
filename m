Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC523814E;
	Tue,  8 Apr 2025 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131269; cv=fail; b=A/3fI3VNPVM5sSXguR11NXuHbNF/rE2qAwK50jWEOTWc3gMsWnNPAeFSuYrkC4zk1pObysT10q9MSisDkjJlO1yjdyh1Wa7kvb5vYWyApcDtMsJeAWZMdHworemEO6ggUCjJgQmThKZqhahGhlpoIklBVbPJFi/MUFifQsd8KNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131269; c=relaxed/simple;
	bh=vGZNS+ynBDpsBdyHfjLX4OmQFQQ0iT1gC/48E0OGTf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hN9H2apwXsoWW1JH4KaRXC8tFjJuXp4mGsxIBp0blYrh73OwIvyM+nq3QxSKagdIOfX03hQdMjBQ9ojDf8OpVizxWaRLgV8Rem+yTBbh42EX4FpX6zentEslgxcSTuzYxwigrMT7cwL2QEmx3ikORK0oxevlwcgc7jqecHTM63M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oOxCsiYx; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oOxCsiYx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkZkKkLl53iKPT4BGz1yleXqWBtyDHsiGhIGfBgvwnKY6w9XbblbTNRJrv3GBkCUH8sGFsxpaRkUJTyngjIQZKd/QCjZOfZKsjROXtC+C8ckLEgb5RxGv8bNb9nUY7y/FIJHUR8lqsJKl3TDn6jbZj1/eg2ykMIqkXZ0u4va/7kazpZZMYzq1ajE9uXaT/I/Q5Ionf+y6KbTW0FGYk67A/eXN0WOLSCXMbeLyDFq/KetsDYeMED3WQN0lLGWhSBfg8IZO3ZuALsSEHWPuBLUL1a4qlFLqewnWQdSpPhJiUq7aHDgwfs+s8zciVmAYiNcCM8KiID05nt+vqx2pgp9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNg4ZD94IDIitY8vj+IFABlEolj+AplmGFJxU40zyyI=;
 b=oBtPpvteMU/359RUzwtDzT0N9cSv0DBKsR4Xd9HKw5ezHDIf3ADV58dD1b6YzytSrzGCVMKmxR/Idq6UJMgi9TUMhSBGthu6wY+4cWcXFYv+xhcTBTS+lUoo93e0y7ohhYOFXwpQqNTst/+Wx+N+f1qxebB+CCWEd65mWR8jpf533TLUEGfMQEcD2ZJ+WCHjxriKy0Ae1X6GBgFzuWXlHQ+p+zTSZRaCYMsexL92BOvDrVmZvpOMnDPU7DRaObPsCVr0upgw8HhdVUQu52tRwhQGa1VLGeyMxro/CIKGYLRE4MP6HkhUyjGYZAMadAutqC+sEiD0cNxCHfmiF1Mppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNg4ZD94IDIitY8vj+IFABlEolj+AplmGFJxU40zyyI=;
 b=oOxCsiYxxlXaYtXJ5D12E9c+d7ogD+pDbwMSUGqyqsPHgfZxCy+w3XrZT4GcBRUAcP4adGiXeICN3pBV8fMeAmp/8W1gCH03pO1EtJYKpO28rkLaui6ycXw/7YJqdu3Q7r2+fCkaFhD8gFYsHngkr1wn10qe/yO2cNPFjrfvE489h2a7STQ03VgR/67qCsvp1NoOMRo4QX2WnqJM5D3gATPcVlphmCz6hSfrZdpnTlJcS3pa2gL5BISfn0LbVe9nyfROQQhK2OzgoHvaGOh7qTMHTkqauuZSstnDu/VQ91OunxwKvQfnhXrYUlEzhKgSldhRodsM1E6B9//rv0sHMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:19 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:19 +0000
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
Subject: [PATCH v4 04/23] iommu/pages: Make iommu_put_pages_list() work with high order allocations
Date: Tue,  8 Apr 2025 13:53:52 -0300
Message-ID: <4-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:408:60::45) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b9b012b-0bb4-4b2f-2859-08dd76bdfe70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2HxTvJmuy7/6Hw1SomN0C3dUc2945goVY4aBoJ2lArlOusxyzUCdlwBTWh8h?=
 =?us-ascii?Q?nDiBMGT2rxjml7ls8XC1BnltTdIQADDmJBqYjZNlDyRXP+RbkbgZGLwLPE4Y?=
 =?us-ascii?Q?b3iHbIWkftp6CuL4rospeyxv7jM9eb+48+F1WHEDlcthaifve5JK6Lz99wm0?=
 =?us-ascii?Q?bEaEqJj25Eid7d4A2QGxnf3vAy022Ag+AvgIby/XPWHJ0Dqu+b9+yF9HJtKt?=
 =?us-ascii?Q?NZ958GXmD/fwXRdPnhus0Z4EO0YmoSytJctR6CdPfs/oJ7XYlFQjXEKuvJtj?=
 =?us-ascii?Q?jW3NnbXB/FcZB+rpvToyKD5lIeI2qABl59YszMvIeu4qYWxoHT3df+Cgwzpf?=
 =?us-ascii?Q?tHwOWXd7vqVXlw9D6t8LwHBEVN0fDvJukjAurxB3hcqMiqitu91ja4Wx4vwl?=
 =?us-ascii?Q?/HJuyODXMvTpC4ghIZ/BVDWOTOIwWGOcVIi+s+AaDt7334B788ZOYnyFgy19?=
 =?us-ascii?Q?ErdpKFMMC7VbB82YeDkaVWS85jzwxp01g2T/etd+qL4Zl0YpcMYlQ35kipMM?=
 =?us-ascii?Q?n6fedNnQyCX72brRe7EYiM8Heyr86vH/Cyz0YoxiKIY6EiZ3ZkKwzWnf4yQh?=
 =?us-ascii?Q?0AhKE8F+4IDmQS8fN/CdDWISFQt/6+riNBo2pnpYhFC+4IFupER3dG9l9d92?=
 =?us-ascii?Q?dXV5aEjjwEbQGDoL4oBnfIBl8AuucmEHLdyZwh0LUI4ZAJR8TaKXFzE2wX9O?=
 =?us-ascii?Q?vk08ITzSl/cE6hHhT2lCIh7PVQ0+IXyKb7H1HxltsJlffbjefXd9lMFVUBdW?=
 =?us-ascii?Q?IM+W9acilH9Melaje6C5FyABbuUvMP4R2AioOGg2h3Pl6pcxVXlwtUW0yrDu?=
 =?us-ascii?Q?dBdkNo1v25XxI+UnmETPEUk6zRUPUS8NByWbOKxfhS5z9idgfbld2nNGMU0Q?=
 =?us-ascii?Q?U5opklez536PxROevyvz4CkAneFjsIq/M6OovSka8sOIRMTGmWUlK4vv2PZ5?=
 =?us-ascii?Q?sRU6SkVSO3UPEq1Gs2E0U00t0M0X6Ool5C135vY9TAOV/jLPu31AGvFJU1aR?=
 =?us-ascii?Q?/Qxc5NMfnOFNIWnAbLlVbaqnl+LMo2KmO2aXhaPSIoJvyJgmgUTYb5cpSf5D?=
 =?us-ascii?Q?NN83UGo2ES6a5R2aWyjXG695Vu2V6Cod88IEoT9c5xpjdZqu/XgMs0Pag4M1?=
 =?us-ascii?Q?bzl217GOebG6OhLixcN08Mdj+mxzMEvTVmYh4fMzriZE5QFc3i30eAjlygUh?=
 =?us-ascii?Q?zRKeQwiyzKAtQy0NpAKlb7e9iu8zdx4jjis8r+tPSbOMmWz3M9q/Y2M2b7y/?=
 =?us-ascii?Q?5PNKvXMlcX6Pb+eZRDz+thzWEv0u5jGPM2eSwHczfZXcRKxJKoJgjmxjc/oN?=
 =?us-ascii?Q?ims4MhI6YTWMy+hSEFMUoyTE9u6kOfm/AqsY7KNoO8MLR/4Xvd/82hlcGIto?=
 =?us-ascii?Q?0/Xeh9R+nTzEzcFyj0wUcVlp8PA1/KRlpyzSKKbpcb05Q6LwFKy9v9T7RrPp?=
 =?us-ascii?Q?GJDuXFzu4/oBvCSDczIVDSqDWKsFdLMoq/lRiDeTdU6QxipNXKQNSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cxGmjKo0oPxu4yh6IZTDg0X4VYQSbcw3IShFghUicche71QK813ZU1jkJ0TB?=
 =?us-ascii?Q?TvVTg9OsEFevHnFgxOmRrfCXme0vR/qp5ZGTZrJMVZfvUdqtPFlp3weBcezI?=
 =?us-ascii?Q?OTpc1J91NB4CnAms1WgZqgs7h9ng0wlKW0ms0cAxjHCZF8QB+CZPlMcGaKTh?=
 =?us-ascii?Q?Ay/f03WjsON44MP6KtQIibb0jQ6ZggoDlB2VALhz1fb+aVOGMrkKeFXOUL6b?=
 =?us-ascii?Q?gY/Al47Yvmr/9V4klmLWMB5JN3l94lmFbAphxwF4x7Ho1ff9vMF4rEhzFbHw?=
 =?us-ascii?Q?qnGjdR+ePbTopi+jcgOqdgPuSLjtnYu7AmfHLOiljbud7c/juPSBT4CShKmY?=
 =?us-ascii?Q?hVq7Q0xYtSZxyIqvng3o44hX6xjQXDirYwAfyruwa8nUBlJ3SH4fSqtLWDJw?=
 =?us-ascii?Q?sTSL8/DLmiF2Ct6NnR6L0jVlzXyeuaDmMjxXjUp8gyBZejx7GPLTCBTm+80N?=
 =?us-ascii?Q?Y7IQ7wKazjOuKLGgnHxjyqeDS++oWsZDt/G/NWKbM925M/dHygODgoO++Okw?=
 =?us-ascii?Q?5OYGVDVn0e9KadCFUX0pAbExErX0LjB05KFzH36htecZMndJqY8CTS3JA9T4?=
 =?us-ascii?Q?5E98CVomxNYSY5n0DIY+GGdGRzFdzP9vsYqMiOU0IzvhZM0wjGy2bHChh/yi?=
 =?us-ascii?Q?3wlL74/A8KgItR6iv8CfniPTO2dFQ4tzpMNouaUyiQU5I7RWY6uIw9HNDRaU?=
 =?us-ascii?Q?EjKgpQNyPBHJm1RQdUmFl+MRx3tbvSCSwEFjLvR2pU8jio6dt3eM3L3UBFHP?=
 =?us-ascii?Q?UiT0zWoyhbHSlb+4UX/y1OC1xAR27z75nw+fQ4XY3v3lKKBmCPAuRoGLh4T1?=
 =?us-ascii?Q?SowzsMKzp5TcptD1jH0/4G+BF8DuotlKb3dNJeKcZ8fVnA5V7IT7rrKaX+2U?=
 =?us-ascii?Q?LkHrZC3bJlLRmYPYs5P8noMn07ptwluz682NDWpXaP1opEFBDiz97jSelx5N?=
 =?us-ascii?Q?V0Rw4T2zbwS2ibZheO/98DIUMygBfpMVdKRemsEc5KgBBDZPuOznOwSsqWm7?=
 =?us-ascii?Q?hCGcii/MXqaGcG0hhxyE930ylfXLhsjLPteZri2EmrLIfbpVbhdkBoNEiDSX?=
 =?us-ascii?Q?z6a+CPNzbDYex0XJlGJYUhEjLW+KHWKbgyGI0UgJsO4W/nnVp5mPHKuZRmd/?=
 =?us-ascii?Q?mIFzfymyq74pG72yk1cgI6/Qm2xfZMOWRfMEPnN7SQHlU4up7ZUC+0hVSRTv?=
 =?us-ascii?Q?oPlVSFWeia9Z41DAh+UfkAtowdXCWrgqiIdGpiNS/Qcw4igFU2cRqT0+xv9Z?=
 =?us-ascii?Q?yxowsTMVFGlKWu01jWwuPL24S6rer66aUqenoD4FJikgCA/7xpPi7m919NZI?=
 =?us-ascii?Q?eHcgT8ILBcJeINvY0Idj4+dEgzLDNURNYGYK62i6qQyPhfF9fcSJZCNoWZ4C?=
 =?us-ascii?Q?7P2aHdM8l6WbGk2VdiL5EhTC6wYRWxERnPOTOqWdilNuX7XA09nzZTFuI+cz?=
 =?us-ascii?Q?9NrUpVHnRIdxWlRVRUCbES4a/1PBR0tvPPqky3jWwwMEUBTwJcewlVKuFPNx?=
 =?us-ascii?Q?cHQQc8pFn0a2Gu+BuoH5iAu9L7KWqYQTBrIRvZRuUV7lznH1d4guXKU9bJ/t?=
 =?us-ascii?Q?93F395yNHa+czYmpsnaRMIDPGLE+Ysh2HhccdmiL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9b012b-0bb4-4b2f-2859-08dd76bdfe70
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:15.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5XeVOHeZ7Fn7hCd5qDQSaurQ3F5IXKMOwGtct1NXoArlLgOjDEJNa0v67ZO6BOG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

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
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
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

