Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8131C861A;
	Sat, 31 Jan 2026 00:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817657; cv=fail; b=fk1UEipY3Er7izt2LHVRMaissZAsyiWtnMl6z+eBSAF587pgWK/jeS42QUQJR7dMmZFLRtNOTZe3ifDrCRx9aVhUq8T1XpGulHG8U4gCdpLM7ZLEakhldaODtZ0Gy+pJo3RAa2Z8ROVyCt5kNS9hu2C94WQNIqoXMNfY4Lwc6xQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817657; c=relaxed/simple;
	bh=V9wjxz56SldAh1igT8bvw56sPjedgF8hjNNyJ9bJGd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oAuGHf3AKfMYs6ZOhOmgVRgVman0E25gZuxgbOkI1v0Dr+Q/0MzpI+kby3oglWvwu3oq0GgampkwRAhIcIXTNtrlXIxNXIwNrjF8jNO56wjc9DrwZA+BV6PIEDmv2cjT1TsriQwnqrWe/pH2tYYl4lcqHXWsw4vmc/DMIwY/AAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xk4LmEOb; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xk4LmEOb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXfz/iM5Ac0AqedY0kMF7JQTi8kyBtSVbziTRHiuLhd+x4uap7Y61XuwEVMwovNbhxCMyuDgAv73soYrjyHGKQMMVQnBSeF1e6WOZb+czPcY38xJqO6ja2wcFxE2Ht0/Ew0DpbCj8DHd8owz28va1MRz2cpOZ1YukZwKPwW13eziVs5xdJU+Np97/tSPkX3R9ViSVBwaAzKYCir+FdYz2Kd26AnQFuMwZozgUxOC2Rf7fHLdz/QB/TxAlCuk0kdSUk6dzw5xCjPXUlxZQJxG3OPQhelOJRmJgwmePoVCGywvr0CB2WHECXumaFK3oeFEKpMobADPDB4cycaLlL64hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv1NyfL6jtImE1ax2u0JNWO4FkNc0azGLHqxqP165bk=;
 b=W1MlI9yI1YwdzDJt5eR3/JhV1Q7GFB3syfoBvDkVcbspOgV3+Ju77P/Mi2y9CBWDOCHzZifRCb1nTjGVpmQlAqaA0MEuxVwN0VIJ+M2yzgFxQ1yBPh/MAfBcIXMl+vHSc0edNuArJa0zFR1Lv5xChTYKoBk6f8EvjNCbG6ybZmYuZ/ejd/YzUZA6S7OHb/Akj6fa/5SzZ2nz3hpEsNkIbFHqsyfYKOEhbr7o7JfYgUfcCGy4FIkLZsWsvlAcAZwdhFWP6/yqojmap/7O25Lgsv3UQ7jW7uG0V9M9DgsrmeIurkkCweufBeMIgkFM3stSrsH9XppaCYWNqawKq1SI4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv1NyfL6jtImE1ax2u0JNWO4FkNc0azGLHqxqP165bk=;
 b=Xk4LmEOb/XWQRKGeoW1XXvTVGalDorsi1wi0vh1HIcsmJR7pqmQ/eNOFy6eJmpvIBUxXKXaltqmyKRYUuzBl5Z6t9qwIoRPWtOrh2+40psFCVhlOXAiRzRUBwwZ6wZgOAC6fkMJKDNDhMJTS2xtCHP8RwUCTH1G3vWdNiFivjEhQGusllS5GnMy3DMxDti03l7MBW95/5hpC4iy5EVVMGZ5tL+fuIipVr+EVpbZzs2xePKgmgSY57/UilrQYbpR1m+JWRmLXuJZyqO1VUb7aG5/mw+80JSJOxoWzwaIrDuKiSGzelbPhky0nsExB7iIvhIYIeKYgMugxVI6gQgRvkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
