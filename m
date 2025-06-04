Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BC46F073
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 23:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749080489; cv=fail; b=GVfeqiMW5PXqMTN1pD7ojqG+LqYDOrFRY6S2YMrIEeHQmxlP0X/96y/ZcRI4eZdYKOEPsDV4lx75r+1ESu0lbafcAzdBioSb/HwdYSRFNQ3uujKH0UcZtYzCmbzexD7zvmwQBX+T0tbrgH8nZkvfdmSY5u6HA7o+hrnITeBay2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749080489; c=relaxed/simple;
	bh=YFl9nnh9+BO3QmgP+eBzjuacjXIT9geGxUcpBXyA1lI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nr21Pz0wTaBnEntu5lYTJ8/I1D+nmn7hQG+3hxwMcD9CM29CwqPp/cI8Qg2CuNZ3kR+5ua8OeCC4Pn5To4ELUksrzd0GTZdANAOwqclbZ0NAQ1anxWJWcLWxv6Cw82qIGARwEZQn2zVGJIVIVqC0XmarVu5Z0Y7uT6HjbR4LzHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XozZKd0x; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XozZKd0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749080487; x=1780616487;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YFl9nnh9+BO3QmgP+eBzjuacjXIT9geGxUcpBXyA1lI=;
  b=XozZKd0xM85D3OnuOUywa9M7hfQ9lQM0K7K4XY+93MooqjjeJGbSwBpr
   NEP6/hrTHi6Sux5tJS+ce568LMk9Oi69fMKiTZRPapSJrpmy72bwNtc2p
   Vj2VbTf/UbGlsWE6hjAlTap7cOzP9sAWs1Cf3qC2T7bzRkeHhXPr1ZD+J
   tdHWXSU1q/u+4nhn3vrbD5P6MEco38A8JIxsf/yiG8Gm6Ilr/K+il0OE4
   ndOTP67HTVDZmyFJMNiAgsOZCM2YJ1sWGH83XcpLYbddLB+OA9nyeuUrQ
   wTZtf8YWzJmhxGp6qRlzaXKMB72gWeaOzMFJH0VsPQusQnh6WjDaQi7G3
   Q==;
X-CSE-ConnectionGUID: 8yRvu35mTvGUcluZeldR3g==
X-CSE-MsgGUID: SntOOku+Q2Gxk7FI4Nm9fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="50299080"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="50299080"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 16:41:26 -0700
X-CSE-ConnectionGUID: s76mMqA4Tq2LJUsSraLRRg==
X-CSE-MsgGUID: oeS+8nuqTSGzwqlrtBVzKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150207957"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 16:41:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 16:41:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 16:41:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.89) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 16:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l7eWAhSW/LgU/5ibA/JUJxb1/xQvIoEDsVaLsLmttc5uI565JnxZkmy+QWVcKz49tIm7ZGe3IEtx/5pPaTf79dXUbsyBtAopFsNpfFBJpcWC3wNf4j6gP5zwGWc6MlNr+HMnstExmZK6gFpQ6i11uzguqQFpNU4JafTMAkbK2Ag0triIVXm2n9BY8zIBxNKtikLixIBYBgehbKX2dxxapQO+w7+Kr/Nf+rYCQByOZjDtkHHvDEhuh18v2uMT5edCRYtYaQoZDmSysX8Tf7b2KcI3QIC7eDgF0m0PwA5o66wicY5AElXGrt4iLKQ8kN1pIe5w85oM79/SyrrvHNqMMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5v6ZRdw5U3I6Aop3caU7oIEI0PPxrZzemPUhPF72NAA=;
 b=ivkiX/tOj2ZYfZSo6pNq9qizFWFGtqwHRzd9D2m/HvWITFukSfoxhOfsPotOuJy3i6ILWjjGDoFcP9uLab9+GZEhlLJ7GuuRVZgoneMf73ff7LJiVQ8essFPp4WqqakBZrKKx1NU5Krc4JNRr0fTiuJV4H5k4+RhHfctIz6NLhZveT+x6TPn92uCoCaN5fvLGMIB7nMVfGGZr1T2fTkC4aw9PMRSadRxWGN6DKuhvMi2o/fhGp2efHFZd3Qk1hUB6OxLdjczr4iX3YoX3oAQTjZpSvHNJIKMSA6L8QwW3+JLkShyRf7XMMBlA/nYGfYg6cngIVJJUSyy+9sFwKNjDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7838.namprd11.prod.outlook.com (2603:10b6:208:402::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 23:40:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 23:40:54 +0000
Message-ID: <a1bb0fda-22ed-4510-b89f-73d5aa07110f@intel.com>
Date: Wed, 4 Jun 2025 16:40:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/29] x86,fs/resctrl: Improve domain type checking
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-7-tony.luck@intel.com>
 <7de291ed-a29b-4768-9b27-7fd9f5602e37@intel.com>
 <aEDPhbwyjzeum_Km@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aEDPhbwyjzeum_Km@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:a03:80::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7838:EE_
