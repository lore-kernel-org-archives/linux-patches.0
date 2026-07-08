Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C9338B14B
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551671; cv=fail; b=OI1QxPFOHF2v/levIYVAk5dOwfejEZh8HfSxVqDEPcBlFttJBaBKogQEbpDn37LhjLMs/dbf+0GJPJfDuP8MJfuMN+UQLRBbwVYE1Gr0Z8L/i4qqfNbsO/NiSBqcZH9uPX7I8QmgBzrxsqdn8HEyQNzXNgsfqWi0DIHVH7M2cLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551671; c=relaxed/simple;
	bh=PSfuf0Ax6PghnWPtzXG0JxHypuX0SBPF9K4FqPAc+Fw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZMNpJuHm2Tl0BU8MPLPZiG9nldwwkWedn3EILxgyx4KgMER7Lrxbq7PJagY4szRDvlxpBboylHlgS7A3AhpDvNXdkRnglpFDrWlrQps+XRIhxxTIENkir24FUajzZ9Ierrim8z9YFfZnUpMrYjAiXBEGMQBf0QrYIEE2cEALhZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6a2NTlD; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6a2NTlD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783551671; x=1815087671;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PSfuf0Ax6PghnWPtzXG0JxHypuX0SBPF9K4FqPAc+Fw=;
  b=B6a2NTlDYCoCVt2Zt/byfCGoeUzggasHFn7bAWzcxCdf7od10tMY7y12
   sbhbgjgZzfgkmYEEHfS7n2OiOCLKwwOR8p2325aI832kGbaTw30ctqE/e
   vY4RQVL3CDLS37sW8lQCx6NPmFS1TLZgjgDCQDkYssE11HMyUm6epO0iW
   qNOHN8GNe5kWBh++YmMW25wa23P0XeoKSkGUClc0LY8JCrtrcs8ktoUBJ
   wazbVV4zvIXQogmZWCXPOA8Tf5QVBLjly5G2A3RScxpPPpl39NmZMFBnh
   l+YIsk1YAwUN5hipTVvruVRCa9QMKZYfBqr7orF3aBFIP7Km1kCldnn4I
   g==;
