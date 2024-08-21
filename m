Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF691B2EEC;
	Wed, 21 Aug 2024 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261854; cv=fail; b=tcCtHDwLTLdCDj0+/N+Bip8scBIL+vZ+BfvH4KlV2pDmnr07DP5zfSBtX16g5IWp9wOotYC7oAE+8AqrqLyUtpamAVoCH2PvBr4ndPAVJ4cBWA6+wMwIwZn9tby16eUy7C4JnE+UpCfKzQy6aZIcmEH6nPuOprHtngqliMSEvvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261854; c=relaxed/simple;
	bh=TMc3/TNR4+hDQADmAg1WrpNK7rNFSwtSDVdWCacOqpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PPct/7CO3ytt0kdDHnMcAQQ0gew3AbqVY1kPMvYW7gVjwblnxCgXlj4viv/b1pXUVz33tURyGXsROd2IJLk9mx9UQnvSD8PYcEcXaSKgir/3VLLxZ9CfhOQmTrxoY/mpssDEX4Zx69NWWCfQKrSAHVk16CEa+CQ4V+egvQE1IlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UG9qj391; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UG9qj391"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUie3YHSnLaDkXE39sGtBajDHRYOPMr2Omu7hGnkysTupAlVxFg27B6sieuoGH00BF2Zddn6IFXqyBshuGKkfYKT3covZsPqJ0A8U2bwaQuOwBuLC098SnQSSUNmAtZCm/LEEhtjMqCLlCDmeglM6EBOBnKA2yLK1f9KmdtWFsVcqN0mQclz+7i3cvOVE/opFCkFp3cOTMaIgTOH5w88h5VV66xiYS7XZZQzkQJlFvvrdm7jYkNb153/kiyrn6Kcrlt09I9VQ6HuKzMAa3MbtD6MoGbCuy+orAO1n7QyBRp9h2UU7g/wY76YGd6oacSRl1gJoVUOlMI8uvqNDc2qnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+H6LhiwoUiSsOVWoC1/EHszXKtjxYJ3B1z7t0x+pqg=;
 b=IFVkWsHU0RhQqaxPm+awZIrW/2Pzx3vJZ8m/ysqTDUKCi3RjJEIky8eC4C7i7hUawIto6bZUCp71bXBNO7m3IUFfBdfRhWpxhwaFO7VxmDvJarASu5uSZtZf2e+hpHCpEecrgyC0X/hnC/PDFPBS2oIPmi3a7riL1a06hqWnxTwLzfuL9yFaTCtab71x3iubviOyKBosAuUicuhaSY8Mapl5rrChhzaZa474M0FfW0VObLHsDMOE49L75A+ooJmYs6YbkE2lpX+9sD0ueI+Oad9GhlC2r42UtZf4v7J4lj7vIOMWng/xFDO1rIqpqLyfTOwy8arYVa2prUOmTCOWpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+H6LhiwoUiSsOVWoC1/EHszXKtjxYJ3B1z7t0x+pqg=;
 b=UG9qj391L8JpIPgjeLOup+XIroD5WYWn9U5HzqVQkAMQWOIPgCh9ApCGM60zTtTU/9/Mrxu1FBSb3sDJjNUVoMtcvf2mW5XoD7+KN02y+6JsdnmZhsljhiYRY+iTXugAxqYO3ppx1+rN79sep5Epr6Z+MMbP1MWAQzWPwxLDqCRcAlDPDoRRNtIqdRwaCX4aZV4QMpvHrJXSeaROOSryQofNbU6Ri3/QgQzLbRT4FEAsbGE6i95eTwsELk2aZ4+qKjj2L++l/4KhYHkMb8She7nGGKL4CnFc2ldbm9uupSiA9+Un2P1yJPhWeRi/kq3QJDWX0LIuIc+bhB1MExDx4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 13/14] iommu/amd: Correct the reported page sizes from the V1 table
