Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B131411D8
	for <patches@lists.linux.dev>; Wed, 22 May 2024 21:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412500; cv=fail; b=qeMO088ab4XmNJHivDz1029gG4oddOJbYHl3Ayfc1Df+n/hQq4vWZR6f+x78d55zhQTEpAYbmyBrjzaqIgxgRSqHvCA9E+BnViMzvqAWjepn+xxc/k+b5Vu5n7Gzg7Cd3/Uvv/kmea7JqVFZjzJuTx2nG+69T2VZPETbE/nrEDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412500; c=relaxed/simple;
	bh=djBbhbyKALYYW8ruhUiGJOrtCSUsAwWAVaTja9IfQSE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xk28hvVtPRwbWWv6TvQDrW4NcNkhdNvSUJxMvYg5eFOKiyzH046MiV+m2QKEw1iMymGszUpPyF6zq/1eY8cRX1H5qPy1eE/jFTaX6FyY3+dbIkNsHbUY/INqZQnglR99C+JOr5eSsNrCEx6KV/DZ6iqsVf8VhWA1rwyhM954Y+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kmn4H6xt; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kmn4H6xt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716412499; x=1747948499;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=djBbhbyKALYYW8ruhUiGJOrtCSUsAwWAVaTja9IfQSE=;
  b=kmn4H6xt/fMHyRWoTDs90yom4sPUNS5ZeFBr9Sw98/sMk1h00IjFJfFa
   Vn1JGcNnUtojdjv/C/5DA5QNXE5hVHQjJbagvn4Iam4rDfBfaJt3f2p30
   9a0AlnRyxdzyBTZ3hVwqoL0wyL1ZcPINc98+Fj7/SnZV0UH5pq2gItiIz
   /Bfsy1tMFmTjieM13Of/jhlgmPUyGQ/qAsihhRYJTfufuS+wpQVUjyKZo
   OC7ouyb/tE6O1roqEMtAtKwX93LXKZCXgfFqPihgZx5UloCe7ZLC20bZL
   SniRDdGtfNldyLSzKwtEGWv8OXXKCYUyOlTRHg8gIWw/nubhmv+Tc3VFT
   Q==;
