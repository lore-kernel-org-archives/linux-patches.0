Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA1B4CC267
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283372; cv=fail; b=VZEdmdQZowGW17g5tiw3LVqTyIChW/NU21jjWP1LZXdTfI7POYTCxS4LJeju7rgJgm5lP/9vduupAa6VQIwig8K195O3QIrC8WWybtTpOC7EyQ3QeQD5dT4Kk9j1MkZa1YXJBePUvC8FND1YxAnr93d9e+Ah0GPhK+s9CLW7sic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283372; c=relaxed/simple;
	bh=00y2/XNNwiZu9FJfc6GTtbYNw438Ql+CLH8DkQtbs0Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rf9a8zJgx7NuNScpNhhwMwP0iPQG7kv5YOf6YneNEHl3l8TWYS35AAXQSV//aPLGapWcN+aUV0Qtr1eDi+IuSHHWSszUH1HtJ4cmIozvVvfW52frgjvB952vOTxiBXS5toxjHA7bQKkBajJ4oKqrA85gNbfhLwHwQ3As7/eTS/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nkkEZH+O; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nkkEZH+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283370; x=1821819370;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=00y2/XNNwiZu9FJfc6GTtbYNw438Ql+CLH8DkQtbs0Y=;
  b=nkkEZH+OZn1pic4Ur9ulkVTYw6XC7h/9cUQ+ThBXhovPHVl4Q+PekbhX
   yCqlCR8EC2kJGxONgsYpFCsDKuUa68lF/wMUfx/2Cm0L/f2hHGBYa1Y4e
   7KaAEoa5tqplA5UTNTHNnzrCJhh6+8KVba9sSv+cLwwrW2xk9njSVQI3l
   uQObY/JTgxHN5GINCgaUWoCUBRVQIhauja3a04hTaEcAUUJffsv2s3eSZ
   yyvzCJFlUVmWETU42h3Hf02wRmoGphi/1zFqGANOkmRy7sg3d0Olb8JKJ
   E5ripIi0IKi/XZz26oIlI6rXAP+rF1zxWYU6zV0/g+1hzHrMz444/F8ay
   w==;
