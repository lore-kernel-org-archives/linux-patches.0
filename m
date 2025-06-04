Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434F3171A1
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749061508; cv=fail; b=I4+RG9eZu8M8NT7goevoRDJLtgedHyBTrchy6z6Pnu9NubWLSuNVFli+3K8p89OX+pYFsSIZ5G7GkFAtBx9G5A6wfccEDf3uAASmL34Yb/K8ksqDJ7WTIng14iQVOT67qoomtq6PbwioyQDcwn+TDzIjx1ny23vnMlXwSZxdoTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749061508; c=relaxed/simple;
	bh=R8LiFmz3NwMAURbam7tWBt5nRDyrpeW8kukconjBSIc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NLtvHX4028mylc68Y4/wfbCPdxPsO48ZvDjZKcS4UaDjtPKJ3e17rXNO5xeuxzxEtC4mcsePeXFcxL4pGHhmKxbxmhu6BOHcJnCUC7+h+WmKmUhDXeP03ZZbeT3Rq1YY/8wIHbne1BQp8tfuD/jkAQX7vw3ut6tXrh4iQp0mCTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQZ1PIc6; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQZ1PIc6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749061507; x=1780597507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R8LiFmz3NwMAURbam7tWBt5nRDyrpeW8kukconjBSIc=;
  b=SQZ1PIc6WaIu+WDPpIpMOMRak0CNzeYCAn5MBqON5R/gvtRlht1J18pC
   N767VxsksCaR534wMNbDyrIewkzgeEjxnXM6JnCN4ZsK2jK9G0vyJHH17
   kHpvw1ICeiFCtLgJVHYqSVNoTA8SFVmGDbx9ta/XTncqJqlzBnpChzE/K
   6feLmrr0A7xK8e7RPVpb6US0BrQnLrvtt+dQH/yYFUDXs62e0zsbu4205
   I8wUyNQePhcW6Ml3UWH0fVzx3+SM06qB+01tkjLWCx7i9noHgmQclvZFM
   BrDW/qxUFDLT39nzDkRqDbq9IWcdtkOpaH3PxqFtBljLbWhxQBaD/EmOq
   Q==;
X-CSE-ConnectionGUID: v1JWqmbTTU2PeXmFbCj+Nw==
X-CSE-MsgGUID: S+FTe2OlR1yp4OGBxPKoug==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="54957483"
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="54957483"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 11:25:02 -0700
X-CSE-ConnectionGUID: L1CGcH3dSOixdz5ZU+9O2w==
X-CSE-MsgGUID: 21JHMEFHQ/GfOKIDraG+Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="145611042"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 11:25:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 11:25:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 11:25:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.66)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 11:25:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTlDt2CYPnIorkirdozmsD4VdVK3aJWCVPKNHtkeke2pTtMa5RnFMhzVxTRcSstmjpFbf4aauUQQbbmyg9iVgGAeOlKozJwQFY9ieA+XYCX+i2CzFLWUbCPrYO5C/TSEJP7DC5q86V+WvAtJngWD9h5QmT91TPmB3i2UEMUFZZQqFE6tXX35gcutuaI5v0XfNCW+DhiQxOpycMj9ZvmMBnPcytvSbLkrvGfEo15QxlV3hODTKRI4R1W47g6QNlYHvdNMdYATfzlNTIbs2EOcIIwNDaXHjCyysHLUuA9FGubp40Bhavrnga07bQMEOTd6ixbOmPRkRlG5XlLMwcX5jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzuhW5AsHCY4iaqwwjkqR1+gFkozzWy9BV+091jD2Co=;
 b=Izl4yYLnRyS7fwv/1WA6yOnC0ySv0v6Ja3YO2TesC6oym0Vb0YECUMyBcIkjOr9yHHFAR6muqmCAmWSUxiQ6Mr3SZABVXAGJO1CvVzlsEPvu42MZD2Ss/J1tyUsLwOB5n4ivr62ndSW14IGbTt0ClSvCN0vEfpyn75CXvQjG3cWe6a3ib7RCZFxjnTlKF6KksbNtSKsgpADH4yPdEUwUR0qLGeqsLwH9zdv5/4ruf52BAAVN8ahNSFc4fAd9YQTuT7tJqn3mVoFhbeGlVavE0DibQmy4HrI/4zzfYLx0K75D7o2Hrsnx3cwLwxNeSKjkl5pVhnCJ3Ek2chSg4w1Jaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4917.namprd11.prod.outlook.com (2603:10b6:510:32::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Wed, 4 Jun
 2025 18:24:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 18:24:16 +0000
Message-ID: <650155ab-c5cd-4ba7-9b08-bf0e60dbba92@intel.com>
Date: Wed, 4 Jun 2025 11:24:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/29] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-2-tony.luck@intel.com>
 <7eec0d2a-457a-42c7-904d-2c85633dc2a3@intel.com>
 <aEB1T0GFqLl6RG22@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aEB1T0GFqLl6RG22@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4917:EE_
