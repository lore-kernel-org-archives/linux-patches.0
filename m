Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79C42078
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716413272; cv=fail; b=tw4Y8BUmOdqZJwz+SOi2VvzULTz7mycedubSitzW2ADxxR67riveuD/inuIqWOl2wAhHUhUfNXpfWyOeUL5zKykFZWgFd+ZL6lCmTYxtTUbcu4iyZfwbvPdxETFUmVQogzTkxpEDZvWx5+IWjJBARoF1NkvASYNMGmbIwaDrmFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716413272; c=relaxed/simple;
	bh=uHO0VtfM31KfKa2X7ZskndaKjCqFsOU5GMA+ZOf+pnY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KPg1JcMMCSezUe2dAdZYdlqrq2hAzCpGIFxTu9KyB8JnXGLUAjWVe9T4FGZqTn18OjWOCYUfu8l/c/hi0HyVW1C0FIBgEMgJRGGbkYGXKu4mXv+mci0pv3QtO030dCUwjFQK8XzV3m16NtS0dTNrcfk52WglSmalhy+VevFfkG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnDk9Si6; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnDk9Si6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716413272; x=1747949272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uHO0VtfM31KfKa2X7ZskndaKjCqFsOU5GMA+ZOf+pnY=;
  b=WnDk9Si6O1rF+LGB6R52UMMSoFBrtYKb43S3gjioVgxm407yvHIOn2Q6
   A3mlqGXz0kT+ZaJdoWKppNWeTOSqdr6x+AKr/0lLmBYDgdBdxADrm+Jd0
   rLTlWWP0ZBDBtVpg+lMPYI7y9TUXD3OuzIO8PrwteM1IZD+gwFfLYHP0/
   bo1gJE+pjP8mWMClmEhCwJZqJp7LY+PfYWZeC4yCWpDYkqH4okGEBIYaT
   aOE1/bON2MvNYURZ2XPCSDXhZA4WkqUYSddME6Ryds9y3OhKOGiviMNvx
   CJW1v0qyNvt0qNDJq5kigKnlSPz0liCNiE071cYmNjl5hMlIJMYn5C0Lm
   Q==;
