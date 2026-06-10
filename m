Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70FB3A7F49
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781125023; cv=fail; b=H5RTJOqPhXmYKMuA2I5mHZtimPXWYL/WX8QsuzFcLVqq/VMM9UtbwUxPb/PUkvqdBFyylAEtTbnA2BwTz3XE2/sL787ZWFF4cVAozHVukDglu18ueVyvAzoiFhG+vMsWEPkbIIZyHZwLHqc5oWr+VT/LHqcvEu1RnJorrrU7OK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781125023; c=relaxed/simple;
	bh=Z/Oc63Egr+IYKM6BSrQH9h7FQHqUtusMeeuelpYoRgo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pOKhaeAK1iwixjyD0ZaZ7ghgZqtRv31oiGYmnPZY44s3+ZdwCYLC67zml7424qt778L0jDwC97ybOkX6wOTRuWrL4yCxbWl9lKomkj3sw/kTewAjpL8mqWiFGil4iOrsmYgHxcRFwcpJua9SaD4RpdEyxzkzNRw7QqwH6St+e9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JqzQhhme; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JqzQhhme"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781125021; x=1812661021;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Z/Oc63Egr+IYKM6BSrQH9h7FQHqUtusMeeuelpYoRgo=;
  b=JqzQhhmePtHxzlgZWNSL+lZB67/RaWMF4931JUcC/r6pcxx+xCZQgyM6
   P2RCi40zrYOrTD8OtNahO05RB/wCVlNf+ObhC3ImTt3u8e176hhyR6nDp
   h6NeFaKm6clh/KSLJtoCgO8wjPsAdP0XYjtUbKIy1gZbhCs+r/nuAu3DL
   l2bsXa/z4jr9ssCX85l4pyEI1kyClcpIeq3u2GCF2nNRS45lnjOOrelXV
   Xg+2tAomKWns9YrlS2FKM1AW7dJ/LINBRLjVJZFAdPVJtVzcPKpfY3Pl2
   z1hWYqYIKDkcXB9cuOEQU4dmm4xYe6t5nx4ldfK0yN5lvECPm81GHFuVv
   Q==;
