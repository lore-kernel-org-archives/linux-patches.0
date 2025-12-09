Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89F9306D54
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309423; cv=fail; b=k89XkGZSDotklP8dZNtky5ogQUzCf65quQTSrkUrMSwHTOd+uEl8ujQJ7c3XWlL7JGDK++LxXIiuUqMtf2fiF845WjvSFP2MrrCdyrkyXrUaDOwmBZLYcSq30Fmb4jiDkmBTeflWG3Q2zULEBvFLJiqlIxoknK4aboDtI7Atvd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309423; c=relaxed/simple;
	bh=V5pKpL/LHEoIziT2xx3K7QECBfS857bRqU2Tv55yKTg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ty+yYBd8p9157DLs0/FR6mTr39tu4mMIr/wHeBcGlaM1fjf6quZaobZXRTUgOSzkpVDG4uDH6MevHBfKlH7bE3dTmZZiIgzGrnmi5T2pwN5ed+P5VGrxKPGGRIyxVW3kcrNxkIekxPD0e7rpyc2FAJNw475KYzYOt3v6PBeiVHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gc6msSF7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gc6msSF7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309422; x=1796845422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V5pKpL/LHEoIziT2xx3K7QECBfS857bRqU2Tv55yKTg=;
  b=Gc6msSF7pslGAZvHr1zR00EDUBTfrXud0QyiXjU14utCMwXfPVFB67QD
   cCulBRtox8gx5QW/cUYzET4U/3V6qMdMPmGJA0JhDe8Oz0TOb/KvfP+oq
   Fef62BbRsHl1yiONeqs6EewKFTV9KCMfAualFT3sOQVFsKQflQKZ5eUDx
   0wrtSSWprSGLNTkrvrhb5bXlTScUZHsYpK01VjkOfFOFoSgP6+Q7KnSNj
   8Giyqp/FJMniBVAaQZoW0/Whyxj+SZ3t99ioeyJrH8qFIO3jCYgfa/qKo
   ELrbKgOOMQ4afcpJqdiKT8JWv4pXEnX6q1g45r/nUw99gdQzjBDkXjG2K
   A==;
