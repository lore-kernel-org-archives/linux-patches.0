Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268812F12B3
	for <patches@lists.linux.dev>; Fri,  8 May 2026 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778276200; cv=fail; b=dKi5mCoLqEWK46Sw0bxpe3TLUpiNfG8+kBMbqrLEdAqfUVgv5Sw+k674XwKYqX6pyQ/rly3IdeNxdDXShl2YyI5zB8GIvVSdDpz8czwuCZ116GuPMzSbLQamun1jUHj6IaNjrW98csEnUlhFAIpev2FGoiEerr+26HSFjGj69sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778276200; c=relaxed/simple;
	bh=PxswiFh/O3PCninvoItVZkKMsbtwv8YDudz6Mt6HfKU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r32ixc2smWgRHGhsVgN2e6VAn5y/xp7JVNN01bYstWD9CUyMR5gyTF1cFfHZ2Kqd9gTBQLn/ymvi4h+lMQITdywevWcjkNPIHbGt4hFZQeklYfBPeFPEEPSX11uIrwtfzx3IiTWnA9iIIc/aBhu4vzg280yoplH0SMzbAGN2VS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyt5ttcG; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyt5ttcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778276197; x=1809812197;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PxswiFh/O3PCninvoItVZkKMsbtwv8YDudz6Mt6HfKU=;
  b=fyt5ttcGdqOpOdcCxhTgIz75DgZsmBiJxgqznPpBm6iyRYi+jJOSW1B8
   UZiTZjBWAmXXWCdBKeCLSa73zYToM54eUnNlImSdb3pzVk75k66iZQZHM
   AJjdFCttus4KwSqAtK5cLF+5QmsFgszjGlPGnluqZlAEUOXQW660YZ6G8
   sv5sj0Je/WTOPdQWYiHKuT+5BdfHByB9yjIPYKz9StVXgGev6RcgmBRsS
   CV4k24LyoxdupM0n0h3lIbQTohbxerfhZEW9MGD+afStuej4Nf7aR2b57
   Y9SvQzpcvnSHu8X8vTmb7EEPXIJ5dvtDr0mQAv6mn2nio0lWmxZNJ7vM3
   A==;
