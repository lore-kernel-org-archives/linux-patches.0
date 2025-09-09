Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF88253F12
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452359; cv=fail; b=oIdfKUpg688Ax/tpMM/PcbEbZOq6LXhEqqNWdTAev8XQGEJPzMwJWFhW27tLsX8gZQ4ZHnH1JsHaz641FPpOAvlp00412ZhFcUoTIpb4ayb8o8QVAgCmvtxk+VGAAviJ64N1tOvnkqYt4L6jOepNTDfmg+qw+EHWuWpINycTZ30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452359; c=relaxed/simple;
	bh=NNBWghNqlAsAywUkvPxLJM5dfD2uFVOBqkJNs7P4t2Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KH3O2tWkrRRPEjPf8uwuBty9fKMsq+XfwE15xMLUsNoxj0hEqY8t9Wx8ISmOUQYzeFovgj/QzF5TYXVNgQAMiKv+Fv4iKUEm+ZzT6ArjVusibLKPldwYVUguwrDINLpIZqLcIxSjQWkvaHn3clphOLCOcmnwra5X6rHqlf2Jmq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EVA493EK; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVA493EK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757452358; x=1788988358;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NNBWghNqlAsAywUkvPxLJM5dfD2uFVOBqkJNs7P4t2Y=;
  b=EVA493EKWif7D9/4PpsC3aWduXizZFX71bZbZyBcJTBMnDzXPPW3EZsn
   gG96A93QgLKLWtgO6DDpIFAM1Ep1fEMrJ5KcS7rnve8k1efbpjubGNC0t
   WxKhLuS3VvqVlW3W1a97klQ2jdwrVM7eiZN1R3k3npki3pYYpJq+k541n
   cRPowrnEOXJ2x0Kw+6BygM8d9IrCD0twVMuT46knoXPUOlnTCqnLmMgRb
   /OSoXq4KeN6DUGiBO/ivaon2vUIA3ocY7WPN/6UNGkAA7FU+K/keFbdhO
   7CUIYg83hRCemIYWVv2mDkhZvn8E89byzoB29GmACIZt0qbKrubcAkaFP
   g==;
