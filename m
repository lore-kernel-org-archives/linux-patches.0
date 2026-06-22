Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705DA3CAE74
	for <patches@lists.linux.dev>; Mon, 22 Jun 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782143200; cv=fail; b=J9KT8yj4bJG0wkYCnXy9O8rhbU79PIpM8/wTi26hZLkdl4UieOYnRSzOhfZK62S7I66iQ6mJ4Iy4cHPvwQcN8xyCh59DmQ3Gf+l0bWSsxQWKps8p7MXSc2uYeqkDt09S92pJg6GX2lOUwMrGhezQhoEYkM13alN/r4w1t5YUUEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782143200; c=relaxed/simple;
	bh=k26x/9rmAGuRWDgDgdJ1nmwJ8d9Ew7MLq4l8Qsftfls=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nytXx4H99FqFdD+gNL8eWsNyM+C84UVVoBJRZHO328e212IA5d1e1N32/kbsvBpT+Us5JthRDw0rcsTym3q4eD/WCaEw0ES425+L4BnM3Kk5ZHu0UFI3chtOUDvQNcwa0lGlp0LL+oeP9oDSwU9dRgRszUnz2/y+XXH5TCYePWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L9naxxEn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L9naxxEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782143200; x=1813679200;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k26x/9rmAGuRWDgDgdJ1nmwJ8d9Ew7MLq4l8Qsftfls=;
  b=L9naxxEnWeNw6+dfK6msHEYnnvaottp+1aEqWUwD76qknv/CvQ0G203P
   pmLDYjIcUWBGgnY2Lqn19qYifFQ9mf5m9yM3psMYl0Ij8/UmUJ64b+sEq
   2f3i7q9aDxOkM8X2ND8v5JeljI31dHcxSKa1OMbcr6WVtrA/MPiJQngWJ
   WH2TaCiABtx1FZZa8fnC85VUlVJIGYT2DXxAOHbzfAhYG3QZxrGYb01Op
   zWnSj/gYi18B0AmgRvhWIgH9pHdtSe3uRyfMh2E5xkma91kFiNb9fz5ed
   N2mxbJt7nKaw4SiRMPSadQN7MCbMtjZrr9nVreDizR2X2GyNWfqZ00Dl9
   g==;
X-CSE-ConnectionGUID: 9pdAKNG3Q1OUmQN4Y6or8g==
X-CSE-MsgGUID: ehP72iRFTPyNI+VT6ru7Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="86720240"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="86720240"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 08:46:39 -0700
X-CSE-ConnectionGUID: 8yaOqNfBQsuKPQOHuN6WWg==
X-CSE-MsgGUID: YO8JygDiTcydTv8EqCElXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="251187184"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 08:46:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 08:46:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 22 Jun 2026 08:46:37 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.26) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 08:46:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAZCt41FwUdg8Y/ciSIsM9QQfCV/2JlsU/MOK0CfcAJmnXve1m5ttZbyMnfVTUUNLEccOI0PVKgSMWNPnOvGf6kwiOY8lEmLGStGK1072mDUf9Bl5YBBCnYwu945erxopguzDimqttDf24AS8OfTfYfFnLrdv3TNOWanJWZNLpnrXtVYq0/R0HGI7Bt5LH6hqpZUF3XItnOcbv4l1so7c04mwk4gyHr4Hndxz47iHmlfQKA505j6ZlFCZcYbxMcfauB6O+zg3rQX4AnHjvBUAXTMxlom8jbQ2uh44/Q15g+kpf6TvtgYB8RNbX65pUMcl6x3OO79ofKw8qT2fXt4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NtvWMj/ZXH42ib8N98NTgloO2wTC4EwCsEPleo4n+Hs=;
 b=hnMJCMNFY7DZ2Y1Yff4Eg1mZiKkOTjfcLBVUfVla75iDO1bPpajanjoKzsymDd6N98k2RTRQv4oGOSM2UCeLyZlSSPlhhVLPqmFG/HZnMkn+S4aRbcEU7UHUG3xjUuue0qRivjNNecMWkVqqyUOwr0WgyCZmnuNAHAC+cbIQSEseSR1hoE5Jvgov+9mNe1oU6ziD0hwKax1UITVtLqDMejc+2Fi7Z9JF79TD2o+dOPXhMreiVHe57ZC7QVC945hY/O3qgF8IlebTLSi68690zphnkO79WJu0nSjrIeRXPrgmS7eEohLP3Mat7lC+6XaPbThzTRqBbdSnQOGaZ58odg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Mon, 22 Jun
 2026 15:46:34 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 15:46:33 +0000
