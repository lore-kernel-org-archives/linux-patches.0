Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAB320E6F2;
	Tue, 25 Feb 2025 19:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512402; cv=fail; b=u5bBEI1YJsyemmCkxi8P4J/rFhv7W5kSdQmTvAlAsxiI3OyLnXSsdKZTNzJnMKKY7mWC/omqXSVKKi+HfXzAIkEhKrDt7mI+Un+z+8CxfMPNjs3o2C3H8GUJa/+YCLyjxL2rupefnEcxWNRIUknBXjWo2DQLwJ6j9cLyu1bkB/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512402; c=relaxed/simple;
	bh=8owX0UimuTp4fd1IOKInR6cBeqD1aVR8hkBTKog8HQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=atReu8gAtQNZs6qoBHijYaToHImTXHIMEMBX0gI1hzNjhMg1D9UmfKGOyUZ4ktDo1uYzANVk+ZkWJJX1H6jZ/WNN87Nsn5wlStDcjZongU3GAdktwSdI8AY/nf3vVvkiXpe1fmYvY8xD6CuH84f7GXdFxHV5MPkTKGMXVXIlRz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E3cGFo0Q; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E3cGFo0Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQpKfUIh+Jiv7lehA48bx7PqqMNdbVYahEc1+Df2wUcsyNY1llBJA52taGYSLG+a6xCDqdk2FYD2vKcOLW9Q1w5+qO5ve240HZ10C2xLrDNISqr2S+Tl5F0zvHdN29nHPc/r1No8TZSAb/Nuj9XVIYfGc5P8gxGi433uA3v7vlMMfEF+ggF+2dD9RN6L84vrTxRm49JCU7JmsAjaFAnVvw/UMPuSSLqDsYt9rigWxSQ2vsqoejarukUHW8puH6UxQWFV8qjpqBk/qxXXN7rrXukyPMUBpqrVmuB237g0u+LNEbbV110wPGMUaKlbnGbxk1g7YQ+CWCuI7hMmLVRZ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZJeM3PGH5q9K5y1kqAZKJGg+yk0NtFwN0/v9eAYncI=;
 b=cz0RnkuEnx777DakNN+7rJ99bYzqz2bVAKZgTf8Ws8aqIhc4e9ofi04/KfkJXHuj3P1wASUWAgfHZWsEbBD+LWnr63rfvSolvENO8U9lXmX+CcFAtLnQ4K2+TsQWlwZH8EY77RpWO9TJ8g4YlGT5QxG0ktLmoYn2nSe4hepu0P0Zl0x3Saiac7gRRtmzWOl0AtZhinCef4nGIJBrgPx9JQSDxBBpVOTCjt+cMl8NNUF46gdACpIs9S8DiH5olqb5QoggsvFb1ncicAZyDolJ/G39YHWuayi9EZ00mdHps3NTJluElsuHvDwTo0hhkCO3xh9E7w7M6MI4EoebPpfcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZJeM3PGH5q9K5y1kqAZKJGg+yk0NtFwN0/v9eAYncI=;
 b=E3cGFo0QrMKkiQJ4X017Gw9Dsvn750jc1gSlq3AVzXuZy7mMX0DFg3Y+WaZnT86i4vhPKNjOmGtsx/+OMeI716twJWj4OacVNCgewDaQ50AU+LjsO7hwluOIPaRdfhFoc1QpWToK+twNvLsGyaTDqfQ/ZKvkf2PnfyJczQB/Ua7qNVkpeiIEp70Yt7AsoPIUFepHneOWLa7NkzYatyYrXrIHMFhypkPSmMPhK6r9h7+Lppr9D9JqD48z4qeH9yxyi3nJ/Jo7FDYSnvsLehP6COi19tQv4ZJbVse2CVo2ErNbEkWPqD3QwiPweWlTcn5buKVWMPM2YR8bZHsfD5mw/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:51 +0000
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
Subject: [PATCH v3 05/23] iommu/pages: Remove the order argument to iommu_free_pages()
Date: Tue, 25 Feb 2025 15:39:22 -0400
Message-ID: <5-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: add4fb83-1f12-4eb0-a7e8-08dd55d427e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xf1HzE4YTEaaYLeNx9p67SKIMKBgmxsdVmdkpX1l121ntQ2/SPOc7ieuxh5X?=
 =?us-ascii?Q?JdDKnlvnbE82VjLHY75Dnyy9DwzN6mml2DR9TUtT7PupSRuQLkH6Dj6cXZdd?=
 =?us-ascii?Q?tgVvLbRw4Mmrpo9CdtwcsqEsbEdy4CJMHjdbSxuLZKHS/mUlhCzTVYbQulh9?=
 =?us-ascii?Q?PU+BMNBET55KdSP/+H2izDNvxjX+QG5xwtdDFksSRg7jEAwkVGYaYtyQFk2Y?=
 =?us-ascii?Q?LOmcgeIWL7SC09t4B166EwSCeqw8uXc8FWxzrIcVxJHOsy85lzuXlH6DBqpd?=
 =?us-ascii?Q?fXp3VUSY59DVb/f5RBbeaMUxhznIcAWUOaIRGojxZnp9MlxZ7XZi+83opAp+?=
 =?us-ascii?Q?8ZBJpgvBmTQsw+aF+4QUgzk79p75tvCa1VaJpLMHOI6HRIkaxvBcaAFNv8va?=
 =?us-ascii?Q?kfuJr0lv8wiqJqDlvFfy+5F6vjMA1yMWPRCIko9avuGLdScL3ZBlo/fdZx9z?=
 =?us-ascii?Q?ZO8z0bmXmV3PaaN3giYT+4PlB+Tkp5OGlH87GsjzcfL+WgKWYd8mMhz5T8am?=
 =?us-ascii?Q?Li184ydd8xDxCpJrMrYBURbaaprAXrroWX2YtYC2s2PpZe0sXcNl4QrxCWNM?=
 =?us-ascii?Q?iLOnXeH8j6rLECF9EqA8On9hr7otV5CO4pBkBgJadJ0PbkMaYvuAialYqfcN?=
 =?us-ascii?Q?trb9+wRzCJV9ukRLX9Pr5aCwGSfYz6QjqHGM0T2zpe5r2JU6tzh0zqyDXIsP?=
 =?us-ascii?Q?sK2NqbLaIiswjxLMA82TAZzRyM3HCngrwoiJsZwuGL5nq4bY2c0uIsRdvbdw?=
 =?us-ascii?Q?rlv4ruDulMZ54lsWdWyfHxMxBwTicaIg4Eg15JSXPGlydPWC1tyhkzN4B5QP?=
 =?us-ascii?Q?j/xlB7lFvEX9y8slaoMI/L3K0FX5LZ4bzdskkwZ1KQ5qC/IK4bhZwRK/CFgm?=
 =?us-ascii?Q?A5poMQIaMTos3N8ILTe2m/x49WmFqGvfGMEci3aqZPsE3GMv5xnsUdtIKgA0?=
 =?us-ascii?Q?ItrV2zYIiFsf3UM2uxx5eFyqhp0LEJkNs8PQBclJa7YI9ZpOM7eIASUuZORo?=
 =?us-ascii?Q?W+eweQlOfez2W0UdI7O8dm+O4JZ4YXmhnwjrjdZFjBx2xi+KuFkUEcwrP5pS?=
 =?us-ascii?Q?AwzvBZHLIvJZCRB24XH5JlqI9whbqMTqPjS7h5sd2YqhLe8AGBz1uJ3WfWHo?=
 =?us-ascii?Q?hjH2A9ciuUy4G3P10qHCfHd4Zw+ReiUBwOW/BdnWzFroLeyl/0sIiSptecJ6?=
 =?us-ascii?Q?uoa8ySoP7uq92oDpyv0nzZtB4rqkCeqy+2mP9XIqkyhZWI0mADISvGon+lfz?=
 =?us-ascii?Q?2PGvNIViqUKtLuiyDcMMxUn25y+Lhhu72+r3ly6bzPnzzd6D6VDVY1DQ72dr?=
 =?us-ascii?Q?GlQbXKZjUTfqtdenyVTTwiv+sJ7HqO7JCITbTRqbBtinr42btc10KQAowEXV?=
 =?us-ascii?Q?j+wKpcpDwc8N/HAhy7DTnMuRnMN0APSmoX5xezD9qA+l+JuHmCacWbpd19Ey?=
 =?us-ascii?Q?y8k6zcnUkeM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0/AE2fed1ZQesE7FjlG64K9m9HVxO+to1RiXv/6z/durtGEDhxOiqjMCL8Rb?=
 =?us-ascii?Q?kGqMiBXSmXCOSIB4oCB0UoALjz+hnYzr83EHRtFo2hSP/1FUvfv/rlBJajA9?=
 =?us-ascii?Q?u8+bpVq9dqoRIyHmpziL8d64ktMUNEr24w6FxDBfMjB4/iLXEKJ+l4tqROcs?=
 =?us-ascii?Q?cySy5yKMKiIoQDc/Gm/npyzq1UMbt/5gKZtE7znX+uRxnbcwgXsgqtiXggI3?=
 =?us-ascii?Q?EtP6OemaXGTQUQWvII7pChSnSzUNt8W5dL14Crx34i422CmkyxHulBU4YO/u?=
 =?us-ascii?Q?TGP5fs8m3Vyuq+mcUeyb7dxSB7bJ2hHO2XTFn6itIDfFCwNlFSuAeT3adlM9?=
 =?us-ascii?Q?c11GYhxqWfyyDds8CKoDImO/v/GgF+UljPX9YRnqxzMP4+fiyMFYJhJFwmpg?=
 =?us-ascii?Q?iqzd4XAPcDWQqPMNEJP+hzc6Ku0EejoO3U677ux+6X5AoGELversP7KrDCzd?=
 =?us-ascii?Q?cSl+4hBsdn8HGHgfVg8UvoPttUjsGajOZJA5Rl2SxTnqZzpON48R9Trcrq/b?=
 =?us-ascii?Q?LYswZv6/k8xt5ZOfygZnqkEhakt7NWEQEYBKTz44qL76U2ud0byaP9529HKW?=
 =?us-ascii?Q?QZwC5YBuVIcYAF7rB1fCM2nd2Gv7ygkSdFGPTg7p4aQ3kufcHwg8EqUCVmdn?=
 =?us-ascii?Q?gNVqtjeJ/IgVSZyWWc4dSYD3vWuE5y/wxRz4Q3pm3Xr/bk4bEmLtV8ehkYcu?=
 =?us-ascii?Q?07LZTbKVhZqb2dz0MQ6xMqac6IsVwPM7F7gSi6BK+jA1m4gNAshZJVQ5soBT?=
 =?us-ascii?Q?T3rAJs5k0bsbzJzHbKaYjmD/qwGPd4i+zNqPzdWcEXSK3OqpdwA16YEwm7xG?=
 =?us-ascii?Q?FR8Ntpb+a688WibiXIvNBvf/gHCkR3OlmfO5QwnfGyEsHSuYfH8i/hsneSrW?=
 =?us-ascii?Q?0ahWj2piDKktdIge5MbZ7IwPkAXfzdgrrceAmZ10/XFDckdlzZpytyZOlvjy?=
 =?us-ascii?Q?M9j7H2Yx3N9eUOEF7tjVVzQrS7NbbM5dbFUqnt8QihGgqhWw5+jc/PXiqwYh?=
 =?us-ascii?Q?hsHxlxWcf+3pXTn95O0T4JGU7dTVEogkr+1zQ+jMVy1qR8yLhvuzCDlOUdL8?=
 =?us-ascii?Q?3qLzUwbLKu20hLaoV8/zYgCLDdN/5vwRtq9t6ZETNFbo4u/lFn3pkhrdsLBh?=
 =?us-ascii?Q?/qZNfliNr4qHw0CmG/TXwSFUajGoPGW0LTU4X2MHXt+wmjbIZIAxc4QUQB1U?=
 =?us-ascii?Q?36qSeS279QMXOxaqXZ1+FvrtBu6UM4qivy/9haQzJP0yx47h0CyeyxOcmhHb?=
 =?us-ascii?Q?dGr5e6VR7MF4NzF6SM9Bsf6K169tGPPyJtXukXlhwJHi4UrFHqBtMfiTG85A?=
 =?us-ascii?Q?vpgWONSr5fudBIsP9CzoQqgBVCXZj9nTkznmPAjs/tN2x7Jsg0yuuY11ZVQt?=
 =?us-ascii?Q?xmwK1U7OhcIJKTPTEdiknDl7BG3v5hZJOyBFfKeO1WYpfFsfd7qR0pIOuWOO?=
 =?us-ascii?Q?Wy6VQ+MTHtw/uM9ffus+2kocLd2e5gv+hZ3JXM4E+Hm0lcfa7lQSwxYuVk6n?=
 =?us-ascii?Q?FSm+w3llSRVaWq+IrZ6l3ZTiSGSYUvNP56+ZAba236LoW8TzhMx7EYJ6ldRB?=
 =?us-ascii?Q?TP372C4Wts51lYY8+iJcZjPfuQCQw7b+ChSUZkd+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add4fb83-1f12-4eb0-a7e8-08dd55d427e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:45.0707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHtsKmHm0D1HgUxcUHhOoCR412y3BZED8DxJuwIqiH6FaeLz+sJETCZlxO49FqcC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