X-MS-Office365-Filtering-Correlation-Id: 889310f4-44ed-4789-05e7-08dda39503a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGtGQ21NVDQvaUg2VVVkZk1NRGpLZWlnMmk2Q0k5cXVRZ281bWNwdkZZNE9z?=
 =?utf-8?B?aXZ6VXhVUkJiVU1WL0JVeHh0elBrV1dTVXVGVTEzUFNzQ2lCOWZDYjYzQzBC?=
 =?utf-8?B?RE52NUUxY2ovNkNmcWtLc3hTS3BSRG9ZaDhtQTFYang0MmNIOWZLZWJ2MS84?=
 =?utf-8?B?YVdSMVE4V05ncEFLaTFKSEN3djljWDB6K2xLT2Jab3BvYUh3U1M4aThDaWI4?=
 =?utf-8?B?WW5LVmZnSHRUaEhYS1V3T2dROERoOXFBenhScVkxM0ZZeUt0Mk1pZ2lmWEQz?=
 =?utf-8?B?Z3RMMTJZMmt3R1BuMTEvdjhKSHZOUDZPbVp5NS9Lck11eVhLVzBvb0ZFZnda?=
 =?utf-8?B?aWpEdjRyU1lIQU9BY1V1ZUpwSTFOaFRZN2JOZ1pQSHBQUk9vVTc0OFNWUy8z?=
 =?utf-8?B?WllzcXJaVlBFdEplbDV2T0J6L0VrTHNTNGgvaUJIbkFrbzdkUVY5dEZzR3Jq?=
 =?utf-8?B?b2lMQ3V0UHl1N0c5OWZLS0JRdFJpZW8vbUwrS3NtT0VpY2Jmb2w5L2NXMkZt?=
 =?utf-8?B?aXUwTjBQTGtGbEVsVXFtWEh4aFZkcHU4NmtPaGFRdEN0M1p3NkovUjlBY0tB?=
 =?utf-8?B?c2tDOGo1UmdBbVJBeTZqSElkY3RJRUhXRS85S243dTVIUGNxdlh2RjZiZHNz?=
 =?utf-8?B?bS9ENjN5RzZ3azRyOUpGak9OeHFqcTdMS2RvOTBhZmw5a1lFUytMemJhN3Yy?=
 =?utf-8?B?c1hwUmt6VmZFaW1lRDNOSmFvTXdRcTlTVmxoQUptTmdKNXkwb01zWDdnbVZ3?=
 =?utf-8?B?NW93eHltYk5TcUNZU2dWTzVUM2RZOVh6Zjl1aHNUTVloWlhKdk53QkJWci84?=
 =?utf-8?B?d1g2ekx0TWVyMlowWEZhUDRnNFlOWWwrRjFTTmVUdm5CMUNiTDVwdVBsamdS?=
 =?utf-8?B?U0Zva0FvREFGbDZWeGVuSGdYblJKNVpueWQySUpaSVZoN3QvVzVSK2ZZVFhu?=
 =?utf-8?B?ZWpMdHBLbExyUGpJY2Z0bVdhUW4wTVJIVW13YWprN0FBQVRqdmNOU09uMUJJ?=
 =?utf-8?B?UUVJRG1ESzdFcDRKZGdWN1NSZGU5Yk5zWmNiU3BVMEhPZXhUWjNMeU5IUmI2?=
 =?utf-8?B?bHRaNDlFb2dZU2trSS9ITVFWTm9oYXl6U3dsUHFER1pUQjBVQ093Z3NhMzdY?=
 =?utf-8?B?SVhheVpPQVlqWEJtOEVyUmFTK0RHUGNOZlFlR0Q1akR2Ni95WlRJbjBkQUtp?=
 =?utf-8?B?eElRV1lLa2k2L0hUaU9MWVVRTTFPbWpnaWFVQ1dNNjE5VHVRT2ZKZHNhUmN0?=
 =?utf-8?B?U0tuazBwSm5LclByMXJob21tQWI3SDIzWDJndnJTM1JEdmpGcG1OVnRmUnRu?=
 =?utf-8?B?TFp4S0hUREVVSGluSXFrbloraXNoOXgvTDhKSCtSREU2ZjBEcDQ3VVRhWlh4?=
 =?utf-8?B?ZWFlYk11R0pDTTZVMGxnL0VEeXU5SldLVnhoc0dXczJUOFFuY2xsWjUzTlls?=
 =?utf-8?B?V2RUemhROVB6TmdXYXpNTGI0VDBWRHV5RTREVk43RzBVV01udmMvMGhoLzBl?=
 =?utf-8?B?aHd1cTJsb2lGR1dwUWR3L1ZPV2E4Z0FLZFVieCt1aC9mdzN1LzhwSVBjY3V3?=
 =?utf-8?B?TnpUazJSUnJpeW9hU2h4dEJDTkVISFZDNGE1NE9oWjhkSDVVNEowbUw5ZXha?=
 =?utf-8?B?ZmdQSVA5ZE9RdUhoMU9BdlBZd0h2bm03RS9sTGRBaFhaRFBldUJUUlJmSFVZ?=
 =?utf-8?B?VVRhTVRSY0RXNUhDWGl6eDFrMVp4eU0zbjJORk9iemU4cVM4NTZoL25FQ2Nn?=
 =?utf-8?B?UkVDOTFZWEYvd0Z3eFJCQ2taOVJleVV4K1M0VFRtSWFSam1VeGZxVVEzK0VY?=
 =?utf-8?B?YWpxSms3bTdoSDhTN3pTSHBvNTFPRmQ2d09helF3cVBnbHBYTFpJMW8vT2pP?=
 =?utf-8?B?U01wak5hRUhOTWw1ZTM4WmVLYWdidFlFTmRWeTFTVzU0TWQ2cDB4dGZROFBH?=
 =?utf-8?Q?rGIT6yr7xZw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUVyeTVQYWl5U3FLYjRhR1o3eHFUaWhoanRBMVpEZ1U0NG0ySkpTSlZzQ005?=
 =?utf-8?B?T0hDL2JpV0V1VFRFTkdsR1UrYmx2YzhNOHo5VlRnOEtWdjgrblhpUVBTTzlR?=
 =?utf-8?B?VlBaUkVLaFlYZm5Vd2l1SHlwYmNyM2wvcEo1YU50emRoWi8yREdYZmZYVzN0?=
 =?utf-8?B?ZjlaQlI3VWRwN2hCdlBZUENSVE53K3RVVndKbXl2N1NRT1V5a0h3R1lERkgz?=
 =?utf-8?B?a2VzbUM1Sm1ORFA2Qnh1KzExeUhiUkNpS0p4by85MWJibkprS2RvV00yRWN4?=
 =?utf-8?B?dFpFU3FrMlF2bHlDcnBZZXJRQ1J6UXRwdDJ3SWcvMWVzdGZ5WkhWNzB5alBj?=
 =?utf-8?B?NVBFSUJwSWVMeExMQmpYMzZ0TG5FUTRhRW1vSFVwQTRmYzE2Y1FqOTdRc3Ba?=
 =?utf-8?B?eXlaam9nS29YYjlwRk5ob1hBMHFoRVVFOFQyR3ZFY2E5QkdFVVdTYzEyZmNH?=
 =?utf-8?B?NkNuOE5RbENOYlN2SGgwUzZZSS9lM0g5TVJqNlM4M0NSaUtOMnBLRTBLaTVC?=
 =?utf-8?B?T0E0OGd5dnowK2dVUzBzcXhGaGF4eHlCNXlVbCtMaUovdFhaVHBwRlk5VHJh?=
 =?utf-8?B?cG5jNWVQWHlxVExlTWU0RlI4SW00ZDV5eTNKc1ZOMWJvclEyUDlRRGtRMTli?=
 =?utf-8?B?djkrMHFxSjBmMXo5c0U4cDA2VGRiL1N4bDlsUGNVQ2k3ZkEzbVREY1JhdEN0?=
 =?utf-8?B?YjZ5Y1J2aTErb2lMY0lzNXdqc3NRY09ZU1VpeUl3enhYYTFFbkNsRkdhd0NM?=
 =?utf-8?B?NmNVZW0xczEwSkRyVTZkQUN5ekVrN21zUDhRelk0bUtmdHpLbGxiQzAzYlFF?=
 =?utf-8?B?eEZXallzYmZFb2tyS2dkc3hGb3REenRNa0dQY3hYVmlmUjBScWxzTGNIcGtx?=
 =?utf-8?B?WkhIaThPL2REQnVnRndIYndyZjNDRmQ4cTh5MGwwUWtDSDRTL1BpMGFFK0tY?=
 =?utf-8?B?UzNZdGQwSEMwUUZrRmdUaFJ4MGpnT1UyVnExN0xWak5oSWxSdmsyd0loNFU2?=
 =?utf-8?B?QnBhOUVxZW9mVTlRRUJsVlAyS1cyRGpHWTl2T1lXUks2bno1S2Eva1owSVNK?=
 =?utf-8?B?NnZQcmtDWkpLUVJkM0o1cG9yOTZWNzgwRjVGZjd4ZHhjc0RPVEd5R2R1RlIw?=
 =?utf-8?B?cFdYSVg3VlRDeXpseldSYysyQVNVc3Evd2dyTGNwUDQ5R1cvZDNGUm5xVlRu?=
 =?utf-8?B?V3hNOVp6ZGRXVVlsZlhiKzVrUWNCeFExTmI0eVJmclZBcm9RWk0xaktOblZF?=
 =?utf-8?B?cC85ejZ3bXlMa1E5eGpXOHZ1NEpWWlNlSkd6alNONFJyTWpiWXN4dXBqR2VD?=
 =?utf-8?B?aUxwV0I1ck9XcEI5WnV3R21LdEFkTkVSVzZob1R3blFQTXNGSUpZbjZZWm55?=
 =?utf-8?B?eDJhOXJhNExkdzNmazM4UGhNN0JremRiR2U2ZGFNYlJ0UnM1b0d2MU1Zd2JB?=
 =?utf-8?B?VWl5anQzYnA2cG5kRjZVUUtaMkpoNjBiODZNNFRzVkxpckdJTEFvd091bHVD?=
 =?utf-8?B?bVJKZEFkTHRnVVc5R2lNZkY1bkdXWUZ6U0RDb1F3SkFiY0FnNUdCR3pTcTJJ?=
 =?utf-8?B?SHl0eHY4cGVaTkVDMGJWSS9XbDJ6ckcvTGdoTFhreFZUT2dXS2p5d0laTUYv?=
 =?utf-8?B?dUxhdmVzR1o4eGtiRkR0aVlCMXFOL3RKSjF5d2NyQW5BbnRuaE03bjgzOXdD?=
 =?utf-8?B?Ly9JUWJzSjB6aFZlZzNNUFprTnp6dzR4MnlxbVdOWGJZM2dnKzh6WEVYSkhP?=
 =?utf-8?B?cTI4NjFqcTB1L1RtYUtpeEx0M21Pa3VlejY1dmFNeXE5T1Z5LzIwamg4ak5S?=
 =?utf-8?B?SGZUSk1EdWZIWTR5M09jOFNHVER3d3ZkcXBVeTZ3WG56SG10MWxIWHIxdngz?=
 =?utf-8?B?aTdYVDY0TEswZWF4M1FSUHFEVFBwaWdpSU1OTHFLaTFqSTF4RlRWZWxTQkZ0?=
 =?utf-8?B?UW1HcnJlRTRFQkN3TndBOUJJMm1iMHZLR2IvVkpxZi9CMnUvT2JIQ0JOSDV3?=
 =?utf-8?B?aXROeGQ5TlovNnRyWmgrSzFrL1piaUN6cnpqVG00ZVE1SnpsMkxBVTExSHZO?=
 =?utf-8?B?T2gxaUNSaVBBbGFaSHkxOU9xb0FmTjNCalY4MVZzR1RrTDI3R1hqWHRNMlNP?=
 =?utf-8?B?aThwMm80RzBKZDlCNEtnV2EzOWMxK2QrNTM3ZGxDTzlpZHBlcmlLOHdMbG16?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 889310f4-44ed-4789-05e7-08dda39503a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 18:24:16.5142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCSE8uwDE+oMorAA9Hmi77K1xHs7IhhYygIileD1eMX5lz1JmLgHB9lN9II0POoOsbmsTwnT9XUF0veeJY02eyRz778gHXGgZhe0PFGPpKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4917
X-OriginatorOrg: intel.com

Hi Tony,

On 6/4/25 9:33 AM, Luck, Tony wrote:
> On Tue, Jun 03, 2025 at 08:25:56PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>> +void resctrl_enable_mon_event(enum resctrl_event_id evtid);
>>> +
>>>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>>
>> nit: When code is consistent in name use it is easier to read. 
>> Above there is already resctrl_arch_is_evt_configurable() that uses "evt"
>> as parameter name so naming the new parameter "evt" instead of "evtid"
>> will be much easier on the eye to make clear that this is the "same thing".
>> Also later, when resctrl_is_mbm_event() is moved it will be clean to have
>> it also use "evt" as parameter name and not end up with three different
>> "evtid", "evt",  and "e" for these related functions.
> 
> Should I also clean up existing muddled naming?  

I think that matching code in same area and not making things more messy is
in the scope of this series. Cleaning up resctrl's variable names is not related
to this work. If you instead find that doing this cleanup simplifies your
contribution then you are welcome to add such changes.

Reinette
