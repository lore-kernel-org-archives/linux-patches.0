Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E0532694A
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074625; cv=fail; b=DvthloYQgUTsNfMgXMHtrazJ3uq0ity/AYpMk9IEakfC4MeUIZ9r9JrLWk9Eei8+SshbLNpeWHEzP3RAkATPK5IKU/dNRM6OL0rTY2XHeEjTgTKrW3gUsncpfqxsIGu4DVhpD4wylQ3PZnqfE4e9yAfDt9r0sqJi5ZKa9oszmd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074625; c=relaxed/simple;
	bh=eP1QtX57UY+dZiLZFk8nFkbQ3qd5Ra3bt5ZccAcqARU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kIxXLFvznFSnMM2oOur7+0mfBFGROogU9hgrvRu4oNmpYajshMsGnwPodtkWjAdL5eUDQBjciBNn5erC3R7NlHNK0VIQq0KXopf2HW7/2KaSgnFdwfmVQ6DQc6VmiCldG+BRQU2NvAa1eXEAq3ddAJHPmsFpaBItEjI1rTqJrEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RnA/11b6; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RnA/11b6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074624; x=1794610624;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eP1QtX57UY+dZiLZFk8nFkbQ3qd5Ra3bt5ZccAcqARU=;
  b=RnA/11b6rwumPMrgIO58GAg8O4F8O5KYzLXYDKtYaBocoy4raTiBspnG
   yesxJxZI/ZUDT2B+L1NH0i9jZFCRfcwmcBl9G+A05vF8pdQfFO8Xtnse2
   KrbruuOk+dUO06UYYqory9gUct6QjrJlMOyjV1Mel0YKoO8oSlFCjffIK
   l3csaJQ3dKUs5aoNtiUwhDzfAqkKw/EgkC/Hm9EnM4yrflWS7sBs0nc8p
   xp7/HKIT6FiNGh4YWxkTZtL7/aIzN5CvsfSBU951CNbyMoBI+MF3/f70S
   m1NoXYmfXzHbXqkmy+2aTg4cqU7Pc6k34nMSn6UDavzNzCf/V34FPs2jW
   g==;
X-CSE-ConnectionGUID: wVEprtdARhu3YFyQv8U1+A==
X-CSE-MsgGUID: Od7R352aRZue3Tr7BioH8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65104379"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65104379"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:57:04 -0800
X-CSE-ConnectionGUID: tZ3ZA+/qTjmf0UKFOk6W9Q==
X-CSE-MsgGUID: a2oXaQ1GQWWxfq4D2MT7Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189874980"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:57:03 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:57:02 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:57:02 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:57:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y79ApNgEjB5NTPfMP/lH7k+gdsMOX4Mmg/9rP/11G8+ZsNsHx6+V9EP80/5i44WjrLbmvpd/RiaKt1CRFTlIltZ9T6CEQZj0mthMgpTv6DYTz79p8jUfLKqkQ0tiNyyaLibg8AO8e/a+NFa5TFf+hy8c/m0xr3LxdskGwKoP1S8PVEJBqW+soSwxNdohU770Eo4oeTbHwjhSo4IsnFIRJ/Zqnrizie31EHL/dW4xE23OlAs/4cjQaJviK3KKSMPA6sGnwxR2fLckq4mUDl4T7Cq/BgEleVsrQkFBPd9CeSAPeZdS/fwRPOmcn+47kTMQyWlv9nuh6KXbLLGFyPrPhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESKJHNBlK1irzvrNtG5E7/0plgrKSMxgkzM5DozD29M=;
 b=YJiMBaOkmRl0NSAe3SbJUmluKlpPnk7MuA2Si9Ckuqj/vQ+gntiYmzS8/x/gOsrV3d6jloHQYfckRSu1lPL+9OD5kCNNnkA5rRIxNsDr10Jnxb0bnXdYMsIiHxbh40T4U7XxKg2QdhrAZCkTx1orDqwPILLhSnPlHozbQ9oYSqH9F/GUZYShg/hXKvmI2KdqSQYVwFyvii83Kolj7ksafTOsC9f4vJL1y8ORcnffo1ZlZ7zeJJU/x+XVx1V1tUQOuv2u3WQ+FSWHxzh2ok+v7IV6Ji3MIPfdbKyX6MiiWlB+zWLlSC2XpLCpbOFvYNCtNfQ3H01+9yR42DXrfH8y9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:57:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:57:01 +0000
