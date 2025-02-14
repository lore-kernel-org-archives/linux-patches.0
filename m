Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8175267B11;
	Fri, 14 Feb 2025 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552886; cv=fail; b=cnDn5Zo/2Gm95VYfQ+QdP1PDc60iSIwXScZo94Flie0lOzHmgAoT/htC/Rmv9BiUJ76sanewTjW1+c5yrvvTBBnhyPgw6eZIbMnA6MRjJU8czTSuI+zaiw16O4jkh46tDB7jTekcMSd3llgJFW+uiRFhafQiMRljE73tuppcJQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552886; c=relaxed/simple;
	bh=cBe6jIfDJFYXa/c3eIS1IFc067JNyob/XoufAhKjwFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CyIFnp9RKhoaVavRA8gGvljcBh/u03RObMqOUsEyrCRq24e71pHGy7iJvfqPLLxiC9zuLACVIDVVo940cgigSvFVHPYhkC+D4w3wxRvfYF94ukOCx2lCe4GTRqKmQn2TC79wTxIb84yWxZ+UzhSRymQ7PHXxTnEjMPKNUCPv+sY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hgDwiq9t; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hgDwiq9t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TthxjFNdAEq37xh/vOOKbz0sZHTixxwRVqzlvW9eJ3AW2dxpF2W6oG/Z/e0ChCUx0i+MAgJbF1vT4G+OGeU4ZuXgx2G0bpGaLl3iB30UlUxluCaW1iR/XLSsfTZsNnLjaekCitSFmVsKtyRIzJmecZG12q3429aTkfj/sU8sZMvpgBMD20gceNRFcrdYPOzKNRrotKp2QPRR784UAPFrXLsT+oQmqNTzegoLo8h/G/eMII9oWMdKaNiFAIuJwD8RhP95KgVYUUXwOJc9LOXk+Q4Mt27uPkz1Y3vxCKRPamhTZV+0vEF+EApuf+aolAYvQTsyvbllzHKGp153vfo1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zuKTF9RfQhBDm53BmXULY7I+FEz59KIFvuzGP2148I=;
 b=SH1g9Sfd7/ua3HXgPf7wRmBnqhPLvroE3yRrv4CmDvrMgB+qauWITJ9RXxzmDb57NN10HokWcsHUUZBhKE8QEtn774P7mnHYX5eMnFYv7C9OiawPaOmY1LHlgIL3mM165sGBT+xEMjln2ZlIbboObkpxD4tISw3Ke7tezD5d9fa9ezW+UfYkONJJXGIsS72z97u6Kh9HUGAdQMBkurf1h5niUCKbKFuwQ6z93wk8aGxhVzx6dpnSl01HTvjgmus7h2fEHQuz9wg29iGdNF8AGTfSKNsriTA6gv7a73DVrtUof0NabO9ONsz7pA1GgXQiSpNWfq/yPwSbnuDO9tUu1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zuKTF9RfQhBDm53BmXULY7I+FEz59KIFvuzGP2148I=;
 b=hgDwiq9t+Z640F95G5VGu9c3AL1HNXeg4rffsKH2xjKow/90QZcsF6Gz6ht95MCq2JYMExPGqQhaAXnAXOEyvKesUzQJh9xGmojFPiFTFfpw6umbcNwj7oKWXeoy0tEMKqBxjkZzRGr+MQfsfxCeQWEac46RNRt0kZJ0blzgxp4FFHwXgEZzCfbZ4vZxkwA7ftTYpCfSkEbtEIVjYlrnHpk9HCFP6mHjk/kXgHrPOGtvWf4qNvXMkRvP+TMOq23/qupBaeqZA3B7h9ki7xQvpk3kD4b/1Wo6neoCq6rcguRseDJCdk2izPYu0mw3kNdoflfJyBvD8EDPIG4f5SFW9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:00 +0000
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
Subject: [PATCH v2 20/23] iommu: Update various drivers to pass in lg2sz instead of order to iommu pages
Date: Fri, 14 Feb 2025 13:07:53 -0400
Message-ID: <20-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:207:3d::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 65e46406-dce0-4810-19a9-08dd4d1a2177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NsgoVvLiZgIwcKydFW0/zFhMIi2JtqYTTWFZ4pcXYPLeZHI2nOrs7DouVUa8?=
 =?us-ascii?Q?o0vamrGUFO2tjNOKS1pSNxcl1WcoK2V6yo09IDBJ/vKAnu9JOoN5uS7F6ubv?=
 =?us-ascii?Q?TrUhNfjllcKBI+sexwBhH9NIes/bxchs0iXykEZYSe3Gnjf0cwrCkyddW43w?=
 =?us-ascii?Q?zmydIUPpzRO6fOoXllrMdkU2TS8WJrVjSal7nASqfr0ybuu45iJD1CVKGivD?=
 =?us-ascii?Q?OAxsQ5bcdQSrLroOkVh7kVKpq4coNJ+8YDt3yoGszlaH7ESp0K0r6fnNDZpn?=
 =?us-ascii?Q?AkLljQ0pWSnAc9Mav7TjmGqoTcipRde0ZWuNCvprT1C3/xpltKKUScKYGdLB?=
 =?us-ascii?Q?lkit7kJ+VKJf/Of8qh2E+eoZ+BEHp7rENs0r9QLA8+hUKdDNlMOboc4HV9X2?=
 =?us-ascii?Q?2Pix0Ss9y9fQS8VEQxiov6q6+ehS6isHcS4Fgw/7ZNHQu02wF5pHdTKLv52a?=
 =?us-ascii?Q?dWCmZkOWg32FdwYuGezXFdjgH0DjDnYlH6SlMtSTDmPyEMy3C9Ccqsd4QVK5?=
 =?us-ascii?Q?krOUCE+/eaaa2dfuJM5OYEaIaKtWZAxj0V0yjQwAD5zXw0b0hkExPSqQdxj8?=
 =?us-ascii?Q?HeUbZinsvWKUazMo2s04BmNtZBHK38ZG4UE/MFQZ0aNaxtXrpFdsY2yuzJ+H?=
 =?us-ascii?Q?IRlXMX3GGp4zjeFhxybj44wMPxMjkPXj0eq5aF6MOBk6CdnOVPlTEnbW8AlS?=
 =?us-ascii?Q?KSkD8uh+fO+UVoblRxSiQq545wWZtNIWBPSBf5wRg/QM9ysJyKBxnraG6YKE?=
 =?us-ascii?Q?bPbmBUM5by/RhTYTkVZEhWvES+OyMXgshiRHg6yhrKMdz11KoUa85V0k9f1z?=
 =?us-ascii?Q?uBj3d66HZTjE16Px2am15RH2fx/meKQiN+lqgfDRF1WDATVaBaXJ0t50dYAD?=
 =?us-ascii?Q?rOserO2/3830TqgBL+VZeucfjBXzdtAOCsrAVypQ3w9V6z702EgjX+Z53ObS?=
 =?us-ascii?Q?fHUWeHgKAZ27v1TPCK6iZ8I1zZSEWfm82J/KcRUV5Bcwsjw7IAAjevxWWiF3?=
 =?us-ascii?Q?90LfIgg2VVDXLZoBYOzO+P0ma1PDzFnTgVoQekfHws8SD0pmB5aDWexJWoyJ?=
 =?us-ascii?Q?9+aeMeD65uys+ygXPnjsj6am55Pyq/nUOf5B2+ZHESBxDuCQ2S6gAMWkSE+U?=
 =?us-ascii?Q?dmMB/Uy6cNCfR7rD2ogt5Z2NX9d4sAPBaJgOxt4sKdPape2RpaKC9QwfLJEB?=
 =?us-ascii?Q?GDqigMMcWZDd/jAYW6Q7JXPxdcGKr9pIJLcAD7jqS9pbZfIihBZdM2f3HR/p?=
 =?us-ascii?Q?aIMiDsdBHAU5HwFW2/kIlSXFwhq8HfghBFqRCt/Q5JaTFMxkokTNCxbt9k10?=
 =?us-ascii?Q?qipaW5qUMQrZoZHiZ7ykb7vWJHeOlK4qFOUc6AMqviUekzKBT49dEnCX1i/M?=
 =?us-ascii?Q?7U50hILBrdcXRGc0iacESJpKpWlUiitguTvz1awkx1RtuoEjH1WkglLBEuXX?=
 =?us-ascii?Q?dCTDoh1iGTM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yjx91Jbw5jpLSgNOjYDZt+D1Dj6zv6usmMoIQDxNXXAwUpQPk1rhSqUzhdeK?=
 =?us-ascii?Q?1sx+/Wbw21mhhgzjB0qkX5jfdiYazV4PDbk6WPjKgxILg2qcpCxtG/ItAQC5?=
 =?us-ascii?Q?CmChWAPwqVj1uBdIWSI9UiCHVo6WM/EEBp2iy2mR4zlFi73cZatxT+Gwym7R?=
 =?us-ascii?Q?+3gcu9b33A7f+io1KEYJfNcY3cFJtq07IWOeV5NGu9H0pD6VmwrLjJjiRqJF?=
 =?us-ascii?Q?LeXiWTHHusJ7o6nYOYkAKV5a8QIxtpgX58Sk7nfnyRHnygYnHTZ69hvdSi5t?=
 =?us-ascii?Q?4Gp3k80eZGBLu0eSL68yxE+jFK99nJDMtZnf32H857oationXyvoR5PFwAg9?=
 =?us-ascii?Q?NN/aVYW+MEmFR20mVH+nULWvB7/G/Ak+T2fvQ96JcsnkYGXKfOS7SNLQ38Mn?=
 =?us-ascii?Q?jRtEc+aLUzx4QSmrxq1+pF3AcfDgduwBE4fEAGeqetZVqXUkpAbsHpkrzhB+?=
 =?us-ascii?Q?hYWK9wjiww8HYXKE+C7pv88SznhoPKtzeEdUeeoAEd0oIjc7HT5BUiDILc3s?=
 =?us-ascii?Q?nLaH43U0JeiyfvYjZ2eGRhXqpD+5Dmb8oYmVQvMiVWws9P5sBrxJGPYkCyjJ?=
 =?us-ascii?Q?C1KVftxLQ6N/RNAaZ2/d3drkwPrXPvSluf0ie2CGUzImIMyE9cAOV5puSwUF?=
 =?us-ascii?Q?181VhXT7Nxf4NuHYzr5159Kgttzq799F5gvKZ8C4om00cF+syY6cjIt48zQ8?=
 =?us-ascii?Q?Lm3fI9cjgpnYhPR6Fn4xh/V28hjIf8mmdN1bOe4rT0SJNXUqHjv5QRSLkmGz?=
 =?us-ascii?Q?T/AokUIJQ3MLyRlVkvY76uajbSMXFOkKDFGOHdoFtJB8i+JHZICzetPv96j0?=
 =?us-ascii?Q?HXV0p6LOZluHmb9eJLkStbzuWqUcCtwuJwgWNpfCIPdzfAxlgoZ6VWgYV3nQ?=
 =?us-ascii?Q?9WIJ8ZHENbvAn2qVMjUWBtvsDPLkg1gYo0U23v4fDR/1rTzWlxdTwqIZC1VR?=
 =?us-ascii?Q?FVzsJwjjYfnLeQuaW1uaWrSbHdRi7fAa+w2y0qHjxKg9PNZAYnJtoXIOzlMj?=
 =?us-ascii?Q?M5qn5bkgU482rCNR68b32qsssplu9GOjmbAI90MnugPimcc2kr6wT4iNo2aY?=
 =?us-ascii?Q?g0nRmWsJcMJ12iRtJ1s5pJBlkRicr5xVl+37L1dPIZ8do6HCV6Hew5+UJMGL?=
 =?us-ascii?Q?HSkbk7WdBWmAsuiU4Cv9X2RRCdvpP1oWkynHVs/SUYhxlmvuw8Pp0WKkXyeV?=
 =?us-ascii?Q?S1JEd1fVXtMQkcwwiwdHRWenwp567WDt7fIxd9c3U+9VAJ7GtNdm5RjZzVGs?=
 =?us-ascii?Q?6Npp6APZj11odPJUS8QpS4uNci+7Jq8xqxkIGYEN2DDJqxDfSjjkLZI+XS0p?=
 =?us-ascii?Q?3fQBrclbc9ZEI/Biw1GJIKzcWNVozqsh/89ciZ9OY5YQm1BhkcK8BfcQA+TJ?=
 =?us-ascii?Q?dFEjRc+X6/t0u4IXgVheO3Es6TrROS9vIThwbMxZeeoU6U5fkCuQW1/+8sbt?=
 =?us-ascii?Q?ychfanRuv2Uz5t7pE9c2bDj6nGkqAqYcO0ch21d98xuZohv71XyrrYcF3TaA?=
 =?us-ascii?Q?FEXZMQza5el+/nF4c3G5K3DqitbTc2Xb02kpDxxhej9BC3cKgj6HNBTntdjO?=
 =?us-ascii?Q?a2gz237ybf9p57xm6m4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e46406-dce0-4810-19a9-08dd4d1a2177
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjgQx72mpjTnt55WENwB3zsKp1dvK8+EE667CMR9LNa3qEfzmTbc2pD/nVorJMZW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

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

