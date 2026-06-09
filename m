Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2C5347521
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 22:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781043081; cv=fail; b=Qc28sQYhUuX6jMDeoQgjb2v/aeUwj9E8eaqE3UwriPLumVViXJhTt7E12mDB/kUnh8kvjaRDLAyX0EtJTo0D0CHRkAEgWOF8xKfnMf9oUKdjyWwhgm0OQmSmP6unU/MUHSFgvck+GRCwmq6MSsoDey9GHgaax5lqIaL2kGwKuGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781043081; c=relaxed/simple;
	bh=4S0kMSl+GT2rzWraF+trhHZ3IHCIrEBR3HhO1fiCvA4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Tzlok8803PlVruw7xBL/SuQv12aEcQqy0I9Hm28Es66e/X931bK4bB+EI7K2/k4w/5KBCSMl/+braMJFHt79cWBS6fOqDR+QE/vIXM1czKBo5Whtq2stFNsiwNRRF8hUwHU33JaGx+3bhMuvOaK/EVa9tr/dIIutdmZwImOuC8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tk9uIzGz; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tk9uIzGz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781043081; x=1812579081;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4S0kMSl+GT2rzWraF+trhHZ3IHCIrEBR3HhO1fiCvA4=;
  b=Tk9uIzGztT5CombGyQcmgeO50tTJmR0I/Yrp9K7WCHpIAEs+uEzCdU6Q
   7luosYK4MZ6TQshmQD7RsUS8Y9PXrDJzbg+1pPCgWy1hH0nqPkKEguqtE
   P+K1WIGUOz2A9yXoL8VtGYHwut39XnQu/21LcnN6vLe4diPQffzaKmiK1
   tj+iGXXvhT8dcLeOonU/3ZXvm1eeyEDp5zoGzKUSVTLt4cHXMW6SniA5h
   RO13KAf9gtKfvslVp3DcwXD+eol+5562vM8N/eEj7VlfohlEkPebqUcFp
   MTaKlMqXkZZwqvhQEPfgHJWufU0DZndrDVE+AKg1UkiEktsfpTdtC64Ai
   w==;
