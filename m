Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CF83921D8
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 23:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789429776; cv=fail; b=uL1leANW6cxQPcKedYhFD3VMqL+Bj4VtR7RgGWSAfUb4qf0gJzHwbZH32fBb0uReAm5LVxDm+yqNA5XRAS87WaiPmfgXj3Zk0SlegRb3B6r2bZBAtRsZW1V8YXHRgAoje+qOYVKZbuKtFxSHLsh94QbDNHpGGpX5H+B+xq0HXuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789429776; c=relaxed/simple;
	bh=iDT6GYsAxguWQZlMAfg8cqYxjsxAeMkA2G3qiQCecr4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q5gC1tnt9nURjRt4tIiBV/ezwSx8vrLgQNyDnfP5o0RQPndupbHijkFxYPY8UTcN8Ie33LlUVn65Ip53Ibon+jX6j5mIcSVSPFrzVBbsgm6e/Odg1H4pZryBE7iofoWhbppOY7yxqugDDTbHWDC9lcw3zxyWynDoxz1YLNcrA2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f2rjegM/; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f2rjegM/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789429775; x=1820965775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iDT6GYsAxguWQZlMAfg8cqYxjsxAeMkA2G3qiQCecr4=;
  b=f2rjegM/0jxUvktko1agw8KjkVO37VFGp90it1dpxErxv3Ei3vVYL7Yr
   wOIxA1golyN7Xder7BQoOIjSxnmYiOtvo8KpkOP+H+GbP5ycapJ2bHy0r
   CpTBZ/s6MvIqulgWrRhWOOLFsfgDgF1yEVXJS8ztahFzNcpNgAh5QrHPq
   jJnKwTUQlavjosjX7oV/sC/EVUWrihn/3NaWMJpT78GYlapmp0omaWGzP
   laT0h1ve676KdOqhUEA7GbryGOnhYgs2NVMNUXi/K6Jjf58kNfY/lyqDm
   Go9i2K+DRewN1TnSufn582jJgZiE1L1Zr8ffbPGqRHe9sEBUD+eI9jBKs
   Q==;
