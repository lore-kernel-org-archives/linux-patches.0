Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793125847;
	b=fGOUazN4XqT7C+kyBJbXNH0Q98CaPAo1INhsicToZez5IHJjsnkGmvdmJvaZRmSPYfIK
	 FNsRJ0TqTnfH9S2Y5VHwCfTinLfxMO2K52k05TDPLaqMm3LGJNkg9iKhPsq2gVmbwXbUI
	 oe+MqSud4FzxWxi/CQh2lXv649MWRcxgvpzwo6tVYIVsPFP60/4nKe1OcOAdsw3dJ8Fm4
	 1+yAhZx1QKMnN2UZEPdKlwuHlqrKQN5CDPtAZav+JoshQFzh65MG8hTmhWL6vHvXqVpwX
	 2CKnaJ9qDnnei3GZv+6HuP9C5d+OJbSmMT0NnQ/3pTFhRa/urKk6pr7tg1JThzhSYKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125847;
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
	bh=XDOOm4bodQ1W237Gxf3jiPpvIWLaT9GS7qUFx2jP30I=;
	b=IvmFTLY5gccGI/zExd7m9eZxQrsY94zl29eOQ4BTjLCuDRrCfEPlsOR4WXpA34jGwAhe
	 Okrp1CRYI8JmA1y77NpZbebB49rWqMu9B2V+uhPZKpwRmxvkddiafVjc5k0X5HPYoU8Op
	 1Ea2SmezLMUfyKLXWc/MtPT8BkfmWlZ/wecNwHN2WB+8ruq6HSiGKp1q+Ycw4mlCMZqGl
	 u+ITqd56Y7kimFbB/eNUzYFWn6wDL2uWMvzJ3AX0B1jsmKj3r06R2K5m9qLuRXyEEhcbx
	 SlcnF3baAdADRYaaVLhDQOhp5eywr6NyZEmXuGqK6Kk9x98MyH8OJsYrNALwVzqeprg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZpkaLfmt;
	arc=fail smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B50606A31D
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 18:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37B50606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZpkaLfmt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793125846; x=1824661846;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TaeQgp/zQ3KHSstTrQoYtYjIhDaKUBn/Jx4wFxC1c/4=;
  b=ZpkaLfmtTcDtNThb+2YzXcjSrwwJWrRONQGN1FCApDnw5zL0GugjhiUW
   rfYf5JXJDAiVSgwcVB0cXpKBUggOcZDQWJ658k+Zwtadq3kcOcSZs8mj0
   C0KpUeKvMZWxjWd650/VTMXqwGhF0LOGwOp90nwDJJ4YGB/gwOO61gSu2
   G+f8AqFtkPAX7xeboco+uyCDod4itKOVZVB0SW4Ys0h72GUwJd3WtOsde
   LGSgP1XOCyzqqUfCYBJBoPg1rgFCeiiDto3/Lf7wtr3Q6SVB7Luk4qgnz
   CWKyFBPZ38Bt4D0ojW0hqWLWjIeWwVyRtJYlrFyxNZW5Lu7w+0HfxUjyQ
   A==;
