Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935DD7263D
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574691; cv=fail; b=CHz3ZMoupp1+KgihVBjTrL7+5PpYLeLRAH1FKW6RxPRWVmj2ZS9eiEsJAMiSEa+YErAb1LMMPMhw4Et5Y7UC6I+Zr5Pd1WeNKCJipmNTpYOm66RXfxjL84HXMR1ntruouIe5fiEzulnoN2/+P/+H5pEvs9/MjV9UsigpJfZu6ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574691; c=relaxed/simple;
	bh=j8Em4JEMH5YtHfi1dV2QJ9aZU3Dbwm08DHJ+qjcz+x4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pYZg+o8jdUF6NJWvEkBg4DoaBSNGupeZk8mnAqqT+mCkNmyV0eowOvd0Y0mxN1Tq1pwcdlxt9HKtuMKq6XrrzMYW9wBnyy9x0N9Vy0XGbmb21TNpNRIe6OPMzfiluLGQLtHflj5irQr3iv0d1v5LOdChbmYLNblJZ3hVRSwf1+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lvhslPHB; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lvhslPHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751574688; x=1783110688;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j8Em4JEMH5YtHfi1dV2QJ9aZU3Dbwm08DHJ+qjcz+x4=;
  b=lvhslPHBs0kzwcxYQHMf3AWXWlU5K7osLGVWcYpRpqr8FjVy6K1f5zye
   LojVYTzeYybCI6+PlCFT0NmrhjmRs/9U9+AuOuLZ0eFQcEkMOm4uiA9Cf
   PW/vZDcNLmXtdssIcYkJ6LFYxYFN/MaSmIyLyoiaZcT4Ilw9VYnUu4AEq
   QpuqKdbZtjcDTYzRQ78fHuTuGItLfe5NoGbqfkBnwGRubXN2UwNY9MWrF
   WzGskOtYKaGpkN13QmgPRkkgEk/+apRbN1TP/vVpykyyzZ/LNCJQtOWxp
   DcfCPFxLbgmEvQFnTseEb6FPlUX+yNrMaH31kDClfUBzcIZe1Y/ukt8yZ
   w==;
X-CSE-ConnectionGUID: YqYLJexCTGCslSvXws34Yw==
X-CSE-MsgGUID: KoAqCKXeQQy803INtug3hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="64160153"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="64160153"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 13:31:28 -0700
X-CSE-ConnectionGUID: 5+tOl4eTTdqVZr8T/wIZ6w==
X-CSE-MsgGUID: egJbLdNJQEKwOCKTg+UhdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="185485751"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 13:31:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 13:31:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 13:31:27 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 13:31:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mtfwEUq7OqXWscn7mnyX1nAe7n6eW0z9ZXoGdaN9yOtGqQkIgGPaQXwideCnyE7EG56yhs7ZHgUoxdHRMKplDQkBkAhKVEqJy84pJ/aMjF8SjBcYnycOoLNYnqlz3u8bZ3WPBGiflCL0bSdIWpIEsVmR/KfyS6D4FiYfrb7QDnUoMcdJr4IQHI1XF43j4isrrfEQXUnzxI5ODOOGLCe6U3y9Q4pC6isoBeia37SC7TIMVW2w0xxpGAxhYxXtjUfADMXYc1iubt9AAPNY1VXKHgdNKnB0AAHu/glzkqqkQYE0IlTj0pE20vit/v8FpDBhPQ75HLfuMGunnmKL5NoNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XN0rthNyl08R+2HD5jZpGPwaXcPM/8BV6DPqgimRZw=;
 b=y7gbx4c5B1BqwH3rZsWePPdeL494dUai3hM15FasG0OH37yMYO7c9ebgE10MEakjHoRUs2oP8OiXTYGs//4cYG62PTNmK2ql8VNTkwgtPLD8tKaG+FYihTxoU9IBkvp0hlwwWW3YdwlM/86uvDS5jPgpvL9de6Gp6ifEit9bL6vxQ0Gd4is0TwqAaWpXCZxZPp9VtUc1f1P43WKnYZ3MSt9/Hf+r7f4ZfMLd/2Z5ebSghEsbSYuUWG+JJOyjNd48NGH1rG/ywmVihkHE0b5ZPg/s0Fk8S2gGpdFWUlHHGGh9+ENiPuRSdbgESbIEBICEaQ7DbTQ3pUFkwaRW6yyCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 20:31:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 20:31:21 +0000
