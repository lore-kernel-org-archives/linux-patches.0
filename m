Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311E39A7E0
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 03:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012723; cv=fail; b=k24f155G7N5bjNBZW9X5VjI7fxyCAVQg12uGPZsl/yxJsXpJcmYYtYllOUlj2SG6UU7V7wzsLWrg4zpTfM0FXYx7iG1z+ziv8QoBQNBVGhL01x83SlZ+/vSvBBPcAkxxaNdAculxF+fF0l2jIHWnN/oWyBa78ZJwNG/Ko/2zkm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012723; c=relaxed/simple;
	bh=+gJ7u0/k7zDWGbShLpk7mOi4crZMKxbFTlzG3BtJGl8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ct8S836IS6G+1//dLacRYpefjkZubyOnuPgYmLKGKHmihILpuTJWr5WxctcVlV9ErTqfPomRXPoQDdDAN+dDtGLr1bv3oMDxz3WpW1o08qJvr0NWXS5la+aGKKtOX8crbt4JpdElPp9deYtGu5T1JHLC/+EGDzUtOnayaYQ3dAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PoE6Z09S; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PoE6Z09S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789012723; x=1820548723;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+gJ7u0/k7zDWGbShLpk7mOi4crZMKxbFTlzG3BtJGl8=;
  b=PoE6Z09Scgf5Vt6OGQItMTenrWvXx/4Uc0FchDO0V1Yl1n0YCDlBnm2a
   1v8O0/QGBCIvqBVRDImfK4ohYaNuqm6fQuJYgt64FQ9xB9FO8bonDMXTl
   nD0Q4V24tRfprxMAcYY8GuWZ8vpznXCUO6sMPwmfPHKLkQ4z1gxFKJ9IS
   JyCw3khFK6cjFzqx8WGA0BKkEJJqYVvRaz4FyZ25V5LjOiC05vcrmDiPR
   tB0FZVSP7dQGMu0yPvxILqZegPXOtvVUREQPts1W1ordgEekI1DzOpvpC
   sFdwUGzI12d4+0v4enp2IttG+wNaRTFZ6a1t/O2LR1UBipKs3PDhHXEz5
   Q==;
X-CSE-ConnectionGUID: +x6IE65aRhOyOm20lc+XJQ==
X-CSE-MsgGUID: aDo54LdcSuuWG/lGU6FhtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89385331"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89385331"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:58:42 -0700
X-CSE-ConnectionGUID: NKiieRG5TWCDRkDQRv9vOQ==
X-CSE-MsgGUID: arNMkMqfSgGlvj1VmpWPPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="273477802"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:58:41 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:58:41 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 20:58:41 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.11) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 20:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VR7PFovDXI2xGKByurrBWn4YkibUHO+flPztxNi/qEpWmJ9SOROvD2PZ6NtBlngZtXViFPUbe8mIYLnGtm0bdTO9kDqMfUHvDy9msDM3VyntFVDCS4UD1QxPNiEtv6wfFPjiPKudKzj0zVmeiYmgTov7fohhThdKyh4/ZNf+i2xbZl0N9PC1wBSpl4OHXGaeWPb/4k9gHT3pzNFaQ9udGdQSIpVEMhUku4VouFcxE/AvdYQyuI268c9IIiqb2//SI36BtEekXDDxNB2l0bSu13aMFxfD5dXbpjL6+TaJHZ1Ad0PrwcIUcDIilwyAmIGucO2ZWi/UStq+yoLA3jqQuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gz7/tX57lo9e82LOxdhxulSdUR9nzoKyoc3lFMmA17Y=;
 b=RHYY4q6f6862M1eZFQrt8wBBGFAFwYmFF3wiRNf17ze5R+mNXZhtIqcJQeMAPTooi9fVI9pJsW5rGStmsynHyOZQhR0d2PK3/cIT2dYeqFBD4/hqFGdDeBd3QK/8TiVWpyF+wvjcsCHgIzAyNs6+iNMrFwS/2LNR2qOzuP3EsrhhKC/BzkFf8Ir0zS/PjBVZERw1TWM+2d2BhCmxl2bA3dbxzUl863bO1C4VaUmBCWUdG9chvxyPT+z8fpbTzjgkd45bfnb/BpDzrg5CObXL3vx8qjDHyhNgZszMVx9j9dBBEBtcs/I6eDhGttEmfo3UyC4IlMHv1YQJU14dPpKtcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 03:58:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 03:58:38 +0000
