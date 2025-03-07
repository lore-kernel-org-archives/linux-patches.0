Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8C21ADCC;
	Fri,  7 Mar 2025 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371455; cv=fail; b=JfgKUG0Ho1oFid7WncG7YQGSHfoMUgGQvd07J1ORqfGXx/wuPUTEDYhcNb1yt+EOkZhYRTlvkiGlZq21xjyVeJn4BBiEVTlHzYmtW+j7qwyPrQCwoJnVqo3u3+eebdIYbY1qNjmd+YzP79TZlsnvMwKaKdRAE7rc4c9lAgNIn5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371455; c=relaxed/simple;
	bh=plj5Oa/E6pWsgPsP1YeJJ+aB+nCBlWOBYtH9orvmumM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=X5G8xxxINJmvJp8tPAHoZm9WW6IDMSGy49piy1feYU3EaYKkTze/2XUBanqySI4NLXF2SNAqXJupvPifCFvYMS3Qf0lPGUDQmTf6GM4uRVTLDV4H/vNddiOxkyRSjuwQGgE6oefKJXJ2lTK1BKK1C8ToG0HD+3KbrIGnG6+6Hik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nB0SIbIw; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nB0SIbIw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzSuPRbObSmSJ5GRx3pD9Ge3Tu0sIkktNXc1uKxXuMvcg7yYmEAXJijv1bcSR6gksxciNxFc4UsV5I/JOCDlsq9UH/qoEqI1PTwOtZgHlNdn4UHCQRMhd2bxETApJ+OM2A5031ZroYsSD35oJ9VpLDusyVrfupeDH0/ntIUPetWu2yuJ9sAII9GeUZ7FrLgb5EQ/Iyf58oKMRBEIBeWaQBfI8AHkfhCbfeV3qB1kPGHdLpyi1ukol09bVB5522995zvomL6jkdJPEmk5Lxo8FRMMFi4eb724O2+CQoQMnILk67gGBntHrfJ/6EeWhrXoclH8GoKulEulmCsjI4k4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta7i+CeYgYCHrc79g1EHl0OuzyG3EWhLH16UVaXWUyA=;
 b=Smz5tY+lICoAVPLytKj6W7RfVxR+ZdFEZGyUjDYrwoOE8dkHL4znA1F6Ci4xO4qrqn0y7qMAS7q5kAI1X0D614/XJtdtEdxs5XMOK7eXV++GJHTJRAk9GIDIFrfN3f7y7ckkCF14u28aCBWmrtg9HLxoyAi2wFGMwX0i43Z914h/dtmjt5GbN5eJE1ucksBHpkVokpmopis9SjQrlKI3L9RItN44Tpzbn+okpQw6lwz8J9sU4nievRFfS6N33esdLkm2UIf9F3gvXvQtoXaFG9s+cvrZyeCB4r70ESQox495sO4+JszbcteZIV8hgxN+FfpbdGqGKjJdFl6Lg8JQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta7i+CeYgYCHrc79g1EHl0OuzyG3EWhLH16UVaXWUyA=;
 b=nB0SIbIwUI5jYv6s+iLoPYVr3SHvjWq7V34wA0twF+oRjPGTncV0b3wX8fUk9G3y2Axn6jop3vmYTk9uqj6IX6MeZ/lxOVmih2CVlCZFdYcTKXq7d57nCRSMMaW7+VQyuSqO1nsefsZ5qklrq7+nvbxRh192GlvlwHgTLWxUKhbR5/zgtgDVRHjVFckPHDwZsOYzZz9XCzIcX79qTdCTGzROkvDMmTG+lSehEmA5qA0vyx868TaSOeKvFLONi7VJ6T5ONy+5ZhKN422JSNS04JhQpbaIcFwOM9Sa6X7iXszoy9KIkp9RYsu0XAhY7pDpH/HTjFHd/HF59U/RvXQbZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Fri, 7 Mar
 2025 18:17:28 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 18:17:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v3 0/5] Convert virtio-iommu to domain_alloc_paging()
