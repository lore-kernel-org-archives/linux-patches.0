Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51158261B83
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527116; cv=fail; b=WXFecxNO3sE3w3u23HoU/FZAESjxVeM01Fvi4Ahm8jARME81pIh4WUjKK5IRHqIYqnuUxJjUYXMUbZ7AbiFFPnvC4BVRkDmHPSAX2mbMvdZGVgAHF9js2hETWaQcvmSF69AjoBpFwhN/TgDImxjSS0xaDeh0+q2PwAoI6Ds5ZXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527116; c=relaxed/simple;
	bh=Yf1tGDA3V5JhYyFZ/GNwZaDFlXcOSM+E8kSsSv2XH78=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vDyWWuZG9CJnrnMMKWM7RkJ0YAd0DTkiRtLbNiwikI22/JKiaA4yC9UXFVaLIVK1bttAE3fUnxs+TVnTHAvy45krH2YUiNJv7MINgsAYuHVVFaRiGDLIVSV8JCI2Wev14iDA1UFrz2TOgEXoSZoYycm3ICt4epqGE87NS0FADMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aD6nl+Qx; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aD6nl+Qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757527116; x=1789063116;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yf1tGDA3V5JhYyFZ/GNwZaDFlXcOSM+E8kSsSv2XH78=;
  b=aD6nl+Qxyqe+W7iQDcwBfK7Fgy7j96F0GcPrmFat+aUjMYgqeOQzTdGV
   34ZD64J5ml2njbAhgqy+mDRxsg6XqS19fF9DGcFGj9LHV8bdkw55yImjn
   jYxStmfFk4KgOfO419WTkBu8G86sa2rfu+3GHS5sYencEzx09nN/C6BWA
   vp0xedmV950atCKALA2EsuiBMmNXe2u1YIax22oorC4FFjckiS5/0I+KI
   9e04dv9eLeCQ0MhI0ZvUmdg6KY/IUCHkVGI6U0pv/5bB5AAmr5URayk+s
   tLwwzPCLbAata7eF1m3w2nVeu3k8RFcUqA1VwNg7wDtYO/Chlgb3fa8uW
   g==;
