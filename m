Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D411D416C
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 02:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788746906; cv=fail; b=RMei7sR58bbXd0t/MgLfdhwVSbyESSeN8rAhGTaSqvPlQxQBb6VjvQfTwtBGlTpVvhJd5TNUd4FkdOmYqlaW9jEyb2cACQyx1M59lhFg0I9bWH+i2O4KesrZNNJHxVGx6XwLygY6jLx+ZOx0ikjGUtD7tYsL6DmHLcIKbvDm8ss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788746906; c=relaxed/simple;
	bh=JvabZGl1q3kCx5NLkOH2ACCHNe6g/3miKsXfVXXS4EE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M2E7fvru0VgjJ9s0UmXZAER/zRQMh9vj93Xp4ctivBMCQtvV+opzG7sb32rqu7a3j3Txdl0cnCECNoBqPTS6InSJT8CjbdxisqODdeUQ1qeJs2+MCjQ8cb+/svjPMEi2n3QJfXbwLVB+PoM9sKbt7sgEK4u+zuUwqVzx4RwB7NE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LO2l13d5; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LO2l13d5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788746905; x=1820282905;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JvabZGl1q3kCx5NLkOH2ACCHNe6g/3miKsXfVXXS4EE=;
  b=LO2l13d5nVkj/31dhRJ4kXnVDiteemfNCRedqHS2nmO2fOo0xJTt7jsJ
   g4m86V9nq5Ht0yLWOJbW+POgq6Ep2QJcOhfk8Acw55WtX/vHUjC/fJ1ty
   pH3fh3kr1QWnbyBmNGevQuYVLiZG9sLQsszBzlfpU5rerb9noi9REILko
   zXN8pxncATxZpeW/PT/VXi83upm0YIq8JQpWbblAS+cbQrwotao/w9Cxy
   CBITnKH7qg2SUWYJvm0V7NHWnfo87c18xTui4Yrk+oUS/2HVFsTa1lDnU
   uJyHEH1Wz2WTzBAnvHZDAFTDYjz9dpSFN0tZqNeI9pW/A8hpikgh3I7+g
   g==;
