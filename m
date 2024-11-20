Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD478848C
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 00:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732063104; cv=fail; b=kSrqFMWiia2t3odjmWYYsEeg5WLoT8MiEl+66g/XjDLEK9midKivghS1BxGmEX4AveM7vVyL2yjH3xtJM6OZub5wd2EfB8qmMyuKS5FNST3h1+ohImJOa51H0+NWSrMJPDOOih5ZFDhUorGYzKVvnbJxpDfRxzdtl/vI4Xlr26Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732063104; c=relaxed/simple;
	bh=DKy4KENS2Tf2G47hyqzGA2dGJv1KA15rOIQ193oee+U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AgS3csRBMEXXU3LSNw1t3PFOuPWzalGvuSRG4yINDie5Qxp7aj7gPY1W7Ofmf9bI4MIMzerr5Ott13wLtr4Hv9s3ezrmVShur/RnNsWRPC6egg0V9dWHZ4k+jxM32qTpSrclt7vo0gXgvj5cdh+aLel0hruwHuQq5O8OKGCgIiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BH9cbQ0x; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BH9cbQ0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732063102; x=1763599102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DKy4KENS2Tf2G47hyqzGA2dGJv1KA15rOIQ193oee+U=;
  b=BH9cbQ0x1Oe9R0Yrt8v8cSoqNbUZlUb/3SL+SjsN7km7fVRo/uXjsSpK
   3exkUSLJCUkb8BPkOvKcxN3rADUC/DaS7eqybb1bPCZfwvCovsN9yDdWL
   SAtz+LnCkpSETRMQmNICxOPo6+nYe24RMx1GrL80FTbbof3UiCNrZDgYX
   BFS2ba5/cq4tlBGnwmcl6rxCwO7FEQpNmsmD4mR+E+uAEfXeH+FLxZgwu
   Km+yTRLRjeOrbK/DWEGGQFHvyK3wqmjhoff6JyBkvb0YglHuvNsWsByzV
   OfPWU7wY3Idt5d4SJs4+A/N8GiWKLlhRibFCAH+hBqdlyP/CMbxojDsqy
   g==;
X-CSE-ConnectionGUID: UxgqdGMpS+eTrTuDDvX5iA==
X-CSE-MsgGUID: k8nhGWsXRaCw1MlFNHAINQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="57504040"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="57504040"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 16:38:22 -0800
X-CSE-ConnectionGUID: VeNtQqOYTkq0m8OGkCTlYg==
X-CSE-MsgGUID: r3crC6L7SeGAZPbmr8kBOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89682929"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 16:38:22 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 16:38:21 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 16:38:21 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 16:38:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ae1Nv67pmBsAYLDti2CGlAD4YH5Ms6zZ/QEAQ+OwGkbubJqcSFyOTzFHw6f2rIbUZqI31N1O4CHx8dHXy2o+Bev9b5CJBl2/4puDjwRX8aEWCJUKIjOOOKpfajSuyxoUsk9kKDLwwVB3f6gZ+x2gkMfUWWGGghvbb4zr0/f2MCci/pIE9YLUJ7kl53omrniWqUZMo1m4kxuu14vKp1ebaqHxG/4oN4tOu1CNu5FbaPjFnrQur25Px2SVXtGthqm9K7LL7DBsoZEs3cfkIPHymFW3Kr4o/mMroTMq1JRi2XaUPL9pqkn+DO8RpetiCeD2U+mpE7ZgO8pL3GInPua1Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5fBb3AERaTZrTLYyygc05ZHkVuIMgzzyB3sarnvfbc=;
 b=kcilsj9Atg46FVfOIjavRICLLvPlUrI8bN16sVhSdVYZsS+yQWPUNl7iao/V2m7ristgDJYtkjcHJqMcOtxzYe1ULPSJoNSgLNUDN10DMFmAcS75zodCnPEZ1c9fnbkqtA4Xt8xFb3w8opiaNSzm4JIAs+0Eapta11TvhEMqgzoa8Rwp1zGzEUMVRTPDEzG5/z7SjQcEmOeP6IVP0Br5AUhFt0MU4y8ZtXAybvAMUh2HEmeanHL5J6AY12de+FmLaUO35vqEO6BcjGD9AxdLLPLETJVebH82EF2UBPs7kiGtzK/ONyzMTMR05gABu23Cse3mG4WNLaGYrjnqoYemrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Wed, 20 Nov
 2024 00:38:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 00:38:18 +0000
