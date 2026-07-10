Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5BB3A7858
	for <patches@lists.linux.dev>; Fri, 10 Jul 2026 20:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717169; cv=fail; b=qqBvfQIJR34AMm9kLRmY+ls0eLcUtY6IxaePOSBhNxCHuiR6TqwRhl77fiBFHp4SdCzX2QqL1Oj1lqvuwQWJ+lkTgow4HxqJFLFOWoSoy4Kb918s2RGCJ7FV2PsJZUWg3yF7fzJP10j2BibmN9bIyw/veP7O8D5vM8ziaqi5M6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717169; c=relaxed/simple;
	bh=tMr+bEcRSZe3NtE7hRfUH3qhfFsLHkesALNq0ZujzPY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bhvidXP3VOhTb9/zIIuf+PvKLw2GQfExLua+bsoixVw+Ahml+37+Z0d7szjCnuwLh2vFQZ87XDBulyNN25sM9sVoCnOVncQlmNgYAiAak7hldXeHrxGPeB4/UvVOc2rHfbJwgfu1nAzXgvpOZqRxmzcgZz/60sX3Q7cF2dqS5JA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A7WJkSnO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A7WJkSnO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783717167; x=1815253167;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tMr+bEcRSZe3NtE7hRfUH3qhfFsLHkesALNq0ZujzPY=;
  b=A7WJkSnOPwhxZO7/1E1dwOciawKgkZaFjrWHYRLWN4dH5JmSIYSahUhU
   byZ/Bhp0yMcV92KX66k549cYeYGA3bd63chWWYocCgtTArQr42hdIprmD
   gEgHF5pLAWSXwP889A3WHGV/o/seYi/mr1gVJlWPaUkXlpIk6NouqoDvq
   vUCPUwaVZBdDBnv/sBq37H9dQ+oQYjU2WcD3M0wBCRSC3meNw8UYmI7mE
   g0Wic7qqhy5uu475Y01fsQXeI4AJU7ycGK9S32tFL7CLiBNAbRi5IlG4U
   5SI+jF+JpMuT/UytLt22hOLayODJOnz6BRz8NhZd2K044DEoupmw69mk/
   g==;
X-CSE-ConnectionGUID: aWcYSwxlRSi4LWKM34XlkA==
X-CSE-MsgGUID: mFSq1hgGRR6srqezqIPOZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84297831"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84297831"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:59:26 -0700
X-CSE-ConnectionGUID: OTh3FYI3SxyjC6i46aaC2w==
X-CSE-MsgGUID: BWF/olT1S7OiomXO9iJ/sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483527"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 13:59:26 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:59:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 13:59:25 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.64) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 13:59:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yhy64+Rrb+BEDxQuS/BcvqI3dtoP1+AtRTO5XxbJcBMREBCdAL/OWm4wP/XAy1YO+HW3bHJRMJNTDyMtTlUtQQIB5Tljoxd+uW4rZ5B44NOlfJK8C7+GUB7hFD295qFjrq3/CLSNusfcXqn+OdnsmW5sg2rH8+7/KYQh8iJsg3UpnoOkvSM5887iC0bTKJdUkZP/EFKqnaUE00/TvhwlhwEQ9PpcpTVEtN4bUK0T5TaNl5rKjwoK+xK7Edvg/qZCBKF1MEN49oighHcIv4cNJnpBnJrFVra4gKAlECR1atG9i+VNIDJ9O8TbYlJNYKnphTc3qKGEPPMxjIO4Z7lcQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pD+LYa0UNx2N4Z2I23M6S/m6XDXIunQtdynPaQMscSY=;
 b=XM44/C06BcG2otnZsaWAvkRAGvYeku0NKwBEAd8qPV2zW/u5+jr3dcGvl1g+oNX5J3Cz3QF45bbDTSEmQpzPnLLGsxeFzqw4m1dv5d0bXGo8rKTIJCw6G/wJs5fGqDGwYPmzbWc5lR/Qh58G4d7Csxx2wGNfLM+u+dA1nSnUD3RtdqFdk8HuuqeBuhVJ3LqDa9CnHFmeRtmmkyY1LQ/HcmtqOfSzDJ/57RYJ66IAOOBr9Nu3yQqVC2y+13ZYS0yeZ9EKD3KYzXufzUJ1zwuOWehi8lls/eF+0YajHqJmIh+Ix0rv/zNmZkXzzBpgJ6Garx8/wqlTQVwXaaJR/o4PHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV3PR11MB8507.namprd11.prod.outlook.com (2603:10b6:408:1b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Fri, 10 Jul
 2026 20:59:21 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 20:59:21 +0000
Date: Fri, 10 Jul 2026 13:59:20 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v9 09/12] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <alFdKPQDc8ljlld0@agluck-desk3>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-10-tony.luck@intel.com>
 <9b83fb5c-302e-4306-946b-cd65351f794e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b83fb5c-302e-4306-946b-cd65351f794e@intel.com>
