Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D71A724C
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765312643; cv=fail; b=Z2XsfX+NTON4hdsmtvVppWB+0e6hquuXSsSanekBmF0f9hdEQXSPDJAtaB77gjtMnuCa+fN451NP8IzoTu4rGFR8M4obGaooly2GDsXJpjjclG7iGaxKbRANtBkEdBUBj5lyvZqiTp+pDExQZsUw0tRYPjzsWGW5x5/zEKKYIYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765312643; c=relaxed/simple;
	bh=nuR5aYEdXqr1HnLAKJghC9FJwwjdrP3KGhH0hT6kOxA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KiWH6p9C2eLWNSUJAV4XfjL8ZwMJ/RAVS8/bTvRFHm3Zg+MUAlBAmKXoULiBQ5Xw6E9tljRhCjcL9mWXwmJrkc4lu+580JTT8idynJYSLFon0cyr5syPsgazUON5HddPKQX1dyfbWU7Yz0Kqg6M+P3D1G30wllue3zL887lPKzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FD25w+yg; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FD25w+yg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765312642; x=1796848642;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nuR5aYEdXqr1HnLAKJghC9FJwwjdrP3KGhH0hT6kOxA=;
  b=FD25w+yg0VA6ZYbIZTWxzhuOARNsw/diZYXbxL8WvYqnlYP8VUwqQaPu
   IxtVFTrX3+aHUXcCahGwYY6maivwuUcZC+nrKhsqpSt1UcYglWZhOJfSZ
   0t9vY1pchBAOzwdRrqGNsXvCspzmXqsMJ9b6NN69jmay5q/4L1l1EYrK6
   eQ8bbY2UvPHuPtI0IgtnqnhTbPZYr/oIzqPlxWZ4tVh1/2C6WDC+33SnC
   MdaHJ0ImDHHZHyDAUs/cYGlw57nt2MQFpO6IkUosjHoj560QjNlaqjU+F
   999n9ccWi27BthMz4jHTIElINlgj0NVkX6Wfy/VLK+oElp8htooi9hsqc
   A==;
