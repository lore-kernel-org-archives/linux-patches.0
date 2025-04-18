Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBC1B6CE0
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745013095; cv=fail; b=FedQrmr5cZ50V8IeLrtzXffwc1m7op/3EzM+w/XAciQqLBIpujGDAfA2KC5Tv0A8zFYMPhe1bBdZPUBfoCOADlCKuNxM1eRA8oa6tFx7XGjnVYDw1RqW41Wh5nKQFLDh6TU8Wc5jk/TQdLP7UdcpyRrHUWucGdsf70LhnWITBm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745013095; c=relaxed/simple;
	bh=RjWTZdfqpOSLH0ornENZ7a2/ZRI5PfvXogOMO5l88mA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZeP2FE/6nuOPJnkx+oc4QfLa8S8Uf7zX24OTIKHw9421l4oWesNj12iwszHVv/Yr3oLeVDGVPfa4AiPQM4BHPdpfGk+oBSP4jKcfyzpsv7BinFDZ+qOzk9rmp8sL1fevwfMkE5lBCKB6qFJCvRts8Ix4V4ptoy0E/H+IZ9iw7yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SmSZu7P2; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SmSZu7P2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745013094; x=1776549094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RjWTZdfqpOSLH0ornENZ7a2/ZRI5PfvXogOMO5l88mA=;
  b=SmSZu7P2eEUhU8rQwGb2ZvzNQC0H5J04++Bb8zzznMOAjgEIYHdodLYJ
   G4EpfSdQh0zlxbuYv8gyVh39YM27doOSZzI0o0xLozVeytW/D+SIJHPsB
   hEw1vvCD30gW9uVuaI16rb1CClzcCaHZAX24WhW0jl9rvDAj/Qvgk+7iI
   qMAoSG96Emm9f+k9qUo2IpvJclnBiml33X4+3rZXV9gdtPhy3Kl8xMT6i
   GhXb+eAm0lQSbMJ8oOKLRujMldNSGrogR1FBVjtx/gBqh9Wxo/wiJkSO3
   ZcmwPvY3Qc8Wu9gxYHSri0wMyEquv9dcgEuiKLK/oUkymNVA17cCTI/i/
   w==;
