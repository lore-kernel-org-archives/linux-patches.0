Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00AE365A1A
	for <patches@lists.linux.dev>; Tue, 26 May 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809564; cv=fail; b=CDDk6bZJMcVUIEHb/SkLf6kwE3OE5hGFf2BbfazTJGAj6pCwPMXDNS4hP6cN7scbC+QyGkfjUxXZKjGfQwvSxIpTLs82beWgpwwrNy7mbmo+CX2IPCSTZyoPM2ITROeZzWB5pq3EUG95r7fXcG7fhxQJcd3ZpEUXqOnOM54B7k0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809564; c=relaxed/simple;
	bh=HL52QobMohsnBaPHOPEsDVAwRhhf/vCX+SG/3ZivHdQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fABZJlB/no05wm8A4kFXiW0x3Yn3jSyNrvNup4Ig+uU5lpjYcsqanArvpjBRa56bKElzSmTNubbkgNV+sWMSObFyK7ajHykngQMuuEMELNEbpQCbU4izGo3cBNuMMkoEVPGJLy+C3Po8Kfp+JT6wGiVY2IiueZvA8ehyxTC94SU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L6Lrdfhh; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L6Lrdfhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779809562; x=1811345562;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HL52QobMohsnBaPHOPEsDVAwRhhf/vCX+SG/3ZivHdQ=;
  b=L6LrdfhhoW0bR28+yn6SBtB8qqHmtL8FFXfdEB0N/zDiaLLHhfmhW3q+
   CxGfCzGxuSHkTEw3BW5QLNWg2YkxFA20JJhI2EVpz6OjfoRwQBNu5U3Qi
   7uK5MDnn0W17ucuKSqhd5ke86XpZ5otXd6g1XA8akEGaTYs1PUfga38yc
   ZAzNijNDPP7paJTTXuUdfUVtfWJCfrp31csE2dG4DLbfboCKokaCiF3Kv
   sZEB4+JQgDOf0ZEi9XKNSRrvjF74gK8QYfzCUHwnqJXUhGH3iAaet/d52
   /o+uYpbVyF77crgR8mkQl4RAl+egeJsXQVjaQ2ap5baviMBpmXKOX2Y/X
   g==;
