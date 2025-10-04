Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D01AEACD
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759537613; cv=fail; b=YZECeqBsxrktbNdn1s3ibBWej9GCn7z8SRqCCSnUYKW8c1ddH74vvSRsU1i8k5bwKSnjn46oDb/+1qpfXBULkme/rJwf8eSZuyBGu2ivilj8GnRcIHAnS8NakBgU13lTguN5/457/CCXtjRIY/GbuUeT2TPgncUKAeZupP8feT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759537613; c=relaxed/simple;
	bh=2UOWGVO/bCCExyx78vmSkp+7h4WvC2fKXhiNdsMtnJA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gYHsBr6u2WjR5ZZIk7bOYNuv6VLhxtjYtJUnKWHDtxQIa6zk6QePFZSi6rxzMTJvxKnDuOX/7AGCqHgO3Tr37AnGMHhCn+IaneZS5hCehtLA75D/OZsvrlFnRVbfuyxwcMnWGLYXvhCAMdN/GKszEUoD3vP917i7H5SYfQ5PHgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ui7aDF6I; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ui7aDF6I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759537611; x=1791073611;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2UOWGVO/bCCExyx78vmSkp+7h4WvC2fKXhiNdsMtnJA=;
  b=Ui7aDF6Ie4M2poKnDEByF5MjdjeNz9ywXZxIJRMNNziz/E79rREVVoqO
   GdlJInoXlDrH7FOZY5kuT9cuAd1Sd2Sv1F3JTyrEWAny6ycz8ifL/zOfU
   UWHM1PpkQDHKuHKZs8jqNdbLPLGuDxW7t/uXhmZUeiBiF55yw1Lzhlk7C
   dEMrze37JNPzGxZ5XumQkMyl9WIm1GvWnhreEJgwA6KEHsuhTNaSMXCK+
   LUylxVnJOq3yqdME4sFsNN1ov9qrOhL2o0u9SIILWC21u+6tBl/LAe0FF
   iL6viuo7dMmicODkr8WbdHLe06QMgA2CP2qp8Cw34Cc8YwzMrSxURNslq
   A==;