Message-ID: <f9f3cb40-bc98-449d-a801-6af836900e76@intel.com>
Date: Wed, 9 Sep 2026 20:58:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 11/23] fs/resctrl: Add interface to disable a monitor
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c1d938-4670-4727-a4e7-08df0eefcb95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: SuBl7dE6LuQ0J2u5d7JCXHMjohKPsWRKza2Gy8z5rtxlpxHn3cfVCFEnGPyXqOvZluCo1vQt54f63FUO+LY5SBkHjmaJyzQsMorMbjx243jU+Nd44YXAjZx7OePmujWfxzxpmyYKWAd4/biHuu9HOX/v91kjiXQh7KgpeOoRRuq+Day6GAAjFqTgsqhreAyRwb4qhCxd8nkhijlikjJyNTsvSDHGMSEM39Kd6aC11Z1z4SDDe5AxbczDry3HByClEjuh7NZiGef/3JWjzT+KDGl7SUYQt434JxIzIsywWevvDy6rXCfDemZx1G/Me3SbYvbyBXJGsFNn/xa+tY5iuVZAA7jzTmuFvvhlZnoVUjpaOKBaILFtQwcA/cRhEBvRZaTbag8W7+IzOdBhbfi5UoYpj1YmSVjbPiIDu8z00EKeEyqLZGg86FbdRwPV7Uyw1hx+SonH1bTJyuSS/2guXDZHJnr8OUsHnBocRTJXHfBTC8BSAs8E+DA34UJV4tWyvty2KKjC4jnlkaORlcORywTLN2IZ5h8bG5Lc/+AI+D1XocWaizAUF2k+/cYfEGU+T55rfVne1bY7ORs9hGRevGliKnXVRYaei2FFF/crnhzT7UpC/AS9yXCkrrLpsZCJoOgf8733qpdDbraOKnO3LrzmY6mnoPYzWz9rf+BUPGFXDhzosgnr8MTBigfJo8VjbIZ8EaVXDAE5uUISD5wM3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3N3UzdaR2MvU0tpdzZiYjRlZ3gzclBBbjBFaWNwN0lyZDNCbFZrU2dzTzE2?=
 =?utf-8?B?Mk15VGFlNU1VVFVaRm4xVHVVZHU2S1ZQd3B4emJxNzVxNmdGNXF1MllmWFI1?=
 =?utf-8?B?S3E1WURCbEd6YzRYL0VGamwzOGVMZHpQeE9NOXVkSUd2L3J2ZmdnVWJzSmhS?=
 =?utf-8?B?bktzeFJ0c2NVemhVZmxqTzFnL2VHL1dmNmQwZnRFOWRIQllDWlhhN2dVbDNu?=
 =?utf-8?B?R2swVXpjeVJmWEQ5UXlhd0RRQ1VzVE9neFQzaWV2c3VWRjlIQzdnaE9VVnpP?=
 =?utf-8?B?d2FzOTBmbVUyQW5NNmlIZml4WjFEcm56UTY3cnZ4MHFnaGdOSHl1ZTdVak43?=
 =?utf-8?B?MnhmRUZwT1BkRkU1YTQ1NWQwSFg2UEwyTE5VRnMvWUtrTW5UcHREcC9MRVpP?=
 =?utf-8?B?R3preGpFb2d4SnhGOHhCemZLRzR6WXF1dkFGUUZqWFZwNHJmOW5XRGRxR2xL?=
 =?utf-8?B?REtseGdZckV5djdEQXFEcWgxT1V2UkhlUnlhc1NFYTBEOUNYbkNuN0hCZ3hX?=
 =?utf-8?B?dFBFc0NNWnphT0ZxUnFVZXMrQnJQbGZITlpBYkVjOFBQTFl4Nzd2TWZSRWhL?=
 =?utf-8?B?U1NOVUd2Y05CTGxlbGZjUG8vOWZEWi9GbHBWQlJrWXlxS0xtamoyRWlwNHgv?=
 =?utf-8?B?WU1OYjh5d3ZGUy9MYy9zTHRmd0VMUzlVaUl3TFhIOEtPSWtUTFVKMGFhVTcz?=
 =?utf-8?B?TWc0aWVNNHlSNHhCd2ZmOHJuY3BJTWk5aTU0REdDYmV5VUo3Q3NhMFdtaTZB?=
 =?utf-8?B?MHh3OHc1TGxzWHVuQ3doQUEzd0RhMzRrNWZOU3dVam80UW1UUXVla2Z1Qi9t?=
 =?utf-8?B?UkErUk1VZTU3TkM3OUNDd1lvaUxPdEFsNWpSTjdDSmJMMVJFd3NKUW1SNG1l?=
 =?utf-8?B?V3RxTXRpYktmSUszVWhnY0h3a2xmdHpkZzhPWXgwNTFoNUh0Z3JVQ1VEUlV0?=
 =?utf-8?B?cGNCZ09UckVoZEZuNkdCMElrTXhRZDB5VE9rOHFWbE1uTzJwbVJFQXFrOTRM?=
 =?utf-8?B?N20vRFBmNnNibmxhZFlxVmZ6MWhWa1BlMkcrdWlhSHhhQTVXMXdmMTJENm1G?=
 =?utf-8?B?SCtyRkFqSXhaMCtWb095aTZrNWZxcEd2ZE5MRjcxcGlIUFd6WUZMOUE2QXlB?=
 =?utf-8?B?NEdXbHQvcm5Qdk9BQnFNLzV3a2luZDRQOVBKSUVHUnFISE5xdGE4N1oyOUY3?=
 =?utf-8?B?ZHRuTGtleElKamw4dTdHTHJHQzEzSWdvSzdyUEQvaDBKSDc4Y25Cbis2aU8r?=
 =?utf-8?B?RmcyTER1S2lmR1lKUEptalY4NEtrcWVjNzdHdDlOaHg2MFIyOTlwaEYzenVz?=
 =?utf-8?B?ZVBLUGk3YkJtMzBINENkczZSbHBrUUcveExlWXE0UU84WkVCVXVRK25pd2Jy?=
 =?utf-8?B?QjZSYngrNExRWHF0VjFSNnNvWHdOdjhkUlMxVS9YWmpyYjBlVCs3NXBCSGtQ?=
 =?utf-8?B?d3ZSSEJ5Qy9zaWRaOEYyQzNud3dkVC9SVDl3eTRoNUlrZGNXNENuUGN0RWJ5?=
 =?utf-8?B?SDZoNnp6VUtTeXMyVWMzZVQ2bFJrWk1UNlpUdCt3bnhCa1FKaWVrenVNb041?=
 =?utf-8?B?eWR5QlRiS1FlMDZZWjJBNDE4U3czZEgrOFdIeHd0L0QwL3lmMFBsdXkxYk5F?=
 =?utf-8?B?V3VhUXE0cG11K1JPNkZwcnFxWjBhcEw0WGNQMGJucU9jMGhWNTZPc3hVWlRE?=
 =?utf-8?B?azhxVkZoOVdmR1pIRWpYbG1LNG1iRTV0Q044OFRaUG1yRDAyVHVrL0tKNkx1?=
 =?utf-8?B?WFd4OXgxNUFOaWVNUVVFdllBR1kzSEFNcWtRRk9hb1VFRnhNQ2o0OTZhVDhL?=
 =?utf-8?B?bEpRVDFYTmpUckIzS0NSOUxmK3dYWHBBc2xnejAvdDF0OWtwOS84NjBiekpU?=
 =?utf-8?B?Z0VQWmkrSWJtam93ZzlHUm1mRjlSR213M0FnYXFlYUlJc3l6TmVlWkZDWm9G?=
 =?utf-8?B?ME5Vam1BQXcraVNOSjZFSkttcFBORzFleG5pdEVIQlZjSVdkTGd5a1Urd0xs?=
 =?utf-8?B?STRLekxhdGloZnBBbHJqY2VqdVpVM0d4bDRUbkV6NEZFK2N5bXZ4MVdaNzla?=
 =?utf-8?B?NjgySEppOHdiRjlaeGZSRmNwZ0NaT1ZvM2dEbGRMRFRmYUczS3pFN0s1K0cv?=
 =?utf-8?B?YkpnWW02UGF3OHMrWFg4aFl0R2llbVlmenplZmxxUmhHNThXQjczM0RzdmM0?=
 =?utf-8?B?WHVteEdlRzViSUlKNU9ISExlSDNseHZXRysxc0N3bGp5bTZOckRTdzhKQ3JE?=
 =?utf-8?B?TDZBTWloR1NEdHgzNDBqWnNOemU2STRXbFNtV3hYZ2tjWC9nUXpsbVRKbEll?=
 =?utf-8?B?ekdpbzk4aUJjdVl3R1B5RkU1TStYdTJlMS9HV0RsZjJaQ21WcUNmZWE5RUlW?=
 =?utf-8?Q?JLUkWNYRDDksBZA8=3D?=
