Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E72448BAA
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788292436; cv=fail; b=kZwDgLTZLfBBwB0MEeEFoupsJu1OXJnCkJ/5Di9SbgCS+aLec45givYaF0LjRsQyUaXUF9qjA9moICj83/H2LVrPFVnMkAqnEUsCR7a+5hhbFSEhesydvWwfvomAlHksBCuSNl3gW+WRt2oGaUke9ADCvImZ1vdXQvL0iClTeA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788292436; c=relaxed/simple;
	bh=hB7I6Ul/zhKA1gWxtZU44SW8DVIy1kbewuNIcAO4y34=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h6J4rQ1wH7AHOA8ztepJ/5VaqhNRz1LLJmmljX9in9nFouBzfRn9HPVcpeGZqJeuoWQYKZlZjRTXMF00vj57JBA1Kl1O+8AJ9VKEVSfJtMq+mzYQTq7+YlRHuaUI+AHdAxoQqKHkan4Td5w2sVf1fH45h5M8ftNcgczVMq9PpKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwxslat+; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwxslat+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788292435; x=1819828435;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hB7I6Ul/zhKA1gWxtZU44SW8DVIy1kbewuNIcAO4y34=;
  b=kwxslat+4OgPgU5hVibsWOIb/2BNdDubFZnKPF1+GlDoqJPNyYtr5479
   4xlbgNFsxhWGxdZY+yPuIW1CPux9xG/oHbNOtGfziCH+ZpMtMLQcTmA5u
   TE0IhY7VI1XXUHCDSunRFWH30x5SQDHcomEwxAgRRzB67V1crXDF1GXo6
   MMJc9Mt4aHtmiFyWLl3vC3MeY3a3tbJ/hUw/iqjyJohCds1Sc9w2xsXIp
   s8UOuhlGGWTMltHNIKATbyF6HLHERM/MwH/wnjGz3p+LDrdxuETwfptQ6
   /OVan+5WrZAqe4SZJt66bpibBu2+BlI7io5ZqU+KM12CLAarXKGijoAmv
   A==;
