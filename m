Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A5C1DB55D
	for <patches@lists.linux.dev>; Tue, 26 Nov 2024 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646594; cv=fail; b=KLQbl71szmUG1xt9KwYrRYd5bBjGVd6H1V7DSPQNttUlNBVPI8gD998jfUrMw8xEefEzZHWIumhxoZsnL0fFy4VQ990sdN6gz3HV8OJourI4ER44Wel44KVHaHgUiFhIPju2Gz1rpfVvyQnKzT0yvRnOJLjBMvdhB4SPqjTegv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646594; c=relaxed/simple;
	bh=Ya5KhRd9KDc1iSSDhgYnGlWsXC70K5vvONlMqfbUSVI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OHhH7qAbLLRJDmT7eMOz9OaN+wPgYn5vcOjQSucz6FdMr0bJpeOvN22PvwUgT1sce9/8aeErnf5JUkO8LDodHnHpIM/VT6kkjgiQWaekEk6kBX6WCbEfWI8XMK7Ug1wCaCePOYLUc49buXb6RRIdzoDZ5camHNfrMU5QjwQFZLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TRjX1jVX; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TRjX1jVX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732646593; x=1764182593;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ya5KhRd9KDc1iSSDhgYnGlWsXC70K5vvONlMqfbUSVI=;
  b=TRjX1jVXuL8rgvOQ4kAwp64cpOGtK5L5AfMIHuEBU5Yw2exu0D44kn4c
   rZ+KRGdqK+PdFquYiXj3lRO3PbewCGLKt6ct9fPw4a+nJ6LViq1YdEtde
   gzXo+ZZnAjrwOq53d6GZfgh1MQwIe7fNScf4+4MPRF6mt0L3GSKa1q63O
   RkWSWAIQL4MDLJu3/iQju/O+mX4izYvstqWgOfvghpMoD/R+hxWAAJu16
   YjTkiSTq4hBSmX0FBZiEcLd82vPFVhA+vD2TPMBcE3DR5fJCHJry2unth
   RoKcapzfltoHVeryskkxzOsvA1d97ZjUF6Rr71TPM/0WNHTM8j6NkFgyo
   w==;
