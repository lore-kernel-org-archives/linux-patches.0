Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AE927935C
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719797; cv=fail; b=F1oQlYsibem61k/DyVvMG11yJZF7AhwUdI8j+1tTH0Uq3jSsTIiZNCWybMHzesTvblplAyy0FMX5Oxyaed6V/Hr6Dlr+xc17no1li66QW0SNdvvZEP18lLNgZ1SwRqbubos2PIpJYgmAFhCS5rZPlfRtxxtOTudsbf+AhS0gSes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719797; c=relaxed/simple;
	bh=/6+Wz30ewTtP3PRbdNd45DRKD2unMzykTfBMr2NhDL8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GVDgPqDrgqksT+mgy92erwSEOoNefk0axo62ddZ7J5H20GdoNwyHp0rvMXdhQT0jL7bBDFefO8wtTH/iU3qAGLEWxTuPChcHriADhaG5k3N/X1e6aRDr42v35rwISxhrrx+/3ghX4tWV96+N+DBfJPlymuVNqF+D6wgoSKzopMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5uYS0Nh; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5uYS0Nh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719796; x=1778255796;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/6+Wz30ewTtP3PRbdNd45DRKD2unMzykTfBMr2NhDL8=;
  b=E5uYS0NhXeNVQpFJDAE4Wnas5L1ScYbpCq+Ffes65m597e4WrFOWRt+m
   OtpyNYb253NS9KC5Z3GtXUPUkcvMS9EYpQCLEB7SYOPQT49871k6hoc3e
   ilS+8ClLySIL3Ix4agKA0cPHzQUGCeiUbhG70KaWdLyH20VXvbtIX0oEW
   4Ih/a9UcRVY8xiMr8qjax+p+KyxER/y++AWdDQko2x2bSMFrGXyPKFIhY
   CjZpkMs4+W9LbUiFt3g7amS07+TC7qRR8JIe7sJjKY9YkX2Nyo+2yHI7z
   bDzbydKT+Gnld8/auBXkChNSEsw20eKLZGwnFOXIS30lP2UVGXeB0eWwo
   A==;
X-CSE-ConnectionGUID: Hg3ChetnT7ey0YquK5GudA==
X-CSE-MsgGUID: MJQ/Pi5uTCOJC8+7rgqbEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48423497"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48423497"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:56:35 -0700
X-CSE-ConnectionGUID: LnFpTh2tRpWZB++TjAGEqw==
X-CSE-MsgGUID: 1pyQl+okQNu8vlIU45np2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137270320"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:56:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:56:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:56:24 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:56:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBkkAm5qLEhy/HE1+ZTNrh5kySf4tD2gBTiGS6RLNBJ4zJO9WajJ57cabaiPr0Hlo9qdBAuISiDkiEyzV73vqcdro79KBE+kbpLnnU4xZfV/QqbZ5/O2R8ZjEbU3elYdF5kCIHqw0INAJiOmPqQDE6A8zaN0OmDd+U3Kz4I3kusdwc69n8jGF6A3UQLH31mCouhD99/3ZwZwGFiZFZ6i8QNp2+8b3yN0tOKIYKN+XghdgBKjl7Cdxs0r4qzdictBVtseQJ/f2Ol4LSCyRRGTVO0Fb5BHxY1RVZZoBHJpKwBViOUgCRjcJi5TWwEE3E1qCfl6mi+mqyvrhrgfa4xvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Hi98X2UeeOVOpIzjTw3PaLtZwbcLgYIL/Flgh4YWS0=;
 b=HxKf5iotocctpTLujU7EIY6wEBc0VCobBtuXhH8p/sDrpZ9ZKXN4jRAOipxdcJv+NRpwXzgQQT4x0a3MSTRWs9Fyfq3+T//t1dacIJnTWA7cs4xnHTGK/SRU/Z/XH3nY1q0t39fawCaJLT+AThh+n0bAp4NBUnDwdC25oVqrbvtHtLHhMX3VY1HpgO6xuGhYsSxRLujMsVBw0qV1eoHKt5ttgyOAHFYGsjDn2HtAcsxAMiZDG7QPAepedwPXXioKYBvRQ7LM7VAcAJbinzRqAjCygu0nR4UcRri3yMfBzBuf2nt4dxQWpPMdM59j3pNkac01hewYDdB2Hun5t73ijw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB8158.namprd11.prod.outlook.com (2603:10b6:8:18b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 15:56:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:56:16 +0000
