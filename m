Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828EE1C27
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759536373; cv=fail; b=b+zk455xD6WGzogvc93ADhDXFk5nK71uBAAQFzC51jgx++TFGkDhL7SOQzxqxSRy5qgwX1uiB6pZqodjAJl/CByUp5vjO4D6FGS6mg/Zf9lIyJ72n/xTCp7IJ6AuV7LlZuEAHi1sYQdqtCmhCdOUlK76YkkfFVlYTgoGDjvRwlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759536373; c=relaxed/simple;
	bh=zeRD69XPYlj68+OwgfypXN7uQJ8dkFLFiS3m2qfBVX0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cT0yWifMG/ZSDumg6rntox2CxYBlWidgklNS7WWOooqQQS1dRE/rKftlJfE+LMisJk0ogUShrauV5hqrayoMDe3G7nZSnWLQuwxqr2qKPR2rS+h4sDD/2NVqJFjh7UqSjoL+UQXqDYYqnDURw4eRvCF4V5azacLkofWYZqce4VU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G76J4VUO; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G76J4VUO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759536372; x=1791072372;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zeRD69XPYlj68+OwgfypXN7uQJ8dkFLFiS3m2qfBVX0=;
  b=G76J4VUO/ElifPbrxRslHg6y4pRskUsT0saF140tvwmkKW4z5dIq0lVZ
   mQYzXTx4l50nEnwQdtUsyyMvBpbyo0tCS4NrlAUw3zVCB1b9pxsnT7dJB
   yulP9/DRZoSsM4M+qJJ22zAqAJ2SkSKOAi/rOASoWMIDYoSXf83qxbl52
   ZOCq7KyZPW8vK0nTWbvGPHvuRmF6tprHWQHPiN1tRB2jL+0ugYaTlF8SW
   hmIBrQ+YfZjKHB1wHHCa2MJci2Fa2MM9q8jX9AHWYy2HKWw0ScGu3sadS
   BQsM55pSeBqLUt2B7MjvvwMtf7XGJHAPs+NACYzcxO0MyDZVa7R6qKKmW
   Q==;
