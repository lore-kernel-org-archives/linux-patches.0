Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D987E21171F
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438204; cv=fail; b=p2IePUpglhuTj/vVxJAJrtQ1dvdwT2eiJwxaVh942Hhug5VuX4RW4oq3+1Cq9WLkUZJ+PlkwcYa0msNHWd2gPo9kawjpW5frhiUvDXOguVmSlNvP2zidtTf+MlfKYfMPNfyU5uvnPDCOcQdiShQ36qIeHOHG9rlnApY0S2xgdIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438204; c=relaxed/simple;
	bh=sTsecvNXkhcVyTVP9ttZ00W5t4Qdik6fBy0vnK1pQHE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sjXVQDLk4/Q+lcF2VVHtlZ4PmqfzQ9DhawnmaaAB7+fv/ivnBwcwG5syt0xqjJuxRv1RoFQ8X/gzzKefOwz2rrrtlK8xFCZ/cvnSN02Tpeo/5DSEcO0e/3Gd/T8BkbV1fdHFGlqQKKTGrjnyIoXJayfoCetFSSFyfgDghPEf+kU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dsrf0bxj; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dsrf0bxj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743438202; x=1774974202;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sTsecvNXkhcVyTVP9ttZ00W5t4Qdik6fBy0vnK1pQHE=;
  b=Dsrf0bxjFMlncRGpy372csKDhjPeIZbi3Y6f7pv73VzLZJ9gwmSu0p7D
   kqty6okHjGqCP36q8DMvC041YPKW+iY4qg05nV2ktFi3t/cdWVi4VEPpG
   zyC1zN43bC22RDuYdOyclhbiM0D7LZO4UtD+z5f0frqNAv4AYr1Ev+5nE
   iygrSGUJ+Gz1GfBypK6GywX+s0VmZRuIq4vsJsCf4fr44W+aj7U9uEXaa
   f9NZpSatl4/LoSJoBz9cDoMgj0NLrvs8rd033IehxhM6eR5uJF+H5iKJj
   A7lqcJyjSTL4x/jBhfM//Cs/HoFCirGQmMZ/Tzq4DsF2awt4xqKxBXJQW
   A==;
X-CSE-ConnectionGUID: wyAkc0l6SamAujMpMUJxxw==
X-CSE-MsgGUID: 3cioOsR2TkWu3lRUo+GVuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44889922"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44889922"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:23:20 -0700
X-CSE-ConnectionGUID: M6IoJoCKSXuumv5g0TEf0Q==
X-CSE-MsgGUID: XhhmRfP9QS2+AOrFZyJnEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="126132818"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:23:19 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 31 Mar 2025 09:23:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 31 Mar 2025 09:23:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:23:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKqiIYfPkuMs8syDmMpEU3NW1ZlopwWOXM5PWKH5S8lK0CgUg6xyJ3O+Dmh0GzYxaK0RsGsqXwdKR5f54QcyPSNJOwgCHQa+UcacNVwEqxfBKjeEJVFQtt3CgdBUURX3G1zKCHqzEHatSaFcO26C18ezRpqfth3T6E5i0TUPIo7d+5TGvEFWJZ0ByH/ycc1TPBqZyVnXnsb3DpPbN2DyCttuma8OmgpLgcTNZ3hK09jWMTBKteJhxK/KdcLfugr5Vq3KArA+N5BvHWAZdJoFCLTCvnJ/EH+ouEDPRGw/frW3evPEcUaeI7s8aSKJwP4GRZPCkbnf7ATvweeFgvFE+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=virB1vKpppR8eBNS0VrL9ilpozf4lzMsw0ciZqsgEgo=;
 b=cEGREL9tEd/wV8W7oDjxleNs53aUtulQWc3xMUh9hFgyEgSEBs4ASBwP/8w3Pzs2Evhe2S569e50UQVaJ/uJnMuZVywdHSDPRsqp81l8+Mj37STJmDBqAe0QLJw/unsir3YA0xij9fb8nzWANeGS67MsY4yMf+gl6Cgbn1rZmeu+0BxH5sL/ZA/RcnzN2IKmRz7OCWUL1QB9mIFwLFu5i0n8wsuBw1a3BGIuvD50H2yQsiquO2/HeSSbnRLKpMVAi5VBuBUfbr4eUCK3RIAb1kUWoqJo2l9JQr8Ua5ZuuTCIhcXlpe4ENVwaDCl5WaVxwpK8DE9cmobtJM0YqnwWEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:23:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:23:15 +0000
