Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB81BC41
	for <patches@lists.linux.dev>; Thu,  9 Oct 2025 02:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976179; cv=fail; b=Olp/3Lii+6y0G5TJEchN4Uty9zOJrIjspyIUA1aIstfENAFeV7CuKjblOc54KUHSrCltlLPXSj5tzd5SntnfKUVvXf+ZcVn0yGTz0XeIumt4m3sS3pe18RBRyp1oqA6tAViDn2gtsypEBimBgVZMDVYqO5cpa1ojRHhTwiSgs4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976179; c=relaxed/simple;
	bh=9WrDVp3Bs2uwFuJPlzuLCD0/oYR1CsBMNxYM11PFlA0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ojvJqPajyfLETTAahOgzHOA4e9EWx1KxH+52tUua/SAP64NX89yEdEBuWEXdEOgynZtY4slwAnkNeDiSC1XtekTBd2zPTbqwK20z3+8wRW9xgV/oIVbKFbMntFvII4F5XS2GFi6ZDJsGkhC1F4qEPdE/HAG71M6YYrRiKhTS57M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQkZIOln; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQkZIOln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759976178; x=1791512178;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9WrDVp3Bs2uwFuJPlzuLCD0/oYR1CsBMNxYM11PFlA0=;
  b=QQkZIOln7hTl5mAmSchDVXMXkzPqq5Oi18WHTMBCNuU5rZMAi/xgfLCO
   RakuqS05f+BMjJXFKsxdtHn1X1TcYWwaaNszSpHe5wgKaa5inE++VzhFy
   zBLXokUKELw1imz31qTtO4+J2F5YblMzIIipB6nlsyIaVEZ6enF4XiEuU
   e4NxZ1WOCqEzLl9SROjbZwLiAZ3vqaxqapKLIhQuBt9cGRLa0+dkPrpVK
   4zLhAPx/MpB3fHB6zBmlkoHt9jvkVI8hkwQvId15oK7HGqkuqL4Nhhpab
   n1HOCil1sN+ooGBSNo8GbTA89M50CG7aCVZirKWk/i+bjntpKSfeyFheF
   Q==;
