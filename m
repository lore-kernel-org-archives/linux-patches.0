Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5D29B224;
	Thu,  2 Apr 2026 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139924; cv=fail; b=bK0jVzCcm6SlZw9f3dlx2U1lZJEjsXbEp8QYZk6X3g0SETj3uAYHDU5FUzsoRpTEDrVQVJCtiCg88mAiOT/nRHTz8dG2g+nqNw/ezgNnUsiNgBs092K1xHftYDHzaw2Gb5LQIomp0caw7VmJOxtfIm/m5rKCfVCnw+gEWIkmyFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139924; c=relaxed/simple;
	bh=qoGWlq/WZOA8X2hL9YMi8jmJ6ZSc3mtqnKohCfVj3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jUx1svEoB6XNyZMSNzyssqVdYqEQ28Ck90yyY7sCOHMz7p3N88n728Z/7U0DxHf2fovto63b+lGDsH+LvhxKz6Y6ZJNJMPj+YAu6ZcTbcnPdzYqvZRG59icf3sDHCO6AHnwZLq6JS4ecTcxQ/8XX5bhi2iPaSdFPtuWFwxkM1Ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PijJggio; arc=fail smtp.client-ip=40.107.209.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PijJggio"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DU4w9ALpR49Gjm4or4X8gRoy0O8XKhymqx/p3w4VatCUF2ssisf6p562LJvfw+zdR7fDvud1GteKiLWQFsHH9U1FMt0zF94sxANybFbYW+Zrf4ZUZzpuU3hrTRjo8KaKSYKjx2LppJH3l5+Bg7e9VSFKxdYxvVBESehrPCLQXYYfG7L9UQYKgTRaPGCsFgAfJSm5WJgT3T9cTSqgYjx3JSXrfwCaa62qtf44witgeQSXLuXolxFXKgx+9t7H74J/TX0tmgHiIF9SUOub6M+xtnX8gA5MFFMqPMpM+81bS7VM1BhOxiA2hKAJDYLhr66OvknqTlUgMSt+w9J8464wKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOla05PLOF0VALlFp8vJFniRVqdzSLQHLlw5Gf6sb/0=;
 b=eaCKfTUKDCVBQg+9md6hEm/ynuqa9M/u+6dm409HBcgsjHc9kBBq0WqzbQ/bTRGCjkF1Pwkc5IoR75cj/+yC7QM0wAMmfcKYgEd4smLzSY82vPVoXZKp9TqQ6J0ZZ78xeob4qitDYYyMjQ7PgC7uK8WE1io00ZwaSlhvWNJIxaDJPUQT7w/S4PKtQH4aoZuOWLST4X3qjJYmjwfZjo+vNJch0jUnPzqWa3ye1PHe7QG1qxqkRTM5mp1JhqYF1CTynJJX479lG3gjR0AxWiwrZ661L7VUPpkMAoE2vAOqSil8BcpYAh4vwE0cDLQW4gG7V3t468Y+XmvWmGMBTy7M6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOla05PLOF0VALlFp8vJFniRVqdzSLQHLlw5Gf6sb/0=;
 b=PijJggiolscYQJmq/0Rf4sJHI39umcCLhsmpsiC78VTdHii/zfPD0x+SapL1D5AvriCRuohJoEFApX3HQTQuhj8xP9/WzCaKKV+CznvKDIYCBpTB1O1CNc5hwvDBjxpFS6D+CO7Y4/nsLyG2l2zpAzPgs0dFvO/reX3mSoQAhqhc8VVGDz2b6y7GQ43Ow81BUmM8y7k7j31nxMHFxUa4HehLy4NwF4wJqmAvwnte52L/8ch/wSverJJc0Wi8ur3umPNcDxTmHmzfqD+P+bHhtmaFOjixp8+laeIbZJwHfMRKHksBhuxw5K2G0Ac/7li3hy+n6U31S/x3h6jZprjtLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CYYPR12MB8870.namprd12.prod.outlook.com (2603:10b6:930:bb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 2 Apr
 2026 14:25:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.017; Thu, 2 Apr 2026
 14:25:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Neal Gompa <neal@gompa.dev>,
	Orson Zhai <orsonzhai@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Samuel Holland <samuel@sholland.org>,
	Sven Peter <sven@kernel.org>,
	virtualization@lists.linux.dev,
	Chen-Yu Tsai <wens@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yong Wu <yong.wu@mediatek.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	stable@vger.kernel.org,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2] iommu: Always fill in gather when unmapping
