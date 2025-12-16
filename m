Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BD337107
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921620; cv=fail; b=nC4hygeSJ7x7oUhA93/RX67ZVcERpBD/QcPOleybOs5tlcvpPaer7e9QPfPWJfQjBQoo87k2UY71nToW/caJdnwqf0t7FfPx5bNVbbAHOf9ApWUrsOtdoY2aHjfvZ8EaeNgvq7SRE60FTBjVBSw3k1Wn7AfWTSTU/KSgGr366dU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921620; c=relaxed/simple;
	bh=1W+kmN7HjhtgroDGUmq8JqQbaUQZ6MKn6nLf4K7+J9o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O/ySeDwsWWyJNnVw0082FsoPJ8zgg6aiOWbmA7ZZtNnSDsGfms2M1AJpWgiszQMhW8V0baPyIHCdwwNp60cjXvFNVU6mQacdZxn0MoJaMdEe/ZviIrzI/44JGMxmBgJ6/tDnVjInlz4pbQ4q5kU1PoFgesWP6vwq10NgpEhh6OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=amXjCSPI; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="amXjCSPI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765921616; x=1797457616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1W+kmN7HjhtgroDGUmq8JqQbaUQZ6MKn6nLf4K7+J9o=;
  b=amXjCSPICwg9YXlQFKWB2ScWpqIFWnybC1GgOQcksSStSbfQN27rR3iK
   ZA5HLpHuu9SHCZIqT/IFkYlRDDD+oI8kyIAoWKbsA9ggWMG6K2DQS5HW4
   BveN+/lrHacnQLC1sXfPTaKFEVxI5o7LyOyWy7nVu9oMsHJCBbt1noKe3
   ZDxX7i+PrhchVBuQLrVgc3HFwv0cvcIqpZJ8Li42QYf77oLczq5nX25JX
   Z8yrSakv4fKeyPtTSXM9kBXT2cayWXhp2CdGCmjAI9Q7ETchUwC85+S4o
   90vb8KU0tpph23RBa/pFXdRxb/YdaEmsNKXrN4hP+qsuBxAoBopcoyY5M
   g==;
X-CSE-ConnectionGUID: W2R+0vsaQp6ZrBpnqb1cig==
X-CSE-MsgGUID: +h4MqF65Rw++cY3Wj7epFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="70428709"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="70428709"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:51 -0800
X-CSE-ConnectionGUID: VuEh55dxRkq88pLvKQDliQ==
X-CSE-MsgGUID: Ijlm33RRTjKRZqA8Zvopow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="203241668"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 13:46:51 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:50 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 13:46:50 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 13:46:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=We5ovcTlKU5xcUPr7IgqXXAUAZxBSAny80rUK3ck5IgFSW2FEU2ETulw5M/8z8SoHFT3USrpO0IjR7XluZVhbRFaB3Y0LHV9ORsoSYsnRD+DwaR9s8cjQ4J0z6910UzmSUP7MCrv1ege9dU47Vhs58cSeh3MyIFHwlXFefaHgXVNWHd8yv0n3r5/m/y+LCGt68Fk/o66z4cB+tG3P+EAY+bUMIEgS42G1aHijHocVabsKoUPT8tNe24dCqyf0tdK6u0GxrDA8mM8oBf78/GF1mU+tykPgk6S1fo6pvr5ZTQVpWPbo9fNlUJjTJikUFFTis/0CzsEieWgpQn+tbhDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1o4rYscRrqjnqxhZTvOei8QuVt4trnICrMWvOSbjFAo=;
 b=KdbHy+UvjcbCOdIsK1qBc8OzQ/QS0Yepp2+XWwTepfLePG4OLWVCI2uQRidZHRI/nQYN9fxsFhjWSWUv3fIS9dO1lvS83ASaImBwSt7BCG1Xa1BZIzkKDD8jsT4WKV3MtNTINPjEvFGZHoGOi4bCD4MfjNGdCho0mroIHEMbGquikojK/boikxoCRc7hpzVGXSgHEELpGFeoj7+XiUf2M3xYH3gTwbS5CbzyEFJA2tfZJNybxnpj/6u5YG1dVnD5RmivQNPekv6otDKswSVlYOgsDhE66syHMocMhzJCczmep5gXFw7ZMweIHtZZdSlYCVEZAK06sbqGGEumegN1Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 21:46:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9434.001; Tue, 16 Dec 2025
 21:46:43 +0000
