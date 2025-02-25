Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE9220F079;
	Tue, 25 Feb 2025 19:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512400; cv=fail; b=YVGDvTBrvs0H4lhEsyXeT9x8KShxzXiD9ZUwgCC/r8HsxzxD9Ilg8KCsvh3mXv4RkXRYsQVoVaXXvqL0tf1kYuWcW4dnpcr61IWEzRZucVFLY9VphHykjbm2DVV13hUMDpqx6wYOpzJJ3kVkQ9PSZrFSHyyf8iN0hyBaq871Zps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512400; c=relaxed/simple;
	bh=cBe6jIfDJFYXa/c3eIS1IFc067JNyob/XoufAhKjwFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EzWUQzZqJFjxbD4vqzMrwbQL4i6MPIP5RcxQ3yEEAti7vA/Ca8CPFBTOmHllcuQcjZfWhMdCqI08a4Tb4I/7gEb1D9s9Gw5xBMJRfnYcYN3Kau4umEGqwL+F9pK1LOmUrxWxTNKrkNDin2CuZQ7Oy+LfFCAAeeqq3gYqo+m1Uwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UHdyyH4F; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UHdyyH4F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJ5gqD3eoEx5P0CeHgpGODciocbzMLX8CusV4IfBeuZgYF1M0BQUz/wcpABcKNzl12MPywh6V36Bsm5BYuIp1i0HQQ8dOjhJYwE7pI2X/arUDD9lxUCBAvLDhEvWYMPiKb44qhF71oSTaphIZeRnSYnQETPvN+k60OAnvrGCEYRm0wYt/Dtp4pQBQL8ZY8auYMPpJ1pmucKPaKcxAOt5bfXLWNOF8ma37qBPRjkGVkmv3KhL02Y6J8vgqexwTF9oRF9njVKybLC25r+f50OH/9iqJJtDTWwxsmxOFyo4xX47RihwEnPyG6iih5TRd12vKz4PNwAVqbqcxqDGyumoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zuKTF9RfQhBDm53BmXULY7I+FEz59KIFvuzGP2148I=;
 b=lSf+FdI6sPUbUiKVP96Z/ux11mwBBtsfUi/DAmt6NVtNRDwgsuwjkYyZMv5X0B+a15q1gASBvX8zcoUu9oDgFaKK/N1j4J4T+EdZJPoSKw8U3HCCkxFMyOVURPxFe4IIldCkiIpvXMFGSe/L7+ago0xJGA3Iv6Zvv9LM5IsLkjjmOuSSyUFvQo0iOCTs6ek+htN0mpZULkVB45jcMicWcj88lj3VYqj0cBE2UvLSsJiod+gIol8GDg91KVWWkrFSDaeBInR/5oe8HOQUBExeI5HLKQCqJzlEH25OLwtjRL82tEPRjDirPIoizVFsDdvlYt4vCSL80OvCkthmWm/cdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zuKTF9RfQhBDm53BmXULY7I+FEz59KIFvuzGP2148I=;
 b=UHdyyH4Fgat4bFyFggQ21ETs+8q5MkLeY9NhTxadvPKHjwcgXSb0L9Aj+hvEQ09M+0/DU6aGkBLwiMW1/X50svFYhOVD5VF0ruVaYdACkXR/NbN3u8DFJt21gLuESgqwb0m0G3yHmo2G9B3yFu6gM6rtUpGHPAsGsHVtN+U+Do9ljMc83NXLc3CZaMtwY6Bb45Tl6SPYVtAApNj1TBqaQQJOOeDkvzTLleNI8Kq5C3PzYKPmfHKYidpnR0ObDMbFlAj4/GYeEvjVlqAeovOahRwyV3HnQ5/Tio8+YHzW2c0Ft9CDmPpdnwoC4KiAhBaecV2xMnIOEDsgh2h2Af49Eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:47 +0000
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
Subject: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz instead of order to iommu pages
Date: Tue, 25 Feb 2025 15:39:37 -0400
Message-ID: <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4ae4ec-2289-4b47-9485-08dd55d42731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?46HPGtiQIalG6mUeczIL0887dNEeoPWgGNuS1+PnLxCr5hCO838+PhJxjG+J?=
 =?us-ascii?Q?lICw1YF/kYpttBa+re8qSFnqMTSVqD55YfO7bhpltm0t16MH4hJu903XQlX+?=
 =?us-ascii?Q?9Fas26SLLhJRn3U+BLnPY/ebwB39vN6bUe45XKRk43VjslJeSWyr4v+IxUeQ?=
 =?us-ascii?Q?HyKLXc/hRN+fERja43ta7uS5hVUWAh5cBoi0gNNPWLNUyTDDJMDHc/D+bjNF?=
 =?us-ascii?Q?zO2v5nSZYgQ64SMvjZ+s6S+Hvl7+Is5j4DfY9j1BC2R81eQegGOy/Neq3wH9?=
 =?us-ascii?Q?+r/YORehNgJSOnveUzs/Mn3pMg6MnCg+e+O16FhmhNl2C2p3Mm4Bqp0kMEw+?=
 =?us-ascii?Q?bqCG0nLCDAOAZ01/Q6PHonDqX1pcCLDdyukoWbZV5q3EA33+myaQsf8G2258?=
 =?us-ascii?Q?3EptgsGBCtUhpX8Ow83LRbLu9iRH38av+957Fg88MfBx2ZH6L132oPcbqLRH?=
 =?us-ascii?Q?GqkSOUfFIUNHuq/CPseTIKy7mqT6DgNlscNsn/SkAYlt5ei9jnKOqzx/2nCG?=
 =?us-ascii?Q?b6Q7Jc8jRfTPvRM6WzZMwRycj8+IJjU5qFqwjm0CwNh8E52SNTdyX84V3x1v?=
 =?us-ascii?Q?yGWoblCZ0NNd99alUywV+2b8MwOTIhc3HlB0dwsezH1hmhMyyzosjRGbDNmq?=
 =?us-ascii?Q?0tX4ByqJkt0F9EGzMFOGuv0ww2qLllwuBsCfIOB8++ch9XFGUljRet/yv+25?=
 =?us-ascii?Q?uJ+UGEVsc3kxT6YK7TX3rI5OMpcNwFxVTayjUzOAEbJAD5zxRkmM+PgTWBSr?=
 =?us-ascii?Q?luOga15hBy/TwiDuFbdb3TNCpGXlrBBpdYyD5yqGiJIDIyQ+6qQjAjmpaETv?=
 =?us-ascii?Q?EKsWFfM4jaK7en2AnDeUMvko2Kg83WCo8Uz7ZeDo+5FzFR5O5uqlsc74T14f?=
 =?us-ascii?Q?ZCO7j7qVMD+K3m8ulrM6RCn8OpaUuDiFpZ6IuJbE3WG8vBbkAY9ackilhSaw?=
 =?us-ascii?Q?zEtDiVZzJR0kaQVhCFAHTSK48n9DPekijq2ScdYcSePrL9IdYydMgu6TItf/?=
 =?us-ascii?Q?MR6/20rzBQ3E6TCCQ20mswFo+tTbZ3/lemlxb0Ys564co8/Ey5wECuKQeFv4?=
 =?us-ascii?Q?xLkf0ZexpoJ7xK6rF5XjJdd3ritxiyN7fwVuW+OSA/cfQ08s6snUV7FV/lfu?=
 =?us-ascii?Q?S2GBRdP/t+MWyI/DCOlZRMX2OBjVNUUnnOiUV+8AKZ1gfNT+cuzzPC/Vaj5j?=
 =?us-ascii?Q?fQZI9Hm9BThtHxKCdW4EdBGqyS/vfZtUNIBS2ToKd4SH9Yc5nahYuLpBmkAZ?=
 =?us-ascii?Q?45an9emaoVPaFaLsMBPtxITFhkGb0GajteJ39nsyfkJcXU4TRfsAjBlTaDJo?=
 =?us-ascii?Q?ZlzI9w7Q0AWt/JMjiVPRTNLOIvwtJTINCP7M4cbFMxjbE8Y2Obcqt6y3uFQ1?=
 =?us-ascii?Q?6nQ7w+cUCpGwYm+2jup5NqkH1iqedaccS6SyvnNKSwITDgAwC4yIO5xdw/vi?=
 =?us-ascii?Q?09NtCogx58I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AQdlQV0gl7EA0eeRxDqX3VagBVnxfKETosXBibdXS83I3JL72wZj+cKN4LS6?=
 =?us-ascii?Q?bOQyn+IWhke2uf1WMbuCyOAlZ89m6Pmd8ab04Zsd2RZtUoBcwrfwnJzV7Ffr?=
 =?us-ascii?Q?+tWr23jYMjP5KFnVkep/ugnONFRiPjRejP6a2WpbT27c/yIkpTHLIiAqpZJG?=
 =?us-ascii?Q?IWPsU1z+9HU6HbVaf/5Q7e8kPDk9f4mFsOyfarGxvK1ZjCfjtypt3Yh/K//k?=
 =?us-ascii?Q?Io1BSVCjhw5iP1iecJoutwOGEK/CP6126O3g46sfN1tAuLgXgs789+GVw+Xz?=
 =?us-ascii?Q?h6ZQDVpnljb57QZkxvdIy09QbVZmASC1IXs42te4FGIu679jTPsmu87jHT04?=
 =?us-ascii?Q?R6sLKjqXJgYzNI0rx4qtJlrgZ9/9UuSJacGzO3njJ6HFBIb6Wn6AcUmeMsEW?=
 =?us-ascii?Q?4PygwozfoGlLORdqbIiEd40kGxosXuU/KFZUmVF3TcRR5qPlfFxvFYVXovJM?=
 =?us-ascii?Q?jsOqlHC5GFuGQcRhKqTliJIBU276F3e8/BRhJXvZWih3n/7C/cc8PXc/sOfg?=
 =?us-ascii?Q?nJsWndCO+jEHZs+920O4XffL0fwXDHGF7M9pAk+mjaK7r0oLaRSe8p5tTGzE?=
 =?us-ascii?Q?qv5ar/I+rGMBqBoSGN6iSLpu3+VhHGC7jkJbVpABxpT4XU4h7KcZinxoW1YR?=
 =?us-ascii?Q?XyQwxhFaM/fww/BWt9xHnffvM2B9LJgGFB+F5jVWCa0PBOWgfqpmbKwvlaHm?=
 =?us-ascii?Q?+1FtiuaF8YjvXFw5W36kabYjYEQj84nxKi9wi/thj9YD1qIhQM06Wmvb1gt3?=
 =?us-ascii?Q?tV4oXa91HwHb9swp850w6FvYqbYjFdv+40dxvIx8RLgIwOOs6TPXu/623V/H?=
 =?us-ascii?Q?aKfL+52AFDzk8W0SBzoJYd2RzLup7UabUyu3MX12UU2NEFCep3l6EyE3cSjU?=
 =?us-ascii?Q?fuFlIh2NeWswmx5EAxdix7KAA8o3WtuqB7rQW6JIH37tQ2aG/IROvJFjfCfO?=
 =?us-ascii?Q?VaLJbHn5OmeEAE08GCmQkL/vtokK9S/lHLZx4kjD88WNbzxhOjus3Gw/Z3+L?=
 =?us-ascii?Q?3yPOmfL+OmYyZK2hUeKCB+3dJgmjGcoZFbv21bMs+ouIeyjb6AnR28mNZ6kv?=
 =?us-ascii?Q?AzQxtpWzHdFVK6wSikEgiGPJkGTUU1ZgeM3yJtZzXGp28T86nyGYoKgm8mfm?=
 =?us-ascii?Q?P1TGySXiud0xT6crJxR4uW3uZlslOkbw/YEcD6WlRDnezlQBXRQt6XmHC4uI?=
 =?us-ascii?Q?B+KPstE0Hy8oN10AdgtLfgXzErqqU44kva65gxwASsAz59TSPsSgRR8ibT10?=
 =?us-ascii?Q?eclR6DD79zOzsyl8+Nh9xd8O3RmXh0Dbn4XmMlxb7XtoBiR60CNcl3SPUqhx?=
 =?us-ascii?Q?r3Av//EcmD4QqK+IXdlObkL6txFPshNNfgfr/f/XYf3hZCYmSvmT0qOVxaq2?=
 =?us-ascii?Q?2KVQqVRHfAsj7Hccu3PV3P3hYaSghTEhJEn1yBpdifE0nNYcqKi1zGh5FVWj?=
 =?us-ascii?Q?J+ZAwdd05WCUmErBhO/UYbWbZwD7DEt54pB073hUruK2HHdO0Nf5NdEQRfAM?=
 =?us-ascii?Q?AfZC7MSYaatxx5jsAYguNigcC25YBR0Xz4mnhCN/fRh/l2V4zcSjM+Gwjxwc?=
 =?us-ascii?Q?i/AqJBQd8M4c/rm2Dvp7Hgzrd3O+Yzh2cygT9lBe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4ae4ec-2289-4b47-9485-08dd55d42731
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:43.9095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6mTGh1Ade/qJkO+5pebf88kNaseM0ECO7eDAh8dwURPuv8VcuKGrkK82h5t/Rd8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

