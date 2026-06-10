Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EA1F936
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 00:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050099; cv=fail; b=TKJIJgWDAmulbLaeUL7f+JENI5fs8irPpOq8b4gVa3YSibEdY+anYGRWrsMc1wOLlHIhe6xX8Rj6/tubfBwpXvMsPl9d3w0WVNco69tT3/9yeg7Xd5uP0vXAgdAgi1AlcTe6rKyrQJDO92caUAbbWyybiC2hC4qvX2CelSAsbbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050099; c=relaxed/simple;
	bh=0/EDqxuz8qtHt0KqoK1JuYrMNKVlPMgYYVce2mzPfw0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bJEeXNUOo8KorLaGyCVo1KY21ZZ2xU5RrJaybOg5dm1F0/ZrV2UqA+O5L5IjyhYzD7Pj2U3zaJa6E5bUH3SFPyn2Jp69DMqZ8h2j0YwzM1fwUOqR0Vf1WTXzFpwPC2Z59u7kyRcU3vzCX+ZmfUgPr5p3Kz+r2nGMjXMD9K9cL7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SFpJU1D0; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SFpJU1D0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781050097; x=1812586097;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0/EDqxuz8qtHt0KqoK1JuYrMNKVlPMgYYVce2mzPfw0=;
  b=SFpJU1D02bd8/+iqBz4pWBzFtq8yL6gp0DIfJWA/ww5HLO7r2701d9j8
   oEGivzjf/rcSon1MXICoMjxC2XVOI90L78t9sWZ+cKXAqKCNeGOKwisaI
   N8f/62y8g+o/0UoRbq8WhHL/miM3sXnsM3L/YCidu7TA0VuWTXARzxirv
   1b/ErwT9iX24WDXYDpufkP6ONSoEJq4tQ1Y85Tvc4ebP8JZCRb1PmBcwg
   AHJ3uElhA+SCXXh6W9zQSG4M5aulT7K85sAvU/OrsZinPyGMQWqj40UEv
   BmoQl7kRruu/cqh8R+00gfRVFzDux5iiDO0UG1/G6E7wmnL8uD9ypIvkP
   Q==;
X-CSE-ConnectionGUID: J0HW4AyjQDKuoexHCibmBQ==
X-CSE-MsgGUID: eq//apAsRfuWzEVF37mrYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="85681290"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="85681290"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 17:08:16 -0700
X-CSE-ConnectionGUID: LepupPsgR2C3dgKhantEEg==
X-CSE-MsgGUID: lmt2IuGTTciP3cObLGn2Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="241574772"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 17:08:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 17:08:13 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 17:08:13 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 17:08:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RHiNuKvprcbOUqfrjE3C7ngGWvpT0qDjuL3m/PhmxD87kVf5RKbvWPpFWYPBolXaXzl0beaYBtQ+UOcDQ9bX6NffPeByL9I/3pN6ot0kOCwN+2nkuK+orS/akyLEujYBVvTmm/f3Jsh9iGA2FC+q811lYpJbu8ahFkB89+QAsr7DsHnnKKDhByeX+MLfc20ZKWCoHLxKmIYFWPGg3COqDbqU6eG7Qxhy5bDKWfj8VsepHDCw0G2nsRq3VzkZggEj0soA9U3UEwZp+BjN5SMoMvBTRGu6J81MY8Ek+dx+Ekf/Hcl+YWxcYwsdVQgKLLEyD+fa0Cy111AshM3uvEjM1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCxutSIDQplgC+Jb2+ESwxhVttrLnmp1q4q2gO3NuRQ=;
 b=Kq0bv1mj3v79b4MIWYyu5Sa5MbEMxMW4B/zRNp784x994eVfTn5yVoMZgTOa6Op+O6I9NN/klLxLWusQAwQPuD7zJHX5d7sUkUPNr5JpLQXczckw3az5zFE7mACYIbq0ZbivxIqIznN7nYF4jXTHpuR8Z2QMqUyIzOg2TZ3Kbzddr0Rx432iB6zfBWLMTkUTKejDcHa7jvF7YsZ2yEspCXsHPjj9kkAIsqLEYUKcD+pXrnxayhrori+AbECxCH57fYi9dsPW/q7o6vsuvta7R5J//fjem1iPv9odS8v6xzvRLHe1rTNszKDd4iMdvdaDDZzz2x++aIEsiGV03KS2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA3PR11MB7554.namprd11.prod.outlook.com (2603:10b6:806:315::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 00:08:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 00:08:10 +0000