X-CSE-ConnectionGUID: 01LPMaAJSTmKR77SSLcuGA==
X-CSE-MsgGUID: sVsjPQC9RcKid3+QFwoVZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="49372966"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="49372966"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:26:51 -0700
X-CSE-ConnectionGUID: o1fxhkdPQjGK4ppOv5O7+w==
X-CSE-MsgGUID: IirKGDcYS7us497Vrnk8Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179834658"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:26:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:26:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:26:49 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.64)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:26:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goq4zx3Z5eJujhS1iGZ1GuVsNv7Kh6+XNj30mHq+0HtdsNMY/Z0EnyR521Lx0TRFQRYQbvlGA9FVdz8GmxaQQ7yv3ePnuAqCMIpI2KSnjc3IWR33IIIWjsqmh/JBGYu+TAxpGtdgEcIO6qTyRZDXp0HTZ70nQBjGoJcdvg/JDJI7JAKD6jhFstjHHl7/+ziGkwjKPRYyQytMIN40RFPQz0uFfncofYhnddCThQZvypg8Ehm2tJaaQNzNklSuoJ8vYyTqI5eiyk7yNdmZPRwSTyEqJxLu8aXW+hvEHuuI9xd3/H6nb241wiAyNNwD5jV0Y2v1vLcgU6lMjpvtjbIeug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTrzw2/aJXFf/sseR/12MpKDVAczkZ3S5ywdB+4FRnk=;
 b=Cc9mIFrwOdiur/yrdccPStMUHSGlFkjJRfauy0ht0jXoho1FiRKnUTPg9j7tE7L+uo7kY7i2xuWED8AyEZsmsyHXjHyLkYwW7CrQdfBIVVMf4yHMbWkjap4+WxMLm57RVNZWwa5yeRBhHeK7aAEfdWv6zspLtrK565tCK9JSuoZsLzU6ot3xnBEFRSCj02A3/HRNvmvECSoWkqsgNdTLGyJyOyB3LddCgnNFcXMtyaArID/ITVIQW0v7tdIGjFqll/ejWcxcH/JejkdCMv31GZIagxD0WW3XVCpCCCR5AHwEAbiGarvJc2ueYG9mFeDcEdyyWbIwOHj2Mn1hQWfMvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF990BCE628.namprd11.prod.outlook.com (2603:10b6:f:fc02::3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Sat, 4 Oct
 2025 00:26:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:26:47 +0000
Message-ID: <105e491a-475e-4d6a-a1cd-88d500d8fea4@intel.com>
Date: Fri, 3 Oct 2025 17:26:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 31/31] fs/resctrl: Some kerneldoc updates
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-32-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-32-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF990BCE628:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8edeb4-221d-4ad9-8686-08de02dcb45b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VkxMMi9EdnZRY1phV2xHeWkrcXEwbUVBc0RXWUdFMytJejdkbEZjU3FsTEEr?=
 =?utf-8?B?U0Q0UnpKZXRtUnhEeVRrMWc0YVk2RXNiWlduK0lZMXBYQ3E1c3BKRjJMQXBB?=
 =?utf-8?B?ZTVlY2F0NVVIL014UjRxRndta0NYM05uNjRmRVViR05OV1Z4MWpGUlJvTnBM?=
 =?utf-8?B?YW1oZzNzWXRjVXVaOXErRThHUTJ2NWFSaUxiVVNkejhlV2RsMWpnUzNEbmU4?=
 =?utf-8?B?YnR3a0l4dEN2bHZ2djdJbE16clIweU9oZ2wxVVBRUVhUK3R2cVR2Q1FHVUJl?=
 =?utf-8?B?WjJaN3gybURtcDQ4aENEN2FtbDQzRFlBNzFVRzQ4cG4rQmVoVXJHWS9LdUhP?=
 =?utf-8?B?cTlNVUN3WUpwUGY1ZUZvMFFyRXNsbkNlOUpEU2JDY0tqR2FVKzdxbE1VWmNh?=
 =?utf-8?B?THlKdERyWjh3SHdnMWRuZ3FsNG9TR0NkVmtPcitzaDIxK3BUZFNzRnBBQXlZ?=
 =?utf-8?B?R09kejZnYmY5UFZkdmtTREFGTU9xcjZsTDR0TTF3eUViSDQ5RTJ6Z25ndDNz?=
 =?utf-8?B?cGY0cjhKcjZJUDNxYWlsS2FHNkxhWjdsMHIvcmNVZ3dXZVlaSjVwNXFzNFZR?=
 =?utf-8?B?YUFXaFlUeWtQc0xpWExDUkh1K3BxT2dTSm9ncjJtY1pVaVEvUXhhVlFqTHRR?=
 =?utf-8?B?Q0dyak0wVy9RSkVZRDFvMmhHSTRXY0QwcExrNGVCNWZQd0FZVjVtSGdUZ25B?=
 =?utf-8?B?c1NqRXRTMGVLeG52WlpqQXZsdFBnWVRPNWxUTDJwd3FGTy9EL01sN3V6akpw?=
 =?utf-8?B?STl6THdPWVEyMXYwU0NkdVNJa094ZFVGZWtPSDR4Z3ZYd3FycWNBenk4VlB0?=
 =?utf-8?B?Rll4OVRXRk81VWtPdnUzUmliN080SjEyQzduT05DTytTWE5hQ1B6SHBtdjY1?=
 =?utf-8?B?dVBGYVNMdTJtTkNBVGlmbFV6aXo4aHA2Z0d0SVhNd0hDNW4zdmZwbmRzdXB6?=
 =?utf-8?B?bkwxc0o5UnNkb1VlN0xEMkttTWJKYk5rV1lqV1dGY2NZNmt4NjQvY0Urd1lO?=
 =?utf-8?B?QnY4V2oyQ2tmTDRmbjlkTEFoSkJ3V1prRGNUbVhWYU5vUy92Zmp6QjRwcUhz?=
 =?utf-8?B?Ky9OZmtlbG5JUGZFd0h4a0pVSkUxaFo4UFZRTDE5dWxwekpTblhOdS8waFBB?=
 =?utf-8?B?d29TTDBnMCsvY1hVN09DUG44OElrMlFiVFNBR2cwK3BXUU5VTUV1K0VPZWpy?=
 =?utf-8?B?RHd1M0E1OGhsSy96N0JnMCtjUTNiZnI1eXNib1NmZ21oaDNUTjdudng1UGNW?=
 =?utf-8?B?aHRoOEUrMWNDSmF6aS9LWlVEK3piQUZjWWtEck9KY3FPM003VFcvRlZpNE9O?=
 =?utf-8?B?SFY3c0ZLTFBHSmtib3FteWJKdTdIZjEzM096SU1FOUFMOERqL0lQTFNFRDJM?=
 =?utf-8?B?QmIranl3Zy9rUEhZTXptd29lRTJjQzZSS2hXQ1czSTFPdkMxRXpOMXFpMStr?=
 =?utf-8?B?dGJWb0NCTHBmMTY3cVBIeEJnM2V6T1NhVDVFTDZVdVhwL3JWNFBrUGJMdktY?=
 =?utf-8?B?dDYyVTl2Zmx0cGNBdklhT1YyL3dnUEEvUklxbUROeitsZWdUcDRsL2ZPcXRR?=
 =?utf-8?B?T1cxMGxYVlhWc3libWlnNjQzUUdWR2xKZlQ1bVNNMlJ5ajVrRU9UaHkxOXpi?=
 =?utf-8?B?RDdmZThPVmhBNVFFeU9Eajk1eUVxTUw0Q0NSS0J3aklJV1ovWitmKzdRcXNH?=
 =?utf-8?B?YnpKL21pQmlETmdJdUt6ck00WXRsSndTQW5KWG9ESy9vY0lJcWxGdEJsUzlw?=
 =?utf-8?B?WGVxV24xTnBMam1HeTZoYmlxNlg3U2hmRmtia25LY0hoWG94ZGJvSXdka0k2?=
 =?utf-8?B?Sk9xNWpyNzFGeFp1T1hIOUpBWFlrMHFGcmZPb1BxNGpOT1MwMzRXakRUQ2dt?=
 =?utf-8?B?dE5kejRXTTNDb09ackovRFIyZXdxMjVZQWlYKzUydXVVbnFPVzZNTENaYU5k?=
 =?utf-8?Q?Aa5NbSjKfiJ9/vz505+hVB/0MBqwdI6Y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z01kVHZTMU1tNXBlYVAyOU1Nb0Zsa1VuZytydVlqZlI2cThRSDlXdmVianVy?=
 =?utf-8?B?NFhuNjFQMzZhbXZLV3dLRW1MaFRncms4ZFdWOHJQMnQyeGhlbmNtUWRlRnkw?=
 =?utf-8?B?cWllbm5iRTU1VlRCZnZQd0w0N1VqWmVoTmpxVzh4ck9CVG5tUFNrTGV1cFJh?=
 =?utf-8?B?VHhVYXRPWDhoQkMrQjJKRW9NYWhJazBwT0VzV2VFNjBCNHNkTDlKYVZKRWlT?=
 =?utf-8?B?aVdwc1BXZDI5Ymd2SFVZL3VBM1poSUxGV0UzcFhkOHVEdFN5OUhlY0dmeEZB?=
 =?utf-8?B?WHUwSjdEV3JYaXNmQUt1aUgxUkxGZ1dkWGpoR0k0azlUNEpuUW9FekxaekY2?=
 =?utf-8?B?NWZrbEZHTjRhUDFlWUxpUWhwSS9LYVRVa21QeEIxSlRROHVVOWtDcS80MXly?=
 =?utf-8?B?ejBlS2cyRnhEdkhLK3NHeXdSZTVxWm1CTFhQd1p4akplRVl4STd1S3ZBeFZk?=
 =?utf-8?B?eUxNTjhzZkp1THhVYzlTRHlKZHBmU2ZmYzdMTVN4dnlSOWdZUHNpQkxPSDl6?=
 =?utf-8?B?TkdidE1yaXR3eUZGelQ1c0ppQzJvdGo2S2wwMisyNjNwK0MwQmxRQTZnTnNm?=
 =?utf-8?B?aTVOYjFLbWdETXFFYzdHdHJVQjl5TkNmYXMyVUh4UzhIeWhjUjFCMStaTWIw?=
 =?utf-8?B?OWp4WFFGeWM5RWpnUXAwWS9saFIrRFZvNzlXM3RoZjh0TTRFeURMYldhTmZi?=
 =?utf-8?B?cDMxZis4U1NBeDVPamVlamc0ajlWZXNDZ2tKRG02TGEzVWk4QW50YmJLZGha?=
 =?utf-8?B?dy9uVEJpcHVDc1M0WDZxdDZaWHZRaURFV1VqZFJOd2cwaFAyOWhrMVJrV2lt?=
 =?utf-8?B?eFQ3RzNZSWR5UktNbUhWdFNJaVJQZUc1QVZJMHhxTmdGM3pBVWtSUDJ0RGt0?=
 =?utf-8?B?SG9ZalFUWUdxcjNhaGJvMGFtMGlDUE1GVEZiUUFRUUtJY1c4SXROOTM5QVZW?=
 =?utf-8?B?akUvWmh6UkwzZllFcG8rdk9wdVV3ai85eTJHYUs1Skt3WXE1NzNramZSOS9M?=
 =?utf-8?B?SC9zbDgzZGFQazdJUGxyaUNTZ09lZHJ5WGNWV1k4YWx6aFljZjB4a0lxUjZj?=
 =?utf-8?B?SUQvdUU2Y3dSQU53M0lUOHo4UG1DL3k4dWhqaExQMkY4bGpJcDlwc0Z2WEM4?=
 =?utf-8?B?MFI5TVl2SXRqeUdDRFp5cmY5Z0pEWXY3bUZ2QmwvelZhdFV3dFhXREdMRS9U?=
 =?utf-8?B?UVNjMUF6V0p6cks0d2xRUTRWQkZsVFdWNVFpMDdhU2tPL1BtYXhkQnZ6c3Yw?=
 =?utf-8?B?aFVmbTJsdTVwbjJFM0FzV2hRUDFaaVprK3lFVUhXY2EvSHhDa1NlS0VRNHMw?=
 =?utf-8?B?WEZTaUZHaXJwOFZrakdqcWVGZkhZdnV4N285MzN0eDlxMTQwTTB2K2R6RkZ0?=
 =?utf-8?B?MEp3SUY5M29sN2gwSG9IdzhtNThuUFVDSGZaOFkyVG1lMkh4Y3IzYk9FOWpD?=
 =?utf-8?B?TkNHamE2bXlQNllkSVE3Rm9zcHRlZy9INlJ5WGg1TStlc2UvM2M4U1h5bEtX?=
 =?utf-8?B?c2I0QnFCZkhuZGxFa0xhQ1RCOFN3YVdaMWtJdlViTUdFdi9vYkdDOWZta3dX?=
 =?utf-8?B?R284YXpUdVRPaHdUdXk3NHdySkZVc0s0dFYxUG1iUWRobkhqVEFTY04zL1Ay?=
 =?utf-8?B?bG1qbUR0MjRLbHAwQ0QwZE1IQ0YvcVJxRnBiVlRSa1Y1ZUhrZmtTVkhXeGtK?=
 =?utf-8?B?YXZDUWR3cG8zU3lLKzVSYkhubSs3bkhCekpxdGlQZUV1QlRNQ0NhaWhnVmht?=
 =?utf-8?B?WEd2dER1Ymx4RjNYamhlNGJxeWh0bkZOcGE2U1RpQVVqNTNsTHRkMG05Nk5x?=
 =?utf-8?B?bXpsV2FyRWttSTVvcXNvdUJIQUlGQlU2eXhJblU2WEErcDB1MTI5UTVGdGVZ?=
 =?utf-8?B?d1NsL2lkUUlqV2JrcDVBdjZaR3B2ckRpYXdWZ0xyUHdESGFVM3R1d0pWNnUw?=
 =?utf-8?B?bEQwSVlSSk5tamJTd0JCa25Pa2R1aUFxUWFycnpQRjFTelFiaCt6N0lFeG0w?=
 =?utf-8?B?eFlZT2pFd3NWbURTaGVvQ3RrMEE3K2hTL1BUVGtMQ0NOb0xGZ2Z3WWQyS05G?=
 =?utf-8?B?TjNObkdVY3Ywc1V3d1duRGlyTnF0Uis2T0hNVmIrdnNGQWFqbEw2am40WmlJ?=
 =?utf-8?B?Wk84eGtYZG1DTUNERTBPalVlL2JMbytSaXRHdVFrQ3doSU10YUQ5WWtLUG03?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8edeb4-221d-4ad9-8686-08de02dcb45b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:26:47.6563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wJETSbpUo0kdRbQcip69aQxSOoMXvJTj9KnIRTKIb+V9Wlri2kbIvxd5StxV3vHpWe9Et0NeGyHUmXlCmwsEj3Ghirm6jcmVqs1YmDZdwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF990BCE628
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> resctrl event monitoring on Sub-NUMA Cluster (SNC) systems sums the
> counts for events across all nodes sharing an L3 cache.
> 
> Update the kerneldoc for rmid_read::sum and the do_sum argument to
> mon_get_kn_priv() to say these are only used on the RDT_RESOURCE_L3
> resource.

This is clear from the patch. Why is this needed as part of
telemetry event enabling? Perhaps this can be combined with the
unrelated SNC warnings found in "x86/resctrl: Handle domain creation/deletion
for RDT_RESOURCE_PERF_PKG" to be a patch dedicated to addressing SNC
topics related to telemetry events? 

> 
> Add Return: value description for l3_mon_domain_mbm_alloc(),
> resctrl_l3_mon_resource_init(), and domain_setup_l3_mon_state()

Appreciate the cleanups but please have series start with cleanups instead of end.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette
