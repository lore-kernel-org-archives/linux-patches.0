Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6081F1CAA6
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412417; cv=fail; b=F8zXCktwBJY/H/ynyTjKg3oRUlT9KbovHyhA3H4vZXOK3zTi4QswIK5TPPjGr4iewiIbCyro2w0RYZL3R/UCqihFAhEKWSPnHYcWKZICDkY3CMPuApS9WwfZeZvL+VeMUJ/OnWnMQGsDYSCZ88JoXsyFXz+S1Mxin+AtAybW7to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412417; c=relaxed/simple;
	bh=DJUiMPXScKQSwxrziWTsVQzhsoYKxfoncfKyq2rp4wA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xj9TiDBDh/J8bQbXZXSa/f+nGXKF9yWLp8/CYJcu7IYTPWHdxNIEN4pMBATVGCbR1qyhAcHOShMr96LAIys6Sjpe1NeWp71jSTEDquQwdRmVZsIUGDwjwpMs9j1IqH6uxSgffiMy1ea5oBlWzQy3vc8u5NeEyEbd3EY7XXA4V1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpvHbLmk; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpvHbLmk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412414; x=1747948414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DJUiMPXScKQSwxrziWTsVQzhsoYKxfoncfKyq2rp4wA=;
  b=BpvHbLmkLeYROjmKE9hL1sx+vGXlTKhujaLJNN9FrF3KfV3MYNf2Om7F
   vNqpWVnnTwgn3aZAsgIzuuLhevwbhTyUt3t6C3UzedlcAvvYPzuK4mWve
   dID2g4O3WZkpMdCPiDw1lBl58EA7Nl/MCg/jpQEX3aIhgqW0CNyRDlKVL
   b96ucJRwKi0OiTCMpbHX9azBvu6uwpltokMeg4j1tISVsVWVdLBUi6KBv
   8kYJ/bcrXS/s6DIiWopN8o23UJPchhC7vv4v8NQ3uH6PUhPPKcBgfut/x
   CmqkPhyAz6x1J2YHTXsQNX+4437sM96LfvdQFCCyTErAIQ8lwyolW0gCA
   w==;
