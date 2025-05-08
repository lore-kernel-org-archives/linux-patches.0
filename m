Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E649F1BD01D
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675383; cv=fail; b=f4B+kZvR4kuUoJ4WQH5SPInZVd6MeilYfjBCRI/C89SxkZr9wtKzp3L4FdbRksbD06I6nMY0gKEd6ZhuaGSxFaKdYiY0ebHWmOnVKBWGJG1MvM9qsbC6PyDOvs+8EFDsXrSokxl/2cHftPGzlRVuVZ3HSa1V/O+m8FhMXAOKSy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675383; c=relaxed/simple;
	bh=JgvWJ3kRO8oIynerzktf4WK3ijGoeW8sXgrkqd5wbvI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NU1LFnIoLhrDc7u+GmOvgwvKpSsL7XWR+8C3qqEBE+OjJtC+OBYELOdEUpVAxy6ZHPP9Dn5P81GIVaTivq9SbMbkGxwb9551bYt5/weXyZVlGeFeJDleOhqekFHxUn2L1Jc5sUKjAzOOmZNkVJOgyGcYvWH837V0VB2Ap3b/oWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DZEGhBUB; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DZEGhBUB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675383; x=1778211383;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JgvWJ3kRO8oIynerzktf4WK3ijGoeW8sXgrkqd5wbvI=;
  b=DZEGhBUBAFXfG5ZKvjJ1Mjt4yq8XlmGyPB6v8cxzzS+lnd6tKj8x7Z0N
   zSbrsbG8jgCLa0wh1PuNPpZyzL4kkHwK8DhqO+wj9b6jt4fK7Llr8tVyJ
   z20q5XpX5jP5XuRRd9eHevrVGdsS/QQ0kAj2QH3KJMElqhlK2lgypfGwN
   zWRnqsYs8v3HudSD2ntE03u1ypzz/RItusH473aWlyipbPnN3yvcArWp6
   ivAVMnoUVFO/OBaU0ZP+ZIQ0Ao0s7Lvf8z6mVy+vXqLwuBYDPQB4naMDy
   rZWVTR/B0Y6/DWmR9uRW3qGwEUbFG+iOwzgQSKxl/VA7blEsJ/KJOg5ix
   w==;
