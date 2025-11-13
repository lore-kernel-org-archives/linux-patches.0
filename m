Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF181CAA92
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763006489; cv=fail; b=JOgeIwhtNwFdRbHrhXId1Sh/+2EGKHfVl/79pekgj681UFEk+DpwG85OA8Ca0mydF9PpD+ilFKdvK5ZY/4ntROwl6aA2VonydUt9lbmyk/kZhXnzGj/1aa6JJWLh5cNCwg5qVDhgiCJRe/H/2idrAR6j/Z56uSLTc2v+QOAx6Wg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763006489; c=relaxed/simple;
	bh=tG7BU2Id2QmQ5U6NsIjnpPHhfxYUT5WS6ECQjkuVIjU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aB1P3iTcaUexkDxhZYAMT29cNWLz/wa414hme0cEFmxP31+reoVLMOzGNXCKl6VX0AiXDVQyr8JoaGoQbJrfjAe+b0dIqJXYuGoc/hQQ7coyt0RTcC+/rkBbZenOAHd6ciZGyaKJlCEJPaVyvI2ja2d2UQKbxHpQFDR7p6SPmlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbW+nQok; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbW+nQok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763006487; x=1794542487;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tG7BU2Id2QmQ5U6NsIjnpPHhfxYUT5WS6ECQjkuVIjU=;
  b=CbW+nQokztW4aTlIuLCA7zO6vrtq/rJXVgj9D3L/DJ06/Wf9fJ0dj2Gi
   kGwhdMdFUtwe/+0V46JNwyjlCzgsrdzmkv6bxtp9HPywdisNTnfQ2yDPa
   RcOjt0hs7BgXDLc8F1fobqcUK0iuv85EE6ZMrfVXngcKBCZjhNHsANQWm
   e7/LTGKW/+uCLLVg36wfqU7g1YQwXOKvYehAsJ4c8tisnNHGbsfqyqpi8
   1Mj9nGOnZvXoL/UuvkTkYPUXxyzCUcnoS1BRLI/eht9tK03eKPsEb0mBG
   Z7fn/zD6oCV002kXO8xEgwU05y1bfAjq6/wfpiSugISok56R3XacCEHVO
   w==;
X-CSE-ConnectionGUID: JIsBlRn9S8SlcvzB9Bwg+w==
X-CSE-MsgGUID: PRWwVIZyTbuCPs7FoL/kLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65014947"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65014947"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:01:26 -0800
X-CSE-ConnectionGUID: khiiYWHeRNuEu81d25dJyw==
X-CSE-MsgGUID: pVvgvxf6S/yWt+QWRktAmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188679500"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:01:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:01:22 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:01:22 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.2) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:01:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YP7lFAnvqUR1Pyqmdd2efqrAHvZRv6vs4QahDw392Ea39+K0JHVJqbNTd/SEgF+m9NMtQEJzHNKjAbbhov2cXArDltEHT9gjbEpiI0aVlZlw8xZEvuHCDVOT0XNJTf23Dm5WhEVGE1QvjlvLRjSxBbvGyMe9VIJSx7RMiymtXvVlPtkjYGtLGRJREWjLa4l5SDyguqq1uiTWt9B+z6uhgu8G2FMQVGZftCSx9A9S6QyVop7A+Z2/tCKkmHNtnTmSLk6COJ7hlGhwXahKJkUWs57iocTFTudK0BO9FrtaBEL94eDwZzj4cw2RSs0l1Pp+UJffzPI8r2UqZQyDjbAlhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFOhIO/QDRqIoJ2x5VeV6l1cs3WvTiH68D29Uzd1Nwc=;
 b=OFz1MwkRJ2f1L5OafYq41nqeyq9GiLevd5+5CMjjEPiz6+ReYBAe6h8uOacvoZUZJs/6FOCN+7vjwEe0DtdHMn3BdffmHF/ZdY+mpirurJbzmmLqOn6ADLSQVpnGbjMoa9JQ63hWE4qfKi4yd+h0R6emKHCyjKGbJnopuuKI2Pt2pUbAxMO2TRfXuZE+qldxa8aCwAkrmXB2WZWy7CHxPe9mvdi2mmu8zWCxnMnCSJG0F7btxiLB1vdpub21pebfILxtgoO564A0607wrFy7C/0SkGw8W3YcD+FyYrhkhJvMd4uGSPHNbyRX8+jC5QaOTB64xxHT0rNl/HLDpYqzZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:01:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:01:13 +0000
