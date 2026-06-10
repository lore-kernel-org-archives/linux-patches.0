Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967A937F8D3
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781121714; cv=fail; b=XWg0anUTWuWUv68MjxOhxGZq6dSzZny9swzZ8b0a/9whtY7dECchP7ANsF7qKU3TElgo0VClb9RP0c+Fv/XqTANzDMin7JoFH3mOR45uyF1wP6w/06CU0sFJvVUTVf9tW4McZCCDUn6OXrZ+7OtrOahedP72LYxYImTzBslOF5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781121714; c=relaxed/simple;
	bh=1lGiXbzX+XY6bF9zZmY4yxVnCHKe3juOY3FxJvNlWiI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZQFlOF1vvHjoHtAdcpu6SnA41qi+LWz5nvrIItDfZireJCuXRMpOcm0xu2ZT6ez0OtyPq5p0E+9xaE7jUs4fw5bNOQ0rl87L2H7d+qX1K2arOnFQWhONKe7LZVJeJj/LzTke/ArJveTvNMLE/PBlgZb6MUXMgcd8NtZg3dYXWqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SRVBH8Nk; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SRVBH8Nk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781121709; x=1812657709;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1lGiXbzX+XY6bF9zZmY4yxVnCHKe3juOY3FxJvNlWiI=;
  b=SRVBH8NkqEhjKDm+jIdN1Y4VjOC70so2sLQifhYIPALB6hBFHkrNdXEp
   vkz9wHAtWyazYUmI0DmwCwz34pA34noarXfRb3oUuPMkOK/ObYotLSIPl
   b4gJAv16IfN9e9ly2LSYQPjudcJwSlPV6XXdp883YRAVrFgoHklH6JnHW
   FdijfcOYgXHxpijMrvG0JlIeLHHtbiDunLe66kcVvsv6idMdI15W+z8gw
   uzwNsDT+otCgn4xth20lS11xP9tLD6vEr4CDcedyAS22NwlS/x3EQbbkR
   fBgrIXDRbcF/kHLOyU4Whw/EkOl+7xpqEmHbtyW7L74IqakdiHz9UDl6Z
   g==;
X-CSE-ConnectionGUID: Exvao0/HSXq8VVrb0IP7vw==
X-CSE-MsgGUID: PIMMHGMURJyT8eSaHO7lgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="85551973"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="85551973"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:01:48 -0700
X-CSE-ConnectionGUID: zzp+T085SLaiOak4Z1tmxg==
X-CSE-MsgGUID: LcKWd/hJRPmQnBXNN+KmyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="276462752"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:01:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:01:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 13:01:46 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.32) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:01:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UECtGQf4uxh5njvO6NQzLs21vxl0yXaiOcXpF8x/RkBlN+vbr3YGB++VvCU7/YSjTc+sUOLpVfIBC6mylmnNVxVZjnWhepscKO8C8HHX4L8dK+fgtHMh4ZhY4+LsaeOfTupf3VBazQjQoGeT8wTvXB+CNvLRN4zOThagtk65KqYf23L7d+2YkWqCLDo+j+wuNc2DJMm+Jfudc3OJ0oTqdULs0xNcGkBQOr7gxwWK5yJfJMwvS9Frll/oXCG+288fzepDXwfpaNjjzqTETcjjdplxduwn+JwieCW0vBReoiKPb5m7u1EL8uS26pSpRooLptkmbWGdK6I0tYBnGYPGOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7N4oDDgiAvyH/CaOAT+s13oDkKPSSAP9WIx9Xf1tfA=;
 b=JVEpaY0d/l3SXc7uvAM0pWvdRqUytJU+Pwk7DNUa2UdXnJ3Q1y+0viXEhbjij/PyHVkKj2DW0MehLh0ao8wtKEG22ChG9tbzOV4a9N6gH0WZwj4PL+57JkIjDxdrFPZyIToB8htZDRmjPenA4pp1vPIrI7G9EEj8rfxV2lHQVQ0q8en2QTDm/3ddUo6xEnbViZFpqOZajkjtpG2JP67wJlDJpFRofmoPXfjeWLAgwLpC78JBSJ0UtlvwwHXrb6rMicdBRz+2nAOl/s5N/XKFrme+x2ZNulCgzbw5iLgLo63ovPHHi+XRLs83MeeLet+QU16Ll6W2SGgAbV37Xj2QVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA1PR11MB6823.namprd11.prod.outlook.com (2603:10b6:806:2b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 20:01:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 20:01:37 +0000
Date: Wed, 10 Jun 2026 13:01:34 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 05/14] x86/resctrl: Stop setting
 event_group::force_off on RMID shortage
