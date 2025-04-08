Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A83232364;
	Tue,  8 Apr 2025 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744133053; cv=fail; b=GguxiBmeypqRuXKkeOG0B2v0Iz5EHYKbZmhoCR8r5Tyb1ikJOYGc5UGkzfcO9U3szms8oQfpVxcD0KqXWL1afnu7rHWaNPRmKruLtNsmBc9fnQeTDgF5/MK6rSUTxSM47wxoHv7bG3Wh7zDMZTBZRLmMgkjXPBC2D8ZQDUYa1Rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744133053; c=relaxed/simple;
	bh=jECmLwFa6zjvAYsf3UU5ilIBxXN9oh1pb+RFy6znKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s08o9ZfyAzJC49ma2Pz9E1IFu/q/GMdDZwmJtB2OLeznC/fmvePF37vsRQkGrdkUjkfDWziQ2imo5PqeW+HdDl02YB5rci6AXfKH2rJe/sW2h+oKasx2Ajydh/QGYCzRxiu/sQTtcd8D99AWkdprZ/HpVugtZI/T6YhCAguWBXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hzrLUX2l; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hzrLUX2l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4iW8O5YtkTRKuz5fwIq2JOCdzbBFV/q+7iDQH6FbvBoxcIKgflr9KOLXDHjKTc4XhHIB7ifmT3F72HASEhPgUn6dd1hv5fmg2AsNWeHsxzww00h/2DMNVx3SeGmceC/4BthjxFsYlC4tphWT0fSCChY6kdqUdFDPUcqYfgVc1h0RkVo73ETXZw/pTBFzx+fzkRL3eZeRntVvQalp6hwsN2A8cAzmktyYs6VpqzaujbW+aARgV8AKb5s45HGK06l3Y8Qhya0yUWkDfQdvzIJjjvkxDZDpesi8wCFTc5VHjW2tdPuXzvo6iRgxq77WEZg4/UirvYbXPjOIS9NGVlpaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7BPIeyT3cotDXj6MRVWw7szAtV/kLylvW05uYWnCe0=;
 b=dkZU46AL+1DNCfcVXESyOzxMFkL5IsDRrqujaSVhaOUjinRU4maCKi1YwVHthrvAnzw+3ZiuOFapLIgwtji2AbKjHWstj/J3Q2prjlTkaHhWvQ3A8so36w0+s1LfoiUfZ+nNxIVOt6A6Nwgg2UZAoL8FgdBHu9qppF7ew1EzBMaf/+qSx1XkCJ8oYY0EtdIp3gtm7QXacYc7IeouICLZST3Zy6lBKey/+NL6s/D7i6XDMcc1PZr7f52L8SCKqBvO6JqRleNa35Zo5UwLuBjBUCtcwtRuf7ddbhiBn3IooeWz+n+6rwYUgcQTpcfSMzAhDgwmy5L8pJnwSNKZcNFuaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7BPIeyT3cotDXj6MRVWw7szAtV/kLylvW05uYWnCe0=;
 b=hzrLUX2lh+3E+yQuZXh8GWvpUtJB2dQu1a958tZE0cQqy0SFYkjfPD37sdi5UFsLsinNSB4mPUy34bgUCXS9MI3uwE3xgeGuyU2Cqx/yq5xMc8rUiPj8TtYHShNu8UK15JnDDO1BlTuMJoHMkkL7QUBBVgP1aGXPjaRi6l/MET05Ky/V1k31m0mQeywAo9A5CdL7bnR5AkrpXx6cns4wJrGVF0WC6hIwmHKHSZWQ6/UBR8pBKdcjY17oitMM1pxiSz0kvs1z8sw5rGGFymNEaXT26FY7tsa5QENnN4zGlpXhTCMW6rfziqumdarvg/IzljLdNwXj3PRLx8+t7Q7UgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6330.namprd12.prod.outlook.com (2603:10b6:208:3e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Tue, 8 Apr
 2025 17:24:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 17:24:05 +0000
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
Subject: [PATCH v4 07/23] iommu/pages: De-inline the substantial functions
Date: Tue,  8 Apr 2025 13:53:55 -0300
Message-ID: <7-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0078.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6330:EE_
X-MS-Office365-Filtering-Correlation-Id: 4005723f-5ae5-4995-4ad5-08dd76c2298f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N2iduw8wavf6sadVDsJOWmEKVWV11+xysB52r/3Ip8XIcYmk85h3oP7rPbrH?=
 =?us-ascii?Q?Rh4JIunOPTyAZaLINpJUl0jxePI7hx+orjjpdCD2JqNwSCM9x7pSBjLvDDTd?=
 =?us-ascii?Q?p857Od6TTkEGJz9Y4hsL3eXD24TFJVph77dJjceoo4E2AQQod8SoepOalmeO?=
 =?us-ascii?Q?461Ycgs/JVoNdtioHnB8FWZFvkPp3/Tl7sb+bm740DDJ+nGXa8LW5iHHG0SA?=
 =?us-ascii?Q?o3sqxIwzDXYg6vccm0dTvrWUrfBYxStHrhRM1BlQf2MTmLiiFpDMoGvKO01Q?=
 =?us-ascii?Q?YSvZAduYsnyHSKegXz0gTbOW0tc6OtUnNi1mWEHXFzSjCHhP9//KLUM71St0?=
 =?us-ascii?Q?B+bbyxXv9OxNF948XH7Xg7I770ttNvKSu6J0dOsAmsYoF1rnjEoKZH0isak1?=
 =?us-ascii?Q?l+P4rSz+IYDugYY9o1kIhfA5NvfJx0ATKbxDbovAwRi5Nqv1dNju0HMmKwio?=
 =?us-ascii?Q?G4cmVHjTdLYSa9xFg47Ou3zkRL6WyFmUJahMlajHNftNU14ep/Psn4iYCjlv?=
 =?us-ascii?Q?/FBbcFVmOsfqnXEqr7DLo3VRkg1mNWb8uM/j4Hba5ygrLCJ71kkrQXNN2Z8q?=
 =?us-ascii?Q?xBtvPWpX3m+WWjxpsJt9DJPUCsHTxyjaNdCC4XurbUoKiTsqHTqyVg2cSUKw?=
 =?us-ascii?Q?ewXg9USIC2YH79W9aTHqZ41X/JIs/jsslKe1csqVfqcyM7k744FDtvxPWkrN?=
 =?us-ascii?Q?tfk7nBOuQwSEGIDP/7y8JBK0NsmqnFOuKPwHZLx8tICF0fhMGmG/r+dg4nNA?=
 =?us-ascii?Q?885uI2MwAT6s+IcnqZQlIg5vPbiHaq8flesS8vdFI3wpPzKtiX1JOsTUOkuo?=
 =?us-ascii?Q?avVJfAmpoHHjVGkj1n+69JqxzcaIXaLTjrldg0k9fwCjxs9QjO5FxSgrHZ6K?=
 =?us-ascii?Q?dBS6ZJr0F+eq4yrJPeSdJlqU4gpMCIvvrqM03rWpSHt7r7UsItDJHwV/wkq1?=
 =?us-ascii?Q?FFVNPGlCdSlI2flJCaucfvUI/wwisA710cH/jC8kBH1kECJyUW8n/lJM/1Rt?=
 =?us-ascii?Q?ce951x93u9z4ZYXcS01LDmy6AboSrUTTWrDmJ8KoR+G3a9sSXX/jU1gLCfXq?=
 =?us-ascii?Q?S/DavW5CZEvScjyyDg1a2LUBTOKHWt4kyzLAn7dHr1zNMR1n853+AUebwlRu?=
 =?us-ascii?Q?PF5E7S5RNgvmNZL3+IblPaLXte0YEJpE1JJ91gAXF2kRZDGqGeR2lN2hrKxS?=
 =?us-ascii?Q?lZ/kJKITsZco+esCAk2OQn3haTU7UCNdHmNIiA3F1gKRbNRZAcHjQL0y153+?=
 =?us-ascii?Q?ogXHaKbATlXZ5QIO4czuhIPxsqKX4qS25A2JNskfC6KTHD7rcie1DHpE4YE4?=
 =?us-ascii?Q?dUUyc8k5ejjsoa2KAQJCT/RBqWaXzzukms7kjQm5UWshdLLmamR72OH/Qm7X?=
 =?us-ascii?Q?JtLxJ7AhlpZxI/jrb60GzkWVtdBXzIDZiwxXgjTvIuZ3ss4czrHrRaEGdFTK?=
 =?us-ascii?Q?UDK1/sD0BcEDMnibPryVU4/EgwUeP12nCj8e595ZZxFwCxzwzJpiYw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/rHjik2yHDjVGt9gTQrfO8sZUy8Kozps+x3T9KKSo4EBi2fybevJcNHHh6+9?=
 =?us-ascii?Q?jVuo/fhiZJcc/Qz8JOHSQaxBgL2orNP7+ILrfpYlbr1rpJBzkh1hhADrE+Q/?=
 =?us-ascii?Q?/NlwPoLyNYs6bSN6wOpzl3X9GDG49+p5AEZwnSOoy2O5KIKjK3LIIzzDotZb?=
 =?us-ascii?Q?iryn9UMk5nl/jL4+p88/KYGbwyDfVFHHldTlE8xRy2cpsVOTkeXsscBFIyyn?=
 =?us-ascii?Q?b6fYKHXpHXGXFDhnGE+2ZuWUsYr2VJvG8dFwwuc7jPF7JlEXm0ss2XYGk02j?=
 =?us-ascii?Q?rkI4F+OVEgXxtulxUu0m52byhuvDhVdQjMnilxOw1B2X0/J5Y+4bzPsLbmmB?=
 =?us-ascii?Q?ZKenyUIxsD09yZciq+sR3g9X0hwLmd1XpyjFfag2elg3mxpLI317GY0rEnwc?=
 =?us-ascii?Q?2xjpNQf0vzn4w7aoWc0lUsyuIPB2tIvdXTIzZrtYSFaccxbqxdtZGVKlwnp3?=
 =?us-ascii?Q?J7qEL5IpJi9q2T6TPyLE4F0FYaTo+fgeJaL0Mb00V4rz099e/cJLA6CTSlB6?=
 =?us-ascii?Q?8nNTqDG2h5wVTL21IgLGZui+JqIsp7gdnEiwn59HriXK9cv3xGcuv972VQ1g?=
 =?us-ascii?Q?JfRQXozJ3UdLiIXIaB8THpIWCJD35oWuo7orJS1vWaP+6vTl/lQRsmEflJdl?=
 =?us-ascii?Q?UfIL/FsT7RSOqXjO6wE2JPeWbYfoSvamW8anxhyi3xB+7NBBB8PgNRQ+mv24?=
 =?us-ascii?Q?tjLNYyo5vlycmzg7qx7UjU1FCZvQOLMMjSM40e2uTA8Fgn5qCR81q0ZixakU?=
 =?us-ascii?Q?GFohGJgRUD9OWBzPKiKaCt1bIvF88Uf6TIkQ0R5NxAwXEZhcmLIzPw6cBICO?=
 =?us-ascii?Q?9K2Ww3t4c54sr2b77ybOYUN+rJN3qKCq3VjCgy+hM8c/IcMmrijzNotc/UCQ?=
 =?us-ascii?Q?WrQfm1q1aIKJdCkEOdGB5TVCdPgP/q67F7cNDsze1SWyLxcHkZd8A1hleB4T?=
 =?us-ascii?Q?qsM1qVGQZF3s48l9Z0P2545/ykCwf5SKZLnjsQGa1X9tzvNXFP4wvn/pnJ1K?=
 =?us-ascii?Q?cx7OoOsA7koG2YdQLUiqw2eEYqEOQW70CVb1R0Wa3DaFjgtUeswhW0+i/y4k?=
 =?us-ascii?Q?IZf1twLHeNBLAh7nsACax7BpEjOFQjyrLZFkbs45rdeu4Eg6aOQ6E0JIfH9W?=
 =?us-ascii?Q?srjnf3ZPfPykqS3xiQZf/75kjcR3VA+VeOvTll+v1PhqdWLX2LvnYSdQ2mS6?=
 =?us-ascii?Q?YYw3rWWaY3W8Ok3O+zJRHo/mH556VWfKsAoxn+AHm9DXQ4grV3V46lFLPIT8?=
 =?us-ascii?Q?FAmU350wzGyZbGiHiJEFh82KKyGeboQhDfYzn02wnjIXtIWlrWb2EQyyyNln?=
 =?us-ascii?Q?BwCFPGXZI97/937C8Ff8Np/B0XBO/gxQLnjBzsT+qELTsorO7/nBzUW/YUpf?=
 =?us-ascii?Q?COJGUJcgLG9SJxH44fo+5lWaFtjL20rwi6xnB/j7S/yCyDRVrutSE62Dfizf?=
 =?us-ascii?Q?h+5Mhtiw5YdfgxdZ3blWdl5GgTNm7LVkY9m7J91T60XIDgy89rqgBofi30El?=
 =?us-ascii?Q?Y9kL4L/CsSlQT5MOmkVwn0894/u4BeTx5RBLFGBubKgyA/0PwzXJBL4LDHZx?=
 =?us-ascii?Q?NdT4REeN8Bq6hH0RgECzXOkxGZ8It2VbwaG4DZnK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4005723f-5ae5-4995-4ad5-08dd76c2298f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 17:24:05.2499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0z24EPWdt6YYtJ1ph3IZigWh00/SA53eettlQikFAydGeGITSyFqvI2F2oOjVy1Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6330

These are called in a lot of places and are not trivial. Move them to the
core module.

Tidy some of the comments and function arguments, fold
__iommu_alloc_account() into its only caller, change
__iommu_free_account() into __iommu_free_page() to remove some
duplication.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Makefile      |   1 +
 drivers/iommu/iommu-pages.c |  84 +++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h | 103 ++----------------------------------
 3 files changed, 90 insertions(+), 98 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 5e5a83c6c2aae2..fe91d770abe16c 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += amd/ intel/ arm/ iommufd/ riscv/
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_IOMMU_SUPPORT) += iommu-pages.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
new file mode 100644
index 00000000000000..31ff83ffaf0106
--- /dev/null
+++ b/drivers/iommu/iommu-pages.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include "iommu-pages.h"
+#include <linux/gfp.h>
+#include <linux/mm.h>
+
+/**
+ * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @order: page order
+ *
+ * Returns the virtual address of the allocated page. The page must be
+ * freed either by calling iommu_free_pages() or via iommu_put_pages_list().
+ */
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
+{
+	const unsigned long pgcnt = 1UL << order;
+	struct page *page;
+
+	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
+	if (unlikely(!page))
+		return NULL;
+
+	/*
+	 * All page allocations that should be reported to as "iommu-pagetables"
+	 * to userspace must use one of the functions below. This includes
+	 * allocations of page-tables and other per-iommu_domain configuration
+	 * structures.
+	 *
+	 * This is necessary for the proper accounting as IOMMU state can be
+	 * rather large, i.e. multiple gigabytes in size.
+	 */
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
+
+	return page_address(page);
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
+
+static void __iommu_free_page(struct page *page)
+{
+	unsigned int order = folio_order(page_folio(page));
+	const unsigned long pgcnt = 1UL << order;
+
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
+	put_page(page);
+}
+
+/**
+ * iommu_free_pages - free pages
+ * @virt: virtual address of the page to be freed.
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
+ */
+void iommu_free_pages(void *virt)
+{
+	if (!virt)
+		return;
+	__iommu_free_page(virt_to_page(virt));
+}
+EXPORT_SYMBOL_GPL(iommu_free_pages);
+
+/**
+ * iommu_put_pages_list - free a list of pages.
+ * @head: the head of the lru list to be freed.
+ *
+ * Frees a list of pages allocated by iommu_alloc_pages_node().
+ */
+void iommu_put_pages_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct page *p = list_entry(head->prev, struct page, lru);
+
+		list_del(&p->lru);
+		__iommu_free_page(p);
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index fcd17b94f7b830..e3c35aa14ad716 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,67 +7,12 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/vmstat.h>
-#include <linux/gfp.h>
-#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/topology.h>
 
-/*
- * All page allocations that should be reported to as "iommu-pagetables" to
- * userspace must use one of the functions below.  This includes allocations of
- * page-tables and other per-iommu_domain configuration structures.
- *
- * This is necessary for the proper accounting as IOMMU state can be rather
- * large, i.e. multiple gigabytes in size.
- */
-
-/**
- * __iommu_alloc_account - account for newly allocated page.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_alloc_account(struct page *page, int order)
-{
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
-}
-
-/**
- * __iommu_free_account - account a page that is about to be freed.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_free_account(struct page *page)
-{
-	unsigned int order = folio_order(page_folio(page));
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
-}
-
-/**
- * iommu_alloc_pages_node - allocate a zeroed page of a given order from
- * specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the virtual address of the allocated page
- */
-static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
-{
-	struct page *page =
-		alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
-
-	if (unlikely(!page))
-		return NULL;
-
-	__iommu_alloc_account(page, order);
-
-	return page_address(page);
-}
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
+void iommu_free_pages(void *virt);
+void iommu_put_pages_list(struct list_head *head);
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
@@ -104,42 +49,4 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
-/**
- * iommu_free_pages - free pages
- * @virt: virtual address of the page to be freed.
- *
- * The page must have have been allocated by iommu_alloc_pages_node()
- */
-static inline void iommu_free_pages(void *virt)
-{
-	struct page *page;
-
-	if (!virt)
-		return;
-
-	page = virt_to_page(virt);
-	__iommu_free_account(page);
-	put_page(page);
-}
-
-/**
- * iommu_put_pages_list - free a list of pages.
- * @page: the head of the lru list to be freed.
- *
- * There are no locking requirement for these pages, as they are going to be
- * put on a free list as soon as refcount reaches 0. Pages are put on this LRU
- * list once they are removed from the IOMMU page tables. However, they can
- * still be access through debugfs.
- */
-static inline void iommu_put_pages_list(struct list_head *page)
-{
-	while (!list_empty(page)) {
-		struct page *p = list_entry(page->prev, struct page, lru);
-
-		list_del(&p->lru);
-		__iommu_free_account(p);
-		put_page(p);
-	}
-}
-
 #endif	/* __IOMMU_PAGES_H */
-- 
2.43.0

