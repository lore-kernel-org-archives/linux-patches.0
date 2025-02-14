Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F6326868A;
	Fri, 14 Feb 2025 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552898; cv=fail; b=huq4E57cXJo4DaWKMptkyJPt82VI3juuW11spQ3bpX1mim3tUULO4WUZt7qxXWQbSD4FzHGY883/L1Io7Ha0+vgirY/KXm49withe1gZ2yNTzq3oiHoIpFkc52DckclYAzt6P4oJ1mFq3NrFTtaydpxJrwSxzA9cm7vE4Tt6DsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552898; c=relaxed/simple;
	bh=8owX0UimuTp4fd1IOKInR6cBeqD1aVR8hkBTKog8HQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Rsg7QQk6vVnTWTXKrMyPEcyv71JGWAkafky4JFKHEFIO8Dmy76DRcNSmnE8aG2SV5QR1tqzXuys7I2vywfwS2MOI+wzMLYI6K1DGiGft4dQ3VPuuTsdwoS45vb6d/RRn4TumvX/ZrwS1ZCAJKbS8HrnC7dBuK9b/8npg0JQrvVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eMkJnuDJ; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eMkJnuDJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRYc63J5Z9CgJfOZ1NV1inn4o2OlaRpJDgg2bu4JgxPpRLKMJo79+Azoji7nR9VPLeNUMO2paEK+hUXPxjiugplx+yCuIZGyd/SqGw5EyxrcHQIocSzuTulBd52R4IUMmkeZfGCOQbUZ5fHxS8NkEVuFNDHHv0SAkGVZgXJBsquiEWlkJ3AhQLw3eSGPV7s7sjH9z3uSRfCx1JOOdRtZAyLKdSNRm+NMb48tUhbEs5gUDUnWkfBITXiGteDw/Gg8dAU6cU3LIqN6HXHeDvZ9r1kmm12FBXaSECHMH6APfMAHtJui8DfXQm3vw4RbqWZyiAGBffE8Vqqau072Myyvug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZJeM3PGH5q9K5y1kqAZKJGg+yk0NtFwN0/v9eAYncI=;
 b=i1lip+JnGm3me7gVZTbo7+1upKjxqrffYS/3+c4kVAeU8tipL3wUE6pMSSfUSWRZzJvJSkw3NJtB9OKpIPkrLGRT8L1hzKl6PvMBGunRPMe8Di5/etqzN0G2wxOsX93QpBtg4tYlP/V6r5prJlF5CUwxfRqGzBPkOn+zx5dK0t/xOHswVXL29AFCL2g825BkWnrN6KpVpZwf/4R/6amjkjzq4quRnpAMOwIlI+YtJcfpIb58IckDpiLghCOd6o7gt8DMgApZ5iBOwUxilXmWxJSmNpVJfImOpAMbK4d4XdFKORyZil8Haat+3yRPqdwFKXEiAMK6CBtDUdp0nvU6kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZJeM3PGH5q9K5y1kqAZKJGg+yk0NtFwN0/v9eAYncI=;
 b=eMkJnuDJ0lcFmAuzVNngQAY8RM6V8f3zWokSqS5ZvUn4WuzpoPFp6QJqXupY90UOZhisW98ABCxKYIvOnn77KrWwgsIVPxbpemtTlJXa2JVF7wyUEsIU44eIFP75vA7idOejw96UwOFOyRC+X/4UfvXbjr5M0LAILd7BXp/25XD95iJrn5StxIpyI8Q30JzcFLkvszfmOm+YwkMxs/k363W6iyHm1z5GWQynlg9BytthbtBN3DHOk4YFsyKhLwzmorvNXiEV+uWRf5hVQHf5/rVDo29gnT/FbmpLrFQIEXibscr4IZu5pFWed4BVqkfmd398+0LMRB2oVwRRZzlP+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:05 +0000
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
Subject: [PATCH v2 05/23] iommu/pages: Remove the order argument to iommu_free_pages()
Date: Fri, 14 Feb 2025 13:07:38 -0400
Message-ID: <5-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 41e1b8b1-983a-40e5-998a-08dd4d1a21d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8rRoZGuvmlAzDjUyT8dapMdGefS28v0FILESCCLqDAvdOjApbU4aZ8cuj0kC?=
 =?us-ascii?Q?f+g/FZs4G1rfHYJQITmqbxAakINaF37qIN0Xv/dwbqzY4tpJRFda3pEd0D82?=
 =?us-ascii?Q?SEtWOkGyYYY2PD4CyReFDFVCpNj80PGu6xrTg3Ay3ZVjwL95XcjN0fhKb/kV?=
 =?us-ascii?Q?Qi5i/SNQXK+cKmDmWRd0xgWmR7oA7x2NmJeGH3Tajh5cIeTFLt4/sMEmKDW4?=
 =?us-ascii?Q?l6oQEvmRTF0zyb3kDSc9yLxNAODzVcD3OW9GvvYIlY9obwOKaU/eVfjdH3Ls?=
 =?us-ascii?Q?OvDqe1KlKyhYh//GKE+198k5XMav6egRbX1yc02m0+fZ7ydoI+gqq76KywBW?=
 =?us-ascii?Q?ix3hyIdO85i1SZk1bIFxxI+IqNbRNBeFkrLqH8p1CxJWn7qavT9VGalnMs21?=
 =?us-ascii?Q?i/KkLET82h00oLw1RjEMts0t8g/Jdz2FakshUgiDUCvWaHpblwlbY6cJReu0?=
 =?us-ascii?Q?EeMt2amWUCGLZoKoXMlZD+nxv9KjYEneTjzR43tpnps1ZaL7cR0YLHuUlqKP?=
 =?us-ascii?Q?ywtYD5g9XDRoXDSEtfeBmeRrYu+LD/m0ZDgnxjOO2vQpYhJm1fZXjwg4qrz5?=
 =?us-ascii?Q?vkq0yima8tvmHngwdImfJ+u5wMisxpsb9sOtME1YkD9304gFBEGc9FJL1GJU?=
 =?us-ascii?Q?1LlFt1GjuFpOt+7qgTM0EaSxHlhYLw4Zfw1phz8TSk3mEC8o2hUmo1rJ/Q0h?=
 =?us-ascii?Q?f4Rmy0xGiFESa8gGCqzJ6HEE1l7nc4TcivokIV2Icp0KfcMLx2/BSyz0Uf3Q?=
 =?us-ascii?Q?mB4sUo8tYBYDShjbbIDa8L44v4Lnpk/AxA+zz6XvWyBxQ9QCcmKTVBQtaazY?=
 =?us-ascii?Q?390wM+k48dXUJGRWP+id+CJNnmz2Kk1pUZvz74mNmmTrIdaN5Ins+x/IYYDj?=
 =?us-ascii?Q?r256kCXx+32A690C7jlV/AFY1N2Q0uDRlFq5D6e1Cq0j9n2JFgI7a8pqkE/P?=
 =?us-ascii?Q?v3mJgRh3hLJVYySWqYDzgaCxwUl64NoqZf468cJ2a8D+9ZE8Vb+TvNhu0seo?=
 =?us-ascii?Q?SdYcmv94bkciztttlotSHu1PTPXmY1uEUnSHA4CfBlo/rVgornak2M7m1jJD?=
 =?us-ascii?Q?4nLpFD7NNgry05E0xbARe4pVipd6OUqffmrb0yST3qtC8B8JJuj1tbhIQGo3?=
 =?us-ascii?Q?PgfYGULDxlRsb0xYmiMpNTFGB1AzQ0AAmfaai/TJ+U3z2mL7mAQ6FGGyuByy?=
 =?us-ascii?Q?fL+vJfwzE3NyoidW1sq6krDys+vRKeqozhsculM9BR5l7FHu702D7zuVpD0F?=
 =?us-ascii?Q?xksrKKdEq0cmvh+yNzBjdTkHuscTGJTJYYsa/OZwyBPJnNZTeYOwTTZHD/T1?=
 =?us-ascii?Q?soVcUPUPLae/R3r9LGlS+L5NJZ64Z2r/K3C/5DCTr4u0K5lTE16vlrHCcHYT?=
 =?us-ascii?Q?ZJGz6QmngEuXXSp0DyOp1XfJj4ugUAobQ1uOphk/4/9dXKuXEvEvlqyxUKT+?=
 =?us-ascii?Q?XFkI5Y9V/p0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+2wo464T0LVK/KiFJeTSIkhocLzO0irKFP+8MTRDVqmFsQkZRU+seCSw/j3/?=
 =?us-ascii?Q?w285R3VFgbwWCxMATh8RLu27vveEWxfOk2DnoVM5elZ2B/Mm3hmbEgOrR4F4?=
 =?us-ascii?Q?J66L352TPI+HcUfSJt0MGmEb1Vh1BZLYvyyUtRmq58nHFWZrxyR7pDMAqtIP?=
 =?us-ascii?Q?A+fQB07k7hDbTbkLFh70lbVvu/2A3EsvN1Kdoc1zSBhpNW8OGTXV+zKw19Mg?=
 =?us-ascii?Q?EFheo5M+JLQ1tPXHkYQg+6Mvdvd6dvDXUKZOgFn543D6tOOPrfx86ookoi4q?=
 =?us-ascii?Q?CVZHDz6BC6gyZj5ve7Lf9WrJoDNOq24XATSKOQkwM1yvZvrUPn5fTphkFAYh?=
 =?us-ascii?Q?R1ApBK/x6hD6W5q4MbdKcS+ctEjWLsCEg22zKgsBcc4Jge+ik7poxzDTvp/W?=
 =?us-ascii?Q?iLrvujw6J+UJ3kcaEPp0GplPkcBnteqPQo92GhmOC6um0LGFstpEpgcTikBo?=
 =?us-ascii?Q?YG/bCRsJQThSaRyy/Ry/XGz081TY8JiTP/kEU6NFWwW471EOih/TAqS1BXkq?=
 =?us-ascii?Q?XOuc5OMrfn+KRYRawphYi4OdRzswJDAez/NN/8lJeCf6xuCnMoHQUBStYEIw?=
 =?us-ascii?Q?Gb2q955HgXsvTSFZoshaiJPLDi5SzUWMmX1HQRdAL+aUIkd08VE0rIwA31aG?=
 =?us-ascii?Q?TRvFUsMrbwC75ardC5xURluUq3/PxmJ5tN2SBCHemFY+s+Kw3I8uzFQfQgjF?=
 =?us-ascii?Q?ZuMV8gn7lHlg9/qaq7bFSLP1kxWMlVdG55jaWJ10ZSN0O+uxEOUbClxv1Czp?=
 =?us-ascii?Q?FpPeJDn83c5iJvKs/tke4t/DP+3LFFDDfIxHW2fyYjipLmg85iSCoMGq73ra?=
 =?us-ascii?Q?usp+MHJyg04KQ7vsSAQFz3A1/HzQ7Cl8Zdwyi9qJe41Ur8CpYm6KxKBXjuEk?=
 =?us-ascii?Q?hpRWwUPKEoh8kVKJioe4TsDykiVY+9Z1xJhRPt4+wknbrLTVuccLxj2bIU2u?=
 =?us-ascii?Q?TLA4KY2mxbXzLTH92yACSc+leQhx81hbB6/5S8ldd1DCFWDvvGjgo9wQ2nET?=
 =?us-ascii?Q?enBDOgpk542X0CNCiCiUW+zaX0hwvm9S2fW5DXwbE2ks2+elH6GDSLEPUGlT?=
 =?us-ascii?Q?bE60+JRaz34O2jiSHMNEyYFLUK4IR2J7PKblql6/Z4UYt7uavpRsAVxivHRx?=
 =?us-ascii?Q?VW6+9zr4rqAWUxtg5vAUMFQlHreZvIZ2fDAQRGJzk43SMJp6GF11F8g4e03G?=
 =?us-ascii?Q?7fDNlBmt7zJMxT+4l1ZYZHvBxfqFnxAHhQ7RRW1++7QlEF3qOY/DX8RtBITG?=
 =?us-ascii?Q?ugoZ+L1NegCXza1LIoCzJ2NunB7zwIfwXoHq44kp3fCFtl11ZuuVvaRX325c?=
 =?us-ascii?Q?3Bj8lhQlvumVouJvR0rfPe6zR0OWyDlKUU83MLUI27dgq0q0bvb5Ju545ere?=
 =?us-ascii?Q?CcieYkY8H4hfBaxhDhiyV2UBW+b8BBiRrresIGx+zpMmZ/D/eYbuxy7kQa9x?=
 =?us-ascii?Q?EdznmatPZTLv+oo/WjRy3ba9d4Nj0pBht8JSOtuZ0hswt6GT2BOOxalNmEr8?=
 =?us-ascii?Q?fOIx8ssEL1Ljfe1IVyxmmaOdUX8qN2No9ODo7RUJJvIYTEnGQLrLtKJLRGzd?=
 =?us-ascii?Q?6ugQvbuDUWTNHnlcNkE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e1b8b1-983a-40e5-998a-08dd4d1a21d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7zsLLuZNXNa31y3qzbS+lefzqsplZqzK+8/BCY2/6JgMFRM/cdv4fLvJJfAQzAx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Now that we have a folio under the allocation iommu_free_pages() can know