Date: Fri,  7 Mar 2025 14:17:21 -0400
Message-ID: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0900.namprd03.prod.outlook.com
 (2603:10b6:408:13c::35) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: c97245e9-6859-4c31-3551-08dd5da451a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y6fxAuiCrconJ1xawK+FwE0XJwo8p7zKK3rQNoc+avoF9GK4Y8RRb2/TD0GI?=
 =?us-ascii?Q?BbqbE2DDy9uCUR/EsGAdlqHFFuItJxf7oe0+iwNLzVUtyeCH931E+2+vz6CZ?=
 =?us-ascii?Q?5SBLbbknH3PkXtYQlNWJ4wBSFLueXn4n99/nNLqGLJGIC55RYrwj50iGOggk?=
 =?us-ascii?Q?qgmnqCeYvLDPUzfeQdEzAtRrmIhCPz4Zwwj4qnmqRsgacxke0JOtf7h2REoN?=
 =?us-ascii?Q?H3lkiBMRPX+H2llgh97hAiEk9ogGB+FZVaug5IHZZK+Rpk+SByIfU0t1NMci?=
 =?us-ascii?Q?dKe2Pqv+d/p94IaGHulw0FenYnYfDWGnL1TxMpbQFdyxsAj8Blunl7HDlCbI?=
 =?us-ascii?Q?ebMKV9eeelHStXruXn6aiG24VgbUYR94xw1+POCQyCAxs7k6SBHxgXdzHdxh?=
 =?us-ascii?Q?FIlTdrmxS/bZsdfmejtRvRPcygNG0nIJPGguutw4ebJKTm/Q7yrNZ1irnI2t?=
 =?us-ascii?Q?EmProWrwGMfFwwr0lozZV4ikfClb67b1lFdgvmKb4DspIgkiZLB5mjE2ebMc?=
 =?us-ascii?Q?5v0ZHwRzzwWxe3/3xPVmy6pB5yl7lk5vEuRbTjtalQT2bFpMIfyYUKKKlgk2?=
 =?us-ascii?Q?Oz65gI4KB7vddO+3ueEjZJ2AiIxg7/DopCoLy9OkkcXer6PuTXuMcxgK4zRk?=
 =?us-ascii?Q?IJ8h9rT+e+ieV0FfvavhDnj472cAG7nSB2Frg7ARzygHnJ9ByLhRO7C6hgq7?=
 =?us-ascii?Q?DUpRQBSd0OQ+lnZ04oHldP7X5du3U2wO0w8oDfH86TLVnoSvHisd/NiuzgKW?=
 =?us-ascii?Q?v7l3gefnAeI96DkIbEm5FsQ24Y2uXM0WLHL/w5NKA4iQzxOC12AL7ClGaHXQ?=
 =?us-ascii?Q?LrnI2MScARvnBSR41bBU4Wk95i/sdPB8i91AaukP3DWIZPlOwH9EUXpMKgDm?=
 =?us-ascii?Q?TiNFSgQbkVIPWZLNaq8M55OHIaPz9WEhB5aRvVgiBRtc9COlLNpmWhcAolYj?=
 =?us-ascii?Q?JghsHpkYC+qc4Qnv/EVX6TG82ygaD4bmEc+/RVKJwfLZO21Vg/Gz45OuVuDF?=
 =?us-ascii?Q?rmJ8j6/yhRoZIFZRoegP0rsUli8WPAMeFJbSByuvCUes2TOqIXRGW4Q1VsQW?=
 =?us-ascii?Q?luxNwC4KA3DDkFywJ8fv3Jv3TJJTozAZnv0XcVMj7FsANdUsGMpZVcqloGGm?=
 =?us-ascii?Q?geGbhds6Epvi0TXit186sB5E7T3vfkVqcNUzFgErQqgd9wP4Gwr0xpC3Hcau?=
 =?us-ascii?Q?Z9FChCtbZll8mNulzfD/O7GbTclApuvBdsRsB/k3meaoCfov/oxgWzKlwrW1?=
 =?us-ascii?Q?ryarTtxSleHU+VIcBlQLbPcRUNa6RniUJJZN5LvGPvILXpNq608k6gKcjMjq?=
 =?us-ascii?Q?b9zxPzoQtZFyTnBp3yQRy3kRQmdkDZopaQsBj8KVXMRTTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B9hnxJHf4JYUv+KXBYd8Pfz3l0BCTQH4j3zTMaZ5ZCt592JcKOpUOddhf4HH?=
 =?us-ascii?Q?XpfYc/MHlso7UJxRl2krNzDAju35V/ykGKMem0Ie0umwCUr80MQTyO7g5sCu?=
 =?us-ascii?Q?H1B6pqrkdXh07Qe20C2PQFSiVfOb8Vpm06Y82bCZW89vSVsCnjiGBPjU8Gmo?=
 =?us-ascii?Q?m0FNh5mGNdXDdGo5C9o8+19ZFiY0bs2Mm1o+n9gaMwMfq8LpVULcgwZhOLmx?=
 =?us-ascii?Q?GXnzAM58vSEms/9w2yWpXTr2p7XKeWYp6y3/CAg6Ls2MS4CwuKhe7Wu9mPKI?=
 =?us-ascii?Q?/sAasC+AvX1cmKaWsZ8DfBRbeAFGkmPU0VsFvlW0Zp5DkRxoopB0OqhnZ++N?=
 =?us-ascii?Q?lEMufo6Alrhy9jnJFrdSW09x/FiO0TP82/6PqlH5diI46FWN4QhtHqjfuIZt?=
 =?us-ascii?Q?R9fziZyTMe5Q4gz6U7eJDMD83fEXSB8cU7DgJCfZilHo8YqPZ3OpRJzHej79?=
 =?us-ascii?Q?us+7thJHMqTIwmKBvnm3YvdwuKFsiIJw7ZOJ/qOgVT2LF+IAetUbXmnZnBs8?=
 =?us-ascii?Q?6MUzsN/T82KnZRVSf0+9CIYysVUtbIMi6Vd08LMMbsJNz131fU/goaqD/FAa?=
 =?us-ascii?Q?DbJSNsuZTBFfQRSfmb04VwVEDNtjMukZykyTgHetMlczVDd3BbsGJ826BWx7?=
 =?us-ascii?Q?RSV1k23tFJxgQHHlAQBBOdwif64pspq6tRlAFxrfIEOnAEK2XJa4N/k03ysn?=
 =?us-ascii?Q?OHFgjWwuWww8YdsT4CX4b29m91YNAPWF5VfGEf6uTWP0MXhJwCKwgNSfzWvt?=
 =?us-ascii?Q?pZS2UIxir1HSwRnp7t/IL4a7S1IzuubaeCA0b2X+ecKrW68I2halAaEZK5Kh?=
 =?us-ascii?Q?q5tcBYgFfxXKtJXbnBJYDdrLDX3c/h8bm+p0bfP+pA3lSTynGPvD3QlP94Jw?=
 =?us-ascii?Q?2eGnvHq579hXskWxvfhqL0j80bwvcxQZS/LAAPuQ1pK2cqiGm6ar29Wrj9kw?=
 =?us-ascii?Q?fLWK6jSF7iRe+ripoq7KhZaa/6Rtl0pmXQoMmySZOS04jhCfF7QPJM3F0uBO?=
 =?us-ascii?Q?z3CN2YRECYdmpeD0eXEm8HYLZe5DRY+7Zo3SSTU9sD74zy2d5znnVjwxLWDc?=
 =?us-ascii?Q?nzxdgpIY01zhyAZaWOWyf+xrbw9eNb+NCWFWfzEFMqcmSkVwEIw+VNSCOxXu?=
 =?us-ascii?Q?XU21F5Bv3mVqqjthTzDElTtlPlPj0Y0+fj/BWv+40ccB3vRjsgepIatbPzKt?=
 =?us-ascii?Q?/YbcJqjp0b3EzlwbaJO9LabtkNoR1l7V2wEPi3eqZwKBUxWAU3ICrxBYLJjG?=
 =?us-ascii?Q?MzagSc+DDdpjUwRwRidlgIn06/38Zm6N8qZ2O4x7hX29EsOwfSW3mkdDLI++?=
 =?us-ascii?Q?poWfBrUl062unqaxKMtZJjJHken6PVnEVQw3j+c/Is+RW3bSwKhXchJrdbm1?=
 =?us-ascii?Q?OcUM5GPIzBKqqTrd+8u9vDdVoBn9hjPhUDsXjVmrk9HMYgXxAqU9vGk0JOMg?=
 =?us-ascii?Q?fTvB+K7a2LXNGMs+wv5ieo7L1cuiWE2X3Uiy1uiWhR+DqPR+nSRlpqHGx81c?=
 =?us-ascii?Q?YpOAw7ymHD+FdlejI5/FdHH8oh4254m5npsdr9fwV7lZuWTub+7xs/29Fegr?=
 =?us-ascii?Q?5SR0T0MJyOfXpEEZD7Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97245e9-6859-4c31-3551-08dd5da451a6
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:28.3739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zi641OAV3rGPAYrPSVg7Xqg1lgjwGpDt8qmmkKHRiT5gBdpdRArdReE4PDGuZgRV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