Message-ID: <903eb9af-49ee-4e70-8762-1d6dd1703dea@intel.com>
Date: Wed, 12 Nov 2025 20:01:11 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 08/32] x86,fs/resctrl: Rename struct rdt_mon_domain
 and rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: 945aab94-5fd9-4d1a-01c3-08de2269498a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEFteHNqLzFBcDlWVXl6WnZnbGZjT1g1YjV3SjcxN29wMTNqMTdkRFBtQUJh?=
 =?utf-8?B?WGRMQWpRbHZUUFhNekJtSWZIajZIaWMwZXZFMWd2QzRzYlVqUmwvYlF6cm9Q?=
 =?utf-8?B?Z0RlODg4ZjJ4M0dvYjlpTmo2T0VrVGF6eEFFSkJOWVhmZXV4NFRqanpnYlB6?=
 =?utf-8?B?Ym1qa0liNW4yRmMxbmVtSUI5Z2VKY1FWNDBOZXNpUmN5RzhHQ1Y3UXhOKzdG?=
 =?utf-8?B?Nm1TVmxRdkNGd3A0Smd3TnVVY1pXQS8ycTZla3Y5V3NsR1Ivbk42aTY5aDRM?=
 =?utf-8?B?S1p6cndBK2daVTM3aDlDSHpZb0pZZkYwUmJMN2ZSVXA0ZjA5UFpwTG1PMVQv?=
 =?utf-8?B?cEhJZ0czSlJDVnpzWU51VTRHcHBJM0cyc1F4cjlmRCtzT29rZmlKNHhxWGxQ?=
 =?utf-8?B?ZFptUi8vQXhMVHVOUVoxa0VUWFlOa0RPVHlnRjcwcjN0MzJRYm56RjdGd3Vs?=
 =?utf-8?B?SUtyVUFaT0plTjFXVnZ6TTMvWWZZaGsxZzh5dHlpR2FpRDkyaFdMd2hZa1BN?=
 =?utf-8?B?Z29KOG1FbWFKL2pWWStlQ2J3Zzh4THBlNXJjT2o1UGZYakVVK0d1TjlnekhK?=
 =?utf-8?B?bGtNTlN2Mi9qaWF3a0RzWXJ4U05WTEJOZ1owYUNWNk56c3Z2V0xhM2I1SC9k?=
 =?utf-8?B?Q2sydDlDdndNN0J4SFhqUThVckVRRnNFeC9Nczg4bkNCODRFQ215ekhualA1?=
 =?utf-8?B?eW54YmlaRjdrdWErY2RqTHJrbEx4T2c1UFZncU1sRkxOa3ZwbWlJLzZVNkhU?=
 =?utf-8?B?WHNhK2FQRDF6bGFZUko2dFlDQi9rNTlBWTJCeEhTOGlqVEJHN1JBNFBqWXFE?=
 =?utf-8?B?enpBSW9kY21LYmtIaFJ2T0F6V1VBNUNyK0MzbVkzd2N1Sjhzb0xIejNhbGJw?=
 =?utf-8?B?RDQ2MUZoZ1IrVWNjenlSOTFLaVBIUEdPanBRZU1FeVFYeHMzZkxaOW5uL2dC?=
 =?utf-8?B?WkhnRUtnMjRpR3RkWEFIWkV6M1NuU056Z0hQaGJzZ2Y1TC9seGtSZVlFR1M1?=
 =?utf-8?B?Tzl0U2ZuZnp1MUhyc1RWTmtkVFd3eldINThsWlZFN3pRQ2xlY2liWUpoa0xj?=
 =?utf-8?B?Z0hsbHcyam5oZVErNGFETkpwQlJodDJKVjJ6M0RHVk9ZR1dvTXZhb2MyeGV1?=
 =?utf-8?B?YWc1b1cweXlKWTVaK1ovWFBwUDBMR0dJWnlLNHYrelpIa0xhZElMakh3N1BM?=
 =?utf-8?B?THhmdE5ZdnByWTRLT050R1N3ZnlsVWw2cFkrMmkxclZTMlZNeTlwUGZUdk92?=
 =?utf-8?B?RUpnQmtsZSt2MXlsUTd3eDlzZFZpUHZvTnRMc1dkV2pGclhVRmJMSDF0ZHg3?=
 =?utf-8?B?amQwK05JSWtCK21NeXJkOUZNWkN0aENxZ2hpM0d2WXhVT2phZXM4VGFiSjV6?=
 =?utf-8?B?RGl5SzkvVWNxQkVLWm1ESkRudldiNWdTUFB5MGRFKzcrZUJJOWh5V2Q5VE5S?=
 =?utf-8?B?bXdWcWZiU09SUTBZL0tzdHNqN0ovUVBmRjdGSS9HUDVqRXVNaUsrZDlJQWdt?=
 =?utf-8?B?Zlk5M1VTb0dQU0VFV2JwWVV0Z25xbTZ0VG1uTVoycWNobkRjUXg4S1c4akFl?=
 =?utf-8?B?UlJnQ2ZuL3V5ZnVOdS9NUjFDQTdYdFlXWURwVU1iVkdZeUZSMWp3NzJWem5K?=
 =?utf-8?B?elJrakFsTHE2NVlPZzIrOGpteVlqYWVyRE4zZi9jZEMrVndzcjN5V1JheDhY?=
 =?utf-8?B?enZrRkR3MVRUcGNKTlNlcktmRk9MN1cwdkJwVHRGd1ZodkdJRVovUThOdkZI?=
 =?utf-8?B?YVp4c09XMENJVm14L093VkFFS1JCd2tVOTJsTUYvNjlqOFB6aGU5NzhId2xE?=
 =?utf-8?B?eDIyN2grcHlXTUJKSnkyZGdyVWRmTTdlU3VGcEdYTFRuaEZlUGVBOW50WFVO?=
 =?utf-8?B?WjNJNDU5eTVkR21kU1JvYmF6RG9mWWZIdDJhVlNNUHVmLzNZanorcjNoYnZo?=
 =?utf-8?B?QVRoN3o3Wm5hSVIydHNJV01RQUYyekRkbFB2eUJkbThFaTVhUjAweExGb0w0?=
 =?utf-8?B?K2pXVFRSZ2lBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUFDd0FwdkxydDRLSUU5QmRJalJjUksvRTYxWGZoWFNDQldEeDVTZGttcEFa?=
 =?utf-8?B?VWZ4UHpIWDFRVFdsb05acFVMekxqRDBqTjR5N2taYVlKRVFMOWtWVTRJZWIv?=
 =?utf-8?B?cGFMY2VBU1ZJZ3AzWnFZc0xnZ3FoL29UYm9nL3VqKzI0bEJ4RGo0b253Nmdo?=
 =?utf-8?B?VVVFUFE0cFc4WnZCQzJ5NERoWVJhc083WGRRUU11QjF0eUlkc0h0Qk5kZW5I?=
 =?utf-8?B?MEVLaFFPUmQvUVNaQnBMMXdJSUVMWlVnNXRwZVFyQkhQejVyS0ZUNkVlQTBO?=
 =?utf-8?B?NVpFYUlLbE1xU2JEN01ZQjNlWVMrVzI0UVpUQWtDbEFNTUtLNENRTlB5US9o?=
 =?utf-8?B?NDd3c1FtOG8ycnp3cGVGd3VzQ3paR1pMbGFRemFyblpaaExHNHU2cVlKM0cv?=
 =?utf-8?B?NFJNZTJyS2RTTjViUk1MaFV0cmJYSDRUR1FaaHd4WExERnk3c2g5dmZaa24x?=
 =?utf-8?B?anFnU251WEhVNVlxd1BNRTgyQTJ5N3RVRnZpZDlzcjF3OWdmUHBBNlcxWm1o?=
 =?utf-8?B?TDBiUHh0QVhqQkhuZFZhYzZQMDlLV21wMmNwV0RvOFk3S0diSnFOMURQOFVW?=
 =?utf-8?B?ZVgzd3dZdmhUVTR1MTlhTGtXcVN1RW1kRDZjaTdUOW4ycEdWVkFlWGt6b0NL?=
 =?utf-8?B?UmttemVJc0w4cEdyOGpHUDJqcUEzSFA1bHprMTF5ZFY0NFBOV001Z0NXeHRn?=
 =?utf-8?B?ajAyWjdnOHNYNTlIRHhmYUxaT0Z2SlRqRlhMMElDV0w2aGo5dGVNdmtML1VE?=
 =?utf-8?B?Smp1UjdZRUJ4TVFPSVJ1cnBId1hab2pBZ0dPNUd3VnZIODR4OFljd2NEY294?=
 =?utf-8?B?aERCT0JYeHBQWlpUTjNIUlBsSnRKRUZhS1ZJaDFYMFI2QnkzM3htOG55ZXV2?=
 =?utf-8?B?UHFXSTdWT1AvVFNJVHJMZVdKNm9nM2NWL1g0UFF1elB0NFFPNFF3c1BIbStK?=
 =?utf-8?B?K0ZyQzU2TjMrZ0s1Y3g2Zldpa3Qxa0JXWW9OQjVMUC9tcjdJWWxjUTI1ODRn?=
 =?utf-8?B?a3hPdmx4REdvYWFYNDV5d05VSXEraUNJcHJEeDRKbHhiM3JLREQ0NEUxckhw?=
 =?utf-8?B?S2RyOUVxTmQvMktEcjNJZFEzRzdzT2RDUFVhQlJ4a21GTVcrWTB6ajZoWGEx?=
 =?utf-8?B?cUdJZ1VPKzBydDFaQzNnd2J6bzNac2owRDdCSUVkREhzbmNNOEVxaGZXVU1S?=
 =?utf-8?B?b3FraGc3NVU1MGFiMHVtcGEwQlhjSm5zTzZOb0RMejZSUlVvTUhFQTFtRUk3?=
 =?utf-8?B?bW5SQmZFRGJNVFo0c2VsRm1qZ3MzK0dkazhFeGM1N0dFd1ArOWhXNml1Nmtx?=
 =?utf-8?B?ay9aK1dMZS9jRGk0cC8rMFRWMHkrVFE4ZDdQUCtQMzN0UEJhQ3Y1NFNyZmtY?=
 =?utf-8?B?TFlILzl2Q05oMzJHTmltUjFkY2V0MityYnFFNTF5VDhyRFFJTFBKR3U1Zmd4?=
 =?utf-8?B?SFc0ejk3aDZod1pWY0U3QmVWdkRSSkxVOGVZdGZRMG9pdStoOW1uanAzOE9x?=
 =?utf-8?B?Q1BSZUlHU1ArY3dTN3Vyc2gwR3VmeUIwVDRwcmlKWXdEVUtoRmg2RHJqd1hG?=
 =?utf-8?B?WHlWblIzQXR2R044alE5R1J3dm1hVG9FaGowc2c3aHk3bWphWlJrdGNtb1lZ?=
 =?utf-8?B?MDBueUx0aDRkdjF5RDRCbkNxd0FGNU95a0hnUy8wSEtpK2c3MXRWWFFHSHVM?=
 =?utf-8?B?ODFzRExibUtPM0huNnZPNTFaNUo0cy9zWVA2S21qTTh0MERKQmIxZWNndkVT?=
 =?utf-8?B?c1lDOFR5c3U0WkhocmZzbUhhZ2JFZWJBekZOeWlsNmRXekNkVkU3U05hK3Bk?=
 =?utf-8?B?S2oyRUpXdTZwcUt5cmIrWC9pRmxFdW1yN25GY0x0MTNESXBGZUwzWFFYZnFO?=
 =?utf-8?B?dG5WQUxpbnppVDJOT0d2TEdKYlZRRXVhMDMvSlhaSGNETmJKV2syREtMTngw?=
 =?utf-8?B?d3JSMlpMS3NuYUNDbnFiMUgwZ1V0UmhCbnZ4SWVLeWsxeENIVEthc0RZRDlO?=
 =?utf-8?B?NTlXTkxXQy9wdWNFV2hlSk5pSXdVNEpiY1BHN1RXenlkQUI2c1FGcjkzS1hu?=
 =?utf-8?B?UmZuVXVkU0UybitRdWMxVSthcnBwMFYvUnZtYXN2SXFiQmZ3ZWJvNzdURTQv?=
 =?utf-8?B?R3hPOWpIUS9yQmlKeHFCTk9pelk2MzhIWnB6aTVBTStMZk5yS2RLL1VVeTJi?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 945aab94-5fd9-4d1a-01c3-08de2269498a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:01:13.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7/tW4Di716rjLoLi3iWIyVNzdF7IOPR5zgWorKZuM+Jv3v7wBCWiKuDIr/+VMsPpaB3P6O3PsYg5vTByzszH9A1+w7eQ+HSCuvI4eg+2Nk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> The upcoming telemetry event monitoring are not tied to the L3

