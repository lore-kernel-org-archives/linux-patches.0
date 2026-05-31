Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F73382385
	for <patches@lists.linux.dev>; Sun, 31 May 2026 08:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780216679; cv=fail; b=KDiTRwq8pyi3n7z0Ga1HSsv5q4fuuyZ/MSS+08Nqp7H0usXe10+yfUM1E0LLpLvBvHoqWj4tb9ro8DPoasRk5Ln6yozwowfUyWonmTi5D3O3DM2kx8xWcOX682b9IIT3et5JOOYOS/xnKoDQASqacYNICjxmWwJ09hvLtxgsiSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780216679; c=relaxed/simple;
	bh=03NXETMJrEJmBnS3x4SUiziCyCl4Nu5Gf0A1yRdjyJA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XFixWsfqnAgVbs51HekzmIwWAlSxv5UW4L3wnabiDsAhe44gxG9pY6J3iduG5Rqibs56YVVtC0ElGERyGKo3CqvBaWIwhIBT6tQHGAfY+6+RMtiTY6A7IW2nqItk7T5CC/cfi0KSM8fVj2IXex9NcTMUn5hGBW5wysMfMeVY0u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AEUEMWj5; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AEUEMWj5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780216676; x=1811752676;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=03NXETMJrEJmBnS3x4SUiziCyCl4Nu5Gf0A1yRdjyJA=;
  b=AEUEMWj5fOgi/ZSrx30hBaYdNRicOjLwv6K+AsmjcQvpHWR4QDHG561L
   clY88hpuTEWfYtKNx+xNY7hOjZdrddKG+WYGF7MdlBHd8+GngTj2qpvBy
   7ON3AWWEDIjlA/WoZp+MyvxZUxA4rVnOrLFo8E2ToJ5KjOVCnqRA3LsrZ
   LuH1i565Qltt1DjUf+MXzgbD/hmV7bzZoItpasA2K5HCWeo2r65LC0A8l
   R00ez5T7R9DeKS1Y/sPcBGO1JTNjxDt3d8JfZnITEalPibeCTsONvfZ56
   bbBwiLuz5M7GkBemoYxTwr4Db/EzI0nUL7ivd59A/K/kOyr4Ki+sIP1TD
   g==;
