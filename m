Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF78231830
	for <patches@lists.linux.dev>; Mon, 22 Jun 2026 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782169237; cv=fail; b=el4YykK/P9dHQ64qcfXIDqw06E5NLUzNVxcWxlmMkOvTK386SfsQtmq330b0atHT3+Tdz1IvgeE3kVE1HjbbI2emIIQd5vxg6dbJkpNCtEChSO6wN4skPhktHxLqwEezP2L2M0ruCaZQdZwoNpnetfLWP2iUHFu+DIy8HeJr/Xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782169237; c=relaxed/simple;
	bh=/TH9NtCjawYADcpR4GGNC5EaZELJa1ylzhwiXsm8wb0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=s0uz5t+JI0Bza+SUzwhqcSFUKeK8ctrTvaEbnfEymJHY/m5MTS9UEKkVXfbmVXAQdNnQTinFQOF5vnkEV7MpqdDzC/nf6re/5KKRMeNk/caKrIVbItiEK1jFL+Q6mMllbHXVrjkaiYJSHrCHaRW9/RBEOUvhCMVJvw9ZKp+gTJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U7Lk12zL; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U7Lk12zL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782169236; x=1813705236;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/TH9NtCjawYADcpR4GGNC5EaZELJa1ylzhwiXsm8wb0=;
  b=U7Lk12zL2pwZwWzjSUxRgTSHcWEhbnAfsflTP9ZxNQMgk6mdTeXA5GQD
   OLFk9ktOix7IjyZkkjguIvl1cMhpoq5895nYF2TSquHwRekn6g9HqYzaC
   qSt94kiAir9c2sUit8Y0wYsTF8toEe2Lq0NzW5W6WGfwlXLbRBr3Nm0ZI
   5/mYjnEgVObP1ZThvQJUaPQYb4xONllCiLy0uGtrj6uVlpJfUhFA8gnvC
   T3qp7TB58HUo9DrPLkGqPr4LiX96oKjnXnGQSKGa1i02/L7voRN/zcQhk
   BQFSAvOxeXdK4PXUTUU8f0rQ/C4RsQs8vTa4YqsFeaVy4RxnurhbjxyZU
   g==;