X-CSE-ConnectionGUID: 94oUrSaXTO21Gxdcde3KOw==
X-CSE-MsgGUID: gab8wbhGT3i4mA6nG9k+RQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1864769"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1864769"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:30:45 -0700
X-CSE-ConnectionGUID: mMKbBu5fT+6jU66buTx9JQ==
X-CSE-MsgGUID: XlejRTmpQIq/YDpxnRkAdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="5013131"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 11:30:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 11:30:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 11:30:44 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.8) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 11:30:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNlB9zMmdpoM1smBK74l4bh3P4Y81r9wmpbP4gakBerE9CG/n4eDJYMmIuKNvVnreBtr3kbi7wtiT5N1V/IpjJ/8JJjIJ0+f/y0Hfa77tzo7dISSL5nO/KY1ORGoa1XlOeelMhBIUXlPV41pEDJ5PeyTs1lEBITC9sYrR1b/eG9HsPyqvLp0YmkI4gIaUy1XhF9jmN+CZdhegiw7qO0nWqW+pOdx0ceDg4wTcqmNV+JjWf2VF+ye+X2BSuTwr1e/I57yRmSN3aQwnzmmiHEqsKvyznDqA76PtTuymWIXS4rX0etFHkGdCzE9mVSHkenm/dG0L+2nHq5PzXFmXi2iYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDOOm4bodQ1W237Gxf3jiPpvIWLaT9GS7qUFx2jP30I=;
 b=iPS6SGt02TLHzvnjvQU9qjezW+DNW6Ss6dvFQjMRKJI7mT3nMXsASwXFuZMrfJXF/9qFFNpsTNrHYD4D+amuWpecpbS+VNrd591bEzeu4Fouj1et5XjZjudW6vkWcaHUvGne/MO+OMjKem5k0PkQ12OYcGmyxS7nPptySum5Hc+Dsi0VJO1nLY78CLeKJ2KLWNwethICgyH0zC8W0m1yY/vcIcE7cO4mkmpKK+rgBBMyf1Vv3Vp95nib76zUMsXVpiTfCUiRHGQdAhX6E7pZ76+cTSNPTz/g8YWm+hBmYXVPRC4E1k++Xjvcta9rKWt4GvILu3NVs971KcupWQBe3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 18:30:39 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%6]) with mapi id 15.21.0546.016; Tue, 27 Oct 2026
 18:30:39 +0000
Message-ID: <dbc8fc24-2ca3-4152-9bfa-81b6e5d502a9@intel.com>
Date: Tue, 27 Oct 2026 11:30:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] arm,x86,fs/resctrl: Support asymmetric L2 cache
 allocation
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20261026215718.16810-1-tony.luck@intel.com>
 <106caf0a-8644-4801-9591-80be38b39418@intel.com>
 <auDiLEujZ5BGCACj@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <auDiLEujZ5BGCACj@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:303:dc::24) To SJ2PR11MB8370.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SN7PR11MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 203c519c-fd68-4226-e13d-08df3458668b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|261009223027099003|261022075727099003|261022105027099003|261021121427099003|10067099003|3023799007|56012099006|261026121527099003|6133799003|22082099003|18002099003|11063799006|4143699003|5023799004|261026140227099003;
