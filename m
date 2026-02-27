Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FCD436344;
	Fri, 27 Feb 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205964; cv=fail; b=FAY7eGSlhxftT1xVm1Op/9dt4dfJeJ4TJ7ShRqwumTLFxF8d+6XsTAa1Kt9Zm5PoIufJ899CDNO4bDmG3Dzx4DjeNNJ3nHn6Tks4DySqI6VWQOgFj2mq30iI4B+wTSAzV3CXpzrMmZ0EwUmzS7e77+IMkSzh53GEhUbjXArQtRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205964; c=relaxed/simple;
	bh=nL4pIPQ8FrommMcmB79ytoriWeQipMR2cjQhxTTEXLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gVkljYiFnAF4TwaNdZYxZH8E+ky2X9ohc6qEFH/2rtRqYNM/rE6fzCeO3OPrcU3ChMOBdpCP4EamqDHvqBajlO9QM6OaEfdHDcRhINS7M3PmYDC5LNMfA/8lvctP4GVGAh4p9Nwae9nbBG9uftLac74zf7sc5iDln6RQ5ZQI/8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PUHYkKTH; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PUHYkKTH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hO9iF69pJ19yxVPDR9pyIGVzysI56Kx0472/eNFZ0dKZRmOSdGx8mPohXQjU3WjpZK4oY0aG9ySCOBr+CM/30O71U8O/ScdOPg7g2oe0Vqi3AgamH58Pk6JnCYCiE4YofTebwPtUxhR/M8gPZqVWqsBrFmsflmkhgmShaoGN470BWxvIEs9dta8/MZZ8zeAC8ttAfUQypJ5CO1+g/mr/XHul7h6OvMfeOQ6WKKydU6UAVfiJP4UEqC3rGqedvBeqDIKi1v5pArOl2oYhoj/lh1UN1mOCrUY7AihtlSEEvkj8swhF/1IxByvadaUh35AGuGus37aYaPcyPJmyQ6hX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Odg+J4scUNaKrFXygnOzNioEYMtq8k7QiIbnTRLsk2M=;
 b=tJdRLZWE5mo7wg8WdznWC61paFFt1Jp0VkDY50NnB62w01psGLTCkWCBiNszRJR4tTjcrrF9lM1uyDxUrhspBd7N++JsAhVCEtDQ3cRBY+9n1hhU5GO1Wv3OQlTQCm8qjzqqycdAq0vMBxF4sCG4yeSfyDWaRHrCGIYjKhgI5C8JrH1nkt3kHdjsxbkUA6Sw7xNAHUGRKzlETjT8bShxVL5/hdsdiB+94i5dGQe15N0LkXjCWeLJ1AdDFx3chBFDL7hTzj80JmT+Etait53oQUe6/U04iqgPwPg5K5rcKGAI2t1wbmMwoqO7LlzSDXetq0JXpeCDBRb64x80nxurtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Odg+J4scUNaKrFXygnOzNioEYMtq8k7QiIbnTRLsk2M=;
 b=PUHYkKTHFwel2M+iz5sGxcQCGqbMK0bDHqLoZV+w3HwZW7iYf9JGhmqfcY+4thFCmDLp+lmBOJ2KIeOeHuxhz2uin6hX/U5c60GKFIKtVf2jSvNFaAOFjFEwsZBNWz0w78V3NLlKYbu/WXqGixabaISMGuU1ilP4xwl+tRv1hqaKdxZvZ8jya2Dr3lGYkhRzEMqOK+bjzI+2veihF1JWonfrI+8pUEBUVrbVT+ij/cYsffRGIndIPTmel7tRqJP7GKdkV8OJRWH9uaBYSKiPmexqKk8fA6+0o2lXhiMi14r/dZWNC8xEnxAPtonPP4++xnOBW2mVR0X/7LN3FTQAgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:46 +0000
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
Subject: [PATCH v4 1/6] iommupt: Add the RISC-V page table format
Date: Fri, 27 Feb 2026 11:25:36 -0400
Message-ID: <1-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:208:239::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: cbeb4d09-edf8-4106-e209-08de76147960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	jb2ZX84WcMRiwpSzd4Lpt4J4Jz5vwUtqpKlzmX4LeFviovN/fkbz8b9m+G2wZWrusMvgCmfu5V+NEseT5a07bRYAZlOb18uk9k1MNRYvB2ujr4/R5MzVvq21kMO9o4UATAtjegt6+y16Hv2KsAGK20m5GHwo/k7w2wpywyYM9jg7ZxRpxKxIuurL/DrRqkF+U6qvEqHIRrnEucUMraiDcnyQLLdL820xHdnaO/ToVRiOqvek0iZJ98c6XNMAZLUVGQVmZueNHyF2bVtrBaQrIdDJhSmK82Eu0nPfFzFRWcHPUJnh9k3LKT+HikyuFNYSqb+N9AHJvNPISaxp3ESKu/X4hPPUQFdNEvi46kViS5ttpIMh+CPye6r+kyi4fV3a+ViMvkSS3X1d0ZVSlDPG7Fz3RLG1Ha7rYHyFpFq+IbYU8raLwp+iJNYWH3W2Zyl8rxrnh4p467aMvfvIsKJht7HmVTWbMquf/Y3SqxMcRV5/Nfk6mEV3jEm+dbUWcO/pK9Eb71DpJMa0EMNTxAPktgBXIDd/G7mnAN1MAeg2l6kFt9yl0smYZztnyi+mTRMfTQpBD+1hrOb0eFNtMDYIPKQhsKWbukyha6HQaJ4ch6b/nijQCHtvUfFJu8vZZauw+6a7J+/xf+Ge9jf8HLEu+t2cQbRFE0G3a23gq5uKpBXJ5rltc6lfzuzKF1Js79gLfafdK9aO1ITqKZfuGHbqEAi03TEnz1U9LFJJxmG0qEY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZOCxZS3h36MjQOiSuDre/nbg2P477NYNkTDALTSrFdGXwrEmCPZGWIkWTxJF?=
 =?us-ascii?Q?znLEcDnFLYtLhtjbirUhQQpIJeLJxfp5fvjw0KYXAcp7H6wh4n5EiE4Vsrao?=
 =?us-ascii?Q?7DSlYzLmp27YmLdMPVGG6aUI4HNOW29yy+LADeqKdW31ox++3FDDJ5oTweGr?=
 =?us-ascii?Q?bU4JfXaDAaRvYIGWTbt3sY4nCeTkFCUed8nFljrZEcZ1wZ4EEQmN3Y9E7bz4?=
 =?us-ascii?Q?OKJN2w91sfPDeKRqgH5XZhMMoKDcybvhKnh8sp/1QAYPAeRHd+dWvLd8eYxI?=
 =?us-ascii?Q?h67xk2u9iiuDlzLr9vH32ZwcXvxHiNe8UESznmCAdYhxu6spLBsuaY8kRZ1X?=
 =?us-ascii?Q?rKoS5FBkisru1kMnrVD8VJliNz2L4EPK1e+Gum9JiUEMTbh8Po4Rhc5AZj7T?=
 =?us-ascii?Q?IO1sSr/sJBuGdlTibrKfJMV5djew7bl5CW5w6HK4RkoRRM9XeqP77xcwnhtu?=
 =?us-ascii?Q?VK3gwQ5yIokYqpZieIvwpmcVK8SM8eGJv1lUZQu9V2RP/YVNdZqqyshfnyar?=
 =?us-ascii?Q?BVClUZDsWUqC7rZ2RBfv8Jt2BhtTK2zN59pJhoV7JHD40nD721EMNiEO7fWs?=
 =?us-ascii?Q?28kkFTyAlROfEi16mTIq//xphlXThJ1wS+mjhxmC2afKg2R4/U4hkI9wo5+k?=
 =?us-ascii?Q?iqlKDfv3yBqoE0tLVHLNS7SZeUXFMqdu99+NCf2fkQRR6C6eJVLN68IdVcFp?=
 =?us-ascii?Q?D0v5WjnYbgBSrnucEBmfscT3OINnChfm1l73efrCTAUh8th14zsBIbm2WARJ?=
 =?us-ascii?Q?DGJL+XaeD5/CqkKeMWZFq9r3n4E3j9pxZ5x0P3gr8PGHqZW8WwWmvHu0SbO2?=
 =?us-ascii?Q?odUlS+tgmGTdMwEm0cUQVw1mN+kdM9t0ihlE1OEm1Aq5UhYJ01Uq/p+ls18J?=
 =?us-ascii?Q?d/GQp/ckq1lxR+K74U9OVKSG/2Ls311tpsH1xnVqEKMisTXeExbNrqCoiOUh?=
 =?us-ascii?Q?fJTBTr1SR3/yfbfaPWxR7tAAE1ztBcG/ynmW6ngIvSkOfEht2R8KjDlZ0yX1?=
 =?us-ascii?Q?g1+i9J4LdX7A1cfwxwBIHWbcKk5u9Ya3BVXaGv8QbpRavVGRg4+plcc0qoCU?=
 =?us-ascii?Q?yjsfXrJ/sA5VTB1wKN3zgc9/pDvuFfOnxhDuHjbE8XO6qDOu3Hidv8w6JZiq?=
 =?us-ascii?Q?nxsZYW7JS6xb5Z3qTUOTsWKlLQKKK0AcR/CC/UPsE7kq79d7/p6LPyusHWiN?=
 =?us-ascii?Q?jL9/jPcg7vFnWZO13Lvwwdkvf4tyRS36muWaU+92BCGwXlRDlWd1C8uI0uUR?=
 =?us-ascii?Q?TONaGFh39ec+hDp4nemH3nDVHkAvFtjvGAmMdNbMsdXQHasuNKVe/4dgqIO9?=
 =?us-ascii?Q?f4zSeT9iepp9il184bqs230bQMFNPhAbt+kV+lLx7l0GVI2SSrlydqqotPE6?=
 =?us-ascii?Q?Ft71Vh/TIe7eu1ZpaxOeHfGeYTB3tsuu+Viq7DLuf6yysJHiVwN4zAD8UCjV?=
 =?us-ascii?Q?/BpvDBPmgaZZ41VMYRbwSmOUkDlB60Is/OzUaPwlAZtG0diVGkPryE/qqrA7?=
 =?us-ascii?Q?s3y65adZY6FLEoFOzqq/fGECA+eDGdKqNVzmDEmqS+5GJhe9qJfgk/BJLU/d?=
 =?us-ascii?Q?FO63/DUlsP2rs1Uz1hGzIoywcLHqHhOICjYd+M0bWX23CSrhjhoi4dBW7Na7?=
 =?us-ascii?Q?Pic7B7uEFg0YIl/fAaJUfxb3EFh2BYf+AH1wPE1UlSV0uzdYmFuolNCCKPFa?=
 =?us-ascii?Q?DfzTlEEA+ZluNBQbAKj+uYOf1Pf5nwIFZQCYOokX1AgwWnd15ZoDG//Y32z7?=
 =?us-ascii?Q?+/iIEjnPpA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbeb4d09-edf8-4106-e209-08de76147960
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:44.5551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyQH1eMeoJYfEqX2Hi0ok+85xHxjXx0ukP2sxhk2xTH+foYfsoUXXjLQDlTS2joo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

