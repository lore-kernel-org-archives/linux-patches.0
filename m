Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9853E37A3B4
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761839660; cv=fail; b=ETfuziaME52p1SHCr3zJXx8k+MhH/2tiua/W5hZyUjo2qDo3r9ZGTN2OsdAHuvzCKnU0a96wv28P0OHTb3YqLSU4EnR5doBNVaMVB8Psib1tul18ZWESqjkrApWt3O+dZEJCTCUSuFKkuVqu2tEcJt9cr3iKGOeByMzZjHXIF2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761839660; c=relaxed/simple;
	bh=80vd+0jLD41k4u59RxvGlTD1lUBpY2gj/vhwQ7SSWv4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EXz0G9ajnw27yIAWXxFhnIJB9dASRlkZveSvjtgHzk9I6Dxp1QmY6NgMPyGdcp0eILibNUpUjt+ubefAs/cPs5a1sMEtC7inmUuNl/ytNixj2IIrrMxrvScRq8yP+MgFF6ckvsamWBzMvzKAQtxwJ1ed4jCL6trySoax6krGRys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QecLCDYp; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QecLCDYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761839658; x=1793375658;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=80vd+0jLD41k4u59RxvGlTD1lUBpY2gj/vhwQ7SSWv4=;
  b=QecLCDYpkCcuCMGsnqAfUxXFYlhpoypASAiJPqjCEVBwhoIPORQAZMCf
   tMwu78T/Q9iBP05kLNvQX0ES7NrpICuIzLy0baktakhGgoclOK22Ps2WI
   CQve7tNmfySZg0MJ8s/AdG15p3GdoyyLwkTckTa123h9ddx5M8idTO7Zv
   MYWNf3zNoDhI6TloNdJ9HPC749Lbcuu0/SnSStIjTaLUC93gzS4I0RCIj
   zGdodwETY77T1mlKcOSTRloPccyjxb4Vk2Nvs4w4zLfmeBG4mtcKTdUZ3
   jvJ/Qgdv7iFk1+O0AIka23vbafc20ocZ74gI4eu8zz79em0rd9pYUUNnW
   w==;
X-CSE-ConnectionGUID: B0qYAWL6SkuaitUoymSh6w==
X-CSE-MsgGUID: NWhk5nTjR3CBi1F25yuLOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="86612462"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="86612462"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:54:18 -0700
X-CSE-ConnectionGUID: 6sOkLO4tSTyzT73QOu5M4A==
X-CSE-MsgGUID: goq81g+8QPeLN4F1TsF/vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="190061197"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 08:54:19 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 08:54:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 08:54:17 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 08:54:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiRoCzdwp+gYwt+6Ze5XbsExOq1O/pvaGKsAgxpy53Wtr9I9/UoMiZSZt7iLfVQ0zm9Qqj+p0q8/j6bVwvZxou2NtI4XWU9STUi+ZxcUnlO8cYRBmVR8/8FjujgiwNEkppCRdeNDMyYht/c6lsSGwYM1mS7HEoApYW4x4gMuz2oODz20u5KPYiky0fJf/gdtC5KtjqwWVie/NwvTH0IDnWZouobS0/V/A3JJ+J8Kk0c4qDtiWHXDJkFtk/+7ucTc5kLiR6b17EiuREG3CKpqlIWjkVedxaK5KaaEhY0dJYQduaLJMD3G7MCZXTgREpiAssurTrOddf1bZe/49oi1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrNPvNu4HX7HYOoamq1x88Pfg3LYMWwu+d3MuKPh4Lw=;
 b=YhOsDN5BsKTdC0wD+m5eC80qCag/ntAPYfwfrRcBczIY+u0tHFJy7L90rez5PSQuoXOz/06COVvK9JMdRK6HWKvl3vJc6cJ6C7BIvc3Aocs+GpU3448b+bj1be1qWY1UZe2z5pr4qvLS3XphTqEbq420N8l/ZhAOB12/A31jv3KNb7DDKu+FhIGfOieOpH8HfoX3vIDFyzMIfeKeU7X2hl7XaB9qte1vfaIcJJRT4r2C3QrnkJrx/1FQILbS+cdZreZTJ+UTMrXPC36UtT0JFJAOF3uQSmeewqD7YAorxcY/VFn8HnfF1+7GvbNnq1YnlwWXZhQwFZiqoj0GiptKFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB8122.namprd11.prod.outlook.com (2603:10b6:510:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Thu, 30 Oct
 2025 15:54:15 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 15:54:15 +0000
Date: Thu, 30 Oct 2025 08:54:13 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Reinette Chatre <reinette.chatre@intel.com>,
	"James Morse" <james.morse@arm.com>, Fenghua Yu <fenghuay@nvidia.com>, Dave
 Martin <Dave.Martin@arm.com>, Peter Newman <peternewman@google.com>, Babu
 Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Subject: Re: [PATCH v13 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
Message-ID: <aQOKJX13sIWhDVJ4@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-12-tony.luck@intel.com>
 <83f2ae55-46e1-480b-a218-7be679542908@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <83f2ae55-46e1-480b-a218-7be679542908@intel.com>
X-ClientProxiedBy: SJ0PR13CA0143.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB8122:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d5d6b9-bfeb-4e28-92cd-08de17cc93c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NBys1PFMkSfSxkdD0la9JivraxHBWCG5WVXv2FfrAd9G6IcobZEIb0sORwan?=
 =?us-ascii?Q?gsFtSHcBybv85ETSLSpu4+947NtBA8AU4gV2ZJ0w2f6VfCAJx1lUtceD6ZJy?=
 =?us-ascii?Q?2XPDKDNCLv3di7J3Ja/h3uANXsBX24Co+7+/L3/CzCig7Kwcoo4HRexyBxp4?=
 =?us-ascii?Q?NJxOMXXWrXU/z01Ajfk+yyTyojKCJk7Y5e5y5UkwfVTX9LivR9/lr42HjyTQ?=
 =?us-ascii?Q?QWG6o3OMw5cjY11FKfs48UWXwlTVcLKU9Nd2Dqg07Ckr4EiIOmSgjgqnTqq8?=
 =?us-ascii?Q?PUNILc45bTV4Fx5q9Prg0nfPbOW9BggMRjaPRAPzOn2cIxAIqBCpPlc80T7M?=
 =?us-ascii?Q?215bj4a+f1A8FlvLtMx8yqOev6pz/i7F18FzNJR01ABQgTPrhpPjHbWUOmH0?=
 =?us-ascii?Q?LKQ6LdgW8ik4u4X6h5FtcOLYd/0RwPqhEhKE5tw/K77zBZ3LKNbOn0/H1QBL?=
 =?us-ascii?Q?jNQXbF1OHKOJbFU5E6NbLQflw14MHZUqUK8HtgCFI67bF8DnyuSEIyQ+KFVp?=
 =?us-ascii?Q?eJ5WRIuE75sHPMwuy+dyzkyRJKdBiRykVZg0df4DxCsQJiYbfm/mNHSnz7mk?=
 =?us-ascii?Q?piXm3iPPZqFVEiRNF+2vXlqJHA0dZE3tJx1bCIJz2TKAqshMrZgvinVOUMwo?=
 =?us-ascii?Q?JQmiqYO1QeaUHsLk8j06Wci3Ntbz90mi65KHTkJFZX/S6fbm3paRhrPQQiiX?=
 =?us-ascii?Q?gW6fXmMlM2DVfTq0tw+LQMR2SuDNsd7+HalHu8STrFiIVT2lfuzhVXVgkpcV?=
 =?us-ascii?Q?odkmW0qaN+1U3wN1fAXslNEWVlcoliBcgl9b8Rxfqu5w9BxkqHnPfd2CRlkT?=
 =?us-ascii?Q?JHm8xU3UA9vtcYZ9xMUpGAF5kDnnjY1hFinJcnTuoGCylAKmd1KTiEP/mhD1?=
 =?us-ascii?Q?x429ldRRUW98XXqdIYLLJDTcA6oXaPRoZNevi1xrYUD9oxiqHSLVbElNI497?=
 =?us-ascii?Q?KGb9HBpwbkW2erJG5gtVjcki7MmfI3o/koUKNe4cNtb8S+HfqYrvyHhCO97f?=
 =?us-ascii?Q?f160rG1nwJ9MRk+EZKUk1i+nOUPVL5gjb/dlR7alFA5jFFqgM4zP00I1nE1S?=
 =?us-ascii?Q?4xFQQ/PwNWTbPsiUVTeQfPpbcVEfcjQDAIbjPASyZmLXYAYO/cv2b63YvtaH?=
 =?us-ascii?Q?sMS660ymV76qC/YB9hXC3QL3ukPG7wydq+T5aPnQVU0atgmDskQw+7z/PuKn?=
 =?us-ascii?Q?++d8nRCQs5AC4CnfHkrnCRRZTud49yx34UTnEKuoNLTCk0Qh7Dndj9xWJ3Ee?=
 =?us-ascii?Q?haY5oUe3HilDYradXzc35mXCX3kcJwbcl4bmixQ7ZXCjgmJvJ9sfuLEWnJAN?=
 =?us-ascii?Q?OZChf2+U6xfe/6Bcdg3JS/IFYb1e+V2Rj5lNcDNPbpJw+Jm8XkAGyOTg3MYb?=
 =?us-ascii?Q?xJRSdSmELA078qWDXdJa+JZTeRTIMQgbiHmwf4ZV5Gx+ttkc15RdILONgjxu?=
 =?us-ascii?Q?Ta9vh2U8u94nptEImAbGk1Ow2RO1kOMt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PawEvHEGbL3SYthpwhYLSVoN5OZUFAXASqDuxZZWQCBaMXo5UCcZPgXmXjoA?=
 =?us-ascii?Q?UC9FIsZbb68Wy4Y3d1sC1z1MABSi+m+GVZyDSHk9MGzZbhQ9OQppaDj8GHof?=
 =?us-ascii?Q?WI0WBDL2A8tt1iGkl28LMM8IeMR+uyhzcDAb7alSpo6ZrYN32qk+aVlyOtiN?=
 =?us-ascii?Q?UvCzrp3jpIZs/pgihBq0TwSnK1Eig6y8nodCUAVVllU7/pyFsMSxFwuJnS/v?=
 =?us-ascii?Q?f+Tm6R/hTzJb5bm4ddgJZxLPJReIdEWqH3490TcyhJsq5bs53Su4Onq52hYY?=
 =?us-ascii?Q?MGcQ7EBPSp8CVi2354daderhQYAl50H3cOLSzP9DPUJApOkKMNdBqcfzcZ2C?=
 =?us-ascii?Q?XMVJyg6WwYoXjfJUhkJHlxqRNr1ELP4HO9wdKG2Kz8Dvu65/e+qAEt2ymPar?=
 =?us-ascii?Q?3BR+agqWEYPe9cpG4+hA2MZGNs3Ms7OzqesQQf2hM3upB3EBph3HllrTtm7G?=
 =?us-ascii?Q?RX24Oy07WY/Nq5e73mcytc8JD+LbPxzPfFBX3SdQX7+ErBLUkzeAVJt7cTht?=
 =?us-ascii?Q?BJ+T9+VVC9ptzEXaZCiht1bnNlqrv25ZVaOupQg8sIPGL4g0uEbY9zM6DkBG?=
 =?us-ascii?Q?l7NmGwBVky46vkbCDdXaFqHvtqlCyVQI3iKQ24ZqWLL9krixoQPQ7kjCC4rb?=
 =?us-ascii?Q?hftaQZaVkluEOMD3VtrffplTGwRko7gMrB8gJ6OR8xSzs3F8xDUiNBgs3QCm?=
 =?us-ascii?Q?7K+SCL1VJhS/yTObfDVma1guwEAt57NQHqz1j6DkluJfRLuxElADbqBtd/OJ?=
 =?us-ascii?Q?wG1Im6Kyoh6Mx6sKP3oPpkkKv83c46WW0WAQRjTiveB4zKsleCLAMcRWvu2S?=
 =?us-ascii?Q?QQxgbRUVY7jOjC6GzxKbPWr/UqB741DcI99UFmkDWwcY+nZJHRYULEDwiVRr?=
 =?us-ascii?Q?uSLnW9N5CMTij//TqSznGAqUmgQ3P8TLZrF2HNcnp+E4qSXlW6E8tHGQRfCU?=
 =?us-ascii?Q?YoGnpA1wZYQNb1iQt58PyPZM7JuHVXaoTk+1NzRmxgm3K3TxDt6QRXYn/cU2?=
 =?us-ascii?Q?42rgYJNW+9+3v+9nv3PVp1DM6iPchpT0i0d3Khgq3m3h3H8xXXjbpOUCP9UZ?=
 =?us-ascii?Q?kM29FeENn5TxrZfStMJH6UZ92AeJdv3oU6lf61rq+p2B5utbhKlhri3VhKGP?=
 =?us-ascii?Q?j0uOlG7eTB3kNxJX0AFHJZlfB1YcPEa9ocOkFaN1MZiTxZKpgMIuV5TU6I0C?=
 =?us-ascii?Q?FGQAUubCtQc8Zh68AJUKBWwrLkpvBJmo+xRg4kQc5+JB2uorO4YP3cSE0Z0S?=
 =?us-ascii?Q?QiSJJ3w43AtYzJU1nH0Qg2go6gaYpUbfEZ8kNim7+EVMTVftCysPb+i2bq8o?=
 =?us-ascii?Q?JIxRykgROa0OFABMI+QuHmFIQcflAULidodwyM/bAA+CM+G4snoPFvrUda5T?=
 =?us-ascii?Q?hC/+OUolqsMWrZQ4ctsCkxs0UxadOkx0J/eKCZ0xnEMvhoUyiwdvD1gUINUi?=
 =?us-ascii?Q?uAU0u46L62UEySK7iJsp1lFb5KtV8c6Lpvvf53Jw30qe0HGxQqVc6afFRJLb?=
 =?us-ascii?Q?E9SLE3fagYoC4DdrBEwhff3FISoKOFSCIgtPp06S9oNR3myVu/sYtgrEci97?=
 =?us-ascii?Q?uuWVNtcLaKxjjTmXakz0TPSoiqlV13cYhjBR6Qfn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d5d6b9-bfeb-4e28-92cd-08de17cc93c7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 15:54:15.6913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXrm/T9dfdsPqlaYEF5ha2QhtkajnOwoW7CAydTqLUa+KNV6LNb8tAD/ZQxHsfj3YwzFzOYs4VSeBkVaXGWl4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8122
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 02:14:27PM +0800, Chen, Yu C wrote:
> Hi Tony,
> 
> On 10/30/2025 12:20 AM, Tony Luck wrote:
> > resctrl assumes that monitor events can only be read from a CPU in the
> > cpumask_t set of each domain.  This is true for x86 events accessed
> > with an MSR interface, but may not be true for other access methods such
> > as MMIO.
> > 
> > Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> > indicates there are no restrictions on which CPU can read that event.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> [snip]
> 
> > -void resctrl_enable_mon_event(enum resctrl_event_id eventid)
> > +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
> >   {
> >   	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> >   		return;
> > @@ -984,6 +984,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
> >   		return;
> >   	}
> > +	mon_event_all[eventid].any_cpu = any_cpu;
> >   	mon_event_all[eventid].enabled = true;
> >   }
> 
> It seems that cpu_on_correct_domain() was dropped, due to
> the refactor of __mon_event_count() in patch 0006 means it is no
> longer needed.  But we still invoke smp_processor_id() in preemptible
> context in __l3_mon_event_count() before further checkings, which would
> cause a warning.
> [ 4266.361951] BUG: using smp_processor_id() in preemptible [00000000] code:
> grep/1603
> [ 4266.363231] caller is __l3_mon_event_count+0x30/0x2a0
> [ 4266.364250] Call Trace:
> [ 4266.364262]  <TASK>
> [ 4266.364273]  dump_stack_lvl+0x53/0x70
> [ 4266.364289]  check_preemption_disabled+0xca/0xe0
> [ 4266.364303]  __l3_mon_event_count+0x30/0x2a0
> [ 4266.364320]  mon_event_count+0x22/0x90
> [ 4266.364334]  rdtgroup_mondata_show+0x108/0x390
> [ 4266.364353]  seq_read_iter+0x10d/0x450
> [ 4266.364368]  vfs_read+0x215/0x330
> [ 4266.364386]  ksys_read+0x6b/0xe0
> [ 4266.364401]  do_syscall_64+0x57/0xd70

I didn't notice this in my testing. Is this in your region aware
tree? If you are still using RDT_RESOURCE_L3 then I can see how
you got this call trace.

Maybe you need to dig cpu_on_correct_domain() back up and apply
it to __l3_mon_event_count()?

-Tony

