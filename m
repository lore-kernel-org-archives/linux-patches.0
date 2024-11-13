Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E974D14BF8B
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 02:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731466470; cv=fail; b=VY+JnPErTY9T5QGKxDvXVXScV/TbU9bgLwNpMSqJcZLCa7ZbuNbLuPfS147PMOsEr6tPYRp2uqWM6PzqdGG9iMyyLrdGGwiiQvoqiOu5nSRX5FEsA6WrS7Y/t3z49uHtkzcOyl5LFLT9UAfBuqr0Det3Gjb9dKm5/5B3DGZ+HGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731466470; c=relaxed/simple;
	bh=gXCngvSQMGgnIKLqxTd58k9VmwRwPS8piSV2eE/pvpY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OUxbtG6dRCg4hn3GnlVWbO4nUeazrh6vwoPPUAocQcFPLI7dS4GkxKS3wif6TM2VS4TKtIGO5B616aAV+kaiVtuIRgYSoNGg+cTk63uC6Lo58e/cHp71FjRcyVznPgXcsK+5zGx/JWW3VmJreS3ddiTpmF+dpc9pZklgPzEy6MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADhH+y36; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADhH+y36"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731466469; x=1763002469;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gXCngvSQMGgnIKLqxTd58k9VmwRwPS8piSV2eE/pvpY=;
  b=ADhH+y369XEBysukNsjKrx98PD2WXRe1ELefgqWhwLjuqqdcDjEeaEko
   uDjTtDZuAiro3AtWvzEvdWk5EfhzFb81HTazk4PlbNs/+UJsJNu6Z0kjv
   baWieGwu1sIzyhIyaJJ86+Wcf1HOGq0DzQZbXJJw4cK+QQWBaRb0FoMJC
   u4bIF0PvDnedK17IioG2XRnrNEbMIRix5cOx5KCS9BhqeYpFgxg50jefp
   gopKxN1FjtBMSZyRi2Dyuf2fnpDo3y9l6u0YZkUeSVUB08XyGCxD8iXR9
   deR483jGLMOs70ejfslo7LFYDYlmp1Nzwbmm04lIQAcMjlYHENfv1SP9S
   A==;
