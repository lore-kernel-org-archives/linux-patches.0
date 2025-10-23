Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069BE2741DF
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 04:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761192509; cv=fail; b=GrRKNLavrE/hg+dvhoMeoHVpHn6bgb4ZX4u5z9JOIxAaMXZxd7cWGYUezyXE4+30SgjXH7NcufF/9XEly/8AAtRGwMykEPVuDMBVLzvyFng3B+fXUVZ3EuIfQCDJceRfnXSMsTvU6kaxsbqBFAfgaOwqSj18s0clVweuiMj33R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761192509; c=relaxed/simple;
	bh=Ti9pIKTDOsNtpOhnR0TVvMbCk5owp/hNXttSB7pzWKs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EqG95VcmBnp+rTpt8Yw7suVwbT+AkwUTv3Wah9UeCjbfC39bn8oMpBJ4LpkjeWPFRuBRKZcf22y9bmvUIOINCVM15RLKx18rGCVllc88aQrf0CImhFw5/Y1KrIodhnRP5r5JfJecrBpGqvOafjaf/EGi5Q4MxT/XpMzGP1b8nDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8R7HRes; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8R7HRes"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761192508; x=1792728508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ti9pIKTDOsNtpOhnR0TVvMbCk5owp/hNXttSB7pzWKs=;
  b=W8R7HResjCmTZz8Qx2u0OeJDqytAt1w4N5ToW/XEJDjItqf/sYEkGUj7
   P/RvWff61im8bPxPhXn/0l5Ydz0ziRFaUyHKgpIvZI4yzRYvH1QgDxW3B
   /suNkxJArn4uslKWoCLme5OURyF+bX+oCLLtMsxJ4B4cDMKTG5nyPYXOg
   p7Js24Qvq+XDTnHaibkxVzpAWs8HL5L5a+szBFJ22pWcetScROjJJIbHN
   Lj/LVGX2PjwPmr/EqZrgawnQ/bSmWf6IAjrcN1Mdm5F2q/KRPXIW3DJ/7
   fTXivfSe0R+CijvPpim75NANuztDwaBMbF6yMDV7r/R9s7y2RwjjoGQnG
   w==;
