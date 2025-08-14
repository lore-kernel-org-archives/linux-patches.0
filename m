Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89D0273805
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208646; cv=fail; b=KXKpCSfDI0YX4EIggpJbbrEnLCMiWCqMOZOQc4oxmK/Y5a4u0/pVVGECd+AgrqEZRwuZaHdTqR7B1whjzpm7+mSkW7IJuWGW7vXcSKPJm4YunuFxV8WgeK/faySJnM/qnjH5pY52r8mZIZkgOojTbsj08sr1YEw+6vf4LRImf9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208646; c=relaxed/simple;
	bh=X7B+4S26dgcvpZClHq8NHkzrHOLY7mYlAo3IkKL0XRo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UhAx+Xot/Pyrsgea3BYvHBIBUyByLS//ynW4bs+3FKH7tnSVjswiUil7nUjbQTIm0YK/H8XjcvLWR8tA0YVcgO83L/y9UERLhwXGsfEVuEK/cNHlUewp3s+BgRorg8+T1GnxG01guGcQ9j19FyhJ8pddLItWRvZV3QHH4bJPhQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g1cFJq7/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g1cFJq7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208645; x=1786744645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X7B+4S26dgcvpZClHq8NHkzrHOLY7mYlAo3IkKL0XRo=;
  b=g1cFJq7/kmduKHOxlFEhHFQNbaCosJC1OQXDGLyb8NSHuLKwcKgH8DMD
   XrHrlJCbwlwAznDE2rjhI+RHFk2g0zcKGm+NxKctMgGr84iF+gZALHvoU
   B2ZVOsmnpGIhgTLM/X/C3Pp07Z8rl4jVkNzUGehhoN7rQzwrvBueO8ESd
   KkXqASbFXHTRkZkbPoGW7VgJHFMIcC1ckd+mxnlZhmyjmP2ppMOmHXCby
   9+2qU0AGVh7bUv0LK0texM/YljTZ4mDA722Uk8lVELYLFofE8rw/nJ7lg
   jvyL+QYxcv/ynPgG4Uruejxp58IYW8Zo9iC6Dsy3gLKn7kc7UwjkyisYM
   A==;
X-CSE-ConnectionGUID: f0AoH4ShSX+RQpPm2Dpg3w==
X-CSE-MsgGUID: EP3y5DRCSfGoUulrgpxXBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="74988914"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="74988914"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:57:25 -0700
X-CSE-ConnectionGUID: sJlTr9YgR3y0MMiDLMyKJw==
X-CSE-MsgGUID: 3Qw2Zn7LQ/O6obqhyrUtVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204052380"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:57:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:57:23 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:57:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.58)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pykYMuFDBAPHU7aFVosMADJQYBPHK+xx+mXuXRXGN90ZMXJEH84tL4itqeD88IJHS4iRCBThTApJ3CwhlRmz/0lYQIhe7KkwVc7mwOcmWkme9LcJTlDU751M2OAh1Nfm8EtKTUiaoOu+ZPoJFiojOhfDSC2tXvf9FTcazeOgvmQ2MuJPKcsZ1lJyNccAGgMtcE8R+bzwbXytkIQrbeT0jU7Elv74ADszlUcaiEfbn/NGG3z8zVUU/H/1l0kiL7ZhWYfTqB12+rTbIklI7WCF4docUtPDo/KSSVNI9d99SakJIYzDj+UB8aSHy+oGgVC7ERbtGAUX+yhOAXE8wfy17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwWsQOD80EOSCQZmopXn1hB44OwY82EOKDOEXvK414Y=;
 b=RARxJksQxgs5hEPGwg7OJJRl08CiiZKbXjhUer08shAHkLZfyTOeRUfK2xJDgDiz7+gux4RNF42vZK//KCbd0VxUF/SyegbFLDV1X/VIVByYwRuVukiyQYYxk4NjY61q/wLvmbetb4UTTyEpX4a5YqavLnPKUzv1/R/Xkb+b8L08fLh7C6JZHXzVfxUPZOZ9ApOEORmjKbT9aKl4x3NQ6Gry2h9fZnGcW4d6AGTugxxVwV81c1oxkdM+F1ulPG8VAhjZTUvaGNcuXZleF5Ob8bZdwmdicM6jXTpuDDW4T2dL9654Edcx597Qb64vdcRfMSphgpvOGQeHVbpjW6uvKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:57:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:57:22 +0000
