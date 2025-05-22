Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5C3367
	for <patches@lists.linux.dev>; Thu, 22 May 2025 00:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747872144; cv=fail; b=EBdQycrSaESYwjCGQwaybCkprJLyXOaDe2G2xA3utFlALTcNfIaGFcb+H9qNa8s6EKg47jp5Gn5Cb9Wk4touYt+8vYcvb21hk1hK3JbbrNOxS77zeB6719ZG5ZwoZwftWhwePWeko8jb16UcEpmINAMP96/+uiMR4p0a3A9xHDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747872144; c=relaxed/simple;
	bh=np6czyp5sUazYVKKr6qy991FJI39nAZ+9FyG0mJjZqk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MAz8Wri7/XymTiSEr9tRW5WcE7gctw3OZjBq82jr+gLCKwa2yUOSldv8HJbiCU1b1l24+P8EAPDAs9lg8dAQdC07wtYpHVWGPOn0/6x7W9kB4UiM5CAxd5GbzqX/o6QiW7WUcXm61QVO/fpTwyp/zS+01bJSzd0kMnhusCihnMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gv8K4E4Y; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gv8K4E4Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747872142; x=1779408142;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=np6czyp5sUazYVKKr6qy991FJI39nAZ+9FyG0mJjZqk=;
  b=gv8K4E4YIKr3fKsC59aW+PIJd2pBAv4g3SgtaRP/wr/ZaZK5UYKoNgOT
   kuGsg3SPBDmSbVA4TruAkbeys0DY7vCE7rKduHVNPCIgOKmDZplHGGuu8
   5P+3F9FFGVYjT2GyKRCZJfBvQIJYYaONHBaG6p/pRbozGP5oYMgZcbaTO
   gcR3esEK8PuF4OG3zA+MzHNmS1a9fYSiIjiV4alpIWdN6M8H3VCCBb6AL
   jwLNWM1a+YFZQryABLre0X/b05+BH0ZPQio0ZSVhMV3fMr0q7/86NFzMO
   IX+VBQ1OYrk+cgg60XFk3dFZm7ELYpz2FVP2YAlmXpv5YM/mv/IoLWIjD
   Q==;
X-CSE-ConnectionGUID: +Xwyj43WT0e03t6hwTPiEg==
X-CSE-MsgGUID: rRe1sBLiRD2Nezoh1HcCQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49781511"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="49781511"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:02:21 -0700
X-CSE-ConnectionGUID: IT0n5DfWThuWHycXjrLa0A==
X-CSE-MsgGUID: L8N4lv68Q4Ga/xL7ruVsoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="140084047"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 17:02:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 17:02:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 17:02:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 17:02:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+h71qb7VhIlUpVsxNNGfhbSEHtC+cg8ipGsiFUnTLR4bv4g84YkSyBol/4xZGAmtzp2yki9QVEp1gAKQJFfaHqeU4Wx+qDN5zWNAfORyRs49ztRDBoONklrCPxKcPNcww1ZWKlINPzFglTIJbxi7cYhQp+qetoZ2cYv05S+eCZ0VSOy/O5Kgo9QqxBs58CACELKgfbJCDRY2DZb5hc0mJ0hi6uT8QpxlLzTvJqkiSuSdFduq8IYTGunYZ/mqfMWZc9yzKsbEf6fXEDd29oidNUWShgSlRkNbyMXDOcJVRx0C35qyt173xEHhuy9zwp1gIknb6KeE6lOYsmRX+VDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77s0WH45lpGNbg2rkVQEr06kF8OM9hCYMUIQNP3qCxo=;
 b=yuXIZHxnkWj7Ur4RC7wPi3Ald3Y9ftZEDDhqw2g2TTChF4JLt2+WVH7SPhvKsI8+47qPa6uAv9QzKJYUJhcMz3lBju2vc2NVAqW7VBLcg7kqRKMIWy1h6qbAcdEGzj+X2U6O/aN+cKNONZCl66C8QQXtmfmCHAKhP0GYn6e2A/HTYrOXEcBf/h9r9Jk6GPXGPxx4XFW2KfaRXY1npPGr+B/xirq1s0QaD+HiQOW/DxcEOuap2QCSJ34CLScVtoh4ax+1tis3W+hEDDdwid+vps3vifo6i3IsxD4qiWlichS87QqEMwk5DI8ydB/i5Eoi2wnBXm9MH4xOaJ8d/4o1TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19)
 by PH0PR11MB4776.namprd11.prod.outlook.com (2603:10b6:510:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.35; Thu, 22 May
 2025 00:01:58 +0000
Received: from CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6]) by CY8PR11MB6818.namprd11.prod.outlook.com
 ([fe80::48a1:723f:54ed:a6d6%6]) with mapi id 15.20.8722.031; Thu, 22 May 2025
 00:01:58 +0000
