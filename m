Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4169215055;
	Mon, 12 Jan 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229357; cv=fail; b=X89QvdpjvFuZRtg2+trC+9Lu7pCxvulwARwpdNgNvm4GRiY6mntKDQ7S/16xIaErmBrpzdb0+py06CZGNKqNYFnWCIX4lCwYFeSrEXm0S8aM+TEQqfMa4xN7Cl7otyN39fwJ3+kr4J7uQJhSxM8k4f1vf5NwV+UiOh/bDpnWOgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229357; c=relaxed/simple;
	bh=9/hWBRwqxoKwb3PHzPQ9mb1gJy8DcgoMSMP2JnmnmfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X1pKNo+GndwQdN7asF8IHG7KAR5tRpMmLrXqGmQi2qo7uYpYCCKMxM2uHGXpFGIe6ZtnDDfOQ86CYuSdB3WZQwpP0Jvvgr8ThdGqSu2FJBTimxs/KRzUld8pG+vJNPcXkqWzhnoplR4x+9JLQA5zsJbmExBqBD1AC+RM2XYuuNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mhHere4c; arc=fail smtp.client-ip=40.107.200.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mhHere4c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIcT86LeoebUBkJ1GDkey4sdciPZQbZWZZw1mWduS4yM+cuqaTsVzLWXY5HKHjYOVagysbCPwPLfgegl3VEOq65/KiHy64IfJZ2bYZ0sNtB4rw9Dm8ZV17bIlHmhwqVw6zwltba1MIhQDP508zksKyMh1yjke7ctWN5KsBDA/Om5Atay35rHQlQI6+Q6kR+kMezVZKkfFd5kfKoj9V7ARYmSiZApOJRq2IvyOkGsk6zAW337PKARwoyxEWclMzowZMjf29j8iUB5Yz+8FGwh9uEoSiXqvP1b0PCMvk/IcgPDLPJy8EoDBRYmWaDTjbUFB+Ku/aYB+dbRJe8X+xoCPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MIHE62PpXHeDyzMjPMfoeblYviu6HzdKhvQ+AOwpug=;
 b=oQO+fDk4rdL087A+pGOLecnLIhvVnKCElcmpVNZePujz1WCkW/nf3/A0DEslH4y9QsA75NDbgl1QoSjeooJr8zgBvkRlaEKsYK9nRPjAgJ/fKTRAP0quGyjC3j8DsisjnzfevmWL8oaUqDINCz3SpmwzWm4LnpUXsIuK/5S9yyUJJJdx+93wAJnZEDAxZFNZ6/HM2wAl/frTd18PdjISCJ6y8R5Ip273iSH4MT3NGiOFx6PeplV7Dib+MuDyLpj9dOiUHHt/V6H/F0Qt+TyksHqXzKtvhRUOILfZVQOnTRVxhLRYv8kIi1OBsnBqGC0j0w9g47VCK0h6QVKZXDfhaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MIHE62PpXHeDyzMjPMfoeblYviu6HzdKhvQ+AOwpug=;
 b=mhHere4cuQqwdqq2u+taS9gZXeGhy733C0IlX/LZpaJgnXQ1Nkjv3eRFqgfjyVpsXbLPB/pGpVHfH/h0uTMGjJocVFjpavMdQDpulFbOh140iVUUYsAdRIlehTu3Tq7vZ05U1lB6BWW7c0llWE5lFoMk4OBb2TVG2+5Ius1xbhnAffCsdf5xOs6p37nh8xJXEZi2dOMsMs9ptEERV3KM/JJSeiXureP//fsnywiYV3HoQspD1uosXtX6wjZkg1jD6HLO1NdYRaU+MQNG7vpkWn7QcCibLr74eUei0ctGPlCLlGvYDjDZboonDBQ+2qHU5YjC5aWPnOUULf1ovJ9Ivw==
Received: from LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18)
 by DS5PPF8B1E59479.namprd12.prod.outlook.com (2603:10b6:f:fc00::659) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:10 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:49:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH 3/3] iommupt: Avoid rewalking during map
