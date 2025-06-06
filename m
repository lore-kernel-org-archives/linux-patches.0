Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D58289343
	for <patches@lists.linux.dev>; Fri,  6 Jun 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749229036; cv=fail; b=u5OzAjIu+5SXjocvADdyeGV4zy+7ATzvfxb+BAF5UE5xgkw1GTBNtNSZYXomuFu+Bi3338C2jz1oeJOqffG2IciHKf2P5gQ+VnJhom9ot9fveOZDFzbyZ9dZkxpXFZHuj7by2M3LahAJx8r5P/x82yaAc3aMxYdZZOBWbeOQpWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749229036; c=relaxed/simple;
	bh=o4ATKNEEQsXjc66L5VCOE5XOBCuJzsa0oY9ZYKJPqIM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dmBZQK272zKtuTfnoSurIydZwouJD/SLNuA17dxFqtnO6mTLZg1iKlou87VddkmxGWAjI8y4H7HnkOgKF68Dc6YoaYIIFL1wgvs1GOCzLEX4lDqe5h+9JTNpcqF1xZp5+PbusCYUIvyrtUWMFqi6DFHlgGnYkSRDGGIPdYDQCQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAQbUQ9+; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAQbUQ9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749229035; x=1780765035;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o4ATKNEEQsXjc66L5VCOE5XOBCuJzsa0oY9ZYKJPqIM=;
  b=XAQbUQ9+wwsmNIJt0c4qZX/twJN/Ngom0Di0CGZuAoHYyfPiiA84CWRJ
   u3DY53SNKpPh7w7RbaFEh5N0d7OOp4m5wiG2IdiLP9wT+x7gktWkoIdoh
   HF6wSEW7DjgDm2D5lMSY19xoFvMDc4gNmIbhSg0HA8KVjwW/CyxIOcl59
   I+/yUnaHsuYKACJZlaQIclVkdWAmljYP2hAexYq3tg/ZX//OhR8O817cI
   9qECiqxXw36pMLCsXWdksawpbKsYDLzawWY+yCrdh3tc11ous3axupcZR
   boLaEWIM2jazUljyUlkpyxAnKOTY6WVx/ZFJH+JcHZ+MNbrUZELb0ailx
   g==;
X-CSE-ConnectionGUID: yKEIyetGSjeHzl2JBWcXkA==
X-CSE-MsgGUID: JMTEsORERdePdH4uOBY6cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="54015380"
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="54015380"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 09:56:30 -0700
X-CSE-ConnectionGUID: C+ojGLRATBSZYcUhnY8CgA==
X-CSE-MsgGUID: 32SOo4hgRV+T7ze6Yvqi8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="146847149"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 09:56:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 09:56:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 09:56:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.65) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 6 Jun 2025 09:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MlFLOk675cJ/XsBzBAN3CluR0mb5kEhWbcc0Wjr8x4Y1L1OZFmDezcpG2I4jQo24Ouur8P9AecRYSW12qBpMHCyzF7jPcx783UFJSDrK7iNS/2MDIrGDzPj4H2ZIC5qm1f0KAOxluFbXOoueEJD4gSYEI8jQGjQzpLfmW8scriHDpGZH5Jd+sUpXk77I4Fl7Uv00pWL/cr62mgwExlYku+N9gStsIAtI6iOLhdzwaaw7aOdXo1Hzzs0GytyXVvyl7ahHk3iGr4tjZ3MhWMwszC+RqNlsG1vwktwoPLXTx9aroS06uqLtM3IKETtawdHeKIC3HVozfAxtFNTKOaHUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Q8PoeNGh4miPe6R3VYescVYxux58LKeJ+qyT7H5/LU=;
 b=V9a2O0xmb9YmUHr6ODD48UFvZALPeMhjBn3dVxqr2um/ZZI23bt9nsJtPAIf0ezkK/ecK6+4k95D3MxRWxr/5ZEZXb0XnUpY+VdAzA3S74+27uRiDVfQrJbogfnClR5nFWH6amr2rd6lnDBzTRjfUY2KbL2mgOXIax5lIaOl7CL4uUwK3kqVOVlNjS5Td1rOhVAmgH4okTEH8tvwssgw4ijy2/Hi51IRXjNcxn9x2cf36Xlgleo/Q8jaAoujn8XPkCLEc5c5/zX/4MkaTr3a1p+nwiGCoHfSeb9uvxGErpoFW4jvSF82uakAC+9bRoEp2XsdJKp2ucJ8pXDZhXh4Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF1611BC49E.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::812) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Fri, 6 Jun
 2025 16:56:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 16:56:27 +0000
