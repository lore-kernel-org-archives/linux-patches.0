Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E694237160;
	Tue,  8 Apr 2025 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131263; cv=fail; b=dZyUGbF1iMcT8dsM4VGd0G3BN3ThcaKfi3RJYpywIFfY62ejgx/+OBQREPsIajrhsq0fkkpnXOj6OohGZdrBsXgVZSEbPsOAzMN9CP9+lXstF/THCx3CGkXw4Yq94VAnBfO3k6+q8IhnByhuHb1BexirdLh9gOkJFnU6G/1pisM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131263; c=relaxed/simple;
	bh=Uk/6Ciq54cbUF75u9+f144pb/13FDwBOG4xUZDgDNio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pDWtLZaG+AIv9jqu92LE4PbZdvzyeM+c0+Ay5nKBLAJEYFdh+dRf5fJCe84ZaiF91IKOan194lC/nwX4SUe/ap2u3ODkFc3ugewFHKet5Fm+h1v6aErbnz2fuUBNlnJeIzkPlA883r1ryT58lM+uGt791844fe2P0J3gByo+p4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eCA7slN/; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eCA7slN/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=smFeq8sM+Vi6+VXw0Nl2PbScXhoGUt+lfu5dGFo9SSjcq3bW4z8E/zKYVhsEkBm7lOm9kNw4g+0rcMsWswTofwLfdOSS8icYI+YPlhAIlxFJuYjiKIN7OR39a1I19Spg1n/q8kUpFfT4rcVVMH2PNxgGjg6EXT0WgG9XdkAREyMlTOhNIGNmr/ASJmNLi1WRce9nTlpD9/K+G/fQgUwIElSvUdGm9qxJVh1tRaPUO/WEEO2A8sNbO/PxJJKNbvKB5RwepRYc+qTcknT8aB3zeBBA2eH9i5q/8cFe8xSZpUUv3N/ut5c2vghRLWi+lK6CHsk75ZKLYwZomWakW8E8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+akwFg18r3NdimMyy2y7q62VGXPwuDsWVi+yie6UZWg=;
 b=tkfz1fUOekvkZEIM+8fTMUd/b6ZvFx2MMnWCtAgM/y81cB+HgulgTBeczwqbXrOqk2nvdHUNBNgkAf+HeMYJLmcmTWSAX8S4oX6nIpzuieuMN0ZH3W8Ypm3XRO+iXmFts16nrVv1ZGjG0cFngFNAxrz+y5RTNXuyZ9lZX5D1s520UtDYroNmsqCMJktTLvYrBfNinWe2wJsr5pkZ99Vh0cDbNT5+bKqczqLtyrTdxihvn9YQj/Nt1DjUUzAwlYeQD/kxuiwWV98A231R9XKGIdfr7Wrkw/Xh5I/xDHzn3wKM9+X7M+/lPATKuO9FZpuMT9n5jrRcpBGl9/r5a7wNbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+akwFg18r3NdimMyy2y7q62VGXPwuDsWVi+yie6UZWg=;
 b=eCA7slN/vPd8XI46j5nTLF74n58tGE1/FAhFoyuiN7x9Ra7wKsKfNB6xzV6uM/2SpP2IrWDo8Y6brMy6tw8qKVLasMkuxZmSsbyAljdQTiGbqsoDEuySsvjo/AlxgCKLYaxLBpCJD1M7vIX9OIu3QJUrIoljDk48NDkYjji002lVuCab0MeeU2xrXqzXiquOY9qcQOQYMNygcnDfFfI7HLUBSO84tipPjYsU8/R83loVzQrli5Bl8uqeo7NUMffmE7j7CH/ioEFHIvwN5ABPm0m0rUpy33JW3gRAhwMuwYMBe3s9hKhZNhQAZUGJ3vZNUMVFmUTWa0E1JTYj7UoFuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:15 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:15 +0000
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
Subject: [PATCH v4 09/23] iommu/riscv: Convert to use struct iommu_pages_list
Date: Tue,  8 Apr 2025 13:53:57 -0300
Message-ID: <9-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:208:32d::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9f5c7c-64e7-49b7-34db-08dd76bdfde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MeOVKs2Wq31jKaK0JIrZEkbz8jLcRE+YjISlxVxSUv05NSD8c9VOpC6r1mdA?=
 =?us-ascii?Q?eAJVDw42RGxzFwESmKD8UH5AILAuyoYwejSZB2H3MpRcw9nOdPDMHALb3t55?=
 =?us-ascii?Q?BYCXFoEkuzCbGy3JN6JLv5flBwv9i4z2SLRgfdSCYg6cG0duEtFK6V0iNuGg?=
 =?us-ascii?Q?qoHbmY4n1wKh7SNOQkk46MfSWGLffl/BsGUKVSxjhtvO497gVS/tGfo3dfnE?=
 =?us-ascii?Q?D4Q8SiwGjNbrwXmATRXLsXOFCRE/8tpvHBHzI8HZf/E4JKFbvrh66LbQ4G9o?=
 =?us-ascii?Q?dCBAG4UHkNyuB8tRSvPMS3aiXfYhayJ7M68NiGL6bxxWF5jnKoc/VS8A83MF?=
 =?us-ascii?Q?tOztIp+Fjqy8dJaJykTY/USPgrYEyxEQ34xdhvPJ6ORGC99GJq1lLYnxhSPJ?=
 =?us-ascii?Q?h5A7egUu09FStl9P66z7HXbMht5Fdia5lYxyNYg4BSzaP27bMpPwCYbRNhyn?=
 =?us-ascii?Q?5L/7wHmqMd4qL7Zd8+JS6mCAql5hzbxkq/gB+4z7TamDcx1UAI29/Yn5CNmW?=
 =?us-ascii?Q?9vK2gZArlF7mbNamoTZPYwoVdwCPU1Ow637s8S1y7EOKeko1IwSvV6Lr81Xb?=
 =?us-ascii?Q?G9D4vfuIOHcPzh2C3wbU71SpdcCwMPjNOkIHEJK8M8iO8XoKjT2CKulbr7qN?=
 =?us-ascii?Q?XklclYZOflRHwOMWyiDm3hgE7jdBb8mNkLdrT8e670yiQHX1Q6EVDfhHpYxB?=
 =?us-ascii?Q?5MJg8l2TZ0bm3niWOqXG3FUXMLLi4vBueXT7Nad6VMa+5M2Q6rD1SJIddwE+?=
 =?us-ascii?Q?bnkJX3CjhW5Qaty37WQbGkKBit/bYfeTazv2eHx1y63/ZYHI3ZGvxKfk1CVG?=
 =?us-ascii?Q?LfE9+qqEONdCt+ixK6Jn5a44RFp3U4amGbmTxU45VzVcQdT4bVKj8Tq/fG0c?=
 =?us-ascii?Q?LGFtzJzKdBi/C3L5pnoySL3MuaLwxqmpb7WPcCEb8I/q8um8RfgCb19dJa88?=
 =?us-ascii?Q?WAnLHwsWSPkvIz4V2N0s1eQIS+4oXkv5nYutEMjbFO4xzXp/KePuIte15jsw?=
 =?us-ascii?Q?Jyk6ol8WMFQ0AV8GuZf4bwGM35BzYOasFk49IVBiiCT8IIS/CbjmwrPJ02kb?=
 =?us-ascii?Q?je3J37IcpfYBkb3pQs0X2dys4sK1XcdGOKbf0nJB9Jf0G9VrKRD9VMmq7Srz?=
 =?us-ascii?Q?vXd3JJnfBus9AGnN8HfEvJLIPlZBskRtNSMvPKfq69I7J7gw9MVyArmBH1PD?=
 =?us-ascii?Q?klOb4CES3g8ZA1uNWIZtxtxO8w4FYrL40J3BQ3BBhE3WMTyYWJCslXJ92Xc1?=
 =?us-ascii?Q?AYRCD5kyDtmJ/jHvBvszExCRWms2yLyzzvKgJWT0OQbcmPdmD9uPSevnwDJj?=
 =?us-ascii?Q?Yi1v89OYHW8h23qiM/YK81njjTzrQgrpptmNpruZBhq2N48smThTSCZNrtZr?=
 =?us-ascii?Q?I6Qb7vVeerLJ+bd23mPEOmqorvzA+IsVnSiEl+MtNEBAXwOF76NM4701GuUx?=
 =?us-ascii?Q?oy/amPbPTzhoUHED0e7kBU/skbXCtvnj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wmV4QmVu/mtabnw3xgoyRhkOclEp27jWJMIVX+e36yRrrSXfOG8AKoam50Bo?=
 =?us-ascii?Q?+72vQThN4BOIkzW1Ke1D0kGpM77IzTOjvczl/fNdIYBQ3DEbDi5M+rTPst/0?=
 =?us-ascii?Q?Go7Xf07bzneAU5DQJehbcDMUcZjYu8ZhorDEt8KGnmzIJu211n+dP/eGhNs6?=
 =?us-ascii?Q?v1DuU5qCLUZLBiX0ywQuFvxsZCBh18DsJ7HOvwoY/KIeZXNZIrvV5bE10pSb?=
 =?us-ascii?Q?HlJ4bQBA4VubaMcOiyYZAjSYFM5ZIAKr9xJpH9EsJoCuOvJ2eskao25hQI9E?=
 =?us-ascii?Q?RX6o496UHeuSovD/Vangc4yFFXyaAnkI8ee0by7yCgxFgoaqS8vRVqq/i6Je?=
 =?us-ascii?Q?1OmQatsJRbYZ+MfdMFRhyOa/bsLs5bMnzVxFtxIgA4SAC5ZnwSVbTGoah+Ad?=
 =?us-ascii?Q?X1xvSbGwR0569L6BfzPIN9VkcSO+1CkBc4VbENutAGlWjTfBHT85XG9+FgP4?=
 =?us-ascii?Q?Se02XkiWKkb7MTu70CKP0BMHYkxLs8kIU2+oWsXyWZr+ppC2XSFZaseNwlcg?=
 =?us-ascii?Q?KMfuMlVa3hqzwUGM8Xbc9KWSv3d0D/9U1YmvcBEaZA/wDn1d8nPghTtMv9kj?=
 =?us-ascii?Q?YW8ksB0KvaXgCFRwPqCD2cFfRNvuHa+yGgipyx3+UsHG1nn+BeZYzPVRPyfg?=
 =?us-ascii?Q?AEZu1GPNAyhigV2KWQulxprsT3y1gZdreikR6MYJpRYjmKJBF7CLZwAQKA//?=
 =?us-ascii?Q?OLATQRbPyvEq88lZ2WLejUWgcOAmvnwxpOfpAniaKBPX4Cpa3mTXQICqbG4K?=
 =?us-ascii?Q?lEpgcSfdQ2eTGubk+0yymfFfYdA6OYhm0zjfZJCs4qBHwQ4sWod2ptGdDqDg?=
 =?us-ascii?Q?wDcvSqSjDHS8rlr8ROK4KTISDdw0B8EcwSKqdg+9WVuS40vQpdjcpqNUDvFz?=
 =?us-ascii?Q?9b4YE/kbIQKOKSNZh1qkF76DIbsIFVRGH/CKY0sD+NKDx+M29PAeDBYM53IC?=
 =?us-ascii?Q?EcdCCwVUlm8cl9BsJrvgfdi0/RSZmAPP41Fl1LudlaBouyAv2KXAvtZVnjBa?=
 =?us-ascii?Q?T2z67TIRwJ7yhdctFfttm+JPGLTfEQQwijsThf0uhY1jDv+KOYc/qVI/yH66?=
 =?us-ascii?Q?L1Wgom6gtT8pjjo34nDusffURGDsAvklI9TZFO37wnGv9RpZgJ+H2kx4uszJ?=
 =?us-ascii?Q?cTCIxOglgCuuHlM0DNHBMnhabZp3L+MqSlrgO3f5Cqzslz2M801Pap34gh+1?=
 =?us-ascii?Q?d7VWTiuwEYc+uu3SWpYa8IBHEy+VkyHshOeJeipegY5DHthn7+2hyOPRXsnJ?=
 =?us-ascii?Q?C5oUgyF9ssTajyxAT63Fn51v8ndtUoeKbuFUCohVm/uWvRDd3bMHgSA6fZSa?=
 =?us-ascii?Q?NxNt7QYkkBgWRrD+upKgJGders14MOj9qGyGtn5IKOMA3/d2SVz5QmldImgu?=
 =?us-ascii?Q?SIi3UGvwG79bMvfHiBamtLjfWl7U2WQpHrdrc9RQzmMjXfdMbWuckRRiKcJ+?=
 =?us-ascii?Q?wVqYYEVegj1nxgcZfiS3IVVb0gteUN1NqkEzcYijqhPcWb0HGZ9Uxa10a51J?=
 =?us-ascii?Q?SBjseoxjIWokwFL4DUo/ZtGtoWd53K2gNpS0HbZSRu7X8FXMcAHZ8C1iQJdw?=
 =?us-ascii?Q?+xN6cEUK7iV0MtauSMivPsEjwupDdtpE4oiOCQuO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9f5c7c-64e7-49b7-34db-08dd76bdfde2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:13.9373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHsJyvdzt7LGcrwh3QKDTJaINZAF0tmBN9k1GUuEfkjIb32zJ/EeHJD5WIvs5jkK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Change the internal freelist to use struct iommu_pages_list.

riscv uses this page list to free page table levels that are replaced
with leaf ptes.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 4fe07343d84e61..2750f2e6e01a2b 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1085,7 +1085,8 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 #define _io_pte_entry(pn, prot)	((_PAGE_PFN_MASK & ((pn) << _PAGE_PFN_SHIFT)) | (prot))
 
 static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
-				 unsigned long pte, struct list_head *freelist)
+				 unsigned long pte,
+				 struct iommu_pages_list *freelist)
 {
 	unsigned long *ptr;
 	int i;
@@ -1103,7 +1104,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	}
 
 	if (freelist)
-		list_add_tail(&virt_to_page(ptr)->lru, freelist);
+		iommu_pages_list_add(freelist, ptr);
 	else
 		iommu_free_pages(ptr);
 }
@@ -1192,7 +1193,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 	unsigned long *ptr;
 	unsigned long pte, old, pte_prot;
 	int rc = 0;
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
@@ -1223,7 +1224,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	*mapped = size;
 
-	if (!list_empty(&freelist)) {
+	if (!iommu_pages_list_empty(&freelist)) {
 		/*
 		 * In 1.0 spec version, the smallest scope we can use to
 		 * invalidate all levels of page table (i.e. leaf and non-leaf)
-- 
2.43.0

