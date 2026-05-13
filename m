Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADABE3CE099;
	Wed, 13 May 2026 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716681; cv=fail; b=I7G+5w5Up0kgyTWQV8wATb2Gv7jL9tISDh07WO/YOR3ASge77LuwEO6ogCuF9k17DVkbNtN2k6f1rny91F/ShZ2IJS15J6FuzCX+C7K/vxpKqMw96R9KAvZ0N65EuSKwQRyGAwc5mH3SqkCOj3XR7QYee7+KxBQK2iP39g2KuAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716681; c=relaxed/simple;
	bh=cY6u/IVVW7TuN7sLknACWj1NeORofULBJnSc1czE9WY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PE4j2bHtp+QuVq4MbSoZv/zuoVxevq31/oQUIIBqSRMAWMkzxmluAhG55psm05NoaBHBI2uD4ywk9gt3KmGV2SLVMlP1dWKCkFrUAVPqzwsZcBCtuGCS5QW1hsDitFXu+g7EQMgiDXi7pTcVA/psVwysCHwnhSBJvEoB3Fc8VvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hpvHwdsS; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hpvHwdsS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIZ5YmIeEIYxCRBvYa5XNScFrFc2iZKDMwtNepvOcSxfT4Kessp8LkXQMyJMQsLINE4FFyTsvOuMNl9Xfh3BWG9oH4qVgE5IxZ7tFLVil3FA2tlb8k5VfueODxfMoB2FGB3twZHdfWjBZC612au3aErVunMYvK9UStw3V6KBxTTTiZeIYLNoooqgXXaqH6iyQPkIlkT7YBXOs5nUBS62vxdF6Hc+awEQBJgjrF+0Ke2UUrsp4oJMz3RZxk+fk2lzWlQyOgNd/0o+GxYoKtt/4UY85VwvNGC7lvi0rcM9RMwz4hAWpOAqejaWneO10iD6cbC0QWmKbiVOx5RDQ+huAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3lwBRCxuV07iXhnLZC8LwKTzh3R+sfRjw7ri3JaQg8=;
 b=sfDVP19P15CivV3hFkacBHn5yFycMr9vAMTOhqATCKpXMvdWo0lmxNwFVUpkZYis6cjhfTzmNfPKCNPL+Z1Fzv9/fwmJw0aNIE1hnNsRkAZkCJVFmLqpI4A2NAZsZu2GbkQrpdAfAexZgrP2DQL9rfenr0qGLlERIaV9YXC5wFWpZvQdObKY1ZhEQubz8eNPfu8gzwePeTevo7qmwGOFa/vY9Hpb7wqzNhM0YMVnkL877deJPQ/USfGtJ69lFieX65lFGknvcAVpSvG3CjYcZLA7WbrHTFKht5zgcIj7WvzvCCL17KS4mIeDsujR9rn0u+3EUFWkuACfDESUWMzqQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3lwBRCxuV07iXhnLZC8LwKTzh3R+sfRjw7ri3JaQg8=;
 b=hpvHwdsSgfKPN6UFIqd7TZhSj5XJjzHmRNQ2ZktUGoa2tgdDjKiUchsX2cTe79Yr0LRm/nCWPTpTqaFpOubOVhFtlS0ddkKgv7Y+lMyJDiNifJuxwhnq4KOsihydVlFk645kCKGQwkoN34acPiWd42FszhMnN7QSqZDUUTq12GxQh9rOFbBOQlxOrZ1g9y4xIpD0XoIirEfn8T5zlWfTlIN84KqU5+nHqk+8klzzc8sMnjGJqF5mXkNOadgyVg+888U05o2SUUHMoqRUMOD132tgE31tZoCRivAAmUthwxSGSjWTMdjw7CyJ6py9M+iQA1R9A03Akn9bO2Qee5aRWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 23:57:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:57:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 0/9] Remove SMMUv3 struct arm_smmu_cmdq_ent
