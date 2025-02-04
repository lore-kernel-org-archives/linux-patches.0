Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F39B218ACC;
	Tue,  4 Feb 2025 18:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694121; cv=fail; b=q3iIgdVQ0PVy/fyDvwwKYPEFF7g2BwUSOd/6wrE3MN4j//7h0goBS5bSh45/GANvvIdne+Gj6SXt+9OZ88chU12xjtXhKT1hIGoI2qlCC2ANevTfl/aMMM2TtsA9ZLVTGJ1RuP7bxwI0U4EwdmeP0vqDaxvtHoS0KNKvTyH8Igg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694121; c=relaxed/simple;
	bh=zDzX+G8j/BAjPkvi0tkDLBidKCrGDY9Y1/KAx7DmUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ebGexNJzXlJcyGnT1nuIgBdtQ4NmpRnCRYC7YRTZAuRjTs7MEu0yNJxgIcbbhrq0+YxgbmJwgYuAiDVo9OR3Pkfrt0gqbCliozdjFX8lorJtTME54zlYDgUFmge9e4aFm9/2sJEvH/QMAMVTMUmwNGxcEOC2CYZtHKg7RkToWo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cEfGD+Xr; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cEfGD+Xr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bq494OBm6Am9nUA2fweUsSfH2iiZY1K3OaqOO7csnvsUVKX+DE2je2lAlFvtSyJUETfJMgR2Xe2FOnBYaFYkDv0poP+EH7mmmnna1rYcut4L05rW3SVuDBFUW0XSn2nIe2J1xjFHHPYdxVJKIXpfLuwv9Stw2Y4aO9wHc+RX9ciplwFbcfu9kckruD5CRlY6PTqrKO/yv87xp/xSzNC8dfUeJ+cYNs2JpSGBiiIuGY6/RF9CLw2SozPsGhXdyNQIjOBQdo6K0/Le54DuIeyPHeqWWMYZA+yznlGR0BWcUvw0qT3MSACTaTcfmFv+A6op3W6nIwf71bRdS3K0qq5AtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUs7YNq7X7OVVnvw1bMuq+cIhDHdPe/00qWrT3ifJ+4=;
 b=gGha0cg7p7U3lu/HGb6gI/5waulhHRXTcOAaMeBL6HIjm1oIzoAR8G6uyGlwzpZyAPTDvW5fr8HeBMNHMCCmQNJLoXPnA3XKttPDXBxTgkfHZNUragJFgTPmkktiHtSnP+dIK0UozzuBG9CRbw9wQwOwvRkO4WbcylePG8iU1/8QQ4s6wL14weFubYh9DZU2ytv0gX3RZTe7Eaj5xbIbkLNuuiIV3E8aeedEaLPOwjPYevDLWqerMCDPsuNw9eLwBHbO6ROfBeB/xth28KUvMAe54v+3sFSo5aQa0K2HGaAHtB34dcTq5KScztkTuNGJJN3T5Ol0ZAdnuEHnBN3CRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUs7YNq7X7OVVnvw1bMuq+cIhDHdPe/00qWrT3ifJ+4=;
 b=cEfGD+XrVNCRZHHfARv25IM5x22KhcYgLze0dlwuiiny7XmZO76vVYc7UO9ZpEWyiADmBmxxaqdIp8AfZUSJjcvsHYLHb0c/2dMX9Jn3/pjjmhYx3YH/JO9WaAyia6HH2hRpeMBB3tMbXM/SHIkEuUFLY99VzDz4vprHOmePkDfLK248pmu9SS06sdWQK25CHQSgRy2ZS1yD59oenAjSzze2XZdIQ822t5BrbZS1ReNhR+ATnWicMLzD0gCAuGglCzVjHzl5b59j0VN0Y6q20yl/x2kxVhPwetADYGhUVxz466M4S1ypg1u/1XzL0wipevAVTorRRAIObk0sXWJJ6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:07 +0000
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
Subject: [PATCH 18/19] iommu: Update various drivers to pass in lg2sz instead of order to iommu pages
Date: Tue,  4 Feb 2025 14:34:59 -0400
Message-ID: <18-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0009.namprd14.prod.outlook.com
 (2603:10b6:208:23e::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 1816033c-2933-45f8-3a92-08dd454aa3be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zy/1A1OAPXMveBPo+wc4XGWKeDfU6FSMpfWxOWqL/UoZ+ddtBORV0Aq0LMDf?=
 =?us-ascii?Q?VcV9yZqs2M8wUTtF9pXGsFCCj5lCyau/RbeVuzJLiveJ3cimK98DTNxliQBv?=
 =?us-ascii?Q?NXWk18tt8LxzGy2ZgrPjtH1vv992hzS4wcZSI4ZpfZOC50tKeVf8PYQNrE3w?=
 =?us-ascii?Q?1oKEi/zLizLxkZV+NgrqVGUKXkol9D+O+HA6xKgr/EqBOrlB8IRtXWgFJwl4?=
 =?us-ascii?Q?iNnuJRHUwqgSncDhln9g45FXNKXaAm0UZRrhtDuKzoV5Abyk/gVvShJ55B+C?=
 =?us-ascii?Q?xBj1IW107fdKeKc6SM34+KlXuwrOCIepHjyDXAuGUbBTjNA/89+Bp1sA9nUR?=
 =?us-ascii?Q?TXy2abD9/dcpc6n38Y7NCuyxZcYIVp0epecWSinHWO7mOpbDwc/txm5fUP8A?=
 =?us-ascii?Q?ilIhdTsIz0JB+a1Zhm3umXjk2lAct38S0TAG9ql6ry6RAc8OIJxn9/s5AZUd?=
 =?us-ascii?Q?8wd8Hja4KE4mxoA3wab/2o0AzK3wUUtQLHWFmZUv+tioBUBl8NX+NkvrubmZ?=
 =?us-ascii?Q?eCg2Lv6CLwgo1z+e57KNMX7y5eDKVbOYcKqlYCB3z1UPhSJ+1sXheARLCf+U?=
 =?us-ascii?Q?ywq2OcYp7GOtf1VPLM/K196kM/bm+UVdwlQq95evPMq+ozSfvztbz14ZDxed?=
 =?us-ascii?Q?sQwabOSZvDCeInn0cUX8Vi20HTCUSswKDwY/fHC7YnIkLMzcCGmxik+ASXT+?=
 =?us-ascii?Q?gvqTJwAApCAcqRwLc4hxnjM2c2ENSD4Acbb6RRJdgBO8b7irrV1Yfi0fqdqn?=
 =?us-ascii?Q?DDZSW7VuwTQ3wIvRCVFvusHixYll3WpLApH/DyvLejgDpQF+4CRPb94/Pf60?=
 =?us-ascii?Q?stbWJsmt2OEVGzEmpOXMCeH7IZQQ1vejMX9cS0rVgbd+rMMUMtK/MYmlOzbl?=
 =?us-ascii?Q?oij2nPTs7NpqzqG2xyvBAA59NtQQk7y1CN8mI4WYw0CL3rWQVS4Xyuf8KyYQ?=
 =?us-ascii?Q?6og6j8RjzG9ADlbMtLYIYbUOlU9FacLpUWByi8wwgN9izQIDhm3CqgSEV5m7?=
 =?us-ascii?Q?YuzuzyuLOonzfqm1ZOnVCJsUazHDpVGG1c1KF1TK7n4n5UMDmQgeTww5rMq4?=
 =?us-ascii?Q?6VbgK5pIP5h5TDJx5mJm6oFXhf5rggu7xH+jN1VcqKyExRzujG66qIyx0Rm9?=
 =?us-ascii?Q?3EZqYMruQ6j1EHR+TOtA9Vls3f07CPU2rmKkkb5eAMhhkOQ+ckRYrCR9Chbb?=
 =?us-ascii?Q?Pd70dOBuX6kO6F6HpRqaf3b2nSGcHpeoD4HL4zHuASMyH+5GrUHDfLzG+9yx?=
 =?us-ascii?Q?GbKMhPlcUw3rHWe7zPfQnJNPgl5vREdBvnQm101+uKgzKzmIOLf44cPEgdnD?=
 =?us-ascii?Q?rnQulnxAMed8SuAeR/VBcLRZBNNkojr3F+/1n8u2L7Dyt5G7eUG9Q152SCAG?=
 =?us-ascii?Q?ep5WDHMS0ITOzwcm3JZA8UecV5wlO61S9smNoTkw5TXnjoJFBog7F6NKVwHn?=
 =?us-ascii?Q?JBo1SpsQT08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?63xIVvAU9sbDIVTtEpgZyo/8/4rb8HnPmPoFV6BXJD5Yy/z/n+SQuYDsPM/V?=
 =?us-ascii?Q?4Qz9B90wrAe9h9ofm3uxE6DNdlwE6vnS1TatQmue08ZSHNYwBGLGeZGkKlHL?=
 =?us-ascii?Q?5qnBULU4r45Aq+fw8UqXjnCnK/lW9AmxoQvDA8cRXK/oQwHOFnXbo5WQKzM5?=
 =?us-ascii?Q?hdzsstjQVCo/8kt0MTgOjizWxW4VWm76e8b6oNmoWON5zcNDHrOcrlidj15D?=
 =?us-ascii?Q?p3v/Cx8E61UKDtgiF8rp4X0eiFd6tkhddUljDrX9MiPwzXEx3xKeyIcwhrAC?=
 =?us-ascii?Q?PG3iJfZp/0VHRYwdke4n1YWXm3utjWNqFCZKMKewluCA59Snmj5Dl2MIjd2F?=
 =?us-ascii?Q?K0UZSfXZm5H39EhROq3b2v0QFrv7nIoGKncnSufydhmp6hHb3Fv5PsFklV8K?=
 =?us-ascii?Q?mjmI4QZK4LnD57YEwoe6pG9o0F+XseKZwEpo9DDyGmmJGQhHvdQO2Un4gD+C?=
 =?us-ascii?Q?nYhjvw8PFlpsxEXcTEIqhImgEjRf4endPyao9ei1ov0va/PK5PSsmv4aqEZj?=
 =?us-ascii?Q?UUI54zrKMCfX914dJmHnWm2+xLEC35XqXiDzDEm+O31bUDYrMYKRN7qB//qZ?=
 =?us-ascii?Q?RCdtUcngzlUAuabcix2yUvz2oaKEhBd4agdrEcD+i9nhCvwIWeVq8fiazNov?=
 =?us-ascii?Q?Ja2rDAxoyxEoJh6IsryFnwUiz08J+MxQiAijr/2e0mG7BxGZJ7m8v3H58EMk?=
 =?us-ascii?Q?TI2Kc8lY/0D7k46L9HD+RIH50bqcHLmz0v59nQKIJ/AqBXNA70v5BdaeeiAV?=
 =?us-ascii?Q?O7Du29iyJbOPY6dGAohgYZrewzueACmR9AKvFimA534kOXy4wuDR5Y4YLcKC?=
 =?us-ascii?Q?yklhZ3V85njIsmuDZksy2OIQITIuQGfZI5lT8JsDRHlB0nyXvzQFRBXnZJe2?=
 =?us-ascii?Q?z+LpshUReSRuK0nnUO7F9d00xRgj7OQE9xc3sweAB15GXe/br5g1oA/FjnYa?=
 =?us-ascii?Q?veuKL4DaQggStfOhPVCL5WR9F/2AhUO3BQdEk27YExz1fWCijhRF6Wx/J8Q7?=
 =?us-ascii?Q?bpjoSILmBa4Kx+JNfzvYAX/x0dZTCsZQtMZ0q9L2cEF1uvwUSLAhZDh7cyFS?=
 =?us-ascii?Q?y640n6z8Mof0CGuybMN7d0oFhyqatQbv+ae64hZ9Octo5zsjZwbUO7R0+UOR?=
 =?us-ascii?Q?v6qTINRRDFcycKs20K6udiUwFbS6FFFrN75Fyd8jON87DuZJhdovh+Y2TLjW?=
 =?us-ascii?Q?B7KhdJ7IDx5TPkCJWkmZavVwGZ32k1sE7/hT7MBl079FnWCGrwXvuzxJNB0/?=
 =?us-ascii?Q?Z17gaR2eyQEIGmYyCj34TepEGbSHUnGt2qx/2QUztSK/QtOBVnmNtbo9/ZBi?=
 =?us-ascii?Q?PBB88R9NVeAU6KmhKBzL9OAyNbC6pCqpS01gZzkLX9n1JmBJAMmZbK53NudO?=
 =?us-ascii?Q?8Jr2w+mBcrV/jnoL95acEbio4teeDdBM0O7xwd9CkAriSnCjk8yC/QRKuMri?=
 =?us-ascii?Q?io6uEqz9aBKSMMkg/kdqJESBfr3ORO8c9Smmqk/yYHq8ye2sFfrMuGGIF2e8?=
 =?us-ascii?Q?DT05goPr5yBJ4Mkk2E246ghw74tzDu5pV1Q2bydi4PqwFKzgfH3F1m1yPeLu?=
 =?us-ascii?Q?tqcG/Yq051h+bOIR1SU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1816033c-2933-45f8-3a92-08dd454aa3be
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:03.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruTbsMaf1g2yrfxfb1XIysGpuk8wf9AUYrWqqApaJHydJ+GY+9AkVWMfgamV651P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Convert most of the places calling get_order() as an argument to the
iommu-pages allocator into order_base_2() or the _sz flavour
instead. These places already have an exact size, there is no particular
reason to use order here.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/init.c        | 29 ++++++++++++++---------------
 drivers/iommu/intel/dmar.c      |  7 ++++---
 drivers/iommu/io-pgtable-arm.c  |  4 ++--
 drivers/iommu/io-pgtable-dart.c | 12 +++---------
 drivers/iommu/sun50i-iommu.c    |  4 ++--
 5 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 7d77929bc63af3..70c038a80874bf 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -640,8 +640,8 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
 /* Allocate per PCI segment device table */
 static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->dev_table = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					       get_order(pci_seg->dev_table_size));
