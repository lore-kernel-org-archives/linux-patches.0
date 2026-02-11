Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D2288C20
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 07:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770796622; cv=fail; b=hq7tSatxBiHtg3apQVPb1tiLduJL3JctD0cGQR3P1ksCfXjolpJKqffCuEpDynDUxz6iTc0KiEn+PQKg35YpesS+yuLs63nmG9ax71gMLVcDnaIsnOulx7NweRwr1dCMGewwcIynjMs5blVxQ8zY0TgvyKJPczP9uxqzf9aiICA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770796622; c=relaxed/simple;
	bh=9beYi2ilZg95N5CW3YOKvo9ft/GtbWmkw1R1RYbIV8Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dJZ2fiWfZXkr6AbawC8xUBhOeyjwHORk3hBSbrdeq6CSNyBeH84/RF+4EqWgOq277P0AK77Echy6ME7V+yxzlOseHtEc/NulwXQ6sR1sO8b47kihfd/151bY2mL+XyLd8zFEMFUMB7m68RcYkK8c3LMLvVQxEqT/2MYERwPOiLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLBtrc0V; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLBtrc0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770796621; x=1802332621;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9beYi2ilZg95N5CW3YOKvo9ft/GtbWmkw1R1RYbIV8Y=;
  b=LLBtrc0VNsQv4KJHqHMTZGc17bxiKaV/EGbMknbPH+U8r+nsHR8KDBV7
   IssAZHaLTegJMsKc4z5B7rqlgxhnWU2f6F2zsSWb9LTR9fsN97+CXAqzK
   B2FeZdmVFNgX5gB91cK99iXwccf5jnZdOA2aCzceVZ0f71+54Vmwb0A1K
   7TBVmcDFC0KuZg7kBf8yCV74OWo1CuG0eLM/AothOWCq9dKuWzQxpMf8B
   WWC3D94Xt6YstoNvsUZJnPa3woeegRCdmJhoKi/M/H2ShAGw8EqoDZbjB
   jHa86aMQ8kFGaMHbgGlL7hN9QF2ApYcNsnC9cOnRxobzIk2j41cLZlMru
   g==;
