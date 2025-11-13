Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D15635CBC3
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074075; cv=fail; b=JxUTvDn6tpv5rN9lpIg/7sQYGTuTOw+EPO6QGENoqAvX56Enmx8ttlA0C0qVBrjGIyMIN2rFiOBO8EOHfrbT3FEdtUqHgVEVEk1pFyHC/3hdHlYVXyniBuQfWNrRC2VuZaWGVxYonW7ar2ol9KYLgqYFXqrayGlUVesOH5YX8zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074075; c=relaxed/simple;
	bh=YEt/hfNaZWDxOQGqM4R1QDcgYCakixm5c8hekZTJsUY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nDnSmbwVH1FimJozlHcQD2KdRdj32Ao5JQggd80xozvMhNpFVT80ItMprG0dnkM8gRocJWgQSBYAkwTPECnU5uWuwLaRmFmnXXLHj+vP2I12tgGP9mdF+/SX8CCATXmcbOkGbBLsndPOVg3tvkPdERfB8LpI7NTSdnrQy4XE2cQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRmg8e0K; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRmg8e0K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074075; x=1794610075;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YEt/hfNaZWDxOQGqM4R1QDcgYCakixm5c8hekZTJsUY=;
  b=bRmg8e0Khp5Or7GAvNu08/tgyHdO3E0Wa4yHXM1iZvYLRzXkZFfQZJCT
   uUXUObvZiw7eaeQsw/tQvUidpT8kmUA0zsPvFIEGILBvHe+beZSxNUhvN
   FyRAamH8yREJ3Fase/VbmIJOqoAdgPnUqXIx2xDB1aYf9E6s4e+SldKDE
   8yjG+LF2vzWUTya5zigIfXPiJOJK8bycLHQ1G59gJ8T9HLr4ZvawKhOF7
   LSC+CEcxuVql7xZhb5ngHrQtIfVTT6K+BGo7yRAdLPle9JJv6a1KRmOzv
   TM+5yviztMwSVCeNw5WN2XMV2H5HdZ09+xAfj+ASaa9vIQTNB0SI/PCoW
   w==;
X-CSE-ConnectionGUID: c3ne7vafSLqD2CNTbZcWFw==
X-CSE-MsgGUID: QwWUAj+QQQm30CdXasCIhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76627114"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="76627114"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:47:54 -0800
X-CSE-ConnectionGUID: rdrTi5klSNGpRTGLSGwVWQ==
X-CSE-MsgGUID: IIU+7ndrTZG1x7tjUYU2mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="213026753"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:47:53 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:47:53 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:47:53 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:47:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3zS5mu9Q985BSuT59E/WCLsqSzOmIa7iokQ45DFTfE1F0WpZRbYHgu6B4VN6+JF1OE1HRg8NH9KnL4OJ0G9AVoG5Oe9IweAt4wTQ8LA2UoWIf6mLDxtNFMjYKrE/bmAltKAafrwXdD38DtrbcGkhYbiVsop3gxqq/Tx2gASAPjTmm35XmcXtc7AMK6z6qI2sek1iDHhpJ4PiGWk9mY1++YQkNdBW31b9uS/Bc1Wm7Ipu3faCPlwrE/X6X9fYtIlLdFcV0uHJYFYsX3HtWiN0pCsgbAo3p6cyZGF+o7Os7EnYU6m+pZ2hymbCdUaZA05XLsZXyaTWVnnrogKcISG3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCMLld/IyamjFGhrp/k+Me6fvSzOH8YEzFdug2dEz8Y=;
 b=K6zaw6TJL5QSHxVO3AYNdrT15+pHPhYcDrgaQwYlaLrUb5P2OFnsvkoC/NcOIwNDQjXl59gsav4rHm89eDn6zPQFmSLqBElbzmcOCJdsoJZPRB3y0nRCymCiavOfrjlt8VrweCGy9KSpUInuAF8xwhlKIBzQ+tOPTwQRfOIXxNekP+bRA1LYNyEMaozFx0ih5e0Ql/5bxCZF+EEmyqXLRI8dueVeOGZBq1hbUsWy8Ng3Ueq/KLrti7y27ktGuAC0XPQOHILiUHg4O+LFPMsPGwEAWlVypxbcMlkLuxS9iWHYzfRFLTHs9AhJHUijzweK/18rW7ZAq1LzTY2tvcqOvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:47:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:47:51 +0000
