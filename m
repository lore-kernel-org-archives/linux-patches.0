Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AFE3D904F
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781042309; cv=fail; b=KNPNlwTjmWXOG4Gd/C7psGBNg4mCJaGqhMmf7VJwvx0TUosnD8hUY/JnlCdNxcikeQZ6KXWImH9qMQ5oC5EwrxGQP7+E+FQUukhS0LiVsO2WAUJJoKy0awzyR1Pb8D8/C4Eax9cMQda5FC7DD1yF5ufSetqllfqgfEwZbSa4KlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781042309; c=relaxed/simple;
	bh=XFeauyfygLQD2btvhvXJH5KUne9B72493Not+l9uXhg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ko1fEsvVQkpQUKSxErskJlZpuLhh1brHCCzYdk6xBeVXAAT+qL+/wnCWIXMDI+f67Ln7C0nzKT0yso32hEdxgQLJLPWaff+egcbARUxB2w0n1ovSpF2pLuR1uynFXfD+jsyngylCaahENOwuj0TJ7HGD0ucVnWvIuoWAl8vCbZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=biArk0ZU; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="biArk0ZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781042305; x=1812578305;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XFeauyfygLQD2btvhvXJH5KUne9B72493Not+l9uXhg=;
  b=biArk0ZUAmplXIy+Y+9HbWNKJEziPdiFuG5muJIVLA1unOiAfitqBoJ+
   nkaoEfoDMReNkUtEr/V0CiYMOWRLNO9cXuqothZgcnAJJE5Qm83VbhmxW
   Z4h7W0CyeyAGWw0Hb7fnN188rCX2g/LT6RO7cUs+ncVx/Bpe5P4p7bT2X
   yy/PJKNujjXbWFMG0xkKzR5bYBWeGWnVo0wz5ESvUQisDQ3RX+ProgBCm
   osR5+YdYlvmRuYAlNijIBOaQDkjM1PnQA/P/JOlGyOxYaw+u/Y8oUZYWL
   5/xJ5WK4419Qz2dNqaBAKDK+QieIwT3AGPn6tylgt63Hqub6V+PlIrWwg
   w==;
X-CSE-ConnectionGUID: jfycpPZUR3+TwqCWAbxbXw==
X-CSE-MsgGUID: zFlFod7nRQ6uJXzO7U9iOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="84390967"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="84390967"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:58:24 -0700
X-CSE-ConnectionGUID: MV9JmI8aQ/mvlC94L0zg/Q==
X-CSE-MsgGUID: NVjCAIOuTnGKahI8DzgE/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="247835281"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:58:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 14:58:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 14:58:25 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 14:58:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhjQvknG7t5HACK5o+j++Ir4zBTk1HzVVqOhtwnz/wGo4JPN0P/l8htwcdt88Gu0aekOM0P+DWCXlaH41FdPcYUsDQosB6ccIWrZuJpj7gEqnHToW0Dd65t+BCrhntz4u7JtSOxWAfnjlx7U0roy10QBZJi3515HUA6on0gL90pDNZN+GK9BXmmQdkLHJNXmvFqj4ZXqd+iIOO4lrmF28nEmvRcND5GrG+Cyo5ZIUrULYUle4wybKvMChnIdNIoFLqweOwSpHXQnDSLH0rcjrK4WUGiSqifxOxqBjdXv2u95I7xTGzf1PPXOZ2Sswhv6KG+/5HrS8k2ApedsCdsfLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QlU4ZWwKRpjoUjOmrSqJjKIiJmGa8ivSgD5jXsPFsI=;
 b=OOYoMwC4m1rm6QcMjSX5R/mXfUtIWUTi7AW8EMX59tBXtt1JjC74Av5oQ9XchlqHflSCpta8fI5/Rf4+yKKCdb8MvYuX7ybwNPnf8DinEqvXgP9vTnTx+0PsVccZ53YH3s89dPRHKjpcTVYqWiMdZm4wlD4kEuRwGplEmbtz3CuZ91IqhrZXmY54A52PLP6l2hG5EX30JlU3bq9QzsQIVnaU7DHRMmC9UuA9LJ4DayLVNA2fYhsrHSYPtiso6satybuPM5auK+Dq6qWbRZqqKdCrcNiQNV64oaI8l2uh2tjuvzHaweoQzsnXO/At43Q4uhnAHV9QWQ4VTacHSLej+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 21:58:22 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Tue, 9 Jun 2026
 21:58:22 +0000
