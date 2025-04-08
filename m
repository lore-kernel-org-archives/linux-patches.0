Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253EB23814E;
	Tue,  8 Apr 2025 16:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131266; cv=fail; b=H3MGAZA/qj4ct2Art6QrdrY5C5QZfRMGdzKbg0QomxACIKiWsUqMr6D3xpXOliaDpeHyA7M/KDE5H5XYXoTx8aGBA2+FwmFunAz6mZDIzy5cpWrjzI05IwzqcnhbClPpAVmKYjOcUIyDFRLHw6vEdoHYrvdtvgzxxdKfTMoRu04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131266; c=relaxed/simple;
	bh=y1k1jt2PbqgpOzmOj87gm8x5RZvROdkCeQEd0+akElo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VU3JVZ2ZsuHeAJqD6nkHEXWZS9Pl1kiOt+6HjvrCvR7hXrwMRsQAAYps2OW8DfiNAdIUKkImntUrAOrcOxlxhYR1xQMg6ICfNxO2k7JCFatMVy9Yz/zanGyrUrylYA6Vgjm5DhWfu3th4qo/7xZW0l1LdGS54RzLz2ABrJ9yQdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AEMfWwI5; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AEMfWwI5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SAEBhMjzW5n3+n1aLfC8f4yLResp9ho+cyBH3WHdJgyVvD1/uZVuK/BR0SRxfmAoih860tSKEU3GwZvxvVUvdHqii1LGWNZ/APc7M9C7gfmMX339MWiEt/YAJrKwX8/V7d9fen740I6rBysjOjVxaIsA4o+IkgHJOULNuK97xDS7yIOJjbSOJ8YaNLKxAryxxliGbvkcmQqLd2X+d6rxYpIaGh/HkJyzl2bSHqI2vOom95szdyAe7BrbYVMnUe1j+tckH66RudhxV1zRo7FWYzYLLt90qQGl1R+q8qwx5PkS+nD/zZWV3NMN7NYBABFp7Kt7ASXARBDwC1ttOPvGIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yWR11U09nyhGLEmSthuTAaf3mrkamzIJMdLWHxAsZQ=;
 b=Sldpk1HojGw5d5/rO5III5kq9S8Qzvg1mGNnB2JkzYhzfRxjPTaMUo2OgXykTQpcG283aIaNf54hVkd+5CxJzDDu5zt4GjC7yM/tFBQ8X50o5FwbR1a9NEqvGP5LmYgyaZVgKvgWDcMwSSYCv0WZ5ejnmHACzf/yWaramZp5W95bt7pJBqe+hBe+/MOUGpJp8AxPCc1cYpQjxo+wrQdGDWc4X2nDqDl6iYQ9PaJkT05F4VtYEWj9MYmYdaS08mRgG6JhhyQPEjuWP5bzbLeh/W+RZh96Z1oUWzoBO1/zJaupBVGQfkk5JeiqvzTVS0haZKh0WlNA3VkbSvaKeSRPXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yWR11U09nyhGLEmSthuTAaf3mrkamzIJMdLWHxAsZQ=;
 b=AEMfWwI5BeW/33U6uL3c09zYcgiFco/vrUXyrVr/ZQTz54cZtoBqP4smMxEozs7MJETmfJdEdYBNOHdaDuBhJIgfA26BCXW2U18Q7Ji7q+SUWWqnclFeAntj2kHADRWxuw94ha3hldVZVKrwzZM7wuep2iPvAssHurg18KJZ1o1zcbGDpXzTbhrGqhL44Spdf7SododYallXCKkegh2L1ZjsS4QmpCNnpru9J4CghcW+99I7jAEZreZBzrS0dmyqRv5XXMBccm2+aGk4vtpNKBWJAPFRF3o06IryGvKTTiDZMdVmd4WJJwhrOhjAxf+v5cNdz5HPxcUhKF0Kp00N4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:17 +0000
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
Subject: [PATCH v4 19/23] iommu: Update various drivers to pass in lg2sz instead of order to iommu pages
Date: Tue,  8 Apr 2025 13:54:07 -0300
Message-ID: <19-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:208:237::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ec5830-dad7-4a26-0c87-08dd76bdfdf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TiJRofcbq3KLQQn+qwgp12jT8w0iS9XHuw6saDZJp0rm0F62rSsrl/2JIgFA?=
 =?us-ascii?Q?lzPF1vJ6z29t18b5jQPOst5YGI8Skh/GbhTQMqOHRRWNuU9MB+Pjq1b1Yo55?=
 =?us-ascii?Q?9EASnnEQh83J2AFO7Vn/bp4tIn8K5OTZ39u1ZDAo3qazTpJdVvGIrLWZV3DH?=
 =?us-ascii?Q?AfAbMHIyBNt6P1lADmai5ZWQDLPeYP9VRysyJBwdgaYBtSVDyTZU/Dq4Algu?=
 =?us-ascii?Q?nth4mjsIvSd2jvJd2/c25s5RcUFqxaiKiUljzzEfEn0JHhIdYBW6jq1bS9Ob?=
 =?us-ascii?Q?eQkhyd5MyPowvcP7xXA7W+R0jOA5xVueDIQNewEOXMaWio2Vq3R/ZG7Ag42k?=
 =?us-ascii?Q?rreqzp1XJJTceLUjpkuVLvAb4ZnIiId6bBam8lfmKRLvDUoIvcGw2wJQTVHl?=
 =?us-ascii?Q?4nHMG9sZJII56LMLfJS9SeoxaAEpkqsAC68RykvaT2bAGRmHZSV2i5TOyd0W?=
 =?us-ascii?Q?DBuBFK/KJoLQEzYOKKmfCFT9TaabkcYHOhmuIePBJvfEdESyQVkgXynLjBYH?=
 =?us-ascii?Q?ph4Y3dTh0EXK+zp2gletRoGE9iKO+pGzpZR3swLr4BtqLScFPPl3Hs9Ozsrw?=
 =?us-ascii?Q?mCd0F9zm81H2aJ+9eLj4jh95vb41trPMjzVKAEKjzupkJ3tpfNe0txNPNtSB?=
 =?us-ascii?Q?sN5S+qotUi5qQtVMUS03siDftWWRnZiMFwT7I8xeVmjxhFlsO2jKzU3J8Kjq?=
 =?us-ascii?Q?SyQjkPe9QPvt+pXGWzqon7Z3kncO3qbqyNF27SGdcSBMREbHA6VeBD0aC/aY?=
 =?us-ascii?Q?TzYiph1YIh7I32TfHANtDJrAqUE4tafxNeqP65Y9TVc6xwlAhXu9366/x4/i?=
 =?us-ascii?Q?YxwZ2k1aNIEV4DRM71vRz5v+VrQgmt8IluR9t5lcf3ujdpVi8CWSz5KcW0Eh?=
 =?us-ascii?Q?qjf4cDgZ5NbSYK2X00gTQIqkFtqSY++5TSJPxe7W/pzWwp66tsZlhHhfuEC3?=
 =?us-ascii?Q?hSjTNDwEYdAEdQv6qaIoK+GxUoFKElLEphenGflR7lzyyekBMO3f3RwmRl85?=
 =?us-ascii?Q?JYUt9hjoBfu1N/3Yujhd1ic8Vh0ReTRc9XXhzwxno6we9v/slr9j0OJz1htp?=
 =?us-ascii?Q?J7dBASGuDaFbzU28RQK5jpGA1bWAF9X6s8Vp1h4vcA2Qbb337RQLaLTAppYU?=
 =?us-ascii?Q?FThwQKgmAYSUsQYmt2PySYM3NdLT7qIgB3LrB1L0CmXyeGvQ2ih5j5gLnhLt?=
 =?us-ascii?Q?0wVtmgDT6ziwSv8EKJl59/ha6RggXSAoR9sNMGEq+ojDOHGYCtTC2ebijt2a?=
 =?us-ascii?Q?Zcl/GDSxPLBN9YEh4Qpo+0ueV5/t15YD/789+Bsarirlrx9t7aHfKKm6/JMg?=
 =?us-ascii?Q?ufQ9hVqLb00kGA51j+Q2wh6TMrs4YN84FWhBHLS9SBz/o+dOyOt0IXkXXFD1?=
 =?us-ascii?Q?6zHZhYjFC7iPEWHJHCyCqz/fFNRHV9/DKPmelarGp40QM/xYH5xghEaFTW8i?=
 =?us-ascii?Q?5UXY7azRg3wlcN5jOEFnl/Pme+Glz22cRMY+EimNNUxtFxChkAmQvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rKIBDwvrKo49wCRT2/lLVx5yElcb5aFYr0UpkLmU+rCyZv793YdLlrQK4Syh?=
 =?us-ascii?Q?QYH+3suWRiLviWgp2DOySxv+8qLN5h5xp0obiPHHaHOxIapClvH/S3btuHgH?=
 =?us-ascii?Q?xzIodFl0LRJbvF7pwq4Vz9xbB4mm47BRDq7bll24sKJWFa22df11abEBqm7Q?=
 =?us-ascii?Q?EatZD3vejd85giBOp2XCnjTbcPp/3blgid5e7ztZDypXTZlW1HhJ7KLn6va+?=
 =?us-ascii?Q?bWhWXBiyrsqEvXKHdYx4/pU6PJpOVb8BMvBgnNKMItWJs6iOpMDOVNuI6nmC?=
 =?us-ascii?Q?9LZnPecBY3Y/FRLllGTFAFYUGNE7Q+3+5pZe7ivQ2Sf3SLa3sC4x8skpFnNS?=
 =?us-ascii?Q?n4yX1ao3cWNINEryy6qVTt+KnsA521p4bV+8gDb3RXeek4iKxCWYa3ohu8gR?=
 =?us-ascii?Q?7hcaH1cujSsyVwkPQUoyW7rnZ6IsyFd5iuHYpc0dohMol/5gFKy2FRBjiPpu?=
 =?us-ascii?Q?k8cM1dIXLOLt73BjQz78Oc3LTtm/3yVC3RDm+jjZoqH+CO9t+tE8yXiwRy5P?=
 =?us-ascii?Q?Ps8HwOX1Qism+VMmOmRO9y+QOqYZlDZeiWzwbD0h7Oi+hgduK0E/zk8/W0+/?=
 =?us-ascii?Q?1/HYdU4ELRLGLhXo6jnV7MOmA8jLN52eNH7SxE12RTyVQGfPbxWMBZvOWiR1?=
 =?us-ascii?Q?FHYJ/kDfQs85WtjRwGUlzZtX9QUIy8ovAJr3NHS/M3mHJU2PQOXAoWRMH9G4?=
 =?us-ascii?Q?f0FDReGHfhPkd2oZL84+GEdybjKFHzyrsdbUlTGU2MApSPv0W6b9KuH1Ic+h?=
 =?us-ascii?Q?l4ygzT3O58l2QTy1V+B0cArm3YBPs1kNLiQBmGhIiU7p500uh3l/kmR1Sl5o?=
 =?us-ascii?Q?iZJiHCXRQKlVuJ5uazPsxlZ3erPpMdGYu9m/sSkr26WkYt0R8hZ6ZsoWYMkW?=
 =?us-ascii?Q?sVNUB3xH2WQ5nOn/iE4e4a/uGG9Y4hObWHcvd6Ca8ogSfapyJOZdYk6ASgqy?=
 =?us-ascii?Q?Kun4VMUr/hn8b8RaZOtOwTQwxcGte4lmn/GXbykYXXYNzjbDrZAN0gCFtePU?=
 =?us-ascii?Q?8zvzZ5m5Mg6aQKOCzflPdzULFe9h8wP+pM3qrZKn7KXiSLzaYhrk/MlDrNq2?=
 =?us-ascii?Q?KBRJ1OrVYdA60grESyduAMWd2+fHNCBlqzl1STQubQnNSQ3y7aUYkjl6ZFvU?=
 =?us-ascii?Q?RcfbCsWWq2enfHYxRK/p0a0empQJM2TFjwNPNgF3e7r4WewWXfwX12nFLyAG?=
 =?us-ascii?Q?JB3vMGZAgJX8hn+xstBera9CXjxOsybC3GMRFSpUEluPpDz96Y58mN1W5+tN?=
 =?us-ascii?Q?+JMkvb9Mlt9J/22EeDYXrky9g56f4j1QO21eU3KysOTjhvIqVH91eUERxERZ?=
 =?us-ascii?Q?H5RkFNHFDYAwRF8DPbBvwkspYbrEYkG49kmELivoMnpfqCVg2YOYiLQZF7Vp?=
 =?us-ascii?Q?hzuXcPgejfKMvv1GQ1N1TC59RNynrBuLkFYybG7WXgcFPqSADiIb1kOpOGE0?=
 =?us-ascii?Q?GsrA/h7SNdjIXN3scyl+3cfOUeUDY2WO0N7qs1rKynGWy3n7Ul/8mc8VkVmZ?=
 =?us-ascii?Q?1HOTvUcdrmZIwyrKu+8f0Dzinn/3EFIiQEQ2Nj7Zup1+Gh+h9o2VO0TocRtH?=
 =?us-ascii?Q?wkAS7rA0fl87Z/rOoWjsug0KiUqZv05J/sBmsegc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ec5830-dad7-4a26-0c87-08dd76bdfdf0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:14.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTqhVCF5FYo0YH614cpzKXfBE4EOst0XPdMz7Mj7uBQ+YIXxd9c7au+I7GyAA+Tc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Convert most of the places calling get_order() as an argument to the
