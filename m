Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42701A9F90
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759787244; cv=fail; b=UHxg89mxYbJ/IvWJawV8Yq6vgKPs69Oo8fvqgLC+H0VxxHdESQQKCkxaX3vKGlJG7n1+UqbbwMt4n7pvNY4IQzsMjit/AaE96wxdHMwxiR/gHe09QeptGCgXmZxuUXi9caMEUxSRA+9khLoVxj27cQVz2fqGt24HjPfXv81e2IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759787244; c=relaxed/simple;
	bh=71Z9RPe6wf2Ov22+kM4tsixR5Y6bJ/9V4uAMYo5MN9s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NmRcIBGAjl9qcnRDFQf+MRT/TvO519lsJC3ObnBQAzTGgaAaQ5FTh3CfMguvlJDfJ6xxfQfoxrhVuX9sV6B7cqgL+tX0fGNt5bJACAWURqmb5KcOK3biq7kIig4oOYwO+KnlIukYPFGwbUt4P6HuacBCNqj16/wVT24++a9V8Us=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Znl7vbc1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Znl7vbc1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759787243; x=1791323243;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=71Z9RPe6wf2Ov22+kM4tsixR5Y6bJ/9V4uAMYo5MN9s=;
  b=Znl7vbc1Shtcg0MJ9pO73l/9nAQDmeCR+z+8IDAVGP7/A3RMiB/5pB7J
   cfmDGY/9qXfKOunjrTS8BHvMWojUzIDcGB/ocQMWWP1w7GrtehRwE7ru5
   x7gQ+jdnreplxl3WOHw+IYWV80oV/X1Rzm6LLT7amDOltSPI+57LJ4DNm
   +SKak9NUZt5O1+DRAjA8waM3rH5/P1o0whBQpgzCUh9kWjaNrRPyshlDH
   z+g6RVYaggtFM2BuzEzxGkq/efe9Vpqvz3s4vvW3XgZ2ddr2qxRh0KUfw
   86mw7nLugf6ABJmF8+qCU81l44xDhaCC17XTPZaTwBpN9f9zTRN675y7u
   A==;