+	pci_seg->dev_table = iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32,
+						  pci_seg->dev_table_size);
 	if (!pci_seg->dev_table)
 		return -ENOMEM;
 
@@ -657,8 +657,8 @@ static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 /* Allocate per PCI segment IOMMU rlookup table. */
 static inline int __init alloc_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->rlookup_table = iommu_alloc_pages(GFP_KERNEL,
-						   get_order(pci_seg->rlookup_table_size));
+	pci_seg->rlookup_table =
+		iommu_alloc_pages_sz(GFP_KERNEL, pci_seg->rlookup_table_size);
 	if (pci_seg->rlookup_table == NULL)
 		return -ENOMEM;
 
@@ -673,8 +673,8 @@ static inline void free_rlookup_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline int __init alloc_irq_lookup_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->irq_lookup_table = iommu_alloc_pages(GFP_KERNEL,
-						      get_order(pci_seg->rlookup_table_size));
+	pci_seg->irq_lookup_table =
+		iommu_alloc_pages_sz(GFP_KERNEL, pci_seg->rlookup_table_size);
 	kmemleak_alloc(pci_seg->irq_lookup_table,
 		       pci_seg->rlookup_table_size, 1, GFP_KERNEL);
 	if (pci_seg->irq_lookup_table == NULL)
