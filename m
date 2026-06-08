Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50556340A57
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960903; cv=fail; b=GXjA+1X+T5WpwlbYSBkxs/WMVdefsxmhWMd+qqA9oSVlOyTdAq1Wl4n15ubla1HoUtVVpYhFA00zUudLCwxTVoOCAKoUvFdQTkHfbzkbW9Kw6rzKpUmDeyP4aPk5HJqBz/OXdTIOG2PHN+a4YRHwV4G8iv4Rfnz3SZmWqNOyKT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960903; c=relaxed/simple;
	bh=6e3AlU3KhW2HetqCID/fDxUBZxPvospFuJcxg7ONSiI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BlUMTBIxlGR4G1WflubX9mlNR2mDW7zpE37RYI3cg57RYlKYHG9BZjwKpVtKpvkIpyf8uw+z2WqJU7E8UwaSpyrfcVROSR/DKVoZn9HtD6o+UCNi1RgmnIIA0Iqy/TwD13FUq5kIHO6a1+OWzVimR5CWOwGWGleSrSVBPilUS0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGw0U+Wm; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGw0U+Wm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960902; x=1812496902;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6e3AlU3KhW2HetqCID/fDxUBZxPvospFuJcxg7ONSiI=;
  b=AGw0U+WmN+UQK0+Q6FUz/FpOkEEPkCY/fVnTB20xf06sGtSu5i/gKbzZ
   gTwpsYU53aaoVNuqvJIMaqcb3GRy2GIGIWqlm/OcgTbm9jvnGKBEp90pb
   wDFxOEnG1uDKIbcPwYFslLuRsVy3cD0vxd1KJYP8toALh+PXjwhYevZuQ
   XkkCvXqoVvGWErti0pRIZCkOgQudPEcyDCrc4fG6msr+ntz6jGKPQ2/4l
   tQhYPDRlBIcRq74M3zwvHtk6/K8isyx81xlf8Uo+n9sZBb+QQmSabQFgj
   QCi6L3kUHMWCyVMuOBowIPW6GUNFXGPcQ8l8mJZ8/x4Xim0U7qRaT6JLY
   w==;
X-CSE-ConnectionGUID: a7gdLIDsRqqJXawgGTcadg==
X-CSE-MsgGUID: T9nKrMgIQ5OruZ0hSAflEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="93098230"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="93098230"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:21:42 -0700
X-CSE-ConnectionGUID: eew5mLVbRKifjCqb3UfcZw==
X-CSE-MsgGUID: wg/t6rviSrS/y36133u/xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="243250233"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:21:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:21:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:21:40 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.67) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:21:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhPeOahtazYmW2Y/ZzuVf1yVdkLAlzmMFuKTB6B4/pqF0ux7ABSurLb/5zQ131rg/SUBTZHBkhIq+NcqnRtP8SIroxEpKW9UCmsA6WRzTStKAOd1OOE/wAJQEf91emPRzKoOlKcVOBEpQRDnKhOgIhBSkPJWPO5vY1NMzdMjnR1nzFjUo4jnW4BKR7qOxjoou3PdN3FsPSN+W62yuYM08b9fkqyl7qZSYJ7M4hS8bDT2kqSqEBJwPQdKsA0vsdPKaaMr7NQtgBvbb3aI1WFeGohemJfoTGYon6ZQ40uBdvhQIENqZ9kzaz8gS/6HqjJMpz/3eUyM3wnBDXpzs617HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fc/Xp3GO6CInUQTWfDdj8aZ0orZeq6J5seAS9Xtfiqs=;
 b=gexxIazkVbZyhN69eStyNqzZpCsEcTUlidprkVCl8Fm1dUiW7RXCIUd92FMGWqeUgeO6mSqC5o8tG8t/9SIel8jzffMZ0BnOcudBiuHziDGG+jX0jlNON6p59gtGNJRd/u4FF44woXluRaPxwrcx5DNegzWEKgxfKXojaQTwkuof+icnULoZYiTcIpzAqg5WzJNTSgfLpMz99tp7GnlO+GrfN+WbRRqKTKSQ2dtBVACaXPrDWyHdf5G1C9rneGZ482Pn+I87/CDxu3pwphJ36LJtn+5JneyQb88brHbZcnG1dJ2DZ2wjYNhMdslJEf2wkPA/v9oU0toboRPJA8jlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 23:21:37 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:21:37 +0000