Message-ID: <94295ce0-0ed7-482f-8475-5f3fcaf63772@intel.com>
Date: Thu, 14 Aug 2025 14:57:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/32] fs/resctrl: Provide interface to create
 architecture specific debugfs area
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-31-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-31-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:907:1::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e610ded-cad4-429d-9e41-08dddb7d8be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0hOeXZtVzhIZXBWVmMvTlhZM1RGek1yd0FNRXdkUCtnN21HOEE5YklLc3Q1?=
 =?utf-8?B?TTE1TjdzbXdHSitaVU5ialB4SlI3Z3JZMGltTmZxTU4xUGNiT0JpaVhYbU0r?=
 =?utf-8?B?cmpUV3BObG1GK09JZzRlcGFZV1A4YnBaQjY1elRNZ2EycWExWiszZ2UvcXgz?=
 =?utf-8?B?MlR3K0JEazZsVVpQTGkwaWYzZEVUVnBOSmFRdUtBMVNPKzZXVEs2MUJnRVNZ?=
 =?utf-8?B?QnhSVlVtOVJiTTNmTTB5SW9ZcU8xeUhvblQwMXg4Nm5UeGJYU242Qk9ndHI0?=
 =?utf-8?B?akFZaGhqcHZ5RXFyMnI4MDhQVEZ6L1h2UlorWkQ1a1pKeUFnelNiSG1qM1BB?=
 =?utf-8?B?MkNXMDZSYlpVS3VmeUFyNzVmOCtOMVhSdjd3UmQyQ3ZTK0J5OGtYR3VLQ0h0?=
 =?utf-8?B?QUJ6VnV6RW1qODVjdXg3ci9NWmxMWWEyYXVHL25jTnJMSGw5OStPb3Y3QURI?=
 =?utf-8?B?V2pkaVNnTHN6ZW9hcWoySURCNk5LSDVQTE5TYmlTNTdySXkycUhVN3RzbU11?=
 =?utf-8?B?dVJoTW5HVitjRi96bStvWDlxTGwycnNHaW94U1NNTTB0dWtWcUVSQWdQZ3Uv?=
 =?utf-8?B?Tk9ZYnU3QVpPWDkwQllZWU5haHVUeWIrRkw0TDlKNlBSN2NVMU4valVrdnBR?=
 =?utf-8?B?dWFOU3NmTnEvY0R5TkZLTE1DN1JweWFvb2d6dFNkc2JJUWNKYU95QTBzOVJy?=
 =?utf-8?B?MWF4aXNQckxTUU5tUUZEakxYUXRrd0FHdTJBU1lJczNjRC9IcU0wQnNIcFQx?=
 =?utf-8?B?WWhZSWpGRGxGVVlxRUduUWNEUWE3aGtwYnJaOXQ2ZkJSM2pST0ZHSHA3c3VF?=
 =?utf-8?B?cDdOWkZqb09PZmJoMzJzK3RqWk1ubkhwNWtYUEc5T3ZQeFNlaEQvOEphd0Ft?=
 =?utf-8?B?U3czK0V1MmgrS0RVbSs4eS84cUpvRitMTTZJamJSbFlBMndtMjZYZEhtQTN1?=
 =?utf-8?B?emJNRHFuTVFqT0o1M04rYWtIZ2EvUVl4RWVRSXVwQ3B2Qzd6M242YURLNkNZ?=
 =?utf-8?B?N3dPQ2wydXBpZ29jcDZEbFVBQjExbHpHUmM3aVdlSlhJNXJteVErb0pvVUxl?=
 =?utf-8?B?YnhQaCtPU0JVTGY0clhWMnRiMU56WktodWROM0Q1eGhFNU1vMTFGeTFUS3F2?=
 =?utf-8?B?SzJvVVVzOHNQdUNvbXVZZlQ0QUxYNTdmcGJUM3IzOWgxc3poVTNGampPOUE1?=
 =?utf-8?B?a2o3N2crMzIxcDcvVEpaajZtZmhJL1pWMFB2aWJMM2Y5ZDBtR2d0K0laQ1ox?=
 =?utf-8?B?MU4xbXk3aU5oenhVSU9CaWFHL0NLNFZYVWtDSDBvMFhzL200QVlFUFo5bDU0?=
 =?utf-8?B?SDlKOE81cEp0ckZQMzJtOVM4Y0VxZm5DUWVVY3p5QW85LzVibDlrYkxlMXN2?=
 =?utf-8?B?WDZmemE3QUZCdWVrbXVNYU5iU29aRHNrNGM2aGk3cENScE0xbjU2eVFuT0hr?=
 =?utf-8?B?U2V6VFpBSmNWMTFQa2RaV1IzRU5FOUI0QWRSMUdiRTFKNCtzVjlnR2E0aklX?=
 =?utf-8?B?bzJuUVhNSVd0anpLV0E5L09JNDhBdnl0VVpoZVZpOGdWN2pxb1FpVWNkcEpy?=
 =?utf-8?B?OHpRSmZiOWJpUmlETWp2cWlnZ2NLMDJ3Mk9hVkQzdzZuYi9ibS84R05jSlIv?=
 =?utf-8?B?Ty9mZ1BGcG1zME9veFNUb0gwSXF3VmxFWE9XLzFzckQ3M1E0bzkvdXFaZjdH?=
 =?utf-8?B?MytsNkw3N0FoWm00K2pHck9nZGNtOEpiZWRDdktwdDZoYm1hMXdtV0NsaWpy?=
 =?utf-8?B?UDFXUlpiZDRwRDFWREQxdGxZbGJnR2c5SnBvdFl0TWtWYy9QVGFwNlRma2R4?=
 =?utf-8?B?c2pFcEFNQU5HbCtpQ2xPZFhyWHJTYU53VHJBaE1wSWV0REVpcFlBZEI4c0wv?=
 =?utf-8?B?QW55TTdZL0JRaEFuY3hjZGF2NmlmS1hrTEVMcHQzTERHYnRiTFZ2VDM5WXpF?=
 =?utf-8?Q?b/a8G97qhWc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJnY0hZeTBKNHZBbTk0SW1LVkJmQW9qREdTMjgzK1pGMnlOOFBBVlhOQXBE?=
 =?utf-8?B?S3lRV1dxVGM2Ymc2a3NGN053M3NhaXEwTTBkQkdlQ0tVYjdWN3ZCeUlNZlpB?=
 =?utf-8?B?R1BLUHVWYldETzFmbUFmclB5WUxKQi9SSDlaV2ZYdlBrak1Tb0dybENYR2Vr?=
 =?utf-8?B?ZHZPb1VvdDNVNjJUYnJpNytiZHBlSVE2eWFjSEdEVnoyL3M0aTE5TUlrU2NC?=
 =?utf-8?B?YURWMExtVXNQeVlCRVpxbmhyUUNhUVRPUGVHbXJwM1JVNXdTamxNejJoNU1V?=
 =?utf-8?B?eXNTRG5hRGlPdGNQMlNEZ1kyYjl5aGIvMDYxWWYwSUlQbmZsTDZlVWQ4d3Z2?=
 =?utf-8?B?MGt1L2l2TkJFZkdiNEp5dGZaZTJoSWw2TVdZR0daS2QxV2xpRkFxNFRBOHAz?=
 =?utf-8?B?T2dSZVpFSXk0ZVNGUFF1M2RNbzhzMFo1UVUxZGg3Y1ZWR0ExNllmNllNblo1?=
 =?utf-8?B?NkdVQ1NtVlI4bEpUNmZTMWxTb0EybEs5SE1KaEllUFl3aDhyN243MnR6ZTFO?=
 =?utf-8?B?WFNOOGQrSUVlWU41eXc4WmJaOC80U1dML0hFZmk5ZEpuUHJGMXVNZlBseTV0?=
 =?utf-8?B?U21HWENFWlNsTVZDYUt1TmcxbjRiR1ZIVThqdXNsQjJzQS9NdHR5dnovTkpN?=
 =?utf-8?B?VkNHZXZEYVJQdStYRGRVNDVvS0VEUjVpZTdDYmpZM1VBam4rekIxVnV1Z2pW?=
 =?utf-8?B?d1p3UytwSi9PeVZqNmpSL0ZPZ09ZOWJLcjZGK2tRU1RRSEFzNXdIV3RmbE9a?=
 =?utf-8?B?TjN6dXgvNkhmbjJpT3VWVVdDQUJ5cDF3UkIyZTlHWFQ3K1hWYlg4QlFqTk56?=
 =?utf-8?B?bDZYcSs3cUxBQkpBSWxIdzJhZENRVzZrb1hQNG1iaUF1d0t1eHZWb0o4S3NX?=
 =?utf-8?B?dmE4d2hxUHN1RGI4ZENaNUdTZFMxMng5Njk5SFJQT2hFMzBHdTcrUTB6MHAx?=
 =?utf-8?B?amFTZzJvc0FGcEF6Z2kwWWQzdXdPMHluNkFXZFV6VFN1WDlpeUwwemhhTTZZ?=
 =?utf-8?B?NklHWVBkaVFHT25RQldPZUprSXBrSHYzeWtsY1A0cldCNU42R2N5MFB0TTdF?=
 =?utf-8?B?N3QxZkYzOTUzdEM5WnNLRWVDcThSNUlnbE9qVG4zdEI5MjVNNDV2OEJBUEUx?=
 =?utf-8?B?cnFDU0E5Zkp1RTA1VnQ4Q1FUM2hPOHZLSFVId0xpcFR2dU11MHdGNFd0U0Zw?=
 =?utf-8?B?c1lrWUpSUHlwdkZFUFpLL0pKZ21jL2Y4bzBlNEc1Sk1YWVljZWZnSEpoUVMy?=
 =?utf-8?B?N2xUMHZsMk82SjdjWlNpa2RCMnlPUDZLN1F2U1djT3dYL1RLNkowbXpxK3Av?=
 =?utf-8?B?SUtWMGJTSmZ1WGo4cmZWUkpnVlR1UkptSVBrY003THZVTyt5M3NudEw5TENi?=
 =?utf-8?B?cFdjbWFpR2pReWcvdzcyMTFrWlhpOXBvYlZGcWpTaDdQTENnUjRSZTl0TGRJ?=
 =?utf-8?B?QUUza1J1czgxUEZsbWd2QW9QdHhFTmZrc1N5S2lTWndhOXE4QklxZGxSZy9V?=
 =?utf-8?B?VmFOTDBWV2QzQU5yZ2drM3c1RjQ1aUp5QkxaaE5kL3FXbllYQXJFSXowNndC?=
 =?utf-8?B?b1NNdjUrQlQyMW4wRVdlYmhvbjIrVTRES1QrbjlUTjVhWFMvT095SEpBYnda?=
 =?utf-8?B?b1BHWndJdEpYNkVIZGFkTWZYdFJhNWEwb0Nyc3p5RlVqQnlhUEJFeWh3TDdV?=
 =?utf-8?B?U015ZW41Z0tJRTc4REY4aU5tVmRZbmlIWlUwaTFZekE2VFZMczhZR2Z1Lysx?=
 =?utf-8?B?VXU4ZEtUdHpTZlJ5d0dLQWhYeGRMZzlway9IYnJ6dzA2WkFDVHRJRnZjUTJx?=
 =?utf-8?B?dXVFWnNHK1VEVnB5d29MVEFNOHROcy9LUncxSkdUT21LMUFIRWhzR3ZpRXBj?=
 =?utf-8?B?TmNPUExDbUhGQzNFREJNeXk1bkw2aHZVTmhvQ1hYZWh5c2tWVnVoRW5SVnBm?=
 =?utf-8?B?OGRjRCtkdkpjZU9SNUN4NWpMQjh4RGF3SmNNd2krVERLbjVxd3VGdjVORUNn?=
 =?utf-8?B?clZvbGR0WW5aMWJaMWozMUY1ckphaVg0R1lhdUJXWms3cVJ0cG02dWNNVnkw?=
 =?utf-8?B?VDRXZXp2WEVlVmZTcXlYWGk0WGphakI5V042ZVh2QkFSQnlSK0pOSUNEVXNX?=
 =?utf-8?B?VldQVCtqeU1iVENXS0hCSGhrMEtEcGVydzF5NnFndXAwcUpHU051QnVnRjFk?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e610ded-cad4-429d-9e41-08dddb7d8be9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:57:22.2184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWes/1aNcQCcNS7Dv2ANU4NOQeiIB/UlMj8sDI8yy3XFkcjXmM9HJzQpUGBoCKdVpxgbGOUXCKGU6D/ljOeQrPkz2NsEujRXA2ED20UeAK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> All files below /sys/fs/resctrl are considered user ABI.
> 
> This leaves no place for architectures to provide additional
> interfaces.
> 
> Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in the
> debugfs file system for a resource. Naming follows the layout of the

"a resource" -> "a monitoring resource"

> main resctrl hierarchy:
> 
> 	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}
> 
> The {arch} last level directory name matches the output of
> the user level "uname -m" command.
> 
> Architecture code may use this directory for debug information,
> or for minor tuning of features. It must not be used for basic
> feature enabling as debugfs may not be configured/mounted on
> production systems.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reinette

