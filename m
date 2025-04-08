Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB1923C8CC;
	Tue,  8 Apr 2025 16:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131275; cv=fail; b=Lar0a5JA1cLzZAJ2yuCJDNxMHuTwlRqpAxBUrmVLiuxv8aF75MU2q5PBqaqXVPvmzqXJXGbMdaeqRyLngSk+Y3MvvTQVSgWl4ALh7zbfpf75l8yG6qdh9i5wD2BRnxI6bm/rLGa3WNxcPvTt5nYxk9niNSH4CbONBo2cVPzepc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131275; c=relaxed/simple;
	bh=EwUz2zpDl8ttuhnt8DzDNLoEp4n5kn4u/oKRixT9+cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b3yPkbthssAJCn+hY+PtTMBCnfgY8beRGIG/w9puQASO+GaJ/gGwCJ5Sm221OsqzU4g8WQMLYhgi1uW0+j1wyT8mJ8RXjYPBV8f45kZM/74XeD9YNRDkZfWn0XxdYYGARrht+PpQEFpvKwPfyelegnxflj2k9ftFnVbL3X56XFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kkr6nPb4; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kkr6nPb4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lEp3PcVo9RzWfkjGikgbJc4QsuFSRf09PIpZnd2kYKsV8LEL7St/O6FgPa2fQS74iX20wqIIBXYnyKk41oQermSnLSRje79dt5eDT6q9mRpvygHDeqGEsFAyJxiBV6Z+sV/kDsvFcE2AbtGO33KlDTF88EFDbjL8CqftAmNN7X6z1Hl65jx9Uw3QZW3KV4epQhGZ+or1IigbxYsL6Ive9NCYIeV9TYFLmPdMFIPhLXfv7trUPMpLIWBsXye9QFaVqSttEDIzwI2zNSJlP8iNvOPMFB+UcLANtb/9CxoYoU05Zthpy5HEmyhhWviPH6ImaJeieK7OM0H20D5xf3XsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOMbIpYmrZnccYIV89P8MSgtHZzA8Ua/GI47Fo/WeoQ=;
 b=nbI9fgGHe1gPwzllkhDmo7t9ITqcCUtOR/xg/ptf+3SrRYQeW0oLCID0H6kx1Vy0sW864UvqIcyLClih2KUB9z9w64CVMDaHi6qJt6NRNtAyvNzGdwcerrqc5AhyRyyaaWMnDsbH1tCVCTox8ORv5Y+BIBsO6oymqxO3u7fwW35Vf9tACt/q7/DZTzuB6B/BfLWfEDmzzA++EpttqUwSie2GnFX1DZ7xlfN0v3lMvUkp1xLtqak3nIbDZfR2Mwzrjv6QmbB6xtrLoNKngcjNDRWXE3uHxFxMxgddKg8ybRRPLPMq/acvrY+hYvAdVqqXtRoD3lUz7Fu2VmEeI8Qpfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOMbIpYmrZnccYIV89P8MSgtHZzA8Ua/GI47Fo/WeoQ=;
 b=Kkr6nPb4QkceM60udPp8rNFrBQogT3C+wn39MHm5DDbQjO6C1yIW7S2ubJcmQq3mcyB90zgZ3MumFhhMbGp+0757smGR2ZwWmPlxDp9atCj+ti/9Z9GALj/3N/f3FKmPCHG5klpYWr2IqfajDKyUkjK1y74STDzVaBx7xj1/dgTjMKtXLJUV39hwlI+LRaDu8VUUp6/zQ052cTn2EX7YGvw1akR2CaAevCgBOP3r//fTD8rb6KBSLLWfzynurh+xox0lkT7DmGyHMWxPN8DQvSA0SiEu18cDREZp5Irxaq5ukTJeeeQxdnVKZIePmbT8X1oTPS6Op9KFYpTSKuJzrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:22 +0000
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
Subject: [PATCH v4 10/23] iommu/amd: Convert to use struct iommu_pages_list
Date: Tue,  8 Apr 2025 13:53:58 -0300
Message-ID: <10-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff1420c-8e3d-4f6d-2093-08dd76bdff67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e1mgG12ZD9YD/OdZetbga5NPgflwgtOkf3nQILgl4sRE8OlNG38iVR5G6h7w?=
 =?us-ascii?Q?ma6ir+d+yHQY3BUxcprTibscw43KW7kBn/xzYQeKr1NlRvnA0Y5eUAEr1h2R?=
 =?us-ascii?Q?PKSsOqNn0VA5b1YDMztUJKofqSLAtrtm07ClSObGgEiCxSKPXHWuD1ODlwYz?=
 =?us-ascii?Q?CvnJ2kr9WEBdXqHzdFhNMPs3HEhhR4zPhCzlF3zvO4joNZMc1lOWCY008dXf?=
 =?us-ascii?Q?wvyssNmsUD0JX7S9X5EvqcrWU9dYtMOFBt6bNByCPTq8z3/LtrmDN6/MZwJg?=
 =?us-ascii?Q?ALiXR5lqV76lWhPITEx6h9dkbZ3Qx3iBModAmoUmErMfYSYxtVseLTrAkd2T?=
 =?us-ascii?Q?VUOqEZVVOE4x8NPe9GTFQQnTP3UpkQHVZWYpFbGHIZnyTpDb+EvrnVXIM2lO?=
 =?us-ascii?Q?xZudTIidbp+fNIGk2sPD/EIrrO9ng2L5LiUMBkbN8DKlyv7e4U0it0exYUWe?=
 =?us-ascii?Q?TTjCpiZb/lFtPqQrg6FpIc1vTnRJuycDO5PI5zLtP85p7SnoZhYkYm4TpJnO?=
 =?us-ascii?Q?EqyGmVNpsp2532YwTQDdoLZUTGV7ZHULE8MM4inIUEOWIygOssNnG0xiTxXh?=
 =?us-ascii?Q?cnPQczw6c1h6eouB/PfnMKX1aPPkGKopIIt6hiIxsJuEy6rdz6DcZ012sNax?=
 =?us-ascii?Q?irViuJPi9JeEXK+2lIbjc1cQKo6+1E5OBK3wMrZHLYBBUUB9Z6vNUfLcH2bl?=
 =?us-ascii?Q?U42+kHANzmosmEESk5KVrrYCU2ekH7Xj7aPPoUpoWsIY8bim0ZK8y9yGClkC?=
 =?us-ascii?Q?DThBNord0LtTK/3UM8uy7by9vkN0OofFErUk7EkTPdqha2ZmRE9aNBppySYV?=
 =?us-ascii?Q?DCdUW6lRiB2B34bNoRvbbDKX5C8fDVbRlpwhBFyfbuukmb9wAXwOqvOjwqKh?=
 =?us-ascii?Q?psw/Hd4/b68aKQnh5vS46lTVwnAmGBcgQSuuVtsusxQWTmRKLD9bznxdT5BP?=
 =?us-ascii?Q?6+ivuq1U/c3n6SKOG5usS32juMtdzJ59zAeAlZQJ7OCKW4yYvJKp7ZnK+ZJ1?=
 =?us-ascii?Q?CA/hRvdSTxvg3BnOP9JNoI5liL7ROT7SHNFKNsCyIWK59HxA6KCTLkn1CsxW?=
 =?us-ascii?Q?tro8H14FEJ4nSRSJOsWtv1YHqIu088U1v0OQ1dRnU9YPC5TzwczmPxgk3J5B?=
 =?us-ascii?Q?pNeFCO2KgxbUEdk4eqHP/tJLbtD8GSnSXh14kbKs5Yl2JXa6Yml4AcIiDgXp?=
 =?us-ascii?Q?NRNpW/ypvCEPIHDiUEf4wuelYLaIWNXpWWpB6ONGighMb7adNZ+s+kdp7gkA?=
 =?us-ascii?Q?mRDfsx68eOP01GlPUtb5HypuwBIhw6ymhbwhSxizWdiQDFR6nTlrqw4776pZ?=
 =?us-ascii?Q?3xDUEPOnbZB71aFjFGv0RY6WKB0Vw5UVaFzokiyhqyUxmeJpV8gj2u5mIPYZ?=
 =?us-ascii?Q?Mk5CghZ/w36sNLLuubcBx1WLsMPOl2KvOjOO2Ps1rp2h+R7rXq59Gc0pP1eQ?=
 =?us-ascii?Q?Ybfc6alsJ5tBhBdiSq9irP4dtUzI0/lyWcianmN4RLr0L3FjVuKhTA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gAVMuCMUc/bpqZ6e45CKzgedA5gHPpzqfgZjgUp217god5GZjkIqxutHiwi7?=
 =?us-ascii?Q?HZoTzXw0PRaha+792TKoRzH9Y3HXcDP181NXJpibVE1PQm76X7RyuFcLOUp6?=
 =?us-ascii?Q?pbVrVSYuI9ui2vtNl732J2fJaFei5M31EQ9RV8wMD+gzJe80HM1gfp5jbJK3?=
 =?us-ascii?Q?SdoKRyZ+uOpgVhOu8U8SX713OQQ3f7xRDL/ght0D0Vos/lhraZ/G1kPMn5XB?=
 =?us-ascii?Q?NGl+uTCblHe9Lk0azeMq1+TNDp3BCHTDDmbZYUmfSkhUqu2FV15GmH4bUPWX?=
 =?us-ascii?Q?GoNBInOlqu69Ut5kOcARHkmsaKTT41dhDsG5GNZQnyCR/ZdNowblHN3QkBNt?=
 =?us-ascii?Q?RrKZeqkWiOiqI+x3Z6FEVZ37mOuzMe2K5VmfZsCFtM83+Ke1lTwNO5YHsXuZ?=
 =?us-ascii?Q?RsiBMtOlMF1xVap0CE9sWnZs7Ys779LLniLyaAQ03QLBTm/4iVcy69Vu3Hca?=
 =?us-ascii?Q?zlKVbP8HXyBBYjnSPYEzGA5xt66C/vTzdhM+IjPlIQ4MALqi7qtYSdJf81dL?=
 =?us-ascii?Q?EUCrpUFtooIppF9bZMi4F5LnYMZKj8/TrVtl0e9s1lGLf8nTeHvd2iMyfy2J?=
 =?us-ascii?Q?kbsR8TEEWj+APhRYxJguZ4Dn4DcH0sbU/GGDQn/VSYgdKvznks7g2jPcUFzF?=
 =?us-ascii?Q?eylfuRZt9/sdtZpIoTHvfIQx0fQAB5Yt1gu8ewWjE+vMJt6ucwi5Krs+Vpzc?=
 =?us-ascii?Q?GhIgenTqw3fxa+HZ+S2cf4b3JYUXYH8bj2u5ymvOhDFCV38LFjeN+NHyEhoi?=
 =?us-ascii?Q?1lE/Uuf+CfAxjTplcY1GkqxTyx+9SwGkV9nhavrSPrpnlgJ2cFhvNhoVqzfe?=
 =?us-ascii?Q?J11gs/M2sY9Qa98acGk7T8rUTiEghy54HbMP8WfncHaAyEwfJ17vLuCrPuaG?=
 =?us-ascii?Q?L325WPouoemsf9edm5QX+h00YcMbOzgXUAWqzywlBDW19pxXLrbMpTIf3KMD?=
 =?us-ascii?Q?9uip16jsdSzUlDi5yD4cEMhdRi7z8xdZe+9qbc3xq1kcj2+xDB/+qoHHd/YW?=
 =?us-ascii?Q?629MLsAqoAJfrRjzLe57ahbkpIuYuJ6CxQgah/DT/x0CutGFW3iIIg6Qa1JV?=
 =?us-ascii?Q?/ncpn9jwSRUwUyovHqzyidi/pKvIgApLgaIC13bgP+ovMWj9vNbt7nYGnAPi?=
 =?us-ascii?Q?pNDE5MDs6P6w64ssjWuSr/Y1N2QouJN0FZJ9u+bhBanMOtQ1dMYzm5IyYziO?=
 =?us-ascii?Q?2h1l4kcp0JL+DSVvGip0DBUALPl72rwRis7ihsg25C/7omHYfbla+Mlg7RKC?=
 =?us-ascii?Q?Cs9P2fpTXsP1MRg3uYQPdc8hfbO4sK0ho50nynDJ/rNJC8qrGqxCjkwzovcK?=
 =?us-ascii?Q?YI74lUuZNlXN32gbuvfEisILsmsiak9Ffvg472eq8s67AftI+F2YQPs5Ly0a?=
 =?us-ascii?Q?/7w32rS1G09WV99mnAsOyh8oYGyocvA37fOV5qzTITNIptXPIBRe7a4o/hJh?=
 =?us-ascii?Q?dxJbwGdumTfIiwZVagy/d85Rdmfde27XJR0yCnz9PuWB0K/XRYoo3wEkRV23?=
 =?us-ascii?Q?DwC5GgKnKzmUBDrxmjPTWv1AGEF2/lQIDOedO1K4f6B8Le+XLh5ipUyVu6rA?=
 =?us-ascii?Q?XWLbQMNPQc6iDi40DMs4yy4zNQpexI4gYOXR52Og?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff1420c-8e3d-4f6d-2093-08dd76bdff67
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:16.5679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYmXri0hG9r4hYfkkoFv0T2JyouWGIW29bAKuKTngD4Y4T+vy7aeJHmgr4SgGUqK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Change the internal freelist to use struct iommu_pages_list.

