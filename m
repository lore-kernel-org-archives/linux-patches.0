Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A8724679F
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759535533; cv=fail; b=qqfzH/m0htLlb3CH++4DhLnNWe93991a4FRiDjTaSAgMxR+edDSIqvAr+UuogqXZt6x7QNTfmYysaQrsIQg6G5/1xTR87Ab/ibkR2axMFFXxDzvp6cZfO2hLgKwXZHPTTNVeLQRM4qoJ9gfuUCylSfbE7ld6pVmy2NC0Aysl/6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759535533; c=relaxed/simple;
	bh=14iM/8pzJyZWAdxtBE4CytYK3WZR1h6gnC1ZYCeul1w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hco4yNu0pIWmw1aC7iQpat+IbEXvfR0C4+TKDTg13yl/53zf1+V0hJsbc47jwubIzhw3lBCwrY3TtoM1LFgmztPEGvsm0baw/aFGKJeLD6Ndh69hqN95izCq2x2djhZUE7tGC6diQSY9v4tgAD88uYWno0pqbR+6uLYG8HvAaOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cjXlDCVB; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjXlDCVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759535532; x=1791071532;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=14iM/8pzJyZWAdxtBE4CytYK3WZR1h6gnC1ZYCeul1w=;
  b=cjXlDCVBkfhHugQAZHaAUROmpM7bEs5YjnNexbXKgET3Hh8rF3XgAuzl
   MdmlU6jR+L+5OGdCMowLJjynaXyJGuAde/Nd9S0AA+DMopESDTUl4wBVT
   /TL/460XpdnmswxqtFxXjXGcqpVh1V30mdZxg1xWEO3sHj34BopkWNe87
   i34uTlRPJePRlSsUgt/zDMDSffI3+vYVC+5GTKfr5a6lJAuOwHp/HWZy/
   27b2e2xRXgeqU9bY0ZR7Uo5YKLyMYlCmfMO/a/iQNeDXha5Si6ooU2C1j
   0oT9+dR7ZChIRMKrVm9R+uCYf9UCTqpfN6w+wGCZtqfs34zHElai45yu8
   A==;
X-CSE-ConnectionGUID: WVPjcYbBTDqkKqiXD3qA5g==
X-CSE-MsgGUID: 7BAO/M2vQPm6aMDiQ4V+OQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61780576"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61780576"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:52:11 -0700
X-CSE-ConnectionGUID: nlEPqREdTcSEx+CNtZPoOQ==
X-CSE-MsgGUID: iZzRJPt0Qd2/NmzuTPGplA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="180205108"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:52:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:52:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:52:09 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:52:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fNnbe4+1tzCmoTHhHNCWAtpcsn1fTS7Pi59D/6t1lH2TAHPI1Y3pSRAD+eHc+yg5dF6E1RMni0VKLmUvdb5f93CCuKcq21js5W1EQD9uzj2tE6e9JsvmjHXq6UwvyTEy0hE/99IVyA0ffnlttfwmgOLN0Gwu1lhZqNYOMSKSfG21TRw4g8miPlh/2h36S5X6nhirMXd32p/H+WriC2nzgz9Evd//fLCSNyr4nXkbKeG+aV+fsVGY2yYUoRILk5z7OrEp+PXWAYzBY+6n+MntBvc/kVoHh/kUGN0o38ZZhX+p0EcZ1Lf+icJBOeP03pPqT5rJDhe/xUKF8XI5rCnm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dslhqXZoj9XPrg7J2ULpZSSatsgx2Mw0SfskxoWVD+g=;
 b=mo8eEM1bGNLM8qxg3rXcXfhv5TD68uMXtpVJGCPynnSqTEWbSMx/Jo2hUfZsed6sXybGHVUbA7DeQReAqAPNPRXxF4b/DRpthTL0ZqKA9B38mSL1DNwjrhImoE3vr6nm75ePzELVdA4ArgLEP/afVWd4tOy7sXMB4nO/9HCyktRGP5Gl+8VZk+aXqB8UIaHKbMf6g6TtBLEzjryX9hmuQEShXC2rjIHI5O19STjIPVBUbl4cSor899gSuRTTRkD1pcK9b0Vy44dsvQTeT2pXqDrKKx5Lq9AUMekBDFSgUKbgE7jt+KRS+pyaJHi+Czp7eCEny2hG7hbwFLFdKtRhgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 23:52:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:52:03 +0000
