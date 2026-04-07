Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C11E9B3A
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585626; cv=fail; b=d5G2hDc9eNINUqlbYpjO835CtE4brnq7j9a0hfj49YXOaan0V4+HHNGzM4fk4R4GGMnyZa0cPP4+0HCziz6PNwIrh9rraTztO8lJf43Pw0ojObiHUL5ZNqTCIkQQGMkyDvid1xvVm6fERZCGb7Zr+2OIX9SR6UHB8FLiz/U+0VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585626; c=relaxed/simple;
	bh=P0+rH4rxgdz0EgOmC5VI6VtF+Bn5K2bF2FOUJT5VQ9I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SOuKTv0O/c0DmQa9JbHQehUrwEXqa+EoAT2M8jCVlzS/xDFkphdAuREo/dQ1FcKAdF/37JsoS6BAwL7xXic/ziXgYhI/NCTRiByhrfJ6nqwTbI/IvJyxuJ4eyKt8d5RqKZm/bdbuKqZ1a4K1On0CReDQuNieVThiOCvH6HiSaaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+o0sdG6; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+o0sdG6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775585624; x=1807121624;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=P0+rH4rxgdz0EgOmC5VI6VtF+Bn5K2bF2FOUJT5VQ9I=;
  b=A+o0sdG6PCFVNQ+Uap1ybpyZClaFUW+VeG9v/izXPqu0quOsi4KVQH18
   SXA7WLKYPBjFEFJwsBS1UqraYs9alKd8P+k7qgcczwDB5HETo26AKfDqP
   iBf19Fwjo+wI9HBRC/YlyFUA4ScUC56YEQQaHuZui2Grx/+HmvPeKae8H
   lWye3eqv0dFGkojoFJsRD9dOORIJU40rRI5UXyz20EDg5BUhmhyJ4va2D
   Gbz5lkYjVSXY8z2YG9wz7yWCDdZIZTLrj280jOhLDpOGRoNk0HHIACHRe
   gfNbqQksLGWve8w7eWHKNpLBVWcZQSgZHmt7BKDPALvZGFVQF8KBG4kYT
   A==;
X-CSE-ConnectionGUID: R8ANRtE4RPa8rjl5FeFnKQ==
X-CSE-MsgGUID: HwwXpvtgTpWL7ju3JCd8Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="76522285"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="76522285"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:13:43 -0700
X-CSE-ConnectionGUID: UR9GOdvwTOyhqcCnRGFFtA==
X-CSE-MsgGUID: /nRgZZpBTzihXglEGOqDTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="258668007"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:13:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:13:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 11:13:43 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YAVh+ZDyoXYA7VOx/Vjj35lgsIyq+zomErX05SL1OK5KssdnoRPv6MCeAfwCycvsYJLmB/Q12VNGrQ3wyclEKBJ6yBx2NmEipdOjd0fudM7En6wCv3J90XdfV8DV5U/ESJvqJz45ijQ8tV/39tihl1+cc+KHsdosXK62g/Fn6xAjPizRq025Jw4hUK5Qh2u2aLpW3yHWvFj/XO7BukZnXE4X5i+jAK3MNpWf3KguKT9dAqGGoU3AXmJd5XdKB/gTD0vQpunoCAlxJ53K+mRLYz1Wt/iHDR5/mTmAGItJ67fxy+xcK0f3bzjIaqIZGbEIfo1NIKmA+mdZ4qc9Ag2mew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23ny7JCeGJ7ayD8pyH9b7+pOjn6J32r6XhbviAK6gco=;
 b=XOx2ftLdZlG9BvcdgTjevj8o1Gosm6ku2hffYumVF6xPEIGOndeaCpMMxy4BXcyde5rYxrWJoZyn7CO7Gl66O5UbhwE2ckMQQqkZEFzQXliG+YSiirOyqRZOqcrNugorP7qVItoivb5QTl8NKrFuSxP3t9tljlaCyGJnEgdihvTc4oMbXGkagnag71x3MMIWFsooGVIx3Lk4OPX58uuEoQrQpiETAaUOV5y+8qUvfQ7qgLqBdcph5ZO9ioKBeDjqt7I2fyqa4w895lcM1rZWTFfzITMWVEsTsgtWpRTMJwlI0VZ/TVKyk6wDHT5yqUh081sOljOKGi7lWzdf21KWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 7 Apr
 2026 18:13:39 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Tue, 7 Apr 2026
 18:13:39 +0000
