Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F771428ED;
	Thu, 29 Feb 2024 20:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709238220; cv=fail; b=Ir3cAvpyz1SVzXnd2gec6mU1OoT13h5v2pB0R0H0UHHMTbR5jeZd/3o4tBJoTSBXpDvp7r8rtaDJDoziWRjtg4udHEPcJStS1Dm0rTTNi9js6SRuLUevHEz0X0Byqz5ToTafpB2cCGIM251muTOygq7NbWuI5Ae4wEWpC6PXxKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709238220; c=relaxed/simple;
	bh=otcLA7Y5wo5LK6rFj+1cavVHsu/ZqmUeCNBrwsDg3oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OvrsnAAC7US97afE2gkplPcGImsuazkDPNB57m/2m5Yzq5xL8SqjICCdNvcBHNMmSFSaDfK0xwe6OfN+DMsx6T/jmgm0ckNAw4EqA3+8OdZzqSMbho6+bPABDMxWRXGGhnKrFHcRTG2BTO56YYIwpDBZMIarkREujGrKMScDbdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mPOYiluj; arc=fail smtp.client-ip=40.107.100.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mPOYiluj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz6t0j6O/DFTJbUT+gBBrU7JcoIJYGg+EUYlNogcyLtxV2sNmjSFWcBu5KxmVuQDAO5E1yDsu6ZCCrz58SfWZAjz9e+jao68RIm/DWJI9dxDAE1TD+CvX0CTh3vTBqNR5pGO8hvOcEKOM9OhCHEAqOufbmqSCGHqRo7YEnG9HjJNPOk/Jkz1WLpPgG4NOknO7T/IF6TxRMdVk02gdK5lY2pX/PDB9ENsIP5a2xsP6y4XefmSpR8vCTwVjIBne0xTlW2mQRop2lGtbuyZjI8ZVoZIX8enWUN5iGEvXgI7qky+jGPQDfIVwSU/iYBiuMfJzi4msoS6G8jiBTav0bJOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shior3ur48hvQ//+aeYxlcen2/aPxeT+bqHzjYHu2/Q=;
 b=Bu3ROBBZe9VjzqqYw+SX38rOKrZ8uLVT2vmEq4ZPvT59mFreUNQmMd3vFWbV1LpSoQOinVcVVg0M0oH3e8+czyGbdLHeK5Qsh4NfMVU9YS7cGH2zzhtu3Svzmm0qML4gwmyDQlRKd0iTKB7bKuI5PEXCxQEXISyolFkFjvWkGqrnI4irlNC4YbEjdDW3rKCssQZnxugFtWrb/jng5YuuFXhBFze904xFYsRPHIi2Qd3s9raDRYtrg6BMycKQ9Xwz9wz8HmDm+/hr+CuoUKh9jayScnxxLRXgdAemo5vpUvKyyJU4ESy54RTLtkSfnr0FNd1ItuHryjy07De9EnTsSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shior3ur48hvQ//+aeYxlcen2/aPxeT+bqHzjYHu2/Q=;
 b=mPOYiluj8Y+0TtD/fl/H8DR4JILOijU055THUQVqNDalXV3X+vySYF4vR3AeDXaCijTAtFcnpSBQEYmSQewYqYRf9YQMcgQNd6vs8LIJ7mMJRjrURR1uibVqJk08Wb3FqtwWkk6FFHbad48wnDIAVqWxgmEpB8FZv9nYI70vKNlgflJDAbcRJLGEopHNBs93agfhPQ8wNF5BrZI7MHFvii47JQneIi8JRFimEChoX/H0ZYaZlQLKtcKyp6N56z3bdNbgjF1WmEtU2wJM4ZT0US4U0bwHSj+lPhmh2ctvnsuQe2tkUM03tar80ZpaW1RS87tFNM4qZ8XYMUMze8I66w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CYXPR12MB9318.namprd12.prod.outlook.com (2603:10b6:930:de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Thu, 29 Feb
 2024 20:23:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 20:23:32 +0000
Date: Thu, 29 Feb 2024 16:23:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, kernel-team@android.com,
	Michael Shavit <mshavit@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Moritz Fischer <moritzf@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v6 00/16] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <20240229202331.GL9179@nvidia.com>
