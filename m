Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C73DB30F
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 20:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109082; cv=fail; b=NeBJytoSlGl+4jmocZYSE3FOCezQY/C092exEsFSL5H8b1iqslwnjJn4m10YSK6HoKJzokVdyRfQKXHLDzUiiBSSa5d4mm2euXxU+W0efwPeAzicaEDPLaTRKCdK3ZZyeJ+vv+RTSiDGwscxdeeHIQJXuQmSVxoJGNmPmuCaDdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109082; c=relaxed/simple;
	bh=fsWRU/2kkbXL3HyXyacqYwrunSvKRaWp5xAt1ay/Yvo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cbRgcfOd2v8R1ciyicF5PWr0FfJLhyBg/zyXwwrorObFiATITwRcQB0BqPErrdtwg96waZLIgHe3A2F0mYerH/7l09AoDxYv0mjj+18BT44ZGgxfNnStrgXJPVmUdFSSJh4322iIDDVJRJVLVxgvWa3uwTSz3duJnB9d2sWoxmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JhY2bqVg; arc=fail smtp.client-ip=192.198.163.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JhY2bqVg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790109073; x=1821645073;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fsWRU/2kkbXL3HyXyacqYwrunSvKRaWp5xAt1ay/Yvo=;
  b=JhY2bqVg0WEJvyNCus87cKr9sZ9vJFg3dxZjfSic1CfnUmOTfCPLeZ2h
   swqQzSJhZFsLoAAXtSDw82PW5Oi0hsRo7wHpqx5zR2RAcELBN7BX3go31
   lod1TeRN3L8Z5z5alajm0lo/AsmENFL+NKdlx0Thc5YtoDz067ZIUlpx/
   FKJ4hgQVcLrH5F+yXj33cCeeyF88NHT/C6a3+WyMy3lXGq2Urt/t0t10i
   7PlvnblGh4fHVt2zhhadzphKtBVY+Q0ESgqSdWD4sjSdI7xqkEGePl2FZ
   U+j3Sd6L3D0okLJfpygtwqVS5N+bDGmx1x6C6Ay9nZcTdeikiise7nuuV
   Q==;
X-CSE-ConnectionGUID: aJQ7828lRgKtWgqUqZoR3g==
X-CSE-MsgGUID: tJ73s55YREaOC9qV7F6aXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="1255424"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="1255424"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:31:10 -0700
X-CSE-ConnectionGUID: vNk703K1S2m+id0d8CKrWQ==
X-CSE-MsgGUID: BwlgIOnZTG69Bc5pD7DBOA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 13:31:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:31:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 13:31:09 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.42) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 13:31:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oLGJlwxQdJbQ3APDXEvkF9cZ8t1nmPuBMWxLFbcs8FY0Mu43pfoSUBjPDj0BQUw1Wpfvnfzmn2R9D0H79yK4irYZ8WHRiNdeHTXkh1KHoHlhmZmdaXAu2W/ojjYAqxc1WG7dmaYh5cAMrW1qwUpvv/54kb7v56OS5NJYCLI0q6RybBs11+LpqrfQgIcX7qFa/xDxr8sS23N2VDUyWAuuwliWugINyd78BATmG4x9lwa3Zw9mNjmnEul/fIRtoBh2goghk6wksMryOU3AT+g7YukM4gmBnQfsoAN8FGsw4JazianInBFUR/x6reDwiYupEhNupQnIuFW+8HGdkyeiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tLTbeNvlr4vdL7aw4p2KmSn7ccQoLGl7Uh95Hdx8X0=;
 b=pHt4vPPpoCrPih/4wRC1io3/ikCutuNAv/eJvZpLJ1UwX/DfHZAt4v+Sj35bg0LN5jBrsMoTNuu7pD4zzGi4L0AF5/Bid9GlGOXd7sIRW/RqbNTNGNq0vPdtNLccLe6XAS2TI0Gqw4EFggkDANp/AuqWmKdW8gZcPa2iJzRMv3CsuxKQCOOwybZ1Uzaur3sv0sIaqrzjraIzAydC0v1dodOfnKFMtvEahIWA6eWltmV9Em3abi6XAhEtpDr06ArrenuxFL2R2VtUtJC9AypD05ADADOootaLdGkrlrmm0pxBPu0VibNoDVWy++c43pFwr4yYydASyai9PRV6DS81XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 20:30:42 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 20:30:42 +0000
