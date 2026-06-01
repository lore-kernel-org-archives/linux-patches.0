Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1588C3630B3
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780352443; cv=fail; b=GDiKx5WFXYPfblSvzuUtheEC5NqzbVjYg9ZYJDs5Row9a8b07PMpFxQUe794E0wC3e+in/7Yg+7Go+eG8hHxIJBBbzKNLGFhXdpkWLTEYJ3K5mjSkFvz0dU44ZQy4pooFd6ZHB1OA4o8LzvhHun+cI1EG95ybTwtV5QYeXoLhjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780352443; c=relaxed/simple;
	bh=2LSVxjI4TNVEHsg9A5W/Hh0yz1BQ7R/QOcq5XcrUgBk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l4ibSAcUe2JS/kDtC5TlQSw/pFWgJuxhC+UwW7O38a6zsqJ9bOd/9MSvIJ836q3LwhTp2mA8CpDETocv/b6mE9PfAK/EoBpJs+a+V9koW1g5DibRUydJY0ziqWv7vXpeQrzgAyiYAgxFv+dUn6Im+DVnYCOgw1PEIKIdOPLhwjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAulVJ+E; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAulVJ+E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780352442; x=1811888442;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2LSVxjI4TNVEHsg9A5W/Hh0yz1BQ7R/QOcq5XcrUgBk=;
  b=NAulVJ+EWekgVnIZnh2YoEfaWyMYkYqdxmOFVzh8lhG+3jhlh5Hk6NZd
   +etmEhinHdTjAsOh8zD0FlnNKtZTcx/UKS/JWPILyJ0T34DrzT8Tp9gQU
   P7OO5iTm/rHh7JXLSaKkBfxScXlc+iALnsVCS0oJici1gpQiWEA+Lhufc
   UtuE/OgVnSxoeXDpm9ZcNeaaZPk1xWm9G/tdf2QU+lTw9J7RunsXYFBKk
   IOH3iL0Uxqp4fRZRaU7c9gxGQYqaou7ms5KRX0xu8Eghh2s9CsZPnVKMc
   cnDO8B1RCHbYtrXpysi7nyV8077wxZvhwIeFBj7ETr8/Dor/nFFLNKZJ1
   w==;