Date: Tue, 9 Jun 2026 17:08:07 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <aiiq55x6fs2ddS91@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
X-ClientProxiedBy: BY5PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA3PR11MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 5afc3556-4e4d-49a7-0327-08dec6845b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|6133799003|56012099006|4143699003|22082099003|18002099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info: 0nZy25+Ib5Zi6f8FRRO12u08ygZbPvKAwH5fl6l066OK3tXdEQy3j5/gScyNLFEwCB7vU1Gk2TQ0MWiWK4Lu0+g5q+M/g6d9+d+ExZtYJ5nVu7KZ2pEklGgg7Qf2RSuiGul5x+EPRG4APFcH9mdlkbZt3+Fg7kinbDzKDw0Uu2X2d/ZeE5OqeX9npvpY74k7Sou2XwSj1XcwhDKfZTfCgGiE4Inimhh7ytSzKM4jeOUvebfKwrbygceZdvsQlIdJn0m6I3Byh6NHmucH+n5lUfPqtLWvGvGtWExPrnCYiaBBYrzkbsLMCPsZUCvHTZLs6uDr2rVsO4phUV103v0hPhlLmnl/zvpiQwl3nWiN9aOmyk9YKkceCiSJchjgSro19yQpDkx9hC14qAPkpkWQuQm4cskrpcvjmS5nq3wqhVSLxvvYWTlmoXCh1C5EQSLmKc7sk2N95iSsv48qwktnTt5H4ijrFCnkVZSw7DKZGLF+dwjz60+0zPP68ZPFk1ac9ChzN7g3HUa0X7k2AsSal+diw6Sc2oIiLgHlyPBplzPzyHia52VqB+gfQapkFE6fO7jBWohAKYMBu6UpasCv4Ozfz13SwTAsPX6BpYHFYb5tOIYPCLkJkOuJ4SV4sYpetX3yJWkqJ61UXFW1/wwWbIxKa23K+XjrEHxiDNQPS8hfs8j6xZ5VTWVqPIvAOGGo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(6133799003)(56012099006)(4143699003)(22082099003)(18002099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sc8OwJNnyKGRpigPR8DFwj3AuBk0uyDGWrzhe+rRYFmc0PoUedII0AzDw5ff?=
 =?us-ascii?Q?iy0CN2ov3M7phyxqSaDXo5N+mbwmJABZu1iKTdf/W8QBOoCyujrckhJVaBvq?=
 =?us-ascii?Q?eykjIarYeOOSk1OXMqMqxSlH4eQSQJMzWZCaBNwXPOYqTS7vt9C1qwNYtxqx?=
 =?us-ascii?Q?uE3BXvS7IBUp31EWZz0NTJZERtburd4E3xdahTocG7dEPPZ1BgDsx6mqetgV?=
 =?us-ascii?Q?kBeTALxq4A7FKNRwqZ0UMdK29FVKRtv4jSQcrdJcyOz28lYPZxit5fRCMRJb?=
 =?us-ascii?Q?T6GTKzj1nazkRV369MSqOl9nq0UhGzCeMiLOiKXhEFaaVP3wFhGXwHFCVtB7?=
 =?us-ascii?Q?jtSYFbx9wQBbB5ObRpeem6Mbd/gVe4GXKcABA8eHwfleklIRM1fpZjJZuQqz?=
 =?us-ascii?Q?1g6ep4To4fCMrGOquIuQmoddlkoYXGQRnHJvJZS4lDtYtFEeSa/A0ldCjkhs?=
 =?us-ascii?Q?qjwgMyDI1q9OKvb2LIoReAxppN5BPKS7sXVjEW85tMlDuJJCEORQBjdS1MS7?=
 =?us-ascii?Q?nfPumEKfwqbDRh5n4ih4UPRd8j0ZA0r5hwEBlO9M3xeVzp2tPttlLwjeUq02?=
 =?us-ascii?Q?975QKKnYtQCJbFCXvkJZOYEjnARZlATMU4HC2g56AUvxZ6m9yVceDCcC9TEl?=
 =?us-ascii?Q?94JkqSj4QznzG9j54MTY6E6B12YHqvKATMOIl12r5ocoL5HGjdlZGJtcmgEB?=
 =?us-ascii?Q?UkVm5SzofDzWIj1kplUPF8Mwt7jInAJfWDlKtmHA2ASbzBjyAl60+COFl8q/?=
 =?us-ascii?Q?LmL3u9fzdNcI86lShb6XoDQbII9Pr+JtYeyqkS5+QMPqmMmbbD+GBO7NRyDd?=
 =?us-ascii?Q?uVqCgrjqA3/sVTQWYQKoX+fdZvwraRhiqXI/JcV6MPnmdO/XVE/1sJSW2eVv?=
 =?us-ascii?Q?flUzFNFAMxzNxSZbj6iKYRf/D4F5kx9TQmmyXAYkMtPREqcIclOu2W4I2aC/?=
 =?us-ascii?Q?rHHrC2y5dYEI1RCtw13Pvg19Wl7+9MFVh3Otrk4audxl3eGK36sS+/GTKdLm?=
 =?us-ascii?Q?fqVvrmIwq5CYlodhObm8MXyy8sx8VB0WaBCiegQHRn21YD8f0NFOr9HqNEAo?=
 =?us-ascii?Q?/5ZyLHEdzHuzl05TbIH6ikGFP8Ni+6qGHQYijSELC+fh/XbbyiE4oXbjdMOq?=
 =?us-ascii?Q?+b1mA1SaYxN9fEJrXBrtWSnIwMzecp/rZDr3Zz3idO561WCNZ+qjMoyq5nV/?=
 =?us-ascii?Q?Kb6ubX127D7KNstUWKCDOl/95rmnwWI74QA1wI7dvafj9q8VVuTW4zvcSKon?=
 =?us-ascii?Q?WTeAO8QylHyDtBXWrMZpo95RpNfkTGzkwyIb3ex+WE0lG+64rzIQ4EKk3i3L?=
 =?us-ascii?Q?6WoUJNuCxD/lejCZlWV5GER9Tz97tGwsnXMk/r9h79qsHRxSkgr/0lpmWmeF?=
 =?us-ascii?Q?31RUloa2kpnke8Mw9DWbTXyFsSzmN3KHKhWXbSrSfT1mge2Myxj/i6W9w211?=
 =?us-ascii?Q?RhKWPRNC8TMqcGdD7qcyalGvWVgfyz0Kc3WL80CPHFLBEW3m1+FN5Jbhc7fj?=
 =?us-ascii?Q?9gNaXge/A1sNX4jVvtMIbLBRCTPsJChzm3byBpwe+/Lj0BNLyP2NjhcJUg+D?=
 =?us-ascii?Q?c0mvNpDt4xMuPMpbYTd2euXrhNhBVaPmMtZynfDyGXHpgtOXlgyEQhtRZ0ol?=
 =?us-ascii?Q?Lun71jJZ8eLlwx+Nh3MOuUBWtAZ6SG5xwCyFxNAykC+FifxiHSN7BBQsj5L6?=
 =?us-ascii?Q?1hcKjKF7blIB+Ld71qt+W8hAGtbL7fBJtTDCBHFpVZFhjRpyrTS4sV3gyn9x?=
 =?us-ascii?Q?FEpWVw8lAA=3D=3D?=
X-Exchange-RoutingPolicyChecked: iKkSjBOT4Z/UMBdI8dbgprXO3sxlrS88fRPuKE4f3ooPOaBFt8JxsdByPnW7nx3jLkbB3V4Zb9i+CHSWhommBQ+IWLA5/1V7BMbBjbr2P7msnvTAKquitVs0Pu0L9chpYUjLBkQWea/XL0c5zYwOotrgyQDeiOb/3tgszTIR011TNFu1aNIYrRhQjEXfSIwAYgqe4an/3UzUctOSJ7KXh45mR0jcpZCMwJxVFcuPbJoyZ01Gr1HpexHZTTjdR8CrlTFwgVMxSWCVYMCumb0JJLaT0y0PDbMByIbIKuKKeCKVXLYBkEdOHXeMp6c0VG1poyB3Jyi5iXrcDSNp5I81/g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afc3556-4e4d-49a7-0327-08dec6845b0d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 00:08:10.1150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0JeK2PhjYpGZx6wIlCkEyx+ltqIaODZoTkzW68hbjjeVHqTXbgL9I5s9BvGSH5qtQBmtJfJ0KH0K+Hz/C68NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7554
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> Regarding a subject prefix ... We do not yet have a precedent for prefix
> when MPAM, x86 and fs is changed so this series may indeed have the
> opportunity to set that precedent. When doing so, please be consistent.
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> > logically independent and should be loadable modules.  Switch AET to use
> > the function-pointer registration API (introduced in the preceding patch)
> 
> Please drop "(introduced in the preceding patch)" since patches may not
> always keep this series's order once merged.

OK

> 
> > instead of direct link-time references to PMT symbols.
> > 
> > Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> > by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> > resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> > the filesystem is not mounted.
> > 
> > Remove intel_aet_exit because all cleanup now happens in the unmount path.
> > 
> > Note that the Linux file system code does not serialize calls to
> > fs_context_operations::get_tree(), so there may be arbitrarily many
> > parallel calls if users invoke mount(2) multiple times.
> > 
> > Add locking and state (resctrl_arch_mount_entries) to avoid repeated
> > enumeration on nested mount requests from file system code (which will be
> > failed with -EBUSY status).
> > 
> > event_group::num_rmid may be reset (reduced) during enumeration. This is
> > not worth resetting on unmount because the same reduction would occur on
> > each subsequent mount.
> 
> Even more important to ensure that PMT is done with its enumeration when
> AET enumeration starts?

Would be nice, but I still don't know a way to make that happen.

> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  include/linux/resctrl.h                 |  3 ++
> >  arch/x86/kernel/cpu/resctrl/internal.h  |  8 ++--
> >  arch/x86/kernel/cpu/resctrl/core.c      | 41 +++++++++++++++++--
> >  arch/x86/kernel/cpu/resctrl/intel_aet.c | 52 ++++++++++++++++++++++---
> >  drivers/resctrl/mpam_resctrl.c          |  4 ++
> >  5 files changed, 95 insertions(+), 13 deletions(-)
> > 
> > diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> > index 3705f0214fa6..9534d42e0c57 100644
> > --- a/include/linux/resctrl.h
> > +++ b/include/linux/resctrl.h
> > @@ -557,6 +557,9 @@ void resctrl_offline_cpu(unsigned int cpu);
> >   */
> >  void resctrl_arch_pre_mount(void);
> >  
> > +/* Called to report unmount. */
> > +void resctrl_arch_unmount(void);
> > +
> >  /**
> >   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
> >   *			      for this resource and domain.
> > diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> > index 3b09cfe9a046..017a19143ec9 100644
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
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 934492c7e643..9336299b9647 100644
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
> >  #include <asm/msr.h>
> > @@ -776,12 +778,20 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
> >  	return 0;
> >  }
> >  
> > +static DEFINE_MUTEX(resctrl_arch_mount_lock);
> 
> Please document what this mutex protects.

It looks like I'm only protecting resctrl_arch_mount_entries, but I hold
the mutex for much longer. Perhaps this could just be some atomic
operations on resctrl_arch_mount_entries? I'll think about this some
more.

> 
> > +static int resctrl_arch_mount_entries;
> > +
> >  void resctrl_arch_pre_mount(void)
> >  {
> >  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> >  	int cpu;
> >  
> > -	if (!intel_aet_get_events())
> > +	guard(mutex)(&resctrl_arch_mount_lock);
> > +
> > +	if (++resctrl_arch_mount_entries > 1)
> > +		return;
> > +
> > +	if (!intel_aet_pre_mount())
> >  		return;
> >  
> >  	/*
> > @@ -798,6 +808,33 @@ void resctrl_arch_pre_mount(void)
> >  	cpus_read_unlock();
> >  }
> >  
> > +void resctrl_arch_unmount(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> > +	int cpu;
> > +
> > +	guard(mutex)(&resctrl_arch_mount_lock);
> > +
> > +	if (--resctrl_arch_mount_entries > 0)
> > +		return;
> > +
> > +	WARN_ON(resctrl_arch_mount_entries < 0);
> > +
> > +	intel_aet_unmount();
> > +
> > +	if (!r->mon_capable)
> > +		return;
> > +
> > +	cpus_read_lock();
> > +	mutex_lock(&domain_list_lock);
> > +	for_each_online_cpu(cpu)
> > +		domain_remove_cpu_mon(cpu, r);
> > +	r->mon_capable = false;
> > +	rdt_mon_feature_count--;
> > +	mutex_unlock(&domain_list_lock);
> > +	cpus_read_unlock();
> > +}
> > +
> >  enum {
> >  	RDT_FLAG_CMT,
> >  	RDT_FLAG_MBM_TOTAL,
> > @@ -1174,8 +1211,6 @@ late_initcall(resctrl_arch_late_init);
> >  
> >  static void __exit resctrl_arch_exit(void)
> >  {
> > -	intel_aet_exit();
> > -
> >  	cpuhp_remove_state(rdt_online);
> >  
> >  	resctrl_exit();
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index db671725acbb..74c34593876b 100644
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
> > @@ -308,7 +308,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
> >   * struct pmt_feature_group to indicate that its events are successfully
> >   * enabled.
> >   */
> > -bool intel_aet_get_events(void)
> > +static bool aet_get_events(void)
> >  {
> >  	struct pmt_feature_group *p;
> >  	enum pmt_feature_id pfid;
> > @@ -317,14 +317,14 @@ bool intel_aet_get_events(void)
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
> > @@ -353,16 +353,56 @@ void intel_aet_unregister_enumeration(void)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
> >  
> > -void __exit intel_aet_exit(void)
> > +/*
> > + * The pmt_telemetry module may not be loaded when the resctrl file system
> 
> Is this accurate? What prevents pmt_telemetry module from being loaded when
> resctrl file system is mounted?

Comment isn't clear. The issue is when pmt_telemetry isn't loaded during
the mount operation, but is loaded later while the file system is
mounted. On unmount "pmt_module" is set, but should not get a
module_put() because no "get" was done at mount time.

I'll rewrite to make this clear.
> 
> > + * is mounted. Keep track of whether a hold was placed on the module to know
> > + * whether to release it during unmount.
> > + */
> > +static bool have_pmt_hold;
> > +
> > +bool intel_aet_pre_mount(void)
> > +{
> > +	bool ret;
> > +
> > +	guard(mutex)(&aet_register_lock);
> > +	if (!get_feature || !put_feature)
> > +		return false;
> > +
> > +	if (pmt_module) {
> > +		if (!try_module_get(pmt_module))
> > +			return false;
> > +		have_pmt_hold = true;
> > +	}
> > +
> > +	ret = aet_get_events();
> > +
> > +	if (!ret && pmt_module && have_pmt_hold) {
> > +		module_put(pmt_module);
> > +		have_pmt_hold = false;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +void intel_aet_unmount(void)
> >  {
> >  	struct event_group **peg;
> >  
> > +	guard(mutex)(&aet_register_lock);
> 
> Could this get a short-circuit to make behavior on AMD obvious?

Like this?

	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
		return;

Same in intel_aet_pre_mount() for symmetry??

> 
> >  	for_each_event_group(peg) {
> >  		if ((*peg)->pfg) {
> > -			intel_pmt_put_feature_group((*peg)->pfg);
> > +			struct event_group *e = *peg;
> > +
> > +			for (int j = 0; j < e->num_events; j++)
> > +				resctrl_disable_mon_event(e->evts[j].id);
> > +			put_feature((*peg)->pfg);
> >  			(*peg)->pfg = NULL;
> >  		}
> >  	}
> > +	if (have_pmt_hold && pmt_module) {
> > +		module_put(pmt_module);
> > +		have_pmt_hold = false;
> > +	}
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
