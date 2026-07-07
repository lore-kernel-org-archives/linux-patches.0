Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3618D42087C
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 23:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783467230; cv=fail; b=Uf8KVXBN0yJmVUUU1m1773TcmD/HGd3DvN4dKRzNX/urOjLtmUHYc1WQwyp04FUpJTciBNMo8KFKx2TrLNCCXsvT446JUW+WOE/bd/NQJ7aO1XwvygipIIiFeoMfvzDeNtBau53JAhXtlhL5Jf8ifGqg56gphpsEeD6NiyJSDt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783467230; c=relaxed/simple;
	bh=evoI9Hc2dDfo/bhGi/v7SwsH6Kl5D1jEtogspF2Sk8k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XTUmv5xb7S51JZ+UbLFYd7B+kHZb50C/7fayxjtjS5Z9MqOwIJcftrU25d3Z013ET0yxij8/B8QbiB1+1yDrRbPyHwwHbVg1yLMxxjelKafOi3BvC3pKZ91NdAyqi5/kyGdgL2egfNX554rZuXA3TwWFl9tCfP+8B2XtgoPv5kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e3G3gtfp; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e3G3gtfp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783467228; x=1815003228;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=evoI9Hc2dDfo/bhGi/v7SwsH6Kl5D1jEtogspF2Sk8k=;
  b=e3G3gtfp08oPoDwFWhgXVaofBT1+imh0EFD5M2yCizHX9Ash6mxCQwJS
   rjAjV7pb34N90ruYgRHEIVM17p3AaQJOysDZ8f93a7Ll4vHdHwiAvab7L
   wxSxiYMGVV9cc7HANN6/dqTSdcw5QwcQQnkidWonAx4CNuTAxLD6sprD2
   CV8htzT8OALHNtG+brkhArXEzWbs436ZJXQGBTnzLcVMy6dm6vH/Kl91v
   RH7llxhvCsU7x3Ec0miZPi1jc1u/1hT1PWeP5h7GL42vWpKi9Tat8nVFV
   e2kRsuHHBeXyCA1HPs8zu6iKHgtu7LN750FlZ3KZTfWA03Du5+1jLc78j
   A==;
X-CSE-ConnectionGUID: J+n+PUt+Qn+jEl2qbc3VUw==
X-CSE-MsgGUID: PYgfYlDKS4OI6dQ3NTYbbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="84182471"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84182471"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 16:33:47 -0700
X-CSE-ConnectionGUID: vdxc0XDRRCKMmuGpT8vQvQ==
X-CSE-MsgGUID: /vAphsPeRKW6TaK2wUgM0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="251462444"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 16:33:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 16:33:47 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 7 Jul 2026 16:33:47 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 16:33:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SaZYwsEBwT/xhzTvGbAgWjez2VVk/0FvuZNv/9a+pB1VmBUPXY0sPOfdiW+pzgRO4/cB2Jhbi0EjWV47rElya97l0pSC0/wfr7fB50ZdXdwgB3eJsGJHhukpcrbK639G8k8bcqknSN0pHnW5/smoiBNYkdtew4RmPjlMitoVBWLy8p2tJfCD2wT/3NV9tc5gyNRBE8T67TThy4169XInVDdjPHlWEW/OMjj9IqUJFASo4qs1hIL4GSTTBHOs0L1S1p+AJYxRQJRQhAlqn7gXna58ZdWAaZWAn0oTBD4ueHpCCkZIMZolsRzNGctOGELIxDg1A19t5VSyIq7YMveG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfjMEfn2mAywsGlfNpcuucKJ2ARCC3luZs2+WKiV27E=;
 b=GDFuUqsmcjRCF3g3/2Ikn0iBCS38Q540+7EE7L/rvNZSufDjasIYtzY+LJavQ8zDRYCpO8B0Zydd1VC4Atm/41k98m6hJV5K2Z79qM92O4iB8CWgsrFR52G2O2MtqUW4kzgc0ePLqSo6Kgio/y+4MVgngkyzat+W3VHoX/ocQDIsnQDCkCzc+7RdDy0o5lit9jOwSrKmNuXVf9QHsFiMAZz3VNSKHDG+XhVKCwznL8fU18pKsMDHuGfKZoLc9/zlRuO67acfV+Ih51TWnswB/Rl+iAslJi6GiLuxyvaqIYEYtWnBGFZBU6PJ1zyJgNP9EmIAXyWSN5pjQFERHVl37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LVTPR11MB9909.namprd11.prod.outlook.com (2603:10b6:408:3c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 23:33:45 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 23:33:44 +0000
Date: Tue, 7 Jul 2026 16:33:41 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v6 08/10] fs/resctrl: Prevent deadlock and use-after-free
 in info file handlers
