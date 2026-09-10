Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257C8306B3D
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013083; cv=fail; b=A+Sq43XpiVI2K9nxJ538LLrBRSHsUJbTxjaAHqTvbak+THMcgxtGC0VDaBX186LAuDR2MRylLbRcypmxMIm0Zu/QZtcKtU+eHoc9bibGiSgrmDLfx/rvmo/OjwlSqKk1k7qUD3JyZhPvRMz4d/3Ai+tnDs+4nOcuUDn3KvsrHvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013083; c=relaxed/simple;
	bh=RD1t+ltJdqXb1cAYLC1k3J6RZkap6+pV4wu6tEQEdrA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TjfHC9Th6YhIoKO9fziCoI0WoTkjsNo53/BdgQ9LzbcFnrF3cbHZbhxRPJ0epRunUH/MO7gITEP+tHJsguuqJJkY8iAg63q2vewVdSeQmSK1OZtV/v/gBgeOi+9FVa8rleblpr5Ni2XqEgNGcW1fof/iHoaVFU7tmlq3N55AaFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MLyL3YvE; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MLyL3YvE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013081; x=1820549081;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RD1t+ltJdqXb1cAYLC1k3J6RZkap6+pV4wu6tEQEdrA=;
  b=MLyL3YvEOsvwkyG4URbhUsQEFCYhpQX11FI9wdu96KQBbCw7/VTNUu/M
   tKbGS/vJStMiQx5pI/+G5w1xN80IzWM1OADUiDgtr9DmAL/RUHfqcFd99
   nrom2EgkInpz6rbi5SqXQJOz4fiftEB97oJbBTlfb+YyToVC5pXExVWYI
   mnLcM7bbv4aohtNvgXZnxpAGlsRr0GRlG61789awdGsEdTFQ/eWMN9TMI
   5UEHnYOfjVmRggqhENSseV7jbnJ1+KZuMUq3VN7GLG89gAIQHPAGvToNl
   cbnIUfZfn52Vm5cs5gF0PDs9H+rAhkFwJW0bc5N3fkrdbpV3E3pT3IvZR
   Q==;
X-CSE-ConnectionGUID: mUmd+S4ZTUGa/S6HJ4Zu4g==
X-CSE-MsgGUID: sEAEnZ57TAe3y5GmpVaexg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="77011999"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="77011999"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:04:40 -0700
X-CSE-ConnectionGUID: k5nI1PpTRsqYTe1kDvSpSg==
X-CSE-MsgGUID: uIVPnU42RNuSLDMr1HRZyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="269747234"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:04:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:04:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:04:39 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.15) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:04:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njoNHUEfSyG3sjQjD7Zmh1zCXUaeCsf1zt0m5aY7r28QtHUUcL5RRKnyIL6eXFpA3YhlkE4XMuJI0HwovnKM2gdw6zVa6BCdUCRLwx8/Yh5v1d/WSPlTv7ISCV2jVMu5QefGp5e/tFrOFcbXSTnTvPbKWrrIGaC52jLiqYpNfMT+m8Zue2iU83HVKs3JJTvZNm3sDroyDgREaXJ/7fgDUWYwwTeQaTz60FKw7qwuwT6ftDZJ8AyVUonDq9sz46iHZfT1k4YQU9rPUfVijGrm7SsLtCJtqtPsPRwLRsN+0P4iiWvjFlXqwCMm6aKvnyZdgqDGmvKZT51R8VqQQqfMnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4wR+z5tybZ9XWCKQ0yadk/R/xtcLSoLzYLIn7ncqzg=;
 b=x7+C4L8ooZD+u6/5VuDIqjhYtm0bKEyqnowgucCM0RArC1ZlOvo/mPzvtMhmrPr0J7xgu40xJ4jl+E/rhBjMFy7PUryiuOd1etwbuyt5maQZe8PbVbml8/Kq/BjdHOVCsl7e/Oz9ckBaqXT7Joh6GRSkfxpa5A/L3vsDf14aeijoj6V7w56X/8grEt9eF4ZbPtCziIEAsQAvmnc+4u+yuNqEtsiFa+hxGFm0kQioEejXoPNgHv8XEU9zyUWcC9CB3O35viGkniZ/0eN3ousjxBvCs2Dt7QhsVIqmjLVgUMZZ5K8G2daSZ14h5pQAwZ6CgRWe0iYPvqzaYL3NmHW4OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 04:04:37 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:04:37 +0000