X-CSE-ConnectionGUID: eZu0QB2zRFyiPCQXjhPYTQ==
X-CSE-MsgGUID: BWaYXsIzQAmZRNjcSFgshw==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="77595485"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="77595485"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:43:42 -0800
X-CSE-ConnectionGUID: jFH+XRO8RVynAe09qO/BfA==
X-CSE-MsgGUID: C85qNzahSae+2Z1646j47Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196354634"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:43:42 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:43:40 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:43:40 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.60)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:43:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYC3NUpcRqHaoFn+k6huLdVt8ChY7PfvoBA0O/ty1JxeyyZK1B6FdT7jG8fQa9LLT9XIdNzogZSukvHYKT0dvH7AiIow2Ctt/ZJ9Co30gE/H2rXfazRYWsdKvVSZyO21W1Ua6dMlz4aNSB8CXQPBjlMDz/7PgJVFQpn6cU8Yl5AF5x6MehnxMygn4InSPi+FXLtTzLL4D+SwIgCucVH1NA3sM/ar8hExe4aiauRbAHM0ANseXMho8A3W04+F1bbsMJi/qMCF+lqa/iFmbNKPX4KC0uXKzp+GeD6q3yZePXnyWsODxoY0vC+o2IC2lbwesrfqKL+UXHIvOby5S3SCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vKmIFZmNyYbFOJ9zDrm/cfg5PWLXuveXx4xHHQQQTI=;
 b=rqqgjaqVdCyVd+5vYUd24q9o2W7Wy4ZRktvW2i95dl0W6GBYeTfvJy8ZhLhczgr7fhuavOsfzD527/rQ8rAgRh1o7lQVDU17/0dXM6WC7EdaigHH56YiUxPTaVAZcErDE1qiU2Mqfr7lgxyuZrsUg+kpQuNKOsD4pPxvH/nuBL8If04Qx7c6S0ayGKvmhtYJRBsPONG5GXLXqZ81Q+ZTt2MuqyNN9nvyWTN/EayjaxibC9xZxeRFmIX5lXbTQ2Oe0T5Kka7YWT14jWj6AmzwhP34KDXmererdkcnxwq6wOCSBJGq6wM4Lgfde0t7HuilSye7gdyrmELcl3ngjYr8XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8152.namprd11.prod.outlook.com (2603:10b6:208:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:43:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:43:33 +0000
Message-ID: <e0c88658-6724-4307-8719-d94d2b65dd3a@intel.com>
Date: Tue, 9 Dec 2025 11:43:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 32/32] x86,fs/resctrl: Update documentation for
 telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-33-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-33-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0125.namprd04.prod.outlook.com
 (2603:10b6:303:84::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: c70901be-dbac-4606-f15d-08de375b3ca1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RE5yOHpxSU5QOFZhSkQzVWU5VGRYUzU3MUxZWE5sZnNvbnVNenRyVGR2UWlD?=
 =?utf-8?B?dDhKb2RxS09kdzRvU2NUbTd0a0lvVXhxcTlzaWVCZEd3OFRpdU90dXBLMUdu?=
 =?utf-8?B?amRVYThxWXBCdGdNUkgzdDZ4OEhSNnlPQ3ZJNWZOdkxIOEVrSndSaW5DZHJ0?=
 =?utf-8?B?SmduTDhUeTVSS1hOTC9QcW5pbzNhZU5GbUpNSk5TY01FOUJUTnQxVFc0Uzkw?=
 =?utf-8?B?VktLQ1hxODI2d1VBYlJodTlpMFFENEFaWisrbVNoUTd4aithU2lmZEpuTFhQ?=
 =?utf-8?B?WjFrQXpseXNGN3JaaDNLYW9ZNG5uOTRTVmZlWGliajhWMFNUeks5UW1jUHhy?=
 =?utf-8?B?WWcreTdUdnFNWk9iM0padW05ZXc0d25XYmlDaWd0bkZjSGh4M0d4ZXlQdUs5?=
 =?utf-8?B?UUtJdnhwYitVWE1FMUg1WnlwcG1oWThlVDNFYWE2YlNjb2pONnNRUnVsNjE5?=
 =?utf-8?B?bzAzTGZvSkF1WHNpajdhckg2L3lnS1JvRllaNm9sTE5GNGxGU0Q3enB5TjJY?=
 =?utf-8?B?bmp1bWJlVzhvWDVhYWNnZzRBY3h2eU9pVitQU2p0MVRhRnd1UWUrR1YyWUJ0?=
 =?utf-8?B?Wk8yNHM4aHlmZm96M1JRbVViNklXbmRxWUl3Yi80TXZTN2VCM1I3bi9UU1Ba?=
 =?utf-8?B?Q2FpZmJqbnRQZHk4M3lXZG9tUUJOVkhqNDNzQUJTL0lQajJJMkF3cVhOWWQv?=
 =?utf-8?B?bHIrb1Uza0Z3ajhvUGFXSXBJbUdrdHl3SGdLelAwNVNKQjA2My93RHY4YVBT?=
 =?utf-8?B?cVBWQ0ozd1Awd01MK1FMbGZheHRuUVdIS0FhVEJtNkVJSGU2OHFobVBXelpQ?=
 =?utf-8?B?TW1mc1RobFh3M2JnVzBuaXQyTHZrMG9iVmJzcU83L2FPUGhaWGJmS2R6QXRO?=
 =?utf-8?B?V3pUUXdsV3VNY2NyektFV0x3cVVGdDM1cnYvUVVVdXMxS3o1eXM2RnNDTkoz?=
 =?utf-8?B?TmV4RlZWRnlZSjFKbGp3czh5eG5QaUZPOXVYMTlZNmUvMFJvZ2doalltT0lt?=
 =?utf-8?B?T3pWNkx1dHdDNlE2aUFQb1BlUE8wbGplS1FodlZnUE12Qm93ZSthTlBIcmxW?=
 =?utf-8?B?VVh2eEE4OHlpUG0rYU80dzZwSjF1ODcyZ1c2V0JqNHBjdXQrUlcwU2hiTEFz?=
 =?utf-8?B?dmRMZTlUKzZ3VkRnUFJRMmdkS0FUS2pFOVB3NCtxWW5Kb2hlNVJXcm5RZ2Rt?=
 =?utf-8?B?NTJiYkNkb1Qrcy9rT0RuOTNVaUhtOEpQV0l1NFNGQkxFMjV0V2JlQ0pOSXZQ?=
 =?utf-8?B?cmVERW5EaktxQUJEU2lidG9VYndEZFlGVUFXYTNXbXJ5ZWw0QkJtUE5ubDVD?=
 =?utf-8?B?U0ZwUVM2bzdDakUyVlpiNFZDRFRqdW1FU3A1R2FBOUI2ejJEK2grMEZzMnZ0?=
 =?utf-8?B?WTFmSStFL21nSHVSNDZGMnJIc1g5c1dLWVVoMk5OM1lHekpEVVlpaDJlT0ww?=
 =?utf-8?B?SUZ3UGlFSUZQWHJ2WFpzYUNBV2FFOVJGSGlLM3FFOTg2U2kwdC9LR0R1ZlZn?=
 =?utf-8?B?S2h4Z3laRG5jcVBqQWVWRnlQeEp5OE1WWUJtTGp0V0V2dStjdTdyRk04eXFC?=
 =?utf-8?B?UXg5M2NBR2ZIdmJqMkd4NU0vRnpaamRBT084MVVqZWx5b2tValdZZ0dLUktM?=
 =?utf-8?B?STErUVlja3U5NEw4aW1mMEdveFY4VVJBWTBFbUFLYURJVUdmRU5tM2VTV1R4?=
 =?utf-8?B?MitObE5kenhzTGpVc2U5czFyNmFHNFdyYmx0T1E3VmZRdDB1bzVrSTNlazFI?=
 =?utf-8?B?dXVEMFBwRDdBWEhTMndUU1lwQzVNOXc0eDJFV29SbjNLdnNFbC9PbGZmbVNp?=
 =?utf-8?B?ZzMxNDdQczZDbCtIcnhNYTU1M0x3Rkk1RTZQK21vaUVLTzRNcWp6NDVvbEhW?=
 =?utf-8?B?OUVBOURRazQ0amZiUkVIOEpnc0hNU1VxdnE2bFFiMVA4SnlYdGs2d3FYa1Jw?=
 =?utf-8?Q?8J8iG53EEWIhNoiePGdQQyiJnQc85S/k?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFNQc253eUR0OHZabDM4U1QxbmlvR1EyMW14NFZ3OURVZGV5RkczRklnaGZF?=
 =?utf-8?B?ZjNYUldYL254MzlTcDNSU0lZdEJxdUpXWHJsQzkrV1NzZHJ4eFlTUDZMSDFk?=
 =?utf-8?B?UUU2Y3FTc1dMZ0xoRHNBWEVQVk80emhMMDZpaWkrVTBXTVJGTnkxK0dsQ0tM?=
 =?utf-8?B?bDY0MjFWZWxmUlhJNjlvRDVRTE1UVmVrMTdDaW9Mb0I0Y3pyUGl6MDFRNzgr?=
 =?utf-8?B?U0pkQ0NjMHd5a1JjV3k1UzhNdFBQTVVjb2VGWDJPc2FEalpEK1VXalhaY2lq?=
 =?utf-8?B?ZkZYLzhKcGJDYzNkNVhENkpESFpBS3JGR2dRSENLU2x4akg1dEtQbXNMWk8v?=
 =?utf-8?B?NHA3MjZGYTYxZWh1QTJMaXdHM0tlQzJCNi9QVFNEWWJoU3NvVk5ldm1IYith?=
 =?utf-8?B?UXNmVHFqTzR5ZnBVV2R4bkhPNFJiRFBVcEExakRQakd3TGx3U0Rjem5TQ1Ny?=
 =?utf-8?B?Yk5jc1Y0WWxwSEVOUmtJYUlaVndiK3M3dnhaMVM3QUd0bHhWVnhYYUhjU2ZT?=
 =?utf-8?B?ajBxTHhmbHhjQXd0bFd6WW9yS1crVkdkeWZvYWFzK08yRGpERllvaFJxSURk?=
 =?utf-8?B?TnphdDlkNmJ0QzYwRjRHcDk1NjJUWEZWTFl0anB0WE5seU41NklVVVg2dW9m?=
 =?utf-8?B?TWozTUVCK0pmMXlBU1lnTktGWFBiY3hsei9oOC9sVkRaZDBWcmNqWTdNeWJO?=
 =?utf-8?B?SGc4Y0tOUXdMMmM0MnhyMlNJejhMMG51VExWL3JpbTJWNDlWRS81RWc2V1lJ?=
 =?utf-8?B?N1hLL3l3eHlWMW9aK25WMHJYUFNqbWNRTER5Q1VRdkZsdEZtRGpFVDBPeTlx?=
 =?utf-8?B?d1NZMWN3Sk5GbmR5NzdkZGRpS2c2RFlJUEhxL0xpd3c4dFhWQjdRZjNLOXow?=
 =?utf-8?B?TVlsNEZtUmh0WThxUlhvdks1ZjFSdytsK3dXMHV4SERhRDg1M0VubVdJMVdV?=
 =?utf-8?B?WUpDWGFIeEZQNmcweDlLOFMwc2pNT3FRS25XT1VBc0ZiRWxWVUJvT2VlVkRv?=
 =?utf-8?B?RUpXS3dENTRxVFh3N3JJSG8rQ2hoSjRuTlc1RC9oMXIzRGVKSCtuS1htV292?=
 =?utf-8?B?cVI0U3FERElENDV6bHVZck1rZ2FQTGFPWUR2QWpnN1daTGhkdURjZ1dTaE8w?=
 =?utf-8?B?VGp1TDgxNTBreXNmZ3pJWTI4cUxaSlVZWkwxemI2RGRJZG1vemFvRXhMOGlw?=
 =?utf-8?B?cWhHRTZqdm5lbmN1S3NoK2NjbUh6cTY1QkpZQlVEWEc2VFFlN210M3ZPeDVy?=
 =?utf-8?B?TlJNdE1ubE9QTFhkNXFBZzlZWURnRWFrT1R2VGhaU05YcE1SVGo0STM1VlN0?=
 =?utf-8?B?dHVXQnd3RmFadGZyclNGZmp3Z2RMOXRVNVgrcHloWlk4QlpFVzhSeENnWGJr?=
 =?utf-8?B?cDByR1h1bmw2UzVqSlhIZVJQWS93MHVJR1ljMklaUXlpT290dGNmV09FZ09H?=
 =?utf-8?B?STlsOFhpeXh5a3R1d0JSbFJjTm5CY0c2T0ZKTWFpdEU5Mlp5S1ovQkZBbEhH?=
 =?utf-8?B?SUdkd1RsK2s0NFZVL21pQzlhQy9BcFFOZDNGVE1JNmo1UFV6eVpjTWQzUlR5?=
 =?utf-8?B?Q3dvTk5wQU9pWnlHRnE5TzJ0RnRVeEpUY2xPbmFBZkN2clBNaWZiOFY5UktV?=
 =?utf-8?B?RlVvQU4zSFhKM3lTejJuVUtKejNoMEUwSkFTb1hHZWxOa0FNYWE4a0QyazJF?=
 =?utf-8?B?K1hSbnBqbUFQT0hJWmMxSzlieEdKdFlDWGhBRExXeTV5MFREUVFPM2dZNnBG?=
 =?utf-8?B?L0MwYTZOdUVlakZBdWtONTNsdEN3cmFSWkZ2Sk14REVtRzFUQ01iRll6YWtL?=
 =?utf-8?B?bzRKMEFob3BTZ2dhYzNnN2txVGhKVjVtNjJJZ3NFRUtnaVVuenJSQkp6UC81?=
 =?utf-8?B?Z01NK0ZNVGVJQ05EVE96aHlkZ3JFYWZQc1MzeUZ6VVo3RitXS1JpeVdkSk9s?=
 =?utf-8?B?RktabjFGZmpUYyt6ZXc3VnFwQ1NuOVorZ2kwUFduNjNMNExUNlJBY2w2NVRj?=
 =?utf-8?B?UXk4NFQwMlZFVVdLa1pUNzFBWEFIazU4bGhldFNzSG9rV1g2MkhVQ04vdHNY?=
 =?utf-8?B?K1JFcFFQK1JIekpQaXdMeVpYRkh2YVY1ekZOVG1XWjZGTnlZMDJiOVdRVHNq?=
 =?utf-8?B?Y3c0bERjZTg2MzJ2TDd3Q0k0WU5IbXFaMSs3MnJIOTcrOHo5d2lmbEtYVCtZ?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c70901be-dbac-4606-f15d-08de375b3ca1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:43:33.3661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rb1VnR2leL6sjn59ZIbNpGpIfPSW3l5xrxF86R7fKfydYs7nA7/j7rGFTGawD83sGuqnAKnybuWQ5XCOJbJ336jfP4GogDQuK+6tLNcl4Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8152
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:54 PM, Tony Luck wrote:
> Update resctrl filesystem documentation with the details about the
> resctrl files that support telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 102 +++++++++++++++++++++++---
>  1 file changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 8c8ce678148a..5418ca72bed3 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -252,13 +252,12 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":
> -		The number of RMIDs available. This is the
> -		upper bound for how many "CTRL_MON" + "MON"
> -		groups can be created.
> +		The number of RMIDs supported by hardware for
> +		L3 monitoring events.
>  
>  "mon_features":
>  		Lists the monitoring events if
> @@ -484,6 +483,25 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be a "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of RMIDs for telemetry monitoring events. By default,
> +		resctrl will not enable telemetry events of a particular type
> +		("perf" or "energy") if the number of RMIDs that can be tracked
> +		concurrently for that type is lower than the total number of
> +		RMIDs supported by that type. The user can force-enable each
> +		type (or individual guids within a type) of telemetry events
> +		with the "rdt=" boot command line option, but this may reduce
> +		the number of monitoring groups that can be created.

Same comment as before. To make this easier to handle I suggest this is split into
resctrl fs and arch parts. Consider, for example:

  "num_rmids":
		The number of RMIDs for telemetry monitoring events.
		
		On Intel resctrl will not enable telemetry events if the number of
		RMIDs that can be tracked concurrently is lower than the total number
		of RMIDs supported. Telemetry events can be force-enabled with the
		"rdt=" kernel parameter, but this may reduce the number of
		monitoring groups that can be created.


Reinette
