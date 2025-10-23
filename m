Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821D158535
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761194249; cv=fail; b=s6tDUj7RpIvynkMrqBbAjmy7WIVL1PZFX64lTV4pQ0HJUXg6MxuIjQYWmsNMsLLEvid/Ci0fzGcPGtjvs4qkpVC5j0kfRkizGxzwa+PISLyjhEQ/rBngW+5yLaSN7rxWSkb/rxhB6B9N1glF3TtqmGcVGSmT0teTbL22PUEXeBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761194249; c=relaxed/simple;
	bh=9cDNPw/Qu4aum/mfAB9kztGIbdxS1GzY3NmTafx2e+I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jWYamqsuNj+AIouqC1qXqC3yXCYHTYu0zn5dH9NG+3oI0H4RAY1nPZ2rw/TzuMECxH/5KEpZtM2QyeUT2bd09hra4Q5z+I2k8o9W/Ty/aIHvqySpOzhtOSLe0wVwSM2gPAoYhqe7BshvsUyxWihWhZYni1B0kehKfk1kjU8mcmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LIbieVmC; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LIbieVmC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761194249; x=1792730249;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9cDNPw/Qu4aum/mfAB9kztGIbdxS1GzY3NmTafx2e+I=;
  b=LIbieVmCcxo5bk+dz0Tn53aiP46Pa7owsnKoL8cceJGwwK87Obznx2S8
   C8GNKXkiKeAvSo1jMaEo+MKbhgHLMX7J6fquR8Q/WKCR3+Xr32JfgJUBv
   DZMkF/CF6ifU7bJhozY4i9qP6f2RSXoveenUg/ZmKAlS1dP9YwmP4SMSe
   Scw76+e0tYIPxE7VrdfAQRo/G9P18WjPucO5LdlhEruqQn8X08eZp0RSo
   +xqt5GhCk4IdugoPELqAR6PEHn/Ltosqilievquk6rYQo3/nmYlMH1qkG
   zio+cvwIVnFjFiQx2zct9WoHwuQiIWeya2R+h0EymIZLGaJq72oRLgoQ6
   A==;
