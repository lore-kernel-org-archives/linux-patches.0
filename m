Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4834268C69;
	Fri, 14 Feb 2025 17:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552909; cv=fail; b=jPruCJxVfu/pGMtGhLndmcr8C6X3/pBCA1JOsOB1KQ8Ulk9Sg9apvwAwLB39N7GAY+FiJM1trhbBxBeXwk1rRsPBJrqwv/r3toOq5om43ja1luO8O3S9+gRe/ZsPmuAwnvq1VLSYO05iavWmLh3D2/K3aOT0Z21sevABDNfFrIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552909; c=relaxed/simple;
	bh=wCczHAv88B+Ou0XthYvRpFv5NImMcfTgZp+PxGyuyfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KYIp0La5LoIKiz566PIsmICn/Q4i2ppHnQ5vm+bkG5sBRzJHT238IrRnUE+I1fOyDjMwFJs70pn3xXJLR4oR9Z7wZyd6FgFk8wg8G2hkEzG6ZEiPvwOtkt2Hi28WfXNwNm4Cem4QPxlP4gQlOQPCbrYnwkHnk/35FWPIXOhArY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tiqszqi0; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tiqszqi0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zTD2Z9IxnxJlKtMe8ziDhf3qOv+STBdJXyj7VCdgMk05k7re7xz77sjyCCuh0DKyAfSKxJuEDpM62UxbWbtrNNA/+wcoELE8Rt2lrtfzAp8OXcMWQq43Uda6vghe+ZCBJAzQKBdEZLPX2K65uSu+XLuuQorousKbd7/6eg8EVc6w1RXe4rrwagcgb6OopVOEXzOCEetNXmrlbBqJ1985LaqkwVoxBUn4T76gpRHVTRp+ZxhAu5SOFO+bWRv5hKw0UkEbfQf5fn4jeQ1dRLm+xsMtsVbPy5iRHTpO35AMh9ClclJKbTgn/0zcyMV5Mx3jVLrp/PV5aJl08u5EXkdlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ls8imfyIqmD923mL3/n6HrytShoMVJl46mNDwyM1gGQ=;
 b=dnd0aFzir/gw7r3KLZaUyh7UW8n/4fBdSNJrKPPXgwkJ59xNVQQhjlC8JsLo44NHNAr2cdgC3tKQbprextAHG44iUBNzPuLAVhb/yzelhTyCQwJJxUSMJlCW3HkOCwiDri/Wfn5JmoM7iNPAqZq8KkFVmz3+VUb2nz24EYcFHbpnh5wSPfahYk/pSnJNDTFiWAcl80bym4O4THLrFriiLWEs75JFQ61Zq/qS+oZbnhda53UbSWJp7WDIb7w4R0TAC1/0mkoP2R7D62WZYVk/LEFNgye7m3ZdQ0yYVNmmOzyVx2eK2AHTt3NpQ2IH1HujwT35vqNAu4z5TvQChrYB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ls8imfyIqmD923mL3/n6HrytShoMVJl46mNDwyM1gGQ=;
 b=tiqszqi0tpGCV/A87xa8cju6rt4fhfCRQ5ZWsW7OWiKk71CSkdY/540uq/dyNF1nwG2TjwaeKdeHly9vQAU0I2jy80TOabd8ukR6b54AHkcRtsghcUsUyzaoRFAr/mG1f0FY10l1m03R1omLbDW+mtRGK/WQoEWyJZnpB0ycdYoi5pHteKdovRL+v9nbr81M6cCVZoP2ViCYLnsb4c3TAyoXfKlsPMzHr9Qe2mQKP8Z/cKdE7yKSl+dgG8f3GoanfmvX5Ih/X3kTDj2hmw5NuUvHUlKuaBXCZdy4rgm6oXWARUuUvIBbuYVG8WP9JGCEbZsFLkZMbuoKYht50kNInw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:13 +0000
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
Subject: [PATCH v2 11/23] iommu/amd: Convert to use struct iommu_pages_list
Date: Fri, 14 Feb 2025 13:07:44 -0400
Message-ID: <11-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:207:3d::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: a3a189b2-6451-4bb5-6a38-08dd4d1a22f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HxgNLAhefkX3D31lLcJFxlE+0su5u1xMbaStEbZTNzRhXUtj6zKXm6XTiJjS?=
 =?us-ascii?Q?EJ1+WPy4FS2LgBnl6lYvC4VwiCD5HMPWOE54cNc8G/VaD34YCFeM7CBGrkfp?=
 =?us-ascii?Q?dSjz7kGgNHyZTQiASDh7NDCuSKk5H2+ymQ9vMGSqDWU/d3UpCB50DVFsQKAq?=
 =?us-ascii?Q?ijW4Ul9veCEtdGq/N+6BgdbKBNvyqRYl+R0yUWv+1zGiTFT97J/Jrw9sVafD?=
 =?us-ascii?Q?vl7nCp4d0jfRootmX3MD6IhYeCaoMivvUNqOjpPnUM5xgK3rB6wJTWRfRq3t?=
 =?us-ascii?Q?MkJ8OQuMbm+y40ZMNnvMxSW6Bx9uCoongKgwkNVz7kaXfcQxZn1VfahVJwQ9?=
 =?us-ascii?Q?cWK8ASkeCEx2LtRoVJDaeSOy5mJW1KyPTsT22t2jI10Eul7Gcdi440IDS+Yy?=
 =?us-ascii?Q?4S9roJk9inSDt7g6Yl1vGHTMFa86Zh4XcsjImQlmR/nhdiOeosLVezLstONx?=
 =?us-ascii?Q?1+nI+4wFN6cM6sv2JR/xuF2OpHHquQUBxOhazma4XgzhyoQrIXHGUJx78LHh?=
 =?us-ascii?Q?WbfqWE6odIj49oFhqER3eUAOoM024dr8fEH0SyByMwAGreHD0UXcZ8laCPJA?=
 =?us-ascii?Q?5KPPv0yIcN1BvtfAZVyKSU1wjtZyJhd6KMFtdi9arrlmFXaRs3QEhMdgMMQx?=
 =?us-ascii?Q?qsLHAamwoLCdH3mY5JG81Cv2ldNUPjfnwYXEuwRvo4lAMh3jxhgNJnPnlkh9?=
 =?us-ascii?Q?+gec36KPaQxDqhS8TqrROnuCTnSDSok38Vk7r+eNcG88Od7YVA5bf9Sue1ql?=
 =?us-ascii?Q?LbITzY8p+FJBimyW129VN+aQ/F236YdPGDaKjVvF9vxf1zR8JKrV9uOgVOmO?=
 =?us-ascii?Q?XWtQiLrxZ3QBDV6scufrVUe9UZM4rM1CpvICPkIdHETbXvQcyHVQMc7+K64u?=
 =?us-ascii?Q?F+EKCqkUw2IEMBPjODVmB8c1O8/9buX18wjOi5Qt4pBY4bl6CcL88q/HpFP7?=
 =?us-ascii?Q?xXfp8BxfrsjHJexvCg7M+lz0bpa14co8tPIem5RWBRfzfioB5iZ0pBJn6D3X?=
 =?us-ascii?Q?QyIdhiEZ6Dlu9Q339argJg3ztmbF+IJI/pvcH/UAUBA24yQmzcrMFi6uMtCS?=
 =?us-ascii?Q?EWv7haOh2Wr9GQoyT6SEiiRNoSN/IwOEnOYXMDcVCYiV/ksKiF771ptTIJFx?=
 =?us-ascii?Q?ZHMha5BLwTvUw2G8i2Ir3Bbwy9ePjmOE/y670Zaebg+GJEZ1YFyjS+R2CGsk?=
 =?us-ascii?Q?iG2nolxqq+KCUPZEg4QVBF4ZndV5iXwqWuItgoenLHwHyHLz3pHmDO42PaDu?=
 =?us-ascii?Q?ccTOuQu9q96yIFoga0cYg6jDKEaILIkH0nLfq4FG2Wj/RwIPEpB9g16L5iDx?=
 =?us-ascii?Q?gyekC+58bFVFH7jdPg7lAGRb9Y6IAIeJgjmP475S3c4GpqP/xYxVlQx4uPya?=
 =?us-ascii?Q?eiufvS1B0/WZI/ICe0ilC4tZW/FYZ9YgxUqipNDpmcBQoDm9kk9rlUw/cLCq?=
 =?us-ascii?Q?RpxkZHFZ34k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h585Za/jFoGioIKfrdhysZZQIEue10EIih3SZcAZm44cU2jXLnnWwNejnNwb?=
 =?us-ascii?Q?mLQKQyvPJOF2x5oDTZiAnmfziMU4VjKnQrVsaOqAG1qEEpxBGdgKhOIisq6w?=
 =?us-ascii?Q?m1q6XRksFOu6dR8wmCASiPmyS//z1K/am74/ZrRhyH8NUx2ESOsIbDNXuIiz?=
 =?us-ascii?Q?ga+s7IH68wCLpJtpVvLV+dNpPjRPEKdowl9lu6HgGxUs63/s+2EwYhJuLTcQ?=
 =?us-ascii?Q?npcuJAcp23724CP9X6sBJMHsXR4pzqjigM9+1jZxJUehmx6SDWiSNm7Kmg05?=
 =?us-ascii?Q?EqzgEMrvCxDFYHcC7myQITzEdS3Q7Mqjrw8h1X3zOMENaSMBef9CTTfkjxuJ?=
 =?us-ascii?Q?galonITnSSWq9uHuncbdp7oqpL03MpLsPDCKNvAoHinzMPRO5Hl0iNZjzZ/0?=
 =?us-ascii?Q?Oz+dqGjqcec9o8z58lQe2MlUvoC35wlhtDhmYrNtyPzUjylZXg+DisIcnWdj?=
 =?us-ascii?Q?Wgg+Z2XiueqWU3cflrbE15MbEjgpNXSoeiMSPM0b4hHbhyXFy3qwskEPcWXY?=
 =?us-ascii?Q?rwZjb0Si80Cn4yOG812+Tq5PcnuE/olVuv9CSZsK8wR6+28wkVBeQILR9V2H?=
 =?us-ascii?Q?nYgA+01Qu3mGLxBXtlI19b85Syrn7E23dZiEsxrX/s+yWpDvru6Gd5P/gid4?=
 =?us-ascii?Q?JY6SNYKCHvmAa5zOmI7V09olewSIhl2T3V2yWk6HdqWLd9+PoOIqYuXBhbNP?=
 =?us-ascii?Q?yh+RfvvXjij6m1d8z9olwuzeiYkYDesnU0JDRl+nhEGtuTNF+vsFKG0v3ON/?=
 =?us-ascii?Q?ifu4SQaE2lppWDbRN0K1KjLIqA1NVQQ3y2z0K/zjx4thR0JXkLG1mWu+e+uK?=
 =?us-ascii?Q?E6vAKfdWtWlLfcGpydWyxZmPkAH2/awp/e8nI0DMQWu8g3M4uHd6ueldRukT?=
 =?us-ascii?Q?FXqiuO9ffbnh/h7OGuGfAKQXR+uYiUGiTC2kz8qjyAVfylZpE+GETUChnSbq?=
 =?us-ascii?Q?7i3Vy8csQ8ef/N0nXSReNkO04nOyHMsehMCtiNPiMJk6alPr0l1T1tppAs+L?=
 =?us-ascii?Q?706+r/60dfeGvuHAfUmhcTOSCy7/NCkwbG9Y1q1gUA+lUW1Acdwqirsrm33+?=
 =?us-ascii?Q?SRgAxdX/mtqzHFYax+maQ6/JxEhtTYhZVEHx6ZKXAaLa3/5e8OPvIfvAEzG2?=
 =?us-ascii?Q?weKIC3A2rfEVC17qxXWTlkiiXFZlaJwVl+0y+gsJ2yJ9yUTC0iIQsbzUMcMk?=
 =?us-ascii?Q?0MI/T0laQJzw3FVuaGsrVXB23purN3SP4pqxPN/jGXYGK0C+2lglP5ueow0y?=
 =?us-ascii?Q?XxoDacet5ZvDU6uBYrQ6rX2a0Gp10Nzh7J60Ngg6f0YNA3uK+KiUwBV/uRao?=
 =?us-ascii?Q?jsNJYDZPVYhGmvV1zx/BWE0uJd+P73yTMkPwZ+R9EL1MiqZS7/1RIpaQpMdg?=
 =?us-ascii?Q?E0SMhG6E5VDgnOvwDHLf2fFU28PTJr+55kE5WA2aVtEH8F/MhdWWY9XZbKr8?=
 =?us-ascii?Q?WY5Qr1yFLQGmJMQdIiqksPTJv3qF/v0ITzcV0GchRLBAV7QggOz3FH1JRcC8?=
 =?us-ascii?Q?srLTtJhcoFbYd721YprxwS//l/2Us+oILEu4/YbdBShMdkUkONsTwWEoxyWe?=
 =?us-ascii?Q?TbSngJ4K1bFr2wRojKo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a189b2-6451-4bb5-6a38-08dd4d1a22f0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:00.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDOICe5sQqpDrrdK3khX1UsKO1iRBJtmbIkWYEBnVPi50MYlaMnhmUcXwEaEczyl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Change the internal freelist to use struct iommu_pages_list.

AMD uses the freelist to batch free the entire table during domain
destruction, and to replace table levels with leafs during map.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 025d8a3fe9cb78..04d2b0883c3e32 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -54,14 +54,7 @@ static u64 *first_pte_l7(u64 *pte, unsigned long *page_size,
  *
  ****************************************************************************/
 
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
@@ -84,20 +77,20 @@ static void free_pt_lvl(u64 *pt, struct list_head *freelist, int lvl)
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
@@ -306,7 +299,8 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
 	return pte;
 }
 
-static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
+static void free_clear_pte(u64 *pte, u64 pteval,
+			   struct iommu_pages_list *freelist)
 {
 	u64 *pt;
 	int mode;
@@ -335,7 +329,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
 	int ret, i, count;
@@ -360,7 +354,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		for (i = 0; i < count; ++i)
 			free_clear_pte(&pte[i], pte[i], &freelist);
 
-		if (!list_empty(&freelist))
+		if (!iommu_pages_list_empty(&freelist))
 			updated = true;
 
 		if (count > 1) {
@@ -531,7 +525,7 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
-- 
2.43.0