X-MS-Office365-Filtering-Correlation-Id: 19b2c9ad-1cd3-40de-582c-08dda3c13f1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXN4cDFpcGdBQStoTXBRMkRMeVZMenhKWm5ZRUJvT3BVTVRPMlp3QnlOUnM0?=
 =?utf-8?B?M3liS2lBKzZEUGZXQzFZdkpxMEhwSE0yTVpVMHVXNUdQQlBBY20vTDU5clc2?=
 =?utf-8?B?bUFPOXdRaDJXSkdrR0FUSko2ejFRa2t2OWV3cmRLcTlhbjVCalRSNUhQMDB3?=
 =?utf-8?B?SFpiU0VrR1kyYm1sOURpb2NxeXB0Wko3Q3huWEpaVmJoOXBPd3IvbHFnOE1U?=
 =?utf-8?B?aktST282NFNPd0FSZkpYMGZiNE44aXdhR1R1L0ExZ1hVRUIyeEl4RlNCU0hj?=
 =?utf-8?B?eGl1OUxrZ1pOakJDN0ZhS29ZR2ZHWnlsVW9tSC9sd1ZuOVh3OHc4d1A4VmdK?=
 =?utf-8?B?QXpYL0U1bEJzRU1Pc0NmOWZ6VHo3NC8yQjJ5RGo0cDlWcXVudEpMdjNPZEFN?=
 =?utf-8?B?NnY3c2p1aEhqT1JicXM4L2k2ZDR5L1h5eDVxV1FGc0dHV21DOWR1alR5aVpa?=
 =?utf-8?B?eHFWVFZPVnVCY0czS2tlekJpbXU1VlhTWDdyZUZhUHFITTdjYStEZm1pdVhM?=
 =?utf-8?B?Z2Nib3pkL09Sc3dSa1N4RDdBYTNKM2FDZ2VYOVVWSW1SWmY0SWsvMFZLMXpw?=
 =?utf-8?B?N0hDQ0FxQlJnSXpNRnlaSkFyWWlNY3ZONzYzOFFaMkE3WjAxUk5md00xNndF?=
 =?utf-8?B?b3Y0RXRZdmptdkduSnBNdU1IQkVMZTdTNjBlNGhHYjZSNTBCWkxiNTdCUFFZ?=
 =?utf-8?B?UkRGZ2ZGdzhweWZTSEpPcDUyWmpxN3ROZmZJZGpNWGpScXFYZzJKQkhrUStS?=
 =?utf-8?B?N01wUGoyRG16c3Z1ZWNoeUNkNlJoUTBqTjVxZWdkV1Uydm03elhNNjdMYnh3?=
 =?utf-8?B?bmZianNXaHdyTkZ1MHBRdXpKS2VBL2VrVVhPcllNUWRGZzdXa2xUQjdYL1Jw?=
 =?utf-8?B?aml2RVQ2UjVkRkMvQkhyRG9CbFUwWXl1cDRGQStzV05sTkJTUTg4Y0U4cGFo?=
 =?utf-8?B?WXJPZzhZclU3WGEvMmRPS2ZyQjZ0YlNkU2lLQ3NZUXJWMmg3aUFJbkticWsx?=
 =?utf-8?B?MC93UldYd3VuS2QzTGVWZmVhcXYzZ1pidzUzUDZLVTJNMDY2N04wRlVoWTRG?=
 =?utf-8?B?OXJUZTdFVC84VlNkcWxOdWp3TW5DQmVlT0Y0ZkVzamFaSnFtckltV2dybGxn?=
 =?utf-8?B?bFk0M0Q3Ulc0R1BLWGRha3pvWUNKY21LeTV0aE5LTXRhRzVQRllKSStoNXVs?=
 =?utf-8?B?MWwwZHZDdUNFZk1TVUdyOWtTUkJyZ3BnMkM4bHR2YlFZdUNHcXFlUzVaa1cx?=
 =?utf-8?B?V3A3MVVkM0tEaXF5VDJHbU5jNGpDNWFTVllWeGlYZTFST0RjSEJqNjRDeENO?=
 =?utf-8?B?RlpaVHdBTkZnWVRqaVZVY3ZRZk80Qm9Tb3JTOURieWo1T1lUWE42VFgzRks2?=
 =?utf-8?B?dmJmWDYrdmV1d3pQRUl2QWtFa0xHazQ4bGVGVzFsMzc3T3JyKzNWSEJqL1N3?=
 =?utf-8?B?UHRJejQ0UlZDcFNrTFhYSEFtV21iODhJbEpEK3ptVDQ5bGY3dUlhNmVTMjVp?=
 =?utf-8?B?dVErQnhnOVEwbXBKNmpBaHIzQU1iZWxDOXZMSHN6VWs0dkRpVG1kQnZSTDFK?=
 =?utf-8?B?WCtRR2tDQ2hna3BCemF2Z3JqUGZuRW02dnF0M1F6Zkh6YzBlelU0K3E3SHFJ?=
 =?utf-8?B?K2dOZjFQWVF4TFNWb0NSVXV6U1VFSjdXTUJYem5BanFwTUd3ZERnNThOaEp5?=
 =?utf-8?B?QVB3SGZ6emtvSkNueXpWZDJwK1J6TU53dzJwUmlvT254WXc4WWw1enZGWVdx?=
 =?utf-8?B?U3lHYk5KUzUvT2ZYb0E3b0c3dzB3R0NOTnRqaGErTU8yWVB2VjYySVh2clBn?=
 =?utf-8?B?RjY3dU93U0JwSlJsNkNGZEhNaWRKN1JTZDNrcXh1aytCSWVDU3FteXVzMFV6?=
 =?utf-8?B?eVY3Yjl2TWhsbUtrTDVZMU96enhpTU5GK3ZBS3hOZWJxSUtIM3pZd0tMMEtp?=
 =?utf-8?Q?Ucq1MwWu6AQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlZRZ3FsZFZXYXZwOE5jMjRUOWpBMUVJR2crNTRVdFp2TjlRYTJNaC8xZ2xr?=
 =?utf-8?B?UXVCN3FKdmp3ejNGTHIzdEdLK1JpVHVNc1VEWXZ6K0FRWU13Z0lSaFdJYmJZ?=
 =?utf-8?B?R1FTa3NNOG9nNnNjZmlMTG1TNkhsaGIxNGFyVmJIdUg1NUVDTnlSQzVwQ1hK?=
 =?utf-8?B?cG0vVzltMVBWdlhEVGtla1RoWkVXWmcvSXg1dEVBWGNzVmhmOHRxcUZ4VWZJ?=
 =?utf-8?B?cC9TKzJkYUdjVHVxdW5YdFlpcTlGTjd4UmZRTVRhZ2k1dWZyQ0dGTnVFZHRM?=
 =?utf-8?B?czNQck1oT25ZSE9VYWVsMCtTMEkvbGthbjVReG9RL0xKbDE1WUlnNGpyM1VI?=
 =?utf-8?B?SVNVdlM2aCtSb1NyNWU5cE9hM1RMczNjYVBES21UeCtNOWdHTEc0clRDVTVx?=
 =?utf-8?B?NWR5TVBCazlLM1lFOSsyUW1NQ0hOcUdkME1rbUFmNWowNWkxeXVteHE2NWNk?=
 =?utf-8?B?c1hIUGJCTmlSVm5LNXUyVVozMmFDMy9FZFR4NkVmWnYyZEp0dU54M2EzMTB0?=
 =?utf-8?B?RUR5QWhTeTRRZzVLT2dJRWtnNlBEeFhkZ01sSm9zUEhZODFwOEZna2lSSkZO?=
 =?utf-8?B?cWRQWU82RVJtNGRXWmtQR0w3WCtjMk5pVjIrM25uMmxBWTFpOUxSYUR6cFNL?=
 =?utf-8?B?aDVtZWZBQ3BOT0MvbGlyaTJkdk81a0tkYVR3OVlZYUdDTjFCc0NhRGVwdnpO?=
 =?utf-8?B?cVUxTDcwWVRuV0xXZTMrcFBzZHVldWZBRmhUL1ZTOFhEcVhpTklCYjAvU2xV?=
 =?utf-8?B?M3FETDh3YjJ4SlZJcVRBRmZWR3l2cjJVblhHeWVVdmpKaWpaVVhvTVNCNXd4?=
 =?utf-8?B?UDl6ZSsycnVkZkZCRTRRRVAyTWtpSk9qSVlnbWpLUzdIVUFsemIzYUdSeFph?=
 =?utf-8?B?K2cyN0xVRU01RDN5M05kZnUxK0dWbE5LNitwVHdxYkhTQkJUQWh3ellLbGRj?=
 =?utf-8?B?a0hIZ3ExL2Zlck5wOXo4RGlmNzlZY3F4L1BGUVJ6TzJjMGRPeU5nclBWbVgr?=
 =?utf-8?B?U0RxOVdZdFBRcU8zVjA4ZkNtYU9OOHhYbmZXSmJzdC9BVmZ4U0c1cktuYXpP?=
 =?utf-8?B?dStEcVNLNVU2RVBCV09ZWCtiK0g1bGMwM0hITjQ0WHFJb3BaRFpROE5VTnlR?=
 =?utf-8?B?MVo3alBqQVJ2b0Y2R1NlTHoyTEJOcnB1SWxpbW9rNlM1REZRNTIxaHc0bHFn?=
 =?utf-8?B?M2F2NzhhRW9KY2EwUFRpZGNrS0pDQ2NZcUVOSTg1M0xldXFiNFlJUkU5S3l5?=
 =?utf-8?B?TExFRk5jT2oxbndSOUJ3QjRFelZyd090K1VzQUJMZGtJRlh4TnBla3NXVVE4?=
 =?utf-8?B?VkpGVmwzYmZaSkFUL0VGVmJUZE1BN2Y2MFdDTkpZNzBrZXR0RWF4Ky9SeXRT?=
 =?utf-8?B?L05OOEdySjFwRW5icXF3Z1o4UHdvUGt5alZmS2pmK0RveWViN1FzRUtiTDZI?=
 =?utf-8?B?K1pta3VlODNXL0NBNFVIRk1kRWQ2VVBpOEo0TjF4UXBNUkFoeWhIcjdaV2Vt?=
 =?utf-8?B?SW8rUkdJaEpHb1d4VWZHd01wbmh0ZjhvdCtaVEt4aVJkRkFUY1VZeWNHaFBm?=
 =?utf-8?B?dks3OGJPRXp6U0pGVkpGUWdONnlrT05nL1NObm9CN0c4T1pRWnl6UnVkYmJU?=
 =?utf-8?B?SnN4WnFYOExTZUg1YThiRVlXck5hekNEWitnd0kvUDdpbDFRNi9WUFNKYWtj?=
 =?utf-8?B?R0lURFFPZEhNQWg3M0hyMFF5blBoakpJdEtkY24zeDgxbUtvQlV0NUtEelNL?=
 =?utf-8?B?NlNvMFhoNm8wSnpwT096cGdMTmdFNFFNOW5JbUdDMDdvdUhUTnVFZlZGYUVj?=
 =?utf-8?B?UGhGalM1Nmw3MFlrbVFmM0RZSmVmZmgzSW51UXB4MVhPbGF0RG5uOGJFQnVx?=
 =?utf-8?B?VkM2Q2hLTE1SZjNLem5JaUFQMkY3VngrQnB5ZytsNGE1SG0rdzVBK1BUYjNj?=
 =?utf-8?B?bTlrdmN1Mzg5NE8vSXQwRHlOaGEzT043STNrZHVzc3dtK1YxcVM4bllad2lt?=
 =?utf-8?B?d1pDR1E3NmJjUEoxVkpYaDg4NGZwSFJwR2Jtc0R2N2lDNEtNaEkrVW5BcGtr?=
 =?utf-8?B?RzFkK3VTaXo1QVN2UkdybmZnVG5iMFh5T0VoY1lvcStIK0VyR2JYQ0NxYXFl?=
 =?utf-8?B?SGJxS3BlbHVFbjNPMVcrV3d5dTM5VFpJdlM2YWdaZ3pERjNIZlZZaTJSYkNs?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b2c9ad-1cd3-40de-582c-08dda3c13f1e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 23:40:54.1257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rnm0KReUKz5ZDaby4O01HaGwbRun8zkm6LRDtHqzXDT7R2xK8+zf3K9XGnBJSzTQYTh8wSZSvjgY06v8C28rj+NXGmcSr6sSLZpRYmholR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7838
