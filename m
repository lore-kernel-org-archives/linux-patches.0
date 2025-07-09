Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CB823E344
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752102004; cv=fail; b=nOUxH8YL5kdTUSdkQH/zG+KI1GzboV9raqjqkGU7dxiugPTN+dx7jUokIqRHTbCal7tmjUx/K1zeE+9c+rokxBxDflg1WwfDtLXdONholxMgpPqUNsKm+iouFyW/IhVH3F1tYsunKKRbshiHUdYwMmxwMbiDxNpUIehrmP5UHxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752102004; c=relaxed/simple;
	bh=3yJhKw570kbGSLEWlIM/HYeVec357P+7+DTxQ5/icHI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QTaewJKjEk7cX92+eI4YV1CPqPKsIr76vCGeunSt07YNn4rqFzS0uJhoxB3SxxWg8NF/vrLu5bvDn3frX5Y4Jfn5a5JW/TFXosPxOyDpHd6RHGW3HzWpK4bZA/BMXp64LYry+Yilb0n8TNRF1jh20JjXBRlGMxPMgee7PLYiEOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJBDTzC1; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJBDTzC1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752102003; x=1783638003;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3yJhKw570kbGSLEWlIM/HYeVec357P+7+DTxQ5/icHI=;
  b=GJBDTzC1ZlJqEpFekZpMFT/VxhI0Daw6MXN+wHPQCDc7TP2DLnw9+5br
   byw6bSpAcVspGuIxCHLkQBDbW09dTRLd/5k/Z6PY0uwkRbxQKhZC356ln
   73k03SZl1O+o99B0je9QuYAXD0KdFYRlMVaBiK8dV4U2Jugii/6sJp/U7
   /R/alGygFHU0a2s1YaNdSrmrudvCTkihRrzkLcU8amWHRLMLSaHv/xpRM
   WMjpN5p9MaCugkbB2ZABX9HrUvAGT4aBTnYzgn25OgLL9kGqWBfHt5hxn
   RAyuJHBVo0YBcmkyCSKx835fAa9K6iDxLfBU4HOvj3DM8sgEA2QU7ha+e
   w==;
X-CSE-ConnectionGUID: 4dlKa7EiRJi4p0K9ENNzVQ==
X-CSE-MsgGUID: dGsQlJP4Qze0DOLoczBglg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54505675"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54505675"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:59:58 -0700
X-CSE-ConnectionGUID: izPu+1g3RTWFl6L7qpLS+A==
X-CSE-MsgGUID: uBn/M28OQiWrK6ACjR6Few==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156235145"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:59:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:59:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:59:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:59:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gWAJWg6ZIkfa/tlFUMERwhAVG53VNu7oZwre7ZnJSw2YrrreLTOU7Bpu1HXiBBqmm55Se7Dz4DrdqP2XaA3NNOc8u3n1tIvVNrkSeRoc8Or2vYUlh4ge4/CPmnZPO0fQHPKgOAkPFUjLQHgSQg/2msiktiiNwiFBya9QQf0xgedJQH3wdorPy+dzxyeaME0WPvgTlI9qyVSdcgVtekAn1YPBDc16tgvS0vw71esL+cwa9Jvo/DqrcftJxSt3k4tbhI5VBR1c3U3JHkUf4dTofJMCOqM79GVQtixBoIDrbDwbYUyhGzl7Chnyef4GUHMXrm2p5qPV3isjIetFLJ8dkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7v1bz8LQNlDmhS77x3a+onKn1nSTsqzuOtJFV5n8Qo=;
 b=Rf1x9r2gWDw3TCWagTXc3LtnEtm3a1Pw/cpRSr4KNQyTHipIzC5nJJQ8CpLHk3m5CM9XzmifGUdQvqDG0Vl3lQAL/LnA0ZmbnbkRxtK8tdsUDRqDaZ2a3G8lv9duV85NSS5GPblSYgthH4S40cFD8g0QXB7tLgSgMiIYVcpWcm2wOBnat08NbuN3+tReA7V7seDo/2xy+B7hT3Q535mvTgce54IwT2vnITPCkvrAHFGjSE2lBChiYdiGakm/91nJycH1xUTF0NvYdpafrI6ckFwOvHxg88A0cIn/SeXbMEZxnIQZ0jHPkuVFsdeEr3/GIiGiwuMYkACmh96nFcWNWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPFE94346F35.namprd11.prod.outlook.com (2603:10b6:f:fc00::f59) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 22:59:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:59:38 +0000
