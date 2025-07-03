Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B170E2BF011
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751580050; cv=fail; b=sDDXDJJc7cwBviUzBxWc/O87gEJPGvGmL4wg9WN+OZFs9Tf6yhHEHfc2CTTmZLZ7/FoULYqTobeykQNyyfDH+6X9tgTYkq8L+6Zx6/QoEWxvUSA1xhqPzVOMTELoYvIrZncW6Ajr9CDIN27YPbv5wL5/a8HZ3i4NtzDBphpoD5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751580050; c=relaxed/simple;
	bh=Lk9iphZvBDKmCnR7X8QfVBDLgBcUeLCyPgqF1HCpyVc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gmOPfG8jBPMaUiKLIPnPw7tcgmGxUoS2pzWiFFCBKmNKL1hr8YQHCvaWHBdCrfpFiWZEUTdMtDVQRgxUxrMZmFqlCXApMv5ma1WrdsUKsR/VbwZC+qhYQEAjgvib4lRktXeOP4JsCScBFMlTHOh1Dh+Z9lPHaS3V9mrVrUAnVSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eHFCC7+6; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHFCC7+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751580048; x=1783116048;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lk9iphZvBDKmCnR7X8QfVBDLgBcUeLCyPgqF1HCpyVc=;
  b=eHFCC7+6CoovoJ2IUc74CFye9hSd8y8jYHlLZXvYESCXeWIGDv4tXL1R
   TYuYoMz8w0+f315EeAOXDPXW+8+gRFTzd+BdlwfptuSTVrHrnvLBdtoLc
   J68fRKlbkXr3HzFl9dsKqr5b2bOOlcfPD1dphcvn1awu2wzbG7SyCvceZ
   149ESiJIsaaQxwFIDi4gYujoudxdvc9XCUayTHleL6ncC6Yw3siB10KeD
   ei2bHRfnxOr2ztPIPCCq7H9sxh3fuK719Rv3oR0lFLjyDxVvZwdhl1175
   FT0K/hbCTe0RPaV9HVfo6JC/BszITsBOdNi3CsMRIJXZI2rorWUwSe0W6
   w==;
X-CSE-ConnectionGUID: Q7++Fjv9SViBw/TnTFugoQ==
X-CSE-MsgGUID: pbH3RvqAQDWbtGUjtQZj3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="57726312"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="57726312"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 15:00:47 -0700
X-CSE-ConnectionGUID: jhHWyjovTUG3YGGNB43oGQ==
X-CSE-MsgGUID: +UxdsC5YTTCq71eRkqR3BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="154122670"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 15:00:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 15:00:46 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 3 Jul 2025 15:00:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.57)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 3 Jul 2025 15:00:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mt62khB65p3q6755gCEkZUuY6JTF5S5skW5EjTkMuQiXWlZY893ZVqyHC7lwBMV6TxsIjP0k3jpRnDBcuzgfd59LOc/0RCsOeVDUJB8mW1NCpLvUwaFqSOmGhtB7GGuX2IF9AhykzrflNj4Zoies5nkmeKH2tjt7M764UsZhm1m7/AKwSTnpZ4WWe9ccanVU6F4lYL4WgRqVPqdO5EpCXBN/lgWPAXAaVEdT3UiemJIjPqzRlSMrJ8fThVCcime50vHHfJqd325Xo2/jiWvf7jKJ/rVvQ3MuGwd0gXqLOiy7ZMZVV/qE7WCgBa4N5M/k0m3+nrx6B0vLwTjMOXmmPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uT+UUdsoKLdJJAzPw5IiypGhbwi82NHWd+ivnCEdDhg=;
 b=IV72t+Sv9Lf1kh9w6VSZwpiwSz+QlCdhkt7GpUOHL/FC8m/Te2CL9WZZzpMtX4FOypeOZ9bnWF9DHsBdOwUpE+CtqJtT3OKgv2qLek/shvDVKU0GicBuwqGqR9VJoIK5fF16leSI/TgBL3EH6TU4pMVE7emjg+Dz6qyjJ6ZZ1lVkgUBN8ZZ2OTJhCzGaO/T/EmjaywCqXaHhm8JjjEb+KotzbqY2PzWJMfHwXwDXCtVD6QqwV+kNUA+MU+yFp/XP2l6SCNEYtOBOJPpxYoBMAzRCXsShKoQhHDoDZXWNF0NVphXFZGcR3tjBXHPgJiHdtsQ5606/myZK2tB8xJAKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Thu, 3 Jul
 2025 22:00:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 22:00:37 +0000
