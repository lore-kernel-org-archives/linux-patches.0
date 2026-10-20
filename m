Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792506884;
	b=a5hVqRv1C3Hr6k4+9CZwMPJxWazWnVPSU8p1qVxjt9AEhv4SHLeOkwQ+Oy0nOXEEAAwu
	 ngxr0bf18chYQarpmzL5Lv7NDyOU9Q9+TKOipQVxYbLzSXQIbxX2iFnRgJMOoaDJWhiBd
	 9U6Lv0PdQ69tTUbUF3DTVU1U6oGboBtW14QtF+h82hhsfRSgiy+nsssy889/gLcs0tQO8
	 PVxHd8bhZtP1p0ViTPBUjfhBd+sHwhJIByajIM9JqgEYmBIeYXq88iuPinY4XXrCS51lM
	 T2a7h0aKmOQUC9SmtKBpT1zZxsJ1s7DdfhRleD+1bc0lmlW7QghO/BtkExQ5XsAA/gA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506884;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=lGmOWdSn7k9LR9Um4PCcEghq2bUx4eR7JfDMRuBsLVY=;
	b=pgXyaHW6Qp5honqAzC7aTeGF04faHQbie+0xgi8j06MX/g1ithun1QhYWiKozs5eGkia
	 TZV9gO59JoFg1zeHzeyo1a1S7vKI9MR4g2Je4hOYCken8DWekarAASX/qv/GlaO9OLcjB
	 UetfPjEVKbBgZmbT43AsNWXn7Vmcj2ZMHn1GbVPGjQpxbV5tTaNjdEsKwVTddkyAXlW69
	 GPgmy87yhKMWy2IKFIZHmxuJJXDJi3IhcoTdIITfqVAbwk6I1t2h+MaB2VyDCTvyK2K8C
	 V7S0bIHanr/yjva4Eb6Wu2VR9aoZIVAFltdZrPkz2GuSPO8LCcnp7OzfwS3AszHbj9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mMuI6P0h;
	arc=fail smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9A606A32F
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 14:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38F9A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mMuI6P0h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792506883; x=1824042883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jLVD/PcWocMPCuOw8dnaCrL7rmKbsqn2UbaP3iBWnYU=;
  b=mMuI6P0h6/8pyf2EL6OuxzhN3w7Mvi0V7HPSoyKmANlDTylO2gfXSp5T
   NMsRBNB8Xb8lFaHLG1YuHYiXwGfPjqfOUzc0CDF7OETlZvdbZ/M6amAG4
   I4qS70bgMkloT2x6bPwbZiFulJ6DDu4meGfdU6Vv6yu9QsydxV8hy3nyI
   XwAZfvpmf/ZgKfhEnpXhMwyW7OaRGhyV7/xzecI1KPCTfQ951EQiuQibY
   d+hlGm0VDba5c2NykHmaXqgE/lw/de30GPcNWbstZwncLwSU3iqL5ALke
   VysYF2y/zn3zwT21rB2TNgZboYjhohRIYLaio7QkCNM5KqQCTk67cLQeD
   g==;
