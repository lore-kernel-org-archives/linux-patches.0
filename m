Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31420D4FC;
	Tue, 25 Feb 2025 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512694; cv=fail; b=SpBXwZLZJtlEN8D8pGkufY4LXBZHE94r2bueNDu1D0Igk/MEONba71buysr2a6HQJuGcK6N0Uvj3CoZVrjytqoj7JAzneKviibn8SGeBKvT4FV898MMBv/+6NK+AJhUSUrf+4N8n7DWVJHQWXtDPtE7HUD89HnVnW9t9yPRFGgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512694; c=relaxed/simple;
	bh=eJHUqsSVR1qED5PwWaaVg9CbeYgcuCIIkT3nFYIj1fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bi24Nlye9vzbEzgKr5LbQ9IiXYAuhOOGth+1JkL+DfzbgaWwkXCrd8wdmIUTqrSi2KghjQVMkAiHZH5jQ2ysGrCSWbMIhQ/pl0IIxzgOcgwuB19nuqrLbFEv29ruU0dZokQrc4d9mFu730DQPt4IY0DwvQtRN1i2uxAnweAoL8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cSbHjzR9; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cSbHjzR9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aRzzu2I5oxmGVYG8JLNI+UouW7HfT4CIqtKbWEcfZ6WyRtGkcz5KEZql1em6FC2AgPFKqb02cc0bwKiYm/3T2n1DaWJqpKAfAkqS77NF9WxrRpUagXyehPS5+UMEPyREyAkNVc5z7ccH2r99Uk75zmNEDjSRZN65t9HXEHFkm5odFdH0eoci2dCO1o00ZZpLQvAw9gPZF3hTB58qVGc4awFlwt2MbOYqZqxnvIDEJPD0Rx3C/MkktNA8gFMEzIKbnzY6oVA/otwKypysGjYs5WPAJRmUwPPUUJFFjimhp0L64GndTQT/mpfhNHQMM3BoL703j2vCadbzJI4byZd6EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4NfpPV+rLdyqnsWObgNr7LdA2h9tGUIN7OlGOty9No=;
 b=H0dTZaT2DxLT9nhQmQiA6nNnWE/KBTBdgCNxSj7QuBGHZES89mVN+XcLAxVaD3X7cupwsJ752OLQFRXVDFAKq4kHDUe+CXqZMxWSyLbpj6oDATKtn9SmDes/q7rvyGYttdeV9LNArxj04fRBlFbZ1RzyKxSt48yE4aHwSq/fE8xWGegwQIHFIuLFNACpCN+SJ+YMHnkeUplBJ9e1VN8R89NfvaCdYFPYKyPr6GtbgACLhqot6qYopU1PAYos7RjGhawDnGCc2b2vGpC4BjR7d9nysYQ6PyE3mCrusGhDTxLWkE3FZJVrJdUSWOKeRESqhVrZO/bs+QLA0bP5t6P/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4NfpPV+rLdyqnsWObgNr7LdA2h9tGUIN7OlGOty9No=;
 b=cSbHjzR9ipXsWlMNt/Y5Z5l/QvTPzl8F8cfo8a2pyOBfgIY1aykBXtf8TZIFmeCISDcLRY5Plwq0s3DblUnMV2Pzb0kgdqw2KrsdUvgUKIp9B8sB4N2gm8+aUVrAA5G9FOpBhuJ+SmxeX+pLRhKvkJ+AfJwlrPkd/YWmP0kt5fdhvlkqGYuJYEEW6wiEHHsldmdkV/+8E5WLgmjhuRFcySiFCqV5HeCk/g4A0kPHZ3CmwG8YkHQGu2GBeRSGaKwei91Id/dHrB637NV4uEcdmWX7c28HPhvyc9CcETivjTlRkMGY7BCIoIAppJNU2SizilPtabGNXud7tPigJIGhqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4375.namprd12.prod.outlook.com (2603:10b6:208:24f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Tue, 25 Feb
 2025 19:44:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:44:49 +0000
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
Subject: [PATCH v3 12/23] iommu: Change iommu_iotlb_gather to use iommu_page_list
Date: Tue, 25 Feb 2025 15:39:29 -0400
Message-ID: <12-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0323.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: a7801054-4e3a-43f3-ebca-08dd55d4dd92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jkfrK10f8kHiLt06tqDhWIIFTwfE1ElxnUVF/c5AXwIqk8wmlC7Cz8NyPv+E?=
 =?us-ascii?Q?T7VbGTMxfinJ0ES6s/O1+MDp6GWugnXrBHQdMzjGPLSbuWrSGYf4jGmisRqG?=
 =?us-ascii?Q?wFOQuiB2iabKR0gMIqnAkoJg9HFHWylMuf/84/u/cjrKjPOoCMdry1MQAsiP?=
 =?us-ascii?Q?XnDncJ0RuQY2Ok5OlpCCWmaAbhXT2rotl9INlqPNRbsferyy55vng+gTHEhX?=
 =?us-ascii?Q?vDE3KF5kPJI+Jqy782wxLs1Tj7Y1nGF2qh5OM5wuzzSdL8fHULeURxHfCuV3?=
 =?us-ascii?Q?PqkUPJiRAlkdQbZKW7UqvEXGTjNxf2nbKtmZmCK1RE/mO5lTFAeBmPRbKtKL?=
 =?us-ascii?Q?1Xks+3FhPC9lSSQSyDcyljy+M3hsCFtKeZ9131gJnAZdd4DI+/liOuakaUKs?=
 =?us-ascii?Q?FUDR5IAW6LHA55l3pyaY1HeMZdbXifL5V8dyv6wJMS4qeGIfp6NtrmQyx3L7?=
 =?us-ascii?Q?B2SnD4cZwOSoox7xHEcbIOzzqG6cwkBJaNAnv7cAoHybrfvzjnwrupTvOSGM?=
 =?us-ascii?Q?ST710I1rNhjMFh1KnfYdC06whxnlubO241XlpRB3J1bgKHQDAtYaRmkJDTCn?=
 =?us-ascii?Q?bNaDh0hmOfhjk7hQHe28FNwtnwyyMwfiem7Z92VudOaUvapZkLe+8NSAyeuG?=
 =?us-ascii?Q?58093C/QDGAts0ng9RA5OxQc5LztUiICLCtqNSKBun7RCx1LDja0FkEx7Azb?=
 =?us-ascii?Q?M7qWXupZ/alDWe5R2JhbIFoqD2nuHKjK+xujnoBC+9t+aARTY6o0lorwzSac?=
 =?us-ascii?Q?jRGpyioigDOuFKwJxGTQDMP7nGfJHIeEH/fCI5yQLrossonrwFD3i/YSGNk2?=
 =?us-ascii?Q?eIQQo/4fD4DDUdHBjrlvdSsFNpDK/Pa/azA7w128G+DaT8AxhsOiTTZ0o58L?=
 =?us-ascii?Q?QGmq+KupD2OYMP9k/4Bdahoo5Wd1CIu7JIPeP9pGbWpkPRT4MlxL9xO3x+w/?=
 =?us-ascii?Q?S9jmKvExg6ASHaILSVsY8xCiZ+NC0jfPAOk8+7lEGNk58iCzCD7hIjqg5K6/?=
 =?us-ascii?Q?+HlLenOhxAq271iB9YRHARG2oVeH8GTzCykCokJndJw+Gm+ICr9Ti+6hEm0y?=
 =?us-ascii?Q?4C7kSp7UXL2pAA2gyd+Adv2hWDqexW0KT/I6wFitzhBj5tUhvU6LZekq0MYJ?=
 =?us-ascii?Q?CRTbn179rA8nSxmGrSGh6DhudVvSfhfk4CDyoH5LMFAiYp1bv2o0wcddWGfk?=
 =?us-ascii?Q?QavIwT8tgM9bnE03eWG3IYr2JNWe4BrJhkzqFuaR+76kYR6rocN1GCGn+KqJ?=
 =?us-ascii?Q?hpLXDWZrdxcOhzpumy1+HNQF7PBNtfGQiJkzm2X1c/NjI6Nh90aq5HP+UEIr?=
 =?us-ascii?Q?pA8ZNM0NrAUVF0Ogk2m56YiBJfJUbyLPzyXBu44u6wLceeBOId1G23hdSQhB?=
 =?us-ascii?Q?adH1HsTtwINS5e2dTSGj57DKuxyyOt2Tyc9vc0llBtBHrdLbbwBUdw+0zmbA?=
 =?us-ascii?Q?FDDrnOkBDZU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WP6pNC6OQfANETAK/mNBLbXJqkBXIJ9qxW5f+bQSiyd7EfdwhegJ96IRdX/f?=
 =?us-ascii?Q?NFiCdfOxPwWtHvH2LYOJo+yv9HcvYzjtUl2EnzgN61oFFBCn0RYwpU1ZnzAJ?=
 =?us-ascii?Q?YniSNu12CcM35BrlLeSHoTOOqsYbii7KaaK4L7BAzYqWuCdMZ1GHPlrO91Zo?=
 =?us-ascii?Q?Sij1DOvZzQAK8Gqyg1p4G4UL3jS13uz+18XdOM0HhpTB/Iqjqn2CVGo4WE6H?=
 =?us-ascii?Q?+7TGbDAt+LJdOvNHDpNZh7NYiJSNDLn8Q4TrXpAQ6RTTxDJvduaJssJiKxui?=
 =?us-ascii?Q?Uw5GCKsdxgyeCjLX7H4LvO7AD8P/MZmShVuGZVWaWrReFW+F1FkKAsMKZw17?=
 =?us-ascii?Q?YHtbtQ35M3ts6BqjeKVRi4WtXQxMIIgnEHYA5t+MjKh+rso20js6eJ/wqycY?=
 =?us-ascii?Q?D7JUJSh5WNf/z12qFe1RRCH9VoT3c/KTio/kVIh9XAR4M6txXmmaqZfDWOUP?=
 =?us-ascii?Q?+GzWb7Yk9ai+nXyHPPAf2As2fxiX81ONkNHOEvxAxz4RXmC2DkC3pVAopxTC?=
 =?us-ascii?Q?06xW1Qumlvitt+0umxiOtyKtkAhQPkLnhC5emIYNsSX0KpzIk5PB3lrf/ljB?=
 =?us-ascii?Q?VOmJ4Dm97eRk89tyuZ96p4RSKwAxkx/bjzgC/zNM93+r9VOIIYKeQeoecXI2?=
 =?us-ascii?Q?qLg4Net5sKnEICGQym81ykb+dDhpk7l3PCsL5ab3z2xwBy8WUKVvkCD2sEzr?=
 =?us-ascii?Q?V+Oll7kxx5fENYgllD7+82etLdydcbwvsNQYkn1CjBEsom87aX0bYMJy1rzJ?=
 =?us-ascii?Q?uIr6sOFGyjCyXB+FJjcoCvL2Wqg+ym2k28FDT9BCTTIPkp0yDVTqKPGAC8UF?=
 =?us-ascii?Q?3bLM/jV4+3GnW/NkawgDxc5Gf3fbBGGhTAFwmuhDyJVOwSYTm3ERPMuj5N3J?=
 =?us-ascii?Q?k08NtcbOdIMdtfSSTH4H+tzhlAdn0N+V5sRJQ1jGccuGiXS6FbRJFNJXk01g?=
 =?us-ascii?Q?nI/im4jVZZsHftwixikaGFY5ZZL0tw2PFakt/N0AfdScnRQO5/Ltd73PgvnB?=
 =?us-ascii?Q?dmbs/2LhN/mpqLAQ8WttCqE0Kxz984NqQslGNCjlIOQ33NYx5w9V2mrO2+xb?=
 =?us-ascii?Q?2ONAedc+XjX2tspsbe1vZ3iS2SNKcO/jPNdMZH5nIKEplF9HYY4Pe9M22Q2O?=
 =?us-ascii?Q?Vff6ioql+/QNpn/BHRNZ4DrY/Ol3W5y41KoH6bqZKN+X9s94KHQGbmp/t/+C?=
 =?us-ascii?Q?8it0iBpxPB1KK8Gfgsuee8Thkq+Nvvtd15oNwPLJ4JuUIOuZW4SANlBanC3Y?=
 =?us-ascii?Q?68Sj08LexieqOfrcHx/hSicSjvDzjxe0um/DwifB5AnOoF2lOSbQmDiYC5DD?=
 =?us-ascii?Q?rGgkFjPJg/KoWX6tb+lZ/0rVlhXi0ozcFg4C9hG8Bc43z+OrSsRJFMPi4C2j?=
 =?us-ascii?Q?qlpB8gDDjZXqEk+qGrZrxO16EhoV4fWBzou9hAh3PMaiH2XdlRKJU8rNYhRS?=
 =?us-ascii?Q?+nwm8YqBDfEtZa/yyieRrUDzQDWfjnZWo5G3d8bwdjq9tEeRLxLN08oS0xyJ?=
 =?us-ascii?Q?2C+UZ4nlHePNDYlXn0H2JU9rxGkPVSmVdoAX0UODIlqJhbIZBEfn0/+UQQv4?=
 =?us-ascii?Q?QiRNpVwk7YT3uk+kTPWpLWs8L4HnnyQGp2Vsp9fk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7801054-4e3a-43f3-ebca-08dd55d4dd92
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:44:49.7512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LszUb5XMNP0KpyigMMwtycIL2NDHGxgKPmDa53iJ4f1KWZ9k4kKzzBTPyL24nQKO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4375

This converts the remaining places using list of pages to the new API.

The Intel free path was shared with its gather path, so it is converted at
the same time.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c   |  9 +++++----
 drivers/iommu/intel/iommu.c | 24 ++++++++++++------------
 include/linux/iommu.h       |  4 ++--
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 2a9fa0c8cc00fe..3d5a2ed2e337be 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -114,7 +114,7 @@ early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 struct iova_fq_entry {
 	unsigned long iova_pfn;
 	unsigned long pages;
-	struct list_head freelist;
+	struct iommu_pages_list freelist;
 	u64 counter; /* Flush counter when this entry was added */
 };
 
@@ -201,7 +201,7 @@ static void fq_flush_timeout(struct timer_list *t)
 
 static void queue_iova(struct iommu_dma_cookie *cookie,
 		unsigned long pfn, unsigned long pages,
-		struct list_head *freelist)
+		struct iommu_pages_list *freelist)
 {
 	struct iova_fq *fq;
 	unsigned long flags;
@@ -240,7 +240,7 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 	fq->entries[idx].iova_pfn = pfn;
 	fq->entries[idx].pages    = pages;
 	fq->entries[idx].counter  = atomic64_read(&cookie->fq_flush_start_cnt);
-	list_splice(freelist, &fq->entries[idx].freelist);
+	iommu_pages_list_splice(freelist, &fq->entries[idx].freelist);
 
 	spin_unlock_irqrestore(&fq->lock, flags);
 
@@ -298,7 +298,8 @@ static void iommu_dma_init_one_fq(struct iova_fq *fq, size_t fq_size)
 	spin_lock_init(&fq->lock);
 
 	for (i = 0; i < fq_size; i++)
-		INIT_LIST_HEAD(&fq->entries[i].freelist);
+		fq->entries[i].freelist =
+			IOMMU_PAGES_LIST_INIT(fq->entries[i].freelist);
 }
 
 static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d864eb180642f2..6df5c202fbeba6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -894,18 +894,16 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
    The 'pte' argument is the *parent* PTE, pointing to the page that is to
    be freed. */
 static void dma_pte_list_pagetables(struct dmar_domain *domain,
-				    int level, struct dma_pte *pte,
-				    struct list_head *freelist)
+				    int level, struct dma_pte *parent_pte,
+				    struct iommu_pages_list *freelist)
 {
-	struct page *pg;
+	struct dma_pte *pte = phys_to_virt(dma_pte_addr(parent_pte));
 
-	pg = pfn_to_page(dma_pte_addr(pte) >> PAGE_SHIFT);
-	list_add_tail(&pg->lru, freelist);
+	iommu_pages_list_add(freelist, pte);
 
 	if (level == 1)
 		return;
 
-	pte = page_address(pg);
 	do {
 		if (dma_pte_present(pte) && !dma_pte_superpage(pte))
 			dma_pte_list_pagetables(domain, level - 1, pte, freelist);
@@ -916,7 +914,7 @@ static void dma_pte_list_pagetables(struct dmar_domain *domain,
 static void dma_pte_clear_level(struct dmar_domain *domain, int level,
 				struct dma_pte *pte, unsigned long pfn,
 				unsigned long start_pfn, unsigned long last_pfn,
-				struct list_head *freelist)
+				struct iommu_pages_list *freelist)
 {
 	struct dma_pte *first_pte = NULL, *last_pte = NULL;
 
@@ -961,7 +959,8 @@ static void dma_pte_clear_level(struct dmar_domain *domain, int level,
    the page tables, and may have cached the intermediate levels. The
    pages can only be freed after the IOTLB flush has been done. */
 static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
-			 unsigned long last_pfn, struct list_head *freelist)
+			 unsigned long last_pfn,
+			 struct iommu_pages_list *freelist)
 {
 	if (WARN_ON(!domain_pfn_supported(domain, last_pfn)) ||
 	    WARN_ON(start_pfn > last_pfn))
@@ -973,8 +972,7 @@ static void domain_unmap(struct dmar_domain *domain, unsigned long start_pfn,
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		struct page *pgd_page = virt_to_page(domain->pgd);
-		list_add_tail(&pgd_page->lru, freelist);
+		iommu_pages_list_add(freelist, domain->pgd);
 		domain->pgd = NULL;
 	}
 }
@@ -1422,7 +1420,8 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 static void domain_exit(struct dmar_domain *domain)
 {
 	if (domain->pgd) {
-		LIST_HEAD(freelist);
+		struct iommu_pages_list freelist =
+			IOMMU_PAGES_LIST_INIT(freelist);
 
 		domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw), &freelist);
 		iommu_put_pages_list(&freelist);
@@ -3558,7 +3557,8 @@ static void intel_iommu_tlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
 	cache_tag_flush_range(to_dmar_domain(domain), gather->start,
-			      gather->end, list_empty(&gather->freelist));
+			      gather->end,
+			      iommu_pages_list_empty(&gather->freelist));
 	iommu_put_pages_list(&gather->freelist);
 }
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e414951c0af83f..166d8e1bcb100d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -360,7 +360,7 @@ struct iommu_iotlb_gather {
 	unsigned long		start;
 	unsigned long		end;
 	size_t			pgsize;
-	struct list_head	freelist;
+	struct iommu_pages_list	freelist;
 	bool			queued;
 };
 
@@ -849,7 +849,7 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 {
 	*gather = (struct iommu_iotlb_gather) {
 		.start	= ULONG_MAX,
-		.freelist = LIST_HEAD_INIT(gather->freelist),
+		.freelist = IOMMU_PAGES_LIST_INIT(gather->freelist),
 	};
 }
 
-- 
2.43.0

