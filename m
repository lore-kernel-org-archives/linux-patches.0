Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289AA267B9F;
	Fri, 14 Feb 2025 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552907; cv=fail; b=hrHBFZXW4ac3XI82jf+DcGZmrjNC1nVUoUKhWtEKpa2BEOswNwsKCRjZ7KYeUXn2IVXouO/nU3MWwoHFNpcFDuS3RQCuRTp39VcqK6ZldqzUHz7jv19alhV9h7k4JlG8TodDEp/tj4IfSSPydVKtK9CSidWXFXTzGDfskBss3Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552907; c=relaxed/simple;
	bh=4nPVlxwsbrepLWNwRmBIogQEFkis9VLmbaAKIZU8744=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E5XiljazQ/L0Av8YUAtnAlaZB7Tq1WSbIokdFVimfQ5VxfswwdWH8tL3xg6uA9KuGEwNlno5Ks1WiRRRR3WcIAkZM9xiBMQM2tWH7AduLTlYI/y7L5bkIz4o6G0WQpRswgHN+pz7whF2lSC+9SVvqiTKfa3pfjPBiEBwe7jrW8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nChusJD8; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nChusJD8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQ3RjlAI8AAZ8yW1WbxgFgwqY+vNt/4zTXh/ygGoSujuM+UqcuNuGyHLxi7ujLZCffwkSfe90ni0RfoRQ/5inNQd3FYcrPHsqnOSuOP1HUTNlopM0CpJgkvGXU5v1SFPcUO/KcYTL0pjlZJn4crhhT4s4q5JqcZKebezstEj3BurgkOztv4LtMF9tgY3NeAe8PvIbJNWzT5fgcSw504piLn+C78F5bwFPtpVDQyfG1H7KAdG+5FuloEmeP1S778QyjqwuUE2Ttsr5enopek8+97Ky4y+6FT1nw9057ZKgoSogr0kVoyH+E96eR0MqFPsDHrPPQwtdIXO83Z7pAHRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYGmfwYYThg+EeSF8/LyeNC/9wQTQWcfegozIydGvj8=;
 b=nKlLoO5RffZuUAPw31DaHugugNYnTQ8/rRTxtFes2OIlTdIQQmlVvsGfTiT0B/4H4GrPuZVsqWzmXwDziS5cjCdfkZlhx7DaHwZ+9aIAab4NKKSEhSLN+UXCxf1U7Ko4/ZYJV4S2X2SwQVOO1oiJHrci3aHzt4PUEvCG8OlZCgHxm8LWlHb9qpDGXnJ+2HY2UIUpDJpxk7VIOHfaj4i4EuQf/g4IBs5mRljLxQb0b63G5zEAwvgNOzF82GO1OOax0IwfpyqalCoXEJkdF5N/eiU1+/Odpi5fY93Ei8TtZxIh0eK1G8lMRgwUljE9WGSq2OYGSCt+qJuazdzeraSPGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYGmfwYYThg+EeSF8/LyeNC/9wQTQWcfegozIydGvj8=;
 b=nChusJD8fBOyqrNQP0Hr6zDDOE5SO3IwrQWyUCsoqkSoZXyY3AUYq5D5IOuBDKbQL/fLiZqVuNCIoVRC8dR/tcb+fP6Sdo56moFBoIvVhCsFX2GD80yTe/aHy2/x96H8HUGDkpfAq39ThIlrat9oJYrxQ2aR2XVHs8wxOKHtPqAzr39AOeYZmeGBxOKdMot8zwuV6v7XWAOLEzWiwO13tedUNRcxmm1RP7xmq3YL6o5a8S47pTNi2vrN1ZBGjBbRR7HzWUEtjFvObnw3suLWgM8bcLwi7gHf/TrtVZF2lSm5Yph5riHFJRwgI0YboZhzyRYFaQuGvqgrruAdn8J4Tw==
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
Subject: [PATCH v2 14/23] iommu/pages: Move from struct page to struct ioptdesc and folio
Date: Fri, 14 Feb 2025 13:07:47 -0400
Message-ID: <14-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:207:3d::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f7eefef-4675-43c7-a442-08dd4d1a22c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?69n6azyIUKh69iA6u2NaB3g/s+nO4XcFlwYSVzMF/o+Y/a6q00fLrRhjd22f?=
 =?us-ascii?Q?5I9ByH9zLzaQ9ANB9kiTmEPSa1+tVD9sbCtIOiYbe95OKzvVmT6lAw7FYlrF?=
 =?us-ascii?Q?+pDo3g56TZnJQGbMjwo4DBGGP8SfO8IIu3QRUE15Rb1YGJjwjarPQhWTVgA0?=
 =?us-ascii?Q?Hj5M2My4Zz8L/7kW6oY33L+0kAplFquEkQDMxrozmAaOfM0mb+S09uPGMOmt?=
 =?us-ascii?Q?HCrVfmAhtDoO/UaX7ajDC+gCVRfUTcXBlikWqi5RN67M5JT0ypGSe7NX8AHk?=
 =?us-ascii?Q?Ybe/wPhtd3j9iDlvWZL2e5RV+rbMKQZLW3ZCrvdBRfXM/6Zp55/uSiUFiQfB?=
 =?us-ascii?Q?FULBFb4WozI5WTQ4kHuONHNyocPjrxFqEklhLTciCv+7HLPBh3jLYfRL6VMI?=
 =?us-ascii?Q?fskoyhkutxEPNONaVDsi5PWXI7yQhPZxrLfJCEMxP0lr+k7kDOA3efqcsDUk?=
 =?us-ascii?Q?VmTOGLt8MkabhwJR7+D6XaC6CqBK262ckhUtRIPrBrY4VKOASA4h62wojT5x?=
 =?us-ascii?Q?O3xpZwBGUXYCzP6rz4TP619bEQ84H0eZzBkc7itFT/INoSeP0DKrJf0nvDVK?=
 =?us-ascii?Q?UzeGRrC1IWwzoW39h6xiDkoDfZ1AoqLa4bUQ1L7ptNzcvQHoAvs71ae4gohn?=
 =?us-ascii?Q?cm1iyJdIJ8/ufzXyD+yrG/pnkY2WgsibDM+RTyJMRXw4LxRDpb5d50djNZ74?=
 =?us-ascii?Q?7yyQzLOgw0qXSxqf29J0DPpZWn4i0U9MYYI+rMGay5ZOGqe23OJVIeWFThza?=
 =?us-ascii?Q?MzTl0LjtU0cLPsJBSHlNDgxGKSP/XClPlCrDlYdlVagRGp7NjrHZdm1LHMHa?=
 =?us-ascii?Q?EHJxLdaE2jwI5lD0pY3jB7LwPqIhydDmUGDSVy+A05p8+OOuHd5xguE6Jv7r?=
 =?us-ascii?Q?c/jgoO+LJdYuG6d5EHlE/ZhDxin2uFTMft6ccbWnoPR0S4JVeFbx5zR3RS0C?=
 =?us-ascii?Q?L0x/b9EMNYAU+pKfn4OBR2H7ZVP8d1MjrQSMC1HIHPKahjlTcmWBdzmeDMuF?=
 =?us-ascii?Q?QlxYumaOxfsRz2den66sbGydPZoE60NtFzuRNWW06yH5wgTHYnh5lAygn7Xl?=
 =?us-ascii?Q?pRkKZUGBq14uF9Vr1+5KGypxbJYugeyCCAY32AQMixOsTUZAYa/GcDZjtOjA?=
 =?us-ascii?Q?iqBRkw+pXJCFX4TiTvAdP9LGDVCGhLlFjoqT96vV99dwZBTKCdV8REjRK1mr?=
 =?us-ascii?Q?+6Y/Y+RNw93GYuukqNLjY2RJOzAWmBztJZZtOHkHsfcOkQ9o60ySfxzBs5f7?=
 =?us-ascii?Q?nNtXYZRabCKdImirrSR0wcJJ9HbBQqwKVMI+DiafWIUmtahNvWSL++a06a1v?=
 =?us-ascii?Q?dMEjuDxBpzwmwRtNiZKvgm0csLU+7kVxY3xlmYWGBNV3QsXYUiW/8up57E8W?=
 =?us-ascii?Q?c32lyIus04jIDLFT0J2WbnlbJ47LPjL0lQUUG4T15huFCBQr+vfWFz3v+k3V?=
 =?us-ascii?Q?SJUbbOGH5Bs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vh2DhmLizLPQku5OBsWqKvInCLOuApuipkdjOkHkB4w3kwrmbTtvmhy1cyqv?=
 =?us-ascii?Q?jCbAVpfiouPduRMZRB03z2DX9TbfZPZAEJF0L2k8lnO1KiDqKqtilPXlZNhR?=
 =?us-ascii?Q?gRHDIOnsYWqtZkg5w3qNQHIUlFE3+Dp/f8ahWghdNPjsNPL0SFqmvZC/CTwd?=
 =?us-ascii?Q?baWaRfwr7cYcUa2Jmj1N4oS9ixSwRGKkNX8ZoTTsipdcWn09zLwOGtOLuG3K?=
 =?us-ascii?Q?KtxFvKbSoR6luSgg+FfPYaeMNQT5oarAUcqf6wuLbnsO4B2JMe5EK1aZ3fMo?=
 =?us-ascii?Q?Gs0w3XlR42Gy66UhUB/k3OTMYT4OEs7rSwkn/0RueYG5Smclmp1gMQbQEeNE?=
 =?us-ascii?Q?RX2MomGoXiil1nkgp59wJvX0RGWLBbfgDw2bWSmmXTwxHLGh4s9PiW9YUAC/?=
 =?us-ascii?Q?FeE+7b5FHNturGnLoutFZc99aPcecVRau2G04ib7UctjCP/Fiq+EjB2rzSZj?=
 =?us-ascii?Q?gZMnNkPUAH3qczL3mHoY9KqVFVXE9V+uDzsh5UI2KDGqopm0vJBTV9/KVAAz?=
 =?us-ascii?Q?ENkpvs9KTok5xvtBNSTkOE2x2JOs0N5Hfm2xZzhi+QWjKj4CeAwtPHndvdud?=
 =?us-ascii?Q?4NuX7sWPRxXLoRR/GA3MsssTrnziYvubCzROV/CfbgGrY5vbTgzOkKRAnJy0?=
 =?us-ascii?Q?WPY/EOBzPqsSxLMRGnujXr2zc2DbVxqxNTJvHobRpITVpE26foS+deymNfZh?=
 =?us-ascii?Q?hDY2EbGABV7/L05zJY9ArbO8YyHA/J4W7ikdD2iYdb1snZMtUv+q1jJwfrts?=
 =?us-ascii?Q?oaQlL1ins7p24eKDJE7ZnM1Kgnpie0mO5vEoP1ik0kKGs2elIfWvDEDuw+c6?=
 =?us-ascii?Q?MbsvgJE86jSVDk7Q3F0RQZd/dCXQc4+/dWbpZZxd/yJvMQo+zznAUhtX+aLO?=
 =?us-ascii?Q?QTqSim2vCbyUC3i96aR2StJkON2I9BoQGKRLwav39pncC+1B5meMfOzliXVU?=
 =?us-ascii?Q?N8tOp49dpeO7Gr8sFlCjvNYh17nbOKRxSqL6q5miB5TTBihlDAOgrQ3ycjGl?=
 =?us-ascii?Q?tWcVwr5dfz3hh0tOTrFnp1ic9sCLcvm8pq1lOihl1R2+2M4OLjLf1Mi0hXCL?=
 =?us-ascii?Q?EtN7LmJxqDmquT44Y4KOmblAXStsJNiSOO+i/fVxZwZjMEP1Y/Jk+qg1GZcb?=
 =?us-ascii?Q?xJFK04lg8kA+nH4/dBgY2bxYSTLRXTFGvspknSb2sHJMU+iIUAL8VRd7mqat?=
 =?us-ascii?Q?gd6DvoUZz+eEBCpt+EY5VMtFuE5h87l4l47mqkRFj3zvvI59soyWFLUnz3l/?=
 =?us-ascii?Q?kv2xN3mrJlG2QvYVDe85goUm5WGyWdCvLU/NVwzgW5nUHp/j79ufJ0MHRIos?=
 =?us-ascii?Q?HakYrwmyFjp1hM7mAQFzPF3ayRBGKReF0Het5GiOBfkM/FDQbxZMljRkvrLB?=
 =?us-ascii?Q?W6q0OGGwAvM0P2KCZgKBySf53TsvbRrVFu+SY0Kilkr6Nck/f2PkxrKAC7Nv?=
 =?us-ascii?Q?QEeq2rRXJlMJZniSpKdZQy5Sg+328pxFipdYx69MDeZgeqxKj35zNrIjDNDO?=
 =?us-ascii?Q?X5U0KlwLWiomJHOrIqf16cU5se9r7NcyU+/jTg2t8jBQ7PhuzhsaO2aE9Gzv?=
 =?us-ascii?Q?AbjVvMS5uDgia8zbuuk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7eefef-4675-43c7-a442-08dd4d1a22c4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:00.6753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0kFOZ4BChCMjXS/qJCadeEJekewAomyFE8iDkRi9bS6dF6iI/TOPSmCPzmtBWOQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

