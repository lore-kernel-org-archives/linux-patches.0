Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3191128362
	for <patches@lists.linux.dev>; Thu, 23 May 2024 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716506338; cv=fail; b=mD8vbq4txL/CXd8uGDzKKSxadFkzMAV+7UH8jXhjWTBemQipel07Z1tW5lm7kiK+CJhDCMwXg+5S3pE9SiPkb7ugsPBbvEM8YOiNlUTCGwd72Jrn2YJVjiIpVFrAsHzU+76ouilGKHpY/8IrZyTZhVKuouEPhFJCHkpbjncGFps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716506338; c=relaxed/simple;
	bh=ev7xCdR+7y4lYIb8Nq+fIsn9P4C3Nz9ygh+57OYaQ1s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ESzoCohI5tXCoqBm/BVCtl4lKwzAGmqWYsA4ZMD4WGljTGiI273Hxsqx4M10SncqMT/F6bj68a9Vly4Z9kum1wl8aTqzrsHiYvuetg1ajtRSzgwMdxPGPvBsZdsGYhmtHDAb0yAUIkudn6u6sDg/MSuPY2Gh+AM+xlqOjhywQEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSGIDmgP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSGIDmgP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716506337; x=1748042337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ev7xCdR+7y4lYIb8Nq+fIsn9P4C3Nz9ygh+57OYaQ1s=;
  b=MSGIDmgPOzyNxupslQuSMGPQ0DOWb09XjU/dhrC5Bi9Vwr7ErHj26HYy
   ZWLRlO85owz4uqHUeNU5e6xJRvbLbcI/+UbHHX10IfVlWk8e38CLnBjzj
   RdxpvH+VAaWpJMvPqH3InheRTAtcMep+AX7yNp9kz+qea9k94JFaPDJAL
   h/gu5TzE+c5tThVwpnZdET63vMT7ENKLSohovbhwLSu9bT/fZnyljtFV/
   83Ti1vo/FPOQZqNCCnrDUmtn+ng1+9trd1prAkWhM+jY5x0v9iRqizzOi
   8XabqEvrWBvMY2KUJcCgSlgxiNfsbum+18uaZewIKT+2Mk5hViosmNrH3
   g==;
