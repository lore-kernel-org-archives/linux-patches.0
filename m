Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010037.outbound.protection.outlook.com [40.93.198.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E5B480335;
	Thu, 13 Aug 2026 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786630407; cv=fail; b=mFpMXN+Hl63kbiRce38qGi3nlOAcft+FqVDVwBlp0+aEA6gMi3nO6fDUHrcxicfYW0ZV/m+RxQL8Ae2BpY4i8ZnVUJ/37fPMdGsHXje6sYioDWx0XgbNFeMGOFjBanusGu2C5gjjJQl9VLJ2NPcgS4lmo6Nc1frEDDZkwptef3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786630407; c=relaxed/simple;
	bh=GA7E1UC6fGWBN1VzgQZKds/LLm+kCi2xJmifTJ7ekWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RTfYa31ZgUoFKP/JmHjN2MOC7pMOyb5E+7JLNEvu7rSKt/pLZJUIpiEqKF+T05xGCdgzXX9mvdtkCRxKZbqD/4CaY5IXbHJgh7u0n8fac3u0WDRcPkCWRhTAvTzpJlX+oBw3djiDBX05Xbx0srw0Qny/g005y64E6Toz0KYMWOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BVpbCQZT; arc=fail smtp.client-ip=40.93.198.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BVpbCQZT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tXIEZm3yH8SBJnBCukpSqa6vTswGi3c8NZyB/EEx1gLJgQEXpcQf3dze9NgqGvSYkUmRX/wlKRbEOXMtQM5Aa++yrFox1GR8XRrRzBwelZ13y+8Xz3NamAlXJseKvUgtj5YOxTxuFkcQFakz5hqk3/vudGatGkb0xZUGYN+/zLcYCOt79WoMRCSvjyEygUrDV5H/bPy/NQyoN0Sk6X18J8mkXJNr7TEhvcd6uA9Wpf6B4kyTt1Vn+W76MQhVD9RYacwGSdecIZ2DcPjTulVwVtUw8WcwAWzBWmDO6MMWhlwVuLqW4o9nu+z938oi5Zjbmy1dTtwzE5lKDTvaby/0fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mn6Vh1o932dhUDkIRW3So4IeXLZqoga7DH3eYMz50/s=;
 b=njWD/9QXR0aYcfSGwwGmtMJU1KlRXWWEUG9zNn8Fm2qFWRmrOHzCcmtumrEZ2QOCdKc1rN4eta7JbPXmaqHv0RwXB0KcddZ/xVNSioGbdNfv0JLfzJa50iRMtxfmSEsPtMuqYe1tYZWOjQKOrwOUyfCnJ5pn/lSH3ncJIjBA1DRcFY7RSAszuEDUsENaEoDtpt+9aM4iuOza8U25aRpP8qbWxACBtsPL4tAgj1R5hXuTpIR/zeIznmmeEIlxhr856Y8t7s0F1ezPFOz5dcy58iDBm9OmTJMmTsqQS9zk2AHQQRRzqnlqO40ZJo7XnwuM/JKnoe6IGue1YYzqzjdsjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mn6Vh1o932dhUDkIRW3So4IeXLZqoga7DH3eYMz50/s=;
 b=BVpbCQZTjmWATnt9OONDRbcFTN+hcclvtOXCPfucZQNmYnFCdtkOzGz7w0nBJaXoOOWVPPE4+EE3/V8kaqcJjaHYGz0/nHRShreDwPnZpcSkX+cLqgaLHBO6fODFJi7keAkXpnZcpKxhE3IwsaQdEE5PmeAiAva31qPHESctwMqkErTdLrF5JnNIGHZ382J/J+yLRMcOSjsIdnG6r5l+mQkP0Nr5f83WiFpjkRNi66ZmTWFRmxc/QhRf+0CeO4RkSmpnmuvt74qPnaQV13wyHt+Aza1hXMo+/5ImiRlQtdsN0QQryg2XqNE5AUBmollktvp0ayzxoByvODR8oFBZOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8772.namprd12.prod.outlook.com (2603:10b6:806:341::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Thu, 13 Aug
 2026 14:13:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 14:13:21 +0000
Date: Thu, 13 Aug 2026 11:13:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260813141320.GF730363@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3MSKEj7VhT4WkP@google.com>
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8772:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb8c9d6-30fb-40cd-ca87-08def94507cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|11063799006|56012099006|18002099003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	giELf6W9YNSQs7oIewePi6IsVKgqodwt/3/nyugQ6xwx8OEAAZVi92FnaNeBXrednBQcmfwh8XXSIV/v1w/UvRt3IVAR3jH1MldNi+KSTLw6ZZrpMZgdIlFnRR5L1a1/2Tp48+Bzv/rQ510Naq3WBf4Yfip5b04TlbX2JAlT/GfckJ8AR4xEhJFQxmEHZ7JfbYRaj1iXTu/UtMl4VzWjmCxYT26Pavu4IdEAQS3VHOyt5UTbDQLaynQwUfM/AOaIyhbaPMBaxXLhL0SCvKmPXCAInnuhckyqarsN+dwSCmqgoUHbnniX1QugzBMi1t5lxjL53J6sVpeAwMjvja7K4IdYq0ekoDJhFEqS39pNh3wWso1ybVM7DLvZWbwF+CL15EXUnMSDOZ9oTGQNpiY43+hqSEfffV+1RXD9ruaOPT7YrQOnAjfQrRTY5h4NUdaUE2tA1YM7fNdggDpB9Oi0PZfWR1QoNPzrrOvTB2Y+nEPJhc7XMqXSYIFCwGVVxSXvOM5zslZtYNveIDZ19sz3ZMrLp5oNV8ALV57dKefkiwNKMkuVe7M7sfj7lgtLUehakjp4E5eqs5utlbk81zQLFYsbZEkUzsmd//0PJnBiPZ7/AQDjIJDujIriOa8FVPdcN/Wx/f8zQWzLa5NhI/G9giH4cl4nEXBC0t+Dvm5g3BI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(11063799006)(56012099006)(18002099003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ms3WiUNO162t/0N55h0XDJcKBeDGnsYPfOMpup3jb5RGSSDulrORFfyXMivS?=
 =?us-ascii?Q?NDVeve72qm8BgNMMfoh0bHyu5QCqm82T0FE9RFnEpLUEXm2HO5Lg9GnB2PCv?=
 =?us-ascii?Q?NpT1BLr4XVFFjEu0kHgQVydZcPHTQvrnkEyiGJQC1rpuqUi/HaoqrmIFqlpu?=
 =?us-ascii?Q?2EqAbUdKV0qWUJUjYDSo8vLpV0AlPCuWHqUk6DMnlY6TBGS5h37/+fbqyLDy?=
 =?us-ascii?Q?XPA9DlJjrPb3EbxYmYjYA4RhLq8iv4XI7InLhZv4ieN2sVvtFItf15SpmEiL?=
 =?us-ascii?Q?QAdmTLYXubavh/y4nfAtvoe9MGH6U0VjC4kR4q6LvKFZFEIemOIf9QK3d+3E?=
 =?us-ascii?Q?AVXm5S/uY71NkirD23E1k0uCpQJGoHqrbGFt+HVc+DYq41ApSue5a6A2qiDe?=
 =?us-ascii?Q?dBgx2bvQqshlDZMp162Lttp22vJw117WxVPBVtl+qALc/M88jEB+4G3bD2IM?=
 =?us-ascii?Q?miVd9dvEXmFbiSPz+CxYRQT73rKviQ2xI41ov552I33VdUE3kP6VnD3tsDZv?=
 =?us-ascii?Q?3TrHuxWzUmEjTvD9TNu4zeTGahkEluQaY0T0iLaBeIhagjAIdOjJCdT57HHO?=
 =?us-ascii?Q?KUrcbVik5pXPIM2r8LYNwWukinpTF8YZZYgQQDznK7BCTEHDxhjafAsFtfBh?=
 =?us-ascii?Q?DvUUnUC6FpmBSRlA45g9EO7cm4+Y6fTEb1e0h/AwtA01lHp8qwektWnV2nT2?=
 =?us-ascii?Q?qEMRHujnlN7BEjIEWCzkr63ctWLMxUYxVfjgT8j2aAZymiab6jjT9P+h7lwY?=
 =?us-ascii?Q?PW9nhMUwez2niB+Qcaf6e3Zpx3Dj1UASRPgMfPGfEvL24a+xDPKxU9oiwHDN?=
 =?us-ascii?Q?IuOnhXJifpasspouj1CDTsudHS33v4fov3eVR4SEesFDMJ7GyiUkoW0k6ejP?=
 =?us-ascii?Q?uSoT7r0uo023owy/4HUuKY8ajrFh+/gGlszOYyOBQJrgEhGtfpWIVifl43Eb?=
 =?us-ascii?Q?8Opb3U5n9AUFBtxfHSTxO1QJ6aqAbs+Z1DLghSgXvzhpuc6hVSlnAmjwAqjc?=
 =?us-ascii?Q?Hwxp1Riu+q5xo/V0wsvsNxps9Jck6z4O1b8L6x7JLppT1F0nwissnqBeO8xB?=
 =?us-ascii?Q?KRsTLwBPjM39YMcFor9B8aJGZ/aDFH6D3OjOlxA2cU3Fm+04drX//+yelmCu?=
 =?us-ascii?Q?8CFNLfyLKbIv5PhoaOdnod/kk97uvk2uZF54G3PSPVhdOFM90+zJ0Emwtu6B?=
 =?us-ascii?Q?R1dikZ8xdVLHuNZ7ZI3qUxfXJz+ksP+Z20s4Y7qvzDGC4Uoeh/9XFX4oqHSA?=
 =?us-ascii?Q?iNZ1GCgTSzC+AmyAjrQ5iQDrv5dQFgxtgOqYj+xWeOtSskiKEAxBE3D63fCM?=
 =?us-ascii?Q?TVgBQubIzvBuYaUsdojE2CuGqeuY0sUVy9tz6ECzFa17JWBCs6lpnunWrR9g?=
 =?us-ascii?Q?gpXdBf8OgYwSsfmNk+r3EAbc/mzj5AA3AjO5/9NLAs8am69MMOlJRhjIRZIr?=
 =?us-ascii?Q?XO75a03QCrkeRB2T/PIMXe99FTnCGIYQR17zgYbrzFgGuueD+BnD4pp20meC?=
 =?us-ascii?Q?W+B+Gr9uIQwN1SYdZAg5ikqdP/kHCAzlWxyx9g+CWblrtJhxEx3tRenLeJUF?=
 =?us-ascii?Q?P0/BgQvugFPl5IksHzPupblziR+QyBKzuR3co16YnNANKCdcC3OLL/E5Rl0O?=
 =?us-ascii?Q?lhJb83CUhk+QnOZyRHHj2P4U6DPw+WF7tJGCkBaQSxE2/T3UCkQkgrVwc9iF?=
 =?us-ascii?Q?r3v1DiF6hEOIHttnbMPuT2nD6TVUBrla1HYSQNNQ1qFLrMElh31uXX6a3hKb?=
 =?us-ascii?Q?3v/uFvTaUw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb8c9d6-30fb-40cd-ca87-08def94507cb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 14:13:21.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ny0w0refZrLGKp/rv5f0dI5kxHv9EmDkATVsaI0MfcZrcYyFwxv4ftOS0U49ONT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8772


> Sorry I lost track of this thread and I just saw v4.
> 
> In the mobile space, I haven't seen an SMMUv3 that does not support
> RIL.

Oh? That's very surprising, AFAIK none of our embedded chips support it
yet.. Even the server chips are only just getting it. Are you sure?

I gather it wasn't even available in ARM IP until recently ish?

> However, I have seen workloads that are really sensitive to translation
> latency (display, camera...). And I'd be concerned about those
> regressing.

Yes, those exist, but again, they are already facing these problems if
running without RIL.

And, for the common case of putting something into a carve out region
it is not so likely even an expanded RIL will intersect with a
reserved IOVA that has a high alignment.

At least the things we have built are calibrated to handle a TLB
reload occasionally. The isochronous TLB's are not even sized to be
never-miss for all cases because things like 4k media require such a
large amount of IOVA the area cost is too high.

While others can do something else you are reaching into a pretty
narrow condition to hit a problem:
 - HW that must have a never-miss TLB to work
 - HW that doesn't have a carve out, or has a badly aligned carve out
 - A SMMU that has RIL (non RIL is already worse)
 - A non-isochronos workload that regularly exceeds the RIL/single
   expansion thresholds
 - Unlucky IOVA allocation that places isochronous near other
   workloads in the IOVA space.

> There is a clear trade-off here as you mentioned with TLBI latency,
> would it be make sense to make that behviour configurable from a
> module param?

I think it makes sense for a driver to indicate to the core code that
it needs isochronous and we can do more global things like change how
single works as well. Having an isochronous flag on the domain, for
example, would be a good overall direction.

I'm inclined to leave this as is and let someone come with a specific
problematic HW, rather that try to badly guess without much
information if it might popssibly be a problem.

Then we will know the HW and can mark the driver as I suggest above.

Jason
