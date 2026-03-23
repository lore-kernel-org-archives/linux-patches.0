Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFA5386443
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 09:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257314; cv=fail; b=ivtDEwgZ7WDZMRefaOk9ei6zh9UdbvN3CVx+Y//EPTmD5XAY3vKMGUwi6G671BitDwIwuzWMRNEvtq9er+YJYnMQS3Mkt3b6FtL6ODyGG6S26obtYZ4QZUlz+RRPckIQMd15YCghSVIjWOlmdLoMHueJyTrnqs/RMVcFVHiaxME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257314; c=relaxed/simple;
	bh=xKdgxwsk/h3s5y0O+2k99BdcHR3E5GJwTTwlDN1DKrs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FeoIIelwfCwW0yiJTkQ4s7LphqLGXcjSRSaZWMyCGcrZlRZalAwtzR2tYY3j1XdzAzTXcRD72M8gDEU2cTA5KLrSXhorya1+8QQLKxA7m9pNGIaDhhtF810S/F0Dy4wDLLuNl0DnZFUeIJHm3wHlKZY19L7lCX/MIJvIpRjbQkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GEYW4r4n; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GEYW4r4n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774257314; x=1805793314;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xKdgxwsk/h3s5y0O+2k99BdcHR3E5GJwTTwlDN1DKrs=;
  b=GEYW4r4nvNctT6SCcjgEY0Y1p2HfOcsQ83J4xV5AdPslr6LruPDPFEpe
   4P5/h/So8XtMpDjj2y5DDfcLOtVCqvW+/cCzaatcemKJVlHa2sy4hsPho
   yjA1AWlXCNsUTd0c7hE/Mx4QUDPT/RwHJQxx4ILFlDG60YygDStOUCy+M
   VYrNSNPTVl2qg+tiN/1dCII8AiHmvr1exfAmCoObnS4fSPOCLbMnkHM9Q
   rGjhr6E/jYtDE8ePEatTtETLUUzoRxML8AdNBD1pQ3TL8H4ZWqDaphruT
   ykM1SptWF5QFGFWT+2RvZnulPAJwR7EqvNzWjE/GHmr6eUdPI7McbC9IO
   Q==;