X-CSE-ConnectionGUID: 8hScbZ9lSwyY6qUNzTfxZg==
X-CSE-MsgGUID: k1f8LFhcQl28pEr+vrv0gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81835602"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81835602"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:57:00 -0700
X-CSE-ConnectionGUID: R26iRwDwTpia+ubqi6RoOA==
X-CSE-MsgGUID: O9+v1q+BT72EVlq1pQIQ5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="243813616"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:56:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:56:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 13:56:59 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 13:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y6LPZCGCG76P1eIKq8dPGLMDZLJ7MM/1PY9RHmlFr/7YWRGlm/bFV/VJG4EXBolkLJT8u2wG/Oab6/6pUGE1ddC9gSbXI/nHpMJEFhlVFHGEPOm2NtWhoyfnWTv6eUerwjvxxTEqieypJ90yMAnvUIwT7yzjGyt2W+8KqSQcj2H9H3U3HaDmGOrW5BifeEXbnyJkfcaBfXJHBe4tjiuUSoj7SOuAkQ0T2L4nZJIXUtZ6OQr9x6XerntdlU2Gby0/tqjH7phnLpu+pl3W6e4FWp5XCaYT6MaXUzfz973eLzE3OHa4eCIjANUrBhjeVPvqnvwGEMWxQxXuIuoIxGI4VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+rVR5+lOBEs0mbgsaLwERUyjUHCxt1W2sLgSG4ZfaU=;
 b=vAbtXcyKMU5OnIRFcSr82yOTNJVAHMRFYHij1Z7o06hMTdky14G4FJfFkHAXKovQxRzYe1S5kNuDX2ObI4S/hVdkC5iXdcPEaP3v0bp8SpmL8mrnb1epYJBAZAxX664IGo6IGnygOYFm3CZVqMfFsBywgQONbGyIj9CvnQ8+F72OHGqLoVt/AczoBj3IIycHWFjzC728Eov9dJBVa4D8FgLw1ZTLvtgnsGTpklRbAZNoh+Xj9g9hJHDcldNAhaGZmo7v97GNHndL5G1w33WmQRq/VluVM45Xx03FyuX4dbvwElrviRcsAONBu2PUgsa/nBexSnDpLCEDG9j+/7gaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA2PR11MB5083.namprd11.prod.outlook.com (2603:10b6:806:11b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 20:56:55 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 20:56:55 +0000
Date: Wed, 10 Jun 2026 13:56:54 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
Message-ID: <ainPljLE0yc0o1mv@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
 <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
 <aihLqhlxS7l1y3jO@agluck-desk3>
 <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
X-ClientProxiedBy: BY5PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::40) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA2PR11MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c94768-398c-4531-d9e3-08dec732ce54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|3023799007|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: w+M4aP2xFCmvKJbDCfo0SEVR4lJzAEGcHfHXuI3GapJkSuDmUBQFNq5hTBAIb6FP+JMwIMnZCjc45z2W95hXRGEUe+MkiT+6mINZ2hDSAd1c5gfFNjrocVqe3lIyld7cbtnpqVKP6AgrPTbeYyjYOuEDFfSk3eBUrWmOmmeEhraE0xAypT2hCZKw3AjTek5L/6zULJF7SSAm1KL9h3H0/NSHK8TlcKmP4Lo7Tp87NRkNuU73i4mVmm+WS1ErlIXUHacDl5wuAk6ELNfHv+VLkAY+TZMT2pviqHX76h/S7ov1NNhiWDXPbH33tV8JREk4gb3n8b5xUJ6ggYm3EKIQoxBMPtqgj+X7TOSppBuFNmCncGeXK4lA/JVMsaFkpxMvruzpzE4A1rjvPxI3Gmkla/91GEmwKZOAxPVmwkLDeeDg6fdsHDgQepZIS4vsXf71bRB+gZM8IlN6HgUSB3Few+UvmOB0lljs8IOJF1s1n+QJ/kkJx7BoCu1ngoIarsmdbruRpGxfugiMXLptoJtSRWruvX+OO1T9L8B4v5sybJeA/+MQDwaEcp2Gy0UnTv3WBQPogs8ocG7YH78yB/CE0M2Hyz+OYNy4dYr0QU+KGp2c1/ob9mb6InbSCNRSIHcAHWW762OgEByXJ5q9e0m5H6mTJZ1TDmQR0z2VLex6JQh1usyF2pPikQHBvl5D2ju4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(3023799007)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UY0IuvAetfbNc8sI3LWOuVbt9hzYY2ASvxj0bc1XhVwiZ90Tdk469TxbYEyc?=
 =?us-ascii?Q?cE9UmFdMrLD+dzyecf3+BKIm6qOhB39swYehexDkXqRbSzv26zSB4w5XD4R+?=
 =?us-ascii?Q?zZEHgiVYPEnKgl5NDxzwCemQ+L+EWzQ2UE4OU/cU0/JQb1qoIYrcsrilg+GI?=
 =?us-ascii?Q?TRzs1iVA+h4prtXGTP6uacquCO1UVKDNR/3wdpU9xmnuzWUYZpkSoTkG5qkf?=
 =?us-ascii?Q?eKeaU0oPPnWlQdtWfxTKuDSCs5RJE78fM9zkYtDZ9Q9/sz8CtjNVLpmkrhXc?=
 =?us-ascii?Q?D0yd18CvF7Gf5t7q5utjhrG77em3KtVJpC17tWYmSIhq2NoQKvpGxM0S91Mk?=
 =?us-ascii?Q?4z/io0Jlp+4HLcfDbzYXNbQGm6vk2qdSHSFo2w8R1V6j30RNCQGzO/y8z2Ja?=
 =?us-ascii?Q?QwEgL7P2iAojpjl0MKcUIExR7QlpRJqvbZZzb6TLBTYHU/nJt9fs7KUkL2A5?=
 =?us-ascii?Q?PAY4Mzsz+meonM88wP9K13fQX8Htmcfp/D5gdAECjAM5nCeq7XleIMTxGO0G?=
 =?us-ascii?Q?uRY4vfJqWro44hWOjJ/vYgn13UOrgtYx/Y3HbzgbAz4V6EzdWsGQMw2HuBUn?=
 =?us-ascii?Q?Ky3KLNGL4X29ZEVayPwin4tRMFC3lJ4CJtvRsfW/J/1KYX2q3yjv4sVaB0ec?=
 =?us-ascii?Q?EE8KXyiUD2g+++q0SKTlhLL8ntP/iohzdnS2c6BZwaCYNhqq0yQtNCmTdIIJ?=
 =?us-ascii?Q?VHaGVjA3fVKryBG74xHoR3/IKRJQ7LwsiXLh9chUErmsTrRPzbrxm5JoPhLt?=
 =?us-ascii?Q?vaLJiSKRpQIuvsFWSMnisCXfZ/vhtq1KH10g0Rej0LvattADLWegQF+3Cz07?=
 =?us-ascii?Q?DdFmrezQOkc+DwHRmdMzc9DgjDY3y4QG2NnI7ceamBWqPb9R1yjWSIXfHBAV?=
 =?us-ascii?Q?vdZIa7El8RYow276ZTpjXGkQdThCC7zth9TtfpLgjOY1Mvape5JK5hppxdq5?=
 =?us-ascii?Q?CxgLa1P+z4mrCjrFbWS9Al5gTO3I504nIdMSAIpMWPusWaaR0XyccPEwbD2Q?=
 =?us-ascii?Q?hqRl1ZnWGfKS47gcM/ClXLV9fo2MqITO73lRlMIZqMXV7TEC/gbAuqp6JPaP?=
 =?us-ascii?Q?1vSSvJZOAy+wcqb1SM5dhGiDrkGetpbOgyAonzVehOJcALR9n17kKyT7cedj?=
 =?us-ascii?Q?BeNrd7FKP05Q+N+hIavbbiPq2P2BaPaUy9YkeHF02daHHtLTOBn4C6KOo2AV?=
 =?us-ascii?Q?wmxXcZrv8NmJGY6dotc3BvcNmwLNf2tRnC9t9zpN64CC1+cgmf0mLcMIG7MX?=
 =?us-ascii?Q?cafF0hLlEouYmpFad6wPF84wWUvdRm9yaR6zz/N1JuxF8hO9Jg8IpR+BgfLN?=
 =?us-ascii?Q?kwctc2KT/dyIxBR4HCt+i/sbEZ7AYTMbJJBw+G21wjnUSsJ2CveW0axjh5wz?=
 =?us-ascii?Q?5MZTrLvqi29jfBUHQ/OFiUD3psHN2LX+xjfW62kWAqKz1MZs0Dt8r+gVMZwu?=
 =?us-ascii?Q?Bt4rwuGuRiXd2TXzDR2F4OsX6G8oI8sFvAtJNq5hOKYL1H7O9J5LR29LkEzH?=
 =?us-ascii?Q?Hf74oGS+1ikJqQwJtm6tSCqI2yjXAaiTFRRWmJ5oG8/tlhhscJtSg95kCEuf?=
 =?us-ascii?Q?ZEmNuCkjW3SM4lDn/kNsTAuPb/PyHiS98CmVDG8jwyZMhb41MAy6bRoCBsOD?=
 =?us-ascii?Q?LkUJJR6ZeFA3x9tG71tLi0qRrDTs9ch2XJFc2CvHFU2HeezHYn9nfYEy8ZTR?=
 =?us-ascii?Q?vBTqbM5dlyZBunaAnNgXHZy8ymtPQ6fjWdRKjv3BJu0d6h4KUnRSsW4BcTp8?=
 =?us-ascii?Q?zBElHKloDg=3D=3D?=