X-ClientProxiedBy: SJ2PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:a03:505::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV3PR11MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b88b22-c6a5-48e0-1e65-08dedec61dad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|23010399003|376014|56012099006|4143699003|5023799004|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: aI4C+Br4XPZaFy7DOBhefel8fCQLRHSOSNeivzw2IR44XCLzUijGGz1okOyA6HT3YkLeZvIBzfkIP43Q+hZ/4aULsHrJxNvSMB9Z2B+gY4Dl1rwUax2BudNeAKu0xrWYSpFKdGldrartt/42woaEiCvRUg/XZ6dmvF+2M0H1bHgv2uvsHDQ2ZbipfEjNSQaWXFyVH9GD5khA7HQZ+dqQD2hcbrIg7ZJ6ByM9SXN9lDQWKir9V4FC8Jx6zDndoENXdZt1Wz+7bWF4TpHXUKgNPZyx/emFLIok7A8QUqfP91DioWHceCWZ2c/uDutjhaqEWJ67uuJfqHpJbltqwuktvQ0GnZQ7CLgkYzdEfUiQ2jzVt8yE1rG/HXKCkQUuaENNtyv8sn+QgeF44ErOxbSwWC13jSgq6UtJJErSaFTjjO80vg7lcZSDXurpQfG1E1W3bSl5MmAgFQA63yFWQHaPHhm25bPzuPLpL4AZNwpojeix//oBGM17V1HfZGI6DTaz/JkWzN4DtuGn5mR645S7b7B/TQx4GGQwOvTBvd0OQFPBDFrvY+afDWC1++Ettb66YcKQREGswuNVRibBsoskTEn82K21UZawIKHbV3ldt0REFMT0iKp/GFs9TPApseNq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(23010399003)(376014)(56012099006)(4143699003)(5023799004)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SaTPXvD8MBYrJyS7p4KSxD2NMttPSdvwg9uFA8545ZGrMNg11J9nupttIqKi?=
 =?us-ascii?Q?J7HVdmEWMqiYmqemN+e6M60Anc9FudnqzWZ+5jO2DmM7yS60oA92bENz9euq?=
 =?us-ascii?Q?vIavAY1PolFCMf9roNz1ZGqffEFv+qOYuJPFUIgx/54dw5+Z+FOtYCmrJ5XO?=
 =?us-ascii?Q?3p3iI37xORrHSZKCgapSYGC0EK2HeWukYlh1hw8bzGwvkoPC5MuAShZbBpXd?=
 =?us-ascii?Q?Syo10+RokbAtZwsLJgnrhbeXNJSp0kyh1cKD3LVZub8YOi/1uZ+sjTsZuVpX?=
 =?us-ascii?Q?/24TUQee47JbDVHtVVbADUjaWEVDahsIDld9vn+GbbLEhwk9nmNeSRJ/uR3e?=
 =?us-ascii?Q?jtNJTpksHFTaHYko8i2/xtSpb9iq5Zm4OLOgZ1i4vxrOrUpWuZHTW2UH7O3V?=
 =?us-ascii?Q?TGO5HHn2+1ZMJTpm0J5feL5m7f5LlYbKeIo81KfJaXivjiKHn1BNp0gH7T6K?=
 =?us-ascii?Q?9ERmxBv2msvVm4J4BjBvmjMZ6X94c7as7MtMLQHbu/C3iwnMhmExR2/Vmw3x?=
 =?us-ascii?Q?IA1k7oM5WRUXk7HElGoQ2CCMftN85G+QB4AH3BUFaGPSu9gS6/mRqNnHveLp?=
 =?us-ascii?Q?IFmCnu/AxJlb8NXOgOnFbG30JD8w/5HvscLwsyE4wS8ja6lE8rSPUAY4dj6r?=
 =?us-ascii?Q?hqZcXnZlI6rZr5Wzcjk7buK0m7nqfb+gUvdI/NhnvdV54IycA1r/ZTF2sym9?=
 =?us-ascii?Q?KXZXkdHWTt4Wyf6eTbhaJ+YPnYM+VseQli6AAO22zRWK/NwDDgaQYuUUUyW8?=
 =?us-ascii?Q?YRU9/NRJp0vIIX+64v8r5w+Ohql+Xy7QoZX2bfm8eBEqQ4KU3NICUuJAO/Hl?=
 =?us-ascii?Q?vGdFGh5rMYwwJVqCIj08xtw/QzL+ctAzVe7ZAfJn/H4MHvzjn8+QdS9raEjq?=
 =?us-ascii?Q?B5mkAwko4RVSxWY6fS0vIzdZOM9Eg9WS+5Loj2TSaRFnbs3rWvEiJFkatjrg?=
 =?us-ascii?Q?RGMrncA+JA7mbk9daTFjXKE76CDd00tkpRbEQEk375bsrbVv+aMtnXo/w+9P?=
 =?us-ascii?Q?LNfmD3cmBhfG7abwKjhduzwLyZDAGH9bZe/HC0369VVeA9g/7YMGauPWfoJH?=
 =?us-ascii?Q?Ox6tX3Tgrdw+sRqgWqoHPOaeF7fwd9wANgjqtll/8QNRqRgDHZhu36WilS4c?=
 =?us-ascii?Q?odL4Lcck2f0trlUPkcTaPM3yuH1nYVXmeWnPlliuBV57iH8jnsSCw6XFgveI?=
 =?us-ascii?Q?pCycr04jmQRfG1E+1BCCvkvWRUriCYU0sTHBWQZw6RevhVL3Mi863j9VxZvy?=
 =?us-ascii?Q?WprsOL58fxq6AA+rlLG6u/5Ux2CfqGQEbS4z1qjhI8QdPPVpOI556R8MDA2R?=
 =?us-ascii?Q?JLpUrxf7TEfM8nsU3YqafUpgaJ7TVWB5r9mEiEfpyRefwLioemGgyJT92lBM?=
 =?us-ascii?Q?YHZrq8WkJmlb3Np3jAXENHpvbFlhb0AJczqxq4AcTCdHZyFNAfPwmgoJMtmA?=
 =?us-ascii?Q?Me4TdTAmcX2LlQxJWJ1UqJU3wSb9q9/jNrrDpR8Ttf5ZhVD2RdzELQEFCaCR?=
 =?us-ascii?Q?kTJfbV7S6JPtwWLp7AfIwsigHuSEJvyhuglsSdg6yqMpBK0s4yYLwjyHwSWp?=
 =?us-ascii?Q?PoRbtx+5ZPIzqYODSad5Dg8emR0X3qZdFXskhcMYh2pXHA3qU1o4tGcqhID9?=
 =?us-ascii?Q?5/Jk8p/IPFlwei2P4EkvHLVa7QPQAbejf2/EtkB3330hpdSRmLyyfc9eOU5p?=
 =?us-ascii?Q?mR7Mm5YCaZlcZhqpk8Aoxy9NiBKF49bdNnWftbDfrhcoZMbpQoBIWbdhahUP?=
 =?us-ascii?Q?aFnVu56bOw=3D=3D?=
