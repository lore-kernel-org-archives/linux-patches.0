Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD844246794
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099868; cv=fail; b=tElihZor7kNZ2NOWbDkStWBgZGE7f1bGSRAREKWRvdIhXWFPfjpgJPABypKM9Ju/yY4Uic/7+NsacZyuw/CsIDaXshlICTu3QF8Vn/IlJD6wIThsTYA9RtHEyvUv8o6kBG7aBrqMsocFgrcuBYeGcreX1QQXgsd+CCSdb6dudW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099868; c=relaxed/simple;
	bh=iivHZiVpizvaM/YBeyp1g5p8Jfx/flwErEGNk3LMGnw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ECH8WqAQTPiImJjoiwihKQpTI8LTZzHbHAeS5jq1abO30p49yPNu+1j3O3ublGn7PhNHKYKrtpW9IMneVTbNcf2Z3FkY1xKoVTAoncX5L2JsvUpEmX9g6bFItbJQiQbM/PwFeF6dqC3OsrbTFAb42Qcu6tSq0UtPphSHUcy/Jo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwbPCX/j; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwbPCX/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099867; x=1783635867;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iivHZiVpizvaM/YBeyp1g5p8Jfx/flwErEGNk3LMGnw=;
  b=CwbPCX/jdlZwyt6v0z/mDsOlmC+myQhZCOpci/QPac66QsaJGnONY9AH
   55aC1y3j4KXE9M6T3rCxJmXLDLfwgprwJS7g0StyeSqgqAaLKbvQAQr2t
   5d8m9JXHGzjAtRlpwTf2XH4hgs+ZMiAse6IhKzRkS+bG73cPMqyIQ9oBb
   l6qkxyE8HIE5trYqLQpxd6SUMrJ5PsMbcgknYA4wIzIC5Ay50NtEwDlrY
   dy7oCaC02zigX+4OH206vbQJwUTAy2TfXDNFVtEc8efsPmimayGidor47
   JlDx9YPzsf3A9hVkpoWhj+c23EDrsIIrkVkGthwSbwaRs/jzPRC37K8zH
   w==;
X-CSE-ConnectionGUID: P3Hn0pleQIy0qVB+Lnqv8g==
X-CSE-MsgGUID: PFntgveuQ0+U2dnTTRRoNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53482329"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="53482329"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:24:26 -0700
X-CSE-ConnectionGUID: kVspz0RNS6WmQRBFAHhxkg==
X-CSE-MsgGUID: WbY3GTp2RauGtE3JcQw/HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156228954"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:24:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:24:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:24:25 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.50)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:24:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avv7kIJUXGuJtGaGHhNaC/6Afs4ylrwdDmHFKvXTCZ60bOzak7d3h1W98iF1gaTgxGBzHaUhoPTIujbwDbKVavHXfqEMrUdoI0PplIkD2Xgb9FM37Juk+gA1n1aw6RxgTrpXSA5Vcx72vWRjq1my4M5j6bzePXB/zymQ+PbbU6YfI8vUhby7+FcG2equ1mDZXiIYh/G8DZ3TuxtTopVIs4YM1wJQtgx39kT4HsCAnF8HbKyO5jtWkd1jl0ob7y1ZMim85dYO60hQJNzfCUcB0/V/oNgkJ6Cp9qHJIZxMwLnaI5LFN2OBnduaPyRMdBsnlTGzKsUZ7IDcswICNWuL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLOI3FvuIpkoKt1lEfi65KhwDHZ7MJ75sym8smsKfzE=;
 b=q5BlJ9irGSr+brW9FCNLBPTNp8oUS6eTPCRF2FnT65M6dTnhIHXyiuOOkOH0+mRhEVAAdZVlE3gKcx+X9bIlseFiUhS++24LINrxJGXw8DVSVi//XlRc6P9OjmjtTYaLBEgItTYIeqYXkrkGIp7pv4GD5iij3pZ5gZ5ijyjSDucfuRUhJ9zI9Ldotnf/nk2UD0av7OMWSZvDPzee0n2zbX7AnB22qVBOZEeG72SmO5FtPT4DWEwmjI0bL+r2rMUKJJmNSAzXL9ZGMsmqzmFRvGP3wT82h8NEirkUWdVmIdsLOPEuyQsB7f3E33C2BmLp903IMHZlwlNG3YkcLNYibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 22:24:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:24:21 +0000
