Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53074207A
	for <patches@lists.linux.dev>; Mon, 13 May 2024 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715626408; cv=fail; b=i65aOzl3lj6DiJBRAMkl7xZKl5R5iD7DjXPwHiEuZseHFoXDglcqGXPzqcFBSni/MlxmQUd5tMSdGP6kby3JjHzsGRHeozEbSGAsyT2ZOMipD2b/d3B9fNnMexKs4PwWEl7Q2UE+UTHK3Qj+CVdiWGcTOdk+MwREQL/ainAnavo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715626408; c=relaxed/simple;
	bh=aKsEICA9lB+f1R3oorVU/83qVW1Aex61umaFyBUXp10=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K6GdILvEVXA+/WSRfTs2CyJZFL8v36aAoWaL31Tt/NwlWRZf8kY1hiZQFiiivNy6F5TSrAywQC9kaoU8p4QghwnrGB6JsHDHWFOa7bwfiLJLLC6Tfp6Nu/ui+y620xgTJymR6Dla13awW/3YB0mjT/SsZWX3eA39dUbGyEyN6lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=novemctn; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="novemctn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715626405; x=1747162405;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aKsEICA9lB+f1R3oorVU/83qVW1Aex61umaFyBUXp10=;
  b=novemctntJOqYyAXtLEOCg7OLRujICszk6vw1xyEQX4DEk/OhMwUVeKu
   rFxmr0fktxsH6y7heeqx1LVnPt/NIYFAjhyRckpwimUoJPRkm5zW+cIc2
   sgPIkS4PyUP/HBVU4g64WJABshUFmuIkglpB9GoVCtarjj/8Wh5xyJR4D
   9YAC+CgkGQS+34rWeLYRhNQOBFdv7DHhQ7urjXgx96UxjJ6fkNAThk7yh
   YKw4406R3BVAcsf1zOGK0a1mxWWIIm2zJW1odHPazY+p4yl3UD0S4LMmL
   LsvYaNAzHifaQ9IHqEjdG9dsA5aFUQm6oZM9JV1nhtpm4vv1kpQ3vjz1t
   w==;
