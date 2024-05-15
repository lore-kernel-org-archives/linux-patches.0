Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049C4157A67
	for <patches@lists.linux.dev>; Wed, 15 May 2024 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715798941; cv=fail; b=bHbMIyz7dt38tWEH8/sQi6JL24pS+MLwByE9IDgjU0hGaVxIkyv1io589/zgIo+13pnnCmYP8bE44EFEKbzANhHzqOWOPX404m//Cb0piK2oTPIODDM+EGYft0j7Y1+VGuo3MlxgNDEK6J7XvfsXYdUyJGEefJWnPd/W/WvvHm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715798941; c=relaxed/simple;
	bh=kdDYhDelKfQ2YdLrwVQ7YdwrBLzkhay1CL7s1WduyEU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ql0k6+nJaRDSrfUDmFZKpPIBTxjoSjPlP1qPnYPnxwdsSB9sh7oFZ50h4LWsPZK2dukqV8pgCsqtqcTHA5+oscYOS0mcIYF5s00d9dCsyOdOVlWS2APXHzpb3A1K2vZlP8X29Z4bDbZMJvNjDqUoWGz9Zaes53kfJyasGjcXOrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNMsYCVw; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNMsYCVw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715798939; x=1747334939;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kdDYhDelKfQ2YdLrwVQ7YdwrBLzkhay1CL7s1WduyEU=;
  b=GNMsYCVwX62rgIwWRREhYWZvm0u+sGoic/i24+fb9/DZ9fp5NhBR3NMj
   DdUARCv5TbWNkmEPUMmG6SxGJfIoUuTfMMhJDzbEAyNaMzwnOYQFfEmtk
   WHmsZiNMr4KXxmqZ/+cXK33oq9olZ04GQg9dHy8x5PhK9O+mzA9ilJ8k+
   I9DJdDRZZSO1YNbCjReMwrVm5ICMVEV1MK0wsV3CMIdJ8bYZG9W1tWQNq
   ccueQl715X18LHfx5a9YtiZx8n/U3NoXlNaTTnenwFZlbkze6xkZHNonu
   Oka8YknVxbpAFg7RsFj1OshMICZqaAwPB1wTmBMYznP4GEqTuk/w3BX+9
   Q==;
