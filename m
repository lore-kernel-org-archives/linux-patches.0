Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9D2F39D1
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763162813; cv=fail; b=E5c0W8eJYXyISG63GBZKtU/tPZr4y/ymD0V+IrTBrevyH9C2RAWyFVP13A4oRZSWUsHuEZ9YVIFjiiWx7t4pu0QjiHH+954XC4vfUp7HLcKjSX0mb23XwDiW8sid62O0iXoIs5inSP6mUBZqbDpJjBZR4W2B/pvt0HVd2V0pkJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763162813; c=relaxed/simple;
	bh=gVe/nOtiNrFRXJLhepRNBrCz508pcC+fnH58zwzUXNk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SvLscAzQ6QNukV040qnuAUsakgBUHoubJD2OvRgdtXJ52qnDfrXi7xrQPE9zzurOiaCTVCqgOHZzM93poJzMrs/FaUXsFkR538+2dW5Jxm0VUbihmB6m15fbdFOpcnDbnZiNQbGGHRL/cyktevjsmpKuoVdqJdvY9E0fg02WQm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8S2wLEP; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8S2wLEP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763162812; x=1794698812;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gVe/nOtiNrFRXJLhepRNBrCz508pcC+fnH58zwzUXNk=;
  b=R8S2wLEPJJ8yS31wklZT2Lm+Vi+hN3xjxmr9jOAn9tFHoL68UgG+nw8m
   rDUH8FtPydqRUFEst+0qhay2yPag+MjvqjxK3jGUR1to2+iGqUKJLXEEy
   RLkonU3FNKdd1jAvzQ8bIAXj955HgaDbSpGX8b8YOSGrDK1G0FfsfJ3hU
   eDp3LFoxVatdxcJZ4enDiYqcjNFhRYYISe0zMvcY+7bZcX8DcDKFHyOqw
   Y0lJsKxiGNnQk7czyhgGKwzP3vm3fCAPQHRq5yrYWPP03N+mZKckmXWPe
   ptfjNBH7dxgO4puZXXBDmLN/d9rKoH9hvTRbTAjK3nswkX8synzGWDeMY
   w==;
