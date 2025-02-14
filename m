Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74291267B94;
	Fri, 14 Feb 2025 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552894; cv=fail; b=oqjwhayTbQvL8plk9vf9cPN39p6NhhcctcOf2qqwe0n2fkmGZYdBXpEL6u+AjBbn9YGLvTRLvhM0A9ElNt6qnfgb+eF85EBG2ZXeLGiN9eFoukYh7FA1NKFxAjI8Dv3zAtnxfxe2zfK1lZ4UQsZYiP2qkGZ0nw3Iy0eDP3oCj3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552894; c=relaxed/simple;
	bh=3w+pUx7So7j4O6blLmD8O5fIBe82WlBd8SSzrNezI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n4gyvngYuZaJ2hkE18MVuBFktwrClJt0Bh+l0VhompMy8uRu1YNfadr6COCyyXcifVvZq8bp6AYc4JGLeS8M1PObo22dzPkL+88hQ9scgbJYMmMKBiKdR8iPCgyQpt0teBG4+kICHHGNHiPC8QFE5vKC0xTY/4zaf9BA/ux/7B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=imgr1n7G; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="imgr1n7G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZZRXsbOMIFzazjST5VRFU//scbs5Vhx2mwpHrllepevcJw/RRcmDvv7lyIatmVjpmiGNAvRVz1488N+0ujpMfsyzhMt8LoQjiboay51piKWcNDnGc4AmFDSZqmEAB7iJFlz86TUQeNV7+ENFyAwXp+5u0i3lYBne9jI3Vb+INGZtiDvNXnObpuJJCWPERjXcIOW8mTgwx2rWnqEIRCaOgSNDoQpLHSv6ba9+VQ3qZWT0q2yLnCZn95LPy3nfEaddvu8dO0CEcXC6qT3plyWr8pRK5be1gTCXdLKj/ZKWwuVBlsV7Yxg+efxK5UJcQ+I+FjhpFTXUxQIBqDa8gnBCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtZJ4xMLD9+fk8VLQ4Ts5Z8FQO2u4Pxg0MV5NMplONg=;
 b=Xs22oaLA7aT7PONKv/UGR/X2Ax83o/b4ems7P+wzzTHa6XggXgjBTcbXjxeIIt78/6MSDJoaLXvJJQH3UN6VYDEpw2oeNfOTFYdNu5xtrWqekhVFVJ0CNM7+EXUvzCLnzyckpda9fMP6Yt26EN34J2dZ6Hj2UuVIT7iZm40kOViabzwKxUdrahIoZL+uavRP20ZFL435ZyqjXnpjdcexTvHpD3Pael3wMFYdj4kUp9ndSnnbYabrFJxgFZ1GJz8XW4xv2Unql/XodfHLjsZyt3oTzNG7rjSuzQR8LSrFHIPDNZj4B7TXuux7XCTe8NtOunGhd5ZuzMlTWCkdv3CMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtZJ4xMLD9+fk8VLQ4Ts5Z8FQO2u4Pxg0MV5NMplONg=;
 b=imgr1n7GCYsAIcoUD1BULbuM3DyFwsWRC0TNHr4FxhxOip+/qkjPMwLiGYDegaYwsOIpBuoJ+a0iOacYSq8WnMw+tS5VFlVPBR3La/D21dXq7f6CZ9LH9p0P8Qcw3fh3QNF0AIT/KPk6CDHG3io26dls7BXdYhmeubworeeRNIuaXPLPlhIwunH/+ra2E8EinEFM0Py0U4IUxS3UW6+gBOL/GqM0GEMJB3LHEy3JObOibDPRWVwok0WcqOzUgJglM33T42jh1GmN1Db6X+NebQFkymajsiN71YAXaVPVt7buSQ2bzCXZn4EhYLVTFvg63en88NevJtORGXCA0CCXBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:03 +0000
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
Subject: [PATCH v2 06/23] iommu/pages: Remove iommu_free_page()
Date: Fri, 14 Feb 2025 13:07:39 -0400
Message-ID: <6-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca4bbcf-74c3-4d60-1792-08dd4d1a21c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nMwyEoxcZ5KtGCgBIdsE1AlIKyfwYieZA9woYrwYawQZNspPHnZg6qSRUJmb?=
 =?us-ascii?Q?2X3YNrbFFD46zvu0ub7FTuztWDwU6E7yG5KEF6mZC9MCxFbUG+6kZqFzE6Mq?=
 =?us-ascii?Q?skN/8I4JCXCYrTxFZIly9TAgbYeGUL0davTjrS1GaAF//PliaT80klaU2jJ6?=
 =?us-ascii?Q?VB34sj9qwUXrzmWaCnOWSrczFfej14OVIyR76AbFewknTdshr9gPtgk32PBf?=
 =?us-ascii?Q?eHwUAH21QoVKhfMjbQC/88RmB4hK/2veCcMt5iBeLIqkKvk6/G4rTyyBpm0T?=
 =?us-ascii?Q?Gyk8zc4iq1Q5JRU5NSj5kf2FFJE4lgJTXl2bgMUrx+8xzQXOJYs9ZFtr1Eca?=
 =?us-ascii?Q?zsaI/1vygA49VIo7JHTNZXJI4YPW2mCqmffYncOEKubcUKKaSsZuwW6EVZn2?=
 =?us-ascii?Q?+B2ISSOda91J/x0cMLb0t5/4RLHHv7qk6ldNgf9/Dc/WfuQtKOfHbvxy95qF?=
 =?us-ascii?Q?zkh1UbCA+Bc5ReP/ugmKrQonWPrXZKXbusvmBVrYvS8CDfXxYmoFHevxsdjy?=
 =?us-ascii?Q?eeb4R/eJSI6xGJ19OtfnVhKAjB+JWFDaoYfPb4iwJD6F1Yk8gvl73Qtw7yCD?=
 =?us-ascii?Q?H6UiL3kMbPVo8qVxQKGjyanGZVOtYzgvrUSjESTV688OtPPL0YAIxgIm647s?=
 =?us-ascii?Q?BZgwMCLcJ1ke+WGHY6QiEXGjrUNM76mRO3t3tmfgDaYvb6gbQq4Ec8Vnrenh?=
 =?us-ascii?Q?DnryxmCtpRaZT/JGyl1fZ0BzaU7r+OstQp22hCgp2FfAThFoqUErShbt8Opy?=
 =?us-ascii?Q?P3OCaaYwz0jsqABUbD40F9c0jJJTuzYtWuUMQmxiHzfOE7CNilThe4SHemsI?=
 =?us-ascii?Q?3Hi34y6RajfpKdGli30M+pSSty3siVNKurme6S1p4fV3U6SquC57B20lT5tt?=
 =?us-ascii?Q?r7H3QdM67KgPdoq33V8CZieCuC87LFYWp5SNjLE1WK9Fqy6x3HV8HP4nIh7n?=
 =?us-ascii?Q?h99i0RUD19Xl66kiuSU3r9XGQktAR4ZG4/CPbqS8QMFYq5QLd90EQoyY6VSr?=
 =?us-ascii?Q?SA+7PBIp3ZD8S489j+Vf8Tmi2o4hW+bhlGeqQH57WVBn6EP9vFgFOr89zOfL?=
 =?us-ascii?Q?wJSQLF5jxPYY27E1oKqoXdLMkRGSCsC8/43y4Cod2DpQIMWVr3R7pRcTKwvU?=
 =?us-ascii?Q?0bl2e7uFQHbffi/BcbXVq7Ki4hD+yqXy6enCszo/+f2EFxrv4ubZYfbMyWfR?=
 =?us-ascii?Q?BwCqZUDVTG15qhTi/JXEapnFBpGpkLEqO+JalFSpAvLPsiBf+j35Cd9V8QwA?=
 =?us-ascii?Q?KJVQmOQJTImUd3aLfwZyT0qKS3D3F1RQD2gR/qWL/mSnIq8wPEWBnIYkgZl4?=
 =?us-ascii?Q?57mPD7kbSUSO8Om1kWgeNMGwYcEPpQ5misvhKAEaz1H1J+l/ihsyrLjnMhjB?=
 =?us-ascii?Q?mNHSWIhOAfIcmYH8VPm69rMmAo5PJ99Um65ZFV/fu68aEo9+jMP+zi/frVx9?=
 =?us-ascii?Q?ATi4OY6yc24=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xtHnSQ90/KNEJ3i88wGV47+xXGs/gfrv3AaUXwBkG8NtSnxEvewNd21FPJMl?=
 =?us-ascii?Q?BR6UUIL8sEIOierRrG4uvzj9fzoy0akwkY+7BKVDj31vapgxJS3korSP0tcG?=
 =?us-ascii?Q?8TSoCmyXM6lXBFsK47dmD2beXD11k9kKCOXnR6cepasWIRpObom+Z3pcpqnF?=
 =?us-ascii?Q?1B1/oxzVnV1mWYckobsESI+0EpFXZdNmnUxU0Gvyqqpphr+7RDhBLZtJ8RO1?=
 =?us-ascii?Q?WJsnEW0oZAyadQ8JyVadQ8W+B/9B6eg0qt66rXS8eCLVug5O9ZgE8jtx4Sha?=
 =?us-ascii?Q?72Rs+l6jSg3fkz45v9YtqPfrPyz2AwFJIjQmhAYxi7P8LHYXIHZlJBqMwOsR?=
 =?us-ascii?Q?zTlALL0Nj9iZDUXC5wLRjfZ6YXb3vz1ynE28HvZ387CSwZlsUvw2wRsjRb/B?=
 =?us-ascii?Q?9ix2vyUUIlhwCiBKE2058hr2P0813M4HuoVCXg23Ofpid1fgcAuS4QdwYY/r?=
 =?us-ascii?Q?L+HmjDOiyZynv0YRHUZWCs/H4imzRUxAJpXcxthlsUr6pHL9LggniRThR8E/?=
 =?us-ascii?Q?jPLyX6tO0s7uqqxhfOIVTymJM44D3h2rQali2SoF9mTY4Zmex5sSV22gP2w7?=
 =?us-ascii?Q?HiJgC7VpoZ0Pptiht06yQNriZQACuY8JySk2kzqcmqFd72JMdET6A25CGes3?=
 =?us-ascii?Q?o+03Gl8n4RfoXfEAfuio4akaO/I4zVKInNBl83Bg2SVamB2iQvC1ccr3lP7X?=
 =?us-ascii?Q?GHFb+oCfIwJGlK1DJozW1R8nz3XLtrKkIwv8bLB1WlKQncCc/yLApTTOFJMn?=
 =?us-ascii?Q?urGqpa3/ISz2wmVlIXoxPUE51zHWYpbF7W8xlG+InKIFegBqL0mck8BOtCl/?=
 =?us-ascii?Q?aF3vPlmbHnJVou25MG46d8pnbGUvlmCoqYrUmEFbhAKRdQgXgVJKPZ+l1CcF?=
 =?us-ascii?Q?DGILi5MnWFQVQvt+Aa5pvDjJbrgvVietnBIwM/uOzrUMpvYypVPEh2UZzU+Q?=
 =?us-ascii?Q?HJp3EDYgCOdKlc4Sqx5pKOUuPAWGT+VGx8EEmmEgoqxGkedrThjQWlQe4By4?=
 =?us-ascii?Q?7ik5CPHOP0NpBiduBUaqiB8GuhW3gLDv7VmVX0d7Z1rJpxE6XJI/SKMYCep9?=
 =?us-ascii?Q?v8TtTttEsdxo/u9ZwRRlT0GTJhrd+OXqrP4sx+W3h4DIbEPiV56aZe5eE9Co?=
 =?us-ascii?Q?yrYaI+FjCyHknQc4YNC2LJY0IEv6+GO06LddfRpPxFOkpKjmjzYKJIVYtnX7?=
 =?us-ascii?Q?xrOyUEV0Fk64t75Ugh6K8MT0Obm9v2Et444e8jg4n+HP58/AksHjMha36slb?=
 =?us-ascii?Q?09ouBQzChSLRprM0FQkpQ6+TnYL8+pmxpkGoff2qj8IEb/0CSbF5CMmjwaC7?=
 =?us-ascii?Q?rwch01rEmcDOMbwQgVEMQdnRSxgFQKv2Nbp7O7MtZWl57ARJG6KrPgfveFAA?=
 =?us-ascii?Q?OXjJZVw7jlKExe0pXbGkNHY57n0D7sYQKk7t6NAXC1iDEpTLZYtQ4nYZx1TR?=
 =?us-ascii?Q?0TpzjM/Z2nyuUxaJeELPjPLmh8F/cGc36DrlC5M0GVZvMiw6lHPwW3QOBs95?=
 =?us-ascii?Q?Xmje6SCEydoQlQ2ZcAK94oIQLug873TIjNgNUfjVgFuTOH55VGCtW0U5a3b9?=
 =?us-ascii?Q?CF/btS2b+cncMzPJYL0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca4bbcf-74c3-4d60-1792-08dd4d1a21c5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mz4s4op6aK43zcXtvmU+H2vo2+TJaZyfV663uw1sZISOn6/UW/mYk/DmwhL9pYtG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Use iommu_free_pages() instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c          |  2 +-
 drivers/iommu/amd/io_pgtable.c    |  4 ++--
 drivers/iommu/amd/io_pgtable_v2.c |  8 ++++----
 drivers/iommu/amd/iommu.c         |  4 ++--
 drivers/iommu/intel/dmar.c        |  4 ++--
 drivers/iommu/intel/iommu.c       | 12 ++++++------
 drivers/iommu/intel/pasid.c       |  4 ++--
 drivers/iommu/iommu-pages.h       |  9 ---------
 drivers/iommu/riscv/iommu.c       |  6 +++---
 drivers/iommu/rockchip-iommu.c    |  8 ++++----
 drivers/iommu/tegra-smmu.c        | 12 ++++++------
 11 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index f47ff0e0c75f4e..73ebcb958ad864 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -955,7 +955,7 @@ static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
 {
 	if (iommu->cmd_sem)
-		iommu_free_page((void *)iommu->cmd_sem);
+		iommu_free_pages((void *)iommu->cmd_sem);
 }
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f3399087859fd1..025d8a3fe9cb78 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -153,7 +153,7 @@ static bool increase_address_space(struct amd_io_pgtable *pgtable,
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
-	iommu_free_page(pte);
+	iommu_free_pages(pte);
 
 	return ret;
 }