X-CSE-ConnectionGUID: Vu0v124ESvuPmP/r8IICig==
X-CSE-MsgGUID: L0lI24vaRFC9XAcSwB/pkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11703682"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11703682"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 11:48:58 -0700
X-CSE-ConnectionGUID: xar0bFOwQhyiT5lfg5iF4w==
X-CSE-MsgGUID: kjGZx5e8Sm+0P9gUYoqJOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31082598"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 11:48:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 11:48:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 11:48:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 11:48:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8CABHeaARbSkfq3m3D3XN0m/bXYuv+NOY3IZqaMvbiqgeOPH1hbc1VdR0BePbeH1C5gvDZwBtcifHisRHIME3Qn3ahsLAoHAlgZkBOUk1CR9Bmt9wQoFMwpoEVR08vIOSz+nZ7r647wNIHNn0PaO5RQ4KoYdd4Wk30yJE879EJaxnMfSm87CgrL6gv7e5gMS95QJTJw9Knixs4lPYu6K/fBx49a6v/52LHEeIbfzNjF2cfKll8fkda6vHxvrBAtQzbqy4YVB58Of9Wqvu0QX9udbhzAPn8Xb7pyMfNkwzkg1cIfJiccz4ewOx+AU7X0f5fwBiuCQqsU+xepR8zIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sgDPvfsQIVM58nVySACtJo5pVY301+3O3oE/FwThPU=;
 b=JUCkeKO8VEET3bNwIcU98cOfbpccvL3WK3cheBerxCetae9idueoTjZJcOujX8IE1dnOOXKLRl0WxK6EJYc/zpI1ULucpfygRiiH7ZJFkvjuEkDtQcKTPRz6PWnSXpklE5JfCfgQDhpWCw0WVhCfUk5285O9bxUlFNMX3AvCYPNWQyrQhyDnfivFm/DCZrw/h7G/ef5CMWxxa31JVMWm1a5EdJO+MqAII70TP9d+eTBbh1acHMDeggMNXgTTFELA1QoHMcDm1LXWLG/hDghi3b/cHNDTn+W05Z3B8T0QrocjA/Tc8V4/4RBSwsiGtprRw/0+9p7CO70wx7LzqJ0UYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7964.namprd11.prod.outlook.com (2603:10b6:510:247::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 18:48:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 18:48:54 +0000
Message-ID: <8c1fa448-2b75-4fca-8379-8f18e06861bd@intel.com>
Date: Wed, 15 May 2024 11:48:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: Tony Luck <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
 <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
 <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b718c70b-21ea-4c4d-9ecf-387b8276a721@intel.com>
 <ZkPdPTbgH-0EpBc4@agluck-desk3>
 <666470f0-e8c0-423e-bcb3-ea16359f5cfd@intel.com>
 <ZkTvdtzhlCg7SOQo@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZkTvdtzhlCg7SOQo@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:303:b5::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: 3303249b-cb59-4401-8d50-08dc750fabb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VHcvZVdFcnZzSnVIcmFqY3VUVGRNY1BEVXNlc1ZVdVNPN05Mak5zSGMxenpQ?=
 =?utf-8?B?dDVhQm9CMWFIeC9GbFJJblRDekJLWHJjNVdYdXk4MW9wOWl1Vkc4SFAvY0o0?=
 =?utf-8?B?bkRPU29NcFdUSTE0dHFWS2ttVm81a1FCT3MwNzBCdkxjRHcxY0hTb1JzSkJF?=
 =?utf-8?B?SDB6bGU1ZVkzRWorSVVMeWhDY1ltZU1hUy9Zb0F4YTBJM053NUpuUzEyTXEv?=
 =?utf-8?B?TW0xeUovSE5rdUdNb01uaG4vODZKcXAxR1RvTS83em1JWkxwRWFkWUZ5VlZl?=
 =?utf-8?B?N2tITk9iR3dwZTBqTnJhL0hSTzZKZnkrMUVwZUpXejFudFZBK05sUGY1SjNT?=
 =?utf-8?B?Wno1N0hoNTMwTkNEOTBQeXQ4S0I4TnBXbEtZYmFYTGc5cFdrN2xXV2ZZTFB2?=
 =?utf-8?B?Zi9jbVFXajdaQ3ZDVzdmSEpkUUNDOTcyZHBkYjhHTzF2M3A3N3VjaDBWb0NX?=
 =?utf-8?B?SkdWS2pSdVc2WDBRQ01WOUxCR1lCbC9ESHkxTFBKZUQ4Qll2Mi9BNGM1V3Ru?=
 =?utf-8?B?eUFnaGNTMVlFNTNud014WjZkU3dhV1ZCekRnM3lDSksra0lKZDRyRVFJNXhw?=
 =?utf-8?B?TUZ6cXozcnVpQ2NlbUpzdkFta1VhVENQTWgxMEo4eVdsSlpXbXRpclg1em1S?=
 =?utf-8?B?MmVPdkZoMVFCR0J0SUhXNEhoMS82aTU1MGhidHRqMXFGQTY0cDJ6VkVzZXEr?=
 =?utf-8?B?MlFFdnJHU0V4c3FDYXc3QzJFVlhjbEJGY3RzbFM5R29rUnZJbGt0Z3QrdDZC?=
 =?utf-8?B?RmVrQzhaY3FpaVRzcTBQSkloUXduT2trei9GeDAyM3k3bEtkekVYeTFVVzhm?=
 =?utf-8?B?eW5FbVlEK3JZRHZkNFY3ZDZtM1l6MzhjNTNuZWd2L2pFWHhzOFFLWDJDemlW?=
 =?utf-8?B?TjhjVVN6Zyt4TlppMTZxR3I5RDZLWVM1RHl5bi85V2J4VnVGQ0o3dFh3VVFl?=
 =?utf-8?B?elpqbEk3WVdiTVVGUUFGcEN3cjVPTFdoV0xWRzVEUFpwN0JsaVZwYWY2a1Ji?=
 =?utf-8?B?NzBlQW5YNFUxanRYejY1TUI3UStkVUhObmt3Y0h1WGhMK1owd1VJWW16eUlx?=
 =?utf-8?B?SXdORWczMFlpcEN0MksyK2NNYWliYUxVWHhWdHlIaU9oNGFSeEc2UGdYYlc0?=
 =?utf-8?B?NTBZVU84UldkVzFsTmVydUtjSW5lOGlnRGRFTHdBNmdBbG91YXg0R3BXUzVS?=
 =?utf-8?B?RmljcVlaSGFsQ3hVMVJBY0dyZSt4S29XZnY2NTM4MVQxODk2dU44ZGoyODFp?=
 =?utf-8?B?Tjg0dHovWGpxaHhUK283UGNWNEpacFpadk5UVzFmQ1EycHgwQnRWbElUZXk4?=
 =?utf-8?B?ZUN6QlNIcjNVT2FDcW92TGliRGlZNmJubVY0UCtpaXBFQ0pEZFdUdTVqb0pm?=
 =?utf-8?B?bzlhcFVyTHp5RFMrOUEwUjNNZVJraGN5SUhZbldSUVhYTzRCZ3lyUFlrWC9Z?=
 =?utf-8?B?Q3RyTDR6MGt4MEdhbUJiMllzZmdVQlBpMzBJRWhhdkVIZHZWZXpxV0NrNHhH?=
 =?utf-8?B?bDlIS1RMYmxXS2hOaVFtZHJGWDNYMEx2TmUvZTZXVTROQTdhRFZPVjNpdC95?=
 =?utf-8?B?cXdOTGkrWGJWcGhwNldEMTNPeisxbWtyUUNsK3FyOTZ0RDhDQ21KeUpwb3Yz?=
 =?utf-8?B?VjRYUERQNXZiVzJIVWc1SnNlL28rcThaN09telBDWkMydVp5VjlIQkNxMmlS?=
 =?utf-8?B?a3VSTlRXeWhwdmJiUEJrYXRzdHlXaWt2T21tMllQc2RvcWV5azUzcHZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUV0bS9iU3pBSHI3d0oybTNPT1NuOXFQT2Vwd0FPTFBzbERHSnhNckdWZDJa?=
 =?utf-8?B?a09jUmd5Z1hHaTlUOFVFeEJYTHVrWXVzOFBDcnFtV2g4YkNaM1Q5cUJlRmhU?=
 =?utf-8?B?cTBzNVRxMmRZcGRoT2pOV3gzZXgycjVCZ0ZzQkZOSkttZDN4dm1PUFYybjJD?=
 =?utf-8?B?MDNuWkxCd0tXMHJMQ1k5KzR0akVkMGlhaU9SVmZKOFo0djNHaDh5aTNGWGpF?=
 =?utf-8?B?RWVnUXlPNUFoT1lXcS9xM3JqOGp4V21GeTkyTzhub0FtYnVsclp6UUw4Zmgx?=
 =?utf-8?B?Q1NoUUhTNHFCa1VYakFubSt4S3ZaQ2w3aU5jZDRvVGhDVk5GRDRGZXZ0SUVL?=
 =?utf-8?B?S2pFRDVGTXJsbWJkVXBXeHpHRkY2UDBCYjhZb1dTVHZrQ2FjOEFrcVJJNlc5?=
 =?utf-8?B?RXp0ZUc0NEcvTWxNclVOeFB4cklyUGN5bThqTE03azlKMDBha2VQNmpuOEJ2?=
 =?utf-8?B?LzhVMUJkZDYxbVB3ZXd3R0x2WkQzNE1RWXVlYUZwTmExSGJIR1F2TTRteFB1?=
 =?utf-8?B?YlhNOWRmMERreUxyc1BtZk50V2cxYkJwZThmcTZBblBYSDJmVXVianRTU2FH?=
 =?utf-8?B?MDdiRFRjandwT1NiWHV6WDl6czJYQ3RxNnY2VStqUnFnY29URDlKK3NuZEVE?=
 =?utf-8?B?TTVEUXI0ODVQY3psYnJxNDY0aVU1ZlJYTWZqR2JhQVVDZDJBZWYrQ1VkbUlF?=
 =?utf-8?B?RlRpdDZjTnRVYXAwSllndFY4VTBLUEhGMnF6a3Rzdk5vR0UrWVltWWJUeXM2?=
 =?utf-8?B?OEZUb09QclJSV0xzSTdFWlpzZmFoaEtqdC9TWnZ1MTR5Y0NVV0RxVXlOcXg2?=
 =?utf-8?B?UEVBQTBMTmFidy9pd1JVeXFRanZsenkrYzAwRWs3TEpSU2JPV3ptQXdlemFm?=
 =?utf-8?B?SGQxRWdVdzRpUzJONVRyVGFDS0NPd2RMWXVvMXZyTDdmZzJVeE9JeXNlblZm?=
 =?utf-8?B?RmNuRDNOWTFrdlFacWdKQ2ZIV1NMN3VZYkVKS1hlZzVYQzZHZllIZUJpcTNV?=
 =?utf-8?B?VjlrOTg0WkpKS1NtamZSSjJ2Z2tQQWw3b1FocU4yQk1sZjNZUTNRcExBdC81?=
 =?utf-8?B?TG1RRGVTZUhJdFVYVTMrRTNPTnk5SjBVdXZ5b1FidHcvaG14eEFpM2FyRys4?=
 =?utf-8?B?VGpxNGNZTzdqa1BvZ1JVUncvUnloVjRYQ25vb1U2UUpZb0c1Y04vUTFnQ3N4?=
 =?utf-8?B?Y0V1Y0lacWdPMzg1TW9wSnovbGNrS3Zpa0tnSVZzb1RDaUtOOXVOcFhsT0l5?=
 =?utf-8?B?c3MvUjhJcTcyNjM1cnZyTFV6YTZWNEVRSEw1TEFyUWU1U1ltU3E5WEI2SmlF?=
 =?utf-8?B?WSs1enlrbFhQeUVVSitBUS9sRjNXTDEwYjlvalpBSGltMGdTMEZXbDIxRTc1?=
 =?utf-8?B?ejl5MkM5WlMyaSs2dHVWMUMxZVJNNTRzcjZaY0lFRE1RaUMvYmJrSCtTOWR4?=
 =?utf-8?B?RTZrMXFyZFBLcXJzRUU1S2g0NWFQSng1QTdZRVJqWmlXbG8xKzgxUU00MklQ?=
 =?utf-8?B?TjU2SU53dmJKbVdUei9nZmFnV2JjK2xDUmNtVm44MEZHRWE2MHFIYlQ5Szlx?=
 =?utf-8?B?VjRzb21FOE5oVWFZdkhXQzh2ZlNoWlJTSWN6Z0FUNlluZzhMYktnMWZUNGdx?=
 =?utf-8?B?d3YwcUkyQW1acTR5UlRPV3pONzJxYXpCV1RObXNKNGpKeDgzWDBnSEdaMVAx?=
 =?utf-8?B?YmtocTJpaEErQy8xTEFIOFhmamNhVHJPSnBxQUxBeHRtbmhoREJnQzRKRGdl?=
 =?utf-8?B?c2lFSjRYSHVuOG85MDlNQWVIV0l1Y3FyK2JHVUtIUjY5c0lYYjZNL0hKQWZl?=
 =?utf-8?B?VnRmQlA2SDZDMDZ6SE1NL0JiemdUVWJPTElDWUdmdmhwS2FXaGVxRVd2dU42?=
 =?utf-8?B?Yy9tT3pGenBUcng2NGxwTDcxVkpMVythVis5L0Q5UU1PcTdmbDc1WmRPa0tu?=
 =?utf-8?B?Mi96MG9YdGFwVURyNExFN3p4QTRvQXkyRTBzZGt4ZktZOTcvaGd1TXFBaExM?=
 =?utf-8?B?TEduRmkrTkQxYWJXZy9qMm4yY042azBtYVFoY0czcVlsdGhxTE1PQWVaU2JF?=
 =?utf-8?B?cnV0ZXoyK3pRWURoVEtYRGRGeFRNSzVweVFuZ2ZwVllsSzJTQndFYmxEeGdN?=
 =?utf-8?B?SFd2OU9COE1MdjVzc2ZzYy9sYU9QQ29oLyt2azdXZkVRMGxWeWtGeHdPbWIx?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3303249b-cb59-4401-8d50-08dc750fabb9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 18:48:54.7197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItuzfV2KkHRifvLFI4jx4xh9bGhREgLlvIuU0iVvizAuUqNfmR1OT3d7JtCTgoPwE/oDfqVzOQGtppmITGCsxIjkOupgNfPgsmmFEegbNlI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7964
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 10:23 AM, Tony Luck wrote:
> On Wed, May 15, 2024 at 09:47:28AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/14/2024 2:53 PM, Tony Luck wrote:
>>> On Tue, May 14, 2024 at 01:30:05PM -0700, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>
>>>> On 5/14/2024 11:26 AM, Luck, Tony wrote:
>>>>>> On 5/13/2024 5:21 PM, Tony Luck wrote:
>>>>>>> On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
>>>>>>>> On 5/13/2024 10:05 AM, Tony Luck wrote:
>>>>>>>>> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
>>>>>>>>> Thanks for the review. Detailed comments below. But overall I'm
>>>>>>>>> going to split patch 7 into a bunch of smaller changes, each with
>>>>>>>>> a better commit message.
>>>>>>>>>
>>>>>>>>>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>>>>>>>>>
>>>>>>>>>> (Could you please start the changelog with some context?)
>>>>>>>>>>
>>>>>>>>>>> Add a field to the rdt_resource structure to track whether monitoring
>>>>>>>>>>> resources are tracked by hardware at a different scope (NODE) from
>>>>>>>>>>> the legacy L3 scope.
>>>>>>>>>>
>>>>>>>>>> This seems to describe @mon_scope that was introduced in patch #3?
>>>>>>>>>
>>>>>>>>> Not really. Patch #3 made the change so that control an monitor
>>>>>>>>> functions can have different scope. That's still needed as with SNC
>>>>>>>>> enabled the underlying data collection is at the node level for
>>>>>>>>> monitoring, while control stays at the L3 cache scope.
>>>>>>>>>
>>>>>>>>> This new field describes the legacy scope of monitoring, so that
>>>>>>>>> resctrl can provide correctly scoped monitor files for legacy
>>>>>>>>> applications that aren't aware of SNC. So I'm using this both
>>>>>>>>> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
>>>>>>>>> or disabled (when they are the same).
>>>>>>>>
>>>>>>>> This seems to enforce the idea that these new additions aim to be
>>>>>>>> generic on the surface but the only goal is to support SNC.
>>>>>>>
>>>>>>> If you have some more ideas on how to make this more generic and
>>>>>>> less SNC specific I'm all ears.
>>>>>>
>>>>>> It may not end up being totally generic. It should not pretend to be
>>>>>> when it is not. It makes the flows difficult to follow when there are
>>>>>> these unexpected checks/quirks in what claims to be core code.
>>>>>
>>>>> Do you want some sort of warning comments in pieces of code
>>>>> that are SNC specific?
>>>>
>>>> I cannot think now where warnings will be appropriate but if you
>>>> find instances then please do. To start the quirks can at least be
>>>> documented. For example, "Only user of <feature> is SNC, which does
>>>> not require <custom> so simplify by <describe shortcut> ..."
>>>
>>> The main spot that triggered this line of discussion was changing the
>>> sanity check that operations to read monitors is being done from a
>>> CPU within the right domain. I've added a short comment on the new
>>> check:
>>>
>>> -       if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>>> +       /* Event counts can only be read from a CPU on the same L3 cache */
>>> +       if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
>>>                 return -EINVAL;
>>>
>>> But my change embeds the assumption that monitor events are L3 scoped.
>>>
>>> Should it be something like this (to keep the non-SNC case generic):
>>>
>>> 	if (r->mon_scope == r->mon_display_scope) {
>>> 		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>>> 			return -EINVAL;
>>
>> Yes, keeping this check looks good to me ...
>>
>>> 	} else {
>>> 		/*
>>> 		 * SNC: OK to read events on any CPU sharing same L3
>>> 		 * cache instance.
>>> 		 */
>>> 		 if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
>>> 		 	return -EINVAL;
>>> 	}
>>
>> ... while I remain unsure about where "display_id" fits in.
> 
> See below.
> 
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>>>>>         }
>>>>>>>>>>> +
>>>>>>>>>>> +       return 0;
>>>>>>>>>>> +}
>>>>>>>>>>> +
>>>>>>>>>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>>>>>>>>> +                               struct rdt_mon_domain *d,
>>>>>>>>>>> +                               struct rdt_resource *r, struct rdtgroup *prgrp)
>>>>>>>>>>> +{
>>>>>>>>>>> +       struct kernfs_node *kn, *ckn;
>>>>>>>>>>> +       char name[32];
>>>>>>>>>>> +       bool do_sum;
>>>>>>>>>>> +       int ret;
>>>>>>>>>>> +
>>>>>>>>>>> +       do_sum = r->mon_scope != r->mon_display_scope;
>>>>>>>>>>> +       sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>>>>>>>>>> +       kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
>>>>>>>>>>> +       if (!kn) {
>>>>>>>>>>> +               /* create the directory */
>>>>>>>>>>> +               kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
>>>>>>>>>>> +               if (IS_ERR(kn))
>>>>>>>>>>> +                       return PTR_ERR(kn);
>>>>>>>>>>> +
>>>>>>>>>>> +               ret = rdtgroup_kn_set_ugid(kn);
>>>>>>>>>>> +               if (ret)
>>>>>>>>>>> +                       goto out_destroy;
>>>>>>>>>>> +               ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
>>>>>>>>>>
>>>>>>>>>> This does not look right. If I understand correctly the private data
>>>>>>>>>> of these event files will have whichever mon domain came up first as
>>>>>>>>>> its domain id. That seems completely arbitrary and does not reflect
>>>>>>>>>> accurate state for this file. Since "do_sum" is essentially a "flag"
>>>>>>>>>> on how this file can be treated, can its "dom_id" not rather be
>>>>>>>>>> the "monitor scope domain id"? Could that not help to eliminate
>>>>>>>>>
>>>>>>>>> You are correct that this should be the "monitor scope domain id" rather
>>>>>>>>> than the first SNC domain that appears. I'll change to use that. I don't
>>>>>>>>> think it helps in removing the per-domain display_id.
>>>>>>>>
>>>>>>>> Wouldn't the file metadata then be the "display_id"?
>>>>>>>
>>>>>>> Yes. The metadata is the display_id for files that need to sum across
>>>>>>> SNC nodes, but the domain id for ones where no summation is needed.
>>>>>>
>>>>>> Right ... and there is a "sum" flag to tell which is which?
>>>>>
>>>>> Yes. sum==0 means the domid field is the one and only domain to
>>>>> report for this resctrl monitor file. sum==1 means the domid field is
>>>>> the display_id - all domains with this display_id must be summed to
>>>>> provide the result to present to the user.
>>>>>
>>>>> I've tried to capture that in the kerneldoc comment for struct mon_event.
>>>>> Here's what I'm planning to include in v18 (Outlook will probably mangle
>>>>> the formatting ... just imagine that the text lines up neatly):
>>>>>
>>>>> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
>>>>> index 49440f194253..3411557d761a 100644
>>>>> --- a/arch/x86/kernel/cpu/resctrl/internal.h
>>>>> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
>>>>> @@ -132,14 +132,19 @@ struct mon_evt {
>>>>>   *                     as kernfs private data
>>>>>   * @rid:               Resource id associated with the event file
>>>>>   * @evtid:             Event id associated with the event file
>>>>> - * @domid:             The domain to which the event file belongs
>>>>> + * @sum:               Set when event must be summed across multiple
>>>>> + *                     domains.
>>>>> + * @domid:             When @sum is zero this is the domain to which
>>>>> + *                     the event file belongs. When sum is one this
>>>>> + *                     is the display_id of all domains to be summed
>>>>
>>>> Here is where I would like to understand why it cannot just be
>>>> "When sum is one this is the domain id of the scope at which (for which?)
>>>> the events must be summed." Although, you already mentioned this will be
>>>> clear in next posting.
>>>>
>>>>>   * @u:                 Name of the bit fields struct
>>>>>   */
>>>>>  union mon_data_bits {
>>>>>         void *priv;
>>>>>         struct {
>>>>>                 unsigned int rid                : 10;
>>>>> -               enum resctrl_event_id evtid     : 8;
>>>>> +               enum resctrl_event_id evtid     : 7;
>>>>> +               unsigned int sum                : 1;
>>>>>                 unsigned int domid              : 14;
>>>>>         } u;
>>>>>  };
>>>>>
>>>>> -Tony
>>>
>>> Maybe an example might help. Assume an SNC system with two sockets,
>>> three SNC nodes per socket, only supporting monitoring. The only domain
>>> list created by resctrl is the mon_domains list on the RDT_RESOURCE_L3
>>> resource. And it looks like this (with "disply_list" abbreviated to
>>> "dspl" to keep the picture small):
>>>
>>>
>>>        <------ SNC NODES ON SOCKET 0 ----->   <------ SNC NODES ON SOCKET 1 ------>
>>> ----> +----------+ +----------+ +----------+ +----------+ +----------+ +----------+
>>>       | id = 0   | | id = 1   | | id = 2   | | id = 3   | | id = 4   | | id = 5   |
>>>       |          | |          | |          | |          | |          | |          |
>>>       | dspl = 0 | | dspl = 0 | | dspl = 0 | | dspl = 1 | | dspl = 1 | | dspl = 1 |
>>>       |          | |          | |          | |          | |          | |          |
>>>       +----------+ +----------+ +----------+ +----------+ +----------+ +----------+
>>>
>>> Reading the per-SNC node monitor values looks just the same as the
>>> non-SNC case. The struct rmid_read passed across the smp_call*() has
>>> the resource, domain, event, and reading the counters is essentially
>>> unchanged.
>>>
>>> Reading a file to sum event counts for SNC nodes on socket 1 needs to
>>> find each of the "struct rdt_mon_domain" that are part of socket 1.
>>> I'm doing that with meta data in the file that says sum=1 (need to add
>>> up something) and domid=1 (the things to be added are those with
>>> display_id = 1). So the code reads:
>>>
>>> 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>>> 		if (d->display_id == rr->d->display_id) {
>>> 			... call stuff to read and sum for domain "d"
>>> 		}
>>> 	}
>>>
>>> The display_id is "the domain id of the scope at which (for which?)
>>> the events must be summed." in your text above.
>>
>> My point remains that it is not clear (to me) why it is required to
>> carry the display_id around.
>>
>>  	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
>> 		/* determine @id of @d at rr->r->mon_display_scope */
>>  		if (id == domid) {
>>  			... call stuff to read and sum for domain "d"
>>  		}
>>  	}
> 
> That "determine @id of @d at rr->r->mon_display_scope" is:
> 
> 	display_id = get_domain_id_from_scope(cpumask_first(rr->d->hdr.cpu_mask), rr->r->mon_display_scope);
> 	if (display_id < 0) {
> 		take some error action
> 	}
> 
> So it certainly isn't *required* to carry display_id around. But doing
> so makes the code simpler. I could bury the long line into a helper

Is "if (d->display_id == rr->d->display_id)" really "simpler"? It is
shorter I agree, but I would argue that it is much harder to understand
what the code is trying to do. The reader needs to understand what
"display_id" means, how the state is maintained, how
the values propagated to this call site, etc. With a query like above
it should be obvious what the code does.

> macro/function. But I can't bury the error check.

If this is an error then it is a kernel bug and should be handled
appropriately.

> 
> I'd also need to change get_domain_id_from_scope() from "static" to
> global so it can be used in other files besides core.c

Is this a problem?

> Note that there are several places where I need to use display_id,
> computing it at run time in each place, but it seems so much easier to
> do it once at domain creation time.

Easier to code perhaps but I do not see how it is "easy" to understand
and maintain.

I think we have now repeated the same conversation twice. Previously you
promised that your design would be clear to me in the next version and
I have already stated twice that I am ok with that.

Reinette
