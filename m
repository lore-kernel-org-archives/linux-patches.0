Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FA24A1384
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023877; cv=fail; b=YM4LijoNCTaV3tyxmaxLYYFCoinOjLkKBldC3cEzEgsI6xPZaEW9zXK6fDgd3ZxcPMx7YVIc1QJgSA9ov8YQqqopKWgRjIsKdW+meW4mz0iOsJ0rI3xU8ocBSwMAooEZGU0XRq8uW6e0D2THzSBNwScfYSkE5LOIQAz2LuyhNiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023877; c=relaxed/simple;
	bh=9cOYxtutzRODtGtzwJBJ08CQwe7iU6SP0inr04lwfro=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=svIxBFVthVwFEKHP82BHCb5soL99maIUqOXfd3kRe7O/pVCS3rVzTEwWZmxlHkLF927N9QiaZsWpZG1vOVOBnDenhGiuDyBbQ4gC1xFqg789wAgCart18YDmxFgi7UFBaTinVoFJqzNP2RWvz/HugBlLuuHELdRXdOGfufVW2M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+j7JLmU; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+j7JLmU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781023876; x=1812559876;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9cOYxtutzRODtGtzwJBJ08CQwe7iU6SP0inr04lwfro=;
  b=F+j7JLmU5QFLtrqHW0Q6XxJCOAUg7VFCaq+8YF4X4yCQc+N5P+fAk9Tf
   IaTHLYF6/Ul9ClX0pgtdgsYkxujn/YwuBFhOHC+I11ajUVB9WDv7Z44+y
   OYwWVHQf2K/KL+YhkzIYpOHeaULVWrfNlMmZdj3+FO37unzP8MWmAxR0X
   wybAQRYxVmuQWWSefqlftzCZgbv9lL4J/lLSwL4K8PPgeAgMguWLkiiix
   D88nXsQ516BnYSDT8Afb10IeK6d9LUumyGxZ1ciP2SYbGFfCRcL9HKBTH
   NrbBqoBxD7g3MrrGKSa0P9guU4Q9hlxx+v4OhLo1S6KJj+JMbT6FrnMaj
   g==;
X-CSE-ConnectionGUID: RVEvhP6ERquWciyu4rUtrA==
X-CSE-MsgGUID: QC5MAQXXR9+yRME5nDlhbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81983240"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81983240"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 09:51:15 -0700
X-CSE-ConnectionGUID: wDCi7suzRUGrhGscDWFCAA==
X-CSE-MsgGUID: Ggbc2u29TJq8F1ywUR1PWw==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 09:51:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 09:51:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 09:51:13 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 09:51:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gyo65CYfgnhne9zWg9qzC6QXocYmuTWlmNvK5WRiMzwCUeIjOSrIUofTtv2BzIXC41u2edA2vfcz1MRcBCXVuTIwJUIj6w5eavvKqZ2v4miRsK2naEMI2HJSAmJuF5BsbItBSC5DGYMO8Z+/E3LapOJiJ+oE6U5hJXys58I814zVLm29DqSaDIm7vjJhfoJaXw7vKfPEWZVWd3YRnxvp/rBsYDevYFeXONR+4xJ8c/2o486RCGX4o3Xedba2HTh9sF0BXuu86QtU2kj8l9Uo47HJXC39rQ3LY8JdFoh/NeiTal34UIvfpiQOxZgIH1JFjXitFTnZ8rx5bEknE59ZMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8le1PcTjMGMEdRR0MAGvN3Yctd+ivUWeS8pbJF3GYU=;
 b=TlHtFzWPajgHMcz1QObRFNFbZygUvFvEmI87woJlfSukxyv7BItxHg/9J/+C6u5VrtD8hgnSHMRvQXtx48IruoFF0XmDa/PFATUGA9y2wvhwYY1ZMf6I2PolOHGQLe6C/lV3ShB/7riB86di5y3Ist1V6jcUTxQH+D0z8jSjO6Z41OmoehLY/mHMZPqVZvPsNJxjge1lCtIHaPRCiDcwW+oPsGNczQo7ZdYuKf9bUEy4Dx6FkBOqx8qVhlyiKMfqJXCnE4dxbkNEpNh7chsfOSKDelmx4dNSuOAnV6oRWcOarQGzB0rPRdt1VDO8f94OH6D22YVev4YNpepEK1Xm3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB6223.namprd11.prod.outlook.com (2603:10b6:8:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 16:51:05 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Tue, 9 Jun 2026
 16:51:05 +0000
Date: Tue, 9 Jun 2026 09:51:03 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 05/14] x86/resctrl: Stop setting
 event_group::force_off on RMID shortage