This brings the iommu page table allocator into the modern world of having
its own private page descriptor and not re-using fields from struct page
for its own purpose. It follows the basic pattern of struct ptdesc which
did this transformation for the CPU page table allocator.

Currently iommu-pages is pretty basic so this isn't a huge benefit,
however I see a coming need for features that CPU allocator has, like sub
PAGE_SIZE allocations, and RCU freeing. This provides the base
infrastructure to implement those cleanly.

Remove numa_node_id() calls from the inlines and instead use NUMA_NO_NODE
which will get switched to numa_mem_id(), which seems to be the right ID
to use for memory allocations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 54 ++++++++++++++++++++++++++-----------
 drivers/iommu/iommu-pages.h | 43 ++++++++++++++++++++++++++---
 2 files changed, 78 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 03d35c01597cea..a6b8ef653fc427 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -7,6 +7,21 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 
+#define IOPTDESC_MATCH(pg_elm, elm)                    \
+	static_assert(offsetof(struct page, pg_elm) == \
+		      offsetof(struct ioptdesc, elm))
+IOPTDESC_MATCH(flags, __page_flags);
+IOPTDESC_MATCH(lru, iopt_freelist_elm); /* Ensure bit 0 is clear */
+IOPTDESC_MATCH(mapping, __page_mapping);
+IOPTDESC_MATCH(private, _private);
+IOPTDESC_MATCH(page_type, __page_type);
+IOPTDESC_MATCH(_refcount, __page_refcount);
+#ifdef CONFIG_MEMCG
+IOPTDESC_MATCH(memcg_data, memcg_data);
+#endif
+#undef IOPTDESC_MATCH
+static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
+
 /**
  * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
  *                          specific NUMA node
@@ -20,10 +35,17 @@
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
 {
 	const unsigned long pgcnt = 1UL << order;
-	struct page *page;
+	struct folio *folio;
 
-	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
-	if (unlikely(!page))
+	/*
+	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
+	 * alloc_pages_node() did.
+	 */
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
+	if (unlikely(!folio))
 		return NULL;
 
 	/*
@@ -35,21 +57,21 @@ void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
 	 * This is necessary for the proper accounting as IOMMU state can be
 	 * rather large, i.e. multiple gigabytes in size.
 	 */
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
+	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
+	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
 
