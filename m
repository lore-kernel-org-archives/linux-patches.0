Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95DB33E37A;
	Tue,  4 Nov 2025 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282867; cv=fail; b=drCqq/Tp5NTLIa6F5OSS5byGBlcSjYCNVrw9oxE2/Loo9ERz4kYmnE3nmKTrPy4KuwLIs1BdWnMNC6/LpM8277vkmTA/qzADzBavhisyIKbMh0FmUsmHr4lmN/ubTBPet8QsoZT3sx8d4Xfey+5Jp9+DPeOZHf8gpO/ez/ko/FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282867; c=relaxed/simple;
	bh=dXzILNdlavMZ20yDmmYt+RuB+oUW6TWf/jdb3dwDHFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eys38Ycg3yi5Ymq8i07YB+9lVn0D6P5xkl2dcyLHqufHN7vwrch3ZS752JsQxMuckXZ34twh4brJWPdUOl8X5io4aOoA5h6NXP/I1viHPPK8OKHsVkHzUbu8mOlyjnxmWE9FwYRUlc8tqlW49bFIE0d5iaoEhqagf9FSY67VKu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RpTtIXeO; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RpTtIXeO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+2eKkVOyJBatcjVQfQT0qlrLzJwTWZBp7GbGwiZs7Ys1FB/o6YrsaFR0aYzSKSxWbK4WI2dQkn5uBgzlpwfucIXfns4ZETxnu52+dA/1ITR1PRfHgJojaavhfnBSAnClB1psK2wMc9CB73lwDq011SXefN2CbZhqbB4/wxFqzRCB/IFsw7/+nED64RbFbvruB3dUcO3FMlazAsZCQEE5IjagGYv7j1TZpi4ihGkfd498zQLJbf0ivqPA2x7w7qyYG6SE7xKK/JKlmLVJtTPRazG+a15ImP06mDge4UZ028RYmrYJVHvLYdl5ROhdo7Ntue4BWma+HNORwMddGiYeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDEY99nmxn7FcVyQkXLbfdV80dcmmDbAcYoORfkbq+Y=;
 b=Kdc/fCQ2UMX9uLKznoQQPRcrPnRMZC4oxPEcU/KNQAk3b8eJqoRnPhSR/oNstu0b0VfoVFHQ8NZ9er5vPCjApVbrwnQndoF0S9j4TdbBCud+jU3E+reRmPVT/xnjfX3JRgvhl4cHA9KCOd5PeylNXo2TpOuXSqe6Kkzn9Y1nEq5mKVyujx/TlUano9ZHpKwetZUJNsU5Wn/wRSyH2m5ObjYHJ0xT7Itc4stxBc1hEMfwxmwJd83vR1UMt2TxRxaO1gjkSDwgdUGTkJ+YPHNlYC24PcwGZQ+OOIUIhtdkIfH1bp0mPslWM76myQonx21nrYYvulhVZbVdJ3d+xa7hUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDEY99nmxn7FcVyQkXLbfdV80dcmmDbAcYoORfkbq+Y=;
 b=RpTtIXeOFAY7+K91VmadOlPDdPpr0L1xt2R9rFPMt3+9dCRQEInlR1RhK5BS8/3OsBkbYiLMN/xJIUlPQsNMU53ApSl5Y35VbSf2+w/dqWnLDIaaC2sum3emaoOqozbQwD0zRZYEyLL7y8U56Yst1uY9//Go0VO4Eo8CHXMYhirgO1qI47YQWrX5EY7nV8gKPTzR/ecSZg+aeUxydezi71etgQHI1v+3cDi6lrFOcawTnp4f8YMNyhpIkgK3tTOvjw6KtwOTKzBUmUPadiOJZS1gkGHJd1VKOPAm1Ch17lv/aU52rncMWHDnBNqcLQLSndbtwLZ+om1uC0P/D8CHfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Tue, 4 Nov
 2025 19:00:47 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 19:00:47 +0000
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
Subject: [PATCH 1/5] iommupt: Add the RISC-V page table format
Date: Tue,  4 Nov 2025 15:00:40 -0400
Message-ID: <1-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:408:e7::16) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e511afe-758f-4e00-d1f0-08de1bd475b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ojVLyZVGfEH58ir5VQCnu4dm8cBqDaSuZoi8VdVwl8dUIL/hYAG4c6m2PlDO?=
 =?us-ascii?Q?wgLNZsLae9nl22jjjLSjgI5zb+goKah7MN58fxZ5ASV+8TF2h7CXaL7gnxC3?=
 =?us-ascii?Q?gbuwoptRyqvnvSdDtpaQEKof5K2oouj+Lgqt9K5C3iTmN85ofaunzVOqK3k2?=
 =?us-ascii?Q?NL98YyoLKELBUn0bAdkdbRu4kXa2Vnc4nVrFfbvN7HzUlVguc/C7DBHFvdlp?=
 =?us-ascii?Q?nR5psJ+iG+UjWWwub32tzzlom2rdpDGG4gGzo40YSsCyXe1eNwKmesQkokQK?=
 =?us-ascii?Q?5gYLrppv6FWgqk+LVPdAxBDZE+GRB30Yt6wBxUuo0fsMZ1vYwVy4nrEON15t?=
 =?us-ascii?Q?dLdRHdR3cHjBCB+cLgKtCU1+dF9SchdU/gKwYr9+Y0bgyovMFwQl/IgmdozC?=
 =?us-ascii?Q?fOorl7kNb873f8Ba22i7K2XZuRKvIxISJDhC1bGXE337nzI6+ArRbJ7OCQpz?=
 =?us-ascii?Q?N0ONqqbi0fCOq6cLJlmu1bT6Quc/8ks20dkN7aP+1sAGEPPIoGIsLffkYY/D?=
 =?us-ascii?Q?JMMjoTGgJnpFFwldf5L7ZuI/c+94ksD4+aIiB6X8hNqYp8COxs9lDSQ7FjUp?=
 =?us-ascii?Q?aucCPff6VrgTmbSZVX3iDcOSqu9JQqULvjgYVmIquZJ8MqHHF95OUdIb5jCW?=
 =?us-ascii?Q?Jgp3eKeuJE3S8fU1SzvoV6gFIAbbhA9RXDbmVn/6+MgTucwlu+psv5YqO3s0?=
 =?us-ascii?Q?s1AeWSHyOWSjN0y5vcQyWMwOCn7nFX7+KoreKOX2QchRb/czOxm1v9OE2Gpf?=
 =?us-ascii?Q?sZA2oAdSSFjxi/zUC5vpZtoGPHhYuXBIKCwEuHfFOUSanI8HwJYT8OR+hFZ0?=
 =?us-ascii?Q?NrH7q+FtFl+Q4+wnmRm3O5CYuSG94M0o+aNxRrYas3jZyhFKlPG94xFFSjq9?=
 =?us-ascii?Q?W/sM6ZsVs2CkSm+WybIfxLJ5GzZwxVqwbuHcxl/uoiWDY6YMUiC3KPYEyG4O?=
 =?us-ascii?Q?HDFJfJyuAMCMM2GdEUh7lMs3a0a96F1c3FvAwHhEPHZWw+PrLzdx9MMb2ECG?=
 =?us-ascii?Q?Qg65BGFlwUZDMAEcOWPk68SnEtFaVvWwZsDvqY1KElK71KbSLnEO/Q78pPvY?=
 =?us-ascii?Q?e6BkVhRC0aIYTvCufjqw6eDOVN6rdV9HGaCFarQKuGYh5cHpHdtdtyG2H8mt?=
 =?us-ascii?Q?d0fkcPwlgYWfLBP236VcezlB4TugfedR3Y4zZmwRxE4QixfgJt/AwkGivdk3?=
 =?us-ascii?Q?MHZjq0iOCbysL1W57aLaBN8SNjTLkpR98FCR9JN8/RqDUh6Oqjo6LC3hyzNJ?=
 =?us-ascii?Q?CNx2UZtciEUJmNyxM4tWAdxX3tac4RfEeK48C0Ogbrk+VbIhMDEv8eNlQFiZ?=
 =?us-ascii?Q?wS7RtEx4XmOFjkOn/7NxEGZi9AdlmBjgeoLRFppyg6K1zxG9o6nHp1BGVy9K?=
 =?us-ascii?Q?msOt3mtIVt0/rIQvSfA6rQyW0pocFgVexqoZxtAz+irD9pRcLfHSXBlBJL7W?=
 =?us-ascii?Q?n59I/TQXGWWRBmI/MVH7HEBuHJfaNf0HmJdJ3/TTRIL1IFAgrrouGOk9Nzep?=
 =?us-ascii?Q?eHAZ6SgQhsy8/+U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MWG9KFD91QCDrcG1g/m/yi4Qc19l7Z1YpmUpBm1Tky/YnrT6K03GLEb+9IOC?=
 =?us-ascii?Q?yHJp8EyaPj/pyJROF572CIhMN1FO54fXk8PYQw3Umdc94NAn7ctWcvmVpurj?=
 =?us-ascii?Q?FLa1OZBlbrlNRiiD+6yrJKIuwEVk7PaPnc2stcT7M4SvG3wZHrJnzb6TOIi1?=
 =?us-ascii?Q?5qkiuI1zc/6wif6852Y9bYuS15RqyUICE4J+UHs/5vK/NoUZzqMYNUVR8tDm?=
 =?us-ascii?Q?+lpj1qj6PuzrWWtGOmVjYO8WtfKCz+bjSts+MQWE178i2ojT/q1lal1iZZ78?=
 =?us-ascii?Q?0/P0cwCftQ7Ez4Jt3sjD+1MRiQI7ttZBty8n9YYpNmT3GDplWUarDTV5FPa6?=
 =?us-ascii?Q?iiREPqFyg58d9zfn07dBvx0B1mX+qjJrVC61oCSR1s5fwIaWXJX7iSGcxFyY?=
 =?us-ascii?Q?tK9NzNUPOfqFMCIKl2mVZtUF/lI3KnD1ohhjY3qSZ7OlvOQ3qYuT5D5jjQLe?=
 =?us-ascii?Q?HXNcggmxOycwnz1cIN7ptuHOyHOlDkwZ2foiTigrcMnkVzX+8UbTHKqXclOK?=
 =?us-ascii?Q?5+YeeYe6X+7KOKSxV6oWN4YnScekfzBxGDR1wisjlt8GO/JJurzMXhsf6Kq3?=
 =?us-ascii?Q?gAZI77MWJt2EgMh9vxxyJHsNQwrdMi/kdZ+6Rfdd3/JyW0m0+NAbXyORilHf?=
 =?us-ascii?Q?X4hXPuEpB6d0EYkxY/YxXMBAWjWVt3SpyA/WZMsrnLyIFUQOb3vx2jAcgDjG?=
 =?us-ascii?Q?qmTYkXuErQCHOxV67wRNC9RDrZ8hXrxRZGqCs/9kBTb2buW1FFGEB1eeVnsH?=
 =?us-ascii?Q?RouSJnoygKVUOqlnCaLrk9IPIMyGTcG0JsQ71fih7hJhU1u2JoESspSW526V?=
 =?us-ascii?Q?eYNRl8V4GsDEQzmQEsN7bO4WOKkZiCvtoa0npcDUs7NH9P3BV+KiypcFPgK6?=
 =?us-ascii?Q?GpJL3P83UVHs/o/jDGakbYAQzEJrmYyTHwES+3ACUzfuv+0qemZsaGEne2OD?=
 =?us-ascii?Q?E+AyghgouSyOn8AiWSfreqF6GQllKfYskKwNMdZeeOX5m9kQCmm8dd/Kfn7Z?=
 =?us-ascii?Q?+VKPOCN8otb0GmLIisapEeENLb+xKkpqouNGDsnIL6L5orP1KItrwtb86Dpr?=
 =?us-ascii?Q?Q7F1v9T+pdh1QCFXkDEUdPUuEtZ6L+142IZ9jykoGqrq5HieCLr0cxaXo4pm?=
 =?us-ascii?Q?31TyMm9i1cpol7/r0pFq7zEhDa1UfMkOpl/mNIsfjgYsF03nm+bgTJIgNw6l?=
 =?us-ascii?Q?/iav1xL+Yay1OMGj1cHmT0BetBlIOhq+SEeuRlYk+SzCYO+xrIPaO40PeDKG?=
 =?us-ascii?Q?jJzMWmnkn4r4PRNr1gyEr7jp/iKLcVKJLlhZea1vRQ/ZSpYK86YGf6E5AzOz?=
 =?us-ascii?Q?hC82ZIOhlSWShRKN2S55lTYG3zwwDiojtuV19/vW9kAKdksTfrv6/HYkzreW?=
 =?us-ascii?Q?bREgI18U02X8SrhGw/MkjZT4t8ScdB2zztSpwHUPLliZxz0DuEuXNCNYiA0K?=
 =?us-ascii?Q?135xovntsl7RtxYjnwcxYJaLwHlhoV2/r7mFu04NCrB4B+AgjgNf5bsKhbiJ?=
 =?us-ascii?Q?5TTMdKw1JHVVqPsm5kuIxSa3XIf58CN9edYwPSjOgvu1oD3+689owdO7Zphv?=
 =?us-ascii?Q?qo1zTjlyjhgRAOHApyk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e511afe-758f-4e00-d1f0-08de1bd475b2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 19:00:45.8649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nKnIaLa6rRmr1fPoX0KWE3pkD9qmrSBDFETHdXSayiw5RnfUi7zcZFxiKg7rO0N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