Convert most of the places calling get_order() as an argument to the
iommu-pages allocator into order_base_2() or the _sz flavour
instead. These places already have an exact size, there is no particular
reason to use order here.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c        | 29 +++++++++++++++--------------
 drivers/iommu/intel/dmar.c      |  6 +++---
 drivers/iommu/io-pgtable-arm.c  |  3 +--
 drivers/iommu/io-pgtable-dart.c | 12 +++---------
 drivers/iommu/sun50i-iommu.c    |  4 ++--
 5 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e3f4283ebbc201..a5720df7b22397 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -635,8 +635,8 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
 /* Allocate per PCI segment device table */
 static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->dev_table = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					       get_order(pci_seg->dev_table_size));
+	pci_seg->dev_table = iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32,
+						  pci_seg->dev_table_size);
 	if (!pci_seg->dev_table)
 		return -ENOMEM;
 
@@ -716,8 +716,7 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
  */
 static int __init alloc_command_buffer(struct amd_iommu *iommu)
 {
-	iommu->cmd_buf = iommu_alloc_pages(GFP_KERNEL,
-					   get_order(CMD_BUFFER_SIZE));
+	iommu->cmd_buf = iommu_alloc_pages_sz(GFP_KERNEL, CMD_BUFFER_SIZE);
 
 	return iommu->cmd_buf ? 0 : -ENOMEM;
 }
