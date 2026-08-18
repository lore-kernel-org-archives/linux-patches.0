Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA00117B425
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014279; cv=fail; b=iDGerm+tqQEcpCmmr7MPMw/HY2B2rIwa49LiRwNPntFMnkccLHk8iRTLKnk9R0FHpQfr3Dq/IMDV1SCOH0QUTWcc95LhWc9MiZSgyZZx+Mb+ilE0x/8Hzqwv+r8UzBVSD6T4Qse6o9qOiresWPXU9wsZRAQY23AlACdu/gzUvEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014279; c=relaxed/simple;
	bh=TelkPmvYBomaS87m7Y1P5whT6M/syoIK7AidDRkHBzc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uj2CgAGJbmuS4jqcPtemAWfQkxIoJwIfx1hddgBTxWoKMUgd3qzOA5XTVZ4/zgLjm1Zl8qYCBxVFdOCup6vtvFdJ3N5fvPyO2YZz0P0GfU8Cs86s3ClSErblxQ8mIZm1yWsUOexRfNyLLjulGDwbZ5prOQKTAdOxGJN+EtuFkns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/n0mYCU; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/n0mYCU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014278; x=1818550278;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TelkPmvYBomaS87m7Y1P5whT6M/syoIK7AidDRkHBzc=;
  b=g/n0mYCU0vnZHA3CG5he32c+gX8fBJ/0xffcMVCwLki8opp97Wr3vBsi
   T592H0e5CRPjeXHJSbUav7H4W/3B3T03fsTAtcnFdTY0p5uAMtkwRhaXe
   w9GFKs4dtHyUGls8NKWj9YEffM+KPygFCHbjyK47tWPHThQUSFlSK4Kqh
   4iLhlESHLiP4irslZ19WFQzlZKg5ZFcHaIFAdlvJU2qTH8ReIHWZd45BK
   SyK69nvfgE1naXz1WIIrDL+y9e3HCgKgP/HqZAwkOCF5f5Wxalbjo/lH8
   9XiFMcaYXIVV0Pa9uz1Axtge7nphluXtPstqTMsMf5JmXYA7AwE7JRHcq
   g==;
X-CSE-ConnectionGUID: lS7Md3T1R2iuirennZCaPQ==
X-CSE-MsgGUID: qu9q4eC7RaibGO8+ON5F7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98162564"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98162564"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:17 -0700
X-CSE-ConnectionGUID: uLNKwMIhTCaayyZBQ1Y28g==
X-CSE-MsgGUID: oWltGkJWS9a3RLluPgZQLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264623561"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:16 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:51:16 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGTjIBwm0S/usfowBJuNRfYuKp6cNlnRQpT6P+nuJnp7HF0wa1nWSITq70OjsdVGxg6MVkq9YLamx8W2nxGJ3iHf+ezOjyqdjjysWz738PNfia2+1UGAiHW3zVmOaOoU4HrlAUyfjaTH9pLjC25NSNH2psk91jZvtRziUAexRUT/0SFSUUY1lz7lSg6A6bF8aGmBsxw9sXWobLMSqczXdKFVSHuoA0JbYCbU86JratSDfLjymMzduowDBRcGtokcaU1zGjz0ERksyenQX/dBceR/SALKblKcEClerMunJhngnfpZ+XNj9nMtW1Gq1d6mBYEbhjNtkQh8+T6AhDIIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FICKmdpx5T58mk/xYabSaARJ0YGDH9A7H+uMc/WIk5I=;
 b=T2vbI4wpyiBihYTNhCgEwfLuPcjXEkhbgSlMek0dDLeWcgbq+to67Qr3C+4Hs32aADT5R5ay0yUIUcoESl+xJxNwUy1uxI7CyYehFYSMH7KyD+mX4EytSN6OzgoRkbdwI6lwP05+geBtMoSWcUNEXP1IOaaMZdBK98Y6UzwXDRTEy0EheqdgiI4XcaBPaSAPf//jXjDJPWYRZbAPNglt+Z32cfurgtZV3GiWZNL2GzWqO6VrSF1HnJCuz4utKE1UtrGiCFThpJUZ6JVKIWChaNfJLnVoGxisTrvfxcyA3e/awoCLEfHjNtmJFYsuJ8xhL/Ajd9HL+xMfjNS4rk7tYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:51:13 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:51:13 +0000