X-CSE-ConnectionGUID: jaeMZAFlRKGvg+0ipsyKtQ==
X-CSE-MsgGUID: gQ51SDOeS/CbMIn9dxTI7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="108451424"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="108451424"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 16:00:35 -0700
X-CSE-ConnectionGUID: gUaoEh/vRvS+815kzKfCmw==
X-CSE-MsgGUID: Ns5Uu8XdQvKkte+OqqUYOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="254435289"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 16:00:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 16:00:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 22 Jun 2026 16:00:34 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.37) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 16:00:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rznrReo7YS7K+yGi/DLzee6CQV3zeRdWHf5c92a52/brgJNHnN+w5Bw71K7hx5eql4rlvhZFcmXybAE4UBunDFBudvPxqMeKSvtisX/1tNNesDKsBu1KKXGLmOGXcbadTv7LZfpKCcqkc9fZIH1InPXeyobexnjXmVpCPd0+LB+irG9z0gvUA24PM22k1KcooFOL0wKxjj2E7fv4hOABEl+g+efKdHTV7XyyrR/AMfA8ngoewcZHBBqna2wl86C/HTFtTa/wjTrvrAveodpzHbwqaiyLOeyUbIEoXaIZ1X0tvvA5kTfntuNfCc0I86EC1IQhi7gPRu0rwvzJdnPxvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcI4WbdFZuD4gt1YjCeNKuYxd4g8f1H+z+jc3YK9biY=;
 b=Ah3ru7wvAtC9OaQck4rMe5AxE/dDTh+mltDRe/FMOQ+TgMWkJoGkTmi62UCqRy9Cm3qIeub0in8LBS/dQrabWoUxKOYf3IivYiSTovu+uZUb/Jk/iWCEYSS00AKTlK+Y+JWDB7rCB722R7GWT/wCIpZA1bVtP8L0HqBzAjnRHo8frc5S4+pCXjAJPtfzIp/3dlh9upf1CtX9P/7R3jjVoFTs8Z5RlyY+5Fcwr4h/bWv5ToaV8pAXIHu0SG30zFacHhh5HSAiBjgLhlfzCW55ADp6JTVh37HsfJYUAAItoDrKHzkbYJmlREUSeaKGoakg7A2eX7sXBwREoTSIDO1E9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7593.namprd11.prod.outlook.com (2603:10b6:510:27f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 23:00:31 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 23:00:30 +0000
Date: Mon, 22 Jun 2026 16:00:29 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
Message-ID: <ajm-jVzj7TUeJkY-@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
 <ajRf2P2ChE7SExwO@agluck-desk3>
 <ddc91d49-c861-4737-98ed-9b5d2e583449@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ddc91d49-c861-4737-98ed-9b5d2e583449@intel.com>
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7593:EE_
X-MS-Office365-Filtering-Correlation-Id: 774fef7e-40e4-42f2-f7c9-08ded0b20ec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: 7aMV7CN8XMVVag3+qXlFUIWTVvRbub7QkWBhSxRz4JNawKJa6Vf6oaPqlyTaHgOJnLBjRJPC6lBTTve2IKEHySBfMomWwR8kzKPrJ2TqUkITuv0PviyTOT/haM+GE5dizH+Sep5hC9oDujK0olsBFQbQ4gzo1FICje4ZzbBniUbaG4XkN/IqIxDhoiHJrqLolPw8MY0K3rRJ/R8eUCQLXR9ndt5tC+gRKrqHoZcN5fLeuYjibL3gO2P0DWdGRj3uduxq3xDpIr9XUf/7gXhLgu16bc4lqz5qltlZ5S8qwqYwQhpCBJToyByUr16jOkSDjtC7Jrxp0jdmjNUCdRCIgdKWR1zrazl4e+w7T3zwjOBqzYVirc+y8xtiGrByX3ae0sAp0HwMlYdAX41onWoVFoWj64ijNVNKKLc74K11/eCLtmUy/hLgW17t7tPMyVeBuR5QrYfGMpTKpqOqaPamLRzcBogMpPb3wsSYqi2GcJwvg/7Oco5EpkFLqoURiVtXqq162rHxG9HhaXHG8goRroqiu+sGMP5+Y0L/uH3w0TwcurOBEQjlFI3oaG10ZUaOEE1uOgjM5wjyID8bhNo/FYsw8ZnNU0cEOfUeebsHwQmd8D6FT0wwHLnIh/WoDTvXsJ0n2mJ4E1runA4zYgE5Dd4BibovJJ4OkYAvZqObcMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+QAmPX6NSx+BCZoZlBpwzJ+0DJ9Gg5MFdIMu5j/Xv9Ou1EUcTjlrFeFHaPMq?=
 =?us-ascii?Q?2HaS8pCNrjbltfOdOKZ0alM0lWqAH+GFf0ocAQ2AC/rC4ZKcVO7/URiYKYtv?=
 =?us-ascii?Q?wLYivBwVhNWjBT/q4uy/PbHsCa8TxsCWdX6ddijbF/FehcfCVk9ndBxOe9Qz?=
 =?us-ascii?Q?/lbR4u6BzUewakC9nRGhl0FvxD1szHyO8sZJfZUrNJJwZkwVjQB+t0Ea3n1S?=
 =?us-ascii?Q?i1tJbVAtBOffNg3giTTpnUlEgttWB6aEPFfTKnxuK4yiEmhdCrMVpqiKvms/?=
 =?us-ascii?Q?oH7aE2+Q/iTc2rZ61vfMj++N62eROhjhUQFG2Lfz7YpBtX7HGsWWsUp7hsCD?=
 =?us-ascii?Q?FmsIG25JeRrO1Xa2usXuqwRgldjxTDhurT3++brYZ1kVELXn31GNf8+mfjii?=
 =?us-ascii?Q?CFrD8SXuJkd/e5uCB8LYuTKUKnRvvxdsDySfB06Zh5uFRwokbBuQgUwrIqnO?=
 =?us-ascii?Q?P7vTC8b5h5UjRITbwjKnW3Kdal8jW/JHYbPH9c1kIhfgVqxQKmdglSTiCqVA?=
 =?us-ascii?Q?ici53Fxh97qDN0DJ2OQZrTuxOelAsAombtMFhpX0bn8X3hCYgF+HB3qKDs9J?=
 =?us-ascii?Q?eX71ZcKH/noMuKbxxhOYZ7Hd2t3O3QCxjSzyK3Uutl4mApuVo4KkK4zjcapR?=
 =?us-ascii?Q?ACVY8akhQqtgFaHrtt53N5EQ1JcRA8EgLJNBandz4yGIdNBc0JSJjYu3TzAk?=
 =?us-ascii?Q?URX9ZVURc2EA3uS1tvq3rd/9IUcF+agm69uhgqBMBrtfQOMHoYukOl1sDa4w?=
 =?us-ascii?Q?a7n21vOPftdzftewIjqywQabS3HKKgr0wYeexkMEVJwJlSOGGMYQSUy0/94n?=
 =?us-ascii?Q?6TpvGIzSZ+ApmHI9u5SAH9lWPbDSot2N/EJql3+OXjO8JAGemsIYibTI17OC?=
 =?us-ascii?Q?ImjvpDDf6HiVaV8EJN7jXRK8Won0Cah4EDxG2kco0XYEZcegYoQjhRUPAX6e?=
 =?us-ascii?Q?j70aQdMM+4vtCDGsI6G+u7qsejG9ZV5LPrhAt913c5VKP+lK/a2zvKawxRcv?=
 =?us-ascii?Q?0LNJmXe6bGlrDHExauhmn5AILPRKgYCXySPtaJN9IS0rHIME9BYeASLxKMZQ?=
 =?us-ascii?Q?2CfMQ0s06jS2k5dKATBBtq3zvJ5AAVpUGLkQWYCSBfvyKfWge9eYlUYBOpxg?=
 =?us-ascii?Q?JF8V/iqbd5Aeb9Blg1i7yzNl2imKlNB5RZW4w+ZkEURJSFXCroympphStl1L?=
 =?us-ascii?Q?rbQ/VQHJvZxIMVZcQwITEuIgQJYxeRnMR1yHDgV4tH6sIBC/6D8YfFVafFaL?=
 =?us-ascii?Q?ZYwJOOPLk3tYPUDP2sBne7FFEaFyirBMTMk4tjQlrkiXGl5rrCiXx7MrBJ+d?=
 =?us-ascii?Q?F9n2iefhiw7ngHvQMzaT3EcZOhuFdX+9E2RT6sSv73s8AWnNMhHuzPX+V4nL?=
 =?us-ascii?Q?xXMYsB0YHTgn1PpimLDDLaLkllj3dtstNRdPGpbLv+vPzpqrvcTfd/8EWTci?=
 =?us-ascii?Q?z+ISAg/1+4VBeakFS//t2Zq6BcFUoKe2S1wToKIpo5RK88MOHpl1C2VJWH2D?=
 =?us-ascii?Q?Rr/tKlHwZIZeFDTPljDElumVcQRZTif1o041JUYfpyDcRHErWF4evcaXB9in?=
 =?us-ascii?Q?MHVBSbhYd0tYEGm+qDcFo246lyTE1L2rBx8TgNj3XpXC5swWO7ajOQ4Li2qJ?=
 =?us-ascii?Q?k7b3D59P5p6BUvTfVqoYARtqVgEPh0LnxiucSk9LGBAesngkvmpXEREs1aD5?=
 =?us-ascii?Q?zI0pnov56uowEpoqTGeJ5RB8UmyjfQ2t10apLuIskcxniJAtoYoqZeZxRuL4?=
 =?us-ascii?Q?BETmWa54zg=3D=3D?=
X-Exchange-RoutingPolicyChecked: DWavsRomYLhbV3SJ5UcpLdC/1x5slUlQes9dJYxN440K4KhNgy+pgWTbRcB40d5zcJwvNA8wYiGH3FdofLIF+QTSiJ7ZnZRkYpkgAmQyZgGQtUYcc/D4zsXEw6RIzSaAgfxtBkgmE/Ce4CPVX4sSvmRpOPWTDpa/5ValLVpfkCGYtExPk6wjFV9dvz73lo5Y+D3AH3anuzDv1PfbYgQ5JMAJEtFllc0ofK1xBJglUo9XuCPgiahM+jW2n+6k83gO8Pwm60xGXsKgiVfPzsZV+9tTtqfGYQXXKVzw55czvILPpyG0Aca5FSAWq7B6Shh103+K07JJZNQf+3bMdvmQMw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 774fef7e-40e4-42f2-f7c9-08ded0b20ec5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 23:00:30.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BoQEvy3eWHn4Xv7d0GN74baagkqaJn6dG5QhkhbD94CU3xMsXiryyE76Hcibb3tp2dM7fAKthEkNtZJBr0QyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7593
X-OriginatorOrg: intel.com

On Mon, Jun 22, 2026 at 08:46:31AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/18/26 2:15 PM, Luck, Tony wrote:
> > On Mon, Jun 08, 2026 at 04:22:27PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 6/1/26 12:56 PM, Tony Luck wrote:
> >>> INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
> >>> call PMT functions directly.  Register the telemetry enumeration function
> >>> pointers at pmt_telemetry module init, and unregister them at module exit.
> >>
> >> To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
> >> it be more accurate to register at the end of PMT's .probe() and similarly
> >> unregister during .remove()?
> > 
> > I agreed with this. But on further reflection I'm going to dissent.
> > 
> > There are multiple devices (at least one per socket). So .probe() is
> > called for each. Registering with resctrl at the end of .probe() sets
> 
> Thanks for highlighting this.
> 
> > up for a race with a mount of the resctrl file system:
> > 
> > modprobe				mount
> > .init()
> >  auxiliary_driver_register()
> >   .probe() for socket 0 device		rdt_get_tree()
> >     intel_aet_register_enumeration()	  resctrl_arch_pre_mount()
> >       mutex_lock(aet_register_lock)	    intel_aet_pre_mount()
> > 	get_feature = get;		      mutex_lock(aet_register_lock)
> > 	...					... blocks ...
> >       mutex_unlock(aet_register_lock)
> > 						... runs ...
> >    .probe() for socket 1 device			Does enumeration with socket 0 complete
> > 						but races with socket 1 .probe()
> 
> Could you please elaborate the details being the "race with socket 1"? Wouldn't
> moving registration to init() experience the same? That is, if registered during init() then
> at the time of resctrl mount socket 0's probe could be complete but not socket 1's? The
> move to .init() has additional scenario where resctrl mounts when neither socket's
> probe has completed.

See '*' paragraph below. At end of pmt_telemetry .init() all probes have run and completed.

> Are you referring to how user needs to remount resctrl to obtain all of AET that
> the doc patch refers to or is the race more serious?
>  
> > I may keep the unregister call in the .remove() because as soon as the first
> > device goes away, resctrl can't usefully run. So it seems a good idea to
> > handle that right away.
> 
> The "resctrl can't usefully run" is not clear to me since resctrl mount seems to be
> ok to let mount succeed without all devices probed (per above). So it is ok to mount
> resctrl with partial telemetry enumeration but once all is enumerated this will not
> be supported?

No. Mount shouldn't run unless all devices have been probed.

> > 
> > I will provide details on the reason for the asymmetric .init() vs. .remove()
> > in the commit comment (and in code).
> > 
> > Ok?
> 
> I seem to be missing a few details to understand this solution.

For AET telemetry to be useful all aggregators must be enumerated.
Running with some subset would only provide data for some subset of
the cores on a system.

So now I'm trending back to registering in module .init() after
all probes have run, and unregistering in .exit() before doing
anything else.

Some experimentation has shown that the asynchronous part enumeration
is just the intel_vsec driver kicking of auxilliary device probes.

 * Looking just at the pmt_telemetry .init() routine, the .probe()
 * calls for each device are run sequentially and synchronously. So
 * when .init() returns all of the AET enumeration is complete.

Today I dug into the problem that mount initiated automatically
by systemd from an entry in /etc/fstab occurs before pmt_telemetry
is loaded. I asked AI (Gemini) if there was a way to let systemd
know it must wait for enumeration to complete before invoking
mount(2). There are MANY options to do this. After cycling through
several that either didn't work, or seemed overly complex or fragile,
I've settled on this one. I can add to the resctrl.rst documentation.

It uses a systemd service to mount resctrl triggered by a udev rule on the
load of the pmt_telemetry module.

The udev rule:
$ cat /etc/udev/rules.d/99-rmid-telemetry.rules
SUBSYSTEM=="module", KERNEL=="intel_pmt", ACTION=="add", RUN+="/usr/bin/systemctl start mount-resctrl.service"

The systemd service descriptor:
$ cat /etc/systemd/system/mount-resctrl.service
[Unit]
Description=Mount resctrl pseudo-filesystem after Intel PMT loads
After=local-fs.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/mount -t resctrl resctrl /sys/fs/resctrl

[Install]
WantedBy=multi-user.target

> 
> Reinette

-Tony
