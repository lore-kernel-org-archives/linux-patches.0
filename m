Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F9302146
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 02:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788747040; cv=fail; b=t6HoJdNB5+AqWb8imjntIrrevuWkO98tZ5hghhOMZZuSLbJLUJVcT3uknPPErgI6lIj1c1zFuC9Z5eWRaWhCua1kAr6fp8fyoDZIP8ynOsZVm3KFEc40vOx8xNpjSSakl9lucbks2s207ONf5ZnAp4IF7fqcHsdShuRA5Wzw7Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788747040; c=relaxed/simple;
	bh=1WExr/2p7bByOM4i/WrfU0Yp1SjbkHe37ats1qzI9b0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VzlJCrrAFoEvFw4TOs27OImG/SCdSxGrEt3XiSd8dKpx9Pz7S5x9Irnz8Y5oy6mckXcwGT8QlTFfAaOv14gJ/J+IoYVClVy7lui1Seu6ucMWPw/NnXmL1iTnn4IRZ2etAA5N9GW2vSPfs9ceQALW22AaR9f1NdqMjr9FjwH6pGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iSdVXYuZ; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iSdVXYuZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788747040; x=1820283040;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1WExr/2p7bByOM4i/WrfU0Yp1SjbkHe37ats1qzI9b0=;
  b=iSdVXYuZgPhKGkyAlHO7EOASVaT1pWi/p/tr6SRkk4WZv4dT7FelvcOB
   HAnRvSZEi4P2blQFTpzJsIBOUv8Mroas+Bpu4RFl0SC3XkcqBPhU2lHSw
   yilSK83ZYEjoG943H+v24sdOw3j0RQbgZI/jSwQWzstrENusPrtWrhcu+
   aG26mb1pE6FU4j6Q1eDZ0d03FJ7qZWap7uN8PEhInDuhQHpDwnaME7h7X
   1zpUhd/RjgTS/cyLTE6JCV71Xd+DZ+b/cQXW+IKCnrSqh3bu8putte3e+
   AyuIchKhqQxSzNiwi+zcolh4XEZV6DWpd0U2vxtDHooHeLeyNgZ4P3hXO
   w==;
