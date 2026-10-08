Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80B83D5259
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 23:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791501951; cv=fail; b=mQKZKEUpgmhyWzLplmmrH8Dn5yY/8Pa/rd37QTGofGy0mxGp8IBVbXVBqIHN7eifSYq53zm9aTt0izKVR3byyvdfJlL1mBZrt80i6mkj/ll6iWlZeqNMOkRJchljJMVHfcLo9bKHtkuEobUt1NwihbB0/YQlY7bbuAwQYS2a1yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791501951; c=relaxed/simple;
	bh=JfspvJ2+cvcMBb9TxeARxvmFWyNeXKlYR028FLfRnts=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XzuOY9M99VppI+hfkhFj4yu2/Avz6Qw8mX7VShlL/XpRNMJSaAPrMYyIYZ12VXLw9xCiBGQqMuTZVpio35c1rC2D8RWB5V7if0+xwMVBGRgy8/FjkocaScZYDNdITA8E74srqyAlQ1Nzw9JWR/Mz1f3d+0ZUfH8nTlI6sPZBeFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J3K9UXUY; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J3K9UXUY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791501950; x=1823037950;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JfspvJ2+cvcMBb9TxeARxvmFWyNeXKlYR028FLfRnts=;
  b=J3K9UXUY4Z4sQoQIo+YvrXEYdOZVSR38fn4P/PtHT1AX6lSVvDosBuBl
   yS4tttdHcmbnLYfA122lto/qfhzpbuWsx0eUFnlnWGFlrWme0kPJoS6Eu
   VB46qOODp+rfBxHEGERB0tpyNeIY7Lqf4xUeyfgC4SrJ968GSHzTjhWBE
   5Vt7bKi/F5zYokZ4t3fctUeKBNsMQl0pUNxklOqpD5qSuI86NbzyqMLPu
   TAFRUMooA0IHqIne/ikrrteEZOhGKnaKygg2Djfinn/Ke9H1Ub7++61f+
   Gi+4ayzPwmDzhw/vwfEexJMWvQL0Mc0b0U2+L0uVph5Q0a+mNgW/DKXdv
   A==;
X-CSE-ConnectionGUID: AzSWZ8kzSeqH7dUKwQ1reA==
X-CSE-MsgGUID: 5dBENcLBRFqgzqbFHYxcpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="181704"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="181704"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 16:25:50 -0700
X-CSE-ConnectionGUID: nlEQRkqvSSah+sH6puwwXQ==
X-CSE-MsgGUID: F6qO/R57THmUenPWVzD+UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="126350"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 16:25:49 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 16:25:48 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 16:25:48 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 16:25:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8GUr+529k66Q5oI+J70OK63DZfBcdzpw7B0JLel8BxE3pOpgrl7J+C38eP/aV5EVqpqRcvvpGgbOrlY8uAnO6Yj37Monj/QSmve9te3Ro/D+xXWaNYlapXz7A2No4pgdbeEiQqWTT5s3qFkcZo8gyxkNFwMg8dTamL53CjnktcTMjlY267LbPswBMhoaR+MqkwHXY54/Vh3RKURk+zITJ663P+y4oC3M/RbFvvJ469JkRfSKKz+BeDNaKG/IyBTaOOLS7L+D3myzExSAHIAX15NRlsZOcJKWB8AwRewI+hU51fxVq3ICol6+8Wu33sty/x6kiTR6wwRG1ol2qHz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVACnzM05q+Hx3TB3Kjsvm/fWOrh2bF1Mx1lVx6FxMY=;
 b=Px/1/LtDKYjvLQARBwBhJcrqq8QHjmsQnhCkkJqoQLa98Jvi77PE3xsf/KpUC7MLcrmfbxN3yLCkDnGyTow2Xri0GENY7ohXEvxWxpg9LSQFjI8Zuo2pFBXZ6bqvZEO8JOyP7j6QAoqWGkecfZT3caxPAV2KRp33Rf0YzO6n4YDDm/quq3/1qDK1aXPsyWgRQFcaFLE+lvtY8WEsOu5QtHwnVLoob0wbFIMmYAiVn9gXANt6ApwJd1eu7c+aSsw0816gUsy1hKMS4zspzgbhtW96OW3FHM5jfyb2t0Gyaqq/HISK/TnWxMW+4XlcCopH7M67eF0urXW2O4kJndVK9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Thu, 8 Oct
 2026 23:25:43 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 23:25:42 +0000
