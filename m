Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F276156886
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 03:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732074310; cv=fail; b=Ri824PG3KDcxHLnzbdPAL8rs0hGSyzrdisd/ixrKuANNpjlgiILe2w4ERL9nXzOpq+LI7hE1omkcW8CZLelhU2NDVtQozPKoe/0L8z/d20Tbb6q1mfFW5x9ZgHa1QL2+dbhrGMjMrHXZfXxTfuQXMWnByJuGtJDaIAt1sscKVr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732074310; c=relaxed/simple;
	bh=+zTRJZbojFuGefbu3RDIcps9VUfFb53uBK+bYCcTwPk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lNfos+/ARymbP7MLaScBjLFsFP26c6czkuBUtqGKRDWjG1r6ID/hgzXggmL9zjWlknVy5v7krJknQ2SwUUMPzIdja/88rJGFCJAVrD2OpOzocivbyON7VbwRTaPwPn10Et2qUrMaHnZned9mdlwiZ28jH0InPdhpdk32J67V4V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhkzorit; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhkzorit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732074308; x=1763610308;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+zTRJZbojFuGefbu3RDIcps9VUfFb53uBK+bYCcTwPk=;
  b=dhkzoritHagu3Pi4aYBR3rOS90dbsQJe7LexqW4cTWyxOsmBTOLntpOi
   7S2X/FOFhtPAmyHMVBcP+KuvjkU/V8u2yZgqv8gTtIhyjNyC4mHf0dKP7
   Gm5uWHjuleQ5LEdbQ4FmobBPr3OiWDiQaR5THVu7xC+o2lJ0cqBdSNMwJ
   /ckgulSxW2LzYM9H+RIHNP58fKJp+2aVxBlRhHXTd2OxWsttRdGt8BApX
   oCVHHskPcmRsThlLLeulqFM4iG0am7lGkjbpdY+aqatYR/7ZI13QB+m3s
   HgWqUCddOd+8437GcBFOi2QDlMOTw0BZUZFAw8J2pJoqP4vLSAUG+llj+
   Q==;
