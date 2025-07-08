Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CDD195FE8
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008956; cv=fail; b=aDmyYOFl2+kv/GJp9yEE0F2zOaLyAQYtSADO4aC94+RoWcr1dY4XefRBBuTQMul8JW4eZ3xxpiYoEwj/Fcv8HrlLeRVGTAPVO0fMv9QS2b3dcDcjzc4sA6SKhSxXaPZ/p6KeKB71lad4X64mKu9MCZTPhk5pVlfzu2MxMOC5tZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008956; c=relaxed/simple;
	bh=yepKCrOY7szOgI8N0lopkrhRkji3r1WEAzI1yKyuqjo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rus/fERjh8ekSBrw2rbwy1XeDiDH3KjjFj5eIE1wTHUQZIvz3MRnL8oNSNOXakWWk4y8ngGxe3RIhSVLsqEXk1qpweL12/DSVTMsdywLLTra28ebqmsiwBENeqNQ+O8gehZB+lVeKw0GW0ed3qxUcBorUHrjU2IG3o00wIfKNgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCW67wVc; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCW67wVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752008954; x=1783544954;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yepKCrOY7szOgI8N0lopkrhRkji3r1WEAzI1yKyuqjo=;
  b=TCW67wVcQoms934speNZprOaQvltYkB/IsJqi91H5GZAde1PXD7cab7R
   Ce+uYSgSsZFxfWARFeKQB2Y9n4SwYskkeSNzu0joeou52d6zIqpC3jWQZ
   KznXnJn2RcgUKGsLF0ORVw2FYwd34W9iX6FpYpeB5rHeSnjm6Tn/xjCHy
   CKKFbbN7qCdlcTHmudHwsHx/QFQ9/0q91N+FaBxZPi+ml+L0VnGJbPbSa
   KFuzLIyfQMpO3ZBVd69eFinOgjeZMMlFnxkqujvobOFcD1JofPKylKYsp
   4mfHy3v8ipoJxbY8Rr9rAeEZqJ/1ZxLmWf3ykgbK8WdGOUioF0+g216sW
   g==;
X-CSE-ConnectionGUID: w4Nh2tLTR9KUv8yCtnuvcg==
X-CSE-MsgGUID: yW2kLuIHTBmno24IpLCReg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54392013"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54392013"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:09:14 -0700
X-CSE-ConnectionGUID: YMhTfM1tSP6eN1A7ijpAcA==
X-CSE-MsgGUID: uoARpLWGRs6Pg6XcRo3V5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155225200"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 14:09:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:09:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 14:09:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 14:09:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRFumyrdEHtLCBN/wZVAdK8lbVOUd2vgOhkoLOMpAadaWu15kxVeOiY3swY+ZnFsCMjBFu+If2kH/cuJsvs+DUu8fKMY2g/c8eCqBZdPNcXu9/k+lBX1UpHVTEmhm96Bz8MEN5JhdFBsNxjbCTPr8/xicX0B0FUy5nCnXx0I1EzjscIYWKQmoXqTPunCSm6k77H9zIrS5T81ZV/Lj6L+DeofC3iH4khTdMybXp8lj1GyPhNmvSBguvsgFOqK5XgyGzJEWd6OTJc/aqMC+0ZtKz3Y+LpyOVOxfL68c8D75Pk2Gyw66vunLvwTBXUx0J+R+B8ziLZptpMB8SxkkBhDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDU28Bl4q9xtH+8wk4OXs3VjQN//TZ6+jBmBEp1CLtE=;
 b=uEdDHFklg7kU1hYHwV4ygWMmEUTJzFUlM2MnHMQgY4wn3HZCD7h6hg7ptQsw0ebJbT4Cg6bzhB5W2bxw+uwZGcI7utj30XT73XydAO3M2DgyFLG2yTPoOcoB31/XYTLvFqAHq0oCWiwpvJw99EO79SRwpBi17UMXVw678CP01JL/73C+ygcsgnSAfRjn+YgEUQpBDodeZXyPl6GW1o10x+AJDytEzzib5OSpIDUtuZbYx29dras4JNKe8dSDE7ett8XFGns3nz+SNaEAQco17Z0V0pFTbmtSTdth8DNSwzzNeSYg/eTMSo/flUz1PhYzCdlvJesx5w3yZjZr/e+Q+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8786.namprd11.prod.outlook.com (2603:10b6:208:59b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Tue, 8 Jul
 2025 21:08:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 21:08:25 +0000
Message-ID: <8a786c63-0cf3-4d23-b9a2-623424c88f02@intel.com>
Date: Tue, 8 Jul 2025 14:08:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/30] x86,fs/resctrl: Rename some L3 specific
 functions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:303:2a::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8786:EE_
