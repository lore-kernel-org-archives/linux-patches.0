Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69C45038
	for <patches@lists.linux.dev>; Tue, 13 May 2025 03:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747106427; cv=fail; b=cQx5xMfBrUfavh5ltp8gkgMjQCL+/H11BiUZlSBnu+2QpzN2st1TVY8/uHbLe3xDD5OR87fkVrEv0s42Kweqo8HSqANlwehdIcbZHFpv0PzqUNFxJfUJogKOWHfbTeyoYDoDG4kAnXrvEPAaloOUPM9s0su0XPfr8k3Rx/UwnYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747106427; c=relaxed/simple;
	bh=Sdq8+alLyc8WrjLmIcvLltRGlw1CM4PVNkOw+VrNmsE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Akq6hDJGu01IrU3+WuRWp9y5JW2nzFuE5jjXBs9Vcdpvqs0PR1gVz/pVXqxdOK7udMoUjk3r+i5ZHIEZcb94/29pW2B1ALMToAn9UeHDcLVYE4MsPIpWdoVGmRt8YNqxHBHrja6NMAz3FGv3G/QAhFP9znouSMaXjlWodibmXN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQwTBX5D; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQwTBX5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747106424; x=1778642424;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sdq8+alLyc8WrjLmIcvLltRGlw1CM4PVNkOw+VrNmsE=;
  b=JQwTBX5D63j798XnRW2UxpwkLB8VjdqjeqqVWcLsXxIRUESz+jdvXBy/
   5ofbV4xDXue2vHq64pB4J/yHgPUurRXr3pQl5x9VtkiemWPjdyBg6Z5FG
   mVGTQFmY1r8LJ8hhXseW5sG1qNwjo9apfU8Umv3H8cxvgy6lvq9fRjwSx
   zTYwKvENYIg8OmlLw28GU4SfuFkuaDbF5Xh1Am825H3uNkK1TzENvVKnK
   xKh3+CNoYkBlwHAKJSOLCrWzRE69CdY+8OY4HGfe7AbR/I4mwUHm6yuPX
   RpHM6I2k6DGapJcIKWWO+3VTiwxf9RyxBuxktK8cm0kuHy+lzExJQs009
   Q==;
X-CSE-ConnectionGUID: pU1sv6tMQ1SRkC2dQ/aHZA==
X-CSE-MsgGUID: 1/Y244jmRLunPcaTZhWOtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48038073"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48038073"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 20:20:24 -0700
X-CSE-ConnectionGUID: cYA+6lkjSg6cJSpk//I6+Q==
X-CSE-MsgGUID: XSpBQ96DTYinWw0sP/rwAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="168657644"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 20:20:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 20:20:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 20:20:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 20:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPNMu/Dp0F/u084740X9egUm5XDRCuvSNgTI5bcbrXNAiHcjnYzq0OLwN0U3yDcGYmOmNg/B8MSpH72Z6Fxb8Y1l0pTw2170zoXK91ax81IBtDcoqifLmHsZZgJ4UTx35zr2qesqlBC2VgUcOlh6PTbq2JLcQ2IQLqmbP9uLpcU2EcorkITleGtfWZbIAVkuMG94StdWfHdliyz/iAOUjQjZEA1Z46NmkouqM7A8HGlMwARqs4c0QCmvY3bT4WeI7w44J6bwZooOBo3f4TEKVJacE+QWLR5OMaAQpHazuSq4r9RyOqJMoYiDerSz6+K+hp3Or6N9CQsm9RvIhW9c7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlAV/HSj3merG5NDnT2WkA8rMkMwiR/1CoMbiOePw9M=;
 b=Bg3CaEflYWHeootDfigG0ETATwDz6xytSU+hpECxTU3EY1fUttwzbBl0KJn+QzL08F4vg2UioX4Ja4WkyWcHcLmHHNOcGv7CFETaGmurn6/cHoFrBW8u/Zp47bWVmdqIdmYgWrz73pj3dDhlkh4yVL/oN1sXZyytbtxc1JKBD5MHNIQ8dJe5+O3KoHxROTnBy0gahRuNdrt5G/ni/N4uFbgOOfuVazD2Gvn/O/xfJKw2Ddf+OW/90gCmb7ufwnrHJXCbRjRb1AGWnylmhCdVOombGt+yTm/Cn2hrFUuI0KoPmz94UbrpLJQpf7dANvyY7xmcdEVHcbMnycdHGkRxaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 03:19:35 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 03:19:35 +0000