Date: Mon, 12 Jan 2026 10:49:04 -0400
Message-ID: <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P221CA0016.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|LV8PR12MB9641:EE_|DS5PPF8B1E59479:EE_
X-MS-Office365-Filtering-Correlation-Id: 1314153f-0b17-4623-2b49-08de51e9bbc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gX1H/Uo5NdyVuImAHew4vANfe7AsUCEzJeKSR28bFmFS+5Yxtem06lVu7993?=
 =?us-ascii?Q?CoEVUF3OfGW3IjKMIml4klBwjRqNDS6vXPrnE8k9DnSR/YhIx+U/Rrb2Sl18?=
 =?us-ascii?Q?YmWINUkUTzQrcZyDf+pL7CKX+53+4WGHf25wqstIuNXGA2UH5uDLol9nqoAd?=
 =?us-ascii?Q?q4csXhO9Vv3aitPbADVgg8b7vilt+WLE+dSwFG5FgO7bo/8ULHLMGsJ0mkAK?=
 =?us-ascii?Q?a1oun2n6oph6WN1IkQTtKd2EsN0f6NBn6TczknwHica1n6BNISNOGzK3mpji?=
 =?us-ascii?Q?GkTiw49YUGo1swpm8nbmoSzqINBKBUfoodogAueCUx+gA8IM+Tvtbfnnupsl?=
 =?us-ascii?Q?1E2An/L5UyJ2gWvfGIoTZlVBoc7WlKw9XPARb+54oPwRMYWRIAfcoxL6TWB0?=
 =?us-ascii?Q?6Ly6GAvnnBSD5bUzvmaUeba5a7l2d1V7sP+0UZgmB4wRnQkU4qUmKNptGGYc?=
 =?us-ascii?Q?TR52/KNu4Es30y6kDujn9OER0UNEb9Ej2ISKVk0CflAUyvqI5Ei554Xs9Jjk?=
 =?us-ascii?Q?2/KzHk3VIZPrjxt2ZuDAhFFF9EfBa88ScU+5XpUczP7hBV/Mh63y0sQmHw4F?=
 =?us-ascii?Q?35LP928sf6ijJOYjQj5YwBwZCCha8rfJl7MksaPG2SHPdabqBk3DKHm3jOCN?=
 =?us-ascii?Q?gjW53yvNyCpuYn7eaeDux6bEgvE09QQ1MxDePj+H7G5Fj+qg1rk8wgJ46LA5?=
 =?us-ascii?Q?Wo/kFjN6nTyKPag/5aqyRdmr03Nmi0P6OvXSh8Gr8CkwFErDfxP2h9Fquwlm?=
 =?us-ascii?Q?P8Nf4oZdclcmPnP+dH1ruoNV9p9c+mcYuMhQsoAcixU3wJnybduP6eeXzhqp?=
 =?us-ascii?Q?bX021MemdmFy04fzMGXI7/Qo7noJ4fn11cY8CCR15FWof5uKSl1Uvn85Wp8B?=
 =?us-ascii?Q?P1nJkWdKutsP6caiAp4hJNtxjHtdJ5A+WWaauqWQjKloG+hyduDCUiGzdU3C?=
 =?us-ascii?Q?tfASUasNx8NhoX30HEn+H965xIQPHbDcCikoW2+qqKwroEWM67hoBY+VqIc0?=
 =?us-ascii?Q?MmHTGFzqxKCXcJ7L9xfpKhD7p0ekk4jdHnt7KO271JtBUPyBkQonYaA1FLAP?=
 =?us-ascii?Q?8YJ7wSYXUPjYGnsgzQ/2vTIAoDTwsuhKWNd5+vZP3Q0gXTKvtubqaWJ7Zkr2?=
 =?us-ascii?Q?LvovweP9w2TdShPtBgEE+QRga2Bi8MSDQ0i4e0h99boTFAGwnw5/t8+i5ekv?=
 =?us-ascii?Q?B5RZEfkpRlWILDpiUo0ieniAG/z1FPq1VCXPuaId+O65fqD589tnSZKFW66I?=
 =?us-ascii?Q?VezhjpcP29EiE+Kv/IgMp+t33navrjHY1z3AuWTNqJuES9MjGKk6lJDqADNJ?=
 =?us-ascii?Q?f4Pys0CxKdp/YvttvC2eY9mw/evQW0PBPT//N6JAEuft3ksZ5hvSw2ElqkFd?=
 =?us-ascii?Q?mfCF5fAkofsOdXX9y8dBqryEFYkjMx/4mGockAn3tPArnTHl3y9cePbuBLNK?=
 =?us-ascii?Q?jQKDZZyON0OzKsKyp5QQlOJYEhOjINi6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8bKrQ3QM52pC/swgc4q4uHerufUlBL010bpJ70o1syrOsEGDe/HiCp4Byi7u?=
 =?us-ascii?Q?gN39+DsX3W4EYEXjLeQ1jTlXVaoK7Tg17JriEo/NPArnr/7TTjeLZ2kegrXD?=
 =?us-ascii?Q?Kwklk2zpB1fgfCxGvpotekWqle0CDjLcDm3uliR944YPvCrMaUzZF+SXqHFL?=
 =?us-ascii?Q?FQr/u/w8Msnsh4EXYwxLLx0wEB+SgfqM2EUle99kgTH4SewsPjHxVypfUmyQ?=
 =?us-ascii?Q?19FIjHq3iRpp8uhCq1Sos/AyxKG/fgdzAYd6vMBp6NzvQ0N3nnFg5aguXF/m?=
 =?us-ascii?Q?Ygtux1wda+2+08Q7JeppAHzhMLQ9OBRMmgIjqn3bIDox/IcxrD7mUouWPVf1?=
 =?us-ascii?Q?T+OUxKx+/t0tOJcWS6ES4dvp/zlY5w4oFgD6t/aWxtGl6Hth0+U1mG+2piDP?=
 =?us-ascii?Q?FrfJEK9ukpSVkHAaE3nmwHcBPneo/Sx8/QrGknhqphbKa08puVNKFdIo+Zbo?=
 =?us-ascii?Q?jxd9nngeH7C4n2L+KH34w31t69wxpZ9sPhfl0MUSe8Xb91PeAJwa5/mOHCv2?=
 =?us-ascii?Q?43bqa7Gu85GSMfMA1lMBEUbyAVRVm5TvqDJoyy1N+x6PQW0ZLH6o0e+yVvxS?=
 =?us-ascii?Q?/VLnGv8MjhtftsXv2422K1ybX4O4ZbSKJRo4oBE61BXs/dOHV+M9VcdYTywC?=
 =?us-ascii?Q?u3pY5R09xQ8iPpYqk4vmndFk8cSXdvBXUstyuq4lokDo4voc0XdqoayMH/MM?=
 =?us-ascii?Q?DuBWv0tuA1Dddzl+e+DW4C4Crwu6siG8eOP9pjkWY1DNlypcCteGNFhTkvk6?=
 =?us-ascii?Q?/cX9l2kJGJ7Yw0YqH1/ZhBFmMMHZW52suJBPmR9VDdQnnpHueKfWxSlNnrqo?=
 =?us-ascii?Q?wjaFuOCq+Q0tKB3dxUvUL8qE+hSDYzoz244AFcrfH0YPIFybQoBINBRo8/uL?=
 =?us-ascii?Q?Tj5UdEGCG0ZHk27iPFSAMPPjVCNrQdd9UqyLUwu+g4t2vv9mtbGKgfOEWyt3?=
 =?us-ascii?Q?3/M1JDntm002Ry788Gnz35H9qLV0EMqyPxGwJJRtfCJd+2i/UNu/HvEvBSOP?=
 =?us-ascii?Q?RwM/F/QGxrWcat1fT1uP09FaFq++NZyNmLo6ImFqXtkheNLhBmR2yauLKlsU?=
 =?us-ascii?Q?TXIrsf/BLtBZC1wxXrqfSDNjU69SAvj/L6nfGOTWzqXM726QQxp29yQTzveu?=
 =?us-ascii?Q?oEQSF3cThuY4WR2JvLGcG3PWH0yRi+d7GibLcAGPs6C5/VEq7OlRKgz0rv/9?=
 =?us-ascii?Q?6mNFXzV3hthIyC+wCxTKx+nZEDCLZTkZ2wW9hmdtDjgv4/RzbthGcuTfncvl?=
 =?us-ascii?Q?kZ9jUQoYkj0Dr4fgNLaG2aj6xVFqh4yUqd/7V5seu9ykGYWJCybfv0lIYvFW?=
 =?us-ascii?Q?6j516F7uEDSoqOMpfnAKoLnuB4GnJUjT3pKKk2H521sr3ADI2X8SX2l8pn0d?=
 =?us-ascii?Q?XhtGwXT/RFNN2poOM6/MsDE8CgYNasd444qpjR2rqRRr9pp8OrH2zYM1s6wA?=
 =?us-ascii?Q?VkT4jtiedimZMdIdn8AQhFy6ZDf9ZNIvw6ktZXci/zW4CsCG7A9z0ZF7S7RU?=
 =?us-ascii?Q?Mqhn75j18aACd/hm/BrhqdCQ+O21ZA91va7DaEdt4XmpqOza2FiuxUgpexTy?=
 =?us-ascii?Q?7Bdo5j5sKBPyWKDUJVNpGRaC9R3PlHeGbPSfb9CopNGFIz5sz+2vkfbbv1F1?=
 =?us-ascii?Q?vDje09+WPCmxQkucA+Yuo36yuQqpIQNTZi4LB/Iiq9fWXfKlOgMC8uMLmLQd?=
 =?us-ascii?Q?fnUWjryCU84/bY5A28zMvFBxc8axCXmiBjV4JxTHidh5VSCV7Ze8YLj6p8d6?=
 =?us-ascii?Q?v9uqZERSag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1314153f-0b17-4623-2b49-08de51e9bbc1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:49:05.6207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzpMUKODhHUkeyXRQ5d1XNt4j65CA9rxiD4FuFcskQ1vClIJ3QNe2PAwo7tXmkQ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF8B1E59479

