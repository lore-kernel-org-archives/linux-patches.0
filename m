Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8599253F35
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745369517; cv=fail; b=cRz495KSb1ShESIqYRQmsnY/N6w7F7/ReHjLLq+BmCyyQPaMNlE8avHqY1KSxsmOp6ARZwZ7gO3Y3+CbRRisDH/yDDsiNH08Syd3MXkGrFN6GPTcrROg0klUOkN7pSQR3FXKyFahL2+tNY6AivitUpYBIThuR3PsjXRYFoaGW/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745369517; c=relaxed/simple;
	bh=a7gQuVID9WCoL7/pjTUfLynnhhyjiIdO9B7cRyafZEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OpXdDAMuIBI2qoV8JdTqdGtrXfw2Hbi+Mg68ZUzpUWhpYjVtXY1bMfA1QohvypLV81VQdo7TpvQQ2t4zabfaSnMZr0+F7dgzlfKKSeKyLKgXtaWiNo5lLAtif+3VC67f5Psxo+dj1iJh5Ph3N9oTzXHE4CY0rj1YSz+eqW8rC1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqbsZsau; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqbsZsau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745369516; x=1776905516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a7gQuVID9WCoL7/pjTUfLynnhhyjiIdO9B7cRyafZEw=;
  b=GqbsZsauPxsncG5UrVZTGixufrYVWaqEO6LRPvRqWL3vryUf/arRsLpF
   mS5N88eVKX45nbOsoyEsW9maLYPMwuhkEoc1Le7tIwECYcEIldn3NXhkS
   KsLh7clVs1MdKC1MVg/SvlEpcnvzYmRvjffmv6ZcxOu7iA3USLdw3nWwx
   5hg51Om9F4mGHQdJeMCInTMq8gVhfzNWPjq5OSoSLBbNgTx5FfoXmajg9
   LdFPLTmqDNP25ANnuKxKCfhrow8hu3YISPfJ/xP3OdVPlLylZiktpc2LU
   NBQcd3a1fFvcdiznm4LHdWK1uU8ruG6OtJWkq5k08msRQfRkRVdV105Nl
   A==;