Message-ID: <3d80bd53-6036-4a95-a036-16a87b09f1a9@intel.com>
Date: Mon, 17 Aug 2026 17:51:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/17] fs/resctrl: Add interface to disable a monitor
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 83249604-a2d7-458c-98ed-08defcc2cd86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info: 0L4aiocE/2lAD/QrSNmfWddrKzeyKm2MOx9iFMZ4p8dnyHN8irvS1gYa5cANNhj0DOblDpco76CnTeI8Z+ClDUIWTVFkOy6+TBT9JU0FWY3kQeJF41JafybBMmQoNojiuBF3bPnkdKSMRX41mcNIEdfAUyRUpt5Kvybc7FeXgcNI6gXiU129U3SobFSQ+qa5OtHlzuxp7NYLQkA5VT/mzS3AnNx/BfvPtRX+B5SAOyr+pYHqZeod5/CrulagsnQxhefs3wNGtF/egmC6OT7MfxRvflH+CLeiaIZNvx9ikEHo9ylRwd4oUYBCKO9K9/09nSRPazrdmQXFjJ+Q4yRxlgr9F8kDlCReT+mdu05zmkL176/LVOChkaVZQHMVE1Kd00k9rmDMsnnlNF8kZlshGfv5bAi3AhM7UZK1dBVWBUuh0xOry8HZjeT46WKN48QnOin0HzSsIQjTca8tkhfc+ecfX3cEAcI91f79HCvVPF1FeCXvMbUrHJcvtWCEGrAWSxyZV+wyeHO9VMB09pHDagRBChENDiifc15IxRf52jw4PvuZki/4+pQfPc8uEJGZ0UobXNt5g+ZoappyVxaS029+U4guT+2miGY5w3YPgL/JGTxfl19FTIQVn6/GkknfRchgFpzvvlJDT9CFDMq1GvJ1PxYKmzHkpKnUc7+x1rReN3qDTueUFvOp1Fw45bqMWGPimwo0Cg4xt46a0MLD0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2dtbEVlVEtVbzNxUDIzRjk0OVFRUUwyMWN0aHpBeklDMnVpZkJxOXp6Q2tX?=
 =?utf-8?B?SW41ZngzUC9zRU56d202MGJHeVVrR01SU1lzbHVINjFNa05xS1VTN3BqMFhv?=
 =?utf-8?B?MFZ4eGsyWjExdFNxZ0x2K3R4YzJXTEovVy8zbFdrYUNhdWZWWG01UmRZeE5i?=
 =?utf-8?B?dlBPT0YzSFl0Zmk0dExuaVhWb1QrWjJvNDdETHZyNnlmTkQrbG9YS2ZJbFRH?=
 =?utf-8?B?aGF1UDR5aUovWjEwTEdGYkJYV1Q0WUhuRnNUdkhyY0xkb3FCVW1yNk95VFBS?=
 =?utf-8?B?YUVqVGk3L2xkVVR1SmlWdGFjWHN5ZlBDZEpNOS83WUw0SEdKa21QNUI0Slhk?=
 =?utf-8?B?YmFtWEhQbUh1QkhlRkZUMk5FT1l1dkowYnQ3T1ZqekNCZnNOUVJ2TmpvdWJQ?=
 =?utf-8?B?MERxaFBDdnQ0aEtEZVFBblhMQk1NWTl5S0FGNC9HME93V2lSVExOMzFiQ0Zw?=
 =?utf-8?B?NWFjN0NQMXkyeGdHcXhVMGZtQS9zNXdibnNhTHdPY0pDcUN0QVE3UnRERTVH?=
 =?utf-8?B?VVZvcW1hSmtoQUhjT2RzQzdFWWVJWlk1WlZTcTdsQXBLK3A1dFBvMU0rRWRT?=
 =?utf-8?B?VUw2YWFSMk9OTk5VS3BPVmVqbjYzYlhtU0lhLzlaR25Na3N0enlvcFFQZ2RX?=
 =?utf-8?B?a3A4Ni9CbGxwK3FNQXJxK0RrOE1rOU96NUh6SUdqaGdVZ29WZ0dkdGoydlRm?=
 =?utf-8?B?bnlJTkpNS1o0VGJQTVMvek1STkJNL3hWZXFQSnZicHJwSnNOT0UrK2Q4Vjkw?=
 =?utf-8?B?ckdocFdUVjZqSS9sN0djNnlKT1U3Tjh2TGQ4TkZ6RndMM1ZNdDRBRHMzR1N1?=
 =?utf-8?B?TFJocnFoWjBhZ2VUM3doek1SWjl1ajhON0ZLOHIwZGUvL29HSG43cHFvSFpv?=
 =?utf-8?B?NS92eGZKS2QrU3ZncUNMais3UitPM3YvZTFHQXFra1hwZFl0aDZ5cGRPc3Jo?=
 =?utf-8?B?RDV5YnpReTZINHZHWjdzTkhnUlZNL2NuRS84a21aZEVqNmgzc2pnNVN1MVJJ?=
 =?utf-8?B?QUNNYkZmVmN4cVpSNE1id3pyazJPQmltQ2ZwZS8zRW52REZtdzB6V0hPUnJW?=
 =?utf-8?B?V3hPL0ViUkFTM3RWWDZqTnpDQnRpbFZmTVRFamhqRmoxbDVsazRZdjlKVW9k?=
 =?utf-8?B?Y0o0R2ZQWVl6UTk1cGZRSlZNLzhydi9RUEcxYmdGazJ3L0lCVHNEOS8vS0ZC?=
 =?utf-8?B?Ui94b2o5TVBDTDVZVVdqNlFGUXJxVWFuUm9sTFM5MmlNM0FySjU1LzVVSVBp?=
 =?utf-8?B?R2JBanBsTGoyZWllMUlYbU1NL0lRUTl5RzFiMGZkOHBlVFUxYjFDa0EyNzJv?=
 =?utf-8?B?VzJEN243UEdBajdxWVU5Smw5YUlwemM4NTVrWVpkc05QWXJGQ01OSmN3UnlJ?=
 =?utf-8?B?NzQveXNxUmd0bzFjUEsxbFVCS2U3emorYkYxUGtTZ040N0pkZjU4dWxDZm9h?=
 =?utf-8?B?a25QNCs3TWtDUmpLWjMvblpEcEpxQ3dIY0dSNUJ2NVRlbmFabnNKZ3pWT1Yw?=
 =?utf-8?B?dk4wUVJ2Qk0vVnUvSVFHdXpQRTdkUnl5MTVrc3BJbURudERJK0plUW9TYkMz?=
 =?utf-8?B?YTNjVmpORENqcEZiNVhnTlpoSDJKMHpmcmxlc2psYW05ZkMwcmkxU0h5dkdr?=
 =?utf-8?B?TTZLOU5tNVBLdEVjOTQ4b29lN1ZWTkdRbUJUOW5pNWlBaVd3cVdia3RROHhn?=
 =?utf-8?B?RjNJRXhmN2E0N1ljYUdxanF4U094eTF3UldwSEJhNkI2R3JaM1k4dFUxTDJp?=
 =?utf-8?B?bUlBL2phMmtUUWJTNDZQajRjUEhaL1MvVjBDQURxcDVoVER4N3BQUHBqWkEr?=
 =?utf-8?B?TnVqRkNHanhUWllWZkdGUDRZbTBaRTdIdlprVFI1NytGNGVScEFSYTMvRE9x?=
 =?utf-8?B?bUFIN0lUbzBmRkE0VFUvUlJNK01nMXV4Tmt3RVVzMktMVWc1MnNiL2dMaUR1?=
 =?utf-8?B?QkpMbWZyT1kvQWNTM0FrSDBXalVlTXFPbEFrQ0EzU2FHODl4b3BxU3dJSkJ6?=
 =?utf-8?B?NnlpTGtVZlI2VE41MitadUI0OWo3RUd5VzdxVVBuNndud1NPRHpITW9wL0Jj?=
 =?utf-8?B?M2VjREI2ZW82SkdwdnBIT2Uzby9sZnNRMDNsQ3hsaXI4TC9JaUc3andNWWlk?=
 =?utf-8?B?NE1WODM5cjd0T0ozdzBTbVJsSzdRZFFxM3d0d2NLVGljdUZWUjV5bHBSUjB2?=
 =?utf-8?B?aHR1SmdLT0FVQ0tpNUp6QXJUTkVyZ1BCbmZqcWNVQmVGZTdQeFErSVE1b3dV?=
 =?utf-8?B?MUZMSDVBcGR4U09qSmI2ZGZpaUQxQldhajBiZDd1Tzg4b1ZJRC9xUnJpY2tm?=
 =?utf-8?B?MkFQcU9GaDY1N2ZCazRuaU85YkNqVFk4andYMU1GZ2FvdFg0MGRjVFV1amIz?=
 =?utf-8?Q?/31Kg3uJ9VDc3o7s=3D?=
