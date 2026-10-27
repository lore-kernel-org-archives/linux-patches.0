Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793111022;
	b=w7bqyKx6xYU6wpZJTqA/17SumM2XXCXAMURxvrSTBYFh60ldygMHfvE4nZdVOhSsIO+f
	 vLsppnRfCCvgYCkxtYx1kxxZF/5XJFMooQp/FHJnKLu2lX6K6iUSre0b0Si8fFqcwk8rw
	 DX5dRqr/0aZQ90xStVOQUXKpxy+voX61bdfNbzhCEqeURPfLuaneB51mEoMoDXh7dJBkf
	 3Jq0NZmFCTD6ikzMA5lnSwZCo9EUwP4DVcTMCdyDCMZvQcNvBPZvRYELk5s4mCSPuVSnj
	 P98veqvvc2X1RF6fHgaGw/NfRImDbbAhY9Jwy8njYxWmhC8Wz4eWurJ2k21n6IrYaNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793111022;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=3TeHgegcSUqtInBgiNa7xjibMFcHinMGaPSHlz8CPjo=;
	b=Uux/c2Qdv5Zp+c1TpPVuXJ5fEItVY7FNBEX1Cf68scjbzYVKtDxj5NICyBnlUBDnho4g
	 C75tHBEv6yYtNzKBixb8IahTiE/sy0mv17xBuPu55RAN352oRlRbPP9mvwA2wQqNRxezt
	 j0fRNl2/YiNucZ/ZAa5GziExnvb/s6GFuNnc0U0uyM1LM67S8MaXSjTilZgF2v+3Fc9Su
	 F9KQd3CNGXtrcURUBqeD1n8/i+xkY0fJ4fqCPqiZtxQ+xHVPfDFbQWHCASUudTHh/cM0T
	 XsZDK8Cm66QfrBhaTmiW83VxTxpkkFoiK+v14oVmppSYnNuN4prPPnYC0hoQzlI0UNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="PP6px/qc";
	arc=fail smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FAA606A329
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 14:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22FAA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PP6px/qc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793111021; x=1824647021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wJlm3Gexn4Ss+9p1ILTdppk7rwsENKDoWIRmqtfbLAQ=;
  b=PP6px/qcoyEhGqdk2C/tETsHqV7XRrgNPOWuIm/rnPqo/QsEGophw4G6
   OX7dK5FCk5C2Eh5p0SY5318kPt/RET/XXicMEBwMaw4IGuAmXKeMJEkF+
   HqE7vYEcvqpgD/8QTH4/gBF9fGY+KHNhqVCg7OaXwaLKDOQ9FjB06rIzM
   nnQTqe3vGAWJZZoY7VmrYK/ZM4mdNO4PFbEpK6TRE8IjT8IY9cyUSjm4g
   bNXtn0h4A+9ewwIJuN9/haRlqNKM9kMxXbsXGpqtcMqgqeABLk5E6bMLc
   qf2T90hx3EDXbtltXO6N/Reo1zKOIslt+D63L3UOM67qrzSGtKnLmDfNj
   Q==;