Message-ID: <1d54ec15-8c07-4d6a-ad8b-72c376389b48@intel.com>
Date: Thu, 8 May 2025 08:56:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/31] x86/resctrl: Add third part of telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: bd100583-47bf-4070-d2c0-08dd8e48ddd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V0hxWFU1aU5hZWpidEJqS1dTMGhXNXRPWGR2MTdBMk05a1BoZGZMZ0Z0ZjBF?=
 =?utf-8?B?L1RJcmF2NkJheVNwTzNVRGZ4R1BKVFlFUUZZWmNEbmwrSmFhOFpXbUJlN2xP?=
 =?utf-8?B?NHp4QWppS0s0K0ZDL1ZwRFltTFNJZlI4RDVqVTZMRDdKdmZrMSs1Y1FZRVZp?=
 =?utf-8?B?TkxGMHFsdW5Cc0Q5V3J0dUdMTWhSSVlQSkRlelJDM0s2YlRUQU1teW9Nc210?=
 =?utf-8?B?cEtJc2hmYm9Jd2FwUWZGOVVoa2dmZUU0Rzc1bU84bGRpRVR0RkhUMzdWOThi?=
 =?utf-8?B?UTBMcEVBZGlZRW1iS1B2UjQ3NDByb3d3U1pTVVJiQ1JkYWtEc0JXWUVjcDUy?=
 =?utf-8?B?YjROeXQyckkrRURnL2ZLWTFwWTNlWmRhZ3JjV0lSZTBReXVhcmp0VFY3Zmt1?=
 =?utf-8?B?YnFGOXk0Ukl4NmhlRTB4R0l2YWJKL1orL3U4VGhJVXpnY1dmWVhBUEVZdVVJ?=
 =?utf-8?B?QmNDUGUrQ2hTQ2kzTmJhdGlNbjVGcmFpQUJGSVg5TWx4MEJkSWtNcEhRa2hp?=
 =?utf-8?B?SWlyVWlONzI1Z1R0RU05Wm9GVEZ4Sy90eFBYcllsTlZLSG9PZDdwUDFKR3JO?=
 =?utf-8?B?dzJVU1p0K2Y0M0xVZGE3RWJNSU1tdHVMU1hGYnZWb1l4b2RWdk9yWE1iZHN3?=
 =?utf-8?B?UndvWURGQTBxemU0WXpwTXFiTlNmd0pvT0wzN2YwZWV4MjhOOVlEODZqdEpZ?=
 =?utf-8?B?VFc5OE01ODloWmtrZUNMb2EzaEZYQnJVcVVGVmw4aUNDQ0h5WFdtSllERjZk?=
 =?utf-8?B?MUxBZlQ0dmxPRFl2aHltbkJyWXltb0hBVGwxRC83NGZVT3ZkSTBHVXVSWWRS?=
 =?utf-8?B?NTRKeEF2dXN5VThiS2ZKNzFsbkw4WUtySVlqZzlncVlKMkhJZTRiSStDa1hF?=
 =?utf-8?B?K0ZXWmp3SlZUUXBUazBWQy9jMC9MVTlaQ0xwS1FXTzZFbmU3TkdEWFowcE91?=
 =?utf-8?B?THZGQ1dvcHFJWWFjVVZoQmZwaUhqY3hZL2NGQjVXVlJxZ0JTWjF2UnBFRnha?=
 =?utf-8?B?QjJlU2FBeDJEa01FMTYvNUJCZDRuVW43Wmh2bm1OTkt4djRMZk5YTmxGMnJD?=
 =?utf-8?B?SnAvaDNBdmhNeGRGT3pDdkpLMXhhMU93ZnhXUlowcHZhT0tnZmhNK1JYT0xS?=
 =?utf-8?B?QXlsTklobllPcEhJQ3ZIcUw4WXE0cGJmQUtnYlVBd1owbjlXV0FsejNicHFG?=
 =?utf-8?B?bHpVaVZVaEVGOUVXb3hyZnVvNE9aWjV4YzBwMkNUb0tXbmN0YnpZc0IrK3ZK?=
 =?utf-8?B?dGVhWUpUcVlIY3hpNWZYbmpUYWoxaDVZQzFtcFRRNEpDNGxHRXVnY3JaS08z?=
 =?utf-8?B?SlpwOS96Z0xST2tzQXd0TldtaEFBdVp0SFdtL3NtTWFJYXJwNUVzamZqakti?=
 =?utf-8?B?K0JxNUl2M21lTlA4WkxDU2pkZ1FEaDEwQUQ2Zk5yY3V3a3J3bVg3Vmk0UHVY?=
 =?utf-8?B?ZEFyRGJVN3RpZGJjRU1MbWxidzg4YUZ0T0ZEblJZN29tRlB1dWVpODNaeXE4?=
 =?utf-8?B?Smx0c2taMWIwSUlUWm1TVnpCZUJuelVKOVJDMGZORDdKUVBaa01TZ0VKVXdY?=
 =?utf-8?B?c3dJdGxBTTYrbkhDUnZrSWFEOFJHRndaMy9Nc1lHMzdIVUprbDUxdERpR3po?=
 =?utf-8?B?TkpKVGxZYVhZSGtvdmV6U09TMVc3azBLTFY3d2FFTUpFT3ZSSitvNXVEVGpo?=
 =?utf-8?B?NUNGSDZ1N2xSWDhJNnZReENwUDN1VmJrc1BEM256N2grTXdKdTBtOCt3Q1FH?=
 =?utf-8?B?bURqUW5tUFdoUUlZUnlWVWhIZzF1WWdRamF6RUdEVDJkWk40YjBXYWpyUzVz?=
 =?utf-8?B?WGM4Skhnc2I2a29VdUZUeUY2UUtUQ282R2FvTDJOTmxrbXdaRWN6VkZpVkh6?=
 =?utf-8?B?YVNVZkZ5RG1uL3dTeldxc0loRlI4ZWlxQnNKOGFNRWc5cmMzM2dudk51dkZj?=
 =?utf-8?B?VnZtTUVTNEVuNmh5SG1wandpTFhOUjgrdEZwUkI3eTJTZnpudjVVWTRkMzlp?=
 =?utf-8?B?YVJSNGptKzJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1AxWGZQbVAreGl2RlJ4UjRhYzBENjFndXIybGVDdGJzVVU3bDloM2daQ0RM?=
 =?utf-8?B?bUwrQTVYejBPRDkySEhUcC94bFFrRE5JR01IMmt1S2lJS01NU25rcDV4V3hQ?=
 =?utf-8?B?bDJaWVFMci9idklUWXpubGErZWtuNk1VQXpIdzE1WGM3WHc0dktpZ1JFSGM4?=
 =?utf-8?B?VGdmQWtuQTVvM0ZITWdVRFUvMENGRy8rdENhanpKQ2JibE5IUFN5M1Q5V1Vw?=
 =?utf-8?B?bStJc0VydHlHd2dZeTJ3UzJFeVBmdFF2T3hWRGVwRnVLdWtZR1EvWStPTkVl?=
 =?utf-8?B?cml6Rkd0RDByekVyS3ZYRXJKc25hdHJDZ24xc1RBdXhBaDhNeHRwd3pTOXpR?=
 =?utf-8?B?ZCsyZEhlRDZsOEs1a0N2K3dscDdhVmhOQ09oS04zVWUxM1R5REg1TGlDOC9j?=
 =?utf-8?B?ekJEaFR4Tml2QVFiUEZiNGlDeis1dHBzSjY0c05WNjNRWE1oNlJyVUI1T2U1?=
 =?utf-8?B?bXA0ODRCRHUrNnRJUkc4Qyt1a3BxWUtpc0RpU3dXUWtMQVl1SUxIMElzeEQv?=
 =?utf-8?B?Z3FZa2hMZWJheUhoSm1QUEhMMElXMzFyWlVrTEdWUVdKVHpyUHhRSEd3YUIy?=
 =?utf-8?B?VEVpOVdWaGZmMHVxMHNudGdUdVNMUkljSWJUeXhMZGo4U0hzSEsvUmxGdTkr?=
 =?utf-8?B?MTgzU3hMMTJDM2lvZW82U1RvQzFjOVN4b09PZUpJRFBrb1BqcTFSVEVnWGlw?=
 =?utf-8?B?SVh3YnVRZWFWSTZMaDlia25lZ2g0RGd2emo1dWJyTCtmWExjSkJFNkhNT2Nn?=
 =?utf-8?B?VjM3N1JOMU5YY3dOMFZQR3NueVJXZGVQYzZFZDVEOHVHVDVJNHIrL1NaakJU?=
 =?utf-8?B?UDJwUWpnWUxkaVE5bENYMWZsbGpDdjBzckdnSGlWMG1KVC9QWHY1WkJzOGRJ?=
 =?utf-8?B?N3FTVmFGc0lTUC9rT2V5ejVpQTJURSttbFZXRC9Zb20zais1ajY1TW5URUNH?=
 =?utf-8?B?SDk4SHdBRkpSellaakpVdmZwT1IvSjZ2d0hTb0FtVE1SbHp1RmJTZ1ZqY0lJ?=
 =?utf-8?B?NzBCN3JjWDRCbGNKUzQzejhQc3gyM1pDUG9CU2xUQWtoVENDY3doaXM1c2RN?=
 =?utf-8?B?TUhwVmI1TllBK3ZvbmJBSEdhclpnWnAvSTNtOHRrdmtjS1dQMkl3VnVIb0tz?=
 =?utf-8?B?MkVvL1ZrT2h5RHR2T1FSNFBRQk5mc0ZDQzdzWmMvb0ZnR1pmMlIrR0Z0VXNn?=
 =?utf-8?B?c2k2QytidXFiWUswTEZ6UHpoaFE3Rjh4Z2c0WUE5Y0V6TFRaQXJEYUZRZjNz?=
 =?utf-8?B?bUYyM0dKRlJzNkVQNzBzNzBSdlNDd2pUMldwMkViZTNYVTA5S3VvQ3IzSFNr?=
 =?utf-8?B?czAwMkNreU00N0M2SVc0MC84ZUozeFR5Ylp3YkZ6MGQyMkZYaGtqYld2bkdw?=
 =?utf-8?B?SDRseWJMQ2RXMWltRWJSWXNvL0diVnJET0tCeitwT29Fa2hLUjNaTEpZUWtK?=
 =?utf-8?B?K25CQXQ4RHRvaDg5TTdWeDR2b2hpcHFaUzdVRDNXbEVVWU1tQ0oxbEEvbCtv?=
 =?utf-8?B?RkJJL0U4ZHQyWThKM004UzZQbU5jNlhXWUc5cDVody9jNHhoREJMQVkwcHBh?=
 =?utf-8?B?N2xPTldIM3RUSk9RS051b1V1OXl2YWdGOGE0UjRFZXVqd1FveHhpNTB3OFZM?=
 =?utf-8?B?Y2NoMlZiR3IrRHNlYS82TldreEJXaE5nUWlJQU9zYmtxdG5uZ0dkeEdrMFAr?=
 =?utf-8?B?RS9PRWRlY0JPRHJYZGh6b1Jha2cvOXZGZGVwNUVxeDRKajh2UzZHOHZFekhk?=
 =?utf-8?B?MUM2SmtTTU9raG1SeHdnZGx2RjducHU2ODlzcUQxbVlkVUFidDk2VjlMYTVX?=
 =?utf-8?B?QXQ1aHBRMSt1MmUzakI1MUJJNDE4aGFJczZOUGt1Rm8xZHhhV29td2Z4TlVD?=
 =?utf-8?B?MitzaFgraVlDRTkwY0VhWG04dloySUhaeXhuWk9QU1NNV21FNHA1aklvVnZK?=
 =?utf-8?B?aERvY04xOExOWEFIZGtzejFpLzJvZWVEK3BVdHNHWU96eXUza1FLcXlob0tj?=
 =?utf-8?B?UHlMYTNsWG9IOS9uSGtERVlHeFhwUHRGait6ODRWMHhNVXNyQU5IODZlVjVq?=
 =?utf-8?B?WTRPSEIwNy9QeUFjT0R0ZG1zS1RTSzF2VEdhUnpubjR2bXVXc3hYbEZQTzRN?=
 =?utf-8?B?YUpIdVpORXAzeHJQcWhkS2hKQ0tXZjUvUkdUaXp6OFVuREp2RzVmMXZXZFdY?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd100583-47bf-4070-d2c0-08dd8e48ddd1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:56:16.8367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bpw4JM0evuh7ECX6OnduA+Tbe9tVSsqMDxSa06x5z+zwWCMI1Tso9dXbDqNbJDM6HhruPUNto/UN1tFsp9+yCxSRlphe3/wtePLhSt1siO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8158
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Counters for telemetry events are in MMIO space. Each telemetry_region
> structure returned in the pmt_feature_group returned from OOBMSM
> contains the base MMIO address for the counters.
> 
> Scan all the telemetry_region structures again and gather these
> addresses into a more convenient structure with addresses for
> each aggregator indexed by package id. Note that there may be
> multiple aggregators per package.

