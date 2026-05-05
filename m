Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5FE35F18E
	for <patches@lists.linux.dev>; Tue,  5 May 2026 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777952843; cv=fail; b=lw1TCTVgfFYsKhRhihDUsIqDEGYdnijijFTQusJ3IE8QeJEARH7NOtZrUc1/WED1nY/8NbvEf1mQUo23EZGcXg5q0JKh+c6nGtdthVpairnmHHx+GVU4fSs3TgbL/Ya5GmvQegshf5mMyJOBr0dieBGJ9rQK/GYoW5UFEhA51Ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777952843; c=relaxed/simple;
	bh=dM5xt3dhSy7+OvSjwjYAyrfPQxBxFG4tJ6GobBQMf9c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g1b0re70voN4dKRNjKQ+hel1Yz3cApeR2zi87lZH7cfbEl8+r4X1Iec1tHaKS69c84f3C1XxznSXaWykds5W70n8clJu2t0VnjAyD960vGcvhNUoq9hHa560wA42yNb6MQxmNlHc4XmcSDGweMqkZq/WldRsH3LsALnCr/zdsK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n+0/jah4; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+0/jah4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777952842; x=1809488842;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dM5xt3dhSy7+OvSjwjYAyrfPQxBxFG4tJ6GobBQMf9c=;
  b=n+0/jah47NicMfJ5rf18mimMY5nQzPuxjREoTTf5fr/mZXN597GbcaBL
   6CJzzUhYVcfyAdV5rTztM+MC8fwRD//dSlBRpQuhiCvNHbdqu88FyNWxe
   1HvSCwXgl+bEHPbX5zNcCemdiFsvM27tzogxyRPZV7Z62WyfITOl9lDgQ
   N5Zj5B2GJyWCExfgrTg/NnjIz/kD/YQfH1/d2l1/OrAMbbBPcJ9QYSYD9
   kzawKH233lIzKDf8yRzh+MmGbvm7mTNw73VgAYLngP6d7f+W+oSGfpZzC
   IiRYe973kJVkG8XJ9A7V9r64DPqEkqPxQvAQ3WxBRMI3uYUHyNoFO50HR
   A==;
X-CSE-ConnectionGUID: UUtaictOQSOM7ZndqM/+FQ==
X-CSE-MsgGUID: bkG1j1qqS7KexPPxsObkgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="90190247"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="90190247"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 20:47:21 -0700
X-CSE-ConnectionGUID: v3PMZjTIQS2mQ37ofpCuYQ==
X-CSE-MsgGUID: CeByVTd2QH+lPWGFSUUi9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="235943425"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 20:47:20 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 20:47:19 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 20:47:19 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 20:47:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMWDkxpBPnks07npEiUGM0IsEf16Trosr/S/rHBMRPAXWWmwjFrF5kljSfjMwqZnaB+YKylMoFEUAUKrbBc1ZYSy/bQop1l782QUIuKRrH3XzoRMf7bhxZMqDZOyRQElIivNqka+mqWkkxiwPk9gMhYCQ1Z+XAXX9vbtDBCNPFg+VuO62qquL7/nxZ9nPwxam8N5khp1P3qOsyLyGbDlYAzqCy9ogSs43hrFvfQiUO1fUs/1fjUM40+xa/7ZjFtOF1FMyrIwCRRhuoc/XwnP2dLVzT+72z80afY4xeiEYcrOHoEMTosnZWfpjPUdnLEohLShn0mC4Tj1IiTMHb6kGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWa/dFRNNLJPIT5ULXtKg2ey5XVr9G8S8f+mDbXtbC0=;
 b=h2369Kukr7Eq36MdXeDuGknaL425uATKgbVayE2DHHvB9pkMeAtFb3kBkwvgDzpKnuwCq2+APvx5A2SFhJBg2adwEnmINL6IsPniRNjRqPkXbmZv0pnL/aNKDpJrrL97p3HuIJhbKAI2e20hvu09198bI1nX+kncbQzLM7UtglFfu99iYxxajEdm2Ngmg/1IZMkYMhkI/j5nmqHPFKbEfXc20BSGxsyDpyuO6ARIyW8TjyfSR0kzu2kcfYRd/ZFg4UoZbX0CYShRv+MC5iUpZHO9pO0Y7ICmVYEH0yO/moEs87VhpT4AN3XsjN5kxm32JFI0JqDVbW1mRj0eatKsqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ1PR11MB6300.namprd11.prod.outlook.com (2603:10b6:a03:455::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 03:47:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 03:47:16 +0000
Message-ID: <4a4ffdbc-845b-4d01-a949-1bbe75cde43f@intel.com>
Date: Mon, 4 May 2026 20:47:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/10] selftests/resctrl: Fixes and improvements
 focused on Intel platforms
