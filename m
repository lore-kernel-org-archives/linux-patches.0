Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39A13C140E
	for <patches@lists.linux.dev>; Thu, 14 May 2026 22:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778798701; cv=fail; b=mwfMrkXUJ8fIODRbrNIXrVVZ0KO3YZrIF3JyNzQlZFk5BpmN/D1wOubvU99j2jCqMLJqvXdiNE3w/RT6S8aFvNq/2JkFsj5r3RfYkAzBpfFG/YnjhrXnBdUALSTXdIe4VRXGYav2vRsNUaMFCqO01Kcd7Q+FBRspTh2oaTLggG4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778798701; c=relaxed/simple;
	bh=ZabQFLGlQJ59WGAS1nYqyoXJnEoR3sZOYQHQY/323lk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uW6DOg5q0wLgIAenl0lKREUt2X/eKGk8S6GwgzL1aK56/MDNvPYJuc8z09ivK92dhu6b8bJvCb/SjAFjNM8GtpId3NV1iY4h6pdtiBFhbO+I5H9mWfv3njZE5sgLOFTScse4IyPUdeeUBzdS+2rTyU29V1iN1Ok7YW1qTAJf5vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YPVzhfaW; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YPVzhfaW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778798700; x=1810334700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZabQFLGlQJ59WGAS1nYqyoXJnEoR3sZOYQHQY/323lk=;
  b=YPVzhfaWNB9c4pgt5GwUvGpoFbHdtrvwMJ2dBDQgM38rkMrMXtYAWkqU
   i9xG6r0VGTaPuoW0bCWsPuQUJ9waC+2OhjY+P1xl0ax9Y3BHJOUR0ExfQ
   h1UYdv3vlknozNULJZ+KAJj8IvOO6iR+2WGppWUYdtx70x/aClOVdVM9f
   ypTXCZHCc2dj7T/XKtrHVbz7JKedU46OQQhsXETogwfN7mID1A/BPloys
   AQ50SamCWH3WJN0OiTLgIDiV87hV32F9a9w2LfdeXoRsAG4Gnl+f/MbVp
   bHk/QN5vVKw4+R9V/GAsJ/6QK2xaeeqSIRUb5+FKQbAn4Tuf4vNlgnKJP
   w==;
