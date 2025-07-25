Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF625F963
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486020; cv=fail; b=EEplt4CKowZvnJ5/3HFuz/0ryk5ryBJth9BOxgcgQes8da37lbd4B9yvl3bVlJ+UsPgmGnwBEvqQPo9dbQTAfjKTv2YSFXlvN/6BYrKWYc5O+T/v0BAnzYIQW7o3Ic15LKUOWgz5DqrTU03ctdw6A5R0r1749Jk++aXstkbc+ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486020; c=relaxed/simple;
	bh=EnVUuhwVrVRbk5yIheI0hU4wAcrVS8TV0I6q+xIY27g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gz9+JEbYdBiAmB0lHYfUP0Yfd5tusqx5X6TDf2TTnskYV+snAFYJSEGHdGhahOKnPCXRmrXVhBAEssV+kU5oqQfuF9Yq6TBLrQSAz689JRr4wGTWtxfNnO2Xcdzr0D7oYsnSr2Y/J53gLPEMWcMlwVzbBpX3PO/1/Cojs77D4Wg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEDf4Qz7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEDf4Qz7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486019; x=1785022019;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EnVUuhwVrVRbk5yIheI0hU4wAcrVS8TV0I6q+xIY27g=;
  b=dEDf4Qz71i6+qnFd2YK3nmHCBtaV0JdqW5fIbvcfdysl1ObYyE6pl2a6
   iwYwp4j5hxKxo11h6u9JxtCVwOu4VEW4svdU+aDvJkjvDAA6YwPqjOgB/
   G3f3CKAsLzX+hGA1a4WSpkYEsh6MRZqfF5d5p+gJMdor0XXp3SLopEcls
   t21+ntJJttK1WZmCPRoG+vWG2IpsidG61Iqex1A7NzWQujUj31VxHfYjR
   MmcRwqePqKH0PmEoJ+VtHLV2GU7sItgJ0kseo+gqmARpRWS/OU3QHRsv3
   aOGLcH/KwB+hJULBiDYuEUFHe/ZR0Fk/EQSa3TsLzBP257Gyub5ZtfAhv
   Q==;