X-CSE-ConnectionGUID: bl+7kKM0RKWWzoEUVvEUig==
X-CSE-MsgGUID: UKMUWXX5Qw+1s37lfF5Q4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11072"; a="15413028"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="15413028"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 11:53:24 -0700
X-CSE-ConnectionGUID: J6F3AZJ8Q+Wd72ob9GGzbw==
X-CSE-MsgGUID: a6AJsRojQi+6pfoovXbT6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30437407"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 11:53:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 11:53:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 11:53:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 11:53:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvuYNbQQjHcPaKMd0q4Vzrop7i/EIaojQ6lPitBMQnFe4fu/dGZiUSwI8S3gDnZWdQ4H6wvvLs5eL4NAAobt2CgKAP1wqClBfresefyMrN3zQQ7t5uwWlrb+yzWkp4RuPWPMwCVDDDBb9yHQ7kfcLO6mfM0DsrTUXIeku1bQ9aiGKK4dKklWhnwwPfR9Pq4K6QWfrpo9yWg2aQgphs8NG9CS763OEEQ0E6BsBXQHmxDRAOVV5077vof6vSGenTp2VfYP9mv2DRat8XVEjE09eBAdV8Kww9JKS417QT8Qh0Z0WoDXgFhv/Hs05BASb339wgs5Rsl4lhtnx2vyJOFOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/9zsN+6wEbtY6Cs4mnF1dCp/A3RM5bYHtiERtYYSLQ=;
 b=ftdyDxQDfOGk/Qdu7Yh9sqJJP3LwNTkEOzGSjnw94ouK2nGYvj8Aq40MedItRLv99bYbjOrYlecNOWyHilk35sE11YwjJeqS3+Xeo4U92TcYvBavP3FWSBoRD5aX6iVBLOVh/ybzSJG9jcMY78ox7xT6B1X6LVQcWD6fjei8hKRpj8umJlv4kEvmn9SJIOmPGlPPCs2DE3RCFiAyu3FYz2aPORV2pYfGfMwzL+0rgd3q6VKy1mfEZpeXohezJnFQ0IpoXKoxhPrl6FDNVyaLqaMCpaz2yVBQ0nbCmnTHivG9h4yIYOhLcEtUq2hdYJXf47AnqYvSqqesUXfHM7QgdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7372.namprd11.prod.outlook.com (2603:10b6:610:145::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 18:53:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 18:53:20 +0000
Message-ID: <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
Date: Mon, 13 May 2024 11:53:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZkJIZdU2knEUJN7Q@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:303:6b::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca8d373-a9ff-49cc-5531-08dc737df4e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?c2owWkU0S0VKaVVKTVpBUEZoZ09MR0lWUm5YenRvbUkwZENrYjdyZnpuRUUz?=
 =?utf-8?B?ekRpeUJnbWUrOXlkaHNjTXhxY0ZEUGNwUGxOZm90WEZlaXpqa0d6ZVViajJz?=
 =?utf-8?B?T1NUeFh2eU1OL2RmeWlYWXRsNU5oOUVSSFVXT0dsd1ptRUk0NmlYaFVSNThD?=
 =?utf-8?B?eWNMdSs2ZkJPU0JxL3pDTE5KZEJCWFllYjdiV0tQZkZQc1lpZ1kyTTAxN29S?=
 =?utf-8?B?QzNiWW5BTUFsQVNaMzVITnJqdnJOZGJRY2pRMWl2K1FDWEhJeVVwYlo2bHQ1?=
 =?utf-8?B?TW5zRCtBNEIwREhyWk12Tno1YW9nejQ2OWJTY0Q4SDFib2NFNFFUUG1wbEtu?=
 =?utf-8?B?L21IdXZTb0xJNzAxVjRLOHJmV05oSWxqSGF5Ym05L3Yrd084ZUZXUndQczkw?=
 =?utf-8?B?My91N0dYRG9jWVhTVVdUOTJ6N2c5Q0xLcmdWaElSN0thUzFMTVBlR3JjeDJV?=
 =?utf-8?B?SGVCTXJsMnZlK1FaaTZhRkVCL1U3TVpKWi9tK1BKM3RiZlRnTk14djZHNEF1?=
 =?utf-8?B?ZUJWUWVlY051bnV4SlNnZ3lXZGEzbWFsNjhVaUU3cEx0YTRuRHYvL1RMQVFt?=
 =?utf-8?B?K1JWSDJZczJOS1lDc2VLOU5jNC9iL1JrRndaVWN2ekFNT0JyWWhoMkJXTnVY?=
 =?utf-8?B?ZXFJbTdMVlVjVWJndlQ5a2FvTWVmekhna3pYNzdIaWNwNldyU2V4VVNmcWJ6?=
 =?utf-8?B?M1RUMENrMWk0RDg5dlpUNmVwVmVKci8yTVpESCtTWDN4Vno0VElGYktnbzNz?=
 =?utf-8?B?dzlCd3BpWFRiQmEwZ0Zpd1FoVCthYlZlKytYK0NwWDdJRGkwRU5GdXdkam1S?=
 =?utf-8?B?RUU5a2E1WTFkYi9nMXFGcDZudFhzY1RYdmtnbHFGdWxMZGluQmFINlZwMVN0?=
 =?utf-8?B?cE5RcUMwSkpSbTNTWmFWZUVVZSt6cjBTMXVpNnZCTDJVdXJ4VTRrUjA5eDV3?=
 =?utf-8?B?bjhVY05rQ2E5RkROZlpnQUlXekM4UHlqejNESUp1WXluQVBkaTVJR1NMTHVs?=
 =?utf-8?B?aHlKTHBZRExmZ0NSM0wxcGw1UUw1dU9vY005emEvbG90d2FUQzBJSE5GN0px?=
 =?utf-8?B?a2psNDcxaDVYRXVmNk9GTDFxRUM4TVcwRm5FaGVsTmd3TFluNHllYS9yeTl2?=
 =?utf-8?B?TkpOWVpXZEVlSk13MWZKVjk0My9FSmtLTUpHWjZWTksvWHBNVENkSGk1TjQ0?=
 =?utf-8?B?OEFJQTFFdldEQzh2dW1SV010WVJtTlJvb3prdnBFZmE2em9qN01yNlRrVTB0?=
 =?utf-8?B?SlAzTGVsZWFVdkx4aUc1RHVYODI2WnlLNVFuZGtIZXZFbHZ5cFhIbUZ2ZXlr?=
 =?utf-8?B?Q09yNkhwNTMwZVNXd1luYjI4UnZhQ2liU0JRNk1acmtGTmQzSzZDekk2UVdI?=
 =?utf-8?B?QUlyM0tlTzQwbmFZMFZNV1pMT0N6NTBTeHUrZitpc1JDM051TGRZVDdNWnlJ?=
 =?utf-8?B?Tk8ybUpObk1wRUppZk5vQlRnbTZwaVZEMldIVlJTcWN3eWs4TDBnNGVJV2w5?=
 =?utf-8?B?ZzllR2NtdG9aNzh5MmxZRkcyNkVURkFNZ1dxakJrcmNBRFBaTGVsb0NKOUJB?=
 =?utf-8?B?Njhia2dDclNwcm0vdTdtNUpKWXA3czlzdE1WTkdHZUhVWDY1WC90WWUvNWJ5?=
 =?utf-8?B?R2tWKyt5NmwxRW9Jb1dhUUZaNk9wRXN5UFBLeG05R015dGlpL3k2dlB5SERO?=
 =?utf-8?B?Z1FVZzQ0N3dLZ2Raa2N1bzdVMW5DVHZSM1BrWTByQ1IyOUdlVENjd09nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3FlQzJ3ek9XYVltSHdmb3BtQTZyNVArN29BL1BvVXJpR3dQUG9raTZ1N2Jn?=
 =?utf-8?B?aHl2Uktqb2pudUw1S1BtbEh0Y3lsNndRd2pJRTM3ajRVSHpQcGZQZm83WUVT?=
 =?utf-8?B?N09Md0NYNnZ2L0hESGFWUi9lRDFHczgzTWZpRnRJWXE5WTVMdDlPWUFuazhP?=
 =?utf-8?B?aE5zaTB5N2hMSG1vRFlFK0JqbmZWNG9PM2pXUFl2YmcxWTcwN29jV2FlU0RX?=
 =?utf-8?B?SEFwb0YvNnRCbDVPUXlQb3RlVHlIZ29aNWJBZFhFNlR5L0djK2FnNHBBTGRJ?=
 =?utf-8?B?WHQ5MnZ3WVYyRlpteVhNeGphdUNwNFRLR0xBRUc0a0dTamtFZ0oxNFcySldt?=
 =?utf-8?B?NGUraUxvSDlxOTNxNm0ydnVGUWhWMzFrWnhZTEZuYVUrTGdIWkJmcWwzbHhm?=
 =?utf-8?B?TFo4VWZVdUNYM1UwTXJ0NUlDZGluclVKdlQ0ZFljNlBJZWdJTW9iSm5ZL0VR?=
 =?utf-8?B?M2JNZmR2QXk5MlRqMWZERkt5Mko5bnBVSm9aMnk0dUQyVjFQajRrdTVYYWU3?=
 =?utf-8?B?SVdYYUhlNmJXK09RcDRvTTEwNEJ6SndnVk1kdkdscC9WazJJUUVjd2hmMVBx?=
 =?utf-8?B?cU5xL2xjaVA2a3VkcFk1aVlRNEVJT0ZlWjBMNzVMc3Bzd052QkJyTDNtVUFD?=
 =?utf-8?B?NVhKZUFVUDFWS0hUUTJBMGhtMVdVSnVzZHIrZHl3Ynd3MlVnKzRxMlJQcUgx?=
 =?utf-8?B?b3VLRG1XUXZQS2RJYXBES1lSQTJrbURDODQvVTMydVlSb2tEMDMvWEFKYUwv?=
 =?utf-8?B?L0hTNXl0czU2cEhxOVgzVXR3Z203cVJwR2VWdFF6My9Vb3d4d2ZrbGpueUZE?=
 =?utf-8?B?K1lGa2lQMVBsVUtndzB1czF3V1FQb1VEY2p1QWRXUkhjOEtSMWJHNG5CVnlz?=
 =?utf-8?B?RXg0NFRvckVtcDg4TTBWVndiblA2U0d2akNUSEd4SU9zSVk0Mmc3Q0JsalBG?=
 =?utf-8?B?OERxRnV1eVY3WVBmRW5yLzlUbm56bklNbzBTY2g2cXgwb1FqRFpLdEZBdVRj?=
 =?utf-8?B?eDNIbnpIbEtBMlIzVEMwTnVQREVRT1hUV1YzdmJxWmwwOVBsdUF3V2loNXkr?=
 =?utf-8?B?NGxXd2xSK3ZycVYrVDBuWmRwMmJ3dzRDNFo2cHNZQnBnVThKb0pKYm5qeldV?=
 =?utf-8?B?TU5YQVVxWS9CTnErTXZjdWVibVZNcTVUTjJwTDRncEdrV1V0QWNscTBhU1ZD?=
 =?utf-8?B?NkFSeG9rd0pzSkdJWHd1K1dqNVNYdHdOaFdvbVZ6RmY1bk5wU1NFVlVoMHFH?=
 =?utf-8?B?ZXE3bFYxeGZGN1RlOVYxaW9tQWdRb0NUUnovR3dEb25vWFZ6Z1dBRDR2NFlS?=
 =?utf-8?B?OC95Z3NkSis5NnAzbjRsdENHMDl4S1JaZGVXVXNtZEZxS1E0ekdNSklFTW9Z?=
 =?utf-8?B?bFJjbHB0dnVscWZKUWJZVDFGMDdYaFE4a252bnE2aXZsckgvUkg2UzFIRTdj?=
 =?utf-8?B?WVBNS0JxcUNLVmpDMlpDSTgwTVp6SzRhUHVuT2xrVWxNS3BHeWorR2IyNDlM?=
 =?utf-8?B?Y3VNYXJHQ1BCeWFoa1ZhSVUvQ2tYcDM5MzBxL0F1VmZOV214RWlVQmUwVUlR?=
 =?utf-8?B?bTJadWtJZ1U1OWdPa29hMDg3TVdDN0NsSVJBUzRPb2ZIOXFzNEtLcGo2SVMx?=
 =?utf-8?B?T3hWbHR5UTQxR2pIRFZ6N0ZESHlla2Q3T1BLT09uaTNiRE1aTXFPbUV5U3ha?=
 =?utf-8?B?MWl6Y3VnNERjWnJ1ZFR0QVlHbUtxVU53OXhzWjQ0WTdiZTA0Y2c1WkRnQXdY?=
 =?utf-8?B?ZEJxd0pkLzB2YUVRTnlwaTB0ZmpFL0pFWjlJaUp3cnNya0pKZkM0VnphTkRZ?=
 =?utf-8?B?UU1mVXdaTk5uUkRnNTJ3QzFuV1dBdkt5Y2EyUktvaHNFVTR1YkhRWVJmTzJL?=
 =?utf-8?B?a2VpZFFvRGpja3dBL0lRVG1NTGFTcWdyZk1MQkoyRlVocFNJSGYwTlJzeDBM?=
 =?utf-8?B?RGdWQ1VWYUxDWlI5b2NPYjdML1kyNUg3eHRGbG14dFZpVkp0YkhVS1lyeFJH?=
 =?utf-8?B?aGlvYXlPSWd3bXhnSHgyU21VNlNrcVF3OC9GN296MStTV2lpVWQ5U2xISUF0?=
 =?utf-8?B?TGFzU0E2VDVyOXY2TzMzbGlSR1hSRzlPbzFLTS9zUTI4MnA5eHc0TEZ0bnlR?=
 =?utf-8?B?OVhUa2xtTUVjb2RSeE5KWkY4RXZIelVmR0d1K3JrYTBQaGJ2WHMyKzJjRy9z?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca8d373-a9ff-49cc-5531-08dc737df4e4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 18:53:19.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ub7ZTwMf3uhkuDDnxl8HjeDDZD3QgcHUEer9XmROlDfPsU3sulqRdHRkd8c5tl4NbfaKRu0QVNXvCnAf1eTBWEzYT9qaTrkmbM4egi9oPB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7372
X-OriginatorOrg: intel.com

Hi Tony,

On 5/13/2024 10:05 AM, Tony Luck wrote:
> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
>> Hi Tony,
> 
> Hi Reinette,
> 
> Thanks for the review. Detailed comments below. But overall I'm
> going to split patch 7 into a bunch of smaller changes, each with
> a better commit message.
> 
>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>
>> (Could you please start the changelog with some context?)
>>
>>> Add a field to the rdt_resource structure to track whether monitoring
>>> resources are tracked by hardware at a different scope (NODE) from
>>> the legacy L3 scope.
>>
>> This seems to describe @mon_scope that was introduced in patch #3?
> 
> Not really. Patch #3 made the change so that control an monitor
> functions can have different scope. That's still needed as with SNC
> enabled the underlying data collection is at the node level for
> monitoring, while control stays at the L3 cache scope.
> 
> This new field describes the legacy scope of monitoring, so that
> resctrl can provide correctly scoped monitor files for legacy
> applications that aren't aware of SNC. So I'm using this both
> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
> or disabled (when they are the same).

This seems to enforce the idea that these new additions aim to be
generic on the surface but the only goal is to support SNC.

> 
>>>
>>> Add a field to the rdt_mon_domain structure to track the L3 cache id
>>> which can be used to find all the domains that need resource counts
>>> summed to provide accurate values in the legacy monitoring files.
>>
>> Why is this field necessary? Can this not be obtained dynamically?
> 
> I could compute it each time I need it (when making/removing
> directories, or finding which SNC domains share an L3 domain).
> 
> 	id = get_domain_id_from_scope(cpumask_any(&d->cpu_mask), r->mon_display_scope);
> 	if (id < 0)
> 		// error path
> 
> But it seemed better to just discover this once at domain creation time.

This may be more clear in the next version?

...

>>>  	/*
>>>  	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
>>>  	 * with a valid event code for supported resource type and the bits
>>> @@ -207,7 +198,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>>>  	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>>>  	 * are error bits.
>>>  	 */
>>> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid + rmid_offset);
>>> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
>>>  	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>>>  
>>>  	if (msr_val & RMID_VAL_ERROR)
>>> @@ -291,7 +282,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>>>  
>>>  	resctrl_arch_rmid_read_context_check();
>>>  
>>> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>>> +	if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
>>>  		return -EINVAL;
>>
>> Does this mean that when SNC is enabled then reading data for an event within a particular
>> monitor domain ("node scope") can read its data from any CPU within the L3 domain
>> ("mon_display_scope") even if that CPU is not associated with the node for which it
>> is reading the data?
> 
> Yes.
> 
>> If so this really turns many resctrl assumptions and architecture on its head since the
>> resctrl expectation is that only CPUs within a domain's cpumask can be used to interact
>> with the domain. This in turn makes this seemingly general feature actually SNC specific.
> 
> This is only an expectation for x86 features using IA32_QM_EVTSEL/IA32_QM_CTR
> MSR method to read counters. ARM doesn't have the "CPU must be in
> domain" restriction (as far as I can tell). Nor does the Intel IO RDT
> (which uses MMIO space for control registers, these can be read/written
> from any CPU).
> 
> We do know that those two MSRs can be read from any CPU that shares an
> L3 cache. It would seem to be pointless overhead to force a cross
> processor interrupt to read them from a different CPU just to satisfy
> a "must be in same domain" non-requirement. I'l split this into its
> own patch with suitable description.

