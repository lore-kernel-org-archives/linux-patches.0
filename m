Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894A1E7C16
	for <patches@lists.linux.dev>; Sat, 10 May 2025 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746871132; cv=fail; b=rYySIVR8dVrkq7NY2LN5eUDGnTunnIUOqZtjOCGBXBj8NZLldbXSMA27PHAnKUGI7DII/RTNdlrGdjMdPcnzY69gqV/AUfH6rVqgPgBGKUaMhIrZO6qRDRRvu5tFvHnYM2nG3WdNfyCdr4JvwlZA8Bh4ylcbJvtmwQi3MShqkCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746871132; c=relaxed/simple;
	bh=AAdPnkJDt6p4xiEI5++AskY+gHXEoeEyaiHhlzB5Yo0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C+B9DY0PPWVoGxuD/jwdK/+TSDEJ5w+hQVmkZDB8kMZX3Kn6TYiJy0En4y3gHWhhTB7+IlDrmi+NtaAq6hBu+pMfurnbgcOdjmGnnWsV09YwF+l13QySf1yADrSBXFGYABEFP24HHkljWzWbnmLCuduvL02RUp5V0isp6jcO3G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ABA2/lKk; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABA2/lKk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746871131; x=1778407131;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AAdPnkJDt6p4xiEI5++AskY+gHXEoeEyaiHhlzB5Yo0=;
  b=ABA2/lKkCLAAv+eHoeQssgYSk8WNpayj+vw1q9umQ6ys7cxmlOV1/LaH
   WJ8BLjwHcwk2gSqqT//nWDjXCGp9WbhHzwk0bT8iskZfHJuyQHjFUAufT
   ahQNc/y6vR+svdin3AXKT/KuTzpFjV5LheSasc9GaXMX7ywYb8PByrbzH
   hBsIZ2CHmtU88dkb1D2otgkcQdT4Hnf8xa4ctq66k0Q0VzpJ05hXyAzfN
   f7n4766rjYnXnWtLKfGmgni9EDNuAiogRwzfqCuLNgCSf6ljRGg1z/+Qu
   I6bqkKR0y8/s6ObD07p7PSGZmpclESQfu5ZJE7wT1CSuq0nHM8Hj990WX
   A==;
X-CSE-ConnectionGUID: IwcrdyfVRJ2psP68lLgnxQ==
X-CSE-MsgGUID: Tp4y8vdbQAuoTOD0LWScvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52510026"
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="52510026"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 02:58:50 -0700
X-CSE-ConnectionGUID: wkg7lU/yQAKEOW8mZf0oxw==
X-CSE-MsgGUID: LaHW97kfSOeHK5VFZmW80A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,276,1739865600"; 
   d="scan'208";a="136730585"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2025 02:58:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sat, 10 May 2025 02:58:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sat, 10 May 2025 02:58:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sat, 10 May 2025 02:58:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fcymXagPbUbc5Z33Hjr+SbDtG9q2o6rttJHnZupcNkA055s7Dbo1CrTH4n9g5e1Ow9mKvP7aooCQgvSccf6kiou//PEbM3IapyvFAx4os7GmeUtIpPIgSdqC67X76wrKwMdEEXxvpcQiWWTRJVqNW/h5elf71MWIw5rvgwyIxlZgLYoG3Ca7cfhEk9OgItnOdu2tWPYdrTXDuxHV+DzjGAxra5BFIufeQSA1KybGUoF3IcQslebaYfG/euKavYdSR0ao53Kg8Kg16Mc2oCIF6kpBv+6dlxY1NSfopdaXQXxhNsu3Q5POB+LW+U+BsBNBxk94TofDICQZ8sY0nLJPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GkVxcJLPKEfpFxUtRvtgNHhFxhfJpVi8BkUQoExgZI=;
 b=Xi552XWqvVw2T4LWNg9QmeaTWM0xXsbU3qCxec/D5z0Ekblt+fPt0zDhLPXO57QrjPnPxkPwb23iIVhSOw6EBHks7z3Z7iwZC/ag9A0YFGTQIxPDBbnGHqNJtnhmPI1pnj5/1Rb6YkDkQHCpEbqR7V19w5bkwmswMgcWeZbUw6hXZ7lAuYqnaTlcarhReb+Jk/VTLwjFpaAm1057y5Thmqo+96gjhP4uF8/HMtNQixxIr0jHJgtrXZhkQWc8KRI4RUfnjCi3TMzilbR+Btls611kW3X5ZIASEgBEOxFJteRLWsUQe4jYIxVh3vcWu8Jfg8xyssNWLTr/mIWeRC2Eew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DS0PR11MB7879.namprd11.prod.outlook.com (2603:10b6:8:f7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.21; Sat, 10 May 2025 09:58:47 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::4af6:d44e:b6b0:fdce%6]) with mapi id 15.20.8722.027; Sat, 10 May 2025
 09:58:47 +0000