the order of the original allocation and do the correct thing to free it.

The next patch will rename iommu_free_page() to iommu_free_pages() so we
have naming consistency with iommu_alloc_pages_node().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c            | 28 +++++++++++-----------------
 drivers/iommu/amd/ppr.c             |  2 +-
 drivers/iommu/exynos-iommu.c        |  8 ++++----
 drivers/iommu/intel/irq_remapping.c |  4 ++--
 drivers/iommu/intel/pasid.c         |  3 +--
 drivers/iommu/intel/pasid.h         |  1 -
 drivers/iommu/intel/prq.c           |  4 ++--
 drivers/iommu/io-pgtable-arm.c      |  4 ++--
 drivers/iommu/io-pgtable-dart.c     | 10 ++++------
 drivers/iommu/iommu-pages.h         |  9 +++++----
 drivers/iommu/riscv/iommu.c         |  6 ++----
 drivers/iommu/sun50i-iommu.c        |  2 +-
 12 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada061..f47ff0e0c75f4e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -653,8 +653,7 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table,
-			 get_order(pci_seg->dev_table_size));
+	iommu_free_pages(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -671,8 +670,7 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->rlookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->rlookup_table);
 	pci_seg->rlookup_table = NULL;
 }
 
@@ -691,8 +689,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_pages(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -716,8 +713,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table,
-			 get_order(pci_seg->alias_table_size));
+	iommu_free_pages(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -826,7 +822,7 @@ static void iommu_disable_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	iommu_free_pages(iommu->cmd_buf);
 }
 
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
@@ -838,7 +834,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 	if (buf &&
 	    check_feature(FEATURE_SNP) &&
 	    set_memory_4k((unsigned long)buf, (1 << order))) {
-		iommu_free_pages(buf, order);
+		iommu_free_pages(buf);
 		buf = NULL;
 	}
 