@@ -229,7 +229,7 @@ static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c616de2c5926ec..cce3fc9861ef77 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -121,10 +121,10 @@ static void free_pgtable(u64 *pt, int level)
 		if (level > 2)
 			free_pgtable(p, level - 1);
 		else
-			iommu_free_page(p);
+			iommu_free_pages(p);
 	}
 
-	iommu_free_page(pt);
+	iommu_free_pages(pt);
 }
 
 /* Allocate page table */
@@ -159,7 +159,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 			__npte = set_pgtable_attr(page);
 			/* pte could have been changed somewhere. */
 			if (!try_cmpxchg64(pte, &__pte, __npte))
-				iommu_free_page(page);
+				iommu_free_pages(page);
 			else if (IOMMU_PTE_PRESENT(__pte))
 				*updated = true;
 
@@ -181,7 +181,7 @@ static u64 *v2_alloc_pte(int nid, u64 *pgd, unsigned long iova,
 		if (pg_size == IOMMU_PAGE_SIZE_1G)
 			free_pgtable(__pte, end_level - 1);
 		else if (pg_size == IOMMU_PAGE_SIZE_2M)
-			iommu_free_page(__pte);
+			iommu_free_pages(__pte);
 	}
 
 	return pte;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b48a72bd7b23df..e23d104d177ad9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1812,7 +1812,7 @@ static void free_gcr3_tbl_level1(u64 *tbl)
 
 		ptr = iommu_phys_to_virt(tbl[i] & PAGE_MASK);
 
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 	}
 }
 
