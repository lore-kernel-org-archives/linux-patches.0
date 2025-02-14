Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083DA267B94;
	Fri, 14 Feb 2025 17:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552888; cv=fail; b=UGag4lBrgS/ayyWj66DJ0g1lVlQGKxu35Qwx8ReVlLYzeqw7s6emWu95q3arFMQjwcyt/MSOCzhxn/qIeWNKWpfUwi9+/TPavj7jrfr9F4XgYjRfQFEAmK+a4sfL290fk/gJMKCt54KKInwmh72nyig0mGL3uf8Ft5tPUVCiI88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552888; c=relaxed/simple;
	bh=75yvjr7dn5OawIM3bug/ul4dFZ8lzhKHadpZV0QV/ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BwRQoYDqlcSUDxRgMeR4FnBzKss8Kf1zltwvNxNhB3ib+1ROura53L4TG1l/I/3qeq3U6yG9DlBx7L2ll4JF7GTWGJa+Yc7ZNMndGEG/dIKj4QWY+aUmzLRa3W8EfHo1KzZqkjDVgv/imGOz5rqRk6l733LMvc0zbiWKqyUzs6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=asycgjjj; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="asycgjjj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EmSrT86HPKNmSlIWDDmWRIgILVwqvnVbZ2utAT8OEHVb7OarDYXzUviCRjJIWWM5D+v3SzZo4thTqdkX2vIK1ogxHhDSVxe8UL4v4EpuqH278TduDYYJzSXTwka7TIQRZom0TmsWXtTdrb3mYTts9nwuoydzm+oS/bEKTMOHdR7JF1SeKC5x8B2wRkCU95qD2nV1MCjGmAeV+LszD1hZK09xMCp86bvBDtdkpqwdZibE5bzAq0cblZ7kDZ4IpkKEOLHLSDhSIfaqSQHOCieKU0/UlN+CBo5p9lrjkmPTpJX3W0BWcPoQHZ5vyfzzFC0crHcQ+1lF94b6mMeI1DRggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ocqkWzOZVA5WJ+XsiY+3U6yRvBn4DuZi5eoxznJmr2w=;
 b=VpxQSjRjhV3gtEy3XPNsovNmmNn4HAQmhc+NXfvw7Oi2vDtOE5BQr/5ziYKngtSNzVOEUn/NIVRQWIk9amlveH6R9TB5mkD6y8ZaqP3XHbHd+HWFxPcPAl0bqiySn8FUINPDrzPsGQ9vM1CrxIyjJOE9hpxAodNdaKDl24LCsHauZVdhZZjjwADVU/LyerCGXskeyVssU+rqflA6KIxWm0+quKxzhPH43IBqTWs/Pb4pqf2mvMHXYE+yDNtXeLUhNvOLml0zCICr8Bxup6+Ze34aOu84wMJtUYtYsy+pWj9uRJJGePt0tdzRLoSHY/jpemJgT7JwqeGbfUmChWsajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocqkWzOZVA5WJ+XsiY+3U6yRvBn4DuZi5eoxznJmr2w=;
 b=asycgjjjA2WxS+bxLO8299rR7FUblkgc7lopQ95cTlgKICGg9e9LDIhZUmZFvIBbxJR8GVnljMSIHeWyEMulsU0WhVoZtogDvCcI5B7UWeFMyi1uQti7A1pEok6vyVKK0pwagGgJzPQhGkiVGZCWNAEmK8SOTA6Wf0HNUA1VA8uLSHkJOoFlnAEUghYpNsdiE3AEDKTHeg/2slJOj6RYTyaf1Bx1bgR42gy7zOsc/VhCToayyAzDxNvI7BUr7+BiZmZS2+5zxsPZpcyH068B78e4ezUQXyEnQdb4mcORkWOVMQGcOYmUumS1rWbxc863Mf1ae6NFtZP7mYnI1FqO2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:01 +0000
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
Subject: [PATCH v2 02/23] iommu/tegra: Do not use struct page as the handle for pts
Date: Fri, 14 Feb 2025 13:07:35 -0400
Message-ID: <2-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:207:3d::49) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 600e91c9-7b2e-4bd7-c8ef-08dd4d1a2184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qTnTfo4yleaucqNsDO4rLqq+PpFM2lD6nvAVbh8PyELZU/KVW4CS43UfGy+4?=
 =?us-ascii?Q?tqR7F626hoMlP/0XOW2SOMfcwJ5dVbRiwQi0IGxNHgcHK9lDHkuSPiTUpx2L?=
 =?us-ascii?Q?YEqeuBKfwWej5WLLqNzyStz4Y9SgxgwcizRuynHUUyTCa8lf3JFokEqx22rg?=
 =?us-ascii?Q?JCjcBh9YAL+JmQxkr/0sSAUKmAE9BPcAg/qrF56/0F/F8O8m5tNfF4U1Kjfq?=
 =?us-ascii?Q?A6nOs9wu5OI4fzUatGrdo58o24peyOX+GDaanoAJ7in8QzFzJLgp19/Sh97X?=
 =?us-ascii?Q?SrQAU4mWsGdZWkyEZDQDFAnTTT9x/oGSSsjfLe+uIgmwu124B0lB01Q9iAt8?=
 =?us-ascii?Q?eJFe5pDppmCNI/vz9opJP7NOZbhanQk9b0dPxyvV5AbufGxXFSazOI2qGQWe?=
 =?us-ascii?Q?1dNB2aareNgpSn3aL1gp8ZIbBQVmV1TlkCaZHITotM3z1pJHaQ7xwN7ZD4tB?=
 =?us-ascii?Q?1JOQMEZhHjGEPivTFhuctoh120O1Ngp6ZnLFvBTiAiXiayac6xTzR2Ijo43k?=
 =?us-ascii?Q?Xzr5xYe0AR7eio1mm+WVZ0mysXFOltVHzLgp20ObI6ln3k/L+iqMGkWJ1whE?=
 =?us-ascii?Q?NPrLZHw3aISZhJOWYdyFPdDFyUOuzkgAxojPhhKElyCmrSyjWJWS8TJDS+Ty?=
 =?us-ascii?Q?XPbBJqIGCCfWDIb+wVljRklyRLU8ncRgFn1NT9N+cXlD8cSh+5+hjrMuOH+S?=
 =?us-ascii?Q?u5vVRUsLUH12ZpO1BwbgK/ClAD6lYcLqamqoo005bYYgA1TMAexhIerHy6pq?=
 =?us-ascii?Q?LLQ1Sb9H2NaLhHWWnuT82+biHG+TL9XjCsycN31MfluFDZXRNw6okjVqcuIF?=
 =?us-ascii?Q?cbENvkElekkwssvXlDl29tgwpY+YlVDcHZYvXK+dnF2Mis68sRIDBExI4FPS?=
 =?us-ascii?Q?BruOMLsSfKsOg60jOkBdT1t+0kNMhjXHZ24hU7i/CC1v/iWk1BE73CKl46ZB?=
 =?us-ascii?Q?NOlyvoaeuUkv7L+NYWND5HkR2I0678O6Zf5mgRUA0hCGnvOdHxVONjbhukAJ?=
 =?us-ascii?Q?LzYwl/N9oVZ6aHiwjblOClqeblFWvQJNioYA2PnDtGpUzoQFLp1DwP47XGEA?=
 =?us-ascii?Q?+tdHA3rJhxK4R92b5W3E5F73+dL0tDMP0errDGgtxqhMoRWqixM4D/2isrgq?=
 =?us-ascii?Q?3PtM2lt9VGeZnNOuzzHeh/m7qqAch1Fu+ik5EfXthtmJqCK8dz7wFkshx/f8?=
 =?us-ascii?Q?cm6ReKZyMG+yPrL6nXYZFnguT4ERIdKU0Y/vH23lYqAgUz2INJBBiK6xv37g?=
 =?us-ascii?Q?yP2aLCya0RPBNybtui0wwV55ieNFpdpdtAmb0GcOv5k74xdYNgewDZsxfkOe?=
 =?us-ascii?Q?cCU4tHdKZtkBNwplEUQdekQlUQ6R7mXs9+85wzSwaeglWQLVwPYybYY9bzy/?=
 =?us-ascii?Q?xI7NvGUFpuCy/uwlolynutvTHMeTNpUFHKgehFhG7J7dZJmgnuAA6AXLczeh?=
 =?us-ascii?Q?uMeXxLJ3Gcc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yig7Ldkz0a9iRKeYB1essUxGQFSslyqstpeI8ZjUOAnnrw5gesit+EHm9Kxc?=
 =?us-ascii?Q?3a89H6IP2YfqMG+YITDIHzQLmKBnt/21bn1CYBtIp0FkLE1jHsO74IYkL0yw?=
 =?us-ascii?Q?Lg3yEtx9nihjCA1/31FwOMVWLKr4SLcS4RPCSs36BohwjqumNucvWio1C60g?=
 =?us-ascii?Q?XfPOSaMolWUsuM+aDx+0iunfHNC2UJpBLvujik72sSviYdKr3XmYzWJSyRu0?=
 =?us-ascii?Q?5H0FZD5jSx2K3zXOTzwohlJqwDHUd4BmdN3PHAVkAiup3SWuqbd5bENm3IEk?=
 =?us-ascii?Q?nBay5Ad+U8f1/zjx+uRvsq5zG0tGseii+WItiXT7ElFIX0WPOuofA9X6Du/C?=
 =?us-ascii?Q?UBMpcGe6H/NsYcl5Aw/2WxedgBWzgtoZerOELESUBtRwSz86/eNN9GnCmVf0?=
 =?us-ascii?Q?+yUc8iA0SUuooqhmMFvYItCTV90pSr9kK5LwNdCsf1t+6wOE0CRLV0w7IbcV?=
 =?us-ascii?Q?sw3HptmE23cDh0D/WfCzXNi7zGybQP6o+KB/h/tOqTWepxKRrZHq72YzCsiG?=
 =?us-ascii?Q?4A5TTNjzGjdUWc3/XspVWSevH3MUV4VxIkzOpvWNFTLOpfYiSYXD7qwa03GO?=
 =?us-ascii?Q?HOx1TIP7NmtmnJwnrSbcXqf7G7EvVc5yMx4BcJM/GdgvJ5MiSc67P6LeSPDn?=
 =?us-ascii?Q?PhEOzOu0ejnRL2s9IdTPdJo9lj414IXy71SCkNEW6wIn1eu9koV9G/ZCIdo/?=
 =?us-ascii?Q?B0LcY6IudatggYu/ZordTVOsQ4bwJDBcrDyjZjHrAWcqPv+YF0yprT6mVoAD?=
 =?us-ascii?Q?afgoaQXWL0VrK9lx8EcZjjRVBThZupkZHPfnNoIHkZgPjhmjPvYJEdXiwwKW?=
 =?us-ascii?Q?PhMLii2kyPIeZVbe9k7hpk3HVLPviGUZfBXvTwUcGyuByj7MuHct6NOTFFOF?=
 =?us-ascii?Q?VuNM9Gj69v1dGBIYgpIhii+gOOf0cBRXVm5p3Pxqsa0cYmByEEMt5mKI+nz/?=
 =?us-ascii?Q?HFA3Cl8s1oyG03A9t1QDhOVCJi8sjI+6SqCIiRXrmf1VKvhCRQo2l1L4spbM?=
 =?us-ascii?Q?YnOSXsVB4tiC+6rJjoFsGVXYKp4nvWZWUbnhWz/yYNMyuzucoa7G5ZBedCnJ?=
 =?us-ascii?Q?uVnMjjCV5cEttAedKplKTFb/K8g7SeU4gxI16TnJvSt2RWSwdw9WzQr6M2f2?=
 =?us-ascii?Q?FpEHaWHjTw0Qz4CZKLlWBiA7f2CRavGoauB+piC0H4tbjU8EJwGcEIHvLoPs?=
 =?us-ascii?Q?QGtjA1rwYnUIZYJYDKJYDEYB+IkvJM7FYrLbPzRbOzR28KfbBSFp8tEr7YuS?=
 =?us-ascii?Q?/BTi8nQMpyz4yIKsvmj+W+0MdzcNyAkk/fH473bGqaJ6C3/iYapavZcEBvpe?=
 =?us-ascii?Q?3CrZowhVEVpwoNgh6c94imeI6LxBTAALAzvHklD26/VgMOTDwrFTfozeN2x3?=
 =?us-ascii?Q?31myO0gF399DNJSY2KKOZmyEzv3T4cRVACkf8tKy3O6Fjm6nWHUlmKjglgmb?=
 =?us-ascii?Q?qyp1y/HRTXXUNIaCmlkdfk5szSTbbaUX+TnQ4mCR+zuc7ii6m7fnNt4lID1Y?=
 =?us-ascii?Q?Cx7AhTK/GiGy42uz9H2CmhDI1yq9nCFG6x7QCW+jG5c4mUo9rcC+polt0bTg?=
 =?us-ascii?Q?61NMoeUgLzKymAYvAWo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600e91c9-7b2e-4bd7-c8ef-08dd4d1a2184
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z5NM0OfBf2vyFpiLFt1YHelqWfGZYFv/8wbIb0E32tThtKavtsVEGmqo3D0BaNSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Instead use the virtual address and dma_map_single() like as->pd
uses. Introduce a small struct tegra_pt instead of void * to have some
clarity what is using this API and add compile safety during the
conversion.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 74 ++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index b6e61f5c0861b0..c134647292fb22 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -52,6 +52,7 @@ struct tegra_smmu {
 };
 
 struct tegra_pd;
