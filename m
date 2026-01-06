Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6899133D6F8;
	Tue,  6 Jan 2026 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712026; cv=fail; b=lqjNAj9nXlFYETF2xQAEwuPsdDphFOcwUQZZ3HmLIxNcwF8qX0D93+hoHoquyni/BW3ZTZ6NTv7o4sxeCtNl8XdBZNu0x0GyVqQLRBZAxh7wwgRki1WThe8D5XR6D9IOXkMnxrSgas5XXqmJJuRlnl4rkotK2CmHuKHN2yynCsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712026; c=relaxed/simple;
	bh=ua21OqvInHc7IwdggOL1KnwU1Rxgc+Y6lx3lwi+PlG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UUJwUMaVtJcLOhfRH2Lg477fxf04lxtZPjOIaWC16OrYFOUI2O/3ZxWlwwlAfwe6DhEvq/VV7lCCTEm/UOQ9lJlkhOglrQAwI3BPDb8GL89FpSttxGKNw4T0HK1KxofZI87/ovsNM66RQlCuJU39/3I/x1UbkBSycoyJSYdL704=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jtW39JvL; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jtW39JvL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WAHdc/68oeT4/kx7uuJYalWSMrL9kNZzKRfrejhyHLVPxsNurB5JKz4sY2UDnc9qLqWzlylCvbnEV6VSNAuiLMfg9AaEKWxVbK1ykSZIgNXp210WRONjI516867bEfCtxCwaIWpe2+As+Hg8eH25YDGSSd4hCPsehc9+SAYQ6VCMSEXFj9JVr1XZDauKOJX9kyYoScVOszYX5U07oPvZsO0o4BfZuLm3PCqV+s8SYL5ZdKtjPDLJleOGik3Eweqej2rrbJnxe7nUcCf5H6Psoj3kZPXxfro/xkx7PES+janJMGZzKTbvYnLpby54ReqVAWKXXPahkw37bNs9lg+fFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3waL8PbXtJwYP8cCrJFjLGcaszM9J67P9OQdgJfGxg=;
 b=xOQVSsGEQtWxYjOsHU7H8xB5zGKi6QH1kTv1XgJdPYzm/yOMtV/o/qIVuik1xZd885LLAF1o7soThjzeJBARfGGlUJUiZUeu2VJjn/JOWJ+NeKuLBmLqTEIWyIjIZFulz+dZjtFHQ6xoNZhZ6BzGLJXU4oF2IQykAyFS7SkkU2v5wFLc37lYuAvgpnv1AwMwW2MJzxxFHMbSyrUE9ehxKtcnUCRb2uIhgjZuwkv7Ea5pcODNwbIBrbXjspDMU4PVwQ14KC2hIBGJr7FyEdxHGkvHjilzk3ckkVNkuOHB93hKoW/jwn1S2NFP0rkrYcPwRSjECIc2drSOX7DY94sVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3waL8PbXtJwYP8cCrJFjLGcaszM9J67P9OQdgJfGxg=;
 b=jtW39JvLBfyMc6njhl2Kfmns/qsmZDiZgfncVXOrKV2l2kP6qk0TfdMCZO4hkkPR4j+0Y/F7IZSfXyJomGXeKa81rLerWiWOvajAPUf1lVoex9jQ0UNrgfFE9vqPX+U0E3SJTsH7nE+6r6c9fdPaspka9vcGHK5gwmqtiHWOFjJxToCAjnhOI7eGdwRWXsmLtnB35pDu3c3hCj6NtsLCyScc8jU3OvKXnzBRnqdMGpY530yX2QeowrRvpPET+z+9ZsnXXXiXWnaRwHsP8M8uzLjU7caRi2gFRVgEGHqbg7VcIcM0DWAAAsKOpvC4F/zc7gEmUTaDvsHhQuNk4u8wmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 15:06:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 15:06:53 +0000
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
Subject: [PATCH v2 5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
Date: Tue,  6 Jan 2026 11:06:49 -0400
Message-ID: <5-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:208:329::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: a3485558-632f-403c-94a3-08de4d35386a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V4oTk3ElCQgY9oShPpkY9UwISn/90YT/z+dGpFHVHM4EIDbLo0Ln/FDObfD1?=
 =?us-ascii?Q?HyIuAq3nOUV0THAa+xH9BpCjYWiWSbQLTM+88cMCF5khwJT3kiarA2SLXTyS?=
 =?us-ascii?Q?VjeR9l985Wdl+EWaTYkZowa60JjurWykrPRp669agRVrQb0Exvcq9iXhGnKw?=
 =?us-ascii?Q?FmlhjfVq+a4yjpDNEtxUme6wF0WZ4UunZ/vDHFHIF8eeewUsDLY5d3T4hlEz?=
 =?us-ascii?Q?/48w90EtOl+4CGxyOJD1YPwe1YrUOQIXsDo2RHxYAEyNIe74NQC2kiWZX/6S?=
 =?us-ascii?Q?IK9n0BBlVbMrKFgI4k9xEn31k0diwU5JBV/SpbnYxLJqC0zgNhBOwIrpb5hr?=
 =?us-ascii?Q?H9ZIjJtecFqUjc2jW2YvWxz3Pbmmz7NCcIK7G+4oLj/ucb3ZBmR3tN9q4jvq?=
 =?us-ascii?Q?cRjGXF91AaGTpFJe1PlsVKtrwADk1rNFsxBDEjp4HNFvt7lndwodNVMdfkI4?=
 =?us-ascii?Q?1oFEWgry9o3wcZ9ygkbJjpyqrXqRAeTqy0oShU7yao8LFVKIsFWFj/SOQA5F?=
 =?us-ascii?Q?pJFaOSeZDvQuwJRzQi6HitptQy3JGOeD1Rswv/kmRL4dGPZtuceiwpMjSck/?=
 =?us-ascii?Q?43eqRjX9dXXOcI1N56Q/kOwxlLk5vPHsRHU7OhxIKccoqVCuT06sxdv5tI0R?=
 =?us-ascii?Q?aYeHvIBqwAHIbI/2XCwxwR6v6fxPE/xvRIahojwIFMkWjrMc3dzlZpyquo/9?=
 =?us-ascii?Q?Tr9xe7Cn38tfVj2yC8xfCMNAKeBam06A+f5cBKJWtr2cGjv4NluHqTHiV1eW?=
 =?us-ascii?Q?WoaH2uFgTWw2suU/tFOiCWsBoBKmNDD78i8uCpZDAJzu3T8JbRk6LexmiHs0?=
 =?us-ascii?Q?/sVKZ5mI6+1Si58KVSNSfdnQd9Z3X1MzdSpms9u0DTtfltI6IGhSeONcuDLJ?=
 =?us-ascii?Q?y7mmOy9SJuM7llwtVLHKqZcMFexuiMm3TYPeOdXZF7Qe7ycgbiFxItA2oEYR?=
 =?us-ascii?Q?AHGxetj3bDX/WqbYPFhRlUX0bZ1bHoSJZZgCjSCR7H6hviA4Lzo0reTh0OVl?=
 =?us-ascii?Q?yA7l3Q0xJEi9+wvCRqz9zbnY4pft2AC4qDqPnTusF83clmXENQtJBOA77M/H?=
 =?us-ascii?Q?NAa0uDkCtXoVtywJsij1jN0/aJ6xb93kYlVOSxi8RcI9gY9PG5cQWhsgF2kt?=
 =?us-ascii?Q?kwfnRTssBC4QHFYnTGVFN+WoMysh1Dgv88gwPk/c+MrO8XdV4avrjsz0sOan?=
 =?us-ascii?Q?mjmZxdh53uL5a5fkvArs+j8MY3eOnHRVPcidsk51hKXsitn5Ay3o9Sjft7z6?=
 =?us-ascii?Q?gXxgEzKvbb1pWVOl8fOezJTisS5ZE+2TUZY9ZnBemidjSLHG/F5gcfkXy0A6?=
 =?us-ascii?Q?q7Ltn6JdKaW5xZYfZGA5EeatNCcNZoTRAE62dAIv3iPfuiTjfuEEVsnaKUpV?=
 =?us-ascii?Q?VadnXxqON+ORklSVytPytSVB6yumJ2E6vEz+lWf/USDAS1Ynw82a7p/8wBKH?=
 =?us-ascii?Q?tt+kzqHGb3kVfH1oSvQpt9L4vvbsdP/jP2bJMqRcck8p4/mypLFPbQCTVtke?=
 =?us-ascii?Q?3yEOMN0bMxi2jMo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TJ2yp/6i3bRnhxcvbT/wxax58jgCTB12P4gr2ExaYGCPvJJYBz8BflQfddG9?=
 =?us-ascii?Q?/6w4tlozhci2yaCw4T5CanuclCqC0tOjm3aKftb/lLCnooj9yaGqE5cfrjFO?=
 =?us-ascii?Q?oN4CAq4lMElT/1XvNpPXfp7LEhwuKjQd59QoEOojPy75F/Mz8kYLak1O3y71?=
 =?us-ascii?Q?bgZasMtIcC/RM4+o3oq7YP+kk2Do7Ygac7nl8lnRd4fYuWlbOR+56NfszWAK?=
 =?us-ascii?Q?Sfn1pvBcdIGeZXG7D0zBcCARGHF3RswWUjXIoWb907xbOdx6+Lt8oiNt7nKP?=
 =?us-ascii?Q?6Xs5hF8vlT8mmbXqUo8DLwEej7o/xMVi4jtmCSSthaTgjfh1gyCWOOXdAb/l?=
 =?us-ascii?Q?WBEH0QeuJlYjDoT2Q+CBz4DHuu3uuxZtwdAQp9H8Z9UfBNmQU3ebgpERunER?=
 =?us-ascii?Q?2tFkky3cuqCcm3VpfSnWjGmuHxzIxSGXcR/+sIFG99fi3Sh+IzQjE1Tv3KDp?=
 =?us-ascii?Q?Jgp038uK9u2phgaDfcZy/U1Y2ThwZ1DaI8hQAXps6cQ03VsjFrPl9VROZBCe?=
 =?us-ascii?Q?9XhycBwtaY8uOK3dE64NrJCmhVzK5auXRZb4kF0twOd/8U4xyQDMmmj8jENd?=
 =?us-ascii?Q?/Rce6k1ZtiNatkEwyZMPHgooIuhkUF8WZq6oVDBiDASY9PFCN3R667J/lg96?=
 =?us-ascii?Q?suvtVeW6BXuAhWzzM6SB/XewccSbsOOfOJkDSa59X62vnxH0cNc+N3TTc+vx?=
 =?us-ascii?Q?iQh2KkxKMPDAcD13c10645HtUjefpI4yEQ30voHP8teat6boqDlJYLUyns8J?=
 =?us-ascii?Q?SNc6+NzhYqveeEnlCl6TFB2HMEI4ogmsYJrCf2U74oHNzVQH4kUVtBlVZ0F9?=
 =?us-ascii?Q?sXrbHX6ECea/d1NX4FgyOwhD2OnRy86KkPd9OD2yOhH8fxR80Ytlq/bi2R4X?=
 =?us-ascii?Q?P8YDhdlV8muGgT6bzS+F6/ZpzCRBZAD+VlV04oATpake/UezxYxyPCgvF9su?=
 =?us-ascii?Q?ab5XhsW5yBt6kKpVx5nmKzqZpHKeBa1lBOwZi4lkh/fQ2jrBlsVMTBf+mZxq?=
 =?us-ascii?Q?xOyXMPDB6P0eiMAjK0PBIhUkX+aRLP6dCcJ39eDe1wQIpF7ayw9aD7Pmexib?=
 =?us-ascii?Q?L3tkDAh9kGzfz/McP8moa5pPJCvmWnxqVXqhjmVSv235qS3h/kT+fnsn+/T9?=
 =?us-ascii?Q?SoQ7woqtW6ME8IDRMirR6tN7VLFQNbWyOS6YSWeAk+t9ZbzLx5HJ99QMhwQU?=
 =?us-ascii?Q?LUMqlWC0t737ripO73vX0l70m2dCJ3efRyHtt0yWbhCVndw7tH7If69nRaMm?=
 =?us-ascii?Q?6HQOXR6deQ4uwR1mM2ZI8UaLUYWZvSFICPEhtxJ6pgKEVuxSH7tMyaclvard?=
 =?us-ascii?Q?Ki7mxDeIE+yKgfg1bbkGglf2ohr+V6LCbRWmcQdgS+s7kFi1xpQ2FFSfHcnD?=
 =?us-ascii?Q?2N2PaGOraeZnB7ph9aayZhWwyTms3QPHcNyxqBQIjXKBwC15w0k3iFqhrtzF?=
 =?us-ascii?Q?JSMsyi4y+mTYbqn54JHQD/qtgrc1uu5z5+QgYKNd3G9/AmiLaagM78wSMHTA?=
 =?us-ascii?Q?aMOfS7tf+UkdmSvqk+gS5wAe0a7oP5J/NMmF+2KZ1OEhuDYSJHIMV3wvhkl2?=
 =?us-ascii?Q?MFNkmh9BL8n3nlTTmYMp1eXZATf7pU0eBjMOQfLv7Uk4f8XYJMLCCVsbx4C/?=
 =?us-ascii?Q?Zjzc4xTbDpydms6aShLKi0YXE0kh+TroSqHVMGY7MzTZ38W+/feBcuDPtIO+?=
 =?us-ascii?Q?e3VnOILxAzvDhH5gbf4pNDH0ONe5wqDaKoZsJflpgzz+LFEcobci0R9zhWNi?=
 =?us-ascii?Q?AiUcVYTmpw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3485558-632f-403c-94a3-08de4d35386a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:06:52.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkARLzHhuLHHnr6zkVL73evtOyyEyiJ12R/ldDvrpxM+PfPl3PgqpxwKo3BDv2Tb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

This driver used to use a lot of page table constants from the architecture
code which prevented COMPILE_TEST on other architectures. Now that iommupt
provides all of the constants internally there are only two small bumps
preventing COMPILE_TEST.

- Use the generic functions for the riscv specific phys_to_pfn() and
  pfn_to_phys()

- Use CONFIG_MMIOWB to block off the mmiowb() barrier

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/Kconfig      | 5 +++--
 drivers/iommu/riscv/iommu-bits.h | 4 +++-
 drivers/iommu/riscv/iommu.c      | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index a329ec634cf1c5..f681188d19a1bc 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -3,8 +3,9 @@
 
 config RISCV_IOMMU
 	bool "RISC-V IOMMU Support"
-	depends on RISCV && 64BIT
-	default y
+	default RISCV
+	depends on (RISCV || COMPILE_TEST) && 64BIT
+	depends on GENERIC_MSI_IRQ
 	select IOMMU_API
 	select GENERIC_PT
 	select IOMMU_PT
diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index 98daf0e1a30690..29a0040b1c32ea 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <asm/page.h>
 
 /*
  * Chapter 5: Memory Mapped register interface
@@ -718,7 +719,8 @@ static inline void riscv_iommu_cmd_inval_vma(struct riscv_iommu_command *cmd)
 static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cmd,
 						  u64 addr)
 {
-	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, phys_to_pfn(addr));
+	cmd->dword1 =
+		FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, PHYS_PFN(addr));
 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;
 }
 
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 4e2e08114bbf15..7a63f1771295b1 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -160,7 +160,7 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
 	if (FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb)) {
 		const size_t queue_size = entry_size << (logsz + 1);
 
-		queue->phys = pfn_to_phys(FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb));
+		queue->phys = PFN_PHYS(FIELD_GET(RISCV_IOMMU_PPN_FIELD, qb));
 		queue->base = devm_ioremap(iommu->dev, queue->phys, queue_size);
 	} else {
 		do {
@@ -436,7 +436,9 @@ static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
 	 * 6. Make sure the doorbell write to the device has finished before updating
 	 *    the shadow tail index in normal memory. 'fence o, w'
 	 */
+#ifdef CONFIG_MMIOWB
 	mmiowb();
+#endif
 	atomic_inc(&queue->tail);
 
 	/* 7. Complete submission and restore local interrupts */
-- 
2.43.0

