Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E41ADFE4
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144614; cv=fail; b=pmw/VF8PctbZBn10k2DV3m5SvVSSJSulKh3FKstNBVZrP9juKM5lVOKngfawwY5Luv42rG+mnBT+cL94je4va6vSPCxLe8uo0Mhq7eKREF7WGfOkcXwcX0tLwjj4MBBDWYf2+lZIHnshuM2YBIkdlSLmbOnw2GvVuJvzzYuKMfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144614; c=relaxed/simple;
	bh=3wp9aRmDmI4+w8gRfX58KVWxhgE93KIVjTdzrmOl/xk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aAzd//SYT2PH73sQWRtXgq1tLR5aNcU9xpFZ5Gv/+yz60a73mgZ1KBBPOS2z08PCz0S+JNlmpxUAp9sh/Yw9C9K2JFKApQHy62LKVBvxDr6ieLkr57x6/z0uA7DvGB5HDj5hi3fRbvpi1U4EyGVg++H6IgXQE4eODQINFYAD91g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EAajTWEv; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EAajTWEv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144613; x=1786680613;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3wp9aRmDmI4+w8gRfX58KVWxhgE93KIVjTdzrmOl/xk=;
  b=EAajTWEvyBCWEVM7v5/MSs7QE0mNNy/ichjIBL/JagfX4cAaSZzB+idp
   TOB9rCYDCjCA98mHsQorFbXeTZ7yzhrPumcuRE0hqPWW5ov3vjce8NtnC
   Zd/MZuSTcYUzt93sn8ktHXPT8Nw1vdaoYPUk3p0vLYsxWACC6mQiOYbkn
   0N4H+UFCE2brs542gp5cNWdzNE0fRIhYEXTkMo1HpEZUQS6JSBh0iMapc
   eszruY7cjk3SFZw80D1KiYBDWJozLf45tBA9SMD1Aplv1rf09UPZ9vBFG
   tWfszJZUe2rL/YAd6Y7P6unBrJwYsShxFRC7uR7JyZZHMzZ/UIf7zVd85
   w==;
X-CSE-ConnectionGUID: RZLN6XkUQKuIePYGOmACuw==
X-CSE-MsgGUID: 7sNiFCtOQvWW1CRgvXUAqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="56475378"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="56475378"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:10:12 -0700
X-CSE-ConnectionGUID: N0qlpF5TQU2LPj4EPGNQQw==
X-CSE-MsgGUID: CdvK7dFUS1WBLe8ix8Rhag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166297822"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:10:12 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:10:11 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:10:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.44)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 21:10:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0dzDijUbxU3zGB/TPZ1qeSM2TladZPDPU3V6A5hLLOj2aMRta821fH/0xZFy39zdNgjGeLjKYH1Q1doimB5tNFt+kmVC2AsYTwHAViOfTG49KQWUZrkLEvJQ4JscYi3RhMCwmKNOFCtPSqz7o/k3AlF24JBYRSa+c9VCWUGzIkbOjLqGSzEh5ZzAk6UtFtW0ur1RB1zEzpl0LwJpGZEovhJrLPxyDUuuUJ41v6pVztvDClLKvWjqCsA3v7VHeR7SDI/qaV9gePEsyK2NBw4WIKdgSV7jVHp1wuEhMApVtAsh5C9TCUh7IIi+ddYgw8U3SEEIbF2kJNAafMlSHwPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tc7/bPV9N94WddRXDiDqFmgqBkTafVAG7+01RL2wNY8=;
 b=yAAOHzxSYn0AbmgCX2mnxnvkw8xk+Qd05lYiMZdHTfzsFS3XQGur6PcTkKewNsJjpLAv8OoNkal+0gs/tXce6duV3477QEjtrbV1MhFqQnXW9pV+j6l7+1tabkKGBTUNqV1KmNBWZuce/LIFf9GmI0bkzcrSO+YahfKLwa8/k5KPDU0MLCui6Amo16yNv5lo8ami0LzKx2c8+p3S7XwrKE+GW8J0WLZ/qP0BSffIQ5xoNhaiM+A8217ZWYkukrHxGn1vxNVenpUsG3vxLg01Gx8Wjwkfkp8/89UCJiyvugck2dZuiPh/57F7VZYKOmO1YKmdHrDN5hUwyw7QyN8lxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 04:10:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:10:09 +0000
