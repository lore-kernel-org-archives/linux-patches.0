Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792519E819
	for <patches@lists.linux.dev>; Thu, 12 Feb 2026 03:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770868461; cv=fail; b=iy3ekEn4uaMgfzQYj25/AbxDq6oWPrSPBR6/43Q6BkxIjkvAchuq9r83qfssXfV8+ZLjCw1x0er+LCB2tfZMCj0nNS+nChbmOxpou6ZPV5m3h5iUruoIOSM2Vs68T8KVlw3X20IUEMlLuhvdhNZmK5XnVObyKnxVQtsR4ERUG6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770868461; c=relaxed/simple;
	bh=WsFV0mBvRi5OGIgWCgGVNMRwAdo27JCLfKH5IUgF02E=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gAJzl2u/sekfWdklnC8DXyBOz+NA7EJtzZA4ks4KMBqTiRrhPPT+NvuokTqJm4PMIlImW6L9wI+gHfWknNaeo0RT310ZVu/OlmWatObm+P7hh4DusR/pxLI3SZWjFcxRfCr35ftHj1stgZtGJN91HEvQKexwLzXQD8N/p5AM7UQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FLruEHmz; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLruEHmz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770868461; x=1802404461;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WsFV0mBvRi5OGIgWCgGVNMRwAdo27JCLfKH5IUgF02E=;
  b=FLruEHmzsA/Ghbciv3XOo3b6yN4wcOgsEkupR4O4H8m/GxC5btbNcFV5
   Nl/pcAJUIunHx0X2foFMT0SI657W5JeoNZ+0dMSYVxuj9eMqYtd9KSZ/G
   Tr3WB1XPrRhM5wgFw1MfZy8HUjPR1m4O+RvA2JYtHqB8HMnayQglOYoO5
   3z6Ayqan1oTJfPKuXwHKBLXnJuWYAxWZd9Xkzgq/y4W+iLpun6ntTvvC7
   NOpUsx76ure/uIgAGAIs5czzgww6+MiRCCuiE/lPu5sAfZPeQP8IU9fdm
   0W+1aBDk0LpoaqPUaE+eV+cYY+IPhmWnV3Qf9RuTsPFLzz8hE/iYhu3az
   g==;
X-CSE-ConnectionGUID: JkYlS4V6RsC5zQVwb3efzQ==
X-CSE-MsgGUID: U9bcQ0dXTsiN594JzKKdKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="83135785"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="83135785"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:54:21 -0800
X-CSE-ConnectionGUID: Lp+OLq4zQq+1LUdojcPQFg==
X-CSE-MsgGUID: WfwtWp0jTkqXZ7YYUf3maw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 19:54:19 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:54:19 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 19:54:19 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.3) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 19:54:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2BLBwKEyLpLZCep0KXiWMnavAKFeCvNkifk2AWF2Pp2u+Pm986Mvjk61lhF4350bzaaJ/srgXmWnz7OcXAnUAyOeVJrDM5lCwaI+c/2IVMjWbIi3nZcAolMlfSfdgvmEoVsHgck1zFLYdXluM37A11pdGmF5HNYnLOJaEJGm4P6Rag5pKmhB6EIvnTXoUn8rFlGo7TR5ab6As7oNl86YVZAb2P6CotkgcPBJf8C/i9J9JyJ/I19NQuC9ImEH5oJk9dHZWvY+XeKmNunQ/B63fWhRT2E8XE/xb2W3cQBZPNLzqE9xAMHUkZDie79Bo8odFKWFTJkjhE1rlZBjmbUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQo7JTGd+X8Wf+NEEN36hawuY1Nd9LjLsPs/wxu3uIk=;
 b=ES6UDj52MsGyob8wRlrhB0doztYO3YAuOueIrEK2tiAt32O3/2kOpn7EwkyxxZoPm0FYwMGcwHhyEQUlUetiABhDFZUiQqBNEyDc3IW+Xvr0pibrY+SfdJoifOF3hs5iksfZP1/i6o+TAVskWWiaPYvR/KSQFrPOkqTvz973PbnIqgCtMvS7h3SBIdlUxdK6ErOIdePe/vEjMe8HAJvUDXvvEtppmjbUwRKDsY0jQBvSoNavQiYSkXCdGzmt3BmmQsp0haUQpTSoyryOOneGIqUhKhUvk8/u8Z7etSkuswQk1tTRfb1HJS/Cwmk8AOiCMMPYwU0LZK/M7UexIPC9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6339.namprd11.prod.outlook.com (2603:10b6:208:3b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Thu, 12 Feb
 2026 03:54:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Thu, 12 Feb 2026
 03:54:15 +0000
Message-ID: <1c3574bf-93b9-4f01-bd69-bea5e69da8ae@intel.com>
Date: Wed, 11 Feb 2026 19:54:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] selftests/resctrl: Support multiple events associated
 with iMC