X-CSE-ConnectionGUID: T1aWr/hZT/m2+x+ht6QbDw==
X-CSE-MsgGUID: eZLjSDDRQAerf17yVWc8Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="85292528"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="85292528"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:35 -0700
X-CSE-ConnectionGUID: fR3SUV5ARE2Fa/wXAKQJ4w==
X-CSE-MsgGUID: +ipRRK3ARySCLc9dLOgzUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="197144499"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:58:34 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:33 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:58:33 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.80)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:58:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IfWCyYuggIgYLUxl3jum01vQ7ePLJTK2ovI84p/MnzO8cjE/ZvD2iwophrgQ5ZwhUdom/2F7iMvJT87VJ2YnpD5G1EsgTdcTjrnjuNOq2b0PB6Zv8fFKXggOfhuCPFKgAf5AZUTXfkW/jKc4x4z4wSM/bRO0KSMliCGSKlKsn/mWzy/WfFwCps0fVdyxh1K1+EsnexX9D7KsMM11aSvd1xaaq9Ao1fJgvWprI2OZkjkHJWeiFlH21wUdmuKFj/+fgzo5dBqkknk3n1Ab2rvmOa6pZWvO10mBrSTIN6tSCD/zFOdLIN/5yveJEpEJ4kn/45qZOT8tQvThzVRsrstlSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgOcDeIsPdFOqbSeBOn7Dkwmq1DweCrvD/dOh+pE/kc=;
 b=JDogU8TVKy0ioC2JeuvbfdKhTy13wCgVlYoHA96G9L/TZ0MT75WQBfyj/4ktteKceIbjVBNxn0Zc5BYR2h4jYnK2qQO3J99SgW8lXtsyZwIJamu2a8SfTtbf+CT1BytetmLGRZbKwIGxu/O8SQ6S0stsxYhV4gmRW+1d+Zkd8pq/rLxfbv6+Bu1Sh3fYSmRqzRV8bEHC+CRH1VdOdC7ss/+0TcamvpGjPfY9GwECzSz9cpb30NydQKO/6odmSXP8rEssJ7mmwN21KkG+eU9VJ5Mk8rGydoaKsqRplF5RG/0vYWH4Ta9gWWYQCX1bglwtwVu7D4+U3K4QZrLUEfsZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5937.namprd11.prod.outlook.com (2603:10b6:a03:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:58:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:58:29 +0000
Message-ID: <fd1a7cb2-a5de-4e66-8c70-6ec6934d8e9b@intel.com>
Date: Wed, 10 Sep 2025 10:58:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-29-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-29-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:303:b4::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: c215b425-6cb1-4855-1260-08ddf093a644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cEtOckJneWNmYkp0N09lWEV2VjcvRjc1YkkrL0JqZGdHcURJaWd0bVFlQnJO?=
 =?utf-8?B?WkVJNkhtRVYvQTVnMlRWR0ZVcmh1V2hGQWNOYVU0UXMzSGQ5Y1JvMDI4OE92?=
 =?utf-8?B?V0VKdUVXRld0NytBRlhYRE0xM2p2UEJNMzl5OEYvQTZwM2dYT2hjSUZyWlIv?=
 =?utf-8?B?YWF0TGFmQVI5VHM0M1FWbFRFOHNGZVgxU1dqdzFQcHowOGYxZll6TmxmKzBQ?=
 =?utf-8?B?UUtscnM5REFuUHRoWUZqSWlqSCtLL2JsOHlON2tCazJaM1YwUzlITXU1WHIv?=
 =?utf-8?B?a21QVGgwRnJFeHBCeGhhVE93L3laaHJtenFvV2ZxU2Yzbm5SU2kwUU55bzBC?=
 =?utf-8?B?MTVpWE5kMGRxazlwWGVDYW4xRlRieVJIdVg5dEc4VThQRExGUXZlVDBBR0FC?=
 =?utf-8?B?WHhqcWxvSjdEN0dHQjB0a2hOZWkxZTRRK0t4ZVJ1dGJqSGdDaGdoZFZyWlpG?=
 =?utf-8?B?RVJjSFdTNldCeURZU1JrMGFLK2xCdEEzei9CMFFXWVpDM0hic2hnbDlDN0RB?=
 =?utf-8?B?QlJqVldHUHlLQVRQbmxVNTl0NTliNHpWVFZYMmxESHRQQlFETVpIOC83bndh?=
 =?utf-8?B?RjlKUEV6WHNYVHMvYyt3R1hHb1ZZSHJhYlJrQUNrWDJXeW92RnBPQWlJeHg0?=
 =?utf-8?B?MXBlNnZibzJOYlBjVFJXQk1haHpOYllRZlVuQU56K3o3c0QyUFQzaUZOMHda?=
 =?utf-8?B?VllLTTJVRStEK0Y0YkZJY3FOMkQwZVR0bkphdHhCMG1YNGZBV0tMSGNTVTY2?=
 =?utf-8?B?R1BzWDF3SDR6SlBlVktiNkJUNDdUUXJ3b0xNd3dXZTU2K1Vza2pycnNHVm84?=
 =?utf-8?B?T1cyVlBBdXpwZGl5ZkJwcWZkOWRtcHh0Z05LVE1xUVp4TXZlL0ZCbGw1ODYy?=
 =?utf-8?B?RCtGdnpmOTdCUElUMzZyUGcxM1A4ZjFRajlXNEZQVytkR21SQVloc2MvblVL?=
 =?utf-8?B?dStnYzBMb2NJMThBV0VreFl2U0haS090Rm1zVnl3dWg4bTdDdUZwSXlnaGZR?=
 =?utf-8?B?VXJYdmlOczVvTTY5a0loZ21sM002aXdodkxtd1hmVnY2WTNwaWt1WlliSXRL?=
 =?utf-8?B?N3IrdUloVDVOSmhVaE1jekdzNmJMb0RkSVlvcWF4c3p0UnZ0eWx0NkZyV2Q1?=
 =?utf-8?B?K0VwalVwNzVkVzJlbHRyQm1GNWQwRWpOL1lrcFFYcWwzYVBQUU12MjY1K1FL?=
 =?utf-8?B?MU8rZENHTzdmSVFTS2dIVDZaSThWTmJ0SElSaysyT25oajQxS3dXNWNZdllT?=
 =?utf-8?B?Rnd2NDFmeDRlcTFDWnFXM2hlNkVneDZKbzJpdCtCSCt5VGV6QUVVRkEvMHc1?=
 =?utf-8?B?VXV4dWVEYXZoTERiZVlQWDdRWlBqNmtuSUNpdHJNL2h5UC9OMFAyRHJud2hI?=
 =?utf-8?B?YVB3TlRqajZrOW93TWJoQkZJL2hqRmFNL2RZVXpyRGtnSGZyVHhaQ2hFS1R0?=
 =?utf-8?B?eGI5c3hLdzNvcTNkNVFkbThsRllKQ3NNVmNiVERjTXlabEFEYU1xbU5Ta1lz?=
 =?utf-8?B?YWlGZFFISUZsWXpGdUovdWpHbFVrZXN3TG5jVVRaUkNOYmpKQXc3RVVJb1hG?=
 =?utf-8?B?eTZBaFYycWFMUTRNUHV2NWtFT3U5OUhOYlVLV1ExT3NjbkNEQjc3Q2pJbFU4?=
 =?utf-8?B?MjVTeDRSck9YcTNadkhRbUp5b2Q4QnpwUUprTDh1S21qN3lsOE82RXJVK1c3?=
 =?utf-8?B?L2o3cndYMkNsRVZYaEJIakpwY0lQcnd1T0wyK3VaUHJFays1M0lZOU96cENq?=
 =?utf-8?B?L0F2T1Q1eDRBeHRmZlJmNkVoeXZ0R01YeEZ4ZnNPb1lrZkNmTGltOFhpMzhH?=
 =?utf-8?B?amcyeDZ5NldCSWNydEdkbUN2SWhKZ0VwRGtZTFdZc0VkZEhBRFpRU1hhaHJD?=
 =?utf-8?B?a044Vzc0ZStacUFwYVc0cCt0V0lTMnQ1TlppVWs2YnpHRWozc1RxWnBVQVNo?=
 =?utf-8?Q?IYZ9nMpbsH4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmtwV1B4Z2NOVHZzVFdzVFpiVGVkUkVoMXc4OHltRkVuVFE4OHFDMUhPYnJH?=
 =?utf-8?B?RDhvUWxveG1vSk5SQmtMZC80dHJvRURGMXRrYTFJanFiS0lYV25XNTBNRkVZ?=
 =?utf-8?B?THc0TlpzbmlpallZaFF5dzFOR1doNm1PYm1DaE9uL2ZlSjJ2UUE2UXAzbVFl?=
 =?utf-8?B?M1ZoWEFPcjIrc2tzNHRqbmNkNVlpVk9WbWxhTVgxYWdhcXpXQ2VUbjA1MUp1?=
 =?utf-8?B?VlVER2dFYXFpWGl0bHlKRnpNOHlKdFpsREU4SitzL1dCM3pFcTBlRXprMFVY?=
 =?utf-8?B?QmdCUE4xVk5JeXBEZngvQS9ZZGZzc0MrOXdHY0xIb2YybC85TzJhYU5yNmhY?=
 =?utf-8?B?OW81NXkycGdMN1ZURjJlWUx4SFVLT1VFY20rbGFXd2JER2FIb003UXR5dmVn?=
 =?utf-8?B?RDVURnl6K1N1MnhBb1h5cnFVOGw0dFhmUzZTbWlCTStCek5GV3haNlRHZkRO?=
 =?utf-8?B?THdTdk9vMkg1ZFZpMFpONlVjSU5DZDdiSHhNekFzR3ZXUnlKaFovVGY1SHBL?=
 =?utf-8?B?MFQybnBJU3ZhZDgyOG1YUzQ5MUpmaDJ0NS9rRmRYZEl2MzdLQk16bzdhQllS?=
 =?utf-8?B?MXZabUdxWms4VTJUS1pMQVBFUGZzYnlaY01PaHB1cGRnWG5xT3BIakhVQWll?=
 =?utf-8?B?WVRRTXhJV3BzVDdMeGxmMUszc2gxTUNTbmZhY3VLN3VSc2lYa05TQUo4dm1E?=
 =?utf-8?B?cUE3VEJCdTdyeU1PbCs2N3ZNRjBhTFFjMEVCY3BFaG1vNjhXWnRBTXhYTjBy?=
 =?utf-8?B?OXl4NEFMcDBHNkk5K25tK3RiTGxJdWZJWVJ6Tm02Q0lXM3o3dk9nem0xOER1?=
 =?utf-8?B?a3JSWmptTll3K0s3MFRWc0lLbml1bEVUUFNMWkE0N2c1NGtiaWZFcUVuZVlr?=
 =?utf-8?B?VDYwa2ZSV1cwdGpPNEJybFZtK2pIWmpJYi9PeXlORnhvNGxEUCtOVUJrWDlE?=
 =?utf-8?B?ZXVwNUY2OFNpTUJIZ0xXOVVRbHowd3lQZjljcUZsZFZQdkZhSFFmc2NuRXNu?=
 =?utf-8?B?RHFJOGtXbGo3MU9seVJlUzd6NGlLeW5Gd2FEcWh4RnY1bVVzOFZxQWI3RTFt?=
 =?utf-8?B?TXZhTHlRQXFwYmZZMGJ1akFtNXZUdytSanNvNnFaYzFDMDBRbHJDZnpZekpj?=
 =?utf-8?B?a3BBbjE5RGRicVJEMnJWd2tsanppTHJiQ3FJUkQ0WGVFc0hNNUdyMlhxalJD?=
 =?utf-8?B?OHFGN2Q3K0lONjhiK1QyOTdRNlZQS2hGdnNLWGVTbEh0YlJ3WWF4bzhkZVNq?=
 =?utf-8?B?OGdKRFdMTnA0Y1gwY1AxNnB3emp1MnVXenZVOUNmR0ZzejNLTCtVa0U0djFs?=
 =?utf-8?B?SkxHNlhoNTQ4dllMQjdkb2R2R1Vjc216RlJlaVhwSjlaRjlsU1JWWUFDU2F5?=
 =?utf-8?B?MUNkT0NLY2FpenJ0TGZ3Q2JzK3JjMVVMM3R5Z2d1VWhVZVRwYVpFRUR4ZVdO?=
 =?utf-8?B?aDVpOTdOYnNvcFQ2MUw1enRFUXUzMzFCWVIzUkdaWmQyZmlpQWhHdWV3MGRK?=
 =?utf-8?B?K25rNWF4UnpydmNVOXpnM3QxV2dQUkZEWHdOTldhdGRLeXhjLzN6WHplTDFh?=
 =?utf-8?B?TmlOZkloMkN3QU1JZTNDZGRyYVM1Z0NPMXB5WHNNd08zWlFBdXFZSjA4dm9M?=
 =?utf-8?B?M0p5OHpzcDhKR1BRSUZBbUlwZmhEUFo5UGR6L3hqbTd6NW1uY0F5dW9pOGdw?=
 =?utf-8?B?VFBVWnFEUTgzS0g4MlFnVkZ2RUMreTJzTkcyMlBGQnFSQkV4TlErT2E3QVJV?=
 =?utf-8?B?SStQOHB4dVpLZVhFaHF3MWdqd2sxOUFwUnUwVm1tdVNOazFLVHhKNzlhaUpH?=
 =?utf-8?B?ejZhV3FJcVI4NmxiNHhaaXRlWXdCUzYreTFLVGxrWEFpZW1rNENMN2l0NitY?=
 =?utf-8?B?dkJYYU1RY1pVVVZNT1plMC9RZFZlNVVVbWdXUENES1dhdE1GWWxnM3pmbk16?=
 =?utf-8?B?Mkd5bUJMMUJIbXd0NWthZ1hnRm9jazVFbXBzNWFtc3NBcjZIN3dObWFEQzZn?=
 =?utf-8?B?Z3JwbEwrUXVHdDRzOTJRK1Q5aGc0TlUvS0RMRHQrcEhldFFhaXpNOVlIditB?=
 =?utf-8?B?OXBEbHBIY1lJejVuejNrN3hhc21SSnF2bE9UdjRSNTBJQmliVEdmc1ZjRndL?=
 =?utf-8?B?N3hoTjlBZHJzVjJnM3ZWaUgvQVExVEVnOG5DV2ZYTTRjT1VlM0JHUHNWdDlT?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c215b425-6cb1-4855-1260-08ddf093a644
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:58:29.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ry6eeIYVaEhcQKm9v0QG23bJ6GDZQs3Np2Zi7hJH+0jWcv3pGsYXMsri8TtYy45lFhvCR7xH6zONAwVW+7/yc00p3rdXPmtLdpM6S14bHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5937
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> The RDT_RESOURCE_PERF_PKG resource is not marked as "mon_capable" during
> early resctrl initialization. This means that the domain lists for the
> resource are not built when the CPU hot plug notifiers are registered.
> 
> Set the global rdt_mon_capable (to cover the case when none of the L3
> monitor events are enabled).
> 
> Mark the resource as mon_capable and call domain_add_cpu_mon() for
> each online CPU to build the domain lists in the first call to the
> resctrl_arch_pre_mount() hook.

This just describes what can be seen in patch.

Reinette
