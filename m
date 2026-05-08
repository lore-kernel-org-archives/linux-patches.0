Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5A3F54C7;
	Fri,  8 May 2026 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252003; cv=fail; b=Lx++PpLytJK1CjcwPFpAwE9XcB0P5iOvQfUZBc1yhotPz3DQantNu5NKoezHewsin8YVsX45KnpZ2SZrvs/Gq5SFAILmaCHhm392hi42VLQjkQHkO64QJapaie++Q9u+144O7IyIJv9J+9zouPWjHCyBGmE53tsXPfb/s5Z4nXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252003; c=relaxed/simple;
	bh=krH9gGxxSCyYRUKbt1eiT5Di/MIIhxbvhr3o1AbjfBI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=n0gjxCLAL2oQUxvXPZEYeC11c9LLmg/IhnR3AX8k0+56lsK+d/mm944mcHOuS+e49l2K1JvAHSdf8pZ/G8+thWeZ7ya14RxTqud7rw9yogkd6s9H8F6J7D3GEEvK6K0plc4Qzaw2qPNMzYELwNrZbyTNV4AU+8+MJNIAOcoXlA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KH4FW3ID; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KH4FW3ID"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdlXJ3TWZwLFsOm5hcZ+Ji72vp/VjmkiY1HaP52L8bCxfu7YeIfspZBSDLk5Jrkp7GqbY8FCwUzRkuadgOtneJmGhMp37Js3qY0/R1yMujmqHNpW+3/ShXbTBhuMT6l+Vbr8QrRarix2myNkaXLFHh4Ef8SB0vCLeb18AOcbwA7eB7z3CMiHBn1NmLykHAjlreZMt8WKBi4AmYJSyR+74lF9BUA60Iccg7BQipnsQghC6S7znTdwOht11oTkJc1rABBGZniTcYujY8nHGtQU0g1X+Iv5GC+9as4Kqeg+Klk+K54qIqJ+wUutyV24xL4rWy42+vg2KWz8a/pmA7IIoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5+PT+WCMADHhkdCJmLfXIyjCEGdjuPc9VvN1Q8JldI=;
 b=pO6Zii288QXGn1svTivCniBgvCtjwegGkPuE76pCbwfotrTRQnmeta+uqfTmx823lc/k3LniMA2JT37w44nREnUNZzE3XARAyfMLesgqZdYz5LdLGHeeTSGiMfcT/ufYInOutAe7/Wn5vhlcy2hL87+fUWmUGJuNfStuoeLK8Y2ZbAgBM9KhzvSetpwfLsFVu+B6dhe7xnX+4PryEkVh71IcM7PXEHeUwY5f44Pf0Om82dlzbKe2DRJ4RMdMg3C8jmlpCjNut2yLnVNdNs9lhcSHpP1P0vCiIvECj2XVsBtpHOWEZxUxgZhjmgSZ4jlcYAXbaBQPJFuruWMe1x3AnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5+PT+WCMADHhkdCJmLfXIyjCEGdjuPc9VvN1Q8JldI=;
 b=KH4FW3IDEQC8m9XnMpruzv+Sv3756y4D/j9Bro1L2KyU0Fsez8+K6V8SzKV3hun0jDyy7icLZwV4JtV0tkMNGQh4RdxuGqD+L0xENFPQ5I2+t4sVX1IvUBLC4TK3O+itDukH0S9JJa2Mt+FztA3KPbyk+l+sMEc/h2gVy82126Yt4iUG+lXY2V3GlpjkORwtGDN2cZQamQJtg70/cr8PL6tYB/GcLXR8fb4Lmdz7RqXKXzokZiByOpfsevahaJTj6uOmSg4vwL0xLGAGCeVuq48lvP17gBNorGW3hgxrPRdHyk2aR5noUESTqIvKAsyFjWCErYExZf1WX2wwwst7dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:11 +0000
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
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 0/8] Support non-leaf and range invalidation features in RISC-V
Date: Fri,  8 May 2026 11:52:59 -0300
Message-ID: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0135.namprd04.prod.outlook.com
 (2603:10b6:408:ed::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: bb9b6b73-0b0d-4ea6-4b26-08dead11860a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|18002099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	Ng1kGqNhSZoQC7mh1rI4IvffpexCz8UXXqcfOT0nSsoS5h9cb2cRX2jjOAt+7zr1zVv2W9XpEjroN2GOAsL3N8VuPgxTv+69B4+0UtQyPjPlbZoem9Lx6lMcJiXObl93goPUJTrOAYSFgFNUm3+x25LoZUO96CA6YMtJUGYTAw9aL9J/3X8bpuFomthZGtePRqY3d1GI5s0sCzw7TE8mX/8+GloaF7CIHP1tuBxuiex/pvLQvw6KP7ngVmmSDc3dghLhRJQWFAF+SYFPCcz6lTAJNtcMDvoTIMksiG7hy1R/Uva9l2weHVlkc0Tj4mghYZ2t3/uWQ4dx4lMdfeBfFmHf8naz97vS6ijV5jnWGkn3xRaJx6EdRl84EwMrtR8APv61W+wwKhiRkVvIr5RqFP2ORAhoSFk5ybHt+Adl4OrE789Qlkb2y5z8rgikWH9FhoTzCgaDYHj1YKOxflg/gVVJ54u/s5rQA4TcZu8axFcftEwwvrvW2bmXb9ch7zUmwHq/XTPfHghJmW8E1d6qkgpRpnhPWILotM4qCobwAZm8Wjb0eWVxDTBJE8cwduc/tTo28cnq/9DCgQ89Cb1gdy1AJIpAr4XbhOdgN6rLmm6QU9NntNGEZjh3nymN16tuwCj624Xf7zh07FO+8WiND/HQSFRIfnd3kvHecmu1D+99I7pDji1ZMZVuitgW0WTC1ihkdzOFhuxUsQrfdhUHFO8a0fEFu3h5Q68WT8AoiyLZcj+x1jsIxs4/MZjh36yi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(18002099003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?irVmLqq+KYwdcl2CmzYB38yZ7LrbG39rKVTTfWnd9f8MbJdRDWTKHLC1d+Q0?=
 =?us-ascii?Q?VP1AjWZ8QM3+xnWVoi1d2iuYFcnI+fQ52RG7SnrTv9fBvN3b7L80H0CMd3Lg?=
 =?us-ascii?Q?W6/PlyZga2C/uWwOfu3CFMW+DHd5kU6p3jUHttmdY7xeV9uW1SRu1B/SNqUS?=
 =?us-ascii?Q?EMDt/6UgbHZejTV3el4vRYmr8BTAHuX/1ajGSIVkcfRbJzYlnXYmQicBO1OI?=
 =?us-ascii?Q?yEu2xyvO3b9V9EBA1tAR3Bte32uAoV/SZSXQUGuCQc+sPO/wPfA3rsoFpI+b?=
 =?us-ascii?Q?DImvhLwlJYWxq0pc+83NgtsSA4G0k/srTXsSjPPPAYmZyOUxSI/pXZksm8+W?=
 =?us-ascii?Q?H1LJcFEtpAlorwFqY01kIPywIok6xF+diT6VG1H2s/n9ltlibK3Q9yyNLSIS?=
 =?us-ascii?Q?SsjiyrbdloML8ZLLGQDrbSRBZkjzfFgK1/zdGh5edLhyPrFlWUJD72gIeQHN?=
 =?us-ascii?Q?T+EGgm5+/+P/mQ7HeVNOTX3pq4ucL4rwBopSVeDc9Ae/lWhWvuFUq4iGeRY2?=
 =?us-ascii?Q?Xz7nGHwSjTBImyIVL51pooHuIe/PP7W6SK9All3MTFlVjKa9+i3wKnuMSdir?=
 =?us-ascii?Q?E+KXgMMhuPdR3jsEhRbgDaTLTwN2HFC7Jio8Jf2gW/pXXPqWNmZzpb0D4gwe?=
 =?us-ascii?Q?qxxj/r4x981P7pa+6SEzSba1Q8IwC2GIZ/Khh6mGwsS7KjNyYbYdF84nNVCj?=
 =?us-ascii?Q?h7+EIFFfPBl3mEAUAlgpiMUPnLxfxCdHH9hU0XFACOgziDxcYnpalJQu9ZT3?=
 =?us-ascii?Q?QVk735PW5HKgy0Z6vVaIY7GheL/akzXfBA2lLdR3CJF+I5A/4Rjg+grFUj/Z?=
 =?us-ascii?Q?/gz5umiUDN6E2qVEwW+bKA9TDYQO8J8Img9Vc0pmbVQoa08Q+14LyFuRzOm8?=
 =?us-ascii?Q?ayi5i8xqwmDM+8wUXv5o+yFPoZzF3OTj4vt3uqOPOX7Rm5aJkxYOwDvc3WEC?=
 =?us-ascii?Q?JOEwzvoyO4/AqoPoID8Cw8ruLtnwzqNoIKyOo9gC+j90pZ3PXZom+bexg08J?=
 =?us-ascii?Q?3VoUVdbRPG67iUla/JKoj3HYDNpJd26W/9S/5jqPSAdw6WEx1pd1+KqyR7jw?=
 =?us-ascii?Q?6u+oPrBynwxDK6HFPRFxvyFPvk8m71YEiM3bXlBpcJPiw94KyvFhKzqBjF/X?=
 =?us-ascii?Q?h+HkJ6jGurGx29ceJOx/LHmMF2T/FE8lcncNhTkiz+ZLZoDFQjHUpPm0BAp9?=
 =?us-ascii?Q?X1cekKYTGgORIgSoSZdFtS4r4S6WE0/+nyp27X/YvzhDRuMOAYCDAW7uexr4?=
 =?us-ascii?Q?ceZJSdEDEnsFDlIGNwoI9bAsgNQYqDjiYhUuV42150yyVPPwqf+QmvogI7y/?=
 =?us-ascii?Q?xVMh9EGC6cWI4C/xCPrrFY9E2vI+3apT6lL/cHjaNhC8PKn+iSomi+6n8Xsm?=
 =?us-ascii?Q?tcvqpwHxcaj5VXtBxJZvAQsIX4WUeznvqLZoiZ+VaRMO3OsREQjmONI5uuEo?=
 =?us-ascii?Q?v3pj2QABlJg094il0oQuprDgejYJDxUxUeohvqQOdLqmwFLpyWKSR3r6G21y?=
 =?us-ascii?Q?jV7Ds1YxNTTg49ItFi1rqwaM99oXlyupOWX9H2wpU9rpQ2iDLt381U+asPHd?=
 =?us-ascii?Q?UV+ZZvJPTHCnZ42PfmByy61pLn+JIc9txVyLO1x8fZJfDicCDwJv4NJX+0Tq?=
 =?us-ascii?Q?ovsUNThv/6yERtbBkVwn23kt1IxPdeSoL8cWywbXvjw/khD86fs2uPsce+Z6?=
 =?us-ascii?Q?kFBIGNjet+FlCymx4wAQpkO3ZOIIduwoQ83T30OlOOwrsadj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9b6b73-0b0d-4ea6-4b26-08dead11860a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:10.9632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJOAUqRUGjL1kAubuyhyQ9vhDWTMgLXy1AQDq2YpVicaSicyF9Us++7fG2icWaMD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

This is part of the patch pile to get SMMUv3 moved to iommupt. From
that perspective it introduces the PT_FEAT_DETAILED_GATHER which will
be used by both RISC-V and SMMUv3 to generate optimized invalidation
commands.

I don't have any RISC-V anything so this needs to be tested by someone who
does.

Improve the invalidation flow in RISC-V:
 - For single address invalidation, compute a stride based on what
   IOPTEs were changed by having the gather track level changes in
   bitmaps. This allows things like unmapping hugetlb-backed mappings
   to avoid jumping to global invalidation.

 - Support the NL bit to avoid global invalidation when table
   structure is changed

 - Support the S range invalidation feature to convert any gather
   into a single invalidation command using an aligned power-of-2
   size like AMD and VT-d.

This is also a requirement for the kunit iotlb series, which was used
to test the math used to generate the invalidation commands from the
gather in this series.

It replaces a similar series Fangyu sent prior to the iommupt
conversion:

https://lore.kernel.org/linux-iommu/20260208144213.94856-1-fangyu.yu@linux.alibaba.com/

The full patch pile is here:

https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/

v2:
 - Add a patch to add the dword number to the CMD macros
 - Correct the IOTINVAL_S position to be in dword 1
v1: https://lore.kernel.org/all/0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com/

Jason Gunthorpe (8):
  iommu: Split the kdoc comment for struct iommu_iotlb_gather
  iommupt: Add struct iommupt_pending_gather
  iommupt: Add PT_FEAT_DETAILED_GATHER
  iommu/riscv: Enable PT_FEAT_DETAILED_GATHER and pass gather to
    iotlb_inval
  iommu/riscv: Compute best stride for single invalidation
  iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
  iommu/riscv: Include the dword number in RISCV_IOMMU_CMD macros
  iommu/riscv: Add NAPOT range invalidation support

 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |   4 +-
 drivers/iommu/generic_pt/iommu_pt.h          |  98 ++++++++----
 drivers/iommu/riscv/iommu-bits.h             | 123 ++++++++------
 drivers/iommu/riscv/iommu.c                  | 160 ++++++++++++++-----
 include/linux/generic_pt/common.h            |   5 +
 include/linux/iommu.h                        |  42 ++++-
 6 files changed, 309 insertions(+), 123 deletions(-)


base-commit: 83ff8144b661ec00d997d78a43987f974cc5792a
-- 
2.43.0

