Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B009268FD9;
	Fri, 14 Feb 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552911; cv=fail; b=TLfKYRXFBr/szSdQquhOC6bBSNNGTBtGIh6fXEqftANYUVg4oJUswxkgOanhCGoe9QhoSYd1VsiMHff6Gu9Q8HzKtbqGgbhfYHXbWE4hVqcbColgkTKX1TeIARDTbYxUiTCntNywJ8MbOwMdhGXXx9S7Y/E5e4smlkLCypotvro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552911; c=relaxed/simple;
	bh=9+PcXgxj5ZwEJjq6mK+XECqgPL32aFrQJ/AnVGVmfcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HIoZU36VPq6Pwg8cgT4e3TKfTzw/8Hy4vSK6jTpSDVhvb7iA9LAOK9BjW13HKuRYkX+1J6EpltXSrIGWNMZbODApH+TH3RKco2z26ttLr26V7OmzcUs0dbLmKtZjjmmesptnIV5n0n9ykjtFsjYu0QIFGLVGGYHgHm+s3+Xl7OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PZa0cKDG; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PZa0cKDG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXDrHegDsd1bGlzukQs6kS2Pg0dAneWtzNI7BzPaqQL047JCYnWz29C4r78L/HcUiVDpI5b/Xx4+afIsYXi4PXfvhY4AbD1Ym4Mt9Yt4pBV7jt4v8794wxaNVLxHaSgaL/bN2icTzWJ8FYBbTAYDy0bVW29AnrQ8V+j4gJqYIFon/OC4io/5I9VcvkIvUsq+a4CNWrQm97HeCfXfKaZHRMS5maUNiVX7kcHsgDaQyaIPV/gyvImb2B3yxG26CBLt3P0SHHS517E2WGT/PFbZKUOY8amyn9fThkuJTQjCftdls0TpvSUIVAdnA0mDB31cERAtlBCrelF1oqtr/54HFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svzcsAcPURNMvNzUrcJqS1csKa8sqow9qtq28cPI8dA=;
 b=AWBo/ZNcPPm45GssBZyirz5mZ+01Fx8wbxQE3Re+lwQCZnq/qkqL4B9BrAsI78vV6rPbiJgo3MCpMplZKXQhKPvV2qSuYBgW466FZd77kOlOvBjkZs5TmhLqicLDjZO1K025YpLBFfcsuTBu0/GIFLxWwcegvA5O+0XwUmdnooUBuMg+fpBrc98+kwgrehhKffSaFEDcux1qvdz6cbWxLsNaFDixkURNp0MG1V6TjjH2m9yb8rCaopMnRNR7IXwnq6ERWVscMT1vQImyq5SSpzRx7xZet4mSkB10oX4lzT3MciAdCFEqbNUshoNBSsFEqucSaT7z5ShHZvUhIX403A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svzcsAcPURNMvNzUrcJqS1csKa8sqow9qtq28cPI8dA=;
 b=PZa0cKDG8LaLnpYhWTU3IJOAhiXDcsO1WN+tKo7gcdOFofa+mybhIZKCh2sdfXpSplZPxtRiciUbdCmrjFS8NDmSjArrn3PjMHIXMAqFwFt4bgQ43T70cCwwBzSlo1v+vqqFmC6IKeuwKHwjcVXIYVIqRBbRfHw2HG/2Q14bXmmQQl3ia+rL5zY9Y0DfWIw3uaGPNLGpv9me2U3w0tZ1LA5/rx4DJZC0iIPAA8xVQM9d4CggCqLsytrG95Igxbo+DKZzbBNoCjdN73OEfw/VjzzUieszEifrOrqOLzB4ZC18cUEYBIUhkQUlc1tL6ZhTSK+egSUXL1xulzKoQdwhLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:16 +0000
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
Subject: [PATCH v2 17/23] iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()
Date: Fri, 14 Feb 2025 13:07:50 -0400
Message-ID: <17-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013DFA.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:d) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 942f1c51-192c-4877-0a3e-08dd4d1a238c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rCrdom5Znt9/iY6UAI9gckQszFlWN6VaeoVLGxp5bZmK6D2X18GG6JmU55f1?=
 =?us-ascii?Q?vrghYniOiIGM70UN2h7L4iXlvUzJEW8JAFXaA+Q6BSxNAEIf0/WKeKtzrfhK?=
 =?us-ascii?Q?IAJpA8W2W/2Xvj015RRHDZfTWRzIMdef2Qa7RJnkXl5YHTofFmR4zGmIEkrz?=
 =?us-ascii?Q?EhQ8tQRxli0x60gy3ROt3LHlr1bCcr5uMtmT7/CPomKD2Fo5NIIXUu9sl/+x?=
 =?us-ascii?Q?ZrNsvkXkJnVtHtUGTydr+gHaIKjcYqrMM7tKOfdhdzO2p119a+UA4FYQzbyv?=
 =?us-ascii?Q?NA5fY/ERyYPMZkLs6M1wiJw6+NAsFmpW4csAqSDfeyQ1Z5/fXWud5Niq1MGY?=
 =?us-ascii?Q?EUjx6CnHZKpAbIDPT4vOamzKi18vBOE0MER6LVtwyGmjSH277I6EqTJeqEuk?=
 =?us-ascii?Q?ZgGP5j7UgdqLgTg3lYdRnXTivREXREqmAtaK0wLZgqO5JGSTye09k0PiZA/4?=
 =?us-ascii?Q?+NsgJs78X1wgkZ6x4DkckU3ADIifawObdTysseQyBC7Tyy6/3wxyiJMIYBU/?=
 =?us-ascii?Q?LkapFLe1YRQkSyosl4ORfVFl99Qu1kDojVo0FR070daPwN7SiTzaOIqftjsc?=
 =?us-ascii?Q?DreClNNd6v3tGBIq/Q1RfZgg4IS6hW+FWd6Vd5f1coYQptAPjIq8JW2F1flb?=
 =?us-ascii?Q?9opx4sNbWLjx5Uq64f85lcAISN4MUYahXt+KgnVLzJtI36lzBP2uUePvr2cI?=
 =?us-ascii?Q?aLpTetW4fUrHen1orvCgIh0QMYoylfjCXSBs+EN5uYyT/k6Fbc97WIUqCXrz?=
 =?us-ascii?Q?iuBmHwzG6l89QL542XsaY7kKXpoZ3WecQV30oAiY/TmiSc1W9HOnRKF1+sC4?=
 =?us-ascii?Q?CdZujpQGdROM6TaNoDG3caH38O1EduRtRhXgLS0fIcVYxLHKJxgDMTUDMwe/?=
 =?us-ascii?Q?NUV/ZaQESOqUdYt/7lOZSJioNvn1bcnQ4QlChs9RxTnCwR0QXfqIj86ECicn?=
 =?us-ascii?Q?pKLbDonxDh3Rv4tcC37860q0UHjaFVZ7HxrekFIOpZccTQ2B8yqdLNx7sUjw?=
 =?us-ascii?Q?LsxjprBYCdfHdd4qUnv+6WeArITj2RAp/2Zu/JddovrICiyi3DMxC75gVoeM?=
 =?us-ascii?Q?Ey7aP6QURpJouFnfKW0n+G/A3H7K317uHabHPZXj61D6EFOfs/zzqu8RW1Js?=
 =?us-ascii?Q?+zSWJZZFt+28i3GYS1BwCxsTcR+myUyPRMtWDNBDjvtX8Y1vp+U7KCkOKOyZ?=
 =?us-ascii?Q?0/SH0UztIXSEOhl2K4mwAsgttZ0q/YnK6IaBBGdFSVXIOQ0yYkUzW7Rd/hNr?=
 =?us-ascii?Q?BFjnOIME/qA0GAl3HoB5IBGr0pmM6h/9zCaU8pXZSPaymfTIYihArF02MVfN?=
 =?us-ascii?Q?i0EhTRPRf6PLtYs9DQoJctwcAg2d6lbgdbwYjZlF6Guw4U3Iy+H4KsedhAvZ?=
 =?us-ascii?Q?ATq/Y4wgf8kYmK8gGfrRmwKsgnhey/Ido1L01Hnf3yL1SsbYT+dhUhrVm/HX?=
 =?us-ascii?Q?yigp1HBSRAI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P4TsEv0ceTBq1CfzEkeMd6G0G4XhSCjT8ZPt6sansojS44bx/CBA2inRhnfq?=
 =?us-ascii?Q?K4SWYrJ4Tr9+GscaXY6TPQuYyNkKk1THmq2u8maGrSxw14GvClM1/08wJRjb?=
 =?us-ascii?Q?FR+kquMSCPQkk8tNd/pj0ADFwJM149R9Hd+I/oDZ+MRXQAmZhVxi/HtWa23/?=
 =?us-ascii?Q?8dCtiuAbpqY8M2BLuKLLKRzraDjeKWV4F46iXjENEzyJYu9BbQSrjo+7Wa+J?=
 =?us-ascii?Q?qOhOp0/FDxZo300jRx8l4g3FTi29ong2v5jc00g881Hjp5YRmcWZ8IIheEzX?=
 =?us-ascii?Q?shcqCVonGpgPuRc47dVZW5+9J/0f+Ho+Rq8WW3oRTAGQFUq+RowwylJjNMc1?=
 =?us-ascii?Q?ReKcfp7eV+u5SxutnqsCGxZqeXRW3Vdjw+YV64tntSRXGZhT2vd3tAImIslS?=
 =?us-ascii?Q?6JL6bTGfYgqp7HdIJihV0Of7eGZzxlFfkq36dP9BxLiTYD/++5BcC9WPVKg9?=
 =?us-ascii?Q?tN0Qr0qw8u7CPS9Qygc0hRHFJw7OOk0VBxrA4A3Z9/u5gYq9elW+c4jTcFpm?=
 =?us-ascii?Q?2zcCW2QfC9t8mS4Ay2jGESXiEBMRd8gP5/hXZGV1pRPa9Fm0AL4X2V4G1AtG?=
 =?us-ascii?Q?E9X8Jl5sntaha6ij5ouc/e/eE0evQpKjuQH5FLtd3eNai2Cy4OCE0Gd9y869?=
 =?us-ascii?Q?nwQyMOGed+7EmpoSGOWsVR4uVA/InlwAa7SJvIpkfTiNif6tLiEOTmOMJKu8?=
 =?us-ascii?Q?RJPB12h3aObxFTy2eGDNsgvhm2AGr18P0qSXYS5yCf3FhwwipDvM9UJ3JUY6?=
 =?us-ascii?Q?pfFadZF3a1kM7gREkiX3IneDzaBHJ7xnRshpMFL1Ain81vWxTmB6VPJZAkGL?=
 =?us-ascii?Q?DUlZvdHmxsTDJS+OCyIkSvBTEqwl08x8jIkzYPudtPWGKhK6DoqZESvVooeT?=
 =?us-ascii?Q?Tjjch6RapxxQiQ6iewA8aXbp2rpKOTocTJaM6C6lextsx8hLRFbt/u0s1tm6?=
 =?us-ascii?Q?vqnGA8s2N7b6gw3jJbDBLEWs9uJSYQTJvEh8FPvV3edzTVoLZcRfH52/yAv+?=
 =?us-ascii?Q?AkUQA+FxL/2+VFJ3mGYUU+445EgzyDaFeZcqXsSmdtBv5u5KlvLhSA7stloI?=
 =?us-ascii?Q?AzD9XdKasDbF0r0/bxqo82yZlq9yp5itpXY75pZdPjk14Loli9fvSP7Tgiw7?=
 =?us-ascii?Q?AyNynyExVH6n1FrBRrNP1KumvZnyUDk6F0j7IlHECfJqB7mSKFtvZdkrCTVz?=
 =?us-ascii?Q?u+vh2dtmp+l/xKCP6RsRQNSjURlzFKoB8WB6E9dr+xqG3uGo47+SYnZ4tDo2?=
 =?us-ascii?Q?Mwl2xyGoz//OMEcHtTGITw+feh0XxMNruuS6nqzLRgRarTa0iB54gJL63MAF?=
 =?us-ascii?Q?kEMbojJiZKaH0wlyRR1oLwia7valnCFGcSIg7pFu7KZZ9pEWdCF1UrTWAWJU?=
 =?us-ascii?Q?hZBFrCQmeoHUhdi6LG0obWk9sXrl+PAoT/P/tX+SUeVP7kVwHdUqUE4yLPRp?=
 =?us-ascii?Q?NfbNTodpA6RuwkHctuowqswYq+OLLL+jjJOIf5nbCgScUhR5j3INocif5bUn?=
 =?us-ascii?Q?8Rszo+ZDZi0yo8dI/Vx8wHvJRJoJ6I/ye1PICyppi9jVGPLYKMkW/62zNitv?=
 =?us-ascii?Q?AjmIh5nGz0NxK44WVig=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942f1c51-192c-4877-0a3e-08dd4d1a238c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:01.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tnr9QKSDM3wD8uqI3TtK0Zmco36YQxEM16tUDt4sZ81x2kHu75+cJhVfLBdQ0wAD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

