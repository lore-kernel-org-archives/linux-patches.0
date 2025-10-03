Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE290285058
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505336; cv=fail; b=cFBV00WJMsl2/vW3f0pzK1anhWrc7EK3JNKhv7yY+ltBdaM/H2fbYN+3TgvvnopYOPZZRfYb+7RhuwP6bTUtm4oQmcU9eaTdgFSp/FiJ7g7v7E8s8s1Xl888XKFAaU5al3pbh/+XSvEMv6fGCn3q2WKkYudK0Vnlym+OcTy/R8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505336; c=relaxed/simple;
	bh=UZyXfU9Fz1l0UkADjSHJXD2TriVoGtz5hVpgN1C2obY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eSMsIYbBAOPkJbS0mk2ZR6pl0ood2upawLIFoTe5ul3UuXNeyXECpV9xDEIZ8EWG0W9j3Q3dUdo2EeHF5NjZ3wrywL9/L24CUv2xYrRX9Qwy++P9SkAjqNTB5j7ywCTePTsD/qJYNVwOxi5iVULKKqRyKZjEmF99nzBAXdpK47U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GwyF587N; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GwyF587N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505335; x=1791041335;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UZyXfU9Fz1l0UkADjSHJXD2TriVoGtz5hVpgN1C2obY=;
  b=GwyF587N23S1RlFymRvvSPN89D45NfiWJS3/x6C5ED0TMcpE9YCjXj1n
   ZoFimu26r9rVbrgUanWz6pb205Tq/lHTOPnhiGd+Q8pul/rsiJVo17rKr
   ejhBuh6o3bBsWRzwPMAmlLuhmsnpHIj0a9M31tIO29fvxe6mYDQz0De/o
   fxxqYN6ljgmhrCjd797b83C3OLU3CmSFc0+jofVx1mQwqNrQtLZ3/Sx2G
   /ADVKQbEs9NV/Ucr+OK8N2hxiBeAoyr6YCt8FPy4OfTLB7spDuHUBzlwi
   NxSEI7stcCIlbv4o7a88IBajGOv652y61Gd2+OUhOkrwK0IVCQeRpsdRp
   g==;
