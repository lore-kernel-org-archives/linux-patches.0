Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8DF142E8C
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100449; cv=fail; b=TQPOZMsmQ2WJr8OBa8Afl907aqTEYIiDGVvdo7E8KSq33c3l1HkOPXgwkpPQ4Qq085yPgxRuVTvWoSOUZgGeUH5QV9oE8NwLheswd79/4SFb/0Ej3wm+YmlaZFEz0/Vc8l5rn6ipx4ESTcJbLjejYW+VrgOGriBSybH9Qqqgwaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100449; c=relaxed/simple;
	bh=rRau6v+MHrDJ76thFZNDJzsXDxQR653UeVQMvi1+bB4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IlUzHoJ33J/OOeBfVMgaEb36RR7ZzU8H9BHHMykD2xox+58ZNMtyHWeaWipkAKGtVn8GFORaRgdGP8GRzD4qmZuLuB6kLFEpv2Y1B+V3JZprTWQPtfnWPrW9AIhJsvXAQGfIaNm6KQUC1yPcKF48YyymQtqlzHtf+px4Ovk/Z2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISTFoNcr; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISTFoNcr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100446; x=1748636446;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rRau6v+MHrDJ76thFZNDJzsXDxQR653UeVQMvi1+bB4=;
  b=ISTFoNcrRV8s9KeDuLiLOdKwjKofLxcG43EM95LoCh0hyGYZE+251ByS
   gjZJWIy/jtL2Ysz/1/zLNH2cl+gASoPQIWzOGsharxK0elSTqTkFi8+x+
   lraUMm5VC3afh2vsu2Bg4UGGlYICw7Nz2sZC+Or14VdZD2imEUF/1DxoY
   oYh1BIiUPlnKnEpBwN+dcNzhcoGcFcDohrlOma8hMK8H1U6gkt/bmEIj9
   dJT84hnsTFKJXnzugkSFscujkJrmm0xVATMV7oiip1FUt7vIXe6EMzeUy
   zQ02Sl2EKFkaaCKrs/9xt/26/cvXjrRzKuzXV962FF3mAEbYUKQ4F0U8e
   g==;
