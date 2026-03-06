Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE63A6EEA
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 19:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772825151; cv=fail; b=i30Du85oH1lIoVu8/oGD+9qDST1YyRrV0IIL1oEibChQfIvefuOn7tFfsFFAiUm3RZuRBbep+aSNOamd4pJXFhV9kDoQT5ujhPSSTju6Cdd6siVeBGnKO9fOmM+ZghHmwxSUYgu0RjVbERPliTBHJV/Iq7DBePLteP4l5iQ0BuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772825151; c=relaxed/simple;
	bh=tpFRcEPTmPsGjg2iC5LG7Z1c9Asa3I5tmUaF4mv/Kd0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eJciwd5Rqb1qwN2FLUxajzkJMkmBTYxz6dS4ydZODZHkpLeR1SFh9mghKGuNME6nMAm5ZuQXWJ+TbCbpcg6cFxv5lidygaaMxxy/XuwZ+9QLXTbdgbGBDbxmFCcK6d9LWgIUKiFJIBDP1ar+y7mEZB8E8sT+EqiY7etjWPAy7JQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ErYk+UH+; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ErYk+UH+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772825149; x=1804361149;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tpFRcEPTmPsGjg2iC5LG7Z1c9Asa3I5tmUaF4mv/Kd0=;
  b=ErYk+UH+Emj2ldhUdBFu7Z932S4ReKbmTcnevLjzoekeZsWzic6q7qYp
   7hzJxwx++Cc+SNr+BkObMIepEpmCL8viC8fJLxXY5aa5bWGGPKuEH+y6f
   ThXp7iWOp71xMmKYWw1MuLAuJHbLulXBnS7yL8zUEoxUSIlkZGfDms51A
   wH91cHw4+paG8U9zMw+Ds7t/HrgJ1e9qK5LH1ttnIpi5sm49eZ+XbtM1p
   POtuLjK0BwcO0FD98khSqxJsGlBlL5zsgjITeA5rrBR6OZ2ueqJpisd8i
   Iio0Rq5jRxyKeEcHSkPwbxSOJaPy+AeoGuIwB8aZgp1QJWnrnR4Rn5I7V
   g==;
