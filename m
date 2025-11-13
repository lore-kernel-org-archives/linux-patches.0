Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31162267386
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763006492; cv=fail; b=PAC1tv2f2Wnahs8g1dcfX3WRdo8z94aeHmyYcPpHfGf5kLVaIwmUMjXsjBdLYigLoQJ8VFmXo369AYTK90IAPa1pzN0saKEvLObBoXNUO/V4gCsc6altLsbhdoO8b0JSUrUn59bg5gD4jQacKEaSw5D7vIgZjWxtYtvZp3c+kdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763006492; c=relaxed/simple;
	bh=ZVEaVjUZ5bXb6BNw3bwzXHL6GXB6pABZ+AEm6gk9o0w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TkxtkQkKcyIMouy3mK3ZtmtHh94mg8wVYbj26Zjr8yHRadS7S3SX9HUoSmdCpo8uIW+DUAq6kBWv6kefymalJvh2MkCpAKgONpXoj/CNt6dotnp0b6p8W9Y83IxOue9Y+kijY6S9HcAlOUwKImaxLfAhW4PFm6SlAx8o95pm2e4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KJcMQHvg; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJcMQHvg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763006491; x=1794542491;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZVEaVjUZ5bXb6BNw3bwzXHL6GXB6pABZ+AEm6gk9o0w=;
  b=KJcMQHvgrsjJsxlPCbNPTJaUdhlH4Y7bzUtH5FlbefKxM1AYY6p5BXjC
   ttxS/3H1IILJfCl+7dJv4Inv2vfeUvT1C5T4q63IxqYgGI87gql8PsnPS
   XcGcSz/3661vwRTQQ1IxeMQt3hABRGen+JDjbnvlrrQrtg7GLGK1gl+62
   TNi/n5uZDEA1jPLPSAckpb7M77C9x9PDJ8QB8KOdYOMLzONO9CAv5XoJJ
   GuqZzyn2FfPFOGPX8ubN/pjyanE1cLkzCF7krT38Lf+vS30Sn5T+iYVVA
   mZFKirixf1JHsqUKVZUhrHmR0Q5XKQIT9tK0BJTZMcRpjbJYsSjQ6BdYb
   g==;
X-CSE-ConnectionGUID: CIctp0w/S0qiFGSt+C5yrg==
X-CSE-MsgGUID: Qft39LzsS129Ql55Uc1UMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76541680"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76541680"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:01:30 -0800
X-CSE-ConnectionGUID: ZNPTMG6PSmaSlErVPzLyMw==
X-CSE-MsgGUID: Mub8yjCfTqeZoxIKuroo2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="220153066"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:01:30 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:01:30 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:01:30 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.29)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:01:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kcmx/GfU7KIQ9gs3F1991ruJ9eEYbZXGpLZYqvTxQUQQbCoPvQPAR86kJadAmwhcvwKh8s9Rwsrn1qnGNunqi0/oLrdsd1mz4v5V3jIvEn6rGO9MlVVvCw2KcdOcSwDDZ04FeEKcxix7MWLpOFeKmzOXoVMLCODABIQvHwlXS5rf8lXZTPjqVvUap6de4bG2EoQnq6IoIa9+qdFfb+OaIi5YnD6IXvakktaFZxAf0vdRjw9oWBelNuRe6mDr0uSLGor34wDTtE9XdpxktIoC8AgCK8tE+17ieKgqVRsZSx4nwCYkqGW1PMKuQKnOD3wKAlGxJMDhPW1YLiKDFCSg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxTm2LK7IWTIzC4d24Q4shcOhHQ+VsN+9vktQcflzCc=;
 b=ocuU35VgwhMMltQCBeTtmJe1IXQQ+XfdcZiZdj0Iiv9cvEB7VFXA7IM5/0DFOisqEf4TqApV21lPBJNV52uUfxb2FJIyRxIKzNtbvLs2K48mT8fCwU5lqK6OIj3uw8irAQ8+jq8/n54oGbBu2AoJhHNYnNTcbou0SaFTg4iHEJFikTf8kQxNCq/V+EOyjgaGZHieV+yJ/70Ahxi9kglK28rkgmGqzrq7iC0OxqRpEn5q20t7b4C3HROdu43/O6I8g6zXAmf+NDC2D61Vgq5xOoKF2ziLoQ/TI14zkpiKaBQYNXvamB721Pvt/TdF/G2ii0MdOX08ZWDld3y31DRHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:01:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:01:27 +0000
