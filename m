Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3290258CE8
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486886; cv=fail; b=aYi4z0KFRfFzinoqOIcbhglg3MTciDE6f/TLP18AVpW5C1vEU+xuBBcgIloTYcliV4LjecEwRoD9clzAeYGO2Fezj4j/tuJcVTUa06V8h6Fr1ZLBRRTPhcA+sgb87w0t8eRMD/XDNNj9kZvSTXk8yU8bVbyZl7N/kgMMcu6NZw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486886; c=relaxed/simple;
	bh=ZrnIQyTzhBd9kLfP0i8u+qd+IL/agwOBCgYazVWY+Wk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kq5cG2rk60hbJ0rWKtl4j3fBJ4izbkN6TbQB5wFYawUGFKQCEufWe99pqi7nTRHxXpBypnGGm/ztmyO1GKbCGCbKG1P1AiP3jUMGYKwQrBI39GL7L6oeO07wxb5uNQB2bI2gNH2M3s3Tp7xcSaeBhB2LYRal7fXbSOqpNZW8CLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ccBlFt4F; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ccBlFt4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753486885; x=1785022885;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZrnIQyTzhBd9kLfP0i8u+qd+IL/agwOBCgYazVWY+Wk=;
  b=ccBlFt4FFqZ1nx/5J76xyOeUA2mYB8FdMro00Pazpm+uGMIr2ZQ8G5SY
   QmLXKJ36NcUoFpCwDW/5lJ8ZeFWKojc6Jeax4nRdGEWYf7WUhPTHVoyGT
   5GYdUof63XuTk+FyH3zkIKpSwi/kaRYaKf9wMubFe1Xl2e2kKQqUoKVDW
   /9ftZQrRS4VBg3KQqZkazh9/RreC4QaH700O0jLY7AfdIMSMT02vwakqK
   FIdUoD0iCYMZeOkQ99vNxhF1yf5u5WIcpNLZUZpxw8pZ/jjTHtdWSMpUJ
   XLrxba4YTr6igGVI1n/izDbqBCutBaid/5y7bID7/INMWKCbhj6nS//TQ
   w==;
X-CSE-ConnectionGUID: susZb9bcSbeuG8To5iYIjg==
X-CSE-MsgGUID: 4zhPE3liSY6qUj7jhFr9Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="66394952"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="66394952"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:41:24 -0700
X-CSE-ConnectionGUID: YOQXNKRRQwu5vpc0WVHgNg==
X-CSE-MsgGUID: 84nHd1ttQ2KL9VwmYDj7jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160803797"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:41:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:41:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:41:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.89)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:41:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHlmHs1EhQ/9wHvekksfRBInUDugI00w9qBcsFM6IB9IX/Zts9j1hf1jkQQd57/bdlwAea0vjiNE7/0fgjyH1yClUdZGR6qKbOLQKq1HLQGJL3qDFM9Hb/wWtwjPLtG4QD05Am058bGSrldlzloodY8+1wt6RaxuYR+I7u2+1lL74G/eYrxXaiCi+iyjAuAbn5x6zzxOIrnjVV2jZpvg1RjCj6vd2NMDL6xsLLhWDe3UWs6fG1QG8/QxLAAFZDBMCiel1T/Wti0Pdmsk2Z/4HngHtrSJ/3vWL+BY4i30bldDEEgeFtampnNtEakM1y2JIutYilNQVp8rLGeoetgUGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJ744Vl4JZXGvXKUVq/PJHikimuq1svm5VvwJRooR50=;
 b=Snxuah40J8PEIpgLQxPoO9lCMWR5/55JKeEcmsnUcn1TxciOlXVEHpzHU5iT61BoPNUshhRmRk1U+Wc8rrP0kENu99eyDCF+WZC+pfCFg7C+7wOwHjFzmgpTys5tEPkyrclskV3vB9IdLxSt9ZGMjcqlvaRXLM5S3cTR1iv+TJ690fk1T53/kJSFdksmyl3+E/NI444nr9xUJq0O5kZKGOtGNu4gk1RZvzquRGahB3nPUjzgUIKIZ1fYvjTzJumeBEm/l/JvDTAPhMllKlyEtbWhW2ArptplJwTqb5aKbsbwWVVoG7I4dXm4AmgSimWj5vSaD+u2gwi8PSf7Z4OPKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 23:41:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:41:20 +0000
