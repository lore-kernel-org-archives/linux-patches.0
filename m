Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C110140E34
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 22:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498602; cv=fail; b=tGYwclkgLVSGLlI2Kzms0Vrjtynj9IQEPUp5V7ykUYfOqEtoM6ynfcE+yUfZETK82FUyGJPkMLF5Wl9fYlGPIWjHNzBZXbFRFEozsrr9PM7/zYgIuVj9p/prbMscWjKf9hO3ZEmQeMBhcMdyAdgj5riJeQfJNB3Nf/1N9M/t0z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498602; c=relaxed/simple;
	bh=Cw6CvcagDLiiHQN5EjuBjyK6k19o0l7zELYfgXSz8so=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lZHOAX2CG27nAJYp98K8xXwR+teFXqw/yCgXtdZGpJveMAnsKHWFs8z9bRI/bpmZOMzVNSPxQ+TaU7v43gLuMPkoikSq59G0JuWjbFSyPVhXexTbcSp8tM4vIef6d5ibTKFNPKy8KvccXyYAroBStU9YLXzmg0urjHMzBfRmBzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxJlizCo; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxJlizCo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730498600; x=1762034600;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cw6CvcagDLiiHQN5EjuBjyK6k19o0l7zELYfgXSz8so=;
  b=WxJlizCoVQWhUSDn7x4TGeo85ExiRG0hZ+A//++rq+7D+TH0Y7vJWJd2
   vi2ZNbb1YALyW53CozDyRdjvADg2RkbJGI1gZi+bISxEn20J3iNd3Dt2a
   CbwpRqaXXK3a6G6fxpr/k0Ajufwbkgwh6w15pm9w0g8ziUhk670hA6THV
   eyp8pNq+uo1AMaIrlBaH9qWR4X6X4wRY+y+K1LNbTBrpGBfRCxU9ExUZX
   mr9bSsV2u74lrjYZNH93w++ongrVGuzLwVm0hn/go1BrNjF2zzkIGMtdk
   jDiHisVsGTj25L9LytrLe8wsq8Y/s+DVbDRU7VpKreVVx8JPstpj2YMF3
   Q==;
X-CSE-ConnectionGUID: UHVlT4KQS1ajTOb6teo3vw==
X-CSE-MsgGUID: tdR07qLaSu2rIct0rsQwRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47727486"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47727486"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 15:03:19 -0700
X-CSE-ConnectionGUID: bA5XGC7fRguerkF1UpImXw==
X-CSE-MsgGUID: DLOkfh+oTkeLNa0PIpevhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,251,1725346800"; 
   d="scan'208";a="83001520"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2024 15:03:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 1 Nov 2024 15:03:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 1 Nov 2024 15:03:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Nov 2024 15:03:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vp736NMQ8u/lKJMaM7FNZg2SLvgekVKROPmO4ruiMWbS7n3/jg1AmOwGDdaI583g0Efl0rEddXliFDOybmA+f9ESDJnDeUIgPW2zarDhB6RXQLxrYVkBYVD1XgIa6zyIZBo8OwUlTdjhY/T7s6XkUxBoU0YPzXcqjtrUcl/exP/RDY0AWpfBPMpGE/89xj7kqdRjwz6UpjL9pt/qpaiS1PI5/bRg+LeT5x9w6qm3rKx2Y/FrnOa0UHJrLZKezgWiL6CHQcRApn8Hmbk1xH69Ga0z1n2jHLgBr4X3vD6wSDVtniKvs0l+z1KRO2vt06SCw0dWa0LI61SrcAh4CD8Ulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtU7jQItkCbgGmr+7Zaaw4dtiS59C7fzLmkCGheLETI=;
 b=vLEMVnRPEe/cUmA1uRa9rZvDYQqkR9GSnWHFfaCkVaI9pTPcOlwJ/NGjHgAmo7HQM74zxj+qDbp0rW8lat7WmFdnApYbcF7uFjTBgnDkyurWIIs7lpVazyPf3EehGgPQiq49hIRAYd0KeUtbEMjlgnM5cEnIUmM97RLloRWUEFYaoW68olwF4f9BCxaDeVE6wB02G8F9BX5AK82oJhRzqKFCH44cyjoqNZH6bf3ny/usXdqD6QIe7RvH3ebHCCmRybX2wDlaalk24C0a7MHP+wuG7Hyyxf4XS29TxZDHGlCax+Uqf80L6v9s7nQhGSIRVfFR7gBhcTzQs4ZQgFu8Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by CO1PR11MB5153.namprd11.prod.outlook.com (2603:10b6:303:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 22:03:13 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::8f29:c6c9:9eb2:6392%4]) with mapi id 15.20.8114.020; Fri, 1 Nov 2024
 22:03:13 +0000
