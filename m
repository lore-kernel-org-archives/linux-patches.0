Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE224334688
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774653777; cv=fail; b=DhMkZ51uht2QVRiBBVn6el/iSlIJa6gTsshYmBEpWWw0xP2NRC5hv8/2RTSlhjVipviYQAGoV63Hg8WYJKhafrNynU55VQaaO3JkK8TeayFcZ0n1X2a82JODF8/1oJihxzUdDqFaFrinFow8s/tSocbe92LrZBQq28Aofi7azx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774653777; c=relaxed/simple;
	bh=cU7JrbqQo1BYtTZfNc3IEdmmiYVtXemtFrLDE/qUrYY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gIrGklx1caMIu4c8Puki+rfAfZqnuJdWdQwkaNcXAwItBYDnKOGWUIkuuNXmrU7PG6D5azOhojrgiorhS74IpWo2eyWk6sk9M+CdXQVunoCWfHi7uceHHzDqr3sGQvZO77KtGeZeFNCoaW86n/yVlGYpOlI6yFbHeeUwSFj8VXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S2ZXLo7B; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S2ZXLo7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774653776; x=1806189776;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cU7JrbqQo1BYtTZfNc3IEdmmiYVtXemtFrLDE/qUrYY=;
  b=S2ZXLo7Bd7EssAxF1V7J+bOvCYMnrl81H18P0+LPOm67NYM7Sds2TBP6
   wKxzzmV+WKUtnd7Acopj7PPGCEr6jyF4KEbhxvSE10gsExz3tf3lnrk5B
   OXvB79pDLkF3A0LD0+vJhho4MTdgGA60IEVT7eoXjpzGjqkn/ox7lTdX1
   lpmTN90U4Xr4qo8ghw6e66IFFeV+HhqwD1A0yseozPcZSB6uEFgTft+7P
   8qQbE5iYurjPGCitpuh5WH8dGeGc/PdvYsbR8TGgzmZxYDtNyuQkPM9AW
   faCiDi0bESA0K4eZwefjkMoxByjYAsWooE6A5IOeIjYXeBPaMXPF5dCmc
   g==;
