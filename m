Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCD34D4E8;
	Tue,  6 Jan 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767727340; cv=fail; b=hxJokWHUxXWgJ1rEioARYY5DtKfovfxMQiYMYeb4d/9tU8lSVP3Pj+TKgIzNmN6/zsyMTDUpFMYjmYakSG/lb8FvgWFqPAQQUrIcGOXLrhXBc3wsmh4K3L1OllUgU+GaYnRfQnhIyIBlJk2iLaWIj+76XL+L/h4I9LV7/SfTYS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767727340; c=relaxed/simple;
	bh=EGjTeWsXKzwYe8ZbIGFtBzE6i8zAi6oJgvw9nQL16kg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nuUCB4gbQIj4exJ4HN+nC2Ry16jcUpvGSdZYSRCwaihfQxY+Y+twwmvq5LcJRQAwtA6NubS7JTjCEbYoJyHIeeNr47tItwxocrQY6vd55M+nl74MmpOJaQzLUSmu4kdvNjSZphsv0Y9Qjlp8aR1fBn5v9Ci5d1xlZSwaEOp/qCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YYTf+dAc; arc=fail smtp.client-ip=52.101.201.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YYTf+dAc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wp0Ewi1UaH8JcQl8J2CHDA/u84UFoKiKGyFa7CvVEduznk1eypTVC2Aa7aUcUrA28+CuMD6W/E0QUCffVJ/shIwpeNgOMlB96dD73+X2aRbe15qJISrrzqqv1yhZZI/DumHioWfPIGfpLRQvs6uyQSNri4Wi1hVPp79uLtjs/Dv2t/VbX2IIxq6eVTO2b6IoD4z92P0/CUVs9+HF6+uBs9b9xCSPg7iiUEqK21sV3v8qsCH33gaE03J94pwK9cD9bp1i6EWbUChESk8kSCygBafV0OmxjIvHSQjJLjAQiWxVzV2BXzq2V8Dq7rfFRNLThHwSbVUs8ukr6rPkMrgO6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=euE2lFQYIs+5QAZcJ6QERVJnjMsGNBUFJl3bDIe7LrM=;
 b=o7fQIjfWJISkAQm1CeoQy5h2gOWe/UB4PCtV3DZ7W6v+TOOo+Q0tiLQj10VCnvZw5kg6LtjSxZ1ZYGrymx+kaeA1m8J0me5kS77Dmftd3+npXzGJ3JhN74HacLJj8qhy5OqD0ONmY+iPgUEwXLLHMKhD2V3Y4es9EJ7LHbfwQWE+fNd8k8fkhvqfwkBDZHmUfTgnAHsbOy1lI8XhnWkzmbh3zTekr/lXYtNKvAgOunqHxXf4pNCS96rd6OurgljEl8obF7+xhvoFIpNwbIVaLO7sfLQIBsNErUj9hEko1QSzKm3P4J0PQidebLIpRDsxxF/C5e7qa8PynsFzfUsukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euE2lFQYIs+5QAZcJ6QERVJnjMsGNBUFJl3bDIe7LrM=;
 b=YYTf+dAc4zsrXP+6Oi5odFQQn5E+oZqNS4FWlLEQ3fmguMQnaFfgM61dSG6rEu0XK2FpJ5Q6tObHhiiv9NMEHAejxZToJCSKmLhv8C2tBjktEzN6GAuXur/z3MoSIk6S4ZBIoqEgWtF18AENWlN01ofqKv9Sprk+nwTkbphF4bneps22WJDqy3lTfjkYbkQSSBKfH4J874ag5EUzh2Gm5xLyL+c0MOwvMXSohLCaaMmcppgaWXsEDSHudsdDrigcANBuVlwj+CFS5pD7eD+JKleONDqNni2sl7aWabV+KJoAAmdebKgxQ3T8EKREeR5iG4jEqD6MQU+r8lZgVUSjrg==
Received: from IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22)
 by SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:15 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 19:22:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 19:22:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH rc 0/3] Fix some kconfig related issues with iommu pt
