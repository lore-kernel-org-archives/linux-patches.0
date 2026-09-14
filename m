Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA03477298
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789399032; cv=fail; b=ea6qh1lQQFRq4hKdRlvokzNRR654EvN9pAb4CzvCn+n0wzIHsHIrlIkY0NTe26SSPS/rEpClkWNzmOebVc7CeQetOTDkVuY1C484ARLA1OTht5qad0i8by8cP3MFYDUK1WTa7rKgoP5/CotPj7FsOJCVzK3lMTNHhGeVT5XWKrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789399032; c=relaxed/simple;
	bh=1UhLq7Bb/qohR8YKCsXKfSoinQEtkJrAnERvgdj7uD0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=il/JvgBXUNysozA01gnfiKEvg4FiMUscywPZk7Nwj4LeZ48NIDF2zOEENuG7GiEyuFUuK/ejeBmty1sYtSWH3MZDCKZGwTWA5TDWenpxKPOpRAeLCacp1ERHE8RsXe5UYSr9XrJCDsFH2A1ZbpkulBtSVIMDmbOa4RV2xVZfvbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PYQMjcUq; arc=fail smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PYQMjcUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789399031; x=1820935031;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1UhLq7Bb/qohR8YKCsXKfSoinQEtkJrAnERvgdj7uD0=;
  b=PYQMjcUqJQwlUj9xOPJ6ks30SoG6Y1QRAvExxeHnbMSl70zt79z0/3ih
   MlSkN5QmukxyDQeFTrMxy7IkMoJOWVuh0JcWZafPKjFoBWtvQksLvS/EZ
   1Xz15cjtHuPpDAdzq5snu7cK/IeTLyU83cSqkqvZh70FiLumCC94mTkwy
   B/NWzsj42wMSS2UA6p0et+59A62We9NEEG0kaWNqhUBjVnK+5X2trsEmI
   iwLrlDS/x9sIUihfgsWVRQ80zkKLOdjGaWrRvB9lUQd2StjczDaMnlZNn
   3Xo1z5ETBt7U63mhhYR1mAYuF2NauHWgrv6G97hd1FlE18OL42lFKjA4Z
   w==;
X-CSE-ConnectionGUID: HNodXPzxTi2tNyc5VlPO6g==
X-CSE-MsgGUID: 1o+BppRFQTKbsRMKXQt19A==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="260772"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="260772"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:17:10 -0700
X-CSE-ConnectionGUID: 5NZby68JTvSfDjMKSt0+Ng==
X-CSE-MsgGUID: +l+yDhbjRHyRPUA1IrkeMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="271243954"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:17:10 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 08:17:09 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 08:17:09 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.46)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 08:17:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xO19kSlOqXOHII1cEZ+SrMlFDOfNvN1Factx1N/I6i6thg7sBJ8RWWXBRpnoEKA+lD3t/YReUDs9mM8/LzBiidti2iyoqC9HC191r7oHXIWwu7dRhigVayTxdQkiweWxA/n0gTnr8EQutSBW0r4Fu3q4Syqrqmx2EfdyYkfN1/SH2FRYs/13JlpDcx9lD9rGLtnrzHFRkj7d5Af64SnGfNj3yba2wXaQorOplQqPLPp2p7rVoxfEeHsPlBa20OwpGlMSb0LwLFqatKrFCu9ssSiPm0MHdg78RR1/kS7zE5syZDYRBVu7eCI349CLG2b2ZpqdUHZPTfvd+4xVHIVJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Smp0o/axeCKh7gTnLsclVW0hzeB9izP0oaDpCHlcSqA=;
 b=EvMu1SKQ76sBKeiqmQBS2IHzwCw+ImTm5I5KFjcW6KQTjp7Axx6U6EE088LGzVbEsWJ5aBAwwQWkHhN+ix/H9xdvtg7euLlghIXhl72V0j5y38YNt5J329EPFPmgy3++xBWIRskRw05cZd0RDYeU86vhD7xcd8w7zipARvrF1b3egyaDgmcwiESLIIA4olvLddyzkuW4b4qn0LKbfEpXLnXvs7orUwRLj3gAVRCEj74HQ46WP1s81Wdr3cK5+tOFhaLNstEv1GOeivgEop17SOxenLTnGMW4DJkfXNhG7UmJtQ2uASB9zXA5CIPcNQsxYqZJoESqhy+7Rv84W+6Row==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM3PPFD5EE188BF.namprd11.prod.outlook.com (2603:10b6:f:fc00::f53) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 15:17:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 15:16:55 +0000