X-CSE-ConnectionGUID: Ntv+TG0HRGyLoXWWHA76MA==
X-CSE-MsgGUID: F3y9FcjxT+CAHjuqdzimYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="49611582"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="49611582"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 17:51:49 -0700
X-CSE-ConnectionGUID: GaA49TPWQLuxTSCaKxcjxw==
X-CSE-MsgGUID: lY+zIDf4SfKNWBGHuXJBuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="133043327"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 17:51:46 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 17:51:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 17:51:45 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 17:51:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xIEEROwraOGbsnmF9GQsd7RwCV62cpq+JKeX2d91NC4e8uHsyimlv6mj9H43O+3XAzYio1qzrn4JJu8ipGtKPRCcgrpZcP+pW+o03qbOCMMJxB+umZObnY6C6HsvwXSWu6h7NuD+eWBIiEkjQOm/94Pm4SmaKa+FgpX0FsxLi2rTxBm/+50YWbbGeFCyQYpnnLQ6tze+7THNiR9eBxRy1ejkusFsKk3pTkg9uuZCPVP1Of1nMY2Sl6lASa4i+xVYIXrCxguCSKJJb/JZBDZZSbG9+v00OCJGzdqiOfr1Pam+bJezys4mCQ7fp9sAto9Ob01ruAZ8A8gpEcCvqKE6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7gQuVID9WCoL7/pjTUfLynnhhyjiIdO9B7cRyafZEw=;
 b=UTBvR2OasVX6ixlR15LCy+2oDlfVN3twWGTQbTJ2NILyomiLkYZE2UXm7sRGQ7/GviWWTB3WhUB/y5yBWFzXar2Wj09OebhvVEjF9NDrMQGuqzZJ+PEAIK76SM3nJ8dsTvEyLVE2Pr7olAdZiaMARJt6XQVtMp4xEQw02/SNm7NZZReSd4YdSKf/qsZCBZUQKU3xVpVGU3Zi2dk7l+d3pqV5E6YCkZQjyK+trCf6Qs37gHhbsC2aRpkjsHSf8nh3MGreEcu4NgCnP3DuKZRZSgpRH7g2us0hWRc24LxNyqmrOP03YQy3WxjweI93hgVqOSNtxP8LR8A9OOAXAM8VGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) by
 DM6PR11MB4513.namprd11.prod.outlook.com (2603:10b6:5:2a2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.23; Wed, 23 Apr 2025 00:51:37 +0000
Received: from DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec]) by DS7PR11MB6077.namprd11.prod.outlook.com
 ([fe80::509c:f906:cc6:2bec%6]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 00:51:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
Thread-Topic: [PATCH v3 10/26] fs/resctrl: Improve handling for events that
 can be read from any CPU
Thread-Index: AQHbqBaEHhpPnF3YeUi0jcZ9tuBUaLOqGWEAgAX8wIaAAGqfEA==
Date: Wed, 23 Apr 2025 00:51:37 +0000
Message-ID: <DS7PR11MB607763D8B912A60A3574D2BAFCBA2@DS7PR11MB6077.namprd11.prod.outlook.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-11-tony.luck@intel.com>
 <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com>
 <aAaqbUk3gZbCan13@agluck-desk3>
 <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
In-Reply-To: <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR11MB6077:EE_|DM6PR11MB4513:EE_
x-ms-office365-filtering-correlation-id: d506a7f9-3487-45c1-f875-08dd820100e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZDJlZmJQS3NTOHZNWDlwdVBVaEl0VmRyQkNlUE5rMXZrWGpUNklXaGZTWndV?=
 =?utf-8?B?VzhIdm5BZUlObTc4U08wcUlJVTE4dWt3a2VpejRETjI2cmdOM25JNC93RHgr?=
 =?utf-8?B?VUlXNE4yRWx4cDR4Uy9sUFNPdmhMOUhnZUYxUE50YjBrNlJiSi9BaFVQZE5Y?=
 =?utf-8?B?UEo2MUMxWG8vdGRvdzFFUG9DN2VaTXhPcHBlSEcrbC8yRVhKMDV3ZUk1b3o5?=
 =?utf-8?B?VUMvdzNxRWNGUjFKRFUvNGpRVmlqQ0VTRC90bjVrb0g0SE40L3l5aEdIRk1p?=
 =?utf-8?B?M3d5UDd6YlV0N0tZcTZIK2U0MGJyT0ZYbFc2OVgrQkVoSjBFY2gzaklmdCtv?=
 =?utf-8?B?VTBpMzNJcWw4NXhmam4vaUJodzViZ291UU9nNlNhT2pLdmJZNVEwQzR1TmhS?=
 =?utf-8?B?dUhwZkgzemdxeE1jNXVBcy82V3FPcWNwQmJTVHVMV0pvd3ZSTkZRWFppNnA5?=
 =?utf-8?B?bHlHdVBQTVkvU0xSdDllY1lKVytiS1g3RlFOdElJN3ZzSFc5bWhSYThhazZS?=
 =?utf-8?B?dVI3NWhBSCtNd0pKLzQxWVVEUVI4NWxCQ002Uk5HT1M5VUNrUHNUSWROaDVk?=
 =?utf-8?B?QVZ3QzA2c0FTZ2NyTFZvR1RldzVGc2JxYlluU3NoelBXdTZrZGpXY0FDbUlI?=
 =?utf-8?B?dXE5RmlmRHRyMjRBRVNlRHk5ME5aVlNDWGE2cHdUR295SU42enhkNmNqbWtq?=
 =?utf-8?B?b1lGeU5SUFF4WXdmM2cvbyt1RTFVZnNXdWhQMFNLNmE0UGtNcDdVTmxPUW0v?=
 =?utf-8?B?QlNnenNTSzRHWnVYeW1NWkM1OEhPQmN3Vkh6eldKc2lkWDlDWVdsdm5sSjdZ?=
 =?utf-8?B?Q0JEU2hOM21RYkpNUWhKVVUwd2FjM3FqWFBqT08rT3VJOFVHVjJHZ2wya2c5?=
 =?utf-8?B?dzgyK083MFVJWXE1M2NML0ZoZ29DTVZzdmQyVm5EYllPSG5Oam1GZVFxNjZj?=
 =?utf-8?B?OFNaUENXUU9NMzJZYjN3SUpraWQ0MldhVjA3d3ljTGdKRGoyU203VWVzSUcw?=
 =?utf-8?B?R0NGNUw4dkpSY2dmcWthU3RxWVJWU1ZjQlVYQmxnL3g2VFpGTTZKRkJlL3JG?=
 =?utf-8?B?NGxQNzVFTmJndktuQVU0aUJHa0IvQ3AxRHZrWUdHTGkyQkM3ZVlrWENkOFNw?=
 =?utf-8?B?TFJEOGhMT1QvY25OVld2QnE2UFlvZFBtUDNSbUwyUEdnaXowTUZoOGJvS2xv?=
 =?utf-8?B?Q2wvVXYzK0ljTmNwYzBmeWYySEwxbE80U2d0MmN2SFdVdnV5aVUyVXJVRXRs?=
 =?utf-8?B?OFBvSkFmV0JYMXEyWVFOc0d6TndkaEVYU3hhZlZYV0ZkQmdkUk5ERXJFUzFX?=
 =?utf-8?B?NzhwY2hvQUs2bUJTYUxZNjV4eWFDWENISmUxblJ0b0RZYkhKY05TNFdXM1Qy?=
 =?utf-8?B?QUhUenBERkJ5TmFUNWF0ZDNqVHBkNUlwcHk0Vk1nYmE0ZEpzKzg4ektqUExW?=
 =?utf-8?B?dnVQVFFWY1lyM2ZmTUxxendHWCs0cXhCWCsrSEM2UGVLcVZrdXBYNTBBTFRl?=
 =?utf-8?B?MDJmcmMwY0d5ZDUrT1l1YWtoVEpYYTNBSmNmQzNpZkthRkhOQTJTcVlrVHFu?=
 =?utf-8?B?UkozN3phQnpZRjhwM1dwTVV3allNNDU3VWZkT3ZJZ2xhRGllSlRwZUEvY05y?=
 =?utf-8?B?b1MxeFlTemllZDM3V3FSZVN4RGZUcGJ4a3F1ajNpZ0tINnBIZnFlUm9vZ2dz?=
 =?utf-8?B?WHhVZmc1Y3pZRk80SXEzWmZjMURxVVZJZjd1US8welg4WnZCbllHbGhjQ2dy?=
 =?utf-8?B?ZlV0VzRGTXVNb2xReGxqdlJyeDJIMnNJM0NXQU54b1NNUHlrUk9CWTBWVHBB?=
 =?utf-8?B?TDFXbG9rMytMdW93ZlIreVppN0tGeHlLZmRCVEd3SzN0THpUUWZSYnFxVk5L?=
 =?utf-8?B?blFNMEJIdzkrc2dTOGJ5ZWd6Z0xtNFF0OU1hYndNTndrZ0hwYTJ0YkttMVNu?=
 =?utf-8?B?Q1p6UEdZcWFUUHZlVHZtbWh4Z0VISGkxc0Z5R1dDbStTczlaS0c1WDIvRWNu?=
 =?utf-8?Q?QU9+OGvcbRlaiGaqOHsLey4lp/Al8I=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6077.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0VaWEpFbGFjUkpGaFdtVFNETnBDK3Rzb2YvTnFHR28vZVdRT09ycE1IaHRi?=
 =?utf-8?B?TC9CZENSN3pJSXZ0OEZFOTR4WVJEc04zY3Z1VHYrMGd3VnZoTVJTRnlMRFBY?=
 =?utf-8?B?RmtZdEY3QTZBVlVpRmROVXlrM3FienZraEk0di91UkFBS0ZXR1crcCtLSC9Q?=
 =?utf-8?B?QU5JRm15d3JiQVpITWd4MFIvMXQ5NDdSUHdWVWQ0cVEyTmtxZWxjaUI5N0g0?=
 =?utf-8?B?MGluM09UQ0RxTUdkT1FlVFVjaDVZK3lGMldXTERGWDBXZ2pZUHo2RTVod2g4?=
 =?utf-8?B?ekxTd0pLQUwreGY5akhHMVNuZlhkUFFGNlZlck9DaU9hRFJIaDRvZE44REFn?=
 =?utf-8?B?M2dKNW0raXozWkRsTE1jTW9BZHY0NldoNTRBdTZaRzUyVEtaRHVnZFpwUDNy?=
 =?utf-8?B?b0Yrc09kMWZCY09tQlpxRW1MbEc3bUZHTmxFTkszdEh3K2hsUHo3cnNXcTY5?=
 =?utf-8?B?QlRwWXp0S1IycEFZa2ErQkQyeUhwMnllUW4zS0dpaFA1UmgvUk5nK0xKRG96?=
 =?utf-8?B?UXN0Zk5FZEFTQnNTUFVSZ0hFMENmRnYxa2lPdTFIdjEydkhoQUl2L3gxeFY4?=
 =?utf-8?B?cnJDMUtFUnVzRTBOSVVoQ1A4cmxaSkdrWmtqNnlWUDJodjF3RnZyOVhSVGNF?=
 =?utf-8?B?cGx5anhSMkJhUXNRWlZuNWdlTnhEeHlaZnZ4YVVjZ241QWxIRHBQai9sQUhN?=
 =?utf-8?B?V2ZlbjJvVWpNNFJVb0ttM01XblA5aWNkRFBoRFZHMVhHbWxnditxZ3V2V3lF?=
 =?utf-8?B?RzNqQXI5bEVkckV6KzdKMUgvTFdFLzNIMStQUE0ycnZrMm1tbEZVREtSb3VR?=
 =?utf-8?B?QThSeVNjbGVmTGw2MC9vY21oMWlsYk9qM0RoRWp1NDl1ZUNrWUI0dGdIUGFk?=
 =?utf-8?B?a3Y4c2NjWXcrendJVmt5ZkRMcEg2SmFjT3FwbXpZUFdaUTlnY3ordndmc0Ru?=
 =?utf-8?B?azNoY3cwL3pLQnpmZldCWXVPZXVMdWJWYUdPQks0TXVockhkZTlYVWJ6V1BQ?=
 =?utf-8?B?VmRYL0xqd2NsOEJSNW91bGJSZjN5cTJUTzE2eWk4ay95RlRLWU44cXY0N3pB?=
 =?utf-8?B?QXcyMC9GUVl1UW4vWUdqUHdOU1dwbHhHYWZLTHVvcWZLTVRlVHhXcnJCREtX?=
 =?utf-8?B?SFZiWldwT3A4OVorMUpVaGh3TFg2OVpodklMZUhoSGxZam9kN0lCUEExTjc5?=
 =?utf-8?B?cWZxVXhFYmkxYS9xbVltRlJyM0lzZUt4REZCUG11Mk5LVzBiQXlyaFBjZ0tC?=
 =?utf-8?B?cWRjM2pVbkExSE0zME1rQWxhSmp0MUFrdG55UWpEaVlJSTI1UlBTTWthanhM?=
 =?utf-8?B?TS9pRm1DZ21KZ0VIR1JlTHI0MnVBMHU4OXd4c1lmdFIvQ1VRaEYzb2FySmJo?=
 =?utf-8?B?dnJDK211NnNHcG1CNnNwODFQcGlUVWYxTFZYaWt3bS80ekhBMkprcnhINUpC?=
 =?utf-8?B?ZkRUV1pmVi9GMTRWc2Z4SEc3blgzUWpKV0plYWx0aE5nYUJIaTd4b1NDMDA0?=
 =?utf-8?B?VmNWekJ6OXBHRTdHSncwQkVjaTNBZW1ZK0phRk1JRjZCUTlyRW9ydWlwS2xq?=
 =?utf-8?B?SXowL1RJL0tjNzhXaUpGQkRNRkpjdGY3dW9wUjJQTEJBUGNrYlhzWnFpQ1Iz?=
 =?utf-8?B?Yy9Zck4wVUJhK2pIMksrQWtHWFg3MGtQckloQ2xOWHc0a1padUVZUE5QQ3R6?=
 =?utf-8?B?SjM4V0c1ZWJWZHBKclNnZFFkWWE0cDdDVFFRK2prcG1jcUsyR25DakVLT3B0?=
 =?utf-8?B?RGtQNFZHckhlY2Y1SC84ajczQXB5anlyQTFUYVZyTlZzS1hxTStBb1pPSGxI?=
 =?utf-8?B?cnQ2bWVibElxam9pN2JISVJ6SWpiRVU3UXVrYVlWaWtQQ2N0QzBWWi9vMkFi?=
 =?utf-8?B?ZWx4VWJVbGZLV2VGaFl2N1VLQjNiNU9oSThPMkV3Wlgva2xEUEpDdW1iV080?=
 =?utf-8?B?NjcvMGg3MHRBVlV5UHRUV3RuY3dndUlSU0VCZ3NOOWxFS203TWVYVzFLYzdH?=
 =?utf-8?B?ZTdtcmYxNzBIVURPeHc2N2lEd05YdGRiTE5QbUREN1g1S25mUGowdUczUkNp?=
 =?utf-8?B?OTcvdUF4bC9XcDZRQmhYWWdrMnRUZkt3NENxd3d6UGRUdVZZZ0IxTnN2a21u?=
 =?utf-8?Q?qgtEnfNLAybfDJVOYyxS7olTA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6077.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d506a7f9-3487-45c1-f875-08dd820100e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 00:51:37.7839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8aWZN3inpzeq08Jtot0NY2OpENips6iHBGTso13fy3KiUh8VVoJQ0sSlO9US+iauIpFb2rCKmIc1QAvJvQo2Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4513
X-OriginatorOrg: intel.com

PiA+PiBjcHVtYXNrX2FueSgpIGlzIGp1c3QgY3B1bWFza19maXJzdCgpIHNvIGl0IHdpbGwgcGlj
ayB0aGUgZmlyc3QgQ1BVIGluIHRoZQ0KPiA+PiBvbmxpbmUgbWFzayB0aGF0IG1heSBub3QgYmUg
dGhlIGN1cnJlbnQgQ1BVLg0KPiA+Pg0KPiA+PiBmd2l3IC4uLiB0aGVyZSBhcmUgc29tZSBvcHRp
bWl6YXRpb25zIHBsYW5uZWQgaW4gdGhpcyBhcmVhIHRoYXQgSSBoYXZlIG5vdCB5ZXQgc3R1ZGll
ZDoNCj4gPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDI1MDQwNzE1Mzg1Ni4xMzMw
OTMtMS15dXJ5Lm5vcm92QGdtYWlsLmNvbS8NCj4gPg0KPiA+IEkgcmVtZW1iZXIgUGV0ZXIgY29t
cGxhaW5pbmdbMV0gYWJvdXQgZXh0cmEgY29udGV4dCBzd2l0Y2hlcyB3aGVuDQo+ID4gY3B1bWFz
a19hbnlfaG91c2VrZWVwaW5nKCkgd2FzIGludHJvZHVjZWQsIGJ1dCBpdCBzZWVtcyB0aGF0IHRo
ZQ0KPiA+IGRpc2N1c3Npb24gZGllZCB3aXRoIG5vIGZpeCBhcHBsaWVkLg0KPg0KPiBUaGUgaW5p
dGlhbCBjb21wbGFpbnQgd2FzIGluZGVlZCB0aGF0IHJlYWRpbmcgaW5kaXZpZHVhbCBldmVudHMg
aXMgc2xvd2VyLg0KPg0KPiBUaGUgaXNzdWUgaXMgdGhhdCB0aGUgaW50ZW5kZWQgdXNlIGNhc2Ug
cmVhZCBmcm9tIG1hbnkgZmlsZXMgYXQgZnJlcXVlbnQNCj4gaW50ZXJ2YWxzIGFuZCB0aHVzIGJl
Y29tZXMgdnVsbmVyYWJsZSB0byBhbnkgY2hhbmdlcyBpbiB0aGlzIGFyZWEgdGhhdA0KPiByZWFs
bHkgaXMgYWxyZWFkeSBhIHNsb3cgcGF0aCAocmVhZGluZyBmcm9tIGEgZmlsZSAuLi4gdGFraW5n
IGEgbXV0ZXggLi4uKS4NCj4NCj4gSW5zdGVhZCBvZiB3b3JraW5nIG9uIHNoYXZpbmcgY3ljbGVz
IG9mZiB0aGlzIHBhdGggdGhlIGRpc2N1c3Npb24gdHJhbnNpdGlvbmVkDQo+IHRvIHJlc2N0cmwg
cHJvdmlkaW5nIGJldHRlciBzdXBwb3J0IGZvciB0aGUgdW5kZXJseWluZyB1c2UgY2FzZS4gSQ0K
PiB1bmRlcnN0b29kIHRoYXQgdGhpcyBpcyBiZWluZyBleHBlcmltZW50ZWQgd2l0aCBbMl0gYW5k
IGxhc3QgSSBoZWFyZCBpdA0KPiBsb29rcyBwcm9taXNpbmcuDQo+DQo+ID4NCj4gPiBUaGUgYmxv
Y2tpbmcgcHJvYmxlbSBpcyB0aGF0IEFSTSBtYXkgbm90IGJlIGFibGUgdG8gcmVhZCBhIGNvdW50
ZXINCj4gPiBvbiBhIHRpY2tfbm9oeiBDUFUgYmVjYXVzZSBpdCBtYXkgbmVlZCB0byBzbGVlcC4N
Cj4gPg0KPiA+IERvIHdlIG5lZWQgbW9yZSBvcHRpb25zIGZvciBldmVudHM6DQo+ID4NCj4gPiAx
KSBNdXN0IGJlIHJlYWQgb24gYSBDUFUgaW4gdGhlIHJpZ2h0IGRvbWFpbiAgICAgICAgLy8gTGVn
YWN5DQo+ID4gMikgQ2FuIGJlIHJlYWQgZnJvbSBhbnkgQ1BVICAgICAgICAgICAgICAgICAvLyBN
eSBhZGR0aW9uDQo+ID4gMykgTXVzdCBiZSByZWFkIG9uIGEgImhvdXNla2VlcGluZyIgQ1BVICAg
ICAgICAgICAgIC8vIEphbWVzJyBjb2RlIGluIHVwc3RyZWFtDQo+ID4gNCkgQ2Fubm90IGJlIHJl
YWQgb24gYSB0aWNrX25vaHogQ1BVICAgICAgICAgICAgICAgIC8vIENvdWxkIGJlIGNvbWJpbmVk
IHdpdGggMSBvciAyPw0KPg0KPiBJIGRvIG5vdCBzZWUgbmVlZGluZyBhZGRpdGlvbmFsIGNvbXBs
ZXhpdHkgaGVyZS4gSSB0aGluayBpdCB3aWxsIGJlIHNpbXBsZXINCj4gdG8ganVzdCByZXBsYWNl
IHVzZSBvZiBjcHVtYXNrX2FueV9ob3VzZWtlZXBpbmcoKSBpbiBtb25fZXZlbnRfcmVhZCgpIHdp
dGgNCj4gb3BlbiBjb2RlIHRoYXQgc3VwcG9ydHMgdGhlIHBhcnRpY3VsYXIgdXNhZ2UuIEFzIEkg
dW5kZXJzdGFuZCBpdCBpcyBwcm9oaWJpdGVkDQo+IGZvciBhbGwgQ1BVcyB0byBiZSBpbiB0aWNr
X25vaHpfZnVsbF9tYXNrIHNvIGl0IGxvb2tzIHRvIG1lIGFzIHRob3VnaCB0aGUNCj4gZXhpc3Rp
bmcgImlmICh0aWNrX25vaHpfZnVsbF9jcHUoY3B1KSkiIHNob3VsZCBuZXZlciBiZSB0cnVlIChz
aW5jZSBubyBDUFUgaXMgYmVpbmcgZXhjbHVkZWQpLg0KPiBBbHNvLCBzaW5jZSBtb25fZXZlbnRf
cmVhZCgpIGhhcyBubyBuZWVkIHRvIGV4Y2x1ZGUgQ1BVcywganVzdCBhIGNwdW1hc2tfYW5kbm90
KCkNCj4gc2hvdWxkIHN1ZmZpY2UgdG8gZGV0ZXJtaW5lIHdoYXQgcmVtYWlucyBvZiBnaXZlbiBt
YXNrIGFmdGVyIGFjY291bnRpbmcgZm9yIGFsbCB0aGUNCj4gTk9fSFogQ1BVcyBpZiB0aWNrX25v
aHpfZnVsbF9lbmFibGVkKCkuDQoNCk1heWJlIHRoZXJlIGlzbuKAmXQgbXVjaCBjb21wbGV4aXR5
IHRvIG1ha2UgdGhpcyAicmVhZCBvbmUgY291bnRlciIgYmV0dGVyIG9uIHN5c3RlbXMNCndoZXJl
IHJlYWRpbmcgZnJvbSBhbnkgQ1BVIGlzIHBvc3NpYmxlLiBUYWtpbmcgeW91ciBhZHZpY2UgZnJv
bSB0aGUgZWFybGllciByZXZpZXcNCnRoZSBmaWxlc3lzdGVtIGNvZGUgY2FuIHNldCBhIGZsYWcg
aW4gdGhlIG1vbl9ldnQgc3RydWN0dXJlLiBzdHJ1Y3QgbW9uX2RhdGEgYW5kDQpzdHJ1Y3Qgcm1p
ZF9yZWFkIGNhbiBjaGFuZ2UgZnJvbSBob2xkaW5nIHRoZSBldmVudCBpZCB0byBob2xkaW5nIGEg
cG9pbnRlciB0byB0aGUNCm1vbl9ldnQgKGFzIHRoZSBzb3VyY2Ugb2YgdHJ1dGgpLg0KDQpUaGVu
IG1vbl9ldmVudF9yZWFkKCkgY2FuIGp1c3QgaGF2ZSBhIHNpbXBsZSBkaXJlY3QgY2FsbCB0byBt
b25fZXZlbnRfY291bnQoKQ0KanVzdCBiZWZvcmUgdGhlIGNhbGwgdG8gY3B1bWFza19hbnlfaG91
c2VrZWVwaW5nKCkgbGlrZSB0aGlzOg0KDQoJCWlmIChldnQtPmFueV9jcHUpIHsNCgkJCW1vbl9l
dmVudF9jb3VudChycik7DQoJCQlnb3RvIGRvbmU7DQoJCX0NCg0KVGhlICJnb3RvIGRvbmUiIGp1
bXBzIHRvIHRoZSByZXNjdHJsX2FyY2hfbW9uX2N0eF9mcmVlKHIsIGV2dC0+ZXZ0aWQsIHJyLT5h
cmNoX21vbl9jdHgpOw0KYXQgdGhlIGVuZCBvZiBtb25fZXZlbnRfcmVhZCgpDQoNCkZvbGtzIGNh
biBzdGlsbCBwdXJzdWUgdGhlIGJ1bGsgcmVhZCBvZiBtYW55IGNvdW50ZXJzICh0aG91Z2ggSSBl
eHBlY3QgeW91IG1pZ2h0IHdhbnQNCm9uZSBmaWxlIHBlciBkb21haW4sIHJhdGhlciB0aGFuIGEg
c2luZ2xlIGZpbGUgdG8gcmVwb3J0IGV2ZXJ5dGhpbmcpLg0KDQo+DQo+IFJlaW5ldHRlDQo+DQo+
ID4NCj4gPj4gUmVpbmV0dGUNCj4gPg0KPiA+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvMjAyNDEwMzExNDI1NTMuMzk2MzA1OC0yLXBldGVybmV3bWFuQGdvb2dsZS5jb20vDQo+ID4+
DQo+DQo+IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL0NBTFBhb0NncG5WT1JaZmJL
VkxYREZVWnZ2OGpocFNoSFB6QjNjd2RMVFpRSDFvOVVMd0BtYWlsLmdtYWlsLmNvbS8NCg0KLVRv
bnkNCg==