@@ -1845,7 +1845,7 @@ static void free_gcr3_table(struct gcr3_tbl_info *gcr3_info)
 	/* Free per device domain ID */
 	pdom_id_free(gcr3_info->domid);
 
-	iommu_free_page(gcr3_info->gcr3_tbl);
+	iommu_free_pages(gcr3_info->gcr3_tbl);
 	gcr3_info->gcr3_tbl = NULL;
 }
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 9f424acf474e94..c812c83d77da10 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1187,7 +1187,7 @@ static void free_iommu(struct intel_iommu *iommu)
 	}
 
 	if (iommu->qi) {
-		iommu_free_page(iommu->qi->desc);
+		iommu_free_pages(iommu->qi->desc);
 		kfree(iommu->qi->desc_status);
 		kfree(iommu->qi);
 	}
@@ -1714,7 +1714,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 
 	qi->desc_status = kcalloc(QI_LENGTH, sizeof(int), GFP_ATOMIC);
 	if (!qi->desc_status) {
-		iommu_free_page(qi->desc);
+		iommu_free_pages(qi->desc);
 		kfree(qi);
 		iommu->qi = NULL;
 		return -ENOMEM;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index cc46098f875b16..1e73bfa00329ae 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -571,17 +571,17 @@ static void free_context_table(struct intel_iommu *iommu)
 	for (i = 0; i < ROOT_ENTRY_NR; i++) {
 		context = iommu_context_addr(iommu, i, 0, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 
 		if (!sm_supported(iommu))
 			continue;
 
 		context = iommu_context_addr(iommu, i, 0x80, 0);
 		if (context)
-			iommu_free_page(context);
+			iommu_free_pages(context);
 	}
 
-	iommu_free_page(iommu->root_entry);
+	iommu_free_pages(iommu->root_entry);
 	iommu->root_entry = NULL;
 }
 
@@ -744,7 +744,7 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 			tmp = 0ULL;
 			if (!try_cmpxchg64(&pte->val, &tmp, pteval))
 				/* Someone else set it while we were thinking; use theirs. */
-				iommu_free_page(tmp_page);
+				iommu_free_pages(tmp_page);
 			else
 				domain_flush_cache(domain, pte, sizeof(*pte));
 		}