X-CSE-ConnectionGUID: rARs3p2ETZuzvUkTgu8sYg==
X-CSE-MsgGUID: fFFEpCARQoqZDTWDvnLrnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="30226800"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="30226800"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:27:42 -0700
X-CSE-ConnectionGUID: KBLnE5WmT5yjmZMCIeiN3Q==
X-CSE-MsgGUID: ycyoYLl/Sv+xKDajvwayIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33402393"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:27:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:27:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:27:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:27:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:27:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3wAIHXGspOIQh33EFeHRmv7dctBw0fbxEpthCJGJj1oaBxje/pMxmlbzTPT7e4cfmZ0s5DQ0QRdY7eKZKbhyl+6hfqCzJyr3sHOPsGFsvbCYCa24FIAIKHvTUDhpjG0XHZBmxS97bluxn7tf0gecMJM+9qUf36y69tWyPq+c4TlcX1jSdBJb6dKu+O6OWUk9sS5TTNVWbPWObt53L/fYvn0xrksGqnt/sWqk9N4oJzzc8nFotQIiwg2jCucc9sez7tKv5IMZTRigi3BYo39LEzFM26vMVzWk1y35n5kSPZxZPtxQo5979bveEYhvLA2dEAJm1ivBNC6hs64l5WKaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dCIc/h5VF6LDuENO1pmyisruTukk/SyAamgo4+ED98=;
 b=ZAMRoxKWx64iV1sydDq1eg2RB1z5+bwQaZkmlgZ/Vd1nvSbBlGPqEAgIbMPmwlRAVrDVIQOvTL2zj96/QWsm60yRarC7ZQxDGVCx2oWf4GnyniNu7AW+ea4YRGKzMIF7YDXH6wOaWSHYXz4y6wu8kvDYkg5JDWtUbooWvC0OKVipeLixrD9yYMi447ERKD9EBzVNkZ32V246OuhXSp5Mwgf7QFjtRZUE1XmFzUNtl47ru004F0ulO/YBjT1B5M8FPoflj1cweWd0v7DZqY16PfLzI0z3YqLYrnebLgHixQ1CtoSGp/QkvMT4vRyLXEnZ5qRtLJ5m+2kJKnxH9WI/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6031.namprd11.prod.outlook.com (2603:10b6:510:1d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 21:27:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:27:34 +0000
Message-ID: <84195d22-c056-43be-a40c-9db5944862d1@intel.com>
Date: Wed, 22 May 2024 14:27:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 17/17] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:303:b4::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: ddcf9a90-6cf6-4361-2a00-08dc7aa5fea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?LzZzOHJhd3JyT3hMcFBwd25oSmdvZ1JtUzJURkNHcExEc2wzVEdkcEtWYzV1?=
 =?utf-8?B?eWVkUGVxZ3ZkazZIMFVoVENBNDY5enlVaTZpa3orR29XcE8reVN6QWtaMHdj?=
 =?utf-8?B?ZFVBTGlXbHFTQTlSNyt5K0gxeDVTWWYyQlRnWFUyMS9UOVdRdUMvbU9kQ2ov?=
 =?utf-8?B?ZDRTeklMQjVuMHhyZTV5SG9IMTZvMGtvMTNNUjVWVmN4YXRkK3o3ekp4dFdR?=
 =?utf-8?B?b2JVSFhiU1hoMzI4aEJ1YjYzRUIzcHlubTN1UDBrdEs1bzdaV3kxTzRjenVT?=
 =?utf-8?B?WnhvSC9QcmlyQ2RkYmd5L04wcUs4L0RPclF6TTlsK1ZQZVpjK2ttU25MSzBu?=
 =?utf-8?B?djlyL1BuYTd6NUNoWmdtTkY3YWNIbS8wMG52M1poOE56TzdBSndiTE5Wd3NS?=
 =?utf-8?B?MkNrSTZoamZYZEFpRGNJdUpuTUVvSWJBdTI3b1plQWIwRy9RanltZFMzQmZJ?=
 =?utf-8?B?VmRvYjZqYUhLQ0J2VjNvNEhSZnFsSU9ZUldiWkhHMXFjTWhZUzZNZTZkQzY1?=
 =?utf-8?B?NDJhTzdwVytZRmhOcWhzem5rejRSTEdvekpVVDhjRDFrNFhRT29Fbk5sSjVB?=
 =?utf-8?B?ay82cXFyQTFDRTR3Wk5OM3ZHVjNDWFpRMG5xMFRQc2pnM1BLdlQzN3dna2hh?=
 =?utf-8?B?bExrclhTRDJvd0Z0bThndi9mY1BpTWZQSnMxR2E3Rk9iTXJ4Q3QyVVdtZmN5?=
 =?utf-8?B?Q2c3Wkx6aDRWa1lzbGd3dzJjZklEeFhJQVdiSEgxRVJlanVhSmRuN2JGYnhK?=
 =?utf-8?B?bGhPcVBjYUNLWVI0QzdDY1E3N1daV0NiL0tCZ0tiNDkrNG1nSUMwSUlzbU5N?=
 =?utf-8?B?TlRuMlNidEJoUDB0SDJXN2tJRlBDT1dwZHZ4VDcvd3RHNFIrZVpvVlo4VzV6?=
 =?utf-8?B?L2dpR0l2Zk43dEY5WkM3NFNXTUNIZVhMZTB3QW1nMm9pS016THhhdmpmUGU3?=
 =?utf-8?B?ZTZGYW5TR1NnNGRCdm5penJJclk0cTZnYTR3QUxlVUdHZW9mcUdqT0RsVXBT?=
 =?utf-8?B?c0lNd1pCcTROdG5mTnh2R3ZIcy9vSVBtT1VidERMamZLYWl0WVdJejhvZCt2?=
 =?utf-8?B?MmlGNGtMcUR6MUVHbGtHYll4aGpWcWNDb3FCaERrc1c0QlFjTnBWOTFaMlFr?=
 =?utf-8?B?eXZWWXhQZnNrZ2ZZdzBNRWZVQ2dXS1ZLTDU4dzN6MXhLNWVmY3FMNFJSSW8y?=
 =?utf-8?B?VHQ5b0hkSHVpSnl2dGlaY3FWMFpXV2Z6NzFJOGRXUlliRUpDTWEvcUhhc3dk?=
 =?utf-8?B?eVB4MXBiQmx3ZjFjN2ZuT0dTZzZmNGdvbm10V1Q3UUU3T1pHUnRuRXZLY01X?=
 =?utf-8?B?czdCT1lhNzdiSDRnRzRSYXgwV2dQaVNDS3VXeVNnQ1lEZ2JZUUZkaWRxOXEv?=
 =?utf-8?B?dUtrV2MzdC9XS3Q0NFBpK2JPY0ZsTHpQWnhIKzFibVBveW1MOVNtQlZ6SGx5?=
 =?utf-8?B?ekdlS1pJbHdEK3QzWUp5amZ0K29Ka3JUcnEwQXEyc0dQMkxGR2k4ZzV3cnpP?=
 =?utf-8?B?c2FOYksvMGlXbzJWVGlaUHBZZ25EV2JsSld6WnNjNmorSm1UU1doZDJvb1l6?=
 =?utf-8?B?VGE2eHYyYVY2SE9YSDR4b2krSFFqR2wzK3NmbjFHYjN1Q3RCclhFa2lhWnp3?=
 =?utf-8?B?dGVLTklLMEtaMURxVk5ZNTh6Z2lvY2ZlREM4U2haQkFsY2pKZWZ3UmVqb2ZT?=
 =?utf-8?B?MzBUUVNXZUxrMlpucG1aMkZzakF4cmVGQTMvbDNMbG52c21USExPakNnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THI3NGRMaS9UR0ZaY0gyRG94Y0NKYjNhc3hoUDRzckRzVGQ5RFp4OC9tb0dC?=
 =?utf-8?B?OTloUmlrNkx4N2p6WHRmZUVsQUxOS0dtUkoyZTN5aVRhUWhiTENDSXJ1WTh2?=
 =?utf-8?B?Z1FnWnFER1ZrOTIwOWRWa2RwUEJaOG11L2VFSUN5QWhBUXVHKzQwSTZsTjlu?=
 =?utf-8?B?WmRtUkJCWVQyNSthYlRobnZjb3V0emE0cFcwZFc5TEpMQVFSQWdCYzBMR092?=
 =?utf-8?B?NlhhM1diOXRaemNGeUlQeFhkSzRwYmlNRGNRTEluWElScjBMS2IrSktSUHMy?=
 =?utf-8?B?UmQ1d25LUjFHcUF1eXNRM0Z0eSthYlVBOHBaVW45Unp5eXVsRlRYRTJ3S3Jn?=
 =?utf-8?B?QzNVbWJLT2t5UHlyQlpqWFJBa0VEb2ZITFc2cTB5ZlV3RFVqYjZYZWs4YlJ3?=
 =?utf-8?B?bTNZUElYclBSMlhHeWQ2UG9xK2c3TThoZHI2Tm1OR1cvL3FSVW5NMVBta0RT?=
 =?utf-8?B?Tm9DeGs4UXdHNUNMbW9OeHhYTVo2dFdpbzB1cVprUk4zeXg5QUl6SDk1UE02?=
 =?utf-8?B?YlZocVJEM0hneVV5aHdBRE9qdTFjMG5IN3gvY3R1VzdWaitmdlRTbUJ2L0xq?=
 =?utf-8?B?T01DUmpSakdKU1NjN01ZWVg4RHdGeVJOclIrSGx6dnVYWjBTNEtjSEkySmda?=
 =?utf-8?B?NFFLYTYvYng3bXcxR0Qvai9nUXMzM1JUV1BYK0thWVVDT3Azcm9yU081aVdu?=
 =?utf-8?B?dUJ1RlNUQUFSeUloMnl4L1VjYmVtRVB4OVgrMVJWc29qZEdySWtxeFNCcFBQ?=
 =?utf-8?B?YkJ0cXcrL3VHb1ZzRDBOYUpOREZva1N5NGlxMWthdElrV1gyNVZsL3ZyNlZT?=
 =?utf-8?B?OXJpaEc0dVBIVjhad08rTFdIRnRwaWRLUzUvSG9UMnRySzF5MHh0L0JuWUtv?=
 =?utf-8?B?NmV4Qm92UU9CVm9sZzlNdTc2dkVNQVQ1Z2RyY2Q3YkgvdEwvWFhJZHprUFJN?=
 =?utf-8?B?NEsrdEtyLzBGb3R6VVJvakk3NlFEM2pMTnJiNWlRMzhlVERGOWxYVHhza1pl?=
 =?utf-8?B?enVNWFN4U1dIUUxpRE1iRlMyaUw2WENpYWxjWit0N3NIN1ZCclBseFI4c1I4?=
 =?utf-8?B?Rndvc1dGT3FCS0pBSkdFZzRMK1ZTa25YWTRWSW93T0c0eWlNNG5BczF5M1ZS?=
 =?utf-8?B?dXdidDFwdUF3MThoeHNRSnBURytvZTk2ZDNqSVUxUFJ5MVdzejYrdDQ0b3NZ?=
 =?utf-8?B?NjJkTTNpTEgvdG56Ymw3eHFFKzg4RndhNkh3T1o0dTMvM0lMR3djUXJKNWJB?=
 =?utf-8?B?Yk5KN0ZvN1hzdVpsUHRmMEFmWXV5RVJzZTVXQm1WcE1lL2Vvd2RpN2pVOTNG?=
 =?utf-8?B?L1ROMm1PQ1JlMzBHUGlJMUY0ekd1bTBJQi84bXcxdDVFYXFBRmRzSUhhSWR4?=
 =?utf-8?B?cG13b0F1eEtPMHVKRFdweG1pcE12RklnaG5hTHJIZEZvb0JjTFo4WmdoTWhC?=
 =?utf-8?B?MXN5N0pHditkZnhMZm1uWGRUV3dpclRFY0QvL3A4bWZnUTJ3UytyMzAzUzdO?=
 =?utf-8?B?bEI0Y1MrV2JsMksvVHJpSmw1Z0NsMUcrY3I4bzhDMkVHUDIzVDRxTjQ3dG1u?=
 =?utf-8?B?Y3RlSVJSMjBobHFER2JuMExUUUNub2xBSHQwc2d0clpWWU42Y3hZd1pYcStV?=
 =?utf-8?B?M1k0U2FYUjdPTUN6aGFTVm15Ymx2eW5MZCtueWhQSnZjOXdidytxNlA3MXVR?=
 =?utf-8?B?TkxxRGNQT25aUFZWVjFTLytzdU5xNkNRUFptdnk5eXp5Z2pUQXgwZXd3MXIz?=
 =?utf-8?B?ZzN2ZDlpb29IZHRpdENMaHdiWDA5OHJJWFRUOFpvcVRkcFhGVDJjWTVUVm8z?=
 =?utf-8?B?TGRSZ09sSDQzbER5R1Jua242ZDBVdEFGdDhRaXFsQ2JsU1hNYUZ0dmd6NEt3?=
 =?utf-8?B?RitySktqS0VOUk41WUtQN1hSVGx3dk9IL3Z6Z1p6OUk0VEllVGFiVGl2WHBn?=
 =?utf-8?B?aXltQ3doanJ4ZXZXaHQ0OFZwcVN0cDdGTEhuWTVKTFNrT0ZtSEJ0Vzh4QnF0?=
 =?utf-8?B?aVRTancwUVh0cXZJb0tYV2pBU0Z2NVJUVENITnVQYVczMTljdUNrYll0V1hM?=
 =?utf-8?B?aDJSd1BzTCs2ellGTzRQSHUzWHpTWWZ5MFZYdHgrcWlQQ3lWQ29sUTl1c0h3?=
 =?utf-8?B?U3d0NTFwU0k5NmFPTzFYNkREenBrWlFxaC9paFhFUUU4dkE5Qjcxbld5dWlI?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddcf9a90-6cf6-4361-2a00-08dc7aa5fea6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:27:34.1361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuiyU2yiA92eBcs+WPZv1a4bapvEj715m+5f4EaeyEnrTEUnRf+jwG+DjfY6xNJsLEIpFFFndgTBQ3CZjOkV88gm12gEptDXaZLX2nH5tqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6031
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> *** This patch needs updating for new files for monitoring ***
> 
> With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
> per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
> their name refer to Sub-NUMA nodes instead of L3 cache ids.

