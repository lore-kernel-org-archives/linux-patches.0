Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605272459E1
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268005; cv=fail; b=TK05ZlQOdandE11qKbJM3icW87Jm+npL6o9y/IavL/i+UPrBFx3UsSJiJy3kvem8y8QF2NTRjYl60Jxj3OA5+p8ZPYCvIGGaeNFW+edF6EdakkMOGyzl5aLGQNRQnBhP6fiLHfJM8y/41Jl1cY0JwHNWeGuJEPn45/ktQD10xp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268005; c=relaxed/simple;
	bh=KP8MLO8s2Y2/Ge9ejcKop21oBf3ELaRLKwecTOkcPBg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kjPB5TshcFyIcK5DatAkQYnnMGTFCXG5jQ0My3n++lsdoC8Tie+atj5FuYLligDCSKxLNnUsXuBzVev4NNp29JoFqj0gZYEJhuk83vXAwgQq7GabGeU98UwrT4IvZXh0Jji2Rhra3nVI8UpXxFoM47Up737GSHz+Z41hoKPzKMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WG0ihcKY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WG0ihcKY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787268003; x=1818804003;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KP8MLO8s2Y2/Ge9ejcKop21oBf3ELaRLKwecTOkcPBg=;
  b=WG0ihcKYxAnWJKBYhMe0lGyO240zQ+Hh2+j7LESMkE+tm0+OO0OYcT5R
   HPfZsibUSV4vA6a3xBbvvP2RaWG6Mtgk2ydXWwEZqGrczDpuNv0MEnUXY
   hN3LnXkmdZ+LNZU4kDZNM1fKeadGPKWJYIiG7Ofwm+1UoKkgduy7x6W55
   oEP5nx/8tL3+KUbRultPKwz2k0IXSVW1Hu9UYrC5ihUts7Dur/9IeMV5o
   l7UbEtKtnQSDsS5YOvPcTO+fghWWhUA8kXAy12y0LAtUwxzHXWOTtCIjF
   R+wXS10LQzGpBXHZ7HqP/TsDhb2n61ubKKH2h8DD6jBnPYLFMUnVxcPdl
   g==;
X-CSE-ConnectionGUID: JUfAciD3T52GnInwgK85hw==
X-CSE-MsgGUID: cDHsZ4biSreSTTN0B09Xsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="98972519"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="98972519"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 16:20:02 -0700
X-CSE-ConnectionGUID: gfKi1xwgTWmQTOk2Rt5rPw==
X-CSE-MsgGUID: cp0QJaDkTU6L0pXDnD3yuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="263527767"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 16:20:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 16:20:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 16:20:01 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.56) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 16:20:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LpobBboaBNtB65Ies7xA5F1pmz3iKnN9Hamn3MhHToh0Qvj/Z2ALwz0RulYnvrMhzinYRwVpDpjqaSH9Oc8MFmvxPtQz/85J8NfQj+1+6inOFJYD+aTryFLnW0xfl/BxZB2+rmAPnuubFCW9+wXYnjf9zDF6NUw9CmrCkyz1h27FZt/1MZKzUSxmt/AUDHssXK61k5q0HOrp2W8AAYztlErP05g1LiDmEHV6qW6OrLz3xlPb9kas/gx9fhsoh0mb+T+jZQAmkwpy6typWuB6FimM1e33YRfKifXmiu9n7S7+WD0BaediFsN63it79U3x4qz3tGq7BO+hOGfcZew7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axpiMEBHR/cPYB2TZ2f3ggFIBJQuOKv5ZjZg3i1Hz3A=;
 b=sRFkCygcinkXXFU4TFrGpOsA4BAHjBzB4c3iQMER82WTy52D9QJAeuGLlEtQjOxFGEVVscBtMoTA/gssb2zrL6uBwhEcQI9moPlbEt9OdFVlVU9a0oCz+vp01dPx9GMiWWDjdxPsWXpbLdWi/N9pO/45//s6lUdb8oD84BUI6nbSbkM9wvvIvyE7Mzp5RL4PQb/oI5U8HrMPL7K7/i58CbbGMwVZB+tLIsoKPcczRUFWEX96ffiTFsKMdwnYkYhW5TW01IcXhTD+Ws0z7eWc9EyiVqWVqmDfV0JedQlrPqR21VUIapMLDgD19TEgaIqqLEx+Uth2FCXTlLaify9JRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6698.namprd11.prod.outlook.com (2603:10b6:510:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 20 Aug
 2026 23:19:57 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 23:19:57 +0000
