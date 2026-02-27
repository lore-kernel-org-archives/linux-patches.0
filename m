Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE9D3F074C;
	Fri, 27 Feb 2026 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205959; cv=fail; b=AV8rwbL1JKNWLJeUPVrTcq0TLja+zb7D40C+7wyUM9nznjyNcW016AHHiWmOzDamsd+8z99kytt5ZqL36ih0T04YTD8eNJ1IRXfp01r7m5zYOl9M1/tNIgZUKH4eLsOmrYZhcVUTD3A+mAd0RKEy93GEr/8CX9cM95FOT/rPU3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205959; c=relaxed/simple;
	bh=FFf2B1C/qXfhPI6hOmokd9mrz3DgpKWPtcgzJDfuiis=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FtylQBrHhRaxVYpsdrwugdwpQYvcMsfryTb5ljBpv5Eb39+arHX6bTYJz2D3YuVROLPcnab+wX+8cKzpCBQMXzqnVAvcBpjyFjW11GY9/10hfsUKimqpS4IqXlPHCc6KARkw42UEY5nZVyMUm+WujWlmbTu8TNDeemTu9JKG6B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fOkh/tBo; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fOkh/tBo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ip+v9vInm6zqNnc7ByIXv2xFIbQckB+cZvdv+bsparlPqHPDMwb8YstsTT/KzevJfIrOZzNHyFYE0pdUm/Up0emb0xnOdpUYNcT+D1+1zU3zdSU60MWL4SQd9HAZChNGeOYlljVhXHfXqDQrtUuUhIjqh7HZr5UjjKIVPn151/c1gutXwNnEW+8YY7ckdbxa6o9tGcv7O1eU7QzbAw48ZJawtlgWxOIcsrp3J1xtAOCZIURJZsFS5EioU44lXQJVvRd/KLe+d5NOJALYCxZ4vc3o/qI/T45Zw0g1F42+wNebiSZtACTqfgQxFALv1LJ78GdHr3uVyNJNh3ftoLLqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrSIphU3Pxj3XB66UrAmTlQ94D31EAUSAdz4EPP44xE=;
 b=Y6zMUMRuB0U7NjoKY8gdUO5eNycRFCvsB/1ujoWfAhzixUMVewpDdAMqYci9g/Ag8dmfutwAOhbQYb+gPzAw0S//bGVxFXzAslSizjcgirXsFSUDy8HfVSNCQJDJYGe6p/zmWl+aDkL4+Zsh1p+eoWY5ztdosFXBBdQqdwmQIOB+xoDl5SoHMyQXMHYG5VpeBTsUix3KaY5Ax5ZiQQZ62k+8zfPr+XaBGcto0QHM0tEpP6pfRy4Al/YpvZNJbK+F/iteFOxwx7QY0HLjsMn8sqkgfF7aaOYF+5XtNzPIZUSSJBqVO9XOgFakZe4npzRXRF1pvHzRhC39yg+TLxDGew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrSIphU3Pxj3XB66UrAmTlQ94D31EAUSAdz4EPP44xE=;
 b=fOkh/tBoU+SC6kJ/sfoLMT23SzQQKg1W7MH6n2jsemu5SfjPJY2fsNY/+e/itoyci6rie7fiUorFD9iI2GO3mrU8v4gkyuJpVYf/OtJK1yFGVVZk59XajCu2gEVELaBfFS9R31G1v/z6zpxrtVX7scAw2tChMAwWqXaXeESjOVkoHc+B/bc1iaZXGHwvsPXYHrr8sfrGnDnQtoNfMbIRgVBCHHsX9hw9GLqEiYGDlPe2VFAdhLunbSHK/8PKm/U0LecKAro3ETfGdL6MI6+M2BsLJpt2b0ZxTyQtggku5CuHch8W0ZM8vpaHRC/9bBALSziHaym0N8YkdAvCeM3XQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:45 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Joerg Roedel <jroedel@suse.de>,
	lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v4 0/6] Convert riscv to use the generic iommu page table
