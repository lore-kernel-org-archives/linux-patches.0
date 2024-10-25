Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C935320F3CA
	for <patches@lists.linux.dev>; Fri, 25 Oct 2024 22:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729893610; cv=fail; b=t/6RXWhKQJEcc2/WNT5Iuv6WKl+rAqp9eOCkSUGRFDYpGps6qItLasbwUJoOTPinVNhSeSz9pYrE8bRtS7+h8z7FtTSBa1dGCxx/38OxrvNgmbcuzXMruoVgUXYL+OsgijyqHUCNmvMT93ALyZSu4I9ODGdJ0k8ViBBMs5wqiQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729893610; c=relaxed/simple;
	bh=95OdYgZT6YxlGPV6l3wAR6kgucGg0/qiOkx0CrRLCAU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nGu9sYl/5t7T6iNS1XvC28nitXZzuiwmq4gLHAUNtiEbVVXl83BC4+ouy9jJ9hwvD5y0Ake2Y5r9T+xHvOXTEmpXf6vYhD31QRmxoRPp4T8iL/E+6ucYX2Toigt40mPiyHcEyBhs8cMbWhepwaw6l48OayRe0qSxkjsUg+yj8Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SR+LfxKi; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SR+LfxKi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729893609; x=1761429609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=95OdYgZT6YxlGPV6l3wAR6kgucGg0/qiOkx0CrRLCAU=;
  b=SR+LfxKi15lPgt3s/54qsrgQDCfUd07Sk3pEMthQZv3905ZDtDJnGi5y
   as5c/PbHC72fakYFYF7mOCZi5wTEblw1WoAq8uTKsCLUIiLerhe1U//Je
   0B5ekMlrUfxPktrF2INmKgQFM5eBjoD2A+EM+EwQb3nCcysDdSnaqDOVk
   fWkP84mkbeMJix5zuGFnA2aqzFg6IBVM6eYivjUA2kNtBTRnZiGDKOgYS
   NJXjeMHZkp9GCWzsnLLl5YMtwJtlC9lEqoU1/xieX4Rb0lHrHmYiMRmky
   hrie6kvl6Lpio8wiqI5s+lDwmyQnRmj7X14nWh7QcJpbAtzyruggfynhw
   A==;
X-CSE-ConnectionGUID: X6gsSiH8SG6plt95KyLhcA==
X-CSE-MsgGUID: 83tl33IIS/GO+vcaDUBZ9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="17209158"
X-IronPort-AV: E=Sophos;i="6.11,233,1725346800"; 
   d="scan'208";a="17209158"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 15:00:08 -0700
X-CSE-ConnectionGUID: 5MbMC/hPSsy+Gu0w+lPhVw==
X-CSE-MsgGUID: i9rBcu8JT2OtaKznInG+MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,233,1725346800"; 
   d="scan'208";a="85007806"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2024 15:00:06 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 15:00:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 15:00:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 15:00:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EVdXjVON0cJH4gvkcyIEvFksPgfqYjT8A8Wd9PI0uTt+Yolfe9WuK+hoKb5Vo4UjD/ncw8crsh/1Ooch+lnKM7D4Za+dIpmgKfzsdbqM3c9QqjdqNaawjSZofMMaCE9vffh4jjhzlbr+mD4Rw2dJjNU+phwKEQPPpDfrGBe9Wt7Y3EQAnoPzP1Zv7vlVUQbsCXYZL2i4SRZr0491TYL/3sXTNfeDHbXuV1jWnwt7rGjsxHA4IQqCO/K8/LNaTmF4LBiSqbwZbXyxBNo7HgeBTAQBEblJFwpDGGJNLYpC6xiaiGie8UXsjpN0VWd2WQhcgFJrQ2asCHrgfahTnkkstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpUu+p0bJHcTDhv5Cs8chaku3jEWQG9nljDfsn8HY9M=;
 b=l3fIlVrYL/zuCMkPS8DJln2GJjf0NYKZLkawcPEZHZwzh6tLfK6l9Tib4K3R5FvMz4wAcOHuqFg4v3ledzXL62BxwUJEAiWAWnX/wODV7lrayrgjsRZmJWo/rVzBVEhU4dr1uWr7Ac/xkndLLf6Z5Qg16qo4vU3lnN5wPIaIcvjfPo62iBsk+cw85SEc266Lk8M/gE6Jpv28L0BcAEvrU5rlQy/rk11xu9721DqIbvxZuIsYU+DjG19x1Jodf5tbsIOnnMJIF5TYp6G0DVm7HSmG6nb8t2vddVPOaK7Pr9VmLtekuNdkYwNLQG7c1jXjafKvIGieg0uteueFi/qJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5079.namprd11.prod.outlook.com (2603:10b6:510:3d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Fri, 25 Oct
 2024 22:00:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8093.021; Fri, 25 Oct 2024
 22:00:02 +0000
Message-ID: <e09feea2-6024-4196-9096-c1be51bfa375@intel.com>
Date: Fri, 25 Oct 2024 15:00:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/4] x86/resctrl: Make input event for MBA Software
 Controller configurable
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241003191228.67541-1-tony.luck@intel.com>
 <20241003191228.67541-2-tony.luck@intel.com>
 <bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com>
 <SJ1PR11MB608328D2D772314AF62A2A7AFC4F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB608328D2D772314AF62A2A7AFC4F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5079:EE_
