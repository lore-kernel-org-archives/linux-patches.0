Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351717DA95
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752076136; cv=fail; b=ioOPBbxtI8vq0N9XuhkRlPa3j/bUA7G11Aq6QNBqRKhmz5q5qd8Xh3zeCCpEIOPOF1d81y4jOKbpPAH4bnkdwlQq61k2rADtBvfN9eNn4jUuIOI5mQwJDx38+Pdbs7cX7A+0/8Qsb2ZIWWtdWLRl4za9LOgcWPsdSW+DCKK5gHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752076136; c=relaxed/simple;
	bh=BI4U7X8+Zw/BQzcuqzCdNAwN9mvdYDzZKudHi9dzJRc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WFvOT3XTAVHvZRNwE1qunbyw1eOfaaSDOVgG58Sudh0axLjHM4xym/4CJuDEsPaykzfxSpDcAJ4wpj9XRsjuZrF/aI9ZoYcBTdMuTyDrSdQGRcpuH1pqe51jOhJoTblwD6ANMevDLsf1fOjJRqOgedxSx2IBcda0teuTAFCRjas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtGHms7n; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtGHms7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752076136; x=1783612136;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BI4U7X8+Zw/BQzcuqzCdNAwN9mvdYDzZKudHi9dzJRc=;
  b=MtGHms7n5rRZxRZWRPJWYin2ux9e+j0q6UYqOgqDTmSHilC7ROWGdKJn
   7LTVHuVNBbguMzC5LzMpjX4RJa+ocYJoDdolCvF/ec2GRG43P+ZKBUt26
   wlBql+7TuQFBP2TcFOMEsgYG+f6dU8OHoB4zkXlh+WiieHT7wheyQZVpz
   gd/DEmV8Z52/4ccol3GtBcBQyraG7ctr1xUPm7hYCQ46vB4WeBV8sw1DQ
   8wANV9mbGoyFGa0VEN6wDwygd1q+GTV7FBdPnEp2VCvuIZV9Yj5+Ppmyk
   S5YS4ZEuISXYmMwmqvl1mFF8Tjt26fUuDwOyD3btucZe1TBoLT4WgO4jO
   Q==;
X-CSE-ConnectionGUID: WJblpKI8QfKo4gdzEjnOgQ==
X-CSE-MsgGUID: tdFKkxx5TjmEpvlLcRP8xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54198028"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54198028"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 08:48:55 -0700
X-CSE-ConnectionGUID: K24F0uqATIGIfQxic0zajw==
X-CSE-MsgGUID: nMA4Kz2rQkekrq7rgN6VCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="179496435"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 08:48:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 08:48:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 08:48:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.84)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 08:48:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rv98V7KZCz1NRZsuPjhn4m+xz1D0vCyzxLIYaLVfA7taUPTYiak6s+VzZKsABUyzTdK3bSVGKjnAvE07uN0H7TtK9mnf/Y0GggfdsNprghgIL/6mugITpwZJaeSwTZz9+KiD+BbV4N4IE0vnpBDIA1x4PlDILlrhtZPFNulSN1hSbJXcSTkGIjLXUnLizZ72nKTdvexI/cWdk+MjxR7HF9Jv2kgM/9GC6pss1c4ryUsgtOnqOWxx+FQW7kPOFkb55w2rh7Py8qnKnyIVrUvZw23ur0AICrQ/Qf191pL/oku2Zzp23F/hnM4PRzfj5tchFEaNnL99N+Jx3NtxQqaz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psXSvIitoVFfjJTEcBYLb6Sl8kn3KR2jYXzyxwNqWF0=;
 b=BNwUWqNM27kzEGXvu5z0e8hLeuYQdzKROlZsYDN9OKsVzifPiopGTvp9NeNnbppLlmPMMVs59LRYFsJzWUbILUz70pjMHJFIg0lB5B/ZNkCE7kCukNP2R62HG0msRR/MSXSUML6rxQc/gLJaqwXGcGjQDx9zZDs86SXzXJwUJztakjIuK/p8ms22rr4rT5xuJWqpjjvugFxkG8Zr0f0HHIGnH0KXxZDY8RXzdG/rPFJcRWR0dOWNWibw17lA8H01i/2yrJFzRAnKbC2Dqwq2NLAnsd/WdkBJ3aczZcLNZKQktsumkXKYlkmotWg/50A3Hg5TOQ1cTTNZSzMpDfsYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 15:48:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 15:48:49 +0000
