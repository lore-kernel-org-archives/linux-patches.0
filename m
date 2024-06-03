Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB23135A46
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717438051; cv=fail; b=IEtTIh2H91YG6Xyzj6Rsabq916HeQ6Dpvmh5DyORDunb0s6u3rJi40UMcB+nUu4cyoM7vmN3Pq43nD6kDERQ+g0QKMc+8EYm7CMAuPGcO7YcXQ7tMdViVrrVk+puzvj4suK/bFZZqvUVo2G08HejzBhi0S+KKaJ1tc6aHlZ/aVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717438051; c=relaxed/simple;
	bh=RPRO6rpjbQFLzfa8gjPWtMbjPCoBelxmdABjGzVNYa4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eKjpEMprqHs3os9eEbt6Yk6VuK20Rvg6ZfpWdiSR1y0P4DMIw7LmFiH2OXxg2E267M8aCfWgc4WBl+0O0Tn0rRFaxs8v2CyXM7/oxwQ8VsRggWZKytpI8Mi4QoQZR1d97VlF5y2TmGphW7LQQyF8aZBLbu5r8bj/C+t5Q303V3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7rBbb2u; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7rBbb2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717438050; x=1748974050;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RPRO6rpjbQFLzfa8gjPWtMbjPCoBelxmdABjGzVNYa4=;
  b=P7rBbb2uMpcjjch/LfubdN4eh5i95IDxNC1D6O+952N51Vg4PWBoTjBw
   7n3DBgpCoHjKBgIa2Qy/0bNYrfroWCf5o21GvE8p6vKx3tVafAF6tIMft
   qUKVdjvss5qhjoWBuQSWs/3VLJ6BqkbWuLMxXNdUvIGiMOoTOBCSTfQL/
   rOSX+8d7A/XZ38rez5AP35hmXc5Cwx3TC9+QnzFlZjBx/+3bq3Yw/Msqb
   sis51N5NFQgugM9WrGw8kUzgmTCeFLmvhipdfjYYf/trTyCfcD65MOcQd
   905drknX9sSTvN6Yv9CITc70XV7ZtpM4us9vvv8SjoFzEGqEgfWbmWVcc
   Q==;
X-CSE-ConnectionGUID: H8PwobdYQXaX2pAh/WCiMQ==
X-CSE-MsgGUID: GqqZ9pQNSjaivNidBreFWg==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="25345967"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="25345967"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 11:07:30 -0700
X-CSE-ConnectionGUID: lGmibTDpTDSPWgWvZrsZaw==
X-CSE-MsgGUID: BMw1Nz7SQc+R9u9CG3VzKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="42036202"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 11:07:29 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 11:07:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 11:07:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 11:07:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaEmID9RsiZBCC5Hzs2q1zs7YmmA0cyOOD1muMqfz6dQod9Pthb6i/CQVy3hBnJeXQLXY2g7FxwvORSHV0UjAf7cwdMs9Y9YlTOrO+Lu7Teb5sEeOVoQNaDLEHloEzsSgwYeqfHmBdZ6OPq09dZF327d5u5C8FuGfrJLXV9mkov5Nn6B9LsvM1lbTCW+3XDBUZ9xk2b4miEqbe9ZxAKJJTey9fx3IXJFK64hQShNfv7F6KGD3UIsOpZgvBXgmm3ZBRRNdHagU2VRitAgaYqS3oUpbYHJexKRr4xJytyIesqXWvIjkAmnCDB4F4ikl3yZUbjOHpGVYxR7wHv85n1w7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDjJFUdRpcEA+RO/Ahh4V+9MTy3bwo6YwXOU+wSvKow=;
 b=QzIyFefmxOgQBbdRgngH/D0Vio3Yf/4TVsgYgnpeb3KXYQQ/Uob6TmfT0CYpsa7VUa38rYLrm8BxvoNwHRCELhPGX1cFhQaNph+HIvr988UASttWh12VDVUHicBvBtLwbXnP7gyPYmXeerDSwwrLZTBp9afWMP87RS3UWXGe1TuHpObEFBhrQiPJFuj56EP08vVXUFPhiLqPavJNN9Q365R1VE4ys4hPk8cGGi1A3lk6BTXv8YTBEZX4yG0Rm+WrjcnzSgoN+u5RuR16izzQrcv7HMvAbJTkB7fcvjEwOkymBkcxMckS/2tMS+CkIgx0mX5WHZ8xOFNyCoo5Md5TVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7383.namprd11.prod.outlook.com (2603:10b6:8:133::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 18:07:21 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Mon, 3 Jun 2024
 18:07:21 +0000
Message-ID: <c11a323e-1703-4fc3-b05c-c12f6fbec63f@intel.com>
Date: Mon, 3 Jun 2024 11:07:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] x86/resctrl: Replace open code cacheinfo search in
 rdtgroup_cbm_to_size()