X-CSE-ConnectionGUID: u1j9wbdBSLqg7WuRnNnhiQ==
X-CSE-MsgGUID: 9cjFOP9gS/KpbzjNpBduQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65418466"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="65418466"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 15:26:48 -0800
X-CSE-ConnectionGUID: /7Q0Ynd3RgWI0KbJPSFoxQ==
X-CSE-MsgGUID: SFDN/WW+RDuc3L5nXc1qtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="190084611"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 15:26:47 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 15:26:46 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 15:26:46 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.33) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 15:26:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dm8FVliRaRpeFhL//2lr5a3uYjw31aYaRFzUM70y0sUkfIVpVtntQgs8Jz1FpL0Kdm/pCtMmirYlgtZFmg5cTvvT/l9Nf09m7OttfZfRSAYtS2UMZ5gz/vUCXyxygfDD6lS6uMGdZ51bCm5mOjfVNyUtFhiSL+e0ussWkaNHRlZd/RqL4zBcbqbbrnr8TsLdDglf0avVX0K/GzgB1GzMHRLGLZHWv2UjmulOTalO9RXRtU7UK/4bxZddoUN4LXsPeeDNLu9GkqAEIiQsHigTQU5pirxddAU1ax4mnWcZ3gyibSKL+Ub+s34WM+ueRpM6a/18xMNg/F2w379HXLsIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnqdUoq2QqkQLeMXwVQM1wNw3Egyc0lu6c8BjRSryig=;
 b=baD2WDfNDu8P00o0huuCEruEparVfzP4wWbRPULJGRyualNL1IsZ7hH/F32xWidNGUSir9W3QLxh8QnsrgvMXAxEOBguffLCSeR8mOtjhdSTkuX6YKkbPq1g99BSlqnUml3XvTU7qWvzEGBI/5ve1W9AWJsU1Dq9Kebj5j9lDolzEExLDvB3L3lZPUrPGLbBDk6v+kmc93YFkmpAtIy/LeqfuKd7POgCQfO41vM24RNQC35cKVnYfzoK1uuGsFuInjkSpsQ+6oZIBAh4UhY1w4lOxKuV0kHvNAtR+ESj7jThQVZhrkT6rBzdAyt5kIRrY7fm6tL+YwXXaL1neQ0e3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5919.namprd11.prod.outlook.com (2603:10b6:a03:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 23:26:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 23:26:44 +0000
Message-ID: <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
Date: Fri, 14 Nov 2025 15:26:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aRelbFgQ4-11Xwg2@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5919:EE_
X-MS-Office365-Filtering-Correlation-Id: e7418be7-b318-4c45-50e7-08de23d545c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDEvWnNuemRYcTk5YzdKUHhnRm5POW95c0pLeVY3RjQ2QzdqSTRqUFFMNy8w?=
 =?utf-8?B?OW9aaFRjRVBBQ0Fwd3FPQlVveGVjcDVxeXJEUDZ2eHJEZ0lWSTMwWFROYzdJ?=
 =?utf-8?B?UVlTa1BmVkp6TDhrQ3ovZjZQREEwVWs5elRxYkluT0ZWbGk5Qm9KQXcxR3Rm?=
 =?utf-8?B?QTZYMG84eTc1ZUJxdjJkdjlWendGd2VBcVJMOWxDVmFCdXdrMDJENjNZczdP?=
 =?utf-8?B?YzdnekU4a1hxZUdNQ2hUVDIwYjFaZ2ZEdEw5OVorbW1Ta3JDUEJJTTZKTC9j?=
 =?utf-8?B?V0RRMUR0VE5lSVNqdTEyaHlsOGU5d2VvdFZXb1VjelQrVWF2Rzc5QmhTNkxL?=
 =?utf-8?B?VTg2dnRWZXlmcFRWV3dqd0lBYUxuTlRhdFhSOFhZU0RxS0l3UUpqSjlJK2Jn?=
 =?utf-8?B?Umd4MDhlNkdrSmxObSsxVGFTRGRWcTlrTFA1aXlPMlJMYXcrMTJtOGtMcjdY?=
 =?utf-8?B?RlUvL1V6bGhwVkZSZ0dFYjl2dU5DWTlHdHpwZ21TaUpLMEFNMHRFVmt1OFVk?=
 =?utf-8?B?MVAycjhGTi82SllvZzF6MU5KL3puSDY2M015Q1hvQmlrajRsN1Y4U29ISDlN?=
 =?utf-8?B?S3NGeGdPakRMeCtUTUZCcUpERFI1bTVUM0c2RTRPdkhTRG5od28wYWJXd3I4?=
 =?utf-8?B?YkdVMEJGcXh6VkpPUVNoM0VuSmgzQUF0MXhFTjU4QTN6T0d5UWtwWFd1QVdX?=
 =?utf-8?B?RzVMNUl6N1UrNnk4L1ZUQjhFbG91REI3NjE0bmx4NEV2M2lQb0NJaXZyMWpq?=
 =?utf-8?B?ckZSVmprVjFFNlR3czVSNEFaNlh3dDlMRzF3eHdmQUEvSllpOVlPSHFLdmdL?=
 =?utf-8?B?Y0tVTVVZL0dSdmhyNkxaWHJkUmUxbk9XNW85SDNzWnVrdnA1TjZMcGR3U1pO?=
 =?utf-8?B?VmFUNmpwZFZBNXhIelozSEhaWGlkVjAvK1NxdlkrMTZ1VTVjYTNSclZuRDJ2?=
 =?utf-8?B?NlgxcDkzRzRNdjFxR0tZZFV5cWp1RXd5WFVQMHh4RXpubGlKSlJ2Q0FzYXdE?=
 =?utf-8?B?Zzd5bWhEaUtoYy9RRC9nVGhKN3BWMGRGSkpoa09ha05ISXNFd29HL3Q3TDJH?=
 =?utf-8?B?QXhoeDRmM2pHR0gyYTduWFV2VG5KRFZIaGk2eExnTlNBbGRBdWNPSEZTMWtj?=
 =?utf-8?B?NmtRdnZuMTd2TU1ZQ1BKVnRkWUZHYi9Ydmp6bnhWNnBoS01FWlYwVlR5VC9E?=
 =?utf-8?B?ZFpXNTl0SmtlZ0crVEpxRjJFK0U2Wk56aWxoU2dwc29kcVZ2SmFpTDFsY3Ns?=
 =?utf-8?B?R3R6OUwzU1hLdGJPak5LTzE0S2cyNlhzdTVUQ3Mvd0hQOThhRTV4T0NDTk85?=
 =?utf-8?B?dnpVa3ZjZjhJTkR0RUk2emZJRU1HQ0czUm9WTWFrRkdNSGptZGNBRjFpMkxu?=
 =?utf-8?B?L0FWeENySWRpbGYzR0hFUk9KRE5Ia2NYTWp1MWM3N2pqRkR5S0xyYjBIeFhD?=
 =?utf-8?B?cUNTZXF4TDkwYWlVTDNGbFFyZHJlSDU4OWpBVkcvL2d2NjJTZ3JERE5NSVhN?=
 =?utf-8?B?RzV5RFRLa2t5Z1pHTHZKUTlLeHdPTFVKYm5qY3FUOGIwdGtnVnkybjNvOU5C?=
 =?utf-8?B?Z2VFR1BxdzF5OU1IS0pJZ010YVMrWi9WcGVuZm1kT1hPd09GYUVxa1lVa2Y3?=
 =?utf-8?B?M0RTNFJNbnFxYmFsdHZFdWJ5Rkd3QjhnaW1SSEtiQmNBLzlKc1VNRStLd01M?=
 =?utf-8?B?c2tuWFErQjJDbXA2SDgxWGRseVBrc0drdmU0MjFCYUpVZlZrWlN5YWxyUm5P?=
 =?utf-8?B?V3Uwc2FmazRVOEM4ZkJqNFdOSElhZmtVZVVQWTJZNlZHNHVjZWhxM1VoU3ly?=
 =?utf-8?B?WXBteXl2NDNCenBXLytXMm5JQk1XQ3QwSGtSLzZGOG9yWDBYd1Q5Z0I0Wmxn?=
 =?utf-8?B?d1dreUhjS1F3ZW1YeGtDN3ZlR1I1MXdnMjNVWk01YnoxZ2NxSFY4WDhicEJp?=
 =?utf-8?Q?3rnladfRwisDMYyw+hsx/sO+TGHb6o4X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTllRDhabWRXK2N3enFtR3Fva0VuUmRITFpZd1YvKzFyMVZ6bjI2WktHYTU5?=
 =?utf-8?B?N2hkODlJK29ZSXc2c1FaUFNTWFFLT2h5T2NBOS9VWmRCcExjU2dEbGVDRTln?=
 =?utf-8?B?djNtcU5rVUphVTUrSTBTL0dHbm04NkF0bSszaC80ZW92UWdqaHpPR0orUUw4?=
 =?utf-8?B?SkM2VWQ1SktPeE1BbXVha3g4YytaSHNFU0svL29wWUtUeElQbC9ZekZPcjBB?=
 =?utf-8?B?di9JY0dTNlR1V3IrTnl5S0VkUWNtN3VtTWhSQmVEYzU4VW81QjI2S0dSeE1o?=
 =?utf-8?B?Z0RWbzludlpSemFhUmNZS0VndWM1aFhNMXp1S0lLTXo0TnFDNDZ5VW5NMHJ0?=
 =?utf-8?B?REcyeGhEelZ2VnBQVmk4dE1yVjc1ZWRMY1ljbzlIcnVyckg0Rk5wdDJkb0F3?=
 =?utf-8?B?UXh0d1dYWWRtR2U2YTBFVWwvcnRGVXRhV21CZjRacU9IVDdXek1SVndKcTRP?=
 =?utf-8?B?WWI4NXViY0x5TnpRV2JHRk1TVkhCNURaV0d3VmViQzdYZHJwcmFlWEpZblZs?=
 =?utf-8?B?N2RBTWxMeUdYOGZJS3VVaWZHWVJlbFFFOHRxZ3IzVC9GSENmRWMwSThTd0dD?=
 =?utf-8?B?V2s5dUhmK09oZUloSkE5QU9RWHF2aDd4akExdjNiYlJHYmNwNVZZTEljUGZD?=
 =?utf-8?B?V2l2NGxHb1VPSHlqU2RiTTdvNVFMZUMxelVucEt4UVhFY2Ivc2x2ZHhVeGRD?=
 =?utf-8?B?TktXVVdFUURZa3RzUEZULzFKM2FpeWV2TTZEa2ZvV0JrRTl2NG1tQllranVw?=
 =?utf-8?B?VklqalpBdjFiWDl6UUppR1U0bjVoT0J5RFk0WU96QmgwY2hpb3RRbnRvaGtm?=
 =?utf-8?B?ZGViK2R6bENJcVROMFU4NzFhUkh4eWtMdXlWcWN3SUdVMkJtcXphTEltcjgz?=
 =?utf-8?B?SHRiZFNsOWtrakpkbkkxVjdNRmZvNUVqNFRLQkQ5TGhMdU4wOE95NWpCUDVV?=
 =?utf-8?B?ei9KZGVMNy81OXN4N0l0UTdta3ltQXVqYnQvUng2MFdhT25UNmtvUHpwVmlh?=
 =?utf-8?B?Mnhkek1La1lYVXZ1RUxSbWQvZXRFdjhRTnRVWnd4c005UysrVkllT0pLMFQ2?=
 =?utf-8?B?cmhjK0Z0YVkwaEFZckxISktYVFMvQzE3TmlEQ1VBbkE5TWlqMFM2Q3NmQldk?=
 =?utf-8?B?amRoOEdidGQxcWxqNUVPaWlLUGJiWkc0NHVZV2svcVhxWElIcWdoNXUzNisx?=
 =?utf-8?B?NGk4ZzYwQzk2T3ZHYVpIK21aeXhuRkN0WXhWNGtZM0Vya0p2ZmlxaTl6Szg2?=
 =?utf-8?B?UDlZVVpqU2FqUnA3bkcycTdYNE05aHJERGtLRHNER2lPcWo5TXEvOXhadHVE?=
 =?utf-8?B?QTBVcksvb0dmLzVXZ2dwMmJVWmZKckNqZzQ3dGEwS1EwOGp3U3g5YjVYVDBo?=
 =?utf-8?B?T3JtYm4wdkN4ZFF3dXlkeU5yMngxa1F0TE1PN0Jwa0lnZFQ0VWp4ZVBpWGhL?=
 =?utf-8?B?T1dpY3hoUjlNdW9mdGdVKzNkZGxUQjgwdnhacCs0aU5RSHhzZWlSeE9jbmIy?=
 =?utf-8?B?TG1ZU0tqRThmSktJQXNrOWhHek1nRXdyUU9hS2RBSzlxRzN2QTFhR2RBMWRm?=
 =?utf-8?B?MzFCUVFwTVluM0FEYkJramMrQXdFSWkrQTA0MlFndThEN3FOdnZNSjF6eE1t?=
 =?utf-8?B?Nk1EZVdQMGVXZm10aTQycmdVdHNNVUMxc3lvZTNYZFBMK2ZZais1bzFSRkZt?=
 =?utf-8?B?aytZb2RUaXFiVm5UeUVPRExHMG9tckJ1U3Rhd2MwbEx1b0ptYjZHVE9qTHhK?=
 =?utf-8?B?aDgrSnVCRWZSTk0rTlRrTkZoaG1xMzNEN3ZUUFZhaUxOVXQvZXpIYWtaOS9H?=
 =?utf-8?B?eVhCYmxhTE56QVlqUDM1TTYxQ2NQUXNOd3VZOXp2RDNIWlRrbFJoaGN4REc2?=
 =?utf-8?B?NkV4UVY1ODVGcFBIRStaUjNMd3NGN1ZpbTN4Q3UwOTVWMGNVUkQwMlY3RTVa?=
 =?utf-8?B?WkdBSWdSS09STTVxeURvNFBsMisxOEo1RzAxdk9UK21ibkx1ZDFjV2JqeER4?=
 =?utf-8?B?TDIvRmRxdnI3M2YzaXFUNkJqRFpCcDdGRnl6Tm4weFZVc3RlTm1mUm5VbUNT?=
 =?utf-8?B?NTlmVnRKRjBTMU96bmM4REtpdzB2SC9nWFJFdHBnbmVtZUZsOU11VmFaUk1P?=
 =?utf-8?B?ZElKb0NoamVlMkdWOXBhUnBqcmhZcWVRc2NnT2FWMFdvc2g1dFA1R0xvblJz?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7418be7-b318-4c45-50e7-08de23d545c9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 23:26:44.0161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjjkRLbHCVP+GHM25/lHFiZ2nZEhh8BxoOz1ynre2ZT2Bw+beDXFdCbXYoH/rS0Tl12vqsLMxucq9cEYyNtzlh+G85qsJgIgI2AGYSjQmoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5919
X-OriginatorOrg: intel.com

Hi Tony,

On 11/14/25 1:55 PM, Luck, Tony wrote:
> 
> resctrl: Feature energy guid=0x26696143 not enabled due to insufficient RMIDs
> 
> 
> static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> {
> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> 	bool warn_disable = false;
> 
> 	if (!group_has_usable_regions(e, p))
> 		return false;
> 
> 	/* Disable feature if insufficient RMIDs */
> 	if (!all_regions_have_sufficient_rmid(e, p)) {
> 		warn_disable = true;
> 		rdt_set_feature_disabled(e->name);
> 	}
> 
> 	/* User can override above disable from kernel command line */
> 	if (!rdt_is_feature_enabled(e->name)) {
> 		if (warn_disable)
> 			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
> 				e->name, e->guid);
> 		return false;
> 	}
> 	...
> }

Thank you for considering. This looks good to me.

I now realize that if a system supports, for example, two energy guid and only one has insufficient
RMID then one or both may be disabled by default depending on which resctrl attempts to enable
first. This is arbitrary based on where the event group appears in the array.

How a system with two guid of the same feature type would work is not clear to me though. Looks
like they cannot share events at all since an event is uniquely associated with a struct pmt_event
that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
will complain loudly but still proceed and allow the event group to be enabled.
I think the resctrl_enable_mon_event() warnings were added to support enabling of new features
so that the WARNs can catch issues during development ... now it may encounter issues when a
kernel with this implementation is run on a system that supports a single feature with
multiple guid. Do you have more insight in how the "single feature with multiple guid" may look to
better prepare resctrl to handle them?

Should "enable_events" be split so that a feature can be disabled for all its event groups if
any of them cannot be enabled due to insufficient RMIDs?
Perhaps resctrl_enable_mon_event() should also now return success/fail so that an event group
cannot be enabled if its events cannot be enabled?
Finally, a system with two guid of the same feature type will end up printing duplicate
"<feature type> monitoring detected" that could be more descriptive?

Reinette
