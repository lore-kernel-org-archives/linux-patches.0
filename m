Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6FA48AE16
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784043698; cv=fail; b=fVFNDP82zM1vC1HYnppPmwP978lmGs+Wr7Nov21sHK8VFaT74xzLcYTfnwAkPxhZbUw3o0IjdqAm8rTA3o8SF9tsMfCuK8u2Bb5S39Y7HDnwWNiC83bjBNOwd5U7uz7lQTMi///jciTaqLGlUq7QJsF2LUsMMRUj/81relfKWP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784043698; c=relaxed/simple;
	bh=f4I3K0quwORRSElpZG4wfvTDAtTW29ZXolPZ14bwR2E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SPpwkRRLMNwsdNmj7+/PwA3nI1i9Cs5jrz37ABq/KpvMAOBIwOTWlQThgu72QPMe8BIhtJuP8Vk0hPdkkQNwk0zyzpoVSscZRTZWXMuAU60sVeBtsm+TKPT7ZEegLte94bwHn+Vcj7/Te8xw44zu0ENG3STRLFyjcQiJSZmtRng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOXixuVJ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOXixuVJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784043695; x=1815579695;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f4I3K0quwORRSElpZG4wfvTDAtTW29ZXolPZ14bwR2E=;
  b=lOXixuVJjy8W5HG8L25r2nbMWX65QTBLStVigCcbazD6rxtOwLEcOkuN
   1FmulsWI69WrkBrPFiXAJRxq/YEhhyushxSU+AnUlQ2M87D1DiFAJcDQM
   YgL8Q0z6VnNjz41nHeC956LviQEGoYy2dUlfYSFzxJGzX6W6X5gz52g7b
   hNsAZykPDjDJZ3rKWkGY27fFSEHaIdtR16fv4A2rBTRhZpav/dKET0kII
   bYCRMemTUIj88fIZP45idbMJjkIwWqyGnG2vf2nbcX1s9v6s3guE7mhnf
   Ftnka0H8NEpo2SPLSjHyOdj74yH/NQRZOatij2nEzDjAlUn5gSv3A3Ebi
   g==;
X-CSE-ConnectionGUID: zz3PGHJcQfeD+BXU4kvX0Q==
X-CSE-MsgGUID: PlPsQ1zxQZCXiXuNMFePyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="87213074"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="87213074"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:41:29 -0700
X-CSE-ConnectionGUID: 72N45E7YQb+JJ+DxBKhF4g==
X-CSE-MsgGUID: 8jXlLczCRKy+to0oy4ppIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="253273134"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 08:41:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:41:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 08:41:28 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.70) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 08:41:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/Aj0TKCn4SS3aGS5de0sBF2VaQ/WeUOkm3SCNADbAbFdQrT+M7WzlmlUSBQpYIKKmIxWx4xyLkVtZB1RVjYmg5p8EaLynIAJS0MD0Fk1+kTziamGo0LcjNJu/5wgbhGJUGm9TkRcD4LSjtH3BQJ//3ijtgPGwzGfcu+bad4VeBjAM7gEaIMv6VyAw0Jj7LYtE7bPju/0dAjqKPSObe22asmzX9C8enk6S9GM4jSflKZvJWke7FK5sSwfkl2V1si9kKERhO3SULGTG8Bij9m87vDLVbNvdUrXkJT/6TM+u6v4S/TqE8jHNnCo5HdzmvdX938Eaum6iXvsO+009o41g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcV4MF/CXCx31GQu+7PdD6ex5UBIML5F5tDtAi1+iN0=;
 b=F59eYPP6ijeIKoksuHSR66C4P/WG1pis5+P28HrIft9Vm/ZQh32f0s6pYeJ1uAy9Zdg0QiDsF751Y0Nn83rZlMsL5ygKc34eEsX7zfN71cCoMfESo7peXtXZ9GVIboXhXLBg2h2Rm6akqn08QuLjhct6xNW+aszfD65Spx0Sb63hrpXqkwr/aCMuEuiSsnX0HyzVCSkaKI+ZsFY1yppP0QCbwYBNkzRA2Bb0Z2eh0tzuR/EkTzcZYCRF7tTnBwlqFSf6Qpz9vVWSfm7iBdmRLrUTtZ4EkuoHqQdGf01UPrOp+cMfkAuEyhBGFd9X3H2wYBok/te5fEnbmCwPogg6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB5080.namprd11.prod.outlook.com (2603:10b6:510:3f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 15:41:26 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 15:41:26 +0000
Date: Tue, 14 Jul 2026 08:41:24 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 07/12] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
Message-ID: <alZYpF4IeSzbEdsY@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-8-tony.luck@intel.com>
 <b128216b-cc06-4e6e-b6b4-498a6e135d16@intel.com>
 <alFcHbGmaDXygQpL@agluck-desk3>
 <6cf66f70-933e-4b26-ba80-83222fac17b1@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6cf66f70-933e-4b26-ba80-83222fac17b1@intel.com>