Now that we have a folio under the allocation iommu_free_pages() can know
the order of the original allocation and do the correct thing to free it.

The next patch will rename iommu_free_page() to iommu_free_pages() so we
have naming consistency with iommu_alloc_pages_node().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c            | 28 +++++++++++-----------------
 drivers/iommu/amd/ppr.c             |  2 +-
 drivers/iommu/exynos-iommu.c        |  8 ++++----
 drivers/iommu/intel/irq_remapping.c |  4 ++--
 drivers/iommu/intel/pasid.c         |  3 +--
 drivers/iommu/intel/pasid.h         |  1 -
 drivers/iommu/intel/prq.c           |  4 ++--
 drivers/iommu/io-pgtable-arm.c      |  4 ++--
 drivers/iommu/io-pgtable-dart.c     | 10 ++++------
 drivers/iommu/iommu-pages.h         |  9 +++++----
 drivers/iommu/riscv/iommu.c         |  6 ++----
 drivers/iommu/sun50i-iommu.c        |  2 +-
 12 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada061..f47ff0e0c75f4e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -653,8 +653,7 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table,
-			 get_order(pci_seg->dev_table_size));
+	iommu_free_pages(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -671,8 +670,7 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->rlookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->rlookup_table);
 	pci_seg->rlookup_table = NULL;
 }
 
