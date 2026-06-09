Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A498349CC9
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781025713; cv=fail; b=j6NkGMbnnlaUTPfy1vAHROMsZA4XPwy/A5WBLepByEefxgZlI/NfLHaGCOJ+ekbXvoGM6mAApeg6e1sm2hU+w7VsTZMFMLLJ3/IpD6MrViM7y4yXiEyxPojx+LVl63TN2PMsLOX2aseoE58srl07ld1OlgSYajVmdR+hY2CYXg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781025713; c=relaxed/simple;
	bh=LKWwSQKrUIXXT6mJqAJo13M8oOhc5cP6O9JUIb6/Lcg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t3KxaLTTH1/mJYJX5E/EQ93lWdaFysfDjI3FoAEQdhFMIymxWULdNann+4gegBjM8OyYp2eN3WhY5pBSc9u22mE1/ovKOwTtp49LTcayUp4aPq6PoK/AZTlH5Yt251drMEdtqiU41iUnrSKhIf5f3nD4vnpoHYN04pTJbLfqsMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNMlFNdF; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNMlFNdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781025712; x=1812561712;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LKWwSQKrUIXXT6mJqAJo13M8oOhc5cP6O9JUIb6/Lcg=;
  b=fNMlFNdF1U6S7QAQlv2Gx8rixnpQE9q8ZzmMAS3vScOniXD7bzSOKJCk
   Xp9quwJGKGaMHOy3K8/illnXZ4F1nlgay6QDAHvDdCGVCsyZWzEgCzLYt
   /QJ/jn4vCxlxDZZTgLQ1K1QO+oSF4U/6IlHt8/iKd93LCDfaH/SL/lZ81
   8F02dEk0KuKuIBFjbnf1Mzk3ue+5bk0L/M1w2QOONtnKkT1y43IokZYeM
   Ok7NHoQA+GwO9VIgX7lN99KzbjfvZBkRCkxkXDam7a6dAVfgSgmQfC85o
   3rKsC3zFp2FDcvINax4uXCusoUxJStd+aYG3g7EIdVApAhtYnQlZfRKMf
   w==;
X-CSE-ConnectionGUID: xy2pa2wgQrqgKKLmxLnpUw==
X-CSE-MsgGUID: OlNYBf6CQk2XRF2ERqWEaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="92472819"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="92472819"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 10:21:52 -0700
X-CSE-ConnectionGUID: kazpXWUqTtSVpIgN3p4gOA==
X-CSE-MsgGUID: UIQ7/WqOThuHZYLjCRciVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="269599339"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 10:21:52 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 10:21:51 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 10:21:51 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.54) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 10:21:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mA7DXoaZxaA4V4ZbIjnYyhE2MuecM7FIJxmGROs1XI3L3hu9Ao2/jqNNYPvpRzMQt0N/qSRUg2nWoH0cvlzSa5RdNO74I7ltDZ2iE84qq8p+AQccq1uMArX6/JWRV6QrqdKzt9PXGPio3cHrMU2p3GdNV5InX4QwJ2WmeWkNbOr0E3F440ArfsslLe2/aqXDtSWnes8gaI8fPCk0FBJm05NhQHLvmQwTYOZhBzWxGtsXfsm6SESQUEg6np+HNQCsX1qLA+uQSgKNw1oaQwBiiQQQx5oVYSX3J9lyPikqOIgJQXFg/AANF9/pEpudTheq2KQW/bth0IUuCHECRAs6pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMgs9kHKXrpC4Mu9dMRZsi/9sBGFrznVtDrvXktGGMc=;
 b=ZjRQDFrkjGD5bsTIvS1i8lA2YSrC2NfY/EQmBEVTcM1gC4S6kg2ZuAH/bmeeDQ3KIM0eXF5zBCL0pYX5ztF8Bau7PgeQmT0TISgih4HGVibrCYge67vj41mUh31lxu9fO8RR8KB5JPuyY6zsUCFTpfPZH9D8v5gtDGXfdCT71snPeAyMMQPZGbBtNd0UCtJxTp/vO4yLCLMUqZPv0OFWWY030V7OCd6ep7ZwWAh0zaWmCNftCxwkELMm5fPvzB84opMCnoEN0gnS+xP2nUZ9iX0IBKiOZDxMtwKvJywbk+lBtRV7vsFTljFiWj4nDo3BTdjw9tGWAywo0tE0o9XrqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL3PR11MB6482.namprd11.prod.outlook.com (2603:10b6:208:3bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 17:21:48 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Tue, 9 Jun 2026
 17:21:48 +0000
Date: Tue, 9 Jun 2026 10:21:46 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
Message-ID: <aihLqhlxS7l1y3jO@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
 <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
X-ClientProxiedBy: SJ2PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:a03:505::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BL3PR11MB6482:EE_
X-MS-Office365-Filtering-Correlation-Id: fca0f66b-0acc-4d76-9ca5-08dec64b9652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|3023799007|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: cWK24aTczF0au31Ztmo4o3S0hVWjSdiwrF7t7ujxGRNadg2WIaRlJBb/TYum75BjWrzilZei6x+xhGspoC83c7ncaZFn2hVTpAyPMuxiaZDslPVUzN1vVjctluFpOlDuLbFBNjOPzRATkGHQQuBP8vfxIWkaId/fzzYne1BcgyGnEWz3t9qr3a6dHGSmx0lr/XtVAP48AKQ6JuglVZ7lcm5r28G4OaMuoyHO+GHP5ZcKOqXRFmQ1c1hAqWieO9SgvNa5aWMmeC2KopcnqY5BQSA5CU6H3nTTplTMvfuyTFyUvePfiGNjbNgFgATxyX8x8ONSQ4TDO7rV3Ygud2zuTj6mBdBHYnyYsK5oKHngxeUojnY32AJ+/H2dHFXS0XR8Lp08fZzLvgQT9ZnzCHRCWE7h799yv/o0Dad4AQCE0Jq+6vou6wObtSebTjW47yV0aoZNBq41ImPRjkmPhzN7vu9IrgQ7u+LxDVzWkRznp6bNLfayAR9TzwTMdepi++rA2090CsLv3wzgV3fKGZ2atu9va5Gx9QDi+NqRcgjcnyCvC+SCUc2xOZJI9pEt34ShUScN/hE/f2Z3Zv/gLymoRdkJq8CkyBgT7IuCmzdiib4yoQv2yzzPbPF/49g3LsIsWl/ggN3Tl1cPVjMUh6SgPN9J4nwMUWadkz8eW5n4emo7v52PcqH9yEV+XbA312pO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(3023799007)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pELato7S0I+MytKK71QHKfAzGqmXazOwouEamaty+Of6vx7RB4RYko0t2wbe?=
 =?us-ascii?Q?z1IMVXkNqUhGkP7LugZZAFwh99DGzuS/VVo3QOOFB3iJthJiIsbxUdX909YZ?=
 =?us-ascii?Q?CfYBcR5LESSQXxayRo2amjvBP/p9eSoB6SXyLtObgMUO05X6C58g9uCKVmPC?=
 =?us-ascii?Q?6MQCwsL746McYVRqPUULpEKPsktifjHzs3IFaqwSNYARqDNKvCGQLDi5yUAd?=
 =?us-ascii?Q?Ro7cbFX+lYqo3jzsS5UFerH2DW8HJWOo+1YTHaKp379Mz/dyC7YT2xe0ZBAb?=
 =?us-ascii?Q?bhzYSGlf19fw4aVYFLQ85WdMbsE4wBLnHXavSQS9xbfqW207uDYG1X8AFGuz?=
 =?us-ascii?Q?tINhY0qAEi0JQ7bFLwqqFCkO9MSfi1y0PETJSU8Uu7mM0QinJid8vz9uCd1I?=
 =?us-ascii?Q?FAgeEtlXqm1D6aKUPTrfpyn5QoRJW2YvXB03W24qKsnetU0sAsFbsz5AuG4H?=
 =?us-ascii?Q?/ASaAHv9Hj/Wl3EWXHOcuGji4xRqEmLQjLcljpiEdik4LNNE8kiNpta/r1gn?=
 =?us-ascii?Q?fQh7Qf1t+ceaBEZP1ZBAxrDiXnlw9A1URsXny4itGbTaXv8I7oJLSrddGdgO?=
 =?us-ascii?Q?/5+ljfou48NLXZuDTt7Z2kYzWlNGCWGcCZVLGbHH5qKF0m7mobJVR34vGlsl?=
 =?us-ascii?Q?VtYQtp9HgsRsfK4jiTxi7ekZos+9nQH+deyBq5z6MbAsTuu9UGH8l6aKU9qc?=
 =?us-ascii?Q?pHy67SNUrW6ku6h0XlBjYUXWtm4H1xeXwU5aLHxOhbsID60KCnGm/7y1zoTi?=
 =?us-ascii?Q?rtbBwS2I1O6gmSLqTLhLJSUg/d/88b8djogldS80wQYTacSNUjS7TGhVme/z?=
 =?us-ascii?Q?S1Pum1L09Kd4KuJyweKiTV1asCVZImCF1GCwt87oq2r/j7zM2y3meG8dTQOC?=
 =?us-ascii?Q?fGPu8DUyyQIX2NN6kXFR7IQyLHhphB3WXO/+unZPVy4bo2UQR/ziyCZlqSsF?=
 =?us-ascii?Q?iFpyVGpmELnIKXcjxuvU5rBKtdHkN56iR4gP1//VT2jNO2KewNHUroWDo98M?=
 =?us-ascii?Q?7wDS2wskJGEs1pnAj9+0SJAzQAkjjnJM8186fLQPI/jbmSLJ5J6K4xfD0YfN?=
 =?us-ascii?Q?/+r2V2aKY0cBpVR2XSgN/7ONgNHmMW8qPiPcVZMHM0CLxD1qFPqah3SfeP17?=
 =?us-ascii?Q?uZ71dtBsLkxau3W0qHY6tSGX9eggWOuff2q2KWcnA8DCPEC2zT32R/QkYZLr?=
 =?us-ascii?Q?shIiPyE7VX+0527ZeVDMeUl0JxOM3+oeaNKwmYO9/bfiapGuyb658NmXC+Kn?=
 =?us-ascii?Q?1TOsluN0qToAMskB2DKUnQHmUNJUoUcm4xwLABa8B6XM65wDwaUDQnjgh18Y?=
 =?us-ascii?Q?HffQckDGFjFYRFlaHrTecLPafLi+d6TfCe73X4KsZeCkPxqznr7uHUuSIcuU?=
 =?us-ascii?Q?6yKOGsER/cgv6rItaeczJ/uqdEINHTmJMHcfalw/rw8Xk/QyrfnfWVMOVxhA?=
 =?us-ascii?Q?ayKkc/Uv7qq7hIxJ9lsdDGh0Xrd2zVJD6nRn29/Z3t30Ka+xoa5RVJsO46II?=
 =?us-ascii?Q?YJEMujvfUFc2eJMG/LAZdYVuUz4+BaNfhbR9QZsgLTonJSxwQNsKIlMaLxyM?=
 =?us-ascii?Q?ZMji5kuM/1hf48Ij4CaiRsWZuIfLqYoGlWScq0ry1NiqgdhTBrdlUCPGpJNB?=
 =?us-ascii?Q?5/zTbZ0mqAAK6RVbt4CNYTvbdoj1L4owDhy4z1F3dadS0MDMe6E7P2XuHK9s?=
 =?us-ascii?Q?uU8fc8+zPSAYd+6a9b1MAIBzMl+AfmP8ZEbl02NQRga9u7lHo62rQpg7nQiv?=
 =?us-ascii?Q?AKh/uR2aYA=3D=3D?=
X-Exchange-RoutingPolicyChecked: ZR1A0PeUubqxNN0Eku/+BOj2+jcORlz+Lmgg/Q+JNb6WSwYvcVdk2dbBCNovAFzyuksDeBc1g1AhhR+rEcuwS5WJBm95o9T4C7MLCnhpubJqmib6qoopJI/EIsFWeVahn1N0RgospgCKOVfbwoTXmZqDQ2mAw/egRkxYJPnd+ZzpOES8QjFxnbkAuHo6Qc0+i9TPBjnCLAeZBrIcTma26r5RvC1PktW7t97WRT3yS8Qpj6DnfktDmDntYTVZB49PjrQbbP2js1tb5jXZDAIjOntxY1iaLp6tTF+oKYMCi9UOpuPcd5cR9Kh/Pr6u+qj4bDs4hMuGyW8omCsWnVe6dQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fca0f66b-0acc-4d76-9ca5-08dec64b9652
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 17:21:48.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNiQXsvNt22UIO2ezNxVKflgHtVaJ7kL5d1NXxv5y5pyu6cfV04vudULBlS6dL2xycWpntM9d5wYeH67EjArbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6482
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:18:23PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > In preparation for re-running AET enumeration on every mount, AET code must be
> > able to disable events on unmount so the next mount starts from a clean slate.
> > 
> > Add a file system interface for architecture to clear the enabled flag for
> > a given event.
> 
> This just verbatim describes what the patch does. It would be helpful to describe
> how the flag is used by resctrl to support the first paragraph's implicit claim
> that the enabled flag's value is not relevant when resctrl is unmounted.

Revised commit:
---
Subject: fs/resctrl: Add interface to disable a monitor event

In preparation for re-running AET enumeration on every mount, AET code must be
able to disable events on unmount so the next mount starts from a clean slate.

Add a file system interface for architecture to reset architecture
controlled fields of the given event. mon_event::enabled is only used
during mount and at run time to check which events to include in file
system objects. It is not used during unmount, so it is safe to clear
it as part of the unmount flow.

Add kerneldoc comments to describe limitations on when events may be enabled
or disabled.
---

> 
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 9fd901c78dc6..327e7a863614 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -1012,6 +1012,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> >  	return true;
> >  }
> >  
> > +void resctrl_disable_mon_event(enum resctrl_event_id eventid)
> > +{
> > +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> > +		return;
> > +	if (!mon_event_all[eventid].enabled) {
> > +		pr_warn("Repeat disable for event %d\n", eventid);
> > +		return;
> > +	}
> > +
> > +	mon_event_all[eventid].enabled = false;
> > +}
> 
> It seems reasonable for architecture to expect that "disable" of event undoes all
> settings from the earlier "enable" of event. The new function only sets the "enabled"
> flag to false though. This is potentially confusing since it leaves the event with
> some lingering state, some of which is a pointer to state that an architecture may
> be reasonable to remove after disabling this event leaving a dangling pointer. 

Ok. I'll add:

+	mon_event_all[eventid].any_cpu = false;
+	mon_event_all[eventid].binary_bits = 0;
+	mon_event_all[eventid].arch_priv = NULL;

> 
> Reinette

-Tony
> 