Message-ID: <1071ba91-4b59-48a0-aa03-c604c079ac4a@intel.com>
Date: Wed, 13 Aug 2025 21:10:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 11/32] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0227.namprd04.prod.outlook.com
 (2603:10b6:303:87::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a422383-efa3-492d-caca-08dddae8757b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V1ZscSs3dlJFOHQyRFhZUlk4SVozbnpKVEpDSXVEZWQwRWhBYXNtbWtlc0JW?=
 =?utf-8?B?eHdSWk96MTROZVFlTUl0dmZ6bUh1ZmFnVTErRitIR2ZWdDFnYjRqWkFhdGZU?=
 =?utf-8?B?RDhMbjlNSy9ZUFNzWXB1UU9SUGRzMC9uVEcrcFF1M2wycXFFYk5KZk5IZE1a?=
 =?utf-8?B?VE1EVzlqVndGSlVaaS8vRHBXUEN3ZTZhUFJTMzh5MkUrd1R1YlcvOThlNGJn?=
 =?utf-8?B?Q2R6R3lEYUFyVWNDOU52ZGVLTklqZVI5VEt5MXBXRUNidU91aDJwRXRIVWRZ?=
 =?utf-8?B?aE4rVjlPc2FqbDEwcmJTUU1KTUFDTjJLZEE2NDR6elRLM0owelA3QmhtczQr?=
 =?utf-8?B?SjR2b3pwazBvKzA5Slk1VDFaQ0I0V2s1aHRXRWZONDFRK2hXQ21rTU9NazlF?=
 =?utf-8?B?Q3ZobGJsMWxGWkMwU1dYK3ZHazVmZzZSUEh6UjU2WXd6ZWJNOHdKbjdrVk9K?=
 =?utf-8?B?NGlmSlNLQ3JtOEhQaHAxVVBZWUt1UlpHdC9IMm5HbXl4WTFJc09UcUJTRXkr?=
 =?utf-8?B?dFpJanp1dmQvRmhjU2hxQ1VSZ3NjeFp2MmZ5NGtOV3YvL0U2dDJ4OWZmQjVV?=
 =?utf-8?B?cU5tLys5TW9jWTR2RjRjc2tEMVoyTnEwamtBSlNvb0lDTkFhTEY4U0dxdXBI?=
 =?utf-8?B?WFpPUzZZOTVxV1I1L1ZQM0dZeXFkU1pnd0NGVGErQ2R5c0taUElYU0g4dGU3?=
 =?utf-8?B?dkR3cEF5SmNST2pPMUk5MVh3YVF6QXpha256R09pNVM3amJZWTBqaXVYWm1J?=
 =?utf-8?B?ZVJJdXY3ZzJWVXFJYTlSZ0labTNURDVZUENBb2ppTnZxcjdRbmR0bURvRVJ3?=
 =?utf-8?B?MEFYYXN6ZE91SVFPYm1NaWtwdDVScm1NdDlMREMyQ2RnN2IwbzlRWkRyb0ly?=
 =?utf-8?B?Qk9uWUd1dTZYdHhWZis4dXpCSnRSRjdHTmdBaHBUVjQzdmtkZUVsK0lMR1RZ?=
 =?utf-8?B?SlpDQndMYS9OT2xVUUE2UldZVlh2RFpSdElQbG94N1VORzlyL1FjZUJFTUZC?=
 =?utf-8?B?cXZPYTFteElDU0I0a1lRR09GeEtMOW5rZnUvTFo4NXlxdHZ0QURCcFkwUnVC?=
 =?utf-8?B?b2RWVm10b2NQT05OanRzNytrZ0NiS3pQZ0lkT1U1NVUycktiWnowd2hmazJE?=
 =?utf-8?B?ZmhvMW5lRkNUYTdxR3NWMmhxYnhLbkh4WW84dVVwVElWaDM3RHRQSmU3OFVZ?=
 =?utf-8?B?cFZtdWZCL1hocHVBSkFxNFRhSFBFY0k4Z2l6OU01M1BTRGtpWkprL3YvVWx0?=
 =?utf-8?B?VVdGL2plOCtGMDdpVGFpQVlZL2k4M1BjbzF0Q05Tc3NUR0JCc1FEc01nbVZE?=
 =?utf-8?B?R1kyWUh5OVVmd21XajU4ZWo0bExYRnNMWGhnd0JSQVhmVFlFb2FPKzVBQkJF?=
 =?utf-8?B?eGJRU2pIQ3l5UGxkRU9iMWorQ3RjWFRUWFRPZ2Yvem5pSm92MGFkZURRVGFZ?=
 =?utf-8?B?aHBFeEFya2x3dHlRV1YwUERXejJ0cndqQWF5YWN2QVpyUlNQZHhzUWVKU29C?=
 =?utf-8?B?Rnc5d2hXbnlIdTNFTzR4cEYzV1c3d05LWWEyR1IvMXZyZkhRWVRoS3N5TzFq?=
 =?utf-8?B?ek5Zeko5NHg1S3FpTENGZG1JUUx6TGJXcXdPNXlvUWhQVGxrcFR1SjdPa0F3?=
 =?utf-8?B?Nk9kcTZzQ2Z4ajJnemljOVkwSnQzN1RWdVBZQnZtZ3pkdnUzK1VHNjRwbHJ2?=
 =?utf-8?B?Z0Rxa2dWZ3VMdlg3amNrSTVDZjRwSytNTCtVVjZFdnBNS2FQYytKbWthNW82?=
 =?utf-8?B?NnB5U2VLYm9rZTl4aWUrVjM3M3pydit3SnNwVGs4dk1oYVNlNXZKTERsSHpn?=
 =?utf-8?B?cUJQNzhmMVcweVBSY2RiV1YySmZYYU11WFZkbkZ0STFjVW1IQU5XRU9DRUVi?=
 =?utf-8?B?R0gwRmdmTUNxamhoeHpEY3MrR1loVUxxdXdQVnAvVUhVanMzOThLWW9Ib2Z3?=
 =?utf-8?Q?4l+lCL4Cdbs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L29waW8ydnJwem5DMEg5aE9EYmtUUVRsT1hVbHJmSHV0SnZuN25xWTNHNE5u?=
 =?utf-8?B?VnU3dlZWdWdRVDVXM3ZuNmVFdVkvajdlUjRMZTNWQ1k0UFFJZ2t1ekI4b3J1?=
 =?utf-8?B?UFFSRDBDWTExSU1UcDdlTUtoTlFDbDJzQzZJdWt2a0N6RytxYzMzNXFEdjNr?=
 =?utf-8?B?ejdyM3BjTUxDa3FXc1o5U2ExTU13b243NFQ1TDZEbHpEWEdEdFlMWlRGYjFs?=
 =?utf-8?B?QTRLS1dsck5sZHNDVXR4Nkx0ODlheGd1ZTB5WDVyTlo3WitrMm9wcHV1RllI?=
 =?utf-8?B?RUJMTmFvZ0RhNDdVdXVuSjRLT0ljQ2ZPTDU5c1RKa0puZFhNVWNwZ1BneXlB?=
 =?utf-8?B?MjFOMmlHdk1xY1VlZFdBMlViZGVTck5xV21HU1EwNFAvZ1Q1ZUN0ODVVSnVI?=
 =?utf-8?B?TnJkbFMzRm5Bbjd0NGk0YlArc0pVSzBNVlMwUFVwSTRGRzRKak9tb1B5dmNt?=
 =?utf-8?B?Rm5sTjdFS1Q4VUdjU0hKZkl2Y3A1OXp5OGVBVUZvS2s2b1ladFRRTG5wT1Vs?=
 =?utf-8?B?cTljaEhGS29TYXR1QmVVT2RxakRBcUZoSmRLUjNSMGpyRGF0L2RyZ0tsUjgw?=
 =?utf-8?B?Y1ZZMytSSFFrUk1DemNuMFVZZk1ST1ErKytCQm1EeURlZmhTd3F2MVYwdnRu?=
 =?utf-8?B?bmxSbjN6STRmOHBZbEJjWlJMdmpYb0FxNDEyeHp5N0kwYzNGOU9CcXltK01x?=
 =?utf-8?B?eVRDeTdhMHhGeTF1WjJhMUJFNTVqZ3NsRUlPSU5EZm5GMVV3cDBjRnNYYlBI?=
 =?utf-8?B?TnRWRVMyVUpKOWd5NVJZSDR3TnRXMDZMaXJsYXBRSE5mTzRLWmR5MzVUM1di?=
 =?utf-8?B?UzFDMUhaZzRKVHpJNzJNdHVDdGFUWWJxVnJ1all2dWVJZ2ZpSndTdU5aRVZT?=
 =?utf-8?B?Tm1YOElHRk90cUJiR0NEMGZoWDRQYXNIUUcvd3lnQ1h4ZHpWaDlWem1KK2Vv?=
 =?utf-8?B?eTB1d1ZVblJvUmhkNlc5TzhEeVppem11M1pMQUdYUFFTWVdEYytTZ0RLVlZ3?=
 =?utf-8?B?Zk5ZZ1JKMGZkOVRwVVdGT1BvdG5SMXBPSDE3OTZHdzdYYkFqYjVReVRaVWw4?=
 =?utf-8?B?ZmhYQTBXQlZ5Z3pWVUNFVUNncEprUmJ6ZDVYL0FsRUQyb3Z5d0hMTzR3b3VI?=
 =?utf-8?B?VE1YSTZCa09OVTFQUVRCL0kvOU9OWXNoODdxT2pnb1JKWEZ2YXFqR0dZZmxZ?=
 =?utf-8?B?TUp5Sk11RWJFTGMyRWtYNnVOYnhERkgrZndDQWJ3OFhJSm9yVTEyMEhpeitK?=
 =?utf-8?B?M3ZhR3QwdDVEbWpHd3dITmROZnNaSXkwZHR0OUREK1hhV05YOHpGU1F2Vjl6?=
 =?utf-8?B?UTQwNzMvVWZhQWo1Y2lVV2trVmlJL2FyQUtpTWdmZi9sTGlVTldXRVBjSWtS?=
 =?utf-8?B?cjlJbnVYSlRxZFdveXZ1cStZZVNFb1ZNUzZnZTlGMko5VlpwMExDMURiQ3Fu?=
 =?utf-8?B?UDR0dnMzandwT2VpeDBVNkZ4VEdGVXF3U2F0WVdDQzRNa0hmZ1JmbU9wc1FV?=
 =?utf-8?B?eUVJWk9rK01ndW4rV0toUlBsTlhXdzV6cHBqL1czeVp3U0pvRWtNS1lER1lX?=
 =?utf-8?B?dEMyOUlpcmxkclhVQ0RlUGg2d0ZUWm1sbEdJSHMybWFib1dRaVZxU0hhQU9R?=
 =?utf-8?B?WDZ5dlM2c0pLQW1oa1RkZGtqMmhIYWdRekFJZ3JCTlo2R0VWc01HN3NObVVo?=
 =?utf-8?B?Sk5lMy9lazExVFppUGVjODkzUm1iWnIxS05UNjZZcWNzN1E5aElyc09sZTk0?=
 =?utf-8?B?VWI1Y1g1MlU5ZGJzeCtnYWZSODlzWXN4YmVTRGdDWEcra1V6czFheFpXSmw4?=
 =?utf-8?B?aDZwalFuaE01ekpmTDBMNCtyY2tOUlFlK1ZlYjdVZ0NGRXNLaFhDdUVwNXVS?=
 =?utf-8?B?blliRkxublBjbmdnRTRqRFRQQXJVdE1iMXRsWXAwcmxXbWNNZG1KN1FrWHF2?=
 =?utf-8?B?eWlXbENTZ2N3Z0oySlJqM2FJUXRHVTdIOFFZeFBlWCtBTFRBWUJmYUFWdHpT?=
 =?utf-8?B?UFZKdGRVTkwzZjBCYWpiZkpDN25DVEF3ZXY0VnBkaXE3ZktIYk82Sm9TMUlO?=
 =?utf-8?B?MmRoWXNYMzF3UlJCYU5XMnExOWJqQlpwMnZhd0Jkd1BBazJuSmh0eFBBVXA4?=
 =?utf-8?B?eUlRaUV3TEJ0aDltay8yZi9CdkRhZnRIRGEzckp2OHlVVjhxTGlTekkxekR2?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a422383-efa3-492d-caca-08dddae8757b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:10:09.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lp9GJjD8KRNq7Yl1OaHCIPbZfbQS9Efu2PNiMyQWUbm2kpyScTJaVWQRfyfFG2+2lnH+mb/qZrIZy5ZPUsdDp0pzDVCL1iJW02Vsp4prEXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> All monitor functions are tied to the RDT_RESOURCE_L3 resource,
> so generic function names to setup and tear down domains makes sense.
> 
> With the arrival of monitor events tied to new domains associated with
> different resources it would be clearer if these functions are more

"different resources" -> "a different resource"?
"these functions" -> "the L3 resource specific functions"

> accurately named.
> 
> Two groups of functions renamed here:

"Rename three groups of functions:" 
(correct the number and make imperative)

> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Initialization/exit:
> resctrl_mon_resource_init	-> resctrl_mon_l3_resource_init()

"resctrl_mon_resource_init" -> "resctrl_mon_resource_init()"

Up to here the renaming was consistent ... the previous patches
renamed the structs to have "l3_mon" and the functions up to here
changed to have "l3_mon" ... and then these last two switched it up
to be "mon_l3" instead. Having a consistent term makes code easier to
search and follow, could these also use "l3_mon"?

> resctrl_mon_resource_exit()	-> resctrl_mon_l3_resource_exit()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