Date: Tue, 9 Jun 2026 14:58:20 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 08/14] fs,x86,mpam/resctrl: Handle change in number of
 RMIDs on each mount
Message-ID: <aiiMfPwk1oDD_2MI@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-9-tony.luck@intel.com>
 <2cd8dcac-9257-413e-b345-7c78bd77043f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2cd8dcac-9257-413e-b345-7c78bd77043f@intel.com>
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH0PR11MB5314:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e9a6e9c-cc0a-4a3e-3945-08dec672392d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|3023799007|22082099003|4143699003|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: JzU92hZApz8OH9nd1k0JsEMVVDLHfSeGyYyVQlKk0wVQ+X9A3tpYZmVHmBJbz9RH/Yx9Wrw4r06dY16DeOk69P/kFYMg+qE7qhHIgsr2RKK+snVD2j4Zqc5FvDJbKaBeA7d2Bvq0J46B/IaTVyoAhnlI5BLmEg+Vwkzrh7C3M5xtVC5Qqv5UHv0E9YVHBA1eFkde6ncBKlLubmQQaLDtok2HSl0HvMaW/zm9pqiNO9e2WV6knc76jB8dgh1V4N2hb7va+OAmF91/Qecl+mvJj9aFf1CblVlmwNgP1n83Lw1ScHFWGPJV47MNbo9ajlI96FX2Es2X9zbUrOTkzpHl63458obQu0TyjmUtdHFZv2oZ3nvSPAwMQ8w1hyVi1lbqjQ2W1PP1N7VsZ5QxSibxsbFeyNl4KCtBqXd3CaLR7gkwEcijIzIucH0J/5b3QaG5gJFMJmMbrrWgLfnnKONVAk5R+wfDP4zA9oKm1oxQVRLJVglmt0JUje9qQRgStA5w4yxGOncxXIS+VEZclqn4tnwnwHfBVbpmFfWcasMgOFsSNRCM6/J4pg6MrVM8cyMSLf0noMehIW2UHdC/3KTyxUFHEFSzofmf3ttOFaSP+SbKrur4fd01o5d1QaVVVeuNe8FYmLolt8OKVRuiMV7XAQYjDg1yXyq+g+gg5kGYR3gTlZa7PsbpSUxJGBAy3QLZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(3023799007)(22082099003)(4143699003)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nrAdy0zzQSGOY1FaGDWANmvV7Qw5rmyfCttuSPGeu9IXHf5X3EdjefUQfA0N?=
 =?us-ascii?Q?DJ4QX6oYEFjBTzKyZlzPlH0tKrOB4EQMOdHQYieDeBGrJ/0K873Kspo48Xa/?=
 =?us-ascii?Q?b9cFC0/7Z1nGr9STKe65u6yrtzN+8dAlifxAzNooJndIP3SMj7R6s7bJyyEw?=
 =?us-ascii?Q?5WVmm268oI/VIISyFjSjETIR1ZP6u0pfrHBv3ixF85bm/l68h5USE48tNIgk?=
 =?us-ascii?Q?IwRNvd8nW5sAM0e6t+RqbGgDZ8Nh5ybaPIyGX2kWo/vzla35ISRa5d+Pfjk+?=
 =?us-ascii?Q?1OX4chzQPdAibykxYqaD414lf7kPgc0AUTWOPUsUzla8fanddD15a1V64/zH?=
 =?us-ascii?Q?YI3myMCM5zZ+Dm2EP2RJvDy7JO8WO13Eg85InKAXu9RuoRO4ysXeU6uH25T0?=
 =?us-ascii?Q?YX0htflA3j4k+Bf5quxhKp/9LgRZ9vXwKdMb0W7Ug2KBPFDGdrVYJ5ayRIPm?=
 =?us-ascii?Q?MPFun4iorm9LH9N5vA8zYI17dzd86i4OYCveH90boo68tdb0PUMkHILz4vmQ?=
 =?us-ascii?Q?16579VWgwEeOGIm7UlON9J21JhbZvXRGCQofCvVDEBWhGw00FqSCpNW7S1Qq?=
 =?us-ascii?Q?PrhxwsmZjIpC1mpA/39iX+ipOpyDXxs8o0DkIO7BFWZsFTAZ01/gq5wHPRE7?=
 =?us-ascii?Q?g44MrHwG9hlpdEzW5fZPPDyU1XUb7+YiuuXF6qpwdxc7p8TaGd9tFHKqU1Yd?=
 =?us-ascii?Q?LKwacQWmfJY2hsRr55PqyZixtfPrDjraQZXeN7SxlC3Jq+oOX3C+YyU9sald?=
 =?us-ascii?Q?ZL8S504jkUYTtjMADPpTC86L+09BQ/b4SXOlmD0q/p9W7oWqSdh9zPW1kdcl?=
 =?us-ascii?Q?g8fcB+0nVTPzSZOKnzHtvtpbO6U5xUIkKFaALKN5iF3AaegbJhLbZ1vuMQyz?=
 =?us-ascii?Q?e0a9wND1jU6orx6YcwFdeSp9gwJJ6tYoggFL7E+hE2UW8LQ3fB+xQJZRqa9A?=
 =?us-ascii?Q?dODdvqi7nAsSCjJ3v2UnTfpHqv6mlLe40LX1qSj4RPR9ObUzehtehgKOHKxc?=
 =?us-ascii?Q?7orroXmLzG719ZFXSo+9T7hFmHMELQjSolZExpPsE+/s5TLlWQ/KsXoVFDYw?=
 =?us-ascii?Q?D1tjpNleGrhodTclvH21gnUhyXQ0twNfmKVgykBVNfmBwlHA7c/Irbdk6zXQ?=
 =?us-ascii?Q?sfvBh5m7vQC/6ZU1kGxCD7YJ9eij/tCQ9bROksE0wmC4610T7H80w0WJt0lt?=
 =?us-ascii?Q?oVmGiIGpJIsnzp6jyE7bI61KQye5hGzspzcG2QuKPX0JJIM5kWpFT4iL0aBk?=
 =?us-ascii?Q?H8tM+sDy99wIH/rb9KBtldGI4+LF8icdRLXmlT0UmiK9FBZYJhKMZbEX+L9y?=
 =?us-ascii?Q?6oll0u5HKRsWqhMM+S7RL1JdBSqjSVTSoExC3sbEhm1dmXJGnFe1soS5oLsM?=
 =?us-ascii?Q?JtmQbySwvLJx0/O+rHWEC3ftdGSoMpG0CteIL6krvyqexw6pbIpf9A07Jpmv?=
 =?us-ascii?Q?hvkiqFNgeLoYDWkA3xaTPv8l3Maz7OZHRnVLkEVoO6oMcvU8iI3O15UaHXec?=
 =?us-ascii?Q?PCRhpG/QT0yDgDsqD0ldeAOoIs3yJE1noHORrsSdZLY1cE1o8pSq4NckZl7T?=
 =?us-ascii?Q?DtMEAoEVzigoDphxQUsNlP7r3DZZHZyYiB2StvDMlMFEad3kY+VO08x7XFD8?=
 =?us-ascii?Q?arkdWkZER3+9kdI8Sq/LJF1OYZtS0IiBv9ySV0o+vDENMMoVIFy361dYcsE2?=
 =?us-ascii?Q?08p/UdPpbwKo5FKJIpGL2HvxcH1I4OS1Eh40HbRYjA4jkMS/zVxL1oaaq31m?=
 =?us-ascii?Q?SE8K9q9zjA=3D=3D?=
