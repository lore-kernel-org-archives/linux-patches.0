Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCA51990A2;
	Tue, 25 Feb 2025 19:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512692; cv=fail; b=m5SY3pcxGb8YA5N21hC/x2y/TQfWUIXprEX7zu9Th3rzZvPJAf0HKNX5sCF6mJJxrqLxFPlc74pQq1Q9t34MiwFXUBfE3az082vMcJrT+nJd7Vvd+EZCIxXvp/QLZqKoMyCEqe9avtAHP1AVO97PHexpgDX7svBQvO7Malh0izk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512692; c=relaxed/simple;
	bh=CtW5/CifOx9yUhMy6oTr/wrdWvqgq9sRFZIUUo0XUj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tAxghyYloybHY1up4orHdhvmxLvXJeX/4pz1prdhuref2tTKQeRFgJM4EUPTU7L7hiBNKzWShtsYs4L9/Dc2/QwTFqNIj5UYDW9tGv3bim+gSZQ+9+yTHRa3eBe6jr0dG9zgzmO0wKIfgDIK+A/MUYNlKCeFSm1bGjrmw314c0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ob4vGdEY; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ob4vGdEY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GxOkyhiHgX16EEKCeSad6b75NaGMDEgfCzJxMRe4wQXbygwWA/lVi3hQTixGKMl//TfvJUhsQ2nTvZALe2ZTiOQFHBaNVRq3aaUBHR8BXfpfhgJBqe5eR18+HZgvDHVfbzisasmaNImzwkW/rWKyKwFJiOgjAMrLuMHReBud681krps4i/wUV+/PV1m3WFpvGfQq4P37vBT9GsXc+1Tqeya2V+JWA7T1OFcIGTePPAA0flrvnpD8CPQAbP+W1MB9M2kRHCwbcYvQG4ZMJALtu0U5awbyNnLpQT7nnW6isPoObJJ5PSz+0vsZ0QyrIAMJmfY4IMkfZKOdjStIy9DrGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DZWsvdTAy19EE7VrKBkVg6EJIK7tqUPMojrqwAdEJA=;
 b=Cowy/W/33GtOGjYbg5QE9qGaXjmT1MSCmp5qVXA8olVreypmPMaWkUfboQC6wiNqSHwnpsB71HeX63j4gHNr7jGu99g/dmDtkfRXN+D7ij6VO2u2TP9CELqVxCwZDMcALq7KcYVqFKsEaxdf2saEH11PsPQ15Q/InFdUCkqu8huXaQs58io2oP1nCNSUyNzHeUdySfSUlhBwqR7CCS1GOMkxb1WTMR7GdXmy7UxC4MamCo1HuxxkZLlFoADqYSzfcAS5PljQHJzOkt3mjVoQq8H3VzISqV+0H+mURPvz7k4pX0POmCfUgNJ225N30BXsfqj+auUa7Lbq9xqIfbsnZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DZWsvdTAy19EE7VrKBkVg6EJIK7tqUPMojrqwAdEJA=;
 b=Ob4vGdEYOh19OCEuGXE31ir0KrzeGXOIZ/UyAETchMpuZ7KunqssVGCJ3H8R5kinsAVM7n19UPuRgGVmxAzdQHf0Ca5RPrSYWYFIgc6ED03oIlBGN4+vVZK8jxC0g2naAdemqNYRaurENAijZeuKo78F8v9FsIEh+06rNOPFHzLynHjxlITCaZ14ZR9oc2rIuzzeh+X3Xe60zOt52uTaOQAiyHM2xa72hBwpAfT97z/0JEERCck5PlkYRnmyYYXSa//DCCJJI0ldLADbzrKQwvQIHdCvxyKyBzxKolJ2Jpg3vfUjxl+s99c8pTHNgNQPJeQDtF+81CsZB+8TbNzWgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4375.namprd12.prod.outlook.com (2603:10b6:208:24f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Tue, 25 Feb
 2025 19:44:48 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:44:48 +0000
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
Subject: [PATCH v3 18/23] iommu/amd: Use roundup_pow_two() instead of get_order()
Date: Tue, 25 Feb 2025 15:39:35 -0400
Message-ID: <18-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: e34d7e66-1876-425b-dfa5-08dd55d4dcc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YZf62sEQNEkmUcVMMSNE9lDQCudQKMJcGTaLyX3BFIT1g2LK5jD5gj0KNJKP?=
 =?us-ascii?Q?BycOCjk0uekclwp627UhoX32GCdfS/piV6bYC+A5lQvwFXFG/+0so/zBHojO?=
 =?us-ascii?Q?RSoLSKEWgZ+cWCDs/AMkqdnkbjq0BVs10FZay4cj0zTwJ3NIVAAdv+sP99EI?=
 =?us-ascii?Q?DtgsVWAK/OZT+P/ztd15/sdD/Teds0dChhXKdbYv+eBhY7XWqQxhQQYJmJ+P?=
 =?us-ascii?Q?rtgdSYx4C0LGLf9Di4W5RJ2RKp/xvGLVuczOMl30Q2yYVqpJ0jwim1sjHBbj?=
 =?us-ascii?Q?MzHDiDU0tVSjsy7f/B70GKDJ3Ivh3Ly3liM27bFxImKyYStiq8cEwkq5ese0?=
 =?us-ascii?Q?ff7iMzfbpKjMkO87yr8z3qMtRdaS1LGd1tGo6lzZ5H+Jg8KWPgIuN+b0yL9W?=
 =?us-ascii?Q?e7RoDUk8GUPMkSmjRHuc1aMFh1aRb3Z9P205Kz4HeYZ9WgIMqLaIdFu2cMvl?=
 =?us-ascii?Q?nxgmGdRbVrnLFyi70nBQWLKezIrp+MbP0Zq5jgHPxNpB0YE1CtrMuzqddZJQ?=
 =?us-ascii?Q?2Nb3vtwqFcSbBX7iXgpdxx0wwXNzEBw2DszDMctGt4A1zUsNhDcED5Ue7rek?=
 =?us-ascii?Q?sVtLuY0Zlbx7MkZwWdE0My4nP00Ifo6GJZV6HMdEjc7ebOD8tndbQ0f4Zo6F?=
 =?us-ascii?Q?bQwwithSoQfIUZQ3SxLh9EyTDYKr3Rqvs7Ts6rW5jUI1ZZ9roJLsZpOiy8q5?=
 =?us-ascii?Q?kvf67WX95pAg7MzNztlaFFX65A5oK55aG8IFYiow8jof/obGoH0n0XviZlk1?=
 =?us-ascii?Q?cBVDr6xI2Y7VvIbsl8x+Pf3iFb4ON52/zpCtl5kapoEIORApbpD6kr/tbWSG?=
 =?us-ascii?Q?O5f9XUnafmaiEbGdHEUHzyC42T5pf+XqupcXNYm428J9Q4GrssqdJWx1e4tw?=
 =?us-ascii?Q?Nz+2OQVvQnLAktKm3xFDxxbdoyg9/InXZP4o7gUdymeZRmMyOgvfGvu/SEH3?=
 =?us-ascii?Q?QLpMStKXevclsWPc4Cois7owMmyRhGRXmlQMXWAn4Ks/tIuQAzTXMro8GCjS?=
 =?us-ascii?Q?cxkXzTKxP1I+uWwi6tuCcZ/X3n0nISRUAeLccklf6iOUwgKmjNdtFxwaQm2o?=
 =?us-ascii?Q?iHKe61Nf3wJlcmamFLt4fThwvs6YaFtll4nd0DsKZ11UCDmIdcO1dLkVDffJ?=
 =?us-ascii?Q?eIqtX/Uab7ZkkIt6A+gWPZukZq61voZXOsaEWF8XNQCCFX8FSPmdgkBalA76?=
 =?us-ascii?Q?EdcAh7nvOWH4mcoWmIH16fZ4w7SdzzvUPMrSkZiLqoKQgBST+Ncdrd+yc8Hh?=
 =?us-ascii?Q?ZMMRb6iQvqbAb83GLXksvNOU4kBTnEeT5DEeLdIC5XXd5mxdA617IIO0LA1J?=
 =?us-ascii?Q?JEJZVBU6V5tHyJongt6SdYYmxy4xRe3ofkB2jtURo7mT3QiHxuvzDOLxeRpc?=
 =?us-ascii?Q?xR1tir1pWuFl/WgdJhNxXel9YjnlafUOtVZ6fT0HMR/AvBP/fSnwYqaXu79E?=
 =?us-ascii?Q?asJv/0Tnbys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T1qsBMhDjyTRJhGwUblUfsmLF/OuxGvr1Rp7xp3RGtZX6xTWi0YTIHGtT2cD?=
 =?us-ascii?Q?it4yQROLPdL3Fw2HCk/hbfujwb8iAp7KU1SSjuoL9pPXkBOtn6VEcMnjiMP+?=
 =?us-ascii?Q?mui7hOyk8PGP+VgwBFTdsCrehRo3uH/anp6L0O9+umgUMzrcAv83yM7liy2c?=
 =?us-ascii?Q?pTXSHFV1SueaDTiy0zpCKh5n3muMPx1s/P39V4xAUd8U5tFAxfHoYvZdMzbC?=
 =?us-ascii?Q?qaDIRaLsFc3cWofOs8gObx/ITSpYW8Ur6S97s2O3aclrKGDXN6NOWV8vMS/y?=
 =?us-ascii?Q?4ix7fGDHi0NwU90JDbAKILb3Zut+upfCb5JfLOWXlZeN1/FGIztRj9EKb15Y?=
 =?us-ascii?Q?cQH/jlGwXoTKJzZS7DUPRWt4DhY+FQtLWC6w3cANDqn2LBQqDHuF4XVvytiV?=
 =?us-ascii?Q?Onb8rzWH2yBMKVteJgM9iP2hrUTCzKWHZ+nWFCl9aAed/Slv0lJYZaX9JY74?=
 =?us-ascii?Q?vbl9b83PmUNk1HQQD1LiuLIDE1aRstvQGGNlpSwdrKJkMMM8miDUP5zjuk8A?=
 =?us-ascii?Q?PoLFhgvsuyqM8UcVcEiVwu+YaNrfg54KD31e1ttksx89Zxoh1+HMuHWLQ/UW?=
 =?us-ascii?Q?FfnGpKdXAVcmCPtneaq4YOGwIJOauKBvmIEfj1wygEnHE8An2+8qkZ70eDHq?=
 =?us-ascii?Q?a5x/cBEvZCq8o3VdmAQHImTHZug6Yn6AdJl72votRAhyInAAzcx8TJM1gEVm?=
 =?us-ascii?Q?mPSGGYKdbukHXDyAFi0Nl/c6sNGi9XcTnfZzHCDw/cfZNPsN3XQe7eiWBvl1?=
 =?us-ascii?Q?OB3+SBVJMGiI1MVVUxvZ4h3UDAvf8SZieiXHHYNb1/QWPzJbbXVuWQ1R23+j?=
 =?us-ascii?Q?G9CTJUxEE+XT8F7b1HJFYpTm5QcePN0F1rLo3mhnX4U1dIzcb80SOuyqFJVt?=
 =?us-ascii?Q?/YNjG+Kit0EW5iVwld70i92IQ8Q6yBZnNiXgTvg65KBA+Oqxt2UGLilnU45O?=
 =?us-ascii?Q?feAAyfzUKC95haeLIIM/3kPvxXD2H8WndLuHKYjonXsq2vQjMD3hVLlPsP4H?=
 =?us-ascii?Q?xZbq6OfzspWlyWPxAIDjpz3sKAAUt0iU6L+yGep63X0rR6wteaQ/S4fKzhW5?=
 =?us-ascii?Q?iLXjxGpzF2de289Bkq/Lho1KDX6w8oJyLifDl7fqxnpYAvMP7Rtp0OO3xfrJ?=
 =?us-ascii?Q?QrRGjwSyEbdVQCYoJaLjRQSrw4QZK9TrxTaqFRyCiUrjSfKlkAMo3S96taBn?=
 =?us-ascii?Q?5VHItmKE34dLkFfujTGdv1JGNxynpOe1gvxuB6x5VUsXchzk7FRTWhulM33h?=
 =?us-ascii?Q?KF51P9MnXZs2q35MQgnGJvt7/ZRKr9nCdz6DHoZUId6ZjCFm4FDLppTE+hc1?=
 =?us-ascii?Q?orSmi+i1TtJBl6WqBrPuQ7ji0Lr0aef+jIekEuJqaTDFCWk8GjR45RkqfsnN?=
 =?us-ascii?Q?J6eTiOzlUuT+LUxvGjDgaSng3NjkcTRnVoMchQ/AP/2l4GQSbZ+NOKjB2jzz?=
 =?us-ascii?Q?6VOJKYE4mmJdy8e9ZuHy6KIGdKi9ofdeXS/ooki8ZJZ/BuKn2VXnPRIfTy6w?=
 =?us-ascii?Q?EaJHQkrjHsBwtgkFk5dwBqzza/SkxQRsmbgASwGezYvZdyF3kfIfDqM62aPb?=
 =?us-ascii?Q?ydkMpOTM7G983f9ba0ieKW8fD2wrmwTeICpf/i0O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34d7e66-1876-425b-dfa5-08dd55d4dcc6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:44:48.4119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBgEKCDYaxcqGbCMqJUt7ou6AEwhAVmmY0znVZmnOkJxJo3tAkaN/3CTuITOBE6C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4375

If x >= PAGE_SIZE then:

  1 << (get_order(x) + PAGE_SHIFT) == roundup_pow_two()

Inline this into the only caller, compute the size of the HW device table
in terms of 4K pages which matches the HW definition.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index fb3c3d17efc167..e3f4283ebbc201 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -245,14 +245,6 @@ static void init_translation_status(struct amd_iommu *iommu)
 		iommu->flags |= AMD_IOMMU_FLAG_TRANS_PRE_ENABLED;
 }
 
-static inline unsigned long tbl_size(int entry_size, int last_bdf)
-{
-	unsigned shift = PAGE_SHIFT +
-			 get_order((last_bdf + 1) * entry_size);
-
-	return 1UL << shift;
-}
-
 int amd_iommu_get_num_iommus(void)
 {
 	return amd_iommus_present;
@@ -1603,7 +1595,9 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
-	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
+	pci_seg->dev_table_size =
+		max(roundup_pow_of_two((last_bdf + 1) * DEV_TABLE_ENTRY_SIZE),
+		    SZ_4K);
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);
-- 
2.43.0