X-CSE-ConnectionGUID: V/n6r84hQN+X9Y+d3hz0oA==
X-CSE-MsgGUID: MUM1TrFYQIyD5+RJ6oWiQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73173410"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="73173410"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:06:10 -0700
X-CSE-ConnectionGUID: PnT6nrGYTvWyhR/pQ94VnA==
X-CSE-MsgGUID: J9aSYVhIS4a3J5WlOWeWPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179328378"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:06:09 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:06:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:06:08 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:06:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYVA59ewujFuDOZoJIDSrMOiBJVXlAl2oTArmkUFVj40PtWKXsHrsgqJBgv7I7D06jSrK82qMOUDRPx5PG9GsAkPcfg/zNbBpx3cUVmAORIGTR2eIoTKUrwoDa84wk6Eopk8z55bex517zHmGWlLx1CyZWqCuh0NAoAQjRbycZ/WRVY7dK5WvpJ+jqCxGWmtsvmA9YkysGixM5GxUKwY9HKGdgIr80AFnxYBF3HL+zXOXmLGtab9UZ8LYB0LydVpnSLPXS8XzNqvXUSHUsals24A1J9JxXsvg2i/c1LTpchm3wqUZWOV8E3hMDrWji0AD/3azml4sopfHdGWgzNgSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGj24BhaWjJaTsaqVwod6NFnXly8w9Rzmpei/FgE/k4=;
 b=urh7bOmJfT41ARP/5sMH+iqZY6mWRSsIv+qaW18EUr/SzPOZZdUtCp++y0ogWV1M6a2qwGYA6dsQrEV/zV+/rffaMtjGBwF7OwkZ8S/Xd1D+q+B7Hix988fcXxrSetsqaSnAGxapXXoiJDomqeYWbv4GQIQbSrCf8fcM8jH2FC5A6UTiANVTDKfYjKnF1xJPkVObqrsFd13mZe29fQmrrrQAvOZc5MW+i8BwFZIdiNb+aMYMSJnT4CxUwwvsrHg2usI2ENrvKcMN4nvwruybtqNdCz/hVWLRyHTt8rlVcCvNB2i90LxC8TbhgKP+aUuFh/LcvLKQdWFPirgbdQ7n+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8715.namprd11.prod.outlook.com (2603:10b6:0:1e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Sat, 4 Oct 2025 00:06:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:06:02 +0000
Message-ID: <a307936b-c85d-4c88-839e-740c52d96b8d@intel.com>
Date: Fri, 3 Oct 2025 17:06:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 23/31] x86/resctrl: Handle number of RMIDs supported
 by telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-24-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-24-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0014.namprd16.prod.outlook.com (2603:10b6:907::27)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8715:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ec639ed-94d1-4fec-65c1-08de02d9cdf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ck45dzV6dytTY0RpeHNNM1hVWkNxSzduWkMyZUJ2ZHRuNVJWTk80di9nWHgz?=
 =?utf-8?B?b3NLWmF6dzhvSldqMVFWM1FNNjl1azc3M0dHY2xwMnQ4S1RWMEJxdEVFZS9P?=
 =?utf-8?B?dTRna0FBV1BSU2ZWa0hsc21wc2N5bzA5RG91cm12MG9DSkZmSkQrMHYrRmJK?=
 =?utf-8?B?cG40aVNMWDQ2YkVmdXJPWDBTYnhRa0JwaE1GWEZ0dGJTTTFFeWFOSWlRYThF?=
 =?utf-8?B?NmNZc0srNFBGNlpFMzZQWTFxbzByelVqU2s2ZTlpWG4vbDdZSEJuMXAzdEZp?=
 =?utf-8?B?cTh1b1BHY1Budm9HTytiazZsRk1EVTNZSXA4bG9UQzBGU0ZxVVFsdGM4RUpZ?=
 =?utf-8?B?U2ZQMDYxSFpwNDJybnVmbVhXK1p1QkhUd3U3ZUpOU01DOUQ3MFlIZC9mMHQ3?=
 =?utf-8?B?eDcwWTNscWJKeHBkRWpQenN3ajdtMjc0UkFydnpsc21BdVRObmxHYXBuaXBJ?=
 =?utf-8?B?V05QN01EeXBjUitiTXpCMjNUNmNmUUk1Wk1WRlhzWldPV3o4RGppL0l4ZkFu?=
 =?utf-8?B?Nk43TjRvakZGZmloUDBkZ2ZRa2JDMTZNSGpmdDZTdHFRRWJMTzJPa0tBWTJx?=
 =?utf-8?B?ei9meXZBNCs3WkV1VFJtSW81eVlBanlCMkcvVmxBcy9YQnNVUzQ1dFRKc2VR?=
 =?utf-8?B?UDBDYUlNV0lGb1Q0dUw1Rkw5WEszRGlFbGNVTWlqMitHRkVyNEVrUzB6ZEJX?=
 =?utf-8?B?UmdHVWticzV5ZWZaMDV4bHE1eHBhSmVCTmZtY2FVRmxkNmluMm9jK0NaU2dJ?=
 =?utf-8?B?UzRZWUVzaGQ4NmRCd212ZmYzWjhiVmZkSzBoTVhiMVBhNG5HMmF3M2hHZ2Qr?=
 =?utf-8?B?N0N5d3BpSElRRmtQeVlKb29CUitDZWsrNVZQR3gzQU1zNWZhQ2NJbDdsOTJh?=
 =?utf-8?B?aXU1MVNrVm9kK0RMeVROSzNKbTY3ZC90RHh1ek1PeVAvWTFGRmtJbWZJb3dx?=
 =?utf-8?B?RmtkRWMzUnRRSmhtaERQTUNEM0FtYXZCbTFWL3RlNExmWFIyNWdPdlhyelNM?=
 =?utf-8?B?RFlkZGI1RzFuK1k2NEdVeksySi9PVlE1S0x3VlB1VDlpQ2Frb1BnWHNWVVQr?=
 =?utf-8?B?Vk4vdnBtUEdzSzZ5bVFubHkvQWt3VFRCaWdGOFlxeG0vK05NWWVwVmRlVDF4?=
 =?utf-8?B?a2U2ajA4Sks4SHkwK3UvbTNhRnBWbkNRODFVSEhsYThaelBqcGlPYk9kQWJU?=
 =?utf-8?B?UGt1RnN5SVR2ZytyUjBESllqaXYzZ0h3VVkra0Y2T2hHUVVXWVBQeEJVY0hZ?=
 =?utf-8?B?aTdORjU3S3ErSVQzNzlwQ2RhUVJYaTB6MVE0OWNNVEZWTTgyTEViWmJyYzhZ?=
 =?utf-8?B?c25XRVpRNzg0ZzJBcUNPWjZJSVdKR2hWMkVneXA2N3JPQXhEajhzd0lLbCtv?=
 =?utf-8?B?Z3U0SEU4ODkxaFVnZ3hIQVBON0UyRWNjMjVweUdFZVQwQnZKMURXTmpHTll2?=
 =?utf-8?B?SWFIVDRaODUzZ3JYYWxzK0dseGloUnh5YzdGS1ptVGg5SEJlcmk1L0xXcnJt?=
 =?utf-8?B?RFhMbC9pNTRFWFU1UFRxblphRm0rRnN2WG1wcDdRMktYTXVJWWxwcVVVcnA3?=
 =?utf-8?B?eFR1TmFhL0FKVDFsUUFWNndxNnhTUUhnTXVOdjg4ZVFkQVhxSDZhMlpQQ3Ry?=
 =?utf-8?B?ZXUvQThEekx0dEE1ckI2TzZ6cW8yZitneTRrRDNBcE1NWFJqamQzdFdsZ3I5?=
 =?utf-8?B?OC9DSjVmZUhPUnZnQlhXelB6Q1RVYjQyWWw4OXhIQ1JrcjlzK2Z6OE80andj?=
 =?utf-8?B?d0NpTjVXeHNLLytmUlhIK0NvQkc2ZlNOTUNEV0FrWHlLN1c4RkZWa0IxeWdG?=
 =?utf-8?B?aXZKeGwxNFN6KzcxNUlnRW42dDN5Z2hkdGpnNkMrQVlyTXF0NUlBS0F0dHFl?=
 =?utf-8?B?Y3NlSU1meU9zSmM3SS9obGJ6ZC9iaEtDZDdjdTFiUHliU1g3dDd3THQzOWps?=
 =?utf-8?Q?E4Q2z8L8h90VkT2apEFC+KdptpaoEgKk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L013VTdkc1dlUDNmUHRueFZCS1QrTXpQNlBYMzRENzdYbExGbUkxdWJGSHQ4?=
 =?utf-8?B?NjlrY1dad3ZSb0RHUy82aVBWb2p6QXNHd3pqOTlGaWVtNUJPSXllMEx4YmZP?=
 =?utf-8?B?QVh4UnhaYnNrQU0xbVlwR3RLRUxTMzFSOElqQXp6ZlVUT0puSGMxSFNYRnZk?=
 =?utf-8?B?TlYvc21XQ2gyb09LVHozejNxRnE2S3BmUFZoam5BbDVzcnRPUndYQmZYQXhr?=
 =?utf-8?B?dkQ5YU1iNUJveE51aElzVFk3VTBhWEI5YStITlhIRmM1cWVHWEdPdC9tMnAx?=
 =?utf-8?B?UUQrdm1EWFJGallpMmJCS0E0TXllY0lmT1hjQUhLYUNvK29QVHNOdDNJdGdY?=
 =?utf-8?B?WFBQL01acFZFbitDWTRCODIxL3dISnlqdUdjbFNCaFlrVjJjQkRYTFhKVkl5?=
 =?utf-8?B?b2lEK2ZYSFJoNWRzQzlpVUQ0bXNuOFdmSVJOZmJnelFieWRuS0hVLyt5RUhY?=
 =?utf-8?B?ZEQrdS9VeVNPSUN6MXNlN2k5ZEJid2ZYNFZlKzlCOHlSQ3gySndianB1WWc5?=
 =?utf-8?B?U09OWG1qYUJ4Rzc0ZW1yVXQ2eUJubU01aWp6UEZaVkhHUWdHcFNuTjZtTmha?=
 =?utf-8?B?cXZka00zNVdINmNKYVVHb0lYRHVWOXoxY1d2Vi9GN296OXVjNlpXRzRBRmNV?=
 =?utf-8?B?d2I5Nmx5NkZDTkVvcW5KandiMUJ0SGV3RHVDTjRNbmlXS1VlOVhGT0tLU2RN?=
 =?utf-8?B?b1NCQWRGeWtNcGhBblRjeHZ1N215VExLaXJNM3RHN2Y3WTFVZUhUa0hkMlB5?=
 =?utf-8?B?akVIR3hsWmJHZWVRbE9HRERPN29mQ0NYeUg0OW1yR3krRmoxUkZKYWtTNGhE?=
 =?utf-8?B?U2JWYnJWcWNDMks2QTNkelVUN1V5QzgzS1RVWW9pQlhnRW9JbXl6aDExVlpL?=
 =?utf-8?B?bzNaMWdjZXQ4WitZSnhGMlhsVUgrTUgzSkFRVE1hNzdxekRMMWdKeW9CTnlj?=
 =?utf-8?B?Sk1USTFub3dZRGg0SUhMcldrV1VaYmxUK2FaSWtNS0RhMjhmVXhPN1pKVG9O?=
 =?utf-8?B?alZCekkyaXRXWDA1VUF3TUt3bmVMVUVaR2hTWUlna0xpZWtxOGZmNTZqU0s4?=
 =?utf-8?B?K3A0TlFQUjNzTlR3SU9CRjJyWVl5amlkUXhvMXkvNjlMUkpqbllCb1hMWjNV?=
 =?utf-8?B?cXZwSExlT1lKc2hQWVBWMFVoTG5PUHpvOW82TFpIK21ySlY3SDdnc3diYXMy?=
 =?utf-8?B?ZU81MkFjMC9ZZ05JQUlFOU1DaUpKOVJjME1laGxaOG5vRWh1NU1OS3QvUi9O?=
 =?utf-8?B?TWxuc3NiYkhSdnJ2SE51cUNkaFNqMW9reURPVHNRUmR4RWhyZFVhVEcrcEUx?=
 =?utf-8?B?SnJlZGNJVVd6aDFySWtaWTVxMVZLOTFORHJaakZqSGZDOStNL1RiTVdRQ0pT?=
 =?utf-8?B?R3Y3ZzRodCsxazRQaFBYcENmZWtoR1ZNU0VuMGlwbkV5M0grc2dOWlNITUZF?=
 =?utf-8?B?VnM1akNpMVRnUGJWWm1pRS93bDFTeE8vL3NZYlgyZkVDNlFGdnovdTljc2xi?=
 =?utf-8?B?bk45YS8xUVpBUzc0RWJNMHV2Q2Q4UDN4UzlNMTdZU0RaTEVZN3pLNWcxcTRG?=
 =?utf-8?B?YUVvSlRETC80RU1FRlg4S0ZoSHBYS0pKQjNnUGRwRTkvY0JUQkQyNS9JNUV0?=
 =?utf-8?B?ZURIVGZCNXQ2UTJpRzRtUThLa3NBdzhma1VpMFc5QzR6QlcxMjJ1SlpSWGhX?=
 =?utf-8?B?Q1hJeEF3amFCZndXQURlcDY1cGRKSW1SNTd6UnlRR2Y4emdKdUtxc2pqVUhU?=
 =?utf-8?B?TmM2L2l5akxqSjUxbytRajRBeEk1bzltalZhQ3MrSjV4WkRUVHpsQzZQMTRY?=
 =?utf-8?B?YkphWFQyU1FpUGg1S0R3UXF4WVFrckI5eE9BTkxvMHh5U2NlclNXV3RkYUlz?=
 =?utf-8?B?T2RyT0pLcXF2OHJhN3VFVldZbitUb2s3YzIvcnF2TmkwSDVZUFBmRnZSdmJs?=
 =?utf-8?B?Y2tJMGFPSGI3eWxMMG4rS0FyK3c4YnBkRWg1cjU3cU9HQnY5R0p4ZHFsN0tD?=
 =?utf-8?B?ZU44TFhQejVZKzdIdUE4b21oVTFmS0VDTmFPWjRBQ1hDQk83NnRkTXVmblRH?=
 =?utf-8?B?WXRoRUR6aE1hUHRRS2xPMy9SVU9iemdDUE1FVmkyMVp2bjQwMlNZSHNuN3hp?=
 =?utf-8?B?bVpsTURSQlIraHF3c1lXTDUxSVVRQzU1V0RYdVlraHM4UTNqVUtvdDAwTmVm?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec639ed-94d1-4fec-65c1-08de02d9cdf1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:06:02.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /kgptQmFMoAdfcH1JmnnqlRQLfFRfE5UauChCbJh+9eUHaCekhS4Xiw+bQA6+PJSgm7lgM2NRBt4ifpWtp6GcTsOl4vOMWW1x63yjv6H668=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8715