-	return page_address(page);
+	return folio_address(folio);
 }
 EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
 
-static void __iommu_free_page(struct page *page)
+static void __iommu_free_page(struct ioptdesc *iopt)
 {
-	unsigned int order = folio_order(page_folio(page));
-	const unsigned long pgcnt = 1UL << order;
+	struct folio *folio = ioptdesc_folio(iopt);
+	const unsigned long pgcnt = 1UL << folio_order(folio);
 
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
-	put_page(page);
+	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, -pgcnt);
+	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, -pgcnt);
+	folio_put(folio);
 }
 
 /**
@@ -62,7 +84,7 @@ void iommu_free_pages(void *virt)
 {
 	if (!virt)
 		return;
-	__iommu_free_page(virt_to_page(virt));
+	__iommu_free_page(virt_to_ioptdesc(virt));
 }
 EXPORT_SYMBOL_GPL(iommu_free_pages);
 
@@ -74,9 +96,9 @@ EXPORT_SYMBOL_GPL(iommu_free_pages);
  */
 void iommu_put_pages_list(struct iommu_pages_list *list)
 {
-	struct page *p, *tmp;
+	struct ioptdesc *iopt, *tmp;
 
-	list_for_each_entry_safe(p, tmp, &list->pages, lru)
-		__iommu_free_page(p);
+	list_for_each_entry_safe(iopt, tmp, &list->pages, iopt_freelist_elm)
+		__iommu_free_page(iopt);
 }
 EXPORT_SYMBOL_GPL(iommu_put_pages_list);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 8dc0202bf108e4..f4578f252e2580 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -9,6 +9,43 @@
 
 #include <linux/iommu.h>
 
