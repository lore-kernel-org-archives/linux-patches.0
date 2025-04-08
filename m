Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B007022F175;
	Tue,  8 Apr 2025 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130165; cv=fail; b=MAvbDjcwkqTuKlkMHbtY9tMtbXNJiFHshtKexkhS4ZMJa4W8O/WaUCzGzGeycOrBSv3tnZTuR7kM7M/gKxHmHMRRWZr/tyIaI5JRqvcsYPgLpnnhq2HMyGCdjQ68AaHzeGUSZtm9DXgNCFnLHJ+o24/yhe96lvPKyXUKZl5U+Kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130165; c=relaxed/simple;
	bh=H2Szh5V+m//EnjTnpa7fgI7MdeO8fnaN/2Et0QTmKFA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=m2UZk4Zyltuo6sKsxVQdpw4Lee3zR/lxyZNgxIJJoCWAVtDRP8BP/rPGSiYDWI/NkUjHNTotsZgju11AwkkKDI5bkz7FLbFzKf1FsVjDF8Xk4si3iE2LcEwLTmK6/t065rQv9Bekns67o6ZfSgZWlzJ4igdMGYiO6zqsyWtSK58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IRtIc/7p; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IRtIc/7p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfkhBUBEVMtspCDR1gR5nFwyS1jy4epTDOQJIZ+tW9X9ZB3r7RizvdJxP9+PwAHYlLY9WZp1bSxcqHSw9W0TssjHaVGtd09gQOW+/oTrsfvFRSJ9Zmfkk1CcVVtWFeebwgScXHOmaWIevXeA5UMBzlByTUZqDyu1lxtRRprfp+EmoZzHOkhjTChJPJ6pxP/bBgqmTYZOQWXtGJyxm5pxVZYxQYmEn56Tu0junJGZSoocpTSKSKTS1nY3B8YzxrSMBiSbdWw+DwmdXn4+EfqDBO+OUxZk+IQt7Husfqoa8w8DbKTi6v0PXoeiu51OhtsjNuPZ9gegcFsyWOyBMevBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASY6IQXbb4S32lRnldo7UHkkFwLUtpA7BdCMwX8cvkg=;
 b=KDwVluqyi9MpVDLAF3ihgmDp8PUcmEve+GYlomQmKGcyCm3SEWx+S37l67B3w7OKT8o9snLJsRB0ZEDlDYr0TptDhS2qjct2y8oesYW2fVa0I/OpT/dynHIWD8Sti17/ldN7O0evcSp2ybNYxm7IDVltBo/r1hfG2iZG56RbltTBS8hOKvGSnJi+XGIIAFX1vaftof8gIzAHjTldc7alv+g8p4D8+cQXvmVF2Dpfd/tm4YxqgpiJ9o+VPANto0baOgzi8gE6yazjykIC6RFOrW2Ps054pGYHs48ccTfoYiOBs2mSVFhxIbmMu+X1XOlpfm8iKhPykT8Z4BUYOe25tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASY6IQXbb4S32lRnldo7UHkkFwLUtpA7BdCMwX8cvkg=;
 b=IRtIc/7pDy+PZT9Vw55NsrvsQ9cPmhokRWlbX8TenRcJuwr9+h6EwApsar3y5ky8XB2GZvBGwdNcvEYYpTNby++XlPssxj9WLyzL3sUUyIKgxikB2K0pHnL6oN3VLOJq7IsFxOehDcqG+E0Dy3480kAtFnbXEzc/VrHydGQiRALG+zdoZO+kZKN++k2BYYPYHmn4YoQ2+GygIYVPhhV0Ofd+4fTgOYzo5HJaFzO0BRDQ2SOb3d6i2s50G6NdZG9mGcyJXExmj4U0AMvJoWQ3Uk7PWiCze4xa33vggsB0yIjQoOBkcc/Sfd+UoGRdBC6hZ4JE6SFXVk3jB+9KpI6IhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9212.namprd12.prod.outlook.com (2603:10b6:a03:563::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.29; Tue, 8 Apr
 2025 16:35:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:35:55 +0000
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
Subject: [PATCH v4 0/5] Convert virtio-iommu to domain_alloc_paging()
Date: Tue,  8 Apr 2025 13:35:46 -0300
Message-ID: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0601.namprd03.prod.outlook.com
 (2603:10b6:408:106::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9212:EE_
X-MS-Office365-Filtering-Correlation-Id: 88534b5e-26e9-42f9-d3d1-08dd76bb6e71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ApuDScWOcyFP9CTKOe/aY36Oe2BCLxjz0n3bIBY+EkBLWdarxP/+RoZ4BHwB?=
 =?us-ascii?Q?8ksU3N4bZ5YFfynos6DQorurG1Sk2q1Lazp4eundU/RuFfGYTSFgIpNqb1PH?=
 =?us-ascii?Q?WWfVwmWL+2nuMzfhZwlgieShmKHy2pZOpobo3Jp3r160Ie5pCaBGjSZ6TPYF?=
 =?us-ascii?Q?vUSQ8umDEqd3ReOkd8X1LbydnWh4HeOew3B8ozcIF+67mnLuo+vsDUSwycRx?=
 =?us-ascii?Q?L0FsBRTN2XdV4UH1M7REoHTSDawjYlRCATWUQi3mIkLX8sa32r14Uq+Fzlaz?=
 =?us-ascii?Q?nf3wNoaSuuUQaNOxDfaw1SkXIV9WIBZlDSA1N1lgtIV4nAr/PlRmO4Aha+aq?=
 =?us-ascii?Q?llwD740UmeaskwUTzbQeJUceLWvw2ulsf8ixWAZ+UM9FPGssyAHZXVYZB5+L?=
 =?us-ascii?Q?4yJNz40s3gM7TPJw+8FsI7ho1mFEe5fMbjWyD6wDBJVFs4XxBeN0xbwP0nJG?=
 =?us-ascii?Q?Mf6UK9hxKv7lJcuCyLCTj4UKHuuUEqGSSFjpI3uIAZgOcwpfj+wR0Hbdj/jN?=
 =?us-ascii?Q?S8R6t6LXUSLMQgRqmqllQIPQGiy5GzwduAOsmg9l5CVd/mKZYvN2+YFqcnxf?=
 =?us-ascii?Q?+A4826tBVby0zo+TpXkTjV2U3QLbysomg+AqLGQQo9xHwahE3fT1GKdDIHtW?=
 =?us-ascii?Q?f0sbMw64EMIzoBNzlZ5+5Em/gAHDsJxzUbb+3cDRRNZRvsuZWn9J5jID+kmK?=
 =?us-ascii?Q?ux8xYD6IcKGqwdmvpFyLuIc999zNEhxqrHyF+c8rzmLdsptYzIUbwj3D+Z6o?=
 =?us-ascii?Q?3oiRed8StGAQdBFK4JRDLHiIJWcBtvFi/LSGYCnrHOm6y96YHlvWP1Pfehfe?=
 =?us-ascii?Q?ywGu7Rrt6rrwFUVXMfJ8iI5CqiENHdEY94NJJ4Z8k3664/pDCVptKoVdl36P?=
 =?us-ascii?Q?gVPD7bG+boWp2cxbLs21C/oh5zFyuNHpqLvxiXNf0tBi46tJSeEbe82qvtm7?=
 =?us-ascii?Q?5otOL13PQx8fN1cf3za/LviMmwJzI+rynyRTGQJAcv5JqRpJGOafsZzWTLP8?=
 =?us-ascii?Q?O4E7PtbpEb/i87+nEtO1iMBXrZHpFqh6h/P5kES7tMK+1JdywWTO56oXgzGe?=
 =?us-ascii?Q?xKjCgyM3gq8aKohMtjTq1T7nU3Q3G9hWD8fGly3eH7VpYlMdE0jJQC4iqmg6?=
 =?us-ascii?Q?UUlgG7Q15iVcYmb33btQ2OE9c2JGRDD8SrgxkRoIIIgq1NU1k8qyhYgr2lHE?=
 =?us-ascii?Q?Kdo7ni7VGRQ2xt1psD2sBXvkhKi916D5k+Q6aLKd/fs2asfiRrfMxa7uXOjh?=
 =?us-ascii?Q?mEVIw/gFE15YHXNLqF5G6SUC7vsNHIVG3qPUYRTM07HlEJpt130A5S5SUhwo?=
 =?us-ascii?Q?6AkH3rxi1QOvEt7+Gpfnyyl2IuhlZcvnLYsXDCCeN9gtBQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MSazZm5hBoHcQEjGpBmNx1NDrjE43RAsj86+IOPt+tZAvt4+ln6a5130ZwsB?=
 =?us-ascii?Q?cDJyeRh4cq7ml8/EUCvjNCLUwgXTxOFx27m0cl48gaZuWeeG6UO9wQZo7r3+?=
 =?us-ascii?Q?yfSoFffkW7gzEfyltVDgBAoaIJ1R+lDEw+/0LNjYINB5J42N7W/jEBuai65z?=
 =?us-ascii?Q?TuDPnDUY1ofBQ1ngareSrnFmcV4JQ6Dm+0ijXpusTZ6ZoFUTeXiOiB1hsg/s?=
 =?us-ascii?Q?mz1I2tZIK2ZB8QmZR5X0gcsX0JO854hJ7647xty+d5SWMtN/5j77JDtPyxrB?=
 =?us-ascii?Q?ZnMSW3YWNKAkzDSeRNiQsvVdNXRSL6j0wxywCzFzhZfeBBkDa5kiBpVYaODK?=
 =?us-ascii?Q?sW7ESA11SnJ5v1bQcNJSOuDA01Jd3hUGAanfORUZlIxMUY2VRyQ8PGhVpLvh?=
 =?us-ascii?Q?5LMaJRZ4Hp9e2bF7hSzw2y8cDx/sxpaPEq2P9ok7d2IAvOjGnfoFyKXSSYGY?=
 =?us-ascii?Q?aBx41d7GqytzB5bn814hQ/BB3vO9XIvCm50280Z/qFnSGVjqWzdRkQGTq4tR?=
 =?us-ascii?Q?QfnOqY9psIQs9jngfEIi+/C27fFld5hE1K7LkF+hu/7f2kUA2qYwpqDfiXFU?=
 =?us-ascii?Q?y7tFFVz05XktMVFsXfRm39tohIQEqD2T6p9kOdXpgwlirpgyK/PgWMMp8Cu/?=
 =?us-ascii?Q?E2CnTcnjHhRqZlGcuGCzP3W9htt4SnxFpqRCsQ4zng2LYb97BH4/QcyPdZZ+?=
 =?us-ascii?Q?HpCGt10ks4PYtds2KiKQ/2Ye41dGPPaS1MUd1M2Cj0Q8ijGfDaWipfYejasx?=
 =?us-ascii?Q?TjbvPMH4dp9DbZsE5nju+lE11Uafcl+mGAilvGZqzboQXm3lnHpaQ5bVp3SW?=
 =?us-ascii?Q?YOkBcoC/RsQjbKHk8Mn7tvwmHUorMLqQke24eqUFhEJnGr97pBa+jnJWeLtR?=
 =?us-ascii?Q?84ekapBUvyX9gpiIJgXEgxMrI0jiEEe9NCo6Gu2g7Istb9dbMVavFJ0vjGBZ?=
 =?us-ascii?Q?E6gryHmEO895Mmtl0Ytgu+rept9c62Ux9BE9pEaoGMRdgR8YvNZ/dCKjcXrT?=
 =?us-ascii?Q?/gpbqVK4lc4Q7UGaAAiQyfdhXcQPBznbQRXDWtzobLWOK/DtbHECObphNJeA?=
 =?us-ascii?Q?2P/yvfNZnUeaeALHyu8pe6TuiE6z9WQ6HJ0YXOOy5TTTMIlLXpiElnmLmyIu?=
 =?us-ascii?Q?RES4QqbK7DvXs9Z54p7LNaTS3KjjsyTWUEmquXo3z8+Uea8UDtF23CeTCyqU?=
 =?us-ascii?Q?5GI5/yU+IailSbS4oomItSUfcW+NT0SXR3ULCZO/7AqIa82Ha9b7YXVerSLU?=
 =?us-ascii?Q?Bp4pdxEydEUTnlalJPbOIuGjCNd5asDeGYUsDwoO2jDvuje3chHZAME+9/wo?=
 =?us-ascii?Q?w+APtC+Lky5r3vDe2kF0R3XojZmBSMV/kY6xnvt0mAsuhpd63QdLWG6KmcEQ?=
 =?us-ascii?Q?cVpx1Bqiy4pen88zWny/BrOW3hkbBzVybo07BVSQEMazxWyNBA0gRCy0fYfg?=
 =?us-ascii?Q?KVFoe2Q478vFUq/GxtC/Ei8SDe5vR4PVuMtS9qCe4HgjjQ36LLbqrU0BYNxz?=
 =?us-ascii?Q?GIm36LvupJN9yNaJSt4xpRUBEgfSZvC3xgg9eIeo10c23WDgYw+waJRMIWRz?=
 =?us-ascii?Q?pugYDqBU0duVHADjrIcZ2GIEOPB045yXd7nHM9j4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88534b5e-26e9-42f9-d3d1-08dd76bb6e71
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:54.2868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BxBPhsK0Qfl1SDcpre2QHj2ZbM1Qjg94ZNapChBtI55e6o8wk9jUz1+ynqv+OQaI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9212

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

v4:
 - Rebase on v6.15-rc1
v3: https://patch.msgid.link/r/0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com
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


base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
-- 
2.43.0