@@ -882,14 +878,14 @@ static void iommu_disable_event_buffer(struct amd_iommu *iommu)
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+	iommu_free_pages(iommu->evt_buf);
 }
 
 static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	iommu_free_pages(iommu->ga_log, get_order(GA_LOG_SIZE));
-	iommu_free_pages(iommu->ga_log_tail, get_order(8));
+	iommu_free_pages(iommu->ga_log);
+	iommu_free_pages(iommu->ga_log_tail);
 #endif
 }
 
@@ -2781,8 +2777,7 @@ static void early_enable_iommus(void)
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy,
-						 get_order(pci_seg->dev_table_size));
+				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2795,8 +2790,7 @@ static void early_enable_iommus(void)
 		pr_info("Copied DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
-			iommu_free_pages(pci_seg->dev_table,
-					 get_order(pci_seg->dev_table_size));
+			iommu_free_pages(pci_seg->dev_table);
 			pci_seg->dev_table = pci_seg->old_dev_tbl_cpy;
 		}
 
diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 7c67d69f0b8cad..e6767c057d01fa 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -48,7 +48,7 @@ void amd_iommu_enable_ppr_log(struct amd_iommu *iommu)
 
 void __init amd_iommu_free_ppr_log(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->ppr_log, get_order(PPR_LOG_SIZE));
