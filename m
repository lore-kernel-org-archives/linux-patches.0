Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E094925FA2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487711; cv=fail; b=cOn3NA8lIWcFnmGjkufawywCBI+okE/XmlgC0FBuhlSuRcm1mUcwns96M4aBMHyZKuaZQCaknsECnPEFMdZSUCBO4jT4yKOysajOXyxpjiDGXI27CPTtkTriUN6zt2TLilBcp8TEkdk0FMSt0j7oTtrG4u09YmTpP0PHqZVWt+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487711; c=relaxed/simple;
	bh=IQy+h1cOJavxJ2UscHZCb52dh2er4VObeiWRap8aCm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gGCpCyak70v+lDZc6wbX6GMfeaecg2QyxGyrMZfZrYHRFefUTVe2Sejxnfenv+lDYoPLUuIjVFjgOkadhcDUFmsl+kSnv0OCrTS6NYLwtGakeelaT+x9hn960v5rN7Tc+hrNfwphYf4nQ06hMPIZyHkl+yzezLR2YFjYlJZ+0X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diTrZsku; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diTrZsku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487710; x=1785023710;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IQy+h1cOJavxJ2UscHZCb52dh2er4VObeiWRap8aCm4=;
  b=diTrZskuSHaiXSW58aJO/Kwqqte5aRCUamgluSmcoke4m86t0neykfgO
   zxE3znqOjiqnlAgSTMHmVHwMbrEshNStFZQtX2enm48aYn2psVVLy+I1d
   1VHbLKOAiMhFOlALskdeljOG83MxMz4LgZHuswiPo8nq1cxhVyr39UCOS
   /4HF1kGDz+vmByUq9bmlAXPcTQSQMtpXNcRYlCtshVAKcJTjNvC1pOCZb
   FoUnNV7Ps5+phsGwXSZ7c/LenIWvpqM2LKWPWFJJXRJ7qqJiPhhvYm/V2
   f8U3xBMc4ljSMHgYbbKae0je3MzYfh8aHSKYUCpCUNCWoBZBwLhhcl5Sd
   w==;
X-CSE-ConnectionGUID: 9dNbN6ZFSq6LKmHgJNF19w==
X-CSE-MsgGUID: FNSNszYLSUaST61kfbn4jA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55793772"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55793772"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:54:56 -0700
X-CSE-ConnectionGUID: KatuMfivRuqhnIgbor/yLg==
X-CSE-MsgGUID: rE+W933KTciVjT44P4woyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="166578542"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:54:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:54:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:54:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.84)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:54:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pvn/mHGCKisYM44me2W97KUOR1764Qo32//4OMD2YSQ1+I8nZgm2FEGfD2nfEDUP7WQJx/tpfeASzuLJjyW1ppRfYKk98dNqokAvo7WvYC1GmmPnyOeIRkHjOHBBCl4cufaRlnT2v3ioVHg2YkadA2gsxCp51kTusgHobPLyLkbXwBMGP6O5gbd3xxYJWQU4ROEyL1hol6YwPqWvuCpGKOB3D40/U/TpYvRF8utH4W58mX75qakpafCBMWQq0N4U/fCzpk9Xue1b3mWF9xZkx0c6lkz/8IchkBGkfVm6KLzJif1/1aUMTy802hsC9lciIP/4OhGatpT6VTWNVm8+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZbzY4xJpYGtBlT3uQiid7o+t5+TMCf9vtBLyPVAHyw=;
 b=gpx49HI26paDP5SHSF4QqJpuA8bvwmWlzXIyGUPzINrT52h6cWOIQHmYnSiAwjIf82P7OtWxsEfNCD9hDNbsYOWqYQxwHXatIRJRWgZLLUfEBck5NUUJtb1e4Q5ag/AfDG1KfGzxpNaNFk4TdJK7C63ZhEEk2MFiQ36BdRvABoNAvFeaQYbmSrToENSm1k6dH3j8Az/wTkmh7WNkN/YwWZ7Jv7uCE3ED2IVQBP/dpFscr0wHzVicxJbbMwWw+FN88Rp9lnYScDg6feXgRsk1ImTMFi5rl6nU2BN5HqtzqJXf4qHmGfG4jLPzpF/D1g4c93DeuBo28MUmL022O7DgNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 23:54:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:54:52 +0000