X-CSE-ConnectionGUID: IC39nQbMRjWLtAPInUpu5A==
X-CSE-MsgGUID: HIKbpILFSca1uPCuAD9Cyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11898"; a="106515073"
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="106515073"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 19:08:24 -0700
X-CSE-ConnectionGUID: Te5YfPDIRsWNXRGmvLzAuA==
X-CSE-MsgGUID: 7Qihl6CPQFGgBS6H0yX9gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="268838884"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 19:08:23 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 19:08:22 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 6 Sep 2026 19:08:22 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 19:08:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gd3n/NcvfJvFVWbyfOJKKreK/4L+U/Win+T31SaU5qaRG50o/HmZN+yuNLGExLN8VHU97I1V7vYPWC7d4kWtrsQIa31wCeuLTeJkpdicrbaji/2/ZZ7HFS4LN67gX7tmvpL9fmnevrjHChjaqtEb+DmBzt1JN0WqoGpHXVZ1rSajSEtnIdpZhk7rtjh+HMzfO2/vc89J61dawj40DVg8g9Cdqg7gK5aHg0IcOpk3DTYK7JqgASnpL0ezcXDzMKN2fidlGFDpGdnUnWyjdfKjUEQQoDQdMz9lJRPwGhiXFj0Konzcxh7bIUl+qj1O1IUUUTg6eN6U1XNPTHAWLELOUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brosK2my/zV2Qmb6YM0J3qdUM6p/Bupm2vbIsN7JBjo=;
 b=ct19xC7klfwxk9XDnYa6k61FO5oOTmYWxQw9nLPRCx+P3raH8kdCP+FJ5wrAayb/W2tjGIpnnHemrYzWRiCcrB/n4i8YQZ92lbFfQognZZM9d0XhVGfUqmrOeZIMgGZT7l6Yyl8ZKNP8yK3G10ERvt5+HN3m6NLSZzDzbkANbamMQsU+nigw40HieRhHEMskhkJRZ7pYY9G69E6XTpQTBMnpZ5Uy3gM8r+wxDfZStzrC2t83zieRQ3dCmIrkTEpG/uQRJ/pX96H3DpAAQu2v9llhAfg4tygEwLeZqOZOLIJKZ7qOlX7OzTx9IDzMwEGA76SonBrmCVL4NewSXVIomg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH8PR11MB8061.namprd11.prod.outlook.com (2603:10b6:510:250::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 02:08:20 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 02:08:20 +0000
Message-ID: <f5836c85-189b-4c5f-acdc-f77ec6d24263@intel.com>
Date: Mon, 7 Sep 2026 10:08:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] fs/resctrl: Drop support for different bandwidth
 delay mappings
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <9d39435847fb26fa7b467c563cf8bc45c314b917.1788452481.git.reinette.chatre@intel.com>
 <apo8AKv5XVggDE3J@fengwei-dev>
 <b5b1fb15-3a83-4b91-b9b8-8bc724e5312a@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <b5b1fb15-3a83-4b91-b9b8-8bc724e5312a@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI3PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::13) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH8PR11MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: f6f0c7c8-fb8e-4ed3-23f5-08df0c84e33f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|10067099003|56012099006|4143699003|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: gOpC5R4nY/roj/HP6W/keUm8lgYMA7FvUj7gpttdUgrU8ZLa/AJKIt+XMTKBL7kDZfTpbvbDppVXsqDeGMISxm+OnxZFH7lkHjSzZxKyHByrUfXheuY+TbxOCl7KwjNB4X2prNa9y6p5pBcq4DpqUtYcfkmL3qj+dt+dRdlkVbJDFgIyVSf58fqMEJ+1Mh1zey+rntHraG3/m2eCSbWCwQZ4p52h6exbwBiRT6VLxr+29sA3dR+jg/AnmUzk18E+nm5WRjPXUnDupivnvDk0fl0nMx6JAvs9krcfZZJumFfyccBRkwPoI5wwVSexu3NKP4PWrSEgidxMr1BwW5zLgjVoXzWa9xCn3GQw7O13nBbroNzkWP8HkfWUAzAJ2nhAjnudeI+t+hPT+S+P6BeR3VTZdCyNzdAbjcfCYPrpnQDNmqgBh+gN3AryYrKYRCkLxbSnxM9sNaMaV+/DYMOJCD5cJ+m4T7pA417VxPjip8kFBEfqhoaUNGJb+S58NJow9JRhPY8dzNJX4jkH/Ap12zsjqAPvYEVIjfY5dBOTi9Q7BOZ4qIQWTotuLNCuD2GewYCHxHcP9WA+2HS5x3Xe+66ClqafJ377hF4ECm6hMz1maUryajW8LJj9pYBlKmetg6wUW0psF9CSsVmeql8EQ+1deXH2uK3mwaOW044MVlU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L21RbW93RHF3NFI0U0lRaFFVVHFFalpiMlFUV05DV0trYW16QUdycXluczU1?=
 =?utf-8?B?WmNJbGdSbEN0Z2JtQld3OVNHSmZ1YmFHWThpRXdSRHYwY1Zvc2pYbFR0b0xB?=
 =?utf-8?B?ZDdNdmF1Z0EvYjUvZkdnSXZMU0JweWZGNWttaDdicDduazkxblNXZ0JwL1NW?=
 =?utf-8?B?L3pRZThCdEtOaHdhSnY3SHlxNFlRK3ZvNS9ZUnBCVEtlQlRDTWxzVVVienUx?=
 =?utf-8?B?SzJPUyt2T1pCTFg2SjFzTXp4c0pKT290Q0FBVUtXTXpEMTN3Z3NxcVozZGlq?=
 =?utf-8?B?SkFtcHVBSVYvcThCWWxqWVJDRXdqRjRCZEkwZDJVUE5YMHpGUXAvSkdZVjdL?=
 =?utf-8?B?TjN5QmFkVVpHbzYxWnRTYnRNcFdDL3dtelNBaHB3UHZTYzBlY3AzdzVrWHFu?=
 =?utf-8?B?WjdwUDBLNFQvK0hyVzM3aGVxMVh2czcrQWtsMERwNzBrRWl3blIzZSs0YVBz?=
 =?utf-8?B?TUw5OXZCcWVJNGhoMmpvQ0xMVjZZcUJlY0VlNXpOcnJtR3RRR0ZRanc3Sjgw?=
 =?utf-8?B?T3NFUjZMSnp2eEdrclNtR2x0M3hXTGZnWkZzTVo5UTU5ZEs1RFF5K1dsb1NK?=
 =?utf-8?B?NHNraGsvOTM0SzhMdE5EdndaU2Z2a25OWFB1ZG50Q1pOUUVUdUNBbTRRcHlB?=
 =?utf-8?B?NXA0eUk4UTl0ZkNiMWszSTIrL2xJYVcrZEdWanRyek5hMmxpWk8rRjBFbWM0?=
 =?utf-8?B?bit5T05sbEptWC9sbTFLaWo3Z2VtdGhwMTlCM3psdkdkaEdSckJaQkZEUDFP?=
 =?utf-8?B?QS91UldlZ0ROVnpSMDJGbTFvc01nWFdjRXI5OXFtMEg0SHdia1NpSStXeEZM?=
 =?utf-8?B?ZmFDdU02djNKQVM3Z2JyREhFdXFsNFpFNzJHaGFQOTBRYTdjZ3dEdG12Vmx2?=
 =?utf-8?B?czE1TXd3clk0VmNFL0hGSStZell2WFlaVGsrbWxtNTJvQnlWM2lpd2JhWi9m?=
 =?utf-8?B?NXdkV1lwUUg2eHFkeGE0eVVHampwUWcwTGdNY3ZnN0EvY0ZXTmtiR0NzWjlE?=
 =?utf-8?B?VFJGR3FNUGJEN3dqRGxwYlZmNjh6S0pNcFpTM0NPbHdLVks0L0xtcmVwTTNu?=
 =?utf-8?B?alB2MlRGd2NCWSthSklVRUlITVhGZFV0M2pYR21HUFdpdi9LQ3BwTjdCaGpZ?=
 =?utf-8?B?T0V1RlRjUDhPcXAvSFltbGZrVXRPZjI0NGdzZjNMUnQxUHBNcDI3dXlSSjNI?=
 =?utf-8?B?R0FrM0Y1UWxRK3dEaXJ0ZThyVUxpaG5pU1Z0WjdYcjE0SkVLVFd6OElMRkNR?=
 =?utf-8?B?UVFHQUFSMXVYQm80eWpmajF5Y1RueDB0ZlY1NGFLT2QrU3VmRFhiQjBZRnJE?=
 =?utf-8?B?enFwSDBzTXVmcUR3Mk51cjZPQUdGMVU3eUM1ZDBtc0dFZnUzblhWeU1YeklJ?=
 =?utf-8?B?YmR3ZGpBRDg0VkxHVXlNL3MvVzFNK0pDNzQ4NWhNSXRISnRGYWVaeDZqRURw?=
 =?utf-8?B?K2tVZG5iNlEyQjFBL1E1YVhac2RGUHhjS1dVbWhjY0JrdnpkM3hndUM1Tjl6?=
 =?utf-8?B?OHY5bW1mcU9OaFo2a3BmM1ZyM3piakFvR2Y5Ung3bk5uaGJveDAvVzRrU0lV?=
 =?utf-8?B?WldJckJtS1Z1aHRrZzBZM2U5elhidkVFMFA0aVhVaHhzejM1Z012MUVKQS9Y?=
 =?utf-8?B?OGJRbEMzSFVxNzNpaW9hQk9HNDF4VlFOMW1XYzlvWWJkRnJvcWh3Zk1qTU5K?=
 =?utf-8?B?SUxQbnE2b1Z4Tmh5ZFNWUkJJcnR0cTc0TWE5REtOd0pYOHJYaDRoL2tnOGZD?=
 =?utf-8?B?SWVTejRlbHlnYW9uSWpnbVBsUWxScUxUM25zVlhMazVOM244bnd4Vy94Qjlz?=
 =?utf-8?B?K2RhbklWNDBDYTFHZjlVc0cxdkQ2em1XQ0U2b1NBOElPSVR3dk5oUE52cHRZ?=
 =?utf-8?B?ZWwwK3BJdXlYK0IzalpJVG1aQ2toMkpEc3JPNjZydG5sSjF5b0FaOFdLaGJ6?=
 =?utf-8?B?VUVRcmswdUpYdXQ2YjR1cXpxRzR4SXBPVmJvOHQxUFBlNE9vT0ZkbDJlV211?=
 =?utf-8?B?aytFYUZsc3BYU1VTdS9idnZBcHcxRFBWT3J4WEZEZVpQSHEzR202bUZTbDNH?=
 =?utf-8?B?a1hNcEFSeGtoQ3RuREpwcDdXdnErVlNDUHE3VFVWdkN1VXRnMTBLVndCVEpm?=
 =?utf-8?B?MDZQcGQrNTgrckVBWEZnQ2lIMlN5cmp2cVFCZENyN01uN3JISFA0SXBsZXdv?=
 =?utf-8?B?aGFaL2tSQ1FKMnV4eWR1K1FYQlFsRGMyTGVoQmhlQWd5RlAxRFFwaVprTExa?=
 =?utf-8?B?YzVRUndTQzZCeHB0T3NjS3g3aHRiMEhjNVBxa2kvbHdtSTJhQkZiL1ErT0ZI?=
 =?utf-8?B?R2pCVitMNE1kMDVjSzEzYkRUYnV4dWUzbVFraWpHSjVZOUFDekVCUT09?=