Message-ID: <aecb9aaa-5b94-4787-a976-a633831596bf@intel.com>
Date: Fri, 3 Oct 2025 16:52:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:303:dc::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: da3d3117-a457-4433-4be2-08de02d7da05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UDcyMW9ad2NqRE1ST3NhVE5lajZ3SFR4UW9ndWV2RjF6RHdqK0tTM1JZTWZy?=
 =?utf-8?B?M2xSaVZKcWt0SXZoanFDemJTTmprQzhFTFpXM2RCUVBWYzQyQWo4VkdDRUNz?=
 =?utf-8?B?VmFreGJRcWpZUU9iY1pqcSt2bUx6UVpkYy8vRmgvMHJ0Z2tTY05xT3VCSCt6?=
 =?utf-8?B?YzA1bFdWa3Rwa0FHYVNaUnV3cW00cDBqUEhGOVUrL0NpUW9xY2VTNVhrNWFC?=
 =?utf-8?B?WE10dEU5Y05SNE5VSTJBUmxlUHFMbGpWamI2M2Y1dm9IWU9oRXZIV0lsRTJO?=
 =?utf-8?B?Mmdva0pPdE1tS2QzWUNVcVlPK1p4RTEyaHpaalVrUUFOR3lhdDRuYmxOVWs2?=
 =?utf-8?B?dm5PSldTME1VeVJDUW9Za2VpcTlUQ253QnBhSFlIT01uUDdieVFYbXpUMXdV?=
 =?utf-8?B?dnZqVk4vcnB5eGpzcVd2dGZ5c0pVWmVXOFdFSkxlZFRrTU1WeFozamRCbllt?=
 =?utf-8?B?WTcydFBrRDRDWEhNSWRQb1VUQXJrNU4xSmcxM1R1cHVQMkFQMkg3VTJBS09Q?=
 =?utf-8?B?SXdTM0N1L0FEZE4vM1lLYWo0ZVNmR3JxdHBEQjlacVNiK2t1bnZlWlpNOHBP?=
 =?utf-8?B?Z21IMFVWZytGTU0zbmVMSWhRTk1MQjhyMS9seitacWhudDRJYmx2bnlWbWdS?=
 =?utf-8?B?RjlTOW5zc29NUDZKS0dYbFdTVHVjMkhROWxQeHZoVDVoQWdkYVR2UmpFakQ5?=
 =?utf-8?B?VnM0NDAxVVp5V3FCSVY3S0pyNHZVOHpxWkp1ZUZHNGYwSnhUWS9TNUY2Q2s1?=
 =?utf-8?B?MFRzZmMzdzZEclB1ZGVvOGY0ZWhiMnpadURHaFNJSVl4aXRTV2VyRWxkT3F3?=
 =?utf-8?B?d1dIbTU3aW1qODQwVlJraXhqM1ViRHRPNEJnMkJReG83Smk2Vkp5QlN0ZHFC?=
 =?utf-8?B?S3ZObUlYbTZKK0p1VkNLNEV1YnZNSEtEMElucGI3dXNUU3ZvU3VtSjlua0Rx?=
 =?utf-8?B?VFNFc2Vsblh1dW9ZcGhybkRFZ3FZdXR1ZS9oVzFmbTh1MERNaEpYUGZPWHBU?=
 =?utf-8?B?OENXVC9SWXlCMkxzajh2UWZEcTkzUXRMZE1DdEkyUlBMeHI0UExOSi9MR2hv?=
 =?utf-8?B?alFxREpDU3RZRHFNeDlQNEZINFpBTzZ4dlFDTFpZdW41dzJxU3dtVDBNZmEz?=
 =?utf-8?B?S3MvUW9YMnBjSE1oU1ByOWw4ZW04dnN2aG83QndLenYxRVBteHBzTEg4UWRT?=
 =?utf-8?B?S010ZU1aZEptczF6WTQxa3BuY04ralI3UFFvYjVlNVFaOFpCMEZNUFVLRzZz?=
 =?utf-8?B?TXBPa29BSTVHRWc1dWNkZ2g3S0p1TlVRMytkNngvK0RTWE1rc3oycEZGQ3px?=
 =?utf-8?B?cGFnK3RMalhKUVNOTGFzYXVRZmptRlo4cko0Z0E1aDNrVXh5NDNkZ3NKMzRp?=
 =?utf-8?B?QzRKQzc2Z0Vxa2ZPM2pUeTVWN29UN01IMnMvOGdTNm9QL0dIOU00OFRpczJx?=
 =?utf-8?B?VDZSTGNCQ1QwZ3VKMmhzenMydTQ2VmRRZHdDdEVPdHl0Q0FGT2YwMWhjWFJw?=
 =?utf-8?B?R1JkYy9icVg3Q1ZXZXpBSUZGYjEyVml0b21IQXFuYWk2cENIUWNZZXFwZWlL?=
 =?utf-8?B?NWJHekpTbnArcFFtdEp1Z2x4WGszK0s4UlVEdm9rUm1rM2VYdXVwWXRYQ1Ba?=
 =?utf-8?B?eVJOVllYVndteXEvSjlxb0FRSC80Q1lMbVVnUkR0VW16a1hRNis5bGthbzlQ?=
 =?utf-8?B?bnQ2QXV0M1F1Q3Q1U0sxNFdTSFlmNnY0V0diekZUK1pRU1NsUlFtYmp4NHJ4?=
 =?utf-8?B?ZDdFa2h1bHBsWWRmVTUrY2Z5TDYwQ3JtNXVVSG9hUExaWVNaQ1RCdUpsLy81?=
 =?utf-8?B?dytYVTBCY1RYMlluTzB2dXBBbWM5ZXdVTWFvbDFzVHhsTXR3ZFhOUENPNHFk?=
 =?utf-8?B?U1JHWWIrSzJWUXB5azVXVHBrb2tSZlNGc3pVSVpTLytjMGNYRnFVVCtCNnM5?=
 =?utf-8?B?bE50dWNKRmRjZkJEMXZQbC81bStlUDlJK001OVl2QmNIRk5rRDdoN0hXNHM0?=
 =?utf-8?B?TGZveW1qMzdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmxLa0k4MGdsRHpRaS8xdzR1ZmthNSt2ZTkrcHo4SjhaeDBqZWtWQ2s0UWpG?=
 =?utf-8?B?RXY2MHlaRmFQWmhBakhJWG9wMnp5eUh3czk2ejMvRCtJaGFZZEJvR0c4TVNw?=
 =?utf-8?B?UFkza1BKL0hvMUFKbzF3UFZnTStMckZueFloK0hMZlBuUGlNOS9Fd2s4dVF1?=
 =?utf-8?B?VS8wZDhNTnY4MHVaZW1vRVlnSWFZY3pFL1ZhUFpqZXpnQnkvckc5YlFRWXdP?=
 =?utf-8?B?cU4zQmZiSDlaMzYzV1Q4R3A1Zm9lZ2EyeTh1Y0VEaEp3QjNRM1V1OU1ObU1R?=
 =?utf-8?B?aURXZ0d1aXlyUGYwTCtzYVRSdWhtMys1VE9sSmc5T0tCVldRcUE3cVY3UldR?=
 =?utf-8?B?eEV2QXI1a2lsaDdpRzVkRVpISTU1anJia095SGhuaURTMFhXU0tCcUg3SFh4?=
 =?utf-8?B?QlQ3YzVhSmFSVThUTEVzQjljNTBpY1g3WWxnK0dNOTc3dDVhRkx3MUhMZmx0?=
 =?utf-8?B?WXExamI4Z3NpUVpxaWNoSmFrc21CaFVhMVlkR3d3SXg2N3lCZkRzcWcxR1A2?=
 =?utf-8?B?TFNuR2NMcTAwQ1hLNVd5eXdkVzVydktEbVhnVk9LWTBXQ2wrVDdMZnZOaU9I?=
 =?utf-8?B?N0RpMUxlM21KTG1IVjhORlRPaXMxVVdaUFpKRHEzOEdaT2ZqWTVVczFkUUdh?=
 =?utf-8?B?VWkyYmtRWG5QRnZINmtmMGxLR3ZZK2U5dXk4Y3prTWE3R2w1TjkwRmRpNG1E?=
 =?utf-8?B?OFFGQmNNZmxONlZ1alIxSnhBNGJPVFYxWDlkeHBadUgvMFF3dmlCaGZwTiti?=
 =?utf-8?B?aElrZUNCN05aNDN0TkVoL1BMMDZ5Sy9wSWIzVW15UGd0NnJ6THJoeHJHekMw?=
 =?utf-8?B?cHljZTFSWEcya0U1R09XYTQvd09qek9mL21wdWtqQnR5WjZIbldXNHYxbm1w?=
 =?utf-8?B?djk4VzJZTENPRHVRSnF4L210eTNHcWJnc1pJYnoyZUdLMkVHa1N5RndxV2RG?=
 =?utf-8?B?VDcrU1FrYkhseHkyUmlsTnBaSTZ0S0dtVVhGOWdoUGFNYjhNQkh0Z0xiVUhN?=
 =?utf-8?B?c0g5aGNMT3BwcjZVdHUyckVrdTlKZ2JqR3NqMU56NStNWXd4bC9CcWxxcmVF?=
 =?utf-8?B?M2NZNit0VlV6Z0xOZENReUM2OHg2b1dBU01jZDNvcVN0ZTNUUWYzS3Q1dW5o?=
 =?utf-8?B?SWpRWWJEM1lvZWwyekx6dEZva256ZDdyVCtvd1RpZFRWemQrRWg1KzZPbTU4?=
 =?utf-8?B?emhHb2xBdHN5TXdhY2o3eWRxYXFKUk1FajdJb0VCYkxoV0J1RHlHWkVuRjRs?=
 =?utf-8?B?dXlndGpUVytNWHhOWENCOFRrZWs1SmRTUzI5YmVRd3I4TjJhOGcrNklBbXV2?=
 =?utf-8?B?eUlmZTZCMDIzQnBSNzRxT2tmZ1c0dEh6RWc1T2VlWllzN3RXR1ZCL0l2c1RP?=
 =?utf-8?B?dmRsMENUb2x5Wkt2Qy96R0ZQa3hFUTA4WENoRVFTblpPSlNGdVUrb2FxcXlx?=
 =?utf-8?B?L3E2VWMwbWtHV3lzVVJ0cmxFUlZSamVxUEpqOGJVUGY3NEhObVNickZJcElz?=
 =?utf-8?B?NDNOMldxTkVXcUlaZWxLYzg5bDI2TkREUEZGR0hFTElUa09PM2tVTk13Nkx6?=
 =?utf-8?B?Zm1nR3RiOTg0WFkvN0lMclh2VFBXT2pZcFBxK3hob2ZOM3gwY0dCN09UMmly?=
 =?utf-8?B?alFSaUxnVW9jaFVwN1VkWG45VnZjNnRsSDUxVGh2OTJMM2kxZWhhZERBNE41?=
 =?utf-8?B?S28rQjVXbjJ6LzFUeWlxeHlVVlNuUk1ZenR5c2lDSlJ1K0JXanFybGFET1ZW?=
 =?utf-8?B?VEdrUkFqQ0dtMTcwWCtZNTZFWi9XSTBpSmhObEEzdzVocm0wNEpnVkxSeFl6?=
 =?utf-8?B?SzcxUkVoNytRT0lycTFwM1JRZnkwUmlGWHRHZlRodis3bFFhK1VaUUJqMWxY?=
 =?utf-8?B?dmhqQWV2Z242d3o3VVM3YTh4ZXdBZlZtUHlaOEFsamJWTk1VTDFEZ3orYW1l?=
 =?utf-8?B?dXJybjRkRjRGM2E4TWhjODBNSDZyWXpkcEpSd0dtNTFBSE5kVkprVTRkZ0xK?=
 =?utf-8?B?WHAvYVBYaFVoTkJ6bE5sZk1LUVVKNVlSdmlFSEUzSzUwRGMxWXMzeTc2ZnRx?=
 =?utf-8?B?RUNZTlRVVVlYeVJmYU9QUWxhd25jbzdPaG5mRThweHpiRzk0LzYyc1Z6dnFy?=
 =?utf-8?B?QjZ0ZFRwTUJjQmtJNDNoL05KUXg4T3RMVWluU2M5cGZzRHF3UVF4d3pPc3Jo?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da3d3117-a457-4433-4be2-08de02d7da05
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:52:03.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzuVpouU1Q2tQUNUG5SzxVMMN+rXKxBW5V5m1GbfCKoMFom5NxVXg+OQaHScOnInxQGUYC/plNNvMDLQHCnaVEdEaq/SR6b2J/Nb7fcdtrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> The INTEL_PMT_TELEMETRY driver provides telemetry region structures of the
> types requested by resctrl.
> 
> Scan these structures to discover which pass sanity checks to derive
> a list of valid regions:

