Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF364218587;
	Tue,  4 Feb 2025 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694126; cv=fail; b=u+CjAgMCbTRqPfDO2oX3Z02kWy2/EPjjFYLxplj9BCkn4lg01YjzbccMkRVxGd1jz8EsLCm+5MyjVAltBb8J2tMdTSz3rk2oJudg5eiryma+eqiH3fYbGVrugdlvniFGCmpdjkUdp8EwuDcruFKpJRbR814xh/aV363tPVuRmQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694126; c=relaxed/simple;
	bh=mWYxazs2ohjme039FVM90kD3OIJ9qEPv3fkpEaUQiq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jzmgRd3vxcphW8FWz87YB07xSJxKIP7Y0Aw9f97RdVzIrxebWDMFNgdhZcuzCcZf0zIP/5JG6agS1WQNNTBgnsO0eIgXRBhU/0BC+fYq93HlDjJ8d3lw7kFIactWmdo1X8O+QuWr0c1AH1g5gK4iN/XSCS+5H4yZesNQyDq40zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ly8/MSfW; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ly8/MSfW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGaCaC7iRNZ+/Vij3jeGG8J6gmoGvecIc5tGFqu5hr3+HtHu60u8NYleqSKODaImIGXahUuC3IYL/WBxaC6c7bPCD8AsSLb4X229TVJOGh3dIVVQrH+jWF8b6v3a0+U7f81GyK+02H8eaCQzFriNDyD/T6txCndmPhL0SpZPIOVC9E3NegFnOt/HA4M0T2iT4k3zAtJkrJbNblPF3njZLnpuzKrzcxKBR03XdeHSFKVfrTr5FunWdQ4ngTS0MhBz9MVjxzd7jfsFGmiQRepneKnz6kHnsa63/LzSYn+T+nz2ESRuhHCdEVrLsyKfzNt4MfVB2igZQJKLnIJVot6o0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBp6b+7bFmlULDMXCOdJKTaAAqGZ8bRgT+Y6g/5Bqxc=;
 b=Go0J/X5N4RxurporNrleHjQfnERl3V/1WqPhFBqa/niElJNZwWu9sHmFCgopEP6qU3tkYqwtAQ/rx8TOsVGFPWi2J5UY7x/XA2+4Pw3Rv2w8Lofyam1eIuswbvo+sbsuefNb/MX9pRy+9JVBHEaz0pon6lyK7NHQ5B9P2b6bcxFUT9N/rFRl+rzNzcSx68XLNk5lLUjWCzqacFFAlc0mBoWTvA74CMyLNg/rhOZSmpx4qiU/Wwp+3a/7VPB7arHkXP2QyXb4nG/t83wVT1oKpe8ylvPUe6o83P2X9sNQi6Fqv+oJGczLLONCmErkhoEB6mYK5KTR5IXdOVbpsp6yMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBp6b+7bFmlULDMXCOdJKTaAAqGZ8bRgT+Y6g/5Bqxc=;
 b=ly8/MSfW87wysfFUtMnrELNMhSzai8D1+JYYBMuh28tx1LKFSuyyxvjObJUj7NKis3coqVks0hin+BSoQ5xI2Ak0Pv4mETao655UC7I89gjxh7wRFx1p/szhNJfcwGJ/ec/VH3+dB5F+uXPWzKITMWnVWppSz2FEi6eZHWd44dvkbZ0lLP4PPosf0IDY99JrzIIEbrN7wJG8vwaZqxcSgaNQVtnYoR0L8jsuiRSZhXwpq3+UKp/t0atfHPZXX+kL/c9FgsHTuenyBXSOIo9AdowFqK7rqUWOXtOboAYEAcGwQghUc/ZGor8nMWocw+9RgMG/lDBglzJSKW/O51zq+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:09 +0000
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
Subject: [PATCH 08/19] iommu/pages: Formalize the freelist API
Date: Tue,  4 Feb 2025 14:34:49 -0400
Message-ID: <8-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: b08c6277-1c86-4891-b073-08dd454aa42e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WsuX1qO7lK+qXXfq/+Ean90cWDG56JVRTmAybWTk8CpFE6aeChq36ABsYYKd?=
 =?us-ascii?Q?bUvf0HJCQ48QmW216x5V+wDYSihS6C7ebVLHw1tTx+Kco8qI7h9wSEMM+VTv?=
 =?us-ascii?Q?9d80j0VdJFHjZYSz8mnNyawGSurnKjacgAieb2YkhBGIr5itVs2qqPLaUEHH?=
 =?us-ascii?Q?Xr7gaomhinsy3E+Zn7Fkv9PNnSO77HpWimrytdaeUssvNGuRA/LDrjeMM3Rp?=
 =?us-ascii?Q?5qE9tiENv7Y+jY4l5q0gicRFLR28H5deGVl/t3meQD2Z1dkN9/3Vs75tYYUZ?=
 =?us-ascii?Q?ONeNJ53E9HozwcenEfcRLx8dbDXx0hKYf9+gKWMJaZJ5ArtZ92iZCjTBjUJc?=
 =?us-ascii?Q?+ZsNW5Y6koOTVh8qWuONZb/jZg13svc3t91Bt0eDbjwq4GrEGZk8ACeMnAYc?=
 =?us-ascii?Q?Jus5XzhaGDncpKSiNf9Y6ihxxuJLDcfHDF2ct1A1EfMIPN9sJd/T45zq2SwL?=
 =?us-ascii?Q?J1h+XESQ4H59txCWeudQP/u3SJsGNM27ESZrMyFLW5ykBavN28KSJuxsDX/f?=
 =?us-ascii?Q?rKI6ZXffeCf8eZkntWpTe3ZqojOg0Ren7V+RUO2xxXMxsb8gCVjvovkpKXX4?=
 =?us-ascii?Q?GsCvrFmMLJxORSF4EdF3+oGNrrcdsMl4fwcpl8gXqW6SntuU5G+eo3nFZ2eT?=
 =?us-ascii?Q?VZflEStcpzJFiQ/Oog+4A7sPamD4BS/NMXltq3gIQn6e8p4oJRdl18kCPXWA?=
 =?us-ascii?Q?uDNdO3LuE7xAbimcgV9JNd33uN7q+5TxwNhyq0y1JE6HLJjFAvP4N4ilY5YB?=
 =?us-ascii?Q?OmLUaKeuFumjdMqOQcwpzwIBRc2t1RBPf5fMKo83weFIY6xfJeEuWtSUQ2QV?=
 =?us-ascii?Q?cf45Pm44GluyNKna7EqnzfGkU35G8sAlN1tS7pfeYa0TkYMg4cXd4H5zuWiX?=
 =?us-ascii?Q?b+yfB7f9lmMm+Q1SMzQaLo32WvRHPbsT5ZFCN5i/snz7yONVMxF7X4HoqJBj?=
 =?us-ascii?Q?qaIOGbyBzS+c3fy9j1cHhK4s+ivYfKjLEKPHXAeGRReeYiS0WWM5QJcmmOog?=
 =?us-ascii?Q?kllt0qHTBczdV4+u4Jf+xOLMKGpokG20XQlwKOKdVi1xN1ky60aktBoxQt2Q?=
 =?us-ascii?Q?OezAisPuYTBTPaTDFg0lnXxtjvuET0LziiLTLMQFxuhHrOg3/gEGGZiNduxF?=
 =?us-ascii?Q?yj/NkaiAMhipucbcS9/nuqosZGNbe4zD+Xw4P761SF5+4gJqV/8cxVm4HxUN?=
 =?us-ascii?Q?LXz+wa/+/UPRyB0J0ei1D1+dfllFh/8SOR7mLBO13qgyeDqF3ozF+AlU4hoQ?=
 =?us-ascii?Q?RZ7aF5FvolRRwu51/ULcK3V0oACuMSx7XpZbSLnxFRvrC30ZjtloNflqcuxr?=
 =?us-ascii?Q?lPvM71shTJUisesnmc0aJiIEWs2jFGi0KniOIifRo85Op6fKP8h05GMItDNM?=
 =?us-ascii?Q?+ZE5jFDYV2bs/pY8nxhqC1F9qJjWzQawgwqizag+klPkdH4pSkq3TMmN28Ll?=
 =?us-ascii?Q?4xk+SRBH0dg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1xV6rmXalUN8DsMrgvlPGfstN/qpsUoKCSTiROvoL69+fmiDxOf3MeYpkdFq?=
 =?us-ascii?Q?1RLAq7vB/OcX1mCf+bxCG7xMCKxpkASc7c2HZgiChAqOM1ef6a4HxjorMjUt?=
 =?us-ascii?Q?g9DDnhvaqyWsnqDk1SdCKdXHlFdt4HXN6yAe0Maw74DS1pOwm4ULWfpBTE1A?=
 =?us-ascii?Q?r9dX2DZ3ijAQrD9Aal+rQr2HdgO9b2mfUrD2nQwdwx3+v6UAGQ1mFVbxwXIW?=
 =?us-ascii?Q?uANBVLw5FqrFfNlImRHao4Vz/dSWAxhrHx7vkf2gOJ0mIv2iDZuSclEcmdq4?=
 =?us-ascii?Q?/nbi0p2EdQAIUnD5VXzQ0l44HAmu2Okfn22FGxUy3cGGY58TndFXC0D8f/XX?=
 =?us-ascii?Q?HzDllKpkT/dxHHm0vEf33laVQCZ06qX5Uh7Ogmyz1fD/W2qpzKLqvo93XKm7?=
 =?us-ascii?Q?vBm6EJPLeaxszWo7kCmieCMJ0gHrNRQvvOPTd89JqfdwyFR2m/faCz1Rxmj4?=
 =?us-ascii?Q?JxtFx7rTBSumX6zevBiUyWrYK1eEYpMnXkZRZlQBUcQTFri4HG4RKH/A66Qv?=
 =?us-ascii?Q?wROWuWavk270cAmQiU22vDCmJRZujpXGfm0hpJYcU5ERgqYEEWbxbmyjnPKd?=
 =?us-ascii?Q?uGX0MhdsYBmlmoRFX1NU8QE+NMPp9oUSUJgh7EMP0BdRlK2Y7OO72bdwgUS9?=
 =?us-ascii?Q?mYcqbq7w4bM3UISv2Z3X5V+9MiNxiyRfU1bS5pRddz0oeHz9YIps1/k4yuO0?=
 =?us-ascii?Q?+kt82//JmlXkFvtkfC8/GpGSfjojO+xbYzNWnMw3NrqXxSEkFFt4oVC3Yg3S?=
 =?us-ascii?Q?DeekqZHmaXnCgtGmg0rU+x4AvVaPG6VG7cFskLSY3NbYaWpiFilKLyokcFtG?=
 =?us-ascii?Q?DXJyPYrkpcOwlZXj44MunDD/ujUFvErLMYG3pFACvtNRTZijn6jlYxe0lRY4?=
 =?us-ascii?Q?En8oBCNle0YDleuhVfcN3meu5WEzaUA5pDAiBIWZloBLfEM6uieI+jz9hJ6P?=
 =?us-ascii?Q?7Ub5fYIwszodApdZokdL0K4qmA3sFXUeb8VVy3gvUETSwwnjJYeQUHDpbxNf?=
 =?us-ascii?Q?j3EYXUVOxLNetbBzI6/fyXJubld/DWpqN1Hznx/g7YgdYvjhZEiqYGfMTmmI?=
 =?us-ascii?Q?gn8YY2mdV+1yVL258dMzuEh3Vc49aZphYfNn5+H/ZIwQOYqNYPrBaIJirhYo?=
 =?us-ascii?Q?DzkRMjTra8C6HoO4zuC5SmBsJiDtJasZ2SttLUULBbFgxJyAHximBysPI8xl?=
 =?us-ascii?Q?Z6LZdPE0XOMEgr95Ns04NDxOOMiMHuHLhgyG3Bv7/8AZuGk9J9NbMLBMFgV5?=
 =?us-ascii?Q?m62MZdbcurkNiLo2VNyRuUmZ1HTxnBsZsw22ahGDw42Exq6HCpyK182wLXto?=
 =?us-ascii?Q?4t/VkQRpvw7/+W2DXzoiHTSGLGRcyYum675+fieDgdCFm0s+zlzgIs18uMej?=
 =?us-ascii?Q?58XsArOJdQChc9uLp2XS3V0+xC6F6smt7iI4YXxUs+gL3oGx4pnZQWG9ptQK?=
 =?us-ascii?Q?a06EmGWZhcVnDZg+mQclrliXEmq3ab3AqZXDMzGlW3Fdeq0Gb3D6hMnb3Rce?=
 =?us-ascii?Q?PsCH1HH5GeRk455ZJHpbHj/Iitse5fJ4BT0VdMW1/bbnX9Na44T9zbhDHzSd?=
 =?us-ascii?Q?x4gKKZXxBzYG84GP964=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08c6277-1c86-4891-b073-08dd454aa42e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:04.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xx9RuEQXo5yQAGXxAzIXuRKed+IBXfYXWI9oNkrlIJw/eHaZ2+Dd2ukYd+LbEAd3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

