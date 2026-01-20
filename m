Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D4C8EB;
	Tue, 20 Jan 2026 00:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768868003; cv=fail; b=FZTkSDfSn5Pbo7mWTdV3I1y65WrNnjgGtLG2L7BuHBnGMQNqsax4pbG1hak9JkJMIvBKDEXzpnP02mFqe+ZYOVB6r6Zr4T4HiMazPib8bSwO+QTfw/B7Jp2CkD4ouHWnJ2G2nv/+qdhbn9Axq8sHJNtoA1RRv5vId8QGmETN/O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768868003; c=relaxed/simple;
	bh=Nk8aE5pjdTalAqF5S5+vYj4Uj1A2+tzMb2spu6iRy7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cm7eOq0AUoSV3HZ8KQ8+eVhMXbBIrzxPk51ONyeSR3VKB0Puj8myJSmYIV+MhXSQ3hTfgDBPEibOiiugCxl+MOwTzP2s0bNQip2bdyPM++eTGEOl+jZQ5eW51G76MH4I78Hl3sCZ1udvoTdW7TgLBJVHeicmlw/VPN/q7wU8FTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ntle6UJw; arc=fail smtp.client-ip=40.107.208.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ntle6UJw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NW7VIKTgW5F2cCy3QLlWZUZZbO586TaF1osj6KwWw/5pnIcfz0Eyug45y80NIFDK142aKokg2v7LhPbB+uil/eJPsmm0eeDxQ7wwnQZyevRRgNhe2WbdBfmYHPzf0/jCGM4Z2coia6n1DCvD1OPv2StwiBrcDuDyfVNQw7UtsJrErsdghDz6QSC0IsqkXCVgFT360tgQNpEbzkCU1/QoADAkYJa5pCgmAhiX/8wlwWAThAf7EkY8W+S4dKbzzi/DBkOc1UnC/p+zWBQILJL4w4h+pEbYDC0H/WV+Ov4EG+VZ/nl6sK+88ONiLQ4LMktBaw3aiZXdHldEQfGSyb1cAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpFSNAbTCUYPGe22WpTKp+JIN7u8FqWofyrNM9p4lhY=;
 b=WEZ9S0oJbbc4+rB3guXIJgwVa1oO6g3tAjhNGCiNT6p8h+2Xjh1KXjVuX2qMsk0u61C45aSs+qhnpk+vPfSoY+OoUgoKyXV4+UUf71ak9rX7lqZzhLpsu4aWQQCb9ug/HY6eW5GPpEXSni3HaJiwfTaZNgbs0XuGgg2LomyEvsUiBDVySAyIxUBiiyHDogbluq7LXwwNJMS/L3fabuYeR2ssPwrWY8KfZ0eB99jPJnNsUi9J2t2VsPGJbF/p/u6AvVb7joFbwRL4Yk5/FMwpfu6DMsHQFaKtJwaCXqpQX0YTs9MZdUX1zHWOPU+skEPYcWkcX9xi2ryjKy+ltwgYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpFSNAbTCUYPGe22WpTKp+JIN7u8FqWofyrNM9p4lhY=;
 b=Ntle6UJwMCff2eiDnzQ1rVF0lDNDJ1uioQ7wu3Uum4Dh+5Q2cUvs5E9SzDziKEDtEoudELV7EfVh5eHaFbJujNFlfsHplgIu8J/azVMDoHJ2E1Mx6CCIGLxmvconCO73jd4k1HU4zl7EHfzI+efht2LuOsysrT0r7GI5fIfVHKYjnDOaG0DuNTEgTlc+omSTXB5+FRfBWP2QfRiMaI4lAvJCsxOrZOLS1iWAtizMd7UoGToeWx6kSs/QsqFq++G/o6IB+EX+YhlHYGzv3VnJqDpLpoRGMELzg5GxutVAsJJXa6FeIXLsInjgJEpEmbqngkFRGdAaT1kV+Wr0HxXRFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN2PR12MB4142.namprd12.prod.outlook.com (2603:10b6:208:1dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 00:13:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 00:13:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH v2 1/2] iommupt: Directly call iommupt's unmap_range()