X-CSE-ConnectionGUID: 54PWoWHwRK22J5morKGG5g==
X-CSE-MsgGUID: 2wq3GT28Sqea9IdODBi0mQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12872653"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12872653"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:13:32 -0700
X-CSE-ConnectionGUID: T4107qdGS4+3aN8G8LfISA==
X-CSE-MsgGUID: 15lvU95WRkSYDRSR7ryZ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="64262924"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:13:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:13:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:13:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:13:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW0XzoOTkIRZb3R0/HJNxet5EItzHmbGckR6hrry1oct+LVzZAyle+28C9OKO8LwQPhbsKZ/1dR2ibWvmmyGOB4ilrFBOhsEOG3nvocKCUeHqfxA7fXoL9i2o3/XZCFwlW+DnafdQ9aBwenS/6AOxUCPRVzBoAhJeFbVebCId6fAoalar060mHGaLy8ud1J4Dq6rYPrs+tBVanEZUilIoewdj38TGg1h1GEkzNDVVS4u4lOFZMpInUlj4BfqRJNjkvLjzfBUemPEeiHiRbS1LjFCQWaLczNWq7OWKS7jtEKmzgCpwQ86vHTrjalp65bDLC5bUQay6Ch+2Sz4OHOoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FskDHHjEgcRZzGYoZidQ6q/fxUXRLAAurz998nLKz6U=;
 b=ac1LvDopvVCyudtbIgh21g0oiTIlMMgy5OXVlBwzGORsBu0waF8F0B6m+Gwv7XUaSeiwNAEfthZMLLNwj5oBUV4HvlUg8oXPu0Q9E7JzKC2bTU5pi39+KFx2Fn+jOieq/dUJztapr+x8g4WWfFYTtZtUIMD44hBQEHBX9Js9yELz7Z2R+ep06/a6N46AyuGGqafOUsQ2P+tQIPKpUFZkFOZdaeJxBg6AquQRfHBO6YlDl18oW4dr7jG23kEkNZp8r/xmfRHB1ChsNWnOssf6ynyE2mzFEuEvrs0l0BdnMqPG52/hiSCJXRkRVje8g4fg4afoVDTc0Zb6p8EdJIc2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7671.namprd11.prod.outlook.com (2603:10b6:a03:4c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.18; Wed, 22 May
 2024 21:13:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:13:28 +0000
Message-ID: <7571640a-2250-4e35-aeab-d25cacf2135b@intel.com>
Date: Wed, 22 May 2024 14:13:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 08/17] x86/resctrl: Add and initialize display_id
 field to struct rdt_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d4ddc52-c324-4b2d-94c6-08dc7aa40657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K0E0cjRjMmFyTEtmOXN5TG00WEdpZEFZSHNUNVZKNHFJRFpiQ1RIV0lSajBH?=
 =?utf-8?B?NFRacEdrY1ZwYXBCUTF6MFRIQXNHNXE1aXRVSng1MWRDM1VDYnBYbDB5bUR2?=
 =?utf-8?B?aGtzYkU3V3EyTnhhR3hkL2FONWVud0V2MkM4VHBLQVpPWk01eTZ3VXNxZzFJ?=
 =?utf-8?B?N3NHTm9DSVM4ZVJyYURoTUxnakNLWGtxQWExa2NWZU5KRXNxMU9Ub3hmSjQ0?=
 =?utf-8?B?WGhLK1hhallhNmgycGtlWUVDRytGQWhGd056VFVEYUgvdnBOeS9qZ0hpZWho?=
 =?utf-8?B?RlpzTGs5L01pY2NNZ1NVVGFoYkN0NWl1WkpBWUlkNVIwaTJBVE5kalJnWm81?=
 =?utf-8?B?SkJ2djUzZUJjRlF6VnJycHY3T0JMRnpTdkQveDlabFJ3dFk4MUZhanhmUkg4?=
 =?utf-8?B?UFZ0RUFKTlNJeE1jWWorYjlmWHFocitCZFp4YU53RkNybWtSalNEaEl4Tnor?=
 =?utf-8?B?RENMZ0dOTGtzRDNRNkhKbFYxWDVFdzBKYTdNUlB2S0J5VVhlbVdOWjZzTnQ2?=
 =?utf-8?B?V1Jia1RqT3JoR3dLZFVQVzFSWEs3TUloNnltb25KL0xBbGVjYmJ6eGkrZFc0?=
 =?utf-8?B?SHNMVHBBNzY4QXUxeEdWdXJ3RCtpVm0vdVZhNXAwdUNlU05PeXkzcm12dTRm?=
 =?utf-8?B?MWpJaUp5bUV2eWdUeklVazB6Um50Rmc2eGVnb204VldIb1ZDZXpHOG85MWtn?=
 =?utf-8?B?eW1BVGxqZENxT1Q4b0tiZWRrWUdyLy8zSkVmYnlDOFVNT0JZTGxxMFBNeWNQ?=
 =?utf-8?B?TENQTEV3YTl1ZlAxeGl6c0x3YzJIMkZzQnlaMGhWMXNOTThyQXJUTEpCZUx0?=
 =?utf-8?B?MkNINHd2ZVRLeVhXY3duQzdxYlNncUozVDVETHE3WnVtdE9BVHRhRzlxbUlS?=
 =?utf-8?B?eGROQ0NLOVlUbzYwS1dIS3lQd1kvNjdmc2oxQlIwbGkzaGpJM1R0bUc5QzNJ?=
 =?utf-8?B?cnpVN3NZSU5pbWJaZmZJOUJmMXZOR3pHaExYREsxaXpMbjdiMkkwSUNBaE51?=
 =?utf-8?B?bjdWMlFURTZrNFRyUmZkeFdZbXJwOGQvcDRZMGRBSmkwK3ZhUE4zNERXNmZI?=
 =?utf-8?B?QnlqZWpQaWZTaHhqYW9ub21BZjV5TnBjT05kdUR4dktjc1RkdGQ5b2Y2b0R3?=
 =?utf-8?B?K00xRzAxbU9MUjRIUVZ4YUgwV2hrMlc3MCtmTjBkeVA1SkV5TU8xSXc3UGpo?=
 =?utf-8?B?dnJ5Q3JxdG1UQnIzM3B4WU9BSDVwUVczK3JpRVRyVUlQN2l1ZGhsdHBQQlZl?=
 =?utf-8?B?SlpBdUZiQzNYS0FCemxCU3VCejltWWxLbXpHYVNXU0hobktnUWVoS0FINGVi?=
 =?utf-8?B?N2FsNWFWWW5oUUNiQjB6eHp0Z2NJamVTUEI3RkxmdzRTMmdDTHhSL0NsdmUw?=
 =?utf-8?B?clErSE40TnJqdGhTNW1MK29OVW5GbnN5d1dPNkZGYnRZYy95T1FNYVhnMzRH?=
 =?utf-8?B?MXRiS1pFU2Y1WWlFdGppbGhOYnJtK2JmT0dwYU11Vk1JZUtDY09VUTJKYnZt?=
 =?utf-8?B?cHlkU0c4bDRuL3JhVTBCRmlHQnI4VkRlRTdSVzdMS1RqNUo5RHU3SWUyV0x3?=
 =?utf-8?B?ZHN0cVBVZU10ZVRGbU5BWVdOMlV4OFVIdHpyLzRGQzJxNmlrY1ROUmsxVUU3?=
 =?utf-8?B?SzdHcHpPUEpmcWRmRHV2SFZ5ZmtxcEx4dytVNHpVcWRoZjc2dG5LSlo0T3VI?=
 =?utf-8?B?eTZIU0RDMHlrejVyU0FQV20zSDBXK3V3Uk9QWXdSTVl2cDA1WG1HRWpRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVZWUUpFTzBQUG01Umt2bE0vWExGbTBDSzJoUEMzRnJ0WFY1d2p5SHArNHJS?=
 =?utf-8?B?RGJGaUFGNjA1UzZmVEdiV1d4WDluQWVISEZ1NEg0SW1FUEx4My9rYjE4bTZT?=
 =?utf-8?B?ZjFrbTJJSldVVmhZM3pVcTg1T0prakNCQnJnZHM2VHhuMUJoalY4bCtkbGoz?=
 =?utf-8?B?bjk2Z0JyQzhMOUNjWk9HSlc3TUZiUzMzVkFWbzRIL2pOZGZDQjlGWEJaUUpi?=
 =?utf-8?B?R2hLOFhpMjFxL2ppbHBvY2pCVjY0NmYzYUpKeFhMTC9xeHNaTEc2dS9aK3hW?=
 =?utf-8?B?R1ptb2xvVEJQemw5dlhVNkdlSlNUcmpDU1c3NGVCckJrOXFrVWxWWFlyOXhC?=
 =?utf-8?B?cDVNYUlYNyszcVlYckRLS0h3SjhBUmNZNE9VM0VuYWpIdUNOdXNQbnkvcFcx?=
 =?utf-8?B?eFFvR2U1dCt5ME13YXpreEVnNU4rSWprUUFoWDhvSnFZcTBGMmZxVHZna3Fp?=
 =?utf-8?B?azgySzdUZlBRWUZ1NHU0QzQ3dDRDcGExdnBZK2E0cktCVTI4U2h6Qm1qRyti?=
 =?utf-8?B?NlVIZEJkUnE2QmUwQkNGcm5ETjZjOUFHTzNYeHNjTmtHNjk0TmUzUGdtUEF2?=
 =?utf-8?B?YTBTZXkxUFVQMWJQZU51SS9mcFJUWGdUVXEyTFZVaFlDcFZ3MGtDL1lPb0tO?=
 =?utf-8?B?VUgySDMzS0FrZnI3NWZpa3RZNHNFUVNQd2RiZm02M2VFUTREMUd4ZUkxRDJ2?=
 =?utf-8?B?RnJMc1F1VUJ6L0xkanRFTDlWU0JQaWh2ajFCVG0wMURTdlNDRStHMDNzVk5V?=
 =?utf-8?B?K3QvcmdSVEtkQklmRXlNZkYrTXcxcTBjWFNUcThKKzZWTVMrcHEvNEN2N29Q?=
 =?utf-8?B?YnplM3R0Vzh3cVJhdURicFl0M1psck5BSTdPR052c01HUUVHZHNiRWU0Ty9J?=
 =?utf-8?B?bXRqZ3MwWmZVVGUwMlR2RzhGTktJV0xqVmFHVW14N1ZlemRmeU5IcUUzWGRq?=
 =?utf-8?B?TVRxWlRyRmlEdDVkV2JDdHhFTktuWHdVRFZnNVlJSXozeHl4TmVjQUpQZ01Q?=
 =?utf-8?B?RmV4T2J0Yll5eXpEMHhEREcyV3pQc244bTdnSXY4eVFHMlBBY3ppNE14YzR1?=
 =?utf-8?B?SzdIOXQwWFFyQzBodzlMMXJZV3QyOXJiejFwT1JFV3ZpaFNPNmNzVm1Od09X?=
 =?utf-8?B?bklNT2R5VEprQkhEL0E3bUJrZmRzWndUd3RzK0lmZVI1UlBiNk1aL1F5MkZl?=
 =?utf-8?B?LzNaU0M2eklMcWVyZHU3Z1Q0cHpsK0dSZmVEVjZMSyt6WG5QN2ZWZjlQSitD?=
 =?utf-8?B?Q3hYdWhpV2EvWWdsTS9MOER0VVdGMWJrY0dxbm1zTVRqT2RDbjFySlQ5ckp1?=
 =?utf-8?B?QUxsTkdqR1NUeTVHNHFiSFA3SHRSNkhEQnpkTFR3MFQra0YvVWc0VGpPc1c2?=
 =?utf-8?B?RytGYmhOeWVqZ0ZVWmlQNi9tNUhGZXVGQnBWQzViOWhhUkNjMVJuTVAwem94?=
 =?utf-8?B?bmhIaTBwN2ZvSkxLaDlGT0RCMitXUFlZTGQxVGl5czZqVUh0RmhwR2VwQ3JD?=
 =?utf-8?B?cW9jd3kyTm5QYnh6aEJSSUhMbkduRTcvSDhUU3VPWmlQN2FpbllSbm1jd1ZG?=
 =?utf-8?B?VmpidzhLb2lBRkhJb01nUmxnWDRGNlRPYUlWYlV2aXNySFVPeGRtYXgwYlZ1?=
 =?utf-8?B?aiswckxoTUhjdlJCZGRodTU2SjJROFp2TldVWldodjZkdkpMY21FMWlMa3RO?=
 =?utf-8?B?VWw2ZjN6cFVvVkdPeXYvSTcyZzlkVjFLbXRSVGRETFd5TEUyVVRZRVFVTEti?=
 =?utf-8?B?eGZKY1VuWUZEeXJzc2V4S0EvVmhyTUZpcmJxMXJva1BkWWRZdWZZM1VLWnlU?=
 =?utf-8?B?ZEFBWktzZWYxemwzSXlPMWROK2J4a25QbFRQVHErQmczb2Fyc012YjBRajJ3?=
 =?utf-8?B?dUdMdDRzTy8wemRXWjYvd1lkcUVUcGZUQWgrd0g1MGExelF3Nm5malJMN3Vx?=
 =?utf-8?B?UjQreUFxVHJKN3IzR1BuaURxQm5ETlVDVGRxWFpXa0FKV1hodEhMVkdTdVA4?=
 =?utf-8?B?cWtlRXRIMUx2WkhROVdXVHVGd01nVFpwU2F3YmVuKzMrUGxKRGJudlJKZ09U?=
 =?utf-8?B?dEk3b0RaSzBuUWlJMjlyb0J4NjZkVnFmS1lhWHlWZWVsSUZPNkx0L2JtaENa?=
 =?utf-8?B?WC9va3hqZU9GTE5lMmR4bitTb0g2RjdZQmY2d1FiWU43SjdRUm1Rd1dFSWVw?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4ddc52-c324-4b2d-94c6-08dc7aa40657
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:13:28.0482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftEGa6cL3sQJ2uneCwa8gAiFUyb7+Ml423cf2rmJiUQcPpS/e34kvxsTZB+RZA4dWNDbt0W32mHwwrA7S3uJMvlEtHlZ9JjvlARXFEBF+to=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7671
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> When Sub-NUMA (SNC) mode is enabled monitoring domains are created at