X-Exchange-RoutingPolicyChecked: Np71yp5t68FO8cP15qx3kdcE3acg4+P/V2MKfg77SM+VXGQyGsfhrnQbjdti2uOSNHe0pG6075iXLXHfa6hEDue/P3C8UYKN3D2CeGUHW3FUtrPsyENP5G5hn6ewrA+mod2PeZmaPq6QVd61rJTb5ItijU+YZM73MdnoL8kjfBW3dEI8Qm9qC/d617x+OJtiy80+GVn03qdG8VnwSCiXRzHmL/SDdbtR+J1QdDHSHV5M9EZdCO3ti8oQwDBCf+ZtwVxKdAxz4q5pw098EyWbouNf/nDr2Hcm/eUhNNNX7jBiX620Y0DrAyg54u0Xv6tqBq1GVX4ZfI+41HTyXgn6dg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9a6e9c-cc0a-4a3e-3945-08dec672392d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 21:58:22.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKrZ4B7dadDlgkJzJ52CmKtXdUh7Kr69Rv8NfGTrEb80Zsq408NP3REv+moSfg3R/K8p6tt2s4W4avKp+BzA1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:21:10PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
Changed the Subject: tag to "mpam,x86,fs/resctrl" to match what you used
for the RFC discussion. I think the implied rule is "architectures first
in alphabetical order, filesystem last".

