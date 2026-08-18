Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB18285CB9
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014779; cv=fail; b=IliU0SqeP5QNeYnJUH6EDL903PdIYw5wrIyKazssDOo4rJ7Ux4k8FYQDAO/gMzeY/scwLD6rjdgUj43nW3UW5kcsUbWGDYmYbll9zLHPwoVY+9++/Zsu3JWQd9q2Em/kO10dA+wVQtg7T4PGVsx85mBJ0Ow1oTsDLRZpW6GU4bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014779; c=relaxed/simple;
	bh=rToXATWnjTJyRwULqAnnwetBX8ayZnNFUtJmZgehDY8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N7HdeVGC3mMW6xAJg5SswwWMxcEOMlOBzv4jMOVErZl/awRwvN2Ta6pN6Ydu4O1gUZ5Y7WBRS27opt1a019riyZdgIPr38k4ZvAFnWdvPjzmv2LHmRGOhsfM4HZ4uvnMgXtk3+pM0nHL2i6/1EX5zVDK4Z4Iocb12GRngn4L3XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S9LVZ/Rp; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S9LVZ/Rp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014778; x=1818550778;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rToXATWnjTJyRwULqAnnwetBX8ayZnNFUtJmZgehDY8=;
  b=S9LVZ/RpEr96v00tnxYHVuxmpgQeFdRSeFUYq5GPhHrDJd5Jk3JB+nhQ
   ABzf8QlXN+fo6/m+pOl20pyIfAZrFZSVlbEw5rZCmEtOOG3+ni5Xhs6ia
   0XEDwgwwUhr3QTH34GsYb0hiMAVA5DS5UD6ZfHY2z1NQCjCIXENMBybWr
   ekHHjvX/RV69672SrbyTZMXmwEQG6E6k2M5xJhIPbTx/aYP+C8nM939Ye
   ti4CCBb5FSJKHFDuTKaQubbb5iPofWjzaUoublZQz8uKc+3pcqkdKEgtF
   W82zs2CQgPeoShDsQpZGwf2hMqL3c1IeiwWRbHeyuuPRv03heAZ9Qan2o
   Q==;
X-CSE-ConnectionGUID: sqfmkvazS42Vno1LeW6Alw==
X-CSE-MsgGUID: gs1IenAgSe+FuR9IgYeXYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87705963"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87705963"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:59:34 -0700
X-CSE-ConnectionGUID: Sgg7+9RbRACFqA3E+ALlLQ==
X-CSE-MsgGUID: 123WI56mSruOFsTNlYryuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="265105324"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:59:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:59:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:59:33 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDif0hKmHTx2CIUJdLEA17mwh09OD9gd9VO+DLIn9KkWshslJJ3pQw0AqrfTy+4y9RV8Z6bH9MqhRtfFlQ+ny8V4Cl6ghNGFcreFNt1FUDC2xnSG1O21tESOkD34DyBoEHS4rBCygpZLo9gbRtX003/CVvntO1yWL0CTT2ExmkO69+tG2iHvU9JrAnnZ6SXlKRSUhT+uCI4t23xV0Vper/WYcGuSk+dpjw0VyWAFwvscfRKAB/PrDXSsBYEy+nNkZbersa7+vVAifEynxgy8ZZZWKuht3Wj+jYne1H3q4q1esT21GsWnV1C3ufZIZuGy7QAQZXEBhqsgaMtG33Lhbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+695puxG5VtaOZ7QzZOldARaGrU2nocbRmlr6fsQAi8=;
 b=u+Nz4nkOuMjImBzhHxFgpYJwKzjdkbbPzUB9lWrIbso8B569UPynpWxf28kKj2cbGmy/HEUSR8sgwA4OLjF14BwIcmP89R24RmKKTgIn42od+98QaqmFzflrCKqaJ6trvjiucBk2p9bCIUOjqvxxChPUq38c+TkL++LTSetvIfJBgWKcX3ZvaLjbw+XLcAC1STsnBaveSbQVNulVRORN0d/XJnfDRdwCkWvpZ5ZgBqtfWyLqMyDwxVu4r4GJmdCP3PTrckTkKNHMPc0f46RqkbL1Nq/oeE9W8viWGOKj46l5iN3ijDcY1wSoHHlZt2CUq9GRywwdB6IaLJg2pvh3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:59:26 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:59:26 +0000