+	iommu_free_pages(iommu->ppr_log);
 }
 
 /*
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c666ecab955d21..1019e08b43b71c 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -932,9 +932,9 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	return &domain->domain;
 
 err_lv2ent:
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->lv2entcnt);
 err_counter:
-	iommu_free_pages(domain->pgtable, 2);
+	iommu_free_pages(domain->pgtable);
 err_pgtable:
 	kfree(domain);
 	return NULL;
@@ -975,8 +975,8 @@ static void exynos_iommu_domain_free(struct iommu_domain *iommu_domain)
 					phys_to_virt(base));
 		}
 
-	iommu_free_pages(domain->pgtable, 2);
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_pages(domain->pgtable);
+	iommu_free_pages(domain->lv2entcnt);
 	kfree(domain);
 }
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index ad795c772f21b5..d6b796f8f100cd 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -620,7 +620,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 out_free_bitmap:
 	bitmap_free(bitmap);
 out_free_pages:
-	iommu_free_pages(ir_table_base, INTR_REMAP_PAGE_ORDER);
+	iommu_free_pages(ir_table_base);
 out_free_table:
 	kfree(ir_table);
 
@@ -641,7 +641,7 @@ static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 			irq_domain_free_fwnode(fn);
 			iommu->ir_domain = NULL;
 		}
-		iommu_free_pages(iommu->ir_table->base, INTR_REMAP_PAGE_ORDER);
+		iommu_free_pages(iommu->ir_table->base);
 		bitmap_free(iommu->ir_table->bitmap);
 		kfree(iommu->ir_table);
 		iommu->ir_table = NULL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb59a7d35958f5..00da94b1c4c907 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -67,7 +67,6 @@ int intel_pasid_alloc_table(struct device *dev)
 	}
 
 	pasid_table->table = dir;
-	pasid_table->order = order;
 	pasid_table->max_pasid = 1 << (order + PAGE_SHIFT + 3);
 	info->pasid_table = pasid_table;
 
@@ -100,7 +99,7 @@ void intel_pasid_free_table(struct device *dev)
 		iommu_free_page(table);
 	}
 
-	iommu_free_pages(pasid_table->table, pasid_table->order);
+	iommu_free_pages(pasid_table->table);
 	kfree(pasid_table);
 }
 
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index 668d8ece6b143c..fd0fd1a0df84cc 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -47,7 +47,6 @@ struct pasid_entry {
 /* The representative of a PASID table */
 struct pasid_table {
 	void			*table;		/* pasid table pointer */
-	int			order;		/* page order of pasid table */
 	u32			max_pasid;	/* max pasid */
 };
 
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index c2d792db52c3e2..01ecafed31453c 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -338,7 +338,7 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	dmar_free_hwirq(irq);
 	iommu->pr_irq = 0;
 free_prq:
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return ret;
@@ -361,7 +361,7 @@ int intel_iommu_finish_prq(struct intel_iommu *iommu)
 		iommu->iopf_queue = NULL;
 	}
 
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_pages(iommu->prq);
 	iommu->prq = NULL;
 
 	return 0;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 7632c80edea63a..62df2528d020b2 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -300,7 +300,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, order);