Message-ID: <f6205054-c29e-97d6-67d3-dd3544a01dec@intel.com>
Date: Fri, 1 Nov 2024 15:03:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v8 1/7] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-2-tony.luck@intel.com>
From: Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <20241029172832.93963-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:332::30) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|CO1PR11MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: eba15781-e3b0-4da3-000f-08dcfac0fadc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0JlUHA0KytkVU5yM3A2WDhOUmFGUExxY3c5Qk1OYnhXMzlrUHhYaTlQelBU?=
 =?utf-8?B?NUcwZjA2N2ZlKy9IV210dWdVRmgvV1ZiWmhNMHNGWnVIMHc4OC9ZZHZsRGZU?=
 =?utf-8?B?U0VZZHBrdDZTNVdGOTdjQWpwTWkvWVlYRDRVWWFaK2xvUnpwS1RQdzNLTWgy?=
 =?utf-8?B?bkpRaWl3eTF3bGI0WlJDRW9uUm00M1JLeElZVTYxWkhFRjBSN1B1YVdIMzhz?=
 =?utf-8?B?cFRkN0M3OW91aXJjbzFqTXFVaXVQVFFhTEx6R2t6d1A4MXA3K2lpWlBGdEx6?=
 =?utf-8?B?YjFNZS9IUGRuTHc4OTZROWU5RFRUQ0s1OFhaeGF1OVFOUnY2bVNqMGxSYzlV?=
 =?utf-8?B?aGR0OGp4S01SZVEvVndTN2ZUQTdSYUpPVVRFckVYa2V3ZHlYaW9KcXVxdlEw?=
 =?utf-8?B?REZrVjY4M08yNGtGMVQzSExRSmo1YVJnbXFsemU5NTBaeWlzbnY1ejBhM21j?=
 =?utf-8?B?NHRjNjBkdjlhN1MybUxtVFcwdkpwUUliejR2MTluVGtxY1B3alhvN25ldENH?=
 =?utf-8?B?S0tEcnJGNzg3citFZUNab3hVL0tpM1Uva0VvcVBhakhPN01LTVgxc096N0lv?=
 =?utf-8?B?aHQvR1djdUtkTzc1c1FwTVh4MTJjQ3BsTFZmTFBsYlFKcXVMcFdTcVF5TVI5?=
 =?utf-8?B?SzJsWFpBU1hkRno4VXBoQUFqTDFraml0ais2dTJONUZma1Q2WVFKOFJZc1BT?=
 =?utf-8?B?SzNZdHY1MjhxQzdoZWhSTSs4RXlPTkxOUEo2bWlXZElBRUlaSkE3MWRESWRV?=
 =?utf-8?B?NHNHOGJjNTdkVFp6ZWpBRC9xQWgwNVZqY3JtZ2dGa2FyODZHbStMdzZiRXpD?=
 =?utf-8?B?KzdVdnlsdUZNamNtVzhDLytpT0tsa2ZJTTNNeFpXNnB4S2xGQ0d1RWlFdEgy?=
 =?utf-8?B?U09aRS9Lak5XMXNFOVpIWUZ6V2ZZTHY5eXBNaS9FRjRSRkZuYXFpaTRPOWtz?=
 =?utf-8?B?aG1PbzE3R1l2NjlKbVE1aCs5UFZFbndlRzVWb2YxT3NLZzNseEhaOUk5cUt1?=
 =?utf-8?B?V2tBMU9MQzlDVXhzdWZ1clVLNjNJVXo3MWpuYThldHc5Mm9sZHExZzVneEVv?=
 =?utf-8?B?VnFtUGFnVWplQ2VGVis4OHU1VzdVN1pBanErWmdzb2RCRVRySU5nUUxtc2dI?=
 =?utf-8?B?dnYzeE91Y1c2Qms5R1BNWFpNVVFSbjBoV0pVS3FFQlRnR25VZm55QWwvV3Y0?=
 =?utf-8?B?dFFlN2ZwejRYRkxaT3QrSjZxVS9hSGU2NEtOdUprcHZJVFptdUk0VjBCRmlJ?=
 =?utf-8?B?ancwVUYrV05XQ2tpVG4ySDQzMk5JWHNTaEtoc1BQUmZTUWJ2NCtRZkFOUDhN?=
 =?utf-8?B?K29TbDArbmQ5VE9DY2ZPMXV1VDVMZm4vLzB4U29qUUJrenRQM1VoZGlwRGQ0?=
 =?utf-8?B?alBUcHNNd29rUDhub1pWZlcvMkFvK0pZb1kvU0RaYTZHaWVYeXJqemtEcVlV?=
 =?utf-8?B?VEZ5SUVMUmJLa21naEhNOUJ2RnJkOGNVQ1VrVmtkSzFab0RSc0F2Zys0c2hY?=
 =?utf-8?B?YmVDMDhGQmFtajVoNll2S0daU0JVUTlxSnN6TGUxYVZuR0JWZGZFMFJ0SklX?=
 =?utf-8?B?a0JkUDkvWnoxWTJqRE1ISUdaSWRaY2srMTlTLysxVlExOGFuM2s0L3lXaTBT?=
 =?utf-8?B?SVFEZEREYi9wTDFJb00weVdObEw0MGs2Q1ZMS3paQ0dCVzVtQXowMldqZmlY?=
 =?utf-8?B?UnIrRnlWMW1BZy9xQVk0WXhlL1QwWTE3Z0pKcStseHBBbWtQWkNIREVsekpn?=
 =?utf-8?Q?d7CfyDlc43kQ9knH4bKuDeKE+LNqL0v/XU2vhC6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2luVU13ZUZ6TklLR291b3hac1IwUUM4eWYvMHloaXFJVmpJbWNpcGUwVitn?=
 =?utf-8?B?QU50ZUFuOXdCNFI1Ui9TNHZnNHZla2hzUFl2WlR2WEU5RG5lSENib2NmWGVR?=
 =?utf-8?B?andaZkh1UG1jSDZ4NUxrVkJhTHAyS2JJSDNQaGh5b2FnV0hmTWx3VHNUaEtz?=
 =?utf-8?B?eHp0Z2grLy9mUVdPbldtT1Q5T3JQc1N1V2VFUFEyRzZ4Yk0xZmFPRnBPQUxp?=
 =?utf-8?B?MlZSTTJTU0JSZVN3UzBDUERJQmh2dnAzTFBPdWVkdXpwbnV2VXd5Ky95a2hV?=
 =?utf-8?B?dVlIbGpJcE84U043bTBDZGpicGVxVFIrZm1ReEtadVFPNmJYbUZ6YjBVZzhT?=
 =?utf-8?B?cE5veXk3OWJSQjYrOHJKalhaVHJ1aVhJcVpCR2hvMUpkYjdqSk42TmQ1endy?=
 =?utf-8?B?UVQxUHlnZWplVmR3d1BLL1FWWllMUFNkZkkrMThpS3MyaUtNVlozY2k2eFN3?=
 =?utf-8?B?dXVUNWF0S0tIMVhYcmVjWUpZMlB1bzdndVlFb2cyZUVtdytBNm9BT2NtTG1w?=
 =?utf-8?B?Zk4wUWVzS0dJVGVFTExzMU5hQlZHRnRkb3Q5cmNsRjVZc0Eyc0xQdkw3dEZh?=
 =?utf-8?B?c05qYVBuNWlRT21YVXF2RzVTb2I5eEwzbE55b1N3M3c2d2R6a3pweHlHT0tz?=
 =?utf-8?B?NWRvMjJvUW5yUTdHeWEyYml2NnI2N3U3Z253RWVhMU03T3h4cnZYbUcxclA0?=
 =?utf-8?B?a2NGSFkrdzNrbGppMjJiQTBhSVVJL2xOQlZpUTRlUHgyU0lkWm53dnMxSjMx?=
 =?utf-8?B?cmg1NktXYitBeFdLSUt6bjFtLzdianpwMmk2VWVBU3BXQS9pd0x2VGNLL2RN?=
 =?utf-8?B?MzdPMXcwa1FFZlM0SU9jOEU5ZU1GL3dCTFdZazhOUGZCMW1jOXlFMXFJcTVE?=
 =?utf-8?B?K3pldzh2YTRNNDlGY2FmMWdZNk1vQkplMGpPd2FsWDJabC9reUdiVDJ5c1Iv?=
 =?utf-8?B?SUFQenoxeUNZVHRWQlRHenNzYmg4WC9QSmdteWxRN3dpRnhEeng5dnBVNndR?=
 =?utf-8?B?UW1XZkF4NnZXTzhmVGw1OWszYWV0VjJraXVmRHl6OUREcUxSWE9zdTVSZitx?=
 =?utf-8?B?ZksvNWE0cm9NQnRDOTdmcDhYWFVVcTJZMXNRVjBtWDJkUFBqUVhHSHg4R3VS?=
 =?utf-8?B?QUhXZjlDaUs3emcxaTVzRk8vN2JLS1Y5bjB3Nm44UTVZRlFMeGVuWjJnU0RL?=
 =?utf-8?B?dmtxdTFwLzVkUlVZdzdjSDAyS3VJTHVvMGhVMVR5UzB3Z2JiaElLV2NYMFNk?=
 =?utf-8?B?b0dCRDFteGhPUmdtWmltNGU5dEFhUEZERnEyQWlRc2Z0RU93enBUUTdORzZv?=
 =?utf-8?B?OEFOajBHOVFZRHZybVpJTWNid09ZT2xqeFIrMVJxalBUZHBQSTEwYnJpY0JQ?=
 =?utf-8?B?RDd2M0RqZHFlWHoyL0ZTa2JaeVlmZjVEN042Nms1VXJsVWtNVnptWmhHaSs2?=
 =?utf-8?B?VTU4R2I0OHhiL3Z6UlROUXdiNzBlR3d0d2ZoYXR1aStCTmNnemhacTd0MCtX?=
 =?utf-8?B?VVVFVEJQS21sNG9oL2JsbnFZNGR0VlNVaDRJR1FFMGRSNEZrbGUxMWd3Wkdx?=
 =?utf-8?B?QzdvWVFVU3g0eVRIVE1Fem9FblJiSGE0cDVLMFRFVE5FWVhxMjh3d3AzM3h1?=
 =?utf-8?B?RzNtVFJKZEV0RnBsd0Z2OHkrWk9wbkhraGRrNkR3K25IbkNYRmpEN0htaGJh?=
 =?utf-8?B?NlRvMDgwRk9OUnlRb0k0VUFrQlZka0R2eVpjVzRnQzcwbFY3K3dPbWhTUlJi?=
 =?utf-8?B?dWw4TDRYMFZKNDRkOExtMlBTVWRJY1hxOVJwT0x6TFZmRndOL2RTNWRaN2Fx?=
 =?utf-8?B?cVQvRFVyNjJhdXRmZ255TlRSQStvMGdpbVdhYmZBVzZKV1BhbE1BRVNoTmdI?=
 =?utf-8?B?eEo1aHVMTjNRMFg3ZC8zU0pXYUIrNGJRU1kzNnp6SjJWK3RoMTh6RENlVG5x?=
 =?utf-8?B?eWZML3hjcU14V1VXb1JFWEJCWmVvQVRjYjdWRUZDV2doald4Rk1PR3krWlgw?=
 =?utf-8?B?UnBBTFhxVkRxdFNCNkgwVHRHS1BnRW5EbHRsNWNndHp4d1dhTng0Q1NFMHNZ?=
 =?utf-8?B?TXc5cDZnQ0VOTUdGUEtjT2ozcWV5MGRCcFN2aEtWSmlPT2E0VjMyVUY0YkRw?=
 =?utf-8?Q?ad5PJtVbK4ubVrHpcnNeMscfg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eba15781-e3b0-4da3-000f-08dcfac0fadc
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 22:03:13.1207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WDBaFivHqb/LkxpGuNb0nStYG3HFbim2IkcCiUUU4e/2WQls08PF6jIPkYb90z9jqiwlIJqxyXAozYXAy94Elw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5153
X-OriginatorOrg: intel.com

