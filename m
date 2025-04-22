Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AC029346F
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745345952; cv=fail; b=tCPogIG6qsUHYACW5kPVFO2K4cRQwo0BW5MCVd0xMFgOlqSjCeZNZb2w36gI1XQA/O4j/Nf/rWZyRLfE0HwxmRjm2p0Yq+n9o7O8cits+4efQH+XLMY7FDCwz82qAm3FIbYUubf6aNOC+Jja2fFM05Iz5qtwTqAKBhQgtSXq0e4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745345952; c=relaxed/simple;
	bh=IEVhExjRQlAc5Z/19asGM1cebqQP0LxjWQAM6Uin8uY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nyQDDM867rYZU/2ncuqifEGzjzRu+b9ajgI3cuhRPD1HZpJFVk2eyQToOJVnpam+Yy98QzWbrjRU3C0zCCadEkHlO2CtgT6Ggo6z2Vd0fm5FK0Yq65KmCnYOczZd7LdUmESLt3YxRWCpPhedYAxFZozJbSOxfgfh3SnOxmQEq+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dktu1IXz; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dktu1IXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745345949; x=1776881949;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IEVhExjRQlAc5Z/19asGM1cebqQP0LxjWQAM6Uin8uY=;
  b=Dktu1IXzgZYtXTNBhKY0yg/rldqvbSqv0wBmwpb1OIwtcGOZbWsME0R/
   Y8ybT3bcAmTC+lq8oHug1Mw6xC1OBZfNhdrOGpwGhLud5whABQQbEsM/m
   o5SBPunE4zYPsmugk4FJznOwjUGfqZsaKI/syVN8/1gKnyvM9+cuQsllr
   2u3++MiCFJd1OaoBeuJ1WVvFHcqFb5kbI7TO4h6nMwdK+Nzb9f0hZA+8c
   PzGeA1Zv2agKryYgMPXv1Qw/YiNf6Fat5noGcFJDV52pl6wPNnu0Wfo6M
   fJWVDG5ZF8urGqxonGU4F7OQujDp3v9uAcIwRsYYN4YCIMNBBEIdeRNJf
   A==;
