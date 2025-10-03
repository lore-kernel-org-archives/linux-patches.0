Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729F5EAF9
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505598; cv=fail; b=jyRx0KQmKFzYqEAVEo0tw8zKgAmNMKxluj7VGy3WydzmSVv8imCEsykb4pK7XV60EPNvWM7hiOzmsmTb69+qW6Pd6fSynLCAeqR3sKEq0eq5TvxrD6TIIzj/AtqanloDvNwqIvQLbByuLw6R+LVBCvwi7tYgR9SrR13jaxPzaKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505598; c=relaxed/simple;
	bh=1qEOPm+5Jn5blUXPA8cP27wWNGrstj4TUGTZqbsseCw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y7nmsbBeI0EeiiRSLpFkQjkZ/rPf/2c8iq2aubpPgmjFHWoZnSCvgqA7mLQ/D4lUt32YWtEy2rHnX+W8FIaJBqDRwZZi6ufGD9XuRd5mI93OawWwe0hSM7NswGfWiBnNxYHrH5YqFZiUOX2OZH0ApfBUJmBruH8ZLrGSxVYeiEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N20oaP/8; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N20oaP/8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505596; x=1791041596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1qEOPm+5Jn5blUXPA8cP27wWNGrstj4TUGTZqbsseCw=;
  b=N20oaP/8bRqR0rkS2slexEsdW28M2d8ywIAS7xQVCZZ0jAjCMnZD1Utq
   dsFdwZBWucfEDx/taTqrsB9o4GICHa+LwnVZqsXPsspWMH5m7aZWshoie
   3cj9LQLPVO9u9LKU7p08rXItNYJeXL5uLR/jEl9KFVCRzFxhRDRc4r+Qw
   o7ZCSqL+uFFxNWjZTq0qOSx3H2lpS9fECw//+VifxCUf+s2mjWdyyymxw
   Xgf7PhDAIupOL4wxxsb264w2GeA14HFWVuOKtaZRDeOutT36kGKS5/kaS
   aSQHv1sZzT8rcNndhctgkXVDh3IRyp1TdaiX8vIPFd6gIMmFbNjWF2OEh
   Q==;
