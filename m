Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D04F23717D;
	Tue,  8 Apr 2025 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131264; cv=fail; b=pAUo+aMupBas/8soGSLbJuqYY1s2w+b2HmAmHe/Mc7YjWEedwMk183gOf2SOmCDeyq2mtq9PJFHYmZDMdT0ZXrJORVIrzXQrV6lLv0V+hmnHk2G2H55rSFZMEUi2+5SwqKTbYvD9kLtmaVPyRh6K5Nu1PqIgF6dGwqkYeb7L9pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131264; c=relaxed/simple;
	bh=BEzGcByKBzSfOrV8KoFTeiIYVMGHR2xVKWo9Aqm53kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H1JddneB4soTD4CCgqUx7YmHLhNIv1pukyONeYPcGAxtMw9IXzpn0iZKVeCxvCXd4ZLanrWUVYVImZFegRzDcoSTj9I6rVxX1JpOZka6DWfnIw5ma5ftHx0qSzwC8UDFk/pGGyTqxld0H8UEPE4vGlkN5p2BnbKc1tSm7rUjIgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aPfz2cjO; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aPfz2cjO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LvbZMSoeY+kpK8ChAGeytm4OBw45QQXSJTjFPj7AgLexyo/pbKq8gRDe6FYSjlePuy13JJhEfnzynJVIt//FB31ruHwwqnKt8A5lvAgftq6Ww/DAvnElZEpKzzRZH5YAq+Jt+E8c5X1iLNn33fgjS/4DCWRY780iNImGnNxuOJtxCH0aGQeFR8FAu8wmuQeul9YMfhNYJdnGTwLqsL0+cyb6NKaoM92M80o2ro6fNGwrHMbeBN2fhm9BZZ+1l1bPGtaZtLGn8aLdPDsgV5SJXT/mwPli2mwHDry9gV7hTtSP0gXklOuueGSHAU+KvMNx9sdeMUPZOaxgs0dDXhaP0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/CcqvHaatxqxCBTUZe70EJygmRlsAChel0RA2c75rw=;
 b=bDxz1DkYSiOB4OS6nL5NAAShOHS1voFD0DOSp0vM94DDUp21peu9U1oiCjP7lxmBVINZyxRD4kDV4htt+CEDwCXRrJk7manyqAunsJHP2CsuqLIXIL9PvR2tL60gWBKx4cDio2/B2x8t55YfoYHw1W6bAw4oKC2lRBWQ4yIfKiH3p7PLn+OgGd+cF/5qNfn1POHy83TdWqczm/WWP+MVfwwNq5vJ1I+EEMicnTpBl+Y6v3IE9uVoMG+vSbCMZVhNJ2JMLCTd8ZIq9xrphXYdCMv659krzcgZDmC7h2MGI4dZhK4P1cRKKL4VMcHCNEsM1TqzwcUqvcT7ugldt3mJkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/CcqvHaatxqxCBTUZe70EJygmRlsAChel0RA2c75rw=;
 b=aPfz2cjOD1Dcxu+ue2YCAmhzEh9MARiO2rAn13UYRv+0aef2RT8wTr+SjifSddQEFfdlUQW4eoSe/RNKSYy6lGRp1NgZtHLaM4lyvAE8gFcVSrwhQwA9ZbaZRS1a0vgXamV6HGlBwGoEeNLmH3pZPP5YQAVbV4IIwKsl/lFdHh/DGAkcFJ1Aeio9mzLRqg2UL8maBVsYO/6+1iCeeGoHvJqpnF1gwJArznK2LHPtIW1HQvfuCmdxhtvSsoWt2x5qG/fAI+rKxNPLWwB9B/I26KEak5A8oUG4iRfDDKxRRjauWS1ZQrFyyJQhOJu7u4NfJnB9hnPWzhuCyUS8bSKRqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:16 +0000
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
Subject: [PATCH v4 16/23] iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()
Date: Tue,  8 Apr 2025 13:54:04 -0300
Message-ID: <16-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:408:fb::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f6b8c13-befe-4218-9ce2-08dd76bdfde7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?su9ZYrFAOM67EtSO4Kizv1uF9qMlTBWK96Kav/+/AWyTCx3yih7PBrtUiw77?=
 =?us-ascii?Q?S+98ckKks1AKmmJ+ggIYTxyBz+zVmW6i4wGjhQ4xA1bpIKxRiktMfM39q8fM?=
 =?us-ascii?Q?I+EY+8dBg5NXkrwDo3TUlE8q5FFO8FzU/QvR2WNoCDwZwwpkBImfWdZ6k3qI?=
 =?us-ascii?Q?1nwKnpNpKGEeRdE94uSeIHziKXKsUNyvSC1gD7zlabANamy934rVEiUCQof1?=
 =?us-ascii?Q?6jRO1i24Memt3cBphmWPfQ9zjD1hLVefnkQw9qwm2wxzXY39XU3+KM+y0xgN?=
 =?us-ascii?Q?CnOBcGVm5x5aUGS5M0SxKPHN7Evxibrr78BbZVFi39hV7TIGUPrTHW0RXdUY?=
 =?us-ascii?Q?1XJivg5qrsF9s2soLhcVjX+ADfuBEh5oez8dgoK6scK80UtSNuYbx7tMohoB?=
 =?us-ascii?Q?AoV0MXh+V1tou4vcV4OMyHNQ2F//iu5S0ItPUPMSQ0pzv/cPI4V2jhmatNV/?=
 =?us-ascii?Q?7ATupDwVhcA6n9ET7TGAC24GJ3BaI3mqx2u5PDrP98oktS/RgNozrFMiC7d1?=
 =?us-ascii?Q?HWg6YtG0L1OaKGV7bG3UVYNcvN4GfqIZOA/8WX+FVitxFUTl81HZKCn2XgcH?=
 =?us-ascii?Q?w2etgqShNdoylTihUPEhJjgKQRiyvir0QwAybfM1TzFNjYSq5MQCoQiOZuPd?=
 =?us-ascii?Q?xAwAudiDRATueKQlUO/KQmJ5uRGpU9KuL6f4ZYLEVaL6KK9AMr/W4dx39tBU?=
 =?us-ascii?Q?YGLLHNwRQbX/OOfoUDhin7k72vOm+2tYB4SGdUlR8bVR84u5TOyvmXGd6919?=
 =?us-ascii?Q?tmZko/DdBlnkh3Upxww+bbo0gkQYONYwi3Yh8/Pil08tgn6GtB8DlVZe69Gb?=
 =?us-ascii?Q?2YPBFob5i4bHdH/rkGM+xmaignXXXJNZkq1CaroN9pVDf7Kgz181f4o+j0mp?=
 =?us-ascii?Q?RDfcTmnjlba1/+oqLMvsAnqqkaOvW8ApcUI0hCHMS0ulevfftSqWK1zJQhia?=
 =?us-ascii?Q?tSw2NG/pM7ckUCB1FM5eT13t4WTSNGGXwHX382ucHNv4QnJ6Uvl1IEGbQrwR?=
 =?us-ascii?Q?ubvvht2/yQpxoh3EaP3/VX5YB9DgRs3Ow1gRYJTTPeN5pj3d77KHwpE/0Q0B?=
 =?us-ascii?Q?t78ANvGFhQeOxc1kO3rvSbaLEb3U0twFA+r/c8h7xNnjJs5kzEB6JTIz/NS8?=
 =?us-ascii?Q?+fGnAXFv0uv42niQRDP3i8Eq2Dk+DwiMjLrw30n7pdW47xf40Ze3mT0CYcnL?=
 =?us-ascii?Q?fE9BL6m2Y+58hpkVkZ86/uS8ma/HBkcngLE3AJOrXfX/ElZgx9eAAVF82spN?=
 =?us-ascii?Q?ILxmYpAd4oNikIuuwQ9zhBrxuc9Sec4OYeE77I7b5XqQuoG8hGZTqFA0fPz0?=
 =?us-ascii?Q?MeCdjiKGrS7gwUo5bDae/gtvJvnHbNWA5sv5Svq38rlwtJIDofyvdZaCcrMn?=
 =?us-ascii?Q?XFOEcaMAZlo2j8neEucxtjg53HN5USfxNXPwZZOhqfXEt0RzCqcT44o/q/7m?=
 =?us-ascii?Q?vaPygYyAF6glLeBSb/PtfEtPFhAH+xLcejc/JwTpoQ//x3ovcFYK0g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OjggxXCG7jD52ArL+6/UJcHDtN8NdyS2fzCXWA9lNcVjIjhgRzpEJVDMoTUZ?=
 =?us-ascii?Q?We1i9hut4yUPMDikBRGhOExs+IHpculPHssbaJRAhPPaoKKM0HKsBECatfkp?=
 =?us-ascii?Q?cfLGlqICc0eQmJuv+pUCUixLwpRfY7EmRJwTbeKK7zoK/WwtIXhiXnEF/gTS?=
 =?us-ascii?Q?oAeleUFdbdrMSKX3JuJASy5PnlzqwTxhAhcqturhEYfcnanu13nSuxxWqkZ+?=
 =?us-ascii?Q?e31mus3ggT02jr1TryI7V+hOnOrI7emZcm6OCA2RcfoCbqh8T3y/tfjFi7Sz?=
 =?us-ascii?Q?ps6apKwhmv1QbV+EB/6ekerWk1XWdWU6N4eXZcGu1qGnJMgl+9mx5OuCjxrT?=
 =?us-ascii?Q?IS+EKogCv4YPRLMEFYMPHVP9D37P2rG2afdCBqnccvpnxdx09OBpquig7IVk?=
 =?us-ascii?Q?qV5ky8F4+++gR3GZKZZUf39NL9PSc52SYMpdESBTgI1tHuMUbB8hqPHdQJ9k?=
 =?us-ascii?Q?JIEICQaxEYVKd94nuvVc7MMhnxvpohglIpO0bjNwxPy4HCu+KvkBtHcJvao7?=
 =?us-ascii?Q?aFF92fU9R//n7AxhSx4Ceac5/dloL58AV/uXDWR663saYlOFaHBDTbra7lwY?=
 =?us-ascii?Q?ruYFNMRZva+uID2qSdAA418tKdNuw73IU3hJAzrnShXhUIBsefBIJX5QOqOE?=
 =?us-ascii?Q?ULEahOQdV/UsoS+TGOJS66/fsxbXZUEI2B+Enja27qmc8xD78e8BIiqvZ5n+?=
 =?us-ascii?Q?TrgSTvG0b770Ws9mpuxrQ5Ar/KgBx1qDJsDOiETusrtAEx7y1Gx/OsMeNz4e?=
 =?us-ascii?Q?32+KdXcheYPeJm0Fo0QELlty10FCUYISRK3xjA/8ozia25XtoFmguQxDRVpg?=
 =?us-ascii?Q?GJf1/79fPIiw/EhYcTSsz+l7p4H+YpFq9S9ptOVTmTlyj2GKDMzJ7owahRts?=
 =?us-ascii?Q?rLhCWVZzcP965+jvnp7v+p5xWe4peqhsIamIVI5aaZlPXpFKXlUwlZt2G4pt?=
 =?us-ascii?Q?OgEW18DoZSfN7qhNcg6USRfNj+Znu3t75RzGLai1neBnLgO6VcJKDSmh0Pp0?=
 =?us-ascii?Q?8u75zv1IgqgXC05K2GF8OL77wZ24xoGvccEx4TwKyV3HncfVl8F7qIxAjOEv?=
 =?us-ascii?Q?aO21A3VJedApLI+Eatf5GkBfRCeEr53L9gb3lu9Lg74VBjrIAI7W1bThxq4X?=
 =?us-ascii?Q?2sSrHGvB6k07EPf5l+A5YU92vBHhASfMLQ0EHBivbCN+tMA4mKtE7zvEZSYr?=
 =?us-ascii?Q?hgO8xbSDgoIz7Fnp3gZS9KSC+Ud9tcJNjlfPJd97IQWkp41S+WxTmoFRaAaB?=
 =?us-ascii?Q?ZBR+gFNESWBTBTrUioMKKG7/rvfmE+fBaH/KWQgjY0n+7BAERiP+tXA7oFsT?=
 =?us-ascii?Q?2IWu7Gh16VR500dwxfUdVSetEy4LyxQXK78pbMAUtsja693FwOcWQw0geS/B?=
 =?us-ascii?Q?51+xK4qq09dTj+gefdn+65ZLSpJxGZMr0X3XRuhUTB0BQVuOUS2tMFKNeYoc?=
 =?us-ascii?Q?WxV+UXLh/xo1BUrOMnuLIw3fZYOwJNGWAH4LlDhvoQR/Iz+xvULp742EVP0J?=
 =?us-ascii?Q?Zj8ocOtyvpMXdFWyfc5krYrRbhYob6kEFVSPazg9+fFcK26G4WJgnMExb6BE?=
 =?us-ascii?Q?MS7Uil66WGTJKhGcDLX9LLFMynGrRLSsC0BjVo0y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6b8c13-befe-4218-9ce2-08dd76bdfde7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:14.0947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOfVY5XAikJZ6yTCyZ9Axf3DY4Vp3uIEv+duET3uCQ/GMWbEqJ26mE6AjR0ydq2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

