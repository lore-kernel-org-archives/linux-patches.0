Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816A7404E
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 02:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027646; cv=fail; b=ES4kXtBsMRed2z/lO2gaQXGVnURBABQmv06WVjV4Xf2XjP4jf+96VDbsLTkQoflED1/jLwYlxjS83ilhOonhHMcfVduxje3lJ/BZX9ZBCjjyVxXvIB3zpJAlhnXm7KY7tfMQltlLrlbpCCn6MfjCMFtrqbf239zfrs2Ecmf7ijY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027646; c=relaxed/simple;
	bh=7GrBMR0SY3jVWX/RQmyj0/oA0rdnZfethbh+ifEgER0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RYKbf6bEx6DwbZL9oXIciuC4Ouk24V1ftAPF1oetv8HSt6ykIXSt7BIWtsnM3dSx4O5xlUUt4ND9QkaXRgUtt7pNmHt+mdsufnPFXxMdBoBsBhb08wDXmpNaLVJh8C8JSSMTrgPfccnRfbgnRUJ+30uI792SCcW+1cRtaBvjoX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JSkpPPXM; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JSkpPPXM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752027645; x=1783563645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7GrBMR0SY3jVWX/RQmyj0/oA0rdnZfethbh+ifEgER0=;
  b=JSkpPPXM3DCI3k04HljwQFdEeGwxcZp1aZcANr0TQIOredNoRLVJWyvT
   D+aTkr2MmYdCFkY/4OTpV/q679+VhmzBlfJSro//sd7QCi4hhhc8zCgL9
   Y+2F0Blsq5+0WftzsAR0zfWksCakDoo+9VS9tHoklV3pMrlkM7RRJeaiV
   JFAmXCA0onCzqXAhIyzBp01pzF8UnLh4Pa9aXZdVmEdl/+XIZ1G8QXUIc
   Ln/Ux24CCQgBhzk6OrtdYcwOz8ko4zh5/AEUSNskUu8LeB4vxKno6+aFi
   ClOnHJCzBiuO/VCb+hE3yQ82NHnrz0Qd2ifzgzhVzPAon/R0VGwlGJPo0
   g==;
X-CSE-ConnectionGUID: LGm8FthKT7O4eBZ59xrsTg==
X-CSE-MsgGUID: AthaUUohTt6yKlbXFQza0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54421473"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="54421473"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:20:44 -0700
X-CSE-ConnectionGUID: xMWgXfVXT+qjWX+FZKDH7A==
X-CSE-MsgGUID: f8hML19ITlm3oC+bh4HiaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159910746"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 19:20:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:20:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 19:20:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.88)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 19:20:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CAVx8J+5xrKjGmbIQrMoJxjPjE78RF0YWGew/UB8xzhXN3CD3H/o6OWkzrhaPO4SLs5xW2lvABW7ua1ds9o8E9R12xuA2SBmZZScwIbz8Nf+auvQcXKX+JhiAMmmJ57uTXe1SKL0DIYtC1WyGgpGiFLlK3sb1sN/1923EPCrXt2/DdhyCLdsp49/ds6owwVbdVP3TfINap91MLzolpNcuq9fzvrAYZCsUGcqPShzlI4DlRQbq1JwcDRUVZ6gTPPcOeW0rcBQY24c4ICBliPl6jHs8fGJYNpD6vL0sqbLN5r/n0MvsfWSObfFV50LsKkPfmqiVF3jdiUaPMUJprf7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5euruHmaaQEStAfsmUj4fn+0B6ANBjteGnBryAI2pfQ=;
 b=d8SNnYrDALY9s6Kj8WRMprj7zetj3oUC1HQeKzSgbhRCxXne/AU/6IwV8IgadmtynanTGcFX2hSEhEFunC+79HEHkGmCJZhQZQBzjRC+jsRGKGNss53EC/iXUT2lpN6ByS4oqf9BafALBcqAgOEAWybSmdqcbLyEMbgbenCEM388IVIQSQWV1o1UNvfWzspfLbTOrwJHJTDbJp3Siip1UGUluKbmJJJSTWOOIvliMNTlVOBLXdV7tCnb03c0G4MZTrHVOYRCGOUXCiXFJyok3ifH342EJ8HQ8/YI3Wn7/2HOPGVxzNeFlZanSph9zHvVUfKkEU946Xb1x4xHp1g/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 02:20:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 02:20:37 +0000
