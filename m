Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC62080C1
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534522; cv=fail; b=mOD7JAH0AO/DS8fCTDFemuduRF1RPyqkaqW7oJTDeTTbFfwLsfqVE1DaNjAg1j7bfBI7Bu162Icbb8biLMPyvXx0o6yPF5Z7mBrBTJ5gpCLUjd9LfdMv6yT7XE7HdzW975GnYA7YgLzwzQlWVqhP27Oin/+3e1d0FJtojlIPmek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534522; c=relaxed/simple;
	bh=F4XbDW6ePgYv9RL28pKgn/j7/GSJrrriHA+g/GZ7kC4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WZKLmToxhmnjqVseo3ihL9g9zqIOWF6cRUmOf/dlAo1Sqnng9QsDQlhyJZebVfib/nmIyj0nWzUXEBXo0GMDh5uHdWtjH6TrzqAR4NPokDsSRFh5EcPAcCNbyIwgj1qeAse9yJcCAGd85ZxjH7A49d+XgnDIbHAUY5wpzmEcgn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PpyCFUxY; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PpyCFUxY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759534520; x=1791070520;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F4XbDW6ePgYv9RL28pKgn/j7/GSJrrriHA+g/GZ7kC4=;
  b=PpyCFUxYOJ6LuuU1E5LOPZwoYlMulIYED+RwGurFkBgo8KkuepS8rUZb
   zYEmm6fxcPzE+sLQRxNdCPLmX5q23kzvPloGbHqtRzT0ONd1Ks0wexLka
   9qBEgcwJ3ve/fpA0oQqynPZk2f3JGYNNJLgG0aEclaY6YGuLjDNZWFtB2
   rn8JCLdsYOJlnPXInXxSsobcN3g5GaftrO6W78Al6eFbvd1e9jzQw4aAi
   Z3hzpF7um2dBG6x+45whQPPwQpvJ6OJJxOxsbmizNYA9UjntMTSEpq0UK
   i27eDinBB+i4M4efzjnaOsh18uy4CnSv6BYXXgRUBhM7k7yPe4mTQAfs9
   g==;
