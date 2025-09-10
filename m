Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D60E199BC
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757475598; cv=fail; b=me0+ELFsX6p6jc73R2FncgSQwkUfSmsjbUQiAtwxMGk2kKQr0OgMHf/CeeFV8u5bJA47sQwR5qu8xC3ERgCzHtzd9mhyzD8bwsg6HK16ypqkGggQct3Ti+Q/Tjh6fsW9lZfEsjJ0anLDg/UhBguIKnesUBUhJeDYLvJpcYzUyx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757475598; c=relaxed/simple;
	bh=4cbSZP84b59brmViviIyS2w/yQppH4mevDMlSEcndtg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VaD9+t/d4szCK6VIWJQa93/4pLkfs5z33v/9HEfP0TJb8qMNoiAfEri6LwJakzJkFMZtYeP7aLrUFuR6n/OYw4RFw1JiVx50INudiHMgQrtW+3QC6oISxYd9GaB+sl/KogpAmzjB1IuAlIMWjmzdHirfMAuoCXBO1LYn1QS9tB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZuycGekL; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZuycGekL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757475597; x=1789011597;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4cbSZP84b59brmViviIyS2w/yQppH4mevDMlSEcndtg=;
  b=ZuycGekLK6TROksP8oiAFjIOXrHbz40w/MQxP0Suqn6tkC8HHziZxYp9
   7aWuV1UvrfiLjAa84QHSNCaZh9rLlLoooXWkPZNQAiTHlUikQOcgZO76Y
   lGLDmN+Q0jOWxIHJ5aWAsb+OX/qAAI9giWnYyTf8zIFWxRLjtIMHEceCx
   obNxkOLlstxe492YA0BABsLU1sa7PRBho6zHNfQLjQy49Uap17krRQbDn
   B8V6+i5Iele9lsYUrFPqAIEN/hMlaP5yHUzjwBad3FK7e6/lWsmC99IJW
   5lJfMnW/eLFfcOuGCyjYT8kN3dpmNIRnocEugoueyry/F0XgS/imZS3k8
   Q==;
X-CSE-ConnectionGUID: POrChFSfTgy/rSABCwNqNQ==
X-CSE-MsgGUID: W7JRb/ZfRTOvT5eKJt1i4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="58994183"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="58994183"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:39:56 -0700
X-CSE-ConnectionGUID: spf3fxoBSwu7MBT8zIjORw==
X-CSE-MsgGUID: xFsxUgicS1K5JIosRHGB5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="210399947"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:39:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:39:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 20:39:55 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.59)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 20:39:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xICvbC97+sJ6FVytixxJ0QFiSqk7hZRTpxKSVq5pmW+VSGOj1iO920XfS5KM6zdfvNiNL9wTm9kGwaaj8dFAdsMxV2nz0z21hG2DzKAtwCWQUTGXNqsY9C/fP1Cl0cTSO4F2c5giWkSTSl0aGxIPMx1PhiFZ0t/NxwEkfyuB2RD4bba8pEwsbhSQtnog+eRUckgSU8ZuUWnyJiqVYM6OOhsaQW3x8tfVOzFGOEvGqnBlcu2gTjaBD204r5Y70FzIkUisZvJXDeSWU7VBafVwdk3mYejobyV2YpjdzrUiLgKTvEz3Syi/Nt5AFVqVwUvRdFJhsCK4mnESmRL5gA+QQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sc1MsFd7n0BgmE/GaDPO8PIIUEcyM6oKHhRElaHzyTQ=;
 b=rGacrZ3duzWxoogYPIrRek/+yU+/Hx0ljwUe/QThihr8B2pGvcOQhT2N40sreo1yzfKBnVXioAn8Aw93vrdl6P6UbaavU2Mwu4inLBkXntNtAqm7F9UdOf+D+r2W8aBynlC5U2TqC0W6U7vG4HCgyv1WiStOJ8cKhTIOed5TMNfCUPb9d9BRcJWgt2ls3msozfM6BKYQT+LhyGPItSDzutnpqLF/+fy52RIfPzQIwuth7gnAgRnEqsrdaK+QgBVcnbDpsN3RHrFuTeHTyrXSV8OLuyldfKDji+8qVoQM3wAWp/3mxn/oB8HtGwlTk7s30Rx1MGWjqDnNbAaXq+MIMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF66B2E927F.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::830) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 03:39:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 03:39:53 +0000