Message-ID: <bb9b5ee5-3367-4193-9e07-747b1ab50637@intel.com>
Date: Thu, 3 Jul 2025 13:31:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
 <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
 <aGblc2VimjIiy_bY@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aGblc2VimjIiy_bY@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:303:b6::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e3ddde-e9d8-4670-eaa5-08ddba709270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SURHU21VcWN2M0UyUk9MTHFwSVFIS0FVMU1RVGlxbzBtY0ozRS9leHNheko4?=
 =?utf-8?B?YytvaHZWdUx3QjFFMVRiSklncnRZcUdYR3VNMUlqeUdmQ1FqSlVBaDRIN0lZ?=
 =?utf-8?B?WG13RE90RnRYdStqemZ4Rjh5L2FDdVNzbitobjNiRWwwR1BCdzVvT1dieTBJ?=
 =?utf-8?B?YnQzei9DYytkTXR0am9VOFkxazExUFdBNmo0OXpid25xWVhGUXFjOXFiejRx?=
 =?utf-8?B?dUx2bi9XSWQrTzA2bmpwWFpaV3BRWEJqY1RjNXFMd0h1dFM4azVGelVoMm5s?=
 =?utf-8?B?M1IvQnliS2RLQzF3YjhiMExJQlNRMGV3MW54ejgxTFJFZjFjVnJ2dWRxQ2Ro?=
 =?utf-8?B?T1F4REpvZlprL1AreXkvQUpBTnVnYU1jdWJTRGJ5ZjdXOUpmQmlLTVEzU0dp?=
 =?utf-8?B?bmEyaEVqcDl5K2dENTJLWDk2RGJ0NllsbjUrNHZFbkdSVTg2L3hPK05Wa1JD?=
 =?utf-8?B?WGJYTG5OMlV6eWFhQjZvYkFiZTJXeFg2RFppZVIxdzNJRmtHZ05STHBQeUs5?=
 =?utf-8?B?elRwdWxsZElPUXhSd0UrbTlXNU9sVUtsM00vWU1OUFZsd0E1cjdJbHQ4bytB?=
 =?utf-8?B?NTdjblpLai9sckRmVWMreFdxL01OYlovSTlSTUhZNFBGdGpLWjR0Rk5nRS9h?=
 =?utf-8?B?aVN2Myt2Vkw5ZkVidHEyTDlzeFFwZnBtL1NMd25reWQwdkRyMjFVdWRSaC9V?=
 =?utf-8?B?d0ZWamlBbkhITHVTbG9IcFBobDRNRmFWTVozOHZVd1pvcUs2RFFBZE92NXhH?=
 =?utf-8?B?ekRBNWljU0pjU1VLWWdxQkNZSVJ1c2dYVG0renRoSUpIamZERG1Ublh2U3BF?=
 =?utf-8?B?VHFJSWZSUzNZTHkzdHJQeERwMjM5SGpaWW1FcTJrdmsrTUVSU2g3cmx1emRT?=
 =?utf-8?B?SktqQmhsOEVrRmtRT0lHYUhJMDVqcWVDU2QxZDVrMXk2S0R6b1B5VkNDTTU5?=
 =?utf-8?B?WHhPR1dPcjNxZHVyaDdFL1dmbytMa1FaY1ZnS2FBMW5melZjTmhUTVZjMU5l?=
 =?utf-8?B?MnVrWEZiNlc0NUNZZGx6OGNDMVh0djY3ZmRsMzBJMjRXTTF0RUd4SjdtV1ZV?=
 =?utf-8?B?NE9yRjBleGZ4QWJVL1RvaXZadldSc3F0TFovNVA0VDFmbkkyS0dsMDhsejdt?=
 =?utf-8?B?UzMxZk02L2YyWjFtU2N4SDVUSHh4bXZ4MVpxaTcyUTE3bHIvckd1R2U0Znpl?=
 =?utf-8?B?bXY0ZCszaU94Wk9tTnY0aVo2d3ZOUHM4a2RRdlhpSnZFV2lQVXZhS1lIUTFK?=
 =?utf-8?B?dlpHQnF0VEswVFFLL0xDUjZzSUhDWmxsUC94QWVTekZIRHY4VmtweWhsbld1?=
 =?utf-8?B?WkhVSEhxaHZDZWN3bDJzWG9RbFIxZEt2bTVGN0NnL3BEbXFLNGJwTjlpaWJB?=
 =?utf-8?B?QVd3RDY2K0QybnJZUEcrNy9pR0pVQVkyblBQUTJTeWlwNVZ1cUlmaWhzLy9Y?=
 =?utf-8?B?R1U1QU9Ea2Rra01nNWttNVJOMk9WVUxLbHR5MlIwT2FJbjVOTnhXWnZIS0Ux?=
 =?utf-8?B?Q0F5MlVsQzJ6Rm13TjJQUmJybjhKM1hVMExhaGlhME8yQi91MVdNMFRnd0Nt?=
 =?utf-8?B?eVhEemtpUXdQUW9UbDhlb0RMM3dRRVFOZFBRTEtuU3dHVHVLMzlsNE5ORjFW?=
 =?utf-8?B?SitXQ3ZpMVpCVnBsb2xJVW81MGUwY0R2V2xSbG0xRDJldHQ1Qzl1NG9SbExj?=
 =?utf-8?B?TU9WRDNhb1RtaWovOS9WWTFVRVBsOVpPZ1RzVzJ3M2JYQ2lKZDBkRmxIM0pu?=
 =?utf-8?B?TmppRk1wTjFIaWRMaVdKVnhxTDBGUXhRNlB6OXkrbVlQYzJ2MGYrbnRzbjF0?=
 =?utf-8?B?bENSZEovMk5EcWQvUVdtTjJTbGpmMSszakJSMm5Bbk9rSkZhelo1TmU2UE5P?=
 =?utf-8?B?OFhMV1RqNnRYVm44Wm10QXVkZVJSR0Vhc00zbmhHWDdrcklJTmUwM0ZlV0p1?=
 =?utf-8?Q?cPWvAiF9BjI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzNpVWVCbUM4N0VQNHJaVDArdnZLM2psY044T1NIZ1YzbzhTTmRDWnFTNWRT?=
 =?utf-8?B?ZEJJVDRTbnpueDNRREE2UlFHUmlPbXdBeFppT3l2SjRNUnVPWkRxeUJZZGlW?=
 =?utf-8?B?OG5vUXdMUG4ydjl0ZllNMm9YeVY2eGxsckV5M01OK2hhaDVQSEJLUG5rTHNX?=
 =?utf-8?B?RWl1bEkyRnB5Z2s0L3JWUjk5eXJPSEp2TTZYVm9yNXFVbCtLWjFGc2xEMHVz?=
 =?utf-8?B?SU5HWHV5bVhmK2hxTXhhWmQxTUg1bGFMK1czWUNjbE1wTktGQTdkUzhFRzk1?=
 =?utf-8?B?OG0rRlhXQjZlZU1KMzIrcFZzeGF2bUVkNE1GY2JsV1lwbFB6NHNwN2EyQWJG?=
 =?utf-8?B?NVF6Z1d1cTB1anB1Z05UdWcxbUZHdDZPZE9GTkN3VHpwWXl6K096bWdXTW9p?=
 =?utf-8?B?dVEyUEl5aWgzY2JBVVpacVphZjZicm9PMFNRUGdUMlZsZXRDM01WQ1lMWEpj?=
 =?utf-8?B?emhES240M2J4Wi9oYjRjV1NDMnhnOUxMeVdlUHk5c3NNblEyenN2VjJ1RXZC?=
 =?utf-8?B?RFMyRWMzblZESG40SHF5TnRrR0xNeEJCTVlPNDhPUE43WnY5TmlzZkVVOVEv?=
 =?utf-8?B?eHVuUHVaeHZpZEVuU1V3UGVJNEFqdFV6N3RqZm43OEhXeUcrM1VydU9IQ3dR?=
 =?utf-8?B?cGZ3YU0yRWNpU3REWlJDL0Nobm9odG9BblM4RVAzZSsyUzNLWk5McHkzOEdO?=
 =?utf-8?B?Sk9zekwweHZXYTNMbVJWS2RyaE5McmtDYVczNVVmOFZqR1hCN09hK29NTUM1?=
 =?utf-8?B?QmJlT0xESHZYc3JydytqQmZFbU81OUZWTjBCY0c4Z01HQ3dPcmRWNUVKTTJp?=
 =?utf-8?B?aWw5K2FBNzRGSlo0WmtNNkVqb2N2WDRYc2VWbUx3L3IwOVJGbHhqb2IzQisw?=
 =?utf-8?B?SVdlc09tbEZTaDNnL3AvYnhCTjV4MEFWQmhoRHJHN2QrM0RNUXM0eXhtZ1p4?=
 =?utf-8?B?djdnMlUyVDgvRUFlMU1SQUYrdTRLcUR2aWtxcWJzTVRtVnE3b2pNZ25vVVB2?=
 =?utf-8?B?TlQvTDlZK1phOS9rNVBESCtFRmFtc3JRVHUrUGgxSk1hdXZVdkpLZ0VQSTZD?=
 =?utf-8?B?K3B2L1NjOGplWXI4R2hKY2IycDdxdGhqREwyMS8rV2p4dGxTMjZMQ2FWRFZq?=
 =?utf-8?B?MWhrRUZSOHd6bWVxMFkwYld0amx3eXBaOFdhend0YUlSbFNKUS80UTA1RXBY?=
 =?utf-8?B?Q0xWNFdCQWFVbFd4Tkh4clpCcWVFcDdZdlZJcW5YK242amNSMmNCL3E5RG1s?=
 =?utf-8?B?d3Y3SU9zZ0VLSmRYREpsODB1R3Z4OTBkVzBKR3B4K3BjUEdUWGh4QndTNDBj?=
 =?utf-8?B?Ymo1eTJJbCtzN2dSdmo4dG9jZWQvYWJEUWhSaTR4dkdoQ2tFUlBDNFZjdklD?=
 =?utf-8?B?RmdIckhHUmVpdjZGVllkWEJDN0cyalBjMmRTdGtwa1c3dC9NaGt5WU8zYjVl?=
 =?utf-8?B?WnVlUENiVnBwTHhHUFk1TkJ0Z2F3QXJrMlNvR3lVY0lDQ0FDYWJESC9KK2xu?=
 =?utf-8?B?MXFIc2ZRQURxd29iS0VIVitteDVYTWFSWU4wUXM3WGhXQXF6L3Q0ZTZ0U1lv?=
 =?utf-8?B?V2JrOEhiajFaUll4VzdhNGdraUV6WVRLeHdzTjRtL1UxeUpJdG5CbWJydVdm?=
 =?utf-8?B?d1MxUXl2Ynl6VytOcW03OTAvOHovVDlqQ3J2dnBRNjR1c3UrTDQrdk9RMFIz?=
 =?utf-8?B?dmFlS3hxTHNYK2hhenZGMVdnUXRwbU9wOTRIdHpUdnhRNzBMZWFob2ZkM1g0?=
 =?utf-8?B?NWNHdytzWnFDUTg3VElWQS9LNDRrQkVFWitLUGhvNXNNeVJGV0t1a2l5UldJ?=
 =?utf-8?B?emUySElGWHlvSno4cXQwL1dJcDNwZzV2MVN3cGl2bjRZTkc5OFY0cVF6YW1Y?=
 =?utf-8?B?cWxWenQwZ1UxNzhuRVVsRzNyd1UwcXRwcXJjQVcwR05QdFFVZS9SUi85dFRE?=
 =?utf-8?B?TnNGZS8va1MwWEgvaWtYT084UkY0VEx2aXdoZXJ3ajEyL1FDYjZXOXB0Nkpo?=
 =?utf-8?B?OHlMSlJ1MGtTUzdINXAvLzRHSjJSZ1pjSjFyK25VNlZwSjQ0VnM2ZXU0ejRy?=
 =?utf-8?B?QXZRWnk0ajQyT3NvVklSbU1DcjJ4T0h0N3N5QURMcWY5eXhsbXVOQXQxc1J2?=
 =?utf-8?B?VmFkclFzY2o0T2t5eFNuT21JSXV2NjQ2UEpqbm00eGFBV1dTVnlSeVJHdzZt?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e3ddde-e9d8-4670-eaa5-08ddba709270
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 20:31:21.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dJrE/dB+G1fMVOd/N3dmNJ0R/773NCAH1Jd7JWcTwnMRegOqH4EVw9jpH6ikFQJE/8PGvxm8XyaGTCugdeO5OiEnJw9M+cycvTRxs2epP40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
X-OriginatorOrg: intel.com

