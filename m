Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFD63451CE
	for <patches@lists.linux.dev>; Wed, 13 May 2026 23:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778713481; cv=fail; b=h3JziZWg3bujn9uRf3g4b3Ysn4r5OPzHkRM8MKHvNnYQMmNN3sEsom/4C5A51VrrpLewnAsFffNzpe5CCAUFLXLOd/4JD6U+J2x0sggmrHnqKvI388LFbj6zzz09qje93pg5XTIiG/O2vEOlHBIGM5XOwRNmx3XVcrrYDhq8Gm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778713481; c=relaxed/simple;
	bh=Iwfh45zdGdOop881T4aO2QF0QzpjIJvmtFa1Ll07unE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QDIYYUPNJfUQFK/MJFRvroTjwhEAvIhiB6gf1VwZ5zYwZvVRkxH84+hFKwt9lv7QKQ5Vh4OMubhJvJtd94Hu/4RYE/ECpbirLJbScoGFvwsmhmVASfITcrXSZnUM986L+KWByRxph2/b3BWLxCgGj4WEXOLrAp/5u7S6E10BgCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jaxQAL/C; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaxQAL/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778713480; x=1810249480;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Iwfh45zdGdOop881T4aO2QF0QzpjIJvmtFa1Ll07unE=;
  b=jaxQAL/Czb3JrFGbaLifL1+WOI3lf5OYxXe5vFQQvA0ydaenoILOF/6f
   3jip/5enIO4hLfnypYn2/69eHHI9zeJ+qe8EV7lpeb0vIgCF2WUiyP14K
   gFvIFR9PMqkyzGxog4/3N+IyFnxJ/vg7HUXHuFif/qsEjXhnTqz0syxKn
   MUH304gtwcolxxwJF9iNiPhMS8iC/beCCtrvGac0gC/287oQiSCejiN5E
   U4C5+Gfxx/EmEmvT68LKof4Ovn2B6zUgCP985ayKqzHvy1KhKUNFAWGfD
   u5P3iUTVGlZQwph+GCeZqM/pGVLbEdrHzanKxMd9sM73SzX38punWcnmT
   g==;