Message-ID: <621ff36f-eaa7-4dba-909a-e50977abf6dc@intel.com>
Date: Sat, 10 May 2025 17:58:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/31] fs/resctrl: Set up Kconfig options for telemetry
 events
To: Tony Luck <tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Peter Newman <peternewman@google.com>, James Morse
	<james.morse@arm.com>, Dave Martin <Dave.Martin@arm.com>, Babu Moger
	<babu.moger@amd.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Drew Fustini <dfustini@baylibre.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-6-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20250429003359.375508-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU0P306CA0078.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::10) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DS0PR11MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: b763fed4-dfe4-4697-64e3-08dd8fa94168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnhDWXFXRzRLRmVqaHRBZU1Pc0xCWEZ1WXdlckpnR21VTDhqNU5zeERnRWJp?=
 =?utf-8?B?Skw3L2xXa0Z1U0QrWjRWNFBTRzViYWdOSkkwbzJyL2FncDExZzl6SldGQXU2?=
 =?utf-8?B?cG11LzNCYmZXak5Nc1pkNWMxR3Z5bVhTeUR1dTBLWUg1VGtIejI4NXpXZ05h?=
 =?utf-8?B?WTJnNnIrVXBoK29pUkIvS0s0MHVwcTR0SjZiaGtrajlPRnRoNjdGcms4MXgy?=
 =?utf-8?B?eE5wZVhCMkFnSXlSN2J6V09Hd3Y1Ym1IN0F0YXUyOFhEdjBuS0IrcEdBV2Z1?=
 =?utf-8?B?akdHZlFjUFRnR1FJREdxU29PaEZaSHJ2MHJFUlMvS1BzdCtRaUpaZ1Z2QkFj?=
 =?utf-8?B?c25MNGV1SHM3TVZ2ayt3T3JSTnVJUDE2ZEJrZnByc2FxYi8wYUNwRzdBQkVm?=
 =?utf-8?B?ZkkvU3VtZVlKcnV5bGVhUk82YTVSUDZrOWZKSEt0eURyc2p2amJFNXNTTVZy?=
 =?utf-8?B?UmpuVUFvaTVuRzN1ZkdtR0R0VU5sZWNHMjRMYWVpSHlyREdTY3pLVC9IVm9p?=
 =?utf-8?B?WGp5dktUN3ZCOEZHaW5zMUZoc3l1eUdVK1RndWo4N1hEeHdRcXpzRkcvRVZB?=
 =?utf-8?B?TmZPNzJXTDRrVnNJQW1KQVJvTkRHeklrWldvZnQvaU1WRnMvUThVNlRWYmtG?=
 =?utf-8?B?ZnJTVTBPVXI4cFNZNkRBajRSb0VTT1pyb2toanRMa0g5c1pZVVRKU095a1RG?=
 =?utf-8?B?NEExeXQrNWJ5ZmM1cCs4Um9pOEpONm1jY0tSdjNRNmxqZzRsVk8zdTVYL2JT?=
 =?utf-8?B?R05VZXFYSHc2RjhyaFFoa3FIT0ZWWWEwMFFPNkd4blhER1RXTTBMbEtNREhT?=
 =?utf-8?B?VDlnMFRWdWI1ODNyS1BwWEQvenBxKzMwc2VlSFdDMng0cVhZTFhzWFRWd3NC?=
 =?utf-8?B?WjZEdXhkUi9YN1NkdW5zWG42WlFjSzhyblZheEVxS0lXNXI3eDhBbm1ldklL?=
 =?utf-8?B?T1ZFdmlGRjVObmJKSXpUMUJaZ0gyaGlZNkNRNk9tamtqWmhMcUJPUUlMT2Z1?=
 =?utf-8?B?bitMeU5kWXBiL3JLSFVkeU4yWGFFWlpVVlR1Q1piTlcwOC90SWQ0UHZFTnpo?=
 =?utf-8?B?MzZOdVRad3FqUGZkMVNNc203Yzc0cld4Q1dDU2Zuc2t0RXgvRVQvWHFsRnA0?=
 =?utf-8?B?QTBQY3MxZDBoYmVPS3B0LzNWZzJrM09RZWlpSmttTkdXV0VMWlVWMEJiL2J2?=
 =?utf-8?B?OGdwbThKbGhxdG9EbHNHUWl4TFpIajR4V0JidGVqSnEzK2xXMFRJWDIzRTkx?=
 =?utf-8?B?NEtWa1ZaVG1USVIxY2o0aU85dUFDTWJpWnR0OHhjSDNVeHYyclRWaWw4UHpZ?=
 =?utf-8?B?RjdBQVZqc3VqTUxoL2laV0MvNEpEMWxaazVnRmluVFNpYmRyeEIwKzJGcG1t?=
 =?utf-8?B?SDFXaGo3b1dSaFpVaG00WXdKRGpMKzBOTXZFNlBQR24wZHpNQVZ3SDhzNjJE?=
 =?utf-8?B?dnhIM0JLSTV5MUVUSzFPaktMMEJkSEozc0FNVVNTZG5ZY1B1SFh6VnFsY0pS?=
 =?utf-8?B?MytERW5UTVpnK3k4c2RpY2JMU0Rpb3dZQWY3NDhvVVBvbTI5N21ISTZpSVJT?=
 =?utf-8?B?WUlkd1d2NWYzdytMcmxlRVRzS2RsOEowK2kzU2MzNGNmbXYxbTlpV3hLQTRW?=
 =?utf-8?B?NTlTM1lpVnhER1lvYVJSV3dNb0xxL0tLUk1MSUs1YzdKdnh3dG1uNFZIV1Fo?=
 =?utf-8?B?eDRJeVFuVHJpaHJsNlpXckZySmtjckVYNDZORVNaK3Jod2tkaUJNcEZGcXQ4?=
 =?utf-8?B?ZnRvdlVEc0w2dHZHamxzYzc4Q2p6aTQ0QytGUG1aelE0NVVLOUY1a0tBVnFD?=
 =?utf-8?B?NXlWTm9NaCt1RlYvYTlYTUdlSFRxWTN4RkpxL0VrODduQVJ2UFNPRHRwcVkw?=
 =?utf-8?B?S3M4ZmUrYVBESHdWRlhscEhtd2E0dHpXdmhRQjAxYTZyYTRNMzlGdFBVTWM4?=
 =?utf-8?Q?oZlOTdxwuGg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clRGb0JTMFJueXRPMEJEZk5HSTRmYWFtMGUrT1lYQUQ5SUM5TEhGY1g5eENo?=
 =?utf-8?B?bzVhNjgwS2kvdVZxR3lXa3NZRlVVNmRheWRPQURjZjlkODVlU1VhRjgwOGVi?=
 =?utf-8?B?SGJscVNnWlY2Tm5QSW9LZHRVN1h3UVhEMkZ0VHVCZk1RbHVESEZ0Q0lOUUhL?=
 =?utf-8?B?YUJ3dm1YR0FudmphMlNqa0FQSHhqSllGSDhBRUNTdlk5ZUNmSkhaVTVtOU9Q?=
 =?utf-8?B?VEh1ZXZXanYvcmdtU05GcUZlRThLYWJsVHJsaXE0bnlxMVIvMDgrZS9vSVh0?=
 =?utf-8?B?SUNxVWFnQzFUWHNwTjc4T01xZ2NsZ0NwOXROS3J6OEQ5eWhwMTduZmJNSXlF?=
 =?utf-8?B?U1krdVpTQU5uNXVCbFZ4dTB2ck1NUXVLUzNtcTZ3UkN2WmZmcFAzV2xZSjlT?=
 =?utf-8?B?OU5tOHExK3k0YjRhdklvd0hiL2xMcXZQTmpjczdjRG9sNDlhWVFQeVc2TW1V?=
 =?utf-8?B?UzBFOFRlMk5NNXo5MGM1N3N2U2hSb2pMdnN4Y2pMckVXbzBrMkYwUWNzK2FG?=
 =?utf-8?B?NDNxb2NDZVN6SFIzNHphNWZSSHQ3aFhWOHN4NzRkWnhyN09SdWUxU3JCaHRa?=
 =?utf-8?B?MW9jZVo0Q2VJV0hRNWIxYUtwSDdyRjBhTlBVa2JHY29tV01ZWVl5d2dYZzhq?=
 =?utf-8?B?TUtmU3dYMUFmNU1HalhocmZ3VVV5WGhiYUhXTVpIYjJFS1VZT2I5YnNQNEtl?=
 =?utf-8?B?V2hPSm92RFRhVGVEdDUxanZOaTJmR29tZVAwQlU5REVYcUk0cHovN0tTS3N6?=
 =?utf-8?B?QVV0VnJEd1NZK2dlYWEyb1A4ZVAzTWtvVUdVZ3U3aUFYVy8zQ2V0d1l6OWQ2?=
 =?utf-8?B?aWJxVFFTQXpGZytNazdPNDVaL2Fscno2NC8xaVRSbXpGbzViOS9hQWtJZ29G?=
 =?utf-8?B?SWRJYk4zRGt5N0lKQVhJVUZDbVlIWHN0cjlUWTkwank3a3dEMEVoZUU0cDFt?=
 =?utf-8?B?UGlTeXhiWTMvN2txcXV5TzM3QVpZUEZMUTJDZExtSkhjd01rY1VtaEJDeXBT?=
 =?utf-8?B?WG95TFhFTnd3SFV2Z00zeDFFNmZ6Ri9VUUVkR3pmSjdWL3ZLRnphMXU3dEhQ?=
 =?utf-8?B?WGoyeVljL1Mwc2QwYmRRZVlBa0dVUWJJQ0VDREtmQXVwa1BGSVJZbTBnNjJt?=
 =?utf-8?B?SmYwNnZZTUtVNXRBdFZBMmw4R1M1MkZkeWR6enBPRFpzMkNLcmRFUGl2b3ky?=
 =?utf-8?B?K1duWEVWYlFMYXh6VUZuSHV3Y09IZVluM1VyV0V2OGs5MDR5Q1VwTFQzcGh1?=
 =?utf-8?B?WHEzK1FDaHp2dGd5TlIzWUxReGdRelU1NU9obDJmZFZkaUp3dUpuYXhSbEhB?=
 =?utf-8?B?dzBhV2FPRVhyWXdFMS96MlcwY09DeFZjT2NwaWthc2NDUFNISzhmSEJaQzBn?=
 =?utf-8?B?dlVremVzb011Nm5GRkdLNU0vUnprY1lTWU54RXZqbzVQM0ROWEFJVkJyWnNW?=
 =?utf-8?B?TDBUK0o4R0RuWm5QaFhrK1E1bkZsZDgrUko3MWhkVWNpSUswb1lab29VSGZ5?=
 =?utf-8?B?SE4zamJ0Z1lkUGxBWkg2WlFicWh2b241aUxOV1V1ak1GU0VlQWFnM3N4cThY?=
 =?utf-8?B?dUFSK3pydlljL2t5UEEwQkdOWGdySWxIWHNFb3psclUrZnkvYnFxZDBMa3pK?=
 =?utf-8?B?T1R2SEM4azkybXIyYjdHQk5vQkN3a1F4aW9zMXZhejJ0RUNDWW5rZFhxZm1q?=
 =?utf-8?B?ZlBocDA1c3RObWFuUVh5cHN1VThhRHkrQ3ZuU2dXZDlSOEYwcCtYNk5xQi9x?=
 =?utf-8?B?ZTlFYzlTdnRqM0tqYWFwLzB1RWZLRWJUUi9DSmRWU0c3dC9vMTg0cUk5a3BN?=
 =?utf-8?B?bzJKa3BtVlFjVzdZVURVYVlXK3Z3dmJvZldRTlNYc3FQNXN5OGpTdVB6WW9h?=
 =?utf-8?B?dU1nRVpnczFrdGxETjRSOWJNSUwxYjJpN0dZTCtsQTgxKzBPMjFXa1RXODJY?=
 =?utf-8?B?THhvU0UxbHd4Wkx2TzU1ZHdYWStIWWg5RnUwWmdXNDlYR2dlSVNsTjYweHl5?=
 =?utf-8?B?UGdOZEkyQm52S3Z2aWZRS0NvSE9pd3NXdDRta0VOOGc1Y1N0b2l2bU9DeXRZ?=
 =?utf-8?B?aGYvVWk1di9SYmhYS3pCdkNWMHFEODdLdlFGRzBRbWRsTk12NVpISDVOSXo0?=
 =?utf-8?Q?jx8kCWNWDn6TpeHHcGk4mkruI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b763fed4-dfe4-4697-64e3-08dd8fa94168
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2025 09:58:46.9539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hR06Wk9RpmGMXo6d5GIEjc/Vds9/OAIMgyheh3Kfc1YYZ4MnjppztU6UDYqV9n9MUjRDejRwQ8v8vnJZPnH4bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7879
X-OriginatorOrg: intel.com