Message-ID: <69f18b65-4e20-4383-a559-46fe1eda7db0@intel.com>
Date: Tue, 8 Jul 2025 19:20:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/30] x86/resctrl: Count valid telemetry aggregators
 per package
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-19-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250626164941.106341-19-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b615a8-8b98-4df9-4b9b-08ddbe8f3169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cGR1eGVzc0pKSDFyRTc5Znd2RmQ0cE4xamh0MnBjYWdoVHd1WkZRYUhUN0oy?=
 =?utf-8?B?YSsycHdzV2dGbXgzbEZ1cjg5aEh3c3d0UStNTXJlS3MrRGNvQXhtZDRsMnR4?=
 =?utf-8?B?SnU1U3lkSm5tN0oxd3JqRkhmUFZVbVpyOUFtRFFLZWszZHNIVU5vd2lJa0N4?=
 =?utf-8?B?UFZ4a0dPd1VBUUp1QmhudnIvV1ZKUmVrRm03ME1NYW1IODV4Zm1iYkl0MXEw?=
 =?utf-8?B?ZEJEcDBMNXpkZEo0MzIyOG51OW5GTnBnNUpBa2krN0ZyOGhsU2VKQzV5eEtS?=
 =?utf-8?B?YTY3STN1YUQ3RHpRUEsxNUVTTndxREdWUmFDOTlocUxrdVZXZCtmb1NPVDR2?=
 =?utf-8?B?N3ZPa3ROSFhkOSt1YlZQcG1FdEVYTmRCUTR6SVJmQlU5QWNPRW95QnZkL1NG?=
 =?utf-8?B?aU0rdmo0MC93LzRySXE4NWowMFdseVN4cmh3YWFMUlA3ZEkrSUl5MXdtblRL?=
 =?utf-8?B?S3VXendWbGRXaEZSalhxamlTdGx2OEc3Ull0OWRrbEI4RXFkaTlPYlNYbVc1?=
 =?utf-8?B?NHNETTI4NnB2bEl2aWl5aFd6UGRrT0JjZTdSdStyOGkyUUlJU0ZUUXlPNWR0?=
 =?utf-8?B?aVkvZms2SXB3SWZYTkFQWGdDWHRDV2EyMFR4dERSVUU0d3ZvZnBDL1R5cW5q?=
 =?utf-8?B?dUpxN1c1cndsb2FMQk01MUdLRXprS0JsaUVuWXc0WG9MNlNQL3JVK1pNd0JU?=
 =?utf-8?B?RVdJZ3l4eGJrWVQ4R3pCWlZKOFZEcW4rQ1lEb0JFcHYzemRuR05Jak5GdFph?=
 =?utf-8?B?VTI2OEpyamZZaGhqY2MrWU9wRkRXNlJpQlJNOStJdEZEbnYvY0lscDFQWXBs?=
 =?utf-8?B?N2x0dnJDMndNRXIrSEoxc0ZuMk9leGRrNjQ4MHZQdVNCOXo4eFhtTWRvM0Zi?=
 =?utf-8?B?VkFSUzRrT243RUplUHVvZXVuaXIrRU43YWc2Tmo0MDRZNEJ1cDdocWVnNk9v?=
 =?utf-8?B?bWlmdi9UYjVyaUdYRTlaU3llRVBuRktEMUs2TCttNDllTEFnVmxINGdQMjJw?=
 =?utf-8?B?TEdPVFdIVmdMWU5GckFkSXFrVE9MWnJucE4wUFQreWUvUUVBc3plSzNVb1dj?=
 =?utf-8?B?clcwVnV3VEZYcjFXdHdiNnhSdDlteEFkKyt2M3M3OUxRSzZwcE51UkN4Nm9D?=
 =?utf-8?B?MkVST2ZYSzRBVVExK2UyREhjYUV5WWZGaC9FUVlDTjNVVW9JNnMxRzBGbHIy?=
 =?utf-8?B?eGtRWEJuZVFzV010dGhSYllKc2lLNitkckdwSWRUaUQ1aHJlV04xRXRXcVBK?=
 =?utf-8?B?QXorMDVITVhsSC9SWERHMlo2VWxCZENIdDZrS0FHd0pXR3BjRTZoekh0MXhH?=
 =?utf-8?B?ZHFCdms0cExSNE9NKytEaWtuUmp5clY5Q1BYLyswTjVWMmVTYXFpR0RSYnNi?=
 =?utf-8?B?Zk1ZOE5pcHhWS3gwQzBFWmhWMGJDSGNVSjB3RjJyVkJkWG1GUmJlOElRcHZ1?=
 =?utf-8?B?QXR4RlNZcXNxemZ6eXlkWmRERDd5S2dTMlk1Zk5lNzM3UjdPN1Yzd0QzbVFP?=
 =?utf-8?B?RG1teC9OVjdUeGxwWE9QcHAzbjhvUGY2ZVR0QmtWQW9QUVM5ZitRem5UWXF1?=
 =?utf-8?B?WGFOM1RjejY1YjJlTGZWMmFaQmhHRlZMTHg4c0tUdVRjQlpLbW9RQlRURUxN?=
 =?utf-8?B?L2FaYVBTL2tpbm5mbWV5UjNxOGJyWDRzSmEzSHEwalpJV1FsRFlzeXZCTDRO?=
 =?utf-8?B?eEZncTBwU01ZL0JCaG1MY2dEU0JSQ0NySWJqSWpSRFFrODNlZk9paFhMZUIz?=
 =?utf-8?B?MlZxb3o5a0RGSlFoR2lQZU1Sdi93NTFhN3UvVVRsWGQwL2ZCcVJySzI1RkZY?=
 =?utf-8?B?WjMrd292UzQ3UFhKSWtLcExSaE1CcjU5VmU2bHQyczF4dlFTOWxkSis2TTdJ?=
 =?utf-8?B?ZDlzQmEzeXIreThlSk8rZVlYYmd2N21VT0F0Z2N3VXI1RC9qL0ZNeEh6QkJK?=
 =?utf-8?B?ZFZzUFc2K2s3eFpMNzZPOHU2aUhNYWVnd1o2bEd2ZjlVdDN2ZHUrRGluU1RX?=
 =?utf-8?B?RTFqQzk0ZTFnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THEyYXJrT1UyekhubWM2b3JXOUZqRDUrenRqRmIzT3ZDMTNxbjFHVTVzZHdC?=
 =?utf-8?B?U1gySkVBczVWRlpSL1V3MFNwREZSeXpSUEp2M05KZGllc1V5TWw2eXBWZ1hp?=
 =?utf-8?B?alVVc3h3Ryt1c2NiZjV0bkhiU3VZVWtUWUtoYkhvbyt1ODYzNTdOdnpXRm51?=
 =?utf-8?B?bVc1R0xoVStrSUw1ZmppSDhHWDNqNmgvOWxDbkRPSDZXb21xYkJtejVKb2ZF?=
 =?utf-8?B?eWZVbnkzbDY4RnBRQW8xdkFmM1k1OHJFdkVlTEU5VVhXTWttYVkwZXo3QXdo?=
 =?utf-8?B?aGNraVA4WlFkc1N0RTZYOXVBYXV0SlQ1UTUvNHdVYVUwdmpONkNFb0Z2VDJq?=
 =?utf-8?B?UUp5ckdBMHAzZC8yYVYyamxOQlpCVHJGQmY3NlQ5VEhIK2NzRS9oVGgxTHMy?=
 =?utf-8?B?Q3NkTXA1SjBmTXZLSTVXUjhFTW95OU9SVkZRdGpOSEx3VmNta3FKNjRoWkxX?=
 =?utf-8?B?V1FHN3kvNE80bXM4VjNBNGJVYnlFSXVIWnl2OTlvaTZWR0l2bzJyS1pjNGZy?=
 =?utf-8?B?dmFDRS93ZkxjSmpicGhxb0U4ZGNHWkxUWGYxYXIvNklKT0pyeVp3M1lkTllm?=
 =?utf-8?B?UTdpdEEzOXp0bzU5T2Zuejl0ZFFndy85ejdidS9FN3JkQm1GR1J5Q0k5c25l?=
 =?utf-8?B?aG1takZPNExIN3lycUgxZGR1dzVydGc0eDUydTFvSDFYZ0VXMi9Rek9wL0JH?=
 =?utf-8?B?Rkt1MlNMaFBuNDJkb01QNFp5S0RlTkRnaXdMT3pvSm92Rk9obmlwUFdXZERs?=
 =?utf-8?B?aS9BaVN6U0pMZkttZGtJa1JiYWNPZW9IcFhCcytwb2FEbTBSZ2JaUWtXbnNP?=
 =?utf-8?B?TnAvekRURUxuOGFCVTNlQ01Edk1ZSzNVb1oxYVJNQytMZ1VwVGEyclpoQzQw?=
 =?utf-8?B?SGU1aDRhUU5RQUFaM0NEZlY4UHIyaS9HKzJyT1ozZlVSeWRyQ2lNL2hIcjBz?=
 =?utf-8?B?c3A5UG11dVc3c1NKZ0YyTWQ5cWt5MzFRdVVJUkJJU1IwT2JFeFNIMVRFS3J4?=
 =?utf-8?B?UFB5eUNhbkpVamVIMFlCQytHMzZRK1QxM2oxTCswQ3g1OGxmUkR1dDFFMVFI?=
 =?utf-8?B?UDhDaHhXc3o5aVhLNVdqc2FoMHdiYmJLc2VkZDVUeVU3SFppK0JwQWZ2clVv?=
 =?utf-8?B?TlB5N2JXOERpWTEyQVFoNzdhSnN1bUUyS3ZTaWJQWnJEcEVXWXlFenBHR0lI?=
 =?utf-8?B?c0RMdFh0bmJzQ0V4TG5leTJEcjhLeDc0T1AzeUd0MUQ5clVrelcwSi83cXM0?=
 =?utf-8?B?TnVOQStGamNVSlhkVDNRU01iRmtPS2wzaDlKcDFkMWhwNzR6azhyMHpzd215?=
 =?utf-8?B?WlhVL1BWNGErSmpKczljdlNPVXcrZGdNY1dYK3pPSDNwV2Y4bjhLd1ZiWDJ0?=
 =?utf-8?B?Z0NTUXFGenFCM0ZhVFJORW1aYTZ3YXBIakpnbk0zOW9zL3l5MEVSTDN4Nk4r?=
 =?utf-8?B?a3lsb3lZOUdVam1lU2V4d293Y2tScE5kMVI3Z2tpdDcvNWpjanBmcy9sZ3l1?=
 =?utf-8?B?N09XSnRDODd4SFcreXJURWgzS1NHeGEweTd4RnRXZ0ZZVlROUFZOM281YVVF?=
 =?utf-8?B?MXVUS092b0RyTnowZmY2UmQ5VzRSckhWb1ZlSEt0QlIwaW9UQlZueTI1WEZJ?=
 =?utf-8?B?RUZyYW9TejBwK3FuZlJvVU93SlMxVHhSNXo2bHFkTlRLVDB5NFNFOXVKTVli?=
 =?utf-8?B?NVpTeVl5bWVuMWVybXQvcFNDUVpPSDh2UDJ0VG5ZSjhBQTFxQTZxNmxFTk9Z?=
 =?utf-8?B?czVpLzhRcHhNOWs0bHUvQXFRVjlENjlCbi9naU16Z2VXZk5iSE5nV042bU56?=
 =?utf-8?B?ZzlkYWowanpsYmswVE9xcjcrRHNTY1N0Vktvb1owZy9yZUR6dEZ6aklwZmh1?=
 =?utf-8?B?U1pDUUVQbDBqWElDdTVkOUllOEVJTzdYMmFxcVZIQkZqMEEwV1k0WHVHUTJ6?=
 =?utf-8?B?eXZ1eDZrci9idHk5eTBjOEp0QndJblBmUmhCUGt2ZWJoamNuWnhUR2h1ZmFs?=
 =?utf-8?B?M2FyTWZSZ2xxVGtkZHlDdGxWdktBMU5MUUhqUjR2S2ZjMCtmM0gybVRlWlFX?=
 =?utf-8?B?L1BudlNNSWRveGxvZ3Z1YzRreFViL1hsdzVYdjVPSmNLbHprUWJhZVNqWFU4?=
 =?utf-8?B?T29WMW40Zk1UNUFMYk43MXNGYk51VW5SaG5kMkovS0RjQkp0S3ZPMmRGaFVP?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b615a8-8b98-4df9-4b9b-08ddbe8f3169
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:20:37.6983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AN2AIyY4Vhr9lUlW646Lux62QZjxKGwkU/F1LxfYeRT0R0DIrJNQ2wWNdalys2N4mt2u9CoRIOQ9iDcVrB4pTdCmcjH7zwubhTv0IcBRn2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> There may be multiple telemetry aggregators per package, each enumerated
> by a telemetry region structure in the feature group.

