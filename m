Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3481FDA65;
	Tue, 25 Feb 2025 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512387; cv=fail; b=uM+b+mKOjRHNQp9KjuO4r+zQs4qfqngn6jX/uAUWLRVBi08m5u0ha3p09VkCEOvtxBVH9msTmzdha54UIZOzrbp0PCf8s4Ah1QrALuK/FbLxrnt7sww6cnqg0XJrZY5SC4U7nYARuiMzj6cWghRxPAZBGAby1TG4TGeh0DsO+20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512387; c=relaxed/simple;
	bh=75yvjr7dn5OawIM3bug/ul4dFZ8lzhKHadpZV0QV/ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PEWrfh8ivizGIAaEP3wfUbMvyeeFWsCrW5wJNh6d0fiLab2cS8VyqjApMWa9sd/+Adf6zMkA5zeetfE15GcAzurGFjjafvaoaVHmcb2nYOLanUcJFnTWIQLIv4F+aISbQOm0EBjACteIfGsCFlJQ/KM6h3S/IJdwjfQXjpLx6uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p0fFgqZI; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p0fFgqZI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ywj2dACj0W0zZe+2XwwRFAfVUfVogGOlkcC67erJ6J9mYwLCIpHwzmKKxUvUrFFMMSBL3A6vSqegp5pQx2lbftatdFy2KHFoobL/+XGyZOSvqNAZSA1oiZK7nNuaAqr9O9vNjY07ny4HvhlmsF1quwlZQh1uSvwKEINRjc0WDX4YSkYGUD6KIRJZAI+PkHoYjh8P6zEHAuauGJk02LNWrZpzxLJW9qm5pkWFs/KUfUxWgdyJUm+G+MEtDSd3drSVBebx9GSMwdpm42jQogUACMlkHW8LH+XcDC/KU6Fuf5wQdguviAUKSfSV8Pr5g+399Q1oCUdJwXBerH6Zx3lqqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocqkWzOZVA5WJ+XsiY+3U6yRvBn4DuZi5eoxznJmr2w=;
 b=XSkpqO/ej6Zfmt+Xawzsx7uwtX7CF3osGLfimSzxXIOuVVrHjYX31FA9dSZhAFoWN5iJqpCEunZte2wuV+pqsD++t4aWKZ3EJgoqzpKSMVc8Ia15XwLpnoMnN2zx+N8MBmFE8FGipJomH0MBQgiHS2Y3admKgqrvFv5SeFEMqSQYmA4M3mKz0Iwaxn1gpwGYNh93IrpXgUdOPiptzcz/XRxih4kw6pew5Yql3S5HCKuFt2ELCM5vSUE2TCHP9nFJIFQYLvzcJyue3zNC08JBAB0w77RL+EFgRLuWsUvhNPabUJz4zsTlM+LyF+EXTJHPDEZrArTMxBIOm0fZw/sErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocqkWzOZVA5WJ+XsiY+3U6yRvBn4DuZi5eoxznJmr2w=;
 b=p0fFgqZIcbMZwMrJtUmnMZHg5gLCcj6ZRQzX4bRZ2UUkzmd/0R8odapfNOo0doqk88x0CL7z5Dm2C9+Yr7cZsXn7AjTA7da2nH0LK03Z6fbLIVRMYgDcSs4qVHYiID9Glz9I75W8i6KIUzNuGreLiyEfYPXVUUpDvfhGEOYAfV0zP12ZPy44CmjSYqsP9FVMGLaZuOwyfnEPtuN07a3GJp34eGdDq47F5XKAPM96aUvsKRzOOFjNDKYCw7u7NDupmcHotNdyMlul/TtfjA3mFt9u+GZ7dR8biOpoeadbB3+nhQUyKpAyhB5KSiDlOOMOd26/FO2aO5lObJS0CsIo2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:42 +0000
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
Subject: [PATCH v3 02/23] iommu/tegra: Do not use struct page as the handle for pts
Date: Tue, 25 Feb 2025 15:39:19 -0400
Message-ID: <2-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0137.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: c2dc9974-5f49-4a22-19dd-08dd55d4263b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xj5U+9Da9s/BT0yNwFBrLSxTHc2SRDtHy/bUnWJUJpAjJgP2ommYZ39kyBTE?=
 =?us-ascii?Q?A/RPq5YDHy2YQ8YBmho+IuV9ulnIm3TXfDi44LEguTWEOOh8E4/oCf6I2z/f?=
 =?us-ascii?Q?I0nbVaOA7h/vaTO4RU2W7iycLoZD7lR7TzDEpYcMHXD4QiZQBD8IO3NwPJzP?=
 =?us-ascii?Q?6hi7rdEgMh90K1R+s/nN9R7CB6mSbhXuIJwhD1Q6NV8m09lfCf8rUiKF0vSx?=
 =?us-ascii?Q?QMM/kKCvbh9oItfTS5y4Gvwh3elx53mIZEJeU7aOE4MLFY3JIzrGpT2I5z0R?=
 =?us-ascii?Q?P4OAprjfaSV9nOfMvaL3zDYpS0YlTc3FGCRoY44iHMMTtMEaLNyRB9WJ4kab?=
 =?us-ascii?Q?gKpLtz72DaUnad/H7e0L525msUrZXYDXY+l4SSeJDc3oOO6xVWKTdPaIP/Va?=
 =?us-ascii?Q?wC+gyujDn9thRAauYFe1OHdIVz4nvaVsRI4wWPc4u7AmDo3yOm8rOMIpJHmL?=
 =?us-ascii?Q?l+fTgAILKNz6hu+rOj0lJZPHTKb3mHp8zfCJGVHyCFO43q1coKN6TVEcA0/R?=
 =?us-ascii?Q?+2d499Ah5vTeiSv+KqUUnmChDKpkimQsqZJFEd/fK9t8NPN7b4Ua7575NvBs?=
 =?us-ascii?Q?oz+Jkr2mrv7m0phv6cuNuWJA0kCURE5SijC+iHd9zjy+CkWM3tqEn/wmkQzo?=
 =?us-ascii?Q?W6qvrd/zb0fuu7PR++3CfCwEkn2Vp3WwSZk/KykkK+zXappuWc0MnMwQyCVe?=
 =?us-ascii?Q?XmlTE2OEbPtx2JLV8acKDrFubgmPU19hKLVPyr0JNOhlMsyuWtD9j6ji9vUV?=
 =?us-ascii?Q?A2uzDz1NvL42wJBvcVTKBE6Xb1OUz93Sw4CuZB67UpZrWqcb/26G8r7P3RTY?=
 =?us-ascii?Q?WM2HTt85yvNfduZ5e1MkayIzaPYMsqHzVgIXnxnHOyqtjHN8r9afH7HLXyD3?=
 =?us-ascii?Q?mIP6zQwQRQG5omdKeg6PE9cUoODkGox+ZjW6wwBuMrJVxDLtqAbpl11sFMWV?=
 =?us-ascii?Q?GlvFWuBc9vemHBB9dFeF1jm3Td7QrT8xWTfJpaM/vZP5cO4IMSWm4iCqZoLb?=
 =?us-ascii?Q?bG4v0BBhAjpnB5fVypfyor3anbsQlGETaJdBrALP8HzFE5vH60gEC9Bo+sBz?=
 =?us-ascii?Q?g98biMLzWkQmk1E1rJdvj16m1NJ6UYPvcmgyswoo5leKnlcQmkx9UA2ISYD6?=
 =?us-ascii?Q?9kAQw7fFQX4UoyimsVCp7M5yH7UeGmM/bIDcsgaY5ObJaIJ1zEe9jElobMFl?=
 =?us-ascii?Q?LPik19WWl+6ybq7Yd7Ca6ARaZfVbMq9Rr02MsmJhIkn63q535qfRtbUnyV6D?=
 =?us-ascii?Q?optR9jWMgBZxGqH71Y3yo7vnlFi1IbiFKR7fU/zWxhgP8hoXySc6c3tTWKMA?=
 =?us-ascii?Q?X+r46exEhVzOtn75fJfoHBAMR+rJzMgSv/+QlkzYszU1+pKBiODsm1LZGYsI?=
 =?us-ascii?Q?IztUhXalDSHPBaSomQobAMcgV/9id+S9O6nDfpZvpw+R08DfsWG2w0QCxtvo?=
 =?us-ascii?Q?0OPokOPDriY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EvL7GsN6d1Ps0GshW9HQuf/AD6KyKCLa9zTbdWfuvdbY64r3mSYZ0/jnkHIj?=
 =?us-ascii?Q?XHMK71/Gc9/LFJhwlrVyv3EARqE5d9YHhsNRfn24y7ggYyrGzbsGLXyfEq8I?=
 =?us-ascii?Q?ZR4DxohwAB/JCbyOq9XW/0OAzELo94BPd+05il52Sf5q8hrM4eMa1hiP52cf?=
 =?us-ascii?Q?+iLFiMeVgXpuNXpBe1FRvlPQOYdloD6qIHqqrsOKNNa89ZXIrBEibiXxhd4J?=
 =?us-ascii?Q?LbdYKfoUBHT2Ryh9m7QG0t/6iYH9h+LmWOxs9EgHKX/JBg5zREcEfEYgqbyv?=
 =?us-ascii?Q?jXTTsuaT3ERvocjEDluZkl/OCNYhMg4M63B+7/QqBX2HsGML85hrXx/izMnP?=
 =?us-ascii?Q?XUGwRe1gliPgtlrAsPkl8StgTgntMFg7O0+o4fxnZhufbaixmVDHSlao6pUT?=
 =?us-ascii?Q?0ht2afTZg9kDGk8rte082Kd5oMzS6MEJNLZJpddZMCFt/rgxffRUd5xuffZ3?=
 =?us-ascii?Q?Uz2dczpSvahKLbrciiiFuVFu06FLRh+462p4c+WFaGKCEmt+K4yc52CynBVB?=
 =?us-ascii?Q?cFVD9q8OUOc8E74HqsFKWqXVG/p9SLRFwBkiAuUhlo3p+ha4vJhKdHiE3UCx?=
 =?us-ascii?Q?2vRbbol8YsQuzuWIc3Ay/M5aQQakXz3/7sU9eHWUFzQ0Nfx8djUAof97RrM/?=
 =?us-ascii?Q?MAgreVNJ6plWGnpVxrZ9OMrJWDYc5hTkdTAewp7zDYoSY5tBKom2V26pw4S5?=
 =?us-ascii?Q?OuSTZ1m9gC8n29qT5jdN8UQ/s83zc9J2GXkN8pYU1QrVeyV7HbXj7wwXL/IV?=
 =?us-ascii?Q?EYx20EO42SNK/Eh6oWspKrxbAaFccjlzygwcQrm5yWmReXxJUaYPFBfEaQ/V?=
 =?us-ascii?Q?SN9DnyOxnQr4tG+Lsxw3wTUPdLoU/GuvPE/sN8nVf12uUwowa83N26FJJuxn?=
 =?us-ascii?Q?VqZ4CQMAljbJgij2GHIcHC/iCUEeoqZhDBTH9EnUlp7L47TWWylQlDtc66yU?=
 =?us-ascii?Q?4P/UoYAFfLQqMHJXVgVmc4dNjpnSLozLSlQ2A68MqUbExw6/KxWiKruirQbF?=
 =?us-ascii?Q?lfQyXPKN1WBDi+jc+buiQx0NhYnLgbkXkteliull5q2/q5jo0iv8UgCn+ftF?=
 =?us-ascii?Q?P0NOLTgauMODhDe5JPWuXN0zbTIyhFo0cUQGDRUrPYxG/nqYucgw1vPqPvka?=
 =?us-ascii?Q?jWc/oRuAfDZz4IJQW+LAsOwi+yUFWxlGJxa5h0C0WWYpNiiGb1gdD6U+eBba?=
 =?us-ascii?Q?07VDfa6gBA0Capt+CbVEPxLfeuVS5YUzg3v3XbmqSFHQ8OlGawcAcMwaDCeJ?=
 =?us-ascii?Q?qWG/6H8BLl4WtihxQwDvmELHrEz7Hdkm2Luv548SZSj0Drwv6iiHD56u0y8R?=
 =?us-ascii?Q?quAea3YOWEYC6iXkVBhu83yegnlWv+VlydW/Q5gRxwucWGBB8kNLhkBlfW+d?=
 =?us-ascii?Q?621QJc/5QBZHvv7ekLfTB/T+adi+TDDNm3opiAgY5gL8CrpNMDUA6/4lauKM?=
 =?us-ascii?Q?krEP+D+unBqzoiKyKLZG2PKA5iFcYe0QAfPqFqZpJqVjLkUfGsh1EqszoQxZ?=
 =?us-ascii?Q?GgF0qEPgewghGca5oEAaTK1elS8CbMRa7BYFN8bN0h1E49KSN3WU+a3qLKHS?=
 =?us-ascii?Q?TsjTiB9/r+o1SH2SQAlmWdykTLHWRkYehmZaItAb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2dc9974-5f49-4a22-19dd-08dd55d4263b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:42.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWaaJ8OTwhQFvoeQcU1rGxvXsydsi+yfN4P4EXONCrA7c2N4HrUeacffewLRUchk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Instead use the virtual address and dma_map_single() like as->pd