X-CSE-ConnectionGUID: oW+MU713SJy4CYToFDYh3Q==
X-CSE-MsgGUID: h9z38BWyT3OxsbsVZzi4SQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="57108832"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="57108832"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:19:09 -0700
X-CSE-ConnectionGUID: BWMnVo0mRmmBc1YPasfHCw==
X-CSE-MsgGUID: ZGiCXAs4TaS4HZV1vtb0mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="169301075"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 11:19:09 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 11:19:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 11:19:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 11:19:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fSPxWY29hO7Ryreq/4bEZiEucjzMNLf3PcK2nHkZI58dEUGTgxftWLouJKgAIF9DRJbjlGZUl9Rypl2R1r4gLyR8TP/ia23TQR4ex5CKJCegVsxDBZd4BTHuWAy6MLqlP+Em0fb80NWQThRS1EKBRTuhGkGiY2BuQj+UNou6OdnIxCSjxwi8Wh6+w7wwFaawkL0F9638aN3KGAPYMru59TLtOyFklh13j9bFjwEmkq29kgoKJh82AQk/ZLMcHvsgiv8JV9XCaCqoCYMMbCUqPTIPZDUaYRm8luS+zqVMyqmvBqeRZtTeXe0CPF9j5nsm9GUcBqbsLjV5ecYUU0JM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ReJP0fKLsKjEAgFxTd/C28uHdP7u4mVDR02JMEa7aY=;
 b=IkorWK3xTbsYGbFRxqG94Dqvgd+sCHC1YtisSPbQzhlanBwmbTn/CXPTEoVQAXTXIK6SwXEMd9hh2jJ5pPwGMv+7J6QrTey+scBfvlHJ7wsaIxMVm1EO2DUu/XjC7EILwbN1Ggl3ouSt0hhYgSProx3zDhrk8EDQj7Y+PWTKZIhNkZYRQ8ahhn0y5K09W9JYRUPuoYODgPCwXHJrHtwqD410tIOiXJ7dL3br/3++5KTHhqHBAR9KOwh5PvXkebNlbpq/Lt4hftVYy0gu/TkoyLRQCwsjIOmjNWLA9WJQiE8PS/26Lo/P4NoLUaed2DZMhvM3AyNwAgjGuCBDMlCcRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6716.namprd11.prod.outlook.com (2603:10b6:303:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 18:18:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Tue, 22 Apr 2025
 18:18:50 +0000
Message-ID: <8d5add17-fbe7-4d80-a2cc-31749a052d5b@intel.com>
Date: Tue, 22 Apr 2025 11:18:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/26] x86/resctrl: Move L3 initialization out of
 domain_add_cpu_mon()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-8-tony.luck@intel.com>
 <698ab022-b6c1-4fca-b42d-26a3b4b2b8e8@intel.com>
 <aAakETammzi4vGMn@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aAakETammzi4vGMn@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0389.namprd04.prod.outlook.com
 (2603:10b6:303:81::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: 8345308c-e862-4284-8e5b-08dd81ca2184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VjZYN2FiL2hrZTIvb29lSnlyUzR0NDhRWHBnc0duTHhPd0h1cmVKTWVESDg3?=
 =?utf-8?B?L0QwWVVTeXlOeXg5a0hDRWlIRG5OUlJkTzk3bXdkeWx6T1hrSjkxdi9lV0sw?=
 =?utf-8?B?eldUaEEzSVJwZXRUM0lGQ3U3SDBrZEZacXZpRVpHSHZWd0NiUGEvTHRSajZu?=
 =?utf-8?B?SkEvTkZPUm9EVml4NHg1b0RtUDNjM1NoOGxwRzBSL0hCOW1KWmcyT0JmN00x?=
 =?utf-8?B?UmhFaG9RMWRjdUttZUp6TitiTEpycUdodWF2STRlYWpsTklWeVI0dWcydnVv?=
 =?utf-8?B?d0xhY3c0VmFiTXB1NEgzQXBWVnNuWmdOY0poVDdYSzdhWEQ3OTBhR3RwbDVQ?=
 =?utf-8?B?VnNSeFpkd2RERUtZaVU1cTNUQVhGVkZzOC9rNHptQUx4dWx6N3NWR3JGTUsz?=
 =?utf-8?B?WFlRREQ0S3hKdnNMQlJnbExJV3NtaDlqTmZHY1pOdEczbFdDWVo5WVhVVTZP?=
 =?utf-8?B?OW5IOWxBK1FwVGhEWnpNL2ljZ3ByZDZXdUQrcWsvVVVQUXl3NUxsbERwUzdl?=
 =?utf-8?B?endiM0RjVXdJYnBodnJIakhSTjBDbTNvcmJVVmVxSXlTSzFOcFY1V090VGJW?=
 =?utf-8?B?RW9zZHJxN1RBQ3pTSUdKdWIybU9uUTlNdldESU5TVWc1cklXTkFkZkFIaTNk?=
 =?utf-8?B?bVc0TUtiL2RIMDRJMlJjRXpESnpYcTk5UFFMYm9HdFJRd3cvc2twT3F3d3JT?=
 =?utf-8?B?amhTajlrMzFaaTJ2VXJVcE9RRWk1c2dBNFgyS3Q5akd0dHFrZmFsT25Pai9O?=
 =?utf-8?B?dE1FNkgvUllvdHJ0ZUcwTWd2Q1hDcmlIQnZkVW1wNmIya2ViYnNGTmZaVlJa?=
 =?utf-8?B?bmZiRWVYbjJiZ2VocnB1SUtsYjF3R3JTTTlRT0RoYUJGOTVob0V1VW01UDU3?=
 =?utf-8?B?cnlDSHJLMVVQZVdzU0JuajFQellSZWlzemMvSXdaZjVTcTV5Nkszc1hiYlFO?=
 =?utf-8?B?b3NsQnhnRlJEaUxxSERoRTZneStGS2J6bmV1aEp6ajhpdGEvTXFzbDhFTTlu?=
 =?utf-8?B?aVNoRGdPcXpoWFFqWmd4RmhobDk0NmNINlJrU3gzdlFKWGNKcmJjWWZZcUpr?=
 =?utf-8?B?YWFsMkJaOEd0MzdNbXlQWGMxUkRhRjFadkU3NTArTis0d1hSeTBSNzRySEJH?=
 =?utf-8?B?RTk0Z2hhdkhINDBvRm9ibTNQM1lDTHVsdHBBOUFrbkJIUk5oa2Ria2JCQngz?=
 =?utf-8?B?RlFFM25Ja2N0MzJ2S3NwSTNHNWJraTZjREdkRDRwdmN6YkdoYmt5RlZwK2wx?=
 =?utf-8?B?NTgra0xvbEVwencrU0NiMDkrMGZINDg1SHNIM2lQVlR3ZVppaFlSbkhnb2xQ?=
 =?utf-8?B?S0t6SWRUZ2VzWk1QSXBqeER2MDMwb1VteTUzbnZiMEpyTStra3orbVJ6UGIv?=
 =?utf-8?B?L3M4ZzVreWhSVlcvcDRoYjFWUlArVzVwcmh1M3J6V1ZxaDFPYVhQNTZzdUlH?=
 =?utf-8?B?YXpCclB2dkVWRFZRODFqYSs2KzJzWml3Nm4xVmJTVE10SnNPRGVsZzRaQ2NZ?=
 =?utf-8?B?ZDJrMUZRZU84eXk2c1VManpKOVhHS1VmS1A2ZnpzUk4wSm42aGVIa29EWk9z?=
 =?utf-8?B?bzRDejd0c3A3SmRYb1VuVHlFbHY1bjJSWSsxRmFWQmtTSko0bm8yZGhiMStU?=
 =?utf-8?B?Y1ZKOGdoOFpXMHpyWXNBVTdpVFdMUENFbWFxVzF5SmlOY25uSEVBUi84aWNS?=
 =?utf-8?B?cERqSExtemFGMUhpRWlKczdZS0lPZWU0OEZQVHoyTjQwQWM1S2ZERnhwbG5t?=
 =?utf-8?B?d1RHQm5rclpOeEhQT0Z3ZHZVZ3JzbEtsLzVoYzhjb3dJSHpaTm1yclR0RjRF?=
 =?utf-8?B?VWhONkxGWHZhZ1JZdWNlZkJROThpbVlOaitEWGVzKzRaVDBSVHpPcno1T0RG?=
 =?utf-8?B?RW9RUlpxTDZQSVgxRXZnUFFjTkliNWRaL25PWHdpRnV4c2xnNldnNUtObnNt?=
 =?utf-8?Q?WMXssnC3yJk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE9PbS81dzVURVU1ek5PaWltVWh4RGp5ci8xRmY3WFNJeElhcmRxczFlaXR1?=
 =?utf-8?B?MkpBTzhXdENKbUFSZW84NncwWkl6RWNJM2Q1Q1ZZcVZwQVVEcWQ4ZHB1YUIz?=
 =?utf-8?B?bTB1bSs3dmdzODVGalhpUFZqNDFvK3dYVGtIRzBFSjYrQ2NZNkFZbnFsU0d2?=
 =?utf-8?B?dEo3Ny9tMzl5TFJCUXN2cWNVelZIa0IzU1h4N2FDcnhHSTVZQW1iR2wrTk5m?=
 =?utf-8?B?bDdiTHFjbHdFRWpOS1dwaFlYbU1DNzNBd2t2dVcyUWZ3dnpHTVhRajUybnQ3?=
 =?utf-8?B?KytqS3VBUzhRN2V2UjUxZmtRMXRjTy9zemdjOHhIUG4wMUlBRUNWMWNWSSs1?=
 =?utf-8?B?SjlBUHp6LzJwRkJ1ejlSdDFIYytKQ3J1R1NMU2RkV3RiQUVBZ2NZcnNjUkxa?=
 =?utf-8?B?V2NtbUdIUjhVci85TXUybjhtaHcrU2xqb0tyUFNXZ0p0WUVRRGhUV2dWcit5?=
 =?utf-8?B?UTBvdXVJVFI0cWxBVGhWWi9aVmxtV3pMWEdjZDNkdjUyRFRoYUJza2xIZk9J?=
 =?utf-8?B?cDJyUFJPQjlNKzl1UGJJRk5SZ2pnOFgvUXUrdWhIYVJ4Q1p2T3NSem9admhH?=
 =?utf-8?B?WlM1aWppcVRkSzMwbnpXTE5ka1ZHaTFvaEsyZUl0alFXZWJXQWhHK2oydm5v?=
 =?utf-8?B?eFhXclNNL1B5cE1MaUMzN0FyenZuU1haQjB0ZldlMmF3ZW81S3UzU09mWWV5?=
 =?utf-8?B?WkV2WWttelZxaGJCcHlNOTUwd2k1NUdCZVUzbU95VWYza0xza09OUWxmd3N3?=
 =?utf-8?B?bHFjZndSMDBra1BPaVJFZzR4V0pMdk9oc3duQnRwYUNhdzZGUmFaQ3VMSmhx?=
 =?utf-8?B?cWk5TityZkk1MUp1eS9waEZaQ21hMG00b3R4NmxPbFFvSW1pRmpLNzRla1o2?=
 =?utf-8?B?RzlUQWlPUDlIM0ZDS2xlSEZPU0NKOGFXZkt1OEhaVkxzbUlQSytNenk2OU9m?=
 =?utf-8?B?MFVCdjE5c3JNMGQ3RnFuRXdHS081akFMaXJSdXpLNy8xOHBxdzJOZFFHRTQr?=
 =?utf-8?B?THJNUGpmVW0yRURrUEtvUWlUVHNmeENMWU1VTEVycGlyazVEQklrV25NL2li?=
 =?utf-8?B?cE52STBla2FKYzJPTThCNXAyZTRIRmN1OUxFRTB4T1g3V1ZoczBodC8zK2V4?=
 =?utf-8?B?U3VPSW9PdDVuUnlLQ1FDL09vZTVjRSs0K0tuMWZ6RzhlMzd3eVJQWm1nZTZx?=
 =?utf-8?B?WDVYVjluZVI0aDNRTGN5N0ZKZjN0eUhlRmhOT0psWFdmYXk3ZlZnR0g4SVZq?=
 =?utf-8?B?RERHU3h1UlV2b3lLb25pOXhGWEo5NFF0MjBrTndGK2xtbmF5SXdoeERmTzJy?=
 =?utf-8?B?dmEyYlp0VjBFMlNlcHJoOWE5bnBGZVlUZUwraDRlUkZTQStmWTdURUZDaWZj?=
 =?utf-8?B?L01tY0hBaURiOTFXN2d0d0t3Z2g3STJkR3F3UVBtSVpEM3dGWm4wemplOXZX?=
 =?utf-8?B?QlJCNnpvSnlJOHRBb3R3RG52Z2tXMExla1RLdGNKNU4zVDlHM1EwVEp6aVhU?=
 =?utf-8?B?SDhEdnVsbllnWUd6bjJ3Y0psaGZicnU2WTdRbW9GaUtzamhKM3ZPaHg5ejg2?=
 =?utf-8?B?dXFXMUVlQzg4OUhVTVdDQmRNS01ZTHRycmhSS3dhWDdaMFV5bUFLMTZ6Z2RF?=
 =?utf-8?B?bk5lRTBlMDdPd3FVSHFOUzFrY2JhWUlkd3JRTFI1eEt6Mk1MWkR4b2R4bnVS?=
 =?utf-8?B?bTIvekU0NmZOYWtzL3RjUE1ZcTkwZUZQUHBsVWdpaHhnY0xpT21RRCtKS2xF?=
 =?utf-8?B?aHlkci9MNThob2tCVDFQMXNYS0YvL0ozQTk0V0lRK09FVkJtUzBuaXBWMFFR?=
 =?utf-8?B?NHRqNU5hSkloRkpmSzVScFN2aVYveE5Mbm43NmZTcUJFMFVzVEkxZWgxZi8x?=
 =?utf-8?B?dzhpNkZKbEo0MjlCUnFCcGcwVVV0VzFEMm1rRHNMYlJRcmJrNlhpYUhRelR3?=
 =?utf-8?B?Tm5GalBFWGxIVDV1eDg4UUdUeXYvTlhCbkw4STFmNU11NlpaYzNUUjd6YUFv?=
 =?utf-8?B?L3R5WW10cnlzRlkzYVptNUFwTmNSWmtHK1NxQTRDQVh2ZXpuTkRGRTF3aDV5?=
 =?utf-8?B?VE8yaVVCeWU3cGU4UEVSOEtVWXk3R3lTdXRXWVNUT0pBenEwNHZTN1BkSDRF?=
 =?utf-8?B?RmRXcGp4QjJTT2ZjQm9SME1tem5yZTZQc1VMdzJjWTcweU0vWVJOMTRtZnlk?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8345308c-e862-4284-8e5b-08dd81ca2184
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 18:18:50.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUotgIa7TEwDrsvP7Pa8cRVb1iR8KXz63GBQAx4kxAOcFDA+33aieFS56/oZH6JIPALLFeAc1mbGzMFXWFJg+0oqA6EQuAbnxeHJ6JbxULk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6716
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/25 1:01 PM, Luck, Tony wrote:
> On Fri, Apr 18, 2025 at 02:51:01PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/7/25 4:40 PM, Tony Luck wrote:
>>> To prepare for additional types of monitoring domains, move all the
>>> L3 specific initialization into a helper function.
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>  arch/x86/kernel/cpu/resctrl/core.c | 57 ++++++++++++++++++------------
>>>  1 file changed, 35 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
>>> index d82a4a2db699..703423b0be0e 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/core.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/core.c
>>> @@ -493,33 +493,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>>>  	}
>>>  }
>>>  
>>> -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>>> +static void setup_l3_mon_domain(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>>>  {
>>> -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
>>> -	struct list_head *add_pos = NULL;
>>>  	struct rdt_hw_mon_domain *hw_dom;
>>> -	struct rdt_domain_hdr *hdr;
>>>  	struct rdt_mon_domain *d;
>>>  	int err;
>>>  
>>> -	lockdep_assert_held(&domain_list_lock);
>>> -
>>> -	if (id < 0) {
>>> -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
>>> -			     cpu, r->mon_scope, r->name);
>>> -		return;
>>> -	}
>>> -
>>> -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
>>> -	if (hdr) {
>>> -		if (WARN_ON_ONCE(hdr->type != DOMTYPE(r->rid, DOMTYPE_MON)))
>>> -			return;
>>> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
>>> -
>>> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
>>> -		return;
>>> -	}
>>> -
>>
>> Many functions called by this new "setup_l3_mon_domain()" are specific to L3 resource but
>> since L3 resource has so far been the only one supported the naming has been generic. Now that
>> this function is made resource specific I think it will help make the code clear if the
>> L3 specific functions called by it are also renamed. For example, mon_domain_free() can
>> be renamed to free_l3_mon_domain() to match the "setup_l3_mon_domain()" introduced here. Also
>> arch_mon_domain_online() -> arch_l3_mon_domain_online().
> 
> What about "struct rdt_mon_domain"? It is now specific to L3. Should I
> change that to rdt_l3_mon_domain" as well (60 lines affected)?
> 
> Ditto for rdt_hw_mon_domain (but only 12 lines for this one).

Thank you for considering this. My vote would be "yes" for both. I think it will help
understand and maintain the code if naming helps to make obvious what data/code applies to.
Monitoring has been synonymous with L3 monitoring for so long that there may be many
instances of this implicit assumption. 

Reinette


