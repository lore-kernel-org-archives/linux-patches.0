Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDF9FBF6
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675509; cv=fail; b=DyJ2XlmcFQ0LQjGVtd7N6XS0zBZY74QfKc4E6xUXI84+qsQ//EFNoSk1s5Ve9OTYRaIKB+gg+tLaMa+X/T1DMTkLUkQu2upbhsgLrxZzCxYp9/oL+YqRk9Bh7SinfoWjcWwqSNRVklWmUyuIA33XPZN9lTpqyQjTx7JljZHxlHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675509; c=relaxed/simple;
	bh=ZVl5n9dBVCu2RsWnqnws1GXHmNHLwV6EdF9HAgbBO3s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iEFRKF97IrOwvzDTTnx1gTayBJqtgJLH3bCIACDhwjrx5upTrZpcUxCyydMNA/nYcQHPM5eagKoq3dasCIGjbIPVep3qE0y/TBTBdBGZBFTWh8R4yPjJdaQ4F4qmwXSy1pE3r4vHwYo9lbTVukok8GiLIlRenBVoHn356oyZORA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aEC99s9v; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aEC99s9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675508; x=1778211508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZVl5n9dBVCu2RsWnqnws1GXHmNHLwV6EdF9HAgbBO3s=;
  b=aEC99s9vVFD4lVpmKe8j2bw+p9sGiipVKzFRtczHTF8lK1DkFrs0++M2
   Jll0EwYvBRiFdOoK4TqFCzd0BknJD+PMRpRSLBYgt6Xa4Gi6loHW37npM
   3gs3iXrxmAn9bWhyrsbkNR94u0M+dRVecLB44KEy+YzIr++OKMKRukeTh
   WDB/rSJlTx9+JJQzYQymc09JDPSppgvGh9mj5W0KZrv4hYJgdGeAQGAlx
   0Yv3OMDnPCpoDpeqVImEDMaHyisu5NLDAYIYF0gtK+oSmYX816Qc7K33/
   K34wuJO62CN01haKBLvfR6I91fNopYQ0g1fGUxXNzucyYNFKFOy0NL3m0
   g==;
X-CSE-ConnectionGUID: 0k0y2vrSTLW3BuJZcOzXQQ==
X-CSE-MsgGUID: RgDs0vZXRmaZOu+6nM90oQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58638450"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58638450"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:38:27 -0700
X-CSE-ConnectionGUID: YzBkKMomSKyHR4rATvFWEw==
X-CSE-MsgGUID: e2DLChz9TTexWzZz2VLcaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136117079"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:38:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:38:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:38:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZbemunhKAqruzR4t0SivVX12jJbsmBSv9ClE9/XsqOQjThU72lwuhhHbHw9ZLEDRyKvPksecSA7Goi8buBfAiV985UXASyZxd6+3E2GPLuUXnM8tH424nlpSlqvs8Vmd/F5j52dGdQ5+tMMnN95CeP+y7cIbk8Pn+TFofg2vkZkZcLZNjbsjox+7P4b2ybN6Ylxll9umIj0pYgMHukIpywbbkEpW0IusRW1RrNB9bQO181vmOxupNaKG+ktdM+LY50zo69vmI0pBmMvycL/RrJkjHqKPO3Y6NpXCpOrRVS4HqsHEdqls4U3YGK0J3H+gtUXK6ktUF11WpsD9jZfEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKBlz21xkll2OTwXWYfDjqyWWu9YlN3qrptqTNmQd30=;
 b=Nh9CALa316tkEsOpkynzQ2Rhcndd9c5HzuhlcEmXokKLxG0CuW5WA9uVgLjzsC5iKmVYK3+232ZN8GxM2b/4/WIsZjFJvnUJ2yKLYbAxZHbjOBC5PJEbC4U8D0oumvjIUqgkIoMZIHQlSn0qe4k7Xes5NhjqQcL3ozIyQbeRvpHnE33uKJI8Itt/tv1jUbAPIOz6bJQwLjYcL6w5CY8IHOwoFm48RS3zxlsdiDZlBl2ypoZTMb6ZmMZjm4BGsZUnTFDR+GdW6zqKeTUM0nPAdftxF9zJiQsq2lYFxLmu6AH58ZjO5/sLbBdhwMBcSjZOkceuGVqm7GDJ9OpSNSLoIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:38:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:38:14 +0000
