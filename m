Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E062577B
	for <patches@lists.linux.dev>; Wed, 15 May 2024 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791663; cv=fail; b=bLMTIyQcuKzNjbsIEm/dWZ0MIi5VckPN23XuBpR2apdhn8zWziRwViCFVpO2sbvkZvYV4dkTMmLKdViRA92jgvNBQGDpScN3jVfpa840ukl9fFGGItST475DuOyNxE4rWMSlzWx9TKKl1n9MSTPa2jqOKeLjWN+tVKonILqOhl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791663; c=relaxed/simple;
	bh=og1Rp2rHSB6u7Uv0rIkATKTyBE63fcCdKegEUQnHgzE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aJ8dHQVtGDKmJxnop5SCv3L0lnyhq1hfHAUyXwEWxsSww1qyDojZ33WFQ4+xSkdUA1hEYVqqNuJxpBvmqEntKU12bmIwqWxyo1gqnAQ7O5wXaDPuegKKim3in97d3u/s2LXxNGwNDywphWuyNVjtdsUwhYXJe1rngviq+QLYFUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bj782XWf; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bj782XWf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715791660; x=1747327660;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=og1Rp2rHSB6u7Uv0rIkATKTyBE63fcCdKegEUQnHgzE=;
  b=Bj782XWfin3+WNehHJc8xVw4PtBohnM2WFXTNE3qY2Ul0DAsZD+BT5f3
   7VgE32l9faaV1Cw+Im0ISsm+Hh2QRpKNGnoFGlFJtigEJFC0Yac7PfS/x
   r0H8v3P1Tgyq1eNL04XN8hdTLVvHgaf49ESbL3OBzfV3wjsUqWndHzMtu
   0ndyNtCBdeQMFBo4BYWA1UhUVf9XFVCmoy52SHqqlZTMxB61p6Ku/4WNh
   CD8XDe6xiOYChXCtdqCmqNGlniOI65JfUQg8JF7u/iCll9JWHJoNKnBjy
   cJw0Bkk0usLQtpTWMDz0NM9KMaoBIN9yyS1tBjpY6voNZTHFU+Fo0dKJw
   w==;
