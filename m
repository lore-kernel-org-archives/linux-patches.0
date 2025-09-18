Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A2C2D7DDE
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758232512; cv=fail; b=f4DVJ5MjpGhvODnapS3OLLLn8/28gt1XrkuU6s5oW8CyIM9D+Hv3LRr2NOTZRcLr1nq9dgAah1jFckiyXIhJxbdzn8AAWaCNPWyRiBvNtG6gVM7KIrl0g8DTO/6garjaLO7VeWXFFmDgcNYUKsqngFh8seSCmo0NcbqKhMFL23o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758232512; c=relaxed/simple;
	bh=NoImQSe2Ibobow+qrBWVK3AYgYkckz2/p3U186v3fdM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JwF24imtTB7nZKiTlUheo+sVl8xH4Q1t98nyjqT+8bOjvVe3/Uat5QmCap/4KTkAavGAUmbpWm44gYa7avCZxdR2vPW/r99bgMLI3doF9AzNnHvc+xMQF8lthZ2Rn0KxF4Hq5+EY2Z1x0ZKW1ZIrjIsJSDduXEeuFG8L07o5RHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L2wxD3mg; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L2wxD3mg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758232510; x=1789768510;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NoImQSe2Ibobow+qrBWVK3AYgYkckz2/p3U186v3fdM=;
  b=L2wxD3mgBodz83TLN1u3oiJAR5c+lqcvIxQTUmXlQSnxSrLguSgqXg4Z
   Br63OmBloXfX6LusiH/B4r4nSTysrxQ7l4omtEDSAJGzj8QGCUGUEZNly
   0IKFoXCeNC53m9B4bgqoiekIlE817+ghiNLdcTTGYRHPAI4h4LJgm7/pw
   uJHv9JkopK6gMPdRnb0HjggPPxiiuYEb9A/NvpjKgJeVbl1vjp9CcOZH0
   TKpi92UK+4k6U64v5ZrdUZr0Krz9Vfd1Ydxqpw9w7IWwV96ExFqg7z8J5
   YVjxUGWTFV6GZ9QNpM8jsYczFIpS0rBeIpSsv+R0YxK6wrnxD79PdYDnB
   A==;
