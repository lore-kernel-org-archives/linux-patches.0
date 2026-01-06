Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3040B33E352;
	Tue,  6 Jan 2026 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712041; cv=fail; b=u3RdsU/bD0y2tXK+P8Il53AnqwRcJFHLkfm5V8BLcjTQjdJ4jlpD49Kb7U5mZ/AcmdnRCuzj2qVH7q0zXdhGZ9YV/HnO+ICxT6DSD1vBjX7AVINHYfu/DvMWqyuFtdTylqcy09wyUYyClDIsaDSfAosKywMYJD4vsi7jISlf6U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712041; c=relaxed/simple;
	bh=Y6VD/94lwI3FArh6OsX9Ih+GqklShQJgbbgINYRyGek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uTdf/utW/+j+/wb39QCSwEYC1KLwYfFkbBdlnvATyz74cg9bkxGNuCzy2EapjrC2fyStb3eyNNIQMzYWObWuryasNqtjWmmyIwOj+K++ycNJw5MAG2bP6TK+nzAlztKk1eChmwGLCahM2owKL66GC4O24H7Ucm4bxUU8ZeV26Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OLWv45ue; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OLWv45ue"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDtalcV5dTnfhCxN1D5NcfsuHWOYAD22E/o9lpRQlGu3U1HXNaFeqmuynhdPVlGeQq0awcomlGGQq/Vu9BLaFIywq0+So476lEIWHUEhwmNxmBwXQ8X1FC1aCdl7lyuEXvTkWUQFhX9kfgFhNYSSh2QOrp4ZV6oME2w+B0VS3jtL6B6A31GLmvhOWKNrM2Bt8Uaz4eZAyhQVxz6WOZQnoT0z91o+iH5DNfwjZSM86atQABD50I3U14uid1dtsAZaCHA3thOywFmKfBseLY2otMoE+jrZnKzSriovmxWVvbecGCU1tmjLarLskuelmaCTyy5T7kDCUk8XFvXC/OgxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+IpzLS+TwqxeN9bzwP3K484tSjV5BWz37x6E2rR3SQ=;
 b=xuemZZooFziitIuBNQEbQV6JoJ70wfP1eScdG26sUcAQ+4QcrVc17sPqzyRQG3NlgQm9z2dMM7r34CsUv4SDWxCJs92AU8N/ypFmiTU4GSb97E4cwFHicmhb117uK8Fd26SZ0fH9GcOlHOk4cDGc4UCi/8gd2KCQ94QQk7V8S/RRBVPF+MyjStKmB1hEXKPllsfcDv0Q3PMvqIdN9gkFg2/hzHUS+U8eL2MjJK4pLfMCjXef41wXmi46Y57I+l5MMaN5XbopnjSjJe9tryQQ59t8Xgh4wuKivLITQCi5Voffm/QzU/+Gd9be/84KjyhBMNhVqhVdO2XDmGC5qqtNiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+IpzLS+TwqxeN9bzwP3K484tSjV5BWz37x6E2rR3SQ=;
 b=OLWv45ue0aGsates8gnBwyi+H8mWnu7VToBBavbQEnqMeumv+gF1kY1waISvaVaBpmnbkjvW9I+VQPSAZo0KAId9NJ8JDNqVTN2ez8a/lRLItez/9vNXAD4XqDHpNhjWAMqP0PwggLjsmDSV5bwyWs7K7g1lb4C4zD/1ss9YMXJudwVLTgrwYqIq9rrAl7TTwLpbVh+Bwa4nrlcJvldkA/5n13k78qAicYru/r0fHQFsM+Hn32825EhEtsXjGQefcp5OhfYFkYF1Tyyu881FPptro57KNMT8gBWMk4RMU5w9OVyYDY9Iz/WscBETdZ/KrNip+fgX+F7P7qTVfoCJbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 15:06:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 15:06:58 +0000
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
Subject: [PATCH v2 1/5] iommupt: Add the RISC-V page table format
Date: Tue,  6 Jan 2026 11:06:45 -0400
Message-ID: <1-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac0d3ed-4d05-4808-00b8-08de4d3539b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+glrWi2gJ8pVzDMQK4YJRsozOaGdk95zkbSRr26LMGWOJgvJjfyq0qa1QHk?=
 =?us-ascii?Q?lQ7x6FLCmX3SflzBmm5Wt2XXtrcQypWrzbtJLo0ONi0yeaBv/1z4PUzKZPep?=
 =?us-ascii?Q?hPamXvFaDy+ZyE2UIpfZDtO6zpWnJidRFF0IgUrld3GiAtcqAVqLZtUF3wkN?=
 =?us-ascii?Q?EvRnEtBHONRqhrkOOhlBJxdOQr4xS+18N9G0NEvfTowWdxz966aBaAWAELWj?=
 =?us-ascii?Q?V3MGCcN+nsUXnusiHDUE1KtGeOD71nQIkS5mBiidLN5WAz9/tl+GwgZ26NoW?=
 =?us-ascii?Q?A7vw1tlFrGGV0Fxwmvab5enZcvKkyJlYDayNLWed7Jkcto0e8U4Mc+0o0H3n?=
 =?us-ascii?Q?aqzTEKu95sdA4M/B3Izu8wHXdYi4FrPFaTsTRbzmSN72TsE/GMT4cQ0Vb+nF?=
 =?us-ascii?Q?2ZZn6Bs1+AOsLvRfGloKvKuuAMxjE1toUSwmQXN4LEngsqzYit61WEcFyYss?=
 =?us-ascii?Q?btD4anWW6lmQFv/sL1kJbjehWdxj4Ex+tO3QovxWweIH029UemSMTfjB9X2U?=
 =?us-ascii?Q?rCEictHcfDtQ/EhBYeQhfuBe6ahBcunKwfqmDG4SwqrBiiixp0i0GQXsfaxd?=
 =?us-ascii?Q?KxnBjVWrsfJ4NFNfXf5bi9lTzKPQa5cDpM/uaA0GmtyXr37elNBHUx3H7s0i?=
 =?us-ascii?Q?VJcrrzKb03g7vT7o8aLWJ8WETZrLJ9nstIA3fA+QqCnkZpLOdkKLOn5u4kNZ?=
 =?us-ascii?Q?ozGsQ4XzWqhZBKkZ/h90nftIsiAMhXUZKpGA/MeAPV2ZUvdwyywjqjydNts2?=
 =?us-ascii?Q?4xrLQNwm5wjWn2qjBu5udQiyBLNFAoq/9uMk+T5QsReniUx0w+29lP8wP08c?=
 =?us-ascii?Q?tSaNMsuTfIyEFj20fhtFrF+TKVEbfbN7aPNEkehSfJAYdRQh+4JtAWddoJ47?=
 =?us-ascii?Q?5+uQGy32h+V6Qt+meuM4w9kJrqmW71ExReFJLcmDnkB5rhizw0w7q39bCsPb?=
 =?us-ascii?Q?7uceJCnj1JQJzm26CR123hovUYE7XrF1GKiegVgDcUK2t3hGZCyAH3Z3lXoR?=
 =?us-ascii?Q?9xJmbvRFcpM60T80TJ9VjBZ3lpTpMPkCts8TiZnamF3nYG7S7ADd9cOs829a?=
 =?us-ascii?Q?+S00EacRZlq2pnlGMQFIQVOJiGzHedVmvT/7fO+18BNyfwXI5rE/jsCxmRKU?=
 =?us-ascii?Q?EKiuANGu9H3GQKpSlvhh5//oqin2hsHZrn3kC9QCjrgX3CBqV8urBRgwbbuz?=
 =?us-ascii?Q?ksu+4wyr3SXXohZMZp7PisDrzFatOiEDwTBj2M5ugR47cOMRi5lU78vSt7YK?=
 =?us-ascii?Q?v8JBB4ektyNGfVhJAOJfFQ08DFUwNAC90Mko2Rh3lDXTLdu+AyfMlGwkQC1W?=
 =?us-ascii?Q?Vn2veoLv+SclXc0vAS49BCOTkpJqiQHWkMqDa1oZ1oC/JD22qKFSRpe8t6rR?=
 =?us-ascii?Q?Kn2aI2XkjKxMK3FTkq/7za6yYZB8DJigLDmQE1pVkVoFyBjgvLg11xrvVMDY?=
 =?us-ascii?Q?YYnLFebvoQX3ECLfK09NiV2kLi6wUp118HlM6Bb8a1kN+l1Bc3rvvDzohjQa?=
 =?us-ascii?Q?zajNH8ZMhRK1Ka4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZAA83Z8wSh0ICjVqaOprpP6cT8F9WpYnAY6JnHr/WqKcMc52qjCRFyC5KWB5?=
 =?us-ascii?Q?I7uxGi9ZGp2CGu6vgiwmXWsUSuJZU6A4kiojEhcItB1cXJRH5Ob1r1s4BUQn?=
 =?us-ascii?Q?ygGpfkUbiErDeFvlK/6egKu6rmb20JS+QBNDtC3skLc2MCi76AFkB8lQ1Rv7?=
 =?us-ascii?Q?CamMpdxOSkUywGyq2m9W8wqtVY4dGtWCDTFAj0lX/A1AdyIgF0/lpv7l3yt8?=
 =?us-ascii?Q?TeYJfi/oLgeX2HNtmVn6z2//nMenvX7NxLKHe9CXlI8x/PWehPussOBExCdq?=
 =?us-ascii?Q?9P2meHtFm9Wi9f483TeE8Fb0niE0B9aFzsiTUnbVT8yOCpg8WAUV7ny3arLA?=
 =?us-ascii?Q?ZjIzO/JPl/f/FQFpcfGbflaZV4f0Q7NUleb0mv907VWrwrX50HpxTwwjhgXg?=
 =?us-ascii?Q?A8l4NcLFJbAnWHhd8s/uSHUIoeo+wKBmW29SLhcpks8MOY6Ahq2OKYx02aWz?=
 =?us-ascii?Q?rOqsMV3RES75aSIz+jVSHnGbGd13izu1q6GtBNG7R6M+vUvzTdd4DUqSnfSQ?=
 =?us-ascii?Q?/KuqCOKi8ADEkn0H26rwRXM4j2c4FOy4vt90uTltvTzP6Q+OhbAhbSO+2j+c?=
 =?us-ascii?Q?624Cm8oQ1OrSZTv8jDarkWaNc1f8XWvhgrixWZEA/T4Kb6YoPGd0aRABjVeR?=
 =?us-ascii?Q?7YiyxJ9QkxIcM5YyFDOzzFU3+2hCrj0EmLS98NP6D6SrmeaqiFx0kJjSf9WF?=
 =?us-ascii?Q?lGBkt1TwprT/6e75hHY9j7cfgek75rSvEDoSVvb1VoLGbAwrX+lm3p9rTdB3?=
 =?us-ascii?Q?N3bKoevx+tIFfRIMJCHyNf67Pa1bWvNHxcLJ2RZsroX8Xv4kXNS50Q9+sJn9?=
 =?us-ascii?Q?rkyf1ZsGtHTHPuYi5RKNpRYHaIkupfvmc/FD/bB/lwSUCkGF3rsRxVUJi8C4?=
 =?us-ascii?Q?o9k8POXkQlSib6gFbPnqSicj4f0KeYN1KYAkmedhqPJpv91qEt2lCZflLMcL?=
 =?us-ascii?Q?9RpFzVFxAzQxsQ1rgARc9obpf3Dh0u4vDG3KPM90QY64BnErH44re1YP21xm?=
 =?us-ascii?Q?MkyAg1vB+M0pPCOhaIaf7YD8f4iPu7XJr1KpefYO9rVv5JRrrNjsNaeR/7mO?=
 =?us-ascii?Q?AraQAlNe2OCZ5g+CgVG/ANzwrIE0TvUMzJSe7+Fp2Rx2UxpYW2RmipY8i4wp?=
 =?us-ascii?Q?xQ0tlKPe9pNzUcPDK6Vy8LxDodUexD0EHq0Y1dBBwzgmz0p44VZbG0UoJSYc?=
 =?us-ascii?Q?Y3QaFThwiSrb14sekiJrWUvwZsuyF+aJ5XqvIf1KW+xAeOWTQgSepUNr8KML?=
 =?us-ascii?Q?lswmFvN3D1zUNOVa3M4EEbC15aLiHGUj187ZmGc+jmi3o/oC1a142fLszWz7?=
 =?us-ascii?Q?mggddvTfK6u1oj0N7J4Yj/3Ax7s5sqQPH6QJdR6yNKtV+GIrYCJaxV61hpTI?=
 =?us-ascii?Q?BDSZYRWMZVAIt3GyBeUpxhtqpnOw6jnzckEGCucZNDv1cQciKRA4+2qZD4FS?=
 =?us-ascii?Q?tIgcYm3qpeuVVcrAUBaceJaYozUgAimoc81quBul5dVum8A+Y3B34HHBtkEB?=
 =?us-ascii?Q?4CcQ0qpa0KH9fNTbbOl83yON4NDpGbKVnRuHtQvVJuZ+iJ/4ziHZBnZ53yJS?=
 =?us-ascii?Q?ZYkPIplwRE4AQ86IXAiRskElRCCn+8sLsCEg2k39hRap69zFo+Rms9BquTBZ?=
 =?us-ascii?Q?1jc2v5rb7R5gMW+9URsH7+hwKM60XXmahWpaAY9fIIdFF8WPg7U1UAmcPmQq?=
 =?us-ascii?Q?L6qlMSCQHZRSvbEDSm1+Gvc94QLo9m0zAd9VV2wBxz7gmER4pvL7YXTny63A?=
 =?us-ascii?Q?G9AjAdCxBQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac0d3ed-4d05-4808-00b8-08de4d3539b8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:06:53.9276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvaLT9SJcwKag6WWRhn3QITJqOO/Hvd3a73crUDlTXFLjkRVfnCcRzxAXrDXBV3k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