X-MS-Office365-Filtering-Correlation-Id: e4be587a-92b7-4824-809e-08dcf540603c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ajdmYzZQbW0zdW9DMXF6cTN4eTR2UlJHT0t4c0VQSWpmQUZhcFZaL3RUMklW?=
 =?utf-8?B?SWJSR0FYUWVoMmMwRTFDNzdUN1k3MGZFS3dhZGFreWJSZWpkYkZrUzB1QlJu?=
 =?utf-8?B?U0hJSVdFWG9DREQ3aVlkb3JKQ0hqKzZPLzBmbEVIY3UyOWljODF4anpGSGhB?=
 =?utf-8?B?RHNiQzl4N3pwSGErMHV1OFRCOHpMdHRYeVltc2pVbEljSjFnRzRwSXNsbW1x?=
 =?utf-8?B?MlQwaXVxcVhiQnc1eE5LaDQ4YmVORUlVQS82VW9lUEhXZ0dOOFU1YWdxYzJP?=
 =?utf-8?B?YWdnVEh4R1RtU2hsaWRDUEJZUmFJcXVnOHV5UnFFMHM5dHdGYVlYMWM4VHVh?=
 =?utf-8?B?ZUc3ZDBxaEwvbjZXd255YXJVNldubFlyRUdFUTcxQVF4YURQdjlnR3dEc3ZQ?=
 =?utf-8?B?aFNYSkdOOVVQdFNvQkVJVWoyTTdGUTNraG9YYlBBWi9SK05qYVVVSTE0dDQ2?=
 =?utf-8?B?aldrVzFwSG94WmJVaDV1cW91YU9jTGF0VVZneXN4dnFPQW1scE8vNjBLTGxX?=
 =?utf-8?B?aVQrK2FXcWlhdkhMQUllNTRRanBrQWl5eWxEUFFDRmxzbFJLT0dCdGZyK3Fy?=
 =?utf-8?B?WTFxMnhJMVFpRWI0ZWZqTFl4VzBGemFwWnBQVTBiV1JWTXVwL2VnLytzUnFM?=
 =?utf-8?B?VWJ4dW5KeGVGSWZac1FjZDFGQ2FoK25USVBaSDFoR2lWRytlWDJUeGYvRS9H?=
 =?utf-8?B?RzhLQmpFYStXQnptVCtRamdVcDZKd0RhZ3FuUStVLzNvOE8yak9DMTJ3WGdT?=
 =?utf-8?B?bm5QcFltTDFJQVU4a1k0K0FWUENoUlM3YVlEUlRDcW85OUNBclRpYkVmRjRD?=
 =?utf-8?B?ak05dEROT0pwazhRb0JGSDhxOXFYQWJwM25DbUFkZ09tN09CYWJtcDRFaFcw?=
 =?utf-8?B?L2Y3aDUyOHJDM0EzR3J1amQzb2N4ZWF6TFNiWGVxRFlZUE4zcEhIRVlrdzJh?=
 =?utf-8?B?RUtaRkhVVUVUUEhXOWZCcnpFb284VUZNWXQwVE1vWHBXWEFUYk1Ncmk3U1pW?=
 =?utf-8?B?V2hsV2E5bFoydzZWdSs3aXoyTDlhMDNXVkxINzJkNTZQRkFTMXdGbUxzbjdh?=
 =?utf-8?B?elVKVmoxVS94LzFNbWNlQko1eDRsTVZHa1pwc01vNURhNVlsMmJ3RDFOdTVJ?=
 =?utf-8?B?dlhwczEzSm5CVlBueVY0WTgvb3AvbTNDUC81QllxMk8yVForbHl3Y3Jwc2Qy?=
 =?utf-8?B?NnRlemljZzhkWnFub1U5T2tnMzBMVy85ZjFxc21BcHBqVzdMNERNTDJWeWht?=
 =?utf-8?B?dUlsWDNJR1JMVVhTQzhlV0pIcThrMEptZmtDQ1kzTGYvTXU3VjRLWmduRGdw?=
 =?utf-8?B?VytHa1JUajRIKzZSM3pOLyticmc1MURFNEdQTlRPTDNCTFBXMUplRTdHcjJQ?=
 =?utf-8?B?NzN3SjJSWDlUOFVwaHhONnl3cXdVRVZPMkZaeVBRUjJrSHRGKzRQekplNHVS?=
 =?utf-8?B?UWR6VlRSYkU3MnNPKzhDbldmRnB3YjhLSjJ4NHBOOUtWUzJaaW9vQ0xtalVl?=
 =?utf-8?B?YVhhRzNlZnBuaHBqWDNZWVprL2gzSUxxZ3Q4eERmVjgzdk9lS1pmWFNPNTh6?=
 =?utf-8?B?OXJzdmFOZHJPRWFSWDhGT2NFU2tkQno3WWg2MVovUXJtNzR3dDNxZFdxalpo?=
 =?utf-8?B?S2Q0ajJKdEVyRWlUclQ3V2RSeFBmcGdVWFV5bi84eXNTbGtMcGJydHl3SDFM?=
 =?utf-8?B?VmxHL0FXWnNEQkxTS1hPZjVaUHB3N3QwYWhMRTAyRERSSzJINFduVWVDeXdS?=
 =?utf-8?Q?NDlYp5QsFReoMj9yQkpc6QOWsMQJgVYouDSXIw7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHpBWXRaa1B5UHFLSWJUWDFGYUVNbGdENFJ0MlFUZDVwUUVVR1JiWkljOHNZ?=
 =?utf-8?B?aGpiczA3T0haUFpidTRURTdVbkNjd3hMUWwrZzNjVlVubHByczJjOG1xUVhZ?=
 =?utf-8?B?Rys4K1dvbjIwYi8vOVR2MG1nNGVORTlmUHQvQkZPSWtxdlBZdEJWRllmY3lL?=
 =?utf-8?B?TUJpR29iVENDOVpPK05yL2VZYUxnSnB1RE1ERDVmS2RCY28rL2dYMjlWdm1B?=
 =?utf-8?B?b3NsckJDWUROekUvdGI2SE1CeTFvd0JZbzdDbVhqcUYyQmxOc09WUzE5OVFR?=
 =?utf-8?B?R0hmN0plclU2UEpuRjFDWEJoYUdHbmZmOEY2QSs5bExMc090ZnZ2VDNjU0pS?=
 =?utf-8?B?WDNyN1VEWG8vcmpKZzB5aGVsWkJUUzJNUExsdTBabkl6Z1RhSk8wSjRXK1Zn?=
 =?utf-8?B?SzZNTFcvbDJsQmZZdmxUWGdtOWRQeWdlRlJCUW0rSEw4NzZGWHd5Nm82V1Nw?=
 =?utf-8?B?Z3ZJUWFYVEpMQjlFd1E1YXRDVEJ4NjFuL1VwY2x3WTFBSGxMMXNvajIvTzg0?=
 =?utf-8?B?MzVJQURJMGRvVEVvVmcrSkJuSFdkWC9ySzdrYmExWmZDSDFtTlR4R1FTdk1m?=
 =?utf-8?B?T2FnT0ZxTWdtTzE3REpMM21oQkZ5TjRFRzEyYzNTMDVBTUh2aWFQQmpyMVFP?=
 =?utf-8?B?L3krNUFUN1pnaWh1YTRxOEU1emVhL3dHMkJlcHgrbjVTaGMzSDJ0SzlSaFVW?=
 =?utf-8?B?d0c5SCtPYnFzZkVPWTJQKyt6UkFYS2dJKzBGZDB6SjdPK3FIUlEyaTFGQnlX?=
 =?utf-8?B?NTRvdDBvcERRVkhwemdCTU8yYk5TNDhRRGpZNlRLRllEbG1SMGRTZlhjLzVT?=
 =?utf-8?B?Y2czQXZlTEZVcklNNEZ0clh3SWVJdnBLeWVxZjRSc3c5SjZHOEY5VmMzU0gz?=
 =?utf-8?B?cmRvSUJ6QUQzcyt6dHBDUFpmOTN2RGg5dUtMT3JVVC9hVzFUWmp5KzF1MHZD?=
 =?utf-8?B?bllWSTduc3JRb1Jjd0pwSEhwbkF5Q08ycGZSRGtxMjNGU2xSNTFRTzNBaDU1?=
 =?utf-8?B?ZXJ5V2JxWk9hUk43a2sxOVBBN0JaUmtTWHgrb0FoeVJoQVNkdVpJa3ZSWUkr?=
 =?utf-8?B?Qm9uUndQQ3d4dTdWNGxCSWRxT2NlZExZd0hnMG9kblViUytRRDBEblR4Wjcz?=
 =?utf-8?B?bFpPUytLdGhIS2k5b0ZoVW9yTFFOUEN4dVl5aXU1WSs0dXFiTUs1MlR5MC9i?=
 =?utf-8?B?Y0lhaEFmOTdWUHBLN0hKcGtkTEp2T3kzemRXWkloZUZNc0daOXFWRlBSS25w?=
 =?utf-8?B?UzVYUnJYc2hMMkdmdWVPV2ZleWg2ZUEvWkE2WFpQc2RDVDVxdTdRMDBmNGs5?=
 =?utf-8?B?SmJxaWxpb3RQS0Y4ZWpheUtwVkRiTjQ4YlRMV043L0xGL2lPWDBLb0tHMnBX?=
 =?utf-8?B?QjVBb0dOcndkSXRtaWYzdFo5MmlpMlliS3hab0VwQlF1MStHVmxJYkZJZHg2?=
 =?utf-8?B?dkQ5MU5pSWZuVng5S09qNnRVR3F5cThmL0hSSjdESTZYWkFUTGkyL3ZqeGlH?=
 =?utf-8?B?TmxxR3FhNnQxaXVBYWFScmp2d3h5aE5uVXBPMzh2OWl4aWx6K3NURUxSUHhh?=
 =?utf-8?B?QjdOUm1vUmJZckpYS3NBNCtkb0s5RFBmWnFDbUF2R0hNZUlhcklRNDlMOUJX?=
 =?utf-8?B?WU1nS1B3ZVA4aUs3dXpNWXAzRWoxSytxdFF0bWdtcm9kbW9jcW8yWWFEKzZ6?=
 =?utf-8?B?dmlkRVo0UXlsL0htNUNFbkpPUkM3dWs3RFhxNnR1ZnUwTk9IRllnVC84Wm1D?=
 =?utf-8?B?bTFmMDRFNEtpMHhHVVZqa1k0cDBqd0hqWkdCc1NITXBMMEErUUFMdmlsK3pQ?=
 =?utf-8?B?dEhNMDZuR28yTzFuWi9OMVBLcytnTmFvTy84eWxrdUltdUJ3ZHhHVlkzM3Nm?=
 =?utf-8?B?WHN6U0ZqQmpoWUVoMGsxK0tQUUhzSk02V2NzeXA0aXJaRjF2Y3BQUWxyYlUw?=
 =?utf-8?B?YkUwcG1IR2lUQzV1Vnh2cHBNbERsODdPNlRGWFRqQWRpWlNHRjVvakZZdU0r?=
 =?utf-8?B?UW1ZaVVpczhHV2orWURhQWJRS1FCcW9UQmEyRy9tTW9CVzg1QU9FNWExTXNz?=
 =?utf-8?B?K28xeXgyZzBrSUVKdW9scnlZSEhScnNrZGZZS1VybVNuT2pTN0U4TEVSRGd6?=
 =?utf-8?B?N2paaXZiZnozN3ViUHcvOEZzNWovd25DTys5WW9lWG91VWxLMTIxR0lOM1ls?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e4be587a-92b7-4824-809e-08dcf540603c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 22:00:02.2508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H989+Fb02pySxZrfM9qg9HIoU39whe3gvGKhqJ1XAdrRFIQnU1GK9I6POhHkleoRzvxtX8RhDxYDslQ2HdnQBKR05dp+RQcAyBjhiLivm14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5079