X-OriginatorOrg: intel.com

Hi Tony,

(nit in subject ... "resources" -> "resource" ... with caveat that
the term "telemetry resource" is not used much at all in this series)

On 9/25/25 1:03 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled

"the IA32_PQR_ASSOC MSR" -> "MSR_IA32_PQR_ASSOC"

> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids.
> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs
> are difficult for users to use, since the system may reassign "hardware
> counters" at any time. This means that users cannot reliably collect
> two consecutive event counts to compute the rate at which events are
> occurring.
> 
> Introduce rdt_set_feature_disabled() to mark any under-resourced event
> groups (those with telemetry_region::num_rmids < event_group::num_rmids)

Would it be more accurate to say
"(those with telemetry_region::num_rmids < event_group::num_rmids for any
  of the event group's telemetry regions)"

> as unusable.  Note that the rdt_options[] structure must now be writable
> at run-time.  The request to disable will be overridden if the user

"Override the request ..."?

> explicitly requests to enable using the "rdt=" Linux boot argument.
> This will result in the available number of monitoring resource groups
> being limited by the under-resourced event groups.

needs imperative ... how about something like (for text starting with "The
request to disable ..."):
	Limit an event group's number of possible monitor resource groups
	to the lowest number of "hardware counters" if the user explicitly
	requests to enable an under-resourced event group.

...


> @@ -156,21 +168,57 @@ static void mark_telem_region_unusable(struct telemetry_region *tr)
>  	tr->addr = NULL;
>  }
>  
> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_telem_region(tr, e))
> +			continue;
> +
> +		if (tr->num_rmids < e->num_rmids)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	bool usable_events = false;
>  
> +	/* Disable feature if insufficient RMIDs */
> +	if (!all_regions_have_sufficient_rmid(e, p))
> +		rdt_set_feature_disabled(e->name);
> +
> +	/* User can override above disable from kernel command line */
> +	if (!rdt_is_feature_enabled(e->name))
> +		return false;
> +
>  	for (int i = 0; i < p->count; i++) {
>  		if (skip_telem_region(&p->regions[i], e)) {
>  			mark_telem_region_unusable(&p->regions[i]);
>  			continue;
>  		}

It is unexpected to me that skip_telem_region() needs to be run twice with
second time marking regions as unusable. I think it will be simpler to just run
skip_telem_region() once to determine which telemetry regions are unusable, mark them as
such at that time, and from that point forward just interact with the usable telemetry
regions?

> +
> +		/*
> +		 * e->num_rmids only adjusted lower if user forces an unusable
> +		 * region to be usable

In this function usable/unusable regions have a distinct meaning that is different
from what this comment intends since insufficient rmid does not make a region
"unusable" per skip_telem_region(). Perhaps something like:
	e->num_rmids only adjusted lower if user (via rdt= kernel parameter) forces
	an event group with insufficient RMID to be enabled.

Reinette