Message-ID: <aihEdw6gikv2aSKK@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-6-tony.luck@intel.com>
 <4a62b53d-fafb-4f93-b724-e39ef93f0e99@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4a62b53d-fafb-4f93-b724-e39ef93f0e99@intel.com>
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS7PR11MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: ce1d45b4-b12e-4a86-6f53-08dec6474bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099006|3023799007|4143699003|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: LH8BlX+VbdJV4wU/cdokb7sOkoIFDJdRnknjV2W84PWp0h9c7ys/SzvlynLhOdf/ThDQ2+h1AsWDTnG63ddQVHC1p7H4t5Ifh0Q6iQIAmOXgc3L66hX27CRlIRyQCKS6KnEt4KbeDf6MY78hbHV4Ul4o8WdnPp6nJety7fgr0hsy57vfJntdzI2f1zuqGaV9D0Qx8BapN/8WhxhNmL+7zyx1nugBebg7dPR+cHVYNIPG1+SDcsFHT9CDMqWBRK8QjVuq4SGrpL+Q4aqaafxs62Hic5bCDv0876Ow20oqirBnUV1q6V4oqx0+DgAJaCxkSM6BW6XXJOmOEV3L5Vr7pPLRalko0h6FcGL2hpWpP3Bonl+GRsfp1+w+xVaSvnXfkvBNwerTSpV2Q9yY5xRLJ+dI4zcEJK9M2B5kcMYbxLEKCA9f2DrJRSo0a6BaucRIBSYKrnJ3DAAZr1hcVrv8Cp0/iLOYSj4rIbI2CkQnc67119rgxNEeFtEJ9MrTHNODxl4B/dZiSr9zcepwa8Pj8I1C5q4NgRUaYp+07gGw950IFU6mqfj0GhcJpwHpMx/riihzNQjf+TduMaOpyR0Ad3Z+d0jMGuTOQ0waqq83RewB1DJqsciFLrCc0vMh9xKkUb69WyIsb0fXrZTb2Ku//bK44FqOQr63Ww/O66OXp9sS0QoH3RoDu+w6GbYSKnWp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099006)(3023799007)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCHBHvsNXTVHqxTcDQC8Y9RlISBZs8/0GP2eX2mvNFvz+gg05GSaciJTTqzf?=
 =?us-ascii?Q?tfrrjRKyyWb3mpHgTQwnQdIXVrJPmVhZIHP5qnGaETprsliggGSlPQxWyXGI?=
 =?us-ascii?Q?YGHktQrH2ZCtJviTvq8pB+xJU8xBeCg8D5oCQiXHOv8kH2tl4P948FZAcxR0?=
 =?us-ascii?Q?30QKWa3C11V5kh+6r+zdp2bzjfSLIkgwqzfEaIkgdYhelCll4fMx7V01chh0?=
 =?us-ascii?Q?QQZvxZpD1FI0O7YdZOwKWhsW28YDzoOImIhoNA5+UqtyokDEBp2EN9HTiQ+M?=
 =?us-ascii?Q?6jpWj1/aew1uYa8XR8VPhKRv9fS3W1xlkQMHfnfcN1nzt4lxjRabU2JvBe40?=
 =?us-ascii?Q?/rPqupbyYZKp+sZ2wm5jEVNMtsXuA18WOcAfsKQYn3nI6YVgnoO5EHQFf3c5?=
 =?us-ascii?Q?RpWZ7xaPqcT01rhbPLFj3RxU26MiD4peA9TRc+0OXB4on+bvwbZ9jhE3SyF+?=
 =?us-ascii?Q?MACk8R1F8tFDPgqJJQzjfFG4gnpN+ju7PwkwXu4TSJkfQhitci66b7SfIvUG?=
 =?us-ascii?Q?h/7Cl2JV7S6D1pX/IrL7n1h/yUPQ8zRI1gg8C0imFPKxoxu6vz68Z6HUx3dN?=
 =?us-ascii?Q?1xaVQ6kp/DsxQLSItXnod/RzmlfPrOQED1Oe9S+Q9+AfKwbZd+84oCPH50mJ?=
 =?us-ascii?Q?WIwftVUk9s5TG1Mxg2ZWQmi95lZlu/4tfij9ftcwAPQTzinsAfFnTVb3P/b2?=
 =?us-ascii?Q?UQVr6Lqfylu7QSi+BboqYdrLoPG/THJJ4ynzi2vzKoHiQySq4jpP5tZFtmiB?=
 =?us-ascii?Q?vmDggNprqQm4Zb+Jn2nj01xhhaThTnAH2t2/PCRRXU4id2eka/ogERD72ki4?=
 =?us-ascii?Q?zmZaNqYqlJu3NcTVwMuLYLo4xhrr1+c1G0u25sYbNCuNmz0bbzaLnXC3uItA?=
 =?us-ascii?Q?mDp6fQLkBgPz0Rv0LuXJ7OzVb7HI+8VrL+6VNiNC6urXM4OXUJ1M/p4TXyXw?=
 =?us-ascii?Q?yIZnnCpEuritsI3Fr0e+79BTxeFlMSNhsEFw4LsbPYWhF9iNSAvqc2B+dx8q?=
 =?us-ascii?Q?gd/TK1NJFQQvxnEhq3cu2w2nz76sPCCob7HGSVgQATFOXb8nyRaRzrf/qtSt?=
 =?us-ascii?Q?fRS4w7iZc645HaTYOORpaoUbi5qrfc0T6Pf7OhII1YcwUEuJ/A3vczFpd9CT?=
 =?us-ascii?Q?PhQMNCHpFRbRmOaWhDn2YpakIZOG9Xl8qIeaBHkULTogArg9mWmi7xZCX2z7?=
 =?us-ascii?Q?2i8tGU89eTIje5eC5n2xcOCZ0LGL/ETZ/m5cMN+hPTMmlDcGxDBoWsyvxXla?=
 =?us-ascii?Q?QK9rrepG3sr0RPaDSsejpG+Glrldszt/lsfdTf02YeNdftiEzlmPHxCcGXe1?=
 =?us-ascii?Q?bWbmoWZLeabzdFHfW13bAB8lXwyjiGAiQOH8hPgDbp3U0vgh4r4IKPKQzrKZ?=
 =?us-ascii?Q?ahvQ9w/f3mqEvvPi8uBp1FFTQ4eg244gXbvIe801OC0qLDtmvVTETrl5ISiD?=
 =?us-ascii?Q?CJz37kldV8LsSes43eRVCTOQHaULy9na67ncl7M5I9l33XTy1FAubzQsKdMM?=
 =?us-ascii?Q?+WYyyvukO7giVCmgxLQ7f0O+M4NJx2WwcZLIremTEDNramU01PnaLsuZ9FKh?=
 =?us-ascii?Q?nbpD80aXAqLDL9g+oCsIWecdDY9sNhHtevq+//1MDkLt4S68SAjO8QtLKpHw?=
 =?us-ascii?Q?4WCO5IbNpPczm19oMQAzgUXjMuyPx2XRBpNbhZqIv3WJ+3stlvzFedtz0sb3?=
 =?us-ascii?Q?Q+LiquMSlOer/c0IvEWe54IiGjhwHV7tUi6zEsGDCQ7gnTMz8OTSEHLAFiF2?=
 =?us-ascii?Q?J/VjORmRlA=3D=3D?=
