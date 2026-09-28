Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3000D4E4C5E
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617253; cv=fail; b=mZ4Bv4n/7IB55Dx4u3Gbl9PqqVsOz5UPlqbknotQlNkii5tGS0oV0p1JzXCDR9cTkmJD4O3NMi+yjUOcXKl+ciTMZdV9VFdx4sw9L5yTLb1437crnKObALWugbT5+fcolw2O5GFPGteBGTVx9V+Q1Uxt20jboY95l8AmXYUzAPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617253; c=relaxed/simple;
	bh=h4kRq+r9rbCY22WrC1Q6/se4fVJGmBbV0BlisPlDlVU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UYk0dgwXKg2MwgV83IA6/rXYoRvY4XEBOByFkldRyAQ28D4dKJE6VjU2RiMMtWWwtaK3pqmVil0KwbUHLmvnxIlLLsdNx92W2iqrdpeEbjvboWOYLqnCNltxWZ2UH+iI53wzxHw16spE3mxc25Ee7mBOlUi6DBVLzghlMXrXcA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0H6CtSZ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0H6CtSZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790617250; x=1822153250;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=h4kRq+r9rbCY22WrC1Q6/se4fVJGmBbV0BlisPlDlVU=;
  b=g0H6CtSZTpPvRq3yw4mGT+kDN38Mz23QJEvaXmCRaExqTGPK4bAQajP7
   eOTvq96sQgxLMqXjl4Jp8N//7rM4bXzNzKBljTScV8ozpPpbdi9Tx5tXT
   APmR8ZRj4etUcKQoP1Eg1bZcofYzxSkMLRxsVshmSIzSmOFr4GzZ08vEu
   lk0m+/UDcBx6Ljlk3bjFO4o0wpQFsozzfuQIrhoM+iJuNOIOKC3BbvCpt
   nnObapC1lNJMI0Nx/t7MDi0ZnQzvm+lkvPE23iGdoihO3/XmGCn8p3D06
   9O7FiJRquDWQQ6oAUI9MKTyAnBTuIqFsDZHALGHeS1ngarqX/tdnjR5do
   Q==;
X-CSE-ConnectionGUID: wRb0Q/BcTtyYptQJJigWhQ==
X-CSE-MsgGUID: je1+PZNuS7GlAB4t4rr/JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90451588"
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="90451588"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 10:40:48 -0700
X-CSE-ConnectionGUID: orXCeti0Rai1NDckeH1EIg==
X-CSE-MsgGUID: mTXVBIYZSt2xPe2b/pm7WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,128,1787036400"; 
   d="scan'208";a="279840069"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 10:40:46 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 10:40:44 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 28 Sep 2026 10:40:44 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.4) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 10:40:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrghXpnJFMzg0SAZVUeuLk4oy/NKef7RtuVojjoZGoJI77uS2AWOFz56Ch8aRbNLDMYDVkNYAxUh0g3W2li9cP43nsTch5jwts+C8E9TFwgkUd0OS/yj33I9fR6pHUDFXalNs1TJR74FG3xHNfba/2bO0NqCWv1Gj6CLnp1w9t/uNEH5t3zZBKn2Pf7+f8+DVV6Hn5e+J+xfjuQImOnF9K55O1MIntTk4yqvUFpL/6d7LR2xxMqXKcI43hygYIKEbQauX3gBiDRXtuN7eXQdK+7t2XbSV9IGhbevSEoAhST59WHGGhvWaNdvgGxAsHr9W3Drqiq3itbgMy/TJEXTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dlwwVLMg4MRG6bgHPB2Q39B+rsoGRQmE7RXWqGRYGY=;
 b=s/GONA3YCI9yRlLRWlvseja/IPsTbJL+Y04EDutyZb1SsNP6DttGuFsk7hPdoY1IYrUxRhzs93Zj1UvRxpk7mCA6JgRO/aZ3o6SZimkstm8v/0JKMQDes+KUUtVHwV9guHlkgF6C+EuUsMrIBLDm1VmEaUsHD1un1crIrrbK+137FKnyRDjnMA8sC+Nuf49aEqKAn5DhWW5t9S7hUrIcWovovNWsnGH65w6e4dO8YFVX5fvfg/dJEYhmfFpMkVkiZlEuTVqNHdZtttpygJT2epO2nPeJMpsV5I0b4i+Hke9a7nkhgwKBrCPgpAcAsTrX8Uo7CpKG6pZMbbUW2ZVXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BN9PR11MB5305.namprd11.prod.outlook.com (2603:10b6:408:136::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 17:40:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 17:40:37 +0000
Date: Mon, 28 Sep 2026 10:40:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 06/25] arm,x86,fs/resctrl: Replace architecture
 resctrl_arch_{alloc,mon}_capable()
