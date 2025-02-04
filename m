Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910FD219A67;
	Tue,  4 Feb 2025 18:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694125; cv=fail; b=RmuoJ9LX1KXrGDnTl3oaHKzDOWRgS+U0CcC/uLlAnQ3Uj9/rX2UdxgR7RBAUAqe5vyu4PHxXWsNcgv9+BIeJHwVz3kQrDuEmWDwxw8b1RgCh82NxLwltfECv+f449gjsTxm5q4ls9jI65rYrB8pkb2D/LJ/hYl8TElrcnI8Hzrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694125; c=relaxed/simple;
	bh=opJZ2On7gk2B03I1BF85F/GJe9mH0uSxyygkOkJrMNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kvTnRu9ziEl8psCC+QIeZE1RHNff+zIg7brW3OFR2hci1nW0joR6KJZfkwHwrfeCT90hBvQLhyxrt8lPJTEo15JSdsmMOkJUcJVIVdK4LNkCnKRlu2DOx8MANzUqsXMGeH8Nysph2On4h6d4vfomIGbyJEHsHXsm3NEeQai6Ces=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eSVUifI3; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eSVUifI3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKgxTKgBpVEdQlFtWQ4oMIMbFH2sBcGjWCKUyVINXY4NuKl70z8xnstt92Q3nIHcjB5N2dVpGzxywGPWgrg3inLmTz0cOB2t27gcD67kH9wmaBynFL+AWp5HHfeYmnj93Ih2R6Cq50eGK8QJuRn3t+W09rzFsI09OXCPwhvvyz4B8MPOD3AmYkOYmdD/NjGpn2yu/wv/gCA5qLnyZIHshUc+U3jfBa1cuX59OfWCljQG/S7BtmvaLOF6ihk6gCcOPhF7h1qdcKrh3GtxwfrPAA4FoYwk1rJQqaZhVPiZXo7cmL+L1PaA8sBhghLKo1ImriFOvM81ikSdCipCQPrUJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWy+iynyAZGjLuuwdsRFJXiTwGrNk2KhWIWJj7ear5c=;
 b=b77zQ9XJptLTkttOi6f2IXiGX2c1xhA7rRC1X7pbvfmEwECDwLAn9CVpYZzyZOk8Mw4Df8xYnb6ge3kR1O7ZO8bcMLh3AesK3aEbc5YAj7B9lZ8ypNXsr+2tYIa4k795ov0IUI2/CePwifNDcPbt8TDAdT71Gjtj2o/p/ptruPWSvlHOrqI7hJssQrgdSpZBhR14zHuiewsRhVc71qwMfIYed/lUYFa4+8C0fzeMZIuTNVRnAgaUrducYJ2inB0tWhQVNotphxJJtKZYDbBYAw1m6KiIOKdw/dZs4gOOgFzt5FFBQaxV+gSBj0L1Ole7slpukvPVH9MlYWvetQKxoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWy+iynyAZGjLuuwdsRFJXiTwGrNk2KhWIWJj7ear5c=;
 b=eSVUifI34/kfXA218smttLb4NyTjOKzkE3GsaZKOoCLfrkiSUvYiFzDG2HoJJKkYMzS1cLv+xxE2gbnnS8lSkzubxbXwS28NUGr90BhWSCY1MZYz3K4Ce0Qd6HZaYKoQsbvIDw9NRQ22NXc9I49AkvvVJ4i/hZ5RdKuXT23w1erzi0+r1FlWtO2PqHDSJK55yrnkWKTcxZjsfiSzaYPNyOG0zqZ8rADp3CnRXdlGLquqYKTcwZYSTKfPmuOOqiNkCywZpw/my+3AiG8SDWA+vpcEG3RoIo/tI8VA0v0CRGRNFbV1b35qY7mtPtE7m1YH27vkQq3zWxljuNfSEoeSSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:10 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:10 +0000
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
Subject: [PATCH 05/19] iommu/pages: Replace iommu_free_pages() with iommu_free_page()
Date: Tue,  4 Feb 2025 14:34:46 -0400
Message-ID: <5-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0007.namprd15.prod.outlook.com
 (2603:10b6:207:17::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 52dcdfd7-16d9-499e-881c-08dd454aa462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DCHa7JgOWURzIaqxV+EP+qxc9gtnQ2q3OnfPI4XPft9n1Q8fnaClEHIC7V3Y?=
 =?us-ascii?Q?P8OTeQ/i0wvrdTL/il/xQts2udT2HcvnlehnijeCKy9fiwcnLlXWoq8XiDdq?=
 =?us-ascii?Q?M4F2u/FNuE5bThu1dPmiKoOB8jJdpStDN/0ezBjjOSjMYetdlm9DSNdawRHq?=
 =?us-ascii?Q?vpTwrwdovdJrtcZFYsSa4Tgg31kW7XYriWuZiOPUrmQyAQ/WfVOnTyGcndHv?=
 =?us-ascii?Q?hOZ2+C8u6WIK2/zCZIgugc+sAlFcSkY3o7Ig+W2eaOhZIYGzlLR17wvCU8cn?=
 =?us-ascii?Q?JDtsGWLQtVhzRRHluohahBqkVoCvj5nP9rI9gQfIL0zz58Plxc8dzAipiEiE?=
 =?us-ascii?Q?Oje042s6wdZJmRy+qJCLkOf2lzldNHwTxdG9G/K86btsBCXleUHlmbs0i7Ma?=
 =?us-ascii?Q?k9G38n6G+HsqAiTuSlTi8b6NSuNNXpFXC6zp93oIcpJhhxrOC37gxFXn/m1b?=
 =?us-ascii?Q?A4SNoF/0qL1ZOC9N65mBomtJ8DqzzJ7o+OmDpxcZ8WVg43EFStajDC5hUue8?=
 =?us-ascii?Q?sR17AnETBO12X0e9g7/1qVfeGI1D6knkA/2tUpJjPHvnse5RHFBszDUHcNQd?=
 =?us-ascii?Q?xvGbIiUS5eakqx5iRrh7iBrz02NgdIWKBsIrGWxW/5tpAzF7kXxDjrv97E6V?=
 =?us-ascii?Q?8TT8XBLGoIg+S9iUvVO92wGTiExctLBwyEuEa0zy9N05iQNVOMmSw/LGtRbY?=
 =?us-ascii?Q?JT/UWzJFHPRfVuiJCyxnr+uGhapvcjdofM6vTIWu3ZGAOgjOOQTMVSNzDRyf?=
 =?us-ascii?Q?rgQ5Szy/evaDsUrGKLFuBtIUijpTqx2Cg44uWSL5PPdKIBx4cvb74LZVMnLO?=
 =?us-ascii?Q?i3tI9fOyqKyAGKrFZpppi0m3f4Y6WmIwm4yY2Siu/8V6EWbmhx9x4Hfffv/o?=
 =?us-ascii?Q?Ji3Fu5q+L+mFe0mvdLX6wCdZt49VFR4KsM8NBCVblfAHvExHvk7PK+uVWVW0?=
 =?us-ascii?Q?JvYFMVY3LamIzrcnLF4wYkOseGE01tO+9htHI5cnP492Ci+/qUZjGd8wfAlw?=
 =?us-ascii?Q?+vsT8szMBf2/WNPRpnSS639bbLu0YgVPRfAuuReAWo19YAYD8m1+11bhhmGm?=
 =?us-ascii?Q?nEo2Aub1MSc/jOcLxysdBAa+PxP8fWWwvurikJUwnCfP5asubKR5CY4/JaPS?=
 =?us-ascii?Q?yrlTRDGfQ1UYXqYx7BVfJEpBpj4VY/35ARASi1ymqjgWv9PvYWhZ/7Zcxwyh?=
 =?us-ascii?Q?X28KLjhzlPxzf7lHxNEQogQyFOreXgmz13lhc7hQIaB2PUMBDmvp8pyR7khj?=
 =?us-ascii?Q?4ZAgLgCDOTQUTkGG7I1fjNvqVJMM5GGkRhEkY8ClO7c/PVsR2aP74fbN7WBV?=
 =?us-ascii?Q?oSCIilq5xJJoVyy3GL3eL/GyDMNbiVtEyewgyEIRdFFAHoX3SkTF7qGsKKeA?=
 =?us-ascii?Q?thIZFhWTNUsWW21/l4H1N/TCwf5ZNejSEwcndk9GZkgsJ6I8hn171ocAwlCT?=
 =?us-ascii?Q?c6sBGiRr34g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FvHCssO21TJjeiiXOTlZQac6cog8yHOMqz3PFum64KoARQsacbuEZZkEXYoV?=
 =?us-ascii?Q?da0SzMXW8pRfc/7ujtLuyEwsyPSvamDgFcFPMo2A2l18V1rIJrBIOtKo3qtS?=
 =?us-ascii?Q?OydBXBOzfB3Jqy4ilk4UpQ7ZtCuB60cJqaaqhSwIS/VStLHjrQCAY1YqMcTx?=
 =?us-ascii?Q?1DkWc8yEX9J34W2HgKeSn958yth5vt7VGTcPry5PYz63jzEqsLVfWvW0agGL?=
 =?us-ascii?Q?6GFyCW1KIL/e/Ncqna17Qiux+ZBxrgI5Mik0JS25gM+wC3OfQvbYrTJMoow0?=
 =?us-ascii?Q?lmng87+OTGA2DpBqNkppItP/N7u3vFNRQijwTDhooFwqTGG0Q7Xj+uJO2Jht?=
 =?us-ascii?Q?LkxDSfIdk1wBkH2gPQ/WbzoHaBMSK3JH71msXZMReYHhqERNyuVBekO1y3Rt?=
 =?us-ascii?Q?tklYcI2FC2WJATmbeMzJl/tVEm8rE7Inu163f0iNTKJaWxPxAEuFLXh4P4z8?=
 =?us-ascii?Q?2cokkapXV8A7+liLemKrwaYoFXpe1KauNVlUA6yjim8Znn0GK1+03t5aM21s?=
 =?us-ascii?Q?dC3Kgptkvw9PiuJC8TId5G8wMa91Ws/qujzPF9DvZjSkqELZQg31U90W4Rj3?=
 =?us-ascii?Q?yXptXvr4GG7qNxL1ngkTCjTxNtlrvqoI/XA65H78SyTt3OEloUsh2lRk5MiJ?=
 =?us-ascii?Q?2asl4SUaJTP8zr1nFFJ+W34I65pidfI3PJSsZjZuCr8Sf2VhkphhhFtg1PWu?=
 =?us-ascii?Q?WRbmG4DhMQP3okNjzWIjXwZXRI9FVsEcxZyjhn9mPgL/Mf9VV2vBZMoBjMrI?=
 =?us-ascii?Q?rgszc1CdfbB2IAEiprj3yJgDhvyEx0IqDQfyclPda3tJR2LH3MAnDTR9XZqn?=
 =?us-ascii?Q?2caXZH/6TcO9Qf+gnSsQ6gg14lsdDTTyTqe4cxYUtVlgg4kzV/WlhUocoEB3?=
 =?us-ascii?Q?dfzAz0lBSU6544+wOiTyIAHwMkjM+idlX0W0cmpZbUO5YH5X60QxvnaaDNiD?=
 =?us-ascii?Q?FvGF1hA4NVMnNERoBmI81uXSN5Mr68dFJXaZgT81i7C7mO7gxTjqEimNYPP4?=
 =?us-ascii?Q?P/9cwWqk/FbQ4W676SxRjYeXBKqYO6QkIf4anYTviGnvYGhkVX/THeKUGO0u?=
 =?us-ascii?Q?oshE1FEPsQpDMOPRNe9GX1VuJCNqw6wTxxGPjyHcSRECVA1IdTIdzj5rVQdX?=
 =?us-ascii?Q?Q5las1JYUTzZlQQUTszdQ7JLIp32iOv1++ao0WKp25OYZT8lfum3MvkUGlRg?=
 =?us-ascii?Q?b54EWwdtYP5t7PzBRIhZG9UVrtXC4+RTJ+5Z2DeRHgA1XtObCYvS/bOg2z0V?=
 =?us-ascii?Q?3I3uMpmexqDZo3uzy0+k2cAUVDAh15CEXyaxotjFmsxnnHzHMwkPQR06K6fL?=
 =?us-ascii?Q?DbOhgZNti4Te7OtL7/dg6OYvOjABNGENmpBgT7s0e0BJLUp3RGqQ2G18/+ye?=
 =?us-ascii?Q?aLnWxmblS/sm1B24iZQYCuKKreV8NmvTI4oju0y0BaB9dtQIBeO4AuxE0Td/?=
 =?us-ascii?Q?Oq4ZSqOO9Zs/CV+a60ox94T1uf1sPBFsbbK7IbMSMxlbcJJV7wWQjQDaCqfR?=
 =?us-ascii?Q?S55kOcBSRzU9QP1eNvb3iZtjn0gzj0mxRdoZGCXH6GwS6GBpi+wf5Eig5z/y?=
 =?us-ascii?Q?M4lmsKy8m52Is+niluk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52dcdfd7-16d9-499e-881c-08dd454aa462
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:04.6806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4amCMH1pKQueZCo+NDHlYKYU1PW84wmCz4HapYoKqw9PwvZK0zFbb0sRk9G91Ad
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Now that we have a folio under the allocation iommu_free_page() can know
the order of the original allocation and do the correct thing to free it.

Callers no longer need to pass in the allocation order to the free
function. Just use iommu_free_page() everywhere.

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
 drivers/iommu/iommu-pages.h         | 14 ++------------
 drivers/iommu/riscv/iommu.c         |  6 ++----
 drivers/iommu/sun50i-iommu.c        |  2 +-
 12 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index c5cd92edada061..f1c5041647173c 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -653,8 +653,7 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table,
-			 get_order(pci_seg->dev_table_size));
+	iommu_free_page(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -671,8 +670,7 @@ static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->rlookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_page(pci_seg->rlookup_table);
 	pci_seg->rlookup_table = NULL;
 }
 