X-CSE-ConnectionGUID: sstP9171THuXjRuhGtKxIA==
X-CSE-MsgGUID: lFT5bIdbR/2q3FUi5M62Cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81890511"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81890511"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 15:11:20 -0700
X-CSE-ConnectionGUID: OFIeCdrwQOaGVUJyxBGbHg==
X-CSE-MsgGUID: sxbBQ+MzTO6t9HI3XiotSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="249904989"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 15:11:20 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 15:11:19 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 15:11:19 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 15:11:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UN2J/q8MK0nYWMlb7QqskHOexLnXh027DPsaQhzMS82cPO2iKIDot6BE+Hv/U9+MDM80EB8l4eMJrwxvo5SWKin/2eL4qSrCTR7dVZR+MIh9AvIuGB6K1qtzFmbOd6/HAAyrNTM/2W8AlvCYpd8VZwkH9c/iUNjUe0nfNgLPTYpAlUFAx0tU8QIqB2TsZ9LOznIBhxNr3LWLrOzrQjt9nRmCs7oTvdlvwG7QW5Qvh9P5lsHSct5pd633XxeUsGyNsOT1t6X9eJkI7e0PqXge4fdHCo2s2exY8yTVN9UQ9NfOOkFnYAnnVyYnayMWmM88+NieUngYIzwp3uu0smL7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFCihd3RKvvYxHVBLQQutLSXHiQuL4NZrKTxhD4t6KY=;
 b=uvfBzo1H7quxE4gHIVU69eY9UFzKgh01gVFnkRrgb8VmVXhL8iHZmY0MQ44RIwKQEIsJ5DMNcie6/D/bEwWzDCC/oTf8Ybd/OofgTfaNASUIsBsANqdAJHlO+ikclk0xP1f1UvgKj5ozJLoFmZ77uaU5wWuJXkm51vrT9kOIkfDaiJp/YFaC5AP8W9Ds/pN+HIN/s9WbiognW0ry/n9Wo0/zJxalIZ0V1kA6+HOqZSDZy+0pC264LYUj5YkJ28aLF6Ogn0JmwU62kLCq17FXt7clFfRBCpVAdycG6xvEr44ntcwhru7/l6AL6+o6LBaE51OE94jON7Y0yh1s73jwPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7082.namprd11.prod.outlook.com (2603:10b6:930:52::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Tue, 9 Jun
 2026 22:11:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Tue, 9 Jun 2026
 22:11:17 +0000
Date: Tue, 9 Jun 2026 15:11:14 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
Message-ID: <aiiPghaWHzOREKfr@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
X-ClientProxiedBy: SJ0PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::29) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 5edbebbf-e123-4ef0-fa3a-08dec6740682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|56012099006|11063799006|4143699003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: wgvvLPqxB3rwhRP17jqnkCeZZG3xlY6v1i37/1Y8fx3vDL7ulFPmXlkql8tcOeS9CayMMYBWDTPstUtnCPmLHa+UsJkPD6NWZNRIrOQYrAHRloiaaKy2koTkwTZfhkp7UMN3ONnMsjn7lpnxKBTT21krPTJ1zD17juWNtfp6UthqqNbXBTgyvtHcg0+rhXrF9qtPi3I9GJ9OQgwAe7e7M2w/778fNPs33lontm5bgo+CYa4mI+xaqPjrGuHdEivoqXFjiJxaRI5NOav4EM17q3a/1OIaleUe8E4ubfb/15V2SLdfraN2dXxjNsXdG/rAg51EYR9bp6p3pl3wm7IQJ6zI9AmHs2EhcXPGDM2LauYoQykExnG6X5g5pjYkpRdq/hhgIi6FUcvELl5I/rKpKRXY6ucqaOS4DEpFTfTIf+lviR1KK9kcuOJomU840eEKARgsNikOL5AEKAeSU2INZLci1hagQi44Hwri2abI5juB19rQ12v40QeEPboL6OWk/mf+xCqo8uCGsE8o+6m54PeMGL2k2XcNG+SFOC/nPqxdGtEm5j1X62sA7H0Ustr8H8qALwotz2UqXQKtjnXI1z8t8RoQoHIn3dljCfHTV+1tM0CayJUhLVO8cgC7mJ0yR5QaYLzpHEvzkpnaeh1v/TPhdXjpTvpuA+meTlg0Q+++VONsboBbtJK8Yi5PpPHZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gncj/7P6+dEfus/a5TOUD/nx1aFp8S0gfcOs//Y/mKZkNZN0Nu2w40Cfwd4+?=
 =?us-ascii?Q?N1HM69hy6X1OSXUAi8CiYY8YR5zYX6Bjlt/v3GytPb3TN1IdQ2t51tkh/YGF?=
 =?us-ascii?Q?aYNXFBoQQ9zx2A7mN2ZI33nsiuffLM4kMeXvdAsnNBECeTE/kiWEe54QMJvc?=
 =?us-ascii?Q?RM/YNsXSJ0QvjcqK7AVyOr/Ez+EhBquRl2lQNtgoA1qOyTbGZVizemIQmsO8?=
 =?us-ascii?Q?gcpKI/Ozfxk3AOepy9GIKcwCxp2tcFQEt8VmQvNtMc+kZhaUSgQl1ARxG9VU?=
 =?us-ascii?Q?9LrCREeCX4OsXcHQAqleROG6+2y4kZ9Zxhw/cRgZQoSr+VMg/LjDjrRSAiaO?=
 =?us-ascii?Q?RtjsbALNsDj0H0Ojf9h0rpwoo+AqArriCM2QeO24XotjtKhHOvUV2iDiQoJB?=
 =?us-ascii?Q?Lpw50Ncjp/kOBB4SMq26nUGLA61fVLl9/+SotqWZMODglzAKMNGDmBJ3KMcR?=
 =?us-ascii?Q?lSBttXtnqrrN0dOdupMYRHyWbtP3rpWEUQnEn8JutSlpwqidyI6YcMvW2ixu?=
 =?us-ascii?Q?jb6pIUzopUZuK9qeBHSFK+HV1lznQ3JTr87uuWr3AO+3aACu2V7MrmkZLe/E?=
 =?us-ascii?Q?TuUolT80lBQuOXoiEDFRs7ChqU/9mCm6g5oT7e8M0fuFmvMbnirv6u4Vu5MJ?=
 =?us-ascii?Q?51luh5vlr0w7aDRH1SEUj9G9o23A5xmGwAI8Yoy+wwoJ8i/77jqVuBd3w8Gm?=
 =?us-ascii?Q?w6uokTIjyWz23H0dY45Lvu9VTaYCm7e2KS3dVen3F8Mzzhm8wZCWt2/kgpJ+?=
 =?us-ascii?Q?OTlN6seiQ5xwasHuKj1ZaS9bDCho/JvLziqaL8CxoBT0swI5h7QgOwsxe6RS?=
 =?us-ascii?Q?08HTu1X3pIKxxpoUA50rEGIJMtXqN1EfW4zpxFOgA1qGu3K7MHmnXkkccHL0?=
 =?us-ascii?Q?8Mf+ee7fh5mnHaHH+xFfbBt4LZ1roJBEWuAZHYk6Wp+kwSOr+28iuEhtGCBB?=
 =?us-ascii?Q?2Sckop0o/fopDPwHIXddgHfmzRTebm72gwavNEqkzjk9Lb3L2ufjrCt6cNif?=
 =?us-ascii?Q?2OH6RSgG3h2m1944BEAVPxPiKxQsPoX6UnIGKbbPo3UggfRjQNlyQlZpIoj5?=
 =?us-ascii?Q?f8Eyjhk7SSJZERfQWdhmFzI0lifp79+noNDlXiFOnq2L9Gxd817tsHRZFq6Y?=
 =?us-ascii?Q?+VplIrJForWeWXukChrXxQVK8tkKfNz8hm7ZL+Hutf8akS72JI7OqyD0G6ox?=
 =?us-ascii?Q?MWv98sWFZzdcD91/ZqKV3zHhZ9O9RT9RS5stY9m3SRgvAnd7I5AKDWz4j/no?=
 =?us-ascii?Q?9KojLlgwOVRT5etfgR3JA6V42QkxMsaxo7E7jYCVWnAredHLHu9BtHZzvfwB?=
 =?us-ascii?Q?nyka4pUhXyeKhtIY7yayEa0KoiaKtUnaoKL0t6icGPSD5kKpJrwnYBA8LeO/?=
 =?us-ascii?Q?lyFYvDoQ4u2bLDetG6krK53ZHOF2Yf3YdBJwuTulCHrll9/lRck2L8guIIiR?=
 =?us-ascii?Q?OxOhcaLqwWY/yhJjh+WECk6HOyRgTXkDMB5QhPuuoEAmDbwTKvBl8kZ1R+nu?=
 =?us-ascii?Q?Xfe7aIAzSsZfuM2OeBMHSh0NnxQ6JsO9YWjhfpQDqDOBZ//VGcfcM22SRrhl?=
 =?us-ascii?Q?MDcnBfraGHUgKYDHPsDl4UsQ0izFQ/+CclLc1mB4XwMoPmd5kbZPBPCz0bSo?=
 =?us-ascii?Q?xRrpZJv4JvDF96J08UnGyBrt4jvMTkixvX9eQZa8KemjLuctlfHeXD7+KEEl?=
 =?us-ascii?Q?BRVg6zBX/kwHdUoGRnXI3jSz/6zYG3j3cPOTaWn3IIocAOWEwZGD10muLLpe?=
 =?us-ascii?Q?zBtsjgFYSQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: MgL0eXMlUL9+hnBAMFheAWVpKWo+Ax2qGe0xpjxcyQNY/lt6U0MmBo5miRGaJzt44vnr6vF7S2TWol6RQRNg8Sz30PxEoAwZUxEJu6FoyUyZp3GGIpeqA5A+K7cJ1ifh9m0LcoW16kdqZOAs8Oo7XbiZeK3uXFsPRHMS0Gf1r9gcCZjtaCHaMtePIiLKHGfge2tu+Qx4Z+kLPmlhhSexxNiGDtZ5tlvbM7ObCxi8/tfAo7ZY/x/pObGtEdgkfzTLtKfMgoXdPZIBEsIkXzYuplkHzbfW/jzHyrHDP8a2XVzxdDQhLbuyohTMEwqp0O+iCjkVhBg4XX6Yi5na7Rr6bg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5edbebbf-e123-4ef0-fa3a-08dec6740682
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 22:11:16.9250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0w8u50gKtTlxVti8i/WILN2oneEYlk47mJcZnYHIGYVP2GDSiJ0Y+Y9hCjIRNA74DhfIYni/lChHojzYYQ+5qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7082
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:22:27PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
> > call PMT functions directly.  Register the telemetry enumeration function
> > pointers at pmt_telemetry module init, and unregister them at module exit.
> 
> To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
> it be more accurate to register at the end of PMT's .probe() and similarly
> unregister during .remove()?

Will do.

> 
> Reinette

-Tony