Message-ID: <bf248f42-1024-48a6-95ec-93d3c72f38ac@intel.com>
Date: Mon, 8 Jun 2026 16:21:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/14] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-10-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:303:6b::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: 47eff5cf-0f14-4bbd-c639-08dec5b4afc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: aWDYXM+kYzrpwmlI5NKl28Qz32Xnm7dVytKtmyxqqJBpKa4N8mGgl38Xul7xAZPxvihUga8nBMfUxbhQE3ipLa6ZOSJkm+k8brCICtCOOXi5K+cIiOm5JF7tMp4JIiYkVy6tanIwG4emb0V6sHvN8Wf6EgeSYfPsVwHTQhoAtf62RwyVVOCCoY91UTxotXRmE/SZD4h1psL/rCIBe9VS0OPQFTn7ION9D1CbLVpz3Ainq5f0UMwTrJ6Eje7ioUiI643b1JwAi2nOHO4Wk5mQuG/FIG+/tZNu1D2nhb4Qr3VYRaPd4V2KJVCgaAu6pDwDe7K2oF7gCrvCpQYQSxb2dJyahGHHv4wS1tKl0oL/53kDoh5K7zJ0s2ibElb26vkaofhBjSzfaIkSTOYsUAp8lIkQoTI2G0aFOVZsNa3cV+BWS+iXq8+XCTQd/0uHP8DNZYWuRaY8n57w8PIwhtPd6n/WJaSvy8jV49xhVicdSvJ7o2m5EHNWphXJ5zgY4q2e53cmRTpUH2dHNvMqmlEiAAfOZqSaZm+m5t0yItHoRG9nBTOPGVZHuBLRme8KwLD2SmK4xXQauUXOGFAKL03Vwrp3XPqBoLKjDZfdXC4s/OGNMP3NeKElKt9UPWpIkD31xe7beKVEVYebD6vKRQ2yhLtAbJs2cpO8eECB3HkObmgmS7JqBapa3Zs6FkeV5ISmItlq1K3QBjinxVqieI9Oe710c47mRHpU5F5Y7iphUko=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0krU2RWZ09PbUZZSjl3OFZwR202blM2RlBKYStSL0IvY3hVZmZSOVVlNkg1?=
 =?utf-8?B?OFZpVWFnM0h5VW95OG1vcWZJZE8vblkrcVdYQzhDbmJWOC8wNXIwUWxYeW1W?=
 =?utf-8?B?TVhTY21kUCtsaTZqb3JFSW9uNkk5dThZSWNsTkRuUXNIY25YYUIvQy9yTkFJ?=
 =?utf-8?B?OVV4dmVxQ0s4RUNjb3hrNDluL0dQUFlCODd0eTliWE9vMDJRT0dCVzZHb2s5?=
 =?utf-8?B?aWxvajk2dVZsQnpGdW5yN2F0V21BZzM1R1c5QnU2WVR4RXhTb0pKbVI3cytL?=
 =?utf-8?B?SlRLbURVbGxXYWpmQm9CZUxrVFhUcjE1ZlZ4NEREWGlBOGEzamFKQ3d2a1dp?=
 =?utf-8?B?d0NhK3RVcDdnWWdhNlpDZ1FYTENsc0hvTFRNZTR6Wi9FMEhBeHUrdjZ2bC9w?=
 =?utf-8?B?ZWVJVk5mb2FYYkNWQ0pJb3l2QkhRQXdqcE5qT1JGMktLY1p5UU84SlNhd3hI?=
 =?utf-8?B?Nk5IbVJ5aWZpZWZDZkNMZXFOdDlzemRKTXNKVm5vR0h5cXBGMkFQbjhLWEtR?=
 =?utf-8?B?NEM0MFJhWnVPNnd2OUhjUCtMc2tHUFh0T05PVkhtV3U1MUNrZkEyTld6RHpD?=
 =?utf-8?B?eWNEKy8yOTNFcTZPNzYvcmdEUkR2OU8xbzdtTUQ1NkVMM3Vudi9BRE1QSkhO?=
 =?utf-8?B?dnIyLzBsdkNYUlhmSUZobjNpeTZYakNqMnMwMGJnN240SXprSE91K3ZiNzdU?=
 =?utf-8?B?ZGtSTXVYRnNnNkk4blBCNGFJWUtoN0RFRVBFTzZ1VUtvdUlTY1puMWp4RjBl?=
 =?utf-8?B?N0RTVmZiV09UaTM2UGVraEZGMk10cFF3TkpWYitsd3BkQnJiNUVzZFNSVHZu?=
 =?utf-8?B?V0JqYjBzZlFWYmZpWFNwYU13VzRMbjhPQkxSemtXRVlrVVc1VC9hU2xYNjg4?=
 =?utf-8?B?UVI5N3FFdzlEekQ1cnAwZEhBZlpteTdEc01Od0taSC9lNXY1RTRDU2VrdXdM?=
 =?utf-8?B?VVdzdzB5cnppYm12NGJLT1RZMk5NY2RONXJKMGp6NTBQZC9SZE52OUsrWUpu?=
 =?utf-8?B?eDZ5YlJyU1lBRVZsWExqUzlBZWNra3RHNnJCVjJOdTZXOFV4V3ZmUjhHOElI?=
 =?utf-8?B?MVNqSmJSY3VqKzY5ZEtHODVJK2EyVlNRV3J4NU5neXVXUnEvMlllb1dXcDNX?=
 =?utf-8?B?dEVrTUZ2elBUb1FzeUpWamszSW9NTTl6Q1pQSmJuMEVxRDBLMnFrdFNtWkph?=
 =?utf-8?B?OFZnWURIQ1YwRTdmSk9MejN4dm95U3FuWkNlK2lRRlZmVlNRWnN6MHVWZEh6?=
 =?utf-8?B?NGpCdzRnaXlOeVF5cCtjUXkyZzg0WXFpcnBZTVJWY1JpdU0vMVdiY1ZMUXhu?=
 =?utf-8?B?ZFBDVUhDL05nOVlINjN5bzYxNzQ5SzV4TmJqZE5rWHZWOTcrdW9kbFhYd1Yz?=
 =?utf-8?B?WVJBckJtc0huYmFOZWVLaVo4MDdNYkkzWlU4dkJSWmR2eGJEZm5EeEg2Ky8w?=
 =?utf-8?B?dVJtUDJUS0NMUmhOMzVQUDErQkkyNlk5Q1FlTm01N2JwR2pmZHpEQWxLQVpN?=
 =?utf-8?B?REJjcy85ejBHSUtXdGRtMmNobDZIWlpPNUg3ZE9BSHZwbUs3dEJyOGh2c3RM?=
 =?utf-8?B?MFhUWDg0NlZzU203bVF0WHI3a2xjZE5Dd1ZGcGNjUnliYnFQUEFEV3crMnBO?=
 =?utf-8?B?VmJMOFh6Y1VRSmxodXpsMmlkbDcrNkdpWGR3RHZMOXpZM3hCU2JwMkJpZjdD?=
 =?utf-8?B?dUQ4RUdvZXVRWGw2L0N3c3l0Q21HWWRuSStleWdzODZHUkZCVE5wZ3lCYm1q?=
 =?utf-8?B?Y1A0MzZJL29kYkt1ZVdjbzV6aDI2SzN2TnljR2NoQVhJaERYUk1TSXBoV0hu?=
 =?utf-8?B?WFMyZHh2QjlRM0RxY0dCc004SVVkMENSck1oVjZ5RTBrS3hmSSt6ZXhmZFNw?=
 =?utf-8?B?azRsNk1MVGxjSFpxY3hhWGRSYU15Q3F5SmsxbFRhNUJLVE1YMVdxeTNSaml0?=
 =?utf-8?B?Z25DQU1xM2Fpa1BWUEtWQnU0YmdUYmRFNER2WG94eExYdk5OcHQ0T2E2SXlB?=
 =?utf-8?B?SFQyeTJaK0MwaFp3cVZxQ2NRdmJRZkd6dGhSc3FDMENBcjdkS20xMll5T2lt?=
 =?utf-8?B?ZDcra0RTK3FocVNEVklJRE5lYmtxTEVHeXY2OGczUW9OSnd1VkRsdklyVE05?=
 =?utf-8?B?eWxxVlRKWGRSbjNWYjZua1RqUnhTQ1dISWZmaXdPOXhjLzZRSmtJUGdtQkhv?=
 =?utf-8?B?a0NabzhueTZ6Q3hYc0hJY1Z3TWErWXY1TkZuSitkdE9NOVJZYjh6ck9nWHNj?=
 =?utf-8?B?VXAzN043U3BUQkQ4cDAwN3U0WUtvLzR2aktLdmF5c3d0T3ViSlZOa0ozamdm?=
 =?utf-8?B?bUMrSmhkRUpOc2xJQkdMeCtrU3lMTXdKRWkzdFJLRWxSOXdBZytqNG85OFhl?=
 =?utf-8?Q?t9Y9v5CLYe6jFHCw=3D?=
