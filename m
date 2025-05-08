Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF3027A44F
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719934; cv=fail; b=iQVQ8X6Lr3cGG5fJHa/1QxA5ljVP5fqBLeHzirFJSxPENWDvLO7qMHl0XTbAE3kjEchIPMIDCkA/45xGtEZw5KSvL2dzJ/SUzJDoQILo2jzX3K2zHtcgUi7EnhjLMJ4j5u4FAIHH8kpNEZwmBQSRsWu7G3JmsiTWxgbP5TazwKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719934; c=relaxed/simple;
	bh=9pVRuxL/y0IYsLP8Ege8rZyTfnJlUIlYe1O4w6gc4Y8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=emtrZ8XbHBBUq1TUWl2HbCAk76uLzAQQuC8M+YDxR+4FUJhFWj5VijCzxZdCPtiradM9+jfb+1BZDnGR8JpTWGBUckZGmefGySexg1m0P1hmeIUGhVDxQQrfSeo0KO1QMAv57YyNcasKY1fvJwqCx2TCxIA/Msxbyxtox+WiNME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDRBOZ2a; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDRBOZ2a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719933; x=1778255933;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9pVRuxL/y0IYsLP8Ege8rZyTfnJlUIlYe1O4w6gc4Y8=;
  b=bDRBOZ2am6G2koYvmEmgzsEtFb68ImVKXcFC5r4Uoi4jvFaq7CCSZtz3
   QCFolI+cQ+LRGTlKU3dnOyObKBimkHgdGnXrWFo3NmxGOVZ+BZECi2csK
   u56Lf4oKvhJwPxeOeV5upIrtXZdY2Dw9PjrPT1PuiE54KJ/iI27XLyyrS
   88EMZcZ8UbLCJ6pLkCuQ0a4r2m5Q9hZDYzrhzw4nSjeAh8ulS9hKM/jTt
   9xJD2phHcE6sQOzoY0il6su7FvBgvUtr+Ev/RLcWn1Blk5BKzYwtcyTN3
   Xybc1V/SvPtwa/sOvRQIYRll9F3PwQ5TqkDw4eQqj7GSs3aRQjHNZIZDZ
   g==;