X-Exchange-RoutingPolicyChecked: GEiZNlsd+uhDLgLPLdk8Rc6T5B232u1z/0SyaO6X59FLn37Z8jYYqlc+e72X0Xtu2nZbXe6qFYeVnzfIK39afk45N3BK3o0LffvVwu0vUI3Bl7IK6wTWKQ1V+wlT3RN6BPFKn7x6oTiMio0P6cQgIH0x+Vfe9rmpUoTPfxeJ0ZOss/2xRo6x+mas4XHNjUrwRQXHmoRFzlg/H/1Y/ncrbu7SMw8YRrSfk4hljzO9Gna+SLEDGKTozcwzB/I5AJZbnclQKlr1DN4oVf1sRzpcQoo5NM6pnWKaDyzjhsCOvrwbOMwJiEJYcJzN0W9Z4SiylQFcxNyUm+721lx1dU7wow==
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c94768-398c-4531-d9e3-08dec732ce54
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 20:56:55.8271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8ObpZuMkzR0y0HKY2rmjDRQzTR3IQnwwBmV0OIxjXe/uX/Z41ZBSX4pV1vpjYzNkcNfWGzD8yPri8Kx4m2nww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5083
X-OriginatorOrg: intel.com

On Tue, Jun 09, 2026 at 04:02:55PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/9/26 10:21 AM, Luck, Tony wrote:
> > On Mon, Jun 08, 2026 at 04:18:23PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 6/1/26 12:56 PM, Tony Luck wrote:
> >>> In preparation for re-running AET enumeration on every mount, AET code must be
> >>> able to disable events on unmount so the next mount starts from a clean slate.
> >>>
> >>> Add a file system interface for architecture to clear the enabled flag for
> >>> a given event.
> >>
> >> This just verbatim describes what the patch does. It would be helpful to describe
> >> how the flag is used by resctrl to support the first paragraph's implicit claim
> >> that the enabled flag's value is not relevant when resctrl is unmounted.
> > 
> > Revised commit:
> > ---
> > Subject: fs/resctrl: Add interface to disable a monitor event
> > 
> > In preparation for re-running AET enumeration on every mount, AET code must be
> > able to disable events on unmount so the next mount starts from a clean slate.
> > 
> > Add a file system interface for architecture to reset architecture
> > controlled fields of the given event. mon_event::enabled is only used
> > during mount and at run time to check which events to include in file
> > system objects. It is not used during unmount, so it is safe to clear
> > it as part of the unmount flow.
> 
> This introduces a general resctrl fs interface and makes some powerful
> generalized statements in support of the interface but these statements
> are only true for the AET events. Surely mon_event::enabled is used
> during unmount since domains can come and go while resctrl is not mounted
> and as the new comments explain there is significant state coordination that
> needs to be done between these event callbacks and hotplug handlers.
> 
> Similarly, the resctrl LLC occupancy worker keeps running while resctrl
> is unmounted and depends on LLC occupancy event being enabled.
> 
> Creating a resctrl fs generalized interface but motivating it with a
> highly customized lens of usage without making that clear in the changelog 
> but instead just making grand claims of how safe this is seems underhanded.

