Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800A42D7D47
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074384; cv=fail; b=WtBUHZO3yUOODtrG7rk8tK1uvWhLq2GvhTRbBhO9txLKcv5EmFYNqExvmC5g4ED3JpRpN9NLbSey/haIvHeUOeI92PK7xNHKUiKiigbxJZOO5dOT6xAbXrTU5cLUiQ/gblDplAJLED/wyzKxrnu6yp5QlwdcQn0OpEx3qStgLFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074384; c=relaxed/simple;
	bh=UvdA27FxEJxjqJuzbCZqNRuhg71Gz0qsZKCI/ALlKHE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qSobRkRjxQUq121IcGFEBrtIdm8GOJuro90y4FylIFZuvDUFePWJyW5FnNQpY0SKSh48LH+xsqWDGOY9wNbYVsFokYZrpYznzA1U7+PLZcZF5RN53JkKp5kbWqKzlXO+42CsKraWb7vOvLn4FvdwH6CRmTyfvZf5Dew/VRKf2Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SZ+PCwKU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SZ+PCwKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074383; x=1794610383;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UvdA27FxEJxjqJuzbCZqNRuhg71Gz0qsZKCI/ALlKHE=;
  b=SZ+PCwKUDoYnR4bczA5+Qsdke8r27UVosVffi64RQCHPFiMvxo7VsYg/
   MVTc32lFoOusyImBDiF7/JbuSrRq5OhhWkF0ZAxpzPJzyqiDleWO1dyVq
   E5Hj8qBU60V6QDiMWEduCBgzhoAkESv8usvUi1iiycU+4xu7xBzIEU0e6
   iQYmZQVz8inYVhFzj27z+lNwLk5IMtQeJfYxu7Wrch1VeBJmOm3zzlJ7q
   yUXbXuV7gFMDY4yjTdQ5zjjZtFoCIlZekC8U4B2yCy4Tib76uGB4ZtCgj
   Wly3zKWNy0ADW/DJGIA06EGqC/us+FXC9owZaml6j/Vt3VA5BEAV6xG1L
   g==;
X-CSE-ConnectionGUID: 1lgoTC5MRVmiZTySBgrBfA==
X-CSE-MsgGUID: TitgUVqcQx2Xsqke+rVx6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65052543"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="65052543"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:53:02 -0800
X-CSE-ConnectionGUID: NImofLbPQ82+7DgiZwdNJw==
X-CSE-MsgGUID: 82xAysWET4C2fDviiEREdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="220467986"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:53:01 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:53:00 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:53:00 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:53:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uI4ezjhv5V78+EpNF3UQiXdFOZhI1DBkxvygqHt6mWef9VYV8B0HtXAeXP/patSL3J/qmgzYSmRH2TUYovRqP/zq3kO/EvZXKtpWrCGEi5RwxNU+pVBHSVtOoYNbKz0iyFKI6oV6F1Rkv05PeCVkcyR/9mHr52fZUJnG/+tlSzyxjIBr9vgMeALhCl6bsNLy3ijkz1Cb9xp0ygJI6zuygk6TVLLKF38xC02ZarRaF7S1qKfawNIHfrXiQy2sTb09I/pVmp4kDHcvUCa1C2kNWehK5ubOe9AAtS5mkzgkTSkhVQf31xnq8tiUriYVAhyviYavZojx7lAFJZIf2TY5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9heSZh3YnLfbU7cGvxRRP1hgZ4eGQw2VvqNlRURBDJA=;
 b=sStCbt9rs+0gW+l0QY8Ee9YLrlfQePm0/yfOXPAhZcDSWJDEBtRXjEwHpBysGBcAT2ZMx5jqMuJwujWRQvWBiyFG8yYWe5FLhlH70HofXfEKVZnscYVXZrXxTQ9NTYhW3cIJM9YR8sebvAvwQJKGo6jDTI3Bz1ssnc46HzeZKCx0LFzPXJaeG6ScuktNbKqzgf6WRsQ4VCxkrwgW4jNvOx1OMvkp9RJadrm5v2LBrq0zO79XzrlhlTexH0hyk2FaC6DHCMiQqvboADfUosVSr4HgDkq2TCiFPZyLx1uFOLg0QWUVg6+pJh6AAkBPWibjhaINnDZy0CXXy+LBqkPtfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:52:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:52:58 +0000
