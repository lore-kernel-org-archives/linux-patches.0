Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C28158DA7
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100470; cv=fail; b=Ch9MersAtP10BJqo0YkmW3Bsuv7Ww2S8hQ57DL9x7oYm0+akVnc3j/JoMObEi+KQzu+iOEKRQdhgN3Z2lE739cA8krd/mICsavNbxjGtgzUqmZM/WKo6nl3Srrbf53sRVOcsmPVs42CTXYsZTXq8CiNEYTsQsuI3cey/lfLHTzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100470; c=relaxed/simple;
	bh=s5fe0CEca5YSbh23GcJ6L2Tc6luP/HFVvxD6pyimpo8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UE4UY2bw4ynHITwsMFJ6u0G7MMyQVeuwo/UKmYYm/oUZdxPjPsxxnUEX6WiEf0E7ZGElaP3ppwz5FW2M1J+tFh2PM/X0aW0UIfcUG9rnL6AoKz2yJ3Kx3L94er4zPoqX5TVXBr6JXpF5VNniFzEQSlaG/IL79R8HetcESgnXY64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLON1doc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLON1doc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100469; x=1748636469;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s5fe0CEca5YSbh23GcJ6L2Tc6luP/HFVvxD6pyimpo8=;
  b=CLON1docS+nVfmRAP/rPrY5dUrbVLLvVGvcDjJ9J2xIp0S1a/Q7PWfLI
   GDZrtFmScSGv4oJFqjixZohdhcLlSPV1H7NF6YFnjM2Kq7whmBp51enQk
   p8jB5cNf4HeaMhigkOi6nui71PjTcyL0Qu8v6bkkCQyxKv9kFIJ/sg05s
   2Txf3DM6H39GX6BEhDrAH/qSX8+YcSU3bHOruU9sM919B1Tws97Rre4Mf
   i0Qv3dVE7ZuvElrDHSaDzwZyK0MV2ijSaBksy98R5vWvNxWZGDs0ZcMc5
   /9Qi5K8KbNSTQdMM6JyxrSphJ7RB1fGDUgWzvUFYNAm+UXH8fdyFCximv
   Q==;
