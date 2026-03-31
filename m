Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B644E02A
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988592; cv=fail; b=kuXGiwXyBI1GqQ4OhNq7kOTFXeJimsZ4TME/vthyB1MRPKj5UnnsEqAmHim6pns4qP/GXNtDeH4J0DoLm8rdUj1g7eMKpWeNP9jir3UsND/FWUltQeTZZpU38AAFd92/OkWeUjXmo2tbJAnUPR4hejx4kp4qVDFhVMfWGzZuky4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988592; c=relaxed/simple;
	bh=uz8U3z5Wr3pBxj1JBoNhRzEzmngx7OYszLT1uYTTp58=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mz/z4qVd2XRi8RNi5Sfz0eDVzjLvbClURisFiwIz9Au1OMICBmH8USc9AGxUoA4hCTpdDBMfNfEwDj78ekzRX+NTua3bXgxs3ipCswD7wVPq99g0E5ME/fJpzOnJd9JYDviOzWWOYpR4vwR/Yz8k76wRaU0jHW9T4rCtixTUbp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AR+CHRIx; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AR+CHRIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774988591; x=1806524591;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uz8U3z5Wr3pBxj1JBoNhRzEzmngx7OYszLT1uYTTp58=;
  b=AR+CHRIxziLdLwh51E9kANwzz2PQKWmrcDHdPROBv33rYqAecx4rvWfD
   nB3/SXpdFSyEPUuEYxyZH8J4A8AZoWiII3JeK3c9reCEs0rdWwmWXRwrF
   OkOuvUGS3872xSAfsXuUiCQFwbJ9RVIeSN6GwgZsBbVtfnRhoybx9qvzO
   eg9/6JLCZfY5EjdHcl+wppvJ+1Vt4gCRzyiAvqXuSREcYGONU8GQzyNaB
   u8Xj6l0rFSG9DlQfx1mwKz4CdoQGNZMSXxCATZmoLNdMzai5xC5tbyIvL
   KuKcmSKS9oHuQkeLtb0NfnujLyRST7B1qkDPhff7xIgzpA482GaS73ULU
   w==;
X-CSE-ConnectionGUID: Zzln8qbQQty2EJsGol+gvw==
X-CSE-MsgGUID: UAW0nqxDQ9G422QQAuLhOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="76131640"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="76131640"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 13:23:11 -0700
X-CSE-ConnectionGUID: H54yN4oBTNSND54X6rKtpQ==
X-CSE-MsgGUID: +tETCzKVTrC3dMpeVpqEXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="249680519"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 13:23:11 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 13:23:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 13:23:10 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.4) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 13:23:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9CRKs5P/URSrUCtPznjoXuNRiJ2J6H8nidzOstRv7lD4I4+I+N8vj746fArDBZ5iz3m0YiebMu9dZixwngvFO5FRdvwiII8pHLqt2DzHmP1gLmqEkSTWdw+6Jlm7DA8EpTBX4BfVgA/6gE0mhdaZoCxpHFOqNg0iAwqz2Oz8dvDsKpT3j7auElEgCpVgNDPXpmVujvh7qC4Fbz5YAnsPvakX/61sKQVh1mw2FLZL2Rg6oy5lmAR+8E+swH51XgKn7ie8/JqDMVcy9gKnb58tqqxH3lNHhx7eD+0x9O/aTLZcbX0LgPRcbmpQnrHBTbWUe8wxLa+GQ4uQ29/PD/S4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uz8U3z5Wr3pBxj1JBoNhRzEzmngx7OYszLT1uYTTp58=;
 b=OVeiYqDHUfbwRQHkFUbNO5QH8Su1lLNX5F3hvGmC7YGPgl++knvHuz25dlfSTpI4wryWYCwvz10gZm94URr5xHR9lTlzFvliYKGc05aJ3r5S/4WOQbvwV7msL1nVaFur/DeAzIL3EkM+5l/kuslbZLrw8O45sQJq+3X1o0EQpZiptVWyTvcJobL1g/Uyj2VrLjU97IiQOjA/hSt95w9pb7YRCOmvJr5/Ju/rnNFpTfijpb07p8a7jmUT8l1qyN1GxW+sgeCAkbGWaMDajnfqXMJJJ6aEZiLPfpG7PeyCPlgGuQIHWJAZNJopvEQKTC1D2H4h+mqDD0XFSsE2CGJKOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 20:23:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 20:23:07 +0000