Hi Tony,

On 7/3/25 1:17 PM, Luck, Tony wrote:
> On Thu, Jul 03, 2025 at 11:27:19AM -0700, Reinette Chatre wrote:
>> On 6/27/25 11:06 AM, Luck, Tony wrote:
>>> On Thu, Jun 26, 2025 at 09:49:26AM -0700, Tony Luck wrote:
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index 71019b3b54ea..8eb68d2230be 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -512,6 +512,9 @@ config X86_CPU_RESCTRL
>>>>  	select ARCH_HAS_CPU_RESCTRL
>>>>  	select RESCTRL_FS
>>>>  	select RESCTRL_FS_PSEUDO_LOCK
>>>> +	select X86_PLATFORM_DEVICES
>>>> +	select INTEL_VSEC
>>>> +	select INTEL_PMT_TELEMETRY
>>>>  	help
>>>>  	  Enable x86 CPU resource control support.
>>>>  
>>>
>>> The list of dependencies to "select" keeps growing. "lkp"
>>> just told me that "INTEL_VSEC" depends on "PCI".
>>>
>>> An alternative approach is to just add:
>>>
>>> 	depends on INTEL_PMT_DISCOVERY=y
>>>
>>> instead of all the extra "select" lines.
>>>
>>> Pro: This describes exactly what is needed. The INTEL_PMT_DISCOVERY
>>> driver must be built-in to the kernel so that resctrl can enumerate the
>>> telemetry features.
>>
>> How will this behave on AMD systems?
> 
> The call to intel_pmt_get_regions_by_feature() in the INTEL_PMT_DISCOVERY
> driver will return that there are no telemetry events.
> 
> If it is a problem to force resctrl users building AMD only kernels
> to load the INTEL_PMT_DISCOVERY in order to use resctrl, then I can
> look at providing stubs for the entry points in intel_aet.c and
> create a new CONFIG option to allow resctrl to be built without
> Intel telemetry support.

I do not think resctrl should enforce dependency on a driver that is not
valid for a platform.

Reinette

