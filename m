Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA732B13F
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960884; cv=fail; b=DsKlbNuHmm0io/Nu9fV9hYLxl6PZ6Z/OydGo/8zl2rhqgvU7HFhmvsi9ds7HdjWls8rpvyaiLQ3QPUDiSlcBhkJw5foFNSMzYF09PP5OUqdPSgWBdiqJ1Zs2hqXWxh4NQR5HnKRQqkUqVPaWmwq7INGzlW5JdcLtiCLHWIHrFT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960884; c=relaxed/simple;
	bh=93Sj8q3OS9E3KP5h69oYgGa3WDfN5mu7rbUrjZ5h+nI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QaxXebnI0hOYHPjOy2oLxoASit1MWZ1moLvg6ouh4kv5xDD7+keBFu1fgvOHLAp4Ek4rb0PHYckzBFV1NdZTpKsmPyd3ml07frqMPMOsUPppV/jgq1RUexfIrv7KB1tMW7UQi3CnuvylsiQ+lr8HzDlzDajZTQuwQ716XN9LuPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z0eKBkJz; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z0eKBkJz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960881; x=1812496881;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=93Sj8q3OS9E3KP5h69oYgGa3WDfN5mu7rbUrjZ5h+nI=;
  b=Z0eKBkJzTE3HOJ6yEAnxx9252nYKxt5YiPxGyMOj7H46WsJwfpYCSgOP
   D0Nh+aErYNt8C1vh4eA4fSVu8SUwLE+I+HqHV0CZxmueCgcxrZxyPwYp7
   IQKy+hk4Rqzzw67O8yam5PHkInOgyxUbwRQRvdxrIlvtsirudE3NuqYSf
   4nWGR72j4QgVP1h9mVgn5lXiz1GUC0XT2hl8PZwR3sSI1vSawBi/61iRy
   8eUE35D2J2oU16uvOJEow9n7bVecxW507n5Znvi+6jaPHBuMg0xSPYptq
   AvylHm2aQVr7DPwMabPdNtwU3qJmKKmzqNMHn1UzGdympCrDfGEASu9KS
   w==;
X-CSE-ConnectionGUID: DATzvhbiQRmT6bl/rINb2w==
X-CSE-MsgGUID: v/d+k1LNTCS179pJzf+GcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81565053"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="81565053"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:21:21 -0700
X-CSE-ConnectionGUID: EBzNmHKCQM6Enl7/S49eCQ==
X-CSE-MsgGUID: 0f4csN9EQH2a4+fv4xXoUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="275874308"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:21:21 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:21:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:21:20 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:21:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwDZuvyx1mh01/tLaTgU9pQ/kEg4LSjgYL16IYEqORIyrnHdB5dluJuZrGR3AfssYCQ7VhV4l5ucAezzfVqm2PtGqQYg9vR0wb5zvkSvFkxCROg7G8E4eRQv+KvHaAx2wfOFwoVamwP0XyCajqvYhCwzADpDv8jzzdddYvZ9BJFErRIMRnyduBA21Yjf7Lfs1DR5oKrrn1/TAFeFXCtLEGpKEFDG6oa7k2dbdsYQQNEvlN09WPR+LGYp6iR44BF1f8Jl/Ydq46kBD/OJfdKaja54jgcA3U9u5BewClY7s5MumsNvpMFc5Ai5Ia8lJy163v6UdwgajtInOUTU7Eq/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3i/6+UAXa5huHZSMc/FJOogS2vC7PvSiA/K6hRLG48E=;
 b=PlcBWGDaZnnSRWBMLv8epcphJrCnWuuD03qPsRwmgwhwr73DnswdkspoKzRU+KKHGIfb203P39GJTXEds24Buu8e5eRwB8zDFxS4osV1iKcCNGYFuoCmXWQXuMmqM6xZEBi/PxRVVOVQ0i8Wv6h9mynDziy8k9YKrGykoJbVllOtg3u3oad4r/OoMYR0LDsQiSJrcuYBRq5sKcd9Ypu0mkHW5j83uB3cZGgNLAhJVpDj9RVVtW4jsSm0RR2sz++qGdnd7vEFFvDShiOwTy6eYHRL7hrWqEW2ux53xlHeYtwCeu3o1UqvLX9DO2jAwfhZtuCRYfBdS7EYLycA0/S1fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 23:21:12 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:21:12 +0000