Message-ID: <e818906f-b03a-474b-8a6b-d291cf1a74fe@intel.com>
Date: Tue, 13 May 2025 11:19:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/31] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: Tony Luck <tony.luck@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, Babu Moger <babu.moger@amd.com>, Anil Keshavamurthy
	<anil.s.keshavamurthy@intel.com>, Dave Martin <Dave.Martin@arm.com>, "James
 Morse" <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-13-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20250429003359.375508-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: e16b253d-361d-4026-0eff-08dd91ccfc29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zk03VFcvSnRoK2x2QU9aN01mN3pkUTQ5ZHZ4aGN1eTdkQ0dWQVJzQ2tCbmw3?=
 =?utf-8?B?UGtGcFFOTHdvWHpyNjNBTzFoakdmSkhJa3JDWC9zZjVpQVl3c1h0alN1VnB6?=
 =?utf-8?B?V2R4WU5aY1FJcXN0TEZxV3Q4OWtuWTM0bnBWbmZIM3JnQ0JaUElscExBMnBS?=
 =?utf-8?B?NEZpdTBEWmw1UEhHblEyWkNOYUgyY0hHRWFWOUszNWIwMUpSdzlHTC9uaExE?=
 =?utf-8?B?UFRnNWl4cTNESmNFWDZJTUdnKzdrYi9senRubGZ0VC9DMTJXNDFibTBKZHFm?=
 =?utf-8?B?QlFqKyt5YUFSVmE2TWN2dWFVbmdnbVNTRmkrWGF1ejF5WFc3UllLbUU0RGdO?=
 =?utf-8?B?YlJUTW5FUHIzYmg1elo5NEJHQlArU3VkRmNBemQ0eUtIam1GcWVFN0RMT3Zk?=
 =?utf-8?B?cE1kNEJpTU91YmpMK3JMWFEvSGw5TUVyUkRWTnA2N3dRNnlILzBBZURLL0dB?=
 =?utf-8?B?dmN0bVRpdzJWWVNzck1LSXNTMVFHRjFPMlNRb3l0RVp1MldPNVIzTVZkSVpp?=
 =?utf-8?B?dkhicjZwSDdvQ2RDek93YWtOWUhZUG9ac1owSUtSdFN2MTQ4MW5pZlkvTFho?=
 =?utf-8?B?TnJOZnF4dnJLQi94ZDlYNDNpN2lidWlSVWtCRDZyb3hpS3NsVFREWHpSMFVq?=
 =?utf-8?B?OWYyUU1sVDc0TXVkbGxkUDcwc3dIWEJGcStubkJrOFNoUEo5ZENvK20ra3R5?=
 =?utf-8?B?d2tGZnA0cTZ2Z2FwS2xkSlhJOEZwaVcwOW9Pc0NvWWUwM1VWV2h4dDAvZHVu?=
 =?utf-8?B?RlE1MS9zai8rVStEcTk1VXp4eUFBRnQzSVRiemx2YStzU3JrNVExSDRlVlIx?=
 =?utf-8?B?L2tjK2lQUG40SjFPYzhucE92Rnl0QUZYaWF3MHNydWtTSFAvZG9qR0Z4dGxI?=
 =?utf-8?B?Y2VGN2I2RXh4OTB4YUxYd0g4a3pETXMwUjB1YVdVdmRsaW1neWxPOGtLRUxs?=
 =?utf-8?B?TnZ5UTExQ3piUTlBYXlyRFFzK0IvQ2xjaHI4cFJ1WDJlWDBFdlJXdmJ1QndM?=
 =?utf-8?B?czlpdTY3a2VvVlpMdFE5NE1MOTFEZmdKSGx4RnFhNUdXbWVWQ2dyaVZLRXBk?=
 =?utf-8?B?R2hZMjlaV1BGanhONmlSWmZROStQNnF6dzFaNGo3VTRSR1E4OGZ0ajZqRFEx?=
 =?utf-8?B?Rlpxejc5aEM4Ly9JNWNrZ1RubmtNbDZmeWJMTCtueW8xY2VsRFZsZHVtSldQ?=
 =?utf-8?B?Nkx0R3VSOUVCNGxKb1lESFkvU290ZXVhT1FiNTBvbFlsaTJUTE50V3BqQUVu?=
 =?utf-8?B?RnZvT2pyendiNTNscDNUL2JwK3Vvdit0eWdJSTVGUHNMamVqdnpCK3J3Yjly?=
 =?utf-8?B?UFlLS1hsbFphTW9ERGJ4WWFrNTh1ZlUyR2U3ai9kL3pxTTNwb3c4bDBlb2M2?=
 =?utf-8?B?M1RYWjVCcFd3Z2NoK1g2UWVGVS9Cbm5PdFhNRnhLZjQzUWNNbDBHR3Zsczd2?=
 =?utf-8?B?YWhmNU5KN1ZwMTBSU1FEMVZlOFdHUUhtTW02Q0JyRUxZUTJUSWRJdXJzdDhH?=
 =?utf-8?B?UFBmZENEWitON1pUTW81bTNxWUQxT1FJbElDVzBYdFU5WEVXQVlkSVhuR2tt?=
 =?utf-8?B?SHRRNXd0TXJJV1BwTEpOU3ZDOExsQmw0NU56RWV3cXNzYTZldkc5YmFZTkQ1?=
 =?utf-8?B?Z0xQYlhsZFhLOWJ0WmtPZ29semZxQy9sL1JzT2FidjNCbXBZQ2t1SDFibFVq?=
 =?utf-8?B?c1RzR1JQUU5obVN6enYyRUtMWFIvTVpEL2dmWkNEd0RnVEFzcFRzZElRQ0dJ?=
 =?utf-8?B?b1hSa1RMMitqcWMxY2xhQklIKzRwa2U4VURjRWgyZjU3blZsMUFBQlgwS0Fu?=
 =?utf-8?B?cC8rMEZSdnZ4QmRPbVA0bnRZc1NDSHdlSk5mNUtVQ09PSXpqdWR2MU1rYXho?=
 =?utf-8?B?aEVGdzhreDlTWDVwNHVtYmhFMTJmQi9QNkJjQmwydFpEWExzMDdsWGlvU1Ew?=
 =?utf-8?Q?ZZNSzxVOcs4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akZmZHZhQ1J0Tk5ZQ01iRGUxWmUwdDdFaGhWV0lmaGFTTXI4WGQyOUFLeWFj?=
 =?utf-8?B?a0pSZG5kbStFRFgwZldRTDFkamhYLzNkSzYwVmd5Ym9JK3RyYTZiOWlHYlds?=
 =?utf-8?B?L0w3Z0o5MG5jS0pQNFM2UlExVXpZT1Y1LzNHbG1qakkvcWE3cHNFamRUU01h?=
 =?utf-8?B?OGh1Tm5kVFd1cXpEU2I2YmZmMncxVlc3bXp1MEVhWU15eHJjTVpuNVM2RDh0?=
 =?utf-8?B?bnlwRUZPd1huM2ZsOXhVN2RibFR3R3dMTEh5UlFNTWEvZFdkaldmam9ZdzNH?=
 =?utf-8?B?TUJ5WElQcVNXeDg5V2NXZllUNktpbjhTdnI2OTQyZllVV0lkcGg3NUpqcDJC?=
 =?utf-8?B?eCtkNjR0ajhsNCtuOXY2KytEbmxXMVR2Z3cza0Z2WFdpSlVsaUZIaTNyVTda?=
 =?utf-8?B?dXpSd0RGTis1dE1wb0FjbW41M0dya050RHJmYTdvbWhmZjVLR2VIeEhMZmlE?=
 =?utf-8?B?OVl3anBqVlBYTjVzUldOK3lJc0V1ZlpFY0ttK1V5ZlFTbG5Da2F0OTVZWTJY?=
 =?utf-8?B?ZjhHMVdxRy9DS205N3JkNXFMcXZtb2IvaXR4d0ZEYVowUjlQQm9zUUxmR3Zk?=
 =?utf-8?B?cXJEWkY5ZDRxVFRFYlZaRkdkcERGYzR5dDFDcnByR0ZSL0xqUDdBdVA4c3VB?=
 =?utf-8?B?bXE1TzJjMjllZC9xQUU1QlRHSHhHZC94UHZqZzBTWFVkQ0NrSGVwQndhTUpK?=
 =?utf-8?B?T1lwdUFYUlBDN2VuaE16encwdS8wM2YvSVcraTdBdmc1SnhZKzRjbWhvOEoz?=
 =?utf-8?B?bXNJUlp1K3ZwVXFqd3lMbTBBVGFmTHE0bzQ5UGRkelVwZmxudVkwVGVaU1pO?=
 =?utf-8?B?cy90YlN1YVhsVzVJOUNSVGZ0cXpPWUN3OVBIZTBOSEE5QTRWcERWZE1lRVFP?=
 =?utf-8?B?ZzFsM3J2dDVlRXdobjZYUjU1N3M2VUk1M2ZEbUpZNGZnTVVNZW96cXYrT0Za?=
 =?utf-8?B?MTRVK1hPOFNwRlFyMVFaaE9WcWVYS1BTcUpMK0c4ZTIwQkcrMnc0SnIzbVRw?=
 =?utf-8?B?dXpxTGZoNkFCNzJyV2I4K0hNMkJoczBoN2M1K3ZhRXhHVW82dVJTS1B0VHBU?=
 =?utf-8?B?Z2paYTFVMjBkcDN5UWZlTWM5eFdzNU93cWppOVdNVWJuVWxjRHg3RXJKdGpR?=
 =?utf-8?B?QlgwejdVaVcyVXl1WjVWbWNtbG9QMlZMVFRxNE1sSC9ZZW8zaGZPVmdPNnc0?=
 =?utf-8?B?ZkNOVEd2TW5YNXRiakJ1Mk1PR254bEtBTDBLTUl5YVcydEpSUGN2QXYxTzBp?=
 =?utf-8?B?d3VPRENZdHJPRGxEZkUrUW4wMmFWL3VieTNoVGhUdFdDQkxCSHo0L0pqbzRl?=
 =?utf-8?B?Y1N0TUFVais1L2VPN3hKdDhMaGh2Q1NTeU5ObXdRSXBrTlJyTVp3Rk0vbGh2?=
 =?utf-8?B?WUIyTnJFRzdUNzZLRjJYTlBpM2pxYzNqYk5NMzZZc1JHSTRqQy9HVVVJeHRj?=
 =?utf-8?B?ZXI1ZWZxSzRVR24yZHVRZmFRejFKemtuL3pTcHBqc1dGWUMwY0lNS2FVbHZJ?=
 =?utf-8?B?ZytQMXNSL1MvYzFaZ0wzbHJra01DcDZ5SU1uc1k1Y0lmQzRzeFJOakZsTW9E?=
 =?utf-8?B?c3F4azA5c3V6VU9vVnUzTm16MXVHaENURk02TEkyM3lBeGpxelhmd0VWVHRp?=
 =?utf-8?B?NzVTeW9JWDlkSjlJTTJiNWVzcDlnK2gxS1d4dVVHZXRLUkFFVlp1Vkh0K3Fq?=
 =?utf-8?B?RCtaRWZuWlhFTnQzRTl0TzF6TEgrbEZjTzllNzRtR3kyanZMV3N5MlBIM1ZZ?=
 =?utf-8?B?T0cxZDhZMHhGaGNpaUE4NlZKa1VNbnJoamNWWXRiQVFwSlN5QnoyRWpqY2t3?=
 =?utf-8?B?K3hhSjRSY0M2dENtVVJLUG1VUkdFcTNsdDcvYjUwYTFwU2lhdTZkdHd2ZlhT?=
 =?utf-8?B?NHczK2JGV09FL3pONDlOdlphZVFXUnFHY1JpUmFJL2lUMU1BSVpqNjJXaVF2?=
 =?utf-8?B?eWdUL2NjRzJRMlJxU2hieDNWYVpVMXA4cWVJRWFndWxoUlFMM1Vac3BOQWVN?=
 =?utf-8?B?WTNrUFV2SmdiM0syQ1A0Q3ZVTm5SZzlqbXBtd1Uvbzl4L2dRVUQ2NGZFMlpj?=
 =?utf-8?B?VTBMODF0cWJLZ05ubUsvYVpBZW5CK3V5NVpQcGE0ZG0vYzRnaHdFcXVGd1Np?=
 =?utf-8?Q?19dJsZ2/V++bGDL7GPg/O+Td3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e16b253d-361d-4026-0eff-08dd91ccfc29
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 03:19:35.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKHmk1Pl+4NBy/xA+WXBmvMSiAeiydYKdoM795+GAGfP8DIcVdQSaeJgSY+tvlN+EGPJsGHNcBTpBEhY7CIxcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-OriginatorOrg: intel.com

