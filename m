Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AE51FEFD9
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 22:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449562; cv=fail; b=HZIkBDxy1bYdj/SnoTzo1Te0Wnth1eFtOr2L+GUPii5gzXGbgoZAW2sPfb4tReB4pxJiCtv5QmItkZH7wREPLIlNHNTAwaeNA8nPxEMlZHKP7Zb4XxoW5E+ztXI3mMhqzK3TUUcHEAxVe+TEd3+C+7i12CGpZhjSdesqC9ROyJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449562; c=relaxed/simple;
	bh=OCZpTS7fO8qk50rXD9Mp4u9VOsoP2uRMqOQ3P8EiAJQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J4ZymQKFnfq5VjS+I+wj74u3UUtzxkhOGs2/f/c27KuiikWDFhdQyE/OTMBZYDaRZ7xe5b1iQh9IsVJJTAU3eBI4AiALwaxrV61OBQY+spG1baBNFFmJiDSHA0BD8bupH6a8c7QVhXfNtZioUDBkbtcWiaE0h5kRlTWKW4MEOWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DthpmiA3; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DthpmiA3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731449561; x=1762985561;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OCZpTS7fO8qk50rXD9Mp4u9VOsoP2uRMqOQ3P8EiAJQ=;
  b=DthpmiA30oDLTBB1jTNJ8edL4qyHXBg8NFV30iZToy0Q+8Ds1qgzFazU
   CAdYXZy54XCu2Se+YN4i1YaOBdPAKI+ALk7/ZwhFNKgf6QNyDT6froDu4
   3/68E6TYo2VhYwp97TsuQdfn921aP3vAVDxRSs2nHXuEpWPlkwTC1GeL0
   zFGGNR1RjxJ5II69WgRIwW20TZjCeMSxiY2IT6+sB790HTH6NcFp76Vsa
   dNx9daPytUPg4by6VT79DIDZpLl7QxfElTDZyBfmgShU/u+EjBRjXr5ll
   a3OsIDqYPwLNzprI4fQJY691op8Vh1iDjq8UvwR4PwgSJAM4AfegcBMyu
   A==;
