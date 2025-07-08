Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3FF3C01
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007874; cv=fail; b=JBv06UYS5ef2c/PO8NbwTD8kX/QshnPi/URfPjEB7Q2OGO41q6wulpb/xNfiy6Og8ssclUiS/4uwTUZsf65fDpj8b+C2AfXcUKYO0yCRUAJ2+/lI7BlIyjr3ZpYRRgg7SK+0L1afjOGDo4/S+kt/epLgy69m7Q137PgcsaY7QJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007874; c=relaxed/simple;
	bh=S3EGyH9hXyd+dPhzLIAqhZV+H4gnTaSf3b5wPFIY9No=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cszaxvDzBZWpCcx3llRRw2uzTgXFat/WhIYfu8jtPyLe5sn+iy/fj12OAnbxdMcXHMtxThOYOHYzbqtkjA14gDISbGIZuWV1VpXBEgwp5BWf22oiTDwrHCNMOMgtuqFamZWdYaAXcoIqauJ3DMewj6xGE5p3cF43QS+klqo0vBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCmQkweT; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCmQkweT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752007873; x=1783543873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S3EGyH9hXyd+dPhzLIAqhZV+H4gnTaSf3b5wPFIY9No=;
  b=eCmQkweTVZzyOhnt6H8JSIXxxFThrcDIxnLT6yO1QV6huWT9I8xYiiPu
   /vy9dheK+mROTPWtMBw/Ktu+oCGtjHDfyJZeXNX9Zs9wqWX/8tsE4+RHU
   qsTqX7YsccmEwZmz0BfQPKpi3VL4+eG9Jsw52RjQjI3tFufph6LTZImbv
   ziEXzN/M+ScMTArURRjJ9BCUYFcdYdh5E1JBtOCD3CoC60wks+IFq6wM8
   pDdnm5aJevDg6HmZyvEUiRuTmKsU/kM8CUtjyPcdkFSYm5B03A3UDlq7M
   P7H10nsyqDMkD4d7GPPgF0T82Z+D3kCZNJ29IHdGfx8q3NqBxodGiGSey
   A==;
X-CSE-ConnectionGUID: s8c3y9pjRpCcfY/VAwnQ3g==
X-CSE-MsgGUID: T+q16r1cQSq2AWDzXUQgqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71842126"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="71842126"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:51:13 -0700
X-CSE-ConnectionGUID: EYTW/1L/SZW+udd+x474QQ==
X-CSE-MsgGUID: yBpResqJSeCgB4l3Y19K9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155006251"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:51:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:51:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:51:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:51:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuksaVVatJrrwXzzTAVUa36MuMOIWMH5SkqcwJSwqV+X1LhBanMRBK2qv0OX6cZ+5620q9Wl5maWlW3U5B6IZiiEFlhTSJPtoAO2uhRzzL0cdy+CWqxjb2kn5tRp563JmhLQ//8mXJ3EkGxITmIQ0vUEUvFtjeIlAGtWEHQPkDiaRk6dqN/W0I9cTPQktZuMQ9aRoRaE9+liqZB4X81aOjWa7AFVtQIGLJ9WB+0qi/IeAnl+f6aLylemlGWh/puFDxmLMingtzb9+bbNCni9/F2/r0TURzKaBfdEwP/49YCqwJ5dBabfmLwXYld/hWBB2MlXh5n9kuSOpSB3pEC9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEDjB4wiXO6yybIhVimpv6zLYYvE3Th4B5VLzbJJYhw=;
 b=gTWo/RlPVLtrsP1IMSk3PFISyrL1SdnRKZK4BVR9p4CirJ5L8nCXC1atm7db0PhL28iM+ygjS71kQ0FI+zv4c6quIa8NOWRbOc6bLvgJ03NOGm49b9OfCzZJSjCXF48WKdcSyPpA93Q27k4yVXC1OtY5qt3AMLSIaaxlxK6g3sExphB7ybVbIJNSC8ptnwZTLq9+hH33e+iIjQ0fRrHYD9KQlOzwJOsU+iaBFPw9Xa4Ile1cP6eS2+/O0BM+LIWd4iJ8vRe6feaj7HDJhi5AoWusUn7ygnFXKQQqX35O4VuioCvkG9CqXOZEEzIGABWWECQl+Qgs35qtDhskqQMyCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:50:41 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:50:41 +0000
