Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3381A524C
	for <patches@lists.linux.dev>; Tue,  1 Apr 2025 00:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743466413; cv=fail; b=GFZotxucjBGRLln5KOGhydtAAZETf+739oVD15tPXujOfwqMFsduBrqU2z/OgIG3HWB56si+VXFA6Mft5EnWMddxJQNpxJEocQhKrQYkwdKAL/94yTmdNMqCCrAHC6QOhXq7Pfdit2Eecm6Pmgh8YBPG7hGY9gV7PAj3g1qFlSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743466413; c=relaxed/simple;
	bh=xIahfU2V1nNa7h7EFxpLsW3yzP2fnyVrB39mRWXZ3Ko=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VwzAF76rWc2/PjiG+/gurIc0twaT3Y6aNJExC3/fv79XP/+qKsbLc5zS+euZSQVyR/qzScgVUBapfcGNu6pSUuH+vmhcGfDQT96H41QoCU6gsEqmYPMRt9xQNfrGQxn1rN1pEePQ07bEy8w9ya11egcPeT46PRSZmb1tocxxb7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UvLrTRuA; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UvLrTRuA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743466412; x=1775002412;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xIahfU2V1nNa7h7EFxpLsW3yzP2fnyVrB39mRWXZ3Ko=;
  b=UvLrTRuAenLZ7dNfO2/2ffY3JegP+GbxKr4L2KqUsOVPcQl/Rjmo7DAf
   kSsh242zDcz453NAOs4VQxnretNQ/fuhWP2LLh7QpW2197IYx5SuqD9eU
   MHqEvDZZvxCsQyfB5f0POKbYbR/8UjGKQb8PMxDTym82l3F2g+PgvSNIX
   Hemxwqm5kA08EAFIKbhZ8ngYII5aci4mR+9xmHNGK4QXEsTUNA4QhBd0I
   z2SrWrKP+HGuuuZiJjYK8Rv3dp6oPCPFrXlhkIo5Zd/VaskFYk74ST5aZ
   IFeo6rqjENPvIBzm1NRcsAIIMl0c12nVtGJi5BvzOZwoAIxv63JAQNylT
   Q==;