X-CSE-ConnectionGUID: ffk1u+yORO6fBtSff4Y6XQ==
X-CSE-MsgGUID: jC6QtQ8GSAC+Wr8TnWmrpA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17450051"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="17450051"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:20:45 -0700
X-CSE-ConnectionGUID: 1UUYKtz7QQKWEnGMxLrBDg==
X-CSE-MsgGUID: GX1rGx0bSWecHltordB+Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="59113018"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:20:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:20:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:20:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:20:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/4KVpuUZOujyfqlvVS0ObpAfkLeqsJFQqMUqt6pRmXBrR0oDuat4918m71BgPoWuxITMACBaO9AcrAolNdvyeuWkDLDVd7Vb9cvM/EKJIZtpZnuWs0sXkh6bceb7jrr6Q3LJRRZHn7vF9bYEf8h8PLihaTKN4gTyfBertP+XZzGUfEABA1v//rVTRNC+9J7jtNlq/Sh6Yka54vUkPZW794YB/dZBLA/gecsS0k/LRb6eu6jX1gfYDGDN8sSPz8BsdpCUz9AZxQ9SJWBSQt9tmr9tpy4/pVO07V+hksLMkGpJhQI9KZ04BQWF+lbxKtB8VnIvzGDgCjzTy1KuU0Ruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+8N9LBXoNnXjM9hh8XTJGjrtexBZGWhdLDabwb8IcY=;
 b=hmZgYqbbMzmv0IqLUVpI+htz52QtUO1j2nup1CwRYfG8PQeTvYb96/s/AheNVD3hGbG7VRTe0hqcLP8QQMUCeuAujbHK7vVOp/6xhXh/rrd6iS+1Cl12wvpUo3a76Ty3OMzW70s2zlA1OnJ4IqB0Utr+ajYrAQBXEGbqkQXMqxheJR+Kb1Z4v+2cs/jEBCaM/rXNTGQH2HCrUJJOszThsv3VaIW1o5Zhgxn9kaUsqCqWVmfo06VZP6TAcF5/q8lQRBQ3EsjLOvJnMqKpSV5OJY5mxYDpqod3BnAozBCKC/Fz4ASkg8gpxZDp9je953S61Vfnuzndkku5Hkveibz3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6453.namprd11.prod.outlook.com (2603:10b6:8:b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 20:20:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:20:42 +0000
Message-ID: <b0e17f5e-210d-4aa3-9410-f1829b570c4b@intel.com>
Date: Thu, 30 May 2024 13:20:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 06/20] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: 646f8ec1-f326-4e0d-e917-08dc80e5fa98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V21kd3dpRDEvbDBjd1pFbVpXOGxveFZscHBwYTl1SjdwdStQSXE0ZGtHMnhV?=
 =?utf-8?B?Q3JqMDJOTzM2NmVlaitSZk9iSndFbDZvMzV6RmxCWU5PZUlDdU5COS82SUJV?=
 =?utf-8?B?dkkxMHAxRmFaRWFWYVU2eDdIRHUvZ2svNEZ6OU1vVXhiV0g3R1R4SWs5bmlo?=
 =?utf-8?B?SVArbDBicVdKS1MyRE55OVQ2SWVMTWczeUZYZXZlVjh1am1FMVhoRnhCRE1D?=
 =?utf-8?B?aWtmdDNzYi9kS1FtZW5QY3dMT3I5RU9wYVhmMDJNMzJKeHlmdno3RFNwaFRK?=
 =?utf-8?B?bFNtZTZqZUJCVXI1L2NhV0NuQXQwQ2cwRHhZZHVqcXUxQ1BwUFMzK1hBaHNJ?=
 =?utf-8?B?NjB5SEUwN3c3UHVwM1VKS2RqRWY2bEdVeGliWHhRZnFQb0tVSWthYmNSa0dw?=
 =?utf-8?B?Sm9aajVscFRkNjR3ZFJyTk9mMnlON1dCeDB4Tk4vU0VLeC9HVG5pV1RjZmFs?=
 =?utf-8?B?SWRrMmg2aGtRd2lHUFA2cWc4SUhkelBZUTlEZ2RKS3IzbmovSWxDWjY4a1dG?=
 =?utf-8?B?UXU4SjdXRE9pRElZRXJIZkZjV3BKaFh4UzVJU0Nwd1V5WnFXVUg4b2lUSUJU?=
 =?utf-8?B?OUJMY2l0TjZNaU1IajVwOEpjYXkrK1lSeWRrS2xtYUxXeXFiby9YVWdEOVZ1?=
 =?utf-8?B?RXVzTkNTSUxpa2hzempzVlNBN08wWkp2cmxxLzFXQ0VDN3pORkd4WTdIc3py?=
 =?utf-8?B?WE43WFFPUDhwTWtRN3U5ZUFpUVg1b082ZjVsQzkzQTV0NTlrK084TWJsTTZ2?=
 =?utf-8?B?OHRKYWhaeGNPRmVCaGYxdUl4Qmg5VGFmSW1oMXJ5eWU5T2VrVnU4eGtPUUVH?=
 =?utf-8?B?ZzBESTgzdGs5VWxDWnpwaUduZzZ3RUxOWnJFeHp5NUxmQ1FYQ05zc3ZPK2d6?=
 =?utf-8?B?YlJvVEZZWFM5S3h1eXFxeFJ1cWhKREkyQmhCMkRCZWtFTThZcjBKUUp0cHQ3?=
 =?utf-8?B?NlIxOUM4aEpNVFJUZmZaLzl6blJ2Zm1DYXpiS25ITkJxRjZVdzA2a2c5bUQx?=
 =?utf-8?B?emVYbnBKaHlzVENSYVRHRkNGckQ1QjU5ekFqWm10L0szWG5Sb2lLdkV4ajJ6?=
 =?utf-8?B?ZzFBOHJFSS91Mys2TGVsOXhwYzBxRldKOHBBMmY2VisvVXhnOHVzQytSeHNZ?=
 =?utf-8?B?cjZLOVpYenQxb1VweVBrUTdpUEw2RFByOGlFSWg1dWxiQXpCU055RkxVZkRa?=
 =?utf-8?B?ZDZTM2cwYUh1MVlnNnp2OWpnT2R4OVFqejNjUEcvYSs3dmhLeVNvTEt6dm9Z?=
 =?utf-8?B?OWdLQjZYaHJRUGpsUG1QT3BGenowZ09WbXRRT1Q1ZkNESC9lcHJxeTJMcFVU?=
 =?utf-8?B?ZGNBRTBxREN1VmhxWlliRG1Jd0tudGRPMFlvbnQ4YjhJYWp4NTV3TWF6K1ht?=
 =?utf-8?B?d1hBejkwQUZUSjVaYUx2SVNyMzhWNlNtVGFNK1pSNkV1MzI1dVVSc05jMjl2?=
 =?utf-8?B?N1A4M0U3dG8rVkJOV1lQR09pQVMyeVRUZ3hwVnRmRG9ETGtKdGZkMnNDU0Ru?=
 =?utf-8?B?RWhCd05Rd0xpeWdKbTV4Y0lFK09qTlBndUhHSTJjUmFNcFJ1NHBhQlhRVHpa?=
 =?utf-8?B?U2VzN3c3YndOM1V2VC9Yd0JFTkY0eGVKZFM1aUZaUXYwb0dobmE4NkFIdGhJ?=
 =?utf-8?B?dHlPbWpkeXplTXBpNzM2TjI4c0oraWh2OEdYK3lkOHYrZkcycHFtMlNrMXND?=
 =?utf-8?B?UWVORUJXdkJUOFJUQ0JSOHg3WVpEMUFHQVJyaFhSdFdDZWU0V0syQTR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDVZbVlmd21EUDR3VHZKbXgyV2V2Mk4wb2Y4TktGZTNYRTNGdTB0a1BVS2Vz?=
 =?utf-8?B?Ly8rdVArM3N0bzBBQ1FvTzJTS1J0RDU4QThKckZnekJIZ3oweEhKME9nTkR6?=
 =?utf-8?B?K2EzN3hjVG9CbFJGTWN3cHUraG5yL3VPMldTbWV6bk1jMW1FbkpvQnVHMVN4?=
 =?utf-8?B?Mm1lYnB0ekR3Y0RxYno0aFVseGRRY2d3dWJPMzdpR0I2R2xkV3haQ3N2cG9i?=
 =?utf-8?B?OFJ5Y2ZJbjNtbTk4a3dnTTlXWXU1UmFMeVhqY01Ya3Z6c1ZvY29nNGpidzBx?=
 =?utf-8?B?aVU3OGo3WnpPOTRSSENkRGxsaVlDNjZaalZwcnVGdFExaUdYZjlzS0x4SjRH?=
 =?utf-8?B?MVBqVGdCMHFWbVlSQjJhWExsS0VuVmx2cnFjclIrMXJ2dTEweTc2Y2RuTGE5?=
 =?utf-8?B?WW1ORTFNaC80Y0dqbjAxUE5YS2RDdE5ROGNkaFFraE9PU1hyY2NuQzdsTDIx?=
 =?utf-8?B?RktwTk5TNlBUdEVBVkJLdjl1M3BZSExBeStCVElEZWpMTi92UDgvNUcrMWhl?=
 =?utf-8?B?UzlwcmtabkVMQ1Q0NFNKb3pOZDZMeWROQkhSWk1aS1NEUTVxZE1NSXpaVDE1?=
 =?utf-8?B?NmFWRGluZnp4ZHdBc21zQXJUYWE0OHZpbnBWKzE2SVZHVEFwNEpTalhHZFRK?=
 =?utf-8?B?LzUycDZUeGhhdjlJRzJHQmlUd0F4VEZyRGcwRlFSZUpJM0pZcGlDd293ZDY2?=
 =?utf-8?B?Rm5Vc2ROUXNzSE5TTWxZMDJkelo5cWtXblhOR1BsL1BRb2kxM1h3bzlaQ0xJ?=
 =?utf-8?B?U3QzakI2cUROWXZJMHNoKzRXcmo0VXQ4d2gzeU1vSnhKVGtoRGt1c3JJNy8w?=
 =?utf-8?B?Q3FycmZmS2tobDNGNEdEQkpTcWZjeCtzSTRrSGtkNDcrUTN0RjYyZE1KWkFa?=
 =?utf-8?B?cXRhRTJpTVhnd3c5ZjJXU1ZEc0ZnUmNsbXhWc0VDeVROREEwYzlmeUFKYU5k?=
 =?utf-8?B?MXFxdTFqOHlkSE5sL1RjMENFN2FCZ2l1d3BnU0lsckhyZzlubFB6L2RQb1M4?=
 =?utf-8?B?OUhZUysvcXY1QzdXQmZZS0s0ejRzOXBmTWV5MU9kcjVmVGxydkF2VUxXQXlZ?=
 =?utf-8?B?VTVkajUxbU9lOEtzbTlMUDBlazBwL1MxSUVKSFdVTy8wdVZpODhWVTJqV0FG?=
 =?utf-8?B?NGVTMHErbEtVY2FVOFU2UUxuVUlFbGRBUnkzdXYxTnAyTUY4cC90NUYvM3Ro?=
 =?utf-8?B?N3VDNWlQYUE0c1pZR1ZjdUQ4bGtONWRXZnJaeERUVndCc3BhMDZRNHpTMmdJ?=
 =?utf-8?B?SDF4SytPejhpWlZReGdYMm1mOHlObGVQUjFFNE4rZVVGRjhyQmtQZTAwckp6?=
 =?utf-8?B?OFhISTJOWXZVVC9KQkZoU3o5QzB3azN4Rk9MUm5neHpwU2JCbWp1SEZFVE94?=
 =?utf-8?B?N0tHZVpWR1V0NlNVTUlwaXJoNkZvWDQ5bXdJMlZGSWZBSzFOSGFJSDdaSEk2?=
 =?utf-8?B?cEpsV3hhMFJMbkVWcGVTakNmY1c2dVYxZVRQVGRFYVU1M1FIN2d1a04vYU43?=
 =?utf-8?B?OTRYM2x3SFg2SGk0Ynl3eTRPZ3MxQVdGcjYzcEZrekNLN0cyNGd3My8wNmZh?=
 =?utf-8?B?bmxTMklaRjJHWEpxcnVQZkNFWkloYjZpNkduYUpIK2pUZHFpQTMzZVFEWGIv?=
 =?utf-8?B?R3MzUXc1UGNoRSs2OUhhekl4TGFaUmpZcXk3Y3NqQzBwZmRSQ2NUUUtmUlFx?=
 =?utf-8?B?RzdCUjdSR1ZPOVd6NmtoMlZDYXBhTXIxNFdPSDd1bjNZRDlKZGI1MXJKU1k4?=
 =?utf-8?B?dUFhc09XYjY4cll1SXQvSlJWMGZLbkhOZE9wYVlBSlJ3dVJVWkY0bWVNSDVD?=
 =?utf-8?B?aFpGYWVWMTBIRWN3MlMyZnlkS0kzVGhGTE9sY2NsaHlRQU9TdEFSZTQvRlJk?=
 =?utf-8?B?YVNOUWdFTi9lVlVSb0ZYZDQzTkJRSEcrVm1wTjRhQjVOT25EeFF2OXppNmxG?=
 =?utf-8?B?bDlLK0hBYURLVFBQMFNyTm4zK2dVNnlCTk1XVXpFVVVSZWNYMFBRbkp0V3Ar?=
 =?utf-8?B?OHdpUksxeHlnanB2L2hRVWtWVGRsWkw0UkwvUlRkTm5hK29nblhzSENHWm1j?=
 =?utf-8?B?a0x5VEFHY3lneVcxa1hiMjVyTkVybkhUU3g3Y2xIMnRrRWZjQmZlWUtmWHRk?=
 =?utf-8?B?MDQ0dDFlTE1MN2U3eE0wY2QyZXN3Tk4rbEFEcUduTEhmSm1IcTlpbUJNajNC?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 646f8ec1-f326-4e0d-e917-08dc80e5fa98
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:20:42.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzezvWO7olKGYYSZupFJbjrCAXpH3PxH1mvSG3oyl/LF5cSsyePb84wOlqTOB6bktmApPsAvxofbyqPmfhJ6lHs7v16atedMdenAAnSCyEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6453
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
> 
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
> 
> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
> 
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
> 
> The other mode divides the RMIDs and renumbers the ones on the second
> SNC node to start from zero.
> 
> Even with this renumbering SNC mode requires several changes in resctrl
> behavior for correct operation.
> 
> Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
> how many SNC domains share an L3 cache instance.  Initialize this to
> "1". Runtime detection of SNC mode will adjust this value.
> 
> Update all places to take appropriate action when SNC mode is enabled:
> 1) The number of logical RMIDs per L3 cache available for use is the
>     number of physical RMIDs divided by the number of SNC nodes.
> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>     nodes.
> 3) Add a function to convert from logical RMID values (assigned to
>     tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
>     to physical RMID values to load into IA32_QM_EVTSEL MSR when
>     reading counters on each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 37 ++++++++++++++++++++++++---
>   1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89d7e6fcbaa1..b9b4d2b5ca82 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>   
>   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>   
> +static int snc_nodes_per_l3_cache = 1;
> +
>   /*
>    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>    * If rmid > rmid threshold, MBM total and local values should be multiplied
> @@ -185,10 +187,37 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>   	return entry;
>   }
>   
> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> +/*
> + * When Sub-NUMA Cluster (SNC) mode is not enabled, the physical RMID
> + * is the same as the logical RMID.
> + *
> + * When SNC mode is enabled the physical RMIDs are distributed across
> + * the SNC nodes. E.g. with two SNC nodes per L3 cache and 200 physical
> + * RMIDs are divided with 0..99 on the first node and 100..199 on
> + * the second node. Compute the value of the physical RMID to pass to
> + * resctrl_arch_rmid_read().

Please stop rushing version after version. I do not think you read the
above after you wrote it. The sentences run into each other.

Could this be specific about what is meant by "physical" and "logical" RMID?
To me "physical RMID" implies the RMID used by hardware and "logical RMID"
is the RMID used by software ... but when it comes to SNC it is actually:
"physical RMID" - RMID used by MSR_IA32_QM_EVTSEL
"logical RMID" - RMID used by software and the MSR_IA32_PQR_ASSOC register

> + *
> + * Caller is responsible to make sure execution running on a CPU in

"is responsible" and "make sure" means the same, no?

"make sure execution running"?

(Looking ahead in this series and coming back to this, this looks like
rushed work that you in turn expect folks spend quality time reviewing.)

> + * the domain to be read.
> + */
> +static int logical_rmid_to_physical_rmid(int lrmid)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	int cpu = smp_processor_id();
> +
> +	if (snc_nodes_per_l3_cache  == 1)
> +		return lrmid;
> +
> +	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> +}
> +
> +static int __rmid_read(u32 lrmid,
> +		       enum resctrl_event_id eventid, u64 *val)

This line does not need to be split.

>   {
>   	u64 msr_val;
> +	int prmid;
>   
> +	prmid = logical_rmid_to_physical_rmid(lrmid);
>   	/*
>   	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
>   	 * with a valid event code for supported resource type and the bits
> @@ -197,7 +226,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>   	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>   	 * are error bits.
>   	 */
> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>   	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>   
>   	if (msr_val & RMID_VAL_ERROR)
> @@ -1022,8 +1051,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   	int ret;
>   
>   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
> -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
> -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
> +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
> +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
>   	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>   
>   	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)

Reinette
