Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497648EC89
	for <patches@lists.linux.dev>; Fri, 11 Sep 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142215; cv=fail; b=W2LCOe/z/iVFFAnfRZU0nqXagJnyscREccnwyS+9KaNCMMo6b1W2aEsz42WhAKsArX7CXdzfJQLbvU0mq/ZiQcG6AuUmZRpNPjZvNW7l+qaFhbiGFIyLEfGkPILPD+UXu1LpKU7NNn1IGk2vIA/X7h7zWQgJXOZiqADVPR8jNxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142215; c=relaxed/simple;
	bh=2K7rH004sYH5FlXvs6oYDvZXSWUNqgCRvbWXHD0p+TE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q/ifiCXbqELkxulxa7wyetP4T2v5uwDBnEzLpREtv1k0C5KwMvf5BLJkhqZArKl7p1mA3Phyhqfg7ghyX4YBheQ8H/kj3lRZCQrFeYAP7jW6LEgyk6Spkc6jwpvoLlqfkbNX86/yYRngkks8Rnn/w5/1dK2/ITxgmBENBWjEzxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVehaB+7; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVehaB+7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789142214; x=1820678214;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2K7rH004sYH5FlXvs6oYDvZXSWUNqgCRvbWXHD0p+TE=;
  b=LVehaB+7DPLrfG48f1KriTEdRlTSdacPw8ZznUruahHo53C/YN9UTY/+
   360dfHDBEAa2IXqMq3gku4xUbaAXKhvHslALv7NCRKqCkAYGVn6Sgctf9
   eBPLO+ktpT2ZD7MHg6u3TWwTibDTF4L6LDof/0LyCq8NYeZVgLedw9Crv
   6K8Nsj4z/8YJQtiRAVZ+6EsdV6RUeAZ8/phyDKn29sU81GTwW/S1Lf056
   qFo1YXHAQ3uANOuWBihcTnC1OiSPTfgYCW3HpgA9XfmRkVMqTaeyeUDCH
   0bBUaOHpvIR3uRsn/1P1D0xwJpmFkVH7rrr7zAVPi7UHu534Cm3DaV7xZ
   A==;
