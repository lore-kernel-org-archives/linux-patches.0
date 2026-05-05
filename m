Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A66E495504
	for <patches@lists.linux.dev>; Tue,  5 May 2026 21:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778016387; cv=fail; b=nYlwW74swwAMdouY/YeGhKfHeRFSqUg+ehJvD1ScpRFy/ufZPgKl/ZfHilGmOc2zAYN+v647kx4x3VMzZ61/mgy7PHkAEvGuuPHIG+Li6gjImtY23EEy5Id+pz00ce4/lyd4grYMlkqzFP+MKaSO4ZEcN97APksSanHHOc5ow7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778016387; c=relaxed/simple;
	bh=mqluKbExDj6jId3VtNCKP9l+JGXGUow5Lb6Ib8VQQmo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gNHKS/AQTC5j0/+mTx+2QwmDB4WP/496VmFTjCgrPxzNlV2gb9DbyEOARwJQaHzkLCE5T4qOxOS9W+lG4BkhcQLSDMivSlvsPxKEiZL7E8MkdYlG7IQmDVcJuDkPc8QhGbATWcsWM2sNeW7bOdNwgjw3XG7Wq40kKR4WVef7PsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hf9mwSWK; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hf9mwSWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778016385; x=1809552385;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mqluKbExDj6jId3VtNCKP9l+JGXGUow5Lb6Ib8VQQmo=;
  b=Hf9mwSWKNY+DQCgvPBl5LSJRuQYq09vQ6q0zHqFK/OUI9KIAi4yAssmJ
   V1zYaATfE6fCTdDFqaVK9QVXQ7CjG3HQiNPoEkRpx2mKrI7zPDc5nioKQ
   3m/B4MNzJqOydJiTbD013/bk0SUL3m6LJrMLT2ky87s7A1Bk6348UlkhF
   lZpGVU53LUQnKx8gnDMm2PCq8Z38zMiQmi1iF9l8X2tnpP3x2SE8FtP78
   XmyAtfBqeb0omyV+Z9xslQgl1YkyCTqR1NF8bBzAvXSHqxaA4tyDDRnJa
   DxZ9QZIVhfHcma9fNZLW0teudvKWO8wOHa50KpETFUciEiCElq0MWTtAx
   g==;
