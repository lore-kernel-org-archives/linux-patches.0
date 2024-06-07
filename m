Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DA914005
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717778960; cv=fail; b=LlRVBsvI2sdKbwetHtkR/somV+dIGj3JM+s/cIqGfXy1r+gWazMPSaQZo36SdCg2oPAX7OrP0FSdB/QTR+PuX46aXzqr9uXh+7uqtvEackIOs+XjMpoZpcZhiNyZwDbB9bDC3UB9miwOv3DevfVdMY4tbLjPmMSeBzzPXvALbNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717778960; c=relaxed/simple;
	bh=box+siwQOS3k1rhs3IJw3OhqahsWFsfS57frBYuqOm4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WA2w3KZMqgqnj/Y/SlbaXtg7jge30fFRoxp4Xxg0IwIBNteP+XemeBtvt/eFZZOGd46PG/y4AcM9ZDPmJREi5vC5Nu1hDxmVacoqFfHNntcpjEHffhcPjMbv05ma6x6RGFF4a0tE9VKx1eedKsVO+03Ne+G3mhnlsQ6j1QcTmU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d1ivDIMf; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d1ivDIMf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717778956; x=1749314956;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=box+siwQOS3k1rhs3IJw3OhqahsWFsfS57frBYuqOm4=;
  b=d1ivDIMfLGL9VAbe7z6k3TfipLQjQ1UL/RADZZP5S+iqZ4kMUK4ArKtu
   d8HQok8HTaJcF5zzlS8yvE/uTII5CeucmPvtv2onDCGWGa1BaCQcu/JdL
   5FPJJAdy5sIXe+1/AR+fcjHNUcKLjFQB9HNrpRtIdACtWX4paLGwbg0sF
   VuJY4OaQeSK05zFSmiPFoDFDVHvCg1CB0WvvjU7w3Ywr6E3DVJAQGklHK
   Mw/WoQRQu4uB8s7DsQpzJmokUKRbBXiuXM+PbD0pYp80Nkok0LKafLX/L
   UTa+8ZIGRXFx6KW4uuF9BzJzgg4/F6KBP74tAea2wbD8el5g5ozR5O8G2
   A==;
