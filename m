Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245EF25FA0A
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486990; cv=fail; b=FiEKT7GnftE3fJbhIq0/CsVLR1AiVfQ3+pIBvqaoUH+zCp6tTctMLLgM4nIyBDjZgJrTYFWlTxpNVQcwNnhACS4yVTw0S/lTlMpagbnBKn4Vo1Fh/+Ey+AeWhzDjcMbZ7m8ZLEYFHmfN1W22aF8owYdpcMwGHsRNOf4FNVBUcHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486990; c=relaxed/simple;
	bh=4TiRyfHoecJ8LijIeA15dl8DXs7As23k2zBDYgiqjpw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IQN1LGmUJpiS056y92CWN9iBPyAv6J5Yfc5fdRGyThMqwKnnLSGcj7JMwYv6075FPQ/eypGDek4ejBDUwnZpHTN/MomL6h4wJ33U+MHvP98oqNSOsJt2XjspmSlfBLBGIjhutPDTjvNjnJdrMWyO44iYeikKMX1J+KQXUQ9qlhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nSFIwZGq; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nSFIwZGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486989; x=1785022989;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4TiRyfHoecJ8LijIeA15dl8DXs7As23k2zBDYgiqjpw=;
  b=nSFIwZGq/98qhODXph65c2NBovGm9OmmpwpF5M/nMtq89CoJ2anpXJuv
   8k/7GPOXwTGU8SZs2sNF8hS+UrEc2YuQjWUBxYqp7N3U8xFFKi8BfGhWy
   sPP9vgUDqEs7PBYVO754ClVTdJWVEabbgnFMG1mlhQdagGOtWPwWOHmd4
   KFKJaeUI6qme64YlWVM3CwCp91vi7sB6MlWqGSNmQa4zPv2UQeXBlW/D/
   RzB2DmTuiYWB7K6geZG+f9GD5xyIl180x8RyPRiftalAzkvuzr4bbA79i
   GHs9TL8x9Xqs9zIelCYDx87Q/SgOAhqO7z6aAMsUAPkw8SFWErBZ+E1Al
   g==;
X-CSE-ConnectionGUID: +Zu0b9ZSR6SjgJjXIQRsfA==
X-CSE-MsgGUID: 8IAz4qmFQFSLTVS2HT4yQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55039630"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55039630"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:43:08 -0700
X-CSE-ConnectionGUID: g0vW/dX4Q+23VcsVCQBTZQ==
X-CSE-MsgGUID: aYOo2JYwRTyY52+FvkmCYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165697330"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:43:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:43:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:43:08 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.46)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:43:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dj3QDwLCOABPFTZ12PRJkozVj3AqLGcSklE0TH1FiFrmomq5xU/z9PBYld3JkVVhgrjBppj8VpF469+PB2qhCJIiJMIIB/V4hankxAERIlMtz8Kp1Rn2M5BC08MpTYxyQ/sSW/xAj3myqhOOGTQVktAo+DGy9PkJf7QqZkJ7yuypPhzdxtaNcI+KbhtYiAFavSV3wLamtOccOjiu3coXjgnVAm4gr33L3pYLDaf6X4HpMS4NkZIQWcKJFJL8O0Z6DqY9psTXFRi/DRt0PThasTKElBUcKORaBMHyrGOvlItFFzWfFdAPb7vTaO5kJ/CEIfM/PYT1LCLo1WCxuuGbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9vT2poZPgiIJfDeGS90P74OXd6JfUMXGR85K7PJHhA=;
 b=XKbry2qSJZbfKjttp3juD2Kex1XoVo6Nyob90va3vaiWD4xKRDUu8sbwUR4NXX6S5BjtvBMzY7hh0IltMYGIUj92fJCZyYgDfZ4/4OxUgVn12uxhg68dnGeTrSvHZyZ96qN+3wWrhASVdfPh89valzqHAXB/GzwevHtC0PSMde1oVtTtAsUIl0sAL5f+K/eYg79EIrvoRzzs07bymh+6roSA3uqSLA4e/6bt+zkUhDJ2AHh/W90zoM6dTD2Ox1an5sjf1BGH8zictM4yc47mB6q79F8mnHlpFiPUm4iHFp0t/EWMAemLO19cIJ279Kp/6Q6b9H0rF5EqMcmqr0Mt2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:43:06 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:43:06 +0000