Date: Tue,  6 Jan 2026 15:22:09 -0400
Message-ID: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:52c::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|IA1PR12MB6209:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: 212e7ffe-6b08-4b6f-a5ef-08de4d58e543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T27xku28vS5G2zuOsbR5/FyHG6gAx5XLEueqcHF958Otzs4e/17KLxvjg0zo?=
 =?us-ascii?Q?3ZWUT2Kf/uprzzJSUYR2S6jzhKSM+pOWvC6B4REgnHG+ilxGg/PiJfl4642N?=
 =?us-ascii?Q?sELsnXQh6xOu4Gm8IpVRXgEAXejMxIVgKSqGvWJpyNYY/zOv7o+Hbmlv406I?=
 =?us-ascii?Q?n4CH43O55ApY+pmOmrZtC5Uj/VF/T8QEyI2L/QYDrp5Yz2a9zhZFvbnDSyJc?=
 =?us-ascii?Q?DYZVb6F6VCz+rDmgXJ+gwCjFq/4iBhQK38rqIgrwyTSbq/YSzSATXlL3tUcq?=
 =?us-ascii?Q?GRLgY7LdDELbJJMe0FN9/hVp4T+8lumJDnmkswJXosQu8hn8jUF+4wQNwfYI?=
 =?us-ascii?Q?5+u6I3pV+xaU2GWIKkLjuwuYGC/97zZQO+Rrj3+rjUXwJzqajBZRydM4odTZ?=
 =?us-ascii?Q?Rzyn+LIw8LsQNw+DTBYG8hrFtGQ9c6YXaHYUdpT8ml6VtEiP3vlss2ePLdij?=
 =?us-ascii?Q?OKLCbOawe1+vDXJRrq48AUeVQ0ZUaaOmqjsHWkEFdAbS5HLmaN2LZB1xzU6t?=
 =?us-ascii?Q?k4t9T94ZpuzRznkqprlwe/wdeHrpR/W2bc/QWjIFKfsbb5aXDvMu757DldQD?=
 =?us-ascii?Q?K32uWxMERFggp3XJGTERiXMP+b/WxJwQBhMTcbTNq/Ps5e2QjvOHow5GJ4s1?=
 =?us-ascii?Q?sQT9e9a7jWrn5vXJQJy5HyZcd/CYBrFGAagRvEpDQSID+8/bbiqucyT9GTbK?=
 =?us-ascii?Q?uf6com551PEFejGybG88YHXZg3YZ37nFHgWKtS7NODojuDRd5ntDrR1YPyCo?=
 =?us-ascii?Q?iGUJQmp4X92tSOFaVTz1Vns5uZLfVePz9fx+FxJpR5DtrO83q0rdzHqMzyPU?=
 =?us-ascii?Q?9dNYK9R7bmfZjkidaQYFxNM0pb9LLjom0m6G84UHNi5/7aD+/U0spiGLz4iW?=
 =?us-ascii?Q?HKcOoltRO0x+2U+z6gPQaNyXW+r+ZvMGv7LvvkcKoFzyTwK3hLjox7cUinB9?=
 =?us-ascii?Q?Xoiufd9txfK1V8lmObPEquKBD5VZlZteNMyhJeoiByRtLU+0JnNnFoytSB9j?=
 =?us-ascii?Q?EEGKdXV3dFyo7u67kNTHoRMKajwzp8G4kBtiZ9LLgJhW1ZBTW9E5XwrDNF3H?=
 =?us-ascii?Q?/KtI2X+/ftk63cfDRz08vqsgKry3r/wB9/CrP0obLi3Ten5B9lsSgGEgKHll?=
 =?us-ascii?Q?PaL/IKFFuFjPRHaCFrEKxtTEnGsMRm3J+G0ynCer3Kg9iNyngjpqOxXyOANP?=
 =?us-ascii?Q?9rPp3/H19Zha1705WqvxpskivgkmYKNJv+cH7PT3Qvz9dzcRASHlz4kOuuTH?=
 =?us-ascii?Q?yAWY5qMcm6VBbNkRqVM4IXya3y7mNzEcDQbSeNZJF4qMEzRAb9IK3RrUSrsD?=
 =?us-ascii?Q?CpgVXFfg0BPfiqlqtKuK+DVgWUJdyNWx/1mgDZsclU1VEsoEkI6viR7wryKY?=
 =?us-ascii?Q?hPqv5RK0NHsptIJ50LbVje80yO+biJe14vvHPyRneh2/lApezi+wrvUBNUvw?=
 =?us-ascii?Q?pWvMjXjTb+/+/EdZkF3dCODh/pktx4R2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E5xKrAe2c6/zma3483N+HqmM/U2vgosg4qLd7I9M0MOZT5BrB2eE2Re2hqbT?=
 =?us-ascii?Q?kEooVm6QxlMKlghJIdDbM7vmyC1IPX3BWtIzc/rW9s3UkbDOBDmd8wcOW0c3?=
 =?us-ascii?Q?Xp5+aETEmNn3baDGv7VG4QH1aLdCkm+EJ3C/fWPgPs9C9XiPw1EubuIkpQLB?=
 =?us-ascii?Q?H5dwb2ZLRPZ42Psuqv+VqO9JZik91XjJUxsioNGa2IbOCqBMUMwmmOJKc2bv?=
 =?us-ascii?Q?KTWIZB/QYGpSUd0KnyvJhheQ+BqH+Q5gvHjbYQF7QxI8vjoG/vutObgSas0G?=
 =?us-ascii?Q?yDTcEjn+rksMY1tqbkSO5gA5hmqyoNxwHQU7WTK48gx0Q3igyoTgnSTHDyKy?=
 =?us-ascii?Q?AgqTYshcWCT1j2zSM9cUFOujcwZRb0bxw/c5aNffSU20Jbo38WMXUnPIf6kJ?=
 =?us-ascii?Q?trgAf9MMXN4BcsMjkSfkKG6n6NiCAL/WCu18bSEZZgd0JHmCCS6cKDUlG/FC?=
 =?us-ascii?Q?KsoECZgQWZFJxhVYp/GrTxxsKrGcTMYs+vo7hH0cisOGFOM3Y3qQiEPyMLDo?=
 =?us-ascii?Q?LuYvacZYd7SmFbMLYDJN1NFCVdJjWGTpN6DrREr6Mf22JWS3+FDHaEFU/Y4f?=
 =?us-ascii?Q?+GjzKuGUG0a22RDTISziW/u8SLfJ9iDjGYa+0QIKpGEBrraiwqrqU+n3INRB?=
 =?us-ascii?Q?2OYBSlAbIJNjGfToaMKitdVtgtEqEjjVBL+5gX6LNhy0nkeKsKNzlgebdzfh?=
 =?us-ascii?Q?5jkr/qZpBLTL7/PcChu5+Mtq7HJxKLNdssXNfEE1jBuyz4AzdPwVp4Agfz6e?=
 =?us-ascii?Q?uzEBD8haeCUGdmqbufWBvp2AIh592mBdmcUTI7M1KSZ4Qe0o9aNSliGgtEGp?=
 =?us-ascii?Q?7xHIxnHjmonAtUAmG1/NO4WXMhLR8OJo/zJxEIr5mpFkJ3iiAnZ6Xkh++RJ5?=
 =?us-ascii?Q?O8by9pFYqmnhH3/n3nvzSv+vyJs1G7hAleosEgw3MxssBNhuVHo6B6X25lJS?=
 =?us-ascii?Q?bha1rA8foFDjuM6GAZ/noVRJTTQoedTM3HTOc8inPmPtWvLOQ4KwbDIM806w?=
 =?us-ascii?Q?aeHlVhP/44GSJ8RS77+cGDGlbBwTHC0IDUIQ7tAj/KBt0AtzzL+vpx+hheR1?=
 =?us-ascii?Q?g6J6tlk6UCx7b3hpFJh9A0io4PgSsIALu02msArj5h4UQmS2V8KgKQ/fMb3u?=
 =?us-ascii?Q?+WYJ6a96/UjL7hVa2zk4dnfcNf7EBdaD0GZLlvrA1aLDg95SmwjFYIXsFSHL?=
 =?us-ascii?Q?qQEDLT/FtDyqOirTZ5vAX0ndY5dzYIq76OH64RZiH7BgqFrYSYgxJoIKR2Mv?=
 =?us-ascii?Q?UwGiwdmdEijuerJtoUYLZBmaPHC0n2bjbMpIMGgVmwOyGs1idY2uJNWcSdin?=
 =?us-ascii?Q?DKM/bRl7C/2Go8e96QEsjivIa8vrW1RXfDdiwqHBtRyB/6Q8ys8WoZY4adNO?=
 =?us-ascii?Q?KxFOnZmCYEgx3E1qV5oxSTnXI4qPkSCDLJarJjahszdUzLpoH3/qXI8aXEPY?=
 =?us-ascii?Q?k/Xh7GfIF/rQCy0uey/WHLoMnqRCwbKRxfiioyP7wZlM8ZEg+Iw91m4KswuF?=
 =?us-ascii?Q?Cfj7E/CU6WGNxdJLQqwnyF7LDjkrHdCMsEFG9d1Yjp3xzsgoN+Tn5su3DPiS?=
 =?us-ascii?Q?nqqc9lzTC56g5R1Yq/bbEodaMa8An5rv9cQ/etCKTwzs8TTrLcksFMahWwwF?=
 =?us-ascii?Q?JrI79GhW5fFrPPBZiVkwqhanw2ppmiZCJhvy5EwjJyAzPeLb6uXgEgTkUP6L?=
 =?us-ascii?Q?TdRucHvFEKXNGBddQh376lXa3MYJR8wp1yGpT9DDqfzWTrn9NNVPfPry4sJ3?=
 =?us-ascii?Q?+v+8kF5z5w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212e7ffe-6b08-4b6f-a5ef-08de4d58e543
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 19:22:13.5672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SR2LwzcHFpiqKzQHuviVzuqVFF/HuZQnMm3gfbMXbk62T9W6Sz6PYiL7WMAqhJK3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847

Two issues found while checking the kunit against rc4, and one from some
build bots.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (3):
  iommupt: Fix the kunit building
  iommufd/selftest: Add missing kconfig for DMA_SHARED_BUFFER
  iommufd/selftest: Prevent module/builtin conflicts in kconfig

 drivers/iommu/generic_pt/.kunitconfig | 2 +-
 drivers/iommu/iommufd/Kconfig         | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.43.0

