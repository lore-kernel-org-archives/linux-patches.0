Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58903312826
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775510006; cv=fail; b=niuAS68sqjsJ3hRdCGCtzgH1tu7G8bolUr+0y16MSI/y+dyyqYq62s5vezr+oRD6yWZOXQEexOiEpoz+cIURGkQWeVOpkWALKdcyQebU5WLH2xqsx++Z0RmqP38tZ8INyRfH7dh9hFXyc6ZlS7pIbIZzdbhc30hUy1jIMXbkRvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775510006; c=relaxed/simple;
	bh=eWodIX/tMXaI61h0TaIdvJGc1sN9SqL40H+NF2Vh4is=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TtSR0Fn+/GZQNAh1OwxxSYfaIjIypExbpdGuiXaIiwN5+Xd/SPonSTnws5q6g0N5TvmbSTF67TB5RdFQcYYtShMa+4JCXuWIiYvoavzDw30F19YjZbgY2C/X3JT601R9eho2rxvxZ3ion0YPRjKq5Od+yNpIhpeUmCu4ujKXP4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYbwRlM6; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYbwRlM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775510005; x=1807046005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eWodIX/tMXaI61h0TaIdvJGc1sN9SqL40H+NF2Vh4is=;
  b=WYbwRlM6yQAI+KxivjZFs4B3317kWaLKF5J3rDYHua0K1wRpDUfthmD2
   xAxs6dJYWt+KAWTzaXA2LksZMcf9EVlKZXlI5YszLhP/owVa0ZlhtliOJ
   VFc+RhYO+owvXLjCFFwYRP2zZmWMQTUIFaDChv2wd5Rd1exOuJUAVYbYD
   jxYAbbca4j2C7j8ujKI5h3sPl+80ZAtu6ZAErxTmr7lOg9PNMf/ZZOR5D
   oMjCL7MQ4OkJxreqsIrHIRrnlYeiwwUE7JrhWN7dTyWLx50vkWITAHdw0
   7i5Ym58evFcGHaazwIt8aTlu2vzEO35+jYJm6cd8FDYA1RtcGctD0JR7z
   Q==;
X-CSE-ConnectionGUID: Mn63ZWwjSZGvyQLRXbEBFA==
X-CSE-MsgGUID: CYqhmUFfTZ2HRWAY8yZqZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76180880"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76180880"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 14:13:25 -0700
X-CSE-ConnectionGUID: yHxmPURXTbysP3lzKEu45A==
X-CSE-MsgGUID: /hIXnXGARoi+7VTWmehZVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="225227035"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 14:13:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 14:13:24 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 14:13:24 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 14:13:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcqC7CBRbcouZVN1JlY3cB6rcaOn7+gRdakor75rqf9dzVsLrVgscC7mvMDVcb3vAzaIoPMG7M7cBWg9txjrmsGhIgK4Ze/i8qQt6LvSWk6TNp+85ilPmnk5sGazvJ5COMquZQeuiY3aJq5RqUl3DkXrmiDnzNJclwuKiBb8T+0+iMznfYrq+Y6RZIV/Oqf3hbOeWkHYm67+U7miPZqVjHXfXOwjFjwEYDkZiMKU+dHoVKtPv8QWtPFTf+CpAuk3CxzttblLkxFdFato5RmqbGqK86BZ6wRSZznhpz7tvv/rbDmV8KkWWMSDeWEOOj0XGP0y8cnQTRfj0fHl0oDOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXGEe0POhywNogSl9uw+bPjFUE2Hqkvb9uJ7TNypt08=;
 b=l6NHkQmcPWeEbH86ubC39Fs+zUnTvqbQoytdCN5SA4pzw7yXPTefFH4VVbxYh2/OlpJ8iCcxuW/O1OhI0CI2F4snLC9HfsDMkP+1Dm/O9oA79FiSY8RDlCKLHTpB8TYXgUQ6/W831WZGD/iiTgCDbA7N2ZURZaF6INNF/uaDBKS2Hwmm8ftPUi7CzV+2HKagNwW1txqxHFxZA8WpLjByqHa4SF3IsmswC6kSNL8YhqBgtlS3mWypZJ/gKKdYZzMcIe7j3PqcmPSYj3xYy3dr1s8dtItpu18ecCzch639Z4OtuvchFbWJRGqK5B2Xr6sMbOo6j2wXPN9CVOhFfUluOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 6 Apr
 2026 21:13:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Mon, 6 Apr 2026
 21:13:21 +0000