This is the valuable connection missing from earlier patch changelog.

> 
> Scan the array of telemetry region structures and count how many are
> in each package in preparation to allocate structures to save the MMIO
> addresses for each in a convenient format for use when reading event
> counters.
> 
> Sanity check that the telemetry region structures have a valid
> package_id and that the size they report for the MMIO space is as
> large as expected from the XML description of the registers in
> the region.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 55 ++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index b09044b093dd..8d67ed709a74 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/resctrl.h>
> +#include <linux/slab.h>
>  
>  #include "internal.h"
>  
> @@ -24,6 +25,7 @@
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
>   * @guid:		Unique number per XML description file.
> + * @mmio_size:		Number of bytes of MMIO registers for this group.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
> @@ -31,14 +33,19 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	size_t				mmio_size;
>  };
>  
> +#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status)	\
> +	(((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
> +
>  /*
>   * Link: https://github.com/intel/Intel-PMT
>   * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
>   */
>  static struct event_group energy_0x26696143 = {
>  	.guid		= 0x26696143,
> +	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  };
>  
>  /*
> @@ -47,6 +54,7 @@ static struct event_group energy_0x26696143 = {
>   */
>  static struct event_group perf_0x26557651 = {
>  	.guid		= 0x26557651,
> +	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  };
>  
>  static struct event_group *known_event_groups[] = {
> @@ -56,10 +64,53 @@ static struct event_group *known_event_groups[] = {
>  
>  #define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
>  
> -/* Stub for now */
> +static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
> +{
> +	if (tr->guid != e->guid)
> +		return true;
> +	if (tr->plat_info.package_id >= topology_max_packages()) {
> +		pr_warn_once("Bad package %d in guid 0x%x\n", tr->plat_info.package_id,

If struct event_group includes the RMID telemetry feature ID (see below) then it
would be helpful to print that here.

> +			     tr->guid);
> +		return true;
> +	}
> +	if (tr->size < e->mmio_size) {

Why not "tr->size != e->mmio_size"?

Patch #25 explains how tr->num_rmids may be smaller than the number of RMIDs in XML file
but from that description I got the impression that telemetry regions should always
support all registers documented in the XML file. Similarly, in the earlier "fake OOBMSM"
code the MMIO size of the "energy" MMIO size could still accommodate the 576 RMIDs while
the regions were configured to only support 64 RMIDs. 

> +		pr_warn_once("MMIO space %zu too small for guid 0x%x\n", tr->size, e->guid);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Configure events from one pmt_feature_group.

"Configure events" -> "Discover events"?

> + * 1) Count how many per package.

It is not clear what is counted here ... first sentence is "Configure events" followed
by this unspecific "Count how many per package" that can be interpreted that it
counts events here ... but it is actually counting telemetry regions?

> + * 2...) To be continued.

This comment implies that as capabilities are added to this function the comments
will be amended to document these new capabilities ... but at the end of this series
this function comment still reads as "2...) To be continued".

> + */
>  static int configure_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> -	return -EINVAL;
> +	int *pkgcounts __free(kfree) = NULL;
> +	struct telemetry_region *tr;
> +	int num_pkgs;
> +
> +	num_pkgs = topology_max_packages();
> +
> +	/* Get per-package counts of telemetry_regions for this event group */

"telemetry_regions" -> "telemetry regions"? Or is it referring to the actual struct
here?

> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;

The function calling configure_event() does:

	struct event_group **peg;

	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++)  {
		ret = configure_events(*peg, p);
		...
	}

As I understand there is 1:1 relationship between struct event_group and struct pmt_feature_group.
It thus seems unnecessary to loop through all the telemetry regions of a struct pmt_feature_group
if it is known to not be associated with the "event group"?
Could it be helpful to add a new (hardcoded) event_group::id that is of type enum pmt_feature_id
that can be used to ensure that only relevant struct pmt_feature_group is used to discover events
for a particular struct event_group?

Another consideration is that this implementation seems to require that guids are unique across
all telemetry regions of all RMID telemetry features, is this guaranteed?

> +		if (!pkgcounts) {
> +			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
> +			if (!pkgcounts)
> +				return -ENOMEM;
> +		}
> +		pkgcounts[tr->plat_info.package_id]++;
> +	}
> +
> +	if (!pkgcounts)
> +		return -ENODEV;
> +
> +	return 0;
>  }
>  
>  DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,

Reinette
