Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59AA2572;
	Fri, 30 Aug 2024 00:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976403; cv=fail; b=UXYWBSgLdyC0yIh2mdtDWctVmq53kFFRyGp0SV2kF3m3y4fdEsyR5PMHoH+YrOQgDsdz62aQ52av3/InBuaVkRDiDzi6c0KNJevylb7Ij2WlQNGPrj2lqxtTFgsrZFcViFfxlsZMRJ6oGioPWcCmPAhINFS1UGqBaze198QDXz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976403; c=relaxed/simple;
	bh=1BMnfhKumEaWQ2yungDrq4gycSsmOfK87D/e0dAGsE0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SNnDhbkM/EGINZ3mGGJA+4do6IqwYY090/2L0zNeh1hFHMh79po1Er+QXdQWosl61INC/Rl+R1dXe+Nf2N353dcfFkqhiHRKSpn4xTmGnssaKZMQqJbLrD7PtCyCeJ/1gDFjeQW46pEz9B/N5Dih2JsFKcPcMeHUqq79q9F+VUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=meAsGaPG; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="meAsGaPG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMe/ydeCQubIEwqM0gz20swsmRfUuT0LBLPPULXfhWoDpX0VhvelV7V8y+IG8ThPjSk/nOYFBq7jIgunDA/95NqLclVcavhLG4AofOY+iHxNfutaxgIGC4x7O/OCdGLsLh5tlTyPxZReuusxso5wjxB2gRk86ZGEurA/2sv9Bft7aPQrHHavjCmimXVLFJo+Q/DhTvdfD85BedvuYKqUvHuY830++NiTKSxygRf1kUnk/2ZV39EmQMlOK9RDYxRcIF2Pq8HDKD2dpmLv0vPmlxyz/RZtvWz8A2adFqViUvd603QRtAbnvve1BRIngKYYEMBHKY8IkfynEQ7yIh0vxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obx0IgeGQ/bnRDJ+cD31vfPq0gJUU2nYmIDwt+F0tJM=;
 b=xECbwiY9ORbmJmST0j+WsDpEfsEhI/t/MH5gGCWkIyobr/0qz5sIvlqKAdUMDQMQGlkpYFqz0ivdnBrU41gLyqDspQvcpamFxHTm2t4WJCP4TLDXDOD+DWOeysly+R9qYR1KtG4636qzHt3ad8KKH8jJJNa4Tlx+4sNKyQepi+Pdb3CKK/7v8C10RVNki/IUIpp0Qb9/8M06jJ0FMXpNHcwDItwtZF9OQng3KjFpbzzjXYIx5j4VAz9Bxb5ThGYGWYVqzBhqQKv2nJqSstFVY5zNix81d7prrf+ugHiv85nJTk5TuXYrAKCSROOM28iASC3HpcFihU859SMEpRBs/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obx0IgeGQ/bnRDJ+cD31vfPq0gJUU2nYmIDwt+F0tJM=;
 b=meAsGaPGQuc06zMQb3nIddwVP+qFiBBBHuoyJcp3ebMmuodEyZi8dS6x/oMTJz1YD4DdGulHuzi45Tm83Rp3VnQN+BnQRih5U+HLZTuZXj7TGR/Xpm5wUQDrvfmK6YVgMtmgg77stlZq2mKm8bt9eUwKVUyIWpBDNU/gnf/Xb8AUcFLGzhLzoQqocE4cLY17NqGpwCZ0eMa5Z4eBF0kwcAJ1fdYBFlCYpqa3Kyj5eMbehOHtZXex3b8goTjxaYHx5v5pbeJz7su5KG9NKh36Z8b6xT0U4OSvBR4NE/y7f9kwvfKWbQviMml33RGvgWlVhlEcPwwkk4IY2k59ne4VHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:32 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:32 +0000
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
Subject: [PATCH v2 00/14] Minor fixups and refactorings for AMD's io-pgtable code
Date: Thu, 29 Aug 2024 21:06:09 -0300
Message-ID: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0926.namprd03.prod.outlook.com
 (2603:10b6:408:107::31) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: c64d8f28-0472-47f1-cf9c-08dcc88796ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1QQjgtDovpaN8XWerYBeOAycu3++cMoPsVp8uwgDPrZeb3H2FHUSuXXbIERY?=
 =?us-ascii?Q?avh9G1tibidVzNMbA23A1Rqe/EUQ5n3HxT9g2nOXrmSO7sb2HS7LA7/WkDEJ?=
 =?us-ascii?Q?0ezpnPvDf0CuL6SStbVaXO9vivzPA9D6PYHDiCdwX7JNtckO4/IOigexjIRH?=
 =?us-ascii?Q?5KlhTK0VQR1FWF7wUTtRkzFwtmjRIHtmAnhFho1nO18Ge1PbLzIc0hFgU26h?=
 =?us-ascii?Q?2R7JHLZ5wmYgSmJBXLWHjgK2uklxJcmZTMtNAvxhpaCQjBs2m7W1G/vwu152?=
 =?us-ascii?Q?QgNL8FWpIXVzU5zzjsifb++j2wmoIEaBLILl2BLNSd5F4PKVbHEd9Vc0LvqT?=
 =?us-ascii?Q?ieSJ7MiUjZw/9O/Jl7Ov5mIicuA/tQmV+3+7HPr6y8NPDBvj7VKDb4AT/o0v?=
 =?us-ascii?Q?c4HNR1ILdVKvTb0joMCYmQb1DO42tQmNkZxNDNuHB4ewIuIa7X4EHJ3O3TAY?=
 =?us-ascii?Q?Wq+Oo5dOYjsaxoGbSpx4p2BHOsT1yYqBwresupzlKq3ZNLsmShmOTxaPr5ja?=
 =?us-ascii?Q?lZ+KtOLglqSTSnN+/lEfR6s+FjVGujIhtEQAEos4hcVSHFo1cdJi59ePvf8D?=
 =?us-ascii?Q?U5bYlsIA+fdWCJrSgDWe5IaUOsv3UnX8N1txkqzxW6EOIcnJX7rHNCxhCB0j?=
 =?us-ascii?Q?MS6JAgOfH83YcLRc7gFWAZakJEIaDZ8PjIqqocDeGZfEG0Lydk9A8URcvf6g?=
 =?us-ascii?Q?BIOxDEFOgfz2bXhGgx/QmKs4fiDU3zSSVew5dgvcjzrneWFJLDHXH0ETTmhG?=
 =?us-ascii?Q?xYaFV79nh93L3d38GUg4JTEukgR1zfrvWuIT0z7+uDZwxbWxxwQjf+Xm+9c7?=
 =?us-ascii?Q?WDKrp651/RMRS4esvFALo/pKPYJyqt8W6yUOW+3m7E1APfo9juBRBDuMJ01d?=
 =?us-ascii?Q?sFUkoz1v8m75gwH0OIhYZhkn3EcwJ7GihGdwSts7gbB9QA/TGHonIvLdKCXO?=
 =?us-ascii?Q?fy/Isz7AgSf4sy/CtQIXt6q+NZA8/fX1A8BvyatJnOb/d2s3c7M/UueaPG/0?=
 =?us-ascii?Q?e1ortk+QtG9+Ef/83JvZCUwa0RYivu0c8Kx1iPF450woGtWuojBIYUbsNRpj?=
 =?us-ascii?Q?9e0MM+r6j0K7gG8lUENHuyq/YT9NF0GnbVqd4ekWZTQKqkokYG42A7xHG9oU?=
 =?us-ascii?Q?Zld5lCzAP9ahS8rqbkjs0laX8qbaDgpCD7BUuDtyK1+vTHMncOFlrmK66Jyh?=
 =?us-ascii?Q?FjGXH3mKtnkLCSds06DZtZXIvmpo42p3nN0j/6IibhvyOQTvbhpEX7U0aJY7?=
 =?us-ascii?Q?Z2LKD3l+lnTZEGuY/jFZo31LD8gIi1k/t06mvWuAXuRx+8FOwkc4IiRZNhNa?=
 =?us-ascii?Q?XWo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X9nYFem0lmDGm7nDw7VrKZs5/6ejimxN5UHcJo8fVh29b7V2veJIqKaFDmGS?=
 =?us-ascii?Q?6Ylc3eS7kDrmmdsviPIthazbJnLVILaTJ7SKfBq3YYW7AWt7F7RCU44tgFJo?=
 =?us-ascii?Q?48tiwupMLhbKPRgZ75G5RWwJ1zMciDZSgAa4kTJaAKB0EFf4J+2hPe8ua/47?=
 =?us-ascii?Q?6NpA1APd88I6bZywkz9o9SivrQg9UqzTppTTnyT2p+yYhN9cVhdf3IO3DuG5?=
 =?us-ascii?Q?KxWFzA7k2HJ2nCop73VB0Be5qOKo5NOz1nRGKHhd9iGEsP0CA6XeXxLW1+Zl?=
 =?us-ascii?Q?HKHX5UmRD+p5m8THsqIZKQFtFzEJrxNvYF/VBsVFJhAkUrRBDL7ywjkd9RS0?=
 =?us-ascii?Q?5nEkfflLgCtu2TbeEVTvdm8U6y/4kX8syFcWSYgB1FhdDyBCFK2bdRkYXUR7?=
 =?us-ascii?Q?TRt5K8cOP3eWxyPOSUj6bkF4XK9zXeUV6JH89Gyc8EL9c5vN42yhMgk0WYvt?=
 =?us-ascii?Q?duRUu9iaNHbvV488ELZaZGgO3GeWI1yw3TtWeFjE9DGykzD65PZIPfFZyKUz?=
 =?us-ascii?Q?dyCxV0tC2YeoK/Kl36HnZBTrgxc0LpRCgj/h+QYXhWB3fUvmD5SH0HTyTI7t?=
 =?us-ascii?Q?3+5+RS3cwxSXnEdwh1/AWqLInuz10D9WJRmhdDCfA/sp23dw+3n04Bele4il?=
 =?us-ascii?Q?xm+PIajw5AGV0WM6KtOT/WcqKn8mDAABc3E1b62RX0qmPNCt2US6pHP5zAhA?=
 =?us-ascii?Q?tgJ68ta/3dl4wYM4rOZZXU2MSlFGPtK/EPA7QbT+ZE+ut6f03ggS6ejK+Nyz?=
 =?us-ascii?Q?dt1w41soqzoF5mqLLeXFx1fdy9lDTOuIwkDSSdAkwPpPEMT2w7nPoRP7b17A?=
 =?us-ascii?Q?+z1ekAs2yLFvXOA/KIeQtcDe3RnDnTIxGnkh0UfnbSpQp6dU5fIUD8xULZ19?=
 =?us-ascii?Q?oOf/QocglGWR309nq/klMClM3nGcuteiENOB0vayMqxZJqjs66Q8tKxjDdaZ?=
 =?us-ascii?Q?6RsZucBhfbHp11JcDBfaiXW3naTijgAzMDcLz+6vVy+fkt+HzDdzWvyUskMX?=
 =?us-ascii?Q?XIAHhQvkixVYsOnxqUFJnhhtjUmC+dloq2lQQ4Uqx0yJT6sZQ2jFLZH6ixvU?=
 =?us-ascii?Q?/ZknyW5WN3oEKpUfDI5DQT3qmhP1CKsCVRzDPMYq4BQNrPnQBW95Q3YWLC75?=
 =?us-ascii?Q?6tp1VEmmbSwfUw2GhrKE+WOACuwqaDqL6cBIgm3sB2ytXPIOi8mvGstyt7u/?=
 =?us-ascii?Q?BwyXWdfrJThZZ6F7/szo67O0swOHSlea1nWpTUGHncG0XPm6uOF+QtwMgNIk?=
 =?us-ascii?Q?WR3byRA3+AF4XQd9SAIpYBnS3LA1zENcjsrc+zS3cl2kPdqyqHfbNm0kIrwq?=
 =?us-ascii?Q?Bp40cWUdNhp3YQlgsl9f3xhTW2/vtQeNLFaD4sz5BeEaWMnWz0WDLQKmkoiZ?=
 =?us-ascii?Q?Rtk72iFmO7kB/5tWHl+8rYCJc4BRBtOzRWoYxEA4exbMPboly4GrOAy8Xgvc?=
 =?us-ascii?Q?XVIZCABxyxZ2e6BLp978vFTPp5F/mLmrx8Ak7x24CcONhMFuGa3Yh8YKwKqf?=
 =?us-ascii?Q?X2JOxSx1+7QZ1W0tFOAg+8N4Dm/csVfXuVQYOXkvzcZlfYuRMXbSOSaupNBZ?=
 =?us-ascii?Q?m1y6JV3dBwtcJyYd+00R0nHStqOuiUJHam2W5+PD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64d8f28-0472-47f1-cf9c-08dcc88796ea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:25.8923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAFJ7WQLyjcsRQaHeCuO39UwmGWXQGd77v57UIRA625o9gg+aK0y64W4VgjsMfMO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

This is some preparation for the Generic PT work here:

 https://patch.msgid.link/r/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com

Where this aims to increase the separation between the page table code and
the rest of the driver. Ideally the io_pgtable layer should be completely
self contained and not reach out into the IOMMU driver's
iommu_domain. This doesn't fully get there, but it does enough for now.

v2:
 - Add local 'cfg' variables to improve readability
v1: https://patch.msgid.link/r/0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com

Jason Gunthorpe (14):
  iommu/amd: Move allocation of the top table into v1_alloc_pgtable
  iommu/amd: Allocate the page table root using GFP_KERNEL
  iommu/amd: Set the pgsize_bitmap correctly
  iommu/amd: Remove amd_iommu_domain_update() from page table freeing
  iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
  iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
  iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
  iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
  iommu/amd: Narrow the use of struct protection_domain to invalidation
  iommu/amd: Remove conditions from domain free paths
  iommu/amd: Fix typo of , instead of ;
  iommu/amd: Remove the confusing dummy iommu_flush_ops tlb ops
  iommu/amd: Correct the reported page sizes from the V1 table
  iommu/amd: Do not set the D bit on AMD v2 table entries

 drivers/iommu/amd/amd_iommu.h       |  15 +---
 drivers/iommu/amd/amd_iommu_types.h |  11 ++-
 drivers/iommu/amd/io_pgtable.c      | 102 +++++++++-------------------
 drivers/iommu/amd/io_pgtable_v2.c   |  56 +++++----------
 drivers/iommu/amd/iommu.c           |  97 ++++++++------------------
 drivers/iommu/amd/pasid.c           |   2 +-
 include/linux/io-pgtable.h          |   4 ++
 7 files changed, 88 insertions(+), 199 deletions(-)


base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
-- 
2.46.0

