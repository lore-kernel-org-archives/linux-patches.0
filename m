Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E667F35A39C
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768916; cv=fail; b=qfmRyh7Dhhni3EBBcqnz760pjg4xMX0UrFabVVRF0U4mKRwW+c1c0KqlSvCWz8Uz87SHa2+0ifLbnomAf5xqHMp4l3vEP29pNj2vWuxDBYTSSwrwvn09PXEeDek7HHWymNrnvEl6N8lso/csDKDBGhbvP9m5Iyz2pWrI3wzbaCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768916; c=relaxed/simple;
	bh=n6TiZughdOYjSRujKyGM1ABPKiBKkqaBRDPZnBzX3xA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WQsWYfE/tGl91eMqGjzuTDdTi6BudqM/0WNb4ec2HtUv5DlBPcf4DEImN65qgnIHKOYtdbkGlO1XErgP2PFE5q2ov/t7OkD/VRMnbHTJqWFqu2uJnR3+vtYHlpuPUAAGIOsOy5NMEWCQq7m4VyxC1Ka0Ex8XbHjGIBhvqXvd9cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RrvzwBd9; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RrvzwBd9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773768914; x=1805304914;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n6TiZughdOYjSRujKyGM1ABPKiBKkqaBRDPZnBzX3xA=;
  b=RrvzwBd98x2lBN+M0m7sStP6eLQxzX9ilzUWfHgnVnExiidrXrsMgXUh
   Ksdfpi7hbaPVngdbnk3ekdOCoR1x5YQOHy7Y/M4rc7NFKOQwXcwa09u2q
   LA1ZPMF4IjGQXw2WZbfUlpt2lab4U6mFlfZZE2UbRT42vHNf2Jh+UGMtS
   2of+RC91sWA06lRlbJ5F+OnXN4XsKz4IRUtayKyW59XPdaQ/uvL/MpcV6
   99SPVnvTdnfqqmsUsGLyWOAf93iOQHm1ilSmWjPq4bjEQ/87qsOAlpsMG
   lyusd1YNheupMzr5sxpfu+UovcsMgk0mbtQwXNkZ25SbwOCchATG0Kqv3
   Q==;