@@ -857,7 +857,7 @@ static void dma_pte_free_level(struct dmar_domain *domain, int level,
 		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
-			iommu_free_page(level_pte);
+			iommu_free_pages(level_pte);
 		}
 next:
 		pfn += level_size(level);
@@ -881,7 +881,7 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 
 	/* free pgd */
 	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw)) {
-		iommu_free_page(domain->pgd);
+		iommu_free_pages(domain->pgd);
 		domain->pgd = NULL;
 	}
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 00da94b1c4c907..4249f12db7fc43 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -96,7 +96,7 @@ void intel_pasid_free_table(struct device *dev)
 	max_pde = pasid_table->max_pasid >> PASID_PDE_SHIFT;
 	for (i = 0; i < max_pde; i++) {
 		table = get_pasid_table_from_pde(&dir[i]);
-		iommu_free_page(table);
+		iommu_free_pages(table);
 	}
 
 	iommu_free_pages(pasid_table->table);
@@ -160,7 +160,7 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		tmp = 0ULL;
 		if (!try_cmpxchg64(&dir[dir_index].val, &tmp,
 				   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
-			iommu_free_page(entries);
+			iommu_free_pages(entries);
 			goto retry;
 		}
 		if (!ecap_coherent(info->iommu->ecap)) {
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 88587da1782b94..fcd17b94f7b830 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -122,15 +122,6 @@ static inline void iommu_free_pages(void *virt)
 	put_page(page);
 }
 
-/**
- * iommu_free_page - free page
- * @virt: virtual address of the page to be freed.
- */
-static inline void iommu_free_page(void *virt)
-{
-	iommu_free_pages(virt);
-}
-
 /**
  * iommu_put_pages_list - free a list of pages.
  * @page: the head of the lru list to be freed.
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 1868468d018a28..4fe07343d84e61 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1105,7 +1105,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	if (freelist)
 		list_add_tail(&virt_to_page(ptr)->lru, freelist);
 	else
-		iommu_free_page(ptr);
+		iommu_free_pages(ptr);
 }
 
 static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
@@ -1148,7 +1148,7 @@ static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
 			old = pte;
 			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
 			if (cmpxchg_relaxed(ptr, old, pte) != old) {
-				iommu_free_page(addr);
+				iommu_free_pages(addr);
 				goto pte_retry;
 			}
 		}
@@ -1393,7 +1393,7 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
 					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
 	if (domain->pscid < 0) {
-		iommu_free_page(domain->pgd_root);
+		iommu_free_pages(domain->pgd_root);
 		kfree(domain);
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 323cc665c35703..798e85bd994d56 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -737,7 +737,7 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	pt_dma = dma_map_single(dma_dev, page_table, SPAGE_SIZE, DMA_TO_DEVICE);
 	if (dma_mapping_error(dma_dev, pt_dma)) {
 		dev_err(dma_dev, "DMA mapping error while allocating page table\n");
-		iommu_free_page(page_table);
+		iommu_free_pages(page_table);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1086,7 +1086,7 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	return &rk_domain->domain;
 
 err_free_dt:
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 err_free_domain:
 	kfree(rk_domain);
 
@@ -1107,13 +1107,13 @@ static void rk_iommu_domain_free(struct iommu_domain *domain)
 			u32 *page_table = phys_to_virt(pt_phys);
 			dma_unmap_single(dma_dev, pt_phys,
 					 SPAGE_SIZE, DMA_TO_DEVICE);
-			iommu_free_page(page_table);
+			iommu_free_pages(page_table);
 		}
 	}
 
 	dma_unmap_single(dma_dev, rk_domain->dt_dma,
 			 SPAGE_SIZE, DMA_TO_DEVICE);
-	iommu_free_page(rk_domain->dt);
+	iommu_free_pages(rk_domain->dt);
 
 	kfree(rk_domain);
 }
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index c134647292fb22..844682a41afa66 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -303,7 +303,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -311,7 +311,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		iommu_free_page(as->pd);
+		iommu_free_pages(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -608,14 +608,14 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
 				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
 			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
 					 DMA_TO_DEVICE);
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 			return NULL;
 		}
 
@@ -656,7 +656,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
 				 DMA_TO_DEVICE);
-		iommu_free_page(pt);
+		iommu_free_pages(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -707,7 +707,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	 */
 	if (as->pts[pde]) {
 		if (pt)
-			iommu_free_page(pt);
+			iommu_free_pages(pt);
 
 		pt = as->pts[pde];
 	}
-- 
2.43.0