Message-ID: <d3128009-2cbd-4aa6-9764-ad44a8520b2a@intel.com>
Date: Tue, 31 Mar 2026 13:22:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] selftests/resctrl: Fixes and improvements
 focused on Intel platforms
To: Shuah Khan <skhan@linuxfoundation.org>, <shuah@kernel.org>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tony.luck@intel.com>,
	<babu.moger@amd.com>, <ilpo.jarvinen@linux.intel.com>
CC: <fenghuay@nvidia.com>, <peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1773432891.git.reinette.chatre@intel.com>
 <17b0f9ea-ea81-489c-8a8b-f3118d3d28f3@linuxfoundation.org>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <17b0f9ea-ea81-489c-8a8b-f3118d3d28f3@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0262.namprd04.prod.outlook.com
 (2603:10b6:303:88::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV3PR11MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b14d23-ea47-4adb-8a1c-08de8f6351c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: CtG3sPJd2aesz9+c2xQnz5c7OWIK9rwFNg9atMZjCBI/RyFcpTq0IixXBTq1E7RbswBVQO+CwYqUvKmrUPYCm6a+ixxAthErELu811jP5hpABeGrsx12oOOC/wmc5aqR9bCEk1fmbf7ehA8xa2OMUA9+2nbovVycrW/s7qKEdYzs8DI64Exrd2DTEHvaf4KbjPOvSvBHQeru75wbQPOPRR8mzDCuMx9mfGiOZ4ju+W7KXkNFzxd2SRsDPHASsQ1Pk9Tm9JP86XB6lQlDaUcQZIOo/9ENVZsH3uZR6whigQZJ06t4S1Ub81Lgw1/WATF7jqQlZ8vDUN4+tmLC+jXHxXCth4hxXTjthg5fU8jv/ukMsgMPWia9H2NlyENd/Y/W7oAJGaUhBuxTKraRMyS1/qy4Rq3YJbOs2brrb5fI/HSBJaiWV9oY3PMSa2Nhap3v1JvajTq5LDXGR1Mz4+fKnLNjORhlW2xhv8APjj/YHI6SJNTWYBtD4IdsgOZfzn6jaQsM2nDPeOiQPxI/2+040nSrx7rBsDt649TynfxtQ3kifpcQUu+Ix5qMr/wmxWZY31pvH+9VRlSzuxGBvPs0NozxrlTZZGozkpK/9+k0OCi+ifZHBQ+TTW2Du5uYV40z685vT1ukVoa9Y7NPKRJ+qK5YnlxulwlDu6d7TbW8j4R7ub1elvUMfD4xyY31JNHJi51sXTKA26Rstnj28lyBu8qFtU/BuQNDH4/x4+032Zw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2tFQ3VnSmxpQzl0M1BMYXVROG5JQXdhRFAzK1VMMXZUcTJ0Z1ZkOVJzZ2Y1?=
 =?utf-8?B?VWw5bk9VZEJ1YnpFaXREdGtYN1JZSDdwQllKcFl6RWFndzBtMkN0VG1rTTkr?=
 =?utf-8?B?SmxLUUVEcEZLK2NtREpua0pMTms4NzVTWmtLTW5uUGdOSlNuV1c4M0tMOW5C?=
 =?utf-8?B?VXVrakhheWZac0FpUlVaQzgwK0xpKzlKWGhnRWllOU8xYXFtZVZidXU1cHQw?=
 =?utf-8?B?WUVpK0ZCcG9SSkNyNUZVNXBLcTdpeTBTN3BNVEVFLzRGNkYvNzg4Ly9iTU9h?=
 =?utf-8?B?WmR0MWR3WEt4MFA4VDFqRGhudTcyS3VORkNoZENVZlhxWGdXaE9ER05GVi8z?=
 =?utf-8?B?QkxNUm42WlJXdGw1QmorUHdtMnVHSGlQTDhaaWMzeHoyczFCcy85SGRqN0s2?=
 =?utf-8?B?dlowSHNqQkJReU9HRU5uTENUbk16K0RFSnFZdnhXZ3pQOElvb2R0SklVZWsz?=
 =?utf-8?B?MStuenV3b1NPbHB6eWYrMERzYkNtZUgyaUJHM1h2NWFYVmxhRENRbE1IT1Ba?=
 =?utf-8?B?MlBaYVdMU2JxUGNaT2FYNkRRNTNGSHVBUmFNeGU5S1FhZ1hxVVBFdWx5SUo4?=
 =?utf-8?B?T1RWSEl4WTUzOEpPL01sTjduZzFWdE5hWTdib3RsMzJKUVdKRkVaTWNDNWRT?=
 =?utf-8?B?RDhmSmxxbnFwR1pmaG9odmkxVmtqUmZ0SE5ITnhLRkxKdDc3VSt2elEvQ2J5?=
 =?utf-8?B?OXdVVzI2SXdEZnpUcnAzMjgrbWRwOVJ5bWdkTXhwYnJMT1JLWUc2QkpTV2Vx?=
 =?utf-8?B?WlV1WjEyZ3BUcVFBYVViODJlaTg2RFRaWUMrcUl1TkVhMTkvWFJtaXd4RkQ1?=
 =?utf-8?B?OGZtN2YwaWYwdkhlcFdlNFJZeXQ3ckxwRFE3ZzcrQ2N3ZjhCTUJNVllGS3BZ?=
 =?utf-8?B?REN4aXEvdFh5ZWlpQWt5eVliMFFXa2MrRndVS3ZCU0dLSHRHbDM3dWlybjQv?=
 =?utf-8?B?SXpYVXpVU1pSb1hES1dPV3VTMmhkc0x2MWI2aS93M3BIbVhwOWF0OFM1STdS?=
 =?utf-8?B?S2duRlFkOGxSZUMveU91VThQSUxmNmxFa1NLOGh3ZmR4MHVIZkt0VUlyQ0h5?=
 =?utf-8?B?K0R0alpDdW0vQkhZamMzZno3VEtGYVdzN3FrdmdGd0pxektnZy9RWDRwcUlM?=
 =?utf-8?B?Sk9udm9WclVlOEFXU3c0KzE5SnM2QTZ3MmFITEN4cmRORXNhV2NmaVRRT2h4?=
 =?utf-8?B?Q2JvNUpYUEpXbE05cG95MGQzTkk1U0ZFNnp1NUFGVS9wanphSU14aytSM3No?=
 =?utf-8?B?TkYyVno5TjhxYkMzZmNqaHJpTUtoTnkyRXNQTm5zQ3F2U2VIMkNlTVBHM1pa?=
 =?utf-8?B?K1I5WG9SSHVOZUE0K2Z4VEFraEk1WXdqSnZzL3BXSkZZSkt4N0FiUllyZExh?=
 =?utf-8?B?UldPR0p1dkd2cFFIbUhTb01RM25sSFYwY0FmNi9LNXF5YzU1KzdiS2JkVmpw?=
 =?utf-8?B?cS82YzlLclRRMkRJU3U0MlhiQmg1MnZKSG1Ud1VGRitoS3BpbmVERTdVRWE4?=
 =?utf-8?B?a011UUpGTVRKNzYzU0xEUEp0ZCtvcDFQUEk0TkJjQ2J0V2lLTVBLM0JuaDh5?=
 =?utf-8?B?N2VCZUdnVFBaRHYwRmFwWlJ5K0xPaWpQY1dFKzU2UHlReUhoN2F6WWNicS9n?=
 =?utf-8?B?aExDRHVXTDlqa0ZvUThremRYNnBPVTRjWkx2MEhmN3BIeENJQTYyWW41a1J4?=
 =?utf-8?B?b0o4VnBUMUl6QXVDMEtBWDFxMDRTRld2STNzMWZ0MFZvUlJhMC9FSVRnallm?=
 =?utf-8?B?MnZRdnYxMHNMRFNQSU5ET1IzUFB2bHJxaVB6WUlBVWw4RjY5YUdiZklNOGgz?=
 =?utf-8?B?NkZUNmpPaVRBTmpyUWdtc1JuRm9kME9BQTdSdWNNSTFDRFlzcDFJd2R6VlVk?=
 =?utf-8?B?Si9DWFdUUzlrQldjU3JXRGFEblh2cFhBaVBzaUdmVXU3ZTd3YXlMMVdTa1hL?=
 =?utf-8?B?MXgwWXJsVXZDMTNuRnc0TWlaalJEZVVwNnpoNGc0Qk9Xbnk5SUswWU43SGZz?=
 =?utf-8?B?QjdxNTQ2eGZoSEwrZ1pVMGlzWllaeDNaMW52R2w2cm5adTlCcFZ6cm5sMTI0?=
 =?utf-8?B?NFR6M3NhWVhBZGdwVXV6QjRzV05kVWJIek9Rd3Q5M0NoQno3MW5JNFBXNUUx?=
 =?utf-8?B?NlR0TGVkOFd5a25RTHZ6OVp0bi9aandwVGF2cndWUXBrRlRWTmhlTDZVQk9J?=
 =?utf-8?B?bWY3MmZ3cjF1b3ZuUkpFTTYveGFLV05CK1lWNjAyeWxHbEZmdEh0MFlXaXBV?=
 =?utf-8?B?QUczV2hINXY2c0MwUXRSclFXVEsva2oxV25mck5YM2hkYkFSbnRWSGlmbFZi?=
 =?utf-8?B?VHNqUzhFRlY1YzlWSENvMnZtRkQ1aDV6VUlPNktVc3lSdFY2Sm5DazZpTjVi?=
 =?utf-8?Q?dd2WYAoLFWRxbFxw=3D?=
X-Exchange-RoutingPolicyChecked: M6LZLhaF2+GjIcqxiQ9emOIQDU5jt8QVeoo4OFlac+E3pUr/0+b6CARxToZjZ/wRAN+zHtFNXz1q/3ckaJoNlsq82hQBgE6bpQ7XFCsLT9InFIyUWLvpUqTBsdXCMtrtvY0SZL2eUK6k4N4VMdXQvTm9cvX7y/eY9ENHrGi6VnIvH4M6bCkTRBZBDhh9qs2XCiF7Zp0L36pazQtdnCWJl4kfgTr1gPuMg2ZDC1R2Hv/THLiSkXA/ieEmdkAJ9un5B8tra55/XxHcs0wTGWnsTJh7I1ceTwLF/yZ94d6eJSp+O2wTM6bF+v9zij2Uq6CrN+2wgOdIkfw7fU6YLWXl6g==
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b14d23-ea47-4adb-8a1c-08de8f6351c0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 20:23:07.0897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fxfl691cObYLhBrTfF6xUWIJTB4vo7HT+LxTUbI2JWrK6wre5lYHk2cvfdSW5oY+dbaB2GW5mptJycIE8emj6+Ak4jzZAYmdyDZ3Yq77N1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
X-OriginatorOrg: intel.com

Hi Shuah,

On 3/31/26 12:13 PM, Shuah Khan wrote:
> Let me know if this series is ready to go into Linux 7.1

Thank you very much for checking in on this series. Yes, this is ready to go in at your convenience.

Reinette