Currently the core code provides a simplified interface to drivers where
it fragments a requested multi-page map into single page size steps after
doing all the calculations to figure out what page size is
appropriate. Each step rewalks the page tables from the start.

Since iommupt has a single implementation of the mapping algorithm it can
internally compute each step as it goes while retaining its current
position in the walk.

Add a new function pt_pgsz_count() which computes the same page size
fragement of a large mapping operations.

Compute the next fragment when all the leaf entries of the current
fragement have been written, then continue walking from the current
point.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified map_pages()
style interfaces.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h         | 127 ++++++++++++--------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_iter.h          |  22 ++++
 drivers/iommu/iommu.c                       |  25 +++-
 include/linux/generic_pt/iommu.h            |  34 +++++-
 5 files changed, 161 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 5c898c01659798..14a73d3b291b42 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -467,6 +467,7 @@ struct pt_iommu_map_args {
 	pt_oaddr_t oa;
 	unsigned int leaf_pgsize_lg2;
 	unsigned int leaf_level;
+	pt_vaddr_t num_leaves;
 };
 
 /*
@@ -519,11 +520,15 @@ static int clear_contig(const struct pt_state *start_pts,
 static int __map_range_leaf(struct pt_range *range, void *arg,
 			    unsigned int level, struct pt_table_p *table)
 {
+	struct pt_iommu *iommu_table = iommu_from_common(range->common);
 	struct pt_state pts = pt_init(range, level, table);
 	struct pt_iommu_map_args *map = arg;
 	unsigned int leaf_pgsize_lg2 = map->leaf_pgsize_lg2;
 	unsigned int start_index;
 	pt_oaddr_t oa = map->oa;
+	unsigned int num_leaves;
+	unsigned int orig_end;
+	pt_vaddr_t last_va;
 	unsigned int step;
 	bool need_contig;
 	int ret = 0;
@@ -537,6 +542,15 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 
 	_pt_iter_first(&pts);
 	start_index = pts.index;
+	orig_end = pts.end_index;
+	if (pts.index + map->num_leaves < pts.end_index) {
+		/* Need to stop in the middle of the table to change sizes */
+		pts.end_index = pts.index + map->num_leaves;
+		num_leaves = 0;
+	} else {
+		num_leaves = map->num_leaves - (pts.end_index - pts.index);
+	}
+
 	do {
 		pts.type = pt_load_entry_raw(&pts);
 		if (pts.type != PT_ENTRY_EMPTY || need_contig) {
@@ -562,7 +576,40 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	flush_writes_range(&pts, start_index, pts.index);
 
 	map->oa = oa;
-	return ret;
+	map->num_leaves = num_leaves;
+	if (ret || num_leaves)
+		return ret;
+
+	/* range->va is not valid if we reached the end of the table */
+	pts.index -= step;
+	pt_index_to_va(&pts);
+	pts.index += step;
+	last_va = range->va + log2_to_int(leaf_pgsize_lg2);
+
+	if (last_va - 1 == range->last_va) {
+		PT_WARN_ON(pts.index != orig_end);
+		return 0;
+	}
+
+	/*
+	 * Reached a point where the page size changed, compute the new
+	 * parameters.
+	 */
+	map->leaf_pgsize_lg2 = pt_compute_best_pgsize(
+		iommu_table->domain.pgsize_bitmap, last_va, range->last_va, oa);
+	map->leaf_level =
+		pt_pgsz_lg2_to_level(range->common, map->leaf_pgsize_lg2);
+	map->num_leaves = pt_pgsz_count(iommu_table->domain.pgsize_bitmap,
+					last_va, range->last_va, oa,
+					map->leaf_pgsize_lg2);
+
+	/* Didn't finish this table level, caller will repeat it */
+	if (pts.index != orig_end) {
+		if (pts.index != start_index)
+			pt_index_to_va(&pts);
+		return -EAGAIN;
+	}
+	return 0;
 }
 
 static int __map_range(struct pt_range *range, void *arg, unsigned int level,
@@ -585,14 +632,9 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 			if (pts.type != PT_ENTRY_EMPTY)
 				return -EADDRINUSE;
 			ret = pt_iommu_new_table(&pts, &map->attrs);
-			if (ret) {
-				/*
-				 * Racing with another thread installing a table
-				 */
-				if (ret == -EAGAIN)
-					continue;
+			/* EAGAIN on a race will loop again */
+			if (ret)
 				return ret;
-			}
 		} else {
 			pts.table_lower = pt_table_ptr(&pts);
 			/*
@@ -616,10 +658,12 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		 * The already present table can possibly be shared with another
 		 * concurrent map.
 		 */
-		if (map->leaf_level == level - 1)
-			ret = pt_descend(&pts, arg, __map_range_leaf);
-		else
-			ret = pt_descend(&pts, arg, __map_range);
+		do {
+			if (map->leaf_level == level - 1)
+				ret = pt_descend(&pts, arg, __map_range_leaf);
+			else
+				ret = pt_descend(&pts, arg, __map_range);
+		} while (ret == -EAGAIN);
 		if (ret)
 			return ret;
 
@@ -627,6 +671,8 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		pt_index_to_va(&pts);
 		if (pts.index >= pts.end_index)
 			break;
+		if (map->leaf_level == level)
+			return -EAGAIN;
 	} while (true);
 	return 0;
 }