X-CSE-ConnectionGUID: XVzk7DYlS6yfdeKF04LEkA==
X-CSE-MsgGUID: iQiu0S2mSROzCoJvhqBbrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61707003"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61707003"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:33:16 -0700
X-CSE-ConnectionGUID: iqu8prHtQXipVYVQhoZHog==
X-CSE-MsgGUID: sdeHac7MRpOaMD66A8yyLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="183331392"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:33:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:33:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:33:15 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:33:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWdNq/OvynIBUy/vo6LwM579W2EE6oeGJI7NOIWuCOTozNcuPoYM58eK9ADxjs1gEdgFKiFhXNTPvpBOVg3w3f/y4MVJNsSGJZQfRL1TinP4wQfENWu8o9GvqBHdvR4c9v5/hLN36+1JA62vXkHl/gGm5vvXD0iUFrPnrMi2/cKBWFHaJTIh7hx6Ul8FO6z3UbQD7+9+kVfMoeXYSgN5JALQMF49MCZllGLVU3r+vk2jBUJi4Gz5/a0j+5nf2KHbNX/eUw7gn/OW/XJxEyKu+0E4XcEm6V7qmqXNoTuRHUUvftBl3tyFt0oSbhaTWUmMHgLteU1u2iEMqbh+ukmkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gv2sS59wTTJl2LcHtASprwScicn8InJaMuRazRMSysQ=;
 b=gsx5obYGpkT3x/nApNPy+s+wzMwcYmUMLe2B963DzmE7YpZ4FrGzzIuKUErTB1bJGgqiGQ/EJHHta1MC65TnKlW9oZKP1PJyhChwqvTtHC5ZkEgSycBzqhnZqOR0NubguRz2ctWAYkw7IZCXPnPsi3aTIMq3cPlvzrv8TWjKoMpq3G5LR4lniXvPARD3YMrsBDTXda0k3tjOad4xqz3GW7z8fetam2Dy+Tv7LYvcegrI347JmslvkZNGuoR+Xx9eLjR3Y1ThOU0/oLmG7jNPCaXHoYlhCN8+WJ3P/sjW4ZEbChs8nF8MhizJRxj03kVnrv01y4DvL/sPTHhj2ZxWwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by SA1PR11MB6943.namprd11.prod.outlook.com (2603:10b6:806:2bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 15:33:03 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:33:03 +0000
Message-ID: <a6bb4a29-e494-495b-b8c9-fd6b380c9ebc@intel.com>
Date: Fri, 3 Oct 2025 08:33:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 05/31] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:303:2b::8) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|SA1PR11MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b6eadbb-4eb6-4fa8-47f3-08de02922458
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z1BOaldZd1MyM0p6NXh0OFZ0ZEJPR2JuUFJqYnlTcTdQdzZ0V0hGM0FlYnJr?=
 =?utf-8?B?dmtZaTZpZTVrSFVsaHltK0c0bFV2TzZVdmJxM3VBc3hwcy9Fek91QTNsbmRZ?=
 =?utf-8?B?NWN2WU82UHMySWNPaXczcWxjUkVCTVJWdUI2aUlIS05BVkEyU0F1Rzk1Nmdu?=
 =?utf-8?B?NmpPRDNLaDhia2o5N2s1ZSt3L1VQbDUvOHJWSTBxbEllc2RQaWlBRVpPK3VN?=
 =?utf-8?B?QzBJL0ovcU5ob0k4ZXlGWEw2dnp1QXpiMXJOZUZleFlBU2hpSEVYTkdRL3RG?=
 =?utf-8?B?dXNTcU5uMlpjbkpFdVl1QWhnVHRuT1JPbGVMZEtXeHhFOWpvaXdEcFlBdEJ1?=
 =?utf-8?B?Z29GdGFDZDJGOUN3TDVQL1R5M1FXOUNhRW1qc0tqVVhGcnczT09XT0dPekda?=
 =?utf-8?B?TXJ0dUx3TWNaMUw5YmVKUW5TRE9XZnd6VnV4WDk1Y0ZxOU9KRFZ6MjMwU1Rr?=
 =?utf-8?B?cXMvZk5rVHpGMDBCaE1GTzZCeW1RdlpMc1Z3T2pwTFlFWGVML0FqdVdwQVlC?=
 =?utf-8?B?Z1FrbXY1dmswQllCM0FhSUxIVEFIWWI5bktSd3JCRXgzZlNlZlV2a1UwZE9u?=
 =?utf-8?B?bWg1ejNMeitrY1BSNjloVGt1YW50dEJuWCtZVjB4eCtnbC81TmVWd08xWDF1?=
 =?utf-8?B?N1lrKzlNdGVlZ0NZVEdLdThzbUc1WlN2YXZmai9JWitYbE1VUmRLNHhaWjNw?=
 =?utf-8?B?ZFZDNnNGc1Y2UGpXYnQvSHBCcTFNVG92cFVMWTErTWoyNVJXTHFoc1BhanE3?=
 =?utf-8?B?Q3RFRWpPeGJhQ0Z5Q1RYU0JEUWtyU0p5ZWFtU2szZllNNmNlK0hWckVXU1p4?=
 =?utf-8?B?Qk53d3BzZW5WZlRCR3p4Q3NtUm9xeW5FQVpqdEhvenljdXNyS0ZIREkvckM4?=
 =?utf-8?B?ZFV6YUdwNGdvOVkrR1ZSenBqbXBMeFc0SFZHVE96VnlZNTJoQStJNkRSYjhI?=
 =?utf-8?B?d0tFeDhXUFArNEJwS3Awalk1TG1YbkZRS3pOSEdpNVBLbmlJRVQrWmJRdWV1?=
 =?utf-8?B?bFR0amcrRngvVHQ5NVdOdU1jUFVCZ2tjc3JmT3NsRERMNjZJVUtsblVYczBo?=
 =?utf-8?B?Ujl0cGtrTUdCeER0OWNMNXlidERWZEdFNE1PM3NHbysvWkk1eXFiYkJ3QlNR?=
 =?utf-8?B?VWJFUkhXYllrN3UyRXNvYjVWU3JtOEJ0TEx1UTN5TW9ma1NzbmIzWmJSeEFl?=
 =?utf-8?B?NmFna2NldUQvQVZSdWUxQUxoaWJKazNBdkp2N3g0Rlg5TjZzdG9lQUl0dU1y?=
 =?utf-8?B?MFd5VFBxemNhb1Z3dUNUQUpXRDI1SVdNSFZmdEx1SWdJZWFSZDBMQjRyZGhS?=
 =?utf-8?B?V0tqMnNSd1FYSDRSNjVTS0laQVgwbys4SjhGdjlnbGhJdnNQN3d1WEptVUdC?=
 =?utf-8?B?a3FZWHQvWmRxNTJ5VWU1RnEzYzBGK0htMS9hZ2ExWVFyam4xNXJ4a1lneUhJ?=
 =?utf-8?B?SzJhMlEyaVpTSG9idTFOMjhBLzl4dWhtaEpqNjExaEZ2ZmRzSEdGSlNtd1VB?=
 =?utf-8?B?VkpaNGx0N1Q5ZlFiME1BU0lZelNzb0JLWitrTmlWOGRQZDl1Q2VuTTJaUTk2?=
 =?utf-8?B?OStHTjFIQ1NZbHBqZjFtUnllYXg0MWQzVXlIZENkVVlDSjRtMlRTWmRYQ00w?=
 =?utf-8?B?c2FtSGZLYnBkTEYvbDJnamcxS1VNVk80Mk1qNU9ZTEpwL25QOHRacXVWTnhU?=
 =?utf-8?B?dmdxSVQ3ZlhsbFpGbkxUTlA2ZlZlQWZWbHNkY0xlR1VsL0l0RUlBbk10QWRj?=
 =?utf-8?B?MTB1SE1vKzY3d25Dc09oc1BtRzhVSjQwWU5ZNTFwdlJBYzMvRXZLVUxQWUll?=
 =?utf-8?B?TE1mUGdDakYwVm8xSFJiVjBPMXB6NmdiWWZCL1lsZzQvNHg2Yk1yamFmYkd2?=
 =?utf-8?B?eWdHUmdzNHlESjN3Q3BNKzNIaHFBY2wydGRCNS9DUkJrNGhILzhkcldHMjdh?=
 =?utf-8?Q?P/PDxA8X3xFX4zhwtft+1ttBgBVJPVIg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0orY2NVWXNYTGI5ckFSbWRXWVVjNVhhSFdzMnR5NEZxMHNCcXhUMEFVaE90?=
 =?utf-8?B?eDkxb09oQ2NqMjJZWjJydlRGYUNrVlYzQWhDdW1MMVl2T0ladm4wcWl0NkYy?=
 =?utf-8?B?R1FFcHcvTjNTUW84T3hnWkNSZHBmeWJ5T0gzSjdGbTVqaVo2YU9SWjVwVzNp?=
 =?utf-8?B?QlhkMG5mUzRWZmppVThNSEJ1THZ2NlpPWm04dTFoSFg0NUpUSUFaSzJwalRG?=
 =?utf-8?B?WnU3VlVRRENmVk9FTTk4REtmVVRmT2ZHTmFWRUZoeGRXWHYrd05SRE14d1A2?=
 =?utf-8?B?UjUyN1hQdmVEVEw0Q00zRzlrY2FuL3JqSHJEWHZkTjVpUllDb3Z3Qlg1b1RF?=
 =?utf-8?B?bXVzOFY5SW5WblhocmhVZkFwNmo4cDdHMG1FTTNCNEJrSDJ2WTN3eXNLbVRE?=
 =?utf-8?B?V2NraE5FRWNmdWZrVUJYN0hzZFoxeStzaithNksvNWhPczRYUVk4UkVlQm1v?=
 =?utf-8?B?T2ZGTmQzWWdoR2ErTWhVNVlQc2NsMEhnYmtEbzArMFZKaVVqZlZ5am1KZitt?=
 =?utf-8?B?K2lCZTI4T1Y5OWk4U3BLeDNoVGN4bElwbnBpVWUrbEVuWk1wNFlmS3p1L1JM?=
 =?utf-8?B?bmJQaTNHaU92cTdjaEJKdWlSY2dLMm1Vc1VzbHZtVDBpMEx4NmlvL1RlV1hP?=
 =?utf-8?B?QlRKU0dRNEdRNDVYcndYdS8vbWRGdG1rUlh4SCt2Z2lxS0xPMEVEUHQ5bGNv?=
 =?utf-8?B?d2xCTHY3TWZNTTRLeHRIMHdBTFRDYnA3aGNYV2UyNUo0Z0IwTDl6c1I0L2x3?=
 =?utf-8?B?L0NtQzl0MUovZHFkL3JBUE53VUJSb0RtcnZVcUhUWXdtMmpFbnhtRGZMUjNG?=
 =?utf-8?B?OXJRYmluQWRib2xPM0hHN25YSmtCVS9ZTDZYMTNiRmV6RHFBT2Z1RGJxQXdT?=
 =?utf-8?B?ZFNHbWs0Y0ZkS0JxZFJDWk43OERCSWVDVUQvR21LUktxWGwvVEVEelVVSTlq?=
 =?utf-8?B?UEE0K2s5cDNtYStCUTVsZlYwMXk3UlQ1eHBQTi9nWVFLc2s1MktObkRoTDBL?=
 =?utf-8?B?Sm8weC9qRVQ3M2FCWkFnT3JzUGhVQ1V4Vk1HdHVHNU1aSDZIdjdBZld3Umkw?=
 =?utf-8?B?YlArZXJoNzBzNXZTQ3ByREZ1dEpSS0JZd2pYZ2xsV3QrM3RxYU5EVHRUeHJZ?=
 =?utf-8?B?bkNENDRWVFU0ZHdEaWxrSjl1WjI2aXhpdUJmOHV2ekNZK3hSZnVtd2lPOUlG?=
 =?utf-8?B?N0xqcHJZcEtUN1I1Vkg4RlU3SFNXSUxiMEx5SDZVQWliVFNDQnZlaGtmMnMw?=
 =?utf-8?B?UnJtY2M4Qmh6NjA2K0ltSnVTL3J3Q2hWZVBYVmlXbzVOYjNiYk5sUHFNMDNs?=
 =?utf-8?B?RFZTU1pIQzdqWTJFK28wM1BiNW5xTXpKQm5ick9jU0t3WXNidm5HaEM3UFJT?=
 =?utf-8?B?Z1NKdFBKdjhrclZwbmtLMDJ5R3JqblBMbE5RdFgxZ3VUWS9jUTJrbnZYZVEy?=
 =?utf-8?B?cnJVNC94WkZGR1pRdU9oWjJ6T2luMTlSZWxDVmt4RGI2VVh5NnNPTFJtdmo5?=
 =?utf-8?B?ZkV3eFJiQzhBMCtScC9GdElmUTR6RzRzalMzL0ZwVUJ1TkU5ZU1FeFlwejdF?=
 =?utf-8?B?eVZid2xSOU4renJlZDdLWGs4V1R1TGtUaEVVMG43VmJjbDFLUkhTaUtuNHJ2?=
 =?utf-8?B?cXAvWHhHMzMxVm9JVTZlVUZXK2YyUk4zdnhvVXUrTElJSWk2ZE9vL2szTUp3?=
 =?utf-8?B?cXlaTzFoSkRNN0VET091ck5tQzBqeUtmd0w1aHRvbSsweG5WdEd3RDJNMXhs?=
 =?utf-8?B?azJKSzhrRUxLenc4TG42MFF5NTVvaTgzZUxyT09vK3gwK2Z4M2ZaODZjMDRw?=
 =?utf-8?B?TlJvSFJpcGQvWXFJN3RsNnpMTmxoNXJSL1I1SDliRWduTGN2QmNzc2ZVSE1S?=
 =?utf-8?B?OHk4YjUxSFUrUTBLK2dqTytjbVB1bnVOQmo5dm94Z3hLUnNCRWE4akZidEd0?=
 =?utf-8?B?ZU9ESUoxeGYybmNNY0FtelNDTTQramZZWitwbysyY2l1TXd3VzcwQlRKS0tx?=
 =?utf-8?B?aWFwcmI4d1M4ckxIakc0cGNJanBtZFhnUXRiZng4UjkrRnQxdTVKeHFxSDZN?=
 =?utf-8?B?aUVEY2NGdHRjbmEyemVCc3VpY3oxTUtBa0d2VHNJT0JkRlAwUVhJaFBaU1lj?=
 =?utf-8?B?RnhGaWJEUjBBZG9Ea0M5VXd5OWNkNEhCRFE1ekVId3RUa3c1NHM3MENNM1Ev?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6eadbb-4eb6-4fa8-47f3-08de02922458
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:33:03.3278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXEVtS1ERYIBfbMHl15mnRTyE9WRLy4EA9OqoKN10ToDA9tUKoxWYfRXkP+e165LC1u4BjgOn9zgfOJWpqWsdqTqT0NVg5tbSDWpgtuzgnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6943
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:02 PM, Tony Luck wrote:
> Up until now, all monitoring events were associated with the L3 resource
> and it made sense to use the L3 specific "struct rdt_mon_domain *"
> arguments to functions manipulating domains.
> 
> To simplify enabling of enumeration of domains for events in other