X-Exchange-RoutingPolicyChecked: HsjweifO4JhdsQtqoO+9fh2cYBx9H+N5rRZ0xR7t635G71T2dXCt2c9v84dA8l1mv1zGQHl5aCVHD9QI8OrtbSkPSKoDseeqYFotA0W6kU9LaY8XKgw901VqIqRBGpZt5xSYeQhlmzDroZd843m1ZMZFBxUVvuUl5WdGbqlvOePfDGgLXnJwfjdBy70IeWR+fNv9wyaxiCQbJKj7r6gmTTCGNnvWruUy+qAi3wcc58tQi3Zd9pIuzYCkVmBaCPPpLx3OkrXwhaEV88KcXbxKIKiA5XexZvka8Fb4INMyq1/1spojnzPhGNkGUsPSHBj6nT4otlM2y/Pt7t7eAJtN1g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 83249604-a2d7-458c-98ed-08defcc2cd86
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:51:13.7002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18/7xDPHc/akvTurMrn/ugv0h1T3Mbt0+DfjUX6VSIOKEkE3L5ehfvMdmkEOnMvpiaEsnSYTDPcMqZRA+v3T30VyByOLQSrZD6fFgqNYyWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> resctrl currently assumes all monitor events are enabled before any domain
> is created, because per-domain state is allocated by the architecture's CPU
> hotplug callbacks. There is no way to disable an event once registered.
> 
> AET events are enumerated by the INTEL_PMT_TELEMETRY driver. To allow that
> driver to be a loadable module, resctrl must tolerate AET events appearing
> and disappearing, which requires the ability to disable an event when the
> driver is unloaded.
> 
> Add resctrl_disable_mon_event(). The architecture owns domain lifetime
> and knows mount state, so it is responsible for calling this only while
> resctrl is unmounted and for cleaning up any per-domain state. Document
> those requirements in the kerneldoc since they are not enforced in code.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
