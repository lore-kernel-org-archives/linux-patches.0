Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644842AA6
	for <patches@lists.linux.dev>; Tue,  5 May 2026 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778022473; cv=fail; b=syMvygZR62FxbiwGiZmQPDKkQl0HOkgXtT7Ki0//77wG5R9GXnnivDGEZTdMX8+stpMosmLkwwNSfWNW/t8FGXz+DSJO/CX+EbY7yBMVfVUmzLT+Gt2V/BBVoDXtfrctUupJUjjj8SdLoTsJcPraw7veEATX/hNdrmpRaRCudp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778022473; c=relaxed/simple;
	bh=c1AXw+7Ep/4FNrEy9nm+bYotppfRrOnGVOUICyaRMe4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=adcq+v0evr21nbNhXtfKxp5pIn/yDZJxeCbLnRhq8KoARWF8Hy3oDMxT9Ha1x9vLAAGgLLbRJnoI3HJ9ePG+mqs38cayQDUsocIGFMzHv0d2vQRxXyt9I1zU+WdfKf9MmPt0x8Do8OXbTggcmuyGE/q9gqoW1Iv6/v4HPcuVJKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YReOR5dZ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YReOR5dZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778022471; x=1809558471;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c1AXw+7Ep/4FNrEy9nm+bYotppfRrOnGVOUICyaRMe4=;
  b=YReOR5dZzk1RaLj9S1Rh7BEv5eM/sbFdaNWKAC9rFmy2NJiDHGEAI7tp
   QWZ6DAB26hU7TRTipiGBDMAG0AN9Jc+4Ol1buhUPsEyt0skmw2DxpsUkQ
   T8dqFiAJfbtNFMurKt3bJ+NYOKdFGAb2eFZgG2ijIM8wJZPV98AMM8dyW
   bMpw+38hj+SRduo6fHF1Jqt0nsUDiuZTyAcZ1ALu3Xf2Qtpnc6n6hCt4U
   nDXRqlgtICZslzFi3zks81Z/xouN+Txt/po14AB4BCFzqOveC52QB4VA4
   9Lj1DeYkVdeLiqb6KmAZVocdoYQ9woglZ5GTnZquxfqWSU9+uLOWBMd88
   g==;
X-CSE-ConnectionGUID: xbF6QSsERK237g5fcOSXZw==
X-CSE-MsgGUID: PIlWsxlAS9OxsMrZtiu1Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="90283096"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="90283096"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 16:07:51 -0700
X-CSE-ConnectionGUID: v0H/VOAjT7OJOgRkewu0ag==
X-CSE-MsgGUID: 33+KAFmvQIaTcxvS6vF7Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="232829134"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 16:07:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 16:07:50 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 16:07:50 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 16:07:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npBKZ6/E0StuGpmwtY6roDPRzyUej1RAvQpzoXqo2BzrY814GNaOj1K9FjuDj/j2ifm5HkpX4rDI2fGo5FlV2IRW87pbcLSmX2lKJO8BM20JXFdYXWHGZhw5kFRJ5AeBmUQJRgLviR8OVMvlrmv4o/nnUy1jlxQRsVXGZguseEaeNrKdQH26SA3tNBm1D25YDWuU/MwXOgEiKQhoTiFQt/jhIXu38tmK2cyuFECQdjENhSsLN5BwxHgYKWPlgbO1JXCKcdkKWB6OaGoJqdoMe3pTEyc3jeS4zKGyIo7K6N/JcJgeluE4cAZiI1qCxYe6ve7tBOv+4JVuS2KoKx6Ccg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neOexBgvDjDhsfA9D4KlrBQat+UFEW5hLXh5cQ4PC+E=;
 b=dnIuz/xQH/G5Y+5U66kRxXhqblVD23CrwdiCn6vBHFzVYY1CCUkUyDKf7CnzUarFEcUkNxrMEKMZAJEXxMtgVAfFZinln9/+aN5WsqPrCClHsQsq3ih7JmfcnBQE261ziPgdBn8bdTjvMs2jE2Hf1UX8uZNfU02J1Tx8m1p/8yZmKUqHhDkVsGKlpUKdR67z77z0oYzPDQiLQzTpT53LLuSAznRNExTsGPTTWxSLlIfUAJAcqDbZ7dyYpQXuyAf0/igZpKZIAGVKHqAwAx8x+fox4rBiq8mGGxn327GblvYgkajaqpi2JOOxu2SsUSMbPh/kXXCJpg6b+1yXvXgSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 23:07:40 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 23:07:40 +0000