X-CSE-ConnectionGUID: rH/woT8cS62VB4pOBZMSAw==
X-CSE-MsgGUID: 4rOqJOK/R4KbsMae9fC0mg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22994117"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22994117"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 09:47:40 -0700
X-CSE-ConnectionGUID: zhkho5LyQ8+JAUB1sUIF9A==
X-CSE-MsgGUID: WN2fzEI0RHG87gqCjIFjjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35582271"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 09:47:39 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 09:47:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 09:47:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 09:47:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvMGJnWgDwLDhu4MiijkR3zljQg0FDvpT7ec5OinhjY63/OYkrKCFzunrwfJLBuFlK8NUBozTQhfrz1q2BC57sgkyxFB1rcSRJel3fQ6Hbx9XacW+TfJnHNzCO+xHlJ/VgJe5GMKcbjCcv7B5bMJ6N//njOoQt0V92gB2MDxrszufMWRDbAFfEJCtmdv7U3nNwmkWlq5QMgpqVmZbjWIub97Nzyg1Etzt6whYqu+GxRregwBGN3HQTsxxyeFqU5juxzAbNeR5ogBjJF/NFp/+tkM4uCb20kgPfQDloe1+kNXVCluIARaKVsmC8Fp0OFNBtb5fJCvxT4IKTz7By/4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CkpNeMJPkuvXs3fcVlSDkGGDiMmsDVzzQH4q7jxHwU=;
 b=ghJe4/Ww/a0Oilrg3y2AnMWBGIiljnYfygBWdaNc2bJoZCg+cohA5pTRQQBJooYXkzpcQPDmtyn84gnUwm0DSeqv/2cPizNflfQ1e6kRVzr0qOUTo8A0yeE8OcBCWT6io1hEXqbiRadg4Hn/xKbRwvqZ+zANG1bnaFSYKJjHjXPWTzeANWKG0+zEC7pzM63XWQ15ktTfirAmSGMyl0YZh8dr4J9cs3gEh8tfwf5fkb68TOQMmJTJ7nEfHQ4kkPhhBG6ufbob2lFFepN+4Is9D8w4LIYDZYl1u0kzFMkG6zj8TCVnqP9FANBiS+6HLlfBfsmL5P7/d8R8nEOrlgwk8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB7399.namprd11.prod.outlook.com (2603:10b6:8:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 16:47:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 16:47:30 +0000
Message-ID: <666470f0-e8c0-423e-bcb3-ea16359f5cfd@intel.com>
Date: Wed, 15 May 2024 09:47:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
To: Tony Luck <tony.luck@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
 <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
 <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b718c70b-21ea-4c4d-9ecf-387b8276a721@intel.com>
 <ZkPdPTbgH-0EpBc4@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZkPdPTbgH-0EpBc4@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:303:dc::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB7399:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7e11d8-1e45-4535-627f-08dc74feb601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnpjLzEzYWlYQkU4eHA2YVFYOHVMcnFONSs4N042WURXRnpmTDdla0dXK21w?=
 =?utf-8?B?c3FZakhIMVVHVG1kanF3b2Rtc09JRVBwZ3lCdHVpMXZwTlR0WmVKR3BQSHkv?=
 =?utf-8?B?UWI0TUl5R1ZpYTNwRjE2a3B3aVAxZUJNbllGVG5OdTQralJWUEszajJQSkww?=
 =?utf-8?B?bkt5V05BTzB4aSs5MVhTUjlPY1U0NWZkcnZ3Uzd2UmxabkZSamQ4Wml0OHNW?=
 =?utf-8?B?cmFhdUF0S1QrSnZXRnlFdFRDNUR3czdPbU54S0R0aUtsNnV6WG9iS1J2T05s?=
 =?utf-8?B?WUMzT1l6UjJPbU5pS3hpWnNsVVNsK1lycXBwWU9EQXFmTzZxU2owbXVKVXN4?=
 =?utf-8?B?ZXB0dnRsa0VuSXZzQ1NWZzFPSTBPUFRRVTZ2bExGbStaNXB5b2FJWm1XTzJZ?=
 =?utf-8?B?RW1TMVJHcjJEd25WZ1dsb3Z4UDZPVDNPNHJ2MEtlOG02K2lSRThWaEJOTWJJ?=
 =?utf-8?B?akg2NllDYk05ODM2QnlhYmkwN2JOcXlwc3NjQUQyeGlOb0dhNlZGeGdGWlpE?=
 =?utf-8?B?ejhiWjJQeEo0WDFBMk5aMkxWcmtrVzVPZkVJNVdTMEx3SkF0UzZRTm5wclNy?=
 =?utf-8?B?dEx0SUx4ZlkvQllNYnp1WVZ1dmhlUTRiRkZkUzhKY0xFVWFxdDA0Nk94NjBt?=
 =?utf-8?B?WnVEL1pjdEZFck1ub0dxWWtrWEF5ckdQZTBJcnpUKzdMMDdkY2sybitTaURT?=
 =?utf-8?B?bTloSDgzdEwrUkNJTE5CWityUVBmSS9Cc1NzL0hVdmZuSTY5am92VVZLaDUz?=
 =?utf-8?B?eDZxS2dhdTVLVUlSd1EyUG14OVd2OFZsRm51WjdFVVFsOG1veTF4MjlsVHVL?=
 =?utf-8?B?c2hRRUFIMUVOb1V6aTkvbGNjdDkya2FRZW1QQ3dvNXl4NnlXa1V0S2tXTGVn?=
 =?utf-8?B?aXJGRnRsdWdUOHVIc05pK0FwR09KcW1iZGlUbUtIbGxBL29UZkV2NjZpSDhx?=
 =?utf-8?B?REFHTStGT2Fvd2trblJQL0Q3TWdvbkIxNStuOERWNkVwd215YlVpeDBQL3ZG?=
 =?utf-8?B?MWFhU3hIbjM0QmxRd1U0ODkyaS9ZSm1JT2drQmE1Ri9wQ3YwT2NjQ1ZVUjRT?=
 =?utf-8?B?dEVOMWMvRDd0cnBDRmsvV3J3dUw2WE1ldHF1Si9KajFTamZJNCs3VzdRNFRY?=
 =?utf-8?B?SCtkVGZnbVl4MStVcmhjZzlpNjNEZU5mbm1SaFF3eXl0SnlPandvU3lrQkNw?=
 =?utf-8?B?cThuUk5Lc3RoWk1Qd2pGZHVMTVFlaUhNMzUyQWN5eFc0Y21nQ1VnOERHZUZ0?=
 =?utf-8?B?WWk5NWthb3hkS0JybCttOG15M2FaWTUxeDB4MmdEUXBrNmVKNGdONWM5WEVV?=
 =?utf-8?B?RGNaamx4VjE0aWo1SyszVER5eXRnNlN5UW1rTkVsalBic0xlbnd2Q2ZhZW9F?=
 =?utf-8?B?YkRwK3NFVUNWNDk4Nmc1aFhrOWhiMzMwM3RqYjdFcis2Vm8xSkYzMTBlbnVN?=
 =?utf-8?B?aTRVT2VhY3V3WWdyZWJBOUNUeFZ6MWx1UGNVdEJrTElBVGNtbVJ0eWZ1cGJF?=
 =?utf-8?B?dS9NWjh2eTNTVEkyVVlZbmNGWjdwS0ZBZ2xZQ05DOUd5NFJhejNsYmVIRENJ?=
 =?utf-8?B?eURYVVB4dmFvYXZXSEJKbzM3Q0NEc3ZkWlNJeWFHK2h6VHRtODJYbTlUZHNh?=
 =?utf-8?B?ZnowRUd6bHhoWFhMN29ibG10bFhIdjViMHRLRDBWb0c2Ti84WDQ5aDRzanFi?=
 =?utf-8?B?S3g1VWk0TkFwWjM5bjRETXlyZlRzZG95QzF6Rk1NdVozUkpYNHlDTXdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEpEd0QwUWNTc21qaU0yR2RJYUdLZWgwUUNBb0l2eDlhVFBYZlluWlI1TDU5?=
 =?utf-8?B?eElRN20wR2FMQnZHaDZ4aUlOOG9EUmg4WjVPVFg5cFU3MkRmOWx0aU1Vc2gv?=
 =?utf-8?B?LzI0N2t6ZnJ0Z0p2YmRsZ081V1d3aml4UzdXR014NE1RN1lKeUZwaUJobnJ2?=
 =?utf-8?B?SHBSa0dZNGRKbVZDWEJhOGd3U0wrRnNkYzNjV05Pd3R4MDRMdjBZazZhdW1D?=
 =?utf-8?B?ZE1wakxnUDBhWXVZeW1mTSs1UFp6S2lraVg1VEtZdnY5MUZDMWc0bkdYYnRk?=
 =?utf-8?B?VjFwYzRJeTFEenNoZmVDOW9qQXFIT3BRVFkvZFc2d0ZmZm5vNjV2cE11MSs5?=
 =?utf-8?B?SFRHZGdjZHdiZHR3a1pxR0pqNnY2eXp3a2h6cVF6TThLdDRROFJGdWVkWDU5?=
 =?utf-8?B?RzlJUkFQcWowY1U3cGxTU0pwQ0pjOVhyTGlKUmRCcHJoRExYbUhmY05DZElP?=
 =?utf-8?B?blc3UWp3SmtuSTJZRmFYYXlOWW1KUnRXNjdreUZUMTdyUXFiWDlTZnR2dGdh?=
 =?utf-8?B?LzZXS1R2c0pSTXJXazAzb0FEN1cyNngxOVpwL3ZwejFCTU1jczZ5TEp4dUJP?=
 =?utf-8?B?cjM2cGo4MGhrUDdBdVZ0Qm5Pa0l4RjRtdTN4TWJTQy83VUgxUERkNTNzM1RQ?=
 =?utf-8?B?eTVoSjBvLzVRZ2VMclo1ekpjYkRJK2M5cXcvWGZ2WCtPM28yaUk4REh0bjU5?=
 =?utf-8?B?czR0czNEUUhiWDUxM0gvMFVxRis5a09acjhoUCtpdElkcXpSZ0lPSStyRDRN?=
 =?utf-8?B?ckVNMDRySFFlclV0UnVSZTdsTUpqQ1QxdkRvR1g3MmdzR3hrd0RxSzdYNy9L?=
 =?utf-8?B?Smtubk91bUp3WE1rcXB0QVJCWGJkOFV3dUJNTFNiYmtPaXd5UU5PRG5UMlcy?=
 =?utf-8?B?SXFHZ01aTlp4UlErZGtvWmEzYURYRE9WVnNIM1F5eGxxcVg3N0JPZ0VkWkw5?=
 =?utf-8?B?dGY0ZG5PMUdtUVlsYllQVTQ0YUtJdTNYRm04L00zZzRVWUY5bUFzMnN3SFRu?=
 =?utf-8?B?UG5RK3h0cUc3VmR6RTNVSW1VOE5JRktGcVdJQzZiL1pxZ2F4SHFXVkxEY3dr?=
 =?utf-8?B?a3hCUnRMeWQzZHZmNjlJdjYwRHZYM213Z2Vqa29SN0w0eGVkU2l5LzBTTzNW?=
 =?utf-8?B?VHhTcFNkcmdhZGlqdWZBL2hwOTVLT2U4cWIrbU94blkzMHFQQnFCQVM2Ukth?=
 =?utf-8?B?SjJVYlhmUGxoTzd5Tjk1aTFtVnFQNUg4R0pDZ2hJamFLVkUyaXMycWt4eEdH?=
 =?utf-8?B?Snltc1luZ0JyUG5rSk01dWNmb21xZWFKa1FqM2pvODdSTzJjQ2JPbkIzcDdP?=
 =?utf-8?B?a1U5VjZtNmZXYU43THErb1A2TW9mSnMvaklrOFJBbi9LRzRtNDJsVHNld1dQ?=
 =?utf-8?B?VldQeHdyOVJoTlNBL1RSblJLaldJblRjMWZUWW8yZTdCWk5DcjM1UVFmeWRj?=
 =?utf-8?B?MjNNZVlpWDBEZ0Jxd2ZvMGdORnIzbXd6ZjhkcXRPYW1kNzQxSXpxZC96Yi9Q?=
 =?utf-8?B?L1dLNnVGMm5mZlpkM0lwN3UvZzRIb3B5RVFEMmZYY2ZxL2FTQkI1MWtTREV2?=
 =?utf-8?B?d1hpNHZGaEFmbEVxTUdIYS8yQ3NRcmsyVGlQUWZYNGMzNGhWL3d0TEVQbDBu?=
 =?utf-8?B?SUFqeERtT0lTSDVyWFhNdUhlcGduV0RJeFlONUVOYzczVDAwM3YvcjNCc3gy?=
 =?utf-8?B?Nk9vS25KYmhRMTdJZm1BQkN6dDZSUEtZck90V0JTalZZWWhUelAwYVpuU1JF?=
 =?utf-8?B?RDBwa2YvS3lrUGh2dzBSMGhjSVBNd2wydmNMYnF5bWZVcG9TR1VMc2RTVUVU?=
 =?utf-8?B?QzZPUGZUMGF5TS9jMERwRG1qVzZGVEIrVDEwMmFLYmJ0UXMyaHdEY1pEUU12?=
 =?utf-8?B?R2pBbVQ4ekpxY2w1ZURhU0hDTjJTT2xzWGlyQzNQclhJbVh0aGNkdXNJbGVq?=
 =?utf-8?B?RkVZYWYzNjBPbXRxOE9IcFNhWXZLTHNTK0VhaXRBMGRkbFgvdnhWUjVTdW9y?=
 =?utf-8?B?MEsxUFhleUVLSlgremlDQzFCVWNoWGtaMzBGVDBrMTBFenpyNTFzZHpIV1pL?=
 =?utf-8?B?bkN3NGxKbzRiV3A3YTlnbS9hNzB0UWhQQmxoTzhCeVJMdGF2alV1MDZYbHBp?=
 =?utf-8?B?V0lkcTU4dTFzNU5oaml3MytyTlpQTEl5VnBtYkw1TUhiMGxGWkxueUZiQmlQ?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7e11d8-1e45-4535-627f-08dc74feb601
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 16:47:30.5380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtZX07q48Mgk5YpgryM+e7AHKJR4q1W1SZl219L3F2KSZjBev8VnARR4Mu2OnzYYh5Dk5tDSHSoDAXrb5MatUwGn83WzygFvLmvopbudVYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7399
X-OriginatorOrg: intel.com

Hi Tony,

On 5/14/2024 2:53 PM, Tony Luck wrote:
> On Tue, May 14, 2024 at 01:30:05PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/14/2024 11:26 AM, Luck, Tony wrote:
>>>> On 5/13/2024 5:21 PM, Tony Luck wrote:
>>>>> On Mon, May 13, 2024 at 11:53:17AM -0700, Reinette Chatre wrote:
>>>>>> On 5/13/2024 10:05 AM, Tony Luck wrote:
>>>>>>> On Fri, May 10, 2024 at 02:24:13PM -0700, Reinette Chatre wrote:
>>>>>>> Thanks for the review. Detailed comments below. But overall I'm
>>>>>>> going to split patch 7 into a bunch of smaller changes, each with
>>>>>>> a better commit message.
>>>>>>>
>>>>>>>> On 5/3/2024 1:33 PM, Tony Luck wrote:
>>>>>>>>
>>>>>>>> (Could you please start the changelog with some context?)
>>>>>>>>
>>>>>>>>> Add a field to the rdt_resource structure to track whether monitoring
>>>>>>>>> resources are tracked by hardware at a different scope (NODE) from
>>>>>>>>> the legacy L3 scope.
>>>>>>>>
>>>>>>>> This seems to describe @mon_scope that was introduced in patch #3?
>>>>>>>
>>>>>>> Not really. Patch #3 made the change so that control an monitor
>>>>>>> functions can have different scope. That's still needed as with SNC
>>>>>>> enabled the underlying data collection is at the node level for
>>>>>>> monitoring, while control stays at the L3 cache scope.
>>>>>>>
>>>>>>> This new field describes the legacy scope of monitoring, so that
>>>>>>> resctrl can provide correctly scoped monitor files for legacy
>>>>>>> applications that aren't aware of SNC. So I'm using this both
>>>>>>> to indicate when SNC is enabled (with mon_scope != mon_display_scope)
>>>>>>> or disabled (when they are the same).
>>>>>>
>>>>>> This seems to enforce the idea that these new additions aim to be
>>>>>> generic on the surface but the only goal is to support SNC.
>>>>>
>>>>> If you have some more ideas on how to make this more generic and
>>>>> less SNC specific I'm all ears.
>>>>
>>>> It may not end up being totally generic. It should not pretend to be
>>>> when it is not. It makes the flows difficult to follow when there are
>>>> these unexpected checks/quirks in what claims to be core code.
>>>
>>> Do you want some sort of warning comments in pieces of code
>>> that are SNC specific?
>>
>> I cannot think now where warnings will be appropriate but if you
>> find instances then please do. To start the quirks can at least be
>> documented. For example, "Only user of <feature> is SNC, which does
>> not require <custom> so simplify by <describe shortcut> ..."
> 
> The main spot that triggered this line of discussion was changing the
> sanity check that operations to read monitors is being done from a
> CPU within the right domain. I've added a short comment on the new
> check:
> 
> -       if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> +       /* Event counts can only be read from a CPU on the same L3 cache */
> +       if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
>                 return -EINVAL;
> 
> But my change embeds the assumption that monitor events are L3 scoped.
> 
> Should it be something like this (to keep the non-SNC case generic):
> 
> 	if (r->mon_scope == r->mon_display_scope) {
> 		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> 			return -EINVAL;

Yes, keeping this check looks good to me ...

> 	} else {
> 		/*
> 		 * SNC: OK to read events on any CPU sharing same L3
> 		 * cache instance.
> 		 */
> 		 if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(), r->mon_display_scope))
> 		 	return -EINVAL;
> 	}