X-CSE-ConnectionGUID: YnlnYEZMSny4RMCQsVIGmQ==
X-CSE-MsgGUID: WDLLf5DTSHWLGmBJtFQ1gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="32222507"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="32222507"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:45:08 -0800
X-CSE-ConnectionGUID: SbygzzXkRxSB79CmYx8K3g==
X-CSE-MsgGUID: SXuiwYsZQKylKvVf8C7sWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="127321019"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Nov 2024 19:45:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 19 Nov 2024 19:45:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 19 Nov 2024 19:45:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 19 Nov 2024 19:45:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wyyLNRbVmAeOneza8+VqfgQMYDs0zfPBStfHRY5Exuf2AWGa4ecCCWihm9NQcfTsEUya4CcwWlcu1VIIbGCQ6U79qlzXbs/ZjQS8LI8HIb5ZaeZJun048HwZYSyapjS0iYZJi+9fcYYNGBrph+2X7gDM6QtSDTQ9gUl52ryWFbo7vHImWV86gaX3KLK0q5O/q9mICwE4CvJwX14yieyIHJnm5iG+tOLgOnejk0yiBj70OkkJ1a6d3GIJmXHx6+jlt5BS+fFFs8EU0R5vY3aQzmSQsJNy2vukg9zNjUmJ1pfgwJlZW7abSfeo4A0Ng3BuUxC7fWcs75PqKl6WoLyKLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewwvs6rnsfbIslKaaijreTQ98+hp3VYUR6CHV24PwXA=;
 b=E1qA3Z0sUTakumERE8l3yD4UgZr32XJQZo9Y8PFGb2HZbY6bEBtkA1IsJScqgdxLjZdIZsPUGqXjhyey+HkKtB/eYOev5Yg1+h1hSc5+ZSzlY/kktaQnEdajPq8x8u2RjBGNx9qeBctcTxs1z2NAV3LpQYvgd3pzAjL/8MBZ9q6027Dec/urcMHa+lc8Il66jxtYooF0P23PvkSLxrRuIb5B4l2HLuMDjmJeBvhkjtgkgySrAtY7sygpaevPnrzVkPnbz44E7jlDIozuFkosl0GqI36yGLY+qamGIx/y+kmi9Ngxia0JvPXe7vQnDs7P9j4sFyB0q9GNalMZSfKD8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL1PR11MB6004.namprd11.prod.outlook.com (2603:10b6:208:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 03:45:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8158.019; Wed, 20 Nov 2024
 03:45:03 +0000
Message-ID: <6fada5bb-7ca2-4f6b-9174-109c429e8d68@intel.com>
Date: Tue, 19 Nov 2024 19:45:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/9] x86/resctrl: Compute memory bandwidth for all
 supported events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	<x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0368.namprd04.prod.outlook.com
 (2603:10b6:303:81::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL1PR11MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 28838291-ae99-49c1-7772-08dd0915b7a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VTFIU08xcWd2YlMyemJLTWpNL2w3QzdPc2hKRkVzSnB2S1loQ2pJVmpQRkIv?=
 =?utf-8?B?N1lRaEdoY0VjM21KUFNMaE8vN2VueVQxdE1yUG9MM1R0RWZoblBTVC9vYmF3?=
 =?utf-8?B?ZHM0SUJUUGJybVRzQUZtbGNOWEhZTGRoNnVyMFBPNUlmVkEyY2g0d1NkZitD?=
 =?utf-8?B?endMRzJHNGZ3WDlCVC9jL0ZuSXBGM2c1MzRsQUVHdHdoVjRraURkWVlGWU13?=
 =?utf-8?B?RzNMbVE1bXlPNmVmOG9HVTMzcDNxUThEa2sxOHNGRWxZZDQwNmRXWXNSMEtw?=
 =?utf-8?B?b0dKUHhEL1R3VjJrVGxjVFFmSWx5a3MycHErSVo5VmdhUDlRakpXR3NuS3Uy?=
 =?utf-8?B?SmZQemJSZHU3dGRsbmxVTmNKTi9oNXRYVHB4RGU5bHdRemhmUzNLZEJBb0E4?=
 =?utf-8?B?QzhwSzhUNk96Z2dZQ1RCRjJ6bFpDN2tIVWZNUE13QUhPd2xEQVU3d0RyZjNx?=
 =?utf-8?B?Z1ovQmVRTWwyQi9aRFQ2emozY21WUVB5Q3hqeTdiY1h2KzlDVVVPZXhFNTBl?=
 =?utf-8?B?aVhtZ3dOdnExWGFGelh3VCtRNHkxc05pY1lOUjlsSXpaa3BiQXZNTXAxU0VS?=
 =?utf-8?B?OGNGWjBlNnQ5ajk3SG5TdUw2UEhsVWdVTWZpYTBvZ2JjeTFZbnBsaC9rdXJj?=
 =?utf-8?B?K1JHMElzcnk4eW4wOG1LcFVjUFd1UloxenI0Ym9WTEVmZHljbFFCSGFDLzN4?=
 =?utf-8?B?OEYyUFdPUWxicndkNk5LUnphMXpWeFh4REdQU2lFM2NHbENzQ0ZBblYrVHdB?=
 =?utf-8?B?OUtBREhtLzlVVkVuZUJSQXVzbzlVRjcwMXdMVHZ3ZTcxOVpZOEd2VzlQSDlZ?=
 =?utf-8?B?VFI4OHdFYlhDWVdZcVdpL29UNy9TU2gwRzRCME1YS3F1TlhydjFGeXVZNjR1?=
 =?utf-8?B?TGpuREVvU2J4b0d2QnFPWU5NenBJREpUR3ZWWkNmYVNWc3A0dHQ4b3EzN3pi?=
 =?utf-8?B?OVR1L04zQW0wZEdYb0N6L1BQQmp6UDR1SnpaOG1Nbi9lcXJNRHE5NTZLTGdN?=
 =?utf-8?B?R3VPekkzYXI1empVZ2dCM1hBOEZ5ZGkzRW9uekZOTzVCamZPZ0hLZmEyWklW?=
 =?utf-8?B?SW51eHRzdTA0anFaNDJudmwyN240S0hkcFZpRDMwV2xxOUFhenRBTXl2SWVp?=
 =?utf-8?B?TWRMYnpZd2hFQnFNUFRhQkRwbzk5bDRvRmtVa0JaVW1peGdkNWRVaVI0OFB6?=
 =?utf-8?B?b0N2RjhUMkFHZkNmaUl1aFR0RGJ4K2JHSmptVTBHT1dMY0I3M05Odmo4bkZz?=
 =?utf-8?B?Q1NLanpJdUl1aS9Xb0NpZm85a282b09uQ2pjcU5KMDVKTHFnNjlwTGR6NWI0?=
 =?utf-8?B?aVlEM241c2R6UTFqZFhXMEN5b3o5eUw1QVZLNjA2ZGdkR29BYld1aEN0TzNt?=
 =?utf-8?B?ck1vMFRFN0k3SEd4dE9kMVJzWXVrbzM3enVoQzd5VWhXS3loZXZSZG11clNL?=
 =?utf-8?B?Qis4aGoycHZxeFRhclNBOUREWWlnS2FHRXBPeE9sR3JVUDRHU243Y3lMejVU?=
 =?utf-8?B?ZXRDcE1LQUxiQ1lDdHl5VFZMalpzdWVYUWRSaXBQdDl6dnc1ZnFrVVM4S3Jv?=
 =?utf-8?B?TmF2YkdoczdYampwbEsrcGNkbkd0TE0xYVY4K1l5Vzd1VU44QlI4NC9aWk5I?=
 =?utf-8?B?OWFHcW1rQ0xqN2pjN0VWaFppUHNueXlBOVc3Sm1kSEw0M0VJalFLb1NDWjVs?=
 =?utf-8?B?Tm9VRVpTKzVlcWVLaHR4M0I1WG5SYVlxTllWdXlHSHpMeW1VS2xxVlRxcnZD?=
 =?utf-8?Q?1zUHFasBhnTve0g8ptBwVq/adgONTWAagm9mDZI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dndlK014U2p4Vkw2bTcwOFBXZ1A2eVBGNks1OGFYNHZXUEtpZGcxRmVOd3I2?=
 =?utf-8?B?b2IwSEFyRjg2TUpXNmxZeGtkaFlSZEhOZk9tVzRiazBvRjRkcnp1TjhWS2U1?=
 =?utf-8?B?bU55T2lLZ1YvUmx4cUllRzJIWDlmbXU5b2RUM1JqY3JOYTBSbmphUGc0dTBn?=
 =?utf-8?B?SFZKeHhuOFZQcHp3ZXlzaW55b3hJbnVKRWIwMVNvY0xZTFc2cml4UHZHb3dY?=
 =?utf-8?B?RmwrNSs1OHozc3FjMDZtZktFamU5bjZITGdTOEp3bXFEYlUxNGovQjY5RUxm?=
 =?utf-8?B?WTJGQjdJWWt2SVNCdlorRmZ2YXNMemcrSGIzQUxZSzIvS2lmdWlzNHlDWklp?=
 =?utf-8?B?OE5SQkExTWdoMmZxUlBQRHRyalpiSXhialk2bWxJV29RbG45Sm9DUGVjQlI3?=
 =?utf-8?B?cW5MY3A0d2g5NCs4WDl2dmFnYTkyTU9LVkE5ZitpT2w3OGszTXh2cXZXVnFy?=
 =?utf-8?B?cHJvM3Bsb0lBZW15MDJ4b1dhVW1hT3dWL2R2b3A5RlptRkRCeSsvMmNLQzRy?=
 =?utf-8?B?SHFxbmtCWnh6ZnNtVXdkQ1RzK29ucmFta0J0Z09TL3p0QnY2d1cxUG9aZWVr?=
 =?utf-8?B?U0dGaHB1M0p4YUprbTNPNFU2dHl2cjNoN2xjZW5qNkdPT1BBUWZGQUVQOXM5?=
 =?utf-8?B?R1NFdEpIYzYxS1R2b0NaSWQxd0lDRGozVGVhN0c1a3VXRVJJanZTdG5CREVZ?=
 =?utf-8?B?Vk9EMEVUQ0FjbUZndHlvSmNsRU1TMmNuTmpSVmRpREpVcGNaTlhqdmIvNEE1?=
 =?utf-8?B?NTlVM3dqWU1UNVdKUHBrYkZCWG9wZUN1bStQd1JYOTBTTnZidHQ1MVZhOTZM?=
 =?utf-8?B?cVd1Q1B1dmtCSXRzL21zOHJlQW1oSHI5emNTSGRoOUo1WlV6cEpTZmtBYXlp?=
 =?utf-8?B?NGtldjBkYndIcytjaEs0ZlBFaFl2TXVTcGJMVVZjTElnKzcvTFNUUGVOU2Js?=
 =?utf-8?B?YitzYnU0MTRRTWk4VWZURGhudzRIdk5yZVBlRVhteGxSYlFoT3VDSUsrM3hO?=
 =?utf-8?B?YitEMlZWbnpPTkdLdFhQTjV5SVdaVDVuc1czem94U1ROVjJFZngydXdMWXY1?=
 =?utf-8?B?K2RSeGN3NUNPY1dxRkswMkloZFByd25yY3ByakcrUUJDZzVsRitoeFA0ZGVR?=
 =?utf-8?B?OG1zTjVqRmczRGVYMXJNaUpjYWU2TmZRWXNwQkt5Nlc3VElBTkhrT2JhNUM1?=
 =?utf-8?B?aUluTUdzMWdYZ2xjSzR5b1VtRmQ4ODdBQ2RpVjc1aldpSHlQNmNBbnlzdy8y?=
 =?utf-8?B?aEJWRy9iZDhxM0JhSkt2TjA4dUNOYVYzOFE2SVlaZDN3a2dsellsTjZFZFRE?=
 =?utf-8?B?VHU4K1VvajhKYnF2UjJXU25wSGlpQUtwME5INW9ad3lERGMwc09WdVJvc3VQ?=
 =?utf-8?B?RXJnd3A2azJFdEZiTkJtNjVXb3ZKVk5yblhycUtHZzZCb1FnUk1ISUsvV3pT?=
 =?utf-8?B?MThhQ0xacVA4OVVjdWlPbk02TnZCZGZLanVPYVo0aVlSZ2hZMUIyVG13TFFY?=
 =?utf-8?B?QXNLbENCeXJrVXBUSDEzVkwzODNISm1XWFk2L080cGdIcmVhSHBqWjdtQXVH?=
 =?utf-8?B?WnhKZTFJSFYrVTgzQUFaTTByaXJpTVhYajZjaHlZSU1xbEp1L1J6MG02MlZ4?=
 =?utf-8?B?WGgvanMvczFrbTU0dWtqY0EyTENvbGtiUVp4dGVxY1BlT0lVZ1F6RmUzdVYr?=
 =?utf-8?B?QWpxeUp3bjdFT25TZU9DNGZpeUM3RjNMWXFFamxhMm9qbngvTlk5cUFTQmZj?=
 =?utf-8?B?OWd2ZkdMeXU5bHlPemMzMlBteXJNV1hqK2VyMWs5SytiVkhGM1ZPQVRrbmhi?=
 =?utf-8?B?LzVWL2JBNUQ0a2FBL0dmeHcyRElyQnU5V1pkVGc5ZFYyb1RUWjJTR2ZoUkxY?=
 =?utf-8?B?UVFVYW9YVmR6TzduMjhGU2tBVXZCVVBKR2JFN2ZlekRUbGlOYm1wZmZRVWQ3?=
 =?utf-8?B?bzJWZjNYR3ZTRC92NFkranRYbVBDU0RvNTlGc1FObnk1ZTRMZ1l0bndySnE3?=
 =?utf-8?B?VzB4NjFoZTcwMnlNTnRQbWxCWHZpVWFIQ09VbHA1NmIrbUd6QzBYQVJ4dVhh?=
 =?utf-8?B?R2Y5VXZLY0FYUS9xYnlGT0kyLzZzR1J1cnJOb3JJM3p1Q0tiV09qOEhYZ0pR?=
 =?utf-8?B?Qi9ZaXB0Z0pkQnV3Q2FSb2ZZVDU0MlBBMXUrTEx0VnRad3pHZG02c2RFRUZ5?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28838291-ae99-49c1-7772-08dd0915b7a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2024 03:45:03.7821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5QyQ4hRcAZAGqyz1D31KkDpOKUdFSj4vI21980EaIf/eCpH8HyDnkVMCaAn6K6CeEC6S6gTPaqUqyRctwCnnnEnB2jhR5KFBhi0jbZXd9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6004
X-OriginatorOrg: intel.com

Hi Tony,

On 11/13/24 4:17 PM, Tony Luck wrote:
> Computing the bandwidth for an event is cheap, and only done once
> per second. Doing so simplifies switching between events and allows
> choosing different events per ctrl_mon group.

This just reads like some a general statement. There surely can be
some context, problem and *some* description about how this patch goes
about addressing the problem?

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/monitor.c | 72 ++++++++++++---------------
>  1 file changed, 33 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 2176e355e864..da4ae21350c8 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -663,9 +663,12 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   */
>  static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> -	struct mbm_state *m = &rr->d->mbm_local[idx];
>  	u64 cur_bw, bytes, cur_bytes;
> +	struct mbm_state *m;
> +
> +	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	if (WARN_ON_ONCE(!m))
> +		return;
>  
>  	cur_bytes = rr->val;
>  	bytes = cur_bytes - m->prev_bw_bytes;
> @@ -826,54 +829,45 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
>  }
>  
> -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> -		       u32 closid, u32 rmid)
> +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
> +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
>  {
>  	struct rmid_read rr = {0};
>  
>  	rr.r = r;
>  	rr.d = d;
> +	rr.evtid = evtid;
> +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> +	if (IS_ERR(rr.arch_mon_ctx)) {
> +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> +				    PTR_ERR(rr.arch_mon_ctx));
> +		return;
> +	}
> +
> +	__mon_event_count(closid, rmid, &rr);
>  
>  	/*
> -	 * This is protected from concurrent reads from user
> -	 * as both the user and we hold the global mutex.
> +	 * If the software controller is enabled, compute the
> +	 * bandwidth for this event id.
>  	 */
> -	if (is_mbm_total_enabled()) {
> -		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
> -		rr.val = 0;
> -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> -		if (IS_ERR(rr.arch_mon_ctx)) {
> -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> -					    PTR_ERR(rr.arch_mon_ctx));
> -			return;
> -		}
> -
> -		__mon_event_count(closid, rmid, &rr);
> +	if (is_mba_sc(NULL))
> +		mbm_bw_count(closid, rmid, &rr);
>  
> -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> -	}
> -	if (is_mbm_local_enabled()) {
> -		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
> -		rr.val = 0;
> -		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> -		if (IS_ERR(rr.arch_mon_ctx)) {
> -			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> -					    PTR_ERR(rr.arch_mon_ctx));
> -			return;
> -		}
> -
> -		__mon_event_count(closid, rmid, &rr);
> +	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> +}
>  
> -		/*
> -		 * Call the MBA software controller only for the
> -		 * control groups and when user has enabled
> -		 * the software controller explicitly.
> -		 */
> -		if (is_mba_sc(NULL))
> -			mbm_bw_count(closid, rmid, &rr);
> +static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> +		       u32 closid, u32 rmid)
> +{
> +	/*
> +	 * This is protected from concurrent reads from user
> +	 * as both the user and we hold the global mutex.

I understand that you are just copy&pasting a comment here but could you please
help to avoid any obstacles by removing the code impersonation? Perhaps something like:

	 * This is protected from concurrent reads from user
	 * as both the user and overflow handler hold the global mutex.

(please feel free to improve)

> +	 */
> +	if (is_mbm_total_enabled())
> +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
>  
> -		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> -	}
> +	if (is_mbm_local_enabled())
> +		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
>  }
>  
>  /*

Reinette