Date: Mon, 19 Jan 2026 20:13:14 -0400
Message-ID: <1-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN2PR12MB4142:EE_
X-MS-Office365-Filtering-Correlation-Id: efb647f0-78ae-4c8c-7589-08de57b8b5ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W8mB6EQF1tZalG+Hg999mEVhjHDrhpkR7+HaqNMAqwgQnKgk9h1fAPiHEI3j?=
 =?us-ascii?Q?QpB2mqjy/gxN3v/2Q1+BHU9srdaL3+1JBlcJltM7eR9f5juUl2JuxPa4Wbye?=
 =?us-ascii?Q?Tl2C5z5oCx+ocgVFFLiXyZZpi0x0SZCe7QEfj44HYC2tGtCZEkXQG4SKFian?=
 =?us-ascii?Q?JU7EWb/e2m3roqWmAijaXOli+R+HoQgaaFtwNrtkghA8PV8H7tl4xOeobKaw?=
 =?us-ascii?Q?kQR7StZpkx0718ldjDkczgUYCxApmqb1YFXtxU5YA67mgfwxwi/rxFnb4zKi?=
 =?us-ascii?Q?zQvqiH5Am1WPCt+1QaprqAZE4iFZuNRMzr8oYwywOc4ZU8znRJrYnZS4O2rm?=
 =?us-ascii?Q?s6JIxctDNYS+ZA3cts5L1OGXO5cj3rwa4e0wvNRTnGxkTtXMGl7bvWlTY1mW?=
 =?us-ascii?Q?3qeTdNGg84Xx9gcLAIcoIUCiLKYV08vDJ5T/G8UEjPii+KZr8+JBWUmfJ/1k?=
 =?us-ascii?Q?juhE5CGcStC56tMyB1q1vp0P1elv0JFRkXSgXld2ppZ81+sgn+mj5poq09fZ?=
 =?us-ascii?Q?/egj7/T61VK4lsK/ZPz4wr5lIn3uNtae9JufoSwWrmD5ENxVuxI+GHbujTJU?=
 =?us-ascii?Q?YAkZB/nJi9PEL8wV77H7T9gGF2qx5m5ziU+V8wEl5YfbdU6POInCO1tGr1sA?=
 =?us-ascii?Q?ZElcziVS3TMm3vnEhJG/2vRQNNeeosGtifE3fz/A5C7fqWkQQvI9CEZAWqcS?=
 =?us-ascii?Q?X0cWDccorSk8OEV+j+AG2dRi/dtz8MGnBnovEhpkPQhhkdJ0TzC7e5MMdtLG?=
 =?us-ascii?Q?B3Tikh5jsgyxrIrPZKQt5U2bE/G2M7LMmWpgrv7N4nCWYHMRLwoLiucMobMo?=
 =?us-ascii?Q?DKNf45Eg1UfWejFgVGtO5YYkL1XnulBXoWzhQ/bpcSOvtIEqwScdz4J+TtTK?=
 =?us-ascii?Q?sEKYPxD5NbvaZHYG1/2d6PEnNEOYdInP+T/ystTMIQIHtuoFg810Fim63tIg?=
 =?us-ascii?Q?NVbdLTj/12aocXFfoVDwhdtk7aN9/7/jGdwchMRlOPtYrQURCWm9EQPSVRlC?=
 =?us-ascii?Q?aKUZHHw7JJnx3QsSQSz5PF9pmnKg83i4HvSJ/abFlpRvcnvRQl8f0BNv+mVo?=
 =?us-ascii?Q?3IoE3BNe3UnGAvaP/9KuMw3mPcckNHYxEHSHiHJ7Dyr9T++JJ0V1PgeJMcG6?=
 =?us-ascii?Q?DEgw3B1RSH3ptGKvWqIdDGxpayJdCdqYAsPzoPvu4mniiNFmnko8Ik7Znctf?=
 =?us-ascii?Q?yAIYXAflCdDWG6x1i3vrRX6DYk82eXWOwfGrcZgwwycex54DruZzmhTlOKNa?=
 =?us-ascii?Q?r2EiQkCR8mMdBHPzuOnzkNjHZ4EVW2OV+uTl4SYOtZPh0VkgC5usbpNj2b60?=
 =?us-ascii?Q?U+yyPvlXjfEQ0aW6yntROmstpjp6AzP2TaVf2Jm1NQBieaBUW0mvsVuS/Sqc?=
 =?us-ascii?Q?TUoKwbA2ZmWn9JMpPdqxtNs2SfdAoeFGiR3QXbD9BtdoDb/zMZn7R8+CiEtX?=
 =?us-ascii?Q?YYE1+QbYhGfwjxQvS9ASmNcpDlYjH3svmoiPLrv7WfXnt2AmIgRXrCr49OUZ?=
 =?us-ascii?Q?kM2vQ0yNJAPtzUGstDCygkR3AI0qjjxpUDpKniuEb6/Op3Hke1Pt/muJHFdS?=
 =?us-ascii?Q?/xG6BjN9Be+z38jpFLM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hzme6pZS9zoF/4hpP76QDtK8Uj9AojrNXcFeIruQt5pZufDu3N8os3GVTRw+?=
 =?us-ascii?Q?aGDXiShqpk185R11csWvLTGj7Za5CyUCBSsXFITVd+QW+wjHXFqg4Yi5xnZv?=
 =?us-ascii?Q?enQ7rpni9cy2kDJV4p5uFEOKiSvuHvqUoioUnGlA0uqwhGulobs1iXVj82Uz?=
 =?us-ascii?Q?dCGv4BpRyifbRq1NLspdKR7tQxWN+d7UzY/nPBeHhPfJLN9JGXymLGhuPgwC?=
 =?us-ascii?Q?bW0u6yHf5nWw9nGv6B5ttqlgGMqeJVRoa6clyDPs8t4jM1jOTTXaVFGWSBgt?=
 =?us-ascii?Q?ebbmOKUkL0flD6nNqCE2KzdAy0glkjQIUbOMeQ5f98IISIzP6iH+rSvrl10M?=
 =?us-ascii?Q?wVaF7ZAKNK9p1fcKyrwI72s4Mu4du21nmoqSCWKwFkMG8Hl4c86OPfA3Y3wT?=
 =?us-ascii?Q?kBd3jVt/+mAbXWaGTC49yMWDRLKrfVtRgIx01XmcCB6eUpJ/hjVYaMXUIgW3?=
 =?us-ascii?Q?4Qvdfd7I8TwljxTMLIrhoPmoAX0cgwS/KbHXD+bVDuxbYPvz/31GXFpH2DQJ?=
 =?us-ascii?Q?+HFQZZa57384dS65ms+NywnLD+ETi2QnfodrZ2aTToJyFeF/mu2um3zXrXWM?=
 =?us-ascii?Q?zAes0y1GrpwSGqrquQdDGKAZuVUV6X5uVfFaTZh1o9EqiWVqTDwm+NSB9jMq?=
 =?us-ascii?Q?sC+HSidiary30m95k91vrLlHMFUpXvFEnZYy+BdB329DY28FYTlS1Gioeyva?=
 =?us-ascii?Q?+rnEpjhVWW+1wyRqXRQIRtkQJ6AlUTovtRri6fo90noqh5se00OqcxoWXMfC?=
 =?us-ascii?Q?PSC9qNW1sI/nK69dnrvHvNZm01Cw4GYj+nmFM8RLo10oLRkbqUss24caIE2Q?=
 =?us-ascii?Q?jLoH/oZC5h9AfnEwVStd1NrwDM4PtSTQMrpoXDm65mIX6r7U/doqHPba4VCW?=
 =?us-ascii?Q?W2E0Q4DsrR5+/w74hcXFTemMlCIN2lU7UrQGjM9XcWLAkblWpmegYQLdKdsG?=
 =?us-ascii?Q?5U8VMezGZFTD1IlrPN1ugTEwcqKJRjXdInwlgnM4QUsRM6toxSilSCoqfzQG?=
 =?us-ascii?Q?k4skLMDrxLygwaOGLQo1fC7rOI5yzVmF4x6XSZ3a5QmhM5ii8POmAy9I5fom?=
 =?us-ascii?Q?GMfjB7A6cZt9+121koTWuevLRX8RJhaL8nk0bJfStJNDtLJkf13QhvWxOtps?=
 =?us-ascii?Q?xq2DXQO/+2JNoA3nwPEkziv7HuSPyWXUDuZ6m40a1wSz6L8QEodtik7boVQR?=
 =?us-ascii?Q?WkUONhKluJRSjuj3drTwOyk+Th01iKElgoq+12v1WcifUxMtM7cCjhzCG7/5?=
 =?us-ascii?Q?oQ0kx0qzEViHcA+LmAPWKZtYDG70ns3WGceoxRFFBod7ZEC3JU24kHEQfu1D?=
 =?us-ascii?Q?x4fDypKWI2+tD8t1+ViH6L77f1onniXG7VbLqF+GSxCzMCAoec2yyyWLrsmo?=
 =?us-ascii?Q?XfHAIY7djbQfv5AdsrQ0Y4C/kPIhPjWZQ0hBSD8JSHETWUEMjgMeH548FBBA?=
 =?us-ascii?Q?O4pCgjZ+4aN/nnmoXCrowVMjlrsA6o5Q3e1sRLOmm1RcvroCh/+TGk+DbSu0?=
 =?us-ascii?Q?5a9+JeNE0uOpTGEfx44q8zs0ESX4Uuw1VBzMb3Isn1hHJzAVslgVulADiPpg?=
 =?us-ascii?Q?QKn6YJ5N6HCkCpLpP814oVU9Wtke3IuXYK/El0yEcUkroqOaSQ0sEfJZlZtq?=
 =?us-ascii?Q?al+6waTBGv6qosMspGEZdC1b3tndHfBy1908aldHiU1PE/Ca0AQViOyj4ZmL?=
 =?us-ascii?Q?lppvUrfWU7a98mD6v/DgfH7+VDpv4eeyr39R2ZvG7zbh0fsjpS2VA4bXm+6a?=
 =?us-ascii?Q?c3Efvm1fOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb647f0-78ae-4c8c-7589-08de57b8b5ab
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 00:13:17.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XO+dlF+5o9zQFLKGGxpfue1tDaiPsCnEfcRRbc3aCAES6c5KhCRMlmLTOZZGNgW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4142