> On 6/1/26 12:56 PM, Tony Luck wrote:
> > Application Energy Telemetry (AET) event enumeration takes place
> > asynchronously. Linux builds the pmt_telemetry module into the kernel to
> > kick of enumeration early enough that it completes before first mount of
> > the resctrl file system.
> > 
> > Allowing pmt_telemetry to be a loadable module means that it is possible
> > for different numbers of RMIDs to be supported on each mount, depending
> > on whether pmt_telemetry module is loaded.
> > 
> > Add resctrl_arch_system_max_rmid_idx() interface to provide the maximum
> > supported number of RMIDs on a system. For x86 this is RDT_RESOURCE_L3
> > rdt_resource::mon.num_rmid (if L3 monitoring is enabled).
> > 
> > Allocate the rmid_ptrs, rdt_l3_mon_domain::rmid_busy_llc, and
> > rdt_l3_mon_domain::mbm_states based on the maximum possible.
> 
> This is a significant change to data structures expected to be
> indexed by RMID. Could you please update kernel-doc of these members to reflect
> the new usage?

Will update kerneldoc.

> 
> > 
> > Initialize rmid_free_lru based on the number of RMIDs available for
> > this mount.
> > 
> 
> Above three paragraps writes verbatim what can be seen in the patch self.
> Could you please expand the changelog to help reader understand why these
> changes are made?

Will rewrite.

