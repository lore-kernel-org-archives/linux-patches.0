Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDDE267B94;
	Fri, 14 Feb 2025 17:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552892; cv=fail; b=U0k8+SV68SopqmmDegFCqfMPZtMw3CHnjB1mkkLfYKkCKScIt9NacARrDOMd7uhJqhtKtc628G3AFmSVBdyUzZ/2HmR7M/LK6NbjcEUQng3j4/IXS1t+Ba4kSTJKy7I5MWoizV3TP1HVODILlB1Z48q9vyy6ASX5nibQPxb1+dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552892; c=relaxed/simple;
	bh=heeqkt4rM5E8R00hhBHM8lMmf24Hlp4TnTjfBGlaSzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Lg+qBShnIUhOjYZhVb8F6FoZ5ZQhWn0MS3emTf28bn4mkTg/xmj0gAIDqu30xik3CHpznZT3IIaURlsy8KrnIh9hSsFvHEAUYBXoA87FO552n65djCw9ogxTAy8jWFOcpJGbvC8JK6WLprnq9vvRAOLD93Z5QLnVlaJZQePOt7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aHNVK48U; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aHNVK48U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtLh0wOn9DffhJq9Wvq1K5jYBj22adUoN3mMjwtSMFiCc6mn8n2msTIcCrXqK4KIsEfvjoYmmxfbzZELhKHFIzpHOmXpvo8BkeMZuixr90MLmSgABC8a0mY/wIa2ZPiqfcgWYXhrFRzaa3oVvQvN+gTn7eaUh2yxmNxwjT99jX0QUTtXThX3kkxEUnn1iBihWT2qJthFVXMQ5oooXKW3iepjnyIC6isZTZaSxK500dyjpE/WGtrQVkK5IhAbZteW/8ng8JbHiMi7oYHAiooZZrj4h6v9OGnfm+haJCUjnz5Q1u2A3wydeM2FbBU9Pp6rT+UPaULFUDFtC/cbMeWesg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nisvBXgjfcBDPPgoC4zvixk+wTAE4AYi/W8wVAvqWt0=;
 b=SC8235uSsg3BxVu1z78MKKgbVLRKrhXhk9/lxB7gDCW1SWtTtBwFktOumNwX5dSHzF+kDfAfESecmpuEHWwUv/Y63opf0OrO82tPVMvadH3d3XZK+/X0PjbJZmF2ka0ZAdf3ZuHcWHtkCbVgLg/qp8xAeLl2uyeJCehKfd8IsCdm1GXG1oONFTOgJMQO2XDqynEcKwW+vVgqY3CXl1wzh/LfAK8AIm0NDt95YLktqXDAFTk7QJohXWF1akYNa7gviLiaGdtCNS4r3GeiBSmL1b66gbIarLFrDXOyXaCdVp3eAgsAq3+OX+rkEe3A48G8Ubc6fQYcGSQ+QEBcOzfQDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nisvBXgjfcBDPPgoC4zvixk+wTAE4AYi/W8wVAvqWt0=;
 b=aHNVK48UPOc8jHoAykTsaovRmcw2JmNPTVcUdCKAB6ATIVudXsDK0Ns25x8VZ9mnXL3BSN4NRLLMY0NxPVdxwom6+wgMNp6FMnF7Vkdh30Dv4/KI49VHpSTxEZS/FQqNqgg+P6wiZ6xfg8oAfT3y2932PT8E12yy+hKi1uwlqQl0ZMSxiX0jZJndYP3+udvJUzZWNVWoiTiina3c1NjD5YE/MBqmD6ACKPTr1qbh7aAaQ02KBm7jwIfAh34WZScYgSCABvL6L9HpHypwRUJQSky839ITdqywqYq7qgRoD7ocYx5/+gnPbZkiN/49RWCRQu8esA3tW87GKMBU2EwzLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:01 +0000
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
Subject: [PATCH v2 22/23] iommu/pages: Remove iommu_alloc_page_node()
Date: Fri, 14 Feb 2025 13:07:55 -0400
Message-ID: <22-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: a3bbb2c5-28e5-493a-e694-08dd4d1a219c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TM+m0Fea3U7/5W9wPbbnXiaCeJUhjvdMfq1IzTpRIKj9ait2DWEWSHhvHOgQ?=
 =?us-ascii?Q?ixg8hm0BwSxiQovA+icQXM0f4XvEZKqnF0RbsHzWyx0zCYvGYrhX0XpkzDmr?=
 =?us-ascii?Q?8gUmJYPLefTFSxW2yN4iJgedH1wtuy0aTL31o3V2uep7TnMVWL6o47ULZCAf?=
 =?us-ascii?Q?WApWw69ue3Gyazq+atdmZ83Nm/g9WGpA4PSDZvBq2mSg9kxXMdon9HjUtgWf?=
 =?us-ascii?Q?hOCnEdhjR6nr94jr+yhjdBjzUcgRuYir7NcKojTDxRhAmVEd3It+k1sAKuSq?=
 =?us-ascii?Q?s6NxfJJIDWKz5QH5DLwH4yuaSThf09gX3OaX13NDc5bnjLRGOgHi/YjJajn9?=
 =?us-ascii?Q?dtbOq+HdRRzTZJP7KVIcLI2tmJi77Y6FwlZtE0ynDuhmfE+3AolwTLLskHh5?=
 =?us-ascii?Q?v+m+z/onRlNg64A9NrSIJgROD2ES/9XyVxszPWejh9BUOtK3OqVKvu+5sgx+?=
 =?us-ascii?Q?ZD2w9M+Wx5GIlgGwi336Kmmv8wZXlIIXvOJHrwq6bVR7IIy+AAVQKa2Y2+Pr?=
 =?us-ascii?Q?P9HE2Qr+l34GvRltdieaWNIChiTocF7bm+SiEjrRSZWXJf4Yhih57GEGRLxT?=
 =?us-ascii?Q?0dOhnkJV10IU+/V2agGWjKaTDbz23bepy0FxRLX24S0azaFr++S7vK4QtsTs?=
 =?us-ascii?Q?U9YhCZp9xFr+sPuUex70bJ0fkfADA1XTrgw3S4TQ6OrMAbE01gd9g6IqG1cp?=
 =?us-ascii?Q?jTRT7n1wZ7ViSpRkF7ehYQVV1OTEEqsyBetZKNi+1XMouXaifh10RF7n0grA?=
 =?us-ascii?Q?p/eJLZqecshVHJ10U26wlmgLXgkOzBZ6Xh19/B9QpxUXVw76du1R76mWLub5?=
 =?us-ascii?Q?GddNdMQIBdaklmKO6tC02rqPWx0JeRMY79vzYOcWuOmSDQ4ECiKqtFvPjNFN?=
 =?us-ascii?Q?bex20NegCAA4c6O8jr6RhaihXCu4ZISmyCoSplFfHfPKWisrUJG+Vgr9HCHX?=
 =?us-ascii?Q?c9IhiiiiXunVCilzCMOOLYII/zl7rOkyjgNxf4FjLDgMoADQbyJOOrkseRLV?=
 =?us-ascii?Q?nLSMQLEo9fiaCO+4WXaBVdY4Ua+o65MNE5hKf4eEXLtHJppBLtBx34pjd2il?=
 =?us-ascii?Q?ao8EjAIfgZEdW80f2Y3N63UCNYo60R9yrKlmGWpjZNErzdCc/wNvAkDYyJGl?=
 =?us-ascii?Q?RBTH2cS4VqOjDhbEVbmp7vhJ+qhIZHbQ10iWN/D65z9Jkvka51duLwtiRkXY?=
 =?us-ascii?Q?tZjR1qT3Q7GBmEQDgJpBk68EfJRXROSxQ6TAlL/k5puO9ngpORH//LOuxXrV?=
 =?us-ascii?Q?4cZSK4IH9kOGnuiZzke3j/tMZh0m9wZZaXcwUbWIfTedPoPFA5aW8UzRwzxs?=
 =?us-ascii?Q?RKTh6D5f+dYIJLVhEGx3b0jlercABvgYhUTKos+q/rtgJSFs3+YE47NKu8xL?=
 =?us-ascii?Q?kR0YDAO7/wHqUGQD9sVydhJgNVuRCCyRU8jWSJsivs20k5Os2Lrt1aD7UUXI?=
 =?us-ascii?Q?lfB39j0G/E0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xkEoNGiIgCxn1BVS4AuwiFa7MNn8W9XxUHKkzb8jGuy4FSQ1P77ktzX0BjzB?=
 =?us-ascii?Q?iQdcZ+DvWD5rhXXem8/6UWPmCKr617spoq+bvNl/13zpPqT/CBwT2lM9bCJy?=
 =?us-ascii?Q?njgCKHNM1hAH0RwE55oraigXkXgJ+idh3B8VQWXO/Kn47BvT+kDiIIiBkTOV?=
 =?us-ascii?Q?Y1EXVMotp+gZP5Vo2h16vvfDPDG2AiGEE0zudfqHVVq2S7o8ph0yTEZtphKB?=
 =?us-ascii?Q?rr6Zmb14Tji+JDjx3nhhEYkzN8fXDZV1N3nA3NVb8lC7DzP6a7cvlwYHUbUp?=
 =?us-ascii?Q?yWWOxpLvwR8z813h56s+V0BRHTRRGuyD2L5dguPU22krhEqbe8MBwVheUyUc?=
 =?us-ascii?Q?NBG9+hiki+6gwtxEQDzad4gd7kPRblGVQ+OFDygU7igyuxGmCEDZXjfeYuy5?=
 =?us-ascii?Q?FoiN6VaLWiJkcu0HkhgTfpTcaRl0nOiCpELnBrPX27j3a/NmsKQAT3ZKJZmh?=
 =?us-ascii?Q?62Zj1cb6nTQYcIOGKfxdcj5CK783abpg0vyJiwCH29NFMKrXjI34Vc0hJydR?=
 =?us-ascii?Q?z5ALMBTFzZnYMkygsxyQSi2dS/xPdopWTnAtWuesmsIonkrLfjCBfnsHZhfv?=
 =?us-ascii?Q?KcwKPK3WZrrmKemdJBxIPCd4UGqLcIl7jncFV0CL2/z2cX3CxGb3mh4S67rg?=
 =?us-ascii?Q?6f5Ok7ECZWyKZOdQQmLyl/FlbwiVOielNfgI1Fu+7JAHihRVO+4QpcQiAQwJ?=
 =?us-ascii?Q?mGYgKW4EyRCc9YxVQcx2x6ynO9YfAPTVuNQFuSbkxIb8sp87mfPhzFz/yRoP?=
 =?us-ascii?Q?7t0TFMoZfGDhrMlMCviJ5TkfE9vWUnv0Y5X9/qWdCKywI8rMsxMwxk1NVadH?=
 =?us-ascii?Q?YWyyLd86oSZ22/VLslG+K0npRGVwhGg5B5HDuPecSSeUZSkG8m+rOlXu/3q4?=
 =?us-ascii?Q?T7WnkU9FfDKCKW2MHTp7YBx+RI0R572G+NLnu3ssnW7WiDH2ipucS1SjLYdN?=
 =?us-ascii?Q?KMTUs/p2vjRYB4vG9GYAk/YJ+WBn55vZyx8NFNXB11hI+dFfcop7YU6uUyHW?=
 =?us-ascii?Q?fnFobtC6u9a3KhLq7t2UN/7ox22g0aq5pspXwTG/v6Njli9GYCyA+uJOLMgG?=
 =?us-ascii?Q?0RGoEgvjXWzKmOU8VX4pT1oVR1j7k0Ai2tF9XL5j9c64+QjWvm7GC2Cv+g8u?=
 =?us-ascii?Q?Q4g9SPoOzG6B7uvyulGu65/B1YHayNyykn6hp7wUX6BGckt+44sW/Bsk+dt7?=
 =?us-ascii?Q?2eOgPzobFmBqFkT/yLvCrpyT/SyIwI8zrLPnSlwazaDvAUA8CLw6T08346iC?=
 =?us-ascii?Q?vfW+Vi/0EQwpRi+19bjmd+AUkkTU1sGwcuXZixtlMUMHXZPSgDXPj45bVwiU?=
 =?us-ascii?Q?94A2SqpNyNovH7UVjXVKR5c/PfZhUulbQSRsDZkO98YmRejpZKT4VNmwN1iH?=
 =?us-ascii?Q?SpdMFILuMuKj/3iNMW2p9L+r+yW0KfVyU1sEzDIffnykLhqCVaug2LFiv5or?=
 =?us-ascii?Q?2qJjh6AKRbYZ7d+UBIB7hA6/N0ROzEMjxmZDVY/kdTZxaBJNOFl8GPqZfHuv?=
 =?us-ascii?Q?c3jGJjwpr3Rf7V8Upy95vMkwmOr8k+0beSCY9FcFU8NnBIp2jBXPnxQ2d153?=
 =?us-ascii?Q?afBEcbVR7ZYsAqqVPtM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3bbb2c5-28e5-493a-e694-08dd4d1a219c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNFOD0SGCAAttfyJ4yo64xT0GALNAXZiRAo7cLiyxOydGkksi1GuG8repTYqJDGY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Use iommu_alloc_pages_node_sz() instead.

