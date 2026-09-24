Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26D27E049
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263297; cv=fail; b=dcIA5WvkPyF9Ea5w64oI5ex8VVI6Q9yVqdJ/8byTAh1n8XiFEpKdZL+eL1HxupxRE0IEmOw1Y+FSAVRu7Bl3Sjh6IsVtKWzAO+1UiCI+/P45zlRncfhzx3Xk9bIGsQzYKF5gGWz0PmUruRkbFIEsFzIEQBasMK17wO/8yt0ojKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263297; c=relaxed/simple;
	bh=IjxAuCqYLLaqkR/M+kKg3qN2Wvgzcc1uOY3OY82DWn4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fQp8Jqk9SSq0iUPASKHBABw0qNFMvY+rIqHCxETk0/teNdT1jKmtd/9r/ATadmXW1M4nh0pKAKnCdhLLIFad4YQLDPbDf4sXDcf8NQoHGdLP3DNiFD8at+v9M9l81mBYYbGq/ozN+kLJ+nsr9jz1POEbHQJB+yI9oZFQdLDap7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bg3M1bYq; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bg3M1bYq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263296; x=1821799296;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IjxAuCqYLLaqkR/M+kKg3qN2Wvgzcc1uOY3OY82DWn4=;
  b=Bg3M1bYqRMkHknomMC074y+B2YQkfuekAaoPwJ94B0HSPRCH4UuSKr5o
   9OnratbjBzv4a0zNPzHh8eFsfaDhYxd8ZHaZ9eaXzh1FrDrLuxdgGqmFd
   tVLZ8zfBGcd0XvtSw0dMPA9Q5Hl0xhuVNag2fVjHmXmVfeSr7Nlttvg2p
   IYUsYymfq4Ym699jmf+ZnNaISimrZkEez+6SbagLXU4he+mLQbC09I+Rk
   BFMRXkeXzazGYknuxmqiMlmx+EBQ4YXPRathT2vpifAj+WFaEMg2C6V8t
   YEQhBysJj5QTGs7dUCsL5vw2M7/gkLDNyuOzjWPQV1PifdrtI39VfrXec
   g==;