X-CSE-ConnectionGUID: X13DObTKTmKjltyDFBv6uA==
X-CSE-MsgGUID: 0if4brQ/RIqiYUb5g2cUMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="72007183"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="72007183"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:55:09 -0700
X-CSE-ConnectionGUID: c8BEsyuLQ7GhmmtzIAUxLA==
X-CSE-MsgGUID: wgOC+as+S32uv2EAhiE71Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="180778941"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 14:55:09 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:55:07 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 14:55:07 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 14:55:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hk4pQSgTw+DIZF5pWmeU32WCucWo3P9ZTAcEDf3x5M1VSqYlLEtgAkM7PDXMtV/AdGkYPJJV27+KvZfIwqnZ1Vz1B/HZ1YCPkceyfmzra5z9qrl7HUtlpbykAk3hbmkwJAzlrTmXDe4Dhl5FnxEDu/DVK1xgSCLaeTwogdTRFo32/w4VlaT1dAXBJu6D1RaPca8vHh8qweHLWrZUaEO9CY/JmYU5C0TE9N/2OgKYhgMOnJm2UtwO6a1/VI1Vb+tXsxidZuJQw7ul31nSyDUda8kz5Q5c/Ut9o0+d+xmbK8D9r43DngU3kK4SpwO+XoBOw1RtUUrNJY6HS20bXKIwrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcpI/18/VZgxDghopMJ3vln4AW0DL4S0bKsrbDr58yI=;
 b=kIlOIb6f19hYEVSEGJ19SmdLRFxV0BeDAOEFCp9jimR7ouUYmR/BkKRsfF0ZfSi8cRA2SVF79iIUZInNXQ4E4TeLU7nYq9e2AZP56TNrlwF6XGHPLXtPpplb8HeTkgU2THPzcr2h0EB1C3EVyQGV45/w8Q9zzus70XAh/Ruypq45o5jjf2IjLsfiih8SgvQeYWJP8kC5i7cqQClTNc9vwcvoqTl1MuIgopXN7MCaTvxPbv9U2rjB0Ng/j/zl6jPuM2c6vi5YC8+DU61uEvq7rv0hPTW95HSP2KE+niRIxX9y20EECkZ0VdvKL0GmODXkDTRcUBtBlS1eoPDLti5tNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6076.namprd11.prod.outlook.com (2603:10b6:208:3d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 21:54:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 21:54:57 +0000
Message-ID: <69ec7c09-2c4b-4289-9f98-143a9618a7cc@intel.com>
Date: Thu, 18 Sep 2025 14:54:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/28] x86,fs/resctrl: Use struct rdt_domain_hdr
 instead of struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250912221053.11349-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6076:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd19595-14f8-4a4e-9e61-08ddf6fe01d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TG05cGQrZFg0aHJ5SHlScEo5MkdNWEJUNDBPWThvSGdYU1RKdlNuRnkzd1R3?=
 =?utf-8?B?MnltS1R0ZThxVjZRWEVhZ3V6VnlPVnVSYTFQV0Zha0ExRkpjUFUweGVQbDU3?=
 =?utf-8?B?Qk9JU1pFSUFxM0dlazNYb0JtcVg2ZUd1aUxVNmI4UWhIbmU0VjVid1ZXam5k?=
 =?utf-8?B?MEJBYnlwSkFRd1lFQmFkcUpEQTBUWkFwSzkzMEZoaGh5Q1NuSlgrVGpYaCsr?=
 =?utf-8?B?Y3pMZUFRZ1ZUSTMySXRDZjlyRldZTTdPbGIzSk81WVVKQmxDekhYc2lYVDRl?=
 =?utf-8?B?QkR4eUVPbjRyTlVjZjd1dDFRbzVSRS9kYS9WRlJXcTdyMG1RcUpLL0ZuOWd0?=
 =?utf-8?B?ZjJyaktXVzNzcmd6NWF4bVE3YUJOSzVHYWdxMXBkNE1yZG9aT1dnQ3grcW9H?=
 =?utf-8?B?ZDZuR29kc3RKR2RxUzVrSlJTdldWbllDMzJhWE0xcmw1ay8vUlI3dTAwNVBT?=
 =?utf-8?B?ZTBsWlU0S3lYQnU3T2d1Y21vSWRjVWZQRFdnTG02NGZnM2VEcmlRZTd1OGxU?=
 =?utf-8?B?S3BFaDNMb3hKSG50MnNQSTJMUmxoYXVuQzlRbktNajJybDdCQi9YaHZwQzly?=
 =?utf-8?B?b3A1UnpmcjJvNWdua0xUTCswdjNVdEJRV3BrRFU4dHFCRXczQThzT1JrS25X?=
 =?utf-8?B?SGxGeTBIcGx1YWc1VVQ5a1RJbGRITHFCSDNVZ2RadkN4bzFBQTRZeTEwK3JC?=
 =?utf-8?B?bXNLK0NkYXEyQVNYU0o0ZkttNG5zQ1FRZSszNzlkS0NPVjE4N25nZGoxaUVl?=
 =?utf-8?B?bVBUNllPOTVSM2oybStvcHAybnF3RjF1dUQxdzdVaDlGWUl0dnoreUJYSC9I?=
 =?utf-8?B?RUNXQUg0SDRiMTBCRnUyNUtmTXhQQzZDZ0tFM0Npamt3K3lyUG9GYVlqMWt4?=
 =?utf-8?B?Z1pKRE0xcW5TbTVFR3dEcytUNEhRK1ptS01idEZyWGRObFM2Vjhab0dyZW5P?=
 =?utf-8?B?RTJLNUhidzRMWWxjREVGYWRlRmk3RE1sSTRlR2FYY0s4S2pTRG9MdkZFYzYz?=
 =?utf-8?B?S1J6OW9TR2hERFRGVEN4aE9GUDdSWktPMjVxWENqTW9tY1JCVno0TE1DRVI4?=
 =?utf-8?B?K2tqQ1FzaUhQWENRdFJTOVc4b0hwYlU0NHpoUW1IL3AyRm5xZDBNcndLUExs?=
 =?utf-8?B?K1NybnNCK3AzemJ2ZlBvcTY3ZmgwMTV0UU52dXV1ekdnblh4ZTVZVWx0TWxD?=
 =?utf-8?B?QVFhVllxTG9DaHV4Z0lKdlNicTdwYTYwSlM5dDlQV0toc21vSXlTUWwwUEtp?=
 =?utf-8?B?SWljSDIzNlh0bmlhWkhjMUZQSlFHZzRrZ3V5K3JCeDVzdTdiVXQwMHZIcy8z?=
 =?utf-8?B?NFdVcENpYnlGUHBuWnRJSGJZdFl2ZW41bE1kMXRBNlAwSVUzdFlFR0lNRHlj?=
 =?utf-8?B?dGFNdmcxSFFVa0kyZ09TdUdZdnR2NUw1WHZ0SkpwQnpuOWE1MUVReXhXcDlH?=
 =?utf-8?B?cWxralBHK2UySXFPRk8vNjhCL1NBRUFGQVpPeGlWTWd3QXQya2cxYXcwazR3?=
 =?utf-8?B?d0JDTmttMmlsODhFM2RNK2ZoMXJEc1JHNTRwblFwNnNWNDZmVVB5TnExZmdq?=
 =?utf-8?B?QS9LbFBiYjcyRWZsTmZPbmtMZkw0VHRxanVLYVYwNTJhbVAxdDNBSkh4alFl?=
 =?utf-8?B?RXhza1hoalJXSURLVm5SZktXRkQycy9hYTdNZFcraXVaRFMrTnBGOS9WQkE2?=
 =?utf-8?B?Rk4xOG1aMmM0Yk80cEpxK1lUZ2czUHJXL2VSNzNVdHdGbE9Na1hqdGhkc2Ur?=
 =?utf-8?B?ZjJHWWx0QURrb1V3S3ZuM0s3Z1pBMzNKOGdHNTArSDVCM29Wa1F6WjVPMnBa?=
 =?utf-8?B?TUtCbkRUTS9sTGpUUDd2bGM2cVMxWmlJQ1Y0ejlmTzBWZGZsbVErczVENGNN?=
 =?utf-8?B?OERBNzU4M2JxbVh0Q0xUN01EaVR5ZGdqdkRGTTJWd1Q2SVJ3eS9hRDhBL21z?=
 =?utf-8?Q?nd93aRvt1ag=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGQxN2wzM1dkMUI1SmZuc3ZsUWJUa3Z3TDdMeTRPZ244QWsyQXVUcDVOWnlW?=
 =?utf-8?B?R05MVmh0VWJObENybEJSMUx4UXJaYW9Ma1hJNk9pajgxT214TzRSTFdDZXhs?=
 =?utf-8?B?aDBsZ3FadXd2TFVOcm05cHNFcExzUUNYcG1LS2wxVE1CTm5Vd2FQVENmUCtv?=
 =?utf-8?B?Z3BuYU9reFVNUmpld1BSMk1NVXJkSkJxRDkzT2Q5b05TbVNEK1BaZ09PVEpX?=
 =?utf-8?B?RkZWMHVXRW5sd0xIVEk0QS94M2VOOUNoTjY5RGVhV09hbmtGME5xQXFYSlV5?=
 =?utf-8?B?V0JjNzZtWEtMQzkwN0hpdEx5cER0cy9Sc1oxaXJKNHIrbGpYS0w5TnBuaXhG?=
 =?utf-8?B?SEN1QUlCTW5Td1JrK2x6OVZYcmdwYlR6UEM2cnpIT2ZqQTFBemRQY0lGdUh5?=
 =?utf-8?B?a2JHT3dxMFljb3ZUY3BvVVI2L1VyOStrdmVUQnY1djdyamJqdytLV0E0WmhO?=
 =?utf-8?B?UGdnK05vd3pBdWR0TEN2WWh3aVFmQnN1SjUzMGhESHpQU2phUGZwc0ZIZ1pu?=
 =?utf-8?B?SXlOMFRxMTVPZGV4bHMvR0NqWW11QVRaZ0NTZ2tCYTRCTGZmaCs5eGgxL2Iw?=
 =?utf-8?B?ZHpwVGttQWkyMzNoMVJQU1lFTmw5Znkwa1VKU1Z4YTJTMUxqMzR6NXYyWHlX?=
 =?utf-8?B?T2NlcGZrVlk0cENWdUhYdWttdVA3Rk5paEhyTml3dHI0UlEvcTNINXV1eDlk?=
 =?utf-8?B?R3U2TGJrUmtoTkNiaHRYazNNQTJ5L2FtRzJzd0RsblZUeWV4cWFFNXN1Ykor?=
 =?utf-8?B?MHZraVh1cWw0ZW55WkU1UzRodkowZlFLSXNuYWhJREhRancxbytaVWJkYk4w?=
 =?utf-8?B?MC9SS2xvUDU3Z1J2T1dyckpUYzNyYWFlc0lUbXhNRTR2cCtXbVhnc0U0U3NZ?=
 =?utf-8?B?bk4rWjg4V3UvVmdiYnFPY2tTZHJxV1hYTDNLU1JTM1ZzKzhaeWlKTHdZeW0w?=
 =?utf-8?B?ZFRpNEJmY2pUeE1aMzdoaVVtM3IwNkNKSDhtUFVZb3dYN1Qrdzk3QWhIQWQx?=
 =?utf-8?B?WnFSaUl0Y1VsNHY3Ym1hWHFHdFhOcUlkL0V4VFlUUEY4VlZFQndvS2g0dEI5?=
 =?utf-8?B?c0dlMFRPcGpIUmJkaGNHbVM2TnlpSDQ1R21RdmlYMWp5U0VjVGZ4WW9MM2Nt?=
 =?utf-8?B?SFF1Zy9oR1dESG55THAwUVY0TktDeEdDN1UwLzF1U29ueUVSb1ZKbzhnUkFm?=
 =?utf-8?B?dXdMbXlRWjltK1hvMDRkalFrUGZWY0N5a2tWK0lCVzFrRHhtSE92RVNPakNW?=
 =?utf-8?B?dVVvSVd1Qjd1cm5aRFFHeTJsRG9MUjdoaTY5a3Y5bkYrM0J0ZTNhZ2s5NUZh?=
 =?utf-8?B?YmdMczJSMzQ3TlJJamR1S0c0YkVsL25sRm4rY2MyRWhCUnFGcEZpSG5kc2ta?=
 =?utf-8?B?VEMzM3E5ZXRmdDZLT2JObEEvZHhrWEVVcDVFTm5paFVyaWJ5UGNMM1pDeTlq?=
 =?utf-8?B?VlVNVU9WaDFieXJUOUMrYmcyTGUzVU1WcjZjT3MrZHVtL1A1NTljUVRIUHVa?=
 =?utf-8?B?WG9Zemt4TXNyUWRNSmZpUC9iQjhUWE1rSlJnSUg0aTNGTTBVclBHelczNWRt?=
 =?utf-8?B?RjRCTVRpSnFzcUQ1elRQSG5IRE1kZnBPSU0vZTRQQlhSekJ0MkhydUpFYUtO?=
 =?utf-8?B?dUMza3NVQUxaelJKRjNXa1U5eTRmNDBoS0FSbjFEekNkZ1lLSG1XWHpOSDU4?=
 =?utf-8?B?QUh0WlAyUnJ1NlZmZTdpaVNvcDlTR2dBSlVFdWlLK2J4cnFXU29kVktEQm5I?=
 =?utf-8?B?NkhFbitXeHlOYldlbWF0NnFud0JZY0UvbkIyZnB5Z2w2QSt3WXhxWnpHbUpN?=
 =?utf-8?B?UzZURHhhQWhMNUNvZ2pxUVZ3ODFCQnhPYVJ2cFZvaVphN2QwUDZSQXprR0ZO?=
 =?utf-8?B?b0JwMFAxNzUyQkZYbHVIcnFYU2NsR0dXQXZMVWg5dmxucThmSFc0b1Azd1FC?=
 =?utf-8?B?VklkblNpUjZ6MXdIbnNOaThPcFh2YUowQ0JIcWxicUZOU1pjbktlUmhSY2J3?=
 =?utf-8?B?UGpFTzNHZXhvTm1hbndjU1pTelZVQk5rVFE5bkVsM0g3SVB4QkFvbENoM1Vz?=
 =?utf-8?B?VGlwTFRQSjJvMnN4SDVPRzZDS090Z01DL202MTZ5MGp6WTNzMWNEY0FaQTc2?=
 =?utf-8?B?UEZibUJrRmdoQytMRnlHVG1GRGRDdWIyQUZ1cnFEeFlwTVFOMXZYcWdmTUJs?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd19595-14f8-4a4e-9e61-08ddf6fe01d1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 21:54:57.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9Ofv6Ij9sH+gW6gsbZYQrvBCjcYJIgPiZ7tIAhZG9tenlLrW1T0QZ46bqEG3ApSXXrnUzAWuchyBob+ab8uoAhPFgZciSPW/FKYEG7aKoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6076