To: Shuah Khan <skhan@linuxfoundation.org>, <shuah@kernel.org>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tony.luck@intel.com>,
	<babu.moger@amd.com>, <ilpo.jarvinen@linux.intel.com>
CC: <fenghuay@nvidia.com>, <peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1775266384.git.reinette.chatre@intel.com>
 <2598acd3-542f-4c90-b46d-dc64c6cdc700@intel.com>
 <4e9175ca-1b1c-40ba-83de-f9ca8c9c9a28@linuxfoundation.org>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <4e9175ca-1b1c-40ba-83de-f9ca8c9c9a28@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:303:b5::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ1PR11MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 562c28c3-a4b9-4d84-8bfe-08deaa58ffd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: kIL3oeDaCfcoyWQ5RZSDoo9AWTfJD5Fs835QHZ3D8jh2YS9v3HI5orbI9nWiiJcLtdVuL0E3c1NV2ytO1mHs+gX+6xVbuVWgAfevX22jIMP/yFabInk8BSr55h9gHSFYZAbWiu1HBPLMM/Y8pBGvhxEYiLSDt/4COAXvTb41MQTyjH/344PB8A4n/MFNs4OtOlze/EyG0Q9Jx9ws3FcqN0190aufi5XLaTqnv8Ec9tHliFUmEVonUnEEyRUnmNymk12fZtAieynyflu6HAWNk+lkXaTVeCRFeZlPW+/UaNqGFxkOy3TDpmjRsm4IJv+YUNxTnutdLc/OB2En29Vx18/B0GLWbu7rWdtpivQvDL7G2H0kPWmQhufiWdeEC+QHOkHKmUKuCSOG30LtBE9fvsWSvG/iWzqIwZ9r1TiJ8y68C3L6e7qnZXaq/rRFIq01LHAWXwy4LSHKh/SJ6QSjzr6EZF/KY6Wo24ItYLVjY+TzaYSfgPUqdSRssVUO1C7A5rgswIPs5lXBNQo3jqK6xsoDIDK2ol7tQ0WjX4kWgIZJK8pDI4o3h2FwJR7P8aTatFLSyRJcJw1twLcbY27MRzGuBCnKmGVUz0pIf/H7+WobQcIIXwrFDOSFITXpnDgPPUcUwIWtdLfjWFQeQVNm/QN2FJ9Kz/9oQmZ+rtXALH8JiHaVw+CIBIdWZOkDZA9g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVA0R3BqdlFua2hXSXRTaUx1ZmUwQ09yZkJRVUM1bmNUZ2l1S3dDL3JNdnBW?=
 =?utf-8?B?anVzcWNBV0NxbEhwSFB0YzJsWVY0UzN1a3NkL28zVmYrWkJVZ1BRY01vOWVw?=
 =?utf-8?B?UkE3cGs4MnlKWHpUQ0lCZjd5SWVMd3JaQ1ZRczdrOVNvNkVJa0lzNWxqZmtE?=
 =?utf-8?B?NnBra25Oa2VIS0Znc2t4Mnc0QWZkcHoxZk1KNXcyZG83bko1OWRXNFpPVDN0?=
 =?utf-8?B?R1l1TkZaVFZ2bXhHWEQ0dWlhM01zT1MweDlzZ3dTMnU3b1QyblRtQjI1TGtr?=
 =?utf-8?B?N250ZUtnSTY3Tk1LUXhTelF5Z2hmRmhUWHBNNm83cENseG50NTNTSFpBWHdh?=
 =?utf-8?B?SXkvQzdBQ3dNa3d4RjI5aEVXd0RpZzhVWXBwam1vLy9OaTh6YVptL2hQWUhs?=
 =?utf-8?B?Q3RTUk9hR2JUVUo3dExGcHdnN2ZwNGJlajQrNlY1c2NTNFZqL0JPOTB3UjA1?=
 =?utf-8?B?QlVia3kyMEZrbGt4NDVKL2M0Q3Q5MExNdjd0ZHFrTEk5ZVNzR09idzcrSUpZ?=
 =?utf-8?B?Q29KN3pxeFh6akMyd3RMNS9BVU1OTnIyWWJXSkRDZUt1RWlLYmZ4UWwvQTl6?=
 =?utf-8?B?K1JlMm9KaVh3ZkhTbTIrS08rTDBFbnJDOHoyem9LdXQ3OVNYRkFpd0VlY1RH?=
 =?utf-8?B?OVRRWTJHSXpkUlpic2xGWDN1YUlaVUNFZ1luc3FIdzdLVCtpVTZ1VGp2alpa?=
 =?utf-8?B?enJublEyUEhRVlBla3NlMzZSRk9TeHk2ZHR5TG5xN3RISExwaGNkbWxIN3VB?=
 =?utf-8?B?b1pCdWIvNWZ4TFIvODRuVXA4WVcxa2ZyV0RYcXF2RzRxNXFSdGdqWDN6OGgw?=
 =?utf-8?B?NWp2VjNIZDJnWE9MTm04b283dnUvWFQ3czNnczJrRk5HUTR0Yng5dXpjMHhw?=
 =?utf-8?B?U0dWMmZ1Q3ovaXFleFVScFRvSWFhTFdYRnVMN05ITEo3WVZWK2crQlZUNjRo?=
 =?utf-8?B?WVBKUzd4ZHBUc1FJWUpoMm93SHlPSUxqdWJvUVRzajRFa2FQWjIzR0ZreUZY?=
 =?utf-8?B?NS9aeFdqNmVucTR1TVlMYjd0Tzk0TGJWcis2d3k2MlIwbnA1Rjh0VU8xYkNw?=
 =?utf-8?B?L3o0UWhYL3dNUVZkTVZtQ0dKRldUODAvZUJkdkRoZ0ttMktDTGtRZ1laRVVu?=
 =?utf-8?B?dmhsWVV2N2xmR0VkZFZ5b1U3T1RPVVJWOE8wN3Y1QWxtMUIrTjNISjVFYWtV?=
 =?utf-8?B?S3MrV0dMVWxSVkNITG5RbmZOVk8yVkRzY2g5NFVPY1hqRmVZcXMzLzBpWHI5?=
 =?utf-8?B?L1ZYK1p6R242bXBvb2JrWVowQThyYkh0ZjRCMktHUGRSMCtGbm1FcEFscEZE?=
 =?utf-8?B?T0xwdHhEVXhjSnRxdmtMcnhHNHp0U0poSFNJSjljekM3M0VvZjFDeE1Vd0dW?=
 =?utf-8?B?cTEzcTZrc1RKMXNjUGxxSWpuRldmKzlrbFNEQ2Y1V1J4d0VGR2NLd0dzY09x?=
 =?utf-8?B?VmpydjB2djBaUUIrbW5SUkoyQ2VVTVEwMklqMFF1V0Z1dkd1NFFqYzNmUjc2?=
 =?utf-8?B?WVZVYTZMd0FwZFRKK0lob3dwUjZuRW0vWG4vcWtGb1ZQcDFzVDB2SXFjVzd0?=
 =?utf-8?B?ci9ZWUpvWE04MEdmRC9XK2dJb0UxbVcyeks5cFhGNjRCcWwwbHB6eUdzRVdl?=
 =?utf-8?B?ZXE3czNLNHpOaFM0RGRiem1BWTEzaFdxaklHais5ZGNaS0lFNXAzQ0VyNnZa?=
 =?utf-8?B?T2FCMmdZZjlISmMvaXZLVDI0NFY4Zkl4aS9MN2xzWWZZbEJJTkdLZW1DY0hK?=
 =?utf-8?B?b3lWUks5WDBDYW5TT3p4SkJyb0doRHNtYWNsdEFSSjNRVFhOcEltaTB4TjJy?=
 =?utf-8?B?VFdDeTR3UkppZ0s4dFJlMExod21KRWRIdytZcXJhRE92NjFQSTFKc1NJWW9N?=
 =?utf-8?B?MzMrS1FOV0pZSWFYZUVBYTVtUW1qSnR1OU5SNnFDM0tnZkYzM3dpbEl0c0hO?=
 =?utf-8?B?T0g2cEFsSGFHT1pvbWFVb1RUdDF2WDVTVnM5eHZON2YvWk5yTWtOU3JxK0Zt?=
 =?utf-8?B?VzdVN2VxOEl0cUE0UGtwRWJia2NCbC9mb3M4KzFaVzc4Slp3TDQvYUp1QXds?=
 =?utf-8?B?bGUydGk2TlNZeDYvMmFqSExsTVJnejVYUVZmL1NSaTBYUXhUQ2MvT25xcFl2?=
 =?utf-8?B?MGgxRmE2NVhabi9UOFFxU1ZhTXBwMmRkZlZZNVVIeExpOE9uUkcvcTBPQUd4?=
 =?utf-8?B?bXlpYXBXMjBRUUEzZ0tLbHl2YTR2V01ST1Q4RnZYRWhUV2J0bTY5N3JSbkRW?=
 =?utf-8?B?R1J6SGhnbG1hRmVzaUpNTTI2WkRYTmNEK3VBTDhBdjdUYjMwWmdpVWZXOFRL?=
 =?utf-8?B?TnhNMVVCNmRNYzBwczY5bTFwa3I0Zk52STVKYTJIaTZIQ3lPeVI3TEdrTk9P?=
 =?utf-8?Q?r44fxrk0Rnd3HBsU=3D?=