X-CSE-ConnectionGUID: 7LQsVuXnRtmKsaVXpVmA4g==
X-CSE-MsgGUID: r3E6fcjwTjy3q0KoTJYvYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89812407"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89812407"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:49:34 -0700
X-CSE-ConnectionGUID: jXhOQOwoRiyvDsD0f1PPOw==
X-CSE-MsgGUID: 0X4k0axSSVSyq0m/CIx46w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269499985"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 16:49:34 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 16:49:33 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 16:49:33 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 16:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4LDBO8KEBJg6avGvYyrs/mMiKymLNXGZL0b9rzPTpRJZtMmV31Bbu4B4zzjHIdZZyY28ONJnGrmC4QQ39Zj2omyNvEUs42CgJCilqpC2+Z/zYEJK0yhQHOEc9x+OojDuPtnILULRXW1Gxm7Vr/YvCfRIsqPag2XBOKWLuJSUGmxiOs5HpRhbsb5I+cXtZ6GvoZDj0uVCtN3d1i3D6JI5qIHtBSw1JU4SU+FQmKqSHFeo+ya4BkHoo6nk83cyFRuCaerOqSdEYiaU0lIPveZ4ylmvKgXLvvhpije6Wwjm4ZcbKlz1C6lYY0AIveramew8lWJE1SHYly8DSUtNBZW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4i8Fl2NSkm7zm2xu8QsACT/3PJ/Mwa/e69OCw7UBKq0=;
 b=eHft5PDUS2q39gTXGVICDtH2HqREag64JVYFg25oXebCH+M2YU+he1jkLVQuCfsRYJcOAL1ni1rHP2Wh53dUaO9hMHB189E+fVbkzthtVbYp3/J1XuM5AvbHjLqO91g+O52gYCeR6AvzoKKPGmbnzUFEOlKu9GT34rs4m6JQOlh94336A+1f/XWQFViYX8Ito8Y61KMvQYVhmhicOaveeDHRU4DM/9Q4W0DnkzhUgAMuod3R7H6gZviAx+W9Gg+nO2poX337zlZzYgHTbe0jurkaTJpD0+tbBgOcBT3rkvTR1Q7P4vUUz9NRBl+Qi7+Cos3vlWczkxgR0irwQ1BY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH7PR11MB8598.namprd11.prod.outlook.com (2603:10b6:510:2fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 23:49:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 23:49:24 +0000
Message-ID: <e95f8746-4dca-4dc1-88ae-1dfd75fba180@intel.com>
Date: Mon, 14 Sep 2026 16:49:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-15-tony.luck@intel.com>
 <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
 <aqhoMhn4rsl-HWmb@agluck-desk3>
 <99a4db07-d142-483f-9544-969c7ef9f258@intel.com>
 <aqiBZy4vmMc8Zq5Z@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aqiBZy4vmMc8Zq5Z@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:303:8e::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH7PR11MB8598:EE_
X-MS-Office365-Filtering-Correlation-Id: ee050654-d67a-4fa7-d456-08df12bace1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|4143699003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 7LUaPakX0gI2A2BbPnop6CE0u31XhyCeYPDH8HYJ6xFgjlRghntIkc5x7/D6Cjq5Dro+bwpUuW6OxQynyaIsCx5KI+wqwQ5bhWnQ+a6HhpB/AS1ix3clVRDHMR2ERVV1QT6QenvuC+mQXuKl29ytO6JSRUS/Y4bh6qB1D/oB6Mf0qVh6b7GP9eRtYTuKcAR8jIQvZp1wBuwStEI2SRmiEu0q5XijsmL9HMv0Y2Xj8/LTCHqkX4KXKoMShBRGEihvO91+gF5p20hIDiYf1AB05B/SGHkIeWF35BRfo05YJ8AIVWY5lxWZJliGtyxoF2EcHP7wyTp6JAk8ordI9ME5HFuJTxhO03Qj++ck+jl+ib1gdavuErtEQql+qDZ/Q2EXly4H6HHSA3+8wmNF4w79ycSGUyv1AazGgdhg/khaa4kB192XVIYfUoda9Mm1BL07itDDUGyPNdMDxstkqXYXV6VlrTsFCaFSk0J81nPTy2s+9TAc/YniByjwgzefKS4LqGlEBxuHxVGeOmNK8PG11YGSsk0xqR5Trvt6v39naySjffUyPpLl/E7y/2b1IckxspsLve1JMgKByREZDOqsgJhlS4X1oaauEQveTrdjejUXkZhH5qKjb+isPsKucLM83xLhAcU3ja+Fgu2QIwwlaikfsOj4TJ1thzbMPJqowhg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlJJd2ExWGNiTDNxNGRORkI0RWx5S3FUdkhvSHhvNXphMFhSc0lvalJkOGs0?=
 =?utf-8?B?cWJGbEZwT0NyclhDZDJuT20rTDVwODFackd4WGovSjhQU0t5SFp6aEFVbkNJ?=
 =?utf-8?B?S2p3WVN6SU1kd29EeHhPY1kzOEVzNWp6VUZkZVRBeVVWc0JqQlV2SEZRMTA0?=
 =?utf-8?B?K2FLSDVjeHZXZHZaMC9admlIWmhlUDBtcUhUMFpsQndVbTVTL2gxckhUcVFl?=
 =?utf-8?B?YjJVRUlQbHc2TVZJanJaelZSTFo4SnVzMGJYL3lFWnlPWjh4T0ZSSEQ2WW4x?=
 =?utf-8?B?L0JFd0tzZE5LdEw0dElLd2FBTnY0OHFRS25vZjJXbzlYQ2daVFFXNDFIWWlQ?=
 =?utf-8?B?NzlWVUsyVTBJb2ZkRlQ4UFE3OEo3bHBRUEpRemMxMjBKQ3p0RlliZzdLcnBu?=
 =?utf-8?B?cTh4NWhFZDZOZkFpNDNIQmxveWpEaTF3em1ZT0xTQU05UGRPUmpDWjd3MmM5?=
 =?utf-8?B?bVJmcFdmTUh4eGUwdXhiSEJmZ0p2QUhMZjFsTi84NDRMdzhxYXhMRnhXdmMw?=
 =?utf-8?B?US94VWx5a3pvN1RzdmoyOW5tTUdWWXgyK01DZjRMTHRCSzdyaVJEZWViWVJD?=
 =?utf-8?B?UVAzck85eUFqWmw1Yy9zaWNZNTh4aEd6Y0gxWUZCRzhBS2VmM3orOXVKZlB4?=
 =?utf-8?B?TWY4b0V3a0cyZy8xR3lXeGlYbDlhQ3Fobjh2S3kvZzJ6ekdnYlIvZnBqdWVQ?=
 =?utf-8?B?KysvQ3B3TmdoeTd2OWN2cG9OdzlrbWovYVVYUHcrdUkyR3VFYVJKWGNOa0I3?=
 =?utf-8?B?ekw1RlAzdUFCUEhEZ0RJREhEczdvRzFuVEZCRkdBSithc2tXQ0NCc3JYWUY1?=
 =?utf-8?B?SHdVb1ltMWpHL2JvYjJDZDkybnZISXRLVlRxRERhZnpOMU1scThYRitKdjVF?=
 =?utf-8?B?NEZKbzYyaStGR09id0tQQ0xJNzJnUm9HZjBodnlSQStZVWk2UnBYa0tzRWhY?=
 =?utf-8?B?YjhUZlNMM0MwVmR0aEhDSDRodHIrRytaYVVsK0tNWnRPMng1MWowMzRYSGRu?=
 =?utf-8?B?T3VteEcyMk1ic1QzZGNxYXRteFZvcmxCSEt6RUMzM0JXSHdWYjJTdFhYSi9X?=
 =?utf-8?B?S0RBbjNOVFRGRU5ZdUc0enVCNXZkMHRxVHFEcFY2TWtvM1NYR2FTdytTcXFr?=
 =?utf-8?B?MmI2SVlVUUVnRzZ0Z3FvTWl0UnBPUnVCdE10Y1dQNUhFdUp4WWQyMnNXcXd2?=
 =?utf-8?B?VlF4SjFtQ3VPTHpYTXVwclF1WUNhWllhRkpUM0tJTE5jWHBuSjVwMEhyMTE1?=
 =?utf-8?B?c0k5YXNKUkN3ZFlzUURXeVNWcnhYMkRXYjkrTDNmUksvOEJITndtN08xdXhH?=
 =?utf-8?B?dGNvMEtKcG1GbUg4NWJJUDIzNFBxbEhSQS85NjFQSDFuZEtEd2o3MXROSjRH?=
 =?utf-8?B?eVRUQ005QXByQWx6bmZXVnBCakpiT2VxWlYzcW5RMGIwVGY4RzNTNlRhSzR0?=
 =?utf-8?B?OHhNSDVUZWNHMXdHUXIyQzFNd21GMXlIQVdCWFlOL3U5cnRUcGNQL1VrTmxy?=
 =?utf-8?B?MFJCWDErWE94WEt5YkJpL1lxVnpNaXFLOEJUbi9Iejc3MUdPN1p3ckRRYWFG?=
 =?utf-8?B?bUQrdVZMRjlLYlNmVHM5UFp5ZUF1ZXd3OTR0RzMwQ1d3eWE5azQ5a3l2THIr?=
 =?utf-8?B?a1NSNFlSTU9PdUlVOHc0NWNJNFZxL2swK0MyaC90azYybmxaYmtyZGMwMEhP?=
 =?utf-8?B?RU8zUmU5SWlPcmF3US9LUnNxWUUwa0lhb2tkd0ZCTTcrMTA5TjJkdHJZV0tB?=
 =?utf-8?B?T3ppa2QwVldxUEV4UVZzSVBvdzdRei9WWnJzYTc1aDZ5SitTSmZhKzZERTJP?=
 =?utf-8?B?ak9EMWF2MS90RmFZcHlBRzZ3b1krRDFpZTUydWRUZUplQ21SbzArZ2hBSk5D?=
 =?utf-8?B?NzFaMENrNzA1dFhjTUJWZ0dSR1NWckd5ZXJLTE9uTXVGN0FwRHVwekZOazlG?=
 =?utf-8?B?UlhzU2kzTDY1NW1ia2ErZ3dlM1ZsSTVBMGJ6dDFJWHJ1Y2Y1eFNheWFGREpC?=
 =?utf-8?B?ekxaZm1pQU14eWRxRXJ2ZnQvNHN6OFZ6emhRN05ZT0lSV1Vvd21VMXhDbXNh?=
 =?utf-8?B?Y05ySEkramlselJaRXcyZmlaZGVHNmcxYmNTOXhwZHU0blEzWW5MRlNpcFls?=
 =?utf-8?B?bkZDVUZWTXFCUTZUWTNoeXEvTW5Pb0NwcmRtZlRPT1c5UHZZTWhGYWFWbjRW?=
 =?utf-8?B?TmdvUmhQclNhY3FRZDRLcll1S1NuMG5nVi9DUWlFUTh2QUxraStzNmtyaFZa?=
 =?utf-8?B?TGJ1R01xZWtlNTlaVXpPTnlsTmx0b1FUSmQ1aktMOC9kMmZLRWNwY2RtVVF0?=
 =?utf-8?B?RzdIU2hNdElPb1pFRnh2T05Zb3lpWEIrWUM3WmZ5cldJQnE4OEJSNU52cmQz?=
 =?utf-8?Q?wZM0lITlNK5+W0gU=3D?=
X-Exchange-RoutingPolicyChecked: BnWTY2+2GTeOaiO3OwOkHaq9Y/L2JLV6DywBMqW0Qf0RDyJ4fXkWEIarFyKD5t7Um+gyRRWlJ27C9UhdYFVE30J4zyRRn2lZK79nbeFPWcsj4SnMZbwvVt3AlDAGxAG496BdeJVvg3MqtEasPNLmZmqFvsAx/aWAlMFfjsi86YOm12s7Fp3i4Ny2LEgiSd4rDMsHqDCOFGTjbUTmam4dgVY6VZlQFUOC6WXAj9u2oqKAt8Nw1nLEDhugODikrIXGAd7O2Qp+n57XLEa8mCDFwQX65h3b8C6mydxUq++NkpsDcInHoe+PAfM0/JacMkL55eIPvfPr5w4tIPJ6ENOA4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: ee050654-d67a-4fa7-d456-08df12bace1c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 23:49:24.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tn/YX/exFGkxadVnWSLRWy6EENaZyF7jxpfJytG0t3tRDkQ9e4ybRmyEwDEa597JhRnoPC4pafXazlFgLhEuwYXKM6HfxOnm7i/KEx9ckho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8598
X-OriginatorOrg: intel.com

Hi Tony,

On 9/14/26 4:21 PM, Luck, Tony wrote:
> On Mon, Sep 14, 2026 at 03:03:45PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/14/26 2:33 PM, Luck, Tony wrote:
>>> On Wed, Sep 09, 2026 at 09:05:28PM -0700, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>
>>>> On 8/31/26 10:44 AM, Tony Luck wrote:
>>>>> AET (Application Energy Telemetry) event groups each support a specific
>>>>> number of RMIDs. But that number may be lower than the number supported
>>>>> by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
>>>>> enabled as that reduces the number of supported RMIDs.
>>>>>
>>>>> Reduce all event_group::num_rmid to system maximum.
> 
> Perhaps I need to be clear on what "system maximum" means here. See below.
> 
>>>>
>>>> Why is this needed? Doesn't resctrl_arch_system_num_rmid_idx() ensure the
>>>> minimum is taken across all resources? I do not see why a resource needs to
>>>> artificially reduce the number of RMIDs it supports.
>>>
>>> rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl.mon.num_rmid is used
>>> to display the value in /sys/fs/resctrl/info/PERF_PKG_MON/num_rmids.
>>>
>>> It would cause confusion if a number > (CPUID(0xF,0x0).EBX + 1) appeared
>>> there.
>>
>> That is fair, but on top of this this patch additionally reduces the number
>> of RMIDs of RDT_RESOURCE_PERF_PKG based on the number of RMID that RDT_RESOURCE_L3
>> supports.
>>
>> Documentation has already been updated to contain:
>> 	The upper bound for how many "CTRL_MON" + "MON" can be created
>> 	is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
> 
> So if L3_MON does not exist (because L3 monitoring has been disabled) then
> the user will expect to be able to create info/PERF_PKG_MON/num_rmids MON
> directories. So that number must not be more than what can legally be
> written to IA32_PQR_ASSOC.RMID.

ack, and info/PERF_PKG_MON/num_rmids is the same whether L3_MON exists or not?

> 
>>
>> I do not see a reason for PERF_PKG_MON to pretend to support the same
>> number of RMIDs as L3. This unnecessarily hides information from user space.
> 
> To clarify, I am not proposing on limiting PERF_PKG_MON to whatever
> limit L3 has. I'm proposing limiting it to (CPUID(0xF,0x0).EBX + 1).
> That's the "system maximum" in this context.

ah, ok, sounds good. I was considering the resctrl_arch_system_max_rmid_idx()
as called in this patch that incorporates the L3 limit.

> The L3 limit could be lower than that, or may have been reduced if Sub-NUMA
> Cluster is enabled. I don't want to use that value.

ok sounds good.

Could this restriction perhaps be contained during AET enumeration where
event_group::num_rmid is initialized (currently enable_events())?

Reinette