Message-ID: <765d3f16-6ecd-4581-940f-d062d3340c14@intel.com>
Date: Fri, 25 Jul 2025 16:41:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/31] x86/resctrl: Complete telemetry event
 enumeration
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-20-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-20-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:303:8e::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: eebedf2a-581e-460e-8972-08ddcbd4c231
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTdtSHoyTmduYUdHYjNFMUpKemhMR1FjNm0zNG9DZHF6YmtrMTU4cmJST0tR?=
 =?utf-8?B?QjI2OTdDZU53S0p4U3d4UGsvMTJGdzRSWTNINGJHM1FSU01XZE9hSmd2T1F5?=
 =?utf-8?B?ZmtpSS9QR0s0OVpEUFF4bFVNRm4veS9OTG9mZlhMdm1xNnFBaVRFeU9helRS?=
 =?utf-8?B?V3Z1cWxmQWVRRXh3ZGVycURVaS9nQW5GV3V5UzRXMzRyZTdmRTV5RDZzOGg4?=
 =?utf-8?B?YXBPaFZ3RXpaajZaOTBpY0NUZGp0bmprdkpMdXNpNjBQckdDQnFGOFVhVEdY?=
 =?utf-8?B?WXM0V0JwZk9hQUlQYW55TFZaQXhKcUw3dWhaclNwSVQrY2tmQ21uZkU0a0JY?=
 =?utf-8?B?a0tqUTNZVlArMzJpOGF0VGpoN3hWSHFCUFp1VkxxR2poRE84L2VNalloaTdB?=
 =?utf-8?B?VmhPWEo2ZjJHNWJ2dGhLYWYydnlwdWZQY1NMK09kZzZqZDIrc2JJcnRVV2ZT?=
 =?utf-8?B?Yi9Wc09XL2JjU082RGdsNUFyZ3lLRmZUelNjRTV6elNlNTMrTm1BMitDcm1R?=
 =?utf-8?B?aXRneFpWUjdMS0p6Z0F5UGZNYWpwT3pNMncyeGdtRm96a3gyTXYzaFJrSzZJ?=
 =?utf-8?B?ZXpML01QbGxTMVU5bXV6NXNReEhzT3R0WjBLdU1SOUhVRHhzdW9xVnc4VVNY?=
 =?utf-8?B?Q2hVQmRhdndhd2ovak1FRXJSZDRQa3RpaHBsZmczQWIzN3BoNGN4c2tXb1VP?=
 =?utf-8?B?YUxQUEpJczlSQnQxSHVCdzlUVm1BNDZId1FlOStXSTdKRUFzZTY2cm9hRmcv?=
 =?utf-8?B?Vm9PT2FhK1JqczFidGlXZjNhd3lEWlowTzg3WDVQWmRwek1GWjkwREZpT2dy?=
 =?utf-8?B?OGFQUnkrNngvaFNnSk11SmwydlVQNWpGcjJlMW9LVlFYTWVidTdVMTQ3SFZR?=
 =?utf-8?B?UUhIQWVEcVhhVkFEZWdEVzdrYWd1TmN3YVU1dVZ6VmgxVzNaTXIwakt2dVN4?=
 =?utf-8?B?R3QzcmNSdXdCT3dpTDJLakhFRW1saXZ6QWJPQ2dNRmhtWWF3akJ3R3NwcWFS?=
 =?utf-8?B?U2tOYUpyZU1OL0dHdjNxTC9Bd2FLL1IvZEVDdk80ZDlQWjIvaFhWditjbURP?=
 =?utf-8?B?VC9jZlJBMzBPSHp3bHk2RE9Xc25WUFdSWC9UeDArQ2JoZWJQcmtHc0psSWpV?=
 =?utf-8?B?cUVPL0ttbllTZ0JUc0hsU2o4UVhxVjJJdmVNRkdSZVpSQVV2NmV0SVpiQXYz?=
 =?utf-8?B?NWpKMy84SVluUXVzUy81aGtiWmRQamZXanRuRUdJbm84RjFGMU01Yk1qMVMw?=
 =?utf-8?B?S04xY3c0QW8zbW1jNjYzVXlSUHBJN28xVjZDTnBERUtQdDZiVzJNTFBPd3lZ?=
 =?utf-8?B?RUwzR3BUTkYzY1pBZ0d3cVRlaGNaQkp3blBuSGhoaEZkNWNaUGtSVWxmbDVU?=
 =?utf-8?B?NXF5OFhDT0ZUa2pRTkZ4MEhuYm9lUW80WjlvQ3NQYXFxTjlOWEVGbU56cmQ2?=
 =?utf-8?B?WWRIOThOOWMralVNNGd1TXA3WHh1VG5XZDFhaGs1SitYTDIzbVhuUmVETDZS?=
 =?utf-8?B?MjgzYzNkcGJrY1p0Yy84cUVnN3pMRkhKdG0veVU0Y2JLd0dmVmJSalk5M21P?=
 =?utf-8?B?ZGU0Tm0rYkZJNEFNQVkrMXpOeDRRM05ieWlaUnE5RlBRUHYwM3dYaXBZWkZa?=
 =?utf-8?B?cnFJVVhnd1pGQ3ZJQjhTakRXSFRXOWlUUllaSDdjdHdWdGI0USszckpXV2I1?=
 =?utf-8?B?aHJzL0Nmbm1ISytPWE83UXd2WDZycnJ4L3V4Ym1EMlFIR0ZtZWljQ0FUaGlO?=
 =?utf-8?B?UGZVMDVneWY0TEszUFFvRE1lUk9IZ0ZXNUxUOHlhWjdNaGJFZVRZV3FsQkVP?=
 =?utf-8?B?cVhHODRIUUdpSkMvSlBSb1pyVjN6QWlHTDJMUGI0aGVBamdmMVhGcVpaeXBy?=
 =?utf-8?B?VU9xcS9zL3RMK1hOY3AvbllMM0VrKzl5RUNic1hhcnVna3MxcGc4Z3d4QlRQ?=
 =?utf-8?Q?NtChxqqVMXI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkY2WHQvZHc4UnhkWVZ6d0VWL1RTTDBvVXNIaFBGZVZDQ0ZpSXltQW9QaCtr?=
 =?utf-8?B?WlpCQ00wS2xOT2ZQQlNLeDhCekdycWxrallxbGM1V1RNZ0dMY2w3bytGUTNT?=
 =?utf-8?B?NmpzZnFwY1I4WFkxM3VaL3FnSUJVQXV3UEVOVmhlNFFUOUJIU2tNa3d0Vng5?=
 =?utf-8?B?S3RsTVdwQW0xWEJ4OU44WWNia2VhVm5WMzUzR2RnVEZkY2RnK1gwTnkyZHMr?=
 =?utf-8?B?NWJ6d1RDMWUrQWswT3dYd2F2TlhtMVgwNzRFczgxS0RwcUR5RDFSWkN2R3c1?=
 =?utf-8?B?Q0hDVU80REtpQkFmamNrOVJSVUZPZlpUVlNzc3FrVlRFZ3FYanR6ckk0K0k0?=
 =?utf-8?B?bVorZTZJM2VwNDR1SXNWdzNEbzNaSnh1OXlqUGdJWVV1eVdHN05kbnJ6akRH?=
 =?utf-8?B?MWY4T2dXMUNRdlk1dStJTS83aFhvTjlBWDlZVEhLbllCQzAwbTJnOUprdkJu?=
 =?utf-8?B?UTVla3ZCUXF2eXB1OFZTS0w1MDh0L0wwVElpWERoaU9tWEZld0JLS3VjcVdR?=
 =?utf-8?B?NXVlQU13TTljNGJBRFBTaE94QzgvMVYvTDBsMGY3ajVvaGE1VTYwbjBkcWZ1?=
 =?utf-8?B?Mnl6cmt1SXlvNlo1dG5yV213YnkxS2hyWWRyS1JEWFdmbzZtaUY0RlFRVmR2?=
 =?utf-8?B?TTNOc050cjdiWno3NHh4TytCenJwWHBldGZNQUlIb0E4ZVJNbEsvYy8yUjF3?=
 =?utf-8?B?dFoxdlUvSCtaKzBrMHdweW55Uis3WUtxd2tTblNoNENoc2tiRklTV254d1Nh?=
 =?utf-8?B?RFd6c2lZbWtlM1VkeFhwQXIrOTBQVmVDMnYrUXFQM3pVMTFLWXJhRnBnRWM5?=
 =?utf-8?B?ck5JUi9DVGlZTWdMZi8zdGg0cm9OVWQyR09yMWJST2NieU0xdnd5VytuaDJP?=
 =?utf-8?B?eWR1NWlqSVZOSjZRTXBIbDNmYkZzSVQ1K0QraitISmVwaVI0UEFwcGpQTVZK?=
 =?utf-8?B?a2krbWdlVDJ0YXd3ODBldm9xSWkrMWxHMElUWVI2d3ROV3pDOE0yY3Y3VHI3?=
 =?utf-8?B?SDlQVEFCTXdaVVJSTFBUeENHanRET2Y3Z2JFalRUdVQ0L3M4S0JNVG9wRG9Z?=
 =?utf-8?B?UW5SeVd6cVRNWHczb3g1dkhjc0czdGJETHcwdFdhenJrZmYydVBCSWpZc1Qv?=
 =?utf-8?B?bURza2RERXgwNWJKZlZLMSs0M0gzdGxFVzEwV2p6ZkhCQXBQOXd0MVBwWE1i?=
 =?utf-8?B?b0Jud25NUkJoRHFJcmQ0U1dYT0tnYitrQlZkcGpVdFU4MHFQaXNaVWM1eFl0?=
 =?utf-8?B?NlkrWXpXVmRZbUprTk52bG5lVDJrVXRtVVYyb2pmaDV5TjFUbEdaQjJmelJo?=
 =?utf-8?B?TzM2TVVnbjhlOGN1SFNXVXdyNGRtUys1WXV6YzF6RlFYdkhhd2hiaHhOWHd0?=
 =?utf-8?B?MGhZM096RlZaM3BBcCtWc2pidklKdkR2RFVSK2NmUUVXNktBT0VIQlYwM3d6?=
 =?utf-8?B?NXJiTk10TjFERzl6cmEwTXlpbndYdllmMGdHY0RIcmVvS2t1TnNZL0ltL3hT?=
 =?utf-8?B?WVNtcUswSTlPdWxRUU1LMVIzT3E3K0JUa2JLbE9FazQwV2t3Ry9sYVBsZ3F5?=
 =?utf-8?B?NmRFNllRRTZGcTVqZU5FVndnbXVoVllaQTN1SzhFbTVWbGp2M2hhaERydkdj?=
 =?utf-8?B?Z1RDRUxYWHVwdDhYSmNQUzNrU3ZIYXcvMnA2WklUUC9hUS9oamZPVkJubGI0?=
 =?utf-8?B?QWtaMVI1czMrZ3VIeGUyNU9IWDRyaWZIcEF4WFJLUGFOckg1ZTFoWXBBWXJt?=
 =?utf-8?B?UHd3OE5hbU9xbXpSclRpK2hnMXU1ejFHejZKLzQvQTF5d2p3S05PTTFabFJP?=
 =?utf-8?B?SUcxK2RlcGlvN3NqSlFDeEVHUnpJZTBvMTZFMVJKblA1NGp1d1duQVJaOUFh?=
 =?utf-8?B?bE1CRUwxdGdFWURGRnVZd3BYWllXNzVITGl3bCs4Q0Q0bGRid2lCRTg3bndj?=
 =?utf-8?B?WkxuR01pc0F1TTZHYVMzUllDMzVaeFU4R0F5eHBIUFpSZnVZWDFheDgzYmZP?=
 =?utf-8?B?RlpNUFRBc2dkd1VtM2FueWVOTXBKa1V3dTRmMm10bjc3dWxRMU9OVjJiVHAx?=
 =?utf-8?B?OC85ZXhsMGtISS8wWG1jNlNibk1PNzErWk5UOC9PUjF3NG5rSWpucEdkMlJk?=
 =?utf-8?B?S3BjdmhHQjdBRHR4aHBJem9KODB4Z0dxOFJTMUd0T2ZJYUNzS3hMUTRQTVhH?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eebedf2a-581e-460e-8972-08ddcbd4c231
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:41:20.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yp+/mPvi+VIF0nsy1VFPateQI0gmDvmJ27/CGw1EXn4vf6PaP/17Eeiaets5at+x8veHEzRS54VnUHhgMDdE28ZaOz90cTJcVOiQcmvPYR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Counters for telemetry events are in MMIO space. Each telemetry_region
> structure returned in the pmt_feature_group returned from OOBMSM contains
> the base MMIO address for the counters.
> 
> There may be multiple aggregators per package. Scan all the
> telemetry_region structures again and save the number of regions together
> with a flex array of the MMIO addresses for each aggregator indexed by
> package id.