Message-ID: <f20e9525-66c8-4fb1-8b11-789c72532840@intel.com>
Date: Thu, 8 Oct 2026 16:25:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 03/25] x86/resctrl: Check if monitoring features are
 supported
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260928221509.68002-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:303:16d::22) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|MW4PR11MB6936:EE_
X-MS-Office365-Filtering-Correlation-Id: d02ec4d4-a3e9-4782-0915-08df259378b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|921020|4143699003|11063799006|22082099003|10067099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: MtX5rkKqwlo4cc5yzgQ2Zrwzs/aleTt27wvWpfI+AHbWY7H1I3gLkeXmGcbdyH5vrQ28nfBx7JwiqGBkojL3CI/CAhNAP1/ROlializSZGfnpyZxpstuDGQOLnXA/2WeNfGWCbAeLbB7Okwfz+SbXzRDMaQQZeknH2h3ioTfI9rYPAzXsMSYi1MR1kaMhzpxnTNTioS4S7HZBUFiI9H7QD2bnd8reOfrdDp1Uq1J/R6EY6TbJaiDz1E32JqS+Z7txncZb8TfGCsPiOZeQ3i/PA2rtwGbqKrTZUYI1aGbGeI5kNUPYqnlxjEFTjJF3CBc56FAU+2nEtVPrE7l6D9Re5cL7I0LEtuxAPQxxY7omeXT2/VS0ai/RZ8oMmjtsymfACl9scd9AnB088V2BPF2cwE1xRDopz9VxrWVMs6YHYzLnT2lO6A71NNfe/Ou8BVatKTSD6NyN5sYKHMFjBPKYdM0OZ/UlliGHaOtuUZX0XzzDmSLGrx+or1I3a1Dm/LjJL51So++iIUrGIpJYy9F5W0zeXk/vr235MK6cB8woUVnWdq8P6LBt4p8mgL8ScnhmtAxNqgKe4nZRRywt4dSs2ZEO24dGrcnW81HfZ4Z4NO0EJoAkUKn5b3A8vh8uC7ti2kg2ihuUbOE2DkgizpIdTKhYTSryh5MCJUvAa1j5i8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(921020)(4143699003)(11063799006)(22082099003)(10067099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVN4T3MyeTAxY2R1YWtPdUM4alU1RGxWRytMd0RVbE5CdS9UYVp3ZnNtVUVN?=
 =?utf-8?B?QXM4Nm1ZVEswZ0pXak9zTUEvd281Y3JYUXNtVHc0WFVKTy9NdU9LdnZvK21T?=
 =?utf-8?B?N3AvYUJNUFNIek1qSWFJcnJ5RlhUaTlNRFVNTVNqYWdOcEtzWkN4Vk55UlVW?=
 =?utf-8?B?RHk5UzJZRVhaY1FueFZTR0w2aVlSNVMvd1Nob3JuK0xVU1JLRkh2NWdJV2JB?=
 =?utf-8?B?akhBNkFKcUhlcE5idUNkR2JCcHdTb2FYZEROZGhWb3ZMdHVsUGgvSzJkVXUr?=
 =?utf-8?B?aEpUOWFCNW5Bcm0xeHRWSFdMR1lPRWQ2MEs0ZmxqZldaTWNTQzMycG8vWSs1?=
 =?utf-8?B?T25HN2pEeGJXS1RraUVPTFppRUFNSWgxM254d0ljakw4akRYUDJuWWN3VEtQ?=
 =?utf-8?B?UXkxMGc4RXFMeW9OQUJKdHFyU3NvWDMxNm1VREx3Q1NVWEJ3SWF0MWJkTnNQ?=
 =?utf-8?B?dG9CMjJQNXR4dnc4NWcrM3BGSXNIZlZUaEpqRmx2czFPUEVyWGx5NWRZSHAz?=
 =?utf-8?B?eGZmeFhsUS9EaC9IU1c1OEhsbGx4eDVqYUc2UWZQSWFSYW9saUl5NVgyVkxs?=
 =?utf-8?B?STJQT2t4b1VIa2h6OWNucUpxZXdpZU1iek9xUzNyRDByUjFCMFNtWHVNaDR1?=
 =?utf-8?B?NnpqYXRMNVVDRnU5aVZUeUFJNWZ1Yit1V2VNbnhSTkltdVB5d3JDMEhZYjBQ?=
 =?utf-8?B?ZXFlc1h0a2ErQ3VJWTBhTy94YWV4dVpKT3V4OFVlcnRKd1ZDZDJMbGpNdU0x?=
 =?utf-8?B?UmFEMS9vMHNuQld5YnFVanlyU2VVSlp4VXJTM1hnUHN2NTVXaytLWGkzZGs5?=
 =?utf-8?B?eEhXR2gzUStLemdTT0FiV1FZajFUNFFnbTgxQTVRTFNnbDNsWkpoaHFTQXRP?=
 =?utf-8?B?RCtHczVaQVRCYlZJdDE4YjRYNTlCUzJHM3hPNmgwc1lsYUVEcEtDN29pNFZP?=
 =?utf-8?B?KzFZdFZkLzdFeDViREllaENONVh4MG84MGxLUmdRR3BkR0hkSWkxK0RLSmxO?=
 =?utf-8?B?VVBCYlFmdVE0TkdackhKaWRzYUNkVTU5NEZFQnBIckhmTEovejdKVjhEZHdn?=
 =?utf-8?B?VFcxdUFZREhOazQ3YncvOVlhMWpoQ0svdVc5ZFFEZHR2S2MwZWhCbjRWa1VN?=
 =?utf-8?B?VmlDb0dwTFFYdkNxRXBkcXNvd1g4MnFvRG1OdWo4NDFYT0lidWRNL3lud1I4?=
 =?utf-8?B?SUo5eTVnaC9sdmcramZVTGhaei8yNVFiTVpUUkVCZEFqQ29vdEhsZktQRjJk?=
 =?utf-8?B?Y3RRMk9QWllWK002VlVTcVd0dEp2azk5ckIzWmVENWpQYmZ3TENieUVCR1Fy?=
 =?utf-8?B?Kzc0b0U4MG5nWDljTnRHS1BKbExhdVg2OHN2VFU4REt2eU1iM3RrNUYzS3Q0?=
 =?utf-8?B?a3JsSjNpYURWbEZ0a1hiemRJT2FpSnVsRGFrZEF1eEJlRW5iSDhSSGR0SGRm?=
 =?utf-8?B?RUNjU29UR2JsOE9qQktiNFp0bUFjclJEVGZQT0x0dVJueHpmbHYxUFhCY1VN?=
 =?utf-8?B?Nk9oL0RsU3IvRnJ3MXoyR0gyT0xOM3U3NzNqZVdUV3pOdk10Q3FyckgyM2My?=
 =?utf-8?B?VGErbER2czFPYktoRitkcGYxTmgyRVhCWGhKQjlGbFhNK2Q1cGFZd1g4UlZ0?=
 =?utf-8?B?dXAvZE5wZkdXTmFpYjU2cDgxZlIwdHQxeHFicmdvMlNQSzhwUzRReVhJRERz?=
 =?utf-8?B?R3FCMDhVaEJ0NXVZYVlTdms1dllwZkVXV2Y2Vk5qaXVMVjh5WmxQUVV4ckp6?=
 =?utf-8?B?ajBsTThDTHVIRDRYTjZBTWVvSVlwQVZpQkluc2JLZVNwaklnMEFTc282ZGVX?=
 =?utf-8?B?aHUrRjk5VFppejRlYnZGcUhCditLV2cxZ3RMWXNhMFJPMFU5TjkwWW1leldq?=
 =?utf-8?B?bnh0OWNva0JubUFiMlVLKzd4eGhuZHZnVFpYdjdCcVJDY2VaeHdoTlBRRHpB?=
 =?utf-8?B?cVpJTmdlcnlrMEhUZ3BlNTY1UW9zRmNpcnNGZ1NmV05FczhHbC9wbmY3cHNC?=
 =?utf-8?B?MU83U2VQeW1sRTB0Y1hFck5Yd01IRWFlZ1N0b2R4MjZPNXliSmlHMi9RbWVD?=
 =?utf-8?B?dE41RE4xUnBuK21Kb1hDbXcwTXl1dVZkMXhJMlhEK1E4bTZhcXJyVXdSbk9w?=
 =?utf-8?B?blR6L1QzQzF0cWZQTkVYZFN6K1JvTHVKTEQ4Y0RyWVdJR0N3ZCtsbWJDT2c1?=
 =?utf-8?B?WHFRNWpESUgxenVHVllQak1wN2p4Zmt3TEdOalFETDN4MDY3NkJTTjZxV1JG?=
 =?utf-8?B?T01XenBkdkE2cUdyeGJXQ0N1SkVDMlFQdE1lU1QyQnp0Um1kaXlQK1JvRnZK?=
 =?utf-8?B?NW5qaVUwSVhIS0NZcVZBU083K3JqQ08xbDBackErQlVQdnhTNy9yeFBnK3Vv?=
 =?utf-8?Q?OoXkQRdasap3VB68=3D?=
X-Exchange-RoutingPolicyChecked: Q5f6dkyuHWWA6FPWJHFDm3Lw058FG+ZWpza6a4ti1x63fcyzCEkOaQMbY2eSgo4VY8loLP+3MYHLesOYkk+X8RcJmSZqw/YNV2NpzgR/52Fvm7XaFpYvdsgZf8wisFX1HG+aHeWqtyDkkAVeNWf3DUMeC0fWjNO9ePBbBocQRvR+ZLeGqkHFyVAKvNoP/HnHQesErq+f/IwfCNwD9ZkVu3C3sWwIzTd7lGGi/42PbMQNluRncbEG4eAdaK/lJ1FBHncbABM3EOk65ruiIjX44I8tdL4V72Fxohz70qwo66iZLa+ilTmqExurFCfveC50sEcsXGP9itvGlyAY/luVOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d02ec4d4-a3e9-4782-0915-08df259378b7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 23:25:42.7690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNY32Qnarvd0uK5kJgAd3B6KFZlOexlXvnUGfp19As9ks0e8Qz9eicNJn5kJJmUKsCM92Vjmbpq/gB3Q6k9wCkh9b479sIFr2aSMM1hsWp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6936
X-OriginatorOrg: intel.com

Hi Tony,

On 9/28/26 3:14 PM, Tony Luck wrote:
> Both Intel and AMD manuals say that software must first check
> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are supported before
> checking for resource specific features supported in subleaves.
> 
> Each of the L3 monitoring features is further gated by CPUID(0xF,0x0).EDX[1].
> 
> Add checks for these feature bits.
> 
> Maintainer note: No need to backport this fix. No issues have been seen
> from this failure to follow the exact enumeration process in the manual.
> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v13:

v12 feedback at https://lore.kernel.org/lkml/430f74d4-5d04-4f95-b7e9-83dcd5cd5ba5@intel.com/

> 	Dropped (Linux: X86_FEATURE_*) from commit comment

My comment was only about the "Linux:" caveat, ideally applied to previous patch also.
The feature flags are useful.

> 	s/specific features/resource specific features/

Suggestion was "resource specific monitoring features" to emphasize connection with 
"monitoring features" that precedes it.

> 	s/L3-based monitoring features/L3 monitoring features/

Suggestion was "L3 resource monitoring features" with intention to connect
it to first paragraph usage of resource. 

> 	Added maintainer note about not back porting.

Maintainer notes are not intended to be included during merge and should thus
be below the "---".

I did give preliminary Reviewed-by tag in previous version. Giving it again should not
be necessary since I am just repeating myself here.

Reinette