Message-ID: <ainCnu4xmHbgh91r@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-6-tony.luck@intel.com>
 <4a62b53d-fafb-4f93-b724-e39ef93f0e99@intel.com>
 <aihEdw6gikv2aSKK@agluck-desk3>
 <933eb065-17ea-413e-875b-3783ad2456aa@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <933eb065-17ea-413e-875b-3783ad2456aa@intel.com>
X-ClientProxiedBy: SJ0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA1PR11MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c994cff-4918-46f2-dca6-08dec72b1423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|5023799004|11063799006|4143699003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: cXV1FAXVlIMcjYf7XzEd4g0a0UCrqMiTHaTKCyyYAF2tmMKH2bpdOAw0UUWiT4Wl6sNGsU0geTD1Qd2u9m2vUPbsF8S1hVV77E6cQrRLUvZRtSlNPj2IhKFRJ7NKW0K4lmLn4e5kF+/REqKrYw7ofIpBI7SxUA/2YSGkX8pVQQfjgQwF5HXPJaf0RPVWmoU4mvAtLkZm5AQ+lR4N8GJjJG+FJifi6VllrBH/5HXyHqoWbV7RpJUdUYhHajPm9w46bs3Ji50wuP9g/C4uokfFpWUoKnHW4aS5iWzVVv2D6DeyK2T++XIGtd/6xGO2iQllUdtt5Fnl0CEj3mSAfpglBXt+C4w4voLAI2R2nnPeR66MO88d4XZHkSKW5/AP/0m6g0s6xMpA1KxCkifxwhYFsUq7sLZZK2Q0LQlAwRpHd72BlivUQ/Lus1ZAs98OyNV7Rv/z0LyGpVCRQSOUMbjwihggJusgSuxMU2BRiyX2wKydZX80JMPTBebxDN5Wiav6T902d24Y8fcpq2QITHKzxgU0jVD+D71McgVTpOl+Hlh7Y0K9OydBARS0LOUfhA7jdRCWKcCgKAkHwbkOtD31THdWAUUXgdGelCLBu2cilLiixqyb7oiJz1H5LoXIsHdynbijJJdJrXQm3Z7b4+VckJjt7ZWZ/EgXty9csnkgsm1OuTxugMfS5bKheDZlS8Fa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(5023799004)(11063799006)(4143699003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nbnDm7OWHgmtPPbcBWfPa9KKBB3wMqRZvRPW+jWc+Yg2W7qzVjjfiej6uIzZ?=
 =?us-ascii?Q?97R+v9d/Ndr0mFzKktiWEwNmC8dwX2H2WHe18xilUA+msfXNZreAleaq5JEQ?=
 =?us-ascii?Q?Whkbmae94Ib1KWz2Z2s2j08/HP6Sq+34phjt+QNKgEwq2YZmCDHiiy5Qs+Hp?=
 =?us-ascii?Q?qbhG1o4EGmHnAkIe/1GAO45KVREAK9h8whfZwRncMB8N2Nz6hHcCxx7LtjAy?=
 =?us-ascii?Q?LTOwfqKa3Cn2dW4NOSpcI4SHwk5HnwxP2z4r5mbx9GUDYRnE8WwWYHF5hiDb?=
 =?us-ascii?Q?JS57xJoW/qlAq1dag8KO3UCK4AhzYMH4+KpGOKLNPOjextpxozHGNnj6Fqn2?=
 =?us-ascii?Q?yYoilcljXgptxUVflqHKg1Lqa0RgzgyYLEN3bc0jcbUhiXKSp8q9qz2kYmgw?=
 =?us-ascii?Q?88y3xfWipTq7cwQ4TieyROUZbdVwz0N7xF3YKgF0aOH/QyW9yUsEvvrGY5az?=
 =?us-ascii?Q?em38Xu1QHOeZWYVEGrPMXeRZmVQbHbb3C6crpPMyk5OLXoj4UamWOCHcXr4H?=
 =?us-ascii?Q?3OSl3soPP7Rw0qwS+HC6EOku8OE90khXUvfQjH+tPE/Crv/aLdRdXxptK2a/?=
 =?us-ascii?Q?Lu88Bdgg8dnRyr5osWE41jM6pgWD209c74cNVQghZF09J0dY5wIWc0dgbZHb?=
 =?us-ascii?Q?4q6S+RVNScJ8kPxQzpalR5j5AulEyRNJhMFFfGoD9dW20u5MJEKt6baDnHya?=
 =?us-ascii?Q?IGcajdUWzFtZ2d6znL7Xvh6CeqLsvbWrg9QrBH4qGYIJQjg8NZOEcWHkdQY/?=
 =?us-ascii?Q?S6uGi5KAP5Gx0Xm6iF9BMCtcNirT/1iR7UZrOohciNm1haQbij+zUo/swq6+?=
 =?us-ascii?Q?LVDr3zR5LS4OCd4oLoFdq8kyf7+fdCnkdYYWYRrwjAzHnWb/+7nsboZJWsgO?=
 =?us-ascii?Q?LZXJulsXn0TaN1eXxfpq/WlTjOuhdUUdrQTEdBWMJZ1TsVpHtHsg/3RukqUp?=
 =?us-ascii?Q?X5Okr/CN3QuyQOVpBPWYkjMAUbTPf5ObOF23aStO0FpszzCCnUAAubyLp9do?=
 =?us-ascii?Q?11m0Dupy9kVYS/3Sd0LMhMe+GH4j2dg+frI7Js+gLpyRhSDsUcNNqf7CwJhz?=
 =?us-ascii?Q?5/+mGf1faLNYHJJKAvxKfjYPOkCl8IyctO2RpYHi1w27j9Rww5rhPOdFOapy?=
 =?us-ascii?Q?SzlsrMaHuMU8SYF2TfGLsvzvCBbDxhzUqng/xc9frAlxAjRaj3FpWxFofFLK?=
 =?us-ascii?Q?2x9LjzOrb2N75EeQiyGfyyxyYSLlEKDGCjlFSCLD4b6EiRdZjxO9SIOWmikB?=
 =?us-ascii?Q?uXSGpvxd+uKKzJ4Y2Gs3qjxC5pJ3TkMc+kqcDp/0pDmIT2svnzwbb0Ba67Xy?=
 =?us-ascii?Q?ydUNOFSG4vmMhwiF7tL0TgX3278EOyRqHRZ0b5vgA9qlB3qNTC9T4eWtt7Mz?=
 =?us-ascii?Q?/v3EN8SjGgFTMZljRN/xqqPJc4XT09wXL7TMvFKsK+jinuiQW61dcgI4cAQa?=
 =?us-ascii?Q?IbpcH6WKWg9JQieER4FAtvFOqSXdEnF9XbMVpXGkH0HyfU4iUksHg/p9Rloa?=
 =?us-ascii?Q?lw/n9Cmb3CXQD+/KW28Wwh8yydfYX5gltFE6J7GzsInWBwyTwhV9auHccGOy?=
 =?us-ascii?Q?2/GHfjq+Be+NVZXIdPNj5hyF9AhQiq5hryM0GBHAvl7w3DRQIT6zqyqhjxA/?=
 =?us-ascii?Q?mzQu7clxHeSRf1Z/p95l2VbevEM6XdVE/qAUCtbkBdSEXbyTgZCCMHLq6jaG?=
 =?us-ascii?Q?B8AH/q9cN1t6zr0XrmItL0W8Bk6EvRldVlXO5PPCDl/leu4Nsawyhvr8bmkk?=
 =?us-ascii?Q?avT92ShNiw=3D=3D?=
X-Exchange-RoutingPolicyChecked: gmkevbkr/S/a8vyklvCnW6lFa23qowyJl35AkV0fBjuDkNtGl/OS4snE/K4bL4uoWHXSF7GKHf+p7u3UEDm5nyVAN3R7KGSOrxrgdcrMsTYn5ZzGQH35l8IsQcWvHULd/Yb9dm2cUtC56P3hD4MuETgH16Wr2AfnszHKjLbIzajPcg4q0I8Aireq8Yrl23QT0/ZLKbNTvNnJNZdnvuxWGjt4TVoRNLZ8Q6y96LxIizikJt20u26ESdaMPMTHi0EGdf9Tp85Vxv33IcZWa+m9BSKhoZ5EsF0IGMVZy531YxymGFYqKbPnC1FhR3X53UsPp2f+AJyswQEGvbIaw9CMsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c994cff-4918-46f2-dca6-08dec72b1423
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 20:01:37.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ax1Spd5bpFJ0PKfEkkrprA+g9LR1sMjynj+hKmElax49rAdU2WRq7s2cW5ff2oGmJMuwrMqFIPTAWfif+K/KAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6823
X-OriginatorOrg: intel.com

On Tue, Jun 09, 2026 at 04:02:11PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/9/26 9:51 AM, Luck, Tony wrote:
> > On Mon, Jun 08, 2026 at 04:16:58PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 6/1/26 12:56 PM, Tony Luck wrote:
> >>> Drop the force_off assignment from all_regions_have_sufficient_rmid().
> >>
> >> Apart from this being obvious from the patch, this is not how an x86 changelog
> >> should be structured. Please see "Changelog" in
> >> Documentation/process/maintainer-tip.rst
> > 
> > Revised version:
> > ---
> > Subject: x86/resctrl: Fix usage of event_group::force_off in AET
> > 
> > The kernel command line option "rdt=" is used to force enable or disable
> > individual resctrl features.
> > 
> > There are two problems with usage in the AET (Application Energy
> > Telemetry) feature:
> 
> Above seems incomplete. Could it be "two problems with usage of the rdt= kernel
> command line ..." or "two problems with the "rdt=" usage ..." or ...? 
> 
> > 1) If the user specifies both enabling and disabling of the same feature
> >    (e.g. "rdt=energy,!energy") the request to enable should override the
> >    request to disable (for consistency with other features).
> > 2) event_group::force_off is set true in all_regions_have_sufficient_rmid()
> >    which will cause problems when AET features are enumerated on each mount
> >    of the resctrl file system
> 
> Two comments:
> - In general we should aim to make the changelog as specific as possible to
>   prevent reader needing to do any deciphering. This makes the review easier
>   and faster. So, please avoid general things like "will cause problems" that
>   requires reader to figure out the problems (plural!) on their own. Instead
>   just be specific about what the problems are.
> - Is (2) still a problem when (1) is fixed? An underlying question is: if an
>   event group is successfully enumerated during resctrl mount, will it always
>   enumerate with identical properties on every subsequent mount?
> 
> > 
> > Fix the first issue by checking event_group::force_on in enable_events().
> 
> "the first issue" seems vague to me while the rest describes the code that can be
> seen from the patch. How about something like below to help describe what the code
> change accomplishes:
> 	Enumerate the event group if user space overrides any disable of the event group.
> 
> > 
> > Fix the other issue by dropping the assignment to event_group::force_off.
> 
> "the other issue" is very vague. Here it will also help to be specific. Although
> per earlier comment the need for this fix is no longer clear to me?
> 
> > 
> > ---
> > 
> >>
> >> Please note that, after the preparatory fixes that are expected to land separately,
> >> this will be the first patch of this series ... having this first patch just
> >> kick off with "what changes" without any context is a difficult way for a
> >> reviewer to start considering this piece of work.
> >>
> >>> This preserves current single-enumeration behaviour while preparing for
> >>> the upcoming per-mount enumeration, where latching force_off would
> >>> incorrectly suppress re-enumeration on subsequent mounts - even when the
> >>> user explicitly requested the feature via "rdt={feature}".
> >>
> >> I believe that user space should still expect that rdt= options behave
> >> consistently. So if user space for some reason provides: rdt=!mbm,mbm,!energy,energy
> >> on a system that supports both then it should not be the case that one is enabled and the
> >> other not.
> >>
> >> I this think that, for example, enable_events() should start with:
> >>
> >> 	if (e->force_off && !e->force_on)
> >> 		return false;
> > 
> > OK.
> > 
> >>  
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 8 +++-----
> >>>  1 file changed, 3 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> index 89b8b619d5d5..e2af700bca04 100644
> >>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> >>> @@ -60,8 +60,8 @@ struct pmt_event {
> >>>   *			data for all telemetry regions of type @pfname.
> >>>   *			Valid if the system supports the event group,
> >>>   *			NULL otherwise.
> >>> - * @force_off:		True when "rdt" command line or architecture code disables
> >>> - *			this event group due to insufficient RMIDs.
> >>> + * @force_off:		True when "rdt" command line disables this event group
> >>> + *			to avoid system limitations due to insufficient RMIDs.
> >>
> >> >From what I understand it is only architecture that can disable an event group
> >> "to avoid system limitations due to insufficient RMIDs" and this capability is removed
> >> in this patch. Above implies that this capability now needs to be implemented
> >> by userspace, which I do not think is accurate?
> > 
> > Should I just drop the second line? The user may have various other reasons
> > why they want to disable this event group.
> 
> Now that enable_events() starts with a check of event_group::force_on it seems that
> the existing behavior of event_group::force_off to also reflect architecture 
> disable can be maintained?

OK. I'll drop this kerneldoc change and keep the setting of force_off = true
when there are insufficient RMIDs.

>  
> > Combined with the code change you suggest above, this would describe the
> > use of these two fields. "force_off" disables, "force_on" enables (and
> > overrides any "force_off").
> 
> I believe the "force_on" description below already accurately describes how it
> overrides an earlier disable.
> 
> > 
> >>
> >>>   * @force_on:		True when "rdt" command line overrides disable of this
> >>>   *			event group.
> >>>   * @guid:		Unique number per XML description file.
> >>> @@ -214,10 +214,8 @@ static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_f
> >>>  		if (!p->regions[i].addr)
> >>>  			continue;
> >>>  		tr = &p->regions[i];
> >>> -		if (tr->num_rmids < e->num_rmid) {
> >>> -			e->force_off = true;
> >>> +		if (tr->num_rmids < e->num_rmid)
> >>>  			return false;
> >>> -		}
> >>>  	}
> >>>  
> >>>  	return true;
> 
> Reinette
