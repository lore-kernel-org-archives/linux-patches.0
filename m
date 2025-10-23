Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CB73233EE;
	Thu, 23 Oct 2025 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243768; cv=fail; b=ogKXaQDisGKtHom5PoPaqOM4XVtiIY6WcBUtPasZxQLA7+P9oY9syt/WlIQMbORsA5PCs9yVX8PVdJFnZEI4F9ljCCXomJb+1a1JR/3V+foP8orUvvkOBMRP3jqsfqpLYG5CMY8+5Qi1GzpMKC+iNM8rgnh6+WBKGHHnc+bfkLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243768; c=relaxed/simple;
	bh=gyFmXXqX6jDl9N2nwfgJJ2H2lDc4io+FSDdatbyjygo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TgncJ78gX29IjCAYFbh3Mbl+uhKvHLoPTwVjCy7lwxDAL1IrUt0zTsr3X+ZB8kFF9VYoRgc7kgtXQ6jn2CVjJ1GgGlnTBwvf4PDDN5+9KChpCPk8Af3NbcUGhuKBZ0OVPD26C+ksri6qFbA749Pl/DFpr8d1I/zDnKqxTpFLS+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NFFCI05o; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NFFCI05o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxO9lZ/XnZqC/+mOUJI8TXVv/AQ7JJa+zcRLTVZipJ918DCm5fYDSniupEXIRB5NfUWpQtF12wQJNM93hGNY1AkDpAaXD/xZWJan8efuwA/+2VtB7b1NMLCIksYaKwaFk/ywApRSPKdUDiOdKqqueWrLjXQD3s1bbrIVdl7NrpPU/T2vo66oOneI0Z7ymwBViNAYo4HO6ZtTZ58zSjavAebJqDWLPbGlWITg/gy6FEwJ1Nx00YHIruOCHE3HO4+qq/6MN6GBkRDVoI5yAPNM4GjMRfZAcSca7AZmNDk0InMtWbSY7V0pSZgoxJPFMVOtVK5ZFQy78VsAb8nz/zRD+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUClh5n4fr1aKVMvdSEfXqZwPiSfxXMQogXttiO7fpM=;
 b=adXQExosRaHS8NJTWNt884FPuyaEeEPd5t4R4I7mZNTTysWtgr0fky4191mi8leIarOnAEGIdYHHrzJ/ebxrz+tkK8h90JFITnsKYx7RdGte53QpiO04lIAlxqtZuZ8jHr8+IUFrTJbIIEKoCEu2q4VacG8/3hs1zzMP9xIVA1gpcA67gdvzZJ+2kq5NIV480i4hBc46PU86Eyv6Lzb3Fnw5do9rz52hmPJaW9qlSHnNbK/XMBj9++1WYYXE8mIWM1an7VjVIllDH+ipIP1/GWPykZcaMSZz53XfMbenmWcYkijse9x2iaIkfd+qGS8OIj4CcgNv2x2UbZdMwbr9Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUClh5n4fr1aKVMvdSEfXqZwPiSfxXMQogXttiO7fpM=;
 b=NFFCI05oZVLgZXiIviqW1A6aUj2bLFN2I5CmJIrhQ91tL/S5NQH2PB15weMuL8ziMsgBQMtPybyOpuZqW2eD4Cf1SVL1UQ7iivSz34WF0yrxEgletb7eFKY1RuU0J/K7EsT+xhk3yiTGGjdSJOalHB7OPGTf/1ObwOrWN6ayegnX+dbB/dlnpFc36tIyQxeLM0+GpZ/8G73OowT7rNG5zWCiAn+xNbs+Dmtn4gTc0HbtP5tolprawwgRUgcZ9Srg1LrRlBJqTbgqQTGpy5inHxxYKfDeBqyoy+vWSnaPMZdnMQxK+5OVrDnCFt/gUlTRNrAq6Wd3lwgucQxLSEn+eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:41 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 00/10] Convert Intel VT-d to use the generic iommu page table