Date: Tue, 7 Apr 2026 11:13:37 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 5/7] x86/resctrl: Resolve PMT and TPMI symbols at
 runtime
Message-ID: <adVJUSFFypXYp4qT@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-6-tony.luck@intel.com>
 <435073c9-02c7-4816-ad07-fdec09610114@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <435073c9-02c7-4816-ad07-fdec09610114@intel.com>
X-ClientProxiedBy: SJ0PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:332::8) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: c28f7a43-33bf-460d-c42f-08de94d164b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: fqRZZJNoapp9xbFC6rKWExLrX/YcNb5Ye+Z4mhAqp6KOT0Vva2d1ILV0LgnZn0wu/mjfjNr7jx2cqJvAgmN/YRCCoYyl2ikOkgmftDSl+JxjLDa/MfR/wJHzPBHtwTl2QDfAMI/HqJXvC+MvnbPFviWWy4K9FyWnipUh+vBQjtTfaG7u4XCkzCD6tK8I6VWyrD/bE01MHEt87xUO/UQcLGsu8drp+xlW5bB8SO2u2Llxd+UrOo0o6PgA8XmWHj4hFpUF1YWzk+O+qPPYshxKCCBQvSoi4lIQIzc13CPEeDA5whdw2zQ4psWw8Ay71bgeGJl+V+R6srorZPMhS/uSik7hw6my2cZva6qtyCNz7mGkTG5W+etgADP7AgRutsuAYGZk+2ouXEQnSs8mgFerJKCR4xQ8QtHutVm53+LyZr0cs+JwVngvN6gJI4lXEvXIw5RUEQuTzwgP9FAexx+qkAULDKufcxWadfiQ/22qPJmP7f7SP1luq+phFReb3v3yjOFbxjtXW6ShZPGoHJa2CBWRVdfYXEvd+u8aqNzyQ7lwqK0U7soB1FUaG6GmQwa6Rner67usGJZ1OBrJGDQtTvHo7ylm+yOQaQqOTRuWqYBe3lDsyz2SbV/LlHAewWgQYGua4yN0GuTcgTA8QM75ECI4ifKYOTkQRfLp2nH860KLckKTdqLWZPGzYBzgvCo0uc+UsHgpJnIevd7Ilw+S+T1z7iQkMPkBmt1mNxuiFEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HnJ1s19KyhPxbt2er0Gxa0HmIdYvt3kNrRk5ZkNwlkVheUU4flXoTAuh8L81?=
 =?us-ascii?Q?2zXsRbhEKjiaXFpyMoiypmT6s14OOOpnY1UuVf8ah1WE7bDnCUucTgpmODUI?=
 =?us-ascii?Q?p4YAlOX/xe2dwaShOWGTyPHmp0m5LskiA1y7ISD9iQucZeCrTZBZNvQu1l2Q?=
 =?us-ascii?Q?yYA9b1alfgzATHFW5ztp5s3I+9q+WFUUNFOiwyOpYhMjdDbkQPfnEtGIu+nY?=
 =?us-ascii?Q?RJdIk49xeMANlr24qImvYcE0FVPW8r9PAWc7a7hJjUGnSeNOM+YU0AdIbjpe?=
 =?us-ascii?Q?MVBJ75YYXTSIM5rwP0TJcI/0/emfklguvN4bJ9+bTJKzOjtzStJeQ+1ekF4m?=
 =?us-ascii?Q?N52aIrwWwjDwv/kJxG1i4giY4yuivMY3SOCnkc3XFqnxuJ6lwY8XRUTMevmA?=
 =?us-ascii?Q?LK7UXjaMrO61RcO54X7q8j2VwZPKK8SF0xrV4EyiGN0lI2c1dzIEjPAM2pSR?=
 =?us-ascii?Q?GSCcH9Yz87J8iHLT8YbtboFTkd8n0FdEeHZbsnR1pgJSTmqK2I8tAiefR39k?=
 =?us-ascii?Q?3b7NvchmQOo2ZRVU0afgqujb5FOE4bAbf2+KOjzqFnmE05A71jpQBQJK1CMd?=
 =?us-ascii?Q?T67RwBw6+hVbW8Rs9yDqSPztbP3wMiqpoNGPBxwj5qhY5gPomLznLaY4u6MP?=
 =?us-ascii?Q?fL0FEtVF7hNbP9CrUGjHyhCLgYexi4fN7Jnd8lx/Bd4TIO6XtN8T3sa/ttZu?=
 =?us-ascii?Q?w8UsmKVa5TUN00yAZe2fVuTcwevZ9K1EjGObZmeNUqHbTzikF5vPTXwI94CN?=
 =?us-ascii?Q?2LSMLhjIO/1v98/MCfgVIjFjZVYvGgn9qvzu8WXNeL8OZ0d9UjEollEo+vhy?=
 =?us-ascii?Q?7UJUBuxkC+gyAL+nmw3UqKgbU3/vkPl9mv1hkR9UaOnKq8navF0XWvgMwLn8?=
 =?us-ascii?Q?P8/A6FmO048ddvGbw0hinGvXAeNmbOOyC+s5iOWhY3ApqM75T3gk8qcG28LE?=
 =?us-ascii?Q?eovXFSMszu4CPMo47F9Q3ER2GjXc+ZcUsH6kBYlfbnEcL5j9a9KzaJaennjy?=
 =?us-ascii?Q?ChOjvVqjNO8TTcm0jLMgHrvLmsqJL/TSCJOUy0wypDpPUdYIl4lq5S/nUk8b?=
 =?us-ascii?Q?K0loO5GJpoSIvK1kkm7gNxkcpXzBqcv2fD0kgj+NcKct72yPidikEx2eNRoU?=
 =?us-ascii?Q?WVxO5Jmcm3HQGMkaTBKj2Sb3KxtmNBzz411eWQpzVWfaVKuyDn4qNDW9C3pK?=
 =?us-ascii?Q?KDnPNI5hnM440Cwf2nmeJdGC8EKOMC9LwRVjBj9XD+lRXicUHdcNIPhB4tZV?=
 =?us-ascii?Q?wSBgvDcxNNSaI9OJ6DKOl+EqFJEeWBoVPu3bMzhGWKDe6nz56jZRRAqH1kYX?=
 =?us-ascii?Q?sm0s0m4yFlqabHSMtF1JWjMTUEfWBmyl4dmKMwN8DzhWD0NuOWT01Mfd6+qF?=
 =?us-ascii?Q?S6g6SQekmnOacvzAS6madMBIwX9y/WdDDwDEZoNA2dJykeAKzTUNsxrCjhrT?=
 =?us-ascii?Q?zyPq9/zpED7TausTYi59+RU/acKkO60m5j8YjW66YyLHZAHAJLPTb9g+LE+f?=
 =?us-ascii?Q?s3xRSetu3vCI+PCdPvVjDCA1JKkWJTFvMaCEBUJ/zPdgTv/dJjHf4FKsZLu8?=
 =?us-ascii?Q?lTCBl4BEqhKOQwzCugJlrMyszrrABmEPi42KXzrjDsbovMRQoDCOlyxQLol1?=
 =?us-ascii?Q?IuNxv1DIRSOQenzlo/jiIPyC8i10bLgUbKf9E4Z5LZBP3ZCTdS2QpPvjOlTJ?=
 =?us-ascii?Q?ZloCZb6KfbFNHQjf4/1GcL8cQ3UAlPi9lSLRX6a1jSzC2mj7o6BZJ8kfreNH?=
 =?us-ascii?Q?m5wkOGMnEg=3D=3D?=
