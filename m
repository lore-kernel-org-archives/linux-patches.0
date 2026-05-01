Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011033.outbound.protection.outlook.com [40.93.194.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D153C7E16;
	Fri,  1 May 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645767; cv=fail; b=JEIu8P/IUAX+FeMnMKc/VB63pwF/OeARGxHrj3cviyVFxe6XxXpBl13zkO1aTwh4VK+4k0TAtwUTprGq0b5jkk/t+hpp1elBhl8ljqPOmQtz8P7IMdm/rPppdUVv8f2Qy5mDoLR9qIKAUc0WT51rm/k3TNs93nYhvx+hMdIS/dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645767; c=relaxed/simple;
	bh=mlVB1lh8Di0Vm8f1uVfqMF4ohDqj8UBnvS8j/IjkvrU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lVizeV4lJ4k71WRe9z1SuFTY/VC2wIuKTipEAiLrRltCIlA5am078FJtdRyve4S+d84J5cuf1JUp8D0P8GfV6PnbRvgLyNUWfPTRTPF5CBQefP9MXPdxveC4kpQo0feYNhQdNnkDlBizHwgzWR7Mq5AiYaZNZtVek9TpMx3p+Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hLbSTdzC; arc=fail smtp.client-ip=40.93.194.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hLbSTdzC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikGgzeZlGgsurNy4o/a48d4iLmqAMCwiXLMu7hITdwrS9BLYIy+BktzFFzczgLmnpTy90i9LX3AI47RI9tdvvU2EGAX5Kbw6Triif/AMwkpTTQFa0HtThYQTjKeFikSo5QSFXwz0FrTmOXtjJl8NldEg2LqxLWSz6li2Ytt1XeFX3tOi1sNp53PYDOUdWvDgfPK0UW/m0RIxr8pv3Dx8U0bkhft0Poi2LzJMIncyYuJQX8RhJPSJ7RAyC7ig3NIHPU671nhZpzD6zz0ug9awgign0Q63YE7/XNUBWdHvk+zjLIt9Lg2M8rNMXGFPSgHBjE5AZmJm961E0IxgeXWzmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vi+bqK+gyxquBk3DD4oW+hnyK5nYdwpBs0Gz3CWy/qU=;
 b=jX+ji0FWAmdvLk4HHzDGME5q3ZOjkFv4OjGp3GMIv3+LbrZnVinIqcDyV8FIUJ6bQ4yc41MKRG7EcaxZHyyKVUzSfD9BjGY83V17tQX9rQrQacFkjml3/YSpZW1JG3uYGzm2lp+rMDhvLu+BBCVzMInHh7bACZ7IRw5zmLXGxKrcbaPUELEfI7HAmP8bOxAUZ5fbS373jJBC3B0MYvV54ekKXs8bWAck2e9yZl2aCOIYLT9JTfuRf8CngSMS7Zdh5lRy52BRzyGqFqOB74zzXgsLSTxdPr7zgCS97SSRlWa7dZ3t58dQh7oB1TkdSd2PmWFlKKYvtzY1x9Ynr5CbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vi+bqK+gyxquBk3DD4oW+hnyK5nYdwpBs0Gz3CWy/qU=;
 b=hLbSTdzCCgT28GDenjI9MG/1J0SM/9BbBHQ0pdR7qgsOJ8wByckIYYBt4QXKQTjznXuLiktqb6ZKhWKgSOoRU5SSqrCFMnnpgcGx1LvtDjIUYM6XdEqg0JWyDSaGiT8k+u6W6V2Dkvhf9RJWZ/ssVOHZRWLpdYDtAJswZoJc0U5CO1/hyVsBl6vbwqD5HlAlv2v3el8pEmzpwppJ9cVkm0BlphWADGLEJxHiTV+jb6G2q4LqzeOi/Sc0OwwVQtQlVDxLLRMHVtXmnztqQY6nPqgxly+8oiY/Y8QKlGEzTtkKzB1ZyUhl1w1xsZry2JoTTYXmZQj+C4JAvhautbpWVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV3PR12MB9216.namprd12.prod.outlook.com (2603:10b6:408:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 14:29:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:19 +0000
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
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 0/9] Remove SMMUv3 struct arm_smmu_cmdq_ent
Date: Fri,  1 May 2026 11:29:09 -0300
Message-ID: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV3PR12MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: 891723f5-d8fe-4c15-7a73-08dea78e07b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	r7x8c7IxduBNz7tmU4FNIiFXd6wltZeLF5eNyXtCKjO9n2r8CTWOwz2Pj2Bwov86TMhbx/pvAwCMf7J2JMa1skKFdWtozN2vUU7eXvzKvg3tDSDjsxAPzPSIjSONKXdo6HeWXzAsV53l7WKK59/VoveTM+XZNNuFyi8T7iQaYvFaUhAfR3o8ekVqrc+q6nnFSY7nlHCUqTiFxddgkFWZpyOGJhVb3y8jRtD/NK6N3YT5ctPn9kcjF823RIUU3V/VajXevev+RJwM8YGuBLXVAdjuuRzsQi8PaTsAGEh8bLxUPiz1FfGbVsQROL6GuiKxiNHsPNXHImCZalA6oSzDhGf/yyXKBRBX70rp3+jCAg0gKNEGkFbBxYylmoCq8FOShb8r2tFYnMhjYE/dSQdptikWaB1DZcs+p+Mf9r0P7DfRZHSmGZVx3Vhk21+1GCiHuHVL9FnW6MuRcXXP2a3lReMtuHfbIXm0S8IWJN6Qm+lFtmjkbL/4yi1gCkD4V79PGyiL9fOiQkpd0RFjBcV9yJhQdFb6ECjGqRhMW3MLcMvqpttqqb/0S1JHYYebwDtxt/1RW4XCiGq0Tpv+ezSqTgBfLvlvZeogZmxBUyzwW+oSdPgsM8Fv9+YtMv74C6M2qLx5MdCntPPBbS2gmmB38mdzKjnM3YAPV18HhFO+ZwFiAKteqgADnekhWufPZDc9T4W8ZZuIcIPsCLuMpLkr3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R7Fvp86rFAmSWdqxRl1MyNcZs1vM7CvWQp1JLP8NBb2+vepRH7NCD3PItZ+q?=
 =?us-ascii?Q?Ch9y0Vny+R3pQX+2tuTxGfGp9Zr9iGpz+Kb6i739KskVeTybCJGUNtQVlqYh?=
 =?us-ascii?Q?rukf0ZhqKEO3qwTJYkgbKifHCnia5Uz+tj6EbT+xS+aJnK9FaqAeVWyW8eaG?=
 =?us-ascii?Q?2ytHSE6sAcSX/FmN0uWxcObomd4owEbeL87TtfVrYT4dnDMc71/GQ41Qdjma?=
 =?us-ascii?Q?onRK2kxY/afpoXBK1Uzli2GndBCzpe78xxxcZRbWMZO/+LJ235UJBVRZd7/p?=
 =?us-ascii?Q?m5phK5gh72mcgp/2gc7TllHzYhAu4gpYKrLJLV4t3RbTdDVIHJ+2rakYsPyL?=
 =?us-ascii?Q?9wWHUKwHCirkg6KBcwnnwoePmFJ7nvMrDnRl7jlKTatCCOEsW+vRgNuMCxh9?=
 =?us-ascii?Q?WsURHgPDQ+ZxBbEQR0a7hsd7onoAC9CgegXMh3B2qXtijr4kcJOUzwS2nTGl?=
 =?us-ascii?Q?3JYPdBpI73Mv2eJ393HzqElAp7BPtHx4KV88ea9lCxa+9WIgUrRDinCdU1+B?=
 =?us-ascii?Q?prSee56qvuhpHA8L7bhYXc6PJCAImsfu9YqzXjEz5SznTMxLc6fVY8y3zifL?=
 =?us-ascii?Q?eC7/4xLP6GhBrPpEzaQSDFWp3nmdFLC5+sL71ufXo5flaYMapufU6+lGqwnJ?=
 =?us-ascii?Q?5C5lctzHWPfFfTCcDLHHvg7QbNBkKCj/DLwbv1c+rtfXX2Mk7TIhJe+bLZNo?=
 =?us-ascii?Q?vUc4JZhh8qXm6pv8OtqSuvAABflQpz65wVhu7Qn8fJl+p4P/knSiTbJJ9DI7?=
 =?us-ascii?Q?QvDDdsgcibftHpzjb+PykPHm7v1BfMD8V58UqUPQFjk46neaUKK3dE4bqBgl?=
 =?us-ascii?Q?yUlLfx8ZHyIJRtL9q3/Sc5AukWrg5sNIHYrNZQWJlVvfYrZjZlZerwgy5KdO?=
 =?us-ascii?Q?YKVOeBm8OWcJ4qPOrb6DghKe1wCF1f8VE8CZJ4bTMZNHSVtxrglh0TjGuAh6?=
 =?us-ascii?Q?vCI2DkkWpvmDvaAy68ftmlPhIRQT3Yj4PFgiJ616cHPgOnnZ024NBF5MQDmk?=
 =?us-ascii?Q?LjpO3Jvs2+g/Cjzbc4ofQX0lzf3+TGnSDN6ElG1I2GnK3Mvy3pWTnlx85HBJ?=
 =?us-ascii?Q?Qivj+iPZ3IOE/XwQKFJeDW6Rhy/EXDidxeRqC6ai4c8kv6w11aBsM894nnR6?=
 =?us-ascii?Q?68mwyrLE/3kGnqHvrI7bYtKAsHR9mi+eyRpNlKmGi3SHYbtDOPqo3GBk4ys0?=
 =?us-ascii?Q?QpK/Izj7oPH1HAf7mzV0BByuK2lbXNUPUlkcLPKkTW8JpMRhXoO1Ixxa2KFp?=
 =?us-ascii?Q?iRumUaEiLhqQ+NxW4oOehnrXn7xViDoAqNAPmgGgLlUxg/8Q01MVpnp8s2fC?=
 =?us-ascii?Q?Sum4KI9i19X0ukFNridImq5qtorrYTsMOpfQ1OXneSs9Xb5wIwZwRG/FHJyF?=
 =?us-ascii?Q?YTYMPL2fV3gwxD4bLsLsuaXL+Djl9e1QXO3VfZtHKlc8N+4OVIZhU4zPH6er?=
 =?us-ascii?Q?ptRWrb8BBOlRkj/jbbX8LxC9iYFcBTvye8Aa+vtByQwWMfdBvWNLiWuASUYe?=
 =?us-ascii?Q?v14DvpvdQS+wf45iACUHnQUOo0u32d4qOgPT+k0UhH5UcdcwRPKs7UmmbkQL?=
 =?us-ascii?Q?kTj8M0nrjKxfdGhr9KI80oDs5tUQceFdUmtLuPeuROtAQctBXCo5T5LN0Ie6?=
 =?us-ascii?Q?hA10cjtsuRjfQ4voe5HOtrkl0wZLKsV6hyT2XP5Nn1MSmGrOFfe5JBfcDYU9?=
 =?us-ascii?Q?x/3RFW+m2GY992Jtosepf+yqVjxU6cZZdX9hdHOvpkArnlAE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891723f5-d8fe-4c15-7a73-08dea78e07b4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:19.1804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gl1zDZ+H4uzvgJknV/x7lG/BcEqXxX4tS+Jj1uqoXDy7nvN8RrFJOFFAGfgbuOKr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9216

[ This is part of the patch pile to move SMMUv3 over to the generic page
table:
1) Introduction of new gather items and RISCV usage
  https://patch.msgid.link/r/0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com
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


base-commit: 1338d1bd1ea27bfe2cd1c4494547d409016a6644
-- 
2.43.0

