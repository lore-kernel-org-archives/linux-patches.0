Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841CD27A467
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719856; cv=fail; b=mpeTON+NUKg5lNk+Gjt0AnWr0//F4l4nhLB+H/JUyI35U968QifqyPEWf3qyCZpFvBDeTpwIOhfuXyaicDaUejaKADZcRwUFvW0aCv2/r/mKcwUXoBNIS88AIBes47FPcvdL8zldsRULZenTbPNj/4edajqIusIe2MNt/h4YIGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719856; c=relaxed/simple;
	bh=o+vb7ox1qAfaTn19dzoIPjIu3BRubtsY6gzYeFReKnE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qpx4prmLayo/pCctkwKW8r9TQ/UQvVjrYRYJdhD56qpIFtuLf/2bmL0NSfkhgElrCUAdfBkUYvjM/DEQFya0vtkhrv07Qx9fvq/PF5vsBb4wpkkuzu8Ho/tGtCBpYV/jatDm1xAzPBWjDzLUw+MsDmABjB3gKbj9lyd6AT+kmgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWJlxCEm; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWJlxCEm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719854; x=1778255854;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o+vb7ox1qAfaTn19dzoIPjIu3BRubtsY6gzYeFReKnE=;
  b=QWJlxCEmRF9qDJZUIC3gFyCMQcvS93nQfC/GBdcHv0+3qdDkrvMOZGaK
   VsGaKCS7uwiQz+8buwbhpUyTaV+QJhNZ4gtPM+MFAgaL4fneGUE1CbZOO
   Yrk7tvrWhYNdTl2iSwNX94TeUjeXONcchug7K5k0bkw7unonXlp+jmVu2
   oQuGqCpLa7/o4eb47Loj8l04KRlGfh+eeoY8zqAq7ztN6Mc9wggifwKES
   BkGqqX2TukdbHJLqX6UKQ/WvvBS3TUPacDLNEOon4h/jNz46OM+mf03sH
   eLhqQTFFc7qmZAXD4+HP7YRwhbejouXnEuiRxMNC+s4rstBAHhnt/ws8W
   w==;
X-CSE-ConnectionGUID: qNhvjvQRQXe+KCQv9MCkpQ==
X-CSE-MsgGUID: WPNR4JP6RTGqLhoGkfZDaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48224240"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48224240"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:57:34 -0700
X-CSE-ConnectionGUID: K22/wXBhTjS1864QfiUjSw==
X-CSE-MsgGUID: ciUihsuMT4i9XlkRcMHCUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="136296729"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:57:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:57:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:57:33 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:57:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jU5b3/nsSyf1Sd82XD0B8IZkwMAzZQESBL401hOIYl335Qxl8BxXRUy93KtOAzEgxqDrnEhR2uhhMzgg93X6FWKqorN7AbMU1kfh8lgG1PMpgpGrcdAFV9v3Ap2yBTbsgKKjHoxAzXZjefLXyjRTbtk9nA+HDJoHeGf5NBb/0gd2aaE3Mqcd6To0QqrGXHQgudDBFX5rB9OhFiELQXoqkWcggG4UgQur1RRP0zh5bYryzE78qRqVTX/h6/KtM8hR9LvZDQ37V81mhiZ9+eWCvHDUBT8NAoT3p8H4wU+Nrsk97BiQGbYOWGxXCZiaG8sJBgZMocgM7T7mIHoUnYAYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWKHMDAlrDMIyGFO2l+YF45lwMUvmChroHuda7HwVnI=;
 b=nKHBo5zcc7EX8urTEl8frrHITEfR8aZyAZB1b3VvljXoRREjyb6BiFpcKwJudxamHNRKMw1RB9i21NirW/bc+u2h2Vyrv9eNY8K2vPbw/skG37WlyQPVngATdJZNO3DzQ5AvvyXHQsI0mb8E2wplUvDr9iR5BFauiynjIWYmpEBzMGIEBrWmRM7eVXHP6u4/2oY7Pk82weuQ3ln7W7HjVo9cYIVNYCVQ2SfrUvSxGBaqYqZhoXD0dE0fetmL/XijL+z/jCPgoQTWoA7FG9H6CTVGla3nmOjzdvRz9VXCAEOO0vlH3NZJdABjYX3mK36agZLnL8XmkeOIGS8nkUKZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF0D43D62C4.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:56:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:56:56 +0000