Date: Thu,  2 Apr 2026 11:25:16 -0300
Message-ID: <0-v2-b24668f107b2+11bbe-iommu_gather_always_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CYYPR12MB8870:EE_
X-MS-Office365-Filtering-Correlation-Id: 232e9ee0-b52b-4a80-7c9b-08de90c3a9bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	YH8D7WLaU4qdRlHYZUPvxyyNv7AFQAzP83JgCE1LQXT9JgvRxC4OHGcZyAQmUZazbphGfvFpFzlzsZmBzPMZMenHfb691PHj+kqLqexPbFxJh3sFvOr5ITawjnc4rM51/V+yhPWjXPGnpc4dIUuUjewC4lkEmDhGK2bIani0SgmKzUTLMj+xrXrBJpIIUBbYbPM1r8Lcod0K0gFeSTPmI+FGERc3C2UItYXJSO/ecjVL70bV8R9aiDJkZdcmQ8fwOgGMFKMy9wutELBnjZZoeGNqxNIVE1fd4kLMus4FvgTQ+/l0nc0/3DzMD4e61sOQZuAG4tJE1H+fbTOuOqpjFwRWZRCPi7eJLWaoyhlMijvD0+lHaZxbkCLspcw6IRxJ+oaCZe2M5hcWcOeusrXit0GvvbKPeUX47GM3EKCaYwCjOWbkAakBkyO5ow74L45WJD0cJxjbUPOE5fj11U+cPfm4PbbGBnlxQRGokSP3+wTwqusOEjLNvyvCJSr8SKLMTb2nwZNS7mFjElMeRbnB1x0BU9b664e6QbnYt3WOC2VdqK/4z1AqYmkZgzH9YNKjrzQwCaqLHFcdx8wuvfWm8yWAija4rE48Lfd7+Jppf59qWHg6acrzzrpwKnnHR4zYEJF2uKbd/965gzLtEDjr75rKCCK5Ka+r4WwB4ZkIiWjKSLOOxJo7gx6TrIy0rxdp+adT+OMNXND0QNuNZs3RYMEnmHGEjFKQWo1wejxnSoBWX0/6WxMi5K0XtuuRd6mW9x7kmrkp/FWkZ4p4jiR3fwcFBULP5o1ObDncyj2I2/I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?19tT4B57Ciz++iIzGYDa5r5O17NDli9YhNLe+gIRcG29CsS0pcfhz+4L38bH?=
 =?us-ascii?Q?stYoyzujMPUsILaaZ0GGuYAdhTt/oc7QCEvNjzZo1m/I1lvZXsLv8ZjgitFn?=
 =?us-ascii?Q?VOXzH2NiDzNRhiFlfk685agikys4/oQAAnum21qq0pi4tNXh25JySLXcNPqI?=
 =?us-ascii?Q?rN90vSfQ87muq4FfxDu3JAzA95plfRHrOGRAsDq44TYdSfiO5BKtCYQywes4?=
 =?us-ascii?Q?2f92GtUgvSyDiCZO6TKlQ6wXuSkkbQl+LCPIPnC85lrRhuxZ+bM00jUHAG1h?=
 =?us-ascii?Q?IvpY2sFkzdy3nOMZzLF3rNrmV3RQ+LxPw0uoLQH/NHyDcEGd152zXhcsDUmP?=
 =?us-ascii?Q?hQGQoOLhEGdH6ZYZ6LydbbzXCr9HeCCRXnbDX5imAaNK7Gh69uW4AlLqj24P?=
 =?us-ascii?Q?X9G2Celz0LNpWM5v/N8UcCDj5cX04SByZ/TKy/7drErjIR/oszG9ee/0dqHb?=
 =?us-ascii?Q?+sSkc6+x5qPEffS42nOjUma+BQMu97ukYhA+8g63GvnNfCJbZN/KsyR92P0W?=
 =?us-ascii?Q?Kuu2ApN5EUYI0kINlV8JO0se9D9OMO76DG3A1lm5BnuaGS6McDc4KWMePc2m?=
 =?us-ascii?Q?vjnIOV+yaeD0/6WiVgeihcocyGQqNP5lyKTvOQUiObTNmL8dbXwxXUy8CR8g?=
 =?us-ascii?Q?UbB6Eo46pgdzifkKQWDl2eYF3nhQJGh5YwyksAw2NZWZI7n5Xv5YZ7WtBY7J?=
 =?us-ascii?Q?CzeFpp6qEwt2dJuv9fGXPU4jiwEZuwzyKmydV2rmjTk4Av5886a+UACMtlyM?=
 =?us-ascii?Q?Zs2bbOt7wPa/6CIhgaAnhYzUBF+MkFAk8Zwc/areAbtiXW+1MyIZsCldxKNQ?=
 =?us-ascii?Q?BOgyE8rL4iu3JLdNurIWLLu4+GsPh7iQrzwVDk5twrTG39QrzOJrGLXZRfIi?=
 =?us-ascii?Q?asYrBp6sjnbWoNWOmk49h7u5fDrlOutIkqBSCG5VawYELh683QHz3Z2cLpd3?=
 =?us-ascii?Q?CaHhQxleXwzx6GJqkQh+VNiVq1r9FhCPyJeXX9G4WmVKkRDkHOYRmDonUP8V?=
 =?us-ascii?Q?Hs0fqp5BsqLKkiQgRRmcOBjpY8nzydjMlIU1K4yiZtVfdSXv8G2Nh8RUCy6V?=
 =?us-ascii?Q?/qRjrzeqyb+P3690HF+AJTs9tQ4aM71QpQy2yy4JoKboeill7C5cLBxFqCkH?=
 =?us-ascii?Q?R+fKdmm3+WEB9k+n8Llp/jGinxZdbBppYbYqL6xAE01sXvm7v2/eD7tQHiis?=
 =?us-ascii?Q?1OykGAwgmHA8ycjQzLNpRohH6W0sRxmNkGXkoGoaKTj5qzcPsVYCk9QbVPLj?=
 =?us-ascii?Q?P3i443Cy9F0n8YCO4lgwUyp/8XVrFSOsg/fe0O5yNjRLVYlIluv/4WbmyCMn?=
 =?us-ascii?Q?t7kmNbOcx/LLeAfIpm39stZ/1fg77erQ1Ba/z+8MUyWgV08weaAEt9K5zCJy?=
 =?us-ascii?Q?esnH94NM3hf4difs6ahscx+oZBso54yqpM13hyS8TCO2DerNDqAtxK6Oo89O?=
 =?us-ascii?Q?xl+zYbyFUldTJSJI0Jst44s4XqeYTDBs5bSiegnrzdnRMpJ2XwLDN8JqaOmi?=
 =?us-ascii?Q?DO6Mp8SA1XtGxDkBm4k1r/3voVYjtXh6ALfnNrMC60NWQOLICWh4RT0olkGO?=
 =?us-ascii?Q?E3LBHgVRaag8qxz9qc/79CtsvdhpP/uOBGhWI+W+CF6yLZkLMhk5YYpxhdZE?=
 =?us-ascii?Q?bmNaUQMpr25UViYlk9NLU+D6tN2UE07zyWDSD/y5AzVfgXIcN20p0p2J8KdW?=
 =?us-ascii?Q?TOGCKKQDr1wqxTI33bLDqw/2TefAEiKXQaVf4xLFbpaGoy/2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232e9ee0-b52b-4a80-7c9b-08de90c3a9bd
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 14:25:17.7758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/7j2dw+12E1v97J7QR05Cz1ZuGMwo+0oEgU30otKne+JVoAJ9l8erXG9pj1vO7c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8870

