Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709621A9FB8
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756160441; cv=fail; b=J3z8tQniL11Qh5AU2uqNZM5GHq4b7SAkzCdAe3XpQe+QRFrvLG7Rbs2wwVScnvXWul+RFoBR6NW4MvZjo06oq6sijnuHzGGjuyveWwP4qaOwyLBUL/X+5lY5XEvXal5Xk6EJMv9p5I8jT5kuMayAVVTC8QQPstzXZgbbnfsd5O0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756160441; c=relaxed/simple;
	bh=900aTwsvtTmBgcX9/4OInaIyMR0zcf+N6zzSkMdccuA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TPt46rdOVUYQY/0yFLH27y4MeacVRjvsrUasrtYAQn7M5K9lmeYEVIoOb4yBHMffnpSk3RIxXkIo+YNk+/9igwA8HGpGXON/rOgK05d946jAF11FuboMUE8Kmw0wmlMdkxsc3Azv2Rnql18OpY044qMS5FzY1KzH/vm4oe9jvoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mYEta3XO; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mYEta3XO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756160439; x=1787696439;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=900aTwsvtTmBgcX9/4OInaIyMR0zcf+N6zzSkMdccuA=;
  b=mYEta3XOnxfrg5SGDoEeb84Li4l1JtL+uq2chlQoGO5nxzIh5aO9KvqQ
   vgDspAQKPDZy5/BTMGmcN0U64UwUEI8GiiSppPR4y20yNuZFnDbJaIKHZ
   bgS0IpBGFyqmms33YxYnd6OvoCANcw4YkrdnoCEUhiIwpdZCHh79txNOt
   CmKoFxHwkzfDsDFkssBHf3CWUjXF8cxUFc0PZiL356eX4wqx9KTg5C65n
   VGLM0vvt8A8Why6slLi+L+IpZKqioHL8mxFrnclwVGYlZu/tgUE0jvLlx
   60I2xzHNR6DKhkmp/ybTaob9EubTj6lyJZSgeqpTfZRHIt367ifj8Rukt
   w==;