X-CSE-ConnectionGUID: Lkvhb183SDmIOlVDOGhkfQ==
X-CSE-MsgGUID: T6iMVCUhRSGBrDSOQOy4aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="79792854"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="79792854"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:44:59 -0700
X-CSE-ConnectionGUID: GLlTk4d1SFa6eFbwpi2QTw==
X-CSE-MsgGUID: 1NhYIAkHQIOtSeP4XBURcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="262039072"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 15:44:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:44:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 15:44:40 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.67) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 15:44:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVJ9/IorLexSa3y/VkdzA7XWS+uIJD31I0a/F9ohUmXsYNQr3AlMyC3bXBTe4qu/QNtbPeJMcPXw2OMxqoey+ibDV2zsYtYj60sl8YJjNBQQZLJ4kmy4JuclM9p61c7flAv/EjT9luKbVrEtkUeskL49nu89yegciBRb71eYG/cdvadwWw+s46Mdv7tZutSGwVV1SDeEVkuhOsPxbQ2cy9uDOq94+hD0lf9JyF7WR+xkc5QmsxNMxcu5yqWkZi5mYK8DisZK+FzYowHDPonBAyl5mzSuKtOSlmcdEzc1VxtysMvQcVNJdETz6VkFC/BpFsk5942iiZdPHu/Ss1vYig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXAe5I1x2yJ4c0LeMBw/jWG32vl7+QY70YxJiSpH9kc=;
 b=Y2wJbVhbDZ1tAxf16aoxcWZ5Bbj6oZkYGMVwilslfWEZPxa7Puam+zhLCk/LzrsbG1EWx1yH4UfugcsyKQFJ6qHlKinIKeVCcb/NGUQxV4NqHdLuiHFBfZDFstX26cOPSizD5HHQhru/o23c7a59iHAsUDpCeTzZ9HFFvs9Ar47WpicpyZksnzElwfTmxrgQxXxNgFT5g6pJR+eM9VDlAXEWwKrVLiiHJC+gx3JrMayHq6qm2cI6uGaHDqMPAKOQdbmqEdLxFfWskpUO4YzmudDMFDlX9cAfjsNbsOLknPaiW+OmCRsC/zJjQGe6gtOstjS7BwKWbNd8YItsy5zoFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN0PR11MB6086.namprd11.prod.outlook.com (2603:10b6:208:3ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Thu, 14 May
 2026 22:44:33 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 22:44:32 +0000
Message-ID: <48574bc0-c2cb-48c7-9acd-592c7f727c07@intel.com>
Date: Thu, 14 May 2026 15:44:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] fs/resctrl: Fix use-after-free during unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260513224044.17167-1-tony.luck@intel.com>
 <28f663b7-de8c-4d10-b750-edd8ab9bceb7@intel.com>
 <agZLT1hIPrDIrN4C@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <agZLT1hIPrDIrN4C@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:303:6b::10) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN0PR11MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e643109-42ae-415d-efd6-08deb20a5db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|3023799003|56012099003|18002099003|22082099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info: xRBY9MrJSSUW66SlyTnnFnz6NPX78u+7eSN6zx8lNo/YqROQLtGZhp8UUBoMUQdKE3X5wESxf2Yq8nfsdp5ybuUZkNNu8E/e1p8P3WrUEjNalfUhteV+FHBzsG8TK72wy7mBn54sWIV9TrN6tCaBQMjhf4u8GMWlIRT6uoYAE1sTe4vtq1yINE6lpjRkyl+pASmNBsybiM7Uj3jPa/a4zC3NWkrp2aEVjMmEDCtgidCbjgUBP0b6gO9a9XnZM36Q1lIuLJ4vsTRCnUQCkgb+qIyH/8o93qlPdJKVIHB4xvzymNY0HRyRwziaIS88UXknixOVN6kU+N1VaIuVrW0PzIJT3cyF9nQYyL0PgNNEQS2QKntqm06SFwU+p9iiDaT2AZlbW50Ulzkh/0CVOc4qe8Vsxbo6Q3VN0gZMTeue0P9YxSq3sWVpkYsd8rFicVLmGUNPibkJ/Y2FUWHs1rqw77uYLF0SOSTsDHk58bKgUWSckHC4RgooTa8EWl6rrfDhDw/ZyALzvUUzru1PDNdozAjf74IZ7kWKHvajP2/GCnhFpKSSNt9P9OFIDdaOSWWsucq8RDG5GUuGUVbCCVSHVYcj+tx99x0GjmaLosImOYPU47Bbdjt6puaXApINx02Xt3c+x74i+allKsz58t6W3rbbdVwT4aHxtzzV/EysbFp7pXdFB8EA6vBeJTdOG83Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(3023799003)(56012099003)(18002099003)(22082099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnF5RHM3U0RMQ1Zoa3E3dzBRUXJCMkdoWE42NkdBLzFOejJhTEUrRUgxUEhZ?=
 =?utf-8?B?enErZWc1b3M1RU1PWGNkT3d6aitmUk9pbGxpSDJ3NCs3QTJtREM4Z2lBcWdT?=
 =?utf-8?B?NU1DUS8yRHZkZFNHSXhLb1M4a2x4V1dhQjZrSDZqL09ramRTMDYzQ1AvK1lU?=
 =?utf-8?B?VUE2WjJjbDNmaTNEdzhNakNHR25DNm9yK2hkUnJNYkh0RUQvSE5EamRKdS9F?=
 =?utf-8?B?UHdZdXlFNVN2V01paTVtaGVkWG5KMUVkQXdEWXdvbk56a1dJRllzSUlxR1c3?=
 =?utf-8?B?eDR6Z1FWRzBUVFBqMXpuZ1hLZC9VTk04R255ckhnUTFyRFltOXp2M1I1R3Bq?=
 =?utf-8?B?WCtYTlQzSmYyUnJEN093NjFYMzZkVkJXZzNWTjRPQnZwUklwb0g2Z3liU01J?=
 =?utf-8?B?TE1Ua2d2Q0R0YlJIMEVJVWUrRjFzR0o1eFR2NHI4MDRpazRNaU9hY0lLT1FJ?=
 =?utf-8?B?YXVNNGVmQUxWV2F2WW9pS1ZUU01FV3RSc3E3Z0prTjhVdWlMTVNrWXo3QnNU?=
 =?utf-8?B?MWNIZDUzWXBkL3dHb3RvcVljV3lxeGlRZ3FRekZDcDR5Ulp5VlVOcy94cm9B?=
 =?utf-8?B?azJKM3FhUmtQRUdkaVBLVWNYeTZrSTBBN2Y3cTZBdzFwVHlNOC9lNHB3RWhH?=
 =?utf-8?B?WU5oMmppMUZrTmJYWXlFTGNMWHEzRGcyK2VJVXdmYzNkZU96L1B5cHpWNHgv?=
 =?utf-8?B?NSs3a2loS2lzcDVscEZvWXlqbWxMOWtGeGx3NlllZWp1MUxmcVZ2SVhJbWpi?=
 =?utf-8?B?VnkrdnpVU0JCTi80UmlXdHRVYTlrKzZBRkIzMW1uK052cmRDSlBkdWYzU3RW?=
 =?utf-8?B?MFdwck02RWlLenNxR1Bzc0toUlNSMGF3aFAwdEtsK2VxQ0tDd09zZTByckZL?=
 =?utf-8?B?NWVST25SR2hhUWRpNUIwWVFSV1g1OE9PN2ZKdEpGTWp1VjNZcHVNeXF0ZUlJ?=
 =?utf-8?B?YjNqUURFUE8zaXVMdDNma1dNTEZDRGd2TTBiNldMOTFxbDl5S2hVK1NnUjRO?=
 =?utf-8?B?Y0tnbkZsZURuWGszZk83QVgwK0VUMFdXcW40aWVqSWhFQ24wTnJyR1NlL1Nz?=
 =?utf-8?B?ajEvTmN2L1dNSUxnL053czZ5NVh6MzZTL0JyNFQ0eGhOMC9QbEd5TGFTc3ox?=
 =?utf-8?B?ZHZNOFlNOEllZlBnUUtpMDJreHJOUzlQSFBYM081ckVUUUZCOXEzVVlhaXg5?=
 =?utf-8?B?aEhTZXZuR1J4TzFXaEVMT00zM2R1WTZRSlF6NmtjRHIzTkpCY1lEaXF0bi9Y?=
 =?utf-8?B?L1BTUEhPN0lIYjdUZ1BacFVsVUMrWERmb3F2SFdBKzgvVUJVSkpZSFFlbENV?=
 =?utf-8?B?VFExKzZRaWJ6clpIZ2J4QzR0NHo2UlQ4eTY1dlJzcWNIKytSaUhJdy9KSnht?=
 =?utf-8?B?cEJqQ3pqZFc3NjhvQTYxTm96WUcwTTdWMmZobm1IT2JaMkxwMXNFU3FjYzFK?=
 =?utf-8?B?VFpUUFljeTdHL0NkMVFKblN0cFBCUVNzV1UvWUN3YXlYR0x6d2hQb2YreVVm?=
 =?utf-8?B?MUgxczJBTktybW1aZ0lBSjhLMGswa0Y3SC93bXBTY0xUN3hreGxpZWdwOVll?=
 =?utf-8?B?SEFzbFJZRTVrNVhiM3RIY3NGckg2Ty9zcTdtckZFYnJZcW91aTVBNjhyYm1o?=
 =?utf-8?B?S3FqWnBWRmRpU3RGbHNmNkFtMUhHMCtzclZYMkdoaTcrUmkyTVp1KzBGSnFH?=
 =?utf-8?B?NHNJNjRJcFdCWVlZendiWTg4M2V5SHVqOUZ0UXhycUx2VEtUZkk5OGwvSjR6?=
 =?utf-8?B?Z2hzemNKenpCei93R3I2eEU0a2ZJQjg2bmJKdk42MWVoUEhJRC90MFZLazl6?=
 =?utf-8?B?N2l4c2lOTmJnOVAyL2swU3hvYk5DR25ZMXZIckZlWEdBV25POUhocWxqTXh3?=
 =?utf-8?B?K3JpS2pTWDFHaGdFOGdVYlNLMDJkMnIwVGZxODdBd0k3WUVOUmF6TmZHcjN5?=
 =?utf-8?B?SUVjNlEyWVN3Q2Q4b0Y0RzNITURvZG9LTUphb0ZneWd6NFhxWjgvaWJJU2RU?=
 =?utf-8?B?Nzl1SVJYeVV5RS8xS2dsTXVNSWkzd2RyZmM1b2s0TWdlN1htTzMvOFJKalJt?=
 =?utf-8?B?R2RUcnFkSis4NG5BZEpxT2hMUmxvWHh6YXNxT2Y0VkNiZE9QZkplQklyS1dC?=
 =?utf-8?B?VisvMEhBOFZEMVJtWFRXeVo4N1Bvb3FkSnEzRlpHa1hXTWpvL1NJUlByVkVP?=
 =?utf-8?B?UXh4cEc5WEtMTnJOdEFvWkpWSmxKUjByOUlrcXFFZXY1QkdzeU52RUI0SXox?=
 =?utf-8?B?OHlRT1NyVXphUmhyNHZhQXptODZ1QThwaC9XNDVqeXliWVB2YzZ2cHlyZHgz?=
 =?utf-8?B?ZjZVWHNIdU5hYlFPd09nTDdMTldpOXpzWGc1ZDFrcVhBR3lsOWRMU0VCTXZx?=
 =?utf-8?Q?or/cst5FW6vUUd78=3D?=
X-Exchange-RoutingPolicyChecked: HfI5mbtM3yXaU6oLTB6KBC9vtfSnHAxZ7BnbWtO85sQeWmc0KgRCj+Nho2TnWlpgumy+0Xh944y2PDb5szSCHMGTQl5fxwy5v7wO8gJLgC6z78hXVhWm4oiqKdqDE5WShBCKGq6yaY1pza4mwmqLWe75jVFUm6Me7x/ERIGAgI/ZgUBZOtxlTHlTd3fcZYTIWD6yvT15Uf4rgWyPSP0l8JhZsmQWH21MydpYceKj12bbQqkM4/2X9lSlnJI9m/mI1Ppr7Q20iBQEo7w2ybIIqeWggd0rOLLdNe1aSXqLLbrHolYR04QSFoIW2HokGtlifpVrIaYqoMiKBbTCFFrDNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e643109-42ae-415d-efd6-08deb20a5db7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 22:44:32.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4H0n+QAulfUvtAs5zNV0aB9k4MwPzl4cKLI3D9zmAOkhtTl32TgluicKaSg4urFi5suzOO+c2RxDOsGIIRC8Hvao79RbwyjzCfBrDGda59Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6086
X-OriginatorOrg: intel.com

Hi Tony,

On 5/14/26 3:23 PM, Luck, Tony wrote:
> On Thu, May 14, 2026 at 02:45:10PM -0700, Reinette Chatre wrote:
>> On 5/13/26 3:40 PM, Tony Luck wrote:

...

>> Another alternative to consider is to not call mon_put_kn_priv() on unmount but
>> instead on resctrl_exit()? Thus treating it similar to the RMID LRU list.
>> This may be more complicated in the long term since it needs more care to ensure
>> needed state is still available a resctrl file reader that was blocked because of
>> unmount or failure (via resctrl_exit()).
> 
> Pushing the resctrl_exit() is currently saying we don't care about the
> leaked allocation (since resctrl_exit() is never called - actually
> discarded). Cleaning up on unmount now means one less thing to do if we
> ever make resctrl a loadable module.

ack. One correction is that resctrl_exit() is now called by MPAM as part of its
error handling on receipt of a special error IRQ.

> 
>>>  }
>>>  
>>>  static void _update_task_closid_rmid(void *task)
>>> @@ -2965,6 +2966,8 @@ static void resctrl_fs_teardown(void)
>>>  	mon_put_kn_priv();
>>>  	rdt_pseudo_lock_release();
>>>  	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
>>> +	if (atomic_read(&rdtgroup_default.waitcount) != 0)
>>> +		rdtgroup_default.flags = RDT_DELETED;
>>
>> sashiko found a race here ... looks like setting RDT_DELETED unconditionally would
>> help.
> 
> Yes - as long as you are OK with the asymmetry between the default group
> and regular groups. I think it is OK because there are already many
> special cases for the default group.