+		iommu_free_pages(pages);
 
 	return NULL;
 }
@@ -316,7 +316,7 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, get_order(size));
+		iommu_free_pages(pages);
 }
 
 static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index c004640640ee50..7efcaea0bd5c86 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -262,7 +262,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 		pte = dart_install_table(cptep, ptep, 0, data);
 		if (pte)
-			iommu_free_pages(cptep, get_order(tblsz));
+			iommu_free_pages(cptep);
 
 		/* L2 table is present (now) */
 		pte = READ_ONCE(*ptep);
@@ -423,8 +423,7 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
 out_free_data:
 	while (--i >= 0) {
-		iommu_free_pages(data->pgd[i],
-				 get_order(DART_GRANULE(data)));
+		iommu_free_pages(data->pgd[i]);
 	}
 	kfree(data);
 	return NULL;
@@ -433,7 +432,6 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 static void apple_dart_free_pgtable(struct io_pgtable *iop)
 {
 	struct dart_io_pgtable *data = io_pgtable_to_data(iop);
-	int order = get_order(DART_GRANULE(data));
 	dart_iopte *ptep, *end;
 	int i;
 
@@ -445,9 +443,9 @@ static void apple_dart_free_pgtable(struct io_pgtable *iop)
 			dart_iopte pte = *ptep++;
 
 			if (pte)
-				iommu_free_pages(iopte_deref(pte, data), order);
+				iommu_free_pages(iopte_deref(pte, data));
 		}