"are not tied" -> "is not tied"?

> resource and will have a new domain structures.

"a new domain structures" -> "new domain structures"?

Could you please review all changelogs, even those that already have
RB tag, to make full use of line length? This is required by tip and having
patches formatted correctly will reduce fixups needed later.

(This repeats 
https://lore.kernel.org/lkml/22ee0370-2cdd-435e-a7d4-81dc0c3df547@intel.com/)

> 
> Rename the L3 resource specific domain data structures to include
> "l3_" in their names to avoid confusion between the different
> resource specific domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 1a33d5e6ae23..a07542957e5a 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -178,7 +178,7 @@ struct mbm_cntr_cfg {
>  };
>  
>  /**
> - * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
> + * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource

nit: The "a resctrl monitor" in  the description can now be updated to reflect that
it is now L3 resource specific. For example, "group of CPUs sharing RDT_RESOURCE_L3
monitoring"

>   * @hdr:		common header for different domain types
>   * @ci_id:		cache info id for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> @@ -192,7 +192,7 @@ struct mbm_cntr_cfg {
>   * @cntr_cfg:		array of assignable counters' configuration (indexed
>   *			by counter ID)
>   */
> -struct rdt_mon_domain {
> +struct rdt_l3_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	unsigned int			ci_id;
>  	unsigned long			*rmid_busy_llc;

...

> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 9f4c2f0aaf5c..6eca3d522fcc 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -60,17 +60,17 @@ struct rdt_hw_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
> - *			      a resource for a monitor function
> - * @d_resctrl:	Properties exposed to the resctrl file system
> + * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
> + *				 a resource for a monitor function

Similar here. This is no longer just "a resource" but can only be an L3 resource.

Reinette