The common algorithm in iommupt does not require the iommu_pgsize()
calculations, it can directly unmap any arbitrary range. Add a new function
pointer to directly call an iommupt unmap_range op and make
__iommu_unmap() call it directly.

Gives about a 5% gain on single page unmappings.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified
map/unmap_pages() style interfaces.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 29 ++++------------------
 drivers/iommu/iommu.c               | 27 ++++++++++++++++-----
 include/linux/generic_pt/iommu.h    | 37 ++++++++++++++++++++++++-----
 include/linux/iommu.h               |  1 +
 4 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3327116a441cac..5c898c01659798 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1012,34 +1012,12 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	return ret;
 }
 
-/**
- * unmap_pages() - Make a range of IOVA empty/not present
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @iotlb_gather: Gather struct that must be flushed on return
- *
- * unmap_pages() will remove a translation created by map_pages(). It cannot
- * subdivide a mapping created by map_pages(), so it should be called with IOVA
- * ranges that match those passed to map_pages(). The IOVA range can aggregate
- * contiguous map_pages() calls so long as no individual range is split.
- *
- * Context: The caller must hold a write range lock that includes
- * the whole range.
- *
- * Returns: Number of bytes of VA unmapped. iova + res will be the point
- * unmapping stopped.
- */
-size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
-			      size_t pgsize, size_t pgcount,
+static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	struct pt_unmap_args unmap = { .free_list = IOMMU_PAGES_LIST_INIT(
 					       unmap.free_list) };
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_range range;
 	int ret;
 