Message-ID: <54291845-a964-4d6a-948c-6d6b14a705dd@intel.com>
Date: Thu, 8 May 2025 08:56:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/31] x86/resctrl: Add fourth part of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF0D43D62C4:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b547651-d66a-440b-cc2e-08dd8e48f537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?alB6bFZYbGdWYjJUMGRnQ0tRUTJXdUxWMzMrNUZmQXB1RlVoOGEyZnYzSFFI?=
 =?utf-8?B?TW5BelViZG9CNFZLOGtndytzWGlaY0ZvNzVRLytCQVdPR3Vmb2YrdUdoSGw4?=
 =?utf-8?B?Mmp5MjRKeHVyMHAvZSs0MXAvaE5RbFFXMXdSWmcrMGxxRzRhTEJadWs1NHhW?=
 =?utf-8?B?aUg0SW82Q0xFemQ4d29iQ1REQU9XakhmMGd3WHFZVWw1eVJvekllNktraTdZ?=
 =?utf-8?B?S3RCNitTVVJVdWp3Z2QvTmhuaGlDaDBaenVzdTJnaHNMQ1NXWlhVeWhmODhw?=
 =?utf-8?B?MURydDRPR1NXQXZVWTFkQlR5ZzRoemEyV0MwRDJVd0tyU3NDMFFuQ0JzQ0t5?=
 =?utf-8?B?K1N4Vm8wZkF3aFh5K3RFK1gwT0t2VVM3ay9hRzRFdFBTZTJwem80a2h5TnhP?=
 =?utf-8?B?Z1hCc2dtRm9mRU5Helh5cyswVmplTTdOTmthME1qejh3MHdLSjgrQWsxUWdn?=
 =?utf-8?B?YzVQZnBzRGVxMExoRkdrbW1iUWdHdkgzWVNJWGpNTmJETkUzc0N1YlFxVjhl?=
 =?utf-8?B?Q1lTNWdBSUk3TWVQTTh5d0pYYmpXVFJZa2JWYnMrYW93R0lWSTJkdGFFWHUz?=
 =?utf-8?B?Uk0wNW9VdVp5UTBEV1RNdVFzREQxZzBWUTE5M3BQbTZZT0IyWUZPeTVwbXNJ?=
 =?utf-8?B?N3drc055Q004aWozT3JVSUxlZWNtMCtvdzMzaTlrVWRkRFRPUmFBZjRnZnMv?=
 =?utf-8?B?aEFmV2hlSVpJWXoySmUvK21ydlRNcFFycHdWbFZMR084SzZBbUI5VU1RK3l2?=
 =?utf-8?B?TmUzTXNiYmNSU2VQSGJVVzlIOEJkWWhHWEVKejM4bjYrMU9PdXVGREVHWjhz?=
 =?utf-8?B?dmdhUWlxK1RYd05UWEdZZUx3dkMvR2lXNVJKcS80OFpzeXZZWGx5Q01CN2Z1?=
 =?utf-8?B?ME5NdUh6MlFzeVlVSWNhYUZaamJjSHRiT3JidU12eUdzL1VJT084VU9TMDE0?=
 =?utf-8?B?VU0vbWluZXJ2ZWw3ZVJKWXQwdFkrVS9EdzRyLytuNGlXZXk4U25LUnBIUFYy?=
 =?utf-8?B?U0xvNXQxQTYzWXcwYU5xejQzdUk4YWJ3NzcyQ3ZJdENWUXAxTmdWN3U2YXhi?=
 =?utf-8?B?RnRNdjhSNVJxSDR6Z3dTU0pEazlLZklVdSthYkhKdmpQYTVFTHdBS09MY1cw?=
 =?utf-8?B?SGt1OTNLNFZEYTBSZ3RlcEFhMlllMlFsWG1WN2J6cVBuNmdTOHNyclBqVDcr?=
 =?utf-8?B?UHZ6RHNVY05MbHBlcGt5SWpLYi9XL2JPeTlpNTZIZDNWbm5SUytsSzlhNTI3?=
 =?utf-8?B?a2RqMXZ3L256ek12SjRBb25hS0E3YnYvL3ZHdGZDMCtwbGZBN3Nra0RBM1l3?=
 =?utf-8?B?dXBjL0JGZGszNnpIaXp6MHRIc1QrdytoQlNrQXoxRWU5ZUJrZnZDMExVcGhD?=
 =?utf-8?B?Z3dOVk5GNzlJN3k5L0MvQ0w2YXhzb1ZMRzk3WkVxTlMrZGd1NUR3VVp6aytm?=
 =?utf-8?B?L25ZaXZWREdiSzlPYUFhakpVREZodjBJRkhjcnlRTjlNN2xmOU01Y2xuTkd2?=
 =?utf-8?B?ZlJNd0NRTGI0ajhsSmRUOFVHdWtVRFJ1MHphMDB6LzFGb0daU2tBMUMxaTVj?=
 =?utf-8?B?MEJpdkg3aSsxZnpiTUlHTEJHS1VHdFk1bEtaN1NOYzJPa2U1eTBydWFXZnNX?=
 =?utf-8?B?TlA3bWNQTHVyb3ZwQWJwZkNlNjBTc1ZJa0UvbEY0VE1rNHJKYnpWaUU3cDc0?=
 =?utf-8?B?WDhyYktya0g1MlBFQWFRdnNYSmsyemZoK1RlSmNmakQrRVhYYVVqKzQvWGxm?=
 =?utf-8?B?NGlXckdkejRXVEVYZ0RCajdLckZRM0NGaGEwc2ZTdTVrRmNqb0tEWWYvNmlZ?=
 =?utf-8?B?WHZRRitERDl1Y05DTHBmbnMyU1BjaFByRk1RdDArbXkyUWJTbjdxMTB2V2Q0?=
 =?utf-8?B?UWFaaDhRNVZXVFo3MnJtbWlsUTZ4c3JML2tzQlRMWURNczVZUDRLdmNIM3Vv?=
 =?utf-8?B?OFJYaEFQbE5ScXVOb1VMdWFWVnEwamhTd2tNdFRhQlExcnNZaU00eDlPN2tV?=
 =?utf-8?B?SWRuZGdYUEVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUExZ0xZMUVKQXhGUFViYzdya1R4QkZtRHR4RzVRbUhVc0MwVm9IYVlDcEoy?=
 =?utf-8?B?N3VGdmRDUEpKRysvdnVmVUhBVkFoSzJVZThZcHEwME1VUDZsc2VEc2IySllh?=
 =?utf-8?B?dGowYTRacFlReEFtKzRLN0FnU0FOZUEyNDhsSG5xNGlvVzBXSG5hRDk3MFR6?=
 =?utf-8?B?ZG1raFFZOUZxQWc0c2pCVWM2czFVM2Y5YnlTblk3dW16RWtzUnZYTHdDaVhr?=
 =?utf-8?B?UUtnSytCdTYybjNEMmxJSENZVnZjWDhMNkoybjZmV2J4VVQ2L25KWkdBZkl2?=
 =?utf-8?B?YkZJOElpUTdMYUZCcjlOaFcra0doNUg1LzJ4MUsrbnVyMloyZGR4NHduRFVz?=
 =?utf-8?B?aHppM0lCU2U3QTNESHFhdHJnSlVyQ3AxY1hlMkhhSG9DbnNRclcrNHlZYnlL?=
 =?utf-8?B?c3BqSWVVMVo4WnRzVzZDUTFBdy9lcG9udEpPanBNUmlIMjJRRkVXWkM5L0FD?=
 =?utf-8?B?M2pQYjdMN1ZyMktNWitFMW5UcHlrTE9MbXM5dFhkWlZhTW5YaVRqTFFLUFRs?=
 =?utf-8?B?eWo4T2JKT09xQnRDZFNSYmtqWDNmUlVsdE1jTHUvbGYrN2xrR2dPdkk4cUZn?=
 =?utf-8?B?VGZWcXRjOWp3L1NVbm9CNVRHbllrTHBWZEJRN2Juc0ZDZ2JtRHc2M21Qc1lP?=
 =?utf-8?B?QnloMjdJaEUvZHBIcTlCeHZGVHVodExxdjkrUGhLWmFGaDNMY1U0THQ1dEZ1?=
 =?utf-8?B?MFhuRW9STUYzNmhOQ0RMd1praVBFZEU1Zjhtb2V3aFNJeCtML3NpOGpyd1Yx?=
 =?utf-8?B?N0NqcjdVbVZNbVNoMDVVR1VicHpWTVlhSEgrcFlsdVVodndKaWJORG45cTJk?=
 =?utf-8?B?RlVvSnlWMzhzYXFsbEJXZ3ZEZ3NSdDFpVklFVjV5TkdqZ1VRZk55REJtRW1v?=
 =?utf-8?B?NGpIVHE0dVl6djlGV3ByRHpWTHJ2YTczQTdwR2xvQkpmZFZiR3dVZEFuRVdM?=
 =?utf-8?B?ZzcyMWNmamlUTGVRWTdXVnZYdHYrQjk1SjFPWE5iTGtmZVVKaTJacXZZSEpD?=
 =?utf-8?B?ZnQ4c2NwVXdEd09QNUlwUkI2YThQNXJ2YlNZa1g5OFFqbzRvMlRIMFlHRHNZ?=
 =?utf-8?B?VlpuSVpnOWhzSXoxK3UxTzFvRzRFa0RndUdITzYva2ExblFRbHB1YVUvR3Fk?=
 =?utf-8?B?ZnZ3MjdxRnU1dUh5TWhWOHRjQjdCSUVGTjR4NjEzbms1TGsya2xNUlZkM3Er?=
 =?utf-8?B?T1l2OHhtUXg4d1E3cG5OMzJpYTEyVkRUd3ZaYk9OZExUcHJSeDJ4dnAxbFBr?=
 =?utf-8?B?MVpuazA3T0hJczNldHpwOUJtemp1THJiZnAxL0dXUXpmOEdmcXpOR01UOWdk?=
 =?utf-8?B?RFNBUzdKOTZHMG5mblFIeTBBU0NnTnVvTEt1THdzSnovZU14S0I3enhqZXpT?=
 =?utf-8?B?enV2WnU4VWwrbjJRcG92cUh0cnNReU1ucXA0ckhuMmNGNWZDRllQMnBseVpj?=
 =?utf-8?B?VVVkT0VnYW52UDJ6c2NxUXA3SEJ3S2RFU0RXUFA4OWE3SFN0TmJpOEFXVXow?=
 =?utf-8?B?N2dGbkNHT1pUU3BrbDV1RDAyWW9wY3dTR2RXempYaEM2QVVjWG80MlZGMU9B?=
 =?utf-8?B?WjFROWVsK3lxbzBYWEdWMWxSUG5lc2Y3ajNaRTR6R3Ztc3V0WlFwT2F6MHpV?=
 =?utf-8?B?VkM3OG1SL2g0RmVWMlhlSDFrc0dwblJWQzYvWFdPSnJrSE5FVTlxUnVJOWpv?=
 =?utf-8?B?ekRZNnh1SkZqWmZocUsyRmpPdUlqbCtNQms5Nm1XQzRNTnBPUXpGMExkRTlL?=
 =?utf-8?B?RTB2aW0yWVFteWlHMDBQSWhYR3I2SzZPaE5INGVQV0lhbzhlU1dBVC9Yb0Qw?=
 =?utf-8?B?TWtkNVJqUHljQzRIUmJNT3JocFM4Qlljd3gvcThZUm9HcENtTjRXcU9CTEt0?=
 =?utf-8?B?aCtQV3NOMmZXVlVZem9jbE50Q0dUNmpYT2tFaEQ1Q2hZN1hIZWFLV0VQYURu?=
 =?utf-8?B?NHNVdUxoRnhsR2V1ZnQ2eFZNWUtkK2xIbDVlaVFvRHE4bGZ2UUFoOTR3dEFj?=
 =?utf-8?B?a0VhQTlFTkFNb0M3TFRrYStZYlZmQVloQlMwbThwcG1sTERSRHlUeWF6NTFk?=
 =?utf-8?B?UUNuYjZsdDFQRXU3K21LWi9MNWpQSit3SDVkS1ZucjBxRU8yL3ZOOVpaSjlQ?=
 =?utf-8?B?Z2pXc1RlWGxKajRmSEZRdVY3M0VqT2U5blFNcEZOR28xWlVZU0g2bFp2REVW?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b547651-d66a-440b-cc2e-08dd8e48f537
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:56:56.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MmyNTeMThBFi78CHIwq9NOKq4dfKejLXvu2btJgqBjoFmMgE+PJXq26Sw7pM7ufu5OreoGkh7Zfwx5udoeHwJJuKzjDueEM4JoU3kT9P0ZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0D43D62C4
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> At run time when a user reads an event file the file system code
> provides the enum resctrl_event_id for the event.
> 
> Create a lookup table indexed by event id to provide the telem_entry
> structure and the event index into MMIO space.

https://lore.kernel.org/lkml/7bb97892-16fd-49c5-90f0-223526ebdf4c@intel.com/

> 
> Enable the events marked as readable from any CPU.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 37dd493df250..e1cb6bd4788d 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -97,6 +97,16 @@ static struct event_group *known_event_groups[] = {
>  
>  #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
>  
> +/**
> + * struct evtinfo - lookup table from resctrl_event_id to useful information
> + * @event_group:	Pointer to the telem_entry structure for this event

What is telem_entry structure?

> + * @idx:		Counter index within each per-RMID block of counters
> + */
> +static struct evtinfo {
> +	struct event_group	*event_group;
> +	int			idx;
> +} evtinfo[QOS_NUM_EVENTS];
> +

Reinette