X-OriginatorOrg: intel.com

Hi Tony,

On 9/12/25 3:10 PM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource and it made

(copy&pasted intro)

> sense to use the L3 specific "struct rdt_mon_domain *" arguments to
> functions manipulating domains.
> 
> Telemetry events will be tied to another resource. This requires the
> functions that manipulate domains to not be L3 specific.
> 
> Change the calling sequence to use the generic struct rdt_domain_hdr for
> domain addition and deletion to preserve as much common code as possible.
> This will simplify enabling of enumeration of domains for events in
> other resources.
> 
> Update kerneldoc for mon_data::sum to note that it is only used for
> RDT_RESOURCE_L3.

Above seems unrelated to the change described in rest of changelog.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> Note: To maintain bisectability this patch adds:
> 
> 	d = container_of(hdr, struct rdt_mon_domain, hdr);
> 
> to mon_event_read() so that the chnages to the event reading code
> can be cleanly deferred to the following patch. This doesn't need
> a domain_header_is_valid() because RDT_RESOURCE_L3 is still the only
> resource available at this point in the series. This call to
> container_of() is removed in the next patch with the completion
> of the conversion to using struct rdt_domain_hdr.

Why not just add domain_header_is_valid() to make this clear and remove it
in the next patch? That will take less effort than to justify not doing so. Not to
mention the confusion introduced by this patch.