X-CSE-ConnectionGUID: BRkzE4BDSyOgQ7cb8d56Pw==
X-CSE-MsgGUID: pZ8wKDA9SFqh8VC1mWo2Tw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="17435882"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="17435882"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 09:49:15 -0700
X-CSE-ConnectionGUID: r95Bg/ztS7qtg9ZMT7sLvg==
X-CSE-MsgGUID: KAU4Gp4BRqmlJbZwtwsPYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38501480"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 09:49:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 09:49:13 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 09:49:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSFdqbSDM3VxP9VYHqJLjFzgx8SepcTy2y9HgYebXWmRth+cfB1kyNJ6trpydHXpNh+7esK6MjoWfEqlNn29PtwFBa2zyuDXecwASYBXE8mqBjMQvz/QOqGU7C4ufwbU7JSy+zFHkM6gGcUnjurJM6rJ0izhhyRLVWHPS7hrD5vvzzLcF5net2iJIc95wV19R9ndCeP1rRiAF9mc5Y7T4amgRRM1+UTZqPKNUl/1PjA04vtkfA0PiaxbrHQZCYOW8192LMVLlhtZmofSDifaJafoNDi2nJ/siTwwkRY2skA4QqFMK2MiqEjT7fSVDuqht0etjo/A9KqaOELEqV84nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQJP/F6i1LkrUYv/qnUh3vUUz8NflW6sL6Ajg1XQF/Q=;
 b=aUdr4n5t38g7GlkSkI/VGxSgG9WneqlsdkTHNGTY2BsYDhiLOtDjxyGiDfMy0WmhVF+SEmGJciXWkXVEhNxHjzDi+IfApfdgFl63Boqxz/FQ1hJlSOCRVsQzjJoM9zfGoqekbiJVIv09oY6lAq/nTnX2FUT96W55OzK0iXONpX5fsAAL5yDtleKTpKNijfvHGYiMLD5RQ7PRwoNlCph39KQusE2reU6vBf/D0B7mGmKDT6j8EE+s7U5AK+U9Yz2p/ZY8lfu2F5GzLjFr73Hf+bCgAZyl8lj99NxLRSzXRT+9/g3XgUZ90lfZ2tfHAG1sdvIenXyl7eAFsgJQJMe3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6146.namprd11.prod.outlook.com (2603:10b6:208:3ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Fri, 7 Jun
 2024 16:49:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Fri, 7 Jun 2024
 16:49:06 +0000
Message-ID: <7bdd42be-f469-40a8-88b1-418cc427b30a@intel.com>
Date: Fri, 7 Jun 2024 09:49:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 06/20] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-7-tony.luck@intel.com>
 <b0e17f5e-210d-4aa3-9410-f1829b570c4b@intel.com>
 <ZloUKaU9tm_lIe05@agluck-desk3.sc.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZloUKaU9tm_lIe05@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0324.namprd04.prod.outlook.com
 (2603:10b6:303:82::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1792f0-ecd4-470a-80d4-08dc8711be77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d1FXZG1rUnVWY3BOUlhYYzd5dVJWeVZtSlNRR3YvUmJ2QmVLQkYrYVpXVkUw?=
 =?utf-8?B?SlVqNy8vRHlhWEFDejd2SkVRVDdlbHkzcDRUeFVkYURyZ0dqV0k2dThZUmlt?=
 =?utf-8?B?VW15RGNKUXR2a2R6MFBTUU9lY2c3d0NGSEZQT0pwczhpeW4rWEN6Y0xOdzVU?=
 =?utf-8?B?T250NHRZTlk0NTlSUGdqZVJITEx2Vm5TUnFsazEydHNPOUVXeFJ0MGJoVzBP?=
 =?utf-8?B?azZOREpIOGpqUVhSemVrWDk3ZjRLOEJENFNyRjkyaGJIUHI0dytxUkFCSmEr?=
 =?utf-8?B?L3NtWkdnMVVhQ2FSdmpKMytOV3RKVUJPaVhqM3cwOFJjNDVoZnJkM0hwdlpR?=
 =?utf-8?B?ZGZGTUtzY3lvRFJDSEtpSHlBZlRPWVVqT2FvMnNXdC9LUS9MY2k4ZFNSaFpU?=
 =?utf-8?B?ajAybHVDc2kwalBKT1oxV3ZxSnBOdUpXdStTSlJoc2M5NEZLY1RUa0IzZFpp?=
 =?utf-8?B?S3ArUGVFRzAvVDJ6V3ZBT1BpLzdsSFZoYTd1eUw2bm5qZ1dKVjRsQkg3RzlB?=
 =?utf-8?B?bVlyb2hvL2FVRVhFMTFaWHVnNHV6WGNTdEV5ZFNES25rczNTU3BDcm1VTWNx?=
 =?utf-8?B?dlJGMnZzOTZpejgvMGgwSy9KSllWNTNtdUNIdkVPeVNQVCt0S00wQmlIbWtn?=
 =?utf-8?B?TFdoY3JoVmJvaGwzMXlaVWxDUXQzTm4wdEpVMDcxNEVJMFM4VVU0VjkxQWty?=
 =?utf-8?B?MXlvYWtWaEZLa2JRZ1lMdVpMU1JoRDF0OVdIQ2FzaG12ZFdwSTRPUWJTbmNO?=
 =?utf-8?B?bDJWelBHT0VSN1k4NGNmcXRoNERpSkJ4ZEN6cU1RcDVzVXJZaVAvcFJkS005?=
 =?utf-8?B?UGROdklGMVB3MjJDbm5Hb0J0RVpiMDA0c3J2MGpDR0IzMWl1d2NnUElLeFgv?=
 =?utf-8?B?ZnpWalMzRHJPbVlaeXZ3Wk13RENPSldtZGtzT1E3bUhFU0RmSnUxdjFYRVNu?=
 =?utf-8?B?TnVIdVFBOHFtcXdxc1MxL0FjK0pYZTl2d1pxS2RlRWlrNTA4aDE5ZzFqQW93?=
 =?utf-8?B?TXYzU0NtenhuOWlLOGUvd2FhL2VIRloxSS8rNGg4aXhHTHJacDIyaGZBa0tF?=
 =?utf-8?B?TG9wRHBNWEE2UXltVHFJa1pIZjA5SFFIaXJNVGVIcnVVaHR1S1JzUE04NzJi?=
 =?utf-8?B?SmxhK3ZudGo1ZGEzZkd1WUZPdDBzMDRDSTJEalFteEhFMVlsbjRzNnFwcjN1?=
 =?utf-8?B?ZDFhZVhRazNCWHRBY0c3a1d2bkhlU2E0REd3VE9oZFpraW5zOVQ2RmF0WWFY?=
 =?utf-8?B?OWRHeXVhSFdVOUVLK0lTZ09Vak0vSnR6VnZQbjZsZ0ZQRlVOOCttanhGTy9Q?=
 =?utf-8?B?cnkwK2dCdUIvbEJReWROTUZvVDU1TTBRM0NkNVpKN0xkTGJtUXM2SlRpYWNG?=
 =?utf-8?B?dm5PdFJuSXdsNnFtYWI4dkZBdzZmcmZ0RTNEbzUwVjdYcCt4d29FUFN1UlFx?=
 =?utf-8?B?ZklVU0JiMUVkTHN0MUIxRVlOaHQzakFYMmh6MVkrbWJkd3p4RlpHSzJ3TDgz?=
 =?utf-8?B?aVFoQytRcEYxbDg5Q29nNjJwZ2NwM3R1bENIR1BrMW0yNWNsMSsxTURKNVkv?=
 =?utf-8?B?Z1FlSGJLZ2R4T3VxdS9tMm8xZGlDYXcrcE5JL2NVTkdueEhoQUowUXBhWHgy?=
 =?utf-8?B?dHN6SVFwZTIxQmxBT2JQSlJVY0pSTmJQT2tvS3JQdHMrSU9EWGtOY3EwajZ2?=
 =?utf-8?B?WUdMckxXYmhRdFkxQTlUZUt5dFBFZHYzemdIbmVQNkZWNE9oMEx5Y05WcTBY?=
 =?utf-8?Q?dJBW6t+zbmTwRdPk8IDuSJ/zNFNqXp2qz4qC8xE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHRTRW1uZjRqbnNUVWJKSGMyaFBVdURWQVVrWFloa1lUWU9TRjhsdlhZTmpL?=
 =?utf-8?B?djdkdTdqTnJqOGN3OFdqUklYUFNKc3V1V3dKMmNVOGtjMDNSbzFnNnpPU3RR?=
 =?utf-8?B?SmFyZnhIK3F6M2kxNjJrZFN2ZktaV2N5cTRGbW9kTjZWK2IwQms0RnlWZGFt?=
 =?utf-8?B?VXZZZitCMDNnbDdNTzNtaXJEN1E5VnZVUnVxWDRSODRWOUtKSGJqWmlkcjJw?=
 =?utf-8?B?SlFnTVRmYWNhQUF2VDNQdWo4dSt1MXBjWXd1OGUvcXltWGI3aXpidWxXVTdM?=
 =?utf-8?B?a0lpZTJydUh6WG1hYnFFRFZaM1lPY2JrdDR4YmI1T0NpQndnMEtCSzViUE00?=
 =?utf-8?B?RTRxWnNoUlEzbHRveWZ5dDd6YUVqS1g4clZsWWpqWEE3QjlWZVJGZUhHVXg0?=
 =?utf-8?B?QnVuT3FHUzBKY0RvOWZRcmUyRUlVN21ZRkpNYlFwRG1wU2tjandlbjh4eUIv?=
 =?utf-8?B?VFJFRnp1OUI2cDlISlhaUVl5U2l1WVpDWEhiK0wwSGNKMUJvS0JTZjFxWkFs?=
 =?utf-8?B?M1M1Yzd0dnFGbWVkVEJjR0ZSVnZGNXZVdTdPcjI3SEt0S1h6ZVdvY1Mra1BR?=
 =?utf-8?B?VzRDUkNxdDZJNFFhc1VQc1JsbytXSk8wbGNYeVpqNE90WlczQ0FhcDhGdUlK?=
 =?utf-8?B?cHVVMVA3TktteE1XR3pRazVLTmJKYnJWQ0MwcnlwMTluN3AwbXozTS92dDVu?=
 =?utf-8?B?NXpDTUJpNWNOTWc1U00ySC90UDVyUVNkb0RhSUMzOFRkTHdHSnZvREErbnhH?=
 =?utf-8?B?eEhXeWlNc2lLeE1rbHVDRk1ObHliYzh3dFU2OE83S25FRUtJWlhwRkZpcGli?=
 =?utf-8?B?REwxRTJ5U3BLZHZ2dFNXc2lsc2dWdkc2bCtFMjQwYUM3aU92MUIzL2lPM1ZF?=
 =?utf-8?B?UzJNZEw4cnVOOGt6S0hxOXp0MEtpMVVmM0lUMzc4SFRaSFdnV1llOWxLbVN6?=
 =?utf-8?B?ZTkrNTVsQkh1YXQ3Umk4NnpSWndkSU4rNkdxdU1tUklkeitDaHROVVF4WkdR?=
 =?utf-8?B?WFkrUTZydzlCMkpJNitlK1NDSFEzRmlicEQ1eklPaFU2RTlJTWpTRVdMdFUr?=
 =?utf-8?B?dkpZSXJ1c05ScVNwM3hFVEpKOHJiajEvN0Zaa3Z3OEZzWnhkWEVkTzVBM3FU?=
 =?utf-8?B?aUY0RkU1aUNpb0VzSGJHMVFLWEk5ekZZRlp3ZEVIQ2pyNE9kc3QybmN2cGNq?=
 =?utf-8?B?VE5mdDQ5ZTVnMUlnZ0x3YTE0a2oyamF6aFUxR3JBay9PNnZKRkRacEZhcmVj?=
 =?utf-8?B?Y1dQeHBaR2ZFVExaaUxrcjIwNWxMdnB5K3BXYklWdjBtcVNTVXoxUUx5VFBT?=
 =?utf-8?B?clJ1dG5Zelc1SXFrN01iTWVqSEhHdjdnWVA3eTQ2TUR3b0pxU3lzL1o2R05B?=
 =?utf-8?B?c2xTN01CdWtzV010YThzd2xPR3R2akdVS0VjeS85K09abTNIYVUza2Rnb2dH?=
 =?utf-8?B?QjhPdXBjczNGQ1JIVzR0MUYxU0MvR2tHVmhabmNOeEF5Y3JySWNPOHpXeUts?=
 =?utf-8?B?TmZpaUZZWEc1UU1FMGJUT1grMFJtdDZIQVcwdTUvaXhOMEZqMDRrSzBMekFV?=
 =?utf-8?B?cU9TK0tONlVub0s3NXpabUdtc0xzeGR1WGd1aklpNFppeGgxMEZLakNiTFJm?=
 =?utf-8?B?RkcxWm1XRDlBOG5UWlRlcGVJN1hyY2hMN2tUd1FiMVhwczV3ekJhaWlHU3Fs?=
 =?utf-8?B?b3ozMmFNb05VQk9YVlF2WmI3bTNzWElNSzc2VE8zZlNOck5wUkVPNVB1MTNq?=
 =?utf-8?B?SVcvV3A4cmpZZENRaFJsOE1OdjdIZi9FQzdrTkJZbDdhQy9XcVhIU29idnV2?=
 =?utf-8?B?RVZGblFmRzFhV1d4WG9uSjdEUXpDVnVyUjlUZjdRUlpIc3BVeVpWV0Z0WVRD?=
 =?utf-8?B?Q2x4Q2ErbHlQT2RHSm5yaVVxdU5tSElaRG1PcFc0R3NZN0hKQlA3OU9QdHk3?=
 =?utf-8?B?aGJxY3RyTUQydHJEZUhIWGpkc2RsU0VXNWQ0UWhBTWR2M2swcVpDVUpKcDQr?=
 =?utf-8?B?L1BueU55dEM1ZkFmRlJERGV2MjNZUFp6YzVXQ0FOM1RBLzQ5NTFPeWduUEVV?=
 =?utf-8?B?T1JuTURRc25IS21iUkdCb2tzU1RaVER0RVpBTHkvazFGanljMTlMWjd6YXEz?=
 =?utf-8?B?aG5PcitGSjZYVEFiTUpiOXdaOVNRZVJOd2Y5MnlRQzFncXFiemx3M0dDSmtx?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1792f0-ecd4-470a-80d4-08dc8711be77
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 16:49:06.0770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDfHRPdj5u6QaQD2hQOkvJFtN17U43l59f3k3My3q5Dtm8s3OR1Ng6jP5oU0DOER+bMLhyEDyfZR727gmbaMeC3RwanZbidIvQrq8GHF140=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6146
X-OriginatorOrg: intel.com

Hi Tony,

On 5/31/24 11:17 AM, Tony Luck wrote:
> On Thu, May 30, 2024 at 01:20:39PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/28/24 3:19 PM, Tony Luck wrote:
>>> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
>>> and memory controllers on a socket into two or more groups. These are
>>> presented to the operating system as NUMA nodes.
>>>
>>> This may enable some workloads to have slightly lower latency to memory
>>> as the memory controller(s) in an SNC node are electrically closer to the
>>> CPU cores on that SNC node. This cost may be offset by lower bandwidth
>>> since the memory accesses for each core can only be interleaved between
>>> the memory controllers on the same SNC node.
>>>
>>> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
>>> to track L3 cache occupancy and memory bandwidth. There is an MSR that
>>> controls how the RMIDs are shared between SNC nodes.
>>>
>>> The default mode divides them numerically. E.g. when there are two SNC
>>> nodes on a socket the lower number half of the RMIDs are given to the
>>> first node, the remainder to the second node. This would be difficult
>>> to use with the Linux resctrl interface as specific RMID values assigned
>>> to resctrl groups are not visible to users.
>>>
>>> The other mode divides the RMIDs and renumbers the ones on the second
>>> SNC node to start from zero.
>>>
>>> Even with this renumbering SNC mode requires several changes in resctrl
>>> behavior for correct operation.
>>>
>>> Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
>>> how many SNC domains share an L3 cache instance.  Initialize this to
>>> "1". Runtime detection of SNC mode will adjust this value.
>>>
>>> Update all places to take appropriate action when SNC mode is enabled:
>>> 1) The number of logical RMIDs per L3 cache available for use is the
>>>      number of physical RMIDs divided by the number of SNC nodes.
>>> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>>>      nodes.
>>> 3) Add a function to convert from logical RMID values (assigned to
>>>      tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
>>>      to physical RMID values to load into IA32_QM_EVTSEL MSR when
>>>      reading counters on each SNC node.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>    arch/x86/kernel/cpu/resctrl/monitor.c | 37 ++++++++++++++++++++++++---
>>>    1 file changed, 33 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index 89d7e6fcbaa1..b9b4d2b5ca82 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>>>    #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>>> +static int snc_nodes_per_l3_cache = 1;
>>> +
>>>    /*
>>>     * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>>>     * If rmid > rmid threshold, MBM total and local values should be multiplied
>>> @@ -185,10 +187,37 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>>>    	return entry;
>>>    }
>>> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>>> +/*
>>> + * When Sub-NUMA Cluster (SNC) mode is not enabled, the physical RMID
>>> + * is the same as the logical RMID.
>>> + *
>>> + * When SNC mode is enabled the physical RMIDs are distributed across
>>> + * the SNC nodes. E.g. with two SNC nodes per L3 cache and 200 physical
>>> + * RMIDs are divided with 0..99 on the first node and 100..199 on
>>> + * the second node. Compute the value of the physical RMID to pass to
>>> + * resctrl_arch_rmid_read().
>>
>> Please stop rushing version after version. I do not think you read the
>> above after you wrote it. The sentences run into each other.
> 
> Re-written. Would you like to try reviewing these patches one at a time
> as I fix them? That will:
> 
> a) Slow me down.
> b) Avoid me building subsequent patches on earlier mistakes.
> c) Give you bite-sized chunks to review in each sitting (I think
>     the overall direction of the series is well enough understood
>     at this point).

I've been thinking about this a lot ... but I am not able to understand
how you could draw your conclusions based on what I wrote.

I do not believe we need a new process. I find the basic patch
review process sufficient and would appreciate if that can be followed.
What I mean by this is: after a patch series is submitted it is reviewed,
any disagreement or clarification of review feedback is discussed during
review of that series, next series is submitted with all review feedback
addressed. Exceptions may be when there are such big changes that
a new version may be needed just to create a new baseline, but that does
not apply here.

> I've attached the updated version of patch 6 at the end of this e-mail.
> 
>> Could this be specific about what is meant by "physical" and "logical" RMID?
>> To me "physical RMID" implies the RMID used by hardware and "logical RMID"
>> is the RMID used by software ... but when it comes to SNC it is actually:
>> "physical RMID" - RMID used by MSR_IA32_QM_EVTSEL
>> "logical RMID" - RMID used by software and the MSR_IA32_PQR_ASSOC register
>>
>>> + *
>>> + * Caller is responsible to make sure execution running on a CPU in
>>
>> "is responsible" and "make sure" means the same, no?
>>
>> "make sure execution running"?
> 
> Also re-written.
> 
>> (Looking ahead in this series and coming back to this, this looks like
>> rushed work that you in turn expect folks spend quality time reviewing.)
>>
>>> + * the domain to be read.
>>> + */
>>> +static int logical_rmid_to_physical_rmid(int lrmid)
>>> +{
>>> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>> +	int cpu = smp_processor_id();
>>> +
>>> +	if (snc_nodes_per_l3_cache  == 1)
>>> +		return lrmid;
>>> +
>>> +	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
>>> +}
>>> +
>>> +static int __rmid_read(u32 lrmid,
>>> +		       enum resctrl_event_id eventid, u64 *val)
>>
>> This line does not need to be split.
> 
> Joined now. I also pulled in your suggestion from a later patch to
> rename this __rmid_read_phys() and do the logical to physical RMID
> translation at the two callsites.
> 
>>>    {
>>>    	u64 msr_val;
>>> +	int prmid;
>>> +	prmid = logical_rmid_to_physical_rmid(lrmid);
>>>    	/*
>>>    	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
>>>    	 * with a valid event code for supported resource type and the bits
>>> @@ -197,7 +226,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>>>    	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>>>    	 * are error bits.
>>>    	 */
>>> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
>>> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>>>    	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>>>    	if (msr_val & RMID_VAL_ERROR)
>>> @@ -1022,8 +1051,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>>>    	int ret;
>>>    	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
>>> -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
>>> -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
>>> +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
>>> +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
>>>    	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>>>    	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
>>
>> Reinette
> 
> -Tony
> 
> Proposed v6 patch with fixes applied. I didn't include a URL
> to the RDT architecture spec I reference in the comment  for
> logical_rmid_to_physical_rmid() because Intel URLs are notoriously
> unstable. But I did check that a web search finds the document based on
> the title. With Google it was second hit for me. Bing lists it as first
> result.
> 
>  From ab33bacb9bf4dcf7b04310c1296b9dacddc4cd80 Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Thu, 30 May 2024 09:45:35 -0700
> Subject: [PATCH] x86/resctrl: Introduce snc_nodes_per_l3_cache
> 
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
> 
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
> 
> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
> 
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
> 
> RMID sahring mode divides the RMIDs and renumbers the ones on the second

sahring -> sharing

> SNC node to start from zero.
> 
> Even with this renumbering SNC mode requires several changes in resctrl
> behavior for correct operation.
> 
> Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
> how many SNC domains share an L3 cache instance.  Initialize this to
> "1". Runtime detection of SNC mode will adjust this value.
> 
> Update all places to take appropriate action when SNC mode is enabled:
> 1) The number of logical RMIDs per L3 cache available for use is the
>     number of physical RMIDs divided by the number of SNC nodes.
> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>     nodes.
> 3) Add a function to convert from logical RMID values (assigned to
>     tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
>     to physical RMID values to load into IA32_QM_EVTSEL MSR when
>     reading counters on each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 52 +++++++++++++++++++++++----
>   1 file changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89d7e6fcbaa1..0b05dfb5ab67 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>   
>   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>   
> +static int snc_nodes_per_l3_cache = 1;
> +
>   /*
>    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>    * If rmid > rmid threshold, MBM total and local values should be multiplied
> @@ -185,7 +187,39 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>   	return entry;
>   }
>   
> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> +/*
> + * When Sub-NUMA Cluster (SNC) mode is not enabled the RMID value
> + * loaded into IA32_PQR_ASSOC for the CPU to accumulate data is
> + * the same as the RMID value loaded into IA32_QM_EVTSEL to
> + * retrieve the current value of counters from IA32_QM_CTR.

The function is logical_rmid_to_physical_rmid() and it is called
whether SNC is enabled or not. Above provides summary of expectations
when SNC is not enabled but there is no mention of "logical" or
"physical" RMID to understand what this means for non SNC.

> + *
> + * When SNC mode is enabled in RMID sharing mode there are fewer

What is difference between "SNC mode" and "RMID sharing mode"?
Please provide explanations about what terms mean and then be
consistent in their use.
This new version seems to be the first time "RMID sharing mode"
is used but there is no explanation about what that means.
Only previous mention was in subject of patch #18 but the comment
of  arch_mon_domain_online() has no mention of the term
"RMID sharing mode" in the place where that mode is actually
enabled.

> + * RMID values available to accumulate data (RMIDs are divided
> + * evenly between SNC nodes that share an L3 cache). Here we refer
> + * to the value loaded into IA32_PQR_ASSOC as the "logical RMID".

Please do not use "we".

> + *
> + * Data is collected independently on each SNC node and can be retrieved
> + * using the "physical RMID" value computed by this function. The
> + * cpu argument can be any CPU in the SNC domain for the node.

"The cpu argument" -> "@cpu"

"SNC domain for the node" - what does "the node" refer to in this context?
Later it becomes "SNC node domain"? So far this comment has "SNC node",
"SNC domain for the node", "SNC node domain" that all seem to refer to
the same thing. Inconsistent terminology adds unnecessary complication.

> + *
> + * Note that the scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is
> + * still at the L3 cache scope. So a physical RMID may be read from any

"The scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is at the L3 cache."

Pick if you want "physical RMID" in quotes or not and then stick to it.

> + * CPU that shares the L3 cache with the desired SNC node domain.
> + *
> + * For more details and examples see the "RMID Sharing Mode" section
> + * in the "Intel Resource Director Technology Architecture Specification".
> + */

Reinette
