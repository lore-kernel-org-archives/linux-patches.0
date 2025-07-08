Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF6B239E66
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752007964; cv=fail; b=EHz7rW1kw9sBXoPZ/UaQeCDe1ZNjzr2T5RhRdi5be6iMBGMxry0uZNqbixh3IdZeExzbbGKKIIticXd0hI8ufZKRsFuz4pQB+0RN5fjZ6dOjRZSb9AG+bUcvll8RqKqUh1W4O6mzRqwBQR4U/otkA84/3Rdg5IMbPqFy1+klquw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752007964; c=relaxed/simple;
	bh=2ntsAGaB0uySY853PGc4UUgkbvaFBhwufrqAxSsmVoY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n8VaLezA8QJl1sV/0RWcZ9b17zwq74+0TEmi/cX9EbO14eI9RrFbrMCUTgxwfyWlDlaphz5D00i/FGpyUpBSfYorO4XnWP2y+cMnsbDe7NXeQ/yZJXpMFEGZewSeZ4aIHNKUXTketjAw1FuXzBzCBWoFD1NlnB7/jZTVugwB+PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l1xiLeZe; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l1xiLeZe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752007963; x=1783543963;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2ntsAGaB0uySY853PGc4UUgkbvaFBhwufrqAxSsmVoY=;
  b=l1xiLeZexYYF517MPWVVzTdoE3mZ7YR21vMczXK1HGsXgipAh2+TTRMj
   +gw0mDVWMzdjLXIXHHzKJzgtBTZT5Yv3oLZU2XB8OOQkCjSR0gqq67iNj
   Eh098ZBC7y7ZfE5Rd7XfSup8mOXXnvjf4yf7tHgk+QM4JWFV1Tb1QE7Ey
   zTvqJhSErDq4bAOo2E9rzDA/IzbuqscMw/dW7Ro323jDaE0dQaBZrbhNU
   /GYkqNu1G6kLqYwO9uJ4qhrRt5uNP6wuBd0ERueIl3Wf0etN2tbZO8oog
   E5sw8VjDLc8EMac91IjSQCzpmv6JNurki5h7iEa704qTufIYOsMof6sY6
   Q==;