+/**
+ * struct ioptdesc - Memory descriptor for IOMMU page tables
+ * @iopt_freelist_elm: List element for a struct iommu_pages_list
+ *
+ * This struct overlays struct page for now. Do not modify without a good
+ * understanding of the issues.
+ */
+struct ioptdesc {
+	unsigned long __page_flags;
+
+	struct list_head iopt_freelist_elm;
+	unsigned long __page_mapping;
+	pgoff_t __index;
+	void *_private;
+
+	unsigned int __page_type;
+	atomic_t __page_refcount;
+#ifdef CONFIG_MEMCG
+	unsigned long memcg_data;
+#endif
+};
+
+static inline struct ioptdesc *folio_ioptdesc(struct folio *folio)
+{
+	return (struct ioptdesc *)folio;
+}
+
+static inline struct folio *ioptdesc_folio(struct ioptdesc *iopt)
+{
+	return (struct folio *)iopt;
+}
+
+static inline struct ioptdesc *virt_to_ioptdesc(void *virt)
+{
+	return folio_ioptdesc(virt_to_folio(virt));
+}
+
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_pages(void *virt);
 void iommu_put_pages_list(struct iommu_pages_list *list);
@@ -21,7 +58,7 @@ void iommu_put_pages_list(struct iommu_pages_list *list);
 static inline void iommu_pages_list_add(struct iommu_pages_list *list,
 					void *virt)
 {
-	list_add_tail(&virt_to_page(virt)->lru, &list->pages);
+	list_add_tail(&virt_to_ioptdesc(virt)->iopt_freelist_elm, &list->pages);
 }
 
 /**
@@ -56,7 +93,7 @@ static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
  */
 static inline void *iommu_alloc_pages(gfp_t gfp, int order)
 {
-	return iommu_alloc_pages_node(numa_node_id(), gfp, order);
+	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, order);
 }
 
 /**
@@ -79,7 +116,7 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
  */
 static inline void *iommu_alloc_page(gfp_t gfp)
 {
-	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
+	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, 0);
 }
 
 #endif	/* __IOMMU_PAGES_H */
-- 
2.43.0