Message-ID: <a7c3bf62-2356-466d-a95f-8b17ea98e3b1@intel.com>
Date: Thu, 13 Nov 2025 14:47:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 20/32] x86/resctrl: Read telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-21-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251029162118.40604-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: RI1P284CA0123.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:10:157::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b22d78-dddb-4bd6-7d35-08de2306acf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OWxFNThuSk1Xb1B5YzV5dVRpVTJ5RFFvaDFRRXZKcStxSmZiandvU25IT3Ns?=
 =?utf-8?B?RGFwQWZzQzJkYk5DSFlON1NPZk5tdW9jVk9SbVpmMEdjQkQvZUFFcVZTYnZU?=
 =?utf-8?B?WUpNTGNTQm5mNXhSMnpwZk5nbFB1YktaZWlia3hlb1l5aEdiTDdGbnFkUHRo?=
 =?utf-8?B?cEU3YU9aMEdXUzVqZnI1VGNzY3RONlBicXdDWmgwUHQreTB3cUdBRy9vQVQ2?=
 =?utf-8?B?OVRNRVB5Z3dKUXJ2cU1vT1loZ09aT2piTGFwS0l6OXhteGlyUWNjZjJUN2dq?=
 =?utf-8?B?TVF6L0ZPWXJSWVdIUDRBa1NJYWdoZzJjNjVtRHFtY0ZyT0tYb3h5bXRYb1Bw?=
 =?utf-8?B?T2dsRUJtemlnZ1Bnc1pwR2dXY3dCRGJDZGRqWjZVQTh4RWwwUVlpTXZLVm9s?=
 =?utf-8?B?T2FxQk1HWXBSNWlUU0hQdXgyMVNJTGJIZmwwZVBxZ0pxZnVTWHVUeS9pQnZy?=
 =?utf-8?B?OW9YV2p2dys4NTQ4RThaTjBTNU1JMFQxelZyM1pQZGxOTm5kWjdmaDhNYWs3?=
 =?utf-8?B?dWEzbjFxSzhMSk9NQndUVWJ0RGNFWHN6dEhTeFZrZTd3dlFZTGIySjl0c3ND?=
 =?utf-8?B?VFBhamF5cmFNTUhHYi9sdW9tV3E0REZoZlh3VFg4dmU2QmNKWXNBaDJ5QytG?=
 =?utf-8?B?SjBPelhzZVptejhDaWRVdmFpRVB4c29tT2szRmxZeXFQNGl5WjVyL29URnJM?=
 =?utf-8?B?di9Sc0lpOFZtdFdzK0g1a0JhUmlhUVJWNDZzenVDTVoxcFlPK1Znd1NqWG5T?=
 =?utf-8?B?a2psaVZaZ1N1M0FXMDJjWWhubnU1WlpkSS83Y3pmZS80bHNINHVtckx6VlAr?=
 =?utf-8?B?bmJHaCsvVFBFRENpLzBlM3FIY0JNWlZXV0pJWUtGRFVoQlFWZlNlUFlvQkQ2?=
 =?utf-8?B?OEFuSExBTVRVWHQzTUtITC9SUFlIOUMxSGdSTHJYV3NsbkVORitUSkZiQzB2?=
 =?utf-8?B?ZzR1VUxlRjJ3MmMvcDM0Y1paVHRMeGUycXE5ZC9IaTZnck9GV2xOTkxXUTJu?=
 =?utf-8?B?Z3g0VVJYVWg3MDk3TzVSemx4bzZIdlE3VTduVDd2OHB4ZUVjeUJCeU81UmQy?=
 =?utf-8?B?ZmhzenRJYkZOWVp5VXhJcDljODRvdWZDcUpIaW9GclVJa1ZEdUhPMGg3VzEy?=
 =?utf-8?B?Y0NTRVAxOHloWFNaSG4xWDNEOFpDV3ZmVVF1TWNDWnNEcEFxQmMxcGNlQ2VO?=
 =?utf-8?B?bzB4UEVsbkx3M3IyZjhWZUhldDllOGtBNDZmSW1ua1NCeTQrMEFIUFdpVHBN?=
 =?utf-8?B?TXRMOE0zWnYrQWhJOUhvcmM2Ymtja05meWhBRkErdnFxbnNxU3BORzFRYjNB?=
 =?utf-8?B?OXltS05xcHBYWnpFbytobSsxMTF1ZUp1SnozV1J2WU9SNlRwWTljVFEvWmNm?=
 =?utf-8?B?ZXFQSGRtMkRxbk5ocmZNcVJnalhUWS9aS0xxRkZBdjRpUElWdzM2bTZ2ZC9t?=
 =?utf-8?B?NWNzN0dnYmRMSkRIbzRSYVAxVEo4MDBKWktIVHhFcEhWc0ZRck1ScDBRZkxo?=
 =?utf-8?B?MmtvQlE2Vk5HcDB4cEttV042T2RFYlkxdHFjQVNLWklMYWxIMjU3V2FrbCtD?=
 =?utf-8?B?YjJUOHhuKytqbCtnNTRMVXF4eGlsUWd2NmpvWVhJVXJ5RTl1Zk9FMWdhdVUw?=
 =?utf-8?B?SEdtSTRvK1p2NUhsd3FiUWY0RUhjdGFlWlFyZGJRRUd1emxZVHg1akQyUXc4?=
 =?utf-8?B?K0xoellKek1UMUVrNUZjdlppNXQ5T3VPY05NQlFzVG84RVRzUmdZU1JqTGxh?=
 =?utf-8?B?cTdOUkZPWjFzdGIycUtucHI4RXZKTVlYNmJnbUtpdXR3dGk5dytkMUV1L21v?=
 =?utf-8?B?cjRyM0pvSG9TUi9GbzBQK1Q3RGZ2Y1NGMnRQREYrYnhZMzkvWElHT05kZVo1?=
 =?utf-8?B?SWlhaGtQVk54bGd4eitCR2loYkhHWmlneXlOTk5VWUkyalpzVlZLU0cwVlRR?=
 =?utf-8?Q?aAFIViSym+jZhEzq8mafp5Sh4mHZOSpW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUpTdkNoYXRadUQ2MkdIWHFVZnkrTjZ1THozTmdRU0h4eStoS2crK1kzdGJR?=
 =?utf-8?B?d1FOdjF2dXRxdmFqdXo0MndCa0l6Nmw1MU1KSlZ4TmZEaUt2NkdvdzlZaWow?=
 =?utf-8?B?YjJGUnRNbTk4OXIvazg1dG91Ui9BdmRsaVdja2FBTXZXV3hZMzNYTzJuWEpR?=
 =?utf-8?B?Y3RmSEM1WTRaaE5FYk1QMFZ3dUg0USsrQ3FYOG8wTlpjSHZ4Wm9oQWtJUGdH?=
 =?utf-8?B?M3RMMkdVVFhOYXNtTEkycUNVbzZERHc3U2FwbjZJMUJEL3ZFQjZ2VDMxS2V5?=
 =?utf-8?B?U2hFMDJMNUZ0OXl0N2NnQkFBb3NuNUdoeHFXMXdTL1Q3Z3IvS1d5dGs0cjRG?=
 =?utf-8?B?aWYxbWtqMStBV3JsUmhXR2tpQmpRS2IxeStxVldVc3VLQ2RoU2F1QkFzOU5K?=
 =?utf-8?B?VnZjeFBnT0d0Q3FBa1ZsTktuV3RBUS82NXJocDQ5WDcySERGTDExNjJETEFa?=
 =?utf-8?B?Ym1kRjRrOEY5RzNTOVZ3OWE1ZDVLRVRtaUhOWENEWjlWSlBtcEp0UHZYeHBa?=
 =?utf-8?B?N1FkTkR6OGRMQVZQR0tvWnY5dTdXbndxWjJsaUx2YVNOQjNsb3BJMThnUlpt?=
 =?utf-8?B?WUk0aHVuS2RnSEM0L2d3ZW8zb3ZjSFhHNFBuODVWWkQ1VnBiMFNZV2NPZDkw?=
 =?utf-8?B?ZmZ0Z1VBKzE5ZHBXVU9wYjJNNHE1L3VlUWNWT29YcmRYTmI4VVpZMUVjVWsw?=
 =?utf-8?B?bnJrSlNTVDVtYUt5U2U0UTArS2YxbFUwVVlZVXlyclU5UjJ2eENFTXQ3ZUtL?=
 =?utf-8?B?U1orczRkVmtWMGxzcFpPOFBQWHFTNVVjU0dDNHFhSnhOY3ZDR1JEc3d5SmFM?=
 =?utf-8?B?Tko0VDh3OXVnY295TGNoUTVjSE53eWtQS3k4bDFCaDJKTmpLdTlaaHVUMHVX?=
 =?utf-8?B?Snl5VmZLa2RpcEx6V2lDM1FqL0N6M2NDTzFPMnVER1lTRnBGZm92Qi9Zc0RG?=
 =?utf-8?B?UXpDcUpJK3ZpNVplMnltbzVsMVBIOUJsU05pUmVlb2FxZlNZaCsyVnhwSUJD?=
 =?utf-8?B?Z2srdlkvVC9HZk5lMjBBa3dLZEhmNmZmZTJuSVZwNmlSa2h4RFZ2WkpkaVgy?=
 =?utf-8?B?RWIxVjBnMUk4bm1KYWxZcW9hVDRMWUJBVC9VSmhXSWpiWnhIWkRwUUFvZnpw?=
 =?utf-8?B?dGtwbGVyTVMvbzhTRmQ0T2FKNk9QL3JpUlBmM3BZY3RpSzNSbFp2YUYwK3h0?=
 =?utf-8?B?L2NscC9IaVRZRGFROExTaElzZ08yeDM2NFhjZExUZEdCUS9EME1vLy9ScHh4?=
 =?utf-8?B?S2NwejdkbFNOSnJqY3RkTVNQMEt3SmFZSUg2Q21OaFdjaS9FUWdaWEs3WjRi?=
 =?utf-8?B?WjlmNGtGSlgrbmMvbEhGd3QzRVN4MTh3bC9EYkxBSHJRV210NldJcWJOS1NM?=
 =?utf-8?B?QUQ1R2Y1c3pZMGpmYXlDRDhub3k3SVhDWGNXSmg4dTNmWVdXVE5ac0NvRnNm?=
 =?utf-8?B?cGdjVnBxZlpua0w0Q2lzYjJsTWdRZ1liS0JONjY2Nk16bVl2WnRJNjhpSWhj?=
 =?utf-8?B?SVRNS1Q5YlduaDhxSmtaMXNtKzBSWGUvcDVYUkwxOEVLUEJlV3ZvNzd0Sm5r?=
 =?utf-8?B?OS9ERkR3NC90QlhpU2srSWhpRFRIaWRUaURFVnk2a3ZITS8zeWNoUjBOOVZU?=
 =?utf-8?B?T1d6NS9YUW5BdWd1UjhOQks3TWVRNkgrK3JIZFJuVjlLeldEWjRZR0xrbkVP?=
 =?utf-8?B?YS9DQ1hROHBnZmFsOXBnWDdRYzQrU1BHWWtVeXBhNytadkJ6NElFZXZwTDlk?=
 =?utf-8?B?eW0wQVhVdG16VzJGeEVCRVY5VUYwRjMzVFRNYW1zZW16ZlI0VElhRHBlN1Zs?=
 =?utf-8?B?UUVOU3BRK3lKZ1YwdkFOcmZ6bS8wYjV0NHlGZnFDZlo5bjZPbUFWUTArdEJK?=
 =?utf-8?B?SFdXOUpObzk0M3dzazZOOUsvYnJjWklBNFJvZGFZeFdpcW82dS9yTkZoaVpK?=
 =?utf-8?B?cGh0WnZzOFdvN0FLb0xBek1QZnozQmZFT01adXBpaWFKT0pNL1NMdStHYWpz?=
 =?utf-8?B?Y3RraGtwV0dXeXBaZ2ljYXUyWHAwRzBkOWQ2UXlLRFdFbXFmajU2Y3NGYVNM?=
 =?utf-8?B?UGdTdUNJc3RZODBKRFZINEI3QzRzN21xL2o4YWxsZ0hlZGhmQTNGZnRmUllw?=
 =?utf-8?B?TlJ0VHcxb3F4TTJRVXhvekxxZFkzVUpXeGhPSllMS2dTN0pQb292UkVRRlhC?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b22d78-dddb-4bd6-7d35-08de2306acf3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:47:51.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIHxLuOhYmAweHL4/AM0C2EfumPGOKIuWabM+CnWvf+BzyCstreVY92ic+jAUuX3hG4ootOC02m50ixYLMifhSHhn7VCJPa0DCMP8Ymyx3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> @@ -217,3 +221,51 @@ void __exit intel_aet_exit(void)
>  		}
>  	}
>  }
> +
> +#define DATA_VALID	BIT_ULL(63)
> +#define DATA_BITS	GENMASK_ULL(62, 0)
> +
> +/*
> + * Read counter for an event on a domain (summing all aggregators
> + * on the domain). If an aggregator hasn't received any data for a
> + * specific RMID, the MMIO read indicates that data is not valid.
> + * Return success if at least one aggregator has valid data.
> + */
> +int intel_aet_read_event(int domid, u32 rmid, enum resctrl_event_id eventid,
> +			 void *arch_priv, u64 *val)

Is eventid needed? It could perhaps be used as a sanity check of
pevt->id but if it is not used then it can be dropped.

Reinette