AMD uses the freelist to batch free the entire table during domain
destruction, and to replace table levels with leafs during map.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 42d9e6746dee28..97ddadbcfb54d6 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -47,14 +47,7 @@ static u64 *first_pte_l7(u64 *pte, unsigned long *page_size,
 	return fpte;
 }
 
-static void free_pt_page(u64 *pt, struct list_head *freelist)
-{
-	struct page *p = virt_to_page(pt);
-
-	list_add_tail(&p->lru, freelist);
-}
-
-static void free_pt_lvl(u64 *pt, struct list_head *freelist, int lvl)
+static void free_pt_lvl(u64 *pt, struct iommu_pages_list *freelist, int lvl)
 {
 	u64 *p;
 	int i;
@@ -77,20 +70,20 @@ static void free_pt_lvl(u64 *pt, struct list_head *freelist, int lvl)
 		if (lvl > 2)
 			free_pt_lvl(p, freelist, lvl - 1);
 		else
-			free_pt_page(p, freelist);
+			iommu_pages_list_add(freelist, p);
 	}
 
-	free_pt_page(pt, freelist);
+	iommu_pages_list_add(freelist, pt);
 }
 
-static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
+static void free_sub_pt(u64 *root, int mode, struct iommu_pages_list *freelist)
 {
 	switch (mode) {
 	case PAGE_MODE_NONE:
 	case PAGE_MODE_7_LEVEL:
 		break;
 	case PAGE_MODE_1_LEVEL:
-		free_pt_page(root, freelist);
+		iommu_pages_list_add(freelist, root);
 		break;
 	case PAGE_MODE_2_LEVEL:
 	case PAGE_MODE_3_LEVEL:
@@ -299,7 +292,8 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
 	return pte;
 }
 
-static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
+static void free_clear_pte(u64 *pte, u64 pteval,
+			   struct iommu_pages_list *freelist)
 {
 	u64 *pt;
 	int mode;
@@ -328,7 +322,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
 	int ret, i, count;
@@ -353,7 +347,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		for (i = 0; i < count; ++i)
 			free_clear_pte(&pte[i], pte[i], &freelist);
 
-		if (!list_empty(&freelist))
+		if (!iommu_pages_list_empty(&freelist))
 			updated = true;
 
 		if (count > 1) {
@@ -524,7 +518,7 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
-- 
2.43.0