@@ -691,8 +689,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -716,8 +713,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table,
-			 get_order(pci_seg->alias_table_size));
+	iommu_free_pages(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -826,7 +822,7 @@ static void iommu_disable_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	iommu_free_pages(iommu->cmd_buf);
 }
 
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
@@ -838,7 +834,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 	if (buf &&
 	    check_feature(FEATURE_SNP) &&
 	    set_memory_4k((unsigned long)buf, (1 << order))) {
-		iommu_free_pages(buf, order);
+		iommu_free_pages(buf);
 		buf = NULL;
 	}
 
@@ -882,14 +878,14 @@ static void iommu_disable_event_buffer(struct amd_iommu *iommu)
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+	iommu_free_pages(iommu->evt_buf);
 }
 
 static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	iommu_free_pages(iommu->ga_log, get_order(GA_LOG_SIZE));
-	iommu_free_pages(iommu->ga_log_tail, get_order(8));
+	iommu_free_pages(iommu->ga_log);
+	iommu_free_pages(iommu->ga_log_tail);
 #endif
 }
 
@@ -2781,8 +2777,7 @@ static void early_enable_iommus(void)
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy,
-						 get_order(pci_seg->dev_table_size));
+				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2795,8 +2790,7 @@ static void early_enable_iommus(void)
 		pr_info("Copied DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
-			iommu_free_pages(pci_seg->dev_table,
-					 get_order(pci_seg->dev_table_size));
+			iommu_free_pages(pci_seg->dev_table);
 			pci_seg->dev_table = pci_seg->old_dev_tbl_cpy;
 		}
 
diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 7c67d69f0b8cad..e6767c057d01fa 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -48,7 +48,7 @@ void amd_iommu_enable_ppr_log(struct amd_iommu *iommu)
 
 void __init amd_iommu_free_ppr_log(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->ppr_log, get_order(PPR_LOG_SIZE));
+	iommu_free_pages(iommu->ppr_log);
 }
 
 /*
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c666ecab955d21..1019e08b43b71c 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -932,9 +932,9 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	return &domain->domain;
 
 err_lv2ent:
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->lv2entcnt);
 err_counter:
-	iommu_free_pages(domain->pgtable, 2);
+	iommu_free_pages(domain->pgtable);
 err_pgtable:
 	kfree(domain);
 	return NULL;
@@ -975,8 +975,8 @@ static void exynos_iommu_domain_free(struct iommu_domain *iommu_domain)
 					phys_to_virt(base));
 		}
 
-	iommu_free_pages(domain->pgtable, 2);
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->pgtable);
+	iommu_free_pages(domain->lv2entcnt);
 	kfree(domain);
 }
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index ad795c772f21b5..d6b796f8f100cd 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -620,7 +620,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 out_free_bitmap:
 	bitmap_free(bitmap);
 out_free_pages:
-	iommu_free_pages(ir_table_base, INTR_REMAP_PAGE_ORDER);
+	iommu_free_pages(ir_table_base);
 out_free_table:
 	kfree(ir_table);
 
@@ -641,7 +641,7 @@ static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 			irq_domain_free_fwnode(fn);
 			iommu->ir_domain = NULL;
 		}
-		iommu_free_pages(iommu->ir_table->base, INTR_REMAP_PAGE_ORDER);
+		iommu_free_pages(iommu->ir_table->base);
 		bitmap_free(iommu->ir_table->bitmap);
 		kfree(iommu->ir_table);
 		iommu->ir_table = NULL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb59a7d35958f5..00da94b1c4c907 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -67,7 +67,6 @@ int intel_pasid_alloc_table(struct device *dev)
 	}
 
 	pasid_table->table = dir;
-	pasid_table->order = order;
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
@@ -100,7 +99,7 @@ void intel_pasid_free_table(struct device *dev)
 		iommu_free_page(table);
 	}
 
-	iommu_free_pages(pasid_table->table, pasid_table->order);
+	iommu_free_pages(pasid_table->table);
 	kfree(pasid_table);
 }
 
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 668d8ece6b143c..fd0fd1a0df84cc 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -47,7 +47,6 @@ struct pasid_entry {
 /* The representative of a PASID table */
 struct pasid_table {
 	void			*table;		/* pasid table pointer */
-	int			order;		/* page order of pasid table */
 	u32			max_pasid;	/* max pasid */
 };
 
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index c2d792db52c3e2..01ecafed31453c 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -338,7 +338,7 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	dmar_free_hwirq(irq);
 	iommu->pr_irq = 0;
 free_prq:
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return ret;
@@ -361,7 +361,7 @@ int intel_iommu_finish_prq(struct intel_iommu *iommu)
 		iommu->iopf_queue = NULL;
 	}
 
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return 0;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 7632c80edea63a..62df2528d020b2 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -300,7 +300,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, order);
+		iommu_free_pages(pages);
 
 	return NULL;
 }