Could this series please provide a clear definition for "telemetry
region" and "aggregator" and then use the terms consistently?
I find the comments to switch between the two causing confusion.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 55 +++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index a0365c3ce982..03839d5c369b 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -20,6 +20,16 @@
>  
>  #include "internal.h"
>  
> +/**
> + * struct mmio_info - Array of MMIO addresses for a package

Please add description on how this structure is used. Please use
these docs to help readers create a mental model of how these
data structures fit together. 

I am making an attempt at an example below but I am still trying to
understand how things fit together so would appreciate if you
write this instead. (Please consider this when viewing any of the
samples I provide.)

Example,
	Array of MMIO addresses of one event group for a package.

	Provides convenient access to all MMIO addresses of
	one event group for one package. Used when reading
	event data on a package. (needs improvement)

> + * @count:		Number of addresses on this package

Any information on what this number means? For example,
"Number of telemetry regions of a specific event group."

> + * @addrs:		The MMIO addresses

Can the layout of MMIO space be added to the comments? 

> + */
> +struct mmio_info {
> +	int		count;
> +	void __iomem	*addrs[] __counted_by(count);
> +};
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   *                      Some fields initialized with MMIO layout information
> @@ -27,10 +37,12 @@
>   *                      retrieved from intel_pmt_get_regions_by_feature().
>   * @pfg:		The pmt_feature_group for this event group
>   * @guid:		Unique number per XML description file
> + * @pkginfo:		Per-package MMIO addresses