Message-ID: <3595fe1b-0621-4599-b94d-a027336a2ce4@intel.com>
Date: Mon, 14 Sep 2026 08:16:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
 <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
 <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
 <86603611-b20d-4a0a-a247-8cebb11b3432@arm.com>
 <071d3dc6-6c18-4287-af26-719b89304058@intel.com>
 <d403b92c-aae8-499f-8c73-933a2d757fba@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <d403b92c-aae8-499f-8c73-933a2d757fba@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0385.namprd04.prod.outlook.com
 (2603:10b6:303:81::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM3PPFD5EE188BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd50266-9ef2-46ab-b1f1-08df1273366f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|4143699003|11063799006|5023799004|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: bcpjofBeO/0XnxycKdtASfrXeYYfW6+ZRuuQBgLL+PTyMJXtZfzkYoWzaQTNlg1jpiXbEfolpp+6CyCzoYNn2fXLRxoVAAn9eQGx8VPN+9zhAghlxia3qker6ZAUFIpZijCWQ2HSP4RrP13R6Qo0M6MPmGpVlyVWQyIxJUS0hk6K9GDMmKZ94TDqzkhtfHYbdfqstWw1p4vLW+ZKCT63ORQv8lkyM/hDKGivIohUrwTitGwmaNNSIU0IQDuAyzszmwpAPLXCjgF/IIJP1d9eGh/L5+19iqB7jbk3MD+q3CRlov1I9Qzwij1IuKlLCbSj0q7ECCwyeDt0expOaGq6hMK3yMyN6EVHyaBSACzxDkGMptkLAs9kMYby47l1hzsXOYwD9c+zEvobbUCorYfb10kt4Sq0ZUwS254scCqh9ZVrYxku738Bdq8dmZGqdYELSaf9rhE5+xgxZ7DXoMV365dypfqMvcMviwEHw429BBTMuk1z7ZmPyBSP7tAxoGXIslaEM8DicM8YvV5fP8CBkOUlq/NsQDBhX4Cw7MQqmP4xw6ppo1TCFiOsd6dW3L0jxn04bpg/2dWLMjJKBPOLmCdQkoAGbzm1oj0tQWQL9uq71ruc+EuSsZkc49TfLiZQ3dXxn21cSIcq5uF/DVaoTYgrc2NRuupVdLl5Ykm/z98=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(5023799004)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXJsQlBORExMWGNQaG52UVlUYWswMHVMZkpRdy9DK0swN21YelRvKzM4L0Ri?=
 =?utf-8?B?ZmlrSWRFZlQzOVQzNE1xU1NPL0t6WEV1SmhWQU5icm9ZeFM4TFBpVUdoUnBq?=
 =?utf-8?B?eHJuS2pkRlZ3V3BXWEticEl6eDhXUkY1YjNDdFBxbkovNGhJa2ludk1SM293?=
 =?utf-8?B?M3JTaFZldU8reXdwS1d6djNiS3hvb09Wcm15QWRBRWVwdFFIUkpBbHRmdVNV?=
 =?utf-8?B?VHdPL1AxMHJJMkdWV1ZIQ2ZaRU9LSXdUSFd4YVZVQURPL0lNMStNYnBFZU5S?=
 =?utf-8?B?UnVvd0MzN3FxWXJZVDhKT3paSm5rMEcrdzdSbEFiM1ZndnYzQ2MyMzdLbk5B?=
 =?utf-8?B?SGRkNncxTTJPbjJ0VFhabFJZNXd6TjBIVDVnbVNpU1JJUTU4ZlJqdUJUWXls?=
 =?utf-8?B?b1VjeDNRMGpUaW9wNzZyZ1pLMnF5SEdPSHE2czN3d3RFMDlxOWQ4K0I3Um1O?=
 =?utf-8?B?a1lueEZTdG0yTXhyd1ZnQ3R1VmNNZC9KSlVUb1lRcE5LWklNUk4zNXZML0Nm?=
 =?utf-8?B?NWtQYUVjZnFHK0IwbnFZOGdIajhSNjgrSEhJT2w1ck1RbFVpdEVhcHRYUW5p?=
 =?utf-8?B?amRtamU4TXNEMTk1ajJUWk9telRrQ3FKUTU2bytsN2F6L1ZIT29yT0o5NmtO?=
 =?utf-8?B?TXBjZUVjcG9JZUJ6K3ptcE1hRGR0RkVNSUhFaFV0bnN4a0R3RlVVcnYyT3E3?=
 =?utf-8?B?SVY5V2RFN2p4UCtrMjNqSGZubElYM0h2cFRIWmx2RFhraVZUWGlKTEJqalRH?=
 =?utf-8?B?Wml3SFh1RXhDNnVUN3IxdnRRMVRYM1BEK0MvaFdYVFNmejI1U0Y1b2VVdFhI?=
 =?utf-8?B?SFAyRkVwS0pGNVhkbzg1Tm12R2JRM1NtL2RiaW1OeitmZGVFcGZHTHV4WFRN?=
 =?utf-8?B?VDRHQktRc3cwMVk3bWQ2WTdZVGR3cGZUVXRGUHQvVFQ3NjFabmtGQ0NKMEN2?=
 =?utf-8?B?TVBhWWpDU05Dd09OdE5yY291UkV1MmRRUnFwSGplWjdwTUxoRTVtZUlySkZK?=
 =?utf-8?B?ZXg3WlEzT3o3ek0xMVJYQUlDeDNYcmgzc0pURWtFVkFZbzZJRmN2QmpqRzA2?=
 =?utf-8?B?T0tOYXFnRUxXOGxlaGNsRlgxVnNEdnQrZCtFbkhLK3ExcitUMnlnRDBnOW1j?=
 =?utf-8?B?dzMwYUY2QjFpNEVKQkZpUXJoeDFOdzhlSkZpUDVlMFhPcW43VE5HSHE1ZEd3?=
 =?utf-8?B?LzRiOWR4SHRaZDRyQnJrVlNEQXkyNWJza09UcHJlMkZBcWNCRldENVVJWXRS?=
 =?utf-8?B?Nm9MRncwa2xrdkE1QWRGWGZ5MHVQMlhWeGFTUk1IdmRDVkZ1WjBvaS94QmpV?=
 =?utf-8?B?ZUpwNWszR2pPeUY4N1duYmlhcUtzcklQUk5sdGFqQnpLaTBKZWY5MS9oRUg4?=
 =?utf-8?B?WGQ0dldPVXpxSlptbkhxZ1VBU2x6N1lZcDFqZmtpcnRpM2RlNldrYUppOERQ?=
 =?utf-8?B?LzFzRzdTZjkrakF5NGdCREloaHBabjlyM01ScDNiWVFOYjFKVnNBUWNHZy9B?=
 =?utf-8?B?Z2Q5eXhjeFd5OHlOTHByejJ6QmNqOUR6NEZ6U2JVem5qMWVhNXArbXRodEtM?=
 =?utf-8?B?c2c5dXpzWlNvTVZSV1ZZNEVjcnZ6ZGR5aC9qVVMzRlFnQkZGM05PSTE1U1pU?=
 =?utf-8?B?TUQ5RjAzcXVmSFF1NnNqNTJDVnkxcHlYb1hseCtYY1JRT0RvVmcvYzRMZG1q?=
 =?utf-8?B?aFdKZlg3djUrRDIwSG44NjFadndiYm5uOGU4MUdNVzBsaDBwcnJrZDVYdklh?=
 =?utf-8?B?UkZsVzFTZFh6WEJiRFNGeDIweXVuSnRnSnFzYUhtTDloYjNWR1hVODhBMWJm?=
 =?utf-8?B?MC9wcWxwdGtzMnZPTWJ1Y2thb0hsbjlFVWVRS3VlUitjODlCV2lTS2dCM3Z6?=
 =?utf-8?B?OXVlY2V1b0szNGluUUFmUmpyV2dhRC9DcUNjaVc4QTEzNjRTUHdvSFphOVRs?=
 =?utf-8?B?S1RrbVk0L0t4VGVyazJuLzd3N25pSm9jS0g0OGpTMzZ1VDFxS1RqOUZJb3Jt?=
 =?utf-8?B?bGxvMzZaWVhMbytTZW9YL05vWFF0WkhLZGp3VFlCa2U3UmUwM1ZVU1B0NmZo?=
 =?utf-8?B?TXVoSm1NWS92WUF3MVJmRWFYMEFVS25NYm5pYzR5K01ncnh2NmV3ZWQxQ0hG?=
 =?utf-8?B?dXZuKzBFRm1IbTBDdVQ3WE5mREpaMW1waUdnMllPSGFPbXRYa1ViRURnOUpO?=
 =?utf-8?B?KzgyZGg2eDJiVCtxc3lyVk54RElTV2pVRXJQNWh3TDJ4U2VseFczNEkyNjJS?=
 =?utf-8?B?RG9kUEdLdElXSWVqd0gyWXlpVUJEU29xdWhpU3R6bnlMVmdxWk52TlBJakV6?=
 =?utf-8?B?L1lZaFVYdkJzK1FpVHRTbnFhNGNNZC9tUDdmTzRpRVlHNXE2b2V2WmhRZUxD?=
 =?utf-8?Q?vtwsUUF7igyIjh1k=3D?=
X-Exchange-RoutingPolicyChecked: XZcULR/3lJLwt+TJR+zz/EhNkvyIhSgAy700MAUV0zYl4XT/NHuUy1akgyvw19+DKWjy64mJWBvP9MdVeCeDE8jTlRbgKYBTCst1eFnXLpChSH/YDfDN8Z0mZEOzXS5DRNDSTCPykSjV2ZaYmGhyD7VQip/SeEzv+nl1QgB1Z+MMsYanMGh6d50oWpsqlPPEuK3aX44E/ognOSoPn61HzX0UlyKGZRaHxKHugyJYknE4vaoVxidCV9wsS1sxov/q41bqJg3bDm4Oz0bdOxhiXE42Udqb9/Wo48iFTwqkVQk+Xvou34/JMZUPSr6FuRI3NrYQBl/QQwIS558QAM7YsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd50266-9ef2-46ab-b1f1-08df1273366f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 15:16:55.6745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6YMeZyO16kO0b5uwq3c0hI0MaDtBjDa/sYNwLGQH9ost26M6G4IvCYoClMLPnNwaxE5Dm7EXhH5AM3vsh9LXSkeMTDvJE1bwM95/gO+iow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD5EE188BF
X-OriginatorOrg: intel.com

Hi Ben,

On 9/11/26 1:56 AM, Ben Horgan wrote:
> On 10/09/2026 19:10, Reinette Chatre wrote:

>>
>> Do (admittedly crude) guardrails like below capture the existing driver requirements?
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 9d223057953a..dbd06371890c 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -1681,11 +1681,18 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>  				continue;       // dummy resource
>>  
>>  			mon_comp = find_component(mon->class, cpu);
>> +			if (!mon_comp) {
>> +				WARN_ON_ONCE(0);
>> +				err = -EFAULT;
>> +				goto offline_ctrl_domain;
>> +			}
>>  			dom->mon_comp[eventid] = mon_comp;
>> -			if (mon_comp)
>> -				any_mon_comp = mon_comp;
>> +			any_mon_comp = mon_comp;
> 
> This first part which ensures that if there is a class for the monitor then a component can always
> be found for the given CPU.
> 
>>  		}
>> -		if (!any_mon_comp) {
> 
> The any_mon_comp check could still be useful to confirm that if r->mon_capable then there is a
> component for at least one of the events.

resctrl fs does not handle such scenario. r->mon_capable guides whether the resource
supports monitoring and if it is then all domains belonging to the resource is expected to
support all monitoring events associated with the resource. resctrl fs will expose all the
monitoring event files based on r->mon_capable and which monitoring events are enabled, there
is no finer grained support to expose/hide events per domain.

If any_mon_comp is true while one of the mon_comp is NULL then resctrl will still expose the
event to user space and pass attempts to read the data to MPAM driver.

Is this a scenario that the MPAM driver needs to support? That is, users will see event files
but reading the data will succeed in some domains but fail in others? 
>> +
>> +		/* hack */
>> +		if (!cpumask_equal(&dom->mon_comp[QOS_L3_OCCUP_EVENT_ID]->affinity,
>> +				   &dom->mon_comp[QOS_L3_MBM_TOTAL_EVENT_ID]->affinity)) {
> 
> There doesn't necessary need to be a monitoring class associated with any particular event. If there
> are classes and so components for each of the two supported events then this check looks correct.
> You could ensure that by checking existence:
> 
> if (dom->mon_comp[QOS_L3_OCCUP_EVENT_ID] && dom->mon_comp[QOS_L3_MBM_TOTAL_EVENT_ID] &&
>     !cpumask_equal(&dom->mon_comp[QOS_L3_OCCUP_EVENT_ID]->affinity,
> 	           &dom->mon_comp[QOS_L3_MBM_TOTAL_EVENT_ID]->affinity))

Right thanks, this needs to be more robust. Essentially this is the finer grained check that
ensures that if the domain supports both events then the backing components have the same "shape".

Reinette

