Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E4F215066
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745012469; cv=fail; b=VnQMxoW6ioMJ9lF1m3+wp9gZWH8/gJkQKgCBEZcNBQ9GDQ5uTcE8eADuxj6wNBExC910fih2Hg8kp9M+V9cOz0BWj4siDFSvJkMFSKj6vY/3sECaZkIQ2bMlB1HoSFLfkrSANM2xnClQHmw0+mY5GmutxrcQlxI5+66Lk7U4sTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745012469; c=relaxed/simple;
	bh=TOP9MS3rp/n/LsNIHEtdyNtSWwXRnzPSPHFrF+nk+es=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FMT4QOhSTIXfIJHpeCCmTErAWDVev+3EbSekkuN0TaQ8fwRk7YVVDG1CnChZDlwlwxvYT3co/padQcbnqcNRU+D1kPVe2k39oA0wU1OTURrEzN2Tm0KxN/SiF/RU/vWVtBfduUnSzO7gwP7fWpj97HklOuJfixdxraiay827FUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CqowOrLf; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CqowOrLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745012468; x=1776548468;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TOP9MS3rp/n/LsNIHEtdyNtSWwXRnzPSPHFrF+nk+es=;
  b=CqowOrLfEyGeVThP48mmyzMgro0L0n74DLGFG9AZ4ZAjIke0En1NoOtZ
   UQ4JJyCYFzTY3b2suD6GRj5Rjon+kWuuPX11sfS0XjdXRIr1osAArzXqe
   QRuGK1okYLWJRci5WHl1L4xXxwNRWXfhW4hkkyrIaDWBeNf8AFrkFMIwv
   XqajShMtXjSVWrFM8yLWm7NM/nVln3iWgYJISMomm7AiZ0Au/Yp9xVZOj
   f70vEbQOn0H/8aC7MlAjinB2c+pgcC7TFS1i2IW0LApDA25IZpHqyfm/l
   fWEJ9IXgmtnXoQxxmZWHAhp5X08GMvTCGor7UyBYkNgfDhdrxrJOF57wZ
   w==;
X-CSE-ConnectionGUID: hjoeAqS4TDa8mHk4h7f5BA==
X-CSE-MsgGUID: IHHJlp72QICBvpNSkVh0fQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="57635625"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="57635625"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:41:07 -0700
X-CSE-ConnectionGUID: SekpJqRlQ56gnnnpY1lQaw==
X-CSE-MsgGUID: a4UntrrmRuqnZSaL0wBZPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131512593"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:41:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:41:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:41:06 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:41:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tsxSuVoQwzvMtMXe56E0KPUT6tOj5Px7z6NQ1M+ByN9a+0YZrvQ6DVBFEz+a36F37bvoaPEx8L9bjawsV2WqfI6HwvO+IzmPXrb1t9ucdz6/0W/sR1S3vT/PJllX3K9yJMzE1exRNUHxnXIZ9Dfeic4at5qLTpGFVPuh62CXVqOvJCqlqY64m15e8mXBb9eW00xsx6kggaYTnjacdQNTKwG2AZNok8na/0W6iWtsRc7wvdpxoCA51wF7JmOt5Ngr6RZ7qHtSkzasEUbj/wdnLV/svAkN5ptLux5zluEuSNHzZu0P79Fg1htOTsrSEdVtHBwCXEuY1hzpVKHdC0XPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYkLvlm7RJmF46DDZ7r9y4aSizgJGEB55W8oV/35EFE=;
 b=W13I+5FDhiJFQ980wGve9YZ5rTBeA3qBEnFnsYkwLHyOaSo9iJecJZqnSJdjwYiIvYvxvMwGAg46AaJh1O0ttjQkf/RgJaMQy2EJGtlaRImOnLoJAZILpK//H2X4d82gUBj5EM7PPodtrlB7VL76ZM3l3QYotLvfpsn2MiLvRzDQCzZtn3qEjz3jwMt1akrxYrvjacMlJv+6CgKHlzurZTzBOl5ALPTEFw0+0oBjYK+nZH0udmiu+vt2etPKbYnfv+BP9dpNd4l1Q9bvmflBhpPdINCn6aIQlGvXtJw/opTg2Rm/bW8iO4ef48hDbPjAnstTk/iajodk7kUIGb7uIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB6421.namprd11.prod.outlook.com (2603:10b6:8:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Fri, 18 Apr
 2025 21:40:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:40:57 +0000