X-CSE-ConnectionGUID: 1X4ORH/iQOeZNNTZhmfw6Q==
X-CSE-MsgGUID: iZ1fjVaTSTu9v9tx+z9D3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1842960"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1842960"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 07:23:40 -0700
X-CSE-ConnectionGUID: 8n9w6V2vRsmfN8O8lMuYRg==
X-CSE-MsgGUID: 8Ax3tJJwTcmO2I2ZVIvB7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="6397928"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 07:23:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 07:23:39 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 07:23:39 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 07:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4EurZX9ZlnTVMPNGBdvi+LJoqj58MTc47mS90+n7+ueLXmobnMXqjIeWSTvG1TbxFTxK3xguhYB+UkNVxi9ZOmwufrUuYE/qOFeUhcOG9ZDvViwkcIjXLDV3Ul8lHuotpqM3d+/awE7ZXNXTe813uTBkHZf8+xs9xg2qWtYc842mak8kA85WmiT3qP4qvTgFvN52SQ58eP61/wdticy98Qx6bMhqcjGFjKpayYK+P32x9WpoTatVhndKdu+pSuLbVZymkQ5+zxCx0p8YFXa0O44YO8j4PwOTQShg0UxncwomeEwef8ulJjICPPXPl2z32HhcBldHHB+w10qqRri6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TeHgegcSUqtInBgiNa7xjibMFcHinMGaPSHlz8CPjo=;
 b=h7Qp5K0gJDvpIwe0NltTYqeCHFuLlFMckrWqb8GxH/wbIBk5L6HQSUhapzIhSeL4uFzjHgSdXDC9vRzKqg6S+J36EszHZx7xX8Qd9TAicklhg/5SwXaqFHt6+wCC/lzYngYyQvH98qTxAo6tbTUbFm8GrKwLfHa+lgYTFjnkJOWSM/Qh/uqJv4DtasXn3Eani2F49wmOZh9AH7FVENd6zEFA8qPNebV4U/wFsKv0E0nzckBdf/PEkGceunow3gmr65fn57OmSg0hXgWqsvS5UQyxYvDQ1JLenojysdtbZOslBbx3/gxs7rGyeO1T7LqYoJEn7VEH1qu7GFGZCJnxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA2PR11MB4827.namprd11.prod.outlook.com (2603:10b6:806:11f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:23:37 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Tue, 27 Oct 2026
 14:23:37 +0000
Message-ID: <3d64061e-e571-43ea-8216-170a726b4029@intel.com>
Date: Tue, 27 Oct 2026 07:23:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/10] arm_mpam: resctrl: Separate MPAM domains
To: Jinjie Ruan <ruanjinjie@huawei.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <9e0521af-4ae2-4a53-bbd5-2d86cceb69c3@huawei.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <9e0521af-4ae2-4a53-bbd5-2d86cceb69c3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:303:b6::14) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA2PR11MB4827:EE_
X-MS-Office365-Filtering-Correlation-Id: e07020fd-fe03-4de8-2c28-08df3435e39c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|261026140227099003|260925021911599003|260925022911599003|260925021311599003|4143699003|11063799006|56012099006|261022075727099003|261022113327099003|261022105027099003|261021121427099003|261009223027099003|10067099003|18002099003|261026121527099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info: Wz2oP3tveXsLlMaoYXJfCBFqOkZ8HuK2vGUo6ez/MD9Ec5WMhkhThBm2d+GX58Uamm/p9Tbrv8BJ0fROJ/9pygMa0O06k17JKqNQ2lB3SmRYyB4kqyjKJYgwoxX1tzZzmBpbeJ8EETi8Wcb+WnuRbymCiLPtaTZpVQMIdJq4w88QxbSzeQa4dy2zne10KqFCz/dt03b13neG4w7ngSEHMytinAyDl02cVxPIN+59xq9Di3PQXKp6Of/MJgKoyKzhJ1grLRlkE5EUk9wjpISPX9ngDcdxJ8i/PCJmY1dSEOpWP4UrLookgwOXvIbXMeWDB9SoZzBj6+zJVmMaRrgWXTtW8NvzIMWMMdcimYmMrzu+SfB1TLpXJ/PiZpF83bd3EzJ6HggT5TPiLaCFZXgk1feNFGIGLYq7rQI8jsnFFzVP/cwV5b3Rp46WszKi/9Q7xh0wuHRUk/gYEbVix1pboltDshv9VcZnwK/0lFZl0wuEqFf+LcHCklVkScCJceIrSSzIINGeoSRNLfSenSrCc13gu3MtNJWxY4LIyD1xwl7S8nL2r+SPDJAXUQykaWXAThzCSj7BzV8WSb9ayGSqncPw+H+SrqIA0y1reqK98daaF0h4ryX4hD2F3/2BzETV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(261026140227099003)(260925021911599003)(260925022911599003)(260925021311599003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261022113327099003)(261022105027099003)(261021121427099003)(261009223027099003)(10067099003)(18002099003)(261026121527099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVVtUFZWZkV3bXFqc09WREN1c3FNaG9hdE84Y2hhSWlNd2VVM2JZdmRuclJj?=
 =?utf-8?B?WTZjMUJISXVrVDE5NmNXaS90YURiTDNuUXV1N2toazlreHB5WlI0VDBWczVw?=
 =?utf-8?B?VHEzdEN0RDAzM1dYQUM5cmJOVHlrOXdnWlBJSmQ4TjNRWWNmQU5ocHVoMlNL?=
 =?utf-8?B?eE9tMDBlSDJzN1ZiSWF0cEg0amdRQWNTdHN6K3QyNVJKT2NPcWNTa2dOc0x4?=
 =?utf-8?B?MlMxZGFTczdMcFZLR2FYcFhCNkxibm96SUdod0tPWlZta2d4cERLcWI0d3U3?=
 =?utf-8?B?QThmTVBpVHBrWTZkMW1GU1FTRlFuVlhhcElhTXJpNlFkMFMrZTJEc1pSM2VO?=
 =?utf-8?B?dlNsRElaOS9vU3ZyaDMvSS81a1cxYkdQaUFVWUhjRzBNK1B6S0tncjFGbGJV?=
 =?utf-8?B?b1NEV2dncERwd0NaMnZLaGkxM2NJZ1QwR3dzZVc0U0l3NzVXTzZzK1praDU2?=
 =?utf-8?B?TXBWVmlKSXFmY0dSMEJsYVZXajl6UDlBUS8yNUxJTXA0ci9YVHdHSTFaSUha?=
 =?utf-8?B?ZFQ1RmQzbWhiOWZnZHBYby9qZnpHVU45M2QycDNpN0hWK0NncmFNSzFIcXlX?=
 =?utf-8?B?dHkwOGtmSGh5bVhyakltUkpsT3NidmxKUTZCTXFSY1dWaU5zVmM3REpvMTVx?=
 =?utf-8?B?bi8wQjJNaXVsQVN6N2EwTTZHS3NvRy9BbkNFcG9qUXRJNjF0U2h4MXBEamd2?=
 =?utf-8?B?bElUTkNINElQSlBxTWpQTW5LR09FNHltY2JpWGpCNHhLd0RDY2tCRWlDNk9R?=
 =?utf-8?B?SjhiZHF4eFZ0ZzVoNS9FUDBqSnU0QzhSR2JBUFkyd2diVHRtT0psT0VleXF3?=
 =?utf-8?B?dXE1VysvVVpTRzhvMjJUb2RVWHEvTVF6U2ZodHR6c2pCYVVoNlFoazZmWHhE?=
 =?utf-8?B?emhCcm9VRWkzREhzcFlPMXRockoybWVCeXo3T1JKSGprU2ZaNHFxZ1c1aDBx?=
 =?utf-8?B?YnhrRXFUR0lEY0h3cVFBYUpuRUJ4aS9rS291MGpuYjZOdnhCTHRlVWUwYzVU?=
 =?utf-8?B?RW9xOEw1dmx1R0xHOXhHZmVwSVN3QkV4UEc1RlpMU005ZS9YdXFuN1YvOHI5?=
 =?utf-8?B?K01uVnk2b29lckJobG0zaDZkNmlyY0lUUDlhSCtOYzUxK3MxMktZdlNtRFB2?=
 =?utf-8?B?Rnh4V0p2N0ZqdzN3K2VXZldmbzlwekgrT0d1NldnLzd6c1dFeEdmcjhyUHhN?=
 =?utf-8?B?TWh0b0Q1SEo3M00yQk9SODdIOWVTZU9YVjhNUnVON0NhZUNOSXR6em5zSXRt?=
 =?utf-8?B?TDRKUGIzcXRTUDljL2lWa3lsSklWREM4aHpHc01wbjQ0ZytOSjFqNnEyOTVm?=
 =?utf-8?B?N1IwcUxhNGhZNzQ0cE4zeWlEV1R0cVNORXFVR1k1VFhWNWRKNFhWdmRLT3ZM?=
 =?utf-8?B?UGxKd0ovOWdHMGNlM2NKclp2QVJyNFBkVUswWng5bFNOSUgxajNDSmZrSmJr?=
 =?utf-8?B?eHJKQ3NxK3lIYlF4Z005S1hjYzFCY1h3UmQ3b3BheXVXb3k2ekNKMmlESlRw?=
 =?utf-8?B?elJ4MFF4NTJVWGtTQ2Y0ODdUQ2ZhRitjTG1YeCt4Lzh2eU11MnRLcy85MFNy?=
 =?utf-8?B?dFRLQVE2dVpDRnhIYTNzN3k3bXl5NHlHV3ZZcWMyU2FPZXJhSmhCZHVPeWUr?=
 =?utf-8?B?YUJnTUphcmwzVVp4TnR6MHROay9VK3BMNkJRbG5KOHpaMHV4dWorK1FVVG0y?=
 =?utf-8?B?NHM1RXZxRlk4M0JsanBHZExZRFJER0l4Skt4a2o0cnl6allWOVF3Y0hDQUJG?=
 =?utf-8?B?ejR5azgyUHROcVF0dWlVc2tnWVVCVUtTRlVId3I0dlJjeG1pTDk5cWpRdWg4?=
 =?utf-8?B?N2JhUFpRZ0JCMVI0YWhLeWhpdVZaMVVBc05UV1hYSzFTWEFZUWE2bFNoclRK?=
 =?utf-8?B?ODhTb1JJSzhwR3JmQ2w3YzdmMFRMVU1ubWMxV2liY2lqY294bEJFdG0zTlpO?=
 =?utf-8?B?K2NVWFpBMkV5ZGFaUTlTdWRNTjJEOUREdStLYkVQdGxKZkRjR2FPSDZBSTZi?=
 =?utf-8?B?WW5hL0NIaEtwR084eXRocGFzbmswWi9lLzVJREg4NnAyQ2lZb1IwUmdORUFU?=
 =?utf-8?B?RW1uK3NxdWdkeDZtdjdDTklIOExkWkhWVUF2MGdhaHBOK3FYM2plNGliRGNU?=
 =?utf-8?B?MTVxVzNlSmFaMjhnbXc0VW9FS3pXTlFHY3N6VHU4Y3NDaXoxT2IybEJzdXFX?=
 =?utf-8?B?cTZ0Q0lIcW9kUkE4Zlc2K3lCVWpjS0F3M1BjSmlrdjh6Q2FjRzFXMWs4c1po?=
 =?utf-8?B?OFdoWE4zNDMwMk12UlFldzZxVEJmTE1VbnN5ZnhDbGFDN2tpWXZVd3NTSHVz?=
 =?utf-8?B?MXVYN0RwZjFTWGV1cXQ3UkY4QVdsK0F0dDhaakIweWZFeERZNHJESmFRZ0Fz?=
 =?utf-8?Q?d7HkV8jt7KFZ2+Hk=3D?=
X-Exchange-RoutingPolicyChecked: Pngtny6Vgg0Empj4zLkIQLyfm3vs1LYkgku2zZQFU+nP+ltp6p2Mf4Ygp0QSn+Bx2Gb0MfWAZka25hK4mXPbe4UHaX1zq8nnwHUi0XQj0ewVL9iRA9EpkE/F+0Y6jdpFda0LM3P+RITHuq9bjsc2x+1kkfBCHfpewjZA0JSSforlMZXqi84QQIA4oP9KiPcl4az6QTWZOpCUS3OzReCDu7PhSlWicF2DU87sU2ND2VgBxd2npsDGQuDfj9wVIbdlrRWRb4nUrZBxvSKMofOv4ISAKyRUZYKc1WwsGM/meMFypw4C+/L8DldOtmMGlkCab5N5OH4CpqKCjcsAsiHdUA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e07020fd-fe03-4de8-2c28-08df3435e39c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:23:36.8743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaTcOVB3CSdoFAatouHXWoWHVNGhpkZA9+LQl+kgmDyolUgLClMH/4FrssungLjfUdY+QaDcldLzvHbRMQoT5q4N+mAIqjd/rlYXXHAJ8Mo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4827
X-OriginatorOrg: intel.com

Hi Jinjie,

On 10/26/26 8:42 PM, Jinjie Ruan wrote:
> 
> 
> 在 2026/10/20 6:07, Reinette Chatre 写道:
>> RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
>>
>> The MPAM driver represents a resctrl domain with a single structure,
>> struct mpam_resctrl_dom, that holds both a control domain and a
>> monitoring domain. On a system that supports both allocation and
>> monitoring, one instance is created for each domain and its two
>> domains are added to the resource's control and monitoring domain
>> lists.
>>
>> Holding both domains in one structure requires control and monitoring
>> to be done at the same scope, and ties each control domain to a
>> monitoring domain. This does not fit the proposed support for multiple
>> controls per resource [1]. There, each control of a resource, for
>> example a "min" and a "max" memory bandwidth control, has its own list
>> of control domains while the resource keeps a single list of
>> monitoring domains. With one structure for both, every control domain
>> would come with a monitoring domain of its own, which does not reflect
>> the resource.
>>
>> This series gives control and monitoring domains their own structures,
>> set up and torn down independently as CPUs come online and go offline,
>> in preparation for supporting multiple controls per resource. Along
>> the way it stops failing CPU online when a domain cannot be set up,
>> and adds checks when setting up a monitoring domain.
>>
>>   1-2   Preparatory cleanups of domain allocation
>>   3     Do not fail CPU online when domain setup fails
>>   4-6   Separate the control and monitoring domain structures
>>   7-9   Checks when setting up a monitoring domain
>>   10    Comment update, kept separate for review
>>
>> An earlier version of the domain split was posted on its own [2]. This
>> version incorporates the feedback from that discussion. It gives each
>> type of domain its own structure instead of duplicating the shared
>> one, sets up each domain independently instead of undoing one domain
>> when setting up the other fails, and adds the checks in patches 8 and
>> 9.
>>
>> Patch 7 turns a WARN_ON_ONCE(0) into a warning that fires. It is a
>> separate patch because it is not clear whether the silent failure was
>> intended. If it was, the patch can instead drop the dead
>> WARN_ON_ONCE().
>>
>> This is an RFC because I am only able to compile test MPAM changes,
>> which is also why the patches are small and each change is justified
>> on its own. Patches can be squashed if preferred, for example patch 10
>> into patches 5 and 9. Testing on MPAM hardware would be greatly
>> appreciated, as is any other feedback.
> 
> Hi Reinette,
> 
> I tested it on a QEMU with MPAM rebased on v7.3-rc6 and all pass:
> 
> 1、Resctrl mounts，L3/L2 each report 32 closids (control IDs)
> 2、Cache and memory bandwidth controls
> 3、Priority, min, max, option and hard-limit: write, read back, and the
> 
>    emulated hardware shows the same value
> 4、CDP mode and usage/bandwidth counters
> 5、All builds pass without warnings: arm64/x86_64, debug on/off,
>    self-tests on/off, resctrl off, ACPI off
> 
> Test cases: https://github.com/ruanjinjie-eng/mpam_testcase/tree/qemu
> 
> Tested-by: Jinjie Ruan ruanjinjie@huawei.com
Thank you very much for this thorough testing. It is much appreciated.

Reinette