X-CSE-ConnectionGUID: bGhVZQthQxSiAchzJxHYeQ==
X-CSE-MsgGUID: vGWGVTzZRwaLWhFSsyaV2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="18949052"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="18949052"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 18:54:28 -0800
X-CSE-ConnectionGUID: TpwGLlcvShqQah5xtsp1Dg==
X-CSE-MsgGUID: K/7W1JD3QXaEkCU9S4iyaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88142675"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 18:54:28 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 18:54:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 18:54:27 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 18:54:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CzDZSURN+7ou00jgCvC9kFQCRxLqDds3Y7mrFIftmXQwaJuS0N9oTl96pAJu6fkKUZg6q1yQmdkvTmRjlVrt7M2+Ufqs1FPVZ3UDcvWq4nC/IQZR/IfO0Qu80HZ2s8jUCWU6lcKVq5sD9nitb9Hrl9l4QVxn+DQpgzFvxQt1RMwUrhODIS+vujni0foQNha4e+06MACj8Hh8nGDXkIuozcHQ0lePpm3Tc7WucBzSbVxelfOF1QYe+cTyJgtviRxqlEU2jxO0OF6AeLyt1Y//wRgFbkgN4BOhP5mUPbUCw4pGFCCWLadkopJczzWqkbIL2iK/8dVBa0LG8Aje6Rp7vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSfDfomzYZz5rYTmfRw6IEGFN5+LbSkj2RdadX5XV3E=;
 b=juQRFc0jWLC75UQJIamlH5PUFFtRVuPNAvd+EZond1GHmN013oNuDj3S99lTQLmq6vfyPX3UitWnLHBme1xbxD0vo8k8KFOWhqc15L5+l5iQIxE4rLS1/Cy8JbZq5PnZay+M3m/r67TXOYrlvwafocaHt9L5YgJc0wQxd792QPugRhM5Uw0C6P9NbOscdu10AmjSsHm7RZ3czj+lsHHYDrBRIxSD/YCpmHuTWskycigxaJhiaLCrICKcgqoeZMAE3nv4HYMZYSGWPAZUEuxizUkaGvHyQlloxGrf6V/5mZY1CujOhD4gDG9Q+P0Ckcj0hBFTrD+os+pl6O295vr3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8510.namprd11.prod.outlook.com (2603:10b6:408:1e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 02:54:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 02:54:24 +0000
Message-ID: <1f7938a9-d0ac-44a5-a2d0-db9739ef6de9@intel.com>
Date: Tue, 12 Nov 2024 18:54:19 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
To: "Luck, Tony" <tony.luck@intel.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-6-tony.luck@intel.com>
 <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
 <SJ1PR11MB6083839383802DC9127C5CD2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <c748f9d5-ef10-499e-bde5-1bce20a44d2d@intel.com>
 <SJ1PR11MB6083ACCB3B5D602CDA9F2269FC5A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB6083ACCB3B5D602CDA9F2269FC5A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:303:b4::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ffdbde-ab7a-4c52-b50b-08dd038e7b1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VkQ1a1Vabmc5b2FPNi9nYVNEdzlyZ0QvbDRaVTVraFBYazFSYTlvZFFHSzVK?=
 =?utf-8?B?V0haeXlCcnFHWG0zRG4rZEgyblRLQjlQNTIrakk1NHJza0ZpNk51eTlQWXBn?=
 =?utf-8?B?RlphRjgrZGc4cFRQazVVUWtXNytEbWJDUzlIQ0Jzck44bG8rQTdacVE4NGdJ?=
 =?utf-8?B?OThjWHN1UGwzWkpmQkZRcGFXTDg3WXBreE5kTDROY083cGdXYXhUOUhWcU9s?=
 =?utf-8?B?YmE3OUZnajNpNEVESExvQ2txTUVXZlpoUnR1VVRlamN5SkRuTC95TzVYaWc0?=
 =?utf-8?B?cUZHYkFHaWVkYSttYURKemlSb2lPUTFObjVkRHU5REY1Y1NqNGlLa0xWdkVr?=
 =?utf-8?B?Vmtjd2dSa0htYVJrSXIyekhLdm1CYmVnK0hpamhFdDV3Tzg2N2wvNWV4RmRj?=
 =?utf-8?B?VElOVGJwZEZ4R0xVVHVmUTJWMG5WdWZEUGtnVlNnZ0FIRUxiLzhtUHZ1UGp1?=
 =?utf-8?B?RWNIbFFkc2Z2K1ZURklqcTRGZ2Z0a1F1dUdhVUFPd0NxNW1TNS9KNjBkZUtu?=
 =?utf-8?B?QkwzTzZvL1dHVm9OM0tVZlhxVyt2MUVIYXlhZ3JIYU5wUDJVU0NRNVpRalNt?=
 =?utf-8?B?SmptL2pEQzZhZ1I5cGkrdWc1SXltenF5ZjVmRGk0M2NKdy9OZm8rZkFENmlR?=
 =?utf-8?B?SUxsTGxKTDRyZzEvR3gvU05ERnNkWE1weHU3djJRSUVyUWlWd3JFOE5TSzNl?=
 =?utf-8?B?NHBuckVWclBIVjROR2Rra1J4QTlReEJCYzdybkNsZzFHWk1xdFp0OFYxWmVL?=
 =?utf-8?B?RkJRVVg2eTUwcC9wK0pyTTFuUGs2cTlveDViTjBUVlR1VGRqRDhFR0NEWGp1?=
 =?utf-8?B?UkRoVVcybkdkTThuVXp6VmxPOFFyKzVnc0hxVFZ4c255K1RLdE1iYjB3dytQ?=
 =?utf-8?B?NlNSa3g4QnpOZ3VGTE1aa0FDVnBkK0twU3NVamNYdHkwbjNTZGxnOVV5cERo?=
 =?utf-8?B?Si9DbnN0MU5PajF0SHplMElCaTRjcEczRDcxOG5GTnV0WTFsQXhqbmFBMGZX?=
 =?utf-8?B?UHR2dUN4VGVvOHNjeUh1OUgwSndYU2lIYmlITUorUjV4UVVGcWdmQ0pOL1lr?=
 =?utf-8?B?M0xPeTh2WDdKQnh3ZGp6ME5tZ0lyejh6dXYzeEtDY3BWYXVQMVlSUG9oTDF1?=
 =?utf-8?B?S3hBcjM4eGJrWjJKV3ZZVnpISEJVYWFCMS8va3JuT1NzdzhISXJjeGhxYzVS?=
 =?utf-8?B?eDJVM1FaSXNBK2dGSE1mMExhbVoxQWJNUXlzcVAzS2YvVFVwSnlzMGhQOTVF?=
 =?utf-8?B?S09DdU8wSjNVdmlSUzZRN2FCUU9zS3ZISWUxdHlzRXVxUG1jb0EyeHVxVnVB?=
 =?utf-8?B?VS9TTGEwZFJQY2crNm13Sk1xb3U1MjI1RWVaaFpwM0pZM3NMbkp5ZnFnT0hL?=
 =?utf-8?B?Y1VMTUJucndJNzVFNzJhOTUzS3ZUUFJpQUtYRFRlbkxEYVpzQjRuSVpQOUZT?=
 =?utf-8?B?WXRaTEVId1BEdUpkSXJIcktzSUlVR3VseE1SdDhlUW42VlJpZ0hYUkEyTFJt?=
 =?utf-8?B?d3dwWE8veFE0Mm4rVHpoZUFIRmRuanJQc1VwdGdQUDFxdmt4MW43YmVJY01K?=
 =?utf-8?B?M2N0RTJwbWI1QXZWZ3lOT2ZsTUI1bGxRdGN3TldJdDZqdHFnOU1PNG4vU09t?=
 =?utf-8?B?Sy91RUpqMlNJVHlKNk92a0xRNzZseDdjcWJlc0xZZVl3S0dzSWg4UWxvOVRy?=
 =?utf-8?B?MzBaRjQ2YlhVdjlGNEwwTWxiMCt5Qm5DMzIxM0g0WW9oS2VzUWsra1lFREwx?=
 =?utf-8?Q?zK/tU9p/nww+MZOr6pPXoHC22l67QT6xsDwDCNo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWkzQy81S1VEWUFZVlJkSENrNkNtQzIyb2I3SUZSUlBQTUNidW9nZVhHdzZG?=
 =?utf-8?B?K2gycVpSSlFSQ04zeE4waGU3Z0s4ampHalFMcXpWVDNvb2Vjb2txMmZrbUFq?=
 =?utf-8?B?SndyZWZBZC9UNVVIUWNQSjJuanpGUFlJTUV5dzVWZDdFem12NDhkR0tRTjl2?=
 =?utf-8?B?aHp4a1NRc2RtL2Fuc2pONlZWaDhsaEpHTDhaaUdaZC9CcUhCdjdvUFdvc2Ns?=
 =?utf-8?B?WWxNSjdUcTZIRXRvU3JrTE9GbTdnaDl2NnN3V0FOVUVhMk9tSzc2SU5hNVZE?=
 =?utf-8?B?ZTJ6bWc0N1dMVnVRaURHbTRsaXBPWCtrN0VlMElkVElMMXRMUkR0L3drQzdt?=
 =?utf-8?B?Y2U4NXpvSTViMjNXdWFxRGNVbXdOSitxZHVHTzg2RFMzL2N3dGY4OUhXUXZI?=
 =?utf-8?B?aHVUelBYRFZDemI3RHhSbnVHQ2FLTVhucFIrL2dzL1VUM1hGN3daemJ6bUow?=
 =?utf-8?B?RzRpbUpsVDErbE50SmFhQ1NUK0txdVFYTXIvVlBHVkV1TkMvSlFUcjFkM2xN?=
 =?utf-8?B?ZUhLak1hV2hVQXROdFJyOENvTXo0dGtxeExjQ2t2blZEckxtWXpNdEVrdVpv?=
 =?utf-8?B?T0hzZk9mQis4NUtLczFWZXdtdCtYbGFGdWRTcHIwa2ZLSFJURWhOOTRvTEhD?=
 =?utf-8?B?UC9PcVpKV0FCKy9HdU0zdGowbXM2bmhSY2VNZU1JWnJtOXJ5eWVLTlAxaWd4?=
 =?utf-8?B?andtYUJRVE1kVVhva015dk5lYTFRbnBhbUNpSUtQcmk4Njg0NStlMWxDZ25u?=
 =?utf-8?B?eXVOaTQwbk50aEZBT3JoczB1QzRNVWxvbEFZa0NiWDdKaGhjZWxMTGM0cXVW?=
 =?utf-8?B?Z3hFaWllL2Jvd0tFQXRxWldRb3RNZG9ud2x6L3IvenBDbmU2VUJjM3g4TjdI?=
 =?utf-8?B?cGVrR0lFdEVWdW5HUldBNkFEYzhHQTV5bmlobTkrbG9iengwOFdja1pkQ2FS?=
 =?utf-8?B?bUpqcHhSVVZyWW5Vd3hNWkxVL2xqQnJEMG5wNCt5V2JoR2Z6dkdpQkg4VDUv?=
 =?utf-8?B?WEN4dFF0eVNwTmx6MjJObU41OEJTSUlnM3kyT2tHVExMdUk4OUlUUnc0Y3M0?=
 =?utf-8?B?SU9HMi9GU0pwdHcwRzlWWHpJZ1JGb2lhemJPY2NVVU9ud05lWXVUdVNqMURo?=
 =?utf-8?B?NTNTdTVpa0pkeEtjc1ZwalpwWGtjNlEyN1Z6QUdQSXBBa1NXenBpTndDZ0Nl?=
 =?utf-8?B?WFpUV0ZaQ3ZhbmMzcEcySzg4YVJnOHlqYXVQQ0I2RzYvb1hZVExiMFo1S0FI?=
 =?utf-8?B?VVRqSnhnUFIrTC9CZnFjcG9UVWR3R1lEVndtVnVnM21za0F6a21EbnJsbjNJ?=
 =?utf-8?B?Q3NXTjBxUU9tM0dMcDRyVGRiRHhTMTM1VDJITFlMZDFrdU1uM0d1VlVoYmdL?=
 =?utf-8?B?dCthaFUxM2NPWkc0SVd3eHhjREozNG1uekJ3VzRxcXRIbThoSHlTbzZrV0No?=
 =?utf-8?B?R2tyUVdwVmVydjRmUStURVY3WllzWXN1M1NLRjBlZDk0QVF4T1RQNVpKRDNX?=
 =?utf-8?B?V1F6L0ZBc25Xb3pIMEYrSitnVVgyNzRYaE5vemkrTS9QVDJSRnRLVXdqVlpr?=
 =?utf-8?B?YjNETzBEUVlNUmFsN0tGWXVXd0Qzc2E0a3pPSkVPLzN6Y29pZmR2N1NEOWF5?=
 =?utf-8?B?UmkvTWtQZXl1ZHI5SkJFdzk4VmVwNmNwNGhDMm80aUhVRWF3REtwRG9yY0tU?=
 =?utf-8?B?TGhUSXE2R0VPVVB6bVc1dXZqby9Sam1zNmg1UmVPcEFramlCM3FsYWg0THhR?=
 =?utf-8?B?LzN0eE00S3E4UVVFVzAwWWdYK1Y2Snh1WWFBS3NDTy9oSXBHTWpTWHZSd0Rz?=
 =?utf-8?B?TERFdDBmWTBnYkZSb2t5RDZsZWVhaFIvdmRNTnpjbVViUzhrZ25zdmRvU3I5?=
 =?utf-8?B?V1B3MW1Sa1MxUXQ3cFI3aytubDRsZHkweXRzZWVtNnE4VGRoaTFSNHhpbmJZ?=
 =?utf-8?B?bEo1a2F4ZWdFbU82aG5CSUJ3bmlZbFFWNHZVK2ZmMEEvUUFoZnlrdi9PV1N3?=
 =?utf-8?B?OWVXL2EvNkZxM05zbkkyODZld1F4RWhBQ2VyV3F3b3RqZ3VlRlZQY0cvVWNi?=
 =?utf-8?B?WXFMdEx5K3NySGdJakx5cy9wMHNhKzFRbGtaTUwxT0VwS3hPbGtnV0VuQkdD?=
 =?utf-8?B?ckRXTEF5WXZYNzNmanMyd1lvcnZUVkY3UExmb2RlbmtTNi9vQnJRY3k2VVJ6?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ffdbde-ab7a-4c52-b50b-08dd038e7b1a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 02:54:24.3562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IPxTlpHCtpn6Zy4AevrExbbH2hbXguyeod9WVKsDBIM0j/+N6lOYC4djmHw8v/ryzBzISb39RFYFKK9FLSqXlizgF8n/xgObnKGgh5MLJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8510
X-OriginatorOrg: intel.com

Hi Tony,

On 11/12/24 4:53 PM, Luck, Tony wrote:
>>>>> +static int set_mba_sc(bool mba_sc)
>>>>> +{
>>>>> +   struct rftype *rft;
>>>>> +
>>>>> +   rft = rdtgroup_get_rftype_by_name("mba_MBps_event");
>>>>> +   if (rft)
>>>>> +           rft->fflags = enable ? RFTYPE_CTRL_BASE : 0;
>>>>
>>>> I think this sets this file to be created for all CTRL groups, even when not supporting
>>>> monitoring?
> 
> I think I misunderstood you. I though you said the these mba_MBps_event files
> would be created even if monitoring is not supported,
> 
> But now I wonder what you mean by "all CTRL groups".
> 
>>> No. The calling sequence is:
>>>
>>> rdt_get_tree()
>>>     rdt_enable_ctx()
>>>
>>>         if (ctx->enable_mba_mbps) {
>>>                 ret = set_mba_sc(true);
>>>                 if (ret)
>>>                         goto out_cdpl3;
>>>         }
>>>
>>> So set_mba_sc() is only called when the mba_MBps mount option has been used. So
>>> mba_mbps_event_init() isn't called.
>>>
>>> Note that on unmount of the resctrl file system rdt_kill_sb() calls rdt_disable_ctx()
>>> which calls set_mba_sc(false) which will clear rft->fflags on systems which support
>>> mba_MBps.
>>
>> It sounds as though you are saying that setting the wrong flags are ok as long as it is
>> done in some specific calling sequence. Is this correct? Relying on calling sequence
>> instead of correct flags requires more in-depth knowledge of code flows and makes code
>> harder to maintain.
>> Why not just make this "RFTYPE_CTRL_BASE | RFTYPE_MON_BASE" to make it clear that the file
>> applies to CTRL_MON groups? What am I missing?
> 
> The directories which need this new file are the same ones that get a "schemata" file.

Only support for control is required for "schemata" to be created. Monitoring support is not
required for "schemata" to be created. This new file requires both monitoring and control support. 

> 
> The initialization of fflags for the schemata file just uses RFTYPE_CTRL_BASE:
> 
>         {
>                 .name           = "schemata",
>                 .mode           = 0644,
>                 .kf_ops         = &rdtgroup_kf_single_ops,
>                 .write          = rdtgroup_schemata_write,
>                 .seq_show       = rdtgroup_schemata_show,
>                 .fflags         = RFTYPE_CTRL_BASE,
>         },
> 
> I don't see any files using .fflags = "RFTYPE_CTRL_BASE | RFTYPE_MON_BASE"
> 

I do not think there is a precedent for this case where a file requires both control and
monitoring support.

Reinette 