Message-ID: <a1df0e8e-3d80-4d42-85c1-71e014d177aa@intel.com>
Date: Thu, 3 Jul 2025 15:00:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
 <aF7dt2iQpvuahZil@agluck-desk3>
 <eb6f7bc0-23ae-4100-9a34-fade6c650460@intel.com>
 <aGblc2VimjIiy_bY@agluck-desk3>
 <bb9b5ee5-3367-4193-9e07-747b1ab50637@intel.com>
 <aGbyA-TVAdG5uUBk@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aGbyA-TVAdG5uUBk@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW3PR11MB4697:EE_
X-MS-Office365-Filtering-Correlation-Id: fad5ba6e-9886-4e4b-cc97-08ddba7d0afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXpVNEtqU0VCbjZnREFGbVUwMWlySm5naWtNcnpQekNsRitOQTRYUElHb1ht?=
 =?utf-8?B?RzdlT0htT3hBb21iZFVtN3pGcDF6Yi83SDloakFMaTliZGNwMU5wdGZxZTdO?=
 =?utf-8?B?ZWdySWgyT1d1eWRhNk0vamM0R0VhWkRjdEllbTlqalFFZlhhSytlUzBLakd0?=
 =?utf-8?B?RUs3TmppTEVYUUJMdWJ0cC9sRUpBOXorSWcrVzA0MmVteXNZUXlnUEJDb3I0?=
 =?utf-8?B?c3hkMFhIQlhhQWpOZXZoazhDOFBpdUREYW9XanFnMHFDVmxyZmVwSkpXcEo4?=
 =?utf-8?B?bk42dXpXSUVJWW1zSXE2aUgvZFdBTEVGaXppQjJtbVF3YXVEcGIxNklNYkZF?=
 =?utf-8?B?eUlEYWVvM2xBOHJoVWE5R0FRejJkT2hadkJuM2dTei84cUNaS09rdWhEaE8y?=
 =?utf-8?B?R1dMWnM4dlZ2OHNVUzArTXo2NGVNQlhEK21zSVRZczdpR09GNDZnWStzcmlY?=
 =?utf-8?B?M1dJeHdsckxFaStBeHE5SnR3MFZ3dHc0TFU1aGR0SXNtN25VTU9GQWRxQ2p1?=
 =?utf-8?B?ZDBCVFFSQ3VBWFpSQytJRThpVTkxbndnK1RZYkhndzBRVWdhVm5nYll6Z00z?=
 =?utf-8?B?L3A3d2VqOGNnZkQrQlFkMHFGSnF4UjRIU2YwajBYY2wvaTJHZHdXMWRvU3hj?=
 =?utf-8?B?QkpuT0JlSUl4VUEyUTJOQThuZlJLLzMydWQxay9hcGFDMG5MTS9nc1NNRXYv?=
 =?utf-8?B?a0FrSTlvOTg0ak45VUJIa2s2VFNsZGlYUHlPemttVTlPK01EYmdZVXpGVng0?=
 =?utf-8?B?VllGY0s2UGhueDdJeXZLRG8waHo3SXVhclNNbU9uN1p4bXdpRkxMZWNCVHg2?=
 =?utf-8?B?ZXNEOUlwTVdSOUh6eTRsWVk1QWtjWG80ZTlCczJBaUJCdEorWno4NGsrdTNw?=
 =?utf-8?B?ZHRodEdXZ0ZyMDhGT2lEYW1ONC9XZE9XVHJKQU1oOVFDeUN5MDA1UExPZ05n?=
 =?utf-8?B?SEd1L0V5c0ltTWZXeVZwcHU4dVJEOFAva20rZjFMUjJWRlFuUmpUM2ZHWm00?=
 =?utf-8?B?M3BZMU4vMDN2WlVxM0lGS1VLZVprMmM1UGREWGV6eC9lMGFkM1FZWEtSQzVt?=
 =?utf-8?B?RWdIenJ3WUR5RkE1M3JPMk9sSFdaR3JLWVBRVDdZQ0p0Rkc4N1dFeEdsYzNp?=
 =?utf-8?B?MHJSemVrNk9wS1dXMkZsdXBmQlkvbnJRRXIrOWF5bDQrWURWcllkdzhJNFFV?=
 =?utf-8?B?VWtCSHhYeVZxQ1h3bUZBZmFISjBWS0lTZmNXeWp5dWxMaFA0MGgvd2NsYU9N?=
 =?utf-8?B?VGd0ZjQ0d1J3eWxLd283RTEzdE9NQ2dUc0pKM2JrcU5TRkk2WGpmSTJlWS80?=
 =?utf-8?B?Zk1ieFlnK1R6SGRzSU10UHV1SE9VbnZnLzlCYjljSEJVM0pMZzlpZ3JKaGFw?=
 =?utf-8?B?K29xQXA2MjE4V3Z2K0IzbjBZWU15cHh5MG9iUHgzMEJRbzVWck9QZGd3YThF?=
 =?utf-8?B?U2V5S3FvbisrZnRZcGhoN1JyNjhHWUdPQVludzVOZnN1ZG5FZFVMK2ZvNzZX?=
 =?utf-8?B?Z1NTNXBvS3RiQWRXQlgzKzZveEJQem5CUEo1OVVqdlc1dGUwREJuMDErbXJY?=
 =?utf-8?B?OUh3RkFLSjhtZzhVUjNBbHkrQ0hKL0I4NzlhN0dYbUpEaHpsU3lDYmk1YXFZ?=
 =?utf-8?B?eGZLaHp1ZWluZ2NMdkVhWFEvdFJKdmp4M1JWUmhlSC9vL3ZMK2o3SzBEeEx3?=
 =?utf-8?B?ZEs0RnFPMHN6UlFjMUVUSE9VcWV6N3duZlhDOEttTVFxRzVXL2xDbDFzWElk?=
 =?utf-8?B?RzRUWXVRZThnM1U3SzNlS2d0UnVHUVl0NTJZd29DeXZIVXFqdXVyYkhGMWsy?=
 =?utf-8?B?RVROUGl1WnhsUFBVU0tMVGhHOFJZQmNmU2pTM2hXaXlmcDNiSkdFTEMyZVNt?=
 =?utf-8?B?aDU3aktOV0lNdm80anUwbE1HOUNiQTVKSmM2NnR4VU1yTlZ2NmZjM1lZZ3cz?=
 =?utf-8?Q?9p8uzpFcvw8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm5Ga3ZtWG1neVQwN2VQVVBxMXF0YW45Q2dLaEdhSGM1c2t1YmZoOU5vbiti?=
 =?utf-8?B?T09JS1FkQWtLTmZ2eGd3SlJJRnVST0JwZVIySmtYOWo3dU9BSm9tbWpGY3M2?=
 =?utf-8?B?ZVJNbGpuSXh4bHhYRWJqVVMxY0tRdGZqT2VFN1JlOEY5UW82TStkMEtzdDFT?=
 =?utf-8?B?OHFIZ1dFaUFydDJZbUlpenZsUStZbjZwbkMzd2JndTZjUjZnK2lMSDcvUzVk?=
 =?utf-8?B?UkJWZE05aHQ1Rk5IUDRFNCtFbzVxQ2xUd0ROZklVazBiMk5maTZrNFNoMlN1?=
 =?utf-8?B?dDNTQTJLRUw2UkF0R0FESzR6VklweEI4NkV5d3JIb09FYUI3NHhBZzJVY2VT?=
 =?utf-8?B?L2UycUtqMk5FTTAyWVJCK0NFck4rN1NtZGtrVGZ3UkxPTExNRVYyaUpvWmdQ?=
 =?utf-8?B?dDJxL0tYb0RKejZLTGdsc1I0c2QxN2ZYUHBRTTVMTFpJOTRGWFFUTUp0UEtj?=
 =?utf-8?B?TXVUbWhUclh6VG9idEN5VzNoUnRyV2lUQlB0OUgxNTI3bGliWnVVOGlQQ3Zl?=
 =?utf-8?B?dHUreHpqWlN6WjZ5RU5Hd292WXR6NXVTZEpVODlNV01mUzVMT2VCNEp5Zllu?=
 =?utf-8?B?eTA4VWZhbEp1dkZHcTFhcXRITWpraWhCU1hRWnFiY0Jtdm1ZTVFLQ0VzWTNo?=
 =?utf-8?B?UmxxdlpTZXArQmpGK1pPc1NjM3Q5ZGpXMGVSZXlnY3d2V3lzSFlrcWJxR1ZX?=
 =?utf-8?B?OGR0UCtqL25VVWFuNjZlbFpUMnJYQmpqTTh4WDNKdngvRVpiMDBuZ2RrSU1k?=
 =?utf-8?B?ZmMwNVZYQnZBcUVSY1RwRFRaM1pNS21tRVVTZWl3dzBYNXhncVZLTGZ2Tm5P?=
 =?utf-8?B?VDVtbXhFWGlnc3QrOXBMNDAwWmg4Vkd0QmJHb2grczNpUEdtSzZsMGlOYWh6?=
 =?utf-8?B?OVhaZ0ViZzluQUllc1duSUtHYXB6dUdySzhZS1gyU0s5bHlDYTR0dTFkVXht?=
 =?utf-8?B?am9OMnNwcC9jclhxcUNzRnowMWJzYjNqRlZyM0tQS1ExMnFQUXhEallHd0dI?=
 =?utf-8?B?dVpnVWNicEdNWXh3K0djekNVNlF6NTViK2xXRHk3RWFxTUF4M0NRRERWc0c2?=
 =?utf-8?B?Nk1POXRGSmx3c3VWK3U2U3hwOWpYQ0lmZVAyZWQ1YW5SVHJFWllkeFVIWnVq?=
 =?utf-8?B?UitMYUFoZUh0RkdzbWllWnVpYi9jcjc0Yk5tRGk5REpUSnBVTnRZV2FTd0Jo?=
 =?utf-8?B?MGw2UktONWlNb01xczVEZnlYWGc3cG9XY0ZhZ0VRUWdMT2MzdG9iVUo5dW1M?=
 =?utf-8?B?N2pPR1NKWWJxNnBqQXdxaThYL0xJR21PZ1FvVS9YM2VSQmszTy84VTlKVmNa?=
 =?utf-8?B?ZGlnSHprcmhMU1JxaTBvNHV5b0FNcDVKd0oyOCs4OVNjYVJydjhKRnVUZzg0?=
 =?utf-8?B?MEYvYkY4WTdlK2FIckFJZWZkTVgvZFFXQ1cvQk1rdGdFTDVpUnI1NHVvZlpL?=
 =?utf-8?B?Qk9vNGpHVVpyK3o2ejR6V25BUlZwU0JIRStMakdzRkRXM29KclZYSHczMnE5?=
 =?utf-8?B?Qk1uZ2U5czl5TzgzOWRjOUk5L0dmMWRlK3E3K1d6ZGpESzI2M0V3NkJzL2RT?=
 =?utf-8?B?K1d1ZmxRbjZtREFlWE1FcklIUy9qYnhNNDRLQkxuUWtsMG9VWXo2YXVkdEFU?=
 =?utf-8?B?eVl5VVY0VEwzZUR1cmU4MEdzVjRVUEtNQ21HWXI0T1FmdTIzRGM5QUkrNnRZ?=
 =?utf-8?B?QjFzT2NkRStMQmRqTGEyMTVCY0dneDQvZnNnZnJvSURDMTBLeXJIbi83TjR5?=
 =?utf-8?B?ZGRJVlZTZ25TOTB5MjZFZis2YU1mWEhlY01od1VhV3g1clpsQXAzZU8vYjNt?=
 =?utf-8?B?Z09VQzhEVWd3NlVGUEVmT1J1bXJrWFh5eEFJZjk4V05sWUlxSElPTE9ra1Fk?=
 =?utf-8?B?U2FCTFJuVUVpOU9hSU51aFdxN2lOQWY3Rlh3S0g3SldXVjh5RnE2Q09MdGk1?=
 =?utf-8?B?SWVQYVRKdTF2SDlMMDlEUjBCMjRMZFlUbEhBcHNLY25RazR4eXZvZUZKenIy?=
 =?utf-8?B?aFVQalBsT1hsbmhKS2YvM2lGNEZYajJ5M3BMbW14OEtieTV2dU9KR09WOUEr?=
 =?utf-8?B?WjJldVV5SmpwcUhGMGpXSXVOWHEvMkZvK0IrOTJ5TGpoVm9OK2VyZGxuU20x?=
 =?utf-8?B?RHNtOHFsVGIvTnMwUE9PWDJEcFRKVjJsREJOeEpYR0ZxMkl3ZTZMTUlXNytY?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fad5ba6e-9886-4e4b-cc97-08ddba7d0afc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 22:00:37.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhbMIPXoPvkQx5UNjdcswJxPUKC+nbjRXAzprNsWedLBgLJLTyVG1tME0uy+bAUH4A9eG/KS2QYjh4bL2rXB9vEg1E86zY72r9kWdfqEwyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4697
