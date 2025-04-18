Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE1E21B9C5
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 21:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745010865; cv=fail; b=H2kIiLCPzscGIab342NDBePped5F7hpBDQE4qKrze6AnVtYaircb4PKtts+SRN6irCzNEhkD1qpZ3WJMGpieX9SlpOdF6T/z/08nLofQ2WuwXM9KwKxRobw5KCFfH82GhpiXntvqkR3UQ8EPCItBZju2+IuDLt7gop3q0i7UnuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745010865; c=relaxed/simple;
	bh=dpa2Uc5ZL/TBk58PPM4Z0dWgk5vhPkzUdw5y7EF+ckA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TB8VNMWqZgUVRvzbFAVBVPgQk8ODZ5VvLy2Dzz72qRdpKF0FI5ZUHXW1i8W8B0y73zphBLgc0ADmRo3XlllpSeqShpuvvu5YEobARMgVFYVqKDed3zgp/cfqzmh5T94YDe7/0q75W/2rtH3+1m0ym5WwV1YvRzxT1EmrhkutHek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YGJIgaZR; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YGJIgaZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745010863; x=1776546863;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dpa2Uc5ZL/TBk58PPM4Z0dWgk5vhPkzUdw5y7EF+ckA=;
  b=YGJIgaZRkd/0tm8GOpAYFvM9DRnyLvYi8jgnDXb0zg+tZ3VRiPpt3R7V
   nIpCpWss1/sVXUXf6SJGuiePDfxTcfXBIpmqTK/PKKnOx2/VdwVMWk5qE
   zkT+pj0HZFvUH4n4sCcF8F4LPewUNvW9HxYBNFE0PKfAsxVQE3S/adK1H
   sax6HuB/Z1FnPV9LVlqlMgVJawnfdhP+AvdMayZa0m5/g5JDzJhMsnS2j
   AwwJXEzqP1wWtJLOwS2auLpotA+Q8BRy6l2TtOY78oU3fnpGnOHAn0Dk9
   uzJDDnu34Wj/4YMZRgCc+cUMZ4igobfyJLTGEV1hePKeIarLuJYS2aFK6
   g==;
X-CSE-ConnectionGUID: hQSMCfIIQWScRXNnhuwVvg==
X-CSE-MsgGUID: HufwCOt1QZqmTY0OLXEEMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="58012316"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="58012316"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:14:23 -0700
X-CSE-ConnectionGUID: usZrh6l6RMCDk3HCKnckiQ==
X-CSE-MsgGUID: A//ei8tWT4ysGeaAe0u51Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="131188898"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 14:14:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 14:14:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 14:14:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 14:14:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzfhop8FLcgmZHTpmqbxA6NDAvptw+02BDjnrGzF+6/vL2j3GZXhpyrffxmmRdUcCJAkrxK7WwNgbyAdfxe0DQgPtXL0FmWSfgjsaJzJjY5S5/zzTSg1Cj7pCfMzW+AVKcb4fu5l7ulp4/AkpYYq45XQh4zvdAAq9MQUe8Q9be1VGkDcE8LZq8UVavfj/NCOSFsJJbndWgnrlNucslpy96SLKtxvIJA0PcBDBIWRV7+3MXWFREMgSCGMZixAIqBbS3NUb+jN+NFNKG/oNTEh+/lxvB9JSI/AhIWv/j+vt7NzScSvtXrHJec40LFIvDoJsIeT2jYYq/miFFVhXcisEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SQenjUbG9IMGzPTENEUzkI0NgsAv2uZrdMiIxHfInU=;
 b=rWIseXIsU3Jnef93iyDL4NWClvjYYkf3m7bBDkWF/qvwUzXXe8DSkx/mPKsSm19X9j4S9MT5s+YJO3rg3RtK5ujrqwNEaZMyi5cYlfvGMKa3Bqe0+MsNDgzMGjGnfxmdVwYRlYRtAW+uge3R5FKJQ4e/irUivTBgsu4Lwj+Ms7z2MwuDveO4uQXFL7DvHZUX9PrlPghJQWYnLO9WlHXhS1OyLvnuFQmwf7cXqv/ZYwqIyj0dgZvIGviJDZsc8gRade9Ar5iw7qLbgmeqCkmZF6r8Ix8rOu4XKJO+PaygGitvZOxdNklAbCAalcIU/QGdFq1c90zH1BYVElIWEHEqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Fri, 18 Apr
 2025 21:14:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 21:14:20 +0000
