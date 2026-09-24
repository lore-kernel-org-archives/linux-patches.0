Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714CE4A1DEC
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263377; cv=fail; b=Q2N/8r36xBwWbp8fBXulNAMqlADcDAW1Dl1DN3ErkwAQDbxArFzJgxX86weDOGkqdW2/uPdFTAQEIMTFaHwuXaBUuhX41i5Xnz1Xq7+n5u9/npjSZ+BjR4yvwUfNLWtiurx4J+29oUoO1pgDltswtgBF4OoB33AiSv1WpBLG7l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263377; c=relaxed/simple;
	bh=O8z5itCVz4+t8RWKkviaoU43Qf2Uxkf67UhxY6d+eQ4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SNIv6W97JocO9Bx52qaCHutGmnMlPxNo0VdZhA3T50OdmeCxEyTVyp2Z5pL0Dorfy2LFZ9tDXseoMxRpZKY9EKahLUXY9iJE8XAJyJbjmN4QFT2qfCEMUzA7Q/RiHknRWn60Kry7BFlM887dXLTZske1nOhh4Vfw6Vk14+yQ17w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MT+w8S5l; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MT+w8S5l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263374; x=1821799374;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O8z5itCVz4+t8RWKkviaoU43Qf2Uxkf67UhxY6d+eQ4=;
  b=MT+w8S5lwn4Vke9Wv7j+VcIPFbdvMk1ROBzqBqu4qBaNTRWFjQsyw9eQ
   ubFRMmyVsvutU6Qbc7xlVVcCoYZxKDP3Kjx2sRIhihguYhc+ubyN52v9i
   iUQ9te0av2EaOOj1Jg268kASGINXY86kvWvcfl+AsQtLFuZ0Ia2Pzqtj+
   9soHe2zFV78Tr+j6PnJZgT2t6HbWTVixU6Oy7jHoykVBJcRUwbQVJl+wP
   1RkwCDFEWsm1bFQjJCcFupyrfwI2sIULbv4rK/IAzT83BIjqTjYjDrzJT
   gP9A5OW0+hb+Wm+ANhgzpjN26rRBLUFsYRSe/iVufflL2m7yJvgKYd3v5
   w==;