uses. Introduce a small struct tegra_pt instead of void * to have some
clarity what is using this API and add compile safety during the
conversion.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 74 ++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index b6e61f5c0861b0..c134647292fb22 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -52,6 +52,7 @@ struct tegra_smmu {
 };
 
 struct tegra_pd;
+struct tegra_pt;
 
 struct tegra_smmu_as {
 	struct iommu_domain domain;
@@ -59,7 +60,7 @@ struct tegra_smmu_as {
 	unsigned int use_count;
 	spinlock_t lock;
 	u32 *count;
-	struct page **pts;
+	struct tegra_pt **pts;
 	struct tegra_pd *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
@@ -161,6 +162,10 @@ struct tegra_pd {
 	u32 val[SMMU_NUM_PDE];
 };
 
+struct tegra_pt {
+	u32 val[SMMU_NUM_PTE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -570,11 +575,9 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static u32 *tegra_smmu_pte_offset(struct page *pt_page, unsigned long iova)
+static u32 *tegra_smmu_pte_offset(struct tegra_pt *pt, unsigned long iova)
 {
-	u32 *pt = page_address(pt_page);
-
-	return pt + iova_pt_index(iova);
+	return &pt->val[iova_pt_index(iova)];
 }
 
 static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
@@ -582,19 +585,19 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	struct page *pt_page;
+	struct tegra_pt *pt;
 
-	pt_page = as->pts[pd_index];
-	if (!pt_page)
+	pt = as->pts[pd_index];
+	if (!pt)
 		return NULL;
 
 	*dmap = smmu_pde_to_dma(smmu, as->pd->val[pd_index]);
 
-	return tegra_smmu_pte_offset(pt_page, iova);
+	return tegra_smmu_pte_offset(pt, iova);
 }
 
 static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
-		       dma_addr_t *dmap, struct page *page)
+		       dma_addr_t *dmap, struct tegra_pt *pt)
 {
 	unsigned int pde = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
@@ -602,21 +605,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 	if (!as->pts[pde]) {
 		dma_addr_t dma;
 
-		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
-				   DMA_TO_DEVICE);
+		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
+				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			__iommu_free_pages(page, 0);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
-			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
-				       DMA_TO_DEVICE);
-			__iommu_free_pages(page, 0);
+			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
+					 DMA_TO_DEVICE);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
-		as->pts[pde] = page;
+		as->pts[pde] = pt;
 
 		tegra_smmu_set_pde(as, iova, SMMU_MK_PDE(dma, SMMU_PDE_ATTR |
 							      SMMU_PDE_NEXT));