X-CSE-ConnectionGUID: 6b5PlBalRXGQBNJgivaoRg==
X-CSE-MsgGUID: MVrJZmgcQZqpuGAw0AbEPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11268"; a="36614694"
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="36614694"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 10:43:13 -0800
X-CSE-ConnectionGUID: +nmmmq8GRqOhE/rCHccMLA==
X-CSE-MsgGUID: gyeF9TjDTnqYjkX5hAwC/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,186,1728975600"; 
   d="scan'208";a="129219543"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Nov 2024 10:43:13 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 26 Nov 2024 10:43:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 26 Nov 2024 10:43:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 26 Nov 2024 10:43:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YWJ/WHRjXzaNwF5Z94CwT0St9ZOrxEeCusLTLweSi/F05fu9AD1+GnBH5kbbr6IdsYUd309X2Hm2wDEnvGMTZ92e2/3Ifsx/Jnw5B0gsmZYHSVnIRmHUrc0VUCh/67+T04H8z53BC1XLXFcIiXSznEkW5j8duh16Fhle58+HlBmfPmBh/3mrJi+m/kTpjYGlqDJs9jrbZaswJSnaQItduP3tzIUCNQqTqHA5jSIWtx8IbdeQX6O6+nxNY7nW+1mJO0gI9C7yCy/ADN5kWlaEVG/P0OOJZ1OgtiBuFwUqFNFLCCnPMc3IV+as4F5spKgq/yqLDvjAmgFTgBjkmBpJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FY1zDieg5o1triI0vwnyiO/I015jQ22p0dRqvnQ1pA8=;
 b=Z67qSg9+F6Me2uz3VHQVxiki9NQsKc7x5Zo8eMFKPEmhtxksLuY3JsRNPi+H39lYV50q+maf3o8h5eWMhvJPWJOm0yRvL4eA2hKgffiHYMY2ouHZ8qrl1pqEH3Qx96K69GwdyoxaQN8oa6jj1m3yjxJuMkruNKoE+BoAgqxfAE56X8/Da4r15Lfweo0YvDm5b2k63kE8SNmcJ9y4XeDWtdm4ysAHnaoUzi6nji7o/DmcVLkWchOk0W/doVtUnXxUxKKhsplohTOVltloEHEcPGZrl1vzgiThe9tzy4NCe59lXDzmU+Y7AG08xpd3xnKBf4h/SGW7ECMY6ZczgS5dIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB5904.namprd11.prod.outlook.com (2603:10b6:510:14e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Tue, 26 Nov
 2024 18:43:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 18:43:07 +0000
Message-ID: <4f3bb85a-dd6b-4b4a-bd2b-58a9714f5b5f@intel.com>
Date: Tue, 26 Nov 2024 10:43:05 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 8/8] x86/resctrl: Document the new "mba_MBps_event"
 file
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241122235832.27498-1-tony.luck@intel.com>
 <20241122235832.27498-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241122235832.27498-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:303:83::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e7d9d0f-580d-4910-43f8-08dd0e4a2b71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QTVCSkxKK1Vmd05UQjkzWnVuSEdETUtkTldhZnhBRy93dmhRaG16RXQ3SnBt?=
 =?utf-8?B?amJ5Z3YwNk41d0NWTjg4aVBrNHN2WUQ2ajluRDBQdUtUeFVPcEtVTDhhM3Bn?=
 =?utf-8?B?U3pORXV3anJtQW1aWWdmbjdMNmtNOXdseTRHbzRRL3V0ckFMZU8xYVRMci96?=
 =?utf-8?B?NDdSQ0pJTmtXY2ZZa2t3R0NnSTMvUTZIOWhIM0pYL3A3OXBYY1NJRGg1aStN?=
 =?utf-8?B?Wms4eisrOSthNjBTMEtRcUFHK1pkU3JHY1lickNrNS9XMC9Na0JTWkJtNEd3?=
 =?utf-8?B?ckVnYWI4ZnBodWExU3piMTJqbHZwTE14dGJKUkRsd0ZXRnYxQlN4UmVJSGZl?=
 =?utf-8?B?dXBZblZWd3ZJc3RoMW9XZWFYZ1REcEMxSHVvcDFzQ0lmbXV6YXBpeWtzQ0x1?=
 =?utf-8?B?VjRvQjBtdjkrTmtBRExFbXlReld0dDhsM3EyN1BpNkdiODhaUUlkQlAveUNn?=
 =?utf-8?B?UEZZWUtkbGhEc0gxKzh3Y0xTTGF1R2hRckRPdXlyTHVCNkVXS3pPZHlFSUhi?=
 =?utf-8?B?WG1OKzFoM2FFdUYyV2hSVFJjczlFK09tNFgzdStVbUtmUW5FS3dkdGRwaVhS?=
 =?utf-8?B?TGE1ZWsxTXVLcHZkNnpBRURzMGxSTXRhelRyRWtmeDg1ckJSWk0yTGpMU1Yy?=
 =?utf-8?B?NE41cGE0b1gyR0t3Z2lXUzM2RkhOdXgwUVVBQlovaHhXLzFxYkVJMHIwaHI3?=
 =?utf-8?B?VHEySUdLd0h3SUo2NXFsSE5DTkRGM3NUNysrWlFjalE1b1BkMFQ2TUFpTjJB?=
 =?utf-8?B?bmJhUTVsTHhuVnUxQTR5WWkzQWxLRFJySFA0M0pYR3AxOE1rbjZEdm5LR0hS?=
 =?utf-8?B?UldkYzNOb1llczduL0REcUtiMTgzY1pyVzhEbFdvS3ZicWZKdEZaQ3VhQUp4?=
 =?utf-8?B?a0dqT2JFZjE2d1pIV0JFSFlnQWpWdUJvbTE0MmRXV3N4d1I1Rjcyc1JKa1NT?=
 =?utf-8?B?djJGanFhMFEyYjVGcXphNjVxdDhNdFpnRmRtemUrM1FFTGZpYlJoUExJSmJS?=
 =?utf-8?B?d0crQ3BpUkovakcxa056dWtyN3NWTiszd3RvZTQxQ3pBQnIvQkh1QTY0c2xi?=
 =?utf-8?B?RHRTb2p3VWhQMzlpVzhGd2JBNEtLYTBTdVJYN0wwNjZmelNuRW1sUkpWbkp2?=
 =?utf-8?B?ZDR1Z0svWlhmRGZLQ3dmSmJlKzk1L2d2ZW1ZU2JQM1BzeEVzUURGN1p1dUkr?=
 =?utf-8?B?TXdKUDZpQW5oR3h3elVGQXUweEJaN1krMnRpTTBENnBSQ3daVHN5am9zSHpp?=
 =?utf-8?B?Z1Vld1Y0YzVWMUJjZHFKZERiMGE2M1ZiaFNsc013WTNKZnFVNnU5Z1lpdWZz?=
 =?utf-8?B?NDVKTXJuTkVNR252bmVqUjMwRmZ2cjJ2RmdvZ0t3bTE3aHVveU9NOGIycWEz?=
 =?utf-8?B?QlhMcnp0VkdZbHZGYlNVZG9QekwyeEt1Y0lCSCtaaGhtbkpFcUxXd3RTcWFH?=
 =?utf-8?B?TUFqdUV4ZlRWTjNheTYrcXFqQXMxVG5paktGaFhoOUorZFppcGF1Ukp2OEZt?=
 =?utf-8?B?eGFRa0RDMDU0RHdYMUp4T09EM00zZDAraHNXRHNmSitHV2kvYjJURlVEbXhR?=
 =?utf-8?B?Q3RUWEhBY0ZIYUpVdUtjMEdkbzBLYm1VN1BJakFqcmRvUDZuN25oZHhIbHV4?=
 =?utf-8?B?d25BUjJ4ckRtaDNCYVZMRmVFWjdTM1E1Ri9SN0VjUXZFeGpPYTRsRlJFRldz?=
 =?utf-8?B?dFpqTzVnNU9xS2FUUVNuaHlTQ0tWSnJWTHFMQ1dSaFJyZEkxSHcwK1lGV0li?=
 =?utf-8?B?Y2RsU09XZGVvRmZTbG5JQXdDZU9PUSthUHVDbkhHMSs5YlNlSE9DcUdaeU9z?=
 =?utf-8?B?bHdEUXBTU2RCL0dobUdkdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDZKMHlRdDFFcHhqdEtUcDZ0TjBwM3VCWW9kNnZkOXZuRFN5L1BpV1NJaVA0?=
 =?utf-8?B?S04vdG93dXhvSzkyY1o4MUpsYm9MRFhrTFZzdXJoZ1ZQRnJGdHVJM0dzQ2FX?=
 =?utf-8?B?cHpPQ2pnMjJ4VWZYVHVGVGZaeDU1TmJzcmhBMnlMcUpCMndlWGhjMllDUGNL?=
 =?utf-8?B?MTlET25WWlMxSWdYV2l3NCthMkd6TUNQcnM0U3hya3Nsblp1OTBJUlN5UFRl?=
 =?utf-8?B?ZVRrbFhpYnFHSmxvd3RIc0VnUy9xSlY0aE1tNXFmNnFUU1AyQkdjTGl2Rk9r?=
 =?utf-8?B?bVdGQllkejlBazFxOUhuUmV0dnhNSDczSjVFNGVCVUErZlVxaVlxdmJEMFhr?=
 =?utf-8?B?MEh3VEFoZmUzdmQvYUxjWW96dWVjQ29yNXE5UXIyb2d5cTV0UGsyLzZ3eURK?=
 =?utf-8?B?clBpU1F6Q05lUmRremxXQU9WSjJpRFh0b001T3NDV1l6aUNTa0FoUlJTMGIz?=
 =?utf-8?B?bmJ4d2V4UGNCVXA0R2NSME5nYlJpcWw0LzlNa1hKb255dTNtczY4R0V2NlBW?=
 =?utf-8?B?ZUYzbjlJV3BBcENxdzFQSndwdmFaQTZzVjRqaFFGZHhQYzM0bXpWcG4wMkUr?=
 =?utf-8?B?UjZjSDAweXRtQjhFVk9Kem1DRjF1Zmxoc092K1VRSjI2b1l6dDFPVXIwM2pt?=
 =?utf-8?B?UzZYMHFEc1hMMitlUVpHVURGbHpoQ1BjQ095VlJXRldYYnNVUkM1UWswVVZs?=
 =?utf-8?B?NGxsR2JtZFZyWU1qcG9UMzUxeWp3RVEzT2loeE1VcDJ5czFYVXhHQ3I3YzNC?=
 =?utf-8?B?cFM1ZDYyMUJ5RTRLcTNQYUl3aFdKZ2V6VndrZ3VBWFcwRy9kMXNoUjNaYy9p?=
 =?utf-8?B?Qi9Ja1NsUlVPMUFMdkUvZk16bDhEQlNTOWZLVlI1YlpQL1JlV1h5TTRRcWYr?=
 =?utf-8?B?Wlk3TkI4UXg4YkF5VHZVQkNsVTlvN09sOXZiUnhLVW9wR1dDd2NPU25VVzFQ?=
 =?utf-8?B?UmVJRXBvM3Q2NUJwUlE2UDgzenZib2xVZXBsdldKN1VFNUhyeDViSHNxaVNu?=
 =?utf-8?B?NnRZdDFHRFM1czEzbysrYW1JSFMvNkYxU1cwM3k2Vnc1S21rd29ZZkg2TTBo?=
 =?utf-8?B?SGdlQVZNKzA1Z2NpRnljODArVU9JQUxqUVB6RTYybk9JZ1dFR2RxTFdnSWVl?=
 =?utf-8?B?czVQQWlMTCs3YXA1NFlCV2pnN1pZQjBwL09TV3F3a3JpZGt4S3RSOWp2Ynh2?=
 =?utf-8?B?Uy92ZWpYUm5QQ0VkdUFHdzZzcytmcWkrYjdMamlVbDFsQnhqN1Q0S04xSWlM?=
 =?utf-8?B?eStoYVAwTWM1QVhDYTRZSmlOb2w0ZmNhbktWVHpWb3dVWEVxQ1Bmamd5SDFp?=
 =?utf-8?B?dk5hYVBLUktJQzJKTXJwd2M5Y2p4cW1oclFWajltN0VGMFJOQWZ6NklBa2gx?=
 =?utf-8?B?aC9iRkFPY2lGVWp2bTJuTkhFUVJkYTJQV05WLzljeHBDMzlDa1I0OG1DNUtW?=
 =?utf-8?B?allJcEdCYTJaNFZ0SXZzTndDVXdvMGpLNnU1bFo4aTIxSkgzbVdQeFJ6SUxj?=
 =?utf-8?B?Qk9sdVlYUnlYVTVwd3J6TFBpNkhyTTE0MUhVQXlqVGRpUnZOc1hPd1VZOXdp?=
 =?utf-8?B?M1RmRDl3VjJTcEg2ODdCUXNjYjU4c1lUd0dCd3R2a1lieTZWaEZveitiUmNy?=
 =?utf-8?B?Y1lIVnQxWFZPTEpkSjN6K1lsR1Y2Y1c2MGRRUUFLK3lxNDF0Z242WTF0ZnZP?=
 =?utf-8?B?RWRKc1ZxcjlvOWN6SHQvNG5WZUtNdGZDN1grOFlLbVhPa09EQTZLMFhLTyt3?=
 =?utf-8?B?RWtDajZHeFJ3K3c1OXUrdzNXYzlodVBHaTF6a0F5dkgzdUZSVGdMSnRtS2s2?=
 =?utf-8?B?d1JBUWtlWmI3bkVSeTMrVkZLMG5DeHpobG4rVUcwTkpyV3ZCYTZ0cXpJOGFM?=
 =?utf-8?B?L2FTOCs1azdBYUFUOHIyRmFKK1ErTG5GQ0UrMWVLcUY5bVI0TXQ5UG9OUENz?=
 =?utf-8?B?UFdlT3pkdUFWbXJkMTJBMmw0UTBxbzFUK2h3bjh4Sm8wOHlGUUdHREcrUHQ3?=
 =?utf-8?B?OEtRWWYyajdpZlhUa25hZlZudHF4VTRVSDZONmxUbmhtTkRwamFSZjZXTEIv?=
 =?utf-8?B?QXZTeU5iT2QreU11ejg4bHNPNU1SZFZGNHpxNUF6WmlMMTNIcnIxR1lIRjBG?=
 =?utf-8?B?MnE1MkRkZG5sSjBtN0Nxa205YzkwUnVjWGIrSnN2cTkzUDRjVjM5YnA5aGY5?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e7d9d0f-580d-4910-43f8-08dd0e4a2b71
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 18:43:07.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Un4jZZyLVWJGnzr3VCz/uzEWw6GmP5lfbugs7UZVlvnUZo5zOk3yloaWIEAq3LVKbA8hFroaSy4MynXzu6FG2jXYeNvO+aps4o2fy4VztsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5904
X-OriginatorOrg: intel.com

Hi Tony,

On 11/22/24 3:58 PM, Tony Luck wrote:
> Add a section to document a new read/write file that shows/sets the memory
> bandwidth event used to control bandwidth used by each CTRL_MON group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