X-OriginatorOrg: intel.com

Hi Tony,

On 10/25/24 1:42 PM, Luck, Tony wrote:
> Plucking out just the big, direction change, comment for discussion (which may make
> several of the code comments moot).
> 
>> I needed to refresh my understanding of this work by re-reading the previous discussions.
>> You mentioned in [2]:
>>       I tried out some code to make the event runtime selectable via a r/w file in the
>>       resctrl/info directories. But that got complicated because of the amount of state
>>       that needs to be updated when switching events.
>>
>> Could you please clarify which state you referred to? I wonder if it may be the
>> struct mbm_state state maintained by mbm_bw_count()? mbm_bw_count() is lightweight
>> and I see no problem with it being called for all supported MBM events when
>> the software controller is enabled. With state for all supported events always available
>> it seems simpler to runtime switch between which events guide the software controller?
>>
>> Thinking about it more, it seems possible for the user to use different
>> MBM events to guide the software controller for different resource groups.
>>
>> If it is possible to do runtime switching in this way I do think it will simplify this
>> implementation while not requiring the user to remount resctrl to make changes. You
>> mentioned [3] that "a separate patch series" may be coming to address this but doing this
>> now seems simpler while avoiding any future work as well as confusing duplicate ABI
>> ... unless you were referring to other issues that needs to be addressed separately?
> 
> Yes, the state maintained by mbm_bw_count() was the piece that worried me. After
> a user switch to a different event there would be no bandwidth data until two updates
> passed by (one to get a baseline, second to compute bandwidth). So update_mba_bw()
> would need to be aware of this liminal period to avoid making updates with no data to
> back them up.
> 
> Your solution is elegant. The cost to maintain bandwidth data for each event is indeed
> very low. So there are no weird transition cases. update_mba_bw() can immediately 
> compare bandwidth for the new event against the target bandwidth and make appropriate
> adjustments.

Thank you for considering it.

> 
> This requires a new file in each CTRL_MON directory when mba_sc is enabled so
> the user can make their selection.
> 
> Note that technically it would be possible to make a different selection for each domain.
> But that seems like an option without an obvious use case and would just complicate
> the syntax of the new file.

I did not consider this possibility. I agree with your assessment.

> 
> Maybe name this new file "mba_sc_event"[1] with contents that match the names of
> the mbm_monitor events as listed in /sys/fs/resctrl/info/L3_MON/mon_features?

I do like that the content is connected to existing user interface by using events
from mon_features. What do you think of connecting the filename to existing 
user interface (the mount option) also by, for example, being named "mba_MBps_event"?

> 
> So default state when resctrl is mounted with the software controller enabled would
> have:
> 
> $ cat /sys/fs/resctrl/mba_sc_event
> mbm_local_bytes
> 
> User could switch to total with
> 
> # echo mbm_total_bytes > /sys/fs/resctrl/mba_sc_event
> 
> On systems where mbm_local_bytes is not supported default would be mbm_total_bytes.
> 
> New CTRL_MON directories would also default to mbm_local_bytes if it is supported.

This sounds good to me. Thank you very much for considering the change.

Reinette