X-Microsoft-Antispam-Message-Info: 6/DzqYKO3bHJrTEZ0g3Rp8ba8uw1Br+zi+VEnSwemWum/VI8P5IBMuKBTA94VsYe8BbDH1kkXTp4/lItqFGVtNZpkMxXksjdLjn1A1wtLzWkLzVRCXIpNhIlTJKZ784yF9nKQNfKrA87NBK1Ohbl7LCuBZKFmQ5iPfEomjymV88bNx/i5F5vcSiRwOomyVdB875AMJwYn3xrw9r/+czOikI4kob8kP9mQpl/Pb8yTzceOIrR/Ib9onTdWPdzKTDEpN0Oy2cWnPNzJAdSBK5vU9TzI+U5NQvq08dDwQNQUcOKlURH0HaPx9O9WpMeAlgVXxwrwT7XBH+ppm08zgGyUHpSVkufAd01IdATokmn1R4eFMyIMRdH0kCvCBitcAEgAVCqj13d2yL/ik/lBhLHWy1yLc6Tpw+BtU0LctlDc+ftry52FBccYi+5EoC9EIpJX0uciEOhh1pqQQK+s2YYi8tpTKg9/CPflLijgc5stnt0/QjZ++8MIhVJhwIfgRqEonSFKq441aLgrEcPmDpvz9dRGy+BXeVpZE2PAl+5K/W1AGFjW1biAswfwCOQg/ILHWgDQqQPADGU7SAT4gP+mQqO8mMmFv4RVEPD8G+TaMz0IRv/bvym6X2i3JOw2EXv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(261009223027099003)(261022075727099003)(261022105027099003)(261021121427099003)(10067099003)(3023799007)(56012099006)(261026121527099003)(6133799003)(22082099003)(18002099003)(11063799006)(4143699003)(5023799004)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dC85NFVPYnE4WGpsUEFBZHRFakprRzdhZlZ4Z0tsVVZLelZVeGFkd1Y2Y2Ns?=
 =?utf-8?B?WU5TVnBPR3piSVgrUGZ0cDVlYVpjWXhUdVBOdmRZV0RkZFdXSGhjeFN6dFl3?=
 =?utf-8?B?eGVNMVpSeDlEeGZ3M3BQNFBQUXR0Q0dGck83QWRQL0hyM3I0dW1kVEk5RVJ1?=
 =?utf-8?B?dlEyQmxocWRvemhNQjl2UEttd3E5Tk9tTGg0bllVYXBsNE9STFJ3VHdLNFQ5?=
 =?utf-8?B?ZUYxVVN4V2JMekZjSlNqdTFzbjBtVjB0LzNQc05SaW5EYzY0Vy9JcHhzeXJi?=
 =?utf-8?B?M3g3S3ROSkp6WXZXaTlsaVRydUJJcGJmMmFBQlNqcFZYQWFtcU9Id3lDdExG?=
 =?utf-8?B?THMvMUVFeXpkbkdhWUhYMlI4cjJWa0tMOFB2YUd2SHVnTVlwVi9LRTdBVVJX?=
 =?utf-8?B?S2ZuQU5wOEYzbmRoYndGQklpZFVpcVFLQTVmb3orM2Z0MGc4REZQMCtnNklj?=
 =?utf-8?B?ZFRsLzh5WlVwQU5ER0hmd0lhYktqZkM1R294L2JKQnFoZDlDY1h6RzZRMUE3?=
 =?utf-8?B?Q1NuN1lBdGhYNmNOQmVQcEVSaFMwWW5MRHkrWlYrc0EzQksrOHRzaHY0OWh2?=
 =?utf-8?B?c1dieFlXeDZqbHl4Vmp5YnpmbmdiZEYzeE5Id2YxUFRCQ2NLKy9mVUVPVzhj?=
 =?utf-8?B?bGlIVUhMTmtzUVF4MFlvV3lSS2NFY0ZkY0VyKyt0dDg5NGlFSUk4QWdqNUNY?=
 =?utf-8?B?eDhSK1pXdW5KZXV4TzJRbVBBdlRqZVVoR25URnZSQmlsMmY4elBXWTNpS2pT?=
 =?utf-8?B?Vkk2VzdUalR0Qm9SZ0J5TDNqaS91WW5iQ0tSR3Mvdy9CZEQ4RHBrWlJ6Y1Bh?=
 =?utf-8?B?YkcxM0lWWi9LZkMzYnVlUXN3UU40Zk85RWlMR3ZFZ1lwMG05SUhyc0RIQVBJ?=
 =?utf-8?B?Z0MvMG5yYTlIOTZDdGFsUUo2RHBtYzkxRWFEUnFYaW91Qlh5YjlrRHErSkRE?=
 =?utf-8?B?NzdzbWRTQXpVbk1kOWxBMW5IN1VGcnhPdG4vSHpmbEJpL3ZPZ1E5TVhmOGRk?=
 =?utf-8?B?emxTb000MTI1WVlHQm1adXZNNWEzT0x0UnZhOHNxSlFpSW1manMrNDFDUnpK?=
 =?utf-8?B?SXdONGRicGVmTHFtZVY0ZDdPc3dHK2VOM0dJT1VrdGVodGk4L0VMWGluUzRt?=
 =?utf-8?B?MTZsaXhpcDdGOXo1MWltZkdjaHphTDhFZ0d0R0E0R0VzR3JZdDFsSHlIVjZY?=
 =?utf-8?B?Z1cwNE95ZStCNVkwOHptSDJMY2M0dHQvQ1VrS2I3azQwWDdiYTNjT3RYKytL?=
 =?utf-8?B?cW1MRmdqOU1ha1QrangvUC9mOWhwQ0xiNHl4Q1h4MzRCYy9rZ1Zhc3FFQkhq?=
 =?utf-8?B?OTJCMk1tcE43Q3pXRU11enVRUEVwUXNNQ0JFMmdHQ2tZYy9ERlZJVklqQ05P?=
 =?utf-8?B?K3I5bDdvR1JNUHFoZ0svdXBUOUcxRHdHODh2S0RITTFoR3N1Y1d4Y0xBZ0t2?=
 =?utf-8?B?clFoRHVyWlErc255QjUvWU4zclFEQXhiTytYWG9ZdWJCNlZkaTQ2Myt6dmR4?=
 =?utf-8?B?V3V1RG9mcWd2NmpFanpCOGVYU0RKT3hKM0M3RmZZZlRoVEVPSmNzQWZpdmIx?=
 =?utf-8?B?VC9pdzdEUWs5U1RwekNYUmRrNjZ0YzlUZjR0ektMUkpISkRIbE1wQy81Y2JK?=
 =?utf-8?B?ejhsUkxEbFpXREM5U2pWZThMVmN1QnVEdzdKOVo4dTg1QkU1dGpBd2JjZUtJ?=
 =?utf-8?B?SGtMTXRKWU1Hdlp2b2VxUkpBbDYrN2FxcVg0RlM5VllnL1JNZWlUL2NrSkxG?=
 =?utf-8?B?Uys2cktiWkZrL0FuZFdtYWV3cDRZeDVFaVB3bDB0alo5TG0zRnJVVWpWRk54?=
 =?utf-8?B?UFdJKzJENVJzaWN2Qks5WHVPZE55aHQ4YkJFRVladytLTUV2eElKdFhQTVo3?=
 =?utf-8?B?ZDd3c0ZQaWp3TFBGR2Nod052VkphbkdKdkdPSUdHblpUZVJ2K1ZWMWZiYytS?=
 =?utf-8?B?elRHczVYbW4vUWtUbk9DSndUbVVjRVRDdjNJbjRrRi91TnNCTGZlczdEYVE5?=
 =?utf-8?B?N3JqSHNrdG9hMXlSZS9VTVZOUHM2ZXlzcVhTemtkZDVoODNxQnJLUFJFYWEv?=
 =?utf-8?B?ajhHMzk2TVdHOWZJbGVJNWVmZ0lVWDJwUHdJdFNhWVFVOFpnRkVCYzZMb25X?=
 =?utf-8?B?SzM1czkrQXJycnZmOW42MSt3T09wU01VejJNYmdEVEh6bnpLZW9nVjlJQ0xn?=
 =?utf-8?B?Z3hBTFc5YmNDdkt0Q0RNV1Fac3NtZXJ6R1pUdzUxNFBaTDlRWVZQVCs4MmZT?=
 =?utf-8?B?cndrVmh6c1hjekx5ZmV2V1RLYUV4QXBOdFNqK2h4MDN5ZjJjTWZZYW1lTXhr?=
 =?utf-8?B?QnV5WTcyYmlzeWFzSXB6TGhROXZGTzZJbHFCaFZTejlnRlZiYUlpN2JyeC9L?=
 =?utf-8?Q?OzqzC7iFbnwE9yEg=3D?=
