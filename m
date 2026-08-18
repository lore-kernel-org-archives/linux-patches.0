Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063D8346ADB
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077214; cv=fail; b=BpKDdPQ7vVcN/luBqzAYpmTKKPpLWfRpPOuKl/SImCAT1G6Zu4beXyMhisuC2QkEyLcEn3pl++jKVWJ6b32jh5g2XH9tKWUUCzDfmSdzlY7DbVatLKVoSEdsZzRoIBkeZ5vRc0hS/Gy7dB50lJNWw3+QTNYJl5EtiFr8ocPo1hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077214; c=relaxed/simple;
	bh=7EC51X9N36D4BAJpbbaellefGkiwnlFe80BsXRP9HP4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kz0v/LYAJXh1lOmPRk3/BZCVJRdIDYoVGUseIb1ZwssNyt/EyCjXQXub2nk0QJgxTjVxgWMN0OVVnRCLUdIE5ZUu+ud6wmQVSRFlnHzX75+ojZ8DJ3gq4KhBLIuo/to3dZFnwhX9bPhUrJn+1ROniVjJvOE1AWdOUwsWEGlK0oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHKUj78c; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHKUj78c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787077212; x=1818613212;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7EC51X9N36D4BAJpbbaellefGkiwnlFe80BsXRP9HP4=;
  b=FHKUj78cBTn4sim/O+ELSykTwKxRXPvDqwQWYeRXhG5OCG3EDXkVxvVE
   lGGIWUu1HV0Ezd87GJt/DzybhITK/nhpJKJFzLoDl3DULcQ6Yc597CG2/
   C+VVJhrFT34F/QmDanT+q0j7t0bC4CgTDNbmt8doHjqa5xNjyUUtW4Qgs
   5EcqKdMVUN1YFXYQ6M0QaGyd5S0iD5p2d62Kn9pa+bgEHzGCgLGxgGWwB
   WLDnRQ/kjxoL4+rmRcqAT07rJs9KXKjBX75rZRGmiLq/Jp5Z5BbQTBD30
   gWBKy9JnuqL5WVxTx9Ta0PQHCGE4Zd//gPyBPFHLN0q7rz3CnX5PHohmw
   A==;
X-CSE-ConnectionGUID: wk0NirQlRQiqNKQjLnGIyw==
X-CSE-MsgGUID: QMWoWJloSPC+N4az4Z6Qrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="110364401"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="110364401"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 11:20:12 -0700
X-CSE-ConnectionGUID: oO2d0wmDTi+PybCSey/Cvw==
X-CSE-MsgGUID: NTqpE5vBTiezqiaCZ8IH6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="295226580"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 11:20:11 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 11:20:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 11:20:10 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 11:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1kTAgRipwyWxSeuNxysaPj9YPWHFCEKltJPcM5yztNh0pN7UkWiRcqKG9PZCJyzohPqZbKPjbaGuP9jR07CUGVvZE4MlB+nfHxhGbAVlqqflXzXoKGiekcfEGOHWU6/MdEpxOv2CH36XJYFeJigUE0k4gAYprZi9sODgRt9tNJ4QJW6Q45j+o9ujhkPL4Yw4sDv8e1ETBiqYlVCyFeahxIB5a8eS2Rhv7TqyaABP6HtHO6thWA8ypqZ+twLEAynzObaRBYC4vCyl27yTtZ1bTj+jgz+S4cWMfm82EwJ/7pnNjGFpzBgv656PXWfXooIWvuLU0oX6ItrltvEiqbOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWpSgGebCx0oObnWVV5UY2q7366B8e0BVH2z6K1ZL58=;
 b=nFdy2GBwM+OzJc2itvP871zTvEoiZbHIUaGAvUGlL2dFnHrQ0LYNJtrZQ6FGpNG/r+dnpMAWuRtMqQA0siqSmvIXJeNT/TxNToH59+OsG0WKxuxooAtoy6w5I1WL3X0k8uMKXR98ina4M6ADOi8hqIWVhYJ4DUc64BHtMpKRKnMRBGK1dt/enH8c9Qc4t6JgNRmAOMX79Xn8Ed4usxP+RgAY5cx1jfSjYTM0maTS7npfRzBBWPQoXOn4CwMpiSDEO7vbd7YmvCQNbfds/KdAmrUhmTqDNO3IhVKGbQOcmyeEq+PdUdpu1Pq1p9Lua5GoGFku+FMYmixxXagmfNZ/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS6PR11MB281697.namprd11.prod.outlook.com (2603:10b6:8:529::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 18:20:03 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 18:20:02 +0000
Date: Tue, 18 Aug 2026 11:20:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 13/17] fs/resctrl: Call architecture hooks for every
 mount/unmount
