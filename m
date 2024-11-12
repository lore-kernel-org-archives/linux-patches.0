Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BE821832A
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731439522; cv=fail; b=fqGFxwIFsZSNcArqaXxHcn01cAQwBDr1Aio1eArm+AfRkjPSu+11k2h0KhLWW7Ln0gRhzvYl98ZJd3/UlQRmbwcqkRzG91Gr2KNoAMahGEFyq9Rjl3j50xpXMkjxDo5a0e3Eyk6DgWrxHGEep4Bo4pZKFEfcxOhzFWgLyt+JP5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731439522; c=relaxed/simple;
	bh=Pawz0WcPPinrYBtn+pTtGx1kwSBunOwNqYOLuOBQmoc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WoFyZ+d+PTZpL/t6WkQ/MjXbhuQPIHeqyi5j59geXOfc3PyZZVQmLGZ7rvtlJx58PUjYM/Oo0ioPSTMQ466h/R/7e+zEGhXRaqaxjaxqxHj8aE5mzi+sX8dvUgnpcUMiBGo72f0aDdYLKuSvgHXcNhZ9gOJnVuiJg2r1zF7OxAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Poan5+In; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Poan5+In"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731439521; x=1762975521;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pawz0WcPPinrYBtn+pTtGx1kwSBunOwNqYOLuOBQmoc=;
  b=Poan5+In3xcZXO1EIb5+2lDYQgQ4Xd7OoDqMPu9B5Ry4b0y0bJKX9bq/
   wmroK3nBjRg/3gVxJDUVtcqGIllZUj0mjsrE0STww+09zig9EFni/JxAB
   75CULsmVJdqC6YA2P0MO79H9bDPoF6kUdmWXcOM0y8UA41vJm4FE3Hwef
   UvYzdynUdWtT0dsbT1zp76iURVlXzO02kBdsi8CXYFTa8ePgGQSXXzPpX
   8gSpRGymkMa4RJZ69Aig1PbrMYjvm/jLHBhXkpmMBhIvHznGHA3oVsy5/
   1LRnK4Lkmre/PinXm62EmJTa0F0oh2DjFKKScGiLheF1Pr8mz10BlwuYv
   A==;
X-CSE-ConnectionGUID: KocjDu9wS8S1oOB3X2N3IA==
X-CSE-MsgGUID: ozr0dEImQMSdkMaFFCthZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="30700259"
X-IronPort-AV: E=Sophos;i="6.12,148,1728975600"; 
   d="scan'208";a="30700259"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 11:25:20 -0800
X-CSE-ConnectionGUID: m8Uz6I4DQFypvgS5oizHTg==
X-CSE-MsgGUID: sFs/L2EBS6qSk32AOZnrjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88443109"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 11:25:21 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 11:25:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 11:25:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 11:25:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wwi513P9iKGGgzZGA2xJWYN9IXS7qvy+6h/l5iFA1OtFZs+iEyHe9Nypmbj98//KfI17Y4iyHvNk/ULKEeWWuUUysi0w2Sbk2ksW3GAu98oSBEU/oP9aM8Jr4mmEh8L7FgWnXdZuNvQri/yN3Z9/T9Grlk0iFu+z98YMoIFzKtI9dzJsYT84A5xj4pCyoHD3FE0AtTyPLYv/OIAMO6JUMYwRgyuCtUcHRSh/ZXFz7LgCk1K8a8EmrZlRRqsCU2FmKknKYYK3iqKTm73ApLqF6HK0KngfiEK47AqEtOj1fSeJBaNbhUCLntAWtTJnJDbqrSj63Onz0qSKsrMqr2Tq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+jPa5/eXUSTlHgi9UxOxjHowCEF9JlW2Bj/LA68rsk=;
 b=lNrONpaNdesZ64rA/34HF4l5CAea00qpaAFgz7QWttHZXEPZ7bdDYClIWOmW26Pd+tl7lUMa7g312betYMNdTlDCt1E8jjf8CqFFbZCB73Nqi5WXGIH59+8ulBQfZDgSJ7V/sE3X2lXGTBYCZY/CM1qaOk9V0tUmHZB5LkDOFBPNeZEwqbv1aZYGWSW1wC+IwY1Zx7VtNJPyzqIyTpCZdxjopOlsftROY9vMI/R3SXtN09bnNqAB5K8AfKkdb7u09XuaRSvIn0qENdlcd/38NbF9kTq7BuU1QSYP6SKxD2YbtMHYY/O5wfrfpSn5rDym0caE3CrJCZ49MODr60+v+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 19:25:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 19:25:17 +0000