X-CSE-ConnectionGUID: Y7F/EZj5Sc2oiQhNw6Vvgw==
X-CSE-MsgGUID: G48Us+o7QmCDKGDTw4acuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="81115018"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="81115018"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:20:41 -0700
X-CSE-ConnectionGUID: BqBvYDT2TamxiZKABnPF1w==
X-CSE-MsgGUID: 5NmrcjgzTh2zJVJTPzEptw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242668944"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 15:20:41 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 15:20:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 15:20:40 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 15:20:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clddhgm+iw7q9mEtJw8WpuS2FFoTCxGE9VPwLv638IxqluX4OJcVkD0BC7gS4QD1KcsM+r9GINOTZzw88nMgMUGbRNwCHwCIlQvUYTeW5GG0l1QvUJLs98335LyUwcS6Ni5T/CSGd+ea60ePA9sjBufAZ3jKvG2xpV8ob34Ba5+3EzTPob0fleGXPnmzpSMi2cuUiyzqAkuXhxwIIA6v3v9vNsIi7ObycCOw8RAIEzRqmMhWWP4v2fW33ahZdBJZBffWzgfr8MxGdza6gPEe5C5pfR/+IAcye2w9TwXzxSNEAqwlIx53OnqCXSkunZldtCk80w1T/akRtVhrPk4IdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBTna+JUTJWgVMDzow4vlV3o5UmfbRwt33UZ1uAqs5E=;
 b=c+e2gfSuBy3QJ4dMbU6nzzfOEOWbNxibwcMSeeV3RlnLrmIyZXGurhfce4b2LamMjIokQ5FtKeyalQyC2U0Z1O1r/jp/45JYsW1C0WuNtyvhMvXn8+jKj+vUPld2igCKjRAHidrOP0BgYQjvliQDpa/VQif86YKtTSZwiQq/mtzsvMXt2gjM84VMZv/MXhL8uQptvXda7bRgmLKcWdWlBP5Sm8PiItjDBuskGP4C34pvd+csWjw/EHorvDXfVTv2c7OxGe94ubJz7F9bQpD+JJo0fOmsnxqBcp6LqMYlhc6UZGVSqel/27R7cvwfN9rLCyFbOJYKEg9GqtBsA3AU9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14)
 by CH0PR11MB5300.namprd11.prod.outlook.com (2603:10b6:610:bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Mon, 1 Jun 2026
 22:20:32 +0000
Received: from DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58]) by DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58%5]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 22:20:32 +0000
Message-ID: <34103d30-acf0-481c-a387-26a9fc4769c6@intel.com>
Date: Mon, 1 Jun 2026 15:20:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 178/272] ice: fix setting RSS VSI hash for E830
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Aleksandr Loktionov
	<aleksandr.loktionov@intel.com>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>, Marcin Szycik
	<marcin.szycik@linux.intel.com>, Jakub Kicinski <kuba@kernel.org>, "Sasha
 Levin" <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194634.287856530@linuxfoundation.org>
 <89da255b-a781-4ccd-bcd2-b2f856a8d7a8@oracle.com>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <89da255b-a781-4ccd-bcd2-b2f856a8d7a8@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:303:16d::34) To DS0PR11MB7381.namprd11.prod.outlook.com
 (2603:10b6:8:134::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7381:EE_|CH0PR11MB5300:EE_
X-MS-Office365-Filtering-Correlation-Id: 5614bcee-576a-4ad0-a83f-08dec02bfec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|3023799007|18002099003|22082099003|6133799003|11063799006|4143699003|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info: Wj4B1QT8emtubvDbQc1NIpIcIR5vFkl1fa5lRB+IOwcDs0K6jAjzrS8Hk0xsih7hMM/xiD52sNNAG9l9SF0OELhWJOeCIlPlKzbwLE0se7qlz2DCgEuy5o8atRFuOM+dd+39UJo7wzEmP6fW1AD+BBrudNHSLWFmjJ6A3f58XTcwcAmzHOr/ITS4XxhWn+837FaZUIliHgY56GH4TJizP7+8+TSnM7xP7Gmldfr/bGBfPW40MrKnaLlZ06BW6xVjoJSVFFIEzCr+wlu6PzEXZb1F1RmggW5Hhc94+gYhCMdQztq59OgNiwXrKHo3uDmo9TN5ZpdZtodnvfwmRjijKo//sMLs2fAp170vrNgRxsgg3SgbiVSfiJArehVIfjUNRG7uoaJ+PqOaTNvKnn8lpIN7ek4at9BCZK9tse9/mvTDj6c3WSeMCQGSd2yPe4R1vSOJ/k3vr1bCVMphZjBJ+YCrpedOtH25ykz7RkGB+upSTFnvuLiq3ib5Q8C9KpWWOp/uht+/kMkAzj15iDh/JqvMZorM5YvFsDBbZkDJG5X+5rZFMnvW44WdUaXjasuGHBZpY1RiUZqwExBcZlw1LbelMd7bASTWMsOo/IX2aoY60rPtT9Vldl2A9jSkh/AULMqp1Dy8Qkf5M7KsfOP9kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7381.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(3023799007)(18002099003)(22082099003)(6133799003)(11063799006)(4143699003)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a043NUtkSmUzdVBsTXlLOFhZR2kxSmovclh2b24rajdmMDUxTTkyclZkYXNp?=
 =?utf-8?B?dHdIMzFYMjFja2ZNa3VJandmRGZyV2s0SE5ZSTdpMTBiYVhoSDRHVXB2NG0z?=
 =?utf-8?B?UGZsMU1DbS92c1RFdEh1c0tKd21DTkVIL0VQWjJZSmFFNkc3VnlwMUl5ZUZD?=
 =?utf-8?B?cHJTNXVqUkhCcFcwM1pHZEx3U0RNd0Z2YmVoTFIzUDNHaElKakpBZTBBT0E4?=
 =?utf-8?B?cEdaV0RMQVFtMjEzMXRkRk0xeDZ2S3lCRXl6YTYvcjgyQnczMFpRRVdLek9n?=
 =?utf-8?B?N0hSWmloeUtnWEVCSTRvdkFYa3VMNVFFV3Z2RkRjbENLM2kxQWZhNzF3OC9w?=
 =?utf-8?B?YkpwZm5kVURDZFlweUxqT3VLdVJRb0JPdUpad1BjWElKWkhWangwQVdzUGhU?=
 =?utf-8?B?V0JZTGw2RXhVSC9jYXpNRmF3eGxta2FsUm5nN1RUQmYyK1ppcVFFaXpZa0F0?=
 =?utf-8?B?dERvY0Nzc0UxU3cvL2l5K3A5cjdTa0VHbk1iTklQTTNGU1VoblZqRmdMZ0xP?=
 =?utf-8?B?cURQc0hVRk9LdEhZRkViS0NTWndBM0dKVFdEV0dPWkl2eGhOYVhOL0pVRHky?=
 =?utf-8?B?dWZvVzM0MXFqNHAvRkFuNkJFMmlWd2xDVzN1T1dCbHc0SGpaTUl0MWE2YWJ2?=
 =?utf-8?B?aDBiZ0RQdGRpSzFNcGNYa3ZET3UzQ1FlTFlILzduamZsN2tjbFNCd0FyY3hv?=
 =?utf-8?B?a0JkKyszdDRxbmxiUXJqaEE5TlZVNm5SdFR5V0JjWEp1dVRlZHhHajNjbVR6?=
 =?utf-8?B?dTRySmk5UFZrMHc2aVRNcjFad3ZhdFpsNDRxL3Y3S1RGM1lmZWx3aDZRZmgv?=
 =?utf-8?B?UWhtY0FaZ21JVVIrRUxWYjRNVUNCS1I4VTNGNEdhUzNFekR2eVFFM2N4bG4r?=
 =?utf-8?B?bEE0eXpsb3U5RUxRRFJ3R3dnSTZlK3lLeExXdEJnYnVPbiswOHU1VVl5bUxH?=
 =?utf-8?B?Z2RoWHhvV2FEVVBUM1hualpDcm1aNHE4Tm41dFlWRzlHdVVnUE9uNmYrY0NV?=
 =?utf-8?B?TmpSNDBHYVFMcElDcUFaY0JHLytwSTEySmpnUk5ZRXB2bFVvdmtFUnZ6NEg3?=
 =?utf-8?B?Ny9XRWxwZzMxS2o3MytyKzMvUUdqeU55elhRc25tSmp5VERIeFJNZUZjMkJU?=
 =?utf-8?B?T3FRT0JTait0SmNCWGRValRsZ3ZoTjQ4bm53MEFpQ1c5czY3c3lubjZvUExl?=
 =?utf-8?B?d2tnRmVIcEJVL05QQjQzaXpaRzFqcU0zSmdtc2llRENqUmhCUExQYlprTGhm?=
 =?utf-8?B?aFVmSThPNlNJeUtYRmpWYTU2dEc4RHRjVVBuVW13ZVVjRGtadlVkVzVKR1Fr?=
 =?utf-8?B?ZVVFK21aUzJMWkFXYXRHWEZ1bUY3VE9QK1FES2w5dTVHQUxoVGthNXBINU56?=
 =?utf-8?B?bVY5YjZzUy9UQ0VOL3NiTXVRSm5uWGZOdVlJOG5tc2xrb2IzYy9YbmVKMXVa?=
 =?utf-8?B?RmNDOHBrZGRYT1NNTk8ySHEwTCtkYnhlQmZObkI5dFNvSTdOQ1Jzb1dmbTUz?=
 =?utf-8?B?MjFZcmpRK0QrMGFiN2pxL0NqQTVGTnJXKzRQMktuTVlEemNoSzJqQW84MTNF?=
 =?utf-8?B?RHYxSzA2K3lsa3BtSlJ0U0tld1NFb1o4eUhEU0g5aXkvRXhXRHc4QUVSYzF0?=
 =?utf-8?B?cDZMOVFySzdWRWhLVGtBOUp0M3IrUDl1Zi9hd2hOSncwUmhGYTZvRmVDZ1RB?=
 =?utf-8?B?NlR4ejBOcUZmUXdGUVBsZ0JjODR5MVZwSC96d3kwSHFnaEk2SUZFTWtQL0dD?=
 =?utf-8?B?K0lnMThPSGF2N3RsMWIweWpjK2plQzFBbjNvT3o3Q0xnOFQ5dUNRRWdseWJ1?=
 =?utf-8?B?Yno5RTRhRVNsL0tpZWNiTUNHNDJnOThBcGZiR2pRenp6VzBBNlJtZ1VFOWFF?=
 =?utf-8?B?OE9hZzIrU2hGdFQvdVVpSjJJb1ovVkM0SXBRTFlQTUxUT1l1dlBQbzBpNkNw?=
 =?utf-8?B?OWliaWJFdnJKNWdUZ3pqdVYxTHJnbHZzQU9IVk83emhNUmVWd3hBM1lsMmpL?=
 =?utf-8?B?b1RKUmNPdXRkM3U3WXJCTTJ0REZoUHdiTjFoQmR2amZ2c0h6cWUvQ1F4N1Y3?=
 =?utf-8?B?Uk1Xc2xDNlNRaVAvbHhxZWF1VTBaYlpMVi9SMFA3VlRDMEdHS1U1V2FldDRQ?=
 =?utf-8?B?QUdJWDdkUlhkYmpDRXNKWlE2QVZ6VFRCQVc4d3hoaEcvSjdyQ3lXUk9NSFI0?=
 =?utf-8?B?ZDFDRTBSRmk0em83RkY4VjQrRjkwVzlBZEZPM211SVdtbzBIN2xyWFBaL3NL?=
 =?utf-8?B?a3ozVkRMR3BYOTBQQjk1WXcybjloblpkNnRmV0c0VDZWRjFnSXVPTjZIM1Jm?=
 =?utf-8?B?Y0pJKzlPekEweWp1dFQ5VWkweUdxbGx4WUhRZ2IwWjJUaWJ4RGRRZz09?=
X-Exchange-RoutingPolicyChecked: N7NOJb3z7078907FWiWIthtpsn+uEQzkZxZg4vFHiSl6SYInIP5FAOZS+ulsqUIlcAsBuu+1qvc+LJIAWRBGUpKIC8ib6zWcuwxfPS4NFA9BYjbA4Pro0co4FJiA8iQxQ/dfz/qfVOU4yTSaIIelnBwMm3Z9ndIi7G8H62WIFxf9FJJB123HPltN1eHwfXI5pjdGHTSJ1GBVFgIcc5PIu6MXE+zTpwMPCCq4YrJdXFHxqH2SBKEjjNBQnRezW9btuAerx/p2p3KB/XxlIdEoLutmugSQVgn8jQbElyCAZqg7Cjso1e2scbOUNsbNCmkIgVi5esj9p7RFhfrLocPpTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5614bcee-576a-4ad0-a83f-08dec02bfec6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7381.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 22:20:32.5303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpp4pFpkHCi38k3C4jx2kmIAaGh4peJIFsCDs/ffzrP4jcmvJjlRrE3L5RxuShftue7/IeB63QFatRgyL6uzaS9WpGKnJAzkeYhr4JiP/D0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5300
X-OriginatorOrg: intel.com

On 6/1/2026 9:37 AM, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 29/05/26 01:19, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me
>> know.
>>
>> ------------------
>>
>> From: Marcin Szycik <marcin.szycik@linux.intel.com>
>>
>> [ Upstream commit b3cda96feb60d91fe88d52b974ff110dcfa91239 ]
>>
>> ice_set_rss_hfunc() performs a VSI update, in which it sets hashing
>> function, leaving other VSI options unchanged. However, ::q_opt_flags is
>> mistakenly set to the value of another field, instead of its original
>> value, probably due to a typo. What happens next is hardware-dependent:
>>
>> On E810, only the first bit is meaningful (see
>> ICE_AQ_VSI_Q_OPT_PE_FLTR_EN) and can potentially end up in a different
>> state than before VSI update.
>>
>> On E830, some of the remaining bits are not reserved. Setting them
>> to some unrelated values can cause the firmware to reject the update
>> because of invalid settings, or worse - succeed.
>>
>> Reproducer:
>>    sudo ethtool -X $PF1 equal 8
>>
>> Output in dmesg:
>>    Failed to configure RSS hash for VSI 6, error -5
>>
>> Fixes: 352e9bf23813 ("ice: enable symmetric-xor RSS for Toeplitz hash
>> function")
>> Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-5-
>> a5ea4dc837a9@intel.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/
>> ethernet/intel/ice/ice_main.c
>> index 2a629b9a9e03a..664bedfbd8054 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>> @@ -8108,7 +8108,7 @@ int ice_set_rss_hfunc(struct ice_vsi *vsi, u8
>> hfunc)
>>       ctx->info.q_opt_rss |=
>>           FIELD_PREP(ICE_AQ_VSI_Q_OPT_RSS_HASH_M, hfunc);
>>       ctx->info.q_opt_tc = vsi->info.q_opt_tc;
>> -    ctx->info.q_opt_flags = vsi->info.q_opt_rss;
>> +    ctx->info.q_opt_flags = vsi->info.q_opt_flags;
>>   
> 
> 
> I ran an AI-assisted backport review and checked this against the 6.12.y
> ice driver. I think the E830 RSS fix is incomplete on this branch.
> 
> The backport fixed the PF path in ice_main.c, so 6.12.y now has:
> 
> ctx->info.q_opt_flags = vsi->info.q_opt_flags;
> 
> But 6.12.y still has the older VF virtchnl RSS path in ice_virtchnl.c,
> and that path still does:
> 
> ctx->info.q_opt_flags = vsi->info.q_opt_rss;
> 
> Upstream has newer VF helper in virt/rss.c preserves q_opt_flags as
> well, but that helper/refactor is not present in this 6.12.y tree.
> 
> See commit: 3a6d87e2eaac ("ice: implement GTP RSS context tracking and
> configuration") which is not yet in 6.12.y
> 
> I think 6.12.y needs the equivalent one-line fix in drivers/net/
> ethernet/intel/ice/ice_virtchnl.c, changing q_opt_flags to preserve vsi-
>>info.q_opt_flags there too. Thoughts?
> 
> Maybe lets drop this and backport it again ?
> 

I think you're correct that this won't fully resolve the issue.

> thanks,
> Harshit
> 
>>       err = ice_update_vsi(hw, vsi->idx, ctx, NULL);
>>       if (err) {
> 