Message-ID: <7d4c739b-3fe2-43e2-9771-6137f15b42f1@intel.com>
Date: Fri, 6 Jun 2025 09:56:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/29] x86,fs/resctrl: Support binary fixed point event
 counters
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-15-tony.luck@intel.com>
 <f368c506-c479-4e8b-a5c6-b9bc5bcd5674@intel.com>
 <aEMWhMbLpImmMBrL@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aEMWhMbLpImmMBrL@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:40::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF1611BC49E:EE_
X-MS-Office365-Filtering-Correlation-Id: bf9292a4-c76c-4c1c-abcf-08dda51b13d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RFJGV1dmUEJaUEdaZ2hoVHNZVWE2b3Y3UkRBYk1HL0hxM1U0cVBVZVl1VGZl?=
 =?utf-8?B?LzZTVnk2UHZsd2EreU1BTzQ5WGxmTkc2ZVhLODJ1Rm52TmNVclBEbVRlSFdi?=
 =?utf-8?B?MHBuY0lKY1RZdFUyb0s0YTV3S0R3ZTI2VkxYaXh5Nld2bW1ET0VtdlE1eDJw?=
 =?utf-8?B?bTcxWVF4ZE1SZWhaWDdnWWRrSXRKTzVYVVRpTkxJL2xaZ0hRdndyUDJGTE0x?=
 =?utf-8?B?TU5rMllsSmhGN0c1b1BlNTNNeEZacXpNWEVWc2IzdSs1WnMyd1huRmxrQUNU?=
 =?utf-8?B?bk1mOG54QjlmdCtwaGN3K0tNd2hPQ1YwT2dINEpHQ0d2NkltSHJxbHlwRXox?=
 =?utf-8?B?akVGa1ZQcXhyWW9LUjZZZ1dkdjlpb21wamRnWTJ5RmY1WjFpTDhnMUF6TUJC?=
 =?utf-8?B?bGcrOE1SUlA5SnZYQU1uY3dEYkhoQ2hiYlVxZWdvUWEzempaYjJ1K3NyRlha?=
 =?utf-8?B?RjVZUzAzT0R0TDFjZlR0dE9neXEydFYwZzgxSXFSMDlwTVFSOUZZK1dCSG1h?=
 =?utf-8?B?TTlqY212SVdSMVJHTHJPNmJ4M1lCaThFaTIzUzR1ZXE4NDFHZS91Q2hwbWpi?=
 =?utf-8?B?ZXkxbkN1WkhjL3RySHpaSDVyaTdRYWpERnI0N28zQlVDTjFCd2w1bXV5Qmx3?=
 =?utf-8?B?L216MkREWVRxTU9MUFJyQXpBdC95MU94cVdmajVTZDRVUzB3ZmhxTU1FY3k5?=
 =?utf-8?B?R0ZCcUNqRGppUW9xbG1WWlBqeEt5VmdhN0VPTStRNmdUcThNNHhUbnR3YWl1?=
 =?utf-8?B?cU4xcVMzckJPN2hEUE12K1hHREd6Q1FGYlZoeU5KZ2o4U0tYWjhlMm83M094?=
 =?utf-8?B?dGVUSytlcjRxYWV4azh6ZE8weGRheWRHZy94WGErN1gwandzQkoxc0E2NUZL?=
 =?utf-8?B?WTUyUWRmZ3NTUmRjUGMyUGxYS2gxNlFZallIMTN5TnJXZmorLytrSTdaSzZv?=
 =?utf-8?B?TVhBb0Y3K08zK2VrNGIrUS9teTV5VEFobGltbzFuME1aOTY1MXdaS2JjbXlq?=
 =?utf-8?B?ZzhUL2hhTFk2RWwzZ25rbVRxTzNNc2t1eXV4U0VOYkQzUkFwdmE0NWdzOS9X?=
 =?utf-8?B?cmkzM0Z1dVhCV2l5N3gvbEljYWZjLzRvNTQyTk5jR0JCWVIxb1RJTnVucHVG?=
 =?utf-8?B?VEwxWUYzd1BSM00zQUFTQTFEWVNmWDdCQ3R3N21lRnRpZWRYNWxCN0JRc3N2?=
 =?utf-8?B?Sy9TOVFGV0xmcVZNNTFBdVdWN3RkS2tiS1BVR1E5LzNmOG9yUGNINVVrZjFp?=
 =?utf-8?B?NEY1U3Bvd1ZuVWFUbW45VFFSSXhlY3RZMzFzL3BKZ1BBTE9TVWthazlhTVNz?=
 =?utf-8?B?WnBka24ycHlqUXlOK2QvZ2txQUtrNlY1OHdRZ21yNk1pZktsZUxCd1l1RjVV?=
 =?utf-8?B?Tm5aTXhKZ1FUalVCd3dUMzFrSm44cERIUFNzQm9yQVhzRDBkRGtCZ3JsY3Ns?=
 =?utf-8?B?bEhsSlorRGpzcGhDZlE2MzE1MTIxKy9QbmIwdUpSTjFubjgwUWhGYW5wdVpF?=
 =?utf-8?B?V2ZqT1hTVjlTa2dmVlRMaEJya1RjWlpyVVFCeW4vQStBbzdJNjVENkY2WXhm?=
 =?utf-8?B?NjhOWnY1aUs0NHd5Vi8ydERjdG5tOXE3WjFqZWUyUHFJZjM5S3g2ZUZEYjhq?=
 =?utf-8?B?clRDd3ZONUpuV29tREFiVDVPRnI2UUZjOXU3aFdLT2Q3WXBQQWUyTlg2aDNE?=
 =?utf-8?B?Qm1MQTFjTmlSb291V2gxUHRkN0pkUzJFS01pMUlBRWtNNko0LzZnVkFHc0o3?=
 =?utf-8?B?dmRCenF2TG5lRjY2SnhHUkVVSFZiRkNtNWIyQ2ZjS0ZVbTUxU3MzYkY0endr?=
 =?utf-8?B?WlZHNjliaFRIV09LVk1udFNnWlFDb2xKMnZMamJMdkhSeHNvb3RDeGZQeGYr?=
 =?utf-8?B?MkpxTHd2Vk9LOEZhZjVWMnltK3RXYThzcjdueGcyTmlyUVF2ZEV5eUFBRFpF?=
 =?utf-8?Q?1m5+uEAFy8Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uklhb0NLL042SFJ2b0tEc0JUR1lTNUtXL1RZcURna2dsVks0ZkgwTFZQWXhM?=
 =?utf-8?B?K0lWd1JtUmRoYmowcHAwQlliUkF6QlN6MXN1RnJielNnL3JKejFKMEtqY0dp?=
 =?utf-8?B?bFcyeEtES0lMMVY4MzVBNXlsZVZUMk1ZRTFkeFM0czdDR1VBeElNRXVmbHdo?=
 =?utf-8?B?WmNPak0zdFN2VzBHUU1ja2o5MkxKTlJ3NURVS0lIZ1dudnlZNHdUK2lRcDVn?=
 =?utf-8?B?VVNLb3kwOCsxMHJKM0ZhV1RETjlNeTlMMVlxYjREL2lNeHNDSldreCtVUmhq?=
 =?utf-8?B?OHYycGU3UVI5T1JUN05ZTU8vNHBObWZOdlFTbHIyWEtGdG85dUgyN0g1NW9T?=
 =?utf-8?B?WmYzVFZZZlJmSWtpbVRDYm9mSWsxKzd5WDhBK1h0M0w3MEZDZ1UzSUR6T2ZS?=
 =?utf-8?B?RGFYMjF0enJrem9GUHlEVm90VDNGTm1UZHJ3Y2RHRmpnbm9GVTNaSmg5Nmd6?=
 =?utf-8?B?T1doU29HZkxBT05mNzdIQ0pBN3BOUFA1bFhRdndVeUJCWTFBTkdaSFh0UUtw?=
 =?utf-8?B?SmxOQk82WGdDbXVONU5JeWxXa0hOeWxrMFFHSzlkbmUxS2pJSzdBQkpkWHRT?=
 =?utf-8?B?ZzRrQXIrOEZwNDhSY3JUdGRnbXFLZmlqc2UxWkVjcEV6UzVtMWhyQlR2WWF3?=
 =?utf-8?B?YXFYZlh5RWNBZEt3eGwwdFNaNW5wYlVoZ3ljUE5xOXhJQWNFMFlvZVVzNElz?=
 =?utf-8?B?SnUyYW9KYVMraC9DVWUvOEMwKzZGV3FuQzJLa1I0dzl0bE1kdkRoSkxQcXNH?=
 =?utf-8?B?L3NEUjVwSlRWcjBxMjU2SlFWVFBGNHhIQnlrMXZlS0lBclFXQWRDbDJER1lF?=
 =?utf-8?B?N2xPT3RLMnppVEY1Z1VLUHVoNlozUS91Y1JZVnp5ekFpZTl1R0puVHRNKzA5?=
 =?utf-8?B?K1B2NzBpMGd3YXk0T0dVYnV6b0tvamFvTlpmYjRidVAva2QxZGd2MzdVSnRZ?=
 =?utf-8?B?b3o4UGs0NS83MkxLNUJvMkpJNXBzQkhvZlNKcEhFSmJkQmRUOWJCS3kyZ2Ix?=
 =?utf-8?B?L2tGUWZFaFRuWXV0OVNSTmQ1T2VzenJVZEM5eXRkcEdBeGlocFdFMHZwdzcx?=
 =?utf-8?B?eWlaK2taNGNYS0VCREpsT1o2ZVhXRUVVVEVRZ21ySDdFeTZrQjlIU3NSTXF3?=
 =?utf-8?B?bnF3NE5NeEpxdnBsYlVHYmVTb3FUSHV2YXo4VkMvSjIzS3pkbXRENnlUWllR?=
 =?utf-8?B?RHFtV0lSWHByQjlVenFWc0lXeGNZcHZOMUJhZjNBZmg2RXNZeFlPRDZnbWdr?=
 =?utf-8?B?YUxGRlR1RG5sUUFRWDVGc1JvSW0zbkRsSXQvNk0xUmk2cC91Vk1ERlRVQU1W?=
 =?utf-8?B?S1RINWRCak1CZ095cWtTNGdnSEdkWUNZbkthaTE1eS84SFd5QS9KVXVHbDNl?=
 =?utf-8?B?endlMlQ4VGwzdU00cFBEVk5XNGxnaDd2aXBKdFplcVVvQUFXbGxHQTIxYkNP?=
 =?utf-8?B?clQ2Q1dWSEVXNDYzc2NzS0I2NUFYKy9XVE1MYUhYVmpsdkdKNHFyVnA5RWRp?=
 =?utf-8?B?KzRlQ3BVREphTDQyYzBaeXJCaU56SVJnaHd2eW9lNE5ROTNTdXFRUnIxZWVJ?=
 =?utf-8?B?RkhYZ3ZyOWdkOEJTVHdoa3IxSDJXU2RUTUpuRE5qLzI3UjNYL0pMaVJvc1Jn?=
 =?utf-8?B?cmJmeUtubG0rVnVHN01vSmdPK0ljYzhoNGtoWXBSTDdrWFVoQXg3amoxenor?=
 =?utf-8?B?ZEVCMWg3dUoyU25LRDVzYmhRK1hzS0hWai8xbzlsc3lBZmxpSml0cGlrdkZJ?=
 =?utf-8?B?dFBsSjFjOWVaMkNoUGtzRFZ1VU13cENsV0YvQk9qNHd4MlpybjV0QmcyUWN3?=
 =?utf-8?B?aWE4N29kMFVhRGFIc2U0T3U5SlM5KzBOcGlPVlJRSVY0UFVoWnVnaEdDSk9m?=
 =?utf-8?B?YUJoMXRxNnJrNlVjMGtIdnljMlYwZHZFSWNkdVJiUTJuOHFJaFJWVDg3SVBN?=
 =?utf-8?B?MDduQ09odWFtSFNrTXlqNkZGTzB2SjdjUU1CQUhZN3VicVU4VWJJampkaGdG?=
 =?utf-8?B?bU54RW94VWN1VEsxNHo1YStaelh0YzNyRXFDV0lRSU1sdUdWbXZrL0h4NGhE?=
 =?utf-8?B?VEhKY1BNU0kycFg0bHhRaVB2dVJtU0ZZZ3V3RW96ckNoRmNrM0krYllLdzdW?=
 =?utf-8?B?azY2UElPR2h4YXR4TTFOVU55bVgydVRlcUp1b2lWK0VJdk9tUldWZUZsWmh3?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9292a4-c76c-4c1c-abcf-08dda51b13d4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 16:56:27.3055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9EPcsMbf//vZqhbPKgHqknNofDfx4WX5imYSUQZPUYzTgFOu7Iw2iTs7h/kOXOijLy1a8vm9yetNfoLmgq7ecq83X++hIebxldDTL/g25M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1611BC49E
