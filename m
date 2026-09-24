Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401354A4839
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263765; cv=fail; b=tMEZ9wl5aF7Gi9rQ1lUpoWgV0nVomijjt+V5rXFgFLeD71j2jiz5+0cvgmuX9eSlpLJYNk0I7uQYvwIGdIYB+djBQpq/Sm00ffeg+Kl3TXFZVNpA8ryW4exvzNYANo/lok8xTiDKXPJYuivOGnFihM4bbKiwvUkCyq6t/O+UGq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263765; c=relaxed/simple;
	bh=SIwXq3yae+VPdT4eheA9TxJur+jRyZryuByC4mtU8fo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pEekiSQeaJYjtUBWuW5Xfw512Y/LVqGj5pVs70hHeb84icR/EFFLPMn8AAzQooC75b5enJm/VmezLyphrBcImt16uGL8f22lcMwhm/t+G/RkrOUqJojkHYu5YsFVbrbkMYVWSX4tLeh+V4fWn5/1vC214/+2Gs9FJl+eRaiCMTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hpuZXpdK; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpuZXpdK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263763; x=1821799763;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SIwXq3yae+VPdT4eheA9TxJur+jRyZryuByC4mtU8fo=;
  b=hpuZXpdKaE+YpiVKSBBadkeZEFOgkoxQwX9OsAJsIyhjkcS+18hpxc38
   +FczENhK5GtQZPIV+l8NsxuHVlJeEO0EnHfjB59DxwrT8OtwwYGUL/kiH
   Yo5aQkiiKpzENullt177mqPgAkT25m8kMqq8fSzusOXmR55/HbV8Yc3YQ
   dQ5zYRsIASZ0CuNexkK1kNgfWN7M0DVeqZ3lQfDdYu3lD0DnfNtMGGhW6
   rLo2ncWGcxxurH6CKTP/kkvG5yH9uYZOJW8LsuLiwzZur7+UEAHSsqye2
   qTiNUsXncaPeosdfVn9PT3umU0puE3Tf/AN/Qd2jXyrK1ZiyHtD6SKjaK
   w==;
X-CSE-ConnectionGUID: W/p+0cxBQKGj6v90UnHbyQ==
X-CSE-MsgGUID: 2rVoZF7aRnOCvx8l6YWcUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101618902"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="101618902"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:29:22 -0700
X-CSE-ConnectionGUID: VD2H8uwES1aQvk51aF8GQg==
X-CSE-MsgGUID: ZBpvg1O+RMCEpe3QqD/2+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="282140822"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:29:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:29:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:29:21 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.6) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:29:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVZEM3F2i/ssbuyDakzlyGVv7fCLO1LNr81CDiePTPtXsV7RhsRnYGi49ZLCKFMgJckE4HtTP5/VMpw6JTMJqJU/0cK11trHygfmOLefBseAw2SRG1rhDsloniwPo2l6KLLyoD0/rwQLFdnBw9e1FLGq+O7pA/XJvCaBciLoBhGUyoZfgdqWSbYKP55M/E7XoAkg9EmTEs6s8C2fkv6z3pCJfXierXwvgZflRFtj0dCPTsozVOofgf8p5Qz5T1zhxZhpFkbbOEFnViCqHEnVF8d75sKapVV4lyaD1fiIYtZE507gq0+4PM1yxXHVY2pSxsYVZyMTQuJhsnLw3tCp4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPz2HnrdiWy1QGFGgfe4Qp+zOGMiuUj3PAuETya3bFo=;
 b=sHneEI5vtqtCG8onSztGMclaDi1HKqOcceENOZoe/ymykpBuRIY6aBMLxtoi8aK+2aJJCOhVlvehftynzVSp2MbXJ/s0wvwlACHcWvFXVWPa+FKzYTRRF6QIYIvFvnfLEkQwQwmca0I0dpzXIvni36MJXjeTkNmxzoSECGXXuBU7yVWwfdWUr4wmZ39M1aKyxZ7xJ48IDuBiGJDP0QH2SQ0yycS/De1rfF4MYJCWy0/oVXeBYKNPeSayGbpgdpSO+6A0a2vT+20G/w7xhl/tHz6P2yQQYrtvR4MOYmQ3NSSsa8W+OUCIURIoJMXQg7L8f8D0JXVt805siWaN54BRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB6018.namprd11.prod.outlook.com (2603:10b6:8:5e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:29:16 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:29:15 +0000
Message-ID: <cd9c0d58-ac36-4390-80c5-13a6b5bf4fce@intel.com>
Date: Thu, 24 Sep 2026 08:29:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/25] x86/resctrl: Honor rdt=perf option to force
 enable AET perf events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:303:b7::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB6018:EE_