Message-ID: <dd1d284f-2138-4e63-8bc5-2e55ff9f0a2d@intel.com>
Date: Tue, 19 Nov 2024 16:38:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/9] x86/resctrl: Introduce resctrl_file_fflags_init()
 to initialize fflags
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20241114001712.80315-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:303:b6::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 11fa23e3-7a62-417e-f371-08dd08fba080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUoyaURvMU5kbHkrN1dFWHNjUUEycUQ1VGVxNk9UQW9rc2U3L1FKQUdNOFZs?=
 =?utf-8?B?SFdDalRPdndaeHMzT3FBU2lqSE1zM3U1anhlRW1HSUpUWFg0dEpQeTRDd3FO?=
 =?utf-8?B?Y2IydWFLM280SGVoSER6U0hEWE52Ty9lR01RUXBZZUplK0FIbHkweDNwQVha?=
 =?utf-8?B?OEZaL29nSGE5TkMwdTlRYVdjdDBFMUtmV2dQSjBaRk9pUkFWMVNnbDZTaFlZ?=
 =?utf-8?B?ZTZybGR1c0ErdS9Mc1pjT1JiV3VYUkREYmFFSW43ZkU4cC9vWFk3UDNXdHZ1?=
 =?utf-8?B?ZUQrUDJXbFlxTTVPSHdvOGtWRktzRjUvZkpLZ1NZem92Si9rdTVTV2NMejNG?=
 =?utf-8?B?N0RvaitMaWxzc25ueGlKbE94QTZMRWd2bG9GbHhLT3hSY0RsMHVyRUtOYmdD?=
 =?utf-8?B?akNWOU5GdW42QWIwMW10aGdnWndZcGJ0TE5DNUNDUDhncGYyb0U5OUdqMGtB?=
 =?utf-8?B?dWdiK1JRcUJmbC9oSzF4a3Y5bjZPbDd0YS8xMnk4SkN4RkQ0REg1OGQycnFZ?=
 =?utf-8?B?NU53dldxYVZ3OTA0b2dJMmp6ZXlrZnhOWGROTXZNZnZMdnVqelliMXZ4OTVn?=
 =?utf-8?B?K0JwV1N0RFZkREpYc1RqWnN0WERwVWlzQnd2T3B1YlBOeDlsZXZVNXdkVmpJ?=
 =?utf-8?B?YlVUWEpLTC90QXBBRDBSeEtXR0s5SEs4dXQ3NkluTTNsS215eVd0bmJVcmdW?=
 =?utf-8?B?NEpKemNnS1FSYnJTWmxHVmcxeld0dml2Z2F3eDd6QkVaZ1EzalhwbUVVTnZh?=
 =?utf-8?B?bGhRT2lrZ00xWkZCOXVjRWdzUzRMMUxJNy9JWkcrQ1U0SkdLZ1JPS0J6ZWxJ?=
 =?utf-8?B?MTF1Zk9tYWRESG1SdVVKL1VPZUhxUjQyMEx5cWtIUUZqTS9KVzhGN3FJMGIw?=
 =?utf-8?B?c3E1MjIxeURhcTVaU2NmMWFudWhJNUIyK3hvaFdEZFpLL2JZbkdMK29hWnZY?=
 =?utf-8?B?SkZpNE51Vy9FMlpEVVFCUHd4WVBxRDdsdzNSM0FkdlRSbHFleE9wL3JEQmx0?=
 =?utf-8?B?a1l5RVhlcFFZNXdTNXlpaXI5RWJVQnEzZFlKZnpETzd0cE5heUhQQWVCRjg1?=
 =?utf-8?B?Q3gyd09tZFBoTnRFZlBjVG14VmkzTzJmSTZ0eDFaaVBnY2M1a05kUUMxbS9O?=
 =?utf-8?B?VEV1cUNWMzVDai82MGE4MGJ2eTgxWml3VUFPeEVybHNsaFNGby9VQ2xJc0Vu?=
 =?utf-8?B?TTIwSGV5UWhHTHJkeUdaWUlCRTQzV2lkZ3RjNlczTElVYmoxWlVhU2p0TGZs?=
 =?utf-8?B?VS91RUJCVDkvS0tBOXA1ZEdMaDFab3czWjJ4K2VnVEI5QXdVaStUWVdTK0h4?=
 =?utf-8?B?OFhGQUJsc0E4VmQ2TGd4ZCtGakJqSVNXMzZRZlN1UFk4ZTZiWXgyT0c5cGU3?=
 =?utf-8?B?L3hIM2lQbzhjRUlMUjBLWEkvYzYyVW5Db2IrVU5zbDFwbVQ1WitnTDFJVDV6?=
 =?utf-8?B?UVJPSXlqbmYwTTBRYnJDa3B0Nk1jUFJ6S3VlUTBWWWh0OXVZSWVuem1zQUdk?=
 =?utf-8?B?NlJGOXV3S3ZhcWp2aEErbUphZnhmR2dUOUNXdFlRdE5pb0RZZ1ZaY01wdUp3?=
 =?utf-8?B?cG9QVXl0dERnMnNyWkJUSThaQXQvZ3lPZEJSRG1oYlFpcEdMdGFBcDQ3c09k?=
 =?utf-8?B?eGRIeWRtYmNKcThuTjY1TmtybzZBTWJMdytIQThGdkpyM3RWREJDV3RqMlZu?=
 =?utf-8?B?YWQzOVR5M3lwR01rc3ExdHczb3ljbUlWUnJIWTFWVFBBQnNNU3h4Zkp2Rk0z?=
 =?utf-8?Q?mR6AoPsPAZ05q/Mhns5qEn5lPG2Ld3Vvq89WvV7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjJOVUY2Rk9NSjY3YVdsMldlUEM4SDlCQUlZRitzemwrVHhkTmZTWW5YSzQ4?=
 =?utf-8?B?bWh5ZS9DbTBSRjlTMTYrU1k2RmR6ek02NGRBVEJXMWt6Z2x0cWNKUjZmcE5l?=
 =?utf-8?B?S1RPTUJzd1l0Rk5QTW1TNEE4bE1UMkZzdUszTHhXblpObUZ4ZmV5QkJER2Jn?=
 =?utf-8?B?MmtZK0JYaEZOc29naWE4K0NQaWVzYjBIY2tCZjV6Z1RMd0xqcXc0Z0xVNG5C?=
 =?utf-8?B?Q2RkcExYSitzeEJzVXphaVorTSsrUStrVVQ2eUlhaU40U3FIMjdDY0FONVZt?=
 =?utf-8?B?T2lrdjFzUHVSMHhzaExHU1l3elRxQnJEZ2tvNjhEalVaOGF3bmJrelVZRUMx?=
 =?utf-8?B?SWZoNmNGNjlhR2djckVCSndVYmZEdDV5YkM0ZzFyMW9KY2VXekY0MUo1cjc3?=
 =?utf-8?B?b1pnL1EyOGhYa1gvaDkwYnY3Y1NSc2M2cUZMd1BGZDQvTkxaRG9TN2trSVQz?=
 =?utf-8?B?V0ptS3FoNmFsYWtMZC9JZWs1OXpnSk5Sa3k1QnRMNVBOcEV0TWRFam9nVFgz?=
 =?utf-8?B?dkQyY29nTTZaUDFBS3I5bThlMTdjaStWTUZvMFZnL1ExYnY1T3dmNFgvWG1n?=
 =?utf-8?B?UExtNFR5YzJFME1lR2VSL3BGVWliT3Bob0pIK3FXdnBLWDRrK2xRVU1sYjRI?=
 =?utf-8?B?YXJFeSs2elRUZWI4bWduc2lxOUYwdlpId21OUWFDd1JnZ0JkRU5SV09oZlZ3?=
 =?utf-8?B?eHpNU2xjWWF2UUxLWW9BYWFOaTZwbytrYUFYR2l3anNkblovNUFBeXFXd0pR?=
 =?utf-8?B?UEhCOW1FaFNWQURyTlVZQkd2cldzczgzL1NSQitzRnFBWWwwejNRa0c1cklx?=
 =?utf-8?B?d1p1aU9xTFQzTUlKV0h0WXd3cENISmx2Zm5xTmZSNHBsdUJreFZpaEg0YWpV?=
 =?utf-8?B?VWQ3SzZnTUdCeThIZDB5ODhXMWxZMXg2bnhlVG81K0hnODFxS0tjdnhvY0w1?=
 =?utf-8?B?Z2I1UmtNSE9SRHVZYXZaZ1hHcmI2RlNOSEg4aC94SEl4L09yc28zdXFVOHRr?=
 =?utf-8?B?bHpxYmZCdTc4YXhBNnpGZmNUNmdWc3JBSW1xdjJGRjFoSlR4RkFVdXV5VzVM?=
 =?utf-8?B?aFRaTm1vNkd6VUJ3N1JTdGg1M3JLeDdjU0RmcDBBNzhNZklZMTJLbXFkblp1?=
 =?utf-8?B?UXV3L2piTFd6bXFGK2JKcE8wMnduTlhkMUhEdXk3b1NqUDhFVjNEbHVySnJL?=
 =?utf-8?B?dXBHMks3VFl2bW9vQWdpOGNiNEJHZ1E3T2xURHExVEJkcnhoL1I0UHJVTDFU?=
 =?utf-8?B?UXZvaUlQeEhvQ2JUekZLbmdjQUt4LzRrcjE5MGFFZXFzajFyNE1xYVZWUGRC?=
 =?utf-8?B?KzFLWDkra0IvOUVCVjd1SldRQTk0QmhDOTNvK1JQTmVIQ1hILzBMeE52OWI4?=
 =?utf-8?B?cEUyRTgzOG5XM0I5djlXbWNYZkdJeE1qYTRYaHcwL2lzMlNBZlZLNDFSd241?=
 =?utf-8?B?SmRGa1BHNHhQQ3JYTTRsVFZlS0orTEJKOTVVYnVxQzZWdEh3djVWTHRPQ2N2?=
 =?utf-8?B?YkFjbzFpNHpEcXp2STJQZkRGNURPRmxxZkxocUdTZUd2NkM5bHFPWUF1RHov?=
 =?utf-8?B?QjRRdnREcGV3bHVERllodzhtU0RtRzdnRjM4UHhsMHNGM2xJc3JnOFBBZzV5?=
 =?utf-8?B?QVZwc0x6WkR6NE81QUZReEdTd3FsSHdXZzVEM041OTVUZW9ZQW81V09VNEZz?=
 =?utf-8?B?alNnYU05M1VtVXFKR2hhVWdSdmZWTHVZSnJSU0pEN1A2VHowbWV4S2w1VlpS?=
 =?utf-8?B?SUU5ZGZvKzJ6RWdhNmhhVEk0SkZhRlpqeTJGNmJNZlp6Y2dMcktOMGw3M1BY?=
 =?utf-8?B?Ri8rNVJzVDBJV0k4aERMV3RGR1VpdU50c3ZuOEh2Q1JFV1I4SUlyc3QrdG56?=
 =?utf-8?B?T09UUm1zSVowMXhKTGNDRE1TL2dFS2xodGc2TVBQTlNFN3R4SjVibC9IOWQ3?=
 =?utf-8?B?VHNIOERVYWlxcDkvVGpCcEhaV3lDK3Y0dng1ZWN5c0xtWGZ5WngrRU53MEE1?=
 =?utf-8?B?Rkg0TUNVMjlQcmM0T2RjdmZNT1VsaHFUZmdPOFlMdU1kd0pWTHdYcmF2S2N2?=
 =?utf-8?B?bVJxaVUyY2VIQy9TNG4wRXVnNnVGUkVzdGI3WUlKaFBmbTB5SmsvTEF2dlJx?=
 =?utf-8?B?aVhINlhQdnZFOVR2K0xycWJDNUZQNGRjRCtDSnR6N3FEQStGQzVScGRUdmVO?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11fa23e3-7a62-417e-f371-08dd08fba080
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 00:38:18.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rSLtrsdiUrRl2+T4D4JpXpz5WvSPijwtvGK+qzp3WDMx6jPesEpnEjeGNeMWAzceYCxJ3taFe9sWq8e3JWkbqh+SxyiuK6Xdzz+hgVPv1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> From: Babu Moger <babu.moger@amd.com>
> 
> thread_throttle_mode_init() and mbm_config_rftype_init() both initialize
> fflags for resctrl files.
> 
> Adding new files will involve adding another function to initialize
> the fflags. This can be simplified by adding a new function
> resctrl_file_fflags_init() and passing the file name and flags
> to be initialized.
> 
> Consolidate fflags initialization into resctrl_file_fflags_init() and
> remove thread_throttle_mode_init() and mbm_config_rftype_init().
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Please place "Signed-off-by" tag before "Reviewed-by" tag. For reference,
"Ordering of commit tags" in Documentation/process/maintainer-tip.rst

Reinette

