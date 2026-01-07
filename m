Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BF5352938
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809114; cv=fail; b=U/cC2/T7B1Z+6HsLDmQa6PMy2sWnClCoTKMQyiMJ4sdR32qMv6f4w0YHx9u/1zAV1d4B42K+6cZVO2cfNbsuZDuciPY1AxIn0tQdmwlv3jNB7jaF8lG3rF5sx8P/IFbxzOfmNnuhelSf7e2XQkumx2hc58LtUsyIQp8YbBHfHf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809114; c=relaxed/simple;
	bh=Nc4uUL/Kh+SjYOUanwU9INLqwEY6aUKGVS3Uxg9jYGI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R7KW0XTwMp41/QY/8Uw6fp8V4pYTh4+kXV3/Ls3GZxNXS9po3QKT6V1ijprOBofJfEHjBo0/Mwwes9DjygDT2ZVD0E4E77rWN3boca7H4cfF4WJn1JkI0F4VisAfCMRfjoreRGZLcMNsKMg/BBllnvWSNj0vhvj12yKNUQsG9FU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FVAEy9XO; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FVAEy9XO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767809112; x=1799345112;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Nc4uUL/Kh+SjYOUanwU9INLqwEY6aUKGVS3Uxg9jYGI=;
  b=FVAEy9XO+pvXnHREulwWcrsu1u8REqhTFY75e+HdJLLDjSNhOAwLpq9j
   Glqf5EFwECU1HL1lAE7MN60a25TZ9wE0nbBo1lo+0G0IAycrpgjr/kYyF
   wr8f/IU1QJimzNxUtDkv3SYqjmcdGG8gM0xQ+gVIV4SJUj7YQXQsPUz5E
   Ddw8yRRQIvff5jWcpfc17WDP53J4bC4El/VxqTtn8gRzeiUwVy1Nr4PCE
   gAA/SCnjR8v3tCUiOyyNnjj+7eFLcwfhYr9ylDbUpxFpHUSF01kEXSHyr
   9I7yhlDMpwVb3bfocL0e0Bt2BzHbaDzSCCE+VgHmu6O0oOIhnKJyIKM+7
   w==;