Date: Tue, 5 May 2026 16:07:38 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afp4OkwtPpyIwAC1@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
X-ClientProxiedBy: BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV8PR11MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 51584639-49d5-4ad7-2f6d-08deaafb1b07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: Mkel5qCOdGqKt89j23poxzaMJuwsxwKw+i2bsiV5uIKy9wEJXpaJcGZTigWSydZmYqUtlbkBcxRBR+MOgp1jOnCEgZiLCfG/1oq8bi4DiIgtY11J1EoWDjHB9ZkEuc9SeSsrWcWwhF2ITQodchYf8G0k2QVzK1y9cQFExtFgCw97eS6kiTM+QeBZH3zspzuQ3AM9e3IdAJsAZgJPpne78ymwGmlS6orbrucYStI+BSqFED9GaCFidBPDhVSXeTadv94wHJtktFFcAAy+vTSGnfyVSX0eGggoNS6VR4Bl+/3cofICAC8y1+fJP7evnTX/EGPM5rAFmH/zMXBxqE69OZa0xljX2bLCkixeFnFrwf4CZ2CsEwK2Y23bc7PZANyQkDN7k0n57VOnoLuvPWZE5OP9if4qFjykw3qy4LU0n/Oelm96ikd/z0cEvbwea5lsUj1+WifQsI5SpIiOhpepSDE1pjJVXMHxDdoV5UowmhzuFmhKNrId3eyJNXpWNc6knGQvVZn0TjxC6ZQueG7J4FQM6xs88id3Ku78z/CcEI6PP0XFh8cH2XzqolcWQfiiUeJ0lkxwq1mBZijVmHhWHqMDLuE1qqyKd4l5zK59B6pSmFFzSCZntOZEIsWEduC90KmyE8pGRoil/pZ1V3qZGYQ/uy7B/LXaTUCw6j1galq9Uuiz2cxpyh/VBpOwRxtR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FqbqOibiaCPQVLtF2gMM3VzxmXIBbOKD8SVVijnSPwjx0r5C8xnb5RWL1rG4?=
 =?us-ascii?Q?l7+SpDoNDdTTpLT4eo/FJY3ZuZDpWMzl+iN+Rs5eFSINIfjQp3GkZEXONmA5?=
 =?us-ascii?Q?SLiGiVLIYG45ktSpe21qYwEZujmCN2Mkk2BWaAAwT+s6fOtlafXZK+bNb4DW?=
 =?us-ascii?Q?xugodOMBWip+8+mHh+KAORDhQbhvKbAi29lwgkayVnPAxjsY7kNOByDNK+IK?=
 =?us-ascii?Q?/2RljMyQKPa+wfGIexMSVvPS1GOK53QX0we0t/YuWLyHnhdTZ4V/9nb/zFbp?=
 =?us-ascii?Q?RQkWcsq1zeO4T76kAQ/wQ6eAiMSM9t88Nj3tkwp2X+WcbH0rOoTKA2OybX2t?=
 =?us-ascii?Q?TOxSnaoRrZ9Zi/6xP3Oy+AI5GB8fsT2oo7TvU6w4Hb+3gOETt0GSxKxH2Aql?=
 =?us-ascii?Q?KEOi+ZNeSyaRoFFcJLgXW0zlDZUl/Pq8zbGm5Lt/xKEBph7OKLbNP32qxdEn?=
 =?us-ascii?Q?tdHHSbHmi0N0kdDJpLSwFOoboITW/1m5w6NRoRNFGIubxxLwI+Da1Fcgp3n7?=
 =?us-ascii?Q?+bRkVayICaOyEBZRb0vR7L0MLlm1KpM4hJNhqXWL86BemSOlNfOdIeU8kmi7?=
 =?us-ascii?Q?kS1W+YK0Rn+9MhS/GNYfytVkEa2bHZiGMw6loBD2GPRf4VGmLByj0WEjagLY?=
 =?us-ascii?Q?BxRdJH3wQW1xEcDjfR7Vvn5eTP4fnlfmTVhsjU0ja71yb1RYORO/jp1SnTIS?=
 =?us-ascii?Q?ntP+bpqK7RAPLXj+EvosyWiAVk3JGUi5/K7ETCzJSPSit6rltgjql/GE8prZ?=
 =?us-ascii?Q?2eCVTgbEjdZHWQh5F997zKYpEI6C2+LoeDBQPW2awGQiyBe8tfBLuvH0xE/L?=
 =?us-ascii?Q?9GdR0/0E65jp77EcFFJoaaIfZhz960ZgrcTapVj+OskOGu2rTy82E7d6LsGQ?=
 =?us-ascii?Q?DLgWyIHrSknAiKdEeIePxAv5xLZaJJW9bCAI2CLnRZtUs78nqBGC98YiTwmb?=
 =?us-ascii?Q?mrK0A2jmaHG1blgrYJmNNHn5C701NMYVjVHed3RXNgZsM+fL2eMMUZHbxOLm?=
 =?us-ascii?Q?AhqZj+MrxyhkCbczqAH9j8/DM4x5kucZDEOFxLMhpvF5R1/IEGuidhhwPbGI?=
 =?us-ascii?Q?wges+N5GAsTFsxlpyHXrDKWvM657e8XnyWm81eV6CWXlPhR8PBAoggL2530J?=
 =?us-ascii?Q?qv75Yoe6Re05IJixEEAmkJEEXDbfOkaAkjCV1ZFhOg4nRD/ZENW413QEtufG?=
 =?us-ascii?Q?gqwFwCYzW10FacNFkh3qPSGxxqfDMtfVvEeIEm7ENNMAd4Th5RQvj9rN8KNj?=
 =?us-ascii?Q?4bUAFSVhH4bnDnV1Uf59+vd/Wk48IfLKeo+5xZ8LympvyFwcgbRjThz/qGdu?=
 =?us-ascii?Q?qGoKg/aJQatMb6DDtar3qUeyq8N4nwcoltSDCpI9WBMurqtnt/PPmoTewA0E?=
 =?us-ascii?Q?rjRERWgwr568YrmDzYL3ankE8f8/jFPSA2bFnmpVJQUGe52kU/VolcBu6XCL?=
 =?us-ascii?Q?Fn3nnoIC4P3Zn8WngjmiFJLJCtfkTtRa1Ahz5FMJg3mhyhDZ2vVmaVl442GY?=
 =?us-ascii?Q?FAyMZN66yy34XxDNfrJWXwaKwTwwkBScm9rjFEA8IVPjPQS90Bd94QRT4Yj1?=
 =?us-ascii?Q?LWOjNQ4UW0XPd3BQxgUdYk/6N8YwLM+ATZrqFcg+Q5G5b77pQKNGO2ZkW7CH?=
 =?us-ascii?Q?mM3RmTZcLA1gJbYNSlpMm+EimQMRw60WoC0PBbB3or0FpF8HY1G5jAtDM93X?=
 =?us-ascii?Q?VoD8RE6wa5fbX6DoDtTmRkgEawVMZ3o8NY7pRki97Sgvf1Q6y7QihVKB2+Gz?=
 =?us-ascii?Q?Gm0jfk27+g=3D=3D?=