Message-ID: <ddc91d49-c861-4737-98ed-9b5d2e583449@intel.com>
Date: Mon, 22 Jun 2026 08:46:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
 <ajRf2P2ChE7SExwO@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ajRf2P2ChE7SExwO@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:303:8d::14) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB8587:EE_
X-MS-Office365-Filtering-Correlation-Id: 3872533b-c345-42fb-1c43-08ded0756f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|3023799007|18002099003|22082099003|11063799006|6133799003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: 2qfgjNgA3J7xEaFS6AEtuKM2U9ijNJHmh/2Y2nSqMIESS5eilKH73vXXKSHi1oVaUe9xNHdYPfX281qHGoBiD0hoxjVHn/JXNAf5Dwz2o0RICBreYwVFy8VNus7Id/XpWr+m0F0vRJFAn2tqvyDkYSpcW/Wmi760F3mywblwNJAr3eZtmq1LtyPGuhnd5UxQrb3rMlguoCF8v79ePKMBtgQaafu/JjFgZx2uCuKm/tRw+InAChcABgQ4z1UG37tnwjtJJ70c+MkGKHa0EqLGK9p9nqANT8bfA4D4feynlZ71RnpyPTvehdVK6saeXXdwtkwoB8H7Jj9e6qGddkJSffL4RyvWnw5FUws9dpbQJG/QZ4oINVIXOLGD2JN7hS4VQiuF0JUr7c6Sa1kW/qd0T4fdRtBUpHHqsvl6zxVYsUq9om0iYS4YqUrSpynMaCFmLuxv6ryq6fpWxGVi3GbISrYN38z84D4E2AXs0kfPH6k133hCM0AzmQFPQS3JVQ9tH2DWuilD009ynRfPgopSQcrVcBSsHYde4Ray1T3u9Sigs7VSktUfUnAYRrdbLBcx50THhqbruL+WXyp/PHOmEarQyfZYEjiFO6cfQX7BKxeLwF1dVFnDMe+yqUgaIpoCAnUue+j8hGbQ00LQYAQsfVeRN7LB87tNXcEkRGAAnKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(3023799007)(18002099003)(22082099003)(11063799006)(6133799003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWhVMlRSUksxckRHOGM0aXdjU2QxNDhPcERZc2s3RVQrdEZoT2JUYSswQnNI?=
 =?utf-8?B?bXJkaVdLUWlhOFdyK3F3bkRmcFZ2SHd5ai9wMDhzMGVhckk0MCtrZjVHYW9O?=
 =?utf-8?B?emduWTNOSWlpQ1pRaUtqU1dPUC9wV3Ztc2hqNVRFdGd2UXMwZFAzNUlRS05H?=
 =?utf-8?B?V1BQWGZTYUUxcUhmQmZvdHlsV0NEL0tkY09XVzNRcDdWT211b3l5ajZhcUtY?=
 =?utf-8?B?b2dTaVNuNnM4Tll1QWlxSUlZQzVRaU5jbTJsRklPWmlyT1VTaFNnazVkOERn?=
 =?utf-8?B?WlV5clYraUFQaGpid0NMZzMvSjE2RVhLdWgrUWlXRlVWUktpckxtNjdvSlZo?=
 =?utf-8?B?THNaSEdsbDgybmNnclExZGpzWTFScThpMkVQaDV1UmxmZGhxYUthaW50ZWxD?=
 =?utf-8?B?b0xZbEdtYWdOK1VyU05YeUxhbmxzbCt3SXBGTWlJd0JOZFVNZ2lCWE1wOXRJ?=
 =?utf-8?B?UDR2UDduY2VONWtFckxoQjZCSnlsSmZQWlpmQ3pVWE9XNE9kN3d5bjBDLzdN?=
 =?utf-8?B?OEVCUGJSVHNXYjN1WFRJa2RZaFpsK2Y2cEpCejBsYWJiOGFieVdnQ2NMYkdC?=
 =?utf-8?B?K3pXZVFXY3hNazdBRWRJTnFxbWw2WmtGWWxuTUpIbzBEYXhNVzhsbmUyNTVG?=
 =?utf-8?B?aEI2WXJiTXRlZEduYXYxNjRjY3ZsWjBzdjZBN25jQzRSVEJHRDFkYjZmejRN?=
 =?utf-8?B?U0VnNjVZWklkQnhIOXBLR1padGZra1VuNktSUXFwWWNHOFRrVGk1eE5QT0Fo?=
 =?utf-8?B?UTUyNzFZOU9QK2FOeDlVY1ZSN1ZId1RuOWxxbGpZd21YejFJYi9XN2d3U2Fz?=
 =?utf-8?B?Z3dTdHFpaUlEa2tDYUZrOFhscUlENGpvMFBlVDJMSEYrZDZuZnV6L3VyZjlT?=
 =?utf-8?B?Z0d0dHFGLzBCbWxVMTNHSHYwbmd1R0NRRmxEa2J0WHJxdjRoWGhkWUt5MDBN?=
 =?utf-8?B?Z0VsV1p3cWRUSU1RZlRBUUFRVnpHWWdLNnNRTTEvMCtZb2xLRmIrdTAzYUFj?=
 =?utf-8?B?bExnVEpjd0d1c3VzMXoxdXZMZUlJcGJFTTBMRHBraWFXcXgydDF0cUhVVTV2?=
 =?utf-8?B?bkc1ZEg2YTE3Z3c2T2lNbnYrWU1LK3RHUU1pWjIvVGNvdE9DMThXNGtsQTVX?=
 =?utf-8?B?Qk9YQ3I3M3FlSVl3eG9JU3NUNURnK05FVFhqZnhndjRYTk5kbFB6RmJaWTNi?=
 =?utf-8?B?QlE5NHVUaFJVWUVlUEZFZWZORk41QnVmS09LMTFkc1BnY0F3c1lQemY1WHho?=
 =?utf-8?B?eHpJL1BZYmdRWVVKVjVsRmJVd3h1Um1ZODBsNjN1M3VyOUM0ZlVMNW4wWEds?=
 =?utf-8?B?ejNxV1M2MU9TZ1Y3bnZ5NVJaVnZ6a0VyM2srWnNXVGY1UGp2Ri9iWXA3SnhN?=
 =?utf-8?B?NmEyR3k0c3BwODA1YXdpc0xsOU5tS0VJbzFLcTdtdnZVUm00bGhiVi9kOHg2?=
 =?utf-8?B?UGRGMWZ0UEZNZ0ZsT1d0MTQ3Tm5hVzg5UHBTSW4yVlVoTnJCN3NYVkFpTDhN?=
 =?utf-8?B?TjBJcDZYY1pnNTB4VmVjTFNSeGg2a3djSVZJRGVnYnFnTVkyRHZQdXNYZW5P?=
 =?utf-8?B?OTY3NWZ6MmlFdUMzLyt5NDNHRENQb3hZNzY0N2EvV29sRWJZQTkzaDdaeVRY?=
 =?utf-8?B?cHhGMHZPQno5YlRKM3lUeElPWUFucG5KT2pEQy9DbncrSWg4bjA2NGxYS3FC?=
 =?utf-8?B?OE15TzBsVTlXeWJLV3JKQW9IcDNFVGE4VnMwKys1N1FyM04zaVZPOFJLRlVu?=
 =?utf-8?B?NDVpNVlCVytxMjh2SWlJcnVzWUtnL0pxSW9RQW1lZHREZ3NhZTJRUnJHd3Zp?=
 =?utf-8?B?OXhLYVF5emhvRndMa2QzcHhOQ2pPVXRScVNiU3RlK0lYT1VZMExUcElDbmdq?=
 =?utf-8?B?Vm9mOGZVbG5qOThPWnVTYzVHZjhsZDdxUVNJekd6MWNOb1duQTZ5UEJpOXdp?=
 =?utf-8?B?dzdmRnUyV0p5L3V0MjRUR3dNL1RiZlBuNklWem96YThzQm8xUEFsKzdHOFN4?=
 =?utf-8?B?ODF0L0FOcXRHUjRWR3NZdjFaUEt3ZHV6WmpNQ1lSclFEVHRUOWdrVWtFTDk2?=
 =?utf-8?B?WmlqQ0dyb2JtZWY0VnJBV0p6a2dWQXVNNDFPSlM1cXhkZDVXV1E3dzJUR3ds?=
 =?utf-8?B?RE1Ba08vRS9ZTGk4MGptai9CWjV4clQ4YUdxWEp1Q1NJenFZakUxWmE3STdX?=
 =?utf-8?B?ODNXS2hNN3FoNHpMc0pYT0RoRVBQVEV3bmdSbEJyTlJrL2twb0xsRldSVUtt?=
 =?utf-8?B?OVhKeDU1TUx6d3Y3dHFOV2JpTURnZEthVXc3R1oxQTROOEpJMGZ0VXpCdE9P?=
 =?utf-8?B?YXpkTXRGQ2M0Ulo1UWtydzRaWkIrbGpCaG5mNk9Ld0cxY0NOb28vbGNLNmFs?=
 =?utf-8?Q?AYxdYF8lQht/0Pak=3D?=
X-Exchange-RoutingPolicyChecked: XCjF6Iap2d+6PyFoCZri/vuwvMAi8Ito6rLU8VpzZBU6qgSxnJLAe+eoI5siFmfpDm9V/H8t8/mxDuzrH5Dp49/widy1xBkUsBIIitlVxksPXL1/UC9DUB3vqXK5V/8BOALMrFRrLygv/hmE4uvIEXFg595yi0zVHbFaRKP4+BL7EMGpqdHOn4B0g/o/hjsepT7csVv3KWLA+H7YCHf7UL2ZTDAE7XyQAqHh7vXXgYJ4LnTbeRFN/dZ6GZHkVta25AKQngQMS9xBv/Q2eS388RKBijbLV3bIUEQPi0riSukGfEKUMgXgzU85NSfmuDly1m2HYT2HJ7vRtchUklj5mA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3872533b-c345-42fb-1c43-08ded0756f76
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 15:46:33.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nginrFlVhxRt59XH4SMVs6QXkm87cLlWPxE8IKrZcxuih5UrJIJtQ+enDdXzTT3ckMg7w5j7SwcimbXE00hIW4mWzjcTxS459NrxcWKLdxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8587
X-OriginatorOrg: intel.com

Hi Tony,

On 6/18/26 2:15 PM, Luck, Tony wrote:
> On Mon, Jun 08, 2026 at 04:22:27PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 6/1/26 12:56 PM, Tony Luck wrote:
>>> INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
>>> call PMT functions directly.  Register the telemetry enumeration function
>>> pointers at pmt_telemetry module init, and unregister them at module exit.
>>
>> To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
>> it be more accurate to register at the end of PMT's .probe() and similarly
>> unregister during .remove()?
> 
> I agreed with this. But on further reflection I'm going to dissent.
> 
> There are multiple devices (at least one per socket). So .probe() is
> called for each. Registering with resctrl at the end of .probe() sets

Thanks for highlighting this.

> up for a race with a mount of the resctrl file system:
> 
> modprobe				mount
> .init()
>  auxiliary_driver_register()
>   .probe() for socket 0 device		rdt_get_tree()
>     intel_aet_register_enumeration()	  resctrl_arch_pre_mount()
>       mutex_lock(aet_register_lock)	    intel_aet_pre_mount()
> 	get_feature = get;		      mutex_lock(aet_register_lock)
> 	...					... blocks ...
>       mutex_unlock(aet_register_lock)
> 						... runs ...
>    .probe() for socket 1 device			Does enumeration with socket 0 complete
> 						but races with socket 1 .probe()

Could you please elaborate the details being the "race with socket 1"? Wouldn't
moving registration to init() experience the same? That is, if registered during init() then
at the time of resctrl mount socket 0's probe could be complete but not socket 1's? The
move to .init() has additional scenario where resctrl mounts when neither socket's
probe has completed.

Are you referring to how user needs to remount resctrl to obtain all of AET that
the doc patch refers to or is the race more serious?
 
> I may keep the unregister call in the .remove() because as soon as the first
> device goes away, resctrl can't usefully run. So it seems a good idea to
> handle that right away.

The "resctrl can't usefully run" is not clear to me since resctrl mount seems to be
ok to let mount succeed without all devices probed (per above). So it is ok to mount
resctrl with partial telemetry enumeration but once all is enumerated this will not
be supported?

> 
> I will provide details on the reason for the asymmetric .init() vs. .remove()
> in the commit comment (and in code).
> 
> Ok?

I seem to be missing a few details to understand this solution.

Reinette