iommu-pages allocator into order_base_2() or the _sz flavour
instead. These places already have an exact size, there is no particular
reason to use order here.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c        | 29 +++++++++++++++--------------
 drivers/iommu/intel/dmar.c      |  6 +++---
 drivers/iommu/io-pgtable-arm.c  | 12 +++++++++---
 drivers/iommu/io-pgtable-dart.c | 12 +++---------
 drivers/iommu/sun50i-iommu.c    |  4 ++--
 5 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 13b5f83e642369..df1094893eb0d1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -626,8 +626,8 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
 /* Allocate per PCI segment device table */
 static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->dev_table = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					       get_order(pci_seg->dev_table_size));
+	pci_seg->dev_table = iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32,
+						  pci_seg->dev_table_size);
 	if (!pci_seg->dev_table)
 		return -ENOMEM;
 
@@ -707,8 +707,7 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
  */
 static int __init alloc_command_buffer(struct amd_iommu *iommu)
 {
-	iommu->cmd_buf = iommu_alloc_pages(GFP_KERNEL,
-					   get_order(CMD_BUFFER_SIZE));
+	iommu->cmd_buf = iommu_alloc_pages_sz(GFP_KERNEL, CMD_BUFFER_SIZE);
 
 	return iommu->cmd_buf ? 0 : -ENOMEM;
 }