+struct tegra_pt;
 
 struct tegra_smmu_as {
 	struct iommu_domain domain;
@@ -59,7 +60,7 @@ struct tegra_smmu_as {
 	unsigned int use_count;
 	spinlock_t lock;
 	u32 *count;
-	struct page **pts;
+	struct tegra_pt **pts;
 	struct tegra_pd *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
@@ -161,6 +162,10 @@ struct tegra_pd {
 	u32 val[SMMU_NUM_PDE];
 };
 
+struct tegra_pt {
+	u32 val[SMMU_NUM_PTE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -570,11 +575,9 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static u32 *tegra_smmu_pte_offset(struct page *pt_page, unsigned long iova)
+static u32 *tegra_smmu_pte_offset(struct tegra_pt *pt, unsigned long iova)
 {
-	u32 *pt = page_address(pt_page);
-
-	return pt + iova_pt_index(iova);
+	return &pt->val[iova_pt_index(iova)];
 }
 
 static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
@@ -582,19 +585,19 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	struct page *pt_page;
+	struct tegra_pt *pt;
 
-	pt_page = as->pts[pd_index];
-	if (!pt_page)
+	pt = as->pts[pd_index];
+	if (!pt)
 		return NULL;
 
 	*dmap = smmu_pde_to_dma(smmu, as->pd->val[pd_index]);
 
-	return tegra_smmu_pte_offset(pt_page, iova);
+	return tegra_smmu_pte_offset(pt, iova);
 }
 
 static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
-		       dma_addr_t *dmap, struct page *page)
+		       dma_addr_t *dmap, struct tegra_pt *pt)
 {
 	unsigned int pde = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
@@ -602,21 +605,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 	if (!as->pts[pde]) {
 		dma_addr_t dma;
 
-		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
-				   DMA_TO_DEVICE);
+		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
+				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			__iommu_free_pages(page, 0);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
-			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
-				       DMA_TO_DEVICE);
-			__iommu_free_pages(page, 0);
+			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
+					 DMA_TO_DEVICE);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
-		as->pts[pde] = page;
+		as->pts[pde] = pt;
 
 		tegra_smmu_set_pde(as, iova, SMMU_MK_PDE(dma, SMMU_PDE_ATTR |
 							      SMMU_PDE_NEXT));
