Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D324118130F
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100535; cv=fail; b=gOc4X3JGAkV7FL6i5SldceJu9rz4pbbPCItWcpFsEVVEjnTHQbNlA9KuyHrvsQYFnIoxNSM/v/Pbk8RJs73/+YIFa21SI+24CEHX+uoPhp9wXy36LBAiyPTJEHjJU8VG06yw2xPRhZECwPPweTw0JxbFvUkA21PtGx2KX0aG7iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100535; c=relaxed/simple;
	bh=o4gLnIGWwPBpx6rieMb6V7Gfwg+1O4GTK5TUdMk5hpA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YAoieEqEsHKtJrSfT0g6ANEXIQtg7BmZbpcATiUPDZKbJHHivFJu9Y6PzlkDAvyDUtFHbssTag/gPpux+Oag4bXEWc6TVofuQwOHSWGBpDqD9urBODEVChGXakgsO6+Ry6+ptKA7et2yDyEkepKfhnIKlDq4AwN4VWxVbezrBAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/pzNR4s; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/pzNR4s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100533; x=1748636533;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o4gLnIGWwPBpx6rieMb6V7Gfwg+1O4GTK5TUdMk5hpA=;
  b=l/pzNR4sJqPznaaFFFzLsKL7XPQbtXMR+Lm/jT4By/b3Qj8IyO3lpxfC
   oLR0wJqyXSv6wNMSmIQn2hKWjpDywuQkBLUVCIIES99PWeS0OtH4546Tv
   NwmisskI2woceRAvLhZ3tbivQzU19Lyx91uMeRxhJX+9aim6P5BBRuCPF
   F2ZZQMYnoP5TO4G0/pxU9pY0mlqbIUDsocMlAYQ67gy5cHbeGDnKysVxL
   U2n4Y7VTcNXE+DUpRMgCsvy/LGmurr9fLCcmiPJXu5Idns/7ajGpqenXy
   AB7ijVwmTTp8/fUvTGZus0CiWpN4hGXK2DNI2u4d7s3i9R28lcZMbe9Ss
   A==;
X-CSE-ConnectionGUID: XPRs9QfiTk+6dgi64Iz47w==
X-CSE-MsgGUID: ZYf1JwkrRjy866SZ/PeiWQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13787187"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13787187"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:22:04 -0700
X-CSE-ConnectionGUID: KOnEPP4pTHaj/1Wvs/8row==
X-CSE-MsgGUID: IoJjYEW0QuyqT6RtAsDgBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35865194"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:22:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:22:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:22:03 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkvVF0Jhr5GzhMC+7AKwy6kttu6i5ugd3B0cyCxGx/av7X9Hx34q5HKEVcEpgiMezh9ko0y/Gq5YzP9nSGO/zEQAJgtwsoBgttFDiESy+q203AjynMarLyx+ek7hJS1iD2qfEFbHLGb4L7MEbulm1TVxl2D579t7eS6WNs5lNsLov27suLsi/t2wQt8r5lHFaIf+fHy+HQNyRhENwRT30C+zYH2+uts8DMW/Rz3TxcyaAZ4RyClYFMmgTjju8PkGLmIlgw23eHCxeRsJlc5DlXIqY5k089BK4VTb32FIoeYI7REI/vb/bk0KczoKk/gLGkyYIsLN8x8QSQUkukwo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DO2DslLaj7u4YmcpBsUCRSbYEv315pgj+qRYuIX8g4I=;
 b=QvIZa86FhA82N07hIBrwL7bOtx92OXsQydnMIZ73C70gyEMSM2/b/mpTwMHTPkiwdrFB1ZbJaMBab6pjVV5lu9g+Bi95243Ta+E040VUOkZe5Wu4G2wT1aAf0UQ68Il8ik48eyQvmvBHU2AJiZZiOdrwoknHPr9BZdkviY36y3PEeuYAShla6iM2f2Fy3JZzlvYyNCmoJFQ8T+dhD5qdECxE9lmvV5+cXEClLhn5Ma8KtpGxMCR3psXO6Fba9qCV3zLoByYZgjSpG6gcm2+8VcSavPDoDSkoZeF+GMGQrc/xQnmdQa4SLX0M8Bxu6MlCN9CauxJmmBUXkd5/i6vZsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 20:22:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:22:01 +0000