@@ -811,14 +810,16 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 				  size_t size)
 {
-	int order = get_order(size);
-	void *buf = iommu_alloc_pages(gfp, order);
+	void *buf;
 
-	if (buf &&
-	    check_feature(FEATURE_SNP) &&
-	    set_memory_4k((unsigned long)buf, (1 << order))) {
+	size = PAGE_ALIGN(size);
+	buf = iommu_alloc_pages_sz(gfp, size);
+	if (!buf)
+		return NULL;
+	if (check_feature(FEATURE_SNP) &&
+	    set_memory_4k((unsigned long)buf, size / PAGE_SIZE)) {
 		iommu_free_pages(buf);
-		buf = NULL;
+		return NULL;
 	}
 
 	return buf;
@@ -913,11 +914,11 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
-	iommu->ga_log = iommu_alloc_pages(GFP_KERNEL, get_order(GA_LOG_SIZE));
+	iommu->ga_log = iommu_alloc_pages_sz(GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
 
-	iommu->ga_log_tail = iommu_alloc_pages(GFP_KERNEL, get_order(8));
+	iommu->ga_log_tail = iommu_alloc_pages_sz(GFP_KERNEL, 8);
 	if (!iommu->ga_log_tail)
 		goto err_out;
 
@@ -1012,8 +1013,8 @@ static bool __copy_device_table(struct amd_iommu *iommu)
 	if (!old_devtb)
 		return false;
 
-	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-						     get_order(pci_seg->dev_table_size));
+	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
+		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
 	if (pci_seg->old_dev_tbl_cpy == NULL) {
 		pr_err("Failed to allocate memory for copying old device table!\n");
 		memunmap(old_devtb);
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 14bc39b2cdd528..10374b684d6dbc 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1681,7 +1681,6 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 {
 	struct q_inval *qi;
 	void *desc;
-	int order;
 
 	if (!ecap_qis(iommu->ecap))
 		return -ENOENT;
@@ -1702,8 +1701,9 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	 * Need two pages to accommodate 256 descriptors of 256 bits each
 	 * if the remapping hardware supports scalable mode translation.
 	 */
-	order = ecap_smts(iommu->ecap) ? 1 : 0;
-	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
+	desc = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
+					 ecap_smts(iommu->ecap) ? SZ_8K :
+								  SZ_4K);
 	if (!desc) {
 		kfree(qi);
 		iommu->qi = NULL;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 08d0f62abe8a09..545229cf62d2d4 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -263,14 +263,20 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 				    void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
-	int order = get_order(size);
+	size_t alloc_size;
 	dma_addr_t dma;
 	void *pages;
 
+	/*
+	 * For very small starting-level translation tables the HW requires a
+	 * minimum alignment of at least 64 to cover all cases.
+	 */
+	alloc_size = max(size, 64);
 	if (cfg->alloc)
-		pages = cfg->alloc(cookie, size, gfp);
+		pages = cfg->alloc(cookie, alloc_size, gfp);
 	else
-		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
+		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
+						  alloc_size);
 
 	if (!pages)
 		return NULL;
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index 8b5403aae8c0ca..679bda10479776 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -107,13 +107,6 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
 	return paddr;
 }
 
-static void *__dart_alloc_pages(size_t size, gfp_t gfp)
-{
-	int order = get_order(size);
-
-	return iommu_alloc_pages(gfp, order);
-}
-
 static int dart_init_pte(struct dart_io_pgtable *data,
 			     unsigned long iova, phys_addr_t paddr,
 			     dart_iopte prot, int num_entries,
@@ -255,7 +248,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	/* no L2 table present */
 	if (!pte) {
-		cptep = __dart_alloc_pages(tblsz, gfp);
+		cptep = iommu_alloc_pages_sz(gfp, tblsz);
 		if (!cptep)
 			return -ENOMEM;
 
@@ -412,7 +405,8 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
 
 	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
-		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL);
+		data->pgd[i] =
+			iommu_alloc_pages_sz(GFP_KERNEL, DART_GRANULE(data));
 		if (!data->pgd[i])
 			goto out_free_data;
 		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 6385560dbc3fb0..76c9620af4bba8 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -690,8 +690,8 @@ sun50i_iommu_domain_alloc_paging(struct device *dev)
 	if (!sun50i_domain)
 		return NULL;
 
-	sun50i_domain->dt = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					      get_order(DT_SIZE));
+	sun50i_domain->dt =
+		iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32, DT_SIZE);
 	if (!sun50i_domain->dt)
 		goto err_free_domain;
 
-- 
2.43.0