@@ -694,8 +694,8 @@ static int __init alloc_alias_table(struct amd_iommu_pci_seg *pci_seg)
 {
 	int i;
 
-	pci_seg->alias_table = iommu_alloc_pages(GFP_KERNEL,
-						 get_order(pci_seg->alias_table_size));
+	pci_seg->alias_table =
+		iommu_alloc_pages_sz(GFP_KERNEL, pci_seg->alias_table_size);
 	if (!pci_seg->alias_table)
 		return -ENOMEM;
 
@@ -721,8 +721,7 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
  */
 static int __init alloc_command_buffer(struct amd_iommu *iommu)
 {
-	iommu->cmd_buf = iommu_alloc_pages(GFP_KERNEL,
-					   get_order(CMD_BUFFER_SIZE));
+	iommu->cmd_buf = iommu_alloc_pages_sz(GFP_KERNEL, CMD_BUFFER_SIZE);
 
 	return iommu->cmd_buf ? 0 : -ENOMEM;
 }
@@ -826,7 +825,7 @@ void *__init iommu_alloc_4k_pages(struct amd_iommu *iommu, gfp_t gfp,
 				  size_t size)
 {
 	int order = get_order(size);
-	void *buf = iommu_alloc_pages(gfp, order);
+	void *buf = iommu_alloc_pages_lg2(gfp, order + PAGE_SHIFT);
 
 	if (buf &&
 	    check_feature(FEATURE_SNP) &&
@@ -927,11 +926,11 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
 		return 0;
 
-	iommu->ga_log = iommu_alloc_pages(GFP_KERNEL, get_order(GA_LOG_SIZE));
+	iommu->ga_log = iommu_alloc_pages_sz(GFP_KERNEL, GA_LOG_SIZE);
 	if (!iommu->ga_log)
 		goto err_out;
 
-	iommu->ga_log_tail = iommu_alloc_pages(GFP_KERNEL, get_order(8));
+	iommu->ga_log_tail = iommu_alloc_pages_sz(GFP_KERNEL, 8);
 	if (!iommu->ga_log_tail)
 		goto err_out;
 
@@ -1026,8 +1025,8 @@ static bool __copy_device_table(struct amd_iommu *iommu)
 	if (!old_devtb)
 		return false;
 
-	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-						     get_order(pci_seg->dev_table_size));
+	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
+		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
 	if (pci_seg->old_dev_tbl_cpy == NULL) {
 		pr_err("Failed to allocate memory for copying old device table!\n");
 		memunmap(old_devtb);
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 9f424acf474e94..ce87cfae4eaaa3 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1681,7 +1681,6 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 {
 	struct q_inval *qi;
 	void *desc;
-	int order;
 
 	if (!ecap_qis(iommu->ecap))
 		return -ENOENT;
@@ -1702,8 +1701,10 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	 * Need two pages to accommodate 256 descriptors of 256 bits each
 	 * if the remapping hardware supports scalable mode translation.
 	 */
-	order = ecap_smts(iommu->ecap) ? 1 : 0;
-	desc = iommu_alloc_pages_node(iommu->node, GFP_ATOMIC, order);
+	desc = iommu_alloc_pages_node_lg2(iommu->node, GFP_ATOMIC,
+					  ecap_smts(iommu->ecap) ?
+						  order_base_2(SZ_8K) :
+						  order_base_2(SZ_4K));
 	if (!desc) {
 		kfree(qi);
 		iommu->qi = NULL;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 8727d8e1e02f45..0e1dd519c3b9b3 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -263,14 +263,14 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 				    void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
-	int order = get_order(size);
 	dma_addr_t dma;
 	void *pages;
 
 	if (cfg->alloc)
 		pages = cfg->alloc(cookie, size, gfp);
 	else
-		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
+		pages = iommu_alloc_pages_node_lg2(dev_to_node(dev), gfp,
+						   order_base_2(size));
 
 	if (!pages)
 		return NULL;
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index a4cbd8a8a2976e..3b57d14baa9c1d 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -107,13 +107,6 @@ static phys_addr_t iopte_to_paddr(dart_iopte pte,
 	return paddr;
 }
 
-static void *__dart_alloc_pages(size_t size, gfp_t gfp)
-{
-	int order = get_order(size);
-
-	return iommu_alloc_pages(gfp, order);
-}
-
 static int dart_init_pte(struct dart_io_pgtable *data,
 			     unsigned long iova, phys_addr_t paddr,
 			     dart_iopte prot, int num_entries,
@@ -255,7 +248,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	/* no L2 table present */
 	if (!pte) {
-		cptep = __dart_alloc_pages(tblsz, gfp);
+		cptep = iommu_alloc_pages_sz(gfp, tblsz);
 		if (!cptep)
 			return -ENOMEM;
 
@@ -412,7 +405,8 @@ apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
 
 	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
-		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL);
+		data->pgd[i] =
+			iommu_alloc_pages_sz(GFP_KERNEL, DART_GRANULE(data));
 		if (!data->pgd[i])
 			goto out_free_data;
 		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 3d77aed8507373..d0e515bf5dd1f6 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -690,8 +690,8 @@ sun50i_iommu_domain_alloc_paging(struct device *dev)
 	if (!sun50i_domain)
 		return NULL;
 
-	sun50i_domain->dt = iommu_alloc_pages(GFP_KERNEL | GFP_DMA32,
-					      get_order(DT_SIZE));
+	sun50i_domain->dt =
+		iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32, DT_SIZE);
 	if (!sun50i_domain->dt)
 		goto err_free_domain;
 
-- 
2.43.0

