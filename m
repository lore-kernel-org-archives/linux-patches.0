Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E869F18C331
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 23:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718406706; cv=fail; b=Fax5DQDIj9fqK+9p0vRMRbIxXeC8Dl+zn7AXStZpyKvsNcn4/5N14lstcxk7W/u6cCcBxwDhqqRa+Z8XUmaQShWV/VM4Yn4YKu8NZFg2SRFVgEV2+4rIFOCBm1dEDeEgH75oyJu9u7m9PiMBiNJbyL11/5WZJl8tf92N+0IWLro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718406706; c=relaxed/simple;
	bh=EjpAI/j9wx5vCCrx3M4VHcPZmRxbd/XC1pEtbNbi+fI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t1O0EpY0AgJWcIEnCMkCoR0M/tF/3zjwX47N8Mh9vuas789+elt6VDdDCmSi+Embj45uhKqEZxdcQRmPwFjqCGfiKrmwlt/PKvm3VsX578OG8Rspg3vubuRZRh0heKTGLeB1PJUIkk+BDP+YcUQJTTaOLESvRZTc/t1jK7EMNYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLOPLorv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLOPLorv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718406703; x=1749942703;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EjpAI/j9wx5vCCrx3M4VHcPZmRxbd/XC1pEtbNbi+fI=;
  b=hLOPLorvqpFiuYfW6d3mr9BErhiqhKQfJfyxDBm4mzqjJB3ywhg083H7
   TxGNrWS1LjLtvO8nioOtgmmkds+l8Due6B4K0lDOdkTbnwLAQmQoLsTX9
   F4OlP996+lFP2Z/hm5e+7zsct7qQJp0BWbiXp8nrvcRWKpm3bT3e+BWMG
   BumKnpDcjJ9TwFpJaWwMX4HtYWtLqidFopSRgcdaoHPmO7mevafUCBs8Z
   RLyilLJDAcb2Xmmj1QpchF2mtdOW1aTEnK3EtUcCz8fRmJYAW0kCCBg93
   2yR28aRDPjj+Lyuwuge6c+ow2H/ZytBdMVR1X2qz3EMMWIDIdTpwbB0jc
   Q==;
X-CSE-ConnectionGUID: S7ZOZ7X5QMq19M/hMWn8ow==
X-CSE-MsgGUID: RJ8ksR0ISzKBRBnZkl4j7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="12085096"
X-IronPort-AV: E=Sophos;i="6.08,239,1712646000"; 
   d="scan'208";a="12085096"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 16:11:42 -0700
