Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AD4218593;
	Tue,  4 Feb 2025 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694117; cv=fail; b=W73EkHhl+o5Q1nKgjyD1/BlIyHRfiOevi0pRf+c4kGjJCv3Pxb9RFpDu86C5aLMHGDoq2yQeBCGUwkyBI6JMGpBJMCdhjolmeiLP8DztTXFZ2vUIqcuL2fn31wuU6RjXesg4DtMD24Nseh+sPyVmnLZuwvPd6YUmE+XtaWqcVzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694117; c=relaxed/simple;
	bh=iK5SaVxlqxpEzROoEkdr2jeUz00E5cb1jDmQDDjasAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rX4jsb4niOwqW2FSWifRaNUk6Uzo3v3pBDJyQB495JdmyiiRGmEeuEwDxLvodO3VayeqFdrFVFKd2tbY7J6uhb+sRy4iHEVaT5rrxXVEeAXW0/UljI5gRT2Zl0MW3UbqNXedVmmlshYPIw+fbqPMQhpbk6uLaCRz19xJp/j7Spo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kNkGqHY3; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kNkGqHY3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dQKM+jxAngdr8F+4AKhrtynNvMp0PV5Pyi8hj54j4thlKLCzqlq+E5HSxWOtC4zyXmO7uQ7V3PyGayTOoJ46yXnsB1/NgUHYa2IIWJozhXOIjg8q3mfgI9fN4kzDxrML8xavsfqXlofqfH9AzfAOeE/KwA+zatF56T2YgO/S5m/qfDUAJSLWQd2oLxUKf6/JwCwqLjMlZR0GCndgXUKEAi/wOvFBBZqECmb6YIaWO6QEeRnJBof1OF1HRr/PerFB/vo311erl/B1A307BBFOxZODy+xQyV+Ptu85LDsfvJwbJWw/ZSQfmtAiK2AnXukAibyjzgwFCkNI1qPMDwj73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INTe+wkLi0WgOFJFM1w0rmUWKF1EUxHFfqCmW19iiCs=;
 b=Cibw1AF50Hc5Uglc/SdMW+5kNTCXdcClKM2H95e98k/eL/FmRRCBoaz6uCXZKEHRmRQmwDPEu64UgNBAold4TNNefKubpzDoOFcG2++uEc6h67VhsmB72KZGIBduCgdn1BRJa4YHwh2nQfJpbuqBF9fjkuXRClzOQy+q1P4m5+kA+x6bYwYFHfCR67MKqcBwG66PENpA/PutBkUl4IQ1W+05vgL5/Qg/OBOvHnF0E8kJOEWy13Zon0RAPuk6LRs6fKHrgm3jmT21Bw1qds5GFeMmO1hl9OIxgpDZZYAQuVQ5jWcKtH+qLJ4RtYgcYL8hyflNWc4mEzfF8X5dGbz8KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INTe+wkLi0WgOFJFM1w0rmUWKF1EUxHFfqCmW19iiCs=;
 b=kNkGqHY3vNPLb/KpfJ7YFBsvkyd/zkpGIDZqRSbyV5kf+u7pcMKRbH1ICGLRM394a01Xt9LMIXWEiOifwteR2kjz0rU68egbu5VdmvOxVr2yvhyvBMFwtwkQWC4JzOYZEddcfP8B1Kz/GmyJikPBFFhmkEjoyiK5i8r4ihyO3aI1hhGZhR/yH7akvf07M1mfI/16dnmzVyg1kY+bLGP41KCYRJRcxcrzlByEqCPpxxP1pEmhQl9bAshXWuB1iuVNla7YKWiLg0nahdhxxM7wd7dC4Z5rsEa2NXeMB6tvibVNSZVfP0t5x3CzRzEt7+2US5wL1U/pVhw+k6pSavUGeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8226.namprd12.prod.outlook.com (2603:10b6:208:403::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:10 +0000
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
Subject: [PATCH 19/19] iommu/pages: Remove iommu_alloc_page/pages()
Date: Tue,  4 Feb 2025 14:35:00 -0400
Message-ID: <19-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:91::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a08e336-3029-4cb1-3390-08dd454aa46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Uyya/CMgnqDUVsXojQeSJtDTc+48SS9H4TZQKLFVB9rPtTOSV3BnlarXD+cQ?=
 =?us-ascii?Q?pNchMj5Gpxd8sENF3oyk52ZnXEBP94Fz91uXYHh3rJArgnpI+sqZMNs5Fjyq?=
 =?us-ascii?Q?KiEMDRp2ra/ytp4kZisq2QY3cGY4U+Jw7rjRUIVkBVLwS2wU47arG+VgbOrL?=
 =?us-ascii?Q?uwgiDqBUtEPKIVYms1fg8i7pe1zpujgfQBeqPvnIzjq4ET0UwSHEeCVIUV1I?=
 =?us-ascii?Q?crRb0FyI2jLNFXTTIqV583xLmmHim6JwOQWmZMwNxYoIDCXFNxiJAlUKC8Ga?=
 =?us-ascii?Q?sUG8HQ7RMj4FeNL+jJ7KjVYppMemdCsMQxxT/IcuLjBF5QFKrFQjX8ETVDf8?=
 =?us-ascii?Q?WpeKkHXCsDdAOdZChs6e05vBXuQmS+4CITxSJR/MKhWX4owvT8MvdhfDcpou?=
 =?us-ascii?Q?oaNnimKpUCrOs5TWDWEAoBCbH8gdq1WnDVSloyGyBqpsApxlvaOIXOa5VcGq?=
 =?us-ascii?Q?NNlUFYBwXv9Ud+NedLVPlE+duvXdl3LbDGPFC+zPXm/rsvRiMo/XVql9uAW9?=
 =?us-ascii?Q?0UbwGXY5wWCxpIYzO1ALBSVsRSBHDBHRhBFXJadAGsLIwczHJ+Q3vPXOU1tA?=
 =?us-ascii?Q?qZbxu6aom5iEexXa+1CKrHkA5sqyQMdjo0OTnj2XfAl1joGKPUf0lu4lkI2r?=
 =?us-ascii?Q?1Q9Mxurvo3Yo7P934MTcPA/MYmSv9Lo25tpF/wmnlKLlOrjGUrlYfWD9SfDE?=
 =?us-ascii?Q?I9sExlWy4tbekRhaYK7+24QFY85d9w10yvpFL4RYlGeeDaz2xKkA9IBH4tHQ?=
 =?us-ascii?Q?BTcf0IFujyZkW5Xu0Vw5GjbY1t5amXp7jPjdQev8QfC3i1q4F9EewwoxZ3tp?=
 =?us-ascii?Q?/9yr/kRb2Zcans8Yq8rI0KUSzszJrq7UjFKqAdGO78XcFhJaZRG9G1Us6gYR?=
 =?us-ascii?Q?JG+ZiHEcer88bUQcPr677kPp7nkS4mmYseJzQS0RY3siIaMEDgtbKT6WtS/J?=
 =?us-ascii?Q?LTqVE7oESBKsrBsysz/7pux5S2iodNxrdwg3i2tnGyAdPM5nHZ3voZBUTudR?=
 =?us-ascii?Q?2vXa4jx2PTpLbkmxGd/c51btjrxwOg4oOKOq5ggLVzzCfg7IRyf9J6O1kZAk?=
 =?us-ascii?Q?6JZsLKJ307CGLO/0cHObKSBbvVrnPEcewOINMe8JalZ9vog3CSxhxxbivqFt?=
 =?us-ascii?Q?VCzGF6gXZUS+S1dEpM4QLXfSu553tsWulzBpKoz0U8dvffqS/W7CGfpxL9R2?=
 =?us-ascii?Q?JoNgc/Bb0eU/c7+/9hKFcfcKkpzSXmZ52oC/vlBcaWnjhiJiRS7Uioo45NYm?=
 =?us-ascii?Q?95kPc+N8qi1H8QAobiou+4HEpPqkyLW1zyWVow4hWiHfzi6Zihllyk77hCYd?=
 =?us-ascii?Q?7fIcZkEYp2W+zeFO69a8q3WU4WG5US28V8xEmZ0c7NNpEDpC580NPCwq3/JL?=
 =?us-ascii?Q?kAKyWLNrfmrntxIDYcdwxNw1eelnyPCoJyomdaZKHWfIsjFl5oLRMtzioAnf?=
 =?us-ascii?Q?5Cg1AIrnkUQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1QrjTCcLy1pykNQEHko47Hi4E77jCgeuzpFNjm9f3Wg4JHPyUCvxAMlC+j1c?=
 =?us-ascii?Q?cRAg//GJG3rV5FP72y0YHBjXq0LNGEi28cARuqQbBe4O/0uTs52qt8ljBi86?=
 =?us-ascii?Q?7hacvWUofdg2Jyz8S0UJM89XONKzxdINNdiZLvj7wbJ03EiRABh8VAZPRK02?=
 =?us-ascii?Q?UCVSfe3ye9shbBaOykoECdYG6+EScm5rpIuGOWjNHdsMri2Ro8r5Wm7CNrOc?=
 =?us-ascii?Q?nts8GmPXuCNYKr3y57Sc0TU6zGHOkYNXRJCnxO2y1nv6ztOrYuzOGXahldm+?=
 =?us-ascii?Q?6OHWFiakzAVq911c6B1CMTNj0JXUBX6LQrUsW2m73XrH1KSmHP913UXblmX/?=
 =?us-ascii?Q?tRgGOK8dg289kO/O/N+C3OeYtjvdJT+x2y8KOWNlqaVQr5scGqROy0F3Ofds?=
 =?us-ascii?Q?RK5IjNeRzrbgnR20kJrFO4GIW2p7ldjjr1G6dn2XFiw7AYz2Ub0HzFQujfct?=
 =?us-ascii?Q?Au+wUDjlyUJAsrTSSCOsQ7xbCO8cmo6BcrlI0ZuLZJmgfLl9KA/5no6jq3iI?=
 =?us-ascii?Q?SYJ+40emfHdr5pS6PzwFnzV6ZPWKcByJJY6hXHLoB1CTT+PS6AafTU8YykQ/?=
 =?us-ascii?Q?F0S00c+VNA34Jr9dD2MjWxAyZpTyy4plelSV5kczmbYaOEYy7HHAMfCEVkKw?=
 =?us-ascii?Q?3AI/jY4iM90FOKKWzJjtAP1vAgW63pyY4poDZDmpIVcCkxFgrO3oHY1ttsZE?=
 =?us-ascii?Q?dIW99mrNzJ/qzMK6LZDMpxBCNwOaxHd6QakJJbRDMGLeJbvIMM5E2RZ3ak78?=
 =?us-ascii?Q?i6yLDaMEf/Cbr66u1fRGDop6DxhbE5YsKvZ3SiwnprX6L0QJtMD/jr8Z7c6K?=
 =?us-ascii?Q?ydm7t9o4+AX6tTGFaD201jLJK1Hx8OHjg/opj1x4zmPg0dupA4/ZJ7jxf3xS?=
 =?us-ascii?Q?4g70jFhtZ0ASNQyUwoM0IcxJI/px+0HzbBuLm/Ld1+na5uSfLqvu97eCkzJT?=
 =?us-ascii?Q?AoiebXLUnTIej6AoPRxeP9ArK8s39pn6S5nN4B0TqH4Lv+0ZxAyyyG4Behsa?=
 =?us-ascii?Q?u/vup2NmM1dW4H+0rmIqORJpc4iz4iqgvQzODSotZD6ptz7kJ9TwXXbp5Ubb?=
 =?us-ascii?Q?Mde5TUh8oT3Y60bd6rujOxkOJ+Mi98CskKsETuxbWjlOl3gBXrSzGtm71Sma?=
 =?us-ascii?Q?dubQD9fJfqSSZsRE7e6Qky7uAr8t0KiA5BvB6szWNXJv10oNlr9Mf8h7T11M?=
 =?us-ascii?Q?Sha0OgK1qCi0OsZAKKnUxG49JIqq2SaEC/5HK+oqbxFfpMO6g3pFd1KE8r3J?=
 =?us-ascii?Q?6Ka2wQKPnsyRtimTUqoI50/4x0qLdBnvjQYC6VknFCXa6ruEKPcLw50cegX4?=
 =?us-ascii?Q?K7RlFlVqZhaoqlKmxEgwi0Jxnq3E0PF8MgVdTyIZBM9IvAVkJi5i+eGXol61?=
 =?us-ascii?Q?R9WYA8QUJRVrou0iMuIcTWvfSrJ6oDT560iRTjeirD6w3XjCdrcBjlPzSEBV?=
 =?us-ascii?Q?IuSVq3uHgiybpFzXc6S82gR1yVIOdIQKM1W6avT0QViK72ZyA/BLwLSp2sgI?=
 =?us-ascii?Q?/BRLfyWR/vtuEijKB9JSsW1p3I26bLynpprRNM6rlzHB/nQ33JZivROtJKwg?=
 =?us-ascii?Q?itZeamZUxTTC4mlUv8o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a08e336-3029-4cb1-3390-08dd454aa46f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:04.7192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9m/0D5zVMPUK7SGW/vNvzMKZP/ofn86n1VUMeMsUQBLFqEW246p2OE8TFBHCXgXJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8226

A few small changes to the remaining drivers using these will allow
them to be removed:

- Exynos wants to allocate fixed 16K/8K allocations
- Rockchip already has a define SPAGE_SIZE which is used by the
  dma_map immediately following, using SPAGE_ORDER which is a lg2size
- tegra has size constants already for its two allocations

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/exynos-iommu.c   |  4 ++--
 drivers/iommu/iommu-pages.h    | 26 --------------------------
 drivers/iommu/rockchip-iommu.c |  6 ++++--
 drivers/iommu/tegra-smmu.c     |  4 ++--
 4 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 3c64fcdde6d294..70d36c35b17421 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -902,11 +902,11 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	if (!domain)
 		return NULL;
 
-	domain->pgtable = iommu_alloc_pages(GFP_KERNEL, 2);
+	domain->pgtable = iommu_alloc_pages_sz(GFP_KERNEL, SZ_16K);
 	if (!domain->pgtable)
 		goto err_pgtable;
 
-	domain->lv2entcnt = iommu_alloc_pages(GFP_KERNEL, 1);
+	domain->lv2entcnt = iommu_alloc_pages_sz(GFP_KERNEL, SZ_8K);
 	if (!domain->lv2entcnt)
 		goto err_counter;
 
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 84140dedb8cc4a..edc0b1a62b6494 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -114,20 +114,6 @@ static inline void *iommu_alloc_pages_lg2(gfp_t gfp, unsigned int lg2sz)
 	return iommu_alloc_pages_node_lg2(numa_node_id(), gfp, lg2sz);
 }
 