Message-ID: <ff545231-c704-4528-a490-63626a5bb5f7@intel.com>
Date: Tue, 9 Sep 2025 20:39:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 18/31] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-19-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0035.namprd21.prod.outlook.com
 (2603:10b6:302:1::48) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF66B2E927F:EE_
X-MS-Office365-Filtering-Correlation-Id: d64a0db2-0015-4e14-37c9-08ddf01bb3e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEFiQ2Nzd0xTUGU4TFgxUEJsZHhwTGxQZ3ZQampRMFN3Sks3bjBhbDdqdTVp?=
 =?utf-8?B?ZjI5Rm5tdDlyckJxSGFCRk14UEg0eVBGZmhOcHJNWVNiSzFuamhQZGtuOUx5?=
 =?utf-8?B?TkJoOUp2dzJVREZ1dXVHbklvMzVOWExSUGsrMDE3d0d0U1BrMWhpZUtSeS9J?=
 =?utf-8?B?N2I2c1dWVGwyN3lxaUdMOVBoeG5MNDZ6a1RFMklTQXhlbHNXbVpJUlNuRW9Q?=
 =?utf-8?B?bHYvVElOR1d2V3Nqdzhrb2c5bFBGYStHYzZiOWhObDdaTlpHcnpRUjFLQXF0?=
 =?utf-8?B?SjFNSW8waUJ4V2w4WlkremxSREUyM3FraGZkM1ZPOVZIQ2p5VDIzbEdTSDh2?=
 =?utf-8?B?dTVySVNpaFF2Y3JDQlptYVlidkNzei95T08ycGxaSnFmeGpuWGNJU2ovOW10?=
 =?utf-8?B?ajAxN0JwVHVzMXB6eUh4M3A4Mjg1WWdFNFpPV04wR1lGSEltWVE4aTViNkYr?=
 =?utf-8?B?Z1N1c2YzeFpBTEFXQnJlR2tad0Jxb3dqY0xueHVtVUQvbkd6RGdBZmNrU2tw?=
 =?utf-8?B?akl0YlFLRDdzZytZMVlUOVFBdEdRNnNSSldFT3hLVTk0LzdXRXMvVGJFVWpT?=
 =?utf-8?B?dlAxMXZzaTVPSG9LdWVLT1hodytNbkM0UFNhK3ZWYWpEYStSeStRTlY5ZElJ?=
 =?utf-8?B?L3ZNYXQ0dFNWVEpxUS9SdkhzS2tZaHVDSFRyTmFia3hhN2VDUnAyNmxQQkdi?=
 =?utf-8?B?WmhDYm9LMytQRG04SnkyY0FBNllBZDlLaFJxQWp1OEhqNXArbEU4TjJFVXVG?=
 =?utf-8?B?VlhFcTAwZzAwTktXTHE5Y3Q2VDZxVW8wWk93VnpYOHQxYWxvOEZkU25PZE9a?=
 =?utf-8?B?c2NMbktIQkdROUsxUUNaRnptWjN3ZjJzbmZhWE9XeDVvYTVMakNJbzVkZk0x?=
 =?utf-8?B?TGViaVZBSlI3R2ZxMkJxeXQxUXBpbG4zeTl3K1dZam5Eb2FwNU1rOHdGbWJO?=
 =?utf-8?B?Uk5QWVdGeWp2M3BZdFEydGNjNHF6alMzNHBSejFBUnlFdEl2cTVUM1FZVXlN?=
 =?utf-8?B?eHZMOVNQdzdsSC9vd3duSk01ME1Pdzk4Nm5Yek5zQ0hIdHBMK054MmQ5UG1y?=
 =?utf-8?B?RWdPbkxkWFJjckVjK0g0bnBjUDBpRHBvT2xTRldOdEt4ajRsOXVSellwRDRC?=
 =?utf-8?B?ZFRiS2pMOWhuUUQ1ODR4WFhqZGtCcUwzMmxoaU9DM1JQTzRIU2FtUGt0dlZo?=
 =?utf-8?B?OTUxbDZ2WHBnRkhMdmg5ZWFManBNLzhrMEt1YUlMcWlqOFJsem5PZ2FvQUtX?=
 =?utf-8?B?TVZEaDRKRlBMa0J0RWlzdjRadVZsVlh2aGN1Rmpjd0s4T3BIOUQ5Q0dOTmFu?=
 =?utf-8?B?akVsRndqVHNGYWNIWnlGZmx5U25vdTFrRitJK3RTUERGTllhbHpFaVJjRk5q?=
 =?utf-8?B?a2RPZFpBVjVqSjZFR29sdHFpOFRRQ0k4WDhVZ3czUlN3WVJwbURDcXJwRXVa?=
 =?utf-8?B?dmV6bHp1SUJnNlRDQ1ZQWnhZS29KR2kyaFJuRkRZNDk2YmJJY2xPNytzRmE1?=
 =?utf-8?B?dXJXeEJIc21YeEZrb1lYOG1GOEZMckxlNXlBaGdjRVBRWGpLWXlyeDMyVUtD?=
 =?utf-8?B?amNNSVBORmt1RnNEcDRWb055NEk1QnhqM0d2WnNzVWFMeldMZURpNDM1UWh4?=
 =?utf-8?B?RWFJYjduc0RvQkkzN0FaK085YitHZnVyT0EvRnUzamJ1ZVF2dlBYdDJ3ZmxX?=
 =?utf-8?B?VHkxWVE5d0Y2cVhiTW5kb1p6WmZQUGwxekdIempiV2Q4Umw5TCtFeHBhV0hH?=
 =?utf-8?B?OU8rT0dBTUh3Q2FUTWIySk9UZ1lKaXpEQW5Gei9vZVp6Nmo2c001cWhkd04v?=
 =?utf-8?B?Y29BV1FWMWQ5QU1VWnhoWUVEUlRxNUFUa2VYclZSVHUzejFEQjdiWTBFR3M3?=
 =?utf-8?B?MktUZm55Z0RsQU8rcXI1Qlc2TVZWZkhhelpkOUJKSEhLMU9IbnRvdEN3YnhB?=
 =?utf-8?Q?GHzcV+SuRXw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2ZaQm1WRnVtM0tLYTQzYUZMc3FiRnJvb1lkSW9Kb3JDS2syT3pOMUpoUEdC?=
 =?utf-8?B?TjVscnVuaFFZaEU2VG03d0UyanFyMDlvb1dhbEF4S0haQTIxN2ZGUDJmMGN2?=
 =?utf-8?B?SEJ2ZmFrU0VzOEpNc3kyY1VFem1NSlJsU3JIMFl0bWJFZURQbjJHSkxBS3VU?=
 =?utf-8?B?dlBDRHkwcGJYNEtvZ05kOE9BY2d6U2JDbmZkakNDSTZVQkorUzZQOWsxZGsv?=
 =?utf-8?B?c0gwRURvZEtPc3Y5ejdJZEpGNERub3ExL3czZlAvd1crMnhTYXJZNUN5UmN6?=
 =?utf-8?B?TElrbG1oZTQxUzlZOHZoMmZwT1JvTmpWb2xCNWxielJkMC9BR2c4V2lTSUkr?=
 =?utf-8?B?VDl3ZDFDbHlWYUF2V1hoVGR0L0ZzcHdyMlQ5b20rUytqZXdOMnluNlhuSHpD?=
 =?utf-8?B?RTN0SThzTDA4YjFsVGRCMnFTNVBXOVl5R1YwU1RaOEZhRjhQK25aYkhMVjZY?=
 =?utf-8?B?QmpSUFEyRnJ6S3I1WHJ2cVgwTDRIcGVLMzBCRWR3QkFkaFcxSUxoOUdnRHIw?=
 =?utf-8?B?b0dwNDViazV4WkRwdm1pVU8veHJvV3JFdkdZVG95b1JESUdiRndCSU5kMCtP?=
 =?utf-8?B?WWxtNHVOeWhnaUU1UGc3VFNKVGp0cFNQbE81blJybUd3Y244RStoNEN2ak0r?=
 =?utf-8?B?Sncza0E3QXBFQ09JV2ZSSEUrdmtmVFZDbXdkaDgrczduRDMxZ2JLTjV5VUtv?=
 =?utf-8?B?cWRsTFN0VVY3MklCaWduQlgrMURxYWQ0eVRxRXZTTFlrdVVwL0t0RFBTRHgv?=
 =?utf-8?B?RmdsR3VjSE9BY1NCSzRORVkwQ3hpTDNOd1FoSWlwUVp1UGxhZ2t4ZWwwdUda?=
 =?utf-8?B?Z21Zb1V0WXJPKzZlbk9VK1d6dHlQTkY3NWEzTzZDdzEyN0hBbTdqaXpKazRQ?=
 =?utf-8?B?a0NZQXR4MVI0VmNKUjlOSEJHMWpzTXArUndBWGlidXp4NjRlT09tSHpqTWF0?=
 =?utf-8?B?SWRKdjl0dzByQnhYcDFFQ2hCbzVGTjhCWXpBb25uMW5aYWdmc2pkOUFTRnNn?=
 =?utf-8?B?bURUR1huenlsWVpsRVF2NFVmUG9kWkY5R0FNU1I0SStYaFhmN3cvMDFWZ2dl?=
 =?utf-8?B?dG5CcDYwNWpabktndXFBd3dkWk5FRWNXNUZiMUVrT1FVTzZkKzM3bmpMMFd5?=
 =?utf-8?B?OVJ1UWd0VGZLMi9YUzFidjcxUEpWSnBCUVV0eWFuVXE5alFzRko5VDl6KzNT?=
 =?utf-8?B?UStlaWhaS1FyWnB0YXZkdHJYZThKdk5LNlFZM0NGcWlsRU9qMnptbzB0em94?=
 =?utf-8?B?WGpINTlIU2lGbG1KRzR4TmtzNDZKRjVpa09QbDgvWUV6dEJ2VFo2Q0JXTHZB?=
 =?utf-8?B?amlGVldPMkZ6WENVY1UzV1ovNlZ4eTJhejZ2ekIxUktOVVRkOS9PelJsQ1J2?=
 =?utf-8?B?ZXFnaVZQL21EWkRCekN5WFIycnhpVzQ1WTBUdzNxTUpscnY5bDQrSFR2NUR6?=
 =?utf-8?B?MERhZG1wdThBcHZZNUYrdE5WMmx6YmdjSm94S09pWnQyWkxMaDIyaHB1NS9C?=
 =?utf-8?B?QmpnMUdlRzdiS0lyRklMZWs1TkVGOEpJOXB1b3JHUFhIU3MvN0szTUQzZTFm?=
 =?utf-8?B?WUNiV3o3LzRNcGZWY3JXNXZwWC9laU1LM0EydW1ocjlZcjI1c3M5ZjBJSjhq?=
 =?utf-8?B?NUVRTXo4UEwxNTBzdk5BNU5RL1kxaUdaOC9MbkNGT2lWODVqOHRwQmdQM3lz?=
 =?utf-8?B?VXdLV1IzMGN6U1RGaTZJK3loSGVIRkVkZEZYODdxb1lpeS91MVFWYmxWZ3FH?=
 =?utf-8?B?Yk5lQWdLWEhaTkdVSUpCNVhZSERKbFdqYkh3ZmNIUDRpbTBsTVNEYlZ5aHRu?=
 =?utf-8?B?aXdKNHMxeFFNTnNMSG03cUFCRDZlQlh5VzZ5d3BMN2ZVcUxqbGJ4V2ZZc1Jh?=
 =?utf-8?B?ZmJ0WlZKNkNhV0djWmU5MklCeFFFZEdJME5DUGsxT0pqeEJVcC9ibUl0cXI1?=
 =?utf-8?B?OVhJajNTLzh4a3lmUGJRMlFlU2NCOWhxWE1TOVk5UEhUTFJYaG5tbnBOTFls?=
 =?utf-8?B?aURZdW9tOUxPcTV0RERnZytGTWcrVjQ1ZGgxY3pzZ1J6cVVsTjNLNkxma1V6?=
 =?utf-8?B?OUNWMmxNblNjOGR1aFNPcnFoQkthWjljMDkvUndLYmRDMlNFQkpialR2NmdX?=
 =?utf-8?B?OHY1ckJXUEd6WUJrQlZTMTVGKzQxSUZRS0xwQXB5RktwN3lwNXY1SzI0UTRD?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d64a0db2-0015-4e14-37c9-08ddf01bb3e5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 03:39:53.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOOA9ECSSnZG9TN6DBkKpC/fehmvOfei8cA15xFMmUVCTD4A4AZsjcF7puvkyvbesDQOwnDQxVpsD4na0Q3iqn2UD7DiuhJlVz58TWKetdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF66B2E927F
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> The Intel Clearwater Forest CPU supports two RMID-based pmt feature

"pmt" -> "PMT"

> groups documented in the xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> and xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml files in the Intel PMT
> GIT repository here:

"GIT repository here:" -> "GIT repository [1]."

> 
> Link: https://github.com/intel/Intel-PMT

Move to end of tags and add reference:
	Link: https://github.com/intel/Intel-PMT # [1]

> 
> The offsets in MMIO space are arranged in groups for each RMID.

"The offsets" -> "The event counter offsets"?

> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY

To help understand the added XML_MMIO_SIZE() macro I think it will be
helpful to mention the status registers and add them in the above
depiction.

> 
> Define these events in the file system code and add the events
> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Code looks good to me.

Reinette