Message-ID: <546228e7-0a77-42d3-b2a3-ed6b507f018e@intel.com>
Date: Thu, 30 May 2024 13:21:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 11/20] x86/resctrl: Allocate a new bit in union
 mon_data_bits
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240528222006.58283-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:303:b4::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4951:EE_
X-MS-Office365-Filtering-Correlation-Id: 20405849-0576-477e-3124-08dc80e62a25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TG9ydnRzTUFhZzhlSUw5dUJCZmhjdlNwSlZ6dmQ5bSswbE9OdUE2aVNvVnBt?=
 =?utf-8?B?TUtOcW9XVS9aMCtsblJDRjZBN1Myd1RDNmUyQUJwdnk5NUpoaCthT2EyenlB?=
 =?utf-8?B?bXVQb3BQa0RHVFEzNzhCaVdMOHVjaGVyT3F2V0V3MnF6dWJod1hYeUtSQ1FK?=
 =?utf-8?B?QjRtZTgzVGEzWGtJRHJpdnFMelNqQkJsQjhIalY3cWtOODVZUFpYT0JwNC9I?=
 =?utf-8?B?clRUZVFwRy96MVVMbzBkbllZdFpUaERkQ3RuQzBiNGpTQ3dHdHJiZmF2U0t0?=
 =?utf-8?B?VzUzYWR4NnlxenZXUFI0R05jN2Y2ZWhueEpjRjl6em9DYTArTGw5TEZXVGR3?=
 =?utf-8?B?Slk4U1o4azZyZ0grczVwRDFQbzdka0taL05LRW9tUG5ub0UxREJRSXg4MGRw?=
 =?utf-8?B?T0NLS2Q3UldjaWdBQzNQeE5SbTdXK0VWTzYyLzE2YmVCa3hEczE4eWdXSXl2?=
 =?utf-8?B?anZSMDRpUWJEaTU3R2hMemFnMU5HaitlSTVmME5pOUdMYzZhWWRzL2JhZ2pz?=
 =?utf-8?B?M2ljS3BGZVF6bVpKdVA5cnh4c0pEMndQNUMxYU10aC8rb29Rdm9qa3VCbWpK?=
 =?utf-8?B?aDhyZ2hJcStmMHkrQ1dYUXdsUHBYWjJEWGlsVEQ5RktHQ2JNRGJtend4SGVn?=
 =?utf-8?B?b0gwTmU0VHdTNUhMS3Fid2xwUUZDc2t0bDZBLzR3NCt6UU1jK3UyUmtwT095?=
 =?utf-8?B?ckJJUHRWK0hlaTR3UDA3Mkp1OFZUV0M5cjFtbTA1RTQ4a0VXVTNteVZsWEI1?=
 =?utf-8?B?dmJmNkxGVENMNklFRUFqdU1HR2V6N3VyVzVCZlZXWC96RVZBRHBVTlFNWitn?=
 =?utf-8?B?VHVoY2F2SUU4WTJqTkFiZFBEQmFvL3VqbStLUjlVVUFpS0d2SEMvVDZndGM3?=
 =?utf-8?B?TG9HeHBnaGNlemgxdXE1K3hreHhoeVk2NUF6UDNZY3pVcXQwSDR0MFhjd0c3?=
 =?utf-8?B?ZDROTXV5ZWU3VU1hb0lJVHNrTVVJVnZyV3VlOGlDWUx4T1ZQZzZVYXd5KzNE?=
 =?utf-8?B?cmlsTDJGSmFNeG1iZFdXcllKRXZ3MXk3NTlJR2JwWEM4R04rMlpTUmVEN2FP?=
 =?utf-8?B?ZEJTVXcvK21uRHM4dHdhQUlLOUoxUWtIS293ajluWTlIWmlZNHZIeXQ0R0tU?=
 =?utf-8?B?ZERPd1NFZkhoOU5xdWdGdWJKUU1jRkZ1ZU52WEp2Rm1PcE5IdzF4c1BwQ2NG?=
 =?utf-8?B?TU9CWnFKQkpqQjYyVjVuWlFTQlJhNHlzRm0wTnVySnFNam9BVWV4c2RycVN6?=
 =?utf-8?B?ZzMwSlNVUGRxbGhKUkFCdllBVzVxTHF5TXlUUE81WmxTc2JHVWtubVptT1B0?=
 =?utf-8?B?cEh2WThIdi8zbXVld0tkVXF2dk1La3FwMHZrbEhHRE83cTFpekR4dTU1aXdX?=
 =?utf-8?B?TE9XY25qenRjSXVIeXQ4bnkrMVN6aG02VXpyUkZaTlMzcXl2c2U2NFRJRjBn?=
 =?utf-8?B?T05pVDBSUVlTM1M4RitkVSt2dlltUTJLb1V6Yi93M0VzZmszNUpSRTJtaUhR?=
 =?utf-8?B?SW9HZHZnQjNJWXZSbWtFRVJnSDZLNlVmQ3p4ejNLL0d2dXY3M0V2WlRVRUln?=
 =?utf-8?B?UE9pYnB4R1lsUVoxbkd3dWU5L2xlNDdiYzhNeGRwa2t6cEUvQklMU3UwYk5K?=
 =?utf-8?B?anR5UStYR2NvRWcwUDJYTkdydk1lQkJ5YisxeUg0SGZVR0NTZGZrb1dpbE5h?=
 =?utf-8?B?WDk3RS9lVFdLdUJPVk1GSjZ3TzUzNmF3Y21tMlhheWtRZTFYQ3JLTDBnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzJJL3FSSmcrKzNxc21zcUlRUEtQbjBVUzhIWlZNcmk1aXhMdjN0ekhLSmtw?=
 =?utf-8?B?N2t3K2duLzExMHVId1doMExrZUhZd0xJck1HM2x2eGhNM1pJTDZ6anNJaWsy?=
 =?utf-8?B?OFZ4cVd2LzE1NHNjNW02WXRPWEhadWIwN2dZbk9Oc2xMZ3BLSWpJanNBUTVK?=
 =?utf-8?B?akhkWGRVc0FaZzQybTA0K2ZiQVFVSUxFcUZTNE52RHhiTHE3RUVIS3liVlRq?=
 =?utf-8?B?WFZmSy8xZDYyRVRzNnk5eUpFZG84MWI1S1NpZmU5cHpqdXZBcW1kSHFuVWdP?=
 =?utf-8?B?UlQ2VHFrc3JaZW5XT0Z6ZFJGL2l1alluclh6MkdUcmh0ajA4MVlTOE5uVEtv?=
 =?utf-8?B?ei92YVhMS09nTUtWMFdYWThhWmNRSEJVMlk2WWtkOEhQQVhFNWd4d2J3ZzlO?=
 =?utf-8?B?czJwWkdPc0g1ZDdXL2h5RWcvVDNGM0sxc1BLdC9DL0xvYUNqM3lyUVpUOE83?=
 =?utf-8?B?bE5YZ2lzT0JTdTk2dURZR0V5U0ZvakE1VnZjUDFwQXZmS0dLSkZvckk5T0g2?=
 =?utf-8?B?eGQ4Zk1zN05xTHp3aFFFZWdZSWVERTNmb05UTmFOTWdPZnl6UjZLSE5RTlRm?=
 =?utf-8?B?UDRXYTBKSjJuSHlvS2NST3UvSzd3M25IK3ZoSXZwUEluNng4Vld6WHRvdWow?=
 =?utf-8?B?VFFrVWlrS0lMOGNWV2VwK1lJYUxMTjRpMlp1bXNqaWZNUzZYb0FST1ljVjRU?=
 =?utf-8?B?WjJJSmlFZDZOcmFEdHdWZVVDQ2hMVVdpeVI3bFhyUm9IRWczMTA5Y2JFQ1FP?=
 =?utf-8?B?ZW12MDJDY0l1dnljSEVOWVN6OVIzRVBmbDd1NnRZZVVkM04wNzg2NEViVUNl?=
 =?utf-8?B?MjA3UWFZcTN6MGJOaVpJT1lFekt3ODZZNk02S0x3N3F4Z2VIQ3VWeWFIRkg0?=
 =?utf-8?B?QmZpY2EwRFRPa0V1dngvaHNrQjJpbG5IV3dWMHBqcXRPNk02VDVSWkdZbm5a?=
 =?utf-8?B?WmZNTVVpbWdiV0RLeWZuUnM5b3JzL3pOcmdYUnh1VkdyekR2WVQ1dEJrbk1C?=
 =?utf-8?B?blp2bzErSXdnSU1YNCt2bjVGY3RBZkloaW4rak8vaGNsdVZFdDJtV0tDNDhR?=
 =?utf-8?B?eVp2Vlp1MU1lRDB3aHE5Mlo0Nk1Mank1RFl2SEo3UGlicmN2TXR5V2Z5ZlR0?=
 =?utf-8?B?VjN4UTZWMWJqRUxCZjZRYU1LRHlsUGN3MmovN2pNdXJUU0xtZmM0SDF4clJ6?=
 =?utf-8?B?cjdNV2NaU3F4TXBGc3R6V0VKTURzMnEvamJGRExoN3c2ZFpvdlJRK2dkNTZW?=
 =?utf-8?B?QXV5anhWME9DK21FSDFwU3RWMXNQcW5jckYwZWZOZFE1c2Q3NHhBaWc4MHMx?=
 =?utf-8?B?bVpnVG02SkVqTEEzUndtS1RLOFVsTXZZT1BXWFZ0eGZjMHJIeWIvUmpKL2ZT?=
 =?utf-8?B?djZtYkdYd3J4YUQrNjFFUE5oVXB0c1dMdmthWGVNSEV3eElUMmlOSkJIQXQ0?=
 =?utf-8?B?U0xueHVWOHkyOFFYVVZzYUdMSk5kUHhFam1ZdXJRcWx2MUQveTQ5ZEk2dDhK?=
 =?utf-8?B?TTZWR3dOdmhoWEFONjZPR3AveW5renYxTEc0bW9XcUk2TkpPNDhoZHRCUEtH?=
 =?utf-8?B?SUQ0WEZJMkczQ3g3S3JHTng2TmtnY2x6MVJXUHFMNVNpU0FNZ3kyOXFLYnd6?=
 =?utf-8?B?T3kxS3ZBbGxFQWNaV2NZU1J6M1AxdEl3VWhoYUhKUXpMUHJaMmhndFRQaTQ5?=
 =?utf-8?B?c1kwRVZ4TUM1cnpOcWRNUFkza3N3dlFkdlJFeUR3Q3Z6M3FMa0xoR25vY2RP?=
 =?utf-8?B?U0R4LzV5ank5WDIzbDFuYnlZRUh1TzFhc3U5SlRHQllBRmtvQmV1b2Yvd29t?=
 =?utf-8?B?MXF1Q3BKRlptWXpBdnZ1aHZ5ZG15Zk56OUxFNlJRazVOOUJXSnNabWlSejcx?=
 =?utf-8?B?MWVMSE5TWVRXYVRyQVBEN1duTXptUUNPcmRFTjc1ZkhEcnpXM2JxMDhrMjQw?=
 =?utf-8?B?cFpsYVg1TEhiNXhubmR4RSszMy8rTkorWmRVbkRsOTJDa3JuR1dwd20xZXdE?=
 =?utf-8?B?SmxpVloza3g3Y2FhTU00VTFybFlLVG41UDBxdTRQelRPc21JU2V5cVg0U0k5?=
 =?utf-8?B?TkRiY3dFYmlTTFRSTDc4T0dPUEZzSy9GeXA0WUlZWG84bFU1RjhjakV5VmNC?=
 =?utf-8?B?eEFIRURHbUVmUVlmazNzTy9ZeFYxYVh2ZU9CZytoQ0ttdmtRa1lHbG9RNlNj?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20405849-0576-477e-3124-08dc80e62a25
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:22:01.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGtlqi0siu3b0jzgkh7VMd9MyZQVuPDyhvgU2tKOieGQ+jZO4+LC3W43Av44VDqoPSkkTom8DcfL8nx2gvecW+sEgnOszQnq9uMTNFYUofU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4951
X-OriginatorOrg: intel.com

Hi Tony,

Regarding shortlog: isn't the purpose of this change to _avoid_
allocating a new bit?

On 5/28/24 3:19 PM, Tony Luck wrote:
> When Sub-NUMA Cluster (SNC) mode is enabled the legacy monitor reporting
> files must report the sum of the data from all of the SNC nodes that
> share the L3 cache that is referenced by the monitor file.
> 
> Resctrl squeezes all the attributes of these files into 32-bits so they
> can be stored in the "priv" field of struct kernfs_node.
> 
> Arbitrarily choose the "evtid" field to sacrifice one bit to make
> space for a new bit. This structure is purely internal to resctrl,

Missing explanation why this is ok for this field to sacrifice a bit.

> no ABI issues with modifying it. Subsequent changes may rearrange the
> allocation of bits between each of the fields as needed.
> 
> The stolen bit is given to a new "sum" field that indicates that reading

stolen? Is that necessary? It can just be "Give the bit ..." (also
note imperative tone)

> this file must sum across SNC nodes. This bit also indicates that the
> domid field is the l3_cache_id (instead of a domain id) to find which
> domains must be summed.

l3_cache_id looks like a variable that does not exist anywhere in this series
or in existing resctrl.

Reinette
