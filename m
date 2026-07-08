Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41AC385D8B
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551209; cv=fail; b=fKFRPOGSlzDXJSW6HpFWAwXlvA+egtWktz2Bgpck74HYCnHzVg3HjJ/8BlfBce54JI18WjRpYhIzznyNB6Q2JaKVyUfOJjs9r0kuMi2K8Qo73pjQ5X+pRA1+doZlFU82ERNrWiQqYjK46mJeO7ohrUqM15cWSSZ/zQySFBV65bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551209; c=relaxed/simple;
	bh=Qp0orRwSjS10p6quclzf5rBxKSaVKMCHX3IIpiLDkKM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XH9S1oJGdwLQZgac/hwvJAUXc8oWh4k44VsQTmbZ49Lz6U4HqqPbXljhCJ+pBjpMbtnbikuQy6S4LVt+Qd4XmeSO/mLzDVh+2cKg+dQ5z/omDO8C+pNSuMeGvMSAXqyyFEe5N0pSqmIErbnx3z3bO//LvupcbauQnVguzmLhERM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LecUpGcc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LecUpGcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783551208; x=1815087208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qp0orRwSjS10p6quclzf5rBxKSaVKMCHX3IIpiLDkKM=;
  b=LecUpGcc1K0x2Ro7yx310QC7hvz3Gf+xl05ZinibaMs7J90QLpZumV+a
   +01CIRfNK486xmtE4uSCjPLDrWQzW/eGoQpYCZXjEsSo8+k/NqqLQnnY5
   murFry5Ymo+OZlCWn7K05uibUO42XPTOF1ovHYKm2R79MSE7/XXU842Ps
   v5ENPEzwEnQZJbyqa4iaUFII/iDG6tssxslhy13KMHcUPFag7ihwpn+RZ
   tcfzvPc9wLyph6wQQBd50i9ruijyZLkiXTlnjatzf2GkmWJJGIvyqGqVO
   b/refiguPvhrenBrLiQBWztkk9Jj6sySwDqWdPNs1n1k0ASPKPaxSb9jt
   w==;
X-CSE-ConnectionGUID: F7dwj/QnSw6OsgleaG70mQ==
X-CSE-MsgGUID: M7mbC1ZMTXeGvUKLEoKdXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88140111"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88140111"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:53:27 -0700
X-CSE-ConnectionGUID: a54bUgrCTcSlV5JLa4vDzg==
X-CSE-MsgGUID: WXiCRSfpS2W4dGBpxsz2HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="248045942"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:53:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:53:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:53:25 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:53:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qtcTHTmqZEL8d5mCpLkR/yYnhs/IdgLEiwlugnbApqHLPSCp++Z351w4xB4DqYBnCl2LVQsOYSAFZBf8BGC+SDex2kA0Q+xK830hOLFB7Pq94rCiekZkiiG0eJvbJXI92Ff46QxIfbihegDGNZbIdk3AeYRalkVXLnUPAX/QafKKmKMpH3moy9PVD4PlT/VnQ1eVd5t6jaVMJ0EPOB8gSeefR0wyIv3b5LA8iPFjK00FzF/zoed8rGiXkWfFsglsjO82JGSYGH2RcqMgzuW22wdKc0xDcLHxE3LapMWZDwHIx2gx1gVtSBDDTte2kVelGO/8wJeFL4cZgKPgU6lOyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8B0540wmd0MbhfrswpZ2oa1jzY3JNHTeQsmHVgdiT18=;
 b=mxU6OJtWur3RKcaRptJwiRbu7yabu9m4WhGrv6krgljvcaxYo7BHAQbQUCl9HJ4MrP6VINdtP1S08v9GYJRUk+xqe+kLfCuEVLGC6qEo8biuwLO6RjlnVnmMjujGXm4jErxhS2hOiT20sDGoYkdn2l1cqckLKjb/9eXE+53TQhAceFzT2SAReNDns9FWyZ1Ft0UvTYY8NVkpJdiOVS4IqfiwZix7AvZuYOcAC0c2wJ0bia3oI9n0E2f6ygGRnbPK+e6BZ0W/pY7kzljBwodp59rcOlE2efyWQUPptboF3nGgR6t7thK0I7xH+f7EzXl8d15Cwu4ezJotu8WF3xRkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM3PPF99D0888FA.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 22:53:22 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:53:22 +0000
