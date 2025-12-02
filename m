Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7465D279903
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691921; cv=fail; b=KHVFVY20syxHVoEp0PodH9duc+8/5UYQT9SFMCcP3VYh+ycU26KJ7ldtcIbJIJiOXJDbOKZOsFs5fgkIaFohCYWv+YYPVgROLh9G5CC6m7at3gcquNclozC+nSl2lswT+s6Ho+3/uVkR/Q14QGT5WYJOaFBJX0Bfhs/vOInsahU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691921; c=relaxed/simple;
	bh=vZOfNbhfXlIk2ZenDJt/E0qcTUtJra8CSt0cvq9GIzA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nAPFzlwrUz6JjUzXAdk3XukqgbcYL/vOKZaR6r8R3nns56an5V4XrvPKyjfSSYM5x4quevoXYrSePQtL7SNIAeGj061x/hTc+Ferjh/WAW3OG/RMyyuiO8YzHbxA/B+qHbtuZRK1SaGyqkwilIC5nN6t5jIn8VcfOGt4UtZCiio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHBsqNPe; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHBsqNPe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691921; x=1796227921;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vZOfNbhfXlIk2ZenDJt/E0qcTUtJra8CSt0cvq9GIzA=;
  b=SHBsqNPewrVguIPzkn1f6cOkWXSBc87hKG8vR2mmYFyn3LZ7v3lhOrVf
   aAKIuGePqgyFF+YHyZfjxveyaiNDSQzEE41uhkEjTFsqGKmU4nmGR+Vj0
   LFHFVzlxgXi+UUtB+lDWaKgFADISr+Y8Lh08PRFDebEcgiRLyNuAeKhdc
   743TNgkNKyyXUco8lyByYMSyLrm45MiF8ZF8hDaKc2oZUomWIBWPlThRj
   B0fm4zB0DN6uIZ9bzZyhyYxb3BkPO6szgdutk0zFvUP1zHCY1JZSC259F
   GGQFwD2UXfKlhv2YMvrWQJAY2deJtxHIdfanEzso9aRK6++GnIasKqCzP
   w==;
X-CSE-ConnectionGUID: HmFMHW8oSnKKL3Vmq6iRZQ==
X-CSE-MsgGUID: nC1oonHqTV2lEv+pmDexGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="78131183"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="78131183"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:12:00 -0800
X-CSE-ConnectionGUID: DnJ3iXLKT0uez9XWT0y+/g==
X-CSE-MsgGUID: pcUFkuPhT66np4RQLByGFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="198882255"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:11:59 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:11:59 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:11:59 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.33) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:11:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUuQUPk5SQx06/ju4JBrsvTSwGQtSKZe/AngAMDixOHINhQhrGhke9x11zydb1MHH0vnGA87ooK5eGX88huvv/hqXZVbq10zlriSrOibRPuqYiMXaEGP922Hquznd3B9mS4NW8twlvs1ZE6tX8q7dEH7xjIU9wiR15JU6cb339KBcKU4+8U8/hNq4achL+50ognLUAD0mwDqx0YVaKqETlfmg0+jxgiCv9wl3DW0PwuJ6IPZ/rcrN72lJErRvCZZzTUkKXTuxfnF6S0xBpvlE+kFFx6M/Eve8IhZbgRCEd/PDljTWtvXNrToscvH34NJCrsLwVDqeaql8YGO1W/vZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZOfNbhfXlIk2ZenDJt/E0qcTUtJra8CSt0cvq9GIzA=;
 b=fcwFbanvSVlNsyUc6ip8UkTt/9+y59GlJ6Afb1cnPivjSebCPcnGxMDAq4F5MSDPrhB0tk9ksrMhK50m10hZPg/UjcnhmDxPqeWlwOa+S+jwoESuelSCUSv33NhxjfvnssseFFLgSqoEOZbcCUkx6Ci5NEOPGZ1l7T9e0se3MvtWm0woFThQ/NHgrOirhYyCQrB+5L91hiyKDZCRKYuMmO8v+kfy706U9MyE4rbnK5uk3QhPYFhLmHCmJtoRNLie1ipsxy6sg+GP8l4PTy2F7sX/sOgu1qM0R7fIuqbFEZxpA+YNekoA7sFPjy6cM3dmD2HYIG/nFfNfxhT5SDcWSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:11:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:11:56 +0000