X-ClientProxiedBy: BY1P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f1c1d10-8c2f-43b3-2783-08dee1be5d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|56012099006|11063799006|4143699003|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: i9L/cR56bsi5N21q679rtu03FTm/U4TmzL94cS7dabXXvztTmo4Y1RdcdxcpcF558krlCHSJHujcjalZbvQ6W4mGP9KAmoFTQtHX9H3K4Wlj5K0X9i28B/y2MWNAUZORhj7uCEUtTqGzn6SYH9rqBwShLgqaGuxWZX7Uejy0ZxhUZUpxvZz9WL67739R0AYCnm7JHgMJSXaweo2m8ZbZGDMH7DAVeuOclOAb4ytIIPjIhUJgQvxgBN+q3g2cDQV98UbPyd9bggPbthpFzm5PQ7ijroRfEs8Dxf1yhx11r6P8bEe++JQnKjxOw+4j1idBL5kAGjuXY7/Wf1M2CCG+mA//yqMryZ6jB/JJftAMpwHM3meJyqPAQ5x3VWMFke9ZPTackAjnuY14s4CFYT5gvtKK3TZ/j+zv1jv34DgxUh2V4zrFy+zp6rlQWDh7a7GJKuGZX/I/f4wS5f1HT4/f3V78n4k/ZjS11FPMk8krEBX2hwvf4dzUnqK/ecS2DneTM6rs9M60FdB3Net6I2hiMpFb0n0fAz1SK8bulI5NpHWXEw67CBftlZtIGId6xaV2jt5hx/J+xzcw2XydAJiErMtizFmX76hfB/pD8vpiiBm+7XKfuwAxHERTRXDo4zgbX+SK9sIF2wkufhGNyGN9eWPStv9AOZe7CppADBipckQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(4143699003)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0gkiVchLW6N2BDtx7i8rWk+2jwXrAVJp2pPSsebryV4S7B5SIjHWrivmoOt4?=
 =?us-ascii?Q?EetWnKPcnaqR+5J/VQT3T+QHjlTDz3TMWz4/Nip/E/0Yscs2G9GaYuJU+uTU?=
 =?us-ascii?Q?zT2Y4FDMgwGsiuX0aGqVdkwDFhwptJycg5Tn4SFlPSsoIucSAm9VhH4YDsZv?=
 =?us-ascii?Q?7Dg8h0uS9sPyLK7JhH4UaK6gCgQ2nhrFkb6VTuusWY6Fx8nwrDvDdN1ndUM/?=
 =?us-ascii?Q?CMpMDgO3FVSOfKP/+mFOzMgYO/Mpfdgtgm7eXGQ4/PXpOl4fsMWXVB4yXte6?=
 =?us-ascii?Q?GRnb/xwhufJRH9TYD/F2si5NjK7quqevYYCMP2PkF4EB1WGcAHKn4wEmR/k3?=
 =?us-ascii?Q?qtRiE4rqQv+/kZavnky8wk4n2ojmHz9qv0s+k+AXxqVnBbbJBpmob48LnWLq?=
 =?us-ascii?Q?lMMDDCaFnq6Lmv8nj70sclN2AQ8ci3DWlcxkfjvYBwKpZymF/Wnm8kC89+tu?=
 =?us-ascii?Q?4syWlMEuyZU/m0OWjK+jez0U9R1bDMxydCdxS5lWuyRSGx3K22nBMUBuJuM+?=
 =?us-ascii?Q?Brk2ldOoCZSfX8C4PLthLBpPfb9VBvdhl/xltwT21jgCa5Tzjrb+0a8LlTxT?=
 =?us-ascii?Q?3hBDFbZNGOeQPctQwHC4aEODx17dAtCG5M7ptqZvh6Kqjwmx1b/N0F5GSWca?=
 =?us-ascii?Q?PzC/fQkVLqeSti2F3mxcrwxMomR2zijuzAbyeICUx7n5raRXJOqVouEllhrh?=
 =?us-ascii?Q?VIYmCHlTk6o/+vFUMiVKpAkJ+cG4Y9DVs4YDGtFVeNYoMk2r03XGPNt0igii?=
 =?us-ascii?Q?6lvm9VQ2f8rhphHLUPoswYci9wp9LTyu8uf5Szxpfr1YfI0qFBKBFy3r5D2A?=
 =?us-ascii?Q?hEWKTAr+e7ti2Oe34ZMkG7zeneXYL/ev4fE0neUkVUO3iMsYqLSMbQtI/aqb?=
 =?us-ascii?Q?uOQ0KSFDjp819BsOFtt1tlmkENxrqjwb4zQ8EuJ+iYQQgQo8nlg8MkxRcfEL?=
 =?us-ascii?Q?r7agW8ENk+v1iYxaWVKWYf5Ghgw7sZnP3PnY7mcKJVbuoazUoKaHTMXkwNZv?=
 =?us-ascii?Q?JfzzQ0qSNfffu7SZktIEJZWSAMO/zS+i+kTyap80gF0uyVGuJdN0zIYhizQ6?=
 =?us-ascii?Q?0bel0JTHrij5LSVyCww4zo12CioqapaRCMzXvourqBAlb0QdrtDrEGn25lVJ?=
 =?us-ascii?Q?M0W2K4bKocQuQC9kqIb1tZa6U+vbtnJPXthH5sGcWPth1irMvKFti6lG5pJZ?=
 =?us-ascii?Q?kRG9qo4g/XVZYd2JLNTobL8iGZ5sWIFCVU8ymiv5FixPnPXPyi7hcRAvzrKv?=
 =?us-ascii?Q?vwxz7AZPMinPBeTAy2L2MDeIuZIU3MsskUNpHNqMy5mX8v95yVS5lBK0LMfX?=
 =?us-ascii?Q?1juYZYfoBKKZMXG+UQPRCFTOR+c4zzq9cut33vzL2GgqFwTF/iSNc0ApnWn6?=
 =?us-ascii?Q?/8f8QJqVyXAHaf2oWhd4x0YnZfbxvAgC9uwtDeKStu9m7WhQvmTw6zve0DXD?=
 =?us-ascii?Q?UodfRWvNIxxtfbdfgDokpMs35w46Ip5BmGGzhUp/NO2Rm6Z6pSwDwKHQJmdP?=
 =?us-ascii?Q?Thq6uPHZZYi9PgTBKyhR29/gcTOUvlC9vi/6TKZ1GGCJCuTqJKXPGZxkWkex?=
 =?us-ascii?Q?Z/pZb47EepSnD3WcBH0Bj8x3THYXz2KWhbe0Aw0vkdJ0HWynRNrimvC/hM1M?=
 =?us-ascii?Q?92CElsXCAiSkC4wJHGYA+TiFzmqFi5A7Z30ZfHWvD4mbGKwBPaS76V/8wqjt?=
 =?us-ascii?Q?McZuabxTEFxaIXXRNQkO8bweL7uSG5mb644zdEsdf186rRYRYWhf9U6p5uIY?=
 =?us-ascii?Q?6H4URilFzg=3D=3D?=