Message-ID: <cd58086a-c242-4105-a112-264533f2596c@intel.com>
Date: Tue, 12 Nov 2024 11:25:15 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/7] x86/resctrl: Compute memory bandwidth for all
 supported events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241029172832.93963-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: a93660bf-bd77-40a1-555a-08dd034fbd9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MGFNdm5rWEN4VEFvbzBTT3lNUEtLWGFVNEJJZ0kxa3lQMnVkZEQrRGhpbkNs?=
 =?utf-8?B?OTRkckEwK1lsWXlTVGxYdklkaDNJcThrNmI2blBSMVIvQjJ4M1BIOVRRZEp5?=
 =?utf-8?B?eDNzWVVrRjZNQkRwVmhhUkpJU0tYSHp4WlIyZllaM0VBeVpIcTFpc1c0d3pq?=
 =?utf-8?B?RlVkaFBYa2IvSGMwNzU5b2FQU00xRmF6ci9FSHV5MXdoZ2E1eVBCcXd0eTQy?=
 =?utf-8?B?K1JQd0szK3czNm9yZ3JMcDZwbE1XcTNsMzRUMSszN3R2cjkzMUNjMVhjVms5?=
 =?utf-8?B?ZFY5bm5IOWlyVjNlLzV4M2d1c3I2M2ZZT2VHOWNHcGFGWGdiU3lwVklDVDJT?=
 =?utf-8?B?VmhQd3FqMWdFNEJLSGN3M01NRHRqditzYU1sb2ZVb3J0VTBGYVVIU2VhNGFX?=
 =?utf-8?B?M1kwTHo1clNXV3NVN3JQb0czU3I4emtCT2dLTEprdGhQNGs3YU42NGpoRjZI?=
 =?utf-8?B?d2NLcmhFSDM0RE1HV0pHZjFUZUFRZXpab0d2Y0NHT2xQY2loNTlKTWZLR3dI?=
 =?utf-8?B?cmVPRTY0VklKRWFsZ0VWMFJMWlNDcHZkK0t4WnRkT3VUcWVTMTZuY1ZjVmV0?=
 =?utf-8?B?czQrOWlZVWpGeGF6NFYrWnJwc1BWS1lxTzBzdFgzbGo4M1RtKzd5VmN1a1E0?=
 =?utf-8?B?NkdkbGhuVzNrVFhqUHRaZDdUQUl1RkxzQU9jZ0JHUktUNlBoR1M3UXlxWFI0?=
 =?utf-8?B?ZnRnSTlxMnJxWmI2NGF5VU5UL216bGs5REtXWWd0Y1J5ZDlibWhJWmlpeW1s?=
 =?utf-8?B?azNRKzhqYmFDSk8wWlVBN0xqbFhzT2hwNTZpVVExY2hqMTMxQitMOC9oNnJh?=
 =?utf-8?B?c3JETVNubG1jTmtiU0FxNkg2TFRuL3BqWGRJTGxZYWFXZGFPcHIxVU94UmZF?=
 =?utf-8?B?R2NrNkp5VSt1VkVsUWk2OXVmTW1kOW5iWlFmMk8wbGQ5UzBaeVczRVprR1Rq?=
 =?utf-8?B?S1pNRXBwQWZLb2hJRmpheVpWaWszQjFzaEkxd3VXL3VDWnlXMy9qNkJHSTNw?=
 =?utf-8?B?Y3VKQTJSSDZJUzY3c0g4QzVUWEZ2YXZRREdNQW9jalJhSlNPM0tXcmhPeXlM?=
 =?utf-8?B?MTF0aE9ZL0VGMUNtRDYvY3FOM3Q4SEJPdVJERGVoTjNOblZRc3k4TC9USENK?=
 =?utf-8?B?VzJPdjZ2RXZOa0RIMElTbUVaYXpJYnRlMTNkZnNGN3dMdmR6ajNMb3pKREhp?=
 =?utf-8?B?d3BPWk5OVDZFbWYrWUJkNTZOeENyNVQ2MExQdCtUcnBmZ3FVVUF2ZW41SUNL?=
 =?utf-8?B?NTJOak4rdFNMUDcwQitWd3NRODA5NjZYSTRlZU11a09yektNRTZsalhpekFx?=
 =?utf-8?B?WXJuczArSnRGNmNRTnM1b0pkSkRBVXJoVkJJcE1IRnVYejF0ZW5qWHB6MFVS?=
 =?utf-8?B?ZjM1Y1U3SGRrNmRXbGUyT1NBREtzb3RvNS9TMkpCakFURXNKYkpaUzUwZjZa?=
 =?utf-8?B?alJES05KUG84UkxmMEpCSDZTTlpCRVM3dWIyQ3E0dzhYWXR6aWtmcmJpWXNX?=
 =?utf-8?B?MHVxa0FXZDVhNDFSOXIvQjVoc2o0TXlGcmNQaGFHamh0Q1dnUlVYZUpYOSti?=
 =?utf-8?B?aTRqZklBM2pUTGh4VjV1SDVuV3Y4dkVTVXlSdzFlRHRYTDJjRzhwcDFrNXZa?=
 =?utf-8?B?ekRnRXRtcGtBR280TWR2UzVZQjJKeWxUS1VWdGRSZ3ZPM0Q3L2wxdFBNZFp4?=
 =?utf-8?B?eHFiQkNlNHo3Um8rWVFDZllWVjNhYXdubmxSNkU3SlRhNHJucGZqWURiU3Bw?=
 =?utf-8?Q?nKcmQSInXCECeeINg1oa5b2gUBqu3Bi0g4vOFkt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXZYQ0hFelJsc09VTXJSaWVGZUQxYVJVYlZyVHozbU4vM1FhN2hIbHB6OTly?=
 =?utf-8?B?TjRSU3NEYnNXb3Z1ekhyTzErMHo5R0JKR0pmbVQxbHk2cnY4czNOQndJbkIv?=
 =?utf-8?B?bVFpaGdYUkd6SkV0c2Q5dHNUUm05cnJRRkhENXkrc0tKL2xtTU41T2RNSmo3?=
 =?utf-8?B?ei9UKzFLd0dXNklhWEdRRnBkL0tETkZNeHA3L2l5ZjNhUlkvNTkyZXFWalQ3?=
 =?utf-8?B?TGVwRUZpdlVISWJuRldXZ0IySGxOWSs3V3hOdlhvbDNCTGZYeHQ3ZmtiYnZQ?=
 =?utf-8?B?bEVQMWFZTkR0MUZyZTFKOHRhVTQ1akhjMmo5QXF6UFRySTk4TEVpQ1A3Q2tX?=
 =?utf-8?B?cTU4TFd0ZW5LemxqMlMrVHlSUU1iOU1GL2tjMXBRWkt4WEV3TC84OHBUUUJh?=
 =?utf-8?B?cGUrYkhWVVA3OHpXZDQxSjZZOFdVSzhheGI5MGsrcUwxVzgzUXpuS1RzbW5J?=
 =?utf-8?B?YndMQXJiTFJkRUtWRk9EMXdac0FPM1NmSEtLaU5qem9GSFNJSE8yNm5ZYnZQ?=
 =?utf-8?B?dnptTk52cjBDNi96dGh2KzArSGVlMzBONXN2a3U2WEQ0VkNFS21GaWJ4TE5D?=
 =?utf-8?B?ZktVczZCaFVhV3BYVndCMWhHRGN3R1FiWjlaWnpadnVFdUcvK0hiUTdSeWQr?=
 =?utf-8?B?M0xQd25oUUd3YjB2NDFSa1pnckNrVEJXRGRCVmU2NjNjNDVOUU9UYWgxUVM5?=
 =?utf-8?B?cXJjSC9xS2NPL3hKYzNUU3RhYlpoaEN3V01nK0dnMTZRSDdMeWZVbFZKREpr?=
 =?utf-8?B?WG5FOWd3Qm8vdTVhRkdSU2U4TEJRdmZKT2o1b1gzMExDdWhJNG9KcGxpVk41?=
 =?utf-8?B?dmEvbmR4azdsaXVQaVN2cTNkYnAwWEZPSXlQazc0bmp2Z0lVbXhVYWxvWlJu?=
 =?utf-8?B?bzdIdlJVdkk4ZkdPS1lDNG9JdVhRR3ptN0RvSmFrcTRIcHlDaWFua05CWVVo?=
 =?utf-8?B?QXNHcHNXS1QxSGgvUk1pek1ib0prdDNaS2FTZS9KUVEzcjY5UVJ1L0RJWDVw?=
 =?utf-8?B?LyszWkNNSGZHbGlTampxU29YQUxlamhQeFo0bHdHL25nbG5iaFdtM0RxMlEz?=
 =?utf-8?B?WjR1RDczaTF0K1pLd1M2MXM5OHpRSlZXcTVNMXpKNGV0Q3FTcUlHemIwQ1JW?=
 =?utf-8?B?Sk9hRXNGL0xZRVl1RUNrQ20vSFgxR0tncDFzUG1jYnAvSzVQWVZBeG1tYjV3?=
 =?utf-8?B?VnMzVWJzcGt3Vkc3blM3OElsWlYzY0hKMUxtYXRnVnc4VHo4clpIazB6ZzdL?=
 =?utf-8?B?blJONmtsZmNpTGdmQ3J1NU02MlpPcmJuVjZlUnNTdnVkL2tFOFc1SitueEpT?=
 =?utf-8?B?bCtidHppN2Q1MUtXYVU5T0hqaFJwSUhCMmpoSDROUzBrTW14Y1BiS1ZWRU50?=
 =?utf-8?B?NW4xKzlyY216SWNPeE5pa2NFNVMrWlRqRktOVlp4b0ZaUTg0TzdvbmRVWC9E?=
 =?utf-8?B?OEVUUTU1b3ZReVZQdllBWjhoQ2d0elBFcTE0c0tBZzU0UDJoa1RFQ2h0M1pS?=
 =?utf-8?B?UXFhZWhnTW9zZy95U3c1a1ZpMWI1b1RBK3pCRDh3OEhFakFHU1NwOHZDcUM4?=
 =?utf-8?B?RWRsempCczAzdVhYZWpKN1p2Rk1QbFp6Q1MrQkg1RXlLYnl2bjdVdDJueFRz?=
 =?utf-8?B?eXEvMlBTd0diTEhQVU10dUlVSzBpTVFjVVRRMnJzenBDSy90S3RlN2hyRXhj?=
 =?utf-8?B?L3dISldqS21tYlptN0NsaFBEbGVQaWNya2xEZ3NxdDBjbFRTS2hQSFNFNGVi?=
 =?utf-8?B?RXV1YzZtREZQZzVrSEZPcFFDOVVhWG54SW94d1h4MzhhN1A5Y1NuRmJGMzFH?=
 =?utf-8?B?dkRpTUNlTGJOU0JRTyttL05ycFNqQmZyNC9Pdjc2RGJMV0NUK2trZVVtZ1Bv?=
 =?utf-8?B?Y3NBdkpBT21HNXZjRjUvQWZ4MVB4b2tzTEFoSCtBamE1UFA4Zyt1c1ducURH?=
 =?utf-8?B?Tmg2TzhuRWRIc0pEazBOY3Z6U1lOWnBWcWlvczJvcktyTDluMHpxZ3NiTDl1?=
 =?utf-8?B?N1piKzd4ckFIajR1WTVsNWRrRSt0SlVmM2xVNWhpQ21ITFZaQkdva0xSbTN1?=
 =?utf-8?B?ay9ZdkcxWGlseUxzRDE4OUhjaVlDUjZOWEdMejFZY3FSY29mUUpPRXRvUVpT?=
 =?utf-8?B?ZjZLcVp0VVVPUlkyNTl4cUlHWGtRUFZEZEtjSlpsUWpqMlN5WmMxTENTeVpM?=
 =?utf-8?B?VkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a93660bf-bd77-40a1-555a-08dd034fbd9b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 19:25:17.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKPhqu16mHlIDz+ysm42GKSwXQYFyHY7fgArPIs9hB0QPiGurI6qJku9cuFDM6T8oVAfcfhPplPmcY9hJN1cXgMr+YdxKNzCEwPzLEd3I1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> Computing the bandwidth for an event is cheap, and only done once
> per second. Doing so simplifies switching between events and allows
> choosing different events per ctrl_mon group.
> 

If I understand correctly this changelog only describes the first and the
last hunks of this patch. Further, it is the last hunk that introduces the
duplicate code that prompts the refactoring in next patch "x86/resctrl:
Refactor mbm_update()". Inserting the duplicate code and then refactoring it
out does not seem necessary. What if the second hunk of this patch is extracted
into its own patch and the refactoring squashed with what remains?
In the cover letter your motivation for the separate refactor was "to make it
easier to review", but I wonder if separating the unrelated code in second
hunk would make this separate refactor unnecessary while remaining easy to
review?

Reinette