@@ -316,7 +316,7 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, get_order(size));
+		iommu_free_pages(pages);
 }
 
 static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index c004640640ee50..7efcaea0bd5c86 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -262,7 +262,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 		pte = dart_install_table(cptep, ptep, 0, data);
 		if (pte)
-			iommu_free_pages(cptep, get_order(tblsz));
+			iommu_free_pages(cptep);
 
 		/* L2 table is present (now) */
 		pte = READ_ONCE(*ptep);
@@ -423,8 +423,7 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
 out_free_data:
 	while (--i >= 0) {
-		iommu_free_pages(data->pgd[i],
-				 get_order(DART_GRANULE(data)));
+		iommu_free_pages(data->pgd[i]);
 	}
 	kfree(data);
 	return NULL;
@@ -433,7 +432,6 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 static void apple_dart_free_pgtable(struct io_pgtable *iop)
 {
 	struct dart_io_pgtable *data = io_pgtable_to_data(iop);
-	int order = get_order(DART_GRANULE(data));
 	dart_iopte *ptep, *end;
 	int i;
 
@@ -445,9 +443,9 @@ static void apple_dart_free_pgtable(struct io_pgtable *iop)
 			dart_iopte pte = *ptep++;
 
 			if (pte)
-				iommu_free_pages(iopte_deref(pte, data), order);
+				iommu_free_pages(iopte_deref(pte, data));
 		}