Date: Thu, 23 Oct 2025 15:22:28 -0300
Message-ID: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: cd3fe103-e3d9-449f-3ad8-08de12612708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zc5/6eXiT2ynSFZApvGMCOYaODsWUPZKn4FJaO8VL/N15Hr9RkZu1ailxNPa?=
 =?us-ascii?Q?IaMSx7D/cEZHlcNvcr1SDeh306QjD/bDo137ltUnCOo2ja1VSS0JjHPbqI/f?=
 =?us-ascii?Q?kokli5Lz7UrF+Hs/H0COxUNIZS7Cs28/H6NcLyCrDMmtMxHyv2uqv3zK9TtJ?=
 =?us-ascii?Q?hWyB8tPBYlgeBnBqKZoRORFc87aqrv/iUiKbbKckQAt+5MXJ5nv+pcDuHVaO?=
 =?us-ascii?Q?9g4iRJSiI5kuEr4ke38/FS5A6tI1v0J1rgpvhdiN78T1DUtYoCryT6YJsErd?=
 =?us-ascii?Q?MhJiu52M0UoEy8nEMJOFOxuf1+5SlTt7RMlMqh9Stl+GbB7MI5km1kaCzOFb?=
 =?us-ascii?Q?yiGDiMwEkINiUxRBpFa7Emtzwd5YOuPLJlCjIXED0NHqurxj4u5rshLsB+T+?=
 =?us-ascii?Q?tHLBjJonrQ3lJLP8GBIp4IDidZIntvC2xoYpngua5bY2rtJBxKVKl9xsAbCf?=
 =?us-ascii?Q?wDSxWx2QesTKarc1m5Unwm5fh3W4ajTiq0KCLX6HvgerJEFtM26bYJhiCPqp?=
 =?us-ascii?Q?5vtFEZPam1nA0N8ZHHbHmTzE2kFAfhD4ddrUHl+N6+vAA+Ms0ohWDxTROz9s?=
 =?us-ascii?Q?MWKehZVCvr+tm33vaFOPsqFS/e1GyF3+HdWBFSqzpnndKonwfsUnG4FMxhxp?=
 =?us-ascii?Q?WxF3sESy9mXPgccC1eLA0LuPXiRgyuMON7+Mjxxe/Xx+ppCM8e4nqqYrqstf?=
 =?us-ascii?Q?fhKjp82OKZ92peWcpbIn7kRcB0cR1Q7nfW3FEllH6L65hkq/yRtgG0uv7zWw?=
 =?us-ascii?Q?7v7cQ/Gl3qFbl9YftcdOdqoBbbcZwdovQ2NS8ct4z0/lLvN8Sz0XMrNKRanV?=
 =?us-ascii?Q?NLxdzIzxL/kt1jTnLRNvFQqALU6rn0id9xA7eiqQQjZ9OCWTNWnqAQnpImiP?=
 =?us-ascii?Q?SGY77yREFH9lqsjNtHweBAff+za9+OaENea7hQfqNRFklsrFI+Kr6z6DnGOb?=
 =?us-ascii?Q?nyQ2RicpXNYtDy2KUzpxF6JJrmKKQ///bLurbslwxnhg9rBI9QFKsjISn+kw?=
 =?us-ascii?Q?GRi/LMpYKM8FNmfB82cBuYgseL1R7O7tfp65F23eTl2Rk/NaC4nE6K97HAkF?=
 =?us-ascii?Q?aYa59Q7uddXAFoc5lIGe3oBBcgVdRbMZfN7XjE8yh2sucl+2dIlAWGx3bI1m?=
 =?us-ascii?Q?X6f2gJh/9mrDMHDOepWHhLHjlSNeiNqbdZKyJ35apYDPvlooYjRDs6KBR2Kz?=
 =?us-ascii?Q?1+ti98B0CxXSbjvzOs9KBSW0SIkvCXtesSnRjMv9/ofiuCBTwezR6MNf7r6D?=
 =?us-ascii?Q?uGmemTJ6xWFqjxc2JWWmc7Jg6zmdO2Xg7J3PGRiOmDjDHleCrkuSeSWrV8ZT?=
 =?us-ascii?Q?igd9PuwjG+Eq95y+ScaEPHnVnRn0eg4ef7+j6XRQ6Fd5UT45yXsqv7jUAzvs?=
 =?us-ascii?Q?UDsBUxlARiqUQubVToLVDdroZ19dM1phLtSmQN8FbcZ3p3Y0i65vU7qe48Z9?=
 =?us-ascii?Q?Sd8tSHmVxzX7qEj00uT57SrTL+caxiFF4sCoT7ifZwOwl19Dr+/pcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g4h9lW5N5dFmPTWrtNPaSUuTNRUialwscm/S2d3zRPOo2CMvEGmE/Ljb4L0m?=
 =?us-ascii?Q?Xrsul2AiHe1wNuCMXMBagIw1bEN5FpuKHSVFF4sOZXerY8iMcAgW/JaLSvJD?=
 =?us-ascii?Q?A3otuXijWDn4m/gl6YrQO+uuO1bVZW3gSigQegRFBm5qms7LkhnPXKBqEIqf?=
 =?us-ascii?Q?Ebw2nXxp9ehvxuF0V0X1uAX2yXgPHVuuiaBcs6PxTBUdINpvodwPShtmTByA?=
 =?us-ascii?Q?T/k7Sy2sT95VXbvYrlN1Sabib1k9o0wbrrP4aPBkc0BAt/YlcIwzbPJoY6oD?=
 =?us-ascii?Q?IlRFNbvz2HQ8l9M5ix5eXKSE1lltHmIJSNCwyQ/+P0hr4d+cyXz+GqS6tu0z?=
 =?us-ascii?Q?N9p1yrxwTo+KutyaU4hyl3r+Yz8rsEfIjYHy0D/VB1pul0387g+cp56gRAWC?=
 =?us-ascii?Q?VWhQsO6XRBRs7AZGzJTXe++LfJXyLnfapaBL0RLFEbM7o9k+SO/wvUJXqhXO?=
 =?us-ascii?Q?OE+Ij7AzsFqRgygZ1t1e+gQxz1dPgtML07p2lSLPdKgERD+vESnzGSgBY7+s?=
 =?us-ascii?Q?W4K72LT6fosnEfc3KKMA7eAqdPIBgyKvgW/8/ghux2z9LpB+urAPx02xrL9W?=
 =?us-ascii?Q?lNwFZDhvLOsWn/QD+RqhlStS3IA2Z3uzQWCjtZ+5dX+p95NFDETwx8vRmK1X?=
 =?us-ascii?Q?U/VfJdSdH6JCzLk4C6/4cU09b9R7dh4n/n4+0HMWZEFwGmp46GbtKwj4WET2?=
 =?us-ascii?Q?r2K6jNl+02tY7UfWySQ1BR1grDdDYm+scuaoL6giIpB4Wkezrk2cNYC9Q9XI?=
 =?us-ascii?Q?yPkKryUerYipi1XG/cSFJPOfyrgcbA/zW7MM3JTfdrdKy8q7b32E/8B6TkWJ?=
 =?us-ascii?Q?lVlmjHOEe19UOiINYpBPoXRb2oYe/UpYg9cUHA42meiDnlC2xvf/FhMXy3qs?=
 =?us-ascii?Q?b8mcvgK5PfOvi2rrZTguH0ssDJKoFtA+aqu7gL7SqodYqVWR35Y1A9QkmdBj?=
 =?us-ascii?Q?5fYKUwhAkerdOZKIxWcir/cG5/rHQQ5so/h6NNB63H7pnRw65PGgQig8Skws?=
 =?us-ascii?Q?X/mJHtVEiOH1yvtm49753HuKQ2assqrloNTqDRVNbP1Lpj03Xpto8a32/s9m?=
 =?us-ascii?Q?6sfMI3P8T3oTtTBla51JrS3liktMLM2EWuBHutKVdapajoI8SftVomyB7h6Z?=
 =?us-ascii?Q?cA/yWBmyR1Ztqpeho4NnjyORGOz0uB+su1Chw40aiVkRalKgp1Csgs/DjSX9?=
 =?us-ascii?Q?mAMm1VVU/PCPUJr5i8QUo2idSyReRnpyQXiu8CIFiqsyYMHt8qJYyUtczzD1?=
 =?us-ascii?Q?YGm3fipSBiir03VeWw/q43nJUAI2yx8fJKjQBuyihxmZlEqTAHANJRIEhcoT?=
 =?us-ascii?Q?JN44uyCN/OTbhnJ3QnYVd62B6ne4RVS+fOBVUmKTMzI26XRCmSM6xzWm3QiI?=
 =?us-ascii?Q?B0+tTO2IiACIJIUAdeRaQG2VKlPLwXR3vGYdePbjru9uQgTuYuOGVUyxvozS?=
 =?us-ascii?Q?W9HXwtvLyJfpeGboBSYJEhAXH8pXF0x49GkvYiVKlzEI8nzqRwxWxcg1HOj+?=
 =?us-ascii?Q?ZdA6W8c4vDE47UXBKlWhv4xWbD9PZ1WuTpAKH5JNfOSGe7RzT9VD/udjlPSv?=
 =?us-ascii?Q?M7gCn371nuv54MiQUtYurdF/FDZn9RI7AHHlIb5G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3fe103-e3d9-449f-3ad8-08de12612708
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:41.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L++LrqLdxSggFY98k4WOiw1ie7lpDtOMRhJL84NvEm1bQT1wsm6gvFNqIgpVplf9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Replace the VT-d iommu_domain implementation of the VT-d second stage and
first stage page tables with the iommupt VTDSS and x86_64
pagetables. x86_64 is shared with the AMD driver.