X-MS-Office365-Filtering-Correlation-Id: 6feaa4fb-8523-455e-14c4-08df1a5097a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|11063799006|56012099006|3023799007|4143699003|22082099003|18002099003|10067099003|921020|6133799003;
X-Microsoft-Antispam-Message-Info: 1AP4sm0GtAQrsDTjoZeUHO7OPL+4ji8dgrUwDTCYMgthlAcvQ6LQ2HV8XuFqYhk3I7DxL9HaGKshumdE/odQO16rLapJ0OtrKMzOYDCz9aNNihm9BJujbf2+qDOKgTSatW0ah2/1hKES2n9uCNH+M+QyoNyI7Nyt5Ustd3zShHXIFpN/+kD9eEruPXLN3PPI70Ds7Hi0KEhzrjqNwoJizJszegHP5QRBjaA1Qx6a77Py5jxwT5ZSyu2BDSkkpp5hd8ttCrXP1zFJHAu8EkplYygCmzkB0jHK1rkpyv0otUL+iZGpY2hpIwV0eGLYG2UQPA+ytgjLnU4+wdG/zmLZDfNkkedv7UPw13SnCn0xq6lLTQtQLpH16QSWjn5Su9Z0240RROS7gdn8EoDGQYZRKa0T+8u/dHlYf/jSMXUTvl0BhQvfu3ZRVAn6cVNmg6GI8VbttYAXS1A6+YWBnYvMBinHpk37arS0c1YKEEffFFT7xBadQZaSYz5aS/fVl3sxIbpiKQMRd7pm62/6qAMFXhkpv0fIFvn8oR4FIBM63xbjmNZDelXylRyCatdwTYQ9LISwv3tvc1Lrcux3L82PUSI2DSrC9TMK9lDegd/lUcgAdkvx6jAXqDnw6Df/Kh+hsFKm9HIFRpqbgu8jGQ2XOSQ2gu3bVL3BfYtYp6+SYQWGDX/m4OnmNJW19aZidtB45EaU4DedQUfCaJadyYJnJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(11063799006)(56012099006)(3023799007)(4143699003)(22082099003)(18002099003)(10067099003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU9HZVREbmczWTRnSFZ3blBkbWFXMXduSXpHMWF2TnNtU1pQaGlMS2xKckc1?=
 =?utf-8?B?LzVydFh3Y2hPdDNTeGh6VjdLK1VhUzFGYktyUG5sOHhBb2FiT29vWWFXcmxp?=
 =?utf-8?B?RFNIYW1sbDdmUEI4dDlxNkxNZER1eUU1SUFpRm1DNm1GdC9VcWluR01DclJJ?=
 =?utf-8?B?Zm1sYWdNMWpMTmFEREF0WUZRSGdheEwxdi85T2pUVDBUTlFGdTl4b3NieHZB?=
 =?utf-8?B?YVBKRk5hSWcxZVE1cFlGVHdJK3kvWWU2RDBkdFcxVE1VNCt5amcrUjVCY3M1?=
 =?utf-8?B?dGxiYkU5TWgxajJZS0hLak5vYWYvK1JieEVHNHVqTFdzMVFXY1VtbUpyN1Vl?=
 =?utf-8?B?c2FHOUJmcG9IUkZGODRCc2FmOUtRbjdvSVdkNmNQbGpDQ1VKOVZkejAxbXZP?=
 =?utf-8?B?dzhDYjFrTXV1TkR0YW5zUGJNcS95T1Y3OFczaGxyMWIwaVRIVC9hSmpWTnZu?=
 =?utf-8?B?UnV6bXNycFFpcjNCUHorYUdTZC9TeG9uNmVScTNTaXkyYlBEMWlNYVBsWWxk?=
 =?utf-8?B?bUhEOEl4MWowWi9EaU1Xamh1Szc3dnNWOGVIR1Y0eXBZRlZEL2tpcTNiQk41?=
 =?utf-8?B?ZmRRNXdkNGFua0QzSmlXMWdlWE5QMU5SRlhIcUdTOUhFSThnQW9mbkplSUhW?=
 =?utf-8?B?MDR4aG1oS2ttY1FnNk1LamxFM2thS0lzQkhlSk1CbHB3ZkRSSUJ5eVpMNDJM?=
 =?utf-8?B?c0xWRndBTDZUZHk3dDhoL2VnVVhvNTdBQXdLVFoxQnM5a2lqRGV6N09vdWlN?=
 =?utf-8?B?Nmp1ZFFmLys3aHRPa3h1Z0V5WjNFMStjOTZXSWJtREFWNFBneXR1TnVnT291?=
 =?utf-8?B?NzFsUVhvbFNYNE1kTnBmMExsVWRGMTlGRGJkdVFqamFrd0E5RFhwVUNzL2pC?=
 =?utf-8?B?NTcxUVZLVmxnKzZzekFpL0dCWWJad3lPODY3cS9NMGZibDVsb2RqMVNGbmQ1?=
 =?utf-8?B?T2hNMzJqMC9NRDh2OEJ5aUVBbndwT29qdGoxWVVncEJoOUhIWWVJeGhncXFO?=
 =?utf-8?B?WnNRdy9aOTl1Q0VqY1dVK3JlWnFNek5raDREUnB3OWxuWkRuekRhN0NaQnBP?=
 =?utf-8?B?T3BiM1FiLzg0WEVGbHQvbUpHKzRKRXZIc3RjR2JaUnBsTDdCNHlVemFxSkR2?=
 =?utf-8?B?YTBBZVBMTzkweDB0TFNmcG93VE5hcjBycUI3cXhsSmtxaVI3Tkg1QXVnMUQ5?=
 =?utf-8?B?NE9MdkExS1AxNUxKanNZdmZmakxwc3VTZjgvSnlUY2F1VThCVDNwZUp3d1dk?=
 =?utf-8?B?OEtXd1h4c1Q2TXhPeHFuejZ5Q1M2M0xycGg5V1NWKzVheld2bG1yQldXQ0Yw?=
 =?utf-8?B?K0sxdDN5MlgwSVAvT0RtK3NDU3FyQ0pkeWc3TXEvTHUrNWpsajgvZmFuSHVF?=
 =?utf-8?B?cTV3SU80T2Q1RlQyYXFvQnloUCtCRlVCQnBLcWcvRzBOOHBqTUZaNHNaVUZ6?=
 =?utf-8?B?RysyYnFLSDJ0LzhiakZkTGM3SW1OOVpkQ3RpeThYWW9RQU9iWDdIc1lxYXEv?=
 =?utf-8?B?RFZTaWxoWEhZN2NiRXdYVERsY05lQlZDK1d3cnAxdk9sVG5wUXlZUFBlUFhZ?=
 =?utf-8?B?SnVNRjlPOXAyekQ2Z1F2bXFBdnZERkxpTUJpN0J1dGxZQ2dva0ZGUHFCNDZy?=
 =?utf-8?B?b2VxR1d0MytnclEvZzNBQXJLSHNEK3RxWUJwcTladHBEa3BTZktaYW9kaTJD?=
 =?utf-8?B?NVN4a0FaMnAySlJZcGF5RENORkhDZFVId295OWxCbll1L1F0ZGU3ay9sS3My?=
 =?utf-8?B?ZGtUSnBGSDk5SWZIVWppbUxOYitCd2YyWHNSbmdGT3dRU054ODJqR0pnTkp6?=
 =?utf-8?B?ekowcDlHVEFIRUU0ZkZiN1RxVzM1Sk9ORzVVWDNiT2xkRmNSNXp5ZUQ3Y1Fj?=
 =?utf-8?B?WWRSVXA1VnlUdW5yanBwZW5lelFpaWgwMWViRWt0UkhBTVpDb0hLY0VONVdJ?=
 =?utf-8?B?YTltYm5uOWlJZkJKV3p5dFhRTS9hRVNRTWZjZks4UnB1VjZaUVNLeUo3Q0Uz?=
 =?utf-8?B?QnVHeHZYM09SNTJKa05TSHpwZlN6bU0yOXlyaDU1WlBtWW5ZU2I4QkxDOFdX?=
 =?utf-8?B?S3pPQ3NYNkxXVm5Oc3poRGxzenArbDZ1ejJGeW1aYlJtRkU1ZUc4YzFwYUls?=
 =?utf-8?B?U0ppV1hNQkdUUHNxKzBCM2dpY0pZMmd4M24vQmlyQysyQnR1Zmd3bHFCSG9M?=
 =?utf-8?B?QUd5RVo0ak4vYWdVWTB4N3MzYVpHNTVxRm9IeHNJZk0zQkZKNVYwQlQvRmNJ?=
 =?utf-8?B?VFd2aDZBdUM4Z0pvZ3RoUW94c0c5UUtZV3JkTmxkeVcyQzdlb1pHOGZxS0tN?=
 =?utf-8?B?SnM4cHNPVnFtaXYvRVlneUFNYXV1eTA1T1hkSUZyYWdOUnlvV0hLRHV5YWJQ?=
 =?utf-8?Q?zGSp5FXr9ahxJaBE=3D?=
X-Exchange-RoutingPolicyChecked: xUf3pQleDA0RxKe9HvI6zvQgiT6FrOKsPCz/xGMNX+/fFwt9s6YYTpAP7Basad2NMpACJQX5ZesbsIdg6y71qrabNGio3dZnqnNBeU0BhW0g3cDIwxOWb09wFTranyNgQopAxMOfQCrgwrBCBtTISIPsm1cO/ZFvozqRrYr2xKCohH8DYXkUF7aBavQBUzYAIVp9kGRELWsxoOYDcDbjA0aXYPrUOZSZ2o0SYnirnSta3QiAZtU29cvJerv9MSA0VbT5qNpv3IRW+Lk3XZNS0xonaaIBffvaoPYzfX8VBYPyw+63MitE0fJp8L9ixxo9maV9wf95Ovh9NVvtXyyZGg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6feaa4fb-8523-455e-14c4-08df1a5097a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:29:15.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qDZKQ+x2ptQ2wXxxWFXSchFiH5Sg4I3ReqS/iJergHpFfdPFcshsr+gqRUcfH35h761Jo8tp+g6ImMW+9ANFXXtnc5E7dNfbeiEqGSXieg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6018
X-OriginatorOrg: intel.com

Hi Tony,

The subject is specific to "rdt=perf" and "AET perf events" but seems to apply
to energy also?

On 9/16/26 4:13 PM, Tony Luck wrote:
> resctrl can disable ("force_off") a feature supported by the platform if,
> for example, there is an erratum related to the feature or, in the case of AET
> (Application Energy Telemetry), when the event group has insufficient RMIDs. The
> "rdt=" kernel command line option lets the user override ("force_on") when
> a feature is disabled in such case. Users may also disable ("force_off")
> individual supported resctrl features they do not need.
> 
> Linux enumerates AET once on first mount and skips this enumeration if
> the associated event group is supported but disabled. Since AET is only
> enumerated once, this check is guaranteed to only consider disabling via
> the rdt= kernel parameter.
> 
> However, when transitioning to enumerate AET on every mount, it is no longer
> correct to skip enumeration simply because an event group is marked as
> disabled. It is then possible for resctrl to have force-disabled the event
> group during an earlier enumeration due to insufficient RMIDs, which would
> improperly cause the kernel to ignore a user's explicit rdt= override on
> subsequent mounts.
> 
> Ensure the user's command line choices take precedence over system-level limits.
> 
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	No change
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c22c3cf5167d..4ad6ad78e93e 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -228,7 +228,7 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int skipped_events = 0;
>  
> -	if (e->force_off)
> +	if (e->force_off && !e->force_on)
>  		return false;
>  
>  	if (!group_has_usable_regions(e, p))

Reinette