X-CSE-ConnectionGUID: AGLVhD9+QQWcJgZDVagBOQ==
X-CSE-MsgGUID: NAR3h9nlSr+3Ppo+5vozxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1210094"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1210094"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 07:34:42 -0700
X-CSE-ConnectionGUID: Ve0CvLOTT0Oha4ZOgIba5w==
X-CSE-MsgGUID: Alve0D1mQNOU+hw4Qx6A2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2939347"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 07:34:43 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 07:34:42 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 07:34:42 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 07:34:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jfdt9/6ptk8G1W0a+h0/18YdR0pJT00SdSSQGlSlku+ibbscv/OxT9IXG8RkeK+CxCYs3n67PRum6CyCYPkHfuJh2wKCwvm1lzFDnUdXjT9o68Lke1sHFu/hYiy69Z1bjfT0hC6ipg8N2yGYljs3nT19X5FCCU7siNtiFvKPbIlYwIMyZ61kOqLM4agVYx1r2xwUmtEEbOG02mPKdvDU6ysTUNh1gWRkoPFzjxDfyeYg51T341I2iUpIBzhzkSzqZEuTfckiuZOz8MmG8r937d0BUDnOxhP39VZHQey8ZugFS4eZhEe1IFAgn4yMYMrPymRKh2fKOCF3of7oq0L4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lGmOWdSn7k9LR9Um4PCcEghq2bUx4eR7JfDMRuBsLVY=;
 b=wWcsebxG17C14Za3/xbXNlZf99bvMgK1t+ruR4+hKEtv6pDF4YnB0S/QEJS/qJ2xx8UtxNBqxCQpLFSWGyNz4liFb6+mrcOH/OwHStgurvcHXxROvnEvtKgZ21SfotL9v/1dUbOe0QUsdfT1j+5iPSmg5IXrVEgE6cn0FHY52o0HFJ9eCNi848gh2mxboEJF72vwUGbS/2Phi9ICaJse8Q84SfhSQMpu964d2KYd90mTVttwD/B0nvr4A8v/jfCqTMhXunCp4eM0ATe7LSMkmLNlKkVeE+WBAFFjKoVOz74MR2iUCCl6WPf5dCOJQejbjbv7803AEGpBThkPI/c64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19)
 by DM4PR11MB7304.namprd11.prod.outlook.com (2603:10b6:8:107::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 20 Oct
 2026 14:34:20 +0000
Received: from PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae]) by PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 14:34:20 +0000
Date: Tue, 20 Oct 2026 22:21:22 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 10/24] x86/resctrl: Honor rdt={perf|energy} options
 to force enable AET events