Message-ID: <d8fccc3a-18c6-41b5-8d54-d3c42eb78216@intel.com>
Date: Tue, 16 Dec 2025 13:46:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251210231413.59102-1-tony.luck@intel.com>
 <20251210231413.59102-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251210231413.59102-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:303:b8::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eaa3865-b006-48e6-fc85-08de3cec9a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXhqQVZHdlZpYlpLT2ZqZyt4cUhTMUsxZVNFVDdrSm5WWWtGV0VjYXhVd3M0?=
 =?utf-8?B?eVdsVmdOSWxXcUpZb0Y3TUdOWEZUd0JTSDBwZE9mOVZDc0dQTTZBdkVVeXAw?=
 =?utf-8?B?RExKb3FkaUJaNThQQXEvUklCNDgzaG9zQk0rU1RqMVg1YzBMRFlqanJleTFj?=
 =?utf-8?B?UytCS3FGL3YzMFE1WENJc3krZXpUNnFJRUhGVkNCK2dhaWRna05MeEZxRnZn?=
 =?utf-8?B?R1F0TGdlZ3YraW1hbHFQcmR1WnZmRDJkOG1oS0ZhdHdReEI3VUY0YUZQYU40?=
 =?utf-8?B?d1hzeklycS9raTRYcndKZlNkQzZVaXdzQXNBc1p4czhkVEMvYXM1Q1FXUG1Z?=
 =?utf-8?B?U2l2SUpDeWUzeEZpc0FYKytWWENHS2FxQzBGZTk5VkJEVEtqb2dZVy9hUHIv?=
 =?utf-8?B?Wjd4L3FSV0pheVlSQzZCcGRNWEY1R21FT3FxWGl0UzdjZzJDbXVjQWp5V1hl?=
 =?utf-8?B?R3JtL1hKdjdZeFRZaytGUjBGM1UvNUp0VFdoQTJlNGhUU3JZS2RqazAwaVBE?=
 =?utf-8?B?YWk4ZEU4K3laZVNWbDY2RkJ3R3BzR1huZ3pYMmxzMzE4Sk5XUk1rRnNOK3pw?=
 =?utf-8?B?dmVlbXp3dmxjd0JLK21QdDJlaDJWMFRnenh4c1Vkck9LaHE5N3QrcHREUVpL?=
 =?utf-8?B?QWhpQkFoTWcwVGQ5U2dXbERlOGh1SzlGKy9jRVdqTG5VcExKL2FZZm1vYjVC?=
 =?utf-8?B?WVlLbCtTZzFhSmV1VCtSRTVFU3EvTTVmT2lpeEZlYzhEQkM5N3UwdTQ1M2Vk?=
 =?utf-8?B?SHRydWZYMFBON2tGbWMwVUt0QlVyYndONWowREUyZDdxNEpVMFBKZzdqR2dC?=
 =?utf-8?B?UUJmV0c5SGY5N3pKWC96T2RIRXFSQ2xvM0luNnZVRkxVYXlkdnlUOWw2R3Bn?=
 =?utf-8?B?OFhTWjJIdVlNdlNHOUZSdFdSbjNnbmVjY0svSnB5czdoZTZaMENpdUxBRm5i?=
 =?utf-8?B?VllybWVtTlpaSlBvU3FGdnB2aG9Eb2I5b2YwTXV1T1NTNGJzS29QRXZBdHpP?=
 =?utf-8?B?OVhkRXdtZkRMZllnL3ZLWDU4NUJVcVRtTml4YklDbmpMOXF1MFFtcHd0QzY1?=
 =?utf-8?B?NzN1SUsyQkg5WldJSUlyRmc1eVBJYXh2aG5OY2dBSzBQRDFkaHlENXNSbW5Z?=
 =?utf-8?B?blg1cnRMQjh2WnNRazd3RmtaenBJVHRXa0dVNmxZQVB0cThNcWhTQk5HK04w?=
 =?utf-8?B?Sm9aaUMxZFJCcWFjY2pWMHVNMzJpb3dNckhueExOSVNxS3Z3di9JR3l4bW1P?=
 =?utf-8?B?cW10V1ZydHRZNVZLRklreENodEZiU1M1Wm5XdVFTVUs2Ui9tU1ZqdEZ5VjBk?=
 =?utf-8?B?ODloQXIyM1hOb3c0Nm1ldTEyZTlOclJFZzFPeUNwMkFXQUlkTHhIdGFpVlhu?=
 =?utf-8?B?TzhpSW5nME5mb0NmT0ovY05ibjdwR29YWVN5QVhENlNaY3IxMXlXMWZNMG1L?=
 =?utf-8?B?elZLYUJQSG5oeVYzUXpLNG1tS1lEVzExUjNpOFVzZFpNUG5tTklXZ1ArNW1u?=
 =?utf-8?B?UEFvczJlME5VRTVmZG44OFhWaDVmK1pPVUhSVUNLUWtvcjdKcHI1OGhzankw?=
 =?utf-8?B?Y1ppbkpFVWF4dmhkN0wvNXdsc1lwVm1uY2hFVTBEdmN5QlNxQ2NLS0N1TnBk?=
 =?utf-8?B?clJpVWNrNkVCelRBYzBKZk9vZEZVcHNDeTRXTlBJRjFlc0VZSlJFMEkrSm9p?=
 =?utf-8?B?OWxhMDcxRnMwWU9VQW9ZWWkvWmRZWlBPWXpHZ1VPUFBHZWtwelFFcUczTnAx?=
 =?utf-8?B?RlRlUzcvaFUwUUtXUWtLRDF6cHYyNnZpUktQcTVsSVdxaWl3RHZKa1BrOTRv?=
 =?utf-8?B?RUgrL09oSHR0UGJyK2FtcFMwZGEvSktVL1dDeDJuVXlOS3lqMFRxWkd6V1Jr?=
 =?utf-8?B?YXk2ZlBWL2pzZ3dKTWpqQSt4MjFLeGY1UmpsV3RBZStyMFRFK2dxbzllKzQy?=
 =?utf-8?Q?EmMhX7B8fXRseJjv8FqRFZDTQtp0PvZT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlA5SHYyazZFSHFkQ05hY3MrQm1Ma2NOSGJBVEQ0NExHNERJc0FBMkkvTVc0?=
 =?utf-8?B?SHNNeGtLWlludXRQbjN3QUptYjkvY3lqdGNSd3VxZGRhQnU1UXVpWVc4Wm52?=
 =?utf-8?B?ZmFuV1kxbm1UM1p1Qnp0WHdVKzlHOVBLbE41cU80V1R6dzNSSmdZZ0VLUStE?=
 =?utf-8?B?WjBVREh5bm0vcnZUTzh0VXFUWjZwOFF2R2MvRFQySk1iNHpzZndVaGtseFdB?=
 =?utf-8?B?eUhZUEd6R0YvYnlzaVlDNnZpY3c5YlZ0bjB4SFVIbis0bVVjamc3SXYxaTlW?=
 =?utf-8?B?RUJpYUduQ3BNNFpselRuaUMrZVhVa1hqUHZ0YWZiMUdzSTZxWFBidXJGTThv?=
 =?utf-8?B?QlM1YWs2ZEkxeFcrdnoySFFVcDAyQ1NCQWRXcnR4bEhKYTl3NERmQ3NWenF1?=
 =?utf-8?B?RWV3amdlMmR1a2tlWW0xQytwRjB5aXJ4RmdxdkhtM3drKytWWklpVzlYMm5s?=
 =?utf-8?B?YVJsYjRSQWhid1FTaXk1K1o3TER5dy9Xd3dQa2hzeUdFRUVhbzRVakxNcVFS?=
 =?utf-8?B?WDBINnoyNkY4emtjd2JERERmeWNEVWlEc2REQ3VDbnNkWE9sQnFpWDZFb1la?=
 =?utf-8?B?NHBIQ0FwcDBDOWtaL08zaFFCOXo2dmd4NERDL1MvYVlhQ3hST2h2dnBkYUJq?=
 =?utf-8?B?K3ZIWE1VelpPV29kM0pRT2V6KzI5Z3VKeXVDN1VUQVVmcythNjFUSVBoRUJo?=
 =?utf-8?B?NkRza01WbVpFd3I5d2xnQU1qcG5xbmd0em5xYXU0L2ltbm5HYmtXeFBTWHBP?=
 =?utf-8?B?aDZZOHBEZFpmYlp2TzBUQzNROUY3ajhRLzJZclhkRlVYNXd4cmNseHYzMFpi?=
 =?utf-8?B?dmduY1ZFS25EY20rMEE2a1Q1dmh6S0JERU1ZSHBld3pTMk5hbWxiYUhuNUsx?=
 =?utf-8?B?L0tETkVjUEQ0VTVvL2hSV2FEWU81L3RXVWtxREdHQlljdmg1Uy9iaXFOTjVu?=
 =?utf-8?B?Q21zbmE3Q1A2NDNveHNXWHAvODJkeTBnYWc0Qk1pSUw2RStyS3dyWXZOcWIv?=
 =?utf-8?B?OUk1VHMxMm9uMnVmNkpxWnorVTIzdkhlbmdsZ3Rxa3BFQnJNdWpOZWNiQ3FO?=
 =?utf-8?B?WDBETXRlUTNGN3RHRVlrVlYxYU1NVG9oZGhobUF6TUNGLzhLTXlVTVcyK1NW?=
 =?utf-8?B?MHFQTHhyU0JxVzk4cGl1aGk5VUNzcTgxYVdSZ2FEcmhIazlIbnVmcUVPOXRK?=
 =?utf-8?B?bjVFVnQ4MTRqT3hyQ01OVHdlbS9aY2cvcWl0ekVKTmRKT29QV3lod3dTb29S?=
 =?utf-8?B?N0pYQWs2eXU5TTZPdWlxNTZwWlc4eHdRbHp2dy9kRUpwbWtJZmMxK1pxY242?=
 =?utf-8?B?alRnd2IydnFENEpRektXbnJZVkx2WTRTRjd5dzc2aGgyeHpjZ1ZSbTJVOXJu?=
 =?utf-8?B?dUEyQ2k5T2s3L0RERmc4WmdzRTFFWWMreHFPRGEvKyszNW5LWUE1Y0QrMHRm?=
 =?utf-8?B?SU5IYkErTVVmV0hVVnhSSmMxek9kc1NWQVFEcGR6bmpRRGFWOWtKckxtMzFD?=
 =?utf-8?B?VEVIM3k1THlJRkVQVS9qRUJMalNiVHZrL0NuZTZnUDB2MkV3eDl1bklzb2hJ?=
 =?utf-8?B?NS8yakRIYTFXN3VEZGJueHJTeVFRVEV3Mm1QOTF5bW5SaXByenVvSlk5aWIy?=
 =?utf-8?B?VEJOSFQycFkrbFM5ZVlJNjhpdTRWK2FWM1FTL2FucEgyU1EwZDk5QmI0MHht?=
 =?utf-8?B?NGlpejd6VHp5ZEJ6c3VBSGtYOGZYWDhJNXpEbllPTGl1NEN3VHRFSkhyV1Ja?=
 =?utf-8?B?aWRoZHZheUo4TGE4enorM2V3VTM4Qlp2eS9PSEYzSE1JUGJsYTY1eEJoNU1k?=
 =?utf-8?B?dUpDY1dLcHRlMGpsQkZtd2pQUDRQWWZlSE5YaDRRY05UcXlPWnQxRGZkNmtD?=
 =?utf-8?B?U2F4eHBpZTFtNHo5Um9wRm54TEk5UkR0cDdwUmZPV1Jnc2UxU1J3bWpsNTlJ?=
 =?utf-8?B?MFBzRHlCdk9YOTY5NUNGQVcvaTgxcVdXZFVjOGdrNlhQUUJkSXFRTFRCSFZI?=
 =?utf-8?B?bDNZWjFJMGZ1QTRsb3ZGdjNRTTRLejAxeGhyR21PRFNKcWNTL3VXSDZHQ3Nv?=
 =?utf-8?B?OUdlOFhQaHJEQXZXTTdITHQ4SUt1b2VmS00ybGNiNS9ldVlaVHVNanhWMG94?=
 =?utf-8?B?SDFQQnZpdDZUSGhtU1o5am5JWitXRnNpaWRJR1dXNmF4MXZkUnM4cGliVmVw?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eaa3865-b006-48e6-fc85-08de3cec9a73
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 21:46:43.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1PunyJuDAMnKhl7dbZe50P9k2kZwOliVFsr6VVJJ0f19oPN0SeVbriYxtn+Ry9KK+fvXhTS/fJjgG5Bl5SS3xDTDqT6fkFdyvEU/tqVwpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com

Hi Tony,

On 12/10/25 3:14 PM, Tony Luck wrote:

...

> @@ -202,6 +210,24 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
>  	return usable_regions;
>  }
>  
> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +	bool ret = true;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		tr = &p->regions[i];
> +		if (tr->num_rmids < e->num_rmid) {
> +			e->force_off = true;
> +			return false;
> +		}
> +	}
> +
> +	return ret;

Just "return true" here?

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

