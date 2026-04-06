Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAEF32695F
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 18:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775500536; cv=fail; b=L2y50LevtPLxvVumimUpkwg4V9qnAJeJMp5FErJuyrxlE7h8zYuEmKazfng550eSH0xcQZNJixlMD0Uqd+1M0Kgrv5Q9pMODMjbAxuin0sFyBmZBhe82sIRrg7OCtu4khkopPY2MDMCj+1ky2jFtDlMCi65kvwaIJAk3zOOgXtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775500536; c=relaxed/simple;
	bh=OH5Fotnv+IIExamWUlxlXmkJD2hGe2xZ09h6JdfFIyY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SEN3pm0XyKtCH/V/yw38Nvbttwswk2TtxqqbAvgitHfLZ7DuB4UVBuQb9yi08uJcNLhHqHKeROlfAAWTJuKJTUeEWVTqFfNkKs93PfoVDtTwzoMzwAIeR/NFf1KjJgCAuqguhXOFZz8TtjGd7JYE7OBXt3wPZaRGmVbLChZ19jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ItICafF2; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ItICafF2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775500536; x=1807036536;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OH5Fotnv+IIExamWUlxlXmkJD2hGe2xZ09h6JdfFIyY=;
  b=ItICafF26nTnrCOMr20pOlGsAoQ5pRZccHbXqvmUpMGE+3XfDBNNNoPp
   rgsOr/m12Z+XV4+EozWDuWj6MIfdJdnk7Vn4UyUk0GO7sZB3Du57O8CZD
   9zq7N19d5TdC0K9tFhdeGgQ8R+DUCqzeBcpBwNGAuz6Pq62oB+LYKCT9w
   JxFf5/pePhACjKoDVNi0rvktn3qWbm6rmF9nauPoIDw3YOyHyCQfflwsP
   fARDxKpr6yl3OddTnBtygOhWpX1xH93ItiTRARODlawgGxyHN4iZgybi/
   lRatCmDAlgGf5Dih8OB/ECrDt/kaGUuM78pu3l/jko0OXylrU5J85QzEG
   g==;
X-CSE-ConnectionGUID: 9kFUo93nTl6tHO524/+PEQ==
X-CSE-MsgGUID: ycj5NmCkRaeWj1ENRVDBHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="80342176"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="80342176"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 11:35:35 -0700
X-CSE-ConnectionGUID: 2XtLhNf0T5ed8/rN8rumsw==
X-CSE-MsgGUID: K19hN1QUSIOxrwOVmNPs1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="229603409"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 11:35:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 11:35:34 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 11:35:34 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.0) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 11:35:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jNwo9RyI4ccauqdGta3JS+QBhJeJ7lRTkTCb8HceoheBex4qwKSS+IyXyyj3THkehCNZOIlN4iKB/SlniJISHdLAGpa1diKkjN5+xUJLqz2lC+fzqrg89Ni/fRFoUbdb/lK1BK1wdRxzEL7nuut2Z09DxMgE4fmlyRCgY7DZsLtr1ZtVTd5uKNiDg43ZQgiwxjiuepVq40cel2tDg4mpOIKoadSyFJIZueHg/+heDVUvWEb7XFki8Ae9nwjZnJO9iiBaEQdUFM9WQOGf5liJwhTYH4V99gF4xrtL3esKUYqszD5Vuv5HOlfZuehxRfCTCPcIj9XOGwddHrWZB5WYAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWChYokDRMZPfpLjvckaVRv6UlwqXYPtnWqwljtfeUk=;
 b=g2SSlhptaPgQ38SDV4octVw6DXePm/voj4Ut0pojpRFk9XyffWMFwEb4FnFfeGO585poQBWK5nIAB+j/Ik4QLR2sZFqr93E1eD5Dm4RLTs/38561APuwW50OUtFOlJMFnPKvAf6Q58vTxQJC69yilVydMgg3vTdlzJLfD9QfZxBII4MI5E/PRUNfCyYQQBJ7Autto1fkxCXF5jOmaGSjwPHFXn12F9RtlVJJiQK9STC1JZEC62oilNkNHsdvbROFPP6Hig43Yyhz/l6aXphJVyfA+znV62H9PKQjKtbNuK8A1T78RNXHyjaWmd/St9piE6Al1E0grmfdtbvQfA/W/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Mon, 6 Apr
 2026 18:35:23 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Mon, 6 Apr 2026
 18:35:23 +0000
Date: Mon, 6 Apr 2026 11:35:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 3/7] fs/resctrl: Add interface to disable a monitor
 event
Message-ID: <adP86aXVJONQCFc3@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-4-tony.luck@intel.com>
 <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