X-CSE-ConnectionGUID: lO5VNQ/GTCSXIVKjzA5yKw==
X-CSE-MsgGUID: b3maS3SVRluWzafF5vCouA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="42418669"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="42418669"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 14:12:40 -0800
X-CSE-ConnectionGUID: MibJM2YkQUWp4vbsjdSvuw==
X-CSE-MsgGUID: SV8Gy/XxROKf2oE862izkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="92738284"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 14:12:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 14:12:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 14:12:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 14:12:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0BLaEAd96XlNjG6CKcM2IYjgJjz6rTWqPZPI164WlqMFBTo9dqqpAJkN4p3M5bHRKfjgzS+2yTL2QEm4mCWBcA+4SXFg/Jz3EvXsEhN2Cms1qWB1VGfiBPdo9r5LWDpOjJ3G+LXvDppH8IvO9QDe0h2gmc9wen7Dl80xHnMeCLqRBbTwHAt9xIjRGi2rJ8Sof14gFCXs4DElN46/9QD0nLYVnDUz/4SAeyY6e+u65Ale38I9+/peVn8UeQ+t8kBXbAtXPBffO7TSq805zudKKq48A+7MvCY8x9cpTRhFyQzXvjmOJiQqfPFMcRy/OCjED3UR6VMSCvCIl3k3s9Nfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrVnd98ozyoxcyuge3mgGS9Z6Kix28EDelb4dRwLN94=;
 b=UPkdlnkUW8YEckzKNLHpenfNBXOE83LPmwDRXnWVi8Ln9XSTUqYF5qdgKfu4G3sJMcNu4kdkV7M7wO6ODTKhdryOsGsk2mOkQUY+HOV4CKkVk2Ri9/rCrcc6UtsUnWzaBQAhkn6txZC1paAOpq1F1SieuoiPb6zaWUfc4rq3Bjndii0pL2milQtFJ9VN6myY1WAyLzvEXmKubsi3uRv6nZlHM7ncGg3yVmWRF0tOVvuXDaRiEGDUFxfnfX1JCAWyqVb+CoxwToK4AblZJ1jq6wYSk4qhuEN7GFLGHozhbwyuYX8bzNA5Ue26O5Dgv86i5ldmbUi3ud+VgZblcT8UOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB7966.namprd11.prod.outlook.com (2603:10b6:510:25d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 22:12:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 22:12:37 +0000
Message-ID: <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
Date: Tue, 12 Nov 2024 14:12:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20241029172832.93963-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:303:b6::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: fdc412db-da40-4a72-d358-08dd03671dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eGQ4Y1dxUWFweE0yd0dhSk8rS0xaTDZQbVE3ZnFvM29KYzZDdWovN25KclQ2?=
 =?utf-8?B?OG56d1AxTWxJR0IwL0lyeUM0N3ZxeUJEM1RwSlQzTVhvQTh6NTNyKzVEOTZn?=
 =?utf-8?B?REp2dW1aVnQwNWgrSjVFSk5vNEhBZFJhMG1CbEdRWG04ZDhleUVhRTBvMkhl?=
 =?utf-8?B?MG5WM3RINTBlSnVNTEJCWjNsbVd6RnNjeVhCK0Noc3luekNrRGFrelF1ZXMr?=
 =?utf-8?B?Y1VMWlBCU2U5QWQzcWVOTlVLbVRRUmx6Wktzb3hvbG91bDVtR0cxN1lCdjA5?=
 =?utf-8?B?TmNBWS9Pb3ZlRDdQMjJiaElmTGFFMXhHSUhYeTRoK29rWEUrNDhHa2duWDZu?=
 =?utf-8?B?NmN3WUdGc1BPMDAyTkEwYmU5cys5NkdVeHA2V2NWTXJDMVhJai9RZE5JUU1s?=
 =?utf-8?B?c2xvQ2I3c3Zxb0VVS3BlQlErRGNsalpaU2JSOHBTUFlXMmlBNnpxZEJhUnB0?=
 =?utf-8?B?VGRPUU15SmNPUGE1Tk9KbTBQR005aUtkYkg2VFAwK3Y3dUpVdlBXUGxIWFFV?=
 =?utf-8?B?bXZYZEVnL1FrQjd0TUs4SWFBSDJRQlA2MnZpbzMvdktnVjIxV2F6Y3I4Wllv?=
 =?utf-8?B?YWRHMk8ycERJWk5kYzZ2alVkd2MxaDFncVoyek95TVlqek1jYzdRWDduS3NQ?=
 =?utf-8?B?TzM4UzZhMGM5ZittUnhiVnRseXpXMHhSc3Uwekx5Rk52L0I2ZkNmZFRpcUhu?=
 =?utf-8?B?eHlvNTZBZXdRUkc0RDJNSG9idW5rcHRHbUFSbXhFQk4yUlBTelI2eHVjTUNT?=
 =?utf-8?B?ZjRZaGVkL1FTRGRZM05wd0F0Z3FmaTFQQWpwTVN4eVVJR3QwT0h6SWM4Wktl?=
 =?utf-8?B?blk1M1NtQlorMXFmaUk0ZWJHV1RLTzhVa2pwNXQvRE8rWGhyTkYxKzBLRklF?=
 =?utf-8?B?NGIzby94RXJ1Nk93SEQwZEZ2c0JJMnkzRTNlYksvZ3VjcFVvcmNTTEtIM1B3?=
 =?utf-8?B?QjFSMjFIenZ5TnJZTk5qc21adkdlVjNHQ1hXWVZua0ROMVc3eEVZUi90L2Qy?=
 =?utf-8?B?WEFKN3Z0Y1N2eGNkT1lyRGhXYTdFMW10RENwOVJDUXJWMER6djc1dU5WS0M4?=
 =?utf-8?B?UDIrd2ZsSlBvc2NTQ0JKV3NjVmdoZnAwVytmTnk3VnRuMyt2ZGNELzFSdkVp?=
 =?utf-8?B?Qm5zV0tBZEh4NWtzbkwwWW14bjRkeFBaRjFZM2IwSGdaNndqYkQwdldDQmtO?=
 =?utf-8?B?ZzBZWVpBZ0h5L0xncmEvKzlhem5qYU92Uk82a2hiL1dOVzN3MGxLaklkbVlN?=
 =?utf-8?B?UTgzQk9sYmY0U2ZIK05kc1h0SVBONGx5Vy8xZFBoTlp1WmpKSnNxeklvZ2s4?=
 =?utf-8?B?MHRRaEg4Q29OQ1RHQkpUczVOOE01ZmtweDRONXMwNUdLN0hka0pNZ2l4Nm5B?=
 =?utf-8?B?OFU4SDFQc3VGUktNZGxtanhRMkRQcVVodkVpUmxrTTNjbEhLUkxPMVdjVGt4?=
 =?utf-8?B?MUhKNUpNbEtMSEJXM05kdWxoYU9YejRxM0hjdGJKL092Q1VjNk13QUdLRzFJ?=
 =?utf-8?B?VnQwSDNqVlp0TDg4NWcweTBMWU5oRlY0c2UwNWwvL2thYVlyWldWNitvYWFr?=
 =?utf-8?B?QndZdkkvNTJHb0VESzhVWU82QVM1RHZsc3cxVEtHdWZsM0hpTDkxT3BLT2Ux?=
 =?utf-8?B?bXY0c0Q4TSt2ZVEwV3dwNFUwU1M1KzhlU1pqUUZ3Zk0vNEw4b3IrR1ZjbXVU?=
 =?utf-8?B?cDdRY2VSSXptUXlWSVRsQXE0RTNhdkhjSzFCSEZwWlF2cGEwSXhMa3haM1p3?=
 =?utf-8?Q?6saXT8SmxX9wpi/XcFvVnTLyNElgKO+vkQI6xzz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnM0WDhXWlJhRTdkMEI3NldDNnR0Vi9SL0NLNGEvWENYOGZ5dlRxcDBaUmJU?=
 =?utf-8?B?WEpuWk1OZ0F0VHFZUzVncUhvVTR1Um9zNjA2eWc3dVdZbkk0bnRQbkhxdEVE?=
 =?utf-8?B?bmNDeUw4YVNtcEhNU2RibXhtQUsya3pUcGF2Y1NvNFpVV3NOZnBZVVMrWDFu?=
 =?utf-8?B?WVFHNTc5MllVNzV1N1RhN0VkTkVtSUZLanV3ejZDakw0VTgyK1lOdUNQS1Ji?=
 =?utf-8?B?OTc2Z1VUdEl4N0V4dWlxcWg2RmtFUis4bzNLejFkNHV3NzltcnpJUlJ6SjJV?=
 =?utf-8?B?YUlJdm95emxDUUljU0pPcGlrQzdyb1JEMVdUK2lGMnIxTjZydW83WVdtYWts?=
 =?utf-8?B?SkE4N1J0ajZrenJodFFSN29sVCtwOWcrLzg3Y05Rb1NEbkVCdTV4aGFhYnRm?=
 =?utf-8?B?a0tOSTJzVjFWN081TEFIR1NLZHRycERITXNVSlVRclV6NVBtb3R4dnY2dTNq?=
 =?utf-8?B?KzNyN0pnYkZubUZnT2x4QzF5NWpmbWd6RXAzVUhtalRLNHd3TWtzSDNJYm90?=
 =?utf-8?B?SGlpcXRDMFFQcll3aFk5d3pOS0tmL1ZXSUw0NkZTN3hDWVYzTlNDTitzYmlE?=
 =?utf-8?B?TGt3Q1BwWk0yMHVGZlVRblVJTlRqcFVrbFZ5ZXRJN1MrQUdQMFRhZ2lDb0g3?=
 =?utf-8?B?V3pYNGxkVnMzeC9GaWY4OEhFYWp6QTNhK3l3dkJ3bzhYdFNkQ2VqaXVNR1gz?=
 =?utf-8?B?VFlqb0NNaVBqclU5YWpmcnhOdUNJelNBb0Z6R1JaUzU5QkVka0RmQTl2WDBr?=
 =?utf-8?B?VGMrT2FEZ2dkdG1CUUlRSzBsRTBTRHVLUmR5T2dhdzBEbXNDV1daWWFYRWJ5?=
 =?utf-8?B?dVRGVDgvRWl0TzFFSTExRjhSRytuTEhzZGl2aUxuMG82RzVQUm9CUlFncm9L?=
 =?utf-8?B?S1laV24ybU1idG0zeDZVak5GYlc0Y1JHT2s0RHB6eUFTSUNjZktGNmZmM2lE?=
 =?utf-8?B?VGIraXZlL2s0dzQzQWxJVzRIMGg0VkJTSFZSVzhJWG9OcCsvM3VMS1FqT1NJ?=
 =?utf-8?B?QTdiVWF1SG9GRjB3ZXp3aWNVZWJETGpIZEV6Mzg1bjhDNjBrVTgvMFpuVUJC?=
 =?utf-8?B?QjgzREt1RUR5L0RaTStkQ2Q2bWxseE11a2ljOHdtNUtYVTZMbEEwL0lxYUll?=
 =?utf-8?B?ckdhTTZPYWhGN0xOSXdmTkhrUXBtNFJzRStsRUxndW41MjF4MGpNUEhZN2N0?=
 =?utf-8?B?cEhzaXVFRSt0R2NRSDhnZy83YytsT0hNcTNlYXBvZlNXYk5mYldWUTE0Z0w2?=
 =?utf-8?B?K24vZTlFTWlHUjdTOEEzOHV6VWNOTkp3MjZBQUQ2UmRmTklVYmc4c3JlVWdl?=
 =?utf-8?B?ZWJZc1ptU0dJWDV5dlkrbDZ4QiszVWFiVWNBeVVhUVBIWGlhZWU5U002MWZt?=
 =?utf-8?B?UlFYbUFNTUlxNHE5bXd6NUhYcldIQmRqcXhCUm1RRmFyM0NsNDdGOVUyK3Fk?=
 =?utf-8?B?VHZyMG5mUGQxYnkzTmNpdjRBYXBKNDRWNXRrd0swamFLZzVXL2NDVnlaeXIw?=
 =?utf-8?B?ay9oRm5ScGMrRW9SeUoyWUNIWXNWVXptUDdkRXJlWVpFMjY5UmszNHhETis0?=
 =?utf-8?B?ZTJzeWoxckkrazJnUXVLMTFIWkxVdi9ZNGsxbzZHbXE2TkNIRFNDa3VUTG5X?=
 =?utf-8?B?K3hyZEE0bGVHN0lZbms5TEMxMDZLUUtLWW83WHpDaWRZbGgyS1RpdUJzSW1Q?=
 =?utf-8?B?Q1FrZTVMcjcxMzhzRUVtY2JVUHQzN3ZxTHd2N3g3ckhiVFJxNE9Fb3RlaVdq?=
 =?utf-8?B?TkNYZ0ZnR29yalpJTUlidlYrNjR2b3Q5VkFzZmtLUU9WQ0IrckwvQXJ5YXpx?=
 =?utf-8?B?cytKTUVqdjBlSzZjY0RjcXN4VFREOWtxS3ZnODd5TjJmbmt1QnJWVHd6ME5k?=
 =?utf-8?B?V2JidFlsUm1ZSk5tVjRmd1VUQVlIeWF1Vy9xcmlVRWJxdTlodjlMUksvTGtD?=
 =?utf-8?B?QVFuK2hKWkl0RERqWXp2cjBPZlR5RUNrUzVDTGFRK0p5cG5nUUQvZlJ0Q3Fr?=
 =?utf-8?B?WDJjVkN1SFpqM1RqSFZ6c3lVK2FVL1NjRjJlczFOeE5pOStFQVR1MkVLRlll?=
 =?utf-8?B?M2VIVFU3cDB3c1BUUGdlN3k0UUZ6ZUc3UEZGYlR5TTBEdUNhWjdJd1hIYm1h?=
 =?utf-8?B?RUpxdHdyV3B5YWs5bXprQ3N2QVRtNFJ0VHVoL29jYW01S2FCaGtsZ0VVdE55?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc412db-da40-4a72-d358-08dd03671dc0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:12:37.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eV1alTXtktbgOho95k48/B6Wo49xL1MUznoC2a0/7asXFFI724zbxtaKHFdwxmrPMXQdye1qnccU0Pw+5tK/NMu21CmiCoJ6q4TWtCm1K7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7966
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/24 10:28 AM, Tony Luck wrote:
> When the mba_MBps mount option is used, provide a file in each
> ctrl_mon directory to show which memory monitoring event is
> being used.

Could the changelog be expanded a bit more to inform reader what
the monitoring event is used for?

I would also like to remind about the expectations documented in
"Changelog" section of Documentation/process/maintainer-tip.rst:
"A good structure is to explain the context, the problem and the solution
in separate paragraphs and this order."

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h    |  2 ++
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 25 +++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 17 +++++++++++++++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index a6f051fb2e69..5f3438ca9e2b 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -609,6 +609,8 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
>  				char *buf, size_t nbytes, loff_t off);
>  int rdtgroup_schemata_show(struct kernfs_open_file *of,
>  			   struct seq_file *s, void *v);
> +int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
> +				 struct seq_file *s, void *v);
>  bool rdtgroup_cbm_overlaps(struct resctrl_schema *s, struct rdt_ctrl_domain *d,
>  			   unsigned long cbm, int closid, bool exclusive);
>  unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r, struct rdt_ctrl_domain *d,
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 200d89a64027..b9ba419e5c88 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -518,6 +518,31 @@ static int smp_mon_event_count(void *arg)
>  	return 0;
>  }
>  
> +int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
> +				 struct seq_file *s, void *v)
> +{
> +	struct rdtgroup *rdtgrp;
> +
> +	rdtgrp = rdtgroup_kn_lock_live(of->kn);
> +
> +	if (rdtgrp) {
> +		switch (rdtgrp->mba_mbps_event) {
> +		case QOS_L3_MBM_LOCAL_EVENT_ID:
> +			seq_puts(s, "mbm_local_bytes\n");
> +			break;
> +		case QOS_L3_MBM_TOTAL_EVENT_ID:
> +			seq_puts(s, "mbm_total_bytes\n");
> +			break;
> +		case QOS_L3_OCCUP_EVENT_ID:
> +			break;

Having a value of QOS_L3_OCCUP_EVENT_ID would surely be a kernel bug.
What do you think of a WARN_ON_ONCE()/pr_warn_once() here?

If mba_mbps_event is indeed expected to have a value of "0" to
reflect "uninitialized" then it could also be handled here
to catch any kernel bugs.

> +		}

The custom is to return -ENOENT if no rdtgrp.

> +	}
> +
> +	rdtgroup_kn_unlock(of->kn);
> +
> +	return 0;
> +}
> +
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 5034a3dd0430..3ba81963e981 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -1943,6 +1943,12 @@ static struct rftype res_common_files[] = {
>  		.seq_show	= rdtgroup_schemata_show,
>  		.fflags		= RFTYPE_CTRL_BASE,
>  	},
> +	{
> +		.name		= "mba_MBps_event",
> +		.mode		= 0644,

Please only support writing to file when appropriate callback exists.

> +		.kf_ops		= &rdtgroup_kf_single_ops,
> +		.seq_show	= rdtgroup_mba_mbps_event_show,
> +	},
>  	{
>  		.name		= "mode",
>  		.mode		= 0644,
> @@ -2042,6 +2048,15 @@ void __init mbm_config_rftype_init(const char *config)
>  		rft->fflags = RFTYPE_MON_INFO | RFTYPE_RES_CACHE;
>  }
>  
> +static void mba_mbps_event_init(bool enable)

fyi ...
https://lore.kernel.org/all/237409fb566288d9f3dc7568385e6488b62dbba0.1730244116.git.babu.moger@amd.com/

> +{
> +	struct rftype *rft;
> +
> +	rft = rdtgroup_get_rftype_by_name("mba_MBps_event");
> +	if (rft)
> +		rft->fflags = enable ? RFTYPE_CTRL_BASE : 0;

I think this sets this file to be created for all CTRL groups, even when not supporting
monitoring?

> +}
> +
>  /**
>   * rdtgroup_kn_mode_restrict - Restrict user access to named resctrl file
>   * @r: The resource group with which the file is associated.
> @@ -2371,6 +2386,8 @@ static int set_mba_sc(bool mba_sc)
>  			d->mbps_val[i] = MBA_MAX_MBPS;
>  	}
>  
> +	mba_mbps_event_init(mba_sc);
> +
>  	return 0;
>  }
>  

Reinette