Message-ID: <2cd8dcac-9257-413e-b345-7c78bd77043f@intel.com>
Date: Mon, 8 Jun 2026 16:21:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/14] fs,x86,mpam/resctrl: Handle change in number of
 RMIDs on each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b9499d-cf25-44eb-1894-08dec5b4a119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|3023799007|22082099003|18002099003|4143699003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info: u4xjrF9nQS7ypZ2nFwV4HWLJSo67KCF6cUVmPNOqb9qgpTDBQpimJh6dpKlYfAxVdq7H6mpUYUNgu4A91tRN3G7LQ41LC3WmuOn+mlrOtQijFGDVk0AsICqed8n7cA70u2LrHa4q4MH/T7pOjSs5/duSR2yC542xKKLxxKw5/EVdftxG2PeYeLOsnPYd64dNWr+rTHhg0Rrv1t2BK5h5csf1slOrBScbSenQZ28lnP1M3Eubs08/z3BY9BwtFj5goWHXVfQsUCDGioxe3+Jqy3znTI+7JUYXeEDGqgliClST08sHKOdoZnV3rmX5T891vJAozsJkh+CXsegSAnHyS1cVYpUB0wgWFzjxFIYB759Cs0oCSHgZTqJD3JGFqOjirWt9lysB0C/IuggVktmzGFpmr3Ngxsx1AgJ0JFkfI5XXd2ShydEg2cuAIOEdd7BViY4OkXgDe5f7SKhvsBfQlhNwB6jsr/Fd/hbL7qM6+7S3HaIeW/4x3bK4v1KFyVrFLXffhXZPk6jJTZ9hT89lO8r8SE1lR0Z+k5UiAQr7ai136EUbiRD803P0QkiIOhp/egANbw9Lo+uioIktLX+3LTYzskFpmrwWAYVSI5BpqHugPeElDWer+SDon+29L3K9e+O3TVNa47DCkiFOaOhKq30n1+MvY71rcFRFwWeUinaw2uCkKTziGs3BSig0cM7XQ8ffnrnBmkxayjXGFQ9pGJDWkdZBMictymQ6lT0dwHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(3023799007)(22082099003)(18002099003)(4143699003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVV3RnZsTi90WTFLSkViMFVtVjNqOSs5RWkxMW9VNTVudjF6NUVaQ1NQbG94?=
 =?utf-8?B?VDlvMmRVVys4Q2huSE9BUWZ6SkVXQzdra0FsKzU3QVVUOXlhczZuUDhpazk3?=
 =?utf-8?B?eEdYcnZVOCtvRHA3RTd4cW5xcWRiVmtHM2xRYmdHcUlaTzlhN0s3OE9LWllP?=
 =?utf-8?B?ZXk5T3VLYkN4cFBLV2NUWkZiWVVXZFArVWQvakVWdXNtU2M4c2hLelpOYm9Q?=
 =?utf-8?B?SEdsZWNRLytKTDdQZWNzTk5PM095anNhNjhnSGM0aE5ySDlrL29oUC9qTUp2?=
 =?utf-8?B?YXQyMXhGVS92ZWZKYXRuMVJoKytuV3p5K2w3Z3k3R09mU2d4NTdiUFJpbmpk?=
 =?utf-8?B?bU83Z1ZXOE1DaXFDTTkwU0ZNUjM4b2NDSENYNDdxclBBOFZzNlNBTVNtQXRR?=
 =?utf-8?B?cjIyNzhzcE4xbjRqOE82Nm84b1Z3a21OSFhWa2UyU3JjbWduTS9LMnZ3c2NI?=
 =?utf-8?B?NjNQb1dZMTZPdWJrQmxPK2FHaWR4SFRCSXRrbFlPNVVLMW1lMzZqeGlkZk5n?=
 =?utf-8?B?aUVKYXBrNWZwbGt4ZVNOZ1JCMUpWZ0FlOSs2RnViY2d5ckZFbitUR0cvUWQ5?=
 =?utf-8?B?ejZoc01uREM5YkI1aWFFNms3Mlk0QjdyZVowUVB4eThDRGpIdEJzUlIwUSt4?=
 =?utf-8?B?bzB5STNFM2RPVG5XOTlmNUhDeUdXOUtwa0NOdGx4WTNYVGhPVkNKamdzckQx?=
 =?utf-8?B?R3NBbGhibWN6RG12dFVjd1g3SnFDRHE4KzlGK3RLNkZNYmsxUHNKV1dacldO?=
 =?utf-8?B?M09NeUJxNC9yK0krQ3Q2bjM2ODFhK0FvZmVINm04d3dlaHdaYXJSTGQ0OUgv?=
 =?utf-8?B?dHF6QXBkY3dhVUozK3NiM0dSeStobFNwMnMxWGtUNDNOS0hxNDhTUUxoMHo5?=
 =?utf-8?B?d3AxWm9MYk9MRnVDRHdlYVpudVRBSytCL3dqQ242VGY2M01nMWFheU9qZ1Jp?=
 =?utf-8?B?UFBTcjJoai92blRHOURBT3ZUZW9RZ25TakpYemM2OUtTUmZUME1yREpsSFIz?=
 =?utf-8?B?WDlrMzB3T1pDdDRuSUtneEtYdGxTQ0pWT3g5dUlMZ0N1Wk5OVnV4QlViN21q?=
 =?utf-8?B?TWpZSTBqLzVUSld2WDJHdWhSKzUvYlEzMDFsQTB5akhpeHJUcXhFVmNYbnpD?=
 =?utf-8?B?a2Exd3pUUjRjYm9tR2JrN3hZVHRFbXhyTGdwZmlzREZybXFqM0pjVlV3bTR4?=
 =?utf-8?B?eE4wR0Y3T0w4cG0yeFdMTVYxb1h1RGluZUVGcHh5Yk5tbElYSURCNllSN0xp?=
 =?utf-8?B?NExtZ3lmeUpJQlV5R1VpcnYrbm5BVk1MN084bzBhT3FxWmo4TTZRdnhQZ0la?=
 =?utf-8?B?MU5EZnpkbjVVUEk0NDRVUVF0WDE3a1RJdlRQUThxWGtacDludXFsNEZIbGZy?=
 =?utf-8?B?QUdWd2ZubjEwY3kyYWVYTTFMaGNORUd2eCs1dnhJZExMRWNYRWRPNy8vT044?=
 =?utf-8?B?cVhZbVNuQzBFRUwzakZTTGx4dmFLRTB6bjhEOW56Y09XYlZ4bnNTcFUyWFBH?=
 =?utf-8?B?bjArTEpCZU9tMVIyNHFvL25nVmhoRDV4MFZJTnpTTXhjSVhTUHlyRlVyZDg4?=
 =?utf-8?B?Yk9GQmV2VHpLUXVESG5raVpPMXhBNzB3a1Z3ckd1QWs5eUZ6ckwvY0JuTjVF?=
 =?utf-8?B?V0V1K0NkRTVaRzhRNVB5MERURGcraHk3MEdrekZTV0oya3BPWEgwY3E4d2JU?=
 =?utf-8?B?VVBIU01YcU56Uk8yTU5tMFFNNFBNM3kxUGJOck5yaEJhSit4RFdYeXhUcFpR?=
 =?utf-8?B?VVloTHpmb3MvbzJhUDFDb2xoQy9IcU05ZWFtbHZuekRvL3FYMVgzbHM1aTdq?=
 =?utf-8?B?d1lOT0NJN3EvVnVsOEVabVpXdnJnaTZvZ3lNdTdEYVc0VmpnOGJXVDh2S3hY?=
 =?utf-8?B?NzRJRGtKTis3b29hNEV5cUFHWi9RbVNQdWVFa1I2VW9EK3BibTRqb21VUEFM?=
 =?utf-8?B?amwrY1doZjRBL1JSamdIb1FsZW10REppZCs0aU1TZXduMHE0dDcvbTJQUDdS?=
 =?utf-8?B?SlZHRnhzUVNOK0pmdXV5VzFIa0xtRXVBYXlFS3g2WnEzRlV0YThScXVhaHJo?=
 =?utf-8?B?dDRha1gybVhqalhjWHQxNXF5eWdDK2ErOWlZbmhjOHdreEhDV3lYM3JYTE9Y?=
 =?utf-8?B?VEUzQWpSMnlkdi93b2xXVjdsVWpsRFNEelFzM01UOXB1ZDhwV1JEM2VuRW84?=
 =?utf-8?B?OWxhM3YwbC9Fb0FtSDVOQ054UFJYTERRVlVjampqOTlmUmsrbnoyVDlZWEZH?=
 =?utf-8?B?cFVKTGw0d2lEWXBrU3MxcXZ4MmNTMjUySEYvWGN1bHl0SDFpeUl0cHNETkh6?=
 =?utf-8?B?Zkd5cS9iVWVzY0QrRHFvWEg1dytVRFZ6R3Q0OWNVRWFSdElUNk1CSVUxT1cw?=
 =?utf-8?Q?2W7P/0An1qkekFDg=3D?=
X-Exchange-RoutingPolicyChecked: GkPsua+Dtbpqfh4igB3xWUZhmrN7iyWFAdWkNlfbps1o5bqmW3PYdicnhgiK+l07P2Y6FQaNb1i3AFxsDonW9oD1ZGagn5iAOW5MNXpoLkQw+S6QhBlfxQkhyAcdYsMywTEKZ4/wPwqPBuBHwDtsd/FLre9SyOt0yY+Cx0omqkIxRFDLcTZLt1ZVcYWsnBw7746+cTanedrzlqAeCRw9HjFMv9gBaJ7qrCw0dnZyA6BdwYaoDqpuPW5txwGvmyrhsee/sZjKzwP61Vj0568XMvr/iyo+/DOgh3RqpczAs3akv5fC+jNLzzZ1hgtG3InvlNJ1I3aBOjtdYxv2qelxPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b9499d-cf25-44eb-1894-08dec5b4a119
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:21:12.2996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fa7HvcF6QKQEa/cFbfqHJsOK5RrWlRIeJolXxmJSYGFIgD3fcbf7mFJFVRusgpCTsK5rC4ti1j458IM6NtqonWaVZwofTq6upuEfq1Le7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> Application Energy Telemetry (AET) event enumeration takes place
> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> kick of enumeration early enough that it completes before first mount of
> the resctrl file system.
> 
> Allowing pmt_telemetry to be a loadable module means that it is possible
> for different numbers of RMIDs to be supported on each mount, depending
> on whether pmt_telemetry module is loaded.
> 
> Add resctrl_arch_system_max_rmid_idx() interface to provide the maximum
> supported number of RMIDs on a system. For x86 this is RDT_RESOURCE_L3
> rdt_resource::mon.num_rmid (if L3 monitoring is enabled).
> 
> Allocate the rmid_ptrs, rdt_l3_mon_domain::rmid_busy_llc, and
> rdt_l3_mon_domain::mbm_states based on the maximum possible.

This is a significant change to data structures expected to be
indexed by RMID. Could you please update kernel-doc of these members to reflect
the new usage?

> 
> Initialize rmid_free_lru based on the number of RMIDs available for
> this mount.
> 

Above three paragraps writes verbatim what can be seen in the patch self.
Could you please expand the changelog to help reader understand why these
changes are made?

This patch is quite difficult to decipher when one only has the code to consider.

> Note that some RMIDs may still be marked busy from a previous mount.
> Don't add these to the free list. Check current RMID limit in
> limbo_release_entry() and do not add out of range RMIDs to the
> free list.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 1af8f965fdd0..934492c7e643 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -129,6 +129,18 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return num_rmids == U32_MAX ? 0 : num_rmids;
>  }
>  
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> + *
> + * Return: If L3 monitoring is supported, largest possible comes from L3.
> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +
> +	return r->mon_capable ? r->mon.num_rmid : resctrl_arch_system_num_rmid_idx();
> +}
> +
>  struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>  {
>  	if (l >= RDT_NUM_RESOURCES)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 226ff6f532fa..7079870ca894 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -272,6 +272,11 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
>  }
>  
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
>  {
>  	return closid * (mpam_pmg_max + 1) + rmid;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 327e7a863614..b374e2f84a75 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -115,10 +115,17 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>  
>  static void limbo_release_entry(struct rmid_entry *entry)
>  {
> +	u32 idx_limit = resctrl_arch_system_num_rmid_idx();

Having the code switch idx_limit to sometimes be resctrl_arch_system_num_rmid_idx()
and other times resctrl_arch_system_max_rmid_idx() makes this change difficult to
follow. I think it will help to use different variable names to differentiate 
the context in which it is being used and not leave reader trying to understand
why there are *two* limits.

>  	lockdep_assert_held(&rdtgroup_mutex);
>  
>  	rmid_limbo_count--;
> -	list_add_tail(&entry->list, &rmid_free_lru);
> +
> +	/*
> +	 * Limbo may be freeing an RMID from a previous mount where there
> +	 * were more RMIDs available.
> +	 */
> +	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < idx_limit)
> +		list_add_tail(&entry->list, &rmid_free_lru);
>  
>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
>  		closid_num_dirty_rmid[entry->closid]--;
> @@ -133,7 +140,7 @@ static void limbo_release_entry(struct rmid_entry *entry)
>  void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
>  	struct rmid_entry *entry;
>  	u32 idx, cur_idx = 1;
>  	void *arch_mon_ctx;
> @@ -192,7 +199,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  
>  bool has_busy_rmid(struct rdt_l3_mon_domain *d)
>  {
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
>  
>  	return find_first_bit(d->rmid_busy_llc, idx_limit) != idx_limit;
>  }
> @@ -916,24 +923,32 @@ int setup_rmid_lru_list(void)
>  		return 0;
>  
>  	/*
> -	 * Called on every mount, but the number of RMIDs cannot change
> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
> -	 * until resctrl_exit(). Note that the limbo handler continues to
> -	 * access rmid_ptrs[] after resctrl is unmounted.
> +	 * Allocate the largest number of RMIDs that this system will ever
> +	 * need. These cannot be freed until resctrl_exit() because the limbo
> +	 * handler  continues to access rmid_ptrs[] after resctrl is unmounted.
>  	 */
> -	if (rmid_ptrs)
> -		return 0;
> +	if (!rmid_ptrs) {
> +		idx_limit = resctrl_arch_system_max_rmid_idx();
> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> +		if (!rmid_ptrs)
> +			return -ENOMEM;
> +
> +		for (i = 0; i < idx_limit; i++) {
> +			entry = &rmid_ptrs[i];
> +			INIT_LIST_HEAD(&entry->list);
> +
> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> +		}
> +	}
>  
> +	/* Find how many RMIDs are needed for this mount */
>  	idx_limit = resctrl_arch_system_num_rmid_idx();
> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
> -	if (!rmid_ptrs)
> -		return -ENOMEM;
>  
> +	INIT_LIST_HEAD(&rmid_free_lru);
>  	for (i = 0; i < idx_limit; i++) {
>  		entry = &rmid_ptrs[i];
> -		INIT_LIST_HEAD(&entry->list);
> -
> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
> +		if (i && entry->busy)
> +			continue;
>  		list_add_tail(&entry->list, &rmid_free_lru);
>  	}
>  
> @@ -1156,7 +1171,7 @@ static void mbm_cntr_free_all(struct rdt_resource *r, struct rdt_l3_mon_domain *
>   */
>  static void resctrl_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
>  {
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
>  	enum resctrl_event_id evt;
>  	int idx;
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index d2a1f88d8782..6d647b71c5db 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4416,7 +4416,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   */
>  static int domain_setup_l3_mon_state(struct rdt_resource *r, struct rdt_l3_mon_domain *d)
>  {
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> +	u32 idx_limit = resctrl_arch_system_max_rmid_idx();
>  	size_t tsize = sizeof(*d->mbm_states[0]);
>  	enum resctrl_event_id eventid;
>  	int idx;

Reinette

