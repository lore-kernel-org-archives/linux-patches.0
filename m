Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C83B749C;
	Tue, 20 Jan 2026 00:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768868001; cv=fail; b=PHNEDLVql1stYiJXFMJ9Ll1n5/Eq3z/zYBD2TarMs1U1fTcldzO8kKm8+ob6ZAVwt59FYeHmMfnLt/j9mnOwGDDzJVfxb7iEbONndXyIm7Elh+B80AieHyr1yPVYcUMC0cfqDb5i/4xOIl1OJz3bMeULfY3gzbOoXQP7hC3jkFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768868001; c=relaxed/simple;
	bh=Cdyre2rHPP1SMEgq6XpuCUjkmpNnDgh1evrPy2+iQeE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sWt1z5S1iZ0NjwWAoLVSk29uxTedjqgkUt6ayMrsSKR4GbW+0cf/8mTEXOK2T8iCwPytIpVQjdmKxaWWid8lHC1jwDb4OmvX7nuGWVkbv/FV3wC13dxnbgG9k2/Ni9/Da2raW0AYc6N0UyEnSNf0mIV8UVyCEEYtLWqnO2c8ttU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tb5/xPC2; arc=fail smtp.client-ip=40.107.208.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tb5/xPC2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hsi7hiPSzPkFZJ0Y+wJCnAnrLy1AA2n1omoT4XXb7aHxTgv4uK9lWJRocQwXVOHL5I0gWVczgvueV3UgMfeohw2DAmbmUKkD2+ztti//u16n6n6hp3rah0KJWZ7iHsddX3Amanpw3CB4OmObdVd+PoNPEqmvhsCU3JVBBO6LFGS8JIX/tKg2o6i9iuLSaqWQ2ffV0uMGo/PdW90eT6EfodKCuHddCt3RJf0xY1S1Yt5js6Zj1YUcfzHoosHhiLwmr8texEF0Ue05lhGJp8YRBN62bdJj7l1QNz2B4YsBvvx6JRCjxOsCoHs3bgQ0d0sXV4WIoiMTzlpMNe7PoRWCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsSUXhDJmpvMjoI7pICdEmpvyXoLkunghTRBtS8uUZ4=;
 b=X10/lnJHVLqYR2MblvTvBdbXcqUXs+4R6qcbKEjQw0D6AWJppQ9jo+NAxJ22yXfADYfwFv1RiVadXHMWnvxFrYmrXp2qX9Ri+4XvBKhtLuf120+4XcmKIVUU5ZSFK/hXpykKw5azlEWgGbTUnAHquaZglIrCftVeA+X8Pq8k/+2Drg3x6mag7FjUmXGeBNRroIChczN6k/HLgUDXQuUfkcQkHOR/N0wII5JXVohZdOJnS6JkV45JAHf///NZFxkCl1dSauyiw4RXFged7LK1AB58mdYvCkIzq4OjSnpAWpMtNpz/D+4xIElCV9GWFgfS6MpAbnmHZeQYbtrGx/IFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsSUXhDJmpvMjoI7pICdEmpvyXoLkunghTRBtS8uUZ4=;
 b=Tb5/xPC270xbWaQ+BN3hUpcdkc/sd+pmFRI+E+AcpnUUTaZs6bs9AW+pNShZ/7H/pTSvFh1mkzFPrzg687hGJbKUuQ7CuRcSn30ggG4vShpBdwY+Jy/xyW2S/4pu5/fe8pmKMHERWE7lTVuvp0iqGIhb+pe1idoDZNJa1PW9yQwSz+oi9xBkg9pWrBZlZ55xHE3QaVr/a08agk7dhNbDqRwaooJzIMPnc65zfBz4RwZsZe//awY7h30daJr9e1sIGalMAiNItloUeEAvmG5N/zKNQxSBiFHYm2eSpprVWwE+7RiNVMVrvVfYOJz/FQPZoEJ53cwlp4m4uL7JYBfDCw==
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
Subject: [PATCH v2 0/2] Let iommupt manage changes in page size internally
Date: Mon, 19 Jan 2026 20:13:13 -0400
Message-ID: <0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:208:23c::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN2PR12MB4142:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c37324-5439-4fdb-f7fe-08de57b8b5b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?poD02YIZeGo4UWP+Ckt6S6dPSrlVU35/PS0PmHsdfh54erYLsX9+evFf3D7l?=
 =?us-ascii?Q?tgBu1onDS5nmegcMeYL/OMwMf289DY6HoClJJ4bggSwmuAgKpDzCNMdFgbwn?=
 =?us-ascii?Q?tOcpm+c8q0FAXVnx8mIw2rKy0qf8TcOmhzU/SvRINDTdPZBSkPs9htSBQqsD?=
 =?us-ascii?Q?71/lxnS6GgaJzkS7YVGPvGXm8b7Gl7aqITzH/HxSG5PZy28ClfD3NfUzu/iy?=
 =?us-ascii?Q?XqZ5l/ohFJKy0CM+fATJOJVucGrrWeByRRkV0NdPZDtwi8Z7KYDPaLCJrJmc?=
 =?us-ascii?Q?qTemzO99rwT4OrmoCLlPkH+FDP/e9C4YmPKB+IG8wbm67X7HvxRm+sHwnrKn?=
 =?us-ascii?Q?WDNEsypYwJ2U5Q4np5ZonR1Z80Gi4UkbfAE/WvGdzTz3ysdQWIWjZmStBnLf?=
 =?us-ascii?Q?QTygXnQvExY7jcfKPB4e/61Wc0S/dfmq90XAwu9vGCUKRNEyffFG+hugeszL?=
 =?us-ascii?Q?EnDREd2ygtI7ydj7VQsbZsKaVPcTh5V2DgZYh2p+yxmP2Sn+ZgnxZo+qPvu5?=
 =?us-ascii?Q?Y+pWKO8wdYdBF/bMCvNaZ+LWTRq4QqTH/5NV/UROBEsM9UkXjR+4A+Fzdbh1?=
 =?us-ascii?Q?Y65Ik7wJ9duoH40NVGt8Xfl61aWtqBQUA3uwFqK+K43p2SyWsFUl3VbbcqjS?=
 =?us-ascii?Q?DfLeh/RGJLr0y6AQfU9WAkkJTRcmoeCTtEZjn+pFE+RdnwpJxdJKZLl/wGQX?=
 =?us-ascii?Q?74EAOdvqlMDGpUE5C/M1BHTrcDGX0m0vcIdD4jAKlFi2/8dx5CG0dBB4Z+29?=
 =?us-ascii?Q?uAewzpGZ8E/4Y7V2aZR0UvGYE3H22nqpRq77r3qA4FplHB2DpAsTVrEW572K?=
 =?us-ascii?Q?Z2AongY8ngHbjFTt5f4/mf5a79VWiBTrX/AvchbpvKx3moZdUPGBaBu7Fkyt?=
 =?us-ascii?Q?Lzb6MbBJr0LXC2ZpO0tAse+KWC3vMBAf/giP8i+SwRIvvpuwkE7BheCR6tx3?=
 =?us-ascii?Q?6s91/4woZWVknR5H1ZksH+dzydQd7oF0awT1A8of2ewof8MG1zdROmOd4R5K?=
 =?us-ascii?Q?m7GRfg/4E3hakMPAX0Tov4SSCPpAP7s8ZIPcl/gQkXX4nRIEf7OFYvWLyBf9?=
 =?us-ascii?Q?VpqRZkQU75jYvQNMemdjVLp9lWZzB2aJoN2S7FAN2+DhAp+iasXSa2TU1vBQ?=
 =?us-ascii?Q?Mfp5jxMQvdV8NCxlJfMmM2R5TPe2aEsMzA6vQ0CpfDUVY51BpmJzTCqHzzPN?=
 =?us-ascii?Q?G9HRr3UHem97UMUW8DCmz9Il7A8r267eURcH8FZjry1tDrCWlw6lxtsWoSHm?=
 =?us-ascii?Q?kU0QGswAaz2oaQ1jjd/sD7hu60ECzqePSF6PqMsmOtxwyBw8xBiUcS/vrVXp?=
 =?us-ascii?Q?RiDJPxiWjLXMjeDtxgro2X724kh5Z1FDWEx/ns1jJkfPl4lvRqqL0dnKMGqi?=
 =?us-ascii?Q?LjSBBqLt48cxTLzn6NhcfDIEYObFM1zmc8tNJdJtR8DagKAijJ+23jDv+fq0?=
 =?us-ascii?Q?B5vOh6jIx+6mX4Sb+IOf53uRQUF4w2YQdUh6rpTbf4wPKjORJypz39l5HqFX?=
 =?us-ascii?Q?nDoQ/znXNBzOauzilG2WlJqXIymQj5MHxSwC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ucldg8UZel41C/mnIa1d0hOihoP3rEwbDV3plZF2SMdkAdgY3vNd1k9tRToR?=
 =?us-ascii?Q?Efp5ylcso8tBUmkJ+Yv9LV44VChdstlRPVKGFn+Dt4JPkZUHyxSnFegAYkou?=
 =?us-ascii?Q?KY2KdAj4Fm0Kxm6eWZgTygpbKIzwW1kOFkODC9N9ANmP0jsocf3DtcIXZaJ2?=
 =?us-ascii?Q?zLlJO+1MOVFsLoeoSZ4qSm15x5uhgm7fBDXKaaKIhKy/W0ez4ozbH0OH3H3s?=
 =?us-ascii?Q?eYjazxzFmNLgRQbs8TJqm+/NAHiE5krzxLewL6Ovu++v0oU7qBRmxPnQGxw7?=
 =?us-ascii?Q?KousJkpPkr+oEJ0na9VOT7bAqCcjjRsYiYhXOTgiQtqttUSy2lJW+NwDeIAy?=
 =?us-ascii?Q?G/yNGPe7AS1tQXTAE9WRRrOfMFa5KpP4b4T2q2TFLI/V/ma/YAnUHMR0xxzk?=
 =?us-ascii?Q?qRRrWQevfH3lEq9wg6Rj7BRH/6xak5DZXnieV63snw7WneKHSmWLzWU8OeaP?=
 =?us-ascii?Q?GdPeW1pOf2wEaJU5tZ2VyXSsjTMS7nAtjm07GjLGYgTIJAK2i981NKY7iwoH?=
 =?us-ascii?Q?v3vkcgW+cTnTKWi0ziz0p//H8WnTsC259NBZOwCdx283CWsk1dE7ELW7qCrJ?=
 =?us-ascii?Q?bR8/i4m87qnDeukO0T4eiHe0LeRGLZ8OVFXcnNdZSmtPEZHRZmXlgFhfEdk+?=
 =?us-ascii?Q?OE2NJmp1W3PodGFvlnCCZZTaSIDE3ZRiPc8UK/vZyAohoo33Z6AHGKFp/8P0?=
 =?us-ascii?Q?7ozdaO2LzMUKSd4hucvfOc2Q1qeGu7sLvpMk7QnlBYwfaTxoxfwtFe6FAO3g?=
 =?us-ascii?Q?83DchUQmnzjKpxl6ufZ0Fox6hUrGR4YmcpJjGUmrPDG2q8aOAJPVCSexlS61?=
 =?us-ascii?Q?TlGseSW8ifqdtI+JACgpvImy68e3MdBqyTSsfvdpiBCzR8WJNQqyxJli6tJi?=
 =?us-ascii?Q?BlTraybduMsivKlsmWXFCi+tBeTf/B//svwpqCoq654i1iUNlaTQvz3kFUDv?=
 =?us-ascii?Q?dclB0k4afAVzbCTme57gnmUt3ubpXmLU+iQez16Jvl24Q/9ahqgOBIdCdIjM?=
 =?us-ascii?Q?PGHeRdD/L435AjC62Jk578ZE0leXg9uFsXDx7w5WYHB4Mc3wUEhyDmMkQjo2?=
 =?us-ascii?Q?rhZw9CYxmFHsrXZB+8t/EjmZocEzKFgy7oGW+jDe9g8ZjgqICWZtrjPowbjz?=
 =?us-ascii?Q?oJHo+63yTTK+90XtuF3wkiTseldJlE7z54mtKkgTylLQnRKYrYpmPr2lOHkT?=
 =?us-ascii?Q?kU7E03ZFkpl8qIuPQxb/WRbb5tlFIdzwHFKu1evIrUieXEhxAoZxQ0xeUxYw?=
 =?us-ascii?Q?lPhf1Zgi9U0YCtNIeFRYvHrGl+bze7mdcq+d90Bv39uhE3tmifKDwywXz+Da?=
 =?us-ascii?Q?Skuo8K4yljd+348Hc1Wbl6CUD+KwSqFdjz6OC3ECNaOZKB0o55wkeNTUxevv?=
 =?us-ascii?Q?LPLmPbdE7J4BVUUpqmCTQvcy5N4asnU0XBaFzgbdR63girDa3GdaMW7mFQO6?=
 =?us-ascii?Q?G/XDIsYcKtRB1bRMSgp0iYy3fe1Z7/hewzO1CieAntQHycgB30c/I/m7OB42?=
 =?us-ascii?Q?iQ9r76XpthvlZBmG0f6KkI0qr9uW8PgfG+ErNcEdQSubJnQPzx5/2IJP99sz?=
 =?us-ascii?Q?i9Dw++/T+cgxXz6SX43sDk7hba7hDukKy30SmBcLjRkgPjKz8dDRqNks7vXp?=
 =?us-ascii?Q?c5jayc6QYlJBY3mgm6jkk2KbSdil9S9mBdOjomzGnxM216GUgzLiFzKKoboB?=
 =?us-ascii?Q?k0JiZgQ9EPf1aS1pvcWyp/nh7DMncGm7+RA7WwhxB6J/xLDObnErOz0yLj7g?=
 =?us-ascii?Q?gPw3qMcMjw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c37324-5439-4fdb-f7fe-08de57b8b5b0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 00:13:16.8923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb/e0M55kiUgMI/vt8EUojIlC3iMPjCTqWpUvNmqzOIMxMvPIcnDntt4eAUzuDNg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4142

