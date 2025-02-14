Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B8B26869F;
	Fri, 14 Feb 2025 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552901; cv=fail; b=iJZ0bpWGtJt6NVGhajYxworehMDwpxjJvzg+h+orfYc8/Q16Kr4qiGLDapGc5fqoHzxKSbxJhe6OSGGiavruwe4BcbHnojA+FKSXejlpfK2ENs7HrVcDnxePlIZgiV7PkHvU5ilrJI6AJ0ngEfOQz52yRUPKWzq7SGr0vDbLfKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552901; c=relaxed/simple;
	bh=eJHUqsSVR1qED5PwWaaVg9CbeYgcuCIIkT3nFYIj1fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PY6J8TNH3SMIc8LDgO9IbPgAtLgfRxAJqnKSP+yVKIgdvSj7UMrWWqybMk8YfAGOTGoSDTvknYhVIgogaYj4LLw4IXBs45A0Xfe6yju4fFpTEmvUy1m/+rvPetLxeZ+SMXKkJoWNY/KmY1atfupfMfK0cqwjfy000tdfLO8PDLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ngyr/ax8; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ngyr/ax8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhtLRL7RLpODIHfzmAknt0x3iROODZt6Bkdbh3ly1AiFSLUK0DAg3xsb0ORRlA2mxwTmDghxEK8+FL3GIzoSfQMIwsnfwd7abihOZfim9c8dmNvQuDtY1GTova92zl0rydlusjGIhF4HcaJGbUQQH1OlQrtrkhJMY+USJ9BL1DXWrIoLDJMk1GtUG4Kr2qpSp4H7G/la8skoX6yopHm69XAnOewHxt8YBmicjazK0wx2Bg8Pmc4EAYQo/+Vohp1SyZaBnPLV3lOfw7WQe4DURKPKGBsw4d1uvEHPAfyGm29AZ2KfgkEAdOZMmjnrOPWxiUHmio2g0Ei3D2JtcVCb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4NfpPV+rLdyqnsWObgNr7LdA2h9tGUIN7OlGOty9No=;
 b=nIACdV7GLO8UB1NcT0ApT3H46ndG6dAd/MtH1ptULa1u1CpnUjYUf2dvJbcwuYQ6GwqdiOQr1c+lP1iFJZqc78Stpp0QxP0TRGGARzO5hgPDdblOVlh0RBwZFdv8ZI5IUgX/h97LZiZFY6HMAWnziSrmFIMd7YC6puHDVhzuzFOKcV3VajpuLQ4QX4b/cHbTUa4WUdFFG3ZXL2QE296AXAxik6yMtfwG+NOPdyl+TZ10EnaJ2yOl8aJfLMQhm5y1OqOWe5+DcsSwsQKyRt3+BBO1IaglPBJkNTit+50vAQFVSKpC3HRSJUPlV0tZpiagxcnm8ib5YSdarikquhl+EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4NfpPV+rLdyqnsWObgNr7LdA2h9tGUIN7OlGOty9No=;
 b=Ngyr/ax81z9pjE40oC5ulwZMN3oYsctI+OEz50eKb4DxtSIckqOHpPDDRDMqJwW3ZIK+t+u51sKcwpGhuEQAIIjAw3yyPFbCnuTwiFPbNOj+sRn6BcUxa0uM7BwqGp5WMMgQVAuLmDBzAQv7ZHBcdRnb5J4LuZhHImvuqSSQ/Mbf2bZz2xmxDboX9JWPa3r8YMqw4zAviWa5pvVkLCA4d0H/OV/uPwt1/aoL4QZD4aHawtXNHYivY/rZyqz7+YJ+Pxzu6X/+ulXTBq04r7YBsk7anJ6zj19h0HpHe1YlqQkNn/cpKKeZtCFbvLCwfJolDalVkwIUPdIlNWIRKJgp/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:08 +0000
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
Subject: [PATCH v2 12/23] iommu: Change iommu_iotlb_gather to use iommu_page_list
Date: Fri, 14 Feb 2025 13:07:45 -0400
Message-ID: <12-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0058.prod.exchangelabs.com (2603:10b6:208:23f::27)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 64cf24df-e07c-47e9-b745-08dd4d1a2255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3Znx5E1var9lneZr0ZyKaqoMFKe6gbYak/fZUBd9qL2litLtAWASv7V4q16k?=
 =?us-ascii?Q?bqJPl6LyuvwwlYadsGBO5qBcfPWlSh6JRsugORXgAgSqwPM3ylfHcwsaDNdJ?=
 =?us-ascii?Q?2AZUln74rtNc39szCkdtUvMFiH/UK7Jql5HtjGEEF0/H4W1P/79z+jBogL3U?=
 =?us-ascii?Q?otkCJYaDQASIvyPfsLrTLkIVBt3YydLbDYKidyddKJ3pzll+If+LOcdK+t5L?=
 =?us-ascii?Q?rZ2iOGAX69OLgjMWdkjWtTULe6OK3lJ7fbhXleAe9KB65/X048WE30G2lRow?=
 =?us-ascii?Q?cHLhgxHeckwNXsMru720JXAYmMGJ8NjGMZqAtxV/MKsIHjrZdR8pZ9BqaWOL?=
 =?us-ascii?Q?jLuNLjHiNrmy1f+MtJBFk78qHM5KLUlud4y8M41FiV+RluR93iHUSwJqNcZH?=
 =?us-ascii?Q?7FtqJGhLLyB28QvFj1PwMZm8smFM6sjwzGHpYJtCNdgQxL53t+s6rO47d+lp?=
 =?us-ascii?Q?smkWr6C7a1LlgxNgE6UczyjpN1HHfijxgqIddyiAFAfAvXfmdf7kwqIW6Ae5?=
 =?us-ascii?Q?f93Bup79SVymwieC6+8bYXpZwiIoYj+0hoboGIPVCP1+SWT409PPdQq8OjZ7?=
 =?us-ascii?Q?WRa9TdXvolysfpZTIkIRetJyd0v6D6XxKr9AqeDKRs9Hh17j5DxtrULKQU+t?=
 =?us-ascii?Q?WelewzB8AKgKN5Qtiv+O6j9bAsB+HV0iaI8u6IEe+WEZQjphClICTpQQ9qVN?=
 =?us-ascii?Q?ZQAZBJbFDOzAiULh+2nfcq7qji8P+DlH58o7ZYAIuQXMIX6NwVCR78udO4SK?=
 =?us-ascii?Q?wysLu3R40c92lDYfqSJJstJtMJPLVFF7pVGcLv4yYhip7kxuKiM5UGjosVKk?=
 =?us-ascii?Q?xqY+VNKICvagWrWjAtfzfm8AEXvYF0idxGqU09SnIVPXiWCyWnT7TISGsce3?=
 =?us-ascii?Q?pGkVDyi/3HHeroCFiT1fVmbrDDWp6WAayKUjsiZuiIuncMB31a98GicflKpF?=
 =?us-ascii?Q?FWap5YiN9xXYD7CllzeFlx2e3TJlUt9gR/op3Z+TWQRYGGpOhA5HmN4aT2Fz?=
 =?us-ascii?Q?n2IhtN5AHU2Z/aGygWhuCY72RVeXgDm2isRW0uRFbs75QGVlZ4LXtQJeDfAN?=
 =?us-ascii?Q?LVEe86wOeZY1yMRB3Hc0dUo7BlZsUyTVRXzN0DnmWcLYU4uU6IKcOagRyJI4?=
 =?us-ascii?Q?EdzU7r5FLwNVONtcDnBoH2Aom5jw6Mq2spz2ZSMY5v+V89HRTsNdm2ejSSfp?=
 =?us-ascii?Q?+1zYEPCn/qcijV8QU38LHAgZUowK4/KxN3oUMZuQ/u5/uO0sQarSBOkNCOJu?=
 =?us-ascii?Q?fkDTeF4C121BOn6zB1ZqaK7be7llyGVAT3RItJIZkAclt8BtT8gOlA5THgAo?=
 =?us-ascii?Q?jdswgPZnYcC1XfQq5cJWU5fJge4IICjuiizjdnJzD5wJcD3nxCxh+jyfnxe3?=
 =?us-ascii?Q?He3o0kR0KAzJpqPDaHuao9nHGKcRLDjIOPtjQKiu2XjGptzmE3xLkm6tWltx?=
 =?us-ascii?Q?wk5j/Q1VrI0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n1diwQwqAMWqqEImIwAkQMKmCI4y1VXbqfP70G6uwxKfhuz8qxw2f7a1ceAQ?=
 =?us-ascii?Q?hxe9YgYtuXFoSkXneQHcVOP+gKKbAabnPk0thJGzKMq0xIGYdeiP6s2fh2PW?=
 =?us-ascii?Q?Igk9rOFCUMWl39iecXsR6jTwERuW6DOzfOClTMsfQuTv2i7XCavbUQWhde5O?=
 =?us-ascii?Q?KZ5PLMX5SQelt1XhXOfW0qPIWJtEDW/nRzJ0eil/GxLV5Ep4sN2uRpIiVk+U?=
 =?us-ascii?Q?5kblAyCRJldHeLzOrFH1S5M8LjMui12aXFNpvJYv0S3KunZXLemR9YFms9vZ?=
 =?us-ascii?Q?K5eeHBfLFysx6QsCFxJw62xiqrM2OyCevXzRTG9dYGZchKGg3QusRXPj9rcf?=
 =?us-ascii?Q?oULuvXjTQV1KNC+UTUdaWzE63JhvDYWA1ehnHQQeNsh7UE4A2qzAqR0h9YU6?=
 =?us-ascii?Q?uTI3miXbeIdPvTF9OmX72MHwPbICQTG4BNVCTffIzZHU1RgdPAexT5YFi+RC?=
 =?us-ascii?Q?BeoIu5yAjdcL/M2XtT/jLNnrgGdKluonHpaMZZSUgEOETPnXppn19jasIgPG?=
 =?us-ascii?Q?gQKrPnze1lCMYhBe+zx9xSCAHj4bmFC/WcTErjfQ5Rq9ZM4vxvkWD8n4rGr+?=
 =?us-ascii?Q?GluAOX76IgbTrf3wbGZO4As9UkDlyjpWGEsm/eyS9y4kjZ+y+c/J/v9iU0Tm?=
 =?us-ascii?Q?L/PMMKWM0RfhtVcJLDPyoe2hL9BJ/PTKYdqhZuCMMKN0bB3mQhTJN/tGINeq?=
 =?us-ascii?Q?DldOZaFtp5kqaNdPKp4TzFLNL/JJmVq4wcDZgTjutbcbFqcfAAAHgpgDa+xA?=
 =?us-ascii?Q?pQ431DGhK5Yfr2lvxZIh0fnRuyrMXU2loeq+O0qKTUoeYe56/u6hzpXd/lEj?=
 =?us-ascii?Q?Ykh/6E5FlwoAbyg3qnp1UOFrEfIURidCbBGlQizPSKFgjoBAwzDPS6ApeoQs?=
 =?us-ascii?Q?m3GHYKsAGFFOEGb7GxAk0jwg8xBut0aNNu3wo7wRnpcZUJ1kAJLIJamPsn7P?=
 =?us-ascii?Q?9jJBBkbRvaKAHFBed10WcX2NAeehD7r+Z8vGXA9ubhN/LKfIClDG4Xtew9T1?=
 =?us-ascii?Q?g9zOgHFYtN5OqklYqv5O19Rk1ZpjL/UGbP5fiTTz/VKZXKFNuOcmlQvdNDpk?=
 =?us-ascii?Q?TCluj5e/R3iHfE6F0N/ydV7mJA3f2ZUDswLYpCpZwWmgfHMLgiDpW4Caul6O?=
 =?us-ascii?Q?yOLfCyL3SUB8m4MGiddgVGAKKi5t3nQsgstpAGZlZus2822lqAWX4Eu3mHkN?=
 =?us-ascii?Q?8rlp8Y45/lIW1qayDviJmocNacLXtbezNFSRsbYX3g1t3qay/8Ihl0ABwXnE?=
 =?us-ascii?Q?TH55WtI5whdB53KMPccYt/8c1XDaWl3xcOK7wihK4vzxb+DMxybqFQXEcHf5?=
 =?us-ascii?Q?C6QIOy6DytuotO94Tymep5uaPx7D7XMvzGanvEVaSJ/jrxcQh8vbi8dC/oMy?=
 =?us-ascii?Q?laKRNPD3DZFSktJ2r1AmtIU8qxrAuhKMQaxOv2QUukGPKGgIbUfCAJ2qESw+?=
 =?us-ascii?Q?NohpqwBqiIiuz8Az2Zlv15vXullWd0U+DHi62rLh+xRJewoC1lgXV9z3ih8R?=
 =?us-ascii?Q?B9l824GkymIznQ+tIWmsjkufpkbpC3fPPUawUlkwtPVwBAlGEiCk0yz6zoG8?=
 =?us-ascii?Q?iYwe2lOY0Jw6vCYhK+Y=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64cf24df-e07c-47e9-b745-08dd4d1a2255
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFi8XxsB5J8qp88jk5oLsD+5VGdfy6kiRV+PAimcOmaUSKtWTnRbR8OjcvpmgJO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

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