@@ -798,12 +844,13 @@ static int check_map_range(struct pt_iommu *iommu_table, struct pt_range *range,
 static int do_map(struct pt_range *range, struct pt_common *common,
 		  bool single_page, struct pt_iommu_map_args *map)
 {
+	int ret;
+
 	/*
 	 * The __map_single_page() fast path does not support DMA_INCOHERENT
 	 * flushing to keep its .text small.
 	 */
 	if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
-		int ret;
 
 		ret = pt_walk_range(range, __map_single_page, map);
 		if (ret != -EAGAIN)
@@ -811,50 +858,25 @@ static int do_map(struct pt_range *range, struct pt_common *common,
 		/* EAGAIN falls through to the full path */
 	}
 
-	if (map->leaf_level == range->top_level)
-		return pt_walk_range(range, __map_range_leaf, map);
-	return pt_walk_range(range, __map_range, map);
+	do {
+		if (map->leaf_level == range->top_level)
+			ret = pt_walk_range(range, __map_range_leaf, map);
+		else
+			ret = pt_walk_range(range, __map_range, map);
+	} while (ret == -EAGAIN);
+	return ret;
 }
 
-/**
- * map_pages() - Install translation for an IOVA range
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @paddr: Physical/Output address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
- * @gfp: GFP flags for any memory allocations
- * @mapped: Total bytes successfully mapped
- *
- * The range starting at IOVA will have paddr installed into it. The caller
- * must specify a valid pgsize and pgcount to segment the range into compatible
- * blocks.
- *
- * On error the caller will probably want to invoke unmap on the range from iova
- * up to the amount indicated by @mapped to return the table back to an
- * unchanged state.
- *
- * Context: The caller must hold a write range lock that includes the whole
- * range.
- *
- * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA that were
- * mapped are added to @mapped, @mapped is not zerod first.
- */
-int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			 int prot, gfp_t gfp, size_t *mapped)
+static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	pt_vaddr_t pgsize_bitmap = iommu_table->domain.pgsize_bitmap;
 	struct pt_common *common = common_from_iommu(iommu_table);
 	struct iommu_iotlb_gather iotlb_gather;
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_iommu_map_args map = {
 		.iotlb_gather = &iotlb_gather,
 		.oa = paddr,
-		.leaf_pgsize_lg2 = vaffs(pgsize),
 	};
 	bool single_page = false;
 	struct pt_range range;