Message-ID: <b5cb1b8d-3f42-4d23-98a9-27fe4a263858@intel.com>
Date: Wed, 9 Jul 2025 15:24:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/30] x86,fs/resctrl: Update Documentation for package
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-31-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-31-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:303:dd::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 475aa052-2ca6-4290-626c-08ddbf375a1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M0N2SmNxcWRCQTE2MGg4cDExKytkVjlYRE9JTnNLNmZBSHNuUndvd2k3bmtX?=
 =?utf-8?B?UnlMUC8rL2lSSnllUmpxTnMxRm84YXdNZjFHdmJyQlV6cW5vNzQ5TUErekZ1?=
 =?utf-8?B?TWxSYTlNUUs2bXl0VHdXOEJ4TjJpY01FMWhidldpWEozT1EwNG4zYkJ0d0hx?=
 =?utf-8?B?ZzlsclZuRVVQakVxTkdDWDNKTlVjNmF5Q0lvSnk1UDhVaUpJZkxwMTBkVGtm?=
 =?utf-8?B?OVRlYTVjSDNLODJkTnJ1U25CRlhtK1FyYU56VzlHbDRxYUtNai9lS2ZIc2pu?=
 =?utf-8?B?aWZBSFlLeGZuVzJLZmI5cTQrMHpNdXd2dS9UY2lReTNMK2Z3YmVwR2ptTDZL?=
 =?utf-8?B?ZHRqTHRtQWhhMmJXNGlBV3VUYTVJUVUrY1ptOEJXUkIvdXRtNS9qVHlPcktj?=
 =?utf-8?B?NEZESWhwVlRsQjN0Z3pCSzVhNG9FcTB6c0YzeTlVbFdna1cwZ3FJU3hRUU5w?=
 =?utf-8?B?K043TzBXRFI2cU5kZzdCMFF3MlJMTXc0ZmhrRzVrRTZOcU1JUUFGVTZUamZV?=
 =?utf-8?B?aS9aUDBqd09IcmduUnhTQ3VhK0R4UVQ2V0x3SDE4cXNNLzIrTDV3S0J2RFFy?=
 =?utf-8?B?THhmNzdTSkZHMGkwUExEYWJPSXlhV3lXMW92RjIvVVplOHg4WWltUHh5Y1ZW?=
 =?utf-8?B?R3JZUk5xNDBpUGpTK01IeElXRzlkRTB3MU1FQlVqZlMzV29pamZUL3Q2NlE4?=
 =?utf-8?B?SjVrQ1ZIOHdhaWRUcmQxQ3VkWVZ4UUdQZ3U4ZVpYR3RqRmlPdFNBNStaR01w?=
 =?utf-8?B?WEJnRWg5U2NIQmFlUW5acVR2V0p4eFRIdkRmQmljYUYvak1xTUd2aTZJMnk5?=
 =?utf-8?B?NlNzYkNtN2RmNEFGaDVUQWUwdXNydTFHMWVtaisrZTNPU3RBVkFnbkM5Nlo4?=
 =?utf-8?B?RkkvT09XdFltcHNsSStmSkRUMGREMjNVMm16YVc1NjRaeDFSdXZ5MXRkZzBv?=
 =?utf-8?B?SXJqZ2JhQWxDU21LNUdlUlRsai9EaGVrbHF0ZE5OU3hySEgvYjFMNUJNZFhm?=
 =?utf-8?B?TnY5dWVVY01PSHpCZ1Jic3E1VGk2ZUwwUHhkbTV5WnNrTG1qR1BWS0xwb0NM?=
 =?utf-8?B?SXF2SFdXUmIxTU55MWp6OGlnaGdlbHhiTmVxS3hCVUtDdTVYRUE1ODFiRzFX?=
 =?utf-8?B?WC9VRW1EeklzZURlRXRXZndwU0tsNStsWUJ6WnZnd2JiOHEzcktzQyszVmox?=
 =?utf-8?B?OUsrczNYbnhpdEtvaHFkME9DSWdMRGd1Y2w5M0FabFVuK2N3MW15c2YvT0Zz?=
 =?utf-8?B?OWtFOTJrLzJYOWZHZGIxbEd3cHRORzh3MTkxVFdzd1hETDZXM3B4aFplT1Y2?=
 =?utf-8?B?bFJMdHd0U0lzcEh1dEdHTFhjTmhkU0JjMVBHTUlGQTQ2S3NwZ3ptZERuRGNL?=
 =?utf-8?B?VDgzUTQyVXl5cTFOOElmaXdxdng3L2w5RkJzcHg2NVpEL0N4eWxlUWt5Mk5q?=
 =?utf-8?B?VzZielJJdGpTOWp5UGRsTkdZY3grQ3czeUFXVm00eldwNzlrbFJMYzF5aXY3?=
 =?utf-8?B?Y0tzRmlwSnE5T0RnTFROM21WOGZBVm5xNnRHM2ZpN3pqOUNCdWIxL0x4VTV6?=
 =?utf-8?B?U1RIVUNZbEZFeStFZjJpcmRoZUtlNlZXWVU0Mmg5MFlkemE3bXhoRHZWOGdG?=
 =?utf-8?B?TlpoZHdzM3pQUGdJTlhrc2tRbW1HR0g4Nlo4Vk5IMTh5bkZVK3VZL0tGdVFo?=
 =?utf-8?B?OXVTckJleU1Hdnd1emw1azRSL2JRUDU0b0RjeVluY3VtTXE1RXpzUGtHWUFz?=
 =?utf-8?B?MHM4OEM0UGdVc0VITjZnMXdmR2RwM3Z5Uit6ZWRBSHFvQm9Ja1hrdzNSMi83?=
 =?utf-8?B?QVBoRWhXN0Jpcm94WUt1TCtPMG1rQWsrcmdlR3M1Y0tvYzdaVVZGQ0dIRk51?=
 =?utf-8?B?alJISWpLWjM1UHYxdlMyeng5Rkp3OHhmc3VmQVM2UDh1TTQ4VFlnbG1xYm44?=
 =?utf-8?B?TVpUdU9jWWE3Rk9wOEhKL1lDdHNPc2J6VnVYcTdrMWR0ZjEzTnJ5QVF3ZHN6?=
 =?utf-8?B?SUwvbWpQRHV3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlJ6UWFKQVRhdDJCOEQvWHhVdkNCTTh6aG9yYnErRmlhVFFwVEFsNzhxUnl4?=
 =?utf-8?B?NmdmTjBTRFl4M3c1SGRBcmVmbVRzYXhmM1NjNDhtMjh2SlNobW9GRzNTUHBq?=
 =?utf-8?B?MWczS09jR0VLc1k5TkY1bk9TbE5RWDZtWFhyYXErSHo3bXVPaEtRSkMyQmVP?=
 =?utf-8?B?dDgydXFOdGhxT0hYd0cwcUlJM0tnR1lpdnJFQ3pJWDlYWERZUXpleWJMM1Ri?=
 =?utf-8?B?S2FCVmtiSUZPWVlFS1ZKYzZtUExqaDFScU1yb1crZnBGd0J0bDEra2h2d2Fw?=
 =?utf-8?B?ZTFsUDhncGlKZTBQRm5SM1haOWJiOERsYkJtaU5UVWlySkZyR21kd0NSeCt3?=
 =?utf-8?B?dkZOem41UmljK1ZNVDZhTWtodFFjdXF4VDFqSXBlUWdRdUtsOFF1OEZZU1pN?=
 =?utf-8?B?blZlZmZObUovWEliQjJ4QnBBaGpvbWFDckE1aFhGM2VzVklHQi9laWJqUnlC?=
 =?utf-8?B?S0o4c05pTnRzYllVWjErNFZkakdxcXIzbzdFMnpUYy8xa0ZVNTVEb1MwcGVC?=
 =?utf-8?B?QlMySE5hKzFjZjVKNjc2N0VoUUdadlVQSXh5c0FEOENYQWxlUGZnZzFMSjl4?=
 =?utf-8?B?eThIdzVoK0YvZmdXc0hGZm4yb2tQd1NpRTl3ZjcrN2lpR0pMd2s5aERGR2E0?=
 =?utf-8?B?bllxNW5YYkVHMU9nb2QxQlRaTE1MYmFFTXNlQ0wwVEJBN04vUG54ek9QRmxV?=
 =?utf-8?B?eHFVZ0ViWnZxRFBYbzBrUzZUREhSVkZXY2xXeDRNblNiS0FaNEVBNXdZck8r?=
 =?utf-8?B?d1VxWGV2VCtnS1JEbHBBV3pHdzdhdkl5aktoc3o0QWpXUjIxdjFkYTFRdGZj?=
 =?utf-8?B?QmJoVGVVSE90Y0N1TlhBSWVla1lMeGtXdm9VR3E3eG5xWmdueXA0NHZ1SWZO?=
 =?utf-8?B?ZGNBKy9ZMERzaU93cEJSOFI2cFpxMTI2cnR6ejVzcUZaaW50UjNqVVlYMjht?=
 =?utf-8?B?eVRtNHBna1dyZ05QMTNndGVCZkJmbXFjRk8yakIzZE1MQ3NBSEk2QXNmOW94?=
 =?utf-8?B?NkV1VC8zamRhcjZzdFBrTUFXVU9Ldk1ZNSs2TW9nZlVWZkhjSDFGT1lZODRI?=
 =?utf-8?B?UDhXQSs1WVU4ajh2SHBRSFpzbjNSamtJWFl0bzNKeFBwWjJYV2k4djcyYnMw?=
 =?utf-8?B?WHkwd2VuUE1TT1RhTzgzSnU0OFFXbkExVDU3MzhESHhBcjk1YTFNU1ZSaWZK?=
 =?utf-8?B?TDhFcU9rTmFFdDNVVGpIMS9yMDRiYVg0dUVPbko1WWNaK1FOcFZqVU1LZWda?=
 =?utf-8?B?OXhlSTYrb0FjUCsxcmFFWUJMYmVVaFNsd2ZTdnJtNkRMVVFpcU9DK2kvMGxG?=
 =?utf-8?B?TmF1bmhUVnFxS1gybnhNdUdzQ3BBdXZWNUgzZ1UwL0ZkdGxmZDR3SFYwNzc5?=
 =?utf-8?B?Y2RGMisrK1RPMktrNEN1L2prbFdEYXkxaEhTRmRyZUZsN2ZiYkNpbnYrWUJl?=
 =?utf-8?B?NjRwdnh3K2F4MTc1dnhVK1ZyQjlMQnZpRlNRcHJwUGxBVTlNR0lpMnRNSGFm?=
 =?utf-8?B?dFJxM1AxRXdJeEFESUtzeXl5YVduQ3FkelRoVkoyUk5aVk83em5VTUNXUW8v?=
 =?utf-8?B?Ti9TTWVuRHVaeTZFVFY4WlZIc2xMVzcyOUZiNEFmdXF6Rnh5K3Z2ZTd3MkI0?=
 =?utf-8?B?M3Vnb2xCZEdyLzFiRGRjaCs2Sys1U3A2akFTd1RocWJuWlZpbVJORHpCUGRz?=
 =?utf-8?B?dXBWdENKc3VqSWFSVEljcjNjazB0c3dnakNXR1oycGtRYkYrdkVpK1QyN0Y5?=
 =?utf-8?B?NlNEVHNwMGVRY0p1UzFaczVWaldHSGgrQmhXbC9BTWFkU3dWU1kwUmxxVS9r?=
 =?utf-8?B?ckIxRUhlTmZaQzVVQWlYWXhFWUVLd0s4YWFGa2hCcmJnNmxlWEI5NEpUdlJk?=
 =?utf-8?B?VFN1cHdKODdXUXMyUFluVXRzUWFObmRnQVhWTysxOVBtcVF6VDNFWnhHMWs4?=
 =?utf-8?B?dExpTkdJN1FEYjMyT01xQUVhZjdDUTQ4bkNhMmVZVDR4Z3dUclUrMUh2WFMz?=
 =?utf-8?B?YXd4Zjl3RWJ3WG9reFV4bDYwdm51dlZqRnNZSnlQSGozT3NSNW1vYmRaN2Qv?=
 =?utf-8?B?c09kMDBMdFdRSzNURGNMMk0xWmtOYTVOQVgySnBMM3lXMFFUTEJXMUlsWjUv?=
 =?utf-8?B?VUZXQjFXVlIzSVBYdXZJcXRuU1pLMzByTWtZVkRyaXcxZjBSZlU4TjZXTTRa?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 475aa052-2ca6-4290-626c-08ddbf375a1a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:24:21.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2nVK1cwhv+Ua6gISfo6BTtxSe0o1R3861pVWix7MBkh3+IbiE1C9uIl+DInFdA/XlgRa/8ctMPS9SXaTl7sLaQyFxe6nIHJ4d0o5aUuHcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Each "mon_data" directory is now divided between L3 events and package