X-CSE-ConnectionGUID: BH/Iyq1OT6qQbi783SmPOw==
X-CSE-MsgGUID: PiR3usbTQcCBzWnQsifH6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,239,1712646000"; 
   d="scan'208";a="71851365"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jun 2024 16:11:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 16:11:41 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 16:11:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 14 Jun 2024 16:11:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 14 Jun 2024 16:11:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMax3B6BqejowhmxoxmlyEWDgbRZcLRnW1w284EXf13IWeoHtbDRLmIvPzZZitHuY9IDe76NTaTg2Q4mx724/kcZ4HohSRAl6E9wwCauT5kVbJfBFh3rHZNcMtnAv0+J0rkUbxY2S6AD/hj6I6E41TVStfrYnfyigPKNVjB2XGrTj6rplQt8wId2SYloazV/tnphVpyRu6BoBS4Vc0ExufYA0/cVaWSp/OuyJibhe1zVmaPs7pulDfiJZ07fihHTN+ptwSixYPWAkiQVwq43JHyOA4Ler1LMJYYNbFJ1dGDfgGxOnx5a3sRwiJSDkLVrhQjJbUa2gwi2+jGCZnM9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xojkwFG7PzyVUAjmvKvq9rRQ41upTE+97eA1uCP2SX8=;
 b=BYapyJW74BMBIVZJll9IUzWBrHhadOCzkziu7VRLoHIXPKjdSsFwy1zJZf2zddCXntHiffNtJvFtJRg1Q0l9E0P3jW1rwpKp+bZd2PZ6UL737HtsSS8YLB0JnCmdjyAO59RKim2GT9JIWAh3npgTLZWN8Kh9jE3TtQuSXTJ3T2H9/BMQZuuhx6k+yYM1G2QyhivMm088YQyf3lF2T+GE8cnX252mCKdJMEufX9tUzlzgvIGVEEdxMtltdqpnjfOKtTq9rbsXEo31ajWptMSyseGKIllqVYKji2shwjIQk4JHD1vbiVNfL+SFSLcxhrLxDtve81+ilaJJzZulpnbfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4690.namprd11.prod.outlook.com (2603:10b6:5:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 23:11:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7677.019; Fri, 14 Jun 2024
 23:11:38 +0000
Message-ID: <bd2a8f5b-783f-49b7-b32d-efba4729b84a@intel.com>
Date: Fri, 14 Jun 2024 16:11:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: <babu.moger@amd.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu
	<fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Dave
 Martin <Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
 <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
 <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
 <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4690:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc68bba-7d60-40e7-3ce5-08dc8cc75828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cVRCZnN4c3Rrd2JzN1F1eEpZY29XN0RDOGdWNSszbEd6eXRtckUvSWZOSFlp?=
 =?utf-8?B?aVFTZk1oRnVJNHRYRzdHTUFuVkxpNDlJTnduUnRCS21hT0ZPSVJTYUFDOWdy?=
 =?utf-8?B?NTR6ZlkwMzJiV3dQcnoyV0NvNVBzc1NINlFBOXlJckI4amUxSWZaeWRLMlFn?=
 =?utf-8?B?R3M3TUMrdjhqWmtrNjBMUS9kcDNEWHkvOWlVNzM3WVBYM0h1UHpET1dXV2Q1?=
 =?utf-8?B?M3BOc3A1b1Y2a3lEaE5wQ0V3SWQ2RytlM09CVlRGS2RwRkh4MXROc0V2UDdU?=
 =?utf-8?B?NkRyM0tMcU55SDlUNzB2bytwdXFkeWEyVnFIbWN4UVJyMXUwdzhQV1I3d3Z1?=
 =?utf-8?B?ZS9KdU5nNXhKWkNuYW5Ga2R0U1ZlUVpCWUhpK2E0elVsME9EakRISllwbDEx?=
 =?utf-8?B?dW5PWE1KRGx4empBeXc4RzV0dzAreFFVTmFXVnhZeXJiMExvQ3BidTBYUVBU?=
 =?utf-8?B?WFVvcndvZktOR1RlUHBmbUp0TUxWNnc1VVg3bnZMd3FlRDQyNW9VN2RycGFq?=
 =?utf-8?B?encwcjI2RlVndHk4NWRKNHcwZU5GbkJBSFRZanVaYXY3b2JCMDdmT3l0cXNo?=
 =?utf-8?B?ai9INFVUbldGL0p6RTVoeS9KcVVNc1diSXFKSlBVMTlUMGVvamE2VEFrYmxX?=
 =?utf-8?B?THpxTEMyWTJpTGMvVGhYQTVVNEN1TUlGSnozajZsbnBYYjRzRThraEJqN3R2?=
 =?utf-8?B?b3lwRUlsQ3lTR00zZ2pZTVovSmQ1UU1TcHMyUWQ5NEpmTHZIZW5GcDZoVWhM?=
 =?utf-8?B?bWtaL2FPcWszU25ac3dsa3NhWlBPUzRESk5QVnJlY2pUTkdRbEdCTTRDekdt?=
 =?utf-8?B?MjBYUVQ3dHppbWhQQmlvalFaOW1uakxIcWdIWlhMVkZ1L2JCSWNxQ3RwU1VG?=
 =?utf-8?B?MXJDUWtCclBJMVlwbXFwbVVtQWdrU1JIKzZERFRLTWtLR1paK2QzNHJONUNm?=
 =?utf-8?B?b2RvK1Q0OUJPd2VWbUxwMnNzdlhiS2xTb3BRY1NTZFNmL2JSai9nTmo0TS9s?=
 =?utf-8?B?eWN4M25UU0NLTGd3MjN3TEZ3WGJldVo4d2l5bXRwYXVudkRZeEJReHJvUHVz?=
 =?utf-8?B?NWE5SGFKSFlsdXZic1FKQ2xrRURMeUNwcEpQeVFvYmtLSmRONC9PcmxEZDRp?=
 =?utf-8?B?V0FwaDVWWmJucEZsMysxamovMlNsTDVPSUs3YmpTODdCd0l2K2Z4NmtpcmNu?=
 =?utf-8?B?RTVPcjNTUWpaRFFscUJIeEZJRjFHKzNqTjlVVmhOTE5QM201YXNuM2NVUTQ1?=
 =?utf-8?B?dldsekhXTVhvUGhOYmR2N3BmYmtpOVlydkpUeG1XVW16SUhkenkzVGRXOGZD?=
 =?utf-8?B?Z2tCakJmUDg0b3haK0poQzZUWFkzNi9YWFFrUG4vWkxUek5PTTNsSVVxck9O?=
 =?utf-8?B?Z3pSeC9yNDA0R2VXZ0huS1VBNTFMd04rSUxBMitZTHVVRC9YTFhzcmp1Y08y?=
 =?utf-8?B?YUtHWXNleFJsbHlIdXRCQUlmYlFoT2dmZTZTQzc4eExiMUJIY2hLUWo4ME45?=
 =?utf-8?B?Yld4SlB1eGROTVowcjdaZ05uREVzTDY5WS9MWFpWeWFZK0FRS01jdTJURk50?=
 =?utf-8?B?YXRlazFOYjVDQU1ETFJhckxBZXJjUTYxS1JQc0htUzNubng1cGgwUVROQUpJ?=
 =?utf-8?B?eTV5TVcrWndwb3UyQkFOaHlQRzU2cDFsVTBlT1pyVmZ4d1lFZzRsVmVJamhE?=
 =?utf-8?B?YlRkUlN1RTdMUks3eldPU21xRnZRbFlpd0pzV01mRzFlTmlwbG51eHVnOG5S?=
 =?utf-8?Q?A3CCem0nUozoDSpLvdNTb1gT+fIacC8hCFLFeLs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUVvVE9QK3pCYVV3dHZUQ1k5MFhRQ291bWd5WFJXOVlCTXRNZC9rdE8zWmpy?=
 =?utf-8?B?U0M3aTRUYTFmU2FjeWdUQ0pJNnhiYitJTlh6bEcyb1crTHU4VUs3MFRhTEJD?=
 =?utf-8?B?TCtEODRlTHhqS0xCVGt0c3FtWjVjeFdFc21POUo0ZHg2Z05WNzYzQ2ptMEhD?=
 =?utf-8?B?c1lOY2k5V0hXSEp1cmppV0ZqSTd2QkV0b2ZwblVCb0dXS1Ywd21DeGZjaUQ1?=
 =?utf-8?B?Ky9GS0tuUFJMUlE2SUhCc1lFdTFzYVgvZGJWeUF4cXVhN1NYODA2Z1BqRWdl?=
 =?utf-8?B?OU1MUGNpNm9mNW5pblgxcURiVmFQSGUvbWJnZ2lNTC9KN2IybXRwTlBxdjhM?=
 =?utf-8?B?Z05HRGpTN3NlVHN3eGs3RzcvaWViZ1F2dmJOZjhVeVVBL2tUTXFPd0V5NU9E?=
 =?utf-8?B?bkxjT2VMb0NWNE9mb0FvakdmbHFXSlNFSjFqOW1sQ3ZzTG03ZXJyd0R6T2hm?=
 =?utf-8?B?bDcrdi85QzJ6Q1ZKcUhzY3FBU0pRLy92THNhYWxPdTA0YUxuMy9VTTlaRURL?=
 =?utf-8?B?N2JaMkRVa3hnSXlRV0Y1Q09CMmxpSDg1QlMwdWJvMEZ2aCtkbDQrdXBCbFB6?=
 =?utf-8?B?NFYrSFhvNzJLd2FDUEU3Y093NmxJcFNXd3hhMC8zcjdNc0F6OEl3S1hxY1Zx?=
 =?utf-8?B?TjVvU1l1VTNjUW1iMC9vQ2FUSHY5QUJacWNFVlBXZE00QThSczdzcEZ6WVM4?=
 =?utf-8?B?WjB2Z3hzd05lYUF1VVFpRTFyOXpVTVlSLy8xZFlybXVGaWI2M0s0RTBCUzVJ?=
 =?utf-8?B?Q0RxTTkya0NtalhQN25kbC9RZEFiNmdWOWRIS1dMbGlwUmlCank5S1hYaHVp?=
 =?utf-8?B?cFI1ekhzcHZkZWpiOXhZOFZXTm1SRTdQTHVqK0JmZUhSclp2bXFPcjVNcWJs?=
 =?utf-8?B?aGVFRUc0MkN1enZPY3ZpN2EvVkRWVTgzd2VLVVpZMXdLeldhL29KSCtNV212?=
 =?utf-8?B?OXZjVmUyWkdKRVRoTjg4cllvbUFxZit2S3NSV0ZsR3p5QnUrUnRzZ1VsZElD?=
 =?utf-8?B?aXNnSUltcXpYaUdRTXlHZ1hMVEVHL1JhZzF1Mkc3c2N2VnFLOVlBY040WHFU?=
 =?utf-8?B?Wkc3NTNjYlVhUGg5SS84OXh3b1Y3RWt2VFhzSHE5L01yT3pSUE42dWVaOWYr?=
 =?utf-8?B?cUlVTEFhZmpNZStpR3BlVFcxNkluUDFjaFYwRzBLcENubkRTYkVaRmsxdGc5?=
 =?utf-8?B?ODJMVTh1ditXRHJXeHJSS2xVM2xFaEZMQlFFelhJUEQzbTdhNkFrcnJiWWhC?=
 =?utf-8?B?U05tZjBvOU1rNEtkNHVEd0V0ZGlFUE1QSlhCTmdnY0lqeWNXUDQ2bEVpTTZC?=
 =?utf-8?B?YUJlKzFLbFBOSyttOXhkNkdlNHpKS2VqV3JmMW1GVmhJN0g0M01EWjI5bE9D?=
 =?utf-8?B?N3FXWGdodXFOa3lTQWVTT3RLTG45SjBXcTduMUI5U3VIbFkyVnF4S1pjNTdn?=
 =?utf-8?B?V2llcldFV3RDOEFEeTRLQzI2b2xld3gyOENMS2lhZmV1VjRKRTNPRmtLYlAw?=
 =?utf-8?B?NHlQc2FyNDFmQ0lxUmQxMm5qTWdzTkgzcDg2bGdUdlplK3lRZ0ZyTERZK0sr?=
 =?utf-8?B?aG1GRTJjenRaQ21ZUkUzd29LODVsOXVuWGpUYit0ZVE2THNXRE40dUNaUy9V?=
 =?utf-8?B?UkNpSjhGdTU3ZHExOTFxQWdBbzA2RWNpQkhoVUxJSWZzWjMxUkxKejExR0dX?=
 =?utf-8?B?c2tWZVNSVDNHbDBJVktkVjgvMHUwbnUwenkveWg4VUt0cEhzRzQ4RW1BbXBi?=
 =?utf-8?B?d2V2QXdmTkd4SnAyNmVNaVdvRldBVklZVnNvZ1RYRVdHR3RNaTlqSm9wbG5Q?=
 =?utf-8?B?aU5xSmZSVEZ1NDNuRDk2eWNrK1J4d1hKdVhSaHQ2blRia1NtdSs0MzRZOGxG?=
 =?utf-8?B?Rlp0cndRTlZlMG1uVms4S0xndTFhUVFYR25WUnJyUXdGdzQwbC9pM1plZ01P?=
 =?utf-8?B?RXRaaEorK294SzUvL2ErdHUzaEp1NlhYQkxDRzVlTlRiUW9NSHc5UFlXUkRq?=
 =?utf-8?B?bGs3WFhZUEdPWFFHRExaQlNtZ05idFBVOUZ5Z1VRQzFFYXI5KzNVWit3T1pS?=
 =?utf-8?B?Z3IyN0RZamRQVmUzU0xkUGpUaEwySnVXSUFPUlJqYUk1alFLRjg4VnBTNWU0?=
 =?utf-8?B?L3RDNFA0TGNXeGczZytUYmtoOXd5ZFlKYzhUZ2xiMlVDR2FCUldVN2RldXhM?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc68bba-7d60-40e7-3ce5-08dc8cc75828
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 23:11:38.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx6hCK9BD9i0f9S+ag8fJL2YpPDo2Eq3Op52gWGUFBfWZrf+/hy8JFoiFnCi6DeZRrIuShLdQJcLq41Ni566xpAo9hPPgiFUnqgHB2qKmIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4690
X-OriginatorOrg: intel.com

Hi Babu,

On 6/14/24 2:29 PM, Moger, Babu wrote:
> Hi Reinette,
> 
> On 6/14/2024 11:46 AM, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 6/14/24 9:27 AM, Moger, Babu wrote:
>>> Hi Reinette,
>>>
>>> On 6/13/24 15:32, Reinette Chatre wrote:
>>>> Hi Babu,
>>>>
>>>> On 6/13/24 12:17 PM, Moger, Babu wrote:
>>>>> I may be little bit out of sync here. Also, sorry to come back late in the
>>>>> series.
>>>>>
>>>>> Looking at the series again, I see this approach adds lots of code.
>>>>> Look at this structure.
>>>>>
>>>>>
>>>>> @@ -187,10 +196,12 @@ struct rdt_resource {
>>>>>        bool            alloc_capable;
>>>>>        bool            mon_capable;
>>>>>        int            num_rmid;
>>>>> -    enum resctrl_scope    scope;
>>>>> +    enum resctrl_scope    ctrl_scope;
>>>>> +    enum resctrl_scope    mon_scope;
>>>>>        struct resctrl_cache    cache;
>>>>>        struct resctrl_membw    membw;
>>>>> -    struct list_head    domains;
>>>>> +    struct list_head    ctrl_domains;
>>>>> +    struct list_head    mon_domains;
>>>>>        char            *name;
>>>>>        int            data_width;
>>>>>        u32            default_ctrl;
>>>>>
>>>>> There are two scope fields.
>>>>> There are two domains fields.
>>>>>
>>>>> These are very confusing and very hard to maintain. Also, I am not sure if
>>>>> these fields are useful for anything other than SNC feature. This approach
>>>>> adds quite a bit of code for no specific advantage.
>>>>>
>>>>> Why don't we just split the RDT_RESOURCE_L3 resource
>>>>> into separate resources, one for control, one for monitoring.
>>>>> We already have "control" only resources (MBA, SMBA, L2). Lets create new
>>>>> "monitor" only resource. I feel it will be much cleaner approach.
>>>>>
>>>>> Tony has already tried that approach and showed that it is much simpler.
>>>>>
>>>>> v15-RFC :
>>>>> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/
>>>>>
>>>>> What do you think?
>>>>>
>>>>
>>>> Some highlights of my thoughts in response to that series, but the whole
>>>> thread
>>>> may be of interest to you:
>>>> https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/
>>>> https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/
>>>>
>>>
>>> Went through the thread, in summary:
>>>
>>> The main concerns are related to duplication of code and data structures.
>>>
>>> The solutions are
>>>
>>> a) Split the domains.
>>> This is what this series is doing now. This creates members like
>>> ctrl_scope, mon_scope, ctrl_domains etc.. These fields are added to all
>>> the resources (MBA, SMBA and L2). Then there is additional domain header.
>>>
>>>
>>> b) Split the resource.
>>>    Split RDT_RESOURCE_L3 into two, one for "monitor" and one for "control".
>>>    There will be one domain structure for "monitor" and  one for "control"
>>>
>>> Both these approaches have code and data duplication. So, there is no
>>> difference that way.
>>
>> Could you please elaborate where code and data duplication of (a) is?
> 
> We have ctrl_scope, mon_scope, ctrl_domains. mon_domains.  Only one
> resource, RDT_RESOURCE_L3 is going to use these fields. Rest of the
> resources don't need these fields. But these fields are part of all
> the resources.

Correct. There are two new empty fields per resource that does
not support monitoring. Having the new mon_domains list results in
the benefit of eliminating monitoring fields from all the domains
forming part of resources that do not support monitoring. Providing
more details below but the additional pointer results in a significant
net reduction of unused fields. Having the new mon_scope field results
in the benefit to support SNC.

> 
> I am not too worried about the size of the patch.  But, I don't
> foresee these fields will be used anytime soon in these
> resources(MBA. L3. SMBA). Why add it now? In future we may have to
> cleanup all these anyways.

This work does indeed go through the effort to _eliminate_ unused fields.
Note how all domains of all resources (whether they support monitoring or
not) currently have to carry a significant number of monitoring fields.
These can be found in both struct rdt_domain (*rmid_busy_llc, *mbm_total,
*mbm_local, mbm_over, cqm_limbo, mbm_work_cpu, cqm_work_cpu)  as
well as struct rdt_hw_domain (*arch_mbm_total, *arch_mbm_local).

For a resource that does not support monitoring it is of course
unnecessary to carry all of this for _every_ domain instance and
after this series it no longer will.

Reinette