X-CSE-ConnectionGUID: l02PP58JSGuF4eJDkqKURA==
X-CSE-MsgGUID: g/RheqjJQ1i6E6pz9jV3zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="90359821"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="90359821"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 14:26:18 -0700
X-CSE-ConnectionGUID: L2TL+rirQbG/XSYNoWRNTQ==
X-CSE-MsgGUID: U8fK/yrdTcy4zjbUG0/vSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="231546708"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 14:26:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 14:26:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 14:26:18 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 14:26:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO+ZMV19c71jSzvv6dQvTdomiqbJQVFRiPJ0WdImS38F9lrbpOazUyFxenuh7wSlIyl2Zi6D/RPXv4wKncCcfxbKQM8s1/WSXfC41/6ReOEBph8njt07S91wxBShE4w6IeK+SxoKxqa+795K3JMUuxUBUmJptfGbqwWVE5ca3HYQNLKL6lUUdqT9TrYORULeVaR4yDrqcCYDCaPN5Wh/0rcViNxffHYJAaiyOwcxEOFrdO5oVsYjgpMwIMI5LfYnfXWOBRoouZjT/TZJNWpT66UCUDj6kir3R+R+4CTk+AvMMXyJ4qPpW1nktqxjZZ5tZglvlwapbjQbCeMIMhlF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V11t+mB/jDdOgii64N+TaBplade0tuHP7gc1p6krFW8=;
 b=HZn/D/DcrDcwOhThvpWbZPb40F7DZzlA0EP30KVgU6oHRqZGeEtcEEMNcJOyZwembggAqXf4/BpbqqKsxREUBP8TQI8UJwnJESdnC+wCXkPDO/6EfWQksuR+qaGAgkZG70nlD5uekmcFUxECu92xTwxpjZbDnDMHzAvGh79bIjV11bNRagUc1cfewxsQgHwERRu/yi8thCPNy+4MpsDS67l39UJUIx7E3vJS2wkisLlI0tvGliPxnjqFKxlbnsczvRpWX/dyGfzM8qPjdL7K2jIsnWKj9IeXkbGZmYojNY53h+k6Wz3+1srUkYUAIV3Sjt95adsxiYqetkCbtoCPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5138.namprd11.prod.outlook.com (2603:10b6:303:94::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 21:26:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 21:26:14 +0000
Message-ID: <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
Date: Tue, 5 May 2026 14:26:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afoesuWB8RezVLrN@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0295.namprd04.prod.outlook.com
 (2603:10b6:303:89::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 83e204c1-bc75-423c-2140-08deaaecef74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: xLEV5GntBgl8uu/nzfS2A5TJ/dQTIcL0JMVpR0QTujpLhXVk+Sin1bR5kGylc/VPAm8coCag82zyk3u25HNYcbdcUCQsSFtyYpGDxXws4pma/uvNoCFH7wm1aHQl3AWv3o8lGJpctuJEI9tVOMK/+0HCUt/Rpbbm5qyXg5ImI2F2mrM6d4Di2UHN2oxT29Cb+GTDfnEvBVg6vELDYye8AErE9+8PJv2MyfaEUD+lDDjQIYMk02CVFTNbU85ABQ8CP9S87NW6go4SykpcvD17RIE5PcyxsD+dSXmvYGJ1PIn1iIY6brZCfkE3reFyU5IQgfjMYC1do0dBV2Fb7xnfLjYhhOnUZXizVbj0/bVXiWezDUjlxE38QqoWEISTFOZvfQy9yQFeqasr6m7unz2SRQu3hPoHHKLJrUu791Hp3/i9JPjrW6SMcZb7K84c4CD5BTeKo84v/rg+q1ky8/drrah3/q60lbNeqkAbckAaqUxwrx4p1MSD6prJ9F0teTBQ4eScwrDiabHo8O6x1c2E50ogBzl/2qhGnt2IJqRIewD3E0AjgNW4q4QXqmTcuhT2blAHr7cXY4zIVqeJn8c/dMPYw4/RMbuszaliAQDxCBTabsZBnB8nnN/tD1r/RXN/cguBFhn74YoFjFX6aRjNgAx2rCKkpDVh7eUegi8UyMhZKJtg+6kiHRTJcz8ywxGS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3lJYllaZ3R6TWVESXE0anRTZU1KYllUOXBsTEgwSThyMjkwWDROTGJ5NnQ0?=
 =?utf-8?B?NHMrTFpXNnFBanFNODh6SW8vdmk1UGdXeHY0WWF5VmhTdG5sQU9IWlhzMmV4?=
 =?utf-8?B?NmtoNnFDT2o0RHJma3pBWHZNU09BNnpPb0x5Qm5SZU5Fbmd0TUwydEZ2czhK?=
 =?utf-8?B?YVlUcE93OGJmMjNOd3Awd3FPdkcyTVVmelFkNjZLRHU3SjhGRlQrdmtPS1c1?=
 =?utf-8?B?M3dRMTJTa0dCbWZmTUJHYkhhb1VOUTFONjc4WXVHaDhVK0E5d1pOaEc0cExq?=
 =?utf-8?B?VjJDTVo0ZHIyOWs2aTJodFJJS29lamo3M1RzdVVWMnArNkYvdWZJZDZGWDdk?=
 =?utf-8?B?TUJWN3FqS2hCWXZkVjlVWEFLMzlmOTd1eGQ5aGxVc2RPKzBsOU8yUlJ4Q24v?=
 =?utf-8?B?THJVUlFtaU5GQTd1Z1JOQlRpbjJLVHc2MWovZU5pQWpiYWhjakE3SUNRckV6?=
 =?utf-8?B?bjhRNkRVdW9Gayt1bkphM2ptMkQ2WXppVmVqZGUwb0FzdkgvNHdMN1VKNWtk?=
 =?utf-8?B?VHdGV3ZxaFZIQXlydHhESHE2VzJiTkhJYng3eGRFUDRidXVRVFZOZS8wcWJH?=
 =?utf-8?B?ZVBOaFdBZkFodlJHMEx1T1lDUlV1VTRSSnBRVUpXTVVZS3k3V25yZ0JRL1Ey?=
 =?utf-8?B?S3ZXRGxOQ2FLc1luVEJhd3JqWnorUHZ0OWNUYzJCWnNIQ2xsYjM3WnpJNyt5?=
 =?utf-8?B?eGM3ZlBLM1p0dzkvelNPYTJhOVdGaDl3QVdQaXZDT3lTVWxWUXNRdDRDMXdp?=
 =?utf-8?B?SzQrOWVzN0ZNVGUvSml5NnVTcFVLN1hiYitTUlREMHdBZ1NRNFdqK05na2tZ?=
 =?utf-8?B?eU9wZHZORXB0YzR4WHEyU29ERHJVeWd1dFRkNzUyVmpRb2MxbXJhOFl3dnJ4?=
 =?utf-8?B?SXBLeUMzT0ttSW0wbWk4eW9id1NiZkE4VFFMVi8xdExsZjhqV0RLc2pIQjQr?=
 =?utf-8?B?RHFFUFlLamhvS0x5QVRkcGpIUVR1OEFBbkdzeVVqVGdUYUlZcXRtSVRmWUJH?=
 =?utf-8?B?enhMMC9tdTVISWdVeGVUbElhdjllNklkZTF5b2FpYVk1ZHZORnRxN3JiRkNQ?=
 =?utf-8?B?SkNkWTNOdUk1ZGtBLy9PcFkxS1IwSGRFalJCNVM4Sy9XejFjTlc1b0RWRXI5?=
 =?utf-8?B?eXNDdTM1ZG9iY1VXU1U2R1pmTHJVQ1N6UGczN1BHREZOOGYvaVpPSU15cThj?=
 =?utf-8?B?S0tYa1JENE1CbHc5c3cvSmhpTWE1U285Mkc5bUVHT0Nqd2w5RytPR0FJenA5?=
 =?utf-8?B?alFDZW5IVVZhUms0d1lBZWk4cnJRdFNjVS9yOFE2dUh0RCsyL0l5akNMSVNF?=
 =?utf-8?B?SlI4dzBJMGVZb0xCYkVWUE9qYjNjalk3c1RDNWQ4L0w5aVdyM3hNK2p5bkpH?=
 =?utf-8?B?Y0hXeVB0N3lVOHhXQS9XQlo4cEUrcXZTQkRSYXFzMDRabmhPWFZNVXg5ek1N?=
 =?utf-8?B?YTlOTlBFdlUrc0Q2NEVuZzZ4U0xKTklVL2licUZQN3U0VHlOUVRIUzdkUmlq?=
 =?utf-8?B?bjBaM2xobStwT1RUWTY1VjRIZllNN0dLVjFlUDBSaDVzbzk2UzUyaXdRcTFu?=
 =?utf-8?B?eEZ6dXQwa0NGbkJTVGg3UWhleVJCQ1BFcmlhVDhYaXVua1RzWXg4cUhDQmNJ?=
 =?utf-8?B?bkx4S1hYdXBoY2daaVl6MDNCeDQ4aE1yVllLQTFZNkhXdzZ4ampWdk0yWVZ5?=
 =?utf-8?B?OFdOR1VIeG9MUHhDeS94RkhxZDVSZTRFR0wwazU0UVNKZjdtQ2prYUtoTDBx?=
 =?utf-8?B?QjlickRkS0M4c0RLRnZkUVJGdmZpYlBBN2R5ZEZlQ2VvU2FqNGNueW1tQzZZ?=
 =?utf-8?B?Y1ZaNWVXQmQ5SkZ0NjU0NFJ3WXYraU82WWRtT0JYWHNhdG51Mm9qaXE3RDgv?=
 =?utf-8?B?MlBXWGRjZ3pwUWdTSWZ3MHdMYlc4OStaSUxOcEVMZDZjRldLenBPSlFLTnNr?=
 =?utf-8?B?MlBHb0pKb3lzclludDYzd0lqK1BNendUbVdBVVUxWkIrZDdwYXk0Ym9VYjZr?=
 =?utf-8?B?NE1lcVNGTXJLN2RlUjRXaWk1citVL1l3dU1OWU9uT1F0NXU1c2ZhUnpROWVt?=
 =?utf-8?B?eVBJNFR4dWFqSzJaalZtRlFFOWpyc2dWeTJLTEZnSXVnSFg5YzY2RFd0aUJQ?=
 =?utf-8?B?eVpWYWtNQVV0V1BYVG4wbzR2STUrdDUyRGJiWDFZcm0rTktiTnBkOU1jaDlT?=
 =?utf-8?B?cWVxUHgyWUFVY0lYRHF1MmY0SU5wUUYrRW9hRGIyL2tMd1NCVWZTZmxrZFl2?=
 =?utf-8?B?SVhXRHZReCtIK2ljTnhnMEtndyt0V09NdUl5Tlc3VDlhVUJUVm8rZ0dVNEIx?=
 =?utf-8?B?alFVdW9qa2lKTElIMzVzZnhaakt5NzA1aUU0ODZKY2ZwK2RjRzk0VUxpTW5D?=
 =?utf-8?Q?3cHZnpqsSmEnK11M=3D?=
X-Exchange-RoutingPolicyChecked: UqbNqYHF0KZ+WtuRNkO6/fQWqLa97r/WdccYUcNjFtbXlXV//k4JBx0wgr+UUnVlPvJcf+44xvkvo4s2fQZRb64k2TO6qd5o2MWSktEvk3eP0Nh4dRJ1BVBGpPOJdoH/gyd2kywkkTljOI7PcAQDy3CGEmWSOl2E7P0u0D50RshFoHwdGIJzeyqXUSgPexZDG47c6zaOnSl06MNGcnz0UfGrwykVG1n9mmfjN7DQWNns/hX/KhZNEW2CizrVV7H2yA+zHpf1CZ+rtHI9ZYsz7DfzyfBiptE+DcGCI/M829HI47TVyTF97IaDWJhllskO5xzl6BPTFpthgx+OZlP60Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e204c1-bc75-423c-2140-08deaaecef74
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 21:26:14.4332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oB4txb2xSmGPrvN1NnNQCS2qVqUhxGWkDRLH9Y0mh17cY1XfcYO3sJtJ59fW+uBrBJc6jES+q3ZGAk6PIf/Nmk+SYyhQhDJ89taBgw1rRug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5138
X-OriginatorOrg: intel.com

Hi Tony,

On 5/5/26 9:45 AM, Luck, Tony wrote:
> On Mon, May 04, 2026 at 09:39:40PM -0700, Reinette Chatre wrote:

... 
> Here's the scenario:
> 
> There is just one CPU left in a domain. The mbm_over worker is woken on
> that CPU just as user requests to take that CPU offline (executing on
> another CPU).
> 
> There is a race.  mbm_handle_overflow() has begun execution, but the
> offline process has taken cpus_write_lock() so it blocks and sleeps
> waiting for cpus_read_lock().
> 
> The offline process calls:
> 
> resctrl_arch_offline_cpu()
> -> resctrl_offline_cpu
>     -> cancel_delayed_work(&d->mbm_over); /* not the _sync version */

Here I expect d->mbm_work_cpu to be set to this one CPU that is left in the domain.

>     -> mbm_setup_overflow_handler(d, 0, cpu);
>        Finds there are other CPUs in the domain

I do not think that this will find other CPUs in the domain here since
the scenario starts with there being only one CPU left in the domain and it is
currently running the overflow handler . From what I can tell, in this scenario,
mbm_setup_overflow_handler() will return without scheduling the overflow handler
on any CPU.

After mbm_setup_overflow_handler() returns I expect d->mbm_work_cpu to be set to 
nr_cpus_ids.

This detail does not impact the race you are highlighting though.

> -> domain_remove_cpu()
>    -> domain_remove_cpu_mon()
>       clears bit for this CPU from hdr->cpu_mask and finds mask is empty
>       -> resctrl_offline_mon_domain()
>          -> cancel_delayed_work(&d->mbm_over); /* Again! Still not _sync version */
>          -> domain_destroy_l3_mon_state()
>             -> kfree(d->mbm_states[idx]); /* file system state */
>       -> removes domain from L3 resource domain list
>       -> l3_mon_domain_free()
>          kfree(hw_dom->arch_mbm_states[idx]) /* architecture state */
>          kfree(hw_dom)
> 
> Offline process continues. One of the things it does is checks for
> orphans on the run queue of the now deceased CPU and adopts them.
> 
> Finally the offline process completes and does cpus_write_unlock()
> 
> Now mbm_handle_overflow() can continue. But it is on the wrong CPU
> and has a pointer to a work_struct that was freed by the offline
> process.

Thank you for the explanation, I did not consider this scenario. From what I understand
folks encountering this scenario should also encounter a splat from the MBM overflow
handler from all the places where it runs smp_processor_id(). Well, actually, if these
people are running with CONFIG_DEBUG_PREEMPT enabled because of the
debug_smp_processor_id()->check_preemption_disabled()->is_percpu_thread() check.

...

>> I still think that using get_mon_domain_from_cpu() in the workers could work here.
>> Here is the idea more specifically for the MBM overflow handler:
>>
>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index 88f1fa0b9d8d..7186d6d02d6e 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -856,7 +856,9 @@ void mbm_handle_overflow(struct work_struct *work)
>>  		goto out_unlock;
>>  
>>  	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>> -	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
>> +	d = get_mon_domain_from_cpu(smp_processor_id(), r);
>> +	if (!d)
>> +		goto out_unlock;
> 
> This will get a domain, but it will be for the wrong CPU.

If it was migrated yes. From what I understand when this happens it stops being
a "per-CPU thread" so how about something like:

	mbm_handle_overflow()
	{

		...
		cpus_read_lock();
		mutex_lock(&rdtgroup_mutex);
		
		/*
		 * Overflow handler migrated during race while CPU went offline and
		 * no longer running on intended CPU.
		 */
		if (!is_percpu_thread())
			goto unlock;

		...
	out_unlock:
		mutex_unlock(&rdtgroup_mutex);
		cpus_read_unlock();
	}


I am not clear on whether there are more than one race here now. From the flow
you describe it seems that when mbm_handle_overflow() runs on its intended CPU then
it can assume that its associated domain has not been removed and thus that it is
running with a valid work_struct? More specifically, if is_percpu_thread() is true
then "d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work)" will work? 
I am trying to match this race involving the CPU hotplug lock with the race described
in original changelog that involves rdtgroup_mutex here ...

> 
> Maybe it doesn't hurt for it to perform an extra set of mbm_update()
> calls on that CPU?

The extra mbm_update() calls seem ok. An extra call to limbo handler should be ok also.
One possible issue is the impact on software controller that assumes it is being
called once per second. Looks like an extra call can be avoided though?

> 
> It will then do:
> 
> 	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
> 						   RESCTRL_PICK_ANY_CPU);
> 	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);
> 
> This "wrong" domain already has a worker ... Will this just reset the
> timeout to the new "delay" value? Possibly also to a different CPU?

queue_delayed_work_on()'s comments mention "Return: %false if @work was
already on a queue" which I interpret as existing (correct) worker not being
impacted. I am not familiar with these corner cases though.

Reinette