-/**
- * iommu_alloc_pages - allocate a zeroed page of a given order
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_lg2()
- */
-static inline void *iommu_alloc_pages(gfp_t gfp, int order)
-{
-	return iommu_alloc_pages_node_lg2(numa_node_id(), gfp,
-					  order + PAGE_SHIFT);
-}
-
 /**
  * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
  *                          specific NUMA node
@@ -156,16 +142,4 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
 	return iommu_alloc_pages_node_lg2(nid, gfp, PAGE_SHIFT);
 }
 
-/**
- * iommu_alloc_page - allocate a zeroed page
- * @gfp: buddy allocator flags
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_lg2()
- */
-static inline void *iommu_alloc_page(gfp_t gfp)
-{
-	return iommu_alloc_pages_node_lg2(numa_node_id(), gfp, PAGE_SHIFT);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 323cc665c35703..dbb61ca9b7605d 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -730,7 +730,8 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	if (rk_dte_is_pt_valid(dte))
 		goto done;
 
-	page_table = iommu_alloc_page(GFP_ATOMIC | rk_ops->gfp_flags);
+	page_table = iommu_alloc_pages_lg2(GFP_ATOMIC | rk_ops->gfp_flags,
+					   SPAGE_ORDER);
 	if (!page_table)
 		return ERR_PTR(-ENOMEM);
 
@@ -1064,7 +1065,8 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	 * Each level1 (dt) and level2 (pt) table has 1024 4-byte entries.
 	 * Allocate one 4 KiB page for each table.
 	 */
-	rk_domain->dt = iommu_alloc_page(GFP_KERNEL | rk_ops->gfp_flags);
+	rk_domain->dt = iommu_alloc_pages_lg2(GFP_KERNEL | rk_ops->gfp_flags,
+					      SPAGE_ORDER);
 	if (!rk_domain->dt)
 		goto err_free_domain;
 
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 1e85141c80548d..7e15028f948511 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -290,7 +290,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
+	as->pd = iommu_alloc_pages_sz(GFP_KERNEL | __GFP_DMA, SMMU_SIZE_PD);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -689,7 +689,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	pt = iommu_alloc_page(gfp | __GFP_DMA);
+	pt = iommu_alloc_pages_sz(gfp | __GFP_DMA, SMMU_SIZE_PT);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
-- 
2.43.0