Message-ID: <c457782d-fbee-4937-958a-6a84787a048e@intel.com>
Date: Tue, 2 Dec 2025 08:11:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 14/32] x86,fs/resctrl: Add and initialize rdt_resource
 for package scope monitor
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0301.namprd03.prod.outlook.com
 (2603:10b6:303:dd::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7f5565-50ec-4f5e-0a72-08de31bd83af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0F6Ynp2MEZBN3BXSXJIdmx3T1ZvU0txNE9uQmhuWEVxT3duOUVUeGxkZUR6?=
 =?utf-8?B?ZlpjTHJZR1VScHBJcFpVdHRhQStiY3FPTS84UitUVXNERVI5ajZLZjJnUEhK?=
 =?utf-8?B?d3lyeFhNekVHRTJFc1paejFQWmgzVFpJdm5GOEUzVmlJTDhCbC9BWDkrYytZ?=
 =?utf-8?B?bTlIdEd6QXNna2hQUzdGVnMzUEo5NEVTSTlMODQzTUNKK2JkWURkbm02MFRq?=
 =?utf-8?B?QXFPWUFySHlXMUdOb0d0VTc3V2xoUytIQ2IxQmR2dVE1NWxoRkJEdEdTVjNC?=
 =?utf-8?B?Z0ZoQmhYU0ZOcmh3REZwTElDYWc4elZPOU5rT1Mzay9EYWM4QUl5WTVFREZv?=
 =?utf-8?B?cHlpeGl0Y0JzTWptdkMxR2xDRWNIWGZCQUNkTHFNOHJKSnB0dmRZUWdDQTlq?=
 =?utf-8?B?OXdOT080d0Q3KzRaQW5MQUI0THBzYXlrTzN1N1pyUUlGM2RZUEIxV1ZsN0tL?=
 =?utf-8?B?VlBJRVhwdWt1Z2M4QlU1V0Q1eHQ2VDNGbDl2TURPK2JTNldUc0Z0Zm9MRFpi?=
 =?utf-8?B?VnJVazAzdHJkYUJHWjJxbVpXbGFQbEphMkFVMWRFaWF5ZHV6L01WcmMxOGRI?=
 =?utf-8?B?dEQyUnFTSGh6bUVpaVNhUGg0b1ZFK1ptbFh3bFBjZmduVC90R2EvaU1KVEpt?=
 =?utf-8?B?VjVxMEVkMW1Ic1Y0cEJ2VFFRQjgzS3FxZzNRNTJ1OUpKbmZlTE1QWHQ4OStl?=
 =?utf-8?B?VEtsems5Tk10ajV3d21YR01Pb0FwZHIwYjBmY3RiQncydHBwMUxFN2tFaUJW?=
 =?utf-8?B?eXFDU3QyTklraWtvanE4WGIySlBMZmZyOGY0K0kyYUx1L2Y0eEVNbkovS1F0?=
 =?utf-8?B?WGhsbXg2MFBIRnhiVWZNeHJpVG1jS25TdnVxZEdiZ1AzK1dpMTFydWFrVTN6?=
 =?utf-8?B?SDcwY0R3Z1czSEM5SjdtQktqUWhpcVdzZEpzUDhHN21GdHFoS0pNV0xQMzVW?=
 =?utf-8?B?S0VXajloYVh5QUVsaHZwQVNkK0ZBOCtCc3BBL1VvZmMxMUtqNWhaYWQ2RXRj?=
 =?utf-8?B?VHZYZTRMRnZTdlFnWGNjMURBZDE1ZEs3cVpNaERFUHlWcDRHVmxCK1VjWFM1?=
 =?utf-8?B?VTR5aEZuRlNJN2lPNzJ3ZkJveElQczFXM01WVVBCTERKTFFvcmRpelYxRnM2?=
 =?utf-8?B?ZmxZTGNhdmZxdFMyNE9nQzBTUWl2VnBUbWJQa05oY0dRQVkvZnZqY3FBR0ds?=
 =?utf-8?B?bEE4TGgyUjFmRDduVFVzRUVrRHhNdFpHSUtWVmNkVVU1aHVjQTdaY0VzWk95?=
 =?utf-8?B?K1JiOCsrSGpJOVgvSG10enBRNyt0UC9PREhmVmV2ZklLbml5V3JHQnBCNmJW?=
 =?utf-8?B?akF3UVhLSjVqTkZ4b29Md00vUWRINjI4emozZlZoQjQwWUp2YXplMGhvcXlB?=
 =?utf-8?B?R2lrL25VM0NiTXlOMVhQWTBDRXhRNUgwV1ZBckVyY2huemgxSnhBZkh3bXRz?=
 =?utf-8?B?b3lmVEJtUkhOUzN2YjJqdHMzTGRjRWR6Tjg2bDMyaHB1WG5PQTVhMzA4blBC?=
 =?utf-8?B?QTdQNmdzNHpDRGowZkNmRXdPYWtpaXJ3ZlB3T1ZxQ0FyMWtkekk2YkRwSFkv?=
 =?utf-8?B?cXFUQUEvOUZHZDArZm0yWWRQOFpoeTN4b0lmNzAyMnJEMVF5b3g5SVhPQW80?=
 =?utf-8?B?dExFb21EWkkwMStERExHU0h3UlFTamo0K3c0S3BkTXhFUkNhWmMvL0RYMHJ6?=
 =?utf-8?B?R2xtNitvWndaOG1FMVdxbTZycnl3NHlJcW5lVkVFTFMzVW5XQVRCZUg2Nyt3?=
 =?utf-8?B?bUNNeHFPMzdDYXpGS2piWTlYWTBrLzI2Z3pjclNENk9DVXpHODhmbzVoT0c1?=
 =?utf-8?B?V043bDFPV0JpeFczODk1UHJiNWQ4VjVobVJWVUMybnVSdTFqTlBlZldmaHFt?=
 =?utf-8?B?RlZGbDI3MDdtcFVUcGRkZUtQNTFuUDRKQXYyVy9GR0l0MUd2K2ZUZjJxN0Vr?=
 =?utf-8?Q?pqKF40xKDGr1dUsXLH9Llx2Y/JgMZGRU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUNjakI4TC91ZmJvaG9QbUdWcFZHYkRDeStDS2U4Y1NoNGwxa0J3T1VTRUlk?=
 =?utf-8?B?bSswYm03SXo4RlZIVVE5bzFwaFpSKzA4aEVWTWlxYjlmdHNaRHdXS0o2NlFW?=
 =?utf-8?B?VytMMjRqcVNMVzVQOVFYR3V1bld0QkxaQ3hUUVpLaFNDcUFERytYb3hMQXRR?=
 =?utf-8?B?b3BRL3VFY3NCS0ZUNDR3S0FzZU40ZzZXMWxPYkhCcDdEbGp1MzZ2UjZDK2Fr?=
 =?utf-8?B?WENOUS8zcXFGQytvOXNUOEJHTENUbnFsTDJNVzlodTRWUjZDZHg1alh0NHN4?=
 =?utf-8?B?R1pJUzVVSm9qMEI1ZnJRTFFyVkl4YVRGY1Z6QXJxc0NXTDNvcVlJQWJpSnZM?=
 =?utf-8?B?T3J6eWdPa2d6NnVnSk5tYjNFR0lpYnozVjlOc2hqbkI1cVoveWZqWXRVWkVZ?=
 =?utf-8?B?UzRpamNMMFlWc3dWSDFtQnIrK3F5R1hsaGRlRVBKaDhDVkdsbVA2SmV6aGdX?=
 =?utf-8?B?cEQ3dUhteWRCWmNueGNOaG1Lc3hxbjI2TkZYODVJbWNsYit5TXhQNlloZnVZ?=
 =?utf-8?B?cDlnL0NSMEpMUVVqd2hRWGpqYk9XZ3JDK0Rua2p6a2pJTzlNZXFIN2VQU0tG?=
 =?utf-8?B?Uk8wTG56elRUVVNnbFgrWGZrTUNnM3RiVjMyM1RBNm1VaVgySEE1anBNMEVC?=
 =?utf-8?B?ZjluL2FkWXNydmtWUFVCVWV0RVVXTnJvWk9NS1hNa1NkbVdrbEM3Q0JLQTVS?=
 =?utf-8?B?aENmeEoxT09BVWF1dUQ3ZzdHb1c3K3dUTGNzRmFBajc5c2RiY0dod0N3a3lH?=
 =?utf-8?B?dk8xdnFvbWNNRGtubVU1b0g1MlArRzF4QVZtWlhsa3lFeXhoRk9WUlREVlA0?=
 =?utf-8?B?R0IrRE5vOVFWeUJVMVMweEluNndCZlhVM0twdkZsWEYxZHI2dFVlL1k5Znpm?=
 =?utf-8?B?amN1eU85NHdIQ253bzRNR254MTNmT0prMEVJdHZ2d1RTaVFyVnVkR2hHUlB6?=
 =?utf-8?B?OWZlMHRUV09XZkFBN05XZGJHYlB1OS9XK0RWcTFjTlJsK1hISGU4d0FuMUh2?=
 =?utf-8?B?MzhLR0RYL3JFbjFoN0taSHlMMVNsTnM3NHRKdHFhOEZHZlJzNWNEclFaWmNx?=
 =?utf-8?B?T3pQYjdvWWFueG5EWlRVTVcwVG15eENmVnZYZWhRS29jaFBWaklhZ1RmL2w5?=
 =?utf-8?B?cGtlcitYOFpKYXg3RGFqMlRrWVByNXA3MGF6L0RhcVl2WG82WGZZc2NmR3Rz?=
 =?utf-8?B?d2NBWUt2U1YwSnhkVmk3cnQvUzN6RVRQVWxvVjFqamV2YkVTTXk4aFBUTTFQ?=
 =?utf-8?B?cHZMSnFFbHN3WE80cGp2KzZZTVFlL3lYOVpkM3RaN09tVFlkdStWb292VmNZ?=
 =?utf-8?B?NkR4MkFFd2dWclpzaW5GTC9Eck96TXVhVGszeVpvNGhabWprL2hKWmExL2JK?=
 =?utf-8?B?ZEh6QSthYjJhN0lGbmFteldkOEhyN3A1dmJ5c0pCRWhpd1F6UlI0UFhXT21S?=
 =?utf-8?B?UmVid1VlMkF5UDcyU3BzajB1RFFqZGF4b1lrWndaZTQ1aVkwODduTitXSXFT?=
 =?utf-8?B?VWcvY09zNEs3K1crWmt4V1dvaG1ZRTM2QmdjSWZzTkgwS1FxUWI3WWxuNFBI?=
 =?utf-8?B?ZTRwcE1WZVhkVGJrQ3BxVm9pakFpaVpvNDFVTzAyRHovOFlid29xV1FpRUph?=
 =?utf-8?B?bGZQazk3eVpSQ29HMTVhZ3QwOWdsdDVTNDZaK2ptVDZVS0hkVzBucmF2OXVL?=
 =?utf-8?B?VThKME9jbkRSb2lwSlh1SzloM2VSdEJDYm5oM0xNcmt1Ylp3VHgrN29BNmIx?=
 =?utf-8?B?cUlIYUNyS1JBNW5jYUNobHVXbUl5SWU1alpTNnpFdzhBLzBUQU1Dakt5Z0VW?=
 =?utf-8?B?VXJXaFM5SEtIZHNLTmwyakZnMnBJaHlnNFUxdU1McE8zZUVaTGpIdGJKenE5?=
 =?utf-8?B?a1RxYjMvQVV3K3pRYjRhNTE0WjdqVTI5alFESHhjUmZ2UHNOc1ZIdEtlYk9Q?=
 =?utf-8?B?VzBQQXlGN1JWbmRsVzNsY21UTEJnMmNPNmpPcGM2aEZYNjJqbElKbzVEU1Fi?=
 =?utf-8?B?aThvak9kUjQxSnMxWnNEZmx2VWJsUndrcVFHQjhJbWI3WWk2cDhNWmNucFl3?=
 =?utf-8?B?OGlFSTRFRm5BOG04clhSbVhGelhrWnZOZHN3ckhvajNCd254VzFmZGFZSG1x?=
 =?utf-8?B?NjJYaTRLSS8zYkNsSXd5SkVnYWJ1VVpJcXhHbEh1N2dvTU5sS2ZxTVpwdWlF?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7f5565-50ec-4f5e-0a72-08de31bd83af
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:11:56.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HTd0kcElSKEfkW2RURl97pcWtlMDjzDMaMYb2TcIZq4R/wiiz+7aF6+MqYj6bqpzE5cDjT7/qgTCIMLVsCt6NBAyMy1Q4uCtgFBhvHCDZ90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com

Hi Tony,

Same comment as v13 regarding the subject. Unless you did not actually mean
struct rdt_resource but perhaps struct rdt_hw_resource or perhaps just "a
resource for package scope monitoring"?

Reinette

