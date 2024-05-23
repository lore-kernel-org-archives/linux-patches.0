Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FBA126F1A
	for <patches@lists.linux.dev>; Thu, 23 May 2024 20:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716497795; cv=fail; b=KmdsLlxz7xDAgjk34n0jK+vHtjeb5JMa7lXsCGCiGXh8TGgKNUG9Tm7VfpKQy6fESXAbi3h5fIFRc6mJv6kV0n1UHc8Gs8TgMHf4oYWKjm7ArUmjYrDhM10eAI9mSSJFVS/SiohDzlBVTX+Gq1t9Fxv9MJ+s0sByDSbbDqTjQJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716497795; c=relaxed/simple;
	bh=XpZ008BTsC3CqmZF/fi+OHnV8Fw4dBASmKWxilcHvCA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NdVSBrIkTrQVrpOU5UdNxRIRSFb1xNQVCmqMJCBS5gsmUncu3bLJAliv9LvUY2AU0HbrRgXAhEIZZeq/YBZ62FYikLOpIjIu+W8R05xrcYi8Afe3HnXaIrJMAjv9a8BBVv4g6zx62CCLyzsHMfQPsxatHOpN5y+2LfrqVg82z1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJ01BBaB; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJ01BBaB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716497794; x=1748033794;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XpZ008BTsC3CqmZF/fi+OHnV8Fw4dBASmKWxilcHvCA=;
  b=EJ01BBaBIz4rrdNEIMTRR7lImXwOgBTFbm8oroyzdbgyIC3+78ljJF4r
   hp5RdqJ7oEVw+7zk1hnEZ+Yo4GUfJxdjn5GkUsupYr4pCKxTp6LcvineY
   xgXj8F+OZ1H1NcziKEnbU4EHGJOFCM8u/KNlNxoV5f8VCJ3Fc7Xt47Hkf
   0cEO2TTKAn492pX3E17tclilejibzj7FIDMNQ5x4Je6HYsaanBFzGJqoS
   dR0YXUWjrRI6WU6jHQyJg7y/iwuWELAlKxdXanJAFx/lkLkjpRubuS7Nb
   ciKgJlLvIjmZM6+m8jBk6rCwxETBtX/C+pt0lRnmdOYpHScM1FB8/Sr8B
   Q==;