X-Exchange-RoutingPolicyChecked: DUotNYA0gNzqdY3nMIY1BTQg2lsin4I9k95hil92s3YgHCidpwSsVUHRne4qo6noIR501TrWFBd02sb0PqgNE/SZjR2gGHO9gYpxyq1tj8hqps5KYFmGNafe5KFB7LNbP4kvwLHRoKHQyHDIjz3QOaUyN11DZUS6xmkeaT5xnUC9s8dfQyKxDc9LEw8HYE7EMAEBEFTj1GBGhBg72lgE1FW77MTMO668vmhNtKwjjxAGI+7NwOQo9lcrxJOIbOuMa3ehxuHbViYZw6odl93aulz11Rd60sDpUo2i3zWMYO7nkfrs1LGsLoAbPamAB+lxOe0Hg+fLX95QYK8l7p1KEg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c1d938-4670-4727-a4e7-08df0eefcb95
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 03:58:38.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFQt/jaTR6tToJDJHjujRvzsvv3UI1xDsdLR+u+uQbfLSf62buVxy8DLerBQD+8befKIFHmc6VtA61iJSa2+yokQHG6W2jYPTz4anIBHzfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> resctrl currently assumes all monitor events are enabled before any domain
> is created, because per-domain state is allocated by the architecture's CPU
> hotplug callbacks. There is no way to disable an event once registered.
> 
> AET events are enumerated by the INTEL_PMT_TELEMETRY driver. To allow that
> driver to be a loadable module, resctrl must tolerate AET events appearing
> and disappearing, which requires the ability to disable an event when the
> driver is unloaded.
> 
> Add resctrl_disable_mon_event(). The architecture owns domain lifetime
> and knows mount state, so it is responsible for calling this only while
> resctrl is unmounted and for cleaning up any per-domain state. Document
> those requirements in the kerneldoc since they are not enforced in code.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Add Reinette RB tag.

This is missing.

...

> +/**
> + * resctrl_disable_mon_event() - Disable monitoring event
> + * @eventid:	ID of the event
> + *
> + * The file system must not be mounted when disabling an event.

There are a bit more sharp corners with disabling of events since events
may be used while filesystem is unmounted. How about adding something like:

	"Never disable an event that may be accessed while the file system is unmounted."

Reinette
