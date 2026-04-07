Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EBE33AD9D
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775587250; cv=fail; b=qd+GcmlC1UoR5Bk/U3h2rdEA4S8zYVFhhrzw9gEJG2uOt+/Fd092I/4mBAwUGWqISaDHh5xhKG5NM4ysEL3OhMMjpMJYofijuA7Ufj0osk4NZXGYD+Fy6S1cHVq6c+egozzTqFtkDCwP+DGoi3eJXdINc/r11KHdLUw6Npb/yNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775587250; c=relaxed/simple;
	bh=NfpSScCi/B6NH36Wbfq2PxafxcQ42lFMd8cy3NR3FlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g5rbR3gSe386S3GgkCXdt3u0mVGs4czpB3Ym2zTzjNkNXsu5UrQywskxB1wTOfEHUuPbesw4lIxT/Ev1duFpzFIsl/sVWt91CVKJv9TctZQY9+hYsZMx6NeWmdCdeFh4EG1rm3TQAAt1UDrzVXC3tqUQjNRD27JXlPX+8h8/yW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZQh6C17G; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZQh6C17G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775587248; x=1807123248;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NfpSScCi/B6NH36Wbfq2PxafxcQ42lFMd8cy3NR3FlE=;
  b=ZQh6C17GGwsVn2DXW3Bgb7G+/u2cTMO+2KxT/ULvlf617PPTDmn20ZpT
   9DSDSG8+H/eBVdKmjaKrD0CZodacuBupoIAeg9LOlYgcRKklKOEpT4bAV
   CQjcL6R6d4iVU3BGD/0W6tvlL9qzc9hIP86l2u8LZ3FbYRAj8zRUM3+CA
   AkLW6WKHok08p1FkHti2ZCqZWoVM15VaS/Qt+jrQQnbHMo6rlbdDfJjNY
   zn32BE2tp7H50ufSG5P+X9DBXVdPLI+lTSayJ6tJ6NYFSLoBlWKuHy52u
   ls8K/fjGk4PMUMfCjE+9uXbpWJlhtwiZbkf4eBLDAiDOrD8V3gef4L7uG
   Q==;
