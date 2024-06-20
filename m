Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E16763FC
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918096; cv=fail; b=YQbsYRm+zbBkql2t+cMmUOjKKsCgb9TCqjvke2HE/1fYs6k93GBKfcBqGYQvdmppiRPtEw7gee2/L2o7GJILUWLaFFry+8c/Yb3EqHVd3v+tzbWYzlY9xPJAg67TZTWCilVR/oiFWma/X+nUyZL+HGwvk//MRUFTTaUQT5y5WP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918096; c=relaxed/simple;
	bh=jHlxnWnET4nff65d78bduXYIN1zvN5W+gqucwqmj+Qc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=szZ998fPJdxnNdbGh3ZC7uV3bDDZi/LrNkjM20Hr2V842Ty2YFIt7AwhWx2T6hvxTTFgj2i3BSfzhGvneJv8IqhkW6Zm9ossVr37iZvTvOfxGa/+e95JfhI1Pg5H4MIZ/l+hx4MJNhQGBOfpx6M/qWhptbFRDHa5rWMtotrczTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBUvyYxl; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBUvyYxl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918095; x=1750454095;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jHlxnWnET4nff65d78bduXYIN1zvN5W+gqucwqmj+Qc=;
  b=MBUvyYxlkOVWEduXGt+ALZzQuMUyD3jVbYkKXySjBXrZG/rupTbb+9+e
   kpKcOuNYsgNfCceKTAIzzJo71vFsbAWgjNLzFpjl1RXn3iTSy4Tdy6sq8
   adtUISYEEzQcXY0slwLpfeTKrsMozXm8zaut4RKrY/TAXiseOlQzdIu5w
   PQMyrBgskqgkDiUjZ0PYyDbAeUJlRzqeEbrOU21Gc95mPHniuUveAnwVe
   IsA8QEYuoJrM5lSbDkrsXu5KnnK+C36PXqYUN7nJh/f05A6bbJyS1u9EN
   Ww0Kf7RbQEtmjGQdV1qHYWgGsLXWB1zbRaTRrd7gpn7px3pa6Hk70HPdF
   w==;
