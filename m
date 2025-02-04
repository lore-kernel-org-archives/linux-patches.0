Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DAD218E8C;
	Tue,  4 Feb 2025 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694123; cv=fail; b=sMckO4J2DpwX4SzD7XbYUSEJYuK4VClEqlozpYoSHTPWqrG/mx/tMq/X2m+Sad8huXfhBe5jGZzvtp3akQrqVl71QWIBb2kRGS4NOYDK2E3gy1e5x2m4YkccOyQLaYhJGrIsYfVu9Pumt+y+Rgv1k0jrmscuFuT4U4qdk0oYJ4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694123; c=relaxed/simple;
	bh=3fllfUajv0EIlsEd4sizT75Q6gbJs0xx8p9LxNCnjuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZxEYP36qN8cXXppM8BRLwwtXi1t9UBaWcfKXOUf4lEbmdPdzEulgWcnyecrfDGqB3M23z/kUAhFw1Rm2ehL1nTYjDtKU7lpPXL6+pS4d5jWq/km17Y3h3sj56reL8b0x43g63W92gsVbNJL8uwh7qG7uumKi4Ufq92HxBPlYeA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+H3c7Yr; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+H3c7Yr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XzUz2HkKwcYNQTMyNX8bX2nN4upqHDA0JpEOv2+R8Pfy9Ui4yjiP9aWKg9C+2+HFPkEV6S6e/vYNCgsSLpYpUP1cn4WsZgGzOvb8n6RCl9rkF3OdETZJR5l8LYfrstCpfxBJyAI6/aUnT0M8S140MOeNswK4ZcVUuZT72SQRssPXZrqdeRJ+pcojjU7tBxtyfScb6x8iwvxs6CQhqrPVR8k0zriQ/YRnaEu9Yks4iFDW+XDrdhtoHqHNCW9cO6dCvuHRB4PwVEIO7YVirDM92YoSzeHUR8sH/gEWlO5+YsdSNoy03Jy0wvncZDhjbbiuh65V6RQyGZnBtdPcMMYLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaLVkctvhEv1FkYriYm5WR/smy/3nE7yXIwuZDLwAyQ=;
 b=NmRNiioOTU/grZ6HdxUnB0k778UZVRZTvpE2e4Nt9oCZ4kPszocR3SgfVm0xp9+dBf2ItY1+8T8ubjq80/KhWi6Jqw/emAxGHDRJFRLOVpzckf0cMKy7Ai+YGZ5Xq3I5++TTGs5mcBh1e056tHRJ/99CroQDQ0Xdq2lu9s0cSG5HmNrsJBQClp8Dg7L7db/lJWKXg5y8P9D6Ku9A2H1tvY31x1+fmWfHMs8/qzh09NI89mFNRgU3GC7VnR0NzdAE9zrvEXwEHU/CGqhBNawziB90O/6r6h+607VF4kp0Btix8pK8P7QI753NKwjLTPX16rjrbLb48BkdJKIpBlazAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaLVkctvhEv1FkYriYm5WR/smy/3nE7yXIwuZDLwAyQ=;
 b=h+H3c7YrPkSL3egb0cdasVkvoSCfIb3o+nGIyqWSWIfjT/BfOWRaRPFK9SMeX59uO+7fGz2GxwVkqrjPbWAJapGjGNVqfWkrJK30MwlNxENaXiqvFF2nuFJpB0mDx5SFELTe9O/8g2ei80uHuAoTNAJZ22QaNHDQ8QU26qVCMrfIx5gdjl6Gb8U5Th9dyBubzKZapbUOC2rCjKvJMZ7pT3AJoY3SexsXFEynW7AD+BNszBXVdCiiMlbRF+9p5GvOnl3hGH8G2nwTbjnh+PQa8WMcflkUSrW+stzdaPVKpTQUgDG837aO8BJ/ZhHGdq4mUjwGb3eCFP0wDbdkh7WPdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:08 +0000
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
Subject: [PATCH 10/19] iommu/amd: Convert to use struct iommu_pages_list
Date: Tue,  4 Feb 2025 14:34:51 -0400
Message-ID: <10-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0383.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 521d221a-f226-4c9e-c514-08dd454aa40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wBaeO/s9tSo+UIUdbDW1mj14Z1TIzEauZhefZOyieCpNcyxBIDJpbz5UGVng?=
 =?us-ascii?Q?ZtFhexvZe4mYze0Kg2RwuNPSKzL0aqOYAyQ9pcgX7I9Ko1DXFoEiR8WEDFV7?=
 =?us-ascii?Q?rqwuEGBmt4LLZp8Y5/AIAWqglV0vqyirBd6SBtgPLc6NogAHVQV+B6JUemmw?=
 =?us-ascii?Q?3tiksWO7LiyXIPkCtaT4U8a5KJ0LgsbTFiIa34jVcNdmeTsUdS75qOZVKuv6?=
 =?us-ascii?Q?gXQNY3cf2ksoMcthzkuUO59mLNGblMI/Ru+hIZ2sM71F0TcxkfenFCf/Cg68?=
 =?us-ascii?Q?R16ffa0H9LiLWo4iTAcTxZBqM0UuBzTWNrf3LfZZ/HECPNxmoSwx1QItIO2Y?=
 =?us-ascii?Q?qwqSdFqk6e7+Bkg8hFPkxcOevpuNh2JlywdohucWXjtA2727exbDHzm7J41C?=
 =?us-ascii?Q?AvO7D1X/wuA/X9v9v5jRw3yla9de2Q/zEOCZqMxmCy62ZRiv4IWdgsyPv3Xl?=
 =?us-ascii?Q?5prQDJxMVI+H1amx7U9Tl98tnptF0ieFXb1pBeuF05yUr6AMSlAQWs+1GTY9?=
 =?us-ascii?Q?ASBmEzQP5z3jahi3KysSg3FIyHrd28VEakJggSOa1eSdtf2xgghumqlfAvGP?=
 =?us-ascii?Q?X0rs9TQVk2ERdgffnCkqs3r5P+dPMU5+T6ue4NB58ouSJDXxX+J5HH7QVmvD?=
 =?us-ascii?Q?kwPmGodZceCjv3A3TKt+cHl/SIj8e3KQMypv+uMCD/48kVN9lyPhcn9BHvNW?=
 =?us-ascii?Q?DjRyS4sn0c7Sq5SaFzIuksXuhSNoBnXPhvBgLMWI4KQuxCAwAMd9uKJ8pM23?=
 =?us-ascii?Q?pqpJ+XTHkpB+0b7R2GPOZfrVGjXw80vRF3ip8wFr5uxMxX9zNLliJlb0LYrn?=
 =?us-ascii?Q?sqTZFEVU/AOeXoOumv/c0ZHVhbfCBn1axV8Hkf0UOim3cvhOdUSc47OmyXyb?=
 =?us-ascii?Q?CznSzer3w1pbcLcGM9zFGgR4uCkLHdBHUxsB2ublLFma1mmbhIi0oUz1gYaa?=
 =?us-ascii?Q?vHMrZt+eSwnToznQVMPRO2TljowT7vmiWHv6ag60m1weLIcFT07q5IbNzi76?=
 =?us-ascii?Q?MbYsFD8qb2q4cBKjAmUen55vImrYmICMcJYVkss88cgJsEE56hdnpP1mH1C9?=
 =?us-ascii?Q?rG6oQPTU3tW2XQJmaRtHw6COWsvDmAjyqhujvHYJVKYW3MkflAbk+woj/nlq?=
 =?us-ascii?Q?JNxFQksV9mJWCKjmiljIz6NKMQJwPl2BWBRDP5Dgek/+8kI0raGIWkO2R8FW?=
 =?us-ascii?Q?uADB5QWhkBLbJCn2XMFb5l873NjnszR+9F8peVR61ydmYjLQgP9FPKcLJsZY?=
 =?us-ascii?Q?TQL//4ANJcCuCuqu42h5YPxmPiIo66b2Js6nHvlyq5Vq7s/CXJvUK01DUK9y?=
 =?us-ascii?Q?6Tm4hczXv/dyFT91ec+ED4MWc7zHPeoxIrynCNR7yXWrYWyY0ir0Zt0o7BMV?=
 =?us-ascii?Q?lBM4OIggQaGqKHWf2rPTtkl79YeYjWd8eO1RL316qJO4eydAuMEyBQ0qa2qJ?=
 =?us-ascii?Q?h/9u0uII/MQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AgsRQzky7nfpzPX3CyGHPz+G2m0s/gq3m0FJcbA+oa8mB/jEqhj6A/ZdOPb0?=
 =?us-ascii?Q?TM1NhmjC4K+2obE433mFzlhWlgmMI7Mhfr9AH+OCW/MyvLQ4kbkU9F0TYqXI?=
 =?us-ascii?Q?vqTR3UNkx9lQIJ2xUbFqEeqf5vfPjrNP2G0IDLh81WhBRBHmNc0zSvW3lBF8?=
 =?us-ascii?Q?6zu87acCya0DKJbToIx7y7ACazpHfvej/KZMmsAC7FqHAVvJLXObIC5OnZPb?=
 =?us-ascii?Q?IQZc3JogkUppyk2nnyg1KDaEq0z0byVNodffCHFkeFmiogADyczPoXSiZrXm?=
 =?us-ascii?Q?6GFxTF5/egGGqDnBImwG0eBsQtbfQvTtksymG12SLTVFtVVmk48qnBytTC5M?=
 =?us-ascii?Q?CE04h6MBx/eqOHXsuUG5rrTyfV7WybUfQsZR3jhpiByccQnNRjOljhQKz/oo?=
 =?us-ascii?Q?MhY5QD27ffNUxb3D198ni5ZFWF0hpQP22+Khl1JLIcn8/dbvKVn+3eENwvxh?=
 =?us-ascii?Q?9RPeZObyvludNRwffuei/Dk9guY7B9eA7IlGOgVHUQHWLzmmiWYq9cpGD1Cw?=
 =?us-ascii?Q?kbGFMvQqYz8fwN/+hYjM5WLAv9n5wp0ltaxH4gYItgcoCJga0NgA1To3axh1?=
 =?us-ascii?Q?XRjbldWZiDrxPZmCbFn1cdWHjNHbuHDqvqWOC54seVBlMOjQh1TIvYRViyng?=
 =?us-ascii?Q?b1iPcqFYGCIUxjWRjEuYHR7+ZTrAFzU8GBRNkos2bUniNnmlDd8XRQBl/+hu?=
 =?us-ascii?Q?ZxrRwkDRBLNFHyO6qt3h5OhaHqi997NizcJA0i+PecnCVTS31JsMRjUvFe43?=
 =?us-ascii?Q?dp8Sa55/EJIZurEm1MtzWi0XB9nNPFlc5K9pdcW9z2qpH5VlOUmymtFZPF9A?=
 =?us-ascii?Q?4G6kLdsBzMCu/s8ThXQUr3UE1aRRRnesEiRcD2yHPziC7DYHBcncnU731L7V?=
 =?us-ascii?Q?2BBwiRwK5pY6qcaavxCZ0ENG4pUzP1MNakK+GEPaqaOmYY+19mkF8wP/w34P?=
 =?us-ascii?Q?M22pX3wkzqOddJ2U1r+Ig83e8GI5k5PTdhts1QBzQ24RHlNrUGrnd+wD9lEj?=
 =?us-ascii?Q?C5wPbTv2sNDlF7AzjGNqPmtea3HNi+iXVN1mRsdw7Qdg0fJvt3whAWuBBODT?=
 =?us-ascii?Q?89Y7pfKO+Iuc3fhSP5jMY+DsldG71d3KNidnjr9z7j3DJVH+IuKVFgfomcOL?=
 =?us-ascii?Q?vcuPhRgwP2tQpuu9vdGMFHt9nipoko16Qs4Z8aB5HAgw9EGz481uI9yRn7yZ?=
 =?us-ascii?Q?USbN80nYGuvymuvEHF/jruJYJpu4DekPZHpq/f4big8SiKR5rj4BPE5sIXEC?=
 =?us-ascii?Q?h/BxsMrUo5Evu/7k4aAQfOO4/w7rf2+nye/S7XEbV6pXqo+TUpDOqaRAAKw6?=
 =?us-ascii?Q?OT91kqTpJkhBRUWIqwj3EJVFYkjbVoqMrrKPIfIettoxHy2VfCtFgakq7JWg?=
 =?us-ascii?Q?VkJd2ezur5Xuoymt/yxZU6aYmSdpr1gpCiNd1bVzSLL/wWImBK8KZu/hOXaR?=
 =?us-ascii?Q?tRMd85quOgg3y3npudzbw5/19YXeyygBMTFq5FfQG7qtodRsZ3pWxRYZGCis?=
 =?us-ascii?Q?lTx9UFYP61Xe+IE+RJ4GXID6wy2ZR9KzzS6zPJk0z4a9FJ0fVgZkEq3+kjzU?=
 =?us-ascii?Q?FvFbqoinwQlHPsYGbUI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521d221a-f226-4c9e-c514-08dd454aa40c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:04.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlofT3Yyv3Wc46eGEq/XayevLFJ/7papp2/wxZvP+ue78bAbq4i1WUmDoSi4Afnu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Change the internal freelist to use struct iommu_pages_list.

AMD uses the freelist to batch free the entire table during domain
destruction, and to replace table levels with leafs during map.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f3399087859fd1..e375ddefdb2cde 100644
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