Hi Tony,

On 4/29/2025 8:33 AM, Tony Luck wrote:
> Intel RMID based telemetry events are counted by each CPU core
> and then aggregated by one or more per-socket micro controllers.
> Enumeration support is provided by the Intel PMT subsystem.
> 
> N.B. Patches for the Intel PMT system are still in progress.
> They will define an INTEL_PMT_DISCOVERY Kconfig symbol that
> will be one of the dependencies. This is commented out for
> now. Final version will include this dependency.
> 
> arch/x86 selects this option based on:
> 
> X86_64: Counter registers are in MMIO space. There is no readq()
> function on 32-bit. Emulation is possible with readl(), but there
> are races. Running 32-bit kernels on systems that support this
> feature seems pointless.
> 
> CPU_SUP_INTEL: It is an Intel specific feature.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/Kconfig                       | 1 +
>   drivers/platform/x86/intel/pmt/Kconfig | 7 +++++++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5a09acf41c8e..19107fdb4264 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -508,6 +508,7 @@ config X86_CPU_RESCTRL
>   	bool "x86 CPU resource control support"
>   	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>   	depends on MISC_FILESYSTEMS
> +	select INTEL_AET_RESCTRL if (X86_64 && CPU_SUP_INTEL)

Not sure if if it is expected, I got the following warning
during compiling:
WARNING: unmet direct dependencies detected for INTEL_AET_RESCTRL
   Depends on [n]: X86_PLATFORM_DEVICES [=y] && INTEL_PMT_TELEMETRY [=n]
   Selected by [y]:
   - X86_CPU_RESCTRL [=y] && X86 [=y] && (CPU_SUP_INTEL [=y] || 
CPU_SUP_AMD [=y]) && MISC_FILESYSTEMS [=y] && X86_64 [=y] && 
CPU_SUP_INTEL [=y]

I think this is because the INTEL_PMT_TELEMETRY is disabled.
Does it make sense to add the dependency of INTEL_PMT_TELEMETRY
to auto-select for INTEL_AET_RESCTRL?

select INTEL_AET_RESCTRL if (X86_64 && CPU_SUP_INTEL && INTEL_PMT_TELEMETRY)

thanks，
Chenyu

>   	select ARCH_HAS_CPU_RESCTRL
>   	select RESCTRL_FS
>   	select RESCTRL_FS_PSEUDO_LOCK
> diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
> index e916fc966221..3a8ce39d1004 100644
> --- a/drivers/platform/x86/intel/pmt/Kconfig
> +++ b/drivers/platform/x86/intel/pmt/Kconfig
> @@ -38,3 +38,10 @@ config INTEL_PMT_CRASHLOG
>   
>   	  To compile this driver as a module, choose M here: the module
>   	  will be called intel_pmt_crashlog.
> +
> +config INTEL_AET_RESCTRL
> +	depends on INTEL_PMT_TELEMETRY # && INTEL_PMT_DISCOVERY
> +	bool
> +	help
> +	  Architecture config should "select" this option to enable
> +	  support for RMID telemetry events in the resctrl file system.