X-Exchange-RoutingPolicyChecked: nUgNdGHz0ID1BSTyVvb0wK089OqPnjrqG2xHkWQBYaak9vIie4FdW8zzFMLDorTeAbQTljAaikVm+bUnGoOIyLX8xR7RPmZsakDLy7UJafwtSJl5NiX2RIASmaYBACB+HoRRRrTyBztgSItddFnQPtJnf1Pq2GydtgiIYkJ+Q07EIVkjmA7WAgNxKUqJwjJu/vPlMzbYH6LcZe086Qt7DFWUPmOz6Y0LCV2aw8XTUxLBqVr5kpI7mDlphlud+CsVrv90KJ8b4zPwsH2q7z6wN7VuJI3g3nDSaCKuXh7C1N7fvjtaX2I/+2kdv7iHTlTdmmPNSwT7N3Zz2dYRrzszHw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b88b22-c6a5-48e0-1e65-08dedec61dad
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 20:59:21.7375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JsVaGNffbxilYHR/TUALNREj23er2V0oUhteIZHJ1MBWnBmmgh0n5o8A0zleRQWjo2pfwMQIRSoLIf1G5GtcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8507
X-OriginatorOrg: intel.com

On Wed, Jul 08, 2026 at 03:52:36PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 7/1/26 2:35 PM, Tony Luck wrote:
> > resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> > logically independent and should be loadable modules.  Switch AET to use the
> > function-pointer registration API instead of direct link-time references to
> > PMT symbols.
> > 
> > Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> > by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> > resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> > the filesystem is not mounted.
> > 
> > Remove intel_aet_exit because all cleanup now happens in the unmount path.
> 
> intel_aet_exit -> intel_aet_exit()
> 
> At first glance this change does not seem symmetrical since it introduces
> the new enumeration and cleanup calls but does not call the cleanup call that
> appears as though it keeps a reference to the module. I think it will help to
> highlight that the previous exit code was not called anyway and at this point
> the module is still required to be built in so there is no actual reference taken.