Message-ID: <f59201a8-cc8a-47b3-b495-cb2b6d568610@intel.com>
Date: Fri, 18 Apr 2025 14:40:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] fs-x86/rectrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c60013a-b2d1-4277-1cb3-08dd7ec1b45c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWV1cVlEeW5oTjVaYUhhclRheWNRb09UNjZMSWhQZlVuVWUyU2FTSmppVDFO?=
 =?utf-8?B?aEdsY05RVjJxRWsxME55Y29qWjg2UTkrMm9rUS8vQlE2NFIrcVE4UmhSUEth?=
 =?utf-8?B?bnBYLzV1RmlNa2ZPYXhqZkZLejkwL1VZaHNodWZ6WVlkREVWUllRSG1SS3Fi?=
 =?utf-8?B?eHRwLzNCQUJBZk9uczY5eVVucUJxRUY4dDVPTEhzT1lzZHkwUElFS1FXNXUz?=
 =?utf-8?B?UTZUTkI1Y1o2Q3EwY2llUWJNWmZJcUIxT0NlWndmMmRTR3hoVE94bjA1YWx6?=
 =?utf-8?B?YzNXVCttRW9ZYy9uT2pxK0x6MGhuWTRLM1RjUHZsYk1saFBqTG05SlI4L3JC?=
 =?utf-8?B?cWxDMHE2dFdQMUtaMkFaOEU2UHlhZXIxdEFvS2RDekJ3bWsrSzRQZ1RJNHp0?=
 =?utf-8?B?WGFZTk1raHc4UzF1UGFvMERDWVBoQlBjd0EvVWhRbWUrOVdpQk5PZEFMbFhz?=
 =?utf-8?B?bGx3RlNUSDhYdUxLc1dvK2RuN0lHMHFkcnlKV2hQUFpNblloMG1EQXNkN0tM?=
 =?utf-8?B?ZmltbkJ5TzN3Qkw3Ym9sUVcxTzFtUEY5S0xxM1g4dVFDZUx1dlQ2TUI0VjNB?=
 =?utf-8?B?Tm9lUFFwR3I4OXZjMURDUTlSbFJIa041R3RUa0J2YUcvTmlKUVA3TXFkOWRN?=
 =?utf-8?B?VDF6ZElka1ZRUFR5bTdRNFVTZkZidkczeDJ4UkN0UkkyT0w2Y2VubHB6S3Jn?=
 =?utf-8?B?ZGtpcXlCOEt3bGFJdk5BNk5MRHZqVFhyVS83ZjMwZ2pRdnVNMVpad2dYWjZi?=
 =?utf-8?B?Y291MVM3Sjhla0l1RzJOYkdqck9kc2NQakNlamVUZ3RnQTNxUU5Wa2tkdXo3?=
 =?utf-8?B?TTNwb0hLOGZEQUJxVkVZM0hsQVduaXpLNittS1BkcitjS0VCM3NSL0NhYU41?=
 =?utf-8?B?UUpTZUg2MXpXWGk1czJhaFBNRUFIcFF5NW56SDg5Yy9BckE0UzVCTUtDM1hG?=
 =?utf-8?B?RGlSVGppSEFhV0h6VnlGbVF6Q0VSUWExdStHTklzcThsWlpMQ2pldmdNUHlq?=
 =?utf-8?B?QXltVGNobUFxVVdDSXJGY291K0hGWDJMSXZ4M0tVNWVzMmVPaE1uV3ZBRW1j?=
 =?utf-8?B?VG04eWpacHpYYUZuT3pmTERvNWh4d1dVNkxoU3ZaOGg5TGIzUzVqSHkzR0pw?=
 =?utf-8?B?LytzVHJzcHRySDArWFhoeGRRVGRsWnkwdCt1bkdJWSsrbGJxTmJtN1dFa3Z3?=
 =?utf-8?B?L2hRN2dENnVITWZkSDJ1eFl2bDdDdnoxOUxObVROZjJwNm9lWVpwdUN1MC9P?=
 =?utf-8?B?REExYlYrMEhCbFNkRHBDaHRhYUV0SHY1anFIUDdkT2lKb0ZCTDRzbjZoQ0dS?=
 =?utf-8?B?dTRaTm1zbjJoMEkwdm9aVHZmc0F5cENXelZ6amgrcWxPUHluZjlWVlZEbWVK?=
 =?utf-8?B?U0JnZ0xBQnNZRkFqeVNuSitpZkVjMWdSMGdoOEV1U1p3TURXVnpWL1MvRmdp?=
 =?utf-8?B?SXFTWFNub1N2ellMMEtSOUFSQlZUT2ZCS0tlVStYM3RJTmU1bFQvRWszc3Bv?=
 =?utf-8?B?K0w4dWlMVXhYK0lLMDZML0dBa3FkS2hkcjhRQktjcGNYM29vUUVuT1MvSERx?=
 =?utf-8?B?LzZsRlVLTHdlT3IwaGgyVnNJNjlkaUpBS0pPTlJUSjRCMXBqZDZNWFF4Yk1U?=
 =?utf-8?B?N2YzRFlFVmRvOHBnM0Q0dVFSY0g1ZjhGSzFPMzgwQUttenN3Q3VIclc2UzF2?=
 =?utf-8?B?UmM3UDQxZVJhdURLMUFCeFJLcWdIamh0d1FrYTVSZ3ZsMnNRVXNOQTg2eWhM?=
 =?utf-8?B?M3ZtZ2g3eVcwKzc5bUF3b1V3Y2VMdHUxN3ZRTjYydFB1aWlEaWZheTVIbVNl?=
 =?utf-8?B?ZjhldXgzL3k0akRURjU3VG1PYjJBY25mTnVHQlIzaGJwbVNwWnl6OEYyTlpo?=
 =?utf-8?B?cTFkNWtwL1JWb1hpQzlLY0orMGl5RjRrMi81bmd4OTg5aE5VeWErVUZQcEJG?=
 =?utf-8?Q?2bAO/tNEOGM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1JOUFo4RjkrNCtOMWdaUG0yK2VWNzJyQkVzNENyMFlhZWZMYXNnZ0pRWU04?=
 =?utf-8?B?bi80amNxMHFaa20ySDRidEJGM3hYOUtDRzYvTEhvbldaOHFmN3I2VVRVNGYx?=
 =?utf-8?B?VzhLWXc1VlNYUTh2ek1Rb1hKN082UUkwY2t6UUhKZndXRi9mK080TWdtd0Z3?=
 =?utf-8?B?VFJQTVoyc0s1V3Q5clZzTzBDU0ZLRTdxRWdoT2NrUXNKUnNkY2NHTnp6OGQ4?=
 =?utf-8?B?bk1hVDk4ZWFMNlRCL0M1NkQzNTVFcXVKaUl1RGhDMm94NVhnbDU1TmszZGpV?=
 =?utf-8?B?WjNqK29pdmsxMFRVdmlvYnJSZTFsV3lRbXRZQ2FmRVROTnlQMUhYelF6ZzM0?=
 =?utf-8?B?K1lSeHprV0dOTitndUZOVXNFbUVtNCt0NHdrOTk5a1l2OHFJT1RwQ1lWV0x4?=
 =?utf-8?B?dzQrSUJlMlNWeXdhdVgwY2ZnRUJVZDEwbHZLQ2ZNMWEwVFhRR2tza0EranRK?=
 =?utf-8?B?VlZUN0x6NlB0TVJnbDJob1hBV1JDeGxKbkpYcHVaT05pQ20wcGRLbU02Z0w2?=
 =?utf-8?B?bjRFMTBDN3ZYSHFGQmdmL0Z4Z0RBRFVrWnRpNk5vQTcvZ2Y5bjFONFNDNlAz?=
 =?utf-8?B?LzB0M1ZwVC93VTBBbVU2NjNDZ0RZWkVYU1N1VzRmVTRSNkVzcnFiWTVRWHo0?=
 =?utf-8?B?bkxod0QzYzdlSmdLVFFQcHV2Zk1QM05XVmJTeDJuUldDOHlsYklhZmZFYjBF?=
 =?utf-8?B?Ui9kSDNKL2IxUkFhTDZUcUVNSWdrUDc5STkyWDVTczRYRnpzbDl1K2xaNG95?=
 =?utf-8?B?Qld3SlFyanVpeTkrcEJkZFU0ZGs1UzFoV2VSaTdrcGJWUjltZmZzWmVydnp4?=
 =?utf-8?B?V21qSnhBKzZ3VFhNQ1hsTjJsT0Vnc0o4VzdiY1dqNHVhYXNPVUg0em4zNUtU?=
 =?utf-8?B?QXVLdVJTVExleGpzais5RjdwdzJrMXk5SUVFYjBqZEFETXQ0aW9keWdpakJz?=
 =?utf-8?B?SDg2T1FHbFh4dDA2dnFoYVJQaFlnb3d4QWJnTkRpWXJtT3F6QTBYQ2svU1Rp?=
 =?utf-8?B?Vkg1TnpBdXZxSk02OXRJdkJyZHBJampMMFdZVnpST1VMWXdkMlJqejE4UFZ4?=
 =?utf-8?B?emJJekJPMFJwYTVuWjkraWdlcW5nMHRyU1ZvZk05NjhTOVpsK3VIVktvakJX?=
 =?utf-8?B?SjBydjFzSEpSZGZzVWpLZnliTjlJTGMwUWVHWGRlcWZFaE1QbGtlUXluRktr?=
 =?utf-8?B?ZWFnUVBNMGd6ci9MK09pemRFSlZwNU9MdTRkVFRkZWZmYXdJZEVyYnZHRGZQ?=
 =?utf-8?B?ZUhXSWFyOHZlUW41K0szSU5CUG9LNjNlL3dQeXNUVG41ckN0aW9YbHArbFBH?=
 =?utf-8?B?U29FVEkrbVF1eWxrWXBod0R4VjFZWldXSGFFN0ZSWlZvLzloek0xYWFrek5Q?=
 =?utf-8?B?bGh3RGgyWlJqQnI2OUdVekJSc3lZSTFIRlM1b3hDRGxBMkV6b2ZORWg2eDZ2?=
 =?utf-8?B?MjNLUVRZc2lUKzE2SThRbnIvZVhKSVB6R20yczVzbGNRYXE4QWVqVW5xMVBT?=
 =?utf-8?B?Ykc2VjNOU0RPdTdGUHRCRFFJZExJSnJRRjdzeVRzcVVXeUx2WHlCNEJBRmNG?=
 =?utf-8?B?VVFlQmhlbFNGWHIveFdpMTBsNHg1WG9xQTg4cFBBU2Q1SjJmVXpLcVM0am9O?=
 =?utf-8?B?TGlYeHViT25wU2tVYVhQNTJjbTQvTEptQStzNk84WWpvT1ZIL0tGRDNsZUZj?=
 =?utf-8?B?c2w4MU1RZzRDK1V1SFZPUnlsc3NTNXhNZTNYZ29vd3cveG15dkdEdy8vSWxr?=
 =?utf-8?B?aTBXTmZCSGdKZ0ZQSFp3bWVwZzlLaVMvQUpZaTU5aGxHSG5YWTlPSldONmQr?=
 =?utf-8?B?aGlxeWFtQzgzaDJlN2xXWjhHU3BBRThuL1c5UU5UME5NZ1hyOVdnK1Btc2Zl?=
 =?utf-8?B?eGtWM2RpTWsyMUk2Nytzek1ZNnBlWGlRdEZBNFBBUDJBd1hyWUdjeGJwK1Ur?=
 =?utf-8?B?NjlsWG0zOXFJcTZNZXJQUittODJzeWQrdFduY2RreTVxMlRXSjNNc01oMmRF?=
 =?utf-8?B?SmdDVDBzSkJhUC9yMGFGZnYyN1lGODdTZE5wd3ZETjZWQ0NmYU40Y0VFN293?=
 =?utf-8?B?aGU4RkloUll3a004Nk95eTdoUUtsS2MwTWZTcVJXVjgwQlMvV0JHQ2U1Zlc0?=
 =?utf-8?B?WmVqTGNaYXlxTUwxK2NNYjdheStjdFVSQ0xWQ2dpYnlmOHJEMVpJcmVaaXph?=
 =?utf-8?B?R1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c60013a-b2d1-4277-1cb3-08dd7ec1b45c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:40:57.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: new0oSkkzr9AMsw6AP6Ylwl4i15RpFti1WBakDNi55NyRZ/Ie3yOdDyaNWnJ1qRIZf5Sfz7bwJOr9GTy94yPlJ0cCJMz9sBGz2qt5/yWFq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6421
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> The "type" field provides a simple check whether a domain is a
> control or monitor domain so that programming errors operating
> on domains will be quickly caught.
> 
> To prepare for additional domain types that depend on the rdt_resource
> to which they are connected add the resource id into the type.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            | 19 ++++++++++---------
>  arch/x86/kernel/cpu/resctrl/core.c | 12 ++++++------
>  fs/resctrl/ctrlmondata.c           |  2 +-
>  3 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d6a926b6fc0e..177f9879bae1 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -111,11 +111,6 @@ struct resctrl_staged_config {
>  	bool			have_new_ctrl;
>  };
>  
> -enum resctrl_domain_type {
> -	RESCTRL_CTRL_DOMAIN,
> -	RESCTRL_MON_DOMAIN,
> -};
> -
>  /**
>   * struct rdt_domain_hdr - common header for different domain types
>   * @list:		all instances of this resource
> @@ -124,12 +119,18 @@ enum resctrl_domain_type {
>   * @cpu_mask:		which CPUs share this resource
>   */
>  struct rdt_domain_hdr {
> -	struct list_head		list;
> -	int				id;
> -	enum resctrl_domain_type	type;
> -	struct cpumask			cpu_mask;
> +	struct list_head	list;
> +	int			id;
> +	u32			type;
> +	struct cpumask		cpu_mask;
>  };
>  
> +/* Bitfields in rdt_domain_hdr.type */
> +#define	DOMTYPE_RID		GENMASK(8, 0)
> +#define DOMTYPE_CTRL		BIT(9)
> +#define DOMTYPE_MON		BIT(10)
> +#define DOMTYPE(rid, type)	(((rid) & DOMTYPE_RID) | (type))
> +

This seems unnecessarily complicated to me. Why not just add the
resource id to the domain header?

Reinette
