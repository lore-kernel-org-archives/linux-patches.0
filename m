Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DC438C42D
	for <patches@lists.linux.dev>; Tue, 26 May 2026 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779820042; cv=fail; b=azQgrf1+U3J4IPpWxIPsSdYqwvIsfg4wVkAvTyQSiawNlyXdfvoV9KqM2Kb/AWE1IlCkikIQag9W2P2wtajf+1pqcn0cbo0Qs8zpQdPWJlQiyana3DV8i0dTGK5/6Vvt77cdknF+Ok07gHlsEWwbBkiiJz/cWHjbOYzVrS2QcN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779820042; c=relaxed/simple;
	bh=dbR+20mad4GF4vxfyVsxD8Bjrk95xYZWWBLicoFyN0Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JBrdYReNlyewoC1P+F8xB7VI8UNAbFFFiJ5ZUhxjJh+9ETFqgugCHXuTtgWvNDuDnyH7PlntB+P1Hn9glW6Y2cBnYn00dsScDgV7jKqWXYQpnowD9vqxnB4nxZIBLoAeaZ0pgpWyTgUGVRw3C+zhdipZENGFErCNQNnvT4+cCvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BmHcRaHh; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BmHcRaHh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779820041; x=1811356041;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dbR+20mad4GF4vxfyVsxD8Bjrk95xYZWWBLicoFyN0Y=;
  b=BmHcRaHhV+4qo0xFMo4m2MSsRn8i9InobxWP+Y1+d0VFNHoCAZQG9Tm+
   HF678jRzHriPqLzXfMnymUXonAMEyCoiH3oMdcx0nIb2g2rMxfv/bfqdw
   CHVFN4z5xQtY32uVC3DewC54GNss8MLrrZr1/YC6WpMUUHWrlAC273+26
   n3PSPnlCGCjo6oedLqWU/hxmy4fkZsxzEGidfm1KrE5oMrdQMXfAAPkYr
   VWA8hVZNNX20xjsUSw6WuMXsCtaSns96g/l9VcFh5hgfft0rHFPUUHhaM
   H2jCIkNm7rvylwqng+L5cYjmJytdN4Wj1i8mIk8yYIaZDzUqaBTGuncvE
   w==;
X-CSE-ConnectionGUID: t4wq+kjxQcizkILr6FozMQ==
X-CSE-MsgGUID: xqkbECxxSxGFDkp/q1BDaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80829806"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80829806"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 11:27:20 -0700
X-CSE-ConnectionGUID: JriJimeCTRm7ZJrrMJJYyQ==
X-CSE-MsgGUID: aTABdFNpTYGbgQZnv95jbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="237578051"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 11:27:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 11:27:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 11:27:18 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.59) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 11:27:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PwgTuyX77VQ2cY3cXpOwgTxMVukN1q3FzrZSbv5pWtlHxq9Q49aTi5r/fMzrzqthKceG1mvMF/4GUkhrCWEnqJdyUT9WavtreTAQQ6fRy2NTDcngVp7v3DJG6j4vhOTfr1FlIxFkdgRdf5R9gbKJn2P7E1/bax6yaaZoF5ZDpGMkrmzXHy7jKiNyd5v6sDVdIwxNGX/1qSdLLXRbZ8Qm8ngHy4RbqDIjmDlrA3Nz3KSR41KVcU/0o91S0BhSVrBo1ASOiSu0HYB5w6PtMurxbiD2S/Da0dtlPYqgrnP6SWliw+UkylvRoW9E2tgE9Qt+htVzpnwewyDeW52w7SAKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ji3oz8y6FW5aiTNq6dpQC9+Vjn8mAGhHt9j+ZbO3c0E=;
 b=UX2o3b2Wh/bbwwuKTzKUQoyxJ0r8WsOuVhiR8QGe+eZml7IffpqhvHQ3g7/cPYU3R67lrAueNjuo0oO6pKSPLoLx1s3fLgiHZ2cnpUnJCWT2B5an8FzoBI2HCW/24FgFhzVfkqTQsVRaRA5RnGtvRtMeInXUx11/0G//MTMX5OVvO7w0CVfZmGBbjdghzuQpwNwl5FvhMATKB9gMgT/4wzIENYbWJ0yuQLauxuyt18WrYiz6Bot9M8agXlOBkf507nkDCb+3HKWogtAIQzEneSHjqO/GJWgQYYwspP71pizGCQ5O/OyRRfjePvZw/bigSKxbXSs53JgRmX+L4DtIbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6515.namprd11.prod.outlook.com (2603:10b6:208:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Tue, 26 May
 2026 18:27:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 18:27:12 +0000
Date: Tue, 26 May 2026 11:27:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
Message-ID: <ahXl_UF66yiPiEPB@agluck-desk3>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
 <ahW9EJORpIqnvthk@agluck-desk3>
 <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6515:EE_
