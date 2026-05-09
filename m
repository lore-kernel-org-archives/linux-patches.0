Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B5E23D2A4
	for <patches@lists.linux.dev>; Sat,  9 May 2026 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778330638; cv=fail; b=osbO2Ke+icgbMkuv8hAjUoS996CBC218p7Z6lBazBNojVE4L71vae11g99o6MRthJd+rd1FHP0ssf7GFA/DgK5luYJovAumWFi+whmswtZsPKiYMUzmkbfieGVqJHhSEHQRzkdeEUHPGtVG4Zu40mHKK4T14nC3W5JYYGd34zPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778330638; c=relaxed/simple;
	bh=hEmnpUXQzHlJQKq0yoK3zjL+YWc219iBvFSDQpGEYLI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tzgD5eo/Nk9Z1ZSQfKthdoLgdMHTzpTpqpdr5CIGCZ++WwfvHxhAnIyljCJ35MPXjFvaUimj0dk9+LpSTjREPp/MUPLSzo5AaK2sx/lLsYVnoZ+L0TfIUWt5REGHNwN/bpFZjiozoxbJWCCoDRh4LxhlmKqqZRPkd3p6+29VIII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a9c7Qx+L; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a9c7Qx+L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778330637; x=1809866637;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hEmnpUXQzHlJQKq0yoK3zjL+YWc219iBvFSDQpGEYLI=;
  b=a9c7Qx+LXHvn2farBW4x8JEfuBeKlRVpxJR8XFPNU3dkfUPTM+wTeuOn
   HVg6aZwC+D36gt5RTlBXCFWwJDL0ASn3lGf3nBtgLdyjJKbN+90hsVGU1
   7csJdPuIomKT99Tbs9BqCuLaIGqE3h91I+yL121t2JrTUPL/0voR5bdQ/
   7Jr34aMwG7VNkGnJJmys2Cmb+02fTg3KvY9yYhHRvEaPA7OVmumo44NVz
   r2VvHrd/9siGtgr+6yHLFu/xxa+7fKZbkgdz1a+o1x+fBbg2eIhaSdd3V
   Q6MJtk/c3HS22EANk6O4jr8Znk4y8U1PodtiA21Y09FFMCaI1LXXwhNOj
   g==;
X-CSE-ConnectionGUID: To4RbIx7SWGbdTmReqiIiQ==
X-CSE-MsgGUID: zE2W8lp6TyCPKe8uyw4yTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="82906995"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="82906995"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 05:43:56 -0700
X-CSE-ConnectionGUID: Mf5Ao80ES/aUYrInCE2exQ==
X-CSE-MsgGUID: L4+LGUTsT7CzjAPSw23fXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="237119396"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 05:43:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 9 May 2026 05:43:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sat, 9 May 2026 05:43:55 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sat, 9 May 2026 05:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmQv9Q+TsSstRAgk1mkBQGCgszwf/rViF6GBVaigfmXYfgSoIKcRL1o4Z5pCW3AAfHZwyrXyAwOgC/sgEnx0tRGHq3WyeSjdVaEL22ADvGFvyFXlhp1jYU1ICTl5Jot146hWi3Z8nIDzWydVfErx8c7L6mUOfyn0poc/pEqFwotB11zfN43R+ovSdlJWKugKvjdhJzP9p1zAzGeikN1bgf1/W/rmEHKbcKPCjEJdCFBVlyco0aUzA9cUByxCQYCz03rNdovj31qM1ge6DxgCscztUc9QszLEi7eCeQwSxF/Ip2cBv1Xu427PwhtW4Xam67AzBjZO15NPCK0A5ITD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=La/FGBWrCI63KdQ/nl4qyEcofO6BuRPfMa4UH4kcRxU=;
 b=B3WeUYTgtdgOhE0mFIXhwK2HXJsHSGK5FycsMyWa3/aP8MHq/pP0Qz2dDchhERPv9uKC+W5FATOzs7ONTAZbcHG5mp0x2Mk/gTphSn2UK99q09rn7SAYT2vYKWLMzgxGrhkSNDjYONhUIiKNgoV97Z/+eKQpVYFcDpLYMjYCrYfI7xTRWD/pNr4M4U6Q9Xht5RZtquQTti7drm2e85ldhEm3kwNppCETSGFyZ+s6xEalJoscvTl1OOFqZX8XvHAQXLzEdN46KZYe0LJy/SiRXWvJllgxHA3CbIUJS/iL4WseG06bh2yuxGkgXHX1a8bnpU/HX3HHq32GkwSpCD/mow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.20; Sat, 9 May 2026 12:43:45 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9891.019; Sat, 9 May 2026
 12:43:45 +0000