X-CSE-ConnectionGUID: b51GvikoTfa5qcRhUzINyQ==
X-CSE-MsgGUID: YMWNWg4CQGuiyAp0kOf6vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71842250"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="71842250"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:52:42 -0700
X-CSE-ConnectionGUID: eAszpr5oQrGc9Z06gC/f1A==
X-CSE-MsgGUID: n6ij1XEmQgqHVhwUG1dARw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155006562"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 13:52:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:52:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 13:52:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.63)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 13:52:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7ypTZ3XALouVMNdvMvRa+XaZqfD60jF11E0MuAbelKzLqQqiMkUIPE47zZ10nhiMPqv8/4agU90DztwejoRycXRdYJr4yVm3RdPrNBHGo5oiCBDtHV0NWNkBmOHReOQZgZNAtM68NsyO073CZI0jVqT8UCfzcS9ORL6K7/Y+1DnOW05FJGAjCOQovox6xbKUm3hbYwqlEtre4cYCF3af6Ik2SFNaMNtDoNVf6yd/xxKNdnpDptoEUqYq6jO/RWRi0uj6kuBQQfsD8Vd19tjywcloZOi2hxKESgmDymZkF0EdB/5oQDfo4OW42LZcTWZhN23avX2RXRG5Ap+8M9x8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ik8eq2qcimf45S7hINqBIGc1bwwcOhhU8kRo/G9asW8=;
 b=haC0NSpQLzUk8Wbn6rML43uiBM6grBXn/aFysAft+h0Ms95T5x/gKnwRBCJKFPYzAbW0HYvNJlp38WwMF8bjxRhXcHTHVbR4MYnDr8+qET+xanm3oiTG2gu1HJWtx/cLKfGnKH39WzxfOrt9xT7WstZ3PSBNFhL4IFN8KIsYYrXGHh8MKmXKqso5/LV3tC1fcSDAQwjTJLDAqKt675YtvauqSmxNq/zIPzwOygc9IqRrcKoF6FyVJIrwofQlhe9Vh79LWKBoRa0Bs/3tslf/XfUY0pZJV4sC+ezFEADjtP4FvIw8Sn98pZtnHaCYGaamv6w397V4JoOgtM7Ba0ZQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8223.namprd11.prod.outlook.com (2603:10b6:208:450::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Tue, 8 Jul
 2025 20:52:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 20:52:38 +0000
Message-ID: <302d82c9-8e2d-43ae-a6c1-e95ede7dcd04@intel.com>
Date: Tue, 8 Jul 2025 13:52:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:303:b4::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: f63dc2ea-550c-4fee-e773-08ddbe615fba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R3p0c3o5T1JQd0JEK1N6Slh3RTdZdjU5cnUrdnd1UE9zQVNWRTVIYjFzam94?=
 =?utf-8?B?TmJpakNvUDV1NmJXWE5XSzZNRVFlbktPNGg3VHFCRWlVN3FCS0o1bnJVc3Bp?=
 =?utf-8?B?UHdQekFZZy9HZHM1a1lrcUNhYWNIK0JZc0FVVml1RDNuNU5qYnZvZ1JVczVq?=
 =?utf-8?B?dk13dU5SWjV3MVRFekNmbVNOOTh2SWNDQnNpS3JsZE13ZVM1SGFqeFJGejNm?=
 =?utf-8?B?b3A4TytjWWRTVnpTakhSWTVWa1FLV29DbWRBdUwyUzJRbDBkbDNpR3BuM1ps?=
 =?utf-8?B?d0FNMnc3a0tOd2dmekt5Tmk1YWhoUGZDSkxZVUswMjlhTC9yUTVEbnkrVWRt?=
 =?utf-8?B?ak1ScDN5YVBWQm5mMy9qMGRBUGRLNENCYTJ3SXhJSTBtWUtpWERDMWwvaVIw?=
 =?utf-8?B?aU1nV0lCbU1BbXVZYlI3M1l4L2RGbTFIbk16Q1FTZkp2Tm05OXgzc01lU0Mr?=
 =?utf-8?B?UkhoNXZpcGpHTWY2bHByYXBCTTlaRXcvNnlIeHRsUWZQWFJ1aU1mVkJDSTdO?=
 =?utf-8?B?L2lCQy9wL2RVWG41aC81bm94cDQwU3ErYWVrMFg3Mkc4WWJsY1lENGxNalJZ?=
 =?utf-8?B?TGdYQzZoeTNvbUpsSm96MjkwcENaTENNS3FPcW92dlJCSTArSkp2OGluSkJD?=
 =?utf-8?B?aXdNbDNEdEF0akdLRGtoYnFEWkUwcnU5cStZU2Yxc05ZVlBwcVZjQU9MeWl5?=
 =?utf-8?B?dERvRml5NVduSThZMmxTRExiZFExbW9BWER0QW5sMFlWS2VWaGV3VVpZWVQ1?=
 =?utf-8?B?eFRMS3pKNUs4d1hXTVJ0d1FORTVEQXpXWTYvQnJxZFpIUkZzQmZleXdwVlRx?=
 =?utf-8?B?WHJjQUQzc2J5R1hnN0ljbTR4eUdWYnVTNDU1RDRYKzJJUXJFbUhMakFMNnN3?=
 =?utf-8?B?U1l3U0ZiZlA3aEZhckNVcldtSWdYZkRBOFZzcysrMGpDWVoxWDJYY3NmSW03?=
 =?utf-8?B?aThMcklCNnlRRVRCNkhVbVVzYVhRVSs5TmtxcXF6ZTlGTUxxZUIwWTFuWXl1?=
 =?utf-8?B?RER2S1duM2p0b1pHQjlKaGo5VXBiVDg3cFBydUhONk15cDJlc0dLTTdlaExZ?=
 =?utf-8?B?bW5ma1JkejlFdXR3alJNeTdTekk0WlB0ODZUZlZwVWFHclRYUFFWaDBrRkJl?=
 =?utf-8?B?alp6VmE5M09VSCtjWEVoa2Nqd0g5TGpxRHkwaWI2VFg1U2RMS1JPUGVFWWFy?=
 =?utf-8?B?L0Z0WmRqYlppOVNtMHhpZjRBWUVwWW05UUV0T1dYbkF4R2RGcTNWUk9yeGxU?=
 =?utf-8?B?VXpybUxaRElEYS9NM1dBekRUeGFSUjE3eUhPbzA5T3ZSbmhVQ2NSRmtYU09J?=
 =?utf-8?B?WG1sV1pkVjZxQXplcVp5N2FXbmlUakYybjFybk4xZUpXb0lHRjlrM3ZXTURv?=
 =?utf-8?B?OUUxaTFJeUhicGVJQ3V1VVhXVkY5c0U2UlU3UkRIMGdYblJSTW1FaWZOZkpa?=
 =?utf-8?B?VVJycXlqb2c4NHJxblVQUi9saU1MT1BEQWNaK2h1UmhtMFRGTjg0bk1FbUNo?=
 =?utf-8?B?MVhrTE15Q0UzN091YWZZMEhQWlVuWFBvam40S3pEOERqME1KenNkTWxCSmVO?=
 =?utf-8?B?Zy9meGJtMHlWd0Zwek1OVmlQM3RFZ1VQSDlUd0JHdWlHSU9sNmNCUDBCMUxQ?=
 =?utf-8?B?UkU4SXMxOWFmTks2VWJrdWpXUnErdlZLcGwweVZBMUdJMkJkNno1SzMweHlh?=
 =?utf-8?B?aWpIUWMrNU5Cb0JSUlIvenRuN3M2dkNKb1hwd05pWDc4aXJLbngzUDhQRkVp?=
 =?utf-8?B?SE5STTNrbGZBNnUrQlNGK2poQ1lGL3RQb2QvWmR5V1pTdlF2WFFkcXo1bEl6?=
 =?utf-8?B?RU1HdXpQQVN4QkJQZlJkbDJKdTBUSk4yY2ZNTEplQWY2cVdLZHBLbVlVY2sx?=
 =?utf-8?B?dFhUamlQUDhGNi9qU0paVk5BTnRNOGRjV29BUDFEMVdPdXBlWWg5WHJINGRJ?=
 =?utf-8?B?U0FWbEhUWCs1TXF2NUxCYnk5T2xvL0daeENWOXU4L0VuRFBLK0tMd1AxWm1F?=
 =?utf-8?B?bEFGKzNuRzJnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QSs3b2llVnRlTU5wY3JFTFZhR2RXeVJBaHZ2QzFUTWdqZFFtNm91UDloL2ky?=
 =?utf-8?B?aTcvWHRrZXZJbXNhVWw4QUtycDNIdGZjK0w2TjBxWVFybmVTTGdoQVlhRlRP?=
 =?utf-8?B?MXlNWHFDS2kzcEswRG1IcHJTdm9iZWMxODJscWtxdE5zQmxUVDNidU1XaWVZ?=
 =?utf-8?B?ejNKUlh3aDExQTVhUXlHZWM3RWpUWGpma3BhTFl3Zk56cndJcElUaURIOUVI?=
 =?utf-8?B?Y1NCdDgrSndJa3dPVDRBa3V3TWEzekFtSllwQlRxeTBYbWdBbWNmam1PNW1m?=
 =?utf-8?B?WmUvSVB5blhUQlVFWTdiSk9oSmVtRThpdTV1bXo4TzlhV3V2d09jYlRtbXVZ?=
 =?utf-8?B?RlFHRnd4YVdVL3Ywd0lEUnlYcTBsVDliUVJKcjRzTjRyMjJqN0hIaytEQWVa?=
 =?utf-8?B?V29BOCsrM3F3VVBTbWg0WnFENlhXaUtGZE9aWnVQMFMwTTVBUmtidUdRWWl5?=
 =?utf-8?B?dnlLN1piOWdTa2g2Vk0xWHo4Rm8rZncwQUFmNncyQURacUJSTzVnSVRGblVo?=
 =?utf-8?B?ejdMOTAzRGhZdGpwSGZzcGMzT3BtTW8xMTlCSzhMcjhLaFdyT3VreGRSamR4?=
 =?utf-8?B?bHFCNGlkN1Z0cEFxTWVES2V0MjZ0Z1lYSXRTKzV4WUp6ai9vTk1WcmdPUWhl?=
 =?utf-8?B?aXdBbDBFOTd3QU5jb1A2VEVmbHRPa3RCSnNxbllMVEFaVklyU2hvMkIzYjBH?=
 =?utf-8?B?ZDFIV2twbkYwcUFVQ2I2T09YZ2NnTDk1cGRBaWtuUFZQZm5GUU5FemZsUSs5?=
 =?utf-8?B?MU42N29aRWFDK1pPOUxobXJLTkxNUEc4SDVuaFpsR3hlOEM3UGZKRHloZVBj?=
 =?utf-8?B?OWVOMXNJOXQvZ0RvRnZEWU5NajJYMmN1Ni8vbUkwNEo0WDRPUDBUdkRHOHBQ?=
 =?utf-8?B?M25leFVjNFBISWxuSXNxaktldXVmcmQ5d2haWjM4RExvb3RJMnozdU0vMmcv?=
 =?utf-8?B?NjZELzRFc1VGNlZpWTE4N1JKWUxYYXR3OTdZZHpQQ2dQV25qd0dnWGFZRzJY?=
 =?utf-8?B?cnJaaXpPT2FsNkJVeGFDa1U3TytOV1FGaWQ0cEZld0Fpdml2bDdnM2s2WTBN?=
 =?utf-8?B?Y0RLQ0svSjdDTkNiaGpXbTd0bXF4ZHlYeENodURGS0xmcllyWXhIUTV2QUlO?=
 =?utf-8?B?YTJCRkdrVVQvdEtVZC9lV3R1RWNza2hkRmVqMEVTdFEzZTMzNWZtRU5UZmpG?=
 =?utf-8?B?MWhoc1JCdDRRTzVHbTJVRTlvWmF6Rk1HMEhpMGR1ZXJuMzNmODdoaFZyNHc1?=
 =?utf-8?B?RlNOK09peDNsUFk4eDRZNmM1SGVMTW9SUVFoVHpoSnRyWlhNdXBTaEMxdEFX?=
 =?utf-8?B?Q0hJNTBMZ082aCtxdUt3djBXOGY3eXJ4ejhmMFBGekhodFlRY2NmUGgzZmFn?=
 =?utf-8?B?b3Y5YnA0Tit5U0hqYmVwZzRDbDVzNXFxRXQ2REx2Wm9uUElSSGZTcWoxUkx0?=
 =?utf-8?B?aXduN1pvbWdWQVdtQzByMzZERUs4a1VSTGJJRWFTaFFRV0xIUjdsRmEvSXo2?=
 =?utf-8?B?T1NjSDlBR3FyUXpJUGtyNU44emhwR2JKdkJYRmRoQjdtcjBrYy9acGw0am4x?=
 =?utf-8?B?bEdVM0tra0p1bXNtNEx2eC9lNmg5R01kVlF0eDM1WFluUnhDcjgrc3RpeXVq?=
 =?utf-8?B?WkJjaktEYTRsd3l0dVJQbmpvRmpVdzZQeEpDRUt5OEFhSG1OanVtSGJ6aHlQ?=
 =?utf-8?B?QnVkZXJiWmNUSldaN0M2ZjVmdngwVm5STlA1RDBlZUdnbHJQM29wQnd4Sjg1?=
 =?utf-8?B?Qm92SlhhaFVORGVSUjR0Zm8rbnR3WVpMalpHR0NHWmV1Q3BwVlo4RTBaUUd3?=
 =?utf-8?B?dVNIRGpQYlZlUzFSSVNadTFtcDVmMWFtRUZWcWpiTGlpMXRaS1JGdWJLK0dF?=
 =?utf-8?B?aTlyeXJvV1AzMjMycFNmdVBQYU91UTN1N09zOVRuM1lzaXQ0YzF4SVVnL25p?=
 =?utf-8?B?NUltTzF6dkRmM2N5V3BULzE3SUZCT2pncHFubHNmWlZwUDJ0VVhuYWdpM1da?=
 =?utf-8?B?cncrTkxocDRuZElFN0JiUE9HN1lYdDJuTU4zamtIVHdCa3Z4WVpqdE9WSURx?=
 =?utf-8?B?d2NrbGoxclNSOHhkdGd5TFZHSXdXRUx5dG5TUHkya3lrbVVmcWNhVHpQVjhC?=
 =?utf-8?B?czVJSExoSWJIOVFEVlpiaE5PQU9CQWVrMTdXLytsYk9VM25VYnc1bDJ0aG1B?=
 =?utf-8?B?b3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f63dc2ea-550c-4fee-e773-08ddbe615fba
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 20:52:38.5437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWYrw1mz74feImBGm5OhQmUZnWSVrL0WOc2Ihhouh+WfTtpofeyc9ZlygAXYtjf+TAdr7DZ0bKRGfG3+yuR87pFIWCP1QF+SvQiXYKDS0co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8223
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> There are currently only three monitor events, all associated with
> the RDT_RESOURCE_L3 resource. Growing support for additional events
> will be easier with some restructuring to have a single point in
> file system code where all attributes of all events are defined.
> 
> Place all event descriptions into an array mon_event_all[]. Doing
> this has the beneficial side effect of removing the need for
> rdt_resource::evt_list.
> 
> Add resctrl_event_id::QOS_FIRST_EVENT for a lower bound on range
> checks for event ids and as the starting index to scan mon_event_all[].
> 
> Drop the code that builds evt_list and change the two places where
> the list is scanned to scan mon_event_all[] instead using a new
> helper macro for_each_mon_event().
> 
> Architecture code now informs file system code which events are
> available with resctrl_enable_mon_event().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h            |  4 +-
>  include/linux/resctrl_types.h      | 12 ++++--
>  fs/resctrl/internal.h              | 13 ++++--
>  arch/x86/kernel/cpu/resctrl/core.c | 12 ++++--
>  fs/resctrl/monitor.c               | 63 +++++++++++++++---------------
>  fs/resctrl/rdtgroup.c              | 11 +++---
>  6 files changed, 66 insertions(+), 49 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 6fb4894b8cfd..2944042bd84c 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -269,7 +269,6 @@ enum resctrl_schema_fmt {
>   * @mon_domains:	RCU list of all monitor domains for this resource
>   * @name:		Name to use in "schemata" file.
>   * @schema_fmt:		Which format string and parser is used for this schema.
> - * @evt_list:		List of monitoring events
>   * @mbm_cfg_mask:	Bandwidth sources that can be tracked when bandwidth
>   *			monitoring events can be configured.
>   * @cdp_capable:	Is the CDP feature available on this resource
> @@ -287,7 +286,6 @@ struct rdt_resource {
>  	struct list_head	mon_domains;
>  	char			*name;
>  	enum resctrl_schema_fmt	schema_fmt;
> -	struct list_head	evt_list;
>  	unsigned int		mbm_cfg_mask;
>  	bool			cdp_capable;
>  };
> @@ -372,6 +370,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid);
> +
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>  
>  /**
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a25fb9c4070d..2dadbc54e4b3 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -34,11 +34,15 @@
>  /* Max event bits supported */
>  #define MAX_EVT_CONFIG_BITS		GENMASK(6, 0)
>  
> -/*
> - * Event IDs, the values match those used to program IA32_QM_EVTSEL before
> - * reading IA32_QM_CTR on RDT systems.
> - */
> +/* Event IDs */
>  enum resctrl_event_id {
> +	/* Must match value of first event below */
> +	QOS_FIRST_EVENT			= 0x01,
> +
> +	/*
> +	 * These values match those used to program IA32_QM_EVTSEL before
> +	 * reading IA32_QM_CTR on RDT systems.
> +	 */
>  	QOS_L3_OCCUP_EVENT_ID		= 0x01,
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 0a1eedba2b03..445a41060724 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -52,19 +52,26 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>  }
>  
>  /**
> - * struct mon_evt - Entry in the event list of a resource
> + * struct mon_evt - Properties of a monitor event
>   * @evtid:		event id
> + * @rid:		index of the resource for this event

x86 uses @rid as an index but this is not something that resctrl
fs enforces (please correct me if I am wrong). To prevent such assumption
this can just be "resource id for this event" or "ID of the resource 
associated with this event" or ?.

Patch looks good otherwise.
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