X-CSE-ConnectionGUID: y0Fl9XzMRQ6NOqqvDKBv+g==
X-CSE-MsgGUID: TCHUoNuhQHe7oHZjQo+ubA==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="98050523"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="98050523"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 08:32:41 -0700
X-CSE-ConnectionGUID: 7xM5Y++sTy6R5V3JqGiilg==
X-CSE-MsgGUID: M2nzUuRqTDm50WWIfhH1ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="245977748"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 08:32:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 08:32:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 08:32:40 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 08:32:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2fX3n9k6HzfJRxyScOEqXmNEpkp0oqUQSkLAwv7DpOMtSwJKdUkpclpWvhPRjhp3lLkAkFIbJyQarrc7UAZYQGHDQrgjdxghbREkcHxLcofXzJnPIjZA/wWSWXpx8SFnG+LpRjK0qf4IZysUz3q5ThDWTq87NxrJGUTT30UUHcxdHwRWWqEVBxFeS4sgyUvRJyBTYbFw4HZ8UrPGsTa62MAZb/09ztMhTcIi+4dotzj1Ac/ZP4jEuxIi6P4rxcULUhS3orz775uFGsNnU6IXuOptmU2+4a2vUf/OCRCmlalPnrVVnIOHAlYYjxLapt/kDUN/1g1A6C6vTcs1GwPFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cA0rqxsouDUlWnLltxwsT4WST0uojqjUwsP65KLNzjQ=;
 b=fDpyGWfVPz0bdwu7sBStqphqDxuJe1Ecw0rmcLTNHsUS2DSQ+UwDCvEScCnK8QGaLsh18qY7w+bO2q2JyRGathjTdz7jM/YLenwLeNS5v80uWkqCW5x0BQboBNaqg99vaLNVsvuDWFu7vra4IVvWdjiMf5Y6wwo3towNs0Lb+Dhf5p+6JuGMRiICFoiaK5j6Mn2RqdWQx9QGB0HhQISd8xdO3cjqCIjEkgLODOMNOVFVmhk7NJf3nV/3ZWVUpdpyJkPpEdR2+bLy1VUpsnmhmWG1V6s7xhZWbdZ2Z5COQu8bReJZlvvnziOJtdqHDh7Wc55hRHFjZ6XoXFRC5q2mvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ1PR11MB6225.namprd11.prod.outlook.com (2603:10b6:a03:45c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Tue, 26 May
 2026 15:32:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 15:32:35 +0000
Date: Tue, 26 May 2026 08:32:32 -0700
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
Message-ID: <ahW9EJORpIqnvthk@agluck-desk3>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SJ0PR03CA0364.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::9) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ1PR11MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: d2829897-fc69-4c43-1f32-08debb3c027e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|22082099003|18002099003|56012099003|11063799006|5023799004|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info: rhQzlVzt1FIo7evJQPtjxlAcnxWp2BR8hAweLK1wxeI0uxBS8qNwPv5jLwTWTFIpRIpW6OFdEnhaS0e5IhLmtJBv2XoPTucSQXac9Iey+dQ4+fexKeXdShP64Yzx9oNvvXFkM4RV9noKSXfHxrNw69AMi/8zuemZpqv/mLm81VaFGl7mbI/rFNJzLfise4ivew+i3W678TlJbdNVIw6tlN2S35cEuOMYFzjAkZkEZokkr0zCif5DH5FAVrdagg2lvyfo6dutHJPYZEMIpWFMNeKHoVl6BdxLS/98+Y+G0e6V7HG5WnTNCrJIhxz7Ks86t5hdWeHfv1yjPkPDQykMQy3liDvNXkslRTB98T6cJOApg6bAQfUcO2NlriMIj/j6sGipEqU5nZeoKPURlhBet8JMVyp1n4RyDPRrf4z1GMT6D99KveguKvxJHt6YhUkBjkbc9Ilw4hgaTxrFROyKjMNqaZ2woECm98xyA44/FC1euZXfdrEA3cLY1ctMBDsXYrvZatMTpY6w7kAvGrP4dB+Aj4lOPCGz13NiUKFjxT4xHmyHV0DD1N41MI7nGGEP2pQMrISUfhALcCCX2FveMLtnbtDLRVsmY3KaSoCrCADHXxECE5Uh5uYoQ00LqZSA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(22082099003)(18002099003)(56012099003)(11063799006)(5023799004)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pUZ7e8FvLcAxjc34TcB3furJXc8sX/5DgDtvsq4svtXLuvEBtjiigomxyPvi?=
 =?us-ascii?Q?h5bpnxKXMqwduyJ+LNx//fLR6xjtw4u/hayVElt7N5+P3LLua+nkkMltxNcW?=
 =?us-ascii?Q?UGHNQniwhqS+uXT9QPwBJA3ybZlXFyVQ1zQV3QDHMTg13tuqRGT4c03GoGra?=
 =?us-ascii?Q?TCwsk5Z6lG1BU22OZlC06QvIwZHGboAv5DwWtZBqQqeUlmxkEXlJ3Dm3QHWU?=
 =?us-ascii?Q?NQ2Fj0/xPW31GVoRzym3ftBkeZU0twGSDls1PUHXrKEABTDqrNaj2h1DwRUF?=
 =?us-ascii?Q?ycIU77Le4goO1F4LWzXZf20yYhhPsHnVAb8Tk9YVJ7dPTWsYYXkPOGo8wOyq?=
 =?us-ascii?Q?a05t49KgFTmw0M1WXmW/GyfGT0cXkeCo7L+S0P6Lu/4I9qC1ZdZOZNR/1B1J?=
 =?us-ascii?Q?cO7kIEYvqEcf6sg9v3dYG0yZGXF6o8jelR4gkcGuTk5uHLHkyOcLz0FEgWNE?=
 =?us-ascii?Q?EvgZqPVz7os0Wl9G2PYC+Mgvifx7quSWKWTOKb2OgM3v9capKMCVRi0cQ3M/?=
 =?us-ascii?Q?Fzsl8xoZ/3er8VYHe4C/4I51MnQMklM7KTZmxz0a+xUMxiAiS/bLT7BNBlYC?=
 =?us-ascii?Q?zeVR2GYGa5LBA8bFlcQxIzQMTHRGI7vjhw9yWufoF5CFcLYYm602Ul3S/QU3?=
 =?us-ascii?Q?6OQ2TsCbFqRtU/xRirEkp1RKL1UAftj0y89x9g7XcuZYb+kX31TeBUYTWHMZ?=
 =?us-ascii?Q?10Z5lfPzgCnEHVb8e1L/RxikSDFzT5v5JE/Ia6BIOZoAQRV4aC+U9dAyRyjJ?=
 =?us-ascii?Q?L8YBXO5QTVarI/g99/lqJ9Mf69vMS9hA6oTeDFImEih7E/2mbAFh+EypR5PR?=
 =?us-ascii?Q?/NGSloHSs8Y43VBiVgyaly6orxGBxYEld/texze6oCQk6q4MMyDHvO8sKgS3?=
 =?us-ascii?Q?Aa/0VX2t8EB1W/uDB/r4jLDSj7F1zy6huMj6GHbK6f7CcISYGwmBi7Qnwj0c?=
 =?us-ascii?Q?xL8Es55K/oqdJAuGc82GijJU2AbzgWQ0BnNshnjubHZ7Y1+I0zK47zpJtN5S?=
 =?us-ascii?Q?md7/GlGSwuGzbIhgPyy3Typ8Yn9dzAOFm8F7YWk+sgsstSveBpQDiqHh/erK?=
 =?us-ascii?Q?5GY0cfTUHI5tzcPy/FL6fhLed2vOcIa/JHlvltFCSMYjX800ye6VAnLaB0GN?=
 =?us-ascii?Q?iHBesiqcAZ32lLfNtL4kibXhI3J8qqOvmTLztLwBu8dDBh39Nvbxo6wf96fD?=
 =?us-ascii?Q?NV/VUh7EjC/a/yp5yKNZyjypWimH/ZMo7Hsp0CcSZ5M87HkMQC7E1bCKfC2U?=
 =?us-ascii?Q?oNlKyaTnFVTcuQ91qNTSt4V3LwkiNBQbeEB2SYgNt5ZZCkNTccM3FkxaTE+t?=
 =?us-ascii?Q?P2UckW0fHpGobKNUYr5teBdpmy+JeUC1yqfFh3V6OO9tmTDPwIdUwlhJ9IDy?=
 =?us-ascii?Q?kW/S8jS4DeX2ul6ZKyj+1ZdyGQ1IjpZ3SVohcA6IclOKVpNKctjWR4CEjCvT?=
 =?us-ascii?Q?BVdtTvMCtE+5gDg1swVemiztGdKDlaNs3lm6K9v9j+NICQPkNRV4Eaz7vEsm?=
 =?us-ascii?Q?zNNKoVvp2a/ywUl4SVcM0kCo6HDQytAk5OBdc3rOxA0G+Y1EnUS565a9Fma8?=
 =?us-ascii?Q?48OLf+4vk0CZyI0BNDe+qbpoIgb8cFA5l2Ot2jL6tewe7fJk96OoDYROZNav?=
 =?us-ascii?Q?sZENwLbi5wIF//LmCWvsHF1b2IHmJLQrqMdNgE72ROgzU87+dsMX65tic2FT?=
 =?us-ascii?Q?7upbeK8IDbLHHLWb4tS+982bG8Vg9bp7t43mYmhjXzIxjuXY5aZHReGKfdDT?=
 =?us-ascii?Q?xI9DQpZvZA=3D=3D?=