X-Exchange-RoutingPolicyChecked: YzsPmtjudutzkcUguFEUPzQIqB77+ip9YkrphmHPA4FTwLcp7clZix5M4/84d0W4yjvFv7fEuXgmo4jjT/QhvZJtb5WYmqCe9vfnCPTvGfnloddDZ/hOKKRONR7GPMtvpTve+f2ddro18IkG0X+jzk0NFM2HYzFz8g4HkpblGavu3eYMVFv7U5mdXQ9T9rdpC9GJT4T5NIcFWdQzg6VlkxAEkFKhcDlSdtr0ocPYKYb+BbDe+ceiGaL9kyzx2ZrTkk7s7Yn4asjBCIlowswLslxjtPdQovyw3hTAS+gmRObfZmkV8c8Gd1e6tqlRzciU6hNJa+8T/o6A3sgI/+QmcA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c28f7a43-33bf-460d-c42f-08de94d164b9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 18:13:39.6517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzPoGrEzLLv3hI/c52qYvv4+DT8iJW6OY6kxxkPu9DOvRny8dJRrJBihrW2E0MQicOx/0kwU568SbhJxoaaf5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Apr 03, 2026 at 05:56:35PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/30/26 2:43 PM, Tony Luck wrote:
> > The resctrl subsystem is always built-in. Currently, it has a direct
> > dependency on INTEL_PMT_TELEMETRY and INTEL_TPMI for Application Event
> > Telemetry (AET) features. This forces these drivers to be built-in as well,
> > even though they are logically separate.
> > 
> > Switch to using symbol_request() to resolve AET-related symbols at
> > runtime. This allows PMT and TPMI to be built as loadable modules.
> > 
> > Update the mount/unmount logic to manage these references:
> > - Acquire symbol references and pin the modules during resctrl mount.
> > - Ensure AET structures are cleaned up and events disabled on unmount.
> > - Release symbol references and unpin modules on unmount or if
> >   mounting fails.
> 
> If I remember correctly resctrl depends on the mount being done much later
> than driver initialization to ensure all PMT load and enumeration is
> complete by the time resctrl fs is mounted.
> Now it looks like these modules can be loaded dynamically on resctrl mount
> with the functions learning about PMT feature groups called right after.
> Considering the change in timing, is it guaranteed that if
> intel_pmt_get_regions_by_feature() is called right after module probe that
> the telemetry driver would be done with its enumeration?