Message-ID: <5aecb4ee-15cf-4834-b615-4a9f65a213b3@intel.com>
Date: Wed, 9 Sep 2026 21:04:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 13/23] x86/resctrl: Handle systems when AET is the
 only resource
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260831174421.13921-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0321.namprd03.prod.outlook.com
 (2603:10b6:303:dd::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 4079b9ec-a0ae-4d79-fdbb-08df0ef0a148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: LHPH9Pui5qFVVBWf1l4xumstefOyZnpVIz4s3uRhh85/cQrzgQAJvbJ8nEojFCZFcAOQ15K0n8pgiNe8kFqz5KAKC/+A0/FzckZZGczvaWsF0cIwVJGlGXgB4T5gndp6tR0QYf8Puk8QwwEOCDlWEoZ9uN4E68H5Dchsd31ai1uVpu00U4k+CRg2mNFbCGxtY0efOfn9yUVZBlGFH6cmc4TtJRM2d+5ZeJ/pNeUCFWkfg3hamsfVNAAgmlQlKH54mY88lFo5gLNI/UbM9AFhbpz0Ne+ekdwVZoYtdjswKIm4OTrLDv0dfYlhXl43c7Tve6HlFRj3ws7IYl5BW0UT+5Ws+02TmeZpeyJWP9jgG8uaCxGBIhnwQAgL9n4a5iTMc1GG17eaSCJMp7WY8F2S3QVTWbbWoSbkECaRPFo059tTWzBB2GmrLSdufo+oLabelw3IJjQY5p5aAIEru/qqnPPiJgCfQDgnINMWtDlx48JcL+6NNhHa9lyLHCFGdefFZBvVEroUjWsfLfUm8L+Bbe8ZjS/awZdI+gmL8inDRfvTFm6cgsAgv+1hXnEZ5sW+5L5NjqJ+H8aHhHDyyPqYB3jacaO7Zr1tOOUgdO1YdI3PO9iyoFMV7kdBAQO5PeSOLWLIatvIMTcFXS/iaRdja45IZH8LB5fy5fWyEoHBFMd84mACLZkyGHeND1NIfBraiaD2McwBHp0kom7dIzeBvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0pkcjZoVFhqR2RNbjFHU29BMWZhaUZ3bkFXeVlTc2x1SHN3RlBBQWFibkt2?=
 =?utf-8?B?MWl6WVRGeEdHZHd4eHdZNTJBZDNJNlZxcXVGQXA5UmNnaE93aW5rUTZBdzZ3?=
 =?utf-8?B?cDVCZms0M2VQSk9HZm90ZERxRXh4UjJsWkprbzR4RWVIN0lQcEJrSWZqOWtY?=
 =?utf-8?B?bXZtZE1CRlNkNGo0NlVDb2w1eE5ETHF3bnBON0xHVFMvbUVERXU3K0syeW42?=
 =?utf-8?B?b2paeFhaNWdXcGhzeUdpbmxGVllEMHduTGVjb3JscE05cmR1SCtaOUpSZWVT?=
 =?utf-8?B?enJxMEdCeFhBTVNGS1h0YVArN2JSZUl1T3hvTVZwZFVzWG4vc3dERTM4SGNT?=
 =?utf-8?B?R1hUM2h2NHFqZWlYR1ZxcDkzVEdVN1pzRmlkU1pVcVR4TkRKZW9nQTY5S3hM?=
 =?utf-8?B?dzJ4YVlTRG9oTGFUb1pvUk1KblRBMFZsM1Aya3J6OE9JcTZHSVplS1BIaWRt?=
 =?utf-8?B?c3BZeWFMdTJTNURyZ3Z6VzBqUkV3MHRMbXE3enB0OVVCMkRPdzQ3VmZlUVRr?=
 =?utf-8?B?N3BYUHJidUUwelgyRFZaK214eksvRkgyaUp5RTZBQVJ3QjdQWFpJNGM2eFBQ?=
 =?utf-8?B?RzJPS2ExcW9oamNCbWxoaDR2b0VGaXcvYmJ6SUduNnBNNTltSHowUjVlcExF?=
 =?utf-8?B?alFLZTl4UUl0bmw2eVRLSzNCRStjZGdTbTJadWFkb2pwKzZpZEM5WkduQzVy?=
 =?utf-8?B?UWppR1JiUlNyRmg4NUVvUHdkQTVNVXVpOU91dG1TdlB5WkxFYkpseDNzbGpH?=
 =?utf-8?B?QkdMV2VPUlkxSnppNTU5bVdwZy9DRG8zVzhSVTRYL1pxYVhUZUxkNVE3cVEz?=
 =?utf-8?B?WXlRNjhkbmdiazNMT0FINk9Ed1paTmFDbVdsczlqVXJBRDE5dVVoMEZpc1l2?=
 =?utf-8?B?dDNRYzhONUt1NHR0UVdDMENrbStsS3RNNDY5a0c0NmxqL3g4ckZKZklweXpZ?=
 =?utf-8?B?ZzRUNFdNWHhnNStSeUhmaFpoaFJxOENjaXlOZDE4Z2J4NDV4dTRRS2FwWlFS?=
 =?utf-8?B?Z0x3VkpKNnBGbEJWcEJ0dStQWHplMzdXRDFlZE5ZUXUxWTRydVpJUmJ3NEFF?=
 =?utf-8?B?aG9qN3hqWnJTWU9yV3owRkQwMHBFaW1hYUt5NmNvRG1pSVZ3S0dLamRNTld6?=
 =?utf-8?B?UlRwRExjSWNWMUVtc3UwdlJzdVFhWWxqejN5c0p6NCtFRCtEZ2ZSK1lFaG9M?=
 =?utf-8?B?eWxrSlRDaHpxRFdtTlQ2UWxieWxMaTJLaHI3NVQrZ05GM1dQbTJBWEtTNiti?=
 =?utf-8?B?K0NDMWdWeDNXKzZXY1orOXlDOEMvemNwVWU4clNhTEtGQ2R3eTNpTVlJczAz?=
 =?utf-8?B?QlJNUUJvWmRjRDRqd1RZdElRZEtpK0JiUUc5VUdaR2k4YzBBb1A2VmRKamlo?=
 =?utf-8?B?VzdxVnVHSTBqODNTYnB3bmM5ZXhmNkZOQ3hIRkJ6UDNMWVE5REhEVGw5b0FG?=
 =?utf-8?B?N3RacDAzc2VSaVVrbWcvekUzcndNVEh1SzloRzAyUWpwcm9jWXl0clRvTjd1?=
 =?utf-8?B?NWViV2Y5OG05VlFGSzJ4YXRTZWpVVit4VXROTUpvT0ZWa2J4dmpZNE5OT1lC?=
 =?utf-8?B?ZmdvZi9JR0Z2VFppK1ljL1JYbWZxSVRHZzhVWHZLQVVxa0hVSktpOWtkeEE1?=
 =?utf-8?B?STNxNXpBclo1OU85MkpkVVhRTDlOTkJueFZha3Mzc3ZlUzMvM2JJTHBFSkR3?=
 =?utf-8?B?YW9tM2hDc1hLZU5VNFJQY252SlE3WWFCRTQwMVI4QWJyZVRGR3Fadk9ORnY5?=
 =?utf-8?B?SUM5SStHMWJEL3dpTmk2RVdyalAyYmRmaFNCN0JWc0w1TGh4U2ZwV0R1QUpm?=
 =?utf-8?B?cXg1bElpcXkrRkpGbDNqbDFSQ0FIWXVqZ3ArL2FPeW1COGRWUzRoSnZNeitH?=
 =?utf-8?B?Z05qWEd4UmkyWTllNmFRWUlnalVPTGt2M0JxWG1ZNnpZTmVYc2dWZzJZZG5o?=
 =?utf-8?B?QXk1cUVxUkpLRktzNUJjWUpObnlSOWYrTzBxMC9ZU0hjbWI3RzRPWW1WL3lW?=
 =?utf-8?B?bVJZZEY3VTJNbkUwNVFhNFFJUTBNTzU2cUVJNTA1VHJ0dUp3OFltakRNdVlU?=
 =?utf-8?B?cEl2SHRneWgzMHFNMEVJN2ZHMDcvWHFRdDFxSDBuWXdmTkFYd0RjcHlxbEps?=
 =?utf-8?B?TW5xVWhFQndBTm5id0E4Q3I1b1JaZ0FUa01XQW56S2ZHQXlPK1dvM1dzRWd3?=
 =?utf-8?B?ck1EdG9WeVBjTFNCdTlxeVRBRmpxK0Y3dHE0Wk0vWjlvOERXVjA2REZkU2Va?=
 =?utf-8?B?OW1ERG9QK2QrVkg0a24wcURidFZQMmFCMkJLZ2hlZWQ5Y0xyc0E4bldmN3JC?=
 =?utf-8?B?R2UxazM0LzdCT3NxRzdmWWNrNXZFOGlsTUsxdDJteWdOK2VNVzBpQ01RUXdr?=
 =?utf-8?Q?F2lO/ntaHw6ocO1M=3D?=
X-Exchange-RoutingPolicyChecked: q4lb5y7Ng9hVsJxVdF9SxTjsgBCRglV3t+/RN1RRa5+yhA0DSwezPyY72p3FZaXvUM8kNBpffhVzy6nN2V3GD7Ecu7txREZfnevSFzXARLJH8mqhxNQBAf2mWOcVrFuDOjWsRqcGeZBG/idrOjyvG9Olqj/Wf3gL1jxpJ+4KQZbnuJxfIXL7NkVR5hOt1JKLOwGByR3zqSKEC7b/VsLVR2Citn91Dcrqk8757V8EHF+k/n5xLvAR/2IRiJKrgAQzwwZ5n/TslS0qt0ry6g7oYGVpTGLqgRmAMgzCOkLMNTELmLIYGCLeYwym2k+PXtFP9VMv+7Y8DkTkTILzXrgqNw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4079b9ec-a0ae-4d79-fdbb-08df0ef0a148
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:04:37.2011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2q314VuxLVrdeAI9pAqwDZYHsWXc+Csg+N3mnr2pzr1V2e5lvwK6Yo1c2DUf+LvdcGaPFOFhXgjAwcYbvG5Kz92rUvZdCL3SKzgmgfKRTHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> On a system with no L3 monitor resources it should still be possible to
> run with just AET.
> 
> Update get_rdt_mon_resources() to return true based on whether the
> system supports monitoring rather than on the presence of any of the
> L3 monitor features.
> 
> Make rdt_get_tree() handle the case where AET is the only feature, but
> is not enabled for a specific mount.

I think it will be more useful to describe how this scenario is handled than
a mention that it is handled and reviewer needs to look for how in the patch.
Consider something like: "Do not allow mount of resctrl filesystem if AET is
the only feature, but it is not enabled."

Even so, this does not seem accurate to me since it implies that any monitoring
capable system has AET as the only feature, which does not seem the right thing
to infer?

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Split the AET RMID cap change into separate commit.
> 	s/Fix get_rdt_mon_resources/Update get_rdt_mon_resources/
> 	New subject for this patch
> 
>  arch/x86/kernel/cpu/resctrl/internal.h | 2 +-
>  arch/x86/kernel/cpu/resctrl/core.c     | 7 ++++---
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 4 +---
>  fs/resctrl/rdtgroup.c                  | 8 ++++++--
>  4 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e46eb9a4c725..d70c8cb1cb81 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -226,7 +226,7 @@ union l3_qos_abmc_cfg {
>  
>  void rdt_ctrl_update(void *arg);
>  
> -int rdt_get_l3_mon_config(struct rdt_resource *r);
> +void rdt_get_l3_mon_config(struct rdt_resource *r);
>  
>  bool rdt_cpu_has(int flag);
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index ef37fbb586d3..0ddec2b67e3d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -1016,10 +1016,11 @@ static __init bool get_rdt_mon_resources(void)
>  			ret = true;
>  	}
>  
> -	if (!ret)
> -		return false;
> +	if (ret)
> +		rdt_get_l3_mon_config(r);
>  
> -	return !rdt_get_l3_mon_config(r);
> +	/* Even if there are no L3 monitor events, AET might be supported */
> +	return resctrl_arch_system_max_rmid_idx() > 0;
>  }