Date: Thu, 20 Aug 2026 16:19:55 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 08/17] x86/resctrl: Enforce system RMID limit on AET
 event groups
Message-ID: <aoeLm3LqYXTrADeA@agluck-desk3>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-9-tony.luck@intel.com>
 <cda8483e-8c83-45b9-b52b-0e465e49b698@intel.com>
 <aodKsOMxcdasi0U6@agluck-desk3>
 <779e9ca5-9785-4cfd-b6c8-42efa1b2f560@intel.com>
 <5ad0c32f-a734-4bae-b30b-791796e46009@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5ad0c32f-a734-4bae-b30b-791796e46009@intel.com>
X-ClientProxiedBy: SJ0PR13CA0225.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: b1dee5e8-ce6b-4290-b2da-08deff118ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|10067099003|11063799006|5023799004|6133799003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: o3pb3NFShAZLS3pfgHo1C8jj84KVeYyk8NAPF8CElcixNfl0NFyNCZ0nDBGr6U/mNkqL8FGP5JGhLiUcdGEp83F+vIxAEjCpuGGgOpp86/LAZagebcfHSr2tde3ag9RDygdYaKUfMlEYIGUe8EgF+7zlmDgjai0zsEtDNRXKepsTt+SPVbN/rfkVi+7eY7O7E/X+vpgifQu00L1X+WcbEa8FlKyDuaVfoZZmt6rTVFgKiJ81QCAVIvnFg9tbQ01pRWM4theNn9EzhoCoJi+kHuK3FcW/CQRCZLjrHstOGjdbrQ4ANJcT7GegCbbYn5YIC+O+UHiGi8Ek+Yu0CYBVL7d9mj6PMiR/1q17BtucOyzocNy7vpwchNFAeG6ZV0SQOuYKfZ4tKq8YiPuvDgiiGsWduBCcGrATEN21t0n0HO224+uXfdjr/TcjofZiyhSZhCANsfMWk5L+iDO9dVCpvSNWZR7un6I2aNsDLS7dc56JMm0CedVhe39Ud7AEM1PpGPf9TdKxgGit6z3R8YA7TFH46Q8cIcRbxmWri+RKcxTE6fh93OmRHHxzcpklzdWviHBdmlGVNhlbuab62NPPIM3qajw+2D6chsD6/pLYwP7xiPURlpSEjA0yQFi6kw869XvQsKogOXOTHG7qQY2bBXTILqk2yWL/Cm2NNDQ4G9U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(10067099003)(11063799006)(5023799004)(6133799003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4XG4QVTYy8guwWDR2whbD76ad/1UtMKAMXg/GRfwTS9vMsKx1GHQ3+z7SKqH?=
 =?us-ascii?Q?ANtF7zhbBkKK4BQhITIEB2l1F1vFuEwEFGBTRN0J0jCF1RvM+7uu9h/U2vVL?=
 =?us-ascii?Q?0+vab/a+EZ3wiUsndNWdBY9qf7KEpwlU5TL7dvzaKM2e36CA42Q9caPXX6aQ?=
 =?us-ascii?Q?D1oAIR6rZWVF6ZeCqsW1+VHIbsUf7c4L2PXhi6EuJmh3eNUtgL6ttmDTz9Jc?=
 =?us-ascii?Q?LAEdBVlkNF7g29tvoE6ViOya8696r2GJMokjISWhCUfD+VFHagMXyKwyWFKY?=
 =?us-ascii?Q?sil42LNIGSjNdg025FtFQlTGuN6ar8RqhNQFohKfXwoed0RX/fh9659amOeU?=
 =?us-ascii?Q?4/7oHUdZCERrdS59pgKVpK/DjSZfxXjTBZdlCrd/6c3mjxaQjlxN00KnsjI2?=
 =?us-ascii?Q?uSXlItMciWqg/v1N3iECCOnHnUGZUEA+MLqqfMsNq71TSFNp8BUOEov0r+0J?=
 =?us-ascii?Q?4twmrB97dvcBrq11Eaee7prR7VO02s3KL6y5xuYJsla2qzoTzbO7PGcfOEcz?=
 =?us-ascii?Q?T97jygW0PKEPL6bj4VzlGuY6tLIRSjrZI59IoVzK2UTduReNVDNR9FASKFNL?=
 =?us-ascii?Q?u98TVoul01ONf4eq3fDrwqwoksDbPdccWK4v9hgrxrQOP5ROVj37aTb5q08k?=
 =?us-ascii?Q?FK4fc6pebKuoM1fGeRoyF5EVOoZ/9ek7cF1JH9T+NJC2q5riXNxaNjf20NKg?=
 =?us-ascii?Q?igGU3xdHL2Nw/tydgxrhKEwP9jaiIY2qnog10Z6j8/6QGsOvowj9GgnmWVIP?=
 =?us-ascii?Q?r5/73E47uyR0PiTxrLwCUo+7l2bU1w78kxWk+6f+1iPpOiUAy9ozO+QZGMCB?=
 =?us-ascii?Q?SxGUbR6WxnZcG9N0HZbjjJsOWoPrxqlWc5ZZvCFiS6h7zjAY9yXIeWv0MkeC?=
 =?us-ascii?Q?3NLglRTA9Ovg8YPubHN+HgfxAzLZ9PSF3htyvur5bTd+pYluolyxvtE1XbcP?=
 =?us-ascii?Q?OTyQfKKozpcz9v15sorqBkYLQA2BCP3qr4jZt5tuxVpeJVApfKFPgtJZWauY?=
 =?us-ascii?Q?pSwT43I2hW2VMZmrszLehavWpvtq5AVP+hpcNDXSSnEQuK3+Yp2NyTeFlVt4?=
 =?us-ascii?Q?67AxKNbqqbL2lBBlc0IGRNEkaqSBeFqMNCARDTFqMsoaZQgotQHCbpLvGXDQ?=
 =?us-ascii?Q?aoQ3Bcn4bhGPAIoY0Q63F2YnIsvLfDi7/ZTiev8JwW9sDMcHAx5VhAxwfq5n?=
 =?us-ascii?Q?PN010MNIdlnfxmFsnw1PAblhZJvDSCN10czpO8M47eDmT7db85nA1VzmEYPr?=
 =?us-ascii?Q?Q8JzRQHTJjyZ9LfQnhjYrM61stH03JBimBn2qvQtNYdHTX759Hgiu40zPG82?=
 =?us-ascii?Q?3DMq2yNF/Uxp2jwGm0AWboC41ipKCBPwxd5a/RDV/0CvWzIe5dMUCQhEj7Rf?=
 =?us-ascii?Q?wgIy2Qhe5GMe4bti5vhVipXmiZAwiaOm2W0YFOKRkdld+4Cos7PD28Vsh9DT?=
 =?us-ascii?Q?JkDg8OCq56BZz3bPVVnknQ6Q/uP0Uy+nwuRcF+otA6NvdyblRMGOB2bieYD5?=
 =?us-ascii?Q?hyHF275X6cqCdvx9rgF2x3FGZzPoKQE6Fc67tO24JHyAMQPDxc2QtIq7tNw4?=
 =?us-ascii?Q?TZP5P4TG+XZ3nrWUaa6JURSyieMUFoo6+OoUKduDoiKo2eTx9M6L7hYA+N8z?=
 =?us-ascii?Q?AfqY7RPrxRwqJmXvfb32SSbOWxzHBqtVH/uyXsgfLd7+SDV83jikh5WNp03q?=
 =?us-ascii?Q?JykxQI0Fhjv4fjgRALZT9qUWekimAVMc33Be+rE6tmmuRJvR88jD56EUWpLK?=
 =?us-ascii?Q?BQXz8pAfzQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: E3DGM7As/tdadNHwuLU1VhcJlvBeAe6zhjv+7TxDanzaRb/f5W+dXuKCwUJ04DNYulsbRnUweq0O3+rIuWMCK7H1hHGIfeGnThC7P1htgiUs6iD/0zymtwc+zjeQoXqiLonYMrn5gB/k8OZ0WNJYw7qi53sAHGOyDnLKrgE3+Bi1+YiuGsnHG+JO6sywxiwh4E0szI8iXt738QXBbIeSSnb3PmwzLqJaLASrL6SsinjFaeMr9e024INeBotO7NgeO5LTuPmyFxXVfDs2pVea9ZFaGYWudKesQDcVH76SXJu8ND2ARatsBLvx4/11+9BSszphUTpFUizNU6+89Fbe/Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: b1dee5e8-ce6b-4290-b2da-08deff118ca0
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 23:19:57.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omMzsdt1FFuZ9qxlOl7gvoCmtzFPIjyWgEebCsVPweWPtMl0uDQwvKLVqDmM+8JdVTEdBIMk5SruBaX8qT9LMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6698
X-OriginatorOrg: intel.com

On Thu, Aug 20, 2026 at 03:28:18PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 8/20/26 2:55 PM, Reinette Chatre wrote:
> > Hi Tony,
> > 
> > On 8/20/26 11:42 AM, Luck, Tony wrote:
> >> On Mon, Aug 17, 2026 at 05:58:13PM -0700, Reinette Chatre wrote:
> >>> Hi Tony,
> >>>
> >>> On 7/29/26 10:27 AM, Tony Luck wrote:
> >>>> AET (Application Energy Telemetry) event groups each support a specific
> >>>> number of RMIDs. But that number may be lower than the number supported
> >>>> by the system. Especially true on systems with SNC (Sub-NUMA Cluster)
> >>>> enabled as that reduces the number of supported RMIDs.
> >>>>
> >>>> Fix get_rdt_mon_resources() to return true when any monitor resource is
> >>>
> >>> hmmm ... "Fix" makes one look for the accompanying "Fixes:" tag. What is
> >>> the fix here? What is wrong with existing implementation that needs fixing?
> >>> To me this does not look like a fix though (more below).
> >>>
> >>>> possibly enabled. Call intel_aet_init() to adjust the event_group::num_rmid
> >>>> values to not exceed the system supported maximum.
> >>>
> >>> Last sentence just documents the code. Please describe why this is needed.
> >>> Is this a separate logical change?
> >>>
> >>>>
> >>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>>> ---
> >>>
> >>> ...
> >>>
> >>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> >>>> index 092764cf693f..2c938b97b147 100644
> >>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
> >>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> >>>> @@ -1019,10 +1019,10 @@ static __init bool get_rdt_mon_resources(void)
> >>>>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> >>>>  		ret = true;
> >>>>  
> >>>> -	if (!ret)
> >>>> -		return false;
> >>>> +	if (ret)
> >>>> +		rdt_get_l3_mon_config(r);
> >>>>  
> >>>> -	return !rdt_get_l3_mon_config(r);
> >>>> +	return boot_cpu_data.x86_cache_max_rmid > 0;
> >>>>  }
> >>>
> >>> >From what I can tell this will return true when the system supports monitoring,
> >>> but no resource may actually have monitoring enabled at this point. Specifically,
> >>> no resource has rdt_resource::mon_capable set. 
> >>>
> >>> The resctrl initialization now proceeds where it used to stop. resctrl_arch_late_init()
> >>> will proceed and initialize the resctrl filesystem, which in turn would allow user space
> >>> to mount it.
> >>>
> >>> rdt_get_tree() handling the user mount request could thus be run on a system that does
> >>> not have a monitoring or allocation capable resource and then we see in rdt_get_tree():
> >>> 	if (resctrl_arch_alloc_capable() || resctrl_arch_mon_capable())
> >>> 		resctrl_mounted = true;
> >>
> >> Should the inverse of that check really be an error condition and result
> >> in failing the mount? There seems no point in a mount with no monitor or
> >> alloc features.
> > 
> > I agree that there is no point in a mount with no monitor or alloc features.
> > That is indeed how resctrl behaved until this misrepresentation of a fix changed
> > this behavior.
> > 
> >>
> >> This code appeared as part of James' separating the x86 specific static
> >> branch code out of the filesystem generic mount path in commit
> >> 13e5769debf0 ("x86/resctrl: Make resctrl_mounted checks explicit")
> > 
> > This change would have had same consequence even without that patch, no? Only
> > difference is that before the patch you point out rdt_enable_key was used to
> > check if resctrl fs was mounted and rdt_enable_key would not be set if there
> > are no monitor or alloc features resulting in the same problem of resctrl
> > allowing a remount after it is already mounted.
> > 
> >>
> >> My plan is to move this inverted check earlier (right after the call
> >> to resctrl_arch_pre_mount() which could be the decision point on if
> >> any monitor resources are enabled.
> >>
> >>
> >> rdt_get_tree()
> >> {
> >> 	mutex_lock(&resctrl_mount_lock); // NEW (revived from v4 of series)
> >>
> >> 	check for nested mount -> -EBUSY
> >>
> >> 	resctrl_arch_pre_mount();
> >>
> >> 	if (!resctrl_arch_alloc_capable() && !resctrl_arch_mon_capable()) {
> > 
> > A test like this looks to be needed after this patch, yes. Even so, why does this
> > need to be outside of the main function protected by rdtgroup_mutex? I do not think
> > that it is ideal to have this information accessed by resctrl fs with different mutex
> > inconsistently held. Or does this actually reflect the larger "always return the same
> > data from mount to unmount" implicit contract with architecture?

It doesn't need to be outside the cpus_read_lock() and mutex_lock(&rdtgroup_mutex);

I agree that it would be much cleaner covered by those locks.

> > 
> > There clearly needs to be a contract between fs and arch on what the fs expects these
> > two functions to return. Patch 6/17 is beginning to create this contract. 
> 
> Thinking about this more ... does resctrl really need these to be arch helpers? With
> the mon_capable/alloc_capable available, resctrl fs does not need any help from architecture
> to learn whether a resource is monitor or alloc capable, no?

x86 and mpam versions of these currently use different iterator functions to walk over all
resources. But there is a file system version in <linux/resctrl.h> so we
could do

static inline bool resctrl_alloc_capable(void)
{
	struct rdt_resource *r;

	for_each_rdt_resource(r)
		if ((r)->alloc_capable)
			return true;
	return false;
}

Ditto with s/alloc/mon/ for the matching partner,

Would you like a patch to replace the arch versions woven into this series?

> > 
> >> 		ret = -EINVAL;
> >> 		goto out_mount_unlock;
> >> 	}
> >>
> >> 	...
> >>
> >> 	resctrl_mounted = true;
> >>
> >> Choice of error code is still open. I tried -ENODEV, but that results in
> >> an error message to the user saying the resctrl filesystem is not
> >> supported.
> >>
> >>>
> >>> The above flow change would cause resctrl to think the system supports monitoring
> >>> but resctrl_arch_mon_capable() returns false. If there are no allocation features
> >>> then this will result in resctrl fs mounted ... but resctrl_mounted is not set to
> >>> true and thus allow a remount that is not supported.
> > Reinette
> 
> Reinette
> 

-Tony