Message-ID: <37708e34-9634-4488-aeb7-6a61ab01947a@intel.com>
Date: Wed, 9 Jul 2025 08:48:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/30] x86/resctrl: Read core telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-23-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-23-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:303:b9::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ed7c3af-c23c-4293-6f03-08ddbf0018ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?LzdyMEtXRjF0SGpWUUxmTnFSd0k0RVlPN1Nqc3FPL0pKK0xlMzdJcWxRYkRB?=
 =?utf-8?B?bnhCSGY0TVNlNG96UnJyajlqUlU2SGtwMkVIK0RSQ2k0bUFpZFFZVC8yOTFY?=
 =?utf-8?B?NS9JOGViQnpvdVNtSHRkbnllQ0MwemQrckF5V3I4QzZzNlJubUZHZzJZQnVF?=
 =?utf-8?B?VEtlODZBUzlSMWdJcXZnOGl2WG94ODlYL0RsSURJNlE1YTQ2Wmt3cHlWbU9m?=
 =?utf-8?B?cXY2bUZaOTREQlBDNkdGVkU0cWYvdHRQQUJ2M2R2RkNlRkpVdjdVbjRCcThX?=
 =?utf-8?B?NStwS0FNeTFzTllIQmFUcUN4bDVwVXIzdWdkL3JGSlFPK3lVMmxuVEdCUlN0?=
 =?utf-8?B?VWY2eWZ6NTNkRFBaWU5VMWNTd1dhc0pSNFdaMnQ4YVIyY21yb1pzODJUTGxK?=
 =?utf-8?B?K2VJU3NyUmVhSjBmWDg3a0M0R2VnTjRvQWdzWCtLOEp5dnVMTkFRVFhwNDFU?=
 =?utf-8?B?bGtqV1F6MUl4QmQ3QXpXOGlydjVGVzFXYllhMTR0cHRZU2hFZENkcko2dk9l?=
 =?utf-8?B?RC9UakQvL2JVL2VUQnRiN29YVHBFcGVHYUFqZ3hFTmtNTExmeW5ESHptdU9B?=
 =?utf-8?B?NFVvZGVQZHlMTHFKaVpDS2tKZFhhbXR4Y1RFTHFRTFhXRDA3V3VBQVNSaHJp?=
 =?utf-8?B?djRSQXJOOXlxcmgycEpqRVpqa0dQZC9yRjg1eGdHQ2NqdkFwaVIwejN5SURn?=
 =?utf-8?B?RnNEa3Nrb0x2YlZRenRmSW1Ldk5oelB4SzJXS2lMVjNZZ0NQRHhHdVZpNEhD?=
 =?utf-8?B?Z0RtWVZaNllGWHZVOVljVlJvQXlFeFk0RUEzd3cwQUtnZTZ5alhPcjJGR2JI?=
 =?utf-8?B?ZXhjVCtia0tJeDZMWk0ybTJ6OXlUdWdaTVpBMnp2WlBnbDZTVWNQa1JrVE1Q?=
 =?utf-8?B?cTRBcWNhZVY1ckQ3YzZ4VTc2MUxoRnQrb1JBS2RRb1BMZHlJaFEwR0plWG9n?=
 =?utf-8?B?a2FZUFdXemtqUFBNMVh6QXFWd2UycWdNei9CeVJHMzV5MXZHcEtPM2ZiaEFV?=
 =?utf-8?B?VDEvditSWXFZV01VMzdYenpHR0s2RVlpeWs3TUtJWHp3eUtkUXlLLzlYNmJU?=
 =?utf-8?B?eWxtL1UxRWZpMFEvbEQ5OVIrQW5lVzh5SmJwd1NRWERRa0VBY2JDMWpnSFBz?=
 =?utf-8?B?cDU1cG02djNkcFpPaUhyWWZBS1dOK2JZR00wVXR0UHM5RTdBMUZBd2kwLzFU?=
 =?utf-8?B?Q2tDOGk2Q0FoRndTZE55Zkx4U2x4a3FPSmRMWGRDcXY3dmxJWFFVaEhSMWJT?=
 =?utf-8?B?NDBScHRqaWZpRmZOcTcvWGVRUFNMdnd4ZXZxWnhMSFFMUHR4bVd2M2VlZyt5?=
 =?utf-8?B?cnJWeGpvbXpkRXljU08rYW5YMk96MEZLRXZ5Y0xiRExYRk81OW5vbG1ucHpq?=
 =?utf-8?B?cFVza0UvYXppcmcraHNUVXBqcE1IZW1BUUJrYVl4M0YrVFp1bUZBNWd5elo3?=
 =?utf-8?B?Wk9EKzJGd2g1OTlhM2lwc3pXSGYyTkcrM01VUmowUXZKM2YveXdraW5YMGlx?=
 =?utf-8?B?YXIyWEZhRDhzR2U4TWFVUHNtbGZaamVrQkx4M2Q5aThFYmVZdXpQWTJGK2J2?=
 =?utf-8?B?a2pJb0x1Q21nU3VYRVBWdmJCVTJYUkJlOEtvWFZMVEtYc3VMTmRYK1JTcXZr?=
 =?utf-8?B?VlZBS0NCZ25VQmhCUlpZd0dTWXhYMHh5eXZqUXpaS1FROUY4Y0ZsK0xRN0Ns?=
 =?utf-8?B?OEF2YlprTEc1QmFDaHFVVmRTcTdzbExXcTExem1QYjVGYW5TMmNTQjVtTlVx?=
 =?utf-8?B?amF5d2wzMXVzbENLeXVaa3JJVXE2cTB2Z29ld3pjME5ic0JMUnFuZkZOSk1R?=
 =?utf-8?B?TGY0alJxWWtNbExuUnpIcUIxdWs1dU9wTW1Qdno1WXQ1cEVhcjBiU2owMlFh?=
 =?utf-8?B?ZmliSy9TQ05Ccmc5ZjkwWU5zS0JvQ2I5SExIWmVtbkpPekY3L0ZHbkpQdVo5?=
 =?utf-8?B?bnl3N0xaTloyYWZ3WG9JV0FWZlVxM0ozM01LNTU5NGwrcDNINWI4SmFQS2Ny?=
 =?utf-8?B?MnV1d1VwTkRBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGRTQ3BQQUdZQm5XSUtQTkErbWw2U2g0RllRbEZzb3JNc1pDbkJGWWlNZUE2?=
 =?utf-8?B?VU1EV2FqRGVUY3VrOTMyNGlRWG5xWW9vektmcWs2cWJRcktROVZ0eVlKZ3g2?=
 =?utf-8?B?NjFyN3Q1Sk1WUnJvc0pUUkZHUXNvaUtMek1HSGtBU3pYeU5rN2o4K0h4U0k1?=
 =?utf-8?B?b2F6c2lENGxXMjgzdU8zdEQ3UzAxNzN4ei85VEhHNUN1eEM0Y3p3V1NNWkxa?=
 =?utf-8?B?TVpWK2d1SzV4TTNCNThqdGlCTUl1ZG4vWmpPekVlQ1UyU0w3YkZGMllrM1Fv?=
 =?utf-8?B?YlJ1TTFGOHNSa3dGZ3VJSW4wUVhWODFjSFJweHNoVzB3QUJvaDFXbFZoTG5C?=
 =?utf-8?B?V0ZrelVvWkJpeXRaN3o0bW5EWUx5T0dKM0o1blJwZXFJRk9KdFREYzNNMVV5?=
 =?utf-8?B?dEViVGwwbjN2cFA5U1pCeldHa09Qblh1c0Y4bEhPZCtDMy96VXhNSU1IeitX?=
 =?utf-8?B?ZzRZOXhCOVQ4bW42OGtDY3oyZ2RXOC9OQm41YmgyOC9OQ3J5TEo1d0ZzY1V2?=
 =?utf-8?B?bHdRM0RuVmJGcVB0OENWUWNiU0IrYStFKyt4MDI4ZnZsS3VzaVgrZU9ySU9V?=
 =?utf-8?B?ZSt5VENVWjZXSnd0bWp1UkUvTkl0Nk9idHdFQ21jRnFTN2MzRHplanFacU9m?=
 =?utf-8?B?NC9jTWNMcW0ybURHSERwdjJsNzhtbys2a1dKYVBDK1hEUkdreElvZWpwYklW?=
 =?utf-8?B?MitqbkM1cDQ0dTQ2NnpWbUJZVFZRRllmTzRRNko1V290NTNRS2pvZkwyUkxx?=
 =?utf-8?B?REF6OVpGcStjUG5RYmZhWkpBb3VxQk9rSVllQlVXQVFMQW5vNVpMV0JLMVU2?=
 =?utf-8?B?eUpSMUVwN1FTRUViVnFlUmsyTjUzdWRoc2xNMzJqWDlJUzMxdWtNOWd5RWxE?=
 =?utf-8?B?UWdyQVJGUTBmN2xxeC9SYlVHaXJxYXhUbytsSS9wb3ZDakhQV0FhQ3JqRlRq?=
 =?utf-8?B?bGdkTUlPeFd4eGcyekpsc1pjRnVjeUpiVE9JQ3dFN0hCVFpUSGM2Z1ByU2Fq?=
 =?utf-8?B?TWk2eEoyRng1V0NzT25tN1d2NDI1STlUR3prTVN4Vm1xUHpRa0JuUUg3UTF4?=
 =?utf-8?B?RWNlQ0huWFpzbGtVajJMRzE2OXEyWXV0Qks4d0dKcFNocExNbitlT1JCNWlo?=
 =?utf-8?B?OXA1TmdiSHFPYzBPeHB4UUcyVzNheUZqYlh3eGZLSm5lVUFEd0U0R21yZVJ6?=
 =?utf-8?B?SWxWcXdCei9oK2pLSHpyRDQ4NHhkNEJ2U1NGWXpJRHhSSjNEM2FKQ0p0K2Ju?=
 =?utf-8?B?Ky9KVE9McGVhR0lKLzJ2c3hxeG1PdVNRWk1ONnFRZEM1MHBaeFkyeng3bDNq?=
 =?utf-8?B?NlBIYytOR25HWlA3SDVvSlZJb2g3dmFIbWptcUJPMnZWZ3N1azhKbU8rL21T?=
 =?utf-8?B?NW02UVdhNDZ0NEV5aHMvK0t4YTdvR1lVTjduR2N4aUNFNUlBdXMzenVWTzc4?=
 =?utf-8?B?RzlGS0xRblk4ditUbEZ0TzlnM0tOQmZDdVUva2ZRT29FTEwwSkpnQ2t2bDBM?=
 =?utf-8?B?eElWempLNEVNSHRWcWFheVBXMHFFTmNLTDFDMmFwbW1WdnZNRWU1OFdVSk5u?=
 =?utf-8?B?QnJWSElwcXp4TWd2UHZzMGl3dmZTaWxaL2hjTmt5c0dpd1dmdko3Qk0wYTlD?=
 =?utf-8?B?OFEvcFNxRzZJdjVaU3pNMmVueWZQV2pKaklFWTZWSWk2SzkyWHpnK0FoTFJv?=
 =?utf-8?B?S0luSWd2eFBIYUY1aWJKSDRlakIyMnRwV3htL2U0Q00wcGdkUUJyQ3RnU1gz?=
 =?utf-8?B?YkFhdTM0Ri9zS1NnN3hRUFFodUNkZkVJT3lmNjFrRjNlM2p0TWNQT0IxbFR4?=
 =?utf-8?B?NGsvelVnLzJGTFpWb2owT3RmRE5XYVVBMklCdnhBN2QxSmVEZGw4d2FJbkZK?=
 =?utf-8?B?TzcwRVJkTGpLZ2JWbzQ4UjhRM0VFZXl0OUxOb2hRbmdpS1BJaDBiZ0FPSFR6?=
 =?utf-8?B?dHd6U3J6Qzg5cFh0RFhOY09mN3dwalRraEZtZ0ZoamVHVk5kUVlwME5HRUJK?=
 =?utf-8?B?cWZKelNTMkVWL3JublYzalhGblhiRzZQdi9KN0NNb1VoWHBzS3V6bStaQm5M?=
 =?utf-8?B?cUg2ajBZV0d5RERxQjY5T1FvZXNpdFY4Q2M2enkrU3B5WjNobkQ4QmRmRmlZ?=
 =?utf-8?B?VWNIMmZ1NGx6b0J5RDFyVTVta3dkdFFLUmFvd1BzS055Y2QralAxdUhOY2tn?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed7c3af-c23c-4293-6f03-08ddbf0018ba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 15:48:49.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA0Z8jE3pkPBJCzHQwtYpXLi0RDyZJWDVAtNOZ/BVAo1Asy5nR/2WX38mxV9fMCu6KZy48PlCuTzUtzRHyv242FXUrZr2J7W3VrVg/KoWo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-OriginatorOrg: intel.com