Message-ID: <f3ba783a-6387-4997-9e8c-897109ee3559@intel.com>
Date: Tue, 8 Jul 2025 13:50:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <6485574e-1405-49c1-90f9-1955ac2777ce@intel.com>
 <aGMT35DktIVkzwjx@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aGMT35DktIVkzwjx@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 504bc4bd-e29f-494c-d9ac-08ddbe6119ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y1cwbEVZYzRvZExtTjhDY0J4eS9GNm96OXp0RVN2VnllWmNoVVNTOGtmY3o4?=
 =?utf-8?B?MmtLd3lqYnIrNll4dURZNWZuWjhsY1RCMEQyTEQ0MGVPdkJSN29pMElqMkNw?=
 =?utf-8?B?czkxNVVlaHRBcUJ3SkpWcThmdWZDL0paY0xVdFA2eEt3RUdDa05PeFRSbndB?=
 =?utf-8?B?L0RNSG04TGlyRjZVK0VRYmhtOEtydEZQWk9UYnYrMUlWa3gvUlJBZE9EQ0dr?=
 =?utf-8?B?UGJFeWNqRlk3L3pvZmFEc1VjeHkxL1FQd01DdnJScElqbUNXbHRac0w3a0FV?=
 =?utf-8?B?L3FtZ013c1hhUHo0V3RIZjJYY1Z3WTkwajRaV2d1aW0wSnp1NExRa0xaRUhl?=
 =?utf-8?B?REl6SmJDR01ibVlJMzFqODVYU0xFNUk2Sm1SZHR3MDNadWtEQU5JeVhKQlln?=
 =?utf-8?B?WGlJSThoRWxoZFNTRG94K1FEOUpQM3R0OS93SFRvSXBLNCs3M3FoRCt1Qjlu?=
 =?utf-8?B?REx5TERjQnBiR3dPUzNQaWkxbG5hdHltYjFEVGx6Z0VpQ1pab3psSVVBNjlS?=
 =?utf-8?B?cENwK1FwY0d5LzFjRXpoOTdKUEpqdklvdkFSYmlEN0s5NGVUa1FSSndsUGV3?=
 =?utf-8?B?dE9YZ1pqblF6Y1U2dzBTWElkcFJsZERaMUQ5K1JEVnBpUEZnamVKQ0w1bXpU?=
 =?utf-8?B?MlE5ZlgzQXl5a2ZMdFVzbkp6dUR6dU5MckY0WkJIMXgrRXBqS1E2TThLMDlN?=
 =?utf-8?B?aldRL2xwamdtek9BYjFlN2xIMG16cWhieEpYRkYxRjJYUTArcEg4czd5aDEx?=
 =?utf-8?B?Q0pFd0tteFgxYWJiNkl2bFdrV1RBZ1lzWTNNSUNjZC9yQTYxUGtiWERuWVpD?=
 =?utf-8?B?bU1xME5iY1hGUG8xdGJwTXdvNlIvbDUyRW1OR3p6QUx6eHBOKzNOb01pVmVy?=
 =?utf-8?B?QnBqSk9IdnlGb1ZJTGVGQzEwQUIrUzVGRFNCbTI5elRHS0RiS1p3SU9qazZw?=
 =?utf-8?B?c3kwWkY3UCtZazZTekhlcElkV3NsZ1pUQ2ZaZkt6VFNuVG5tTytBdHhTVEIy?=
 =?utf-8?B?QjFuKzRsdWcwR254TmV6ZVdBQjNPZk9uQTdqRTFoRkZoa2JKckRuNENZVUpG?=
 =?utf-8?B?MUNmOEpYZG9HSS9kZ2NQc2NXbkxiUXhvbGdBVnovQm1ZNnVmTXdGR2hxTkFr?=
 =?utf-8?B?aWtPUEY5RUNkdmpOdk84ZUFlY3l5dE9vMzVPWWg1bjAzYkJjMGgrL0hDcWVX?=
 =?utf-8?B?WjBkVWs0aS9aSXppb3gxZE9SYzlYdmllRTBXQXozZjl6RTdlQytJZkFxbzkv?=
 =?utf-8?B?VHdBdkMwbmFhZWFmdmJtYXRNZG9nR0dKRTFHTmZiNHFaQVNSaVppT2dsMGRN?=
 =?utf-8?B?L0Yzb2N3alU0VGYrSnh4V01YYmRVNlpqUTc4UldISmtLQm54R29sSDA3Ky9i?=
 =?utf-8?B?MStTVDh0bU9Zb1BjR005VzJsc1dCZzhXZUZsV2RPWU1namJGdlVvM0pibjd6?=
 =?utf-8?B?T1p5WGt6WkRsMndOeitGMDVKN3NCRXJFNDNLeUd1d1NLNlo5djh5ME9PNG5Y?=
 =?utf-8?B?a1d6c3BxQmlVRS9VcGdTa3AzaUt4c2lkTEIwVFppSHhrRHU4L0orRGxJVExG?=
 =?utf-8?B?M0ZQeUpiZ2VaUXk3S25hSnJSSVF4Qi82MVhjQnlmT3o4NWhORUh2WHo2MkhG?=
 =?utf-8?B?aWcwQkphS0dkcmozQmo0SkJTRWcwcGZRWjNXOFQvTVBCRzFOM3A2WUM0Nm5Z?=
 =?utf-8?B?ZjZlZU5uL2tYZmVrcGs2SktyWGNUVGtjUmxzMlVhaEhSNTJIWTlWeDc3MVdz?=
 =?utf-8?B?c3N6WXd5ZzgydTJ0azR0SEw1MTdUVDlveG9FV3ZkMitRK25FaVVGdjFsSlRW?=
 =?utf-8?B?c2ZHQkxxaldXVWNFSG4rZVZBTGVWQXMxWm84cEwyWUZEb2diNmt4ODJhd0dx?=
 =?utf-8?B?enFlcGNJTElKS1RxdFdiNUJia01QLzBadmJXUXBRRFp5ckdsWjY4bGhsNnAv?=
 =?utf-8?Q?MytSVSenMMHshoU0JZik/FoFUvkamkdP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE9ZUFdNSklEMG90T1VsaWxxQjNQcVFZdzBRS0hUMThrYmQyRG9na2w2Z1hQ?=
 =?utf-8?B?amR2dEZLbU1nZUFDTGwvYTZ5b0JRTDhmOFJSOW5tUmNONm5FOFNCc3duL3Aw?=
 =?utf-8?B?Y2FrUFVSQlE4Rk5yQzltMk81dExENjdxRkEwQ05xODBHVWYyajRlNHYyUmky?=
 =?utf-8?B?Vm1iOUVFVS8ybVZNWXlQWTJnQzY0eXdKRzZuQlgrUzBvRWpxTXNZcGxHT1hB?=
 =?utf-8?B?TU53S0dDQjJCd3hEZG9zWWMxNDFQeWwzVkNsQWNLMmVKQXVxZzBmZHF3RHJZ?=
 =?utf-8?B?VENSbHlRdXZpcW1SdU1pZlNycWdFdElXeVRZampxL2o3am81OGdLREhieWVQ?=
 =?utf-8?B?NHNPK1p2eWFodmJ5ZlNOL29DVlVqc216TGltUUNEZ2g2a2o4QTRHRkpiL3gz?=
 =?utf-8?B?eXpiWXpWRW8rMjFxL01qOWhKa1lXMHlNVFBsOUE1elNiUDJ1SmxHT2hhVXNs?=
 =?utf-8?B?Y21oZU5WaFlyNENUM2xjQnhnUUVCSjZENXJpWStCRmNQTjQxTmJEK3pnbVls?=
 =?utf-8?B?Sk5lK2h6T1kvNHNlRTV6b2IyTDRvREo2akc4eHVUd2FnL2NVc05wNFRRR0J2?=
 =?utf-8?B?N0NqTUdYMjM4SDU5YkQzTTBNTEV6b0l4anM3Wm1INE1GS1V2RkMySVN0VzUr?=
 =?utf-8?B?WnQ3NlN4NytCZGxjYXNTckxqbGhwMG9jQzcybGUzQUxjVElMUjdXU09raXZL?=
 =?utf-8?B?cDVSOTJ4UmFLVnJTRm5FZGZSaVlxNFloNjk4dEs5SVBFTDhvNVhmSU1FUEZ4?=
 =?utf-8?B?MG96SmFCeUxRTks5NzRwdnU4WkVVak5PdnJEOWU2em0yRDF0TmdaajlEN3Nw?=
 =?utf-8?B?UmN5eUJxTStDWHJmdjkwbXpDQTRqWEFIYW1kdGwwZXRGTDVsNUk5TWVqcU4v?=
 =?utf-8?B?OWxUbFp4QUN6ZHVIL2RFTGN6dUlXaU5NUm8xVEhOa3k3VUY1RmltdkJhOEkr?=
 =?utf-8?B?dTMxRlF0SnE2M1ZDemxUVFJqYlZQVUR6b3FqelRSOHdlalk2bEpSVCtzUUk3?=
 =?utf-8?B?NjdZUC8vbVNDYUszckdxbEhqbTRrbEhzb2RiMTZzZkNKZWZJWEMwTUZQMzZL?=
 =?utf-8?B?SW1MUXFENkoxSUpqMDRWUjh1T2tvVTVlOEZ3dnU1QzNIMjlrM0d2L0hXeEIr?=
 =?utf-8?B?QklLRWZPRVMzMVpjeHJXbUxmQnhOdE96L2Ezbkd5K1ZtblV4emx2blpleDFY?=
 =?utf-8?B?UmhOTW5zQkdLdldweWI5OGNLK1Z1Q1ptYUpJb0MvOWo5SlBKdmVrOFpMdUpH?=
 =?utf-8?B?QmlMUVl0UTlVTHRIY3lZKzJGSXcvWCtPMDNqUUZvWVVHSDZLQ1pZeXhUN3Nw?=
 =?utf-8?B?QjU0U3JYL0JSd2dmZGIrYTlBaEVnVDJEemZDUEhTaEphTUV1d1hTQlp4UFkx?=
 =?utf-8?B?Uk9ZTk1GYWF4QlhuVUlCWUN3OE1VOGlsVjVOQ2ljY3RCKzg5NG9mNEZOOW9u?=
 =?utf-8?B?WXc4Y09teFhCdklZaTFUNFlFdUZiMm5DUmFBejZIMVgwK1ptcnlLbkpUYTlY?=
 =?utf-8?B?SndvMS9PVGZDTFFka051T0pQTURKUUFvYUVKY04vcjdaZWNYck1vTk41OHR4?=
 =?utf-8?B?VVJoR0o3MWJ4bVhXK2JZaUxsWFphV0dDRnkvNkRzNGVvY05uSXBkNEo4ejc1?=
 =?utf-8?B?Q2p4dEVUaDZVN1dLVU5TWkwwbnFhbFZpL240aEFJbXFCYU1ja0tCbTAzajBN?=
 =?utf-8?B?c3Q2SGJydy9zVzlNSitacG5JcXFQekhGVXBzNUxlYTRtMVJ5bDBiRXRLM3RS?=
 =?utf-8?B?VVZBZ3NUa0grU0t6SENUdUVMemNXcEx4S0xWeXExaVBTeGx5bDdtYW5DNUZH?=
 =?utf-8?B?VzJiVGJ2MWFHcm5MQXozNW1OSmpqc3c5K0FZb2FZSEh3YUUxdHlSNERwRldQ?=
 =?utf-8?B?QjdBTDZ3VTh1TE8vVHRodFMySE0yM2QySFprbExJbVk1N2VBTm9tM1c4MDE4?=
 =?utf-8?B?UGYySjlWbHN6SDV2QTgrbWxUeGVFTGxjdVJhelZYeWFyTUxWcE82OGFWRDg4?=
 =?utf-8?B?UXJ3QVBYNVFoSjRTelN2TXhLdDcxS1FGNHdVQUdjS0R3dlhoS3NBVEZ0SUFr?=
 =?utf-8?B?VVBUSmdhdDlLZUpwRGRMcmEzOG5oaXJ5ZzJyeXdNeDRGcHdnSEdza2RaMmpM?=
 =?utf-8?B?Z2tXek45a1hrUzg4Ymx1VjY0RGxVUU0wRHoxSWowemh3ZWVRamxyNC9sOWti?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 504bc4bd-e29f-494c-d9ac-08ddbe6119ea
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:50:41.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9akry35qpX2bSp7rFrpU9j89MevlCDsB5Ss6QdNaUYDL3A/2yZ8H0dq1zZp6LV203NjQyAjQQ3e28Dje8PZAQiDRRrxzeiEtBmRQv3/So4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com

