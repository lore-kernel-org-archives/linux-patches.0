Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86D364E95
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775260815; cv=fail; b=sQfGzgrVYfL5psUfFAIEz6uedS7pZilhP1HdaRl+oUMeBKK1I2rMUP0399YYY4abB0KoUxiYqwiU8esah/dV/zKWIY6Ur/2Yy4IkSqc7HRTpBXHJPtJIOsvWIUrgt/FfunvtBiFVVWI5stX7+1yClN+9YbvL7eZUw4/iF3vOUYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775260815; c=relaxed/simple;
	bh=zOxBesgmOGMFqIEiPACOBZShQdD19i3mpV31D2fSa4s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HhdqfoLnbDJSDctu3yqwASQ1SNM4JBgWS1Ytlss1qj1ESv1qRTs0YCu3Sdtsx6XNnDGTM6Bu3wO4rWfD33BzkPOswY6krI81swGqfuyWvH+NiXsHAvs3zc34xOXGCf3tNJQxOnr6K5gQM9RBb2ddidrtwPW/dRZW82YXD00YOfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OscxsCQl; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OscxsCQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775260813; x=1806796813;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zOxBesgmOGMFqIEiPACOBZShQdD19i3mpV31D2fSa4s=;
  b=OscxsCQl1vIquCUNrv6n0qFp7artXQXQDZbwuA2SyB4AM4pF/ymNMMtn
   MdAGsYz2EhsrnYEuVVnYHBNXHr4KWGbO9aunp/ivEgEKDWPLA94uOnOvJ
   x+AdBt8yl0c/ohidRHCGqgnn6FpEWB10lZ1YLjlf5WquiDt5OE5wIsi4z
   NQv5cx6Zy6pwFKf1AexVjCNn8YiNu1p2hjz6eh13DzA/B5zRX+THLXGa/
   5ORo0J3HOYPu6nmoN71G72IeNcfKIWdFO0/+TUq2zAyqTMeI780gbHCdw
   8CFdh/eCiSBuIT2nHVyXId5bv5GPZh2PmRguQLfwI5LtiE9rOxBY7VC7A
   g==;
