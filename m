Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40824378815
	for <patches@lists.linux.dev>; Thu, 23 Apr 2026 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776988456; cv=fail; b=jRd/uwOcLGyzUlqqfEbZdY66i5dt5GL13fiF2Y5YmZMG2hZXI3f5qCLBwOAk6dqXFB0PUbElwAVqVXlclO4el5MTjC1ykIGNN2agdnCxsQMZgUAdXgwr5K6s/9HlBD7W7vbe4RJN5Xfn8EElQowGWUVl4tASGmwGb+E1keBbV7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776988456; c=relaxed/simple;
	bh=nTyw/lggKx8abRR9X+Q8PqJDrrefNxWbmivxuIXeN3s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oHRdjGqIBNOJxIUBb6aATv+O6api3UH/aOhCZJFaoGCcArbelbOYVRpzyGPErt6ZxFDvOIORViYOYmSdQ+ja4x7TjhmZyIj3CNwWIUXOVg782yYetpdKsq8gfNozNvH6nnCPo2BQ8IA2NnGCqWeyM49QPPY0pWKk4C0z2175lU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXfHVwBY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXfHVwBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776988455; x=1808524455;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nTyw/lggKx8abRR9X+Q8PqJDrrefNxWbmivxuIXeN3s=;
  b=QXfHVwBYo/xHu7jafH9KkX6cUk7X6CYPmeBoCJ30pMP/LskzVG2E0xVy
   /YMvdL8A4nSJLOcPdIXpTqIpo84prc2/4LHMBwUgsjBAZaZ8M6hafcWr2
   CyLrWS5oQxAuX3D7cqzJTOVPQ0mUmpxsU+CxBZXxxsfnIGkYt6KJZzPZY
   zen4PIyXuWbziyQAGIVsGId4+Hcgj5JnqPbdQv7Iutyk0obGZG01dGCIo
   Ra57v1W1MpFuc20WLgOEjrc4M5Ncx4tkX2UKpOqymimWPpi+vRtaFRfdp
   i5ndNHVmDW341S4ZZ1VWOtzX+YZ5ONhCN4OUG/Mt04d11Tb57nlQKtQ78
   Q==;
X-CSE-ConnectionGUID: barMdhHNT52GXqfvwjTNMg==
X-CSE-MsgGUID: 6RZ7bizmTRqkZY4NjZqpgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="77669242"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="77669242"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 16:54:14 -0700
X-CSE-ConnectionGUID: p8V274R2TRGol7bQxi6Geg==
X-CSE-MsgGUID: K6E5zm6RTqiLOLWGOWnm/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="236782469"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 16:54:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 16:54:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 23 Apr 2026 16:54:12 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 16:54:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwcRhBsjctIUPhGjq5RUXHiJzNZZZJZ5j5BYVN3TaZaEnIwo7A0fbMDTEAgc/gSVb8/EpNe+y4WyrHL1EdsSxTN5hAVP6P4mmWH2b1f09hg1qmOWk3s2yTWkM+WUEbSkRL8fC5ctC2eHJkZGW8mGkFzpHhPdx+4Tii/x0AVnaL8R+VfThp7cEZWmbiF/g8b9FZGxo/iW83q4AR6+ezRSFchT+OUvJdbV9N5GCiPU4mQC/LKe9p8+zsAVaIoyYROVuVIffQO9UXe+yZ2Ta4ha2ckGqq+pzu9Py/1rppU30ro39ITQ9OP4R90fMDv99scK0j4zWSEYtMoMk8BF9Ryz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iW/PE9RdKqTgNMqhMqRuWIVJLw4KEdXAdLOextqxkM0=;
 b=DNsNlhBOGDfMDM9xP3zR+qw5siIjO5e/TqNMOykbv+04WYu7FNxvzqAjS+p4y89lWe12w9xGlhlQwr/zQCyoQRGLH7aTVZj+19uHVkYr6txMDVRSm2V8s9EPNBgvFdmHl1Z8ECOeY6ISTrdmWdvw9ReZecVUf4UM4jI5tsJwDfkT1dRqoq8iK3LrSZ5AN8Ha/SfaUpoRGwqu3dfMnI0ou+/9xjzUGPph/ATkTr54OMFpLrKOg1sEpqG62/Hay9iTNOVXPATNluyCB4ZdDEoUiAr3NQ9ftA0Rw+6qeFmpTJ5woXMqz88xh8nzcjjoU0z9ngFdCnZP9M3u//LKRqOVWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8857.namprd11.prod.outlook.com (2603:10b6:806:46b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Thu, 23 Apr
 2026 23:54:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 23:54:09 +0000