"Per-package MMIO addresses of telemetry regions belonging to this group."?

>   */
>  struct event_group {
>  	struct pmt_feature_group	*pfg;
>  	int				guid;
> +	struct mmio_info		**pkginfo;
>  };
>  
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
> @@ -50,12 +62,33 @@ static struct event_group *known_event_groups[] = {
>  
>  #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
>  
> +static void free_mmio_info(struct mmio_info **mmi)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	if (!mmi)
> +		return;
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		kfree(mmi[i]);
> +	kfree(mmi);
> +}
> +
> +DEFINE_FREE(mmio_info, struct mmio_info **, free_mmio_info(_T))
> +
>  static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct mmio_info __free(mmio_info) **pkginfo = NULL;
>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
> +	struct mmio_info *mmi;
>  	int num_pkgs;
>  
> +	if (e->pkginfo) {
> +		pr_warn("Duplicate telemetry information for guid 0x%x\n", e->guid);
> +		return false;
> +	}
> +
>  	num_pkgs = topology_max_packages();
>  	pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  	if (!pkgcounts)
> @@ -73,6 +106,27 @@ static bool configure_events(struct event_group *e, struct pmt_feature_group *p)
>  		pkgcounts[tr->plat_info.package_id]++;
>  	}
>  
> +	/* Allocate per-package arrays and save MMIO addresses */