Message-ID: <ak2M1RZ0EaMzPi7H@agluck-desk3>
References: <cover.1783377598.git.reinette.chatre@intel.com>
 <e5468d05f984f4db2c0fc378562b2c4a9cca301b.1783377598.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e5468d05f984f4db2c0fc378562b2c4a9cca301b.1783377598.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SJ0PR05CA0169.namprd05.prod.outlook.com
 (2603:10b6:a03:339::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LVTPR11MB9909:EE_
X-MS-Office365-Filtering-Correlation-Id: d3e07d09-00e1-42d4-8f84-08dedc802f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|11063799006|4143699003|5023799004|18002099003|6133799003|22082099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: WyTbbXdPKL14GchqHeevkoWipNPDV7toUKSpOsJ9+yTFWxMOMpmmEKrcJ57RuSc60I51XAzETa+kcEfh6YhErXD8zU8IAp/c1noj26Gs+/oTTFc7M9fE4mEqvWGusYG8dgtFG/k3HnDWxColROBUr30h6eV/yqwM5l59Q/oQFwl2Ze52OJK7OjkCfd13FU53b9P4/FghOzK7XDmQJaibWFz6dTYMnmS2scJZhN95IPtkv/PoRyBpL7TJABZ6jsJktabohALWoDTyRgXiX6uOoKhhk2w+GVuEyJ08EMn80A3LhdzElmjPprNo1T0/jDLh4kYU49f8s8aWLknBrkkuI5afmQleg/wTpkVUPhS1QY8rDmIQLdMw5RDquZn4kc+xLL98Q7JsEPPQfz4tgN6FnumBMY9pToV9y6Q3C4TdlVYTvEpe89UWBynxvjMz7VDThcBg91XqcnasiRO17Hg+SkbYQ7BtpNzR+jlWkHuGsQvMio5mIfLPrYurBONOGE8IeUvOsiyXM5v+cje/lW53cauJE3F/BgoauIathfQYTptbBDZqoKm0v7mxDEr8WH2dgwQM+qcghQ88zagWAT/lzVVPjCd40VbZt42ZlTkbxiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(11063799006)(4143699003)(5023799004)(18002099003)(6133799003)(22082099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOQT77PzOREtIjFBcWbrbIru0g5VuZScl+/1lJpw8wybqelqelzZhAI/KuLT?=
 =?us-ascii?Q?LQau9xgTjPpEIR647/flrFIEfzIk/z55sNszPLjyXku0faobBmqOaufT3OeD?=
 =?us-ascii?Q?KZdNZdYltzGK8bGlE9AUXGntnY4SMqIpR3r4mI4Fu16a9yRjfUEqZ7M5roSV?=
 =?us-ascii?Q?AvOrTv9kMdB8VOBcVv60v3cWCPzb6KfKlKoI4H9UkVLE4BXJwfL7N8ikeLwQ?=
 =?us-ascii?Q?Fa7LSR9LVhWddfMJGa2dFVQKC49ebdhneLB2dhpdUsYxUVljlhxW+AveYHyn?=
 =?us-ascii?Q?QFdA6qkWTLOD6pCN2ihGH3sKcfLq9BZdanL16N8KI7CMqhL6cM7/9ocrFL3f?=
 =?us-ascii?Q?G+4/5xDL6TScTIgzmJ29UnP9/RgHo0znn7iV5K1k66X2pvQ/9UZ3gktAz8wq?=
 =?us-ascii?Q?sFwO2dIiCqYXt9ZA9vzN7SECRYrQwQHwuVrIqF/uJiN70XSpzvxIdwP1LpDP?=
 =?us-ascii?Q?/EGl+nKMon+qEK73rzVypki1l06xca+HiuE64ya6qtD0YnjCQoJtaFvDZAxb?=
 =?us-ascii?Q?2YZi2porvS/8oP0w2LpkwRCjRTSib+LmHEHxyAWv3jrRGU0Bl+S3qNikSqj2?=
 =?us-ascii?Q?9I6XlNwCMbu9AJ+a7dgZBtKvO9D6MczTed/gntLL3Bts8cMDgAMsMeqOI+sA?=
 =?us-ascii?Q?fxNXthB8imhSNmFFZMcYu1yE0TexquYs8Rd5QKlNNsjCdhSlGZKcyoDj2wOb?=
 =?us-ascii?Q?yGfuHvjVjmVSCptMIMQkzmISMWuZIflg5fCsatiGtub5iYhE/jz45/JOaj2j?=
 =?us-ascii?Q?XQZtt8e5/F57KJDPLAGejQXlC+Gt7a3/gNUKM1zy6AcPcxSl60YaN0/YzDwH?=
 =?us-ascii?Q?g2OWmENrw9kEsjmIAixlIt4sY09d087TJK3HqId//oFPf776C0KH3EfUhm79?=
 =?us-ascii?Q?FG0ZZLZYNJ/9kr0oQG7YO1KzAPLAFgoQtkNEXkVZ+P5aWR4hn8bp2XvNmulY?=
 =?us-ascii?Q?/QGfwCtmYhorz3RRAcejVSiv5m3c5AuGQ2YuxPRbDSvnoB3MabYI2qS5QLhK?=
 =?us-ascii?Q?bGSvmPSUOO720LNENEPQUjsvsLifarCXIGQ4dpnB3u9EcImg0RzV0T3MOVlu?=
 =?us-ascii?Q?BsufO4jdwO73fg0d5sMPwzzJmA3O9XqCUn4at4tQYIU3hqefDrkxvBtRzHmz?=
 =?us-ascii?Q?wtC6N7S7HdzqQ5+6p94rSC+PI8SdEaWLcdr/F/MSEWBQfpzi8brTHxRhUiW1?=
 =?us-ascii?Q?AL0xm8ieDu54LFcvK8FEc0z0OdIO5xf3P+Zyur1hAbCiZ1GWQkeSPM51Z6R8?=
 =?us-ascii?Q?GGPBAaIcpkD089l88ytlFw8BNfw7cmmMj2Iwyz+oMYhCLZQfsbipMsnqk4yL?=
 =?us-ascii?Q?Pmt3rVjW7HT7xxg+alcM4A2MUYMFSwQe0hDVX0O9DfG75IT+3Ep94A9uS6ol?=
 =?us-ascii?Q?zNqCVIa7bvHd/6/J/5eoRLtWwFHwCz2+xoHWawfv2bcKgZ0mCaaAxYqLJWsp?=
 =?us-ascii?Q?lxRmKOQLOP7qMP/aIo0UzwOZ5ncxh0nXSc4cpARFdqLAN+BuWfM+QnplgjmU?=
 =?us-ascii?Q?+ClN8z5LGewdUg7dEJG68zcSXZOo29dJxopOwfKAswDffd1+P9rlLXl2jbOw?=
 =?us-ascii?Q?/tKsb/9ns73A0W7NBY1xOZKwwWC17Rb/3ycg5hvk6RTGn3U4oLtSgl5tNXvD?=
 =?us-ascii?Q?BGZ8Yq4ZPQvK9z0/ksex0Izx0VQs21cT6tT3dtQAD11oXjDbQMHEp/fZH6Le?=
 =?us-ascii?Q?m49a0pKa75/tKgQcX2EJmdaTZbl4uJfKjNvdA8UOlj0F1K/PnTkbhqxbiSz/?=
 =?us-ascii?Q?siz2FuQN+w=3D=3D?=
X-Exchange-RoutingPolicyChecked: LYtZdQ4nHKjswfdtOp/gI9Ud/SAorJjfOhDpMppX/fCZT+s07xneMzep2vwj5Yb/J34mnhtK54Lj003MKqXojcC8mBOdK0IEMJtitx80um2AGC7NiFrzMYVVkaWBnEtFFz7wl425IClO5sKYzZrPZfR9OQYSOrfgVcE1VTS4WgMkVGE6ZS+sO7NhkciyWemC9zu39dlYjog9jnhCYigOgRDew4oCctk8ptwjtiR4IPQTgvkU/pQ5un+v/IwPUzB9faPpLc2j3uoCs/vA5eVsniRE5Fdb5KeGzyFtaie23v0sV8gkwl9q+z0LRmlkEcd11HbokGrXnukFYFpawaElDQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e07d09-00e1-42d4-8f84-08dedc802f28
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:33:44.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPgjcQPw1/wktMFYPHTaJbHRH7CrnrCj3vCcI4HKXCsVQDXJ2mAGd68jeIrGQHkAfo9yR9Yk85Cpm6ycdi5X4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVTPR11MB9909
X-OriginatorOrg: intel.com

On Mon, Jul 06, 2026 at 03:46:28PM -0700, Reinette Chatre wrote:

Internal AI noted a couple of extra blank lines introduced by this
patch. See below.

> resctrl provides files under the info/ directory to expose global
> configuration and capabilities to userspace. These files are instantiated
> statically during filesystem mount and expose data associated with internal
> schema structures via kernfs private pointers.
> 
> A potential deadlock exists between userspace readers of these info files
> and the unmount filesystem teardown process. Reading an info file invokes
> kernfs which acquires an active reference, after which the handler typically
> attempts to acquire the rdtgroup_mutex. Concurrently, unmounting the
> filesystem holds the rdtgroup_mutex and then attempts to recursively
> remove the info kernfs nodes involving kernfs_drain() which blocks until
> all active references are released. Another problem exists where info files
> might be accessed from an outdated mount if the filesystem is unmounted and
> remounted during a reader's execution, leading to a use-after-free when
> reading the now-deleted private schema data.
> 
> Introduce info_kn_lock() and info_kn_unlock() helpers to coordinate locking
> across all info handlers. These helpers mirror similar logic used by resource
> group handlers by deliberately breaking the kernfs active protection before
> attempting to acquire the rdtgroup_mutex, preventing the deadlock. To guard
> against the vulnerability from rapid mount cycling, info_kn_lock() securely
> walks the parent lineage of the kernfs node under an RCU section to confirm
> the node belongs to the globally active root before permitting the operation
> to proceed. Convert all info file handlers to use this helper and only
> de-reference the schema after it is determined safe to do so.
> 
> Make no attempt to output an error message to last_cmd_status on failure
> since failure implies there is no filesystem with which to display the error
> to user space.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=3
> Assisted-by: GitHub_Copilot:gemini-3.1-pro
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
> Changes since V2:
> - New patch
> 
> Changes since V3:
> - Add Tony's Reviewed-by tag.
> - Changelog grammar fixes.

...

> @@ -1020,9 +1030,15 @@ static int rdt_min_cbm_bits_show(struct kernfs_open_file *of,
>  				 struct seq_file *seq, void *v)
>  {
>  	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
> -	struct rdt_resource *r = s->res;
> +	struct rdt_resource *r;
> +

Extra blank line added here.
>  
> +	if (!info_kn_lock(of->kn))
> +		return -ENOENT;
> +	r = s->res;
>  	seq_printf(seq, "%u\n", r->cache.min_cbm_bits);
> +	info_kn_unlock(of->kn);
> +
>  	return 0;
>  }
>  

...

> @@ -1652,8 +1718,8 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
>  	struct rdt_l3_mon_domain *dom;
>  	bool sep = false;
>  
> -	cpus_read_lock();
> -	mutex_lock(&rdtgroup_mutex);
> +	lockdep_assert_cpus_held();
> +	lockdep_assert_held(&rdtgroup_mutex);
>  
>  	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
>  		if (sep)
> @@ -1670,8 +1736,6 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
>  	}
>  	seq_puts(s, "\n");
>  
> -	mutex_unlock(&rdtgroup_mutex);
> -	cpus_read_unlock();
>  

Extra blank line here after deleting those two lines.

>  	return 0;
>  }

-Tony
