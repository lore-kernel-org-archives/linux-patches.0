Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795474225;
	b=f5qlqUmEEDfl054XIRz/BC6fBHSRD8VUeI7grqp9Em3vCuovtEf12UOynewPst84Y6jM
	 ahMV96Thg0BtT4PQbetdOROw7W5Bw7Uh0xjba96QNtk1G6hp2zUInHOVvYtbdZxUEgcu0
	 djRtnZi+/jppn1vSbKMU2mYV4GLHvyFS77t3kAVfyWCNtSCmhw1+XbaTVHSqotMhZUVVW
	 MWToA+hKB8OxcCuYSje6g3v8bEfOFK4YIX55p585dnJutfdK9LSNHjlSDmVsEJ5WflmJK
	 vgtB3OXpZKaoHUp6lFTfkH4Lt+ktiPeHAfNjcoap7GG4fLmbM6SD4R9ad5+ygV+xOmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474225;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=gceRUG/IXs4KjBDN3uVBJtk9oIpwf9VQeroskVHpKjU=;
	b=pBlTmaLiXSpn3kEsaYLcwBa5BvWBcRo8vclFMwkOnqDK93pgqo/aSwRCeyUGowuRcyk1
	 5bKGV54Mvugp88yrK6fmkI/V5B7NvPsaj/i8wGiLkcytztu7aBJqXNCGzZ/G5pEwUJ4x1
	 Fr2qq5BQeuzvJ/zs+VNNjFQvbzgaSdOlhnVLQC6D7YHNX/RpkALPhGwzjSyajRhh+mJcL
	 +2qcUEmbdTVhFfzqw6/4xl/kmVZIPXrmdKJw1cCpYID53EZ7bcnSE51a5Nqyc8d4lPxZm
	 qk2JDb7rj+GkJBoj2AampGaOYC4JKRYCL+biiN86T7NkM0/ju3ujMkqK/LnG74RYACg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WjmJ57Ys;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=I9LBFZIh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F235606A32C
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 22:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F235606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WjmJ57Ys;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=I9LBFZIh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795474225; x=1827010225;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rBr8eaEqnmV/76xy6+KJcFvqfZckfVAqGbefBPp3ECU=;
  b=WjmJ57YsdbihJVcQ4gxoTHJmifq1VzG3veC3KAwfZ3aVM+K4TyEPtA9P
   NY5rTjX0B3N9cJlfUVnVr25UPmvMWnnoU5Z6CzzjOgDOMmhZVoFin0Bwo
   fnVglWD6TzwIey/ubbsO3IoO/PQXX+sLILZlNPT3l602GF9IYAP4k2vA/
   BcdVVlLOaNEpOH+trdW+W+XaKrY4xSXWlsFGjRN/8HNg1cYijU+Q+TLsx
   uOm1w8sLFeBtBsSErZDoX2tPabGYFZP2yRCwF3HB1NMAG+4xxqzGpT/Sk
   C2r3IrjEVx3Syz23a7+GgUtrMMuYp068p9UMf2fn2wGpNR4gky/d16PWO
   Q==;
