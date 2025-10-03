Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49C1247DEA
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533889; cv=fail; b=UuNnw2tDBj3AmP6eE3dCPtOT4q8GetJIKTfF8MAOySxapajvUyK/1ieGuug8+3KEec4TcA3vKmEgOaH4BojNssVsYSKfzOmH+irS57njbbiNOb7d8G8+TboBv7ztIFswGljmd+eQxMdwWm632hEJ7EnW/ZeATdlS8OYUmzFgE+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533889; c=relaxed/simple;
	bh=83pDdUxh+WDXz2yQqxf7GJbqvRpGcDAZ74qTFfrr5qk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P/+4eAWNWsCfKvSOerbeVkBsDiRWSDEMPr7Ychm25mAZxGw1zVYWSlzUld9ZhqISAtHrIWKIP4+bS1yBBYEIJxStkWaK2MsDWJhl1i0s16NAkA3ecjU28z+Cmg9b4L/GWQRdojVcaege0XhpX126JbmWlilqsm+KRFdH/DtF5lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RK14Cff9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RK14Cff9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759533888; x=1791069888;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=83pDdUxh+WDXz2yQqxf7GJbqvRpGcDAZ74qTFfrr5qk=;
  b=RK14Cff96B1VrkbQ/776ObQO5f5uegPU596MPudNdl81eBCW5lkdz5C6
   bpNvCDiM6NjbOsPvk9IAK1OxQt61uDcXq2I5kSuhA73AZDKGsJgMnrXvz
   0Efc0JRtusPwGjgEYV9czwo6DZso6OqEFh36DYlYr3GMGQRuEg1XLf5VP
   xMbUN8b4QJd8iDTMphYxSz51jXpmG/Lcfw4BMaBr4Dne/CAXvi2C2V8Yl
   lUMjKDtdCbbfE0EBlQXwlzIu9t2bmDBwTfSUVta8G3P4XORxQpkGsxPuu
   kCp37AQtkdrpF1vzafowzQiS9ySx31GVVb/GniJ1uspY8dLT5Xig9MMuC
   g==;
X-CSE-ConnectionGUID: PUJortcDScuInBr9jntQpA==
X-CSE-MsgGUID: ovq29A7iSbu1oGsVm2DTWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="65460544"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="65460544"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:24:48 -0700
X-CSE-ConnectionGUID: RUMyA/P4Sei4MY6N+DLp2Q==
X-CSE-MsgGUID: G3haOpVURxyepFnLdbnXcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179043261"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:24:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:24:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:24:46 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:24:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EwloQB0anqMEsvd/sz1k/IQBOOPyzk07GTuLM1WWGO5p78oian7EKIIdxWQLTCLNjJWEUCaAxU5ucVzhGRLtmPaCC8FVbCP1OKHeLSzecaNrdD2TLttmyBrD//xB4e2vhtdQpHBPjrivTdgf/vBtL09tsuIYmaw5m+myDxzlDUSdPHqPRS7GTlJ2u4IfZqft178wIPvevmb6rfJR2R9d4b0OqJTPEiw5U+Zt0x0C4UhMTzYdMX1ojuTbiRkGQNRz5vfTNtFr4oAZ2KNOxZp2OvI3UWRRsUUNU3nx5euPE3QC3eVGh03/nM0P87bAf20qnPE+nvlAAOUZ3U8vZOEMbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LX+9J7H/krM8f6QIL5q3Rh8ZauZ6UoKc4iY/6tSGRGc=;
 b=ckky6DiXWX9iD5gQ0QwaLzAQ+szPEaz2AGNBf2VeVTi2QQ987rGnI69IDu4mT7XOrUsRXP2FIZBIIBloMJ+t1cTKQJcT/i+MthLaZkYqVE7V5hcBBJJDyEm/ql7S1M7nexXDOg8nQ9ArkgQXT9pVtPiyXRqTdhG6ZTvsKm3qlqOMZiopbqTuT3lqcaLZQVVhUoc/jdxIrur3CObdnQc+2T393vZhyhvMnuqYGQtgo9x0M6QqPdvnFPmSbGyw+B2Ye8EGqnPsDj7OEYeLYZLNItqHYXZyFIilLBwXhcKmHBeOIyEmEEYKPIq+S6rqyAcEpJ8gDPFwAdeANiMoa6M5wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Fri, 3 Oct
 2025 23:24:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:24:40 +0000