Message-ID: <atd44s2pJfgs403n@chenyu-dev>
References: <20261019205031.16977-1-tony.luck@intel.com>
 <20261019205031.16977-11-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019205031.16977-11-tony.luck@intel.com>
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To PH7PR11MB6005.namprd11.prod.outlook.com
 (2603:10b6:510:1e0::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6005:EE_|DM4PR11MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: 026c58cc-ff7c-45b1-d279-08df2eb73a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|22082099003|18002099003|3023799007|11063799006|10067099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info: rrZNWPoRsFY7grf9C+szDKSqOqvSojfrPECzrvNCQcoW42Zvkn+8GIGlaGcHItXqF8yLJiDvGk5EsssckMD6ZwblIOjUK1dE3hyECD8SMm3Lm0xqhh0QAQvFv946UqIK3iszioU5a6tN61bpeUeQSu2aby8ZgcAX2bYDkrC8K8Va53dlDeCc9uvvxgohLFIiHHEj3qAZl9XqAAUx3YaXUj+iBt4mcQxgUmGL4MMut11dSpVDJI5Lj/hf+D4HGVwpNM00gz4eKp1+h72lrOPoDD04Olgu/LOGUgZ541++Nh5WhGbMutNeeEzoFPLHGNPbSWI9KUlh3UUJYs11FWk1ZLA0fPkcgVX3ARXeZXTIsfUu7x6LDaZFD5Y6OId8iYJLjrxN1PD/GCJenpGcTAq0bWnqwMGNYXUYpMjWP8ZHXQCFXOKbfQOdB2gihDcs9TS6YnJ50bRdKaFUlFtiuVIF9uUyW41A6JUuOyuM3B6MCi0nqt1w34MxYzRRUHKnrbsFbDM3vQvspAs0NOYK8rlTIJiBf+RM+E3u1fjOQCDC5Lhq/7GvU60313nmxFgmbCwgeJXGftPhefRydTGMxJwvPyMI1XheO2sRF8hH66j3kMCY106xAFIsJhowcauK2MdP4AJovvXNduUxk8JdNnxEHZ3JZRM54AgqJ8vlf3tlp6c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6005.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(22082099003)(18002099003)(3023799007)(11063799006)(10067099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2yZNbfHhPJhW22BnEVsSD6ARuuUqE8D0wrY60q2TddcQR8zy69PkBdMOZ2n?=
 =?us-ascii?Q?fedPavtBopV+DVvz1yR/dY2K3Tcdl2DPe0hiyumVtqeqZqdEm55s32Dsne2x?=
 =?us-ascii?Q?U5N56IDn6SHQPkmyXVcozyO9Ole+H4VtgyuNuyxmHhg10N1Ghcajfpjv7m0x?=
 =?us-ascii?Q?LPBS5z9QweaYOHUrTCsSpHFudH0HBMRUvQPVHr11dCuwpeNir/vzJ6CHEDfe?=
 =?us-ascii?Q?WkASiLfMr7yJj2qvtzmmbjtV9NHxAcEodypc2TJHK48mL52TjZx2kwXAGY38?=
 =?us-ascii?Q?TRF8veNI5tnVdemSG9w71SCU27l6RjoQmpXmMW667N1XFMPm8YdKcFAh36e/?=
 =?us-ascii?Q?GxHjYpJQzlJKb/8+NdZdAXvDS6arsY4V65ZkEQ6uuDlLwAiBEhN0dum2fppJ?=
 =?us-ascii?Q?X4Nn4EtPeq6U34cF1ozKxsDgnhVa/PE2b6seR3rw6kBos2Mo6A4MbDHEghGW?=
 =?us-ascii?Q?6SqYE7fFBiAM0oopTxayii+MUZuBj4ySWAyNicDUOl/aqEI8Uqs4T2iXDlUf?=
 =?us-ascii?Q?W892LsjCnhpiupoVEn1ab18yNCwmD4iaGVm1EYUqJ8ivLv/BWgw5j7eVElDX?=
 =?us-ascii?Q?8So0CvQtHtkq1HmbGDfiUO5EBY3bjSi/etP05AU9RKW4njqJxlG4PjVYQxZ/?=
 =?us-ascii?Q?ymDNWFvhaIeuoedbzd9on72tBweurPeTgp5BsJ+P1r5GWKhzmUAxGfisLWfC?=
 =?us-ascii?Q?Pr2iIvU0Qw+OE1R+Kf3ln/RikMh0SwMppw0syEE2H5h9FbZN0iMduTRR3QzV?=
 =?us-ascii?Q?et9X38A6gzn17rHzCtt15at6sFQdwrvHHRjiAZCTpQgfPNEd7rO56Sx6iztJ?=
 =?us-ascii?Q?cv7xxwhUBT5FZrNDNURZi7okdV1e57Ud259Z08nZc3vMhj/nFvPGrfYIvrA3?=
 =?us-ascii?Q?2xKNmZZQP4iJtUVeBIA9lMtx0lKGIqgnAF7rAlPFdUHXVikF5GlC1OO305We?=
 =?us-ascii?Q?9w7e92RGOl6IPJNQI/Qb+JE8ccekrjsDCynZP8Cms1ruvYYFBwkYxJGq/4yO?=
 =?us-ascii?Q?FgY5vCaqeqEhFi60zJkrzYWGvSytXC9VaH0Q+vjQm+QspN3LonUGO6xgb5uq?=
 =?us-ascii?Q?lrpRNV795W2yLAwEf4X6NvzoAKNEnrzfz3WcQG5qG1L7qde1ZFfoxw0CDkL6?=
 =?us-ascii?Q?va+vIJmO7RAlMjaVOSQN8Mv5Bmz52unlQtcEe/9O3nzgUS1Dv9SLT8NIjb0F?=
 =?us-ascii?Q?ULq55DCBrOPAubu+TjzB1SP3sznUqNoS43IrPRe9mKRUK0S3RjH6eSzCj0Jw?=
 =?us-ascii?Q?DtiNN9Kfr9Ua1V9moQMBYqVXVoJIm1nyfLDQ4m7NAYEipu4kY7bc1UU8CP8S?=
 =?us-ascii?Q?jcGeBcqRxcfIFHqQZ1dBpDsgJb8C27LCh+7OhH5W8fDq0fEYC1bh2OmSREBv?=
 =?us-ascii?Q?ev2w+Up/Hq47hon/1minnwnsyIoX2z8Yjtih7aYUem1cNqxYUjsYpjiXP+cA?=
 =?us-ascii?Q?G70VvUOMdfAy+2piM5ms/pA+oKJV6fUwnz+0bcXMi6s8MNSTxb7pbmLKWZeK?=
 =?us-ascii?Q?JeYOvdLnyEY1kI//SWTy9qJl3qu2/rtyOMknj1pb4m0aKDrvaP6hOzaHgSxq?=
 =?us-ascii?Q?Ox6NpCpty3CC8oKRQnsTy3wxLwlUDYyAf/bg1OVms+82h3Y4rFsvMNEUuC+0?=
 =?us-ascii?Q?N4nmnLzWhmPToclpHf2EWCEvRRhe0US5wzjcDMjM2RTJ7D99VyealkPFsiC9?=
 =?us-ascii?Q?DFDmFjvNVK1mQq+Sl7pGkkS9plyUXtIEWtK+1y5KtBfEIgOwniLfzp+h+mkz?=
 =?us-ascii?Q?dJMBhgipAA=3D=3D?=
X-Exchange-RoutingPolicyChecked: KMERLwj8Mcc0LGYIYW/A/Z+1df/Y6JZLusBhc5dWPUN9swb+L+x9mo0oUat9AdK8l2XHhn+X+KPN3Cq2ykE1CLTp5R3oCwlSycR9zfMjeHeesmUefwJu6yHQwfaQMZJmlu3tHDCs8rFjoiby49YpS4mODsyJGcf9Q9dUOJnouBNmRCMfzLAm7FLUN+gHZxWpT8FpkMfpNkQ7EZQvgz12nO4ghU2IERLVIHHpVigma0g0UUvQ2b4LzczpjwWM6t85OklFXdOcHckS5xAYSESF5IEN+N8+aKS20WC9HEzHwFrsfvbE2holtKPUNDX4H/XhPDRc6tXuMsU8yALYnQUDIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 026c58cc-ff7c-45b1-d279-08df2eb73a05
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6005.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 14:34:20.0783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mp6H2dhsPNXIB1AoMBBOvp8sKxcPRnp8TM9b9s3KbyWR2JroD5wg5dNiiJsF3vgCpQlKHdsDbJp0nigiGVuoLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7304
X-OriginatorOrg: intel.com

On Mon, Oct 19, 2026 at 01:50:17PM -0700, Tony Luck wrote:
> resctrl can disable a feature the platform supports, for example because
> of an erratum or, for Application Energy Telemetry (AET), because an event
> group has insufficient RMIDs. The "rdt=" kernel command line option lets
> the user force such a feature on anyway, and also lets the user disable
> supported features they do not need.
> 
> resctrl enumerates AET once, on first mount. Enumeration skips an event
> group that is marked disabled. An event group with insufficient RMIDs is
> marked disabled even when the user forced it on, but this happens after
> the test for forced off when enumeration begins for an event group.
> 
> This will be broken when AET is enumerated on every mount. The disable mark
> recorded for insufficient RMIDs on one mount causes the event group to be
> skipped on the next, ignoring the user's explicit rdt= request to enable it.
> 
> In preparation for enumerating AET on every mount, skip a disabled event
> group only if the user has not forced it on. As a result, when the command
> line both disables and enables the same event group, for example
> "rdt=!perf,perf:<guid>", enabling now takes precedence. This matches how
> rdt= handles the other resctrl features.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v14:
> 	New commit message. Dropped previous supplied Reinette RB tag.
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 66cd8c2c7a51..9f0829a82cb0 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -262,7 +262,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int skipped_events = 0;
>  
> -	if (e->force_off)
> +	if (e->force_off && !e->force_on)
>  		return false;
>

OK, it seems that the user always has the highest priority in deciding whether
this event is enabled, which overrides the hardware/kernel decision. This will also
be the design for region aware MBA's erdt:3waymba. Per my understanding,

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu

>  	if (!group_has_usable_regions(e, p))
> -- 
> 2.56.0
> 