I can rewrite this commit comment to call out the limitations on event
removal. Those are listed in the new kerneldoc comments that I added to
the resctrl_disable_mon_event() declaration in <linux/resctrl.h> based on
your feedback on previous version of this patch.

Is that what you are looking for here? Or are you suggesting that the
new interface be less general?

> 
> > 
> > Add kerneldoc comments to describe limitations on when events may be enabled
> > or disabled.
> > ---
> > 
> >>
> >>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> >>> index 9fd901c78dc6..327e7a863614 100644
> >>> --- a/fs/resctrl/monitor.c
> >>> +++ b/fs/resctrl/monitor.c
> >>> @@ -1012,6 +1012,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> >>>  	return true;
> >>>  }
> >>>  
> >>> +void resctrl_disable_mon_event(enum resctrl_event_id eventid)
> >>> +{
> >>> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> >>> +		return;
> >>> +	if (!mon_event_all[eventid].enabled) {
> >>> +		pr_warn("Repeat disable for event %d\n", eventid);
> >>> +		return;
> >>> +	}
> >>> +
> >>> +	mon_event_all[eventid].enabled = false;
> >>> +}
> >>
> >> It seems reasonable for architecture to expect that "disable" of event undoes all
> >> settings from the earlier "enable" of event. The new function only sets the "enabled"
> >> flag to false though. This is potentially confusing since it leaves the event with
> >> some lingering state, some of which is a pointer to state that an architecture may
> >> be reasonable to remove after disabling this event leaving a dangling pointer. 
> > 
> > Ok. I'll add:
> > 
> > +	mon_event_all[eventid].any_cpu = false;
> > +	mon_event_all[eventid].binary_bits = 0;
> > +	mon_event_all[eventid].arch_priv = NULL;
> 
> Thank you.
> 
> Reinette
> 

-Tony