X-CSE-ConnectionGUID: Wnp7UDHPSGKPdci4EPxCOA==
X-CSE-MsgGUID: eqda5p/kR92hVlAigamxOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="87912942"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="87912942"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 16:01:10 -0700
X-CSE-ConnectionGUID: BG3sy3msS1aQS4NdP+pINA==
X-CSE-MsgGUID: FMUasBp2Ss+Sb2BSN9Xu/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252667725"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 16:01:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 16:01:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 16:01:09 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.13) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 16:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNuxXFbDGFwUBmyygZRfmhni26FHrl5SnADy4d8WM8jWyZ1FB1iUmMEFWC/wvoB2vk0p58THewBayZidvoLmzYqd/OAwDP10WU2kTHmSLxwp7VIyIJKGECQuILyMJzom+gVMXbJeP79ZBB0vYlDLUcf1xy9rGFhlvxAHvKoFH3GJPT+O9K9TiwfEX92aCTFDEpqCZRwdpvtpzQdGTS1YJehX+dLrFFayafO++TkRq1pUTzjffSLu4cXh4wD28SzblAafcjQobw/J+ibH5fEsEKjT4x3pkok5Q+o/q4ovlip9oI7dkyceFIQ02r/18uF0ofQnq6gDUVX1hLn8mgekfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eZ15HA2sy41npcf3kFlo7otTLxe08O+j7CZ77/eetc=;
 b=NjNKmqNvI9FFshNwyqD9yEDrZXqfPIdR8fDxgL3GAsBUJzn2NMOtz53N/cwJ9qySL7h6UbRGtqrbH0oAQ9q8+LM5iYEnrIOI4RzquzvKUdBq2PCSLakdEf0EnEfjaWx/OiiIUCN5eEm4s+az+xCI2nRN28dYzdmfK9r6YtTkXlvTe8WRBO+r3bVAnc1Dcf8l1rpC9eSYJVGYB66YcGUC36Zziur9gCHbPf8+sOSAEDLUQMNzc++pm8WcGK5OQzvoBcF/L7G/jao5K26SKFerThnZ62E7ZGsdbQUKOCcbjudRDvx9Bn8qEQdg15grmgh2+w/xm1eT0hocaTzTP304Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV8PR11MB8771.namprd11.prod.outlook.com (2603:10b6:408:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 8 Jul 2026
 23:01:02 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 23:01:02 +0000
Message-ID: <87950b8d-c7f2-42dc-a2ca-2d389304ef16@intel.com>
Date: Wed, 8 Jul 2026 16:01:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/12] x86/resctrl: Simplify Kconfig options for
 resctrl
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260701213553.15222-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:303:16d::10) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV8PR11MB8771:EE_
X-MS-Office365-Filtering-Correlation-Id: b87932b0-b0b6-4f84-8cff-08dedd44c889
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|11063799006|22082099003|18002099003|921020|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: JqYAh+YlWqewqNjlzelm0r0NkOOUxdWEEo+qVWJwXSqz0g25jHkHWrwclCBXkR6iF8EtH0rT0BTXWzKhP4qoQ2KVR+qkFWFdQLSfYFYl0PK/D70Pa2u63nffZbjTbSNWHcltqIX+xB/1ZMZ45Ebv+aAaBpqa+nBJDQ4SsLI2nGtFXYRJ1mXtzTHwJzg0rBR+GpE/yCxHjviepf61IKSGTUCk9yN29kHunUAzpEaU81ZobJFFbPN1veBz36wzi7S+v5OxT7blduNWymSTqmvMrP7Uk5Lqi4vq/XN3IinY4OiPO319JVFqxmgSXf6Z/zj8bQn3WwPN9eCiBOubuKjX9xmgZQ1VnIy7SXkfu5lCXeJmeaukfC+XpILcweXxKu2dh7pG/M6sJyYMPaKgbTlxF1nBeQWETzYs2G9WU39XN+TnU5h+X7anYS32trh1ySdBUHWOqexaS0Sdvl03gRI0bJXhwn9pv/cCbqQGFbpxJ22voaUn0kMox+f3FJPDd5Joo4PABmsmQHPIf3Rd/bejhwvrcSXSj/ExhRAAD+CY/dgsFQrQWhx/AvTzfLOcrdegd+7MXIqF/sdQQOwijWfShRikii+u51HsGZ7/1O8NNcQ42dAwDhxAKKV8FIGbK3tc3qR0mC5++D+zBv+gJVYnWHqBDABNPQs5O3sP1KKU/ryMVSirvFF7qd0G7F13CqGQJ6HgRneGbLDI+Xy4yV0Mow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(11063799006)(22082099003)(18002099003)(921020)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1c5a2xxWkVnMWRKNndySUJFRXhvdEtOcFpwNnZEbUVwckc2bDU3NGd4cE43?=
 =?utf-8?B?Vmwxb296ZnRLVmljVUFnSDhyNG5BM09UUzk0Y3I3bERZSU51TENRbzg4MDE5?=
 =?utf-8?B?Ri9jR3hBTlVxQ1FKeDFFNXZYR1hCVVN2S2laam0zczl4YmVnUVllSFlUWWpH?=
 =?utf-8?B?WUhoUERNNTFwSHppZlJIZlJGcHgzVVBIYUZyOEtxRkwxaWRud3hjUWRIMnNC?=
 =?utf-8?B?VXI0L1k1L3J1L0ZKa0FnbVB3ZlQ2SWYvaDNZbDlqSU5YcWtwc09IU1dHQk9p?=
 =?utf-8?B?WlVDdHNhazFVOWRabnJXY2RxSldiQmdaODhIZGVuRmFWSFlQMEcvWmhCalY1?=
 =?utf-8?B?aTVQTU1OTHZQbkFMQk14RzBjYTI3bkhERjMrT3JDcFkxRjdCTUNvRTVlOVZG?=
 =?utf-8?B?dzVtUTlsSkw0aTRkOWlTOC9UU1VjNGtQOU9Gc1V5c1I3VXdabTdLOTNXTmVV?=
 =?utf-8?B?VlpmbktzY0UzNGd6Vno1bE5uY29KajE2V3l2UGZ1U3d2VEpNWmVFbWNjWWdI?=
 =?utf-8?B?RlM0eCt0a3hlaXBHUjhISGVSVmxTNUN6VVQ4bSt3NmNOTzc5Sy83aDlUdEJO?=
 =?utf-8?B?THlOMmRicHBSemRqclVWUU9lWUNtNW4zNDdSWmwzRW9lNGNVMUZKbk8yUDA5?=
 =?utf-8?B?cFFUQS9VWkNEbW9OM2FuRGxTRm81S0JIWXZZdXkwK0lOTWNFOXN6NkVGZnBm?=
 =?utf-8?B?OXhhWnNRSDF6QkhyU2dLMXRxVE92bnd0OHZSckt4T1gzTG9sdlp4U3l4RGlN?=
 =?utf-8?B?ZEF5L3RNWWhxSFFwdDRWZEN0UytCbnVJZFBCWnZ3ajVFNjBkTmtNYXJqSkdQ?=
 =?utf-8?B?dnBxak1uWUsxSGNEa2JNTWtvZlBEMzJYRG5vMkxLSU16SUlpSUxVRU16V24y?=
 =?utf-8?B?RllZKzAyOHE2R2ZuN01YSUhFSUc3dWQ2Nm9iV1V4dFhSN2dtWURDWGlGSG1R?=
 =?utf-8?B?TWkzUG1Bb3Vhckp0LzBaY0oycEprVCt5MnU5eWNjbGtoZkFBTjNBcTRYazZI?=
 =?utf-8?B?SFFUN1BVOHVzOFRxV0ZEamg2WVFNdzVWbGVKOTlnb1lyTjFUWHdWMzY2cTRx?=
 =?utf-8?B?UDBLb2Q0ZEZGaXVjSVRUak1RZmtaa1lqMUpDWkJBOXVSL0NTZ0ptbzJhVHI5?=
 =?utf-8?B?TnlwUFlDU3VZY2NhY20zSDUvL2xCaUorQlJYbkIyOVY2cnpJMXhEclB0cTVV?=
 =?utf-8?B?bktpUnRROStVTDlnNkNNZVdRU0lndlYxTTYvc1UyWTVKOGFES3phSktreThl?=
 =?utf-8?B?NWpEa2llcjViUDJ1ZHI0WjUxZ0NrVldLc1BFdk1NVmJjNTk5bGw1QTg3S1JV?=
 =?utf-8?B?UjlKRjdMQlo4cDFxRUZGcmxYZW1xUkczTU5vTFVrQUhrQ25ZQjBIQ3d1VUV1?=
 =?utf-8?B?OVU1bzFBZUtucm5ZTjFtU28zVmloazFBbWFaK0Njd1kyc0ZaaW5lZUtXOG9k?=
 =?utf-8?B?SlUwTFdBYUlkdkJLY3l6TDNST1RDVkpCTVlhMC95SEpvWi85OGZWWnNXNHJs?=
 =?utf-8?B?TDZZV1hHWUJrTGo1WHl3L21Tb2V0Umd1TGIvN0Nlbkk1a1JvUGRzMTRiMlVI?=
 =?utf-8?B?a25ZeDI2M3pxcnNDRWJGMmxnYUVtOGJHZDN2VzZkdWxJNUpHTGtUWDM0cXVs?=
 =?utf-8?B?eTFMZkpnL3k3Y2R4OVQvd214akhBSTg0aElwS2thSVE3L3ZZd1Rlc1poanZv?=
 =?utf-8?B?Z0FZS1pHVHNWUys2TDRMb1Y2Q2pYbktwMWk4MjVGL3diaDhhNVRFazZSN01V?=
 =?utf-8?B?VzNqdEpTYWVtRCtCakJFbTB4QUtnc3BKZUdBS0dETzkxenN2YjRvbXBRM2dC?=
 =?utf-8?B?Y0xFYW9hNFQ0RzlrTDEyN0RoVW9Sc25ZMGlWOVlUb01yamF5dHkyOEw1czFJ?=
 =?utf-8?B?SElvWWhDOHoxRWZjSHd4ZVpzN0pMWFQzaDFuYVpNNHFOT3AwT3k4R1FrWEtV?=
 =?utf-8?B?ZlZqNVVPczhPZlJZbHJRZEY3dkdSU3BDNFhQTm5KTHJveXdEbWRiRCsxYzZh?=
 =?utf-8?B?Yks1T3lUQXpublNIQTd6SFQ0T2ZnMXJpWEtMWUkyWGVZekdpR1BQeU9XTHRB?=
 =?utf-8?B?Y3JqRDBhRDljTThRcXQ3ZzRHRnVZbThaWUFleUxEQlB4b1E0djFHY3FNNlhK?=
 =?utf-8?B?RGZRTC9XRi95S01LVTJIUzFvL3lxWDRSYUQ2eFdFUnZzV2RtaEowOXBWTEVv?=
 =?utf-8?B?eWpEMUJ5WjRKZ1ZyVTlrT1lXenRiUm1IQWlGY0JnTG96N1NTeGVHZXdkTDNy?=
 =?utf-8?B?V1l2Zlc1V1o0N2xXeVp6NGdTQ2p5QjVOV1RVU0tNNHYvL2dNL1piVFNwRmJt?=
 =?utf-8?B?Y3VuUk9CUS81VGEvaHBWd3ZpZ3A0Sk9FMksyZ2ZYOHpvR0VzWXFHWFd1NW1M?=
 =?utf-8?Q?9U8COOEBnwaEVOFw=3D?=