-		iommu_free_pages(data->pgd[i], order);
+		iommu_free_pages(data->pgd[i]);
 	}
 
 	kfree(data);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 26b91940bdc146..88587da1782b94 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -105,11 +105,12 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 }
 
 /**
- * iommu_free_pages - free page of a given order
+ * iommu_free_pages - free pages
  * @virt: virtual address of the page to be freed.
- * @order: page order
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
  */
-static inline void iommu_free_pages(void *virt, int order)
+static inline void iommu_free_pages(void *virt)
 {
 	struct page *page;
 
@@ -127,7 +128,7 @@ static inline void iommu_free_pages(void *virt, int order)
  */
 static inline void iommu_free_page(void *virt)
 {
-	iommu_free_pages(virt, 0);
+	iommu_free_pages(virt);
 }
 
 /**
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8f049d4a0e2cb8..1868468d018a28 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -48,14 +48,13 @@ static DEFINE_IDA(riscv_iommu_pscids);
 /* Device resource-managed allocations */
 struct riscv_iommu_devres {
 	void *addr;
-	int order;
 };
 
 static void riscv_iommu_devres_pages_release(struct device *dev, void *res)
 {
 	struct riscv_iommu_devres *devres = res;
 
-	iommu_free_pages(devres->addr, devres->order);
+	iommu_free_pages(devres->addr);
 }
 
 static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p)
@@ -80,12 +79,11 @@ static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
 			      sizeof(struct riscv_iommu_devres), GFP_KERNEL);
 
 	if (unlikely(!devres)) {
-		iommu_free_pages(addr, order);
+		iommu_free_pages(addr);
 		return NULL;
 	}
 
 	devres->addr = addr;
-	devres->order = order;
 
 	devres_add(iommu->dev, devres);
 
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 8d8f11854676c0..6385560dbc3fb0 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -713,7 +713,7 @@ static void sun50i_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
 
-	iommu_free_pages(sun50i_domain->dt, get_order(DT_SIZE));
+	iommu_free_pages(sun50i_domain->dt);
 	sun50i_domain->dt = NULL;
 
 	kfree(sun50i_domain);
-- 
2.43.0