X-CSE-ConnectionGUID: GcSvVH2qSt6lqT3fgPZJrg==
X-CSE-MsgGUID: XEq6HbjBQm215M/mYOb3AA==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35205563"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35205563"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 14:14:59 -0700
X-CSE-ConnectionGUID: U2rmR5AoSJ6EhRc8MQjvRA==
X-CSE-MsgGUID: pOkHKAkCSguKnxUYGXvjOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="70821412"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 14:14:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 14:14:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 14:14:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 14:14:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh+5UQCxtatyRgpxZaI7XA7m+ha33G2tl8A24jUge/1qAgNKJdmAqgCGAli7H30f/rOuzpu0HMc7lGKCXOP46Ayx6YkeYSDG/yJlM2c5JJLfjo5xAhu+SCLCtWsWZw+BeoFjUmFqgD8dpWvv2x9vuFCLTLN6zKUAaUryoU2qHh1VF/CNlETRvqE1lk/meixuMVuh5/l4ExqZEUf8N/SpC+RKQKdFpiw72rxPxEdRWtsA5PFnpdoppx45x4PGqriVPhMKe+zqGDQoiPCpDLDHfAY934Bgq8qmv9UsgKXjNmU47JZQqkMfZgt5S5ViSrz2r+Qx0GJH7DreEgh+Hhl4AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtU6CGXQ8qyIKEjgrada7Vn4Zl48THqKQIVKl+xjE3o=;
 b=PdOLuTpCxcyzq7pBK5cWVXYDCRkVSTwqc8xECMeMLRsMJhlbOvEXsgb9u8N3kS02ytC9xCUswQ3DgzDr9kvKg0Zws3EAJzUc4oRtCvxX1VJHee0UZPfAjOVR5x/UvhiZSufr6w9rewqWYNqOWJKWjZZP3E5CkNksktXp/ecGn4HvL1Bls4ps9sN2azFyK7gTSU1On9q3+yCeMNuamJtk5IgJ/FZvAoc3HdZUrQ+rqCnFhnwg3+urdCPQk1dPCUnN1BW+KyTAbDXNudfU/Dbz7cGnjWXQgl7HAovVWFTZhV0yIdGJ+088gZe1vmjXr3pP2XFS5SpL5IQzTEvJzrk9nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7671.namprd11.prod.outlook.com (2603:10b6:a03:4c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.18; Wed, 22 May
 2024 21:14:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 21:14:55 +0000
Message-ID: <7569db4a-9237-4158-99d1-775fc0854d59@intel.com>
Date: Wed, 22 May 2024 14:14:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 09/17] x86/resctrl: Add new fields to struct rmid_read
 for summation of domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-10-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240515222326.74166-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0143.namprd04.prod.outlook.com
 (2603:10b6:303:84::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7671:EE_
X-MS-Office365-Filtering-Correlation-Id: 25117316-088e-44ea-5934-08dc7aa43a4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UkpxWCtrWTgvKytxMSt2OFFjc1M2ZnV4bko1Qkl5RzRRalUwOURGSGFwdCsz?=
 =?utf-8?B?dGd4ZkNibE40Q3JGMmtTcmdsa2ZTckdiZ0lYVXhRekNSQWNQT3Rsd05uOEhp?=
 =?utf-8?B?K2pDRzlaNTVwd2xXbG5lVU45aHo3OXVnWWllWEgreDdTc1JReitDNm9lWTBw?=
 =?utf-8?B?ZzhGc3RTYUFzWC80OGpXT2NOZGlwTWE4VnFva0FDTXFNeGF1WmtnRlAySlhC?=
 =?utf-8?B?cVArdE1FUU5JeEpnNmp3RXhKMmNxQTFYbjNib09FZ0ZiNjQxa2hueDFDUWJO?=
 =?utf-8?B?UlJiRUxEcDV5KzMraHBobUJZbUxOem1uZThjNzAzMGlZczRXT1VOM2NhVkNP?=
 =?utf-8?B?SWxFRExrbEY3c3NpYVV6N3kyUGNuandXYVp3aVVFY0tjU2FsVjRLNVNUR1VT?=
 =?utf-8?B?RURhL1JiWkQzaThwSWFkYTRpUXpTRXdCcGdPeU1SMkhuSXVQVzR2UWN2NVZM?=
 =?utf-8?B?Z2JpMWZ5TWhZb3pjL3hyZzdzOUw5bjhMUGk3OFlzZnpSenNlUis1MXBnSGJr?=
 =?utf-8?B?SWlOSkw1MVgwSzgydEJpQ3kvK0JqQzFLbjZnNXlkZy8zOWF0OEtKaEJ6cnJL?=
 =?utf-8?B?SU9oRHlPbmhqeWF4N0Y4RmZWdkliTGQ4UlAvU0RraFJscjJZM0JtblRFb2hM?=
 =?utf-8?B?OTNLOEQyOWsvcUl6Ylh5amJZTE9sdURqZ01Fci9Kckl5by94S3dzdXlPTDNV?=
 =?utf-8?B?YlcrZXArMytEWjB6dlFiYW9Ja0xjYUdhVFFHdTlZMGR6RVlHRnBzUEFFZlBG?=
 =?utf-8?B?R0Fjd01Gd3hlb1hHbm0yZng4YkE2U1hqM2UxNHhna1h0TXNTcWQ2Y0xxOERL?=
 =?utf-8?B?SlNCWEVpYnBkVVBQTVh3bFJuTHdLUzVCN1RqUGxzQ1hjcG1uUmxWZUNxM2Q4?=
 =?utf-8?B?eFJpTEFORm5PU04veW1lV3krUlNGYzI4OUx4WERPTWIwcDVmdkNacktodGdH?=
 =?utf-8?B?eCtVTisrM09tN045Y041eU1VSklzRkljblR2SWZiMDNESk04ejdTMjE2OGRz?=
 =?utf-8?B?bW5GQmxxTnVSRU5BanlxZGJxWWM3WjBTN1J4d0E3dCtuUEhuTzgzNW5JOUlU?=
 =?utf-8?B?YXFFSVY4NTUxT1ZwRWxDSWhIekg0SFUzTXFhTk1oei9aRjk0VmwwcDhRRU1F?=
 =?utf-8?B?UWpnRmxoU1BXdGUwUlFTOE9uT2dnNWVNcjU5c0dTbXpYdmk1bUxRdnExdlRI?=
 =?utf-8?B?b3lkTzFjdVI4RzFPSTBQYW9WKzFZQjRJYTByQkN4eHF5RzA3TVlQa0ZncU9J?=
 =?utf-8?B?T1VKek03UDRIbzFLSjdydGhEaFZsUWttVkJLck9iRGZrWGRRWGU3NDIvc0tT?=
 =?utf-8?B?dVBqc05kcG4xTy82d05QMEg0UEN1R1NWdHJCaEQ5NVMyNFFBVEs1WXpQbStU?=
 =?utf-8?B?WnA5MEcrQVBCOTRtRy9MNVUvYUZ6cWFvZ0pBNHhuSlBiMnVxcldWSlpmYWZ6?=
 =?utf-8?B?bHRmcC9WUHhreE1Pb09Oa2VJR0RQa040MEJ3aWhJZWdJcUhLRXdzZmlnN0tq?=
 =?utf-8?B?dml5ODFmcTJ3WGozZVQyVVgvRnhHeGc0NE1CWi9Rekd3cU5mMTVtTkw1RWhu?=
 =?utf-8?B?WEtBUHRpNHNDaHJOMUdxUmFBcS9LMW82NEFnRFhDYmN4cE94Rzg5eW5VbW11?=
 =?utf-8?B?TDEyNHFpcWVJTGVGTkZEQW4ydzI4UmloUjRteUFIMmVrQnh3VXQwTzBSbHcr?=
 =?utf-8?B?ZVI5MSsvRUphSWF4c3J2VVJxQko1ZmV4alAzeVRhQjUwNG5KZGgvTU9BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDlaVDViZVY1dE9GRkk5TGtwS2JMSVJPWVhFNmhDWE5xalhKTmw4L3hTMWNy?=
 =?utf-8?B?REpqeWFpY0dTdmJ0Nm9kTy93Q2QyV21mY3g3SHF5bmI3ZmQxMVVFQUxhQzE1?=
 =?utf-8?B?bnNYK2p1VFlKeUhLUVJ1R3prbE5qRDdtWFA0ZXhqMXd0OFYwV3MxWG0xZytn?=
 =?utf-8?B?QktraWpJYWNoVSs0NjZTRWNRQXo3ajRIeDdRYVdDUStOWWkxdWczY3BqZng2?=
 =?utf-8?B?UUpPU25SR0pKclpZeTg2QjdnTTErU0l4S1BrakdVeitRcE5jUFNpdVBmNWpt?=
 =?utf-8?B?dmdJQW5HQWl3QWJnNEsrRjUxeHhKMUtyQ2NTWVUvQVdkdEpkL2tJS1lqdFlC?=
 =?utf-8?B?TjAwM2oxRGt0RmhhMGRRWjlNUUlKMTgwdGxVUk5mRFVpdHo1TzlLMm8xenh2?=
 =?utf-8?B?RnBmeE9NeS9XcDI4MC9VMFhPMnN3UmdqVExiMDd3c1pQcG1RQmp5bjJheUd0?=
 =?utf-8?B?MEx4cmZMSVJiRUtWTGRPd01JQmFQWjVOTS9NWEx0TjhndUh0VmMybk16SGpu?=
 =?utf-8?B?c0RqSm1UdUNZQ3RxZm9rbHRNVVFHeEhVS29ST0RSeDJxZXlNMEFwYTE0WlQ1?=
 =?utf-8?B?b0EvY0I0ZExtVFpOZ2UrT2hOaGF5S3J0aEhIdHZuSnNCZjJQdmp3L3cxOGR4?=
 =?utf-8?B?d2lxWndsRzVQbUk3MDMxaFBqczFUbEZnL3lyU2ZuMkhCQjFTRHliWWVUTUM3?=
 =?utf-8?B?SFdNZkNWS3NUN0RwR2hjQ2VCeHpCMWNoMFAycm1pK3JwMm0vTmlud2oxaHM4?=
 =?utf-8?B?YWFwWHdzQXZudkxYSWY0YS9VaVhkUDlENktVRCtMc1hKR0kwUzBYTGxCakZy?=
 =?utf-8?B?SDRnNGJQUFJhZEE1ZHdKcUhvSnBIK3FGNjIxZE1VV2JtaUFXb21xbXJzQzZp?=
 =?utf-8?B?ekJJOXhKL2NudzR6L3dmdC9jZTQwQzhSV29LdGUxc3NtTWN3Q0xQaFRhVCtX?=
 =?utf-8?B?UlVuYUN5RkwycktEYWs2alVtSlRDaHhqQ2U0ODRCRmVlelBHRTF0MTJScWRS?=
 =?utf-8?B?dGRQTHltemFaYk4vc0N2emFnamo4YU1PL0VhbXZQanA1WUhuUXNiMkNRYjNB?=
 =?utf-8?B?TVpkL1pIdTFDZEd6bHNFb3hsNWM3V0dQUGZsTVhaU1VFaCtMcWlRcHBaNWF3?=
 =?utf-8?B?d3hRcnJPR2duME44ampIcWcrTTlpanVJYWhic1RyNDB5NXZwK1hnRFRqMUZs?=
 =?utf-8?B?VGk4S1pGalNOZzBXNHh6T0hyVkxkbk5ZcTJjZFBXeWNPV2h6NGZGeTF3Q3ZP?=
 =?utf-8?B?Sjk0cTYxNVVObmRIZS9OMlpNelJpSldZSitadVRMSFNEUENVV0dNQUg5cU81?=
 =?utf-8?B?MlBzTG5XV1U2a1I0a0VYUU5SS2tNRkVNeUx6T01FMEdvbk4xRHg5Nk1ubWlM?=
 =?utf-8?B?bUNYUEsySW9LYVRSeTVMQ0xXZWZHK29IU0kyM2F0dWtDN2w4NmVYb01ZemdZ?=
 =?utf-8?B?U3BZdjFFUDVyMlYyU241UXB2enVBUVFRQUVUOGEzWTEwOVZPYjNPYk5ic3ZJ?=
 =?utf-8?B?YmZIVythckcwQTBvQ2pDck01UzRTa1hwMzUvelBkbnVGYTFYNWlYOFI2LzhC?=
 =?utf-8?B?U25oUXhaRWVrVERDSWNvL2F5bHFhaWlUeHZXS2ZocjUycTB4ek9sbnRqQjRF?=
 =?utf-8?B?elBTUmNIdTg0R0x5NDN6SU9lQlA1MkdjbkgyclgxODNSU1JzMWdKaGQ4K0lE?=
 =?utf-8?B?c1YxU3BIUW4xd0hnYjlMcUNHOW5VVk9HbENtOSs0SmNWY2FhYVhmQzRJTlpn?=
 =?utf-8?B?VFBJRWR5Q0E0L3p6TThacloyUytTN0F5bmlZZHkxdlpWL1h3QUQwbkFvZ05q?=
 =?utf-8?B?UmR6cHpMaXBjdDU4dlhGWkVqVDcxT3ZlZTZZOHVPRENCT2pqelhuVEl2ZFNL?=
 =?utf-8?B?VExqV3RHT3VBcWJkb1cxc2Q0SVZaelNnMURNeHVCOFhOelZ4eXhNTW4rdEIz?=
 =?utf-8?B?OUlndnRyR3I4c0czL1c3YWJ6SzMrYWc0QTl4TFRXTjlWeDRKNW9kZFA0MVFp?=
 =?utf-8?B?aHA3Wm1aTmEyUlpxcFVCSis0K0JnVTJvYndwNW9tRGsyV2FVb3pyRmNwT2JJ?=
 =?utf-8?B?dmtYVkFrN0VHdkJSYkJtYlk4TUJMazBzSE56TmswWHNWMVZLbU01QURMWnVI?=
 =?utf-8?B?dDduM0ROdDZOZzdzdU0zRDluMzBqMm1nalhzQ2RpMk5kUjBxdFlpMWxQempM?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25117316-088e-44ea-5934-08dc7aa43a4f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 21:14:55.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ja/hpNDGMJdHuyAr014mXvVBW6UtutzXQVsad37TH5wktscHzE7PPuK6c0LMcZZJy/0ZLgB0KsBLGykGsmWAuAz0BHh6KfuUcSQknDjbqCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7671
X-OriginatorOrg: intel.com

Hi Tony,

On 5/15/2024 3:23 PM, Tony Luck wrote:
> rdtgroup_mondata_show() calls mon_event_count() which packages up all

mon_event_count() -> mon_event_read()?


> the required details into an rmid_read structure passed across the
> smp_call*() infrastructure.
> 
> Legacy files reporting for a single domain pass that domain in the
> rmid_read structure. Files that need to sum multiple domains have
> meta data that provides the display_id for domains that must be
> summed.

( ... and also for convenience pass a domain in the rmid_read structure
 ... more later)

> 
> Add the sumdomains and display_id fields to the rmid_read structure.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 49440f194253..498c5d240c68 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -150,6 +150,8 @@ struct rmid_read {
>  	struct rdt_mon_domain	*d;
>  	enum resctrl_event_id	evtid;
>  	bool			first;
> +	bool			sumdomains;
> +	int			display_id;
>  	int			err;
>  	u64			val;
>  	void			*arch_mon_ctx;

These new members have enough obscurity to make this a good
point to document the members of struct rmid_read

Reinette
