Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3755A329E79
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776899849; cv=fail; b=TDVSFb1dwUtJH+K3Rr2hg3XHSn1h/G1t8LlbNTGmImsY48h58AzZeO90xHodOaK4jf9zBZykXdiQ9gzSDJOXvcuXyqL3MXu0c6+25qucjnhfyOLr7g2TjCI/peJWAEAZzxsNyZ7p5cMkKtyCAvXWRFG8hJJMBLowsdvMWacxuY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776899849; c=relaxed/simple;
	bh=CwKwfl6RDJPQecMlK+PTdnbDc0AMMWAdaIPpS51ZaKk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ERXnOuEMeSNXsLAd56m8f5AzIxBIKEJo94w7nQD2QqMJdw6Jw0ndRl6RyvSViaKYOYT9DelyWYT5PYGamL6cAtgiHYzhidCYN90Q1DomvVmmNfwsWUh1TUvgVywIjXtMIy7qoAYVlESQytZR96lfRrHsyZ9zNV1Sp8oSXOY7or0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbx6y+Qr; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbx6y+Qr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776899848; x=1808435848;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CwKwfl6RDJPQecMlK+PTdnbDc0AMMWAdaIPpS51ZaKk=;
  b=nbx6y+QrQI0Y+D1heNM2hQ7O6SfTAdBKAChTJuqnn4PIpd/kk2sBsoUe
   ITJ+2PBvLTBdNVF6ae6NRcjldJFx0bxCk4Yo28l4NusUgUEclS5SZ/oU0
   ru7ofrDUhtps7xl+maAJrw1weckXC61sfCMjtP5DwpWs552zqP9sG1syE
   JN586WOojHoEcq1T9IsZFLa0qctXLGo8+dp7MYyYZWx2EGXiHLyhK+QBa
   zTLy0H3HPvDzucSTmjmlunOftw/C97yzEuxOsNYaMvqX7L22wpqgTBBnB
   lb3vDGjhAqKJQr/DRHh6SPXuImALgRmZKhqnn9M7piNmZlTujYrdslVIR
   g==;