virtio-iommu and fsl_pamu are the only two drivers left that still
rely on ops.domain_alloc()

Update virtio-iommu to have a global static identity domain, implement
domain_alloc_paging(), and finalize its domain during allocation instead
of on first attach.

As virtio-iommu was the last real iommu driver using domain_alloc() update
the core code to isolate the remains to fsl_pamu.

I tested this using qemu x86 7.0.0 and 9.2.0 with a mlx5 VFIO PCI
device. The kernel behaves the same after this series.

However, there seem to be some unrelated qemu bugs. 7.0.0 does not have
working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works with an
IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It prints:

 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 80000000
 qemu-system-x86_64: iommu map to non memory area c0000000
 qemu-system-x86_64: iommu map to non memory area e0000000
 qemu-system-x86_64: iommu map to non memory area f0000000
 qemu-system-x86_64: iommu map to non memory area f8000000
 qemu-system-x86_64: iommu map to non memory area fc000000
 qemu-system-x86_64: iommu map to non memory area fe000000
 qemu-system-x86_64: iommu map to non memory area fe800000
 qemu-system-x86_64: iommu map to non memory area 0
 qemu-system-x86_64: iommu map to non memory area fef00000
 qemu-system-x86_64: iommu map to non memory area ff000000
 qemu-system-x86_64: iommu has granularity incompatible with target AS
 qemu-system-x86_64: iommu map to non memory area 200000000
 qemu-system-x86_64: iommu map to non memory area 400000000
 qemu-system-x86_64: iommu map to non memory area 800000000
 qemu-system-x86_64: iommu map to non memory area 1000000000
 qemu-system-x86_64: iommu map to non memory area 2000000000
 qemu-system-x86_64: iommu map to non memory area 4000000000

v3:
 - Fix rebasing error
 - Fix incorrect const remove that was from another series
v2: https://patch.msgid.link/r/0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com
 - Remove the viommu_ops.identity_domain = NULL in the last patch and
   re-constify the ops
 - Fix incorrect tracking in the identity domain attach
 - Christmas tree variable order and some other formatting
v1: https://patch.msgid.link/r/0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com

Jason Gunthorpe (5):
  iommu/virtio: Break out bypass identity support into a global static
  iommu: Add domain_alloc_identity()
  iommu/virtio: Move to domain_alloc_paging()
  iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
  iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU

 drivers/iommu/iommu-sva.c    |  15 ++-
 drivers/iommu/iommu.c        |  16 +--
 drivers/iommu/virtio-iommu.c | 193 ++++++++++++++++++++---------------
 include/linux/iommu.h        |  10 +-
 4 files changed, 134 insertions(+), 100 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