X-CSE-ConnectionGUID: 2jQnxHgRT1ima+CwE95ocQ==
X-CSE-MsgGUID: SIsMI9LbTZyJCCVDA9b1RQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48423753"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48423753"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:52 -0700
X-CSE-ConnectionGUID: 7fD++M8dQDuU3RNMIC+nRQ==
X-CSE-MsgGUID: aSTm1gm1QmezRJ8pyt6MmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137271741"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:58:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 08:58:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 08:58:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 08:58:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2JC9ku10bK82c5dyOK5eQVsIWWa7vIoMYPl7AIEvrcwmWAmiYOGBZMj9BHJ5jRNcoOBOm6GCKjPVGo8wsnwZtjLgg/F3/i3sqaefzYF3ggFA67FZd+tBknPdemuqKNxAT0kRaYD1M0/DI7mZP7LFRjrnMKf2p1pZPABQgkiDsfH+TZXtoxexHU8xeIFcUXdxPswmPPEyBKCtZZT7jwz0y8WOIjXuv28KlyHVN1gBhEES21P6kSXgIOXl9erCZx9jgNzxbE1EEktu/ZdjuxCIoezMpQgYmNvpVAS55ejfdbFVlas6QLYz5hS6tbzTlF4CTiJ/xvDyHHCttNfWmGg8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F505shHZYfzGG41HK7GU0kYtvv0fbcADIPvIheCXqK8=;
 b=vo/iQqY2bKhhHeZkL9zLdKAz5SmAMWoHFftQ9Djuj1MGmvkBTLhzSIfm77zY03LKlb2Vlog0lTKM3Ls94ilgwbhEWGPlQSNcs6v/HclIZuglf4JWGxg4LuWnmnaI9zL9MUfOIAMQOKM7GD1ZxX1hpOq6Uq5e6u4Qzgk9Qev6JHKyNceT8zvUIrg+5le4w0berjqtZm4Fmwzr1J0u/jZsuu4+5V7LpmGSvqfVkoCo40d6OsoH+u2enDFIVqsTMGEme5O/q8nD/gArIon/irkmAcCwn63dmcF1I9Oba3KmMYdZyHpGwkhuWAgtSmwZOjIW3WzK8wKA4s7LYYZSPS7Kug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9057.namprd11.prod.outlook.com (2603:10b6:208:55d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Thu, 8 May
 2025 15:58:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8722.021; Thu, 8 May 2025
 15:58:49 +0000
Message-ID: <3f3f6b21-234c-4446-9203-1fd549fb0187@intel.com>
Date: Thu, 8 May 2025 08:58:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/31] x86/resctrl: Add energy/perf choices to rdt boot
 option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9057:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c8bd44-6683-45aa-734c-08dd8e4938d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z2p2Ti9FYjQrMHR1QWpkcDRaUnBRUEQ4aUh4dk1qQTY5eWI5N3BDWER2VHdM?=
 =?utf-8?B?anRhemhYYkU0SmRoc0lCODFJMHMwVDFXODZmTkR0TVROZUFYQnRGQlJiOFlU?=
 =?utf-8?B?ekZLaTFXMjZGaTVoRndzWjJrM2JGRXl1T1dydDMxbGxhcCsxS3E1aG1CUXRP?=
 =?utf-8?B?akRXTkMwZWNpUllyL0pYVEI5MGJHK1phbGZvdUhPb1Bab1VzYWlMdklpcWVI?=
 =?utf-8?B?VnF2djdUS0xUMVhnRmlVMTBxOC90MzNrcFVjTytnTlNqNHJSUmkybi9oTTRi?=
 =?utf-8?B?YVg3dzBqUG9TZk4zUi9OeGFGQndKOXdqSUZSekxUd0F5L3AwaThCa21Wd09u?=
 =?utf-8?B?NUNyOXArempDZ0FpZktmS0FMNkY5Qk5aZ2MrTlRPVGlVSUFWMlAvVjJ2UjM4?=
 =?utf-8?B?dEoxSGw0SnN5aHEzWlhCWVhuMjRWRHRETk8zSzNZOWNjU1VseUVIQ093UW5Q?=
 =?utf-8?B?d3ZGYTZZTUtWbUdVbU0vMzlYL2o3MGtzR05VaSs2czFqOERndmk5UXFNUkdi?=
 =?utf-8?B?dWJET1lxRDhzOSs1NFRCVmFDY21zd3czR09uL3BGNXdCa0NEdmlueTlkRXEw?=
 =?utf-8?B?T3N0T0lqWDB3SFJ4RGZtQzZFOE93R2tNdFZVZFNyWHJ6TnFPRHBGUHJTeTNH?=
 =?utf-8?B?YkdQOCtqU0k0cWhmMzIyOUp3RVVDT1lEcDhaalQvK2h2Q1UzWjVjRERZdVF6?=
 =?utf-8?B?bk14bGlKd0tsWUZ6eU5jeVdhQzV3V05zN2NTV1VmQ3ZDSjlDdDl2eUtkZml3?=
 =?utf-8?B?Q3MrT05wSVRDWHVqL1pmSXlXNkNPOGp3THFWbGxBakpqWllGZnZDU3lTT0g4?=
 =?utf-8?B?L2puWG15RWRVRWkxa1drQ0JzenpuY1hKbkVPZUN6a3ltd09tMnJiRHpNSHFa?=
 =?utf-8?B?RGpPQTJRdDI3cXVmSTgvdXUzcmdUamd5azZLVVlScGx6OWxUWEp3M1ovQ1p1?=
 =?utf-8?B?UDJlRjhsNWRIOGpUSkdkanVadXJwa0RKRENGZkZzRy8yZUFmRnJ4YTdPU09r?=
 =?utf-8?B?akZXeUFvb3lEekorN2F4YXJndERobmpEZU9zcmdTRnFwVzJkODFmU0JGYXNt?=
 =?utf-8?B?S2NkL1Y1QnFORStkRUZFd1czVFdYRW1uQ2oxOEVsNmFZdEt4SW1SMkpBNUpT?=
 =?utf-8?B?S0dxaHo4a0cwa1JTcUNrMjVJSU0rTXVKakdlV2NOQjBPMzhMamdKNWFmZFFm?=
 =?utf-8?B?YUpNZytoRGdiUDRxcVhGaGdrZFZOeFlLdHFQcGZpbXVab3grY2V5VEJtQ0Y5?=
 =?utf-8?B?dXZkOUN0UGtXSWlVbjQ1dXpHUVM2cTdZRGRtVU5VMmF6WFAyN2pGR3pRQi80?=
 =?utf-8?B?ekM1ZzZ4UllOcnV1Nm5HMVh6STBabExUVlZlaVlhMm9xdDlrcU1NN2NxZlRo?=
 =?utf-8?B?KytyS1VabGlBS0JIS2x0dEU1QWlJMVRsL25halRDbjRqcHdwQkN1WjNnUEZz?=
 =?utf-8?B?RG5DZFZCcjRPWDlkNjRBQkU5NmNoMUQ1Zk9sMHZxV01qazVtRzBtS1MzMEI4?=
 =?utf-8?B?bGkyVk5aZ1NSV2ZZdXhBQ1h6R0tNRnUzWVNCc05zYTN2TmpGc1lLU1dzQXRK?=
 =?utf-8?B?K01VVXFRUUhnUnJiWDMvTktGS1lUbzdHZFNDZ3J4U2l0WjNaNThuSVJtTnYw?=
 =?utf-8?B?c0NKWmZtRnpUcWgwZS9lV1NJNkx1cDV6YkxwcFZlMXBQR0paTkpOaDZJRFRG?=
 =?utf-8?B?dys5MjRISUJZR1VlZUNnTmlPZUNTY282MTV6Y294b2IwL3p6cWtaeGZTMHVx?=
 =?utf-8?B?NG5VS0VBV2ozZHZkR3FIaUtDb1REL3ZlYTJMWC93UDIxMXNxRTBLa3lDWFZG?=
 =?utf-8?B?bUswbDRpbzRNZU52Z2p4anUzRWRUMC8wTXIzT1pheURxTnBzVFIyUzJueCtl?=
 =?utf-8?B?Z3dUWXpibTRBSGNRQjVKMFBDSStRdy9TQk1KcVRxRDVCTWc5ZHFES3FIQ2ww?=
 =?utf-8?B?WWtuWFpYeGVzdytEQ242MkdNQW95ZS9BK3Q1TWF2YWpyKzV0OXBLWU5hM2Ur?=
 =?utf-8?B?OXBTby80bGxBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHJ2ajRXTUZZY3IxV1RMRUZmR0RSL2pQZ0FMNzZwVENlTHFER1FiQTczTnhV?=
 =?utf-8?B?SmJIMEhjTkN4VnVDM1lRUzNyL0dzVUFTZGRoMGZOMEhJdjJiYXB2NEJTOVhK?=
 =?utf-8?B?aEM0bjdNWWpQSDlHdWtkdWVzT3ErQmNNa1FXdEt4c1Q4bkx5RVExeitBZzU4?=
 =?utf-8?B?SEhNK3BqUDJ4R2M3ZnRpbkZnU2oyQnR6bGplWTRQbHp4SC9SMUZtVDJVcjND?=
 =?utf-8?B?b1VxYU1QM1BWd05yeU9HdDNHVlZEQ3J2cWVYditJWGdjVnNlQk5DaWNGWms5?=
 =?utf-8?B?ZWFZMHl2N2h3SEdObys4MlY1Q1dKS0JtcWpCL2pkL2JGbC9DdnFvM2ZmbXVT?=
 =?utf-8?B?emRreEpQblFyS05qR05LMzFhS0h5RUZtMVRLTFljR2tpVURZTUY0U0QxbGlE?=
 =?utf-8?B?Y2FmWXZrc3JSbS9ZUDRQSmZIdlZ6SitPbXc2RlFMZ1o0bGpxM0pkVkYwWGRY?=
 =?utf-8?B?M1o1czBlZUM0UEZlNHVHYlNTYWtzSzFVWGlmQ2RYdVpRbzkxbzRxNnpIVGNK?=
 =?utf-8?B?d3hwcUptWk1VYVFpa0hMWEh2MjBBb29neXJuQnhFcS9PaktXL1h1NkJZTW5E?=
 =?utf-8?B?OEpiWG5ydjNCWHFZQmRtd0h4UmxTRWhWVVkwRkFwQzVlNTFhdnhJSjViWDJo?=
 =?utf-8?B?WjU3a0J3Q2ZRTWYrclpWb2tvQ0RsUFFoTUxvRDJGa25pejR5WHlQUnFPY0dY?=
 =?utf-8?B?cmZuMi82Y0IveWg3UDRIanlzOWs5VmwrYWZMRDBrbXFScU1jdjJ1bGM2MWMw?=
 =?utf-8?B?RkNZQVJocVAwTkdEcmxWY0IwWThBNTh4QlA1MkZVMllUQjkwNlVxOE9wbFRh?=
 =?utf-8?B?QVA3QS8vTnhHekxqUGgrQ3FacDR3eVA1ZUt5QjZibzF3Y3Z3alV3VXN3RWV0?=
 =?utf-8?B?S1VqQS9BcFVnZnEvWU1hKzBSWi9zLzloc1BSZ3hlczBxN25vTlJ2S0tTVFo4?=
 =?utf-8?B?V01hYzlMVytVc0ZhTERaMFZEaHhFTktjTUkzRHJGYW83R0Vtc3c0T3ExMmc5?=
 =?utf-8?B?QzV6R21uMmc2bUdNdzhYTWNndUM0RVRxcEx6d0F5UEVnN3lHdC9TYndBazFD?=
 =?utf-8?B?djh0Z01jdTlzSndEQ2VBc0g3cFhTRkNiMnY5bnl6d1Jib3BGa0ZmcWIvZzA4?=
 =?utf-8?B?ZG5xMDVQWndtdkh6RkVSbHFOaVMyTC96dm5oOG1UTTBVc1NXSnpTY0N0a1BH?=
 =?utf-8?B?elhwU3RuMmZsU0NaOUVDRXppNnBXdmxFMlh3N1dNYVNJR3NmVWs2Y0tLVnNM?=
 =?utf-8?B?b0RkMG9TM2x1YVZidFBlRkhObEtpeG0veTBOdmVpYUtBa054Z0J2T1Y4YU1o?=
 =?utf-8?B?bWJ5eVFLTEx5NTBWZzQ1b21GYnBYRStiQVQ5a3NrWFRoYUNOYnFnYUxjUG1B?=
 =?utf-8?B?dDhIanhrc09jNUFmMXpoWFRBUHRKY1VrRm55Y3kvMUlLZHBUVWd0ajdBcnht?=
 =?utf-8?B?dzlkczJkZnAxaVFSYWRjVGQ2dXQ4SmV1aUJGeVVyc3ArL01sbVBVYUdaTk4y?=
 =?utf-8?B?enZBTURLYVdIeE5hbjZyVWJ3R2ZNZHFxbGloaWp5anR3RlcxMjZJZnNnZFJK?=
 =?utf-8?B?NXoxWEFacmFDL3BlZkxIZzhmV1FpZ2k4eU5rRnpsZnZhelIrUE1oQXNVUGVQ?=
 =?utf-8?B?Zjh2dzZLVGtUL20vU0d1WXNxeVBXVkJvbmRBSERURmtpM1YwWGovMHdrSTZi?=
 =?utf-8?B?ekl0d1JpSVZJbW85OFlYd1dCcUtnOVorNkxrci8wV3F6MlRKdGQxbUdCMkJx?=
 =?utf-8?B?SVF1SU44NEI1SGkzc2ZGckJTbmJ5K2VZdUZTeGJteWR4cmF6OHViMDJJSUhN?=
 =?utf-8?B?VkJENzBydXNHK05zWlIrS3owOSt3eUhzZVEwbDV3bVpwWXRDNlZLaFZ1TnM4?=
 =?utf-8?B?UXQwdXBJT1gvOGZNR1BmWENPQ2VQeGFML0F3L2o0M29PWG8rUVpwdVVqcHhm?=
 =?utf-8?B?V0hmNFlGajlsTHc5Nld2VmU0THZJNWVtN0VtMjJnYkIvcG1FcEZwY3RZREo4?=
 =?utf-8?B?MkNqeGE1ejdkOU9GMGJYNU5DaW1IZ09keDV5MzM0UTcyTnFlRVhwRVF1VWJr?=
 =?utf-8?B?ZENPdVVUb3VVTkc0UmZwaTNqa0JPUk1WRDJzTXI4OXVCejFNOUtHZitiRFlM?=
 =?utf-8?B?eFh6UEFuZktBSmdNUWtqL2I4d2hEYWRBMmpZbG9YalY1Z2pHU0JrRk9GYThH?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c8bd44-6683-45aa-734c-08dd8e4938d4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 15:58:49.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sRnzL3EBe01Uaye/a1W67KCY+NSp7vYEGg8PyY5fWo1vzr7k+Su5D9Rvw0Sjldee9MBzqqIwopnaL0cStUPBQh5viH9uVM5o2vN67zpy2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9057
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Users may want to force either of the telemetry features on
> (in the case where they are disabled due to erratum) or off
> (in the case that a limited number of RMIDs for a telemetry
> feature reduces the number of monitor groups that can be
> created.)
> 
> Unlike other options that are tied to X86_FEATURE_* flags,
> these must be queried by name. Add a function to do that.
> 
> Add checks for users who forced either feature off.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c            | 19 +++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       |  6 ++++++
>  4 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index d9fd26b95b34..4811bc812f0f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5988,7 +5988,7 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec.
> +			mba, smba, bmec, energy, perf.
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index dd5fe8a98304..92cbba9d82a8 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -167,6 +167,8 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool rdt_check_option(char *name, bool is_on, bool is_off);
> +
>  #ifdef CONFIG_INTEL_AET_RESCTRL
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 9fa4cc66faf4..dc312e24ab87 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -795,6 +795,8 @@ enum {
>  	RDT_FLAG_MBA,
>  	RDT_FLAG_SMBA,
>  	RDT_FLAG_BMEC,
> +	RDT_FLAG_ENERGY,
> +	RDT_FLAG_PERF,
>  };
>  
>  #define RDT_OPT(idx, n, f)	\
> @@ -820,6 +822,8 @@ static struct rdt_options rdt_options[]  __ro_after_init = {
>  	RDT_OPT(RDT_FLAG_MBA,	    "mba",	X86_FEATURE_MBA),
>  	RDT_OPT(RDT_FLAG_SMBA,	    "smba",	X86_FEATURE_SMBA),
>  	RDT_OPT(RDT_FLAG_BMEC,	    "bmec",	X86_FEATURE_BMEC),
> +	RDT_OPT(RDT_FLAG_ENERGY,    "energy",	0),
> +	RDT_OPT(RDT_FLAG_PERF,	    "perf",	0),
>  };
>  #define NUM_RDT_OPTIONS ARRAY_SIZE(rdt_options)
>  
> @@ -869,6 +873,21 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/* Check if a named option has been forced on, or forced off */
> +bool rdt_check_option(char *name, bool is_on, bool is_off)