The fixed commit assumed that the gather would always be populated if an
iotlb_sync was required.

arm-smmu-v3, amd, VT-d, riscv, s390, and mtk all use information from the
gather during their iotlb_sync() and this approach works for them.

However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio, and
apple-dart all ignore the gather during their iotlb_sync(). They mostly
issue a full flush.

Unfortunately the latter set of drivers often don't bother to add anything
to the gather since they don't intend on using it. Since the core code now
blocks gathers that were never filled, this caused those drivers to stop
getting their iotlb_sync() calls and breaks them.

Since it is impossible to tell the difference between gathers that are
empty because there is nothing to do and gathers that are empty because
they are not used, fill in the gathers for the missing cases.

mtk uses io-pgtable-arm-v7s but added the range to the gather in the unmap
callback. Move this into the io-pgtable-arm-v7s unmap itself. That will
fix all the armv7 using drivers (arm-smmu, qcom_iommu, ipmmu-vmsa).

io-pgtable-arm needs to accommodate drivers like arm-smmu that don't want
to use the gather by just adding a simple range, and drivers like SMMUv3
that need to use gather->pgsize and also have a disjoint check. Move
SMMUv3 to a new tlb_add_range() op which replaces calling
iommu_iotlb_gather_add_page() in a loop with a single call to update the
gather with the range and required pgsize.