Message-ID: <d3b7c22f-4435-42da-9e8a-90f86d64dbf1@intel.com>
Date: Fri, 25 Jul 2025 16:43:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/31] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-21-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0325.namprd04.prod.outlook.com
 (2603:10b6:303:82::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ab958b-6b87-4c7b-9741-08ddcbd500da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bWVqYnN2SmVhTUxxNnhETjBuQko5QkF4aXUrZkREa2RNbGJOOHFFRzlyZ2JN?=
 =?utf-8?B?cGRqT2t1WGNoUEsvTEI3dHFoWitrVXZmdGt4d2c3bEg0Yy9uZHR5Q2Y0SUNI?=
 =?utf-8?B?TEVNMHk0dTF3b3JNaEVUeXdzblVZWnZzQ3VqcVpuYTU2emc3S2EwalhMNjNT?=
 =?utf-8?B?V3JLT05hallsR3pJbWRYdTF0TjlXOEJRVnhiaWVFcG5Qb0dFOEl5LzZnOE5v?=
 =?utf-8?B?U1JGQkI0dlQ0MGpwNFk3cGZnV0dyS0tpTzlyandkT0lXSnY5cDlrRVJObHNJ?=
 =?utf-8?B?djBDaXJkZm5JOHFKenFLcHhZQ1g2bVB1Uy84RmdONS94YnZWUUlWaVZhSU1y?=
 =?utf-8?B?NWh5bHBHNXh5REphbUg0b0dXV2JjQlpuWGtNY1FzRDJyZE1nRVRsczJ1VU9X?=
 =?utf-8?B?VDFOZGMyQnlDVERpVDZyNkRONVgrNVZialYrTkE0WHpmRUJiMDlXbThJSTlJ?=
 =?utf-8?B?alRhamNFd0RpRXZhSm5XVVRuVTZXM0JiSXlyek9lejJRUkZEdXI3bTEwb0N2?=
 =?utf-8?B?NUxPeW9kaW1uYWtGTkgyTGNJNTMrbjFCekpEcE12cHg5SFZoRDVLd3dXSGVZ?=
 =?utf-8?B?OS8veHpaZmFIWHI5K0huclhKTzNkdTB3SjlhT2lXTDFmRVRFQU5vekJVOGsw?=
 =?utf-8?B?WExQNXR6RE40QzlVTkxya3ZXZEs0MGY0UjEwN01xZ3UzVjVXZWMzM0JneWxH?=
 =?utf-8?B?a2FIQkZwM2J5Tk5ZcDNZd3dtOXFKcTR2SUpiVkthRjhXeW1OTFJqWU9EbXRI?=
 =?utf-8?B?dEU1K2x3RlZuQXB4aTFNRVlWQTA2QWszdDR5bGFNQ1BXVFg0MG5SbHNTZVRV?=
 =?utf-8?B?cWMwMmJIS1IvbUdMalN6NTZiazlFRFZnRHhzaUxUWDYrZGNSYnNZOWs0bTJP?=
 =?utf-8?B?c3FhS1pkZVdlckk0Skg3UmZnTHNQY3NlTW9PS3k4MzIrelhkUGRINXZqbFVF?=
 =?utf-8?B?enFYV2h4bHZRQ01vd3ZtNXl4RmVENnNDL1I3OEVqTkVwS29FVjJwclFXTUVt?=
 =?utf-8?B?T1JZNnRPVllSZDJFRnNwT0d3dC9WK0RGZ1NVYWNBb0hMZ1ZLV0wyZXJPRHhQ?=
 =?utf-8?B?SjFKMmI5NWxXK0tSbFA3bHR0MHlobU9qZmRVOWNYd0ZGT29mVEtMM0VISzNy?=
 =?utf-8?B?VTc1aFN5a1NGK2U2OWUxcmVrL3JKMklDTVJVeE9vT0RRRDFOY2pObHBEU1Nz?=
 =?utf-8?B?OURORTgwL1VUVnlDZFFOZFBmNm1oOWdLRnQxNkY3V1M3d2R6T3ZreXI2Mk5C?=
 =?utf-8?B?eFhUUWNLRW9TTWNkWHh6K3dVMGpzTUVNS21SWkRIWmJLb05laE1DWkdNMWtK?=
 =?utf-8?B?di9CaVp2bG5BNTNkYnd0SzNTRFNpZ0Vwd3MvSDBobWN2WXBYSU56ZlR4bnho?=
 =?utf-8?B?QlY0eWNYWUxOeWlEOTA5T3RkamlKREhGZ0llNm4xVjFYRG43VHhla0Y4MVdH?=
 =?utf-8?B?RmJRc0dYQzRhV0JpNCs0eFY5RjJ2eWh1Mkhjd1hWVE0xWTU0dVhYTW9mN2xG?=
 =?utf-8?B?cWxHamM1dHM4M0VyYTAxVmN3ZTI1aWZ3Wk5ySGQxZS9RNDJ4NDhwUGk4R3RY?=
 =?utf-8?B?SWpEMUdPMGFjUTRBQkZOcmkxQ1ZWVlBxYnEwUGdKNlhuTzBJVDN6cFJnVk1i?=
 =?utf-8?B?MTFVMGpRWnk3OHpYZXUwNWpGS1RZeEd0TW9TT0pBcnlTOGsxUkU5Tjd3dThY?=
 =?utf-8?B?dnJjT29kVnRqWXRFZlpMU0U0dWtoSGhhWFM1SldUbTZGTHBkazk5S01zeGVO?=
 =?utf-8?B?WUt4NWRkSS9aeTBJZnZBa1ZmTkJzKysrWnhkTDhFMHZQc0E5bEYyYTNTV05l?=
 =?utf-8?B?QWU2S0I0V1doVS8rWmZIMUdmQU94UHU0cy9ONGpnSFBNTlRVOVRkL1Z6T1NW?=
 =?utf-8?B?VlF2Yk5hZzcxUEo0ZjJ5NXVscTdYc2s2aUsrQ1Q3U1dpQVk3WHcrVUZBTk5X?=
 =?utf-8?Q?4QF9GN87/sA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU9HM2tHTXdUVytFQll6WWdnMTZLUTMra2loTGV4NXB0Qi9laktkMnFhY3A2?=
 =?utf-8?B?Wk9GMXlTMWJKcTAwRnVlWkZHajdULzAyc2todDQxSmlBSmJnUTQzamprYmVR?=
 =?utf-8?B?ZGtDbmQ0YUFpK01kdys1cTVnUkp0OHU5NnR0M0tLZDhQTFpsNXJVdWR0KzI3?=
 =?utf-8?B?ZWluUWtPRDVSQWhidlBJUXFKWHdwNUFZK3NrSERxa3U4eldmTVA4NkJMWG9v?=
 =?utf-8?B?bW9JK1VhSGIrNWFVVWJWVVpUVVQ4VU0xUVlJRzJMVzhSUzNvbDk0SGRNVEo4?=
 =?utf-8?B?d29NaTUzSXljdXBjbmtsNFphMEZ0V2xhWFBodWNKdkNGZnY2SlpWMlJheVVs?=
 =?utf-8?B?RXN6RWJtRUhXY2w5UXZnbmRpSzlCeE9LV0NaM1Aza3BBc0Jjang5YjBQODdi?=
 =?utf-8?B?QmVoSzBjVlh0aVJaQlRZYVRrbDF2M3dPT1dkOThGSmU4ZlluSkM4K3ZReHIx?=
 =?utf-8?B?UWRTRU1kWThGb2NkR3N6MERPS3oydDhiSjBQOXlJZk9GdnNiUTZzaGRwYU8r?=
 =?utf-8?B?aU5jUHZDRjVMd2dtdlhlaHJUNWp1MngyK1BXYm9JL0pQRFhIRHhLb0hsTVFo?=
 =?utf-8?B?NW14OWl2VXd1QXdQeG1DTVpBVTBGWllzbVFoa2l4bjBOYTFNamg0aUZuUzdp?=
 =?utf-8?B?ai92N0srbXNId2h3T0I3citCZWVjMmdzRkhVUjk4WDFXU3FHRi9nVmR6R2N1?=
 =?utf-8?B?ZFRIWVNMSFllaW8xRjN2QktZbjNENnB5M2FIUTVEanAvRmtQQTc5U29LTG1M?=
 =?utf-8?B?ZkJDSStSclZTQkU1czVIZlRMajM4NVlOdzkxK3gwTzhKVSt6SmwybGwvVjJ6?=
 =?utf-8?B?RFhWZFhoa0xBS2kyOVVUY0JRMDZmcEUxUmxtVDljTDhaMU1rMDNHZ3NWTmh1?=
 =?utf-8?B?aThXZWc5aC9xRktSMTh6c3VleGZ4YjcwdUZHemRFcGtDZzVLL2o5a0R6Vlgv?=
 =?utf-8?B?bTI1ZkdwbzczK0ZOVm54R2xWcDZPRmpXK3diR3Q1bytnM3U3NmRSQUVmVWNF?=
 =?utf-8?B?WFFGbjZ6SWtFdDExTnpZVlNRdlRmYzA3NllWMXA0MnI0blZ3UUVheTJ1bXNq?=
 =?utf-8?B?b2pYK0t5WmYzYWYyT09DTC92UDJsTXNRT2lnV1BRNWEwOFRrRlpMWWFQRm56?=
 =?utf-8?B?ZDdNd0xPYzNuNFRpNC82enlWd0k4Q0FiT2d6dnM5RGEreEdHdmVYellTQ0dy?=
 =?utf-8?B?NkZPMVdQeFdXYUUwbTFxR05MaGhhUDduZmVSdlpPU3R0OXhnVDloMHZOenF1?=
 =?utf-8?B?TmRDNkxWVGlQZ2NpZVhzQWQ3MFNmK0Vlb3g2clZzNXRYTHpGeDljRk9icUxQ?=
 =?utf-8?B?bSt2Qzg3aFJxZW1Nc3c5UEE3eHFQRmdQNVlDSFQ5K1BYN2JQS0c1bnBtenMy?=
 =?utf-8?B?TFZZUUJZUzlTQUFsdXcrZDVmYjRUVUUxU2IweHVQaytndDR2RlJXcVJPZnA3?=
 =?utf-8?B?b3c5bEgvSGtpWmtjOXhvZ2NrQk8yVUoxbG5nWGRJQ3BBQ1kwaWFUUmlEQTdy?=
 =?utf-8?B?N1JvK1h5TkVURFh2eFBxUktNNXE5VDMwQWFZWlN3ZlFSSmw4ZEpmTmlabjJY?=
 =?utf-8?B?cDQxU0VnVGxYUVpkTjM0bXFBQjYxTm5aWFlScTZpNWZRd2Z6N20vSWd3M0d0?=
 =?utf-8?B?dTZQUjRkeCtrczJNaDNFUnpjUHNZT2lONm9MWnBzVUtXZWZQWE9hSjFBTWlG?=
 =?utf-8?B?enBidFdhMk1wcGVpdUkrbWNlMFBhdTMwcjcyTkZhSnY0WWdXdEszQ1NLUGlk?=
 =?utf-8?B?UDlPV0tZcHRrSGI4dHNqV24ycGZCVUl0S2RhT3g0ZVA3QlFQODA3QXdUMzRG?=
 =?utf-8?B?RFZzdWRMY3JDRHNHMktkK1lyK3pxbjhjYy9hb3NHeWpQSUFYR1pxOUY2Ky8w?=
 =?utf-8?B?a0YrY1c2YVVnRExWcEpzTXllSU5CNmFxV3VYMllvckhyQU9PQ3kwdEdhNmVJ?=
 =?utf-8?B?VVhSem5wMHlvQUh1S1lzMHdSb2RoVUw3eEJxWlRkeXNjSGVpd0pRV2V0RXYw?=
 =?utf-8?B?RGUrYXk2UEdobUtiVTNZcTgwaERQbWVaWk55MEF3WkNRak1Hcjc2bzBlNyt0?=
 =?utf-8?B?bmUvcVA4d2I1UkJMQnFpQjMwSVBReUVBa3pqY3hQL1pxWUluNmdQTEFHR3dl?=
 =?utf-8?B?S0JpMWo1Y1gxMTN2UkF4ZkMrL0lLSTBnMUMwZUs0Q3lSNGd3d3dud2NDK3Vn?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ab958b-6b87-4c7b-9741-08ddcbd500da
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:43:06.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xqQqyF0ani10Qz3mTJYNbVyH7UXavs1iGQmObN77/hOCou3Xxq9oBJaH2Drd1kcZ89NKbMdHm15RCSXZTssfImIxtJnoevYtxQFmhWAkKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> These two guids describe the events supported on Clearwater Forest.
> 
> The offsets in MMIO space are arranged in groups for each RMID.
> 
> E.g the "energy counters for guid 0x26696143 are arranged like this:

Missing end-quote.

> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> Define these events in the file system code and add the events
> to the event_group structures.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl_types.h           | 11 ++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 35 +++++++++++++++++++++++++
>  fs/resctrl/monitor.c                    | 35 ++++++++++++++-----------
>  3 files changed, 66 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index d98351663c2c..6838b02d5ca3 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,6 +47,17 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>  	/* Must be the last */
>  	QOS_NUM_EVENTS,
>  };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 3f383f0a9d08..f4bf0f2ccf26 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -32,6 +32,20 @@ struct pkg_mmio_info {
>  	void __iomem	*addrs[] __counted_by(num_regions);
>  };
>  
> +/**
> + * struct pmt_event - Telemetry event.
> + * @id:		Resctrl event id.
> + * @idx:	Counter index within each per-RMID block of counters.
> + * @bin_bits:	Zero for integer valued events, else number bits in fixed-point.

Is this obvious which part of fixed-point this refers to? Compare with, for example,
"else number of bits in fraction part of fixed-point"?

> + */
> +struct pmt_event {
> +	enum resctrl_event_id	id;
> +	unsigned int		idx;
> +	unsigned int		bin_bits;
> +};
> +

...

> @@ -178,6 +211,8 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  	}
>  	e->pkginfo = no_free_ptr(pkginfo);
>  
> +	list_add(&e->list, &active_event_groups);
> +

Stray change?
I have not seen any changelog mention active_event_groups and how it is used.

Reinette
