Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4681FDA65;
	Tue, 25 Feb 2025 19:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512393; cv=fail; b=uH/3qjieHWfS4bEfU0U6897VFvj8F0r2UOjmDLYERH8sm+5IqvtZPS5+Qo3AQx2IyJ53kGJVBDib9itEsVa+QmtXH6AoycXFGa7QFeIGElGK5KWFTuqjdg/ClxOukLlJe1qU6AT++qGUVc15CPZXeEUSY5SGcgWS82oeCTiCSy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512393; c=relaxed/simple;
	bh=MAQJyHIFJE0fZwdG5kb4SOY8UnhphrutU4CA3Qm28Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=obgQjEqYr1aUYBW4T5PXPamVDgjKWvx53gSi/0ocI/Urd040mSSdJcur8X+XAoFDSAy+9WaUEmicXnJU/s+d2GLl0kCGTEGa5EjcSPw+Hmv37uAVQHdnJOspxZwk9f6lLsYuMd8PJrXgOwr5B4/Wt3VQ4HL92F98XXoMhzDk7vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=awH3WoUY; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="awH3WoUY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaFHtjdSBLSQXzGAXoDI+29QqlB6VijAl/R3g3g5kFp87b55tKiImf5okjeESa33Jk6PRYY9x6DWqo1IGJOhlY9oYUpSRlI6LwTyJLvXoFkvv+QOW8l5yTfEseqNaYdAZE4Cw0/Vb9g3YKLqkhss/CmA5XytGRD7CC+bO/21nQqDMo6ki7qXEP8Obvwu0EiDsDGINY5cNIj9/9VXE7wIX8LnF03YhxMUKP3PhlLpH/m2NEKletmhr8wgbgCvnb8LZwTAUnfJDwcNgABdzM2Z0bCnhzUBE34q7mwvM170goPQLXx5nyuHhyZl2V13L+ZNnpufVoaG42Dopenq4BYprA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yV1vI6+BTwDkONdyALdON90gjpfpGH6NQjDVCww9SRY=;
 b=OVxByPW4gC+Nt6N1zZrMc/pW5V3X6IT/mAc3I36J4bdyc9lPxtkZQo7iWOnncFqNj1tpSk9sb2LE4NhTu+2evucONhHohQ/y7xV55fltGPLT/cqPWA20e2H2XLXH9z+KPU8axp2diuRaqXcHQHHr2GIBkUq0gXxdT/JrAEH5nSOvkPzX/KUVW40+MNy3zLy/kafmpPWLkR1BXw30/N+gBwjs/6xtJN87AnX68Y/Rc8PGHrLvRFGiQ+ul/w77kKxgCtM+i+lFrHVJKvjS0452i07Hnh/msEDG67drpdXqkFYRpC/x1qIdotJo31tTYKIBXAqHiJBiV2KsmVNMNG0Yvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yV1vI6+BTwDkONdyALdON90gjpfpGH6NQjDVCww9SRY=;
 b=awH3WoUYQ2M+AIaVl9I038Pl0I3HfR5EQgXTLICfBZn4vK6HdBpy8eZqprmtsT4GDRO1gBiIzCn6Jz/2LKTMPP1xGcQB9o2dpMi9uB29rFh1sTwhPSciWKmtPgc898jqTkYG1QYghacdwF8Hw7eot6DEZQw0WvHQMnQd38p60OjiynQzCdmswePjfF7qRyAQ4Fj3Te+7nG9qiXv5sou18H+r00F49pUjE2yNUqgDndhkOzaP8KFcdDo6ViGwtatMtCSt7rD41Xjmn1Y4cPnQIUX69yZhqLXhpsHdgvxAGptJJKzz5VoB3mrLYL2H7Z8+FzMXy9IXDEklxlSUV8q9Zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:44 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:44 +0000
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
Subject: [PATCH v3 14/23] iommu/pages: Move from struct page to struct ioptdesc and folio
Date: Tue, 25 Feb 2025 15:39:31 -0400
Message-ID: <14-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::13)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b12caa8-7dd8-446e-4ead-08dd55d42687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?untI9P5ODbilD7i2BCmgVrFefAn81uFGLJp6va/v9RQb4LMdAYa8av+C5gtw?=
 =?us-ascii?Q?4YbNRDI//Q7UVos2vQfKcmlvQUS4K/uwWnFWk7E5kBP13r1YYzizLAuDWGyY?=
 =?us-ascii?Q?Up3Pgnsyuiax1B9jbA9cRvAsHXriw48GFLwLfme+MHj7Ozxmv+o13ofhciaN?=
 =?us-ascii?Q?q2oFGqYZ1aoNMBpwU5W3JqQvvCKVum6AaXTznROqI22fU+3Mw/Uhb04IEoZG?=
 =?us-ascii?Q?FTC/qLNShkAjWtRQ23H1GNrerc3wr72r9kodtnjr+xCH4Wdmo3M0Eq7u/2Ft?=
 =?us-ascii?Q?rlJZ9MYvaDdCAaDOtgWFPwxfnNulCvyQI/n+TOr027VAAoPMmNQZcdtWhClU?=
 =?us-ascii?Q?jWAJV/5HRHx88etfG6OmlzuYnxi+HRDEjdDLiJNGb9caeBJ2iH6Ru0O3imw7?=
 =?us-ascii?Q?2v9NZW1iSD6MSyDdTYiuOcjvkTIZsAltl84ORnm+ByU+mbOgRGAXUe5QXR1n?=
 =?us-ascii?Q?iU4hFLOq2fOdZx6Quytig1mWxT8VOcVtIk5hcxQDszoNKzz7nynXYzAs/iif?=
 =?us-ascii?Q?MWu+UsG34vaTo7d6pXPH3OdkOtaOVFq7eydz09rpKfhocKXP6hCXub0oEBkt?=
 =?us-ascii?Q?/uQFQGyFv1YYNOa9TIWQFrMdNo4KEhRD40wNMTVGqPSo893yaTmwCYa4sEfV?=
 =?us-ascii?Q?jbTaTCbTi87vIyUSR5PCrQb0/abgnkhWEPd9mpUelNVrVgIVjINjWqzvV4vQ?=
 =?us-ascii?Q?BLSzO7uzejW9R6kwzo68BL47je20maXIoUpAAgvHmJjB9aARzfhqivaqW0j9?=
 =?us-ascii?Q?/aUvqSEbwVe9dZKeRk1LAUbGfBaEe9039AwUxwHFBn5z9wL8+Jcf/0dJpPG4?=
 =?us-ascii?Q?9UsXD5ZKJQ5+XA30M1+DELp74/vH3N78CxKdrndAx5Zx2kzhZjX5B7RHzAD9?=
 =?us-ascii?Q?QViXXDD6YWzbzDZzGSnsqdpbUwNkzuwoIBSP+voDMusQBuk7JS7XvweNLAgo?=
 =?us-ascii?Q?zAEEvxOXe5b/90khLwjVUZ5KSiZQre/M3mCKNfvWsMTdJZ/fCwQDBQdxnn5P?=
 =?us-ascii?Q?uJIDn/2yr0kwSrWIOGWCbDOiGYSm+xvXKICBimfZ5VcGWh0Xxc2bQFvZyIIE?=
 =?us-ascii?Q?C6x9DuvHFJgZXit5TauFHflATry2jAB6VJ3k1/w3CYHx8IDHQl7e9cQ9nxvj?=
 =?us-ascii?Q?4spexudeUr55H/up5Kc4a7ou8Cg5cX/iAhinsmc+M7CH+4yV36PzP8b3qDTy?=
 =?us-ascii?Q?b+NFuQuot+j5WArVdH89jC7qCiTqC9VlMGyxM1ewhGHi3NweZTycW5j++zIP?=
 =?us-ascii?Q?DRmcEnXxvezXgqaTAUfT4rEs6+/OYbig0bUf78GwhQT5O9SBR9GMPhb+pRA2?=
 =?us-ascii?Q?f3z3ngS2tYSWvSOQFpQ8J8MiuujFVfrHracndCZHH3L4uwM3cMqsimQZmKpf?=
 =?us-ascii?Q?pnDGKHiNiQ95iYzbt+VezquYzHBqBdL5Y/ZPPNwDyp8ScI/pdIKcDGVGJuRc?=
 =?us-ascii?Q?X1G7pZTbLao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6rNnkpIQC9zQ6qzvOgi0jfG6Xh1On0CZran+LOO9VIryHETXNb+K1RH1ZuFv?=
 =?us-ascii?Q?JOkwOq9oeBdJRovzmY7KDdalaWGB6MATYxv3ThimJK8uhOCB87JmmiKRcbJZ?=
 =?us-ascii?Q?gl09fnSWGTqVtNItUas0AjKnAYO8DfZAZFKndp9snj2IwfJNEtSIQMu1IKd8?=
 =?us-ascii?Q?Eztar0Z5Pn/D5gDpsYaWy7ZqFAl0K/4ZWwEHoSN9Do0nu5FsEQH6IT+Nn1zQ?=
 =?us-ascii?Q?94wwSMm7qSf1Xp9lF+UqJLGEHO1Hpkai3lIDOJoiTS7ewurivFEJg8Pslg9X?=
 =?us-ascii?Q?71vZ8kOGJ9OVDBhes265MvT3JoFKSol1wymPyGjZxP4uDbwJ9YGB1EWk6eCJ?=
 =?us-ascii?Q?FEg4/TO6hINrXeUn/OGdR8TaXNP4K6KGIFpQpoI5JKZwklf2Gs9SWr2asbq5?=
 =?us-ascii?Q?UrExTEQHY7PAEU7vQWV6Zh/YqnChXlci0ghSka4dwipeNz+ZQH5Im5tJbPCx?=
 =?us-ascii?Q?LAA039KG3hTnp8LvnQN3BIMhCqU2vpGVkQkGpnR0wxp6wUr47gpz4Hi+drnj?=
 =?us-ascii?Q?KF/6JxW03ll1t+p9CvIQEjRHmKVaYuAtzSCEd07Od1f467Drr6+nEnoC08iX?=
 =?us-ascii?Q?aGdrjww0rEkPtUmJAQCbqn+u2F3/45gLtQG2fBl9A2jVCdn1ZUUZlUK81jYi?=
 =?us-ascii?Q?3teWqj8zl9xGFVaVIgFBLHP51leqOCkt8CRLiVWzFcUO3vVM0y9cqjh9rOJm?=
 =?us-ascii?Q?PqXa8VkR4e7ely4vS6PKf0SKclwYy0lyEeMaDsUQrzVDTmBugzbF2s3obBpH?=
 =?us-ascii?Q?HaIgjSneu+7XmjmxNBcFZYREsGndybuVkJT92bgsbDktA+Txdpu/CYGX5TlD?=
 =?us-ascii?Q?cEXjOItIg7jJ5Nve5urHVOmUFDwcng90yLnBCvsJDRm8mj1MDUWPVvbWnPWO?=
 =?us-ascii?Q?8R8njHyKEcoAOg9SJ2eWsekg3aUsfJTwt5bmJsDT2O7FZHxRiTomnZCaLuZv?=
 =?us-ascii?Q?6P7dYZl4NPs+pgKTY4eE4vmJ5xnbAMWwIs8wMLn9sZBvr6Hdd0IN1ar+kNxG?=
 =?us-ascii?Q?AvxBHZXnFu6XpyfuPOPPmSzjmTGqjxdPWV/elvLtETAPaPn1M/BnP7NXR2Nm?=
 =?us-ascii?Q?LwEQVRRtA4JKoLVBarKljY04w15ch4x+V5W1Nu7rm103GCVf7qfWgsmbzCZD?=
 =?us-ascii?Q?MwVPPMCRzq5GvJn6lqvsxhdmqXmEOfjs+AeTZ8Upq1dik/r9EmcwDpQWRRSa?=
 =?us-ascii?Q?FTN9XW8W0byclNGxLMAi7V5EXkfsRthAcobSZ/1vHPQZ9XT9cF2386HWUVpi?=
 =?us-ascii?Q?NDpqkaXa6iY2VtegQU0qtEKsf4ZQggDCi9i6ZBwK8w6YOAIoludmr6K5X5zM?=
 =?us-ascii?Q?kCEcw7GFP3gc0eme1vSe9wGbIWaZalNX76bExgM/rkhWLwcewIF0qWB+U7RZ?=
 =?us-ascii?Q?oXd+3+0hJkrZJk+yUo2J85eyZqvdKJmC18Vj7K+pmVcfCaEW3tr8lJ4Zo/NH?=
 =?us-ascii?Q?Q44x0Ey+YAVu+eAqRTw+2UedBeY7GS0zre1hbpGyVnTZA+ZdADr/nwGtWLOY?=
 =?us-ascii?Q?SFDEEnXTKaKcr7j3NjvmKSal4+YwJzFRmIxzasLn3fkDT1+pIKvcjirw7KDN?=
 =?us-ascii?Q?fHHgxHrNc6rTOeceCE2Y9cNi1lD8HHrllKNQjt82?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b12caa8-7dd8-446e-4ead-08dd55d42687
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:42.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpiXO6+rAaYmYtzQ8D5YUhjAm5ERCz/D7IV9dx7gIIDYO8kFY51LhjNunkUPq69l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

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
index 6eacb6a34586a6..3077df642adb1f 100644
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
+static void __iommu_free_desc(struct ioptdesc *iopt)
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
+	__iommu_free_desc(virt_to_ioptdesc(virt));
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
+		__iommu_free_desc(iopt);
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