Message-ID: <3c1a99f4-de10-4953-92bd-4a93a5000a93@intel.com>
Date: Sat, 9 May 2026 20:43:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, Babu Moger
	<babu.moger@amd.com>, James Morse <james.morse@arm.com>, Peter Newman
	<peternewman@google.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-3-tony.luck@intel.com> <af5XYNAklCdaAfsy@agluck-desk3>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <af5XYNAklCdaAfsy@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0027.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CY8PR11MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: c16a4d9c-b625-4736-40fa-08deadc89b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: imr4i9Jl2PHuSxHJKt0cGmNsmllppipp6hOt1bd+jKH+UZRFmg9egpgCsKzFR5orRZa5O9HYheMA/FS2akterdxAx4Vpc3hB9BWFViL500HsjpUJuBzOPNmZf/LOoGEyr/X4Jc8DU8uuBZPB708pL6RUxSXkqyspS+oHlupmSIREQFcAJ9c/gTA7NQpqAJGVLjswHGS16wOMoK9lNFYfw9sjPhmNZ1+RqnSp8mZMGCOI361Iu1qiZPGOHgD1hUAQY+t1eUXMVtYu5XOsUBSCeZa8Uw00r9uRns8QvpbOR52YIGgi2gI1rqhq5E7a6yvtqNcJibj6uKoKHDcYTfrsh+Gylolan/gkDDcPQ+LE1rZkO4B3fmwNo2spzpeAvauY4+n9QxqnN5GEUwo/Enyb+YB9bP4/HvQB74P3LIAMwwRRnyGIsHOdZysXHDqdXAe2I4DOmiIO409tVfXFqzM2sSXu4/09jcPu5tQYFdqdQFA4P33NQmzaFV6ZdZYDfCEa6IiBGJoeStADwDdirNo4SkNdmQ4AopbnVvV6seHXt8P+w58PcvRgLGxJlN26iPl45jjgc1c4BRnS8nIBAEG5jLk60fq5UtEfkSnc6vjr9MDZtKmw3Fyx1kMcLyBYE3LcW5PyL3cm7O8uCPlo9YkztfFnUDHq3T3fQyQq7sh8oQIPj6YK57YXG+ZzL46dA+OZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWQyUXBIZjV0VEltaXIyUG1LQmxsZ0dtaG1oY3hsRitFYk11NHlJTzI2MDU3?=
 =?utf-8?B?ZDBwLzRON3Rod0xOSDFTSkdVRVdkQmVGdno3dVA0SmhuUXJIdXF1YjAwckk4?=
 =?utf-8?B?TGRSU2s2eEZYTnFzeUV1cmVOamQyK3ozWjZaU1VFc3cwSGdReFl3R09rVDQ0?=
 =?utf-8?B?Q1BleTBWY1dOL0dUVFViek9EQ3p1b3hyS0YzZW0vWkxqRHhKQUIxa2VLT3VO?=
 =?utf-8?B?VVZQVjlxVEJkdGJjOU05NWNSQWpJWmRTRkIvNWlTYXRrOTJEcitSSWtBUGhl?=
 =?utf-8?B?a1AxMldRSng4RVRVZ21LRkhPRmRoWGRNdTErMldhdXRxQjIxYWFpdElNM1RZ?=
 =?utf-8?B?aWcrMjNHWkF1bGpCN0pJQmlVY0c1bVlzcWNMaG4vNGRhOXhxM3pqVkZieUND?=
 =?utf-8?B?TjIzb1FWRDQybzJGeCtwRFVDQk96UkV3ZUNtNXNzb05Tdm04YlM1M2ljVlBs?=
 =?utf-8?B?QzVTSHZHUGJwNkNvTlpDMnRhSzFpT01pWFpDTkJPSEpqLzFUNVdwWWhLK1lU?=
 =?utf-8?B?RGF1Ly9MR29zZXRHOEw3UHBBS2JpTEpEK05nczN3bDRKWTZRU1drM2hLZ2lo?=
 =?utf-8?B?R2ZHRERCWCtMQTJyQ2xGNTdZbGh2RS9tWTJyNmhxVXlLZ2tzcFVma2ZyVmVt?=
 =?utf-8?B?ZzNZMzJyVGxzN3dxVk9hbnJGQVFObkU4VWI4U1lEYlBGNFcyZXZhS0NGWVN1?=
 =?utf-8?B?bHZqejVrUHJHRHRjeHZRVEZ3M1VGb1M4aVlURW91THZZL1FDMXd1MGFLZUps?=
 =?utf-8?B?Q052b1FKaUJORWN2SXN6ZEJ5dmVGQjlJNTlZK2JHUXZlVVZyVWY4eEdYYW1u?=
 =?utf-8?B?N0hOTEJYYUVIS0NCdWc5VmNVTjYzblU4aVoyTFBIV3doM3JEeVI0WjRKMTVV?=
 =?utf-8?B?UjdzaUJJdzlYKzN2ZHN4SEs5Y3NPd2xZaTJJNjlyZkZ6dkhRaEdYL1Bpd0xH?=
 =?utf-8?B?bkdESithZU55VWJGYjZRbm5DdU53eHllODNmL2lVVTBhNlorTFVXUkpLaXBN?=
 =?utf-8?B?b3ZaS1EzWmQ0aXhvQTkzVGowYnRiUndTWE1neGdaeHZBN0IrYWw4cTgycVlP?=
 =?utf-8?B?ZXkvNFpHaHpiN2VxaHk2SHJBb1gxUU5MZWNTWHdmY0hia0hTVjRNb0ZzVUNG?=
 =?utf-8?B?RFJuN2RidUdncFNIUmhBdE5QWXVEV1pCSE11YUxlMGx0aVN1TVBxZDVOY2Z4?=
 =?utf-8?B?akRhNkI2UXBKRUZIUDRCQWp6UkpXeXhTNkErbGNvSWhaVnV6VFRVYndabWFp?=
 =?utf-8?B?T0NUaDdReEVCbEZ1ZEpFQXdxWVA5SVZ2Znc1TlVjRVpPTTdSWmJZUUUvc2tq?=
 =?utf-8?B?bHJqT2dERlZUVmxXeGxHSVpRS21rVlZwRThCOGlnNDlvdWhyMC83dHlNdmhM?=
 =?utf-8?B?NFB5ZU44L0xEcCtzMXdhYUxRUmhWTHZPSFdYYXhQMVkwdlBZL3VQOWZkRjJq?=
 =?utf-8?B?WTFZZDhpS2FFaEJoRG5EK0Z2UTVlU05pZWVYLzFaZ2c3aURVc2swc1haalNK?=
 =?utf-8?B?SzFoS2thbktZeFBZQlV2TXg1ZUMvZ2lRcVArTjZ0QmFzUVhmVFdDcmtmNnph?=
 =?utf-8?B?WU0zSFlEaVhTNGhFaDhUcFF6ZFdLc1pLUlBuSGtJZmw3Z0dleEEwUEZBeFda?=
 =?utf-8?B?OFFoeDBQRlUxckhhcFEySzR3RE9aZUNXMVhKQ3FXQyt6Sk8wSnVwamJ3Q2lh?=
 =?utf-8?B?R1FBaWFSWG5BaWJxajhhM1BRbGhQRlZwOURtbTU5cy95SXg4ZGNJaDJIOUdI?=
 =?utf-8?B?T1B6N0c3WVg2cWYyMmVWcFo3NWdUTGxraEVEVDExRWV5WHpWdkhOSHlBbm9z?=
 =?utf-8?B?dmpSMTU5NGpMdGVnb2NJZGxOczV2NjhkdENybzc2TUN3NkZXKzB1WGR5R1Jw?=
 =?utf-8?B?M3lwS2Zmb3hwbWg1dU5jbzI3aUt3Vk93ZWtsRCtHQ2ZTWHJ5TFRzYkdrTGRN?=
 =?utf-8?B?Z0c4aXdWM3V3Y1lQRENIaFhzbU9iQko0eUxsK1FNY0xGVTZTc3dROGV4RmZB?=
 =?utf-8?B?SGd5YXJHOFRtOGhuWDJrSGhNaDQ5SjU3ckpVejN6aXpQL3lOSU10VXYvWEJx?=
 =?utf-8?B?Tm42Uk9aQUNmakwvS3FPb0dSMU16RmQ0U3FLVWx6TjMrSHluUWhkVkpia083?=
 =?utf-8?B?MUF5VmNrQnFndDIvcjNlNU5jQnFjMTBCbzdCWGNWdlh1TkVnb2I4N3lMdVJs?=
 =?utf-8?B?QlE2QmQ5cnl2elk5STg2OEwyd0MxOHdtSyt4SGl6eHpKczlsRkhvSXlDbzNC?=
 =?utf-8?B?Ukl0d3hWWlpsQld3SGRscmVzanhsbVdXZjZUVE5nZFU3T2hGVk9JMlpFUzQ2?=
 =?utf-8?B?M1dFMEgwb2ZqaHpKM0hYNVdNaWZxR2FKYjl5aEV1ZVdKcWJmYzM0QT09?=
