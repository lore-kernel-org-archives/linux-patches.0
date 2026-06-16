Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6103D669A
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632214; cv=fail; b=JSeGvgU+jCRV33wRltk5QAqkpLEl6S9Kt+Vti6jsxy7RRDQaREf2b5lfDOPgOEFDFZEsn9fi4IUO/uNqvEmu7VbgwYEz+aV+oxSdmVpKgMw/b0WekfLy7aVL5LYheY6P0iZcnOAO6IiAAJsgCROBgG3NM8SYIgOszlva38l7Tz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632214; c=relaxed/simple;
	bh=6i9ZxW75QvU25B2KMeiyHQBAJH8Q6KhmQe9uNn0ywFY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E7MePcGgEWsSyTGZdvKhNcw3WWqzylUDqB+0y6Msc/mKorhZyX1c1uxh32uX+6gCSyxovdZDIr6oDz6BM4O/pCyAIX3q/d2FVm4cAP8mlQ07FD+YWBkjOZ4bTXiF9M4MfHM35xQ0IF4phRseJgFpyGRQYaEhFgn6i0vKkGFyrdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mVYHCk12; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mVYHCk12"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781632213; x=1813168213;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6i9ZxW75QvU25B2KMeiyHQBAJH8Q6KhmQe9uNn0ywFY=;
  b=mVYHCk12TNfWraLr9d9GVGml8QqmHS28uVSmJLSjGlAX8Fj9ndYtmFnT
   djtFrTX7bM7IZeW5zy3ujVwyen634XsU+cGdcKUUfRbWEb4OJtEtLFEAu
   Ar6/VVHtKrW814upLyJZX7Y3iFRR7Ba+cbskD0HsEejXHiRMevqWHGqVX
   Rd2Ux1qFVnmz24DYvJYh/6snJaj1pGpIfDNY6z7lpTt8tC3KwVQlKs3PW
   qPb6hwh9HAPnnyUlEplFyQkikVU2F5on0L2+ynb+2U4GR4mdsFyT5x7aq
   rKIuSlag4Ldd4Yq18XJl2EgXDhYDHQS1HnncpKwIjJ9DbpDLyUb5mbsFs
   g==;
X-CSE-ConnectionGUID: /6FSIIxOTP2PxmdabERO9g==
X-CSE-MsgGUID: 7589DGGrSBaHQucVirwZSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="84972137"
X-IronPort-AV: E=Sophos;i="6.24,208,1774335600"; 
   d="scan'208";a="84972137"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 10:50:12 -0700