The "to derive a list of valid regions" does not align with the
"At least one region passes the above checks" requirement. If this is about
valid (usable?) regions then I think (4) should be dropped. If this is instead about
valid events then above should be reworded to say that instead.

> 
> 1) They have guid known to resctrl.
> 2) They have a valid package ID.
> 3) The enumerated size of the MMIO region matches the expected
>    value from the XML description file.
> 4) At least one region passes the above checks.
> 

Everything below is clear by looking at the patch. It can also be seen from patch
that enabling is done only once if there is *any* valid region instead of "for each
valid region". One thing that may be useful to add is "why" all events
can be enabled. If I understand correctly it can be something like:

	Enable events that usable telemetry regions are responsible for.

> For each valid region enable all the events in the associated
> event_group::evts[].
> 
> Pass a pointer to the pmt_event structure of the event within the struct
> event_group that resctrl stores in mon_evt::arch_priv. resctrl passes
> this pointer back when asking to read the event data which enables the
> data to be found in MMIO.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 38 +++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index f9b5f6cd08f8..98ba9ba05ee5 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -20,9 +20,11 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/overflow.h>
> +#include <linux/printk.h>
>  #include <linux/resctrl.h>
>  #include <linux/resctrl_types.h>
>  #include <linux/stddef.h>
> +#include <linux/topology.h>
>  #include <linux/types.h>
>  
>  #include "internal.h"
> @@ -114,12 +116,44 @@ static struct event_group *known_perf_event_groups[] = {
>  	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
>  		if ((*_peg)->pfg)
>  
> -/* Stub for now */
> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
>  {
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
> +			tr->guid);
> +		return true;
> +	}

