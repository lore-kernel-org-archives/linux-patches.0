Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC978285
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 20:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719608220; cv=fail; b=TyN5D3Nh7+WDGymZIOGIJ2MlekA5xB315c/7BW2aBtn/321ZHGarnMjxuBmee/o/CUEoffiz005j2t0yAr3ucKIeYasehl+ze6ilg5Llcj6NZ+yO6pzrzMI8D74Ay+d7zfHEC8k1924sWPEo7AgfTBZNG+zQ5/E7Jfi9i5vgAT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719608220; c=relaxed/simple;
	bh=ddYvRXYb6DrghQHfNofCi7fHMWsoEjs46k8xGsxUnkk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sgAnYSkIWyQbFGRcTaGltSK4bU/fgyd64h+xje9o9Pi9NQ5OicQ/4NHlVYoH+3BIXY2etwzHsDLq9DW++Sl7rtS++y62lcGzCYqpJawqWogliObM/fSMLWsQR+uxAcECDns7S1rFD9N9DEwVexb9PeYXG3EBBEVYZVvYx8YSWIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NDV1a6w/; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NDV1a6w/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719608219; x=1751144219;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ddYvRXYb6DrghQHfNofCi7fHMWsoEjs46k8xGsxUnkk=;
  b=NDV1a6w/+WFtFxQnFmUxtFs16W2gDJsUd9tf/7CDuO6vpH1jDmFN46Kt
   BLE5FVK2AIusG7gxg0MaR0R+CbV3/ltj0LV8ricOuFSjk3MetfwSRSSQd
   /UiwtC1n3hk/9n42VSx0jPIftG9JHvtp6oebe2pbjFdOjDRGDtCacBhI+
   JQ5Z1hP0sgXf656ZVCkNCVE4JwkOiQuEbwAVhdDySjaAN+/GxRVBBXABI
   R7IA3nYy+7XSaskFArXQAX7lldArGl1pcql9ODIgOQbj+0Q0eUhAHMx3b
   tt2XHW8aGQnG1LGdO/YlyAL/LemAjpcrQ0l+OFmydXLUrIx0HUbSoKVSN
   A==;
X-CSE-ConnectionGUID: ZZRQA7g9QZCtR2Fp22/Cgw==
X-CSE-MsgGUID: 2cnLiGTUSMm2L9YBKr9swQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="17027700"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="17027700"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 13:56:58 -0700
X-CSE-ConnectionGUID: ca2gmiyWTsG2TJI23AB1Eg==
X-CSE-MsgGUID: stfysP2XSTaSUOF2ShJkUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="49322565"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 13:56:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 13:56:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 13:56:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 13:56:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 13:56:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLwh6Xi6+yX2NAKpvQjnLwrGwQ/n8VEnSFt6zCAnlQXGJFNESFd3ZEa9M+b/5ZJhvwbZfGIFzrztw09hHAAzw/GzJ+LSKKg2ozbRts0y6DFhWoe3kni/IOfYUJmiQw1ccy098DEzppHWv3d84Gq0wFv/Ls5od5ryPZq7B25LoV6FYuEsX0HT/gg3B7EgPxJOxFPrhGyagdxkGkL898k2NL7Kgjj+N9gsda9jX+SA+x9gUINeObsK5FHv0pgSsCt2wiEs6TS756nKhyZLOfdW5s1FVzddXgBUUkOmVW3XJhRx87PWRY7/s2sorLip76CYKK42WiP4UFuk8UqINr5bgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cesD5XzmC4OHtKm6myP4744H9iGuaHP1c8y/FgMgRuM=;
 b=MySHLIZKn00Lxm9GUmjDTgH2j8zUStMbtiAC6J4ViAXCpTedwsb2VSllmlN+joD5JqtQIxxcMI5vosReJ00HzU0YT5bsEaiJy2hKBbX1QzzKDVTrjZQR+jYY7Px3i1ydwyGJw3Jw+h3WIDL0Wd7QiJsew5X4XlAAxrXtUiuWmu/76cXdYDhiEdICg2QeNsxmvJ0aM781m6uOaYNZBCxuFGAro6/10e9c3uvo9OocmInTzgCrcfCwBGoAvTJM7qgMPYd2rAksvUa9RgjrnCsWHivW5XhdrOgaDgrZNylAJme9z3+n0vDlHMwxy8yqCiJieD507xdc3O/KKqZzSAJztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4525.namprd11.prod.outlook.com (2603:10b6:806:9d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Fri, 28 Jun
 2024 20:56:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.033; Fri, 28 Jun 2024
 20:56:54 +0000
Message-ID: <8a2782ed-0fb9-4843-8437-18de83a04947@intel.com>
Date: Fri, 28 Jun 2024 13:56:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 15/18] x86/resctrl: Make __mon_event_count() handle
 sum domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240627203856.66628-1-tony.luck@intel.com>
 <20240627203856.66628-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240627203856.66628-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:303:b4::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4525:EE_