-		iommu_free_pages(data->pgd[i], order);
+		iommu_free_pages(data->pgd[i]);
 	}
 
 	kfree(data);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 26b91940bdc146..88587da1782b94 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -105,11 +105,12 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 }
 
 /**
- * iommu_free_pages - free page of a given order
+ * iommu_free_pages - free pages
  * @virt: virtual address of the page to be freed.
- * @order: page order
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
  */
-static inline void iommu_free_pages(void *virt, int order)
+static inline void iommu_free_pages(void *virt)
 {
 	struct page *page;
 
@@ -127,7 +128,7 @@ static inline void iommu_free_pages(void *virt, int order)
  */
 static inline void iommu_free_page(void *virt)
 {
-	iommu_free_pages(virt, 0);
+	iommu_free_pages(virt);
 }
 
 /**
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8f049d4a0e2cb8..1868468d018a28 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -48,14 +48,13 @@ static DEFINE_IDA(riscv_iommu_pscids);
 /* Device resource-managed allocations */
 struct riscv_iommu_devres {
 	void *addr;
-	int order;
 };
 
 static void riscv_iommu_devres_pages_release(struct device *dev, void *res)
 {
 	struct riscv_iommu_devres *devres = res;
 
-	iommu_free_pages(devres->addr, devres->order);
+	iommu_free_pages(devres->addr);
 }
 
 static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p)
@@ -80,12 +79,11 @@ static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
 			      sizeof(struct riscv_iommu_devres), GFP_KERNEL);
 
 	if (unlikely(!devres)) {
-		iommu_free_pages(addr, order);
+		iommu_free_pages(addr);
 		return NULL;
 	}
 
 	devres->addr = addr;
-	devres->order = order;
 
 	devres_add(iommu->dev, devres);
 
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 8d8f11854676c0..6385560dbc3fb0 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -713,7 +713,7 @@ static void sun50i_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
 
-	iommu_free_pages(sun50i_domain->dt, get_order(DT_SIZE));
+	iommu_free_pages(sun50i_domain->dt);
 	sun50i_domain->dt = NULL;
 
 	kfree(sun50i_domain);
-- 
2.43.0