I believe this is a consequence of this patch mixing three logical changes. As I mentioned
in https://lore.kernel.org/lkml/40461810-95e8-4efa-bff4-540ef01051f4@intel.com/ the
work is very hard to review when changes to support package scope resources are sneaked in
under the guise of L3 refactoring.

The changelog already hints at the confusion, it starts by stating that there is a
requirement: "This requires the functions that manipulate domains to not be L3 specific."
Then the changelog presents the fix as "Change the calling sequence to use the generic
struct rdt_domain_hdr ..."

Just providing "struct rdt_domain_hdr" will not suddenly make the code not be L3 specific,
right? Yet, the patch self makes many more changes than just "passing struct rdt_domain_hdr"
but instead also starts adding support for package scoped resources by pulling out
the L3 specific code not relevant to telemetry events. 

Please let each patch stick to one logical change. Only do the switch to
struct rdt_domain_hdr in this patch. At this point all monitoring code is L3 specific
and it is not necessary to exctract L3 resource code. The switch to
struct rdt_domain_hdr instead makes doing so as a next step easier since it
makes clear what code is L3 resource specific. The code flow changes in support of package
events should also be separate ... but I already mentioned this in response to v9 :(

> ---
>  include/linux/resctrl.h            |   4 +-
>  fs/resctrl/internal.h              |   6 +-
>  arch/x86/kernel/cpu/resctrl/core.c |   4 +-
>  fs/resctrl/ctrlmondata.c           |  11 ++--
>  fs/resctrl/rdtgroup.c              | 102 ++++++++++++++++++++---------
>  5 files changed, 84 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index dfc91c5e8483..0b55809af5d7 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -504,9 +504,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  			    u32 closid, enum resctrl_conf_type type);
>  int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>  void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>  void resctrl_online_cpu(unsigned int cpu);
>  void resctrl_offline_cpu(unsigned int cpu);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 10b46cd9e394..6c78b1a4ca3a 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -82,8 +82,8 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>   * @list:            Member of the global @mon_data_kn_priv_list list.
>   * @rid:             Resource id associated with the event file.
>   * @evtid:           Event id associated with the event file.
> - * @sum:             Set when event must be summed across multiple
> - *                   domains.
> + * @sum:             Set for RDT_RESOURCE_L3 when event must be summed
> + *                   across multiple domains.