X-CSE-ConnectionGUID: l+lbJtvBSU+U7FVMncT8xw==
X-CSE-MsgGUID: +AHgXMMvTIWO0jcCmwSvwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,208,1774335600"; 
   d="scan'208";a="271909705"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2026 10:50:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 16 Jun 2026 10:50:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 16 Jun 2026 10:50:11 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 16 Jun 2026 10:50:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F8i2XhR0lUsIluWAOFh4ynqt7yopDbhCOLf3dzwoBN2he22HkKETmSSqA+H/PduEp2LxwUiFTf6JM9tra6P5L7HGInrSaOSuny3D7W7bnF3dcgQRUBsVevofbkO5J44FvkQ7NmZeQI0Iq/gI/zL6rJdDU1P1eb6jlGr8mUkIHIgaU88XwYt/mgm3Ku8oAoTX6C7nluhczYmd9Y5oll8sX41S0LoKl6vl5xH51jGlyo7W+yBJInom1dVThf7ry4ZE1x/2cmfDpBZXCOsuJyNku8oMVtNwyKiEFpFcwHg1afH8NQwPiuH3MY/UO5UrdxDszDp72xMnw7URrjVeigeXOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZDByaqgpENaKIaD+bawyt6GfP8x8rcExPur1gttRhI=;
 b=DDv7c/SDt8m4TomQjP3kkvE5KQXbHXO+g25Fydoh96Bt/Y23S1ZhAvARU8JKN1A/bYfT2R+ichoEkpzZAdK5Utp7Zo3ufzR1UE0dsQkG3y3cRNPyDM0hcaRCHUIaFP+LimrJyPCd6NM78FX3eitaqWHAl2hemKw7f8qcNmWBRMjyTXdRLudjs8BrV21yoxZB+e44Z7cstQqYmFHfxeeHxxJEHb5vf4IAII2WyWg/Pk76E0lyPObHyGjbYT0XOgxNrwxArxXL4ip4H1kg5BbadQ0fFCEsB/+VDtsgcdeEFpgv7XEgS/Gy3otxjxtzkkJyIkDAieTFFnZe4ERNsbUHUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6098.namprd11.prod.outlook.com (2603:10b6:208:3d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 17:50:08 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 17:50:07 +0000
Date: Tue, 16 Jun 2026 10:50:05 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v8 00/16] Allow AET to use PMT as loadable module
Message-ID: <ajGMzZ4MMGJ0mkM4@agluck-desk3>
References: <20260615182457.14725-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::33) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6098:EE_
X-MS-Office365-Filtering-Correlation-Id: b954a44e-7c1a-4bad-5320-08decbcfb431
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|23010399003|376014|1800799024|921020|56012099006|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: j9hRmFL5kyh+lr96TaY1lS0dFCi80b5nXPPIHfP3FXiXuLOjnvV+owgWAk7o5WOMst/Hl+9FIPPUkcIQGLFGRoC7YFuPXDGf37pp6Df1JXvdCy2DNEoIGICqE/42WcC40FksUAndJXELoKbModpbSGYIDx3zTNOmiBRMS/8dl5wb5U/nruPHiLYtWZRFTaApKFDFUlfqgZ6fCNdZEOSYTKuA+JO1HxfVWWaJb5e/tJxi2haRfxVVuWp7cperTSwuom5t+L/HloRdWq3Xkansm6f63eP7c9QddBF+C9iXn69zkN0FN7LSYtF7+EToH2dUX/a2NTvyUQ/GW7L+TC9KGaULQXc+t1paBz+TNN4T4ym06Ae7XZhaHq4LY+jLJ8YGMfYzgtAMZZkpYN0POnUEHbRo3jr6sa3J+pja/0+IbQrC7Onno3aESuMQd0y1vi0F1+FnQqnn235HKM5VSgHVqgoqG7qeTiKpA5B5xzgWEU4OJkuRmVEgsx4lvYNWRSrU27r3u3bKLr+tnh+xyOxo1+5h+qcDFGiNuYYUCzYgrMc4s8sRx8HUkELQ2frC/KBMs6K/b1w+OIiO0wVhSUct+tUuOR3VkdKaAObOJTeV16xwobtRlTuj0F9uN1HDC1FdD2eJEP7AAg9U2RZZxA1clL/3tusHdafEh9dZ8lcZDLEm8I6hjru9X/No6a2bZyJk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(376014)(1800799024)(921020)(56012099006)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MKojJFpDcXEfgwxiuGuebpUoNI7HOspXobZ+HaQ3TOp5LSSsGzxyHBo2PBOV?=
 =?us-ascii?Q?HzQXJ4WLCuLR/oZ9JyhTteKWwQuLFU2hA9PNvYK4EXlPBtnPax7rmkd/sQ0H?=
 =?us-ascii?Q?hh2OU3w2O/JI2Qs6qAsdn5/9N4oftvr9Cw+TtXELPy0tCl4b0YjtcY9Ypjrc?=
 =?us-ascii?Q?B9559Tkl4Ul1rBiwSSNVHl4JvMqGGJpftlpuf9QZQWlPOHhvQIzGrwNKqRcS?=
 =?us-ascii?Q?ZgTf32CyY1VvUTTRN3wFwejwN42fmvRmQbXkHRs/eDtGQjAF7oFPgLVAzxrK?=
 =?us-ascii?Q?tsH6lAwphYdpFbWvdV66spkcvYzmfLciOTXrx4RVMJkJDb/GW/5zD9CYnAt2?=
 =?us-ascii?Q?29SA+ZDsvFBfFviSI/Z72CaVjiymbmTUwJbC8o/sCUM8mnOC6TTKyBKfJCK2?=
 =?us-ascii?Q?3fCYO3qfQNVF4dY9Fdo2u/T2PyDckwvLV5i5vuAxVj5af/v9RIKBfmk5IYkI?=
 =?us-ascii?Q?AKYdA1B78a3lfNSQ3gsZqneDxlC14liB+/pE9HOlu7eeDSDc8ARsXonCIVta?=
 =?us-ascii?Q?bbkJ9PyB8DRE7iwsU88eQefPgi88bInH3npt6+fEXbnCMvRlbXIYLYvuiiAA?=
 =?us-ascii?Q?sAw+bflv2yVduw6vLx6QEE1UXxa1XOrD6LazR16w6kCSUckF1+3OX+9I1LTp?=
 =?us-ascii?Q?gM4TP4m0zTJ4XgjtpSxzuxi8xezQiPlJNj9ebdYjZnawkVSkXYCMlvjXi9hm?=
 =?us-ascii?Q?EMP4TKNiGkN/7uO95M/yMrlGxMAHI++yfYflgC/+2wm8pXCMJrS7Hd6GSON8?=
 =?us-ascii?Q?2SSv72Go2XLN9Qo3Dh0QbT5P66FAjcVeLWN9Cm2g+12fqIoywcHx96y7sFLi?=
 =?us-ascii?Q?QizalIkRufm3FO9TGvChz+KxSYx5HzLysCqLN2xm0xS5rrbJ4Pd+BMywLt+N?=
 =?us-ascii?Q?GZRMScN0C5xXUgYQf58GDRHpbXRyNcSJH7xvePmFIhDBjzvAbeTKsSYnHETi?=
 =?us-ascii?Q?1Tb2HEUQx/Gv3IWIYIZ156KnrDvSml45EfqUjs5YNUNbfcA+NnjqlO1YFfYT?=
 =?us-ascii?Q?Ve5Dt/4LzgwDAgORicjYT9erKCS6iCRjjbqVJZrq+dlBoFQ4LWcPi6XjRKzr?=
 =?us-ascii?Q?qVe7U+bwAN8MEcOskXhk7qcdK1BoFMaWehzxlTI8vcd2AdV9uOrA+tx5i9XN?=
 =?us-ascii?Q?UtvVcU0WcvtACapo4hw+mMLV4y+7a2uRMmRK1moFkAzcmydSSkAnPREAng9B?=
 =?us-ascii?Q?SyKbCtbzI2tiWwgRuNOVCf8HMCmXexqjYGWL/xl/jANoc1jmDJ9WXlF0NZ75?=
 =?us-ascii?Q?SVWsSsJseNe/w/pcEbOSR7a4p8HUeof2o75/Q7EKnzr5ln+wnkKy284e5gSJ?=
 =?us-ascii?Q?QmJvxCAiRdTA0LDBfKNgBtAcYvGcqDA1BpTyl4JhV3YlETfXFLvHJuIuhWE1?=
 =?us-ascii?Q?aB9sZW3B/R4zP7eVyZn+po4Fay+8y/ClQjdOR3+HZ/B1kR4gxtr94dVYhLka?=
 =?us-ascii?Q?qA1s87QMhxibFTG+RGYWzmxe30tUiZXM2DKS/nDHQ1x0czByL6qe/EvzCLHt?=
 =?us-ascii?Q?nbmD+frXu/QNuuB2VH2t51msbNLh1pCJQiLGhSBM2fhYtuykMzhEUUaIb8LD?=
 =?us-ascii?Q?SntG1AygwW37dwu3PDKOHv4i0eg6JwxDxHE5e+q/yeVwg0DtOvhHadf+2RoD?=
 =?us-ascii?Q?/LA6X8UYQ0bIKmd4X0tJLrrFjX43A6cylQ/YMqx/Jw5UjE+9TK1X1XzUSynf?=
 =?us-ascii?Q?oPLTA1xFspKo5li6UdlWQ75cEp/GgsB0GcC0bp0MxwxzCjrKjfQGwcWHjbWb?=
 =?us-ascii?Q?pwE/n+ZG+Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: DbCO8o4c+ylrzIEVHDvI3FXVgEQCAzb4t7ZIvU/BACKwkZMqwoLC6XDPWjJizjX4uAq6bcb9luOajm/D33gzhLKYAjxamxPk5zBpe01S44/u+GwwpnYIHQs4dXiFmN793yE+pc72ZdtA/uBvjiOkJLmdpsKYLYmh4u4ed54o/gKOI1LsQWow3kqxLiz+GmuNiLriFtctIyv7azP7iJpRIRFZsWnCsNNWOFh4r5s8DZGDjrrgOxjTJrl91ITwpv8U7pu8hMR+/wqsAIYgMjoDLqDkPfEiu+EJHTqQI06P4zHhvqyR/5ZU7wcPQpK0TLdgbNIAQiQT05kHmI91ipOMyw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b954a44e-7c1a-4bad-5320-08decbcfb431
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 17:50:07.8357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: anwluOeM2kWXKhyYEEl/VTq9pmUMEqOidqT2TTJh59SXp28kdNz42DS23IFzEG+TDld8le8B9xgSUNKpo8V5Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6098
X-OriginatorOrg: intel.com