References: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
 <170921954415.3073552.7948276252050662200.b4-ty@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170921954415.3073552.7948276252050662200.b4-ty@kernel.org>
X-ClientProxiedBy: BL0PR01CA0031.prod.exchangelabs.com (2603:10b6:208:71::44)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CYXPR12MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: d8268d58-5789-4765-4c35-08dc39644c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IXOwri6jxhOYUoq4fUsV0i+RL54PPUPbqa5tEcKHzY3/ga/miXUimD784WjFOK5O1hsYe7VFeeNiPohFKfVOi8QRpUCShFjbSTGXjspISBLCXboDv2OvXy99Sq/MaDvd5k7LoioSFsyTdN59dtPMqDjsA+lxnbuF2N6siZ1pfO1TI6upf2y/SuFfMmD3ZtEGL2AXSxgsTLJwc/KGuxsCQvTEyETkTIS75nB2GpOjztUFJy12ZB7Sagrb8P2/84+vpQswFYU/S7d8QRgvajB9om0nvZTKte72c0Z1cpe8V1mnw5B+9lslNMEAjE6WWcVBuqOGPYh0FOXsF7erw6AcxQnKqOUobhq08ZxKi8qzUPU4g2KlYMxSNkU4dumqNx8ehNxsQSxARkm6yhbbhIN5sOS4VESRg7oaXZVnwgGWBUg00DIPwAkFECoIspIDI9mUGL5pvx3zNggrE0vtWOxISUuemdnO+T7VOfTRUOCG26naIJKDLuQcdNpYz8jzz/yiwlxIAuMJujeHh/WZhNgtYW+p6KLhWppOjwFH8aqxLxtvPOSWQHDqXKq+Aii1bFWdLmVor/pEFHjN2ikhdrwXUhFAEnvE0sCYKcWNJqWwW+g1oVS/3bz1ezD+KPr9j8JcVbao68f76SPxcgm8GBGG/A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5HQsXXN01hUf8f+TNHrdQ6jzCj68ZDB+f9+XCzLcXZ3PCYtw9+M/h0bXXfgN?=
 =?us-ascii?Q?TmBZoT2+SRijuIWNV8GfuDTamNxb8+I1qbzQO0C1nkz6OKt1s5lUA6AGqMCN?=
 =?us-ascii?Q?QCj0FIt12hKltzzXLYZGIZTVh/gyp4q4zaFCFEXnzpDaWSkTXSUbele97Zfh?=
 =?us-ascii?Q?JaUzpZ3jXj0Mqjir1sMvXAijJY3cO//t1xmeZLuzzEC34ukZG35oSXFK+GHE?=
 =?us-ascii?Q?9080Y+fcuIuECg+1PJvNnVaW/aoowEvWLpP1jwGJFG+yRxi4QgzqyuZMrPFd?=
 =?us-ascii?Q?uoAtlzC9USp9w3uZs29QGUWB9hlbg+AqfD696ynsauu9WCx0ivzk3Ncft0K3?=
 =?us-ascii?Q?Dgo6YbNRcTu7pu6bYPrm3Ga4Ok6kKigMFhE1eh3gOPH2Eji2XT1OuFlXjb8R?=
 =?us-ascii?Q?QHIj0xEJJAoH4UOpKujrFxv0xqkpMhboQ0x+WXnFTZCg3cxU9DzJYduX4mMM?=
 =?us-ascii?Q?sYWKod+mQeZfbT8BwCv0a8uxIOtvxAMSSW+ocI3h1MZV9Ahz12GxdNn+uDQ3?=
 =?us-ascii?Q?+YsYf6VwUHsPinyvEApiVQHB8ff2dsmp+cSIPUUZ+jMyBghaUcyx9E52mFgo?=
 =?us-ascii?Q?U2cdiXlvQ0L3JTANHU33lWI1ZLnMXlP642s7UqlEDcN0Gw61khA0FtBXl8yK?=
 =?us-ascii?Q?GQpeGjyITVVXLDC7A7euNLf/1DCESaSriqNWkM/oGqYk/28io3aoo5wnaikD?=
 =?us-ascii?Q?eWt/WhF/t/9NEnC2OTi3Ba50/Ec6fkVX/OcAUUt7eQPEDtf1Ox9JcF7Hw1n8?=
 =?us-ascii?Q?p3dFqOkGLNWU3MAps443LMGoCyHD7vXRKi8SrP5Y3W2bmMoNBqPJGxJLZrT9?=
 =?us-ascii?Q?ptDGj0JN+wK/NJshkZNGEHgEQarWZWfYc25OxzAtuAxU3vzinohETkFMkn6s?=
 =?us-ascii?Q?soU/KyWn9OY/dRtqEuzFYGJfbgeLBPV2+no05JHVgMuBCi+XPHqg4PyvCOhX?=
 =?us-ascii?Q?LKBLrC0+LOIr6IejtVTbOHBjm4Te0ItGTwwQTPBAVcCX1ABUgHs1zLK68lSu?=
 =?us-ascii?Q?HvFjTcXZByxsDCITww6BlJQIfLh9xB6HvF/rPx74IE8LPwWo9FzjKqvwKdMz?=
 =?us-ascii?Q?h58qMc0dXoCDNKthTjQJr1fnXo0g9p86lEWCKLiNt3TJkqCIzWaIXeTS+/CH?=
 =?us-ascii?Q?gGBMqV7YpTZgxrvbMQwYvRR9Fciyhco888pN0x7kJuOh3wbdKxbSiCgJIj1X?=
 =?us-ascii?Q?4lIGrOYbIELlqvCqJWc8hw5op/Eekusr9sFTeaqB749zsL1PwNkE3HEnpwj7?=
 =?us-ascii?Q?MLADJP9HgKqpyG8iFXp2dWn/2ELt6INjmLmz4b15sCJ6F+tuqs66jvWbAy2+?=
 =?us-ascii?Q?tvc6kwIO+B8/exPcS441aZz176D67eWTru0cAszHL+OZmXaQuTjyA0DOKWoy?=
 =?us-ascii?Q?2eiZJCjP7avao4ckoa4Mbwm4fnG3bk5CRheOskLfVHGfKs+GZchAU1TKwLmN?=
 =?us-ascii?Q?/6pmBctsJyAgZY4WxChedqDIaKHI9AONwpkKLToIARDCjjvNrmFdO+DPnehJ?=
 =?us-ascii?Q?13S0QFGQ7ySKiiwnpvVoOwALvP8YlpAOBytKPZaNZweWfAQ4BKXfBLSdOfRr?=
 =?us-ascii?Q?mV9zjLMS1wEWqU+Vt8BnwEwSZk+oGlaKHL+mW2Ng?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8268d58-5789-4765-4c35-08dc39644c95
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 20:23:32.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+R9n7igqIbkHWIgu0/ufkvQoWudZ/nVv4HFFG1xumz9w+6lFR+nT+ng29wWDd7A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9318

On Thu, Feb 29, 2024 at 04:34:13PM +0000, Will Deacon wrote:
> On Mon, 26 Feb 2024 13:07:11 -0400, Jason Gunthorpe wrote:
> > The SMMUv3 driver was originally written in 2015 when the iommu driver
> > facing API looked quite different. The API has evolved, especially lately,
> > and the driver has fallen behind.
> > 
> > This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> > the most comprehensive implementation of the API. After all parts it
> > addresses:
> > 
> > [...]
> 
> Applied to will (for-joerg/arm-smmu/updates), thanks!

Thanks Will! I'll post the rebased part 2 and start getting tags
hopefully next week (I got a flu, just getting back to work now).

Did you notice any contentious patches in there that could use more
attention?

https://lore.kernel.org/linux-iommu/0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/

Jason