X-CSE-ConnectionGUID: N6mA35rQSiqAxAv083GiLQ==
X-CSE-MsgGUID: Z8NfkC7MRUiVoYMpIhrWfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="82876465"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="82876465"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 14:36:37 -0700
X-CSE-ConnectionGUID: yvs10cJ4QDK+Qe7Ctn0N3Q==
X-CSE-MsgGUID: tQUZy0peSj6QfRy/mRScMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="236992297"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 14:36:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 8 May 2026 14:36:36 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 8 May 2026 14:36:35 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 8 May 2026 14:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBvRDrLIkNeCZe2mOYFSPd183IUdi9IGdwy3dPeBdVlC+nx2ItKmZJjErKZ+LIUpZeEZHCpx0F1N3HQcPaUyTep9hP21lv1pi2MSMUJS2RY3RxSCKeUGptaEfNbUnRL1GEsQa12Tppeo0rSCgXArSeSBqgColPrqNQCLoNDc7fPn85V19sD+jWuVfmkMHXz7khubnkq23zdB4v0QBbSdn7BgLJnU7jn+I+uUgqF5j2O+agAbKPzfXlhgfPAt3azPlxfABDEerLlQvwhOdLHhSAGTQtH+wDmTJ3LGPP0DknFXklME8cIY6M9VIgDcucyDDjTo5kh42gU2XzhnaWEmzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87KfhIKgPnGRLxPDwcWJSPDyyr0REKmzS6iZFxrdpds=;
 b=K8JYNihdQCKkI8hrxRTWBF/kdRUaWXTZ8oWCqOvz2z0GiVqOJvhysXhbBAw8Clr6eAwAiUd9BNKtSham8qNkdAiHXunlKqOAfL4oxjiPIM7iouSsriXC66zDPTCRfN59u3uliRHTwl7aD0ihTiTNbFzrwdlSecFmI4rIwii8/s98QJ4cgU7vgmjQ7vO8Xa2EcIXLBCws8k4PkDy+x2OppbRyugC9b/PkUd3Qd0RPb5f7GLD0LdAUYfZ4NVlJBRl/FgwJR5b0L+fzwPt55cLqserhaA1DzG3fzIglTNx4VOo9mzYuCpKpj/cBQ4Rg5a1vqzceqLNWJ1Vul75V7eqH9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LVXPR11MB9780.namprd11.prod.outlook.com (2603:10b6:408:387::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 21:36:34 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Fri, 8 May 2026
 21:36:34 +0000
Date: Fri, 8 May 2026 14:36:32 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 2/4] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
Message-ID: <af5XYNAklCdaAfsy@agluck-desk3>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-3-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260508182143.14592-3-tony.luck@intel.com>
X-ClientProxiedBy: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LVXPR11MB9780:EE_
X-MS-Office365-Filtering-Correlation-Id: 4980b926-b508-4361-f136-08dead49e040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: zWBZvIlNYTu87VdGwYkChpzj5jHuLiKQUgKlNStX2vfA/vt6zWwfWGOg5qzaNO477OxanJXNhPsvrYvEMjEtWi27AYS3pGFaGqee/etMyVDuCTAeA+4jXVVs/IMT59x1xcxoaCy2rq/1xI10TTNO3UVH+TueSW97vuJUIi0nxuCZK4iRyDX2GLFmGrEOxloorqLEeJIib0X/Y3PjdhxRzVqBTT5prXO/Me3b81c0MnIh+iHIijmJU3zoE15YFnpdep+gGPFPm+byQJIYf7m3TkJ93ZG4sD4dMmlJxC8CEa2714AwFpUdlrv4W1RLRTHKcHjzZ18blk2ek/iPYFwvtU0CW9ggqp1wToPmM4MCAdR+QKoHEVcvFWjYRYonZW8hb25xRh01B5R/3QOko2DXYHE9pPZSbvU5KtOtA39EtOjIuz9EuFzHcl+ErpGAwlitzhb3IIxLPVhIxD+S6R1XFKUGrjdo7Oxh1dsIBEp2+LgTqqi5VSHlx6iFgvelCXRX+owYEVnkcujAwNqrKtFHneHrkiFmODnRpoS3QirypdGBCPZwuEIuhjULL/obWhYekFMMIQQEuCW/c+MOQmBT6v8t5NyWUyKfN0akwmux6ZfwjKFanXbsS6cbtyZ/jVDD9p5Ub3C3IqCoPRUle2Hbn8+y6p9cVgjChfCgswUN0MD0O/nCjjJhhqFQ4ZD912pn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KSVf+NhEroVATG9YvWNXeT2f76G6dxQBt/5mcJYculnrs0VQpjv0uPSCguDR?=
 =?us-ascii?Q?stzynkhhfHCzYbyQwrr3COq+0HogsidBbITMK95ZkSV5F4aUfre7QpA61QWk?=
 =?us-ascii?Q?k9HwimA+j7c5XKSt26VxsNC/2RGusV1BFEyNcvwNnnD87jsPPnlR/Hni3gk3?=
 =?us-ascii?Q?F2U05BU/cEUuKP2lwY2JFS3/Qw61IDROIsJGbtiXYIuk1S6/ENmPtvJjbvp4?=
 =?us-ascii?Q?UufJRpsmKJP9aHKeDAlaYLXf9TA8xbU8ZQDG8c+U1FdutBsKA6tp/k7jbGFo?=
 =?us-ascii?Q?zf/GlvriOYz0Jn1KyQ4W8y2AGf3UQ1is+PLnLzdOnHRbe5oEOJaqM8ikavIh?=
 =?us-ascii?Q?2zWwU0+C54ugAKjYq3b1wtXL9lzxCJiDLw4gQpY96KOMxm9D4LsQIbjt9owa?=
 =?us-ascii?Q?bjj/ztkUXzyoL5NjSIDmzFmD+8OjNG4X6HaMaqMJv050S8IvRVhh8X4plGqu?=
 =?us-ascii?Q?CY861AmXnkQQHEIoGEkBYC70YSxaDVAQBjyKQHA0RSnt9zbyNZkaP8FYQuqZ?=
 =?us-ascii?Q?1eX2b5UWQ75KOANAZ4VQPxZuXm64DttOr8uSRHDjEDN6aoPNCXZF23QIRdBH?=
 =?us-ascii?Q?2hnLPe1MrdH0/jXdWpHqdyMrKmkMTQ9w4M8yWpYknVOBC26oMKK/X8fe4Dy7?=
 =?us-ascii?Q?HwUeiishMbYM/zJ6OAEWQbm8w9A+o+4hkNJ3wV+78RPLAPtaYze+s/tYEDWO?=
 =?us-ascii?Q?z2ag8aijIlXHfd6rBnrZzHWPhe3TaoWsQ9L7qZiNCBc4JuJNxCsBV4HxtA0U?=
 =?us-ascii?Q?c2rA0TcgkshdvD7lP/rVMzh/KkuAmLzN00vWOB9OUPiuCweNA+UjLSQp44ew?=
 =?us-ascii?Q?pSs3ce0fAR9x3G3sMxe3SvdpawWJ3wdDc+qZIRI2E8BXDFUYJy3/qyy46Xf0?=
 =?us-ascii?Q?gBVRt/luIyH3mL9v9hbxFZOjU/Aw9WLOrhmS9pKNOXqxwtLPJY3zKbG3eilw?=
 =?us-ascii?Q?BKgVEOOARSc1BI2RcVGqFoaGcUqqkAahWw/7tXRgueNQ3iXoASkVfcIXl5br?=
 =?us-ascii?Q?yh3O+kGE1Ja2MvH6tYvuiTVTqw7ObUHoqHMWTUHYJ1db7sG+wSfm2nEroTzM?=
 =?us-ascii?Q?sahR3afxEx2qZ3CTKRkecMnLJ7tBbZKRW1C9uJo1pCc0ZESNqA3wH9SozTGL?=
 =?us-ascii?Q?c3lPpxBsQhLkUVcc/N2dxlc+kkgsFRC28wkYCf4Lv9E8xOK1k4fT9cat7OLb?=
 =?us-ascii?Q?aBBWSF2VSTarX6qKA6M2bPzjBVTgvRf8wQ9ZFN2TypyPMGwSJaIIVpUlxvIY?=
 =?us-ascii?Q?m6rWwhjzDFFMt8eDWuasyUWx0PijrsXAwAPsFLg7hQpwLgHmLz2x5y8v/kht?=
 =?us-ascii?Q?tCmAHx5N5RdpBj1BzmgzyRsB3X+3zCsrjz2lrMv71ml7D1HTqsLypGywWL2v?=
 =?us-ascii?Q?Qru3APEymguM664HHNw3b0PTwZF9aTzqiEc9qH00+tCQAH3fhSdhbtBZxchI?=
 =?us-ascii?Q?QzjgDI63kSlaoUr/UaIJqxbiqYuHtDAL4QIIEZpiEXGyms5gC3zXI6U4sstA?=
 =?us-ascii?Q?f8EEEoonjWnJzELdmwk35ZMqOGQ6z3nYRt4exruAqS4jdYlRwTJJC5RVXY97?=
 =?us-ascii?Q?J8q6ozrmDrm1YnSwpTTGpsoSuY845rQqfgavzREibYqkjB1EPAcnTMX2d/fQ?=
 =?us-ascii?Q?PRkOQwslilFAEOIqcpCEySocjLzhFm45E73sqBfy7nZxledW0lFMtRsRXJFk?=
 =?us-ascii?Q?l9oHxxe1v0Vf+lmHezM+RDKMoxs5Ad5NOm5kLi3Gb3dxFFas2zAbEZ+nmqzs?=
 =?us-ascii?Q?kiZOPpS26A=3D=3D?=