X-Exchange-RoutingPolicyChecked: ok1wnXq0WErQql9rz6P8YO5/p/j2UjuJwoV8jw2GfLxQi7OptaUg4rXBDzmh9xGbtDWQA8TB9DN5dlCj5u2rTxRZYt3R9Gsx9oqpGFE8yObBKC8STCLd0tpPhiTBR8DP4pOU0PM1YRpbfp5qtfY3ajJM6cJpiiJx4MAgwYkYIXWsr0tlQ1+sBGaMHgblWytJffJev7SgspqzhCVWxRNww2lgamvMeuhX+gHfJzF8m1Ygd2YyLil6BYbpDxnb8z7vMtyZ08CT1NwQHEuGZ6js2Jf5PInks9ikp7rJnMtiGmhDQxxQQ+jQtzctRzivNkubVAs/m5HMYHdcxcI/0mLUIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2829897-fc69-4c43-1f32-08debb3c027e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 15:32:35.1460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpmOIsh6kX6eWIo9FcNgInEODr+ufPSVPfqrTsLFoRWaUSnCEGf10UcOidDbnqkrD0kdY1MMbnka2tFKa2VnDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6225
X-OriginatorOrg: intel.com

On Fri, May 22, 2026 at 12:15:13PM -0700, Reinette Chatre wrote:
>   - Adding a reference count to the domain structure to avoid the worker
>     needing to take CPU hotplug lock. This ended up being very complicated
>     with the architecture needing new APIs to manage the reference count
>     which cannot cleanly integrate into MPAM since it uses a single
>     architecture domain structure to contain both the control and monitoring
>     domain structures. Managing the references across mount, unmount,
>     online, offline, as well as worker self exit resulted in several
>     asymmetrical and complicated paths that were error prone. Locking also
>     proved to be complicated since architecture would need to initiate
>     domain free that will need to call back into resctrl that will take
>     rdtgroup_mutex which means that references need to be taken/released
>     without locking.

I'd been working on a reference count approach too. The MPAM combined
domain for control and monitoring doesn't seem insurmountable. Mostly
because it seems unlikely that the problem with worker threads would
ever apply to control domains. Maybe I missed something, but just adding
an architecture *release() function that can be used by file system code
to drop reference counts on the domain when worker threads exit seems
enough.

My patch below.

-Tony


From 611fd8ad816abd37ef9a65b39175ce05907a1d41 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 21 May 2026 15:14:27 -0700
Subject: [PATCH] fs,mpam,x86/resctrl: Track reference count for L3 monitor
 domains

There are race conditions[1] when the last CPU of a domain is taken offline
and a worker thread may access the domain structure after it is freed.

Add a rdt_l3_mon_domain::kref to track users of the domain. Don't try
to cancel worker threads when CPUs are taken offline. Just set the
target CPU for the thread to nr_cpu_ids to indicate the worker needs
to take action next time it runs.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com [1]
---
 include/linux/resctrl.h            |  4 +++
 arch/x86/kernel/cpu/resctrl/core.c | 16 +++++++++--
 drivers/resctrl/mpam_resctrl.c     | 15 +++++++++-
 fs/resctrl/monitor.c               | 46 +++++++++++++++++++++++-------
 fs/resctrl/rdtgroup.c              | 16 +++--------
 5 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..715cf62a5864 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -4,6 +4,7 @@
 
 #include <linux/cacheinfo.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/pid.h>
 #include <linux/resctrl_types.h>
@@ -181,6 +182,7 @@ struct mbm_cntr_cfg {
 /**
  * struct rdt_l3_mon_domain - group of CPUs sharing RDT_RESOURCE_L3 monitoring
  * @hdr:		common header for different domain types
+ * @kref:		count of active users
  * @ci_id:		cache info id for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
  * @mbm_states:		Per-event pointer to the MBM event's saved state.
@@ -195,6 +197,7 @@ struct mbm_cntr_cfg {
  */
 struct rdt_l3_mon_domain {
 	struct rdt_domain_hdr		hdr;
+	struct kref			kref;
 	unsigned int			ci_id;
 	unsigned long			*rmid_busy_llc;
 	struct mbm_state		*mbm_states[QOS_NUM_L3_MBM_EVENTS];
@@ -515,6 +518,7 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
+void resctrl_arch_l3_mon_domain_release(struct kref *kref);
 
 /*
  * Architecture hook called at beginning of first file system mount attempt.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..438016f3097c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -396,6 +396,17 @@ static void l3_mon_domain_free(struct rdt_hw_l3_mon_domain *hw_dom)
 	kfree(hw_dom);
 }
 
+void resctrl_arch_l3_mon_domain_release(struct kref *kref)
+{
+	struct rdt_hw_l3_mon_domain *hw_dom;
+	struct rdt_l3_mon_domain *d;
+
+	d = container_of(kref, struct rdt_l3_mon_domain, kref);
+	hw_dom = resctrl_to_arch_mon_dom(d);
+
+	l3_mon_domain_free(hw_dom);
+}
+
 static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *d)
 {
 	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(d);
@@ -539,6 +550,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 	d->hdr.id = id;
 	d->hdr.type = RESCTRL_MON_DOMAIN;
 	d->hdr.rid = RDT_RESOURCE_L3;
+	kref_init(&d->kref);
 	ci = get_cpu_cacheinfo_level(cpu, RESCTRL_L3_CACHE);
 	if (!ci) {
 		pr_warn_once("Can't find L3 cache for CPU:%d resource %s\n", cpu, r->name);
@@ -680,18 +692,16 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 	switch (r->rid) {
 	case RDT_RESOURCE_L3: {
-		struct rdt_hw_l3_mon_domain *hw_dom;
 		struct rdt_l3_mon_domain *d;
 
 		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return;
 
 		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
-		l3_mon_domain_free(hw_dom);
+		kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
 		break;
 	}
 	case RDT_RESOURCE_PERF_PKG: {
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 226ff6f532fa..15f688f18fb6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1391,6 +1391,8 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 	if (!dom)
 		return ERR_PTR(-ENOMEM);
 
+	kref_init(&dom->resctrl_mon_dom.kref);
+
 	if (r->alloc_capable) {
 		dom->ctrl_comp = ctrl_comp;
 
@@ -1548,6 +1550,17 @@ int mpam_resctrl_online_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_l3_mon_domain_release(struct kref *kref)
+{
+	struct mpam_resctrl_dom *dom;
+	struct rdt_l3_mon_domain *d;
+
+	d = container_of(kref, struct rdt_l3_mon_domain, kref);
+	dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+
+	kfree(dom);
+}
+
 void mpam_resctrl_offline_cpu(unsigned int cpu)
 {
 	struct mpam_resctrl_res *res;
@@ -1589,7 +1602,7 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 		}
 
 		if (ctrl_dom_empty && mon_dom_empty)
-			kfree(dom);
+			kref_put(&dom->resctrl_mon_dom.kref, resctrl_arch_l3_mon_domain_release);
 	}
 }
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..b4af302bbad1 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -799,15 +799,26 @@ void cqm_handle_limbo(struct work_struct *work)
 
 	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
 
+	if (d->cqm_work_cpu == nr_cpu_ids)
+		goto reschedule;
+
 	__check_limbo(d, false);
 
 	if (has_busy_rmid(d)) {
+reschedule:
 		d->cqm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
 							   RESCTRL_PICK_ANY_CPU);
+		if (d->cqm_work_cpu == nr_cpu_ids)
+			goto out_release;
 		schedule_delayed_work_on(d->cqm_work_cpu, &d->cqm_limbo,
 					 delay);
+		goto out_unlock;
 	}
 
+out_release:
+	kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
+
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 	cpus_read_unlock();
 }
@@ -829,8 +840,11 @@ void cqm_setup_limbo_handler(struct rdt_l3_mon_domain *dom, unsigned long delay_
 	cpu = cpumask_any_housekeeping(&dom->hdr.cpu_mask, exclude_cpu);
 	dom->cqm_work_cpu = cpu;
 
-	if (cpu < nr_cpu_ids)
-		schedule_delayed_work_on(cpu, &dom->cqm_limbo, delay);
+	if (cpu < nr_cpu_ids) {
+		kref_get(&dom->kref);
+		if (!schedule_delayed_work_on(cpu, &dom->cqm_limbo, delay))
+			kref_put(&dom->kref, resctrl_arch_l3_mon_domain_release);
+	}
 }
 
 void mbm_handle_overflow(struct work_struct *work)
@@ -844,15 +858,17 @@ void mbm_handle_overflow(struct work_struct *work)
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
+	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
+
 	/*
-	 * If the filesystem has been unmounted this work no longer needs to
-	 * run.
+	 * If the filesystem has been unmounted this work no longer needs to run.
 	 */
 	if (!resctrl_mounted || !resctrl_arch_mon_capable())
-		goto out_unlock;
+		goto out_release;
 
-	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
+	if (d->mbm_work_cpu == nr_cpu_ids)
+		goto reschedule;
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp);
@@ -869,9 +885,16 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * Re-check for housekeeping CPUs. This allows the overflow handler to
 	 * move off a nohz_full CPU quickly.
 	 */
+reschedule:
 	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
 						   RESCTRL_PICK_ANY_CPU);
