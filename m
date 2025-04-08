Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05523642B;
	Tue,  8 Apr 2025 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744133054; cv=fail; b=D/0G4mUbU7tb0E+66tWbZFwRbUNir+KaQJMRBbT4DbyIJS6Q3PTE5hZg/dU7yJwOQmCc3gC+ySYsdqPhoAcDOEnXsZte3BmgzhZBMwX4vxH5+g/z8G45iGuqfMLFu7cEsGn3fBQqE1ec+UNuoat1L8wy0/YYk86//BbdlaxoRCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744133054; c=relaxed/simple;
	bh=fpH1N7MOPmXvPixusCmIocSTIwLnF0KVihRcPVWUoK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mQ2zJyLtMIdxEL87cN2aJ8NsrMFy0qH0EI4V3Q74uo8LeAh80TWIUQQzwKifc51FP/bLuNrc2zQvIC+kGzKjSj6rAhEzgm2t4qfOc9/n46II3q5eds2py5Z2tnCI/WcXYaLOAHXlAisMH9PgHv+z1GkWAVIVpHdi12qHyQvYaA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R7Qu0EBv; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R7Qu0EBv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzFwg4jYXaswBiNb0ICzgusotL3ZehCRGKb0IXm1ghDyKzINoqfZ/jAj9J4v410Ze9FWgkkrtqfA+4cgO+QacB38AVuWpMLnj6z/LzfwQ4Xh+hSWH/oIZLndYXPqRE9hV9gJXrzACb7YRE6Tw3yltqmzztQcYatiu2dsRwsnYxGzdXiYDF2hVxnmopaCKB0pvCfTlf6WdbsWll9r0oVSHgBAdvfg0XMedxHy2DFBODd6dU5Kr5mrSERjHX5JbasMnqB3iFmdN14+SKi3XidmpIpj2kGHCsu4jG8l8adGA7o+9BUpNc92pRh2B6eu3uxYMY43ngvqKOd+WhPGnhHvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=caiBHoyegwy6z6WxYqqWu8RtzzMsX7j/TsfBRoWwxdQ=;
 b=UsfS1I1Zh/25DrDdWrrHz60QFOfaXxWUc2Wa8jEeOgv4fWFDw4/QTyuj3E1/y9XyBeGXs6XPkgIVooLoBffVRFmtIEZyLuWKbDu0xvYUsj3TOG4c3hnKJW64vajKEcZSDMtnWaHEK7R0mc96gZLmvZ4kYwt+rNWzgvpeqa0IBFYwXbiDyJ+O9dK8y6hdNZj71dHvDiIDuwb6Ecz3C/KIijZiTKSQU8o6plFSp8y/sJRh0YwTS2YfKg9uA0pt6eqxO21casESYYKp4VVMdFFUrJVtNW66I5MtzTmARZKdjVc9914+O7jzhG/tBy+72Lf0iY+weHkTgSkZSwPEC6VBCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caiBHoyegwy6z6WxYqqWu8RtzzMsX7j/TsfBRoWwxdQ=;
 b=R7Qu0EBvKzWmIeYBqYIh6lzCSVw5KorS1F6fWpY/6WBx9NG+PBtGD1b9iL8krWlCYkGOgoChD7zu3yJ+VK0WEW1Ru/ogx0l4HKOIoDAchanvtzKdS12yZtHvlr+wSw0ppYhBoRjV8KBA+0TMzBWtGeF/Xs5sS/zk78tUBu3gffpRyxyy8Bea3QqAsWBRu7TE3f1U0O5OEqfIaNt8oSGxi0tn+YgUmqtTlRiE+7/kMYausA/4RPPXG5op+QTLUmoda8YPbAUDptt7biVotxsUUL/eHcg3GDCr2omoP0SEHspB4DscG4weJG89D5RhEv4jk9lfEhlg61wy44JgtpKNyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9579.namprd12.prod.outlook.com (2603:10b6:930:10a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 17:24:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 17:24:08 +0000
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
Subject: [PATCH v4 22/23] iommu/amd: Use iommu_alloc_pages_node_sz() for the IRT
Date: Tue,  8 Apr 2025 13:54:10 -0300
Message-ID: <22-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0293.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9579:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f324c6e-e56e-4a83-ce57-08dd76c22aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x5sOXYXmxv4KPnl4CsYkbwNLdwLPPNaX3vgpYAQ/SiCUR98SDpYTdgJ3NjdV?=
 =?us-ascii?Q?GmpZyEQRjXflG8oLyE8oyBEsRntrNjlb7649SfhnUa+Yn9sdcarco+532YcD?=
 =?us-ascii?Q?/bvUzBohRSehhNbyEHTdJmh0CK/lC4/2WhpTWRdMBfilKN97dv3oEmy8Svmp?=
 =?us-ascii?Q?YbFXtTGoR0JkH2/pFgoy2Z4lnWCaM6Ev9Irc5ocIeK41f2kNTMaVjuboY3wO?=
 =?us-ascii?Q?Sl8p/qquBcS8HrqAVw7HFZwj1MiQfCrpUbjy/FX/BDewWyN8NhBG7Ko62Sou?=
 =?us-ascii?Q?I4UOu2+hMQRkL2MHDnFyxIW4vHUooQVyoTb8GDPxUBzpkqbtfRPNVnMxpK93?=
 =?us-ascii?Q?+sJaFuU4KHNK6eVQO9/vG+QqjuzD6QW2pDprq1gjidGEXyf5b0e/65jhpLpy?=
 =?us-ascii?Q?sP/ZDLrX8VraWLdcUQ5j4VSrb9ZDb0cqKOGE4w2BrDuKpEqyrzX7fDfWexYk?=
 =?us-ascii?Q?aH2ZmcgFHMqYMeOmQKFKyAHmkKZqpXqGu2o3QXGdw8dYioLUecQx9phv2F8J?=
 =?us-ascii?Q?QDkx8WYPgE/R3eCuxb9Hr25CEcOiL44PjmBrMtJuvuNYc1JXl/wqr0tehZqT?=
 =?us-ascii?Q?fXVRp4D6r/IUMJx868jWxJYeFAnuHUdLhq04/NlgaZj3vrkFpA+Nqfi0LvC3?=
 =?us-ascii?Q?Qh9Xi3XXYbF6CbSl7RGipmASsM2UBmlcSFL4GF0RQyFkBf4qDhkjOC+Ilexb?=
 =?us-ascii?Q?MQcHN8wayx+7whlizUkFxTdP5Hv+YqxWfhd3qIW+S41siYFaK01/SmbBtSd0?=
 =?us-ascii?Q?P2ia+Mkw4iziSfkwSYaZjzgx3h3VvzoMMXIKy/IbxvxrZa8h6NXcLCbv/jO6?=
 =?us-ascii?Q?08eogzphAawGnbJRQtL/6XgEyl8G88rHxSWkFkfZyNxgXUTk7qNd5age2aXC?=
 =?us-ascii?Q?aVaLeWxTiV+0RmYz2lpH9UAFkB3faxoln61pO3HgxsiIozKlpv15urQtDMTQ?=
 =?us-ascii?Q?ubm1S4/GzMb7ZsWAwKaojddnt+6bbWPqAb3uDg6Vwiow4hMesYuTXTiTQO2Q?=
 =?us-ascii?Q?C90gqSj9OKf0hSEkyb/Lb2goaVDUvAg58/GOl2shQx+4WGX+eNwYCZCaitX8?=
 =?us-ascii?Q?oa3Eyp2+aU4SKz+EeGiJZS9aVUw5vbJG6gbCC1vFeH/jmEGu1n+zBc5l30r2?=
 =?us-ascii?Q?my3lWDocc0kBLlZJq3H4Z2ljOF+EgDnkHct3/CMGb0dhwtx5GKcyAvp6pM1q?=
 =?us-ascii?Q?/hj7aEbPGnpOcYoe9FBXaZh0xChKys6MBRUr6YwrahyfQ6tg9XBQ6FWiEiGr?=
 =?us-ascii?Q?u4nBx0weQ0AxrjGszQ1LH9ehpWioidgjLxa3n4+zV4Ncd/T3tjZfEJyFO8Yo?=
 =?us-ascii?Q?kro0oQq6uC5Z3Izhfqwn/CaC0w7xBQnHy+Xh7gUByAHOJ+LBeJl0q1n5b9c+?=
 =?us-ascii?Q?k96s5UMrSC8UXPhAPnE4v+UCzynW128FSN6Gj9E8+mTq7i4EAJoJYX7bGvPv?=
 =?us-ascii?Q?5NShZ8RC1AswyDpWICm/kfKgsooGR6rgnZbI4Pdv9S7QEoYdUOQsDQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y4Z2Jha5rcseWKifJfpcaEt7c6IZ/qAUnfI21dT5bSCpRf2GDrQraZIG/9IH?=
 =?us-ascii?Q?wJTyPMqi/J2jvkY2/iOxnz4Ut0PUUwpd5MI3lQM3LQQzo4CHG3LV1PIH4IWB?=
 =?us-ascii?Q?LfEQm/DdOIQA3VWa9kXgGdzvgz51NroDbcUuhT3TRkJ/umJ6Kkg8S/Ctz+6A?=
 =?us-ascii?Q?Vg0mH5tWqqj+FlZPkGD/B0/NdsznhmYImGb6I/5V+4GcyTZepwh3HGHfZki/?=
 =?us-ascii?Q?L3STfYIQvzjWv29GuySXKFMYTGky+Bt3vo+hCFrTtvoos3s2DnzJK+/mdy0T?=
 =?us-ascii?Q?qMnFmUBGF+L9oVZEN0Kv6lucrOjC4TgOKTE3ypfz6JtrSX3eTYwxSXCowu/X?=
 =?us-ascii?Q?AOmA38GVR2Sj6ij6RWiVPOpdzyWokrQ2gPq0xS9osglw6/rWux2rVKkUM4pn?=
 =?us-ascii?Q?yWdWktrgoj+IcqfCrwGEv8wR4AaVpjuXY6jz4ioXtm2Xl1IYUAxVWFfj6weB?=
 =?us-ascii?Q?bJcrOsYtNIx4McXh3LhXbsrJZTbC3AE/TMZAcqN50wBV0DUeHOBXYGoByigz?=
 =?us-ascii?Q?5ACornqk0PlJtGUbj8hG7XrdTssEWrv4ku5n8tVuKcGEIz7ht1F5XV6GrEB4?=
 =?us-ascii?Q?ioCeOqtFGZA2wNOVNs1PVn4r+7b4+56uKuWuI2F74m5NJPGSoB+N2UvrrPIk?=
 =?us-ascii?Q?bKtLMb9ku7BfxDoME72F3XVkUukCIxSbrVvLjcVlYmvbBvxSCeNkjaV6GmfZ?=
 =?us-ascii?Q?CCO6+OJCLrRFDmxVUH4PQ7trGHhyNEmVU+AhjBXo1um8rwZTFim6Q7fAVP99?=
 =?us-ascii?Q?36C5xSUlDKupcl25AGIE5Cx++Pcz573rHiwpte008oSZvu2GRPZuASgYBygH?=
 =?us-ascii?Q?hcRoJZk3d8anIE11XnXuXLy3xbvBL6Yv9dQ6cGStRymCUX1cjRggpz/RmFDm?=
 =?us-ascii?Q?3fqqb/359ymfRgSMCS/W8HZ133pnaeit6SPPQt3TnnLARDtslfkNI0cg844n?=
 =?us-ascii?Q?b+XhPtLnxieNBJxR4bD8nvN9srvQW2XQtF2/6xQMmFML5kR4Ko+CuIO7pfut?=
 =?us-ascii?Q?POqS/oml0HOu2Rv/L8SU6Z1sHjS1rYCt/0HyXi1P/5n0e/fdwf4ol0j3SDUd?=
 =?us-ascii?Q?STYd0yVSeWWjE60QjPhmNLDV2C4IyDo6Xxlx1L9dUolxevjZgkK1MufK+N7C?=
 =?us-ascii?Q?qufXMUp4laf1FqS4Fm9Be2jsbZ88Sj6gtZLyknYKDGv/GuiuZjcZVqp2hz9H?=
 =?us-ascii?Q?KLdDMt78DkH/5u2CnFYNCdgSqffrtrEKN4acvwm2mPFUDK9zLZ+BfXycmDFM?=
 =?us-ascii?Q?fn5YUcJm7opc7lEAzMoNUeDTrp/ee/hR9Z4pnqk0bMQLJRdz+IpSifI+4QmO?=
 =?us-ascii?Q?KdZS9Is0FnbbzKZSU1J8si4uKmUYsnWkWH4Ym7ebfgrfS1CEFJcfYw9167F0?=
 =?us-ascii?Q?vLpyAvhdSPmjva1mWe2tSs59E8nQ98vW1BF7EFX8aiSmhSCMqVJ3wDuf8P12?=
 =?us-ascii?Q?43A04ONUwC2TC+fidr2azN30IS2OloiDP7vv5G1X9atyzZ3rqYyp7LXw1aLs?=
 =?us-ascii?Q?vIUOIvcuC8TePey1b/g1+k3/LjSyF5b7RAruZ/6x3X8vek0q2iKi3ZQhT2Lz?=
 =?us-ascii?Q?n1QCIGR4gxPTKw7ApFzWHtHnz7f5/7HlHbWw0Bmj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f324c6e-e56e-4a83-ce57-08dd76c22aed
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 17:24:07.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wDf8WeT+lzc+JHX5sS9B7RiV+mH9ym4UEB6IyVgOOZUs0oRCaOVNekkjX4Vp/te
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9579

Use the actual size of the irq_table allocation, limiting to 128 due to
the HW alignment needs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 1 +
 drivers/iommu/amd/iommu.c           | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 5ea73f08b38801..bc9f0bbf3c0864 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -314,6 +314,7 @@
 #define DTE_IRQ_REMAP_INTCTL    (2ULL << 60)
 #define DTE_IRQ_REMAP_ENABLE    1ULL
 
+#define DTE_INTTAB_ALIGNMENT    128
 #define DTE_INTTABLEN_MASK      (0xfULL << 1)
 #define DTE_INTTABLEN_VALUE_512 9ULL
 #define DTE_INTTABLEN_512       (DTE_INTTABLEN_VALUE_512 << 1)
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index ed04d1471c2428..dea0fed7abb044 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3129,7 +3129,7 @@ static struct irq_remap_table *get_irq_table(struct amd_iommu *iommu, u16 devid)
 	return table;
 }
 