X-CSE-ConnectionGUID: 937d4W4vS8ClUBiPeAdCvA==
X-CSE-MsgGUID: a1oi+CQVT1CjYGis48zAJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="72918048"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="72918048"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:35:20 -0700
X-CSE-ConnectionGUID: z2nvKyfgQ/qimbTjVilAuw==
X-CSE-MsgGUID: Jy3VMs/PQOqwAnhx/AlHWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="210378141"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:35:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:35:19 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:35:19 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.62) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:35:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gG11uue7lUaxzKqFtLBJAs4SM+SwcM3xOhBt/OMZYxC3LR+GVbTQwR0xbyW+zQ/PTgbuIfPj7KAOZcnYVJfupfG1k3TO7rXtNSN4DvawqPDzLaAMAM7M2wPW89hd5qDtt1spbMjGsmcM/HPjpZ7I2QzjKw/7zxUVtHBrZViSN/WHYYs4To9erYHzJUNTsJ5lh5GGK6hW4oiORl1kR/KY6vlGqrQa9qLvt7BIQxOS4F+cboIoVC/58seq0Gvodnv4rifU1/aZRoqHFBTIqMxtqUNLuWaFzpKFnmx7iFXBGywHYY0VD4XRy6YjXkMuM4jwxcYxPP88MxReevFzP7qzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c1Z4lzIWXMVGx03jux57DpZdJalwkV9XpDFDjpfcJPo=;
 b=se+f+rE6D0pyZBcUgQ/12/YmY5DlsHK7D1XZeaQLVnCOZn+9B7mwaiw2WZJbUsQSQiIOXjjrMIFFQwW+Q7GxVZ9/QWcZHYkqjkvwEjTsSYem/Lr3u8kTmuqzhZnOxWmExP9fwmJrJl/ZvGf5NIPwLk7Pst8E6TSjvZ4aVeJdz1Cf6YrsJaSWbdbvKrDRgfa3265dFEoPA+GNNuUjkH+tcX8A7If4vw9M1k441tE9XPrWVFuHyUxz/ms8ON4WdsaNQW7xTY2ZnfjUwhBzTFGAIdy+NovZDwG8447wcRZ9zF7QRu/Ti9UcTxLHlVEoJtcvwMqaAmufCQG0PKGFQ8jUkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7975.namprd11.prod.outlook.com (2603:10b6:806:2eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 23:35:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:35:13 +0000
Message-ID: <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
Date: Fri, 3 Oct 2025 16:35:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:303:b4::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: d9a82b6f-3205-4425-eab3-08de02d5800c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SVh4Z056OHNNRktDSnZwQkNiYlJQOWp5bDBpL1ZDdGlENFdiL3VKYmZ1c2RU?=
 =?utf-8?B?YUFTMTRnZXd1WXVpVTNzUEtkV25TVnlIQmRjclMvREp3b3ZtQncreTlHbmxL?=
 =?utf-8?B?Ny9yQVN0T1grUmlqOGpPSWNEZ2tCT3RXOVZVSGxoajZWSDN2U2x2Y3lrdnhH?=
 =?utf-8?B?Z2Q1cnFkZi80U1NuNnlzNWRGOHFmOGxpdGw2bnQyb0xYUzFIQnRQOThTYjB5?=
 =?utf-8?B?Y21WY3BkRlhjbExINmtnL2FxT0M5UmNnQXlqT1A1Q0Jpc3E3bVowQS9vY1N5?=
 =?utf-8?B?WUJoMk91WExpRCtzUTdQeGFnWU81TEpoaVRLYlIra3AyT1FXN3dETVJtSy9Z?=
 =?utf-8?B?dVBMQzFYMHJTWHIwczkvdnQ2d2YvR0c3Yldab0F4YWNqekkwRlBPUWJaVmow?=
 =?utf-8?B?aExQNFhBMnRCb3I4ZWs2L21wYzdxbEEvZWRVbzlCR2RuUU9SdGREUFBFcjhq?=
 =?utf-8?B?YTh1MFBOVXIwSmYvdFh4MkpzWkdTeVlnNWNGZ21Vb3NyTGwwOC9kUVE1UmhE?=
 =?utf-8?B?NVRXK01aNGRWRkFrMHB1T3luZGM2ekJPOWN0YjlqaU5oUzk3UmFzeTZUYUNO?=
 =?utf-8?B?cDRmUXo0bExYUXFUelc3ZGYwTmtwT3VQZDVCMitZcmxsbFNuUXRscVJna3ky?=
 =?utf-8?B?SmdSU3NhbGtiM2ovc0xPMmg5OE1MOUh0d1BuZTVha2JXTmowTGdXMy9iOEJy?=
 =?utf-8?B?eGhzNnQ1djVPTHhYdWNXeXM2SHlydytBbHJXc1VYR29lci9JVkF6cUM0dWVD?=
 =?utf-8?B?RUxhSlBhT0JFWUs4b1hSSjY1ZFI2RERjV3RON1ZqUnpwVDhlNE1VQ3RYN2hO?=
 =?utf-8?B?QzQzaC80NFhLN216SGJJMlU2K0ZXS2NpaUFVOUw0d1oxOUdZaEtNcVZ3RTNY?=
 =?utf-8?B?K044S2c2RWVqb1NoKzhJYkRIdnViWXpDVHVXcnJnQVVML2NCaFcwNUlHWG5p?=
 =?utf-8?B?NkZISXZyR05yYzlUdVdmeHoxbmp4VWphaGpES1BLbUVjWXZaZkNKdkN3c0c2?=
 =?utf-8?B?SUVCazFGd0pwYjM0NmZIcFF6TjhXN2NNNng3TERlUENtMUZ5ZGIxeG0wSGF6?=
 =?utf-8?B?YVdTVWJIekRlMnYyY3pUSVdBbXZvN0dLR2t5N1Y5aENaMEdwdWN6bzFad041?=
 =?utf-8?B?blRVOGJ2RWVSalV1d1RmcStZam9UYmk0aXFQU2tDcXJoZkcxd2o0bHdXOVEx?=
 =?utf-8?B?QlBnR1EzcnF5UFU2WFRMRnlES1JiOWZBZ2pVMG1KQWk0NlRQOUNVdDFPODdS?=
 =?utf-8?B?NDlCd21Ka2k2Z0J2M3JmLzZLRUZFNXltNUVLZVhlQldjVDlzVlJYVWNaTGpT?=
 =?utf-8?B?a0Z3OWJ4Z1VNRW82OW9zM0J4WmRYdzVjTWE5ek9uQ2RNVXl6UEpsdE53UWxm?=
 =?utf-8?B?bTNlSHZzWDJXUEozN3loNkFGZXBldDQ3MFhUYkY4VE1uUHFVQ0hTUmlkV2NP?=
 =?utf-8?B?WTF6VVNJcTRHNHZndVIwS2ppSk9zdHFFMmk0TnY0cHhvMjMyQS9uRDRmN1Ax?=
 =?utf-8?B?THBKQWx3T21iMW50ZFA4Mk5nT2FzWkxwYnRUTW5rdHRmVXVaRjhqbDB2U0tL?=
 =?utf-8?B?RmpzT1R5K0hHYWtucnUrRFA4Q2NYQmJLQWpmTjVUOXMvREVVZ2JOT3FlU3FP?=
 =?utf-8?B?eGdpdGh4dzBzbmo1cThMdE1teXVKblB6cWs1TE1vWHlqQytlQWhsdGQ2Rzg4?=
 =?utf-8?B?OWFpS05FNFpOcXRHMG9RWVF5YXlnNzVTRDRTdE1RWFh6L3NTQ1pRZDFsSy85?=
 =?utf-8?B?b3R2ejlvRnJCcHdhQVNBMVpXSW13cnVyYk1KK1ZkU2xlcHVtUG9jc1lZc0Ey?=
 =?utf-8?B?dENEQVlvNDNyNFQ0eG9yb3FZS3kyYWNwdmw0TUNxY1RVTEM0d1loaWdqUGo1?=
 =?utf-8?B?eWRMR3lSR1Q0S1l6WXhRVUZUUGRxZmt5L2E1ZFJEOW5VWG5uN2k1UzF6b2sz?=
 =?utf-8?B?bThxbHhSSE4wRXl3dmt5Z0JoWXpFd0xDYVFzdzJxSTFrSWpmQXl3cys5K2My?=
 =?utf-8?B?VjJpWGovc0tRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkJ2QW1zcHRsM1pIelhoa2FBQ1o4TFdjY24wWDMyMFFmZVZYVWRpY2JSUW1l?=
 =?utf-8?B?TVBCblJzZFpmd1VGclhiTi9lVEZTNCtYR2NHQTJxTStkbVZIcndaTlNMUWhD?=
 =?utf-8?B?enZKeGZFbFB2aTA0TlplKzN2d3hFbElSUWs2aU5HYnVUd2V5dHhwRmE5SGtq?=
 =?utf-8?B?NzlTenM2ZHZ6TUFiaGpaaGdQKzJLaWtISHBCTHFkaGdJUUNydi9ROG9zdHZN?=
 =?utf-8?B?WXpHNXFIdnJ4OFJXalBiMlU4enNSZVRWamo0OHByNHJHYldwTEt1MGZZQ0cy?=
 =?utf-8?B?c01rdzAxVlh4Nmk3SUxiTjdET25IWXFPZVpGd096a3JZejVucEk2dVNkM1hS?=
 =?utf-8?B?R1JweGhyUWI5cWJzSFEzWWIxNDRvR0hlRU54R24zN2F0VDJuUWN4Zm0wdVZk?=
 =?utf-8?B?b0F4S3dTYm53Y3V4WVBTb3hZODFwQndaa095V0JMOSsxQm5CNFRuWUloSk8v?=
 =?utf-8?B?YmFPQStOUEFrYit1MFZYMkxoWllQTkhHdVZMWmJxZENnb3ZvdHVicWprN3Fu?=
 =?utf-8?B?aHlvZ1hobnFaZFVvZnNkbU9KWnBIV1FMNjZrVktNNzZpTm1xd05IWVNPL2Nr?=
 =?utf-8?B?Y2FtYVFHd2YzTWlad0JwSnFGKzZVRllpdzJXUG4yRWw0SDMvbHdLRWI0dTVL?=
 =?utf-8?B?YWxpUml2WVdreWcyYmNzQ1dkekNnMXBTTmJpZllDODJvUHZFMHFHdEh2NWZl?=
 =?utf-8?B?ZEhubTA3b1dCY3Ezd2xIeW5sTVQyTktRblJ3NVY2ajRxcU5QR3ZSa3JtekNG?=
 =?utf-8?B?Tm5yTW5SMHVaVlFnTXpPY24xZm9tL3ZNWDNlMStVMnZqNjE5Y0s3ckFkOE1R?=
 =?utf-8?B?L0pFVDZDYmZUcTA5OFpIcUV5NWVFeE1mbGhCcWdyejcrTWhoMlcyRXE5REs2?=
 =?utf-8?B?dmhxSkNmNy9KTWFJaUlaalo5OWdQUmRvdTAxZnU5UGRoT28vb1MvMi9Hd3dy?=
 =?utf-8?B?ajZhb0dCWEdqeGlXYUpZNFMxbXV6OFkzZlk1YzVoNEtYcGF0UU9zWENxbG5U?=
 =?utf-8?B?ZDh1SjRsWkhmTFdBQXFvOGlocDhwTlV1NnZENS9BVDF1eVNjTEhLOVYrN0gr?=
 =?utf-8?B?YUNXY1ExOTQ5Q3F6ZFh4ck9wUUxqblZKZkhta0pSWXp0K2ZDWXRiS2hpem1R?=
 =?utf-8?B?Wk1NaWhwb2hjNUV2cWpJbFR2QmhYWVZTYU1YRTRPZ3VhdE1CbkVoWENZRkcw?=
 =?utf-8?B?WWJPdVd5QzJreE1DV2ZzOExhZ1dBQ1cvU0ZsWmNDZGdqSExLaFFzTXlBU2lG?=
 =?utf-8?B?bjAzdzZweWwweTNGYmJTWjNLOTduc2tiL1NDRE5hQTlqV1lmd1NieUFqaW5r?=
 =?utf-8?B?aitVbnE2d0VjWTJTUXZ6MmlaZGFmSkNvUWFaSldpVVg4R0hCZE1YRnB4SEtD?=
 =?utf-8?B?QlBuejVzUnJaWTZrQ1BLck9oeExyWWExSXpUakN2eUJhNTUreEc4QkJNNUxF?=
 =?utf-8?B?cThPcHZVVmZRZE42QlltNDQ2S0M5N0dVS2JId0VneWRPRmM5Zi9Yd3Q5RUZV?=
 =?utf-8?B?M3ZTYVR1NW5oMWFPd0ViQVo3UThBaHQwcDM3aXhwbFJYMU1XN3N1Y1crRFhQ?=
 =?utf-8?B?dC9oWVkxOFpVMVlKL2paSTc5VTJwT0xVaDFPWS9xN2w1a1JMYkZYUTdtN3px?=
 =?utf-8?B?VmlUK05adUhraC8xQkhjVW5VbWpNS21TVnBRVmt6WUhJbnZCcktJWFFocm1X?=
 =?utf-8?B?UEE3UlIxaWVqS3ZNVHRVbnEwZ1NGNEpUdUJmZXZyY1JkbWUxTi8xam1KcmFm?=
 =?utf-8?B?aFdVdU5nclpOL2RBbm4rR0M1NGpHR3ZzTEZvc2h4RlY5ekxHaFd5cGloenhU?=
 =?utf-8?B?blo4VndVWFkrYVRDVUZmOTN3b24xQzRZRWM2ZGxxNDl0UGdMTWF4QTZ2Sms2?=
 =?utf-8?B?ZHVLQzFndFZkREhkS1IvSWh5WjQrUXdPbm1aSStPYmRXNy9TNTgrSTBGM29m?=
 =?utf-8?B?M0c4Y29aV2YxaDVYbHJ1UG1MM1pORTgzMzNZaWFuYjFpZzVNV0FUaEQ5REw2?=
 =?utf-8?B?MHp1K0pYRjJHK1V5dk5EU2QvRWorQXl6MFlOanVjWnpJOU9GSmtaWkNBN2dR?=
 =?utf-8?B?WEpUMExRWGh5cVVvOGRyN21hbjlKdWhtTkJGUTBhb3NkMnFtc0RLLzhmb0ly?=
 =?utf-8?B?VFpHeXlwdU1YQ2FqRTBaanhMVjhBUWFnMkU4Uk5ZZW5VaEFSL2FqUWx5WDQ3?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a82b6f-3205-4425-eab3-08de02d5800c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:35:13.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPGEpL2SCDy9SeFJxo5fCMq2S+bHVIO/nI3LifJRtYqw0vCNgUsZHrG0IyngjlsNlhV3xd0HARbbe1sPCco2LOAOEuybG0nbUcGBBw8QdfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7975
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> Each CPU collects data for telemetry events that it sends to the nearest
> telemetry event aggregator either when the value of IA32_PQR_ASSOC.RMID

Please note that one of the "Touchups" done during merge of [1] was to
use full names for registers in descriptions. Considering this,
"IA32_PQR_ASSOC.RMID" -> "MSR_IA32_PQR_ASSOC.RMID

(also please make same change in cover letter)

> changes, or when a two millisecond timer expires.
> 

...

> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			returned by the intel_pmt_get_regions_by_feature()
> + *			call to the INTEL_PMT_TELEMETRY driver that contains
> + *			data for all telemetry regions of a specific type.
> + *			Valid if the system supports the event group.
> + *			NULL otherwise.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};


...

> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> + * pmt_feature_group for a specific feature. If there is one, the returned
> + * structure has an array of telemetry_region structures. Each describes
> + * one telemetry aggregator.
> + * Try to use every telemetry aggregator with a known guid.

The guid is associated with struct event_group and every telemetry region has
its own guid. It is not clear to me why the guid is not associated with pmt_feature_group.
To me this implies that a pmt_feature_group my contain telemetry regions that have
different guid.

This is not fully apparent in this patch but as this code evolves I do not think
the scenario where telemetry regions have different supported (by resctrl) guid is handled
by this enumeration.
If I understand correctly, all telemetry regions of a given pmt_feature_group will be
matched against a single supported guid at a time and all telemetry regions with that
guid will be considered usable and any other considered unusable without further processing
of that pmt_feature_group. If there are more than one matching guid supported by resctrl
then only events of the first one will be enumerated?

> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		ret = enable_events(*peg, p);
> +		if (ret) {
> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}

Reinette


[1] https://lore.kernel.org/all/175793566119.709179.8448328033383658699.tip-bot2@tip-bot2/