X-Exchange-RoutingPolicyChecked: eRiYQ6Fz4k/Bg6hgs5I4hxIY78WHz+ZBeyCf/H0zscb//5ybs0CcGhSd3q9jHULbqYLB5pCOm576Hj1VeV8U+d/9qlNgZq09cQSUtNdFwTS4jcJ4Q1C18DyzZ5RWiYitgVomvFTCoiFywlg2/khR31op+gK7yy0hrqhd0WyG420Tu6v/kyNyojhWPeWfHYV4408fiuZemlApA1V5FJf8ymJtoxgUNayygLdgH4UXk/DHSQW3WtOzYOA4ZfSd+lCkwqzIL2RKrQn/qtAqzfW0CBxr5A5vM5ptRhQndP0sDghBKRCwONq1lkkBj47E5Rhh71HN/wUJdov8EUwiZ2Fxxw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1d45b4-b12e-4a86-6f53-08dec6474bbd
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 16:51:05.0531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pqxxraoit3TppElZwnmLp7mQQXHm6MdyV4G5aECisGqSVFKmPFB4xddqY4NMlfd1Pl32tEmSgmLqNNpRzMKbNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6223
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:16:58PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > Drop the force_off assignment from all_regions_have_sufficient_rmid().
> 
> Apart from this being obvious from the patch, this is not how an x86 changelog
> should be structured. Please see "Changelog" in
> Documentation/process/maintainer-tip.rst