X-CSE-ConnectionGUID: SbFNb2swRaSK1PqlvZmtnw==
X-CSE-MsgGUID: dvqcIBKDSPGBwkzSuwby2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="101192989"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="101192989"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:22:16 -0700
X-CSE-ConnectionGUID: qU4lA5PGS2SQtohF4TIVrA==
X-CSE-MsgGUID: Ry6YuIyHQ7a/37ZjjqUG8w==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:22:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:22:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:22:15 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.34) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:22:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VPYGBofj96uxf0reP5pYTLOR0Bot0MNAj4o/oi6oQihUXyfmZ24OUderrbgWsKQ2uherH2NiBI0GIc++gUdgiHIT40qjc4KKeKAZ38Y6/TsSwNOl54ntN1QeRaOD+QrQS8k4GEnw8s1hNeybcxB0MpbALLv99AWquVJ09GKFejW8ji9tce1WUJkgBZ7lKQMI4WmtwSR01z5cWPFfQd5xLkH2jEOvs2SvUGDioo/bxqkno+VRnvCVeUim9Kt7ObGaS5gdXERsUUnAxFmOUm+wPnE/vkioX4Re1JB05gCFxyllbFlUbETWlfX13r7ywD9prLw1aSdS43TSJEO1BpIWCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCUtQxC1Dlp9QQy1RaDVZb3kvHivJYPaWwHUKLIHLDc=;
 b=PPw621HO9vG7cmVFT1Y4LcosRGj5R/3xZdlafoiBDUk214PjLHxvcc1HEOTRl0ciHG7aYRfTNsKb9p5scX95KwTDW4E2uGtAzvDHJSt2MbfqUX+Wb8GWN2iLH0TsA7awXp3IE93QcwK8qZs5UODqaOfJBF9zdHJIm5XqWGpP8PdSWEY5SANcVp3QbycPNpHdDuFLMMPS1w32qm+id6GKWucNvQiBl+RJXbH9V2qyXdsvEpEsFZJpGv7JrK39xlbHIWa7N9D3Ll+ETu7kBhSC6x5kgN1PqbrXTiiPLlVqECmZbiKrDkqJ6iFg3XkejBMbMntU/8emXyFJy+a6Mk/OSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYXPR11MB8711.namprd11.prod.outlook.com (2603:10b6:930:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:22:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 23:22:13 +0000
Message-ID: <ef8bb064-f562-4237-ac72-fc2c00a5708e@intel.com>
Date: Fri, 27 Mar 2026 16:21:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] selftests/resctrl: Remove requirement on cache
 miss rate
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1773432891.git.reinette.chatre@intel.com>
 <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com>
 <4e3b5362-e751-03a4-f98c-a760ad274d02@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <4e3b5362-e751-03a4-f98c-a760ad274d02@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0310.namprd03.prod.outlook.com
 (2603:10b6:303:dd::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYXPR11MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: 8238f081-4020-4de9-8b4f-08de8c57ad43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: viLwI/ixoCKQses1dsANMfFILQEsn7aSij4EBoga3gHj7jylv18jPU4DvL3XT6DDyIvLzU1IA5volr7NtergG8JUFZvThHgoQFWwlhRy2zjgig2mJ8v1+Blqk2HLbftiqMbb6uMMNwl6PK7fJiZCezeMEfZGB3tSxu+UBj1cIAyIuT+EifhuqPszcAEfgmm4T//8ivFVyjyJoEsrcgdtcsXdDwaxVAdgBIs2vwvzrPoYqVG8gVB9AxOLSwMNS7HqvGzRFvkiZCH++1sGToq/GYAXPML7f1RNV8sZ78/aWb/LDmuQnswjO7gCxqfNrN3wuhftfPF8Ko4bPInZhfedVc5aHp1ZQYfIwgVQo73Eio9sZciTKEPEm02tVYVycIJ7v7pogmRZrMYJqH1XvYtMuYgNyMD9KQcNwBeMzYW21Pbqa5soXJd5SfPFQ9PEL5KgmqPdCtY2z5fj8SDPH+RZMFN0Y5f04ZG9qvzj/vsdw2Z4voNMIhPCxHFuFueGE4wuuiU0DQ5zKhorHmAOhXGIIOxVvfr3GoNGQ2iy/7uVQpgY1l79lBf3yheizC0323lwKb+D+HgOd1am4AatMTpSTjBbyAy4j8kksMUNCZcBIagqMhePkWqcy+Vl9jXX2sSC8qTYxygdRygm09/AyfdT30UgjxaR/LfVdM0V5Va7KRH/w9ySH45MJ7F89q8kzGTZITr0PWAFxKjf4IazUnd1eIDw2unqrRnpcdddQrC/Yzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmpUZGFQMSszUkFLMzFUNWJXbjhXVEkvQTliTUFmalNDdEVDWVlHa3c2ZlM1?=
 =?utf-8?B?bmF0MnU3Mi92ZGVVcDVPSk1QdXM1VEFsTU54N2RCcTBLbERGaGdRWE5wc05Y?=
 =?utf-8?B?R2kwOUFMc3JwMzZJWVlmZ2RvRVFGM3MxdkxPQjBLb1Q3SisyNHJhUXpaZCtZ?=
 =?utf-8?B?K0xLQmp2dlNGQnNOVkVMMkpoMS9Ub1E0eEg4OFFTZ2owTEloNUJFR0kwM0NN?=
 =?utf-8?B?blVLVmZNRWJ4Q3FwcERBRnE3UDhSZzRzdW1QbDNQYmhUcktJam5tRWFLZVlp?=
 =?utf-8?B?REV0aExKU3U4KzNIcENSWjJ1NUJya3lUU3BhK0gzT0F0RFExTHVUTmlHb1Vp?=
 =?utf-8?B?S09uc3ZERzJ4NUdoYVluTkMwTDNaalM0M2hQb0RpMVE4cXBBQW1GcHVKUEVS?=
 =?utf-8?B?b2NKb3NRaW1nM0lDOHpPejhrcmpFM2x0U0JuanJOZlhnN2VtcHhVSVNvb2xy?=
 =?utf-8?B?aHY1TUNoWjc1YWtwOGQvUDBuVjJ1ZkRENXJKcEZxdjdqYkVsVXJ3RG0vb0Fj?=
 =?utf-8?B?RzNSam9lbFRnMEFjVkNsRktVZXdMUEU4dVNMblE4Nmw1UzNxODdSRlcySzl3?=
 =?utf-8?B?N3R5dE50WEJ6N1R5dk84K2NOdWRYMGVVZWVBQ2F6NTJkZ3JYeU1KVG11OVZh?=
 =?utf-8?B?ckI4c2kyUjhPRHN6RmQwWnhic2hTczNNVnQwTk82QkhRS0VOWXRZdEx6N2Jv?=
 =?utf-8?B?RWJmSU4vZEltOTBqN2pwU2lMUy9JUXpaOWdqZGh2WmNEZFlJYWQrVjIwN0Ru?=
 =?utf-8?B?dzR2Q2JIemZ4OUQ0NkdpZGt3NkEwSlMvS2MxNWhDalBVOTdkbW5MaDgwMXV2?=
 =?utf-8?B?ZHF2MUlaNVQ3alRMcUkzczU2d3dlcE83UXluaXNoVEhlbWJ0ditVaTBkNVUw?=
 =?utf-8?B?S0ZLbHdBUTFXYWRKZnVBMWV3NkpIVnRaWWdLcDViU0FVdWt6NjFFeHo5ZjU1?=
 =?utf-8?B?WVh0M2xmOURkY3hVVTBaUnV6UEx1SkdYcVRvZXNRR1ZaWm14WkM5U3h4NHhK?=
 =?utf-8?B?dGlDblp6WHNlWUZWVGtEYUdhQnpReXI1WFEzeFR0MHRmZEJQWDQwUnpXRFFG?=
 =?utf-8?B?YlNLWTRCRlNrTFFiT1lkUFpKZ29xc1N1VitTb1RqV3k5bHF2SmM4d0pTSmtq?=
 =?utf-8?B?WDNJQmxBS1Z4aFZpaTQ5UllmUEIyZjl4MVFjQWE2WFJRLzlienpXWU1qU1pY?=
 =?utf-8?B?M3NoZW5FZEpDTUtVbU9vdng0WHVZcUdiMlA3Z2lkYzYrNzlJaU14K01WV3RY?=
 =?utf-8?B?UlpvcHdReWRnNzgvYWpNY3I3cHh6Z2dPK1BPS0h6UiszS3EvSGIxbWsrS0xy?=
 =?utf-8?B?MjhkSjAzYXA3eVNyU3RabnBtOVI4N0cva1V6c2c2NzF6SU9na1RkWFFKRXVO?=
 =?utf-8?B?cUN4N3pUR21TcVR0TWFoRVZuaUJKbzFqbkRYRnJMTW1XaDh6MHJVc2NGOVBQ?=
 =?utf-8?B?bGxJakwwYmNjVTU3bUZYb3ZSL2UrdUNWcnBON09qNTkzSVc2cjBlZnk2MytQ?=
 =?utf-8?B?amZ6OGJ1R2puVUR6Ti83N0JlWVg1ZDhoWHRBckFtWGpzYnNGMFNVTXYvd0RY?=
 =?utf-8?B?TUNTa2E5QSt0SldjMWRkOUlPYzJETnlIRWttTG53a3J2bHAyVXB1eWl1aWo2?=
 =?utf-8?B?M1pKNURaR1g4WHdsS1licnNSS1Vnc090czE2TDh1Ti9uVUQxZHIzVldwdUQ5?=
 =?utf-8?B?M0lSTSs5WU5yekV6eDRyTXFkMEt0ZnNVVWpEMHZBVXUvaUdVU0VtQ2tkeHBn?=
 =?utf-8?B?bkVJdHova1ZheFpwWC9qT05lTkJGU24yV3FkVUdzc0l2d1E4QVUvNGtVYlRY?=
 =?utf-8?B?d0N6L0JLd2xtRU52Qy9IQlpHMjF4OGUvd2JhSG55U0Q5Ry81TzBmZW96R01x?=
 =?utf-8?B?c1o4YjNYRjRsSDd6VnlrM1pBZURlT3BIOWxLU09rMEpyN2JJdWlDb0xnQ2di?=
 =?utf-8?B?SE1zWmVMN0RYMFFxaVk5UTRyS1drZEY3M0NyR3BOMDR5RlVPTmJnNm5ZRVBC?=
 =?utf-8?B?S0JBOThKRmxwQkpwbWNBbDVVUUVuYmRncXhEMitjbkhxSm9MNjdDQnplTDhR?=
 =?utf-8?B?WHlKRWdkNy93MkNZZnZXRUJKSDcxZmhDQnU5VDlwWUs2dWdEa1FkcnNrZGFw?=
 =?utf-8?B?ek4vckdNaE1rUDFrQW5NdlQxbTNjOVBya01nZjZ1ZXBSWFh6YkFvWkY3QlFw?=
 =?utf-8?B?U3YvemtNTFU0TkdzcG9UNy9BMk8wMVNLcFozUzRTR1ppdWRZME5KS3pkQ3B4?=
 =?utf-8?B?T2VuaFZYYmt5dGxac0lsSUJsNDZ4Q1QxaWFTOGhveHQwRHdvM2tKckNpNDhT?=
 =?utf-8?B?eGl1Wnprb09CeG9pK0ZrZDZwSGQyUzdOeEN5WWsrZUVBN1l1TmsyT2JkdGVq?=
 =?utf-8?Q?qiWdBzZgEIqPaRLg=3D?=
X-Exchange-RoutingPolicyChecked: OXo/ghEjxqX85WHTRPFi9x2G2WUMQgXEDG2HnuZ00W9bzAkbYmxOHe65qP0CEPVF6NdJF8LZYSRjOROWoSqT8tlu64Oq5Gj5kVW2KeU6yHGjWV0GpipF8t68v9+3Yhu3fkZ6Hr4kONbX8mtdlFC2pKnFrwRAgow2NYFk1ofzVvCBBZXcMDrq89lPO6dSfEx4L+MkN6mTC9FZrzFoilwryQdFREvERgYqfi7mW5A5abPHmZHgL4hFNv6c1g5ZJtXDaQOse1SE1Ef7QfDtrpYtwoRai47Snij3e5AjnSqG28t33lui8QMe6ng5eNmaoZSBDGN8Xc9kGNtL8YodBDyZcg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8238f081-4020-4de9-8b4f-08de8c57ad43
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:22:13.1377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/j83jvS5bigJuQg11ib5yw4kSb2OEdTbn3As71K7vpVaalNCairHWi3Ap8Rss2762g2mSKAWLxSSgjliWQWDl6xXnd5gt5uQ2xHuyByXVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8711
X-OriginatorOrg: intel.com

Hi Ilpo,

On 3/27/26 10:45 AM, Ilpo Järvinen wrote:
> On Fri, 13 Mar 2026, Reinette Chatre wrote:
>> -/*
>> - * Minimum difference in LLC misses between a test with n+1 bits CBM to the
>> - * test with n bits is MIN_DIFF_PERCENT_PER_BIT * (n - 1). With e.g. 5 vs 4
>> - * bits in the CBM mask, the minimum difference must be at least
>> - * MIN_DIFF_PERCENT_PER_BIT * (4 - 1) = 3 percent.
>> - *
>> - * The relationship between number of used CBM bits and difference in LLC
>> - * misses is not expected to be linear. With a small number of bits, the
>> - * margin is smaller than with larger number of bits. For selftest purposes,
>> - * however, linear approach is enough because ultimately only pass/fail
>> - * decision has to be made and distinction between strong and stronger
>> - * signal is irrelevant.
>> - */
>> -#define MIN_DIFF_PERCENT_PER_BIT	1UL
>> -
>>  static int show_results_info(__u64 sum_llc_val, int no_of_bits,
>>  			     unsigned long cache_span,
>> -			     unsigned long min_diff_percent,
>>  			     unsigned long num_of_runs, bool platform,
>>  			     __s64 *prev_avg_llc_val)
>>  {
>>  	__u64 avg_llc_val = 0;
>> -	float avg_diff;
>>  	int ret = 0;
>>  
>>  	avg_llc_val = sum_llc_val / num_of_runs;
>>  	if (*prev_avg_llc_val) {
>> -		float delta = (__s64)(avg_llc_val - *prev_avg_llc_val);
>> -
>> -		avg_diff = delta / *prev_avg_llc_val;
>> -		ret = platform && (avg_diff * 100) < (float)min_diff_percent;
>> -
>> -		ksft_print_msg("%s Check cache miss rate changed more than %.1f%%\n",
>> -			       ret ? "Fail:" : "Pass:", (float)min_diff_percent);
>> +		ret = platform && (avg_llc_val < *prev_avg_llc_val);
>>  
>> -		ksft_print_msg("Percent diff=%.1f\n", avg_diff * 100);
>> +		ksft_print_msg("%s Check cache miss rate increased\n",
>> +			       ret ? "Fail:" : "Pass:");
> 
> While I'm fine with removing the amount of change check, this no longer 
> shows any numbers which would be a bit annoying if/when there's a failure.
> 

This snippet only removes display of the number that is no longer computed ("avg_diff").
The values that are compared now, avg_llc_val and it previous value, are printed
in the call to show_cache_info() that follows this snippet but is not visible in the diff.
 
Below is an example of what a user running the CAT test will see after these changes.
Since show_cache_info() always prints avg_llc_val the user can obtain insight into failure
by considering it and its previous measurement.

# Starting L3_CAT test ...
# Mounting resctrl to "/sys/fs/resctrl"
# Cache size :117964800
# Writing benchmark parameters to resctrl FS
# Write schema "L2:1=0x1" to resctrl FS
# Write schema "L3:0=1fc0" to resctrl FS
# Write schema "L3:0=3f" to resctrl FS
# Write schema "L3:0=1ff0" to resctrl FS
# Write schema "L3:0=f" to resctrl FS
# Write schema "L3:0=1ffc" to resctrl FS
# Write schema "L3:0=3" to resctrl FS
# Checking for pass/fail
# Number of bits: 6
# Average LLC val: 445092
# Cache span (lines): 737280
# Pass: Check cache miss rate increased
# Number of bits: 4
# Average LLC val: 724472
# Cache span (lines): 491520
# Pass: Check cache miss rate increased
# Number of bits: 2
# Average LLC val: 1085470
# Cache span (lines): 245760
ok 4 L3_CAT: test

Reinette