Date: Tue, 22 Sep 2026 13:30:40 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E
 Box <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
Message-ID: <arLlcFYZiu7OcBFc@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-15-tony.luck@intel.com>
 <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
X-ClientProxiedBy: SJ0PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b59d2e-e9c7-490e-85ee-08df18e85f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|56012099006|11063799006|22082099003|18002099003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info: HeXAQIXFJMH05Tn2iLoEfgKyzBTuZebweOO5gUpxroweWEOYehdMIRWCye4Jwx93vTJzf8BGR8dyjYUxQ9T9aKMwHy3osAUubikCwzCrtPxA9ICWH4nZa0aHD85j//EONQaP63kf/uXIaP88Spxy8uALzvBhT5Bv8Ozj2io3IbqcI0qvBYGM8MVb7cE8FOQd4toVmU6DV7ZrW6mz0B4dGw+XCo5+jYIQwGNQ6jF89TmKw88WuniLuzqqsMsBbjcyGz1pmu2yZqFktyiklWtx/pPuzhClee26MmHuneOucfaU64ml9krCRn4+qMDEikpLXeGuEZ4wQRThdDsb6gDR3cF25jafYgLohjp3tsk/zswNz3y4JNeaxO6WAliaukxSPw88jVHCGNSZhTjVT+VBvmhVWXzFx3eWHqdsSFdAVINKTZeJUFV2OFT65oFLQhbScINUmmxE1R1yPUIu2PHTtU+l24MrYhVYNrveSsgmU+bwCVth0VO7fkcQ66cl5bDJsWNRbwXPEmnpr5Zh6LnvWXkllNJS/FnDLPpOv5c4NadI9yeh3eC/XZzovHrMxTkYKNcl7HtOO04/RUEiH528RUG476Vnf7G+2xNjHm6peGn4dJMei7hyR04ZBPqQSSFTflZ9ccBJWxo9e7sR2V971Fd/Rt+x9EejbH7rDGHx6AU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3CY7yu0XmE2V7CvV28FQAHNYf/osiE5xyLNJ/+SxdFqWazohnRNe6+3s7U1G?=
 =?us-ascii?Q?r+jWYxUnizRrC/u9VFAwoAmVsPbpFR+lgxlmFejy5A8UPZ2JjHKo7LC40K2h?=
 =?us-ascii?Q?mg+6uqoTniCJaDF413xku5TTlymcPy+yXPiLS4RlM9SxU3HuOlo9X2IJ1yCK?=
 =?us-ascii?Q?z53Kjmyebyew0Lg0mP2x8k2yxD+VgrpdX6kCgeXgjwF5gn3IwPJJVI3gweJI?=
 =?us-ascii?Q?uUWDTxGNl50pcpun+8rjkSNskX7pXtyBlNKbc64DWH0GFQ6HqC3L5hTcLwEp?=
 =?us-ascii?Q?cjRscE9wEEPrhERSGxkADGtVIuTT6J4yVdo/EQXqDKMGSGPTrj1X2dHMCDuB?=
 =?us-ascii?Q?jF4yDYQlKLM+JHdLyZiy8XCoGUioqOPJJ1Ai+ftEHO0141DiqC15cjPOHf3j?=
 =?us-ascii?Q?O9yzkOPKwgifum5U8aAO4JB3ApsNJQ2Kq3pWOpujHWI8PULLyqppKXayB9PX?=
 =?us-ascii?Q?7JrE8R3UGb1CEcJc0uUrV3Y9RHic13xUB+E46LBCbbNsMdlL61sX8xHavcMu?=
 =?us-ascii?Q?QQE1r621YhwTc2soBxG3guZIlTzBj8q9RBwemFBjYCdq9m3qZHxyvWFAvUL7?=
 =?us-ascii?Q?jUGVKH8E3Ys2R+1jA2U/uwjM/ChSdBuA7EMYhNo+KJHGnu/g1TBpv/4l4h7i?=
 =?us-ascii?Q?i44A3cPLODnmooLN0MpW0Z7aTgixR96G7jZChWAn159K1iHEWF7PiJ8bUFUh?=
 =?us-ascii?Q?HAjJiuuaLcibml/tyOMuyTSu5rXxGru2PXjjxGS+fbgIOHt9lRu//HW5lXqJ?=
 =?us-ascii?Q?bAUaOzSwAw4DORACKb/u65Cldu/O0uwrHM7cGpnbDKiBwRavTwMFWa79cZWQ?=
 =?us-ascii?Q?4I/0WDraKoj93W9y4KNhWl3wE/iapShsTrnWxviWePXgbGYgLJs8pqHhVoQ9?=
 =?us-ascii?Q?XSYTkFXUJ8Z7lZ+vypdVe3iyS50NbvuUISPu+biAw249gX8EV3vUSD+NKRLd?=
 =?us-ascii?Q?ElZZwRJE7kHLYhhfHaeL0f5A37t0nHIuO5i9K5piOwIOKpa4qFjmzB3Z8Mbp?=
 =?us-ascii?Q?5I5Rb/LqsUlWn3RKRvO8LOrxpELMwrQy8/tBbUbfRqKyvHY7BWPBC5jHxbom?=
 =?us-ascii?Q?9IcxnHZvEi3IpFAuNMGplEdvFHgmYKt3BbUMkjsPx17qIx7piWRLgiXk8Nel?=
 =?us-ascii?Q?rOenVj+JrSwOhYHlJfFzl/bMts5Tg+aZ66jOR3zjvcVIoqsjstZ9lEwjW080?=
 =?us-ascii?Q?ZetkwUdVp8RZsz6ivpN8ZgcFi1Lnm9YxVblX5WPYaJmABVJ/3D+vfuzbwKbD?=
 =?us-ascii?Q?jG+BqOirnVZm46fB4bnAmsgqJe+LnEg/AGp2ZQCGkrlISNzUabBG03O6J8Wo?=
 =?us-ascii?Q?ZgQi21TkDNdbzlMA/1dcacQ3oJfwfoqmmbsRdd5iCZut/xoysKErz1Sylgt/?=
 =?us-ascii?Q?RZiZNa8kJsxrdpmkoUx84GYBDSrzHyKvWRbC4V2txZcGe6Z1HtaTO+VGbkYJ?=
 =?us-ascii?Q?czl657tVs0oVNa25/CZ/AMw694MqLrinp9lLlengpvA7az8s0fk8VnQ92pZ5?=
 =?us-ascii?Q?hnx8RxHaS9prW6JH1HlPQgx7XWU/yz1wVHIghelgJxf3iEQI1ltWVQW61YhR?=
 =?us-ascii?Q?trMwYPHuen8NVUK7qCyMtFqV0d85+mRkRKfdPCberHEVtGQIOSczyE6AN3Yg?=
 =?us-ascii?Q?PGM345bOG5X8NE1aVLNlNvhv5jliqUvc5bZ5MkRYzJ87eC6PAo/SJISEFR8x?=
 =?us-ascii?Q?lZupelWTpo0j5iVlG/rSqOflUBzTfw37Yre6kBsfYihGtbiWjaCbJS63aDVM?=
 =?us-ascii?Q?lUqaaWwyRw=3D=3D?=