X-Exchange-RoutingPolicyChecked: RZGWCC+ncXwq/Le+NE8C5djmYAlhq25W+dmqVvPN7srg4hkFZpHNIcv63nTEi0UfkHPaM4SBtHmzeGU4/T4MGsiuZOnPSdJ9Jl6/6BoKrIsxc4pL+Q9qo94ycDM3ga86I+CQJmIkjv8nclXzZP8It2IqRusA7C4jCam0jTU+/bFobtdJg5IW6oZqL3b4hFxYyCeFmmDBoOTxWtbttB84ZtQr8PGYmv7QkzxVl+3//Q8P2v1u2xOydQp4jRcm29xfCh1YXL5PhLsgiNP2jb7K5SK2S7mzy6UjVJSfc6THLV/lvcQ2Vql8SRpCr0mghRpEqtsGV/IYPcmX0B5ja9Yq8A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 203c519c-fd68-4226-e13d-08df3458668b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 18:30:39.3507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqcLrKwKk+LL1lEl9UdcBtAPlqankLqhbWSfpMXtsh4yOFtZHKSYRlhUjR0bfBLl8kAFEyPn+A4ul26Z5AGuWy01JttIINSbk5R/zG+Csc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com

Hi Tony,

On 10/27/26 10:41 AM, Luck, Tony wrote:
> On Mon, Oct 26, 2026 at 03:30:57PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 10/26/26 2:57 PM, Tony Luck wrote:
>>> RFC patch series built on top of Reinette's multiple control series[1]
>>>
>>> The goal is to support L2 cache allocation on hybrid Intel CPUs such as
>>> Panther Lake[2] where the P-core and E-core CPUs have different number
>>> of supported bits for L2 cache bit mask controls. N.B. it is assumned
>>> that the only point of asymmetry is the cache bit mask length. Other
>>> parameters must be the same (but code doesn't check).
>>>
>>> Overall approach is to add the per-L2 cache bitmask length to the domain
>>> and use that everywhere instead of using a single value from the control.
>>>
>>> Patch 1 changes the format of the per-control "max" file and should be
>>> merged back into Reinette's multi-control series so this file can have
>>> a consistent format from first upstream introduction.
>>>
>>> Patches 2-5 are enumeration and preperation.
>>>
>>> Patch 6 introduces, initializes, and uses the per-domain cache bit mask
>>> length field (arm/MPAM change needs careful scrutiny).
>>>
>>> Patch 7 enables asymmetric L2 for x86 CPUs that enumerate it. N.B. it
>>> renammes the resource from "L2" to "L2A" to avoid user interface issues
>>> with tools that expect L2 cache allocation to be symmetric.
>>
>> I did a quick scan and it seems to ignore the the distinction between a resource
>> and control as highlighted the previous time you brought up this work. Specifically,
>> please see:
>>
>> 	https://lore.kernel.org/lkml/eaeb4259-46d6-4656-8354-669ad32654b5@intel.com/
> 
> I think I see now. You want the "asymmetry" to be a property of the
> control, not of the resource.

Asymmetry could be a property of the resource but this is not what this proposal
does. This proposal creates a new L2 resource under a different name when resctrl
already has an L2 resource.

> 
> So the resource name stays as "L2" but the control gets a suffix (e.g.  "_ASYM")

For a new control this is reasonable, but since L2 is a legacy resource it is
expected to have a control with the same name as the resource to not break
user space. This is what I aimed to highlighted in the previous thread.

> 
> File system looks like this:
> 
> # tree
> .
> ├── cpus
> ├── cpus_list
> ├── info
> │   ├── L2
> │   │   ├── bit_usage
> │   │   ├── control_mode
> │   │   ├── min_cbm_bits
> │   │   ├── num_closids
> │   │   ├── schemata

This needs an L2 control. As I highlighted in 

	https://lore.kernel.org/lkml/22ecec13-a703-414e-9f5e-75c89173e845@intel.com/

when considering pqos utility user space expects an L2 schemata file entry
when there is an L2 resource.

Since L2_ASYM is the native interface it could be used to emulate the legacy L2 control
albeit with poor performance. By default the schemata file only contains the L2 control
and a user space familiar with new interface can enable L2_ASYM to replace L2 control
in schemata file.

When I mentioned this before you referred to it as:
	"I'm not seeing a market for the legacy behavior, so implementing it
	would just add complexity to resctrl without any benefit to users."

	https://lore.kernel.org/lkml/as6Y72SbiXcJh6Ei@agluck-desk3/

I aimed to highlight in that discussion that users depend on this behavior.

> │   │   │   └── L2_ASYM
> │   │   │       ├── max
> │   │   │       ├── min_bits
> │   │   │       └── type
> │   │   ├── shareable_bits
> │   │   └── sparse_masks
> │   └── last_cmd_status
> ├── mode
> ├── schemata
> ├── size
> └── tasks
> 
> and the schemata file:
> 
> # cat schemata
>     L2_ASYM:0=fff;1=fff;2=fff;3=fff;4=ffff;5=ffff;8=ffff

If there is a L2 resource then schemata file should only contain L2_ASYM if user space
indicates familiarity with new interface.

> 
>>
>> Also, why does patch #1 drop the 0x prefix from new control interface when displaying hex
>> values to user space? This is a significant change for which patch #1 does not provide
>> a motivation.
> 
> Sorry for missing out the justification. I thought that matching the
> format of the schemata file would be more useful. Then someone could
> reset a group to maximum values with:
> 
> # echo L2_ASYM:$(cat /sys/fs/resctrl/info/L2/schemata/L2_ASYM/max) >  schemata
> 
> But if you like the "0x" prefixes I'm OK with that too. Just need to
> replace "cat" with "sed -e s/0x//g" to reset to maximum values.
CBM writes to schemata file accepts 0x prefix, no?

The 0x prefix is from the original interface proposal that aims support
generic parsing:
	https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/

I see your point about matching the schemata file though. Now that the max is
per domain it really does resemble the schemata entry more closely. The bitmap
max could thus be expected to match the schemata entry more closely, forcing us to
carry this display decision into the new interface.

Reinette