I assume that you mean that in equivalent scenario a dynamically allocated regular group
is freed when it has no waiters. Since the default group is not dynamically allocated
it cannot be freed so it cannot be fully symmetrical here. I think an unconditional
RDT_DELETED is appropriate and matches how the default group is never freed.

> 
>>>  	closid_exit();
>>>  	schemata_list_destroy();
>>>  	rdtgroup_destroy_root();
>>> @@ -4291,6 +4294,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
>>>  
>>>  	ctx->kfc.root = rdt_root;
>>>  	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
>>> +	rdtgroup_default.flags = 0;
>>>  
>>>  	return 0;
>>>  }
>>
>> The "permanent lock leak" issue reported by sashiko is not clear to me. It claims:
>> 	
>> ---8<---
>> 	In rdtgroup_mondata_show(), if rdtgroup_kn_lock_live() returns NULL, the
>> 	error path jumps to the out label:
>> 	    out:
>> 	        if (rdtgrp)
>> 	            rdtgroup_kn_unlock(of->kn);
>> 	Because rdtgrp is NULL, the unlock is skipped, leaving the locks permanently
>> 	held.
>> ---8<---
>>
>> Comparing the claim to actual code the snippet looks like a mismatch since
>> rdtgroup_mondata_show() actually looks like:
>> 	out:
>> 		rdtgroup_kn_unlock(of->kn);
> 
> Yes. Looks like a problem in hallucinated code.

Thank you very much for the sanity check.

Reinette