@@ -639,7 +642,7 @@ static void tegra_smmu_pte_get_use(struct tegra_smmu_as *as, unsigned long iova)
 static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/*
 	 * When no entries in this page table are used anymore, return the
@@ -651,8 +654,9 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-		dma_unmap_page(smmu->dev, pte_dma, SMMU_SIZE_PT, DMA_TO_DEVICE);
-		__iommu_free_pages(page, 0);
+		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
+				 DMA_TO_DEVICE);
+		iommu_free_page(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -672,16 +676,16 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static struct page *as_get_pde_page(struct tegra_smmu_as *as,
-				    unsigned long iova, gfp_t gfp,
-				    unsigned long *flags)
+static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
+					unsigned long iova, gfp_t gfp,
+					unsigned long *flags)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/* at first check whether allocation needs to be done at all */
-	if (page)
-		return page;
+	if (pt)
+		return pt;
 
 	/*
 	 * In order to prevent exhaustion of the atomic memory pool, we
@@ -691,7 +695,7 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	page = __iommu_alloc_pages(gfp | __GFP_DMA, 0);
+	pt = iommu_alloc_page(gfp | __GFP_DMA);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
@@ -702,13 +706,13 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	 * if allocation succeeded and the allocation failure isn't fatal.
 	 */
 	if (as->pts[pde]) {
-		if (page)
-			__iommu_free_pages(page, 0);
+		if (pt)
+			iommu_free_page(pt);
 
-		page = as->pts[pde];
+		pt = as->pts[pde];
 	}
 
-	return page;
+	return pt;
 }
 
 static int
@@ -718,15 +722,15 @@ __tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
 {
 	struct tegra_smmu_as *as = to_smmu_as(domain);
 	dma_addr_t pte_dma;
-	struct page *page;
+	struct tegra_pt *pt;
 	u32 pte_attrs;
 	u32 *pte;
 
-	page = as_get_pde_page(as, iova, gfp, flags);
-	if (!page)
+	pt = as_get_pde_page(as, iova, gfp, flags);
+	if (!pt)
 		return -ENOMEM;
 
-	pte = as_get_pte(as, iova, &pte_dma, page);
+	pte = as_get_pte(as, iova, &pte_dma, pt);
 	if (!pte)
 		return -ENOMEM;
 
-- 
2.43.0