X-CSE-ConnectionGUID: u1dV1uJeQu6aGvCfEQ6UMw==
X-CSE-MsgGUID: 0E0e+IkMQe2nDi/On99jGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="92434256"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="92434256"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 12:53:54 -0700
X-CSE-ConnectionGUID: V9J423BOQJ6cQ3vOtlrdtQ==
X-CSE-MsgGUID: AlE1rFJfTja4u3MXa42TEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="273377566"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 12:53:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 12:53:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 1 Sep 2026 12:53:53 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 12:53:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i52M8badtHmqlse5oO9UWLBwK4tkJ+I/IdbAlyUP0ZLZeWRvCz07WoZVIgr0PpkMktJOhb9wGpTEgj/oKl19yBf7P2QnYY4eVsDXrE8CN9gW/kCyGAIbQpAFTdU/fJwSGNQXFETWvAOCcHCvy7jmVdOMJus1Z0nE0Z7A8MPqgimTeaaq2RGd87v/emV6FOJ0rIbTfGmGURwm84s1CYXNwaivGX6WH1FMlIeGgnVstHiFozguwnjqmjix3jyPUB/adDIup4mdSK+/KKc+8YPz3lZPJFmvKgvDAbju6nSS7ZKnwnTFFtn7uoa8u0SIQpDTG7HBuXjlyBw4iPDVIy+ZgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtsq2opq+MJhS1AC9NwLwoT3NQWEMKv2nz4Hy7NafWk=;
 b=nHuQ/9RP+2+SIBxumcx0q4wf5nqk2vM28/cVaNdC8J7UnD+Ds24FrnDKd3D+xfcdLUd8Xa9AyCuxEatpxQzmqZvyrA0HpWnWlqor9ybPtortHbBJaDEKNKm9gF8EqGTMs7D6VgvSWDAyZ3IxSxuSzh5o9/y8YF5Z5cbUp2hsnNbB7L2XU5sgHvon7DumS8nEKKNGpzW1HXil5bUOG+bI0vQ0rIra39PSzxq5Usw6jWreBP/sh1XGX9ND9CWNWRuNQ3MZR7FBT0kbd8OgN53U1Cwo8lq4KOMyFB/pua57gndF9QcGk6o+mlu/Xpb+x0hz92bPW7Mbi/vtMc5f397zfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6977.namprd11.prod.outlook.com (2603:10b6:510:205::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 19:53:48 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 19:53:48 +0000
Date: Tue, 1 Sep 2026 12:53:46 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 00/23] Allow AET to use PMT as loadable module
Message-ID: <apctSv5HELB0wJZ1@agluck-desk3>
References: <20260831174421.13921-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260831174421.13921-1-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ec83984-5b5b-4e58-c5f2-08df0862bd02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|11063799006|5023799004|10067099003|56012099006|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info: vv4jUxIdaA6xHuKGfA17yPTVZ6r00+9UuqOsNLgEkWCldvzjLVtCrNBLuZ/te/JSM+mAFB9dZSb7DQMuGkjqlTzxLuOI5ZWiTrwv19CO9pI5RzflaJbP4ihpAKRa95ymTlFFWs8emMCK5lsYT6JcZioH3W4DhAS3WM7B8tue4BgYH/oCBXtOiDxzIN5J5fj/Bf+SkKDp91LFRS/+VDBPMXq2c+lpLUD7eMJ5EVffQYPwQY7MseGyHn9Vspk6XbuFfEfpMZK6JGCkTJDHWek4NcLbvuR86Nj8QzD0kE3dQk4cJfqF9/LLc/7OhW0TiTfcgQumeZwXI67FFgI94sFIV0VRBPoeBS/QuAaueDz5YBBzTpE4+2X+xeZ6r/5Hi5XvdRbcm1Xlo07sGc7qnrStLjEHpeQVEddRSgrDhN8cg1eg1kuw8Mo/C6t7osv5r+zR0Lz7tcxB2HocIS3zu4aVXDOEvWPcWC/sVSVazS/u2nuOa4bULoSOuBLulilBSSwbqeUOclGCWY07Vx7+Hs5i1F7qb8KRIIWoFDcTOFa6U7lVJJVRvWd17WQSwb9Q8rPydwWGWleyq7oL/BdtQyAxAE0CDbpwOVu3uR9aKQ5L3wmCRoCyUOZ5SK+6eVJKtrW4wqSIz0mijoiIjh1BeRuAfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(11063799006)(5023799004)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bMo3DxcLkoN2X8ccTpdYEPJ7iHZYKLDplsC/XzMtDxt4SRJT8M/I4cvhiquS?=
 =?us-ascii?Q?NWSWwhHMfWF+1OevDkWEmYB1GJtC8y7PjJz1bmZBzK5t27IN5UBYa6w9/IBn?=
 =?us-ascii?Q?oo5XmQp44BBVLQhSdBGrVPP4+ul7bVB/iKtDDRuvwLZQSVFyCqupQS3A4W9W?=
 =?us-ascii?Q?SU9T2IFpAhBQOkv/79K9LkYEAq5Yll08vAjSAYvo44KP0hl/4xPtx5DEDB6V?=
 =?us-ascii?Q?4Gi4UP/Df3wOfChlGeM0kndNC3cx+3qQ09sSYmgJ9Q757QyVADXamCEl3q/V?=
 =?us-ascii?Q?Zg9FR9XNIS0hdY4IGKNRtLFtcOF6eAxbpFo7ojr5Zok5wiLnvXroU+qb7WTe?=
 =?us-ascii?Q?2Lqrd8wnJ1QWsXogSylYIdBPTAG+YnqfzgTRORwkS7mdZfMP6zf5OKjbze59?=
 =?us-ascii?Q?GMA18NZBzfeYV2Quw+1+nOqduPR1cWkQwg6qqau//me/p763h9Z+P3atsBKD?=
 =?us-ascii?Q?0Y3Qms9pBrfTHyPvmiYxuR6jeqTQlDq7I4+6Ldre5/bsXACtGFkGNljgqixA?=
 =?us-ascii?Q?DapzgwUblW2QmSAsedRCFX/fVLmHtT9hVLCPRau0+IB9gu8eCrdzzpYcxyzI?=
 =?us-ascii?Q?ypsJB9Ktgr7aTeyFk1mhnRmRwUyFA1IzpB3K3X3zHJxyYqSTHUzvPgj4L6ZL?=
 =?us-ascii?Q?MD2/ahDPHrCPWfrE3PdqkQQ0epySNJzlGXE8gSofqSSw0zWNkYCUK7DEqnhp?=
 =?us-ascii?Q?3nZFd2w89iBEPVtZE6AU/nXn0DD499FKu5apD3vXXzDAL2idn1j7nGOK3uDR?=
 =?us-ascii?Q?rSBHg/D0amBApr36jBc1Kq6U7OT95RKOut5whwZ9CLof95MwKOzHjsMO5vgO?=
 =?us-ascii?Q?wgiXizYA8TWfQ/R4Zus7XkYxgQTpcdiRGYbu2tUFfJ99spS85TWkgrvykhEL?=
 =?us-ascii?Q?rtNT4pq4zfVrYYMQbvzJRofZweYO6DJ3Ot2sVwfaIpmOOBqOmf4MM2w/O4S1?=
 =?us-ascii?Q?QSb13wHKd0qLf/dUx1P3CjSdKad6SASemNx1Z94ReecU0Q9l5DOnLe2oRgVS?=
 =?us-ascii?Q?fEWVfkMbxVndUyxFQj+tqm+roiIKqLlWd8GX2SZOPa4xkofFIhAC3GRsBcWy?=
 =?us-ascii?Q?LCOia3v/srOKwGw1/129kCm//arje6+ZVTwDKbhKr4FsA44+IDFo73Zs/OO8?=
 =?us-ascii?Q?vydhA67gzAdXwYRENQQPg4Fl9hiidk1ZyyFvWGiseULyNnlUPzJUJ1mSeVKs?=
 =?us-ascii?Q?NmM3XTk6ek2bqK8jHc2wFlqVFiM03QGF/5D6gRbKDF9uKtZqjTzI1zfPMCnn?=
 =?us-ascii?Q?9B/Ie0I6dFX9SwTj1d3rCcV8urR0XI01xwzjbPFLM1l5pbHba2QX8n/+wo6j?=
 =?us-ascii?Q?6hPlEOcBfc5e+AimAUTEec1J4bjBkG5oM/MKVOahMUYaDBF3yXxfIZZ2mzHD?=
 =?us-ascii?Q?RRO+rJ/HVExBCQ8gUPF9dfHMB20h4nsahtWxlgsOBX7NGGwqLd3FgdkfzxvI?=
 =?us-ascii?Q?s6DHfnzE+PkSpaMr8tgzw+qPSFznGK43WqMfbxNKSPqytsPEpWxOf/cc8Ore?=
 =?us-ascii?Q?JUq6THVxzJvCGVGQf3PiRtONg8NNyZX5hXvp2nguJ7IgnY27FabswRCQGd+9?=
 =?us-ascii?Q?ltZHvVSbeA1/DKndMauTVOtPogLouvM1suBvHikcMsEfGkURWdplWdldteU7?=
 =?us-ascii?Q?ZX0d+78Zp3XwotL5Cd+KQg08JqM5gne0YXYx55tOAGY7JGLcO4XbDcm78zb4?=
 =?us-ascii?Q?WMTeQ7P+5Adhfftm/h+IrV/dBo8EE7xwl6+8yT1zFeQ7QaflG7AXNcZTH9FK?=
 =?us-ascii?Q?SGXcOg8g4A=3D=3D?=
