Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFFB14885D
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 19:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759780745; cv=fail; b=VQm4eh8/jEHTngF0O3IH0+HxB8OQbKBEeVWcNA2w0SXFNQiAD4My8WRC2z81iyI/6NdXDKwRyD9pFa/NSPZ6Vn3zMWOfp32F4aO8deLYIR3dIMQp7wjhUsWZleIJTKJ3FJrIEXUqeuO79CQPba6st+eCDGcXUUHJQOSnM3EbWec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759780745; c=relaxed/simple;
	bh=Gkkg2/maq6WQAQW/UyDi+c1p8NQto3EdpsfpM5TFpcU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YkIyiCleAZ6sguexRP5Tm34uKq+/0/BxIMv/km1xr46a9JD+blAQdKs6brJmMGmLtnWjRvahjIDa6PDpdZAszly/eLrkPvUX1HZQyh1ue3n2zqCWSHqfsJ1oopRBro4GSa+HWnMGGFh4/VNiTps/ibEm1fy/5YuMkuJKg+8Ict4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cEkGLXpm; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cEkGLXpm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759780744; x=1791316744;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Gkkg2/maq6WQAQW/UyDi+c1p8NQto3EdpsfpM5TFpcU=;
  b=cEkGLXpm5WKL/cPev9oXXvsdhgEw1dNuzMh6uj+Tc9NQyJWXEK6hV95X
   TKBk76QTK3aO55GcZXksFCufwyGEmF7GP9+vRd+Sq8IdTYW7iyr4pm064
   VNV8zPYYmgZDNaIicGxRA2LFGWZHDeWIDIVWHaO4095WGhz7+Ef4660Ut
   88h2wJSX+NZprhYmQa/YZkr31S9X4Y5YssUEIpaLIancpKrdRwKhT/EAA
   dXom9oi+F2xXUSI5RBC1k4Yrq6A1svt6dNGBci2z92I6WWHH6pirUFKls
   M13Go+gq43nZQeDwIagTEYsiJeuU+k0VFsWB5jhc00gnL7WhTfmbKkv3h
   Q==;