Message-ID: <f0015e2f-3468-4a31-8eed-c46bc6804ae3@intel.com>
Date: Thu, 23 Apr 2026 16:54:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
 <aeqdOlO3BkKQqSQ9@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aeqdOlO3BkKQqSQ9@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0387.namprd04.prod.outlook.com
 (2603:10b6:303:81::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb0afae-7b02-4568-55bb-08dea1939cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: n7fyP70DrnF64gW+TsoaQSChFk505knU7py6/TUmtRSGsmkS3el0Qx+4/ig+xca6VIvgoWAi0vEJpnYpS879OeqKinn6rf4dJrdtFTr/OhvUdeaKmz0yl+O71DYr5JICEkzAALSuEglumJbw9Bow95B4rxBiF5etVBTSL4awMshGhjsvR67/DLGIO7OJGorkkNxO9OZns4Q0apjgbqLZjUAiDjmUV/Ep5Y2Fn+3Bcf57Ir6WhYOzk9cXRm8tYgb1MiuyhOQReAuqh+2fQKy5ytgJLgSRR9ZSgWZfPhJDJPhdHvAOC0YmSemHRK7QsWnUjv7NWEIelNhgueopgvBoyjDmKwKCGrDyMzgMf4V43H+7nQDMtXaEUzOmxDiLCJIQaw9X0z82eFPqVElZUZ6nqJzQ7zf5ub8kT07ViMfYAhRLYNZOlpeeF0j1rCYyks2iGEO3OSPjlnLN/VIMdAJ9UZAxBgUKsplX460h9jVeYbWjUZg9uXPhACXW0s0uKVqku+NZ9nCIItTlH19Ui/BUvBuMi7VejrtWU09tCLFLSIe4Z0KnupmJe3aVQ3ZniG1S0Qvsh4LJFHkrKFnaeCzlKOWD/NOUzafWdlfSmUMrl1NWCvn3AKzw5GbexIHg17j3sVE1LwocNaYeP7Jb3K4mrVDskd1zt/xBUaHgUtimSpNphdylpxJFhhLEU8Qx9ZxUNI5FTyB8Mzh2FfaSE90shg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUxoVnBkRERKNVFmSDJ2dTN6N3lyc3BJNWRNN0dUZ0dJMXEvRGQ0TTZ0ekYx?=
 =?utf-8?B?ZnlESTBycUYxSklNUmRWNFFVZ1RhK1UwU21aVTREV244Y0t0TEdlenBYbTN5?=
 =?utf-8?B?amlvOWFkUUNxaVNXd3RWbENwR3l3Q3hOeVJhNDFXZlg3Z3d3R3dQL1dDNm0v?=
 =?utf-8?B?RjkwVWxSTHRBZy92UW8zSzFqQWdVUVBhcXRCS2NCYXlKZCtrOXZjc3Voc0Zt?=
 =?utf-8?B?Sm5Udmc0dXVJOStQOEpHdmppTVlERHRoaEVtUFJQcWFWcUpFRVlJZUV3Z0pp?=
 =?utf-8?B?MUNPR0lVdXJUK2VkdzJqbDlYRUJ5ZzNJVHlpTkpWc0s3YTBBSi9wYSt5cEsy?=
 =?utf-8?B?L3B0T1NRak41L3NvQXNuNDlBMlBPbThwYk8vWDltMngwL1h3M3dWN0ZzbW1r?=
 =?utf-8?B?a1JEL09XRlJiSTZNYm5JT3htanlDNFVBVVdtQ0JnTG41ZkdGUlNodDhWb2d4?=
 =?utf-8?B?YWFhbStVMWxQdXRjcG9NbUdOaWFlRG1TVHB6bkMzSHZ4TTc4MmJLNzVja1Jw?=
 =?utf-8?B?K0xlYVNNaTkvTWljNjYxQlZ6blNSaXZMK0lOSFdpOHNuLzJMeUwvdHA1eVlU?=
 =?utf-8?B?aWRlRlRSN3AvQVhRV3Z3MStmWmdGM3RCdXZPSGxscW1RRGtFdjlacFROZUg5?=
 =?utf-8?B?M0VxNUpBc2VJK0NJUC9EbVZ4TFg5bFpLR1Y2MEMwUFVXOXRmRVVhWm53akFm?=
 =?utf-8?B?ek94QW1zR2g2MkRiRHNZZW1hZU5KeVVRNXpmK0lsUG8wcUlYcjAyNHh5RlVO?=
 =?utf-8?B?Mkdldk5RTjBsbnliQmhNM1NzMTdPZ1BnQ1l6ZWZvbFhvbUVjT3NrM3ZIdVY2?=
 =?utf-8?B?aHZENzFqSUpZODBNU0RsRC80TnRQai8wcGwrQjljWmhwbk1ZNXVhVVQ1K0Zh?=
 =?utf-8?B?UGFzVUF4WExIWm9iNy9IZnpscno4eW9kVEkyNE92Sk9lOWNLNGV4dk05QTJN?=
 =?utf-8?B?cmNrS2hoR0xuL3ZsaHN2M2FPSnF5ZFBuLzJadFpUUy9DUmFjRDVCOEk2K2Nh?=
 =?utf-8?B?TnlxMW5YSjN6N2RGSXBzK2JZSm1Bc0FsVTlDVERQVDlPVkNYNkoySnhXeDJr?=
 =?utf-8?B?QWNqdmowd3R4L2ZDZlkva0tZUzV3TzNTc0tiVThWbUlvWXFUb2VNVHk5RjQ1?=
 =?utf-8?B?UDQ2KzNIWmVsYW80ZVBOK1BqWi9iY1hVYnJPcUF3bjEvNlpHOUJyOGR6VkZw?=
 =?utf-8?B?eWZ4ckFxTHRrdlZ0UFFzTTQ4K3R0Unp4U0dZOHF4aVdPd3lzS2tFUHhEN2ht?=
 =?utf-8?B?RnR3MlIxMVhuMFF1UDhwTXZsQmMzQ1FOQmJzRXkxV3RxQnN5M3NINnNCcklv?=
 =?utf-8?B?NFJGYldRVEIvVTQrcFpSU0lVY3pLeGVDaERBTnYvaHhHYldTQUtyUFpCMDFp?=
 =?utf-8?B?UDR1UE1heFZlYllraG5lem1ma1JaQ2kvQmwxYTg2TSs1TWlZd2FubU45bXNi?=
 =?utf-8?B?bWxscE1pZWZJeXJOSkdjYkR6RjAxbmVacjM2MTA5VFIzaU53N0drbzljc1d2?=
 =?utf-8?B?VXBhOS9JNnBBQlFQYS95QjVCQ3BBL05NakJNbkg4dEVYTXF5UXF4ZmU0YTNS?=
 =?utf-8?B?MkVmOVRNelVyQjZKbG5Da3hlUEZMem9SR2wwWE9MNlphcEdaQjhIQzZuT3lC?=
 =?utf-8?B?c3g3MXovSmhrTTVxRmd3NFFUKzVmQzJna05FS2RsdFlPY3c5YXY0OWYvaTc4?=
 =?utf-8?B?YTlQZkZ2RW83dlNGRXpjZmxzVk9lMFdxTEFDQml1L3BjQmw3WVAzbEJBYkJs?=
 =?utf-8?B?NXdvZkVZSEhDUmRBZE9sa1ZJak15Yi9sREQzTXBlTDlsNCt6R3RhWkI2WFZw?=
 =?utf-8?B?TGdUNnRsMmNJVlNZMWsvSGxvVGZVUVdweEpVMFRkcXhRbVJzbmlaVlNSc0ZI?=
 =?utf-8?B?MEtmWHl5cjVHWXRVTkd0MXkyNVpxdk4wdGpJUVZHUVhLM2VPMUtOZmhkQ0JB?=
 =?utf-8?B?MU0rLy8raWJzeVJ1NDl4MkJzdkpOYmpUU3QvMWVZWkxiRWU0U3dTQ1Jrc1F3?=
 =?utf-8?B?WUdtK2swbjluMzdRZmlaR2JQOTNFTkFKcEN4TEd6Z1BTOFkvZFBuNG1RRTVj?=
 =?utf-8?B?dTFydExLYWhDby9xaU41TzBvODdCM2RtNzlmb29vZXhJQ1ZVMWF0clFYdG9B?=
 =?utf-8?B?TXNEeitScGUyeVM5bFBZZjVBMUlPR2dyTUloL0dxWjJaaTJqMmFlczUxTlBi?=
 =?utf-8?B?UGV0NTZHV20yMWoxSEFGME9IZUJKdE4yeW8zTVJ1WklWOTMwdmg1ZkZ0SDFD?=
 =?utf-8?B?bFM3TzBua2xEVW9RajJzcDgxVjhjTk1aWnFwaHMvcmRCTDdVc0w5SGM5M1Na?=
 =?utf-8?B?M0xmdXBwdjlFUkx6K2o2VHMveGRacEltL1NObUNDTzBDM28rTzJOTmQ3ZjJh?=
 =?utf-8?Q?72PYRK/NL59/EXUo=3D?=
X-Exchange-RoutingPolicyChecked: Jhzq/4l/Bl4kLztvjXsoODYUt11Jvq7g0xeTf/T5hkUHzTUbg3Co06+4DpfkCqDg5JvnRpJ5tTNKQfQTQbW9RaLTmsyGQyW1EzIjmwFnkP1J9XuxrUyYpr70Ypyx9NuXaE6uMXYPi9ahy7/2LGM5T5SyYAZOgRouhnnCcHNi82ZSSnDUQfpWk1rVnPccCECIj9KgF1papVYHDv0Jz4d2onU2sQgzHM9Aazq+k4pgWxaXszp9wPncoiPvpeyLz9uvFHBuX9fgNen64xMUxObgZD5WFSgc5Zkzw/znG2UwhRX7iQp/+jLX1EEt97MdnTUW2F1Af4VYdQrS65KMi9w1Tw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb0afae-7b02-4568-55bb-08dea1939cac
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 23:54:09.5504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKwzEKQTrRvvqG+pU8ZaFffnS452Q0J5g/aYGZP5IaIhr88BGXXIYSlAYxY2H9JF2OG4PW5P7G4owhdWpTALCSvgx9LOXYgwmeWeG90anXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8857
X-OriginatorOrg: intel.com

Hi Tony,

On 4/23/26 3:29 PM, Luck, Tony wrote:
> On Wed, Apr 22, 2026 at 03:10:59PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/22/26 2:59 PM, Luck, Tony wrote:
>>>>> Seems OK. But to make sure that events are accessible, architecture will
>>>>> now have to "hold" the pmt_telemetry module regardless of whether
>>>>> resctrl file system is mounted.
>>>>
>>>> Could you please elaborate why this is required? if I understand correctly the
>>>> "hold" on the pmt_telemetry module will be done by itself between the
>>>> intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() calls.
>>>
>>> If architecture code runs completely asynchronously to resctrl mount/unmount
>>
>> Since there is shared state that is managed via existing locks I do not see
>> architecture running completely asynchronously to resctrl mount/unmount.
> 
> I think I now have a solution without any new locks in the file system
> layer (just a call to resctrl_arch_pre_mount() on every mount and a
> call to resctrl_arch_unmount() if the mount fails, and on unmount).
> 
> Testing in progress. Cleanup to follow before posting.

Thank you.

>>
>>> when would it be safe to call intel_pmt_put_feature_group()?
>>
>> I think I am missing something here since I have been assuming all along
>> that intel_pmt_put_feature_group() is and will continue to be called from the
>> new unmount handler.
> 
> Correct.
>>
>> Reinette
> 
> I'm looking at a more aggressive change to the Kconfig options.
> 
> Linus complained[1] that the biggest pain point for new people is getting
> the kernel configured. Extra CONFIG options was his prime focus.

Thank you for pointing this out.

> 
> So I'm looking at removing CONFIG_X86_CPU_RESCTRL_INTEL_AET completely and
> just making intel_aet.c included with CONFIG_X86_CPU_RESCTRL.

Sounds reasonable but how the final dependencies would look like is not obvious to me.
Consider for example this removal happening with today's Kconfig that may force
a kernel that will run on AMD/Hygon to be built with INTEL_PMT_TELEMETRY/INTEL_TPMI.
Something like this does not look right.

> It does mean the resctrl will depend on X86_64, killing 32-bit support.
> That was discussed before and decision deferred. But there's other 64-bit MMIO
> stuff in the pipeline that means we have to make this change sooner or later.
> 
> Thoughts on unconditional inclusion and on removing 32-bit support?

I believe we already have a clear answer on 32-bit support for resctrl on *x86*
from Thomas https://lore.kernel.org/lkml/87jzm3jckw.ffs@tglx/ and
Babu https://lore.kernel.org/lkml/162f5113-4eb6-dcea-f034-c81b9dc021b6@amd.com/

Whether this can be extended to resctrl fs is not obvious to me but I think this
64-bit requirement is indeed limited to x86 here? 

About the unconditional inclusion I would just like to ensure that the
resulting dependencies are reasonable for all x86.

Reinette

> 
> -Tony
> 
> [1] https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com

