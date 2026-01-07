Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDFC26E6F9
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 23:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767827377; cv=fail; b=LfWQ27myTr5wOG08WY0pkkyhW4IvHcFHKOtc+qo7AyW8XavFH8RAlq2x0jCtf9jOkzhH9V84ktZd+7RqU7kDfois0q+gR6x09qBlZy1wWsGFzORPqhdxlLEDZeBZH65N1w146zzXSayNbqcnCdlVGG3Td+palWzjAz3GGrOIL4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767827377; c=relaxed/simple;
	bh=jQa5xPCDpgmWQ8BezlmhlFoE+nzql9cnbA7H9/G+2yM=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQQ03cTKlX0u8pmDVMIY8jJ91TdFjl80V3ygwt8se481wkalyaRuyljkIFNRFB6+ucC78Tezsq1MB8izl3RLUnygf+gtjNHnYyfamOzsH9gU9BxihablsWFR65wc8QfgXhGT2Bq6zGlinfdYvUUIR5bKePaTe9Mzxgrwc5o9R9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZr71ci7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZr71ci7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767827376; x=1799363376;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jQa5xPCDpgmWQ8BezlmhlFoE+nzql9cnbA7H9/G+2yM=;
  b=eZr71ci7+eAlspVv6q90hG9r8j2s4Kk9h5pZ1GywDCzNhBll8exABej4
   hEohxytCwx6NuhA2VbPOSPd5/2qzRNTTj493KGSTI60zCokAWyl5V0gIO
   pSMvpZDf8VQso+VHF498dS8rxy3q0fsoxuTUlHknrOu7W+UcSUavl5Xtl
   gRpkgysAJUoSVDIrjxC44LANk/4/tLdtvTdZNLquncrg3dJSqtf/6s3Fm
   JxjIuZRQIPPnFFYVMu/6iu3SuAgyh6fR81tIv6smQQ7ndzTQoECBDoDZ7
   erxQ2hCBtlbXaFKqDoe9c6pGclmaMcX8nbyK0Omcw4HAjd/qion91MO1z
   A==;
X-CSE-ConnectionGUID: ajtxPSRaSpCA58iItWQx6A==
X-CSE-MsgGUID: l0VvPNOeRwqpVoGkoOStQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="69255521"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="69255521"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 15:09:36 -0800
X-CSE-ConnectionGUID: DTXEBXt9RRe1bI/KkYaSBg==
X-CSE-MsgGUID: TW5vqSHDQnq4dawjSO3Euw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="240527377"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 15:09:35 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 15:09:34 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 15:09:34 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.24)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 15:09:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BsZmFIaH12nqK+rFi9z51agN37dRZMLxpO3DxgG9hg3VTalkC/y0cYTzcR5ujN4ACWPo8vMqP2WcBbSNCWYvKkoJVD6QnMI0ZOqt38dk7KZiJUzV78YJvQepgK4Zc6uNvY9bJ5jxdo8TDXhYOEpuftwNlc8C+DuGyc4d+rpdKKHKaSxHu8DdLatiXU7CLLUOL7jkzVFfEKnVBnRmOSOsgkb/IM99f2OCysi5Lm0mUrkO7yATaw17aIIp8CtJ+tQHIwLHOSdtdBvFIczxXRIIou1FjXVEQvKSAiBBM74q/qULyfogS+3B6A7y6GGqpaXR/4Im1pZMX/tGKqjmjbB3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqT0w1Kq5dGc/xvZhtwrnr7FS/Byl3oTr5UNTPUm7r8=;
 b=bCrnMKhIQuUdDG8ROWDmY9Tqlj4hN2/1wGNzmrEv+ePybufJErAqkzn2dACTe3S+qr//RvfAQy7xUqGxIuacpquWUAM4SjdLYJAppAqT7lTDSDCLkn5oDgYnAcLhezgdu8224b6Q2mRGjSSmGrZMyhSjPuctKExWYGJbYfeYL9FRjGtfKRucyAORUxT1L7Sercfu4KVExfiI8vXAzo2aoNuddJSd/CBQcGphX2KCW7h1sYlQZ/DdZCwipHHkVKeBFCN1A3GxL8oCiNZG/QSjnfQ3G/USvNp4wtP9tNPXyU2rSAd/8A6Y3uOvrbTVnb1n4JGmmV6ZfI8CCKnvtnbdtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5152.namprd11.prod.outlook.com (2603:10b6:a03:2ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 23:09:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 23:09:26 +0000