X-CSE-ConnectionGUID: +xqc/Ti7S0WSkdFbIu0pfA==
X-CSE-MsgGUID: CTnogdsDR0uTJF6uzWyQKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="61169682"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="61169682"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 12:59:04 -0700
X-CSE-ConnectionGUID: SEilJ5/3TVSiaTQhnBidXQ==
X-CSE-MsgGUID: y5yJrm9wQCiDo3/rJmH+AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="184249272"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 12:59:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 12:58:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 12:58:59 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.56) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 12:58:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCW0FaijQT2bY2aXSGZZU5sVVVIsir5vVBRLUvQcNKRxWAjKX24ZpWbl88OTFS1O+3nX/2/llLTR6EusPWXwglbN4TWlZrhZxN3/fAeAholuXNowQsah2ihH3GEcn9WvJH2VEd2hzmd6XfjgUPEq3jHLeqmqUdTV6YYhXKTwZ50a8+lBBScPl7x1/FwiNt8WUwl7kk8mm46RjEow/hlQ2hrZShiEiXuYp4rMKuLsIxrVJPlaLcNQwKGK1eODu2U3+Zexe1uJrgYrdkb9dCoxJYKmK7jvkcixNN41MVteJY+8WndMWgDtpC/KU+SFyjh+Q8xPlbwkl6XPKBL1FlVz9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCq7f9wHKWtDrco+CtOtudExOpBx5kBtOg9wzGRqCOY=;
 b=kSNI824X7a8wgKw0sA8nJeSl9oM6/naYFwf6vABRY0Fay66Ip15ELLaB+MM+JPJztfHDm9KtrToT0l2axEHU0Uq1UkJLv4UIvZD3PCPXaQwVX6FJdzFujHxTiqoTuzvL5kyN+S+0/8ZrcvA+5fhMgJqK5mUXxexQ4nFU2G9C3ZNOt7EDKhd7ZhFqzOnOKOKtItRruzDOtSMy6HvjT1koU2fBflNQp8zv4T7ggcL/cetFwzqJXuO4iEUb0dsJl79iqdBqQw19OA9va2Df958BSK69xaiLe4p1hSWWW/tL5c8t/WzDIn8L/xK1cWbCTQxONhN/Wt8x+1F6SPlGtm/NSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB7119.namprd11.prod.outlook.com (2603:10b6:510:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 19:58:52 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 19:58:52 +0000
Date: Mon, 6 Oct 2025 12:58:50 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry
 events
Message-ID: <aOQfevoOYWsftGG-@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-18-tony.luck@intel.com>
 <aecb9aaa-5b94-4787-a976-a633831596bf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aecb9aaa-5b94-4787-a976-a633831596bf@intel.com>
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH8PR11MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: 189584ef-786e-49ab-3c92-08de0512c62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xaWgX/yZgl1oY3BoUid0OEFUaMtygFemADWLGrsH4QS7OZ2mGUORoQB3U/C5?=
 =?us-ascii?Q?Vl/PEbcFHFzrMpG5xjZ2vIYMd92HzQ84ZSKENj8h/Uq9qkSNNGRKGETgR2f1?=
 =?us-ascii?Q?+dpcA5qBQHxP80m35sURA9KJ9JgbDYi7wyhS+Du5kBid7XsNbk29RKGf6qDc?=
 =?us-ascii?Q?BDzhKEuBSenM3/HUgYyBfr6byjWfjndq56IHr3QA0C/+cCUs5b7ngn9DdKGw?=
 =?us-ascii?Q?4+Y/ayQk+JQajg+mFE1I/BveK4a1ESTceY2Dh3XtWebqtcBrqkLTRJJS2oW/?=
 =?us-ascii?Q?ohX+OtAEVK/CtTWtFIdXE6CfFSpwSgjd4oQem+cJGWwZscqP5qHGHTHh3pv7?=
 =?us-ascii?Q?t4xTD11/7tNfS61u1bgvaaKjY/mzApxHvY4RB04uwQP86CvXOq0voisAtUR5?=
 =?us-ascii?Q?ttykxUId7+24WeTC6DUK+jajF6/U9iS1z+NNmffD2N07+6RzF6I7BQcy2yc1?=
 =?us-ascii?Q?bGQdXuLlVzaBKZeU6zCNsOWRCDPdoXO2yIS03zIHjE9xXhVFOBFKDpVQm16G?=
 =?us-ascii?Q?ZKHEkr6X+FPLlkj5F1MmHmRS5fw8/9R+6x6I2JQs7B8lxAFlsHxqx9vEX5zS?=
 =?us-ascii?Q?JuEKbfnMcb3qI6vNjlXTO6qdtO5ZBs2AuEPCUMHAtWS6305bX6wuUkOyn7uZ?=
 =?us-ascii?Q?UiU6UfMMXdLk3FbjG0E4lgS3L7Aq7vZhyS6eN9ETu7v0NVBml4imAJezotua?=
 =?us-ascii?Q?KOtO1gB1MXN5oc6GAJvThkw4NCdPDGKHBKHTN82ohaQbPyiXxFrzfgyMWvX5?=
 =?us-ascii?Q?WhICo+/a78MgNGmBiBoK/e4llsGv30vp7BSgMDMK198cFACMYIiuiRwnr2SD?=
 =?us-ascii?Q?DrOS4yCyFvPbQnrWB/ew2HPEDN26c19mJPdID2vGsyksHqtyc7wPttydhBjs?=
 =?us-ascii?Q?NgiyJA/ozm20Ku+7MYRaCabI3Yo3sSA5HLVUFscHpcP2yjKwMEBT+/xJPO2e?=
 =?us-ascii?Q?eGtKyibALfzr+yBP8LNhPZHZNAR68IQj1rglUiC+5b+Ijk0ajPt5AZkn/A6e?=
 =?us-ascii?Q?Yo79qoz315IGFZP6RqneYHbFEP3JkFhWL+NgOidcA2OK0OlYuqMDDZOimqVD?=
 =?us-ascii?Q?TZI4Sp8EObBXL6YmjZiaNVVGEEen01uJp+7hi2cV1vxENnaNUlBqUKWIxzfB?=
 =?us-ascii?Q?fdyAhaIQbKoZ1VWvJsI60RCMd03PRDB/BpA+/a6W+k4MzBMwkF6p1SJ3uYpg?=
 =?us-ascii?Q?xDwQQhQlgAK7dlVDBfWLDNAHPL7ILmyQEj6c+0wtrVG29PD3g0eLjFW5Vp11?=
 =?us-ascii?Q?QXFCuDEgKf1lOpZ2mInIsKTmWypFY6AmcjefiGA3hlFjjRyo0gXxgOBOTbCB?=
 =?us-ascii?Q?IS5xVpU6rSuHvaKw5W0EvHHBsxdM9DFDfQ/S6tgT6L/LPp4Q0Tu9HByCbW38?=
 =?us-ascii?Q?Yr/83W3oUcZzzbTz6REM5NOgSVltVm9NqI0AJGoftCu6K5+0BJkrQwPyyHCk?=
 =?us-ascii?Q?Yg8uSkJHB0Z9KtrqlSQeKqXz3xEKNTvJnO+53tRgFgoniivaFGQbkg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xyt5HjEIgTEAYvPFTDy7M8TA6Tx3jdoDso+bxI2Lktb+CxcKWQ9H4MEVKod7?=
 =?us-ascii?Q?oWrj3eL1h67WCrTdaEyHlLqsqHH5YAkP9hxysYV8uCs0/JLIlkKoOO94AeGc?=
 =?us-ascii?Q?SQlJrAaU7MaQT8tEM2h2uxlE+q8js27INsj7V2DKwOHjKNscTO2SAgeEE76w?=
 =?us-ascii?Q?ie+8yjcb3nSQnbAOks+rMrjP1fRX/dIQcG3fBqloe0f2V3NFU0W2N4k6xAiP?=
 =?us-ascii?Q?Z1gvyPoHew1Mq267X0yuab6cZHpTR5tjh9mY++9D9saIN6eYe03ghZSdX4aS?=
 =?us-ascii?Q?mHTr2Ve+tVcX02pkqlPKcJSe4Gi/zEb2uggGlKnlbgDfB8HhCo8eUHpe879B?=
 =?us-ascii?Q?m8i21qKPqxF38C2CUwy3gnHez0UIQ5Om/+gxf0NhG/WIAhDhDV2egRjGlBOX?=
 =?us-ascii?Q?2STLU/2wJIQquCmatZWMOoHLodPoHDHSm3vUdaSOZHZdxx9nzA+b6x/PwwTR?=
 =?us-ascii?Q?ZRqTjggR5iTxbHemoMv4qQWrUSlVdXhrfDIC0JxJkgpDpOAu7GDWHfrNoySF?=
 =?us-ascii?Q?J/m7KuJoM8fy9Ofwk+HEyyOAMVpyxjKK6CGooiXjVmBWF0EI3gpCrO9gF7c3?=
 =?us-ascii?Q?+Kb4hNP/aOxJEv1uMwP/2e2pSFLAb/xurNeJ1D+2O/8NMXANiyNAsQnLde+W?=
 =?us-ascii?Q?bm4YAY4Vsxc1l0pdc/ukkVQXOuBs3JGRdLFw3UzlCerm7vgfNTI2WU2wBsKH?=
 =?us-ascii?Q?Jn03TJGiMemZoXKYRgpKBUQNGDB3cT0Nw1iwbMSPF45Xt1T4kLMPa4BGq5sx?=
 =?us-ascii?Q?g2L9i3YiMBiZRuIxz7QzB1Y96SmN6ybKxHOUwyXQW3O5cl8M7Ospjfgcp9cw?=
 =?us-ascii?Q?6AlN8BZsfU8QLe0/FS+YpJ65TPrpaAC+/ELkFLNhjpOuStswJISD+EFg9l75?=
 =?us-ascii?Q?gTrg7pxyNXlv0aQ5SZuX4ACbSxIkbHGbj3lZbyvsk+DtF7H3IRfg8NyvtF2Q?=
 =?us-ascii?Q?Go7a2qbiu6tSX1H6W1yFR13NI1OMLoxK3+K2FD+hb+8rubVbj5kmpgRi+RgP?=
 =?us-ascii?Q?ND7vPb9Wpzq9iR9T1w8PvQFeY+5PNX0c5rKdVZXQzPzHFe/GhWZ1gaJY00FQ?=
 =?us-ascii?Q?D4p2acG05XexSFbsOjP7LEwI3DCiQMuLAoxN6VBj5wn6DVvRmpJc382IT+H/?=
 =?us-ascii?Q?EK7mqq7bBGgfXEqWa62lKoGamf1fFe/Gysr7PPatZt9A+HQRdZ6D1J40UmeS?=
 =?us-ascii?Q?ShxczTH6Agh5udFQuxq/ZyAaqMUDbO00ZpAorqL8h/IBVuF7H9CgRtnE7QiR?=
 =?us-ascii?Q?ifyeE6px8HsCOJ9Zbj6lv/Oyk9d2K1+NHb++62HZSxA7ArL+din3P9oUCx8P?=
 =?us-ascii?Q?z4w66Yt+qlJh1RFEtEu2mNU+B6bY5RXAHsMKqjbVrLUNn+Yvve7tSr3QIy9T?=
 =?us-ascii?Q?xAacORZPVv+EuoQoRhKe2kX7v4AwQrtlzX05RFQvESDgIU1gIJCy0HiHgGtZ?=
 =?us-ascii?Q?xudd0ncPxRJLqWZcGz69g63iYnKy8qOGQh05BwHsG4sct6t41V/AdgpN4TUi?=
 =?us-ascii?Q?IZSFiecaulAUsVYHryWhRKmXI5mfTN2kXeismNCknOwiZYTdREYbaUMyeovA?=
 =?us-ascii?Q?t3EpwiV0/gKTAplMqqYiSC3Mse3YdKfFhq6O1bxb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 189584ef-786e-49ab-3c92-08de0512c62c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 19:58:52.7540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEXastvHtWYhlNWLVrlyyGs8SUma07WFbLifa8fwHxldzxJ7AyE09UYFkuCN7Ej7BbzsHDEV0UPZnrSYF+1Uqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7119
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 04:52:01PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:03 PM, Tony Luck wrote:
> > The INTEL_PMT_TELEMETRY driver provides telemetry region structures of the
> > types requested by resctrl.
> > 
> > Scan these structures to discover which pass sanity checks to derive
> > a list of valid regions:
> 
> The "to derive a list of valid regions" does not align with the
> "At least one region passes the above checks" requirement. If this is about
> valid (usable?) regions then I think (4) should be dropped. If this is instead about
> valid events then above should be reworded to say that instead.

Will drop "4".
> 
> > 
> > 1) They have guid known to resctrl.
> > 2) They have a valid package ID.
> > 3) The enumerated size of the MMIO region matches the expected
> >    value from the XML description file.
> > 4) At least one region passes the above checks.
> > 
> 
> Everything below is clear by looking at the patch. It can also be seen from patch
> that enabling is done only once if there is *any* valid region instead of "for each
> valid region". One thing that may be useful to add is "why" all events
> can be enabled. If I understand correctly it can be something like:
> 
> 	Enable events that usable telemetry regions are responsible for.