X-CSE-ConnectionGUID: KZ8VbryYR0OZsWZJzZ2axw==
X-CSE-MsgGUID: zvvaGKbsRfSIQUUE8pUasw==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="75220195"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="75220195"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 02:15:13 -0700
X-CSE-ConnectionGUID: JnDTqRyNRdijMeILhnnI+Q==
X-CSE-MsgGUID: urnHFDt2Scqd4jsHrua32g==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 02:15:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 02:15:12 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 23 Mar 2026 02:15:12 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.17) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 23 Mar 2026 02:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fnF30Tyhy5ZLQoiBUhXOu/dZGy4D7xCjpiIrSCBycy0Sc/Uc+Z0OyViTGghyFC9g3F4hkNp6seTK07M3hIFrvWl0CeGgob3pvz1uaQDf6oagGj0U9Xf6oY//hn8MdCPSWv4GoKngPbe4PnU5xcqAEX31vYkCZ69QP9EsVEvYIDKoFc9FlyAdM6dHEx+UjPfjeQJFZJOabGl4isXcg5RNdzzCZhatae3Ul6213o9+0J/xOmkmqcsMS8ICCZEG2Doe7ttM7cJKEkZna4gg2l4Ld3mt56Re0USbZEEXwVcO0rzMyFBYW3SEBq5nXIFbBlP9Y9zy6PGZixf2UVwzahbldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hl4o75uQdBIuk4w0gysv4AK5jIOXu7KjRAhKgl2YEXA=;
 b=oc2KdiXVjb5hcuALzRSufhnqg2yqdmjqpYPj+8mNCko+oUT6BCSvUMb5DcwfRKqiSp0R5qZkYcNWNU4g9zOf8JdRxBQO7lnGwxgcyA8VatPxODgrFYPlS9WDqAs3T5hgvMWfsUcOM5sAX63YpsAjBFnLWYntOyxZ+YLAYIuHGjbIGmp/cjjIfMzsL07Neg7ZzOcdPksLNIXLtm+V/jpwg5+ipeGTcOdcHZz6Fm/Gx7wHCGlHUf9+n4ldcZ1JU/D00SQn1fYn2AN9tGwRNqBErHHsSvck+fkfdidszsYQXQTS3BRQctR+R55jMMNb1+D8eMKAsnbbhhAnx0Z5Kj/1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA0PR11MB7816.namprd11.prod.outlook.com (2603:10b6:208:407::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:15:09 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 09:15:09 +0000
Message-ID: <a3e604f4-42b9-4a10-9829-928bc9fd7b4d@intel.com>
Date: Mon, 23 Mar 2026 17:14:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] fs/resctrl: Add last_cmd_status support for
 writes to max_threshold_occupancy
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <1477243b7c470baa920d94477b30d41405fce45c.1774043709.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <1477243b7c470baa920d94477b30d41405fce45c.1774043709.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KUZPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:d10:32::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA0PR11MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 658802d8-45e7-4440-978f-08de88bcae65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: t5OSSDVeXW3pvxTDs3niUrSJrVnXnByg2hsGhWozhpEuJeS8ukH6uWIp0sr2Eo2ZXlzbiPXKpqOjkee1DWzXONIh2WtYGVbq2XJVjJj9NoyVBaGDPSDcADrNIpptXGKzgdgDDvMUoimpc5Ey2o8rIYZCnAra1YFEwSoCnqts45FUy0Y/y6hN4B/K1uWAJ7MdlVfBJVjQgJay2GJ7g2wbNv0qpGdcfkSp78cGH9SD/71PXdAMN4XijKgnVT/+4EbM1tiIDyTLwHTLqXwirkOpIW8wDPIdNWCcCGTCcO9lV90QJS51J1IyPnq6hjFK5z4ocQ2pMF2kM2QBZBddtsDT9/i4kXqqlvZomx0diF7eNIew0sstoE4h48RSeWxsPAO/4B0tSLDxzRtZKCv95yEniKvXFkmfnPPgMl9PM9Ub2pWdrGHHpKVsP2qTlMzRC0dYRsUI+yqFzKVQrbGDbcYTjahxys3ulDLyDffYjHvmMHCGFVxFPS8/hgdKkWRRH2rtGicf4cA4WWu8B531ZwnR1l1Vo/jr92ACuuvx6Syc6ienEStGEw4yINGZjsHihkbNFZIPLl/6LsMngRdQaS3cC+LkzawQpw4P2I15NqkTUzFUSU5AdsVLrgzjlfOV1z40hj8b98udNWRyTpk9YCo9wARsjRoW/9szrhMAHEXRZa0EHuEwRwYPnUBOpE4nYxh5wUWSFuR+EhhsxgKaoZTlC7R8OsojYCPRXIhUC0u+JZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SitJNXgvbGgydktkcjAvdTRabFhmOGpialM2M2ZhVkFmaFR3emFPbGRVRzFj?=
 =?utf-8?B?ZElmdEQ3c29OUGpDeFRuQ3poeWRtc0ZvSTN0UXRVcUVYc0QrL0RaYlBwSEho?=
 =?utf-8?B?Y3kwNkR5QldFNDJ3STd0R3FrRlUrM3Vrd0pDSEEzeGMwVzRqSEhMUWg5elY5?=
 =?utf-8?B?TjZDU2h5NVdPNGN0djNoakl4ZkVQcHpOMk96Zjg5Q1RVb09wek1HQ1hMRURO?=
 =?utf-8?B?N3kvM2FNVHc0Njc2VHVuOXpOS1diRzJabGJkckdTcTA0aE1MSjJlNzV2eWlS?=
 =?utf-8?B?QUlYOElMUGhkdnBndkIvaVNRTkgvZXQ1K05GbjJpTDJBNms2YWJDRWhJRlM0?=
 =?utf-8?B?V2tSM0ZVQ0pZQ0lxTG5aeExFVnFEVkpyTm42cHZGcGdESjhOVDJhaG1rN1B3?=
 =?utf-8?B?SkNHOFllbmhSSlBKaXJTMFlnVHFYc3JSbjl1QjFSWkx4eDZNaDNlRVZLeklr?=
 =?utf-8?B?ZmxxeWtsd2w4ZUFjSHBROWQrc29TRGlrS1J6enR0RUhPY0FDbm5FNVhaOGdz?=
 =?utf-8?B?Rmt0U0NiR0VaOEYrbU5pNng1YUhUZ2RUZm1JNHVidVBQcUwxb242VWlKcW0y?=
 =?utf-8?B?clRaT09zZGdLejUxMEMwbzNkVi9rd3RXd2RrZUpYTTN6bDA2ckd4QmRwQzla?=
 =?utf-8?B?aXdtSHFiVlRadGRFaEJWMERkSTlWMUVkN2EzdkgrZTdPelRQRDFUN25Da0VF?=
 =?utf-8?B?a3dGT3lDN1ZnTDZQaHdXMFptMFJwbFdqY3RIeDN4ZlRlOXI3cTgwNXloaU5p?=
 =?utf-8?B?V3NES2MxUEdSTktpMTRQOXArYnVPVndML3dRM2RGLzB5Mnlkb3htczlHVVVy?=
 =?utf-8?B?UGY5UHI0S1pDU1hHejRUR0txMGRNbDUyOTM5WE5YOXdPNVQ5MDdtSG1EdHlK?=
 =?utf-8?B?enNKSk5pdDFmSjFUUmVvSUd2eWlKN0s3dWVrNGFiYWNRaENkZ3MzeTYzbjZY?=
 =?utf-8?B?Wm9na0ZoUGNCaXhoYWFWVDBqMWU0clZ0WitkMHJoVTNRbHMvUkFhMExnMmpi?=
 =?utf-8?B?bDVPTWJrVnZac3Q1ZGpCNFZsaGNwMDUzbWNEQ3FwTU9sdlhQWTBNTGtpL1Z0?=
 =?utf-8?B?aE9wQ3JOSTRRQnpEUnR0RXFaVDFVVGxYMjJTNlQ1bk5MdFlheGdrNCt0dHgy?=
 =?utf-8?B?cHNZcnBBeGtDRXdJSE5tVjF1YUMyRzlWeEE1empodWY0NXU4c2MxK3Z5SDFi?=
 =?utf-8?B?eXZPMGVvc3JORXZWZVdQKzcrVEs2eFNEbGhOL0ViUFdTWU5kSkFTdWRhbE14?=
 =?utf-8?B?MWluZmMvcGlIbW5PMTlyTFdxa2R5V1NsdUZKY1Fsa1R0aHErQUc1NXFsUVM5?=
 =?utf-8?B?MlAvTkI3bXpLL1BqSlFSZG5uMHduVEpPMkRNZ1FnNzRBVXFkWUFtS2dCODFN?=
 =?utf-8?B?VDVqbWJCVnNNNkFjeC9tNE9PaXhwdnRYcTRBSk5GWmxVRUtLSUhBL2FsbWlO?=
 =?utf-8?B?eVpaK0VZRnJLbzA5aldUZG1CR1FOZEMyNGFwZGlIcVpGbUhjTWxMSlU5Skpr?=
 =?utf-8?B?SGZBU0RwVjN4TmNpL2VkRUFsQ3drN1hndzNpOElhbmp0V3FxL3VhZzl5MUUr?=
 =?utf-8?B?TUIvazNqNkhzRWs4UXV2ZGNoVVFEb3lDQnMvZjJ0MkFSRWxFenFPdEtVOXp0?=
 =?utf-8?B?OWgyeFV2RkhlUGdaYk5EWTVFc3ZBeU9hcmovb0QwV2dNZFBRV3E5Q3R5UUt2?=
 =?utf-8?B?TzVveTdvV29CTTNuemJNUTU5dFNXYm50Q3lYS05zVW0yNWlRM2hQSTM4aDBu?=
 =?utf-8?B?N3BHdmprd2RNWjRrSGxWQ1pCaFdXbWR5b3NXQlFJa0lHODhncWFKMmlDUHp4?=
 =?utf-8?B?ZEtaUkdWVUtWMDZIcnBrTHAyU2E1OG8vMm1tMWRIU0tHTTBDZ1VwNHBzemNH?=
 =?utf-8?B?RzdVcnpwQXVTdlh3eTlFaXJOTy85d3BON09rT1AwaXZraGZSU015KzUzeEVN?=
 =?utf-8?B?OFJnRm5nZ3BoOWFMeWIvNDNhLzFGMWpoOWRvR09ZV2tNRUwwR1g2K2ptVzdw?=
 =?utf-8?B?aGo3RHlOT0lUVWhZNmtzeEtVeGhIcjZRdGgvdXZ5M2NxY2NFTzVqT29VcmxS?=
 =?utf-8?B?NncwMkd1cTRtK3RhaU9pNVdVSHpJUGR6TkpNUXNhaWZOSnE0Z2lhUjdvNmND?=
 =?utf-8?B?ZVMzRTRrZjBueFcvQzcvYWdKNHA1eDVMNUFEWkhGMUtQZVBYclF2d2pOR2JF?=
 =?utf-8?B?MFhsUldRZHFDa1phb1NZbmgvOUkxSlVuMGpISEprWmc4dFhaYmRoVzg3V0dO?=
 =?utf-8?B?YmZ3UXJOeUgraHozTVdtNnFMZW52VkZZS0VKZWVvSXJrMFFZN0RkNGlLN1Bu?=
 =?utf-8?B?ejBjRHR0Y1BzTmYzWkxzWjErV0xqQlg1Y2FBWVJFckVYV0dxUWVmQT09?=