X-CSE-ConnectionGUID: LIeqd9qsQCKXW0CC7Mcgmg==
X-CSE-MsgGUID: qh0mDJtvQdy1mEZZ9sWBNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="102014366"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="102014366"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:40:48 -0700
X-CSE-ConnectionGUID: 9t03bWv0SUel6geX2bv4/Q==
X-CSE-MsgGUID: UvuC1ujeQuyZm7bxhhKTRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="233127520"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 11:40:48 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:40:47 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 11:40:47 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.23) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 11:40:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQbW0wod0Hnq9TXx+T9m7043fw67oM/bCq0fyK2iG540xPN/cZxOMIbg14HNs972vBckjSru2ERjebo3Z8yJrLt77It6w7b+uVzptTwFyhmUsLHxFSs9exYGL/imN6K7Tid1SFqyznJCfejN339hbT8uBBB1ihwSGJlrzYQwWYtIpCV/OV0Mbp4e3348aSqFJKmm2Of7q++NLA0M6Zg81gLUQJHBak9uuNNCkYkoAV234Gn26+p5T6vlj/W4/fXfsYpz3cIxIRcXgEc4TOxR8s/vqgw6yHyN5qNN2PDcFvI5N4k6cCMpAuAtnOdBAPfttIV/Ju5UDEcAC6vS9n0XFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=karFkSKsh1IEzEObMpwNRj0aTE2PBzdX44WOT8+EoN8=;
 b=HZov5wtwGdCZnWkQfkcLh6wXfYL+D7sBVfE9Nejh8Va1BjPjdaS0js1g/SIl8r2W64jTg6u1fMcpsoruM+SFf1p6KJSe0hT99NSYtZvKLdMUR7dHOxsM8VzWeYE6ejEbR38owQmHCrIHhJTJmdOw9AJyTck+0130J2Se6eANcXMtb0HLExBYjA9e/3o+EFMuf1NG5Q/OKr5Ztg0neJUpX2RQZ955xUL26f24c6Smwmw8eCElJRm4xbbRqn2cq6dmOY13LkVd+F5QFmq8AauWQOMFvvbOdRp8BJaIh1v2LsOd/N9lz2eEaERrdZhSubBDhZJQu4DquYLpIodHPEjCKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6227.namprd11.prod.outlook.com (2603:10b6:a03:45a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Tue, 7 Apr
 2026 18:40:43 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Tue, 7 Apr 2026
 18:40:43 +0000
Date: Tue, 7 Apr 2026 11:40:42 -0700
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
Message-ID: <adVPqiY8NRQSR5Mw@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-4-tony.luck@intel.com>
 <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
 <adP86aXVJONQCFc3@agluck-desk3>
 <f6a20148-28a0-4423-a0c7-472b97ec7f16@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f6a20148-28a0-4423-a0c7-472b97ec7f16@intel.com>
X-ClientProxiedBy: BY3PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a78d3c-3d11-402f-1917-08de94d52cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: gJdCs0ccnIJQQcLBOSzQWpRYEZqkuJ3xrdpIASno5K2dFUeO942rO9hPam7SSeNlYPzK9bym5E9/9IjgNGdP28XJX56DqgG0VcusiL+sPgy5u1PhcQiGHjJmn5T3prwfyHocEKewp1hvrMGOEC+gOHndaUcPWrdWeb9u1iR64GkR2SVmyQ6nAyy2QrxpPGgZ3O6rLWM/mImfGFzrtfff5rz9gtGo1uX1O7H0YLibn3N2uxSVhHCP7GO6Wh7V0bFR7sDxaT58ov1om47xOXKmh7zNgHR8PcaOPHrLPWw85tLOEtGSSQwJN2QooLRIloLevu/X33UgvTd+hFEAsup3AZ6Q3dM+ffmgl38AwOCxJlCWYYmlefaQS/Vx36CX3vpSeOienaewvyn//hfsc+kGyS63R9TmvfKk7Uan2oCVCsBsQDpRQc0grKAyT6pnB9vPliIGHgz5/1zzB68iX2VMCu3obdRvIXLL07yZHlEhSN0xEc87uhhaNRiyznYWz1EG8rHtkCXi56NyA6DSA6vw662GAJKmgPio4204ovtG4ZKqJBZTA0tzPF9Zelw4AXillovMs8ztPiwL1EhRPuZl1wP8VpVVAAClbkG/hRm44WrQRvtTTgPK/xBoZ+Ds59cxBGrdh33Tde25yJUP7UgL6RZ4iro53iYmwFsVCwsuouL48QIg8h58BhsAM2v9u347Y3okg/2FyGu3L2mydqu/0s9D2jUKH7CnnOvhx7kx2Oo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?izKPGF4+m1BrMugIp6I2KXfJbCaRDutnOKVurE8/7KttFBGLmlOahL9q4iQ7?=
 =?us-ascii?Q?MP/rmXBXlBjqmiuekzmR8D3j0QAIY1grurtsfYmDv+TBRsxgxCDGNf1QZkt6?=
 =?us-ascii?Q?2cC2LocIhWK/wqr0e0eYT8DWTHCrWNC7JmSQoGjCrU2XLwZW6aT5eYNnekxi?=
 =?us-ascii?Q?LtpU555g9drurxGZwipPhkmNGsf41i+yba0Ov69ka7slpP2oShoI3VhOISIa?=
 =?us-ascii?Q?JY7Cyi3GJ6iFHk6W0FwgjXrxj7gGzdV7KCcBZKRHp3BsJs/nCqUsfwzREzve?=
 =?us-ascii?Q?ke2pS6GBsx95JuEbF6n+PWbe6YvrPdNZ90Gk+EGatPkEDiEmU9kCKTuPkikG?=
 =?us-ascii?Q?VpvjTNRfVEeOe6KBGQjknVfA2AcbQfeNreTahF2S4X0heIotLUzVQZnzVCzl?=
 =?us-ascii?Q?gsQuZZrPZQsTzdxYGTIYP0IHsD5gZDsFxdz+VMub/96NalUgJW2CF22+Yjdt?=
 =?us-ascii?Q?LvVWaL9LnaDXeyD9XHFa/S8QOjo1XTKJSTPQ9OIsLpLoQQUdId4XqiZ+NHSf?=
 =?us-ascii?Q?A42AZi7ihvaDgDVibUy5TzhpsrkjfTkFRU6Qf0wOFPDioEzv9SwjPn3QgMbM?=
 =?us-ascii?Q?J8p5S/yVb0+EF2oGJvGql7kDZRiFbrpsAQ1RxagzAqlFDvgiwGw67Y3MNzAV?=
 =?us-ascii?Q?RFjLkZKja+IgSUCP1HorfU5wPef9m4lgNJ05UB+KJx9Cuk6SFqPzkooAOAxP?=
 =?us-ascii?Q?R3sx1EFwaKFsfYmPJmiVGBgbkd7HmJlP8YDy3Um/B6C0d2XcukoHdLyjuqh0?=
 =?us-ascii?Q?9EbsbegMlcGXpy3A5Iw4cLUnDdTkj65b4h61FyzKjWdqPtRrh+pMNzw3gdWK?=
 =?us-ascii?Q?w0KaPbyBTMXAc0rTfrk8+HsgKSir/GeR75Y03K1wBr3e0LOCX3AAtpShgjOm?=
 =?us-ascii?Q?eRnRlWNXVpxqAgdPdxWgSh5MqP9C8aQCmKIqg7GMiQrlKWHLCeDr0jx5WES5?=
 =?us-ascii?Q?vzXhB4OHldHXl5L9/Ok0+HE1MkNZgQwLfBOnnUHGMLx5RKtgJK+M+aU4YT4g?=
 =?us-ascii?Q?0bNGykt/wAIju218EI3W3XNib4aawUtC5ePkk2MMo63Ug3wFX9lsabP4nel/?=
 =?us-ascii?Q?HHfmuu48Kksw6kTsfNHxkzNCdeCM4qYJ2lwXBn0w8tSoJQmXH5DwR0W/TUMV?=
 =?us-ascii?Q?qdOkYeLNUAyuS2F2Vkbu2qpLxZe4mNXk/Kc3MS1VpWP8qWvTHW8MOa038Jl8?=
 =?us-ascii?Q?6zRoWAVBFnoBl6FvKa3ty+WhZHeyeS+FxcapBCQtIpZmXUdRNzQk8g+Xd2/C?=
 =?us-ascii?Q?wBlkmxKXdmmXehIc+Qi+BeAxSUDgFZOEsloj8fqLE0iU4x8s8PjO07PIeDiS?=
 =?us-ascii?Q?DZ43HUMNwhucAsVOVCHlpzFR1HAyJaBzi9aDrmnekOpTFOJ4468lOPphwaPG?=
 =?us-ascii?Q?7S1dIxlfVpQ33heMmUKZh/s7dPT+mlrzZk9DZe509fHUEixCx7oa6k9Q+/H1?=
 =?us-ascii?Q?GwQ+iW3FNgkg1hWeIkSljzZj+6xtVEFF2io5yvsKj6jlc5wPjYgTiYStajRq?=
 =?us-ascii?Q?ZSlg9gK+aUMiHhHAnOuSnUMwkZJ6wSwSZzWECLIZkPra+jEJq+s7diUXlaT1?=
 =?us-ascii?Q?SevymNYcNMm3KfOl/VRFjZpRm6q4uj4uYUXoj2esfZUhpWgstIqcKGOTMSP6?=
 =?us-ascii?Q?ZH5k0FIDlR0zBsp3ABrIEaMJ/dei0m74pfN+XK4dGrVEDxPyIz4fTUorwrRg?=
 =?us-ascii?Q?J1luhep/0gSEo1Y/s/rafl30cJQz/5z0wVz6O3qPdSuxd1kC2bzTxNErNZUU?=
 =?us-ascii?Q?9KQjBdUClg=3D=3D?=
X-Exchange-RoutingPolicyChecked: BHktJb4FMe0tfM5OCRD2ZAIcn+ygsZfazJBMZSDwMQrgdwp+V94nPZI2/IpB2t5A0o6SGmSPItcaEJEHhXN6X3yW5KpZSWR4vGt+kvn4m0+LNmiPnlrpMaQ/ojtWo69RodLuZz6SIZoK2wMlKEyCkX9UB9gF+HyQNPM1wdAfwpLdLljAX4XdcPRk0xYkS/jxb87vK/Hboz2isgv2u3FaCuUpm5aRQdtGG1FCRash2RxF3h+Gc0yBo76ULTdyQ7OVwlLwu7TSTIcioFQhlxnJs2TEKAGIbfhlWzj6WplZRdFW97x0ECtlCKROxyQxro7H1KPE+qp9ZyWFqxGT1sHnTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a78d3c-3d11-402f-1917-08de94d52cdb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 18:40:43.6141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2U0Yyub/61L4uWN8QFMqftWllxSOc2b6mRxGRIzBjbZFknGajziqSVWHKLawaF/jOpLkD16J4e12K6MKCNtWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6227
X-OriginatorOrg: intel.com

On Mon, Apr 06, 2026 at 02:13:19PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/6/26 11:35 AM, Luck, Tony wrote:
> > On Fri, Apr 03, 2026 at 05:03:28PM -0700, Reinette Chatre wrote:
> 
> ...
> 
> > 
> >>                                                               At this
> >> time these scenarios may just fall into the "architecture must do the
> >> right thing" category since it has best information on how state is
> >> managed for the events as they are enabled/disabled.
> > 
> > Are you suggesting to just drop the check for resctrl_mounted (as both
> > a locking issue, and an incomplete solution)?
> 
> I am indeed suggesting to "drop the check for resctrl_mounted" but instead
> of "just" doing that I think it worthwhile to add function comments to these
> two arch helpers in include/linux/resctrl.h that describes what needs to be
> considered when calling them. That is, describe "architecture must do the
> right thing" with some documentation about what needs to be considered.
> Such documentation may help us to start putting some boundaries on how
> these helpers can/should be used to help guide any future enhancements to
> make this more robust.

Something like this:

/*
 * For events that require per-domain allocation, this routine must be called
 * before CPU hot plug state begins allocating domain structures.
 * For other events the requirement is that the file system must not be
 * mounted when enabling events.
 */
bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
                              unsigned int binary_bits, void *arch_priv)

...

/*
 * This routine must not be called for events that require per-domain allcoation.
 * For other events the requirement is that the file system must not be
 * mounted when disabling events.
 */
void resctrl_disable_mon_event(enum resctrl_event_id eventid)

> 
> Reinette