> events.
> 
> The "info/PERF_PKG_MON" directory contains parameters for perf events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 53 ++++++++++++++++++++++-----
>  1 file changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index c7949dd44f2f..a452fd54b3ae 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -167,7 +167,7 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":
> @@ -261,6 +261,23 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of telemetry RMIDs supported. If this is different
> +		from the number reported in the L3_MON directory the limit
> +		on the number of "CTRL_MON" + "MON" directories is the
> +		minimum of the values.
> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
> +When the filesystem is mounted with the debug option each subdirectory
> +for a monitor resource of the "info" directory will contain a "status"
> +file. Resources may use this to supply debug information about the status
> +of the hardware implementing the resource.

Above needs update to match the new architecture specific debug. When doing the
update please consider that it is Intel architecture specific information mixed
in with the resctrl fs documentation so needs to be highlighted as such to not
create expectations that this debugging will be available from all architectures
that support this style of events.

> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -366,15 +383,31 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> -	MON groups. Please see example section for more details on usage.
> +	This contains a set of directories, one for each instance
> +	of an L3 cache, or of a processor package. The L3 cache
> +	directories are named "mon_L3_00", "mon_L3_01" etc. The
> +	package directories "mon_PERF_PKG_00", "mon_PERF_PKG_01" etc.
> +
> +	Within each directory there is one file per event. In
> +	the L3 directories: "llc_occupancy", "mbm_total_bytes",
> +	and "mbm_local_bytes". In the PERF_PKG directories: "core_energy",
> +	"activity", etc.
> +
> +	"core_energy" reports a floating point number for the energy
> +	(in Joules) used by cores for each RMID.
> +
> +	"activity" also reports a floating point value (in Farads).
> +	This provides an estimate of work done independent of the
> +	frequency that the cores used for execution.

Can this get similar treatment as cover letter wrt "core" vs "CPU"?

> +
> +	All other events report decimal integer values.
> +
> +	In a MON group these files provide a read out of the current
> +	value of the event for all tasks in the group. In CTRL_MON groups
> +	these files provide the sum for all tasks in the CTRL_MON group
> +	and all tasks in MON groups. Please see example section for more
> +	details on usage.
> +
>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"

Reinette
