Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4AA1FF1B3
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438119; cv=fail; b=T+uLEzVtW4XeiDkVdHSWcusoFUywmAME67Hb+JrBeI7j+/1ia1LqZiKAWQ/ajoZLebsbxhNYfIQmMybGsPgNqGcQnljMP1odBaQfq9V2Qm5R7u9O/N+O8woYgy2P9uA8qNkGeyF+sHeDpx/UYI+kSrDA07pcIEIsHIifUK55p/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438119; c=relaxed/simple;
	bh=E+wF9B92yyht2VISgIV8NFmIyBXb3PTA/Huz7Zjv+zE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SqrvnlwHf3Sbpx+KI3cnLTojTJJy0oaN36jftH3NXQ6SAGxr2sdXOYxc/ildPXkGehfgBOciNpyeM6rxRiOkJC79lirfctOplpsaUHyM6W2hqgzSyY5QCkyUaOrQCcv7kg38IV0oS3MoTLazkOW4gSs6ngpZG0ykWvuGikad4/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IzKfQ77B; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzKfQ77B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743438118; x=1774974118;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E+wF9B92yyht2VISgIV8NFmIyBXb3PTA/Huz7Zjv+zE=;
  b=IzKfQ77BB4pIew0NXgbOrAcOD5Y/ObQT58A38RvJMe2njzOEq7sQeX3R
   xSeS9I+dkg+cqjQHw+W69qsCuGoW+ycaEWDi0Gond3ARrNB2PDTJKdAr3
   ZzPbpHBiuvVTqLrpoygTsHXBObu5eP1Y14k+HCYdblipGh7VBsa9zLSTk
   DSFIl/hC/jWpKsp41PwuVh0yxwc3A+HWqn61Yjewpkc75gvb+2/e8mJd1
   5wmJKIZqX+fY8PhktOoNC8tGm/fAFpVjkEb6xVu6GXScO8OURb3IKV+2j
   yrIJF+BQUnSh2PJhA6OehqDWNcapqVJs0QAM1IlWCBzz18htWLvARgW5N
   w==;
X-CSE-ConnectionGUID: 4TIWwHGbQ9+dYW8wIfSZbQ==
X-CSE-MsgGUID: wHDoruapTjmMgsCXmIsv3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="48604504"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="48604504"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:21:57 -0700
X-CSE-ConnectionGUID: qmYleLsBRKSqyjztPe8kTQ==
X-CSE-MsgGUID: ydxsAcsfT3qhjezmLU1fFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="125952990"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:21:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:21:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:21:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6SvcRGBvaS8TdaSRGJKq7Dui6LvhBYFl6V5UwABPFKOihUWMMRfO7SRDZ+pcZc//UixGMsp9hb8Lh+OM1RydA10WyW+/VeJA0GLGIFhavp6NIY46yjJDmr9X6DqlXEqwQoo7uR/AacGxIdIaVA8MpC1DwxUfMGq2Th7Ps4UsAbD96Kk1eUYb/sUtMwubg1tUOnnxlDVTFdj+NZfk5B3fMMKXCy7yYgXzBiR/U4DQfbQIrEDf8tRpL4DjgHgBFW0Tad7ASdoD0j1kA5rfWBMfu1qz3LPLRC6+ubOaFmAuZuf/gXirVYUSni4lGad7Wei8xDnQpV4K9jnOvpEbdOkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxkBaAfRnxg4KflJPJ9tlooKgjXjESVlbU2pz6hvWQ0=;
 b=pQY+1gVATbKWncDL8jru9ZFDeAJOJ3L10MR3VNGNz4rHGSac2abdxGQwwjh54g6yJz7411wOTZYxtJlcbNRJ/jFfiA+nWllsOEkC6+Fo4ydlMNuTfLDEtFHs7+50cbJDF0eIeCphwKjWsEc9JjM+gmcKGpSmqwztHmekqkDe1DCEp9OxfVaG0hkANG7nzVcIzJ39ZmabHakUKVZ4JXLrQJt+5a0J02oRHiA7pGmaXhstcOntYc9Udx1sNQ6BdmBuTFcxkkSl2d2Z2y5DmG8IP30Ce2T5V3gqTdTJb8RBBPtNsJSPAigFoeHh0cHh1ryGKitSrsJVNpxQDueif1gUWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:21:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:21:12 +0000
