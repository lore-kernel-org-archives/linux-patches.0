Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011055.outbound.protection.outlook.com [52.101.57.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C8778F2B;
	Sat,  9 May 2026 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778370006; cv=fail; b=JKyeYZd3j418j4xij0qFWbnbUlS0iStBCck9JhTzQBieTPRsDP+QVfWg4XW2Y7bdKmwIflskitHTnMSPbSUonwwZCAYNuk8YL4KOmGcPXkx8Sik9s/qCqBFaTuqWpmY5Aj7tWMQmFYxMr+06o0atZ/xl0k2Gxik7NUyz0zWKw88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778370006; c=relaxed/simple;
	bh=3DUzmkKZ0J2l0geH6jJ0Zp9xLpdhWV63ZEatGmTVKEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mae08B10/lPimykKHSDxFlWXOhvEFLQOKkZJuwyclu5O6VL1yDQW6KvCIDpCgCt/xLYpLuhmTX+K558dOZc4spx0bpcatVvqgBs8u333VVZoWmfLIpsrlA2AH7Zrr7alxH2HEEO5ZukA1LtnjkQ4QjrHxYWrn3PDNr+NqO1Si8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tKhskZ+c; arc=fail smtp.client-ip=52.101.57.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tKhskZ+c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jp5EY0b95oKILjiBaIqXuxviPzFypvu5aVPrVn9i2k2xEnvb2w/AhlVIUnjL54y8E/Ycbl9HHwFkNlv611EWFR1ddkeeP40p26fz/AZP2g4gLO+DyFezaIhcFENrRQLmhPCz1eovtCyFFajmGpGasDXOk7QclvHefuRi1YU2fEyGop5E6oDJ0lYgy/8ttiYnoiqUdAhFyxjDKWNQJVQf+U5/kI6KE/ecsUuIVh6yCxi338Aq5TvrqcvJ+vI3AT8AerBOJgpd0PG9s2xDMNr6DiySivV5K1m3CUNgRYKljde5CrjSOI6Ip6M9eHXnhgtR7CegVUUO0iw+WGlx8oxKaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQByEXQR/lH8i5ZDuNOgCvzxc5o5IoRqE2Q1cqvy5hY=;
 b=BhIojgiB5HPks8bdHogPiSu7hoycspRC1Yxhjqs7rKGMQaKD0g0sx0eMPfxDhdqlpxGX8/1ULtyOrE3yjf4UV+gPoaVWeTsJbciN9gTDejpWV+fLjZJYPsQRU2SMuBtQ4VdNpG/YaE6DeFujIfFg3TDfNa0GFB9OZ0eKV0vaRz7yySOLKCiPU53YyyQ71pi/VtsChhpa/ONMRlW1B8PJ0PmpNWTvdtR19ixFwsRIoKzFduyZI1NRVFeYVjfYb3rz8Y8wFXJPaZeONFh4Z/N+Ap4xgPW2U/k7/h50kspJKc3182kAegK5qN9BPP50X2oLtvw7X4ojbw1ORV35AOsU6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQByEXQR/lH8i5ZDuNOgCvzxc5o5IoRqE2Q1cqvy5hY=;
 b=tKhskZ+coycpg4ugugljoFPSpRSlTOpsVF084NYIt39IXTnANpk8May9xRQgsLgj5ebVNJ1nZ5ydIe3W7JP0vb2TsJPmA0PUhy/0kGFj6h6oKUskRrckX01P2CESDUMjkvhn6EBYMyZsCbRQM+5znQMMN6o2crHy6FTo+VqWwaUZ9XD5QMpRSJnIC0IlSeojKhkZEVeaEBFFTltusSM1QeYAfxc72bK1tEhsoqk5uLMYOJkct70E0KhzvFpk+MzwyobdeYH2QqFqIxAG5pcjmigS7d1fmKqi7uWneieqmlkMxd/mXg8v4qRFO8GgwJd6YXPTOnN+HGCoPiMVs+mGqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.21; Sat, 9 May
 2026 23:40:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 23:40:01 +0000
Date: Sat, 9 May 2026 20:39:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Josua Mayer <josua@solid-run.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Samiullah Khawaja <skhawaja@google.com>,
	Rabeeh Khoury <rabeeh@solid-run.com>,
	Yazan Shhady <yazan.shhady@solid-run.com>,
	Jon Nettleton <jon@solid-run.com>,
	Mikhail Anikin <mikhail.anikin@solid-run.com>
Subject: Re: [PATCH v3 2/2] iommupt: Avoid rewalking during map
Message-ID: <20260509233959.GN9254@nvidia.com>
References: <2-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
 <321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com>
 <20260509194053.GM9254@nvidia.com>
 <ac1aae2d-9b5a-488b-aad7-7be542ec8102@solid-run.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac1aae2d-9b5a-488b-aad7-7be542ec8102@solid-run.com>
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 267e05c5-7814-4eb0-f04b-08deae244969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YXhwrLD6WRi5AkCr4L2xI17RDvR2e2Q8+kyCUsQ9Hif9/S7ECqAeBpxT1oYvxYBt1hI13pNwxcAVTyBevxbe25X15AKB2H4IChhPGXtOad+FeJWFFubXVQzUKiSwbxrQH+RdjKJk9R4iPbc2v8nv7ggI+foindiyBVz9gdRAPe9N0j4i9NwxkE8J/60LOA12enU+Njh0ZVGdnaarqB/rLrwEA7JRIM7R7C3XUBqa29PmUcYR1Zi+SaNhfWmtur9LVjhJXg1fT6AePFgDU4uD8OaftntpT1rvUG7QJ7whfMddxqx1yJenYdtJQEVY7VITUMPFbC+3uOrhnDwKUsGlArMT+OlWQsJ9FkrfBGXQEU+Im2hJild770cLs6TUA4bHrhEORTYcveOL9B7tBSIKYvOG4uzDHRA9PUayONRNoQF5tt7t7CcOV3khjC2aXBJsPiARaFm6LOBNTpUR/zoCkLs4O/VIBJt0zOOIX8wpmPWdp+ikqMuzonBHoh2R5XS4WnaTOQaW7BlGMgMiERVASOULpahx90BQ94c9b+Q/nr7OGLG1HQIJR+mXrLk1Gdh7+L+Jsak7WoYCAmpaBR9QIzjcrs7hJ9t727RLbT0mjAXUhgF6G7RryJ4LSE+0NInqjFhQf6vo9m+2A7Km+UQvGWZo1mPvH3A4OJI3IcfXA6hqbhwn9/pPePc5wfuQxxi1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LD2YQyWj9EleLgJLyY/tAeqiQqQZiLzLVsZoHTGm5WJjzKqnUTaVEAdAklJ+?=
 =?us-ascii?Q?DDI2JEIc+U/eqTeha+YJSvwo1e3AmNhXFWnN6948Ohag2LLXLwstmCqaAyBX?=
 =?us-ascii?Q?LRqWUI3EXOsnuJcwYE4DKxGMpZW8/UmW9NF75gMvT8VSW3Wg9zwGk/r2fUuD?=
 =?us-ascii?Q?mpugmJBSJCGkdjas0utB87he/NH3q6qo9lkJdcTd6EE+wf7elJAIq9swAp4C?=
 =?us-ascii?Q?/FxeCGTcxS718byLQtcOOwEf++42SzZKjTpE1q3eIL+pWOZ9n8s938sY8jAi?=
 =?us-ascii?Q?+NnMXPWy42jiIy1g4vPwI4vHFZTPDzd36xitcEH2VDmmBiBRbt0X833ud4yW?=
 =?us-ascii?Q?b1aFH3YnZC/vmJUFv7IAcn7tHmXfgjlrXmte9n60xniThPhExRSpAb1aPOlh?=
 =?us-ascii?Q?NpJbe/P0TGT04bY1tOx68254Jm70r+Q29JIoconRehwLQXfsFES8A2U+0Hnv?=
 =?us-ascii?Q?hbaBSYyn20564U3QBgWT6IHBwEWXxnMVy+rmLyUEtm1lxuqvrPEGv1Bkme8V?=
 =?us-ascii?Q?R4IEak9SybY9WxbnPpaOUhZazUoqd7Pzg95HEvj++7jtcN7MgJaKFfjZw2Zr?=
 =?us-ascii?Q?TQ/U3TfrfpbA1BLTj2T41RDYHNHynsjEKGZxhRjpYaMXILFfXeysk47Qy6jV?=
 =?us-ascii?Q?0/krkRLLtp1N0zZleoV387hioDpmX2aX5RGujpfb9P0wFhks45D6QgxCQw5j?=
 =?us-ascii?Q?+pMb09bapTN4W1oSGSx6mo5TtOJyUUJgpSMT412JQcjRL9SIu1WOmTUT8Ug5?=
 =?us-ascii?Q?etFmvjMIFebApQXitm8w/2KqgValoi9Qlzlhht+8SIR/862ACZEoB+++9tRY?=
 =?us-ascii?Q?3pSdS6eAVkINLf3mEA6mxa1EPzbGw2ALC9b5ejkQN1qf5D6y+zsDAsG2m96e?=
 =?us-ascii?Q?BGdeSgLLZEZ+SlpTVIE1xnqtMdaTWxiG6Dhhj2gehYi50CcK5HcKqICVvLLs?=
 =?us-ascii?Q?a22S5p8jswAhup5WIEsZgVbSFk5+edzE+gYcG2Ck8odWv94Lgx5goPiKoKs+?=
 =?us-ascii?Q?d+FLOb01/OaNeUaUubM621sRoNEZ6zN/bPnngEsvR1atApfjqy8Dtd2pdR8S?=
 =?us-ascii?Q?02GluA0JQu4r2ZpqJPoocdvje3MYMXxeG0osa0y0lJQdasEENaVxrrzhE0v+?=
 =?us-ascii?Q?9CFQrKWwtp84EKa2SuELfWRF5nuVJjEO/IYCbzdEqsJuhcfr+M7Jg1GcfqT5?=
 =?us-ascii?Q?rEDtTGcbOE9Vx//Odssth56h/yMW5/M2ZgrYfimE2LER2r9E4QnhbplQah8U?=
 =?us-ascii?Q?QS44M3AC+kQMqkH18bg4ZcrXUZjr7Ll7JJ4lf2OeHX+u25PQ2049W9gb072I?=
 =?us-ascii?Q?rTcjWEAiFnM8S21f/3lWPpVm+5ePqe1QWL3rfztdyZ5oyJ+1V0lhBZSCgowb?=
 =?us-ascii?Q?BljgU3mk2Cds95yDWa9HVfEllJcnItZerc3KRw0sv4lqZ76aH3+JfKCGkx/H?=
 =?us-ascii?Q?oZwWVV4XtKnEwlvPTOsmvZJy+tfzr7oh007a+3UNP7PHi73jvwYzWvqUkCxH?=
 =?us-ascii?Q?wJr+60Sl5sfr+GY7QHdhuPxGwRFR6eVHqziEkSAu13nj+neWQC4m9CtcQQp/?=
 =?us-ascii?Q?05x1ZKCgKve5LHMCXiwKRuaZ29RaAP2033BhHe4h8qUW8Dc/iAOJRf37uzoS?=
 =?us-ascii?Q?Ro1yX2g1qWB2j064RT/QRQWF8F7GzT1zDAku1Vcz9dy3gRZJt3iN7BZpX3ok?=
 =?us-ascii?Q?jmvI5FpXNBMZvkEKrUehUpwtagKVIfBT715jw5uaxTmRMic8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267e05c5-7814-4eb0-f04b-08deae244969
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 23:40:00.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQzowUscBi1P5ksHuFOmZyPXeKGyZSneZkaWmA13kOWUGpviyaHTe5Rtda7YXacw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039

On Sat, May 09, 2026 at 08:25:36PM +0000, Josua Mayer wrote:

> I applied this on top of the problematic commit, and my system boots fine now!
> 
> When I compare the bad boot log, the good one, and the current one with above change,
> only the bad one is missing the following line from boot log:
> 
> iommusmmu.0x0000000005000000: IOMMU driver was not able to establish FW requested direct mapping.

Ahhh. Now it makes sense. This is happening because SMMUv2 hasn't been
updated to create a domain that can immediately be mapped so you get
this message and the error propagation retries it after attaching the
domain. Since that got broke it never retried and the RMR was not
established.

Thanks,
Jason
