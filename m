Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF4A42CB0D;
	Mon,  6 Jul 2026 16:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355392; cv=fail; b=Stq84Py3TLpDtRKYz4jOG/asyehtzv7QTRZP6yDviRGkda4plINSicggbq89Owm8/NhrjSqec4OGhh9I0eUMdIlkxC9p3xE7YoRsYiBBGeF3ZnUZ6+t/MNlltUrISpng2pufa3O6It32Cv8jndcvkH0cYFyEcNrPmiy7AXVjcLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355392; c=relaxed/simple;
	bh=pJDgjBSZ20whZg7WRYdLfYvQ6XhTlMBQCTcFXiE2EOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eRmc3EiRvvHGoo80ks89UG23kQKwGGmoMUHLYCcGxtB6hRR2itQSSHVytKKq7X/cOaOewOo/4dd6j6YokNXDxbHY/qXqdZPz+BhRJB9+hbv3e2nQXtF5vldC3jVuWHN/qE55VfZvUtORV4H1gT+rUtcXTTII0qxqPZ1/5ka0Njg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aCBoDjjV; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aCBoDjjV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ocy8Fe4lt31sa4vO2eaF1qDlDJUIecUyoVJQvEfJK4wejOZKIpt+t6U1ni76HMSaHFKxygqlb8CPzl808X7BXRFLCJYGTyhxemcpLRMe/aArxMpbDcRxv/Anjpm2eMKozJHPvv114tuC8o/Fsx10SNUMgxGabsZm7AMRONdv2U3Yksv/vhSQH1BswTJUzug5cd6OEJZ0bh294TB+jVTODQ4C1wyrns678IOY3mozlXhR+NF//mpKI+1F+gN6nxKLWpiaxJ/sG6mj+5UWO1rgzlRXGrM+Q2Omta4wE1HpixJjS85MUft47wHGAogbyZMSKBHfnPRlcijP5Thk2kTsFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvB7FkwQkzRG04U1u09YQD6gkSFk/Prle1HwlizfY3I=;
 b=nE8l+RQEebL7vBKn8fqChGER/d5cB8nmRboIARxO5AEI4mxlM7S6ttZMXndkEFNTa0ih7CD+wX/+04ip6Y01+A54CYXDHIwObIsGyEEqF0NOeokR0dHUvBoJT3Ehyv+Kxi18BPnrLB7Od+11dCggVtGnxXUmyXIJr74jwfzwNC9Q06yNQshSQbGCv7L93Z1C2O3q0Fmv6ak+w0sGy9Exl2xmxY9qzflg/QCYVBnO6KAIjJcA/9/pm7LNaMPNbrwcAe927OrxFIQcwt4lNe5jyDRXIwWRsVeS4YgCbe9Eqcf0s2qjXHj1w9OtAtEMZyDsYpTrY9YRzr3ySBtN0kk0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvB7FkwQkzRG04U1u09YQD6gkSFk/Prle1HwlizfY3I=;
 b=aCBoDjjVx75t5Bp2jWrtte44z7m3Oznl/v2RpfoKHPvgNt4+CiUWYuq082/H9yqI78SJvDwsuDmidJGEyJl97gdzSjTkJsPtxn8i/ZfLECFLmsPQnvlNnmljsO4Jh6Bwq7K3HbzSoXu63vBSJoRculQAzXfA8SkISt7M7oU+y8i9jELaPYBaaQRmhZfIk4OBgNVxnZ7TytEQMsYnPl+KTx18WFQmR4dzJJGd6MuA2J9tZTkVxQAxfxQRdMHi5OOmDbjOlDuaAETFGbs8yXOvfxkk7lccV6lSGJPC3n53ImA/0KlMYCuxLOg7OjG90mFuB4Hiwf0tv0jN0aLCEKewRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:20 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 3/7] iommupt: Add the 64 bit ARMv8 page table format