X-CSE-ConnectionGUID: 5ezl24JPTXKwaiytXFGsOA==
X-CSE-MsgGUID: iagTMFL9QXOT5sz6qu2PoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11898"; a="111924333"
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="111924333"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 19:10:40 -0700
X-CSE-ConnectionGUID: lbTsUWsqQPurTh3vV0sPfw==
X-CSE-MsgGUID: RHP4m5n+S5K1OpNR2BNeLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,266,1779174000"; 
   d="scan'208";a="300468864"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2026 19:10:39 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 19:10:38 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Sun, 6 Sep 2026 19:10:38 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sun, 6 Sep 2026 19:10:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc6bZjKqraLktZ4q0CyO9bu59w9uXq/hjsCb/Z1I7K/cYirp7Rtm+A3wCkv7oRKv0mLZDuGe+4h/FDD4N7NF4nudxV/J2qXpI2SLj6ibo0kNCjiP+Tj1frg1Lp8hz5gzU9wZSA+omVW+pInq3DKFBXtN3f5zc2qYL1Y9tnp2I07bNilExH4pEXnvhP/fs526Uw7hvhaNPk5SEjaN3dJtekP2oaPAlHS/pr0RCyqRVVNyDKolzHVudrqPY72mzd37nfCXIlUs4zqV+73wY2vDz1BLgj33uAhuuAphQnzjWpWWuDahjkl4hGygIiHmb4zq8Rdz42GUBSANs6YNFJ6bPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXJjW5ooA1Ej+756kKNkD/kdQ48ChoWkBvgqFZpptnI=;
 b=ZV5tDqIq09mHmC8D2wHI6+/N6WeGp554EuBzB+g96MMj7njBLqdbKGB+u/p/vFNTEE0KDXctDnxEcp9ZUDxyHQr2POlcpejnGmsg6DE1i+4Cxi62gxS2HZbUnZuGTu6F6qqyamMFwI9Nv1k1r9lRzMA3RoqQgYZdQQFR5968tWTqgK7aPl64E8Nu8YKlxAW1oX/TVApNkt58Hfo1vAg3PBRR6JTuNnHhDzfOCIknxSgL16OMAlXlj8r3/Ma4vY+Rx8Vyw1jSH+05ILOx/sWaF7YdL5UJdZVBKvGkIg++Uv+tHaDxXN9Lt7QjzgPrJZdKzNsE3gStfqrO3Fo0yY1Gbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH8PR11MB8061.namprd11.prod.outlook.com (2603:10b6:510:250::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 02:10:36 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 02:10:36 +0000
Message-ID: <425a1c9f-7051-4baf-a884-65524e8f4fe4@intel.com>
Date: Mon, 7 Sep 2026 10:10:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86,fs/resctrl: Remove "arch_needs_linear"
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
 <apo3lSWAQRRK2W_r@fengwei-dev>
 <35759986-3bd3-4ada-b2ce-434090cdc1cb@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <35759986-3bd3-4ada-b2ce-434090cdc1cb@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI3PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH8PR11MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c18519-cd42-47a9-dd6e-08df0c853476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /vLx0CYkCFUHS9Do5B3e/yyK5Ykq/cPbVbzAJLohPHuJmIZ6EQ5/uJP0Vza3YhgeYD/1k2Ms2qnyza5sETcOuifbMyJAG3fKYUt9AmrWUMUHx0dft0NzRbHsvJ1t1bvf53EWjNsj3VhuXxNXkKaREFi2yBQVdM371d2sQQcb3LJU2pFNjkbeZNN7ur0W9jmwiHeLrNr06vn3gYCqSheB7tZXEZzUjQ1t8O6xOh0F7RrnuNdeS3G0QfyhvIUvhaTkd9JB2i2OhY80iPilKz+LEUoD3asuHovOG8xAJ/QMQXvDLsiDSLEYul0qeo4HJvQPzpyVAOtx7Tk8JskYmLmIrKQfh1LtvgSbHRahdVihvjMp0CqKHO+1Z//zQ7ywlOQaWUuDYbX/Mu1SiBzF5X6LTr0TujmT5Gpy/Rx/64BwOblOGqRAH2Cei+4s2/x1RYJ7naI1AsSvjn5GC3sGCQB3eNnA7riKh3FDCJzT9w/XeBmFDiq99VYTi+DARNC7BMdplMM0x0iu0zYP5tA1BSmpcIWJ42OwVNtfXlW4lMSvCV/dWmxFWsK3SBP4t27fV1c1EuXXBadc3P8SvfQZ9Jfw5ljFv1jeysJ6iNPWPhJWVF9dFFOifDTrmZZIoFuwPmWSXPWRVcyEtMAjI9gGLe+FvuKo/galkCeWSBbIuLw1mAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmNid21HOEYreDl6TDNmeU1PU2pISGtIa3Jxdjh6WUZIZStZdTY4aXZPandB?=
 =?utf-8?B?RHVkeHd0RVFzbWYyZ2daaUZmWHZTa3JxK2RKSWY4WDBuZ05acEg5UCtReFpJ?=
 =?utf-8?B?eW9zSWpBcS9kS2RWWVJndkR1Y3ZScXlyTkp6Ris5cS8vS0VzcjRDaHpGSGxT?=
 =?utf-8?B?Q0FzNUJWS2xFSUJYMXFYZGZhTlpxQSsrZjZkcUpWVjZJU25sd0hMSUlDZTdC?=
 =?utf-8?B?WnprZjVyTGxxdVZ2RHRDOHVLSG12TVZvVmRuOURsRFVnN1BRWGwzRTU2YUZS?=
 =?utf-8?B?d1FkSTk5R05QYlFWUEhJbXJMMUUvQlpZWEFNM0tBVnMyTmFQZkl0KzY5aVU4?=
 =?utf-8?B?Q0ZNTU9ZTXNJd1duWTZpazdQZjJvMkdwZUdoNTVoSmFpOEhTVUlTSXhlK1ZL?=
 =?utf-8?B?c3Bzd2l1V1NpZlZmNDU1cUxrMHhxWlNRZU1LNS9iL3lVRFVISDA2YTNsRzdq?=
 =?utf-8?B?a01mYzlyMFNjdzRWcnRZQnNscnV4K0VqR0Rkb0VEQUFEWnJIMkZ0MzJBRmZq?=
 =?utf-8?B?c1g5Z0t6d0VOcTR3eHRLdE9ZQWkxK3VjMnFBdytsSnpxMWcxNE1YMHpWbU9N?=
 =?utf-8?B?aTlBNEw0ZXBTSjRTVHB6R0c2eXlSaUNoQkQ4ai9ONTVkWjR5MEI1LzZ2U0Zm?=
 =?utf-8?B?Zy9ETTZxVXRDYzlOZGltMWhVeUJsU1krVXNsV3FOWXlZb1NSb2FMcGhpK2cy?=
 =?utf-8?B?aWcxVlZvazhrdkQ1Zm9TTy9jdGFhZGVyMGNuQllCdHorM1V1UDBTTGJWWGFw?=
 =?utf-8?B?QUFBZVVmYUhVMk5nN2hoeC9CWmwwQTJnVUNZNTkwNk9Na1dsQVN0RHYyazlE?=
 =?utf-8?B?L2hKbmZIQjZyREZoMG9xY0ZSYUpBc0RUVWwwcmxLeGRDbnFKZENPSk4zWEpU?=
 =?utf-8?B?WVI1d1ZFY2VidFFzcnIzdFlqbWpuYmlCbktndExLZkxaVkpRU01tRXd5emVR?=
 =?utf-8?B?ZHRWV0ZycnZiOVhoNC9NQWdOazltVXVVRW1EM3BqUjJhTnp1N21GSU1FeHVT?=
 =?utf-8?B?SGZ4SnpZcytMWTRtTHMwVlB2S2lTclcyaFdIcm5wV291aFhyLzBSOGlHbWR6?=
 =?utf-8?B?S3NjQUR1Wm5EWFRCZ1M3NFJucHg3WFJDOVdidlU0RzM1cml1L1Z1MVdmbGdy?=
 =?utf-8?B?VjZ6KysvWlI2dGxqR0IxWGhDcGViSnVsRFdOaGNNeUF3b20yNk9BeDBRRWdr?=
 =?utf-8?B?V2wrUEVNQkdEZnRIbHB2bnNIb3p3bWlwL0FyckJQWkUrSHZXcUE4dVhFSzhL?=
 =?utf-8?B?SFlFYkRaNGJWQk5TQ3liUkZzcXBzNjlxd2tKZmNpMDBscVVTMEdPamdybEJn?=
 =?utf-8?B?OFpRR08vaDBqdG8yWHA2dkt2Z1RHZE43NGh5QWpyQlJNOHJnc3E0enhCelY4?=
 =?utf-8?B?ejlmUU82SlRjRDkyaWdVNHhFaFEwdDVzd1M3THZsWkd0NFcxeVUrUFZ4dkdy?=
 =?utf-8?B?SUp2T2Zmc3hOR1J6RENJb1drOEExSnRxLzlwMzJhNUFBUXRROUlGd3BRMHYz?=
 =?utf-8?B?bjFIbHRiNjFRMXM2dFpPVnorOCtwQWl5QkVyUUd4bEVUaG1qRmlYcGkvQS91?=
 =?utf-8?B?Q0dsNkZNRDRwZXdFV0NmaUliU0JhOWZzUGtoL29jQnpHdG5teVZha1JxMnli?=
 =?utf-8?B?S2IvUUJwMWw0QW5rQXhrMWtDaGZnZjJteU1rOVNFb29ZN3g2ekR3WnVQR0wr?=
 =?utf-8?B?WGJEb1pkUEZMWVgrOEJxSHdVWU5vekc2MCtxL2Y5bE1sRFg5ekJ3NVRhK3l2?=
 =?utf-8?B?Z1Q3SVNaQzUrdDZqc3B2N0xVdGtHa0ZaKzlVUDJQcFB3bGFNTnFNVEo5TFpr?=
 =?utf-8?B?WkU3Q09raDI5V1ZmMFRVT29jTXRRT0s2dlV4ZVkxY0pMaGwybFZGbkdWWEgy?=
 =?utf-8?B?QWRwcHZaYkRFeExvNVBFYUcrMFJ0ZFZJK3BkL1dLRHVid0Fad2JwbTRMU3Er?=
 =?utf-8?B?dURleU1SQmRFZE9KQVRldXk5QUFmeTRnak5MSEhEV0lOeGRrZDYyaEdVMlJI?=
 =?utf-8?B?OVphd3RLV0pmLzh1Nit2ZWxBVWQyQzh5c2wySjhOZXRYZThDZ00wV0huOE8r?=
 =?utf-8?B?eklDMDVsd1JWN0NYM2p6NVAyTmFQV0VETkZnTHhFQURqN3U1QW8rQXBMK0Qv?=
 =?utf-8?B?NERRU0hJazFlZTlUMm1PYzB6emxNYmw3bUpxcjF1RVdsbmtJRi9oRis0UDh2?=
 =?utf-8?B?YjlzNityR3ZtTUZYTU1CNUhucFpKdmVGeW5SNVA1TFhQcmFJcWZVWTNiWVhQ?=
 =?utf-8?B?eXVHYll6THVWVXliQ0lCUkp4UDlhZTVuVUJ1aFMxOGk4ZGpkeW9iWndxVGx5?=
 =?utf-8?B?UDhibWp0SFZpdm9aMkI5SGk0QlV6Ry9xL3JtZmpKNml6bkNMaEl5Zz09?=
X-Exchange-RoutingPolicyChecked: MWWj5Nnc2R7ec4EyQXtUHyg9axKuj8nm3e78FDaOIpj8w3/HpP28OSc33if1fNrF8f5nd+b9sSQs5x+dMKLC4NZDv22xZmJmS1QDfYAyTTs7CIbGaxShFPFu/Rz3jggrYnQjIoL4UQxweCEY6E1IqQD7Uq+lLMvG5LekdqhF6MEvGj552ubdJdZ5GftMdNx8pC5djtCom0X1eaNdYSKIDwYvg0GBaz81mquQiYWdKpgODANCUpJAC5bqeZ84KV+HbAqj0b3itD46gEZ2j9xb9eE9fdlVokjksbXEOmHhnspyXasOyWsTJWF4nGR9hPoWXV0StgOF2aJAt6hYz6cJEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c18519-cd42-47a9-dd6e-08df0c853476
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 02:10:36.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMiOYvpefBS7Tmo1KFYRhYfO88c5fpMv1MwSzhFziqVmFAJHHWx7VaJn33+DRduJgeiAZzHHLQBa/NVyuQir5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8061
X-OriginatorOrg: intel.com

Hi Reinette,

On 9/4/2026 11:50 PM, Reinette Chatre wrote:
> Hi Chenyu,
> 

[ ... ]

>>> +
>>> +	if (!(ecx & MBA_IS_LINEAR))
>>
>> Maybe also print the following from rdt_get_mb_table()?
>> 	pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
>> 		boot_cpu_data.x86, boot_cpu_data.x86_model);
>>
>> In the previous patch, a "Non Linear delay-bw map" warning is triggered
>> during the actual write operation. Similarly, displaying such a message
>> during bootup in this patch might also be helpful.
> ok ... but who will the message be helpful to? This is a check of
> hardware state, not x86 resctrl driver state as in the previous patch.
> 

This can be used by the admin (not the driver) to query why MBA is not
enabled by checking the boot message, IMO.

thanks,
Chenyu
