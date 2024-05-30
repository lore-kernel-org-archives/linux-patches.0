Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B9158D63
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100707; cv=fail; b=Ob8q1+lhVKvkoqeqbs12y0QsWYeHCjFXmbpxoPy4s6ANjUxGQ5QfUEVMosPM949vMffDXl8P09OOqyxBJFwkIPWVsgc0pndnp3zF+cKSfAwymifGqKKTTyTbqOiTpJDuGLASiJospvgsYZx/9t8Z9nuD/JoRJZphWMX74T82F7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100707; c=relaxed/simple;
	bh=vV5iM9t209dNKYj4Wm3GOCyTR6HY1jI0/3UdlGkW91M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RnU4x41ztsz3RYXP5gD5NgTF7c2a9TZcN8fiejlhWWG2r2McvCudWPoMl3ZJglh7Cf1LhE2RXwhBEtERI6eJWf3XSQMhyZbalcJWI2SANqYeMj6ILJrXRyAB43mh6AK9FabKnUo9sR4ywVrLvvZOmwBCHsQDFV7F0BJ1x7B01Zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WCfOvr60; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WCfOvr60"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100705; x=1748636705;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vV5iM9t209dNKYj4Wm3GOCyTR6HY1jI0/3UdlGkW91M=;
  b=WCfOvr60nfd9cRioezHtyaqQN6oylmvFfBJJ3pRgtkfBOe3M6YeV6kzJ
   DLEMo1cNO2SXKG4VtCxIT+Nqfy+559wZQVH5plQtpVH/rPRrG+W57m++i
   jx2yJK8mJy6FxP4+/lmerbohDgI6/XlCz5JoKDopzVLI++1kWSEpq/Sn3
   lH2AmvqU2u6LcOu538ddLsR+oohxiPuo8XJgnuH6qRiGh1OQKLuUZJHIZ
   iOQw2osDp4REJfph5vwHOH8GkYv+ZFbXvDZSjrXaYocmOnrHWaRRTGFZS
   oR6haGNqD25zbtf11JVjZiUapT6i/DaTj8einu7GatYd05TQRHCO3WFeH
   w==;