Date: Mon,  6 Jul 2026 13:29:09 -0300
Message-ID: <3-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:23a::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e7404a-8ce9-444a-3e9e-08dedb7bb8f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|11063799006|3023799007|22082099003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0mNnqKJxxAj/RddSQ4piuixcBABRKLoOoitsOWwha0kNH3NaqAxB6orIv/4o6HNFS2dxmdzhHJbUu+/P3m2JbXdEgj23FIsnwI6q60vE2a7dDwXwGwdthTGA3HoT8tbsbKwiPK+H+zdRh06r7SITQyVvkUB7bSheB/lKQwM94OqqSJdFTd0/skAwaue9UWp4jlH2f0TQExwXt51chuaBHm4dxSDmnfgLc0yRbNVyIjsBzwqqb0Xi2PbHADCglOFwaMbwBmZa4omVx6Y/M9cW5DnalzmCAsuJo5cvkjFJUo5zqeI8wfujtAMpj7uu1fZWS9cxZFI3gXyIcD5tNiFVdQl+ZATuTrbeMvpEY3KkSf4afpO3DW/pMikLmhY983ME822V5F6wcdXc9PygoOTJC4FuTXoWHGSPF110ORF0PKUdTaUPTHMAnz9rA0aq/G2DapizM7iRbiKAPuQJjI1F0SkgfP/E9ezOQbVCw2lTlYqm9rka8oQNETQne42lrCuUxTjTp2cvR+qqxOHZu4kvY6/YRb2gWqeY4fMBp3q3tYIdj9KELSJJBsxUsgnNxZXagq5KIWQc5lHAAnEquR+HUNKP75e2Z6Lf0U4gcb+Qfsx/6jbn+t4L759AReJ/sXYceQc+Tw/1R2DegjX1uQEQFR+c8kgJljHxJ/aisdx5DZw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(11063799006)(3023799007)(22082099003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NAUDZOod7ITneQmWiwfBn8tLAjVuey3ZZZRlqgeE5bUXohXh0kOpy2AEpARq?=
 =?us-ascii?Q?1370xgN5Dg5fV2w3xjrIlVgpqcZTN3l+7eRbHwTB5EcNBCbh80tm9OjGiwNm?=
 =?us-ascii?Q?VP4INWF0OBJXQmNhwbvMGMK6sVh6LHwGBiugFFYLnvRd2QhuY5CwwlJTJ+5t?=
 =?us-ascii?Q?fyhxgKDiQ5HKrmEzXZ8jXX95nnAWMwCHHxHfD2wdKxb0UmfA51HPo1qtngDn?=
 =?us-ascii?Q?lsHE9vzZ5LHUqGYO+HRn59RZm/e1lj3ZHqml8p0zDnLCXsy9mK15DA6XUvvA?=
 =?us-ascii?Q?L00j4vRogkcWZ6zq5QUHSWNLkjTOkh2cgDxohYdGDLjTcwkH9oOxLk/BVCoR?=
 =?us-ascii?Q?SovYf6p/3vjfQHddtAtGbjKU2mybYjWo34lOsCeUM/WYUs/cR8HVXI8Sl6mu?=
 =?us-ascii?Q?LkwsxwNgyTXFjWiPuQcN/3Ns2JOXFZ0Z9zLrwVHQzNvIcFLGk2xX9dg/HTfU?=
 =?us-ascii?Q?Of9khi2iMAUJBdT+BdIhGDX8949p+Uv4NbK/mxoqrCflSA3g/WfSCkaBYUz2?=
 =?us-ascii?Q?dy3/WkcO4vdiS7R9u3oly6csVi3ZBani+zheJvw0RQTfpX1qku4HrXVljS2M?=
 =?us-ascii?Q?PKLo1p3NZnrsWjx9pcfh132pekWfSXdmUVOvDGXtYVr2/f5K5HUMXInVYCFR?=
 =?us-ascii?Q?MF7w96PyLU3/+alYJgDbH8MkOY5oXRwjJZLC71kHw/RLmcRYjbDKHqfApLRm?=
 =?us-ascii?Q?erFpI7ETbhV6pkrS+0jMu5EZfCSPXSYdEj/WucQTYrC1lwvdAweXaqZ9jizw?=
 =?us-ascii?Q?yIorOvXNk/CBVfmWIxxlK00IG1oOPKNBHrJc1BMro8n3YrGtkgKH7jaVnUDY?=
 =?us-ascii?Q?cqQrFnKQXrS58Az/zK4M4yhB2/bg//2dG6XdAas8aMC2zG16p4gdiGbsaT6q?=
 =?us-ascii?Q?kFRKbrCBqPaOVoI5tbHhEtWoYdGPaoIM+5oSdzpKuCXF66MrImnOfRmPSn7I?=
 =?us-ascii?Q?Ifzn+FjEYiJAB461Q6Q2qk4x+qukG9n/Yf7nvZQnkgkMSBdcgLZK+ZRgV51L?=
 =?us-ascii?Q?BeJYV/rTIMiMG99+jEwWa0J+eECXihl3R2hePhrZx5XRwI9IY6ckALsobLFD?=
 =?us-ascii?Q?cVol14WW5aotaKopIYY4wQ0S+ODl6KTsfJtla3m1ElQf1l4KhciwOK+Syauy?=
 =?us-ascii?Q?iZWG0gPuRea49Uk6LJojzfu1QtElfmZxyfYm7KrCTIP3pEF8W/PD+MxaM6l6?=
 =?us-ascii?Q?zZzIJF3j9MNOyrqkywfiNC03J3PEcnMcqJlTwgCW1ZBkp3v+BSARBTaIJ3LQ?=
 =?us-ascii?Q?v/GhiodlIPtKIyNg9v8MdJKmDsYprvstmT/8U+O6rcVsGCesTNhW8m6MUPWr?=
 =?us-ascii?Q?F6a6Sj/vTimuA5STeR5YtvRlpMe3YTH5sRY9e/vMS5zZ5ceokj0t7gWI5USD?=
 =?us-ascii?Q?zgQOvyqQCqb/Q4YfXu3QS+DLfPbGSrswdZ7Ii8b6hatV0faL5xrh6vQVIGpL?=
 =?us-ascii?Q?WPfX1ljESbBHygg/xC/cLjEZbeAFbbGLmKKM3f4+ctjf28u752/dyYcZt4AP?=
 =?us-ascii?Q?pQiNhjJ9/IFrETFVmVCzaTK3sx9DTF8OOFpy6hjFtj3SwhNpRd29Wlav8iIr?=
 =?us-ascii?Q?MyzTcxyX/e3CiBMJ9CFrEkohciCCZUnMuBjsgV2JboG/8NL6gy/8CjA1AiaI?=
 =?us-ascii?Q?ke9CPpSklsNW7MBs3PfacTFKzXdbD3b9wx07x4u7wHehy1/CbxiVJ4vsVgSa?=
 =?us-ascii?Q?/0PJaolPc/ZVVntv3ttgne6w4prGDtxyfkgilZsHELwIhsjV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e7404a-8ce9-444a-3e9e-08dedb7bb8f1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:16.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejO5ptXiNc0StK/+hWzNNQGcPDeLMt35zhS2bsrpyN3iL/NgvV0f6k+5qGO9v8Pm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926

The features, format and naming is taking from the ARMv8 VMSAv8-64
chapter. By far ARMv8 is the most complex format supported by generic page
table, with the largest number of options and configurations.

ARMv8 uses almost all the features of the common implementation:

 - Contiguous pages
 - Leaf pages at many levels
 - Variable starting top level
 - Variable size top level supporting concatenated tables with a high
 - order top table allocation
 - Dirty tracking
 - Low (TTB0) or high (TTB1) starting VA
 - Software bits

Compared to the io-pgtable version this also implements the contiguous
page hint, and supports dirty readback from the S2. It implements the
original io-pgtable intention of always using S2 concatenated tables
instead of only when mandatory.

iommupt's incoherent flushing algorithm was modeled after the ARM
io-pgtable version so there is no change here.

Additionaly it includes implementations for the LPA, LVA, and LPA2
features however they will be compiled off for the iommu build until a
driver actually needs thems. With these features it can support the "level
-1" to produce a 5 level table similar to x86, as well as all the
different placements of OA bits defined by the spec.

This is supported by a compare test that creates parallel iommupt and
io-pgtable instances with matching parameters and validates that every
tree level is the "same" across several meaningful tests. It covers the S2
concatenated pages, the recent bugs found in the io-pgtable logic and a
range of VA sizes.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |    1 +
 drivers/iommu/generic_pt/Kconfig           |   12 +
 drivers/iommu/generic_pt/fmt/Makefile      |    2 +
 drivers/iommu/generic_pt/fmt/armv8.h       | 1124 ++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h  |   23 +
 drivers/iommu/generic_pt/fmt/iommu_armv8.c |   13 +
 include/linux/generic_pt/common.h          |   42 +
 include/linux/generic_pt/iommu.h           |   73 ++
 8 files changed, 1290 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 0bb98fe581fe9c..08a0d07504d90f 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_ARMV8=y
 CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index f4ed1add58b749..4eb1af5953141b 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -42,6 +42,17 @@ config IOMMU_PT_AMDV1
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_ARMV8
+	tristate "IOMMU page table for 64 bit ARMv8"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the ARMv8 VMSAv8-64 and the VMSAv8-32
+	  long descriptor pagetable format. This format supports both stage-1
+	  and stage-2, as well as address spaces up to 48-bits in size with
+	  4K, 16K, and 64K granule sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_VTDSS
        tristate "IOMMU page table for Intel VT-d Second Stage"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -76,6 +87,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_ARMV8 || !IOMMU_PT_ARMV8
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index ea024d582594ee..6f0d69a72e7471 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -3,6 +3,8 @@
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8) += armv8
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
new file mode 100644
index 00000000000000..1bf796c02589aa
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -0,0 +1,1124 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * The page table format described by ARM DDI 0487 L.b, Chapter D8
+ * "The AArch64 Virtual Memory System Architecture" (VMSAv8-64).
+ * With the right cfg this will also implement the VMSAv8-32 Long
+ * Descriptor format.
+ *
+ * This was called io-pgtable-arm.c and ARM_xx_LPAE_Sx.
+ *
+ * NOTE! The level numbering is consistent with the Generic Page Table API, but
+ * is reversed from what the ARM documents use.
+ *
+ *   generic_pt | ARM   | 4K coverage | 16K coverage | 64K coverage
+ *   -----------+-------+-------------+--------------+-------------
+ *   0          |  3    | 4KB page    | 16KB page    | 64KB page
+ *   1          |  2    | 2MB         | 32MB         | 512MB
+ *   2          |  1    | 1GB         | 64GB         | 4TB
+ *   3          |  0    | 512GB       | 128TB        | -
+ *   4          | -1    | 256TB       | -            | -
+ */
+#ifndef __GENERIC_PT_FMT_ARMV8_H
+#define __GENERIC_PT_FMT_ARMV8_H
+
+#include "defs_armv8.h"
+#include "../pt_defs.h"
+
+#include <asm/page.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/container_of.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+#include <linux/string.h>
+
+/*
+ * Aid for understanding how the spec numerology relates to the code. Note the
+ * expression "level > ARMLx" means any ARMLy such that level < x
+ */
+enum {
+	ARML3 = 0,
+	ARML2 = 1,
+	ARML1 = 2,
+	ARML0 = 3,
+	ARMLn1 = 4,
+};
+
+enum {
+	PT_MAX_TOP_LEVEL = PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) ? ARMLn1 :
+								      ARML0,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+};
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+	/* See armv8pt_iommu_fmt_init() */
+	PT_MAX_VA_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LVA) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+
+	/*
+	 * D24.2.195 TTBR_ELx BADDR:
+	 *
+	 * Bits A[(x-1):0] of the stage 1 translation table base address are
+	 * zero. Address bit x is the minimum address bit required to align the
+	 * translation table to the size of the table. x is calculated based on
+	 * LOG2(StartTableSize), as described in VMSAv9-128. The smallest
+	 * permitted value of x is 5.
+	 *
+	 * R_KBLCR requires the table to be aligned to its own size.
+	 *
+	 * SMMU S2TTB additionally says: In addition, a 64-byte minimum
+	 * alignment on starting-level translation table addresses is imposed
+	 * when S2TG selects 64KB granules and the effective S2PS value
+	 * indicates 52-bit output. In this case bits [5:0] are treated as zero.
+	 */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(51, 5),
+};
+
+/* Common PTE bits */
+enum {
+	ARMV8PT_FMT_VALID = BIT(0),
+	ARMV8PT_FMT_PAGE = BIT(1),
+	ARMV8PT_FMT_TABLE = BIT(1),
+	ARMV8PT_FMT_NS = BIT(5),
+	ARMV8PT_FMT_SH = GENMASK(9, 8),
+	ARMV8PT_FMT_AF = BIT(10),
+
+	/* 64K FEAT_LPA: OA[51:48] in bits[15:12], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA = GENMASK_ULL(15, 12),
+	/* 4K/16K FEAT_LPA2 (DS=1): OA[51:50] in bits[9:8], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA2 = GENMASK_ULL(9, 8),
+
+	ARMV8PT_FMT_DBM = BIT_ULL(51),
+	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
+	ARMV8PT_FMT_UXN = BIT_ULL(53),
+	ARMV8PT_FMT_PXN = BIT_ULL(54),
+	ARMV8PT_FMT_NSTABLE = BIT_ULL(63),
+};
+
+/* S1 PTE bits */
+enum {
+	ARMV8PT_FMT_ATTRINDX = GENMASK(4, 2),
+	ARMV8PT_FMT_AP = GENMASK(7, 6),
+	ARMV8PT_FMT_nG = BIT(11),
+};
+
+enum {
+	ARMV8PT_SH_IS = 3,
+	ARMV8PT_SH_OS = 2,
+
+	ARMV8PT_RGN_NC = 0,
+	ARMV8PT_RGN_WBWA = 1,
+
+	ARMV8PT_AP_UNPRIV = 1,
+	ARMV8PT_AP_RDONLY = 2,
+};
+
+enum {
+	ARMV8PT_MAIR_ITEM = GENMASK_U32(7, 0),
+
+	ARMV8PT_MAIR_ATTR_IDX_NC = 0,
+	ARMV8PT_MAIR_ATTR_IDX_CACHE = 1,
+	ARMV8PT_MAIR_ATTR_IDX_DEV = 2,
+	ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE = 3,
+
+	ARMV8PT_MAIR_ATTR_NC = 0x44,
+	ARMV8PT_MAIR_ATTR_WBRWA = 0xff,
+	ARMV8PT_MAIR_ATTR_DEVICE = 0x04,
+	ARMV8PT_MAIR_ATTR_INC_OWBRWA = 0xf4,
+};
+
+/* S2 PTE bits */
+enum {
+	ARMV8PT_FMT_S2MEMATTR = GENMASK(5, 2),
+	ARMV8PT_FMT_S2AP = GENMASK(7, 6),
+};
+
+enum {
+	SZLG2_4K = 12,
+	SZLG2_16K = 14,
+	SZLG2_64K = 16,
+};
+
+enum {
+	/*
+	 * For !S2FWB these code to:
+	 *  1111 = Normal outer write back cacheable / Inner Write Back Cacheable
+	 *         Permit S1 to override
+	 *  0101 = Normal Non-cachable / Inner Non-cachable
+	 *  0001 = Device / Device-nGnRE
+	 * For S2FWB these code to:
+	 *  0110 Force Normal Write Back
+	 *  0101 Normal* is forced Normal-NC, Device unchanged
+	 *  0001 Force Device-nGnRE
+	 */
+	ARMV8PT_MEMATTR_FWB_WB = 6,
+	ARMV8PT_MEMATTR_OIWB = 0xf,
+	ARMV8PT_MEMATTR_NC = 5,
+	ARMV8PT_MEMATTR_DEV = 1,
+
+	ARMV8PT_S2AP_READ = 1,
+	ARMV8PT_S2AP_WRITE = 2,
+};
+
+#define common_to_armv8pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_armv8, common)
+#define to_armv8pt(pts) common_to_armv8pt((pts)->range->common)
+
+/* Runtime granule accessors */
+static inline unsigned int armv8pt_granule_lg2sz(const struct pt_state *pts)
+{
+	return to_armv8pt(pts)->granule_lg2sz;
+}
+
+static inline u64 armv8pt_fmt_oa48(unsigned int granule_lg2sz)
+{
+	return GENMASK_ULL(47, granule_lg2sz);
+}
+
+/*
+ * The generic implementations cannot be used if PT_GRANULE_LG2SZ is dynamic.
+ */
+static inline unsigned int armv8pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	unsigned int granule_lg2sz = armv8pt_granule_lg2sz(pts);
+
+	return granule_lg2sz +
+	       (granule_lg2sz - ilog2(PT_ITEM_WORD_SIZE)) * pts->level;
+}
+#define pt_table_item_lg2sz armv8pt_table_item_lg2sz
+
+static inline unsigned int armv8pt_pgsz_lg2_to_level(struct pt_common *common,
+						     unsigned int pgsize_lg2)
+{
+	unsigned int granule_lg2sz = common_to_armv8pt(common)->granule_lg2sz;
+
+	return (pgsize_lg2 - granule_lg2sz) /
+	       (granule_lg2sz - ilog2(sizeof(u64)));
+}
+#define pt_pgsz_lg2_to_level armv8pt_pgsz_lg2_to_level
+
+static inline bool armv8pt_has_system_page_size(const struct pt_common *common)
+{
+	return common_to_armv8pt(common)->granule_lg2sz == PAGE_SHIFT;
+}
+#define pt_has_system_page_size armv8pt_has_system_page_size
+
+static inline pt_oaddr_t armv8pt_oa(const struct pt_state *pts)
+{
+	u64 entry = pts->entry;
+	unsigned int granule_lg2sz = armv8pt_granule_lg2sz(pts);
+	pt_oaddr_t oa;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		/* 4K/16K with DS=1: OA[49:granule] direct, OA[51:50] in [9:8] */
+		oa = entry & GENMASK_ULL(49, granule_lg2sz);
+		oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA2, entry))
+		      << 50;
+	} else {
+		oa = entry & GENMASK_ULL(47, granule_lg2sz);
+		if (PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA) &&
+		    granule_lg2sz == SZLG2_64K)
+			oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA,
+						     entry))
+			      << 48;
+	}
+	return oa;
+}
+
+static inline pt_oaddr_t armv8pt_table_pa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_table_pa armv8pt_table_pa
+
+/*
+ * Return a block or page entry pointing at a physical address. Returns the
+ * address adjusted for the item in a contiguous case.
+ */
+static inline pt_oaddr_t armv8pt_item_oa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_item_oa armv8pt_item_oa
+
+static inline bool armv8pt_can_have_leaf(const struct pt_state *pts)
+{
+	unsigned int granule_lg2sz = armv8pt_granule_lg2sz(pts);
+
+	/*
+	 * Tables D8-16/17 (4K), D8-26/27 (16K), D8-35/36 (64K).
+	 *
+	 * When FEAT_LPA2, one additional level gains block descriptors:
+	 *   4K:  ARM level 0 (pt 3) gains 512GB blocks
+	 *   16K: ARM level 1 (pt 2) gains 64GB blocks
+	 * ARM Level -1 (pt 4) is always table-only.
+	 */
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		if (granule_lg2sz == SZLG2_4K && pts->level > ARML0)
+			return false;
+		if (granule_lg2sz == SZLG2_16K && pts->level > ARML1)
+			return false;
+		if (granule_lg2sz == SZLG2_64K && pts->level > ARML2)
+			return false;
+	} else {
+		if (granule_lg2sz == SZLG2_4K && pts->level > ARML1)
+			return false;
+		if (granule_lg2sz == SZLG2_16K && pts->level > ARML2)
+			return false;
+		if (granule_lg2sz == SZLG2_64K &&
+		    pts->level > (pts_feature(pts, PT_FEAT_ARMV8_LPA) ?
+				  ARML1 : ARML2))
+			return false;
+	}
+	return true;
+}
+#define pt_can_have_leaf armv8pt_can_have_leaf
+
+/* Number contiguous entries that ARMV8PT_FMT_CONTIG will join at this level */
+static inline unsigned short
+armv8pt_contig_count_lg2(const struct pt_state *pts)
+{
+	unsigned int granule_lg2sz = armv8pt_granule_lg2sz(pts);
+
+	if (granule_lg2sz == SZLG2_4K)
+		return ilog2(16); /* 64KB, 32MB */
+	else if (granule_lg2sz == SZLG2_16K && pts->level == ARML2)
+		return ilog2(32); /* 1GB */
+	else if (granule_lg2sz == SZLG2_16K && pts->level == ARML3)
+		return ilog2(128); /* 2M */
+	else if (granule_lg2sz == SZLG2_64K)
+		return ilog2(32); /* 2M, 16G */
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 armv8pt_contig_count_lg2
+
+static inline unsigned int
+armv8pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (pts->entry & ARMV8PT_FMT_CONTIG)
+		return armv8pt_contig_count_lg2(pts);
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 armv8pt_entry_num_contig_lg2
+
+static inline pt_vaddr_t armv8pt_full_va_prefix(const struct pt_common *common)
+{
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return PT_VADDR_MAX;
+	return 0;
+}
+#define pt_full_va_prefix armv8pt_full_va_prefix
+
+static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
+{
+	/* It is not allowed to call pt_num_items_lg2() at the top level */
+	PT_WARN_ON(pts->level == pts->range->top_level);
+	return armv8pt_granule_lg2sz(pts) - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 armv8pt_num_items_lg2
+
+static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(*tablep);
+	if (!(entry & ARMV8PT_FMT_VALID))
+		return PT_ENTRY_EMPTY;
+	/* R_RWMFF/Table D8-48: ARM level 3 has only Page descriptors */
+	if (pts->level != ARML3 && (entry & ARMV8PT_FMT_TABLE))
+		return PT_ENTRY_TABLE;
+
+	/*
+	 * Suppress returning OA for levels that cannot have a page to remove
+	 * code.
+	 */
+	if (!armv8pt_can_have_leaf(pts))
+		return PT_ENTRY_EMPTY;
+
+	/* Must be a block or page, don't check the page bit on level 0 */
+	return PT_ENTRY_OA;
+}
+#define pt_load_entry_raw armv8pt_load_entry_raw
+
+static inline void
+armv8pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(49, armv8pt_granule_lg2sz(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, oa >> 50) |
+			attrs->descriptor_bits;
+	else {
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(47, armv8pt_granule_lg2sz(pts))) |
+			attrs->descriptor_bits;
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA, oa >> 48);
+	}
+
+	/*
+	 * R_RWMFF/Table D8-48: at ARM level 3 the leaf is a Page descriptor
+	 * with bit[1]=1; at other levels it is a Block with bit[1]=0.
+	 */
+	if (pts->level == ARML3)
+		entry |= ARMV8PT_FMT_PAGE;
+
+	if (oasz_lg2 != isz_lg2) {
+		u64 *end;
+
+		entry |= ARMV8PT_FMT_CONTIG;
+		tablep += pts->index;
+		end = tablep + log2_to_int(armv8pt_contig_count_lg2(pts));
+		for (; tablep != end; tablep++) {
+			WRITE_ONCE(*tablep, entry);
+			entry += (u64)1 << isz_lg2;
+		}
+	} else {
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry armv8pt_install_leaf_entry
+
+static inline bool armv8pt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa &
+			 GENMASK_ULL(49, armv8pt_granule_lg2sz(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, table_pa >> 50);
+	else {
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa &
+			 GENMASK_ULL(47, armv8pt_granule_lg2sz(pts)));
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA,
+					    table_pa >> 48);
+	}
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_NS))
+		entry |= ARMV8PT_FMT_NSTABLE;
+
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table armv8pt_install_table
+
+static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_DBM | ARMV8PT_FMT_UXN |
+		   ARMV8PT_FMT_PXN | ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP |
+		   ARMV8PT_FMT_nG | ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		mask |= ARMV8PT_FMT_SH;
+	attrs->descriptor_bits = pts->entry & mask;
+}
+#define pt_attr_from_entry armv8pt_attr_from_entry
+
+static inline void armv8pt_clear_entries(struct pt_state *pts,
+					 unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+
+	if (num_contig_lg2 == 0)
+		WRITE_ONCE(*tablep, 0);
+	else
+		memset64(tablep, 0, log2_to_int(num_contig_lg2));
+}
+#define pt_clear_entries armv8pt_clear_entries
+
+/*
+ * Call fn over all the items in an entry. If the entry is contiguous this
+ * iterates over the entire contiguous entry, including items preceding
+ * pts->va. always_inline avoids an indirect function call.
+ */
+static __always_inline bool armv8pt_reduce_contig(const struct pt_state *pts,
+						  bool (*fn)(u64 *tablep,
+							     u64 entry))
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	if (pts->entry & ARMV8PT_FMT_CONTIG) {
+		unsigned int num_contig_lg2 = armv8pt_contig_count_lg2(pts);
+		u64 *end;
+
+		tablep += log2_set_mod(pts->index, 0, num_contig_lg2);
+		end = tablep + log2_to_int(num_contig_lg2);
+		for (; tablep != end; tablep++)
+			if (fn(tablep, READ_ONCE(*tablep)))
+				return true;
+		return false;
+	}
+	return fn(tablep + pts->index, pts->entry);
+}
+
+static inline bool armv8pt_check_is_dirty_s1(u64 *tablep, u64 entry)
+{
+	return (entry & (ARMV8PT_FMT_DBM |
+			 FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY))) ==
+	       ARMV8PT_FMT_DBM;
+}
+
+static bool armv6pt_clear_dirty_s1(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep,
+		   entry | FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY));
+	return false;
+}
+
+static inline bool armv8pt_check_is_dirty_s2(u64 *tablep, u64 entry)
+{
+	const u64 DIRTY = ARMV8PT_FMT_DBM |
+			  FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return (entry & DIRTY) == DIRTY;
+}
+
+static bool armv6pt_clear_dirty_s2(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep, entry & ~(u64)FIELD_PREP(ARMV8PT_FMT_S2AP,
+						     ARMV8PT_S2AP_WRITE));
+	return false;
+}
+
+static inline bool armv8pt_entry_is_write_dirty(const struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s1);
+	else
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s2);
+}
+#define pt_entry_is_write_dirty armv8pt_entry_is_write_dirty
+
+static inline void armv8pt_entry_make_write_clean(struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s1);
+	else
+		armv8pt_reduce_contig(pts, armv6pt_clear_dirty_s2);
+}
+#define pt_entry_make_write_clean armv8pt_entry_make_write_clean
+
+static inline bool armv8pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry;
+
+	if (!(pts->entry & ARMV8PT_FMT_DBM))
+		return false;
+
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2)) {
+		new &= ~(u64)ARMV8PT_FMT_AP;
+		new |= FIELD_PREP(ARMV8PT_FMT_AP, 0);
+	} else {
+		new &= ~(u64)ARMV8PT_FMT_S2AP;
+		new |= FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+	}
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty armv8pt_entry_make_write_dirty
+
+static inline bool armv8pt_dirty_supported(struct pt_common *common)
+{
+	return pt_feature(common, PT_FEAT_ARMV8_DBM);
+}
+#define pt_dirty_supported armv8pt_dirty_supported
+
+static inline unsigned int armv8pt_max_sw_bit(struct pt_common *common)
+{
+	/*
+	 * Stage 2 bit [55] is the NS field in Realm state (Table D8-53),
+	 * so it cannot be used as a software bit for stage 2.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2))
+		return 2;
+	return 3;
+}
+#define pt_max_sw_bit armv8pt_max_sw_bit
+
+static inline u64 armv8pt_sw_bit(unsigned int bitnr)
+{
+	if (__builtin_constant_p(bitnr) && bitnr > 3)
+		BUILD_BUG();
+
+	/*
+	 * D8.3 Tables D8-50 through D8-53: Bits marked IGNORED in Table
+	 * descriptors and "Reserved for software use" in Block and Page
+	 * descriptors.
+	 *
+	 * Bits [58:56] are safe for all descriptor types at both stage 1
+	 * and stage 2.  Bit [55] is additionally available at stage 1
+	 * (Table D8-52).
+	 */
+	switch (bitnr) {
+	case 0 ... 2:
+		return BIT_ULL(56 + bitnr);
+	case 3:
+		return BIT_ULL(55);
+	default:
+		PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit armv8pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_armv8
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->armpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, armpt.common)->iommu;
+}
+
+static inline int armv8pt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	bool is_s1 = !pt_feature(common, PT_FEAT_ARMV8_S2);
+	u64 pte = 0;
+
+	if (is_s1) {
+		u64 ap = 0;
+
+		if (!(iommu_prot & IOMMU_WRITE) && (iommu_prot & IOMMU_READ))
+			ap |= ARMV8PT_AP_RDONLY;
+		if (!(iommu_prot & IOMMU_PRIV))
+			ap |= ARMV8PT_AP_UNPRIV;
+		pte = ARMV8PT_FMT_nG | FIELD_PREP(ARMV8PT_FMT_AP, ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_DEV);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_CACHE);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_NC);
+	} else {
+		u64 s2ap = 0;
+
+		if (iommu_prot & IOMMU_READ)
+			s2ap |= ARMV8PT_S2AP_READ;
+		if (iommu_prot & IOMMU_WRITE)
+			s2ap |= ARMV8PT_S2AP_WRITE;
+		pte = FIELD_PREP(ARMV8PT_FMT_S2AP, s2ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_DEV);
+		else if ((iommu_prot & IOMMU_CACHE) &&
+			 pt_feature(common, PT_FEAT_ARMV8_S2FWB))
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_FWB_WB);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_OIWB);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_NC);
+	}
+
+	/*
+	 * For DBM the writable entry starts out dirty to avoid the HW doing
+	 * memory accesses to dirty it. We can just leave the DBM bit
+	 * permanently set with no cost.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_DBM) && (iommu_prot & IOMMU_WRITE))
+		pte |= ARMV8PT_FMT_DBM;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pt_feature(common, PT_FEAT_ARMV8_LPA2)) {
+		if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_IS);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_OS);
+	}
+
+	if (iommu_prot & IOMMU_NOEXEC) {
+		/*
+		 * Assume S2 AArch32 does not have FEAT_XNX. Execute permissions
+		 * are very rarely used by the iommu and it doesn't really have
+		 * ELs to make use of PXN.
+		 */
+		pte |= ARMV8PT_FMT_PXN;
+		if (!pt_feature(common, PT_FEAT_ARMV8_AARCH32) || is_s1)
+			pte |= ARMV8PT_FMT_UXN;
+	}
+
+	if (pt_feature(common, PT_FEAT_ARMV8_NS))
+		pte |= ARMV8PT_FMT_NS;
+
+	pte |= ARMV8PT_FMT_AF;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot armv8pt_iommu_set_prot
+
+static inline unsigned int armv8pt_max_top_level(unsigned int granule_lg2sz,
+						 unsigned int features)
+{
+	if (granule_lg2sz == SZLG2_64K)
+		return ARML1;
+	if (granule_lg2sz == SZLG2_4K && (features & BIT(PT_FEAT_ARMV8_LPA2)))
+		return ARMLn1;
+	return ARML0;
+}
+
+/*
+ * Validate the S2 initial lookup level against D8.2.
+ *
+ *   Table D8-8: "Effective minimum value of T0SZ" (R_DTLMN)
+ *   Table D8-9: "Implications of the effective minimum T0SZ value
+ *                on the initial stage 2 lookup level" (R_TDJSG)
+ *
+ * ARM initial lookup level = 3 - top_level. Table D8-9 constrains the
+ * shallowest allowed initial lookup level per PA size and granule:
+ *
+ *   4K:  ARM level 0 (top_level 3) requires PA >= 44
+ *   16K: ARM level 1 (top_level 2) requires PA >= 42
+ *   64K: ARM level 1 (top_level 2) requires PA >= 44
+ *
+ * The valid level set grows monotonically with PA size, so checking
+ * against IAS (vasz_lg2 <= PA size) is conservative.
+ *
+ * R_SRKBC: 4K granule at ARM level 3 (single entry level) requires
+ * FEAT_TTST.
+ */
+static inline void armv8pt_s2_validate_level(unsigned int top_level,
+					     unsigned int granule_lg2sz,
+					     unsigned int vasz_lg2, bool lpa2)
+{
+	unsigned int max_top_level;
+
+	switch (granule_lg2sz) {
+	case SZLG2_4K:
+		if (lpa2)
+			max_top_level =
+				vasz_lg2 >= 52 ?
+					ARMLn1 :
+					(vasz_lg2 >= 44 ? ARML0 : ARML1);
+		else
+			max_top_level = vasz_lg2 >= 44 ? ARML0 : ARML1;
+		break;
+	case SZLG2_16K: /* ARM level 1 requires PA >= 42 */
+		max_top_level = vasz_lg2 >= 42 ? ARML1 : ARML2;
+		break;
+	case SZLG2_64K: /* ARM level 1 requires PA >= 44 */
+		max_top_level = vasz_lg2 >= 44 ? ARML1 : ARML2;
+		break;
+	default:
+		return;
+	}
+
+	PT_WARN_ON(top_level > max_top_level);
+}
+
+static inline int armv8pt_oasz_to_ps(unsigned int oasz_lg2)
+{
+	/* Stream Table Entry: S2PS section, Context Descriptor: IPS section */
+	switch (oasz_lg2) {
+	case 32:
+		return 0;
+	case 36:
+		return 1;
+	case 40:
+		return 2;
+	case 42:
+		return 3;
+	case 44:
+		return 4;
+	case 48:
+		return 5;
+	case 52:
+		return 6;
+	default:
+		return -1;
+	}
+}
+
+static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
+					 const struct pt_iommu_armv8_cfg *cfg)
+{
+	struct pt_armv8 *armv8pt = &iommu_table->armpt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+	unsigned int oasz_lg2 = cfg->common.hw_max_oasz_lg2;
+	unsigned int granule_lg2sz = cfg->granule_lg2sz;
+	unsigned int max_top_level;
+	unsigned int levels;
+
+	if (granule_lg2sz != SZLG2_4K && granule_lg2sz != SZLG2_16K &&
+	    granule_lg2sz != SZLG2_64K)
+		return -EOPNOTSUPP;
+
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_AARCH32)) {
+		/*
+		 * VMSAv8-32 Long-descriptor format (G5.5):
+		 * Uses the same 64-bit LPAE descriptors as AArch64 but with
+		 * tighter constraints on address ranges and granule size.
+		 * FEAT_BTI (Guard Page) is not supported either.
+		 */
+
+		if (granule_lg2sz != SZLG2_4K)
+			return -EOPNOTSUPP;
+
+		if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2)) {
+			if (vasz_lg2 > 40)
+				return -EOPNOTSUPP;
+		} else {
+			if (vasz_lg2 > 32)
+				return -EOPNOTSUPP;
+		}
+
+		if (oasz_lg2 > 40)
+			return -EOPNOTSUPP;
+
+		if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA) ||
+		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2FWB) ||
+		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
+		    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_DBM))
+			return -EOPNOTSUPP;
+	}
+
+	armv8pt->granule_lg2sz = granule_lg2sz;
+	max_top_level =
+		armv8pt_max_top_level(granule_lg2sz, armv8pt->common.features);
+
+	/* The NS quirk doesn't apply at stage 2 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_NS) &&
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
+		return -EOPNOTSUPP;
+
+	/* LPA2 (DS=1) is only valid for 4K and 16K granules */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) &&
+	    granule_lg2sz == SZLG2_64K)
+		return -EOPNOTSUPP;
+
+	/* LPA is only valid for the 64K granule */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA) &&
+	    granule_lg2sz != SZLG2_64K)
+		return -EOPNOTSUPP;
+
+	/* LVA is only valid for 64K granule Stage 1 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) &&
+	    (granule_lg2sz != SZLG2_64K ||
+	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2)))
+		return -EOPNOTSUPP;
+
+	if (vasz_lg2 <= granule_lg2sz)
+		return -EINVAL;
+
+	/* R_QQQSJ: Limit the OA to what the format supports */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA))
+		armv8pt->common.max_oasz_lg2 = min(52, oasz_lg2);
+	else
+		armv8pt->common.max_oasz_lg2 = min(48, oasz_lg2);
+
+	if (armv8pt_oasz_to_ps(armv8pt->common.max_oasz_lg2) < 0)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(armv8pt->common.max_oasz_lg2 > PT_MAX_OUTPUT_ADDRESS_LG2))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Limit the VA/IPA to what the format supports:
+	 *  - LPA2: 52-bit VA for 4K/16K (S1 and S2)
+	 *  - LVA:  52-bit VA for 64K S1
+	 *  - LPA:  52-bit IPA for 64K S2
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
+	    (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA)))
+		armv8pt->common.max_vasz_lg2 = min(52, vasz_lg2);
+	else
+		armv8pt->common.max_vasz_lg2 = min(48, vasz_lg2);
+	vasz_lg2 = armv8pt->common.max_vasz_lg2;
+
+	levels = DIV_ROUND_UP(vasz_lg2 - granule_lg2sz,
+			      granule_lg2sz - ilog2(sizeof(u64)));
+	if (levels > max_top_level + 1)
+		return -EINVAL;
+
+	/*
+	 * R_SRKBC: For the 4KB granule, an initial lookup level of 3 is
+	 * only supported if FEAT_TTST is implemented. See Table D8-9 and
+	 * Table D8-24. FEAT_TTST is not supported.
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	    granule_lg2sz == SZLG2_4K && levels == 1)
+		return -EINVAL;
+
+	/*
+	 * D8.2.2: Always use the S2 concatenated tables feature (I_TDMHR)
+	 * to fold a top level of up to 16 tables into the next lower
+	 * level. Since FEAT_TTST is not supported single level cannot be
+	 * selected here either. Notice that there are a number of cases
+	 * in the spec that require concatenated tables (eg R_DXBSH),
+	 * since this always uses them it is OK. See commit 4dcac8407fe1
+	 * ("iommu/io-pgtable-arm: Fix stage-2 concatenation with 16K")
+	 */
+	if (!pt_feature(&armv8pt->common, PT_FEAT_DYNAMIC_TOP) &&
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) && levels > 1) {
+		unsigned int topsz_lg2 =
+			vasz_lg2 -
+			(granule_lg2sz +
+			 (granule_lg2sz - ilog2(sizeof(u64))) * (levels - 1));
+		if (topsz_lg2 <= ilog2(16))
+			levels--;
+	}
+
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
+		armv8pt_s2_validate_level(levels - 1, granule_lg2sz, vasz_lg2,
+					  pt_feature(&armv8pt->common,
+						     PT_FEAT_ARMV8_LPA2));
+	pt_top_set_level(&armv8pt->common, levels - 1);
+	return 0;
+}
+#define pt_iommu_fmt_init armv8pt_iommu_fmt_init
+
+static inline void
+armv8pt_iommu_fmt_hw_info(struct pt_iommu_armv8 *table,
+			  const struct pt_range *top_range,
+			  struct pt_iommu_armv8_hw_info *info)
+{
+	struct pt_common *common = &table->armpt.common;
+	unsigned int granule_lg2sz = table->armpt.granule_lg2sz;
+
+	info->aa64 = pt_feature(common, PT_FEAT_ARMV8_AARCH32);
+#ifdef __BIG_ENDIAN
+	info->endi = 1;
+#else
+	info->endi = 0;
+#endif
+
+	info->ttb = virt_to_phys(top_range->top_table);
+	WARN_ON(info->ttb & ~PT_TOP_PHYS_MASK);
+
+	/* D24.2.210 T0SZ: The region size is 2^(64-T0SZ) bytes. */
+	info->tsz = 64 - common->max_vasz_lg2;
+
+	/*
+	 * Context Descriptor TG0/TG1 use different encodings
+	 * Stream Table Entry S2TG is the same as TG0
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+		switch (granule_lg2sz) {
+		case SZLG2_4K:
+			info->tg = 2;
+			break;
+		case SZLG2_16K:
+			info->tg = 1;
+			break;
+		case SZLG2_64K:
+			info->tg = 3;
+			break;
+		}
+	} else {
+		switch (granule_lg2sz) {
+		case SZLG2_4K:
+			info->tg = 0;
+			break;
+		case SZLG2_16K:
+			info->tg = 2;
+			break;
+		case SZLG2_64K:
+			info->tg = 1;
+			break;
+		}
+	}
+
+	info->ps = armv8pt_oasz_to_ps(common->max_oasz_lg2);
+	info->ds = pt_feature(common, PT_FEAT_ARMV8_LPA2);
+
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		info->sh = ARMV8PT_SH_OS;
+		info->irgn = ARMV8PT_RGN_NC;
+		info->orgn = ARMV8PT_RGN_NC;
+	} else {
+		info->sh = ARMV8PT_SH_IS;
+		info->irgn = ARMV8PT_RGN_WBWA;
+		info->orgn = ARMV8PT_RGN_WBWA;
+	}
+
+	if (pt_feature(common, PT_FEAT_ARMV8_S2)) {
+		/*
+		 * STE S2SL0/S2SL2: Starting level in VTCR_EL2.SL0/SL2
+		 * encoding. Table from D24.2.210 SL0:
+		 *
+		 * 4K:  top_level  ARMLx    S2SL0  S2SL2
+		 *      1          ARML2    0      0
+		 *      2          ARML1    1      0
+		 *      3          ARML0    2      0
+		 *      4          ARMLn1   0      1      (FEAT_LPA2)
+		 *
+		 * 16K/64K:
+		 *      0          ARML3    0
+		 *      1          ARML2    1
+		 *      2          ARML1    2
+		 */
+		info->s2.sl2 = 0;
+		if (granule_lg2sz == SZLG2_4K) {
+			if (top_range->top_level == ARMLn1) {
+				info->s2.sl0 = 0;
+				info->s2.sl2 = 1;
+			} else {
+				info->s2.sl0 = top_range->top_level - 1;
+			}
+		} else {
+			info->s2.sl0 = top_range->top_level;
+		}
+	} else {
+		info->s1.tbix = 0;
+		if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+			info->s1.epd0 = 1;
+			info->s1.epd1 = 0;
+		} else {
+			info->s1.epd0 = 0;
+			info->s1.epd1 = 1;
+		}
+
+		/*
+		 * MAIR value for S1 page tables. Matches what io-pgtable-arm
+		 * used.
+		 */
+		info->s1.mair =
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_NC * 8),
+				   ARMV8PT_MAIR_ATTR_NC) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_CACHE * 8),
+				   ARMV8PT_MAIR_ATTR_WBRWA) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_DEV * 8),
+				   ARMV8PT_MAIR_ATTR_DEVICE) |
+			FIELD_PREP(
+				ARMV8PT_MAIR_ITEM
+					<< (ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE *
+					    8),
+				ARMV8PT_MAIR_ATTR_INC_OWBRWA);
+	}
+}
+#define pt_iommu_fmt_hw_info armv8pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_armv8_cfg armv8_kunit_fmt_cfgs[] = {
+	/* 4K granule */
+	[0] = { .granule_lg2sz = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[1] = { .granule_lg2sz = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_NS),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .granule_lg2sz = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[3] = { .granule_lg2sz = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 16K granule */
+	[4] = { .granule_lg2sz = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[5] = { .granule_lg2sz = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_NS),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/*
+	 * See R_DXBSH: 16K granule + 48-bit S2 is required to start at level 1
+	 * with 2 concatenated tables.
+	 */
+	[6] = { .granule_lg2sz = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[7] = { .granule_lg2sz = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 64K granule */
+	[8] = { .granule_lg2sz = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[9] = { .granule_lg2sz = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_NS),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[10] = { .granule_lg2sz = 16,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 48,
+		 .common.hw_max_vasz_lg2 = 48 },
+	[11] = { .granule_lg2sz = 16,
+		 .common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		 .common.hw_max_oasz_lg2 = 48,
+		 .common.hw_max_vasz_lg2 = 48 },
+	/* S2 concatenated table configurations at smaller IPA sizes */
+	[12] = { .granule_lg2sz = 12,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 40,
+		 .common.hw_max_vasz_lg2 = 40 },
+	[13] = { .granule_lg2sz = 12,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 42,
+		 .common.hw_max_vasz_lg2 = 42 },
+	[14] = { .granule_lg2sz = 14,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 40,
+		 .common.hw_max_vasz_lg2 = 40 },
+};
+#define kunit_fmt_cfgs armv8_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_ARMV8_TTBR1) | BIT(PT_FEAT_ARMV8_S2) |
+			     BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |
+			     BIT(PT_FEAT_ARMV8_NS) | BIT(PT_FEAT_DYNAMIC_TOP) |
+			     BIT(PT_FEAT_ARMV8_LPA) | BIT(PT_FEAT_ARMV8_LPA2) |
+			     BIT(PT_FEAT_ARMV8_LVA) | BIT(PT_FEAT_ARMV8_AARCH32)
+};
+#endif
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/defs_armv8.h b/drivers/iommu/generic_pt/fmt/defs_armv8.h
new file mode 100644
index 00000000000000..d6c74dc3b574cf
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_armv8.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * VMSAv8-64 translation table in AArch64 mode
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_ARMV8_H
+#define __GENERIC_PT_FMT_DEFS_ARMV8_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct armv8pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs armv8pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8.c b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
new file mode 100644
index 00000000000000..95878105d35e18
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_S2) | \
+	 BIT(PT_FEAT_ARMV8_LVA) |                              \
+	 BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |  \
+	 BIT(PT_FEAT_DETAILED_GATHER))
+#define PT_FORCE_ENABLED_FEATURES BIT(PT_FEAT_DETAILED_GATHER)
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 07ef1c8341a4f8..1af2627f30a2ad 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -162,6 +162,48 @@ enum {
 	PT_FEAT_AMDV1_FORCE_COHERENCE,
 };
 
+struct pt_armv8 {
+	struct pt_common common;
+	unsigned int granule_lg2sz;
+};
+
+enum {
+	/* Use the upper address space instead of lower */
+	PT_FEAT_ARMV8_TTBR1 = PT_FEAT_FMT_START,
+	/*
+	 * Large Physical Address Extension (for 64k):
+	 *  - HW must support a 4TB block descriptor
+	 *  - HW must decode the additional OA in PTE bits[15:12]
+	 */
+	PT_FEAT_ARMV8_LPA,
+	/*
+	 * Large Physical Address 2 Extension (for 4/16k):
+	 *  - HW must support TSZ=12 (52 bit VA)
+	 *  - HW must support a 5 level walk (table level -1), 4k only
+	 *  - HW must support 16 entries in ARM L0, 16k only
+	 *  - HW must support a 512GB block descriptor in 4k
+	 *                       64GB block descriptor in 16k
+	 *  - HW must decode the additional OA in PTE bits[9:8]
+	 *  - HW must support DS=1
+	 */
+	PT_FEAT_ARMV8_LPA2,
+	/*
+	 * Large Virtual Address Extension (for S1 64k):
+	 *  - HW must support S1.TSZ=12 (52 bit VA)
+	 */
+	PT_FEAT_ARMV8_LVA,
+	/* Use the Stage 2 format instead of Stage 1 */
+	PT_FEAT_ARMV8_S2,
+	/* Use Dirty Bit Modifier, necessary for IOMMU dirty tracking */
+	PT_FEAT_ARMV8_DBM,
+	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
+	PT_FEAT_ARMV8_S2FWB,
+	/* Set the NS and NSTable bits in all entries */
+	PT_FEAT_ARMV8_NS,
+	/* Limit to AARCH32 long descriptor format features */
+	PT_FEAT_ARMV8_AARCH32,
+};
+
 struct pt_vtdss {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index dd0edd02a48a24..263b6dda6b283e 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -309,6 +309,79 @@ IOMMU_FORMAT(amdv1, amdpt);
 struct pt_iommu_amdv1_mock_hw_info;
 IOMMU_PROTOTYPES(amdv1_mock);
 
+struct pt_iommu_armv8_cfg {
+	struct pt_iommu_cfg common;
+	unsigned int granule_lg2sz;
+};
+
+struct pt_iommu_armv8_hw_info {
+	/* translation table base: ttb0, ttb1, s2ttb */
+	u64 ttb;
+	/* physical address size: ips, s2ps*/
+	u8 ps;
+	/* input size: t0sz, t1sz, s2t0sz */
+	u8 tsz;
+	/* translation granule: tg1, tg0, s2tg */
+	u8 tg;
+	/* 52-bit OA / LPA2 PTE encoding enable: ds, s2ds */
+	u8 ds;
+	/* endian: endi, s2endi */
+	u8 endi;
+	/* aarch64 mode: aa64, s2aa64 */
+	u8 aa64;
+	/* shareability: sh0, s2sh0 */
+	u8 sh;
+	/* inner cacheability: irgn0, s2ir0 */
+	u8 irgn;
+	/* outer cacheability: orgn0, s2or0 */
+	u8 orgn;
+
+	union {
+		struct {
+			/* top byte ignore */
+			u8 tbix;
+			/* translation table walk disable */
+			u8 epd0;
+			u8 epd1;
+			u32 mair;
+		} s1;
+		struct {
+			/* start level */
+			u8 sl0;
+			u8 sl2;
+		} s2;
+	};
+};
+
+IOMMU_FORMAT(armv8, armpt);
+
+/**
+ * pt_iommu_armv8_choose_granule_lg2sz - Select the best granule size
+ * @hw_granules: Bitmask of hardware supported granule sizes
+ *
+ * Used by IOMMU drivers to automatically select the best granule size from
+ * their HW support. iommu_domain works best when the granule is the same as
+ * PAGE_SIZE, it works well if it is less than PAGE_SIZE and greater is not well
+ * supported.
+ *
+ * Return: 0 if none of the HW values are supportable.
+ */
+static inline unsigned int pt_iommu_armv8_choose_granule_lg2sz(u64 hw_granules)
+{
+	/* pt_iommu_armv8 always supports these */
+	hw_granules &= SZ_4K | SZ_16K | SZ_64K;
+	if (!hw_granules)
+		return 0;
+
+	if (hw_granules & PAGE_SIZE)
+		return PAGE_SHIFT;
+
+	if (hw_granules % PAGE_SIZE)
+		return ilog2(rounddown_pow_of_two(hw_granules % PAGE_SIZE));
+
+	return __ffs(hw_granules);
+}
+
 struct pt_iommu_vtdss_cfg {
 	struct pt_iommu_cfg common;
 	/* 4 is a 57 bit 5 level table */
-- 
2.43.0