Message-ID: <arqmlAka4BQ-k4rq@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-7-tony.luck@intel.com>
 <d0e563ec-65c4-4a00-bd54-61c30d80890f@intel.com>
 <arbyVMoQOeCq5F_m@agluck-desk3>
 <39627dfb-31dc-4b09-bf35-230e655ece2d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <39627dfb-31dc-4b09-bf35-230e655ece2d@intel.com>
X-ClientProxiedBy: BY3PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::11) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BN9PR11MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d98a7e7-84df-4aac-cde1-08df1d879b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|13003099007|3023799007|6133799003|10067099003|5023799004|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: G3OFglcuoeavAZwz/Hnh9P4819RiiI8wQBi73VwkiL1Waub2yc3FUN7f27YYTCIdOJqAgXF4RNvgaASWkNSsZg2b1F77vu+btrfzWifhXrPwp3srhPFCj5ITuYLrABPUOFd94EDUuWE579nCxH/UslXtU8h/cYEfEQ8bny8iL1o6iH4iBWAH7kONtw2xeAcva3u0JAKMwDbbxzeJdGTQu3IZ1lGd9Lj1IWUphbTvG8hQzFVR4XnurawQIs0rI9++6gm5QjD3Ky2caC2PQiaRr6MWdJ0XQcbE98UiiMCQbfzZafCdI2V3d7xajWF06V8/P8teKhS5O4qvYgXS8naeew8NCRB/SgfqlmCacVFgFZwh5BIW4Nb4dXGo73iXYyl/xv7O1rZqmrUFK7VaOyQhVCiuGavFzd4i28SBSwf1RmFzPfPP1I+UGNWpb7KS/K47CTuDWcemGJyU29WNibMitzFIwOO9CLA7x9nZvP0efuqXzKlD6eNBMhKbNeF7JdN11HiXgTMKNCrW5Ih4GOD9pLyoLMZRy50T5XSztXByJh2Hu0cIdos85snAiHFal3hTZn5zA/iDpBzt0/pGRk9r4y330Jkw4Rrd4GDg02b10y0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(13003099007)(3023799007)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?swui3NeOJtYy4xdMG4VDN0cX/RyCdFl58Fd4XxYe+9RkI20zsKFtkqtsAg5K?=
 =?us-ascii?Q?EZaDfA5o9I1xYg7MLunPY/I1CYlO/zGA7WPZAobYcSFkNm5FIhRB4B/87obo?=
 =?us-ascii?Q?z7pJAL+L+Qhcz41z/pLAeUwdCbd19bJy2oFFOkPTWYliZWXqfChXFwfcYCnn?=
 =?us-ascii?Q?HwrR613KWsJ+JcTXzCCFZbgJX4mMXcTwk1DltWHeew5xQkTw9NUMdufe++EH?=
 =?us-ascii?Q?S44vSOErhbSqpElE1l1FBryOpYwlczNNx05acvWbH3vIqAPbdoJeOdypQmcW?=
 =?us-ascii?Q?yw9Vu39gJiXPywbkyhActS/5FIDpJkStQ31304OQG92ufpfq6zJJS7wnQPOu?=
 =?us-ascii?Q?Fa21+v6a9J7/FHEI1y6V/6r8/Rk5fXPTFDlbhpZ2J5tCyc5KgH0nNgnh2aqq?=
 =?us-ascii?Q?Lt3Gs4ZC8Lalc6wT4ZCrKJ5LWh0VnvRbxmU6NeqRtBtUTAXF3u83pC8u0/bP?=
 =?us-ascii?Q?UlUxt6JkGp6t7FEsfYD5gUdSjh/8Hzcw9Yoq5W3CblHk4o4hF2PtxxdvXisR?=
 =?us-ascii?Q?kn6DoxOQzd48jbUIa2qXwLf8V9f0uJkq02kFXJwsQmInJw+38LGjUa3G4ied?=
 =?us-ascii?Q?AVyAd6oHWLLfX2q9TTierrMG+LOWSXF8yJymk+t+pFoUUW7JdvgldAjC2DKJ?=
 =?us-ascii?Q?8yHvRyJF6Pr2vxK//MXOcB9cNqUcgaLkH9ggBeEChYXt4P9dpbNduhMe+IoN?=
 =?us-ascii?Q?hUSWAeg+BEXtema4c1joWeS+nENWRaMSoBskgPmLJjDRZqU6IxQq4ikdp75F?=
 =?us-ascii?Q?2gxxMchv9416pDzfATFDsbHueK3g/0tqn2s8yM9kP7b8enXqs7wRt3MQ3Xwi?=
 =?us-ascii?Q?mS8nGNDGPtxNN2SZveUeWAim5yXHnH9Nk2KsnhO/VcTNuLy8RjpNsl4Ujesg?=
 =?us-ascii?Q?Me5I6wUUcDsfe62L2ulV5XLyJjeo1SPxUQbp/QPt8XaGeqYIHzPtY52V+0hu?=
 =?us-ascii?Q?sJfdYWvUGp/5yOaj4hIjCtxRARvUYldpa8H8wY+wernorqFthHGx7bHg/6O8?=
 =?us-ascii?Q?6995hi/9T2pL3unQRBfjsakZEcWFa3kmHdv9mYX1601KcOJLzj+0V0wxk0Mh?=
 =?us-ascii?Q?P6xzEZivHZs0jtmk6lhBkqsVhLsgC3aeGQd6g8HpaHqm2rw5HKzC3Il53zrZ?=
 =?us-ascii?Q?hJDGzvdYv+HAA73o0K1DZ12Oq99+3N84mbdeCtZtq+LSFCoPop6CGUTKJChI?=
 =?us-ascii?Q?Ny1l0atZw85ZaMaFIlarjLC5lbxwUN87np9ew5KLLfy/nqC2nGhdB9xE4/AD?=
 =?us-ascii?Q?vbpgVikFSF9XhxCAGGAh5s6mrDgsEY1DKK5rEXJJt3VA6UkXJp6ppQ60lcpg?=
 =?us-ascii?Q?NWjbAKG4d5trrxDWAl4pjKPra7V4gJ1ie4Y2G7470H50kP2Ug2tFswyCpiFb?=
 =?us-ascii?Q?1a/9a+ST5CFLL8T9dRTH/1zEfCPuq1x8Enjz1l7NqJHdex5Fv16PX4pt04w3?=
 =?us-ascii?Q?1JSxm1eNOdO4tmU4DaLzegAWSu2eXhugdLCw6l72OWQSyHj9bK1IJOg0EpPr?=
 =?us-ascii?Q?Scm1KaplSfafNGVH5p+/GZkcnZ99ekClcXk+BscSkzoStpS+dPZVIO6s9jeR?=
 =?us-ascii?Q?4Yv8TTB4rljxb72yXqiUBvmguH3fTJ2MZ9QFdMiC/wLIX+QH8o2MOc1QA5+P?=
 =?us-ascii?Q?aFzKYpkKLXazlG3nGWgoqpWCTOYYERHEpdWVeG+fHLsdL5D2EpZVsxI3IvnM?=
 =?us-ascii?Q?0h6lvv0DOu0rt+gYR5WY+0zyKWpwzwgzKSyzjHKg3ZRxWTsrDPauR5eLpX4l?=
 =?us-ascii?Q?y5taCzD9yA=3D=3D?=