Message-ID: <22c0f91c-7ee5-4bcf-8146-fd98795a073b@intel.com>
Date: Wed, 21 May 2025 17:01:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <anil.s.keshavamurthy@intel.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-11-tony.luck@intel.com>
Content-Language: en-US
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
In-Reply-To: <20250521225049.132551-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To CY8PR11MB6818.namprd11.prod.outlook.com
 (2603:10b6:930:62::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB6818:EE_|PH0PR11MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: dc630cb8-adfd-48dd-00e1-08dd98c3ded9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0NaMXAzU05IVkh3SnNTazliY2JETEZMYXBHQmJJZEw3RFgraGpodlFGeldz?=
 =?utf-8?B?MTdML3VKckZwQkU5UmFQV0xMU3BNK2taOWJWVTZ1S2czN3ZrWnYva1hzanNk?=
 =?utf-8?B?QXphTTNIYW1lKzhJbFpyTG1kTHlITk9mL2QvNnFSekNaUlVqTWFGS2ZoSXYy?=
 =?utf-8?B?OVA2VncycHhaemdCY1dtMlhBZ0NxeXNZc0tyd2taRjVpeWR3TDFwSmdUbEsv?=
 =?utf-8?B?ZERXM0VrOG1hdEw0a1hVaU1ZWC91bG1xdHJpVzlsYnhJVHJUbzV0TGlXQVRI?=
 =?utf-8?B?SE1yYmk2cC9hNVUva3NnbTJLZlBCL1h3MHRINkxJc2lIUXMybFd3b1hyY2kz?=
 =?utf-8?B?VjVLVmZLOUdCYWIydGRqdVJUc25ScmNWNDlOcEdWeko3TjVWVW9HMDZsbXVP?=
 =?utf-8?B?enJJRE1LOXEzMnlWTGE0cFR5OUJSSXNPa0duWGQ3MWpzbWFQNFpZWjkwTDEr?=
 =?utf-8?B?Z1B1NnRNYWoycHhVWkxISHF6ODFHeHBkZ0xNMnZMbTNBcGkzTVZUa1JGeWVY?=
 =?utf-8?B?S3cvaWlwbFZuWEdqV0tRWm5DaUJSTUdBOUs4cDc4TmVrbUN0N1F6YTBISHIv?=
 =?utf-8?B?TG5pU3pMYVpjVWZDSDlqYXNnZ1ZmaUs5dnFSclFTVnJQMlZPUXZIc2tjVThC?=
 =?utf-8?B?VnFiczA2aE9SbDcxcmJLSDllbnEwZlB3b3pZeFI0SitiSW1nSVpvR0xFRjVC?=
 =?utf-8?B?a2tMQmpuTzdlSlBnZ3M0RVBqUm5Oa3FVdTArSXVkbHBZakJPeCtxNUEwQVdM?=
 =?utf-8?B?anFLWmhZL1FqbXM3OVNtb3NGUm56bkJJendUUDBHbldhSFVHSlZYMkF6TnQ5?=
 =?utf-8?B?Szk3Mm9FRXZJU3VvV1RYd25oR1FGYjF0bjRmaWJDb29LYUtJb1VNenpjYmdE?=
 =?utf-8?B?N1E3VHJMWUlvdTlkN0svdUVRNmt2L0c2M09rempQTm9sSkkzYXRyazA1U2VK?=
 =?utf-8?B?dHN0Y3RoRS9TYmsrNGpGMjc5WFREbUdrdSttMXVUaXk4U000RVJkd2x0UXEz?=
 =?utf-8?B?RmZpb25ZZnBOVE5MY1BmU2Jkb2FReWZIL2FIbUcwSGh3Ym9JdG9YRnlDNHV0?=
 =?utf-8?B?UWcvaHRmSG1PWkdiMWZrTkxLYlh5cnB6RGFNb2x0TnBtRkpIaXdyWW9qOXMy?=
 =?utf-8?B?V3lnNWEyd0lTNmNtVisxUzh0K0dQQ2dBVUREZEIvWE4zZksrb3o3V2JYMEhq?=
 =?utf-8?B?a2s3V2s1dkJjalRWMVNqYWJ5Ymt5citmWGVnQmRFOXZVWEtnTnFzOUZqMmFZ?=
 =?utf-8?B?Z2xCNzdOblFxbzNUaVlucGRrQ3JUSVl1QmU3b1cyVENDMjFLSEk0RTNNaE41?=
 =?utf-8?B?SmlLTVFJQ3FQTkkvR1o2b29ITllIUkNjLzFiZmRlZGt0WW1LYW55cGt3ZVVT?=
 =?utf-8?B?cU54am1WdVdOS2hYaFRWZUhCbVdibWoxUzE0ZXV4YXRoWWhaUXVZVEJaWjNQ?=
 =?utf-8?B?UC9ZcHUvcEEyV2lCazFZQXdSelRqYlJMZ3hQME53R3piU3dXdUpUczZZaXlx?=
 =?utf-8?B?UkZsQXNSMjFrZGNlVDlISnc4aHJIOXVJVDlWMDFtaG9QSkpOVmJGelFtNkZM?=
 =?utf-8?B?aGZpTThhK1gybkFqeUZOWk14aDAwTCttRTBpSWZQNnhlYXA1dk94bUZPY2xG?=
 =?utf-8?B?RVBPVjlMcE1tc3FXcElYTjJaMWhXMFVKcUpIUE1QOWF2S1pTbU1heFl1bG5q?=
 =?utf-8?B?RitlMlgyakRhbW8vVy80NHkwLzdKMkFxYmdERzBJY3RWU1JzeGlpWFpUYk9P?=
 =?utf-8?B?Y1FaRjBOK1g2MDRYM2Q3eFBBNE13cHlRYkg1NHY1ZjczQWxFYWhmOVIrMlUx?=
 =?utf-8?B?V3E4UUg5U1VLRW9nNEJjVHJ4MUZENHJOUEtoc0dEcHhEMW9xZjdYWmN4TkJn?=
 =?utf-8?B?L2E5OVpUNGJ1OWM1TzN5ZjN5WVA5WmNWVU5MN3pxdWN2YXE4QUtxV29SWnlS?=
 =?utf-8?B?aHhCV1ZKU2NTUmRRVFBCeGJrNzFORWx3N3ZzcTJFL1lxYzRGY1FQWXdvVXNw?=
 =?utf-8?B?VzVZRWRpVlZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB6818.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHJoelhxY0djSm0zM2RjTmIxZWMyRXRHMW9iWDZIV2pFZnVaZElHbDJYYyt6?=
 =?utf-8?B?UWgwenNQUGNGRyt3SlU2SE9ibHFyd1RyMU1DL2xNRnJWdHM3bnVNeGhTZlk4?=
 =?utf-8?B?L1FBL1Z3M2g0dVdwVnVVaWpmWlIzR0NwUm5RcnppQXZPNUJUSjFUNHU5Qm02?=
 =?utf-8?B?SkR6YWcwbUxHMUYyUlB6UjBKL3h5Zm14UFhQSTBUYnhtcGdIajFDUG80UGNt?=
 =?utf-8?B?dHVpTjg3aGJ4QkhvOGRsN0Jhei80SGREaUxGT3dXTzF0bWQ3OVh1dVlJckNH?=
 =?utf-8?B?aVhCZ0kveUVCSnRyNzZ0WE4rMTFFV0EydmkyNjhRU1lVaUJyajZGZndsZXlV?=
 =?utf-8?B?Ri81ZjU5VU1PRksvdkNNbEwxT2ZFbGYzcXM0RnBDVHNaZmEwTzMyWXcrd1pU?=
 =?utf-8?B?YUNxYjU5cGIvazN5WS9ZMUhkaDRWa1REYnhNZllIL3paSWJ1aFVLYUY0T2pz?=
 =?utf-8?B?d2JqOS8zRUhxdVRPTzlvaFBPVXNMMXZNMTB4eVI1ZWNiNnQ5RVVaaitDV2VW?=
 =?utf-8?B?VStza0VaS2RRQTg0aUJJUXYxNU13VzJYc2xYckNCSGp6emRnTVlWYk14MDhj?=
 =?utf-8?B?VDhPQW5CZkppWFVkTjJQdThqS1hYTndyN1lTbVdKUFdTYkhLL1BiK3oyT0FD?=
 =?utf-8?B?QWgrT3dXMU9JaFdEV3hMN1hZL3ZFcjNod3NsdVRvWWtoLzFUTEpwOXBIdjRK?=
 =?utf-8?B?MVBJSnlnT2xjSytqaTVPd2pSVlBvdWFzaWQ5cGJta01UeHBJSVc3ZFFmQnFN?=
 =?utf-8?B?NnlqRlFYd1FUbFdiR0ZSTW9aVVhvYjR1S21PVmVvVVdrclJWdG9qeU5WWnlQ?=
 =?utf-8?B?eWpLNTdQbURpcXk2ZERPUUk1T0NYRTZGVVlwRHBtMUsyZ3F3TjM2UnR4NGVT?=
 =?utf-8?B?dHhqVTJBWWFTaEZxdERVZWVMa3Q1d29aU1hydW5ndEQyRjNrUU1ia0xGaGsw?=
 =?utf-8?B?ZmN6ZTNxVjdzVlE5S1A0RTFsalZWanBlR3p0VEY3cjRPMzExL055VDhJdXda?=
 =?utf-8?B?L1YrcERQdFBHUzdXZldmWFBZU3Q2Qk1wdVROVFl1ZCtQTnh2WG02ODUwKytX?=
 =?utf-8?B?a3QxSEFHYng1c3J1QWpZNmRWMm95akRFdEtGTWhuYjVvMkZMdkEzQS82dDQr?=
 =?utf-8?B?SVlHYTlCSXd2ZzdPZi9GM1d6bG0xMjQ1VVV3Y25hNm00b0RXT3grMyttdnJG?=
 =?utf-8?B?U2pXdm10WkpqMW1JQTdmMkZlcXpYSk9yNGFSVFNhYS9pd2dBTkdhc0poczli?=
 =?utf-8?B?VHJ0VHJHYlM3azFWSUVnR1pIakxIMW1TZVZsckpmS3N4REFza3Y3OUtIeE9n?=
 =?utf-8?B?ekE2SW54R1E2cnI2eTl1U215dGJsQkRBM0xMK3dNYk90dW5aZ3ZjckFaWThK?=
 =?utf-8?B?RHZjZGJiektoM1pMOTZCTEI3a3ptRUptbnJIMDF2VGtiUVU1SCs3V2JiN2cx?=
 =?utf-8?B?TjhzT2NLOE5DOTRLdktoZUxBYVZibnI4c3FaaTF0OGZGVzlsU25LVWYzK3ds?=
 =?utf-8?B?SitLQStnOS9Wd0tWMFZUN2o1cCtUYXlqK1FLZzN6bW1zaWhqNkozSkRLTGJD?=
 =?utf-8?B?LzJ2cHdVQTkvdThqL3V5aFNvOEQ5S29iOER4SXByaFpTMXVXSy9YOFp5TDRJ?=
 =?utf-8?B?dk5nQ2xFRU9JdnM2TE80ditmU3BFT0d3VGRWa0IvRE5XVzlXUFF3aVBTb2h3?=
 =?utf-8?B?MFhiV2FDdndNZy9vQUM2Ujl6UXkxZFpWbG4rUVhublJkakR0akJwaXlmdkRp?=
 =?utf-8?B?b1RkM1ZtUXhQQXFOaFRucVlCMjBvSjNnbGVyN1djNXkreHNRbDc0OTNNeEpU?=
 =?utf-8?B?Tzc5bGkvL2dYYnQ4OFFQRTF4bmVScUVPbWxnUWlRSTM1YnF0eHl6dDY4NjAr?=
 =?utf-8?B?V1NzNGVjZE5sakdsWi9oWTdGV1oybld3ZUZFZE5PZE5mK1BQY0htWnFYbWtL?=
 =?utf-8?B?UGFJLy91V3RONllISFljbm5XRDlFbDBlVWs0dk54TzJ0WERDQUEwcXg3RUE1?=
 =?utf-8?B?ejBOa2NtQkpGWCtwZ3F2MnIzdXlxaTlwR3ovVUhKS2ZaTkpvMEZQa3h0RVhU?=
 =?utf-8?B?QXA5RmFaWUsrL3lGRUZTTGI1SHlrYytJcHUwbk1DbjdrZFp2M3Z1SjdxTUlK?=
 =?utf-8?B?N0o1cWNrNmFUL2RHdFNsOXFjNDE3Q0tJMmgzVngyejlGZy9YRlJOWE14c0wv?=
 =?utf-8?Q?1B2bEZqXmgSNqNwheDzzSbE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc630cb8-adfd-48dd-00e1-08dd98c3ded9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB6818.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2025 00:01:58.3477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ny3cLpJx9AOGRwzad2/gsW5QM+Vl4E3MXCYzmFpwpakm/qCcdpMiTf4oah4o+VyEvG4znvvDFjEiV8r8zQEEtBJ7knFXtPe3vlpvG/Syujg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4776
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/2025 3:50 PM, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource and it made sense to use "struct rdt_mon_domain *" arguments
> to functions manipulating domains. But the addition of monitor events
> tied to other resources changes this assumption.
>
> Some functionality like:
> *) adding a CPU to an existing domain
> *) removing a CPU that is not the last one from a domain
> can be achieved with just access to the rdt_domain_hdr structure.
>
> Change arguments from "rdt_*_domain" to rdt_domain_hdr so functions
> can be used on domains from any resource.
>
> Add sanity checks where container_of() is used to find the surrounding
> domain structure that hdr has the expected type.
>
> Simplify code that uses "d->hdr." to "hdr->" where possible.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h            |  4 +-
>   arch/x86/kernel/cpu/resctrl/core.c | 39 +++++++-------
>   fs/resctrl/rdtgroup.c              | 83 +++++++++++++++++++++---------
>   3 files changed, 79 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d6b09952ef92..c02a4d59f3eb 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -444,9 +444,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   			    u32 closid, enum resctrl_conf_type type);
>   int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>   void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>   void resctrl_online_cpu(unsigned int cpu);
>   void resctrl_offline_cpu(unsigned int cpu);
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e4125161ffbd..71b884f25475 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -458,9 +458,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>   	if (hdr) {
>   		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>   			return;
> -		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
>   		if (r->cache.arch_has_per_cpu_cfg)
>   			rdt_domain_reconfigure_cdp(r);
>   		return;
> @@ -524,7 +522,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>   
>   	list_add_tail_rcu(&d->hdr.list, add_pos);
>   
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>   	if (err) {
>   		list_del_rcu(&d->hdr.list);
>   		synchronize_rcu();
> @@ -597,25 +595,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>   	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>   		return;
>   
> +	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
Looks like variable 'd' is uninitialized when used here. Can you please 
check?
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
> +
>   	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>   	hw_dom = resctrl_to_arch_ctrl_dom(d);
>   
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> -		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
> -
> -		/*
> -		 * rdt_ctrl_domain "d" is going to be freed below, so clear
> -		 * its pointer from pseudo_lock_region struct.
> -		 */
> -		if (d->plr)
> -			d->plr->d = NULL;
> -		ctrl_domain_free(hw_dom);
> +	resctrl_offline_ctrl_domain(r, d);
> +	list_del_rcu(&hdr->list);
> +	synchronize_rcu();
>   
> -		return;
> -	}
> +	/*
> +	 * rdt_ctrl_domain "d" is going to be freed below, so clear
> +	 * its pointer from pseudo_lock_region struct.
> +	 */
> +	if (d->plr)
> +		d->plr->d = NULL;
> +	ctrl_domain_free(hw_dom);
>   }
>   
>   static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
> @@ -651,8 +648,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>   	case RDT_RESOURCE_L3:
>   		d = container_of(hdr, struct rdt_mon_domain, hdr);
>   		hw_dom = resctrl_to_arch_mon_dom(d);
> -		resctrl_offline_mon_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
>   		synchronize_rcu();
>   		l3_mon_domain_free(hw_dom);
>   		break;
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 828c743ec470..0213fb3a1113 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3022,7 +3022,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>    * when last domain being summed is removed.
>    */
>   static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>   {
>   	struct rdtgroup *prgrp, *crgrp;
>   	char subname[32];
> @@ -3030,9 +3030,17 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   	char name[32];
>   
>   	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	if (snc_mode) {
> +		struct rdt_mon_domain *d;
> +
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>   
>   	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>   		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3042,11 +3050,12 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   	}
>   }
>   
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>   			     struct rdt_resource *r, struct rdtgroup *prgrp,
>   			     bool do_sum)
>   {
>   	struct rmid_read rr = {0};
> +	struct rdt_mon_domain *d;
>   	struct mon_data *priv;
>   	struct mon_evt *mevt;
>   	int ret, domid;
> @@ -3054,7 +3063,14 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {
>   		if (mevt->rid != r->rid || !mevt->enabled)
>   			continue;
> -		domid = do_sum ? d->ci->id : d->hdr.id;
> +		if (r->rid == RDT_RESOURCE_L3) {
> +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +				return -EINVAL;
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = do_sum ? d->ci->id : d->hdr.id;
> +		} else {
> +			domid = hdr->id;
> +		}
>   		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>   		if (WARN_ON_ONCE(!priv))
>   			return -EINVAL;
> @@ -3063,18 +3079,19 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   		if (ret)
>   			return ret;
>   
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>   	}
>   
>   	return 0;
>   }
>   
>   static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>   				struct rdt_resource *r, struct rdtgroup *prgrp)
>   {
>   	struct kernfs_node *kn, *ckn;
> +	struct rdt_mon_domain *d;
>   	char name[32];
>   	bool snc_mode;
>   	int ret = 0;
> @@ -3082,7 +3099,14 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   	lockdep_assert_held(&rdtgroup_mutex);
>   
>   	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> +	if (snc_mode) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return -EINVAL;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>   	kn = kernfs_find_and_get(parent_kn, name);
>   	if (kn) {
>   		/*
> @@ -3098,13 +3122,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   		ret = rdtgroup_kn_set_ugid(kn);
>   		if (ret)
>   			goto out_destroy;
> -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
>   		if (ret)
>   			goto out_destroy;
>   	}
>   
>   	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>   		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>   		if (IS_ERR(ckn)) {
>   			ret = -EINVAL;
> @@ -3115,7 +3139,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   		if (ret)
>   			goto out_destroy;
>   
> -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
>   		if (ret)
>   			goto out_destroy;
>   	}
> @@ -3133,7 +3157,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>    * and "monitor" groups with given domain id.
>    */
>   static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>   {
>   	struct kernfs_node *parent_kn;
>   	struct rdtgroup *prgrp, *crgrp;
> @@ -3141,12 +3165,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   
>   	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>   		parent_kn = prgrp->mon.mon_data_kn;
> -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>   
>   		head = &prgrp->mon.crdtgrp_list;
>   		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
>   			parent_kn = crgrp->mon.mon_data_kn;
> -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
>   		}
>   	}
>   }
> @@ -3155,14 +3179,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
>   				       struct rdt_resource *r,
>   				       struct rdtgroup *prgrp)
>   {
> -	struct rdt_mon_domain *dom;
> +	struct rdt_domain_hdr *hdr;
>   	int ret;
>   
>   	/* Walking r->domains, ensure it can't race with cpuhp */
>   	lockdep_assert_cpus_held();
>   
> -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> +	list_for_each_entry(hdr, &r->mon_domains, list) {
> +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>   		if (ret)
>   			return ret;
>   	}
> @@ -4030,8 +4054,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
>   	mutex_unlock(&rdtgroup_mutex);
>   }
>   
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>   {
> +	struct rdt_mon_domain *d;
> +
>   	mutex_lock(&rdtgroup_mutex);
>   
>   	/*
> @@ -4039,11 +4065,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>   	 * per domain monitor data directories.
>   	 */
>   	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d);
> +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
>   
>   	if (r->rid != RDT_RESOURCE_L3)
>   		goto done;
>   
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +		return;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   	if (resctrl_is_mbm_enabled())
>   		cancel_delayed_work(&d->mbm_over);
>   	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4126,12 +4156,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>   	return err;
>   }
>   
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>   {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>   
>   	mutex_lock(&rdtgroup_mutex);
>   
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   	err = domain_setup_l3_mon_state(r, d);
>   	if (err)
>   		goto out_unlock;
> @@ -4152,7 +4187,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>   	 * If resctrl is mounted, add per domain monitor data directories.
>   	 */
>   	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		mkdir_mondata_subdir_allrdtgrp(r, d);
> +		mkdir_mondata_subdir_allrdtgrp(r, hdr);
>   
>   out_unlock:
>   	mutex_unlock(&rdtgroup_mutex);