@@ -820,14 +819,16 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 				  size_t size)
 {
-	int order = get_order(size);
-	void *buf = iommu_alloc_pages(gfp, order);
+	void *buf;
 
-	if (buf &&
-	    check_feature(FEATURE_SNP) &&
-	    set_memory_4k((unsigned long)buf, (1 << order))) {
+	size = PAGE_ALIGN(size);
+	buf = iommu_alloc_pages_sz(gfp, size);
+	if (!buf)
+		return NULL;
+	if (check_feature(FEATURE_SNP) &&
+	    set_memory_4k((unsigned long)buf, size / PAGE_SIZE)) {
 		iommu_free_pages(buf);
-		buf = NULL;
+		return NULL;
 	}
 
 	return buf;
@@ -922,11 +923,11 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
-	iommu->ga_log = iommu_alloc_pages(GFP_KERNEL, get_order(GA_LOG_SIZE));
+	iommu->ga_log = iommu_alloc_pages_sz(GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
 
-	iommu->ga_log_tail = iommu_alloc_pages(GFP_KERNEL, get_order(8));
+	iommu->ga_log_tail = iommu_alloc_pages_sz(GFP_KERNEL, 8);
 	if (!iommu->ga_log_tail)
 		goto err_out;
 
@@ -1021,8 +1022,8 @@ static bool __copy_device_table(struct amd_iommu *iommu)
 	if (!old_devtb)
 		return false;
 
-	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-						     get_order(pci_seg->dev_table_size));
+	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
+		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
 	if (pci_seg->old_dev_tbl_cpy == NULL) {
 		pr_err("Failed to allocate memory for copying old device table!\n");
 		memunmap(old_devtb);
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index c812c83d77da10..4c7ce92acf6976 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1681,7 +1681,6 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 {
 	struct q_inval *qi;
 	void *desc;
-	int order;
 
 	if (!ecap_qis(iommu->ecap))
 		return -ENOENT;
@@ -1702,8 +1701,9 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	 * Need two pages to accommodate 256 descriptors of 256 bits each
 	 * if the remapping hardware supports scalable mode translation.
 	 */
-	order = ecap_smts(iommu->ecap) ? 1 : 0;
-	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
+	desc = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC,
+					 ecap_smts(iommu->ecap) ? SZ_8K :
+								  SZ_4K);
 	if (!desc) {
 		kfree(qi);
 		iommu->qi = NULL;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 08d0f62abe8a09..d13149ec5be77e 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -263,14 +263,13 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 				    void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
-	int order = get_order(size);
 	dma_addr_t dma;
 	void *pages;
 
 	if (cfg->alloc)
 		pages = cfg->alloc(cookie, size, gfp);
 	else
-		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
+		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);
 
 	if (!pages)
 		return NULL;
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index ebf330e67bfa30..a0988669bb951a 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -107,13 +107,6 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
 	return paddr;
 }
 
-static void *__dart_alloc_pages(size_t size, gfp_t gfp)
-{
-	int order = get_order(size);
-
-	return iommu_alloc_pages(gfp, order);
-}
-
 static int dart_init_pte(struct dart_io_pgtable *data,
 			     unsigned long iova, phys_addr_t paddr,
 			     dart_iopte prot, int num_entries,
@@ -255,7 +248,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	/* no L2 table present */
 	if (!pte) {
-		cptep = __dart_alloc_pages(tblsz, gfp);
+		cptep = iommu_alloc_pages_sz(gfp, tblsz);
 		if (!cptep)
 			return -ENOMEM;
 
@@ -412,7 +405,8 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
 
 	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
-		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL);
+		data->pgd[i] =
+			iommu_alloc_pages_sz(GFP_KERNEL, DART_GRANULE(data));
 		if (!data->pgd[i])
 			goto out_free_data;
 		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 6385560dbc3fb0..76c9620af4bba8 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -690,8 +690,8 @@ sun50i_iommu_domain_alloc_paging(struct device *dev)
 	if (!sun50i_domain)
 		return NULL;
 
-	sun50i_domain->dt = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					      get_order(DT_SIZE));
+	sun50i_domain->dt =
+		iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32, DT_SIZE);
 	if (!sun50i_domain->dt)
 		goto err_free_domain;
 
-- 
2.43.0

