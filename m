Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11278155389
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761193694; cv=fail; b=dtmzyYiTSZ6VzUmcPZi86dam09WbyIvk7ogkX7zO2UINptZvkKFvnN0eIbrPqV+yb96eE6j7ea2d5VZIEeCZKVzx1neAdjU/FDrWWF9jBT7EdlSUKhVZ+HQ2ZUeKj0i9LTyzFhrMMvhK4zDd1r3KLZKhK2NBN4MFA9zKENI+eSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761193694; c=relaxed/simple;
	bh=Yc+2jCtLX74aYJ0PoHQXj8MV1GUbWiNQsydyPZu3lW8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gVkcqA4jh6KsbQVQezCOQBTqsXWEm61QrSr53Ef2oXcmbs7jV8zHsekRKAalM6z1KVayro+G8vbRMkwhlkFlAFjBiYUoccKcDvHhy+8KnpLmUginuveMsW4FO9ADNIiHGsPFqIw/42R5dhDbWeX/YlJjPR0PrbTdFvSrFdB/gws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ne64cnqq; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ne64cnqq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761193692; x=1792729692;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yc+2jCtLX74aYJ0PoHQXj8MV1GUbWiNQsydyPZu3lW8=;
  b=Ne64cnqqUsksWUFAZ2B+Y5QLP6r5Fxen6+KpRoPDs3pdOSP6vvP428Jt
   Mn9eeta1nRuCc3n0ex77FdFt2KemGUbLCXZ0mNpopNF0qDBXfMDd6JPZy
   XtA6JksFvzotdeQV5MdzJQ1nS5ZGU6AmKGpviNWWwiu2m7sZHkXLALxCo
   eiOv7qiwHMQG1EYmmj0VIUjwjCnRUmKdgrKLE9DOCNxtjnEEIy7xmf29e
   i+3BpyjaRh7QZ3h/8DDv82WuaVSaXCCowfWw3xVZg8Y5e6PnutnCUlrI5
   5onuXCV1kdiWhY0A1SCibfs/ecs1W1+heKf3mT0izv/UaBCFTTtCtiyyD
   Q==;