... while I remain unsure about where "display_id" fits in.

> 
>>
>>>
>>>>
>>>>>>>>>         }
>>>>>>>>> +
>>>>>>>>> +       return 0;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>>>>>>>>> +                               struct rdt_mon_domain *d,
>>>>>>>>> +                               struct rdt_resource *r, struct rdtgroup *prgrp)
>>>>>>>>> +{
>>>>>>>>> +       struct kernfs_node *kn, *ckn;
>>>>>>>>> +       char name[32];
>>>>>>>>> +       bool do_sum;
>>>>>>>>> +       int ret;
>>>>>>>>> +
>>>>>>>>> +       do_sum = r->mon_scope != r->mon_display_scope;
>>>>>>>>> +       sprintf(name, "mon_%s_%02d", r->name, d->display_id);
>>>>>>>>> +       kn = kernfs_find_and_get_ns(parent_kn, name, NULL);
>>>>>>>>> +       if (!kn) {
>>>>>>>>> +               /* create the directory */
>>>>>>>>> +               kn = kernfs_create_dir(parent_kn, name, parent_kn->mode, prgrp);
>>>>>>>>> +               if (IS_ERR(kn))
>>>>>>>>> +                       return PTR_ERR(kn);
>>>>>>>>> +
>>>>>>>>> +               ret = rdtgroup_kn_set_ugid(kn);
>>>>>>>>> +               if (ret)
>>>>>>>>> +                       goto out_destroy;
>>>>>>>>> +               ret = mon_add_all_files(kn, d, r, prgrp, do_sum);
>>>>>>>>
>>>>>>>> This does not look right. If I understand correctly the private data
>>>>>>>> of these event files will have whichever mon domain came up first as
>>>>>>>> its domain id. That seems completely arbitrary and does not reflect
>>>>>>>> accurate state for this file. Since "do_sum" is essentially a "flag"
>>>>>>>> on how this file can be treated, can its "dom_id" not rather be
>>>>>>>> the "monitor scope domain id"? Could that not help to eliminate
>>>>>>>
>>>>>>> You are correct that this should be the "monitor scope domain id" rather
>>>>>>> than the first SNC domain that appears. I'll change to use that. I don't
>>>>>>> think it helps in removing the per-domain display_id.
>>>>>>
>>>>>> Wouldn't the file metadata then be the "display_id"?
>>>>>
>>>>> Yes. The metadata is the display_id for files that need to sum across
>>>>> SNC nodes, but the domain id for ones where no summation is needed.
>>>>
>>>> Right ... and there is a "sum" flag to tell which is which?
>>>
>>> Yes. sum==0 means the domid field is the one and only domain to
>>> report for this resctrl monitor file. sum==1 means the domid field is
>>> the display_id - all domains with this display_id must be summed to
>>> provide the result to present to the user.
>>>
>>> I've tried to capture that in the kerneldoc comment for struct mon_event.
>>> Here's what I'm planning to include in v18 (Outlook will probably mangle
>>> the formatting ... just imagine that the text lines up neatly):
>>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
>>> index 49440f194253..3411557d761a 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/internal.h
>>> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
>>> @@ -132,14 +132,19 @@ struct mon_evt {
>>>   *                     as kernfs private data
>>>   * @rid:               Resource id associated with the event file
>>>   * @evtid:             Event id associated with the event file
>>> - * @domid:             The domain to which the event file belongs
>>> + * @sum:               Set when event must be summed across multiple
>>> + *                     domains.
>>> + * @domid:             When @sum is zero this is the domain to which
>>> + *                     the event file belongs. When sum is one this
>>> + *                     is the display_id of all domains to be summed
>>
>> Here is where I would like to understand why it cannot just be
>> "When sum is one this is the domain id of the scope at which (for which?)
>> the events must be summed." Although, you already mentioned this will be
>> clear in next posting.
>>
>>>   * @u:                 Name of the bit fields struct
>>>   */
>>>  union mon_data_bits {
>>>         void *priv;
>>>         struct {
>>>                 unsigned int rid                : 10;
>>> -               enum resctrl_event_id evtid     : 8;
>>> +               enum resctrl_event_id evtid     : 7;
>>> +               unsigned int sum                : 1;
>>>                 unsigned int domid              : 14;
>>>         } u;
>>>  };
>>>
>>> -Tony
> 
> Maybe an example might help. Assume an SNC system with two sockets,
> three SNC nodes per socket, only supporting monitoring. The only domain
> list created by resctrl is the mon_domains list on the RDT_RESOURCE_L3
> resource. And it looks like this (with "disply_list" abbreviated to
> "dspl" to keep the picture small):
> 
> 
>        <------ SNC NODES ON SOCKET 0 ----->   <------ SNC NODES ON SOCKET 1 ------>
> ----> +----------+ +----------+ +----------+ +----------+ +----------+ +----------+
>       | id = 0   | | id = 1   | | id = 2   | | id = 3   | | id = 4   | | id = 5   |
>       |          | |          | |          | |          | |          | |          |
>       | dspl = 0 | | dspl = 0 | | dspl = 0 | | dspl = 1 | | dspl = 1 | | dspl = 1 |
>       |          | |          | |          | |          | |          | |          |
>       +----------+ +----------+ +----------+ +----------+ +----------+ +----------+
> 
> Reading the per-SNC node monitor values looks just the same as the
> non-SNC case. The struct rmid_read passed across the smp_call*() has
> the resource, domain, event, and reading the counters is essentially
> unchanged.
> 
> Reading a file to sum event counts for SNC nodes on socket 1 needs to
> find each of the "struct rdt_mon_domain" that are part of socket 1.
> I'm doing that with meta data in the file that says sum=1 (need to add
> up something) and domid=1 (the things to be added are those with
> display_id = 1). So the code reads:
> 
> 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> 		if (d->display_id == rr->d->display_id) {
> 			... call stuff to read and sum for domain "d"
> 		}
> 	}
> 
> The display_id is "the domain id of the scope at which (for which?)
> the events must be summed." in your text above.

My point remains that it is not clear (to me) why it is required to
carry the display_id around.

 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
		/* determine @id of @d at rr->r->mon_display_scope */
 		if (id == domid) {
 			... call stuff to read and sum for domain "d"
 		}
 	}

Reinette