The RISC-V format is a fairly simple 5 level page table not unlike the x86
one. It has optional support for a single contiguous page size of 64k (16
x 4k).

The specification describes a 32-bit format, the general code can support
it via a #define but the iommu side implementation has been left off until
a user comes.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |  11 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 include/linux/generic_pt/common.h            |  15 +
 include/linux/generic_pt/iommu.h             |  11 +
 8 files changed, 393 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 2016c5e5ac0fe9..5265d884e79cea 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -3,6 +3,7 @@ CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 6dcb771b3c582a..dd12699fcbc9c8 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -42,6 +42,16 @@ config IOMMU_PT_AMDV1
 
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
@@ -56,6 +66,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	default KUNIT_ALL_TESTS
 	help
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 5a3379107999f5..9c0edc4d5396b3 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -3,6 +3,8 @@
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
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
index 00000000000000..a39fc3cca773d2
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
+	 BIT(PT_FEAT_RSICV_SVNAPOT_64K))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/riscv.h b/drivers/iommu/generic_pt/fmt/riscv.h
new file mode 100644
index 00000000000000..1cf9082e2a4131
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
+	if (pts_feature(pts, PT_FEAT_RSICV_SVNAPOT_64K) &&
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
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_RSICV_SVNAPOT_64K) &&
+	    pts->entry & RISCVPT_N) {
+		PT_WARN_ON(!pts_feature(pts, PT_FEAT_RSICV_SVNAPOT_64K));
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
+	if (pts->level == 0 && pts_feature(pts, PT_FEAT_RSICV_SVNAPOT_64K))
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
+	if (pts_feature(pts, PT_FEAT_RSICV_SVNAPOT_64K) && pts->level == 0 &&
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
+	[0] = { .common.features = BIT(PT_FEAT_RSICV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 39 },
+	[1] = { .common.features = 0,
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .common.features = BIT(PT_FEAT_RSICV_SVNAPOT_64K),
+		.common.hw_max_oasz_lg2 = 56,
+		.common.hw_max_vasz_lg2 = 57 },
+};
+#define kunit_fmt_cfgs riscv_64_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_RSICV_SVNAPOT_64K),
+};
+#endif
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 96f8a6a7d60e10..10b8250659b98b 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -151,6 +151,21 @@ enum {
 	PT_FEAT_AMDV1_FORCE_COHERENCE,
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
+	PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
+};
+
 struct pt_x86_64 {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index fde7ccf007c50c..afe6e581f12f96 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -255,6 +255,17 @@ IOMMU_FORMAT(amdv1, amdpt);
 struct pt_iommu_amdv1_mock_hw_info;
 IOMMU_PROTOTYPES(amdv1_mock);
 
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
 };
-- 
2.43.0