X-Exchange-RoutingPolicyChecked: K3uq9GfYeeCCCiq093UffhXz9cM1jspWvs1VDQCHdFD7xgF5W4g/VLZGHBhEVbl9TKIDynQnHsSGDxpQS0fXkFENRoW3MczkjPBXBH4TCP0nRL8ESVRezijglJSQNXakgyIlxZzyAs/55s3PddwIjSZsgPcoXqna/QRjgpiGXAnFhs2h9uMZBruUYRC5zAa20afgE93+xmLlT3z9Lort9mxZ4pq8LguGTWsYRIHIM6tVWRnDdej3jRyPyUnS5kYUQqPvDTDcEK6Zt3FSdwPc58o6SPpDXlDbSK91FBr5ttW9vLxnD7UP1vVh4UOB6hVqP9B4AVrYhdP2c6KPceTLoA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d98a7e7-84df-4aac-cde1-08df1d879b46
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 17:40:37.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+K0svVWVxtiHeD7K1yEfQkC5HuEzvF8wXR08wXZF9MQlkalOjNhscqJv8ZYIHXEyHITiMJMgWvsn59zDL+d8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5305
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Sep 25, 2026 at 05:11:21PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/26 3:14 PM, Luck, Tony wrote:
> > On Thu, Sep 24, 2026 at 08:22:47AM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 9/16/26 4:13 PM, Tony Luck wrote:
> >>> All the information to determine whether a system is alloc, or mon,
> >>> capable is available to the file system. Architecture helpers are not
> >>
> >> nit: "is alloc, or mon, capable" -> "is capable of allocation or monitoring"?
> >>
> >>> needed.
> >>>
> >>> Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
> >>> replace all architecture versions.
> >>>
> >>> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> >>> Signed-off-by: Tony Luck <tony.luck@intel.com>
> >>> ---
> >>
> >> Please note that the pending RISC-V enabling [1] is not compatible with this
> >> change but there is a change planned that will let resctrl_alloc_capable()
> >> introduced here work on RISC-V also. We need to coordinate these two
> >> series.
> > 
> > The first few patches in this series have relatively simple cleanups
> > suggested. Perhaps when I post v13 you could focus on getting these to
> > the finish line and have Boris consider them for inclusion.
> 
> I was hoping that me rewriting so many changelogs entirely for you would
> already make it clear that I am already trying to get this over the finish
> line. 