@@ -691,8 +689,7 @@ static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_se
 static inline void free_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	kmemleak_free(pci_seg->irq_lookup_table);
-	iommu_free_pages(pci_seg->irq_lookup_table,
-			 get_order(pci_seg->rlookup_table_size));
+	iommu_free_page(pci_seg->irq_lookup_table);
 	pci_seg->irq_lookup_table = NULL;
 }
 
@@ -716,8 +713,7 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 
 static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->alias_table,
-			 get_order(pci_seg->alias_table_size));
+	iommu_free_page(pci_seg->alias_table);
 	pci_seg->alias_table = NULL;
 }
 
@@ -826,7 +822,7 @@ static void iommu_disable_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	iommu_free_page(iommu->cmd_buf);
 }
 
 void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
@@ -838,7 +834,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 	if (buf &&
 	    check_feature(FEATURE_SNP) &&
 	    set_memory_4k((unsigned long)buf, (1 << order))) {
-		iommu_free_pages(buf, order);
+		iommu_free_page(buf);
 		buf = NULL;
 	}
 
@@ -882,14 +878,14 @@ static void iommu_disable_event_buffer(struct amd_iommu *iommu)
 
 static void __init free_event_buffer(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+	iommu_free_page(iommu->evt_buf);
 }
 
 static void free_ga_log(struct amd_iommu *iommu)
 {
 #ifdef CONFIG_IRQ_REMAP
-	iommu_free_pages(iommu->ga_log, get_order(GA_LOG_SIZE));
-	iommu_free_pages(iommu->ga_log_tail, get_order(8));
+	iommu_free_page(iommu->ga_log);
+	iommu_free_page(iommu->ga_log_tail);
 #endif
 }
 