You do remmeber correctly. Your concerns are valid. I'd seen that the
pmt_telemetry module was auto-loaded, but hadn't tracked how/when that
happens.

The sequence is the intel_vsec driver is auto-loaded based on the OOBMSM PCIe
device ID. That sets up an auxillary bus which pulls in the pmt_telemetry
module. Adding a debug pr_info() I saw that the probe routine for the
pmt discover module was called at kernel timestamp 42.720156 for socket 0
and 42.725646 for socket 1.

Adding a "resctrl" line to /etc/fstab attempts the mount at 39.667. Three
seconds too early. No PMT events are found, and code in this V4 version
of the patch series marks the system as AET_NOT_PRESENT and will never
look again :-(

I can drop the AET_NOT_PRESENT state so that a retry will succeed. I don't
see another fix other than to document this limitation.

Workarounds are:
1) Change the CONFIG to build pmt_telemetry into the kernel (where we
   are today, but haven't heard from Linux distros like Red Hat, SUSE etc.
   on whether this is acceptable.)
2) Delay mounting the resctrl file system.

> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 93 ++++++++++++++++++++++---
> >  1 file changed, 83 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 743a1894fe9a..14b472106f52 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/intel_vsec.h>
> >  #include <linux/io.h>
> >  #include <linux/minmax.h>
> > +#include <linux/module.h>
> >  #include <linux/printk.h>
> >  #include <linux/rculist.h>
> >  #include <linux/rcupdate.h>
> > @@ -289,6 +290,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
> >  	return FEATURE_INVALID;
> >  }
> >  
> > +static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
> > +static void (*put_feature)(struct pmt_feature_group *p);
> > +
> >  /*
> >   * Request a copy of struct pmt_feature_group for each event group. If there is
> >   * one, the returned structure has an array of telemetry_region structures,
> > @@ -300,7 +304,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
> >   * struct pmt_feature_group to indicate that its events are successfully
> >   * enabled.
> >   */
> > -bool intel_aet_get_events(void)
> > +static bool aet_get_events(void)
> >  {
> >  	struct pmt_feature_group *p;
> >  	enum pmt_feature_id pfid;
> > @@ -309,14 +313,14 @@ bool intel_aet_get_events(void)
> >  
> >  	for_each_event_group(peg) {
> >  		pfid = lookup_pfid((*peg)->pfname);
> > -		p = intel_pmt_get_regions_by_feature(pfid);
> > +		p = get_feature(pfid);
> >  		if (IS_ERR_OR_NULL(p))
> >  			continue;
> >  		if (enable_events(*peg, p)) {
> >  			(*peg)->pfg = p;
> >  			ret = true;
> >  		} else {
> > -			intel_pmt_put_feature_group(p);
> > +			put_feature(p);
> >  		}
> >  	}
> >  
> > @@ -325,27 +329,96 @@ bool intel_aet_get_events(void)
> >  
> >  void __exit intel_aet_exit(void)
> >  {
> > -	struct event_group **peg;
> > +}
> >  
> > -	for_each_event_group(peg) {
> > -		if ((*peg)->pfg) {
> > -			intel_pmt_put_feature_group((*peg)->pfg);
> > -			(*peg)->pfg = NULL;
> > -		}
> > +static bool get_pmt_references(void)
> > +{
> > +	get_feature = symbol_request(intel_pmt_get_regions_by_feature);
> > +	if (!get_feature)
> > +		return false;
> > +	put_feature = symbol_request(intel_pmt_put_feature_group);
> > +	if (!put_feature) {
> > +		symbol_put(intel_pmt_get_regions_by_feature);
> > +		get_feature = NULL;
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +static void put_pmt_references(void)
> > +{
> > +	if (get_feature) {
> > +		symbol_put(intel_pmt_get_regions_by_feature);
> > +		get_feature = NULL;
> > +	}
> > +	if (put_feature) {
> > +		symbol_put(intel_pmt_put_feature_group);
> > +		put_feature = NULL;
> >  	}
> >  }
> >  
> > +static enum {
> > +	AET_UNINITIALIZED,
> > +	AET_PRESENT,
> > +	AET_NOT_PRESENT
> > +} aet_state;
> > +
> >  bool intel_aet_pre_mount(void)
> >  {
> > -	return false; // Temporary stub
> > +	bool ret;
> > +
> > +	if (aet_state == AET_PRESENT)
> > +		return true;
> > +
> > +	if (aet_state == AET_NOT_PRESENT || !get_pmt_references())
> > +		return false;
> > +
> > +	ret = aet_get_events();
> > +
> > +	if (ret) {
> > +		aet_state = AET_PRESENT;
> > +	} else {
> > +		aet_state = AET_NOT_PRESENT;
> > +		put_pmt_references();
> > +	}
> > +
> > +	return ret;
> > +}
> 
> I think I am missing something here. This seems to build a new state
> machine on top of existing state tracking. 
> What if, instead, just do:

The state machine was built to cope with the spurious call to intel_aet_pre_mount()
in the case that user attempts to mount resctrl while it is already mounted.
I removed that issue with the refactor in the file system layer, but didn't
clean up here.

The only other part of this state machine was to avoid repeated calls to
enumerate telemetry events on platforms that don't support them. But given
the race to complete enumeration is lost on early mount, that seems to be
a bad idea too and can be dropped.

> 	aet_get_events() 
> 	{
> 
> 		for_each_event_group(peg) {
> 			if ((*peg)->pfg) /* This means "AET_PRESENT" ? */
> 				continue;
> 			...
> 		}
> 
> 	}
> 
> Similarly, get_feature and put_feature maintains state about
> the symbols.
Yes.

> > +
> > +static void aet_cleanup(void)
> > +{
> > +	struct event_group **peg;
> > +
> > +	if (aet_state == AET_PRESENT) {
> 
> I do not see why this check/state machine is needed, if enumeration was not
> done the loop should just do nothing because (*peg)->pfg will always be NULL. 
Yes.

> > +		for_each_event_group(peg) {
> > +			if ((*peg)->pfg) {
> > +				struct event_group *e = *peg;
> > +
> > +				for (int j = 0; j < e->num_events; j++)
> > +					resctrl_disable_mon_event(e->evts[j].id);
> 
> Can this be expected to clean up/reset all changes from enable_events()? For example,
> how about event_group::num_rmid and rdt_resource::resctrl_mon::num_rmid?

I don't clean these up. But I don't see that they would change from one mount to
the next.

> > +				put_feature((*peg)->pfg);
> > +				(*peg)->pfg = NULL;
> > +			}
> > +		}
> > +		put_pmt_references();
> 
> Similarly here, put_pmt_references() could just always be called and it will not
> do anything if there aren't references?
Yes.

> > +		aet_state = AET_UNINITIALIZED;
> > +	}
> >  }
> >  
> >  void intel_aet_mount_result(int ret)
> >  {
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> > +
> > +	if (ret) {
> > +		r->mon_capable = false;
> > +		aet_cleanup();
> > +	}
> >  }
> >  
> >  void intel_aet_unmount(void)
> >  {
> > +	aet_cleanup();
> >  }
> 
> I am expecting intel_aet_mount_result() and intel_aet_unmount() to look the same and that
> intel_aet_mount_result() thus becomes unnecessary.

Agreed. Per your comments on the previous patch in the series. File system can just call
the architecture unmount function in the case that the mount failed. Action for
architecture code is same for an aborted mount and for an unmount that follows a
successful mount.

> Just setting r->mon_capable to false does not seem enough though ... how about all those
> monitoring domains that were created? This flow looks unexpected to me, what am I missing?

I'm missing the code to clean up the domains. Will add to next version.

> Reinette
> 

-Tony