X-CSE-ConnectionGUID: B4wCR8tEQyyZuKnbFqyAvQ==
X-CSE-MsgGUID: 6Xn+20MFTt6ENNnzt/E8Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="102396785"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="102396785"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:21:35 -0700
X-CSE-ConnectionGUID: 13Ad3SYhSGipe8kuUuQZ9w==
X-CSE-MsgGUID: U6wtTocQQaGXa7wYNunrpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="278796985"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:21:35 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:21:35 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:21:35 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:21:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LCQVo2KJHileIQhNAKZ4TMdPPdtpQ0kjKzuy/7CiwtPgyRijz+YzQ45w3gkxvOAJa08qg/tCpNDMErcrN9/OwZ0qRDP2bgC97wU2e3pOm2wcjrxG99+vdX4qAejs3sKQSE3N/pB0ffeQepej9vXleHcrh/ZihPAvflzhmF5lLo3EHbGLXxrGjAZtTKeKBgX37zyhfYYIi6E/oAMYuXplGGI3eizIRJMOtcZmEWq/80FmhJrFizTqtFMBO9bgZzJ0Wyy2dSknU83kMk8wS5gVD8xhoWyD8SSsyY9UDaxklgCAmg8Q5HQ0MPnpayyg/kGztP0s6V0VV4qh7J3V7w9hFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVUhlRp+VoBzOX4ICokOdhKshYXC1XXPYnmp8gL/sr4=;
 b=Ob63ux/j5wT7qqb9J4Neeel45UmngKAQK9PDnFnAkXoYhsayYasz69cBgeqzsuBWicm2a+LJC+kX/Cf1zar4C6Tf0ST8waVCf+HQt8o+bxJJCLaFNpHUNdC3weGzsn3sgu82i7IvXEbieLGpsfSWWU5UNZMGXla6YaaFRXEy3wqLC6lr4OaPh7dGwwZrw3yzNjaEHsrlj1P0R4pxU1AaIlwkg1UlJ2ngyk8HW1c78Q72LgtQ4syBo8jukRbraeha2uz6YhLatIe57vqWxJAtevT4XNSu28F/OVb5p/8gQp19lnN3dWI0iQq2pH2OPxR4oN0YRQY1nUn5lZqc9xoHHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS6PR11MB454219.namprd11.prod.outlook.com (2603:10b6:8:4c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:21:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:21:32 +0000
Message-ID: <df261239-7197-4abf-b203-1a81b345e7ab@intel.com>
Date: Thu, 24 Sep 2026 08:21:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/25] x86/resctrl: Delete resctrl_cpu_detect()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, "Borislav Petkov (AMD)" <bp@alien8.de>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS6PR11MB454219:EE_
X-MS-Office365-Filtering-Correlation-Id: bd13a8ba-2daa-42ae-72ea-08df1a4f8385
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|56012099006|3023799007|5023799004|18002099003|22082099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info: s6Q/lhGGoLFZFkaghH3pPrAsGFgRtFK1VLXd/kx+lEfP+EhYU55kpoPsovXPOPdL+ue8N0dARswGFYhprqPDuhMbWFor6v8bkLm0prFNuQP8VkiUFPaIAs+3BXpa1du0hSsOxQIIXEbY26+MorB1yK1H02qljwpSah8zAfiX0UEYR3lRRUPCygBGRoe5/4iaXGM13p2FvR8lzvw0z6XCAXC4iYJrUkpw8oq96sj21P7qKkZq2HnWYNN6VEn2YXuY6au+/6ih4/XTNavMMxueJljEkIgZBLCJgvpIRTkdv4uoux7Ay/y4UQJkoc7Ts8W0yw6/z8iZHRb2Dq5tkRwJrzfZ58Bl4hqkmE5PuhO0eT7t08WIhaU1mVW+ujsmxYaYBOCHFy2iEh0px6dGasP5plqIH3uXK/tEc+4qA/hng2FSxT925bEmaka+LBWW5OepH22ZCIZlZQSDOwZ7+l1bAyqLftRwebG3t7/+Ls9snp6a7lVwpNg5yfEuPwllQjAWSzxvVyaeWZ++1LhONscVyJBs2dHduUt1OQcw2xkMnJgnu1E2iPRNtH7nKxVzGkx28N2IVrL3+Uf3xcaR/KJ9cB44zmHuQLoTiEmkqj9a8b+vzDJyNb06ay/u8cpUDOaUo8zuUIIuJVdsKGnJxzdvehXSuTzlVNQX7iexHL7R1qLG6D6fRLpFz0K6jjzpqLgco+lsVTkDPaweakOMUD79Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(56012099006)(3023799007)(5023799004)(18002099003)(22082099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGFCbnRYRFhvZXdCMHZnN1pIRkloSXE0amVES3pYL01EaHBDL2Rra1lRamlq?=
 =?utf-8?B?elBTZkV4cThiSEpNVGc5Zk1LcUhYNVhtVklZSkFjdlJ6MFNYMnMzYjBvVjBU?=
 =?utf-8?B?Z3dKQTlxR2VaVjF4TlZNVzRvVjFPbEJXckxBK3RoVithVm8weTM1VkNVVUNl?=
 =?utf-8?B?M01MMmE3bU9tTEVrdHY5WCtoY3loRmZLSjFuZVpKYytnUHVlOFc5RmErV1FE?=
 =?utf-8?B?YVhEZUZiVjVDeGg3T0pPT1pyMktwV0o0b21EazNhZnBuclJFNExZeHRnb20v?=
 =?utf-8?B?UVI4WHYzQVVuMWE0Uk45UFJyNjdRb2RobjZTY1hzVFo3L0M5NFYrU25XODB6?=
 =?utf-8?B?NUgweWljbURnNlZCS2cycUpFdzZLWlRFYkhFT1BDZGsyZFRKUVprdHNvVW93?=
 =?utf-8?B?L1ZCbGpobEN6bUxpTFR0bTc2dHZDd2U2d085VEpSdVBzejdRLzNXK29NRWNR?=
 =?utf-8?B?TFlvRGpjckd5L09ZamFDTjVqMFcwaGx6cWlLQjJyZHArRUJmUHJMZlpNRjdj?=
 =?utf-8?B?ckdOdnh1YmgvMW5CVTBWK2tGRzlPK2g0UWlWeXdVTk1YV0hiU292aFZvSFpa?=
 =?utf-8?B?WERORDUyS0ZCdG9YVDF1NEVnYzBiK0p5Q3NvVitpRFBBZDJRR0s0SlhUNEky?=
 =?utf-8?B?em5QNnI1emVQUmdNbFFUeUhuYjA3Qm96d01uWUNyK0hOY3BMTW9tR1pwK3pP?=
 =?utf-8?B?UUNnT3hlc1RnUldKdFZKSHZIbzV4Um9DVzhITUExWXhKNjlwYzFidzRoTnAv?=
 =?utf-8?B?QlczYUU0Q1VTN2xGUUpJY3B0emVMU1YyYkJOUS85Z2t2MkN4cWYwbXZDYTcw?=
 =?utf-8?B?cGFxalRxT3J6algwY09DR05HUnczUllCenJ1ZmRlNmIxUy9WbXQ4Q0lDaVV6?=
 =?utf-8?B?VVFUbzZqbzBYayttODh0R1gzZDAyYmRZeTI5WGtjMmg3KzhwckZIZkI3Ym9M?=
 =?utf-8?B?WDU5b253QmtId0dIR050SkxXRkFwaUs4WTdaRHZVVDhiTUxBYVk3SHR5dkFQ?=
 =?utf-8?B?OHRiOHJqN0hKcWZ3Q2V1cVRiaEpEQUFOY2JrOHIwTkJEZGRxUEp4ZDFpS2cz?=
 =?utf-8?B?ZzdYckRBQ3BCWm9lZkg0N1V0U3B2dHhkY1llZE5HeTlmTUhUZks5am9yc21G?=
 =?utf-8?B?VnlNVjE4enJUTVJXWmRDOHVwVG4zaDluU2hnWERUQTBhWUdRZmFYYUJZN1h0?=
 =?utf-8?B?N0NQbTZTdENQbitiMzMybkM1UGluTUFveVpMbE1CUklGaEVxSkc1Uzk1QjUv?=
 =?utf-8?B?eG9uSnpQSE54T3FtRDM0MDd1bzA4b05lMHhkLzZST2xxaVdGV1Z1VnhIcjlL?=
 =?utf-8?B?bG54MTRDeVRoeVZFNkFlcnluMDVkQTNmd2w1Wi9qV1RaSkh0WG5EbC9ndTM5?=
 =?utf-8?B?ZWREcW94MmFBdE4wbEVBZXB0MVptYkJ3ak1GdW9Nd04zdzdkRGlXcHV5aWRI?=
 =?utf-8?B?N0NJaVVrVVBFM3d5THZKNVIzNmJFTjRFS1UyV1kzbitReTNaaXE2SWhnaTZ2?=
 =?utf-8?B?MUdOaE9XdWZ4cGN3ZTlybFVua0ZKblR6MWhEem0raS93c3FKeithTnUxc2hD?=
 =?utf-8?B?OHJ2U0VzeGk0b3VSdjYyR2FlNHZsUHc0V0FmaU80dXR1SXBZaEI0OVBXZGpi?=
 =?utf-8?B?ZmxqME1qNXUxbmpDYkx2TDcrU0NacGVuMWVJeFZCbkI3OU1KUGJDOFRMZDYv?=
 =?utf-8?B?ZHN1aTVrQ1F0WDRTMFU5dXkvckVya09rZkZXN3F2UjFkVjU0YkpnMTRtQlhV?=
 =?utf-8?B?S1hyS292NzFPU3JjaFVPeXVRRlVvaEZXa2lsTnkrVWlxcmFzWk1hSzJ2S3NY?=
 =?utf-8?B?UjZwQmJJc0E2dURsZTMwRHlQVVpYbENMSHRNMWNsdm5uUmJ5K1NxZ0tjVzBW?=
 =?utf-8?B?S25jdjBXK1BZOVNtL0ZlMC8xQlE2WnBsaCs3aVZYSk9WWVROQ0JrdWk3UXNY?=
 =?utf-8?B?cHZiTFhHeHJDSi95bk1WUFRqNWx6bHh5eXYyS1hqTm8xSCtFSHNlSUcyb2tQ?=
 =?utf-8?B?TmhHbndIb1g1NzQ3NkFrUTNwTXhzSEdabFZyaFZTZFJQMzBmQXdXUnlaU3B0?=
 =?utf-8?B?S1pxZGROSHhGejJ6cVBWQTAwWndzZkVCQW5KTzFVZUsxWW51VDFUZ0RNTFk4?=
 =?utf-8?B?eFEzL1ZiVGRmYWZ1Z0ZJYVEzdEMrcmhjUDVFVGFBbmdYNkx2T0EvaUY0emVW?=
 =?utf-8?B?VEVSbmZBUGlNQURtSUhFWFNNZGJiUENzbkVsVXl3WnJkUHRId0pqSVFuRTZp?=
 =?utf-8?B?OWFLbVg0U0oxZThRb2hlbFRUckxzOEl0NTNwNmZTTm8zcGFWRWZJbHZ5OElU?=
 =?utf-8?B?ZGZJZm10MUhpbTJqd0NSRFJZQk5mMDZIQzc4aW9BMkkwZHdFTjNhNUdpRnJr?=
 =?utf-8?Q?GNRN1zXdvZKEIP8E=3D?=
X-Exchange-RoutingPolicyChecked: QyzoREzOlb8dJPFEy/3z/t2zQga6aWmnyj+OBWrZxRsrrGhFn8sqUdS6GE0ZPL/QuBQvmdqxT4h7FspOKER4ui+qDYuZdkewrXHgtLuGZH8rqYgVLsVb5K0m6IzOfflHkngM3Jp512NJWOpaKlGdYQ/HzVlM+vySSxSYXoAerr2ohIsgJ+7bjcXdBpCgZJYv+DQJ+htyXEGy9kQ7L+pTrpqJ+30CyGEgg2A9nVanrJQIwJ9898xt4IBAOmTk4RCAVR7QMi59IOXJ8s4jKGq+8UPK7Jwqd+U01T5IW7DtEkbXmgf6W2zLAc6AJVVwID+WoZXm80gZIS/T28TkS4MOSA==
X-MS-Exchange-CrossTenant-Network-Message-Id: bd13a8ba-2daa-42ae-72ea-08df1a4f8385
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:21:32.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kblsyod9mtffNpW47hGMLkzdd2Y8J49tvYjzeKF7aEI4a972uV80i7b2onQDxmpxOYsOFTAJcNHQDbqFdscbFIVAZmP/TWS4k7ZxhdFpf4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR11MB454219
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> cpuinfo_x86::x86_cache_{max_rmid,occ_scale,mbm_width_offset} are no
> longer used.
> 
> Delete resctrl_cpu_detect() and the fields from struct cpuinfo_x86.

Even though Boris already acked it I do think this can be improved to not
just describe the code in the patch, connecting it with the cleanup work,
and highlighting the benefit of removing resctrl from generic early CPU setup.

Something like:	
	x86/resctrl: Delete resctrl_cpu_detect()

	resctrl now enumerates its monitoring properties itself, leaving
	cpuinfo_x86::x86_cache_{max_rmid,occ_scale,mbm_width_offset} without any
	consumers. These resctrl specific fields are populated from the vendor
	CPU identification paths, unnecessarily placing resctrl details in
	generic x86 CPU	setup.

	Delete the unused fields together with the code that populates them,
	removing resctrl from early CPU identification.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
> ---

Patch looks good.

Reinette