I did not suggest that this should be done with multiple IPIs. My comment
was related to this addition that claims to be generic but really just focuses
on support for SNC. Any  future addition that may want to build on this would
need to be aware of these expectations, which are not obvious at this time.

...

 
>>>  	return 0;
>>>  }
>>>  
>>> +static u32 get_node_rmid(struct rdt_resource *r, struct rdt_mon_domain *d, u32 rmid)
>>> +{
>>> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
>>> +
>>> +	return rmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
>>> +}
>>> +
>>> +static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>>> +{
>>> +	struct rdt_mon_domain *d;
>>> +	struct rmid_read tmp;
>>> +	u32 node_rmid;
>>> +	int ret = 0;
>>> +
>>> +	if (!rr->sumdomains) {
>>> +		node_rmid = get_node_rmid(rr->r, rr->d, rmid);
>>> +		return ___mon_event_count(closid, node_rmid, rr, &rr->val);
>>> +	}
>>> +
>>> +	tmp = *rr;
>>> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>>> +		if (d->display_id == rr->d->display_id) {
>>> +			tmp.d = d;
>>> +			node_rmid = get_node_rmid(rr->r, d, rmid);
>>> +			ret = ___mon_event_count(closid, node_rmid, &tmp, &rr->val);
>>
>> If I understand correctly this function is run per IPI on a CPU associated
>> with one of the monitor domains (depends on which one came online first),
>> and then it will read the monitor data of the other domains from the same
>> CPU? This is unexpected since the expectation is that monitor data
>> needs to be read from a CPU associated with the domain it is
>> reading data for.
> 
> See earlier note. The counter can be read from any CPU sharing the same
> L3. Adding unnecessary IPI is pointless overhead. But I will add
> comments.

I did not suggest to add extra IPIs, my comment was related to how this
feature wedges itself into resctrl.

> 
>> Also, providing tmp as well as rr->val seems unnecessary?
> 
> I think I was unsure about modifying the domain field in the struct
> rmid_read in the middle of the call chain. But the original caller
> mon_event_read() doesn't look at rr->domain after the smp_call*()
> function returns. I will drop "tmp".
> 
>>> +			if (ret)
>>> +				break;
>>> +		}
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>  /*
>>>   * mbm_bw_count() - Update bw count from values previously read by
>>>   *		    __mon_event_count().
>>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> index 0923492a8bd0..a56ae08ca255 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>>> @@ -3011,57 +3011,118 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
>>>   * and monitor groups with given domain id.
>>>   */
>>>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>>> -					   unsigned int dom_id)
>>> +					   struct rdt_mon_domain *d)
>>>  {
>>>  	struct rdtgroup *prgrp, *crgrp;
>>> +	struct rdt_mon_domain *dom;
>>> +	bool remove_all = true;
>>> +	struct kernfs_node *kn;
>>> +	char subname[32];
>>>  	char name[32];
>>>  
>>> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>> +	if (r->mon_scope != r->mon_display_scope) {
>>> +		int count = 0;
>>> +
>>> +		list_for_each_entry(dom, &r->mon_domains, hdr.list)
>>> +			if (d->display_id == dom->display_id)
>>> +				count++;
>>> +		if (count > 1) {
>>> +			remove_all = false;
>>> +			sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
>>> +		}
>>> +	}
>>
>>
>> This seems awkward. I wonder if it may not be simpler to just
>> remove the directory and on completion check if the parent has
>> any subdirectories left and remove the parent if there are no
>> subdirectories remaining. Something possible via reading the inode's
>> i_nlink that is accessible via kernfs_get_inode(). What do you think?
> 
> kernfs_get_inode() needs a pointer to the "struct super_block" for the
> filesystem. Resctrl filesystem code doesn't seem to keep track of that
> anywhere. Only mentioned in rdt_kill_sb() where core kernfs code passes
> it in as the argument. When registering/mounting the resctrl filesystem
> there's a "struct fs_context *fc" ... is there a function to get the
> super block from that? Even if there is, I'd need to add a global to
> save a copy of the fc_context.

hmmm ... I expected that struct file or struct dentry may be reachable
from where sb can be obtained but I can only see that now for the
paths that provide struct kernfs_open_file.


...

>
>>>  	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>> +				struct rdt_mon_domain *d,
>>> +				struct rdt_resource *r, struct rdtgroup *prgrp)
>>> +{
>>> +	struct kernfs_node *kn, *ckn;
>>> +	char name[32];
>>> +	bool do_sum;
>>> +	int ret;
>>> +
>>> +	do_sum = r->mon_scope != r->mon_display_scope;
>>> +	sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>> +	kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
>>> +	if (!kn) {
>>> +		/* create the directory */
>>> +		kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
>>> +		if (IS_ERR(kn))
>>> +			return PTR_ERR(kn);
>>> +
>>> +		ret = rdtgroup_kn_set_ugid(kn);
>>> +		if (ret)
>>> +			goto out_destroy;
>>> +		ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
>>
>> This does not look right. If I understand correctly the private data
>> of these event files will have whichever mon domain came up first as
>> its domain id. That seems completely arbitrary and does not reflect
>> accurate state for this file. Since "do_sum" is essentially a "flag"
>> on how this file can be treated, can its "dom_id" not rather be
>> the "monitor scope domain id"? Could that not help to eliminate 
>> that per-domain "display_id"?
> 
> You are correct that this should be the "monitor scope domain id" rather
> than the first SNC domain that appears. I'll change to use that. I don't
> think it helps in removing the per-domain display_id.

Wouldn't the file metadata then be the "display_id"?

Reinette
