Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEAB4C74
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749076225; cv=fail; b=Rxc6jk9cTQqpBm54oIAzm2HHyg22aV6hChsZIwfZBLzjmvQCJWHjzpC2YEtmNxlEMOdb0uvh4sbkKIdD5r++jTJghSGPXCy9YgCFD8Ia7u2OPW0MwcrrLhpo4Qj/hYOOg7+2L4TTKmH/jXTeQsPwst0uyXxYS3aEflN4+vgJ1E0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749076225; c=relaxed/simple;
	bh=RSFyDVvr6c81u7hWAltj+HhhA5TsHqzwb+z3AbaVUQk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WvLmUSGqhovtLlnuMeMvsY/bxekSs7qZYHmg6CMReY7Wq2cQUqM8/tyvyGESgKtpMxKqf1T6ZlIlxe/AMreTteQnotTQ8d7trl2ZeAOmHlgmOh11fuQa/N7zmBDi+O7X6VU8HpC5+3hN1qwGkvOdquioqYLreJvWE41tCuF7c3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I0iqsCDx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I0iqsCDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749076224; x=1780612224;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RSFyDVvr6c81u7hWAltj+HhhA5TsHqzwb+z3AbaVUQk=;
  b=I0iqsCDxyZZLKL/xup5RkfIITt2+5ufvMZeyqUY/WojtHmTpbaStPbMq
   AgeH9qjNJC4IAIwv+lWs2zUCRtjhPrW3eMwE3kD6j4K7nR44sRf4WYP7k
   dxNFaeNbvnvIyCCsXT54M6p/WKdkuZtR0VbMcteUfYzgPBGt96BDrVT1U
   IVlztEUPH7V7eFPoRW5OK+dMH0nkW35y+v3B9ur4x3SHmO0BTPYbZ/N9i
   CqDZxjipYX8pGFr4Xb4RUdyq/n+z9EXY/bjFIFIEqu0gySt/I+Bf8/zfX
   Ch0Ps9UJ1ESUgUBkDMu54qZ9GsUTDBjtlqsNyYiMZnPal0qMFG4XvzBMi
   Q==;