X-CSE-ConnectionGUID: E2DtbQd0R/aSq706jx6mFA==
X-CSE-MsgGUID: 60RGN/ybRu6+uyI5Z2jFbA==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="38231258"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38231258"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 13:56:33 -0700
X-CSE-ConnectionGUID: P0uy6Ns2Q16mnaqTDFUPXg==
X-CSE-MsgGUID: ML2mOF0+QvaY0oRJnXum6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38780682"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 13:56:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 13:56:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 13:56:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 13:56:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN/znJRvsvaZh5P9dYRrZv7tPJJ2kROIzTW7sRyV+xkW4PRtmpU/De0Z9nppyjXTm99w9kMIE4AhAYMkrTCjcj5W5qgKZ8cClcHafii2/VYBLU6/dlKd3Yy1G27RKutlHa4yqwbgdzS+BReoibDfC3q43BPHODzWO8tooPEmZyuQJuzJdWNP8GACTlIF5AwCWNrWjui5oyw8qwjb+GXEcXO8AbJK40zEAFwydXKINHCsRELqk8hENs1pm10esv+vYe/VYFVs8Rk7QwZo8PC1uYnhZDW5khqlclB42pEzCWgyXxHkZGDfJI7qlvRdcrpJpKhZnx2cZ2dqFa4khCVTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LV2DjpcIpdVXjo3u1kMgxoEbSweINPeoqbEEI2w3fFM=;
 b=ImxVe4a9+1skYIWw3ZpSZTECJCaX5JgT4zXa95PONVDy5spKB54elEeiF6elNw66mw/+eGKp6OFyPuXwp4SD1OQrOVol3jE9ITy1vD+CMKWQOZMHsczzXPmnzeoVtG2wACsvMOx5eQCIuXOjKvSGXM6dVYUxnhX+zK5EETxeVoUYRLxbXoaM945UN5Fmb23Ef1asuJQeS/CU+lsgcsCeJ6mBWR2xhvlvtxAukSBZc3/KtUEvR6o8KQfR1NailjyxITSxBJwXKtW64JXQ/4VEVH1Bp9cm57ShAMCW2wybHrY8MMYAI1MM3ncMtRGGkJthns3nI+QBBXbI2TqXHfy2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7696.namprd11.prod.outlook.com (2603:10b6:208:403::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 20:56:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 20:56:20 +0000
Message-ID: <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
Date: Thu, 23 May 2024 13:56:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
 <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:303:dd::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 93658272-b172-4903-64d3-08dc7b6acc3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ejUvRVVQb0pPcGZKaWUwL1AxQXlXbG1xazBERnFVTmtOdDdIdEJsRGN2UTd0?=
 =?utf-8?B?WWhvanRQSU0vWlR6VUw2TDdBbGRuNVZWcmUrcnRSRTNlNWw2cjU5a0Ixd3Vt?=
 =?utf-8?B?SmJGalM4NXhhcGpSZ1J5Q0cyWXBFSUtIcGNic0p3dVpSY25LQktYWm5LaVV1?=
 =?utf-8?B?UGJaZ256NnZFbW9RZ0dFQzJFQzdjcFJDUHB0akwyMnB5SXpGMWZRVTdGVjE5?=
 =?utf-8?B?NzdNNVBzWGxPODRwR1laZVliTHVMUGhxZzloM2RTWmR0b2IzOXpNcksvejhH?=
 =?utf-8?B?Q1ZHbzFoRm50bzREK3JwVGJsUzZPb214dG5vVUhXcS8rVUg0NFZTNHhPSFAx?=
 =?utf-8?B?Z2ZRZmpGZ2lHelZDOWlWcVAya0pzZXZnUzNiT0ZuRnhXcTNMblJsSmJseTln?=
 =?utf-8?B?Nk9VMVpyQnpNZURKeTA4OGhjT2R3ZGN1Uy9ITlBMeXFxUFVTcXlxdG9wRzR3?=
 =?utf-8?B?NHZQT0hBWjhLRzljOHVEWDlobStVN3JpOTNlOUh6Rlc2OHIvbUlLNndKaldi?=
 =?utf-8?B?Wnpya013cXpIQUMzZ1lsV3JZUXFzMC8xUW5rUGgvUEF6YU5BWVlEVk9pM1RY?=
 =?utf-8?B?S0hRWGtyR1h2YmU1YjJQQ01OeFZYam1xWTNQQnNYLzJkY3hJaWtZeUgrQjlq?=
 =?utf-8?B?aGdOb2FLQ0N1bkk1ZDU3dUxRVnEzL0hIc0NtYXdGVHR6Qk9FQnh3MFp6NzF3?=
 =?utf-8?B?MjE5NWRGOUl5NStNTkkxMUJESDZqUlA3OGRlTGkxdHlqUXExdTlwc0xiZ1Z6?=
 =?utf-8?B?ZjB1RmszMFNXK3FKQ0JLUmlDVDRvWEEwWFViaGVYQzhSYXRSTFZVU2NtT21V?=
 =?utf-8?B?MG4wUkgvc1hhYU1rTUF6bSthYW5JRlVJWEVWc0VJU1JHQmFBVXBIekZHRDJY?=
 =?utf-8?B?L1JQa0xLUEpOczNTci9wTU13RzJOcE1heHZqa2p4Unl3TUpsS1hkVnRWOVVE?=
 =?utf-8?B?NnlCeEZtY2ZZWis5c0pFY2ZRV21Yck1IdkNYdEhWSjRPeFc4QUM4Q1BOS2V4?=
 =?utf-8?B?bGxoL1ZaNEJqSlVMRVN2MEhnYWZKbVRBR1o0QzRMM0FzVVFHbkJOSjBLN0or?=
 =?utf-8?B?L0ZnaFpTaDBNQmZRVlBzVytpN2lNbmdUSTlRVGVnTFZmZDJRVlIwdGx4MFk3?=
 =?utf-8?B?bkpTdFp2bWVoWHkreFpQZGZibUFFOTRhUjRzUGNXaVFYRDR1U0Exa1FDNHJD?=
 =?utf-8?B?K1BUZDhNM1k5cUhHdHVSaGYvTnYvK1dmTnYxWlNLZ2tXdjFGdkN1UlhXZGN5?=
 =?utf-8?B?ZEVPRWVhMVVNVEIwZjdGbUxrUUI4WTRONnR2cFJWRTVYMnUxZktlTi9RRjkv?=
 =?utf-8?B?OURwb1FUdnpUcHY2M0U3aWRKaVBBSXNJL2NTT2pjRDJZbmNjMzJpRFdyWE1Z?=
 =?utf-8?B?RTFUYm9KRHBmd3RjQ2lJd09Sei9ZTnJIenA3cCtNT1FhalpLVVVKMDhmTTE0?=
 =?utf-8?B?OXNIaTc5RGRiYUQva2JWS0xmQTk0WWIzaDdXelo4SThQSHpuenBhMldRQUdU?=
 =?utf-8?B?bmkvR00zZHpwdjN0bHpWaVJOVVdlSGRJY0o3R3U2MkQ1UStmRlBwTGpvZE51?=
 =?utf-8?B?elhZbUlzd2pTU3hyYnhEZ1NpOG9yRVowbm1QVVRuNWg2cThoMjV5b3BIUTFl?=
 =?utf-8?B?LzYrU3NKdHNBZTZUZngvWk1MbFlMLzdhbFNhazZPaUFRVGdhZWtnck5jbVNm?=
 =?utf-8?B?VitRMlByd0haUGh1ZHhSVXloMGVpZlgvVUFIMEw5dzRDcVhrY0hHSkV1RGN6?=
 =?utf-8?Q?TDoLnv+hSkkmd9U+cHu0XT7qPcIblkoKpi3xlrj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU5oRjZRSVFLTjdYUERKVDRqeWowYmZ1OXJXQW1ZRkVqUDVKbUhqTnBTOGNV?=
 =?utf-8?B?WlBERjhNc1J0NG54ZmNGV21PR1JIenNVQ2w5WW9wMG9PQVoxMFdYUHpScHBM?=
 =?utf-8?B?YWlGaVcvZnhSbWF2Uit4QTFENWQ5N0hmU054YURPT3cvQXJvbUFvelZabnA4?=
 =?utf-8?B?a1R2VjIxQ1RnWDgzeGZtU09iTzlFZ1VCWCtZQ2dvc29MWFhhNThDWkNrYVhK?=
 =?utf-8?B?QjBMcnJZVkJiNjZZNS9yczVENEtPb0p6QTFEMDNZeXE1TVZwMExteE45Nlhj?=
 =?utf-8?B?ZTFoYlh3ZEx3Q0VRbm83SVhpa2JJWlNScVVZdzREcFdLc1hpT05CeVBpKytU?=
 =?utf-8?B?ckpYUTJnNG8yNEU3Q0U5cU10VTAzTkRqd3IycEI1WnhzKzE2a1NmUXRzMWtX?=
 =?utf-8?B?VUlJRTlBOG1TRjZCelFBUXNkMnFnMC9Xck9IWHR0c3JaTVZ3T3Y2YjMvQVlP?=
 =?utf-8?B?QllDRUFuOVFJS2U3QjN3N1IvRUpEOFF4NTByOFMxMjZhT2dYNnYyMU5wcGwy?=
 =?utf-8?B?Z2FKZW1GblJSWTNjc2RlV0dRWXN3TzlITkl2b1dTR0JnQ1BLSWNFQnVvcnI2?=
 =?utf-8?B?ZHVidVZ5eU56MExiZ1NUY3dhSHdmT1lqWTVDN3MwaUo1c3VqdVBTRHc3OTdq?=
 =?utf-8?B?U3VOSVoyanhWWjhmbjNMQ3JJMWZCb2laTktzbEJKQTZVZWdJUHdrS2VWd3p2?=
 =?utf-8?B?Mk5vMVprMnh0MW8yajZPY2lISkdLZDExSlV1UmE2eVQzRG1ZMGVyL1hld1JZ?=
 =?utf-8?B?a1VMUDFWcGlWZ2dSbFgxcVRYckdqZ05xRmFkNTFlMi90SjNlYU4yeEx4YnBL?=
 =?utf-8?B?UnV1cFFXMkxKMUlNa0JoTFFrNmlEdCtGS2ZtT3pzbXVCdHVVY1NFR2dvUnZG?=
 =?utf-8?B?T3hOVWgzQ3QrUUZkdnIxQUI3MHIvRHRPNFhXQkhDOUxaSmFxdlYvR281RGdr?=
 =?utf-8?B?MDdGQUgrTEVDOU1Vd213Qi9WcUZ1MVNnSEZraUo0NVdyYkhqVjBBMzNRd1d3?=
 =?utf-8?B?dDBIN2NEOWVvWG1uSEorMkUwZEJwekZnQ3FoSm5XR1NHb1dWVnA1S1c0SWhJ?=
 =?utf-8?B?VmloUXFGR1BmeHJZY2hsc2kzRzYrY0VQZXhNRjZTTktXKzZCVmEvelNERmlW?=
 =?utf-8?B?cUdOdytLNWxIQ09rUFNQRnRYeG9YWmREU3VsNlB4bEsycko5di9JV3hBTmhK?=
 =?utf-8?B?azlVRSs5TkRURDM3Vk96Q1ltVVRiT1IwWHNad0RMOXdyOXM4U2s2TnBnQmpa?=
 =?utf-8?B?Z1d5MWFJZS80YjVNUGZKV0NVc0ZmTVlFVGZhTWVCbkJFUnVHUGtLYVNMd1VV?=
 =?utf-8?B?YXFwSTRTS2x2ZktCVzZsWmNTeXhQVHFQbTZaNmcxZGxEMnlyRDUrdWNrUlhM?=
 =?utf-8?B?Q0tRblVxUk5PRUtmYnIrdkY4TTJtNVF0UjBNVG9XM2RIT0tzVTRZK2dWeWFi?=
 =?utf-8?B?YlpUVmlkcFJWNjdocUxiRjZXYnloVVA3ZUR6K3JKRHRyNWIwb0hZdFpTZVFm?=
 =?utf-8?B?M0VRNUxsLzFKNlBKSHllVTM4dUkzcE52eWM5OFRrQ2x6dTFqMnc0OG9zN29U?=
 =?utf-8?B?Zk1FbzZQV1pTU0RCdnF5bkQ4U1pVZlYvZjdBKzJwU09nRUJrb01yUW1ySUdo?=
 =?utf-8?B?bkEyaG1LYmV2dlcrR0h1SUI1WW5aK29EWHArdGx0ZU1iTndDYnRNOUFsWWhB?=
 =?utf-8?B?VURISjE4d1BqMjlMTzRHcVQwNE1QWU84NnVjbE8zWHoxRTgrS3F1Q3pjcEpm?=
 =?utf-8?B?ZzlybDFyY0VQbVBmeWsvbk5JTHlqTEc5RElBSFZ5RVoyb0NENHZCSzRqWnBh?=
 =?utf-8?B?cU9ubWZQWWp0MnFlellFNGVVdC9BaXNRckhQeCtCeCt4ZWEzZmNpRTR0a1h3?=
 =?utf-8?B?TTlzeGVML2JoSFROSlRiU2NGMXp3OFErRVNLMVptSzFuTm8vUEkrMFR5bTdG?=
 =?utf-8?B?UDloMzdLVytMRXQ3aUYxVUxtYnR5bTlQWnRVcEErWXVmS3hxTENhSXJmbktF?=
 =?utf-8?B?UkltSnJvR2VqWVoxL0lqT21tTGVmTkVLMlpqS1Z5ZXRmVGdvU3grYUdkQnZR?=
 =?utf-8?B?MUVtdUFzcFNYdFhZd1psT2k5Qy9EMGcvZmJCcG8xQTRyak9Yb0RBL2FUZTl3?=
 =?utf-8?B?b2d2MkNKL3Z2dC9ZdEI4eDZFTkhKOVFhekg3dEsvYmVGOEJGUmIwVlVsMzlM?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93658272-b172-4903-64d3-08dc7b6acc3c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 20:56:20.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9xkvoPCG13gyRE4qYTftHP8ixWkHznyryZAndt+N/LxpEr/WavRlbunmAV+HMP0+QXWJ88D8DTrfbtJSZM1n7Rh0KyPz93FVnxOTMqEPXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7696
X-OriginatorOrg: intel.com

Hi Tony,

On 5/23/24 12:04 PM, Luck, Tony wrote:
>>>      return (is_mbm_local_enabled() &&
>>> -           r->alloc_capable && is_mba_linear());
>>> +           r->alloc_capable && is_mba_linear() &&
>>> +           snc_nodes_per_l3_cache == 1);
>>>   }
>>>
>>>   /*
>>
>> Since the software controller is a filesystem feature the above
>> now requires that snc_nodes_per_l3_cache becomes part of the resctrl
>> filesystem code and every architecture will need to set snc_nodes_per_l3_cache.
>> Every architecture will thus need to interpret what "SNC" means for them
>> using the term introduced here. That may be ok ... but the term "SNC"
>> will then surely not identify an Intel feature and Intel needs to be ok
>> that any architecture calls their "similar to SNC but not quite identical"
>> "SNC".
>>
>> I assume now that as part of the fs/arch split there needs to be
>> a new helper that allows different architectures to set this
>> filesystem variable?
> 
> I can change this check to better reflect the underlying reason to
> disable the software controller. Which is that the MBM monitor scope
> does not match the MBA control scope. This seems like an architecture
> neutral expression.
> 
> So code would look like this:
> 
> 	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_rescrl;
> 	struct rdt_resource *rmba = &rdt_resources_all[RDT_RESOURCE_MBA].r_rescrl;
> 
> 	...
> 
> 	 return (is_mbm_local_enabled() &&
>                  r->alloc_capable && is_mba_linear() &&
>                  rmbm->mon_scope == rmba->ctrl_scope);
> 
> I'm also contemplating dropping snc_nodes_per_l3_cache from being a
> global variable and making it a field in "struct rdt_resource" (only needed
> for the RDT_RESOURCE_L3 resource). N.B. Babu had suggested it
> shouldn't be global many patch versions ago.
> 
> Perhaps name it .domains_per_l3_cache or .subdomains_per_l3_cache?
> 
> Bad idea? Good idea (but you have a better name for the field)?

With the check in supports_mba_mbps() changed I do not see
snc_nodes_per_l3_cache needed by anything but arch specific code.
I thus do not see any reason for the resctrl filesystem (or, for
example, Arm) to know that this value even exists.

While struct rdt_hw_resource is a place to put architecture
specific information it does not seem appropriate to force every
resource to carry what is essentially a system wide (not specific to
resctrl) L3 specific property. To me this really seems like an
architecture specific global setting but I'd also like to hear the
motivations why it should not be.

Reinette