@@ -882,13 +904,13 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 		return ret;
 
 	/* Calculate target page size and level for the leaves */
-	if (pt_has_system_page_size(common) && pgsize == PAGE_SIZE &&
-	    pgcount == 1) {
+	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
 		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
 		if (log2_mod(iova | paddr, PAGE_SHIFT))
 			return -ENXIO;
 		map.leaf_pgsize_lg2 = PAGE_SHIFT;
 		map.leaf_level = 0;
+		map.num_leaves = 1;
 		single_page = true;
 	} else {
 		map.leaf_pgsize_lg2 = pt_compute_best_pgsize(
@@ -897,6 +919,9 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 			return -ENXIO;
 		map.leaf_level =
 			pt_pgsz_lg2_to_level(common, map.leaf_pgsize_lg2);
+		map.num_leaves = pt_pgsz_count(pgsize_bitmap, range.va,
+					       range.last_va, paddr,
+					       map.leaf_pgsize_lg2);
 	}
 
 	ret = check_map_range(iommu_table, &range, &map);
@@ -919,7 +944,6 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 	*mapped += map.oa - paddr;
 	return ret;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
 
 struct pt_unmap_args {
 	struct iommu_pages_list free_list;
@@ -1079,6 +1103,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.map_range = NS(map_range),
 	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index 68278bf15cfe07..374e475f591e15 100644
--- a/drivers/iommu/generic_pt/kunit_generic_pt.h
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -312,6 +312,17 @@ static void test_best_pgsize(struct kunit *test)
 	}
 }
 