X-CSE-ConnectionGUID: INTiwPpeQ2uhD5r0kHey7g==
X-CSE-MsgGUID: zY5YrZjORBKQIS6uE0rTwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71835566"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71835566"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:01 -0800
X-CSE-ConnectionGUID: aodVBpnVSumFnE0qGZTRjg==
X-CSE-MsgGUID: NQUJ7642Qvat0C+1GOKvmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="235152501"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 23:57:00 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:57:00 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 23:57:00 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 23:56:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bptUvpX1Y5Yu0jCI8RxdfHSvvmtbT58B+bfRqMHd9uaI82OHSfEAydDCHtpxR0GI8lm2uJeXpDBJ7hFvLvKHwxILGgtbNli0ukpPRuS451fGwdBB2V5pQ19O4y1RGurPC/FxNTW9nIyCsAYsvJntk9QHzPH+FImK2TRvGp95450i7sfVUNuQPji0FpJFNeRxWh2iWOfIBfWMxB5Il/2bz0l+kYDMhWo1PTKFX5eAN8qhfvHGMh1FAyZSz7Hv/UZICHkrcezRh4rpfm6ivrzd/QGsT0jPd75JeUQ/L8HYvjNDV3zs3UpZdYdmCiumIwRa9dbvQ6oPmgjjVinSBAgOSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41AU7gk1E0CAVpAvYMkyhAcYpmF2c0Qd5yIqHv7F7C4=;
 b=KlwuDqLTCrSfhLd0+RlOVVfdgeYECd7YXCdzA7yfKLlSmipwC7wTTVWCG4fyATIX58ynCzZB5DlhO+8aww+9x0ABBbXj38BSDBK1xwfIIQnQjX9QKjc5Vyr2WW1H5Bsn4L+MbpE3Gmyc2mlmmC9t5uPxcqnvCeAwkYh3KUu3euVR+Kg2toI9CTMZQQU5N/EYTmZIPYICuDweE3PAtILb3cgnIIku1YwAIpicMOFXsnxX7mPtWXydMOpCnDo0YvBol5/ntXjyMHIvFxASmwmhLOxvQ6rLGuPgoOjnbWj8Z806kTJa7lBmSnSkcsMeS3m3Na/prM5SSB7J3njVf27y9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7215.namprd11.prod.outlook.com (2603:10b6:8:13a::13)
 by SN7PR11MB7973.namprd11.prod.outlook.com (2603:10b6:806:2e6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Wed, 11 Feb
 2026 07:56:53 +0000
Received: from DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7]) by DS0PR11MB7215.namprd11.prod.outlook.com
 ([fe80::cba:8493:6cff:5cf7%5]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 07:56:53 +0000
Message-ID: <e4687c44-aa84-4b6f-9871-b24cf53013a9@intel.com>
Date: Wed, 11 Feb 2026 09:56:49 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci: Reset
 RING_OPERATION1 fields during init
To: Sasha Levin <sashal@kernel.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>
CC: Frank Li <Frank.Li@nxp.com>, Alexandre Belloni
	<alexandre.belloni@bootlin.com>
References: <20260210233123.2905307-1-sashal@kernel.org>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU7P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:54e::9) To DS0PR11MB7215.namprd11.prod.outlook.com
 (2603:10b6:8:13a::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7215:EE_|SN7PR11MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dfaafaf-e195-474b-8a73-08de69431e6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T3VMYnpIVXgzQ1FRNjBJbWNJNlhOY29HME96UmZ4QkJieVpLNEdNaWU3aDQv?=
 =?utf-8?B?RXBnMVRxRXc4Tm1CQUFqV2h3dFJPNE1pQ0hJRHFPTjE2VE5WV2E5TFk1Um5O?=
 =?utf-8?B?dmtwT011bHc0ZksyVkJVTklNK2duZk9DeHQvbHZyVitNTXlVUG1FUFNKRitT?=
 =?utf-8?B?Ym5zbGZPVW9tLzFnQk9CMi92VktVNmJ2MytVRk9SZXp3KzZCcDljQ3BJSXU2?=
 =?utf-8?B?eG9Dd2VyNDFKRGEvbS8vdHY2VEw1Q3QwVWhnbDNQUDZ1VDIzN2V4UnNjWEw1?=
 =?utf-8?B?ZG8zek9kOE1vOEtmOUVLMjhYS1YvTlllTzdtM1EzVENvdFp0cFRVMDhsSGVv?=
 =?utf-8?B?MlNVNVh2RHlHVHFXRldESG9vaFkwd0RlUkJDQWlLSGhFR21WaXNIWllsaFhY?=
 =?utf-8?B?dnJLdStkcGFOV3gwZzk5OXp4RG9MWm81c0hGUzRneVVidlc2WC9NUzN5ejYz?=
 =?utf-8?B?QURScHM4WVdacStPamlrRlIvUjVSSzlqTmdiOGQvWHY4TVlnL0ljSXlGcWJk?=
 =?utf-8?B?aVNJcjJBblVVeFZ4SE55MWFmNStOOTBEM0pmck9HOVRoa3R1ZWNtYkh2aElC?=
 =?utf-8?B?S0lOZncvd3hRRkFoVDVxaE9VRUhoZ25tdXNFd3VpUzhSNHg3d1BSbC94SGJT?=
 =?utf-8?B?dTVGeXR5bGhLdjc0a3Z6Zkh2aEdjTFBvOEZVNmcyNUJmdS90ZFRJaC9BTG5D?=
 =?utf-8?B?UStsbUp0QitrQzhMd0Z2UWpUV3ZRWXlrYnFNNTVuNUtmMmpVaVV4SUM2Q1J2?=
 =?utf-8?B?WndZSWFmMTByV0h2Q2hRV1pMdFVacUl0OUxOeTFEVGtORUlKRXdSVlRnb0Zn?=
 =?utf-8?B?bW9OYzVYb1c0OVlEUzMxQkhjRlZtYUVaMlJrbUZ6QTZZNWl0NGRFYjk5NG9T?=
 =?utf-8?B?dHpyOE5OTm15dFRZZDR5V05JUzNpQXMwZTFhQ2MvZ3AyZ1NwaFcwY2dMcnNt?=
 =?utf-8?B?aEIrYlJFSWhPRnhyQWMwdjNMNENscVJEUkVkM1RFd1hjVm5TOURyMlQyRTVM?=
 =?utf-8?B?ZHJKVjQ1emFSRnV3WEltWGh4Ukx3MklXYzBZT3NqYk9SdUpoVnZpRGh4WkFM?=
 =?utf-8?B?RVlhT2V3cTRwU2UrL01Db3V6YWY4Nm5RaDVqeWY5QkxXWFl0WUlxOERydHVy?=
 =?utf-8?B?UE1EL3FzU21BQ2I0VDRsc0w0ZWUrb3hQWTkyU0gvdWp1Tk9qRnNkdS9mWlhz?=
 =?utf-8?B?VCtOSG5pN3BJQldEWGI2bGkrZ2FOV0k5ZjBrRWYxMkNZTjgybWp5V3M0Tm1m?=
 =?utf-8?B?UklUUWVNNEwvaGc4OEZVSHplR2JiRHMzVGJPczFPTk5vL3JrMTNkaHN4dlQ1?=
 =?utf-8?B?QUpQSlNDY3g0MkZ5QWtmeCswekpXZjNXQVA5QTNITzNCZ1FNQUgvUFhOaE4v?=
 =?utf-8?B?RjI1eTM4aFU3VFh3dURPVTVBQ0VGNVlLcHNQdkNDQTY3WW0xS0dGNHVqb0RR?=
 =?utf-8?B?My90bjd3L1NhVUhTTjJQbk02MFE4Y2RPcFlyWGZQWnRaaGFRZDBTTmxRWlJK?=
 =?utf-8?B?UkhiVHhvQWxzNWIybXZVdDRKZnJyajYrZTY3dWFTYnQxSmtkN0NOYUhqV0RD?=
 =?utf-8?B?aGJCTWx6YkwrSDJobHpSMHhjR3hOc1ZlQUp4RjJWZmVZeFoyNGJUUkwyQ3dN?=
 =?utf-8?B?VzA1WnlUNDB4UTVtbGRnTEVFQytjeVc4VElqM3RIQTg3Umdua2xta01hN0Fq?=
 =?utf-8?B?c0xXZnV1WXAyVHNuUVVsUDZXdUtoMXNnZHBWRXc0QUFwU3lzRTd1TGQxb0pu?=
 =?utf-8?B?VU1JclhhU1NiMlM3blZ6bFFkOE9oMkxXSjFHdUtmUGVvOW1VTEs4UUF3Y1RE?=
 =?utf-8?B?KzYySVkxSEtKZVB5akRuSExBRXpXb2FOWmNVbVBYak5DWjdadklFZnZ2ZTlU?=
 =?utf-8?B?WHpjbFYvY21xdGxIRVJVTU1vU2FHSFNHSnNNNXNMZ21kekxwYmdxeC9DM3hh?=
 =?utf-8?B?ZHBFNndhUjJnT3NOTW9ndHZVb3YrL2J5MTdTTmVBR2VMWmYyVTNmWWNPOE1T?=
 =?utf-8?B?TW5lU0NUM25oSmhDRE93TWN4SHJjQzc5RFRjaXdmVFprMGU0cENNdTJjMGRm?=
 =?utf-8?Q?zWLAU2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7215.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0hmZW9GaHIxOUtZUkpzcGtKUnVUTjlSUk1GUTZObGRERlBLUlJuanNyQndR?=
 =?utf-8?B?emMrTG81RlFXSXdGMjIzUGFkakhBdUFnY2ZISzBodkFGNEc2cW1HREkzeGJL?=
 =?utf-8?B?UDZ5NDBuYS96K2VoajRJeUtleFdvcWNEcVl1bnRwUi9ibEt1MURndWE5OXNU?=
 =?utf-8?B?MEE2aHE5QXkxL2JnaEsxMEdHUGxkUnA1NnRsMGdRQitlQ1RzbElGNUl1UEgr?=
 =?utf-8?B?Nm8zUEV2amlxTDZ2ZHg3SE51VkZNUlZmVTR3djFId3MwZDFmSDRVY3JvUVpq?=
 =?utf-8?B?UzZYMFZYU29GV2FLMDFuS3dZKzF0dEZ3ZHJkQkZZR0FFM1VzM25lZlFZZFBJ?=
 =?utf-8?B?OFdlRDQ2MVpXcjkxK2VVMXM0bjF6Q3oxREZuR25rbEpMeWtYNC9hS2pWMnFr?=
 =?utf-8?B?ZVFDTmQ5Z0ZNQzdyTU02bE5KbUZwSlRHV1ZCZlBCMytobWlsY0Z4YW42N29K?=
 =?utf-8?B?T0pQM2IzWmVBQWNWcXl0Q1Qvd2o2V3V5TmZiNEFab0gvb2pJSWhUUG92WlB2?=
 =?utf-8?B?ZDdJSXhBcGhiR0FTeGc2WS9yRGN0USs0a3pieE5iNnhuQUcvWHhEa1BwWkY3?=
 =?utf-8?B?U2NpbG03RGhsVmFmRWczUlg3TlAyeXE1QTFYS0wzVXRQdExhamFkcXlYRmRn?=
 =?utf-8?B?TktFZFZ1eUM5SXVpYmlXM3hSTFNQUHIyd2k4RHRDQUVXNnVVWDVsZms0MXNL?=
 =?utf-8?B?ZzhILzlsSEs5WVU5UHdDdEE4NnRXN2JMVmRucHA3OEhGMlN5bTFmYWFCTVA4?=
 =?utf-8?B?dkZZUGFtS0pQMytBMVowQllRRkpieEUzdnA2OXRRdGJSUm5iaWVqVmxGQmJa?=
 =?utf-8?B?L2JBNStUUjZGUTdobWR2QUVLMEQ0VG9IV3lyZVdya3hQWk5HMDR3d3ZOeHZQ?=
 =?utf-8?B?TGVYeHhPb0ZsdVlrbFNPYXdSQkVuNE85NGg5bTcxMXRXMUdvQ1JBMGVhU21l?=
 =?utf-8?B?QmpKVDJYeVl6RDdoZm9LUUI5RktWN0szZC9SNUFsL2l5NUJOSWlEcnJGcjdq?=
 =?utf-8?B?V0JBWjVQOW1XQmNVdXFjazJ3cldST1JkNW5ka3MzZ1hPMFRMM0ZBSzFWcFdR?=
 =?utf-8?B?aEFiWXFhTCtMbXFyZTN2OWZXclZNN0VmcmVRWUc1dTg4a3RGWDVUaGExK0tY?=
 =?utf-8?B?OUFFTERCWGFPL1NacDE3NXZkQ1hCVGVCUWg0RDQwMm81OVo0M25mWTd5UW9W?=
 =?utf-8?B?NzBXS2d6YklIWGcxL25rblZvbDZTRWZGQzdHNzNEellOSkJkemtBMjFkUUtv?=
 =?utf-8?B?R0RqS0o3TFVKWm0wNHdpeXIvaG80NWF0OFcwbWF5bWMxTzk1dGEwT3J2Vk5q?=
 =?utf-8?B?aHpGeVZvejNTZUNwYWVqRk40bW5Udy9tTnBBTXcraGZhMStObWpGZ3ZFVHZo?=
 =?utf-8?B?aE9ES1R0SXB6QWpETXEzMVRIeTljYXk4OUViL29qaFlLWmNzREdFQTZoK0FD?=
 =?utf-8?B?Vzg0cld4VjkrK0xaVnZ4MFhGNFV1bHBrZzlLeCtMc21DbVpvOFBycS9FUU11?=
 =?utf-8?B?aVNKcmd6ZnpBOEM1cEUwUlpqMTJLdFZaV2d1Rkttei8yVHdLK1M2dy9HbVFr?=
 =?utf-8?B?OE1JcHBFQXZYSTBSK2pET0VKdDV4em5aa2xFT1hSUnRYUERNei9jZU92Mkgr?=
 =?utf-8?B?czVoMVlUR0hRR3dKQjZUcFR3MktUb0dxR3pwa2x6d3o2UUVxLzRRVWpRZFJN?=
 =?utf-8?B?S1VucDE2UXZGbXM4Zk4rbWZVSFlGZ2tBRDdmbmdoYzR5NVg5c1RwbDc5cEdv?=
 =?utf-8?B?alNGM0NoK3RIbFR0c2JSeHRoUHh5V1AyY0VkdXFYWUEvNzN4QUVFUG9vMTlK?=
 =?utf-8?B?RWJpd3RCc2JpSGtMRVI0Yy9qaTFuME54Q2lDNUJPTS9PUUd6elhGM0FJWkJp?=
 =?utf-8?B?SHNJRHZHK1ZqV1VJZzFvaTQyaVhla2xmREEzeko3UmVqTFpBYkN3bnQ2WnAv?=
 =?utf-8?B?dXM1bWxVV2h5US91Rm9NczJoMzlNWGY1TCtmYUtlRlNZRXZmZ2lhdUhqaElH?=
 =?utf-8?B?Y2dPRDh5SDhZUWVlckVVRjhaYjN4Z3pvTWI4T1lXVkNRMjZMV1pROHpUSWto?=
 =?utf-8?B?VmJlZlJreUlsc0FsWTB6Vit3ZXpieWhRM0hqdGtHcEtMVzJsR2dNMmRZazJ2?=
 =?utf-8?B?SllDM0xQTGVFZTJlUHUyeElrZGdsL1B0bFQxcE02Zy9waGZFbUNwc0I0My9z?=
 =?utf-8?B?Tlc2MHpVdWZ2QWVqV0xadjl1OHFFQUxYN0hOZXRxOVh3NVo1Si9VU2FwR2RZ?=
 =?utf-8?B?TGlqWk1oTzd4bzY0SkZjcWsycjNZMlBrSnVpQkt5eXJoY21kRUo4ZEMwYnlC?=
 =?utf-8?B?WkJHbmE0bjIrdG00VFZ6MTdONWx2S1llUTVwQkVnNjRxOXBjSVFvZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dfaafaf-e195-474b-8a73-08de69431e6f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7215.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 07:56:52.9925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUIZO4QqEiUWpZ9BMFgOiP9KyNUjB2IyJvwkaFxch8KdrMCG96iXCwYjk/KXQBAie5d4TV45LlEwL5UvFsRrag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7973
X-OriginatorOrg: intel.com

On 11/02/2026 01:30, Sasha Levin wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> [ Upstream commit 78f63ae4a82db173f93adca462e63d11ba06b126 ]
> 
> The MIPI I3C HCI specification does not define reset values for
> RING_OPERATION1 fields, and some controllers (e.g., Intel) do not clear
> them during a software reset.  Ensure the ring pointers are explicitly
> set to zero during bus initialization to avoid inconsistent state.

This patch was part of a larger patch set to enable support for
Runtime PM.  There is also no support for System Suspend at this
point.

Without Runtime PM, initialization is done once only, and at that
point RING_OPERATION1 has been initialized.

Also, in my opinion, someone serious about I3C usage would want
power management support, and would therefore back port the
entire patch set (and the subsequent System PM patch set) to their
kernel.

Consequently, I doubt back porting this patch separately helps
anyone.

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> Link: https://patch.msgid.link/20260113072702.16268-2-adrian.hunter@intel.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> `RING_OPERATION1` has been defined and used since the very first version
> of the driver. The fix is self-contained and has no dependencies.
> 
> ## Detailed Analysis
> 
> ### 1. COMMIT MESSAGE ANALYSIS
> 
> The commit message is clear and precise: the MIPI I3C HCI specification
> does not define reset values for `RING_OPERATION1` fields, and some
> controllers (specifically Intel) do not clear these fields during
> software reset. The fix ensures the ring pointers are set to zero during
> initialization.
> 
> - Author: **Adrian Hunter** (Intel) - one of the most experienced kernel
>   contributors, working directly on the hardware
> - Reviewed-by: **Frank Li** (NXP) - another vendor confirmed the fix is
>   correct
> - Accepted by: **Alexandre Belloni** - subsystem maintainer
> 
> ### 2. CODE CHANGE ANALYSIS
> 
> The change is a single hardware register write
> (`rh_reg_write(RING_OPERATION1, 0)`) inserted at the `ring_ready:`
> label, before the ring is enabled via `RING_CONTROL`.
> 
> **The register `RING_OPERATION1`** (offset 0x28) contains three critical
> ring buffer pointer fields:
> - `RING_OP1_CR_ENQ_PTR` (bits 7:0) — Command/Response enqueue pointer
> - `RING_OP1_CR_SW_DEQ_PTR` (bits 15:8) — Command/Response software
>   dequeue pointer
> - `RING_OP1_IBI_DEQ_PTR` (bits 23:16) — IBI dequeue pointer
> 
> **The bug mechanism**: The `hci_rh_data` structure is allocated with
> `kzalloc`, so all software-side pointers (`done_ptr`, `ibi_chunk_ptr`)
> start at 0. But if the hardware RING_OPERATION1 register retains stale
> nonzero values (because the spec doesn't mandate reset values, and Intel
> controllers don't clear them), there's a **hardware/software pointer
> mismatch** from the moment the ring is enabled.
> 
> **Impact of the mismatch** — critical operations that rely on consistent
> pointers:
> 
> 1. **`hci_dma_queue_xfer()`** (line 382-383): Reads
>    `RING_OP1_CR_ENQ_PTR` to determine where to place the next command. A
>    stale nonzero value means commands go to wrong ring offsets, while
>    responses are read from offset 0 (`done_ptr = 0`).
> 
> 2. **`hci_dma_xfer_done()`** (line 552-555): Updates
>    `RING_OP1_CR_SW_DEQ_PTR`. Stale values in other fields are masked
>    out, but the initial read from `hci_dma_queue_xfer` would already
>    have gone wrong.
> 
> 3. **`hci_dma_process_ibi()`** (line 614-615): Reads
>    `RING_OP1_IBI_DEQ_PTR`. A stale nonzero value means IBI processing
>    starts from the wrong position in the status ring.
> 
> **Consequences**: This can cause complete DMA ring malfunction on
> affected controllers:
> - Commands placed at incorrect ring entry positions
> - Response processing reading uninitialized entries
> - IBI processing starting at wrong positions
> - Potential DMA data corruption (ring_data = `rh->xfer +
>   rh->xfer_struct_sz * stale_ptr`)
> 
> ### 3. CLASSIFICATION
> 
> This is a **hardware initialization bug fix**. It falls into the
> "hardware quirk/workaround" category — the MIPI spec has an ambiguity
> (no defined reset values), and Intel hardware takes advantage of that
> ambiguity in a way the driver didn't account for.
> 
> ### 4. SCOPE AND RISK ASSESSMENT
> 
> - **Lines changed**: 1 line of code + 6 lines of comment = 8 lines
>   total, 1 file
> - **Risk**: Extremely low. Writing 0 to ring pointers before enabling
>   the ring is always correct during initialization (software pointers
>   are zero, hardware pointers should match). This cannot break any
>   working configuration.
> - **Placement**: The write is at `ring_ready:` label, which is reached
>   for all rings (both IBI and non-IBI), and occurs just before the ring
>   is enabled with `RING_CTRL_ENABLE | RING_CTRL_RUN_STOP`. This is the
>   correct place — after setup, before enable.
> 
> ### 5. USER IMPACT
> 
> This affects anyone using the MIPI I3C HCI driver on Intel controllers.
> I3C is increasingly used in modern platforms for sensor hubs, power
> management ICs, and other peripherals. Without this fix, the controller
> can enter inconsistent state leading to I3C bus communication failures.
> 
> ### 6. STABILITY INDICATORS
> 
> - Reviewed-by from NXP vendor (Frank Li)
> - Author is from Intel and knows the hardware intimately
> - Accepted by subsystem maintainer
> 
> ### 7. DEPENDENCY CHECK
> 
> - The `ring_ready:` label and `RING_OPERATION1` register definition
>   exist in all versions of this driver since its introduction in v5.11
> - The `rh_reg_write` macro has been unchanged since the original driver
> - **No dependencies** on other commits — this is fully self-contained
> - The only context difference across stable trees is whether
>   `RING_CONTROL` is written with `RING_CTRL_ENABLE` alone (pre-v6.6) or
>   `RING_CTRL_ENABLE | RING_CTRL_RUN_STOP` (v6.7+), but the new
>   `RING_OPERATION1` write goes before it and is independent
> - Minor backport adjustment may be needed for trivial context
>   differences in the surrounding `ring_ready:` label area, but the patch
>   should apply cleanly or with minimal fuzz
> 
> ### Summary
> 
> This is a small, surgical, obviously correct hardware initialization
> fix. It prevents inconsistent DMA ring pointer state on Intel I3C HCI
> controllers where the hardware doesn't reset `RING_OPERATION1` during
> software reset. The mismatch between hardware pointer values
> (stale/random) and software pointer values (zero from kzalloc) can cause
> command/response ring processing failures, IBI processing from wrong
> positions, and potential DMA corruption. The fix is one register write,
> has zero risk of regression, requires no dependencies, and applies to
> all stable trees back to v5.15 where this driver exists.
> 
> **YES**
> 
>  drivers/i3c/master/mipi-i3c-hci/dma.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
> index c401a9425cdc5..951abfea5a6fd 100644
> --- a/drivers/i3c/master/mipi-i3c-hci/dma.c
> +++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
> @@ -342,6 +342,14 @@ static int hci_dma_init(struct i3c_hci *hci)
>  		rh_reg_write(INTR_SIGNAL_ENABLE, regval);
>  
>  ring_ready:
> +		/*
> +		 * The MIPI I3C HCI specification does not document reset values for
> +		 * RING_OPERATION1 fields and some controllers (e.g. Intel controllers)
> +		 * do not reset the values, so ensure the ring pointers are set to zero
> +		 * here.
> +		 */
> +		rh_reg_write(RING_OPERATION1, 0);
> +
>  		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
>  					   RING_CTRL_RUN_STOP);
>  	}