Please see comments about get_rdt_mon_resources() in patch #2 and patch #12.

>  
>  static __init void __check_quirks_intel(void)
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index bc2df287ccfa..e3485dc55923 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -431,7 +431,7 @@ static void __init intel_rdt_mbm_apply_quirk(u32 num_rmid)
>  	mbm_cf = mbm_cf_table[cf_index].cf;
>  }
>  
> -int __init rdt_get_l3_mon_config(struct rdt_resource *r)
> +void __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  {
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
>  	unsigned int mbm_offset;
> @@ -514,8 +514,6 @@ int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  		intel_rdt_mbm_apply_quirk(r->mon.num_rmid);
>  
>  	r->mon_capable = true;
> -
> -	return 0;
>  }
>  
>  static void resctrl_abmc_set_one_amd(void *arg)
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index de07ccdffdb2..3ac518ed2368 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3195,6 +3195,11 @@ static int rdt_get_tree(struct fs_context *fc)
>  		goto out;
>  	}
>  
> +	if (!resctrl_alloc_capable() && !resctrl_mon_capable()) {
> +		ret = -EINVAL;

EINVAL is quite a "catch-all" for mounting errors. I think we could treat
dmesg via "invalfc()" as the mount equivalent of last_cmd_status, this already
started with handling of the mba_MBps mount option.

More specifically, please consider something like:
		
		ret = invalfc(fc, "No allocation or monitoring available/(or enabled?).\n");


> +		goto out;
> +	}
> +
>  	ret = setup_rmid_lru_list();
>  	if (ret)
>  		goto out;
> @@ -3253,8 +3258,7 @@ static int rdt_get_tree(struct fs_context *fc)
>  	if (resctrl_mon_capable())
>  		resctrl_arch_enable_mon();
>  
> -	if (resctrl_alloc_capable() || resctrl_mon_capable())
> -		resctrl_mounted = true;
> +	resctrl_mounted = true;
>  
>  	if (resctrl_is_mbm_enabled()) {
>  		r = resctrl_arch_get_resource(RDT_RESOURCE_L3);

Reinette