To: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <20240531195720.232561-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240531195720.232561-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0379.namprd04.prod.outlook.com
 (2603:10b6:303:81::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: eb59d518-0f8d-44ce-eb87-08dc83f80360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OFVqbjl3TTBzTHgzRS9EUE9YUGZGTmtLbEFhTFVEMk1aS21jdWtoaUxHOFVS?=
 =?utf-8?B?elFMSlRDMmthMGw1TGluQlRVR0xMbm1XbTJ1WkxWMGRibVZTN0Z6UGg4a1J1?=
 =?utf-8?B?K0dGMWowKyt5d1JkOVVPbm1kZHhoR1JmbTU4S0svMVN2dFgxVlFFUXBmUUFN?=
 =?utf-8?B?ZEp6NGhLR2hkOEVTU0lXeDZGanI5aVVQYmRSSk5PN0p6ai9Gb0kraGF2Z1Bk?=
 =?utf-8?B?b2l3VUszOWhZc2RkaWZVdmlkR2svYXRXWGRKTUFWdTFoMzBpNkZISGVwMThO?=
 =?utf-8?B?NHhMSXZuOEg5NmtBNzBTd0dxVXNCcytJUmRwSXBKY2Q1bmNzdVBDY0dPVkJl?=
 =?utf-8?B?RXBwYklyQ253dzl1aTVzTTgrWkZmR3ptUFZKR1V2d2ZzSU55V1BZL3lVTGZL?=
 =?utf-8?B?SjRaZnkrcVVwbXhPT0JUbkF5dWNuREZUMmRqdGdYQlB1R3c0Z1VnRmpLRUh3?=
 =?utf-8?B?ZDlNOFZMZG1zZ3BQbnc5eTJkSGtqbDlSNjlaSWhUUmthRktlUjJXdVV6UTFW?=
 =?utf-8?B?VnBTdS9NWFhxRjdram54eXBPVDRDUmxnL0g0elJBKzJuMXEvMTZ2Sm1OSFNP?=
 =?utf-8?B?VzEwWHBmbTkrelQ4ZDdWaFdJVWJoWExINDVzTzZhakpSSHFFSTFYNnltbjNp?=
 =?utf-8?B?ZFJHVEpHUm1GbVBvN2R0SGFEcHRkVXpoamtQWkRMV21NV2dTWXF0TVY2MDRX?=
 =?utf-8?B?N25kVFJaaDZiMG42SUFQdTFZN3VvTWU4WWZBTHlqK2Q2ZmlLVDBvV3VIS3JR?=
 =?utf-8?B?WGR3OXpMQzdJeGdBdjNmTzdwUHJZai9RV0k0RjFMS25oUDZkTWo2NTJRV2g3?=
 =?utf-8?B?dmlHOHBacm40K3F2ZFp3N0w0NXdKUmRZV1BEL2tSd1ZLZ1VVZzJzWHl3VGhq?=
 =?utf-8?B?dE9aU1NJN0lURzU1b3Vhak1MRVVrV1NndDcxcTB0TUFxN0NkYk5aZnlFbDQ0?=
 =?utf-8?B?ZVRjK1V2UURqMFBYQTlESUtKbEJMeENnQmZKZUVLUHRMejFoWDZ3c2FaYTF0?=
 =?utf-8?B?eVNOWFdhRFI1OGJHWDZPTVNIREZ6Rlk4YlpCUTV1TExuc3JIa1dWSTRBazMz?=
 =?utf-8?B?VEs3UjB2Yi9EZnoraWswaUVid25DQ0RxempWdWFwL2hzeWd1cElqZnBnV1J3?=
 =?utf-8?B?VE9RZUZMWWVoNjhLZFJVOEl5RWdsZ1ZNVGxlbk9Qemo2ODNaQUpaYXN2ZHhR?=
 =?utf-8?B?V0JPWkRXVllrSUNkWE5LS01zbDdhOWdDK3FUY2prT3JjYTFOK1gxMmpQQ3Z1?=
 =?utf-8?B?OVlZYmVLM1ZjZWplUzdSZHplZWpZZWgxWXZxaHhqdWkyVnB2TDI0WVprTits?=
 =?utf-8?B?dmtkbUNFMXZwa0ovMysvVUplTHF6ZUs0ekY5SG1LYlY1NmxHTWNsQkdueXJ5?=
 =?utf-8?B?dmo0Y1lkc0F4YmlvTmJqV05veGJVbzV6SlBDQ3pnMmZFVnN3dnVnK3R5MTVD?=
 =?utf-8?B?UllLc0tLOStLRWt5MzlWUE9VWnhrMzJxcUNqR3RTZnFWS2Q0RTJOYlVmVFpH?=
 =?utf-8?B?Y2ROVHpud2JmZmZCZzE5TndjUUZSaVllNDlIZnhhK21XVS93K1dqWnNpT3JT?=
 =?utf-8?B?cWdteXZjTVVzSzdYZndnUlJFQzRoMnlYVnhmdVpRcTF2WUR6aFNjV3o3cXUz?=
 =?utf-8?B?MkNuc285NXFHcW9Oa3Nzd3BRbmlXK1lHbVJJUnJPcXV0Y2tyMS9yR3Ivc3F4?=
 =?utf-8?B?ckJqbUx1K2haWGJ3cjdlNm45d08vS2M5dStBWm9nMXdxRDc3ZDVIcEN3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjRXc0hQVk1Nd0pUbGJOMzBiZytKbjRldzBVc0R0QkF6ZkJSZitiNTJESXBV?=
 =?utf-8?B?dUlReWM1WVBJUGxDMm8yZFdyRW9VQWloaE4yWFNsVm5EY3Z4YXBWVG1DRmFI?=
 =?utf-8?B?QjZjdlNRTm54WXZFbFFvMjZpQUlzMFJ3N2dFK0IvQmprSEkyNmVsSHZuK2Qy?=
 =?utf-8?B?Sm11T2dpaUQ0SjE3L0x0T0tlOHVQQVBBUVp1eG1WMytSQnpqNjlWa1d5TXov?=
 =?utf-8?B?a3RGbjZmZU1wTzUwempSOHV5dUt4WkRldXJZMy9pM2FVakNQU21nenBGcUM5?=
 =?utf-8?B?M0NzZWJOWW1xUnQxdlJCNDZTRzJKUXZ0UGUyNW5hd0VjNjhHM0Qza0I5NkJ2?=
 =?utf-8?B?bnYrd1JpZDJydERqM0JubUdaL1ZtUDlabzhzQUFhMk1BaDB5bjNtK2hoVUdO?=
 =?utf-8?B?WDBuelYyVmxLdmRURCtzaFZKKytYZUJQT2lGbVlEeXZ5dEszOUR4dGNxWU5H?=
 =?utf-8?B?T3cxTE5PSUNVcjJyTGd1SXdHRGxLZnFEWXFqQTJvcWVYdnZDdnlONFo3ZC8v?=
 =?utf-8?B?OEplM0xTTVRWNzJwK2Y1QXFPVzVkcFJ2UkdHV2ZxUFRTWVo4RVVpV1BydlE5?=
 =?utf-8?B?c0pvUFFDbzY5YmNyREVUYkYvTDA4aXIrOVhMTjZOZnV6R3BBSXlITEtUL1VB?=
 =?utf-8?B?QnBCSlRPYWFNQnhCMUVMVi9IYm55cXQ0M1RoZ1RpOUI5ZDhPSTFhZlNqMy9J?=
 =?utf-8?B?U05RWDRuOWdaQVRaY2NhU3RUREVNRDhvQVBiemRRMW5KSUpWYk9sWnhTd1Vh?=
 =?utf-8?B?RDdkY1ZlcXdnWjQ0ZHBUZkk0Q3dSM1JvdldZQkk4RW9XNHdmaFlxeUU2dXlv?=
 =?utf-8?B?WlZ6SjVWOHQ5bUhkWk80MDZTLytWUitRUDZXSzRhWEpMYzE0aGNFRjd1aWZi?=
 =?utf-8?B?WlMyWjF0MUhoQ0NYK1hzZmR5SVcvOXlLcnpzZVBUZzVVVy9XNG5TN056dytz?=
 =?utf-8?B?cFR4TFp1QWtEVkRmTUdYcGRQdDRaRUt4dXE2aFhwdGtubkpPVmNJbXZta3NV?=
 =?utf-8?B?SExoOHVBTk96bVVML01mTXlBdHdBbEMxQUtleGU2Nmx6ZGhSOHh3UFlVWUI4?=
 =?utf-8?B?SnN6MkxlN0p6bDZYZUdZK3Y4T2FIVG83eldWUkRqMGtab3hCSmJqVFFVc2Rn?=
 =?utf-8?B?dGdjSDFucFNETm4zV0VBM2RZeXU4SFlJRzZjM1FDRnQ4UVZPbTZhbG9BWEl0?=
 =?utf-8?B?TWh1N0Jkc3pHTFlPMy9WODBCTk1LSDJnYWhQZnl4OE43UUlQSzUzUFBGTkNN?=
 =?utf-8?B?aXRZMnVWNUhneWNYQzE1VUs2VlFWTERjZ1VaY3RuZjVPbnJMd3M2RGwvbkxu?=
 =?utf-8?B?MFhheWhkY1RTb0c1MkZKTUFaODl0cXNHSFU2MEFzMWI0Y1BVbkNUcndXL1Qz?=
 =?utf-8?B?bGJjWnZQMG85SmZWWmVPem0xL28zM2wvVHBxeVFSdDBjOE5RTHR3dWpiVGhQ?=
 =?utf-8?B?cmtvMm9seVpFSklWbUpSVlJsWGYzZitHdUVaR1NuQ0lFQ2FnUk51Y3ZkZjRq?=
 =?utf-8?B?QlNTOXdlZGF3UkhxNVRZTnZoeXJpdTV5V0tNd2Q1WkpUM2hRbFNQTlVLN0dz?=
 =?utf-8?B?Nm1hTmRtWTdVL1pJaFVkd1BPOVYzcVNBM1dSL1d3eTFvb2R4ZmUvOWFMVjlM?=
 =?utf-8?B?Tm1qRlVIc00xVkpyNjhTSi9SamtXSkROc1NWeTFLUUV5Tlgwc2REVjdOMDVF?=
 =?utf-8?B?dVhIbG5lZG1hQmJpYkVKL2drUHZZNnFoNnVSSUxIaE9Ya3NEU3IwbjN4V1Yz?=
 =?utf-8?B?SE9HZUZPK1R6VXNYWUNNa1dGdGNCdjkwc202azU2dFhiUGJKWFBEc0JJQkp6?=
 =?utf-8?B?SEZDOXEvSmQvcDJON3UyY3g1ckRFb2xaa01jYjFMYTFYYXBkaWI2NlAwQk9T?=
 =?utf-8?B?QWx3LzBGbTdnamVqWXBPalQwUCtQbnQvcmFxbnAwUWtqb1BySHpVcUo5NEEr?=
 =?utf-8?B?OG1xaTVYdjFiSDJMQkRoVkZtSkxxQzVJYmRoZk9KZ21lZHkwU0VvemtnM3Ni?=
 =?utf-8?B?b1llY2YwRk1qQ1V4TklXRk5nR2I1N3JKSVVSQUphaHpVTzNVOVhHbk1BOWNC?=
 =?utf-8?B?UzFYUm9KTC9iMVB4NFg4TXhRc1kwM1FBZ3htV1owQ0NZSEtWdDlRQlYxdHBl?=
 =?utf-8?B?b0VzTlFKVlArbWNLdm1DYnpoRVloeWhWN0RUdGJ0L05YQUJIU0tmNktWTFMr?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb59d518-0f8d-44ce-eb87-08dc83f80360
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 18:07:21.3334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCyv6hEWwjMj/V55j0heYnx5jl7YJrHat1sN/7RDCR7GImyS11HysFluGoWc7QKEcYOk45zX+7rsBpG9aggdrLEQgIubRtfoShhC3ugTU3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7383
X-OriginatorOrg: intel.com



On 5/31/24 12:57 PM, Tony Luck wrote:
> Use get_cpu_cacheinfo_level() instead of open coded search.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
