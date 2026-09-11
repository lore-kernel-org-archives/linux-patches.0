Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028734AD7FA
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150902; cv=fail; b=WNB/oNb/+AnACFSVNyC9qEgnKnc/PIokouefwLyXW8tIJdFsGQEdcE8mX62qgmFF8ZyvJxDnp5MIOzz4TzQo/NNH0D/fPvEkHlZEF4H3HwMgD3xAGz7YOzXOVuGIl9fuACDYXJS0P/Ke78Ba11MS/X8z5gK/+CVHED/tx4QJL3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150902; c=relaxed/simple;
	bh=w7psfYFtq+4CQKfkrQamoDMFVWRtsMsKqo9/zyDVAZE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UzhlKagdYveGdrCg2wsh4uc1b4KalpoqSG1c5LmjeCRzmMDHRTsz9W/YXJcaHP3XCO9UdvyAYKUOb/WL00cZRdtIZ+MBvV7+Ckguc9XIOTJT5X2ieJDoSMuyBq9PsB+d+jLbDPuHDC5rKaBtFGiLoaMXka0Ez2i+0tWGJe5XfhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BCK9iXOD; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BCK9iXOD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789150902; x=1820686902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=w7psfYFtq+4CQKfkrQamoDMFVWRtsMsKqo9/zyDVAZE=;
  b=BCK9iXODaUC8h4jZOQ1Dk7lhtAGiUr+xU3vAEw9rGKyKBCpPhLmktPuC
   06NiDtDZeICQcIZvfG0HC+Hwvu/DWMtyuP5Gc/tWUWLc/gW9Yz+icM75C
   5z+KFrRcP9QvhG6Put4QWgwEPv0mASozAF9GwATiUWHYy9kZUhIl+kw3q
   smQ9sOkDAy3EsS7ITu8S052dDBp78LsJxissAWAqwM4mYuhrMICH3J2WU
   TGQQTx5cKEye/b1Z9U0sIFbFYVHCXK/ojSmsk7YrLDJeUj2GopqBYJM/Q
   +duTC8lDlmbInklKmhBjaNtf0guB1qKZ+r2U75ZKNEvMAZgCPOXywlJoT
   w==;
X-CSE-ConnectionGUID: uMWfZzcWTnml7qf8R1qOUg==
X-CSE-MsgGUID: 8X59h2yGTx6yJ4bWTy1nbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="93315964"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="93315964"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 11:21:41 -0700
X-CSE-ConnectionGUID: xKz3UU3IRpuHvpklDZjfZw==
X-CSE-MsgGUID: LiM7EJ4YSriCEuP+gUWVGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="310254768"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 11:21:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 11:21:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 11:21:39 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.8) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 11:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2t9ARLwteBvf0ZnRm5onxEuvWKy9iNxqLaNHy8AcAR906sDZyn7BURt209LqhY+8YnTfldLKMhtnr2NwsV1I/rSMRqfFOrrV7Je4bL0me2y4nDgwLsySLfflMTVSYSZlzm7jbQ+PHCa21YgP3/G6YJk7Roz0hxb7q41Ni5noG4WgNEt2Tn6S9JzLlt9uvaH5IQXuj2Ffi2dF6EDU8LtRpabIRShfZAcY+9WZz8ZRXMVD1lxxq/CHwu0zksKEwrIGJQs6QqXGHIEeOVkWAO1P0xQ2zDRFQaaw/EJtJTF0rEFDEw1GFNAeTG1EXSzyGFetL2JMZFpAOhi8Rl9wQwZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7psfYFtq+4CQKfkrQamoDMFVWRtsMsKqo9/zyDVAZE=;
 b=i6cQcp0A13l3iz+wHX98sxjMwp86n1xc0pkGPI3Rc909sK6WzIvkxycqXv27zmxT1sQc/DGx77ahTt1kxNw7SJsW0tr4ZlWl1S46o77fVtkh0g2P7dYpLHYFe/m4UwSZylLc869JalUfQ0jP3U7s7ZOY95zvjMJ7H/Jhenu5bXnxxctDz0gy3V/euhKY3f+8ZtWM8yeCCXRH+Zn6kV7J27jHyvhdpkmiyLah40iovEnls6CR51+Iq4ZwgePXSaA6erwFgDSOtMn/V6L5FsVyXdItT+loS0CLXlyg9BaIN2fNeSdEZKriAc025MPThCkCmiOEA3oHJs4woTpUx6FogA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL1PR11MB5301.namprd11.prod.outlook.com (2603:10b6:208:309::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 18:21:36 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0382.014; Fri, 11 Sep 2026
 18:21:34 +0000
Date: Fri, 11 Sep 2026 11:21:33 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE
 flags for monitoring
Message-ID: <aqRGre8eEhxycLel@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-2-tony.luck@intel.com>
 <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
 <aqNGFA6JtddxEn54@agluck-desk3>
 <6cd4a7d4-6f93-4970-82de-be483fe45267@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6cd4a7d4-6f93-4970-82de-be483fe45267@intel.com>
X-ClientProxiedBy: BY1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BL1PR11MB5301:EE_
X-MS-Office365-Filtering-Correlation-Id: 01c4cabc-8d42-44b7-54b9-08df103182e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: NY4VzP9sEPYkHSgvx2lzNOg/v4yCjjZZrUi5ITjl4HvTW62OGY9N+trjGwJDf1PZ99WihbAe7ZCXmVc8AHCZ/Iv5FhbIn6dK6tneb2WlmRtzoOKycJLdJEXs7o5p8vunkxaM/6z+l0EVtVnmNYMeI9As7UjqSyY+GF6yb8wJMT4iY++vs72wYLWnElDZrKeiOdKHZ0+Cjqa4c8U6212g1baxQMYGJylOB0/w+Ut8a0zKPicD2Wvwv0/Y6UNrBbSoORzHgX4YhbsRXH4IJUI4TI3pG4/06zgwnLcfk5iMr5YOF4MplVKCr+wRdp7VFnyWH4A10lyna/D+K+eWPURyYS585F+CNtWqB/lLnM2n+Yf3qb4qdUnGWpIJvIr7/0b7jpssZAQq9nNwI6IMJORWZ23M8WZvpEeca/uuq8vUQy4kn1lzmtKi53mNnAIWyrV6gHdIGE3gCj38KvHz4MEg+tIMZTRLMvwwCXrpRR187vnReAWY7Yr5gBUQDwr8jLIW/lnTbuvNZ1wFEO1Me0oTEWtDmDgx8shg5Jryqyax1FWKccqSi7cGXNL7XZUDABIN/5VfXjFAPS/A+e1TNt2r2jWLMefnc4vfzjGouoGHadugeWDO8cEMTT+rd7j9LMsMwygUyraD5G/SnQTMPg4JSsjibcme2YVUGYSW6qOlLEI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cC5p9Znuv620Ratu+A/WPl/9YDrviq4n73qXlRkgmzf2lzkfn9GENPH8L+mr?=
 =?us-ascii?Q?rJe4P/jg5r/PDEamT4f/7Wo0Ksa2o4H2kX4Q2TvnzPlaJN6w28wJOWt0Jbiy?=
 =?us-ascii?Q?bjnM/A5chRZsRgwHrczWrbP7tRQbHM34d7G5fthrMIoQNLEmZXyKL5YlThzd?=
 =?us-ascii?Q?Rkc2vRb/2a4/CDeYBvoK4tlH7Ohj+DP1IhDFCImQl0LU8J+9pst4yhDT50b7?=
 =?us-ascii?Q?Ey29Rbf3+W5rrEHv8OAk92gHrg6d2BxEjzTzQLSdy/T/M0roXSYrWpPxFhGW?=
 =?us-ascii?Q?wHkr/70L5FMF8K0FL82Pz+ZQV1WD1FY7qK8SSDdUVpvpmql4+tL7eg9FQ6Yj?=
 =?us-ascii?Q?/45bWY5Lvlz3XDya8hqy/QQc0mtSGVktfQV0zWo+oBmz9dLSOmSUA/92puMu?=
 =?us-ascii?Q?RMi/Ez94OzfgVC8++nYyio3Zpmmd7kcAAuEUtsTr1rJTov9y26w02ozQw4vt?=
 =?us-ascii?Q?0Fzr+7XQ+KjxEKzY8Ul80RxrVUXcFVJdfGJcV8hRbWf2xWpHttbUhuOUpXR1?=
 =?us-ascii?Q?GSHHVg1C0YIlQIf3cPU1NC1gPiMAuTMbpfDYcAx9PLFIJAQUi//2OsHZSDnE?=
 =?us-ascii?Q?BcEDa+ud6VUzr3webau07dYwoqPI1O2/+jbDPsqFRMVdiSRm24ff4XLphtbe?=
 =?us-ascii?Q?nbd03boUOTJpqGZ32i5ttT+8ZS4yz8KfYuqDsavSOv8zSl2A6inVeF6XNMoy?=
 =?us-ascii?Q?lNiRNvpZpmtPNHPEWju2C5ZdjK48/JDm2/h0H/DPf6UYskosOrtmrfebFYUL?=
 =?us-ascii?Q?syiyKROGcHBGNYku9KjbdUQTtRIaj1SK0xcmJEXf/vBgJnJXUbas77kZfZvJ?=
 =?us-ascii?Q?+2RBy7pX4YAiFUzCtZZFZmlLtpM3JJSyDjRSGW8sqbCx9MC6Ds2Qw9jpBJ+Z?=
 =?us-ascii?Q?UU1k2B7cFF+l5TXskDqV8F/H0Kk4n5w3rISIgEifye4cInWt+IaRAUzIijbk?=
 =?us-ascii?Q?hpRPFPGoRJbnzC5yli6suhIOoDTqXHrMyMuC8PWQucXX1rZ/uyXOCJgLT+0C?=
 =?us-ascii?Q?InEaG+lckn5ceSIe55vF4dcBGEArzFDI/h6vP1ivLjPu4xW6Gfo3KFueAfRR?=
 =?us-ascii?Q?ogJXWR1PxB0NmXT96ke5+OGyMWhedFSsiQsTHWvdyQGp8kns0U77sR9WcGCP?=
 =?us-ascii?Q?DN//r7JIJYk8Xfhl1RJTJPT8LfwaxaIxF2UKJzV0CVeYW0yCLXHcoeyxayXs?=
 =?us-ascii?Q?9ARTLmg3koXE//dEOSwcWh+ZzbiSUqZq1gcS1PP/ObnQ/sfKpdEeuCx/jBbx?=
 =?us-ascii?Q?a7kabzSHgOEbquFK4dj2F38zKvzqVTKJ7RV+/q6voyxnQajj0Un8Vrm0wWdo?=
 =?us-ascii?Q?AiZ6DEvIUn7/mDH7RefvttMI4/sHpSQfkegmVsJS3LsWIr+8a5IcoMKHHjVq?=
 =?us-ascii?Q?2HqJ+tUKM/PHTuYM+BCKIcluqLonoQoXSjxstYxQ+GA4MKjdt9siUhV6Zzz0?=
 =?us-ascii?Q?rtfWDPDEHLqwEjp96kx+9fewJrZaTmf7QZn+1luO5letqRprYdQoR7+evvS+?=
 =?us-ascii?Q?qu4AfDcysBZTIGfDN0XLMNUHvq1cInIV/MkzR+l6n1Dcu6gJS2w64GMbojtr?=
 =?us-ascii?Q?vnkz4qihyHrUSXhowY+mXLJP+AwVKBnEFwBIVTNRi+38m6bQ1pOULz3V+nhV?=
 =?us-ascii?Q?Sncwe6YT+1nXcos+TpGQFYyUEgV9yrGN8t3ZjpozlqlBuS7/LXvKZUMHFamF?=
 =?us-ascii?Q?/XYHKXmTF6JehPXiqW56kJu/sAI5RXrook0wChC00Qm2FJA6OPbTwgcQeDNN?=
 =?us-ascii?Q?nHzwxlBF5A=3D=3D?=
X-Exchange-RoutingPolicyChecked: vg2rXtj6z+ZB3J+7pYXtXdnCoI2v04/LEzmZkb3t8FnbnWHM7TDBW0oXljXU6olgU9zGGFIJH8bH97puSOPaNAt/QRnzwIROc4G3vAv+y406BHZ0LmSOGXQaELqfF+ukHP2SGRUp4xnPZVNTIg+fl6em/XwMcNsqLmbToh0W0bYrSXvkGvPJ0Kl6GCF7vG2ZksfQ62VOEufQLFakZXTa4YmxDufCtE0JbZKl7w2zZw+Rs1MkDppOSP52U8sEnnpwUzi+7tP+paA0vY7m1HA2vetQVEzW6a1UVAIMAIy3CFVwBiYQPniF5oXS2Mk/EATi5Z0Td1MnQHSlX02UA03vuA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c4cabc-8d42-44b7-54b9-08df103182e2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 18:21:34.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNYopmIxP0Kl5q8ZunY0gVLhO97Zwth9Z8Mdg9CZ0/8J+hoChVWa0FVhm3sMCK8RssRgd8hPshza4RIUmwFlxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5301
X-OriginatorOrg: intel.com

I'll drop the #define name changes.

-Tony