X-CSE-ConnectionGUID: YUJbApuLQZWWHALSvpp4Dg==
X-CSE-MsgGUID: UjjENGtXTTaD4VENjOk1zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11802"; a="103674991"
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="103674991"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 01:37:56 -0700
X-CSE-ConnectionGUID: TffxXlg3R6WTHcyYkrmW9A==
X-CSE-MsgGUID: pWoNB720RRirlZkvltuIMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,179,1774335600"; 
   d="scan'208";a="239093517"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2026 01:37:55 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 01:37:54 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 31 May 2026 01:37:54 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 31 May 2026 01:37:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xd6TBrfhKyBlhOEaOQfC5k/MVi4XLdNFpi3ItkzL5N8tAiBQq9gFIVNaslrxV0GsS+L7DZxYTux9vq8Tyr6qX1WRJKjFF/mqbqkNIj3N6sU0vPugqCXe64HYPNOjapwSjL2sMbv7IhttgrK3t1Gg6aETR5J/PnvxoVY1muLTUars6U8J7AgJWZNYOj6Dc0700QXZrzxHkgI0EOXPEYhw+L8WiyQp/1kukTUOHA2nDMN2i0gT/HW7TW6/8GrGpR5aiuKwNkav70hrOOPUY11kE/3JNW3XmLXm2l40kJtmYiI1IicZYrbfsPWr8z9mfiy2eZPFLIc1f4tsJqF3KFJHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sb23pumXL2hZSjjIyji5EVoGv34x86BsJvTbuA69V38=;
 b=FTzWm8nXr6gcEdtg9t3/gA9blIuYueqYZw4RZrkw3UK9NXQa2aYu8+kHoGd/frkg4qbIw1XS7drOCB/+sCmgABOj3UFYu9Rk+q+FA3jwssL4B6viKAYXGgfZLiViv1GaUoQy02nud/+kbGT3/wRG/Yid+36BDAY/9F+4Jx0RQ4HV6Q8D8ZUz+rnbZnlBHCtogCkamzbAISW7vU1bOQfJH5WEF7LybrjEaema2RLs+hd5i/uRgz7SJRbvEdTMZTglXGVExX1p+kv/X1pi2JJg47alvrMPixLs3hZKYNXKPBPrMj7MT8n18ilhuqtduLJHEMn3wFZkWVGSUv1EcdoE5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SJ2PR11MB8422.namprd11.prod.outlook.com (2603:10b6:a03:542::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Sun, 31 May
 2026 08:37:48 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0071.015; Sun, 31 May 2026
 08:37:48 +0000
Message-ID: <8d76c93f-7780-4fdd-a3b2-9faa8eeddf57@intel.com>
Date: Sun, 31 May 2026 16:37:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<tony.luck@intel.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <dave.hansen@linux.intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
 <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU0P306CA0050.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:28::7) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SJ2PR11MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b3f996f-cf4d-4203-fd0b-08debeefe4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|6133799003|11063799006|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info: pRi5jZfr/867kv2VX/CHlFpveuRooRvzZ0CDw7nmZAHiEQke4TtdvJbcz04wYMk/viy+zngNGmmXrxmpYl8D1/YKj2Rz8m3bV80XbCALbb/fVd9pdadwPSaPxEfLoICRir/g6hIz+JvPi6/3nSnOIq/SRzwkHAjkQskEWP6K+KAXcgtfeVD3qiQv4Hpgt9jHI3h5NwWEoc40cKpirwphfk87C+2puQwMHpHkUjXoEGp0Pe/czsEdNNLKo72ZZZOPAmud2PujBgxTZn+fTY+fXo8utUsnkzEUaDQLJ4coc20rUPyPmyPQkBHaD2IBlfYaW/b4NKuNl1TNgzeFnoYa+HTQj4mJTdoWiLNr5QmxwTRPt9Pwvt5zv0KYxNdljnnj6IYF+zj1BUjBl4TxxkSiPB3oDzicSYg+NNOsyaZLVhIrOzR7IyFmMKtx+sQvPEy3s+0Y5v3F94OU6mnME7/2mbpHRHaWFmcQ+qwDGKmuKLCbJkA00CYTIgKs9folgJ4jtTVnYE2XSr88daEmGokbxIBvD3KRUBLFkW1gPZG1bgsf3y5LD2hqItm9485KuqMsL9SCA3IiEx5ebaZZ4O8JGjMy/C+1vqW6PkH763wHYHdse5yzhd5h3Jc9f5axEFnxEOWt3S9zySlJmATahdpq6WaLHqHZ5k+nOv+kmPBPKaKkUNeDiSXYRlZyjqGbOARAwA7csz7Ij56nBYbce0g48g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(6133799003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVZ0bU0zamx0aFMxOVhrR0Z4eElJQktNTDhaQXBWWWdzRUFDcDA3U3JHWnBl?=
 =?utf-8?B?ZE1aaVJ0aEJRaGplU1B2K2MzRS9TV3Bic3F2anE0QXdXWTRDcUpiOS9RVzZM?=
 =?utf-8?B?Y2hKcFN2Z0Y0RklsZ3pVbjJyMGpaaVV0dktsMlBvL1lXWE5MMmVuejU4Skxk?=
 =?utf-8?B?Zm5JTmZGRE1kM1g0bVpoTjU1R1lKY29VaWE2V1h1V3U3QTNWRWI1eE00dy9r?=
 =?utf-8?B?dXNKbzRsaXZRMC9rVlJSa1o2QlBGMG1TNVJjeXVGZiswQnFLWVBkbGtUQkVy?=
 =?utf-8?B?ZExFcHRHWXFLa2lGeG9iU04wY2l0ZWV4eUpqY0RMUzl1M2VpdVp4cEhDTlVa?=
 =?utf-8?B?eDJvVUdqYklXQi9WL2JhQ091b2t1cXV3ZzZ1b2RSSFlRVXgrblkrTjNpbld5?=
 =?utf-8?B?d2RYMFBITVVkWU96eUlyOEE2ZDdJa1ZLMWxMaW5PWWNKb3MvY0VXNngxK2lY?=
 =?utf-8?B?ZDc1dnV6b3I3bVNEUGRsNVVDenBia05ZemY4M1RKNkVtNVVMcDNzZ2V0ZzF5?=
 =?utf-8?B?U2VDWlZFVzBUNkFNcEREOTl2WHY1NjJtNUQxak95R2ZLWkEzU3BQWVBXc0JB?=
 =?utf-8?B?bDhQQWtHV2IzMG1Wd2o2NzgyVTUzMG5DV3psbDN5R1BaK0hPbHRxODRHb01J?=
 =?utf-8?B?d3oycVBDbmdaTGZHWG1ybzlsZVdCV1dvbmh3NDhNdG1Ya3NLSjdQMUp6czJ6?=
 =?utf-8?B?NTMzWUVFc1VIbm1QZUVRcmZrTjNsbEZWNGQxQ1g0V2p4cGkrVTBiMUVHNE9l?=
 =?utf-8?B?U2FodmhaVnA3VzRIaUFFYU8xMVUxK2I0aUhxL3FLTFlhUnpKSnh1M0pBUVQ5?=
 =?utf-8?B?S3Ewd2p4SEx0RzZYTm14MUdqV0tST3k4M3JLNUxDa2luRmxOVU1CMUhMTDVk?=
 =?utf-8?B?Zm92ajZxMkU5OGF0MXJiVTBLZkxzYnVjYUFHQlZocWN0aDAxMkR5akljSUth?=
 =?utf-8?B?ZFZoWE90aHhXUzQvaWZaNG1uQWZIcUhCT25tVzNCS3dMekxUV1pHcE4xNFhl?=
 =?utf-8?B?UDBnVFkvT3FmcFJiN01FYVJaeHJwZ2dKMjJtcHV0UVFZWmRITmpIWW4wd0t4?=
 =?utf-8?B?UU5WQkJTTEFjeUhwb3NiWDE5MWc1d2hnRzcvdU5hVHJ4UEh1OW1LUkU4enFE?=
 =?utf-8?B?S2V5cjRsMW8zOVllMzdGSmxSSTUvQ3VzODdNV0Jib0VqS0VrUVR2bm9EM0Nt?=
 =?utf-8?B?Z2YyTHB3Mmd3OUplWU9LbnBEU2ZLSzhwQ2U3UWRDZUt3VTlpVUZ4c2cxaThM?=
 =?utf-8?B?ajlOWXhOaFdNcVdsWkFSNHBRRTF4MnpxVjR6NWJOZ1cvUHM3MnlhYStqakJU?=
 =?utf-8?B?SVpDYTJqcnc5dUw0STBsK3dXQVFCd3JrNUl1aXY5WnRZeUFYWFZLN0ZwRFRF?=
 =?utf-8?B?WXNSTnNkcHpLNjJYZzM5N2xEZG1OQzlQdVJ6YlI2eStTUVRzajNFSVZKcXBn?=
 =?utf-8?B?ek93QjN4TGNKVk5sclU2OFlWVFlzWngzNWpmTDFYZWJ4aXhseE5wVVh1cUN0?=
 =?utf-8?B?ZzJyakhBNytrU1hrYmFoc1NlRHJSdmVnZytDUUUxcHc2bmtGZzl2Z1JYTkw0?=
 =?utf-8?B?RWJtWVFBSjVGaU5pQm9XNm11OUpFOFNFb2FhaUNZalJvK0RPS0R1SkdLT0dG?=
 =?utf-8?B?ZEJBNWhHS3dMT1drN2FGL3lxMmZzZFFZUkQrb3RIN1JUMkpHYm55NXhLUEFw?=
 =?utf-8?B?REMyMjJKTkZoa0VmbmdKREY5NGtJdUFWTWpjRFZXSzh3bDRwanR1LzcxSzJ3?=
 =?utf-8?B?Y1dndWgxSzhrNHphbGE3TjVtRTlzOThOSlE2eW1nR0hKQ1drS3h3TEV6QStx?=
 =?utf-8?B?TFNDZTh3alhac29sM2xQMEtCOUZWTEZqR3NCdkpYSDhMQzZ3U05mRzkvRzdJ?=
 =?utf-8?B?UE1mQXFOS1cwQXcxdUsxQnduWk1CemtEOUdDUTZZNVc0NVFFcFp5UEdsZnBi?=
 =?utf-8?B?NWJUUGNXbXJXZWZWK2hIVXVjeE5iRVdMVnpDS3JlS1ArcGRSeUVmZzhhQ3p3?=
 =?utf-8?B?RzI1NUx2VUNsblg5bStiRkxjYmhrTTBJU1lkVEF3aDUyeEtJc3V1T0ZuMVdr?=
 =?utf-8?B?SkRYNGprSldDN09CeTZxaFFDK2daMmhSOE1qV21QVjRTL0tmR0lSeUhKNjZv?=
 =?utf-8?B?cENaVi9MbC9uTktSNitldkNNU0xWZTRVWUx4Ym8xemtaanM1UVhBOElKTXVx?=
 =?utf-8?B?VkV6WXNqYkFDenpzTUs0RTRzRWo2SUdjeWMrM2ZhRi9XdGFsbW5KTVZEM3dO?=
 =?utf-8?B?bTBPeHJXaXoxU1dncmZoTURYYzM3NEN1MFhMYUEwNllIQjhVUGN3WUwvQXFI?=
 =?utf-8?B?d1ptMUNVZmtpQWN4R29wdDA0YXNCLzdYNWt6SnRkeUdVQmVVeDQ5QT09?=
X-Exchange-RoutingPolicyChecked: KGoMayVHNz8Ezeaft8eGW21Wo1e+zOTksezD2JnrW3yXgmtiZeeGZZYH8D7GwjlPtkgFXftO8l62qGpwY/cAABvCrRvF3JOljeLU3a3Oj6AhmkJBeki98f+q/HfvcdRxW6TWyPklDCb5GeoUMN7aqxW0pOFBT9CbL6Qxu4MmZ+Nxi0sYza0JUE/RBWBjPoVzDYAgDARw2Kb0Mdb67ZLUUix+3/uVJRQoheguxITdnLVeJd9DrMa7qH285BzXO8cvc3X5QcHgCzT8XF+n4YeJLNtrSxzz5mcIeKn847csOhyA/2/8m9uB9DICGxLOwqeK42KJQi/pW/Vgw/ATh3CC1Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3f996f-cf4d-4203-fd0b-08debeefe4f1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2026 08:37:48.4457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzhB2Qo5y4YlczcRBJs2VyzN34dIkBT1/dv4OHVHPum6YUeqmG5KjA8NRCZ+jiCPr73tDZMr/sBK3eM6Kr796w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8422
X-OriginatorOrg: intel.com

On 5/29/2026 12:11 AM, Reinette Chatre wrote:
> 
> 
> On 5/22/26 12:15 PM, Reinette Chatre wrote:
>>   static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>>   		return;
>>   	}
>>   
>> -	list_add_tail_rcu(&d->hdr.list, add_pos);
>> -
>>   	err = resctrl_online_mon_domain(r, &d->hdr);
>>   	if (err) {
>> -		list_del_rcu(&d->hdr.list);
>> -		synchronize_rcu();
>>   		l3_mon_domain_free(hw_dom);
>> +		return;
>>   	}
>> +	list_add_tail_rcu(&d->hdr.list, add_pos);
>>   }
>>   
>>   static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> 
> I resubmitted the last three patches of series to obtain Sashiko review [1] and
> respond to that feedback here:
> 
> a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
>     domain is actually added to the RCU list?"
> 
>     Yes. As pointed out by Sashiko there is a short time where the monitoring data files
>     may be exposed to user space before the monitoring domain is added to the RCU list.
>     Also pointed out by Sashiko, if user attempts to read from such file it will return
>     -ENOENT.
> 
>     This behavior looks correct and acceptable to me.

It might not return -ENOENT because the read will be blocked by 
cpus_read_lock()
and after the reader has grabed the cpus_read_lock(), the reader will 
see the newly
added domain on the list:

CPU 0 (writer)                            CPU 1 (reader)
==========================                ==========================
cpus_write_lock held                      cpus_read_lock() **BLOCKED**
   mkdir mondata files
   list_add_tail_rcu()
cpus_write_unlock                         cpus_read_lock() returns
                                             lock(rdtgroup_mutex)
                                             resctrl_find_domain() **see 
a new complete domain**
                                             unlock(rdtgroup_mutex)
                                           cpus_read_unlock()


Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