Message-ID: <75e37257-49b7-443b-a409-885811d04dd0@intel.com>
Date: Fri, 25 Jul 2025 16:54:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-29-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-29-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:303:83::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b25f302-b2f8-4175-1af1-08ddcbd6a60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDZodEpoUENSZHk2ZFB5NXJUN3ZCdTBaNUh0VzVPVHd1Nm9FRTl4dzFha2dY?=
 =?utf-8?B?c2dPRXVKcXYrQmgzd3R1U0hSam52YWpINnc3VkNLSSttU25SdDgrdExpaEkv?=
 =?utf-8?B?d2h6MzVvZ2FsL25zNFZQTlpjbEQxU3Y1QVUwWisybFlmZjhQMW84SU9kcm5R?=
 =?utf-8?B?WlBVa1JWdzFYcS9YbE5PbDJHOUlUTllRZHlJWFQxUXZMYW5XUTNGTTZzb1dP?=
 =?utf-8?B?VkhkYTk1SVZOMU0yZnBIUHVRWWxjZmMvSEh5UlhBMUpWd3pwWXNVNEFyUmw1?=
 =?utf-8?B?SlBiUUxNK3lTemQ4bzhnRHAvMWY1ajU0MlRha0hVYU80N0huWkRLcVJIaGxz?=
 =?utf-8?B?cHgvSjVVaFczVHc5M2R1dUYxZUhhRVprSXFMM0hGVytpSFh3YzJzYkhYUjlS?=
 =?utf-8?B?bm93RlRlU1lONlRMcXk4eWhneFZURVE5c3FFdVN6WE1vZk5HbzRuRGhOQzhH?=
 =?utf-8?B?UGx0NmFvQ3hCbWlZa2V4VmFFQXRHNi9aZCtaOWFOc0NGSjNERVc2bU9WSE1h?=
 =?utf-8?B?TWUvdnFlV2tWcWsrbFhNZk0vb2pzUTVCWEFJSXVOekxuRGJ6T3ZaaDlYYUhO?=
 =?utf-8?B?dUxIMVlWUW45WFVMZnlhNWtEbzZ5OElQbjJTQnArTm0xanNPS0xCZzUybUVN?=
 =?utf-8?B?MGRnR3BJNW5pVkllUU1NZHA1cVdCQXRZRmx3YzZhTDJYY3hhQjVDTGVaSXpt?=
 =?utf-8?B?K3BkbFhzWkViZ2M4aDVIb1BXa3dEbmxxeXFvRGl5cGtJMWRXd1FaLzFtM2VW?=
 =?utf-8?B?bnFKVFBDQ1phZmtncisvbldjaFVMdElGWVBmL0paUTg3T0hZQzNaQWluanRp?=
 =?utf-8?B?TUUzK0pDYmFiNTI5c0lwZEdYUUxXWlZtWnNycmFEL3cxdXVoNUZJN3EvT3hZ?=
 =?utf-8?B?ZklNd1MvMnBndnd3WmNOdFZyMzZBeExDSHpKbjBaSVVPNFFkSlN6WW5CZmFP?=
 =?utf-8?B?cjRjSm8wR0hrNHEvSXdsK09nSzZidWkxaC9xWE1aTk5sZ045RDJXQXlMOTVH?=
 =?utf-8?B?eFhEaHdCOVpHd2hXTGJWb2UrREl5YzBQQTZVcWRBdU1jM29GSW4xelFMa042?=
 =?utf-8?B?cG5FK01RdFd4VnhJdElkOGJuRHgraDJJSDVjNG04Zkh1YVpaTklYeDIzelpi?=
 =?utf-8?B?SzY5SXA3MkhocUhWVkt6RWk0UGh0ano1QnMxMlAzeHlvM0JYbmNKa0VhcjVp?=
 =?utf-8?B?Ry9mMHdidFQ4V3BSUHYrVklSZDAwbCtJVk9tUTFxcEo4QWkyaUxQUDdDa0Nv?=
 =?utf-8?B?dGdKZFJBOHBMN2xNZmgrVndMcEtYL1liZWtrSUovL0ZtZWVLL2szU3FhR1h0?=
 =?utf-8?B?ekpnSk9mSUFYOHpHbTMwdjVyT2ZGZ2p5aUQzUjQyemI0WTZ0VGdpVGpCWUpO?=
 =?utf-8?B?NlRXTUNkdlVDekFUNS9COC8vVnEzVWZWN1ZDcndoL20xalkydk5LR2VBTDN4?=
 =?utf-8?B?ZmNTdzlZT3BFcUZBY3E5SWc3L0EyQTJmSDFVenRYMFBCS3dlcUZlb1BPcy8y?=
 =?utf-8?B?MWpHL3RTT3FpcUN1bm1iMUd6eWZlOUF1SlhGQkVDTGV5SWc0YmxQVmpyT0I4?=
 =?utf-8?B?Y0tEUUdYQVFtS205RHU1MzVBYlhPUlZqRVJhTnVsSjNURGx3eUttaC9QdkNE?=
 =?utf-8?B?UnVDbUp0YW1MekdrbFZHMnZtV2I2UkUrQUpEelYrUzFLYkxIbTB3NXUybjdH?=
 =?utf-8?B?dTUxeXZ3SDVMcWNOaDB1Ymtucy92UHhrQnhvQUZvd25QdlRSdmxaa0dYa095?=
 =?utf-8?B?TGllOENrc1dMUm5MWVMwZjRrS1JkUHNIdWF1RlN1NXJpblBqV0MrUFlwR25C?=
 =?utf-8?B?T3cxQkUxcmlOc3JVL0w3cnpMTG5JUENneGhwYWZja2JKRHJzUUpBYmRSSjZw?=
 =?utf-8?B?SldPd01WSjA3L2tpK2hjMVo1TDBoNmRoYlNURHV0SDIxVHRhSW8rVG5JQ01H?=
 =?utf-8?Q?C/AHU3ggUoI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFRmcDRDWWsxL3k5V2kxbFhuREJ3RW5EeEVKM2M4M3pwN2g3V1lnNTFLSy82?=
 =?utf-8?B?dGpTM0RWSzNUSDdyejNScjhsK0ROU2NURjNZb0hjRnQ5RE96NFEyS3k2SFpL?=
 =?utf-8?B?SXlsZGRVY3dxa2ZCQ0Q1SUJucm9NbE92enlPREhTY0lSYzV3VWJwK2dHeGcw?=
 =?utf-8?B?cFFkdGNoZ3FMNTY1L3JQTXNlV2t6c295dDVFeG1ndHFXNU1WSDNGN2ltN1hn?=
 =?utf-8?B?NkFXMEEzaFh5enJnU0VpR3pUU3hWUDhScHdnMHZuL3Bhd0JkdEoveEc3ajc5?=
 =?utf-8?B?VGR3MmpaeFo2SzBwTmRBMk1ja0NaL212MXZUL2t2NHMrMWordFhNbFdvQVJp?=
 =?utf-8?B?djgreklwd0RLYk1xVHBXMXQwZDZyV0tRRHBLRnZsRmNPOFBoeEtScjNwSkVX?=
 =?utf-8?B?UENxUkE4VkthQ3JVZHBkVGI5UGdMc1QwQlh5YW5FVE9DcW1mMzR4ckI4RTFI?=
 =?utf-8?B?SHkza3c3ZlNHd2toMTQ0czFwTXl0d0VvZCt5UG52TjhRRnZtS25QZGpBQTd4?=
 =?utf-8?B?bTRjN0x0MGwrM2loSFcyOVNsanZHVU5OWTB4K05tOTNiZldKZkJuK2ZCT3N3?=
 =?utf-8?B?Qit2OHRNaHNqdWdWcUpZdktaSWNXK3BFTFBWbzJSZTRZOTdOK2xxWVpBZVp3?=
 =?utf-8?B?L0swQlFBM1k0OUxmdnczZHVQd2RHamgra1lnZ3BZM0hYUXBMWHAzemNCcHd6?=
 =?utf-8?B?QXFwU0pGNWxoVllrK01YOWt4ZmdESm42MmhMcVlpMzI4SDRTaTdsSDZOM3hT?=
 =?utf-8?B?UGNqL0dPTzJ1UU9pTzE2czIvVHpsRzlqQVptNmljTkJHOTVGREg5L1F0OUlj?=
 =?utf-8?B?QlFMZGZTU3ZaeVEvSkJ4OEV3MVVpdU1lVlhuN05Qa1l2MU15ZmgrZWFjTXFM?=
 =?utf-8?B?SVd5VlJqNmtHR3Zyb2Q4SVhRT01pU3pYNHZzQ2pUaVFjZTlCKzMyTm1yY1Y5?=
 =?utf-8?B?WlNHL1JTN0ZicXhldEVnbk5XY1E2by9lTXBjMTJQck9vRmVwV3AwKzRYbFZa?=
 =?utf-8?B?NzNndUtsS1ZqS0NSRWlKNzBYbC9Vd01Jb2NCVm9RWjBTbDZpWG8yQm04ME5I?=
 =?utf-8?B?WkxWNFN1MWFTdDV3QUtLOGhmQTdCYXM3RXA2UnY0NEV5MEZLKzNkWlFpdzBv?=
 =?utf-8?B?MDZiUEZTOU0rcW5JWGRoNG5rMEpNeC96aEZSSmdTTGxqd3d5OU5tcDNlNDl4?=
 =?utf-8?B?cHZseU1HaU8rbE16dUJENHROeDJ5S3g3amNKUTFxRjFPZE1XNFNvOUFNK0lu?=
 =?utf-8?B?d3BOTHREbDN0QS9UUzVFSnFPOFVpVkJjNWpyc0xjdHo1MUdwSHNlYXRaUGd2?=
 =?utf-8?B?bTJUZmlJczJ3R1dUcEVpVjVkZExjY3hFc1AyNTNyWnkxSGZ1dU8yYkdyY0JK?=
 =?utf-8?B?azBmWGxFa1BLSzk0Q1FoQW54RGcyUHVRZ2gyK2JqZkJaK3FJVDh5akkxNkJK?=
 =?utf-8?B?RFlFUi9saVZmOVJETjFXNGt5MTNTSWVqNUhMOGt0cnRFMHBtYlNnaDhPZ2tq?=
 =?utf-8?B?WGV0UFhPblNNODFyNEh6RFZkS2czd2Q5VU9aaFRldVVvRThxN0hES0VudFli?=
 =?utf-8?B?dERFck55SUhCZ3dJdlMrRUdzSUFkUTBwZHN6aGg3TUwwY3h5anhkVXk2RzNO?=
 =?utf-8?B?eG9rN0NvK05XejN0QUxFRGN4bDUvbXdzY3Fsc3BzOVVWTFIrK1RWU0pOSlVO?=
 =?utf-8?B?bktwYm81RE1ickt6blM4WUZSeVMxY01NVlBlRG1IOTg4R0xlZ285ckJFVDFz?=
 =?utf-8?B?ZlNnbnJhRVFZbDBEQkFoZld5bkN3a3pzSjRobGtqTHdVbDlkMlZVYUpuRnFy?=
 =?utf-8?B?SWIrWlM1dUxtVGg0TGNjMVNENzFJNDZ1aTJYMzE3K3RDZUlSV2YxTzYrcGIr?=
 =?utf-8?B?ZkhLMVR2ZXBUTUl0cS9ZbGxqSjNEWld6WGd0UFNERE9yeE9NbEVJZHlaUUU0?=
 =?utf-8?B?MXdOQm5SMXhMYVY5RXdmd3BvYllYN3hKdTJnTE1iRHdBVVY3QnBXdmtsb29H?=
 =?utf-8?B?a3pRSXNjNjlpL21aL0hGUzhnRGVUZ0tlYmt5TlRtYnkxc0Z4YzFlYVFLWGFw?=
 =?utf-8?B?by83eGw4bHR4ZjR6RmVjbnNmcHQxbGpXcExzbk4wT2Vucm9xcEZSNXdua3Bu?=
 =?utf-8?B?WENZZWxsN3JzRDh5eWpuNFlBbTRNTmJFMDVYdkdJMWlocU9Ra09hby8zbFJX?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b25f302-b2f8-4175-1af1-08ddcbd6a60a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:54:52.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Gn5kaIPd0N9OVMLluBKuUJvGOX+4DQYzez1dziBzTHzXlPbHbwA3EmDsS5lUmAt4scmFpgeDE1f+8kdFfB74Yp6nFX6QSUFJwUZjikj1ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 1a6635cc5b37..1d07c38ed528 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -774,14 +774,26 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
>  
>  void resctrl_arch_pre_mount(void)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	static atomic_t only_once = ATOMIC_INIT(0);
> -	int old = 0;
> +	int cpu, old = 0;
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
>  
>  	if (!intel_aet_get_events())
>  		return;
> +
> +	/*
> +	 * Late discovery of telemetry events means the domains for the
> +	 * resource were not built. Do that now.
> +	 */
> +	cpus_read_lock();
> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_add_cpu_mon(cpu, r);

Without an explicit "mon_capable" check this change now creates a new "contract" that
"if intel_aet_get_events() succeeds then PERF_PKG is mon_capable". I do not believe this
additional complication justifies saving a line of code.

> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
>  }
>  
>  enum {
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 6958efbf7e81..ea7a782c1661 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -264,6 +264,9 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  	else
>  		r->num_rmid = e->num_rmids;
>  
> +	pr_info("%s %s monitoring detected\n", r->name, e->name);
> +	r->mon_capable = true;
> +
>  	return 0;
>  }
>  

Reinette

