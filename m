Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F118D65A;
	Fri,  6 Dec 2024 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733469561; cv=fail; b=g9u0gjP3DA+UnZSXh5y5hukZ5EEeBIFI8UqxdiAHRp8Je3BSZGUkScaGxY0PB+fGvWJTAORANIx8HnoMvdK9Q6l0APJUBsBDadf5yVHXPTFpo+DdBJ3tlCIIDQ83/ykKGnQ/yORdDwex3dhBnzYuiBEUGJl196pAisgjpDDJBoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733469561; c=relaxed/simple;
	bh=eU8N+vydZ49mlp87S1H8kVQ75UjHDiyzPnhbPAfsm2I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=geQf1XSEkMcNBza1QNzHs+TOWIqGe7aXcoFPUcYKFIC3JQT/8XoWBDaq8ObCkqjpPx3UJPsOP1B1dOSP1sesgQ4fsKIJsgFZtfVbBUS7AAzF2EeN+fJcEZEMf+YjIOGC4zsJ32KxPzLCiahOzUAgWlebC1TAt0GfB8CWI8vn/5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsJheh/Y; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsJheh/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733469559; x=1765005559;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eU8N+vydZ49mlp87S1H8kVQ75UjHDiyzPnhbPAfsm2I=;
  b=dsJheh/YPRjnn2rmS9T2DEhUJ6+eP2EbUXh78rZXhMH98esfmJ2/rtMF
   pkqDJScPJ1wTn3FrzBd11zexTR11IgwMg8NnI0uRJubxciW76wUKWExAs
   +wP53sa9jWm2d/QSdpZrtfV8hVKi3CfzURRsRqORfTFEkB0nJdbrmlLKo
   oznmnwFeYVq1yz9jSOkE2Me8Q4hvxUiNj8k0fuL66SW7UW/ileI6xp7//
   EVu63cU+GvbQzTz/AUEOwI1y1bRE6X6/EN3ZLba7wK7MpJHUo0bXWd9DG
   MT+ZC9fDu3Yl2DuqY55hz0elzEGBRmkONQXOxEuIR6tsAwDvBJsWcF6LM
   A==;
X-CSE-ConnectionGUID: A9v0AnReRDCKzXCjIjTTtg==
X-CSE-MsgGUID: TEL6Dw+DRHKI3nMDxhKGsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37747069"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="37747069"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 23:19:11 -0800
X-CSE-ConnectionGUID: onhrdVp1SO+COKPF5v6QAA==
X-CSE-MsgGUID: RxGVCzL+S/m6fLX48roC+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="125235331"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2024 23:19:11 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Dec 2024 23:19:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Dec 2024 23:19:11 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Dec 2024 23:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQozWhCOmSTLT6dRORXqX8vYX179EQ4lh3I+gXCL2Z2gPT7YNTyRg6D3ftXsVpiqiYE8xQiz3SYq4uDjq4ncjeinKdUeIwdnOdk4yfXdDXcSxDSxm48cV5Ir3OiHXqODSc+RhWwVKbEGO4MRFdnpLXa9lNAF0oD3XkrIGczP4NrJFTsxxemaRWoh0SHEVR1BMSwNi1uHTz0kAAYdbSFQ1MvHjJ69nKnpGZgUhKa3+MrYgxE8sSp7vzsQGG2v8hy1RAhRHWoT1J631FGqbzAImkxYAKfeeUVDP7zsi4aES0FZrBRw3Wa7dkAffQkionpzgIyxEDuhqe3tyxu/0C6OEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=db5t86qYU4tT/OOsJxGc7LSqEhRWhoQLs3vJA2uah1w=;
 b=WCggxTlK/bRcphM8/Hk1gu8gU/JSBUSI0sxh8oiPuB4yvEXovRd4Tutyg0QvhPIBXGFU9pS9uUpQ5RVnkgxP99TB8eD+kLUpFKELInnZETh3T5w/EnXPrKRSaJIfJMiJEwwgm+d7dySeiMIvyke/0/+dmL23dBvTwthHytKunPvCIls3HpTO35W4pVZ4muniDMQUEvw8SQJxCD+SQczCKAgA8W9uEoLnS6W6bDZoee6khsUQC2O6ED+chlRfHnGSWUkQIphGUFAegicdbhBn+x3OZU9wl5ajKqx+Wc7g2V//w9QPhpcCCJjmbLoAno6wspQCKg3MJwBdLiEM9kNUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB5767.namprd11.prod.outlook.com (2603:10b6:510:13a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Fri, 6 Dec
 2024 07:19:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 07:19:07 +0000
Message-ID: <55d8952d-5628-44cc-8e01-2effea9bbdd4@intel.com>
Date: Fri, 6 Dec 2024 15:24:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommufd/selftest: Remove domain_alloc_paging()
To: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: <patches@lists.linux.dev>
References: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH7PR11MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: 212ead07-7d17-49fd-9445-08dd15c645de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rk1Lb1U0eDVSRDgwVnZDRVMzQUZFOThVL2k0NjZaNGZtQTBva1c4M2NaN2tF?=
 =?utf-8?B?YkZYc3hMYnYzRUc3bkhXK1FyblA4S251anJrWHA3TVdFd2JPRDNreXQ2UWdI?=
 =?utf-8?B?VFQxb0F3SnNEaDZ5TU1JcFkzTmwzclJDU1hvaU5WUXNVdmVzOHVIaTdTSmk2?=
 =?utf-8?B?blNvb29IakJUM0h3bHZ3NlZLbXd4UVp1YlVNejlVTXhyTW5FY1Rrd1lnV3gz?=
 =?utf-8?B?UGx1R3ZKTlRhakg5R2dESTRPeUxaWWE2V05uSXZBZStSTUVIdWljcGxqd0NE?=
 =?utf-8?B?OGV5QitiazZFY2p3Q2JWeWZ3Q09uMzNNODdOSFBuRElKaHhoeWVYdThVNEln?=
 =?utf-8?B?N3J5NG51bDBuaGYwNm5WK1NCN1JtbVR2Z3ptT1pROUcvMnFLbFNGTUtRbHph?=
 =?utf-8?B?aytQVkpEOTVrOXZ3T1Y3amk0SlUyV0lEc1dRUDJuNEVRRk9mbzJZR0JHOHNy?=
 =?utf-8?B?QWJpWEtQN0JNcDZUVUh0YU9vSVZ2RkNxamUxSUIrc0hBTHQrWVBRaHJzbkJH?=
 =?utf-8?B?Q3dwNWNSbVo0Uk9wTS9NblQ4MStVMEdVMWlvVllJSy9sbmlxYUxSNjZybzRM?=
 =?utf-8?B?OHpQS0xCMGtsOVJ0S282TUYzOHcvbG93NGNkSElIbXkrOTJpYWlaMkNjMzUw?=
 =?utf-8?B?RjJkcG9lL2FZZmhUZlBEZ0lnaVpGcmVpbnV5dW9YaWVYaUhNZFBhOU5mZE9T?=
 =?utf-8?B?TElRZ3NwcTR5TktkUG5ndllRUHdQSGgzUnY4eFk0TUV0eWF2azFsZ1g2bDZS?=
 =?utf-8?B?WDRBbjFVTXdNUEVldHVWRkZwaW1hWlJ6SWhrcjFjSEp0VGtwR0JVOGJsN2U3?=
 =?utf-8?B?bTNUVzBadWxFQ2VVMFV6SG4vUmpkNHJzNFZkeENqaGFqSTJHUDZTZkZHSU92?=
 =?utf-8?B?RXZFK08yTjZoWUhqNDhEcnF5dTE3OTNWRVlJby9HaXFLL2FScngrMEhtQWhX?=
 =?utf-8?B?Vm5tRGpranBPOHQ0ZytvRjJ2dVBrZXZob0laNkRwUnZJKzJZUEE0NFVwM1Ft?=
 =?utf-8?B?eVJkalArTGZKblNpajhkNTE2bDFiRE52NXZWZHY4YU4rWW9PTy9RWTI1NTlS?=
 =?utf-8?B?VDlLbTZPOWNxVXFoTklUVzR2bUZyR29JWDlseE9MVXQyN0x0YTUyaHJHTURq?=
 =?utf-8?B?czhaODBFczFwOHZYNUJvYzhHbXkxUFpzWTMwU1pDd2FEUkx0OHhhYVBLeElR?=
 =?utf-8?B?a1MxOTRXTmFvVHJqaXlmb0xaWkN3VHEyd01XZWs2c3RZeW1nZ2h2UUtKb2w2?=
 =?utf-8?B?WDU1YnVTTTRpRmk4bEo2cEduVzQ2UXFPMGRrVzdtZGEzTWt3TXFCa2dST2JB?=
 =?utf-8?B?ZFVtc001cXRwK1dBRlFxSVQyc3l0a1ZhemdNZXZueTYxb2xDOXJoc1QvS2RJ?=
 =?utf-8?B?U1BsSTY3T0ZDYTJ3M0VNZGZ0VFlKUVpkMGNzUnFicmJKOFZqZE1NaDZtbUF2?=
 =?utf-8?B?ci90WmdHbk1QTmVhbXU1TGRjU0diQi80MSt4cHE4ZzNtYmdRRDlkTVYwQWdR?=
 =?utf-8?B?VmIzYVVhYnl0d3gxc2Z1cU40bjlVRzlXdTlGTEo3ekIvWSsyWFJnc2dMcytp?=
 =?utf-8?B?QVdGQjRZc3RvSWFpbW5ZbVJwc0RnclVEdTc0REJkekZ2c0dTUzc4U1dRV09K?=
 =?utf-8?B?dUJwS0NMYUxzcW9HR1MyRE5QQUNydmxEdnJMcVkwWWJGSm1EeWprYjVQQi9V?=
 =?utf-8?B?N1pWK1pQSkd3UUZwWXZXN2o1Y0FXWmJOVWRuR2ZSQTNUb00wVFdiU1Nld3g2?=
 =?utf-8?B?ekFzOGN6dHJuUE5pbTZ2OFpWWEZmS2JMeGVsd2dIeUhHSjJDaUpVRWh4Vmd2?=
 =?utf-8?B?NmxDUG1VajM2L2w2V2VMZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3RZUUU3MElxajJwaXVDVzV1TlF3d0VveWhLbXlCSC9HZ1ZVd09IWGMwcFl1?=
 =?utf-8?B?RUZGd3laNHhBSjdnQ0ZuTStpRGhkdWFLWUswcUo1eFFGcVFrSUNPSndDOTcw?=
 =?utf-8?B?NHhvTWdEUFNFKzV1bFRYZXJ3N3NkWWppeldnVkIxTDhXMFZabHpGQy9nTmpB?=
 =?utf-8?B?YkROWkJCR2tlKzI3VVV2TlpvQ2xodW81ZlhmOFJMMXdMano2WmVSRGduK3RE?=
 =?utf-8?B?OGFVaWN0R1JTRk50cnZzSHNPcXNsNEEyK1E3S1lQNmx1OUZ3WGI1cFlKWWgw?=
 =?utf-8?B?TFNLOUZaYjJxVU9zalJrZ3c0TU9BR3I1eTQzWm9EWEs3b2NJMWVsYkgyZ3Iy?=
 =?utf-8?B?T2FvSXIvcHF6SXRqa1p1TUZvd0tNdERHTEF0YlJjeCtXeGsvK2p3US9ubGhS?=
 =?utf-8?B?eUpsVE1Ya1pPNmZuOGIrcDBoayswZ0g0dEJXdTE2ZW01QUdVSzBhVmswUFly?=
 =?utf-8?B?YUI2N3VaTlJpcmZObnFUcGRSZzZLWS8wWEJZRHhjTnVTODJ1bmtXdGhjaE9h?=
 =?utf-8?B?U2pHSVVYNUVRMjBUVGdQZzcxWHQ1RjBCSUdHU3ExSXZRNE55UjVqZ2duMDU1?=
 =?utf-8?B?YWxuZk4ycnhBNEFwdkRXRVA2NWdqbi9SYkoyN1h5UzVyTkxUTGoxRXRYcEFE?=
 =?utf-8?B?L1YzOWdtWGpvSWRKeFBadXk2clZRTWtRaExYa3JoczQ5N0VpVjVRanl6TFA0?=
 =?utf-8?B?dHIraHFHQU9qOVR4bDNkRFFUd2NqWWV2SGF4QlFpbG9RTUpQY1VWMVplMXJX?=
 =?utf-8?B?U3gzWmJaRG9PRmFhZ2dxSHhFQmFBcThQall6QTM3TWJOMEdzdFZscTIrcG5O?=
 =?utf-8?B?M1RpR0JrOS9FaU1KZG1Malp0bVY5cXZXQUZqeFBYditkUk9CcG5UY3VuZ0Jw?=
 =?utf-8?B?K2ExcU5FdG0vVzZEaVlwZytmRUVNSWNLU1ZJZVBhVEtDeWJDZ3VROEw3S2Nw?=
 =?utf-8?B?amV4UXNlU2NKeE5Pb0FtM1RLVmdVZWxPdEM3Z0VPeUdjbGxJaS9kQUJQNXBT?=
 =?utf-8?B?RnljUU9WUXJOOWxyTEhONTZLUjhMVmt3dFBwQVhMZWhBZjZRUTh3OWw1OWMy?=
 =?utf-8?B?bjkvcDVBWDdYaTh1N09zUjgvOGFuNjBKcFR4QXdSRVB5UUlLZ1pTcTNlWXJs?=
 =?utf-8?B?aTg1UFhoSDlOU1J4MUJZQmRxWDFTRDlNS2xiclFTUXd5YkdQMFNiczVuTEhB?=
 =?utf-8?B?YU9OZG9zVnp4VzhuS0lFblRFejd5b1Fuak9CTGZMMXRVM1ZHWjRsOG1INDRU?=
 =?utf-8?B?NE4xenUxVktoQjNORGNLQU9WN2M1Y21IcE1WdXNtTC9XM2psblFVdU9OS0Vn?=
 =?utf-8?B?ZEJMVVRYQWJrVmR1OGdVa2RtWiswZkROc2NZaUhOS0Jia2RRVXVFWHNuYity?=
 =?utf-8?B?M3lnOGhmZUNVTkZkSjFrdWNRQVlkZ3VQUHBYVnhTMDFLWGd2bk8rOVBkUFVj?=
 =?utf-8?B?VThGeHRZNWtwNjc5MnpIQWRJV1BFNGgvSWZIaTBVZHRUREtVNHh4d3RUSHpj?=
 =?utf-8?B?WmViK28yQ2VDVXA4TzA5RjMySG5hYzVnNmJmVUU3Tjl3VEh0LzFiZFpRenVL?=
 =?utf-8?B?WnlVOGhubm04MXpmNDJkRUlwamNPMjlaYThvc1lhVWc0REthU3NDbUJORUNT?=
 =?utf-8?B?R2Z5NUNKMEx3SGZmUExaN1p4bi9VdzBQS0VPYzU3WnZlYVpzRkhrbXZyVnBE?=
 =?utf-8?B?Q1BUOE1aM0VOTFNBTldXMGdmK0ZOdUtiSDFBb05UUkRXRWw3Q05kU0xpRWMz?=
 =?utf-8?B?SzJOUCttMmFwU0VFWjAxRlY5QWo2aTFGb201aU9pSEFIK1JicldiTm5RMHJI?=
 =?utf-8?B?QmZLQlpOaHRsYWJJZlBlWUFCLzNUa3VYdkZoNWhiQ2duUDErSFFJZ1lmcVJp?=
 =?utf-8?B?VUxxSjJ5Y0xwb0FaRDE0N1UwN0d0UXR2d3VsbDNoMytXa3JTWlI5eGxjOEtK?=
 =?utf-8?B?ckJJQ1B1NDdRSFhhb3k5NDlCQlpaN3lvR3JFS3M2dW0rRFFOQVBGaVlWWmV2?=
 =?utf-8?B?Nnd6UWFHNlEvMW96U2hBZVVqY0g3VnNrc2ZWcUFWdjBDeEpwSjZsMXFmczFp?=
 =?utf-8?B?MjFkQzJNV3Z0U3hScElncEFEakRNVU5kUjgxRFYyWlNORnN5MVBnbktWRzhJ?=
 =?utf-8?Q?lwEErNh6aRvr6FObP+iQTtP+i?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 212ead07-7d17-49fd-9445-08dd15c645de
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 07:19:07.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88xcHi2e0BS9a+VOOI5DWoS93hreN74rwPrW8jzj90RfKesEexVp6VhqiMYXfAWbsoUSq3+o6f3Hphc/vE27Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5767
X-OriginatorOrg: intel.com

