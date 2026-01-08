Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C419CD03
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 02:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767840181; cv=fail; b=l12tgoyk1eQWbj0NBgcy0EnOHrqLX5OBYS2KAaoUe88EeUE7AoEzpVsAkfhCMQAq/5gSymJMIFXfIGK2CBvrv6s305ncK9drTVCJxbhOisXhtDqpF7eMdfmfGDp3Qx4MeiNu+2iTfOc9H6Mf+Xy873NOdHwRryjMVjbbBShpVaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767840181; c=relaxed/simple;
	bh=ksqs5eZWbOlAQQ0Qef/ktsFWHmZ90ikpoR5SwZiq9Co=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kqEF/aPTaNkHsZWlwGMOxkmOB3ybD6EMiDa1WcRhxBEXaXNwUpsMQmOfZDbXIWI418VGHS9jOUNJ2pNl7H1wPFoKjyWQLOvx5kcB6EFoCnO88y0d+6e66T0KyYvHx+Qv7q5+i4foumZDmtFX8nbeAZYc+LTecg0PiDz9+VoFP1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2qxDWKf; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2qxDWKf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767840180; x=1799376180;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ksqs5eZWbOlAQQ0Qef/ktsFWHmZ90ikpoR5SwZiq9Co=;
  b=B2qxDWKfeRJ8xnS5SHm7JkFYUtdoF1lTajqoWKWzFwagJmX2H2k/3XcC
   GfzOFvMSUSptcNQ8xzssDpG10Yaq7dk9OPUI2G3nix+BSYTJ1lYlU44XN
   adYIpV11nxlxocW6tO5toRTIOBvXj7C5Nrbbz1z7IZGj6Wkm2tWSZJ2CF
   wpE3oSt4e+1MQh+UhDv84IEdR53WOg1TUUHPUr9+UvIOvi2dKamDvsQDx
   1NavkIJjLLemIHmIzvPAt85c7Yz/npcBiJF91kqFdxBtM+VGkouCNx9fU
   OEduTqRV7XoQFRMAk5PbJfTDpsq3HYsCOrvMZS3FizSz/M2WoW2CymnWG
   w==;