X-CSE-ConnectionGUID: LUh7fFfgSHypWO0cSuWdlA==
X-CSE-MsgGUID: nqrjgXK1RoKiOGeLi6XV7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="62004670"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="62004670"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:47:22 -0700
X-CSE-ConnectionGUID: GT1ErjU5RUmml6fdMe/RVw==
X-CSE-MsgGUID: oErjsgxGR+a08vWl5fq03g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="180403001"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:47:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:47:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:47:21 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:47:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a3PhaveXobUYDRjtzNtUNmKYLJJxMRxnBrNi4jAQJyNQ44xh1fZtibrwwVWhntgJUO4mBEBl12G7bxhX3fEYswmaQNylz8+KG18eJW4jHjwdu2rfHpxOC0FXlA4bXl8tQnVM14MFwaP30iocS9+isD3BylkVTdMDJpA4HKbQ97cthoiLGWnUBUxo8oEzvDAsuaGBt/YGFR7ZtMEVDkZVEuL1XuShIqyUEORXJ6DYK9RX/9s5qRyNqR5K1etGm4ZZQ9vE5lMYsyWa9k347LLOBFkDVRT6Rufz4G0AZBGwSuXYmcXx6IT5bUpLPPgkuAmJHo+RjHrwnDtQxssvMhTQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeJAwXfH+4viHM/ESfp9cfRPVTWNqdVIJlpdMyRcyJg=;
 b=o7acufmYKjQ1rvfW0knaZNvNEUjrCTjhyXnIkCh0XUbIDM8eLcTJOxKn5jAjN1Vdj5spMlKGn2s7dC7SWXZAgRKHJU+osJU8g9E3ne2CfHmgzn9aP5drC1lbjlOYWQlSIR7SfGMpmaLb5KLsQgtmEi5cZdYbQJTzlEHmpHjzfD40oB0IcovxzQJ5GWaaXsrB2XUWYs0nqjjrCzWNTvAKaeIpfqKZngr/r/wSm+5nPvd+7VflB9lx2b39KLTGnYumRCp6BUura9p+AwLjmAf6fwh7NhzaPxHMZOR5c0Q7pxZVLaVz52UxHB4nlbVtVOKsVO0S6PoCxPadda7Y1f6AAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6565.namprd11.prod.outlook.com (2603:10b6:806:250::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:47:15 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:47:15 +0000
Date: Mon, 6 Oct 2025 14:47:13 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
Message-ID: <aOQ44WJMXweGNlL2@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
 <aOQIMQsgBOta0PRP@agluck-desk3>
 <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
X-ClientProxiedBy: SJ0PR05CA0171.namprd05.prod.outlook.com
 (2603:10b6:a03:339::26) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6565:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f78ee1f-13af-4d15-caf8-08de0521e9cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2S/ZCtLbFuMJKI2ws4Y1yGAeGMTXIldp1BMaC4j4IGHL/pxxjlbvOVvKMDrs?=
 =?us-ascii?Q?ojeNExaZCSw4Ka/SQpQQQsF5gk8Ux4tdlhCd9COjTMLrprnfAgwib8H8lXS5?=
 =?us-ascii?Q?i9GXppfg235/ne4jmI8zYoWS4QyNPybyUVZlZTn8duYAP14FHMr2DGBcbq8o?=
 =?us-ascii?Q?8f+bEXbU7W/sO+yX5e9zmgnA7dH4K50p9B9jZR90f9j72jqhZP+ns8NmUNBz?=
 =?us-ascii?Q?+4HTS7eFqD6v59OsGRvJZnyM+1oVUQDJ5akhET9d+hsd0j6NLgDt3gq2tlG0?=
 =?us-ascii?Q?txHsJCI9aNor2GwLAI3HMN1omD9vsGJILY/k0LX2hi/7vknKrhiB11mWdh9R?=
 =?us-ascii?Q?CBXybo/cvpdggFBGkKLG0atKnW6HnhsyXtaY7jHPCamBxL0tizsO6WciSnYL?=
 =?us-ascii?Q?T+iqxe9IEGx9YMokJn4vofsc1tni9Ov/RIIt5UHjAvaa2pfP1j/Uwq6Uku6u?=
 =?us-ascii?Q?VPpV5NJKxxEQza91f6FDYw8JjZOyUfJbuGyHU8op1lHmOKiURe/HSqDL4v+L?=
 =?us-ascii?Q?z6dLLmIhGoHI3Fy+Lyuug5VjeRHV/FHic/KJSmPGb9gTRX7L/VCs33o960o4?=
 =?us-ascii?Q?R7t90IxrulwrlFkyVtbLH1cVLK0X0C7oQRtqnOQyXpcTbDfGMMtYfIhoJMyB?=
 =?us-ascii?Q?PABG47ZNBwjXfVnY+opGGETuWOegv6+0QBieD1+Qo/8+j/qR+RQkNLxDaRhc?=
 =?us-ascii?Q?pXyMMChpjzdx2FqfWxZupNb5NXQWWChBYMrOmKWbDbkfkK0bgwz8TmS54kaG?=
 =?us-ascii?Q?Pqjxp7qsHFPRJP+u4rSgzZqUuDNrPsbfGqsKpzmpkfhcdSoZ2tzsiMN6Hpul?=
 =?us-ascii?Q?Qn3d8b2Qrqr8+eZ35NYgQMFOGcVTw3pCQPiLhewlKXcsSjGOjtlSjIsdgYZS?=
 =?us-ascii?Q?JaHjQ3WYeXYgZqogOow1eWS5LwA8742VKjN8iqXYwMt2uZx8Zz3AcJHfQ6fN?=
 =?us-ascii?Q?H6ShoUJe1f9Rb/tK/wzQib5koPZCGAIRCwuYbUSOWEK9l0+TIxK+CwlVfpTN?=
 =?us-ascii?Q?5u2iqTSqDl/R28ebMNbwGN0Wk+cEZ/nfMEbaevkN5anLEx3SGFPnobTvCqT9?=
 =?us-ascii?Q?/By0qhiyBjROlOqTZdPd7qoCnui6BtoUjnMzpjPCMfTpUnWobCb6UeejxYt3?=
 =?us-ascii?Q?isU6vjaDQQO8eTifWik/8gLRwQXwI+fHiCWDX479AQztBW+Hm6Ld+17V3DB8?=
 =?us-ascii?Q?FX9urRyvJoNMex6QYU13pektpKPXoMiLMqu/l8jZfxdBuSbGDpzEgbZajgLo?=
 =?us-ascii?Q?n6ca+Zt1DyS11y30fE3eVlIcDnOuWTh3Xm0GnLDVg1b0ezp9qLcTOVY/v1sa?=
 =?us-ascii?Q?b2aUhFU24Bt66sHD9QXZP33gUA1KdALydKUyjkfLFMoz+EuVWmsnp2PDi+YW?=
 =?us-ascii?Q?OSUdTN0Cigk/aNKRepaGMj3A9bSGm1OmNQfc3uU0GWwEbW0g+79Ts7O78KG1?=
 =?us-ascii?Q?6A4CUxupTWS889qW6JeStgyKjSsO1vdR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqITa6csKNcnLqePl6Q4joevDNgUfZ/NIPqo5VUMI+aFdRf+HVDC1h2WHJwj?=
 =?us-ascii?Q?+OtTUYMvBtmBhhflTJ13vrdUtv9bEOX3+PNCOYo+tSBM0tPFIVBhr1ava21e?=
 =?us-ascii?Q?BQWa05oj1fJynrSSRPGqEGjqHgYObdu+AUg3tAbb1UIQ0H0jicaZHEKZ4Jzk?=
 =?us-ascii?Q?CRD9PlLGPiMpfVHTR7hTFE20pFus3+0VNMabnoKxkVaz6dWrXN7hzwK6QRu1?=
 =?us-ascii?Q?3kvuZp4Q4aYOqW6Ifyh1KZAftLpfyYSBep0wysB+PPDkIAkuSWmkEIF+Acse?=
 =?us-ascii?Q?gF5dFglsvexoIsi+ECDI6Sg1JrQly3pNMOyq8buhvjYnK0BdPepzJBjQMD3v?=
 =?us-ascii?Q?7WYuLcCgXcA8bQP1SF4yeb3FR/00gKRd7jNUR/1KCHPaQv9rQUqTLtjc+O/k?=
 =?us-ascii?Q?Q9J/4gFKrO+6/6z2yYbj/A7rJX9eGGO0MgrOcGPkS+Zoji5KnGz2fHIhPHLq?=
 =?us-ascii?Q?ZrbrA6wEPgSZafbF5eobP7HhzB0OJa3ma1KUU9qx8NdNwKffEl/FyCfZYoA6?=
 =?us-ascii?Q?M8n8Mi3EoZ9kSCyc/mXy3sFXDCXIcwf+w3LMl1JC63XlV6H9vpPka4Ru/Vtc?=
 =?us-ascii?Q?8aZCYUaC+8S5ELH8T/vql193yzLllgTy6TjvGokJQTCowFjkx2ClxiX/RV99?=
 =?us-ascii?Q?zhgQHgjd3GdC3zXRK5hPx9ZpVaU2BgZN+4KP9tUKpdA52PhXyxLswfeegVvE?=
 =?us-ascii?Q?ZLK4qCzXgAeormkgAiCT9k4QujVX/IzdtVK5PGVw4K7ktir9GjBmZd7d5Qd8?=
 =?us-ascii?Q?O2ync6Uq3LiAeW72NTpEESknE741v91VCA9F4wonHvNxrK4eE5qwsZkBXYQB?=
 =?us-ascii?Q?YlkXV91djEIM/FCP99KX83LbLJH+QAd9JwyC5dM5wuVRcrL4NZsLRjcQ12Kq?=
 =?us-ascii?Q?ntwGlKZeSVtZBKvxF4ssWhxG9YTJfkmvdJkFQBuQb1NsWLlrtToqtXxFNvlE?=
 =?us-ascii?Q?hyh09wrM9/n/woWvrHwcVGu9VJb/UxRkdjIXjxH25d56IcdHL6HGsNAHFhAi?=
 =?us-ascii?Q?I6+Joejn2yd72BFs5cWiNb7DAphkWyowOwMXulhbdv9NxzatEXESoF9W1Sul?=
 =?us-ascii?Q?GkpX7THfCyaSJClE6T3ivB/qFbNkxUi+LGoy9L0GaYkZYPPRg53puFbjuzKp?=
 =?us-ascii?Q?UTkdR8IqfkxUxa8KC+0SegvzAhCqJRzGlVnb32Wm830Ylv7dqizN5kgzkGm7?=
 =?us-ascii?Q?acqhfoCnUctHlG2ZnI6KeRcjHE74EgrgCfBP2aw/tN/ZhKNjboJKbA9JkFSX?=
 =?us-ascii?Q?lxcn2T/Oy5AXlGSIgKxb2qFjI8y7Bf9oX4KvIN131SwzqpUzyVcyjGpqvjAP?=
 =?us-ascii?Q?SflPxBRLeu9gSKPhcUvA+BuE6To2Id64wXMuKf2UtS96+MU+z265k04Pulid?=
 =?us-ascii?Q?bfUvfw/tp0scHeWQk4bo66vtCFQgrNaWTk3eFxhtMs+vdYxpnVAtHJm6UWtB?=
 =?us-ascii?Q?pOzhCe0qaofBDqHtYUL3vtdVF55XUFNZfp25yM9F1GCcWXemAPa335D04pkE?=
 =?us-ascii?Q?mbtBWlKqR/cvF4YkcQEcvG9hOkT8DT54Zu7YxpB3kFqGPD0MxtuhuekWqHow?=
 =?us-ascii?Q?aoSJtLrF7E+tyilDrEeMpDn42xVe9HFcBGORygPy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f78ee1f-13af-4d15-caf8-08de0521e9cb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 21:47:14.9806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2jvvyrvMVbA2n3FqPwlkWTO2QlwMYD4wgrkkYEf7HBylikjDTEJtQh0s7TSqqpl+rw/oIqqi9j9ssfgzPQX0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6565
X-OriginatorOrg: intel.com

On Mon, Oct 06, 2025 at 02:33:00PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/6/25 11:19 AM, Luck, Tony wrote:
> > On Fri, Oct 03, 2025 at 04:35:11PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 9/25/25 1:03 PM, Tony Luck wrote:
> >>> +
> >>> +/*
> >>> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> >>> + * pmt_feature_group for a specific feature. If there is one, the returned
> >>> + * structure has an array of telemetry_region structures. Each describes
> >>> + * one telemetry aggregator.
> >>> + * Try to use every telemetry aggregator with a known guid.
> >>
> >> The guid is associated with struct event_group and every telemetry region has
> >> its own guid. It is not clear to me why the guid is not associated with pmt_feature_group.
> >> To me this implies that a pmt_feature_group my contain telemetry regions that have
> >> different guid.
> >>
> >> This is not fully apparent in this patch but as this code evolves I do not think
> >> the scenario where telemetry regions have different supported (by resctrl) guid is handled
> >> by this enumeration.
> >> If I understand correctly, all telemetry regions of a given pmt_feature_group will be
> >> matched against a single supported guid at a time and all telemetry regions with that
> >> guid will be considered usable and any other considered unusable without further processing
> >> of that pmt_feature_group. If there are more than one matching guid supported by resctrl
> >> then only events of the first one will be enumerated?
> >>
> >>> + */
> >>> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> >>> +			    unsigned int num_evg)
> >>> +{
> >>> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> >>> +	struct event_group **peg;
> >>> +	bool ret;
> >>> +
> >>> +	p = intel_pmt_get_regions_by_feature(feature);
> >>> +
> >>> +	if (IS_ERR_OR_NULL(p))
> >>> +		return false;
> >>> +
> >>> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> >>> +		ret = enable_events(*peg, p);
> >>> +		if (ret) {
> >>> +			(*peg)->pfg = no_free_ptr(p);
> >>> +			return true;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return false;
> >>> +}
> > 
> > Perhaps David wants to cope with a future system that supports multiple
> > guids?
> > 
> > You are right that my code will not handle this. It will just enable
> > the first recognised guid and ignore any others.
> > 
> > How about this. Take an extra reference on any pmt_feature_group
> > structures that include a known guid (to keep the accounting right
> > when intel_aet_exit() is called). This simplifies the function so
> > I don't need the __free() handler that confuses checkpatch.pl :-)
> > 
> > 
> > /*
> >  * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> >  * pmt_feature_group for a specific feature. If there is one, the returned
> >  * structure has an array of telemetry_region structures, each element of
> >  * the array describes one telemetry aggregator.
> >  * A single pmt_feature_group may include multiple different guids.
> >  * Try to use every telemetry aggregator with a known guid.
> >  */
> > static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> > 			    unsigned int num_evg)
> > {
> > 	struct pmt_feature_group *p = intel_pmt_get_regions_by_feature(feature);
> > 	struct event_group **peg;
> > 	bool ret = false;
> > 
> > 	if (IS_ERR_OR_NULL(p))
> > 		return false;
> > 
> > 	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> > 		if (enable_events(*peg, p)) {
> > 			kref_get(&p->kref);
> 
> This is not clear to me ... would enable_events() still mark all telemetry_regions
> that do not match the event_group's guid as unusable? It seems to me that if more
> than one even_group refers to the same pmt_feature_group then the first one to match
> will "win" and make the other event_group's telemetry regions unusable.

Extra context needed. Sorry.

I'm changing enable_events() to only mark telemetry_regions regions as
unusable if they have a bad package id, or the MMIO size doesn't match.
I.e. they truly are bad.

Mis-match on guid will skip then while associating with a specific
event_gruoup, but leave them as usable.

This means that intel_aet_read_event() now has to check the guid as
well as !addr.

An alternative approach would be to ask the PMT code for separate
copies of the pmt_feature_group to attach to each event_group. I
didn't like this, do you think it would be better?

> 
> > 			(*peg)->pfg = no_free_ptr(p);
> > 			ret = true;
> > 		}
> > 	}
> > 	intel_pmt_put_feature_group(p);
> > 
> > 	return ret;
> > }
> > 
> 
> Reinette
> 

-Tony