-static struct irq_remap_table *__alloc_irq_table(int nid, int order)
+static struct irq_remap_table *__alloc_irq_table(int nid, size_t size)
 {
 	struct irq_remap_table *table;
 
@@ -3137,7 +3137,8 @@ static struct irq_remap_table *__alloc_irq_table(int nid, int order)
 	if (!table)
 		return NULL;
 
-	table->table = iommu_alloc_pages_node(nid, GFP_KERNEL, order);
+	table->table = iommu_alloc_pages_node_sz(
+		nid, GFP_KERNEL, max(DTE_INTTAB_ALIGNMENT, size));
 	if (!table->table) {
 		kfree(table);
 		return NULL;
@@ -3191,7 +3192,6 @@ static struct irq_remap_table *alloc_irq_table(struct amd_iommu *iommu,
 	struct irq_remap_table *new_table = NULL;
 	struct amd_iommu_pci_seg *pci_seg;
 	unsigned long flags;
-	int order = get_order(get_irq_table_size(max_irqs));
 	int nid = iommu && iommu->dev ? dev_to_node(&iommu->dev->dev) : NUMA_NO_NODE;
 	u16 alias;
 
@@ -3211,7 +3211,7 @@ static struct irq_remap_table *alloc_irq_table(struct amd_iommu *iommu,
 	spin_unlock_irqrestore(&iommu_table_lock, flags);
 
 	/* Nothing there yet, allocate new irq remapping table */
-	new_table = __alloc_irq_table(nid, order);
+	new_table = __alloc_irq_table(nid, get_irq_table_size(max_irqs));
 	if (!new_table)
 		return NULL;
 
-- 
2.43.0