X-OriginatorOrg: intel.com

Hi Tony,

On 7/3/25 2:11 PM, Luck, Tony wrote:
> On Thu, Jul 03, 2025 at 01:31:19PM -0700, Reinette Chatre wrote:
>> I do not think resctrl should enforce dependency on a driver that is not
>> valid for a platform.
> 
> Fewer stubs than I thought.  I can merge something along these
> lines back into the series for the next version.
> 
> Suggestions welcome for the name of the config option. Do
> I need a "_CPU" in CONFIG_X86_RESCTRL_INTEL_AET? It's already
> very long.

Looking at other config options in the same file it does not seem
as though this new name is exceedingly long. I'd vote for keeping the
"_CPU" with the motivation that doing so maintains a "namespace" prefix
for the resctrl options.

> 
> "help" text is a placeholder. I can change that up to add more
> details.
> 
> -Tony
> 
> ---
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 11f25c225837..56615b1d3fc3 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -175,9 +175,19 @@ bool rdt_is_software_feature_enabled(char *option);
>  
>  bool rdt_is_software_feature_force_enabled(char *name);
>  
> +#ifdef CONFIG_X86_RESCTRL_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
>  			 void *arch_priv, u64 *val);
> +#else
> +static inline bool intel_aet_get_events(void) { return false; }
> +static inline void __exit intel_aet_exit(void) { }
> +static inline int intel_aet_read_event(int domid, int rmid, enum resctrl_event_id evtid,
> +				       void *arch_priv, u64 *val)
> +{
> +	return -EINVAL;
> +}
> +#endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index a6b6ecbd3877..ceb3eb371a3d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -512,9 +512,6 @@ config X86_CPU_RESCTRL
>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS
>  	select RESCTRL_FS_PSEUDO_LOCK
> -	select X86_PLATFORM_DEVICES
> -	select INTEL_VSEC
> -	select INTEL_PMT_TELEMETRY
>  	help
>  	  Enable x86 CPU resource control support.
>  
> @@ -531,6 +528,18 @@ config X86_CPU_RESCTRL
>  
>  	  Say N if unsure.
>  
> +config X86_RESCTRL_INTEL_AET
> +	bool "Intel Application Energy Telemetry"
> +	depends on X86_CPU_RESCTRL && CPU_SUP_INTEL && INTEL_PMT_DISCOVERY

Thank you. This pattern looks more appropriate to me. Do you expect that
the X86_64 dependency (added in patch #22) will move here also?

> +	help
> +	  Enable per-RMID telemetry events in resctrl
> +
> +	  Intel feature that collects per-RMID execution data
> +	  including core energy consumed by tasks. Data is aggregated
> +	  per package.
> +
> +	  Say N if unsure.
> +
>  config X86_FRED
>  	bool "Flexible Return and Event Delivery"
>  	depends on X86_64
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index 97ceb4e44dfa..26fc957fb3dd 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
> -obj-$(CONFIG_X86_CPU_RESCTRL)		+= intel_aet.o
> +obj-$(CONFIG_X86_RESCTRL_INTEL_AET)	+= intel_aet.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
>  
>  # To allow define_trace.h's recursive include:

Reinette