X-CSE-ConnectionGUID: Sx1dE+v+T5edIDYJFOJ/Mg==
X-CSE-MsgGUID: LKQipoCTTm61KhkhO1XcBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59445214"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="59445214"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:12:38 -0700
X-CSE-ConnectionGUID: R0N64J80QVSsTLFWW5Gw2g==
X-CSE-MsgGUID: cQRegxMlR+ushV5L/t7lpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="177536724"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 14:12:37 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:12:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 14:12:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.81) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 14:12:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkaXnqqir+YmvcdqQQMuKiIuyBKnDd/b77MAPfPcCtG0Na8mG1kP9ENVXePgJKV1eKjDnNcofJEB8b5CRaOSkCvopHZMZzi1+9VVsN3iZ25JGJEoSFEVtaEpd2Cp5pDBEPOXQ1cLkYCDLWSCElP879PnpWM93Y7kW/pqYAZhREgrGJyp4beYQf3FSbt01mrBwHnjzxe0ArSxkEwqNR4q5oqQ2oG3eRieYkRggzVuaiCbvSxP/jKLGPDknY/Mhkq1zHzSMmyN5+ViCFjkg+YEfPq9fnWmiRfzGK9OuhfM/kiM3XLK6zkpPXCzA5f1331Bp/xsBCo72mOHMBqJfpkc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jzlewgz4S0GwvAhvvF7pZMNj5oPvAhOLB95l7fg3UIU=;
 b=qRm0Mithwakqt9yfxeNqpJBbR6y7CIBeQeJy8NjpIP/74HTbLZ8Ktfi3KG0f/yGL8AUNImUg8cdzAhkyEpg06hM2/zq2mN4X7FnmhGiRpktjUOhpamaw8cAWI/DwUMHc5HRgiDF9tua7nzYyNT+c0So438mAAM11lUNPxem3NsaRKPZAuXaiTSQR61unMykZrb8ekDb0usaD7TsRW7iY1STEK8PoT8QAN5aiboL/Islizc6el8SCIOaUJmI+xG+BfYHbT4MM8JFHgwCKy47BcbrHJiOAEQbrw/Jee/HV/CJr6/YoO+wlg7Q0V5RE83PAQhN9Q8Xv1Pp140AjtRAZJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB8985.namprd11.prod.outlook.com (2603:10b6:208:575::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 21:12:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 21:12:23 +0000
Message-ID: <d947f2b7-e2ea-4ebe-978f-73ee6d674567@intel.com>
Date: Tue, 9 Sep 2025 14:12:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/31] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:303:b7::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB8985:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a1ac48-27ea-46cb-f3a4-08ddefe591fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WnFOam9DR2IyenU4Z1ZQbXBsbm9KNk1kY3VYSFladEJjYUhMRjJyNVZLUyt0?=
 =?utf-8?B?ZkMvcWNZdzkzbmx2ekh1YzN0Y2xrdUovUWtQMThwYXJYT0xkMkdJbXRJRm9P?=
 =?utf-8?B?OGsvcjZxMFY1b2ovYmQzODlCSFR1emcxSVBEa2VvYi9nVVptZmR5NEF2QlIw?=
 =?utf-8?B?Wks5S1dYMHpJVUsvNk9TMFVndWJicXU1R0h3N3EyVFVGVFpzNVY5Z2J0QnYz?=
 =?utf-8?B?M2xhMnpvWUFXVEEzQ25tbTVVeGR6ejlaa0x3Q2w4U2x6U2szTUkzTnFyc29v?=
 =?utf-8?B?KzJPQlF4bFY0UEFCUUZ2QVlNN21rNE1CZ3ViYmtVc09mNm54bXZtMklJN2Jj?=
 =?utf-8?B?dDh3eUdzZEVIRnBpaCsrS09HRWNkK0QySEFLdFhhakp0dnRTYXdYQUh0MkpQ?=
 =?utf-8?B?T2hUTlhRMG14RXJHTERRS3NsYkVzVDFtTXVBdlJTV09pUGdnaUE1c21iRmpD?=
 =?utf-8?B?dE0rNnhhMnJoYlRpYkdYTW4wYllXQkRoMUQ4RkJNeVpwcXMyWnkwRGZVSHFR?=
 =?utf-8?B?ek9CanFUbjVuS2tTL3lzZ1Q1S0pPWEpTUkJXenRrR0FUVk9XeEtwOFpUUmFV?=
 =?utf-8?B?bzdINnNPRDc2MSs5SUFCdDhBQi9KTGZZWTRXZnRZcjJkczdORk1GQmUxS0dT?=
 =?utf-8?B?dmZrdXB5V3FpVHRpYzNkWjdqT3pGRjBLWTdLSUdSYnpEa2tTaVk2ZUNONnJ4?=
 =?utf-8?B?d3NoUmZnZzdzYmNWam9MSEcxU2J2dnFyMEc5MmUyeW8zZCtHY0xKSkFkU0xj?=
 =?utf-8?B?bWd6cUNBOWVMWUVsMGx1VFVqeUFoVWU1a1d6dWNCNVEwYW9UNEI4bXpQMGVa?=
 =?utf-8?B?OGJaeGw2dVJLVTVZRUdkOUdjNUpjcHlVaGZaeDNRRGZPSDhiV2Uvb1RiNFFr?=
 =?utf-8?B?eXdSRDRBczk0Q2dPeDczS2hzVWw4cXZRa2ZkL1pQc2VRc1piSmJxYzBUYXdh?=
 =?utf-8?B?Y0VWdFBPQkFOWGo4VVNHOFQvVFhzdXhhaW95YTMwNjFYM004dk1KTnFvV055?=
 =?utf-8?B?c3FvWGJuY1pIV2JOMlAyOWYwdktwM003MzUrdzNjby90UXN3OGJPbGozbVZj?=
 =?utf-8?B?d01XVHp5NFlYOWhVdXV0SFdWS3NLL2V6REZTV2lpWXBjT2JIRjFNTFRsV2Vs?=
 =?utf-8?B?QnM3cmJqZzlYOWhXMFhUZk9PRE5sZ3RLR1FPU3BDTEQ2dEUyTXcwTm03RWRo?=
 =?utf-8?B?TjZqTlQyanZwZCtveG4xYkJDd0ZpcFJnM1pjZFhlbTlzczVMUnJQQVpPN2Y3?=
 =?utf-8?B?U0ErU1Z2aGVLdGhyRkV0NGg4cjdDWGcwa090ZU5zVFBQeHlxZ3VYMEhRZ0JF?=
 =?utf-8?B?a2NNM3JGcURvWmVyVncrdFphcEhjdXlDSFpoSXQ0UWJvNnJGRmJRTW1PT2xK?=
 =?utf-8?B?TWRadGZFekwvQ05xY0toUFAxMjJCN0FaRXJ4amp5dHFjQTRXU2pQTm9BV21V?=
 =?utf-8?B?Y1JzVHhIWVJ5V3JFODU2Ynd5ZGtJT1VRejZKdHliTGNtTTlEQUN5OWpHcDhM?=
 =?utf-8?B?ak1XSENGRlRGUjByR2xJMmFCVlA3dzRsaElGaXg4WFM4S1BoY0xnK0dqZXlW?=
 =?utf-8?B?NE5lZEpxRDRjeTEyRXFQQlJmbXp3THFmZjZ4ZEVhM1ZxVlY2QTJHaUVSQ3BO?=
 =?utf-8?B?ekpHVjVFS2hHQ01SY2pISFB0QmVqa2l5OXRPQ2s0N1haS2E4c0pzZUYwS2Ex?=
 =?utf-8?B?OG5ZcUFNSm1vOEVIZWdBcjIvVklFcGY0Z1RHbVFrVTJmNlZXdUNlR1ZvTGtZ?=
 =?utf-8?B?ZU1aUWR6c2MwbTA1R0VCSzFNNUxJeHlxYU9EVzR6ODFuSitWQmlDNTIydXlV?=
 =?utf-8?B?cHErcUdrMGNhcmJrYlk3dC83TC9SQzgxQ1YvdGFOb3hxSC8zY01QNWxlcjhq?=
 =?utf-8?B?Ujg4K1hRSWdmd3k2YWVzRG1rVW1pdkhzQ3h5Z3BPQTJIY0c4NlpJZWNFeDZy?=
 =?utf-8?Q?LnrRdIGbUbI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnhIend3WWc3Ni8zS1JiR2tBWkJMTzFZN3E0QnVKM2lYOTRlckF5NnNwMWd2?=
 =?utf-8?B?WlZ1VXgzZFVvcFV1TklFVEwwMjI0QVVRYzljUk8rQkdOVGN1OWNCc0hjZjJY?=
 =?utf-8?B?c1hjM3FKT29UOUJEUW1jdjcvTVJxbU9VbXp0MTZJZ1Nsd1loTGtNQlVTQmRI?=
 =?utf-8?B?bXFnODhPYzZFUmRZdkVsNk0wYXpoczFDbVQxRFZ4SlY3YUdGcFVrbTdwZVZC?=
 =?utf-8?B?SnBPdkplSytKckUvT05iU0NLYkVrNklQVDFzeEdOQUpveVcvOTNqYUJSOEln?=
 =?utf-8?B?RGM5bHFuZ3BaY3dMaENBNDlQaHFXR1NTSVBtRno3LzBzY3piaUJuQTg4NXdD?=
 =?utf-8?B?MElrUTA0QTBzN0NyWmYzaVptVjdTcXJBRUkwYXovdGJNMjEvOWFrWFRFejFI?=
 =?utf-8?B?a0dOblRNTmFuTmJyNnhhTzZvM3dPSVRrbmFwL2o3b29hVTJGQU4rVEtkYlR1?=
 =?utf-8?B?TkRWZkphU2hnNGJkTXhBd3pUTzNPVmFicEFlSDVSMVNhd2NPWjJ3OWxLNXI5?=
 =?utf-8?B?UkNyelpudEFuaUxtRk90LzYrbTl3UmVOT3ZBS3lIQlFJRXBZTUR5Yjh2T3Fw?=
 =?utf-8?B?NUtKZzMwZFcxeG8xbnBnb0pmTnczUjFJQ3dSNHluTlN3d1BlaHpaYmUvdWFt?=
 =?utf-8?B?Njdtc2FraDBlSEVTV1pkLzEyNUlyajI1SlltQlNWSW9WSm02SkN5K2RCWnpH?=
 =?utf-8?B?RzJsWlo0eGpSOEtwZFhpUmY5bTVKU3BKdjdwemFiOUxRMlAwdFJVQmNwN3Vh?=
 =?utf-8?B?ZzlsYU82SkltR0xSYkJ6TDRsRFVZaWY3VmJsL2d3ZWI5c1pSTXAvM3JwMkJL?=
 =?utf-8?B?V2NpZWE1SlNZMkxjSXZzeERoZ0YxeUI0OVpvWWVJbDFmaGVYRFpvSmpNLzln?=
 =?utf-8?B?ZmI1bTRoTW4vU2lzUjhOc2JKdXlrYjQwczRwWXBjcXJ4b09udEl6azU1cVBl?=
 =?utf-8?B?UDE2eG1QWWVIVzhkekYyKzlBNlFUYXIzK3BJOXd2UzRTQWNZVmtzdmh3THdn?=
 =?utf-8?B?UkJyb3hyb0Z4TjRqdXljRG52dWtkb1VrZ2pZK2pDemsvNTlyZWlUU3IwVEtK?=
 =?utf-8?B?MitHL1JQaGJFSm54Z3FYM2pRNjZydGlNNmN1bFNCWHpmckMvS1Q5QnlORmNi?=
 =?utf-8?B?Rk5IRUpRRUozajNVQ0NUa1N3SWx2eGgyeS8wK2pnSEtPbWpWS29DT2plb09Q?=
 =?utf-8?B?NWJHK3JWd0tPK3NhbFdTQkl1UmxqQkpudm9YKzJiVVEySjErZUFsc3QrcjhI?=
 =?utf-8?B?cjZWbG4rSENPa2JBdG53RFROMG53K3M1b21vSUVKR3QwZVBHamxJcHREY0N6?=
 =?utf-8?B?V2ZGeVVrcnV2bFZBVzA1ajg1V1BJaW1WMnlocWdMZU5keG9jLzE5SXF6V0Fy?=
 =?utf-8?B?aU1GY3BZMWpBV3J5Y1FXNC9OcjFSNWgwU2FwQzk4d3VkdlUxQldlV0lzZVBE?=
 =?utf-8?B?d2oyNWtoT2s0RjlwRHBSVGxoVzZ5TGVqVHREOG5ZVlN6dWt5cWRzVTEyN0tl?=
 =?utf-8?B?b3dPaHE3b1JWdDVrcUtaYzBFM2xETkdMMFJWYzN2MXg0SHMyOGIvQWRXQWJK?=
 =?utf-8?B?Q0VTMFBpMEVyTEcrd01xdXJkVVVMMldPdmprOUQxbjRXdExzVWZldStUUXE4?=
 =?utf-8?B?TWlSZ29tVGlqQlhhcGs3RHJYS0dzTnJKdnlCd0xtb051bmlCNFV2WS9RTjZi?=
 =?utf-8?B?WjZzMVgydUtwMmREdTVkMnI4eVZhNGRYb2lsNW5jMFJ5TkgwZUZBZDE5bStY?=
 =?utf-8?B?OC9LMTlPQWNPclZWUXl3MWJoMitoelRlaUZPY0FEdmxOK1JnSmZxbFlPckJh?=
 =?utf-8?B?TWZHQ0t2c0h3WTdrMnVrYmpndGZhVy9acDQvQUhQNlpDR1ZxNFB2VFFZKzJj?=
 =?utf-8?B?QkVMeDhXVmUrc3BpMlBTbjgzOThNNWs3bjJBa1lGeURBN0Z0cnowMFBXckFi?=
 =?utf-8?B?L3I5emRORU1WOXc3M3V6NGhYYlpVYTEyT2VEdHZxK1haUXZXK2RQdThLQjd4?=
 =?utf-8?B?WnNXR1E2UlFYTndGMkRyN1k5bUJBVW1MdTNQbXQxcjRkOFFZKy9YWkdnSkZO?=
 =?utf-8?B?YThOZmJybHlwWnQwNnF1V2E5SlBvS2xYbnpJck5PSWFTZCtlZmVUVkp4Yzk3?=
 =?utf-8?B?cTZLYXNSa0oxUFhXL1paUXBuWVhSNW5BYTRGRW4ybEdqaUZrSmd0YnMveVlU?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a1ac48-27ea-46cb-f3a4-08ddefe591fa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 21:12:23.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9BZPAqIaPDDVN8FGDgofv14nKxuhmaVSd0Xi2voTmFlwBAIIAjmP6KXsB8QNgZrSyr6rqvWxsE40UsQJNFHunekmQPKunwYr9FtisToraw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8985
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> The rdt_domain_hdr structure is used in both control and monitor
> domain structures to provide common methods for operations such as
> adding a CPU to a domain, removing a CPU from a domain, accessing
> the mask of all CPUs in a domain.
> 
> rdt_domain_hdr::type provides a simple check whether a domain is a
> control or monitor domain so that programming errors operating
> on domains will be quickly caught. This is insufficient to
> catch errors when other resources besides L3 support monitor
> events.
> 
> Add rdt_domain_hdr::rid to contain the resource id and initialize it
> as part of domain structure allocation done by CPU online handler. Call
> domain_header_is_valid() to sanity check both the type and resource id
> before using container_of() to get a pointer to the associated domain.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