AMD and Intel are both using 4K pages for these structures since those
drivers only work on 4K PAGE_SIZE.

riscv is also spec'd to use SZ_4K.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    |  8 +++++---
 drivers/iommu/amd/io_pgtable_v2.c |  4 ++--
 drivers/iommu/amd/iommu.c         |  2 +-
 drivers/iommu/intel/iommu.c       | 13 ++++++++-----
 drivers/iommu/intel/pasid.c       |  3 ++-
 drivers/iommu/iommu-pages.h       | 13 -------------
 drivers/iommu/riscv/iommu.c       |  7 ++++---
 7 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 04d2b0883c3e32..2eb8a351ca91e4 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -121,7 +121,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
+	pte = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp, SZ_4K);
 	if (!pte)
 		return false;
 
@@ -213,7 +213,8 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
+			page = iommu_alloc_pages_node_sz(cfg->amd.nid, gfp,
+							 SZ_4K);
 
 			if (!page)
 				return NULL;
@@ -542,7 +543,8 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	pgtable->root = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->root =
+		iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index cce3fc9861ef77..a07c22707037eb 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -152,7 +152,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		}
 
 		if (!IOMMU_PTE_PRESENT(__pte)) {
-			page = iommu_alloc_page_node(nid, gfp);
+			page = iommu_alloc_pages_node_sz(nid, gfp, SZ_4K);
 			if (!page)
 				return NULL;
 
@@ -346,7 +346,7 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
+	pgtable->pgd = iommu_alloc_pages_node_sz(cfg->amd.nid, GFP_KERNEL, SZ_4K);
 	if (!pgtable->pgd)
 		return NULL;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e23d104d177ad9..d465cf2e635413 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1884,7 +1884,7 @@ static int setup_gcr3_table(struct gcr3_tbl_info *gcr3_info,
 		return -ENOSPC;
 	gcr3_info->domid = domid;
 
-	gcr3_info->gcr3_tbl = iommu_alloc_page_node(nid, GFP_ATOMIC);
+	gcr3_info->gcr3_tbl = iommu_alloc_pages_node_sz(nid, GFP_ATOMIC, SZ_4K);
 	if (gcr3_info->gcr3_tbl == NULL) {
 		pdom_id_free(domid);
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6df5c202fbeba6..f72de7519d840c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -397,7 +397,8 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 		if (!alloc)
 			return NULL;
 
-		context = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+		context = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
+						    SZ_4K);
 		if (!context)
 			return NULL;
 
@@ -731,7 +732,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval, tmp;
 
-			tmp_page = iommu_alloc_page_node(domain->nid, gfp);
+			tmp_page = iommu_alloc_pages_node_sz(domain->nid, gfp,
+							     SZ_4K);
 
 			if (!tmp_page)
 				return NULL;
@@ -982,7 +984,7 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
 {
 	struct root_entry *root;
 
-	root = iommu_alloc_page_node(iommu->node, GFP_ATOMIC);
+	root = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC, SZ_4K);
 	if (!root) {
 		pr_err("Allocating root entry for %s failed\n",
 			iommu->name);
@@ -1994,7 +1996,8 @@ static int copy_context_table(struct intel_iommu *iommu,
 			if (!old_ce)
 				goto out;
 
-			new_ce = iommu_alloc_page_node(iommu->node, GFP_KERNEL);
+			new_ce = iommu_alloc_pages_node_sz(iommu->node,
+							   GFP_KERNEL, SZ_4K);
 			if (!new_ce)
 				goto out_unmap;
 
@@ -3315,7 +3318,7 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw);
 
 	/* always allocate the top pgd */
-	domain->pgd = iommu_alloc_page_node(domain->nid, GFP_KERNEL);
+	domain->pgd = iommu_alloc_pages_node_sz(domain->nid, GFP_KERNEL, SZ_4K);
 	if (!domain->pgd) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 4249f12db7fc43..2b6e0706d76d62 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -147,7 +147,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 	if (!entries) {
 		u64 tmp;
 
-		entries = iommu_alloc_page_node(info->iommu->node, GFP_ATOMIC);
+		entries = iommu_alloc_pages_node_sz(info->iommu->node,
+						    GFP_ATOMIC, SZ_4K);
 		if (!entries)
 			return NULL;
 
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 4513fbc76260cd..7ece83bb0f54bb 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -114,17 +114,4 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-/**
- * iommu_alloc_page_node - allocate a zeroed page at specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_node_lg2()
- */
-static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
-{
-	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8835c82f118db4..bb57092ca90110 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1144,7 +1144,8 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 		 * page table. This might race with other mappings, retry.
 		 */
 		if (_io_pte_none(pte)) {
-			addr = iommu_alloc_page_node(domain->numa_node, gfp);
+			addr = iommu_alloc_pages_node_sz(domain->numa_node, gfp,
+							 SZ_4K);
 			if (!addr)
 				return NULL;
 			old = pte;
@@ -1385,8 +1386,8 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->numa_node = dev_to_node(iommu->dev);
 	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
-	domain->pgd_root = iommu_alloc_page_node(domain->numa_node,
-						 GFP_KERNEL_ACCOUNT);
+	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
+						     GFP_KERNEL_ACCOUNT, SZ_4K);
 	if (!domain->pgd_root) {
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0