> This patch is quite difficult to decipher when one only has the code to consider.
> 
> > Note that some RMIDs may still be marked busy from a previous mount.
> > Don't add these to the free list. Check current RMID limit in
> > limbo_release_entry() and do not add out of range RMIDs to the
> > free list.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 1af8f965fdd0..934492c7e643 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -129,6 +129,18 @@ u32 resctrl_arch_system_num_rmid_idx(void)
> >  	return num_rmids == U32_MAX ? 0 : num_rmids;
> >  }
> >  
> > +/**
> > + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> > + *
> > + * Return: If L3 monitoring is supported, largest possible comes from L3.
> > + */
> > +u32 resctrl_arch_system_max_rmid_idx(void)
> > +{
> > +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> > +
> > +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
> > +}
> > +
> >  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> >  {
> >  	if (l >= RDT_NUM_RESOURCES)
> > diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> > index 226ff6f532fa..7079870ca894 100644
> > --- a/drivers/resctrl/mpam_resctrl.c
> > +++ b/drivers/resctrl/mpam_resctrl.c
> > @@ -272,6 +272,11 @@ u32 resctrl_arch_system_num_rmid_idx(void)
> >  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
> >  }
> >  
> > +u32 resctrl_arch_system_max_rmid_idx(void)
> > +{
> > +	return resctrl_arch_system_num_rmid_idx();
> > +}
> > +
> >  u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
> >  {
> >  	return closid * (mpam_pmg_max + 1) + rmid;
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 327e7a863614..b374e2f84a75 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -115,10 +115,17 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
> >  
> >  static void limbo_release_entry(struct rmid_entry *entry)
> >  {
> > +	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> 
> Having the code switch idx_limit to sometimes be resctrl_arch_system_num_rmid_idx()
> and other times resctrl_arch_system_max_rmid_idx() makes this change difficult to
> follow. I think it will help to use different variable names to differentiate 
> the context in which it is being used and not leave reader trying to understand
> why there are *two* limits.

I'll change the local variable name to max_idx_limit when dealing with
the max value rather than the current. setup_rmid_lru_list() will have
both variables since max_idx_limit is used for allocation, and idx_limit
to add the right number to rmid_free_lru list. Added a comment to
__check_limbo() explaining why max RMID is used there. I think the other
spots are easy to see why.

> >  	lockdep_assert_held(&rdtgroup_mutex);
> >  
> >  	rmid_limbo_count--;
> > -	list_add_tail(&entry->list, &rmid_free_lru);
> > +
> > +	/*
> > +	 * Limbo may be freeing an RMID from a previous mount where there
> > +	 * were more RMIDs available.
> > +	 */
> > +	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < idx_limit)
> > +		list_add_tail(&entry->list, &rmid_free_lru);
> >  
> >  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
> >  		closid_num_dirty_rmid[entry->closid]--;
> > @@ -133,7 +140,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
> >  void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
> >  {
> >  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> > -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
> >  	struct rmid_entry *entry;
> >  	u32 idx, cur_idx = 1;
> >  	void *arch_mon_ctx;
> > @@ -192,7 +199,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
> >  
> >  bool has_busy_rmid(struct rdt_l3_mon_domain *d)
> >  {
> > -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
> >  
> >  	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
> >  }
> > @@ -916,24 +923,32 @@ int setup_rmid_lru_list(void)
> >  		return 0;
> >  
> >  	/*
> > -	 * Called on every mount, but the number of RMIDs cannot change
> > -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> > -	 * until resctrl_exit(). Note that the limbo handler continues to
> > -	 * access rmid_ptrs[] after resctrl is unmounted.
> > +	 * Allocate the largest number of RMIDs that this system will ever
> > +	 * need. These cannot be freed until resctrl_exit() because the limbo
> > +	 * handler  continues to access rmid_ptrs[] after resctrl is unmounted.
> >  	 */
> > -	if (rmid_ptrs)
> > -		return 0;
> > +	if (!rmid_ptrs) {
> > +		idx_limit = resctrl_arch_system_max_rmid_idx();
> > +		rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> > +		if (!rmid_ptrs)
> > +			return -ENOMEM;
> > +
> > +		for (i = 0; i < idx_limit; i++) {
> > +			entry = &rmid_ptrs[i];
> > +			INIT_LIST_HEAD(&entry->list);
> > +
> > +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > +		}
> > +	}
> >  
> > +	/* Find how many RMIDs are needed for this mount */
> >  	idx_limit = resctrl_arch_system_num_rmid_idx();
> > -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> > -	if (!rmid_ptrs)
> > -		return -ENOMEM;
> >  
> > +	INIT_LIST_HEAD(&rmid_free_lru);
> >  	for (i = 0; i < idx_limit; i++) {
> >  		entry = &rmid_ptrs[i];
> > -		INIT_LIST_HEAD(&entry->list);
> > -
> > -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > +		if (i && entry->busy)
> > +			continue;
> >  		list_add_tail(&entry->list, &rmid_free_lru);
> >  	}
> >  
> > @@ -1156,7 +1171,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
> >   */
> >  static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
> >  {
> > -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
> >  	enum resctrl_event_id evt;
> >  	int idx;
> >  
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index d2a1f88d8782..6d647b71c5db 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -4416,7 +4416,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
> >   */
> >  static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
> >  {
> > -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
> >  	size_t tsize = sizeof(*d->mbm_states[0]);
> >  	enum resctrl_event_id eventid;
> >  	int idx;
> 
> Reinette
>
-Tony