I have not encountered any mention of the possibility that packages may differ
in which telemetry region types they support. For example, could it be possible for package
A to have usable regions of the PERF type but package B doesn't? From what I can tell
INTEL_PMT_TELEMETRY supports layouts where this can be possible. If I understand correctly
this implementation will create event files for these domains but when the user attempts to
read the data it will fail. Can this work add some snippet about possibility of this
scenario and if/how it is supported?

> +	if (tr->size != e->mmio_size) {
> +		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
> +			tr->size, e->guid, e->mmio_size);
> +		return true;
> +	}
> +
>  	return false;
>  }
>  
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	bool usable_events = false;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (skip_telem_region(&p->regions[i], e))
> +			continue;
> +		usable_events = true;

A previous concern [1] was why this loop does not break out at this point. I think it will 
help to make this clear if marking a telemetry region as unusable (mark_telem_region_unusable())
is done in this patch. Doing so makes the "usable" and "unusable" distinction in one
patch while making clear that the loop needs to complete.

> +	}
> +
> +	if (!usable_events)
> +		return false;
> +
> +	for (int j = 0; j < e->num_events; j++)
> +		resctrl_enable_mon_event(e->evts[j].id, true,
> +					 e->evts[j].bin_bits, &e->evts[j]);
> +
> +	return true;
> +}
> +
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
>  		if (!IS_ERR_OR_NULL(_T))
>  			intel_pmt_put_feature_group(_T))

Reinette

[1] https://lore.kernel.org/lkml/9ac43e78-8955-db5d-61be-e08008e41f0d@linux.intel.com/
