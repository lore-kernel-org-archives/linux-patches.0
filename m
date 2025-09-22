Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085A2E7BD3
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758583805; cv=fail; b=rS+gQfZMnHEn3HnVwZc64JXS+63C6KSlV0sF5qGwbfgjBS2EL3EoQk0JppFLbjHOoRkdkK1UsP4nN6y0LctZKajZGHWrHvTzdGyLYOwmpDtcj3PiRelY4W7uxIgg6hJvun3m11VcELaKVKDshEBkP+fJVaD8AWMTlMGOz6GfTWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758583805; c=relaxed/simple;
	bh=bZ8hWF5zOoQsrMTYXRGp1hoyHMp7JsyrkpvsaAvGwj4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oP7jG4KtgWGmwP/lXbTtG5uhoP2OOq2zasmwwmDPiB8lAWahlfXrPXsbu1WTvaBjLo5cVcA4S2EiISk8teQz9ClC3JSS9z9bXY9zDw1oViCPwhCEGIOLAnNEM1y0Br96NLMUyxRpNUHnMIz5qqUzmg9Akb4H8diRjs5WNRrQUu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsNWCbPK; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsNWCbPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758583804; x=1790119804;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bZ8hWF5zOoQsrMTYXRGp1hoyHMp7JsyrkpvsaAvGwj4=;
  b=HsNWCbPKnk7b7HTfCY1Da8sGes8C1OdYQag6IJpOabUobSo1+2o9JcEa
   yldnnLVEQnVbKQFhU6LH3okwqLU4fhN6Dlf9/6HlX29h5Fo/EAZBB3lFZ
   X3uCXWBJXlX9ZMG7jdhDPgIApMq7ecL7eMyDKiQ/Ft9TjLLpRZan/72Lj
   Lr4b68L8mgERSdenhmGOm4c9E75bFy7J0mUvFSJLT5XCmIl3V7RAxGCBC
   bChB6/3bILl7I76v1QJbkGpLodiB5ya+Oo3Nlvq40i6msRrGWB18lac+y
   LBl4pmDsZH6FC/Yn9t/EpqsIpB8woHjwZ8KirV+ZNPKYQ4vShQvx3ME9c
   w==;
X-CSE-ConnectionGUID: SG88Y4kySs6ZaSYgFoEDtg==
X-CSE-MsgGUID: /I8WRlenQC+L2FRwHx5Knw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64660703"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64660703"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:30:01 -0700
X-CSE-ConnectionGUID: 6cftxAm/S86XyhKE9V1vyg==
X-CSE-MsgGUID: B5hePV8NQ1O8v0cyANOn6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="177389071"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:29:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 16:29:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 16:29:58 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 16:29:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R5awC7JPr6Xs6+c8Op9EI/Gj1UzhBA/sPcYZKmBRcQGQJV41pnMMroQvpIQ+cBjhEaJrOytGvYHlpVWMdoZcsJ44vNmijTra2oGfFSbSai+NPIKOItrS532fYV0BjuwWAQTUH2rAbgGeJ7WcKyEzWw8AVcbFrQIQ0KWlA6oDI3b5mrqEgD2zk0TBRQ65A9aL0Twye6hwKmVa6uwgdDKJsMaoee4iEa9Wdpv/S8TbykZ63D+xA/leXtFvj5x2boTuNY1CfAc+poNnfma8W1lfkqqtjDCNxuLJxTUwgAMRYYpdzdaHJrW/Yu7QZYJaHhQ3dq5WJ/2Dz/KmkdVUgl25kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMVfKdC/PwlwBwcTpcVZYtjaEQZiZf9o/hQ8qzvDBKc=;
 b=nQK5lA4CTgRPCk643Jy1LXcZ0DuPp4uLT+bOKZ/PrApjw9oWC+lsC/tgYnchpsfqY5yU1RDsZPBZwCcxPs8luZ6GyLSz7Dwgkx3yIADacZ5+cm59P69vQSRPB4lyw1MoX71sTqiS7CRdrDqjeDLNtmjQNlmybK6hpu4VwzJ1+PRQogDghfO2XwdIQGhcmGeHdWAmc7YlCQ67yBZwpsdRUsF1CjHpRKoP88FKReO9V0qaVo2uY/fBeVvGKHAnBTlZFEUri/xyrQ7ZGdjuZ8aIcnlyQIoqOXUroAi/wCRANrxMgsmcNWBiRf0jmZEVd/THVdEsDV/015anGtuV5lUymw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPFD83941681.namprd11.prod.outlook.com (2603:10b6:f:fc00::f55) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Mon, 22 Sep
 2025 23:29:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 23:29:56 +0000