X-CSE-ConnectionGUID: cmLJlCXcTbWqV7+sYSrUMw==
X-CSE-MsgGUID: miQ5DHO2SAKT60EtpRPD7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4336665"
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="4336665"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 14:50:24 -0800
X-CSE-ConnectionGUID: Ow085F2/QRyYua39fMNOyg==
X-CSE-MsgGUID: 7cs/Cc7OQSubrRZAnGtfEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="11375900"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 14:50:23 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 23 Nov 2026 14:50:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Mon, 23 Nov 2026 14:50:22 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 14:50:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQlhSgIqCNB9lhoMqRSRPb6rO5mr8l8GCPJc2Ty5/l4iOXROlmqAk/4I2B8VU7jZPgPrcokR5oFZTfX+OvduhVkpx5zJx5MRh5Jp1yYg0/D5ktInID30WkL3rFyENW2D5RFX5/SNmB9YAsE0KSJq2NtfQWBc+N3KYdQW5gyI2D88Oz8tT/fxibw4vMJ5DDjxkMVcOM8x2vHOVaSMzy3kIzLGKmT53g/NlxjHZ2DWvXTZlnGFBhv8OvoDUzhpxDMVMJjH0mxtsGuyxyg4LTilYpNpKIqkRM1/XP6KZlLqmyv5D7IdFFTFgFS/KLJU9Fq52pKP2KuFXaI1AahD53YUuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gceRUG/IXs4KjBDN3uVBJtk9oIpwf9VQeroskVHpKjU=;
 b=oIpBKFig/YJjs9aC253Zk2couMlNuKeTYK25s4D/fd6CO992yTKx53hBG/7F8UaDN9gPYPMeLb4u8GwLqnUGn4iHuw1XImdJBlF9R7USGYFqc8Tx0TULJKDeXTahuZ0dDTMZVkvDkgpzOQd9HijbnljnHzwTa+OzUW2QFoUKLSMvM+g5dkO52caTg+zpYobelq4fRQwpJ+70ed8qsItmOihS8+xh5JE7Lt1Fig541DPf0Wgkmhn48995z2SO6Z9louwHjyONqSjM5HAjS3eqs+qKfREybsABoACTdRZYcCb5Qe7nWhEYsu23NIk4vKf39bHL+mD66vp/sHYaePpt1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gceRUG/IXs4KjBDN3uVBJtk9oIpwf9VQeroskVHpKjU=;
 b=I9LBFZIhc/bMsvCZ3jH8z8iDZY/PskXHN2JS4TANkyJZJxiF9TOSFxgHBeDpT4f+5EArtQI9YNkPfSh+zym4m388jAnc+4y6VNn9WLnVFPwkYAbbTyVd5qaRhJJIes/aHAbNDuJhsODN5StaAQ2LljUNnnEluvboRKHlhudNLVI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW5PR11MB5906.namprd11.prod.outlook.com (2603:10b6:303:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 22:50:18 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0615.009; Mon, 23 Nov 2026
 22:50:18 +0000
Message-ID: <22918abf-7487-4662-a87b-34c579783e51@intel.com>
Date: Mon, 23 Nov 2026 14:50:14 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group
 assignment vs copy_process()
To: Chen Yu <yu.c.chen@intel.com>
CC: <kees@kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <tony.luck@intel.com>, <ben.horgan@arm.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <jedrzej.wasiukiewicz@intel.com>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <x86@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
 <awO3nYazk97csbpO@chenyu-dev>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <awO3nYazk97csbpO@chenyu-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0299.namprd04.prod.outlook.com
 (2603:10b6:303:89::34) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW5PR11MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: b95d3405-e49f-42f5-c8dc-08df49b42584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|18002099003|22082099003|10063799003|56012099006|11063799006|4143699003|261022105027099003|261022075727099003|261028144727099003|261026140227099003|261026121527099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info: 3lp2bgBQByvyQzUSCfIoO6bzMqNxvoGoRnch1bdg6e0E++KW/0dipXPwY2PHwq0GbM2YsGpdU2FRn2KCfoJQ+Ri+OWqW+Qch7roMyCr55D5Pkf5XB5tkcXK0OMa8Z4ejhFH/acxZ4jBZqE92x/4vOKiaRuWYGv/nx2XCdIQyBD6SLOy4QE8gAFXrYHlT3zBkep5ZTQMckpAvmtJH3FiKbDT1kvQGKhbVDU10pdpUAxyp12uDvNO3vA1rtiZN/LdfawYSxCA77DLWssIFccXhrxMU76ytQ0u2xY7ZGbGmYfRKO97h3NTCW8MfRYwg6YZhW4rwLJGZ9nYKDtPONv0nmFqxvk9FVZjPmiqMXtMYb5C4ogbVy+FTkhow5ZQlLKglH8GBau7D6FRCY/toICKrJGm4JpgCz/viUW2Md7DSNDptZrm0L63nD1gm26/cFtKrxcbgl72O1l9pwHKrtoquPgEji+i8jCwKRvfLqFKUJMRggsHmqaqs+4ggaTKrOIBcZd2ASHDr5IVoVwnD2R074YlhkLtGhalKsFA9f34p8/3olijm0OoXViar5SGe4YUk9RN/H4AOZZcO/FtSzmnlitBdacJ7sO2ExU31ukLQ9/dEVA3/5A/vyeEoEg5mt1SrAj2BQX84YBk72rdA8ZckEwDUHqD+rzYpm8GMpNJHak4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(10063799003)(56012099006)(11063799006)(4143699003)(261022105027099003)(261022075727099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWtJdkhOamladWZkQW1TSG40SWI3SExDS1RVQmZHY3pCeDRtTzd1WmMySXVr?=
 =?utf-8?B?M21mS2V4ZXROQ3ZpU05Sc2xqVW13SU55UDRnYmZpc3BZVjVqNm16TGtkeUVX?=
 =?utf-8?B?YVB4STBTT0xtdUFSWi9LR0NpQXFoSjIvZ1pRVWFydnFvNTgwRzhkNURLQlA5?=
 =?utf-8?B?WmpuNm9pQVk5TEpVVVM2dXB4S1Z1UzZiakJxOHIzKzdjekQ3cDd6M0RwRWpx?=
 =?utf-8?B?WlIyNnVZTllWSHJDL1JtN1U1SnRJSEYrUEk2MkpheWlvMXczZDRmRXZETlFY?=
 =?utf-8?B?TjR1QzdRc0FOTEMzZElNSmp3T1ZqbC9yaWV2N2hwSXBidWdDS2EzaWlHRzZW?=
 =?utf-8?B?eG00aUxBd1Y5M0s1TnRpS0JqV1BXUjhxM0pDdURBbldLMmRpYXlLdG9uOGNI?=
 =?utf-8?B?MDA1MlJqUUdQd2g5ajNIaUowTFlTSUkwZUt5a0lVVSt4bDJtdnZSV3pxYnM0?=
 =?utf-8?B?NHV2amhSNXc2UE9abDlEWkc3Y1dTMnhKNWFmQjlSYS8vZjIvSDVMc21pMEFs?=
 =?utf-8?B?QjJLeVJkaVorQTlvVzdoNEVITVFYbjZUT3ZMT3Z2K3VGSjQwK3FVQ3MxZXBB?=
 =?utf-8?B?Z1Z6d0pFNm81SDVHSzVtRzE2SnFRRlBYMEloQmp0NkNmcXVnSTZ4TTFRSmRM?=
 =?utf-8?B?WlhFcEoxVlB5elJVbFQyUFJMR1JJMVliemsxUHhCc01mMVlWSFhzRWM4MmtM?=
 =?utf-8?B?MEh6bGZlYnNPZ2FmSWROeGgvOWRFd0dSMXNCQWladWVvMGlKS3daN1ZRUis1?=
 =?utf-8?B?SUhwaTdybXZoelVXcy95U1NmZGRqQklTbUVQTzFESGxiZFp0RjBjUkorbjhj?=
 =?utf-8?B?a1lBZzJIRFBHendMdlVCNVlqMHdsdFJaN0JzOUpRYncxRFVjN0xWd3F4K0ty?=
 =?utf-8?B?ajZKcFNkMzlMTWZmOTd4RGp6OUN0SlM1bUdUKy9EcHZmV2NqWnJReFNYR2Nw?=
 =?utf-8?B?aCtaeDFGU0lrVXBJK3kxWDQ5bzZjYmhicFRhSlU5VzVZT0NlWmtFb2NoUVV5?=
 =?utf-8?B?RzhHY3dialNHc2Q0VnYzVEtMYlpOeEhMUzM3T01BTzR3ckh1akVYSVRmV1ZQ?=
 =?utf-8?B?N3liL1ZDSWp5d0xzWWhUSGIyZWViL3NyNHhhb0JYS0ZQaHVlRlFOa2FHbkJX?=
 =?utf-8?B?MldWY29vUW9vQUMvdUdOcmVUTGlMTjZxdU92TUI3UGlQOGFCdy9mMzE1bHBY?=
 =?utf-8?B?WTc0U3RjV2N5aDAwNUMxZnArVTJySk5MSE15djlqRmJNR2UrcFV5UDlGcFB2?=
 =?utf-8?B?YVliRy9SUUhtczREQ2pMSG5UZTZqc3ZSTi9DVVFxWlRrZDJGcFNYci9lTzNq?=
 =?utf-8?B?RGFHQk83RnZxU1ZJSjFSakJsaFMvRFlPWXdQS3hxYlhCblptUkoyZzF0TU1l?=
 =?utf-8?B?Smp0ZFdYM3VKZHV1R3dSQWFIUE9pZjgxbk12c2JQZGxTaTBMekdlS1JtZUpU?=
 =?utf-8?B?cTJITWtCMmszT0xUWkJrR2RicllrR1ZXTGFzTCtYZmpTSHFGYW43MUYwdWdx?=
 =?utf-8?B?b1ZmQkdueHRFQVZRUnNTcjF0eXhKMXRrcmp0R1duTDdnTGRlYlBYRW04VnJs?=
 =?utf-8?B?MXJmbkRVRUtqYUd2Q3NoQTl1QkVDMW95UUVmQXg3MzkrNWxGNU1FYys2dE5n?=
 =?utf-8?B?NDdPN1RjTXFSdlNnRE9tVVZhK2xXaXpxSW9rU0tEZTNlM1RCNEFnR1JsSEVN?=
 =?utf-8?B?bCsrS1hhcit3Y0hYUVZEdURtMjVreUQ0d2VqNnR0Y2pCV0xTSGhyb3pXdHpS?=
 =?utf-8?B?NWx2d3hwVXpYS1UzV2Y1RnFUemZubCtuejRGbE5uamZuM1NDNVVLVy9BTFp4?=
 =?utf-8?B?b3orUWluWVcxR2V3YTJCdVVWS2kvVU40bnRUNlIyRkI5Mm5HUlI4U1Y1bFBx?=
 =?utf-8?B?Z1JESnpsY204dlFuOHowUHNpVTdPRFpYVVpOTjVKZDU1azhSaGI4VmtHZjNp?=
 =?utf-8?B?SHZUTzYyNFBHbkZaWi9xVUlvZzZNRUJXWGtaSDk2OWgra2pMY0I5ajNaK3N4?=
 =?utf-8?B?V1J2c2xYMncxVnVnaU4yZVJvR3BLd3BoRmdVZXFVeVdvcFI0UkYraTZHRjJG?=
 =?utf-8?B?RW45Rmp5eTlCVGdtZXJNdVV1b3pVUHdOS1hWTnY3Q3pqQlpCaU9UQUpWZWRQ?=
 =?utf-8?B?R29uL2hSYUhqSGlGaTFwRjlHczFlUDZxaGwzekFqUU9QWDdyekxNMTB1UDZo?=
 =?utf-8?B?TFdqM3FYRGRkYzR0NlFFUmdWTmFWUitld3dKSmlpYlVBNTNxTjI4ZFpmYWVE?=
 =?utf-8?B?SWRMemZveHNSK1dDTWpXUGpwQkhLN2xXS3Z3ZWk2UXUrSWs3aWhzTGFYczc3?=
 =?utf-8?B?ajF1MzBsUVdpSlhodjZ2TGNKdkFUbVNWZXFWWUJiU3E0dU1GZ1JXeFl5OUJP?=
 =?utf-8?Q?sGDeYKq/lKdaNgN8=3D?=
X-Exchange-RoutingPolicyChecked: behSnahbPAA6kvr/Z1gfQn+ze9nN81tQOROSXzEui0U1qZ35U0wsqgHYubywhHjUpZMJu1MhsQvQPvjmGyAXftfpYa1Kksoi5hcDfCiKMS9sDdRnVaxnJ4rob2L4Xddu1sHH9LohDjeBr1AHCE6BjIIPqAqJwiF9Y5kGI+Pr6awjbOU3yDUrcnw721AMICTi101iYUwNvb5xh5tgQ0/DgB6jf5PDd56aAxV0vurWsCJq8bdm76sfzRcIqzm6T9JSDJDYDHlR8+v7416APXa1f9GnTSK7s8OWcGwlmMhw1XqraQaWNqDprmUjQtRfExy1pFEcEv/4LE7Ed5+EDl7YHA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b95d3405-e49f-42f5-c8dc-08df49b42584
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 22:50:18.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5r5K5h5slvyhA6HqJyYU6dQfFenLaJ57jGrlBTPZFAlCnx2vPaeEOfOktFYUJfEn5fNhoiB4g8lyfQ7reb/HBKTTtW9CDoYsB725k0J2TrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5906
X-OriginatorOrg: intel.com

Hi Chenyu,

On 11/22/26 7:48 PM, Chen Yu wrote:
> On Fri, Nov 20, 2026 at 10:39:30AM -0800, Reinette Chatre wrote:

...

>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index 57ab090072c2..ebf780fc5fe9 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
>>  		return -EINVAL;
>>  	}
>>  
>> +	/*
>> +	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
>> +	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
>> +	 * while only one of the two has been updated.
>> +	 *
>> +	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
>> +	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
>> +	 * applied when @tsk was last scheduled in, so
>> +	 * update_task_closid_rmid() below has to interrupt that CPU for the
>> +	 * new resource group to take effect. Leave that until after
>> +	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
>> +	 * for write waits with interrupts disabled, and @tsk's CPU is the
>> +	 * one that may be waiting, because @tsk may be forking.
>> +	 */
>> +	read_lock(&tasklist_lock);
>>  	if (rdtgrp->type == RDTMON_GROUP)
>>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
>>  					     rdtgrp->mon.rmid);
>>  	else
>>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
>>  					     rdtgrp->mon.rmid);
>> +	read_unlock(&tasklist_lock);
>>
> 
> Is it possible to combine u32 closid and u32 rmid into u64 closid_rmid?

This is something we can look into yes. The "What remains?" portion of
the cover letter highlights this but stops short of proposing the change
as you do here. Making this change will only eliminate the need for this
lock at this point though, it will not fix the bug, right?

> RDT will no longer support 32-bit kernels, so u64 is always atomic. Then

Planned, but not yet done.

> we don't need the above tasklist_lock in __rdtgroup_move_task(), and there
> is no race with resctrl_arch_sched_in() - but we do need it during fork()
> though.

Right. The primary goal with this patch is to add a resctrl hook into
kernel/fork.c:copy_process() to address the bug that results in a task
_permanently_ assigned with a wrong CLOSID/RMID. This is required whether
CLOSID/RMID are two separate values or one, as demonstrated by MPAM, which
stores the two as one value, also needing this.

In comparison, as described in the cover letter, the potential race with
x86 __resctrl_sched_in(), is not permanent since it is corrected at next context
switch. As you indicate with your proposal, addressing it needs a separate
and more invasive fix. 

Reinette