Message-ID: <ab336fee-fd5e-4203-a7c1-63f8f4c217a2@intel.com>
Date: Wed, 12 Nov 2025 20:01:25 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 09/32] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0086.namprd04.prod.outlook.com
 (2603:10b6:303:6b::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a1dda0-7cc9-4adf-dab4-08de226951de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z01QMC91dy9ObiswZEpOZ3JpTWhncnRxTDgvR3ppRmk2ZVV6TE9qZXZIcU5p?=
 =?utf-8?B?ZVo4RG01SVJHVGtNYlJWOFZNL2FxTGhIQW8zVUtJZ3ZZSUhMaUc5S2tMWWcw?=
 =?utf-8?B?WlZRK2RrbDBsaEhIRzU2Q1QxMzZ0VFpIWHMvNVdJZk40SERVM2FhYTRYWkdH?=
 =?utf-8?B?OFNnMWZiRFZvdkltUTE4UVdFeFk3L3VzRmdMTFB2aFQwMVowM3BPQS90K2pM?=
 =?utf-8?B?WVIwL3RucFRKSXNFam9BV3B2d1ozNWFQVDRJd08vRTlRVnFQKzN2NVd4RHdW?=
 =?utf-8?B?UFo0djZXTUNzbnY1NkxyNHU3SXZyOWdxRml4NURUYWViTGtUNGxoSTBtT3Nu?=
 =?utf-8?B?TThVSEQvVE1uZDhuOHlDNTFNMWhzZzZWNjZFM2JOZGdYK2hDWUN3R0NqenFq?=
 =?utf-8?B?V0xjWnNldHBxNnB2b0RvOWxCeWwyOEg3bjJCMTdNTkNTZW1pQlpPU0grbERo?=
 =?utf-8?B?N3NLNmlSM0NXSStPWjAvTG5LQ2VoWEcrSzVvTWx6Wk1xR2QybDBpWCs4TEpx?=
 =?utf-8?B?LzZETXRyRHdYSElaY2pKN0haUGFEbTNUTEZQczVQaHcrbVR2dk92NE9qSDAz?=
 =?utf-8?B?Zmw5ZTRXUDA0eUdBak5VMDk0SFVDYkl2Q2FtOHhCMFV6UFhMQmVPUzIxUkpt?=
 =?utf-8?B?b3FEKzR5Y2VmVjhpL3BoVjF6Q2grYm9YWXFZM3hWRGNZcWxhcWl2MlJvUDNI?=
 =?utf-8?B?N0xRYmVtTWJkSEdEZm9ZektGZmtrY0VWd0JVbGo3QXlCMFdTRTJGbDNEODdo?=
 =?utf-8?B?L1ZsVHhGZ1VOQzlYemgzK2ZXUkZRTk9JOURGL25SeHQ0dXk2eG9SVnNuME92?=
 =?utf-8?B?d1hUMzczS0V0emxhdUNhSlJLcXllSy9GdTlKY3UrcGtrK2YvQkFsaXdhMmpx?=
 =?utf-8?B?UG03YkdOQVdxa1NxWU9ob0JucUFwQkRPSHhsV3ZQM1R5dmJNOG9tbUMzajdZ?=
 =?utf-8?B?T2ZzNVJmSnNMT2JrY3NqK1lHQXN3Q01qUTkwWmozYmMvSnM0Ym5kb0U1TzVi?=
 =?utf-8?B?dU41eENFSjlvMTNnQitPQ3dPNEJna1djMjlyYkdnbFRjQldzOTJueVpHM3oy?=
 =?utf-8?B?MzJIMFBWOXdUcUV1bUxMYXVHOW5Ea1E3UW9SVTY2bytIcjloVGlLRVZabUR5?=
 =?utf-8?B?bTdtdTFKL1M0VnBQK2lkSW5rcnRTSnROK2dQYUNJOWdqcjVmZDZVbC80b0Jq?=
 =?utf-8?B?dkI4ZHJjKy9zRlVvRzZYTUZGeHdwNGs5UXo5ejZsNVlYWUNvTnZ5TnRTK1c4?=
 =?utf-8?B?aDZTSTkzMVVkTkwxK2lVa282YkJBNGw5Z1F5aXAzRkJjWDd6Q0xwRFV2b00w?=
 =?utf-8?B?b3NRSjNGMnNBSWJUT1dFTlFsL0ZtTlNCMmt0M3U1TFhXZlNHUmZtRVFiVDNq?=
 =?utf-8?B?c1pIK1Npcy9ZTk1zNUJST2c1N2J0aUJ1NTFDWEhQMWZzOFZNRVNZVEpobTM1?=
 =?utf-8?B?NWdpSENYenJSOVNnYW1aRVJRQnZSOUlTM2NCSVVJTWhISTZ0MnUxSjRscmxs?=
 =?utf-8?B?UHptMDNKSmdFWk45Z2t4QjIwTjVlMyszT2VoYWtlZ0IzVmZNa3NabU1VNnRj?=
 =?utf-8?B?KzN1RWdRNW8wUVJUZG1OVjE5cTNCM3puWEhKSDNTYWVsbHptWkpNTFV5RElj?=
 =?utf-8?B?M0pMK3dyL2lMMWhmMndmUTl0VnZYZWM1ZEFpNFhlNXM5WXJZSXpqQVJ0TTRi?=
 =?utf-8?B?YjcwdURtTDBIcnE1UGk1ckxIWW9XRkpnOVcwdW9PcXpDUzNQSUgzb1A2Q3FZ?=
 =?utf-8?B?THhhdDI4TDdoRnVkYlMvc0xBT3JuR2FtdTJQcmpjeGhoNkt0QndhWjNQOGJ4?=
 =?utf-8?B?R01JVEllTEdUbklUN3RQVXY0YWUrSllXZk9iSERqczFNQ2xzRmlrTFFaUitB?=
 =?utf-8?B?c0FaemtiMVBvOWRqK09UM29QTDNROXhiWS91RjZ2dXR3bVNETHlEREU4RjlR?=
 =?utf-8?Q?XYQh7WNBfwY1rjHdZTscixJzSe+R3q8D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2lkdHNhaVFOWHlydDFUZi96MWFJWlQxMzIzVFZuZEdDN0Z0Qy9IVlpzYVhS?=
 =?utf-8?B?ajZic1crL1UwSlkzNzljdUxheCtsTWUxbjVzYlUwZW5pZHFJdkdDVjU3d05U?=
 =?utf-8?B?aEpEbmxDR0lIbWdhbVNhdEJyV0ZOMERGeVRnLzBsc0xGdndlaVJqdXFNc0NC?=
 =?utf-8?B?L1lSaGpzd095cFhzcGpvM3ZpV01jK1JrYkRVeTFjUnE1cmFCUGRkREplS2xx?=
 =?utf-8?B?blB1SENFT05peXlwSFgyUVhBZGk0dWhrMnVEQitFclE5TFBNb2NYVlR1Mjls?=
 =?utf-8?B?eWk5R0dyZE1KQTV6VXBKNG9PaE8yK1lPa0hWTzhiRGliU2xyZHVxM2Z5VTZB?=
 =?utf-8?B?N29kS21ZbmlldTdLUDd5VG1uU05HT285M3pGYnJQbm9iN1MrSG5wMmZMMDZx?=
 =?utf-8?B?cGU0bi9CdXd2bTk5M2JTU05FSDVhTzJtYmppdVIvNHArNU1jbDAyeEk3a29V?=
 =?utf-8?B?dnZjUHRRSmx0b3oxbUZWREduMUFtQXhjR0ZEUkU4SzAySXowOXdzZEVvd3Jx?=
 =?utf-8?B?akI0ZHZoMkRwOS9wRlduL0NYZ2xrS0hsVzl1THl1b0VlUmRtOGEwcGZaS3hl?=
 =?utf-8?B?aXNSeklSdTN6UUFXUUR2dUNDZkJCUXhlcGh5VVVZcEY4M2hGTmZtYzY0dTVr?=
 =?utf-8?B?REhMS0EzODJBRHh1YVoyZXY0T3poNFhKVzdRVGluZ1pmZmo4bEJHZ3NrTExX?=
 =?utf-8?B?LytnQlIwemZ2MFhKb2tlOW5ZaGE2ZjVham4ybXR5RmlndXhpOVVrUGU2Tmx1?=
 =?utf-8?B?MzNZUVdCMWUvbFBzOEFXTXVmckFBVDB6QTBsYkNpUEVVeWxONTFSS05wd2Yv?=
 =?utf-8?B?d01kMW9lVEY3VVpPanRLK2FLcWFMVHpmaGxFNnROK01MSlRIcXJ5aWdhd3Ft?=
 =?utf-8?B?bm1ETDBsMTFSTEJxUFR2ZHNBbjlITG5XanFMOEU5Y3BKZnB0NnVKN2RadFJN?=
 =?utf-8?B?d3c1NkV4U1Y4RnNxV1plQU9lSzZzYUFPSi9LZlpaSzdIUDZZeTNpMjQwa2xu?=
 =?utf-8?B?WW1pTlNTUGZYZTI4U3hiYmhFYXlVbVFrU0dtVUlSeGJib0FqMmlaT3JuVlNI?=
 =?utf-8?B?Y1E5QnE3Z1JVZFBBemNxMldpcVZHNmxGSHlKSHVDOHBHWEp6ck1GTklrYUZm?=
 =?utf-8?B?TnFRT29UMEJmODhCL0lsZVJWYkpqK3YzYnRNVjJkN1JyQk9VMWlNbmJCWTlz?=
 =?utf-8?B?bC9MMTBGeHZnRTg0UTY1bHNSVTBUUDluRWFsblZGUERXY2NtdmtIU2JVbzdq?=
 =?utf-8?B?bGJtdE9Sc2dlQlNia2JWOW1VNTJpUVphRlAzY2doZTZwUUoyT3ZJa2ZBVkFx?=
 =?utf-8?B?REFCRWF1WkJWL2RUU0VzMzhwSDRMN3hvZy83alhGSGtHTlNKSkhLeE9Mb0o2?=
 =?utf-8?B?cENSL29YWUhyUWlxQm9RUTRUd1dvaHVJc3prTktLY0FIRUJWMUtZM3djeGxB?=
 =?utf-8?B?VWlUd2RXcTZWcFcvdWtSN3gyWEt1NVVqS0ZYV1VHMUpRT1h0NVN6WTN5VTZP?=
 =?utf-8?B?MFdFb0Yrc1lyTG01NXk2d3ZaTFd5K0pINFJJcXhRdkZMVjlBZ0JReTdlNzdT?=
 =?utf-8?B?bmhNTFh5djJJSVQ3czJsWXY5eExGbVhvcnRKU1owcFByWFFkV21QeTFlbVN3?=
 =?utf-8?B?RmFmSHlJNXU5ZXBiNlVVWXQ5cEg0Mm13aG5UWno5MFJjcXVUU2JEekRRSE1D?=
 =?utf-8?B?R0RtM3ZjZG1zdkhqRGluRzA2K2M0Y2J0ZTBKNDdKOXFuZmJubkpPVUJIVDFk?=
 =?utf-8?B?dFlBc2RBbXJMcmhxeXBmTUlYY1FwOVBwUndCRnVUSFBKeitVeHlabnZMa25a?=
 =?utf-8?B?clJNcTUzWm8rd21UcjNSblYyUUR2MFRVWS9YaEZuSFlPcHhxS3oyRHFJeXM4?=
 =?utf-8?B?YUpMUUphU1BiYnhJN1FuQ3FhNWVGQUpiMWNCeUhEM1VEVmdPT280TkFnRzVB?=
 =?utf-8?B?QUhsZHdFc3RjbzhXYWtkRWlEYTFTbWYwYXlrRUFzQnpZQnc4WTRQdktveWdT?=
 =?utf-8?B?QWFHbmFVMllJekRPeHRTWUdPOTFlMzhXWHhmQzgwZncxZXFFMHBxd2wwQmNh?=
 =?utf-8?B?UnlOQXlFYms5OHpqQVJhMzR5aVM3WHc1KzA4THA1VmNNRjZRWisxR2dVOG5M?=
 =?utf-8?B?ekJYYzgzUGNzZHUwWmYwWXk0clMxL0RTQTRaY1F0MHNLRnhYVmx4Z2RIOVNo?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a1dda0-7cc9-4adf-dab4-08de226951de
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:01:27.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPwMVFyJ4eQmUwbJ1L8JQOSFUwA8ygz5ez1ndlOztbeZU3XqVjUmWuuXC2iU4zy0dPcpndsYgRHU1HoA8/kG7b1bkmcEIl/QTNaFy7V5hZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> With the arrival of monitor events tied to new domains associated with
> a different resource it would be clearer if the L3 resource specific
> functions are more accurately named.
> 
> Rename three groups of functions:
> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Initialization/exit:
> rdt_get_mon_l3_config()		-> rdt_get_l3_mon_config()
> resctrl_mon_resource_init()	-> resctrl_l3_mon_resource_init()
> resctrl_mon_resource_exit()	-> resctrl_l3_mon_resource_exit()
> 
> Ensure kernel-doc descriptions of these functions' return values are
> present and correctly formatted.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

With changelog line lengths fixed:
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