X-OriginatorOrg: intel.com

Hi Tony,

On 6/6/25 9:25 AM, Luck, Tony wrote:
> On Tue, Jun 03, 2025 at 08:49:08PM -0700, Reinette Chatre wrote:
>>> +	sprintf(buf, "%0*llu", fp->decplaces, frac);
>>
>> I'm a bit confused here. I see fp->decplaces as the field width and the "0" indicates
>> that the value is zero padded on the _left_. I interpret this to mean that, for example,
>> if the value of frac is 42 then it will be printed as "0042". The fraction's value is modified
>> (it is printed as "0.0042") and there are no trailing zeroes to remove. What am I missing?
> 
> An example may help. Suppose architecture is providing 18 binary place
> numbers, and delivers the value 0x60000 to be displayed. With 18 binary
> places filesystem chooses 6 decimal places (I'll document the rationale
> for this choice in comments in next version). In binary the value looks
> like this:
> 
> 	integer	binary_places
> 	1	100000000000000000
> 
> Running through my algorithm will end with "frac" = 500000 (decimal).
> 
> Thus there are *trailing* zeroes. The value should be displayed as
> "1.5" not as "1.500000".

Instead of a counter example, could you please make it obvious through
the algorithm description and/or explanation of decimal place choice how
"frac" is guaranteed to never be smaller than "decplaces"?

Reinette
