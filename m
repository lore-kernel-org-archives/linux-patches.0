Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED9306D54
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309290; cv=fail; b=PThJZpPD0g4+LlYXOZkqHoOLodZRGRTnByIiD/mKiWtgexxIpOT8MsBIpt1PrpHwvNtjhni74hwToMi1zncVZKdPRQjpiVgGSYWG+kR2bFrHJFxBO6+YHibMolpLKMCAEA8NuPMMCyI1DvvaanlTVV6JX5aem7I19f2uh1hCdiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309290; c=relaxed/simple;
	bh=+oop1uSo1da8a9C48bZhXL/X01SANxTnRLUZWDFe4RU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H5gPA6ezeiCqQonJIds7uLAo2zTTcfjiaW4OZq2dYu3h8GfdShXvujAo3Bdjo/Fd19xtf6Jr0M12SMSVyqcl4fa+favtuGSbxm55ffvTNrMlZ8w8CHvTOD3KQm/IVdAaFeUVEQdEIgmGObOIOQZ1dKW0rXqvz3iwCB/qUSBUGfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKl3mcQz; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKl3mcQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309289; x=1796845289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+oop1uSo1da8a9C48bZhXL/X01SANxTnRLUZWDFe4RU=;
  b=eKl3mcQzfYaDaNmYnSZWQHxYzCFRgfewEot465W4BciUxpqtwOuC3Xfm
   3eMlOWv0KjlNABRhe/rewxL604Gg8eRRqIfrHdjC7AE5jHHjsitameR7M
   1M1hfnnegUJChhOPQdWssufXyU/pNRusryve1mTkvcQ9xWyu/PJs00O6b
   9vXk5H6nBxLc0h92BTfyqlroGrmqACrokyzct6dDOwCuwIlipFxuWgtt7
   //OlFDfJQX+hOUQaWJoh9XmMHZRlUVyrBH7ztmEq1OyagOnXxbreKQXlU
   FrR/TXScqZKy9yk2dLb8d7iyUuf72csSVut8dvr33AbKYt0/humjHa9vY
   Q==;
X-CSE-ConnectionGUID: DNGafGirTZ+PNXQEVgFYfw==
X-CSE-MsgGUID: iTLWbxUKQ06KgZfiA4ouSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="89926809"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="89926809"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:29 -0800
X-CSE-ConnectionGUID: XOhhtMOpT4y4v/2hdsY3DQ==
X-CSE-MsgGUID: czURxhy8RviCfivfjE1mcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200480844"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:41:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:27 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:41:27 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.9) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:41:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sdn6VahVe82/jLvmAAtVbEgHR08wTkNJfvsm7XNIWdDRDbgn9oc5Z3iuamb8A/+9iOxZ6cS7Pa4s6Cw/jOFweuds3IG2QxubkjrQRoGNl0rOuZN8j84ZxrQlGdevcAsdyEN8+16itJ3Et8O5oc/MQuf9zQeKmbLwcRkcQkA+zROkCyAlxSJ2mWJ5sY9saGytzerV27ZVA2aO78s7g/+FlKiNFVkk6Mz3t8hx/wTSQuB0msOIsWXeTD7MZ8qeB7tv9rkAz96iEN3vxdbwkNOcdYK5yD01d+FGqeiUCprlTBkBIekzHIM81ObA5mMPWzr9/9xtBhr940b34aXFDBYtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCwqXQfNjTPYtAT7JwMWIAXyNCrdMi4M03pJrin6TV0=;
 b=VG6cZVHLdcXPY2JTfJSGUsGSEuyD5p5X3vkluu7vYk2eibdLY9kdaUzz69+kfgg8/xS2F919D+htibLo43YG7Ef8VqlTUBHPcRdHEN2ygNTPWX1TPdNLRyT0XwAZmTN50ry4uOb5icmRajBuqzUxqLSl4njf4eM7eMw2PIHz0d9bTxt9Fg4EdATX1OPOzx+mXfw+nixTj1foE8r28eIPcxR1cIzXbbnwq7dNK6Pr/qAiIg2bf/VLax9YwA4jGTub/aRfR3imZ0GCms7flFc29Q73s2YPbGH1G0QoJXNE1bfLdfUx1tW9C7aTEjYsHRjAkuk6RjyCBG9rgrsIs9J7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 19:41:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:41:25 +0000