Hi Tony,

What does the "core" in the subject refer to?

On 6/26/25 9:49 AM, Tony Luck wrote:
> The resctrl file system passes requests to read event monitor files to
> the architecture resctrl_arch_rmid_read() to collect values
> from hardware counters.
> 
> Use the resctrl resource to differentiate between calls to read legacy
> L3 events from the new telemetry events (which are attached to
> RDT_RESOURCE_PERF_PKG).
> 
> There may be multiple aggregators tracking each package, so scan all of
> them and add up all counters.
> 
> Enable the events marked as readable from any CPU providing an
> mon_evt::arch_priv pointer to the struct pmt_event for each
> event.
> 
> At run time when a user reads an event file the file system code
> provides the enum resctrl_event_id for the event and the arch_priv
> pointer that was supplied when the event was enabled.
> 
> Resctrl now uses readq() so depends on X86_64. Update Kconfig.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 46 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  3 ++
>  arch/x86/Kconfig                        |  2 +-
>  4 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e93b15bf6aab..e8d2a754bc0c 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -171,5 +171,7 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> +			 void *arch_priv, u64 *val);
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index f9b2959693a0..10fd8b04105e 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
> +#include <linux/io.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -206,6 +207,13 @@ static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  	}
>  	e->pkginfo = no_free_ptr(pkginfo);
>  
> +	for (int i = 0; i < e->num_events; i++) {
> +		enum resctrl_event_id eventid;
> +
> +		eventid = e->evts[i].id;
> +		resctrl_enable_mon_event(eventid, true, e->evts[i].bin_bits, &e->evts[i]);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -268,3 +276,41 @@ void __exit intel_aet_exit(void)
>  		free_mmio_info((*peg)->pkginfo);
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain).
> + */
> +int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)
> +{
> +	struct pmt_event *pevt = arch_priv;
> +	struct mmio_info *mmi;
> +	struct event_group *e;
> +	u64 evtcount;
> +	void *pevt0;

Should this be a struct pmt_event *?

> +	int idx;
> +
> +	pevt0 = pevt - pevt->idx;
> +	e = container_of(pevt0, struct event_group, evts);
> +	idx = rmid * e->num_events;
> +	idx += pevt->idx;
> +	mmi = e->pkginfo[domid];
> +
> +	if (idx * sizeof(u64) + sizeof(u64) > e->mmio_size) {
> +		pr_warn_once("MMIO index %d out of range\n", idx);
> +		return -EIO;
> +	}
> +
> +	for (int i = 0; i < mmi->num_regions; i++) {
> +		evtcount = readq(mmi->addrs[i] + idx * sizeof(u64));
> +		if (!(evtcount & DATA_VALID))
> +			return -EINVAL;
> +		*val += evtcount & DATA_BITS;
> +	}
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 185b203f6321..51d7d99336c6 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -232,6 +232,9 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  
>  	resctrl_arch_rmid_read_context_check();
>  
> +	if (r->rid == RDT_RESOURCE_PERF_PKG)
> +		return intel_aet_read_event(hdr->id, rmid, eventid, arch_priv, val);
> +
>  	if (r->rid != RDT_RESOURCE_L3)
>  		return -EINVAL;
>  

This part looks good to me. I expect Kconfig part to look different next time.

Reinette