X-CSE-ConnectionGUID: AawSYIqZTF+Mt8JpEIOdYg==
X-CSE-MsgGUID: 2sB86fTCQ9mQ9W/gKEMkvg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="15805004"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="15805004"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 16:18:56 -0700
X-CSE-ConnectionGUID: k0Meq6mWTmKZtx7101FTbQ==
X-CSE-MsgGUID: T0fIIXusTp6T92r+R1CA2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="71245825"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 16:18:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:18:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 16:18:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 16:18:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 16:18:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7uWIWsjRuJK/gWqmcxYzNqWKY4jyQDwlN7Y5kD4bIwVd94ocR8mP4HmjA6+sT0POPLP5FxhGHHMVVdRbxt3J++4Mh/hVTt+NvzBIJ6KLUjbMYB7vmZXKBRJqktrYQxDROISiqzZgE75oqF9SN8ealF/MMfIotPu1IdaRAq9pti6STfK8QnsQdym9asQJjH3i+Zr+/s4qOyYOuSQkQXhMN4ffBmSN0xjYTT4dHdoLJDFWnONoMiPrBZpUeBRpDOBdgLbe++WZcZiPiIVT18wmr2o9W7FPY7id8VzU/kM2NFcME8n2iFT0ApxkNpi4IdRUD5Gt/uE0aA66DhXynB/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ev7xCdR+7y4lYIb8Nq+fIsn9P4C3Nz9ygh+57OYaQ1s=;
 b=OihNI8xqcr8+yzYIyKRwzsRpEVTmLO8QJS1bPndJbY7Vwq1ThJsi76Be6WVVtvgTZQBFyRbBCn0DIOGnRkuH90InN69hRe5czZTKE/y1Wg+w3LHAy+Lh/TiKInEOfA7kCtjbhJrF6b6MqIgJWJVK7S9E+o0Q9wo6soGdFt6Ggrcf48ieXRKjDBXJIxLQpmsNCzxKx0FmdlIO5/HvYvG5nyitiAmkfTQzC17fAIatiOdlMXem4VYlane1yOnhi2aeaxFENDvd5zkaIWPj0ydzdOEyjxMJ50koCVL+VZyCix1iiYcPA3tJN655yX2KRVg1xlrrT642njQA0k2orAmH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB6849.namprd11.prod.outlook.com (2603:10b6:806:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 23:18:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Thu, 23 May 2024
 23:18:53 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Topic: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Index: AQHapxaLlE5h/oF4QUmt1DBuxjvwvLGjyhSAgAFrFfCAACP5gIAAB3DwgAATPICAAAkiwA==
Date: Thu, 23 May 2024 23:18:53 +0000
Message-ID: <SJ1PR11MB60832095AC783D064541F0E3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
 <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <013c9532-cacf-4604-b1d9-e90fdc80e7dd@intel.com>
 <SJ1PR11MB6083C6A9DFFF58FE305A33F3FCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f326387d-9636-4377-b82f-10e8d335c6ff@intel.com>
In-Reply-To: <f326387d-9636-4377-b82f-10e8d335c6ff@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SN7PR11MB6849:EE_
x-ms-office365-filtering-correlation-id: 65232ba6-48d7-4948-e7f7-08dc7b7eb678
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|921011|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MDZYdWpjb0xub1NZSENNYlA1TWdYNUgyOU83QVRuR2NrNWlBK0orY2ZxeFc2?=
 =?utf-8?B?c3c1UmlKaU1GUWkvQ1JSOUp4OGtOcjZWdDlMNDkzbmJtbTNqWHA2ZG5yVnVT?=
 =?utf-8?B?N0pvQWpNV0xVNU5kaHNub0pjem5LUGZMeWlYalp6RGtJN00yb29xUEdQWDU1?=
 =?utf-8?B?d1Q5bUt5VVN3aVdKb1pLNmlTSEU5UFVqelpTZGhNaW1JRFNzR051M1NFb2dW?=
 =?utf-8?B?ejN3RHFHODRaNW9YNGt4ZlVkdkViVG53cTJMUms2Umw5YWlYdkZyYmxRM0VE?=
 =?utf-8?B?V016bU12Zm5kRkpqRlV0UWRJTWk4VHBxWjdkR25IeFF1WEhzTUpHaStGMUZ5?=
 =?utf-8?B?NWdhZGI5cEVMR3o0YnJ3akpVc1pCOWs5RGVVelFGR2M3aXdsZGZyeU1VK3Rs?=
 =?utf-8?B?eWp3OXI1SU9LdkUvTUN1YlUrVmhZZnp3MTJQcDJTMzV4dW0zOTJsWEE4Y3pR?=
 =?utf-8?B?eVY5VkthakRRSXFyMWpoT01tT2FiSHkxeVFzYm1XTUFPbFQzUXRZU2FkelBD?=
 =?utf-8?B?RTE2a01GRm01OHFXaktZdUFxSXRnOWRJenpQSkhjN05OR2drMFBhcWFEOUdL?=
 =?utf-8?B?dS8rVFRqZ2pBY0pSMjY0ZnN3Tm1kdjBKc0FQZzlLZWhCVUFjc1MvL25PbEVD?=
 =?utf-8?B?V3h4ODhpbE5HQTNsTW9KRWc2MHovQjhLeWs4QkxhckdFZmhlNmZKcEhBamhh?=
 =?utf-8?B?M1k2Tll1NnZNSEFwYnRkNzlxZnF0bklNSDVpOXpzdXRVajlQY0NvdmwzUyt2?=
 =?utf-8?B?aDVnYW9WU0ZEOHZmU2ZaSmF5UzlSN1U3V1FiUHluZncvQmdXTVM4VlcwaG5i?=
 =?utf-8?B?TzRRWTNEd0N1YlpZbklWU0p4MXpqYzlGN2JTK1ArR3BsTStHUC9qNnU2WXlY?=
 =?utf-8?B?bkdnVHh1enNwWVlXamZtNUVSNVZZMVBaNUFBNy81M0pOeUJhUGIzNzg0THB4?=
 =?utf-8?B?NTlvK21rTWVER3hZZW4zU1lseFdGc0hVR0xVR0hQT1VIbi8zWGhBREQ5S1Mx?=
 =?utf-8?B?dHdrQkt2WDQrTkh4SWZCSXJMKzFKMmFad3lpSHEzeGMyK0Rjb3I5QjE1cG83?=
 =?utf-8?B?RjJ2MFdmRzhmRkt5aWtLUHZodktNK0l4K1cvYlZmdituVjVQdDFYc2d1ODY3?=
 =?utf-8?B?SHVvVnJtMksyZTl3aVhkT3ZGSmZSemVlS05ZY2ZsNkpZRkYzYW9Hd0dWejNj?=
 =?utf-8?B?WUVGbk0zaWl1eFE4NzZnSHNWcTBUQm9sOXlvTkZYdUxwWTlLWkRxL0phTEVr?=
 =?utf-8?B?eW1rSzdrTUdQako3T2ZnMHlUWC9VaGRYS1FxTXVENjNVS0NKcHF1NFYxMVVJ?=
 =?utf-8?B?ZCt2YTB1TVIxcDNhbVIrSGUyV2l5TWhjOENEZE1EclZzSGxGOFphSC82L3Fw?=
 =?utf-8?B?T0R3YnlXV0VBSjZMWUU4NkRYTnNNUEZpNlZadEdhc2dVV2JRN3BzUzllRDk3?=
 =?utf-8?B?dlBVU1phT1ZBOFRNelo5bTdzSkVWZXA2Wm1iNnl1dmdWSVRXQjQ4L0pvRm9y?=
 =?utf-8?B?Ny85K3E3eVVqZUF5REd4bGhvVHdrMW5hemhGL0JFaWdnSUxRS25jWi8zUUF2?=
 =?utf-8?B?L3dodHpPM0ZnZkxZZUpRRWNQNlJ4bFBsREg4ZHErWWIxVTlrbnB0VldVS2tm?=
 =?utf-8?B?b284cWFvVkx5WGlSQlY4czZ5WUdCcGhRL00wMjBhd0FndmttSWNtUTVIL3pL?=
 =?utf-8?B?WGtPYzhYT2IwSHRvVnVnS0RtR0tMa3ZRdlYzNHU0NklROVFNQi9YSFFIMVFt?=
 =?utf-8?B?YXlkZEl3VmRnRVFmSUp4VkhVamxhZGVpTWxxcWFXeHFSdStVazZTb3hYdzNk?=
 =?utf-8?Q?aJuVeTMAwUW2bPILYO19zajcWLnKKGjWRrU0U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0hwUnhDck55aTNYQ1RmV3pzR3ZOWDNZTFNraGVJUDU2WWE5dXB2clh4Tmly?=
 =?utf-8?B?eFVYbWU0U0F4eGpOSXZiWnUramQ4VTVTMTJ6d3JyREx0YUd2ZHQzemhvUHlj?=
 =?utf-8?B?WU9IKzVNTXh5dFRCZitZcFZhdlZyN1doZXdGaHk1UTBKOURIeDl2TnNzV1ZY?=
 =?utf-8?B?V0owa3I1YnIxd0NhZVovaHA3a2grWVE1cHFubUJjUFM1aERRY2cwTnNxTXlG?=
 =?utf-8?B?dVJaTnd0aXRIS1FNL1l5Y2p1NDhHSVF5TFMwZjQ4RVpJUHlqaDRNWmN5T203?=
 =?utf-8?B?MUNHWUlFSDR6RWpGc2lMWWtiWjNuRTlhdnJEN2lVeTdRY1VNaHdrQTY5d1Bv?=
 =?utf-8?B?eUM2RDJlSUt3YVBlSWFRQkk5N2JpZEpHVExxL3Z2V2ZtQ0FEd1lXUGJDNUl4?=
 =?utf-8?B?YWNZbXhBTDFsRDF2NG9aendTdlNpSWl2MjhDRzliVmpPYnA3K1ZCaFc5OFp2?=
 =?utf-8?B?SVVkeEE4UVlNUGRYcHFNQTVqU1dMM29oSGJWU1hzTG84Snp0S3E5Y3AreS9u?=
 =?utf-8?B?U2tOVGJCTG1icXJidGFYeEhNeHB2WFZtOWhuYUkyTERMcHBFS3A5UHF0bndC?=
 =?utf-8?B?amszVHlJajlJT0g5WWZKYm5wUXlzNDZnclhiS2ljdlBDL1dnd1ZXeUVVNFNw?=
 =?utf-8?B?R0xOYkxwR3BycTJOYTJkenJGMm9Mb2YweGxhZ1YyRVhRcnhWVFF5S0tMOUt5?=
 =?utf-8?B?ODBTeldGSGpVcVAvMG1jeDBnTnRGMHdqU2J3aWdCRFJPVzVMcnRaSzRzNndK?=
 =?utf-8?B?eVltemg2K29vaVhEVXdxc3NhakdseHNrODRacmpMTm5PQnpxUDk3ZEFaN0Rk?=
 =?utf-8?B?V25vdE9peDFReks1anMydVc0TDJoRGFLbjN0RlNqWTFUb2tzRElTWU5HS2VY?=
 =?utf-8?B?NFU2dkFvdEVRTSs4YWYzV0IxNXFyV05ZLzBlRHp2ZGowTHdrU0VEdVFTZEVp?=
 =?utf-8?B?T0hiVHkrTktYRTBzdFJRdEZyc21XNDdXL0VWSnpvdjZmOFI0blErSTVuTmdX?=
 =?utf-8?B?eG4yc2xTc3JoWmhZN3dtcFV5bHhySFRNOURnQUF0Nm8weWlmRmxRRlFoUnJh?=
 =?utf-8?B?dURJaU9hc1dMQUtJdHJNZTFTcXJPVEk4bFJkNHhIbUdTRHp5dUtwMTFYOFpC?=
 =?utf-8?B?ZWFaak1sTFRTTlVwREloWXZ1VFBTdHd5OEM3NDNOTXF1UnZrbjBZNmhZWk9w?=
 =?utf-8?B?eWxDYTRPb0xLZkkrYk1qU0NVc2FPdXFlaFcrU3NCb1g5cFNCUVhnUlBEWHd3?=
 =?utf-8?B?Vk5zZG5FWllVeUsxbXB1SDBDc3loUkhWUk5zZjB2QW9sbFFmWGs1R2YycG4v?=
 =?utf-8?B?VTZycFJNMW1lWjFPSkg3cUNBWGsyaStlQXdENmt0ZXBUbFBKYTNlcVY4K1ZY?=
 =?utf-8?B?bTBYcXZsODRxN3owVTRlSEw2NTNlU3BzVmZIZEpjZ0lJV0ttT05mQWV3eHpy?=
 =?utf-8?B?cnhvZlY0TCtOKzlHMTR2KzY0U2QwVndyTFJpdW5lcVIycnVqV0phWEhIOWhK?=
 =?utf-8?B?OE9JRjdqR3JMckhBU05XWS9FVzBHWnl4NW9HRFlXVVQ4UVlIbyt3UDV4VFpC?=
 =?utf-8?B?dnRGd2hFb01Bcm1HSFpERUpQazdZeC9INWRuVDl2SDlvVitHOEozNEdKSjNB?=
 =?utf-8?B?a3hsMGxyVnBMK0tjZ2tjSklpamtmejF1Z05Xd051M2VvcXNnakN3cXYrQ1Ja?=
 =?utf-8?B?bFM0M3ZBZ3VUOHY3VVlRSFZKZVQzbWg2UlNPSGRERG9QYUVaYnVWckN5Y1Fr?=
 =?utf-8?B?MlFldDR5dWxETS9wek9ham9tNk9JN014Y1dRQTF3aUJPcnRHUkoyVnFhMDRN?=
 =?utf-8?B?V2VTM2diOVhiUFo3VTdEdjdHRDlEYnl2bVdaaTVwaFFycEREckFmNjBXY1ds?=
 =?utf-8?B?V3BqTTArNENSalp4c1dmRzZOL2VXMkVoTmxIVjZYRHhsbkp0SzBDK1dzUFM0?=
 =?utf-8?B?NjM0dHhpZS9aN01uYXlkdTh0YU5GaEhXV0plcWtqcFplc3J5NXRRU2ZtRHJY?=
 =?utf-8?B?SkRTRjBEa0Z1cWVLQ0NycC81eG40R2dHUFVYdERtUzlONkd4WXdtZDJkQVUy?=
 =?utf-8?B?NDdleS9FazN1RnNQdEU5a1d2Qy93cWhpcXZDOVZzOVdtallSMkJKTjZ5VURJ?=
 =?utf-8?Q?2RUHAkcr5pQBp3Od0UW+18OjI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65232ba6-48d7-4948-e7f7-08dc7b7eb678
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 23:18:53.6630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCPkXKHQABHJHJU1bpjOblTL59lXPwuLyQ3CIoO4xOS+8dbIiIXW0KIE7E9otqjDQuLvAHhNmDvQg5bBBJ3M3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6849
X-OriginatorOrg: intel.com

PiA+IFNvIChpbiBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvbW9uaXRvci5jKQ0KPiA+DQo+
ID4gc3RhdGljIGludCBzbmNfbm9kZXNfcGVyX2wzX2NhY2hlID0gMTsNCj4gPiANCj4gPiBTZXQg
YW5kIHVzZSBvbmx5IGluIHRoaXMgKGFyY2ggc3BlY2lmaWMpIGZpbGUuDQo+DQo+IFNpbmNlIHRo
aXMgc2VyaWVzIGluaXRpYWxpemVzIHRoaXMgdmFsdWUgaW4NCj4gYXJjaC94ODYva2VybmVsL2Nw
dS9yZXNjdHJsL2NvcmUuYyBpdCBpcyBub3QgY2xlYXIgdG8NCj4gbWUgZnJvbSBqdXN0IHRoaXMg
b25lIGxpbmUgaG93IHlvdSBlbnZpc2lvbiB0aGUgY2hhbmdlcy4NCg0KdjE4IGRpZCB0aGUgaW5p
dGlhbGl6YXRpb24gaW4gY29yZS5jLiBCdXQgc2luY2UgU05DIGlzIGFsbCBhYm91dCBtb25pdG9y
DQpmZWF0dXJlcyBpdCBsb29rcyBtb3JlIGxvZ2ljYWwgdG8gZG8gdGhpcyBoZXJlOg0KDQpyZXNj
dHJsX2xhdGVfaW5pdCgpDQogICAgZ2V0X3JkdF9yZXNvdXJjZXMoKQ0KCWdldF9yZHRfbW9uX3Jl
c291cmNlcygpDQoJICAgIHJkdF9nZXRfbW9uX2wzX2NvbmZpZygpICA8PDw8IERvIFNOQyBlbnVt
ZXJhdGlvbiBoZXJlDQoJICAgIA0KDQo+IEp1c3QgdG8gYmUgY2xlYXIgLi4uIHdoZW4gSSByZWZl
ciB0byBhcmNoIHNwZWNpZmljIGFuZA0KPiBmaWxlc3lzdGVtIGNvZGUgSSBhbSBjb25zaWRlcmlu
ZyBob3cgdGhpcyBzZXJpZXMgaW50ZWdyYXRlcyB3aXRoIFsxXQ0KPiBzaW5jZSB0aGF0IGlzIHRo
ZSBkaXJlY3Rpb24gcmVzY3RybCBpcyBoZWFkZWQgaW4uDQo+IEJlaW5nICJhcmNoIHNwZWNpZmlj
IiB0aHVzIGRvZXMgbm90IHJlcXVpcmUgdGhhdCBpdCBiZSBtb3ZlZCBpbnRvDQo+IG1vbml0b3Iu
YyAtIGl0IGNvdWxkIGJlIGFkZGVkIHRvIGFyY2gveDg2L2tlcm5lbC9jcHUvcmVzY3RybC9pbnRl
cm5hbC5oDQo+IHdoZXJlIGl0IGNhbiByZW1haW4gYWZ0ZXIgdGhlIGZzL2FyY2ggc3BsaXQuDQoN
ClRoZSBsb2dpY2FsIHBsYWNlIHRvIGNvbnZlcnQgZnJvbSBsb2dpY2FsIFJNSUQgdG8gcGh5c2lj
YWwgUk1JRCBsb29rcw0KdG8gYmUgaW4gX19ybWlkX3JlYWQoKS4gSnVzdCBuZWVkIHRvIHBhc3Mg
aW4gdGhlIGRvbWFpbiBwb2ludGVyIChmcm9tDQpib3RoIHJlc2N0cmxfYXJjaF9yZXNldF9ybWlk
KCkgYW5kIHJlc2N0cmxfYXJjaF9ybWlkX3JlYWQoKS4NCj4NCj4gSXQgd2lsbCBiZSB2ZXJ5IGhl
bHBmdWwgaWYgeW91IHZpZXcgeW91ciBzZXJpZXMgd2hpbGUgdGFraW5nDQo+IFsxXSBpbnRvIGFj
Y291bnQuIEZvciBleGFtcGxlLCB3aGVuIGxvb2tpbmcgYXQgWzFdIHlvdSB3aWxsIHNlZSB0aGF0
DQo+IG1vbl9ldmVudF9jb3VudCgpIGFuZCBfX21vbl9ldmVudF9jb3VudCgpIGFyZSByZXNjdHJs
IGZpbGVzeXN0ZW0NCj4gZnVuY3Rpb25zLiBXaGVuIHlvdSBjb25zaWRlciB0aGF0IGl0IHNob3Vs
ZCBiZSBjbGVhciB0aGF0IGFkZGluZw0KPiBhbiBhcmNoIHNwZWNpZmljIGdldF9ub2RlX3JtaWQo
KSBiZXR3ZWVuIHRoZXNlIGZ1bmN0aW9ucyB3aWxsIG1ha2UNCj4gdGhlIGFyY2gvZnMgc3BsaXQg
bW9yZSBkaWZmaWN1bHQuDQoNCkknbGwgdHJ5IHRvIGtlZXAgdGhhdCBpbiBtaW5kIGFzIEkgcmV3
b3JrIG15IHNlcmllcy4gSW4gdjE4IG15ICJzdW0iIGNvZGUNCndlbnQgaW50byBfX21vbl9ldmVu
dF9jb3VudCgpLiAgSSdsbCBzZWUgaWYgSSBjYW4gcHVzaCB0aGF0IGRvd24gYW5vdGhlcg0KbGV2
ZWwuDQoNCi1Ub255DQo=