X-CSE-ConnectionGUID: 0zLx32h1Rvi9wiBt+bIO4g==
X-CSE-MsgGUID: cIo4qFp4Q8yRThHvdzf5kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="101129271"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="101129271"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:56:53 -0700
X-CSE-ConnectionGUID: oK/46t9OTx+/BVXmUMOpuw==
X-CSE-MsgGUID: GQC2ZGQBRM+svU28W2Qvug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="275475925"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:56:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:56:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 08:56:52 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.48) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:56:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBfBYem+lysPmLvtJnvYR+E+StCrCjV9dY5E8W6l0CsjdTYUuycAmk5y4Dt7xNOW6p49qyjGhuiWIOMGLroGyaJVG6/zoiKxLryjGzo1vx65m/NQ7xVEiqKqgTVfXYVvOOUjvvNTxHNWTvZNQCSk8IgIT9mMoDaazvu/XQnD7+lSYOuwbjyDOKJKi/27AZwXlvqTkp7pkT2cpkvA3tTMsDe5v6QRJgAap3KdEInaHhU5hXg8xP5OfyHOBphbXYiHEBKnAm5ghvLHZUmDsvd38w4+G9a47XhbyyyfyDEdOuP0/1WyO1dp8ry+m2mehbKlsc9PXDT37ES+IekwXCjToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOMHPN+FVXsBt/zqHU2pgZuWFdHi1YFvsx5WMOP8PFQ=;
 b=BSrTiH9IlTnQVVLULh6vN/rBZ6B1KD9+01Q+YNMABGD9MvBk2phIsZe9UPdxW5cytKcdigHbPebjTh9dS34CKQAk26f0SLyXgo4rC5wLKCtxSa7uYKrKXxyWX4CmJbNL+xIFt0IQ5TBbf+vgJWk2YL1GHrQQByrzmc9C/8Y4hNRGxgZGaX9qz8TDDYnLWSKQw9CVagiI3AzURmZi7WzNu2XxJJM6RJtHAAFTgGtUGr2NiIoGa6NuC8U7hKY+5g8Kt2P+KgyhzmSn00G0QoLyLbGKl2neZF05ukGSptDIVRmaHeh7KHeOKdZHVvlJyyXvFQHH4ZoGrOeZZ/FyrAYkQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB8322.namprd11.prod.outlook.com (2603:10b6:a03:549::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 15:56:44 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:56:43 +0000
Message-ID: <6cd4a7d4-6f93-4970-82de-be483fe45267@intel.com>
Date: Fri, 11 Sep 2026 08:56:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/23] x86/resctrl: Give better names to X86_FEATURE
 flags for monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-2-tony.luck@intel.com>
 <2a814a14-2717-4363-838a-6585557baf1a@intel.com>
 <aqNGFA6JtddxEn54@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aqNGFA6JtddxEn54@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0364.namprd04.prod.outlook.com
 (2603:10b6:303:81::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b37bce6-f6fb-4c01-5d6c-08df101d4697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|3023799007|6133799003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 7XImDNud3OcR6qz09fyh39injyrfdhtOZNYICxQ/ueojafa3QlVvs4KatCqGE3Vok7QGukEEt7hquD/D5nKU5bN2gEmjpNzKuY4/lDYgLfbS4M9jQwfb0KC9d1WqpNWJ22wmsZm/Qtk8BQyWP9XpE1WWMOiXGNn7NLCUFkGNqULLrBDm5Of0kAkzgUPOBnJG6d1+McNCLAw5zg3S0tbU5uXaSGt4oo87El1S7IJwysskTuahx3BUwC9rVA7PTP6K38y0bGfEFgpsFmDVl9Galy9ZePr1Qg9WQkpNQwz++eYe/SXTvC62u3M/SQ89PNrfsYN8DObOvjIxV8c1RACrk533Dc4O0oyXu57FKhkpY7JS3zb8OY6ta9jOnZkTP8eVKGd9MupdB96FJ79455yWvMk88Yu+PPAet6EqmmETHZcsnSbIJYkcaUxMNT+fdr14v4o4d1Xm5wII1YHU98F9VtGXzZTxvzorHmjXUUOzYeQywYGEc8NeZpwDSdqjyYv4zhZl7cxh3bT9dvnMpNovAfomNn8MBk2xQRSmFGr1oOZyhFiWWiv6VIvHzVbRfmOvUSjgFTc5/G5v0zGnItyVTMOqwPf/KdAVJPzjqNS9p14GxZ2nuZO4d1UqZhYCEtFm2R17RhHAUam9fWW21PnkpRdRYE+Vhf30b2bhpX7nui8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(3023799007)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Und5c3pXZXhheVRodWRMQ21laWdhekpMVG9ab3A3cjF4QUw2Qm1MNm5OOVVD?=
 =?utf-8?B?bGl0V0Exa2RMMEh4MUpRWmdRb2liL2FlUEJuakMzd2FnMC9vNGFnRVF4Ui80?=
 =?utf-8?B?Z3RQMmFSQ054ZThEOC9UR2FadDhoZkE4RTF4L0Y0TUQ1bjJyY0E1UG1nOFZF?=
 =?utf-8?B?aWUxbFFZaHlKYTBBbXRQMDNSSGRKbEszK2VDTU5oUmFJcmtSMjNIbGNmWWdl?=
 =?utf-8?B?V0lUOFZMRWNqaGcveEhZMFozNjRoNTRQQlZEc01sOHQvQzIvekR0OFdYd3dq?=
 =?utf-8?B?VHJtWEVjTHRsR3BNS3d4SGRKK2RzTnlyOSs1SDhLRGZON0VVUlRmeU16UU4x?=
 =?utf-8?B?QnIvVXF4RnUwbGdrZ1dtOEUydkJpUDlTZnI1WUM4WCtqNm5Ob3NJcnVuM0JB?=
 =?utf-8?B?bGFqR0VWYWhVUGNEeG8wY2dxam1NcTlLZmZuNTVCVHh1Ykpqb2ZHOUJLSVZZ?=
 =?utf-8?B?YXQ2cXU5UHZnS1pXVDRkdmlyQ09nVXpuSkVtVUIzZ1pJVVNxOXpHUCtNQkh2?=
 =?utf-8?B?Mm03TWFuTVhTYUJPWWpMd2t1UTlzSy82MnZwSGJXSTN3STRUdVluK0VZbDBG?=
 =?utf-8?B?UVdxYk9XTys0TXp6TytVanNoRERuaXQ0U2k1TyttZ1RiN3RmKzRubVdPSVJs?=
 =?utf-8?B?eHlSVHhtUFhQM0xvUERnblY4SjR3UU90WmVxWkRiMnkxb0lhUnZrQzBqVzcw?=
 =?utf-8?B?VXl6QUJLR2pXSTZkZWttLzhOTnAyOHhTUHBydzZ6Z1FFUERObmNiZjZuSCty?=
 =?utf-8?B?SGk1TDI5M3ZCTjJFVm5KcVpVYS9sMjhON0s1MjUxUmZMcElzUHd1cGlyeHB6?=
 =?utf-8?B?WjNBREU4OTJtcXIvRmwybThpRnRONlBESmlZejRDcTN5Rnl4QjBnM0JpTUNI?=
 =?utf-8?B?cWlERllqR0ZzODVyT1U1NlM2dGlxelh3UXFrd0YxbUE5M0loZFpIK1d3S0No?=
 =?utf-8?B?bHJJWEgrKzIrUURKaHRoc21TdlNvelE5ZFhtSEZHWDhsM0tBUzJFSThSRlVL?=
 =?utf-8?B?SlVVd29jVlpMY1o5WWg3ZGtWQnFtWHI2VC9OTnowTkF0dkg4V1VHMEk0L3Vr?=
 =?utf-8?B?WWlJckF4RnR2NUU5dndOYlhaSXA3ellJTUtudndpZDRYZUNBSExibEJtWDNX?=
 =?utf-8?B?SDV3VDE2bW5GZlJqQXVVUWhjYUxsYU5BS1JhMWNSTnB5aHI5cEg3YmRRZHdY?=
 =?utf-8?B?SUNUQ2krQS9aU3dnYjJWSC92bFlvb0ZpTWpFOEU1QWVhRXh5S3lEclBLVUJJ?=
 =?utf-8?B?Z3hZc094UnpLUUM0SS9rdDFlUVdwQzhzUDFTQWFVQzY3eWMxUHR0bGMwWjNi?=
 =?utf-8?B?dklkNEJCei93dFh2Y2hGRGhDUEk4VFROMjhCQ0s3V2VuaWhSSXhMVm5DWjJR?=
 =?utf-8?B?eTRoczBlNllRZjU0M0h3WlMwRW1hOENDOWxweFRTSFJ5Mnp1SGRDd054c2w5?=
 =?utf-8?B?ODJKSFRJR1JFbi9pVy9xV2J0eHFWeDVYVithdUlHMnlvOXNmMmVLMW5oOHNO?=
 =?utf-8?B?blpBOTZ1cHRyTld6dXVLanI3Z09iVDE1ZjR1Q3dZNWxLbDFUbkNaaWtkbEFw?=
 =?utf-8?B?Kzc1ZjhkblQ0eExpK3ZHUzJUM1BZbGIzRWdPTEFTRXdsMmdkQTZmUVN2Wnht?=
 =?utf-8?B?eTdFUkg0U2plVUJMS2hyVUd3dlpEMXoyZG9ENjliSS9ZL3hVaDNHOG1iNjBR?=
 =?utf-8?B?UzdhTkJBNDkxc1lGblEyeXpDdzFUeXNjTmdBVjZJMXY1ZzZLYXJqSTcxUURz?=
 =?utf-8?B?SW1BVWd5c3VUbE5GZFFmVXFaOWhscmlOY200YmZEUW13a2k4dnYyaHlSSlB5?=
 =?utf-8?B?VGp2aWJGSlpMb1ZjT1Nkc0lHM0taN3lvT1pFbmVxSk5sckV6ZENVcyt5eS9s?=
 =?utf-8?B?TENnY1BjZDd4UG1XUGUvT2lXQ3VPaTVQMTc0MjJHYTBCeWFFZCtTL0tRZ3hD?=
 =?utf-8?B?cGU4M2x0WkV2bVdrYy9DU3RXOWcraVBZdTBsU0hKbEVEdExWemkzOXpPazZC?=
 =?utf-8?B?RW5HblZ2aTRtNTNldDA2djJCZmRJVlRJVUlqNFRaTy95YjI5Njd4T0Y0aEt6?=
 =?utf-8?B?SER3S0Zub1MvM1Rza1NiUU8zM3FLUS84VVdVc2hMYTE2YUpJaDdJcWVhSlU5?=
 =?utf-8?B?cHBEL3BCNUNCK3dTRXppcGhkQ1UxWU0wK3ZBRVdGbFlZR3B5dlIydTJKNjJy?=
 =?utf-8?B?RzFBV2c1Vi91RnR0a21vSmVXZEtpdXBNSzNMQ0NCUkxrWTBDMzFxZDdCTWFU?=
 =?utf-8?B?Z244Y0lrN1EwZjNaUzZvMXkxd0pCZ2libVNERmZlRXJ1MzEveGp0ME5yR1pw?=
 =?utf-8?B?am84Q0VzM0tiT0dUUlNaSVpSSnJhS1ZEcFB5UjBsN1NiLy9PNmRnL2ljOWhR?=
 =?utf-8?Q?sftrgdE7RQ7GVios=3D?=
X-Exchange-RoutingPolicyChecked: 3Ok6IwXrz1qItdLyecc0Vjg1cfwbryPPdSdOdYOor63YCaK/t9xT5T1cXSigHPCdxuvXYCe9iCnKoHJ9Fdi27Lw2P/9sFjz31MMTkwGHvR9mmTE2vzpQkF8PRL8ds4C8nrKbfT9PKbTHKd1oQE8dFzLigWt06qOQWbWYQPCqFVDtJ92HORuceUKbhoxY/GH1P253oZqBoxRS8re03jlTcwb8fA4yiuVEOE9U9BA/Q4Xade3sHHxxXtGR7EpVZ70IL0A3LA4EV8uToDK+WcenWrQSbLr2s4qplZgrgXDSHNm6zZpM/Z+fwutRzDN5Vz71NOrumCLnFESrSW4+54qtbA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b37bce6-f6fb-4c01-5d6c-08df101d4697
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:56:43.7437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prEdgtRgCSv4my6NHC1LwK/gw2uAvdqnCZbFdMPu/63hq+t0kWFcD67P6sx4gaCQV6iDqDbN1Xg4U6aeGhC65uMwcz1amnf8AKi6ypdlewk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8322
X-OriginatorOrg: intel.com

Hi Tony,

On 9/10/26 5:06 PM, Luck, Tony wrote:
> On Wed, Sep 09, 2026 at 08:48:01PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> Please switch the subject prefix to "x86/cpufeatures:" to highlight the
>> subsystem changed. Considering that, the short description could mention
>> resctrl instead, for example:
>> 	x86/cpufeatures: Give better names to flags used by resctrl
>>
>> Although, I do have a question about one rename and depending on that
>> outcome the subject could be made more specific.
>>
>> On 8/31/26 10:43 AM, Tony Luck wrote:
>>> The feature flags for enumeration of Resource Director Technology (RDT)
>>> capabilities were chosen when the only feature was LLC cache occupancy
>>> monitoring and they were given names using the abbreviation CQM for
>>> Cache Quality of Service Monitoring.
>>>
>>> Additional monitoring features have been added to CPUs and the names
>>> are now more likely to confuse than inform the purpose of these flags.
>>>
>>> Rename X86_FEATURE_CQM to X86_FEATURE_RDT_M (to match the Intel Software
>>> Developer's Manual, and for symmetry with X86_FEATURE_RDT_A).
>>>
>>> Rename X86_FEATURE_CQM_LLC to X86_FEATURE_L3_MON since it enumerates
>>> that some L3 monitoring features may be present.
>>
>> Considering LLC as synonym for L3 it is not obvious why this rename is needed
>> (more below). 
> 
> I'm concerned about the "CQM" string in the name. This stands for "Cache
> QoS Monitoring" according to the original commit that added it:

ok, but the new name does not seem different in this regard.
Current name: X86_FEATURE_CQM_LLC, longer meaning: "Cache QoS Monitoring LLC"
Suggested name: X86_FEATURE_L3_MON, longer meaning: "L3 Monitoring"

As I see it, the "L3" in the new suggested name implies the L3 cache, the LLC.
So the only term in X86_FEATURE_CQM_LLC that does not appear in X86_FEATURE_L3_MON
is "quality" ... but looking at the patch this term (via "LLC QoS") is kept in the
description:
:

	-#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
	+#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */


> 
>  cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> 
> This made perfect sense when the only feature was LLC cache occupancy.

oh, hmmm ... I do not see how CQM implies "occupancy".

> That's very clearly a useful metric for anyone interested in cache
> quality of service.
> 
> But the next two monitoring features added to CPUID leaf 0xF subleaf 0x1
> were memory bandwidth monitoring of local & total traffic. These are
> only peripherally connected to cache quality of service.

This does not seem peripherally, but instead explicitly, since these features
enumerated as events of the "L3" resource type. 

> 
> I realize that this argument is somewhat undercut by the Linux naming of
> those features with CQM substrings:
> 
> #define X86_FEATURE_CQM_MBM_TOTAL       (11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
> #define X86_FEATURE_CQM_MBM_LOCAL       (11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
> 
> But those seem wrong too.

These features look to match how they are enumerated from hardware via the, quoting the
SDM: "L3 Cache Monitoring Capability Enumeration Event Type Bit Vector (CPUID.0FH.01H )"

> 
>>>
>>> Add missing dependency to cpuid_deps[].
>>
>> nit: dependency -> dependencies
>>
>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>> index f70ee74b5f92..6a7f0adb123e 100644
>>> --- a/arch/x86/include/asm/cpufeatures.h
>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>
>> ...
>>
>>> @@ -285,7 +285,7 @@
>>>   *
>>>   * Reuse free bits when adding new feature flags!
>>>   */
>>> -#define X86_FEATURE_CQM_LLC		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
>>> +#define X86_FEATURE_L3_MON		(11*32+ 0) /* "cqm_llc" LLC QoS if 1 */
>>
>> The original name matched the description and since the description needed no changing it
>> is not clear why the feature name needed to change? I do see some redundancy in the name with
>> "LLC" as well "cache" making an appearance, but none of that is inaccurate, is it? The changelog
>> claims that the name confuses the purpose. How does X86_FEATURE_CQM_LLC confuse the purpose of
>> the flag?
> 
> See above ... 

I'd like to highlight again that the description, "LLC QoS", does not change and since it so closely resembles
the current name the new name looks unnecessary,  

>>
>>>  #define X86_FEATURE_CQM_OCCUP_LLC	(11*32+ 1) /* "cqm_occup_llc" LLC occupancy monitoring */
>>>  #define X86_FEATURE_CQM_MBM_TOTAL	(11*32+ 2) /* "cqm_mbm_total" LLC Total MBM monitoring */
>>>  #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* "cqm_mbm_local" LLC Local MBM monitoring */
>> Reinette
>>
> 
> -Tony

Reinette