X-CSE-ConnectionGUID: INosHgNHQl+TPNwPyu90GA==
X-CSE-MsgGUID: TuTUmwKXRgCueyLqXM3JuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51246528"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="51246528"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:30:23 -0700
X-CSE-ConnectionGUID: XihfqzTWSSmAepy0bpCYLg==
X-CSE-MsgGUID: GTq9fs9US5+ZIWfCROkJBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150109030"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:30:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:30:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 15:30:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:30:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ef3wOreC4Iv6kZ+7mTvNtpuIObd17T0GcCnVZGWIVO6yrTpF4UVTZ1oNsUvWidF7waaVKsefhdkhtNpITOzNePSM6iHQTbXIsO0qR8Pv6lwoizSUmXiJWCHgD1xgDhUOyeSt+hBA/XL/artbI2+GijH0OFhQjgnbc7JXMkTGhK3kP5UQq5NxMQc6A/H2Auk8zGjqJtWHCl1WQckw4LjPUK1oZqkD9Qiyhe5Z48qQN5vrPj8FjAPrQjfQPXjBQ1W0wi3Lrh4ipCYaCYipNoYcPMZo7w+38vQ0bgnPm0Fw6VJSYOadKZR5cU+9kjwswxtO6a9fzkKcuvmvs0H0z9bA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1HCG/G3saBzWdfZlNSMWmm1DRzk+FEPxlCjs3SG308=;
 b=rmLhskSN1RyN8hKgvP4wSGZEY9JvQ92xy06XNYpuWttVJQhy4wRoKaXkZbphOm41Km/rXQPkAX8Gq8jfE9YJahUWA/Fi0Y4sBMNlz2NUWeFgC5FX3JwwzxN3l3A29LKvLhOxDOHg97GgmbMag1G9HvqlVz6uGQm4C722F3p3hse44e+pxIoMid4UE+MdbXRC5l9m3sGxQaWlfM9+PXr9zxPw88WRoZhoa09IbY8JqedBEA6gYan0KUAtZ1EFq4v9Us+zRA1I0g0a2+NmNKdMAgF0vCXib5qMzrMwjwcv+EJ75a1rnznlNLVhjab+d0A+6nl1J6wWdjnpjdq/6uYnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7193.namprd11.prod.outlook.com (2603:10b6:930:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Wed, 4 Jun
 2025 22:30:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 22:30:20 +0000
Message-ID: <9e8c9810-1b5c-4e30-8b10-c3702810b529@intel.com>
Date: Wed, 4 Jun 2025 15:30:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4 UPDATED] x86,fs/resctrl: Consolidate monitor event
 descriptions
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, Tony Luck
	<tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>,
	"Dave Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250604212208.49080-1-tony.luck@intel.com>
 <20250604212208.49080-2-tony.luck@intel.com>
 <bb7badd8-dddf-41f3-b509-42cdd4539fbd@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <bb7badd8-dddf-41f3-b509-42cdd4539fbd@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0168.namprd05.prod.outlook.com
 (2603:10b6:a03:339::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c96b60d-b7d5-4ec7-d871-08dda3b76381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnErQ2Zud0tLTGp4NzlPZW94dUlpbWN3MTdOUFFNaHhQS1BsK1FtNklTYWVm?=
 =?utf-8?B?eGhLWjIwcjlQdGg1ZUgvYkRIWWxMNWE5eHZybHpKblptSUxGTUh5ZzJjWW9y?=
 =?utf-8?B?TklodnBNRmFsV2ZEek5ZSkM3RkxCRHhwL0FIcmhwMGp0ME1OWllkS01YM2hV?=
 =?utf-8?B?M3p4cDVadG00WGFFZ01wSnM1NXVpZ2UxQTU5d3VUWWZWK2ZySHJTOHNabVVx?=
 =?utf-8?B?dC9lRUJIcm9tOFZVNDdkUHptZ1cwUExWWjFqTGN4QW8zQlVzdkhOelVYV0RZ?=
 =?utf-8?B?ZWFQK0xvRGJBVURPeHkyQndJNVo3SDA2Wk9hUkk3cXZUZHpiTFBORXUvbmtH?=
 =?utf-8?B?clVub2N1MFJVNW1qaGZ6ZFVWRHFHRmpUMHBhSnN0OVFvallybndpYW91K2pu?=
 =?utf-8?B?MUJJdlNHVTYyWFFXWEhkYXdKYjh5cFUxK0NmUDR4UisyanRwSU42ZlMzK3hU?=
 =?utf-8?B?M3hGR0w0SHJqWFQ5Z0dTRXFTQkI0Q29vT2lUdGpDSWtGQmdrOWRoQlpEamVQ?=
 =?utf-8?B?Ty9OQXJPZGFFdWxSdzN4bGU3aGpQcmNOK1B1VHBKQUwrZlpCTVJNZjdKc3hy?=
 =?utf-8?B?ZXhKSnp1R2w4NitmYkUza0QwK3M1c1F4RGo5V1dINVY4Ry9OcWlhTTQ3dUlF?=
 =?utf-8?B?ME9uSlc0d0ZEWmJRSldHOGV2TVRTbWU5OXZiWmk2TCtZRG9teWVRMHR3Mlk3?=
 =?utf-8?B?MmZTVmhYQ1A2aHJKSFRibWdZVGg3ZjUvakc3Z3BRNUR1K1RETTdRdmZUTTM3?=
 =?utf-8?B?OVgyK2lDSkpBOHhvdkoyTEtIZDBqL04yckljK3JXK3BSeVc0RGxkMjVBKzAr?=
 =?utf-8?B?TUpWVitlc2ZQU0I0eGZQQXJrRS85MloyTndGNWJjUmx4bDRlU1ZGbEYzZ0Fi?=
 =?utf-8?B?M3hJTkgvRTFkVGFxWmIrMi9YVktxWEpYK1cwcUJCVWFTTkNuVDVKcVdTa2Q4?=
 =?utf-8?B?b0JDa2c0VjlkR3l6UHJoZStDMmxhSUR2ZDlDMXowZEZjbUdTc2MwNHBSY2Mz?=
 =?utf-8?B?WGFKa24xVWVMU0ZhTmFjdjl4bXZRR1pmWVRlNnJudVFEOERVbGhYQi9sYTVv?=
 =?utf-8?B?L0EzY3BuanhUQVFsWjh4YTRIWkRIaHFSL3QyS3RLTkJFd2xnSGhNWHpLWEth?=
 =?utf-8?B?a1B4Nlo2UTRLZE9YMGxCblVPN0YxcnhpWVhWVklWTkowcEdSMHhlNDFQaldi?=
 =?utf-8?B?ZXVJN2M2eVF2SGxxbmVlRUV0ZDdZYlJUTUxrTTBmQzFXSElraS81cjh5dGJD?=
 =?utf-8?B?NERlMjNnc21QZ2VzSUtTTStzSEFqaWxKVzQ1Q1RjdlhxekVrNGsyeXBBaytO?=
 =?utf-8?B?NkFkWDVUR2FsZmJWSDVyNnA2eHNoaXRmdmFHT3FGcVdHTVdRbUhzcEpIbUto?=
 =?utf-8?B?ZHJxUzQyL0lMT3J4Ty9kS0VESjB6c3ViSEJBcWJwdjBxcEg3VzJGVkJka1Ns?=
 =?utf-8?B?TURsODBVZGRzTnM5Q3hwL3k4UFJhN0tzNG5VeGFUZHdUaGhFRE80czBEdi9G?=
 =?utf-8?B?TWRMZlVJNlhZYTkwWlV3eU9OSDhOVzR2OTRaeG05NzN0aUhuanNPczNDcXZK?=
 =?utf-8?B?Y3EzZE5EdG0yRUdZdjBlOEpRVHdYWlRyWG1YMS8vK1NlUEw4eDQ2NDcrcGFy?=
 =?utf-8?B?RDBtSkJveHpPL3lhVVJ1MWovOFRRTXRHZnQ1aCtFdnpzb2V4ekxldVhuak16?=
 =?utf-8?B?YmtURStVM2V4dEFidUhTUndkZDVPTkdCYm1BODB1ZThkakRpeDJqZjR3RWh3?=
 =?utf-8?B?dWlDQU9FNnVaUGxueU1WU2l1M01pbDJoKzVHdVQ4cHBYclRLckpOdWhXOTYz?=
 =?utf-8?B?STFmZjVMaDhQdk1KUEJzU1BMMERLUTFGUWxHcm1BMm9zZnp4dW80eGRZd3BH?=
 =?utf-8?B?SWdxbnJid2VzYWNzQm1uMjJxK0VBYlNGTG4wRkZkdHZTbHd0R3lTd2l2bG0v?=
 =?utf-8?Q?1IVmZnOktU4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkxKdEwvRDlTa1dGckhhK2RjYXo4WUxCR2VYbmd6bDUzVkoyeklwdXU2Tmxa?=
 =?utf-8?B?cURVbXVySlBDYllQeVVMVXFoUHpyV0lRVmN3N0tIc1kyb3dSYndtYkVPTU14?=
 =?utf-8?B?YkJoK091ZG5BSEZvbXBJNHR1bmlESDluaEI4TkZTeEhlc1BrT0gvZ2FCSWEy?=
 =?utf-8?B?d2owUmJYWURkQ0Vodnp4THhZREc3NVI2Nk9XSXhNSkd0ZVBOVFdRbGErczJT?=
 =?utf-8?B?VjN3Y2dVWll0QVMyN3lVd2VhUHJVV0IrOUpJVmlkcnBjeUtMOTdaRzFraUZa?=
 =?utf-8?B?S3JzUVo2Y3I0Uy81eHNBSzI0S1lCRUp0dHhiMFlGQTFFWVRjQU4zZm1SRVlW?=
 =?utf-8?B?L0lwWEExcC91bnFJZHdLU1VFRHVTbDh2QUQvOHN3VFQ5MFpwOVQzY3VLbnZK?=
 =?utf-8?B?T0RNWnQ1RHZyVzJxSk4wNSsxRmNIQVZmTDRUcVhIOUwwc0JtQ2JEaXA4bW4r?=
 =?utf-8?B?eDZPYXVHZ3NNTGIzYTdEYVdZcllsZWFSWlY5ZUdRdGJsZlNKQmVVZEtOU0xm?=
 =?utf-8?B?V091Q2c3eXlFaHNmTXN2L1J6TTBQMTBvSDQ0MHhLYm0zdXFncGc1OFg5WHdz?=
 =?utf-8?B?WThzOHBETzdXYnBqUVNWMjRLKzJSQnErRDJzMldtUG91NE9teHFMKzlXK2s1?=
 =?utf-8?B?YU5vTlNpTlg2aW1JanZMdWI3SG8zenkrOGYzREpaclIyYWdZcHdLbjlhQUdq?=
 =?utf-8?B?alJVMkoyK0FkRFBnNFdDZ0RobWxnbktlaFF2eDllTy83V1BseFVhZVFUeXRY?=
 =?utf-8?B?R3RDaU9haitNY1A1aEk5YTJLV09TcllQOW5Qd0ZvQ1d1WWcxNU5aNkh3WDBM?=
 =?utf-8?B?YU0zQ2pNUFlkcWV6K3hpczNoNTY2T3JYYzYxVTVyWVQyK1JUcWxkZEZISEdl?=
 =?utf-8?B?alljVjk0aFQwaUJ5RkRFUnVEd1pWREJ0UUs2QkptbFk0cEtxYmQ1Uy96cFpj?=
 =?utf-8?B?ak9YOFh1MnVYTUdZR1Nxd3Z0V0hzR3ZJUTFVSWRGb2w2Nno2WXNZQ0RVNHB2?=
 =?utf-8?B?Ly9Rend3Yjh6SWJHOEZkT1IvZ09CS0d2dlV2dmtIK2JLZU5iL1FSQVR4blBm?=
 =?utf-8?B?UzFaMktpNHVJSzlTOXlRZnRiUFgzaGNjVitMaGtlRjQ0QTRPK1R4d0UrRmxR?=
 =?utf-8?B?d1RrSkFFK00vWHp5cmpyY093YXUwN0RMaW8vSVZxQ2tHVFNxYUthRTlIUGxN?=
 =?utf-8?B?RWF1U0JESnNRUFQ1M01QdFVNWFh2M2VNR3Z2TDVFU01XZ0cybFZhajVweGx1?=
 =?utf-8?B?Ny96TysvVjhWQ216U3dTZUZjSG1MMVh0aGpJeVZnbUhGZ2NCSHN5dUh3Vnl3?=
 =?utf-8?B?dnhUZzVTVy84bjlQcjhwS3E5bW5UMEVXQ09FS1luTTRRYjVwOExmR295em1z?=
 =?utf-8?B?VXcyczV0citFckJCVEMzdDE2STRlanRYWFBCaHhKR1NENnZKNlpVZjU1SjU2?=
 =?utf-8?B?dFdYVHl0VWt4eG15ZDVzQnZwYUhndUowSDdMV2tmR3NKckw2a3RGWklQWUIz?=
 =?utf-8?B?cVdDUnNBR21INEhNWkRnSmVpdW1acmgrUzhBakRSS2dubVZiSnNTOTVON2Vq?=
 =?utf-8?B?QlB3aFJiOUNORDNlOVkzNUh0VCttMnZlSU14THh6K1kvWWQ0bGNINHo4b0dp?=
 =?utf-8?B?aUU3RHZwdHVRSlYvUHZoalNBbkpJeWtBRXNKSXhLVEs1OWNoMTBhTUxTR0Zs?=
 =?utf-8?B?dWJxa2JSbGh4b1ptd2VBOUxUU1ZENks1RFgwWE9FZzlkbktRZU1EWUltZTVW?=
 =?utf-8?B?M3pabVlwRno0WVU1NmFveTVJWTNscVVFS1VjRkNLd09EUTNGcVJ3bDZBZGRj?=
 =?utf-8?B?ZjI5RjNpWEZycllhVFlPcmlBcUxjQ3dQZ1ZEUU1SWHEva2d5c1Y2Z29PNCty?=
 =?utf-8?B?cHJmTXI2T3czU0pXYzJQdU9ucURMVDV6OFYrekhPUm9USVJMUEZlNzZ2YmIv?=
 =?utf-8?B?V25yVlo4WlNPWmJOUU5FU2grWDc2MVNza3V4SHVuOWFTR2xudUxXbkJRRFBN?=
 =?utf-8?B?UFhSeDJ6UzVIL1I3d1RNNm5kUldpL21UR2dQWGxJaHFoWlVwOFhQUnlRcko3?=
 =?utf-8?B?U1ZWTmxlcmtEcU1DSGJTdi9EWnJjc0tYU0Z5dGNxS21yQjdMdzhTRzlMaWdu?=
 =?utf-8?B?UnYyV3MzNXR0TWlHZmN4YnVOdUFtMjNPWXBYY1JPR2VmUkhtOVB1QlFOODBu?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c96b60d-b7d5-4ec7-d871-08dda3b76381
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 22:30:20.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wO/aB9D2L/dmaMZJMCdv3TQ+RQmOhztNwjXUcgpVgXK9YgI8fkDrt5UkCVAvqwZB3bNyQ94Q0HX3JBNC77cN1b6R7tw/rPvS0tRejRDYvTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7193
X-OriginatorOrg: intel.com

Hi Anil,

On 6/4/25 3:21 PM, Keshavamurthy, Anil S wrote:
> 
> On 6/4/2025 2:22 PM, Tony Luck wrote:

...

>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>> index 9a8cf6f11151..71963255ad36 100644
>> --- a/fs/resctrl/internal.h
>> +++ b/fs/resctrl/internal.h
>> @@ -52,19 +52,26 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>>   }
>>     /**
>> - * struct mon_evt - Entry in the event list of a resource
>> + * struct mon_evt - Description of a monitor event
>>    * @evtid:        event id
>> + * @rid:        index of the resource for this event
>>    * @name:        name of the event
>>    * @configurable:    true if the event is configurable
>> - * @list:        entry in &rdt_resource->evt_list
>> + * @enabled:        true if the event is enabled
>>    */
>>   struct mon_evt {
>>       enum resctrl_event_id    evtid;
>> +    enum resctrl_res_level    rid;
>>       char            *name;
>>       bool            configurable;
>> -    struct list_head    list;
>> +    bool            enabled;
>>   };
>>   +extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>> +
>> +#define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];    \
>> +                      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
>> +
>>   /**
>>    * struct mon_data - Monitoring details for each event file.
>>    * @list:            Member of the global @mon_data_kn_priv_list list.

...

>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index bde2801289d3..90093e54a279 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -842,38 +842,39 @@ static void dom_data_exit(struct rdt_resource *r)
>>       mutex_unlock(&rdtgroup_mutex);
>>   }
>>   -static struct mon_evt llc_occupancy_event = {
>> -    .name        = "llc_occupancy",
>> -    .evtid        = QOS_L3_OCCUP_EVENT_ID,
>> -};
>> -
>> -static struct mon_evt mbm_total_event = {
>> -    .name        = "mbm_total_bytes",
>> -    .evtid        = QOS_L3_MBM_TOTAL_EVENT_ID,
>> -};
>> -
>> -static struct mon_evt mbm_local_event = {
>> -    .name        = "mbm_local_bytes",
>> -    .evtid        = QOS_L3_MBM_LOCAL_EVENT_ID,
>> -};
>> -
>>   /*
>> - * Initialize the event list for the resource.
>> - *
>> - * Note that MBM events are also part of RDT_RESOURCE_L3 resource
>> - * because as per the SDM the total and local memory bandwidth
>> - * are enumerated as part of L3 monitoring.
>> + * All available events. Architecture code marks the ones that
>> + * are supported by a system using resctrl_enable_mon_event()
>> + * to set .enabled.
>>    */
>> -static void l3_mon_evt_init(struct rdt_resource *r)
>> +struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
>> +    [QOS_L3_OCCUP_EVENT_ID] = {
>> +        .name    = "llc_occupancy",
>> +        .evtid    = QOS_L3_OCCUP_EVENT_ID,
>> +        .rid    = RDT_RESOURCE_L3,
>> +    },
>> +    [QOS_L3_MBM_TOTAL_EVENT_ID] = {
>> +        .name    = "mbm_total_bytes",
>> +        .evtid    = QOS_L3_MBM_TOTAL_EVENT_ID,
>> +        .rid    = RDT_RESOURCE_L3,
>> +    },
>> +    [QOS_L3_MBM_LOCAL_EVENT_ID] = {
>> +        .name    = "mbm_local_bytes",
>> +        .evtid    = QOS_L3_MBM_LOCAL_EVENT_ID,
>> +        .rid    = RDT_RESOURCE_L3,
>> +    },
>> +};
> 
> As we start adding many more events to this struct(including region aware specific events), this this becomes too stressful on the eyes to read.....can you consider simplifying this with #define something like below in your next version? NOTE: For the feature that I am adding along with Chen Yu, we started to define a macro as shown below.
> 
> #define MON_EVENT(_id, _name, _res) \
>     [_id] = {                      \
>         .name  = _name,           \
>         .evtid = _id,             \
>         .rid   = _res,            \
>     }
> 
> Above #define can to into include/linux/resctrl_types.h file and the above code reduces to using MON_EVENT as shown below.

Any reason why the events need to leak outside resctrl fs? At the moment it is kept
inside resctrl fs with helpers for only those properties (not descriptions!) that
can/should be set by archs. Enabling arch full control of the event is not ideal
since many of the properties are required to be the same across all archs and
dictate the user interface that is ABI.

Reinette