Date: Fri, 27 Feb 2026 11:25:35 -0400
Message-ID: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:208:52d::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ebe6b63-86b4-4e8f-37e7-08de761478ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	RWjYfgDReJA7BiXU2A584aB6FsVI8XsKQgoK7fz2HcGlr9A0JqP17C5PeL/pC/rQQjNymUpRXs2rXBt9tz88T7ZjdXjE07uULu3FVQm2ThqxgrjlmQqIYH/HwnAK6VjmMYCvKvvlABy2oHKSse9fQhnoR/3FMxNgm2yd0gOusczFVd6Qkg8G+62GT/4PGTzly9mBZxtJXREqawxx7Z7PMh16Ya3sxNdgwHui3fzPTGDTlXSfmIvGacFVQdymSIhcsDUOwwN8j2viy19tksqCi4FyQ5D+peuhMo4Z3yyGb8PxkbPiUZOaz6kDZaXHJYWu4GpUUVchIoLNWC6vW8ipvvt8TyOPAk22nOu8CiT3I+ZclVSMvPdSwLnJuBL9ktfdrvYF3ebPYNgElefnQnyDda7vyI9xjXaLOhoSD3l8Z2YJjofETF/1bCwy9Koi3uG7DlwCbpLG7Yp12kVLdsHam4xX2VOpki3SyoZ+TtgogC86l3OcED/yRs7KrP4ogQq9jW7X7pK6zJOCWBHeclOCfMLX3sjzaZ0StKTvFvmwcjnIONE4LtJp4bur9iDr2W3G1YKlEdeZzgNAqbJnZHbbHy2aIJOyksKX4kJ6G0Yli/Cn6BUX+fiNsap32XcWfDhgGUvVbbS0zHMEEodAh3cv28FHZ8cXYS7O/6As9WOzfSj83XtJGr3IdfOaLla0ebFJgeJrhatVx6Rach5MwK27FxZA6Btk9R/LkF/xA/8/iFQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DCKhWuVYGvxL3rsa+itVWnolxYUfesltsbUZHKZqcA+zuc4z2gqF9XDhLiY/?=
 =?us-ascii?Q?5sUaln105OAwftwJ2VU/cgskT3AUyn7t6CHcS+rBy/S+6DUxu8EvfJ7zyR+B?=
 =?us-ascii?Q?ggSZPDMvZjVncMuAEDa0Y4np4xxTQptUiK3DuLQqGIYtlOOqK07+8voiRnvU?=
 =?us-ascii?Q?XuUY6e5/ZX0XFwtv1GkwwgxPOWKEldsg3fXavuANFYiPYQvmHBT1vXu9hmXJ?=
 =?us-ascii?Q?9S0iKNce//pTJTuYVbUV4ooCLtVxEqUL6qo2L39zvxdWr6hkBNnDD7I96L0p?=
 =?us-ascii?Q?fbtk+k6dqbQU94oyun264jqLdD2jwx2hCZxz4lC05BH1bImmMJHF5Cvm8LLk?=
 =?us-ascii?Q?rrqhwsK8+AXsvCVtAOYEb2FzLgwFyyu615jqutPeIaylgzWGySJghszNuwut?=
 =?us-ascii?Q?fRCQZt0q2XPNU/thcNmt81+zvjk/atI1MuYz+ykU/ixM5Y2gwfBE0BVsVwvg?=
 =?us-ascii?Q?Mg7qmrGWGtrF70KMEXNww7YFpbg26VFNMmGZ0pYsQPH2PCKnbhLO3jFCGBZ3?=
 =?us-ascii?Q?b2Onkcdl3U4XanhA6Yum0kayjnzKEFrXCdSm7gxNH0mhXVvf+RMEM9hPOLLN?=
 =?us-ascii?Q?8TGbFQ6hphDdzQ/mTU7IUGzUfu3ANca/XmVm1WZy0ixue7cRHJduImc+WAnd?=
 =?us-ascii?Q?wWcfwCtnBioz4mHvpecGGqAIEX5o80BJ7NZb0PHlQE4S6A00SAMEyYFizUab?=
 =?us-ascii?Q?NM/vxW/NcI5+6E+AeJbmaBvHR0juNHo7P4/kK0EyfNrzemE7OpukI1XakQti?=
 =?us-ascii?Q?d+d3CuuM8Mz2PLdG3QTrFgyzA5YinMUwdRcSIA9dc+bfdyztX3DB/9RDLd8B?=
 =?us-ascii?Q?oCnV5ebK3XA1mocjd7uBg4yhEg9mkfkS9Kolp4J96mMHrHJ5WaX2xE8dn1/4?=
 =?us-ascii?Q?taavuf65iFJb2p61ltaeAkzRJAxwb3kfchHU4I4x3JvEWsE754XcorDVU/J0?=
 =?us-ascii?Q?YzsHbQH5YXSxE7vZMmZA97XFsa86wOsPXLRWH6ooywxtH/F4NJ/tpInSXLAs?=
 =?us-ascii?Q?siVvL7sJ8UnbAvlvgKlQH2X2HLCTo3ufmfTtGhdTR1LcP+jypy/V7tgZ66Ak?=
 =?us-ascii?Q?iClL124+3vyCloeXLJkamCr2oBTr+Bz8GucWin0+dWaT+BCNd9Gisd9olVT5?=
 =?us-ascii?Q?HwZxuqea4V1l6sFKi/RKBVu3seQYoQS6aM5z5cwWlwTfI3GIP022xfDldya0?=
 =?us-ascii?Q?tIZDJHEc4HjliaZmgHZoy3D9cqaamVq9Peo1xnNVajIvrkUF7DOg9iozp4Ck?=
 =?us-ascii?Q?HKJWhF83J/cQR3wWJA8JhhlmJiHx22SzUuvSyL3XK6dIe66Zk+nNMpRXqK3d?=
 =?us-ascii?Q?ZnFbuKTI3n9uwWe+et+Nl0EmF51OYtXBsmqlWTNkFd5QZIbRL5VxrXRfXAnM?=
 =?us-ascii?Q?jWcNn8shZ5wLVlMqMTKyzMFLxfl/rkM5W8bYNK7INLbIRUWHDT7TMzq7jPlu?=
 =?us-ascii?Q?PzcGKOfd8j4Dd/cBRHacDLyteEE8JmfS3Z5rnqgLhJ3T1mT5DzMeejeI2iOX?=
 =?us-ascii?Q?usmWXJSYwCrTubALfvjWcK7DAkK+Nuj8z8g9ekjp3oZogMqH+Ppoq2044rWG?=
 =?us-ascii?Q?bC/ycXTmauoIJpQSL9ZiE/S6S/YVCoXtXtxxLz4gHG0fbAd9B8YXTpFUA53l?=
 =?us-ascii?Q?Qz/w+hLHhdw1BGMbYIzppGpRqG05j5VRqVL3T40NcffXp5hbogvRQGA6kX3z?=
 =?us-ascii?Q?tSwdjJz1TGwYkXmow/1zn5QIjoEXJTkuNdM7NpGzt5OFp/rm7GVVn6uBdjvP?=
 =?us-ascii?Q?+d4O6fLEhA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebe6b63-86b4-4e8f-37e7-08de761478ca
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:43.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tm42/jGK8LULyyLjPIgiId1OYtG1dLwOfdEydpi07yObvs5QdE4W9cJ7+LhK/Jth
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

