Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A36348C4B
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 23:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789428079; cv=fail; b=fHtpBnZi9hd0MLu0XDkfZSJPOOkp6vWHh1RRH9xWk3pY74IWNnbmH9Nuzo023IADilR9xT2IFT4vFwxr/Igxejyd5bcLOHrGKzKicIbAnkXbulJ5pyM2nLbPjf8n6KbEZjuZGRIUsgacVDXuTe9cy/Icu9CEabNATOoNzCEUQeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789428079; c=relaxed/simple;
	bh=IkqZ7dTZAYdlh60kLCEsskOCniXvQr6pMU/QDhIkEDc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i91a/Can+Mxri29GkQmyy1QWvLMSejOXh7c2RESsHLJIuJkLkFr4eyGqdelO37t4xKZQbHaAxUDmw4JORwacEX3BFgOnYrEM1+V4O2UYcwbw3EdzEZ62zNR5E46A+xlidr1ieOQ8TpW/EQQ+EPtg9ZZ3uGF4a4bWjWUq0krq8Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjBoDeK3; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjBoDeK3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789428078; x=1820964078;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IkqZ7dTZAYdlh60kLCEsskOCniXvQr6pMU/QDhIkEDc=;
  b=fjBoDeK3u1fFhw4EfIHNxt1PfETQH4ucXLJuTVSqAU7fAnkdE0+15M7J
   0hc2Nw94Y1Zy7ganu8UzrrovCr+lzLQffyqPWNU+UfRuLtvwhLlT3VaHf
   RpILgSQPhUROtuspp9hoq3DmRyERODk/kR+203A/3LSaZYL/6280/X1Wz
   8M4OYyZpJ/QtziDHoP28T58JIhJLldc5NHnHXel7IQfK0J0zoQi00E2YM
   J28OlEKguWcIUTIrOCFXritSo4oYno0CCgJCx6FF10WJS2p8IcBZpFfUH
   7zGofi0kubGDpiS3KSJpOvBRPNn1zO+ibIv9kyvzdHcon4eHRQ5ZeOOKA
   w==;
X-CSE-ConnectionGUID: UPJd3WfyRSS8jWNi6gKymQ==
X-CSE-MsgGUID: yOyQCuAMSYmgWFdJtkjy9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="101134586"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="101134586"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:21:18 -0700
X-CSE-ConnectionGUID: rrywxc8ETouqhvm1uZ/j5A==
X-CSE-MsgGUID: +IQMQMtrQDa8QkTwYMvBBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="268488786"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:21:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 16:21:17 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 16:21:17 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.22) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 16:21:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PkGywFVhQ4zMHaWVqhlX5+Z/uM61SC0k9OPklew91w8Mk7hw5VX4PcrQnqx2j7uCYc5oWbu07axcJscE/mbv38yJdHLWneCb5FVVPAuZMj/XwTrcd7VHCYcverZtI4gakp1uZyQpKcen7k47iIuECalPuokXyEDOa5aZzYp0+dIRxo07sOxeXOf5VZCs7WM4+E5WdIHnv9Dx6vSVXGk3S6bSaD0mpp767vVIZEe6JAdanAgtjuZNXrwmHtb38Pj2NDbbAtkIbm3D/JqiDjlX5+w2Ur/YB9u3rmk4z5ioA1QDXFuGzNCqnZgZeLCJDF1ys3wo4roDMm07D2O5D0BFDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URVO+h1Zhh5VJI9mVH5dCNvrkDvhc+TxkmF6L6HAEvE=;
 b=ENh6dzi4VmLhkejwj2UdUkny0sSjlDQ9wEP62sSikqo1vIHf/5Kc6STHc/G44hjZAYEtvUVOhtf5iXVb2kcB8yldJCGT2cBIIm2Z6lf5zcubVqbBJf2ECrSmQfSpYIBxqhz/jobiSllRIOr3LqOKjHmjEltCal2u7b1XIq70+oAG+MNSLVDKoVVhXe2m5CZhdS9sZo/CO46GMnYi87WwSATMFU9vRHvgmUjuKWzlXkZkx4RHDZfbGp/r3qv3G57YzoLCMi+N6RG75zjwQv39gwz3NF0PXbBVyFS+upAjsNgSFG/jlkEJwwri+7PZE8Wwzgf/RUkou97EW45hGC5BiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 23:21:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 23:21:13 +0000