Message-ID: <aoSiUF_29hCuN_Rx@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-14-tony.luck@intel.com>
 <03257927-1015-4e0b-9d56-3e5d682d98aa@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03257927-1015-4e0b-9d56-3e5d682d98aa@intel.com>
X-ClientProxiedBy: SJ0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS6PR11MB281697:EE_
X-MS-Office365-Filtering-Correlation-Id: c409851d-2ee3-4196-db02-08defd555200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|4143699003|56012099006|11063799006|5023799004|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info: X4ltDJGZmW5HFdkRVnxWKb47vGViS83Ayjpg0ZQ7DifIkLagWc4xYfv/BWDW0rjHm723ZbdJavboG9XnTzBB9JGrXWAcA4usDvFJqEo0253o8rP/aJX/pgePA5QGjguzfvehjvqYtaflg66IAIOjGJj3PdVS+jQOr514xLiLZO4maX24CgxJd0zC4IqQyVIJy1J6gTx1a4ExUfAQGOOp9JWeYTBwAHqPY+DcXa/4uzHrA2+DRG4/shjo4hWsRbMwwcC+/dM7DhpFk4gg1cPBiV4lFopkajwlPwn6lztiKhcVfccwSVekB62lGkjDGq8SQGdQlQVhivyvtfjfAGLqrzeINVwFWS5xcuqbcvcGxMNGlAcR6RE7Gd41R/1tn2qRzALZqnRADI2u+uGbffTzeuK5Q7E6lF98uI4NYvpWQwA3sB+9CQ0ZxpKhOfzlq4qFjA8c4jwwdGJ+R+fI3hir6b0byms5m8kYE1jJ5yzcNI2ulREgulA2Nw9ZOqwVVbblJGRiqzAEr2mIw949y46yOWrpM4p/r967CBeVSTEzNaWP60BeKBiiNoV0RJPtBs+Ee1/Q8g2I00h1vrKanDKVwkEQi8YC8rmCf8LCw2X1DF7jC5uKEI34vA6TH1WQaQyN4CLgMa7/t27IxSqDTH6ZfbhG8d6rgeHnh6sNA+w9gAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(5023799004)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qId0MjoiGue3XQcF942xhIU4piCkHctXAdDIkxAEPpLWg5fTBZ3vGrljXqCH?=
 =?us-ascii?Q?Tqq6sMrAaqlr520go7bJI5TDgkJNwMgrHD31bg3hunaFomdblF0Gk8rUH/SY?=
 =?us-ascii?Q?UwCcWl/YlVJkjlRntFVdfxfSwx/VQQve3R6pr+4AHIT3NVAVcbBenUzzD8Ft?=
 =?us-ascii?Q?aPH18N53FKbOJkglVL7IzTzsfzjyJv35KWm5FqrJufgPlfJxSMpRgMI5+Q9g?=
 =?us-ascii?Q?vbuaqKezz7ukPslcahp9/QdHw0lWNJoZhRaCuW70bQ4yT17K14HODmYRo541?=
 =?us-ascii?Q?SUL2gVIC4FT2sqxy4SDRdhCLXJKXazDnRmM4YY+aEhES9S1v4RagWVWB522n?=
 =?us-ascii?Q?pNYvP3J+DX8Rmb2dnrH06ELlX/6gOhpDu4njqA080rfeDDwLVPJOWiK7BiF5?=
 =?us-ascii?Q?0ApXtRlSG5EgaiWJOJsAA3UKpbui6qbsVZ95549U3HLq01pwD2pbwHjFz1h1?=
 =?us-ascii?Q?h5sGGvIbctUlHQQjwOq7U/MT7RtezgqRU9+RH71eMz2eRk+KJmeoTPCiK1im?=
 =?us-ascii?Q?GnS3hlXkmCTZwjK9W6GqzEvnXcGZCSqkn6njyJpswflNRZg+q7f8eABKtqB0?=
 =?us-ascii?Q?ukmMXbhd+c/ZqJNYzyDlpE4ks0uhin5NqkENogfEsAjhnAmlRe6JPAnx3pEf?=
 =?us-ascii?Q?+Q+kErp775d/8iozZjhNQHRaXkBRoHCr3ZAGPRCQNxqAfaVnYhY0BIclZtK6?=
 =?us-ascii?Q?ALr0qm7VV4ZBohIYpKZHtTz7DaboccmTgGK5gukgYlYaUy0ughcbOuPlJ4uY?=
 =?us-ascii?Q?15/DmoqE5RdhGSdZu9cHUBZJ5H8NR2T6CgFlI3PwcybLkOHlJ/4LRafTKd6l?=
 =?us-ascii?Q?RzOGPqXEJ2nn7IJve8wlASOJ3G5Nh3mKmWnQJ3LgwrEprfh/zVcsaI8L8HLH?=
 =?us-ascii?Q?5BMwJWRcYXmQiqxyyXV+FCSS4FVmNu7zF0xdb5RkSPO5YfeTevmY3IOqcDcv?=
 =?us-ascii?Q?o/fy6vPBVyCT2k93RrxkKH1z+wq9uJQjkph16NrWly3g9yg1GoGjQA0WFH2f?=
 =?us-ascii?Q?XTRXcMNU9SnULQCJuuTcaPnA5ABuxaeUE/GyqVdho0Wu0x9XN+apHXgq5qg8?=
 =?us-ascii?Q?zf0NkEEqoXP7+2x5uJJeQAzmLiAZKbuojnAstXjglN+p3GNO23rM2pIQ2phu?=
 =?us-ascii?Q?ToMiumeAGDdqjBgVzXQClHW4y5I0PJ5xti8Ef6pS/QDk2E7pRMLdqVDYFqar?=
 =?us-ascii?Q?jaNLIz5qhXut9fVLLwgyYBCaAHZT44so8Bc2nskqEgtS0joq8Nl31/e/IodD?=
 =?us-ascii?Q?+OqNK6dPMEPa2/K1fLSQjOedq/Ij9LyiQthoZweEP48grUowMRmR//7R5c9b?=
 =?us-ascii?Q?KgyNYbRPi1/m6Ie2Xen7f4GQbsZ9EAn3hT1RZdPLgmn5CVIw/GDX+nsH5qBU?=
 =?us-ascii?Q?qpzafI/qBtm8kgvRam+F5Hw7HS3SmgDQYS5ImfhNy8BsFsrB75SY84flYzJZ?=
 =?us-ascii?Q?JRCuSnMfePuCpcKF5WaLQJXcHZqylRVk5+y7rT5F+lLp+FGNPbz1iu/IVbHx?=
 =?us-ascii?Q?kUzdMxg/GMVEuhHoadahiKM2E9shRqu+ZZKaiAcrjzpRYhryHeO9XsCFnJPj?=
 =?us-ascii?Q?iFPDdNXkT+1gdbDiPl/idwaWxaWlBludsjnShVfp+Td9hX+xZY/YRy/orQsM?=
 =?us-ascii?Q?kP9FOMoQhKczXbZm++nZ/AbI64tH9nFY0egStJnYqQI99qWfo+e0H98H+yrf?=
 =?us-ascii?Q?d9TUSOc4TgZJhSmOOXeAjIKZBFCkDHCh6gQ+vxpTIO4/prQQ7eSveZVDY1M1?=
 =?us-ascii?Q?KmZ1SAk2lg=3D=3D?=