Message-ID: <b71e7219-3441-43a1-a92f-7139dab9d81a@intel.com>
Date: Fri, 18 Apr 2025 14:13:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/26] fs/resctrl: Simplify allocation of mon_data
 structures
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0249.namprd03.prod.outlook.com
 (2603:10b6:303:b4::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 303fce08-a0b2-4cdf-86dc-08dd7ebdfc43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QnIzMTZoMGVJUkFSdmRTTHV6ZXNNMXJBS2tROUxrMElIT0NTb0xQN0ErSHF0?=
 =?utf-8?B?bjVVaUhLT0RYZkRJbklZdVpxajVhN1BCaU9sbytkRHNoSlJhSzR0bjV3akxs?=
 =?utf-8?B?VzVWcW4well1R3V4NS8xL21UTEhjQXZoRGQzdm9LbkM1Zm1FSmVyVEJFMWxU?=
 =?utf-8?B?c2lBU3l0VFJ2eWdic2JreWFYZDBjUWFMMzdOUWtjcklMQVpEUTIyNnk5V1V3?=
 =?utf-8?B?YkpQVjNNb3RKdldycjRGYVpTMVUvM09DeHYzKzhtcnRlN09DeTljOXRXMk9S?=
 =?utf-8?B?RmVlQnlTenZmaDBEa1B2RlNpbUViQWlvMVFHQXBwa3B1SHpRN2lQU0lhVm1r?=
 =?utf-8?B?N24xWG12UjNUbTFmakRlZ1p3V1dXbSs3Z2hlMTJNOGduS0NHOTRNOVZGRDNL?=
 =?utf-8?B?QmZ6QmNEZW4wR2FhaVBnbTBOVHhkN2k2b3JCb3FDNGZnWlBLTlFuT25CN291?=
 =?utf-8?B?V0ZTQmJYTmVseUhpSWhiUzZseHAreEFJRUd3Z0NqaktqRXNxTWk3cTBjdDBU?=
 =?utf-8?B?VWEwUTkvVEdaMmgvSmVwVkhoVHFPM0pvY3EvZ1ovcENjV0ZWMGxRNGJRR0hk?=
 =?utf-8?B?SGo3TEZuUFEzd3MzeGlmOUZ0L3hXUFVaS3oxdklCajlVNXZGSitwL1pHV3VW?=
 =?utf-8?B?U0dVdkVXMW81VW5pYjJRK3VzcC9hdDdWQy9KZ20weUNNTUNBK244YTNwNlZv?=
 =?utf-8?B?Nmg5aisxQUF1enRKblNkNlorZEdjbGZvbWxQMWJxbllRR3BhaWtiQ3NOV3By?=
 =?utf-8?B?am5UbTIxTWN6ZnZxV2JPSXM2a1BzWnNVdzZuVlNDNGpzMW9tTG5VOTAvd1hI?=
 =?utf-8?B?MG1mRjNuNGpJaGw0TU1ZUU5iMURxek1UaVp3VHhmVDdyaTFwKzhzZ2JSbloy?=
 =?utf-8?B?RHI2blR5cUxkaGh0WURBb1E5WHp4NXFUQk9kdkx6M0Y4cDlvT29xUzdpQmQ2?=
 =?utf-8?B?a2xjeWhyTWJIWjlXQkdtZjFMN2NPMk5yejJRdlVadnZJd0V3bURLVnRMUGFL?=
 =?utf-8?B?SG1OTlN5WXhOY3I2VWg4VCt1cENlVFhjei9MVE01cmZsWXRsTUhheTY3TmJh?=
 =?utf-8?B?TGM3SC9mejZENlFmSGRFc1hJZUFVVDVxWWtUK3U0OHB5WVNLZGpHUVBtVXZX?=
 =?utf-8?B?c2JaV3RuWFRFYmZvOUZxcEo4cTY3K0t6dTErSlhZVFN3aG9jeUxzMER1VDRr?=
 =?utf-8?B?eDdGazluQXpsaDBmMVZJRVZzY2gzU0RiWGdPb2R4U08rbFZ6NWhEYnkvT1dh?=
 =?utf-8?B?N3kwZjAxZUlTb1BVcExNQzBQOGY0VVJsTkFnc1lGeXI3MC9UQ3FhTFkvN2Zm?=
 =?utf-8?B?SndOVVVxRW10T29LS1NWL3hrS1luUFBCSmVRb2tuYTZoZEJvb05VUTFwWllF?=
 =?utf-8?B?dFdzN1MzWHFGNG1lazF0M2g0dXFtdUdxZDhIWHd0OHkzUWE2SlFPVENxd2tT?=
 =?utf-8?B?Sk43cUZwNEVuZHNpYkVxTlVjSUQ1cWJYUjBaUHd2QUNFenBDSFp0TXVXY1dB?=
 =?utf-8?B?MDJSMDd2N3FBb1VrQzBJUjg2TXBkWlVuQXE5S3B0STZEcUFKeHZiNHlkSmNC?=
 =?utf-8?B?K2hHUDdQNGNtdVQ2NndjWmJUNDQ1eWFvQTI2SUFJMVBLdEZ1OFFVNW1JWkxN?=
 =?utf-8?B?QnU4UDFTekxPZTdIaUE4L3dEOVQ5d0J6WkN5RmhUWVpDK0dMenJ3WlAyU0RK?=
 =?utf-8?B?bklRM2N1RnNPeGd5WmE4UVFMeEw2T0FDWHdwd2k4ZkZwamVMUHpNdkdqMDZO?=
 =?utf-8?B?QTF1SURuQzkvalM3M25qQ2JBT1dYaCtZaUx6OVBXM2FqTUJCbnF3UGFiVUl3?=
 =?utf-8?B?amNCYmxELzg4UlRVNWhKL2tWWmN2aTFNK3NZN1djKy9STS9DcnQzbXZiS2Jx?=
 =?utf-8?B?aWZuWHVXZGtZcFV0VlhFOEp6SWphTkxRNFYwNExnaVR6OUpnYld1b002U0VI?=
 =?utf-8?Q?kiyz9Nhz1hg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0xodmMxdGRtSk1KV2ZWaGxRNTI0TW5nY3RjMDBYcW5PYUk4T2YzRjJVenNs?=
 =?utf-8?B?ZlFxUTl6S0syUVhOTUZkaHYwT21sY0F6bzN5Q3p3UmRoTGhjeFVVVmFpNkEy?=
 =?utf-8?B?VmNTWkZkVENQczZBaWlvSm9XbmpYd2FaYmNFaTE5RE9lNmZ3VUErakJySjhE?=
 =?utf-8?B?cFkzVWJNMjFIZURGMklkenRwNkdSS2RUMTNKWmVIZUFVSWpCdjZWaFlQQUFH?=
 =?utf-8?B?MTF2a0REdkVKQjRWazFCU01WT2dMemkwQ2FMTGxXWkFqV09xbFVTcFU2bnpu?=
 =?utf-8?B?MERIaklMcndnaUdHS2IrbXo0SHBDaHN1czYzYlpOTkVpcXJBNy9YYUg5Tmxl?=
 =?utf-8?B?QndCT1Z0QStjL1VYSTMvNS96cnRWcnF0OGU5NzQrcDhXVERvb0VEUU51WlVl?=
 =?utf-8?B?K05kMkVuVW9hckpJeFNBQXJEMitYaTFIcU9YT0NLRkY0NTdFOUtOUTE5ODMy?=
 =?utf-8?B?TXRPOXREbVd0S3hJdWJUUldFVk1USGRZc1VnQU54clg4WUVWOVBkdjROaFZm?=
 =?utf-8?B?dGkyVVJITnF4cjJWWWQyVzRyYUN5aGxQNHRwaGZwQmcwZ1BwVDByUWtlQ2o1?=
 =?utf-8?B?K3BybC9ZeDhDYXRhangweXNVT2QvNXRTVlA2R0xEUmNiNWttRUhZaWVWaWIx?=
 =?utf-8?B?MVNlZ0tmUThSUGZLbHdJamRJM2t4VFhWK3VjdTd4WFBjbEl1b1FCV3NvSUZM?=
 =?utf-8?B?c1c0TWtsVnFjL3JEcC83TXBKMFp6MmpVNWVEN05WY1VkWVpTa2NqRkI2RXU4?=
 =?utf-8?B?em1TMkxZbU5Jbkc1bDNlc1NaZzBJeVVVTktvUTJtc2ZvMU1BNklWRkVpR1A2?=
 =?utf-8?B?KzZoRndkOVpnUFpiWGhyaGFCcnFmaTBPL29iT2d0L29ZTUVyK1pBQlZzckdp?=
 =?utf-8?B?UlNpTnplc3BORnBXbUFGa3ZRQ05xUVE5eXZiYXBkRTBzQXI3alFaVVEwR2or?=
 =?utf-8?B?MzRjRWlkZHk3QUsxaTFwMk9ueXFlanQ2OUdWbWVBcWlrcW40cFVmQXpjRjV0?=
 =?utf-8?B?TWJEd1BydmttRVFpcEFUTlRQLzRpcHhoT2IrZ3dmNTByQUEyeEUwbnRqRElj?=
 =?utf-8?B?Vzg2RnJrRW12WlZNcjNkRk12YUFHd0tMNmlYcW9abHZ6MFNiRjBBQXFDM01j?=
 =?utf-8?B?WUhEVkl6YmZtc3orQ0xtK2d2WkVFRXNyL0xBb0d0c3pMbk90ZmRsNlNEVnM0?=
 =?utf-8?B?KzNmNmpaa2d4eVlsNHd0R0o4WVQ5M2pNOWVqZ0NFUGE4eVNweWtPa3RnTjJT?=
 =?utf-8?B?Q3IvbVJxK3ZKSFJUdUlHZEh3VGZaUU9RTk15eWhwUHpsYTBhc1JTNEtoSDFC?=
 =?utf-8?B?UExDTzl6ZVJjaTdRWFQxTWs3b1htUG1WL3dWUmhxLzJUS1RnVG9icjZJMlpO?=
 =?utf-8?B?V0xZRVpyRllRSFBRaHQ5WTN2cEZDeURLMWtqclJoeitmODBESlNISngyYW4r?=
 =?utf-8?B?Q3B1elkvY1dmVWdncFRtZVJRSi9KQUEzaUVLcVhHQm9HaWlpYi9ZekhyOEhw?=
 =?utf-8?B?THRPVUNtZmhQVjQyeTdESjc2ZjhzTHdLRVordXpMRmhSbHZMY25UdDY0eDZs?=
 =?utf-8?B?WDZMWDcrNTk5RzNxaWJyY3ZnKzU1OStPazVsRlJYYzNwV3NOUzFoNHAvNW9W?=
 =?utf-8?B?YjIvZSt5TDRTSDRndG5yRjQxT2VjQnUyRTR4L3JhRVFyMHpYSHZKdDhXZWUv?=
 =?utf-8?B?dFo3V2dqYnNpbTlEV1ltRHV6VkIzQUZXUTZxOWFnU3lHWW1BdHBKbGFTbzJm?=
 =?utf-8?B?VUZ2SW9seEtTc085TzFxMERYTS9nWUw5ZVNCVTVUS3ZZMHZEMyt5Ui9uajhE?=
 =?utf-8?B?QXAzbUMyNUxTV25ZQ1lRUFR6Sy9qQUZlVkRnWnBOZjZVTmlMMTI5OWxYbVVs?=
 =?utf-8?B?eW9tTFdLVkVwV0NucFlobmhxZXVITFA3LzhvMHlRQ1QwcHk5cDZUdlZDbEc2?=
 =?utf-8?B?d2xTZ2YvcTFacG44WXpxejhwMktGNXJJY0czRGN4U0ZKcHRIcjl4MW0wOXdJ?=
 =?utf-8?B?L2ZVWU51eHIxeXp3Y2dKNDdvSE0wR1pzcWc5dmVDaUJ2WElpVVE5dHhZWEor?=
 =?utf-8?B?SUsxd2hQSmNUZThCQi95ZW44VVN5K1FPOGRaaG0xVUJ5MmNzOVNDcDlYSFhk?=
 =?utf-8?B?YnBWUlNSS1I1d1hGK2JQU2tiVWF2VlNlamxLeko1a05GNTlzUDVuNEY3Nlpp?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 303fce08-a0b2-4cdf-86dc-08dd7ebdfc43
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 21:14:20.4485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3r68xOiqV1MpHGEWKEIAdSTWsqryc9gYvh6TDvQW83h/fxSdh0j/luV16vXLCaJ2ZRnkCb9kdjODFEF3sMs9bYnkhvSJ3CD4UL6NXzDxWc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
...
> +	list_for_each_entry_safe(priv, tmp, &kn_priv_list, list) {
> +		kfree(priv);
> +		list_del(&priv->list);
>  	}
>  }
>  

Did not look through this patch in detail considering its other version in the
arch/fs split but this caught my eye. Order should be switched.

Reinette


