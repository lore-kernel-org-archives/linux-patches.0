Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011000.outbound.protection.outlook.com [52.101.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE59347FF8
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651215; cv=fail; b=Gh08tfC3pnml80kFbt6KSvND6COigf5eHA/ohmzDvWCQoJozfSC+QWNYjXHHOT34cBjSDpvhKCUMZPlpuINC1hXOz2Db+qj9KVkI9OCzp9aM+2mZexfU5TR3+jsYs+KPBaODL1vLgQ71TcOec4nB4YtNYTOUnj5DfSyueX3Y9VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651215; c=relaxed/simple;
	bh=7oIB94kRDZN892D2nfEXgoUYLv/R4DBm8B0AWsVkbfk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ancVvWXUkwu8lLvC/vpKYtyNOUFfFGv+3tMaW45yArSLd+Ks1CyDPebr2D2/qum58WDSFf6VFYZukPAkiPMtVnz0txFMEHURO4pORonYk3jI7K+I0PhxhgZ9WjtSytvbXIeZO6hLNuJOb5+dSRw6/hvVCaOMkdUPIQ+vK+Y/S98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a68F/JCX; arc=fail smtp.client-ip=52.101.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a68F/JCX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U2aryU7ej6f/lfLDMP4xyF6YhClcOgkHATlEZBroImaJ/Tm/BA3GhAnUgrLTziyX6GZRYbCISaqj+exaZgBJ3xSOzFj66kkoU8yUe8bFvBC+3VrBvmRrEIFRV/ZkzDT9uh8W7JGX7pCusd4Ps2mVoXCifZZ0+9fekRpZW7fFQNf/w0IiVPbGqhl4JnRtw2iMi3lXDjhUpz3fJlmN5x/tMGsANNmyQgZ5+AdMZN8noZ1fx/tWgOIhuL0v530DK2Q0VNtsX9PYJ/cRxHiPgJkUhHRiOlh7OuWG7X07PaW4oSqn5XzIpzqClJuVszmIyb/QnKeHBAGxYPIyzlUejBaMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIbNzKt+0XehVaztKuvtyH5VJgL29jm4LhhK6ILhraI=;
 b=oAILe0AV7Qhpwvri4B803jtmfUb88LhgJ8NOKrg2mz503FA7yg6wH7VepOsKnCPd+ppoCLzVf1GjMAsM7UtGngGWPExEqUiQhpxQ+/xmBMCNkZtqNqTpP0jYbKUvNZGoPzWgTxFbqnkN/KehUhbVQ7cVo2UH3XhViNnvTiD0t3aHfeL1T7bkx8QgMPcETFhdeTwXrqn4QbgWY1+2kx9MxV/gcgHU22t19rJGLuz/qjzVlh/OfQ/SJJliJQqDJCE74xMViyHpi4MYpGx4RgCViBVse7yxuwHDJqFkyRzM2y3u3HhZybQ+n6F6HX2uJ7sJdBm/oxxrfvsm6vOvyd4evg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIbNzKt+0XehVaztKuvtyH5VJgL29jm4LhhK6ILhraI=;
 b=a68F/JCXMGnZB1CfkqDDqzvPMvp0blIog8mWWPtvSOAoUQSbGC0ReMVvJAVj9U0tyIsjLkP4GQdsdJa1PEumILkzyShcxNsOGk1VWma4Po93qEOzMddvKcZw6gcoZ/ystCmMuimk4Jx24hakaeraMJS81EAseo4Je5zRIdVWB2wh4ep7jKwSWgGMcUxM/TriavQs3FBIdfbBXdJ4amSlFeUHnHquqhukI1DyN2KqpBGW02ou8FnZFM4CTrfeRywdionWSs1tEswKG4JQPd7MGa7m1vKyr0Ns6pgls2GBvyOslQWpr+Hc0RgnJOgmvo8RnyOGXZS1wJmAkFS/x4Dk6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW4PR12MB7484.namprd12.prod.outlook.com (2603:10b6:303:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 15:06:46 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 15:06:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joerg.roedel@amd.com>,
	linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH] powerpc/pseries/svm: Make mem_encrypt.h self contained
Date: Thu, 20 Nov 2025 11:06:46 -0400
Message-ID: <0-v1-672b61acd916+1449-ppc_mem_encrypt_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:208:23c::29) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW4PR12MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: 0daffaf0-478a-4e41-babb-08de28466c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c75aSHdvZgTn8ocxOxRUcWT3cS00RBltB2F41R69jw5PIYmFAICxLegiCFb3?=
 =?us-ascii?Q?gS7CpZDaYrrqqeAh81h6gWz4f01WFgvjpnLjyB8vcUv0cbt9ZdsCqJEYpa3l?=
 =?us-ascii?Q?voglK4VFDl37sNIUnjTN4H+StEd+okaiglIMq6vao3wxfB0krWLJ+7fi9pl6?=
 =?us-ascii?Q?vZfM5HGbkCfLBXstlwhO78hoFciTjnHEc+L1SJ579dyo7bUa8i9JuaaBHuzD?=
 =?us-ascii?Q?6ULtKaCY1gOaxbL5+Q7K490MC/20Ms1iEqp4LZBHV1xjKwtXWwpHluDn57q3?=
 =?us-ascii?Q?z/8canDgvtqxU9XbYfsYj2/s+mQoUZ8k+VaEdE1+s0UkTz+6WkpPBB3maA6L?=
 =?us-ascii?Q?qQAdOWOZJvJm5DYvMhZyOjURnnqCykdfTiWA1vXv3I5paPmZSP+YmTo2aA5t?=
 =?us-ascii?Q?RcbVQfX6pgEAZ2PCPtQPNzTmh3Pt/VLsCSKuls6oxfBDY5NkTrpUmjgsYG1X?=
 =?us-ascii?Q?1398Qop3NRuBjnlEGssZca2peHMvOd8HRaioFGSZkTU79nIrYpb/LaHQKrnt?=
 =?us-ascii?Q?omRy8LeAF7RbB+vk8eG+UuPbk0/iZd2ZSbV0JN3/OXILSvbyHKo4kfsliFMD?=
 =?us-ascii?Q?UOj39kfQ+P9K/rZz9y0goaHMCUhKr4+En+Usc2RvdtUEbFybKBSCKEhIGL1V?=
 =?us-ascii?Q?WikVewM6KXf65UvM1Yqjfh8w49C7wI8M/zdTwJv2BhWoIx6eUp9aPcjphV6y?=
 =?us-ascii?Q?HhsNEvyeen1jAojKyPXISORbxtxn8wIstFBVGc1CFyOHGg5nPnPkuW6t7jKu?=
 =?us-ascii?Q?F8HtbYEvqrxtFRVGutyGEtcwtT/RDrO9e7i2lkVCx+COhRX6B4W77ImGavUh?=
 =?us-ascii?Q?r9cADbhsVJky/KN3kGUV4d4QzAfcQXrJ9At9py8iSn1PrRR2dbX7rBBmFFwh?=
 =?us-ascii?Q?w/YBQz2TyQyAiuJKw2XddRgl5xzUz1MZMBzpWjlN/OGT5XK+QKUasWFpv2na?=
 =?us-ascii?Q?DoGT5CgXu1XnRfWMYdd1BzR1m05u9Oi/taiWwbQDfAIpKhbgqufCJzSs/RvC?=
 =?us-ascii?Q?ijRJ2ycZBpjH6ezAS1p6BfzDXqduHvGmII0i//vVAWqTNpvMXdDPj26/ml+5?=
 =?us-ascii?Q?KH0BAg+l0+eCPbmnJeoV4nrD8VYeb8MJLg7iPcdwxJ05sTgcOv9mJzYLjz9Y?=
 =?us-ascii?Q?WGRiZl2+7dZKUOmw6cc6FFb/GDRvmXL7mBGCXApyo36gQjepZo4+WLlHI61u?=
 =?us-ascii?Q?gTmwBx+bi1O/bZnaobgdQU3Ql3hqFMEnhtAobOMHMVMh87n90g7lUoTL+iD4?=
 =?us-ascii?Q?pa/kRMGN9RFfOA6npHvJe92Cl8eEDU11bU/r4WaammoNzpZXtTCdNRJwtkb9?=
 =?us-ascii?Q?47VICRmSgvezW063BPQOH97uz+hBSWcV4iBPp6fCcRL1IqX9uMslWRUq9fc5?=
 =?us-ascii?Q?8bQG3W0LjNs6OVf0ne6nHAKxjRCIFM4Lb5UuP5KxbwE7TV/GdiCYchZ12PIi?=
 =?us-ascii?Q?uOK3SgwmD9cqr1DttiHaWtNzi9PttaH4JQx9zW7PFQ+waUgV6l8jpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bReU4PE0WWhX3wUcq7toZMB+NRpFSefIF/B6QwTqlul6N1yrpFt5ejpp64vv?=
 =?us-ascii?Q?XhZH/52C1J1NrZNczoDXunN9Jx9aBqy8RgbJ4nDCLBI0u7Q1VDijywuU5i3y?=
 =?us-ascii?Q?RsPrez92sWxmxeApjnifWJCQN8SpzY+sJzJ1Z0rQK/CcSzPqski0KXUHnQYf?=
 =?us-ascii?Q?kZZeGnuqbx9n+D2YOlN3ax5wjiZVtZkgjj7Nsdd9zAF0Lfc02wbqWG81xJ7J?=
 =?us-ascii?Q?4sL78CWgo6wh81LW/7fqkZhOQSi/aSkPMwHypu4ABguGOXve3vH10P//ETP4?=
 =?us-ascii?Q?LcrxM4LRJt/gMmDDajM9xujIbzoQ3FTRj1b+6rFGxLnOrKewnktEMATJh+Wh?=
 =?us-ascii?Q?XpnLa5ynqi6bN4gP+e5ZFGUiqXyx2ztI+xm48HCpwOGSNl44awOH3BGlfh6V?=
 =?us-ascii?Q?UhaBZcN5cz+hCHRoDPnUAC23DzwHhJTjM0149lFGHTGpG7sjjQdZSJzlDb8I?=
 =?us-ascii?Q?HYQXsyt/AEfNh+fGiagzxEphS0/c5y6ErJ4q5QWFCu9pwgWCNSiF+iaCpGps?=
 =?us-ascii?Q?TZplzGHIARTQmZxMPwv8Bz280HinHGw16JHM8GE7A1Z3XpkWo364/Ji4R4gM?=
 =?us-ascii?Q?/wK6Ir7dm+eKIbL+GBQq3+7XE6YbGrpZd9n7/ZbA8Ryzs9SvAjYUeUJ1gCLz?=
 =?us-ascii?Q?A6Hikax4RwH9rnHPkw8bB7Rcyej9BlcPcryTwItuCAce2VPaSvdsWeJZm28w?=
 =?us-ascii?Q?Wjp2cmctpsSMWGJyjsHQ41ORBQelY7Maiz86d1NLez3FHnZq9f9BQKyEeqYz?=
 =?us-ascii?Q?PW/p6wfdsbO0YAt6utDTY+B186f/XzMYRBb/urp5DZyXDcu5GLP8Lfl8Otqo?=
 =?us-ascii?Q?dCLvr6MgQpPtsGRpfvv6PuXROLWC5Pijs4sJ9A47KrEelRPrT+t8u3zMUw7u?=
 =?us-ascii?Q?ytt2yQynqeiQcZmh6x6sItPAJrdwhK1EgTeaW5iOW6csWeybS4lYNS6Iq08q?=
 =?us-ascii?Q?mgdaDA4Epnw9G9C1osypA4DPJCgfePSkwuYhcNE+rnzPjB/qcuYcfkb2G0lW?=
 =?us-ascii?Q?nc9z50PsZEnWh7p63TYJwSwdg5GhShMgO2tmFiznQBl4COqTaxALgoeI4Zel?=
 =?us-ascii?Q?9Hl90PFZK+RPDx3K0tICZdkV/pvpsG+qxLcEUrumIBPEmi0VQon0Klz9+QYN?=
 =?us-ascii?Q?UewVhhUcI1QNxyjfabJ5FB/oRM8qhkJ/GPLaKMoDvLGUEBst7U+UHf46Pgt2?=
 =?us-ascii?Q?C1RsdfLtqYxzor4Njqm0q+H8yVw5Nlg4eIvlbEGA119gJhic6Po9AF1ojmie?=
 =?us-ascii?Q?hPXpGNNDivLLrtd3dFINKVLyZOgAiPiGfrc6JwZjz5wQq6LI9BZXBI7FCCPl?=
 =?us-ascii?Q?Yy1DemSlhFX9FBWBXQVq63uF/zKmORi5duUS93vuzgIsbrrNCS/imS5lHfLv?=
 =?us-ascii?Q?X711gWdRMoKuQEtJDh+PPTNEjbdCRiXuSIffS0QnLKOlmyuFYI0zZoci7RQK?=
 =?us-ascii?Q?FzWRKiJ5WXXUfnIZ6CWNPoCSG+sGgR5U9yzZxAOH1tQKdGS5PcDwLK7CoA3K?=
 =?us-ascii?Q?b0WEHlUgi6wepkWaZk32prEjv0az53MrMP54vyJFBV7be3OaDylhNV3AsrGW?=
 =?us-ascii?Q?9cTGPmUMT6M760udp7A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0daffaf0-478a-4e41-babb-08de28466c7e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 15:06:46.7322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhfqIKLybAZCOB5ogsISo4yV9fy5dgCKymn3yAv/Bq40mLiPuqgZt39QHU5AHpT+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7484