X-Exchange-RoutingPolicyChecked: WQDIXjI9ji2m1IaCH0Ssm2fSRUXNAsCAcVqtwu8M997jVRujY8qEDSwA2GQ7pt7kxoU3ZN6or77s0fwMlSeaUVKdrvBhW2uG+YTOgB+HMdvMi9KrRmHqytTZzN2COpOUo2LeP+zAtEeuhNpkeM/FXSZzmUYQxGvL/JEwftKP5EfwLCBFV/GhsamUQ/w6o4hcYGKF8yviSUCfO/dAjCOg1kJbgvDGZjQo6BB5Mah/t4LV63+pHCKxZnjxmQ7aa2HdIjE4Rh1PSPFqPNdV3/AH0r27AEEV7clu81EIIe/R0ki3QbYQaSV2Ncuihee4tf/aP7nDNblRjIYAVavVW7AVMQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 47eff5cf-0f14-4bbd-c639-08dec5b4afc3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:21:36.7710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnSx0v9DRdioyNwFXkyRmEO/WZk6svbpcBZMRgh438rhZ2eLBd3epVrlQxTNVsDn0/jytLlP2hlTpE7fb12xffvb1XCGE023dmloMTxCfQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> @@ -289,6 +293,10 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>  	return FEATURE_INVALID;
>  }
>  
> +static struct module *pmt_module;
> +static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
> +static void (*put_feature)(struct pmt_feature_group *p);
> +
>  /*
>   * Request a copy of struct pmt_feature_group for each event group. If there is
>   * one, the returned structure has an array of telemetry_region structures,
> @@ -323,6 +331,28 @@ bool intel_aet_get_events(void)
>  	return ret;
>  }
>  
> +static DEFINE_MUTEX(aet_register_lock);

Could you please add documentation describing what this mutex protects?

Reinette