X-CSE-ConnectionGUID: +8OzhRcXTn6Vt1rDRG8XsA==
X-CSE-MsgGUID: EOccScbrT9ilgoL+yPLgwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89837400"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="89837400"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:56:03 -0700
X-CSE-ConnectionGUID: X7PoiP3CTYiH1jAMxiwMZg==
X-CSE-MsgGUID: GXkxmFPeQIOMvKnzYUeWeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273240369"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:56:03 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:56:02 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:56:02 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.5) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:56:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IKt1ipvdgqvubUBfAFCDFsj2pTvrbKA3/xVWvgc0N5x8WUhPYv4wwnUpNq7vYVASIzcmHb3wHKpbpGRdKBGEnCeyY6NTw+tgEtzp0jH3kFTYtJwlHDZnW3KXD8qKOyCKZtpHsl81H7sDgh0Cj5UbkUCbrpSiLfjbd+y5vZw1FkXPDZ1O+lLMVZ2653EY6GPZJ49Hk4hRXV2o5psJ1NBswouEODZFWEMEMdILBuzmuG3Arx9huoBDxvWZxjOADbgRxKRLlnlIri34T25o2XKFRKqJC4EppkpS3iQ7H6A5afwZ3/HMcsxVqTxRmT1JZD6R2MEIxlw8XVmxkJT7JRTcSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00y2/XNNwiZu9FJfc6GTtbYNw438Ql+CLH8DkQtbs0Y=;
 b=lCCNuFaY5r+zEvht0hVqAOH126tB6woMaRw1N7M/BcdVZDGrZ5+kus8ns2KCmOuWozXNKt69s+RM+wz8+lSfOvTJnvVGCdNtvuOCGcE2j7GyM/AJamgK5yL/DFai/bzJrKT59lYCSfMyn+nWucztA1/A/YUrkeHZCtXOOcTTmoICuIZ5sn7s8POTzYDf3zGK4pdOVkegOQjWaQNMwiDseBycYpyhJnD9HmQMLP7VgtzabsY/FjRuYsukggZFchUFtL0iHtQtRr4cJ/G7S4gP/EmxoRlaB2UhZHadSPMWPSSSGDpdxevlzriIyQQaKXaFeBqgJBAjVVsnOSNdRkztzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DSVPR11MB9916.namprd11.prod.outlook.com (2603:10b6:8:45b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:56:01 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:56:01 +0000
Message-ID: <83a5f277-da0e-4976-a6e0-6c5743ddcc87@intel.com>
Date: Thu, 24 Sep 2026 13:55:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12 22/25 UPDATED] platform/x86/intel/pmt: Inform resctrl
 when MMIO maps are being removed
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-23-tony.luck@intel.com>
 <20260918162901.10724-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260918162901.10724-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:303:2a::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DSVPR11MB9916:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fa3136c-4ed3-4e0b-6e6e-08df1a7e3d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: shVQlX/GEA4CY9LRPQLgkpZ+dqZA4W9FbWvi+2Ed2dubKVU0KOtWThOZVcbZ3Rm8I7cD9eaKYXmPDsJOMZsffAfpTC6Wf5Qgv2weigWtSAfuBdElGOuexVHafh3q90b86zNX2WxSCc9SWvoJ5Dlrre/CWEGtFkbc729gfZnpMnPSRH6rAdwQ5joHtCPeV/XPYsmonlIhAimLMeofpTYNMWKlxo3C9DAXAkxxXN5+sj58hr30lzayZgyITLro7aPzTg85HJKmRS7xZGsqVdgCVTSGHP/YG1aDFNPSn02vwv49hnUnf3HINXWsWpgJ3oYFtQtDXWW+HCBbHddlkaTASxzEeEguk+RnJQzacB6muNJxrZ+cBiACfSHs33KMnca+vYih+qgZ73oAWliLYvbrchMFnjK1Mzg+g3FGJ+E1YyTXouPju+MIl2EWad2wXh0+m0zNyx7qUXV8Y7zP4O45PrFJZi8+44nBDa1ZtjH7aLTTaL7cPf6AmSZusEfAaH+RZaSnV3mj0pb2xWbCuHMwToZTVJfDgBYCIEgomfcCO9SThmga4KD1+0GgsxhNtfT/DVqgsP7w1xfR60uPdl24X4Hdd/h4t8DoWx/23qb0Bld+i1hE5dAbP7cVo7/ilod2ADSfeKSwvJaWX9V57BJ2Fu8bE93BAFBXI29oqJcmTXZCN/Pqs0VzcxjLwJITF7k8Nz3ml/myGNyG3nOQbE8OlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU9NdHdieitJTGxRTVlvQlRQWXIrUGI1MGg5TlNIM05aTTIzTE9iMG5RNk1n?=
 =?utf-8?B?dG5QekF2YXBlREdjMkIrcEpWNHV2SE9pZWJ0b0NBTnJZV3d2cS9CSlJkNEVK?=
 =?utf-8?B?WmxieHh5YklwVXhuUG5vVE91QnZ5MTEvbWNFa2YyR3l5VXFCSE1CeW9SOEo5?=
 =?utf-8?B?NmRVbm1SWXdJblY4cmltWXViY2I2VllsaTNIZ25XL2JVakRqeWxhaGhjdnAz?=
 =?utf-8?B?V240NHVUSkxPT1RpMzNwUGxEeC9xUzNTWUVKSk01WEpqVmdmT1dST0hWUVBZ?=
 =?utf-8?B?TzEyZ0NtczY1OGVqV3IzMU9tUFMxRUYwdDErMUpEVERWeEEyOG5McVc1RjMr?=
 =?utf-8?B?NmgwTytFMVZFOTJoQWZwenE2ZnVJejRoRWFJOFhJaTZIWWRTa1ZVV3RmMFV1?=
 =?utf-8?B?aXpuWUtEcTYvZkkyNGxNV05TMStxeHBhK25COXozdkpEZVR5Ym1PTGQ5SXpR?=
 =?utf-8?B?V0hXMFJSVWNmSHJwT0JuNTU5SzMzV3JpOXBBSGFlSkU4d2VKTFRaTHBtNG1I?=
 =?utf-8?B?UnR1RHNlZS95d3RSUjJJSHFpYk9tSWNKNXl1TW9oM2p0MkJMditZc2tyYnJI?=
 =?utf-8?B?YVJPNmJ4ckNEY2l1YlJjV1ZveXdoaUR0MlUvdDdRRk80MXRQakMzTFR0ZUJx?=
 =?utf-8?B?MnpZQ0s2Z29TMGpUMmIzaXdCTXFnYlNVSVZNVlBJTGxaK1ZkYWRtWUNQZVZp?=
 =?utf-8?B?RXVzRDRFeGRBWWFHYXRmTG1qWFllV1JNVjJGZFdJak1rV3VWYTU0L29XZ2V4?=
 =?utf-8?B?SVdmSm55U1NhQmF0cVZmSHZTUHY4aG9nSU1mSytTdmZId1phU05DWmhaTlZ3?=
 =?utf-8?B?WTB1SWN5cVlxd1hkT3FYV214c1pmN3lWTHc3aEdqaFZSMHkwcm93eVlRUU95?=
 =?utf-8?B?ekdvYzNEWEFJcjJqMnk1TU1XcFVreVVxSjV3c0JmK1dGSHc2RVNkSkhKZm0v?=
 =?utf-8?B?R3VvdGFUN1I5OS91bXk5eElWblV4b2Jnb2VsVFVrRVRNSXRwMWFoK0NIbHRq?=
 =?utf-8?B?WU1CdEhCWmJNYjgyMHh3cGxJbktKODY1ZlUrVFBXaVFod1dpeGtrZmxUbnVO?=
 =?utf-8?B?aXBQRGUwTVFKT1VZZllxQlZHNjMwdHJlbi9taHBzdU9BMENSYVlnYlVTMlRi?=
 =?utf-8?B?cGRqSnNzdnlXZ3NrSFJ1a3NsYjByTmZKQytCb1dVUkJSUGJxZmVnU0lxWW5W?=
 =?utf-8?B?ZTY0NEFCclZtUmNqb0ZUSUliSDhQK3ZJQkpkdWkwelNSb0Z4Qkd5V2x5WXM2?=
 =?utf-8?B?UkYvTTE2VGZNOUdvQTc1VkxRRmxzbVQydmI1SUJTL0pPZmYwa1gxTm1EY2Rw?=
 =?utf-8?B?R3JQcGhsVm5wVGg3TUVTMEtGY0IrdFAybXgrazA3N2tHemZJaFVOUmtjL252?=
 =?utf-8?B?UjlWQ1YySEM0SVU2ZGR4OEl2eDArSXhnYnFBOS9BbDRzMXpmQlh3Sk54SU8v?=
 =?utf-8?B?WmZ4OWMrWDZUVk5BS1RPWWIxNENjbENOMDIrQUpqQWNxZFRZL0xXblI4YVdN?=
 =?utf-8?B?SzV2VHBlSUJCZlJFVnV3SFl4UDdXdGVoc3JnVnR1R0h2Ly9yaTQrUkJvUkFL?=
 =?utf-8?B?YUYreE5ZSGJOZFJISzNMMjF1TW5uNS9MbnVWajNxQ3JSYUNJRVBic1VjQzFF?=
 =?utf-8?B?cUJQMTNNVE92SHowb2w5c053aHU1aGpMc1dDbDlDUWNJdDF3NUpjKzg1RnZo?=
 =?utf-8?B?SVBJaGxkQk9HVXJIU1BLMjQxOHhwUXV1SGxtcGYxRFJ6dkdubjFTWkJMcW5p?=
 =?utf-8?B?NmJrMGRmN2h1cGo1RzRIZUVDZzAwQWRYRVM4VzV0YkFvVDFxRDdlT21Ta1U1?=
 =?utf-8?B?TllTTzJ4R21UaGJQakNMRXNIWjZBdjBONTdBTWJ0Qm5mUVNMT1c1bVhpMTBm?=
 =?utf-8?B?OUVLVi9pcnlNN1JVejN5VjBrQ3VEdGt2bUtYS1FlQ244VTR3YTFWU2xFbWRY?=
 =?utf-8?B?UlJnL3JEa1lDeDVWZ3NYRFJvZ3MzRHE5cGcxeG12c2l4VkQ5Q3R4bXdObzlz?=
 =?utf-8?B?em83TFdXbFNROGR4WnhCcGtRc1dSSWtkcFpyZjJaSCs5TGpIOW1PRnpaUkFk?=
 =?utf-8?B?VDd1aUhDWmtobEFlaWozNEZLWEJkVDJ5R3VYQTRqNUJKVTNhb0RtN3JGeDBK?=
 =?utf-8?B?bEFVay9GYW9CRXRnQUlxVm5DcFd0cStoMEd3ZG1ibGVSaDEzeVlFUVdMbWZq?=
 =?utf-8?B?ZW5ad1NNeEV3T29iUFJxK2tPSDNMeTg3RkRDUUFaVk9NWTQ5T3NaWjk0S0Nh?=
 =?utf-8?B?REVNUU1pTDlINnBlYzlTRHRMR0h1cGs5OStiaVNuS2o3ZW5STnZjVWVwMGpt?=
 =?utf-8?B?ZmxOb2YweGszdVBlcHNlenJndmpweHdZUlI1Y213b0J1MDRFak9mS3VXTU1k?=
 =?utf-8?Q?OEags7STSRZPXh+4=3D?=