X-Exchange-RoutingPolicyChecked: AzifOEzR+mf3lV5py9J9v/jCt009bj4siVTOAcGUYdBfHxk/gLii+UOrBDhoBmXbI8EnGDjuU8FUWs7in/h/IeWjzKOItIPU44dQ4cok/Kf9oeyDAbDpT9I/JVDOmM4qCEX4wr1Kx3YHcHfFoRdr/V5C4a/PTHEuB0lvSf++9AVD8FiQh0X6ckqnHFZBAhDxsfuSiR+XqYRHriIi2jcH1AqTAH9AtyHFRcMb+6VH5ovhu8UMVgEcPP7DQ6HcTON4vKx5lH9IeKuk4paZiCdKBItgQYpVgM40VjpM1dRQSmLb50e3D5ibejwNDhFHfxMoSCnLrsYZGpWnIQIcIVbjxw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 562c28c3-a4b9-4d84-8bfe-08deaa58ffd2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 03:47:16.0568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jLfzRrt3J6oln9NNOd4LYkCnIjv8i42iDCJgnrZvM+60R745UrUbdR4gJqpMQLN71c6JUdbS2MuuueC0Q62R8LiqIBYuo/MkMOw/54xlp2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6300
X-OriginatorOrg: intel.com



On 5/4/26 4:12 PM, Shuah Khan wrote:
> On 5/4/26 16:57, Reinette Chatre wrote:
>> Hi Shuah,
>>
>> I confirmed that this series continues to apply cleanly to current HEAD [1] of the
>> kselftest repo's "next" branch.
>> Could you please consider this series for inclusion?
>>
> 
> Quick note to say I will apply these to kselftest next for 7.2
> 

Thank you very much Shuah.

Reinette