Currently the core code has some helpers that use iommu_pgsize() to
fragment operations into single page-size chunks and then the driver has a
simplified single-page size implementation. This was helpful in
simplifying the driver code.

However, iommupt has a single shared implementation for all formats so we
can accept a little more complexity. Have the core code directly call
iommupt with the requested range to map/unmap and rely on it to change the
page size across the range as required.

The iommupt implementation of unmap is already fine to work like this, and
the map implementation can reset its walking paramters in-place with a
little more code.

The net result is about a 5% performance bump in the simple iommupt
map/unmap benchmarks of mapped alignment, and probably more for
unaligned/oddly sized ranges that are changing page sizes.

Introduce a iommupt_from_domain() function as a general way to convert
an iommu_domain to a struct pt_iommu if it is a iommupt based domain. I
expect to keep using this as more optimizations are introduced.

v2:
 - Rebase to latest iommu tree
 - Adjust to the IOMMU_DEBUG_PAGEALLOC work
 - Fix missed trace calls for both map and unmap
 - Add a comment explaining the level changes
v1: https://patch.msgid.link/r/0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com

Jason Gunthorpe (2):
  iommupt: Directly call iommupt's unmap_range()
  iommupt: Avoid rewalking during map

 drivers/iommu/generic_pt/iommu_pt.h         | 162 +++++++++++---------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_iter.h          |  22 +++
 drivers/iommu/iommu.c                       |  66 ++++++--
 include/linux/generic_pt/iommu.h            |  69 +++++++--
 include/linux/iommu.h                       |   1 +
 6 files changed, 231 insertions(+), 101 deletions(-)


base-commit: 2ba96d2a97199914b4505d5962c338daa52b531f
-- 
2.43.0