X-OriginatorOrg: intel.com

Hi Tony,

On 6/4/25 3:58 PM, Luck, Tony wrote:
> On Tue, Jun 03, 2025 at 08:31:07PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/21/25 3:50 PM, Tony Luck wrote:
>>> The rdt_domain_hdr structure is used in both control and monitor
>>> domain structures to provide common methods for operations such as
>>> adding a CPU to a domain, removing a CPU from a domain, accessing
>>> the mask of all CPUs in a domain.
>>>
>>> The "type" field provides a simple check whether a domain is a
>>> control or monitor domain so that programming errors operating
>>> on domains will be quickly caught.
>>>
>>> To prepare for additional domain types that depend on the rdt_resource
>>> to which they are connected add the resource id into the header
>>> and check that in addition to the type.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  include/linux/resctrl.h            |  9 +++++++++
>>>  arch/x86/kernel/cpu/resctrl/core.c | 10 ++++++----
>>>  fs/resctrl/ctrlmondata.c           |  2 +-
>>>  3 files changed, 16 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>>> index 40f2d0d48d02..d6b09952ef92 100644
>>> --- a/include/linux/resctrl.h
>>> +++ b/include/linux/resctrl.h
>>> @@ -131,15 +131,24 @@ enum resctrl_domain_type {
>>>   * @list:		all instances of this resource
>>>   * @id:			unique id for this instance
>>>   * @type:		type of this instance
>>> + * @rid:		index of resource for this domain
>>>   * @cpu_mask:		which CPUs share this resource
>>>   */
>>>  struct rdt_domain_hdr {
>>>  	struct list_head		list;
>>>  	int				id;
>>>  	enum resctrl_domain_type	type;
>>> +	enum resctrl_res_level		rid;
>>>  	struct cpumask			cpu_mask;
>>>  };
>>>  
>>> +static inline bool domain_header_is_valid(struct rdt_domain_hdr *hdr,
>>> +					  enum resctrl_domain_type type,
>>> +					  enum resctrl_res_level rid)
>>> +{
>>> +	return !WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
>>> +}
>>> +
>>>  /**
>>>   * struct rdt_ctrl_domain - group of CPUs sharing a resctrl control resource
>>>   * @hdr:		common header for different domain types
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index 4403a820db12..4983f6f81218 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -456,7 +456,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>>>  
>>>  	hdr = resctrl_find_domain(&r->ctrl_domains, id, &add_pos);
>>>  	if (hdr) {
>>> -		if (WARN_ON_ONCE(hdr->type != RESCTRL_CTRL_DOMAIN))
>>> +		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>>>  			return;
> 
> This type check was added as part of the split of the rdt_domain
> structure into sepaarte ctrl and mon structures. I think the concern
> was that some code might look at the wrong rdt_resource list and
> try to operate on a ctrl domain structure that is actually a mon
> structure (or vice versa). This felt like a real possibility.
> 
> Extending this to save and check the resource id seemed like a
> natural extension at the time. But I'm starting to doubt the value
> of doing so.
> 
> For this new check to ever fail we would have to somehow add
> a domain for some resource type to a list on a different
> rdt_resource structure. I'm struggling to see how such an

I disagree with this statement. I do not see the failure as related
to the list to which the domain belongs but instead related to how
functions interpret a domain passed to it. There are a couple of functions
that are provided a domain pointer and the function is hardcoded to expect
the domain pointed to to be of a specific type.

For example, rdtgroup_mondata_show() is hardcoded to work with an
L3 resource domain. If my suggestion here is followed then
rdtgroup_mondata_show() would contain the specific check below because
it interprets the domain as belonging to a L3 resource:
	domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)

With the check used as above the current issue would be exposed.

> error could ever occur. Domains are only added to an rdt_resource
> list by one of domain_add_cpu_ctrl() or domain_add_cpu_mon().
> But these same functions are the ones to allocate the domain
> structure and initialize the "d->hdr.id" field a dozen or so
> lines earlier in the function.
> 
> Note that I'm not disputing your comments where my patches
> are still passing a rdt_l3_mon_domain structure down through
> several levels of function calls only to do:
> 
> 	if (r->rid == RDT_RESOURCE_PERF_PKG)
> 		return intel_aet_read_event(d->hdr.id, rmid, eventid, val);
> 
> revealing that it wasn't an rdt_l3_mon_domain at all!
> 
> But these domain_header_is_valid() checks didn't help uncover
> that.

This is not because of the check itself but how it is used in this version
... it essentially gave the check the wrong value to check against.


> Bottom line: I'd like to just keep the "type" check and not
> extend to check the resource id.

Pointers to domains of different types are passed around (irrespective
of the list they belong to) but required to be of particular type
when acted on. The way I see it this check is required if this
design continues. If used correctly in this implementation it will help
to expose those places where L3 domain specific functions are used as
"generic" to operate on PERF_PKG domains. 

Reinette