X-Exchange-RoutingPolicyChecked: 2wFbF3Ccqhrvn3FpvCK4EIyvnzDlLmfFStVBlFFb6rpDFJ2QSj39mFaMD3U/d83DP9OMyz2XYKuMMWesfyKRBmcyk9XEMHEolJ9bVBe6wDTUx1SEcDpryWUYqjlO2UzjXFxfz6VEtlulmaYPB6U8ABNlMoWhuWbQ2bfW9wFjq1YA0/Tit9znJ2pp1Q6xdrflxklwfFcDPXcF32FJsd0MCjjsJkxsSTqQNNX+KhUdt0xB/sBk0GIiYObjmwGkvawlHDB3YHuPyegXgQWaoHNnFjFlRfRyWZhZ0oC1vyJ3q+FgCQu2QoN4cFWHrn4XtdaCnGVINeyt5ge+FuquZEbSyQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ec83984-5b5b-4e58-c5f2-08df0862bd02
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 19:53:48.3694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwhzpVIFHx+xCx7DB5seOQG+g9BHC58NXQhaGvA1t+miMr2W/c5PN4bWcW0Ttxh5JjPjWXmWIHcTjIy9+wfuGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6977
X-OriginatorOrg: intel.com

On Mon, Aug 31, 2026 at 10:43:58AM -0700, Tony Luck wrote:
> Requiring INTEL_PMT_TELEMETRY=y to enable AET is a functional workaround
> to enable enumeration of Application Energy Telemetry (AET) events, but
> unacceptable to many users. It results in increased configuration complexity,
> increased kernel memory footprint and inability to patch problems by unloading
> a module and loading an updated version.
> 
> Add a registration function to the AET code that can be used by
> INTEL_PMT_TELEMETRY to provide the enumeration functions.
> 
> INTEL_PMT_TELEMETRY can be loaded/unloaded independently of
> resctrl file system mount/unmount. Perform enumeration on
> every mount and cleanup on every unmount.