X-CSE-ConnectionGUID: c5eW4dp1RRW+KFuF0yFQLA==
X-CSE-MsgGUID: 7BLUjCFMR9u5Zg1Q/gGv3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="68223791"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="68223791"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 18:42:59 -0800
X-CSE-ConnectionGUID: yiZ9D0d+SRiUnchh15uAJw==
X-CSE-MsgGUID: 55prIN/2SQmBPG3DriOYhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="203101781"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 18:42:59 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 18:42:57 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 18:42:57 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.7) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 18:42:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJi7HejkY/udHI0AtByfxeAz9C1DtSDzwVy8Rm/nSqYh6gYfUohx+KC7K483EyYKlnRLBhn48oWnQNOcaPXKHx1Rr1wGOBraPPwuFuWxdSkmtZ+SLKrC3ozrkRVMaQy8b1YI7jy+1o5L0xyJHBPW21pXaGQzXPpdi8Oc5VgD/ganRcE03fcLsKoymWn29SN8y35ugGlrtt1vb5ACyTOVTkj+3v9uv7PClHNKw3MF0pnpQT915BFuGG1XcYLfFBcc9gVVUGDo+dXIIIsIsUoX8lh9Lp+pEl31Hhj2t6C/AoHBBkuIYnOR1kceuIo0Ez7capJQ4plnHi1wnDETSzV4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB4W40FSIt6cFXjvFNtb1O4gZ19XGmvX2XfDL3COECg=;
 b=atopvSJ7NXCsihZzcOubSOuJZchOjCxyPMJoGQAE9zS23mO8IR2LmY4FCANW8VsSLDPGaTqqivX7tWRieVvEv4u1RpQoNF91UkFpytXNVAS9+cpCBCD2lVLc9+gRJbYdTYS4kxkILfNNesntSWGVmbrkXQs89SFIaxYgF49LlKlU567altiOGzUrYOYd/EGvEjiSsEi7YKm8Y7SmPTHJY2hcNp20Lab6QH9EHhf6ALa09NFcDeWOTUc2bCaOBlo+/P1iy6Gcl/Y+9PEZjDgAT8zCnQhtVAkPgQ0oCKsz/LlaV0HXxCqkBBxnC1AoW2wFwRShj5QT7XDdGkorrsKS3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5070.namprd11.prod.outlook.com (2603:10b6:a03:2d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 02:42:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 02:42:53 +0000
Message-ID: <36239cc0-0a25-40a9-86d1-57236aa087df@intel.com>
Date: Wed, 7 Jan 2026 18:42:51 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
 <aV7BIWu7cSSgCv1v@agluck-desk3>
 <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
 <aV7d7JTp_YX_4BRt@agluck-desk3>
 <1945e4b2-9a80-4e48-be70-a8904e0fe10e@intel.com>
 <aV73RiFGJvYxAeo2@agluck-desk3>
Content-Language: en-US
In-Reply-To: <aV73RiFGJvYxAeo2@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0192.namprd04.prod.outlook.com
 (2603:10b6:303:86::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5070:EE_
X-MS-Office365-Filtering-Correlation-Id: fe9992ea-acc6-43a0-bbbd-08de4e5f9f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MzRpUGRiRUw2MGg4OE5EWmdIcVpEU2JaWkFHSWs5b1NHdXFDQ1F1WWpiYVpl?=
 =?utf-8?B?OUlwTkMveENVcWJ1cnlvUEhndVZ0bWlSUlZoeHJVOU4zbXdqeFY0a0lqU0U3?=
 =?utf-8?B?SmZWVC9xb2MwUzN4ZWRqTU5JOXlPaGtaZXhYaGxBSmxzNjc3M1BxaFNJUlhL?=
 =?utf-8?B?OVZKQ0pzSGxWWG9qOFBMVFBDNEN0elE4TjNQazErRzNEZGppL3MrdWd2cG1J?=
 =?utf-8?B?T2ZBdU1IdVlhYVZaYUxqWHprcHZiVnd1dlVEcHhVVWpuck9qa1g4aElVUnM5?=
 =?utf-8?B?d2Vmb2x2cU1yNytaR1FkSkcvcUhrU2IxdjdFMEVwMmMzU0Q1eDJiTVRvOGVE?=
 =?utf-8?B?am1YMUpEYjRnVFo4TVY5UlhaL0VrNHByTlhwdHl1dS8yZWhzNFM3MFNVdXFW?=
 =?utf-8?B?Z01vaUhHcXhXMnZGVUVpNE5WN0xNWGlqWXBmaWVxc0hoV2JkY01hYW5WY2xp?=
 =?utf-8?B?Q0lKMjBZVGpWZm0wRG11a3ZHMXh4Sk1yaEpyYTdkL09lOGtzZEZGVS9TV1B2?=
 =?utf-8?B?ZTJyUnR6S3VYMW0vNWFHK0VlWWFhbzVPbDBGS1lLZFM3alRMUXNlVGJ6Q0ZN?=
 =?utf-8?B?TmI5NjFaQ3lqeFZEa0VGMVdESnFad1pGb2JSWGRMa05UNG45YVpzVHo1ZU9Y?=
 =?utf-8?B?Qk83REw2VElvVnhpa05Rc1ZCZHF6K2pZeVJQamlOZG10VjRzMUl4Y3JuVGlW?=
 =?utf-8?B?V0c3V2lnQ1BoVGxybDMyUE55cTdhUGRkcUNMSG1lNWlCVktscExpMTZNOGhj?=
 =?utf-8?B?TlN6R0RLTTU3T3MvcHJ5akJrdldWN3NGKzVUVHp5Vytid2RVdXlwTDYrRGs0?=
 =?utf-8?B?Nm9Qc29Cc1JIaVZmVndUVGp1K0xKWVc2dWd1Y2Y1d0lCNW5RR09mUFVUM0Z5?=
 =?utf-8?B?WHNIcmU5T0h3emNjNkkyUVlNZXFyOUMyeVZVTUl1eENJTUlrMDU1REs4MzAr?=
 =?utf-8?B?VHN6bHA2RGNBS3Nqa2l6dDRmK21qY0tHNldtdE1DUWUwYlFYdTVSV21leTFp?=
 =?utf-8?B?VGs2dldkcHkwblhmaXVVcVhlTXoySktweGwzRmtPV0VDRlpvZDNjcDdPeWNQ?=
 =?utf-8?B?VjJIajhvSjcwaGJxdGxVZkJQS0pZZ1owRlR6Wks3QVpENWFkMmZQSnNqZHBm?=
 =?utf-8?B?MThqQVAvWmcxazBmUUdoVVJzeXdLUmlLRkV1MEFLM3RwQWhMa2srN29pdHBO?=
 =?utf-8?B?Z01SUmZpWjhxa3FYalFCc2lrT2ZMQVZLZkl6QzVFMmtwUFNORVBLN3ZNMit5?=
 =?utf-8?B?WEFwdmVET3o0dzQxZExGRkZZNktqNjg4aDNZZ1NISFcyM2YwOWJVN0hKUzNk?=
 =?utf-8?B?ME5KaVFWcWRzYjRpVTZlVlExK0E2US9JTUpNSXdqMzZTNnU2UG12K3psSmJL?=
 =?utf-8?B?R0pCam9qampJWE10WHJ5Y09hb2FJVTJmVnZLQ2VqaFVBcDNFVzNaViszSWVR?=
 =?utf-8?B?UG51dkUwZ25sNWFQSzkwQlRxRjVRdHo4UEtIYzdKaWs0MWxxSHo4UWFEaHZv?=
 =?utf-8?B?MmdGT1hhQjVFWEVJY3dVVUVQZGN1bkdLRGJ3azJaM1RPcWV6QmpNUUtOUlp3?=
 =?utf-8?B?T01PaTY1TVV3Q0hvR2V3QUNjK3BEc1JQaXJYSnRiZVNuWkhNWVV1RVN6bjRs?=
 =?utf-8?B?VU5GYnl2MjVobUNjNGZINFV5eS9WdkkrSWxzbm5zb2hXbHd0LzJYaWJ0REti?=
 =?utf-8?B?bEhvd2NiTm0xdG16aXhMdTFRUFJ3ZkNzeVJCMFliY05ubWFjeHdNY3pncDZ5?=
 =?utf-8?B?WVRybnZFNlpSd0FkbHZkSVlXbU1WSE0vOXJDY042eERpZXRVWHNycU05U081?=
 =?utf-8?B?MzBVbFROcGZRTmlWbFQ4Slk1cHFNOWMvblNxSjAyZklVOWxJMXhpTW5Vc0Vu?=
 =?utf-8?B?WFFGZWFyUDlQWkJGYTR5aHpXdXVLQjJhem9uend1Q093cTgvNE8ycHZCRmI5?=
 =?utf-8?Q?uDbGMzeKfzFDBmCd4P06nDU5nkQSVXPJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzBNWURBOXVKa1JOdllLTDVBekNrbHNDMnMzVkg3VS8xby9ZbzE2aU9mVTJF?=
 =?utf-8?B?TDg3UmVyWDFEWmgvK2k3aitraHZ5d1QxcWhUb0V0b3Iza29vcmJid1RxUkZt?=
 =?utf-8?B?cHRVOVlzM1NabHd2TzJpVllTYUU0TnJJbVF6b3lETEVEaTZoU2tqQ2JjOE9x?=
 =?utf-8?B?TnBkTE9xNjc1VGVNaXZPTnF1VFV2ZG5SUWJoTm1LWlVoSlBERFdPcGhTOVF1?=
 =?utf-8?B?blRFR3VuRlJwL01SRERGakMzdzdRSk02VzQzdnBlcHBqbkZYbm5lUVRtV2tF?=
 =?utf-8?B?MWFNbFRZOEp1NUpJeDRqOWlQMm9rcSs4bzAvbVZvOWt4ckFnVXFuZ2pQVnVl?=
 =?utf-8?B?dFEyQ0FzaEpQNUZwWDk2N3RFbWZaaG96NURCeWZaeWdOM0xZVUgrK00wY3N1?=
 =?utf-8?B?bG9MazBwYmUvTUVWMis4T2REbU5JdzAyV2RzY0svZk0vLzdOdlpad3FnbFFw?=
 =?utf-8?B?eEF2anJsU0pGUDN0S1dEYjFHbVRsQk51Q3hPRnI4Y0VRdUVwNDE1M2tiVTcx?=
 =?utf-8?B?azcwY0ZOSDJ1NFpCTy8zNWZ3aFN0ZVBvdFdtVWZ4OVhFTjFFRUcybllncDBm?=
 =?utf-8?B?U2ltaGdpTGFBNkhUdDZEVEdDcHM2VGFaWHVMYmpVWDZLOUkrY0d5U0tocENu?=
 =?utf-8?B?SGduZUZ1OTRtMnhpTTVtTnJmZFNmbDlaMk9NZzBpd2t3UnpGeUU2UnZISWwv?=
 =?utf-8?B?SmpjVFc0Y0RsWUJZSFh1R3JMR2hMUlN3T3FTQi81Tnp6a0czVHp5YU1LTFlD?=
 =?utf-8?B?enVrdFMyYmhpNWFsTXdTYnczRW1MWGpJaVdZWHNKR1FaUDVKc2haQno0R2Zh?=
 =?utf-8?B?M0NBc2NvVFhiTk1OSGpONmNtQ1BHNzV2QytIY2dTVUpYN2czRDdWWEQ4dUJD?=
 =?utf-8?B?WXkyc2UyVUYzcytWVThOUVgzaG5Ob3d0NTY0Qk9qdVEvZnlSb0RzQ0JjU3Ft?=
 =?utf-8?B?TXNsK2R4QUZUSEhqblpDdnlMNmh3SU5mOTJQbU85djdOOXprSVNsa0llcUth?=
 =?utf-8?B?VVZUSWpMMHZOUVYxNnRXaFdOb1VhQkFWRHNTMEFwMmZOVEg4UkdFRndpZjli?=
 =?utf-8?B?elpmYkJKWnhZVFhTZS96YzE4V2I5WGordWhadC9rSGVSdjEzYjloUU5QUnFT?=
 =?utf-8?B?ZGRWTk5SdHJPcEdDZkhwQmVmcEVOSkxSY0x4OUpmT1ZHRUdxY0VZc1JpbHY5?=
 =?utf-8?B?SmttQ2hWNGY3MVBEVUNuVno3Q0RiMFR0RUg5Q3ZIZ1IrbXNkTS9mcnU2Z1VW?=
 =?utf-8?B?NElRdktVaUR6Yi9kKy9ZWFlEQVE3Wkt5WWREbDUwZms5aHM3Nng0RW5DZHll?=
 =?utf-8?B?SmRIMEtSZW4zV2hXUXVrRUhvalFmd3ZkcnRmcjlnZXdNaTF5QkRHZDRxaVlp?=
 =?utf-8?B?M0JwWW44bnAzdXRINjR6YlNUTktEeUFUcEc1VWtHMFd2Mk9LL00wQU9wR05O?=
 =?utf-8?B?a3RMS1QyR3N0WStkNmRsdG5QTTFsb1BJNEUvamoycDVUcVZiY29NM0tMdy81?=
 =?utf-8?B?aXd5dzNwODY0RTloS2V2dERaQzBiNWFRZlBSUEJOdFdkNFhWQTltTk5sbGxR?=
 =?utf-8?B?SXVnb1ArUFZYT1JhVVpCb3hLTWZYSWJZeWh0Yk5ha3NFR2M1S0NPVm5xV1F0?=
 =?utf-8?B?RFZBQVRPSktqOFhkTndmNWt1TmpnZ2tGMnI5dlExclEyYWR5SHEzYTVyY1JL?=
 =?utf-8?B?YkExZDc5TzBBOFpBMkNibmkxYms3OGdOaHVjZFRaUlJ2amNkbW1tYjBqWVRk?=
 =?utf-8?B?Y1U0dkxsdzhrVkJFV3ZMZ1UxdnlPQmtSdXM1dFRncTNhbVRUV0pnQjlRTXlL?=
 =?utf-8?B?RXpJVkhHaFM0UUl3UzJ0YjdZdUxQVzVrSEdxMEw0K0JucDlFYkFqRnZXd3hJ?=
 =?utf-8?B?b2RQL281enFnSzZ5MHBXTlNtNlZEbDg4MFlEa0lGRTR1TktkMDg0dnFnL01j?=
 =?utf-8?B?Q2N5eEJtangvN1gwQlpWdnhJdXNaOEV2R01ENlNidEIveG4rRVlOWnpPZ0Ft?=
 =?utf-8?B?Qy9qUFdWbVRqY04ra1ViN3BxanMyL25sdzNsUUl0ZzFYamoreDBIMFlXTEVh?=
 =?utf-8?B?dlRGa21hRTlwOUw2OHNVdjZIaENwMmZkdnNmVWRtTGY1QStPeGFmajVQb09S?=
 =?utf-8?B?Y0sxak1BYjUwTEpNcmNVVWwzNTBqbjgrU09MVTdZV0srd3ROTldIVGNmeXEv?=
 =?utf-8?B?ZmlDL2lNeGd6UW9JZS9sNi9lNGwyRUJYMzJ2ZjFYRjJpZUVSUTMxZCtkaWc0?=
 =?utf-8?B?NjQ4MVJDNk51UGpFd0xPc2s0UTl1SjRKdU13cXc2SjQxOWdqR0RMU01ZQTlY?=
 =?utf-8?B?Q09hUW5FTXZuY1M4TGdWMFZkemJjS01FU3lXVk9pWXowY1RvZUpzdDQ5WFJN?=
 =?utf-8?Q?7oLKmT0N1clPxFec=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9992ea-acc6-43a0-bbbd-08de4e5f9f54
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 02:42:53.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSoO1O0E3s4PRu7y2jrmkzN2UoYuKUOM+mJvZpFlcGjcZQDPN4Mjj+6AVQnd10ci5DAUALZDI5iB09KjYGDCAzdhvv6mczAdiBmEeZVlJjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5070
X-OriginatorOrg: intel.com

Hi Tony,

On 1/7/26 4:16 PM, Luck, Tony wrote:
> On Wed, Jan 07, 2026 at 03:09:24PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 1/7/26 2:27 PM, Luck, Tony wrote:
>>> On Wed, Jan 07, 2026 at 02:09:35PM -0800, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>> If these DO_ONCE macros are ever used heavily in run-time code, it might
>>>>> be better for once_lock and once_mutex to be statically defined in each
>>>>> invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
>>>>> that the static key protects the spinlock/mutex from being called may
>>>>> mean that it is practically hard to hit problems.
>>>>
>>>> Which problems do you have in mind? One problem I see is that since these "once"
>>>> functions are globally forced to be serialized this may cause unnecessary delays,
>>>> for example during initialization. I do not think this impacts the resctrl intended
>>>> usage since resctrl_arch_pre_mount() is not called during initialization and is
>>>> already ok with delays (it is on a "slow" path).
>>>
>>> Reinette
>>>
>>> Yes. Unnecessary delays due to serialization. But that only happens if
>>> the first call to a DO_ONCE*() instance overlaps with another first
>>> call. It might be quite hard to hit that during boot unless there are
>>> many uses of DO_ONCE*()
>>>
>>> Looking at this some more, DO_ONCE() is overkill for mounting resctrl. The
>>> static key part is there so that DO_ONCE*() can be safely used in some
>>> hot code path without adding overhead of checking some "bool done" type
>>> variable and branching around it.  I don't see anyone except validation
>>> executing resctrl mounts at multiple times per second.
>>>
>>> But it does make the code easier to read with a single line with obvious
>>> meaning instead of multiple lines with declarations, initializations,
>>> and if () conditions.
>>
>> I am ok with using DO_ONCE_SLEEPABLE(). The next question (perhaps nitpicking?) is
>> if it is resctrl fs or the arch's decision to use this. That is, whether the flow is
>> something like below where the arch decides:
>> 	arch/x86/kernel/cpu/resctrl/core.c:
>> 		void resctrl_arch_pre_mount(void)
>> 		{
>> 			DO_ONCE_SLEEPABLE(aet_specific_call);
>> 		}
> 
> The AET code in resctrl_arch_pre_mount() includes building the domains.
> That needs the domain_list_lock mutex and domain_add_cpu_mon() which are
> both static in core.c. So either they need to be unstatic'd and added
> to "internal.h", or that part of the code needs to stay in core.c
> 
> Opinion on making these available to intel_aet.c? I'm not a fan.

ok, that is fair.

> 
> Keeping it in core.c means finding out if intel_aet_get_events()
> succeeded or not. DO_ONCE_SLEEPABLE() doesn't return the return value
> of the called function. It just returns true/false to say if it called
> the function.
> 
> So with this approach I have:
> 
> void resctrl_arch_pre_mount(void)
> {
> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> 	int cpu;
> 
> 	if (!DO_ONCE_SLEEPABLE(intel_aet_get_events))
> 		return;
> 

Thank you for considering. This is getting difficult to read.

> 	// intel_aet_get_events() sets mon_capable if it succeeds
> 	if (!r->mon_capable)
> 		return;
> 
> 	/*
> 	 * Late discovery of telemetry events means the domains for the
> 	 * resource were not built. Do that now.
> 	 */
> 	cpus_read_lock();
> 	mutex_lock(&domain_list_lock);
> 	rdt_mon_capable = true;
> 	for_each_online_cpu(cpu)
> 		domain_add_cpu_mon(cpu, r);
> 	mutex_unlock(&domain_list_lock);
> 	cpus_read_unlock();
> }
> 
> It does reduce by one the number of stubs. intel_aet_add_debugfs() can
> be static in intel_aet.c
> 
>> 	fs/resctrl/rdtgroup.c:
>> 		static int rdt_get_tree(struct fs_context *fc)
>> 		{
>> 			...
>> 			resctrl_arch_pre_mount();
>> 			...
>> 		}
>>
>> or something like below where resctrl fs dictates the function can only be called once:
>>
>> 	arch/x86/kernel/cpu/resctrl/core.c:
>> 		void resctrl_arch_pre_mount(void)
>> 		{
>> 			/* AET specific code */
> This is the minimal change from my current series. So my laziness factor
> leans toward it.
> 
>> 		}
>>
>> 	fs/resctrl/rdtgroup.c:
>> 		static int rdt_get_tree(struct fs_context *fc)
>> 		{
>> 			...
>> 			DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
>> 			...
>> 		}
>>
>> It looks to me as though the first option creates opportunity for better isolation
>> of AET code into arch/x86/kernel/cpu/resctrl/intel_aet.c, specifically, it needs fewer AET
>> stubs in arch/x86/kernel/cpu/resctrl/internal.h. I do not envision resctrl fs needing
>> to call resctrl_arch_pre_mount() multiple times but the safe pattern appears to be to
>> place DO_ONCE* in a helper function to ensure that only one static key is ever created.
>>
>> While the first option allows more flexibility to the arch that should not be a reason though
>> since this is internal and we can always change to better accommodate arch requirements.
>> The question here is just what is best for AET support. What do you think?
> 
> The current usage for resctrl_arch_pre_mount() is that it only needs to
> be called once. As you say, that could be changed if a new requirement
> appears. But the simpler approach today is to put the
> DO_ONCE_SLEEPABLE() into rdt_get_tree()

Thank you for considering the options. Placing DO_ONCE_SLEEPABLE() in
rdt_get_tree() is fine by me.

Reinette