X-CSE-ConnectionGUID: ydDZb9rRQvuEQs+wxW4fag==
X-CSE-MsgGUID: loh+r9rPQmGds8QSiVV4uA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17450111"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="17450111"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:21:07 -0700
X-CSE-ConnectionGUID: SDHv2LMeQAeFAY/aNb2wPQ==
X-CSE-MsgGUID: wy8QQUK1QDGZBYnP6+gDzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="59113092"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:21:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:21:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:21:06 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:21:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWXjspoy3ngk7U4ZllDPTdUok6WWikUQZlC8TNC4nkMzvd/Q4f5qnOovt2epoZgC1aVZ7Dd3JAhjmi9zZgQJJV6WdQyvtWBye/xqzWRsMpvcGiuNAAKxjtU0R2Pl1DhSprZ8ic6z3iEuzBViy+RMXc/SX7BFln1uPAIL856+GImAoQ4ATq2O8Bl8eljdiLZ0jv9FABQ2GmB202lDpOdGGSvmTRQLM/NVAif+MTCz9j+fr6XqZcd/o2627TuK2uz1ddDo4TEvb70fdS0kLZ9cx17BAR2ds+WKdbWJrFR1jZABC3h2HzwHvygKuRofwR18xU8tz2tWkZan/k6de5+uAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cbon5eY/AmBcaJIEQugdiGhl0w3zqS+rcLC1mvjuwY=;
 b=NsEZnU/AoKZVMVwSNQuJnqb+5mgH+aCP22McyYu0vjAW+4aX8TLvW6c/ekSzpkTX3Kmby9tymT6CxOyUfGrpJ/IO8ApjbjMKErziFcsaS6+YwzbAaCU5JBXqiymeZuksbjK9TDFnTKhXcDMhMaIJEVTNVuB9fG/f3BizvGiHqZBvjIYlvgyOJrUmLYFgSml2uPUtGg4akS8E/d3qvwfX0rju6tjAHj/bxO4YVvoB+eH+tZKKLFQQpSKFNvJ7/7NCARgSryQomfaDwCS7ZltoCPgI47woJnZTc97u5c7rg72PU3/4adgBHtLM9WqbHVi5hCF3MT9mkAurvpzgw+ydeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB6453.namprd11.prod.outlook.com (2603:10b6:8:b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 20:21:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:21:04 +0000
Message-ID: <fe9a4cd5-f74d-4c89-8667-8b5b1841b84e@intel.com>
Date: Thu, 30 May 2024 13:21:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 08/20] x86/resctrl: Prepare for new Sub-NUMA Cluster
 (SNC) monitor files
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240528222006.58283-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:303:b4::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB6453:EE_
X-MS-Office365-Filtering-Correlation-Id: 22662501-6c7b-45f4-a392-08dc80e607ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0lnZUs4dTg4akxLQUxWby9zTTROY3RyN3ZjWnhGSFJkanhodkx1L0x0ZDF2?=
 =?utf-8?B?a2xmVEwxeUM3bVBpM24zeUl1eHkxMWhQWVcvSnBJS0Z3dDRibjZoTjBuL2do?=
 =?utf-8?B?UXJLd3FIYWVRV2x5OGlMSllaejJidEk0TytaNGQ5RGhocGh0RE1lWnZtbVdq?=
 =?utf-8?B?QlJHU01wTnNLYlFScmlUNldXZUZ6SFRxSVo0ZVZyOEtwb0Voc1luSWpCUDZr?=
 =?utf-8?B?OXNNODNvZTRaQjBGSVREbm9sWUdvbjNZaE1qMEhVQm9XUEgxNStJYktFVEJw?=
 =?utf-8?B?U25HNEpqZWNJaXN4RndEcUJqV3l5ckFPdVZqdmxKYUJuVktlT0hXSmRvaUJE?=
 =?utf-8?B?di9ES0xTUjFrSEVZdUd4SEpvOXl3STlLVEtRNnNzZFdxNkE2ckh0ZDFIdHUy?=
 =?utf-8?B?TzRMejdKd2xzNHJHRUJHVlZJOUFPQjJ1N25NMTk1OGZ5VnFFTVhaS01IeGNm?=
 =?utf-8?B?QUNXRGhZWFFDZlNnSFZTK3FVMWxBSnR5Mk9HMDZzWWVySDFkRFErakxON0w3?=
 =?utf-8?B?VmdIYUpCQ2V4cVRsTVJOcnJUbDdicjM4NDN2T2NSdzBZOTYyNERIQ3dBekFS?=
 =?utf-8?B?TUNhbWZqR3lnUjB0V1gzTWNEbHdRcUxZZVJscjRzM1VIVjBQNEVBQ3dUVHJy?=
 =?utf-8?B?Q2s2R0NiYWpDcmh2VXFvOS9mLzVIL3NNQ2dHbTIvbGlXRlM1VnBPU2NTN0Ji?=
 =?utf-8?B?Ri96dGVidU13VGp5Z3N2SEUrMzJlZk04Uldid2IyRXJYN2d6aXc4VlpsaDZl?=
 =?utf-8?B?YjgxQzhSazVvaUl1UjhJVnhya29JdWNGL1o2MDNuVkdvaXIraHpKQUxSUGtO?=
 =?utf-8?B?Ymx1elVkRnI0VTlHTDQ3MFlSM2F3MmlwbFdVWW1lY0tCNm9wQklvTHVWU2li?=
 =?utf-8?B?YW5zSk9tNWlhYWl1SlpUZHVOdW1va0lzZXlkMG8rak56eFA1U05uN2FEQ09F?=
 =?utf-8?B?Y3UxaUMzY2h2SzdjVnV0TUJjM2pmK3BjSjAwc1VHbTNKQkh2OXBCUnVVTEJl?=
 =?utf-8?B?K2lObzEvMlVjWXJaTDFEQzE0eTdobGliTW9tMUpaTXpVclkyWVY1VG9EN2Vx?=
 =?utf-8?B?SVJvRFBWZEs0UXNnZEVod2hWdksyb1pUdzQ1YXZmeGZzOU5mQS9VTDRMNXo3?=
 =?utf-8?B?b0hqTktDRktGSlJiNnJFTXpCalBaSE5FNHlKTk5Pd1ovQ05EYkZpelg3aVRR?=
 =?utf-8?B?ODhOV0xwK1pybFVhditwRFd5MVZRUlZqYWJGZWpFeVVhK3dTbWpZVjFTNk1J?=
 =?utf-8?B?aWUxTGVKWGRCc0taQ0pRemJqMktjMG1yQmZSMVlFNitHN1pMaUQ1TE9raTUw?=
 =?utf-8?B?N1E1WVZsN0tRMVBxOEhZZTgrUFRUVUc2M2ViTUd1L3dOdFFkaVVQSWI3UXdX?=
 =?utf-8?B?cG14aUhOZ0VNdDVCV2htc093emk2ZnJReFlSNDdYWDRZVUNpNjhWbG5nTWI5?=
 =?utf-8?B?bElkQVVWRTNvc0I2OHowZ1lKWUNJdVZud1c5VW9OOFNnVGlJeDhHSHkwaHZp?=
 =?utf-8?B?TlNzWngvTk9JYjhPbGZONmx0UXA3RHIwa25uYm5MTlc3ZkN4dWVhb012dXlZ?=
 =?utf-8?B?ZG83QVliNFpzN3BYVGRoS2dLcmhRcnJDbFp5MmlrN2xoZFRIWENyeVdQb094?=
 =?utf-8?B?RkcwSWZ5RWxtN0NUZmhyb0V4c3hFWnlZeVh5SFBUZWxzN1FscTdSMExIUHhR?=
 =?utf-8?B?T0ViR3BvWnR1Tzg0M2ZlSE93Z28ybmhtcjdVaTRIT2dMbm1hRURYeUdRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0EvMXF4R0VrcVB4RjhkcHJHRjQ3RXNFNFlTRkRyOGVZNlVsUG5rb2srTjhK?=
 =?utf-8?B?K2FSZTNRVi9QaVpWbDJDYklWTTFNcFdjK3QrbXdvbWdUTEFpbDcyWTRKWXhC?=
 =?utf-8?B?TDM4d0FXbmh0bXRZMG0vbFQ2OWdrZjFCK2hLZFBldlE1Sk1SN3dRTjRPNURQ?=
 =?utf-8?B?eCtkNVFrN1FDZUJjYW4vV1kwQi9lM3F3eC9QWFVHaU5LNFMvRGlZSGFyaTk1?=
 =?utf-8?B?b01ySlRlNHdmck5LOTcvQmNYaFh2RTVMbE9mSHBlQkVET0h2YmswL3R1eFJr?=
 =?utf-8?B?M2ZReUhCV20yeERiOGsvZnI3bzM3WE4rbm9MbDBUM3RaYnZxSCtSL2tWckJt?=
 =?utf-8?B?Y1U2TkJsaDJoUkFMWEFneU53KzVSeXZYYmM1SjEyUWpYUWhJYXZMcDVyaThy?=
 =?utf-8?B?NE9MdDIxRUQrU0x3ZHN5VStQSlRSUXlJblloUUpwTWtnVFkzWUxyUXpMdXhW?=
 =?utf-8?B?TXNzaGpuQjV2RnhONzNFMEk3WmNpUVVpYkxDaTBWVEEvWWdQc2xLMEoyS0pM?=
 =?utf-8?B?Q0lZK3pQSkdaenl5bUwrVHRjT0JqNmRHWTdTTkVVMWdaRGhYVWI5cSs2RHR1?=
 =?utf-8?B?N3lZaW1CY29ZaWgvQW1qT2kvekprM1U5S0hTQ09hR3lRc1J2RnRMeHZDTG1V?=
 =?utf-8?B?MTNxMlRrR0tBOTZSckdIaC9uRGJCQS81KzBPMUZDR2t3RW5jTTY3NDc4TDd0?=
 =?utf-8?B?aFdhVTc0a3F6N29pK0k2VkR1czFmNXM4RWRwT0EvbTNqVyt3ZjEwaWkwV2pz?=
 =?utf-8?B?bHRtMS9EY0h0dXVSYXhJSnFsaGhNd2FURXoxdFRtdFhpTENlV3h4SlN5WlE3?=
 =?utf-8?B?UGEycG4rdUYyak4wN2gxMk54SnVwdGZsNmROK3diRE1xSU04QnJWVWF5aTR0?=
 =?utf-8?B?bHRJVStYZGNCb1h2TUFkWm9NeHgvLzZmeUF2cS9ySzMrcHlpSkozVGR2aVpR?=
 =?utf-8?B?YnhVMWR2Y0g4bEVwM0tUN3hNcEIzV1U0MEZwUGxxcHg4M3JQRW5jRjBjOXdy?=
 =?utf-8?B?MC9yc1ZkV3V6c0VjeWJLdkpuQXJYcjdGOVdTQUtjemdsZ3FFOWduMVlnSVFO?=
 =?utf-8?B?bjVmWU0vS2pQL0diVU9TWlZ3ZU1MZkZjWUY3cEZ1eGhzK0lXV2tXdDY2cGEz?=
 =?utf-8?B?UUF2RGdxZDR4VmJva1E4Y2ZMclBEMURkaWtxaStxbkQ3L1d2SVUyY0txeTZN?=
 =?utf-8?B?RGZ2WlBnWE5OVnN4VHdNM25tWmZHQXU4UWlaUVdKQ09vdXNrZUZNUGlWcFFt?=
 =?utf-8?B?RzBleGJGbjZMWHhwd1dyMjUwVlRTbERwckNNYktQWERBcWYwNzNhUXRoYlIv?=
 =?utf-8?B?eENnWTVhRUN4K0FHa1hKd3o2VS84S1BZb2VObmxBeG1SZEVLWHRDWGpxWDEw?=
 =?utf-8?B?djdSQlgrQ24zYm9PTEJqc1JjSEYrS1B6L3NCOGoxTXByYlFHTzhGdE5WNEVX?=
 =?utf-8?B?TmpGWlJPRmlnd0Evc1IzTDNVU3JjZTBhVE9QYTlTeE9qZytwblBuZ3hPbzNm?=
 =?utf-8?B?VVNMd05BTmhRNUFFUU1WMGs5YzNLZUdvKzk4TFdBbFhjWmtnRTBKRllqZ0No?=
 =?utf-8?B?dGRBRHFHVUpqRUlPMGdPcVVCVHI0dlNFclAwaGd5Wnp5S2lEWFIzSUdVc1cz?=
 =?utf-8?B?R09GTXVlOU4wcjIxbFMxd1ZuaXZEMnBJUW1zeVphdDVWRnQ0T2tINE9seHNs?=
 =?utf-8?B?aG5TMTV5V3lINjlwemNYM205cnl1TlluTlFHMU02MDJtSUpsbWYwOWwyR2ht?=
 =?utf-8?B?NFlORjc0TmtoanEyN0NGNjRPVXkwQ2FyQjMvbUlVb0NWU2lJUk5YMVcycmRw?=
 =?utf-8?B?ZlRQUkg2NDBiMGdpSGs3TnhJVlNuMXBMbGx6U3ZtM2psWlJ1b2F1SDZmTzJQ?=
 =?utf-8?B?NjltWVIvZSsyQlJXV3FjVjN5QWEyby9xYy9sTnRzRWVDdEhDTFdXcTlyLzZp?=
 =?utf-8?B?UGlrSWxRS2w0MjF3bmdkaytpTjdkMVU2SmxrQzhvZjg1RC9DQ2RLVUZWR3dL?=
 =?utf-8?B?U096aTY1U3FrWUI5Y0tkOUZaMllEb1liM2dsZEtiWU1mQ3JhbXQ0OXlnbEZw?=
 =?utf-8?B?dnJpOVMyNXpvL2sxOGVNNlIzQnlVd08wb3pGdVRFZ0xuT2dVWTJYeGpSY2pq?=
 =?utf-8?B?MWxza0JsekpFaW1hZWttbXNPcjBHOUJsLzh4ckNXUVRSVnpmcEdvUXJmUzk2?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22662501-6c7b-45f4-a392-08dc80e607ca
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:21:04.2713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PHOdht30vodLDJgJW6PXBbFH8SMC0/0O+sqKDERESJM/E+FZPDmw052goh2d4b1oUuFFFXOvc71mZCv5Lz6H4UR23/PrJjLYoX9PDNb8TW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6453
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/24 3:19 PM, Tony Luck wrote:
> When SNC is enabled monitoring data is collected at the SNC node
> granularity, but must be reported at L3-cache granularity for
> backwards compatibility in addition to reporting at the node
> level.
> 
> Add a "ci" field to the rdt_mon_domain structure to save the
> cache information about the enclosing L3 cache for the domain.
> This provides:
> 
> 1) The cache id which is needed to compose the name of the legacy
> monitoring directory, and to determine which domains should be
> summed to provide L3-scoped data.
> 
> 2) The shared_cpu_map which is needed to determine which CPUs can
> be used to read the RMID counters with the MSR interface.
> 
> This is the first step to an eventual goal of monitor reporting files
> like this (for a system with two SNC nodes per L3):
> 
> $ cd /sys/fs/resctrl/mon_data
> $ tree mon_L3_00
> mon_L3_00			<- 00 here is L3 cache id
> ├── llc_occupancy		\  These files provide legacy support
> ├── mbm_local_bytes		 > for non-SNC aware monitor apps
> ├── mbm_total_bytes		/  that expect data at L3 cache level
> ├── mon_sub_L3_00		<- 00 here is SNC node id
> │   ├── llc_occupancy		\  These files are finer grained
> │   ├── mbm_local_bytes		 > data from each SNC node
> │   └── mbm_total_bytes		/
> └── mon_sub_L3_01
>      ├── llc_occupancy		\
>      ├── mbm_local_bytes		 > As above, but for node 1.
>      └── mbm_total_bytes		/
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h                   |  2 ++
>   arch/x86/kernel/cpu/resctrl/internal.h    | 21 +++++++++++++++++++++
>   arch/x86/kernel/cpu/resctrl/core.c        |  7 ++++++-
>   arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  1 -
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  1 -
>   5 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 64b6ad1b22a1..d733e1f6485d 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -96,6 +96,7 @@ struct rdt_ctrl_domain {
>   /**
>    * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
>    * @hdr:		common header for different domain types
> + * @ci:			cache info for this domain
>    * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
>    * @mbm_total:		saved state for MBM total bandwidth
>    * @mbm_local:		saved state for MBM local bandwidth
> @@ -106,6 +107,7 @@ struct rdt_ctrl_domain {
>    */
>   struct rdt_mon_domain {
>   	struct rdt_domain_hdr		hdr;
> +	struct cacheinfo		*ci;
>   	unsigned long			*rmid_busy_llc;
>   	struct mbm_state		*mbm_total;
>   	struct mbm_state		*mbm_local;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 135190e0711c..eb70d3136ced 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -2,6 +2,7 @@
>   #ifndef _ASM_X86_RESCTRL_INTERNAL_H
>   #define _ASM_X86_RESCTRL_INTERNAL_H
>   
> +#include <linux/cacheinfo.h>
>   #include <linux/resctrl.h>
>   #include <linux/sched.h>
>   #include <linux/kernfs.h>
> @@ -509,6 +510,26 @@ static inline bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level l)
>   
>   int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
>   
> +/*
> + * Get the cacheinfo structure of the cache associated with @cpu at level @level.
> + * cpuhp lock must be held.
> + */
> +static inline struct cacheinfo *get_cpu_cacheinfo_level(int cpu, int level)
> +{
> +	struct cpu_cacheinfo *ci = get_cpu_cacheinfo(cpu);
> +	int i;
> +
> +	for (i = 0; i < ci->num_leaves; i++) {
> +		if (ci->info_list[i].level == level) {
> +			if (ci->info_list[i].attributes & CACHE_ID)
> +				return &ci->info_list[i];
> +			break;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +

This does not belong in resctrl. It really looks to partner well with existing
cache helpers in include/linux/cacheinfo.h that already contains get_cpu_cacheinfo_id().
Considering the existing naming get_cpu_cacheinfo() may be more appropriate.

Reinette