@@ -2781,8 +2777,7 @@ static void early_enable_iommus(void)
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy,
-						 get_order(pci_seg->dev_table_size));
+				iommu_free_page(pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2795,8 +2790,7 @@ static void early_enable_iommus(void)
 		pr_info("Copied DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
-			iommu_free_pages(pci_seg->dev_table,
-					 get_order(pci_seg->dev_table_size));
+			iommu_free_page(pci_seg->dev_table);
 			pci_seg->dev_table = pci_seg->old_dev_tbl_cpy;
 		}
 
diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 7c67d69f0b8cad..0a7c32ab841707 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -48,7 +48,7 @@ void amd_iommu_enable_ppr_log(struct amd_iommu *iommu)
 
 void __init amd_iommu_free_ppr_log(struct amd_iommu *iommu)
 {
-	iommu_free_pages(iommu->ppr_log, get_order(PPR_LOG_SIZE));
+	iommu_free_page(iommu->ppr_log);
 }
 
 /*
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c666ecab955d21..3c64fcdde6d294 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -932,9 +932,9 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	return &domain->domain;
 
 err_lv2ent:
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_page(domain->lv2entcnt);
 err_counter:
-	iommu_free_pages(domain->pgtable, 2);
+	iommu_free_page(domain->pgtable);
 err_pgtable:
 	kfree(domain);
 	return NULL;
@@ -975,8 +975,8 @@ static void exynos_iommu_domain_free(struct iommu_domain *iommu_domain)
 					phys_to_virt(base));
 		}
 
-	iommu_free_pages(domain->pgtable, 2);
-	iommu_free_pages(domain->lv2entcnt, 1);
+	iommu_free_page(domain->pgtable);
+	iommu_free_page(domain->lv2entcnt);
 	kfree(domain);
 }
 
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index ad795c772f21b5..31a170501d2410 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -620,7 +620,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 out_free_bitmap:
 	bitmap_free(bitmap);
 out_free_pages:
-	iommu_free_pages(ir_table_base, INTR_REMAP_PAGE_ORDER);
+	iommu_free_page(ir_table_base);
 out_free_table:
 	kfree(ir_table);
 
@@ -641,7 +641,7 @@ static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 			irq_domain_free_fwnode(fn);
 			iommu->ir_domain = NULL;
 		}
-		iommu_free_pages(iommu->ir_table->base, INTR_REMAP_PAGE_ORDER);
+		iommu_free_page(iommu->ir_table->base);
 		bitmap_free(iommu->ir_table->bitmap);
 		kfree(iommu->ir_table);
 		iommu->ir_table = NULL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb59a7d35958f5..88070bb7f9b093 100644
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
+	iommu_free_page(pasid_table->table);
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
index c2d792db52c3e2..8620327b64394b 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -338,7 +338,7 @@ int intel_iommu_enable_prq(struct intel_iommu *iommu)
 	dmar_free_hwirq(irq);
 	iommu->pr_irq = 0;
 free_prq:
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_page(iommu->prq);
 	iommu->prq = NULL;
 
 	return ret;
@@ -361,7 +361,7 @@ int intel_iommu_finish_prq(struct intel_iommu *iommu)
 		iommu->iopf_queue = NULL;
 	}
 
-	iommu_free_pages(iommu->prq, PRQ_ORDER);
+	iommu_free_page(iommu->prq);
 	iommu->prq = NULL;
 
 	return 0;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 7632c80edea63a..b4c3729076376b 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -300,7 +300,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, order);
+		iommu_free_page(pages);
 
 	return NULL;
 }
@@ -316,7 +316,7 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 	if (cfg->free)
 		cfg->free(cookie, pages, size);
 	else
-		iommu_free_pages(pages, get_order(size));
+		iommu_free_page(pages);
 }
 
 static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index c004640640ee50..f7b939d4b7d0b9 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -262,7 +262,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 		pte = dart_install_table(cptep, ptep, 0, data);
 		if (pte)
-			iommu_free_pages(cptep, get_order(tblsz));
+			iommu_free_page(cptep);
 
 		/* L2 table is present (now) */
 		pte = READ_ONCE(*ptep);
@@ -423,8 +423,7 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 
 out_free_data:
 	while (--i >= 0) {
-		iommu_free_pages(data->pgd[i],
-				 get_order(DART_GRANULE(data)));
+		iommu_free_page(data->pgd[i]);
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
+				iommu_free_page(iopte_deref(pte, data));
 		}
-		iommu_free_pages(data->pgd[i], order);
+		iommu_free_page(data->pgd[i]);
 	}
 
 	kfree(data);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 26b91940bdc146..b15e0f85b3f739 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -105,11 +105,10 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 }
 
 /**
- * iommu_free_pages - free page of a given order
+ * iommu_free_page - free page of any  order
  * @virt: virtual address of the page to be freed.
- * @order: page order
  */