Hi, Tony,

On 10/29/24 10:28, Tony Luck wrote:
> Resctrl uses local memory bandwidth event as input to the feedback
> loop when the mba_MBps mount option is used. This means that this
> mount option cannot be used on systems that only support monitoring
> of total bandwidth.
> 
> Prepare to allow users to choose the input event independently for
> each ctrl_mon group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h                | 2 ++
>   arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
>   arch/x86/kernel/cpu/resctrl/core.c     | 5 +++++
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
>   4 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d94abba1c716..fd05b937e2f4 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -49,6 +49,8 @@ enum resctrl_event_id {
>   	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>   };
>   
> +extern enum resctrl_event_id mba_mbps_default_event;
> +
>   /**
>    * struct resctrl_staged_config - parsed configuration to be applied
>    * @new_ctrl:		new ctrl value to be loaded
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 955999aecfca..a6f051fb2e69 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -283,6 +283,7 @@ struct pseudo_lock_region {
>    *				monitor only or ctrl_mon group
>    * @mon:			mongroup related data
>    * @mode:			mode of resource group
> + * @mba_mbps_event:		input event id when mba_sc mode is active
>    * @plr:			pseudo-locked region
>    */
>   struct rdtgroup {
> @@ -295,6 +296,7 @@ struct rdtgroup {
>   	enum rdt_group_type		type;
>   	struct mongroup			mon;
>   	enum rdtgrp_mode		mode;
> +	enum resctrl_event_id		mba_mbps_event;
>   	struct pseudo_lock_region	*plr;
>   };
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b681c2e07dbf..5b55a7ac7013 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -958,6 +958,11 @@ static __init bool get_rdt_mon_resources(void)
>   	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))
>   		rdt_mon_features |= (1 << QOS_L3_MBM_LOCAL_EVENT_ID);
>   
> +	if (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID))

Please change this check to:

	if (is_mbm_local_enabled())

> +		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> +	else if (rdt_mon_features & (1 << QOS_L3_MBM_TOTAL_EVENT_ID))

and this check to:

	else if (is_mbm_total_enabled())

> +		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> +
>   	if (!rdt_mon_features)
>   		return false;
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index d7163b764c62..dbfb9d11f3f8 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
>   
>   struct dentry *debugfs_resctrl;
>   
> +enum resctrl_event_id mba_mbps_default_event;
> +
>   static bool resctrl_debug;
>   
>   void rdt_last_cmd_clear(void)
> @@ -2665,6 +2667,8 @@ static int rdt_get_tree(struct fs_context *fc)
>   	if (ret)
>   		goto out_schemata_free;
>   
> +	rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
> +
>   	kernfs_activate(rdtgroup_default.kn);
>   
>   	ret = rdtgroup_create_info_dir(rdtgroup_default.kn);
> @@ -3624,6 +3628,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>   		}
>   	}
>   
> +	rdtgrp->mba_mbps_event = mba_mbps_default_event;
> +
>   	goto out_unlock;
>   
>   out_del_list:

Thanks.

-Fenghua