Message-ID: <10df8cbf-3b7c-461f-8a0d-bcc6b87444c0@intel.com>
Date: Mon, 31 Mar 2025 09:23:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/16] x86/resctrl: Link known events onto
 RDT_RESOURCE_INTEL_AET.evt_list
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250321231609.57418-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0272.namprd04.prod.outlook.com
 (2603:10b6:303:89::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: d00ea600-1744-4435-0e0b-08dd70705720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dzh6eThSNnZJeFlaLzVjd3llbC9JdnE5QlpUZ1k1a3ZqTEtqM0o4TStTRVhx?=
 =?utf-8?B?dzJXNHNkejdtcFhveitlU0RGSlQ5Uit2RCtRR08rL1hSUEpuSkZjcXdsaEs2?=
 =?utf-8?B?bGdBSGxvbGZFcDMwWnA3M0pTdkZYZDJoczM4REZqZitkaXpyNFVJUVFjSHNR?=
 =?utf-8?B?SlIzcEo5Rm10NjdWcjFXY3paV0VsRDNyTGNWb3crTUxHVXBONS9FZnFldThn?=
 =?utf-8?B?RDRIcVBQb2wvZ1IvcEdTUVdaSUM1MWRTWHR1d2lHOU5GOG05YW5YbkR2TmZI?=
 =?utf-8?B?alFiN1I1ODlTWmswY3k3NjF2RjlMMTVDeCtFemJpbjRjeGkvV2FXYXp3ZnMz?=
 =?utf-8?B?M01TM0VZdWxLSUhiSkJuZ0JHWDhlYnltNmdYQWtGUjZSUG0xWHdkRWxtQzVI?=
 =?utf-8?B?Y2tVTW8zanlwMDcwNy80UThrV1h6WkJaZWNHcDhWK1Z5YXBKczJlYWpnMXNM?=
 =?utf-8?B?a1RlSDZtWmdSeUFzdnYvTk0xY0k3a1ZUZjFwT3YrOWgyUHNqNTJ0V3dKeStu?=
 =?utf-8?B?YXF6Y3JZUDNWVWRuNXFNbWlheXJhcWJCczJsclhaTC91NlFWU2JyU2xrSE1D?=
 =?utf-8?B?WEsxWW1aRmZxcUZNeTRHYjlWd2ZvVjgxVTZUNWM5SCtOOTYyQU4xRU9YSXcw?=
 =?utf-8?B?OEhGejBwNXkreExrNmF6WVFuNzcyZFozRCs2andxRnFPUEpPbVZFZnFRUGhl?=
 =?utf-8?B?eFl0eVB2dnlqYm1ZRE5mU25Ya3VtSmVySEZUWHFIU2dhbnBpTzVQOWs5VjBW?=
 =?utf-8?B?bEZFc1ZiVkk1dnhVazE3MEZRUlFKaVRBRzdEV2ZGSFFlMUFhZWM5MHpzMEZV?=
 =?utf-8?B?N1FEa1B4OXBsR215eE5IekJRcm84N0E2Y0NBSURIYWlkaU1SQmV3VGc1cVNT?=
 =?utf-8?B?aHV5RGh5S0lrQUZ4ZjQ1dldCRElyRzdSOTdFM2lpRmFYcGJVb0FneitIMUVO?=
 =?utf-8?B?dU1hT2xJaGtDSER5Q21HL2FaeTdPY3JqZjdTTGRqbEpSSTQrVkpFc0FBWjNp?=
 =?utf-8?B?SmJBVzM5T2hieEEzOVJ1S29iSFdFaUk1RkNwTWdkci9sYUJhRjFiNUdsbDZT?=
 =?utf-8?B?d1hqWHFqeGxDanRDRlYvT3RJV082VU9raW5lZ3pYNEhSTEVWenN0enhHZldy?=
 =?utf-8?B?RmovOEdZLzZwNlp4UUxoaUZwaTBQcXJCemVaSXIyS1RaNVVPMkxPOWlLQkx1?=
 =?utf-8?B?aC9jYkNFbkVnWkVOZXJ6S0hRYjNwV2lFSXFBdmpjMm1TMVN3Ykt5eDF2cFFi?=
 =?utf-8?B?ek1VVnJkUG93cHFGSFJWMFhSMSs2OVMxRkVKb256S2lEZXRwV2NISmtUOFFr?=
 =?utf-8?B?R0lieWpaay9TTmg2Z0VNZmNjdEdEYTlWeVlONzBsdlUwRG8wODVsUGsrK0JW?=
 =?utf-8?B?Y1h6emgwUDZtN3ZwYWw3QjFqTDhLU0ZNUUhKWUtoOXVWQ080REw0dVZGTGRT?=
 =?utf-8?B?OUdtenVXeDZJVmx1Zk94R0k1ZTFpa3BncmxGcTJFdDl2Ri9NS0pxMW01dzc5?=
 =?utf-8?B?UEZQWVlha3dxOVdXSjRtdldVcjdGMVplWUo2V3pQVHVaZzF5R3pTSi9VeEdO?=
 =?utf-8?B?bm9MY0ZaRVFQbTVxV25LZjZ2c2dWSkYzSmxkdVpsR0hlaGZOSDErU3d3TkRo?=
 =?utf-8?B?TkZyV3ltVGdHOU1HK21MMmtsbU9kZlZyc2VwaDVUU2hHb3VWdnpuSXoxbk93?=
 =?utf-8?B?elJvUTJyRnZPVTNnMU1icmppd3ZjNGVIMHFqWFVuTTRFWWFvVkIrTDNZamJE?=
 =?utf-8?B?U0x6WVdQSllEeGlBU2s5NVNmZjU1b1VNT3EybWY1ZTlMa25TUE1KbWN2Ny9a?=
 =?utf-8?B?WSt3OSt0YmhYbE5XK2VwRnI2MWQzVnZLS1J5Snl2WWx5YXBkUE5NUUxSZHdZ?=
 =?utf-8?Q?FSnOMbjSgQl2a?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzBRTGlqNnd3dEFaOTZqZHdwdXFjOEZtNjVjLzhGMUhjbGsyYmlHWElBNVNQ?=
 =?utf-8?B?WnlZam8yaXo4ZzFiTDlWc3k0RjhWT1h0dWExOUpZUmJDN3JyaHl6SnFvSmRF?=
 =?utf-8?B?WDBJRXhud2FOc2JRUHpPSCsxaWZCNVZoQy9zSzBpVnlVMnRYSCtzNFdmUEVR?=
 =?utf-8?B?dzNaaWptZXJyMUNHK1krYlhLOUtVLzZRSkRZbXgzeFM1THFKY2U0ZFhnRmQ0?=
 =?utf-8?B?TytUQ2NiT3RaTVRIcVFzcnhWSXp3TVltTHg0aGt0Sm5WWCthNC9rbXNtNDQz?=
 =?utf-8?B?TzNLQ0xTZ210Y0FDOUp4R3MxYkJqSGtBeHBNZ0VlVjBCQzNIc2xnenk4YTdU?=
 =?utf-8?B?R2dnSUpNbzJWN2piVGwxNGZJNG55cWcvRlc0Y0UwN0pSdVByNWsydVV2T2Qx?=
 =?utf-8?B?L3dJa0tPUjFnN1d2azNTQklQMURGZmdXVVpNTW8veUxqRzcyNThMVWIzbUp5?=
 =?utf-8?B?bjVwWU0rdlU2RjVrWS9oRnNtUXNxYzFWN0FlV1p1b2dYTG9lcExDdW5EZUVE?=
 =?utf-8?B?c1dWRnFMdmh1YTBudDRBcVBqM3JOaE1UMk5lak1qQzlQelExU01sdWVMRGxC?=
 =?utf-8?B?Q1ZGVWZhUk1ZNjJSSWxQVmlPYWdPRVdRM0NibmZWaDNmTGRJTExvY1lvNnFB?=
 =?utf-8?B?N09SNFZGSGdGRCtaNGl4aVc4RjVra0Mrbjk2SlA4dEZodHp1Z3JLd215cC9i?=
 =?utf-8?B?aWtXV2gwN2VEMEZpUkF6RnpxbURjTHVLUWFzUTh2WmJoL3NSRmpEMXB5alN1?=
 =?utf-8?B?VnhVNGhhTEo3MFl0cjFBaUQ0bEhENmpLSm9LKzhWZDQxZWh3VTYxeXRUVzJM?=
 =?utf-8?B?VzFxdlBqbStvZUZWT01VclpFVGJQOGRUallwRjBWaTJidE90c3dnNWlVM2l0?=
 =?utf-8?B?NWNKbkMvZ0hKb1psSVl3TjdaMVcrY3ZBRUVpeVgvYzBZc3FBcDVpQzAzVWZY?=
 =?utf-8?B?Q2QyNXB2L1ZqaXo5dHFoclMvWldQeDRQVHMrdE4zR2pmTmNrNlBOQlU5eVIr?=
 =?utf-8?B?d3FaK3N6VkV2dnNtQnBLOWxFQjRWRmhQQWNzL0VrRVUrckRzQktaK0lpTUhD?=
 =?utf-8?B?ZytZQWNnQVlOTHVNc0U0cWpuaUYyTi9OLzhxWHVxSzBseFJUU3l2dEluSEFD?=
 =?utf-8?B?NGkyVjI5MmRJZEU2NnRzMy9lRXZJUHFhWXpKMjV2SGY0NDRyd2JMaDlHaGhj?=
 =?utf-8?B?OHFJY1JZcnlkZVhldUR2ZWVvQzJwL2VybVJQc1R2MWRJaUQwNDV0TTY3TkFY?=
 =?utf-8?B?cVlLYXNhZE5LcUY2OXYvU3N2S3VBeVo4cW1ydk9aajdLWXk3VWZNTGdWdUZV?=
 =?utf-8?B?MGJiR0Z4UkxLaWdlQ3lzTGxyM29xZUxYOTJvdE1iNDdxMVdJTm5FemNtekdh?=
 =?utf-8?B?TlVLVFlTMldqTmo3MldTQk5iMURjMWZnWWRFeWpJSkgyWmdNS1N6YmhEZ2sx?=
 =?utf-8?B?R1dhNHc5VVpTR3VvMjlGQ3dMRzh3eWM2eUdzNHJpSTJ3c3UyeCtXZEJnVjYz?=
 =?utf-8?B?TG5sOTNGaGJrdE9lcTE4V0lvMlhpTWJEV3psbXErY1Noa3NSSEdYdWRqN2Jz?=
 =?utf-8?B?L0dqVnc5emo5SFN6Y1p6elNDRzJhRGJVeEJ4dWQxS1U2QlYxUFZHWUw0Y3lO?=
 =?utf-8?B?dWlPT3ppMmFZRW5zUlJ4Y1FvWHZDMVgrL0l0UHA0blcwSU1pemtZVHorSEN5?=
 =?utf-8?B?SkE2VEhMOU5IdU5KNjIrUnV1VVUySTVGWFByaGpLOVBnSUtaR0dpdllQM2E0?=
 =?utf-8?B?cFp3RStHS3pwa1JhZm9zY0hoU0RXdEJoMERqSTgwc2lyK2toSklEVGgreTlO?=
 =?utf-8?B?ODVJQjdRMFlvWnlMbXZ5N0FLSDQ0eXUrWS9jSUIyTXA0dmZ1QUdPcGxrUkJH?=
 =?utf-8?B?aG1QM1AvOHU1TDJGSE0yL2ZqRkJFenQwNFViYWJGMFkyU2ZWc1pFM3ltSmFQ?=
 =?utf-8?B?NTFERElJSWsyQUppeCtXQTdtVGlBbzMxNnpDS3k4Sm1hQXNpMWxQUkZzV1RC?=
 =?utf-8?B?bklYZnRIMGJXb0lMUTh4K1l2dVlhRHNLSEhEa3FNMjRpVTFDOG5xVUN5dGNu?=
 =?utf-8?B?dlBqcEdKQVB1Ty9zbm1RZDF4OElwZlpCRTc5V3Z0a1RsTEIwcVJRVHBkS3Q3?=
 =?utf-8?B?UzhrcG1aVXQ1UXB6K0ZaY1MvNjFHdmdobGxsVnJxWUhxeElzUFpPczhKSWJG?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d00ea600-1744-4435-0e0b-08dd70705720
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:23:15.8404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIF4ad5hd4Ja5UpYVmM4C3aGEixMnTKXzk0ks6U91GHy8zwy+DknEyBsml5KTahiHc2Nlrb6xgj9f3KCjWVnRmVFDK9ODyLgs1PzspnY3ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
X-OriginatorOrg: intel.com

Hi Tony,

On 3/21/25 4:16 PM, Tony Luck wrote:
> Core code uses this list to populate "mon_data" directories.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index e2d8eab997fc..9ac912742ef1 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/cleanup.h>
> +#include <linux/minmax.h>
>  #include <linux/slab.h>
>  #include "fake_intel_aet_features.h"
>  #include <linux/intel_vsec.h>
> @@ -308,14 +309,34 @@ void rdt_get_intel_aet_mount(void)
>  {
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_INTEL_AET].r_resctrl;
>  	struct rdt_core_mon_domain *d, *tmp;
> +	struct telem_entry **tentry;
>  	static int do_one_time;
> +	struct mon_evt *evt;
> +	bool ret = false;
>  
>  	if (do_one_time)
>  		return;
>  
>  	do_one_time = 1;
>  
> -	if (!get_events()) {
> +	if (!get_events())
> +		goto done;
> +
> +	for (tentry = telem_entry; *tentry; tentry++) {
> +		if (!(*tentry)->active)
> +			continue;
> +		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
> +			evt = &(*tentry)->evts[i].evt;
> +			list_add_tail(&evt->list, &r->evt_list);
> +			ret = true;
> +		}

Architecture code should not be doing this. I expect this will be something
similar to l3_mon_evt_init() done by fs code after the architecture had
opportunity to configure which events are supported. 
I wonder if resctrl_mon_resource_init() could be moved to rdt_get_tree()
to be called after the new (yet to be named) "resctrl_arch_for_arch_to_do_needed_on_resctrl_mount()"
resctrl_mon_resource_init() could be enhanced to do any needed resctrl fs
initialization for this new feature. This will include being able to 
learn the accurate counts of rmid supported by the system to be able to
create monitor groups that can be supported by all monitoring resources?

> +		if (!r->num_rmid)
> +			r->num_rmid = (*tentry)->num_rmids;
> +		else
> +			r->num_rmid = min(r->num_rmid, (*tentry)->num_rmids);
> +	}
> +done:
> +	if (!ret) {
>  		list_for_each_entry_safe(d, tmp, &r->mon_domains, hdr.list)
>  			kfree(d);
>  		r->mon_capable = false;

Reinette