X-Exchange-RoutingPolicyChecked: NPLxFfArxnU5mZK8jvMDMuwDnSdWW26upPKsjCCsJM+BO+9Qzs584eLhO/7mX2W40byihzyLKo2L4dQr8Tj7RKLeVOcNFF7naP7RaDAersbwP53aqyrwkEC8rzS0LfnrDQbAIYreUlTskV1+71SLJixad/EJF8Il8b6K1WHfqlPhmdZUkFEnCG5sujtHQWRNUWkj9HcL2h2crPkF4T1LUmTzCFQADofdnI6ndSP3zyfUH0mEDbT2RKoV1LMo3AkwzOcWtFyS4a6dFxa8C4yW74Apr+3pJiew+jRzpywgmIb+gWNPwTGh5H4sNsIIbY8/scsPIYYTqEUNKx/LDnXE9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b59d2e-e9c7-490e-85ee-08df18e85f5e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 20:30:42.3748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: beyyg8NSDOzTTj/o/Ius7mLcJm2BLIep6Lt3lt05xV3HbqimqKyggC0LG+qLhNULofAJr8ZBqqnBuPA54gJkiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

On Mon, Sep 21, 2026 at 12:45:56PM -0500, Babu Moger wrote:
> Hi Tony,

Hi Babu,

