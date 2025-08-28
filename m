Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1FD283FD0
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756418746; cv=fail; b=ow1CNLfVwrawqFQEMHNwUaHVkn7koUdJoZ6tB62C1TAA3XHVWUbiVE8Fzf9yBAGJIlTCQDAtf3imCK6Qy53njNvO1ckesC7Nj3IvdGY617UW0+QLusxGa+pa8wJkI3G3uOBumCUHIkByPxcEGNQ58qiI1ETh8JH1dSqW5VeLNOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756418746; c=relaxed/simple;
	bh=SsZpg46hNXr0v1AlHRIhLCWctrAWgqolQTLT2L3SzDA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AaHMzoJ0M3Prr93tsHBppW4KnK3UZAZtmxA/Q09LBgwfubdc7NHv6dlmbxqDHQnxU5pSmYPiccTG3/BJC3FstG28UUY/Xvxn4VmuDm5RJ9oIVh93wymcHrXP2YJIjIlhX68sfD7XDkmfjiiaHZB+pDQbVmtUi3vdlUj6jj7crtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bICPcATk; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bICPcATk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756418744; x=1787954744;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SsZpg46hNXr0v1AlHRIhLCWctrAWgqolQTLT2L3SzDA=;
  b=bICPcATkbXgeOUk79MSe2Y3wdodKvX+lyj6amivjBqYQL4U0gGq4JSGH
   6/VERpmMSPp1irUp81Q/r4piJJebk8y4/GF2Ih2Vgu+01Xa6C6zpteyta
   kvtxjqPsJjd1xz9lury0G0ze2v5cRHOOm97kugrjlcf+xhQI2ZNTTGhL0
   ACiMUH0J9UmoEAhQnRgV3KpiMkLtd3FddaYMJ4C3GCv9UKVMmR15V0cxa
   HdAmQXNedUplLRhUz0PZ7xT6T4uPy5Vfg4gnXLo9WinTRriilvnGOWcoZ
   ysr4KUW8QjQyQ6yoY3esEllgcOvwn+4fY1MEP9P8pgNppeKTURVVN/kiz
   A==;
X-CSE-ConnectionGUID: I6HOz8QKQRe1M9ldymJ5Fg==
X-CSE-MsgGUID: q/0lTi9LRPS45t1MXplXoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76153344"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76153344"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:05:43 -0700
X-CSE-ConnectionGUID: cghjQtsfTViM99e53DfO7A==
X-CSE-MsgGUID: WmNhhyIXT9uswm28Nyd+LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174601652"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:05:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:05:42 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 15:05:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.58)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:05:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dc8SWM7kamyrmi13p0sfOlGJXfafz+h1CnRhr/NS5iMn/oaLcFns0ZW9BowgC5ou77lbpZQo9x5BJOfh0kbwp90kAhOHxCrfOzplyoSX6Ya6tl99d14ZOpnUEp3B6nONF0LIkHBRnQBNE2xgKd0iZadweaNzMGAdhZkd/Rghuo8l0eA+DSPjWLGAoTKcuFLKbE8nLUJhEv8cSMY1Q7r+y6MDOFabubIY9vM8BQwKrgsDAm+8l2QZDwNv8kLZJ7Pd6OA5gkOJVQvFukb2u/1AGlrYxACJT90VH18fZo1KcYSVdlsVN5G/KndUlJpomXxd2ArdFcsZrt+jJYIjan53eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QqrI4cVNE603H0nxQr6Bcyex3eG0KPijcKvUhFvr/Y=;
 b=DzmjyhoYc42yg9C1DnuVJrB5cjdTo/Z03uAoB2nVhknhcyinlp9f4+8P9R/YYuJc9+lbZ9MVVhmRpnkE4UtSHU26zl/LYkFBHU4rZ8UiXZcEuYdQF+GSeJ65ykWoEqkVh3zSGOA4S0Ubwb/qaLiHOPlZi02dvwpydmk7UvpyS9LPkfeFc95gOUQ7fl0YHnOL3uoSB+JFdORcfNvqe6L8A3DLBjLezdBm8NyBU0GAHWAsouLtbkYQVpBr5+TpXHCH01wNlMTGgCSK6zPeBgTEWOkcBrG5xiFfb0yRabMcajVi4CkQEafelvJuLUG6RzJ+c3nGg3DwcszqHgOfprHM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 22:05:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 22:05:35 +0000