X-CSE-ConnectionGUID: 8CImUtffRgSfkL1MGfxlpg==
X-CSE-MsgGUID: sA5iIW8dTF+fontA7sXgJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46750191"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46750191"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:51:33 -0700
X-CSE-ConnectionGUID: Q8cqF31KSv+2YTSzaYduGg==
X-CSE-MsgGUID: S8uZPdjkTSCnmG+IEFXTNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131194393"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:51:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:51:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:51:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:51:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxAGab3vI/Qqwj9FLMeKgbiDVLI+aJU+hxwXoQngs/Z1P7n37qx31SLH2PXInnC2xyIu8SrPOmdujgEUlKYUNDcDzRnnDsnsCveKJP4zkJ+f3FU2JdGTPBrJNsAlwL2o9BNZDMv+j5vExiIGD7iAqc5XHnwcWPyxIrG1jr4k81/A/NxdzDhaBNV6BL9mTdkASGtmK6s0TcvQrHYCvzyTEKWC7leMkwFUDQcNhdRrIfq1hqWJmA5Pn8f9RsNfjv3zEcAMe6S8HJwsfsf9fsLl0gWljFWoIZZjzw+GbED/c4wsCr47F2XEr0DZLc6yJ408jC8O6xr6drPzmxYZQ7dFig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXG4ffZIL62SvEwJFiFjsWewJOCJ58PpqehKw1cCn/k=;
 b=bY/QoRMBScmmBCXRRYmMO8UrA4Pa4BcfIXz6E2KSeUvi+s3iUBoiu/jWuHD4euu6DB+hfvEj8Ff3WOEDkXwyFjcQYeeuR8D7qedPYOpDzTxUweqqnLYP7p7yOgy+4JjCe0HevAlcvKnD9IjCpJEMKitj69z327UmUBNL72lMdaCBDtTBAowfsbeZMkKjvxzk7PRMhqI6OLUQYnfhWvIqYWKA3BGJCV0EC2IURHPwAjfYOYlE0c3a9EI6+d1aJc+p3OjfMlvvhsfK5DJ6l403MKYdIqWtv9NkWz8Sm323RMBkPfoQEg267d+vj2qTQjckGqL1+sl6Re/CJvN5ovPpnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6986.namprd11.prod.outlook.com (2603:10b6:930:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Fri, 18 Apr
 2025 21:51:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:51:03 +0000
Message-ID: <698ab022-b6c1-4fca-b42d-26a3b4b2b8e8@intel.com>
Date: Fri, 18 Apr 2025 14:51:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/26] x86/resctrl: Move L3 initialization out of
 domain_add_cpu_mon()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:303:b7::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6986:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f60d49b-bda4-4e0c-e128-08dd7ec31d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q1JPZDV3bjlzNzFsS3luMnloUmpGSEZzNi8vRWlqL3l2WXA0bDg0elRlcFhn?=
 =?utf-8?B?eVFsZTRJVDNsZVBNVDc3SnVoTGo0N2l2M2cxVk5KeXQxUndodVh3NURpTE55?=
 =?utf-8?B?eERPbUdkcWNJcHJmRkJydWJ4MXF0K0VWOHV5bWN2U0crYlFHTUF5ZlVhTVBz?=
 =?utf-8?B?dTZqdXlJZkE0UmhlK2dFb1Fndlo1VUtwd20zZVBvUitvUndRNkIrRzlqVW1Z?=
 =?utf-8?B?NmVXUmlRK3V6dkJhMEdhaElRUmJKVFliS3pOWG1KTS82SGorR3RUSktxTHBt?=
 =?utf-8?B?M3Aza3g1S0tCbHE2WGJCOUxXZ1A5SGhnZzFZNmVkL2x4YnRJRGdVRWp2b2Zk?=
 =?utf-8?B?TE9FODdwdHYxTmtCTFIvc2Z0aDI2SDg5SElJQk9xdFJFVGRkeE5FTisyVjZC?=
 =?utf-8?B?Y3VxVDQ0QTU5TndhaGs4dVR0Sm02OXpKQnV6MFNBMlJ4KzQwSzZCYlA2MVpW?=
 =?utf-8?B?VkJHT2xoQkFsSHkyYW5SNEpwcDNIRjVoS2ZEOGt3WkZGSVVTdmluS01TY1RQ?=
 =?utf-8?B?Mm5Fd1dQSk5qejJvdi9zN2s5WTVyRHc0TDFjeVlsTnQySGU2UmplSzkycGgw?=
 =?utf-8?B?clpiRlFDODBseGUxbWJ5dDhHSnpvbzQzZkMrZ040VmN3aUNLNFVlYU0rQmJO?=
 =?utf-8?B?MzVId3hkMmUxbGFVYWJMY0tBbWFaTWk1SFNnMzYrdEd3ZmNzUmF2Tm1kd0VX?=
 =?utf-8?B?YlBqS211VWZocWNkcXg0VmdFNVNWZGFkWnZPSG51OTRMZ2ZEUUxPWEdPWVdz?=
 =?utf-8?B?UERhWTVaSHF2eTFXaGxBbS8ycm9kN3dSSkIxQ1J2VUljaThPMC8xZDZlZ2hW?=
 =?utf-8?B?eW41VjREZHR6Q1dDSGRGN1pXTm9HcXhRTGJuRzJxNVFuZG1JcUNER0xwajNG?=
 =?utf-8?B?aUhFVVBZZXp2ZHdBS3UyamNzRXRVUVZZbTliZ0k3SXJhL0FpTXd6MVMwTWtw?=
 =?utf-8?B?a2xsN1ZTbUtZMVpxMFJjZm40QnY3aG5jR1J1UjI0T3F6UFh5eUpEMjFNOUhz?=
 =?utf-8?B?bHZHZDlEV0s3WDcrUWZiV3R0ZXhqSHozRXpHblBhd0RLVjVHdTJDNHMrQkti?=
 =?utf-8?B?aTlhc3pTVENUOHJlOHAwR3VLeHdya1lOdTdxUmNuaW1wZXNjdnQ2bGh5WjhI?=
 =?utf-8?B?N245elR0U3VLT0dseFUxNElGazVJQ1V0QlFwWnc3MzdXb3pTM2cyWHdRaUw2?=
 =?utf-8?B?bkEyR05Db3E2VGRSS2RCblZxQXA5QVNqSmZXaEc5WkkvMEkrcVJLRUJsWVlD?=
 =?utf-8?B?UGhJTlhpYk1IMDlHM3BBNHZhT1hyaXhnZ2dZbUIyak5WQVY4UWhOa2gwNUpa?=
 =?utf-8?B?anFNYi91OFJlRER4anpSRFltTHlIeTV4QmQxNFEwN2ZGT1ViMnlNL1creGZV?=
 =?utf-8?B?dzdCVlA2c0ZRckpndE1EaE5tNzFmajROQ3FNTzF1bytJa1hVMDFzQXhRRkdt?=
 =?utf-8?B?WkZjaExRQlNia2VHeG5vemZmR3B3ZTFxVUZmTFo2bEdNa2dNcWw3SGtFRURT?=
 =?utf-8?B?cFJCMmJ4c0JxaVIxL1Jtd1lWVFdUSXpyYlo2alphdHpDZmlyR1R2RlhHQW8x?=
 =?utf-8?B?NmlvbVFIcEZCZGNKZDd0Y0pneFFLV3NlUFU1bFd1S3I0Vy9lY0NkMlBITXBj?=
 =?utf-8?B?VG5pMkRDZDdUUnVUYjZvM1o2VmxBZWRJcGxKbU9XcGtROFU3RVFObEVGNE55?=
 =?utf-8?B?YVI4Z1A5bUpBV3hQSGNDeGkzYUIvekxaYVl2SkgvTGhqcjJadnBDT2xpQkEx?=
 =?utf-8?B?RTY2dndjRWRwZ3BaWmRwR2thUWpJNnVvMGdUd2psTlplcEhqMnVRcDdaRW0z?=
 =?utf-8?B?SlNTMTlyVHpNVFVDZTc5QlZhdG9PTW8rcGVyUXQ4Q1Zaa3hGR2VjNFNScnB2?=
 =?utf-8?B?ZXhXTEpEK2JoUjRMcDlqcm5EWFYvY2tMcXJubERiUm5tRVQyZ1kybCsvNU9T?=
 =?utf-8?Q?J7WiThOQG0g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXRSMTdVbURWSnI2eWh6ZTZLK0hBdXFjR3puRnNpYXZyK1U1UlAvTjdkRUV2?=
 =?utf-8?B?SXdrVzFxVzQxdVZsN0syVUlQcFA4MWNxR040UGEzbyt5RWhiM3h6NTYwQ1hH?=
 =?utf-8?B?eHg4ZHZ1akU5MjlVVm83dnlMT0pvbDBEUWRUVUE5dWdMNGhWV1RBZDRFdDdD?=
 =?utf-8?B?YlJXVmlGQ0ZYT1dhQ1BjL2hxYXRFbWFkUlEzd0owNGsyc1BxTFV2bHJBeWhD?=
 =?utf-8?B?cjBSQTV1OXRpc0VyR1JYRk9STEMvSmFrVHZEU2hDeGtLb1pOb3dsMDBrTlVV?=
 =?utf-8?B?SklhUDQvNjh6empoZmpnTjhUYlZVTXZ5MHlNVlV3NENjaWNzaG1WbEJkbnBS?=
 =?utf-8?B?bU1TTGdXY0c4aU9qQ2JJWTVRVTg5YkZLaTNUd2UrTndSNEVWbzdxTXYxbnJw?=
 =?utf-8?B?RGpUZHR4SEJTQnZHQm9jZnVLdFVwbnRQWnplckxhSmdzN3VDU29Sb1FYajJC?=
 =?utf-8?B?V21LOWxlKzVHOGdBamZQeTBUNk4zdlYzRFgyTGo5MVl6WXFrZDFHY0lrT20v?=
 =?utf-8?B?ajJDY1JYckoyT1pJcitYSWQ4VkxWY2V0MGU5MVgwT0pLM1l6aE5PV0dBT3Z3?=
 =?utf-8?B?NC9EY1ljaWF5YmtsMzhnbHd5ZW1QQWQzZDNhWnQzaVBOWi8xK0RramM2ODVt?=
 =?utf-8?B?OGV3NmhEbi9oOEdEbnJkNGt6cm96K2Q0Y0VFR3R6aVBldHJrdTIwNExzK1V2?=
 =?utf-8?B?Y1dXMlAvZ2tDdVVMdU01dmhURDE3dFRMSUxTUDhvNEplaDJvZzNibnZ2NjJD?=
 =?utf-8?B?N25qejBzVWREd2JoN3p3eHZuN1hMTXhDQzZXWUlabGVJRU9vNzZCNm5NWERG?=
 =?utf-8?B?YjFTaGdmNHI5aXNLNmN6YzNoeDQ3dmZnYmZUY1dSclZBejBaakRaWjV3MHVT?=
 =?utf-8?B?TEloZVNudHNHaldob3lQOS9LZHpleXZVVmVHNkxiVXMvVTZwSUJ5TjJ2SWJZ?=
 =?utf-8?B?bVBFZEdoSVR6V2NXd2xoOWJiWU9UWlcvdGgzQjVTSHE1b3kvd0I4QlRnSkI5?=
 =?utf-8?B?M1V3RWFSUFpCTFhlemNQY2NwSWxodWIyZDYyVisxMUpPMWdqQ1YwYU8zbmwr?=
 =?utf-8?B?QkszNVJTVUtoOS9EVERWWXBnT0FLQiszT1lZYkRkNkUwUFlsV2hydysrMEEr?=
 =?utf-8?B?aEVsNmpIallkNGpKeUVCRHZtM0d3Q0NEa0hmaUUwcXZtTE5JSzBzMDlmdmRP?=
 =?utf-8?B?OTVpTlovZFdZZE5SSUJNQytYV2tzdUpYRDR5L3hYVVg4S1RMZ2NxaXRRL0kw?=
 =?utf-8?B?cGdqMnBJenR5dEVtalVpZ2lEd28wdlk5cU02TVRqYWdmckhuTm1aaGllaUM1?=
 =?utf-8?B?VWd5UG41TktUZ2toSVlLTjBxWmhKdWxpdFo5VFRwenpBWEVHcFNsMGhBSGlT?=
 =?utf-8?B?QjVoL2syWkI3dmIwbHRFemF0cm96cFNJY1hzVW00WVJQTHd2ZDlwUWJETGdB?=
 =?utf-8?B?cTQ3dmZvNEIvS3FkdmpXV2ZFeG5FVE9CSmJDby9vU0R2OGZzekM2TkFsbk0x?=
 =?utf-8?B?SUlJUHZMbENYbFYrSnFFaCtMVW9NNGRBOE50bmNXOUZEbk5pNXpTd040dWMz?=
 =?utf-8?B?ZExUY0dZWDRpZy9hQ2VaeDNuSkdYYkJ2N3A4aEQ2VXJRT01FQ09zVXdqYmF4?=
 =?utf-8?B?QkJoZzREWmlsdGtKTVp3Z3E5NzJlck0xdDJBdm1FMFdJUVVwTHFpNDlhMDdS?=
 =?utf-8?B?OHBDNXZqa3hJMG5RQTE2SUYzK1haYUxlTE1JMllPSS9VY0xxL1E1NlA0L21Q?=
 =?utf-8?B?WEJ0Wit2SitVc3RlMmNuckxrc2tZN2lHYUYzM2c2T0MxYldvT2UrVTZ6UHdL?=
 =?utf-8?B?b0dDYXlvcXhRaVduQXhzcXVISmtzcm9tbXF2NDNXQ25tUEdrY08xOVhyNGJU?=
 =?utf-8?B?VGt5eVBlL25ucjlZbjFDenFxTWFFTHVMS0c1b0wyTmVCdzNyRDNQTUVvbGFF?=
 =?utf-8?B?QkEzZUZBUlB2SVpaRk9NaThFVlhMWEdEaFF0RnBQbUFDU0J1N2REdHBKWVRw?=
 =?utf-8?B?bDRlanpCR1J1UUk4bFBvSmE3ZGF0bEhJRzJ4U3Rla0NmQWFLbVZMekY1YTEr?=
 =?utf-8?B?M0xQMHdWY3hiTXF4NkdyaC9IaE9KODZrVVBHY3lybnVjZU5sRE1ON0dqclZn?=
 =?utf-8?B?ZWlUaXBaWElvNEF3TVFQRDFMVTlaSEtJVHhFWXI5dXM2NG56YkNqdXkwMEVI?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f60d49b-bda4-4e0c-e128-08dd7ec31d3e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:51:03.2367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QRaUXzQg2x4yK1HMvJwUD5X1Zq0v3x4Uvvi3jkM/b0AcLpMwBnb1e/TBH9NFCdvx8agVz1ImWqI+YhAMUgKg+mV2Lp9dGGtJK0LxPiv4pQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6986
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> To prepare for additional types of monitoring domains, move all the
> L3 specific initialization into a helper function.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 57 ++++++++++++++++++------------
>  1 file changed, 35 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index d82a4a2db699..703423b0be0e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -493,33 +493,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
> -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> +static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>  {
> -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> -	struct list_head *add_pos = NULL;
>  	struct rdt_hw_mon_domain *hw_dom;
> -	struct rdt_domain_hdr *hdr;
>  	struct rdt_mon_domain *d;
>  	int err;
>  
> -	lockdep_assert_held(&domain_list_lock);
> -
> -	if (id < 0) {
> -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> -			     cpu, r->mon_scope, r->name);
> -		return;
> -	}
> -
> -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> -	if (hdr) {
> -		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
> -			return;
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> -		return;
> -	}
> -

Many functions called by this new "setup_l3_mon_domain()" are specific to L3 resource but
since L3 resource has so far been the only one supported the naming has been generic. Now that
this function is made resource specific I think it will help make the code clear if the
L3 specific functions called by it are also renamed. For example, mon_domain_free() can
be renamed to free_l3_mon_domain() to match the "setup_l3_mon_domain()" introduced here. Also
arch_mon_domain_online() -> arch_l3_mon_domain_online().
Seems like resctrl_online_mon_domain() is only temporarily specific to L3 in this series
(would be helpful if such details are explained in changelog) ... to start it could
include a check that ensures it is only called on L3 resource and then it will help
to clarify what this patch does and how following work builds on it.

>  	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
>  	if (!hw_dom)
>  		return;
> @@ -552,6 +531,40 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	}
>  }
>  
Reinette