X-CSE-ConnectionGUID: uxZ++AIaTaSjA3pwsF+MRg==
X-CSE-MsgGUID: akGYWoiJQMK9xVkVU37YlA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13787570"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13787570"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:25:05 -0700
X-CSE-ConnectionGUID: swckhGpfQHaALmFY1LvsQA==
X-CSE-MsgGUID: gCGRBVGGTPSmcGYZ/G2wNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35975513"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:25:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:25:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:25:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:25:04 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkwRUQfgcwrpbk1889suPUy7OP+Gxzh/Uozy9nlX4S2mnK7F7WIr4skQ4sM+WEVrDJ7VlMJ+fHCUkmbVtLPx+Ki40YobtvnksQMSjrZuTyD/9rkYXkIWZYt0CGvuUWJ/ASXfGDDHdgFCA3JzIeYViGq1qiWQCCyxwtNlnm1cNVtgd/crJK1MnahVSkEjMwRmFw/pOrjJ/CHcK4nHspquGAhO1e+hNCp+7Totn+/zTWb0W0B6nliz0IIJicMpvffEjdVBCeo2FLE292wgYP0EqOdd05UUC1UFncAjfudZoGT0gCRL0zeUpKkAylYMTJyOjs9C/Kpkv1gOsSE5xsp8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0+JW9dmd8Qyee3g7OssjiCWXLEXtJL4+9uKBx+Wixs=;
 b=a0mfjGXtwpHs5jGvOgUl0MITnQsGILVy6xNID4DdVNmxSP16rYAVwnioxwkvlvG/aTSUB3saRc3mDuIAm15PsnwR+Vtev278DD2e5P1HWpvGMfGF+yhl7kaxauKju0X2zT9qJTk/Getd5W+rqHrRsq344heIZTCQDveBuLju0LWYzlWUkB3Bnj0rdO5rql2FnJfpsVCYalVahbwF/dcYKaHZZuoS+m0222a4EI4I6FeqRRFIIURYYnezO3jQ4H/TKroReNby6Vcz4LxGIFd/iDGxsicncjD5sTncOdGRHR9rn/L7B57bHVvUvgqk3ait77iLMT5cICJWFaDz0rMmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6772.namprd11.prod.outlook.com (2603:10b6:510:1b6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 20:25:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:25:00 +0000
Message-ID: <9818c304-9056-4d79-acbe-2b35cb847ecd@intel.com>
Date: Thu, 30 May 2024 13:24:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read()
 handle sum over domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-17-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-17-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:303:83::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e1e514-bc63-4d4e-7bec-08dc80e69461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eTdYV0ZQNHM3cWdhdWZoamZhditFMlIvQ2NOSkJvS0k0RGs0NVRORGwyNnZw?=
 =?utf-8?B?ekhmOFFDSHc2ZGgxMWl2TlQwV1N0VER2T2NOaFV0eGQ1OHpEUldZbVBmWjZH?=
 =?utf-8?B?UVVqRklXK0ltYVJDVWhmUGV2SlMxTjdKcXJyaVhQT2ZNSDRvSUp4MHhHdzVh?=
 =?utf-8?B?T083d2ZPTVNOTkZoMkUxcVViUWk0eEQzUjRaZ2hLeHkxdmF6UGRCZUY1WlY2?=
 =?utf-8?B?VjlCUHV3NzhyaXFLZHduRmJOcXRQdXZNQVR3dXhIZFByMnVtaVlLSnJrRW9R?=
 =?utf-8?B?RTlBRTJrVlQ3UmcwZzk5eHpZK1dLclJ4aStYeU51UlVOdWswaTI0ZmEzNU0v?=
 =?utf-8?B?dGFLT2pBNHUxNnNYbW1DbUlwdGRSNzEvdXBSNjdlYStVekJvK21GZXByWVA1?=
 =?utf-8?B?bDJIemQzOXF2UVRUTjJVMWczZWlXT09xYXloUmxJdGptdWV3eVI0NFBUSCtn?=
 =?utf-8?B?WDQyZnk3dE5DWEZ3QzdoU3dSTVZoTE5Wa3Zkb1E2SnFYQTJZNHBGMUNWTWlj?=
 =?utf-8?B?WVdEMG1lWGdTZkZTK0I1b254ZEFDdTU3NlMvZGJveU15SFJIL1lSbithbWR0?=
 =?utf-8?B?NnpSTWVFREVoQUxPU2tUMWNNUHA3dE9xY1U3eS9LRDI4N2dhQlpLc285KzF4?=
 =?utf-8?B?cnNSM3VWTmI1bk5FNUd4a2lQWVd5UXFKK3lsRzdiWHdkeThlcVNrenp6M2hX?=
 =?utf-8?B?MHRGNTFuYm9oS3lHOHNLVVp1ZXdmUk44SlJRUW5VWjRoUzlhbDFWSk1vYkJQ?=
 =?utf-8?B?Nm1GQ2dGSzhXdWJRYXA0SlJJOFlvZno5OXRtbXhURUt4RURwTG5ld2hTbzd4?=
 =?utf-8?B?dUFWejFHeWxvNlY4YWJtMXZnTzR6WUgrTzdxVG8zZFJyamJKMUc2Tzh3YUFL?=
 =?utf-8?B?YVpxT0xIVU43UWsxc0pkYysrNUxmQ29OUHFFZlJsMDhtNzI4YjYxN0hPQTA4?=
 =?utf-8?B?SFZod2plYnE1UkpZOXBWRzRPdWZjdGVRYlczZUdFQjk4RkI4YnlaZy9WOVZP?=
 =?utf-8?B?TzRaSHVHTEhESDZpWXU5NHVUR0ZnajI3eXdvc3JSVUM5MTRqUTA0eVhreXdx?=
 =?utf-8?B?bEhHOEkwZUdXQ0tScG1iTmRTSDIvOVVyeHZ5eFJyYm9zY3JzSjR4TEZ3UW5t?=
 =?utf-8?B?WDVWRXRxRmhPLzIvUm53TmRwUGw5NWwwNGtQQzFOWmQ5ZlpXVmRibTlmN1FY?=
 =?utf-8?B?cS9ZMStIcE9aTnRQUEtXZ096UXJjc3hOL21jeXVuMU8xeks4NDdxeitWelhU?=
 =?utf-8?B?TGRPeG13YXYzc01yNFJaR3V2ZkRTVFYzRGNIdlNSZ0VOY1o4QkY4QzBoQ3pS?=
 =?utf-8?B?RkxlMzNleWJ4YmNnM3FWZkxtbnU4TFQ2RjNzem9CL003Nmt3TXV5T0Z1RDdv?=
 =?utf-8?B?RXc1QlJlTDIzNjRWS1lEK1paZ3crSmFtSEZxeGNheStxc0x1eWNYUTgwMm5L?=
 =?utf-8?B?T3hjaVc0YW1PSENrb0lCUXBPVDFJYmZlWGQ3b04yR0dSZnJad3ZnQ3VQNWRI?=
 =?utf-8?B?OHdrY0UyNkRKTkNXOUphUTA3akZpQm1GNDQvRFZKQTlrSGZubjFCMHN0d1Jn?=
 =?utf-8?B?YWNmanBOZHBDYndOSzh3dU1uRGJPWXkwWmhlSENxSWZzYU9zUDBJVGRYc3pq?=
 =?utf-8?B?blhkZldWZnowaGFIS01yRVJCTjJ3ZEp0VGtlb3RBcjkyMXEwbi90bXZER1BY?=
 =?utf-8?B?MHB3WWJzVHlCNStZcmxPdjlHMEt6UlFHaWFtRnZ1b0ZXMjE2RXluTE9nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDdtdUwvL2o0SUwxanpvdlREUmFjLzlvQklRY2cvQzRraGJqcktMaHNDbFIv?=
 =?utf-8?B?c2NRUFNtZkdWY3pnc2Q4UFpkSlZNNWdMQzcyS3IxenU5Lzhwd1NjRlBZdGlo?=
 =?utf-8?B?NGhJei8zZjcwOFBxTU1Wd1h0VE52OG9nWk9oWXNvOTR1ZHMrazVPSU9KYzgz?=
 =?utf-8?B?UUtHZ21RRlJiZ1dJZ2dMQzhML1Y4bWdjS21MK2xNSUh6bUMzWXluTUlPWWRj?=
 =?utf-8?B?Yi9za1dzK1dBYmJxRGVKNXB6Y1RuR3crbmUwejRKZm9GdTREaTRIL2ZjZ0Zu?=
 =?utf-8?B?ei9SUmpGZjVYTCtFbmxHNUw3aU0xblZVNGxWZjJYNDcvRENMVG5iWXhYYUJZ?=
 =?utf-8?B?SElrT25RUUxYZDJuWVdyQ2RPa0JpM2dPSTFaUjVCV2gxeFBHUkNHejZ3bnNR?=
 =?utf-8?B?bTlvTEtxekRmSXRtVnppQ25qUzUzUHIyMENRTlV4UVdMbS80UVBLYlY2ejBz?=
 =?utf-8?B?eCtlRkYvQ3Z1cFZZUWlKUEtsWlBEYXllR2hSL0RDM0ZML0Z1Y0tMZE84NTRO?=
 =?utf-8?B?cnpPdW5XTWlpUmNLU0FzZFR3R0dNbjhSNURUZzJYbyt0aUhRUTNxMGFsMytD?=
 =?utf-8?B?NTNJMVhiQW83YWxmalp4UFRmTHpZSEZJWGlsaXR4YjBwVlpVelZvVjRxZVpj?=
 =?utf-8?B?ZzZGYUk5RmlpWFZWWjNqTElYY21ua1E4Q09HamdXNysvT1l0TFpWNENiSGo5?=
 =?utf-8?B?WjVUZERQUzZid0pha0FucmNpbzJlQk5xclUwanFnTmRUUlIxbUlwWUV5TkEw?=
 =?utf-8?B?N3RHUWFHYWVHRkx4VUIxaG5ERlNOeWFCcmVUT1BaSVNjWk9UalAyKys4WWYv?=
 =?utf-8?B?enlYWGZOTE1IT1hVMlB1V0tZRW4xcUVXWHVESTQ4UUQ3TmpSWmo4OUpHR0xu?=
 =?utf-8?B?Q3gvM1hjcmpOK1ZjbmRhT0tINjVjd0VUTEJYUCtxNlVxbXFtL2M4VUk1VGxx?=
 =?utf-8?B?a2pjZU15ak1VLzFkaXVaUHZsSzgzWWdNZkxYRnJIb01TRkN1SjlWSWkwRGpR?=
 =?utf-8?B?R3JSWEhOZ21IM2RlQUtkb1dqdEhtMnBmMWw5MWxzWDFmdTVxVW1UZlVYSjl6?=
 =?utf-8?B?T0JXcXVFUUJsKzF2dFJPVGVpUHFNQXJhaks1MFZVWkxBTFJsL0s1aUdlWmhW?=
 =?utf-8?B?aXlsL01qVjJpK0lDOEpkOGtiNFBpODFpNWNQdDIrcDJSMXRKYmdORzRJMGU3?=
 =?utf-8?B?OVhIZHNmL2NTdSt1b2RnSGZTQ3VZdnhpWDNzYWxZazZCTUZTYUtLU2VPb0VF?=
 =?utf-8?B?QTBtZUJZS0Z2YUdaYnlZUTNFOGJCakc5dHk1dFlBaDFjV1dJTGpVVUM4cG5x?=
 =?utf-8?B?YXVRT0k2NkpvYm5XOUl2T3oyNmFWWVRaaGpKdjJ4Q3grOGJvVTZKQzFMUFlv?=
 =?utf-8?B?b3RvN1JGNFdTV0gvZnUyb1JTNlB2THdFR1hXL3RwdS85MlBYcTIvZ0NGbHgy?=
 =?utf-8?B?UkppeXB1Y3Z2STlzY1drbldQaDBqZzIyYnV1cnUwR1NvR2tFNEs4Vm8yOGZz?=
 =?utf-8?B?V3FLaGdrRlRrdytGZkJiaWFlV3lmQnBGU0J1OWJCc0JaanZhbTl2M21hUTFU?=
 =?utf-8?B?b2RFelRTM3lIOHo0Q0VndTl1Ump6MEdSbFZ4dWxCWkhHM0NVTzZKcndTQ1Iv?=
 =?utf-8?B?ZXcyWDJaNk1Qc2Z3aHRhcG9iMUJ5bVNkcUI4VXdqckNRa3haaGdycFBKWnM2?=
 =?utf-8?B?K0JPelgxT2xmUWxPdjZiWVJBdVR1Vm1HcUZsbGh0b0hrQ2NSSjd2cENLa2t5?=
 =?utf-8?B?M24xQXdGOE1HcEtCNGpRdVlxUHBiUEgvdysyM1UyQTZHMGd0dHR1cE9Wa3E0?=
 =?utf-8?B?bFcrZVlzMDJ3eVJadGduY3JzKzQ2RXZpdDZ1Z3RrZUpVMEYzVHd3dkxtcUxj?=
 =?utf-8?B?YXZzbzdCTGJKRnlYMmRncUhxQUozTUx1dnBUeERRVnNKdHFWMW9QTGU1aExY?=
 =?utf-8?B?THVZTUtIMGdRWUFqZ2xMK1N0REtjbnAzOWZJK2ZTeHYwanhqZ0dtbWYrWmp0?=
 =?utf-8?B?T1ZMam1Cd3RtcWhuK25Da1AyaHd5dm05WE5xU0hqWWE0MW1DZEJjVXUrTk92?=
 =?utf-8?B?WDlsaUtwZWxiZEhuSFJDb3JaaDMyN1VkNWwxbTB5MHlsQndNS0JGR2pIT2VY?=
 =?utf-8?B?N0xWY3dnWDVSRS8rclFxRHdHYWRmeFdweGZpUnV1RmRXeFlPQytlZ3VOY29S?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e1e514-bc63-4d4e-7bec-08dc80e69461
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:25:00.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pK1YgnHMFiG4yIIeWWOqUj6hAWGK/dhuTpiPtqbaVlRlzWxMUo/fljEQ9IdeOJ2Twu5YPkylOzB0mnai8ckl77mbGr9KzmURUccbd/jNXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6772
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:20 PM, Tony Luck wrote:
> Legacy resctrl monitor files must provide the sum of event values across
> all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.
> 
> Rename the existing resctrl_arch_rmid_read() function as
> resctrl_arch_rmid_read_one() (with some small refactoring to drop
> arguments that are not needed.

Missing closing ")".

> 
> Create a new resctrl_arch_rmid_read() that iterates across
> domains when necessary. Pass a CPU number from the right domain to
> resctrl_arch_rmid_read_one().

"when necessary"? Can you elaborate?
"Pass a CPU ..." that just describes code that can be learned from patch.
Please describe the changes not the code.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 41 ++++++++++++++++++++-------
>   1 file changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 5f89ed4823ee..c9dd6ec68fcd 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -200,10 +200,9 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>    * Caller is responsible to make sure execution running on a CPU in
>    * the domain to be read.
>    */
> -static int logical_rmid_to_physical_rmid(int lrmid)
> +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
>   {
>   	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> -	int cpu = smp_processor_id();
>   
>   	if (snc_nodes_per_l3_cache  == 1)
>   		return lrmid;
> @@ -211,13 +210,13 @@ static int logical_rmid_to_physical_rmid(int lrmid)
>   	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
>   }
>   
> -static int __rmid_read(u32 lrmid,
> +static int __rmid_read(int cpu, u32 lrmid,
>   		       enum resctrl_event_id eventid, u64 *val)
>   {
>   	u64 msr_val;
>   	int prmid;
>   
> -	prmid = logical_rmid_to_physical_rmid(lrmid);
> +	prmid = logical_rmid_to_physical_rmid(cpu, lrmid);
>   	/*

Passing CPU as parameter to __rmid_read(), which is run via IPI, really
obfuscates the code. How about renaming it to "__rmid_read_phys()"
and provide it the "physical RMID" as parameter to make it clear what it is
doing?
That would mean an extra call to determine "physical RMID" before calling
__rmid_read_phys() but making it clear that it needs a physical RMID should
help to explain what is going on.


>   	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
>   	 * with a valid event code for supported resource type and the bits
> @@ -269,7 +268,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   		memset(am, 0, sizeof(*am));
>   
>   		/* Record any initial, non-zero count value. */
> -		__rmid_read(rmid, eventid, &am->prev_msr);
> +		__rmid_read(smp_processor_id(), rmid, eventid, &am->prev_msr);
>   	}
>   }
>   
> @@ -298,9 +297,8 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
>   	return chunks >> shift;
>   }
>   
> -int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> -			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
> -			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
> +static int resctrl_arch_rmid_read_one(struct rdt_resource *r, struct rdt_mon_domain *d,
> +				      int cpu, u32 rmid, enum resctrl_event_id eventid, u64 *val)
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> @@ -313,7 +311,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>   		return -EINVAL;
>   
> -	ret = __rmid_read(rmid, eventid, &msr_val);
> +	ret = __rmid_read(cpu, rmid, eventid, &msr_val);
>   	if (ret)
>   		return ret;
>   
> @@ -327,7 +325,30 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   		chunks = msr_val;
>   	}
>   
> -	*val = chunks * hw_res->mon_scale;
> +	*val += chunks * hw_res->mon_scale;

The various new layers of indirection with SNC logic scattered between them
makes this change hard to understand.

> +
> +	return 0;
> +}
> +
> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> +			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
> +			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)

This is not architecture specific code.

> +{
> +	int cpu = smp_processor_id();
> +	int ret;
> +
> +	*val = 0;
> +	if (!sum)
> +		return resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
> +

	/* SNC quirk that needs to be documented */

> +	list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +		if (d->ci->id != ci->id)
> +			continue;
> +		cpu = cpumask_any(&d->hdr.cpu_mask);
> +		ret = resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);

The cpu parameter can be dropped, no? With the domain provided to resctrl_arch_rmid_read_one()
it is not necessary to again split the SNC logic (in this case the "reading from any CPU
in the cache domain is ok but still need accurate arch state") across multiple layers,
just contain this in (documented portion of) resctrl_arch_rmid_read_one().

> +		if (ret)
> +			return ret;
> +	}
>   
>   	return 0;
>   }

Reinette