X-Exchange-RoutingPolicyChecked: BoAY1jcvX4t7YcD5XQCV6odzFLF5Fl8tX9BocnkoNGHJEoXjHamHEL+ATPGNuG0lR1FndjG+jsRQ1EuvdaAkvLjQDgbtBBCM6yQVhVKmGJqrQ1IQ2dOiGWgk6y9jDCuaS2OpiR0cJhvmPxWacgZ9NqOssr2mvtRjLEfq6nrenBKOoc1t9/dcouK9tbcIJ8vejZk4GlYqiF/wIEmXncmviFo27xxXfxwkhtqaokPs9UJw7/8ZGG1c5H3FRPGqXIUAMiK9ltXpT57zassBICWOVfz49DPK9gMh48Tiwa/80n1YCa05Vu69HPCCe2TcmxHEpHCETng0qkTuRS7sF2ksKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4980b926-b508-4361-f136-08dead49e040
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 21:36:34.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+wLs+FD6DkiE07Aa1WWVA0UTMsCg51ItXPIwBTP99xySAzlMIt3z4TnULdxHPoNHcrtO9Al8V4hhJr2zyuT5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR11MB9780
X-OriginatorOrg: intel.com

On Fri, May 08, 2026 at 11:21:41AM -0700, Tony Luck wrote:
> If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
> fails, the mon_data structures allocated by mon_get_kn_priv() are
> leaked. Add mon_put_kn_priv() to the out_mondata error path to free
> them.
> 
> mon_get_kn_priv() and mon_put_kn_priv() moved so defined before used.

My bad, leaving this stale commit comment here. Code rearrangement
in patch 1 covered this.

> Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Assisted-by: GitHub_Copilot_CLI:claude-sonnet-4.6

Hmmm. I don't think I was assisted at all. Actively sabotaged with a
patch that looks plausible, but it actually wrong seems more accurate.

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/rdtgroup.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index a6376a3fc4c3..0db1a92aefbe 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3067,8 +3067,10 @@ static int rdt_get_tree(struct fs_context *fc)
>  out_psl:
>  	rdt_pseudo_lock_release();
>  out_mondata:
> -	if (resctrl_arch_mon_capable())
> +	if (resctrl_arch_mon_capable()) {
> +		mon_put_kn_priv();

Claude put this call here ...

>  		kernfs_remove(kn_mondata);
> +	}
>  out_mongrp:
>  	if (resctrl_arch_mon_capable()) {

But it really ought to be here.

>  		rdtgroup_unassign_cntrs(&rdtgroup_default);
> -- 
> 2.54.0

Claude is fired. Replacement patch below.

-Tony

From 0263035539f805f5d4bddcef8968b551354cb86d Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 7 May 2026 13:48:51 -0700
Subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
 failure

If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
fails, the mon_data structures allocated by mon_get_kn_priv() are
leaked. Add mon_put_kn_priv() to the out_mongrp error path to free
them.

Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/rdtgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a6376a3fc4c3..506b40dc9430 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3071,6 +3071,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		kernfs_remove(kn_mondata);
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
 		kernfs_remove(kn_mongrp);
 	}
-- 
2.54.0

> 
