Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF991339870;
	Tue,  6 Jan 2026 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712022; cv=fail; b=YAeLcUdhY+vH+OZEWiJKt6hBuLfDHvudMqUBv8hcLIbKdPnOXz/MsyU8rPsvSuXNc4Wd/6SFFYXNIicTw1a1T6+PJJ+Z/y2U7pffCMn6ybqrRUiwXJ3OWvFzQN4H8PGCcOZdHBidIRwqwbWUlMICj+AmcfXRpuynCpgpgLR1p2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712022; c=relaxed/simple;
	bh=5NS992auhkjIWpM2+j4F42xhTWgmZ3OW5KtYRyRMI8o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hL/NpVYIh9c/AxF0qU+TanN76WfLJKr2nvCcEMWZx3CjIf2CnQwwlf/2MCilLvTyMngwjMPSu2XzNDW5odIqhbx3RC/gdyWsTl3ZgQdH2qc5pEVDNOUhMm7PpP08XDVRVfMCU11KuX1SYklD/bMsA74nrH9gNF3GyqI+Susakw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oPYV4xxR; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oPYV4xxR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ef/DMfhlmyeDwBFaEeNMxeD1r4rdm6gzeHY03vyZnlkW72eyHtZLoqEoa/5BlzboDM09/BiNh0pVUU1/ScrHdZuyOciDtHsnR+P1iQIYhe2ZY8IPKBpkgFynge3T4jeOvPVjTpND0F8gsyF88ky/boQIF5nYUGFIbTQoHSHvPLbUuRDrSOmJEvWHG+z/z6LmYslB4UKUF2OcWc1XnfVVPweGhKBSYtSZd6M9GT8uYUwDOawE8p3/XERl4VjRONQoXdJesQpnAOg4ozcYT/wIVm/sJGauNkVq8M7cWJluFA4GKBV6qEBclWuyFPeb9R2tc2WQqXEIHQv12ABocbeblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuCo1lDNBNC5Wo3YPLQa7KOgeGlruxVcoP9f4ici4KU=;
 b=TQ0qba0dAW7eyiNSrrj70KdHBNStt6WYE+1javIR8cJNtMcsQyOozvux1q1DSYxyAuRzYmiwrWUUS9fTxzpafmNURzPzcTVr+UwKog4X6JxnKku+vuS0joBPhZ/bGsU2pSmGoElFckBvwGwkpmpWlmtH3AkJYOsmia3NxX7VCcHbcJKUQPRexIMWy8pw4v5iO9vgw2fntGyLf+OKf9T+FxLhUT6U7uf+lsNqo1LAx1Rt7uYNlWYMxWLYF4pu6USSS8wt3v3z8xd+erBOvfo0cxlkVmrSp7eWfk0obHPonSGpgdRtVA1wl3JZS71jqoj36GgooGxY2DUWJQJiBwUYoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuCo1lDNBNC5Wo3YPLQa7KOgeGlruxVcoP9f4ici4KU=;
 b=oPYV4xxRcr4beCOv9yHfFUEu/yZaTCubDaG9vlbmG0bOLlkV87053kfwx/nHFcXv8fWS2sik3E2plgz793hLtRTwEdcR/XvUuTiZCTiEyK0bH9gRgFcgAgiN776ktg8axhKwzMoxNmF8DYo5WP/+VWIb3oWOr3/dgRol6bxvlpSEkBez8Bd6jCDQyDJKy4hjUWn5YylUAm13adXPnIIyNtFeeeAymFpcZjkHIW8oZ1TSsHghymtjf4/A7y91MZreVviGM7FWoYeyz8lzaiLuL1QVt0sJaH9+LmFIa0NmYvu8PljPWpDD6gEz8r19Y0HptYFRQKzcgnBGJ2lugBql9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 15:06:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 15:06:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Date: Tue,  6 Jan 2026 11:06:44 -0400