On 2024/12/5 04:13, Jason Gunthorpe wrote:
> Since this implements domain_alloc_paging_flags() it only needs one
> op. Fold mock_domain_alloc_paging() into mock_domain_alloc_paging_flags().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> ---
>   drivers/iommu/iommufd/selftest.c | 43 ++++++++++++--------------------
>   1 file changed, 16 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index a0de6d6d4e689c..6512c1d163481f 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -311,25 +311,6 @@ static const struct iommu_dirty_ops dirty_ops = {
>   	.read_and_clear_dirty = mock_domain_read_and_clear_dirty,
>   };
>   
> -static struct iommu_domain *mock_domain_alloc_paging(struct device *dev)
> -{
> -	struct mock_dev *mdev = to_mock_dev(dev);
> -	struct mock_iommu_domain *mock;
> -
> -	mock = kzalloc(sizeof(*mock), GFP_KERNEL);
> -	if (!mock)
> -		return NULL;
> -	mock->domain.geometry.aperture_start = MOCK_APERTURE_START;
> -	mock->domain.geometry.aperture_end = MOCK_APERTURE_LAST;
> -	mock->domain.pgsize_bitmap = MOCK_IO_PAGE_SIZE;
> -	if (dev && mdev->flags & MOCK_FLAGS_DEVICE_HUGE_IOVA)
> -		mock->domain.pgsize_bitmap |= MOCK_HUGE_PAGE_SIZE;
> -	mock->domain.ops = mock_ops.default_domain_ops;
> -	mock->domain.type = IOMMU_DOMAIN_UNMANAGED;
> -	xa_init(&mock->pfns);
> -	return &mock->domain;
> -}
> -
>   static struct mock_iommu_domain_nested *
>   __mock_domain_alloc_nested(const struct iommu_user_data *user_data)
>   {
> @@ -385,21 +366,30 @@ mock_domain_alloc_paging_flags(struct device *dev, u32 flags,
>   	bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
>   	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
>   				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> -	bool no_dirty_ops = to_mock_dev(dev)->flags &
> -			    MOCK_FLAGS_DEVICE_NO_DIRTY;
> -	struct iommu_domain *domain;
> +	struct mock_dev *mdev = to_mock_dev(dev);
> +	bool no_dirty_ops = mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY;
> +	struct mock_iommu_domain *mock;
>   
>   	if (user_data)
>   		return ERR_PTR(-EOPNOTSUPP);
>   	if ((flags & ~PAGING_FLAGS) || (has_dirty_flag && no_dirty_ops))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
> -	domain = mock_domain_alloc_paging(dev);
> -	if (!domain)
> +	mock = kzalloc(sizeof(*mock), GFP_KERNEL);
> +	if (!mock)
>   		return ERR_PTR(-ENOMEM);
> +	mock->domain.geometry.aperture_start = MOCK_APERTURE_START;
> +	mock->domain.geometry.aperture_end = MOCK_APERTURE_LAST;
> +	mock->domain.pgsize_bitmap = MOCK_IO_PAGE_SIZE;
> +	if (dev && mdev->flags & MOCK_FLAGS_DEVICE_HUGE_IOVA)
> +		mock->domain.pgsize_bitmap |= MOCK_HUGE_PAGE_SIZE;
> +	mock->domain.ops = mock_ops.default_domain_ops;
> +	mock->domain.type = IOMMU_DOMAIN_UNMANAGED;
> +	xa_init(&mock->pfns);
> +
>   	if (has_dirty_flag)
> -		domain->dirty_ops = &dirty_ops;
> -	return domain;
> +		mock->domain.dirty_ops = &dirty_ops;
> +	return &mock->domain;
>   }
>   
>   static void mock_domain_free(struct iommu_domain *domain)
> @@ -713,7 +703,6 @@ static const struct iommu_ops mock_ops = {
>   	.owner = THIS_MODULE,
>   	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
>   	.hw_info = mock_domain_hw_info,
> -	.domain_alloc_paging = mock_domain_alloc_paging,
>   	.domain_alloc_paging_flags = mock_domain_alloc_paging_flags,
>   	.domain_alloc_nested = mock_domain_alloc_nested,
>   	.capable = mock_domain_capable,
> 
> base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37

-- 
Regards,
Yi Liu