X-Exchange-RoutingPolicyChecked: fwH65Sns1d2sqMqA05rCvgX4fUN7oQb93qICKd/hQviiaCSzo+Goob5wwihpK+sfVcrTqRpOA/XccsAR4RRxF/NiG+P0AY6Z4MhKdK5tEoDsMg8JR+qfnmtX9cl8KzP7qiDBQROzcHC2HE576G6gutsDvkC2Uj7jByGNT0K4tBMf4FtTXjxLV4FWAuxrvKdhPaO4/0NhFCQArE8Y5ALbnkkJw9rRERiwjUbgXvJo0SuShbiKiYW4EyjfZ6evNS8T+cLr4saWadsTi4KxaKks6W4vyIAcdeszLtVH7uViFKcCGXT3AZWiOvv79c/4xZ6rCjW+pN0ooXcaIKeb3kg2Iw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f0c7c8-fb8e-4ed3-23f5-08df0c84e33f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 02:08:20.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fT3zbi3zJNdM//F8R44GKiZQCJdYwDlWejcvyR+OnQbNvLEpIWAIXhEMHm9SWYtA7IJHTSsvC4stEPgZHhww8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8061
X-OriginatorOrg: intel.com

On 9/4/2026 11:50 PM, Reinette Chatre wrote:
> Hi Chenyu,
> 
> On 9/3/26 8:33 PM, Chen Yu wrote:
>> On Thu, Sep 03, 2026 at 09:57:03AM -0700, Reinette Chatre wrote:
>>>   
>>> -/*
>>> - * Map the memory b/w percentage value to delay values
>>> - * that can be written to QOS_MSRs.
>>> - * There are currently no SKUs which support non linear delay values.
>>> - */
>>> -static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
>>> -{
>>> -	if (r->membw.delay_linear)
>>> -		return MAX_MBA_BW - bw;
>>> -
>>> -	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
>>> -	return MAX_MBA_BW;
>>> -}
>>> -
>>>   static void mba_wrmsr_intel(struct msr_param *m)
>>>   {
>>>   	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
>>>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
>>>   	unsigned int i;
>>>   
>>> -	/*  Write the delay values for mba. */
>>> +	if (!m->res->membw.delay_linear) {
>>> +		pr_warn_once("Non-linear bandwidth delay not supported\n");
>>> +		return;
>>
>> Previously if linear delay is not supported, we still write MAX_MBA_BW
>> to MSR, and here we return with MSR untouched, this should be the expected
>> behavior?
> 
> I believe so, yes. Two reasons:
> a) This is not a supported scenario. This code path should never execute
>     and already complains loudly if encountered.
> b) In the unlikely case that this unsupported scenario is encountered I
>     find leaving the hardware as-is to be the safer option.
> 
>> Besides, in patch 2, __get_mem_config_intel() returns false for
>> non-linear-delay platform thus MB resource's alloc_capable is false,
>> do we still need to do the linear check in mba_wrmsr_intel() in patch 1
>> as the code path will not be triggered?
> 
> You are right that the check is not required. I view this check more like
> why we use "lockdep_assert_held()". More specifically, it uses the code to
> document the requirements instead of comments. For Intel this is valuable
> since the transition to controls and their flags means that when a developer
> builds on the new resctrl capabilities to initialize multiple controls it is
> required for *each* control to have the "this scalar is linear" flag set. This
> test makes that requirement clear.
> 

Got it, thanks for the explanation, this makes sense to me.

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