X-CSE-ConnectionGUID: 9r+WBCpFSa6qUnZK55xUjA==
X-CSE-MsgGUID: 5/s+EWBvQJyUgpXwEHxsGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="100267053"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="100267053"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 10:35:14 -0700
X-CSE-ConnectionGUID: J+0PKKd/SZWKpS2pYFCvZQ==
X-CSE-MsgGUID: d1oWwhSjSu6SH7ij/FCpcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="226481194"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 10:34:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 10:34:25 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 17 Mar 2026 10:34:25 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.29) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 10:34:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OhVYm8ktYEycrF+OFrGqA51NgUlAJH8QEZ5m6uBSJRxfICM409y31wzRDbbFQVLfQa2cz0tRxu+apVSfw5Hc/uB/f/l7nwfY6Me6HrW6PMCe+jpXD1H2dDG0enuy/NROfDyD/JT+68hq2VEvgpdDYCklW+ovKi+HX0Wc4VqbfLEk7JnAt7jSy3NjY2yl224Hh5VeMZFS6pZvK8WxaeeO6Dtbf2n3iqKH4z6vlAmrz32vmzhvMVdUK2ytHfaUm3/T0bds5XFCfhgNbeTQmp3FfQcNjZ7m/I6ocunWplBhs7rV0MAgAZJ/BZLehGCf/vnZJpRWmfWcGzeXaERQ5EEHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crvIf7yun8WWE4UF/imrwKtwNE65Q3bRHZTTbAZsfW4=;
 b=H/zcOlklAdoEKXQjLWY5yIXL+4pavspC/A8RiNLKTjgvLrk7pSOOaqnL1raNUjRln058G3JJhqtLCYpqJvBQuDDvyWbDPbiEdQ1XlJgDW4OQB18wpmdNQcgkATMAYkEIcKXJbPqo4Qv9Agdy8nu7w46GFXQJ3KzEpM+veSvto7YK8Qa4dZpvsZT+UzU8n5exjv7OKs47pSdBcctYrl0bNtANBFjeD0rern1nrUBQePbkprnVqNcDL7S5uR4Sgt+PCbmupUw3LBwYHv2J/fHGopwJV+BaFmUPUbzR/3PiKJbODVO71oH4Br+nCwl2eZqe/ouJkKbCfVgI81iQQ2H/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8685.namprd11.prod.outlook.com (2603:10b6:8:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 17:34:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 17:34:22 +0000
Message-ID: <630f8501-cbfb-4b58-996d-f17bb71c3806@intel.com>
Date: Tue, 17 Mar 2026 10:34:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
 <008ba74b-94b4-421a-8178-f7425d11bfec@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <008ba74b-94b4-421a-8178-f7425d11bfec@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:303:b9::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bfdbf5b-eec3-4da4-c533-08de844b6ced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: BCEDCkxW4cpFz3lsYwC06FqFne5Gs7Pv7ZJ3X6pCJIp55hbg5+Y9lIJ03/CEM2AingLLrUEmwsX3y2Y5TBaJxiR/3J1JBSJhTtxwdOaU/TszV9bJjjuolDDml5mwVBQnrexnD3A6VJHCrmPPX6XB/c2C1mBc5nckZSD/qOGlzvI5zwBh+yPILcIG5W5nHMirgqTjPMSEM8Vf5v9SeJBVA+/4hA4DlR5OJJWfypo3tKlBbSW6yORYpFX5H09IDwqAPExJZgoSg48jGiPkn/jJ2+00UVJJIXogq8Ig23HbitJcTvcXSaOAC8iXhf2OKUuJZdoQNpBe88apftuS++9gFXy8kpE2jZ7LfRjlULXApOapYM802r+BVKbA/YRFLYw1dlLJqNmHheDyPvfhh+DL1zTqecHIC4jw9H3RpSxfSD61sNyak3oCFYLeeJ8SvSTLxOy9jlfAb64isKqNvVKcsUmMf/f9g0AkgYtHDNp641aYRDZsMvnZQWuhkCsIPqeVgOB2nbyAIy76mzcQo6PVyXCFgcUxgMaDjR8yIPuTWxegWn2j433KL1YzsjC0Bjt4jrxiGEyS3fxuUKBJPFPZ6ligdDnult11LVoQgHcHeYL7Pig8ZHxxWsymSM8RxoDkPuynqsAtIa6xp7JIS+LOm1iTCz0ULqGSgd/i1G6UdqjWBMvpsjRAzj8jk/xKYhFEqa78vEl72MGN3tr7aPBewRPsDHfglj9ri645UUYZuCk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU1uWDRiT0tqLzBScXdicFpKUTQxODdvSjMySk5BOUF1Z1NxdG5XQW1qRG5F?=
 =?utf-8?B?T1pkR0Y0ZVI1dG9rdnBEWnFxTUdVMzY2alM4Wi9GZGZyUWZ5UlIydjNVcFBo?=
 =?utf-8?B?blVzVi9HeFFleWZLTk4vUElMNG03WExRbFo3RE1UZ2VhTjdzeWt1a3hKZHNp?=
 =?utf-8?B?Tlp5NytuNWp4eUNsSys4UVN5UTRCWVlVV2pGb2ZGNFNGemVuWDE2TXg3M0ZH?=
 =?utf-8?B?V3NtTm0wUTRnblB6UHNsK0xnZ3QrK1VYY1B6dC83cXFFM1RuS0oxd015TjRO?=
 =?utf-8?B?b1p5WUVXZkdvR1lPR3BkUUpBZGNRRTVaeFZDdmlXSy9IOUh3SjcybzQ2QnJ4?=
 =?utf-8?B?R2s3RTM1TkhQWnpqYnFMV2lzblprOTFXRWdsMFF2UmtCUm41L0NDZnJBRVls?=
 =?utf-8?B?T2szY1JNTWFna0VETGVzZE1qOEY2UlZJOUlMaW13VzJzZXhqOUlSY2VyajBF?=
 =?utf-8?B?RDFrYUFmN0NpdW1mVWV2aGlXa0lVOG5DWkkxbmdOOU5lVVdXNVZ6bFNqa1Fu?=
 =?utf-8?B?MzZNamlMOHJDSFJwYi8xZHRWRE9ublM0N2IxeHZ1aGtoTFhzeXV2WXVCVmIz?=
 =?utf-8?B?WVlwRnY5YktKQjhTdWxTUGg1RlROUFdsb2hHbWI5VlUvWTYyRFdicDhMKzh3?=
 =?utf-8?B?SFcySlJKWDh2QzVDeDhOK0NudnpoZHZmTEQxa1d2Q3dvZGc2eW8xSkxISzlW?=
 =?utf-8?B?S3c1YU9TM1gyK2svVTJhRXVOcWhaQ2N1UGp3aEZ0UzlzMnJ1aTgwcmFoR3pS?=
 =?utf-8?B?aVRoVGNpY0NVVWVLS1MrTXoyZ3dhektvcDJLWGY1M3VWaTViTjl1RGo4Wmhy?=
 =?utf-8?B?TWVqUk41MlNmbTJFRTh6MWlwdW5YVktGRHJTamo5SXRXcS8vRTBwZ3Y4Y0hH?=
 =?utf-8?B?QkxzclY5NWhOZUM4RHBZcnF6ZkNmVytHWXBoaG83eHF3MHA5d0FIRktGUlpR?=
 =?utf-8?B?MVpwMHVhNDhXc1QyZzRxd3JlMURCWGtmZmQ5VWFLeWdDZUIrT0lGVU10eXBP?=
 =?utf-8?B?VkREYVJtc1JCalJQTUR0cGVmNjhpUFYrcXEzTmFaRmx6SzZ0WGdNSnJFdTBr?=
 =?utf-8?B?N2RWdm8vNHBjT1RXN3JPT1BBUHQ1ZENJMUh2NzFRcDA4dWFMZmtQTkJhQ01L?=
 =?utf-8?B?bEhkOURuUFQ4WUhXWU4xS1VVTWo0c2FFKzdQUytTdFRLUDNnN1ZvQzNaY0dZ?=
 =?utf-8?B?MmdrMHNEbkxWWjNTREl4VlpwZEY5YlZkK0hidnhBYWlXaDQzeVlGb01LZ0xG?=
 =?utf-8?B?WlVycWlFNUp1QUpudzM3NVN4TTJFUmNRVUpCVnR5ODBMaHFKeFNyY0FmbnFM?=
 =?utf-8?B?bWRHM2FqQnBERmtSdmZ6cGJrUFM5Y0ptUVlLYUpjT0E5amdzZWE4UldWcVcv?=
 =?utf-8?B?MjBjRVczOEMwcmJoaURQekF2ZThoWmlxRE5YQ3F1SGE4Nld3VnE3S2gxVmVh?=
 =?utf-8?B?ZTBPM01KeWdybzQwSEl2QlhQMEFMYm1iMWhHT1dMRzJWT3YvenlrRmlpLy9R?=
 =?utf-8?B?TGFzQURsU1lCbU5BNkl4bSs5emdManptQ3krbllFUXlKa09wWmM1cEtYOFNa?=
 =?utf-8?B?c1ZPZHlJbTNkTU9FSDRZaDN4L3FrQ2k2UncwTUFxc1VZc0FmQmlZdmhsQnFx?=
 =?utf-8?B?b1N3Sks1aXV2ejNFd282OFN5ME9wRXM3TXFMc1Joamt1cFMrYUYyRE5Pb0ZG?=
 =?utf-8?B?eVg4dmhDaEVrWFVvQ1ZlazJyM1A3RmVIQ3ZGcy9lbVkrcmQ4VUh0WjdsdjBk?=
 =?utf-8?B?UW9GeE9IZ24yYWtmNWFoTktWZkkwbEVNcVl5UlRSN2JFaW5yYi9sZjcvY2VR?=
 =?utf-8?B?YVVITVJ4R1NkaTl5NkdFQWV5eU5CbG5lMVVZdVIyTXpxOHRCdkhqazlLQ09Q?=
 =?utf-8?B?SFhIblNYM3EzZzl6Y3pmaWNjK2RWMitBdzVaZi9RdzBtODhGOGVaU3hSMy9w?=
 =?utf-8?B?cENEWmVkNGYxaWpFdmRkYjBFL08vOUlubTlvUU8xMnZIVHl1S0tIR2RaOGlD?=
 =?utf-8?B?TWtoYWxnOGhITzNBdDdqVEVUYzJpcWgvS1hJRWNRK3NSaWpRU1FZQkV6M3hP?=
 =?utf-8?B?R29Kdzc5NkJueTlMNTBvczVuWk5BYjIvRzhocWJRcks0OXM3dms2MXhoZUNs?=
 =?utf-8?B?NXRwYTdkellNeTc3eEJjWHhpenVvcGJaRUJDd1ZhMGkyR0JOQjdUQXIveHgz?=
 =?utf-8?B?RThiZ2V0VDN3ajRSRkpRRVJqZFZHaDVBVEgwQzdlTTR1eEVCRllDNituM01H?=
 =?utf-8?B?RXdvQVI4bTR2SndLNUlVUWpNNjJxMm9Rc0t1d09VaDFlYjNPb29PRmhoRU0r?=
 =?utf-8?B?OUR5T3BNVS9BWkUxR0Vqajd5OFVHMEhBMmlmWlg0OEZBbEhRUktiWkgyZkhH?=
 =?utf-8?Q?MxODRctBDq5xZbQo=3D?=
X-Exchange-RoutingPolicyChecked: aWwdHimDqV3lGi9Ue5iP5yE2Sy3jlnhDWqtoBlijlDvfzbacnwMxJ0X+QCk76lhA6gBgc2ciY+9Ow1iXPqKNNhEJ4EWwYYsJSghshmk+Mz4URKlCG6fwUOjleeTsFYJwxPrIEObk9ZiETGpvoe7/cRMT1ZJfS/mIOH++I8VLHf6hzcvWk/TEzx+XYwufBM871+ioKOkt8YfdGTU/09TZcv4TM5ABqpIdAeAxbQm6PZB+De8MNoiY4xHfuDe/PrTjx5RVsBJO2jA8ICrLWvjxyy8/myHyLgW6do5s9e9XY8K608dS5hfWiRfr1A5Eb3QOHWPZ+0IXE0zs8+BV7SCVhg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bfdbf5b-eec3-4da4-c533-08de844b6ced
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 17:34:21.9916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQNJ1iuox925qNt393x/JbvnajNJkl0yEdEgZDgvNq370sGnsydqswLSdmrxa+/6brrxocJfGRniwlronOVT/rQdoGO4ouxZR7DFEB933jI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8685
X-OriginatorOrg: intel.com

Hi Ben,

On 3/17/26 4:23 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 3/2/26 18:46, Reinette Chatre wrote:
>> Every resctrl resource has a unique ID described by enum resctrl_res_level.
>> enum resctrl_res_level is used in all resource ID initializations and all
>> resource ID comparisons. All functions consuming the resource ID expects an
>> enum resctrl_res_level. Of the four structures that contain a resource ID
>> (struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
>>  rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.
>>
>> Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
>> it obvious what values are valid, match the type everywhere this member is
>> used, and obtain benefits from tools that can flag any enum misuse.
>>
>> Move define of RDT_NUM_RESOURCES outside the enum to enable tools to catch
>> when a switch() on the resource ID does not handle all the resources and
>> thus help flag which switch statements need an update when a new resource
>> is added.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  include/linux/resctrl.h | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
>> index 006e57fd7ca5..48e95f273fb3 100644
>> --- a/include/linux/resctrl.h
>> +++ b/include/linux/resctrl.h
>> @@ -54,11 +54,11 @@ enum resctrl_res_level {
>>  	RDT_RESOURCE_MBA,
>>  	RDT_RESOURCE_SMBA,
>>  	RDT_RESOURCE_PERF_PKG,
>> -
>> -	/* Must be the last */
>> -	RDT_NUM_RESOURCES,
>> +	/* Additions to enum need to update RDT_NUM_RESOURCES. */
>>  };>
>> +#define RDT_NUM_RESOURCES (RDT_RESOURCE_PERF_PKG + 1)
> 
> Would it be clearer to have RDT_RESOURCE_LAST = RDT_RESOURCE_PERF_PKG in the enum
> and use RDT_RESOURCE_LAST instead of RDT_RESOURCE_PERF_PKG here?

It would. Thank you very much for the suggestion. To have resctrl code be consistent
I'll add another patch that also switches enum resctrl_conf_type to use this pattern.

Reinette