X-Exchange-RoutingPolicyChecked: rzdAmIYNWss8vwtXQWvkSJtn27zxZnpac7yfY/YX0vLTQq76zQMek+fyMWH2EmO/CAB1xMuf+WFuSBR1hj+LiiG6x1E+meOj5U6uvUpXKZu+V9FOeZFsIvkWc2ur9WS4yRAw+7977U+2vlOh+IpYVaiIJ2mXRR8RmEBFGEOwyGwvdnBeo36y0akuDHbU4b2xGytsviAvPF0YSFGZNzWhZRWZHsrlEBy7LetopXbBIV8zRYt9i3+iwv3jL1V8wc15suzAOF19IRQdLthBdX++jjy+igFXfhU3ieH8uI3TRRH8vLBAkfa0eNKqZxeDzVZwtBhItMfqtRYGWBOMY52MhA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b87932b0-b0b6-4f84-8cff-08dedd44c889
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 23:01:02.6670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXw/boUFFM1x2ZMzzv4pHYYBSMdbBDxaMrL9QhJ2bpFbiv8kqox/W3EsF7Rpq8aWdIrRZ8nlVuuNGQ9K2XyEUZxDE4RaOAP1ZtlnclaQNgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8771
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> Linus Torvalds complained[1] about Kconfig complexity making it too
> hard for "random people to build their own kernels".
> 
> CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was
> first added as it required other config options to be set to "built-in".
> 
> AET now resolves PMT symbols at runtime via the registration API,
> so INTEL_PMT_TELEMETRY no longer needs to be built-in. This means
> that AET can be included unconditionally as part of X86_CPU_RESCTRL.
> 
> CONFIG_X86_CPU_RESCTRL now depends on X86_64 because reading telemetry
> data needs readq().

Above reads as though it is a new dependency as opposed to an existing dependency
that moves one level up. How about something like:
	Move the X86_64 dependency of the removed AET config up to CONFIG_X86_CPU_RESCTRL.

Reinette