X-CSE-ConnectionGUID: tfE3kxLjQgWfxRNJijRMKA==
X-CSE-MsgGUID: 7Nqjk0BWRXitMhePpJAE4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="88472689"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="88472689"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 16:17:27 -0700
X-CSE-ConnectionGUID: /W35EEhLRBmm/En4FAsGxg==
X-CSE-MsgGUID: DXofCdFGQHOicIN9u8ullw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="231441454"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 16:17:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 16:17:27 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 16:17:27 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 16:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ASTz1X/4JFcSC6cRqFJScpFvQDzoxuqzVOw0DIfPZSzDRIaRR1FNAL8+F3psmUOFsxFoprfj9uFRQF0NlF0vA9SnPHtF9fuQTd6qyEi05r0rlmHtQEiuBW38Z4UXKTIYGL37dsIltas+YuTikoXvOCpJsK9k+lTT9oHHVewQANSpvTCGtEiFbVTiIk/nK9xy7PeXV0M635+uhEWlBWfxztluyfNB/Q9IncGcuSbVmH7P2m885nA01eUDognP35cKP3iabpbWl3yBbBGi6UURTrQKtA3Ckwwb3oevdzXDXNQhBeVnCa9pBvqOgEZtwLL4Da3AnknmqDVckdaVOuVo7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZT3LqgxAn9anY17RR+F07x+jvPiyoc8PSJGb26odXww=;
 b=NVvf6ZjG0hFUfFK323BKG2bGoJXrOcXoDLuTLn2UI5ZjpCwCUEAM8sm6kIdqGRaftKjRrgi2d/ri5z8Vn8JLTipAjryrH48diphMI2iQlme0RqAaFgyUFKJYrLkcb/Ntbrz2OJMSExIbymcaFYGDAEy02t3xs6D9F+Cl4AR27LqkAcbKliCUAGsJ/V2/3FYeA46/E/2g9zRmP++TKSIQFB7+Qf55bpdHubDqZgk03wuE+MQrmTPDFFf+xTrSyLy9orqLEKT0rX9twc+u8TJLlhFOHE68DxbqbRjNDEA3NPQOsYUCcW5hLWPWYCnNIE22Gn7kDCu6CqqDMmvM01Ugew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6418.namprd11.prod.outlook.com (2603:10b6:208:3aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 23:17:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9846.014; Wed, 22 Apr 2026
 23:17:23 +0000
Message-ID: <99cf6fd7-fb9c-4988-9278-ba369213e7a3@intel.com>
Date: Wed, 22 Apr 2026 16:17:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
 <SJ1PR11MB608330351CC00D65341CF6F0FC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB608330351CC00D65341CF6F0FC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0321.namprd04.prod.outlook.com
 (2603:10b6:303:82::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 951e230b-3338-4015-b8a1-08dea0c54f71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 7mTH0n7xtpfVtJ1AyVwCvK0WelkFRsXPETFbSZsN/BbO3EVA340ve4i3pvoSjCWrrl6litbtsv/9/80Fwslh++kwjBvcDMXXrC3JUXMrTz4PPv2YOthjfk4F3WNRiMmjYIJr6w2DAqLer50pL4FSSMEJ9+q8XNapF/FbZkejg+MZuCesl7ar3UDgUuGjcpgfdGq9hNyJ56PT8jKh3xqhK8GEHhC0z7BeMrYNa0umbv0PIJKeGrOsFcbxDQbNiFm91u2PxfxgrtgfoiRxS1td3TC2aVQL0g4yeFICMiTws0vqP2LPIGdsm6eBNLbXWBExof9SPwwme4Repq2QV7yzouMnMgyNNC4HDHp6urb9z4jMFM5y7lHOp7/f+qzzMD3ydiKmqAMh1KmssB0GWSqWoj8JyaatJ9Owk3RDLQK+dCKqDfLMFgHd2oI8BYotR+OjHqQAZPaZq0fQmhjn5Gs4bM5ZSFUti8hzq3fxo4Geaped810vzhatqHfQpHOPcVZ4m1sPLWDsUCf3wMktgLDYzbKhfQpjt2d2iBM1n6MkeiPDk77hp0YYSz+s+ZyqWrlG8fRVn1cOWjZed2wi/Y1yWbkWwPOHjGkLkZkEQFyNvBl6DAUi2+2ArZAaNe2j2sIgWTnJD+VU/e9NcSN+fJFKAWOVGMLnFQKsj2LxvR2BhLAgQU5D735yW4yB0UoLPA15PnHPV8O2h2HKW8hRxyIX69kXHX2awPyXZ+CRDFmGGgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUdYREZBeEhXU1pvekFMYVRueDVpQzJLY3BwSk9HbGpIaGlwWjRad0RGMGk4?=
 =?utf-8?B?c3NaSVV2VGxqdkR1QjZGdXI4VWs1MjVLa3dhTjhrUFNHdjFiOC8xZ2xUOEdQ?=
 =?utf-8?B?U0dOSUF3bWhLWk9QK01Qa1hyVVY5eHdNUUR4UWFIMkZId2VZWjFWd0pKeTFj?=
 =?utf-8?B?MGxYdlZIZzZzM1hQKytyRmJybVI5TXpXaTJtZVZUN1AxT0laRG1sUXZTRDYw?=
 =?utf-8?B?OFBHaTBtVXRhK3BmU0hndzlZY0lMaXJZblY5b3l4MDY3eXZqQ2pnVDFva3ZG?=
 =?utf-8?B?bXI0Vjczem9vUndsNWtLenZUcHFXN2tGYnozRmthWUFyKzVidElZYkJVMXlo?=
 =?utf-8?B?YjlFc2k1Rm5aTVluQTUxNC9mR2htOEJEWEt2Z1dNSk1ZREltMnRDMVdnUTFE?=
 =?utf-8?B?TE9COTJ5bnRwdklHVk1taHdOTTB2QjkvbkxXOW91M0NyRlFFRGhxU3NuaHM4?=
 =?utf-8?B?UXIyVkdXM2dIcUQyWUNjemQ4aG42YzdyaEZDdjkveXJPSTBLMEJDUGpBMjd3?=
 =?utf-8?B?YjlvV2RNNmVoS3JSS3RUblhpYzNxUFNoV1hPTW9DQTZPZ3g0MzFCK0dSaDhV?=
 =?utf-8?B?azU5V2s1Z0YrY0xoZlREUFVOdXo1VXZjSGJaYXpUVkwvUU4xR1dEOGdhL0I0?=
 =?utf-8?B?ZWkzYVl6VmQzeFJqRVZ0Q1ZnQnNaNTJqRFFoN1BtWnlqbVdNRTlIUXJmSnZU?=
 =?utf-8?B?dklnZ3ltWWlqSlBXVDNXbXlSUlFRZEZ6eW40N0N3Q1VPT1lnUzM0KzdHYjFv?=
 =?utf-8?B?M0hvaWpaeE5paHVpdEgrczlIeGRpSFNKMFlzazdVMTdCb3BvblFhcFo0OGNy?=
 =?utf-8?B?WjlZRElzQmZSWVBTR0NDbEkwZkxjNGw3OFRNUmFHZ2lOeE8xVWc5YnpDTm9x?=
 =?utf-8?B?eWFtdjByb081VWxob0FORWhwNGpEamgvU3h0bUprK0l0TW5XMUpwMGVpdDU1?=
 =?utf-8?B?MUd3M0NMQzVLQ0tqaDV6SGJQaGRkd3VUQ25nLzJjRGpvK1lwK0xzSzBtUHFF?=
 =?utf-8?B?NlI2OHNDMHFROE9OVmlTa3ZYQnZEejVmYlJVL21lQ09nd2VNdlY2bmFKMVRK?=
 =?utf-8?B?Z3VGOHdqQWNMUm9FZzZqZTJ3R0Z1bklJOHlkSGwzV2Y4NVR0ZkFjcXI5OWVm?=
 =?utf-8?B?S2EyWlY2M1NYNkVTQmZ6Sk1lKzJGeTRyZWZrT3UvVlZHQmxUYXZ2UGtBM1JR?=
 =?utf-8?B?ZXlVKzYrMWQ3RVZNNGE4Qml0SFE0YlUyUkZieXd4YlVwTzFuNnczZjhDalZy?=
 =?utf-8?B?Q2l6S29GaDZKMm55Ni9qcWk5UnhkQnAxZUppWXA5dVZSWEVWQk1DTnNLK0pu?=
 =?utf-8?B?eTBGS3NXT0w4WUJSSVZVa0VLSERlMWhiRTRGQmpOTmV1OXRIWnlqUFoyc281?=
 =?utf-8?B?d0ljU2ZiOFdSSEw5clc1VW0vTGFHenVVd25BeUtDczNMN3ZvVnpXR2Z3b00r?=
 =?utf-8?B?dWZFa1ArR1pGNXlUK1BpdHJ3RFdlbitsTzVRRXRyQ0RZUkZlRTZhU3RnM0d5?=
 =?utf-8?B?QytqMHZNTlpmL2xMSXpndkxGK0pwNTRLTmp1ejJiTVBod0EyWDhOUTEzbkRj?=
 =?utf-8?B?aWFpWWRJUkNLOE9yZmltdWsraDdQS1FWODY4QWxjVjl6ZDNCOEhhcHdOWHZJ?=
 =?utf-8?B?OG9WQ1pnWkM3QVFqcmhGMm5mMCtLYTY1cjVqVVJxN21CamtndS82U2JzMFZ2?=
 =?utf-8?B?QUVMZytGcTRCci8za0hoTDkrWTFLOEY1Y1NjQnNIRnhjdWx3eGcvUjY5eVVz?=
 =?utf-8?B?aDFibS9Sc0w0S0pBWWF6dzdjcGVhRG5GRVg5MTQyY3EvNlZYeUZkQm5La09Z?=
 =?utf-8?B?aGhucnpvUTA1YXNDQ3RnMFJDYm1jb2E4NzJOeWRZS3FmMzlXM0thaFIzOUQy?=
 =?utf-8?B?cVBVdTR5S0QvZC9yQUFzNGFwL3VLd1FGaTcyZGxzSnh4MXgwSjRWTjF4Wm1x?=
 =?utf-8?B?TUI3Q0JpR1Rtb2tyc3ppcmo0Y2cxV1B5R0Z1WGQ0a20rZzRRTWtHZkVqZ0J4?=
 =?utf-8?B?WjlpQkVVRjRIV0IzYXdpb3VXckhwTGsxazZFMVFYY3haNUk3SnREUUZ0dzFC?=
 =?utf-8?B?eWZWaVRDQVZNOHZDUVlSenFUSkFuZmVwREN4MEdkSXNOdFhrRFdYTzNGd0dz?=
 =?utf-8?B?MmtSZkFQWnYyamVxcmxrWUxaTnZBTmRMWmJnemZ6YjU4ZDkvMWkzMDliL2Vs?=
 =?utf-8?B?V0R4VXp3eUNXQ1lSSGxPaCtybFdMOVNyR1c4MFluUEQybm8yRm5GUmxvdkg2?=
 =?utf-8?B?U1JKQ3dNZDkweE5nTG5XbCtTNVQwQy93aUJUd2ttM3QzTEQzcFBrZHJobGJy?=
 =?utf-8?B?R3B4b05lM1p0Yjg2TmE3RWtBNTM0cjRwOEgrblQxdHBoNm83Z2kycVlZYjJM?=
 =?utf-8?Q?Ks0R0/QVXiQz8U1Q=3D?=
X-Exchange-RoutingPolicyChecked: UXDGZgjPD1PEBKZ8mps5EUjG2YC+I3u4qtH7GBGWCCm2NikpSXYZOeb1vpa9MmgeTjNO2xpPa+04++RA9dM6UGL01Z+WdB/JUCP/0XeeK1QLaIUeTLCTTuB240YMxqhXrK0xnurAE6+mmoxzNVXTn53UOfqrIE5hdCAakMMiI2Fy7JDQSK0LT1iZfuW6Gy4bcN9PL98Z6+gX2v0p3ZE/RV2F/fSSLshm7cLIdKSsdaQPSvsM1trR7jQXRXE656/Oy4nUaqigb+TaG6+poL9ep8kdZTsMsD0SHSFQ46uDlCtkHE1rD3mI/8f2aWysy4l3t719mTNQIGDPfbWAXH5AVg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 951e230b-3338-4015-b8a1-08dea0c54f71
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 23:17:23.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEVlqRPqsIEgIAlHUTYhCfxjJcL/0wByXMrKWqmA3Tc8AjlXeaxQ3cR+e6nzoRmbVjkKvBJJi83QTkDlEJwZk8es9NJid7CQeUQ9AfHUC50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6418
X-OriginatorOrg: intel.com

Hi Tony,

On 4/22/26 3:44 PM, Luck, Tony wrote:
>> I think I am missing something here since I have been assuming all along
>> that intel_pmt_put_feature_group() is and will continue to be called from the
>> new unmount handler.
> 
> My problem is not with unmount. It is with resctrl_arch_pre_mount().
> 
> With no locks held, I can't tell whether this is a genuine attempt to mount,
> or a doomed-to-fail attempt to remount. There could be arbitrarily many
> parallel calls to resctrl_arch_pre_mount() leading to races that I find hard
> to handle.
> 
> In my earlier attempts to deal with this I acquired a lock in resctrl_arch_pre_mount()
> and held until the resctrl_arch_mount_result() call from filesystem.
> 
> This seemed complex, and so I moved the locking to the file system, and here
> we are today.

I am not able to decipher the issues you are facing since your response here
deleted my responses to your questions on how I think this can be handled. If you
find that my proposal to do this without an additional lock has flaws then please
do point them out instead of ignoring them. 

Reinette 