Summary of Sashiko findings:
https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com

 [PATCH v11 09/23] fs/resctrl: Remove redundant calls to resctrl_mon_capable()

Pre-existing issue that systems supporting only monitoring will not
report any tasks in the default group. Issue is real. Sashiko suggests
removing the check for resctrl_alloc_capable(). I should have done this
anyway for the same optimization reasons that I removed resctrl_mon_capable()
from is_rmid_match().


 [PATCH v11 16/23] platform/x86/intel/pmt: Register enumeration functions with resctrl

Pre-existing potential race. Sashiko suggests calling intel_pmt_get_features()
under ep_lock.


 [PATCH v11 18/23] fs/resctrl: Call arch code for every mount

Two broken bits, both with easy (I hope) fixes:

1) rdt_get_tree() should "return ret;" not "return 0;" 
2) resctrl_arch_unmount() called in error path before cpus_read_unlock()
   could deadlock. Move the resctrl_arch_unmount() after the unlock.


 [PATCH v11 20/23] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed

Sashiko is concerned about non-PCI telemetry end points. Not a real
issue. Endpoints are enumerated using PCIe DVSEC - so they have to be
PCIe devices.

Pollution of kernel log with dev_warn(). Ilpo also flagged this. It's a
"can't happen" test. I will downgrade severity to dev_dbg()

Pre-existing issue in telemetry driver that other places need to handle
unbind/remove of devices and unmap of MMIO.

 [PATCH v11 23/23] x86/resctrl: Document telemetry mount timing caveat

I'm still struggling to come up with a systemd/udev way to delay
mounting the resctrl file system until after telemetry enumeration
is complete. Sashiko says there are gaps in the example I provide.
The whole namespace issue is a mystery to me :-(

-Tony