On Mon, Jun 15, 2026 at 11:24:41AM -0700, Tony Luck wrote:
> Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
> to enable enumeration of Application Energy Telemetry (AET) events, but
> unacceptable to many users. It results in increased configration complexity,
> increased kernel memory footprint and inability to patch problems by unloading
> a module and loading an updated version.
> 
> Add a registration function to the AET code that can be used by
> INTEL_PMT_TELEMETRY to provide the enumeration functions.
> 
> INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
> resctrl file system mount/unmount. Perform enumeration on
> every mount and cleanup on every unmount.

Sashiko complained about some patches.
https://sashiko.dev/#/patchset/20260615182457.14725-1-tony.luck%40intel.com


Patch 4: Complains about hotplug and worker threads. Dealt with by other
patches in Reinette's series that I didn't include.

Patch 5: Question on whether unbinding the parent of the pmt_telemetry driver
(intel_vsec) will cause problems. I'll check this.

Patch 6: Repeat of patch 4 worker thread issue, handled by Reinette.

Patch 8: Race between unmount and subsequent mount relating to disabling
events. Will investigate.

Patch 9: Same unbind intel_vsec issue as reported for patch 5

Patch 10: Same worker thread issue reported for patch 4, 6

Patch 12: Sashiko concerned about multiple telemetry devices (which there
are). But for the resctrl use case it doesn't matter if some subset are offline,
or broken. Resctrl needs all of the, to work. I think I just need commit and
code comments to document that it is okay for first .remove() to unregister etc.

Patch 13: My atomic operations in resctrl_arch_pre_mount() and
resctrl_arch_unmount() are garbage (sashiko was more polite, just pointing
out the obvious race). I'll drop these from next version and handle the
nested mount case in intel_aet_pre_mount().

Repeat of patch 12 complaint about single PMT devices being removed.

Patch 14: Repeat of patch 13 race condition complaint.

Patch 15: Repeat of patch 12 complaint about handling mutliple telemetry devices.

Complaint they stubs for intel_aet_try_module_get() and intel_aet_module_put()
don't handle out-of-tree telemetry enumeration modules - Linux in general
doesn't care about out
of tree code.

-Tony