X-CSE-ConnectionGUID: ojbwQ7R2SvGsRWmyZ05GmQ==
X-CSE-MsgGUID: cDzab7QCTwe6CZdcktb1Zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58638018"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58638018"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:36:22 -0700
X-CSE-ConnectionGUID: qc05FXHOQJ+Z+U4usKSOrw==
X-CSE-MsgGUID: U0NEf6P3QOKu+xsoH6HHMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136116689"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:36:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:36:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:36:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:36:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMXXfws9i1A219UuBJMgJx+sqzwEFYQG9aqCdSJ48qKZMIiTUfFracNqwMm+vc+f0c17/Gy1LuHbCTivj1pKU1LKEAlXKqw65N5bqfwIJTiWrLEI50X881W07M9meaC39wVlV79arQ9rWQCnVs1OvIySImIYzYUJDtEi4A/9Ceo9gt0KXvnJ2n0CuCDD+Zp9U60qgNj3axTbTDuUt3ESIiDki6t2LQYSvtO0CwPzBS8hBLJbzvZmKqafJ0T/MMipEr2OB8wBTG4A2fJ4B4PNtlsvZgZlbvR434wPeXMYCYL/Pnsz0ijy9K0pRpYWCkcld+aH376yp9a6Mkt9riVIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFjP3BEz0FE20mV2fu5dpjcDdeHRHcgwJUq3LqK9mdM=;
 b=XMMMJEdwytga5wRGJk387hYamMHXiHGwbHPCQJj5PF9JZsfXcBRMhG5J5Loo1Q7ta1vlzzWiAO1b1UZdyrKf8SfZuqAaX9CaRCRKku/VNnb2WCj4y9KcWvXn10YNGcu/Te3qOUZOrtlpsmxdSZlMUlhBAqgDR0ZG28IHn3B/dOlkKwYs8d+GcTrph6bd+KNsN4oa2IOXWHafXGqJUdhcXwd3lacs5pziuJkuTvlbRBUsYOpcGt0zg4rqrh0EkXrNjAy6iG9npC04pUIhhbTELI5kpYouAL18bR92m7IUU2cM5r3fKO2EzUTLPM71Xa6pdo+gcbp+Tb0zvi6QX1127g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8513.namprd11.prod.outlook.com (2603:10b6:a03:56e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:36:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:36:13 +0000
Message-ID: <b113075a-0efb-4a14-b201-54cd2f04a0cf@intel.com>
Date: Wed, 7 May 2025 20:36:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/31] x86,fs/resctrl: Improve domain type checking
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:a03:60::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: 741e6b12-bbba-47e6-820e-08dd8de17b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFlONUJ1SHUvelYwL1c0bmQ2NDEzS3J5b1JZVHNDQ1htUzF3TTVsUGlmOTZF?=
 =?utf-8?B?NUpzWFRySmI1c3cySEV6aStRekUxeGs4Vk8rTEpmUlg0OVlOajdyNm42V1V0?=
 =?utf-8?B?d1RTVGJZT212eno5bDVVenBySm1wR0JTZ3FEZi8wajAvZVA4a3lodzNwTUJU?=
 =?utf-8?B?Sk0zTDJTdHAvSnVoVWNLOFpkMS9KV3hHNFVtZlN6clg5c2Rtb3JxTkt1b0Fy?=
 =?utf-8?B?YUd2NDVUaUdub3NrTndWZnU4dWpnQWh0bzl0bHlsNm01OE9td1dudjJHRWNX?=
 =?utf-8?B?bUw4cUdxcFY0dHZZTWlJL1d6d0c0b0g4eE5zYjdYZkpBd3FNS0JabFdnV21t?=
 =?utf-8?B?VFlWZjV3aGc0TlpGSXpsVGdlWTRTd1hDdTRnSnlmdTgyYjYwTVRoUUIycWp5?=
 =?utf-8?B?bVdsRFY1MG1uTXFucnc2V3FWYkhqUkM4Q1loZUVQd0tPZmFUSHJ5eWhGYklj?=
 =?utf-8?B?eWtsMDJIRlpmN29nR0NkWW1mMkovaTdQUHRlVFY2RktsZ2RFM0duYlNJWWl6?=
 =?utf-8?B?c1JQQmp6ak8yTUYrNHBBNVhYQkhTaDgzVk1JS2tEcmhhNTV4ditBenJsdXcr?=
 =?utf-8?B?RldTT2pFNDVPU2pEcVpFL29sSWRWVmczY3BSdXl6a2dEYnVCb2h5NXJ3RGpi?=
 =?utf-8?B?RVQ2Tk5XQmZUZ0h6TWtzL2ZrbkFsTGd0Zmxwd2twN2cvNzhJTytlclh2MGtN?=
 =?utf-8?B?YzByd3ZoemhYTjNMVHIvN2tvMkNqMXA3SzNneGEySGVLdTNhLzRGaUxkUjYy?=
 =?utf-8?B?czl2a1JJS1BRdzhDUWtmdUFRZ1RieENmbkEzY3ZpLysyUTJCSUdPNHMvK09i?=
 =?utf-8?B?RktGbTNNRkxaZTAwakR3anRtaFM1WCtINy8vSVpRaTZwVHl6M3EvdTV4aFZT?=
 =?utf-8?B?dW1KbUNOZGdjckltQ3Vkcm9GZ210dWc3UTZkK0I0WUpIZTkrZjVQWDBicm9S?=
 =?utf-8?B?SUhnaXdvVktYdytvUG82c3dIdzZtdXR6eUtJMlYzS2ZENGIrblpEVXlJUnJB?=
 =?utf-8?B?RWZjT3RJSysrWm5Ma2tWRDFZanNpamJFWWQzQ0h0Ym5raCs1Nk5pMS9Icnhz?=
 =?utf-8?B?a1FrbkJ0TWJNdG1BM01RbHgrZnZjVzFFYnh0RjA2V25OUEh3Z29yZ1k2WkUr?=
 =?utf-8?B?OWNwa3gxSEw0Z1FnWmhaWUxXOWFBcjhYZytvRlJSTlVtK2NtQ0U5NW5GQzRP?=
 =?utf-8?B?YUFDUlI5T05BQlQxWkJsMFV5L1ludE9RZk5zOU9KVkRpa1VYZzhBOVVGTy84?=
 =?utf-8?B?NklvWkFzREUwcHl5dFovaU9wSVBlYWtSQ2Z4a1UrK2k1MnN3RDl2TEF0NHRn?=
 =?utf-8?B?cHNkb3NqM1dxVFdWQ3RhUzZtMmhuRWx2ZjJ1eTN5d1pBNFd5Z1lKQ3BESld3?=
 =?utf-8?B?RDJqWk5KanRtb0dabmNqNktCYTVBN2hVYWlYRVJzTEdPUTV4TEZ0ZVdVcXBs?=
 =?utf-8?B?YXNXK0JPOFlCY1RRTWFmaEtyODVPMnFUMVAzcTdweFpTS1dHR0dkZEFTN09V?=
 =?utf-8?B?cUVpejB0RFFIZzFKbnExTWxtM2VnZy95ZlVuZjFQc21aUnlqSUt5RnJLNGZG?=
 =?utf-8?B?T0lrdDRKeFRIV1ZpQXdRWUZoTFJ1NXhqSGFYemxXWnFVYjBNenVaMmhqY2FP?=
 =?utf-8?B?UXlFNmUzZHQrVVljMFQ4MTl1RFBnZUdaaE5KTm9Hall6SG94UGNsUXVWTmxF?=
 =?utf-8?B?SDJiTE4wR3VQOUl5bTUvbkVZOHVMQXNVZDJZM2hJc1pMQk40TjdycG9TWWlJ?=
 =?utf-8?B?SklaUHFzTVl3U0N2RVpMYW13ZU1PYUVFVkd1VUp1WXovZjM1R3lXRXFBZWxq?=
 =?utf-8?B?b0lERGtyVDVBZlp5UTVGRi9wajlLWGJrM2FWT042TG1uSGFvV2NtZ1c5Qi9T?=
 =?utf-8?B?TWN1clRrTTUrNUlWU2JtV0dJT29NRzkxUjZQRXNnK0JCaFJwR1NlR3RCSGx6?=
 =?utf-8?B?OTNQTjgrUFo1Q3lvSzhEVEhFNWRlbU0rK2F2bitXUUNYRnlPejFFRGIxMStM?=
 =?utf-8?B?c3hRa1R2NzdRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1ZyNjFlSkJnSWgwWGlCMzg4TVFFM1JhcUVlYkNXSUdFOFFXdUQ4Y1dVaGhT?=
 =?utf-8?B?YzV3ZW9haURFajFHbTlTZkJyendPa1ZCZ3pYR0Nya1dNakJjUm8yekVmblo5?=
 =?utf-8?B?b05vWVBUWFNoaU1QUWc0bi9OZkEyZ3VTWTVWR1Z0SUhYYi9LQm9kRnV3RWxx?=
 =?utf-8?B?blZkQTlFM2FuSEdweGtQTy9OOTBOSkVKVk5aelVwaGZTNDFSMFAxWUVDRGhJ?=
 =?utf-8?B?cTBHSERKcUN1NXBoMDBCQUp0enNncE5VZDMySTNneSttS0tFOU4zbzVjSm5Y?=
 =?utf-8?B?dmxMaDA4L1lNeDU5VU8waDUwR1V2Z0xQWkJvUHZLM0FJenk2ZmZSR2VqMklm?=
 =?utf-8?B?R3ArYk02aGZiRko5NFhVRU1lL1JIUm1ZVHc1S3J4YW9JdDRQN2l4b3UveGk2?=
 =?utf-8?B?KzRuWVVIV2tRK0NaWHBQeFhpUElSWTIzQzZxSTM1N3BTdWhMWUJodWg0bFVD?=
 =?utf-8?B?NnRDUmFiT0g4LzNqd0FxODlFbTA0UThYQis4QVl1WmdBUTFoM0poakdTdXUx?=
 =?utf-8?B?OC9LUWFSTmp1WkZlVmNPY1VKWmlDU3Z2N3dBVEZzcEc3QXM3cHNtVy8wUXNq?=
 =?utf-8?B?dTBtdmNlNFhXd05RNm9xOVV2UDNWcDgrZ1loVG1qbkJOWWtQejlRWHJlY0lk?=
 =?utf-8?B?WVNybm5lNzk1MEhDNytXYkpZZTNQbUVaSzcwQm5TeDk1OVo5b0FEZlBYNTRB?=
 =?utf-8?B?eVp0U1ZiYlVUN1BIK1QxY0ovZVZ2NzZDQ0NKRWt5Y3RobnJBS3NtdmQzSktt?=
 =?utf-8?B?cEQ1YjJTd1hXTVVSMFVndjQwc0JBb2xXS2J4RXVnb25IOTlieTFpMlh1ZGl1?=
 =?utf-8?B?THFMY0d1QTd1cVprSUwrNTIwb2VjNHRybHlTc0dMeEJRQUdXU016ZEorUXo2?=
 =?utf-8?B?a2hkUzd6Z3pZeVNwejVSdk45b2FKV241VkM4aC9VVWFWaHBxTzFIY0lWNjBC?=
 =?utf-8?B?ZndkSWZKeE1uRXphaEhiOEM4RHdIY2FzeWFkZEs3ZEFUYjJSVzFUTzNKMEJl?=
 =?utf-8?B?WEpnVFJySXVlVzJyZTF3WVE0bCthZ0RrOG05RWVrSWVFeXUwaEthb0Zza3BC?=
 =?utf-8?B?ay8wUFJmM3JoT0t2K3FSbGh5UFYva0JwcEFpdVRhaXNwakVKZWVKZitxZ1Jv?=
 =?utf-8?B?L2s5RHZpRkdaV3NoWW1mWERjeklHcEJMUnlncWpYUElMVHpHZmZad1FrSzdW?=
 =?utf-8?B?ZTZNekpTWFRhUXoxMUJVdEhLcUpLVi91YUxWREhJSWh4aDE5Vmh1aW1NZ1Jw?=
 =?utf-8?B?dUdPTFJheG52cDR3YURMYlhCczduNjFEYmwrWCtOaUtEbGdnQ2MwNUZkOU9D?=
 =?utf-8?B?ZkdXYW9OQ0U4Q3psdUt0eitjSFVKRS84QWJpOWhyQ3I5NVI0cnNFOGs0Yi8v?=
 =?utf-8?B?Q0YwV0YvTVRyOG51dE5kdEllNXp0aHltTi9aazJ3MmQzKzlSOHIwVmUrNUlW?=
 =?utf-8?B?c1BoTi9MUW1vU2RpVExkRXdyeEZqcTM3Zlo0ZFduN0k4UE1qNG1VVlVHR3VS?=
 =?utf-8?B?R292VFFRbkhHcW9FZ3NQaGpmclZYZ3dhWWFhVkR1ck10Nm1Id1grcFdJSTFj?=
 =?utf-8?B?dEpCTnJkbzdhVXIwZkRDZFJZWDR3UzdFV3F0YkhRZ1M2b0hCTGZER0xqT1BW?=
 =?utf-8?B?MUhVZ2luZ3lEaHlEendCWFpWeUcycWxUM2xWYWhXaDdmMmpNTVdLOUpod2p1?=
 =?utf-8?B?eUxVR1U5eEdVeVJYYzNDQ1lvaFhCelhIVEMzS0VUYTBONW5KVEdIRzI1c2Nk?=
 =?utf-8?B?Q1NRTjRlVnNkb01MVk82VThzR1RRUFIxcXN6Q2J4Q3ZVTEpLNFYxRVJhMHhK?=
 =?utf-8?B?Qks0ays0Q2FLdy8yYjNXS3VueEEzZERUb2pIOHoyelBtK0Nlb3RVRk42dmJl?=
 =?utf-8?B?bWxpcmoranNaMGY1UXFRTVo2VVNKNzQzclJMUjBIclZPVnFEcDhTTWRlR0Rp?=
 =?utf-8?B?VzQ2VG1IQnJKdnN4TzdYcHJPbW0rTVF4bjJybFZBK3ZHZVNZN2dCRmtEUHd3?=
 =?utf-8?B?dWtIUi9CU2lzZVI3Y0xkaUJsc1ZHZmNkQ2JvNWcyNkFiem5tMGM3d2tFUzUx?=
 =?utf-8?B?eStzUVdJZFpNSGdPOFlYTzRZYUxEOHc4UitwdUQ0R1B1M1daZ0ZhSlk3NXRY?=
 =?utf-8?B?VENYZFpUYlQ5NU5Dclp6QzFYZ2FGVDVTcElSMHhXeWhRTkpNQzNaLzhHZzUy?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 741e6b12-bbba-47e6-820e-08dd8de17b72
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:36:13.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgHb+A6ElgtKQNCbqtSYcM2KXM1up6QcPTBDKmV647pU5oSiUEijHLTvB5l1+V+MXfu/1Xr5q0dDhiUiUcx4TBwx87DtZy66bMn2OJAAydA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8513
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
>  
> +static inline bool check_domain_header(struct rdt_domain_hdr *hdr,
> +				       enum resctrl_domain_type type,
> +				       enum resctrl_res_level rid)
> +{
> +	return !!WARN_ON_ONCE(hdr->type != type || hdr->rid != rid);
> +}
> +

Please name the function to make the resulting code easier to read.  With
a name like "check_domain_header()" it is not obvious what a return of "true"
or "false" means. In this implementation "true" means that the header is
*invalid* so a "pass" of this check means that the header is invalid? This
sounds very confusing to me.

Names like "domain_header_valid()", or "domain_header_is_valid()" makes
the resulting code much easier to understand. Please do make it a goal
to make this work easy to understand, this series is complex.

Reinette