Date: Fri, 30 Jan 2026 20:00:45 -0400
Message-ID: <5-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d0ba4e6-0bde-4950-a556-08de605bc8b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wx5MaJBtYs2rEttHgiEn+2AyeP9xVhJTP0Aq+Uj8HZLGwhs9OWX0Fk0+7z8g?=
 =?us-ascii?Q?mSsXj0SXpt/thKD4Ml+iNwfVvcDP4wu/QjPDiIN7spUIstM0br83iUgR1bxr?=
 =?us-ascii?Q?p0f4pVzdahSIDCw4Y+l78c8P4M+ZPEHPpENosR1o3QHitvJxVHBrCCJVAI5L?=
 =?us-ascii?Q?nnx1kZZY0wH2sSt9eEqT1fcK6fgMoCo/2Pzz/2vETPRYY426FvzIrwgouhez?=
 =?us-ascii?Q?qOTuV9fLEiptQkAr4KRxZpXyIf0pA3U9l1enoN8/9qw0Y95+5olk+z/iXApr?=
 =?us-ascii?Q?vYEQ1ZfOCd8SqH5opLmY0wBzzMwySf+M0PlXoyQnfPWG5wmZ2BIbpPL8NBSy?=
 =?us-ascii?Q?/r6H7O2LKvnRFZEHcKDHq1Q5w99fLOgiGIVfhICbAUQNiAPsH0rlYk9ijQig?=
 =?us-ascii?Q?vEevcHJXeykqOAPwhZ0oHq5CMjvjA2K5Un1clA0RxgGflqioV81CbIQwpTZv?=
 =?us-ascii?Q?iCwJdxFwIqbW5cWkOxwUtQ5uRXHnnb/haFgqhX5DAA2Xv3q2pQJFgGhIDPQO?=
 =?us-ascii?Q?p+Tq+b34sInKl9/ESjUsItnunJqrfC2KGq5779qIH3Op1SdMEtMRZYnzAkJE?=
 =?us-ascii?Q?UYZHwjiHqgWdmscA1Y3rX9ycJ65t+3lDvNCafLeTdrMoGKI4k/nOMzw7L0Gk?=
 =?us-ascii?Q?3t2/ubkZ/nO27pdboRI7hf6YaDI9W7oxgFcEBMDZcCJQK8/+OLTsmHE84AuZ?=
 =?us-ascii?Q?HW8F5fVetj0XNRuzteD06MrOrusQlgvxjvmLdK/wn/SzvZuVAO6F6Du03zv5?=
 =?us-ascii?Q?QfIc1wNWJ05HZNVNlv3Pwj3t89mmRyzflzDsdm8fCS3gvt1lW2+iajNgCvNP?=
 =?us-ascii?Q?IxRoNjYSbFhlXn38Zcrn5sxo/N8kWfLdSbZU2sDteIK6EJi7ekbTfs8HQFD/?=
 =?us-ascii?Q?rzuCjv4SqLHGHmGjT2AymXJywg8o5gHXs2yqwq1v3IO1ixrQ/rOemvRiCzpP?=
 =?us-ascii?Q?bH+LPHtQ6iTs5WNW8Xa6wyjSlYdhMhA3CL5d8AMPCV/7t4RM4N6r0wBH7Ag6?=
 =?us-ascii?Q?eZ7MP9AdSZt1Xs3IIk25n3smO/1FPfL1Qyn37h88uR3ZHxmybnqZ5F5Xk3s3?=
 =?us-ascii?Q?TnYdfA3ziimTbco6S+HHj4b2HRXgsVH66L1Fo+8LqnACA6cG7BvpoIx669ue?=
 =?us-ascii?Q?SFWXVNRTlMj2AjB3hXsJ1tGjLtBDDFwq9b6TN4aRW/nj3jthxNhOGhQfwjUD?=
 =?us-ascii?Q?f+4HpNrx7xBSiEbwatikpIZmNAAH2Dh43wzIzYIFgV25Zf7mMUtHADCwi/E9?=
 =?us-ascii?Q?wwR1MDodPT+Hexi36w83UFDwDOmpLLVu3GRPRV9MZxynd8/ekq/1Z3kbjrDa?=
 =?us-ascii?Q?caSo2nuDM+8/Xh5CCqLQmkEl6M3H38wDAnOy/wMxelvrp/FKND4vi0e9N0PY?=
 =?us-ascii?Q?/Pl2gMxddegyxKKWYkI7+rvQ5SbM+J59z8sJrO603YyooUguSZfsr9nOk2Cv?=
 =?us-ascii?Q?d6mwxhIvV3dz5u80inlUqBwNw1dnDAqdLaJH1SgnSddQ8/jddXgv239ekkAZ?=
 =?us-ascii?Q?4ROSObsCFkJdsaTlf638a8jrxAiS8f1kjPtb8Gl4aiRx0bH1l5ttV7o7t8Ix?=
 =?us-ascii?Q?ZZaEOKQH0fJmXsEpPHQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZpRrtLqtvQqQOS0sowH6vBw0v//NdnyFv3dBXAvLgJtUWXX2bdtXnEtgfIUu?=
 =?us-ascii?Q?sYGxXW0c7/fmo736UP2REOIkRymYGOJuX6L4wHfhh6GxnPl0OpbDc4yXietC?=
 =?us-ascii?Q?r+C4577texRn70zAIIso8at7rDdzxRGO0uskREeLe7jsh9fOkTKoOZODnKEZ?=
 =?us-ascii?Q?hvYIQxOgfn1oa42hOpPvLVL/ISLm+MaEMxzQJw/eUBBA4A8OjMMNPEFyP2kQ?=
 =?us-ascii?Q?YcAxPgyMNjbmfPeesc8NTaq6t4vb4KsvNpmjHuGkfXSgq4rsV5iy+X2mZ/p5?=
 =?us-ascii?Q?rPcpOg1QQV/YKq2u58vqAgT6YCDsWD8b3anFS2WFWuOD25guIpHFEbGLtHDT?=
 =?us-ascii?Q?lf3gqkJYeUxZrs/lqnJlvps/kSTHALPzHkOOCor5w82DrA1frD4xpvTJHWOI?=
 =?us-ascii?Q?wP/VsmKKORQIa6eoa3AowEZ/+sXIYaC+/7ut30Nt+Sfd0FVIA2NaVL9JtEdD?=
 =?us-ascii?Q?OC8odf2SpctxhuKMtXq9JV2/12AOsF47lsqUW8VfTwmyqq64CEqpU++YfO/v?=
 =?us-ascii?Q?P2NjYB9xQMDOPPUfiv/9N33/1dEBSVA5Bs3pLcFuptCYc6ImujGQHFA1YTZe?=
 =?us-ascii?Q?Zi/NTuy88958ae+enLWyDQG7Hj52OeXUUSNnGOban0L/HcPpTNj1eRuY9DmW?=
 =?us-ascii?Q?izKDSvCTzc03n0naOY0kPY1nzeps09vFV29QtCNkQKMSuk8fmDn9ObO+fHpW?=
 =?us-ascii?Q?YPY031OA10mjZSIb8UiZc6XOUlFqk9vSbPrWVIucKNmP1zjNvOpWQvkcsO2I?=
 =?us-ascii?Q?ZOA6NWUPsbA5SXiUGquE15cCZKr9WdHuFFL+PIlggY7wKIF8tlj29K9lfWeE?=
 =?us-ascii?Q?7hiJAgqZuWyPbxJatDe5ePr+35Xd8Hu1eiYW0Iz/96oRR5nfUlR3FhPV4zI0?=
 =?us-ascii?Q?fID49dOSBcWL1v8Jl4DKqES4PSnMDKjPmC7a46Y5WTtI6R10gUSywKBiMgWE?=
 =?us-ascii?Q?CbQx+b7ItvrndaMl4/E8cVC4XRugjltOr3m2bU1SDK6zRoLjDVSZ8NNo5OOJ?=
 =?us-ascii?Q?sguIbMStQcSc8FNa30ZEz+K5c2pCgBbt7+008oa7//Fn6XGDmskm5a4PO0+6?=
 =?us-ascii?Q?IQszr7PfJB6mdcqUnBKGgPthS8tOOk7j6sug+un1HxVX9fuK0wW3mfvLkVlB?=
 =?us-ascii?Q?3ti71Lbf7D0FscitrW4nR1uc9UnA2hZL3WRuSqYhBAgxcs6f4icjOkWvEu9u?=
 =?us-ascii?Q?jclQpSz9GSgM9erkEd+aR8p0lyx772DgYByLCcqTe0EI3qycNG/4UtjVkeGD?=
 =?us-ascii?Q?cQyngPhj1OxGTJYIln6kf6rxOxKcUgKgGk9uzwvRNbdYZGS18+ByrFRz09VW?=
 =?us-ascii?Q?M8/xLVe5Qj8JEHt4/BbLXQ+wNYvVFWInd3KzoDkMg+2JIaNmtLabUDDQXBQs?=
 =?us-ascii?Q?0CTF8OqI8cT1LSNXAadGeEM+MeYoYzewZ6OY3Eh2OH4bWhrpv7a3FuhDFmKU?=
 =?us-ascii?Q?46Iyd/adFKN/0sZzVuW8R7TWJGygOdmb1dHdzBNWG4VZfLWhQ40t5qdwNxnh?=
 =?us-ascii?Q?7j1SNzoaFF0H5M6yZAPuueNIp2YoolHDPC7i4OouI+k1jL+01thE4/WLPooh?=
 =?us-ascii?Q?IXshyo1CHKI1+52X+GjpxrreQMy6YuP/9aKjfqeV1wQFWLfZINprwJepXRmU?=
 =?us-ascii?Q?kZ5hrOES89GdQpSb3DhDl4cl76J7aKtqO2XCOs1UeRyLeqpZ+TWLo3f0LnyS?=
 =?us-ascii?Q?4QnfDTgeYpAwybIWHULIQEgTyF476iESThdwaMyaSrR5g3kU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d0ba4e6-0bde-4950-a556-08de605bc8b5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:46.6956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nN4B++w1Vi0WcYGTtTMxuwHVs1EQ9SjG/6Bg6V352/C+RuSETaSlM6oASAy+zHZe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

This driver used to use a lot of page table constants from the architecture
code which prevented COMPILE_TEST on other architectures. Now that iommupt
provides all of the constants internally there are only two small bumps
preventing COMPILE_TEST.

- Use the generic functions for the riscv specific phys_to_pfn() and
  pfn_to_phys()

- Use CONFIG_MMIOWB to block off the mmiowb() barrier

- Require 64 bit because of writeq use failing compilation on 32 bit

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
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