X-CSE-ConnectionGUID: hCB5sepXSU+mvP6Hd8fEgg==
X-CSE-MsgGUID: OPlJMczST9+kEiQ1RnKyhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80980487"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="80980487"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:28:11 -0700
X-CSE-ConnectionGUID: 9CmS00WwSX+16y9s0gIlcw==
X-CSE-MsgGUID: hG5l6S2bQ/u9zkizlBz6Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="184112351"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:28:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:28:10 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:28:10 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.68)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:28:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRwbwRc+6x9/xn9s85sdPMKA6wE99rY0Cw8N5pdPoknl+WzboVz8cokNe39tFyqGHj31d49B6JZQpeVSZq/00NuT9+79G6KoFfSpmQNNY445r3PNI+KPXhoxEkMLNJ1o/F6Ym6QoGp448vRJUMmVY900Uq1I1UU9Q4+vRvDhK6orQGQc98/ZWESdYaJJ9MxPCVVJP1ooFiT0kKCCqCGtUD37CXEUh5fxpQbf3KGAUr1b+7Ngw7hc+0JXjEladSCv+CYQRhlXa+O9xXpynh/Yl35Pi/iHYX/9xQiv5I+wZvZg6xEzOGeZTxqHkPf8tFlW+HIBiRvMWC3mgIRZIKdXmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hctFw8Y0Q5G0/eRKCjbN4vyWRiflkvLKT0qhMOnfq/0=;
 b=YtnoVqU3ME6AAV9+ywKUTPTooF3H6Ka+aO3jG+0QqNo1vc+OZ7wbDO6W3hBIQqw4423giedpQBJSU/gEtWEjE25fi6IPyekPEI8D0iz8SndSmxGWQJ3ZfhxvShnhnluCuANy93iN4PSdNdCHWP4PyKrgpU6ZfSgWNbKUtZb0Ledm+mON6tMe0y6ibegLASomfbtLqLDN5vP1FKyjwYToA8jMq7oVFOl0zJa0e30mlnnyUsWMJK53LTCTNN7nY67RYKPF2dtoT1B6hg2EVU9X6kW378PokqpgPbCfVGDdX97ljNco0ZCZz5W55E1pW1zNPDPpKMGwUaR8UU66Ba74mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8408.namprd11.prod.outlook.com (2603:10b6:930:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 23 Oct
 2025 04:28:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:28:07 +0000
Message-ID: <fad9fc6f-98b2-4ea6-aa47-ddb26e66f5b0@intel.com>
Date: Wed, 22 Oct 2025 21:28:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 14/31] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0158.namprd03.prod.outlook.com
 (2603:10b6:303:8d::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c12e0c2-7c72-434d-1238-08de11ec90ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bXBGdEtLdXk3c2ZKeXNzY216WXF1aFQ0anBQS1Y3dzVEQ2ZObHBEQWpNTzJr?=
 =?utf-8?B?TXU2Y0dzUzVTdDNaclBhaEEzZGNZOWg3d1Iyam43Z3RCc3M1bDlkbmw4Q1Bt?=
 =?utf-8?B?WHY5R3k5enRIVFBrdW9iTlRQaHFtZXNyRWt3Y25ma1VscUJxUVQ5ZVVjWXZY?=
 =?utf-8?B?TUlEdXlGQVNobXRkVk0yLyt2bmh6WXlTTWovWGtqNVVHUVRLSTFvZllvNVNM?=
 =?utf-8?B?ZXYzRkJxSzEvZnlwVDJzSUQ4QXE5OGRHRWFzdXhkVTJ3ajhyRENxbGx0WGh5?=
 =?utf-8?B?Sk80a1lkb1dIYUFzUVUwRmVIMW5US3BENTRWVkQwMUdYaUpPSU9QbEhGU29w?=
 =?utf-8?B?MnNmb1VTN20rZE85ZlZVUHZqNGR3VXRUd096dGJaQjNzNU51SjFMZUlsNWVI?=
 =?utf-8?B?WEZwQS9ZaUVQQmx4WWRqUENCRi9XaXMxNGZtaU9VSXlveXBWYWxQM2ZkOVNR?=
 =?utf-8?B?RXR3SUd0Q0NoaWUvQ1hmN3UvbXlVTUljcTNCSWpnZnRRem9HNVhiR3pjNzNU?=
 =?utf-8?B?bDdDUG9wZHE4c0U0bnhpN2hsUnJ4S0pWenM4SXREZXZHd0tvVFB1UlNYR09S?=
 =?utf-8?B?aFNCL1pudC9yL0VnSFhveG5Nd3hKOTVXbXN2N3oxWEFvaEhvTlRpNVh4aWY1?=
 =?utf-8?B?Q3RkMmFGNHltekpvOUFGWUt5N01GTDdxYUNrR2djdTFEblJzQnhZU3JtTmRs?=
 =?utf-8?B?eWZjOHNEeWtkbFl5M055Z1JHSWJCRENTMWtxeDF1Nk1uN1IxOUgrcWwrZndo?=
 =?utf-8?B?bytOalZtckdxN055TXNFWjdMVFpTQmljcURkWUZGN25xL1JLQzZ0L00xQ09x?=
 =?utf-8?B?OUlyVDRFdFE1VWw2MlpZNjRPK1NEbVVKNDRVYWo5b3dpenhPRHRjVWl0L0dJ?=
 =?utf-8?B?WXgxTTdxdmk1bzlzYWg5aEJJT3ZneVYxcElmcjJ1d041RkZhRnhRbXp3aERW?=
 =?utf-8?B?UmN4MTAxVmFrZWM3Z29RSlBKbUp2OXhaVC94Mm1TbndVVUtvcWlhd25ldjZs?=
 =?utf-8?B?MVlFellBSzNNMksyVlQ2Q29LTm5mdEpuSWZ0SVExcHhXeHlFWlJqU2pHQURW?=
 =?utf-8?B?SlIrb011VmlkS1d4UUd5cU5HZDFTeUxJeEJySm1oZkhmSm5NQzQxb3FiWHlS?=
 =?utf-8?B?aGtSbUQ1aUZHRjBWVk16SVFOOEt3ZFdKTjZmZmt2dlRYRXNVcmZFSVlXMTlp?=
 =?utf-8?B?cXJSZldFYjNYS2FVNlU0MjIwVnkyOEJ3RDY4b0xqRXB2aHpOcnE1WWxvazd4?=
 =?utf-8?B?eFlCUG51ajBZQXIxT09wRG14VGlPTzJqU0tYeWl4U3NzWUZwTXpBR3pBbGVk?=
 =?utf-8?B?UHF3WnBWZTczWHdXU3NYUUNKNnJFL1orTzFwbi9TNU5xc3lDRzQ1b0ZhZ1BS?=
 =?utf-8?B?L1lWcW9FelljS1JZd1dNQWdTSEVZM1pqZzlORVBXNnpVT2lZZXY4S25uZmxW?=
 =?utf-8?B?ZTM3Rnh4bTloU0NNNERGWGZLN0F1STAveW42NTlPZnh1aHVDWnlWcDhoV29L?=
 =?utf-8?B?V2h5VUdPWkRnK0o0bGc4djBBa0t5RFhtWHRCdEFUME9FVlhodldZd0JRSHRE?=
 =?utf-8?B?YnV4dGo4MndzNHdsOG5OcHlnS1pPNUNOTE83S0h6bm05VkRLczZMdEc2VmpV?=
 =?utf-8?B?MTd4SVVSSFBFRFR6bGluZDdKSHhuM0NTZHFLc0FnUnd6Tm1RZHpoVWxxRkFS?=
 =?utf-8?B?WGI1UWdzYkExdG5PMU5FZHI4a3R4dWMrWWdiVmFHUHYzMHlvTmEvOFZJZExG?=
 =?utf-8?B?TFlmTTJWUy9zbDRsQVNmS21yaHVFajFUWmFwTXRjd3U4d1VnR2djNEZXZURk?=
 =?utf-8?B?ZDY2Szh2QTlGOG1DdDVyTE51QnNSOW5SN1k2Zkh1a3RvVW1Xa0xSZThsZVhz?=
 =?utf-8?B?NngxQWE0STl3NnhOeC9uZ01HclloOG52bEx0UENSalhhRlhtNFRPaDcvdHBG?=
 =?utf-8?Q?AVSq+vB9dGU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDl4VWdndDEwTkpzTTRudjcvd2tDdHdZL3FLVU5POHRaU1JCTnFCbExkT0RB?=
 =?utf-8?B?MlRaZUNtNGZxYnp0OEgvMVJyL3h5OEJETFZWR0luT3l4dGV0NzF3aHk4Wk8w?=
 =?utf-8?B?ZldDV3puM3B3QVpGa3A4eG1YenpYcXJWbkx0WVRRRHZDWnRNK0hTZXUzVmRo?=
 =?utf-8?B?VFdVY0FTVjBTZ3lna1VzMHB5cEtjYk5ka1YxU0hDQ0FTZ1VoSDUybkZvV2RP?=
 =?utf-8?B?Zy9lVUpSMzBEaTFFMWJVNlliTVVHRDc2aXhGak1uUVptOW91SUhJZDF2NkhP?=
 =?utf-8?B?WDlXa01ETENFTU9xREIrcVVvaSt6ckZxdm9CRkRDUHR6UUZlbzBmU2djQlZC?=
 =?utf-8?B?eE1TY1YxdHB6bjJ5NW91YlczeWJGM1d1WlNwRUZrZGdlYUtPMGNjbGhmSGZQ?=
 =?utf-8?B?dmJDVmlKeFJSYmxXOWJSVUp3aFRHR3ZXOStSWlprRC9leFN3U3NzZzZMV0NH?=
 =?utf-8?B?MmhNUFd3ZmR4QWtKZ0lQTisyU1g2MVA2SGt1YVBLTE1OclVjOEY4UTNkODhk?=
 =?utf-8?B?MzhnazdKbUM5bEZ4VDNueUJKTzNXVDZUbGdsc3ozeDVCd1QzeThHRnlacU1D?=
 =?utf-8?B?eUlLbjc3L1d0NkdpYTc4SmdlM3psRGYwc2FIN2NxaHJ2bFhsNFRqZHBTWFN3?=
 =?utf-8?B?bldBbFBmYjcrcWtxSzNmUFRUUUhyUWFjeHBPWVhUVWtVS1YxalFud0lJTzUy?=
 =?utf-8?B?bG4zZU1oREtXenIwcGQ0Q2xsdVVSRXc3azg3dFFXMUFYbUQ5RUJINThVaXJM?=
 =?utf-8?B?dzhmRWphSlhsLzhLNGE5U0s3MU9XN3VPUTBKK3U2M1JsWlhrRlNMNEwwVWxC?=
 =?utf-8?B?YTBOWm9ObkpvUktWY0V6OEhzWGVUUTV2K2NOcis2MTA0elp4RjAxZkxRY1gv?=
 =?utf-8?B?TnBRUHphL3ROSlFDMTlzdlBaRXM2eUNTUmFVYjdkV2cvNnFWRjNyWVlUS0ov?=
 =?utf-8?B?NVNUZU5tdmhpaGYxUWZmTlcwWnMwa3c5ZmNpRnZDUTZidkF5SFFnQjVDdkZH?=
 =?utf-8?B?bFVUZjJOSHAwMzV3MnorZkw4TTFuM0VyRy9uZWc3Y3JXQVYyazY2VU9NNkZE?=
 =?utf-8?B?U2FOcDFXamNKL2NocjhlTmlnTFphRmJDYkZSYzZUZkg3bUVLZW5SRHN6MGY1?=
 =?utf-8?B?Kyt0M3NUUFBJVys5WGQ4K256Q1VOS0puSURaNm95ci96dDBwd0IzYmFybmFX?=
 =?utf-8?B?RE1ITlJoMGtUcjkrcHJWcFZ6TzhtYXJGWE1ia2VDVG44aE5mSUdBZG4rRjZy?=
 =?utf-8?B?aDg4c3J4azk1TmMwbU14dmVtTGZwOEdtUmlMazBIYno5NUJSR2YvUlhEQ2U2?=
 =?utf-8?B?UGNpbzhYZGdOVy9JbHRNeUU0TWZEN2xxOW81Zm96ajgvbkxTT1YxNjdhVFg1?=
 =?utf-8?B?eGhkQm1uNWdQTUlWWTFGU2gyclhSTGpyQ0dxdURlZHJncDh2YXpIdWVSazlG?=
 =?utf-8?B?Y0pqeXZyUjlwN29lZE13TFlJaUJmZlFEYjhVT0RnTDhka3hJZDRZb3dXMlpZ?=
 =?utf-8?B?T29hdzYycFVVd0VCZUNQenhEbVdVS29SY25PNDRndEpGRk1xQjJ2Q2p2bGVz?=
 =?utf-8?B?WHRleU80WXBCYkF0WlVDL2l2WC83OVdxUEJpRzY3ZzBuQUhoZFFCQUQ5Q2wz?=
 =?utf-8?B?a3BIR041TlFsQ0lrRmNxRDFKck5IVHN5MnA3SVMyTHUzVms5bmc4aExhQ1Rj?=
 =?utf-8?B?Q0ZPbmJ5MTNkMGorcllJc2pEK0NTRDhqTlQ1SytleUFIbGVpWUZJSEtxcWg1?=
 =?utf-8?B?S3ZvWVlmUjhOeHFiVXdTQWlhNTBzSXY1M0ZWWnZrejFLRlZJTWpDZFRLL0RB?=
 =?utf-8?B?L1VvUE42NUEwVkRkQnI5TjR2emJjVGNSQ0pWWm8vZkpUTElMNUpUUWcyZ1hJ?=
 =?utf-8?B?VmhoTEVmOE1SRTEwOVR0cjNMTVB3ejZ1cGE1N01GRjhhNkppTWlzeXpLdTRL?=
 =?utf-8?B?MWI4aTNQbzUwVnRFN3VVVXc2MUN5T05leGUycDVJN1R1VGh1ZkE4Uk5UYlhm?=
 =?utf-8?B?RTdhRS9GMkxwMXZ4Z0c0MHVSQ1Y3cXN6YUQ0NXg2L3gxTGczQnp1WVFzZVBx?=
 =?utf-8?B?KzRValNYTDhuRllCL2NsakEwVnRZcHJKNEpxaUNCU2FZblB6UFFwalNpQ1dL?=
 =?utf-8?B?dzB1RXd0OEpPTUpiK2pIdExnR1lYZE1hMkRrdHhnNk12QkNPb1d6dUc0NFBZ?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c12e0c2-7c72-434d-1238-08de11ec90ac
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:28:07.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPwH2GYxKhZmR26xl+RepV0Hq8T0TsvM1vmJQdE0/o9C/IIl5R4AUF7ZUwa1/P0XHjWWlEpVg6JfFhcfk6eFl7FlxpOk8uNcdkTxzMx66Ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8408
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Each CPU collects data for telemetry events that it sends to the nearest
> telemetry event aggregator either when the value of MSR_IA32_PQR_ASSOC.RMID
> changes, or when a two millisecond timer expires.
> 
> The telemetry event aggregators maintain per-RMID per-event counts of the
> total seen for all the CPUs. There may be more than one set of telemetry
> event aggregators per package.
> 
> There are separate sets of aggregators for each type of event, but all
> aggregators for a given type are symmetric keeping counts for the same
> set of events for the CPUs that provide data to them.

Above still seems to reflect previous implementation that only supported
one guid per type of event. If I understand correctly this implementation
supports the scenario where there may be aggregators of one type that support
different guid and thus are not symmetric.

> 
> Each telemetry event aggregator is responsible for a specific group of
> events. E.g. on the Intel Clearwater Forest CPU there are two types of

Could you please define "event group"? It is first used in this patch
but I cannot seem to find definition. Would be helpful to distinguish it from
a "feature group".

> aggregators. One type tracks a pair of energy related events. The other
> type tracks a subset of "perf" type events.
> 
> The event counts are made available to Linux in a region of MMIO space
> for each aggregator. All details about the layout of counters in each
> aggregator MMIO region are described in XML files published by Intel and
> made available in a GitHub repository [1].
> 
> The key to matching a specific telemetry aggregator to the XML file that
> describes the MMIO layout is a 32-bit value. The Linux telemetry subsystem
> refers to this as a "guid" while the XML files call it a "uniqueid".

https://github.com/intel/Intel-PMT mentions:
	Using guid and size information, the associated Intel PMT XML files
	set can be identified using repository metadata at xml/pmt.xml.

From the above quote it seems as though size should also be used as key to
match aggregator to the XML file? Also, looking at
https://github.com/intel/Intel-PMT/blob/main/xml/pmt.xml the file does use
"guid" so there does not seem to be a need to mention that XML files call it 
"uniqueid".

> 
> Each XML file provides the following information:
> 1) Which telemetry events are included in the group.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for an aggregator.
> 
> The INTEL_PMT_TELEMETRY driver enumerates support for telemetry events.
> This driver provides intel_pmt_get_regions_by_feature() to list all
> available telemetry event aggregators. The list includes the "guid",
> the base address in MMIO space for the region where the event counters
> are exposed, and the package id where the all the CPUs that report to this
> aggregator are located.
> 
> Add a new Kconfig option CONFIG_X86_CPU_RESCTRL_INTEL_AET for the Intel
> specific parts of telemetry code. This depends on the INTEL_PMT_TELEMETRY
> and INTEL_TPMI drivers being built-in to the kernel for enumeration of
> telemetry features.
> 
> Use INTEL_PMT_TELEMETRY's intel_pmt_get_regions_by_feature() with
> each per-RMID telemetry feature id to obtain a private copy of

"feature id" is not defined or introduced until here. Perhaps it should be
"event type" instead to remain consistent with rest of changelog?

> struct pmt_feature_group that contains all discovered/enumerated
> telemetry aggregator data for all event groups (known and unknown
> to resctrl) of that feature id. Further processing on this structure
> will enable all supported events in resctrl. Return the structure to
> INTEL_PMT_TELEMETRY at resctrl exit time.

This still documents the previous design.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT # [1]
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   8 ++
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 140 ++++++++++++++++++++++++
>  arch/x86/Kconfig                        |  13 +++
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  5 files changed, 167 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 14fadcff0d2b..886261a82b81 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -217,4 +217,12 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
> +#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void __exit intel_aet_exit(void) { }
> +#endif
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 57a328fdde59..9451bafde923 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -738,6 +738,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1095,6 +1098,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..67e479bdbc93
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,140 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/array_size.h>
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/intel_pmt_features.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/overflow.h>
> +#include <linux/resctrl.h>
> +#include <linux/stddef.h>
> +#include <linux/types.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.

Please place the definition of "event group" in this description also. At this time
it looks as though descriptions have not taken into account the design change made in
this version.

> + * @pfg:		Points to the aggregated telemetry space information
> + *			returned by the intel_pmt_get_regions_by_feature()
> + *			call to the INTEL_PMT_TELEMETRY driver that contains
> + *			data for all telemetry regions of a specific type.
> + *			Valid if the system supports the event group.
> + *			NULL otherwise.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_energy_event_groups[] = {
> +	&energy_0x26696143,
> +};
> +
> +static struct event_group *known_perf_event_groups[] = {
> +	&perf_0x26557651,
> +};
> +
> +#define for_each_enabled_event_group(_peg, _grp)			\
> +	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
> +		if ((*_peg)->pfg)
> +
> +/* Stub for now */
> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return false;
> +}
> +
> +/*
> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
> + * pmt_feature_group for a specific feature. If there is one, the returned
> + * structure has an array of telemetry_region structures, each element of
> + * the array describes one telemetry aggregator.

Above describes the previous design?

> + * A single pmt_feature_group may include multiple different guids.

"A single pmt_feature_group may include multiple different guids." ->
"The telemetry aggregators may have different guids."?

> + * Try to use every telemetry aggregator with a known guid.

Can "Try to use" be replaced with more specific description of this implementation?

> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> +			    unsigned int num_evg)
> +{
> +	struct pmt_feature_group *p;
> +	struct event_group **peg;
> +	bool ret = false;
> +
> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> +		p = intel_pmt_get_regions_by_feature(feature);
> +		if (IS_ERR_OR_NULL(p))
> +			return false;

This appears to assume that intel_pmt_get_regions_by_feature() can only fail if the
feature is invalid/unavailable? I do not think resctrl should make assumptions about
what could cause a failure. It is theoretically possible that one call may succeed
and the second call with the same feature ID fails. This scenario is not handled here
and will result in a leak.

> +		if (enable_events(*peg, p)) {
> +			(*peg)->pfg = p;
> +			ret = true;
> +		} else {
> +			intel_pmt_put_feature_group(p);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Ask INTEL_PMT_TELEMETRY driver for all the RMID based telemetry groups
> + * that it supports.
> + */

Reinette