Date: Wed, 13 May 2026 20:57:39 -0300
Message-ID: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0091.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb52087-7783-4401-eb3c-08deb14b70c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|56012099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	2VHif5c6qzSAuHZX1OGhdYCAlsw0LWLQuE4txO27uzh0F/gAHX44y61gPE7neNbKBP4+vAmP2aT+N/pCDBHseJ+1ZT2sREg/+TgZ2dP3BcJ5ce8AGphSzN/QO2pGW31PwDNdoQsTEG5iS1O+D5utC1Um+kwsadHPsgdZMS/K31Uu7xOWUBAE41F3ET5yDzc8BKcWCBgP9GZ+LTHTSWkssNencsirlQkjTCwdSR01M2bRXVNUCJYvg76DPyd0x9jSYk4nlKUSnPXZqwk9WDs2L9omhTWLaBsscQkjReQsLeyLyEiNH1sOeUYlufUaEBCzrKLTqaefWbynSSv0cwoT7v6+4QZ4v9OTvV85ffoWN5a8FfpP2BEI8GMBv1eS4qxESY/TEN3ifGLUYYj2XkpQW+Ur0j5Vrnek5AHn1aodipx9mNWPuGnAF6fC1W+gNi/ISfbLWqj3p73tPvMXjzNU3i4GKSl96GAlI6SRafs/AkZhg5gGCevtWKFDitOzzmWvzHd9WgHow4krni7H23xrexzU2jMCJWp/vhLB90iR+umTvKDwG3ijSisxkgzdB2RW6MVrEZB+dP1fMhQZOQOjbFm6eqGwdemrq7CGUS8Fm5Sx3XcrOy/UrgbdTDytPvijp/5+sp24OKpKbRQ6ISAr9Z0bEzn/ehh7oDsfvDMp9ovfYH5J3AKzQwvI1hSJmMf0IuxGhzZj5gu3ZX+sL62/HA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(56012099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?79iRDDTHH1XiIOLliCqicG1OS7ktQ1yHb4FBv//SgkoTOWTw3hY4wpcgEywE?=
 =?us-ascii?Q?J4Vtw7bSpwAwwTgqjiPafevqw9HOJ9QhNp7ZPFEiX4DBlTeU40dw/zZ/klsL?=
 =?us-ascii?Q?6PPY0wFHhf65GMfj+V8C34kYt6s1Hb6GSL41dPR/UG1nXDpZbM2q7LE7jrrV?=
 =?us-ascii?Q?MN+3HfcWrVwk/rfMAIlBZHvfTet+LIW7C/PydRvEpPPk2sMM8qhRTnhJ73Fv?=
 =?us-ascii?Q?MzZImvEHDJhsqTGEgJbquCl5a4dYM5JB2yr9ktN+m0M6wqOQFCyCMbPycsgH?=
 =?us-ascii?Q?bYZpQD97ZNDeoIADkCNkPvASq5S44bnUE744BWARQFdVv+IZBVzuWoxTRJPy?=
 =?us-ascii?Q?2HrQJ+ESnHYohhD86Kr8Q2VN45bCxhLL0gY6wjYs7mn+lFLSDYSBFYSLvC0t?=
 =?us-ascii?Q?eJBHtCrkXkdwnBmlX2KO4nzaQqQBHpvU9HOgVyvaGCqcgrrLvyqbZpHIx7H8?=
 =?us-ascii?Q?IuU2ia/5UxZO8+5J9zImn3CGJHmle5Agmm6waCcaJ3itphzbM0k5ZFm+ATjI?=
 =?us-ascii?Q?pEj2lksxcPN0221Y/9+VXd+o0pG5nxUwr7YcgdFkMlnJg2qbkVQYumS5xwXB?=
 =?us-ascii?Q?eI1va+JzxRmYFrHbfYph8fRtkBTUWAW/YcFtwBkCgjuwjMaxITxLQkTJ81FA?=
 =?us-ascii?Q?iixING8HFz8bL7tYDEi5bKSvE2NHewENNJgy2/VQBCVn2iF5HA83b5BoAlLG?=
 =?us-ascii?Q?NnAV/jM3CIK2fzOkusJM4QjdgpYA1aN2tBLldxrFwUus4NkHu9V+VTL+zRmq?=
 =?us-ascii?Q?E5Fxk4fntchMKytb/kNscyA6K+g48KQIvfRi6kFAUr/DCnQX0FQZZkgpHn0E?=
 =?us-ascii?Q?6mLwREPtQ0R+Q+nF74h64wzNt45ck3egxmDrObnxJPdWpW6c0YoxAUZPrC7S?=
 =?us-ascii?Q?fMpV5KncWka9YXbflYqhWaNk23ZbT4ZHCw0wMC05JueFyPFmlUm+lAsL90tL?=
 =?us-ascii?Q?jCGAI7992BwcRVbdhWW6+ufaA0ZnFJLartKyjVPjKND+CHLnrNTskZW4WixW?=
 =?us-ascii?Q?plC7sTib0iuxDxHbkTH7wD3sW3DjRbkAEK7NKKHtBtc3LQLyg8Z7QfSQ+ODM?=
 =?us-ascii?Q?U0WCNcQWZzw5FfJFbkGNr+0rqpdVuv195g9szz/M/mzp/Eit3TAsluuUhJ6s?=
 =?us-ascii?Q?C+eJHkbaCtDmLfPPQGPfFG950OdlEzp/lW15Q7iOPKflnqt8C/zdNmtBoUK6?=
 =?us-ascii?Q?zFfQzS7hbjhI/xj16+RLMjdGtZT9L/YHa7D/g3n5GgNKwx4D/I5t7aqCQr9c?=
 =?us-ascii?Q?pDjnm4Cdd5FFNJpXLMOnpLttv5WwBU5Uq1i+Nvp20a7TMmykkjD9m77E49Fm?=
 =?us-ascii?Q?HDI3gqBxChiZKPb0/FqHvp6RrrhpOu4oIBjyTEPBD17VQRaWfQ63HFCzR8ks?=
 =?us-ascii?Q?eBlypMiYIN9Uu65fGFMCR3e1hwpsOhn+A/TGgJBZnoPx0wW8ub9vg3/prkff?=
 =?us-ascii?Q?Ht656WXDPzZ/RoQkenFLI23vCbQaSXVX+untjBBz5GS279yLeTlGA/oH502N?=
 =?us-ascii?Q?H/ih15zqDKLAf7zcAZTgQN05oqt9q+eC56CVKFGXSEjR2iMHC7t1n2rdKeCw?=
 =?us-ascii?Q?t4dGZ+UwU4/6nXtRw7V2DgmMiJibx5nMvqodXW8QNNVbbs7DNEMrCcQJH846?=
 =?us-ascii?Q?UHmhxNRCXkb6XB7ycGDpjVteEgpvGUCGJry9XO4mUwf8iUBT7OVLKUbvuYXz?=
 =?us-ascii?Q?a5Jrloot/5ypQv+UmXL9bOKIQ/7kqmtEx4giondhkVECPtYm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb52087-7783-4401-eb3c-08deb14b70c7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:57:50.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFpQNTku+CWHfESGNJOOmpVpfd5RkO/GcG7siSsZ0l4Hvi7EPRKv0k+LMyE6pIAz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

[ This is part of the patch pile to move SMMUv3 over to the generic page
table:
1) Introduction of new gather items and RISCV usage
  https://patch.msgid.link/r/0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com
2) Remove SMMUv3 struct arm_smmu_cmdq_ent
3) Organize the SMMUv3 invalidation flow so iommupt can use it
4) Use the generic iommu page table for SMMUv3