Date: Wed, 21 Aug 2024 14:37:19 -0300
Message-ID: <13-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:36e::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 416ad5ed-19a8-46c3-7a03-08dcc207e95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jHvdgD5Q0vhLTvuUBKpO7UubfZEBeNPNgAEgDMR7oGqJk6hspHTKWsVFwn3K?=
 =?us-ascii?Q?wTpwPAw2O78WTfXO+Cuio+WWRGtapmJq5o7iMAB3dIAguWlwULkXSELbc7hd?=
 =?us-ascii?Q?m7owhA3/CQeH9eqrIs+qnjz7ADQtNv26SGTP16wC0AH6UmiWlHNnMWwMRQmr?=
 =?us-ascii?Q?Xdcn7NDYsEWhwRR686dY7QtFvgqWCMT4E3tUb21t3LfiUI5SN3qFIQNxJerQ?=
 =?us-ascii?Q?B9KdGdhWDBnNGIp3TMeUSRBh8PSAHwnUy+dly24gOqy5y+k7cQAZXX8RpRiY?=
 =?us-ascii?Q?ZIgOQbT7WZ23yFF7wHFd+H+XJDlEhCaSVWkwDsdUnj8x08/Tdsku9jjxfyhy?=
 =?us-ascii?Q?nFkUJd075R3CzOer9RJklKa3HGN3TIEvLXP8kmgHBOH+Oyehm5s4LaCqC3rs?=
 =?us-ascii?Q?F00x7TXvypCQy+5oVuVVxs8D/q4wwoUta1cdtBNhhmRLt2Qvrv9LcnWGmoPC?=
 =?us-ascii?Q?Ljgbk3xNlpaQP3uXbSOsRm/v9z8c4zGEV32QU33P6xT66TK8ipN0m05gc3dA?=
 =?us-ascii?Q?4ncxdmFyCinpB06d01TpPiaSMWUJLjfT2kck/IAvvsjylhXr7g1wdDB/L032?=
 =?us-ascii?Q?DPooyrjcDd+JHGp6KSH2NO2dAVeeeMqcYNJqJZW0swjxfBGVhFDOutKbBwN9?=
 =?us-ascii?Q?u9ds8I1qtEeyTKY8b70fZGYtXWriyZk3lU9dHXQJiZzCaqnjaURsJqrZogIx?=
 =?us-ascii?Q?81RGYpqkE09SoRKKW/HWq4Z1zYtu4eMc3xrkH0g7I21OddSt7Zp2LJPWLeMa?=
 =?us-ascii?Q?jodYE7kwvVt+bXlw/kyaXhoJTXUP84S6Y+xC6vea92EBIGCtnO+j6f9bNmKp?=
 =?us-ascii?Q?yVzVFMbS17JgQ1zgpgLuqJNM8rLCWEIq2jem+ryZ9jaj2D3pK16Yh0fTjemG?=
 =?us-ascii?Q?NTMyvrZu0m/VQjS94kM0+uiIFXU7x7UUy3G5jMWCthWZeX1Qh61cITk4yAwD?=
 =?us-ascii?Q?CCqKDuHv+jMEUv6b9zI8z3MqvCn/H06x4cDf02s1yDJzovKqVECFKJ10TLVe?=
 =?us-ascii?Q?tahFVk8YM3mkFLMg/urX8PVe5IvYMj46IG62skgFTtmUsb34Qn1hfJ76oNok?=
 =?us-ascii?Q?OuAH6oZeKjtmB9qcqVeOtnUktrE9lH9GpEPh/RDuu4oaMEdex4P+pb5RPxG/?=
 =?us-ascii?Q?pocqFevwoup8SyO1s6CCotvE3RHDwSXjCra05D/IRuWoEByIMmZJw6QkZXT2?=
 =?us-ascii?Q?mj/IZFK5zETxV5BKwIWrQeUyU0FyG0oD2LSNWADs5+xbbe4sDU8o86ma9OVm?=
 =?us-ascii?Q?LkT6QTcvNV3CnyUoMaT6XPyOQjhjcJDodXrXH8qh3ZpE3eIJ/s8qayr6kmBF?=
 =?us-ascii?Q?n+uFpafR1b7N1J4EWy1YLzW6AaqjRiT+Z59EYtSosOCRlw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4rHINLaMp6Hc2xHKKqGEcMP+TT5Dq58S6qjxBQD8xsE9HnWCCZQ7516AZD2B?=
 =?us-ascii?Q?iZw16lN3j+NBbb9nkkmc6pJ95ME92kHv2VXaEhp33SWzrefnMM/0h8k0IDal?=
 =?us-ascii?Q?K++e2szj4UHy7HdDW7DJHST6giPrYooCdX9yg5gq4mGu4QTKeUWRKIVGnUZr?=
 =?us-ascii?Q?sX2Jy0dVbOhkShVpa8gEmUYPH+BaHzLgb8bIESDZJRM0OALUhEQTAoPXDLlX?=
 =?us-ascii?Q?Wx8M7I2LIxBFPaco6PqEeu/kjEEWbPD0BFuG8+HdoBX/NrRUE8RRPDEjv3Us?=
 =?us-ascii?Q?u3o/ENPVMoXx2oXu6Y9Zg5PzwyJq0NgERHbx7+tK4LEuZwK9agFfRXbb0PNG?=
 =?us-ascii?Q?h3uNld77coEG267DuiyW7Dtck/aZ15/hNs0BXhKno3KkPQK49o2KxV+rv+gW?=
 =?us-ascii?Q?59Eu1MDU4Y8xOV8O6Gubt8f1iu4cW0AU93Lk9xjJcK5/fcAucvCAF0wQzqQE?=
 =?us-ascii?Q?QraX5TyTPWFqugQcCqKTNTi3ScZdWtjYVJlPXKmD4GdySP43GHi8e7kqnvIT?=
 =?us-ascii?Q?W4BsT47TDlWWjRrMUnjsQu3qor2H5UMFvtSx5F73jR0IsNPw0daEF6Q+MmXM?=
 =?us-ascii?Q?tBcGwPVMGjrxIucSiMhA4GhA/YYncT/mv2briOCkoiBd/bSfF5lBrmxkyKo4?=
 =?us-ascii?Q?Kwl4/egBv0yid0qTHScYcyO6lh/sjVnns509Ns0s9ryDs3AMdqyWsP33eaf5?=
 =?us-ascii?Q?gjN9JhoDXr52kxlViKuJqo9C3poIp51GId7aT2ENqIRB+F7gSyYKpxx/mV46?=
 =?us-ascii?Q?FLPSm0ALkA7d0XNT1MMS8h2fTqhHWBHVTkXB3405SNr6MPnJMpcQOZQw9GVe?=
 =?us-ascii?Q?uhsd6nBeuaKKoFlZeZmKkuUzKUkCT8z7pboAUFT8E5WYbAenf2ySq3SOBOdR?=
 =?us-ascii?Q?fN4yeoDnM5Y14P8D+ax5a0x5yLUQVdHWWGbfiFS+mhiZEtHjFLAVo1sX9Fjc?=
 =?us-ascii?Q?n/K64lJ50XhGZxPB+5dedtgnNrmVoHo4udF+ekeB9iFrfGob0RNyoBy1L/zg?=
 =?us-ascii?Q?Qsg37VR/Isy4s+BI8GOySlAasBUQcyKbFkd6BcGMCCxYNXoE++xzXH+f84ZB?=
 =?us-ascii?Q?oezwMSseeQBx8zyG7I7UzklJGaKJDz+u3cse/IRjZpKNJB28FBsUjwn5FKqb?=
 =?us-ascii?Q?jlr7sD8J9UwLngSJdeqmU6ShgL7fnGgCaE1aN3UoxvOXNy4FyZ1Oxeldb0YO?=
 =?us-ascii?Q?T64foBORGu2n/jmTQHSOkpev9lMA4q+32yhr/S2fpceSA/doV+PdWJ6oauSQ?=
 =?us-ascii?Q?3gKfNfpbW64WYwnTwjWHOX4/zwO0Ow0f0Q+F13GER0pVw6fnmH2gl48ocWtF?=
 =?us-ascii?Q?9CQTtK3o1hvOTNhvJbsoXZUoEBdiXdp/rZDRZFUjM5rBwTXEl2XXsTjrrCyE?=
 =?us-ascii?Q?xu92EMjRLQsov58uTSl08uae6bkot6W7VgL4x6egiw1u/PgS6A3SwOZfCODf?=
 =?us-ascii?Q?A1fUsN+epR3Lg67ctjK7fpRb9FSBmvqB9TgWtGWkvxBC5su7g/9sypUHvu8x?=
 =?us-ascii?Q?8X8MR7NNMmx0PGkSS1OTDecz0Ci4m33T4EsQ1nlnh/bBZwzIa7XhFsgPAAjg?=
 =?us-ascii?Q?3WuW0u7or/xSgEgKKIoOmkur/Z/GPIW8oIG/9y0j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 416ad5ed-19a8-46c3-7a03-08dcc207e95d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXk9XooDsYrHsALf1FBA4hkpnVQjn5XNpx2lCuHgIoRdhQSZhL0+IyCwztsrL8By
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

The HW only has 52 bits of physical address support, the supported page
sizes should not have bits set beyond this. Further the spec says that the
6th level does not support any "default page size for translation entries"
meaning leafs in the 6th level are not allowed too.

Rework the definition to use GENMASK to build the range of supported pages
from the top of physical to 4k.

Nothing ever uses such large pages, so this is a cosmetic/documentation
improvement only.

Reported-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 74dc003f5b7815..7eb546af8944da 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -294,8 +294,9 @@
  * that we support.
  *
  * 512GB Pages are not supported due to a hardware bug
+ * Page sizes >= the 52 bit max physical address of the CPU are not supported.
  */
-#define AMD_IOMMU_PGSIZES	((~0xFFFUL) & ~(2ULL << 38))
+#define AMD_IOMMU_PGSIZES	(GENMASK_ULL(51, 12) ^ SZ_512G)
 /* 4K, 2MB, 1G page sizes are supported */
 #define AMD_IOMMU_PGSIZES_V2	(PAGE_SIZE | (1ULL << 21) | (1ULL << 30))
 
-- 
2.46.0

