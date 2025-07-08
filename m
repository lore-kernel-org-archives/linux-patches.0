Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C482066CF
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008156; cv=fail; b=uPrhpwAqjmIGaCNdyI/l6Pep3kYjXbizsNEG7I2a8YY8BtSi92Bf5Ei81OBZKVSOZ5u7BEW6bkzYjqhPqBJfC2qE3p38VHMhi61Vh/F9Of5M4Erz7gxKMy5o4cV66aBYWLMz5JkSrI6FwMZd0YlzeiotQLNnvjpTIeVnNpU36nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008156; c=relaxed/simple;
	bh=JWPHnlcfYY1/ArI6fwpYDcpYcWlibNTsPkmuC/K1Q1w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iL9e39my9l/kW2lS7ZUAQf17ydhgXXFBHfdaGuu478YtEcww4p+JGNQHwswybYzrkI1tTNI7dBHQT9zhN0r3jjzsms+q4J9TLdfFpFT+hGQ1E/zO/+bisVPKXEuvVPMlYORxg+pPBAm7/du4mE7BdtryLGYmjrkddUa/LNbdvrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JzcZwPDu; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JzcZwPDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008155; x=1783544155;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JWPHnlcfYY1/ArI6fwpYDcpYcWlibNTsPkmuC/K1Q1w=;
  b=JzcZwPDuttbjcCKPxc/H7sWOFk6frPAXkvnaF2ZX0bmyYFafzuGvHdhI
   m1J31vsWHNq31f6XEWC16TIfs/+KVMXzlzPtyoR6RwBLCAbgnNlrso3nM
   Ivgn/tpurDwFO53jYQO+/hlTZuHK4H2w4wS3LRvZd+zh+APhg9W0Y5x7+
   LhZRCWOUlVIA7A0liv4Gh1S9LKPOE3eInUwCXel8CnchFS0VgzFnAqgdM
   doCaQZ2txH/V8uL+5yk1Bz+Mn7SxCRnP/jp+fx7UGG/qfLAjbPumVzwQf
   /Yw/iCn057UTJg3TRK6caBrrAWMFqvsSmzjrmO8ZkCNSiNVTqtc2Q+uSE
   w==;
X-CSE-ConnectionGUID: E5+kAjwMR4++YFm3Q9+UKQ==
X-CSE-MsgGUID: sARIeqSYRBiMJbJKnN+BJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57927420"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="57927420"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:55:55 -0700
X-CSE-ConnectionGUID: hI1QKx96QYquiDIJzI08tw==
X-CSE-MsgGUID: D/bp0K/MTwWG+dH2NdZw4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="192777534"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:55:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:55:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:55:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.87) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:55:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HsMwXsjSQyR2a/xXF2SbHSlT4bHEQL/2aTUKo5lcRNLWmSws19fMuKzQuQw5N/nRgoVPweX4eyjUZAhOonbQA2wF6fl8kCQUC/99RecTEprY8jiEGSXCCVg0Ncfia/xrxbL2GV5SjwhorHseU/zLwLHVfBPO7dDcsAdjDt9TBRRLUwbsqSINlpwFkLu9IzNDifhrdxIs6bbFWJsDEd9BgD9JfwoNitYfAOkmRHw9rqJQ5CBe6OCStGnQ3rmXVFPeiiPlFMN1oxDrzuuMy2TIGDb82/rvA34EPrECtwiqdYXtfV8W59pFSXEWksgM2O+ngyuUivF6U/MetgMJgJCckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVT5I4JI4lFA6iva2Txk1DREtZeSwCtx2QOYc5+6B7A=;
 b=yTbnak+BrfbheCGh5PoweEt/nSKqxFwg8yl6hh/YG9EVkD3n9yTT8l7NOFe01KltK1R7YVlTJvmxFMuprR1dHpzhfURLrOojWBiUDFbK+mOghC+2/UKom1IHIV1wQE6yKvez19J7r21g9JscXuTgCU9mtZn6PhEqw8PSx0fWPfkgLC0yTtmahC43O2oNRMupbo4ss51jEMYhl25yAD2ET+LuyUUTG7PlWrs7b6Bm+ba0zB902GDPpPN61itkfwZ+zquSMXiuIcfVgp2tNkeJEZsCdTqhq/Eum63VwIdl9AFkBxraEj6Gk5BSN37zQwHzd2hr7ZUJNVuC5HoIAWslNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:55:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:55:36 +0000