X-CSE-ConnectionGUID: 5OGNSiSqQ2Wd2XA+SKgoUQ==
X-CSE-MsgGUID: ad0MvHovRy+TuaSXOK+gkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="79435027"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="79435027"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:28:54 -0700
X-CSE-ConnectionGUID: wukGPcl1RKqi/4Flssy8aQ==
X-CSE-MsgGUID: 4Cb6c4oeSCCx4oTMLuCBBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="209989866"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:28:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:28:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:28:53 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:28:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amNpeKSJDxB7b6060TfVSYCl4OhwlUcMOASMsjh87IoTDA/CRCxYE6svrH62Y1+k2UnFOlp1sTLyA3ZkmmMdU29zaFWIr1usk54rAMx/tNcCheeYs7e6EsFOQ/0mzZnrKdxoj26HieqoWO8EJ7sheNTEnUJujaFhQlJum2Somxvzr1PSAgNUnxsJUCTP8rH4Zf166WNxzn7x7d9ifAZE8lRse7C/aTzAgcE1uetbUqSX5R38QR6IIpfe/vI4I063C9X/oyLDNLVw+V6fmLanHMpdlJbSSXZ0cVqelrK+Od4NlePcb0g+UiyDXM4Hr8GSAtrq6cM8Rpv83GraBNvHQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkWfmRIDBJyq3Uk0y2aszpxee7qerWIzqySJ/h/sCwo=;
 b=W+KQSAyiSRKi006lRkIdIiizPGd+kM4OekDzmdWtA3khdP4a3F1YtMn4toBCT/5QyQQu7zst/IJNCA2jUxyjj+USDUv4RQDTD5CmUMBnuZtlUYJb98eACRiIf8MGnqdcL2hfbpDcod/OE7lrpHEcwuw1FJTsoO/AVCgSi64oJI5XQhXYbmacjOJ4efNIC0daulF7XDI6HqrJ89f9b4o+1vJq7WtN0oHwefXSGz3XaSXXNbMecrefvCBAdZcYnO+g1pugnml5uysYJmsEvR4I2Vvv+3T1HTP2nRWTSWYhj5VhvUXA7F4lhHfW0GkCvbItStC2Gg46V5+AyvCYO/37NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA1PR11MB8796.namprd11.prod.outlook.com (2603:10b6:806:467::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 15:28:47 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:28:46 +0000
Message-ID: <409e3dc7-b122-4979-8a24-b0f0fbc0855f@intel.com>
Date: Fri, 3 Oct 2025 08:28:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/31] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-2-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0150.namprd04.prod.outlook.com
 (2603:10b6:303:84::35) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA1PR11MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ab784e-b28f-44dc-5bb1-08de02918af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N3A0YmVQYWcvbGtTY0t6Sm9vNUJmb0pTVHdZSFhMOHJpTWljUzNuOUJ4Qzdu?=
 =?utf-8?B?Y3dOaGJyWXM3aExpVzJzaWdpYWlNTFBSMURuU2grdzgwa1h3WnNyd0ZJeURC?=
 =?utf-8?B?RHBhTFYvbjFxcCtDcG9WS0JxU0FPbXRlbTNRbnl1RkRXclUwWklSSnZzV24w?=
 =?utf-8?B?MUZKQkdJWDkwT2lTZ25pa01SbWtpdHBVWXpjTEJvcDdwbkwwZVFFZXEvVmZ0?=
 =?utf-8?B?cUV0alB2SXZ4bEVjL2pvejQzSlg3aUduTy9kS29wc3JSbjRheUx4VVNuZWo1?=
 =?utf-8?B?YjVqOTJlZ3JzVGtZZnBqbk1kVUxTVEZYa01CdlpxZS9kNFlNTlF1bjBvWU5J?=
 =?utf-8?B?QlNmUXRqNHdaZlFmcW4wRUUwL01EYjRlQVNiZU55VFhGVkFXMnc4dDJWSHRq?=
 =?utf-8?B?RkhqSWlMcUNIdDBmTGI2NGZ6aCt3Wnh3QndwSHdFMC9xNGk1V0FUZlA2SUp4?=
 =?utf-8?B?WEdCQTFsenU2L2tRcnE3VkRvd3U2Q21udnF4YWFMU1dNT1ExR3BQL0RBVVQ0?=
 =?utf-8?B?bEtMVUdYSk4yYzlLclJsSzQvY1I4OWo1UjhVV05sUXdlQzd6ZW5zR0lFSkhj?=
 =?utf-8?B?d0RkVXp5bU1BUFMzeWIvNk0xNlNBZCtQT2hodVlJVDJxb1pSa3lJNnRkSWVu?=
 =?utf-8?B?SkNKdng5Zmc4dDJNZmZRMWhFbVdDakJBaFd1dVF2NXRlZzN2a09VVThVV2pJ?=
 =?utf-8?B?K3BWR3ZQVWwyZWhDSVE2a3hrQy9Qazlyb2ZSZHFHZ1dRTVRHTzVpb21jakQ5?=
 =?utf-8?B?VERORVdZZFYrTUxDcXJNTHNDUmV1RFovenY2OVRZTVJuZXdQc01MaWpFQ1R3?=
 =?utf-8?B?bHRwamF4R0NJYzUwc2IzV1h5NDd6ZWVOUlI5WVFxSFdrUTR3NHpoMHMwWkpo?=
 =?utf-8?B?NGpjbjc2bDZhQnZpME91QTVST0xSTUxlQjl6dStjWHp5YTdXakMza0x0cUc1?=
 =?utf-8?B?TGswQ3dqUldIcUhhSTllbDU0QVJRTVZINU52UlVqRnI1RmVESTR2d2Y1STQ0?=
 =?utf-8?B?dnhiOFBRYThxSHpITG1GaDJkU0NJbGRtZFVHY3VMY2xWS2F4SlFaRWFQSDJ1?=
 =?utf-8?B?dTl0clJ1RnpCWEkxZkp1UjZvT0J2a1IwQ0tGcnh0ZnJjeHdqMWsyQ1Z1N1BR?=
 =?utf-8?B?M0Y0V0tCRTNJWlhuMjF5U3ZqUkhhSzRDdm8yNmpnUTdSU0pIY2RwMGxDbTFH?=
 =?utf-8?B?NUl5aXlGalJkN3YvKzBLWGNFSXBOVVpDYW5TRW5Pa0R5TDM5UEM5dHNFQ21t?=
 =?utf-8?B?QTRiSFNJUlFUYWUwM2FSRmxrZ1gxZ2lkZjdGdGxOYWFURmxxQUJ5dmVvYkE2?=
 =?utf-8?B?bVFWN3RXQ08wNmlpNStaNllmemxacG9WQ1g2cVZuUTVnY3NnQ2czVWRUNmxo?=
 =?utf-8?B?aTRJUW1oV3d0TVpObjhDbEdFUW9NNHpvN1JsVXNzOW1iOVNuc2U5cVMwTFFV?=
 =?utf-8?B?RWIzaFZxNU1BUnNXOG5ab0NiblRlb2NEQnk0SjNtWGN2N29SS2N5MEMyN3ZK?=
 =?utf-8?B?MDNTVTF2cnk0YVg2VVZia1U0NUJFN0tjNTRmODNQaE1SZ0RDZklNd04xVlcr?=
 =?utf-8?B?ZkNacnNWYzQvczFQa2NCRjRzL3FnUzVyemlHWUQ4VjI2VWYreHk2T0E1K25L?=
 =?utf-8?B?RzdyeGlqd0RqYkFTRWFGcDVrVHUrcmsxRktaZjJ4RWRSWGEzdlB6WUVUN3h2?=
 =?utf-8?B?M2ZzanhuYjBUYmh6QnlJN1ZyNkYxWVNLWVpaVlQzVTUybGJRVmwrR3ptWjIy?=
 =?utf-8?B?S2tlNE90RTU4WW1jVUNKQjdwWWxVM1YwQUc1ZWxWSGE3djlTT215TG93MU44?=
 =?utf-8?B?MnR0UlRkNldyNTlqeG80b3BrYVNvcXprNTJkcytUVlo4UVhRZ3krc04zVGdO?=
 =?utf-8?B?akJuWUZJUzU1RWh6ZjBmald2R0FjVk5MVHBvNUlZOXMzblJYMnBDNDR5QXJl?=
 =?utf-8?B?MW5ITFg0enhIRVZjVmVOWEh3R2NzRmNLNnE2dTIrZzh6S2Q0cXZyWEEzOVZh?=
 =?utf-8?B?Z0M2Z0Y1ZnZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWVFQk0yN2YxTnhEbkNPMUNBRmV1YXRPWWNLT2RzcjJHbHNaV1ZLUi9uR0VF?=
 =?utf-8?B?R1JsK2tibFB3Ky9HZHVSeW4ySEdDYTBHUmdtREJsY1FMK2NoajlZQ0MxZVk3?=
 =?utf-8?B?TzJTa2xUSlBhdWRoaXdqQVhpTWREVGp0Nkw0OGJ0UFVLdXlMVnJRWnozR05n?=
 =?utf-8?B?enRsL2tVU0ZUYlprZFZUUUN2RzY1QVNiR3d6aEhPWUZmRVlUQ003My9SeFl2?=
 =?utf-8?B?UUVuV1hRYnB4NkY2bEM3djdzSWRxQmszVFMyM2ZRY1dyZ1dndjk2aTdqYzlv?=
 =?utf-8?B?ZXBBcnZWR3hpa3VMSnkxbDRiMDZGbitQYkxiK3pLM2ZnUXlmQ3pEZWlUSmtW?=
 =?utf-8?B?c0hXTEpsckp1T1R4bm1XWDlTeU1UdnZaV3hGM05BQ3FJcm9YNjArT3NBZEh0?=
 =?utf-8?B?bHQzTjZmRDh5TlJkMEk1UzdoUUNHK3cySjE2K0tHclJpK3RWWTBra3ZiVFpp?=
 =?utf-8?B?VFJaanFjVlVUM09WMlp2LzJxUVY1QzRrSklXUjZsaVJIaTVFa2h5TXgvaDBm?=
 =?utf-8?B?c08rQnA1Qkk5YUxYcVFnTjVZQWY3NXFGUFBwenJrdXJVZFlteWo0SWVWc013?=
 =?utf-8?B?bW0wQmtObDJrRUFrM1BQNTR6UGpNRXEwRDk3ZW9JMERDYmlrc000Snh0VUt2?=
 =?utf-8?B?OGRJM0F3d3hoeE9Dd1ZsM1ZGdnJwYkFwa1BnQWcwM0NLL2FreEJaTWlETGxt?=
 =?utf-8?B?aTNYVG4xbElLTGhxZU5OdjQ3VVV3bnRyNWpwYnlueHJ1T0JVN2IrYW1vRnFu?=
 =?utf-8?B?TXhMSDVkZ1FseVJ3THhYcVlaUUV3cmRCbnQxL1poWHUzRDF0TU5kUVQwa29R?=
 =?utf-8?B?WURyN3J3SkFUQWh4N1pqVVF6UVFVbk9hdnBCVU44VllsVjR3dnA1Q3djeXd1?=
 =?utf-8?B?anVyN3BiY1RBYUc2NVJraW5vRXpIaVBBamZ1MUovQjRWRjBMMHBTaWFDbE8v?=
 =?utf-8?B?TkdTTjk0c1dtRzdMbGFaNmtJU0xqRFpOb3BzTXVGeTk5S0hJNnlPNzlld2kz?=
 =?utf-8?B?TEJXbmM2OG5zQm95bUFPWTF1WkprSDZ5V0o4ajdwRWNaQ1ovZDhOSWZvSDhL?=
 =?utf-8?B?bUdEaWhJaGg5bitxdVV1UDNBRFd1eVZIM2JyUmdsOUViTDdtYVhPS3pGMzdP?=
 =?utf-8?B?Yit1enliNytUcW5xbFM1OERka1VYTldCTEFaSExTbTluMEhhd3UwdEw5ZGNm?=
 =?utf-8?B?SWxQZ3VOZDVmZFJRcXNHS1lJOS9sbllpbnQ5UDBtaHp6MUN3OTVGQyttV1c5?=
 =?utf-8?B?K3NOUUFNMEwyaXdDeGhhMWxQdnpMRGErSXovVnRUMmFBcUtjUk42Ritzb1I2?=
 =?utf-8?B?OXZ1Q2sralFLdWR3NTNTamN0UkJFUGkxdUFPVzhBTGIvSUg4cmtTSTlVWVVF?=
 =?utf-8?B?VTkxd0hKWnRPcG1rL3lwbWU0WlRpMGFweUhzVm5IWk9IRW4rMTMrYnpjaXZp?=
 =?utf-8?B?RUpFZDlHOTRpUS85SFhGeElZS1h4QnY5WFZCMDNpcStFWFFUL3paTzhmeTRH?=
 =?utf-8?B?RXJXejNLQWNFQi8vZmZ2Z2VacFFwOVdTRXZMUi8xTUhnbVV1Sm90SCtLSUt5?=
 =?utf-8?B?VzRWMkxqdW9YbDdXemN1N2dKa0x6VkVCcXQySXhobDViVFd4VkVMM0hac25l?=
 =?utf-8?B?VXpPQ2lmUHhVaFVmUlJlc1pPQjI0OXo5aWt6U0YvOGpIU3lRU0FNaUk0bXJJ?=
 =?utf-8?B?SlFwNlNPbzlmMk13WVRLdnNIOFJFMDUxQlNpYjFTcmZ5Lzl6Vlpsdnk1RHVl?=
 =?utf-8?B?Yk5QVy9VNFVUQWIvNjBmNG1TSzJXWndkcGFkelI0ZDVIMUp1Z2lyTXIvODZm?=
 =?utf-8?B?MEhNcHlJMnFlbHEzelgyYXdYaGo5MVUyRzFkc3BhZ2M4Ykc4aFNYTFUrTUt0?=
 =?utf-8?B?MmNrWEI0a1ZIbmY5dkpzUFlDaExab0Y0UkVvUFBIdjR2T2Q4c0gxVk1OQno2?=
 =?utf-8?B?U3Ywdnhvb3hvSEFrU1JmRHBWVmszazNvQmNoRUpaanZHbnhrc0w3YW9wTTVh?=
 =?utf-8?B?V2JQS1FkbEc4MXZHQjlrMk9pVm1HNXdITDROWWk1Z2dZSGV0RlhEODN4b3ow?=
 =?utf-8?B?Y0p4VThadkU0UUQxK1Y1NUNyaHV0TTE0NmZ4N2tZU3NNa0paZmhPYlJoMHZy?=
 =?utf-8?B?OGs1ZTNDSTBCRmlkNHhCbncxY245ZFlkUXgvbWhPQW04QXhpWEM4azFmTkE4?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ab784e-b28f-44dc-5bb1-08de02918af0
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:28:45.9535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18aun2Ru3zskhAplwKDtBQFKP8dyodMitD2X+kpafl52slkJok767mU02BeyKC3Ca7ZfZG8v+y8hdeo9JvsHFAWbNbZ5OiJ51OaZhcwQBzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8796
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:02 PM, Tony Luck wrote:
> Each resctrl resource has a list of domain structures. These all begin
> with a common rdt_domain_hdr.
> 
> Improve type checking of these headers by adding the resource id. Add
> domain_header_is_valid() before each call to container_of() to ensure
> the domain is the expected type.

Apart from the "short and sweet" part of the guidance [1] followed in the
changelog above the same guidance concluded with summary (in bold)
that the *why* of the patch should be clear. This changelog is missing
the "why".

Here is an attempt to address that, please feel free to rewrite and improve:
	Every resctrl resource has a list of domain structures. struct rdt_ctrl_domain
	and struct rdt_mon_domain both begin with struct rdt_domain_hdr
	with rdt_domain_hdr::type used in validity checks before accessing
	the domain of a particular type.                                                         
                                                                                
	Add the resource id to struct rdt_domain_hdr in preparation for a new
	monitoring domain structure that will be associated with a new monitoring
	resource. Improve existing domain validity checks with a new helper
	domain_header_is_valid() that checks both domain type and resource id.
	domain_header_is_valid() should be used before every call to container_of()
	that accesses a domain structure.                

[1] https://lore.kernel.org/all/20250923100956.GAaNJx9BYhXKkfNJ71@fat_crate.local/

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette
