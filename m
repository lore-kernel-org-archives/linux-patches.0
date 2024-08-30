Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB3380;
	Fri, 30 Aug 2024 00:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976396; cv=fail; b=jLwBlcVJV2nBod1lp+6FIh9Kp54sCdyQ3lipdfPiR7aKVnr0BlFxskB1d7juTvQd9DYNQJJehmJ8lVKWbblAX73MXJKFKThdH3vLUWE96kuBTcDjpUY+Auf/yH1oqVft1SM4exBzsfdBX2kR2xcul3q79erOnbGPQ0t0GCtq1dQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976396; c=relaxed/simple;
	bh=sn+tTZhjmZ1FBAeEVYtWcZVoyXsGrxHwWa042UfwqFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bcu82wlAMxPtDNO6qE89elnsw1ioJ88P9w1iDs8/8RtxycGUr72vCSah5IEj9MlcvM4SkheTanXTVYj+csRfVC3RfXbHLpCCcC3U7UwMTTJpK9H3m1/iSV5PB0yRXHwzK1qw3NMcZMmmkQT2Z9SkEkDF2mqd75cGZWjIaMEyucs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jOCh4m3P; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jOCh4m3P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLbfTXRkOjVAhY2CzZuYc4qycLozkii+EETZKnbd14JCCBBJ2KMhdXnjFhnl7xPXAgd0gFeG6umL0t26dG48Mc9HAKOqI6NAFe7dBnakEgS/WJEbi9VdfOPZFI48Hz0l63R3fwvrw4YeYXG1Ui5DpJW2qEOfun9xebMlmIfuerwytFshorCYcMTHfS0SMsQigTiTesudc7mjNkOtUrsC/BozL1lzYPX/BlOzfiH0MdxF5VDqOikVktAAPxLQrLkJnaPHO80Moqv8kfUvx2VrPqIp2ySUYUqFrdyGBQtVOHVIpup2nCm3g2rbx60tpGoaxYFgQVvyc6S0YUDJQZJrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uqkk7sZqf0EfatcYv++mLaKhXwlWDW9G4ibmu7Y7XmE=;
 b=KUatQSmmiwZ92jj2o/hS26JXYJ/LY40qsDTZWss4GJfDNRzx7oD7tkrnYkiSna8FG34qkhSFU5bELukVxT/ssZLJa7QLeKFzrOz//eh3HKMRjcYiN/d3FEiLgRHl+UGaO88qW7D2kz1ZLkOiT+c4qDFaXoDmq1Wt2hPD9B3SuRg+IjCpuTqmRbxLVbDTof7XZ+G0LutiDQGOyhem+LJzfOwT3Z1G1vFk9PCvnTuYMLPVlMBcLtt7zzMaAMNka3kj+cPDLYwS9ph2LtDg7Guwy81yin2ZSPtk1He/UxN6UFSiJaS/B5G5Hokxr/VdIytOrO+DFxzM+bR2CDoHB5MykA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uqkk7sZqf0EfatcYv++mLaKhXwlWDW9G4ibmu7Y7XmE=;
 b=jOCh4m3PZ0XyMjhqdgFFOJ+3r3sx7hPb6OLdxQFHbISAaCnMyHXFj/AVA+Z6sfkPPnN9lBfJ0h47qkUH4PITiQoW6kO1218mTiZqs7Ny84bTeGj9v9UGWNmifDMVYW/v5PVtR+OSwJ/sOPOS7gGwSDXzZ+ctjL+Me9ScgboSCVcslsM4H5GjMeh3Q1PtE8xIU7L1IEYrofmdwzZ37EIj4CMEE8dqJflgV81grJ80StXbjUxTfLvjc6R3m6vCxLRJcdqm91Ois29uqT0HqYA8frLUb/jULBqEHD1MdZ1m8Lc7pmIZinytIzApFgkywE9WkF7N0ZxZnnq+HUBBaLXhWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:29 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:29 +0000
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
Subject: [PATCH v2 11/14] iommu/amd: Fix typo of , instead of ;
Date: Thu, 29 Aug 2024 21:06:20 -0300
Message-ID: <11-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0490.namprd03.prod.outlook.com
 (2603:10b6:408:130::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6dc6c2-5c37-451c-1e8f-08dcc8879630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tYUBmjBkiYhlPxTPZNLWrJqFRLC4rYSqevJPFTvv+SsPNOmPUpF0/4gSLJN4?=
 =?us-ascii?Q?NvQtjWzU1Dj0aaeiU5dTKUWKPXa5h3zQ7p5l1LiYR/L4zzhJ+auePESI2Rzi?=
 =?us-ascii?Q?6VA5y8gRVf0nUZxhmr97E+oXQ0Ef3hsq9Pi6lit46eLD63O+XqplIICTZ+Vv?=
 =?us-ascii?Q?cnzQwh6+AiU82QcUH3uz2PC//BTlMJGOBxgrUT83hUKcjS6J/rPucTNjLj0z?=
 =?us-ascii?Q?38UW3292QPQUfU/lfY//OhsHlYsVPHUzMH2DBLi6IHSOsZ9fMJZJI42U06b4?=
 =?us-ascii?Q?SKES80foWVkDFoDXgLgUES1RdQJWfXANdMyLJq/Oz4wIDijmtYXO1krLr1Yn?=
 =?us-ascii?Q?49ICcWXhcMxo3a72hp1ARAuissmYR5PgVAUqxlwJzswpsB1fnrSGE5fq/5JL?=
 =?us-ascii?Q?gEQww2GtOxPwrQLcJPEz42HVuShAVlSaZOdyTCyRTa6Pq/8ogu8ook6NI40u?=
 =?us-ascii?Q?2vswnW3W0lZrXDhJEk3Fa2u3+aI9AzXObq5VYCSvQhSaSlftjdUbooM/149h?=
 =?us-ascii?Q?sD0k0JHEpSjSiO+QHMaY5RKSozpxfH+bl+4f9AwHdCEeiTzguG+3QUGukMbo?=
 =?us-ascii?Q?r3DdOE7Iqq4PEu+FQDof060CjVlLV169wkUd6fjB62eaJIDQDyb+MORmuYe3?=
 =?us-ascii?Q?ENbnhFxSHTVZfng4S3rw8S0mxZ8UfVPnztWa10IcVpmAYFz5+ThIryT7LEe7?=
 =?us-ascii?Q?YPDcxuHz2AGNo/RcaPQWPEeWAFno9lX3R49Ft60C6Z64ZC6Yjg2SwyF6LwZ+?=
 =?us-ascii?Q?jziVgL7UaRFZlOhZYThpiof4637/+m8XK2SzcJ6tNS8YiRLy1+s8DIR3MDlS?=
 =?us-ascii?Q?pbAywiSLqnNUGoOfEIgg1hprqKwEUZFvsTq5b5Ss7FhJNMUMobsG0HOG6r2V?=
 =?us-ascii?Q?NcNaBbLXuGfBKS+Zs+nNJVYMN3yWRd/oM5d+N+6o4XBbHlQfLIwkFS5Ari0/?=
 =?us-ascii?Q?Hmub8a+K2rZ3mclz/k63ICnSYvuXtJMbbCLj0IyUd9VFPrW92JJ+SKIopbO+?=
 =?us-ascii?Q?0vC0phuDFWSE9UMv8z9P97GDT37nRuPpxHYKJvOfjnCyQ1tF963lcbBm5JyB?=
 =?us-ascii?Q?pOvi2ifdfCv0dI0Nc5+4EhcoO2j7CrVa+4qQG4OudzCa4gxR01g4Jt4gqjHQ?=
 =?us-ascii?Q?62a2sdDxqF9z7WzcMkpe6BQ99DV8o7J7PZSy0Ywm61DfD86XykS9MsF3byx3?=
 =?us-ascii?Q?qOdOUnZdTG4V/214Iz7waM5hJ77+Y55STJTxSd7lgumVR/q88ozYKlV+3I8/?=
 =?us-ascii?Q?3HUbJPUIYSoLdqSvN/ZxBl3C2fgFIiDP5O96P1EoySXxP9pplRMfrCEv6lGU?=
 =?us-ascii?Q?kd6F5NawX06gEdR+VsVEeU6bShwneUnCaRU6IL5LZy6a0w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PigDGDmgpZOHim1PLHiExQU+8eNujNQ8IJtVG/0Lc2phzYXMYF+LIf0s4WHA?=
 =?us-ascii?Q?6ubZ0BQMaMxlXClVJ0wwZ3rl/4rHhZaUvavRqRqXwbdpSdI/8e0AZDcXRIwI?=
 =?us-ascii?Q?xKSk34K7H7WSDNlCOqgfELsvBrzbJo8QhW32RDMjyqC3nh2RssBc0YgOT07y?=
 =?us-ascii?Q?UkntUaEOi+QkMqxwraMX/ZYwOdX2qDYNTK+y46EzqhdBN6GMOV6H8xXfGfDV?=
 =?us-ascii?Q?Hrw9NtsUZscBbMx6VY0s/Sz6wxU3ycGcU/aKg0PdAWOK6JG5vS88iWo1Lij5?=
 =?us-ascii?Q?P9E7ELqloR3rFih0gAvUb9++2oXuIRum5DNdizOP9t2wZCbaamN2ld7+8TCf?=
 =?us-ascii?Q?TJIb8HbvDOyeW3EPE60SVBlaLgoQC8LCJlKwhSz/BvJ+BvHycNkVdpV5HpdO?=
 =?us-ascii?Q?7j2QifyA9fN4P6mtJrFf4/HeK8U/f83SesJiZD6FXIMPQmRxOcaVmRR4hmMI?=
 =?us-ascii?Q?PuIZqmiSp1mB+zQMFZzmg3jBp2GS6gbr2JVIwTNG8UyfUYA6V7zvTmJai9Z9?=
 =?us-ascii?Q?Z14wf5HSaxEvlZgKeBO6bFpmODT9zit3kz1lk+P3JelD1EjlA2sxu5ATJJ9M?=
 =?us-ascii?Q?KsoMRKSvcQ+tRYTsxUQlu6P35audqtopJ3zfPGNJam8GqiyIYiTVWs3mCgmn?=
 =?us-ascii?Q?tWBU6w/A+7Q2Zq1J8pJ+UmroHYEdK8/o9fFdsRpxRk52ovF+Z7ALoUCwQ/VE?=
 =?us-ascii?Q?FDkPa+c/lEEZJRKtYy9BOd91BWampIGQWUmk6L0UIEbgj3dYjMcLNAkxCsJo?=
 =?us-ascii?Q?sbMbkHS9AsI1ijnXIS88TV7R0whNrWcxwd6R2jubOB50JVN8Td8CFQKXAiej?=
 =?us-ascii?Q?V/2I8VqtR7q3ZgDw2vBp39jirWKglvu8vr+CtG2OItemGroxvu4htr2B2VWN?=
 =?us-ascii?Q?3V6e3ORx3MVYFil8SNtjAkNrfqli+mFCXPR7YmGWczASIY3GPasJj0JP2uxI?=
 =?us-ascii?Q?ABbZYsby1sKqn5lUgj3SlK6rRjiAOS490TKOWEFLEMyJWmg+XlfkEYgpZwQG?=
 =?us-ascii?Q?3sGRuvYZYKflat2zuyypd7Rg51TEga/4dEnj4+OYSv/5KsZm9miG4djhhuvv?=
 =?us-ascii?Q?SYIQCIKA0ElU0dfOKd0eEWwSHc6xjQNGVLWe9u1G6Lt/tnJyihVmua4bbbJb?=
 =?us-ascii?Q?61AOuMUpls4GjHhR57152B3vywQj7DJ6a4/UxJn2mCtE/PJ0iu1Ax96JGcAZ?=
 =?us-ascii?Q?S1HCPMz7ySMr3m7pZyLgKxfUnnafF8ZkZC8ylxOBa+XP/AzFY2nDEFf+S5mn?=
 =?us-ascii?Q?3htElV9Pbt/kR7zoquOcXQ+4y1XI9baLsAJCTNYGVC5Mpej3KxLV31i8NO28?=
 =?us-ascii?Q?F4rWj3XufbjWm0hH+oXx80kzWRS7jRox+HeuVYnxbZVQhQ1mnzYLP7/q5xcl?=
 =?us-ascii?Q?jL5PHFbFU8bfNccJfBX+VdC/TOuKq627JoruUyGPnNmmqlsmdHSJT0ODxNys?=
 =?us-ascii?Q?IWLV8XBFYjwbSY2PbSnEzEnX9pewRNu7Rk2dm/4vufXA4bSxnSZ7+mdCVhGT?=
 =?us-ascii?Q?E0nB7eBx+jfHttOqTLgeSpYnuc1j1HV/VRx9WrTUo0moFr0hZ7n02o8XrVFy?=
 =?us-ascii?Q?pBExsKpQO0CIpVKr3DWhTqi3pofl571583gK9/Bs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6dc6c2-5c37-451c-1e8f-08dcc8879630
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYTjdEvZJcjFSgHxzRS0j+6iWOUDD5nGQJqVmepm08/cg+dOrKlUi8DTBrecpqm/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

Generates the same code, but is not the expected C style.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable_v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index ed2c1faae6d580..910fe1879f3e41 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -375,9 +375,9 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	pgtable->pgtbl.ops.unmap_pages  = iommu_v2_unmap_pages;
 	pgtable->pgtbl.ops.iova_to_phys = iommu_v2_iova_to_phys;
 
-	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2,
-	cfg->ias           = ias,
-	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE,
+	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
+	cfg->ias           = ias;
+	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE;
 	cfg->tlb           = &v2_flush_ops;
 
 	return &pgtable->pgtbl;
-- 
2.46.0