X-Exchange-RoutingPolicyChecked: K0THWc5UoKKDPjaaFvJWy4E2N2ogqh5B2Z4f/wxYEAmMsUtaOEoFuSywtewA2+Ha29hzNlNdgowTLKsisQA4Xp2+RfvoRpzA6wY8L9/Xluq1OHz6MJfButx3T5iU/cbC8+9Sp3zoyDajvWyHrXpkWbY2mTWnfof2YxWPLBqoeMU54jEjX8SXrtr6rLjTe6G7APyBn6gw4UMGbhXQCA0P8zhFuD1saYWC6doBAvH5kP0AUYJwQEufjOCGUC5JntLZHFPjd7h9rU+lgxKUcWHUAAOZC86kCU42SdRwLtzmAdNOcE5pmm5uk2VjjKxi75dfC1sLTBBr8/irfIMTxPt/0Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 658802d8-45e7-4440-978f-08de88bcae65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:15:09.7918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRVEaYp1QEaHvpNnxgYL+YCcNSlFU5metcG18/jsgzcjrfmZ8zNAUJ4Fjo0oqCxEGV7lP492MjRfpk6mWzPa7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7816
X-OriginatorOrg: intel.com

On 3/21/2026 6:03 AM, Reinette Chatre wrote:
> info/last_cmd_status is intended to contain more information if a write to
> any resctrl file fails. Writes to max_threshold_occupancy did not receive
> last_cmd_status support during initial last_cmd_status enabling. Add it now.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v1:
> - Add Ben's RB tag.
> ---
>   fs/resctrl/rdtgroup.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 111bff8e33fd..6fa5c8f14e3a 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1238,16 +1238,27 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
>   	unsigned int bytes;
>   	int ret;
>   
> +	mutex_lock(&rdtgroup_mutex);

Maybe guard(mutex)(&rdtgroup_mutex) and return ret when failed
so we can get rid of goto out_unlock

thanks,
Chenyu