X-CSE-ConnectionGUID: PuDdNwWbRQyffvDcUCAcCQ==
X-CSE-MsgGUID: 4BnImFpSSPm9doU8veSGXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="67177439"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="67177439"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:58 -0700
X-CSE-ConnectionGUID: X0zkkIguTEajAsrPDYC6dg==
X-CSE-MsgGUID: jFYlHIIFQkeqp/wVR++k4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161535916"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:26:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:57 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:26:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:26:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LB2YS84zDEs6Pu7OezV9bjyDVfoo/4ZBOylhtApDNOLzORAbfzBStETcKF4YMlRoyZKVGGmr7gFPvUDOTY15/bn7CDur5zlZSIP4tF40BOYMCShbVHC77BS+oxLi/NiD4UfOO6F5rNJYD2J+Rs0N1L8R4YVyOVjxuFC2rjnGdSYlaTdK2tVsPqvKuSf09YtnYJHZg6bcH26IhFjsxEQhIop6mcMXp+DlqFMIhzMZ/fYmzMzVJmmfqC3hjbYOqvS167XuWN86yhbWbVFA4xq1Y5Eg28LZPzGvW4Hj1+d71L7qf+pSHtZW6JlGJ+xzngOFzsKoszOajpO2jL6rlWyp2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kV9+FIX5vzlRl5tQSEjBeZcC25h61K4yaiPN7ngabgk=;
 b=yr2gQs3NsW67Jh3t/9i7xYB4jHTNGqKb069YtxDm7EQS/L5oqH4SwX7e48ZNPn5T3gGmrwBY5l3eGH7H5tLnmiwmE5PgV3sQ/Jl8pZqTqByTumBcTcnqSB+s22/MPy6HEtFDz8aOLpTqr7YpeCfg7Zoh5mbmZl+g7WyQLZU4CLyS7i3rCjjuiB3gE01J/hUV+7KwI6oYPLlgxgLk9REeEOznZAL5qam7rl7XzE1moPYnR8KNVDvPHswvRoGW9JaHOgeyvfAvnwD6JC0Y/7LbaXy9kVoAc3J9EuJfj2loEHIi17xugjvqsby8p9/jDYObsbfgYegzqaB/CYhSr1V22g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9419.namprd11.prod.outlook.com (2603:10b6:208:564::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:26:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:26:54 +0000
Message-ID: <442ad7d3-41b1-4cbf-8ed5-8aa58e3b1f07@intel.com>
Date: Fri, 25 Jul 2025 16:26:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/31] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: b8eb9b1d-66cd-4365-f05e-08ddcbd2bdea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q3NHRUtEcUVxTXZISXM4c1QzbGRCemNWY0RFRDNWekxZTTh6UDJvSzZ2THV4?=
 =?utf-8?B?TWhRZkVZV2o1amdRdGJsamxXcGU0M2Y3Mi9lR1E0VERoWDdoeG1LYnBKMnB6?=
 =?utf-8?B?ZWFLRXN5UlJ4cEY1QkVLTnc2Z1RUWVFqZ3BPU0tOZkpMeWJhRjVkKzVaWlQz?=
 =?utf-8?B?MTNVckpMRElQdVpyaUtRUWREajRhZmxRTElqRld1MVpvMU1za2xDOFRMZmEy?=
 =?utf-8?B?cm1KYjlYSkdNZ0NVUjhSeVBNK1BPVzNCanZoWWpYQ3hFWFlpQmtCL3Rpd0Yr?=
 =?utf-8?B?NitIOFg0dVM5UWp6ZDljWWNxaW5NdDc1UDRFU0IxaU53cmYvZGlTMXFOaUpU?=
 =?utf-8?B?OGpQenVpNHhRS0R3OVlyRHVZcHZ0NmY3UkZVeVljbjcxQzNsZTFmWkwrL2NG?=
 =?utf-8?B?VmtpNXc4ZEVxWEhJQUdhaVBDL3UxWlJ6WUY0MFRhK3hJcVQxMkVpcVBTM2Ri?=
 =?utf-8?B?QVFmSEc1SzFQa2VKMHRhUE5rRy9Tbkpyc015WFhPRVdFTGxLWnRUM1NiaFo1?=
 =?utf-8?B?QlhSMEhPbjdYSkZCQ2trUUtuZVVzSWxCdERQV3QweXhiMjdtTUYvcGpmTjNV?=
 =?utf-8?B?amVqNmVqNnpBL09CYndTalQwcjFCSVl2T1pDTHhNSktwVWZHZUlQdXo2QjE4?=
 =?utf-8?B?Y2RoNHAzUElkTEpCbnU3dThXbmZTYWhLQnVadHh4THNxVTU1alRiY0ZIRlc4?=
 =?utf-8?B?MGRsbG1pYVcvV1dBRVdncnhyTlRpMFJJejZ5K1hmRDg5NGc0WVYvTHE1ZFho?=
 =?utf-8?B?TzdvSkZuMUQzNWlBV3MvOGxSVkJpay9xci9mbXFxRitYUm5GUVNlNFZOLzgz?=
 =?utf-8?B?bHBMRmo4QWNvOUxhRXFuT0VPUEJwZ2RNYitlQi9sOUlXZnRZYW5Vbk9XZHk5?=
 =?utf-8?B?VGVOaFBWODNaN1BzZHk4UnV0dzlVNDk3V3I2bmNvRkw2dGRtSXVTSTZwMTJG?=
 =?utf-8?B?eXNnWXJONFM3cldoMmFNZ0ZreDdVOC96REdxU0cvMEZuS1p5ckErb2s5c09E?=
 =?utf-8?B?R2dNUWVVZmYyRUhhbDFxamdWWXkzK0xJNkRQc04yVTQxbktacjV1ODhwNis5?=
 =?utf-8?B?MHN6RDFiQjVkVFo0cTVJQlVIeHJVdjdzZ3BOb0c1QU10QjloOGlxWVNHSUZV?=
 =?utf-8?B?WFlJZ0NzTTR3K04yS1VmL1VHSGdvTGs4OWdtcWNBZDErOHlWSXNYZTlCVG9v?=
 =?utf-8?B?YVhyTUJlZlVnR1lYU09NWlFzQlA4YTArVkNpdkdCdE5lMU4xMi83aWxLbjB5?=
 =?utf-8?B?eTdXaU1RdUY5M1NKdzlqell0UjQ5ZzY1M1p1YkMybVc1NVdPMlFYS0cvODVM?=
 =?utf-8?B?cDQ3cllTeUdMOURqN3RqSzJvZFovUDNoRGIwM3p2Vm93VkVCTktWc2E2TWJj?=
 =?utf-8?B?UFVxSkI1Ny82VXJiMWxkMlpyQ3FTVStnWVplRkRjd1JxM2RVS0xoaGVNUGp1?=
 =?utf-8?B?SnJHVnRIbWZSamVkdjUzdUpoemZsMWIrb0RZMFh4aFZFUlJxNnJtZjM1aEs3?=
 =?utf-8?B?OWJzTUc2MGFJSGNTc0RPcEVjSVFvQWMyMWRYc25wU3NpK0xNc01veWowMCtZ?=
 =?utf-8?B?R3ZWemU3VHhNN1YxS1Q1Z1FqUUxyU1IzbE05UjVLL1luOWp1dVAxclNJUFdR?=
 =?utf-8?B?eEJOTWFUWWNhMW5zTVFURGJOclhOTjg2dkNWTitjdWxiUjdnbGt5TTRiMlBC?=
 =?utf-8?B?d3V2eXZoMjQxaUlMZlJsd1VqQXl4dytwcUFUQnM1RjJHQXN3aHFIc25XZVJJ?=
 =?utf-8?B?N1VIZHhVbEIvMjN5c0xpZTF1bEtDdEJ3UHM0eklrSkFwT1llWE1UblRtSy82?=
 =?utf-8?B?YlJwdUJiUGFTYW9DeWFhYkZjb2JFMEkweTlRL002aE1sWE5yeHBWQytOQkFy?=
 =?utf-8?B?TWxGUFNSZjN1Ym5MeEI1N0kvR3Z5eWtaR2VYTEpaZ3haeTU1M2RIelNOZnM2?=
 =?utf-8?B?MHkxN2JrclFjcXpVVW9pUEpMcklZakRDRjNLcGlHVzVlQXVHQTNaYSswU21y?=
 =?utf-8?B?RjNoamkzN0hRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2QzUmFzMENDbHhhREF2N2JHNERsRE5OZkxVSGRSbTlsOFMyQkJEVzdDNXFU?=
 =?utf-8?B?eVhwdGtVdUd0MUpTZ3MvcFJIMWJYektWbmE4QWFNSDdFYUluVFpTS2puZFZN?=
 =?utf-8?B?cHhFMGg0bGNESlJoSlV4TFJ2a0V4RXVkUzlwU2lDUDU4VnRpSnEyMXA2VklI?=
 =?utf-8?B?NmdpRFpVUXVhalc1aTNHVWxzYUkwT2JqVG9iR1k2YUs0Y2xWZThxcXBLTGZn?=
 =?utf-8?B?QWdrNmpJekNFNUNVUWRDaHdXVlhMd09RVTRqcHlWS09mam1NNXFNK25QSDVU?=
 =?utf-8?B?RndDRi85YlpGNEY3V0lTQXgrZ2grdjlJaFNtU2dOU3JXS0M4Z09Ic28zcVpo?=
 =?utf-8?B?SStLNXBMYldHVFoxWmlOSVczWkxvUTRsc3FXNlZHUUtaNjZrbEd5ejVSRHhV?=
 =?utf-8?B?OCtGR3B6c05EelA3SU9reUdmMUJhWWswM0tPdTY2VDJMTWJCa2ExZEQ0cDR4?=
 =?utf-8?B?SVdMVUo0VTRjbCtXYzBvVnpHUEtrZThiV1ZzMmxsbVlQNU9KSWZtQ3FnbSth?=
 =?utf-8?B?YnI4elVjS1VIblNoQTFmUm9GdGRFMHREMWZqN2lXNkIrRVFYOCtKUjF6SmdB?=
 =?utf-8?B?Y0VhYVgwWnBqbEVqNmRPTFJtZ1JoVUlCU2p1cXdLNlJLZXZ5azBKSUxMMEFw?=
 =?utf-8?B?NDZkVnZYWWFONmJrd29XWWpHaWV4aXc4Q0szVEs5TnVKV3Y1NGRyTkN3MnVV?=
 =?utf-8?B?bUhreENpNVBCNTBnOXNOeCtaZzFwSEJNUEJkMXZVWWpnOXlyeEVqOThnOFpW?=
 =?utf-8?B?RkRxRmlwK2o2a0NUTjM4VEJEWG56eEwwb0NrRkN0SVNIaFRJYmt4eC82VHRK?=
 =?utf-8?B?aVNMSDgyMGU2WGhrV0puVytTZDQrRkUwZnFNU0svV3I2QWhtcGFBNXhodmpL?=
 =?utf-8?B?Q0dIUEpoSkdqSWFwK3dvN1dCUEw2RzFqVzB4WjFBdlR0dGdQYzJzYmdkOWMz?=
 =?utf-8?B?Y1VuU1YwVXRlY0hEMngzUGtpR2RyVmkyM3BLSlYvU3RQUWJZU0ZyK2UwUGlk?=
 =?utf-8?B?Yk5qNzhiSGF5cHppeXhUTXM3OVFqTDB1a0lhRUtLajUxMkRlQWZmK0JNVkF2?=
 =?utf-8?B?Mm4wclgyL2hqUmNyMEdqWkRybHZBMXFVbWU0bE93R29PdEpSblBOV0V2MFp5?=
 =?utf-8?B?VEdQamVselI0cDVweVh6anVxNUtsVEFadXJTNjFYMlpGWlhXN3RKaUhaV210?=
 =?utf-8?B?cURFVTJ6NENHQkxrL1BYaUpQdDhZUHZwY3RnWU1aY2VTTFBhV1M5WWRWNmZH?=
 =?utf-8?B?ME44Ym4wa0lNMW9YTFMzK0dpVmdhNnU2YU5QbDZiL2s1N0MvNFdxK1VXZDNa?=
 =?utf-8?B?NVd0QWd1dWVqMEFnM29QMGFFSDNvK1NhZlpCVzlPU1FVWDJ6Z0t2OWk4RkZC?=
 =?utf-8?B?TjVWYm5DNHFwa0JxbzVDRkRiUXV4amo0cWxWcGVOamtkNUkwQlhxQitXVzBW?=
 =?utf-8?B?OFlUV2F1eUFJNFZYdjJzZXZUZityRFJrcUdvZEd3SEswQnZhZEkyQnhOU3Vo?=
 =?utf-8?B?WldaNlJBODFnM0FIeHdrSG9FeEV0UWx0NERXa29pdHlnS0poNzRHWlVBWjI1?=
 =?utf-8?B?VjJpblg4NkVqeHJJMVpmTG1JeTFsUkpPalIzRkVHUnlqRXpJS1ZrRXBidC9N?=
 =?utf-8?B?TEQ0TU1TZW1QcUVvWjQxVk82eU5TMHlkZFUxYnVZblJsby85MXBrSzFTSnhU?=
 =?utf-8?B?dUlMTllrbWJ1TUUxcGNsTlE0K2c4OCtidXNXOWQwVVBrYk9NS2hvOEp3ZEF5?=
 =?utf-8?B?S0lweWVLV0lRODNhQVpiMGZSQ2duUkI5NVlIdXNvbC9MT3JRU21FVEttdGs0?=
 =?utf-8?B?TE9DWk1RYUw3VlZmSEFTQnBJRVVFbzVrR1V3dml5UXNMWjB6RElBQmNoNWVH?=
 =?utf-8?B?V3Y1cXFKNnV6VU55M2RSRzR6dFhkT0dXZHhPdU1PelZLM0xENmxiVVRiT01x?=
 =?utf-8?B?R2w0SHd4UXRXZVNRVlNXL1VoMHBvengvRk91Y0REZ0hOS21hN0tlcDNjSEJK?=
 =?utf-8?B?Nmlza2twdmJxSHVsSGI4Y2NTdzR5cUg4Z0xXUzdXUEhnSzdDa29xbTNEbDNn?=
 =?utf-8?B?Q1RGSkVZa01aNlRqMmh4TGp3bHJDbDVxVnRUN0YxK1FKaGttaFd5SGE4VVJi?=
 =?utf-8?B?clNRNWFxaDFQY2dxVC9sTFIzdm82cm1DaThWM1E5dmo1d05PTDZHRHlhZTdw?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8eb9b1d-66cd-4365-f05e-08ddcbd2bdea
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:26:54.8138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POZxUgGtMdrbgxCPvaoTyoABVAk1jdWXNwDqMtiSQgJhrptf9n8LMVYTGgpBMiQwDFGC5v2HaPR8z63j9zUEsPc9Mz1KQdrsUC1rDRFn6Es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9419
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> All monitor functions are tied to the RDT_RESOURCE_L3 resource,
> so generic function names to setup and tear down domains makes sense.
> 
> With the arrival of monitor events tied to new domains associated with
> different resources it would be clearer if these functions are more
> accurately named.
> 
> Two groups of functions renamed here:
> 
> Functions that allocate/free architecture per-RMID MBM state information:
> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID MBM state information:
> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

This patch looks good to me. I also think the L3 renaming done as
part of patch #26 should rather move to this patch to keep the
renaming together and helping patch #26 to focus on one thing:
resctrl_mon_resource_init -> resctrl_mon_l3_resource_init()
resctrl_mon_resource_exit() -> resctrl_mon_l3_resource_exit()

Reinette