Date: Mon, 14 Sep 2026 16:21:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET
 event groups
Message-ID: <aqiBZy4vmMc8Zq5Z@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-15-tony.luck@intel.com>
 <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
 <aqhoMhn4rsl-HWmb@agluck-desk3>
 <99a4db07-d142-483f-9544-969c7ef9f258@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <99a4db07-d142-483f-9544-969c7ef9f258@intel.com>
X-ClientProxiedBy: BY1P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::17) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8ff490-c1d8-4c2b-693a-08df12b6de0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|22082099003|18002099003|4143699003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: QkOvHsbtR6leikD6+ZMHfI+vMUdehN/qIUQreRBXNvrVY5xC9B3lq6ipWdGZwKtZ51KyyV8EimEAfZ2hR8hjmDQLN1YksJs6aQ1elw6hbLXaBiV13s9hy5pBXCG430izG2tzqs1k/xuytDIkZPKYOahyrNwFLPouCxhfI2ijXvGn/THIm/KWSMetJTYFecQKf2moeyBYrCnJk2uvbDdjttiSxpIrPJTWkWfw+4EpXvHWVo6ZTxoEs4B+WgrsZG4K1t0XXDfwPbpwYarrruENRy0PMi6Bae3C0FpCu390Tlae4a3yeJnS0Jp7p9AvrClxLdvhYG+CCqPz+RzCzSpCoZqMVToEsk3wJ9+6G/j8XsV+dvALWmiL5auLo2xG7QTfz4po2MEdeDjZ5dkCLvxtStKjYmm6BhJ6A6Xrb9C9bsuO2K3ZBLLevaa9njk5fk7vZTtlATmcAJdM08z5blxgJQmnWbb6Wh/2PCE/xEQzyXa2szztLNUkQ2WVn8veXYhHVtPr7NBdFSb+yZ5jpM91RDXKnRjUA54+jFq5SxtXKjevpaUlKgKNhj4/403zSLrtjcfiFSivCx9SL1+lTApfq7Oi53uE68VM0M8xt+9msVNQaowI/2rYwcHcYpVuGGRpmDxyQXS99X49YBTROOtq5uN6vTCWEXc3+7leWY8rKYM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(4143699003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+1H+7Qh8gaS9MK/B8ztSbUxpSCLkFWtcAFYRXAGQatFVSHwwGi7v3mD/KUH?=
 =?us-ascii?Q?k+9AbIY3SApIGFPMb4uIGqSfT2jbhd9YbqXx0CRLI+8c5d0NTcRyc11KwjYG?=
 =?us-ascii?Q?FMwV1wpps+ckY0F3uqbjXpbXOrRLg3U4OpczwCQfp+6H5pJQYuoGDk43r6xB?=
 =?us-ascii?Q?WN5aVv/N5IhT4g0Xqzg3EBKepZIeXeoJc6M2eQFjf9zbxXOAkrTbhYfFCQsx?=
 =?us-ascii?Q?BJfSKuLQP3AyfQMkzDlYoGnoomt0WjjnE7Ry+nHA6wP6eAqmZftJZmijZSjB?=
 =?us-ascii?Q?FAKcHLnJ9sLXjOEbCjH4jsOBEwTRZJeDLFzWdfpVox27RFM4riL5CMe6uypJ?=
 =?us-ascii?Q?vEM9/LMYzCWNfKhlw/qtaLrZCa5zs9Fxs75oopr4VPwsvEiWbrUMYxEHQtCX?=
 =?us-ascii?Q?wfSu05yRmXTvZAhEG4vs1sFUl+8yIwSD2ylXBA9vzAlGjq0Jh/vSHmuwJKMc?=
 =?us-ascii?Q?woEDEQ0ynqREaCqdh606kRl+e9D3tQzp2+NrDrW7XDZIVHOOpebOu1pG1fsp?=
 =?us-ascii?Q?yv2C8UWdFzDMQafH5NJ2tk4NxZHGU2zD6PV5041uKVe6Ot81fk60VLkqXpFm?=
 =?us-ascii?Q?RY0Q76sJpAZtEOYBJkx1P4ekNKPjJ1ROhqKQhcsAE6DfEUmTAcSyagT8EAEs?=
 =?us-ascii?Q?aeSgkiyUHugpsuL06h6uPfHu9atGHZOxccrLjjEoZ9vvhuOIKN1sB6kkybjm?=
 =?us-ascii?Q?z7pbB3BmyzKsfLr+GJb6rWrgFgI0jzPXqkRIDW9xHhWJ+A/Lc9khfctDvibN?=
 =?us-ascii?Q?HBas5e4qMH73Cq3sfpWLFHevdN0y/zq33xnreM7OjggDD+vGZI/vIGBS70OD?=
 =?us-ascii?Q?4b4oMCkCNR+o/FS+4mY4ZmHYAozquHZI1BvG7ksmqziG7sRxL1GkGoI7lGUx?=
 =?us-ascii?Q?I9urnXMpwV7Lm5kCMrh/seyyS98Fpts5F+OuitkzQ4D76ul8VAQMsBZYd61R?=
 =?us-ascii?Q?Kx5qTO++AlxU8Tah/TqWG4QpFDNG9+7Q/hhlmtj4IjmdgqbJzWkMLr9B1Qln?=
 =?us-ascii?Q?hERsUqPIbkrgfFo1s06k2kmDpnhajOuuiPIxsXPbIuUpVqAxNuD7na4+MijO?=
 =?us-ascii?Q?DGj8MgQkEUJWc+WdP9CqzYITyYmc8vLjX+oIMcBFxonU0TchrYWiCvpHeVcZ?=
 =?us-ascii?Q?pQEUdr4XSjoTNAli7v9kDzQdytgDNCGxzv/KS+wS1Bya68f2rrVoPbEmVTR0?=
 =?us-ascii?Q?cU5BQ4kfMKvTmoWE9tRtzyKqcY+6QcHa5F+bGvfLisirAWE2yj5dwSEAMb3h?=
 =?us-ascii?Q?C+BVDMemGAfeNzjGiVtvRFXOEE+PooECoLXfoGa+9GS0PEqw5QSddWcjDd2H?=
 =?us-ascii?Q?aD1RCippeCu9lf00Jyozo+DgRGA4X5kFYgwX0LUedDl1FU2+q+vF6zUOjzej?=
 =?us-ascii?Q?8/3lqaimQZKzXluPao2xyEt2xaw96lXAw/8JCLJd/HGQT99IksFZ39Q2FL3L?=
 =?us-ascii?Q?ZEXnij4PjqwvTifMowobD0O6Eva38yZK4XShDxOKxZCeLdutbUL76N9Fw3+P?=
 =?us-ascii?Q?GWhvIqfqlVFBGaAlM5XJ0X6GKv+iUk0zt2aUtmMwy687ffhAf7J8VgPioN8/?=
 =?us-ascii?Q?fmeNENpsNnIcJgIkxYUvswQalqPpwtQo9Zsh1AgNGrU9QHMQMGDj3nzv7MIW?=
 =?us-ascii?Q?C5doiJF+ACU6Z5CAZJ6YqwF+6Fewjmf9y2UCjov9D24QXABzjw5h/QD53ErD?=
 =?us-ascii?Q?qyOcu4npPdqUJGay9m/GfXwE+M2nmAgOR4nx8hayS6PsSsLI1+HqTdPI6yLk?=
 =?us-ascii?Q?bAxDfdLUzQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: 0fDF2zMvM/O/YgRWHrcHv5v1g30aqSPcKalq/cmZfhYXMDAScEx+bsupJhmgz+D0VtjRaUFmUyoT5WDOhChzgmHsecgiaZz+EGuElTtUeiRZymbHLVIP0bu0LrJ0ih5bfu0bLB0HiNs7v6ZZgCUngK66dU1gydgyBesEgSlvATs2qnQMwvEk7hzt75RiZ9BdqhIuTDf8hy9cwTTICdI8Kv9n3Vvq7BASpclGTn+q1komF0HeutFPHDpYcPE56DQW8BDIICAlqa+V5dwWCfs4QFA9Gos10v2iEnrWgtBbmsfpZ3ECoINU1JSbkPhIEehbkGX5esjqxkhyzKbOgPZIDg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8ff490-c1d8-4c2b-693a-08df12b6de0b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 23:21:13.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9hqymKD6tm8CHR+R5oMmyl2C/skWY6PNPH6qNL1aYxDhReJeUhLGDggdBGbjwBDFbHHC6CUJSObj/5IkaFwJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
X-OriginatorOrg: intel.com

On Mon, Sep 14, 2026 at 03:03:45PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/14/26 2:33 PM, Luck, Tony wrote:
> > On Wed, Sep 09, 2026 at 09:05:28PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 8/31/26 10:44 AM, Tony Luck wrote:
> >>> AET (Application Energy Telemetry) event groups each support a specific
> >>> number of RMIDs. But that number may be lower than the number supported
> >>> by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
> >>> enabled as that reduces the number of supported RMIDs.
> >>>
> >>> Reduce all event_group::num_rmid to system maximum.

Perhaps I need to be clear on what "system maximum" means here. See below.

> >>
> >> Why is this needed? Doesn't resctrl_arch_system_num_rmid_idx() ensure the
> >> minimum is taken across all resources? I do not see why a resource needs to
> >> artificially reduce the number of RMIDs it supports.
> > 
> > rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl.mon.num_rmid is used
> > to display the value in /sys/fs/resctrl/info/PERF_PKG_MON/num_rmids.
> > 
> > It would cause confusion if a number > (CPUID(0xF,0x0).EBX + 1) appeared
> > there.
> 
> That is fair, but on top of this this patch additionally reduces the number
> of RMIDs of RDT_RESOURCE_PERF_PKG based on the number of RMID that RDT_RESOURCE_L3
> supports.
> 
> Documentation has already been updated to contain:
> 	The upper bound for how many "CTRL_MON" + "MON" can be created
> 	is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.

So if L3_MON does not exist (because L3 monitoring has been disabled) then
the user will expect to be able to create info/PERF_PKG_MON/num_rmids MON
directories. So that number must not be more than what can legally be
written to IA32_PQR_ASSOC.RMID.

> 
> I do not see a reason for PERF_PKG_MON to pretend to support the same
> number of RMIDs as L3. This unnecessarily hides information from user space.

To clarify, I am not proposing on limiting PERF_PKG_MON to whatever
limit L3 has. I'm proposing limiting it to (CPUID(0xF,0x0).EBX + 1).
That's the "system maximum" in this context.

The L3 limit could be lower than that, or may have been reduced if Sub-NUMA
Cluster is enabled. I don't want to use that value.

> A user may only be interested in PERF_PKG_MON and then see that mkdir of
> monitoring directories fail before it reaches the supported num_rmids.
> User interface will show that this is because of L3 and then user space will
> know how many monitoring groups can be supported if/when L3 monitoring is
> disabled. By pretending that both resources support the same number of
> RMIDs this is not possible.
> 
> Reinette
> 

-Tony