X-Exchange-RoutingPolicyChecked: EqtbKn6JqTaDLVqgAjj4ZwZdLzz5UWtEuLuXMeuPCX7+uVb0gXE7CVo4skD2SUErQAsbGSX2Rq2M2Xcav5x6V5p+ze2k9W6bBbDHo7zQdOTxyOQKstqRzKhN9OYxbQvXVwt3G2vYOKtFA6kX8MZCKEQII8n8shu/4dO54tvRXCq2VXWLl77arovyYKHFAGrm2GAtJjIMy3xpBbaaEcNOX4jXXZ3lsXAuCby3ePWLgaI0L9egdEKGRKqUvfPtLQAxccMvKJOU392sNcyAE5H6vrgBbyS2FoMkCZcBcH43R7wnpVeUit52763YD66Yo/0Kr5h/0tr17OBaS+mPtGVp1A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1c1d10-8c2f-43b3-2783-08dee1be5d45
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 15:41:25.9707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13++jnZzyC7aKJ7GjaFTYFv8mdLxawBj08UNjIhEGZWJOB/j2UXdRECJ5d8kwZNpTXXI5G5aLUrmSU3kub3FrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5080
X-OriginatorOrg: intel.com

On Tue, Jul 14, 2026 at 08:18:47AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/10/26 1:54 PM, Luck, Tony wrote:
> > On Wed, Jul 08, 2026 at 03:51:22PM -0700, Reinette Chatre wrote:
> >> On 7/1/26 2:35 PM, Tony Luck wrote:
> >>> resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
> >>> export, register/unregister functions so the PMT module can supply/clear
> >>> enumeration callback functions when loaded/unloaded.
> >>>
> >>> Suggested-by: Christoph Hellwig <hch@infradead.org>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>  arch/x86/include/asm/resctrl.h          | 22 ++++++++++++++++
> >>>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 34 +++++++++++++++++++++++++
> >>>  2 files changed, 56 insertions(+)
> >>>
> >>> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> >>> index a9f481b7a8ed..48ad55bcda66 100644
> >>> --- a/arch/x86/include/asm/resctrl.h
> >>> +++ b/arch/x86/include/asm/resctrl.h
> >>> @@ -4,6 +4,8 @@
> >>>  
> >>>  #ifdef CONFIG_X86_CPU_RESCTRL
> >>>  
> >>> +#include <linux/intel_pmt_features.h>
> >>> +#include <linux/intel_vsec.h>
> >>>  #include <linux/jump_label.h>
> >>>  #include <linux/percpu.h>
> >>>  #include <linux/resctrl_types.h>
> >>> @@ -189,11 +191,31 @@ static inline void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
> >>>  
> >>>  void resctrl_cpu_detect(struct cpuinfo_x86 *c);
> >>>  
> >>> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> >>> +void intel_aet_register_enumeration(struct module *module,
> >>> +				    struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> >>> +				    void (*put)(struct pmt_feature_group *p));
> >>> +void intel_aet_unregister_enumeration(void);
> >>>  #else
> >>> +static inline void intel_aet_register_enumeration(struct module *module,
> >>> +						  struct pmt_feature_group *(*get)(enum pmt_feature_id id),
> >>> +						  void (*put)(struct pmt_feature_group *p)) { }
> >>> +static inline void intel_aet_unregister_enumeration(void) { }
> >>> +#endif /* CONFIG_X86_CPU_RESCTRL_INTEL_AET */
> >>> +
> >>> +#else
> >>> +
> >>> +#include <linux/intel_pmt_features.h>
> >>> +#include <linux/intel_vsec.h>
> >>
> >> Are we sure we want to include these in arch/x86/kernel/process_32.c and
> >> arch/x86/kernel/process_64.c when resctrl is not built in?
> > 
> > I'll look at this some more. Maybe this code needs some X86_64 checks?
> > 
> Some forward declarations for the needed parameters may be simplest. Another
> alternative may be for include/linux/resctrl.h to get a section for definitions
> for when resctrl is not built in?

I'm trying out the option to move these declarations to <linux/intel_vsec.h>
where all the structures needed are defined. This header seems like a
logical link between intel_aet.c (which defines the functions) and
drivers/platform/x86/intel/pmt/telemetry.c which calls them. Both C
files already include this header.
> 
> Reinette

-Tony
