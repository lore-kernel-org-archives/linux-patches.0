Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C5267F46;
	Fri, 14 Feb 2025 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552907; cv=fail; b=rHadb1NGxGZrqv5nPhkwswfEoATK8d5rJHcohr1oj1OMIlLhcjDf5tTTyN4PiixLE18epdFULZ81QeMHh6us83bWtJbXUFxZpgCXaI5cd9p2kQatosboq2aPUu0xKw7ku3iNPk8C5EsFGhrQQQ1OQ0VePUutu+21+aRBw6eH/ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552907; c=relaxed/simple;
	bh=9U4lyEYxK3G3ozRYMASfjKcpRp5XNXvDU2PcqKcl5D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WODhWCRAe9yFRK+BN9xLcNMianY9pLHoQcI5Q3toUj69emxwNaIzw3Ox+9d0lucQ+RZ3Fh8bhVbD9Tlsp7eyrMpvKBMa5G3mLM8khFno3rObmyHGLXQFCBRhIZxr9uLZtvYNQszJpx8faLqpF/AuAlWhusVZOd8Ne+vtc4/Ex6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q0lxHI4I; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q0lxHI4I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQrNMQhKlOcAdI6NZG3lp5ucbRYtTippz4J4UPsPBaEKIGv5/MJUwI/39FIxmoIuYuo9A0j3G9J9kBPLU1JYfzCBSOrnHXbQTazUQB3bLeC4vXv/753aHby5cxf6WzHLtcbgxr9i3RCDhRL4oSAG9xn7hE04C+ToZpjNNKGvkkk5j4ac5cmbQR4IDHhrZVPzhJciYjX2TKQyKkwkl3lLx1b0nBHLCI4VVHw76O1PWP7jJWFje7sNYyiN2D27Dki0IPaL0UsSdxyz/QhTsN+mxctKPjPF94lMgtKQEnoUEjbgXXK8a7pXHrlN2+hmmL6TxlNU+YvhNtzmwpfFtXK6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHUIS8H7lCmGJIfDNmokPOsO+9kIuB4pJL9MpdOoQy4=;
 b=U6BTneQHtECXXZ3mM1hJ6FpGZtG7d6nibM0yTacWmeiEnf5SSv3xBpNJfQ0IM0S4KrIxMfF6snMLqv135nMXlhfzCDEbCChROqA2/JhZBvM8wiSjY0DqS7e5YE5JhKnXSlPFDL4TkPztxXNS8xeI/2dsMvrEzVM0pcIwAkZCLjFSB6YzkI4T+YweQSmSC3VDo4CvpkfbZnbiUS9svotLeaqgcUzDxGeiiEu+p846r6MkG0p8Jb0m86t7AIAUTTNgZypMeUtalwkk84B9GkuO243G/3E4T9dTjfZAhDutyZ3z8ofiw3sb6OOsRpchbsejwMTbi54jYZ6R1uXs1yG/GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHUIS8H7lCmGJIfDNmokPOsO+9kIuB4pJL9MpdOoQy4=;
 b=Q0lxHI4IaOEHoqlnxg1MMO5RrP8nzjCBmJpjWv4soW1pTX/pJ4Uj5brnob+48gC23zjEQkYgMrH2TCGByespUU8w94P1V6XPw6j2RowCYqDm0prpTMHrGbbREc1QiiWMs4pWaBiIkhhK5QRp4G1bBTikbCcVNJk8R+G5sdUy+IGQ50M1x7IvDDv/NgMu63GP1yf7trWdpr6c9/ueBmQeoCmns7rSgYfrnrhYeaBchzSF5HqPyQpq3HXj52hWT4JmQkwaisk8iUyLmxT3SkSSLf2fpvdWF7r56fUH1aHHrgnAh2G/HLZMYhbPHejnPYtOlAeEY35EpwX/tm9MN/i/Ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:12 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:12 +0000
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
Subject: [PATCH v2 21/23] iommu/pages: Remove iommu_alloc_page/pages()
Date: Fri, 14 Feb 2025 13:07:54 -0400
Message-ID: <21-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:208:23e::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7316f2-1550-462e-61bf-08dd4d1a22e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nOcjcvkvhCUTl6k29tvegDTWJ81m02/uUVcVlONzYwKlql5tPTTqOgG6QkDO?=
 =?us-ascii?Q?i2MS4NP87f4upzNPHiYJQf6Xe5Iz0ieY16vR883hb+SjvWE/EvfE8AJDgp1z?=
 =?us-ascii?Q?+grDEPpv0Fzaeqyl8styjeI6hp5vmG2TePxpgfjX3JnwMMka26ev/JXZkFJR?=
 =?us-ascii?Q?AFDru9OoiX6ECU5zI7X28gXBmqR7MxK7DRE0UrJU2WlJ6zVXbWQo73UY2/Yl?=
 =?us-ascii?Q?y/AMkqFkozjfYsW04TFe1LCEWQZZ0is7xatL/efEVF5MGxKH4Zq6tPtsyVcV?=
 =?us-ascii?Q?SaCtC+vl8l7UD9ltJQPgIK3441Jm6UtEEoRLEj0Ii5lEPqQiQU2pDkLctqws?=
 =?us-ascii?Q?aZbsaCwILRnKV+1bkpfLkYqWJGpj6VrXaOeBxibeUYDsOVPa4PFMlyPycHFE?=
 =?us-ascii?Q?XvZl+p/Y9oLICBNFg4dZNnCqlUNEU/lz0Pn+IbFKesv1R/YRzGcuiLVgECoe?=
 =?us-ascii?Q?MBKvwyobzLX+3jf0VZ8xHr2toOdIdsesO1XSVkTXqd54wDrMn09kowEbboX2?=
 =?us-ascii?Q?FUUzucAySLlFl14zf6af9A37TJpVykjsUzif1/tysIY8h2OwEDgeZ20jDw4x?=
 =?us-ascii?Q?L+QaUo90May2IE1B4Rn0E+abonjxnwsZ3WkJU48wT0oCzBkzymjYbB0y69ba?=
 =?us-ascii?Q?LfWvrv/3ZyUTyPrlYX8oT11908BgjkQTyUOlT5iRwKSsQPUkrHAkaS9wUPz3?=
 =?us-ascii?Q?RJyS/foCn+oW35BlByJA0Ohvtc5shqY24bhT84nNsNSakC7RokGdgvjqzeGu?=
 =?us-ascii?Q?1Qj0pDu9z+kmOBRDWlvvabVcQeek23DJMrzw5/Z2T2D0eWOEIc9Fuj2j/CWC?=
 =?us-ascii?Q?WxJXiFeg1TRfhG8Zgu1A8fnmebFtK0kh0TURHxjycfp8brBrLzvKxnZHiza6?=
 =?us-ascii?Q?gruWNDKi5/QJRPEP95prImhDFqaZfgOwKJRndvuHJhrZDADL71wMfarU8wZh?=
 =?us-ascii?Q?d2qIijwwwggCd0XGibYmty/d6oMbXwC3KNr0MYQ/SgKBeo6ZIKu2wPAbguFp?=
 =?us-ascii?Q?aVLFLApQ9Y/nd9xXvD2z04ZLAF4FBdlTecgW79d98k1NhSRhLAK12sIHACQR?=
 =?us-ascii?Q?+dLWsSdL5YA4lal+2y4hd4vLFF+I9wdSqYhMQKBOFFbjfMXzsgnVQqoeVrxo?=
 =?us-ascii?Q?e0HTbH4kjRwBd4qnmeVZJrl1jIITtAndzaTpU4PLfYHpx1crNLTsIIAXvUKQ?=
 =?us-ascii?Q?UiB/wiY8llNTJ+ZbjU7e6bySFiRDbzJeTq5L5+eDMiyuRdalCjcdSsOrP6RG?=
 =?us-ascii?Q?5dn9wEbvgAKS0vfWTnVe+TmyvRRmvQRvfT121DPRgFiKQl8vCB3TzpDxa4mY?=
 =?us-ascii?Q?OOwD2XVo8YglrkMNYu56bYjYOr1RmVKgJg4P/o6svqlUENaUUD6SCnmZpJXO?=
 =?us-ascii?Q?4xoRY1hP8mIs2i8oiW9vd/mhRArZfQ9hHBy5gPva+AToxJJIVmdanHg2GLCz?=
 =?us-ascii?Q?fux5FhXzHXo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jTe6AhHlT76F4yXzaon9J/ItHTTZB1ic3VTg2SVIlf8OEo466EVh9jfgJx0M?=
 =?us-ascii?Q?Uw9e9Jlop1WDNvpZR9KuYDl9tDq7s4r/n1hnR3+o/DlKpEA3dzBmI5qr4ipW?=
 =?us-ascii?Q?GsbiB3+BksDnSbFthp+zP9g+6x449kTz/S3B09iChRZICbMkNyL437dMFsZ8?=
 =?us-ascii?Q?pRa+KQoEbQfBunlLFPywcDHqOQODkzmWoow06RlcG9NjGPasmdDoAYLbQnB7?=
 =?us-ascii?Q?Wmz199GxzOhb75mPU0EjU5dgjtuFc9bJqcJLF96wUJ0Bb8gNRzP7dxGK3N/F?=
 =?us-ascii?Q?dwRnlLLNYV7Ogc63pVwzQWu7T8+h+rTGbGyODic9pnBDhmuGgvH3rv2G123a?=
 =?us-ascii?Q?uz+OVXSqsUk8RjaQ40e684CCe5AB9H2gE5z16UeAVjVMOy+WcZ/Z64T9jc+i?=
 =?us-ascii?Q?azisfF2vzoXjqv4AIR08/0rQ1HDfZNqKrRRug6mKoluaL3gLDb7IUPi2VP/A?=
 =?us-ascii?Q?CkSImgkxrGIR++1SqFLXTJcq8m5gWhppTtKUNzKl44U8SXCJFt3iHJIe4L32?=
 =?us-ascii?Q?28Z02j6dGSCJ/08tDxqN8hcAsUm7JpohwEfP+sNhhWYNUy7TBAkPh9JUV7OW?=
 =?us-ascii?Q?+7sRzxIU208HPPmP6HF33JXSxwzY7pV5t4OKRpDNFm6m0C3HO4Pfspi3F57u?=
 =?us-ascii?Q?JZrrfJBRBfft2FIQ3BmAUuOrJi18mCLrdLsUHfWXfJaKtRNuP8k2QZvT50lp?=
 =?us-ascii?Q?2V8DRth7VjOVJDLT1K+Y4XJm6WBK9vAT3GhpPYcQXhQvLMUlA4mbI12Dn0cV?=
 =?us-ascii?Q?HBosRhlIGmCCOgCg4f3MpJ3Hz2F/gNV1gabZxZ8r+F8lpFg4ESy2gyzgc2se?=
 =?us-ascii?Q?FRdYrYODW8rSlPkQWwALoYIqkyNpQ7qrGPxXmh3AjueOMzNaN02KJOOHYK/R?=
 =?us-ascii?Q?0tIZnHDx812UdhBcDpyPOTqnYsZLQ9oVXz18Rt91XpCupnMPgaglFB+4dVd8?=
 =?us-ascii?Q?oBAygwLHr/uY4FJi2+usN6ub5Wmqya1r7IZu/GHofUFIQe0M5Aj/Zhw+QZ6X?=
 =?us-ascii?Q?JKZ8AfWpxslCjlyMVBITpN1D8SPUCiFNB1ZKHr8H5kzKv6imwB/dXz/UQatV?=
 =?us-ascii?Q?aOS+ClJhQfI2F/ee/5kqjaHTnXFz2QJ7kELleQ/7ZkI+HDgGJM7aaJ7E7qYs?=
 =?us-ascii?Q?paPKwjilZW5P14ULflPR++8ZrXdx5FvXDPLJKW61s2asimFCT+fm0rNeGmsL?=
 =?us-ascii?Q?kLYp+C5p+uIW0iE3k6IdsvIY/yq7TrVvN6B4ON0w4WkdYo3chnPC3nhXIVj3?=
 =?us-ascii?Q?vM154tk8yCRyYqfSo+GJKAur+uGK5Zn96hGmXobshBm+/LkANBPDaDN7L4/q?=
 =?us-ascii?Q?Tkq9thXZ6tcEtGW4MliPk63+i+f5EKpdJI2l1OahGaZZZxvYIxF+ZSCP5Ww5?=
 =?us-ascii?Q?ySurqF7mk2aNDyyvC97/tYyrbBwbxDlprIwLNqavQWKf6cxJk3sTST/wTkOQ?=
 =?us-ascii?Q?ta7wZfcsORIIM62oIqkGHq7HW7LH58CfqBaDBQ74bPyek37bLbvByBInPu3w?=
 =?us-ascii?Q?m1wDlp3KpA7WF27EDhokDasVzvqQ60Uc70AkuXumPL7z00IScGxZNOnhK5I1?=
 =?us-ascii?Q?nX5tGjgaLYII7o4DGN0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7316f2-1550-462e-61bf-08dd4d1a22e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:00.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4mMY+Q0Vav1PxheSzN8KEarlpkjYCyZmwb66dyCmYXWk6dYXw+p9a0zsVp4ocpk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

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
index 1019e08b43b71c..74337081278551 100644
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
index 3c4575d637da6d..4513fbc76260cd 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -100,20 +100,6 @@ static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
 	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
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
-	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp,
-					 1 << (order + PAGE_SHIFT));
-}
-
 /**
  * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
  *                          specific NUMA node
@@ -141,16 +127,4 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
 	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
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
-	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, PAGE_SIZE);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 798e85bd994d56..5af82072b03a17 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -730,7 +730,8 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	if (rk_dte_is_pt_valid(dte))
 		goto done;
 
-	page_table = iommu_alloc_page(GFP_ATOMIC | rk_ops->gfp_flags);
+	page_table = iommu_alloc_pages_sz(GFP_ATOMIC | rk_ops->gfp_flags,
+					  SPAGE_SIZE);
 	if (!page_table)
 		return ERR_PTR(-ENOMEM);
 
@@ -1064,7 +1065,8 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	 * Each level1 (dt) and level2 (pt) table has 1024 4-byte entries.
 	 * Allocate one 4 KiB page for each table.
 	 */
-	rk_domain->dt = iommu_alloc_page(GFP_KERNEL | rk_ops->gfp_flags);
+	rk_domain->dt = iommu_alloc_pages_sz(GFP_KERNEL | rk_ops->gfp_flags,
+					     SPAGE_SIZE);
 	if (!rk_domain->dt)
 		goto err_free_domain;
 
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 844682a41afa66..a9c35efde56969 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -295,7 +295,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
+	as->pd = iommu_alloc_pages_sz(GFP_KERNEL | __GFP_DMA, SMMU_SIZE_PD);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -695,7 +695,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	pt = iommu_alloc_page(gfp | __GFP_DMA);
+	pt = iommu_alloc_pages_sz(gfp | __GFP_DMA, SMMU_SIZE_PT);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
-- 
2.43.0