+static void test_pgsz_count(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_4K, 0, SZ_1G - 1, 0, ilog2(SZ_4K)),
+			SZ_1G / SZ_4K);
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_2M | SZ_4K, SZ_4K, SZ_1G - 1, SZ_4K,
+				      ilog2(SZ_4K)),
+			(SZ_2M - SZ_4K) / SZ_4K);
+}
+
 /*
  * Check that pt_install_table() and pt_table_pa() match
  */
@@ -770,6 +781,7 @@ static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_init),
 	KUNIT_CASE_FMT(test_bitops),
 	KUNIT_CASE_FMT(test_best_pgsize),
+	KUNIT_CASE_FMT(test_pgsz_count),
 	KUNIT_CASE_FMT(test_table_ptr),
 	KUNIT_CASE_FMT(test_max_va),
 	KUNIT_CASE_FMT(test_table_radix),
diff --git a/drivers/iommu/generic_pt/pt_iter.h b/drivers/iommu/generic_pt/pt_iter.h
index c0d8617cce2928..3e45dbde6b8327 100644
--- a/drivers/iommu/generic_pt/pt_iter.h
+++ b/drivers/iommu/generic_pt/pt_iter.h
@@ -569,6 +569,28 @@ static inline unsigned int pt_compute_best_pgsize(pt_vaddr_t pgsz_bitmap,
 	return pgsz_lg2;
 }
 