X-Exchange-RoutingPolicyChecked: sRIGVvm+tFumxong8/U++2BGgF2PnGB+vphr7e2LBwS0YjPVKCmzDxY4szMmTkbygwOdNEngFCwbD/U8zjlvr2HfoxlQBffdaZVq0wUkqDZvLqJJXlByZsfcQxM7KDrpV/e0QRxJa3BwxMdMnhwLU/PK5R/v/iAzFs5hhk9NNZSgXW5k3K9AiKsEKbqxlRngPaUiSV/xirM76IcG6JKQ48NnXh7l4jMwjAlkn6G1ca5bnCphE+a+7/GSlV8uSJMFkXZgc2JqvycTWhrwBK+uM0GAeThfPm4ltcBv0RRkfXznDM/11g7wdijNpCmem2jrk5wpsDCuj8WavQO11Vb3FA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c16a4d9c-b625-4736-40fa-08deadc89b80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 12:43:44.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0U7KLlsy9Q2uSoPL1eDnA77M7aKQY08NtW7ympzoJaLC1KIfdQ4Kizp3YVugxasUeBpVZiKyBCmWfIopILv2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

On 5/9/2026 5:36 AM, Luck, Tony wrote:
> On Fri, May 08, 2026 at 11:21:41AM -0700, Tony Luck wrote:
> 
>  From 0263035539f805f5d4bddcef8968b551354cb86d Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Thu, 7 May 2026 13:48:51 -0700
> Subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
>   failure
> 
> If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
> fails, the mon_data structures allocated by mon_get_kn_priv() are
> leaked. Add mon_put_kn_priv() to the out_mongrp error path to free
> them.
> 
> Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")

I did not find above commit in vanilla kernel, should it be 2a6566038544 
("x86/resctrl:
Expand the width of domid by replacing mon_data_bits") where
mon_put_kn_priv() was introduced?

thanks,
Chenyu