We want to get rid of struct page references outside the internal
allocator implementation. The free list has the driver open code something
like:

   list_add_tail(&virt_to_page(ptr)->lru, freelist);

Move the above into a small inline and make the freelist into a wrapper
type 'struct iommu_pages_list' so that the compiler can help check all the
conversion.

This struct has also proven helpful in some future ideas to convert to a
singly linked list to get an extra pointer in the struct page, and to
signal that the pages should be freed with RCU.

Use a temporary _Generic so we don't need to rename the free function as
the patches progress.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 23 ++++++++++++-------
 drivers/iommu/iommu-pages.h | 45 ++++++++++++++++++++++++++++++++++---
 include/linux/iommu.h       | 12 ++++++++++
 3 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 0fece3758408ae..92a6966ad4c032 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -67,18 +67,25 @@ void iommu_free_page(void *virt)
 EXPORT_SYMBOL_GPL(iommu_free_page);
 
 /**
- * iommu_put_pages_list - free a list of pages.
- * @head: the head of the lru list to be freed.
+ * iommu_put_pages_list_new - free a list of pages.
+ * @list: The list of pages to be freed
  *
  * Frees a list of pages allocated by iommu_alloc_pages_node().
  */
-void iommu_put_pages_list(struct list_head *head)
+void iommu_put_pages_list_new(struct iommu_pages_list *list)
 {
-	while (!list_empty(head)) {
-		struct page *p = list_entry(head->prev, struct page, lru);
+	struct page *p, *tmp;
 
-		list_del(&p->lru);
+	list_for_each_entry_safe(p, tmp, &list->pages, lru)
 		__iommu_free_page(p);
-	}
 }
-EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_new);
+
+void iommu_put_pages_list_old(struct list_head *head)
+{
+	struct page *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, head, lru)
+		__iommu_free_page(p);
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list_old);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 6045e1f90a40cb..0950f7c0cae9eb 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,12 +7,51 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/types.h>
-#include <linux/topology.h>
+#include <linux/iommu.h>
 
 void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
 void iommu_free_page(void *virt);
-void iommu_put_pages_list(struct list_head *head);
+void iommu_put_pages_list_new(struct iommu_pages_list *list);
+void iommu_put_pages_list_old(struct list_head *head);
+
+#define iommu_put_pages_list(head)                                   \
+	_Generic(head,                                               \
+		struct iommu_pages_list *: iommu_put_pages_list_new, \
+		struct list_head *: iommu_put_pages_list_old)(head)
+
+/**
+ * iommu_pages_list_add - add the page to a iommu_pages_list
+ * @list: List to add the page to
+ * @virt: Address returned from iommu_alloc_pages_node()
+ */
+static inline void iommu_pages_list_add(struct iommu_pages_list *list,
+					void *virt)
+{
+	list_add_tail(&virt_to_page(virt)->lru, &list->pages);
+}
+
+/**
+ * iommu_pages_list_splice - Put all the pages in list from into list to
+ * @from: Source list of pages
+ * @to: Destination list of pages
+ *
+ * from must be re-initialized after calling this function if it is to be
+ * used again.
+ */
+static inline void iommu_pages_list_splice(struct iommu_pages_list *from,
+					   struct iommu_pages_list *to)
+{
+	list_splice(&from->pages, &to->pages);
+}
+
+/**
+ * iommu_pages_list_empty - True if the list is empty
+ * @list: List to check
+ */
+static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
+{
+	return list_empty(&list->pages);
+}
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 38c65e92ecd091..e414951c0af83f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -326,6 +326,18 @@ typedef unsigned int ioasid_t;
 /* Read but do not clear any dirty bits */
 #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
 
+/*
+ * Pages allocated through iommu_alloc_pages_node() can be placed on this list
+ * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
+ * can be used this way!
+ */
+struct iommu_pages_list {
+	struct list_head pages;
+};
+
+#define IOMMU_PAGES_LIST_INIT(name) \
+	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
+
 #ifdef CONFIG_IOMMU_API
 
 /**
-- 
2.43.0