Revised version:
---
Subject: x86/resctrl: Fix usage of event_group::force_off in AET

The kernel command line option "rdt=" is used to force enable or disable
individual resctrl features.

There are two problems with usage in the AET (Application Energy
Telemetry) feature:
1) If the user specifies both enabling and disabling of the same feature
   (e.g. "rdt=energy,!energy") the request to enable should override the
   request to disable (for consistency with other features).
2) event_group::force_off is set true in all_regions_have_sufficient_rmid()
   which will cause problems when AET features are enumerated on each mount
   of the resctrl file system

Fix the first issue by checking event_group::force_on in enable_events().

Fix the other issue by dropping the assignment to event_group::force_off.

---

> 
> Please note that, after the preparatory fixes that are expected to land separately,
> this will be the first patch of this series ... having this first patch just
> kick off with "what changes" without any context is a difficult way for a
> reviewer to start considering this piece of work.
> 
> > This preserves current single-enumeration behaviour while preparing for
> > the upcoming per-mount enumeration, where latching force_off would
> > incorrectly suppress re-enumeration on subsequent mounts - even when the
> > user explicitly requested the feature via "rdt={feature}".
> 
> I believe that user space should still expect that rdt= options behave
> consistently. So if user space for some reason provides: rdt=!mbm,mbm,!energy,energy
> on a system that supports both then it should not be the case that one is enabled and the
> other not.
> 
> I this think that, for example, enable_events() should start with:
> 
> 	if (e->force_off && !e->force_on)
> 		return false;

OK.

>  
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 89b8b619d5d5..e2af700bca04 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -60,8 +60,8 @@ struct pmt_event {
> >   *			data for all telemetry regions of type @pfname.
> >   *			Valid if the system supports the event group,
> >   *			NULL otherwise.
> > - * @force_off:		True when "rdt" command line or architecture code disables
> > - *			this event group due to insufficient RMIDs.
> > + * @force_off:		True when "rdt" command line disables this event group
> > + *			to avoid system limitations due to insufficient RMIDs.
> 
> >From what I understand it is only architecture that can disable an event group
> "to avoid system limitations due to insufficient RMIDs" and this capability is removed
> in this patch. Above implies that this capability now needs to be implemented
> by userspace, which I do not think is accurate?

Should I just drop the second line? The user may have various other reasons
why they want to disable this event group.

Combined with the code change you suggest above, this would describe the
use of these two fields. "force_off" disables, "force_on" enables (and
overrides any "force_off").

> 
> >   * @force_on:		True when "rdt" command line overrides disable of this
> >   *			event group.
> >   * @guid:		Unique number per XML description file.
> > @@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
> >  		if (!p->regions[i].addr)
> >  			continue;
> >  		tr = &p->regions[i];
> > -		if (tr->num_rmids < e->num_rmid) {
> > -			e->force_off = true;
> > +		if (tr->num_rmids < e->num_rmid)
> >  			return false;
> > -		}
> >  	}
> >  
> >  	return true;
> 
> Reinette

-Tony