-	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
+	if (d->mbm_work_cpu != nr_cpu_ids) {
+		schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
+		goto out_unlock;
+	}
+
+out_release:
+	kref_put(&d->kref, resctrl_arch_l3_mon_domain_release);
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
@@ -901,8 +924,11 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 	cpu = cpumask_any_housekeeping(&dom->hdr.cpu_mask, exclude_cpu);
 	dom->mbm_work_cpu = cpu;
 
-	if (cpu < nr_cpu_ids)
-		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
+	if (cpu < nr_cpu_ids) {
+		kref_get(&dom->kref);
+		if (!schedule_delayed_work_on(cpu, &dom->mbm_over, delay))
+			kref_put(&dom->kref, resctrl_arch_l3_mon_domain_release);
+	}
 }
 
 int setup_rmid_lru_list(void)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..a4830a2364da 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4332,8 +4332,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4344,7 +4342,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4524,15 +4521,10 @@ void resctrl_offline_cpu(unsigned int cpu)
 
 	d = get_mon_domain_from_cpu(cpu, l3);
 	if (d) {
-		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
-			cancel_delayed_work(&d->mbm_over);
-			mbm_setup_overflow_handler(d, 0, cpu);
-		}
-		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
-		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
-			cancel_delayed_work(&d->cqm_limbo);
-			cqm_setup_limbo_handler(d, 0, cpu);
-		}
+		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu)
+			d->mbm_work_cpu = nr_cpu_ids;
+		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && cpu == d->cqm_work_cpu)
+			d->cqm_work_cpu = nr_cpu_ids;
 	}
 
 out_unlock:
-- 
2.54.0