X-Exchange-RoutingPolicyChecked: akC4flaC7khy0pmQ2WY7Y6Y1b5cyi1jSPCQDotLlU/4EuuVq54rs6kCTMDYUzMdDSEWSFUC9fBh/XxOWz7XTh5XhsnSiTTi1vXkdX0BKv3N005KAMGg3C/yarHev4qUYpyh5J4wea1Hi8Bwe13AP5P1z6IfVq90TFEkONpcqs0hH8UWO1MAeHrovVpw/zzANtA34kJyIajTrGC9kxHQe6K4xXTKI9oP9xSf0Bqekoe6UStAyNnGlX5zgLnUuJwAGA0E0DGl413cxdO/gGvUr5lHT2sJGS2i1LeQh5Wxx9m9mvBRZx1uPVIZx7k7h5FUWyyYsXq5ZbkSND/US76kFbg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 51584639-49d5-4ad7-2f6d-08deaafb1b07
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 23:07:40.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oTuLdg6eTrFBqiR81noJB7QJX2Ly9SjXV03mcoOGp6Nq+vGKcG0TTIIjFLES8VRu9few51XiMQIDpZadlQo9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8724
X-OriginatorOrg: intel.com

On Tue, May 05, 2026 at 02:26:11PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/5/26 9:45 AM, Luck, Tony wrote:
> > On Mon, May 04, 2026 at 09:39:40PM -0700, Reinette Chatre wrote:
> 
> ... 
> > Here's the scenario:
> > 
> > There is just one CPU left in a domain. The mbm_over worker is woken on
> > that CPU just as user requests to take that CPU offline (executing on
> > another CPU).
> > 
> > There is a race.  mbm_handle_overflow() has begun execution, but the
> > offline process has taken cpus_write_lock() so it blocks and sleeps
> > waiting for cpus_read_lock().
> > 
> > The offline process calls:
> > 
> > resctrl_arch_offline_cpu()
> > -> resctrl_offline_cpu
> >     -> cancel_delayed_work(&d->mbm_over); /* not the _sync version */
> 
> Here I expect d->mbm_work_cpu to be set to this one CPU that is left in the domain.
> 
> >     -> mbm_setup_overflow_handler(d, 0, cpu);
> >        Finds there are other CPUs in the domain
> 
> I do not think that this will find other CPUs in the domain here since
> the scenario starts with there being only one CPU left in the domain and it is
> currently running the overflow handler . From what I can tell, in this scenario,
> mbm_setup_overflow_handler() will return without scheduling the overflow handler
> on any CPU.
> 
> After mbm_setup_overflow_handler() returns I expect d->mbm_work_cpu to be set to 
> nr_cpus_ids.
> 
> This detail does not impact the race you are highlighting though.
> 
> > -> domain_remove_cpu()
> >    -> domain_remove_cpu_mon()
> >       clears bit for this CPU from hdr->cpu_mask and finds mask is empty
> >       -> resctrl_offline_mon_domain()
> >          -> cancel_delayed_work(&d->mbm_over); /* Again! Still not _sync version */
> >          -> domain_destroy_l3_mon_state()
> >             -> kfree(d->mbm_states[idx]); /* file system state */
> >       -> removes domain from L3 resource domain list
> >       -> l3_mon_domain_free()
> >          kfree(hw_dom->arch_mbm_states[idx]) /* architecture state */
> >          kfree(hw_dom)
> > 
> > Offline process continues. One of the things it does is checks for
> > orphans on the run queue of the now deceased CPU and adopts them.
> > 
> > Finally the offline process completes and does cpus_write_unlock()
> > 
> > Now mbm_handle_overflow() can continue. But it is on the wrong CPU
> > and has a pointer to a work_struct that was freed by the offline
> > process.
> 
> Thank you for the explanation, I did not consider this scenario. From what I understand
> folks encountering this scenario should also encounter a splat from the MBM overflow
> handler from all the places where it runs smp_processor_id(). Well, actually, if these
> people are running with CONFIG_DEBUG_PREEMPT enabled because of the
> debug_smp_processor_id()->check_preemption_disabled()->is_percpu_thread() check.
> 
> ...
> 
> >> I still think that using get_mon_domain_from_cpu() in the workers could work here.
> >> Here is the idea more specifically for the MBM overflow handler:
> >>
> >> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> >> index 88f1fa0b9d8d..7186d6d02d6e 100644
> >> --- a/fs/resctrl/monitor.c
> >> +++ b/fs/resctrl/monitor.c
> >> @@ -856,7 +856,9 @@ void mbm_handle_overflow(struct work_struct *work)
> >>  		goto out_unlock;
> >>  
> >>  	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> >> -	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
> >> +	d = get_mon_domain_from_cpu(smp_processor_id(), r);
> >> +	if (!d)
> >> +		goto out_unlock;
> > 
> > This will get a domain, but it will be for the wrong CPU.
> 
> If it was migrated yes. From what I understand when this happens it stops being
> a "per-CPU thread" so how about something like:
> 
> 	mbm_handle_overflow()
> 	{
> 
> 		...
> 		cpus_read_lock();
> 		mutex_lock(&rdtgroup_mutex);
> 		
> 		/*
> 		 * Overflow handler migrated during race while CPU went offline and
> 		 * no longer running on intended CPU.
> 		 */
> 		if (!is_percpu_thread())
> 			goto unlock;

This is neat. It works well in the case with the above race on the last
CPU in a domain going offline. But I think there are problems if there
are other CPUs available, and user takes d->mbm_work_cpu or d->cqm_work_cpu
offline.

Here the corner case semantics of repeated calls to schedule_delayed_work_on()
are important. In this case resctrl_offline_cpu() will call:

	cancel_delayed_work(&d->mbm_over); // Not sync, so running WQ keeps going
	mbm_setup_overflow_handler(d, 0, cpu);
		There are other CPUs available in the domain. Picks one:
		dom->mbm_work_cpu = cpu;
		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);

			This sees that work is already running and returns
			%false without doing anything.