X-CSE-ConnectionGUID: g6vNZ9VtQrKQXpEtyKOI4Q==
X-CSE-MsgGUID: n8r8SaAiS3WCeNQMQ7ItKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16056812"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16056812"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:14:55 -0700
X-CSE-ConnectionGUID: HM8Jl7fwS4ab/C+3waGP2A==
X-CSE-MsgGUID: JeKGcWPSSMSrsEhIUdkCuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="79882679"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:14:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:14:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:14:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:14:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/CXjf2CDGPYulIalYEwvv0zZykxJ5QOHHix7s/7xflmh8By0vsmAMi6898od+55FV9MH9qonbHGD2WJmogQEoN7jT/grgTACrr7rFvXQViYww/lp3DdWHzne8Uz7m3TbXwHZVpR7JrKM8oVlPAL7BCNlz0wfJJ+Sf6TODMVXGNUJpPsk9gTyQDecGlpx9tlkdeGEFw/qs8r35il0iQ4VvkQhL4T19niMcJY/BLtD532uLGmgLozVr8LgcBbmjXlGp1ICsFf3YhvzIlMT9dAdssRXc5TxuGRn1DeFITVZu1lvUxW8A8OwlMt0gGT+I3EQq94mdrUeUCpxRHHUAm4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwWI0mUXalnS8GHC5I7aOY4FUgtl7Pan0DbnrsMu4V0=;
 b=lSoUK8pwbB1UTmmb0toCru+7f+MHWnZmrMXpeiI9eWX7kZZMD01aGDmHJLxmHEHH3QXLpJkCvCRJ7X3DJlXecMuwL3Bi+48Z6gtK+Gr4ZQit2XiHjrUkQroPQXTU0TjO4kiM12DChp/LeG9JfIF0jts6JGbs7MdAMfS3i9gsefL2tJyePqiyQPKrLE59FrtOmxqV/1uFNq5GB3VM8j2a1GjdmitTjqMKTQor9d88Dpo75PSXjmFKpQwIlwL2TUaJSzoEFIHVqtkAx83zeCf6GR/whQptiNulh4tZB5nDSi5pr2yQ6BxhmCoje77kHCg3atqqqFnFywaORsbwE0LdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6878.namprd11.prod.outlook.com (2603:10b6:510:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:14:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:14:44 +0000
Message-ID: <d710d91b-38e2-4727-a3b4-39551691cae5@intel.com>
Date: Thu, 20 Jun 2024 14:14:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 04/18] x86/resctrl: Split the rdt_domain and
 rdt_hw_domain structures
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:303:8c::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff50363-132f-4669-9487-08dc916e0211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?elRubnA0SkhKVGs4OXFaQXl1MWFYZCtQL0ZoNEFwSFBpcHUyQ2EvNnJZRENk?=
 =?utf-8?B?eWZLSjZ2VFp3T1VlUnpQRVJ4WHhNejBoRFl4S3BzM1Zzd242RTFFeTA1Ry9D?=
 =?utf-8?B?UFNXd1NldkREOEsyajRTTnJGeFFnU3hUTnIvMnpNZ0IxeDdvNzUvbGxJTDQx?=
 =?utf-8?B?d1h5dEJPSUlHaFY3WUJpMUV3RnNwNHFibjVhSGxzakQyMG9iRHNvbnhpVEtz?=
 =?utf-8?B?SUtTbks2SUlnbDVBckF4THBMS3hmR2ljeE9BRUJVTEpvcDd0R2phOEpKd2RB?=
 =?utf-8?B?dzE0NGtIKzFBR2hkQ283UmV1UzZWYVRTWis1VFdycWxDa2RHNVZjYlNsSW1B?=
 =?utf-8?B?RC9qMXNSQjdUYVJ1VHJSdUJPNHJIeDdhc0pmQ3U3ODJBK2Q2QlRTUzFleXJD?=
 =?utf-8?B?QXFzZG9aajZtQVQvdDFzUG54b2xXWXdGZ1pSMU1VdWJPRkZrNmc1NmlYNFlz?=
 =?utf-8?B?YWlod2FRTzVJc0lhK2t6d0krRE1Yc1ozdTQ5TWVob2N6WUJXTktDSDNJV0VQ?=
 =?utf-8?B?NFE3KzlRQlN4U1Vrc0gyZEZRYlI1RVliVnovNGVuZms4Tld0T2pCTjU4N3dP?=
 =?utf-8?B?d01yWEFGbEpFL3RLcUhtU0xvQm5KYWFDZmRZdFMwSzRmWWx6RWt5VHJjeW5Z?=
 =?utf-8?B?NVFjY29pNjZuUHgySmxSK0p5RXZ5NGhMTklvUW5DQ1g1WnZWWlBsQ2F0Wk1Z?=
 =?utf-8?B?by9FcTVwWVlPNlNtbEhQUW1POFNMUnl5a2x0c1hzZkNPRUVmZ0pYMkk5dTR0?=
 =?utf-8?B?dW5JNFRJL0x3cDVaY20xU0FoUmtGKzlnOWtuMlFib0EzVC9LZDVkbitJUXcz?=
 =?utf-8?B?S1ZZVEM1b0RvMUprNU5tMzNaR1JpSjdjenNvdVdGRkFGZWROMTN3Y2lXNnA1?=
 =?utf-8?B?eXBzY1lISFJveWRTQktCNkxDRndFNHhDcktkMVhmOGN0VUtIbWlzMlhzNG5R?=
 =?utf-8?B?bnpGaDdqQlljMVVnK0RORG5KSkVhZWdsdlJTdjh6cnpSY3dIQnRGakl1TjIx?=
 =?utf-8?B?M3F6cHN5Z1RHU2w3QW4zZ3g0cTFWT1N0UHR0TytmbGpTWW1KcDJBZHE5WS9C?=
 =?utf-8?B?SGcxYStYcGVqYjB4ckhsMnd6WUhIeVFwcThWaWdnWUpxdC9tUlJMOWJ1azJM?=
 =?utf-8?B?ZDg1RzRtWGEyY1BZUnIwZHB5ajFSMzBDR1o1MjNDNWNCT09ESFNhWTNOUVhr?=
 =?utf-8?B?cE1HZENoREJzM0JzYzBsdGlYZURCOUNlL011VlVHQTl1N0oxcXFSaEZsTW5w?=
 =?utf-8?B?M3pkVFJiUGJLODQxaDMyTXlVU2Z6NUwrWEQ4RThCdWNZTHhkWEpGRjlGeVkz?=
 =?utf-8?B?RVplMWlOZmpBa3NlK2FoV3lkUStnbFpvQkg3REg4aFBtd2Nsa2cyNFZVMUR3?=
 =?utf-8?B?ZDJoeE1JbFBPNEtQYkVtbXJLRjU0UGlSazhtTCtGS0x5RXl2dUFkQ0xqaHFQ?=
 =?utf-8?B?bVh1MTJ6bnF3RFJwajhCMDJpcnNUUUgvUlJCL1ltVm9YUkdiLzJoeHp0TGdM?=
 =?utf-8?B?Wk1aK3dwZEFZU256TXppa3p1MWlQV1kzYVdGUEpXZXdwVENKSUZPdEdNeC9x?=
 =?utf-8?B?dzZkYUpzNVFFTjNZZWs5UW05SVVYYk4yVjRTNWlZZVlLcXBFMjdsZUFTMjdp?=
 =?utf-8?B?TllnTWtOV3kwOE5YKzBVMkFJQk9EWG4yMlN4RXZHVDQzVTE0bzFndlNjRXF3?=
 =?utf-8?B?QytOMnRZZWxxTkdkbGhHMllYWndXNXR5bXcvZTZ4dWFLaDJCc1o2NEs3N2x3?=
 =?utf-8?Q?HgGR24MEs16PwWZt8WcXaH6TDUrzMfZfh9cZCiA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUllbUVZTHoyR1JzSU1ING5pZDVrODFhSGRCdFRpYkFiYVpGSUNJbzR3NHR3?=
 =?utf-8?B?dWl4UFpIcW9HcnFBcmFFM010aWt1S0FOLzlkcHduS2NwelRkUlFVUmpMd1kx?=
 =?utf-8?B?ZEF0Vlp2WWxvOGVlMGZDcy9SeGlFczY1VFpNR2NhUWZ4MHlhTmZITnc1UkQz?=
 =?utf-8?B?T0I5eENzVFJnN3RoZ29uNU0rQk12a0JoUDFIa1IyNERkL1BsSUhsNElNbDJ1?=
 =?utf-8?B?clZINnR3dFpsNW1kNk0vOThpcWhGcW9UMHlkalhrS2dPcGpxcVNjZmMwNUgx?=
 =?utf-8?B?emtCTWVlRVY5aU1jNG9xdHZPaVl1eE5iKzcvY0RNRnBiWmxTUGZrb0RZVVox?=
 =?utf-8?B?RUsydzNkT2NjamtZLzBJZVl5RVhoYjZ0K3hha3Y4ZGRRSXdSbXl0RG5NeE9J?=
 =?utf-8?B?OEVEdEZWc2l4Znh2NERvNnJ1dEVzeUl0WVEzNDNCUTNCUWxwNzRLUVovcDlO?=
 =?utf-8?B?cWFPVFk1eERnTzBsVlRlSXR6WkhoNlNSMFdPOEpTdXVuUDlRa09HUDU3SFZX?=
 =?utf-8?B?SU5BT0k0emVFelR6VEhPZmhEVmdIbjREdW1DUjJRVlJDb1lBdlRuNllRS0xN?=
 =?utf-8?B?MVRaU3luZTlBSTA3OXFjSlo4ZE5ZZVk1QVRKK0tlNGpLZ2RNK0h5ZTlHRDhQ?=
 =?utf-8?B?b3N3b1o0NUZ3aUdQRXBWd3VXMGJGeEpnSFdwVG41bHRKZ015QU5uVEpzVWFL?=
 =?utf-8?B?RENwT2srSFl4VlJXWVdkUTBnakY1Z2l1ejFxWjV6cG91UWpNZDFkeVFUdFdO?=
 =?utf-8?B?OTFrSElRa2ZySURUVVFpaDFraDZNbkhSYmI3QktYZ0Nwcy8xQkpTNEJpZTlY?=
 =?utf-8?B?d1V3MXBYOUpXMnY3QXZMN2ZjYnE3eE1uZXd0Qm1ycVhVNUR5NnlaUDcya01B?=
 =?utf-8?B?bHJhQVBXaTgyZkhWQ2NRM0RxOHkwL0hwTVRpOU1qVG55cWxRNVpQdkdzUGdt?=
 =?utf-8?B?NHMxVVFMQ0F3cjhzektmdkhQVjMvT1ZXejhpVUtISDFnQkh4dU9wdUZlTWxj?=
 =?utf-8?B?VFBZRDVobmRCRU5YZFBYVjhVeFVkRTdUanpzLy9XR2p0QjRHTFdXWmRhSkNK?=
 =?utf-8?B?MmllSFRUUDFsMVlXeTFBZE5XeFF0b1JTVG9DbjFVeUpOclFOa1VXc1V3enZt?=
 =?utf-8?B?blBnc2RYUHN0UjFJSmh2eVJhZEtBbGtzczJtbmZiZkF6VTZyME11RVBDOHFY?=
 =?utf-8?B?SXBIQklqZjVieGRRRCthVjdPWXhhbWlxV2l2eVZKYklGVFZTZUlYTmQ1T09h?=
 =?utf-8?B?QlM5UWltaFBnTnNCckdNTVJ1Z0hUUVpUMFdVRjdCMXd1MHp1VUZsZE5janVt?=
 =?utf-8?B?eUZzclRjMnpoRUo0enpnWE5wY0I3c1VsUnF3S3kvc2gwWW5ZWDNzOVpiOG5r?=
 =?utf-8?B?a0lSTWU3NFNOK05JTkxXQ3ZHcmZocjhQbWlOZFE3ZlBHdDFEZXhhNjZCdlBI?=
 =?utf-8?B?enAwTzNpUmZYTC9JeEFRaTVZWW9iMDg5cytSUTdSbW9LZ2k1SG1uVjUwS2Fx?=
 =?utf-8?B?MlFrNGNxUG5VTmpLMVlwUjdGdnk0ZHE0Vnc3aEFkd0ZHV2FyY2tSSzR5aE5D?=
 =?utf-8?B?aTZtVmtmSTMrbUhRYlUyUUlUZDd3clRhZGZWUHZyMGw2cm8zeHV6M2tXbnZR?=
 =?utf-8?B?REY4ZXowMW4ySUxXelFrQjU5Ump0MHFNL1hQa2gxSytsTVRrLzZza3NjaFNi?=
 =?utf-8?B?dXJFTVIvNWo5dWk3QmhBWVZ4aG1uZTJUOE93eTh1anl2WGRLWHl1cGdER1Bn?=
 =?utf-8?B?MjVqMWVQOE5iLzQrd1A4b0xtSTBWbGUzaFArejdBU0tEUW9WRXQzdlNkRER4?=
 =?utf-8?B?UE9JWWNzVWRrSktUMFU4dXdHemJWajFVOVgxME1KeG5DYWkrd1VQV3AvRjBi?=
 =?utf-8?B?MFM2dC9HS1IxTy9KRHBtbDlSdVIwVUNSTHlBWjZRejlxYVI3V0ZwOGZCRnMx?=
 =?utf-8?B?dVlNUzk5bHFzMFc5VnY0TEtjV3ovM0pGY1Q0bytpYUM2bWZ4MFdsTjgwajkz?=
 =?utf-8?B?K2hFcmhNcC8wR3lkcGROMUcyN1FQN01sekVYKzBXVTErUHlyc3VwN2tmRnIr?=
 =?utf-8?B?OXVNNDdrbGZzUGNsT3UrVk1VSk44bktBcjJOSFhXaVcrYTJWaklKbmVrYUEz?=
 =?utf-8?B?THNaNjU2cWxDb0pmRFVIUXFxVXR6bHhFRWVXWWVqaXBhcTRmVWNIT1FGaWVX?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff50363-132f-4669-9487-08dc916e0211
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:14:44.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MzgeeHJhbPcqoftCVmPnLhi71tbGu47ienLT97VFa+g64mgmmCSlpUwtd6LkUEHXHOepgP6U8msrMGbQZbg1GOvbXgo17ikq7ENxnOuGrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6878
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> The same rdt_domain structure is used for both control and monitor
> functions. But this results in wasted memory as some of the fields are
> only used by control functions, while most are only used for monitor
> functions.

To me the "wasted memory" motivation is secondary to the potential
confusion caused by validity of struct members being dependent on which
list the struct belongs to. Could be obvious if all operations are on the list
but once a list entry is passed through a few layers it becomes harder
to decipher.

> 
> Split into separate rdt_ctrl_domain and rdt_mon_domain structures with
> just the fields required for control and monitoring respectively.
> 
> Similar split of the rdt_hw_domain structure into rdt_hw_ctrl_domain
> and rdt_hw_mon_domain.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