@@ -1054,7 +1032,6 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	return unmap.unmapped;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(unmap_pages), "GENERIC_PT_IOMMU");
 
 static void NS(get_info)(struct pt_iommu *iommu_table,
 			 struct pt_iommu_info *info)
@@ -1102,6 +1079,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
 	.set_dirty = NS(set_dirty),
@@ -1164,6 +1142,7 @@ static int pt_iommu_init_domain(struct pt_iommu *iommu_table,
 
 	domain->type = __IOMMU_DOMAIN_PAGING;
 	domain->pgsize_bitmap = info.pgsize_bitmap;
+	domain->is_iommupt = true;
 
 	if (pt_feature(common, PT_FEAT_DYNAMIC_TOP))
 		range = _pt_top_range(common,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4926a43118e6fc..916b68408463a8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -34,6 +34,7 @@
 #include <linux/sched/mm.h>
 #include <linux/msi.h>
 #include <uapi/linux/iommufd.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "dma-iommu.h"
 #include "iommu-priv.h"
@@ -2666,13 +2667,12 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-static size_t __iommu_unmap(struct iommu_domain *domain,
-			    unsigned long iova, size_t size,
-			    struct iommu_iotlb_gather *iotlb_gather)
+static size_t
+__iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
+			   size_t size, struct iommu_iotlb_gather *iotlb_gather)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t unmapped_page, unmapped = 0;
-	unsigned long orig_iova = iova;
 	unsigned int min_pagesz;
 
 	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
@@ -2718,8 +2718,23 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 		unmapped += unmapped_page;
 	}
 