X-CSE-ConnectionGUID: LqVrCxVwREWvsoy+mnP0jg==
X-CSE-MsgGUID: NaBWql0/SPKZ0vHtlQF8Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="61884308"
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="61884308"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 19:16:18 -0700
X-CSE-ConnectionGUID: caSuJRUMQbSQNUz7rfyv1g==
X-CSE-MsgGUID: aKpDRjRXSi6/deffYt44eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,215,1754982000"; 
   d="scan'208";a="184966897"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 19:16:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 19:16:16 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 19:16:16 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.61) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 19:16:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=saR4VHkBrpHKggCvs6N47mImwzcK+KyVBD11PnpIWbqrv9VMUq9j6b/+aWSqmJkKCBzNS3mPDPcJxmEwzcm3lXS8ZNgN95bYbbmJdR1NtDzQ+oMPifRNvhK030bxoM5MVIYe2idmxyJ4PG133iM+kO+wjlYppdgAdi4CVxWJAn3dKp3BZBsIU3pO/bPjFFyCoYqJikJIf74X6AjB3sQoLNCsfsXUUcXCyd21sRDup08P0FXCFoWnch5zMWcRjwzrgqi99r5eaG+kYeQZsYjLzdK0gMPiKlAbyC59LghXO7x59/PKVzFIUAKBEyS1emurluTkmGT1RAF+JYzHOWjK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4TDhFuGBsJmkerVLaYCxL5V6dUNZLRrzOn3HAh95T4=;
 b=w9fOZTbP1QxhIamxaeku4uSvlVXqIo1UgTOPONHiFargvjAl7EX3PokcKCkxI1fzxQj7IUCnrFQN+kd97gNJcwBlSE700dwWmlZH/5diD5oGrlbqtDXWYF1Jn82W3oqKNL40w/HROaMqwZKQqjCz/mIV6pCbFcFlhxtohqN5121XDXHOifZ1QwaDgSWjDy/SpF/khqd3FV20KytYY7RahF1ryRlVH7/N2Yku8Z5FnICr5VVgq60OwjT0WfbrE8SDPxThQf4PcPEcnNx6CjdPgENiVj0dJV+BeZJWpH6ql6jYdxAhgP/9hl6hIyH4hKvY8BJfpc826zO1NCSZp+rn8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4740.namprd11.prod.outlook.com (2603:10b6:5:2ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 02:16:09 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Thu, 9 Oct 2025
 02:16:09 +0000
Message-ID: <e536ea0b-c466-4381-b92b-993be92fe65e@intel.com>
Date: Wed, 8 Oct 2025 19:16:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 20/31] fs/resctrl: Refactor Sub-NUMA Cluster (SNC) in
 mkdir/rmdir code flow
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-21-tony.luck@intel.com>
 <fbd49f1a-ddb2-45e2-b943-df43d2173503@intel.com>
 <aORMZ6NUXMpECHU6@agluck-desk3>
 <ed1a10d2-2f13-43aa-93f8-7dfe8864cf47@intel.com>
 <aObUZU8rnWIDR_tH@agluck-desk3>
 <860ded3d-2003-4d72-9013-a5fe97657934@intel.com>
 <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <DS7PR11MB6077A0323678A68DF5878C0CFCE1A@DS7PR11MB6077.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0349.namprd04.prod.outlook.com
 (2603:10b6:303:8a::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4740:EE_
X-MS-Office365-Filtering-Correlation-Id: b81f02b1-3d37-407f-1dbe-08de06d9cf83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z0dlQkl6VUpmbVVyam8rS0FrNkMzOEdsbzBtVWRnb3c0dTVhT2NFbisyazBI?=
 =?utf-8?B?eDJ3K3lQamlVRkZaaWFmODJ4SmV6YitmZk15ZmRiTGtJUk1TbHJBWDQweXAx?=
 =?utf-8?B?WHNuZmJvd0wwVDZPeHRaUTZLcHVmTGowM3prT0xTbllqckNMYW5UOUdGeGpl?=
 =?utf-8?B?aUZiczZ4OWtMZXRON25OMEd4bGtjVjZ2bE94bTl0bCt6ZHUrOVRPNEdCZUkv?=
 =?utf-8?B?VUxZS2NoQ1V2SHdYd1cyWnA2WlFIc0IvYXhJNEI2dG8vRWN6dWlreUxudzlt?=
 =?utf-8?B?TEd5WDhGdWZVSFM0OE83NHg1QjJseUUyZlNpNzYvSStvVEVpSFRacmRPM3Ey?=
 =?utf-8?B?ZldIWHlXeFd6WVpaRlgrcCs4K0lWd01nM1k4MzF4UWlhQndCaXgvNWE0MUoz?=
 =?utf-8?B?QnNIeHExallOVlB1ZEpqUEtML3VBZGhYZmFUMTIwT080YzF4MytLUm1qWjBH?=
 =?utf-8?B?UFBTWVNiblNGMnNVMDRVM0RTR0ljNzc1UWRvc0ZhUXE5TWxuN3V2OW45L2da?=
 =?utf-8?B?akd0YisrUTdJSCtEZTRlWnhDNm81SlY2aDhGRTZXcGZlb2ZEZjNDTURsOGlj?=
 =?utf-8?B?VzltR0pVeHltL0ZnSDVnWjBpdmVSU3cxVVpnMGVlMHVNTzFnK3hRQTFuajhF?=
 =?utf-8?B?M3JyVndXeERRUXYxKytxODRVZ2ZudGswcFB5TCtZbnJKOTZyTm9vcG5BQnZr?=
 =?utf-8?B?TmptZUFhZkdycVhidFd4cXd6WWd2V2EyMytuNWNsWm1jK3BySC8yVzE0N0o4?=
 =?utf-8?B?bDFBcTd1RkVDY2lpMmhCSGRjOC9BT3RDRTE2L0hpN1VyTmtlZTAwby9PUXND?=
 =?utf-8?B?Tk1pTVRaR2hlbE9nTGk5SlZTMm43MmQ1SGF6SnFVNWk5K09lYzNNZ2N3SEtH?=
 =?utf-8?B?cXRKQ1I0dlg2Z0NKSXBkWTFQK1IyaUxmMmE2dFU0STJINTJLU2hlcnhwbTBu?=
 =?utf-8?B?R0kzQnVabjZkdXpqVzNzanZzbkF0UG1TRFBDc04wSWV5dEdWVm9ickNSZEk2?=
 =?utf-8?B?NnRING1lMjMzMTVQWWJNaHFDN2FWZGNUNjVnM2x3bUxSUE9vSTZHRGVxclJv?=
 =?utf-8?B?WXl6NjhVdWVHdkE1b0xVNkJENlp1aE5qMndrNFhlQmZMSHZhcERSaVgxSDBa?=
 =?utf-8?B?U2p0cm9kcFVTVTFWY0hPbHlLZW9LZXdjVThhOWQ0Zi85TkRlRmpSSWpkbS9r?=
 =?utf-8?B?QzdCdFRUYnowbWlnTWEzVUdWYnMrc24yd2Y0VjUrREJ4MXFIMXIvR00reGZz?=
 =?utf-8?B?S3pzOW5uZlUxaWx5TUZibjJaL2l3Tm90bUlnL1dXcmNwSDRpVGlMZ0YwNHNN?=
 =?utf-8?B?M0FUWlJORktqc2Rqc09SSW1WVUs3Y0dhR3FkbGo4Tm5LdXBmK0pNSk5OU21X?=
 =?utf-8?B?NTRyY0p6TC9ubllTK1hhM09FZWVIVnU1WmZvcVhTU2FiaUV5bFFwbmJPdE42?=
 =?utf-8?B?U3Rpbno0OVZ6TDJEbldGNXBYY2tJbC9JSEM2YzJFbUV4UWxtQzZEYTd6Sncy?=
 =?utf-8?B?V09rcXN4MVJXcUhQcnppVHpMdTRzb1FVaVJyWkUwQVJLcnl3dmYrcnVISjYz?=
 =?utf-8?B?ZTBTR2ltL0dyOTdxZGlwUk1ma0NLeDBDVlR2emRwd1A2LzcvV1J1QkRBclBx?=
 =?utf-8?B?SmtYenpacTIxeHZGUWV4emZ5ZXlyYWk5dFdXVTR0T09tcGxkb0tnaENtR0Vt?=
 =?utf-8?B?aWwrOGJzNFZIUGpBQTU5SlZpWDJMMlo0Mk9Qdm5BKzdmZVBvVjFVcXlPZndp?=
 =?utf-8?B?TTRWWm5sNTNLQzF0aEZhK0d4SkoxODFTWE00RHFnQlJlK1FwTWtpUFFxaWJM?=
 =?utf-8?B?Z3B0YVlQS01QQWprQ0pIWjVTWWdIOHpJWS95TzdXMEEzZDh1QmdkcUFHT1JL?=
 =?utf-8?B?T1IrVVVKYVVZeVRDQkc0OU5yaGU4L2taLzB2UUVOOXJUdjU4VVl0eUJYZm8y?=
 =?utf-8?Q?UozzCLUOGbjFp5Sxe6XhtFl/MyJe9zuR?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0I0TjRUblI2TlIzSU5NOE0zMG9pU2FZdDhQOGcveFhhWFNvL3RaVUpHbExV?=
 =?utf-8?B?SVRheTU1SDVVMmtQTUVhTkdOTjA0dW0rMXIzTmY5Y1Z3TjJNdGhoUjBPZE9H?=
 =?utf-8?B?NWxVZ0Zuc0JMKzlCOFFraXBTOVpEUzA1V0FqTUZ5cm9hQmhyUlB2Y1pmbnUy?=
 =?utf-8?B?M25JUE9sZ0FpdjNkb1lmR3M1TmI3NEowbnNQaHFvaEk0Nmx0eU5ibWRNMkQw?=
 =?utf-8?B?cFhrekgvdkNPeGY4bDZZN1lHN25PYnJwY05EeUxROHNvNWVBZkhwSk94SUhH?=
 =?utf-8?B?dVF1eE9CaWppdmZneWJLTStENFpmb212NTY0QjNiWGowbklsNEplbGV3ZVY3?=
 =?utf-8?B?SmZvbHNuM1RnWGU3NXdUd0Y2N3J2dEx0RXoyeVB3TWhRclJtUUM1ZHZkQnZS?=
 =?utf-8?B?ZUFIUW15c0IrdmdxUTA5MFpJaGJjL2ZRY09FOUhNQWFIejZjYkVLaWt4bHJq?=
 =?utf-8?B?c3FjeHBWNmhyWnUyMzNnQ0Q2ZUlyZ0xzN2k0ZCt3WGxpTmVJMFhDNTBuTU1y?=
 =?utf-8?B?S1l6R2FZU1hyMUdBUTNPTkNtdmwzMGdlVHVzNHJJeU1vamc1QUlISGZ1NWJY?=
 =?utf-8?B?NmI2bXBrQXR4SjhZenIrWlFnbWRXZkFtTTBwTGllbWUwSUdmdkRhaXpad2JM?=
 =?utf-8?B?d3p6QmhCUDdZMGZLcEJET25NdDJ6SG0xbHZzQkk3OWhCOWcwS0Z5dUFqZTF4?=
 =?utf-8?B?akt3eG9TT01yczZ1eUY3Mm4zQTU5Q0xLekJleU1KYzdqaytjWk04YjBTekR0?=
 =?utf-8?B?VjdGUEQvQ1puK0xheGI4RnkrRUQrc1BqSTc5RnZvUDgvTWh2QzdQY3NzbHFM?=
 =?utf-8?B?cXJwdGo5TzJMeVhoTkxWUCtZNGwxU05GTUJrbDRieDBaMUZoeHRZQWJmTkNF?=
 =?utf-8?B?OXJEQXFtYXdnWFRKbVlyOHFCbjUrZ3FGQkpoVnovdlpaQXlqeEp1MW1Pd2k3?=
 =?utf-8?B?aDZobnUvcUVjTWYrYUJWbytwTC9xdFh1OXJtZWEzZnB5ZFROK2tzb1A5V2g1?=
 =?utf-8?B?Z1pTNWdVVkpZMmwyMGthRm0wZW5UU3VkdXdvU3Y3dmkwOWp6aVJaV3FKNVIx?=
 =?utf-8?B?NnBtNUFENDJ5QXl6Zy8wVUtBclprK0I3ZkhYVllESUpLNWxncFlzUytWeDh6?=
 =?utf-8?B?WUx3N29XSFVvSEZncXlXL0lmb2JzbnFVVUIzaFJhMi9KTktqQmtub3BEQk9k?=
 =?utf-8?B?UkR0U0hUUGJxbFlaUERxYVgyeUlYUmJ1OGl0cWsyY25LMHFRR2JnUk1HMEFp?=
 =?utf-8?B?UElCMW5YbzZ2U2QzUjZFR3lxWkg4TGd5Qkdzb3pDOCtsdjZ5TVVmZVR5WUVL?=
 =?utf-8?B?NGJnOG5scE00WlZYK3hmby9tcTcxamRhc0crSTR1anNjRWN2SXR5R3FUakpq?=
 =?utf-8?B?MERmRTZhRGg2aFRLK0tHSUI1VS9zaDk0NE56NGNlWnBScThyM3hSRHQvaEVo?=
 =?utf-8?B?bFNCbmw3alB4QmZ0VXcyU1B2MW5qWnF4NHozT1QwNkg5Qlh3UFBveUw1TGt2?=
 =?utf-8?B?bForaG9tNGZxMUU5NENaZjU3dGx1N2lLUzFFbVg3anZuaE44Y2JVMktIdUln?=
 =?utf-8?B?NlFDRWQwZWRWVkFQdkxZcmZ0VnUrZGNFSGlwUDc3S01YY1BhNlV6dTVRWHBy?=
 =?utf-8?B?WEVKNXlScmpjbjF5U1dDbmN3S0dyVER6NkwxcVROTmUxazFFSUdIUnZFUTg4?=
 =?utf-8?B?bDl2Q3MydTQvcmNZdENIenNZQ1hnck9hTndIR05qV1paRUx1UTIybW1ZOUNC?=
 =?utf-8?B?VnQxQVFteC9Qcy9BTzVGb0lGZmFIUlRKQnArYVpDeGRDKzBNNjcyZTh4aFN1?=
 =?utf-8?B?aFViVVhEL1FOa0VvTnBGVFFYZDlBVGZBNkQwaVkzN0RSM252OFlzRXUxNW1I?=
 =?utf-8?B?ckd1eGVsbHZ3Y2ZGd0JEYmZWTStWWDQrSDVibUtUQm1DaFVUUkQ1UUlqTmdm?=
 =?utf-8?B?YjdZdTBoa2d6YlJvYVdCOHVBQVRTZHJXb1RDY1Q0M3BwamdGaFRzS0dRZXpj?=
 =?utf-8?B?aExiZ2E5cGw2N2FhNmgvYlhrd3dQZndJcDV6cFY2RTYzQVFMdzlCSDVTdzhr?=
 =?utf-8?B?TDgzM3RGMVY0ZklwVXh4dzgwczNJNEk1R2l0eDdtL2EzVjF3ZkYwMk4rMis1?=
 =?utf-8?B?cE5TNGl6MFNjVDBLaVNBUFlBZzFzL2g0R2xoQXYzMU5iL3JWRTYzaHJKTTJl?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b81f02b1-3d37-407f-1dbe-08de06d9cf83
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 02:16:09.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQiugTBXpeObSK86pQDdCCL98MI/V/go7SbYIi73x+dwav3GWU+1Y85phWpTUnPWcdLm9hUgFPqklasMHZHR62TDQ0v9MALaL3K21B4ImnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4740
X-OriginatorOrg: intel.com

Hi Tony,

On 10/8/25 3:29 PM, Luck, Tony wrote:
>>> static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>                             struct rdt_domain_hdr *hdr,
>>>                             struct rdt_resource *r, struct rdtgroup *prgrp)
>>> {
>>>     lockdep_assert_held(&rdtgroup_mutex);
>>>
>>>     if (r->mon_scope == RESCTRL_L3_NODE)
>>>             return mkdir_mondata_subdir_snc(parent_kn, hdr, r, prgrp);
>>>
>>>     ... pruned version of original code without SNC bits ...
>>> }
>>>
>>> and:
>>>
>>> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>>>                                        struct rdt_domain_hdr *hdr)
>>> {
>>>     if (r->mon_scope == RESCTRL_L3_NODE) {
>>>             rmdir_mondata_subdir_allrdtgrp_snc(r, hdr);
>>>             return;
>>>     }
>>>
>>>     ... pruned version of original code without SNC bits ...
>>> }
>>
>> Indeed, this will keep the functions generic in the sense that it operates
>> on all resource types. This looks good since I think once the SNC code is taken
>> what remains should be easy to follow.
>> I think it may also help to (in addition to the mon_scope check) add a RDT_RESOURCE_L3
>> check before the SNC code to keep the pattern that SNC only applies to the L3 resource.
> 
> Reinette,
> 
> The SNC versions to make and remove directories need to get the rdt_l3_mon_domain from
> hdr. So they both begin with the standard:
> 
>         if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
>                 return -EINVAL;
> 
>         d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> 
> [though rmdir function returns void, so doesn't have that "-EINVAL".]

Understood. This is not about correctness but making the code easier to understand.
What I am aiming for is consistency in the code where the pattern
in existing flows use the resource ID as check to direct code flow to resource
specific code. In the above flow it uses the monitoring scope. This works of course,
but it is an implicit check because the L3 resource is the only one that currently
supports the "node" scope and does so when SNC is enabled. 
My preference is for the code to be consistent in patterns used and find doing so
makes the code easier to read and understand.

Reinette