What does "enabling of enumeration of domains" mean?

> resources change the calling convention to pass the generic struct
> rdt_domain_hdr and use that to find the domain specific structure
> where needed.

I think it will be helpful to highlight that this is a stepping stone
that highlights what domain management code is L3 specific and thus in
need of further refactoring to support new domain types vs. what is generic.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index f248eaf50d3c..3ceef35208be 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -547,11 +547,16 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>  }
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
>  {
> +	struct rdt_mon_domain *d;
>  	int cpu;
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))

hdr can be NULL here so this is not safe. I understand this is removed in the next
patch but it is difficult to reason about the code if the steps are not solid.

> +		return;
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> +
>  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> @@ -598,7 +603,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	enum resctrl_event_id evtid;
>  	struct rdt_domain_hdr *hdr;
>  	struct rmid_read rr = {0};
> -	struct rdt_mon_domain *d;
>  	struct rdtgroup *rdtgrp;
>  	int domid, cpu, ret = 0;
>  	struct rdt_resource *r;
> @@ -623,6 +627,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> +		struct rdt_mon_domain *d;
> +
>  		/*
>  		 * This file requires summing across all domains that share
>  		 * the L3 cache id that was provided in the "domid" field of the
> @@ -649,12 +655,11 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		 * the resource to find the domain with "domid".
>  		 */
>  		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
> -		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
> +		if (!hdr) {
>  			ret = -ENOENT;
>  			goto out;
>  		}
> -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> +		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
>  	}
>  
>  checkresult:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 0320360cd7a6..e3b83e48f2d9 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3164,13 +3164,18 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>   * when last domain being summed is removed.
>   */
>  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct rdt_mon_domain *d;
>  	char subname[32];
>  	bool snc_mode;
>  	char name[32];
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
>  	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
>  	if (snc_mode)
> @@ -3184,19 +3189,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  	}
>  }
>  
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>  			     struct rdt_resource *r, struct rdtgroup *prgrp,
> -			     bool do_sum)
> +			     int domid, bool do_sum)
>  {
>  	struct rmid_read rr = {0};
>  	struct mon_data *priv;
>  	struct mon_evt *mevt;
> -	int ret, domid;
> +	int ret;
>  
>  	for_each_mon_event(mevt) {
>  		if (mevt->rid != r->rid || !mevt->enabled)
>  			continue;
> -		domid = do_sum ? d->ci_id : d->hdr.id;

Looks like an unrelated change. Would this not be more appropriate for "fs/resctrl: Refactor Sub-NUMA
Cluster (SNC) in mkdir/rmdir code flow"?

>  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>  		if (WARN_ON_ONCE(!priv))
>  			return -EINVAL;
> @@ -3206,23 +3210,28 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  			return ret;
>  
>  		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>  	}
>  
>  	return 0;
>  }
>  
>  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>  				struct rdt_resource *r, struct rdtgroup *prgrp)
>  {
>  	struct kernfs_node *kn, *ckn;
> +	struct rdt_mon_domain *d;
>  	char name[32];
>  	bool snc_mode;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return -EINVAL;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
>  	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
>  	kn = kernfs_find_and_get(parent_kn, name);
> @@ -3240,13 +3249,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		ret = rdtgroup_kn_set_ugid(kn);
>  		if (ret)
>  			goto out_destroy;
> -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);