Message-ID: <aa805785-1d81-423c-b1d2-8c316bf75b61@intel.com>
Date: Mon, 17 Aug 2026 17:59:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/17] x86/resctrl: Add PMT registration API for AET
 enumeration callbacks
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260729172752.11561-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: b9ee8059-59a3-4866-f1e0-08defcc3f31c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: zTA/g/R0QxrDYglSOrMO7wSnbyJAJw8fRqE4H3yb/Ca5xhsaeg+mVUO+q8hznunIgKLJeRWJuEflPucUxgXhugBhGHHer/IMQ1AyImssXnZy4R/FNBFiodq/7Cxgs8cY7unV01OIF6olld5KP/KeXqJiEH0FJ8y2wWLQ1bFFzd5WVShf7nc9Q0SdMvG+omx3fpferoTo2Du7dcATfxihubQb8TtjosNd9I+a99qKG7sF6JpWmDlhHQ5+oUpuXSjn+loeScF1XOroiEMKiVVXppfhEajjq/y/QXlDOX+BDQPuemKo95XZgDkJ5aX8kZjQqMFPOfFX6BRb9jAE2/u/3ACFM8cu9iNdcA9Ze5FN2kXNGlH55XdzleGdG/5AH+2ALtfrQLOeeq/IQdetqWE1UV51KnNu7ro0UEAm9twVjMIzmHv5xwwsyO54i9CRwXfuhxESNnzHaGEdjj3IbMswwhsMjWIjo7Mxen69OvQK4PS50AhzUO/0MArnl1Ile/6p5d11+DKVHK9izMGflF/CBXoQlCo8U+/llDQtJ4sIb73Jh6jrywx9ZqCRi33VceCe1aEoro1+TWWnBs6NFwPCaZ2+m0aTtNdvdzdzbE4LOdi4HGCikQ3OLNSh20gYAELVP3ZC8MFmVwOU+BatMUBrAazCUH6DCdAFbda6KvR52GxznQlv6wSv+kW8dnvi+WXTaa6ydIM+jOJqJQecAZ9Ktg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTlnaU9CcmlkR0pwaVFQV3BjL2dsVE13Y0V1T0dxVXRwY09nS3BQZlJBQ256?=
 =?utf-8?B?aG1zNnYvUE1NdG95ZkRpTEN2dnpSRkhzc3UzUmVFc3Vna09XeDMrYUQ1UFZr?=
 =?utf-8?B?WlRDS1RuOGFBSEhyZ3NyRGF6NVNYTkE3bGZodUtlS1ArTU9XWHd4LzZPOFM2?=
 =?utf-8?B?NXBqaHlNaGt0Q2pRNnpTbzBDZVJWR1Z2dEVkb29lQUd4UEY5YjFwb0dGZWRZ?=
 =?utf-8?B?NVdYRlFCWm1MRWNabXlqL2grNHZUdXpiVXZrVzBVdUlNTkZQbERFUS9MMTI3?=
 =?utf-8?B?VE1YdVRJU09SOUQ1QzRSWGphaXBxck1uTWxQQ2JFbndSYWdhM2YvckFrVDlX?=
 =?utf-8?B?MHJ5cVBIaTFQZmFFbk1xNDljMkwrQmNlV25QU0h6QzZOU09NdXN1SDBGWXZp?=
 =?utf-8?B?T05hSFlaeExKVTE1ZnpCWXVwNlFnZml1NXpoV3pJNTQramplWFBORHlkKzJU?=
 =?utf-8?B?ZDBtTFYrSXhsR0VySzhScVB5NTdnalBlZUJkLzNsd2l1eEpxTHFnY2IrN1B3?=
 =?utf-8?B?OEEzemJDdnlYRlFEaGtENDFXZmFYRGpkQ1Q2ZGNPK2pzVmlvbFd2cGJqVTk1?=
 =?utf-8?B?UmRXd3laQWVLZTBZTGgzM0pyejY5SCtCQWpWOFhtNStnMGFwVnl1dkFPMitw?=
 =?utf-8?B?cFdrQjNOSWEwb1ZXZXRmM0pKamxnaWpsaXQ5dU5JM3l2Q0gxZGhKbS9oWDFK?=
 =?utf-8?B?YVdQRmw4aVIvK21lQm9ZcVJ5K1k0NnZnSUlyT3UvS3YzRE1iNWIrcWlldlEr?=
 =?utf-8?B?NjNLaDhmU216RUlLdkFsY3dPbCtXZUJad1pLWEVoUnAzMlBUN2dWeUh3SG1H?=
 =?utf-8?B?Y2Fkd0FXVm55RTJoWFNwN1FnKzVGMWViemFsY2VxYmUzVHcvSVlJM2dTaldy?=
 =?utf-8?B?eS8yNm1NQldZUTVZbFpzbnVZNHZORmdvRXh0dmh0aE1mMWhxMU5TQVBMcVVH?=
 =?utf-8?B?MHE4VWEvQlZDaUJGOERFdkF0TUpNQ3UzL2dZcFRjRk1EbkZIT2ZES0ZINXVz?=
 =?utf-8?B?S2lRSUFIWm1GYjd1b1pFbHdTY21vUWxaRkhac0h3ZFgrREZxQjVwd0FWWitz?=
 =?utf-8?B?MGxVUXBMK3NtT1dJd21GYlNpWnord29sR1k2NVBFSWUxVHBack8rK1V5OWVk?=
 =?utf-8?B?V1VXSW92YWN6ZDZPR0s2emZqUGs5MW05OStTalRWT3lWU09XZmJTVTdlYzFV?=
 =?utf-8?B?dDJ5N01yK3hkOTBPU3Y5ejNHYXFOMnFzNGd3MzgxQTZmNWNmSk02VUJBeHU1?=
 =?utf-8?B?STY2T0JOR1JPa3RFVm9KTXJSR3RIRFF4V0dFTWRWdmNyOGVQS3g1WlY0ZEtZ?=
 =?utf-8?B?MW1ubEtSdnRqRGFWMTl4VHFONk1NbUc5QmVzejBHdDIxaFRVdWw4cXl6dXhO?=
 =?utf-8?B?T3dUVWVHV21jVGs3Y0d3Y3pIN3dGb3VTOXdnaTVhdGdMVjRGZ2VjSFRKaXhv?=
 =?utf-8?B?b0N6bWFaVFo0bmEvaHRveWUzRjFaUVNERkVZbWRzS3RkR05wbFpidWdiZU1k?=
 =?utf-8?B?RWNyS2tqUS9YbGduOG1jUEFBRkg0MmlCZ1MrRWFhcUEzTU10QkVPbmdzQnJC?=
 =?utf-8?B?c1V5QTZuQm1NMHI5VGdmdERtZEx3RVVXa00zSkh3dnE4eEY3U1RNOCs2NnV1?=
 =?utf-8?B?N0RROTV4L3V2UjBwQVl2b1Z1dE9Sc1VtU25YL3d6VzV1YVY1dll5dVdzNUI5?=
 =?utf-8?B?Q1A1TStWQ3NERktoYnR0aUc4d09kNlR1MndFY3VHRjI0M0FUWjFzK3Mwbzlr?=
 =?utf-8?B?Qlo5a01ZcU5vWEwrL0x5WlJDYmVhMjJ5anc3MTBzb2E4WnF2K1VIN0JMdWlC?=
 =?utf-8?B?OGxYZ1c1STU0WE1GU1ZRZmJIY1BzMVNCSlVRMWJYNFhoODF6bE9KUkFqdTFH?=
 =?utf-8?B?aG1qMVFQVldNMm52cCtHTGthWUVYdE84Z2VVeFJJSFRaU1NhaVI3Ui9NQjZ6?=
 =?utf-8?B?WXdSUTZLS2E3VVNZWWkvcVRldnBVRHYrZFdaWXlmMG1BZjA0c1dnT1FkZWZY?=
 =?utf-8?B?TEJpeGphZ01HWWZaNHBTdXBWdkVneG1KRzU3K0d3NzBFRlZNUXRkZms4MXE0?=
 =?utf-8?B?WFpnMVRwOWw4WnlTSHNEWXJsdGlqdUZDTVNiYUVmMEJrSHFsaXhTVUJNM041?=
 =?utf-8?B?dlo3eUIrS2lQTXRqWlVzWVo4cEYzNmdNN3Bra1ljTlh6UnQ4Ymk1cUxEc3Vy?=
 =?utf-8?B?ZUY4bGl1L3BrUnoxUmtmU1RkYlBYdGM1eWFpeTh6d1FkSkJMeXRzdEZHbHN1?=
 =?utf-8?B?b25aZ0srTis1WTJid1VGck5GUjVxMHFGUUt4WVI2RTVRS2lNRUpWQmlzSDNm?=
 =?utf-8?B?ekdKUDR4alZyV0lKVzk3blA2bXc2TXcvVUVuMkJpR1FrUTc0K2NOeVN4d3Z4?=
 =?utf-8?Q?hu/XNsARnZdzbEFQ=3D?=