X-Exchange-RoutingPolicyChecked: mkvEF4En38B5mzzOg7446s4IZ1pc2fAHCPVhruoBmId0QOKEef9Pwr9cmU4vTKbE+W6Tnm2ftkq2RYRf4dyqmnu85sqP/KNnCMDgN0y0BfqU4032G5cCZLxNourHJ7DpQNJcHDemdqELsfl27Yy0orOArCB4IUlgKbGY5NZbpV1XHBIZi6QB+D3/ngQoeoNqS4LSoCGvG0HK5aKQvP2UA0/V6XRVZx9iCguSrx7wyfMKXKT39s0Mx1/121S1OOkZR12hJI6iZN+h13W6hWht+/KC6PPbhvAGosm4+8okLjRv7z62QzU9SRYdejUowG1BLrvfNjyfritKgkzjexxeLA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c409851d-2ee3-4196-db02-08defd555200
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 18:20:02.5357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9g1+5JVkjp/r3OiQCZENw7ZFbHLjIczwOIhxuV/dGxl0QJydUD2uJ4hKqslKVXqid018lKrcMN9XV7DMR0R/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR11MB281697
X-OriginatorOrg: intel.com

On Mon, Aug 17, 2026 at 06:02:31PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/29/26 10:27 AM, Tony Luck wrote:
> >  static int rdt_get_tree(struct fs_context *fc)
> > @@ -3175,9 +3176,11 @@ static int rdt_get_tree(struct fs_context *fc)
> >  	struct kernfs_node *rdt_root_kn;
> >  	struct rdt_l3_mon_domain *dom;
> >  	struct rdt_resource *r;
> > +	bool cleanup = true;
> >  	int ret;
> >  
> > -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> > +	if (resctrl_arch_pre_mount() == -EBUSY)
> > +		return -EBUSY;
> >  
> This does not look right. Are you intending to add new meanings to EBUSY returned
> by resctrl so that user space now need to choose between "resctrl fs is already mounted"
> and "the underlying architecture is busy with something else"? Based on the implementation
> the architecture could now also return EBUSY when resctrl fs is mounted, but what prevents
> an architecture from returning EBUSY in some other scenario? This error code to user space
> does not seem like a responsibility that the architecture code needs to have.

I've been struggling with how to handle races between multiple mount/unmount
operations when the resctrl_arch_pre_mount() and resctrl_arch_unmount()
calls are not protected by any locks.

As you have seen, I have some (poorly documented) locking at the architecture
level that attempts to solve this by keeping its own idea of the mount status
of resctrl.

A call to resctrl_arch_pre_mount() when the filesystem is not mounted
will do AET enumeration, and if that succeeds create the domains. A nested
call does not need to do anything. But when I had that simply return, that
opened a race against an unmount request.

If the unmount wins the race to acquire rdtgroup_mutex, then the file
system is unmounted. At the end of the unmount the mutex is released and
resctrl_arch_unmount() called. This will execute in parallel with that mount
request, so various bad things may happen as the mount proceeds while AET
is being torn down.

My solution is to have architecture return status to let filessytem code
know that it did nothing because the file system was already mounted. I
think that filesystem code should just return at that point.

Is there a better way to code this? Or is the problem that I didn't describe
the race, and thus the need for architecture code to tell file system code
not to proceed with the mount?

> 
> Reinette

-Tony