This does not seem right ... looks like this aims to do some of the SNC enabling but
the domain id is always set to the domain of the node and does not distinguish between
the L3 id and node id?

>  		if (ret)
>  			goto out_destroy;
>  	}
>  
>  	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>  		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>  		if (IS_ERR(ckn)) {
>  			ret = -EINVAL;
> @@ -3257,7 +3266,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  		if (ret)
>  			goto out_destroy;
>  
> -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
>  		if (ret)
>  			goto out_destroy;
>  	}
> @@ -3275,7 +3284,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   * and "monitor" groups with given domain id.
>   */
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>  {
>  	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> @@ -3283,12 +3292,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		parent_kn = prgrp->mon.mon_data_kn;
> -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  
>  		head = &prgrp->mon.crdtgrp_list;
>  		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
>  			parent_kn = crgrp->mon.mon_data_kn;
> -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
>  		}
>  	}
>  }
> @@ -3297,14 +3306,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
>  				       struct rdt_resource *r,
>  				       struct rdtgroup *prgrp)
>  {
> -	struct rdt_mon_domain *dom;
> +	struct rdt_domain_hdr *hdr;
>  	int ret;
>  
>  	/* Walking r->domains, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> +	list_for_each_entry(hdr, &r->mon_domains, list) {
> +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4187,8 +4196,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> +	struct rdt_mon_domain *d;
> +
>  	mutex_lock(&rdtgroup_mutex);
>  
>  	/*
> @@ -4196,8 +4207,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	 * per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d);
> +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		goto out_unlock;
> +

One logical change per patch please.

While all other L3 specific functions modified to receive hdr as parameter are changed to use
container_of() at beginning of function to highlight that the functions are L3 specific ...
resctrl_offline_mon_domain() is changed differently. Looks like this changes the flow to
sneak in some PERF_PKG enabling for convenience and thus makes this patch harder to understand.
Splitting resctrl_offline_mon_domain() to handle different domain types seems more appropriate
for "x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG" where it should be
clear what changes are made to support PERF_PKG. In this patch, in this stage of series, the
entire function can be L3 specific.

> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	if (resctrl_is_mbm_enabled())
>  		cancel_delayed_work(&d->mbm_over);
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4214,7 +4229,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>  	}
>  
>  	domain_destroy_mon_state(d);
> -
> +out_unlock:
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> @@ -4287,12 +4302,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>  	return err;
>  }
>  
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>  {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>  
>  	mutex_lock(&rdtgroup_mutex);
>  
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>  	err = domain_setup_mon_state(r, d);
>  	if (err)
>  		goto out_unlock;
> @@ -4306,6 +4326,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
>  		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
>  
> +	err = 0;

Considering the earlier exit on "if (err)", err can be expected to be 0 here?

>  	/*
>  	 * If the filesystem is not mounted then only the default resource group
>  	 * exists. Creation of its directories is deferred until mount time
> @@ -4313,7 +4334,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>  	 * If resctrl is mounted, add per domain monitor data directories.
>  	 */
>  	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		mkdir_mondata_subdir_allrdtgrp(r, d);
> +		mkdir_mondata_subdir_allrdtgrp(r, hdr);
>  
>  out_unlock:
>  	mutex_unlock(&rdtgroup_mutex);

Reinette