Sub-NUMA Cluster (SNC) ?

> SNC node scope. Add a field that holds the identity of the L3 cache for

This is not necessarily the L3 cache, but instead intended to be the
monitoring display scope, no?

> each domain to make it easy to find all domains that share the same
> L3 cache instance. There are three places where this is needed. In
> all cases code is operating on a domain where "d->id" refers to the
> SNC node id.
> 
> 1) When making monitor directories.
>    Need the L3 cache instance ID to make the mon_L3_XX directory
>    that will contain the legacy monitor reporting files and the
>    mon_sub_L3_YY directory for this domain.
> 2) When removing monitor directories.
>    Similar to making directories.
> 3) When reporting data from one of the L3-scoped legacy files.
>    This requires summing data from each SNC node that shares the
>    same L3 cache instance id.

<insert motivation about why this cannot be determined dynamically
at the places identified>

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            | 2 ++
>  arch/x86/kernel/cpu/resctrl/core.c | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 98c0ff8ba005..2f8ac925bc18 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
>  /**
>   * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
>   * @hdr:		common header for different domain types
> + * @display_id:		shared id used to identify domains to be summed for display

This description seems to indicate this is a member only used when needing to
sum domains, thus only for SNC at this time. Looking ahead the description does not
seem to capture that this value has been integrated into non-SNC support and will
always be used when creating files for all domains, whether SNC is enabled or not.
This member thus seems to be used for more than it claims to.

>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
>   * @mbm_total:		saved state for MBM total bandwidth
>   * @mbm_local:		saved state for MBM local bandwidth
> @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
>   */
>  struct rdt_mon_domain {
>  	struct rdt_domain_hdr		hdr;
> +	int				display_id;
>  	unsigned long			*rmid_busy_llc;
>  	struct mbm_state		*mbm_total;
>  	struct mbm_state		*mbm_local;
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 15856254fea7..dd40c998df72 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -614,6 +614,14 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>  
>  	d = &hw_dom->d_resctrl;
>  	d->hdr.id = id;
> +	d->display_id = get_domain_id_from_scope(cpu, r->mon_display_scope);
> +	if (d->display_id < 0) {
> +		pr_warn_once("Can't find monitor domain display id for CPU:%d scope:%d for resource %s\n",
> +			     cpu, r->mon_display_scope, r->name);
> +		mon_domain_free(hw_dom);
> +		return;
> +	}
> +
>  	d->hdr.type = RESCTRL_MON_DOMAIN;
>  	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
>  

Reinette