Message-ID: <ec7c62cc-61a1-42e5-a6b1-066fe7894611@intel.com>
Date: Wed, 7 May 2025 20:38:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/31] x86/resctrl: Change generic monitor functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0082.namprd03.prod.outlook.com
 (2603:10b6:a03:331::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 5128178e-e384-439b-b66c-08dd8de1c33e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnFWYWo0M0xOYkhUdUpWUStpbXNEeU9zZ2R2K3NwUnZzdVFNRlp1K21PSmZy?=
 =?utf-8?B?SHZOTmVmOGpQdTFjWWwrTGZLdmpIMW5LSmovM2dEL3o1Q3NYNnFtNVJyNW1F?=
 =?utf-8?B?cHZzNERsa1Z4bkZXTFBqRHRzSTZzRTRwN3hsaENBUzZSVDVteXpVQzdvQndm?=
 =?utf-8?B?NzBHckQya1FUUnlyWFA0cTN6WHhKMXFodEJybjFlK2FId1FaaThvaEhpSjIv?=
 =?utf-8?B?d0Vpd3B3RTl6ZjhnRzBqQkxybGMwVXV0eDR0VTVOajBhSHFkVmxZc1lvK2l5?=
 =?utf-8?B?bC9mOVptRitwaHJNVG1SMVVNSGRta1dnU2ZCMFlCRmVwNVBrNjdnN25jeGFv?=
 =?utf-8?B?azVLYXQxdG5LcjU4UTRJM0dxSkRwamk1bGM5d09rUHlWL0M5UVJMWlA3cnVm?=
 =?utf-8?B?Z2FZQkd6OWwrVnFqaWRtV1ZXTXlqMTloemJrc1F1THIzUkNaa3NTYzhKaExE?=
 =?utf-8?B?eVZpL1h0OTZvK3cyUVhLYnUxRjhkS2RLaFFQUmFEOTA4Y0JXOHFQRTlLN0ZV?=
 =?utf-8?B?K2lBZy91OHA0c3ZucDJVWTEyU2tZWTNiZTR5QUxsM1NTQTJHbTB3Z0pWRjNJ?=
 =?utf-8?B?UkN1RVc2WGpLRDY5TVdJTlpzS09DWEp0bjNodTczZFR0c3BRb3VrWVV4bStK?=
 =?utf-8?B?eGxib0RsSDladEJicTE3V3VlUFA3UHE3RnZJNE9RNDQ4NnM3VjhXL2FRREhB?=
 =?utf-8?B?R0ZGTGw2SWNGN1J5dUZpck9nelBEVG1BZTMzSCszRnpUbm1oUXMwdXJGRHFD?=
 =?utf-8?B?anRTZG1TRHdhVi9GS1MveEorSWtYdlBjNjRMUENSaDZzUlBsc2crZHVUK3Fn?=
 =?utf-8?B?ZVRyTUFyWkZQc0J2ZVRPSEVWSHRKR1ZSUzBlaEVHUE5vbTEzMVkrTElTK1JS?=
 =?utf-8?B?dDBsZ1dNazhqTnk5SjhraEw3MXZzTW1uUEM0SlE2MDZEQkh5VS9uL3p1QWRD?=
 =?utf-8?B?SWN3K3NINVhKWVdQLzFvVHNISnZ5QnUwSmtzcEprUktuZ2xJTDRnTlVaZldE?=
 =?utf-8?B?cW91NjlDdVI1WkhzUk1kOThLM1lRYzVDcStsNWNMK1lTVVVkcS9Vc3lTc0p6?=
 =?utf-8?B?bjZIMG0vcFZ5WHhmZ0lIaTBZWnNJYzVRZ3VLdHFFL25FdUVYVlJWZ3dqeDJC?=
 =?utf-8?B?eGxnS3RXWEdsMjEzRkxrV1BXcFNkZ1J1Ky9lb3FtbkhTRlRDOVRJNi8waXJy?=
 =?utf-8?B?S0FrR1lUTDZHeTJCc0hUSkxYdkVjY2NGTWtRUE1oL3NmcGV5b1pOQnAzSTEv?=
 =?utf-8?B?WC8raERUMDRwMjBXUkZJWkdhWkhqL0oyVGxCaXdwTUlaNHlKT0NXSjJBREVa?=
 =?utf-8?B?WUVoVDhUdTlMYTh0ZC9GMmdYckxEUndhR2xNbEgzbVJTRzFpbHBtMkwyczEw?=
 =?utf-8?B?ZWh3Ly9IOFg1ODF5SWNmQ1RmSTZoWmpoeHovVG9SZFpCNVIyT2ZQSzAwM3Jx?=
 =?utf-8?B?eS9DaXNZMXZiZHBCSWsvT3JXVXZ5S2pLczd4dUw4WmhIdmFTaXBQOWJyOEd6?=
 =?utf-8?B?U05aaW05M0lBdWNRV2R0UURYem4wNkFkbVArd0g5MDlsQ2J6VDFlWnJrSHJn?=
 =?utf-8?B?Mk4xMDJaeDNrOHk1aWIya1ZhQkU5NEtURXF6aHo5WnF5RnB1VjUwRmRyN0Zi?=
 =?utf-8?B?cUYrZGIvbzZNaWxXUSsyU3hzMmhnOWZCSkUySS8yQ2o5blBOY3hvUklMSGRE?=
 =?utf-8?B?Q1FCQ1duS0VVd0hpVnkydW5DZ3Q0eU5xUkRvQUY4TVVvR3ZIUkFjWEZZbmsz?=
 =?utf-8?B?L1RNZWtYc2VqZjJQbXN4RGUzYW5Dd1RjNXQ0dVZMUHhKVUtzYVlwMHZneTZZ?=
 =?utf-8?B?aFRkMno5RlhNdHQ5S0hzSVpWcFJoZ2lMU0gzczc2ODA5QXdaaVR3Vkh2a0V3?=
 =?utf-8?B?Ly9hNzBmRFJuVVE4OFc0OXBORnRrVXl5RXZ0V0pTTlhxcUVZMnNjUzY5bHhi?=
 =?utf-8?B?SmtQcEZJOXoyR3I4Rmg3dHJqbE5vTnpONlBaUmJtdzNPU3FOYVV6NnQ4eno0?=
 =?utf-8?B?Zi9EZ2w0bmp3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDdRbmlFeGhjRCt1OWFSOTVHOHVCdWVZSFdtWVVOUnlMVDQwSDRNWWNVZUVw?=
 =?utf-8?B?aHFLcWlrcnVkWTdMa0tnWExLTHFWc2UvWXlnWDZSeG5LNkE1Q2d0TTVCSmxy?=
 =?utf-8?B?dTVGZC96UkkzYlkrQWF6TGs4MDF3MHFZdkR4YmszUFVCM2wxdFRiTXYvYnl2?=
 =?utf-8?B?VnV5VjNPMlZNUGY3RTI4cmdEeFpMWXBDWklFbTBuVWx3MU1sOElOcWNRdzdq?=
 =?utf-8?B?WC9LZDlUZVdvUm5Kb2VVbXhydzMwaHJGSGFYTWNXYktiNGdJaWRxcUVEK0Ra?=
 =?utf-8?B?amYvYlVLQS9QTVZoeG5CTWRLVEhXSlVqNG9FZlAwNVVuNktOMHFiUWJwK3B4?=
 =?utf-8?B?N0ttTVYyb0hvVVVlQzA4eUliMGhQL0c5WFRBV3JGQjFVUVBxbzlBR0I2Y2ps?=
 =?utf-8?B?ejU5MlR1RVNIRkxoQzZ1L1J0WFZjcnB0UDNFWk42YVRZUzNBbWczaU1BTlhq?=
 =?utf-8?B?RitCbnhTTTZRT3I3U1NpUWhsWFhLNUVuakxrUUxlTHp1YTRGcm52YUpGaEVF?=
 =?utf-8?B?b2ZENjZyaitIaGI5d1BKOXdBWm1KTHZFR1MycjlQWnJnSGtYZmZXOVJXeU9E?=
 =?utf-8?B?YW9zNzJQWEZ4aEt1cmpjN1NXVFBMYzBqZkxyNnNoMjU3c3V6WVNLaUYzT1lm?=
 =?utf-8?B?c3Z4Q01jeGF6V1BJdi83SGtXVzJCeFNnS3YzNjdxN01mSlNLcjRvcHM3TUNz?=
 =?utf-8?B?cTNXV2N6TG1NZXRqd1JiZFprWWNyMXZTR1RkOWExZ2NaU095TlVacWlweHBk?=
 =?utf-8?B?eTVoQXVFWmF3NE9pSGppZ1RWbW9rRjFUTXFnQkZtTkRXWE9uS3U2WHplZzRu?=
 =?utf-8?B?ajVIemVLcXVaYzBnYTdkTkdPU1dwam1EWkgybmlncjdxV1A3WVJLaUpucXht?=
 =?utf-8?B?OGhUbldpc0JpYUd5UFg4YjdwYmxyMXBsSnNtaFFZTXRVOWwzdXpBMFEyNGpH?=
 =?utf-8?B?d3lkdnlFVDRRZDlQMjYwZWdsalZGV3UzZ2ZMS1N1NWRibnI0ejRkVS9lY1Ny?=
 =?utf-8?B?MnpiVzFneUdYSTN0RzdoUUNXSWNxYVRLVzBVWmhrUUNRck9uV0cvMzdjMHJO?=
 =?utf-8?B?VWhFTmhVUmtRSDlJaGFsemd5elJvUkhaa2JRaThLMit2ZUVqTkpKbjhOaEty?=
 =?utf-8?B?d0dvUDE0QzIraW0zOGkwcG51M0p5YTBOWXpsNEZUaUpQL0lkZjJ0ckkwYW5P?=
 =?utf-8?B?SnI5ZW1VRHkyd2krdDZPeFZtcVpiMVpHM1cxdEt3NllTdzhNRWZCbEdBY2w5?=
 =?utf-8?B?bm9UY01OU1MrWmJRakVRZGxDcElOTExrUGhZV3QySk5QYzBsNzlvY3NjUldu?=
 =?utf-8?B?UWh0R3VYeFFQTjZSem52R1ByMXdUREM5SHRlRVlZemFXNHVxVjhvNTVBZm5E?=
 =?utf-8?B?R1EwOXdEVE83V2RxenEvMTVTOTNKSXVpSUIvUWNLcDdIaGFXUTNMeUdHMWRv?=
 =?utf-8?B?aDZJaTBsUmQwaXRlbG1TZllFaTFVU0M2UGhOYmlpR3duQ2E1Y290djJqdDVW?=
 =?utf-8?B?ZkhXRFBGU3lTZWpJUzFQVkN2ZS93Y3BYT3ZVTDJsbXBxa2RKMFpxazNad0N5?=
 =?utf-8?B?V1VJeTh6UUZPZlFnY3JNQTA1cG5RVHpHbERvWlhmSVREQ1g4UDJkc2w4RkZq?=
 =?utf-8?B?bzJHRitXbEJwaVVPQ1VkNUhiS1lISHRHbHRjQ0FCNG5hdmVMRkEyWW5EQ1Na?=
 =?utf-8?B?Y2lYeHVQejEvbEhIWHc2TWdHdWEvUVNmQm1PUGdFc2V1cjU4dGlRdjR1ZnFV?=
 =?utf-8?B?VzVIMVBobDE2OXRPNW1oQ3d1NStpRFl5SkRwV3pNQVVxRGVFK3o0RU93dE5E?=
 =?utf-8?B?dW5HKzZuWVdWUVB4dkpVekVWejRvZGE3V00vV2svMmlTQXBqZXpzdTBRelBk?=
 =?utf-8?B?TGN4NE9DMXdJV0kvM2lraFZUeFBMS2tQbldZdDI5dGlOMDRiTW9CdzhZRUV5?=
 =?utf-8?B?MGdsZFEyVjZyLzV3SGMrd0dtMzZRMUhwUWJMaU1OdG03WUFjbGVNOC9xNEEz?=
 =?utf-8?B?WUExTTVRdlNNbmZXVjhoOVI3RTVrb0VDTDAvZVBPTm9MUENvK2VaSEZFNmpp?=
 =?utf-8?B?aVEvS0RWbExVeEZuVFpEaWRFZWxTYzJjMTZJR0w1SVZKUmhuaDFBZHhSdnRU?=
 =?utf-8?B?aCtkWHZpQXlZaE5kUk0yNGR4R01Fdm9wYzQ5RkRKUjBMcVcyOHFkUk9tWnZM?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5128178e-e384-439b-b66c-08dd8de1c33e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:38:14.0447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KiaoNa4TK8KQNAdPImSZaH91YQnzS1VllBgTJK3/SRngQ0Mdj57icZl83BjVM2C8bYD9dkDslub8PIw3fDntnB46jqPO64ZIII0DvcS71w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Functions that don't need the internal details of the rdt_mon_domain
> can operate on just the rdt_domain_hdr.

Please add a bit more detail in the context:
"just the rdt_domain_hdr" -> "just the rdt_domain_hdr within" or "just rdt_mon_domain::rdt_domain_hdr".

> 
> Add sanity checks where container_of() is used to find the surrounding
> domain structure that hdr has the expected type.

How is reader expected to interpret "hdr"?

> 
> Simplify code that uses "d->hdr." to "hdr->" where possible.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  arch/x86/kernel/cpu/resctrl/core.c | 19 +++----
>  fs/resctrl/rdtgroup.c              | 82 +++++++++++++++++++++---------
>  3 files changed, 68 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e700f58b5af5..bb55c449adc4 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -444,9 +444,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
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
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 525439029865..9c78828ae32f 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -460,7 +460,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>  			return;
>  		d = container_of(hdr, struct rdt_ctrl_domain, hdr);

Is the above container_of() still needed?

>  
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
>  		if (r->cache.arch_has_per_cpu_cfg)
>  			rdt_domain_reconfigure_cdp(r);
>  		return;
> @@ -524,7 +524,7 @@ static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct
>  
>  	list_add_tail_rcu(&d->hdr.list, add_pos);
>  
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>  	if (err) {
>  		list_del_rcu(&d->hdr.list);
>  		synchronize_rcu();
> @@ -537,7 +537,6 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
>  	struct list_head *add_pos = NULL;
>  	struct rdt_domain_hdr *hdr;
> -	struct rdt_mon_domain *d;
>  
>  	lockdep_assert_held(&domain_list_lock);
>  
> @@ -549,11 +548,7 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  
>  	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
>  	if (hdr) {
> -		if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
> -			return;
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);

It is not clear to me why changes to domain_add_cpu_ctrl() and domain_add_cpu_mon()
do not match in this regard.

> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
>  		return;
>  	}
>  
> @@ -603,9 +598,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  	hw_dom = resctrl_to_arch_ctrl_dom(d);
>  
>  	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);

Above also seems to be candidate for the intended simplification?

> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> +	if (cpumask_empty(&hdr->cpu_mask)) {
>  		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> +		list_del_rcu(&hdr->list);
>  		synchronize_rcu();
>  
>  		/*

Reinette

