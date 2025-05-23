Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE61F151E
	for <patches@lists.linux.dev>; Fri, 23 May 2025 23:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043535; cv=fail; b=ClyLubOkosZKRz+JCLvx50bDWE91oYhurT0/M6eVdfd8QoBvGKgcwxF6pqoEco1xA8KIpYJ8XnFn5JOANSZYqb3FTxEC7A75xdr0r6RiMAZnDYDfucuA7Pd8Jipm9eh6A2BT3NrqmQv0OF4r/jLq1ke15Jzsp4bPhg4382sYrd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043535; c=relaxed/simple;
	bh=GhqFpdAxQsvimj3vgQTpkQrbJf0S4Jp/MxlPnBP/DXs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B8Oqn9/a4dPFtvYBU8OlQ0RaoaCTaZwOawh35H3yyWRFYPXfwc2eQY5nI+VV9r1sfQH5TTmE8cQ+YsmDFrYH+R+nKl0lpl7Kx1eT04xu2TeFor7qHrXqR3mkoEv8GEy8Idd4cRcDPaj2aCjlbcyD7gZeNE3fT5Ccb35FxYzpNWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=chQr60C6; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="chQr60C6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748043534; x=1779579534;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GhqFpdAxQsvimj3vgQTpkQrbJf0S4Jp/MxlPnBP/DXs=;
  b=chQr60C6m4UVgpq5A/LkihIbN82GpfPTCpThzlYzImoz0QFVUSdF+dFv
   dhPuM9805pHB23eYWlnC+jMMswabVvQLZ+/6O27VyWuPNcfEWSyUvu92i
   wmy/9RkECGMrq2okinb6Zh6AL7ldnLqGqDLJip9m+HHqJy5MD9ooCtdIw
   3CDc+qMojXLSj3QGqcZE9Wkl7qgqSD3QCyuChCDie/HPAJuEilD2tG+E5
   jcCzfYKL2HNKIbwrv7KR0X7Ygc6pNN7Ef7L6Y+M7HoFWF9jBGy3Fszu/v
   cG4KOgIhzKng7eWeOiJIGH47nInb/SjBJ9JFTBEMsRcwMGM/xVKx7KSCx
   A==;