When offline of the CPU completes, the worker runs, finds it is no
longer a "is_percpu_thread()" and returns without scheduling future
execution. So checking for overflow on this domain is disabled.

> 		...
> 	out_unlock:
> 		mutex_unlock(&rdtgroup_mutex);
> 		cpus_read_unlock();
> 	}
> 
> 
> I am not clear on whether there are more than one race here now. From the flow
> you describe it seems that when mbm_handle_overflow() runs on its intended CPU then
> it can assume that its associated domain has not been removed and thus that it is
> running with a valid work_struct? More specifically, if is_percpu_thread() is true
> then "d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work)" will work? 
> I am trying to match this race involving the CPU hotplug lock with the race described
> in original changelog that involves rdtgroup_mutex here ...
> 
> > 
> > Maybe it doesn't hurt for it to perform an extra set of mbm_update()
> > calls on that CPU?
> 
> The extra mbm_update() calls seem ok. An extra call to limbo handler should be ok also.
> One possible issue is the impact on software controller that assumes it is being
> called once per second. Looks like an extra call can be avoided though?
> 
> > 
> > It will then do:
> > 
> > 	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
> > 						   RESCTRL_PICK_ANY_CPU);
> > 	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
> > 
> > This "wrong" domain already has a worker ... Will this just reset the
> > timeout to the new "delay" value? Possibly also to a different CPU?
> 
> queue_delayed_work_on()'s comments mention "Return: %false if @work was
> already on a queue" which I interpret as existing (correct) worker not being
> impacted. I am not familiar with these corner cases though.

Yes. Existing worker is not impacted. Which causes the problem described above.

> Reinette

-Tony
