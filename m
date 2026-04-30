Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013012.outbound.protection.outlook.com [40.107.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC5035979;
	Thu, 30 Apr 2026 23:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777590230; cv=fail; b=NovGdZwyNE6jmQndAfxl4u6a+EaWuj5+X9+mF6OPRyR0Z1gpm9ngV3OPo9i5h/RmjpMwxTK8+6e/RA9/blV3OXN3ufWgbauo5tt33CCm3md1vVAPhAM/QNYfqMR+PqfUfXS3DuOP0UMJdXtUdAPzTlRAwk1aFECeI+rF0kT5JoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777590230; c=relaxed/simple;
	bh=srKzPCK0UOkElT8HFPcFbZG7g0f60PqxzsnYnS52Kng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LlpcqHUBEJNNkTazYen0jBVH1/c7RHd9CZamxRXSxdGSxcnU/6NPeu99BwL7EtP3ms6LyX4UrNvX++LOgIaTVFykan0hmR0rrqtARLPf3mr6AfHRbzQUjX35H3H8trhDZm/YOqipIvJ/a0nWHjiPfmbhSyFKVDyI/+Jz1O7Od+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aQKjRYjx; arc=fail smtp.client-ip=40.107.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aQKjRYjx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXDlpSW8/Mk6b8k4C5N9o2DIhvd5B8BGHvjsZeYdGmH579GptcYtKltWwU7tT2VR1SDTMqPajEVqM6E82YRdsvwzjtbjbQBdGefOBZjZxfNXZ0KBB4mAgvd3wt4DfSKmQBiRbgtbyHK23NMOkvp9DAiok/xfnBeLGKmoy9WRVKvbSAcpdb4kzGwpvFFvO11fQwJnVTyr8fnQ80C8bHxAuR1nPATc8Al+PK7KP5jB8JHlhgA4ijyeuKo4XpG+ok9rd5sRS/qCKDzpIg8dyVK+9+o1MYweZfqcmsXR8XeiCdu2Aqa4ZMfo+9+DuU2lnbz2mXlETh7a0RZ1PTmHFPaCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1z+PsXEoc+I+JLYHoUYMV4V3SsudN/jQGGnAbWNl5w=;
 b=KWL4648smFxmfkgZe92wcAx18mL+Jj2wfgIEHcG68YoSJM4kVVNEFABUM+U2l+Pm5scqhcKc9BxGVNPFPmOd6wLIK0MAc7VpCGJ4rQDDdirvGus65Xrzq9Syty6KzAM/YcB/RMZZotQ/M1TcgQy11c1ai55BzA0gmM17Zj2DZ24BzdFwgNFgCdRyqh3tLiFLWcdMxX2coVWkJuuLzyckWgxYoMDo8bkgcoj/neNeDANY/gfKdKX6GgMLn/yMxhcOdZlIrlqtvc1nBiN3LKEqNHg9Rn6gO9x+U8c7RV/nzjhcg/EQS/ijE8BAerUYKxf0YYm4c3lh7wRzGqLZ1Gi67A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1z+PsXEoc+I+JLYHoUYMV4V3SsudN/jQGGnAbWNl5w=;
 b=aQKjRYjxmnylsf4RWaA+Vfq0ZM9RpMQvaKVc3mK5bEWeg6gPWUc5nYkswvIYVNESUbPZUo6oR53t1A1l8FPJ+S37oGkkXZJ3xn/T2NoCemHRL6tTH8WCiBQ1lxDwC1pI8dTR/qj7r1jQ8traEVuYT4V3QTc0bp1FO1kTpaO3cDefJQT8pezFQLeuyQg9ajqi9MeqYBY/9We2ffXcvvbZe5o18Ixk3BS6o8m5SJa/xTnILkUVjun1YNHJzZa7JbRidgfSjtIgBduDLs3Rl0rv/527FMdOeFfbUEVcb2MAw0r1JeJhgy7QXlUlXnKIlECKPzPC7QQGwmKe4wzYDH4vzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7925.namprd12.prod.outlook.com (2603:10b6:8:14b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Thu, 30 Apr
 2026 23:03:44 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 23:03:44 +0000
Date: Thu, 30 Apr 2026 20:03:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, joro@8bytes.org, suravee.suthikulpanit@amd.com,
	will@kernel.org, patches@lists.linux.dev, robin.murphy@arm.com,
	vasant.hegde@amd.com, santosh.shukla@amd.com, chrisl@kernel.org
Subject: Re: [PATCH] iommu/amd: Fix precedence order in set_dte_passthrough()
Message-ID: <20260430230343.GC6829@nvidia.com>
References: <20260430225414.205094-1-wnliu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430225414.205094-1-wnliu@google.com>
X-ClientProxiedBy: YT4PR01CA0134.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: fee91071-7162-4035-b84b-08dea70cba48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bAtonQ+YMpj2Mz6XQlwXMlVvmheYeyTRW9Cw0B2cacDxpGRC/pL98mmrzeVi6/sOeAvN97QE5cs/VViGnJAzba6sE6VDwN960C86F4AQ03o0hEaBwLFdbOWtyeWu27pWLwY5dxC6/mBHTUwn1xLr4uUzJBmT1Y4WFF/s8X5UgzD/UhpZmbYMc0sg9d5Mkg/k+lfqSOfAA9qU4Gm74oDKiPYHzPukws4ULVFmImVlyTXvNZjqJF9vRRatvExyYAuW0lrHdwoXgvwC4F3RYbmR4EP+lYaRdv/+OLK7vrjr/X6u2xK75Ubd10wDlhQeLKcJgbL4SoR9sFUPMZyov7K9R5lAIaQvWB9JawV+v9pM1jKDBrNgo7ueqUyOQ0AB55FAxIUYXKEex6SjydUs44jeHdlAP/tHHR1lQa7F/8zq+wsLHqtKmjUchnmx+LY8hmDtxcIBjcxp0F1+6PvmbfV8fhkEiqbOF/84Gt9Z83gI1JNFS0hLQeTVUw6YJhkn/dgOIDB5jUhilmYTPexZSWE3xdsh+a5QfzMxK3tCrkhjouY2+8YStFBDOL9e+xAh9z9lpsRRBqkQb22AlcTh+U7y44P+Qn+5uqzfNzTLnRbZI6brbvrPkSDbQ0sKJSbxohlndNIauHYHeRbKABClSQwTIQUhg5duLlgGPrn0on3o724IAG5hwRVQr0tXUZpjiYOY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1uzAGNDcoBNVa+zugth1pUqOQhYRdUcMFcbWNL2wLhbqxW4YP1K22b1qpELB?=
 =?us-ascii?Q?QrFg8MM7aSDGD0IKGNIBLhLuUk8LnbXlt5a9TQgzcwJNT+JHuLowEZI9zHiC?=
 =?us-ascii?Q?ieV4B8qejquT04QZdJ2lRutXOOZ/h9NWmADB0bnvbamywQMOqoa/K4zOVRcO?=
 =?us-ascii?Q?bqdTaa474YbO+g6Tz8w4jchZXeR2DuxDNOhjT3XXBHO5HMe/Vxw2RxiexJ+2?=
 =?us-ascii?Q?lr+C97T0LdBq4BpD0nHKLSzwN8rbNiCNmaNfgcNGn+BznLOuup3JUGMG2kkX?=
 =?us-ascii?Q?pCzaPIDaeICHoPaS6+nWfgEwTXOeJrUBeMeKGntwfHUMDscl59Z30FYBUKZF?=
 =?us-ascii?Q?qVJkzIqsJJg66dm8UStv/EQNL/uwmVjWvBzMox4fikHF3OOt5BjdO7LjUjec?=
 =?us-ascii?Q?7Vl0jljrZuoh4f8CdXGL3JrJzNIIb+SXBDncz+MEPqTnxhTj21oZYz2OdLmR?=
 =?us-ascii?Q?Ntmf9YRcpPRi4u46vgKGy/hZ43GTyKVfJwgotj7izJT0jI9jYvb3vaJBWsY0?=
 =?us-ascii?Q?luDOaB2NJyL2AE+7+rePiYBX/PS6gFAQ6pbob3O95KTwjya+Toe+7qPPORx6?=
 =?us-ascii?Q?xQGVwAXZlLtn6aYjBqVBSJiv/XkeCDYCD1Cyes3R8LsELhSRovMS6nsSncnC?=
 =?us-ascii?Q?ERM0/UJZmCO+z5cED8TYWSp599Yq+f6dnxbD/XfqNnuiJt0WL8CvugZlgTbz?=
 =?us-ascii?Q?KTiLlVo5uP5mhZupUDfr1z4F69dl2wRwxiMgrLncwRhBD7zP2zV2yr9F/s16?=
 =?us-ascii?Q?3UytWoXE+gBwuTx1TXmWp5tKe7+7M42OkRxCF7l02nHqvCe1hv6L4lNJzN+6?=
 =?us-ascii?Q?jMSjBuh4tsg3dwjAKWauOeKu4Zd28srJMu2qQGgQ8sr5JsSAMh50tNb6Efzr?=
 =?us-ascii?Q?tSzTQl+nmK+2nK9eAmPhjrGmxQuDBtIoL5ORQgiZ1cP22oBLC4uHXz3xEMuy?=
 =?us-ascii?Q?7+2zRr3ZJbsI6bw1vBIrWNn0nbt/Kim+BFpLjvDdodFuOFYDsSUbaSg65MOa?=
 =?us-ascii?Q?0FQ0i2CznT/khg63yUgJD8w+5YGT3jI84+JMTPgr4aWQ9cK2nxCC9bfIyyGT?=
 =?us-ascii?Q?MX9fxrru5ZjGWYqwSbSgozdeScQjJKlvOyWhJhalxiV/xH1awUd3V2r/ywcQ?=
 =?us-ascii?Q?dtoUw6gFQ1VrZg6+n183JhayU3Wx8mmiIX27EYB4Q1jLvKIixQSfmZufXwSY?=
 =?us-ascii?Q?HXuo0Kis5y5ITdlz06dis8+G2Tq5mXHzBpCu7wjh2p+L61M7lzNreOlht2v1?=
 =?us-ascii?Q?exOG2NaHdQhhejlEPBKU2sVDL6YMiyaAtpVbcLK2GLYfOUnlQAifx/yPTXJW?=
 =?us-ascii?Q?+CIsrxZhrrsIS1zx8wMdDUgkAA0RwQKUeBn6vKGlrAMs3YU20eTAlwDawhW1?=
 =?us-ascii?Q?69q3c6yV6NdAIb/1v3QfaagjGwDJfyrnAz3d5Wc+wlsmmu4GALteXCtYX/Wc?=
 =?us-ascii?Q?siBW/n7B+DrHL9/QafnRgTAsQbXd+jkhDFKDHSukv8cThn4tGnyHeZpi+82g?=
 =?us-ascii?Q?eiLaMCJKI5WzNaiTNKe+TNs8p2pEYh43NYw6fEhECetBDRY536mZJaFgmYHj?=
 =?us-ascii?Q?PC9L7XFYhaj7g3qrbgJxt+LRjc6miGRCSxFFspbZRbINIuoXOPTJ9U1hJC6S?=
 =?us-ascii?Q?gqqo15oFiPFJfvCtTy67IHhWJGCdfIU7jBA4Oxnm2ljY7a22py5TTEP+kw4P?=
 =?us-ascii?Q?CFs0x8V0SPXPhnEpkd2r/7oh+t9ESGTBXWXnbFcNYbvRPAqZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee91071-7162-4035-b84b-08dea70cba48
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 23:03:44.2025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTR8HeelaukpL7aqSssVlTgi7UqFC2O2iWlnT4s3D9hhRvLAca54GhxTNc0eNYld
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7925

On Thu, Apr 30, 2026 at 10:54:14PM +0000, Weinan Liu wrote:
> Bitwise OR | operator has a higher precedence than the ternary ?:
> operatior. It will be incorrectly evaluated as:
> 
> new->data[1] |= (FIELD_PREP(...) | dev_data->ats_enabled) ? DTE_FLAG_IOTLB : 0;
> 
> Wrap the conditional operation in parentheses to enforce the
> correct evaluation order.
> 
> Fixes: 93eee2a49c1b ("iommu/amd: Refactor logic to program the host page table in DTE")
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>  drivers/iommu/amd/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

This should go to rc

Jason