X-CSE-ConnectionGUID: Gf1ZtTWxSF+HYcvOzWt+5w==
X-CSE-MsgGUID: Vgj/feOMTA2r2Y8cHDHzJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="44947604"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="44947604"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 17:13:31 -0700
X-CSE-ConnectionGUID: VBN39atARw6fRfgkUHzJ6Q==
X-CSE-MsgGUID: 5RUwiZKLSYyO+1HlWFsukg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="157141933"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 17:13:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 17:13:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 17:13:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 17:13:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LogWYwKsrqF4zr9AvzePX4hyDpNu6Y86+ZD0qNReHcLZOsSC/opWpSz6Egq76Esr0J1r11IKawin0rMEGgZo4Jt7VsMlP/GMq7J1s7CywGlXtD1cRrcKfNzikMW2CfKv6s23HUJoVCg+Cm9R8KUExOYtQrwOHQfQPrIN4Vmh/DPUzQ1b9bvrBHUTBtXKoyqFlHF4G8kTj1m4dDnr7V9skvoMMfpXp5mfzdfj85TE/HG35irQpGZlrpaSI/iYMvg0pCGMCl/4ZIcYB7asDqnB5X2GvBYa/G6lQ2atLorfkJ90oQ04WJ/bq8xfuTv+uq3hyQj3VCSOeirDD/ZvKZepYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgM8ySRfgFv6L4zGxeqRMlqWEOwFrEw7Gr9xVn3PMGM=;
 b=Zg3imMwv79yXd/EK34wUDwZomEC622KQLyCRGnOlpIFRynAecedyRCZVHYG1kLQgYTDVZ13SuOcOmsjDakiD4KquckMZhsENhQscdnE9mRqdwGTbMD48z8DEEtZrYKaNThsggabpmpZx03kwaqcVXxB8xmk8JCNtkB7ioLGWvy4jSzOCdhyBRlFhv5julNI/Meeox8JehOIbJ7Dhzo4dQ/p5DynOTPXR0zqEtd0p1c8cOHH4x0L+VV/v3eNkRIF3ZWSG6DtFiqzn/+3FlnGv3p10ILcT/KGG4dqvU1aI8o4OR/+2VQq94kOPbqahG07NMmmF/hzCmRZJKt+kss0QSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7503.namprd11.prod.outlook.com (2603:10b6:a03:4cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 00:13:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 00:13:28 +0000
Message-ID: <ff5f3d28-c67b-4b2f-9972-8b12a3a64a29@intel.com>
Date: Mon, 31 Mar 2025 17:13:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/16] x86/resctrl: Add detailed descriptions for
 Clearwater Forest events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-10-tony.luck@intel.com>
 <03f00372-e863-4405-a077-86173e39368c@intel.com>
 <Z-sSC48XsxFrzlVY@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Z-sSC48XsxFrzlVY@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:907:1::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7503:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fd351f-44ba-4c2c-2092-08dd70b20755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U2FKc0JLcVhNMjRLaTRGMVZQQWZUSlJpV2ZqZVRYMjZUbzhvWklHNXNJcjJp?=
 =?utf-8?B?bzV2YzNYb1Z0UkhacWNwb2lqN1F4dEY5WDQyVGV1ZytCV1d4RlNaYlpGYjJl?=
 =?utf-8?B?UDZ3NlMveHFkUGE3WHcvZjVmTlQwZGgwVXpPSWp1VCs2ODdqQnl4dmtJOGFy?=
 =?utf-8?B?ZGFDTUlmVG1BcnFucWM5WnlGNmJETFBrNWxZY3NMemtGUjlUK09OeFd3YVJ0?=
 =?utf-8?B?eDdFYTRLZ050UFVtZ2Z3Q0FOSWY4S0w0MVVhYWV0ZmVQTjVMdVR6RnpYVHZC?=
 =?utf-8?B?bkdMd0MrUG1XNFhhVzdHYm9PMDZaejgxSXRPeXZkdHVrZURta0FJL0ZaRUNx?=
 =?utf-8?B?TERxUzBpYVQzemNzL2dPbGluT05nUGJjOUN2MFpLUkY4NVJjdnVqTXgyU1Jo?=
 =?utf-8?B?eWUvRmI1YUViNUpPVTVITmV1eFp3SGJVdHpzNFBNY0o5cWN4SGRianljSG5M?=
 =?utf-8?B?bUszQUc3cmRKMDJhTGhKcnFKUmNVL01VRTZUbnBmMlF3eVNLbU1FSVVCWGE5?=
 =?utf-8?B?VUg1Wk5Lb1pqQ2pXUmRqbFZlL0dmdGNhZElFY2doanlmYytya0JUYTcxQTEv?=
 =?utf-8?B?K0cyVnRDTmpTR1NKb0RWK1EwdWlmR0oxYzM1a3VjMHBDNEpwdXRTbThrc0h2?=
 =?utf-8?B?cmdhOE1McmliOGhWMXdVSi9TM0wwdzRCYmg3TXhNSzViSGJkNXVEckVDUUJy?=
 =?utf-8?B?RHZObi9MVGN0d3lyQW1BY0J3THBSN3BsYlJ4QzlIVkdjdm9neVZoSEFibXFS?=
 =?utf-8?B?aDgvbVhFa1RvVldtc1FuaGt2ZGg2czFwZkpGSEdieFAxbVY1Q3lZR0hWZFJB?=
 =?utf-8?B?TklaUDJtcFJ0ODE0WUVob1ZUSmN1TGlCbm5adDZMNHpNd2hWZmRXb3E3UEJ6?=
 =?utf-8?B?ZzBvemRMSVlkUXBRcExrTWlVdUlCcUsrZGdPMEtoSHZqeU1lN1lRRWV2YTZI?=
 =?utf-8?B?STFULy9DazZOclJqZ3ZlT08ySjZyZEU2TEE3azkwWVBqU0ZHL0RHTzBHV2xQ?=
 =?utf-8?B?MTZpOUZEYnR3bUJtYS9sdVVUcmsyZ2RXSzAreEZybXB0WEhrWWJ4dHhkRndw?=
 =?utf-8?B?Qi9IOTBlaXdaQlVTVnFIc0FldUxySzh5VGMybTNhYkMvTFFZaWVKaXBBc09i?=
 =?utf-8?B?TDlVZGRqOXpLMmorbDlBZEE5UlpTS2VrK280ZE1WQ1dNWjRQRFhSNWpIdVdO?=
 =?utf-8?B?cGZKTzV3OUF0eFpTa0N2LytXdm9HbEVuNXZlYjRWTWM4bFJXa1FVVHZITFdV?=
 =?utf-8?B?MWFIajg5RE9sakJFM0pDdHFOYW10YzMxV0ZSajdWbWl2c1lxQXBnR2tObjNE?=
 =?utf-8?B?blN5dUc3MEh6RmNqKzJjM1dubkl2NjhGTG11N0N6RE5zdjBKQlc5ODhKUjQ3?=
 =?utf-8?B?am9SaDBJL0xZb0pOQ3RscVZ4M2FTMXNmYVE5M2lCTkdSZVppUnNsMmtSdUhi?=
 =?utf-8?B?dnorVGVKQ1ZpTWpBeWZlS1JVeFM2MjFQS2dBZ21YcWJoUy9QdW1kc0s1UmVz?=
 =?utf-8?B?bHp3NDA4OW9TeXJIRXJjQjBycUdFbDYyU3JCYll0NjFsWTZlNFBmbEZac1ZV?=
 =?utf-8?B?R3lwKzhiNUFYK295cjdaYTJMQUpaL2V0ek4vVGZPZGxneTk2MEZ2SCtDdnhu?=
 =?utf-8?B?Z1lqdzBSU3NibWl3a2x0OE1jbHJIVXJLUGUwUFhyKzlQd2lVWjJTQ3BUcE9j?=
 =?utf-8?B?Umg1c0VWZ1pRRmRaNlNvaGg2VUY2eXVPVmdDNU1nRmtCQ1BLYkRGZ3RuSFZo?=
 =?utf-8?B?dWdGUk1VUDlDRWFtMy91RWJRRHdRa0IvMjN1QzU4ODk5anc3eGIxb21ZLzBC?=
 =?utf-8?B?Ty81UzVkTFBhYjM0ZEFFRHVFV2JoRFd0Vm5QQitmTkVrZ3A5NDVDaHZMaDdQ?=
 =?utf-8?Q?gW9vMP21pdkNA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzlYVnZjZEVWZzNQUDY2OFJtRC9IUkY5M0lIMSswM1NFWWh3NTgwbldicXBh?=
 =?utf-8?B?T29BWS9lYjlSYmhBZ291bys2ZHgrdTBlZEYvcDhxaEpxaEpxTWlpd3Q1b0dS?=
 =?utf-8?B?a1QwSG10UGxhK24venY2dnZBKzEwc29CQjk5WWFkNWRNdWhCaTV5aTMwc09s?=
 =?utf-8?B?M0JEL0VEM0FueS9zR0VXM242MzdNWjR2UWNBZ0VURklxK3U3cGgyaVdDRnBS?=
 =?utf-8?B?LzhVRW9QVlhOWnd6NC9tMGZWam0yRTRNZ2t2RGZncTB3SjBHV1ZzR2xoRnV2?=
 =?utf-8?B?c285Y2Vodm9EdWNZY2QxOUNRRmMxNlFSOU9PZjJDVUEra1YxSDhBTHFESXJI?=
 =?utf-8?B?Sy9ub00zc0NrcEp6RW8wWXJGWmdqeW9VaktqMk5TYkNmL0trL3ZBV3ovVTFm?=
 =?utf-8?B?aWordnRFZ3daVVZDeVcxQmJkVzgwVlptSWRLL2t5N0UwOHpmSlR0SXhaK1hl?=
 =?utf-8?B?MWhyczZMZVpJVlBzalFUUHZNOVA5ZXJ3RGI5RDd5NjFMdXQzeE11MzI5aHRm?=
 =?utf-8?B?cUx4R1JmdXBvOHNrdHQ2enNSQnpqditHSklVWHNRZCszWFRqY1lJd0ppbEl2?=
 =?utf-8?B?YzJPTlgzNlBKMU1vbllvSG02VUZXRjloZVJkR0FzTDNEL1lPMnFLUTNQYk9B?=
 =?utf-8?B?ZkVVa0VZSnV5a2RUV25WS3pvekdwU3RlSVBiOUVjOUV6Ykg2NjVoY2FZUlFT?=
 =?utf-8?B?U010RUIrZUduZmdkTjA2RGlLVGdSYzJZUU1VS2pwa1NTSUNtenVacHpEdUdz?=
 =?utf-8?B?Z3dsTkMrRUZqbWhRVnlhMDNac3JjYzZwQ0F5SGpoT2ZhWGpHQzVMVGFQUnIr?=
 =?utf-8?B?Tmg5cGMzUWNQeEQvM0ROWVVpSi8vb3JLbFRVampBelNJZ3Fac0NjV0tPL2c2?=
 =?utf-8?B?STdWWFN3aWFidVViUUFteVZGQ0ZnQ0dnQmpLbUFTRWs2aVRZbzA2cVUzVk9i?=
 =?utf-8?B?UEtld1V4UElxZXdFOTMvdjBVdVpVS1FNL2FOZ0JNWS9KWmdNT05mTE9NaCtx?=
 =?utf-8?B?SEs4ZUF5aE5CY01oTmVCTW5LVXNuV1dRVnRPMkxabkMzaXZ0QzNjMkExZnhj?=
 =?utf-8?B?RmV0azRmMXlqL3NzK3RvejJxTU5qTGRLbVVCbS9rbzBkUWs4NHprd1dqNFRG?=
 =?utf-8?B?cnVJNFdtbldLYWhFSHB3TlowZ0FxVUhXMTU1dmZlbEUyWTRuNTVyZVpiNkRm?=
 =?utf-8?B?ekZpaFJVSmFDcTg4WHNwK1E2TjNDUy9wVWl0Y0c5MmQ3TDhORkYvaGVCd1VQ?=
 =?utf-8?B?T2E0WFdjNmRuaFJzZExDTWQ2cmtUb2hZbWNISlBvWUFYUStRZ1pkeHRVeW5S?=
 =?utf-8?B?NXhSVFdSa3VwUER1MGlmNHpkclNQY2gxZ2pEQVNNRU9BdnJJN2VQanZUcDNB?=
 =?utf-8?B?TitMN3pGZnZWUURCYTRmWm8xdmtUUTJhNEN2UWxTOE81cWZVZk5QeGJqdTYv?=
 =?utf-8?B?Q3M2djRwUno1OUxHM1pNQUtXR0hoelQ1NTYwQUtqVlhSOHBrMTZrTXVaeVMy?=
 =?utf-8?B?cXZSa21Hc2tnWERXUVRSMUMvcE9vYzczeFpWcGZJTTdMa2NpdHgwRklkSlVo?=
 =?utf-8?B?SlJsTlVOUjc3WkpDWkphL0w0R3JKNEZ4cUpab1pFTzB0L0VFT0gyc2lXQUFj?=
 =?utf-8?B?VmVpbXZJT213enU4dUpoRmxxb0Q1VGVaNmNwL2tTdnJoMWZ0bTA0SWpUWWNL?=
 =?utf-8?B?YUFwVVV4WXF0SlNJVGFkaUl2cHRSNXdCSVFZS1pnNWt6VUZFT2pNRmVPYVMx?=
 =?utf-8?B?UUg2ZVN2c0doYlZxbWlsRW1iOTBMSWE4cVp6SDRWMi9hME1XZU9UVVZyejg3?=
 =?utf-8?B?aUUzUnVIU1VpclRnbkNaZGZDdWZMUGU4VVA1UnR1TXc1TzFtdkh5cStIYjdJ?=
 =?utf-8?B?Ymw1TVpaN1AyRGJsVjJuMXJJRkczZk16bXBxb05PVHJ2eGlLb1VGME1Waith?=
 =?utf-8?B?aFpqeFFaTTlOQWx2TXBXRStVNHJ4eklVRklEdFQ0bWcvLzc5TGVpQUdKam9x?=
 =?utf-8?B?STJ6Q0xuaUFxaGVzWTF0c1JCQ1NpelUxTlUvL2EwVlluWkZtaFZ0UHJyU3N0?=
 =?utf-8?B?Z3lZT3BtcHgzbDl6WEV6dG5mVld0Y1dSdW4xS01vR2oyTm44dW04Y2RTaVo4?=
 =?utf-8?B?RFMwUDRpbnBBcHBCVlpWcG9FM0tFSW5KUGZHRi91ZEpFQUUxVnVTYWRrVHFo?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fd351f-44ba-4c2c-2092-08dd70b20755
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 00:13:28.7373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YS14/tdOdSa9ya717nZriJKikGooeuCXHZRQPNm5SifZSdRvaGDZtmS6k/sioMV+oDFtekeucqH9QxjHUa1XOT3MPiTDine2Cky9BbrRqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7503
X-OriginatorOrg: intel.com