Add the missing forward declarations and includes so it does not have
implicit dependencies. mem_encrypt.h is a public header imported by
drivers. Users should not have to guess what include files are needed.

Resolves a kbuild splat:

   In file included from drivers/iommu/generic_pt/fmt/iommu_amdv1.c:15:
   In file included from drivers/iommu/generic_pt/fmt/iommu_template.h:36:
   In file included from drivers/iommu/generic_pt/fmt/amdv1.h:23:
   In file included from include/linux/mem_encrypt.h:17:
>> arch/powerpc/include/asm/mem_encrypt.h:13:49: warning: declaration of 'struct device' will not be visible outside of this function [-Wvisibility]
      13 | static inline bool force_dma_unencrypted(struct device *dev)

Fixes: 879ced2bab1b ("iommupt: Add the AMD IOMMU v1 page table format")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511161358.rS5pSb3U-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/powerpc/include/asm/mem_encrypt.h | 3 +++
 1 file changed, 3 insertions(+)

Joerg, can you pick this up too please?

diff --git a/arch/powerpc/include/asm/mem_encrypt.h b/arch/powerpc/include/asm/mem_encrypt.h
index 2f26b8fc8d297c..e355ca46fad933 100644
--- a/arch/powerpc/include/asm/mem_encrypt.h
+++ b/arch/powerpc/include/asm/mem_encrypt.h
@@ -9,6 +9,9 @@
 #define _ASM_POWERPC_MEM_ENCRYPT_H
 
 #include <asm/svm.h>
+#include <linux/types.h>
+
+struct device;
 
 static inline bool force_dma_unencrypted(struct device *dev)
 {

base-commit: 7e06063a43d317c1ca9278b6662555f687f43f03
-- 
2.43.0