X-MS-Office365-Filtering-Correlation-Id: 21339b1b-30c2-4b4d-4f41-08ddbe63940b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VHVVTURvVGg2UU1rT1ZoZ1lSNU1BS2pTZmFkKzRSWVh6Y0RmYm1zNnNMZzFk?=
 =?utf-8?B?V3piZzNqTjM2aVc5UUZyejBrQ2tDSHUrcjFNdnlhV0Y3NnU2WDh5VnZNRXNX?=
 =?utf-8?B?U2lEZXVtUndaUTBoZVNWMmdmMVlRZlN2K0NIRi82dUV6YXE1NHJ5RDhGUFpR?=
 =?utf-8?B?alBIcmJEeWdIRlJyYVZablZvYzRJNm8rOWxXZUM2bTdHbjU0eEwzQTZuT3Jn?=
 =?utf-8?B?c1BVL2UrbDJBelkwdkdwZUFwSkxRdDNwNHczRytnZXpzNXdwa0tEaER4RlVp?=
 =?utf-8?B?aW50VDM0S3hJSk5ueVJYbFFrUWN2OHVtNktpVmtDeExuZ3hQQmJ5ODJjSUNm?=
 =?utf-8?B?RGF1ZFFMcmVFcHFRRjVFd3JJK3BMZG9RMlRXUDJuTHF1WGJCOE8zY0YyVVdl?=
 =?utf-8?B?Z0NNdUY3UlBleEExZ0RjUlZyVWpDbEVOeGZLWHBQVDViZ1lrTy90ZzJxam9R?=
 =?utf-8?B?b295Z2pZMjR1UTZuTXhhSDlSWVJza3l3cXhaRnhXek93N2c0NGpoS1hKdThL?=
 =?utf-8?B?MmlnazVUVTVrU0E2SklyMyticzJYYzNCcy82UGJiV3lWWXNmK2l3VXdZc0tE?=
 =?utf-8?B?cGE3THdLbnlPWGdJbHRVcWl3azZCNllZNGNrcm1hcXB0c2V1RGUxU3FCb3JG?=
 =?utf-8?B?L0thSEpjKzJBck13d3FrbEVweUxNT0UwNFI2ak5sNTdmMEZwaGV3Sm5RY2hn?=
 =?utf-8?B?VXRBeEM5UGxtaytqN3JFcUcxdXpGZDNmREFFU05VTE5oakVjTDQwL0dJVXFI?=
 =?utf-8?B?T0REaHNNVzA5VlVFbk5MZTNTajhjRXh4d1kvQlkrVVVTWkExb2dFL0hBTDQ3?=
 =?utf-8?B?WnJEaktrdjE2UUdweDJLZzdIRjB4RTJxR0FzWmFaM21FMUxmeHVtMjVUZUlj?=
 =?utf-8?B?VUJqZW5HK3Zld0lJS1NJS1d1V1oreWx2VGlMS1BtQnQvdjVBSmY4K3ZUQ0p2?=
 =?utf-8?B?TmdBa2JGNXI5S0RwdjQwZXpjOEd2M1dBTm81dmgyTU5YRDk3NHN3QlNNRXpW?=
 =?utf-8?B?N1dGclltOHVKWDFzSVZTV1o1WWRRMERvQmR3M2d0bllueDR4N2t6NVdlRVB3?=
 =?utf-8?B?UGFRRHBrSm42TG0yLy85V0wyNFdMMEVzUWtDbVJMckZjTU44OUFsaWZtb3JO?=
 =?utf-8?B?R0d4V1V2Zzg5WmtiZHpySlFXYXQyK3gyMmU5c3dMbjlaVWhLN09GSXRSWWlV?=
 =?utf-8?B?eUZQd1VFWHlEcHQ2a0xaR28yR1NZSFhnTDFiaG9DY1VJeDNQc01TQWhYY0Vn?=
 =?utf-8?B?bU4wZHRXdXRTVS9tVURsTlQxLzVvZnpTNXI5Ylo3M3NrQVVwV0Exeml6STY4?=
 =?utf-8?B?bCtnWkVxd2h3bm1TNGdjdW53RGVBa0FzOEQzeU5VR0x0Zk1SSWVpTlZleDhv?=
 =?utf-8?B?RkxUZm92aW1qU050WWlBK0RheE0wTmdXL3NOcDRNRzc1TWY4TDJLeWs5UitF?=
 =?utf-8?B?ak8rMFQxaWRPZW1uTERIMzMrZHFtYm44OEhSbzB3OFRVK2VEdmVRcE9od1VI?=
 =?utf-8?B?bG40Y3o3bU5jOUFURVhzUnBvQWxmV3BURlVkMUYvd2QyZW9NZUwrWGJqZ2dj?=
 =?utf-8?B?Z2xOMDNKbnAxdHZycWRER3hEKy83aktEVll4Z2xDT0tXVVo2Snp3a1doWlh4?=
 =?utf-8?B?N0xRM2NsRDN2ZW11bzBONlI2R3RhZUZ4VS9CcmRzMnlQUTNsOXRHeHhxbTgx?=
 =?utf-8?B?UkxiYmdaRGpNSWhPZkJSVjlpNlZ3ajhSSXlaUGtFaXN1dGM1WUordWN2TUIw?=
 =?utf-8?B?NHFnUm9ud1NHUVdiZkJhM1ZvUVExZndqcVF6UDRHTmxwdzE4STlVSmJKZkt6?=
 =?utf-8?B?RE5WQ3RDaC9rNnVIempYV2x6OGJ4UkZmam03cEZ4UCtucTZqNlFUYzVJamNo?=
 =?utf-8?B?ZXJxV3g1Rysvamh2aTNPY1BQNXIxaTN4WWF2VXRUUS9tT2E0eGJmcTZLN3dv?=
 =?utf-8?B?WG1QOG9vWTM2bzdWTGZUY21pY3c0RU14djFDK0g3QWhQV2IvVzVOd1VFbG5v?=
 =?utf-8?B?SjkyQjMrR0VBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bngwOW14R0dRQnB5bExodUU0S2FtWm13ZlJzYklCUEFnTzUxMGZnMDhueHBC?=
 =?utf-8?B?L290dU5JaWRMZG9pSzltNkVFbmwwc2laVXc4VjB2WDU3dE5mOExyTldISTV2?=
 =?utf-8?B?eXFvWTlmZE9aNFl5WUVoY0ZHS3Y3TUg1Ym5aUEVibERzWnUyZzQrQ3V6ZHk5?=
 =?utf-8?B?Wmc1MlZUcWlCN28vVHNVWUhiTStQWEhSakVMTUM1Rm9ubWxoWUdHVTAyZTNQ?=
 =?utf-8?B?ejliUTVsTVZxNVNjczFJYytLZU45emZ0QWVYWXdXUjUxNlhHRmpxSldYYjN6?=
 =?utf-8?B?OTRjL0w3bjQvdmxLcUxEQzFBekFPWmRTRS9xdU14Q0tlM1d3aWtxVmVyUW82?=
 =?utf-8?B?Z1dkM2NEYW8zN29FSStMMjVPcUVmMlRaSUlYNnpTTUtuNWQzUGlVU1ZMeExm?=
 =?utf-8?B?dHBmK1NPeVQ3Q05kdnhLZktKMmoxTENaQmcxYzVxV1o4cDZyNUl3MGo3T1VC?=
 =?utf-8?B?VGlWZGFIK2p3QVczV1owNFp4OWtZd1N2QkhNaXN6Wm42MDFPTVk1WTNpdVl3?=
 =?utf-8?B?bjg4RG9VZlBEREFBMzg1L3JIOWdmM2hWeFFnY1ROMGlKWCsxZk56VEJiZUtX?=
 =?utf-8?B?OHhndDM5N1N2R3h3Mm9rYkhLQ2NUV2R0L0lyWDRHQW13MWd2MVkvNUYrbVRj?=
 =?utf-8?B?aHRDTE0xOCtZUldlSkpBTnZsWldtak01UTJOVUlzNytqdjAxVlYzR3JDVjFV?=
 =?utf-8?B?d244YjgzbUZHS2Rkdi83eEtNM3hrRWVkUEpMNFVpalVRMTFZekxGcDlXR0RB?=
 =?utf-8?B?elBwM2VVSGFEQUJUVngrakdJYkV3Rk5iL1UxNSs5Y1QrU2tVNFlES0MxWnpZ?=
 =?utf-8?B?enlzd0VEdHh5OFZNdGJkNlBRTXptYU9kNVFvbktwNkVaQlV4VlJZZlFzSjhK?=
 =?utf-8?B?eFVwbStHYUtKaENHRzVyc0lnMEhyeS9JTzh5ek5SdWM2RHc2cU43K3NsVi9m?=
 =?utf-8?B?a2djTWFjWVl4SGN1TVZLNXZ2TU93Vyt4cU4wUUtYbmx0N2x0cWVwRkZpMkRG?=
 =?utf-8?B?bGFkdFY3b1pNRVBSM05mT0QrQm45VkcxZnBhVVBwQWNNNHAyblpvZDJwcjJO?=
 =?utf-8?B?MU1QMVlzK3Fva0diVG1Dd2dYQnYrakxaSmxBTUNUM3AvRW5KZnlFSnlNTVhx?=
 =?utf-8?B?a255cmxvbHFpV2dBUDVqNjFGdkQySnN6SWo0d0l5MEt0Nk9RdDlDbnFtUFFL?=
 =?utf-8?B?WGFYdHc5WFk2VXNJTDhCa016T3lvSDQ4VG4wemlQSlp2OXRWN2pzc0lEeEFZ?=
 =?utf-8?B?Smg0V3lJV0s1amtBT2xVOUJ4QXI3ejRFUWxrK3JBWk93OWJwTHd0S09aTlo2?=
 =?utf-8?B?c1duMWFjRGNsRXZtSVJEQlFjSCtqQ0o5dXBmditVSlBwTlQ5cWJFY0RWblVr?=
 =?utf-8?B?WStPbVE5MnliQVkvZGJTaE9lUG9EV2Z5cXllRnhWNlNvTHJXQVhYZ0lzNWkx?=
 =?utf-8?B?Z1J2MjdJUWRYU3dnbGZacWdnbkY4NWxYRjBlVlB2ckpWSUx1cEhtRnhOSEVO?=
 =?utf-8?B?Ym1iYUVjWHFNY3R6eGNjTWJLeWpUd0lmTVFMaG13SjZkRFNrbW1lUXVCTElG?=
 =?utf-8?B?ck1TbDNrYTBjMkk3Z29UYUpudVhUMVdqTlgwTCswWjNrTzMxaVYxZ25TeWVn?=
 =?utf-8?B?OGdBY2JpUk4wT2tteW5aMHVtMEl3Ly9jSDNraEE5YTFHdFZqZ2ZVb0I2MW9D?=
 =?utf-8?B?ZnNMWXAzTzlDSW1EN2YyQityWDZYeDFDbis5UlhzODNHUjNabjdOK2JDTGd4?=
 =?utf-8?B?Z1grVWZGMytNcVhSZkIwQUY2VmVDRjVzMGVEb3AyZklLazhMY1ZhZjBKTUoy?=
 =?utf-8?B?OFlOYWRPVGN4TXg4ckNDMElnNDlRaGQ5ZlhaaFkvVysyZmdxUUlBc1YwZ3U1?=
 =?utf-8?B?Y2lTdWNLckU3RVY5L0xHUTNUZ25jUzVPSlVRWW5hMXE2aXBCSjVwZ3dCUEta?=
 =?utf-8?B?RFUwT2dUY1Y3WTlJQkhHSEFvTy82ZWIwSDhFTU9ZLzVGZ0lYUGMxUVhmTkY2?=
 =?utf-8?B?ZXgzOElhNTZxa2dML0kvQUkxVHNsY3h1TWEyQzdOME53Ky9kd1ZjZGI0N2FW?=
 =?utf-8?B?MTVCRFJhNnZNNnFLdzBZSHR5OHl1YjgzZjExUGhoQ2VtaVFUaUtMSGNsNmQ3?=
 =?utf-8?B?ZTlya0Y1Y3dudjFQZDhGSUdLR1NjY2dtcDVKS09XWVdVYk9xRnl5TjhpY3Jm?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21339b1b-30c2-4b4d-4f41-08ddbe63940b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 21:08:25.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJmxQl0YDkCkMv+WRRIV/hz6W2FDx6NVN5vtUNmdDWdjr76H/Z4I9/45nFrI5tYUdLPrQ79ZWtbKuNuRNLWG+igggo/h+UCwp1i3uNPl210=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8786
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> All monitor functions used to be tied to the RDT_RESOURCE_L3 resource,
> so generic function names to setup and tear down domains made sense.

"All monitor functions are tied to the RDT_RESOURCE_L3 resource,
so generic function names to setup and tear down domains makes sense."

> But with the arrival of monitor events tied to other domains it would
> be clearer if these functions were more accurately named.

"With the arrival of monitor events tied to new domains associated with
different resources it would be clearer if these functions are more
accurately named."
 
> Two groups of functions renamed here:
> 
> Functions that allocate/free architecture per-RMID mbm state information:

mbm -> MBM

> arch_domain_mbm_alloc()		-> l3_mon_domain_mbm_alloc()
> mon_domain_free()		-> l3_mon_domain_free()
> 
> Functions that allocate/free filesystem per-RMID mbm state information:

mbm -> MBM

> domain_setup_mon_state()	-> domain_setup_l3_mon_state()
> domain_destroy_mon_state()	-> domain_destroy_l3_mon_state()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good to me.

Reinette