X-CSE-ConnectionGUID: CaPXlNmvSqS4kAYU35d3vw==
X-CSE-MsgGUID: jhza1LudTJW0HGWz2eOfeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63260894"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="63260894"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:08:27 -0700
X-CSE-ConnectionGUID: gZgmchF2QZWM6g3ZNUuvGA==
X-CSE-MsgGUID: 6qXhr2wBSBa6yCq8+rFCSQ==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:08:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:08:26 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 21:08:26 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.3) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 21:08:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJMDOrpyHHAmiY+Y1B6yHe1aW5F+PapWqsb40SluQkN7obtOj4lHEuYLYFx1aB/f3gN3qSLPWfk3e3ZSvlVZ99EcRxDP6EjQwYypbOpGP4lCQodEsh/Ot3A/riKZae/yZQz35pyRa56T9XvBRGhMD19yvQQZ1GQx4T4w1dhL7bUY2OPIl/UXeoGpHYjZWHJb6ISYTt0DT33vZNUkD+7s4bTXXgh0EdFqmRmQwSCLX7lQC4Z7TD/ZUeDRjJRvZIhMcrKPvWABqIwzYuQW7nDNEExwkDhXDkZyCEHG/aYGTLetlIhTqxIGXxN9IKgs3z/EOfjE8RfxInL31SdDPWLAeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPuJcesGNKchElryABqGcbY8Al1qIOHpL92Y2x7ZUXQ=;
 b=a/Y1B4LPqaEvm3JPv3bG8bszLr5zgobLA+W/0ciBkdcukNphXq40q4W9caV+SdS2DsBwFNl21dDVXDykTD5LVUES5+aBXOk9Gq92CvAqVuHhstAg2xHBx1S5gyPYbBlkpoUcfvsvOfIgvVRfkfNrkaSpGEYv+ek1L6FYk8Wrqt/hawanMsUFppR7qJ0RAaUhB+SMi1j+l9o53kk5xlXKkdLnJf9/7KGC2Zk6meA7K0uScgtfUgaWdnfMLiRpmktw3HGRw+1C4K6VHmhm7d1Bz0RyfQCXGis2bAiAGpF+6iD1QdGo1pzOE+wbo277KoG+IRZ0Vtj+fL8nWFNj0O7P9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF267298081.namprd11.prod.outlook.com (2603:10b6:f:fc02::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 04:08:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 04:08:24 +0000
Message-ID: <4c8489cc-fd64-4497-b6c9-282e55627b13@intel.com>
Date: Wed, 22 Oct 2025 21:08:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 03/31] x86/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:303:dc::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF267298081:EE_
X-MS-Office365-Filtering-Correlation-Id: 98774035-d0e2-4674-d62c-08de11e9cfe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWc3dmdXbUtUQTNway8rV0tTWXR2TFBuSDhvaG0wYnRodGViYW5pMEh0YjdP?=
 =?utf-8?B?czEya0dtdGlkT2ZqZzh6cEVHUExUcE1kYWpKOUZJQlgwMEdZc1J6dGZwQTRz?=
 =?utf-8?B?bCszTVZQZldMNWZPZVRkNDRmSlMvZ3AyckliK05TZW9yby9TdHZqak9tS3Mz?=
 =?utf-8?B?UzhDK3ZTL0lzNEdlUVRwdm1nTGRneGMzQU9wY2JDUXIwdFladzdmM25ZNmpJ?=
 =?utf-8?B?YXZ2Z3Y2UDJtNkM0bmFRRUlHWFh0VXpZdU0rQXVsYU54MEtMQ0lHUlZZckVT?=
 =?utf-8?B?Q2ZHamNNUStDTTBOMjBPRjd4dU5tNHRKVU5VYTNTUXZlUVAwWVRqNkpCWm9j?=
 =?utf-8?B?V3k3aGNaUDhjOGQzK3JXN3RJUGg1dy9SblkrcnA1RC9vWjM2S2VxOUpJTk9Q?=
 =?utf-8?B?RTZidUNmcFZGYWhNc1JhbDBxcHBYbmtRVGpMSi9OOHJFelVQVDI4S3BYOEhY?=
 =?utf-8?B?SFpzaDJsWGptZzBhMzlOYzNBaVdmVHdTSUdVZnhVUDREZXZXNDc1UXRWM0Er?=
 =?utf-8?B?S2pLWHkyVkNFa1lNWUw5bUxYOWl2L2V3Vzk1L0hRUnJJL2tjMk8vbHMrZHls?=
 =?utf-8?B?MmhzamUxSU5FVUVaWHZ4SGgwOTA0VjhuT3JqS2t6Z0t0LzdEb3VMWVR2Yk9Z?=
 =?utf-8?B?TmtjK0d3WjRScThWS0N6c09ZTzhDMEdsOEMwMTlFYmIwb25HWTVBb081aEJm?=
 =?utf-8?B?aW5uZmdzQXFHa0pRbUJScE8raUlzSGFiYUpqbGlTNmNIOEVEMkVlQXRwUDU4?=
 =?utf-8?B?NVd4WmlqUWY1em9TT0ErSHE4TXpZTXVHa05TM3kwQVZCVjU2SE9sVC95dko2?=
 =?utf-8?B?OFk4dHJXK3lXcWkxRlRLSk9iU1BHREFqT1lrdVd2dUoydUYrRExBS2tjQlB4?=
 =?utf-8?B?cTk4NlRtbmI3dHljVklPRVBmNVJoTW9PZFhsVGdMVnpyU1NXYUpyYmFZZ3J5?=
 =?utf-8?B?T0wwcTJDb1pvTXB2OEQxUHE0TXlPdnA4Mk9xWUp0K1ZQM2FYWStUSnR0Y0wv?=
 =?utf-8?B?c3AyVVhGS3M1L203L1QwckUzR0JDb0k0NFdYVWJzN21LbExpd3pqdFp5Y0pl?=
 =?utf-8?B?RjZaaU83R3VUdGlvNWUybGwxWmk0VkQ4OEw4Y3QxbnFDTm54aDViQ1VtWkRD?=
 =?utf-8?B?L1pMZkxnL3M3Uy81WFVEZEJhREhFNVo2UTFkYUVoYlJYOURxZW1qME1IRnVK?=
 =?utf-8?B?cGtqckMreUZpNWZydFB5MnJISTNONVZxdHZRTlhXcGpqTm9RSnRaa3lCQ2Vi?=
 =?utf-8?B?dUdMRlJGYTBnTWs0WWdNQVFnMnBZak1OMlNTc3ZVT3BzL3V5MFNZbUR5ZEIy?=
 =?utf-8?B?aWluYlM5c21kWG1lNTlDWnJSelU2YThCcFZUVG5DcDI5YUY2YUtEYjJzOVZS?=
 =?utf-8?B?ckNORVFIVnppemdDLzZtUS8vdDgrbFZQSyt3OTBzaklCMzQrR3ZEaDhUVG4y?=
 =?utf-8?B?U2JRd1FRemJJaUtZa0hsMk9HZGpPV0xvTVhwV3FjTjhyUHdEeGUvMVN5UWJp?=
 =?utf-8?B?K3dBVjRpS0l3ZnpFVkYzNHF1ZGk0OUkzL1JUdjlGNUNhbWZBSkdhdENSY0RN?=
 =?utf-8?B?WUlCUmVVQUVoeW52RGlsZEhOdXM2ckdlU2FEb2ZxR1N0ek5WYXB4aUpkVGVP?=
 =?utf-8?B?ZEY2UTZXSE5wbUV5SXFaZ3VOaGRpdXNxUU95OGpvZTdiWEtJR1RrbHliR0JD?=
 =?utf-8?B?N3k1QktqaUVnc3NxUk5SRWVObnVQZzAwMGNUcnF5Z05ycWRIeGFnblpNaExr?=
 =?utf-8?B?S1d3MDVnaGd2R1V4eDJ1ZGVKQnJFMGJYalZYSGNyTzdZUjNmVTBVQUpxVmk4?=
 =?utf-8?B?LzRCS2hiNTd6VVBtaFhoTmdydk1zSkIyYTNmbUx4VGRCWHNGMkI1QUFqYzV0?=
 =?utf-8?B?dElqZmdMK0lYdUpNQWkxbFRZNjgzYk5Qb0FLU1BzcTRmaGhKTlF3bEY3OWs0?=
 =?utf-8?Q?jsC1dBZmZLQ+QigQAykyxFPmKb6od2px?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFFhWEEyaDlEMmJIRjM0RS9mMktMVzNXdnJnWlkrU2FRTWh2YU1XMDRWYXRj?=
 =?utf-8?B?TXhWd1JKNjZWMWhLVDRLRHMvTjVyR09OM2hXMjJnTVFWUlBjb21aVTZLSXZk?=
 =?utf-8?B?cHArVnFnVjBhYkZZeEw2b3FaZmRKc2tUNE9xOCtkK1dRL2ZadUJTRW4yNjdm?=
 =?utf-8?B?amxsSFhRVDRld0tTT3NFeVpWYWIvejhOT3NDVjQ3VE1uenMvemdHUUlsTnFn?=
 =?utf-8?B?K25LZlIwRG42S2tuanZsUHpoQWFtTE4yeURMV0ZMM2JYZzJiajV4TDZyeTEy?=
 =?utf-8?B?TXA1am0wOVVvdE9BZWZFVHpPd2hCM1hHYloxb2NJd1d4NmpUNzd0bEd3RUdK?=
 =?utf-8?B?K3llMDFIa2ZUWnl5bnQrVTFOV3JNcWJ6Um5WR3RKUXNER1JrRGxxVFhmWU9r?=
 =?utf-8?B?bS81YnBIeGNsdEhmeFhDbGtNOWJKeTdqaEp5UUJsL2tSTloxWUVUcjNTYTFB?=
 =?utf-8?B?bTdMeVIyeTZabjFWVzFENDExb3I3TWFYVUNqVVVyeTFzZ1hEYmE5Q01zRkJm?=
 =?utf-8?B?WVQ5clBGK2g5dEQxemRpdjJmaWxhMzFneUh1S1JkRGFrdmVhdmxEQllpdWNG?=
 =?utf-8?B?K3p1cDF6czUyZEpYMXZvcktmODN4ckVhQXRXRlN2ZWZmYWZaQi9GUjNHN2Vq?=
 =?utf-8?B?dHZSbWdJUWtHYjE2bndDSzNUMmlYK3U0cTcvK2R3VGtDL2NOUmJwL3pYTklT?=
 =?utf-8?B?dU1MYll2NGNaNHNyNGtQTy83Sis2bmV6aG5KMVJ2enoxU3A1UTFTMk5Tc2Nw?=
 =?utf-8?B?d1hpa3JuODQxc2FEbXYyMFh2ZllLd3hqNS8yM2RydnFTcVc5SHhrTTlJZ1Nj?=
 =?utf-8?B?cHovaFh4bGwvMUFPTGdsd0VJQUJUcjFROTAyc21WL00zSEJiKy9ROWh0ZENM?=
 =?utf-8?B?TS9PcEwrMkcrbTAxWkFZVE1VMzBxTGhqN2h4L09wMGo0T3NmV3FaTEEzYW9z?=
 =?utf-8?B?Z0pLOTFkcTk4d0V3YnU0dVN0enVxNkoyOTFRUytvNzRZdXhnRXlXSFNzZll6?=
 =?utf-8?B?ZTkzS1Z4SG4wMHd2S2pVY0JhS3AwZk9vZ0ViWXlvYWdaTzZ5blJwMUNmc2Rh?=
 =?utf-8?B?amtjMVFCL0NWSWN6UVFLd0xpUmJkWE5nNlphc1hteW1STWx1dGJyUDhnODEz?=
 =?utf-8?B?NXVwYXZaSG1YSG04QlB3WTZvY2ViUmcybEp6V1dOYWtaNEFMdkkweDlEL1Bo?=
 =?utf-8?B?QkJrKzM2Nkh4Z3JqWkJoek1TOHZBU1NBZHFRNnRZRmsxd1VJRTBRMTAwbERK?=
 =?utf-8?B?Sk9PdDlZUnArWUkzdHR4dUpVeWp3ZTVYUFZHajFZa1hBMmNVbG0wbXFBTjNt?=
 =?utf-8?B?bEFmd25rV0lRMVB0OXlISlBNdWR0eVUzWjN5NXBmMDYxZHZCMmppOFU1WGw5?=
 =?utf-8?B?R1hnV0dBbXdneGlhbDVyY0xzQ2VKU3VmWmpqWkhSb0hienNSdVBiamt4amZx?=
 =?utf-8?B?WElTZWYwWUVmemFPbGNGZnJKYnNUN1lWWmpaNXozTStkc091WUNaZGliMTho?=
 =?utf-8?B?VU5LcE8xUnk0UkNXQ0huNGJoSTVWSG9tMEhncjR6ZHRKc2o5SWkzRzY0WFRJ?=
 =?utf-8?B?SHRnZ0UrdnMzQ2dYOVVLK20wSlZkNmRWUXNocmF2QW1Rcy9MMVhNeERDaDRC?=
 =?utf-8?B?RGE5djRIYlh3bGNab3pORHNwdFpQUWN5ditaK2pBVHQ3T2hCdXlnbDZRZU41?=
 =?utf-8?B?RmVmUC9acFlNQWo2SWxzd3RXRnBJYkpSSkhpcUdMckRDWFQwZTdOZXpNSmZR?=
 =?utf-8?B?TUNPbXdSTGxjc05zRXc3S0N4dUYzUXJoTDRSUGFmb3pocFh1cXM1dlJGeVdy?=
 =?utf-8?B?N3QxcXRQRS8yN3k1N2pSK21kRmNvZlRPWmdxczJsTDZNOFB2Ukl0MW5CZXQz?=
 =?utf-8?B?aXM1ZDJoTDVON0lCU2VsUDBCZXAyWm1DMXJNdTJPYWJ6dHdUZ094UVlkL2pt?=
 =?utf-8?B?cHNBWDBlOElHRTcwVm1uU2V6c1VrK1dWVnBnb2hZRWdLSnhkSGlmVUpSeGk3?=
 =?utf-8?B?ajlubEoyTUNpaVdlN1F5emg4aERwa2RuOUlWLzlrc2dkTVNmdVhLMEVFRkVG?=
 =?utf-8?B?dkg1YWJnSDBZbld0eDliODVoYTNzR3NON0hTT1BXa25Vak9lbDRRMmNaelJM?=
 =?utf-8?B?dWkxWXpwRHBXZGttOWlsU1E0OUxlWHc2b083OWUvMDNDdm5sY2lwMjUyd1RZ?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98774035-d0e2-4674-d62c-08de11e9cfe7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 04:08:24.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyM7OUY8qocKTXdVhuXjqBfjb97N4DVx83DKM2L9iuvx7JqeNpsDHtzCPmY6guS5dHEpMB982yYErof80sPsm4jbcBjobgzcy/y6Slchz8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF267298081
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> New telemetry events will be associated with a new package scoped resource with
> new domain structures.
> 
> Refactor domain_remove_cpu_mon() so all the L3 domain processing is separate
> from general domain actions of clearing the CPU bit in the mask.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