X-CSE-ConnectionGUID: UUePj3/HQTKFx6dRP8MhzQ==
X-CSE-MsgGUID: 4KtsVHJvSeaMs3xAZ0WpZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66997993"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="66997993"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:37:28 -0700
X-CSE-ConnectionGUID: vDZzl83HTBCYRVnoYXMBbA==
X-CSE-MsgGUID: y9It74lpQlu0LjR+BlmXoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="188342430"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:37:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:37:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:37:27 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:37:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ag/NdQYJL1GdzYvk8/g/LO6DGP/oAU5ojHR7of/H1FsprrT/r3ip6xtkSC+1xBi1EdtLwjufo7utBWemd6ynpn8HYRTdRMiY6+7bD88O/lR2NBb1V3OCNdf5n3iG/ySa2Wh37nkKGNv8yUlD9GxUfZOicTFre1aWyXPRC33uXyePTQX/IjDA4fdWT7MiF4lulKEbLZe36j87nD0eHwPktt6WPXpbhpoa5rnBaq0EV2FTFq1HIgFz7Q1CSilYNgPybGZEMk99tYOOYssfMshGTShwIO5Klqp6CoRC4F9p8mUDgYECMXBOLCTY0Je8lQmzxhwFRdMVahNgEbH5pIRs4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOnS2E88JAWJewJt8o2HqpTHyJy9zL6tGwO9ZAF6bB8=;
 b=SD06BQkkv+uRRWtSY65uWP9GKw17NoGdWozSjiwDPGOD3hWpTg5/Q75L4rG80tgRY66t4pwu8NUvKB+oftG4VWNkNguiE8XTlkNDQt1RX+f7RsMxRSCk8EQyH+fuoJqCX4v9ebs57Z7ETSc0q5d4fPZcA6RxgzLyKHSAfZcg5JVu/qQGC9/1041QTSHm3OBFA/KCndZlxWTO0ACGzU5wBkH3Nte5C/Q1cOu1N13FVfraOONZz6cYChl8CejSliv4Zz632JCt+aBD4m+i1Tr2OjbvdLiC1d0AD+VzEsXLuUI30NUyo6CjhAuSlp6K6zzbBR5kInOXO9sP4jlbh88meQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8544.namprd11.prod.outlook.com (2603:10b6:806:3a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:37:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:37:24 +0000
Message-ID: <c6a929dc-0362-499b-bdf8-7f0cb43e8402@intel.com>
Date: Wed, 22 Oct 2025 21:37:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 18/31] fs/resctrl: Split L3 dependent parts out of
 __mon_event_count()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: dc62d417-b96c-4532-e589-08de11eddd11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVhvMkgrdUhoNTFGNmljM25QcE5kcnFVQTlHR2d0Sis0NEtqMnlHUDNLYWNF?=
 =?utf-8?B?dkNBektpNVI1T3U2UmJMSTFMbjhCSFNMVVJIcEQ1M1lKVTMvSHV5N1daOUIw?=
 =?utf-8?B?KzZKcjdvM04yOW5tZ01BdG1YUFJlUThUODNMSUw4TkhnMG9pbU5FNE5KVm96?=
 =?utf-8?B?ZXNlSFVRVWhMVGpMQUcybkRydUtUSEt3VGkwd1ZrYnpoNDlocHhVbWYxR0JL?=
 =?utf-8?B?UnlMbXhwMFR6UmVSMGkrYmY4MlpnblZTQjBvcmZEOVlHTkx5WVF6dTZCZ2oy?=
 =?utf-8?B?UnhNaW1PM09TQnpJZzFENXUxSmM1WVpvVUwrcGhScEx4bGFkZWtkR21JNWtt?=
 =?utf-8?B?dm9VRlh1N0RNTko1YUtHd0FSeFE2dnhoNkp1ZWppbnh5eWJsNGJ3Mm1lcldi?=
 =?utf-8?B?ZzdqVFYxaFJIeGp5WWZaSDM4TkkrUlpubkp0NTkwNExmTXY3cjJjNmVxTlVW?=
 =?utf-8?B?NW5uSjBHcFBMT3NyUGdQaGdNN3RqUkd2eWpqRmQxR25ISmIxL0k0d2lCRDdI?=
 =?utf-8?B?NXI1YitqdHRSZVVVdDVVTkIxWktqRDBNbE1semxORkdNTWs1QkxjRG45WWVq?=
 =?utf-8?B?eWh6WmVEWXFXS2YwMWMwa2V4RFRWZ2EzNVBWbFZmMjhJY0VZaks3UEZtR0xv?=
 =?utf-8?B?c1d1TjJNS2R4R0RqWFpOT0twQ0RoMllMR1JkejlES3ZUM3ZZSG0zb0cxY2Zu?=
 =?utf-8?B?VE42SUhUYk45NnJ0RzVEbmtLU0NCdS9UZVR5aXdLWnUrL1NzbmdIWnNVc3FT?=
 =?utf-8?B?OTI2V09xS3Zva2kxRElnRVRXdjJkUXg2N20xRE1hbG5IaDgxZ2tVMjBLa0NQ?=
 =?utf-8?B?cWc3dnkwVTRkQ1hNWCswSEJBcEF5WEpPTkdVczlkRkc3THdjMGluYW1zSmIz?=
 =?utf-8?B?NDVMTFlMcXZrUSt1MWxTeWhsbnB5UkJQK3lNSHFNU1BCUTI4TTc1bDExamxO?=
 =?utf-8?B?VWdkcXBxZE1wTHI1U1ZUeUZwTEx0SjUxTXdHRHYxVjAweG9jTjJuQzFWUTY4?=
 =?utf-8?B?RG9BdHNrZzdrdW41TmMvdDltdFhNUzlBdnN6SFE3d1QydGhoYk5oZ2YvenlP?=
 =?utf-8?B?UkpSOUw4WEpUT3BnNEFFMEtLNFpHaUM2UksvbllYeHcrNlNMbnJkY2grMkRC?=
 =?utf-8?B?WStHZE04WERkUTdWd1R5Y1RYT1dzZ3FUaWJoTjV1QnI4RXVadFJCS0dkYW44?=
 =?utf-8?B?OGpMVllUZGdNWGZ1YWVvcVhwMjVuaTFnU3RXaTNwUE4xbzNzR0lzQUY5aHpN?=
 =?utf-8?B?c29qUkh3aEhUVDJOYUF4ZVNKMS9zQzJFQzlmN0lhWGVVNzdnY2NiSnpLbDAr?=
 =?utf-8?B?SXpyOXpyU0MxeHVrc0NSUlJicExRNVhpYnFwM0xHb2ZDRTJJUHJJY2Eydm5m?=
 =?utf-8?B?TDZUK3lnNndYRld5QWJYK3h5VXBhM0tjSWcydEFud29Wd3NhMTNJUFFGUTF4?=
 =?utf-8?B?ZzhpM1FzaDB5cFdpdVZnTThHSkF2WlluNnFkSFNoMnVTd0lLWW5ON2lYQTdp?=
 =?utf-8?B?UlpoQVNmM1JjREJNL2ZBaEFCTnhJQkFodmxhbHcxU1VJakNHdkhBSnpFb2lR?=
 =?utf-8?B?ZVo2eFBSM1BMVkJ5RzVYWFdHY0NIY2QvLzlpSUF5RVB2SElDVkZyM1p2WXdL?=
 =?utf-8?B?VVNmZTBXeUZwNDVZYVY5N1EzZXFBQnRHMUw4Vnl3MWg3b0s0K203a25zek1Z?=
 =?utf-8?B?TTRRSDBFd3FmSy9sQXExK25MU254dmRkQ214YXhwTHJSbHA3REZKa3ZqOW0z?=
 =?utf-8?B?SEplNUhJMVFTTXU3Z0tReEpoV0Z4V2hZWlNVT2YrRVFpblduNUJKeTFkeUZH?=
 =?utf-8?B?a1poWmpkWUxuQlVQd0lVKy9GUnBPM2V4Uk1BZ0VCQk5xaDAyNnR2aUdVL1Zu?=
 =?utf-8?B?T3ZWU0U1Y1dDRUxPRWMyTHNZTkJ3MUhBK2twYjgwTDBuSVFTVEMzMnI0RDNw?=
 =?utf-8?Q?SoOZhQSdEYmqociOUbDVoRBJbtifg6z0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1dJRkhZRlkyR3ZBZXcyNVVBc1Y0UUVUMlJ6MXFTa3pvLzZTQ2JtS3hya09X?=
 =?utf-8?B?aUZUVnFHMEZlTWl5VytoYlhsYThFZmNkdjZEdGxLZmZidmx1NGxYdmI4MjhB?=
 =?utf-8?B?dGJ4V0dWTGYyUThhRXYybXpOVmhrNXI4cncwTGRLYUxzRDVWYVprVlNsYkw4?=
 =?utf-8?B?MjRMWXkyWFZoUjVOYnJiZWdJSFFYbTN3cUdLcVZLQkgrbjE2bDlicmhDeDU3?=
 =?utf-8?B?YkY5SFdDWWtOVW9ZbHd1bkQwRzAwOGlmNnh0NlN3UklVb0pibWc1OGR2bnJv?=
 =?utf-8?B?RzJ1aWJBbVdiSlVmY2JwNXZCVmtDR0ZoM3FIb01JKzJXRmtUQ1I2bStlcGY3?=
 =?utf-8?B?WXF1USt5b1I4TDFscXFETFptazR1SkZhZkJnSVZYS1hINmNkenliRTMxL1NP?=
 =?utf-8?B?aTZrWFhEWEFBcDZaYzZnNlc0R3p3Qnl0VHhia2RYNFdtVmhqQ0tsMGJBM3hW?=
 =?utf-8?B?VEU4Tncrb1o5anhSMEtsbEdaRXZEL1ZjTWZMeCtsWmliclVzNGliZC8zQTJG?=
 =?utf-8?B?WGdJR2NaQ2JCRzg2TitrUklzd20xYmNsTGo3UlJWTjl5VGFvSElON0xTajhi?=
 =?utf-8?B?eFZHRnFJUGZaK1NuR1JPV0Ztclo4MU52clpRY3NwbnFGRWZlM0NTYzhHVGxo?=
 =?utf-8?B?K2ZIUGIzWGxuQUE2d2dYdFViS09vNjBCeHR1NGVrZTNFL1g1K2xZb1F1WlBC?=
 =?utf-8?B?V3pyN05aNFNtSTRmTFl5UjU5ZzJTWjRlMSthbVdyamxId29iU1NzN2ExY0NX?=
 =?utf-8?B?L2N3dlowek91a1VaZEh4Z1NrWGg0MTZ1WHpqV01LNFRpd01tWm1UV2hGNGU5?=
 =?utf-8?B?eVR6c0E4dHYwTTVPVDFCUm9rb01OT1RXVzg5eG40ZmRkU0laMnpHU0E3MFVX?=
 =?utf-8?B?RVVpeHBxZ1JGVDJIaTRLN1JQRTh2OHMyZ2FNWUJzelpwNEdHamp4ODRpaWN5?=
 =?utf-8?B?SnlMbnpLSW1vQm9TazZNbCthY0VSaitvZ093NEc5djZEMU9pM21CbzN2ZEdT?=
 =?utf-8?B?VWRzazI3bnByL2xkdTB0TWs4UE1RN05PVnd5Q05lL3RUL0JDeFlBKzU2UUxH?=
 =?utf-8?B?NUR6dmlMQlhRNjdkVGo2ZEJrSHMvd2dvTnNINXBMTUVFS09UQUw1VmhXNktV?=
 =?utf-8?B?eVlsd0ZmNi9uNjRvYlRwc0dRc1E2OVhCeFFEQXc5c2ZwSks2aUhmQVJIN3cy?=
 =?utf-8?B?WkRxVGZQRk9iY1lIMU5sZkNwUDFMSklyMERXcEdrYUpxVXNvSUt5UjM5TUhU?=
 =?utf-8?B?d1R6andzWk9hVUFRdy9aaFM0cW9ha2RXNitHSE5Oak1zV3RETUx1aEE0dXJp?=
 =?utf-8?B?eFdVTUhkdERxSVBRSzg4K0kremZvZ2JkaVhZQWNtenFYS0RMbTNGZGo3STd1?=
 =?utf-8?B?UWpqbEVRbHZzaC83cU1uN1o2bndxNmtKQWhJWlk0OHJ0a3RScmxBWDV1dENy?=
 =?utf-8?B?bVpnQXFmdndXTFNFcXYrdFc1Nm9yUysxT0NHU20wb3dMY3JIVXd0MERFSEtw?=
 =?utf-8?B?OU9vdGgwMko0M2hQcndKL2EvbUgzcy9zcDVuUWp2L01xcE5Tb1JMYjV1L0lw?=
 =?utf-8?B?dTMzNkpOb09Vb3NuRGplbXMvQ0lsR2xPR3ZSQ09yRHFNWjBLM2lPcDY2NmRm?=
 =?utf-8?B?b0c0RnE2UnlOOWpxQmNDSHc1OE83NjJuemFXeEJrWG9yOGl6cmo5YWtTRm1i?=
 =?utf-8?B?ZHJTT2JZQnZxREFXSmZSU2daT3JtY0pHcm5PNEJmS1VIejZYdVphalBIWE5v?=
 =?utf-8?B?dkRoR2VqdFRRUzBtQlVmR3pNNWRtNHppbWdhOWtOT21aWUthRmlKNThodWNN?=
 =?utf-8?B?M0oxTjJRcFFkWFV1UUxRTkovTy9IT0taalk0OGZOS2V0RTBUQjRtOXVKSENN?=
 =?utf-8?B?RnFqZEJ4ZWNrZ05LVjJ5bTY4U3ZQZmgyNExrMWgwRitLTG5vakxDcTJUTWZG?=
 =?utf-8?B?dG1zbUNaMEx5eWhRT2EwSFVWMUFtRzU0MXJsOGNmdlord3lYV0RCcmNCS0sv?=
 =?utf-8?B?eTlkdDJCdTA0cVJ4UkpnaEJvMDhXbFZSQUtBTWo2WFB1VVpSdGRDRGVZWFNr?=
 =?utf-8?B?cFh3QXBpMlhyZG5Sc0haNmlsZnBWY1lEWXlLbTZxN3FrM2gwd2I3dW9VbmJm?=
 =?utf-8?B?eE9WMHorOW9KUGJZQmhqeDg2R3h1MlVJbkJQbkJZazhiM1FvNEJWTFJlcmha?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc62d417-b96c-4532-e589-08de11eddd11
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:37:24.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69G97f7vsfyb1938Kq6Y+nrUSekCqVtK+K8ZV80KCdm7y2cPsoY3qBqLyxcE/yPXjvZ5wtugE9xwV4uhMI7z6nFdok/IjUpzViMjdvI+tUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8544
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> Almost all of the code in __mon_event_count() is specific to the RDT_RESOURCE_L3
> resource.
> 
> Split it out into __l3_mon_event_count().

Missing a "why". We could perhaps write it similar to an earlier commit message:
	Carve out the L3 resource specific event reading code into a separate
	helper to support reading event data from a new monitoring resource.

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---


> @@ -529,6 +499,44 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	return ret;
>  }
>  
> +/*
> + * Called from preemptible context via a direct call of mon_event_count() for
> + * events that can be read on any CPU.
> + * Called from preemptible but non-migratable process context (mon_event_count()
> + * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
> + * smp_call_function_any()) for events that need to be read on a specific CPU.
> + */
> +static bool cpu_on_correct_domain(struct rmid_read *rr)
> +{
> +	int cpu;
> +
> +	/* Any CPU is OK for this event */
> +	if (rr->evt->any_cpu)
> +		return true;
> +
> +	cpu = smp_processor_id();
> +
> +	/* Single domain. Must be on a CPU in that domain. */
> +	if (rr->hdr)
> +		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	return cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map);
> +}
> +
> +static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> +{
> +	if (!cpu_on_correct_domain(rr))
> +		return -EINVAL;

It is a bit subtle how cpu_on_correct_domain() contains L3 specific code.
This may be ok if one rather thinks of it as a sanity check of struct rmid_read.

Reinette