X-MS-Office365-Filtering-Correlation-Id: 65a571da-c07a-45cc-1c11-08dc97b4d773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NTZBZk9hUS9RQlJibjFickN2enRkMW05MTNvL2pGMlNoMnVHQzcvaEc4TU5Q?=
 =?utf-8?B?OWxYTlNmZnZyZC84MlZ5bS9IOGNVRk11SjV2Z1BkeHVYd3Fta1FaZU93b1Ur?=
 =?utf-8?B?SG12eHpIY1oyNzBHQUhMRHlUU3Z1YWxHZGdiV3Bwc2ZHVUVNM1psbnVHcUVr?=
 =?utf-8?B?a3p5NFFhNEc5WTJMd1VPUWk3VktpcGdlMUVLOVdIRHFyWFNIZnBXOWNmUHYx?=
 =?utf-8?B?U2FneWd6eThoaG1aUUtKSGowUFNsc1NqZHRXNjFkYjZNTEVxSWRkSGFtMlhF?=
 =?utf-8?B?emFBQ005clJvbjhRc0F4b1BwNk5mUEMyWXpjZXZmYng3K2dteXBkQ3JEUDAz?=
 =?utf-8?B?dnJ1OE02TDF4M0UrY1d0MXF4MFdVYzJYRUFJNlZCdFNubXBJdzBHQXN4VWtK?=
 =?utf-8?B?aVUvZHoyNUZqdEo2bkRucXNSbEtPZUsxMWh5U0ppTk1DZ2pNQ1Z0Yk53MmRa?=
 =?utf-8?B?Rm9id3g2SXdOYzQ0NkJ4ckthOVZSRVl4aUxQQnMwbjdBaitCY3d5bWg5QzhI?=
 =?utf-8?B?SjE1TW9tdzgzVUdnSGl2ZU5TUjVONWE0bi9FZ0RhemR5RW8xdzNSa05VRU94?=
 =?utf-8?B?Q05QWStwWjFXWmZVUzV3VXJmMUdEbHh5cXllUTd2R3l4Z3FFN2NuOGxaQ3Bm?=
 =?utf-8?B?Ymt1Wnl2WGFoemF3VmxkRE5QUEhZZ2M3bjdyOHNnc0Y0c1RsZnRDTUV2SDk2?=
 =?utf-8?B?ZFdYM3R5SHA0WVZSbE1XcnM0S1lDcjlwTXpINVZDQWUxMGdpWmxUUmpuNGlO?=
 =?utf-8?B?K0IzS1dNcmxVTlJ1TFBGdkxTeWNYRXZmbURMMjVCS1E0Q2wreE5wOHlHOC85?=
 =?utf-8?B?VGlmZXAwY21lalRKSjErTUtqU08xYWtlWEtFVVRlc2JsVWZCblBzU3VlQk9T?=
 =?utf-8?B?MDVna2hWYmJFZG0vY1VKa2Z2WWhSN2xMRmZLeVBHMzljZFZYR04ybnd5bTRp?=
 =?utf-8?B?YmkvSndEakNSZzdkeDlHNTgwai8ya3lmWmg5S0czbmpTWk5OYk9CR0JzVGsr?=
 =?utf-8?B?b2pWZWFnZTk3T0hKT2RiandjTHJjTlEvQ2xRb2MvbW5FOEMxd1ZTS2ZiTnMx?=
 =?utf-8?B?NW90NVdydXBMek1WMjBLdFZmMEJyMC9Nb09mMzVPZUhRMVhneW1PMk5kTFZn?=
 =?utf-8?B?SEpqRi9EYjJmeXFkOVdMaGdUYmgyVjlJNHdWUWtzWFhxUWtjMmRuOGhTRi9K?=
 =?utf-8?B?eUxmcjRka3VzYVF3clJDd2FEWkZYYkJjR3hacXlDVEkyK05FMW12SlhtcjMw?=
 =?utf-8?B?YVpkN2RyQWpsRkJyMS9EYmhFRmZBenV1OWQxcDNtci9hb3pIWngrdGUzNUVR?=
 =?utf-8?B?aEVJN3JNMCtOUHNCWHhNRVdYMWRFOGxoOU9scTRpTDJpZEp4UDFUYjdpK05U?=
 =?utf-8?B?WlMwait5ZEZWbWdmQmE4emh4bUtvZXVYZnVpK0pMQ1UxcGNyUnFXUk5LaFdq?=
 =?utf-8?B?M3BNUXVmeGVTb1ZZbzJnUk50M2Vjc1U0VnhVbWZxRlcrZlBYTUtTZE0zRWFU?=
 =?utf-8?B?cXhFVDF3dXVBVXVQb1Z3TmVKVFMyaHIydXVKdkJ2SVNRV1BvUEMveTVNRlo0?=
 =?utf-8?B?cXVhcW03RWxaSFpkc2E0Q2RFM09uQnNJUkZ2NUV4Q3pGMG85Z21VV21xR3g5?=
 =?utf-8?B?bUxWRzFxZThMMGJUeTl2U1ZQZUMyWlU3QTJTeDNXVTVheXIreEVxSkloRGY1?=
 =?utf-8?B?czJSMkxkUkhqVXBGYno2VExMUDIvUURkL1kzTWFveWtkakxEMmlHb0ZHQUJ6?=
 =?utf-8?B?bnoyaFlGblB3ZVo2Lzd0SDgvekI4R2RKNXRkVFdmY3NRU1VwL1hJWnJtbWRq?=
 =?utf-8?B?eW1wWExGTFhRekNRTEc4Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXh6cG1ZaHV6bFdTZ3FibndaYTRxcTNpK29LTnJXU0xYRWRaV1NrMndaQmpK?=
 =?utf-8?B?V2hKQVNsNWpxa0hwQ1NGZXNYNWl3Zy9WcThJV2l3bnZUWXJtcnJaaXI3U2RB?=
 =?utf-8?B?K3lORVFUZHFPSXBDQ3VmYmYvWTNBWVZ5TFVLNXRVcGd6WDZGcFFBNUx1Tm1D?=
 =?utf-8?B?NGhUamFVRG5meWJGT2ZUbHl2Z3lUdGdUWXdqeHpGNTNmeFZUcHo0Z3BwZGNM?=
 =?utf-8?B?VGhMQVFPMjRaaEdQRWdQcXVIeG9EMHEvUnU3NytpblFlVmp5UGdBSjJZQXox?=
 =?utf-8?B?TjZFUUh2aUtJK04vWm44T3orSS80RHcyYktERmJnbURGTS9FakRqdXMwQVF1?=
 =?utf-8?B?ckZuU2xzRE9uMzhwWG5YdHF3WjQ4OUxSNmxmTzlUVnlWNFljY2o1UFRBT1Yw?=
 =?utf-8?B?OGpYZGJHWWp1U3NqbmJHTkZUK3h4bDNHaTZlWTlsZnAzdEdIeFkxaExXbEJs?=
 =?utf-8?B?RUx0Q05XcFRPRXFaM2VUTnNFV2xUZUwwZTZWS2pRVXVENTRkU0NjRG9paGY5?=
 =?utf-8?B?bjRvckxPa21Bc1p2ZDJNR3JqYnJ3SHJMcTlBWUhnVXp1RUt5b0ZuMWwrY3Vn?=
 =?utf-8?B?Z2ppd1hKOUhuV0JvR05ZN0Z3Y24xYkl5RDhhRkNacGxObWY1cUY0NVNZK2xG?=
 =?utf-8?B?dTBBb20xZCtiVzQ4Q2w0bzczMGZ1ZGJkWnM1SFFPYjl6K1Zvby9QMGFwdFJW?=
 =?utf-8?B?TXRSQ1p6VkJvNlFuRjNjZ0g0OWJMTnlDYW5xQTUrOGNqN1hKTDdyK0RRQTJV?=
 =?utf-8?B?Z21WZnJBcGNLdUtPbE1PQlNBaXFHNEc4eUlNcnhYTUZnQnBYUFdZbGUvb3Rw?=
 =?utf-8?B?WEY3eTlWZVhQNTJhQ1M4bTRFOS8yOWFGdnpWL2RCbU9peG5PdTVXeW1lQk1k?=
 =?utf-8?B?V0ptcUpRMTVteWs3RTJ4Y0RoSUY0UVM1TzVOdHMzc2Z2N094aXRlSUI2L092?=
 =?utf-8?B?Z1BOY0U4MHNiUGZKNDczZ281T2tPTlUwVFpIZW5JRHlyRHBPdGtwZ3VwUzdz?=
 =?utf-8?B?K1BkdFI3VzBVY2ZjYTRvTmQrK2oxZ0gyc0ZBOVRsMWRZMmlEYkNFbTVhaEJI?=
 =?utf-8?B?UG50UHdNYk8vdHhsMGI3WTJZVUcvUEdWdFlrVXdvTWplOURYUXYxNnRZZGg0?=
 =?utf-8?B?c1FERFFHMzR2NVpSQXNtNktzTG1BWVp6Z0RGbFRhSGlQRnJzWmhQbmFXMVg3?=
 =?utf-8?B?bFJxM0ZLbTh4ZG9WWTVvbHdBV1VQSWppNWdmR0VwWW1lWlFvZTVuZkVBb01P?=
 =?utf-8?B?K3BSbUJ6OGIwMUlJeVh5S3o3VGJ0UCtJMnB0cEhzMmRnRXNmK1pnRWJ3YUM0?=
 =?utf-8?B?dXdlZ3p1cDlKRnhhZFlheWRwNmdaaDR0d0dtcXQxL2J2Q3BIMXNMRnoxdlVj?=
 =?utf-8?B?NkFKRHBRb2VQSUxoNmZHU3JZTzhSL0tRb213b0dpSllOK2ZDNTlVdjJkcGY5?=
 =?utf-8?B?aHBLdkhDaVlQTmY3Z2JjTDIrWS82WVBYVmFDNW9Lc2RlMFR2RWlqTVJSMVJm?=
 =?utf-8?B?WGdIbmdnZTc2MmhsOTlNVTFHSkNEWWJMWk9LZ1JOaU1JbUIvbVVMc29aNVZu?=
 =?utf-8?B?bmNqSlNyZ01scVVESGIzcEh1dXdyWlJuT3drUDQzeE1BWjFHQ3p3cllab2xh?=
 =?utf-8?B?VjFLL1ZQSG9udmw5WExMcUc1RUFKbzZEbTZjQ05Cand6TzFucWpqWGh2R205?=
 =?utf-8?B?QkxHNVA1UTErc1o5ZGpTaEc4NG9XaEhPU25jVnRCZEExRlkwdGlpUTh5RmZI?=
 =?utf-8?B?L09kMG1ydStXVGxMNkdmVWN0YTk5N08zbUd2MDcwOVR6OEZuRmt3UDJiODZ4?=
 =?utf-8?B?ZWlCTDhSVU0wdDMvYkRFc0ErOHJma2VsQVNXUWpoUXExNlpJeHRtWU53cFo5?=
 =?utf-8?B?UGdlNTVkQTN5MGpNUklySHgwdUlaZjgvUTloZXpIZlVERDE3UXRGVEt1NXQx?=
 =?utf-8?B?STBpN0FhSHJYSXFVUFp1eDdIQ3RVL1VzcFlLOHdFdTVENjJRajNScGdVdnly?=
 =?utf-8?B?emJVN29wM1VuTDBXdmtvL200cTJiWldyVloxQXJEZnR0WWpMR3hTbndZOEJM?=
 =?utf-8?B?Skhnajl0ZG5ka21vWUpMQjh3bEh5b0FCRUNMdW5TYmJIbXg0bkdtZnZwcnhE?=
 =?utf-8?B?dlNMU1RwbE9MWmJYNmZNazdNMXBuOVlpYmlzVmQ0ZTBiMFRDSjZkd0ZFYWNz?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a571da-c07a-45cc-1c11-08dc97b4d773
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 20:56:54.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ucYkR+LLEUvF+O5kZ9Tl7bpi75odOUf0ufB7x4tItsrnBCJxDCO7QRpNQwz577Rn79vYNeXYlcDopXiBSCBScEHSmo5OwdW9Yja4G0Cf10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4525
X-OriginatorOrg: intel.com

Hi Tony,

On 6/27/24 1:38 PM, Tony Luck wrote:
> Legacy resctrl monitor files must provide the sum of event values across
> all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.
> 
> There are now two cases:
> 1) A specific domain is provided in struct rmid_read
>     This is either a non-SNC system, or the request is to read data
>     from just one SNC node.
> 2) Domain pointer is NULL. In this case the cacheinfo field in struct
>     rmid_read indicates that all SNC nodes that share that L3 cache
>     instance should have the event read and return the sum of all
>     values.
> 
> Update the CPU sanity check. The existing check that an event is read
> from a CPU in the requested domain still applies when reading a single
> domain. But when summing across domains a more relaxed check that the
> current CPU is in the scope of the L3 cache instance is appropriate
> since the MSRs to read events are scoped at L3 cache level.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