X-ClientProxiedBy: SJ0PR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:a03:333::23) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 38ad97af-6df6-46cf-9d2f-08de940b43be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: Li3u2fAIdzr3GFB9HNdNum4l51oqeTHSLiXpYgrY5FdUt22yOBtm4CGRskczQqwI0nFBTn7wPDLBb19qWm7nlFymRsBAJz+q1JN67OcyQdtDiTP6NkuEbnDjSwAjC/dXSsfWQhnGR4OuDlCa74/d1OnRvd41hF7Ee9we6KY9/+52QKH5WcocMm+tzBUrlFFqzvUE80rwwBtyKJROottNxBChD/Z3Q5FPrMRlEMLR+axTqSBwX6vsgp3mGHjACBwFKWPYlkMiScRt/72Jq5Mpf1cWDIkQnCBJ2v+FyR/7ARX9ftAEv7ViA3eFQremw4F4G5cti3L3LawLSTnlqIgSWYFLaMH9lGnWPGc1xdRR1VWbMDeoVY4j/vcwBp1DY97VVCfFMzsu0qcoq9uNljNmQYzEl0ETcS9oJwrkhpd139ZxqozWcCtUYIHtr6m/7q+i6xEI9wRW09LvtWntG09gkIxApTq7Ur/Hvvsi529EVayVItd6P2gYVn7/w9Ji24UoEWHukcC6uPX9B38a2rHF6I9/DV6x7WLJ3lilaCyPJh0vpzKyGZ3ncWDAmacPW5D1g6TgJDlimeBP69dzDCmO3f8DwtLH1Qbdv6R/7erGnAwrIy/8R8QylhWy3TY97rkppaLwM+5OBWjJZtiLY41sSSRne5mCPF+lbFrFkGLlx+k+CmvqpDERSn8CT+9b2InCYXXi89gtapLkgmle933g5aGQ9o577YyxulOmKIg7oeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3069zqKjVII6BjWis7uHzEp+KWER5/1KhDumYGD2/YXoshJzYWR09KrJdiTD?=
 =?us-ascii?Q?mto0sOnarDqiatM05nFxo9++vaChsR7EBpWBUAND1cy/vF4s0o95dxbPTYbp?=
 =?us-ascii?Q?csqQ5JvA3SH8vwtgcCdjFI2JGdNkuAdfVqlkUJUqiFBqG78OXgwFqDTJBw/o?=
 =?us-ascii?Q?CKBW3sQKAu2V85wi23viQMUJm/FfxxA7v5A3ji88TuGZ/MSnC4DTZyWXV3Vf?=
 =?us-ascii?Q?6Kv9H6B8/NDMbqO3kAXzFyyS4+DFHMut0Ctf9ursLMjPcFzi0B86c2DhoX5f?=
 =?us-ascii?Q?vJNzDxPbToOLwOilG2Oe5zCz3dr4HRVmHoPI265W3m/bP51tP5mq67sQ2jAw?=
 =?us-ascii?Q?c1qkEr3IczSGuydXu1GMhNHKE0N3i9fbVYugfl8WyBLqFd6cPcwAykHA4YEV?=
 =?us-ascii?Q?iq9N4rO5ro8o8mKR5BHE1vNp3yqXXmddDr5p/XYN2aFLbM/I6JChmQ78fyrm?=
 =?us-ascii?Q?Wsnp7/uq5pfwi+qBgRPJ1vfHMIzSDgpluuVwGaACYUTHFB52LaxpJxJE/BHP?=
 =?us-ascii?Q?maZlFnyTq8UmM6ji4YzIrZ130lHsIiKudDx2gVlC5/DOXF9y8D8g6FbyGxxq?=
 =?us-ascii?Q?D6UmUf2zrKEnTneGHEushpVeJx7w2+O1KBv84pj6+U0YzicF1KFJ+KViXkn1?=
 =?us-ascii?Q?lykpAeyn04lBupjVyUl9IECdBKouvmhxfpnHiEAZGORQGe5NKJC5QrPY3gPt?=
 =?us-ascii?Q?wvMPgJL8G1Pz84py2tTLOzPm4NxliF0LrUsfh4EKL6wS3ve7AewOe+cN25ZN?=
 =?us-ascii?Q?n5CjsmlSbrpvdzn2XLGSAh2AG3f12PrD7FiW3oLA8vY+bC9G7K+5eqSV5aG1?=
 =?us-ascii?Q?lzFFpWNjf20SxPjfJf8iOLReft8RZhWpPKxlyCT6p+SUA8i4qihYCiCPT+aG?=
 =?us-ascii?Q?6q4IJgPPcVxDHTgUA/J4K5NotHPIQmjgp7X2YPvbvZgpp2EAVVgRAZ0kF1jk?=
 =?us-ascii?Q?d/PnvUIyQvEvtCfHzYLVZe+KBNoB5jLkLz2b1eW457zWJASR/+6isNKCTTCR?=
 =?us-ascii?Q?HpReXvoL09OW2wOoWX+L644+SSSKG4LeZQ/Ts8yqywByECgY38uT4mNd0Oil?=
 =?us-ascii?Q?j4wYDI+VT+q5SrHVBk24Y9lToMO9FnJvueXx23A+Bu105oXHMcvMofWOepBK?=
 =?us-ascii?Q?rbsx8Z8F4T0H5U/horFJDfeA3O4Of5DinXsQup7Xw2jA9WYNeK5xoyieStFf?=
 =?us-ascii?Q?Z7dgcrvCqdkwxNvVj780BvK/n7xTYH8QVQ+mpI2l/oD/q/o9w85qcd27mLj0?=
 =?us-ascii?Q?6AP/rpl7JiL4EQceJFWzEo4mv4LlPdiFxrMy0fb/5wOsZ4vD9R4sm6Cy3EVx?=
 =?us-ascii?Q?QBYgkuHub4r6Td3DNmjpYv4vL6nc5Y12T/awnK5vNMj5xBt6FwuX37gW8iKK?=
 =?us-ascii?Q?pban/6qHY+fJTSPlgxz8tHVXPq3oLzrBa1nsOuFcmbjweNva7XPTYeySMOTF?=
 =?us-ascii?Q?bfKWc+T5Bn4Qu+2+6bX/fdOxGr5xbc4hpQE32ESkjM+tGn2e5oScu2Hw+91G?=
 =?us-ascii?Q?bVDXDDmLFV1SwzEm3wXosN+D0YxUNiKk9///8fQGLqsndp6uHc6I3flGIViN?=
 =?us-ascii?Q?JFYbzRn2gptu35gSq+5fRV1svNy3yLXu0ezbswf97swwqiAvaEckmxymmgCa?=
 =?us-ascii?Q?VPH73npGyTtDizDAoOu8tupKRTFgyUXc2kJIsSqbdMGt/xkMnVPvXECyysQv?=
 =?us-ascii?Q?NejxuZTd4pZFQNsMsiWbmsAtpuic5D13Xfft4gM0aCOBoICR/29/dafHs3er?=
 =?us-ascii?Q?uH9XqxlS2Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: FCaYok3AqwKHRXp9tUkOJu3mZi6r0ghrjxEYyvQO/QA/4rx6G4gX4V563PJ+i6gh5MRc8yYzUvmWrls8pN9B4BoB/eIqr6u+bFCUXkYwIYb5u/WnLWSab1D3O2egsGZhhMDc7W2j/7FnHwOOF2QS5Zj0M8SC5xCRHig8D2J82jPnpccmTl4RrdwQMQAl2Qi8GS/htF5VPhOZBjuSiVCZqt8fweGZT+1ZBA7uRjnze2bj1+pEdosSUgzsXmW9/J6nMo+FE8x991r0kvKnq9x2WvgHqNtdOJwrNcP4+uaXcCC1HJMzgt2kqUGKyg5FnWcItnAljPvth4dUXk4ah3hFjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ad97af-6df6-46cf-9d2f-08de940b43be
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 18:35:23.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: am0jVwbP01+a2ny50sX+VK/OCGa7jWLLkY5QIvVA0erVpzXr6u3Q/7gTTKpCbtmIsHZ6RXXdWAjyolA26TSBfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Apr 03, 2026 at 05:03:28PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 3/30/26 2:43 PM, Tony Luck wrote:
> > Architecture code can ask file system code to enable events. But there
> > is no way to clean up and disable events.
> 
> Missing why it is required to disable events.