This is a fairly straightforward conversion of the RISC-V iommu driver to
use the now merged generic iommu page table code.

It brings support for SVNAPOT which is a 64K contiguous page. Otherwise it
should not change the behavior.

The series disables SADE as the dirty tracking support is not implemented
in the driver and should be done somewhat differently. The generic code
gets further along though this does not include the format implementation
of read and clear dirty.

The format implementation should be able to support the 32 bit option, but
this does not enable the iommu implementation as there seems to be no user
today.

It looks like RISCV could support the DYNAMIC_TOP option. It would require
some additional work on the core side to interact safely with SIGN_EXTEND.

This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_riscv

v4:
 - Rebase to v7.0-rc1
v3: https://patch.msgid.link/r/0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com
 - Rebase to v6.19-rc7
 - Add missed line in Kconfig
v2: https://patch.msgid.link/r/0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com
 - Rebase to v6.19-rc1
 - Fix typo in PT_FEAT_RISCV_SVNAPOT_64K
v1: https://patch.msgid.link/r/0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com

Jason Gunthorpe (6):
  iommupt: Add the RISC-V page table format
  iommu/riscv: Disable SADE
  iommu/riscv: Use the generic iommu page table
  iommu/riscv: Enable SVNAPOT support for contiguous ptes
  iommu/riscv: Add missing GENERIC_MSI_IRQ
  iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST

 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |  11 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 drivers/iommu/riscv/Kconfig                  |   8 +-
 drivers/iommu/riscv/iommu-bits.h             |   4 +-
 drivers/iommu/riscv/iommu.c                  | 302 +++---------------
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 11 files changed, 447 insertions(+), 261 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.43.0