Message-ID: <f334442b-d0d2-4584-a10e-76c703305350@intel.com>
Date: Wed, 9 Jul 2025 15:59:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators
 per package
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-19-tony.luck@intel.com>
 <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>
 <aG6xGGiOy3xKL-t4@agluck-desk3>
 <74a1e5f0-5484-4952-9a61-7a4e5b96b707@intel.com>
 <aG7xxIzTZ2hAVrxP@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aG7xxIzTZ2hAVrxP@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0255.namprd04.prod.outlook.com
 (2603:10b6:303:88::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPFE94346F35:EE_
X-MS-Office365-Filtering-Correlation-Id: 1573c399-8835-4999-0b22-08ddbf3c47be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RFFFNnlHYUhobVdiZjFNVk1idlI5OTEwMi9vQ1AzRHE2NUdoUHI4WjBwK2dn?=
 =?utf-8?B?MVpaYmFnSC9LSjJLcHNqSVB6cXZqVHFzbm5lMmk5bWJDWkhYZndpemVVd2pU?=
 =?utf-8?B?aWVQUHNFQW9tN1MybHhTNkJDWlllV2VDTmFmaU5wTk9hV3ZKUVViSmFjZ1dU?=
 =?utf-8?B?VDZjYjA3MG9YNk1sUE1CeDJudUQwN3ZSSVZkVHhnSDdrMURBWFM0WDJXWTNk?=
 =?utf-8?B?S0U1OUlEUkNDczhJMFhYRytEWTcvaWZSaEdZOFlNa3grQU9sbUdJSzNJanpz?=
 =?utf-8?B?eWc4eFJpbnAydDhtRGxqYXJURzZzdjVIRFBib0dOMjlNeVNaNzd5WGs1dHEy?=
 =?utf-8?B?eHNHWXNvTFpKZENPcGdOMWJ5aFUvaFYwS01xdHN0UnlUbjlSOXBFOEY5S3lp?=
 =?utf-8?B?M0hIRUQ2NGtLdmZsNm9Ubmg5OWlmNjM5cUJQZzF1c3lFdS9MelV0MFdESElC?=
 =?utf-8?B?Nk05ZGNLcXp4ZjR3ekZCQkdZQTlwYTZEZk1HNmM0bnVYWmd6QmdRSTNzaWlU?=
 =?utf-8?B?ejFhSDcvT3hNOUNiVld2T2RFazdUUVZyWVhFdDhFVytBU2RPUlptTUk1Z1g2?=
 =?utf-8?B?b0pVL0Mxc3NWTFlkT0N1eHlEekVQbVpRZUVRbm9yWE9wSERSc2d5WEZybGxu?=
 =?utf-8?B?Y3BoeEhyRUdEMmtQM1hpWDhzYW5YbzE1ZjBCVTR3d1dqNVFaQ0FEWGViL29h?=
 =?utf-8?B?TUZsUnhrWkpSMTVSRWU1OW9EMjJNMlgvZ3JHR2luRnRPYTNhQnhtc1RSMEZQ?=
 =?utf-8?B?NGpXSmRTdFlnUVVHbTBscFJkajJ2KytNZVNnUUV6REd5cmNPcTRiZUQvYjB1?=
 =?utf-8?B?ZlArWlp6aFIyZUR4UllGZnFBM3VRVWdNUmlWN25EU3ZkMkpGNWJHV0VGek9J?=
 =?utf-8?B?TVpXMGNYbmFySUtpSDNjNlo1V0FUdTJFMldsYU1McExITStTWGFWNHRYWFNi?=
 =?utf-8?B?dG5aejMwbUliK0tjQXRGYmg2K2lQSVJubjBua2pWeXFPL2U5QjFUL0ZWQ3Nu?=
 =?utf-8?B?OXJiRkxwNlNMTjAvNWlXNVIwVGtmQWYyNzZ0YXpHNmFUSHlHRHVyZGlLY2Nr?=
 =?utf-8?B?a3RqUEYvRWxqeUdPY0xaeExpb1BvN0tGbkZwdGU5TGs2TVJ5L3dUeUJKREFt?=
 =?utf-8?B?bnB6WDNnek1wejdPcFZaTC9JSlNXQW50NmxuVVRhdnFUOTFYK2lyNklWSFNj?=
 =?utf-8?B?bWhQNjRsQzI2VnFhT2ZuL0J4dWlRZ2Z5VzVlaDNSWmhVdjlKNWFiV3ZRWlp0?=
 =?utf-8?B?UlM0eFluTkRPQ2JQdmlLdFIzdWF5VFZSbjZjdkZMdkI0S0NybEYrN1M3MUhy?=
 =?utf-8?B?MjZxTUdTcFNXQ0QxbUt3VmRjRGVVMjN2VjVWUmkxcWh4VTVIeFFqdXlKNDgv?=
 =?utf-8?B?dFgySTBRMkhPRm0xeVVwTFFhZXVsNzQ5dGYwTldvM1krOTVRZmVsWTdpSXBJ?=
 =?utf-8?B?OTN3WWhTbWN3M0VUV2pqVGNqMVlDS1phTTd1UC9SSTRrRzg5TndVUno5MXZN?=
 =?utf-8?B?bndpa1NuWjVINzVCd3N6RS9OR3hiMUxrTkhMT3J3TEZQMDFLWlR6Ym5HdVJx?=
 =?utf-8?B?VEF3TWVZY0ZVbzFNeGdma2dEZk5BQUE0TE9Hd1FyWG5WRk5xdlpGTWpLME9W?=
 =?utf-8?B?em1Mdy80OXp1ZkRib0RBYy80L0NXUm1mWE96YmZ3bnQrY1Bkb2lNL3ExT0Ju?=
 =?utf-8?B?VUNwdUdhbWVQQjFPdFBoK3VVUU1BbVYybTNQeHA0akt2YmE5UHBRdTBxOWxx?=
 =?utf-8?B?MjdhNXVHemlUdU51UWxQb1lsNVFVN3EzVzRPeTA0U0c0R3orMzlBS1dXTHkz?=
 =?utf-8?B?ajhZaHQwODVMcW0rTEJXSkhMY2x3V2JDTFkxYncrbXlpaC84SjFmN2lqci9F?=
 =?utf-8?B?Y2VyajdYdzc3VWdYUTVFbUF0OGhueitFMHRXWUtpODVDbnQwSVRKbnZESVVE?=
 =?utf-8?Q?E61F5ZcVOPc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yi9PMGhkRTJ0Y1ZiYnJoVmhSOXdQbHJ0OEtZbU51bXBSV2JrcGIzWUVUUDhj?=
 =?utf-8?B?MWE5M3BrQk4yUzN3KzlSSGJYZzVsbmI5YjRsNUlCZGlqSW1kalNFL1pYN28w?=
 =?utf-8?B?Y05QQVJGOEtjYzBieVJoY1lQZnl1dUZZQVEreW1QQ29rRXdZck83dDJ5TUp2?=
 =?utf-8?B?elJuYzBIa2t0WmhpQ1AxaFJiR0hhYlRvTE0rRVZ6cXhrOSt4bUJvT3E3VDVQ?=
 =?utf-8?B?WnhjVTRZSXVFS0RvWER2UE5xWU5Wa0tkUkdFNlVINitET0ZaYUFoK2plN29O?=
 =?utf-8?B?ZFBIbXZ6OEs1VzRURHVLSTBNUUhPQWpRcWkzdXMxc2VobXpkbTEwVFVWOXNa?=
 =?utf-8?B?YTFKeXk2Z0RNQ1ZOVUtqdnFOWlFzZ0doZVRMNzNEbzVsU3lqdDIwSnF3QVEv?=
 =?utf-8?B?dmdHUnJFd1ZZU0pQMkVaU2tNdnhDV2RiK3p1M29sSWRXbjNYaE8yL255blJ4?=
 =?utf-8?B?WXZydnRkdVhUeWZ5WFhCOHEra28zMU8zcFkxRVNRbzhjazhqRHh1OEg4aWky?=
 =?utf-8?B?YlExRkc5M0FuQ3VjODlWbFgyRlRkZDlBTDlhdmkxRmN6d0VEbEFNV0FmTk5I?=
 =?utf-8?B?a0cwOHBwU2QzOE5nYzlSZndTZFNNNjdrRmFGTDErUFhvOTlZK3BBdnBPRG5Z?=
 =?utf-8?B?STdyVm1lT2dEOFNldno4dnZ6Z1pPeElnOGl0dGFZWlFBcHlRK1BjK2xucVpo?=
 =?utf-8?B?YXVrTHFhU1V5dHR1clphclRJMTQ5em93aDJqTVBQU0t4d216eDJrNnoxd1lv?=
 =?utf-8?B?V2lZVHZFWEpnbmpKa092UnFRaExrTEVIVG5BMlRQYldTTy92WUtPMW5vUEtr?=
 =?utf-8?B?YUVQbFRJREhacW9hanlXbjA1Qi8wN1dzSlROOWwvVVltcmU3UzhlVElpSHZK?=
 =?utf-8?B?cy9NUGVZaUVSZEhOMDJlRDI0M2JIMHFDSm84K1dhZ3kwZG96WnBpYkZWcjBM?=
 =?utf-8?B?WjlFR1hPQXFjU2I4T0NhUHl4Y29WM1c4WkI5c3RrYTNtU1haU29lcEhaQXRM?=
 =?utf-8?B?VmxjQ0JXbkNyd2MwVitCVUdKOUlUcE9Jdk52SCs3MHJOVXh2Tk1Wd3JBQyt3?=
 =?utf-8?B?OW5sWmtnMWNqR1dwSSs0UWcvaHVrbVhkditaaEpTQVBYZVlBL3NoRitTNDRD?=
 =?utf-8?B?d1YwQkJ3UlhSanpmRG53NlRGbHZoRkdjVTBPY2RjQUFSYWxMSjR3SEpiK0cz?=
 =?utf-8?B?VTl6NTJIaUllYXFDQWJhRnd1ZmNKaE84alQ0UzBXOTNZbE9xWEhLTFRxc0FP?=
 =?utf-8?B?eFAwYy9ld1YzOU9ORDVDZzVxOHg0bklYQ2xnMUJlYk1HcHVTV21Gcll1OUlE?=
 =?utf-8?B?SE5vRklFVVhFWTNKQW5LUzllRUhzWXFXdWhXQW1QUUxCRGxHNEw5a0ovdmRq?=
 =?utf-8?B?T1ZMdHFqbjVLaW9SYmNncUd3bFNtRFBRWkU3ZkhldXRWaksvZmtmZzZqM2Q1?=
 =?utf-8?B?aW5nWFJsVVhHbEJpMkVja3FiL05WaFlGTmVTaDZiVTJPeDRScWcweitpeERi?=
 =?utf-8?B?Sk1kUzRnc2lmaU5kWEl6K3BCWVNuU2lFMWdONDMyYkxZb3pDTkdKRGR2K0VJ?=
 =?utf-8?B?aUtDRGpXZ0tNYWxENHdiT2dvREZXTmVmczNyWklEdklFT0x6NzFxYW44b0Fv?=
 =?utf-8?B?cjIxdDFNSDJTMWlhM00rQlpFREFNWGpxOVQ4emg5Wi9GVVJ3ZmwrQkd5VG53?=
 =?utf-8?B?SFo4eWlrZ24rU2hYZ0VwWHNCUEhmTHRYSHh2bG9LaHpmWUV3SSsyS0QzWHVa?=
 =?utf-8?B?SVF2a0pHS1Z6RVIxT3pBRWNVQ0Y4V0haRk12OEI5dGdEVnAza1pLTXlRS2VZ?=
 =?utf-8?B?cDM5YVdPMFVkYmJpdDRUWm5JZGN6OTlwU0ZMNFN4dkdiMUhsMzc3eW1iVGNn?=
 =?utf-8?B?RUhibHZERlRaRXg1RTJzOWhKWEEzZmhuKzFYNXUvTDZJYVVtU1Q0aEVIU2lP?=
 =?utf-8?B?dHJkTU1PbndaeXkzcWZtOHNTaENDcGdGbE9rZ25Dd21qL2g5K2p2cHh2SUUr?=
 =?utf-8?B?b1hRb2dpem9sbzRVK3ROdStXVFVoazRqSkFsLzBhMWt1MHU4bkxCdDBYUmIz?=
 =?utf-8?B?WS8veXg1Q0hLYzdLTjZqTDFxR0dlWmxxK1JxbmE0YmhOR3VqV2JicHh1aWNa?=
 =?utf-8?B?ZlBYR1lCUmpWYTkyWDJ5VXdWbHBCZjJPRDNqNERtTE9UQTl5OUhBOUVscjBR?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1573c399-8835-4999-0b22-08ddbf3c47be
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:59:38.1159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yrzx3qtv2irlQiZXRb81rQtlD/XwipLYfWaQnk98U/2w/BtjX6VIpJ7J1FEdYEWONufnXruyXc2bF7QSxfOo9pfbp5F9vUigS1wasCvuPKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE94346F35
X-OriginatorOrg: intel.com

Hi Tony,

On 7/9/25 3:48 PM, Luck, Tony wrote:
> On Wed, Jul 09, 2025 at 03:13:20PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/9/25 11:12 AM, Luck, Tony wrote:
>>> On Tue, Jul 08, 2025 at 07:20:35PM -0700, Reinette Chatre wrote:
>>>> As I understand there is 1:1 relationship between struct event_group and struct pmt_feature_group.
>>>> It thus seems unnecessary to loop through all the telemetry regions of a struct pmt_feature_group
>>>> if it is known to not be associated with the "event group"?
>>>> Could it be helpful to add a new (hardcoded) event_group::id that is of type enum pmt_feature_id
>>>> that can be used to ensure that only relevant struct pmt_feature_group is used to discover events
>>>> for a particular struct event_group?
>>>>
>>>> Another consideration is that this implementation seems to require that guids are unique across
>>>> all telemetry regions of all RMID telemetry features, is this guaranteed?
>>>
>>> The guids are unique. The XML file tags them like this:
>>>
>>> 	<TELEM:uniqueid>26557651</TELEM:uniqueid>
>>
>> I interpret above that guid is expected to be unique for one
>> telemetry feature. It is not clear to me that it implies that the guid
>> is unique across all telemetry features. For example, what prevents
>> a platform from using the same guid for all the telemetry features it
>> supports?
> 
> There are several non-RMID based telemetry MMIO regions in addition to
> the two used by this patch series.
> 
> Think of the uniqueid as a signature for the format of the region.
> Which event counters are present, in which order? How many total
> counters? What is the binary format of each counter?

I understand this.

> 
> Or think of it as a key. Usermode telemetry tools that access these MMIO
> regions use the uniqueid to choose which XML file to use to interpret
> the data. I'm effectively doing this, but without including an XML
> parser in the kernel. Just distilling each XML file to the basic
> essence described in the event_group structure.

Right. If the analogy it is about ID used to pick the right XML to use then the
question is whether the ID is unique per directory, i.e all XML files in
RMID-ENERGY directory can be expected to have unique ID, or across all directories,
i.e XML files across RMID-ENERGY and RMID-PERF can be expected to have unique ID.

> It would be a catastrophic failure if Intel assigned the same uniqueid
> to regions that had different formats.

I think we may be speaking past each other. New code will address concern
anyway though.

Reinette