This is just CPU memory used by the driver to track things, it doesn't
need to use iommu-pages. All of them are indexed by devid and devid is
bounded by pci_seg->last_bdf or we are already out of bounds on the page
allocation.

Switch them to use some version of kvmalloc_array() and drop the now
unused constants and remove the tbl_size() round up to PAGE_SIZE multiples
logic.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h |  8 --------
 drivers/iommu/amd/init.c            | 26 ++++++++++++--------------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5089b58e528a7b..5ea73f08b38801 100644
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
@@ -616,12 +614,6 @@ struct amd_iommu_pci_seg {
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
index b5415dd19426ae..3acdbef8fbbff2 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -651,8 +651,9 @@ static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
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
 
@@ -661,16 +662,15 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
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
 
@@ -679,8 +679,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table);
+	kvfree(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -688,8 +687,9 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	int i;
 
-	pci_seg->alias_table = iommu_alloc_pages(GFP_KERNEL,
-						 get_order(pci_seg->alias_table_size));
+	pci_seg->alias_table = kvmalloc_array(pci_seg->last_bdf + 1,
+					      sizeof(*pci_seg->alias_table),
+					      GFP_KERNEL);
 	if (!pci_seg->alias_table)
 		return -ENOMEM;
 
@@ -704,7 +704,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table);
+	kvfree(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -1596,8 +1596,6 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
 	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
-	pci_seg->alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE, last_bdf);
-	pci_seg->rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE, last_bdf);
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);
-- 
2.43.0