Message-ID: <37274b66-13b7-4ced-9d79-e52d68a7ebae@intel.com>
Date: Wed, 8 Jul 2026 15:53:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/12] fs/resctrl: Call architecture hooks for every
 mount/unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260701213553.15222-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:303:16d::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM3PPF99D0888FA:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a4d43de-4b2b-49ae-4631-08dedd43b65a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|22082099003|56012099006|11063799006|4143699003|921020;
X-Microsoft-Antispam-Message-Info: YwOTGrkXUx25WJU+4uLyWMDs73hEBV1ygWNIAcR/ehvgPZhBFoOXYB1XEzyn4dMGWjj9s9lSZsvKQuWjwWXBTN4i9/NjKbUH7xO1/47kZOfSycgK/Z9izmqPuZGJFyUs0N4Z4PB+F6CkWGnOneR6rxogLGD8DzzA0z6Hn9/qkPJi4eFBXdCLPripm7uQ9IBP9HNM0Zb0x0IUsIAtu+KFQnMD8OesNiXYiXo9YaUoiryhCFc+gQn+9lhmkKjVvAfuadkty8fRpOfi3AyIeQSrmhM3TasvNx3nUsFC+cJmYkuVpHxHNZ78xVHgRNKgvV3hhEQ3MVlaneL7CfAtcv7dFjxflzuztJVl26bFyz0Cc3Z5E1II4GGzptYoytYJedT5bN7wj4sA6B7N9mqjOp8Q2ryDa5Cq23NqHDUnD52i10kZ7HsIW6q06JA8ANCdznJffO0aj4OKckXpGKPpg9yUDYNUd9dBcgqU7D9eT3RdCKPHE0xuLhBVoWDCja3KwMT9l+XaEnYWCYtEk9d1rcesindeO04wt0stVwoGYcOJKnep9QABlLnb7fXeR+JwujV+3BfsAQR99T4Bcm94+OBj6cMmb5X+4OHwosGIaU69HfSszWIXc7OXvfSGJw0sijeUMcQ/mcAVW3z7tQGZFZFgghkdKJ0luoQp+K7ThCX+NuqGTXb0rVqkN21L1VBFbAussIgEdsdldKyjAHXsYWnQQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3lJUlhONGJKQjlVZlEzNW43QVZpTU9RVVY4VlRUS25tM3RHVmVjazJVV0p6?=
 =?utf-8?B?Z2hSdGhsTWhjSVVURFVjOVBMaEhpeUhsTmdkQURvZ1dKNGR4dDdqd1diZmRD?=
 =?utf-8?B?S3RUVTRzS1hrNTdoWS8zWmt1WlhnY0FMdm9sdEkvRWdVdnFFdTV5WTFFYzVk?=
 =?utf-8?B?dTl2bHo4S2grZWZmVXZlZ05LT3E1NVQvRWdwTTJiYnlBNzlLM3RmLzArd0hk?=
 =?utf-8?B?ejlJU0liTmljWFBka3duT0EzQVJYeEJTMzNVZ0RiMUF4bG5NdisxbVBiV0VJ?=
 =?utf-8?B?Rk5RUTVPQnFKSmNWZStwSi84MWYzUVBnUkZlOFpSQUpFTkJGQ2hOUmRtTm1M?=
 =?utf-8?B?dEhvNjZXYmg0QWZTeHBpdlhpMlNkb0w2ZkMwN043dU9zSG5DOUZHQllTek5t?=
 =?utf-8?B?ditjdUw0K1hGM1lxb0NsNGZTczRPTDA1MjFoNC9nUUoxZytjeGdTTjNMNXBF?=
 =?utf-8?B?ZVhDZDNKc0hQbDN3c2dsa1BjVWpLQTExTkZnbzhmVlBvZ2U2bnBNc1JPR3Y4?=
 =?utf-8?B?TUJ6T3dEMkNWUDh0VGVtUmUxeG51a3lteEJEVUk3Nk1DZGNJdGVUNVYvUVVB?=
 =?utf-8?B?VXNZKzBNS1p6U2lwMXVpc3lFWWVoWDdRK1BtM3lpeUJ3RDlPNXBUWDlBSVBo?=
 =?utf-8?B?V3RZT0l1UG43bXB4MEkzQW1TWW5EdDNrZFd4cmp0OFVCeWFSaVpyNTF1NmpE?=
 =?utf-8?B?cGo1SDhwMzlCbVJGdnVnYWJEZkpOcjA4R3RacHlPSDVwbFRidTNHcTRyZEdK?=
 =?utf-8?B?RHRxK2dMOFpRRmYwNDlSVjRnNlBpOGtWbnhaK3NDTDUvRU1WdWxyMWV4T2hv?=
 =?utf-8?B?ZkUwSHQwWlgxYXZXSHVuMGpVN09WaXFYQURUOUVCT3ZtYlJ4WThrbm9DTGdx?=
 =?utf-8?B?MmFmc0swdU5DLzA3a3J0WU12KzVYaCtkZCt6V1VrUGg2RnJsaWVIZVg1b2Yx?=
 =?utf-8?B?eWJRVXlRU1B2YjRJOWtjazA0M08yejZtd0pYNG5kanAvWE45cWk2VEg4dnM5?=
 =?utf-8?B?UXkrWHExT3o4c0FJKytuK0pGa3UxZ3FKZEwvZTVjQ3p5NHc3RzBPZ0pZQ1Nu?=
 =?utf-8?B?bG0wZFVkODBqUloxejZTaGN2aU52Y3BndVhOQlFadjBlV0wyZE5qZjZWREhm?=
 =?utf-8?B?VjgvdlpTeHdiSzhxb29BM3VXakZlMllKcjZmc2kwOExZaUxVbjRsUGZYT2U0?=
 =?utf-8?B?QVFQejg2eUV2OHNkREsxQ0ptTGw1dHRJWmVDSmM5RzRNK2xYdVBQYTVmS1po?=
 =?utf-8?B?RFlJL3RLR0xMb2J5Ui9SQzZYREZ1RExaQ1hDYTN3QTJLQ1AramtnNEE1VDBn?=
 =?utf-8?B?dEttMGZFdVRCalM4dm9GcjBvSGZveFgyK2d0cWhIZVdMZlpNcDNXRHZwSzBu?=
 =?utf-8?B?MGdpbTlMRnUzL3p6M1pIVHozT3hlWFE4ZjlCaE1xenhPVlJ5Y2NZZW8zdytq?=
 =?utf-8?B?TzFBMjJubzdaRmF2MnhCQ3NWQWwwWmZBaVBwMUlmWXUzc1hKNHYyQmhNZStt?=
 =?utf-8?B?VDdOK3RRcHRiWEF3aTM2WWhUWFpXbm5NdTRvNUxBVS92cGgvSU8zZXF6dzB2?=
 =?utf-8?B?d1RPcTZjZVRrNTR6bUUxSDVHYkoyVUR3TStrYTVDM1RnUi9FQlNwZDVMaUJW?=
 =?utf-8?B?Z0xZQzNkN3FxMDNxVi9mVVJJc1RlZnlwMmF1TEQ2NjkrSWJ2UHZVb0xqK3VJ?=
 =?utf-8?B?SVRJTy9oS1IvV0JYc3ZJalU0ZUtadUJ6UlQ3OGZwZ1cxM3lYWHROeHllN1RF?=
 =?utf-8?B?K1NaOWEzUi9SaEU4alljQ2JKeDF6L3R4NWlCRTM0Q3oxWStncDZNTjZDWVVs?=
 =?utf-8?B?TDBFcDZsZU5teVlPYWJpNjRhR3RUMUVGdEFNMzdrN3ZGQUhJUjZIWnRaVE9q?=
 =?utf-8?B?cW9ZR1k0ajZWZVluc1ZJajRwRXlWb2N4blBYZmkyd2ZyaWtwQWk1Zi85S0Fq?=
 =?utf-8?B?Z0kzUnc2SUV3ZnVBL1pBM2JJNFl4TWNMU2Q3OEtWVU5Cb3N3ZUZVRUh3bFph?=
 =?utf-8?B?NTdSM0QrUlZwOFN5eWlMRVJwcUR0Tkhvck1nY0VYZm4rYlVzTmx2RkhyRSs4?=
 =?utf-8?B?bysxb2hkZzdhaHN5RTZrK3hKQ1dwL1JtNmxpcjIrOVdBdFk4aTZXSE1TSk14?=
 =?utf-8?B?ano3bkxMRHo2SXpJRkZvRGdJaUtzRXM3Qld6Y0RNU1J5WnFZS2xub0Fmb05z?=
 =?utf-8?B?VHdLc1J1SjRGNmsyNzV5enVQUWNsdFdDN1lMeXhKa1JvTlZWMkJSTlhxVzhh?=
 =?utf-8?B?NGcvYzJOVWtETXBXMGM4bGVtdjVEZ01Makw5OHMrWERuQ0hGbUtvck5DcVVV?=
 =?utf-8?B?Qm5RdzBSaEdKZnk3b1A1WmlLeDhoNEJLUW9pTE15c3pQMGp2SGtVL3NrTG04?=
 =?utf-8?Q?d6lRvPwk9rx8rQfE=3D?=