iommu_iotlb_gather_add_page() is repurposed since nothing but SMMUv3 uses it
now that amd, VT-d and riscv are using iommupt.

Add a trivial gather population to io-pgtable-dart.

Add trivial populations to sprd, sun50i and virtio-iommu in their unmap
functions.

Fixes: 90c5def10bea ("iommu: Do not call drivers for empty gathers")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Closes: https://lore.kernel.org/r/8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++-----
 drivers/iommu/io-pgtable-arm-v7s.c          |  4 ++++
 drivers/iommu/io-pgtable-arm.c              | 19 ++++++++++++++++---
 drivers/iommu/io-pgtable-dart.c             |  3 +++
 drivers/iommu/mtk_iommu.c                   |  1 -
 drivers/iommu/sprd-iommu.c                  |  1 +
 drivers/iommu/sun50i-iommu.c                |  1 +
 drivers/iommu/virtio-iommu.c                |  2 ++
 include/linux/io-pgtable.h                  |  3 +++
 include/linux/iommu.h                       | 19 ++++++++++---------
 10 files changed, 46 insertions(+), 18 deletions(-)

v2:
 - Add missed hunk for io-pgtable-armv7
 - Revise the commit message to fix the miss about smmuv3's gather flow
 - Make smmuv3 push its gather with a range instead of per-page
v1: https://patch.msgid.link/r/0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com


diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e8d7dbe495f030..97e78a351cf35b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2775,14 +2775,15 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_unlock();
 }
 
-static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
-					 unsigned long iova, size_t granule,
-					 void *cookie)
+static void arm_smmu_tlb_inv_range_nosync(struct iommu_iotlb_gather *gather,
+					  unsigned long iova, size_t size,
+					  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
 	struct iommu_domain *domain = &smmu_domain->domain;
 
-	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
+	iommu_iotlb_gather_add_range_pgsize(domain, gather, iova, size,
+					    granule);
 }
 
 static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
@@ -2796,7 +2797,7 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
 	.tlb_flush_all	= arm_smmu_tlb_inv_context,
 	.tlb_flush_walk = arm_smmu_tlb_inv_walk,
-	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
+	.tlb_add_range	= arm_smmu_tlb_inv_range_nosync,
 };
 
 static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 40e33257d3c2c5..87292a7f094687 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -596,6 +596,10 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
 
 		__arm_v7s_set_pte(ptep, 0, num_entries, &iop->cfg);
 
