Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93B120E71E;
	Tue, 25 Feb 2025 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512397; cv=fail; b=p97OpULyfxJk4cTdvL3lgKuhwCFlXEhoWsjuJzqbl00pbjWXL4EbauZr6Kz7FA4FB+nLenjtPTvPesLJJbkaeuWM/r11P7CIbANF4TjpMc3u5GYfExxm6DszfBxLJ/psN3wwEkYeWP8a41/MZRdl+TaoZ+8k00SmPUV44Y5ZitY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512397; c=relaxed/simple;
	bh=9U4lyEYxK3G3ozRYMASfjKcpRp5XNXvDU2PcqKcl5D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gC3MDrJmBi1fw3J0bWq/xDGLheXeOomxrtyb2wknFvR91MhAxfD/rSI3TbifhyhDxNiRDLp3ULbJu+EkotijYhDNZEQIDYeVgZlVpIcU0eApVLdzViTD8hC97eS8VSuT3ufLVmfCvzbWV9NA+6Kzyi0HZVVL76az7WeQrG647MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WuEWPhCz; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WuEWPhCz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oql2jVuxq6/+wA4b/6UzLh75q+S2ps/oJSmuddIY6/lHKZIraAtpDyXRRXYCWUFKuXb/VPnxrgZLN/XRy5XRvHB3iUYMRfUuH7vQ18A9mnoQ4lAE2EZ1wifpJIH3IlbpGMkoNn4KsDMXssbo7vhaB9Ua69BUAO4g2gjVq0Pc3uEuq+40cMWq7Cm+qzs2T/9r/ikTl7Hjw4mA185YW1ffucej0qfxDtJyJ2pr5rshq3W18M+zrpxCureX4jIveYXPjata0wfke8fOs40woD4XjrcwxvS1mJMg0OcOBeM6IedGm1ggbhSbk+w9SzLtYtumCRIGvdTfWAnxkcFY2Zo4/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHUIS8H7lCmGJIfDNmokPOsO+9kIuB4pJL9MpdOoQy4=;
 b=ONk0Tw8UxI0j54yc1DBa/wiMun8o7FXPosNp1ZQnn+B97o1k+Cw6U2tsVB573HAFL17MlRA+aII6ybbNIF8071bdCQmcXjj7kj2BAuW7g8wW7nPrNIy1LfhNvmHkDFwdhDfG7BYx6uHw70k1RuPLit2xzIrtQy2cAiwKRcvuI/NEM07LdUsb87Q3BsCjha1V4KFlL3CTjhnD+5vfgXKO70mup0diOoZwqNDghfvej0Od7T9xm3982trO7Hr/GAZ13/sunOz0xmD4Ez8vRGZO0xxxvGJtE0MjzZzpJuH2a9vLdq7ugATY4rRq3h30aoeE69EnjEVwEdT10WhHF7BBVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHUIS8H7lCmGJIfDNmokPOsO+9kIuB4pJL9MpdOoQy4=;
 b=WuEWPhCzkwYBMtNeW06r/TTWN8r4Ce5rE1NY7I7PeekHABghQCS1DND6z+ykieSxtroCzvb0+hKtS4J3rDwpGlz2v47vTB5zwFXy/X/+pYajiNAPX1roJCPFUFAZRn/GSfT5ZEMJIsp3LaxIeA81ONBxkbAsmxVgj2YtD84jeDJOMlL8ooJqn7LSsesm4I+FhPpopEGB6+MHXqPaU64EmHGy2Va9yLTsqDo5wfa5nBOXqMc7s2e+D+70TWEsVy4aJKW9ypubQfeQGcY9lBeNNg9wSk0jgvljHEm/6STKRJQ3BWAMqSdJOnSyboNMp8s+asYCpX1DsvcBT+jTlnkxWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:50 +0000
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
Subject: [PATCH v3 21/23] iommu/pages: Remove iommu_alloc_page/pages()
Date: Tue, 25 Feb 2025 15:39:38 -0400
Message-ID: <21-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 5106434c-214a-4bd3-9467-08dd55d427c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?baXJSlA9DbYtdPXIhC3U/TMvh8zm/nJXZu976dS5iZCLFo1O8ZwxTlJfUCpD?=
 =?us-ascii?Q?dQQ2LUlUz8xk7Gw8oYrIn9bkDVhuWaYRFDL36QTM6+lSxmcgFGQ8mpUDtGHK?=
 =?us-ascii?Q?cWI5oRK1X/NW7LmS5pT/zyOeVVUmPNsyxih0QyuiyTi+wcH/yGwkRH12Q02Y?=
 =?us-ascii?Q?QY/LF+SHu+b12PyEyP2ZHiAIzuYCEtMMWbmmQolgKNuT0TAJaYPUvK3pkN6v?=
 =?us-ascii?Q?OlqrKZBPAm9MRuO2ZmFIwHjeV4nIgQ7Pvh4NXcrasSU9x0F91T+q86sdft49?=
 =?us-ascii?Q?6CDfbsJ/6g4EFwwlQF++Ab+bXakpRAyYxsnXoKCG2Z4fOIeBTC3zOkdF8k+v?=
 =?us-ascii?Q?0Jxol9ZFzB2k0fYJ5cLMbJnSaaTNE1HId3PnQgKS6h1TWfltn3jRGq6ii5/O?=
 =?us-ascii?Q?JvXYaJQVpIeqdB2K+04Gsv3pQisSWjtYkPBIZFnqGlG0y6qycpr0vb1JHkix?=
 =?us-ascii?Q?EARB6mgHWgy4EmaW+3PqFHGkK5asry3NEkaYCc6QArFhnqcHrbYZ4HuOSQFo?=
 =?us-ascii?Q?8aPZL8tQQdcTYIhTjW7ofeOhrJavLIi1A22VAiV0z/q0FHvOgVxrINfB6A2C?=
 =?us-ascii?Q?1QxwMX3O6lSBpBj5OHG1DxSzxIj1B/uAPfsvcVG8sDBwEgV3BmEeZBF5+L32?=
 =?us-ascii?Q?nKsuEfSUhQU6auRifqJ9c8eYnTpG7sFMaGkOPxGl87D5RjgPOj5wAsr8eWnI?=
 =?us-ascii?Q?EekJEBALgVNi6ISjXp8ZSfHQQy33vA4OxihR5O0rKQKiDDVrrU2aWYA/9ng4?=
 =?us-ascii?Q?CpI+kGvmVAME2aRd68Wa2eGclWBQyewaUrWABHnl9JthfXoX6EuPN07wFKEC?=
 =?us-ascii?Q?Er0bLRYxOaKA1TvGfO8DR29O9diF2Fdn9JnGRKsQffBNC2RdetfRM6pv1o85?=
 =?us-ascii?Q?TZEiMjP1dD1h8+ZTbSDL3YdKNbv5Ew1GbnQu8SgFiMTTTSHHc7uF+0yglhdH?=
 =?us-ascii?Q?z8/jLGtPzJF/PZ+nGXRzf58QjoG/c8XMP5oGRBxwU9QmwP0Eukf4CXls3pQt?=
 =?us-ascii?Q?H78Xr1PxkQX9khbv8hwC+k4+q5NPI+qV055p38LAGjaX+tSfC7WzEgxntRVC?=
 =?us-ascii?Q?cGmFXBhOTwXgAZEnr7xNQ0QdwnNgGvwah6sezdSL9ZaiUC2M/yz0Qc9UTso0?=
 =?us-ascii?Q?IaWOhp+xxZ9C1Sp7a9Zop3V4EoO8Ifb0dzFQvGpO9ZegkWD6O5mv0ABAkxg9?=
 =?us-ascii?Q?ZGAXALiuJHK2Btba9BgY3ddth4YkVrjI4Kqw876mgd3Bpafwk54V/98gKEdi?=
 =?us-ascii?Q?uoJeIC/vvE48LVpqXn1Z7bbxIF+ZjlS1voDCXpL1N/OYMCD1vJcOhlGTJZ/w?=
 =?us-ascii?Q?GVY52vm5KpCTYM/PTDl576KjJ7jDw4rI1YiU2wEJn1MsAWWRqEDTV1HXMTG7?=
 =?us-ascii?Q?UbsqFvvQzLQMMiHNwSxFIwSP7dhzJ/oftR208XjxcOlrUv10m73ivpoYZg2m?=
 =?us-ascii?Q?u4fWgbKVb7U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RIAAQ8duQkri70cNzFKrO5BRxBmm475aeZo3r1R+sMjAFCwEM8ecEjUvn7yc?=
 =?us-ascii?Q?uqHlLCOCnckGKVNAImDSV9FmldxpugGT0juCKvERYl9KTk5iYcQJLOsAyAaY?=
 =?us-ascii?Q?vKcLT/NIrWCcP44kgB/nz8mbOZsEv9NTtjui1VIKzsihUWyg2zt1ev2vY64J?=
 =?us-ascii?Q?VehMuswzK8kir7mpZO54Zha8hTuLqY5l9ftv75HsB/Oqv9qKw0glZ+ahQbxB?=
 =?us-ascii?Q?8r3HGOV2Ylow7/JJIMy8rY4ltJWtbt1y1lta3k2XXLMTIS10bd87xoqHCGMv?=
 =?us-ascii?Q?BhsTTi1d627lj5ML+1sK7bKqvD4n+aPfqjek0wChA61oI8qyARe7hlJ6wJ8/?=
 =?us-ascii?Q?9NvGPL80HvVVmtiGbruJLthYYAqAd6nNrqDuzx+PGMYA3O9bu/Ax4V4MtgjI?=
 =?us-ascii?Q?RDoLQXrEpyCSKimcY1pdjvAwFYJmRHV02q6tSTVHJ7A1RFwU8vz35MBruRHv?=
 =?us-ascii?Q?RT1ySCTJafMPfSm8DLo3OyhALcqN5y4uBntR3BlS5G94/Oll3tDTT4NSpBp8?=
 =?us-ascii?Q?8d/pPqJSd+0zz5iMjobJpPJcm89tL+Ut97ur6G90KDQVVADWQx0k/sYqoVql?=
 =?us-ascii?Q?dFbFtxlSiHtKsz+Qj5TKZFtq93Sc7K9qmuYcpSa4PUndX90//6HV434CyxKy?=
 =?us-ascii?Q?OJtuNmBilZ3M3Pujs2hSig3YUf2XWyjYv+lCkU4mGaBiy9N7oa7mU4Mwk1V8?=
 =?us-ascii?Q?5kYQGSGdzj/s/XIqC7XWkzdDUv9q0hhsLE4YNW8m9LsEJxND997X1czwSM5W?=
 =?us-ascii?Q?IrcZ3DhpjiZ69OeAMkaJKQeUiIdc+vpYvlkcsiP324vtzOK6TKvyOOGHL+fL?=
 =?us-ascii?Q?pr82hf7Dzo7/FbnCl8L3ApvPkqnn9U1Jg7Cm11rDxby7beAMi2NFO92BYhpb?=
 =?us-ascii?Q?VIQWEqJmLxoMxPw3DlDYb9N2B4mcFNVBrxpxzZ4XlmCc32ZpDhygyMWHHEJA?=
 =?us-ascii?Q?QDi2CDLmb39hiWgFgy6DJIbtT/74vOyzNwbgGkA4hWs241y53i9TKoIb/fBW?=
 =?us-ascii?Q?0V/IzTn2aRoPHa3Bl57Ee70ZzmqWD4RS/zE+AfuZsyazfP4l5hZAByQemLTV?=
 =?us-ascii?Q?u/2n1+nn6kjWfHEw9IvhS7E0NH0hMkK64Nn/Pg/5AcFtuYgHCP7yZkvy0b0+?=
 =?us-ascii?Q?1u9B6Pq4k3bWAflV0J8Fk9McUxtMtCNje26zTRZd0fGa0qa02UjxtTjjSnyS?=
 =?us-ascii?Q?NPXEVAQi40LQmR4LKFhghKX/Jf5LgI8GgDFFDkWM8d8pV07ycMHj9+h/9yF2?=
 =?us-ascii?Q?OJ7A9DzB7ACCInTfi3XrhGGkxM9/J7ZwIEhH3NZeWw25kzkR64myfgV6OHle?=
 =?us-ascii?Q?0i/FG267QJ+F+hhc1ZwuuMg+y+vgGy598e34B3+zYzZQ1bPQLSkngHcx6YAB?=
 =?us-ascii?Q?QxSV2soeIpDLOBMjHpzBNNx2Q7bCUZZBvtdW2pLu++iGuJ5mhtt2TBTFD3xp?=
 =?us-ascii?Q?V/BxvJZ/tdhyWbNYyNzY/K5/G5VoJUThHgN04OKawfXrE0g7AE6SGUmXsGG9?=
 =?us-ascii?Q?txfrKtVkg/chtOyT1rnigYffNvnuHjWLPNVaiu7ktjWfmO/aesrF7leEVSEp?=
 =?us-ascii?Q?XAaTyQoAURV/MOeXEgGtFShVDHny2BZkvNkgnk6i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5106434c-214a-4bd3-9467-08dd55d427c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:44.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIfz1B2HKzBfSly3rJ8BRFLXvOvrw363lX7Whb1dzz0cxFh2FJvM83kRb39E/lHQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

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