Sure, will update.

> > 
> > Note that the Linux file system code does not serialize calls to
> > fs_context_operations::get_tree(), so there may be arbitrarily many parallel
> > calls if users invoke mount(2) multiple times.
> > 
> > Use "pmt_in_use" to detect nested mount attempts.
> > 
> > event_group::num_rmid may be reset (reduced) during enumeration. This is
> > not worth resetting on unmount because the same reduction would occur on
> > each subsequent mount.
> 
> If event_group::num_rmid gets a mention, should rdt_resource::resctrl_mon::num_rmid also?

Ok.
> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > --
> > v9:
> > 	Drop broken atomic ops introduced in v8
> > 	Check pmt_in_use in intel_aet_pre_mount() to detect nested
> > 	mount flow.
> > ---
> >  include/linux/resctrl.h                 |  6 +++
> >  arch/x86/kernel/cpu/resctrl/internal.h  | 23 ++++++++--
> >  arch/x86/kernel/cpu/resctrl/core.c      | 25 +++++++++--
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 +++++++++++++++++++++----
> >  drivers/resctrl/mpam_resctrl.c          |  4 ++
> >  5 files changed, 101 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index e1501ee72d28..4dc41dc99dc2 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -564,6 +564,12 @@ void resctrl_offline_cpu(unsigned int cpu);
> >   */
> >  void resctrl_arch_pre_mount(void);
> >  
> > +/*
> > + * Architecture hook called when mount fails, or on unmount.
> > + * No locks are held.
> > + */
> > +void resctrl_arch_unmount(void);
> > +
> >  /**
> >   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
> >   *			      for this resource and domain.
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index e3cfa0c10e92..a891017f69ec 100644
> > --- a/arch/x86/kernel/cpu/resctrl/internal.h
> > +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> > @@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
> >  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
> >  
> >  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> > -bool intel_aet_get_events(void);
> > -void __exit intel_aet_exit(void);
> > +bool intel_aet_pre_mount(void);
> > +void intel_aet_unmount(void);
> >  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
> >  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
> >  				struct list_head *add_pos);
> >  bool intel_handle_aet_option(bool force_off, char *tok);
> >  #else
> > -static inline bool intel_aet_get_events(void) { return false; }
> > -static inline void __exit intel_aet_exit(void) { }
> > +static inline bool intel_aet_pre_mount(void) { return false; }
> > +static inline void intel_aet_unmount(void) { }
> >  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
> >  {
> >  	return -EINVAL;
> > @@ -253,4 +253,19 @@ static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resour
> >  static inline bool intel_handle_aet_option(bool force_off, char *tok) { return false; }
> >  #endif
> >  
> > +#ifdef CONFIG_INTEL_PMT_TELEMETRY_MODULE
> > +static inline bool intel_aet_try_module_get(struct module *mod)
> > +{
> > +	return try_module_get(mod);
> > +}
> > +
> > +static inline void intel_aet_module_put(struct module *mod)
> > +{
> > +	module_put(mod);
> > +}
> > +#else
> > +static inline bool intel_aet_try_module_get(struct module *mod) { return true; }
> > +static inline void intel_aet_module_put(struct module *mod) { }
> > +#endif
> 
> 
> Trying to look back to how the above ended up like this I find:
> https://lore.kernel.org/lkml/SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com/
> that states:
> 	pmt_module is NULL if CONFIG_INTEL_PMT_TELEMETRY=y ... i.e. built-in to the kernel.
> 
> 	In that case it obviously can't go away, and doesn't need module_get()/module_put().
> 	There's no special case for this. try_module_get() takes a fault on NULL dereference.
> 	...
> 
> Taking a closer look at try_module_get() I do not see it attempting to dereference
> a NULL parameter but instead it returns true in this case which makes the above unnecessary?
> What am I missing?

I don't know. I definitely got a NULL dereference when I did a test with
the PMT code built-in. But it looks like I mis-diagnosed the issue. You
are right the try_module_get() and module_put() have special cases to
handle a NULL argument.

I will revisit.

> > +
> >  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 3169441a2d40..3ef620d8e0c8 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -16,10 +16,12 @@
> >  
> >  #define pr_fmt(fmt)	"resctrl: " fmt
> >  
> > +#include <linux/cleanup.h>
> >  #include <linux/cpu.h>
> >  #include <linux/slab.h>
> >  #include <linux/err.h>
> >  #include <linux/cpuhotplug.h>
> > +#include <linux/mutex.h>
> >  
> >  #include <asm/cpu_device_id.h>
> >  #include <asm/cpuid/api.h>
> > @@ -798,7 +800,7 @@ void resctrl_arch_pre_mount(void)
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >  	int cpu;
> >  
> > -	if (!intel_aet_get_events())
> > +	if (!intel_aet_pre_mount())
> >  		return;
> >  
> >  	/*
> > @@ -814,6 +816,25 @@ void resctrl_arch_pre_mount(void)
> >  	cpus_read_unlock();
> >  }
> >  
> > +void resctrl_arch_unmount(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> > +	int cpu;
> > +
> > +	intel_aet_unmount();
> > +
> > +	if (!r->mon_capable)
> > +		return;
> 
> Could the mon_capable check be moved before intel_aet_unmount()?

Yes. Will move.

> > +
> > +	cpus_read_lock();
> > +	mutex_lock(&domain_list_lock);
> > +	for_each_online_cpu(cpu)
> > +		domain_remove_cpu_mon(cpu, r);
> > +	r->mon_capable = false;
> > +	mutex_unlock(&domain_list_lock);
> > +	cpus_read_unlock();
> > +}
> > +
> >  enum {
> >  	RDT_FLAG_CMT,
> >  	RDT_FLAG_MBM_TOTAL,
> > @@ -1187,8 +1208,6 @@ late_initcall(resctrl_arch_late_init);
> >  
> >  static void __exit resctrl_arch_exit(void)
> >  {
> > -	intel_aet_exit();
> > -
> >  	cpuhp_remove_state(rdt_online);
> >  
> >  	resctrl_exit();
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index c26bd813e057..c2e27ce52248 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -25,8 +25,8 @@
> >  #include <linux/intel_vsec.h>
> >  #include <linux/io.h>
> >  #include <linux/minmax.h>
> > -#include <linux/mutex.h>
> >  #include <linux/module.h>
> > +#include <linux/mutex.h>
> >  #include <linux/printk.h>
> >  #include <linux/rculist.h>
> >  #include <linux/rcupdate.h>
> 
> This can be squashed with earlier patch.

OK. Will do.

> > @@ -310,7 +310,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
> >   * struct pmt_feature_group to indicate that its events are successfully
> >   * enabled.
> >   */
> > -bool intel_aet_get_events(void)
> > +static bool aet_get_events(void)
> >  {
> >  	struct pmt_feature_group *p;
> >  	enum pmt_feature_id pfid;
> > @@ -319,14 +319,14 @@ bool intel_aet_get_events(void)
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
> > @@ -359,16 +359,58 @@ void intel_aet_unregister_enumeration(void)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
> >  
> > -void __exit intel_aet_exit(void)
> > +/*
> > + * Track whether pmt_telemetry enumeration succeeded during mount to
> > + * detect nested mount attempts and for use during unmount.
> > + */
> > +static bool pmt_in_use;
> > +
> > +bool intel_aet_pre_mount(void)
> > +{
> > +	bool ret;
> > +
> > +	guard(mutex)(&aet_register_lock);
> > +
> > +	/* Nested mount attempt. File system code will return -EBUSY */
> > +	if (pmt_in_use)
> > +		return false;
> > +
> > +	if (!get_feature || !put_feature)
> > +		return false;
> > +
> > +	if (!intel_aet_try_module_get(pmt_module))
> > +		return false;
> > +
> > +	ret = aet_get_events();
> > +
> > +	if (!ret)
> > +		intel_aet_module_put(pmt_module);
> > +	else
> > +		pmt_in_use = true;
> > +
> > +	return ret;
> > +}
> > +
> > +void intel_aet_unmount(void)
> >  {
> >  	struct event_group **peg;
> >  
> > +	guard(mutex)(&aet_register_lock);
> > +	if (!pmt_in_use)
> > +		return;
> > +
> >  	for_each_event_group(peg) {
> > -		if ((*peg)->pfg) {
> > -			intel_pmt_put_feature_group((*peg)->pfg);
> > -			(*peg)->pfg = NULL;
> > +		struct event_group *e = *peg;
> > +
> > +		if (e->pfg) {
> > +			for (int j = 0; j < e->num_events; j++)
> > +				resctrl_disable_mon_event(e->evts[j].id);
> > +			put_feature(e->pfg);
> > +			e->pfg = NULL;
> >  		}
> >  	}
> > +	intel_aet_module_put(pmt_module);
> > +	pmt_in_use = false;
> >  }
> >  
> >  #define DATA_VALID	BIT_ULL(63)
> > diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> > index 7079870ca894..5859cc0f5e37 100644
> > --- a/drivers/resctrl/mpam_resctrl.c
> > +++ b/drivers/resctrl/mpam_resctrl.c
> > @@ -162,6 +162,10 @@ void resctrl_arch_pre_mount(void)
> >  {
> >  }
> >  
> > +void resctrl_arch_unmount(void)
> > +{
> > +}
> > +
> >  bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
> >  {
> >  	return mpam_resctrl_controls[rid].cdp_enabled;
> 
> Reinette

-Tony