Message-ID: <f6a20148-28a0-4423-a0c7-472b97ec7f16@intel.com>
Date: Mon, 6 Apr 2026 14:13:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] fs/resctrl: Add interface to disable a monitor
 event
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-4-tony.luck@intel.com>
 <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
 <adP86aXVJONQCFc3@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adP86aXVJONQCFc3@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0258.namprd04.prod.outlook.com
 (2603:10b6:303:88::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 8083af89-133d-4667-dcdd-08de942154e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: NlY1pjsQ21zBJevC9c9nqG8kMH1zGly9ZSVgEgBdAqhBf/XM+KsZ1nU5PY75CCMd5erKrYmYC8T0l1esnCS+b2AKwDzZ6s7gnwr0yrYC8CU5j1zIx3WlQZzScZab8cwtkBnmphCmCilvWxbTr0nm2F/x1c8D4BrwcMgevYz1yErnaeCtYWWOeT/VlaYDOXv5di61TMbC2hqkL45V0x5xOSo1JUTqxBqe+TxINz/W95gyD37OsDrB+KW6eolgB/lyKYj1/1RX3gzaZndHa+Bfz6l+vwMSsMK0F4xNlgU03w9dzMtOkluR5l1imAG+BWrIJePwI47Vo3zmrdd4Eh/8uypljgx4yKWQsaGN7vF62YJwb9QoAWsYYZK6sh82tYLqt+SF4wwXhB8Icq81NNXI3jXDMD/lFGGPu59pfyoyVtutGx0IfNwExpnkfc7RMQr7Mo6nzDbLJXqC/sqIVrKGRb+CfLbrJEhjUh+Lqx21G4tO+R7W1LhH9XB8iSPjs6Tdj/Y43IfxU41+nJWbWcI463qr90dFvXEGSd0Irer2zO/4rXdj63pd8nGL+EnCysCtJTYO+/tqfVdwfXJ4B8OKldDHD23mStXaa4vIyq2NjfPkwjSiO/jFNlIXkMXJZude8SI0OTGHlNkhJAR17Ok+EFjRWD7WrRnBYWPQZltvUKOLNKrKxjrgoXuCsvmQkbKj8ywWDhGVFabVIOE8qpPiJTQM021M8jFgteM9MAdx1sQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2lGTEJpNnpweXdDTHVtN0xnRUR3NnFaUGlSL0o5TTI1ckxkOG9VbVhsUGlD?=
 =?utf-8?B?VmJIWVkvVzBOMllTd09yVm9RWHlqU1E3SWJDemhDU2ZlUStiSGJqelNSdlJv?=
 =?utf-8?B?MUh2RFMyN2JnU0t5RTVhMk1vNmc2K2hscE1mRmpYUUpZSmhTRG02cm5XYU1a?=
 =?utf-8?B?b1RtY3RIbkVISlBLYW9TN2VhREdIQlNOQnlGVHBVRU50Z3Ntck16Mm5pZEZ4?=
 =?utf-8?B?cWZnY0F0NUxqUEFLa1pLcDg2cFZvMnVpY0RucjNFK0ZkQytFbTZiN2NmMGla?=
 =?utf-8?B?WUl3RG5zWm9lVGJ0RHI5SUt1MG1GUzhhYStNd21lK2xMRHNxQnU2V3RkRnI0?=
 =?utf-8?B?MldPWmlia2ovampycU56SjErWkFUeENlc1RQNk5hbTlWR0NNM0M5UlZNSk92?=
 =?utf-8?B?QTgwWWdmd254dHRXb2Fwa3JWb2JrUDdMbXY0WlMzOWc3czdLU20vWUlEV2JM?=
 =?utf-8?B?ckk3WlVCZ0crVmVydDVWc1AvWHB5Tmw2YmFGWEpxdXR2OXpPVW5OY096SFly?=
 =?utf-8?B?akd5dmRuWHduSHpZbi8rejFmTWg1YzIyTjJmY3NodkVrbU9TWU42bGFFUTVm?=
 =?utf-8?B?N3dUNDNZOGg0NjY0SHlBcVNsWGlLcnd6VnMzN3BkNkYxM05na0hxVmw0QkVQ?=
 =?utf-8?B?dUlrdFRzaGpZalo0TkpsR0ZnNUN0dDBiWThsTGxvejJpVXZyQ1FFRlVubGtX?=
 =?utf-8?B?SjBqU1ZoZ1FhMmRRVmlZY0FsVVQrS0xhNUtCL3ArRGduSU5zWEpxeFZrRVhr?=
 =?utf-8?B?Rm1wNGczTDNRT3JIYTZHYVpHeWMyVkFMamxnZW53Uk4rMHVzRnlhcW5JL2Qv?=
 =?utf-8?B?WHNzZStIdVBVRWlKUkxad1BmUkRQUWJtcFNwcnNhR2UrRVMyNmhoWW5tMEdF?=
 =?utf-8?B?U1hXcldmME03NW5uUW51bGJyc3A1QlJjR2lBUE96UkVLckRCekNlME8yMVhw?=
 =?utf-8?B?cVJkZGJrS0RVclpXQmJSalR3RTJTOVhsYnZrRjVnSE1KQ1BmUTRFZzcvYkRu?=
 =?utf-8?B?TmJFZTZlaXJNTEVwNURHSUVUQVVWTTIrckEvL2wwSzhZN0VkeVpHaXlYMStN?=
 =?utf-8?B?Tk50NjQxYkJ6VGdlblVuZDZpQlZzcEx0TXpZK2F6M0hydjJKQldUMDQvMWE4?=
 =?utf-8?B?LytaZDl5Q20vOFpxQ2I5bkJoTjB3YWV5Qi9nUTlpcFBSNzFVSkwxVUwwcmpO?=
 =?utf-8?B?VlhPSmlrejlXYldwZVR5WmZ4Wkx0N3NlMFR5RHlkenYxb28vb05uTUR3THJv?=
 =?utf-8?B?clpEanZoQWtUeEFvZEx4enRHZG9xUDdSNjlhM3pZUVpIdC9EcWdBaHVuVGI4?=
 =?utf-8?B?THVrME5Gb1c1YTFRODZ5UXgwT0NQdzFyUFkyYjlmcEN3NEE0NmNDMkpXN1BM?=
 =?utf-8?B?WUoyQTYvMHB5RjY0Y0kyRlpBZ2FpdUV3eHdEMC9SZkY3dmZhcUg5SjVnS3gr?=
 =?utf-8?B?NmUvUmlZUUlyc01mY2tNVEtSbDcrS1YrcUxkYWpWMlNoWXJ3S0JxVXBJa2RG?=
 =?utf-8?B?bVpFSHRxWHlsMWpETzZqMDMxeEJIQktVOVVYR25qM2Z6bXNFOHpWVitlV1h0?=
 =?utf-8?B?UGFVclcxSU5vejQzaUhobDJQbHRWYWVzMGw1OU1LUVEzaXFQU1doWS8xbEJR?=
 =?utf-8?B?Z1N6NjVhaHJuQ2kzSWlmSDZkWjBWd2JYODBtZnRqSG5XVGRkWTRpZ2szd3FL?=
 =?utf-8?B?eUZWeFNuR3BuUnAxWE1tSXJTWUxWY3crUWFOdk1SaVpoRndpVGw0NjF3VVFt?=
 =?utf-8?B?aDBJMlV3V0JqMWFYbWsvbVlSenQyTnQvUHQvLzFoSG1rN3VpQ0JPdXFSNGVl?=
 =?utf-8?B?dExzV0dvS1JHSllDTzNPUFhBSThuY2todytJYkl1WVV3WFZBWGxQN3ROcDBo?=
 =?utf-8?B?ZEtiWDBSSkljSkhjU1Y5d054cVYwZkhRdjliaUJnbERRSHRycmc3aS9FNDRs?=
 =?utf-8?B?OFBaRjlkQWRQQnVNR2V0K3l0ekhxcG1RQWNOazdZbUF4Z1JmNWltbi9xaUky?=
 =?utf-8?B?SmVmRVB2NldsV1lseWRKNmk0Y3V0MXZPc2hlNi92TXJJRnR5LytXdFhKZTl5?=
 =?utf-8?B?VU96WmRCYmZlRWR4ZURlWDhVdld5Q1AvbFhISHd0UEtHZlV0SFovS1VHendz?=
 =?utf-8?B?VXJOZFQrT29lOEtkZE5ZTnBFQjhtYjMzQTdCWDVhcmRwNnlXTnpWOTdMdFBW?=
 =?utf-8?B?QTViUS9vMTNkeTR6c1k1cGFGaHppUGJoa3AxMitONVZuNnFOK3FBamIvbmVQ?=
 =?utf-8?B?NkRtL09yTUIxTzZrdVJDZXJCQnI4ZlFqOEU5UEJRcXY3Y1VGVnVleFRHTVpw?=
 =?utf-8?B?bnMyWWZIOERCSVBLOXlOQ21hU2kyTHFjUExBSUlQRjFwbHkydFhzVFBCUzZN?=
 =?utf-8?Q?Wjd86fZyxjv554gE=3D?=
X-Exchange-RoutingPolicyChecked: sGSJK14pl21Kx6r5WY2lKeYSUnhovQJh9JqqKnmGboaAvUKxv+VrbCrGwwdU+eGQ5JZtH/VepHFBfCaxD6l5REIeFH1iXfrE/osgM90/NVuYGZHEMKhcWYhsa+a2jgFDrPWyK7W2DW3L71UauxnxjWWMEtkpq+OkLHMEBVvksfFMLmZoZS+JvQhwhu+saI6ScW9WKowXHmLK3kHg5SOhqHuXOaWDjRqbC2Z/vjVHaJshOIatrdIicjahp2uwI9udsJeUtUMkhzckMwESU6TKGdR3gT2QOt7RiKJvikBHlcoX+JvdEaJxEEQ78/WYleow2aMBG5Tptq7lUyhlX+qFtA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8083af89-133d-4667-dcdd-08de942154e2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 21:13:21.3178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EziX/tQLPARBwUi3m/e6B3rrjnpGtT4puSrQ8LDc/wRDEPhI0YNb79z4NKtVwkeGy8s6NJj/eiGhj7R26V2rtn64VCs+yoT/8J26JlOT45I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com

Hi Tony,

On 4/6/26 11:35 AM, Luck, Tony wrote:
> On Fri, Apr 03, 2026 at 05:03:28PM -0700, Reinette Chatre wrote:

...

> 
>>                                                               At this
>> time these scenarios may just fall into the "architecture must do the
>> right thing" category since it has best information on how state is
>> managed for the events as they are enabled/disabled.
> 
> Are you suggesting to just drop the check for resctrl_mounted (as both
> a locking issue, and an incomplete solution)?

I am indeed suggesting to "drop the check for resctrl_mounted" but instead
of "just" doing that I think it worthwhile to add function comments to these
two arch helpers in include/linux/resctrl.h that describes what needs to be
considered when calling them. That is, describe "architecture must do the
right thing" with some documentation about what needs to be considered.
Such documentation may help us to start putting some boundaries on how
these helpers can/should be used to help guide any future enhancements to
make this more robust.

Reinette