X-CSE-ConnectionGUID: kKqb44euQTKIP45h20KC2g==
X-CSE-MsgGUID: fxtFH11nSu2DJ+6JQS4Dxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50030604"
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="50030604"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 16:38:53 -0700
X-CSE-ConnectionGUID: 4ZUBU9pNRpeBzhkKmjfeOw==
X-CSE-MsgGUID: 7HP012vNS06GiT1Vq3g1iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,310,1739865600"; 
   d="scan'208";a="141211346"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 16:38:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 16:38:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 16:38:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.74)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 16:38:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=giWM+CDGMlaEGv2IdXdRK/jUX3QpcfQF99CON4XMVdvB5wPPBAZAzxqm+m7aygcXHktnQD/wTWGzckMETPkAnxAQkXJdWiwx1ZWDmnYGJbgmfW045iyGwXBjDEcexAlxXkAX5PEBPYRto52EtdTVAXmbk+x4O/zFw/Y6BbL5rxBKJT4anP/FGj9S3gxdzdtRzwLxvQoEuUyId96oUNkuKwaXCq8J9Ga0BeYyj0gdXDUpNkn5MyrprlAduGmdL0z/k1rGGN82UOjNbCmJTzjT1qwtgwprH97tNCGRipP3E2AfWPBf9FdaSdT/eMR2wH1Av/OLDCIyaVKpG7lkfsZKiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/V7vb20E1T5xsCwfsjkOk7D8+9RKCbwdEtoSQR4Oj4=;
 b=Anc/EcQB4sHWjYEaP4jUCYPnpFwNPU5lXKYhgHWzp2qiMKqrGDTRD2ruawU3MZTW8E2GiOpEMn6X07afhYneKoBi4qjB4/Gw+RWO3pVGasNrzZkJWJ4zc+W01soWUqvt+yIm8wF3jN62VHuYzpMbRPoTXm/Tt2MVEZ3RALDiEOMdX8XkqLl/FfmmoepGmY4Lz16ExXTmqloyN7cNNxO9mz3qM+rx7iFyMDML4vr1IYGC3aRFTb6T97Q0j1ouHQedd95nBony/Xukt41z7vtRStK+DsgNxR092AB6AUCGaM/vsrm05T2yaaaDeg529SxdIImzaG/8am4Pss0vXtW5cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB6080.namprd11.prod.outlook.com (2603:10b6:8:84::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.29; Fri, 23 May 2025 23:38:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8746.030; Fri, 23 May 2025
 23:38:34 +0000
Message-ID: <33aff696-21ce-4e84-b7cb-6f05cdef0402@intel.com>
Date: Fri, 23 May 2025 16:38:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/29] x86/rectrl: Fake OOBMSM interface
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:74::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: c7db200e-5757-4b7f-7382-08dd9a52eeb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U092Z21vM3EyUXZDM3BNQ0xEM1hEM04wZ2lnZGxOK3RCeEdQbEZGM3Ntc0VK?=
 =?utf-8?B?ZUFpeVcrSVVqLys1bjg1U1VSTXRhOFg0SmxIeWZlRmQ1YUFxTlFBTitWQi95?=
 =?utf-8?B?dkpIdklyQkNQaFVjbU80NnpoMHYwNGRPd2UxOW1KVEhsY21nY1VTVmhObitx?=
 =?utf-8?B?NDUrc1ZKdzgvQ0lpa0RpdnFBbXJoUXA0blEvRW42azJQLzFCRDFwRFFlcndl?=
 =?utf-8?B?STFyWUwrZEZRd0RQRUhPaVRHTFJRcjkyT3EyY3BhS1FpZHJ3Ti95RldVdWhU?=
 =?utf-8?B?YXRNSFRRM0Z6b2lOaWVjZWwwWHNQdklUazR0NXdLckZhS3NSTEdzUXNHV1ZH?=
 =?utf-8?B?QXF5Tlh0c215WGp3aW1lWXZyNkVRZCtnTmJ0ZlkwbVgvUGJ5TzlPU0hWSEM0?=
 =?utf-8?B?ZlAvbDNTMlIyUHUrdFEwMmZKUllXc2VEMlNlZDFzbkliSEpFZlZQWXR3d2hR?=
 =?utf-8?B?UEk5N1lwU3QzYVpJMkdqRnhnWXQyVUVKZkxFUFYvRXVkWk4wK2FhdFhZWktQ?=
 =?utf-8?B?ZnRaZ1Fob09ReS90bEo2MDQxQTJmeUtIQW1ORTdQajZzMHlRaXlVNG03akJa?=
 =?utf-8?B?UE9QWXFEUkxEaDkvMWpoUFN1MVNtZEdRQ3F2VXJtSFZlaTMxUU80QXVKNjZD?=
 =?utf-8?B?Q2svWmtYc1hJNDl0YWtlekh2bWZIQzY4U2VCaFoxbXhWdng4cGdha2lNd1dU?=
 =?utf-8?B?WFJtZTBzSDh5anlPK0ZNTURhdlpqbHVSNUdnNTF0ZDR2eHZ1UThjRGVPUVF6?=
 =?utf-8?B?TjlhcmNaZGx5eGcwcjRQc0pWQnFaaGhrcDVONDlTU1oranREM1NIMzlXQ0ZR?=
 =?utf-8?B?RTJOWHJRTHUwQ2taTE5CODVkYUI5U29lUkFHWmRuZUN4QU02Z2plTFlNbUJY?=
 =?utf-8?B?MDFNWGFYK1RzdHlmOVRjcFdzODJzRmUwVFFna2JxejEra2NXUUtPTW52QTUw?=
 =?utf-8?B?bGhVZk1RMk9qYXowVGpHbUVYZTFyMUN1QVZBVXRJZ2lBMXhRcGRIOUliOFNC?=
 =?utf-8?B?NnIrNFpxSERwRXV0Qmk1UFE5UXRaQlQyN1BNZGE4bjltamo5R1pxb0lXUTgx?=
 =?utf-8?B?cWFvUnRGbXBYYVM4dUhBb3dTbkkyMzRZVC9ONGkyRzRrSUtENFNiY1FtcmdG?=
 =?utf-8?B?VExoeDJkNE1TNDdrc0hHR2FoOW51NHFPLzFFblBqYndFQmduK0tlODBKQSsz?=
 =?utf-8?B?OVlyY2xOK0Foc21KN1MrWitTYjVaZ3cxUU1TVkEwWVNuaG1LR2xqTk5DczNW?=
 =?utf-8?B?cnJ6dC9lanh2TGpyZ2tKZ1lsU2tQcGh3b2VrTFpxSVkxYlRJcUM3OTFVRjVw?=
 =?utf-8?B?K1ZZdW5MRjhtOTVxRWJpOUhuOEVWSnNxZFVYTW1YRnFwaytLY0dnWHIyZ1Nl?=
 =?utf-8?B?Tm4xRkx3L0I3bjZHQkZZTFU3QlRqVFdQV0Ura05NeDlSRHE0bGlkY25DUHlp?=
 =?utf-8?B?MGRUNUdyVlZJcURPYmFVOXJpYUFBaGZDZmtCS3NFMjFYZW1GTm5DeGhlTkV4?=
 =?utf-8?B?L1Z2UkxqRnFMWSswUkFFdnozaHB2RldDRjNXVmxXeTRvZjFKejgvaCtBWUpO?=
 =?utf-8?B?ZjlRVk9aWldYMGxiSlhWZUY4R2tIMkU2UHdNZzlnUzdXTE9iTmhKa0ZEYlcz?=
 =?utf-8?B?a2c0bFcxQXQ5UmJSMUJlWkFoMTBueVFZZ1J6VGVMWXVldFJyemVXaldJT1Av?=
 =?utf-8?B?bWl2VlhjbnVpQ1NpUkMrZmpEQTFQSG1GUXVTaEtaMUpQZ2hDUEJPeWRGdE1q?=
 =?utf-8?B?RnM4NGRCT3Nzb1lGUFJYWmVUTlgzY3RDZDNWSUdCSHQzWXB3MUY0RDhuellH?=
 =?utf-8?B?VGlrTjZNWHhqYS85SExQWHFHZ0RXb0VJSjVtYitOYk9OWGtVcmRuTDhRM2NW?=
 =?utf-8?B?Zm5IM1JpZE1OVElJSFRHUGtjM1ZUV2NDU2pMRXphUDFWcmxxZWlGR3BSTG9M?=
 =?utf-8?Q?TtP7dCk88no=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzdlZnNjQWdRYUQwdUxFYk12b1VxNlJOL2lqS0NKT2dNNE8yeWhHeHUzWVZn?=
 =?utf-8?B?UWNDZ2lGU1lWM1ZCSzlEbzZxdW1RSkRPVDc1V1UrVXdUeCtEMWJpMGVUUUN6?=
 =?utf-8?B?dWhwZGpQZWI3RjV5SGYzbjVzc1dGQ2NURWgzbmJZMkp5UkxNZGpVb1dUV2g5?=
 =?utf-8?B?OTNLM1c0cnFtK1huQUE5U0RIekszRUpTTDVMbFd1emVXM1gvY0EzempuMFNi?=
 =?utf-8?B?N2w3UUZRNk91ckpqNTZKUTltUXJoZXZmdGU1NHdrQnZIOFBKRlZhRVk3Rmxu?=
 =?utf-8?B?RVNYMkR1dDl6cWxvSWx1ZUdVMnBBcU1nU2FoZXFvWnczQSszZkJTWjZVS0xN?=
 =?utf-8?B?NjMyUFJtT3MxalNLTHJTN1Z1U2NWL1lQYU5NZ1BpMWRuanVjc29iN0xYaU9S?=
 =?utf-8?B?QzRUbnBPV0dxM2dORUUxMXJyVlVZM3hQSUtyU2xuM0hIL3I5Q2ZZTm5Yc3NR?=
 =?utf-8?B?UXpSU2d0NCsyQ214Y0VYWGVBSmtxOUxSajBPNWo0cVcvZUpreVZ3SUZIU0d5?=
 =?utf-8?B?M2x3M1MwYWpWWHFNZjJ6dlE4K0EvOWNQRVRYZnNvTVNveTB0U3JVTGRzL1Jr?=
 =?utf-8?B?OFBkWW1HZXdWSzZvaWlOQU5qRit2M29DdG83YzhIL3VxYkhGM3NQNlJGS1JX?=
 =?utf-8?B?UVNoYUFPSmZwWkdUQzRITm1CRmFLL3pqMkQ2VmFzQStpS3JoY3RZYWlxYmo5?=
 =?utf-8?B?Y202Z1hzcmwzN0Zlb1lHa1lBRlh1ZXllMjRUWEJPcmpwRG9EVmNPWDRPbVZU?=
 =?utf-8?B?aDdXdDdiQVhKd09rRkgzL0IycWpvdUIwU1h5OE8rREdtdGNISjdWTjdYamxG?=
 =?utf-8?B?bGROOFRoRElwOVNUd0JVK20yQVl5UFM0M0hPK1E4R1poazV6bmRGVDlCWnN5?=
 =?utf-8?B?UFFwbFZNTmJiNTl6QnJWZDBJT3RrbU5hZWNMcnBteml2MnRIdHdOY3Z5KzY0?=
 =?utf-8?B?VXUvNHdWSjc0NG9hazBvRjFVNHU5amNQcnFZNGU2cnQ2NUpVbkxHa0FNK0hv?=
 =?utf-8?B?eDFvYWhZdlZwVlN2blpkdzVNeURlMjk0cVpFbTlGRC9uaXh2SmVHSVpqUlVz?=
 =?utf-8?B?VUxUb21EUUVZM1hxQzY4d1hsck1oaHBLVncrOGtYaERmaWp1aDhpSXhBeTB5?=
 =?utf-8?B?cSttUkwzM3YvVnJxRlJJNnRmM1BGcU1UVi9nWFV1R1dVY2hyZFcyUkRLcWd3?=
 =?utf-8?B?K3RXWUhWbERmbUZTRUI3Mlpld3Z1Tnh6dVpmemkwQ3F3TCtoNEZWZzh4eHFs?=
 =?utf-8?B?UW5Pck9td1NmVWQwRFY4Qk15S1dGcTBRdDJjb285ZnQ5cG9HRXdjZ2tWUnpk?=
 =?utf-8?B?UFVUNCs2T3RUNmlTN0l0eER3eDFudG9nd2lVN0Q1elZ0UmQzVnRic3NEeGw4?=
 =?utf-8?B?OCtYdG9NT0k4Z01iZHNnL3ltTHJZTEI2WWpLdmRvK3MwbThxblhoL3JXUGFi?=
 =?utf-8?B?WmxmYnpOZkRPM3p4ZUR6UHRzL3A4MFVIcWZzc2l2VEtENURFRnozNk5mSkt6?=
 =?utf-8?B?UHZaMHpXaUhKYngySWhKR1JsOTFSTXNlbk1jSDFaaXJ5N1h5eWtFOXFKWmNp?=
 =?utf-8?B?ZWhXWFpESU5VVGEvaTRLcldYdDZ1clllcHNCY2p1OUMweFo3UkZsVWh2SVE0?=
 =?utf-8?B?dkJKTWpZekxKWHlxWVdYaDBrR2VlbksyUHkyekZxL0FIVlNLZ3dRT3V2aVYy?=
 =?utf-8?B?WVFrbWlJUGd2WTFJOEFlV29Sd3dvOTZaQmNYRnNxRGdRL0szTFZ1c0JjQWRv?=
 =?utf-8?B?VHNXZjROMmFua250NUJXdHRDVEJMU2kxR2hOeGUwRUZRVG9xV09PckJHdDc1?=
 =?utf-8?B?UnVEbWxsbXZwaTUrOHFzSzFNTXpuSis2SWZFMFA3N05kbFc3aFZFeC9xTVF0?=
 =?utf-8?B?a3ZkTzV5eXhyZ0w1MjRXSEJEUjg4ZFEwemdTZUtJV0E2dDl3Z29McnIwYkYr?=
 =?utf-8?B?ZzNDb3B3cXE4QTYzYXpCaFJ1V2g4VEkxdXZ3Ry9Zd1VqYW9zSWZXcGFPV3Ju?=
 =?utf-8?B?cWJkZjU4T3Uyc0NZS2Y4aStpaUtyWmFyZEVndXhjUFZjMTJqRk05Ty9kTkEy?=
 =?utf-8?B?WUNhRHNjTDFJYzA1OHdkenNxVDBkdlcyVCtNc0pKVHMrRWpRRks0c1krMmFR?=
 =?utf-8?B?Mk9aSndGcU1rOUU4Z3QxTHl1UGNqRzZaWkUxdTZVVDJEdEVNQlJpdEJOYVVO?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7db200e-5757-4b7f-7382-08dd9a52eeb3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2025 23:38:34.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYyNtENClGN+z9NA5Mnfx0D2CV0+gecmhdUC5Qyj4cGGwgWjxxOf7bBMe0ihM1mzoBANPhhERdv3LlP0t3btlh+yTQnjrP+RcOC1IZVAiL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6080