@@ -639,7 +642,7 @@ static void tegra_smmu_pte_get_use(struct tegra_smmu_as *as, unsigned long iova)
 static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/*
 	 * When no entries in this page table are used anymore, return the
@@ -651,8 +654,9 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-		dma_unmap_page(smmu->dev, pte_dma, SMMU_SIZE_PT, DMA_TO_DEVICE);
-		__iommu_free_pages(page, 0);
+		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
+				 DMA_TO_DEVICE);
+		iommu_free_page(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -672,16 +676,16 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static struct page *as_get_pde_page(struct tegra_smmu_as *as,
-				    unsigned long iova, gfp_t gfp,
-				    unsigned long *flags)
+static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
+					unsigned long iova, gfp_t gfp,
+					unsigned long *flags)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/* at first check whether allocation needs to be done at all */
-	if (page)
-		return page;
+	if (pt)
+		return pt;
 
 	/*
 	 * In order to prevent exhaustion of the atomic memory pool, we
@@ -691,7 +695,7 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	page = __iommu_alloc_pages(gfp | __GFP_DMA, 0);
+	pt = iommu_alloc_page(gfp | __GFP_DMA);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
@@ -702,13 +706,13 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	 * if allocation succeeded and the allocation failure isn't fatal.
 	 */
 	if (as->pts[pde]) {
-		if (page)
-			__iommu_free_pages(page, 0);
+		if (pt)
+			iommu_free_page(pt);
 
-		page = as->pts[pde];
+		pt = as->pts[pde];
 	}
 
-	return page;
+	return pt;
 }
 
 static int
@@ -718,15 +722,15 @@ __tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
 {
 	struct tegra_smmu_as *as = to_smmu_as(domain);
 	dma_addr_t pte_dma;
-	struct page *page;
+	struct tegra_pt *pt;
 	u32 pte_attrs;
 	u32 *pte;
 
-	page = as_get_pde_page(as, iova, gfp, flags);
-	if (!page)
+	pt = as_get_pde_page(as, iova, gfp, flags);
+	if (!pt)
 		return -ENOMEM;
 
-	pte = as_get_pte(as, iova, &pte_dma, page);
+	pte = as_get_pte(as, iova, &pte_dma, pt);
 	if (!pte)
 		return -ENOMEM;
 
-- 
2.43.0