Message-ID: <2a0ca6bd-374f-4738-8684-202920de78dc@intel.com>
Date: Thu, 13 Nov 2025 14:56:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 32/32] x86,fs/resctrl: Update documentation for
 telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-33-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-33-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:303:b4::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f62cf99-0226-411c-a0ef-08de2307f4a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TWFDMkNVQmVvZkZVRUx0dDNiMldKejZzZ2Q0QWFoL0hYbm53Lzl5UjBBS3NC?=
 =?utf-8?B?RUZzTHFXc3BsTUFraGJabDVSMUlVWW1mMzBpaXBpVDdZcFlsRmRZK1o3QUR0?=
 =?utf-8?B?NWVsaHhPY21hVDdXVTJpNVQ4Wldad1ZPZFFmNzZmcVNBb2J0R0MvMlVYTHEx?=
 =?utf-8?B?Z2hRK3lYV3ppWVp5SUJLZXNjSTZQOVhVNis0dEl0cFdjYW4yUno5QVk2Zkx2?=
 =?utf-8?B?OUhZZmNCM0wwbUtvTnZTQVlUbFZ5M3piYVZwclN4NWl6VHBjYXh4YkttWlhr?=
 =?utf-8?B?M3JiU1dHZHhIYzY5K0RuY2syN2o1NUViMVlmcGV4Q243bVJ5YlRjM2RyTXZF?=
 =?utf-8?B?dksvbFBUVlA5S24zK1RWWnRuRm5rcW5VZVdDQk1zcy85YU5LOWM4L0xqUGdB?=
 =?utf-8?B?MVpwOVptR1p5Mk9HcWY0T3oxVGlBTnFTM2ZNd2JOT2w5TE04UjNyQ0dxTWE3?=
 =?utf-8?B?aHQ0Sjl6ZEtwOVN2Qkcra2dWWU1Zckh2Ulh5MlZQNDBHajhhdXgvZ2pQTHpx?=
 =?utf-8?B?SXRCTE5OLysrbmhUTkUveTZid2QrSVUxS3N1TVJoYWszSURTRTExaFlwN3Bi?=
 =?utf-8?B?cGRmRjFQaHM5TWNaRG43b2R0Rm1VcXFZWW5oc3hzNmlERDJPYXllY3hjN3N0?=
 =?utf-8?B?dGJwSjdBbit3TkVYbUFPMzZXUGQyOGpBS0F1aGRsbTVVd2p4U3hJQVNSdS9H?=
 =?utf-8?B?RGFTTGxucTFka2JaY20ycUdPWkE4YzJQT0I0cnhScm9qS1lMTHBKTVJVajA2?=
 =?utf-8?B?UFJuVE5NaDdCc1VXWm92VlhPMyt1ajhZZDFxY0RhV3AycjcvZzdYdHVTUytU?=
 =?utf-8?B?anI0c0FjK2dvZ1FxK295Mi9kb2hOVFVMaGpZcHNTdkxEVHVGeEl4K0JBUmdF?=
 =?utf-8?B?MnNuWGZES0NacjhMSVdBbk5ybWhvNVhDVmpZV1BMT29XM0tVbTNlMkVRUjU2?=
 =?utf-8?B?OFU4cWlJWHdqQ05FV3NLRUdMemZrelNObW5MR0lsQmRmMXF6cFlFbXp3bkZx?=
 =?utf-8?B?YmRMMUtNclkxaXRnVXNvNVdDU1Q4OTBrUUtGTEpPbXhSOE1FcE1aTkxETVh0?=
 =?utf-8?B?dlREK0I2OUI1WkdwY3JRYkhwV2JRS2lmbndVMmtyajFBMnhoU0pVeHVCT1NI?=
 =?utf-8?B?UlVSWmQrajhpaU5Ob3ozMk9qMnNnQnpxby84Nm0wMGhtU3MyV1NQaXY1M2pY?=
 =?utf-8?B?VTA4QzF6SjY5MlVtaVBDMUNyeEZ4ckcvVVV2NldFWnljT2dsWmRZWWNTendI?=
 =?utf-8?B?bWRCQ2lrQ2R2NDhhOXlZRVVleGdIRHRGSlVpcTV0bDRGTGpOOGRSRVI2UDdi?=
 =?utf-8?B?WUVzSHhMd1AxNmtmVHUveXlKSGFDRnNHTWxvdFY1RDU0RXZXUE9rVGhGcjdF?=
 =?utf-8?B?b0J4UDlsclMzcEF4RzJNcGtUK1R4QndjdGtqSUhxQzFUeU05b1FzVUdhdTJz?=
 =?utf-8?B?RzZ1WDJSUkF5N3laWVJTZDJvbFFzQVhBaVpFenFpSjdyTzBXbCswV1dmVGpy?=
 =?utf-8?B?Nk91bFNjbXRFZGV3Q1RSejNMbkIxK2ZDTzYyT1N6V2JJWTk0SFZkVlRja0lU?=
 =?utf-8?B?bUNsNC9sY09oSTNrakRydndrZFVPUE44SExQemNXV2JVa1lIVjdnU2VmaE0w?=
 =?utf-8?B?YW9GRDViWDF2a1ZZeWtXQjBtcWhadUE4WmJhaGt2WTlsSjNLTnFEc0tFSUhK?=
 =?utf-8?B?MmxvZ21oOUdjQjV3TzFWYmc1ZGlPcUsrU1JWbWtsN2RCanM5OEhsc2pGRlNz?=
 =?utf-8?B?WjRSK01ta1Q5MDhQR0xTQTM3MWJNaW5UQUJlUzlyRnhhYU5sWlhlUFlWMjlG?=
 =?utf-8?B?OUxSaGFHZmJCNHJKRnBwNUNFZ0lIMEVzZlpud0NEU0FYWStTNUk5dWFIRWFR?=
 =?utf-8?B?QlRZTTBiUitPb1k3Z2xGSlBadnBkVWZRL2lPL2MwMnExc1pqYWwrOWpOYXNG?=
 =?utf-8?Q?I7Pm7Eb/pjsNZM8JMD2+Uq8keSG+7V/R?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0hpUW91L1BUWGE0SEJsYnBDak9XTWJiRWlSVmIwaHpBMjZNWmxEU1BYTThR?=
 =?utf-8?B?S0JrQmwwQ1ZPZWYyK0xNRlBpQkZqbHMzUjJFN3o4RWwwMDloeW9kcWMrc3pC?=
 =?utf-8?B?dWN6eEZyV2E2cStiUnp6OUVDa2NsVTlFd0hrd1hJT0htQmxOMXJTMC9PSDl0?=
 =?utf-8?B?ZGYxTHVQVlVDRFZOQ3U2ZkRRaGI1RXFSck1wZlNjdXd2ZDJlOFhYZWJyejVP?=
 =?utf-8?B?ZGhXcmlvcGFOanFuWU9HMmNLeWMyQWFPQ1c3Z2M2aDZMZXdVa3BreER1TG1a?=
 =?utf-8?B?QXdmNzlkTHBIT1lDemFFeVgvMmh6cllRQzZjY0RlaW5UaHZhUmI1ZlFTeWFD?=
 =?utf-8?B?SGs5aTU4WjRBSzU3YUh0N0xSOTZhcGZTNEdJQ2tOelFhSk10VlJDQVU2ekpR?=
 =?utf-8?B?OTBEbGtHWW1IYmJHV1J3c2FuRHhwRkRFbVZ6MU52b3pNSk91U3hxUno1Y3hS?=
 =?utf-8?B?Wmh1NmhLU2pOaTVsSm15NEVFb3Y5K0ZLbUJBTVlsTkZsQlB4cWxZNDZHQjBz?=
 =?utf-8?B?dEhjV3pySzFDdEp2Yy93Tkl4WjFpTURzM0lDME1RL2dnNlVodEhQQ2JlZlZt?=
 =?utf-8?B?MVF3YkROa1ZOQWhkcUxNVW8xTnNwQVRka01YSktmbUhRS1luaFdNKzFnZSt2?=
 =?utf-8?B?dDZlUml5UGp2N0w2eEM3ektMcU8zc2dLRnFRWjQzNk9PbDlDczlwSnlxRnEx?=
 =?utf-8?B?TlYvUEFwejJrcmhWSk8rU0ZVZnpNQW8vTGpuNnFVb29CWHIxZEt5bGNNVjM0?=
 =?utf-8?B?Y3lzZGZEbGNwZ3BvSWNUMXhOUXJUb2FmL2kvN2xWWFVkRGZlOWc2VDZuZnBC?=
 =?utf-8?B?d3JVUkZVQ3QrQW1SdVRHL0JUeEhtYlEyYlZmMXYrK2tOWjdXZTcwdk1UOHRi?=
 =?utf-8?B?WVB1UjQ0ZFR1UUlOYnJ3bUIvOXFQME5tRUtPT2lUYStlTUp4Q3lkOHh2bktM?=
 =?utf-8?B?bzJsdk1JMm91M1NBWGo0V20rODhNdVhKYys0aCs3ZzZUM3hPTGNMeThZdEkv?=
 =?utf-8?B?dVRLcEx3RDFDTkJlc1JNV2hNZWJOcnZ2bzlXWGN3Z29pM3FXZlR2Y3gvR0Vs?=
 =?utf-8?B?c1d5OStNVnRDWXFzc3NQZnBqd0VybzI1UUFWcVl5S1dabm1wVXUvTzd1RTND?=
 =?utf-8?B?Wkk3TmNGN2dLUU1SYm9lQTdLOXhvNDJBdG1EVTgvdmlPRDhPZW1vdW5kR1R1?=
 =?utf-8?B?V080RkN1MmJ3Und3RGVjQkZ5VkNjbmd4V21wWGxlei9NNHB6V2dTZHBUQUlP?=
 =?utf-8?B?dEpGMFZ5dm5qR1pZTXhYZ1JhdUpyNmNDT3VDbnN5VEFFdVFvM2lCQWtYY1do?=
 =?utf-8?B?RU85blVSdXNibUFJNUhQVXV5NXhTeGMwMkd1WGpmcWw4OGJlckZPZFlvN3dx?=
 =?utf-8?B?SWUxaDJFdzYzczBNQUpyZ1pweVhuMmZuKzR5b0E1QUdVam84VU1ITGtxbklR?=
 =?utf-8?B?Ry9mR1V4bXdaL3lrQ0Z1S0NJZ0VNUDZqd2UrT3lvUlloTGt3V0h3dWd5Z25T?=
 =?utf-8?B?OWQwSjlYRmI4Q3BWVlJIMHZmVFdxN0FkVWVFaC8wZG56M3RldktuZnYvRmlm?=
 =?utf-8?B?eDQ5dWg3SjJmckxvRW5SUE9QaEpqSWc1WFFSNmFiNkFSQUFGU1pDb2Z3cC9R?=
 =?utf-8?B?enNuelJhdUNPOTQ3TlpYUlZIY0ZPTWJpcklWblhKTjRWY2xMN2xSNTk2YmN0?=
 =?utf-8?B?S0dGRFc3TjVISEszOElTbW03RGdwVVA3Wmh2cmNxcGxWWWYzZXh6UlZ0ZG8r?=
 =?utf-8?B?MHdBRzJIQVdtcXBEc2dodkVhUXFqTGY3WUl4OVN0K3M1dDJBSHVublBqSnE4?=
 =?utf-8?B?ZXBtMVBFTjB6WWMrc3dLck9zWEs5U0E1OTExRXpNN1FxaUNKUSs0dFZQNXNC?=
 =?utf-8?B?NEVpTC9GWVhhOEZLaWFOMjBqdVhubUEyOWV2aFNZalR2cndGZldnSE1NYWxI?=
 =?utf-8?B?cmF1QStNc1dxbTZyQStmTzhScDFqRVlXTU1ER25BckZLZ1FkTkxmd2QvVy90?=
 =?utf-8?B?YzRGQmoxSDNHZkpKTnllZm8vemVVMVMwbU1qT0doQXFueEt3Yld5aGpLZm5S?=
 =?utf-8?B?dEtRaWNJZ1FRaXFYZmdYemc3K3d2SWtrSk5YQk1zdFdQajBDS3NtZHN0K3A4?=
 =?utf-8?B?TGhjRllBT1hpWmhpenU0cXpPNnE3em0vNkVPdDljQUNuOUxibjlpOFdrNDRF?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f62cf99-0226-411c-a0ef-08de2307f4a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:57:01.0142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGtXgYdjmBHESRqrywWMDZQVo3ZlF1120coT09lgdY02aIVDuCfSidF5EmtEIXKm/aOfCPVFmNRbrgH2nq70h0MpmpIoqUau9LzO9i3eIAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> @@ -400,6 +399,24 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory

"an" -> "a"?

> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs for telemetry monitoring events. By default,
> +		resctrl will not enable telemetry events of a particular type
> +		("perf" or "energy") if the number of RMIDs supported for that
> +		type is lower than the number of RMIDs supported by hardware
> +		for L3 monitoring events. The user can force-enable each type

It is not clear to me how the number of L3 monitoring events is relevant here. This
is addressed later with the "The upper bound for how many "CTRL_MON" + "MON" can be
created ...", no?
How about something like: "if the number of RMIDs that can be tracked concurrently
for that type is lower than the total number of RMIDs supported by that type."?
(I am sure it can be improved)


> +		of telemetry events with the "rdt=" boot command line option,
> +		but this may reduce the number of "MON" groups that can be created.

Since this includes "CTRL_MON" and "MON" groups it may be simpler to just say "monitoring
groups".
	> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
> +The upper bound for how many "CTRL_MON" + "MON" can be created
> +is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the

...

> +Debugfs
> +=======
> +In addition to the use of debugfs for tracing of pseudo-locking performance,
> +architecture code may create debugfs directories associated with monitoring
> +features for a specific resource.
> +
> +The full pathname for these is in the form:
> +
> +    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
> +
> +The presence, names, and format of these files may vary between architectures
> +even if the same resource is present.
> +
> +PERF_PKG_MON/x86_64
> +-------------------
> +Three files are present per telemetry aggregator instance that show status.
> +The prefix of each file name describes the type ("energy" or "perf") which
> +processor package it belongs to, and the instance number of the aggregator.
> +For example: "energy_pkg1_agg2".
> +
> +The suffix describes which data is reported in the file and
> +is one of:

(nit: unnecessary line break)

> +
> +data_loss_count:
> +	This counts the number of times that this aggregator
> +	failed to accumulate a counter value supplied by a CPU.
> +
> +data_loss_timestamp:
> +	This is a "timestamp" from a free running 25MHz uncore
> +	timer indicating when the most recent data loss occurred.
> +
> +last_update_timestamp:
> +	Another 25MHz timestamp indicating when the
> +	most recent counter update was successfully applied.
> +
> +
>  Examples for RDT Monitoring along with allocation usage
>  =======================================================
>  Reading monitored data

Reinette