Hi Tony,

On 6/30/25 3:46 PM, Luck, Tony wrote:
> On Mon, Jun 30, 2025 at 10:51:50AM -0700, Reinette Chatre wrote:
>>
>> Tony,
>>
>> On 6/26/25 9:49 AM, Tony Luck wrote:
>>> Background
>>> ----------
>>>
>>> Telemetry features are being implemented in conjunction with the
>>> IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
>>> counts for various events to a collector in a nearby OOBMSM device to be
>>> accumulated with counts for each <RMID, event> pair received from other
>>> CPUs. Cores send event counts when the RMID value changes, or after each
>>> 2ms elapsed time.
>>
>> To start a review of this jumbo series and find that the *first* [1]
>> (straight forward) request from previous review has not been addressed is
>> demoralizing. I was hoping that the previous version's discussions would result
>> in review feedback either addressed or discussed (never ignored). I
>> cannot imagine how requesting OOBMSM to be expanded can be invalid though.
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/b8ddce03-65c0-4420-b30d-e43c54943667@intel.com/
> 
> My profound apologies for blowing it (again). I went through the comments
> to patches multiple times to try and catch all your comments. But somehow
> skipped the cover letter :-( .
> 
> Here's a re-write to address comments, but also to try to provide
> a better story line starting with how the logical processors capture
> the event data, following on with aggregator processing, etc.
> 
> -Tony
> 
> ---
> 
> On Intel systems that support per-RMID telemetry monitoring each logical
> processor keeps a local count for various events. When the IA32_PQR_ASSOC.RMID
> value for the logical processor changes (or when a two millisecond counter
> expires) these event counts are transmitted to an event aggregator on
> the same package as the processor together with the current RMID value. The
> event counters are reset to zero to begin counting again.
> 
> Each aggregator takes the incoming event counts and adds them to
> cumulative counts for each event for each RMID. Note that there can be
> multiple aggregators on each package with no architectural association
> between logical processors and an aggregator.
> 
> All of these aggregated counters can be read by an operating system from
> the MMIO space of the Out Of Band Management Service Module (OOBMSM)
> device(s) on a system. Any counter can be read from any logical processor.
> 
> Intel publishes details for each processor generation showing which
> events are counted by each logical processor and the offsets for each
> accumulated counter value within the MMIO space in XML files here:
> https://github.com/intel/Intel-PMT.
> 
> For example there are two energy related telemetry events for the Clearwater
> Forest family of processors and the MMIO space looks like this:
> 
> Offset	RMID	Event
> ------	----	-----
> 0x0000	0	core_energy
> 0x0008	0	activity
> 0x0010	1	core_energy
> 0x0018	1	activity
> ...
> 0x23F0	575	core_energy
> 0x23F8	575	activity
> 
> In addition the XML file provides the units (Joules for core_energy,
> Farads for activity) and the type of data (fixed-point binary with
> bit 63 used as to indicate the data is valid, and the low 18 bits as a

"bit 63 used as to indicate" -> "bit 63 used to indicate"?

> binary fraction).
> 
> Finally, each XML file provides a 32-bit unique id (or guid) that is
> used as an index to find the correct XML description file for each
> telemetry implementation.
> 
> The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()
> to enumerate the aggregator instances on a platform. It provides:

I think it will be helpful to prime the connection between "aggregator"
and "telemetery region" here. For example,

"to enumerate the aggregator instances on a platform" -> "to enumerate
the aggregator instances (also referred to as "telemetry regions" in this series)
on a platform"

> 1) guid  - so resctrl can determine which events are supported
> 2) mmio base address of counters

mmio -> MMIO

> 3) package id
> 
> Resctrl accumulates counts from all aggregators on a package in order
> to provide a consistent user interface across processor generations.
> 
> Directory structure for the telemetry events looks like this:
> 
> $ tree /sys/fs/resctrl/mon_data/
> /sys/fs/resctrl/mon_data/
> mon_data
> ├── mon_PERF_PKG_00
> │   ├── activity
> │   └── core_energy
> └── mon_PERF_PKG_01
>     ├── activity
>     └── core_energy
> 
> Reading the "core_energy" file from some resctrl mon_data directory shows
> the cumulative energy (in Joules) used by all tasks that ran with the RMID
> associated with that directory on a given package. Note that "core_energy"
> reports only energy consumed by CPU cores (data processing units,
> L1/L2 caches, etc.). It does not include energy used in the "uncore"
> (L3 cache, on package devices, etc.), or used by memory or I/O devices.

Thank you very much for this rework. I found this much easier to follow.

Reinette