VT-d has HW that requires an incoherent page table walker, the majority of
the patches are adding generic support for the required cache flushing to
iommupt. This is modeled after the existing ARM64 version and is intended
to be re-used there.

Applies on top of the AMD conversion:
  https://patch.msgid.link/r/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com

This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

v3:
 - Rebase on v6.18-rc2 and latest iommu_pt series along with renames from there
 - Text and kdoc updates
 - Drop a missed IS_ENABLED(CONFIG_X86)
 - Add iommu_pages_free_incoherent() and fix an error flow in pt_iommu_new_table()
   where of incoherent memory was happening
 - Rename ALLOC_KEEP_INCOHERENT -> ALLOC_DEFER_COHERENT_FLUSH
v2: https://patch.msgid.link/r/0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com
 - s/!IS_ENABLED(CONFIG_X86)/IOMMU_PAGES_USE_DMA_API/
 - Update comments
 - Update ignored bits for VTDSS
 - Fix PT_FEAT_VTDSS_FORCE_WRITEABLE
 - New patch to reflow how PT_FEAT_DMA_INCOHERENT reaches the PASID entry
v1: https://patch.msgid.link/r/0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com

Cc: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (10):
  iommu/pages: Add support for incoherent IOMMU page table walkers
  iommupt: Add basic support for SW bits in the page table
  iommupt: Use the incoherent start/stop functions for
    PT_FEAT_DMA_INCOHERENT
  iommupt: Flush the CPU cache after any writes to the page table
  iommupt: Add the Intel VT-d second stage page table format
  iommupt/x86: Set the dirty bit only for writable PTEs
  iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
  iommu/vt-d: Use the generic iommu page table
  iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into the PASID entry
  iommupt: Add a kunit test for the SW bits

 drivers/iommu/generic_pt/.kunitconfig       |   1 +
 drivers/iommu/generic_pt/Kconfig            |  11 +
 drivers/iommu/generic_pt/fmt/Makefile       |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h   |  21 +
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c  |  10 +
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |   2 +-
 drivers/iommu/generic_pt/fmt/vtdss.h        | 292 +++++++
 drivers/iommu/generic_pt/fmt/x86_64.h       |  31 +-
 drivers/iommu/generic_pt/iommu_pt.h         | 154 +++-
 drivers/iommu/generic_pt/kunit_generic_pt.h | 110 +++
 drivers/iommu/generic_pt/kunit_iommu.h      |   1 +
 drivers/iommu/generic_pt/pt_common.h        |  29 +
 drivers/iommu/generic_pt/pt_defs.h          |   5 +-
 drivers/iommu/generic_pt/pt_fmt_defaults.h  |  62 ++
 drivers/iommu/intel/Kconfig                 |   4 +
 drivers/iommu/intel/iommu.c                 | 905 ++++----------------
 drivers/iommu/intel/iommu.h                 |  97 +--
 drivers/iommu/intel/nested.c                |   5 -
 drivers/iommu/intel/pasid.c                 |  44 +-
 drivers/iommu/intel/pasid.h                 |   1 +
 drivers/iommu/intel/svm.c                   |   1 +
 drivers/iommu/iommu-pages.c                 | 134 +++
 drivers/iommu/iommu-pages.h                 |  51 +-
 include/linux/generic_pt/common.h           |  24 +
 include/linux/generic_pt/iommu.h            |  18 +
 25 files changed, 1116 insertions(+), 899 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h


base-commit: 214059b054b42e854854c4555e4d7c9b95e7f2ca
-- 
2.43.0

