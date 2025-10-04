Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1871CF96
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 00:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759537423; cv=fail; b=aiRb9cnoJevskXwXw2L3ZHzJeaTeptSHL9AL+JHesiGQyxEPIbPwqmSYH6OWuEfSPUlMuG+HfNPAafZfsS6steucCt0W6Fv4lGuATwLJHpixtDEi+pKhNqs//pzH1wGttBfCEuY/pZQ09bTeul+25e0ae/jBUor2yMB3oZlwibo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759537423; c=relaxed/simple;
	bh=rZqkqXScKBBLDXRrwARGdoA3mIac+aUBaU9nqvIz2HI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uYbzUTCnR4G4QrVPUggx40hvzPA6vxNsBaUDgMkqKdCJ1LWZzlT++YKpVQ2BVKYoEp5nxf3PA/PHUpjeOcLRmuZ9zK9f97z4+r5L7V4LEL7yKmG2OUdRdt1KoIC0TuEg2drEhmvNkQK2dIVPDwvavcsorHz1llEjaYKKrR4e/nY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEKHNkZC; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEKHNkZC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759537422; x=1791073422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rZqkqXScKBBLDXRrwARGdoA3mIac+aUBaU9nqvIz2HI=;
  b=JEKHNkZCEl6TJo/xkKAaHOoUGf9py8C0QqWaHb4HIWp9qHyEtMX7DpRb
   0RIgLboxtPPDIUpR8CPTzpNIp4g2SB3zPnMvon7igUHEFysxfAp/w1sQY
   ULIpVsUehfBd1ggZ9THE3vNZgX5V1YcTyMroDTUZN0/3wbmD5+VcvMEUX
   Gao3+CyRMemRTqop8Ldb/h/AxSmf4JN/MVORCJnDjMfKFonxfK2XA7xO7
   JIOMbsVzlf2mvmZZjiUS0ESAnhGTmTKMWrcdzq2u/PXmoiGM3hGWfxd7M
   SzFfnuSV1Vkp5bhB2jm/CT+lFhhdW1/dqfgFixEYCJCBMAC+rRtu7jbBP
   g==;