Will add rationale.

> > 
> > Add resctrl_disable_mon_event().
> 
> (can be seen from patch)

Will drop this part of comment.

> > Adding/removing events is only
> > possible when the file system is not mounted. Add a WARN_ON() to
> 
> While this is accurate that it should not be possible to enable/disable
> events while resctrl is mounted, this is *not* the *only* time when it
> should not be possible. Here it is unfortunately not straight forward
> since only some events require per-domain state which requires the event
> to be enabled before any domain comes online, potentially very early in
> initialization.
> 
> To me the addition of this warning adds false security.
> 
> Also, consider that resctrl_mounted is protected by rdtgroup_mutex and
> this addition gives architecture code free access without any protection.

This is a problem.

> To do this right resctrl may need to add more state to an event but how
> that may look is unclear since an architecture may require per-domain
> architectural state for an event while resctrl fs needs none.

The extra state for an event could be a pair of pointers to file system functions
to be used by resctrl_{en,disable}_mon_event() to allocate/clean up any state needed
by file system code for each event.

But this might lead to a rabbit hole of adding complexity. May someday
be useful if we ever make resctrl a loadable module.

>                                                               At this
> time these scenarios may just fall into the "architecture must do the
> right thing" category since it has best information on how state is
> managed for the events as they are enabled/disabled.

Are you suggesting to just drop the check for resctrl_mounted (as both
a locking issue, and an incomplete solution)?

> Reinette

-Tony