Thanks for running tests to make sure that I didn't break any AMD
functionality, and for reviewing these patches.

> 
> >   int setup_rmid_lru_list(void)
> >   {
> > -	struct rmid_entry *entry = NULL;
> > -	u32 idx_limit;
> > -	u32 idx;
> > +	struct rmid_entry *entry;
> > +	u32 cur_idx_limit;
> > +	u32 rsvd_idx;
> >   	int i;
> >   	if (!resctrl_mon_capable())
> >   		return 0;
> >   	/*
> > -	 * Called on every mount, but the number of RMIDs cannot change
> > -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> > -	 * until resctrl_exit(). Note that the limbo handler continues to
> > -	 * access rmid_ptrs[] after resctrl is unmounted.
> > +	 * Allocate the largest number of RMIDs that this system will ever
> > +	 * need. These cannot be freed until resctrl_exit() because the limbo
> > +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
> >   	 */
> > -	if (rmid_ptrs)
> > -		return 0;
> > +	if (!rmid_ptrs) {
> > +		num_rmid_ptrs = resctrl_arch_system_max_rmid_idx();
> > +		rmid_ptrs = kzalloc_objs(struct rmid_entry, num_rmid_ptrs);
> > +		if (!rmid_ptrs) {
> > +			num_rmid_ptrs = 0;
> > +			return -ENOMEM;
> > +		}
> > -	idx_limit = resctrl_arch_system_max_rmid_idx();
> > -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> > -	if (!rmid_ptrs)
> > -		return -ENOMEM;
> > +		for (i = 0; i < num_rmid_ptrs; i++) {
> > +			entry = &rmid_ptrs[i];
> > +			INIT_LIST_HEAD(&entry->list);
> > -	for (i = 0; i < idx_limit; i++) {
> > -		entry = &rmid_ptrs[i];
> > -		INIT_LIST_HEAD(&entry->list);
> > +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > +		}
> > +	}
> > -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> > -		list_add_tail(&entry->list, &rmid_free_lru);
> > +	/* Find how many RMIDs are available for this mount */
> > +	cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> > +	if (cur_idx_limit > num_rmid_ptrs) {
> > +		pr_warn_once("RMID count %u exceeds allocated %u; capping\n",
> > +			     cur_idx_limit, num_rmid_ptrs);
> > +		cur_idx_limit = num_rmid_ptrs;
> >   	}
> > +	INIT_LIST_HEAD(&rmid_free_lru);
> 
> It is possible the list is not empty at this point with difference in
> numbers from one mount to another?  Should you check if the list is empty
> and clean it up?

After a clean unmount the free list will likely be mostly full as
resctrl_fs_teardown() calls rmdir_all_sub() which is going to free
up RMIDs as directories are removed. The only RMIDs missing will be
the ones in limbo waiting for LLC occupancy counts to decay.

But the free list may contain some RMIDs that are out of range for the
new mount. Simply rebuilding the free list from scratch is one option
to resolve this. Another would be to walk the list add remove any
RMIDs out of range for the new mount.

Except during validation tests mount/unmount/mount cycles are rare.
There doesn't seem to be any reason to take one approach over another.
> 
> Thanks
> Babu

-Tony