This is just CPU memory used by the driver to track things, it doesn't
need to use iommu-pages. All of them are indexed by devid and devid is
bounded by pci_seg->last_bdf or we are already out of bounds on the page
allocation.

Switch them to use some version of kvmalloc_array() and drop the now
unused constants and remove the tbl_size() round up to PAGE_SIZE multiples
logic.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  8 --------
 drivers/iommu/amd/init.c            | 26 ++++++++++++--------------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 0bbda60d3cdc7d..9704edf5cc26e0 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -29,8 +29,6 @@
  * some size calculation constants
  */
 #define DEV_TABLE_ENTRY_SIZE		32
-#define ALIAS_TABLE_ENTRY_SIZE		2
-#define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
@@ -613,12 +611,6 @@ struct amd_iommu_pci_seg {
 	/* Size of the device table */
 	u32 dev_table_size;
 
-	/* Size of the alias table */
-	u32 alias_table_size;
-
-	/* Size of the rlookup table */
-	u32 rlookup_table_size;
-
 	/*
 	 * device table virtual address
 	 *
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 73ebcb958ad864..fb3c3d17efc167 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -660,8 +660,9 @@ static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 /* Allocate per PCI segment IOMMU rlookup table. */
 static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->rlookup_table = iommu_alloc_pages(GFP_KERNEL,
-						   get_order(pci_seg->rlookup_table_size));
+	pci_seg->rlookup_table = kvcalloc(pci_seg->last_bdf + 1,
+					  sizeof(*pci_seg->rlookup_table),
+					  GFP_KERNEL);
 	if (pci_seg->rlookup_table == NULL)
 		return -ENOMEM;
 
@@ -670,16 +671,15 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->rlookup_table);
+	kvfree(pci_seg->rlookup_table);
 	pci_seg->rlookup_table = NULL;
 }
 
 static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->irq_lookup_table = iommu_alloc_pages(GFP_KERNEL,
-						      get_order(pci_seg->rlookup_table_size));
-	kmemleak_alloc(pci_seg->irq_lookup_table,
-		       pci_seg->rlookup_table_size, 1, GFP_KERNEL);
+	pci_seg->irq_lookup_table = kvcalloc(pci_seg->last_bdf + 1,
+					     sizeof(*pci_seg->irq_lookup_table),
+					     GFP_KERNEL);
 	if (pci_seg->irq_lookup_table == NULL)
 		return -ENOMEM;
 
@@ -688,8 +688,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table);
+	kvfree(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -697,8 +696,9 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	int i;
 
-	pci_seg->alias_table = iommu_alloc_pages(GFP_KERNEL,
-						 get_order(pci_seg->alias_table_size));
+	pci_seg->alias_table = kvmalloc_array(pci_seg->last_bdf + 1,
+					      sizeof(*pci_seg->alias_table),
+					      GFP_KERNEL);
 	if (!pci_seg->alias_table)
 		return -ENOMEM;
 
@@ -713,7 +713,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table);
+	kvfree(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -1604,8 +1604,6 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
 	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
-	pci_seg->alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE, last_bdf);
-	pci_seg->rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE, last_bdf);
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);
-- 
2.43.0