Message-ID: <03f00372-e863-4405-a077-86173e39368c@intel.com>
Date: Mon, 31 Mar 2025 09:21:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/16] x86/resctrl: Add detailed descriptions for
 Clearwater Forest events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:303:2b::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM6PR11MB4722:EE_
X-MS-Office365-Filtering-Correlation-Id: a31a2ebd-9c0a-4d13-fe39-08dd70700ddb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NU53SzV5R1JFdW9IZzhHYklkbjFGK2UwYWIxK2NJTlprelMxamJtZ3FBOThE?=
 =?utf-8?B?OUJ2MVdXVVhRbk9Lbk5TL1o0UTVSYnhGWExMQ0kxTDMwYkJFTGtya0JVUDIx?=
 =?utf-8?B?TCtBQkJzd3lmcFI1eVdqY21pcGpaOThybHlLRXdIcFBwSkVaZ3dIZXN0M2lW?=
 =?utf-8?B?UnlpTnlzQUFaRjBPZm1yNmxWamx4WGpKODl1K3Z2QmxuY0VhSVl4THU0Tm1X?=
 =?utf-8?B?RHZMVEVULzF0S1AwNVdEVUZrbkx1QkJQV3hvRTlaTkNIdFZpUFIzbXVGeWkv?=
 =?utf-8?B?UWNoVE1pVTZYNWNad2x4N2VpRlZ5emc3QUdLVUNta3BjY0VJSnNBaFV0aDdZ?=
 =?utf-8?B?ZnJ4TDN3YStoWlFhUmpCY1hGRklCc2FzN2tGeWlraUwzMG1pbGpMOFNSZFBV?=
 =?utf-8?B?KzFBQlcwbnBtR2t5K2RwTFNuZGY2N0E5RzN5NHd2a0Z0bFNJNXpRdWs4c3Mx?=
 =?utf-8?B?UzVmVi9mb1hpU1NtL3FvMzAzM1BueU9NWDk0QmZtcm9Uay9ab2tHVzI5TE9Y?=
 =?utf-8?B?UjF3R0pLQkwvTVVVUVZubzJIL3ozRExvZEorQ1ZxcS9nRUc2UHZkLzRXOURr?=
 =?utf-8?B?Ulp0U0dBaUxQRWxmTjBUVWJwVS9zSEUxcXEvUDZ4ckcxYkRDZVpiVVEybEl5?=
 =?utf-8?B?U2NvdnExZzRxbm5YQ3MyT0lzVGV3V2YvWHNISDFzZEUrSmRzU2t1dExUejhz?=
 =?utf-8?B?b0JaUWNqTGg5Q0t3SzhwZ0VNSXh4YWp3ei9jeWdwWTBCUktWdjlxU0JSMDhH?=
 =?utf-8?B?NnRlT0J4bzFyMXZTWW1qdHN5WXBLRi9tQ09kZUw3TmNsWUx0cmdINFRJQ3NM?=
 =?utf-8?B?WTQyazBFdGpGekFEaWM0TGNrSVFaWXpmeHdIdERSOFd6K3pxV09JaUlZYmYy?=
 =?utf-8?B?MUVzd1dBNGovWXR3Nm95cllNUzdjM28vdUs5LzBxaVQ5d2UwRmNKcWJ3Q3Nq?=
 =?utf-8?B?ZjE5UTRLV252WHRqdnRCd3p1a3VqWTB2MmpCdVJOem1iOHMyU2FSY2FEUUx5?=
 =?utf-8?B?WFA4c1BsRm42V2hadDRZT0JkR3pkWmhwcm53WUxIMXE0QStKMXBTSStYTnhF?=
 =?utf-8?B?OWp1OUFVRW1FeFdiWnBtSjJmeUxMOWJYOFRGU0xNd3RQVUc2VHY0YVdqTFZx?=
 =?utf-8?B?V0JwOVZ0N0pCTFluTkZabWZYRExlYUVmdDNuVG9IWGJtbGpFMUpGS01CL0VR?=
 =?utf-8?B?V2dGdVRxU0d0WnByaVl4VUJCdmRvSDY2RjFjeVU3NlpoaFU3NFY4VnhPZHdy?=
 =?utf-8?B?NU9jTG9qc1Q1QUNqNmtCeVIwa0dlUFZhVVJKSmd5aU9LZXVnMnp2dnpOa0E3?=
 =?utf-8?B?MXM2Zmo2K2ZRLzY1d1B0QU5zMHBtTWs3SjcvaWd5SldoeXlqc2FmMFN5WW1v?=
 =?utf-8?B?dkNOS1dJWnpWMktxT0FXWFBoeFVSZllDU21xeUdzSFVTTEk4dThFeXp6cENR?=
 =?utf-8?B?b1duTDJ0N0NYaE1Vb01xTzExaE56dVExZVBWRmExYk80VnlleGtwa0Zjb05w?=
 =?utf-8?B?enRUak5Xc2EvUlVweExOSzRaM25adWkzUzlNaFFOWi9Gc29wbmRvKzVyaUtw?=
 =?utf-8?B?ZlJ6Ums3Rm5ieDhFblRSM29ua1pYY3RVaFFOb3lUSEVmald5UDVIaGV6cHRJ?=
 =?utf-8?B?QXp1MTMvL3NEVzZpM0Ezaml1RDVjU2J1Snl4RXV5T01WZC9qNEVHL3lpMW56?=
 =?utf-8?B?UmU2NGw2R3dwdUtScVM0YlVwb0xzK0FCU1ZKWFBiSzFNY0ZPTmtGRUdYdFVP?=
 =?utf-8?B?VHpUdDhGZmpoVnVFVWRZVDhSQ0ZTUThya1NmSlhDKzR2RmNzVml4QWU2emhQ?=
 =?utf-8?B?R2JYL09iNDBlYmtybmovMCtoWEhxMEUyM09kVTkrOGZTbVdYRHZYdjJSU0Vl?=
 =?utf-8?Q?WuXcw8mnNaTBh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VCtmR25PZzZWM1poNlk3c01vaUIzczBYVU5OQmhGY0NqcjVYenQxSVZzc1hN?=
 =?utf-8?B?SGlXMysyQmNsSFMzN1YyWEM5TnRORU9hUDBkdjJXYVQ4OU9nQlZraTBxK3N5?=
 =?utf-8?B?b1pFSHFGNmNCMUVRaHR1OTZ4enM3MXFWMXQ0d21UYjJIT0Q4Q3dlNTVEanVt?=
 =?utf-8?B?V0hRaTVVM2xrZWhIQnVsNVA2eDBnYzR1SkxiRE9YRm1QQ3ZXU0gzSjRwajZS?=
 =?utf-8?B?SzVOMmVhdVZyWkFTcEkrb0d1WlhIN1V5M1VTTGcxSklvVHdaWEt2bCtSUXc4?=
 =?utf-8?B?RTEveUhlQm5LN0VvbVBLTlEvOVp1RWxSNjVrZXhVTmhPZmtDVm1KdVY4WmtW?=
 =?utf-8?B?M2gybVY4eXpyNnlWR2g3VTVVdlZXNGp4UHdCS1AxSWdWM3FmM2pGeWtrcG9t?=
 =?utf-8?B?NG1qcHU0eitnSkQ0U2k2aDQ5cmxhRi9QRktSYnE0YXBibjRkK096U3NzVTJw?=
 =?utf-8?B?Ykl5OVA2UVlVQXhPQXFDWFRXYWpnSzVaZ0wwUnVPTnF3THVkaGNwTisrM3BZ?=
 =?utf-8?B?WVZ6NEcrbzYwRjNXY1lHbVh1d04yTFRaVk9iMUE1ZXdXZjU0NnpzaW9IeHdH?=
 =?utf-8?B?RFB6STJTYVJwYll0NlRMWDV4dGJkVlA3eHlhQ25DNTl2U21sd01iallWT1hG?=
 =?utf-8?B?WDV1U25ZbDgzZmwyOVFJenY1RzR3MU52UXZwUjhyNUFyODlZMGJ3bWhxWVI0?=
 =?utf-8?B?SDBaZUVIVlF4UUNObzJKTzhCb2ZTR0pjdmVmK0NjR3hlWkYyREVnSHk1Z0Iv?=
 =?utf-8?B?d055bmRVNktXY1dBUjN5Q0k5eTRXeFlVSVQ5UDRobER1VnhQYU1QQjd0TGNw?=
 =?utf-8?B?amZ5TUhzd3F0K1FKNzhlcVEwVEt6WlIvemIzenR3TVFqUTdNZ0xndFgydW14?=
 =?utf-8?B?Qnp3SkE5ZG9BdE1FckxQUkoyVDdQS1VSY2tpWXRlc3FwRTh2bHB1RmE5dWx6?=
 =?utf-8?B?ZDZjbnlCRmlFc0IrZDd0Qkh1M2lRcldiWGc4WTU5RWNCMTA0S25oMnRvaWND?=
 =?utf-8?B?UGZBbEJmZS9Na210MVRvWm8yTTNzYjJhOC9wNlZ4Tnp1UHN6a3JUd0dkVDcw?=
 =?utf-8?B?ZnR1c0E5K3VIL1FmRnhPb1BoZDZhNFFzU2x1SmVDUjNlK1JpbTBjUzZXa2Zp?=
 =?utf-8?B?OXhrTm5tL25YSFZOMm5COWIyczJFaEZHeVd2ZjhocDVXTlcyNURUQXNUK0to?=
 =?utf-8?B?WXRneEt6T1o4WG1rVEJlOVpaU0NSMnNsSE9CYnRaaGs0ejlkRjZ6MFVxWElZ?=
 =?utf-8?B?bkcwM2gwdzBRUXFLRFZGYXdXZHR3NWgrVTRkUTEybCtMc2RwSDhpUE5NU1l4?=
 =?utf-8?B?Q0ZCOXBMSHA1NFljcW9nQUVDbHpUSG1GOStTRVBLcWx3ZExpaFdkRTMzQ21y?=
 =?utf-8?B?VXpyaEdYSmpLdHlvOTQ5N1Q2VmFOZDVqVHdQSW5xdEJlY1JrSTdXRlJNeUVu?=
 =?utf-8?B?L0JIQnRsUnJnd0JNb2FOTjVrRDJNK3JuRS9KYjNCOHdJSVZ3TVhFejhNMFpq?=
 =?utf-8?B?a3pQM1Fzb0xubEptaEJsNUFxbG1ZemVvU00zbnQzUjhyeUcyK0pLTEhFaG53?=
 =?utf-8?B?ZTdGRzRZWFlkekVoU1JQKzc4d3lBMFcxSlZPWWgwa2piM09DQk9NTVpHazdv?=
 =?utf-8?B?TGFtWUJBS2ZlRlVjR2xmb2J5YVdBUXplaDNlS2pCWGFIcG1UODlEMjRkbzZ1?=
 =?utf-8?B?YlROckxNWmtscHVXK1VMd0lPSUsreXVqdDYvNXg2MzlqNmNEV2I3UWplSHhR?=
 =?utf-8?B?RTFnb053bEpTY3dRYjlSNkMzU3ZiR2Z0UGdjZVhFSGJZS29yaHhjczAvbTZy?=
 =?utf-8?B?bHJUZ1h5QlFCL05qWk5pVDZXSEVvRzM1WG5BcHFTWUNIY1NVQnJvWkloMXd0?=
 =?utf-8?B?VVV1YVpUckdQb0t1ejlVbGM4TDJDRXplM2l1TU4vSGZzYTZFQVBQRXFQeWJZ?=
 =?utf-8?B?U0swQjg1YzFFRHU2SzJ2Z0JJUFp6eUxaWisyM3NjNU1naGRSWEk5eVRNdlUx?=
 =?utf-8?B?cEJYcTF3R3dpOUxEdk9qcTNrSnhzWUllZC9DM0t3ZzFhOUJXV2Evc1dOWklr?=
 =?utf-8?B?Nlpqa1hOdGZHQjYzMmt0L0k5K3o1dnBIcXV1ZXVMWjZCVklybzZQSURzaGpI?=
 =?utf-8?B?RVNrUlJUd0haMFFhR216RTV3c0xjM0NwRnEyVnNQMFpyRGVXN2R2YmJHWEhI?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a31a2ebd-9c0a-4d13-fe39-08dd70700ddb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:21:12.9165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajSgqN2wADaQcrovrl3XPIUQ73GLIWsyQiqqNdAKezvl4Hvc4QhTttRmeyU12XmZ7tyYEIDj2TWYSAIEi2Q/Bw7IcviiVyJnanRPZI4j4LQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com

Hi Tony,

On 3/21/25 4:15 PM, Tony Luck wrote:
> There are two event groups one for energy reporting and another
> for "perf" events.
> 
> See the XML description files in https://github.com/intel/Intel-PMT
> in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
> descriptions that were used to derive these descriptions.

It is unexpected to me that this is made model specific while the
implementation is built around a guid. What will happen when
a new system using the same event layout arrives? Will the url
above be duplicated for this new system's acronym and contain
duplicate data? How will the resctrl support change? If I understand
correctly resctrl will not need to be changed but instead the "CWF"
events will just automatically be used for this new hypothetical
system? This makes me think that this should not be so CWF specific.

Reinette