+/*
+ * Return the number of pgsize_lg2 leaf entries that can be mapped for
+ * va to oa. This accounts for any requirement to reduce or increase the page
+ * size across the VA range.
+ */
+static inline pt_vaddr_t pt_pgsz_count(pt_vaddr_t pgsz_bitmap, pt_vaddr_t va,
+				       pt_vaddr_t last_va, pt_oaddr_t oa,
+				       unsigned int pgsize_lg2)
+{
+	pt_vaddr_t len = last_va - va + 1;
+	pt_vaddr_t next_pgsizes = log2_set_mod(pgsz_bitmap, 0, pgsize_lg2 + 1);
+
+	if (next_pgsizes) {
+		unsigned int next_pgsize_lg2 = vaffs(next_pgsizes);
+
+		if (log2_mod(va ^ oa, next_pgsize_lg2) == 0)
+			len = min(len, log2_set_mod_max(va, next_pgsize_lg2) -
+					       va + 1);
+	}
+	return log2_div(len, pgsize_lg2);
+}
+
 #define _PT_MAKE_CALL_LEVEL(fn)                                          \
 	static __always_inline int fn(struct pt_range *range, void *arg, \
 				      unsigned int level,                \
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 000dd6c374877b..4c3b8184a2c28b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2501,8 +2501,9 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	return pgsize;
 }
 
-int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
-		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
+				    unsigned long iova, phys_addr_t paddr,
+				    size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
@@ -2580,6 +2581,26 @@ int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
 	return ops->iotlb_sync_map(domain, iova, size);
 }
 
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+
+	if (pt) {
+		size_t mapped = 0;
+		int ret;
+
+		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
+					 &mapped);
+		if (ret) {
+			iommu_unmap(domain, iova, mapped);
+			return ret;
+		}
+		return 0;
+	}
+	return __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
+}
+
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index f094f8f44e4e8a..43cc98c9c55f70 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -87,6 +87,33 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @map_range: Install translation for an IOVA range
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @paddr: Physical/Output address to start
+	 * @len: Length of the range starting from @iova
+	 * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
+	 * @gfp: GFP flags for any memory allocations
+	 *
+	 * The range starting at IOVA will have paddr installed into it. The
+	 * rage is automatically segmented into optimally sized table entries,
+	 * and can have any valid alignment.
+	 *
+	 * On error the caller will probably want to invoke unmap on the range
+	 * from iova up to the amount indicated by @mapped to return the table
+	 * back to an unchanged state.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA
+	 * that were mapped are added to @mapped, @mapped is not zerod first.
+	 */
+	int (*map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped);
+
 	/**
 	 * @unmap_range: Make a range of IOVA empty/not present
 	 * @iommu_table: Table to manipulate
@@ -224,10 +251,6 @@ struct pt_iommu_cfg {
 #define IOMMU_PROTOTYPES(fmt)                                                  \
 	phys_addr_t pt_iommu_##fmt##_iova_to_phys(struct iommu_domain *domain, \
 						  dma_addr_t iova);            \
-	int pt_iommu_##fmt##_map_pages(struct iommu_domain *domain,            \
-				       unsigned long iova, phys_addr_t paddr,  \
-				       size_t pgsize, size_t pgcount,          \
-				       int prot, gfp_t gfp, size_t *mapped);   \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -248,8 +271,7 @@ struct pt_iommu_cfg {
  * iommu_pt
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
-	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages
+	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
-- 
2.43.0