X-CSE-ConnectionGUID: 68YPbVjTQwuMaQRlKEqSMQ==
X-CSE-MsgGUID: msUKmt0YTf+3Hz2IDOjFCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="65463240"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="65463240"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:23:41 -0700
X-CSE-ConnectionGUID: epJPIQhBQn6+m9Gh10Fytg==
X-CSE-MsgGUID: zsWasiV5SvuuReAoQw6TNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179330629"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 17:23:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:23:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 17:23:40 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.70) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 17:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPz6zdTCcOJ7HDGTkPqrmJYABln9lLodCtvWSvIPaQJvoH3MIduG9V8PMZejBh0goz081AgrIPib3T8S+yLZ5lloJWyHZ4yX6tiHFU7iZLvR31Jcrh9W0wqh1fm4tozoR7Dx4CSIY0zQRtr147Y+enT3dsY+zIDmJstqh5Pt3thY15eaXwDxBSlLk3i3kVblINxwI8YCR+2jgTSylBRaz5aAo31HsIfjnjbAsQjuusZ4jdjQHrNt648YLV9jBGaR5xA3h8h2COnhQ8R30q8LFU8uFgwsX/97XKXyn6+pa4UAH5hn7l4gtLC4s+5YOZ1A3Xqz/1YA7zjYs+FepZ5AhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lOzICqqwdDuZix2mxLVefP7eKcsCpZoUmkfnte6GeM=;
 b=xV98bix6a6povmcEtHmXGrWYYTr1G/8hJh2iMwNXZ2w2XdDtQh/f8kR1OcSrmOokbqFz7MznnOmCl2CBKxzx/FYnMA7k1q4pMT6sBMojKmUKtTIDadzHa54+foU/jyG7CuUDYn7mlT2ZdTLvrvop/NP2nXhfnodykqviVMkQgFlIqWEpDDzzkaS/nO6W1xxnMNFOZyhxD5rCZ7qy6FAX9W4qy9eyiXgnxcgoAo3dmz9K4/6iLyPAZhjsPFjzGXGNTxNHtX0HhV5JF/t2KQdzyBZ+dO9tsOxqURY08240ZjhUwe12rlBJ8XU+15k0Y4Sc2OVbhfqtWnff081MJwx/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF990BCE628.namprd11.prod.outlook.com (2603:10b6:f:fc02::3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Sat, 4 Oct
 2025 00:23:39 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Sat, 4 Oct 2025
 00:23:38 +0000
Message-ID: <48f0ad87-894c-44bb-9106-9fe42f5301aa@intel.com>
Date: Fri, 3 Oct 2025 17:23:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 29/31] x86/resctrl: Add debugfs files to show
 telemetry aggregator status
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-30-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250925200328.64155-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0322.namprd04.prod.outlook.com
 (2603:10b6:303:82::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF990BCE628:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a9a8bb0-9eb3-4e2e-80fc-08de02dc43c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWZDRWZETDlEMnpPZFlMK3p5bTVQQVJHWThHTk9KcTdRdFdibjllM0U3S0Uz?=
 =?utf-8?B?ZzQzeHFIRDYvTHdsZDJWTG9XK2twb0xrQkNkeDFJNWRWR3BzdW9Gb3lsYldm?=
 =?utf-8?B?dXJLNDcvUnRiSkk2bFI5am4xWmJtRnNmcWttOXROcmxQeDBwMlVNY2NOclFm?=
 =?utf-8?B?aVV1a0ZEcWFoWWVHaDZNVFI5OS9HWUJFRVdaUHRLNTlOYVlubGxzQ2J4OFM4?=
 =?utf-8?B?YTBvZHZKekJmdnY4QnZRd2hOdzQ2ZzEwMXc1empTcTI4WE50OUtyQUhEZEkx?=
 =?utf-8?B?S3FpK0dja2dndzdNVFh0RE1qWmxZL3NQS3dqLzU0bnAyNjh5UFBkY2JveFJ1?=
 =?utf-8?B?VHNwUm1NYmdsN29IRlJSNG0yLzlnb2NZYXpreEwxY3d5OGExQU4rUGtadmxV?=
 =?utf-8?B?cjYzaG1MQ3haQUhuZEdYSHJlWUVrNGpJREJRNS9PbTc0RncyN1hOU0JQRDVx?=
 =?utf-8?B?Qm9wczFaTitQNVdzR1QvVzJxMlA0SlZDaW51VVFOMHhHbFVwVUV6WTNkbTVk?=
 =?utf-8?B?cUxxOGo2aU52cDJERE5NRVVwRndIVi9yc2ZRN1lmaE5peGxsZkM3RlAyQndT?=
 =?utf-8?B?YlVmTDc5NFhHTFBPdEpaQ2djRGtSMjFISVdvWWt2V0RxZXRNTGVPZW5reUNF?=
 =?utf-8?B?TEhyNko5VkFvUlRMSlpOR3JDVkZ0NEwrTE5ibTNVTk1yMFlkRFdiZ2RNY2dE?=
 =?utf-8?B?WVB1NlFHY2g5a0puVTFqNG9qd04zT3ZIemliS0ZKVzBTN1VYTHl0ekJ5OTQ0?=
 =?utf-8?B?UlA1Y0Z1QmpzazFtZUJlSDI5V2F0T2oySkR0aDlmM2lPdDcvSzdPaE0wWUd5?=
 =?utf-8?B?YUwrQWFPVWx2c1BXOXlhNUF0a2laVGVzS2xNTTU3bUZxSGtoNHlCblhTcUlP?=
 =?utf-8?B?Z2tBZHdBT015dk0wYnEvV1RzU21mWDZSMVNzZm1iWWJUZWM0TUZvZittdldB?=
 =?utf-8?B?ZTJscldlNExxUTRwbEwyUXMvV3RsMWtUUHFWQVdRT2RPb01FUFlFVmpvNDNQ?=
 =?utf-8?B?SnhmL2dSaTMxZktpS3lHVHFYblJkSU41a1FCV2NHRGEwY3B2WkFpVXVaSHdN?=
 =?utf-8?B?VC9WcWZ2S29MbWJTbXJzcGlqMXY1aGtCK2p5U1dRZStyRnlyWTZmTUdIRTh4?=
 =?utf-8?B?eEFReW42QVdhQ3gyNHY5Mnd1VjNMRU8wZHlYNHZLbDBsdGlQdlJTMHVYWGha?=
 =?utf-8?B?OG8rdXdHQU9rNHJDSXVuUHA1OFJTcElMSkw3ZUNCdnc4QzJtUHdnczhBemxX?=
 =?utf-8?B?SkxOaU9qVWVBUm9nSUZtSkd0Nk45ekRveVFidjIvSTBoSzQzVmtQZHE5MjBG?=
 =?utf-8?B?ZkswT0NNaXJqdWw4VVphOGRVMzVncUxTZFIzMTdVZWtEK3dYK3NEV24xZ3pk?=
 =?utf-8?B?NVlmS3J5MDRiYVhzektERXNPbVdZZmlqWHgwTHh2WVh6eUwxRlVORG1QT2M5?=
 =?utf-8?B?dVZjY0VLUEpVQUM3c2NleDJKYW5FL2ZhRmF3NXNlb0hnSWp6U3FjVVJ3YkNZ?=
 =?utf-8?B?ZmdTRHhUY0ZBYld0Smt1aHpFSzU2b0k1K0hLY2Y1WkR5dS9Vdjg3OVpyejBo?=
 =?utf-8?B?US9hMVhhbTJOdE92Q1QzS3lQaExIUHdyVkw0dk50N1pndWl6SXhvWkE4YmxF?=
 =?utf-8?B?Mng5aXhsOGJNMC9OUWl4ODJNZm80TEFwei9PL1c0dWU2Q0lTVEYxaXNBU01L?=
 =?utf-8?B?Tm1aR3FGRTFnZExpcVJ5Mnlmb3QvY3lBMzNhNkFselZiMEdweUlWaXFDbkw0?=
 =?utf-8?B?d2t5Nm5pZUVDTUJzWDI5TjdCRU5LMDdhOVBoSlQ1SmRXTWJuVnhhbGFiYUh3?=
 =?utf-8?B?Y2xnSVFXeEZGeWZURWd0TEJ0RmJVNzVHU1o1UHhqUWRvU3ZiQk9UVkhmMFp0?=
 =?utf-8?B?bzNpcVYyNVc4ekZEbUVsR2ZVQkVOamErcXp6TGFPNENndzAyR0F2dW1EOEtF?=
 =?utf-8?Q?aIW+3wHuSSZCO0ZnF0PrWFd8cbpGJgkb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVpjdmVsQmpsQWU5d2g5YnhCVnZuMzg3b2ZEU0c2S3pTM3Bub3NRWmNsbDBu?=
 =?utf-8?B?TXk2cEF1TU9rUGhhYzVrT2I2ZWNzWjZHN3ZBUTBrRlFIRi9IK3pFU0QrckYx?=
 =?utf-8?B?MU1OS1hMcHZBaXNsU1ZCUnBTZkt1VTREZWlEMVljdjZpN0EvSWwweHYvMnpC?=
 =?utf-8?B?dU9lM1hnQmdFSVE1aDNGdFhHQVNYYVlhRnJrMEJXQU9hWU1sdnM5NGV2S1I4?=
 =?utf-8?B?cmN3WjVhbHJ2MEFHdXhEeFZXamxjVm16RWFuY2E4VmpOZTV2UWFVbnpuN0FO?=
 =?utf-8?B?dVF2K2oxcTFDY0Q0VW0ydjZGbjFpc1ZyUkRSNld1MjBEZG9xZXl4b0xQVWQ2?=
 =?utf-8?B?ckV3eExRNEFiVkhKT3A5d2FicStLL21JS08wZXgrTkpLOHk0c2ZJbjFpd3p3?=
 =?utf-8?B?bGlVUGY2eFNrMTVRSUQ5cWJzS2c2REtZT3dRVGJLT3QzNVcybmw2WjVScnh0?=
 =?utf-8?B?M3JlSGRvWFBEbmU3eDIzd2pxRG15TnVPYjNNU09tTkxiZHNpc2JFTVltWmFl?=
 =?utf-8?B?UHlIcGtraDJUQnZxeUt4ekI4T1VkZ3NHTGF3Z2dyT0hsYnhITlM4b1AvRWxv?=
 =?utf-8?B?V2pIM2Jxc3Rqc3ZaZUVOc0ZFa3RrbzFCVnRIMndOcFl1bTRQQVVZbmxHNTRB?=
 =?utf-8?B?eWZPdjVWSEgyV0JGR0NKMnR3TnZwcEw2enJPNEhydGZLWGdMQ01RbUlreUFR?=
 =?utf-8?B?UzJSYStrSWd3K1Q5dUZEQkNXYlJsWTBGYVd3Vk00Q2JDMHRDNDh3NWlHWEZZ?=
 =?utf-8?B?K1E1WnVNS3E2cHZFb1BUMis3S2RVNGZWbldxQUY4ZUpDVjhVQUpvUFQ3aWgx?=
 =?utf-8?B?VnV0bEZBWGhUaUdIZUszVm5VdTRiMDgycXNqcEtueTVkZTBPbUVNcERoSWNt?=
 =?utf-8?B?ZXdUdG9hOE90NWhZclBwMUl1RWxEY28xVmd2cGxCMzVYT2tFYVVrVytaaVBu?=
 =?utf-8?B?YmVMakR1NFpocGg5K0hNYnhzRWE4bXpORXRCdDBSNFdoaGVOWWtHdlorRW1r?=
 =?utf-8?B?MnF1OVBZU3RUSVBxM0JUc1pseTBwWVJkR1phQ2Z2UVR3YVh3UlRzeEI0Rk9Q?=
 =?utf-8?B?VmMvZDNFS3R4WmExWWJuY0FDdlFJaWVJWUpMdWRBTDQ4bVF0NVlmNmJYUUFl?=
 =?utf-8?B?NEl5MXhtTHZtOHVxSGN0RFhZZ2wwOEVwSHNRbTBiRDlmZURQNzhHYnZ6VEIr?=
 =?utf-8?B?OFRxamQ1My9OOHF2ZDljT3FhaXRCQ3dVV2xndm9WS0FYeFloZTBLU0xLWkV3?=
 =?utf-8?B?b0s1dS9JVVZjUC94b21mWWhHOEd0eWxWRy9nbFordGwzNnVta3VVNHMzd1Rl?=
 =?utf-8?B?Yi9RYktoeUpGd1Fnck1tdStZdG1HT2hWbWJubVdSR0FrY1lSZ3dZZXAwRjhT?=
 =?utf-8?B?N0JOdU9ROEtBWGhqMVprTmVCV0FkTlhVekhWbS9BdE1oYWtadzIzWjZRUlQ4?=
 =?utf-8?B?amNUcURvWUJveGFIOEhtdFF3cXZsdk1hQUFOWUpUZHF0YklRRzhvL3BzV2RC?=
 =?utf-8?B?MGxjeThBQzBTNm1ZREN2N2s3c0NSeVkrTlhqRk5meXZIY3M1N3FYYzc5U2Fw?=
 =?utf-8?B?T2FiVFc2c1Q1UnZBRkc3Y1lTWFBQV3MxamsxUld6S1VkWnBYcnYrM2F5ZE5P?=
 =?utf-8?B?UWFIVERRcVlKYlEreGZ0dFhCSzZQNjdXcFdydXFQci93eVB6TXkzSUE2T3Er?=
 =?utf-8?B?U3QvRmE1YldWbFBmcmN1MURzRys3bVhVZWx6VVZZNm0yNEFjZjI0bDU3TnJD?=
 =?utf-8?B?cjRDakV5R0RLRlpxOEdTMjU4VlpvWXZGWGlNQ0dORFQrUUN6Vys3cnU2M1Jm?=
 =?utf-8?B?RjJuK1dlVS9EU3hmdjZxbVZVQTB3bzVHK2ZtdnVIYnc4SVRZMm53Y3BnVDFz?=
 =?utf-8?B?VnpkSWlUTFlKYnBKRENGVCtjeVJJTi9jcW5tcVV1MzBLcjN3OW5JTEJEQURY?=
 =?utf-8?B?dkJpb1ZNVlBaUm5sRzlnNTZDcVFpeDdwS3hpYnBnRUNxd1JwSWVLY3ZFYVZq?=
 =?utf-8?B?UnQwQ0RrQ3M5WkJrWW05UXEyRXNkdy9kU09hby9TYjlxY3pTVFdxSmhCK3VW?=
 =?utf-8?B?WTNUVk9oRDVTYnhIT2RWSnE0MFI0cXY5bjhNc2E1UUJmT204OTc2UnNGbnB2?=
 =?utf-8?B?djV2UTdVRVVzMEpCNVNCWU9DOEdwOVM3dzI0aWlMZmx0N2RkSWJkZE90Tk9Q?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9a8bb0-9eb3-4e2e-80fc-08de02dc43c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 00:23:38.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFEFPVXUkSvKYFSw5CvvxxV+VkUYADadkIGsKZpdI16CMYXLxe8hMtpsvj0cvJe+aayXv3yzr+uTvzYgGCX0ZSnEwA2b6jqA9aMeNurIxGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF990BCE628
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> +
> +static void make_status_files(struct dentry *dir, struct event_group *e, int pkg,
> +			      int instance, void *info_end)
> +{
> +	char name[64];
> +
> +	sprintf(name, "%s_pkg%d_agg%d_data_loss_count", e->name, pkg, instance);

Please keep the type used for package id consistent throughout the series.

Reinette