I very much appreciate the help. Getting the whole series over the
finish line would be wonderful. But if that isn't possible, at least
getting these first few patches merged would help the Risc-V folks.

> 
> Alas, me writing the changelogs for you seems to be the wrong strategy because,
> as the new changelog below shows, the points I keep making about changelogs
> appear to end up in /dev/null.
> 
> > That would get this change into TIP x86/cache and let the RISC-V
> > folks move forward.
> > 
> > Note there will be one new patch in the initial sequence. The bug
> > fix for is_closid_match() that you suggested I separate out from
> > patch 9.
> > 
> > Draft version of new patch below.
> > 
> >>
> >> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> >>
> >> Reinette
> >>
> >> [1] https://lore.kernel.org/lkml/20260917-dfustini-atl-sc-cbqri-dt-v8-2-7964e8d73fe8@kernel.org/
> > 
> > -Tony
> > 
> > commit 986bf1a4e789de917e955fe549bdd71e51dc2e48
> > Author: Tony Luck <tony.luck@intel.com>
> > Date:   Thu Sep 24 12:40:41 2026 -0700
> > 
> >     fs/resctrl: Ensure default group reports tasks on monitor-only systems
> >     
> >     Sashiko reported[1]:
> 
> The custom for this is to use tags. For this patch it would be:	
> 	Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
> 	Reported-by: Sashiko <sashiko-bot@kernel.org>

Ok. Will update to use this new custom.

> >     
> >       This is a pre-existing issue, but the resctrl_alloc_capable() check in
> >       is_closid_match() actively breaks the default group on systems that only
> >       support monitoring capabilities.
> >       When a user reads the root /sys/fs/resctrl/tasks file on a system with
> >       monitoring capabilities but no allocation capabilities, the following call
> >       chain occurs:
> >       rdtgroup_tasks_show()
> >         show_rdt_tasks()
> >           is_closid_match()
> >       Since resctrl_alloc_capable() evaluates to false on such systems,
> >       is_closid_match() unconditionally returns false for all tasks. Furthermore,
> >       because the default group has type RDTCTRL_GROUP, is_rmid_match() will also
> >       return false.
> >       This causes the root tasks file to appear completely empty, hiding all tasks
> >       on the system that have not been explicitly moved to a monitoring group.
> 
> Please separate paragraphs with empty lines. It is easier to read.

I had just pasted in the relevant part of the Sashiko comment. But I
will update formatting to add paragraph breaks.

> >     
> >     Remove the resctrl_alloc_capable() check from is_closid_match().
> 
> This is obvious from the patch. <sigh>. Please do not just verbatim describe the code
> in the changelog.  
> 
> Could you instead describe why this check is removed? I understand that the bug
> description already mentions that it "actively breaks the default group" but it
> highlights that this only happens on systems that only support monitoring capabilities.
> 
> Could the description of the fix describe *why* removing it is sufficient
> to address the reported issue without breaking anything else?

I'll rewrite to explain why removal is safe.

> >     
> >     Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
> >     Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> I do not recall suggesting this fix.

You suggested splitting it out from the is_rmid_match() optimization and
moving it as a fix to the front of the series. But I guess that's not
the same as suggesting the actual change. I will remove this tag.

> >     Signed-off-by: Tony Luck <tony.luck@intel.com>
> >     Link: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9 # [1]
> >     ---
> >     v13:
> >             New patch (split from patch 9)
> > 
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index 5dcbb0a964e8..6733ed174f51 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -685,7 +685,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
> >  
> >  static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
> >  {
> > -	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
> > +	return (r->type == RDTCTRL_GROUP &&
> >  		resctrl_arch_match_closid(t, r->closid));
> >  }
> >  
> 
> Reinette

-Tony