X-CSE-ConnectionGUID: vThTjauVSFiMgFafSDWLRw==
X-CSE-MsgGUID: BBxwF9eRQYOXzsgFb49qlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="116564142"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="116564142"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:22:52 -0700
X-CSE-ConnectionGUID: S0lhVOzjRBKfuSKnpR71QQ==
X-CSE-MsgGUID: 85clxpUuSWW8fX4hEvrCEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="271887216"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:22:52 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:22:51 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:22:50 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:22:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mISFA0pSB5+jsKDcavp9PWdtJv6JCEEJqRAlcpml4VjnE91pncuTZ5jk4K37HqINKeqxOm7/IPaYh64Sz4XV1NQstYSbPlVyEkl0TJQk2bI862BOmo6Ne9bpT383L8/ve1PNT7Q6kesCOzFMV2Qx2Vp+A+qL7ip0EslW+6wfjAjK0ujKRzxpYTAqvq9hXlPn9ZuIxYYQcYCoGBFpZ/4kVpbdl9y/heG+8Hp7Sa9hCwZXjayOtI12Xu6HtZRbPsf1clYzCL65T+94HgezEtKPG3p+lqIaWJV1SP+Hf0W15fFaK7OPUlTN1CJMySH8I4XPRRKQISMjbg7/57PNC8M/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVcDmKlEWoofr07f1+uzYzEtK7Y6RD3AKTbtuDKcWkc=;
 b=w6i+ivnnWohXoBN+CaO8EMSHdie58u2aW0Ks42JMS7WOYb2Zklc3X2ORAeiA3dlcAJ517/KK3eJBpLaAFbv9GMPmrEesZpVaTLUAXK1g6T+3HwUk4h8q4eIs+JElW8jXtAbfK0waKbyjr48XsTpL7YmeSHeaXngl7csAv5r4ytIJrdzQG36utLUFPP1BxuIriSNnDRTf6G541tkl/Bsw6pcx9lqsCIis614pknuuBUinwSTsf+oZCNc753b06/dQPbcO3ht79W6oKT5LlB3dYiPlDKEe+w/U7Lc15q4JCStZZE/ZHi2+daVdb3AxifnelW5S6yhwbNr8QkrEUv2NlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS6PR11MB454219.namprd11.prod.outlook.com (2603:10b6:8:4c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:22:49 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:22:49 +0000
Message-ID: <d0e563ec-65c4-4a00-bd54-61c30d80890f@intel.com>
Date: Thu, 24 Sep 2026 08:22:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/25] arm,x86,fs/resctrl: Replace architecture
 resctrl_arch_{alloc,mon}_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:303:8c::28) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS6PR11MB454219:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e26d5e1-41ff-4a87-7c56-08df1a4fb158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|56012099006|5023799004|18002099003|22082099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info: ufKJHPiCxD6Ts6R0H+2sjXuDjs/jmAUVWXq+97+b7wnZOQABlsLnU3CdifTOuZncpXtyOaT9fRm+AbOMi+QPeuSWi/MWdY8q0TQOcIYAq2itISUNuafPSwHjFhIAbF0RyG36iiMt/eEj7JtTSm8KHTO2dw/DcOolOtgQEyKkQzOPUAbUcPP07OWlelkJWG52iekouL1byLfVDSN849Z8Xelva7PtO06lSY/8tmO9EeTzqMkNG/D0D2VujHPP/WMc9bCi6+aU5ygKRwow+Mj2h5C2J6nlArdTipaMU3EZox8GPKZXXKK9ElBcaYmImfbwfPqayL1pD/sn9WolWXIe32UILWzydc4xWZg8pyWACV9JOTl8Ri+ftEEAeXaJmInoand3NtrZ/GwP+yrJkQHeibSdOPCY+IjBkSWsxDpCt4lM6mKMSAbaZhFFAzbBCp0vTObQUGaYd/q/tloHUk5N7m9kbl9y9FvckctOA/fPQucLD8ItXRmRp4qXISEoGpCysrQprwdjjqYkHG8GcvzniC1XgfSK6RBB0FyBuEGTMyFSfnvMLmjYK/Vx7cIVYwBDvYqcLbQsHl/JcNQHibT9u9iBzK8DL6td8ZGEEbvq1iemw8buElKoxk/4K6cqikgqP9k+X4GYmYYiU7c8AZilQ+lXUlQvhDvJipLJs6R8M4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(56012099006)(5023799004)(18002099003)(22082099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?US8vWVMvc0srOGVxZHRyeis2Y3Rha1ZxNHRLYklCR1I0VmFOSm05MkFaTU92?=
 =?utf-8?B?cWVzbEw0QXI0S1FGZkEzKzBuUE84NmZHUm4xTVJ0NUJkbmNnT0RqWlNqUFJQ?=
 =?utf-8?B?VHdEdlRSL2ZlbmNHRTM4ZllOQUVLL0twQml4Zk9ocDlTTGMrS0d2cmtMcHdq?=
 =?utf-8?B?RWpaRXhXbEpKNkI1OFpUQ04zSDIzOVNDL0FTRHA1NThNVG0zL0psdC9vb1Y1?=
 =?utf-8?B?TFJnRE82N1hnY2dsMWJRY3lEbE8wRkQ0dStXRFI3TG1NRVEwMitYYWRVa1Zs?=
 =?utf-8?B?OGF5OVJiSm14SmJlQVZ3RHoydFFGMHlWRDk3L1FhSUhReUJ3cXVDOVpKaG4y?=
 =?utf-8?B?akJVZWtsdGNDYjlBOW0vQ1dpTEl6cWxoeTRiY05rMWFZVCtmcGpqTDlZYzRs?=
 =?utf-8?B?MklEZDQybVpKTWl4c2t1N2gyYWtJWnFxV0tIbEtLOFRNNDdUVlU2WWhjTXF1?=
 =?utf-8?B?SGFyL1pLZHpaM0wwVXIzR250TjJkbjBwMVFtM3o4aUJ6LzEyNFZ2MzZwM2tP?=
 =?utf-8?B?NkdTNzVVOWtwdUpjbWY0T0tTaGYvY2svK2htR2xCTUZwUDdPbm8rY2h5YUI2?=
 =?utf-8?B?STJ5NEkvM0ZFZEZ4d0YxSU05dm45SDVDNjJ2aU1vRzVaaFNzeDVJMjJFbTEx?=
 =?utf-8?B?RElpVnZ0T2J3RmVrSWFzVStLSTdibWZ3bHJvaEN0ZERRQXIwRVk3bXhiYm5l?=
 =?utf-8?B?VmxBYWtkdnhTbk5EV2tPSnV2SDE1WVF1SFpRUFZMcnc4ZXFEN2xISmlqUDJw?=
 =?utf-8?B?S2dzMEtEYVNFb3Bvekg3OTNnbVZhSWdqc2dnbVkwWGtibDJ1c2IrMXlNT25m?=
 =?utf-8?B?ZVFEalovcFQ2U1d3bW9kWm50S2hvUWsveFB4enNOam1EUHNOUzJIcjYveWhF?=
 =?utf-8?B?QW14YVMwQUgzWllhdHhhdUM1NHZqYjdmOUxzOHRSNXZ5QSt4UTlWMmdKazMw?=
 =?utf-8?B?NnpleUtGMUc5MUZwem9SVEI5enJ6dWdmT2JRb0M1QWN2Yjk1eWdmd1RWRGRF?=
 =?utf-8?B?YVBJSkdFem9VNzlHUXcxUVJlQlpYU1ZINXVCTmJOQWpOV1JwSVJERHdpeEIz?=
 =?utf-8?B?NmMwTWd3UmZSMTI1SWwrUmI1MXlNVUVDUjRaSnJlaHA0YjR2d1A5UnJrRUxC?=
 =?utf-8?B?bU5VM2VWajlLQTBxTVN3Z0JnSDFwRFBaWnBuY3AzMHlCK1UrMzUrWVZvcjNH?=
 =?utf-8?B?RnppYlpwWmw2UmJmajg5eVB1dzhCMlByeldtcjIyRjdnSnBzWGNYT0ExNFlm?=
 =?utf-8?B?NVl1aHZWWTlReFBSS0Jha0FxWHlIendzeVV5R0xkTkdaU3lBWUhGdUkvNzJK?=
 =?utf-8?B?bERlWFd1ZTJPUlFiVHJLck9mNXFzK0FyNGJmajNZSlMrdTdrS1I0bG1TQ0Jo?=
 =?utf-8?B?K0RXNVVUdzFaNXVWWVJSeGl0V0NONTVYK3RhcW1EQUc1VVRZaEMwYTRobTBi?=
 =?utf-8?B?c2p5azlOSXU0YTlRNGVYbTJnRUxwNGYwaDFBekwxUTdWL3AydFBTeFM2YUJU?=
 =?utf-8?B?Sytta1RUVnhKQkZJemxHSHVodnpiMU1IK2tjSGYwdmx2bjByN21pVm5pZXo3?=
 =?utf-8?B?NXZnN01DSWFTQnlXb2IrT3dkcVgvSDlsMDVORkt2Mk1GRTZIbGZVSktJUVFa?=
 =?utf-8?B?RzZFYndpNDRWWER4RUdyeTJDQzROdkQ5TFR5eXRoZGUrZE95Rk42RUlDNFRY?=
 =?utf-8?B?WWRiSTBEVWJmZ1ZwaW5kVzNNZTh5V1ZNbmdSMHRBcVhtNitQZTZ2ajhobHpT?=
 =?utf-8?B?MzR0TWZCMzJHSkJpSktUbFhyU1Vha2lFdFNtanZjb0t2Rm82ZjdjU0hKTGhE?=
 =?utf-8?B?WkpDZFgyZlhCcTFOZjFQYlFoMEVIcUJmK0ZiSCtFZktDNzgvSHhVWnBQU1Rz?=
 =?utf-8?B?ckEzcndoRytyTFpMQ3dJK1IxVTRtSTZOK21TZitFNHFUWFZBbmN0S1ppRDFX?=
 =?utf-8?B?MUljUzZCaXY1TjFrKzV5OWJwYjB2RkVSd0FmMGxFZ2pJSFNiU2dUK0k1WVFs?=
 =?utf-8?B?ODhMTGpMSTRvV1U3b3hSSlhOMWhZWlJVM05OZHM1YWMzRW80RUtmWlVxMXF3?=
 =?utf-8?B?YUJ0K0NBL3hmdjU1aWxwNE5GQlhoOWlwZTNRZ09WY1hNOFlaZ0lVTVBFb1lR?=
 =?utf-8?B?US9YTTd2OUtvNWZXSm9odjNqWEdFWHZBbG1mQ3FIWnVxU21OWmExNDVvcW0y?=
 =?utf-8?B?cURjekFXLzJiMm1sR1pIVkJkYldjZndYS3ZnMjFRNzdicFZTbzFvV2l4a3BF?=
 =?utf-8?B?Yk1hSWVaZGhmYjd4Z25qSER1NUNqVmYvRVR3MkFGeUF6dDllYVZjb0dJZktz?=
 =?utf-8?B?WStBeEJaVkFQckJGRS9kcjZONmhPMzBxOThjdEtvbDBqZEtyK2c0aEtwVDdQ?=
 =?utf-8?Q?oEukUHxM6O4PB1HI=3D?=
X-Exchange-RoutingPolicyChecked: LUwCzTt/ennmah1Fweg8IBkiDqmc/TYPOxSgM6oPzodP3VEk0Th49e8iwMsrkLbVEnDyr2ACkwbjJgH+az5T1Mgqh8ylz4mTMhIV2yn+HIwKHYe07oXZ42eAapXDLdRN5k+LXgMk+M8PgxbAmCX6Od/SNeuo6nl1pW8Q8Nq9RWJjTu3EescUVUqkuaqVQ8/3N2O1pAPPBghsXMKHuZe27qqzgzNFadibMtiOTYvKS42i8ZUapoFsuWE4BVPoFCGFCbimpZ8895UDWdOsNmxwXB+2W+4I8eAfCIST7OU15jL+wyndheJXqAZRc2XKO6zch52bPIAG++U60IZZ/B797g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e26d5e1-41ff-4a87-7c56-08df1a4fb158
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:22:49.1560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCfM+W4uX8uScc6PBfdxvwje+UdJo3yQUfY/rbykOaDj+sPhisFCHtUa3KRarGEuVgHMKFwIVUeVysyHZy6BkzbkQNP0g13HFmYij1ISVT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR11MB454219
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> All the information to determine whether a system is alloc, or mon,
> capable is available to the file system. Architecture helpers are not

nit: "is alloc, or mon, capable" -> "is capable of allocation or monitoring"?

> needed.
> 
> Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
> replace all architecture versions.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Please note that the pending RISC-V enabling [1] is not compatible with this
change but there is a change planned that will let resctrl_alloc_capable()
introduced here work on RISC-V also. We need to coordinate these two
series.

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

[1] https://lore.kernel.org/lkml/20260917-dfustini-atl-sc-cbqri-dt-v8-2-7964e8d73fe8@kernel.org/