Message-ID: <c55a68ef-abb9-4b5b-a529-d8d1981271e6@intel.com>
Date: Fri, 3 Oct 2025 16:24:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/31] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0266.namprd04.prod.outlook.com
 (2603:10b6:303:88::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 926d62e3-e253-4cd1-a39b-08de02d406ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RVVBeWtON2VlK2syWGZ5c3lrRWRIeXRaaDdHMXpCU0tZZzhzV1BDNzNuRnJk?=
 =?utf-8?B?eldvbDFlbksrdlFBcWpSblIyZnQ5YWdUME1XWWpVN1pQeFN3MTJnZFpERFpq?=
 =?utf-8?B?K0ZaaFVGaHRIdENkWkYxTlFDS0RjenowWTlHcTJVeEZBOU1WVTA1SVdyWERM?=
 =?utf-8?B?NFVyZUhRNFZyRFprWVpycnZoWFdMNjYrRC9Pbzd0TzUwK1NzVGJuQTZscEE3?=
 =?utf-8?B?RlMzSmN3UHM5dWVRN0tQekRUU2JkNVhjOUozZzRjdjAyOWplalFlVzc1R2V5?=
 =?utf-8?B?TitMR2IvdWJhMFlBQXlvS0MyNDJLVWVSSlc4T0FBKzh6VHdvUFA1SmVFaEFw?=
 =?utf-8?B?a0JNcEpPS0I5SEZWWXlWTVl5ZTErMys3OTA0ZWFlbWRySkJqMTZ4VmsyVEZo?=
 =?utf-8?B?MWNWQnl5N29QUTA2VFFYOFhoenFkUnRZdmZ3QUdlM0pVcUJOdW1qU2Y4RCtT?=
 =?utf-8?B?cC9YMHFpejhiMG5wbCs5UmJ2SmNEUk5uMUU5enVadlh6WUUvUWoxcnQwSGph?=
 =?utf-8?B?RGtIL1lSOGtmV3Y4K0x3S2hvRWNhRit2d3oxV3BFUWN2NFcreDBVVlA3eHd2?=
 =?utf-8?B?UWE3Y3BHNjA5TE5rOVNWakFMVVAzd20xdjBDSEp2MGlYTno4YlAzR1JKdUNm?=
 =?utf-8?B?cU9ycHI1UnhVbk1iSDhFS0NwN014UmdPYmxQb3M3bW05Z0lBRzdHL0swMUNJ?=
 =?utf-8?B?RmwwK3lQc1Vzd3hhUTByUmIzZW1jRDc3TGU1ZFdPLzhQWTNCWXZWRE1BQVlE?=
 =?utf-8?B?R25iY2lkNzN1UFZObk9xbUpVWTNjd3ZFNHFYb3ZhQzFhWmVEUnNVZnlSR0dj?=
 =?utf-8?B?S0s5dU45TnVRekR4TlplMGQ0VGgzM3IxZDhQTldyck55MzFWRzZDN2VEOGdj?=
 =?utf-8?B?N1BIckM1TWU1N2E1RURkRjdwMDAvaEowRkJDQVdHS1dkUzUydUtuNkUxbGpm?=
 =?utf-8?B?RVI4UHUrMndzWVJwM3ZWdklaMVVnSlRHekZDMWp4UmF6T3dkT2xpUFBtRHY4?=
 =?utf-8?B?RjArNCtRcDhxYlc4R28zZW9tTWZWV1VvTEc5T2lwZUxaQkJacStnRnd6cmtw?=
 =?utf-8?B?cXR0SnRISGV0dk1lR2wwZVJuandEeTFRK25PZ0dOd2Y1VFlmR2JPVzA1QS90?=
 =?utf-8?B?QWRpMlYwMnkxTmhyeTVDalVzUjVBblVpeHdHeDRBRGttMEF0NHY3QjNMWW5P?=
 =?utf-8?B?cURLRWFDbDhSbUxFT0ZUWmdpcldSemh1OUxJU1pzY1N6Y1B0M1Zqdm5FdXFS?=
 =?utf-8?B?QzdZb3FzWHdtVUd4eFliVVdIbjk0RUxkUVdvWUJkZ1M3MDZhRDl3aVpBWjJ2?=
 =?utf-8?B?UHpadFV1RUJ0aTl2MjljdCs4elVxZ0RrdllUK3RlKzEvWHdJNmZFdFZ1cGlB?=
 =?utf-8?B?cVJOWWhwQkpQUVdHZ3pUQTY3NWlYcnJkYVh4Yk1LWnhBNEpwd3ZHS3JwbzhT?=
 =?utf-8?B?ZEl2SkxIWHZYL2o5RkRDbjEwazBaZ0xMYmdNQndleHVJbUVsTWp0bFUrSW1N?=
 =?utf-8?B?WVFCTTVhTnoyUkcwK1ZKczNoTWNQN2k5eTJFMWtYOXJEcERaMXhnS1dwVTlZ?=
 =?utf-8?B?ZktsNmdqK01UTnBUYWozanBhRTRxbG44aG9VcDVHT0h1VW4ralk5d1FwWnV2?=
 =?utf-8?B?T084Q1pPTnVSOHFJcS9Qbldhb1QwOW0vS3NpVktvSVJlVXFXQU0vUlpmWEhH?=
 =?utf-8?B?enE2dGlMWWFSdVhCbHNRNTFHUzV1VkgyRy9SQVIrVkdVdy9heWh5bGFSdUxl?=
 =?utf-8?B?b2dDelBlWkRDT0xrcS9DY3plZjNzVHlYS01DVkVoV2lxZGt5NGhBckpQL0sz?=
 =?utf-8?B?c2lGQVpLTmErTTVqbmd6OHg1NUVLMm43NlJOWXhmbGF1R05OOE94Yno2bXZV?=
 =?utf-8?B?dzBGSUlpa0hSWmx1RGdETFRhdi9rbEdJd1ZwdWFwVEM3Vk1Gd2x3QXhCK3NC?=
 =?utf-8?Q?Wz3p+uQmKSRkAgPdOR4Dwd2XiI0eLsa+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXhIaUJlL1k2bTErTW9KaUExa3RkQ0RmK1RnNW1OV1l0TzRwcE51YitXb2Jj?=
 =?utf-8?B?c1ZGM1pVV05vVzhMWHkvRlJFWnBtTWw3MnJoKzVQdDQ1dThiQ25TVHltaXMv?=
 =?utf-8?B?UzhJMDhqKzNCaldRUlFRaE91Tm9aRE1ZWldCSGwwd092ZEJySjFXRVRxdWoz?=
 =?utf-8?B?c0w2VnRsaU56QXRnYlpLakVIK3A1LzhVOEFjMk1zT3BTajVPOW5kaW9nM3BZ?=
 =?utf-8?B?cWNjdmZRVE1nU3I0MEhKMU9qelloOU9uTk8rQnFuakxCMkd3KzZYTWM2M1JV?=
 =?utf-8?B?emwrTG9sQXF0eEVCUy9SbTdSSUJpUkRsOFhuYTg1enpBalRkZnVPQkV1U2Qr?=
 =?utf-8?B?MU1adTRLOGU3RFd0M3RXZmRWb2RUYjM4eTNmb3J6eHhncHNoMWU0Wi9Tam05?=
 =?utf-8?B?MlVVbTlUZmptOEJVVHQraG1XV25oWDNLNW43REhrS2pPQVNOTGRQUnVtVFJo?=
 =?utf-8?B?L1AybnFHb29LSlNFcUFZT3ZGcWoycllrNXRmNkdnUm1SL1pkTUduRHBiN1lt?=
 =?utf-8?B?Nk5JK3d4eWthbmhFYVM5eVF0SUU5UWN0OVA0Sng4Uk5UR2hBSDZWWnNhc3F5?=
 =?utf-8?B?YTU5UUZRSXo0M0phT2xoV3JrdS9oMWNCMVh4d0wvQmw0TTVDYVpKSitGZXh2?=
 =?utf-8?B?R0lhNWM5Z3hGK1F4SXRxcGxTaWF6UlI2SzhGa3Y4VktZSlBOa0FWZENCTVRt?=
 =?utf-8?B?MmxtT3U0eExLcnlYM2ZnU3ZFSGpQNmgyc2V3bjZKR0ZJR3VMRkhyTXZpLzk3?=
 =?utf-8?B?ZElaRjdpM2tObklWaUVwYlNSWFVxU2VqeWN2RUh1OGVrNEIxWUFIWFpTT0Mx?=
 =?utf-8?B?M1d1L0RoUWNNRVZaRnlweWd6T0FFdlVIMTZwMHdKQVh2V1BIaHpYbkc1S1RO?=
 =?utf-8?B?Z2p1b3VZNUhUbmViczhyTjFBQTIzWFJLQTFRZVhQZnZjNS9Cb0RWUTh6Qmkx?=
 =?utf-8?B?WE00WmFPVS9UMktzWjBOdHcxWG5JUnhadUsySUxWK29iTHJoanU0dGkzajJj?=
 =?utf-8?B?MWx5RGUxRit6bVU5RVUvd3JPbTRwTGpaREFSMmh6ZzBQcUFMUGlzVVkyME9H?=
 =?utf-8?B?RmRBQlhXWlBqdWtoK3IzU1hveWE5T0YxM1JjMXA1YmkvS2RaZTBZeWxQbHBj?=
 =?utf-8?B?RDB3ZEVEbUVUSERkUmtJSFVkL0JWRmR1Q2MvZGZoSXQwTXN6U1BUSkFtaFA1?=
 =?utf-8?B?ZktGOCtsTks2M3U5YTVTWjJ5bzV4WlFLcmZzMlVrUlcwZDd5VTNzdUh2T0Vh?=
 =?utf-8?B?ejFsWXk0Q0NYZXI3d29xcW56Q2UrcTJQMU1iamZVKzlVdHl3T1c4NnYyRlFn?=
 =?utf-8?B?bmY0Tk1makhIVEhpZGJnWVdrbHVkejkrZ2tNRks0bE8vU0hCSDdOSUNhaTdK?=
 =?utf-8?B?aERvdk9BdU5qaHJrSy9JQ3FpSmIraE1ZNGFxUS9ycXg4S3pvQkZSVXY0Vlpz?=
 =?utf-8?B?bGFxM0M4ZzMwSkFyZEFSWStmZ2VCYlhDZ2o5eE1yMDFiZnVzNUQzZUpSRzN4?=
 =?utf-8?B?RldBKzg2bU5QUXB4ZTk3N242SVNWMGMzY0UzSkZCWDhYemZHcW45aCtjTUVv?=
 =?utf-8?B?Z3M0cHBMZEwxSGcxZ2JJRDJWN1hZMUUvVnhsMFR2elpBdVRPckxEeS8wd3ZI?=
 =?utf-8?B?VnlDMVpSNGNESkFSNzYyZnhvREpEZXNqQjRPbnkzejBJWDhEdU8zMXRpd3Y1?=
 =?utf-8?B?RDlmNFI3aVpMam43YmRFczcweE1NL2prRndWNlNURUJ5R0NyQTVEWGVMejRh?=
 =?utf-8?B?VUxmYnlQNGppOTlScXpiUXRsbjJzZTVlMzVLUDF1elIxeElFUGdReWV6Rk8y?=
 =?utf-8?B?ZGdSV1VoVHl6aDV0OC9tV2hncEpDU0JIUDdQbjlxaUM2TjlsN2xrRHBSWSsv?=
 =?utf-8?B?Z29wQThxMHFGWUd5eDNPelp1b0ZQTm1QdVNseVF6OTc3aEpDZEQ1S3Q4UldJ?=
 =?utf-8?B?REc2UXBUbUw1M0V6V09WTzNQVFBoZ3dVbmJVRjl4S1RwemsxNjFVVmdWVGx1?=
 =?utf-8?B?bHZZR0ZXMnlZelZxczltdndtS3M0cDhvUWhvYXBaQVlYWVRMdHBjVDV4cGxn?=
 =?utf-8?B?VHdSMTRCV2t5SU9yTFR2Rmp6RzdLYnd5WWlydzQ0TTl6S2pEMUFadkFzWHpX?=
 =?utf-8?B?VWNkWnlYcnMwcEJ1YnBpcXVjVHlTSVdrUmlvSGhKb3FiS0g0eUpDOWludlFu?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 926d62e3-e253-4cd1-a39b-08de02d406ba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:24:40.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkHbI29YRETDCwChQdcwh5f5zl2vKE13/L6r+CGtLABgMMVHYfOpU2TqOLUM7a1PP0I6Z3cLdkfuzBvKnvXOtgGWuug/suS3osAuSfN8jRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> With the arrival of monitor events tied to new domains associated with
> a different resource it would be clearer if the L3 resource specific
> functions are more accurately named.
> 
> Rename three groups of functions:
> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Initialization/exit:
> rdt_get_mon_l3_config()		-> rdt_get_l3_mon_config()
> resctrl_mon_resource_init()	-> resctrl_l3_mon_resource_init()
> resctrl_mon_resource_exit()	-> resctrl_l3_mon_resource_exit()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