-	trace_unmap(orig_iova, size, unmapped);
-	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
+	return unmapped;
+}
+
+static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    size_t size,
+			    struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+	size_t unmapped;
+
+	if (pt)
+		unmapped = pt->ops->unmap_range(pt, iova, size, iotlb_gather);
+	else
+		unmapped = __iommu_unmap_domain_pgtbl(domain, iova, size,
+						      iotlb_gather);
+	trace_unmap(iova, size, unmapped);
+	iommu_debug_unmap_end(domain, iova, size, unmapped);
 	return unmapped;
 }
 
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd087..f094f8f44e4e8a 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -66,6 +66,13 @@ struct pt_iommu {
 	struct device *iommu_device;
 };
 
+static inline struct pt_iommu *iommupt_from_domain(struct iommu_domain *domain)
+{
+	if (!IS_ENABLED(CONFIG_IOMMU_PT) || !domain->is_iommupt)
+		return NULL;
+	return container_of(domain, struct pt_iommu, domain);
+}
+
 /**
  * struct pt_iommu_info - Details about the IOMMU page table
  *
@@ -80,6 +87,29 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @unmap_range: Make a range of IOVA empty/not present
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @len: Length of the range starting from @iova
+	 * @iotlb_gather: Gather struct that must be flushed on return
+	 *
+	 * unmap_range() will remove a translation created by map_range(). It
+	 * cannot subdivide a mapping created by map_range(), so it should be
+	 * called with IOVA ranges that match those passed to map_pages. The
+	 * IOVA range can aggregate contiguous map_range() calls so long as no
+	 * individual range is split.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: Number of bytes of VA unmapped. iova + res will be the
+	 * point unmapping stopped.
+	 */
+	size_t (*unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
+			      struct iommu_iotlb_gather *iotlb_gather);
+
 	/**
 	 * @set_dirty: Make the iova write dirty
 	 * @iommu_table: Table to manipulate
@@ -198,10 +228,6 @@ struct pt_iommu_cfg {
 				       unsigned long iova, phys_addr_t paddr,  \
 				       size_t pgsize, size_t pgcount,          \
 				       int prot, gfp_t gfp, size_t *mapped);   \
-	size_t pt_iommu_##fmt##_unmap_pages(                                   \
-		struct iommu_domain *domain, unsigned long iova,               \
-		size_t pgsize, size_t pgcount,                                 \
-		struct iommu_iotlb_gather *iotlb_gather);                      \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -223,8 +249,7 @@ struct pt_iommu_cfg {
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
 	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages,       \
-	.unmap_pages = &pt_iommu_##fmt##_unmap_pages
+	.map_pages = &pt_iommu_##fmt##_map_pages
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 54b8b48c762e88..7ca648c0133634 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -223,6 +223,7 @@ enum iommu_domain_cookie_type {
 struct iommu_domain {
 	unsigned type;
 	enum iommu_domain_cookie_type cookie_type;
+	bool is_iommupt;
 	const struct iommu_domain_ops *ops;
 	const struct iommu_dirty_ops *dirty_ops;
 	const struct iommu_ops *owner; /* Whose domain_alloc we came from */
-- 
2.43.0