The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

The invalidation logic has this multi-step process where it first
writes the command into a 32 byte struct arm_smmu_cmdq_ent, then it
calls a function which converts it into a 16 byte HW struct, and
sometimes it then edits the HW struct a little bit before passing it
off to the batch or submission functions.

Instead just generate the HW struct directly by moving the FIELD_PREP
blocks out of the big case statement and into helper functions. Call the
right function in all the places that were building arm_smmu_cmdq_ent.

Add a type for the CMDQ entry similar to the STE/CD types that wraps the
two u64s for clarity and use it everywhere.

This is intended to have no functional change. It makes the following
patches work better and removes a bunch of LOC. I've run several AI tools
with instruction to look for functional changes, which did find one subtle
mistake in PRI response.

The removal of arm_smmu_cmdq_build_cmd() also achieves what Mostafa is
doing in the pkvm series by making the command formation entirely header
based with the arm_smmu_make_cmd_*() mini inlines.

This series has no dependencies. Several people have already tested this
on various ARM systems along with the full iommupt conversion.

v2:
 - Collect tags and add a commit message note about ATS
v1: https://patch.msgid.link/r/0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Add struct arm_smmu_cmd to represent the HW format
    command
  iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq selection functions
  iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq submission
    functions
  iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds to struct
    arm_smmu_cmd
  iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from
    arm_smmu_cmdq_build_cmd()
  iommu/arm-smmu-v3: Directly encode simple commands
  iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
  iommu/arm-smmu-v3: Directly encode CMDQ_OP_SYNC
  iommu/arm-smmu-v3: Directly encode TLBI commands

 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  24 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 475 +++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 248 +++++----
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    |  16 +-
 4 files changed, 350 insertions(+), 413 deletions(-)


base-commit: d8fa633ffaf43316bc3ee8d7b21366cc92c02002
-- 
2.43.0