The RISC-V format is a fairly simple 5 level page table not unlike the x86
one. It has optional support for a single contiguous page size of 64k (16
x 4k).

The specification describes a 32-bit format, the general code can support
it via a #define but the iommu side implementation has been left off until
a user comes.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |  11 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 8 files changed, 394 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index a78b295f264d23..0bb98fe581fe9c 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -5,6 +5,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_VTDSS=y
+CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index ce4fb478691457..f4ed1add58b749 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -52,6 +52,16 @@ config IOMMU_PT_VTDSS
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_RISCV64
+       tristate "IOMMU page table for RISC-V 64 bit Sv57/Sv48/Sv39"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for RISC-V 64 bit 3/4/5 level page table.
+	  It supports 4K/2M/1G/512G/256T page sizes and can decode a sign
+	  extended portion of the 64 bit IOVA space.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_X86_64
 	tristate "IOMMU page table for x86 64-bit, 4/5 levels"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -66,6 +76,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	default KUNIT_ALL_TESTS
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 976b49ec97dca1..ea024d582594ee 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -5,6 +5,8 @@ iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_riscv.h b/drivers/iommu/generic_pt/fmt/defs_riscv.h
new file mode 100644
index 00000000000000..cf67474d5ebaeb
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_riscv.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_RISCV_H
+#define __GENERIC_PT_FMT_DEFS_RISCV_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+#ifdef PT_RISCV_32BIT
+typedef u32 pt_riscv_entry_t;
+#define riscvpt_write_attrs riscv32pt_write_attrs
+#else
+typedef u64 pt_riscv_entry_t;
+#define riscvpt_write_attrs riscv64pt_write_attrs
+#endif
+
+typedef pt_riscv_entry_t pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct riscvpt_write_attrs {
+	pt_riscv_entry_t descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs riscvpt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
new file mode 100644
index 00000000000000..cbf60fffa9bf7d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT riscv
+#define PT_FMT_VARIANT 64
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
+	 BIT(PT_FEAT_RISCV_SVNAPOT_64K))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/riscv.h b/drivers/iommu/generic_pt/fmt/riscv.h
new file mode 100644
index 00000000000000..a7fef6266a36a6
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/riscv.h
@@ -0,0 +1,313 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ * RISC-V page table
+ *
+ * This is described in Sections:
+ *  12.3. Sv32: Page-Based 32-bit Virtual-Memory Systems
+ *  12.4. Sv39: Page-Based 39-bit Virtual-Memory System
+ *  12.5. Sv48: Page-Based 48-bit Virtual-Memory System
+ *  12.6. Sv57: Page-Based 57-bit Virtual-Memory System
+ * of the "The RISC-V Instruction Set Manual: Volume II"
+ *
+ * This includes the contiguous page extension from:
+ *  Chapter 13. "Svnapot" Extension for NAPOT Translation Contiguity,
+ *     Version 1.0
+ *
+ * The table format is sign extended and supports leafs in every level. The spec
+ * doesn't talk a lot about levels, but level here is the same as i=LEVELS-1 in
+ * the spec.
+ */
+#ifndef __GENERIC_PT_FMT_RISCV_H
+#define __GENERIC_PT_FMT_RISCV_H
+
+#include "defs_riscv.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+#include <linux/sizes.h>
+
+enum {
+	PT_ITEM_WORD_SIZE = sizeof(pt_riscv_entry_t),
+#ifdef PT_RISCV_32BIT
+	PT_MAX_VA_ADDRESS_LG2 = 32,
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 34,
+	PT_MAX_TOP_LEVEL = 1,
+#else
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 56,
+	PT_MAX_TOP_LEVEL = 4,
+#endif
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/* fsc.PPN is 44 bits wide, all PPNs are 4k aligned */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(55, 12),
+};
+
+/* PTE bits */
+enum {
+	RISCVPT_V = BIT(0),
+	RISCVPT_R = BIT(1),
+	RISCVPT_W = BIT(2),
+	RISCVPT_X = BIT(3),
+	RISCVPT_U = BIT(4),
+	RISCVPT_G = BIT(5),
+	RISCVPT_A = BIT(6),
+	RISCVPT_D = BIT(7),
+	RISCVPT_RSW = GENMASK(9, 8),
+	RISCVPT_PPN32 = GENMASK(31, 10),
+
+	RISCVPT_PPN64 = GENMASK_ULL(53, 10),
+	RISCVPT_PPN64_64K = GENMASK_ULL(53, 14),
+	RISCVPT_PBMT = GENMASK_ULL(62, 61),
+	RISCVPT_N = BIT_ULL(63),
+
+	/* Svnapot encodings for ppn[0] */
+	RISCVPT_PPN64_64K_SZ = BIT(13),
+};
+
+#ifdef PT_RISCV_32BIT
+#define RISCVPT_PPN RISCVPT_PPN32
+#define pt_riscv pt_riscv_32
+#else
+#define RISCVPT_PPN RISCVPT_PPN64
+#define pt_riscv pt_riscv_64
+#endif
+
+#define common_to_riscvpt(common_ptr) \
+	container_of_const(common_ptr, struct pt_riscv, common)
+#define to_riscvpt(pts) common_to_riscvpt((pts)->range->common)
+
+static inline pt_oaddr_t riscvpt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(RISCVPT_PPN, pts->entry), PT_GRANULE_LG2SZ);
+}
+#define pt_table_pa riscvpt_table_pa
+
+static inline pt_oaddr_t riscvpt_entry_oa(const struct pt_state *pts)
+{
+	if (pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K) &&
+	    pts->entry & RISCVPT_N) {
+		PT_WARN_ON(pts->level != 0);
+		return oalog2_mul(FIELD_GET(RISCVPT_PPN64_64K, pts->entry),
+				  ilog2(SZ_64K));
+	}
+	return oalog2_mul(FIELD_GET(RISCVPT_PPN, pts->entry), PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa riscvpt_entry_oa
+
+static inline bool riscvpt_can_have_leaf(const struct pt_state *pts)
+{
+	return true;
+}
+#define pt_can_have_leaf riscvpt_can_have_leaf
+
+/* Body in pt_fmt_defaults.h */
+static inline unsigned int pt_table_item_lg2sz(const struct pt_state *pts);
+
+static inline unsigned int
+riscvpt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_RISCV_SVNAPOT_64K) &&
+	    pts->entry & RISCVPT_N) {
+		PT_WARN_ON(!pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K));
+		PT_WARN_ON(pts->level);
+		return ilog2(16);
+	}
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 riscvpt_entry_num_contig_lg2
+
+static inline unsigned int riscvpt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 riscvpt_num_items_lg2
+
+static inline unsigned short
+riscvpt_contig_count_lg2(const struct pt_state *pts)
+{
+	if (pts->level == 0 && pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K))
+		return ilog2(16);
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 riscvpt_contig_count_lg2
+
+static inline enum pt_entry_type riscvpt_load_entry_raw(struct pt_state *pts)
+{
+	const pt_riscv_entry_t *tablep = pt_cur_table(pts, pt_riscv_entry_t);
+	pt_riscv_entry_t entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & RISCVPT_V))
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    ((entry & (RISCVPT_X | RISCVPT_W | RISCVPT_R)) != 0))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw riscvpt_load_entry_raw
+
+static inline void
+riscvpt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	pt_riscv_entry_t *tablep = pt_cur_table(pts, pt_riscv_entry_t);
+	pt_riscv_entry_t entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	entry = RISCVPT_V |
+		FIELD_PREP(RISCVPT_PPN, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+
+	if (pts_feature(pts, PT_FEAT_RISCV_SVNAPOT_64K) && pts->level == 0 &&
+	    oasz_lg2 != PT_GRANULE_LG2SZ) {
+		u64 *end;
+
+		entry |= RISCVPT_N | RISCVPT_PPN64_64K_SZ;
+		tablep += pts->index;
+		end = tablep + log2_div(SZ_64K, PT_GRANULE_LG2SZ);
+		for (; tablep != end; tablep++)
+			WRITE_ONCE(*tablep, entry);
+	} else {
+		/* FIXME does riscv need this to be cmpxchg? */
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry riscvpt_install_leaf_entry
+
+static inline bool riscvpt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	pt_riscv_entry_t entry;
+
+	entry = RISCVPT_V |
+		FIELD_PREP(RISCVPT_PPN, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table riscvpt_install_table
+
+static inline void riscvpt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits =
+		pts->entry & (RISCVPT_R | RISCVPT_W | RISCVPT_X | RISCVPT_U |
+			      RISCVPT_G | RISCVPT_A | RISCVPT_D);
+}
+#define pt_attr_from_entry riscvpt_attr_from_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_riscv_64
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->riscv_64pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, riscv_64pt.common)
+			->iommu;
+}
+
+static inline int riscvpt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	u64 pte;
+
+	pte = RISCVPT_A | RISCVPT_U;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= RISCVPT_W | RISCVPT_R | RISCVPT_D;
+	if (iommu_prot & IOMMU_READ)
+		pte |= RISCVPT_R;
+	if (!(iommu_prot & IOMMU_NOEXEC))
+		pte |= RISCVPT_X;
+
+	/* Caller must specify a supported combination of flags */
+	if (unlikely((pte & (RISCVPT_X | RISCVPT_W | RISCVPT_R)) == 0))
+		return -EOPNOTSUPP;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot riscvpt_iommu_set_prot
+
+static inline int
+riscvpt_iommu_fmt_init(struct pt_iommu_riscv_64 *iommu_table,
+		       const struct pt_iommu_riscv_64_cfg *cfg)
+{
+	struct pt_riscv *table = &iommu_table->riscv_64pt;
+
+	switch (cfg->common.hw_max_vasz_lg2) {
+	case 39:
+		pt_top_set_level(&table->common, 2);
+		break;
+	case 48:
+		pt_top_set_level(&table->common, 3);
+		break;
+	case 57:
+		pt_top_set_level(&table->common, 4);
+		break;
+	default:
+		return -EINVAL;
+	}
+	table->common.max_oasz_lg2 =
+		min(PT_MAX_OUTPUT_ADDRESS_LG2, cfg->common.hw_max_oasz_lg2);
+	return 0;
+}
+#define pt_iommu_fmt_init riscvpt_iommu_fmt_init
+
+static inline void
+riscvpt_iommu_fmt_hw_info(struct pt_iommu_riscv_64 *table,
+			  const struct pt_range *top_range,
+			  struct pt_iommu_riscv_64_hw_info *info)
+{
+	phys_addr_t top_phys = virt_to_phys(top_range->top_table);
+
+	info->ppn = oalog2_div(top_phys, PT_GRANULE_LG2SZ);
+	PT_WARN_ON(top_phys & ~PT_TOP_PHYS_MASK);
+
+	/*
+	 * See Table 3. Encodings of iosatp.MODE field" for DC.tx.SXL = 0:
+	 *  8 = Sv39 = top level 2
+	 *  9 = Sv38 = top level 3
+	 *  10 = Sv57 = top level 4
+	 */
+	info->fsc_iosatp_mode = top_range->top_level + 6;
+}
+#define pt_iommu_fmt_hw_info riscvpt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_riscv_64_cfg riscv_64_kunit_fmt_cfgs[] = {
+	[0] = { .common.features = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.features = 0,
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.features = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs riscv_64_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_RISCV_SVNAPOT_64K),
+};
+#endif
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 6a9a1acb5aad37..fc5d0b5edadc08 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -175,6 +175,22 @@ enum {
 	PT_FEAT_VTDSS_FORCE_WRITEABLE,
 };
 
+struct pt_riscv_32 {
+	struct pt_common common;
+};
+
+struct pt_riscv_64 {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * Support the 64k contiguous page size following the Svnapot extension.
+	 */
+	PT_FEAT_RISCV_SVNAPOT_64K = PT_FEAT_FMT_START,
+
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd087..49d9addb98c52c 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -275,6 +275,17 @@ struct pt_iommu_vtdss_hw_info {
 
 IOMMU_FORMAT(vtdss, vtdss_pt);
 
+struct pt_iommu_riscv_64_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_riscv_64_hw_info {
+	u64 ppn;
+	u8 fsc_iosatp_mode;
+};
+
+IOMMU_FORMAT(riscv_64, riscv_64pt);
+
 struct pt_iommu_x86_64_cfg {
 	struct pt_iommu_cfg common;
 	/* 4 is a 57 bit 5 level table */
-- 
2.43.0