Out of date?

> 
> Users should be aware that SNC mode also affects the amount of L3 cache
> available for allocation within each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/arch/x86/resctrl.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> index 627e23869bca..401f6bfb4a3c 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
>  	all tasks in the group. In CTRL_MON groups these files provide
>  	the sum for all tasks in the CTRL_MON group and all tasks in
>  	MON groups. Please see example section for more details on usage.
> +	On systems with Sub-NUMA (SNC) cluster enabled there are extra

"Sub-NUMA (SNC) cluster" -> "Sub-NUMA Cluster (SNC)"?

> +	directories for each node (located within the "mon_L3_XX" directory
> +	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> +	where "YY" is the node number.
>  
>  "mon_hw_id":
>  	Available only with debug option. The identifier used by hardware
> @@ -484,6 +488,19 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
>  each bit represents 5% of the capacity of the cache. You could partition
>  the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
>  
> +Notes on Sub-NUMA Cluster mode
> +==============================
> +When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
> +nodes much more readily than between regular NUMA nodes since the CPUs
> +on Sub-NUMA nodes share the same L3 cache and the system may report
> +the NUMA distance between Sub-NUMA nodes with a lower value than used
> +for regular NUMA nodes.
> +The top-level monitoring files in each "mon_L3_XX" directory provide
> +the sum of data across all SNC nodes sharing an L3 cache instance.
> +Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
> +the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
> +"mon_sub_L3_YY" directories to get node local data.
> +
>  Memory bandwidth Allocation and monitoring
>  ==========================================
>  

Reinette