Message-ID: <b3874a0a-f4b6-40cb-a705-d5c94d6173e3@intel.com>
Date: Thu, 28 Aug 2025 15:05:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
 <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aKzhsOWp2TlFF5mK@agluck-desk3>
 <d06e81db-1669-4a6c-ba75-67fe15c53303@intel.com>
 <aLC4wVQiBDHW_Jte@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aLC4wVQiBDHW_Jte@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:303:8e::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 89908432-99b6-4f91-13da-08dde67f03d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlBqbDFTUjdQdXl5SWF6QVQvRncvd0c4dFZHV045OGRjL2htcCsrWXcwcHFV?=
 =?utf-8?B?Tmw1YWVFdzJLTmxIMjZYNlNLNE9peWtmRERYNFI2NVVLL1cvcFg3bE8vOGs2?=
 =?utf-8?B?WFNSN0taZDBPelRmTXFWbE1jZGlQeE1ka3p6QmY3QTF6b2pEbHJtL3FMTGxn?=
 =?utf-8?B?c0VULzRJZXRCdU1ETTAzbEd0QUFMWU5SYkN3aW5kRE1IWS9zZ2xVa3ZyNGt4?=
 =?utf-8?B?TGFrY2FIeDVFTSs0RWxYdjF4Um1MbmNMTnc3Nzg4QVFtaDFqcHFQQi9NSDIw?=
 =?utf-8?B?N2RGSFpOa3FGYkFUWWtHRkR3TXRvT2cxdUllVHFvYWY5OWdWUlpJTkJNU2xF?=
 =?utf-8?B?TnUyMDFKcWNFZ3NnSXk2eklxUGlDZUp4anlOZzFvLzh0bk05MnlMYnNBY0Fw?=
 =?utf-8?B?NXc3dVI4ODErNVQ1M1VMY29YcnhOcGtkNWhZUXFZaWtIRU1ldTlkMi9rSFdh?=
 =?utf-8?B?OGZEQTFrRHNmbE1DMC9VbHFyN2xyL3p4bXY3UjNLNzdYY0V5TURNNXdJSWpn?=
 =?utf-8?B?c0p3RXJranZZMmFHemFCR1dnUSt3Mm94bEFvdjROckExYW4xS1hEZjJRbk41?=
 =?utf-8?B?OXFZOTBtVzVrV0NLaG5UVnZjZ3hDUk45UlkvRjJMaFdOcytOSEVMZXkvY2U5?=
 =?utf-8?B?a2hmSXZDWVc5eXZ3Nm8zNnFoRG5JWGt0dkxHWnh4ZmF6a3ZmcytLQmlMdTBK?=
 =?utf-8?B?K3J2cWZQdG45QndoV1hudjJjdkNLMDhsODd3Smg2WVk1L1VEOFV2TFkwcWxv?=
 =?utf-8?B?UzFlSGxIR3BGeUVKUWRSdFRWeVJKZzh5OHo3L0FBMkRGNEtqcVhIUCt5WWVs?=
 =?utf-8?B?TEp3NFJOdXFQcmRIbm53RFRoSDFjRm1VeFp5bUJXM3ZvK3VmSXVSUzJ0TzlV?=
 =?utf-8?B?R2RCQi9SM0hiVHhZbnhXZWRHaUVXcStiRWFkVCtjdCtlemNQTXF2UzZibWV2?=
 =?utf-8?B?VkRMbkhtR2tuS0xOempiRDlPRzZNWUVKL1l5ODFlclFObHo1Sm96ZWVmb0pp?=
 =?utf-8?B?bERtV2x1ZW50RE1OZWUyajAvTVNPRUZ2NTgzbGw1WjNVeUpxd2F2M1ZaeGFR?=
 =?utf-8?B?RThWRHF5V0k4bUlwZ0RjREozdCszRTA1YjVFZVNGS0s1amNnZDhZWHozdHZG?=
 =?utf-8?B?MHhaaU9HVTdpdzdCQ2htOGpoVWxtUnd5Z0I4a2diaEkwbDJmOEZEcHFvUkZj?=
 =?utf-8?B?MXREd3Rja3FsUFpZZzFYMTFzazZYUVNMS1RTMWZUMXV5b2lqaHIvS0dnOFg2?=
 =?utf-8?B?MlhvazFNaFNTdmVSeStuSTYwMmcwTnQvcGpzZC9WaXlIWXpHSXZGaXQzK2Vy?=
 =?utf-8?B?a1paM0pPaE1kL2p6TzlZK1FEU1hEdVNtQ1R3RE9NL1BKV3hxSmkyZ3liNEl5?=
 =?utf-8?B?bnQvMjNFTlpiRkhXU1BEeHpiMzNOM0Jja2ZOeEQvZm9YbWFnQkhHMkNEVTB0?=
 =?utf-8?B?RFBYemlhT1Yyc01lRTh6TFZJU3doMFZqV3c0TG50TUZJMkFRS3Bjd29MZGx2?=
 =?utf-8?B?RWM0dENSdks1NnpwejN4SDNFaHdsV25OR1pMbERGMmg0RVZDS2JZN0N5Y0xX?=
 =?utf-8?B?VnE3VWpjZDgwL1lmR21PWVdySkh4TFpiU2hiZnpHalE5WGZiNFRFVzdiVFNp?=
 =?utf-8?B?RUF3Qit4eitVdm5iZGlPSUZ5N2pacm42MWhJVGRKZXBlNmVMWUZSS1Ezak55?=
 =?utf-8?B?Z3AyZFcrUUE5d2pvb1JGdDB0RGFhaEZla3NEeExsbDlXdmhxaHVoTFgwZnFR?=
 =?utf-8?B?Q2R2Qm5kakw3SFhSYVlpMktCcHFQRGgwZUtnQkdUaUhYdUk5VkV6cUZ5WGUv?=
 =?utf-8?B?dktGdlE1ZTNVODRWMUQzMHZJaVU3TVpTMG84V0VEZHVuSXJSSTh2anZkYUh2?=
 =?utf-8?B?SlVZNWZVWVpJZGpyV0hvaHpiZngxUmRQWHFCUUE3SFlDcXZGbHR0UG1VOW1M?=
 =?utf-8?Q?ClaMFY9A/HY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHhxWGxOYVhDZXJtbnI2bDJuUVhpbDgzZHFLNDNxQlJlUHRUdWVRSnMxNkkz?=
 =?utf-8?B?NU9meVh1UElDdFV1cHhDTjd0dkswVDliT29SNldIRkx2UnJBbVhWOEQ0VC9F?=
 =?utf-8?B?VTMzcVRCTXkycjBiM2EvbXYySEFYa3FHN2dnbTIwR3lMUjZoUll1ZFVKcEhF?=
 =?utf-8?B?OHlUcXZHUk1rYklNenc2N05YZWZacHB5UVo1L3Mxa0xEVnZwVTVldStIdmI5?=
 =?utf-8?B?TzAzMWZhdTlMSTBLcVYwOXpGWHI0VTlmLzhUeU1SeTlHSWJwOG9rYTlWcXJR?=
 =?utf-8?B?WW5EdVNpVHIzWDB2Mk54bkFsTUMxWlNwODRwaGo4dUhYcUg5SERRaXJtQ2Y2?=
 =?utf-8?B?ekZPYXdJMXlieWVGUXBsZFNUa2tJUjd1bUwya3FtUmdRTGJteUk2K1lMYXJw?=
 =?utf-8?B?SGduTGZpb3h1a3BhcnQ5Q1RrNzNjZmpORm9DTG5xbm1wT0JyYUhmd2xxNXV4?=
 =?utf-8?B?bEwzUUhtY3plNXJGTkxFcHU5aXovUHBuTXoyM0hsbVJRU0tnUVhvYjgzdzQ3?=
 =?utf-8?B?WHJmZjlMeEc3Sjl5MTk5dUc1S0JLZEMrbTNCNVNuMXVBeWo1alRWa0kzUmEw?=
 =?utf-8?B?Vzh2Uml6SjhKM1hqL2dFeUl1TGppdnVleXVuV3puQXhWK2l4K1c3NFYwQWVH?=
 =?utf-8?B?WlpBZ1VCbjJsQnZ1TWt3VkFjdGUzMkRUZGlsVmIzVE9yL29ic0pUK0lQZTg4?=
 =?utf-8?B?b2w3VWpOZ1hhS0t2SU9yWFNDbCtIR2hmTXJ3WTMyalhCR0FOOXNuYmJ6bG9N?=
 =?utf-8?B?WE1CM2x4bFhSeFBBckJrRnVIcDVnM3RqbWdtaElvK0tPWnVQNVdiTUFVTU9Q?=
 =?utf-8?B?REh0ZDcwVGJDN0cwRTVLdUNvZ0NjdFZLbUw2MWpxU0ZEVGpYMkxCVGQwUjBr?=
 =?utf-8?B?YURtVlpVbW43bnJEUlgzYWZURzVxN3NUc2toUGZvMXRxOUYrNEdGLzFDcVRU?=
 =?utf-8?B?ZGEvUVdiMlVROGtPUlJxaHlDSG9veGpOZnlSc2xvWG1jdUJCMktGeit2THhw?=
 =?utf-8?B?SXVHUTVDVW8zQXcraXY1UjBnODNkbXRwYnRUYkhmQ1lGeHB4Q21sNWkyMzBn?=
 =?utf-8?B?Y3JQZnlkSThlOVVQUktsRmhZdTFvSm1GOGlFdEljRkxDZjJ6RXg0ank3ODIw?=
 =?utf-8?B?L1FLVEpMTlBSbEZrWDgrZCtjbFFLZ2J1am9FelNGWmp2VG10cWN2bEZZNXVU?=
 =?utf-8?B?UWpzcVFITGdhcWNGUldIN2d5NFJJbVVaRjNkQ2UvTWtPeFNvSWxiVWFnSnA0?=
 =?utf-8?B?YVhpODRScEg5OGdIeXRtNGdUUU5obXNkdUhDb1JlKzJEREI0Wk5kZU5pUmto?=
 =?utf-8?B?b211bjFVWGhpQnpvWVFVQTVQUWwrRlRXMGtYVHlMKzRxWitUVi9qNkIwRXRh?=
 =?utf-8?B?VWcyb0xEa1ZkWGtOY04zSXg3cTFJV3cxVVhjSTcxQnQyZ25COVlpM3hFZVZu?=
 =?utf-8?B?RjdzckFpUGFrMXBFcG9NQTJYL0hqdUN5VnY5NHJzcDhwbzlSN0hzZTZJZU4v?=
 =?utf-8?B?S1VPMWFLdEtHZENJVlA5WWFIWjJtQUkxazZwcW54b2tQdUQwS0YyWldxQnJ6?=
 =?utf-8?B?S3dod3pSdkZwVHJuTCs2cjJRY2Q1MmVna1ZuMWN3WjlxdlZXWStFNElnOU44?=
 =?utf-8?B?Z2FCUTJ2Y0NxOEYwcjR5NDNkMEhrN0pRZjNYV21RN0R4V0hkQXoxVEZ3NC9j?=
 =?utf-8?B?UkxsbG9PamltVVZsaGk4Z3lvTWY0eEtOcm5pbmcxS2VyT0V3bk5DYjVWbG85?=
 =?utf-8?B?bnpIaXVrL1NTdWxvY3F0TEVoSXBnTFFWMkRyN1QrNzIwRnMyVkVDNGJnbmx2?=
 =?utf-8?B?cUlvR2l2SE4yYXl4cWRQZERoUFdhMTIzYmNMWG5VT2ZtNDR1U21vdmVweTZv?=
 =?utf-8?B?WWpwWDh3Rmc3ak82UTI0QUZDYlU5ZlRPUDBNQ0JFV2Irc1NwQjlnSkxrSXdL?=
 =?utf-8?B?eTNSSkwxdUhBdDVXbXBKUEtnblJDS2tZOHFTbEpSdHFTaE9iaVduUC9FSGd1?=
 =?utf-8?B?NU5zVmV6SEtiN1g3OEsxQk80bnNYL1cxbEhqUE1zQjVhdUovcnhlZUNaNzNW?=
 =?utf-8?B?QytxdTVBQmdIYld3SHk5ZnU2VzFyTGJubnFrVURMNG5ydURjQTFhS0xQeGF6?=
 =?utf-8?B?VWJQa0dZMDd4eTN1czhDN0tGRkZZZ1VvSUpHWkZyMVM0SzYrcUpoNXpqV1M5?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89908432-99b6-4f91-13da-08dde67f03d8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 22:05:35.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdJCELHRqqVcHzv9rLQSrDq5zvfW9gz9BPPVl1yM+ltMLczLQF0IZLRi2zp5xnG1zytYobAh/WE3WfWklx3EDAZx4ruswvaGkdBkjOsBsWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com