Message-ID: <1945e4b2-9a80-4e48-be70-a8904e0fe10e@intel.com>
Date: Wed, 7 Jan 2026 15:09:24 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
 <aV7BIWu7cSSgCv1v@agluck-desk3>
 <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
 <aV7d7JTp_YX_4BRt@agluck-desk3>
Content-Language: en-US
In-Reply-To: <aV7d7JTp_YX_4BRt@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0103.namprd03.prod.outlook.com
 (2603:10b6:303:b7::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5152:EE_
X-MS-Office365-Filtering-Correlation-Id: cc309f30-a27f-4246-9a95-08de4e41cdc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N01EUEpPcERuQW5zV1JpQ0p6WWw4VXIyNUZUTkJjV0pxenZTQzRNYVhOSlUy?=
 =?utf-8?B?OVMwaEJTdGFHOEdJcHpBbkVibFdQRlRoZ2hWZE1ZNnMyWXE2ZitISzFaUTJp?=
 =?utf-8?B?ZnA5WTdCSVNsbEJQc1BqVUFZZkhjbVdJQlh4czFWTGtrRFlSbkRVUUxLSHVO?=
 =?utf-8?B?eG5WWFNNT1A5dStmREJtMHhpUnVxK3JwaXRPYUdoT1o0K0xCZXFyczExYStn?=
 =?utf-8?B?YkRMNkZpeXZXU3lPLzhqV0hBKzhuTWF3eTJrdG9sTFJJdHhHdXhBUzk0WUxV?=
 =?utf-8?B?Uzc1MVZ5ZW8zVFlqQklnQndqbnllNGNJZVRZZndneGRrRzVyTEI4d0VJU01D?=
 =?utf-8?B?bVN0Y2ZFVHZvcUNWKzZ0V1YwMG90NXZVNVRWbnJIZzRqM1BHeFRjTklYLzg0?=
 =?utf-8?B?b1k0VE5wVlJVUURCd281M0s0bXNJeFZvdjh6Y1BHb2ZVNXAyYzNZdTF1ejM0?=
 =?utf-8?B?WTRiSGpwandoWGpBQ2hjaTVJd3JuamtPOHRBSFFGVW0yS0sxYlR0Q3dhWGdQ?=
 =?utf-8?B?YklQaDF5RjNCQXdBSEd0ZEh6and6WTFSUFFzRldmeGd0MG94QUVBRDFwczJi?=
 =?utf-8?B?QVNmYnBBZjBpRFFSbGRWQzNDY0xIclhRVGZVTGZwdGJhR2JqT3FLd0tMOE85?=
 =?utf-8?B?bW9XMWV6enI5Vkx1ekFFaU1KNmRrc1NycjJiWGhjaHREZXN0WGtxeGo0NkNt?=
 =?utf-8?B?T05vejJCTzNtYTlnS1F2V2ZkbVFHdW0wbW9hSGZMRTZrWWhPOXpYSk1LSGxN?=
 =?utf-8?B?TjNXanhhdzhCcERPVVhOdGE2dXU2bFh5MWhwdER4ckxPRlEvblg0L0RrSXlq?=
 =?utf-8?B?UnRiY2V6LzNWWWhMektVOXZKZkJpTEVVa2l6WDF0TCt1cTR2RzJMcWdmc1Nj?=
 =?utf-8?B?dUdZeFp4cnlINi9MZjF5SWVZUXZLaFZnaUtiR3dzTWdYTkJvSXRUTVdJczcx?=
 =?utf-8?B?dFd0NCtMNTR4b0pha1lHTGFkbU02Zm1nSFFKY0IrNU9IZ0IyNGxHWlFEc0x4?=
 =?utf-8?B?MEhPbkExVTBGazlYdUllcVBQaVBueWU4UmJEd1JQbE9wdHRIRHBXeldXdWZv?=
 =?utf-8?B?SWMxYStGNkpWQ3hNdjYweUZLN054RTlMSXNub1lmRytCaHhxY0hJOURvYTBE?=
 =?utf-8?B?MC81NDMrY0Exa1V3QmZpaGZkUm1FaDd3aGZXeEl3cW8zeW4zRmFmOTZwTHZJ?=
 =?utf-8?B?djJPbWYzNXU3dEk3MHBiOS9qc3Z5VzI2S1MxbTRIZ2loU3hDTFJRa1ZCNU40?=
 =?utf-8?B?VExCQURBRzNZM0h3aitHa2pBYmNia09YWjNGZWV6Y3VLTUVNbmJMRERtMWcr?=
 =?utf-8?B?MC9lMi80TGNqdUcwODM3cHZMTFA2MWF3MFRaK2wzcWJ0cURWWU5qekRkWDcz?=
 =?utf-8?B?QW50Q3A2QlRSWWRUZkl3bnZIMWtTalZuVmd3ODBHMEJKam55VDN6R2lsNzg2?=
 =?utf-8?B?WWp3bzl6cFJORUJwOHNTMjIzNmlpS0tpazZ6eTJ6NVMvU0tQaXR4dENXSnhy?=
 =?utf-8?B?YUhpSnkyU1lMTVMzWk1jRWNhVHdZNCsvckZXL1AwT3UxczM3VFZDZlhnK1R1?=
 =?utf-8?B?NDdYMG5RUXZuM3RDY3oyTjdJZmNXTldvcWd4OWNGdlJ1WkczWXZ0eWdqd2Fn?=
 =?utf-8?B?blpnNW5QVXlMMm5NY2U1eWdhZUtkVCtvRnpHVWlJSzdUZ0pEMHBRQkJ5MGJq?=
 =?utf-8?B?RXFOdzNNOXc3QkVXUjJYRlgvMjZmeWJ2OFA4b2VCZzJGQ3piUUFsTnVCQkoy?=
 =?utf-8?B?cG1YQlExUWFFRDFjYWRDYTFhV1c0WVFaZEV6TnRGc1Z1SzJOeUVQNEJlalZB?=
 =?utf-8?B?TElaSmpnZmhwQUwxSFJ4aEpseGk1aVV5ZVJWQkg1MzJUM0tSNlE2MlE2WjNR?=
 =?utf-8?B?NlNQSDJKN05Rd0ZFTTZhT1lKbEhhb04wSEZpT2FaQXZZRHc4SnQwdHJEeEpH?=
 =?utf-8?Q?yRRdfAIPyptB51Bkp4s51d4n+3Lq5MlE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SURMS3lwb3JaYnRnbWZscFZsTW96VDdJcHcwZUszYkdpcXBqZEpZeStKek1u?=
 =?utf-8?B?TmI1dGVBaW4zZ0RObXQ0WDNJZ25yVllPUEF5M1lCWEE4c3lGKy90aTNFa041?=
 =?utf-8?B?R1ZkQzdaZ3BQRTVkOUxBcFBCa1Z4NGNNOHFDWlNIbnRTSDVjRnJrYUNWLyty?=
 =?utf-8?B?MkJHaTJxREFsMXdIVWl4YVNDQmN5cXowa2pJNjBRbDlTb3AzUW5STkZCcm9H?=
 =?utf-8?B?SzdMWUY4M25CSkZyU1FxRm53TjRqMTZ2ckIyVnlHTlB5L1RnWUFjU2hwV0VR?=
 =?utf-8?B?cHN5Q3FlaHlrQ1ZoTkQrVGFZVnVpRTVCV3NkMEdFSG1idDQ0MFI0di80QXA2?=
 =?utf-8?B?eUhGbGs0Z2JZbGhCbTk2SExGR3BYTUlSQlpkb1AraGUwaGdoMUpkZVdENnR6?=
 =?utf-8?B?MUJzRnV5RHpRbk4yMSs3b2p2WmJrQUdyM281N2cwSFdKaUc1OFRkRG5mZ3dz?=
 =?utf-8?B?ZjdkZUN5b1o4NzBBVTdJUWJ5T3dpVERzaHI2YUJMRThvSG5UdlZDSzBJOVBO?=
 =?utf-8?B?bVZxS2Y2S3JrZVZyK1JNV3RISFpiSW5iUVlYS2pGTVpPRWIwWUJYQ3JvdElU?=
 =?utf-8?B?YzhVMU9IVG1tWWQvVk85bFd2L2dwcStRZldxbmpLeitEZGNkZ0paT2h4U3Uy?=
 =?utf-8?B?RFFhb3EvenF1WStNZmdoc2NwRmRQbHhWQzdKMk5xSVBzK25VM0x4R083UWw3?=
 =?utf-8?B?MUJXbTZaeWFMSTNqSUhVd0g4Nm5LYk44Mzg5V2J3dW9XU242d1VkdHhtUFFh?=
 =?utf-8?B?U3VHTlFySnRZem43WkxLTnAwUmhJNmdLR1luUmthbHU1Z2hCWkgwdzNQN203?=
 =?utf-8?B?YjdYOTdnWHZZNkdNSWg4UVFWU0pVWHpWTW56NTVyOGdWaFlYaC9XMnBoeFg4?=
 =?utf-8?B?UlpWVElRZFpJMVFRay9XVnl0Y3AwZ0RPeWJJUE91eFMvcHEyOVlvbE5LU2hW?=
 =?utf-8?B?MDhwbW5BeDRyMFg1SDNJZ05XOWNiM2xqTTRhYnFBSG1RbUZ0aEEwSnVzdVR4?=
 =?utf-8?B?ckVMVGI1dlczMXpJTk4raFFLWVQ2cVh4T3RkeE5Hdk5pMDN4Q0Yrc21tWkg0?=
 =?utf-8?B?ZENGM21ZcEN4UVBzV1hBWThJby9qTkRqNjFTRzFhM1l4N2dETUt5d0M1S01U?=
 =?utf-8?B?M3NkRjdHZ3FrcmhjZVlHcXRZYkZlb3hIZm5QWmZyeEJPR0ZlSGtZTG5DOWh5?=
 =?utf-8?B?WmIvZXJqN0JORGRuSzVsSDluWXhhMk9YRElEN1Q0OWF2T0pLTUo5TE1PeGov?=
 =?utf-8?B?YkJZUUdDUkdrSmlXKytzNEp2WUhKTHVuYS82bDRMaUhTaEFWcGNsNkNmTWxv?=
 =?utf-8?B?R2RTVFJjV3hVaWYvUkZjVHJwTU5xbUpoekdhZVBUdkV5R3BmWW1xUk5XcUdW?=
 =?utf-8?B?QXUwYnhIWnlFRHZQbjlBNVR4UnltOGYrQ2UvSHMzVFg5dysxOWRvWmtsQnVJ?=
 =?utf-8?B?TXRyblNsMElPSXVmR0E1OGh3VEhBNFBlVmlLNXdwcnpWYmxzNDBxbzBJdStG?=
 =?utf-8?B?dkdHQ25QNUlvQmNYVGMvMStqbi9JZjNUZjFhVkRtQ045MXZwYTgyWW1SaCtM?=
 =?utf-8?B?RklCRU0vYjh1dHBKaTFGRzRtSDVyWkI1ZVpKbFNrOE52VjhYWVFvT1lRdmVN?=
 =?utf-8?B?SG90U3pLWUp6WHh2cTVlanRaZEs1YjZXSHJoVXBHc1prNzc0WmJIOHBQVkxq?=
 =?utf-8?B?ZWJ3elpGMC9MOXZBeW53NmpNL1RmOTQwWmpja1BleWVheWVTdkRaMXJ6eDd6?=
 =?utf-8?B?U3NKSFZqbmVzcGJXSGNCejRYeWx0dHRSK2ZGYmN3dnNFNjdSck9iZGpPVFc1?=
 =?utf-8?B?OE5QMTIzclgvNXcwcXNqLzJTQ3dqTEErNUVzbHZkVGRRSmsrZk1ZNHVSQTVz?=
 =?utf-8?B?Ynp3a2FlTGhQTUdBSnlkZmduT3dMejRYcUFtQk5aQWM0eGMzUjI3a0tEY0Vp?=
 =?utf-8?B?ZVk1djdxZkRmSVFzWGZnemVsdjJwM2phQ0NmL1hONWlEbWdERVhOQTNlWEJK?=
 =?utf-8?B?R3M5UzhOODdPY0NWRVcyOG4xQzIwUUlIOUtFOXVXMlBaMkRSem9MYUZETlpB?=
 =?utf-8?B?MVBKS0tqZ1FKaU55a3Vya0hVNUFsaHprS2hjdStqWkF6c1NodGNtdGRsZXNh?=
 =?utf-8?B?WEM2K1hTaEk5SjE5aU9aRGVpOFg0REVKRUEyeVhoeHNZNGh4OURPYXJsZEJ3?=
 =?utf-8?B?REkwYXcrcFpITStkRm84eUlmQ3VCenpEZjM2MVhiQ3hhanBHWm12NDg4Wkgx?=
 =?utf-8?B?b3R0K216L2YrYjlnd0ViVEVOVSt2ejQxMmp6dnJCU2wzK1R0dk5QekxIUUVS?=
 =?utf-8?B?OTVuWm1GaFZ2RVR1Vm5NczNoTnU5RkFjRS9RMWtFK1dJSXlua3MrbGlGaVNB?=
 =?utf-8?Q?czgXLtjCzzhKmD0E=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc309f30-a27f-4246-9a95-08de4e41cdc7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 23:09:26.6600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XV3G9QM1sbJMJkoBIWdKjmn64C9xDDNbJgvlAiY13LRiC8NDodz4Fs9jQeX7cvMbvtrkI3Pp9BXjBz3/5IAROqjsf7reyrsZidBX1jZIVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5152
X-OriginatorOrg: intel.com

Hi Tony,

On 1/7/26 2:27 PM, Luck, Tony wrote:
> On Wed, Jan 07, 2026 at 02:09:35PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>> If these DO_ONCE macros are ever used heavily in run-time code, it might
>>> be better for once_lock and once_mutex to be statically defined in each
>>> invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
>>> that the static key protects the spinlock/mutex from being called may
>>> mean that it is practically hard to hit problems.
>>
>> Which problems do you have in mind? One problem I see is that since these "once"
>> functions are globally forced to be serialized this may cause unnecessary delays,
>> for example during initialization. I do not think this impacts the resctrl intended
>> usage since resctrl_arch_pre_mount() is not called during initialization and is
>> already ok with delays (it is on a "slow" path).
> 
> Reinette
> 
> Yes. Unnecessary delays due to serialization. But that only happens if
> the first call to a DO_ONCE*() instance overlaps with another first
> call. It might be quite hard to hit that during boot unless there are
> many uses of DO_ONCE*()
> 
> Looking at this some more, DO_ONCE() is overkill for mounting resctrl. The
> static key part is there so that DO_ONCE*() can be safely used in some
> hot code path without adding overhead of checking some "bool done" type
> variable and branching around it.  I don't see anyone except validation
> executing resctrl mounts at multiple times per second.
> 
> But it does make the code easier to read with a single line with obvious
> meaning instead of multiple lines with declarations, initializations,
> and if () conditions.

I am ok with using DO_ONCE_SLEEPABLE(). The next question (perhaps nitpicking?) is
if it is resctrl fs or the arch's decision to use this. That is, whether the flow is
something like below where the arch decides:
	arch/x86/kernel/cpu/resctrl/core.c:
		void resctrl_arch_pre_mount(void)
		{
			DO_ONCE_SLEEPABLE(aet_specific_call);
		}

	fs/resctrl/rdtgroup.c:
		static int rdt_get_tree(struct fs_context *fc)
		{
			...
			resctrl_arch_pre_mount();
			...
		}

or something like below where resctrl fs dictates the function can only be called once:

	arch/x86/kernel/cpu/resctrl/core.c:
		void resctrl_arch_pre_mount(void)
		{
			/* AET specific code */
		}

	fs/resctrl/rdtgroup.c:
		static int rdt_get_tree(struct fs_context *fc)
		{
			...
			DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
			...
		}

It looks to me as though the first option creates opportunity for better isolation
of AET code into arch/x86/kernel/cpu/resctrl/intel_aet.c, specifically, it needs fewer AET
stubs in arch/x86/kernel/cpu/resctrl/internal.h. I do not envision resctrl fs needing
to call resctrl_arch_pre_mount() multiple times but the safe pattern appears to be to
place DO_ONCE* in a helper function to ensure that only one static key is ever created.

While the first option allows more flexibility to the arch that should not be a reason though
since this is internal and we can always change to better accommodate arch requirements.
The question here is just what is best for AET support. What do you think?

Reinette