Hi Tony,

On 4/29/2025 8:33 AM, Tony Luck wrote:
> Resctrl file system code was built with the assumption that monitor
> events can only be read from a CPU in the cpumast_t set for each
> domain. This was true for x86 events accessed with an MSR interface,
> but may not be true for other access methods such as MMIO.
> 
> Add a flag to each instance of struct mon_evt that can be set by
> architecture code to indicate there is no restriction on which
> CPU can read the event counter.
> 
> Change struct mon_data and struct rmid_read to have a pointer to
> the struct mon_evt instead of the event id.
> 
> Add an extra argument to resctrl_enable_mon_event() so architecture
> code can indicate which events can be read on any CPU when enabling
> the event.
> 
> Bypass all the smp_call*() code for events that can be read on any CPU
> and call mon_event_count() directly from mon_event_read().
> 
> Skip checks in __mon_event_count() that the read is being done from
> a CPU in the correct domain or cache scope.
> 

Since __mon_event_count() was supposed to run in atomic context, the
smp_processor_id() would not report any warning previously. After
this change, if the evt->any_cpu is true, we read the telemetry counter 
directly without IPI involved and in non-atomic context, we might
get warning like below:
BUG: using smp_processor_id() in preemptible [00000000] code: mount/1595
caller is __mon_event_count+0x2e/0x1e0
2483 [ 2095.332850] Call Trace:
2484 [ 2095.332861]  <TASK>
2485 [ 2095.332872]  dump_stack_lvl+0x55/0x70
2486 [ 2095.332887]  check_preemption_disabled+0xbf/0xe0
2487 [ 2095.332902]  __mon_event_count+0x2e/0x1e0
2488 [ 2095.332918]  mon_event_count+0x2a/0xa0
2489 [ 2095.332934]  mon_add_all_files+0x202/0x270
2490 [ 2095.332953]  mkdir_mondata_subdir+0x1bf/0x1e0
2491 [ 2095.332970]  ? kcore_update_ram.isra.0+0x270/0x270
2492 [ 2095.332985]  mkdir_mondata_all+0x9d/0x100
2493 [ 2095.333000]  rdt_get_tree+0x336/0x5d0
2494 [ 2095.333014]  vfs_get_tree+0x26/0xf0
2495 [ 2095.333028]  do_new_mount+0x186/0x350
2496 [ 2095.333044]  __x64_sys_mount+0x101/0x130
2497 [ 2095.333061]  do_syscall_64+0x54/0xd70
2498 [ 2095.333075]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Maybe avoid getting the CPU at all in __mon_event_count() if
evt->any_cpu is true?

thanks,
Chenyu
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index d9364bee486e..32385c811a92 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -358,12 +358,15 @@ static struct mbm_state *get_mbm_state(struct 
rdt_l3_mon_domain *d, u32 closid,

  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
  {
-       int cpu = smp_processor_id();
         struct rdt_l3_mon_domain *d;
         struct mbm_state *m;
-       int err, ret;
+       int err, ret, cpu;
         u64 tval = 0;

+       /*only CPU sensitive event read cares about which CPU to read 
from */
+       if (!rr->evt->any_cpu)
+               cpu = smp_processor_id();

tele