Message-ID: <dc10ea53-90dd-437d-b6d4-3cbe8158b8a1@intel.com>
Date: Thu, 13 Nov 2025 14:52:57 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-30-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251029162118.40604-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: f5723f2d-7775-470b-9654-08de23076456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S2IwU1VXV0VNbm9yb1FqZlpwUlhTckJXMUozNzVQQmJBc1NkN1dadWRyajdH?=
 =?utf-8?B?dnVqYTZ5dnROdVFXQS9xQUJXN3hFaTVLb0w4NXNxc0tJZFNyYU1WR0svUmpG?=
 =?utf-8?B?MDdHOURhdFJIUXpZbmxiUkJZK0NxcVdhSVpaVlVNdXBHSmFpd0JjWDJFWnpX?=
 =?utf-8?B?M0tMNGN3RzFnRTJ6emhSTHY0R2ovaXQ4NzZ4ZnRJYWVxOEFwekpINFdIWkhj?=
 =?utf-8?B?eEVmRDBDR2ppYXNnQmlCRmU0YzErZ012aDJBeUNyclN5T0xCWjZXTlA2MVlh?=
 =?utf-8?B?cEEwRm9HeHN2Q1hMWjZNRktBRysyYVA2ZkJtN0NMci9JUnVnU0lTYzVKYlBQ?=
 =?utf-8?B?WWl4SWtLTGlRMEpuSlNyVUQ2OEdrZ3U3QUJuVzlxbU9VbVVnMWlCTm5CWmRZ?=
 =?utf-8?B?SnNsNzdKdlpFNWVSRnRmUlg0R3hXSnZaRTRxS29xdmtMU25JcmhYNjhqM09R?=
 =?utf-8?B?bG9KaXdGVTFYcFBrQVNGZHJtZ0gyNGdmUnRYWGVYajNlVlFJbm9pZmRXWE5F?=
 =?utf-8?B?b2l3TVVPeGlNaWlhOEh0K3U3cVlLTWFFNUhiWlZKMDZhSkJNSTFqNzNpdWZR?=
 =?utf-8?B?ZndjU3oxL0tMb1BjWFdxei9kWkwyTzU5bm1pVVhtNnBxajhQUTVKWDNtQjdp?=
 =?utf-8?B?dlJmN3NNODZwcDdIeE40czNJZjM3Ri9LbFphQTRhcEgvTFdUSFhjc1AranFB?=
 =?utf-8?B?N1hBVkp1ZnR6ZDNBMTV3bEU2b2lkWmkyMGVGbjNZSkx1Vkh2UDBxZEplblBw?=
 =?utf-8?B?SnU2WUloQmhtZVdnK05kV05rd1loN2dkcXREcUhaTVdiUGdUQVhDdHR4L3pC?=
 =?utf-8?B?VXNYV3phMDlBZ3RhRXV3Wm1VVURSNEVLZXlqVU04STMxbkFLSS96MmIvQzRh?=
 =?utf-8?B?Z09FZGpOYlpMUW94M1duUzREQzh1ZDlSWVFpVXRNVWhMZGNyM0hiOTlIQlg5?=
 =?utf-8?B?TkQvazlpRlliOFV0anRkL1ptdE5NSVFvcWVwQTJaRnI0c2RBcll0dVFNU0Rt?=
 =?utf-8?B?QnQ1MTlaNmVNczU2cGdadkg3bGc4MUJjL3UvMjJmcEVLREVXMWlBa1lXMity?=
 =?utf-8?B?d0xXenRibDJwVFRUdWFjMkZLek0xVlBWeDVDZWJjWjRXZTZuaW1xYy9CMEVR?=
 =?utf-8?B?SjFYeVcyaENWM0hPZjBuWDhWWG1yTlRHVmNWSUo4NXJHeEVtNE5od091WFZ6?=
 =?utf-8?B?ZEEyTGxzZU84THBuVVNXaXVISnFPUks2YmxCeUZsbmFXd0RNSVFMZGZYc2FN?=
 =?utf-8?B?by8xMW84a21ncW84U0ltN1ptWnlpeHNDVmFFcUlWVWYzWXNhNWw5Ump5N1Yr?=
 =?utf-8?B?bGpMTXkvWEhXOGFrNk9FR05aaUxkVzlGYXAyb0trNWxkZGFDRkN0T3hoT3A3?=
 =?utf-8?B?a1NFUjhvQWVWQzdsN0Z2V2pHZ1NTQjlWWnk3R2NCQVJNZi9IbHY0aTQyc0k5?=
 =?utf-8?B?OHR6YmF3RVFEYTE2T1FoOXhVMExvbzY4MHl0OHFCY01GZkwxNzBodHNteG5o?=
 =?utf-8?B?aU44cmFiL2FMTi9uWjVXYUF5UmtHdkhCQlp0RW0wRGVCUDJFWWVNTjRNdTRI?=
 =?utf-8?B?V3NsV2NOMTBDcE1kZFdaUlJiY29zeWZoTWJuUGJYMHBPb0lsb21SU0NLM3Fh?=
 =?utf-8?B?UEVuaVhVNDN4YzFCQUl1U3JCNDIzZ0hyQXNUaUhUcEtJOWxWOVNlMmxURWgr?=
 =?utf-8?B?MTZ3aVdlMXYwK0NmOFhNUUJSRFVTN1kvL0VmYTZWUHI5NHpkcWVMOEVnRXUv?=
 =?utf-8?B?UDdtRXU1OVUyMnZHb1F3L1hUMk8xa3cyb1J1czYwb2NqUlNHNlJrQU5BUVpG?=
 =?utf-8?B?eFRJaGJMZFM5a0RQeWw5TTdJeHBTZ1U5dVR5WmN2d3NtMXpNTG00bFU0Kysw?=
 =?utf-8?B?enJJRGFGcWZlVUFFUVhJZEdmd2I0MXZoNGx4ZnFDOGJoeStBTk5Cb0piN2ZC?=
 =?utf-8?Q?kKikIfvN9mXpUDaoJwCx9mPEsUYZVIsM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjJmbVA4MVVMYnJyY3E4N0QyS0d4WXBYNkJtMi9sQnBPSUlnamRVSTVzM0NW?=
 =?utf-8?B?MW1qL2o3dFBRbysvbzlEdlRZd3ZWd0ZCOStDaG9VWHZjcUFWNldOcTBZVFI1?=
 =?utf-8?B?TDZiNWtuWEJrVVZvWmV5eXQyR0tDQ3hsR003Nkc1djNidlRtdHpFZk9YcEhO?=
 =?utf-8?B?K3lVcEh4WjdyVDBUS0NrdnJqQmpzVjdmWkxwcmZkM1hLTTgvZzZuVHBVbUxR?=
 =?utf-8?B?QlFOblpIVkp2T1ZEL3VEdzRVaERDL1dNZUYyOTZMTGpVSW9Db1FWcll2RE9j?=
 =?utf-8?B?UHg0disrVG1FRGVhNXRzNitLeCtVMW1WUGYyaVhCZHFoR2pVL0U2eGJxTzBD?=
 =?utf-8?B?Q2JlcytBTmg2clR1aldtS3hYNWVsTE9TUm1SS212RnlJOVh4UUQ4b2RJanJY?=
 =?utf-8?B?SWM3OU45VXpXNU8vb2xuVG9lR3pubDM3bmwya3lKOTUzNGFzdS91cy9HTVJM?=
 =?utf-8?B?ZGxxc3VqOWxjbEhCUy83SmxtTlVDcVNQVC9GWnFQSGFKVXFuQ1hsZkFBaDdQ?=
 =?utf-8?B?ajJqN1lZcllFbTA0MXc2MldOeHRjSXFFeFpjc3g5bWo4aTBWU2p5dW9Nd25s?=
 =?utf-8?B?bWZXakVoUHB4SzEvTjc0TFl6ZEdLQzlNc1dWMzV2SEVVenZkdWdxRTJoWGQ2?=
 =?utf-8?B?cVdHMmczOXpYa285VTE3cTlJeDFZNzUwNVhlL2ZMbWtXSlFEMzU5Q2J6N1Ir?=
 =?utf-8?B?L0FNbUNTa09UV2R4ZWMvT283MHc2clNoYjBnVmVUa0JNNEhESG1GbzZGUGhm?=
 =?utf-8?B?dDBMNCtrYitDSStPU3RscG9leVkzd0phQ3lreUZ6aW80aUQrWFo4Rk5RNTZH?=
 =?utf-8?B?QkNVRUFJV2dFampvZHQyTXVDT3Z5T0ZPVzhsdHVrMTNBSGFnQmhwd0xjK1Bp?=
 =?utf-8?B?VUxlOEFsSDR2T0JidlFvM0E1djRscGlYcnRiTFhHaXlEclZmK2FKanJGM1o3?=
 =?utf-8?B?VlQ0SVRsQTVvTFNoczVXUzhTakpSNzVHYXQzWlMrekV6Ujl6YmFka1loNlAv?=
 =?utf-8?B?YmJQV29VZ2VCd2NrdTMwL0VaQkpXTG1wL1dDQzNVMjhqMkNNZTlLcUg5Tm5m?=
 =?utf-8?B?cTJVRzlrQTVUdDNWQk9IVVhJaXhLN09GeVFOMjdMZXdEdDczaHo1aEZaTHRq?=
 =?utf-8?B?d2xlZGhaUWJad2d0Z3NCUDNJUGpMMCtzM0dhc1NSN3pld0RzWE1OUW10WXJE?=
 =?utf-8?B?U0JQTFQ0MXJGTWxuUVRtd2xoc3hJeStDRm84c212aTd6MG5DNVhWay9yL1p2?=
 =?utf-8?B?UHBsNHdvZVZVYUYyYjY0R1NGWjJBcklUaG1xL2NHaDhGRlllQVRab2tQVHJk?=
 =?utf-8?B?RURWTkZxQzZSYlYzb0NybG82b0xYNDB4Uk9oZ2tjTEd1K2xYQXVHMXhLUVVm?=
 =?utf-8?B?T2ZFZWlaekJSQ1BDb3dyeVNEWVh2cTJxZjNRakwzL0luUTRzUXIxSnMrWWZY?=
 =?utf-8?B?U3NCV1U2c1lQczFhYmRFRFhQSktoUmZ2RVFpOW9GN2NObTFiMEtmZmczczF0?=
 =?utf-8?B?bGV2d1lNaGw4SlF5RmprMkozczN6UzBqMnUyWU1WUHdrLzVabGR4em1JY1JJ?=
 =?utf-8?B?WXZzbFJnU2RSMitDakQrMVhUTlNlbzJhTU5kNHpvUEZjYkNxWlhId3A3WkN2?=
 =?utf-8?B?RHJmK2lSVzd6SnRHd1pyV2FLSkd3RDhNRTN4N1pjVWJpN05vTmlubml1Zndi?=
 =?utf-8?B?WHBQZ3pzMFVzQ0NIMUZsc1hjdUlESnQ0NFIzYnRRNEpjY3MybVozRWtkNzJS?=
 =?utf-8?B?TTF4eHpJaVVHWVh1S0JQMllmdDdtNjJpZzZaenlsa0JUcVllWmRxcUpJSXpj?=
 =?utf-8?B?RCtNVURDcEt1UTljZC85aTdCV0tBeHQwaDROQ0F6UTVxYVFOa01YYUNOcW9I?=
 =?utf-8?B?ZjRNaDQ5bVdEdmZqS25nNm54UUpnM0ZQeEZDbkFSSWVlWFlDZldEVDUyVHVy?=
 =?utf-8?B?M0tDdDNHclpqaVAzSENNek0zYTBJa282b2xvSzl5S3Z6ZE1HcVVWVVBINHlM?=
 =?utf-8?B?dDNxRFBweDZJKzIvKzRhU0xZeFlrN1hRNXQyaXltYVNpTU1OMEhnNVBGdDNl?=
 =?utf-8?B?L1NlVlhQRDlkYzNjRjJuZkx5WDZqdEdWdjRKWjNQc25sNlgyRzBGSnd6a3c1?=
 =?utf-8?B?bzFqRFR0SEZjcVIzV2dQZU56cHNRWkNqTythalFhNWVnbkQzaHoyWFF0YXBJ?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5723f2d-7775-470b-9654-08de23076456
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:52:58.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tBmSZpjuXu1yGBnrfyv1xbMQdY7LCGmW0EjfW0vqOdHSWr2vUD6rQRoihLfCRyJfoy+ZLcq8VTNiONHRZurn2jOaO6KDD9/XwXeIIINw9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> Since telemetry events are enumerated on resctrl mount the RDT_RESOURCE_PERF_PKG
> resource is not considered "monitoring capable" during early resctrl initialization.
> This means that the domain list for RDT_RESOURCE_PERF_PKG is not built when the CPU
> hot plug notifiers are registered and run for the first time right after resctrl
> initialization.
> 
> Mark the RDT_RESOURCE_PERF_PKG as "monitoring capable" upon successful telemetry
> event enumeration to ensure future CPU hotplug events include this resource and
> initialize its domain list for CPUs that are already online.
> 
> Print to console log announcing the name of the telemetry feature detected.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