Looks better. I will use this.

> 
> > For each valid region enable all the events in the associated
> > event_group::evts[].
> > 
> > Pass a pointer to the pmt_event structure of the event within the struct
> > event_group that resctrl stores in mon_evt::arch_priv. resctrl passes
> > this pointer back when asking to read the event data which enables the
> > data to be found in MMIO.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++--
> >  1 file changed, 36 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index f9b5f6cd08f8..98ba9ba05ee5 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -20,9 +20,11 @@
> >  #include <linux/intel_pmt_features.h>
> >  #include <linux/intel_vsec.h>
> >  #include <linux/overflow.h>
> > +#include <linux/printk.h>
> >  #include <linux/resctrl.h>
> >  #include <linux/resctrl_types.h>
> >  #include <linux/stddef.h>
> > +#include <linux/topology.h>
> >  #include <linux/types.h>
> >  
> >  #include "internal.h"
> > @@ -114,12 +116,44 @@ static struct event_group *known_perf_event_groups[] = {
> >  	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
> >  		if ((*_peg)->pfg)
> >  
> > -/* Stub for now */
> > -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > +static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
> >  {
> > +	if (tr->guid != e->guid)
> > +		return true;
> > +	if (tr->plat_info.package_id >= topology_max_packages()) {
> > +		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
> > +			tr->guid);
> > +		return true;
> > +	}
> 
> I have not encountered any mention of the possibility that packages may differ
> in which telemetry region types they support. For example, could it be possible for package
> A to have usable regions of the PERF type but package B doesn't? From what I can tell
> INTEL_PMT_TELEMETRY supports layouts where this can be possible. If I understand correctly
> this implementation will create event files for these domains but when the user attempts to
> read the data it will fail. Can this work add some snippet about possibility of this
> scenario and if/how it is supported?

Yes, this is architecturally possible. But I do not expect that systems will
be built that do this. You are right that such a system will create files that
always return "Unavailable" when read.

Is it sufficient to document this in the commit message?

I don't feel that it would be worthwhile to suppress creation of these files for
a "can't happen" situation. I'm not sure that doing so would be significantly
better from a user interface perspective. Users would get slightly more notice
(-ENOENT when trying to open the file). But the code would require
architecture calls from file system code to check which files need to be created
separately for each domain.

> 
> > +	if (tr->size != e->mmio_size) {
> > +		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> > +			tr->size, e->guid, e->mmio_size);
> > +		return true;
> > +	}
> > +
> >  	return false;
> >  }
> >  
> > +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > +{
> > +	bool usable_events = false;
> > +
> > +	for (int i = 0; i < p->count; i++) {
> > +		if (skip_telem_region(&p->regions[i], e))
> > +			continue;
> > +		usable_events = true;
> 
> A previous concern [1] was why this loop does not break out at this point. I think it will 
> help to make this clear if marking a telemetry region as unusable (mark_telem_region_unusable())
> is done in this patch. Doing so makes the "usable" and "unusable" distinction in one
> patch while making clear that the loop needs to complete.

Ok. I'll pull mark_telem_region_unusable() into this patch.

> > +	}
> > +
> > +	if (!usable_events)
> > +		return false;
> > +
> > +	for (int j = 0; j < e->num_events; j++)
> > +		resctrl_enable_mon_event(e->evts[j].id, true,
> > +					 e->evts[j].bin_bits, &e->evts[j]);
> > +
> > +	return true;
> > +}
> > +
> >  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> >  		if (!IS_ERR_OR_NULL(_T))
> >  			intel_pmt_put_feature_group(_T))
> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com/

-Tony