After reading changelog this change is unexpected.

>   * @domid:           When @sum is zero this is the domain to which
>   *                   the event file belongs. When @sum is one this
>   *                   is the id of the L3 cache that all domains to be
> @@ -362,7 +362,7 @@ void mon_event_count(void *info);
>  int rdtgroup_mondata_show(struct seq_file *m, void *arg);
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first);
>  
>  int resctrl_mon_resource_init(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index c6ce72cba543..ffc154189abd 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -533,7 +533,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  
>  	list_add_tail_rcu(&d->hdr.list, add_pos);
>  
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>  	if (err) {
>  		list_del_rcu(&d->hdr.list);
>  		synchronize_rcu();
> @@ -658,7 +658,7 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  
>  		d = container_of(hdr, struct rdt_mon_domain, hdr);
>  		hw_dom = resctrl_to_arch_mon_dom(d);
> -		resctrl_offline_mon_domain(r, d);
> +		resctrl_offline_mon_domain(r, hdr);
>  		list_del_rcu(&hdr->list);
>  		synchronize_rcu();
>  		mon_domain_free(hw_dom);
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index f248eaf50d3c..3bbfb5398e6f 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -547,11 +547,14 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>  }
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
>  {
> +	struct rdt_mon_domain *d;
>  	int cpu;
>  
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> +
>  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> @@ -598,7 +601,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	enum resctrl_event_id evtid;
>  	struct rdt_domain_hdr *hdr;
>  	struct rmid_read rr = {0};
> -	struct rdt_mon_domain *d;
>  	struct rdtgroup *rdtgrp;
>  	int domid, cpu, ret = 0;
>  	struct rdt_resource *r;
> @@ -623,6 +625,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> +		struct rdt_mon_domain *d;
> +
>  		/*
>  		 * This file requires summing across all domains that share
>  		 * the L3 cache id that was provided in the "domid" field of the
> @@ -653,8 +657,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  			ret = -ENOENT;
>  			goto out;
>  		}
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);

Ignored yet again. :(

> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> +		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
>  	}
>  
>  checkresult:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ce4e716e6404..8f45763ff515 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3029,7 +3029,8 @@ static void rmdir_all_sub(void)
>   * @rid:    The resource id for the event file being created.
>   * @domid:  The domain id for the event file being created.
>   * @mevt:   The type of event file being created.
> - * @do_sum: Whether SNC summing monitors are being created.
> + * @do_sum: Whether SNC summing monitors are being created. Only set
> + *          when @rid == RDT_RESOURCE_L3.
>   */
>  static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
>  					struct mon_evt *mevt,
> @@ -3167,17 +3168,27 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	int domid = hdr->id;
>  	char subname[32];
> -	bool snc_mode;
>  	char name[32];
>  
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	if (r->rid == RDT_RESOURCE_L3) {

This is starting to add package scope enabling ... much more than just providing
struct rdt_domain_hdr as parameter. Providing struct rdt_domain_hdr 
(especially when combined with the struct rdt_mon_domain name change) helps to
highlight which code is L3 specific. With that done a separate change can build
on it to separate L3 specific code from generic code in preparation for package
scope resources.

If you want to keep code like this then the changelog needs to do a better job
of explaining what this patch does.

> +		struct rdt_mon_domain *d;
> +
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +			return;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +
> +		/* SNC mode? */
> +		if (r->mon_scope == RESCTRL_L3_NODE) {
> +			domid = d->ci_id;
> +			sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3187,19 +3198,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  	}
>  }
>  
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     struct rdt_resource *r, struct rdtgroup *prgrp,
> -			     bool do_sum)
> +			     int domid, bool do_sum)
>  {
>  	struct rmid_read rr = {0};
>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
> -	int ret, domid;
> +	int ret;
>  
>  	for_each_mon_event(mevt) {
>  		if (mevt->rid != r->rid || !mevt->enabled)
>  			continue;
> -		domid = do_sum ? d->ci_id : d->hdr.id;
>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>  		if (WARN_ON_ONCE(!priv))
>  			return -EINVAL;
> @@ -3208,26 +3218,38 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>  	}
>  
>  	return 0;
>  }
>  
>  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> +	bool snc_mode = false;
> +	int domid = hdr->id;
>  	char name[32];
> -	bool snc_mode;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> -	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> +	if (r->rid == RDT_RESOURCE_L3) {

Same here.

> +		snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> +		if (snc_mode) {
> +			struct rdt_mon_domain *d;
> +
> +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +				return -EINVAL;
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = d->ci_id;
> +		}
> +	}
> +	sprintf(name, "mon_%s_%02d", r->name, domid);
> +
>  	kn = kernfs_find_and_get(parent_kn, name);
>  	if (kn) {
>  		/*

...

  
> @@ -4290,12 +4318,20 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  	return err;
>  }
>  
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>  
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	if (r->rid != RDT_RESOURCE_L3)
> +		goto mkdir;

Ignored again. This is not working. So far (and it is just at patch #5 :() the rebase error
and changelogs not reflecting patch changes let me think that this was rushed worked. On top of
this there is half addressed feedback to this patch. Again without any discussion. Also, just in
this patch two places where feedback was just simply ignored. You submit this and expect a
thorough review? This is not reasonable. I stop this review here.

Reinette