+		if (!iommu_iotlb_gather_queued(gather))
+			iommu_iotlb_gather_add_range(gather, iova,
+						     num_entries * blk_size);
+
 		for (i = 0; i < num_entries; i++) {
 			if (ARM_V7S_PTE_IS_TABLE(pte[i], lvl)) {
 				/* Also flush any partial walks */
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0208e5897c299a..d51531330f8dea 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -666,9 +666,22 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
 		/* Clear the remaining entries */
 		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
 
-		if (gather && !iommu_iotlb_gather_queued(gather))
-			for (int j = 0; j < i; j++)
-				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
+		if (gather && !iommu_iotlb_gather_queued(gather)) {
+			if (iop->cfg.tlb && iop->cfg.tlb->tlb_add_range) {
+				iop->cfg.tlb->tlb_add_range(gather, iova,
+							    i * size, size,
+							    iop->cookie);
+
+			} else {
+				iommu_iotlb_gather_add_range(gather, iova,
+							     i * size);
+
+				for (int j = 0; j < i; j++)
+					io_pgtable_tlb_add_page(iop, gather,
+								iova + j * size,
+								size);
+			}
+		}
 
 		return i * size;
 	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index cbc5d6aa2daa23..75d699dc28e7b0 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -330,6 +330,9 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		i++;
 	}
 
+	if (i && !iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_range(gather, iova, i * pgsize);
+
 	return i * pgsize;
 }
 
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2be990c108de2b..a2f80a92f51f2c 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -828,7 +828,6 @@ static size_t mtk_iommu_unmap(struct iommu_domain *domain,
 {
 	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
 
-	iommu_iotlb_gather_add_range(gather, iova, pgsize * pgcount);
 	return dom->iop->unmap_pages(dom->iop, iova, pgsize, pgcount, gather);
 }
 
diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index c1a34445d244fb..893ea67d322644 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -340,6 +340,7 @@ static size_t sprd_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	spin_lock_irqsave(&dom->pgtlock, flags);
 	memset(pgt_base_iova, 0, pgcount * sizeof(u32));
 	spin_unlock_irqrestore(&dom->pgtlock, flags);
+	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
 
 	return size;
 }
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index be3f1ce696ba29..b9aa4bbc82acad 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -655,6 +655,7 @@ static size_t sun50i_iommu_unmap(struct iommu_domain *domain, unsigned long iova
 
 	memset(pte_addr, 0, sizeof(*pte_addr));
 	sun50i_table_flush(sun50i_domain, pte_addr, 1);
+	iommu_iotlb_gather_add_range(gather, iova, SZ_4K);
 
 	return SZ_4K;
 }
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 587fc13197f122..5865b8f6c6e67a 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -897,6 +897,8 @@ static size_t viommu_unmap_pages(struct iommu_domain *domain, unsigned long iova
 	if (unmapped < size)
 		return 0;
 
+	iommu_iotlb_gather_add_range(gather, iova, unmapped);
+
 	/* Device already removed all mappings after detach. */
 	if (!vdomain->nr_endpoints)
 		return unmapped;
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index e19872e37e067f..b109c95b5ff53d 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -42,6 +42,9 @@ struct iommu_flush_ops {
 			       void *cookie);
 	void (*tlb_add_page)(struct iommu_iotlb_gather *gather,
 			     unsigned long iova, size_t granule, void *cookie);
+	void (*tlb_add_range)(struct iommu_iotlb_gather *gather,
+			      unsigned long iova, size_t size, size_t granule,
+			      void *cookie);
 };
 
 /**
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e587d4ac4d3310..d8fcdb61e44c42 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1034,30 +1034,31 @@ static inline void iommu_iotlb_gather_add_range(struct iommu_iotlb_gather *gathe
 }
 
 /**
- * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
+ * iommu_iotlb_gather_add_range_pgsize - Include pgsize in the gather
  * @domain: IOMMU domain to be invalidated
  * @gather: TLB gather data
  * @iova: start of page to invalidate
  * @size: size of page to invalidate
+ * @pgsize: page granularity of the invalidation
  *
- * Helper for IOMMU drivers to build invalidation commands based on individual
- * pages, or with page size/table level hints which cannot be gathered if they
- * differ.
+ * Helper for IOMMU drivers to build invalidation commands when using the pgsize
+ * hint. Unlike iommu_iotlb_gather_add_range() this also flushes if the range is
+ * disjoint.
  */
-static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
-					       struct iommu_iotlb_gather *gather,
-					       unsigned long iova, size_t size)
+static inline void iommu_iotlb_gather_add_range_pgsize(
+	struct iommu_domain *domain, struct iommu_iotlb_gather *gather,
+	unsigned long iova, size_t size, size_t pgsize)
 {
 	/*
 	 * If the new page is disjoint from the current range or is mapped at
 	 * a different granularity, then sync the TLB so that the gather
 	 * structure can be rewritten.
 	 */
-	if ((gather->pgsize && gather->pgsize != size) ||
+	if ((gather->pgsize && gather->pgsize != pgsize) ||
 	    iommu_iotlb_gather_is_disjoint(gather, iova, size))
 		iommu_iotlb_sync(domain, gather);
 
-	gather->pgsize = size;
+	gather->pgsize = pgsize;
 	iommu_iotlb_gather_add_range(gather, iova, size);
 }
 

base-commit: 23f3682fd3605da81b90738ad3d2a30f18c46e98
-- 
2.43.0