per-package arrays of what?

> +	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
> +	if (!pkginfo)
> +		return false;

-ENOMEM

> +	for (int i = 0; i < num_pkgs; i++) {
> +		pkginfo[i] = kmalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);

kzalloc()

> +		if (!pkginfo[i])
> +			return false;

-ENOMEM

> +		pkginfo[i]->count = pkgcounts[i];
> +	}
> +
> +	/* Save MMIO address(es) for each aggregator in per-package structures */

Should "aggregator" be "telemetry region"? It is becoming confusing what "aggregator"
vs "telemetry region" represents here.

> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (tr->guid != e->guid || tr->plat_info.package_id >= num_pkgs)
> +			continue;
> +		mmi = pkginfo[tr->plat_info.package_id];
> +		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;

For this code to be safe the "if()" checks that precede it must match *exactly*
with the checks used to initialize the pkgcounts array. To ensure this remains the
case I think those checks need to be placed in a function to be called in both
places.

> +	}
> +	e->pkginfo = no_free_ptr(pkginfo);
> +
>  	return false;
>  }
>  
> @@ -130,5 +184,6 @@ void __exit intel_aet_exit(void)
>  			intel_pmt_put_feature_group((*peg)->pfg);
>  			(*peg)->pfg = NULL;
>  		}
> +		free_mmio_info((*peg)->pkginfo);
>  	}
>  }

Reinette
