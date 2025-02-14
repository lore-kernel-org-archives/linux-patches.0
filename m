Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5E22686A6;
	Fri, 14 Feb 2025 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552902; cv=fail; b=laqz19e/WH4rjKVZUkLOQ6CcubY1c+h6QrgBrjDhAxWLrNwh+spyGtTLCCBWW30XgjxVTWlbCtIsmGa+fVHbxEXyEy7KnxbPTm8oSxt4xediLACUjhmxubhwADU7TcAfgEGaqma2JL39EKHGkRZqo3OMXy6XNoWgZvrxZ3DK3u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552902; c=relaxed/simple;
	bh=WFXibRwukAOESLoQRUcMYZST7HA2iLInEXXiRAOnhME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YxEYn1Ql402VlqQumyJDuOcDbh7WGJ8EFFxLhu5VRIHUofm/UDxwhP2rvTAybKeZ6lkzXGVsb5VsRliF5+J4wcnPADadGVEhBaSqlOLZ0IFXsZudxXzp179VslwnbQGeKOVvGkryR9p2f0W6H0DxxRXuhBC0uI1Vol2gt+8iTcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TywOvOYo; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TywOvOYo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tD2DaKnAq7CAgWpgCwaPaOy+m3HR7slhc6tOU2bzr2VIu3dbiFSh3hJtSNaLCKHdxEygy68TFYe22aoD8a1bQjHnYHWnhO0hjDAT7M7UlIIOv03ZXBGgEfj2C/NFkD+sjmkJlTV5HB6ikF28WzDK0STBtzJr3uH9ngOlYS65RHihXpLDOAAq5Ll0dbEKilzPFkdFkuVr/N9CGrENj8XJ3U+9bdZKd+zGwzBRJaBiC/Ek6eqnuvV1Q2iWsnaInQRFHf0Ta9vUyoXQC3R8jRFNQvm/JXY4nxbizUh8Z2fbxj6HDW4FoVvL4M0QVThy1+V24e1sDmPGWprEEQfb254qBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64rPo0typhWn9EiuPyy3CdGiIksUJQiXRmT4BBfuuqs=;
 b=Sr1E76LJYFSnHhGn1cczx0oe66v5x6x7vlZu4wU76ZNVI+v7AnJ8rpnJLdT7giohltbWBgSM//j68L8cFpi7kUafYstwyziIzlHaX57alRYOCNw2m6eIUGXUgSclHCgCB8vOrJUEdOM4aMaBrxCktsfjznkRT0pBTT7CT9L7RTQckNk7JYlYZlDWUYbCHnK258dKh9csSvOkosBM6KQCTOoB6qMl8j8GePrU0Hrb2ZEqw31i5MF51MtEXhxvGJ0xtDkiWfLqanGYFdM8W2mAGAL91KJ8/rkFkZLCC2QS34QqayJ6IWM8x/AHYz83nWPku9OAr4S+kAcCCcDu/XNTew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64rPo0typhWn9EiuPyy3CdGiIksUJQiXRmT4BBfuuqs=;
 b=TywOvOYo2Meqx52g4UUGQtOpYncU+03hjoGBWpqsXQJjx4hzMZV25c6nmDGbSO9/E5dB8nDCBylH2aumunHwXKMVm8qbtlqury43um9+B/fCrfro8NzKnaTYJsmxP84i2y0I9dVIIMXgiv4cYCpUL7EM99YW9IfVKt0L/DO5virZiJY23NdxVC1pecg4EHiOcqyrUByRL41p37kTdhDJbZnrs92AVq0/GFagvuNZZy/e2RMq0NqM/55g4a92ryzA4JZZ+LfD+ucbhfRd92oeYzrQxLOdW94NEq4qsSd/1QcWoxjqQ/7PdY1mJMh+w+9UVU5fOmr9/EWVC+8kB093SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:07 +0000
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
Subject: [PATCH v2 07/23] iommu/pages: De-inline the substantial functions
Date: Fri, 14 Feb 2025 13:07:40 -0400
Message-ID: <7-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0043.namprd02.prod.outlook.com
 (2603:10b6:207:3d::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ec3555-f750-4023-fa78-08dd4d1a224e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xg4xiXQxEwGa3HHNKGWuoE/pEA9D9WeHwrCnSERfcVFymZTIYPicK3dcoRNP?=
 =?us-ascii?Q?MFbqbtC75uJPaQn2Nt8/XHSgRoEcCGJmag+JUXafeo8j9FMwwgPMebg/Bmp0?=
 =?us-ascii?Q?9Jh6lzEkY9wLI9ilKhJIHDjXk+C+LgL3PBn/gjorHv+kN+paJqkOv7RxqkS8?=
 =?us-ascii?Q?Rd64J+Gp/xtTXScqlIXPpUs/S2Ljii9srArswGP9qQhjgGyEQJJEeSIorbMv?=
 =?us-ascii?Q?Aie/pSpDOepVB0EpVqRfhtBpSE81Qm/raLgDix2m9BDFdXLmJFas/idKHpm7?=
 =?us-ascii?Q?Q3bpA6WczKASjfQk8eBkrOmLN8MoOOtiRBQaq7heThjapQitVaBrAYv7HoEh?=
 =?us-ascii?Q?OicxqIUHj5KYmcScw9yYuaW82cDt4K3D1dKH5OMPxxl8CAoe5PScvs7z+nvQ?=
 =?us-ascii?Q?T6Rb0dM4YOr+n4PeWAs/5le9pZbXAPQSB3yabu7vmDe9VZnn41nJ1TJGU5WY?=
 =?us-ascii?Q?s5yVZSmjmZqjyPfsu/XaIskALBNdEZcahnq2VA7Vj5EKfHW2xkBB4MtjV+Cj?=
 =?us-ascii?Q?HztMV7GwkviFWLgCGe4Kw2zlZH+dCWxeIWWcOL0tHury/W7QZlkMKfGT1eXE?=
 =?us-ascii?Q?AncUkxC754TbuNBDHyU9cWvnluJ62VRglnlsSmZ2AhJooy1kWMYOLPVV0fcZ?=
 =?us-ascii?Q?YmLHYXycdJ+xfn/471aKUMuuKXb2eM4cZMrngGGm1fjJ2mnZS2lMNBqiQ0/S?=
 =?us-ascii?Q?z//9USAQLlrlmyfRdwidThJXPUN1XAXf8rspY7ZhOKExouWX7QTsOLzVju9e?=
 =?us-ascii?Q?UI/dm/xlu+qZfXKb6k9P2oH1u+fIh5vLAXbqpeDEHf7TC+ayBoDzEMKEMR14?=
 =?us-ascii?Q?MZ5iJi1MGMxz3fuMfSJiPgUe+Y4UrS/EBWJEhZ+Gj9QCjEOV5YhXeIeBSlGO?=
 =?us-ascii?Q?vmt33VXUc7q7L99Old7kKloOAmgQZgEPMEqGWDrv7aEIzjVwuHQ/i+TM1A41?=
 =?us-ascii?Q?kus8iGsazvUW+DdejCqukNFc2rUdBwaGt6f2t55omMcB0QQdorpNkviGBuEt?=
 =?us-ascii?Q?V7yCh1w5L1Yx8DSWI7Sk5EiVQYfeqtz1p4lpIA8I5MjHLY2QOYKyzKsf+W/V?=
 =?us-ascii?Q?0qy9OjQvDRKuQlWvwx92nIl/SjGs2JkVn9bNKIEjAEWx3HOyb/J3e6I1aQKX?=
 =?us-ascii?Q?3Y07RfvGmrmTnqItrpzdNwiwS8+7C/PgbyxZXBhU+i/K9ryoRHyddp58H3nP?=
 =?us-ascii?Q?oqYExKF8mh3D+g9dE3mmKo22+xlmPj4oDrpqLW3r7lGnpXOe3HEDzhZ50Lqi?=
 =?us-ascii?Q?vFqaUiXwysEY4kHeVQmve4pCJ3sCRy28k95+7K6/369/6SFsO5yhZSO6/kJ1?=
 =?us-ascii?Q?nU96FPWq4QN9JBeuICgDCyykShJ4UKwoHgzJGHCFiHTkULV9QGSa4gPOweH4?=
 =?us-ascii?Q?8rWe9TWdwLKA44ATQhZoJhj93OHbuhQe1yF7F2ObU5dotE/IHsRn24rjbW9a?=
 =?us-ascii?Q?02Pb2V1qZFU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FiTJrMUg6ouAnII6HK2NfNi6YoK//SNB34dpc9xtEIt1vchJvn7se7q6wS+/?=
 =?us-ascii?Q?U9+qV7T3e/jZZ2rl6qPxr009XuxFFvV54QQjdZSziAX1VcbhKjuHXGsaXLEK?=
 =?us-ascii?Q?0DiZ/JEF9ZLXYTBo9W8lHEee57oF3mpLeQP1JiVdNogIJ+iVX7BfDm3rLgjq?=
 =?us-ascii?Q?bAVy7jo8i6JICkXY54waQuNPy5YzBuZWcawrY67SZtuY9sH6Uh6CG6oJHhEv?=
 =?us-ascii?Q?MAiEsqvI2A2Lye99J90kjQpLEQP9tegTQfkPHmqNflBoSoZQtBHHlxWHd9jt?=
 =?us-ascii?Q?LOL6Cji0cwsRMnf3d3PL4rJR8GxnPcNTNfMl7B+h9LUM0sXifkF720bcmEvC?=
 =?us-ascii?Q?x9RAu6onPtsup0urjucLUhjWTySyRxtB/1N+HN7Y2gTAZSRnK+FyhATrJ5ZK?=
 =?us-ascii?Q?HU5jl8RjSQmEcN6YDOzEb/6iWsEH7dC6PTkUd/fw8/1oMul4eYrlfzP7QTiC?=
 =?us-ascii?Q?v4WfkLhnIRS5vv7y6JybvdBUkljxSDdJ0Z+VvyeGJJGTld6zVPc2N2mDkkaN?=
 =?us-ascii?Q?lCI5tZSCipJ26eOG398Dno+ZRaVMLp/RM3tvo275Ed+DwVChJgfb2wGPrdss?=
 =?us-ascii?Q?xXEWXNtaNYgvQtpj9gPKlPCshEadMukazCaEWEC/e9sw+7A/t5yfXXdv4I8n?=
 =?us-ascii?Q?o0V3vTFYrbOJtcAfNMi1i/ZrxJJpZYKwdN2c0/WMZgPlTHlq/Y0n8DqFDbUS?=
 =?us-ascii?Q?rfmsl1xaJOxHug8TSsrmoLQsPxC9GoOf5H1in7Ja7XJbPE1b2OXxw+nIruYL?=
 =?us-ascii?Q?s5eKQTtJiWzKW2X2684H7N9hPzu4w5iXBS4KFaCt4cCIkzoq9xPgY/5oQO93?=
 =?us-ascii?Q?GvfCw/zNoR1yQ2t6fuLi5HMNOfwjbHkb4Y8dhEuYOsD2dXXFrlY2BVPmmZwR?=
 =?us-ascii?Q?DrFtiAb4WRcwPtwt5eFql8uPnlEDAQ55fOGpeeeBJGIvQD3Mu4m16EFXn3Bw?=
 =?us-ascii?Q?4QfQuuSG/6qPIarWDudI+WSF2fSQMmaOd95biUD3S9kB1tDmad/4m+rAr0KL?=
 =?us-ascii?Q?nme5PZI6M00+wWCtPNTT7OXW/f9WeyuNRMIub5xQslo214Eod5nN/uS2Qb3b?=
 =?us-ascii?Q?fvadCArCQINONPSHLFLL7nbBQ2mWB45FUEFmnKUKcXn6rR6w+CDoyCdqdb3L?=
 =?us-ascii?Q?NISCOYHzgd/Lyjuf7IzimjHw7SbmjNX9z6S14RxQr/+imhtu/VKz2PUAl4HP?=
 =?us-ascii?Q?dHsj7KzTDBbf8j5f0WNW2OBNTfkq0xcKz6XuDOIjHN1DVgPvLstPkhdLnwLI?=
 =?us-ascii?Q?PTSIFgjmOz4+HaA+mDZ13EG5xE2wisxxtTLYN0verJUWxJdzUj68NCilKA3G?=
 =?us-ascii?Q?VIQBqRNOTuuUhw1AQoLnL+0KVqIJp9AaKu2vg+AIGUY0sQBTiHBPMKrY80Uy?=
 =?us-ascii?Q?B4Wk7nYobwbZZU57naTZEvj7L4Am03kU+vLwjI44vpYlPtLPELvBhjiggP1h?=
 =?us-ascii?Q?9sJmzVl7hE5voSfoNIG87LBYKaeC1lKqNHU2WbwQYRGpN3F/1jmcf4xdVwKK?=
 =?us-ascii?Q?gKJe3axJwd82d3aEYWuRXud0HM70A83zqotXGhoSon9iE6bBEMzSzK9/82Yo?=
 =?us-ascii?Q?wbQ+Q5ZghPmczH1dTnM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ec3555-f750-4023-fa78-08dd4d1a224e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.8871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XuziWKnua4+EhAuKTkUsS1TpltADr7BHwdBw/7whRtB+xurVQKUC+y8OIh4tABtG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

These are called in a lot of places and are not trivial. Move them to the
core module.

Tidy some of the comments and function arguments, fold
__iommu_alloc_account() into its only caller, change
__iommu_free_account() into __iommu_free_page() to remove some
duplication.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Makefile      |   1 +
 drivers/iommu/iommu-pages.c |  84 +++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h | 103 ++----------------------------------
 3 files changed, 90 insertions(+), 98 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 5e5a83c6c2aae2..fe91d770abe16c 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += amd/ intel/ arm/ iommufd/ riscv/
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_IOMMU_SUPPORT) += iommu-pages.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
new file mode 100644
index 00000000000000..dbf7205bb23dcc
--- /dev/null
+++ b/drivers/iommu/iommu-pages.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include "iommu-pages.h"
+#include <linux/gfp.h>
+#include <linux/mm.h>
+
+/**
+ * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @order: page order
+ *
+ * Returns the virtual address of the allocated page. The page must be
+ * freed either by calling iommu_free_page() or via iommu_put_pages_list().
+ */
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
+{
+	const unsigned long pgcnt = 1UL << order;
+	struct page *page;
+
+	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
+	if (unlikely(!page))
+		return NULL;
+
+	/*
+	 * All page allocations that should be reported to as "iommu-pagetables"
+	 * to userspace must use one of the functions below. This includes
+	 * allocations of page-tables and other per-iommu_domain configuration
+	 * structures.
+	 *
+	 * This is necessary for the proper accounting as IOMMU state can be
+	 * rather large, i.e. multiple gigabytes in size.
+	 */
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
+
+	return page_address(page);
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
+
+static void __iommu_free_page(struct page *page)
+{
+	unsigned int order = folio_order(page_folio(page));
+	const unsigned long pgcnt = 1UL << order;
+
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
+	put_page(page);
+}
+
+/**
+ * iommu_free_pages - free pages
+ * @virt: virtual address of the page to be freed.
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
+ */
+void iommu_free_pages(void *virt)
+{
+	if (!virt)
+		return;
+	__iommu_free_page(virt_to_page(virt));
+}
+EXPORT_SYMBOL_GPL(iommu_free_pages);
+
+/**
+ * iommu_put_pages_list - free a list of pages.
+ * @head: the head of the lru list to be freed.
+ *
+ * Frees a list of pages allocated by iommu_alloc_pages_node().
+ */
+void iommu_put_pages_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct page *p = list_entry(head->prev, struct page, lru);
+
+		list_del(&p->lru);
+		__iommu_free_page(p);
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index fcd17b94f7b830..e3c35aa14ad716 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,67 +7,12 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/vmstat.h>
-#include <linux/gfp.h>
-#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/topology.h>
 
-/*
- * All page allocations that should be reported to as "iommu-pagetables" to
- * userspace must use one of the functions below.  This includes allocations of
- * page-tables and other per-iommu_domain configuration structures.
- *
- * This is necessary for the proper accounting as IOMMU state can be rather
- * large, i.e. multiple gigabytes in size.
- */
-
-/**
- * __iommu_alloc_account - account for newly allocated page.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_alloc_account(struct page *page, int order)
-{
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
-}
-
-/**
- * __iommu_free_account - account a page that is about to be freed.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_free_account(struct page *page)
-{
-	unsigned int order = folio_order(page_folio(page));
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
-}
-
-/**
- * iommu_alloc_pages_node - allocate a zeroed page of a given order from
- * specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the virtual address of the allocated page
- */
-static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
-{
-	struct page *page =
-		alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
-
-	if (unlikely(!page))
-		return NULL;
-
-	__iommu_alloc_account(page, order);
-
-	return page_address(page);
-}
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
+void iommu_free_pages(void *virt);
+void iommu_put_pages_list(struct list_head *head);
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
@@ -104,42 +49,4 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
-/**
- * iommu_free_pages - free pages
- * @virt: virtual address of the page to be freed.
- *
- * The page must have have been allocated by iommu_alloc_pages_node()
- */
-static inline void iommu_free_pages(void *virt)
-{
-	struct page *page;
-
-	if (!virt)
-		return;
-
-	page = virt_to_page(virt);
-	__iommu_free_account(page);
-	put_page(page);
-}
-
-/**
- * iommu_put_pages_list - free a list of pages.
- * @page: the head of the lru list to be freed.
- *
- * There are no locking requirement for these pages, as they are going to be
- * put on a free list as soon as refcount reaches 0. Pages are put on this LRU
- * list once they are removed from the IOMMU page tables. However, they can
- * still be access through debugfs.
- */
-static inline void iommu_put_pages_list(struct list_head *page)
-{
-	while (!list_empty(page)) {
-		struct page *p = list_entry(page->prev, struct page, lru);
-
-		list_del(&p->lru);
-		__iommu_free_account(p);
-		put_page(p);
-	}
-}
-
 #endif	/* __IOMMU_PAGES_H */
-- 
2.43.0