X-Exchange-RoutingPolicyChecked: ndVzuuHwRY2zgCtoLf363bsN8KQdKXDydMnS4mhfu+0ornEeT5ky9yI2eueYzR4upGIyUPUpSXAZQBelLYmL+6v3Vbmlmq5xxmO1p63sXhMizEWk968WEOuIsqjCUJUbSRgBOX+c/tefb/gqCIg5Ll1UWEhTkC1Tm4EMsPzCn3OCO50x4s4nORUsV0E83ncPtHq+cEm20rGMBJ6G5fuP2hVTtekoyEk/RmP/8MeLEuOxhp5XUARreCFdSTpp8cFAMLEQ2dizspaOpPcjW1r+k2NMga6xLQMcS+8Lf0ae3z+bYQiU55gxwuj15Mc00a2HAOQUSFoq0nQ7QJOQuOmgGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4d43de-4b2b-49ae-4631-08dedd43b65a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:53:22.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xnv680+eJ6g2cnTm3BD9D4vMZWZbY6pjTCU85JIus+0UuAAHREaHPiUuB4s3TpJaoUV1GbKlYb2XoO6SPKw9+3Uyg/isu5frjOHF6138FLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF99D0888FA
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> The intel_pmt module should only be pinned while the resctrl file system
> is mounted.
> 
> Add hooks for every mount/unmount of the resctrl file system so that
> architecture code can increment the intel_pmt module reference count on
> mount and decrement on unmount.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

> @@ -3168,6 +3167,8 @@ static void resctrl_unmount(void)
>  	resctrl_mounted = false;
>  	mutex_unlock(&rdtgroup_mutex);
>  	cpus_read_unlock();
> +
> +	resctrl_arch_unmount();
>  }
>  
>  static int rdt_get_tree(struct fs_context *fc)
> @@ -3179,7 +3180,7 @@ static int rdt_get_tree(struct fs_context *fc)
>  	struct rdt_resource *r;
>  	int ret;
>  
> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> +	resctrl_arch_pre_mount();
>  
>  	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
> @@ -3318,6 +3319,9 @@ static int rdt_get_tree(struct fs_context *fc)
>  out:
>  	mutex_unlock(&rdtgroup_mutex);
>  	cpus_read_unlock();
> +
> +	resctrl_arch_unmount();
> +
>  	return ret;
>  }
>  

rdt_get_tree() jumps to "out" if resctrl is already mounted - in this scenario
resctrl fs is mounted and the telemetry events exposed to user space. Above would
cause telemetry to be yanked from underneath an existing mount?

Reinette