X-CSE-ConnectionGUID: Ye6k6+csRBC6wiGtFBnSXA==
X-CSE-MsgGUID: KnieAY60TZeIEJnbe4w+KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67174217"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67174217"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 12:37:21 -0800
X-CSE-ConnectionGUID: CVLPDLLKTDmlXlLUcgcVzA==
X-CSE-MsgGUID: iLEK+Uf1Rhq+nA0a38Xyjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196366647"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 12:37:21 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 12:37:20 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 12:37:20 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 12:37:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8/6zozyfg9z9mJhWcHA/HlAAsOstioIBIxo6AdjqW9zRkRboPTWxCrYV+soTItxIsOj8DaL5dPTDH1POBe9nZwzloEIJVPxDgku5xs/KDaZWxr/52rZhl8cdz/IaPPiZzWnTaiMDF7abjpbFN6ZyZY9BUQqMys7+1FrNOe9HEzhc7IT/NEFsR+bh+0Y4z1cXJnos/+IY8kF/dB01CE7Nhl8BQrgy8MnlcEaTC/Y+w9gAo6MuDiO9mZ+c7gkyz/hRwZ4pb1ze8LHc5yCV0JpKx8AmYq06F56bmQVLc9igx2tlhtTKq+RBzxsqDwfpoDCN7ASvOEM71SwjFgt/pXB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+YLbha3Yr1yCgk0c/e1rKGKAYyuH4gm0aM4YKXE3aI=;
 b=K2IcPC8khknBTQXNx+ryysxkvsFKT/nXol40k3Lh82HVu7TeA42YfBs0fu73aW6Kv3Fy/pOU7u9U8NwUpBFZt8wQSrsiPoDzbF/h+LdA8Dd28eYJDgLR0rp+ENzMjY8oM5Tqj0857ynVue8S9ywOm8a9ET9sk8pjBNbFgZZRfTq33w+Vn6YaRuqoZRVVBoGbSIRjqj1IBDIW5hOXJs0F6lXjtPO+fpIIVULdpCpFo5QdrfOUagWlQ7pfNaxmxuExwKendbhVrVpdgijWQlji6eAuwFIa7WHrr7niKugrplEFT6afogzU1Ckdm3V21e8cw5kC13LliZY0eBmC+jas6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB7126.namprd11.prod.outlook.com (2603:10b6:303:222::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 20:37:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 20:37:17 +0000
Date: Tue, 9 Dec 2025 12:37:15 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v15 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
Message-ID: <aTiIe6U6e5PlEyj5@agluck-desk3>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-12-tony.luck@intel.com>
 <34dfe97d-3aa0-4fc5-8f1d-3da5066a0b6c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <34dfe97d-3aa0-4fc5-8f1d-3da5066a0b6c@intel.com>
X-ClientProxiedBy: SJ0PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW4PR11MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c0741c-c667-4e61-c550-08de3762be16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eLe++nQM3z3qR7UvYHZmysROtF/VHIs4aM3t2coczhl520VDJNoMpP7QJ0gw?=
 =?us-ascii?Q?5Ew8pgSzS8/5ra4cCFLTYHH7kRPjDFR18q89gEZC1hKo+fVPM6PBtPuELiql?=
 =?us-ascii?Q?vWmhUSwAHEEhP3Xsk3p3XlG8eh8DCkV8dOk7+qBMEVyX1REfkZEJ4KjQW5QH?=
 =?us-ascii?Q?Yp3y6MPaHHFU1A4mSBzIijqsEpR9Q4lkOnNRmKgmDMtiUxTLBV9jm4XNnPi7?=
 =?us-ascii?Q?b+xLIHWz+k64Tj1rnWWOwgy2Q6boJdFm6xUUn2awckPni+97c+TM918ZqYjP?=
 =?us-ascii?Q?zwsYKjlvujkXTkOdX+lTUNcUVYKK4KpWofBmJbt0YrnOTK9KdEPABciTPTGn?=
 =?us-ascii?Q?fIdrdw7igzYya7VRuul1Ea/lCEs5XtSUPCSQLwoCR9cN5xpTjpieLgrF2+eV?=
 =?us-ascii?Q?qh85c1vZWZiSd9maJ+7LADbTM2kQ5EIDTmnDuiVMmhJQGk8p4Od+HwlX2pXa?=
 =?us-ascii?Q?uin8XUI75CjhRL9whVMvgRSFFLBLAu5xhbE0Y9z3RPKOvB6AmpV/Q6+xtErU?=
 =?us-ascii?Q?NManNblxKBwfq8SNtJJWgklO2QvDtuPipyQnLMcYo4BmvqS6iysW/EkRtd0C?=
 =?us-ascii?Q?35LREEdkPV0XsgFuswH1e1G5QdmMkp+9lJGknNwqqctXN4jW1bOGoYVFZB5k?=
 =?us-ascii?Q?+KgPLgShSCrlXt83O9bwOnIqnL7sskd+fBTzoEEkXEBmjd2pImP84xLVJZtV?=
 =?us-ascii?Q?K8tHt/Qular3AB/O5pezlWySP7ltdhGwqAvtCBfc/NYID/cguH4UVRDc2Hlq?=
 =?us-ascii?Q?n21Aj5uro9AbZdpHNokS4cdVNu1DThhaHguu3vnlPr0SedwCOAKEApXqI7TG?=
 =?us-ascii?Q?WaWHJ/I+srMQyDE14yn4C1k9gWWel9o+0Ct2G2gPZe9gqMqKScaEFbcynO5u?=
 =?us-ascii?Q?II1NUCjGVNQwtrIRFQaa6RKisaXGrgk52pIok5YjCOI4LGtzh7bErYKUDrqH?=
 =?us-ascii?Q?lg3bVvfqdJvAICV7DND/Ukbyi2n7F/1SCF2vPp7CVRNwQwR7OlcHIFLXGuG6?=
 =?us-ascii?Q?E1OeHfrQU5YJllUpaXXGFqs7rUowbGqV0EkAcnp9uHBlqFEAPIz9lTIo8Jia?=
 =?us-ascii?Q?JrO8cHcldRXx8ZH1gSCQWlQvKBgilGbV672+xO9sCu+RZ4GoiZDOmbE+wsW2?=
 =?us-ascii?Q?i4LFDO+n/DuuG/0QJrxOe+VMDSw80/WioLkYo0H8DhmYGZtfT6K2aMwpWrIa?=
 =?us-ascii?Q?naMmS+4wWvOysflqCSnVOzYZdGIHGxKom8ExcP1yWWEVxkhQ5UFco9z+TqYc?=
 =?us-ascii?Q?0gnM/8e7ONQ2xQWTEprJ6s3AbL6SjwtGAH5aHnXI4oVrBcNlBB3RTP0Voqhm?=
 =?us-ascii?Q?sOhcfUlpUWw4fjTiarZeJxJCVgHOXy9jwOVwfKQ6Kveu8RAgink6vyuu+G61?=
 =?us-ascii?Q?yj8ak3jsyxhHcaASeWRkBtjtdl4eIX0Thc3Y7KiDWHY3Le7R6wiQHV6OBFC3?=
 =?us-ascii?Q?4VmHdSo8XonmEXSgjOtHr7hi43l8HUGJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96v+435hPBxKFtUSidvxGtRdlyYdTYrC7zXa7AwTok9ZGYZByB2e1mHGbW9Q?=
 =?us-ascii?Q?MifXunyLEnf/D20IRLXVpC280Fyw9Dpj1VyEXLzPSo38frkQCsShqgA8Hnw3?=
 =?us-ascii?Q?QjOA//sSxm3xG+hXhGSFouDqp4hr0KRokuZgvqmYKzLI5VhCjL0Adlv7gPjH?=
 =?us-ascii?Q?yv3Hg9XlKyn3JWojxgNoONzpOr6Lzzlv30dG7wuG5VbgrcwlrJArGNeN+Ou1?=
 =?us-ascii?Q?gqqDhx4TtMLM37F7hIwb2Fjz+XF9Ve1jVpJTDiKrguzjobmxgQA8sUHb7o2M?=
 =?us-ascii?Q?rFlLe8Fwoc5I+W5so0o0l622F9XvDCqFA0h+X+kmMpdOmPjtNbX454syhUxg?=
 =?us-ascii?Q?WBs0vV0xOywnl9/5WrZRrCkvLOVlsogwLm/dSJ658sqZZZRd0m5JXk1CmBKS?=
 =?us-ascii?Q?uPxfZay7iBOe2QmUGXorhDfsThT6OFRUthHtEWB9iq5tYz3lNXhhs5f4oOoW?=
 =?us-ascii?Q?qAZRdS8eyicfcO2HIrEhUdHYEZoBGF2nORkjuWyXM3idbcia1g7ZLGWfLLM9?=
 =?us-ascii?Q?PD1WXU9taxmXcnWbd0PwTcsJOBgGqBHh8rv+FWJ9wQHdjQbC+Skv2RJV09I3?=
 =?us-ascii?Q?08AD8SbOHcNbkG+OiIud4HeAnFTDr2Hy4jCyfYTRkhq9k3xckvGsBK5rcGv0?=
 =?us-ascii?Q?x5Vh6USop1GZOAK782O462Z7vIiJm6TawPI6F/iVuVwdiCmjlpA81/0sDDd1?=
 =?us-ascii?Q?J8Eo+2rlJ6p+l2WvRF7gCED27dslYRLvOASReul945kca9WPjkXOqISBRSbZ?=
 =?us-ascii?Q?j1iL1Gka2rDZP650xk1fRn//leX9/SN//Vo8A+cGZm2H6BirMdkkFmUAeFc+?=
 =?us-ascii?Q?KUbpxoWaDTkApGs8IY8weL4K66QEmTzLDd7UXqo4k66nTjFQFENnwdJ3gqVJ?=
 =?us-ascii?Q?5C472tqsHzHwnqyn+bOD3wJCMqbU+cpINrgsgmA4jtnuVGDxpnXYAb5xI+so?=
 =?us-ascii?Q?uBYZQ/GgcCjttOumlJhIJsGyRHsGTNya0FYArbwbyKdc1TWrTp/RS6++N7Bg?=
 =?us-ascii?Q?aAh/+tjK+KtQvG/oucHikeg64OIPCpjy0f3GYmr9681JW4+6fB7TTjJhOLoN?=
 =?us-ascii?Q?uUXsB6EGH+lszx4i6McpvH8PHXxy8U84Ah89wIQl1VVExmbP5zdn6uIOCQRy?=
 =?us-ascii?Q?egupxCj6XcN8uSNYQKXmcGI8ovOVSafhMy4eA3bllQyEvrM1UZDSl+OK0GmO?=
 =?us-ascii?Q?vp2ojW7HLLLENFS/yx2DHALqjB8QsHC6rhXU4gQ22SvRdrQrsdhy04gaj5Ua?=
 =?us-ascii?Q?CoqbM88D2Tddn2Im25m86l3VeQB/vh7WWusJW/k9+jzieYxcEJzZYO1LTGmx?=
 =?us-ascii?Q?Eo48YBEPjr2Mi5dOtjGClju21QXlIUpYls/g/q+r1ckmrWTrtp07aTKpWsn0?=
 =?us-ascii?Q?Zyknp/pueNkfRTYQGLOtUod9An65IkM62k5UgswgHMgOm/3wGDzO0yv4fAgH?=
 =?us-ascii?Q?HUvDPMwVRQPuqisTfsPHJMaH27aCx2w0/EDzxmdKXrymsUpRtD8Gb0Q/f0pY?=
 =?us-ascii?Q?ZqKu3nFNzJYPn+OmeqbTEoblDyJbgbq3Zz/+7iQssiBP8VR7SubsgOcaM89Q?=
 =?us-ascii?Q?cKVXUsfZkLe65IYS2vpftJlq1Qo7IPcRFkc+wGtT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c0741c-c667-4e61-c550-08de3762be16
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 20:37:17.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MUMT/QS2Xwf6HBXl3Hqq/5cZOolxISDj7AA5bGMZPAim1jV4GM4nKtd752hFuBqnT82oCNDcHdiGuRIxVFFlqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7126
X-OriginatorOrg: intel.com

On Tue, Dec 09, 2025 at 11:39:56AM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 12/4/25 12:53 PM, Tony Luck wrote:
> > resctrl assumes that monitor events can only be read from a CPU in the
> > cpumask_t set of each domain.  This is true for x86 events accessed with an
> > MSR interface, but may not be true for other access methods such as MMIO.
> > 
> > Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> > indicates there are no restrictions on which CPU can read that event.
> 
> I propose to append (something like): "This flag is not supported by the L3
> event reading that requires to be run on a CPU that belongs to the L3
> domain of the event being read."

Perahps simpler?

This flag is not supported for RDT_RESOURCE_L3 monitoring events.

> 
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 340b847ab397..081ff659b52c 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -518,10 +518,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> >  {
> >  	switch (rr->r->rid) {
> >  	case RDT_RESOURCE_L3:
> > -		if (rr->hdr)
> > +		if (rr->hdr) {
> > +			WARN_ON_ONCE(rr->evt->any_cpu);
> 
> I appreciate that this addresses the feedback from v13 but it needs to be adjusted for the
> code changes made since then. This means that this warning applies to both
> __l3_mon_event_count() and __l3_mon_event_count_sum() , no?

I'l move the WARN_ON_ONCE() before the "if"

> 
> >  			return __l3_mon_event_count(rdtgrp, rr);
> > -		else
> > +		} else {
> >  			return __l3_mon_event_count_sum(rdtgrp, rr);
> > +		}
> >  	default:
> >  		rr->err = -EINVAL;
> >  		return -EINVAL;
> 
> Reinette

-Tony