Hi Tony,

On 3/31/25 3:07 PM, Luck, Tony wrote:
> On Mon, Mar 31, 2025 at 09:21:11AM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 3/21/25 4:15 PM, Tony Luck wrote:
>>> There are two event groups one for energy reporting and another
>>> for "perf" events.
>>>
>>> See the XML description files in https://github.com/intel/Intel-PMT
>>> in the xml/CWF/OOBMSM/{RMID-ENERGY,RMID-PERF}/ for the detailed
>>> descriptions that were used to derive these descriptions.
>>
>> It is unexpected to me that this is made model specific while the
>> implementation is built around a guid. What will happen when
>> a new system using the same event layout arrives? Will the url
>> above be duplicated for this new system's acronym and contain
>> duplicate data? How will the resctrl support change? If I understand
>> correctly resctrl will not need to be changed but instead the "CWF"
>> events will just automatically be used for this new hypothetical
>> system? This makes me think that this should not be so CWF specific.
> 
> I was told that we might expect to see new guid values to describe
> different event register layouts for the same CPU model. The event
> aggregators are all firmware driven. So a BIOS update could make changes.

Sounds like this supports my point. Naming these data structures based on
the CPU would create naming challenges when this scenario arrives, no?

> 
> So I've left open the option to add additional structure defintions for
> Clearwater Forest with some future firmware update.

Why not use the guid as part of the naming to make clear that CPU model
does not dictate the layout?


> 
> If a future processor uses the exact same layout with the same guid value,
> then no Linux update would be needed. We'd just have the slight oddity
> that a structure named "cwf_*" would match and be used.
> 
> Next system to implement these telemetry events has a very different
> list of supported events.
>

Reinette