Message-ID: <042ff6c0-bdff-4ed1-9fc4-bca8f6ce8792@intel.com>
Date: Tue, 8 Jul 2025 13:55:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/30] x86,fs/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:303:8d::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 973010e7-87a3-4407-8312-08ddbe61c9bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEtCY2lEU1BnS2lNNGZ5MlUyU0Rsd3hVTXFDMkdjVUd3ZTBXclJwVWdsUXFy?=
 =?utf-8?B?ZUM4ZEgvZW1aNjhrRkR6bGxpdkhuVE1TYlAxZmEvVXh3VkNUMUl6YkM5Ui9B?=
 =?utf-8?B?TVBOMHlpQmxJamFtTjdBQ2FGVllCbHdjNG01eFZZT2xrUlRxQzB6UWUzV25t?=
 =?utf-8?B?cWVhTmFUeFRNcXZmVEY2ejVLRit6YWk3Qmw3aFJJK2dESVZvdzVhcEFuWHFx?=
 =?utf-8?B?blNlTVZsR0tySG9IQUJ6R0tZUWo4ZjJoYzJQb3hIN1paZjVUVXJ0VVNaaHVo?=
 =?utf-8?B?NUU1U2ZYSmgvYUduRkF5MEtobTlFZUdpb1JlTEh1akhxS29LN1NWcjZrSHJa?=
 =?utf-8?B?eTdyNzFVWXp6R3pVNzRpMzVrZlZlTUoxNXVmZjBXYnJzZlZuTzJmbWxVTjF1?=
 =?utf-8?B?RTI2SFdORDVSLzNHWmFMWDNMSHFvQnVRdk56UmdTN0hkSk4xdGF4ZlU1NTVM?=
 =?utf-8?B?NUR1b1N5TU4xMlQvVXBVR3l5N2tjTjk2WmZSbWhBb3JsOGFBZGN0U29pY0tR?=
 =?utf-8?B?OE9paXMyWmc1akFWdjJISHFCSkcycjE1aWhQMVZESDd1YS8yRXR4N0Y3WG9X?=
 =?utf-8?B?ZjRxT1BXQ2VpcUhCOHN3YWh5clY4V2VIakVCTktSNEwvODMrNVRuMVJRdThk?=
 =?utf-8?B?UFFIbHJLM1NyWWM0am9lL1M1aXppeHM3U3lxNGhTNTg3RzE0Z0RQQnF0TU5P?=
 =?utf-8?B?L0pIV1BVZU4zM0JqaEh4K1JobTU1L3dqbm0rSzdyUUJpb2RLdmR4TjdYaEdG?=
 =?utf-8?B?alNUL1ZwT3JKb2k4SjhxRXpYL3dpTTZVOEF2VnQ1dzA0QTdPWFJ3b3B3Rm94?=
 =?utf-8?B?SlljNHlySWNZRzh1Yi9FTEh0b3RmUWNaMWJ6dUY4Sit5UmYwcjYrcTh1WnBY?=
 =?utf-8?B?T1Fqb2FaOTh2ME0zZGN3dVFKZ0F1TmtFVytySWhyQU02cmhJZ3g4Y2t0aXBL?=
 =?utf-8?B?bGpJRkovV3pCVzZZTmpjenZiRW9QOFpSRnZxZE0rV2ZyakwzMGdOaEJGMDAr?=
 =?utf-8?B?ekhSa1cvLzNLVDhCTENRcjF4VnkzR3JPNTZMblEyZDV1VnlpTVY4YTYvUXFX?=
 =?utf-8?B?dlRVcURpcUJBVEpuUmVvQzJ5S1N3UkFaSmx5S3JJQlpFSHZnL3pvNlN0Qzkx?=
 =?utf-8?B?VU56ZERaNEsrSEZRdFYzQS9ESCtmRHczcklNM09kOTBNbkFlRkhydXZPdEs0?=
 =?utf-8?B?MTZLU1dTUEQ3dFEwcnAvYW5kTzNKM29lcnA0cWRmdHpxTzMrZDM2VkF5MzNQ?=
 =?utf-8?B?NWRLbmtPUm5JRVlSRFpGVllxNm42Ri9sOWkrZ0M5ZHRzbS83NHpuVHljV2E1?=
 =?utf-8?B?WlVNcnFBOHdNRTl6TlI4dFUwTldpS3ZDNHd3NU0wam1ZVnQzZUdod041VlFM?=
 =?utf-8?B?QVRWUzFUVUJCQnMwemFyM00yclgzSCtma0s3NmRNZ0l2YXV4U1RNbnNVaFdn?=
 =?utf-8?B?VmtVbjlyV0VHL1ZLUm1BbEdlU0RmSFE0dFdxc2t5UUdXb3RwZ2l3dTlvNkps?=
 =?utf-8?B?MXhEOVREeCt4M2xyWUFIZFE4c3RFUVJmMGk3aTR4TUZ4MDVQZnd4MXg2MElx?=
 =?utf-8?B?RENET0FvRlkxMDVkZEVHV3BjRzNUa3IrMlZuUkljU0kyYkd1aGlWU08yK29h?=
 =?utf-8?B?RTdnRlJ5VGt2Ti8rMHdNSkVkRzF5ZThQeW1TMFRoNm1VaVZhdzBWZExMNjFP?=
 =?utf-8?B?bXdVVmJOMldVWS84Rkx3OFIzZUtDWWw2eVJlQlViNng0cFNpSWdMVDgwR1RO?=
 =?utf-8?B?N3lPYXBNdXdtcEJ0RjYrVGdZa0ZXQy9HejFjcmxSb1dIaVltTitOVTB4THZ6?=
 =?utf-8?B?OW9Kb25YalUwUnBVNG9WS05JOFlOcXpQMnI3bHpSVEpoL0t6dVZhWm9DeFFO?=
 =?utf-8?B?N0RPNXhJdjdjRFo0TFJYTFRsOHJ0ajJxRnphVlBndUQwRXk1dFlLeWZ5RWwx?=
 =?utf-8?B?S0g3cTFkeG5YVXNsYXlwazMwTnBkWGlQQ1htb3RUS1hOL3BOdXA2dHk5QVkx?=
 =?utf-8?B?d3FnNHdFTHlBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZExPUG83ZzQ2aUhBWWJnMkJoYXpFWlVWRHFETmpOZVZsYTFlYUdDZ1R1bmtH?=
 =?utf-8?B?dk1KaDdvUVdyMzhXM1RaQjFyNDV3OVpDaGtTc1JGZjcvNHBPOWpRWnRpSlFF?=
 =?utf-8?B?cEkxM0lENTlycmRpSTJWcXZZMEJjL2daZzhwMlpnTUtKRkJEQjFYUUlUSzVZ?=
 =?utf-8?B?NjVnbDFRSk1KYjF1bk9XM1c1aDlydjN6cXhBaHJ4Tnl4b0d5ZXFHV3YxT2lB?=
 =?utf-8?B?Y2JwaVd3cE4zUjhxK0hGMGxzSS80dGdRc0pQeTNDbFN6VTNUd0V6NmVVaE05?=
 =?utf-8?B?OGx2eW1BSTFMRkFReW41bURBb3VJQkRQMndhUFZXem9aano0ay9DYjRQdXZw?=
 =?utf-8?B?MWx6cEpnT095K3NieGZQS2VTZkRpbENkTU5VZ21URlZlajlRUHJ6TmxWUXN3?=
 =?utf-8?B?MGRxSE1DTmRrUVZmRHJuQW80bjdadVgwMVFUYThOamxpTmphQ0QrU3llbGc4?=
 =?utf-8?B?WkNGSEdFS0N3NmpiZUwyVUtRbDN0SFQ0SElNdXpERGkwNTFVTGdxRWFOS1Zi?=
 =?utf-8?B?b3ptdjgzL2hMRGRqVzZQVUZIdmZVV3ZLcWxTemdTa1hwK3BibjZVL3RVR3ls?=
 =?utf-8?B?OHJOVDdZRnJTaDlSSHVzdUU5elE2WkpqNml0b0NQWkU5MVZkeU9TejZnRTZV?=
 =?utf-8?B?Vjg0UHJFQi9mZlpMS1d1dTJFUlgxOElyRWF1MkJ5SDREK1M1SWxNc0QrYzRY?=
 =?utf-8?B?bkNMdUJ0NEZGazhaQ3JjeXFxNHhRN1Q3NHJJT0lrME4rMEhPREdyWGQwUzJW?=
 =?utf-8?B?dnBuc0hmajV6Y2tuSEQrbksyS2pManFaaWNjQVEzUkdMMTRzdUkvQTJ3Nnhu?=
 =?utf-8?B?dzlXeU9EeWVHZ0FKenJLbEdSQWM1L0RsRnlic1NmZHRreEJVcHY2YnZNVXBB?=
 =?utf-8?B?OVNTckpBMUYvMllzdURQWk9ZRXRQeVBWYzhNWTFGT21RblArTVhHejV1d2lj?=
 =?utf-8?B?ajZYN2EzdkNPNEZJMTR0SDNCcGJoOS9La1lpd3NxRVQ4L09DTStHNUU0ZXc0?=
 =?utf-8?B?R0hOa1MzNDhkbjNWaDZYSVVkU2lIVHlrRXdGRVJLeXZvUzhLeWN2Ymk1eDF4?=
 =?utf-8?B?QXhYN0tWTVFGMi96OFA1UDY5SmIwUDg1dFhTYzVRVFJpUTA5b3A2ZGovRVVh?=
 =?utf-8?B?SHdUcUswbndKNW1pRGpZUUhod1JDaHdjTzVhMUx3aWR1dlVxV1hiT2UzRlYv?=
 =?utf-8?B?RTl2YzMwL2txcHN6ZlUzTDEvZjR2RUlBelYwaHlKcXpyUGZ0c09Lem5YbEdv?=
 =?utf-8?B?dXpTeVY1bjFiRjFhTW40TW5QQTNUUFFuZzBzZFRxM201YzROb3UwdEVLa1pR?=
 =?utf-8?B?YUVxSk9qT0U1bGIwVlovMUJnN3pFQ1g0S0h1V0djR1VaRzJMQ25yUVVVTThH?=
 =?utf-8?B?QW9jbkg5Ti81Y3c3M2Ywa0owTXhJRlB5N2dGMXVLWno2Sk9ieUMwSEh6U09z?=
 =?utf-8?B?MVRGMDBOY290WTlmOGZVQjJCL2gzRVk4NWhhL3hPZlRPZldMRzBONG1pWTkx?=
 =?utf-8?B?bDZnRC9qaGZPNFIzcnlTZW1HQmgrNEoyRC80V1MyaytmKzhIWVRTb0Q0VFZB?=
 =?utf-8?B?dUd0cTdraXF6OEp6NllUSTVhMm9EWnVUdmRXaXgvZ29SMG1PRXIwbGVPeDZ0?=
 =?utf-8?B?NitaYnIvTGdXczNqOEZMYnBET2dTRkVIRkh1MnFPU2NpV2c3Ujk4c0lwRi91?=
 =?utf-8?B?QTJzcE92dTArcHZ5MTYyWThHMENNSkVQNjEzQ2NYeWF3U1kyTndxcHJVcW1k?=
 =?utf-8?B?R3BTV2FyejEyYW5FeEZpQmNlK1N6VEZ0SnZkVU9tQkovYUQ0MnpjNDhuVzBa?=
 =?utf-8?B?WGhCVnJNeUJwZW9xMXFsK2VJcFVNSW00STdzNm5COWZXYVcvL1cxdFRuWUU1?=
 =?utf-8?B?cTlFdXZRd3ZTU09FTUJvWVk3anlraXVzOUJ4cGhrdXpiRU5TUk5oaHRaTERw?=
 =?utf-8?B?WStGRXVESlJKc0w2eUJtQjBLZ1dPYWRqUE90UkVHL1d4ZEEwZTYyMk81bGlt?=
 =?utf-8?B?bC9HS2lBT21yTTdVbytOYzNUZTlvSVdyam9WZytvNFVGQVFMSjAvUk5QL09x?=
 =?utf-8?B?bFJQNmNIcjhocmhJUld3RU1uMlVMSER1UXR5UExDelAxUk1UN1phWTRNVnRN?=
 =?utf-8?B?N0JMSG1TczRHUmFZbUlLSzJCQXNaZllMWWwvQjNzYjdYdnhSbjQybFRZTWs4?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 973010e7-87a3-4407-8312-08ddbe61c9bd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:55:36.4337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nhGb4szdRIghc3s5goI9kbScSmay4HUBs81gTu7wtN+aRqQ8QRx4zmUXdP+ArrBuO+Z+WtQNLi8EDW+D8uU4hndC3GipE+JtU6g8VsUf+lI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
> 
> There are two MBM events and resctrl is coded with a lot of
> 
>         if (local)
>                 do one thing
>         if (total)
>                 do a different thing
> 
> Change the rdt_mon_domain and rdt_hw_mon_domain structures to hold arrays
> of pointers to per event data instead of explicit fields for total and
> local bandwidth.
> 
> Simplify by coding for many events using loops on which are enabled.
> 
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it can be used more
> widely. Also provide a for_each_mbm_event_id() helper macro.
> 
> Cleanup variable names in functions touched to consistently use
> "eventid" for those with type enum resctrl_event_id.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