I do not see why it is needed to switch back and forth between interchangeable
regions and aggregators. Why not just stick with telemetry regions? It is
confusing when, for example, saying "number of regions" followed by "for each
aggregator"? Why not just say "number of regions" followed by "for each
region"?

> 
> Completed structure for each event group looks like this:
> 
>              +---------------------+---------------------+
> pkginfo** -->|pkginfo[package ID 0]|pkginfo[package ID 1]|
>              +---------------------+---------------------+
>                         |                     |
>                         v                     v
>                 +----------------+    +----------------+
>                 |struct mmio_info|    |struct mmio_info|

mmio_info -> pkg_mmio_info

>                 +----------------+    +----------------+
>                 |num_regions = N |    |num_regions = N |

The above "There may be multiple aggregators (telemetry regions?) per
package." could add that the number of telemetry regions per package may
be different and supported by an example where one package has "N"
regions and the other "M".

>                 |  addrs[0]      |    |  addrs[0]      |
>                 |  addrs[1]      |    |  addrs[1]      |
>                 |    ...         |    |    ...         |
>                 |  addrs[N-1]    |    |  addrs[N-1]    |
>                 +----------------+    +----------------+
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 64 ++++++++++++++++++++++++-
>  1 file changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 7cd6c06f9205..3f383f0a9d08 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -19,12 +19,26 @@
>  
>  #include "internal.h"
>  
> +/**
> + * struct pkg_mmio_info - MMIO address information for one event group of a package.
> + * @num_regions:	Number of telemetry regions on this package.
> + * @addrs:		Array of MMIO addresses, one per telemetry region on this package.
> + *
> + * Provides convenient access to all MMIO addresses of one event group
> + * for one package. Used when reading event data on a package.
> + */
> +struct pkg_mmio_info {
> +	unsigned int	num_regions;
> +	void __iomem	*addrs[] __counted_by(num_regions);
> +};
> +
>  /**
>   * struct event_group - All information about a group of telemetry events.
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
>   * @list:		List of active event groups.
> + * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
> @@ -32,6 +46,7 @@ struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	struct pmt_feature_group	*pfg;
>  	struct list_head		list;
> +	struct pkg_mmio_info		**pkginfo;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -90,15 +105,32 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
> +{
> +	int num_pkgs = topology_max_packages();
> +
> +	if (!mmi)
> +		return;
> +
> +	for (int i = 0; i < num_pkgs; i++)
> +		kfree(mmi[i]);
> +	kfree(mmi);
> +}
> +
> +DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
> +
>  /*
>   * Discover events from one pmt_feature_group.
>   * 1) Count how many usable telemetry regions per package.
> - * 2...) To be continued.
> + * 2) Allocate per-package structures and populate with MMIO
> + *    addresses of the telemetry regions used by each aggregator.

"the telemetry regions used by each aggregator" does not sound right. "telemetry region == aggregator", no?

>   */
>  static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct pkg_mmio_info **pkginfo __free(pkg_mmio_info) = NULL;
>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
> +	struct pkg_mmio_info *mmi;
>  	int num_pkgs;
>  
>  	num_pkgs = topology_max_packages();
> @@ -108,6 +140,7 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  		tr = &p->regions[i];
>  		if (skip_this_region(tr, e))
>  			continue;
> +
>  		if (!pkgcounts) {
>  			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  			if (!pkgcounts)

squash with previous patch.

> @@ -119,6 +152,32 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  	if (!pkgcounts)
>  		return -ENODEV;
>  
> +	/* Allocate array for per-package struct pkg_mmio_info data */
> +	pkginfo = kcalloc(num_pkgs, sizeof(*pkginfo), GFP_KERNEL);
> +	if (!pkginfo)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Allocate per-package pkg_mmio_info structures and initialize
> +	 * count of telemetry_regions in each one.
> +	 */
> +	for (int i = 0; i < num_pkgs; i++) {
> +		pkginfo[i] = kzalloc(struct_size(pkginfo[i], addrs, pkgcounts[i]), GFP_KERNEL);
> +		if (!pkginfo[i])
> +			return -ENOMEM;
> +		pkginfo[i]->num_regions = pkgcounts[i];
> +	}
> +
> +	/* Save MMIO address(es) for each telemetry region in per-package structures */
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +		mmi = pkginfo[tr->plat_info.package_id];
> +		mmi->addrs[--pkgcounts[tr->plat_info.package_id]] = tr->addr;
> +	}
> +	e->pkginfo = no_free_ptr(pkginfo);
> +
>  	return 0;
>  }
>  
> @@ -151,6 +210,7 @@ static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **ev
>  			(*peg)->pfg = no_free_ptr(p);
>  			return true;
>  		}
> +		free_pkg_mmio_info((*peg)->pkginfo);

Is this necessary? pkginfo will only be set on success, no?

>  	}
>  
>  	return false;
> @@ -179,6 +239,8 @@ void __exit intel_aet_exit(void)
>  	list_for_each_entry_safe(evg, tmp, &active_event_groups, list) {
>  		intel_pmt_put_feature_group(evg->pfg);
>  		evg->pfg = NULL;
> +		free_pkg_mmio_info(evg->pkginfo);
> +		evg->pkginfo = NULL;
>  		list_del(&evg->list);
>  	}
>  }

Reinette