X-CSE-ConnectionGUID: mSh4PmevQJ6GouPRSDWS/A==
X-CSE-MsgGUID: k1txjdxvQZa0zwMFwCRRJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="84651593"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="84651593"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:25:49 -0800
X-CSE-ConnectionGUID: O7D/xmt9RnOzg/h5s3K+JQ==
X-CSE-MsgGUID: iSWr44KwQ16osffG2uUJzQ==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 11:25:48 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:25:48 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 11:25:48 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.57) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 11:25:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGzLal6Nu5I5PBlDMsZoLtdygEE2nDVbBS8oW/rsjFzAeRc12oCpuK3VBKQ8eExx6gq6pBc1Hn2Z7ua29CW07ddKpMsrioucimEOOfqT2nhbUOgZcvl2WYD9uHshHTgjFV0c3gU21iccSDT+LKaqnC+hvhwxjozCE1AAks4KzbOZ0T/QL31uOAL9s+820qrgsessL4y5sWcptRE1jVLDfCI5PpuZolcY4xfYMfPSkuIvM/0lJlKfokFSGoCBfS/VBq67eAjpH3s3JwADHIHJ+FYhXvINBHGxZtG4ipT2iU4bmr+r7TF5fc8yp1TbhBfRfZOH8a1u5ECmdVEAwV+6og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcDfSGGVRzKtMxCifLlIFQsZpZX+J6ef/DPVqSIqvMw=;
 b=bIjtmu8kjYymWr0Y7SU/zpFdr1VntqhKel5K9gBz5p/pqexhHw2tfcW7DyWEA8fWSW7NHTWKzpikP1x9HMv72jkClaLOvnvJTYAW7y9tsK6lCN1W4fR/Vic8Rl1esskmAG4uP3xWlTOmc06JG2MlC4TpmaVxQJkbn1uB8tq8BuOY+SMDYO9+zmOqdpkFyn8+274aDTMcJuckrLOnnmKvoe8LwW3Eo1hAYP7BHliqwVUnQf7AkC6x9tJXJ6i5VSLV4WMLpL/rPK0yAaFlY+xdMhY0JHySFftK61nE3yK+nS0BYIb6vCCDoRlfshvdhi6LhVC5Y19DI+iAnMC51zX3/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB7463.namprd11.prod.outlook.com (2603:10b6:806:304::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 19:25:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9700.003; Fri, 6 Mar 2026
 19:25:44 +0000
Message-ID: <c69d8068-852e-4029-b079-52fd0a9380ec@intel.com>
Date: Fri, 6 Mar 2026 11:25:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] selftests/resctrl: Support multiple events
 associated with iMC
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1772582958.git.reinette.chatre@intel.com>
 <ac8d183679c70f5ff5b3aabb4e19df7bf98d3380.1772582958.git.reinette.chatre@intel.com>
 <a0536a31-a8da-2232-67ca-91c60eb714c2@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a0536a31-a8da-2232-67ca-91c60eb714c2@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:303:dc::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ffc28b-f892-42cf-aeca-08de7bb6297e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: I9GLPMxmTjAs3vXmyaJk7BgreGrse3YWMphS8wBcaJxOue41zbH0bh56MO9zA4nw0oalDymqiYDzf6PlEoTPBKEH9h/kJvnp1vK14YKPvHn63MpYnB7bwFASPhI7QeIhfTiUbHO/1I/dDbeWuWdAu6foEPVDQkWAUpXEmVjZrdOtwLLorpjPo/H1UXnYMGXdLmfFh1s7u02xfNwFNf2hVzkcKmsK/l6nIUuUUoQp3ShJOhyxFrU+POXl2cIkPfLyUkCj6fNyxAYCb/2XgRK+7mVvoCN+pMCe77IwwFDxrZhpg4QmNj3iOrJ/aci0nPlDHHEqTqk043pl75eflu0nCkbwHiaD8eunVRq8hwwOkkzf+ZF9R8sNqRa2Tl+Zvr+kLKUcL01Jr4cTLfayDtv1L3pmrFMWfkTw3HD+fa7uo1DnBe4P7G9zySoJcaIGDkUV/0nw4CTtvz+Rdot+lnEz/PdfTheHPCztzgyw7LJxmmWm3+RFUjSq6VbAWxw739PbAx1VUZt/BJbpnc+gco/X3YEOnYjZWnySS0G+2BBWcbMDGhXacrqj20yUcgSrD29YEshQ6AAd652M2knvMJAT2Nm7f8a8uhwQDJo9YwMo4BqdGwY5H6fZnIt90Iw2qguYL3AGf6bkYZu5vbY0W6eiUxaNbHkpje/bgal34M9YOaBoA9tGH2rcRK+Oq6bs8YwD6QpQT4L+ibZriV5LUBnivGtUxlc41YUQr+6GWEXSLGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTJsZkhkQ0pJQ1dSTW9WcldSNVdubldVYSthVmVtMlcxRUI3TnhTcXRoQ0Yr?=
 =?utf-8?B?VmhkSEtaNVYzejlWa3lWbHZtRGZRQTFXVmw4WkozV1NNNzJvallZSzV3TVp4?=
 =?utf-8?B?ZXdpenZMdk9xYTQ4TUdCMktNWjFyclF6SWx6eE5JT2xyWlNVc2NCTzBUY1BU?=
 =?utf-8?B?Q3p1NWl6Q3EvVTdFTDF1YXMwZStUMHFEeGdEY1h6aVQvZVg3eFpJcEFqQTNq?=
 =?utf-8?B?MmJUQ2dDWU10dWtWeDVFTEV1VUxvdFV3dW1YN2svbVI5N0ZtaUFIOHRnTTRV?=
 =?utf-8?B?b3V6aHJPTk1YVktSUEd5QUV0ZWs0SzJTcjIzZEJVREV6QXgyK2dyMitBWlV5?=
 =?utf-8?B?NzY4cjE5SzVZSDY5N2dONnhId3FJeW5LeGsycTZxZ3BuOTk3VUVWaExFUVpm?=
 =?utf-8?B?VjlxQzB3NS9ENk9YeGRyWDZPK2Q4M09LUng3RGZFMEtBaXBwNHBRNHFMYWM2?=
 =?utf-8?B?MEJXZ0lWd2tBR25TQlY3TUlyK0dpeUY5RENrTW1aMHNkNE96cjk5a3JZTTF0?=
 =?utf-8?B?cWx2YlRpRk9WMXRVcjkzMTVPL1FHMDdvTDFrYitERU1nL0NPRVh6Wjk5d2or?=
 =?utf-8?B?YUNMNHpEYzdKRVdvc01MWHRKRVFCek54RWd1dWZFT3l6OXlCV1JSK0R2a2Vk?=
 =?utf-8?B?d1dnMXZCV0hwaGxKZFFNdndPVEMyZ1BNZ1lOSGdLNGN3UlRSeUtGSlpEWC9n?=
 =?utf-8?B?OW5KczN1WXd1d3o5c3VYY01Od2N2bWQ1K2diL0RFL09JdCs5REhZQ1FIazJw?=
 =?utf-8?B?L3lsOGx2OWxLei9RNGZRcjlEK2lPaWllaFZqc3Y5aGNlM2R1a0RzTGNRSVJj?=
 =?utf-8?B?RjRQLy8yVkhlUDlhNlhybDlCanlwcWFxdmJ6WkR0UXFRbWFoSk5VNkFWS21t?=
 =?utf-8?B?TzN1czB4UXBQVDlYcUl2RmNwYWJvVE9PNGJTc3EzalUvZWVDUU1WeVh6aHZ3?=
 =?utf-8?B?QXJKU3ZOR3VKektGSFB1VWpjcEVWSGZwcXBDMjNWWkJ5UllqNlA1TjJpSnFP?=
 =?utf-8?B?a016SVM2cDRUVE9LQnR3NjN3S3p4WGwzNGhTSjhMVDNXS2NLR1JyOVVubVRM?=
 =?utf-8?B?WVJ1SGZJVlhPc2lYMUJJYktxYy9mZUhhRUl2c1MyQitaOXVqbVB0UVJ1TVhL?=
 =?utf-8?B?clZVbGlZYWFrRS8wTHQwaFFQRFUyaWRXKzI3OHRWYUEzWjhjWXIvcWhVYUhC?=
 =?utf-8?B?czVFY3M0Rkt6bC9obDZhUHAzL0xNeWthNG9MWlVoSWdaSk1idjhJUnROUkh1?=
 =?utf-8?B?R2luOTlPSHJOWFNKOGhCZ2Q0TUlhemcwN0FwTlV1bkgvSS9xWW9RQjhrOWxz?=
 =?utf-8?B?Zk1VOTNlb0hYcEh3WWNaOWcvdWo3QW85cGlLUlcxRGJ5NGM3UTNvSTVkT28y?=
 =?utf-8?B?RmRQTVdYSzg0VVJtVEVHUDA1VXpTdkIveFNQR25qNzEzWEt4ZkFVMFNmTlRo?=
 =?utf-8?B?NnNoZmM0NlpzMmF0ZGF1RWFQSkh3eXN0S0V1emY0WlJ5TzB0ZFFtbUNEcVRt?=
 =?utf-8?B?Z2I3blRPcGs4eXVVV0duVW1BbllmcXFIVXdLWWRxbHpoNEhVcXpkVjZxSC9D?=
 =?utf-8?B?WWtJSEtDVEx0RWcvTzlpbWVxc1NueG8xcDkwbFVLazRTRzJFL1lML3plMDNj?=
 =?utf-8?B?LzBJVTRZN0IyZ2Y0dE5CbkQwTTFxdytINk1wVlBDY2JhRW0xYTV6U09CbFQ0?=
 =?utf-8?B?Nk9tUjlxdDc1aHZFTWFoTytvNFZ6Z2hmTW4zTVZxZ2daT0RPV0tpSlZLSFJT?=
 =?utf-8?B?Ulk1Kzl1bm92WFpvdEtLbkZkanpVRnB6QjZCWENZV0JBNGUzRkVrZldPWXhZ?=
 =?utf-8?B?Y0VXLzB6VW9kS2tkR2R4Q05rSmhrQ0FPbTFQdkMxd3dyWmM5Y1k0OWhnaHJ6?=
 =?utf-8?B?YzhiZ1JxUnYwOTdDTFJxanhFcWh3aDNBT1dLUEtHK0FqWGFBTVdjWmZyOXl2?=
 =?utf-8?B?R0lCV2VObklPNDV2Wk9qSHkvRTRFL21qRExwREgvYVJrOHZqTjVjZHlvYktw?=
 =?utf-8?B?b0p2eG0yMXVvendmNFVpT1BOKzhMWUhEYTA1UUtLbFBiblpqdzB0eXgweklE?=
 =?utf-8?B?ODhxYWZVbWRZYzFCemhCTnREbUZ0aTFpWTg3RnF3c2EzNXhtY3B6OGJoLyts?=
 =?utf-8?B?QmllNGdaSWQydkFGTHhxZjZOQkk1ZS9DM0ZjeEZ3SzBodmJiSXRqNnVHRkUy?=
 =?utf-8?B?bkRKbkp5ZmdIL3lOMVk5RXBMTlMvaW9SakxjaVhwNWZtQnpkOGxhNkFMU0pS?=
 =?utf-8?B?UmphRFgwT1daRGhxRW9DRXp6WUhqa1dPaEFTUStTTU5iYVBjYyszdWF3cHl1?=
 =?utf-8?B?MXZvenlCUlNXN2xBb3I5b1dMbXNyVzltZERCd2JUK2t0THdQeTRHTTF0UjlV?=
 =?utf-8?Q?RKUz3HFNAUrbpAIE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ffc28b-f892-42cf-aeca-08de7bb6297e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 19:25:44.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SH2yr+cuE+rq2WXLbtRbS5zk7AqOHcpXeWVEZDQflWof1DDvRsAI9lA36kI99NllS5+6w8xw1THduGEke/sOCyIZPme0DZQrmOhS1ZKzFmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7463
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/6/26 2:18 AM, Ilpo Järvinen wrote:
> On Tue, 3 Mar 2026, Reinette Chatre wrote:
> 
>> The resctrl selftests discover needed parameters to perf_event_open() via
>> sysfs. The PMU associated with every memory controller (iMC) is discovered
>> via the /sys/bus/event_source/devices/uncore_imc_N/type file while
>> the read memory bandwidth event type and umask is discovered via
>> /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.
>>
>> Newer systems may have multiple events that expose read memory bandwidth.
>> For example,
>>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch0
>>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch1
>>
>> Support parsing of iMC PMU properties when the PMU may have multiple events
>> to measure read memory bandwidth. The PMU only needs to be discovered once.
>> Split the parsing of event details from actual PMU discovery in order to
>> loop over all events associated with the PMU. Match all events with the
>> cas_count_read prefix instead of requiring there to be one file with that
>> name.
>>
>> Make the parsing code more robust. With strings passed around to create
>> needed paths, use snprintf() instead of sprintf() to ensure there is
>> always enough space to create the path. Ensure there is enough room in
>> imc_counters_config[] before attempting to add an entry.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Reviewed-by: Zide Chen <zide.chen@intel.com>
>> ---
>> Changes since v1:
>> - Add Zide Chen's RB tag.
>> ---
>>  tools/testing/selftests/resctrl/resctrl_val.c | 112 ++++++++++++++----
>>  1 file changed, 90 insertions(+), 22 deletions(-)
>>
>> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
>> index 25c8101631e0..7aae0cc5aee9 100644
>> --- a/tools/testing/selftests/resctrl/resctrl_val.c
>> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
>> @@ -11,10 +11,10 @@
>>  #include "resctrl.h"
>>  
>>  #define UNCORE_IMC		"uncore_imc"
>> -#define READ_FILE_NAME		"events/cas_count_read"
>> +#define READ_FILE_NAME		"cas_count_read"
>>  #define DYN_PMU_PATH		"/sys/bus/event_source/devices"
>>  #define SCALE			0.00006103515625
>> -#define MAX_IMCS		20
>> +#define MAX_IMCS		40
>>  #define MAX_TOKENS		5
>>  
>>  #define CON_MBM_LOCAL_BYTES_PATH		\
>> @@ -109,21 +109,102 @@ static int open_perf_read_event(int i, int cpu_no)
>>  	return 0;
>>  }
>>  
>> +static int parse_imc_read_bw_events(char *imc_dir, unsigned int type,
>> +				    unsigned int *count)
>> +{
>> +	char imc_events[1024], imc_counter_cfg[1024], cas_count_cfg[1024];
> 
> The first two are paths, right? PATH_MAX should be used instead of the 
> literals.

Yes, they are paths. Thanks. Will use PATH_MAX.

> 
>> +	unsigned int org_count = *count;
> 
> orig_count is less ambiguous name.

Sure.

> 
>> +	struct dirent *ep;
>> +	int path_len;
>> +	int ret = -1;
>> +	FILE *fp;
>> +	DIR *dp;
>> +
>> +	path_len = snprintf(imc_events, sizeof(imc_events), "%sevents", imc_dir);
>> +	if (path_len >= sizeof(imc_events)) {
>> +		ksft_print_msg("Unable to create path to %sevents\n", imc_dir);
>> +		return -1;
>> +	}
>> +	dp = opendir(imc_events);
>> +	if (dp) {
>> +		while ((ep = readdir(dp))) {
>> +			/*
>> +			 * Parse all event files with READ_FILE_NAME
>> +			 * prefix that contain the event number and umask.
>> +			 * Skip files containing "." that contain unused
>> +			 * properties of event.
>> +			 */
>> +			if (!strstr(ep->d_name, READ_FILE_NAME) ||
>> +			    strchr(ep->d_name, '.'))
>> +				continue;
>> +
>> +			path_len = snprintf(imc_counter_cfg, sizeof(imc_counter_cfg),
>> +					    "%s/%s", imc_events, ep->d_name);
>> +			if (path_len >= sizeof(imc_counter_cfg)) {
>> +				ksft_print_msg("Unable to create path to %s/%s\n",
>> +					       imc_events, ep->d_name);
>> +				goto out_close;
>> +			}
>> +			fp = fopen(imc_counter_cfg, "r");
>> +			if (!fp) {
>> +				ksft_perror("Failed to open iMC config file");
>> +				goto out_close;
>> +			}
>> +			if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
>> +				ksft_perror("Could not get iMC cas count read");
>> +				fclose(fp);
>> +				goto out_close;
>> +			}
>> +			fclose(fp);
> 
> I'd prefer:
> 
> 	xx = fscanf(...);
> 	fclose(fp);
> 	if (xx) {
> 		...
> 
> ...But it is up to you ("ret" cannot be used as xx as is).

ok. I do not really like to use ret for xx since it generates a bit of churn to
reset on success as well as failure paths after the fscanf(). I can introduce a new
local variable that should help with readability.

> 
>> +			if (*count >= MAX_IMCS) {
>> +				ksft_print_msg("Maximum iMC count exceeded\n");
>> +				goto out_close;
>> +			}
>> +
>> +			imc_counters_config[*count].type = type;
>> +			get_read_event_and_umask(cas_count_cfg, *count);
>> +			/* Do not fail after incrementing *count. */
>> +			*count += 1;
>> +		}
>> +		if (*count == org_count) {
>> +			ksft_print_msg("Unable to find events in %s\n", imc_events);
>> +			goto out_close;
>> +		}
>> +	} else {
>> +		ksft_perror("Unable to open PMU events directory");
>> +		goto out;
> 
> Reverse the logic (handle error first), it reduces the indentation level 
> of the loop.

Right. Will do.

> 
>> +	}
>> +	ret = 0;
>> +out_close:
>> +	closedir(dp);
>> +out:
>> +	return ret;
>> +}
>> +
>>  /* Get type and config of an iMC counter's read event. */
>>  static int read_from_imc_dir(char *imc_dir, unsigned int *count)
>>  {
>> -	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
>> +	char imc_counter_type[1024];

I'll also change imc_counter_type to PATH_MAX.


Reinette