Message-ID: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: b0667f23-f753-4e47-ecd4-08de4d35387f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wGouw2VS/pmClQul8npx8Zo5FWb/vAonFTYNqq5DHLXh/uIOIzsSXS2h8rnx?=
 =?us-ascii?Q?Eqbrirln+sKHhLhAfMBQgU1WxmKnVf2lNNChmQRBN2mYJpo6baK6C1GU0PcM?=
 =?us-ascii?Q?uvu8i6xqv5nv+G56uXgDACyQCtzJPrXTjtq15/HmLTFN5qoqfR5LVK3g8kfK?=
 =?us-ascii?Q?tWlRM7OZSBI5oqZCUmHhOWuMAsuQttA/Q2rjCNGef9g1PEeVipcu/a58b0+Z?=
 =?us-ascii?Q?qULcVrGAqJPyFsgX4QY0ScCwhviuCLQOZGmLMXU+nOUr2v5SFqBSlGbYdZHT?=
 =?us-ascii?Q?BQc5Drgx1jbs9eRqCbI8DtKo2Ym4ouXVumP/gEa96ojcZ9eGPt4vwz+A85c4?=
 =?us-ascii?Q?BtBZw8SarDV1bHej1xcSJzeYdhMpJ3nnxX3t55ob2Lce22m1xhGnf6H65YRz?=
 =?us-ascii?Q?POfcB483vCd4w0Bq0Z5n87gnokFpG3a7RUVEhJGNaQG1lxND0YbmHDnhXEG5?=
 =?us-ascii?Q?76A6VWaw6Yf3LUdLN+Ln1a97nCK65QzJ7R8qgOjfpyB1LuEIfDyeiQ0BgrD7?=
 =?us-ascii?Q?3d8a8jbZV13j/R8lrNHQ1nESNR2QhQx3Fap4mE/j/AZ2vpf9cfLAA+9zAZoK?=
 =?us-ascii?Q?IbIWijH3iw2fsG8L8aK/kqAKF2Fl24tTzb6cIi6s5SE+4WF9sY+GcYDLIlz4?=
 =?us-ascii?Q?LwxKsS9t8q4BwJkfucbBqekrqcPPRXqin4wRgZCfnkt5xUqGhtTnGKw8pULm?=
 =?us-ascii?Q?WvRLB2hqt3eWqV8PC033IMcekDTyjUl33z3xIYTV2MWP0oz0CPCL+NL0tEl0?=
 =?us-ascii?Q?qtJRT92BBAV0gNvRaSXyYYWdMjz5UGx+13F9WAWX3dUsi22fzDrgAlehcZl+?=
 =?us-ascii?Q?A0ARn8uAr3WBZVECTiVyryWEdeWsT4ZDoZBaOxhlXfk9TyTP/WSj2fa78Xvy?=
 =?us-ascii?Q?TN2iLQ9TfabPt935MpixhXZmUDCZhN1vi5Kb/ycrAVVq6FhGtBZ5VCr5v7dC?=
 =?us-ascii?Q?X8ut3E2sP3iw4cTkcrgz68pbLjEgYDKZERtBUaIutVcdlgA05IjLcE/W+vPr?=
 =?us-ascii?Q?8sRG5PvOtz9Bo4uEkr4BCw4S89fTqhu7C0P/s8w1JeME/uSdy/T0yGzuLUrc?=
 =?us-ascii?Q?yArGDrf8NoatODa2tFhoOvBctrNRJAIuTRtyE73SvxvsjqXBH2UXsns/zEKB?=
 =?us-ascii?Q?7Ueflie0LefBPMX9OelXabLiG2jpPWtI1lz3vE/Lokw5SyUwiNkqxHlv2nG8?=
 =?us-ascii?Q?fb5DK2xemsqlxSVk23ynknnht9/zWaj277+1x9YTdeG/+t1aeZpLEwXSqOUX?=
 =?us-ascii?Q?ViLwyppMj3jBddu72xdY9brSzTXx0ixEWVJ29CAEoK9nO+mgU10IN557NnzO?=
 =?us-ascii?Q?M5QWpn9kqcZiWP21JnvAo8pIPQRZ3xCyl1CKbyuUN8RUFx359ASbTBipbehG?=
 =?us-ascii?Q?iikH0+zuii8tN1KP6X4BkLJTSbGeMhgWiNuaiJinJT+jV33QRTIf9fe/C3vU?=
 =?us-ascii?Q?mQfXhpfVgUZUDVv8ZtMXhfxvJLekLZxDqSSBqA22c7sYOeM84t/Gs3kPfOnf?=
 =?us-ascii?Q?XsUzfTqrGcaNAfcwokt9YvDhJZMRchyHAfDz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?35W90z8G2Oi4LOFFepvx04Vr0y9j0pfHF9hBTWW1LltCZnzDdapsTEuRIDey?=
 =?us-ascii?Q?8oUwbTrpAOckwfYFtM1mCFuezRGAPCyFtl+V3O8nOMXfCrP8lMixKwD6JxKk?=
 =?us-ascii?Q?22z1wn+1wU5yY+6bVnjwFCJIfa2eUqfUMTZu4Gk3Ywf3NW5sQn2zbpNnP40A?=
 =?us-ascii?Q?PQAe+Xuwosk0Ce2X9yqY3XQ+zjad9vqyqsHsCz9PwECMPOSuQHHr1S60nVLN?=
 =?us-ascii?Q?3IbnXhBsmU7+NeL/Tbs+JLrMa8aSav93wzfCT1nfjiPywb+dC1LgDIaYD8Q2?=
 =?us-ascii?Q?MU273Tmk9jtU/Prrpd4FoMh3D/3cQDBtS61p8LYv2qbgxIUNncMNb99mX/bL?=
 =?us-ascii?Q?5jf+po174qVE+2oeTVMB+ebWDO6dPe5z66tZo5zO0WemkutvFI1YRcOtRg4m?=
 =?us-ascii?Q?yUNVYv0Bqau2GJvnjUl28X3aIUQ3h2a4AFl3TiIbKfIStlz9igtZOaxNDhS+?=
 =?us-ascii?Q?vSprDR9ItOvPcjrtEJiWz2bx0GfGEgf2S3mZpuktYhQ6H0l2JW113e5+Bh8w?=
 =?us-ascii?Q?Aig778d+eU7Ex5Eam3Fb5+lK5lfHD/O45syXTTDzuVWQaVGa9Vt7L6cMcRUW?=
 =?us-ascii?Q?9LE9wiUB1+13sIxEnMklIX5YrNCMES6VOspPbb3mR08G161TDA8mDggOeoSd?=
 =?us-ascii?Q?qiHNJglJZ1LABnS28qdO9uXVOZFCel56g6YM6B91291648G5zPOJeaCrpEAa?=
 =?us-ascii?Q?j2n6t83pOZllb8XMZZA/4zd6f+fnlJqL7KQx43KJqBeR52qhwMoI+idQoeVt?=
 =?us-ascii?Q?ZRt+N16NlVFPmG63d/vWMgSQU2g0fLNGplzJAZV+kdY3XqLP3iY1g7AiYp0k?=
 =?us-ascii?Q?exV0D8uwLQ4z9ZL7X/PFYofqjBHiwiYfLXaWIByPPvp1ZpbRI3xRjCTbUHa3?=
 =?us-ascii?Q?tTuAqIChH+UcVtz9dpSfJNFUYQsZBV497Hq/P0s1o3DuvQUMozs5rEaDlaCD?=
 =?us-ascii?Q?lR/nYT4ms7YPtE4b0ZGEaxkxy4QRjDWGvLOwzrIOiMXWwJbl8/LvS3OqTKoX?=
 =?us-ascii?Q?17w0HYnBYJ0Yj/yv3fJ1abyMtOk/XTVkORvRSPLOXGwzPZOEiK6VdWNr3Jjy?=
 =?us-ascii?Q?AQ8LwiFaQy8zkYlVaOCV/1S0RrfVnazyoe0OS+4j9hFm+71RfOqeqsrua1D8?=
 =?us-ascii?Q?y8U0RWQKLgXedy4Ox/YiV5bLvcKSxS9xwIIMP9OBHNCyAopNpEZ8Y5hzlKhr?=
 =?us-ascii?Q?Qeeqg55BS1zAlPYYLx26M4MvBT//FuDVT1PJJeL/PSr2vQuGSXNO6h3ZejXP?=
 =?us-ascii?Q?jo3PytAJTcbR5o1+Up5+bRWKSNWUxPImJENbdIyyQvhuWjOyVKhGDL/np/xQ?=
 =?us-ascii?Q?GUYeYUGP2AlAGMb2yf+5wuvpx4cu9f5XAHXBGC635mpuJDjuMXAcOLVXOOAX?=
 =?us-ascii?Q?oWGG50Bjb0OGx8hAmciYevMl3oETSzk4drJCyuok630iT0zJF+CNVizpozM0?=
 =?us-ascii?Q?sJglou0IUTMZyyN3FEw2lhfKUAsuOVBGtLJtMl18iqnmR1N2T/TqKs8Op38h?=
 =?us-ascii?Q?mCenZXUHwsjW2/Uo/rZ4g4Yt+UmhaSbN0q17EHs/JgA9r1qQ7HkmhX48D6QO?=
 =?us-ascii?Q?IPvgDlKiUBqHx5oFgAGckiykpW7PcXCM4/cELtKpuONJZxQsjsWm2BAEUEeQ?=
 =?us-ascii?Q?B+ZamYfVtMJP7IUCJ+k0N+7b+22zTzW8GJcmfoWXcMgWerAxaEgVT3t1G5qe?=
 =?us-ascii?Q?7Tx9pa1Rtg6lp8hQ05AGRUkFmoap6/umc3CjG7a5PQRCWLx6ayP+5CbaGLnP?=
 =?us-ascii?Q?Xt++dRskkw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0667f23-f753-4e47-ecd4-08de4d35387f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:06:51.8982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLFnjF+f/YDcZGMIYCLUZYXCdb/ErWoivAgnLSUW+vu0TZMdMezsOiZEJbTw6FTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

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

v2:
 - Rebase to v6.19-rc1
 - Fix typo in PT_FEAT_RISCV_SVNAPOT_64K
v1: https://patch.msgid.link/r/0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com

Jason Gunthorpe (5):
  iommupt: Add the RISC-V page table format
  iommu/riscv: Disable SADE
  iommu/riscv: Use the generic iommu page table
  iommu/riscv: Enable SVNAPOT support for contiguous ptes
  iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST

 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |   9 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 drivers/iommu/riscv/Kconfig                  |   8 +-
 drivers/iommu/riscv/iommu-bits.h             |   4 +-
 drivers/iommu/riscv/iommu.c                  | 302 +++---------------
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 11 files changed, 445 insertions(+), 261 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.43.0