X-OriginatorOrg: intel.com

Hi Tony,

shortlog: x86/rectrl -> x86/resctrl

How many reports of a typo does it take for typo to be fixed?
V2: https://lore.kernel.org/all/b69bee17-6a84-4cb2-ab8a-2793c2fe7c49@intel.com/
V3: https://lore.kernel.org/lkml/2897fc2a-8977-4415-ae6d-bd0002874b3a@intel.com/

On 5/21/25 3:50 PM, Tony Luck wrote:
> +
> +/*
> + * Amount of memory for each fake MMIO space
> + * Magic numbers here match values for XML ID 0x26696143 and 0x26557651
> + * 576: Number of RMIDs
> + * 2: Energy events in 0x26557651
> + * 7: Perf events in 0x26696143
> + * 3: Qwords for status counters after the event counters
> + * 8: Bytes for each counter
> + */
> +
> +#define ENERGY_QWORDS	((576 * 2) + 3)
> +#define ENERGY_SIZE	(ENERGY_QWORDS * 8)
> +#define PERF_QWORDS	((576 * 7) + 3)
> +#define PERF_SIZE	(PERF_QWORDS * 8)
> +

First time asking why energy and perf are both using 576 RMIDs:
V3: https://lore.kernel.org/lkml/2897fc2a-8977-4415-ae6d-bd0002874b3a@intel.com/

Reminded in V4 that V3's question has not been answered:
https://lore.kernel.org/lkml/7fa19421-9093-411b-b8e2-da56156a9971@intel.com/

Question is still not answered in this version (neither was it answered in
response to the emails where I asked the questions).

> +
> +/*
> + * Set up a fake return for call to:
> + *   intel_pmt_get_regions_by_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> + * Pretend there are two aggregators on each of the sockets to test
> + * the code that sums over multiple aggregators.
> + * Pretend this group only supports 64 RMIDs to exercise the code
> + * that reconciles support for different RMID counts.
> + */

This version adds this comment. How does it answer the original question?
The comment  highlights that energy uses 64 RMIDs and thus highlights that
it is unexpected that above defines uses 576 for energy RMIDs. 

Reader is left to decipher the code from multiple patches later to try make
sense of this without it every explained. 

Repeating a question and reporting a typo three times makes for an
unproductive and frustrating review. I usually work through a whole series
before I post feedback but when I got to this patch I did not feel like going
further. Why should I bother?

Reinette