X-CSE-ConnectionGUID: XJ83LiESRYiaU8JS27kTiQ==
X-CSE-MsgGUID: vfhbpQ69QlmNKSpk5HeG2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62212830"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62212830"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:20:37 -0700
X-CSE-ConnectionGUID: Z5soPMcYSoi4b94n/EzFJQ==
X-CSE-MsgGUID: O65r5N9XSIqR+J1+DUAxcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="168618994"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:20:37 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 15:20:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 15:20:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.89) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 15:20:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnNwUJoapq6HFDIyLy781IilciD5pNIY2zXpu/XMpT0KynOUC1uHVZCs0Kmd+ymHKi/U65bEb1OYWo2kxVKiJQOEdDmphIAwsVgMx+6e3oSOKjf8z0SbgENgIIYrvQUfjrunxW98vOsllQupGmlvGpx7hL/tzxZYjij39HVB4iOXkU+A+3GNRlcn40d22NTzLJaByjRrPp7nEMUBUUNCN7/6qPqhdpNAJTgZUzVA0y//SQbIg+wJ9TJabNjcH93SoiX+0KVfKpZD6eOU52+Ye5WIcBeiSl4TqoiGO3uNPLf3Xz3rLoRlzkLk35RnFLq/hQVxVVVj36oQr790fWVMrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25FWSVGO3b2JI+IYhWBRIrHZ2TShdHulbGRp3eAT+8w=;
 b=fh3vpj1GHf9hSMX8mTF9e3Fp/Y5JvZWtrUmkhEPQ4E6FUk/QZW8ErVAF04s8A/df04y9xHvyL1aNyNtc6tgelOFiAMOfJ9UVUUYk20Erm3KaWVs67q+VeL+OFoF4DAO4s8s/b1gsF999b1WUxsNaYsjR9lZUIKzmcMcQ3NVTGng2ctN+jRvZO6tAz4svNHhgCtg6k8xLvn+EPbyjcp8RBc1KCJ0BXubIG5CYzmXK684qpQfM0vLXxsC/APpzEipD4+OcXNU5TjKg11ZbyBnoMesrfQ7cv4852uTrMZmCxF1Q4bkU/75sgeeTb+yD3cuAGhJX3zAyEBeM9M2BYmNFDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ2PR11MB7456.namprd11.prod.outlook.com (2603:10b6:a03:4cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 25 Aug
 2025 22:20:34 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9052.013; Mon, 25 Aug 2025
 22:20:33 +0000
Date: Mon, 25 Aug 2025 15:20:32 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aKzhsOWp2TlFF5mK@agluck-desk3>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
 <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ2PR11MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb6bc4f-54e4-406a-d71e-08dde4259be5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LHl9Ej4O8E4aIsDgE0YrksfpXg2V3r/0BgiFfcjX6YEJLAQJEKwV0TflIh4k?=
 =?us-ascii?Q?AnhXZ/mHhASD8L4OZnsT1F3/SARKNJnvHjbFDPYFfFDLF7foYtIjkT+n0hjX?=
 =?us-ascii?Q?BOY7lIq0E+tv8JZOxJ17n+5n3AhaDbZXDFuosTsIQEs3mkjl9Jp59BFS8tES?=
 =?us-ascii?Q?mmdsEjs8oHxZbfRN15BCGLNIVjJwHY66BRpiOHKfL45ynQdl4olHN9NDGCfM?=
 =?us-ascii?Q?6uefC/Mzl7yFohgB6/xJ93KzfOEIDxtdV8/DH/t2d3pajKsyhiBTrhAxX6lq?=
 =?us-ascii?Q?5B5lZv1nWXaR0vKoXeCUbRc/tnShfB3Pagsk/bKSGVb6UdBjtbbEgr0qZBtx?=
 =?us-ascii?Q?7NSORurce2EqJXs83QRiKYf2shCE2ELZQ+YxHDhCTtG09YVBKYa/kLESlbqC?=
 =?us-ascii?Q?69OYF1ZNB7IZ45o3I/C0Lsljgs3utiCm584AMMVO3i9zl412b6DqGmw1iT5X?=
 =?us-ascii?Q?fpmVE5ajAsIMCAtphUNI9YUswd+xPLt/DkDWKIZVGJl5zpVOG/kqdJIZLcfa?=
 =?us-ascii?Q?upNsZXpYiHkUiEYYYXdHd3dwkQLNDUZ8L0wuiRVXQxw874TRrWudSHiS3avp?=
 =?us-ascii?Q?1v2AptsR33Wuy5oQYReCYlVH4naayusca6jBo5yPUEg0PTR2kRmVSZurwyac?=
 =?us-ascii?Q?laVVOmsHus5TQO9VKvNXdnesT2Tg+UHbyOguHdH4CZEsoU8dPMWnMba+Kbk4?=
 =?us-ascii?Q?Mlp3t/N9lXokQwhPxhA2knxlQvpO9hSfxF9T5xfy/ACKUUDKujwTSksht6jr?=
 =?us-ascii?Q?J1Aplbc3N5L3XGvzSTndG+vAiTcIlwBIp6buw1S/b4b3tkSfR5r3Bs4IzJUc?=
 =?us-ascii?Q?Ko+ZZxgUlr+YPA4qU0v7vU7tsTA0NoW4PmMWG3UoDYRY4deX7yf1GgrjLdwQ?=
 =?us-ascii?Q?33YYfv8d2hPZhRzyXxVIEeYHQHA6bW402bTGRXGOfErQ3e1tFfYo1mdpUmew?=
 =?us-ascii?Q?L+7YjcHFXBhiGljWVyNdTbqG23VKQ7/kkB/mOzroeKrfyS9IU13IKEsQswdn?=
 =?us-ascii?Q?TAqUpVNHclSXzUzcm/f02IMIvGXWLR8QDgNIMr7CXLHHCHIY47WnwMrUwQUN?=
 =?us-ascii?Q?UFYRxt3pbgtE4UO39Dltoqk5kU8G5tozm84BiPKpvdYmI2K/hW/1d2EuNnWz?=
 =?us-ascii?Q?md0I1dKLs5ur4yQVJaOg1CgW7SGLd8smZwhl1cewsA77RTAkfYSYHH4/J+cm?=
 =?us-ascii?Q?9P1+AnXoRL8UexPZoSr6MoREySa8KY3QGs77cqzmXp3HkdEZPP31osfgtFUk?=
 =?us-ascii?Q?XifQ4fC3Vi1AH50/HlSOEQooEAKi1ejozgGVmbCVKU5xlH90V2oKCWJNVwDM?=
 =?us-ascii?Q?fYJE2pqqHqOejBvbwnsXOweYqMTjsxQMzu6LnLw5UkkdIsAXDbZPXSgLIghS?=
 =?us-ascii?Q?esSCFNqtz80gb7NzdykPF9ZfOgZLg7UQheqbG5S5hVojBWs+Bcwnfvt/tmqQ?=
 =?us-ascii?Q?2SFt6fTJJap4+wdz2BMt1jMnxO3NP5yBBAItt2VLHwJXyXxu6ORAMA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lTBRgViDgKK/J/HF6OohHcFfUijiSZTf4Dj5j6nwCdAQyVmvbEAT/Rg9tUKf?=
 =?us-ascii?Q?9PBxUOnwbhjCvLWbit9Te80/4PA3e5MarLRq7d1MwjfNPnK9pmSrYJTNeuPO?=
 =?us-ascii?Q?J3FNtDmJdbHaHQaK9JwRUCAk9WX2dXAFlHG8QBqXTZYgJ1RVNZ3+CrzUmLdf?=
 =?us-ascii?Q?VgR4Xo2O9KVLkkJ2okGqzMHut6/y3cEhYWC4DPmr3zhQ/+4cezQkEJpqI0qb?=
 =?us-ascii?Q?aewyqUw5/MT8w0rNuIXdXj6vRG8HsafKU5wNEtTVm51IXyWMmRp+AteWw5LC?=
 =?us-ascii?Q?ls5a6JIpkc3/ZB/Kg2ZfWifhh+doTcYrsNySChZaT2yD0fSwVy61Xc7ILOkY?=
 =?us-ascii?Q?3+tb2JVtiM+N2h4W3WsoMpt/RLIFeDsJUqA+mX6596Ac8dTu7/ywNuoItiGI?=
 =?us-ascii?Q?iwReHPbWb4NVUcklZgSbxDAI0vqwPXkZ3I8ZNgkKp0LG6pQMH6Sl46S1m/Oh?=
 =?us-ascii?Q?oP76GkWMJgtAy+PM8nKxfR9UWTUhdlQnhsZ/y3C0SxFc4PCmn8kPjrKbi03P?=
 =?us-ascii?Q?V1YXl7TRr9+kHHlBvF6SOizjIDX24R48gatc8G+VODzTEbrZq2dBPWNhgJ9m?=
 =?us-ascii?Q?1F6TuZjm5Um6FFGCoBBnxyVnxWenZyuP22rWAXSEGqkqcoWkm9HlTScL99w7?=
 =?us-ascii?Q?aJM2PSs2PUXgw5mJhIFtN3Rjtxw467TQf0iJCNThlm7lETw8Fxw8/3TRtS+7?=
 =?us-ascii?Q?XRg498mYwRTLkXxGsX4pxIZDhDKSxnKi1jfTyTZjlLQpofqXp8wopnoklv1a?=
 =?us-ascii?Q?CGhHxpAT2AvBmPDl7eq/9CJ/wPnTV/Bstb5StlRwrAyzNvQZPstRO4Jxl1vV?=
 =?us-ascii?Q?v8SvJFmNxsIL7sOyKHemDbV76dmXst4tv0WOYwVlSZ2aQGv2ut4VW7e5yhRf?=
 =?us-ascii?Q?Gnp/owqtHc93pF1aTPZ6tkYvM06mnl4qklKloH4YkTzwy3C4lWlcYCwkwmoP?=
 =?us-ascii?Q?miqCDp3zZzfjyB9fTXCxwSHyNAdlwfaMubOqIoIHarSXqXimuJbHQXnqUBZp?=
 =?us-ascii?Q?t22RRCSgasBh2KybcLxDRrgs2dBHV9syA4aE8cqYzUcf1FIYArR5k7Bghe/G?=
 =?us-ascii?Q?mieOpoWKRDmasn1U9ApOM+yZlQdoU4EeP5d4C6z97MppNsoVObX8g8vCps87?=
 =?us-ascii?Q?pDCIoDFZReif2/iUSO4G7tQZ3+4/dD6fXhEVoCHwuD4awZjjuxgQ61cnZ/+n?=
 =?us-ascii?Q?yWX82mtvBDRuTNXmBPxzqhjFwNSY4RwDYhaplPLIoU82cbMqmj1LqaidvR90?=
 =?us-ascii?Q?qaNZagGOTsh6Xvfywy2pcbAZkoQwiRQG8ja0Y4BsCzC0t0EaOdXjzAb5jppV?=
 =?us-ascii?Q?qJXjPA3E4+gzTCbEaa7fLilWmWfC44dx8IFL645qLVhvOMhFio4EzS7YMEAO?=
 =?us-ascii?Q?lYYynj87eCT4AIgFzhW6wRfpU5mjVOBYqFhzG0YCYpsME/10AV0SiuHYn2OI?=
 =?us-ascii?Q?lPDaNrIZIUeARR7UiRCM6dJ0cmW2peheUyN/NFyv6usujhU3hn0BvUAu6M3X?=
 =?us-ascii?Q?8+P68NcMGOqm+MRlZBvhNZRMTvrVF4IMHqTwLn6kYyZaIFUOsq+iTg4rYEbp?=
 =?us-ascii?Q?7d1kJcTKvu+0ifTqzhafIn1BgKhPhnFAZ0LMphpd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb6bc4f-54e4-406a-d71e-08dde4259be5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 22:20:33.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfzSn6INYlZPGcv7ag4YxKngiCqS60dunWu7VtwoOG43Gjzg351OKx1jFAZ+hUSXDfKKgj4KWZZYFNLS+YhXtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7456
X-OriginatorOrg: intel.com

On Fri, Aug 15, 2025 at 03:47:17PM +0000, Luck, Tony wrote:
> > I think this series is close to being ready to pass to the x86 maintainers.
> > To that end I focused a lot on the changelogs with the goal to meet the
> > tip requirements that mostly involved switching to imperative tone. I do not
> > expect that I found all the cases though (and I may also have made some mistakes
> > in my suggested text!) so please ensure the changelogs are in imperative tone
> > and uses consistent terms throughout the series.
> >
> > If you disagree with any feedback or if any of the feedback is unclear please
> > let us discuss before you spin a new version. Of course it is not required
> > that you follow all feedback but if you don't I would like to learn why.
> >
> > Please note that I will be offline next week.
> 
> Reinette,
> 
> I took one fast pass through all your comments. I think they all
> look good (and I believe I understand each one). Thanks for all
> the suggestions.
> 
> I'll try to keep (better) notes on what I change as I work through
> each patch so I'll have a summary of any areas that I'm unsure
> about for you to read when you get back before I post v9.
> 
> Enjoy your time away.

Reinette,

I've completed a longer, slower, pass through making changes to prepare
for v9.  Summary of changes per patch below. I didn't disagree with any
of your suggestions.

The bulk of the changes are small, and localized to each patch. The
exception being removal of pkg_mmio_info[] which dropped patch 18 (which
just counted regions prior to allocation of pkg_mmio_info[]) and patch
19 (which finished filling out the details.

discover_events() is now named enable_events(), since there are almost
no "steps" involved, it doesn't have a header comment. The name now
describes what it does.

Theoretically skip_this_region() might find some regions unusable, while
others in the same pmt_feature_group are OK. To handle this I zero the
telemetry_region::addr so that intel_aet_read_event() can easily skip
"bad" regions.

I've pushed a rdt-aet-v9-wip branch to:
Link: https://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
if you want to take a quick look at the end result before
I patch bomb the list.

-Tony

--- cover ---
INTEL_PMT_DISCOVERY -> INTEL_PMT_TELEMETRY

--- 1 ---
No change

--- 2 ---
No change

--- 3 ---
No change

--- 4 ---
No change

--- 5 ---
"The "type" field provides" -> "rdt_domain_hdr::type provides"
Update final paragraph of commit message as suggested.

--- 6 ---
Code: in domain_add_cpu_mon() change WARN_ON_ONCE(1); in default case to
pr_warn_once("Unknown resource rid=%d\n", r->rid);


--- 7 ---
Code: in domain_remove_cpu_mon() move domain_header_is_valid()to
immediately before container_of() and switch check from r->rid to
hard-coded RDT_RESOURCE_L3.
s/list_del_rcu(&d->hdr.list);/list_del_rcu(&hdr->list);/

"separated" -> "separate"
"can skip" -> "skips"

--- 8 ---
Code: in domain_remove_cpu_ctrl()  move domain_header_is_valid()
to immediately before container_of().
s/list_del_rcu(&d->hdr.list);/list_del_rcu(&hdr->list);/
(moved here from patch 9)

"refactor" -> "refactor domain_remove_cpu_ctrl()"


--- 9 ---
Change second paragraph of commit comment as suggested.

"so the rmid_read::d field is replaced" -> "so replace the L3 specific domain
pointer rmid_read::d with rmid_read::hdr that points to the generic domain
header"

Use imperative tone for last paragraph "Update kerneldoc for mon_data::sum ..."

--- 10 ---
Change rdt_mon_domain to rdt_l3_mon_domain in comment above logical_rmid_to_physical_rmid()

Replace entire commit comment with improved version.

--- 11 ---
"different resources" -> "a different resource"
"these functions" -> "the L3 resource specific functions"
"Two groups of functions renamed here:" -> "Rename three groups of functions:"
Added rdt_get_mon_l3_config() to list of renamed functions to put the "l3"
before the "mon" for consistency.

When changing names for resctrl_mon_resource_{init,exit} add the "l3_" before
"mon" for consistency with other *l3_mon*" naming.

--- 12 ---
"to lower levels" -> "via the mon_data and rmid_read structures to
the functions finally reading the monitoring data."

Replace 3rd paragraph of commit comment with supplied better version.

--- 13 ---
Code: In cpu_on_correct_domain() s/return -EINVAL;/return false;/

--- 14 ---
Code: Move definition of MAX_BINARY_BITS from <linux/resctrl.h> to
fs/resctrl/internal.h.

Be explicit in commit comment that the file system makes the determination
on which events can be displayed in floating point format.

--- 15 ---
"asyncronnous" -> "asynchronous"
"for these drivers" -> "of these drivers"
"are called" -> "completes"
"But expectations" -> "Expectations"
"The call is made with no locks held." -> "resctrl filesystem calls the
hook with no locks held."

--- 16 ---
s/CPU hotplug/CPU hot plug/
Add Reinette's RB tag.

--- 17 ---
Code:
"OOBMSM" -> "INTEL_PMT_TELEMETRY"
"INTEL_PMT_DISCOVERY" -> "INTEL_PMT_TELEMETRY"
re-wrap comment for get_pmt_feature() to use 80 columns.
"OOBMSM discovery" -> "INTEL_PMT_TELEMETRY"
Add the intel_pmt_put_feature_group() calls to intel_aet_exit()
to match the intel_pmt_get_regions_by_feature() calls in get_pmt_feature()
using a new macro for_each_enabled_event_group().
Rename discover_events() to enable_events()

Add period at end of help text in arch/x86/Kconfig.

"Data for telemetry events is collected by each CPU and sent" ->
"Each CPU collects data for telemetry events that it sends"
"is changed" -> "changes"
"or when two milliseconds have elapsed" -> "or when a two millisecond timer expires"
"mad" -> "made"
"Enumeration of support for telemetry events is done" ->
"The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events."
Drop references to INTEL_PMT_DISCOVERY driver.

Merge last two paragraphs of commit message.

Reformat commit to use more of page width.

Add maintainer note about checkpatch complaints for DEFINE_FREE()

--- 18 ---
Dropped. See new patch 0019

--- 19 ---
Dropped. See new patch 0019

--- 20 ---
Now 0018
Rewrite opening paragraph to avoid "continuation of the subject"

Add note/link on the source of the XML files that describe events.

--- 21 ---
Now 0019
Drop "vague first sentence" of second paragraph.

--- NEW 0020 ---
Replaces most of parts 18/32 and 19/32.
Contains skip_this_region() from patch 18/32, but skips all the
code to count regions and allocat pkg_mmio_info[].

Also includes event enabling code from 22/32

--- 22 ---
Now 0021
Modify intel_aet_read_event() to dig into pmt_event::pfg to
find the MMIO base addresses that v8 patch stored in the pkg_mmio_info[]
structures.

--- 23 ---
Now 0022
Add domain_header_is_valid() check in domain_remove_cpu_mon()
before using container_of().

"There are structures" -> "There are per domain structures ..."

Replace my commit fix description with better version from Reinette.

--- 24 ---
Unparseable last sentence of commit message replaced with details
and examples.

--- 25 ---
RMIDS -> RMIDs
"Adjusted downwards ..." -> "May be adjusted downwards ..."
check_rmid_count() -> all_regions_have_sufficient_rmid()
"Potentially disable" -> "Disable"
Add comment:
/* e->num_rmids only adjusted lower if user forces an unusable region to be usable */

--- 26 ---
Add "during resctrl initialization" and "during resctrl exit" to commit
background statement.

Add "closid_num_dirty_rmid[]" to be specific about what is being allocated/freed.

--- 27 ---
"mon capable" -> "mon_capable" (three times)
"alloc capable" -> "alloc_capable"
"rdt_l3_mon_domain::states[]" -> "rdt_l3_mon_domain::mbm_states[] and
+rdt_l3_mon_domain::rmid_busy_llc"

"the number of RMIDs" -> "the system's number of RMIDs"

--- 28 ---
Add comment to setup_rmid_lru_list() to note that rmid_ptrs[]
is allocated of first mount and is reused on subsequent mounts.
It is freed in resctrl_exit().

Lock/unlock rdtgroup_mutex around body of free_rmid_lru_list()

Rewrite commit based on suggestions with some modifications to explain
why error paths in rdt_get_tree() do not call free_rmid_lru_list().

--- 29 ---
TODO: recheck for use of "CPU hot plug notifiers" may have been called "hooks", "callbacks", and
"handlers" through this series.

--- 30 ---
"a resource" -> "a monitoring resource"

--- 31 ---
"last_update_timestamp" -> "agg_last_update_timestamp" in commit comment

Move creation of debugfs files to the end of enable_events().

Rewrite to work based on event_group::pfg since event_group::pkginfo[] is gone.


--- 32 ---
Describe "num_rmids" file values independently for L3 and telemetry.
Move the note about upper bound on directory creation to its own
paragraph to say it is the smaller of reported "num_rmids" values.

"or of a processor package" -> "another for each processor package"

Change paragraph about contents of subdirectories of mon_data to
gize example file names instead of hard coding specifics.

prescence -> presence
will vary -> may vary
last_update_timestamp -> agg_last_update_timestamp

Simplify commit comment as suggested.