X-Exchange-RoutingPolicyChecked: YQx8QYIK0qajxkewQBX2galuOEbiAKLj8g0AILuTywh6dAscfI1TWOl/S1pgn5+oxl0TQ47EGU5IJH6ZvMio74Q9dOgkfAwtSvbGyZWh14TuuyWT1KJgxEh+4HmWxAAF22mPfZRPEPuD6SRU4haTSVAUMWFkrosBy0XnoQlXAjk62QVHltJL4daticNtqMJMegyr0H2ogObW3d3hMBCH8eonnhomI/FJkcslBhN3iJ8gNt+QAb5dGRt8HUuphoEdPtoJV6wdGL7pKAqwofhFQZQFvIhQQX+ZuhyYujl31H24p4jCL1e3RX9QVmWDhrvsHxkUKzkv6AQTqtoZTvUvlA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ee8059-59a3-4866-f1e0-08defcc3f31c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:59:26.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7NWMuoYjr6TmhvWdcIY4wezkQrDum4bY/mgS1qewlnunq9gz86J8BRRDFJehpN3sA6PozyFoRTAarjn6PKDw6uOWdcJNknlswvBwgIxwRno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> resctrl is always built-in; INTEL_PMT_TELEMETRY may be a module.  Add, and
> export, register/unregister functions so the PMT module can supply/clear
> enumeration callback functions when loaded/unloaded.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v10:
> 	Move declaration and stubs for registration functions out
> 	of <asm/resctrl.h> and into <linux/intel_vsec.h>
> 	Defer adding aet_register_lock mutex until mount/unmount
> 	changes where it is needed.
> 
>  include/linux/intel_vsec.h              | 12 ++++++++++++

These changes would need ack from appropriate maintainers. I am not sure how best
to highlight which changes they should focus on when they are so dispersed and the
subject prefix only mentions resctrl.

Reinette