The RISC-V format is a fairly simple 5 level page table not unlike the x86
one. It has optional support for a single contiguous page size of 64k (16
x 4k).

The specification describes a 32-bit format, the general code can support
it via a #define but the iommu side implementation has been left off until
a user comes.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig        |   1 +
 drivers/iommu/generic_pt/Kconfig             |   9 +
 drivers/iommu/generic_pt/fmt/Makefile        |   2 +
 drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
 drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
 include/linux/generic_pt/common.h            |  16 +
 include/linux/generic_pt/iommu.h             |  11 +
 8 files changed, 392 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 52ac9e661ffd2b..db0a5b2b3c7867 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
 CONFIG_IOMMU_PT_VTDSS=y
+CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index ce4fb478691457..df0fef423584d5 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -50,6 +50,14 @@ config IOMMU_PT_VTDSS
 	  level Second Stage page table. It is similar to the X86_64 format with
 	  4K/2M/1G page sizes.
 
+config IOMMU_PT_RISCV64
+       tristate "IOMMU page table for RISC-V 64 bit Sv57/Sv48/Sv39"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for RISC-V 64 bit 3/4/5 level page table.
+	  It supports 4K/2M/1G/512G/256T page sizes and can decode a sign
+	  extended portion of the 64 bit IOVA space.
+
 	  Selected automatically by an IOMMU driver that uses this format.
 
 config IOMMU_PT_X86_64
@@ -66,6 +74,7 @@ config IOMMU_PT_KUNIT_TEST
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