Hi Tony,

On 8/28/25 1:14 PM, Luck, Tony wrote:
> On Thu, Aug 28, 2025 at 09:45:41AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 8/25/25 3:20 PM, Luck, Tony wrote:
>>> On Fri, Aug 15, 2025 at 03:47:17PM +0000, Luck, Tony wrote:
>>>>> I think this series is close to being ready to pass to the x86 maintainers.
>>>>> To that end I focused a lot on the changelogs with the goal to meet the
>>>>> tip requirements that mostly involved switching to imperative tone. I do not
>>>>> expect that I found all the cases though (and I may also have made some mistakes
>>>>> in my suggested text!) so please ensure the changelogs are in imperative tone
>>>>> and uses consistent terms throughout the series.
>>>>>
>>>>> If you disagree with any feedback or if any of the feedback is unclear please
>>>>> let us discuss before you spin a new version. Of course it is not required
>>>>> that you follow all feedback but if you don't I would like to learn why.
>>>>>
>>>>> Please note that I will be offline next week.
>>>>
>>>> Reinette,
>>>>
>>>> I took one fast pass through all your comments. I think they all
>>>> look good (and I believe I understand each one). Thanks for all
>>>> the suggestions.
>>>>
>>>> I'll try to keep (better) notes on what I change as I work through
>>>> each patch so I'll have a summary of any areas that I'm unsure
>>>> about for you to read when you get back before I post v9.
>>>>
>>>> Enjoy your time away.
>>>
>>> Reinette,
>>>
>>> I've completed a longer, slower, pass through making changes to prepare
>>> for v9.  Summary of changes per patch below. I didn't disagree with any
>>> of your suggestions.
>>
>> For me the item that I expected may need discussion is the use of
>> active_event_groups that no longer exists in v9.
> 
> Yes. It was removed as part of the refactor to drop the pkg_mmio_info[]
> array.
> 
>>
>>>
>>> The bulk of the changes are small, and localized to each patch. The
>>> exception being removal of pkg_mmio_info[] which dropped patch 18 (which
>>> just counted regions prior to allocation of pkg_mmio_info[]) and patch
>>> 19 (which finished filling out the details.
>>>
>>> discover_events() is now named enable_events(), since there are almost
>>> no "steps" involved, it doesn't have a header comment. The name now
>>> describes what it does.
>>>
>>> Theoretically skip_this_region() might find some regions unusable, while
>>> others in the same pmt_feature_group are OK. To handle this I zero the
>>> telemetry_region::addr so that intel_aet_read_event() can easily skip
>>> "bad" regions.
>>
>> This is a significant change that simplifies the implementation a lot. 
>> Even so, it is concerning that resctrl takes liberty to reach in and modify
>> INTEL_PMT_TELEMETRY's data structure for its convenience though. Could the
>> changelog motivate why it is ok and safe to do so? Should something like
>> this not rather be done with a helper exposed by subsystem (INTEL_PMT_TELEMETRY)
>> to be able to track such changes?
> 
> I can update the commit message to explain. I did check how the INTEL_PMT_TELEMETRY
> code handles intel_pmt_put_feature_group(). It just does kref_put() on
> pmt_feature_group::kref which results in a call to
> pmt_feature_group_release() which simply does a kfree() for the
> structure. So it doesn't care if I modify any fields (except for kref!)

My assumption was that "getting" a reference means that there is a single 
object to which multiple users can obtain a reference and then the object is
released when the final reference is dropped. Now after looking more closely
at intel_pmt_get_regions_by_feature() (btw, it is still remapped to 
fake_intel_pmt_get_regions_by_feature in the branch you provide) I see that
every caller gets a fresh copy of a struct pmt_feature_group and not a reference to
an existing struct pmt_feature_group as I assumed. This is unexpected to me and
not clear to me why the reference counting is needed in INTEL_PMT_TELEMETRY.
Are there any kref_get()/kref_put() on the pmt_feature_group's kref?
 
> If INTEL_PMT_TELEMETRY did care, it would have marked the return pointer
> from intel_pmt_get_regions_by_feature() as "const".
> 
> If that isn't sufficient, can you expand on your thoughts about a helper
> in the INTEL_PMT_TELEMETRY subsystem?

Updating the changelog to highlight that INTEL_PMT_TELEMETRY provides a copy of
a struct pmt_feature_group for resctrl's private use instead of a reference to an
existing one will be sufficient.

Thank you

Reinette