X-Exchange-RoutingPolicyChecked: K/aBjGiZJBsybpESkUTYY6OmeYUtyg3ueZGW4qThCGuKekMle5/5SEm0FfXqz4Hq5dLRXHrnbiOR5PAQaRr60BzcowTSejIdiiR7oAJCbpDjwGkGvpUavqHISGRckIVBfiPTwKyosIbIMAtNa0RZS+vMOQEeTPxVRd9mo2RPYBBvLus2/LGVrESGKNxwJH4GoEx9wq4Wy5zfkKxSZOq+ax6/iMnVoJ6QhY6WDils2RQQGvXDb+BI8WFNDq6zdTKW/yg4+iEs7wsbHp1GzNAPLIyAo+bwmFNQuwgSD/KewyJ9xIUPrYjbrZ/Ve31dO26ezqfFpMV96czQc55zFA+Oyw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa3136c-4ed3-4e0b-6e6e-08df1a7e3d51
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:56:00.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82O2nbD7I/Rnv+Ue/7/Gs34p9p0SuD44jXVbGGKM2pSnZrHerximnX2iA2FsnpIdyfYjt7JXSHw9bEoWb9VUcpIo4Ek/hy1bepBeCd+dv0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9916
X-OriginatorOrg: intel.com

Hi Tony,

On 9/18/26 9:29 AM, Tony Luck wrote:
> Before destroying devices, tell resctrl that the virtual addresses
> supplied by an earlier call to intel_pmt_get_regions_by_feature()
> are about to be invalidated and should not be used again.

Why? Could you please give insight into the new locking introduced here?
This new updated patch is presented as a drop-in replacement of
22/25 but then undoes significant (locking) portions of 21/25. Could you please
integrate these changes to not have one patch undo what an earlier one
does and support these changes with proper changelogs to help understand
what they do and why?

Reinette