Message-ID: <1bd224fd-bc80-41ad-aaa6-863a7604890c@intel.com>
Date: Mon, 22 Sep 2025 16:29:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/28] x86/resctrl: Move L3 initialization into new
 helper function
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-3-tony.luck@intel.com>
 <67f34897-d5b2-4ea4-9e4b-edea86b7636c@intel.com>
 <aM2cctuXS8NBLeJ5@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aM2cctuXS8NBLeJ5@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0189.namprd04.prod.outlook.com
 (2603:10b6:303:86::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPFD83941681:EE_
X-MS-Office365-Filtering-Correlation-Id: e7645103-9b08-42e0-586f-08ddfa2ff086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UU5QQkF0WEcxWi9ZTW1ROUJSYk1VL2JCK0RMQ2c3Mm9OK2NrSkp0RC9PaGdO?=
 =?utf-8?B?QU16NHA4cktCOWRNQjdhUVZzeTVRdUw2aGlBZzhPZzBHeWxEaXRpMXk3K0dR?=
 =?utf-8?B?ZlprVmdkaEtBTm02Zjc3MEVMZDh3aWRaOGc1VEJoQnAyK3NCeUhCVVo2bUlZ?=
 =?utf-8?B?emVCSkFKdXJWTzJQTDZGYzc0NXFxNVZXYzU3RW1vYjhJeGtIUHV0VjkwQ3NM?=
 =?utf-8?B?N0ZYcjFHK0FIeWUzeFMxdENHREJlTDViNlVoZ29ZcnoybUdCaGh5THVOdzZG?=
 =?utf-8?B?VS9zZndLUEFLYjc1MmZmYjdXMENsUXJiM0RMa2NpUUw0ZlNib0ZhNDFXbEJq?=
 =?utf-8?B?WDB0enF0b0ZMTjA3SXNTWDdIZEZQbURrWjJiekJSUnNQaE1EMHNvZWZmQTVC?=
 =?utf-8?B?dEpRakloNWtoOTZZQmwxekJvNDIxNzgwbDB5MUoxMGxPclE2cU85K1Awa2Fq?=
 =?utf-8?B?R1J5N3FBYlFUOWk1R29Oak5lWi9JYnhGclRld3ZDMGY0NDlubWo2a3hQWUVy?=
 =?utf-8?B?eVZaTE5qT1NES0dhSmVSbWk5VkNRRFprUEgrdXYra0ZVTWsvbUY0ZHFQakhq?=
 =?utf-8?B?TXVtdnJzT1d1RE02Y0ZiRGpHenJGa1V4eHBUa3ZkUFgzNGtXTUR0Zzl5Rm5U?=
 =?utf-8?B?OC80Y2xJYmRKZ1pWVEpqYlAxTEdZSE9ybEFndWVsbGdEdkdIa3BmVCtXa2da?=
 =?utf-8?B?V3hsVFVjQjdQNGR4b3RIM1B5RzNoOVl4cU5Zc1lkY2h5aGM3bG9QNEIzZ21p?=
 =?utf-8?B?UGIrL2dqdjloamF5bGF0L2hrVFl3Z09qRjhvYjUxTnNjWmZjakloNkV6SzVJ?=
 =?utf-8?B?T3lUOG9JeVM2Sm5iZ3ZObjdMSjRHMGFWWFpJNEtrbzJaR2M5TlU1VTFkZHZs?=
 =?utf-8?B?QjJZdlprRXlsMktPM1JwdFVjNVlYQ0ZvUTF6ZUd0U0FTbEJxYmNHWmRnck1i?=
 =?utf-8?B?OWJNMFdaRnFLY3ZObkU4YmFyT1NyYSs1QisyU0ZLZ3BBWU44aVlMRHptK0lZ?=
 =?utf-8?B?OEc3U2t4S20weXpEQzQvZUQ1Tk9ZUnZNQkx2SDlJYjBzMGxMMm5YQzVsZzNm?=
 =?utf-8?B?ZFB2WFVsN1o4eGVtWlUxemh0K1p6VzlUMjdyNzQ3OXhkaGxHcGI4N0c3YkpS?=
 =?utf-8?B?czk4dmNSbVNmVCtlYUZuSTZWQkhDS1BzL3BIbFJBZmxMeW9SMjdyZW1kVXhx?=
 =?utf-8?B?cy9JL1hzenFPQitGOGphMmNLcWhTelBMbnhwclBsRVN2Tm4rODQ0R2FGTGhU?=
 =?utf-8?B?R1dHUHBGVUpmM3hMWnp5SHd3b1lxTnkzYWF3bHNIWi84MTNCMU5JOGFuaUtT?=
 =?utf-8?B?Wmd2cERiR3dmTEVJTWhZWmM0U2sycTcxOHBEczExam9DV3R0MHYrYzFJWjZr?=
 =?utf-8?B?L08rc2d4UmRFMkRsNGpsdkU3NzBNZ2FtUDIvOUxrdHlkM2N6d3lWb1F3WEFE?=
 =?utf-8?B?MnloeDBZejFVWUdmR28wQ0kwZ1JyODFGdnNzUGt2eERjSm50MDRyY1BNQlBY?=
 =?utf-8?B?bk5JMkh6Wk1KeXFlNjVnMW9jSDBlS0E1TkFHWDBqNE02Q21HbXZ4UXVpcHVF?=
 =?utf-8?B?SStwTTdTUG5yMkVJdW9UM3BsbWVxSXhwUkN1aDJXRVMrNWVROXdnVVhUdzNz?=
 =?utf-8?B?dmt3VlBKdjNRdFdJYmQvQm5HSUpUUFF5a1RUclFWREJVL3kyZGQxVUtKSW45?=
 =?utf-8?B?VUNMazVWNkpOL0JwS0dWRWdrU1JXcmpWTENDaVJuYVowL2pXU2dNYkhRMXZq?=
 =?utf-8?B?dmIvUy9lNFFGczh3Q0Ewa3puZTBUWGFNVHAwWW5Pb3RydUtRT2o1Y1JRTzhM?=
 =?utf-8?B?RnJqb3NSNGNJODJ0UDkzTFVLZlcwNGVlTkpQVG9aSmRWYVRjL2NSWTcrZWpL?=
 =?utf-8?B?empjWGovRHlhU2VUWkRSejMvRnc3RUpyNzZKWmpiTDhuZFlmempoY2hyMzRz?=
 =?utf-8?Q?rWf0ES4p/RY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWgvbkx3Q0dTT1k2M01tTFdQQWVOejhTZXRjaklFK05kd25sYk9BRmpQZTdy?=
 =?utf-8?B?NG4xWCtIMGQ4T2FYdUg1dGRaMkNsOWdpUk5UNmMwM0JGSjFuNGhBVDlURzI5?=
 =?utf-8?B?MU1sdEN3a3RRWC9oTDlzbzQrNjZVVTNtZjNMRS9DdFRmaE5BQjZ6SHN5RHhq?=
 =?utf-8?B?eUMyZ2diQlhCalg0U29WZURrT0VXb2FraGlEeXFreUZWNlUyOVg4WnRwQUph?=
 =?utf-8?B?OTcxT0VaWVpxWStlci9pL2F1SHRoWlJPWk10WDk0Ym5NRFJpY2JsWXE1dDQ3?=
 =?utf-8?B?MzkzUHg3dmhBWWJHN3h2bmcwK283bFFuUXJkcmFoQWkyTy93N202MVhEREp2?=
 =?utf-8?B?U0hTREgydEpxUjIwdkk2b1U0NlpFczlFM0QveksvYXA5K0hqdTg1RGdBVmda?=
 =?utf-8?B?UnFRNEhpWmJhaXpyK3g0TVk3M1Z2L2pFUkJJbEo4akZqNVF5ZzJpcGdKbisz?=
 =?utf-8?B?a09kYjVFd1RIY2hWM3NhbFJqaUtkMFQ3RFkvL0ZkNUxDUXpRejhCM0pCb01F?=
 =?utf-8?B?N3JhOHdmazdZSW9QWlVSTGFXQzJjdkhReEovaEwvNTNjOVRNcDZBODB5ZUVo?=
 =?utf-8?B?QkdvbXRIeW4rU0RtOURmcHRKV1lIMXY2V084dDU3Mk9KSDgzWnBIZzg4dnZ3?=
 =?utf-8?B?Q1BkbDkvMVZmLzFBLzZvS001UU5JMkZzM2NiSFdPQjZENFJGYTR6aUwxVzIx?=
 =?utf-8?B?N25TZUNTRWJreVgzWGVHRENlN2d6THZOWVFNSjJNNkJkNHpQRFFFM3NneC9F?=
 =?utf-8?B?aE4vUkFMcC8vUWhIZlBVNDRpamdRMHhNeUttZW9sQUFRUGRNY2ExWGhyTDh3?=
 =?utf-8?B?R1dGdXdWWk50NTh1a2ZUVTdKaFM5U213Z0J0WE45Mnloem9Kb0dNalVDMXFQ?=
 =?utf-8?B?Z0FVQ1ZNaG54K0lxdEowVVBlVmJmb3hBRldQanJVUUp1Y0FNSFFtN3lzcERa?=
 =?utf-8?B?cTlzVm84NXUyZEowa2M3M0dmRUYzQWtWWFN0OTFydVNONkkwWEtPSUp0elVB?=
 =?utf-8?B?QW40cERSRE5RdGFnWWlITGtwN1lKVllxSktUc3YxYnFMSXhVT3M3NGloUkVa?=
 =?utf-8?B?aTExblYxSHNqa3NJWFZlTkJVaDd2RzR5cHpCZ2E2ZDRQeVo5eUNlcWp5UURL?=
 =?utf-8?B?R1NKY2J0d1JFUFo2cjRHeWg4aGh6QU1IUk5yRWJLdlBWa3JLWEcrcktKTVlQ?=
 =?utf-8?B?RzZZdG5xRkNib1ZZbnp6OWhwYmV3ZzMxU2IzdjVmdFpqWkkzOTZlY0lqc1BJ?=
 =?utf-8?B?ZEp0QU9Zb29ubUNzOUFib1JIYTh2VW00cjNWa1lrUmRiSFZZKytjU3RXamlD?=
 =?utf-8?B?c2xOcFlDVGVBMlFEOG1GVUtBTmR1MTNRMzJubXBNblN5MEdMR1dJTmdwR0RE?=
 =?utf-8?B?bmliQnNLWnphOU1HeXpYelBPeUxCOFkyRVZwc1VMU2dlWE9nZlVCNE1XZTJ6?=
 =?utf-8?B?alZCeVdGeDdkYTQrTDUzRzZIQlE5S2lKK1F1eEZTMi9WdkNsbGd3SzRDWTdm?=
 =?utf-8?B?aXcyTUNoM0N5VURZalpCUHlMSXhOc09EQUJDVTZPdE1Xd3VNZWo5b24vdldP?=
 =?utf-8?B?OTBsTzI4N2oySFRVWS9GQlJXZUhnd3BEbnIyeTQyMTNjWW95dnVZUTlpVTFX?=
 =?utf-8?B?dmFkaXJWdkN6RjBWZmFpMlkyRzMyTXliRU1sT1pEZXpNV21mZ2RLMHY0ZklQ?=
 =?utf-8?B?TjlJY2tEdWlaUFpNKzBtNSt5cUo0NW9IRW5QOEphRHpWYmZDY3dkVHoxMDc1?=
 =?utf-8?B?K2lzZ1RobldsWEdFd29vOUZvb0YxMUVqL2QxU1JTR0x2WnVzRkhBWHpRRUNm?=
 =?utf-8?B?bnBPNlk0SllVMUhiMVhQL1VZMkJRQ21EWjA2UThUZ3NPK0k5QzNFY3VKblBH?=
 =?utf-8?B?cnVESDJZb0lZYVVLaDUyNmMzMGQrOStXUlk5SjR5OTVycUExMXphTWpCNVRK?=
 =?utf-8?B?dk5aUXgrUzBwTWhpUlh5ZGdoZk9vUThuY25NeWFCdHFwanFVdzFsLzkxK1BF?=
 =?utf-8?B?YnVJYjNzOWdsd3FXbmZyc1YrL0VoMEFOb1E5SzF6VHBjeG84ZXBmbXFWZE5R?=
 =?utf-8?B?NUpNbTFRRTlnd1ZBMkxIaVNKMzh3d2xWMU5qSk52aUpkMzZoNzFWRjdqYlM2?=
 =?utf-8?B?b3FFSUhvL1hjL3hWTzVhc2lmWSs4N0l2ZTZtRXF6S3FyNHFoYm44MUE5SitZ?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7645103-9b08-42e0-586f-08ddfa2ff086
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 23:29:56.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFZUe6WIvBQwIz9+LNmX5jC8G2YFjR2gfYiIyTHOcWtEd8NAfztDuBMUQHTyLJo4Qiymt6ib8RFQ7TnqyKPVqCpgEoLmHYKujScFdU6Avv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD83941681
X-OriginatorOrg: intel.com

Hi Tony,

On 9/19/25 11:09 AM, Luck, Tony wrote:
> On Thu, Sep 18, 2025 at 02:49:05PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/12/25 3:10 PM, Tony Luck wrote:
>>> All resctrl monitor events are associated with the L3 resource, but
>>> this is about to change.
>>
>> Please see Boris's feedback about changelogs in [1]. To address that,
>> please rework the changelogs to not have so much copy&pasted context 
>> in patches. 
> 
> I understand that Boris doesn't want to see large amounts of text copied
> from the cover letter into each patch. But there is still a need to meet the
> "Describe your problem" requirement for a good commit message.
> 
> Several of the prepatory patches in this series make changes to expand the
> capabilities of fs/resctrl to handle monitor events from resources other
> than RDT_RESOURCE_L3.
> 
> Is a single short sentence repeated in several patches "too much"?

You are correct that "repetitive" is subjective and "too much" is not
deterministic. Yet, we received a clear message that repetitive boilerplate is
really annoying. To me, five of the first seven patches starting with the same sentence
is close if not firmly in the repetitive boilerplate category. I've already highlighted
that that sentence can just be dropped from patch #3 and looking ahead, also from
patch #7, without losing context. Those are simple changes and I believe the
changelogs can be further reworked to improve the context to be unique per patch.

On a high level: we received valuable information about expectations from
changelogs. While I agree this is subjective, I am not interested in probes to
determine what the tolerance for repetition is but instead I intend to just take
the feedback to heart and work towards avoiding repetition.

>>> To prepare for additional types of monitoring domains, move open coded L3
>>> resource monitoring domain initialization from domain_add_cpu_mon() into
>>> a new helper l3_mon_domain_setup() called by domain_add_cpu_mon().
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---

...
.
>>
>>> +		return;
>>> +	}
>>> +
>>> +	switch (r->rid) {
>>> +	case RDT_RESOURCE_L3:
>>
>> Something like:
>> 		if (hdr) {
>> 			/* do resource specific CPU initialization here */
>> 			return;
>> 		}
> 
> In this specific case the resource specific operation needs to happen
> on every CPU (it updates the per-CPU MSR_IA32_L3_QOS_EXT_CFG). So I
> think the code fragment needs to be:
> 
> 	switch (r->rid) {
> 	case RDT_RESOURCE_L3:
> 		/* Update the mbm_assign_mode state for the CPU if supported */
> 		if (r->mon.mbm_cntr_assignable)
> 			resctrl_arch_mbm_cntr_assign_set_one(r);
> 		if (!hdr)
> 			l3_mon_domain_setup(cpu, id, r, add_pos);
> 		break;
> 

ok. I think this will work for this specific initialization. I do not think this is
appropriate as a general pattern since the per-CPU initialization may be called with
and without a domain structure. 

>>
>>> +		l3_mon_domain_setup(cpu, id, r, add_pos);
>>> +		break;
>>> +	default:
>>> +		pr_warn_once("Unknown resource rid=%d\n", r->rid);
>>> +		break;
>>> +	}
>>> +}
>>> +

Reinette