X-CSE-ConnectionGUID: cwevGrsvS2ehufOXNnSrpg==
X-CSE-MsgGUID: S99JXXyPSGKCjrGHV949fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="69083856"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="69083856"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 10:05:11 -0800
X-CSE-ConnectionGUID: dxLC3FwnSv2BfMGUShTcnQ==
X-CSE-MsgGUID: mIKgZz0xT/q/kWPayumNlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="202193956"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 10:05:11 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 10:05:10 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 10:05:10 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 10:05:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSq5RSYtOOh7GoO3SCwuSKyArtLzrqtov7nzVd5tMHdNy0deEs2aZdj2ymzJ4jhZEncfHqnw3+RpwMJbHCBq3q1HOjiovbtxhVGBb+IbzWrCiMvLTn9PM1Kefs1Gbl4TqWe0oh1Fkl42/fGmp9v03fm4kSnSqeYOmL0hKtclY1+vIOBK9I+3mD1zHdxUxJuEnHC6NyBr1kfXfuowJJt3/kYEVCv4xulOMEqtGbUXrAg09npI8dVJeWQdOORWr7snm9WWaP0y1RmYyMI7Le2JF5r9+oXFTqsIHPnwYlEsCqp2tD3kf3ClR+nEBH42spUweOIPC1jvX5UM27mQxSJ1bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tivRdZhQGFbt8C1TwOPjhZKPcW3g/+AGKs44pxQ7+4o=;
 b=xqKz2gr5YC6u4YQgA33/MsFxM1z9Cy2JE5krEdvuV6gaUk/IQedAUMdujhZx42xRzvy2PlpYlmfbd7Tx8UQvvRzGSO9lSxYn/hkI6jWwhhRH/Fp+UowOPOX1mbgf7z7QC8v3rrvnc9Nay5y2SE9D8qRi4HnsGktTNdYwV5PT/r8IBBslsHMr3UvVhwWV6fyDhtZAK045N/T59KP+WHzGIGt7G6h06pV/PcrC6w2vVAINbxJsYycCMnhX2JxhxXaNFTSp0hVNFzYHGeGyxEM2j0MKib+TNeQopoJdtbNlflGRdLLV66l+QbyIvU9sVwy0GhHSVSGMr9bAH14W/c9QSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS4PPF6915D992B.namprd11.prod.outlook.com (2603:10b6:f:fc02::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:05:09 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:05:08 +0000
Date: Wed, 7 Jan 2026 10:05:07 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <aV6gU-lKrSjA2hDs@agluck-desk3>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
X-ClientProxiedBy: SJ0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS4PPF6915D992B:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bae0add-6a97-4e22-4328-08de4e174b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WhRDdzGoESrY/siEliKrRB/jOiRrX+VVOabuOCZvAPe4h/RQrV3nyRUn8Dzr?=
 =?us-ascii?Q?BSGJOLEPs0yflbcdCf24pg4zAwN/Y7JgJtQNz11nEcVCsqVVMVr9v/7UrhUg?=
 =?us-ascii?Q?ekVXU/ujwhf1Z8dQSedhgkIXGhi09Krr2Ucaq+JV6/BkVjN9AaTiEBSl6yYX?=
 =?us-ascii?Q?FJ4CgqtSsfva7Cu4WcWlItC5jvorBLeP0eHmiwCVt6WYxb+1aHRsZYM9VfkU?=
 =?us-ascii?Q?Bst69VyzS+SH0/+dndvHpvLMMEqLsAjQpZ4QJskO99z0MiE11/NhVCCNtxZH?=
 =?us-ascii?Q?mB9DYbGfWXHM52no0RQjMfKYBvPCR4T4sa9MyaoRdXu2INw3l9W2rokBeuA2?=
 =?us-ascii?Q?Kw493qMdIP7ufdtPCeWmCqjO7uAu8xWvnYpdhAVY5HP3QMaaqjLqb4g2rM99?=
 =?us-ascii?Q?SC5t1EfGe1fO3rNjj2YWp2A2235C61Xt+ODJvPoR3M//D8BQbnuhFSIKflx1?=
 =?us-ascii?Q?q7nV+oSo3HtTg1Q+hz6lSUdeh6YyIcBqOirheDudrRHARdax9/SwnAwyHfGG?=
 =?us-ascii?Q?BhE4pvth1R8D/NfpAhgS7MR4e0ITsbwfOqBrk3VB24J5ial1rX28sRlL0T1Y?=
 =?us-ascii?Q?G2JETf3bUka3iUwbRgBXGybWmZ69PETPyN4o7LEr8I/nRAHEGsMi7bq5/ynV?=
 =?us-ascii?Q?JAMhxJW4VaVsHZ7tKZF3nVpSNnyHYOPg7wvQMMmcPNGClVMvE8UP4IUPBPxc?=
 =?us-ascii?Q?B4ROAYo0b5vmsuT7uVK/Fr3Ly2XfO7NroFXySYAe6f2n8lCMSKWvUdXFCloe?=
 =?us-ascii?Q?DvX/IRdzf5Uc9HDrQnZdpU8JMaWZBb2cNi9DONOzKuGSBkp2/JLnQDkJsWb4?=
 =?us-ascii?Q?M3IeYD6KUK7bn7ftzk9IWhMp18aBb6gYfk26pXAlYt2ZO7H1aWjwc7WV7e71?=
 =?us-ascii?Q?Ah863vbIwmTI4e8N7NXPcJ8KkondZIrOwB1yGheTwguHNGkzg7N/qaGcQtbj?=
 =?us-ascii?Q?3hcJJ/Dt9TnDQTpA4uefpZ4KD+wDeB6NQLxwbZxatMIdEk3bfc3RUJdxSL9r?=
 =?us-ascii?Q?jWAly+WOSRmLvmxguiZGqXo3c5XUp1kyTPRzJ8PXQpFDLN+u5tBvrIjkgMnv?=
 =?us-ascii?Q?yeGrEMmQtqQ8Uo85/WGSeKbJ17AluGPrf2iuvXxc2rOwOFrRPXLRhFIJzu00?=
 =?us-ascii?Q?HDhkOF+Isz8V8y8BxVdZ+b6dr54aNjTsvq6ZRmNdz5+GjHg1jLvQpozonhvs?=
 =?us-ascii?Q?LEB+bRH81vvte0NJGF3x0e7FntiZdlLRRCsYlf5H7OaU7vnsak5IF7JZmQp1?=
 =?us-ascii?Q?jc79RkBp43CXYD1O9ILCvMwWbQkp6grMs7JMrobFOd6pwjd0Eh4Nl2bJvS7U?=
 =?us-ascii?Q?JTEpoQVslnNcyP5geF6NgFSfXHYbdr9EayUbu9Kfszlr9+YKal/wGkl970se?=
 =?us-ascii?Q?fHcV8VF9s2yJu20g+HbkZjad/0A6b8FIRpiQ5w4pJDkDUO+Jcb9A8/kuu+6O?=
 =?us-ascii?Q?A2YbMoKDP/6EXjJ8GT++zH7QAqo4gBu8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSV+MP1OH/cfN0VvvploionhNZYlx92YumaxgCOB9+PmeyjFv3jxIJF4WDi4?=
 =?us-ascii?Q?ccwFGj5yHK+oZt6D5BBF+0Sc7Jw8VRmt/r0E0Y69S8FyfpvWegibn+NQPNGN?=
 =?us-ascii?Q?oNQiqxLP1DHj4R5Fzgnly+3w6GxbNNqm6S5jc1wIZ8Sl5bsZluCmRK3paSDs?=
 =?us-ascii?Q?DmuBIi1cpagROmo781pIxoTo25GS78o43b4+yNy++CWWXMt0VVXQGtE9PlE8?=
 =?us-ascii?Q?zIacUHhDwyXWuFiXmuidRpkVkebSitWTjyY/oAkRmzLHBjqURs/oyjSA38yG?=
 =?us-ascii?Q?3zrCrTrPz5DN7EPuNYDr/IzyQBYdLU/0dlH6qQ3l6T+kK5cKx6dyGVLYv+xf?=
 =?us-ascii?Q?uqbOLaxSRRPAuod6XCzBwg4JMkF7vfQFLJrJFZY+eSD+ojhSIjpP9hyvfRQX?=
 =?us-ascii?Q?VUPvoagn6eVHKBPFKAV1pzynpPxZTcmc1YD4YN99xV+bXB8YckhzSpk2FE2Y?=
 =?us-ascii?Q?9dsuhYEBTcCWFbLUNCGJeRjRUvFcqzgM+RPRzn6K1z+Q6rx0EZRYB36O6d4b?=
 =?us-ascii?Q?usnhQElqifVwWSeAW8hKrMs2v60Ew+ndlALk8i4yt/rq30OPqRtxJbLnFnFi?=
 =?us-ascii?Q?NwSrIXpiuE9DZkCzZPeAUqhuQFmGWEkJeCsaxUArRkA3ZoLAh+z+FyzUjkZS?=
 =?us-ascii?Q?lIdipK+Rl95oNCiGHKEDcdd6WNLYzIktZWYX916TZzM3OUKlix+m3ZI71uzf?=
 =?us-ascii?Q?qtx6lm3J2QJZ9XReKFsaAsAQGaNvpmDJs2TrpLi7DqtnbxMcSEAEXOYgF+zK?=
 =?us-ascii?Q?Wfkqrkx06IesAOrA65UNe1nyQte/z+ZPrXZmImfRiaMJpMlHor9XUI00GpT/?=
 =?us-ascii?Q?ZJoY+ihm3URIoNVVWHxQICpS9e/sa9buHCPWGLLObbUNslWLCLjbO62IG39c?=
 =?us-ascii?Q?gbb/JnBxJOIDlpx6jaXjss5q267UPTvGwEQZR8R6r71WISBS3DYI8aT1pkIa?=
 =?us-ascii?Q?EtZigqKbhmzXr10nGRwA4X5kCCb+0xxkkey9TXxNbJmkZldXl8mxAiRfJw+B?=
 =?us-ascii?Q?86qILbjR2xGWgoEIeXkurX8qc0HcbmEp9pR1PjmyEcLzTxezWczA7cBEWY5d?=
 =?us-ascii?Q?JdmsCu+LJA6KA7RixVIGcHd2/KEoqMqBeMRQmqS3mlOPN12mGg+/xZEF0kPX?=
 =?us-ascii?Q?aJrf7oSUJzkVi+o8jKKbDZer5ClPZcE7AsaylcBuHEzNkg6e9HislGVG3+l8?=
 =?us-ascii?Q?+bh3FzJJSrPUx69C53ghiUlLSMDzsy+oBrW+nlLxwfFWMZR6siH8VRNkp5h5?=
 =?us-ascii?Q?V2HwBBqwdnyf3PTRWVEeR6eeZKafFAdYbLlk3VXpScUXMg7tdC28pmGQ9vsT?=
 =?us-ascii?Q?KJrnsQfeRTZWkXQMEbcnXcDCmWqtR7Ho4SV1tdNCsGJ2BEYb+I/brbfp9/Lk?=
 =?us-ascii?Q?U9pLrr/QrGfv9hkzsknV8JRq27uGZ0rHcmj2s1ob5O74pRfi3WxwB1cEz0H3?=
 =?us-ascii?Q?7/INAKyIBTzgDli8M+ZWpcPtY/W4EX0pCbwBj/WtirQx25/INfWMtl1kyG0M?=
 =?us-ascii?Q?UdZP7MfQwA6D2yFyyPzAhyhOnqrsqjtJBy0P84cLBAsJvQtRW5B/MVUHnGZP?=
 =?us-ascii?Q?VkImHFLJXeWj4bvv64Qj6qBmqdfm3LJJ5BTPB1YH55kWlgYoUGWzvPWXLHB2?=
 =?us-ascii?Q?uX5/75OSyGGv4l5+WJ8Tx+WNDvf0Gb2MUfTYNupNoK4aWWX95c4Mc1PiArsp?=
 =?us-ascii?Q?aSNq7w0rjLhOSA7BIcXPgPFnky5Fpu1QJVMF7n4Dqxva/yRMUK79Sl+NPgqr?=
 =?us-ascii?Q?qLXQmTsXAA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bae0add-6a97-4e22-4328-08de4e174b22
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:05:08.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCY2xDS2bqlkihnfH7FFJRzS9Eb+x6CVLl61sinxVy5ggVBCAUG1lD2CpUWrqnPU2zPzB62Xp49WFmIZqFMfcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6915D992B
X-OriginatorOrg: intel.com

On Wed, Jan 07, 2026 at 09:29:27AM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 1/5/26 12:15 PM, Luck, Tony wrote:
> >> Ok, if it works and passes testing, I could wait for you to send me an updated
> >> patch and drop this one.
> > 
> > Building and testing now.
> > 
> > Reinette: When originally developing this you suggested that rdt_get_tree()
> > should call resctrl_arch_pre_mount() on *every* mount (to make it generally
> > useful should future changes need something to be done in architecture code
> > on each mount).
> 
> I'm digging through the history just to refresh on why I made that comment. From what I can
> tell this work always called the AET init on every mount attempt. One difference is that during
> v2 it did so by taking some extra locks before doing so, but still did the AET init before
> resctrl's "resctrl_mounted" check. The move to current spot (before extra locks) was made in v3,
> and looking at v2 comments I could just find a request to use a generic resctrl_arch_* helper in
> fs code instead of the arch specific rdt_get_intel_aet_mount() called from fs code.

I should stop relying on my memory and check the actual history. You are
right. The call from rdt_get_tree() has moved, and changed name, but all
versions called it every time.

> > 
> > That flexibility isn't needed for enumerating telemetry events. Boris' suggestion
> > to use DO_ONCE_SLEEPABLE() would revert to what I had in some earlier
> > version where rdt_get_tree() only calls this hook on first mount.
> 
> I think I am missing something here - even the original RFC calls the AET init on
> every mount. Which version are you referring to? I am also missing why DO_ONCE_SLEEPABLE()
> requires a flow change.
> 
> > 
> > Are you OK with this? Or do you still think that the hook should be called on
> > every mount?
> 
> To be specific, the current implementation calls the resctrl_arch_pre_mount() hook on
> every mount *attempt*. For the hook to be called on every mount it should be after the
> resctrl_mounted check. This would change resctrl_arch_pre_mount() to be called with
> rdtgroup_mutex held though but that seems trouble since resctrl_arch_pre_mount() currently
> follows lock ordering of domain_list_lock then rdtgroup_mutex to match lock ordering
> during resctrl init.

Yes, the call was moved before any locks obtained because of lock
ordering issues with domain_list_lock.

A better summary of the change is that the "only once" logic is being
moved from open-coded using atomic operations in resctrl_arch_pre_mount()
to using DO_ONCE_SLEEPABLE() in rdt_get_tree().
> 
> Reinette

-Tony