X-MS-Office365-Filtering-Correlation-Id: 69352243-8b73-4c93-7cb7-08debb5466d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|5023799004|11063799006|4143699003|22082099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info: 5b6+9xn4ffbEnCi6itjGvt8GZ1FzoeJQP0Gd4cQIDjE1aAhAb3d7iqgE3itbwdRgePPJ3EPfK/fEz+dWba2+JuRgoGLdteW7d4SyOuZ/zkVzFEjGeVq37TtlMM0lwNTW/jOZ6Jq8F1/Tm36dwxusLFoeXpSupF82Y9dntDltdls7iVbn49Gzw1XIxE4xdRpIQJ3z/PHYVEH7EztoMz1U2AoIChC2f5xuwkvbqKBpg1uprNONyWO2lylkx1BFXAoNly1z3k1Yg76n+9Rv7yzNxCFDskq/lbxA2864Af9r8ZoRIHLKYTj4ROYpGjCMnl6n4bA/AQIVGC4YCI/VThjp9pThU/O+T9m0KCrpFgT2IN79ys+dMvsJwNtaJ5uZZ7wDz41RYPcRYa1qeQDC65iaUtW5pCSWnxRIQYwLNAl9WwPD58gzkk7vq1PQNBGUfAwgRCkrRg1wo3xLwkvDHg0bcVL8En3/JLNTivA1mFUQbNfhb3dWurGzmBjC0ojfqgg7eQwdcIvtb8VX5yZjkwDKdqkVgz/8yW43wvPqxe/R3q9UJ1bpxkAUpzfoDOmMxeCYRFImFTQZh3GcxRxPW+S/YUsITxIlVIw0z4oui6avM0qnsgaKQ7g2sDJ4JdTpNXhPwcrteVDSEm5uZKrmW2NlXMmRE17a/gZOtg3rc7Pxz0KD7KJxsU8KEwJXEcgukYOE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(5023799004)(11063799006)(4143699003)(22082099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yjC+RJMYz59CrlCFepy/XcnJciS1GS4pxyO/zyypZRD+rqwQd3wTIbyjEsSa?=
 =?us-ascii?Q?yL5qAQ6Xrw7GnMn62J8QsA64LTjCtH4T7PqldbsOghZYJF7lpSTdyakXeMAL?=
 =?us-ascii?Q?jPNcx3NcGOocKlHAA53zCMxHsNx3cJ8h7+OMDqKyzT5mLAOptKHMry5kq3MJ?=
 =?us-ascii?Q?Lq0D7bPNUGzS3jl4dQSY/00Z94hEekhY4x+GIZyTOQemw30ba8V1G3DjiO8f?=
 =?us-ascii?Q?QG8c8F9RhjJ1xd5dwo21Z/C2y+2JnotH6geUxjKOQsY7K7CD3BD5d1oj92iJ?=
 =?us-ascii?Q?7egh2yiXNnSyAggAksMAtAqD439GThf7V6fGfPJNNb6ooAY9Hw4lACbRlf9U?=
 =?us-ascii?Q?jOLB+nmRJoj052Tk1xk3QKG8WDEpTuvyoYkVnUbuiHlZBuSC9lqhIpIos0IF?=
 =?us-ascii?Q?DKIhbY6IAW2dtYA5YNxzg/0cMjilGA6jH66wqLo+M0L/CffJ2XncIp5MHh3Y?=
 =?us-ascii?Q?zAA5sKfXEbbCehRI2v7XNtDltqFGgkhvffKFb+GEXefV5pX7ZlYfnU8ggg/C?=
 =?us-ascii?Q?DjcNTMhPZ0rWeN31Xigu5Oly5ChY1CQ7rDnNhjxQUfFU9+S3A3bcYIR9TiVG?=
 =?us-ascii?Q?Pe9PZi3CvDG/Wb206MoE88UTBJALZEcTjYBev00sacfexs4mk6N7OtQ+RFpN?=
 =?us-ascii?Q?IivcK/cO8nUgmDZuo0ubWBLt558rhkKu888eAPatgzc49GJtGOJC5U/cGFY0?=
 =?us-ascii?Q?tT9MxSbjc/VQ6y6U5C+VZ9MwJyFC17cgb2ay+5ksrRt2U/KbBHi2NmnLaiYc?=
 =?us-ascii?Q?namM3dmGmrKpuKSzkdY7+wXS5y7LdhNz8pc4C30yW8tcHGPgtZNDj19c5flU?=
 =?us-ascii?Q?LJvg6q3WP0eRhFbrLoH7w29A48H+mAvj2/IFczWaJpbJkEAxtCenibGzGoez?=
 =?us-ascii?Q?rtK2qr0n+DxeUUiEGXD5jDz0uLfRQWGgJr/gbbA1dxatmWVqIBjf47yVqGeZ?=
 =?us-ascii?Q?d6xQtwQC3ryzfZlO6KJM3mMC9EAlMH7Dl/ff5MYPkYDe8XNKuyf0RUFpcXJO?=
 =?us-ascii?Q?VHPfSyajcgdMJqPyDhhGkDa3hcyBgoktXT+fb15sEsJA/ppUa8CYo7FrydOF?=
 =?us-ascii?Q?tM9jmVxh33hlsxq10nHH+8t4s3AxR86+disNbLjeo8VFQVP5/hrX3klIiiYw?=
 =?us-ascii?Q?RtVSve5ppx5yTTAqxteOwCUtx5IbAVeYPMQZKs7FSHA9hFUcgwjhliur/X1Y?=
 =?us-ascii?Q?imu2ay1aJZIAnnGi1POLMLiHWyfM18fMltbB5AxQ4y696DE2ROVJxCXV4ySR?=
 =?us-ascii?Q?ic8+ev6qk9RYhJIM7NnI0DA0pXudP0hMgd8PVlvDjuP10Czvy5+ASs1w0I8z?=
 =?us-ascii?Q?BXPInHATQRnxEV+5EAx18u/n2w+qOpF5ukyJksdEM42iEgAM0T+d/CGC9hBt?=
 =?us-ascii?Q?4Sy2RGxJXT7RwJBGmAtNEIjkNuSLf0Bo2LVcc+sh0lhCigEVgI9IZT8X/HiN?=
 =?us-ascii?Q?Q1Sv0NbGcgK9xm86at7H0JVVlH+gixuWAifSG3wC/F/zSn1eaoaZRt+VMz0J?=
 =?us-ascii?Q?1+47HjfwYeF/jDvnbLYeGmxU/BLmIIxJyu3hXP3C8G8lSQb8b6aUQnDjF4Vk?=
 =?us-ascii?Q?VBaA4ae6TpaK53kDF5haQrdpNZqa/7Bo84xcSr0TyAkJW5xXv/SWxyp5UGZ8?=
 =?us-ascii?Q?sW6Sb0TEdyHppL0gteyLvdGYcedKuBT3QBZAUEraomjIjYgO3ouIxIY3sF7A?=
 =?us-ascii?Q?+99FP595GgwCkk0NP77hvtQzyH5oeJxz/2+zytJsuQDAk0MJZwKK0RpWb7Eb?=
 =?us-ascii?Q?zhiZ/a/r1A=3D=3D?=
X-Exchange-RoutingPolicyChecked: tJOKGnIbFO/EElZdW0bJ7V1YeFb00SQY1XWS3xlrrGwhUqiwXVJf+TlIk9TGrMLNW8+JJQ87e95aOYfGMajyZMlzzBKPCiMKo6bFJgFuyWHgjf3eZJcn4PSDQOqtGGIM4rldSYTiAlfiaDIl40KB5y4nPNwq7yVO+PpX2MFodNzbcFSIZaBMDoKV4vqm++9YXG3KwWKoGXrjO6e5uGMVnPg4r1EWIJcZLS0b+naVRcuwOxbPLE/eVKIRExQJOzesVnSoJNNx9qiLFZj6HdUkNxaybqs3Mnn1nEdeyJGGPbMe0UAjOyHOtZVh5kA6TJDuFBlT5iNxfgPrE+xQp5+Avg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69352243-8b73-4c93-7cb7-08debb5466d9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 18:27:11.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZkbUOR3MFrnFPUAmgI0HTKIsd3Jn2SOR7xTWJR5rpWac0dn+MYait9M72yweZDhCSAUc5VTdT5+remL2CX6tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6515
X-OriginatorOrg: intel.com

On Tue, May 26, 2026 at 10:53:59AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/26/26 8:32 AM, Luck, Tony wrote:
> 
> Instead of deleting the patch without any comments, could you please provide some
> insight to what problems it has and why your solution is better?
> 
> > On Fri, May 22, 2026 at 12:15:13PM -0700, Reinette Chatre wrote:
> >>   - Adding a reference count to the domain structure to avoid the worker
> >>     needing to take CPU hotplug lock. This ended up being very complicated
> >>     with the architecture needing new APIs to manage the reference count
> >>     which cannot cleanly integrate into MPAM since it uses a single
> >>     architecture domain structure to contain both the control and monitoring
> >>     domain structures. Managing the references across mount, unmount,
> >>     online, offline, as well as worker self exit resulted in several
> >>     asymmetrical and complicated paths that were error prone. Locking also
> >>     proved to be complicated since architecture would need to initiate
> >>     domain free that will need to call back into resctrl that will take
> >>     rdtgroup_mutex which means that references need to be taken/released
> >>     without locking.
> > 
> > I'd been working on a reference count approach too. The MPAM combined
> > domain for control and monitoring doesn't seem insurmountable. Mostly
> 
> While technically possible I do not think it is a clean solution to have
> the lifetime of the control domain be controlled with a reference in the
> monitoring domain.
> 
> > because it seems unlikely that the problem with worker threads would
> > ever apply to control domains. Maybe I missed something, but just adding
> > an architecture *release() function that can be used by file system code
> > to drop reference counts on the domain when worker threads exit seems
> > enough.
> 
> Did you consider the locking implications that I mention in the description
> you quoted? More below ...

I didn't run into any lockdep splats during testing. But maybe didn't
have enough code coverage to poke into corner cases.
> 
> > 
> > My patch below.
> 
> heh 
> 
> > 
> > -Tony
> > 
> > 
> > From 611fd8ad816abd37ef9a65b39175ce05907a1d41 Mon Sep 17 00:00:00 2001
> > From: Tony Luck <tony.luck@intel.com>
> > Date: Thu, 21 May 2026 15:14:27 -0700
> > Subject: [PATCH] fs,mpam,x86/resctrl: Track reference count for L3 monitor
> >  domains
> > 
> > There are race conditions[1] when the last CPU of a domain is taken offline
> > and a worker thread may access the domain structure after it is freed.
> > 
> > Add a rdt_l3_mon_domain::kref to track users of the domain. Don't try
> > to cancel worker threads when CPUs are taken offline. Just set the
> > target CPU for the thread to nr_cpu_ids to indicate the worker needs
> > to take action next time it runs.
> 
> One test I have found to be useful when digging into this is to offline all CPUs
> of a domain starting with lowest number. Since overflow worker runs on lowest number
> and then is moved to next CPU when it goes offline this stresses this new mechanics.
> Have you tried something similar or could you try this test with this solution? 

Yes. My test case ran through all CPUs in the domain in order. That
showed an interesting artifact that when CPU 36 goes offline, the worker
next runs on CPU37, which is the place it needs to be, but it isn't
bound to CPU37. But since d->mbm_work_cpu (or d->cqm_work_cpu) is set
to nr_cpus_id the worker calls schedule_delayed_work_on() to get itself
properly bound to CPU37.
> 
> ...
> 
> > @@ -680,18 +692,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
> >  
> >  	switch (r->rid) {
> >  	case RDT_RESOURCE_L3: {
> > -		struct rdt_hw_l3_mon_domain *hw_dom;
> >  		struct rdt_l3_mon_domain *d;
> >  
> >  		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> >  			return;
> >  
> >  		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> > -		hw_dom = resctrl_to_arch_mon_dom(d);
> >  		resctrl_offline_mon_domain(r, hdr);
> >  		list_del_rcu(&hdr->list);
> >  		synchronize_rcu();
> > -		l3_mon_domain_free(hw_dom);
> > +		kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
> >  		break;
> >  	}
> 
> To me the idea behind a "domain reference count" is to provide guarantee to any holder of
> a reference that the domain *and* its data remains accessible while it holds the reference.
> There is the domain structure itself and then the architecture specific, for example,
> rdt_hw_l3_mon_domain::arch_mbm_states, and the fs state, for example rdt_l3_mon_domain::mbm_states.

Agreed. I'm not guaranteeing that the whole of the domain structure
(with all the substructures that it points to) are valid. This reference
only promises that the mbm_over, cqm_limbo, mbm_work_cpu, and cqm_work_cpu
fields are still valid. That's enough to solve this issue, but if we
were to adopt this patch would need some comments so that future readers
were not led astray.

> Above snippet moves the freeing of the *architecture* state to be called on kref_put()
> while *always* freeing the fs state (resctrl_offline_mon_domain()->domain_destroy_l3_mon_state()).
> 
> A worker may thus have a reference to the domain but when it runs it runs without 
> fs state which is just a new use-after-free.

For this specific case, the worker sees "nr_cpus_id" and avoids use of
other fields that may no longer be valid.

> As I mentioned in the description the release managed by architecture implies that
> reference needs to be dropped without rdtgroup_mutex held since the architecture
> should also call resctrl_offline_mon_domain() as part of release. Locking needs
> to be reworked and needs to adhere to kref rules on kref_get()/kref_put() without
> locking.

That's all handled in the existing (unchanged) offline path. The worker
threads only need to call kref_put() to release their hold on the domain
structure that has been mostly freed (and likely has no hold from the
file system by this point).

The release functions in both X86 and MPAM don't need locks, they are
just calling kfree()
> 
> Reinette

I see that sashiko found no issues in parts 1-5 of your series (Yay!)
Grumbled about some issues in part 6. And then gave up before getting to
your latest solution to the domain offline problem.

Can you repost just part 9 (or maybe parts 7-9) on top of latest -rc to
see if sashiko is happy at last?

-Tony