Please make it obvious what this function does. What does "is_on/is_off" 
parameters represent?
What does it mean when this function returns "true" vs "false"?

Also please reconsider the name of this function to help make it obvious
to reader how to interpret return value.

> +{
> +	struct rdt_options *o;
> +
> +	WARN_ON(!(is_on ^ is_off));
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name))
> +			return (is_on && o->force_on) || (is_off && o->force_off);
> +	}
> +
> +	return false;
> +}



> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt)
>  {
>  	if (!rdt_cpu_has(X86_FEATURE_BMEC))
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 0bbf991da981..aacaedcc7b74 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -49,6 +49,7 @@ struct pmt_event {
>   *                      gleaned from the XML files. Others are set from data
>   *                      retrieved from intel_pmt_get_regions_by_feature().
>   * @pfg:		The pmt_feature_group for this event group
> + * @name:		Name for this group
>   * @guid:		Unique number per XML description file
>   * @mmio_size:		Number of bytes of mmio registers for this group
>   * @pkginfo:		Per-package MMIO addresses
> @@ -57,6 +58,7 @@ struct pmt_event {
>   */
>  struct event_group {
>  	struct pmt_feature_group	*pfg;
> +	char				*name;
>  	int				guid;
>  	int				mmio_size;
>  	struct mmio_info		**pkginfo;
> @@ -66,6 +68,7 @@ struct event_group {
>  
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-ENERGY *.xml */
>  static struct event_group energy_0x26696143 = {
> +	.name		= "energy",
>  	.guid		= 0x26696143,
>  	.mmio_size	= (576 * 2 + 3) * 8,
>  	.num_events	= 2,
> @@ -77,6 +80,7 @@ static struct event_group energy_0x26696143 = {
>  
>  /* Link: https://github.com/intel/Intel-PMT xml/CWF/OOBMSM/RMID-PERF *.xml */
>  static struct event_group perf_0x26557651 = {
> +	.name		= "perf",
>  	.guid		= 0x26557651,
>  	.mmio_size	= (576 * 7 + 3) * 8,
>  	.num_events	= 7,
> @@ -208,6 +212,8 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>  	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
>  		for (int i = 0; i < p->count; i++) {
>  			if ((*peg)->guid == p->regions[i].guid) {
> +				if (rdt_check_option((*peg)->name, false, true))

What does the "false" and "true" represent here?

> +					return false;
>  				ret = configure_events((*peg), p);
>  				if (ret) {
>  					(*peg)->pfg = no_free_ptr(p);

Reinette