X-CSE-ConnectionGUID: H5jfUp4JTTeYXD8hEjzS1g==
X-CSE-MsgGUID: UBFnRMPAT/uw9sqfbvuU9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="79547890"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="79547890"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 16:04:40 -0700
X-CSE-ConnectionGUID: vubtVupLSgqpsZO13V6hCw==
X-CSE-MsgGUID: ZChH7Ut9StqePvrBqh2v1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="242552708"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 16:04:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 16:04:39 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 16:04:39 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.68) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 16:04:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+HGdXl7Ls3OQI6Pjst/wwik3IIVB44hnzNvdOvUZ7LeCWeMLgdhGDKbb+btmiLsWVB3CxLfmKl/yHVZ5viFlcrd6YYe9eFGVs8BlxQPW69B3QYsBK1fHQOOG9SdX1zE/+SBotOGUqAK5X6PHsnKHDTB8LTPCHvvVawNsA1QGgp0N90GzClKiuoJUB114tg/Zck9pFzPPzyD7zefkQ4eqT1KqfDWjnTCbATotE+tRLkC7JDW+bmcVXFBlhltuW3mpGsRVYdo5IeQWUkzmN5Wb+gYxSnBftuxBq0lrXQ+9Qoyc5mHMuyZLI3Tpq2yGVZG12PJAMp+C8HGgmb9J1LKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WwHp5SAaub1BCtIGc0i281tF8dLmH/G7kLMLcK6sCnw=;
 b=TDDTAypbCuIKIwDQszH/hjld5hXFvgQBkjiGCr1+xh84DGxfg0yQIaSGkSarqrIsidIaieYHcGU0Rc7cphOQbNkSfbZ4qQKXVYjxPh/o6J4WF9XVZfFbTZ7gUGYYKwJVsNLc504L8Emwy17AcS0ttlfx9YbGTJ7yZliqrUQ5oUoBFMiQdUBA92GvNcSGDtTQSs/4Vw5waKaOzD836NTAvTjj/Ir9BtyR2uVb9Qjet+15m6ouzzYfyIcw38A85voyJs5Dd8oGhoO2gQRR9CpB/vH8JT/threCCUDySCnOqAv+RkW/RyCgx9mownmLFT/R428OFpn+a6qRrUStW6Jcnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL4PR11MB8798.namprd11.prod.outlook.com (2603:10b6:208:5a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Wed, 13 May
 2026 23:04:29 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 23:04:29 +0000
Date: Wed, 13 May 2026 16:04:27 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: "Chen, Yu C" <yu.c.chen@intel.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, James Morse <james.morse@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, Babu Moger <babu.moger@amd.com>, Peter Newman
	<peternewman@google.com>, Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
Message-ID: <agUDe3PcBy2mULyw@agluck-desk3>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
 <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
 <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
 <8ee967df-329d-441d-9635-47f48b5e7b8f@intel.com>
 <agTWVa1NYNhA5wUp@agluck-desk3>
 <6ef756c6-7c21-47a4-8173-88e1989b7d1f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6ef756c6-7c21-47a4-8173-88e1989b7d1f@intel.com>
X-ClientProxiedBy: BY5PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:180::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BL4PR11MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 776cd9b4-6f45-474b-72b4-08deb143fc79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|11063799003|4143699003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 6570V1+EXCMODfcUVvDBX8PMWB4OtYQQOUuoiV17DfRIeJFn1YqhD1AkIwiSCN20cUtkA0Rp15VlT9soz/xXKXfbmNb9UNg3YCt82cKIGOBykZN5d5/OdsK/pE+19z9+mgxVv5yMtLaUQk5gefI/y50QBhGQlnU/3bHmOe5SCN6B75ySMwr2VxmO6KyDWXIJrm+cslao/yLkf/6CH72ZsK04x0g4DAzMg2JsRB66lCpExduY3vTmi9lVzwxrIGfk8ZRErM75o57pVzvDKIqUbBztpgwd56h36O5N9nVOnnCLN6FXYnUszkjB1i8jP/UetIXQRTDRIRMonlWde0DZcx8aff/GR3D0gfggX+Kita+yGQaXhqkgg6bK4EcKO0S/jDIbH1pwFOwG8V6dabamM8d34e9zilUalHuUcbhXRZIWSBAN0zz1d8WmYYDggIrZw4+sPcCW7OGoT06WGDywtrwUbrGYIeVmgzqFuTcp9ItnAoDNvq4GO++oubSG5ClAW6yHYxWNQpIMb2ICzOE6OIiO54Bg8joUHrPrwCtby7QF/uMEh257Cp5OAQm0gDpQEQT7L0Bvw9gg0MKVhtU5cu3g4Pn10t8K6OpbqS4oObMShUfjJkuMJOWdtC8x1KgTk+KQnQZLhp095PrZVoca1Mq7o/H1nexYKBcS7QEA1fKL4jJfRU+csp23TV2QRQwC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(11063799003)(4143699003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bR2J39wGm9cPhbV+XEwS/Ny0QsXw9mGc7aaxcathpKbhC3XnRxVqWbR5Umxl?=
 =?us-ascii?Q?eH4rGIM6HisdL0GJoXcOBVV4Y+XSGXJMqa3/l3AS+EYQYR9XGqmt+GiMgVxw?=
 =?us-ascii?Q?JO3fTloTXPnTPOsk9YhlZ2sIX8aQFBkjwfBNLUGGToDvZMJC0IKshllFM1nA?=
 =?us-ascii?Q?5LXvCeFKt8C59BxOBFwS9etekeoE1CNRDGxKLVrkqAAngjaapyovYpjSjYGX?=
 =?us-ascii?Q?tjr1j1vh3x5fWFm/HZTTYaJ9vA0bl+BTdcgeyjjOGAfc05RrUJNyXuf9NZfK?=
 =?us-ascii?Q?28pLapU1ue3FY5sZilMj9QJsKCl0yEw85+F5wCjTLWLCIo7Ne+4yL0TEG/zb?=
 =?us-ascii?Q?FpzgMnXEtRO0oIhbVIxhWbweTKYAQzD9Kt2XDV5baHMmqWaDAlxX+jCDD2vM?=
 =?us-ascii?Q?od2gxG5vloDR2NxCodoaJ3HQWhzMZoHftsyXRk/FiaOPJDQXNjKO2kpR5bXB?=
 =?us-ascii?Q?n3lxeWArqLSCwG6SB+P5vppMcdqQy+9PPSfbn6QN9V7bT8VB7pOAMNyCpwmW?=
 =?us-ascii?Q?WiD3HMd7n77G5bfMoI4jPXZNLJY9wpR/DFxcvMnmo0zMC+HoWxb7WJwOOtZM?=
 =?us-ascii?Q?t25pWjPNvzHbwYrkMzSnGJh9t9XYSVmMhRKFkuqhE871398kfCW00btNMDl1?=
 =?us-ascii?Q?55DeNKAti49yK0pwSCfS75PTFlmakM6hKCQ/7RiUVVgxkY1uTVVFrfWhuwnJ?=
 =?us-ascii?Q?DAtUgEhIrVn7pnj8H5yHsHZ+HcDC8Pde1iZqvpuw/SsCVPH/Nc1a4ic2+C/3?=
 =?us-ascii?Q?Y5/VSOLhEvHeyMGyKZtLY+TJKAq5rI4o8ZPiTG/HMv9ZnFWb5oZsl2gev+FN?=
 =?us-ascii?Q?Ob8Ha5cNf9SeKBOGJQLowNPR5Ubqs0naOjMFj3RC6XI74IUO7PWW9/6R4/Yx?=
 =?us-ascii?Q?rqDknDUhakY5fO7aSMxuhttZS810sOt8pv72mkrP4mkZ5Mqf/bKGHWNMYHS/?=
 =?us-ascii?Q?D+D/nPZre7r1r03mIeZH6/JTw07kFyLgbYUTK3bwf3zLsF1yIiZuQ4tCjPAZ?=
 =?us-ascii?Q?VHQHqefuRnKERA+3ZNp7zdgtn31qxPefpf7rsGOU2AA+fi2NV6cyTycRWgiz?=
 =?us-ascii?Q?vNmxoWsvcYxo9dTPZJDANwuHsPNVs+K5tFMbMV170pKinuyu174QU0D1eWzl?=
 =?us-ascii?Q?l3RCNsladXXwliYXCDSy2SOGOh+m719+5ro/6S2GuMIGohz8RzbXK/dy9/fe?=
 =?us-ascii?Q?Ym5wCjlxXWIZDqlQ9RwqgBKp0nZ7LK1okNO3zqRQ5TlIkHHx3xDrY8Bjtedq?=
 =?us-ascii?Q?dDdo/yFrZWLkNSlddBsgWCI81bTT9p5mDDhqlV2kKpg0QXZvdS3UI6sLIpMQ?=
 =?us-ascii?Q?H11NIqJtzomqCm/yV+4b/Y7e0ig3LqdTq2jAb3K0WcCYunfsXt19s7XuOIAp?=
 =?us-ascii?Q?BFPnD/1C30YiqYUYlJK7YYgYG5S1J8XVlqLRbc4v0THoCppGMALf8D0WtR5J?=
 =?us-ascii?Q?qZJann3pm//lmxT5ggFrNw6f6hsXgpSxD+2Aqv9JXSEoTVkuQecxSeuj60xm?=
 =?us-ascii?Q?oSEi77dPDjq++6Wa5X2Jp3/NTFb5I9r36twjcbF3y9iMAD+HO1V1ZGXec7WU?=
 =?us-ascii?Q?SNUHaHF3kF8bfwm4BnTPID+eWAoNryKCCF/6eH8VzBSROl+EY3VmLvp3BvVC?=
 =?us-ascii?Q?0pxL045cTTrkB8dJzYu5nCIWMVVm4h/STvokYJP6cmsTaRdJZZqgE4DStpgO?=
 =?us-ascii?Q?EH60miqNm7iLCCoULA6U6Mbdzr3sUsc0u9NfqdXrP6ONV89Djh0aQU7tFoCy?=
 =?us-ascii?Q?qrWKYUEmrg=3D=3D?=
X-Exchange-RoutingPolicyChecked: O7FE8cH02zLJebqtWGXbFZ/f9tJXKctSe/Uni861oA8sy0fJKuzJOH0Fh4wDZpFGFg28XQTCR0ESXnqkE4ne7MvoNU9KMXNCPgK7d+CPigZQmnaM409hRF3af1oNULHTB2XWJq3opD+RXa6cXnaXiUkNdkHcYNJi4Ed2xrnXymTsHmMYyxnT+qk+OAGkrUrgtMyZruo0l9gwh494qUTQDihQMjKaeo1tWQ2Kv1T6Lw2pOXwwblQno92raj5+VtW1ud4UZzgGqr8Lco2fF3HnZ9YxldOqFwUVSav+W9BbaWk8FTJakWzC2vtg9sZpAYzkWPZ/+dXJ6XnaWfMx0Vnv7w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 776cd9b4-6f45-474b-72b4-08deb143fc79
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 23:04:29.1580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vbF+HW9OGjXVzg4dyicmIABYz1g1AE+QisKoMlQO3ZsD4cVqtjsfm2oy2Zt0bDwJ4nChX0IsCFt0AtUUID0EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8798
X-OriginatorOrg: intel.com

On Wed, May 13, 2026 at 03:19:40PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/13/26 12:51 PM, Luck, Tony wrote:
> ...
> > Are we out of the woods yet? Applying these suggestions I now have:
> > 
> > 	/* Ensure root kn remains accessible after mutex is unlocked */
> > 	kernfs_get(rdtgroup_default.kn);
> > 
> > 	/*
> > 	 * Make backup of rdtgroup_default.kn just in case one of the
> > 	 * following flows (that sets rdtgroup_default.kn to NULL) run after
> > 	 * the mutex is unlocked:
> > 	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> > 	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->
> > 	 *	resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> > 	 * These flows would not actually result in rdtgroup_default.kn
> > 	 * being removed thanks to the additional reference.
> > 	 */
> > 	rdt_root_kn = rdtgroup_default.kn;
> > 
> > 	rdt_last_cmd_clear();
> > 	mutex_unlock(&rdtgroup_mutex);
> > 	cpus_read_unlock();
> > 
> > 	ret = kernfs_get_tree(fc);
> > 	/*
> > 	 * resctrl can only be mounted once, new superblock only expected
> > 	 * to be created once.
> > 	 */
> > 	if (!ctx->kfc.new_sb_created)
> > 		resctrl_unmount();
> > 
> > resctrl_unmount() clears resctrl_mounted, so as soon locks are released
> > a new mount attempt (maybe started a while ago, but blocked waiting for
> > the mutex) can begin. I just want to confirm that won't stomp on
> > anything left over from this failed mount that was waiting for this
> > kernfs_put() to happen.  I think it is OK, because the new mount is
> > going to allocate all new structures. But there's been enough layers
> > to this onion that I'd like to confirm.
> > 
> > 	kernfs_put(rdt_root_kn);
> > 	return ret;
> 
> I agree with your analysis. I also think it highlights a sharp corner
> that may benefit from a comment. The rdt_root_kn is intentionally a local
> variable and the comments above explain that it is needed because of some
> flows that may set rdtgroup_default.kn to NULL. Based on the existing comments
> a reader may wonder why this cannot be optimized by using kernfs_root_to_node(rdt_root)
> instead of a local variable and that would be a problem in the scenario you
> describe.
> 
> Could comment changes below help to clarify the motivation for the reference
> and provide enough information to support future changes?
> 
> 	/*
> 	 * Ensure root kn remains accessible after mutex is unlocked so that
> 	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
> 	 * failure path after creating a superblock but before taking reference
> 	 * on root kn.
> 	 */
> 	kernfs_get(rdtgroup_default.kn);
> 
>  	/*
>  	 * Make backup of the current root kn being created to be used in kernfs_put().
> 	 * The additional reference taken above will prevent the kn from being freed
> 	 * before kernfs_kill_sb() can run but rdtgroup_default.kn may be set to NULL
> 	 * via rdtgroup_destroy_root() and its backing root (rdt_root) could be overwritten
> 	 * before kernfs_put() can run.
>  	 */
>  	rdt_root_kn = rdtgroup_default.kn;
> 	...

Looks good. Replaced previous comments with these new ones. Thanks.
> 
> Reinette
> 
-Tony