-static inline void iommu_free_pages(void *virt, int order)
+static inline void iommu_free_page(void *virt)
 {
 	struct page *page;
 
@@ -121,15 +120,6 @@ static inline void iommu_free_pages(void *virt, int order)
 	put_page(page);
 }
 
-/**
- * iommu_free_page - free page
- * @virt: virtual address of the page to be freed.
- */
-static inline void iommu_free_page(void *virt)
-{
-	iommu_free_pages(virt, 0);
-}
-
 /**
  * iommu_put_pages_list - free a list of pages.
  * @page: the head of the lru list to be freed.
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8f049d4a0e2cb8..6e7df7273426da 100644
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
+	iommu_free_page(devres->addr);
 }
 
 static int riscv_iommu_devres_pages_match(struct device *dev, void *res, void *p)
@@ -80,12 +79,11 @@ static void *riscv_iommu_get_pages(struct riscv_iommu_device *iommu, int order)
 			      sizeof(struct riscv_iommu_devres), GFP_KERNEL);
 
 	if (unlikely(!devres)) {
-		iommu_free_pages(addr, order);
+		iommu_free_page(addr);
 		return NULL;
 	}
 
 	devres->addr = addr;
-	devres->order = order;
 
 	devres_add(iommu->dev, devres);
 
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 8d8f11854676c0..3d77aed8507373 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -713,7 +713,7 @@ static void sun50i_iommu_domain_free(struct iommu_domain *domain)
 {
 	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
 
-	iommu_free_pages(sun50i_domain->dt, get_order(DT_SIZE));
+	iommu_free_page(sun50i_domain->dt);
 	sun50i_domain->dt = NULL;
 
 	kfree(sun50i_domain);
-- 
2.43.0