To: "Chen, Zide" <zide.chen@intel.com>, <shuah@kernel.org>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tony.luck@intel.com>,
	<peternewman@google.com>, <babu.moger@amd.com>,
	<ilpo.jarvinen@linux.intel.com>
CC: <dapeng1.mi@linux.intel.com>, <fenghuay@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1770406608.git.reinette.chatre@intel.com>
 <a8928af52dcc2f2f5a97149416d009e267d23593.1770406608.git.reinette.chatre@intel.com>
 <ee039e1a-d2aa-4387-ab62-00d425e46423@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ee039e1a-d2aa-4387-ab62-00d425e46423@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0274.namprd04.prod.outlook.com
 (2603:10b6:303:89::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: 72041a7e-5be9-4abd-fdc1-08de69ea63d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bUtXL0g5T3ZsZDV5akZ5cHJuWlhtWTRtOVVxUURLK1dQU3grZGdSMUhTMGNh?=
 =?utf-8?B?a3ZmLzd6WjgxOTU5MGdVT1JyOHVCcjhSRCtnSWo1UTRIWmZ2MEZQRDg2clRq?=
 =?utf-8?B?cUFCOUJBbWwwWk9uSUd5ZThVbEpPMGVaK3E3Nk1Ba0M4TkVCNHlVWm96WkI3?=
 =?utf-8?B?OGNkTCtFTGZDRWp3c0UvbXZiY2FzeGhLUE5Ca01JdVlDZVhZUXBqVFhTTXor?=
 =?utf-8?B?cWtmcjNZSXFWME5CaGRoUVBCTXRWRjNRaGJHOTJqOGJPOERNMW4yOG1NWXZa?=
 =?utf-8?B?MVZWZkFFYm1NbVFOTDNQY3grTnFhaFBvSDJMdzl4eEF0eExTc1d4QjhnNWVZ?=
 =?utf-8?B?SlRJbXBwSlFrckpoK3RYckJGRWU4ZUt4TVk0RVZMOXRHc2g3RFM1dnNUR0do?=
 =?utf-8?B?T1A2T2MwSk1ldjVxNXE3R3crZGx6enF0R2hSa3F5eEp3bUdJTVcwZm0wSVVI?=
 =?utf-8?B?ZnlacVFMQXZaQm84M1lTdFBwK3U2cjZmOGdqOFZ1RmdURCtwVnQwNmxlYkty?=
 =?utf-8?B?WnNMYzFsT1oycGVZUW9GNSt5TjBiSUFPZnJISDcyYmNYUU1YK256b2kxUXNr?=
 =?utf-8?B?QXpuVjV0M3IwNjFTUzg4aDUrU21Ed01lZlRjYStqMzdmTWM1ZTR0ZURpRGdt?=
 =?utf-8?B?YmQ4ZFlTUE9DWUZEL1RUaTI1S3dQMjlyd29YTWc2L1B4MTQ4ZTVGK29qNzU5?=
 =?utf-8?B?dGNneDBmZDZXcElKRkhZR3JaMXhHNFdNeEZES05ia2lYZENXQ1E1NGh1L3Y4?=
 =?utf-8?B?VnlEbVF4OU5oZCtMVE9TWWp5ZUQ3SUdQb0lFT2tPTVZlamsvVjVQa0FMUVM0?=
 =?utf-8?B?VmJpcnJpaXp5YzM0azNjdGtySWZuRVlsa3VpZWxqRi9KaCtxMTIzMlZTYmZj?=
 =?utf-8?B?RmRySXVSQXR2Mjh2Q2Z6cHZ0amhYZnltc3VjQXhMMHozdy9qWlFWeTBhdmM4?=
 =?utf-8?B?dlllcUg3QnVOY0NwTHlncGVQanRUVW4zaGtYTHIyY0VrQ1ZjWnphVldlQUE2?=
 =?utf-8?B?WGhmOXNyWjRSTElNZE96TWFVZ0RBNkxSRndKdklVMVZ2Q1k2SS9kcnduVjVv?=
 =?utf-8?B?WW1SY3R4WHUyeWJoUE0zYlcvdEdUdks4dFVrc2JYNzBNWktFYTNUY0I1ZDZN?=
 =?utf-8?B?Z0dRcVJPdjRCQmFzNk1wUmlyWUxVMmVnRHJIL0J6empEK1UrRk94dEpmY3hP?=
 =?utf-8?B?WGxETFVvMDcreWJVQk9rNnZXRWNrTHR2N3BOV0xnTmNaTElFZkkvaWRlS3Vn?=
 =?utf-8?B?WEc3eUw2NUhLcEZ4eGNUb1NYUTIza00xYzZNVnpQZzdLY1BScXBwQ0xGVlJW?=
 =?utf-8?B?WG9hRkFoLytZOVM2TDlpeUVweVBWdVdsNmdGT1M0OVBsWW55QnFGN3FZWWlH?=
 =?utf-8?B?YmVDME14NUw2aGtyWWRod2dmWG9jR3lXWjF4OXliR3JEU2N3WDY5VjhJenl5?=
 =?utf-8?B?czc0Rm1LR3Q4YXlUUHpiMlJTdVJPRTlicUpEeXdJbTlRRk9kdy83bm9DNnh5?=
 =?utf-8?B?ZHQ5Ny9tWUZXaWYyQjdKZldQVnhhM1VhQnMzV0FLUjlwQ21PQUxzYkcyd0tT?=
 =?utf-8?B?eGRFNDY0Z2NuRWcyd29xaVJWcHkrT3k4dmlrR3JNeTZqRUlXY1RVVFMycTdQ?=
 =?utf-8?B?USsxUGlMT0w0SlFOaG05bG5ubmJLTzZyeHkvU1FqSWgwRUdJa3dramdPRzQy?=
 =?utf-8?B?YmFteFVqSzF4dnMvaUZFYVpJMXpYbzFYMitnNkFVd3Z0eUJtL3ZGd3lJdVlU?=
 =?utf-8?B?SDBtcHBDZ0MrVUk2b0o4cDB0cVlIaE0zdnF2NG4zczJHd1p4UzlLYnpTRkFk?=
 =?utf-8?B?UjV0VHlZbDFsZFVHUmV6VXNBeHAxdDdxTC93bmRDdU8xYlpiU1lRT3FWMlN5?=
 =?utf-8?B?QWVTMno3Z2JUTk5ScHVaQktsSUo0S1VnUlpxMnBQZjA1K3J4bDUzaHBCL2pl?=
 =?utf-8?B?OFN6WGZOdFpSYnFBeEhHa0dmWnB2aTA4d0pocHcxSjE2d0hSRXB0SU5RdHBT?=
 =?utf-8?B?SExLSEZ0cXFyaGlxSFhkZHBLUXFsWFBhZ0hkWVVNU2VGZU1pc0Vtb242OWJl?=
 =?utf-8?B?LzNhekZqeFlIb3pNVmx4bXI1L1dqNDVGQXpEZVR3cXU0R3BrWnRNeVBZencx?=
 =?utf-8?Q?O73c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q01YYUdwcFkvL1liN0ErN1JyaDFLaUJ6YjBFN1JmWWd2cXdoazdkUDBocUJj?=
 =?utf-8?B?SUx0VEtwOHlqOW56Z3Y2SitXTlRQWFZEdTBwSXlIaE55ZVR2N0NHZTROdkRS?=
 =?utf-8?B?dTYzRVp0NG1vVGxKRUVjOGt2dDBJQnVDUnNzeFFCT2RCdi9qODZSL3VUdVg0?=
 =?utf-8?B?RFF2NjhNZVVDRFN0czgxWTlMd3BaUjlnL1l5L0VVSjVCaFdncXVBRXEybkxY?=
 =?utf-8?B?L05zc2h2UGt1bVZhMTJzYWpHSzhPUFpYZmtGWGlTMlZMR3RwOFlCajhUWFpP?=
 =?utf-8?B?RC9jRHVXcFJkMllnYmZQU2E0NUFHS2YzNVNaQmhLNWxEVHc1QitxQ29NSXpk?=
 =?utf-8?B?OGNKN3lxcStaSjdvNkRiKzNoclJrT01pWVQwMnZ5VGtUUWtteWxuS0hSeHYx?=
 =?utf-8?B?TEwwNGtZb3VmWkhBdlozakljOSsyM0hXOEVHMnd5MnFLd2szMTZoNEhudTRF?=
 =?utf-8?B?K3grRmxXbVh2ZlVYcTRyWm41WlhDVFZuSlFCS2pqN1o5dGpFa3BjN3U2c004?=
 =?utf-8?B?VExsMDZWV0VjbExXQWdZcjV3NXE0SVNDdU9xZ25tMmJlR09SRVpoNzJaNnF1?=
 =?utf-8?B?R3lqQkJYanBJSUxxZ2Zacnp4RktmYmJzZWFpeHZJTFB1ZFljeGo1eVpuUFVx?=
 =?utf-8?B?NzN2N0N6d0FhLzdKMFBTMnZrcjhGb0dNY2NtSEU5K3BURmw3dFc4VkxpNVk3?=
 =?utf-8?B?MmhiRytxUktjRU9WM3pwTE5ZUHdXNGZLWU1YN3B3bGoxS29MVjc1czBhc25P?=
 =?utf-8?B?WW1pVTEwV3FOSHVONjlFM1BtbHRGZlVMY2M1bnJtZGIwcTVDWVZod2dRK1pX?=
 =?utf-8?B?cFhySzU0a3dXbUxNSUk0UUdHUi9iUHJFOUlQNklLYWIrMmFqckl2citNdHk5?=
 =?utf-8?B?QklTVFZtQUFvMVg3cndGdGdTZCswMGcwY3RTODZsNHdYL2tJN0ZKMldTTzhs?=
 =?utf-8?B?N2NYTmM2d1F0ZDdTTlJUV25oVmNUUEQwUEpqdkdyV1ZsOUR5MEtDeFNUOHEw?=
 =?utf-8?B?RWEvK0orTFdiYkFHV29sZkNFVlkzbVVWNy84ckFaeDdyaXJ5RmlRdkMzNlZX?=
 =?utf-8?B?eW9mNE1sVDEzWnlTVnJZVU9UcmVZOUtrSjBGd3kvWmNpSHZ6SnJLaFl5U2JN?=
 =?utf-8?B?cEUwaFlqOWRPcDFjeHJsc2VydFpFSGNGb0xPTksxREpKSXFDM205Qm5nYUxl?=
 =?utf-8?B?Rzc3VElyVHVlb2t0VnUrTXJTUE84RElielRsMlRPa3hHblQ2d2pJSWg1TlY0?=
 =?utf-8?B?eXZmbXhUNkJsMkZHSHNHZU1OZThvcW80TkRpU0dDTGkyaEFOS3ZOVnFOc211?=
 =?utf-8?B?cmkxQ1JMSWZKTFE1VnN4WmovRm14bFZNL0c0TXdNRE15T2FOYml1dytXendj?=
 =?utf-8?B?NEU4cmNuSHMzeis2VHJ4a1hPYjRaZ2ovd09OdUlWbEF6S1JxZ2h5dGRNbU1I?=
 =?utf-8?B?ZlpOa2hJMGx6bWYwdmU4Vm5lT2Y3SVpCcVhsMVpCWW8ydFhNMEV5SnFWS1RW?=
 =?utf-8?B?WEpMUUtzK2FWaGtIaVBUOTZ5d0xGNWM0V1hHcUJRamJZYjVpQThoVXc5eXF5?=
 =?utf-8?B?aEt4bXNwVnVEV1hwaFRZMjR6RVNOdk0ybzZBKzlKWEZoZi8rU1lNSXM2VHNU?=
 =?utf-8?B?QXViSHJlTTVCMFdNOHRseVp5SFhPYy9pUFFBdXZUMmdaT250a2RMZXNoNFZG?=
 =?utf-8?B?elJwUmduVnpWeUN5TnZXU3U3QzdPSVlzekcrMGpHbitDNWlvOUhHQXhlVSs1?=
 =?utf-8?B?UUdRZ2RrL2pyWWdqQUMyemRaODh2L3d0NlFpbm5Fc2hPVkh5OEZxRWNyN21v?=
 =?utf-8?B?SWVlM2ZWMFQ4YVVhaXdQbTZSUHRBeDM5Q1dPQ1NQMWtqUmN1TFY0TS95emlj?=
 =?utf-8?B?UjhGcU8xcDVPSFpOVUY5andTYWlOcW5IdFBIRjVHdE1ZakJzU1FKRkdCOWs5?=
 =?utf-8?B?RWFma01YSWs5ak9hVG80aHpDZWh0L2JQYi91dTVTaWdydDc4ekhNQWtvc0o0?=
 =?utf-8?B?ZTNjMExJTG1RTXdZbEM2QkJRd0ltaHdjbG8wM3RXU0QzME9nd1VQdFRaaGM3?=
 =?utf-8?B?UDk1d1JuVWZGTzlsNzRVR0Mxb3JIZWYxaHBVdEZIdVJqcGFHTkpUQlIzSTZx?=
 =?utf-8?B?UzlUMks3SWdUeXJPazF0VHJ1ODR0ejM1ZGgvWFcwVEpudjhmMDFJeVZ3K1cr?=
 =?utf-8?B?L3VvOW9tVURTTXQ1alFMTWxDSHZ0S2MvUndGTDJDTkwrNmpwNmpaYWZWaDBy?=
 =?utf-8?B?V2wxazBUY3JYRHNPdmh0S3k5WWN1YStpR2JhdEVFRlZ1N3h6a2h1SlZIQTNm?=
 =?utf-8?B?QnRCdENodW5WUEQvcmlaZUFJenR1d1piakdsQzU3OVBIRjgxTSthQlRoZEdm?=
 =?utf-8?Q?D0poA9exQjMQtq78=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 72041a7e-5be9-4abd-fdc1-08de69ea63d8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 03:54:15.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxwEsRlI4PLA+ojj1SPi+pS+BgulAxCNMSaGQaAVBmazUOC/ZxNLImz2Qm3J2ZUv+ew68dhtW1xw1w93GVemHCuymTue4iP3dMBFiPajTO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6339
X-OriginatorOrg: intel.com

Hi Zide,

On 2/11/26 3:37 PM, Chen, Zide wrote:
> 
> 
> On 2/10/2026 8:50 AM, Reinette Chatre wrote:
>> The resctrl selftests discover needed parameters to perf_event_open() via
>> sysfs. The PMU associated with every memory controller (iMC) is discovered
>> via the /sys/bus/event_source/devices/uncore_imc_N/type file while
>> the read memory bandwidth event type and umask is discovered via
>> /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.
>>
>> Newer systems may have multiple events that expose read memory bandwidth.
>> For example,
>>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch0
>>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch1
>>
>> Support parsing of iMC PMU properties when the PMU may have multiple events
>> to measure read memory bandwidth. The PMU only needs to be discovered once.
>> Split the parsing of event details from actual PMU discovery in order to
>> loop over all events associated with the PMU. Match all events with the
>> cas_count_read prefix instead of requiring there to be one file with that
>> name.
>>
>> Make the parsing code more robust. With strings passed around to create
>> needed paths, use snprintf() instead of sprintf() to ensure there is
>> always enough space to create the path. Ensure there is enough room in
>> imc_counters_config[] before attempting to add an entry.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Reviewed-by: Zide Chen <zide.chen@intel.com>

Thank you very much for taking a look at this work and especially thanks
for creating the perf changes that they depend on to fix these tests.

Reinette