X-CSE-ConnectionGUID: Wgw9nj3+QMqTp49VZPQPKA==
X-CSE-MsgGUID: Sqb5VAOJT0uAY8L/kW2RBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="87708739"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="87708739"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:00:13 -0700
X-CSE-ConnectionGUID: WpNHsbV5TPiwFaU2saYB9g==
X-CSE-MsgGUID: W4qWlrc+SaSerFFs+Wqc3g==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:00:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:00:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 17:00:11 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:00:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKfPaRE/NmkD3hvacLJeCod9YeBRLpGdbnW8z1sCtiZ4YlOWwRrPjGhDLHG9FH2hsdAf0tT22sRJCPUWWQe0OTaYYmBroqaw1d+5X66noGq+zWxzShU+W8+3C7dtNi0mkHYO/8pqALJE6p98ACVeyLAaQ8mUUy55/QujGM2/kQdXk+2F8hkExLdNB49NWK8Je9wZADsn37ZR8TgG7QazebhaGiKSKysjfWDWLal3+l9IAsL55mnsAXi77OA93h8kEPwlBZy8hcz1F8pzl4VHnNSPycPn5BpyY5/Mw5luVwM7aEHjC/nbGybegpgx3v4mA6nHxlpvGjCCe0WttxVGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOxBesgmOGMFqIEiPACOBZShQdD19i3mpV31D2fSa4s=;
 b=SZDHcrfc9fbRChgTAHDg5oRhBBoEJb36W5cEknqomj5iqvUrEbhdAYMCA94UcywVcxATjrbJrKLXXNkM5aBHmzh1jrnv+xjiOzChzWseMpxTXDsXceFxHmgkeEG63Okg45aIEJwNtQNn9Tik5hWht0nRriwuu5lxGLkCI2QyMCtLYlFfUXQEmyaplzAJ2/ml7KuJ0yxKaRmaFfqivHqYn2OelpPfmzkE8Oc16X3qsc7Yg3UFiPnmd0zv4dMyxJI+AMziaf7oV6zGIZtCdKx8EjleE3rsxRhIE8z8qCyW1fu7o0XFbQYgppiUv035IvEL8HpK+JSsat0Oi1dBbN5G1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB8234.namprd11.prod.outlook.com (2603:10b6:610:190::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Sat, 4 Apr
 2026 00:00:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 00:00:07 +0000
Message-ID: <6fdc6275-c898-4b97-a702-8eb66e5f38dc@intel.com>
Date: Fri, 3 Apr 2026 17:00:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260330214322.96686-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:303:b7::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b22816f-037a-443d-508f-08de91dd21ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: yPpyKcLfjDqa6B70O889TOGVURSDqvwwPKvsck8eUH7It4DoSfTAWpv9r46UWa70TD8DO6eUb7RPGjAPbrfJF0nqX58JPqLPirKp3qusnUYtXREK/53AREj3HYJ3ySFPij7D9gBeAq0WVJXrNUxuui/HiOlyom7p5wxswZNYrgW8Qp/xomg65HJiN60rcqghNUF3nwe8w14b1oNaJkBtsdTpDsIHlszfCZ61O601eEv+sNYhAayrZ3sYSb3c7XjFoPT17AXHR80YqV/8+utbzSgW4SGMj7PgbaxP/n0FdPPBP8Q5Mgcf+j6wFMvJ9Y28w7IVsJizzilFq5Y2yW7sAzC0k/9b/dvYc92VtWrAlyJ/IL1O+yYM2/yQJs41S6QUiGt8OI1mHY13eneZ+Rq6KKrZfvk7YS8YQ7xLqj+3R0wI2LDCqiNkHJAOofFOeUYZuhSqG5d/OXAyHPOlNJkrzkU5t+ETAdenmRG3Rwg+iM5z3dH8iru0ADRygvq8l1GagKPo8eDi5vN+mELIOYt3hC3kK6w1VXl5HVpcmr3sEup3MTV4lllQyfV4MeHl3kHJZVYuBzesMfWl75hdgHiOgjo4j5fPCYQ6z4KWc6Q9lKssDMh8ALI5HB/8fqCvg1mTjjNh5tZqa/2pe4ThYZ+Jvz8T+0upSzO02EDgyvGa/jJX9T+7NfJbCAUJvce0fboWj3fmTpCd580/IZiDFshj39G3wPR9wahcE3uJ6cu96HFddz2mPWL65eujJMeO32QPFfz1GUMuzcgaI2zWE9ZAvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXF3NEE0dWQvS3d0WE1PdzV3NGlYVm80M0ZVMjRORURwOW1XcHdVUHBMQUNG?=
 =?utf-8?B?ellXclgzYTR0ZHlEV09WQkxXVFIzZXZBVDlUTiszZEFYUFpKaGEvMzZBUzFK?=
 =?utf-8?B?ZGN6UkJKQXNWVVY1KzNPZUpuSDVBUUdhYkZLVEQxYkxKczRlZmZzNDJNZ2cx?=
 =?utf-8?B?TERnR2VrMjVXTzgyWnhGVkNXSGk1a3JDeUtjM3B3SVBIZjVpN3orb2VEY3p5?=
 =?utf-8?B?eVpqQU1NYUVnb1M4QzY1WHQzY1ZQOC84aGo1K3ZXaUY5UFAvdVlzVCt6cEdM?=
 =?utf-8?B?akhzaWdHQmFEdWhpTyt5WnBIOU9nOVk5dGQvL0JhYmZzaFNrWDNBOWUvczhl?=
 =?utf-8?B?bFoyNEREdkl5dFRkdjZEY0JkZzVrVDhLZmdGU2U5aVNqYTFLT2FYd0xmR1RJ?=
 =?utf-8?B?NUpLSGcwd3JHalZ2MTUrOEZOV3JJWC9xQ2xWcWJzS2VuNG8yUW5HcTYvbFN2?=
 =?utf-8?B?Z0o2dW1oZThnVlZ2YksvY3dJVHV2bDFRUk1mSXl2QUpabXN4NUx2K09yZHpw?=
 =?utf-8?B?M2xVdzhSQUJFNlJsS1lZNWxaNW1CeXZBb3VMc3IwMHNNU1owQmlnd2FTVHlF?=
 =?utf-8?B?WnM5TW5XdUpsQ25kRVU2SEdHYjB4UzEwYWRmQkFnR2g3TjF2YUp3UlFqTWQ2?=
 =?utf-8?B?NnlCVDBYKzhrY0tQYUhNcEtEQzhCbUovVWE2RlZPU2Zzc0w0dU4vbG1wclll?=
 =?utf-8?B?KzhzeDljamx0bngxWFlkRFl4Njd3VjZLVVBMTHJwV1ZFcVpVUzc4d2Fzc2Jm?=
 =?utf-8?B?ZUtZKzhDN0RYOUsxSEF0ZGJveXdnc1hyNzhhb3JUZXA3K3VmSm1LRHBWcWRY?=
 =?utf-8?B?WGtrNkN4NC9UTXZFYzRscW4yK2FMNUpHWVlrcFltWjlkeXZtNkcyWmhjbkI2?=
 =?utf-8?B?T011b3ZNbTl3S3UvYTJnZFlCanh6b2llQ1Q1ajE4Y08yZDZuUnBSVEZlM2Vy?=
 =?utf-8?B?UGN2bjJFQkFpZlJDYWxMTnIzekxHSFhuTGpzM2lTU2k4b3FkZStYZ0Ywc2ZO?=
 =?utf-8?B?UUlENUJiWGs5NG83bnhRN3Y1RmZMdlFpOHBscGkrdnViSUVXSThmVGxUL05s?=
 =?utf-8?B?cWp6anF5QU13OGNJaUMxenJibFE3cm5WNUV2dUM2N25RS2V1SzBDS1BhWWIy?=
 =?utf-8?B?eEFsMTJwbk40RVllQVQvSU0zc1l1aTdOdm9ocXEvOStNdDE1WHFQejdNdlJU?=
 =?utf-8?B?dVNQMzRZdXZYS1BidUxnS1pUY295eGRtN2hzUjhlL2EwQnZxRjFlbDY5RVhW?=
 =?utf-8?B?b2ZHOUUxdllzZGU1Z1hRa2c5RGljMmR3OGpCVkI5UzVUcGR2QUt4eUt5aHJG?=
 =?utf-8?B?Ri9sNHF4VzhqVGc2NG1QODNUK25RaUkrdHZuTW9waEI0T1RTMGVLTmJDWlYz?=
 =?utf-8?B?SElCOXNkYldZK3I0eTRKd3QyUW92ZU9yellUbExPai9DeXdpMEtKRCs4by9Q?=
 =?utf-8?B?Y2xzMlJnRnpTK0pKQUlHZzh5cFZXYWV3UHFKK0NweUEwODg4d01IeGR3TG5W?=
 =?utf-8?B?MzZscjhYbnhmMWVaM1UrY2V3QVRmemd2L3FlbkIxRElEeXpkR3RlL3FlMGds?=
 =?utf-8?B?MUdVOWZjc2ZPMGFXUitRa1drSkRhcjRJSXNhbStQMXM2emVKa2FrRWlaZXF1?=
 =?utf-8?B?Wm9zYTVaSlVJdi85TmY5YytQSW50UHo2NytKVnFKclhtZ2JDeEJjcUIvWjhD?=
 =?utf-8?B?Vlg1QkNSRFBNU0VZdXBmY2tNTG16L2NjODAwc2QxWU95RkVnaEpGc3MzZi93?=
 =?utf-8?B?RkdHNHJvNXZmUUNUcVdVaTArVFRtRnRuZ09GNEdMWU1xQ0tJVE1jMTF5VGwr?=
 =?utf-8?B?N3piMlFtaU1uNUUra0FPNHh4L1pjdlNvdVh4VXIzK1dFSzBOTXVQaEJXSTVj?=
 =?utf-8?B?NGt3RzRIUk43RGlYU05ZZ2R2TnRwcm1SYkd5bkFkNVhMN3BWZDQxVWpKeDhm?=
 =?utf-8?B?VmNlK0doT1YvQlVoWjF4TTduTkdpcUFGbi84TUNrOXN0cGNKRjliaDZHNkVH?=
 =?utf-8?B?YTFwY3R2K0hLUUprRnR2UzdaMUFPaGFIeGFQSWI1c1l2MStjeDBjczdVYmty?=
 =?utf-8?B?ckZjQ1grR0QyenpPZHdiYmRRL1lUbnREd0NrVVpkRXh2L29WbXVKSWkxS01x?=
 =?utf-8?B?TjRZVG9sVzBTTUtsOHFRcmEzbDVoTEdDeG5IMExjcFcxK093d1RIaWNJeExr?=
 =?utf-8?B?amkzZ0NjUEdLNXBFclNmQ3IxOEtTZjdWaGRKcUNWRjZuZGQvSUxuR3dsSkNl?=
 =?utf-8?B?MGpEanhBeTBMam5uTmNiQkdZSGZwNC9OR3JFTGhZTWJVbDdZTEMyNzduSnRN?=
 =?utf-8?B?cWFEUVdZb3Y0R1M3cFV3ZFlwUnBYN21HU2x4L1dERVk0SUkxMVJIMHF0Smh5?=
 =?utf-8?Q?3ieHjFdOk8F16d2U=3D?=
X-Exchange-RoutingPolicyChecked: SzNW/DwACBAg5ZWAMyc+N7dWhWSJtd3B6/GxjWF/em/kwQwAdd0MVvRg9XUyKxVqooXC0FUKn9O2JOxolPt/Dofq2ouNQuxaMmU8JVuaIGIRJZeXNhmyoI0ntnzczZJNmdxPItHA+MByFmao9gt8MUsHcVhkuPHe/cFVahlfUV4vPf9W88Tvf/IqDJqIbN6/E8LJCzWy0yaJfhY2Aic6UCWrJuKroAvKApCwC8Bxf+eplma/sqvJzW6YBKJhINfUipsOBd966VnHyYMHqSbKorPpeRZdhCwjpP8grcCzIuzcaySVmDqi2RMqv6Nx7DKHWZ34TnMQzPwd9l1iwVBgbA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b22816f-037a-443d-508f-08de91dd21ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 00:00:07.8668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcf5uSlKDCoEnXSqM1bC8WXNKEjjOWYrxLH/DmpxlV3BIprlxLzgvU8KThvnfCaUuIv+/zqneQQrJd7IfA9RaIr5KTig6o3ORzTw6om7E6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8234
X-OriginatorOrg: intel.com

Hi Tony,

On 3/30/26 2:43 PM, Tony Luck wrote:
> The symbol_get() function requires that objects be GPL licensed.

I do not know if this cryptic note is sufficient for the driver's maintainers.
Looking at the dependencies among symbols it does look possible to add more
context here that makes it clear that this is the right and obvious thing to do
for this driver. Doing so makes inclusion of this change just a formality. If
it is not the right and obvious thing to do then I similarly expect a better
motivation than some planned usage since any planned usage may cause a debate
about whether it should be supported.

Reinette