Message-ID: <ac238824-c7ae-44e8-864f-502a43178a5b@intel.com>
Date: Tue, 9 Dec 2025 11:41:23 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/32] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a74b729-6913-49b7-801b-08de375af056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TkZ1c2pTZHVCOXUycG5GWm1PczVHcFovcVR0WWp6bzM4YmdGaDVnMzNxai85?=
 =?utf-8?B?a2daajhHRXFhcjdwYmNqcmtJS3VDOW5nWWpXNDQ4WkxUUmRlT0VZNnQzQlN6?=
 =?utf-8?B?N0ZKaEJCYUU3NlVlYkdwU0ljQ2d0ZnFpcWN5dCtmbkNRL1ZyRlkwSFRwbVRX?=
 =?utf-8?B?dk9jWjJTcmVvcFppbXpJbWFTVHZFNHJVejZhai8vQzJ2WHpjSnRCWWJhYmcy?=
 =?utf-8?B?elQvRUNzVjAxZytEYkk1Zy90S0d1ckNxNTlVeVUzTVMwUmxpbmRMUlJNaVNk?=
 =?utf-8?B?b0ExYzVjS2E1djVXbklQdnUwcml5STA4RXBBUk1EZk43T3VGRStXdGdDUzIr?=
 =?utf-8?B?VnhaT0RCeHRmZWoybVhTZXlsZUUwNFF6MGJGeDVUNTdPazRVVVdmSHlEQk1w?=
 =?utf-8?B?N0thSWNmN1FFZk1NaURrZG5KVTBvOC82Z1hqMGF2WWFnSVlXUWh1Wit1NVg5?=
 =?utf-8?B?ZHplOFovMEFUZEpqdDZEVnFnQjFhOGVWZjBrdCtuN00yTjR3T3E2L1dsOWZL?=
 =?utf-8?B?QmkvdXFLSW9Bc3ErbkYwTjM4WmFmWUZjZDBoQnNtaEVGV1VEVXhSMzQ2cEhJ?=
 =?utf-8?B?azhWcDZ4RWJxejVxZWtjT1JJOGhMZ2hwcWJId3E4Qm83WEI0bTNCbEk4S2ww?=
 =?utf-8?B?ZGR3RzFRaFlpYXJPbmF1Y0diTnNvRjZYY1dTVUw5Z3Fabm1Uc21Kb2FyWHFY?=
 =?utf-8?B?RzBibWxWK2hVcDRPd0lpYkpKU2c5M0JUU3NuaTdROG9NWUVQOG1uWnc5NFky?=
 =?utf-8?B?S0hmai8veUtHV3dPSTMrYnV5aDQwK29YdGsxQTBYeUxZSGl2bHdoK0hNc2lP?=
 =?utf-8?B?WUFyZVRkdGpaY0xqanNxUkNaSVVCZll1WVVmQXFZOXRVRkdnY3BSMjJFbWh3?=
 =?utf-8?B?TVcyMSt2aUFDSGh2dXhKeFNPNnpBTGkxUlJKSnRsNEtwbE5xdVIwMWxNUmJy?=
 =?utf-8?B?OGZQdzVIY3Y0ZnZlQ0lOZG5IVkJteHhwUFFiL0VBQ1FWWSt5aWRZYXViSmJX?=
 =?utf-8?B?NUpsTHFwaEkrUkxhUSt0OXJqUjVOY3BLWGkvVXBHYy9yT0RKZFRZaHVVaDJG?=
 =?utf-8?B?OUtaQnZMYzlLY1oreHhaUDZOVGMyVW1yK3ZRWktFdDExSkpVejZsWUtYNU94?=
 =?utf-8?B?WCtxTVU0TldhL1ZJaVdBVkZIK1BPQi8vMmlUVlZOMWYwMjA2WWhkUXhabm02?=
 =?utf-8?B?VVVLVFVidXlCeDZRWlk1ajFIM09nUTVtVUZOWEExenpJd0lPTHluRmtFWW03?=
 =?utf-8?B?TldOdTNnc1dHc3U0NWtvcm5icW8zYXF1ajBFZGg4K2V1NExYRWlyWWlwWlQz?=
 =?utf-8?B?cmpLbHdvWGE2MW41aGxub05vTmhyaWYwYmdiamI1aXVRbjFaR29xd21KTDJ2?=
 =?utf-8?B?YUN6SW9iTE1IYTBZendXZTVtU2RFTVROS2pDd3RteUlkajlHMEU0dnZWWi90?=
 =?utf-8?B?dm8xbmRSY2NLSElYc1NKQWdNQlp4My9EY2dnSERuczAwcmpNYzRmbUh6WUZ2?=
 =?utf-8?B?UzZ4cjFCcStYZ1hsZkJPbzZsMWFDcmphM01TTjVmWHRaajl6MnlTbGliWEd3?=
 =?utf-8?B?ZFVtcGZSTElYMlBvMFdMZFZhU3NDSmNUQmNvenNobDhKUVYxbUQ5Y1YzZSty?=
 =?utf-8?B?ZHRZZGE0RmlDVmJJcElyUXhzc2gzQUV3OE05M2V1NTR1UUdvd2RDQlBnS1RM?=
 =?utf-8?B?MFM4eDczeHZEdHNkQ3VBekhLVkhRNmgvNVZGMmtGZ1NjaS9RV21hSTJyaUhK?=
 =?utf-8?B?U1ZoaTRqZ1JGYW1YcHJMVUErVHRFZksreGZKaFd1aW5XUWxheGVYZ0Z4enlh?=
 =?utf-8?B?OWJwV0cremxzQ0UxOHBXRlBXNHVYRW5nZ3MzdE15ekpXNFhyYXNkbDFlQ1p5?=
 =?utf-8?B?VnUyUGdjcUZZRHZVT0Y5cjV6V1BEcERtVDlBc1pWMk4yVThBaGZydHBiVG5F?=
 =?utf-8?B?cXQ5cy9DWkk2TVA0M1M2R3pUZ1ZFaTlTRVd1L0pnR1FEeXpMSDB4cElVRVls?=
 =?utf-8?B?UFZYVUVjOVlnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NElaRlo2UUNlaGdwYXN3QUdwVXVEYVR2TGJTWGY4cDlDYXpXa3lISC9BSWU2?=
 =?utf-8?B?S3pPNjlGRkN0c3J4MUtVazIxYW9BNkpDZWVoTzArR3JFSitNV1lLTnRZNmth?=
 =?utf-8?B?OFVFcTluRXNJaGJnRElCL3ZlWkJOZk1ZQkdnTkFrMnR1WEVPeVJna2JZVzl0?=
 =?utf-8?B?TlFvMlZST2tLRm12LzNiMTFOS1dWNkNWakNSV2xHeFE4YnI1Yk1MZW9kS3ln?=
 =?utf-8?B?NFFtV3dNRkFUNTFiWmY5REI0VWhsOFRzT1d0OGlqbC9SRTJZekRoZ0FCMlI4?=
 =?utf-8?B?T1dubVN4cWN0NDRkWHlLck5NeGFNTldPaXN2bklNNmJocE9GTWdZV2hzd1lv?=
 =?utf-8?B?b0RDd0NLUUY3anNZeGJmenRZdnhMQjczdjRwQ2xDdkV4ZS9pMSt4ZlBoTHJ4?=
 =?utf-8?B?c1AwaTQ5c1NRTXo2Z3djcml6TE5mY1JjeXQrZytDN1JzcnpYanlPWENSNHFY?=
 =?utf-8?B?cUljV1BqQi90QWk0YVQwQndkdXlEd2QrbjdHR0ttdmxiNHJmeUNKZmcyZmZl?=
 =?utf-8?B?ZzgxMEk0WEhrVUJwWERyT3pQOUp6MHVWcS9NazV3QjdYSjJxVDBJMzZDZTI5?=
 =?utf-8?B?U0EzMy9hd0FqMTBHMkQvSzkwdWJMd2NyRmc0UHZqdDNJVGJpTmJ5TjY5Yk1a?=
 =?utf-8?B?eUVHZkpXTStFRU8zRWptNVBiN2NRemhUNmF5WGlPeFRLY3N5RjQ1cWpGWit2?=
 =?utf-8?B?dm14c0w3WGloY2dZejBTZGVVTkpYblczR2dBNk9pQlVPVXZwZkxyNENtOXQ4?=
 =?utf-8?B?MUljTnlqTDloMm9sMkp5Qk1CZkNORGM1LzlzWmpHL3k4WTd4ejU0K24vQ0dN?=
 =?utf-8?B?TE84ekkyR3g2Yk83OGl0MzgzbkJJeERQY3hwTU9KVHRvZXJOZCsyZjkvN05x?=
 =?utf-8?B?eFpuQmJQcHZFSTc2UzNaa3lqdDZ3STJFTXZWRWVLM0tFNERENHdoR1hsVjRs?=
 =?utf-8?B?eFNqWWZWNHJZblVjaWtyeFYzR2lIbFNZK3RMRFF4WVp0VzJmWkgyZU1aRmk4?=
 =?utf-8?B?SmtkRE0vVHoxcDhmZDlyVmRTRFlBTWV4VVVOVFRYSGhhQXdnWk1HTlBqeWdQ?=
 =?utf-8?B?T01BcWFHS0FOcnVlaWhIREI3bHk5TE9SNGxmUUFpOXNZVG9tT3M2VHN5MC85?=
 =?utf-8?B?QU10NHFlZjBIejJiRXIyZmtzSGdCQm5kbS9pei96QmppKzQ4TDhYbTBQTWhv?=
 =?utf-8?B?LzRHSklGYUVJcmkvajJDZWFEWENRR3hsQTkrWEtRRUVWeVFLVFBjVnhPMith?=
 =?utf-8?B?OUtFK0Z2bHpzMk9zU2k1ZGtydUdoK1h0dUEvbE4yaDdFalY5NFN3emY2T3JP?=
 =?utf-8?B?M0N1Q3l4ZW9JdXhoOC9EMWpzVlRGWTBUVWJZNGJPYzlrZUFWekt0a283Y1FE?=
 =?utf-8?B?SFV6MkZpbjdyeWRiLzl4MTZORjdiOGVFRm43Qjd1SE9uVk5zY0Q0TGEvWWpW?=
 =?utf-8?B?R1NVWmtCdXRHcjlBSFZEcGtHN3RZWmQyOUVST2Z1dHd2cUtmNVVFeEZ6bVNt?=
 =?utf-8?B?R3FsMFlVVVNjclp3aU5yUFI3eFZ3Q3o5UUhDZ3l4UjBvMWxvOUZBeU5kWjJl?=
 =?utf-8?B?TkZtbnhYTTNrV2dvTlorb2JtZVFwOHYweVVBalhQMTJLMnZ0ZVM5cmQ1UmRX?=
 =?utf-8?B?bm9kMkdYWVJSRDNCZnpWRlJoalp0NWtmWWo3am05QkRsdjNRVjIxczRMbDVs?=
 =?utf-8?B?MHpwdU4wOEJTRHZDaklVRXpwVHRQcTUxS0hPSnRlbTBpeUdueFh3QzZ3MkJs?=
 =?utf-8?B?NzluVnV1Q3RWdnQ5emE5Z29GN003M3ZUTmhEczBLTFFZdldrUE5NSkV2TUww?=
 =?utf-8?B?L0E4dnZqYk1DTkJ4ZGhyVmQraHlOUysvV0JqU1pQZFBCbENrU1AycjRSd1VF?=
 =?utf-8?B?NGI3MmZVRHlhdE9rSFV2VytLaVo4UkFESGh5RXUreUtsRVpZTkVMVzdySkpv?=
 =?utf-8?B?U3ZpemhKK2VYd0R6dGpjbUdjMUlMd2MwdjZEWWR6YjlrWGUwbHY0SFA1VHdR?=
 =?utf-8?B?anBBQ25nZk5qZFJjT2NSMVdoVHQyb3pUNC91TFBKY0pjUGtJenpSV21EWU00?=
 =?utf-8?B?WkduY21ZVkVTYU5GN0JwcCthNWhQaXlXQjIxRU5SNlRkWlBOR0dSOGhQRTFM?=
 =?utf-8?B?SGpTb0dQSHRIUVNQMUIxeGVNeEI2QzliWmpVR2tvOW50Ry91R0lLNVpwenha?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a74b729-6913-49b7-801b-08de375af056
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:41:25.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSTjUBMLRlUmciquZRZ4OwAK/VXdoF92qxKJwE5JOayu3hs0ceuWD80iG3jLit74uDyZAn3E0r+h6WxKn2DylyHh7N/mrd9iT4wklRBuUk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> The telemetry event aggregators of the Intel Clearwater Forest CPU support
> two RMID-based feature types: "energy" with guid 0x26696143 [1], and "perf"
> with guid 0x26557651 [2].
> 
> The event counter offsets in an aggregator's MMIO space are arranged in
> groups for each RMID.
> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> After all counters there are three status registers that provide indications
> of how many times an aggregator was unable to process event counts, the time
> stamp for the most recent loss of data, and the time stamp of the most recent
> successful update.
> 
> 	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
> 	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
> 	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP
> 
> Define event_group structures for both of these aggregator types and define the
> events tracked by the aggregators in the file system code.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml # [1]
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml # [2]
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
